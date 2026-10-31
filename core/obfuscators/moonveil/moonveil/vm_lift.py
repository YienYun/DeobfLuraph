"""Symbolic Bytecode VM Lifter for MoonVeil 2.0.x & 2.1.x Virtualized Scripts.

Instead of brittle per-opcode regexes (which break under MoonVeil's per-opcode
operand biases and fused polymorphic superinstructions), this module:
  1. Extracts the deserialized prototype tree and VM capture bindings in a
     strictly pure, isolated Luau sandbox (stopping BEFORE Instruction 1 of the
     virtualized payload ever executes).
  2. Decodes the VM stepper / opcode handlers statically into CFG basic blocks.
  3. Symbolically steps each concrete VM instruction `C = proto.code[pc]`
     through the stepper: concrete opcodes & arithmetic biases evaluate to exact
     register indices and jump targets, superinstructions decompose naturally
     into sequential Lua AST statements, and symbolic conditions fork cleanly
     into `(true_target_pc, false_target_pc)` CFG edges.
  4. Feeds every lifted prototype CFG into `Structurer` + `beautify.py` to emit
     clean, structured, human-readable Lua source code with `for ... in` loops,
     folded expressions, lexical closures, and semantic variable names.
"""

from __future__ import annotations

import copy
import json
import math
import os
import re
import subprocess
import tempfile
from dataclasses import dataclass, field
from pathlib import Path
from typing import Any

from .front import Unsupported, lua_bytes, normalize, parse, quote, walk
from .staticlua import Evaluator
from . import decoder as mv_decoder
from .cfg import build_graph
from .pipeline import clean, clean_body
from .structure import Structurer
from .beautify import (
    _AlphaRenamer,
    _desugar_block_recursive,
    _inject_residual_shims,
    _optimize_all_functions,
    _place_local_declarations,
    _subst_ident_in_block,
    assign_readable_names,
    format_block,
    format_expr,
    normalize_cf_deep,
    reconstruct_for_in_loops,
    reconstruct_for_numeric_loops,
    unbox_cells,
    isolate_cell_creations,
)


ROOT_DIR = next(
    (p for p in Path(__file__).resolve().parents if (p / "deob.js").is_file()),
    Path(__file__).resolve().parents[4],
)
LUAU_BIN = ROOT_DIR / "bin" / "luau"
KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for",
    "function", "if", "in", "local", "nil", "not", "or", "repeat",
    "return", "then", "true", "until", "while",
}


# ---------------------------------------------------------------------------
# AST Construction Helpers
# ---------------------------------------------------------------------------

def _ident(name: str) -> dict:
    return {"type": "Identifier", "name": name}


def _lit(val: Any) -> dict:
    if val is None:
        return {"type": "NilLiteral", "value": None, "raw": "nil"}
    if isinstance(val, bool):
        return {"type": "BooleanLiteral", "value": val, "raw": "true" if val else "false"}
    if isinstance(val, (int, float)):
        if val < 0:
            pos = abs(val)
            iv = int(pos) if pos == int(pos) and pos < 1e18 else pos
            return {
                "type": "UnaryExpression",
                "operator": "-",
                "argument": {"type": "NumericLiteral", "value": iv, "raw": str(iv)},
                "prefix": True,
            }
        iv = int(val) if val == int(val) and val < 1e18 else val
        return {"type": "NumericLiteral", "value": iv, "raw": str(iv)}
    if isinstance(val, (bytes, str)):
        s = val.decode("latin1") if isinstance(val, bytes) else val
        return {"type": "StringLiteral", "value": s, "raw": quote(s.encode("latin1"))}
    raise Unsupported(f"Cannot convert {type(val)} (role={getattr(val, 'role', None)!r}) to AST literal")


def _member_or_index(base_ast: dict, key_val: Any) -> dict:
    if isinstance(key_val, (bytes, str)):
        ks = key_val.decode("latin1") if isinstance(key_val, bytes) else key_val
        if re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", ks) and ks not in KEYWORDS:
            return {
                "type": "MemberExpression",
                "base": base_ast,
                "indexer": ".",
                "identifier": _ident(ks),
            }
    return {
        "type": "IndexExpression",
        "base": base_ast,
        "index": to_ast(key_val),
    }


@dataclass
class Sym:
    """Symbolic Lua AST expression."""
    ast: dict


@dataclass
class SymTable:
    """Freshly allocated `{}` table before or during field initialization."""
    reg_ast: dict | None = None
    fields: list[tuple[Any, Any]] = field(default_factory=list)


@dataclass
class VarTop:
    """Represents variable top-of-stack `v = base_reg + count - 1` produced by MULTRET/VARARG."""
    base_reg: int
    tail_ast: dict


@dataclass
class MultiRetCall:
    """Return tuple from calling a symbolic function `call_ast`."""
    call_ast: dict


@dataclass
class RetPack:
    """Packed return table produced by `ga[3](MultiRetCall)` or `table.pack(MultiRetCall)`."""
    call_ast: dict
    last_dst: int | None = None


@dataclass
class RetCount:
    """Symbolic return count produced by `ga[3](MultiRetCall)` (only compared or used in `v = N + ka - 1`)."""
    call_ast: dict


@dataclass
class OpenUpvalCell:
    """VM open-upvalue cell `{[2] = W, [3] = reg_idx}`."""
    reg_idx: int


@dataclass
class OuterUpvalCell:
    """Enclosing closure upvalue cell `{[2] = outer, [3] = up_idx}`."""
    up_idx: int


@dataclass
class EnvSentinel:
    """Represents `getfenv()` global environment table."""


@dataclass
class VarargTable:
    """Represents `ia[51234]` vararg list."""


@dataclass
class VarargCount:
    """Represents `ia[50272]` vararg count."""


def is_symbolic(v: Any) -> bool:
    return isinstance(
        v,
        (
            Sym,
            SymTable,
            VarTop,
            MultiRetCall,
            RetPack,
            RetCount,
            EnvSentinel,
            VarargTable,
            VarargCount,
        ),
    )


def to_ast(v: Any) -> dict:
    if isinstance(v, Sym):
        return copy.deepcopy(v.ast)
    if isinstance(v, SymTable):
        if v.reg_ast is not None:
            return copy.deepcopy(v.reg_ast)
        return {"type": "TableConstructorExpression", "fields": []}
    if isinstance(v, MultiRetCall):
        return copy.deepcopy(v.call_ast)
    if isinstance(v, EnvSentinel):
        return {"type": "CallExpression", "base": _ident("getfenv"), "arguments": []}
    return _lit(v)


# ---------------------------------------------------------------------------
# Stage 1: Sandboxed Luau Prototype & Capture Layout Extractor
# ---------------------------------------------------------------------------

def _extract_20x_vm_bundle(raw: bytes) -> dict | None:
    """Extract prototype tree & `ga` helper roles for MoonVeil 2.0.x VM scripts."""
    if not LUAU_BIN.is_file():
        return None
    text = raw.decode("latin1")
    # Locate outer `return({...}):<Entry>(...)`
    m_ret = re.search(r"return\s*\(\s*\{", text)
    m_call = re.search(r"\):([A-Za-z_][A-Za-z_0-9]*)\(([^\)]*)\)\s*$", text)
    if not m_ret or not m_call:
        return None
    entry_method = m_call.group(1)
    call_args = m_call.group(2).strip()
    tbl_src = text[text.find("{", m_ret.start()) : m_call.start() + 1]
    if tbl_src.endswith(")"):
        tbl_src = tbl_src[:-1]

    # Build a locked-down pure Luau script (no io/os/debug/loadstring) that intercepts
    # the VM interpreter closure (identified structurally by capturing a prototype table
    # whose instruction list holds tables of numeric/string operands).
    probe = f"""
local pure_env
local ENV_TAG = setmetatable({{ __mv_env = true }}, {{
    __index = function(_, k)
        return pure_env[k]
    end,
}})
pure_env = {{
    string = string,
    table = table,
    bit32 = bit32,
    math = math,
    select = select,
    type = type,
    tonumber = tonumber,
    tostring = tostring,
    unpack = unpack or table.unpack,
    pairs = pairs,
    ipairs = ipairs,
    next = next,
    pcall = pcall,
    xpcall = xpcall,
    error = error,
    assert = assert,
    setmetatable = setmetatable,
    getmetatable = getmetatable,
    rawget = rawget,
    rawset = rawset,
    rawequal = rawequal,
    getfenv = function() return ENV_TAG end,
    setfenv = function() end,
}}

local function unbox20(c)
    if type(c) == "table" and rawget(c, 3) == 1 and rawget(c, 2) == c then
        return rawget(c, 1), true
    end
    return c, false
end

local found_export = nil
local found_ga = nil
local found_proto = nil
local found_code_key = nil

local function find_proto_in_up(up)
    if type(up) ~= "table" then return nil, nil end
    for idx, item in pairs(up) do
        local v = unbox20(item)
        if type(v) == "table" then
            for pk, pv in pairs(v) do
                if type(pk) == "number" and type(pv) == "table" and #pv >= 1 and type(pv[1]) == "table" then
                    local nnum = 0
                    for ik in pairs(pv[1]) do
                        if type(ik) == "number" then nnum += 1 end
                    end
                    if nnum >= 4 then
                        return v, pk
                    end
                end
            end
        end
    end
    return nil, nil
end

local loader_fn = function()
    return {tbl_src}
end
setfenv(loader_fn, pure_env)
local ctx = loader_fn()

local function wrap_ctx_functions()
    for k, fn in pairs(ctx) do
        if type(fn) == "function" and k ~= "{entry_method}" then
            ctx[k] = function(...)
                local self, up = ...
                local p, ck = find_proto_in_up(up)
                if p and not found_proto then
                    found_export = tostring(k)
                    found_ga = up
                    found_proto = p
                    found_code_key = ck
                    return function(...)
                        error("__MV_STOP_BEFORE_EXEC__")
                    end
                end
                return fn(...)
            end
        end
    end
end

wrap_ctx_functions()
local ok, err = pcall(function()
    return ctx:{entry_method}({call_args if call_args != "..." else ""})
end)

if not found_proto then
    error("NO_PROTO")
end

local function esc_str(s)
    local out = {{}}
    for i = 1, #s do
        local b = string.byte(s, i)
        if b == 34 then table.insert(out, "\\\\\\"")
        elseif b == 92 then table.insert(out, "\\\\\\\\")
        elseif b >= 32 and b <= 126 then table.insert(out, string.char(b))
        else table.insert(out, string.format("\\\\u%04x", b)) end
    end
    return "\\"" .. table.concat(out) .. "\\""
end

local function to_json(v)
    local t = type(v)
    if v == nil then return "null"
    elseif t == "boolean" then return v and "true" or "false"
    elseif t == "number" then
        if v ~= v or v == math.huge or v == -math.huge then return "0" end
        return tostring(v)
    elseif t == "string" then return esc_str(v)
    elseif t == "table" then
        local n = #v
        local cnt = 0
        for _ in pairs(v) do cnt += 1 end
        if cnt == n and n > 0 then
            local parts = {{}}
            for i = 1, n do parts[i] = to_json(v[i]) end
            return "[" .. table.concat(parts, ",") .. "]"
        else
            local parts = {{}}
            for k, val in pairs(v) do
                table.insert(parts, esc_str(tostring(k)) .. ":" .. to_json(val))
            end
            return "{{" .. table.concat(parts, ",") .. "}}"
        end
    end
    return "null"
end

local ga_roles = {{}}
for idx, raw_cell in pairs(found_ga) do
    local v = unbox20(raw_cell)
    local role = "unknown"
    if v == nil then role = "upvals"
    elseif v == ENV_TAG then role = "env"
    elseif v == found_proto then role = "proto"
    elseif v == pairs then role = "pairs"
    elseif v == ipairs then role = "ipairs"
    elseif v == type then role = "type"
    elseif v == setmetatable then role = "setmetatable"
    elseif v == getmetatable then role = "getmetatable"
    elseif v == bit32.band then role = "bit32.band"
    elseif v == bit32.bxor then role = "bit32.bxor"
    elseif v == bit32.bor then role = "bit32.bor"
    elseif v == string.byte then role = "string.byte"
    elseif v == string.char then role = "string.char"
    elseif v == string.gmatch then role = "string.gmatch"
    elseif v == table.create then role = "table.create"
    elseif v == table.move then role = "table.move"
    elseif type(v) == "table" and rawget(v, "__mode") ~= nil then role = "weak_mt"
    elseif type(v) == "table" and rawget(v, 3) == 1 then role = "upvals"
    elseif type(v) == "table" then role = "upvals"
    elseif type(v) == "function" then role = "fn"
    end
    ga_roles[tostring(idx)] = role
end

print(to_json({{
    vm_export = found_export,
    code_key = tostring(found_code_key),
    ga_roles = ga_roles,
    root_proto = found_proto,
}}))
"""
    with tempfile.NamedTemporaryFile("w", suffix=".luau", encoding="latin1", delete=False) as tf:
        tf.write(probe)
        tf_path = tf.name
    try:
        proc = subprocess.run([str(LUAU_BIN), tf_path], capture_output=True, text=True, timeout=25)
        if proc.returncode != 0 or not proc.stdout.strip():
            return None
        return json.loads(proc.stdout)
    except Exception:
        return None
    finally:
        try:
            os.unlink(tf_path)
        except OSError:
            pass


# ---------------------------------------------------------------------------
# Stage 2 & 3: Symbolic Stepper over MoonVeil 2.0.x CFF VM Interpreter `G`
# ---------------------------------------------------------------------------

class _ConcreteTable:
    def __init__(self, init_dict: dict | None = None):
        self.fields: dict[Any, Any] = dict(init_dict or {})

    def get(self, k: Any) -> Any:
        if isinstance(k, float) and k == int(k):
            k = int(k)
        return self.fields.get(k)

    def put(self, k: Any, v: Any):
        if isinstance(k, float) and k == int(k):
            k = int(k)
        if v is None:
            self.fields.pop(k, None)
        else:
            self.fields[k] = v


class _RegBank:
    """Symbolic VM stack `W`."""
    def __init__(self, prefix: str = "r_"):
        self.prefix = prefix
        self.temp_tables: dict[int, SymTable] = {}

    def reg_name(self, idx: int) -> str:
        return f"{self.prefix}{idx}"

    def read(self, idx: int) -> Any:
        return Sym(_ident(self.reg_name(idx)))

    def write(self, idx: int, val: Any, stmts: list[dict]):
        r_nm = self.reg_name(idx)
        r_id = _ident(r_nm)
        if isinstance(val, _ConcreteTable) and not val.fields:
            st = SymTable(reg_ast=r_id)
            self.temp_tables[idx] = st
            stmts.append({
                "type": "AssignmentStatement",
                "variables": [r_id],
                "init": [{"type": "TableConstructorExpression", "fields": []}],
            })
            return
        if isinstance(val, SymTable) and val.reg_ast is None:
            val.reg_ast = r_id
            self.temp_tables[idx] = st = val
            stmts.append({
                "type": "AssignmentStatement",
                "variables": [r_id],
                "init": [{"type": "TableConstructorExpression", "fields": []}],
            })
            return
        rhs = to_ast(val)
        # Skip self-assignment `r_k = r_k`
        if rhs.get("type") == "Identifier" and rhs["name"] == r_nm:
            return
        stmts.append({
            "type": "AssignmentStatement",
            "variables": [r_id],
            "init": [rhs],
        })


class _UpvalBank:
    def __init__(self, n_upvals: int):
        self.cells = {i: OuterUpvalCell(i) for i in range(1, n_upvals + 1)}

    def get_cell(self, idx: int) -> OuterUpvalCell:
        idx = int(idx)
        if idx not in self.cells:
            self.cells[idx] = OuterUpvalCell(idx)
        return self.cells[idx]


def _find_dispatch_state(gr: dict) -> tuple[int, str, str]:
    """Identify the instruction-fetch state (e.g. `211`), PC var (`O`), and instr var (`C`)."""
    in_deg: dict[int, int] = {}
    for nd in gr["nodes"].values():
        tm = nd["term"]
        if "goto" in tm:
            in_deg[tm["goto"]] = in_deg.get(tm["goto"], 0) + 1
        elif "yes" in tm:
            in_deg[tm["yes"]["goto"]] = in_deg.get(tm["yes"]["goto"], 0) + 1
            in_deg[tm["no"]["goto"]] = in_deg.get(tm["no"]["goto"], 0) + 1
    dispatch_state = max(in_deg, key=lambda k: in_deg[k])
    # Extract `C = o[O]` and `O = O + ...` from `gr["nodes"][dispatch_state]["stmts"]`
    pc_var = None
    ins_var = None
    for s in gr["nodes"][dispatch_state]["stmts"]:
        if s["type"] == "AssignmentStatement":
            for v, r in zip(s["variables"], s["init"]):
                if r["type"] == "IndexExpression" and r["base"]["type"] == "Identifier" and r["index"]["type"] == "Identifier":
                    ins_var = v["name"]
                    pc_var = r["index"]["name"]
                    break
    if not pc_var or not ins_var:
        raise Unsupported("Could not identify PC and instruction variables in VM dispatch state")
    return dispatch_state, pc_var, ins_var


def _identify_proto_keys(root_proto: dict, code_key: str) -> dict[str, str]:
    """Identify `protos_key`, `params_key`, `vararg_key`, `stack_key`, and `opcode_key` structurally."""
    protos_key = None
    for k, v in root_proto.items():
        if k == code_key:
            continue
        if isinstance(v, list) and v and isinstance(v[0], dict) and code_key in v[0]:
            protos_key = k
            break
    # If root_proto happens to have 0 children, check empty list keys
    if protos_key is None:
        list_keys = [k for k, v in root_proto.items() if k != code_key and isinstance(v, list)]
        protos_key = list_keys[0] if list_keys else ""
    return {"code_key": code_key, "protos_key": protos_key}


@dataclass
class _ChildProtoRef:
    idx: int


@dataclass
class _DeferredClosure:
    ch_idx: int
    cap_tbl: Any


class _BuiltinTag:
    def __init__(self, role: str):
        self.role = role


def _decode_with_loader_skip(raw: bytes):
    orig_stmt = Evaluator.statement

    def safe_stmt(self, s, env):
        try:
            return orig_stmt(self, s, env)
        except Unsupported:
            return None

    Evaluator.statement = safe_stmt
    try:
        return mv_decoder.decode(raw)
    finally:
        Evaluator.statement = orig_stmt


def lift_moonveil_20x_vm(raw: bytes) -> bytes | None:
    bundle = _extract_20x_vm_bundle(raw)
    if bundle is None:
        return None

    vm_export = bundle["vm_export"]
    code_key = bundle["code_key"]
    ga_roles = {int(k): v for k, v in bundle["ga_roles"].items()}
    root_proto = bundle["root_proto"]

    decoded = _decode_with_loader_skip(raw)
    if vm_export not in decoded.exports:
        return None

    # Identify `ctx` helper roles (`b`=iter, `c`=pack, `d`=unpack, `e`=store_multi) AND `C`'s `ga` fns!
    ctx_outer = decoded.exports[vm_export]
    ctx_self_name = ctx_outer["parameters"][0]["name"]
    ga_param_name = ctx_outer["parameters"][1]["name"]
    g_inner = clean(ctx_outer["body"][0]["arguments"][0])
    w_param_name = g_inner["parameters"][0]["name"]
    ia_param_name = g_inner["parameters"][1]["name"] if len(g_inner["parameters"]) > 1 else "__ia__"

    # Map `ctx.<name>` helper roles (`pack`, `unpack`, `iter`, `move_multi`)
    ctx_roles: dict[str, str] = {}
    for ename, enode in decoded.exports.items():
        etxt = format_expr(clean(enode), 0)
        if 'select("#", ...)' in etxt and "{...}" in etxt:
            ctx_roles[ename] = "pack"
        elif "__iter" in etxt:
            ctx_roles[ename] = "iter"
        elif "[1], 1," in etxt or "(j > k)" in etxt:
            ctx_roles[ename] = "unpack"
        elif "for i = 1," in etxt and "select(\"#\", ...)" in etxt:
            ctx_roles[ename] = "store_varargs"

    # Distinguish the 3 Lua `fn` slots in `ga_roles` (`pack_ret` F, `closure_ctor` C, `unpack_slice` D)
    # by checking the export that constructs `vm_export` (e.g. `C` calls `d:G({...})`)!
    for ename, enode in decoded.exports.items():
        cleaned_e = clean(enode)
        for n in walk(cleaned_e):
            if (
                isinstance(n, dict)
                and n.get("type") in ("CallExpression", "TableCallExpression")
                and n["base"].get("type") == "MemberExpression"
                and n["base"]["identifier"]["name"] == vm_export
            ):
                arg_tbl = n["arguments"] if n["type"] == "TableCallExpression" else n["arguments"][0]
                # Map local variables assigned from `d:<Helper>(...)` in `cleaned_e`!
                local_src: dict[str, str] = {}
                for st in walk(cleaned_e):
                    if isinstance(st, dict) and st.get("type") == "AssignmentStatement":
                        for lv, lr in zip(st["variables"], st["init"]):
                            cal = lr
                            if cal.get("type") in ("CallExpression", "TableCallExpression") and cal["base"].get("type") == "MemberExpression":
                                hnm = cal["base"]["identifier"]["name"]
                                htxt = format_expr(clean(decoded.exports.get(hnm, {})), 0) if hnm in decoded.exports else ""
                                root_nm = lv["name"] if lv["type"] == "Identifier" else (lv["base"]["name"] if lv.get("type") == "MemberExpression" and lv["base"]["type"] == "Identifier" else None)
                                if root_nm:
                                    if '"#"' in htxt:
                                        local_src[root_nm] = "pack_ret"
                                    elif "(e > j)" in htxt or "(e + g)" in htxt:
                                        local_src[root_nm] = "unpack_slice"
                for slot_idx, fld in enumerate(arg_tbl["fields"], start=1):
                    fv = fld["value"]
                    if fv["type"] == "Identifier" and fv["name"] in local_src:
                        ga_roles[slot_idx] = local_src[fv["name"]]
                # Any remaining `"fn"` in `ga_roles` is `closure_ctor`!
                for k_idx, r_val in list(ga_roles.items()):
                    if r_val == "fn":
                        ga_roles[k_idx] = "closure_ctor"

    gr = build_graph(g_inner)
    dispatch_state, pc_var, ins_var = _find_dispatch_state(gr)
    pkeys = _identify_proto_keys(root_proto, code_key)
    protos_key = pkeys["protos_key"]

    # Identify `params_key` from export `E` (or fallback: check `m[<key>]` in exports!)
    params_key = None
    vararg_tbl_key = None
    vararg_cnt_key = None
    for ename, enode in decoded.exports.items():
        if ename == vm_export:
            continue
        for n in walk(clean(enode)):
            if isinstance(n, dict) and n.get("type") == "IndexExpression" and n["index"].get("type") == "NumericLiteral":
                kv = str(int(n["index"]["value"]))
                if kv in root_proto and kv != code_key and kv != protos_key:
                    # In `E`, `m[59900]` appears >= 3 times (param count), while `j[20109]` appears once (`table.create(max_stack)`)!
                    pass
    key_freq: dict[str, int] = {}
    for ename, enode in decoded.exports.items():
        if ename == vm_export:
            continue
        for n in walk(clean(enode)):
            if isinstance(n, dict) and n.get("type") == "IndexExpression" and n["index"].get("type") == "NumericLiteral":
                kv = str(int(n["index"]["value"]))
                key_freq[kv] = key_freq.get(kv, 0) + 1
    proto_scalar_keys = [k for k, v in root_proto.items() if isinstance(v, (int, float))]
    # `params_key` has highest frequency in `E` (>= 3); `stack_key` has frequency 1 in `E`
    by_freq = sorted([k for k in proto_scalar_keys if key_freq.get(k, 0) > 0], key=lambda k: -key_freq[k])
    if by_freq:
        params_key = by_freq[0]
    # Also find `ia` keys (`i[51234] = {}`, `i[50272] = 0`) in `E`:
    for ename, enode in decoded.exports.items():
        if ename == vm_export:
            continue
        for n in walk(clean(enode)):
            if isinstance(n, dict) and n.get("type") == "AssignmentStatement":
                for lv, lr in zip(n["variables"], n["init"]):
                    if lv.get("type") == "IndexExpression" and lv["index"].get("type") == "NumericLiteral":
                        ik = int(lv["index"]["value"])
                        if lr.get("type") == "NumericLiteral" and lr["value"] == 0:
                            vararg_cnt_key = ik
                        elif lr.get("type") == "Identifier":
                            vararg_tbl_key = ik

    proto_uid = [0]

    # Lift any prototype recursively!
    def lift_proto(proto: dict) -> dict:
        proto_uid[0] += 1
        p_id = proto_uid[0]
        p_prefix = f"__p{p_id}_r_"
        cap_prefix = f"__p{p_id}_cap_"

        def rn(idx: int) -> str:
            return f"{p_prefix}{idx}"

        raw_code = proto.get(code_key, [])
        # Convert instruction dicts so integer keys map to int/float/str/bool/None
        code: list[dict[int, Any]] = []
        for ins in raw_code:
            c_ins: dict[int, Any] = {}
            for k, v in ins.items():
                ik = int(k)
                c_ins[ik] = v
            code.append(c_ins)

        raw_children = proto.get(protos_key, []) if protos_key else []
        if isinstance(raw_children, dict):
            child_protos = [raw_children[k] for k in sorted(raw_children.keys(), key=lambda x: int(x))]
            child_idx_base = min((int(k) for k in raw_children.keys()), default=1)
        else:
            child_protos = list(raw_children)
            child_idx_base = 1
        n_params = int(proto.get(params_key, 0)) if params_key and params_key in proto else 0

        # Run prelude (`gr["start"] -> ... -> dispatch_state`) once to capture initial VM locals!
        W_bank = _RegBank(p_prefix)
        up_bank = _UpvalBank(64)
        base_locals: dict[str, Any] = {
            ctx_self_name: _BuiltinTag("ctx"),
            ga_param_name: _BuiltinTag("ga"),
            w_param_name: W_bank,
            ia_param_name: _ConcreteTable({
                (vararg_tbl_key or 1): VarargTable(),
                (vararg_cnt_key or 2): VarargCount(),
            }),
        }
        proto_tbl = _ConcreteTable({
            int(code_key): _ConcreteTable({idx + 1: _ConcreteTable(ins) for idx, ins in enumerate(code)}),
        })
        if protos_key and protos_key.isdigit():
            proto_tbl.put(int(protos_key), _ConcreteTable({idx + child_idx_base: _ChildProtoRef(idx) for idx in range(len(child_protos))}))
        for pk, pv in proto.items():
            if pk not in (code_key, protos_key) and pk.isdigit():
                proto_tbl.put(int(pk), pv if not isinstance(pv, list) else _ConcreteTable())

        def eval_expr_sym(node: dict, env: dict[str, Any], stmts: list[dict], multi: bool = False) -> Any:
            nt = node["type"]
            if nt == "NumericLiteral":
                v = node["value"]
                return int(v) if v == int(v) else float(v)
            if nt == "StringLiteral":
                return node["value"]
            if nt == "BooleanLiteral":
                return bool(node["value"])
            if nt == "NilLiteral":
                return None
            if nt == "Identifier":
                return env.get(node["name"])
            if nt == "TableConstructorExpression":
                ct = _ConcreteTable()
                arr_i = 1
                for fld in node["fields"]:
                    if fld["type"] == "TableValue":
                        ct.put(arr_i, eval_expr_sym(fld["value"], env, stmts))
                        arr_i += 1
                    elif fld["type"] == "TableKeyString":
                        ct.put(fld["key"]["name"], eval_expr_sym(fld["value"], env, stmts))
                    else:
                        ct.put(eval_expr_sym(fld["key"], env, stmts), eval_expr_sym(fld["value"], env, stmts))
                return ct
            if nt in ("MemberExpression", "IndexExpression"):
                base = eval_expr_sym(node["base"], env, stmts)
                k = node["identifier"]["name"] if nt == "MemberExpression" else eval_expr_sym(node["index"], env, stmts)
                if isinstance(base, _BuiltinTag) and base.role == "ctx":
                    return _BuiltinTag("ctx." + str(k))
                if isinstance(base, _BuiltinTag) and base.role == "ga":
                    slot = int(k)
                    role = ga_roles.get(slot, "unknown")
                    if role == "proto":
                        return _ConcreteTable({"value": proto_tbl})
                    if role == "env":
                        return _ConcreteTable({"value": EnvSentinel()})
                    if role == "upvals":
                        return _ConcreteTable({"value": up_bank})
                    if role == "weak_mt":
                        return _ConcreteTable({"value": _ConcreteTable({"__mode": "vs"})})
                    return _ConcreteTable({"value": _BuiltinTag(role)})
                if isinstance(base, _ConcreteTable):
                    return base.get(k)
                if isinstance(base, _RegBank):
                    return base.read(int(k))
                if isinstance(base, _UpvalBank):
                    return base.get_cell(int(k))
                if isinstance(base, RetPack):
                    if k == "n":
                        return RetCount(base.call_ast)
                    if k == 1 and base.last_dst is not None:
                        return Sym(_ident(rn(base.last_dst)))
                    return None
                if isinstance(base, OuterUpvalCell):
                    if k in (1, 2):
                        return base
                    if k == 3:
                        return "__VAL__"
                    return Sym(_ident(f"__up_{base.up_idx}"))
                if isinstance(base, OpenUpvalCell):
                    if k in (1, 2):
                        return W_bank
                    if k == 3:
                        return base.reg_idx
                    return Sym(_ident(rn(base.reg_idx)))
                if isinstance(base, EnvSentinel):
                    if isinstance(k, str) and re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", k) and k not in KEYWORDS:
                        return Sym(_ident(k))
                    return Sym(_member_or_index(to_ast(base), k))
                if is_symbolic(base) or is_symbolic(k):
                    return Sym(_member_or_index(to_ast(base), k))
                return None

            if nt == "UnaryExpression":
                op = node["operator"]
                arg = eval_expr_sym(node["argument"], env, stmts)
                if not is_symbolic(arg):
                    if op == "-":
                        v = -arg
                        return int(v) if isinstance(v, float) and v == int(v) else v
                    if op == "not":
                        return not (arg is not None and arg is not False)
                    if op == "#":
                        return len(arg) if isinstance(arg, str) else 0
                return Sym({"type": "UnaryExpression", "operator": op, "argument": to_ast(arg), "prefix": True})

            if nt in ("BinaryExpression", "LogicalExpression"):
                op = node["operator"]
                lv = eval_expr_sym(node["left"], env, stmts)
                if op == "and":
                    if not is_symbolic(lv):
                        return eval_expr_sym(node["right"], env, stmts) if (lv is not None and lv is not False) else lv
                    rv = eval_expr_sym(node["right"], env, stmts)
                    return Sym({"type": "LogicalExpression", "operator": "and", "left": to_ast(lv), "right": to_ast(rv)})
                if op == "or":
                    if not is_symbolic(lv):
                        return lv if (lv is not None and lv is not False) else eval_expr_sym(node["right"], env, stmts)
                    rv = eval_expr_sym(node["right"], env, stmts)
                    return Sym({"type": "LogicalExpression", "operator": "or", "left": to_ast(lv), "right": to_ast(rv)})

                rv = eval_expr_sym(node["right"], env, stmts)
                # VarTop arithmetic (`f = v - N`, `pa = N + ka; v = pa - 1`, `f = (v - N) + 1`)!
                if isinstance(lv, VarTop) and isinstance(rv, (int, float)):
                    if op == "-":
                        return VarTop(lv.base_reg - int(rv), lv.tail_ast)
                    if op == "+":
                        return VarTop(lv.base_reg + int(rv), lv.tail_ast)
                if isinstance(rv, VarTop) and isinstance(lv, (int, float)) and op == "+":
                    return VarTop(int(lv) + rv.base_reg, rv.tail_ast)
                if isinstance(lv, RetCount) and isinstance(rv, (int, float)):
                    if op == "-":
                        return RetCount(lv.call_ast)
                    if op == "+":
                        return RetCount(lv.call_ast)
                if isinstance(rv, RetCount) and isinstance(lv, (int, float)) and op == "+":
                    return VarTop(int(lv), rv.call_ast)
                if isinstance(lv, VarargCount) and isinstance(rv, (int, float)):
                    return VarargCount()
                if isinstance(rv, VarargCount) and isinstance(lv, (int, float)) and op == "+":
                    return VarTop(int(lv), {"type": "VarargLiteral", "value": "...", "raw": "..."})

                if not is_symbolic(lv) and not is_symbolic(rv):
                    if op == "+":
                        res = lv + rv
                    elif op == "-":
                        res = lv - rv
                    elif op == "*":
                        res = lv * rv
                    elif op == "/":
                        res = lv / rv
                    elif op == "%":
                        res = lv % rv
                    elif op == "^":
                        res = lv ** rv
                    elif op == "..":
                        res = str(lv) + str(rv)
                    elif op == "==":
                        return lv == rv
                    elif op == "~=":
                        return lv != rv
                    elif op == "<":
                        return lv < rv
                    elif op == "<=":
                        return lv <= rv
                    elif op == ">":
                        return lv > rv
                    elif op == ">=":
                        return lv >= rv
                    else:
                        raise Unsupported(f"Unknown binary op {op}")
                    if isinstance(res, float) and math.isfinite(res) and res == int(res) and abs(res) < 1e15:
                        return int(res)
                    return res

                return Sym({"type": "BinaryExpression", "operator": op, "left": to_ast(lv), "right": to_ast(rv)})

            if nt in ("CallExpression", "TableCallExpression", "StringCallExpression"):
                fn_v = eval_expr_sym(node["base"], env, stmts)
                raw_args = (
                    node["arguments"]
                    if nt == "CallExpression"
                    else [node["arguments"] if nt == "TableCallExpression" else node["argument"]]
                )
                args: list[Any] = []
                for ai, an in enumerate(raw_args):
                    av = eval_expr_sym(an, env, stmts, multi=(ai == len(raw_args) - 1 and not an.get("inParens")))
                    if isinstance(av, tuple):
                        args.extend(av)
                    else:
                        args.append(av)
                res_tuple = invoke_sym(fn_v, args, env, stmts)
                if multi and not node.get("inParens"):
                    return res_tuple
                return res_tuple[0] if res_tuple else None

            raise Unsupported(f"Unsupported VM stepper expr: {nt}")

        def invoke_sym(fn_v: Any, args: list[Any], env: dict[str, Any], stmts: list[dict]) -> tuple[Any, ...]:
            if isinstance(fn_v, _BuiltinTag):
                r = fn_v.role
                if r.startswith("ctx."):
                    cname = r.split(".", 1)[1]
                    crole = ctx_roles.get(cname)
                    if crole == "pack":
                        return (_ConcreteTable({1: list(args), 2: len(args)}),)
                    if crole == "unpack":
                        packed = args[0]
                        if isinstance(packed, _ConcreteTable):
                            items = packed.get(1)
                            if isinstance(items, list):
                                return tuple(items)
                        return ()
                    if crole == "iter":
                        # Used on `J` (open upvals `{}`) during `CLOSE`, OR in `FORGPREP`
                        if isinstance(args[0], _ConcreteTable):
                            keys = list(args[0].fields.keys())
                            it_state = {"idx": 0, "keys": keys, "tbl": args[0]}
                            return (_BuiltinTag("concrete_next"), it_state, None)
                        return tuple(args[:3])
                if r == "concrete_next":
                    st_d = args[0]
                    if st_d["idx"] >= len(st_d["keys"]):
                        return (None, None)
                    k_next = st_d["keys"][st_d["idx"]]
                    st_d["idx"] += 1
                    return (k_next, st_d["tbl"].get(k_next))
                if r in ("setmetatable", "table.create"):
                    if r == "setmetatable":
                        return (args[0],)
                    return (_ConcreteTable(),)
                if r == "getmetatable":
                    return (None,)
                if r == "type":
                    return (Sym({"type": "CallExpression", "base": _ident("type"), "arguments": [to_ast(args[0])]}),)
                if r == "string.gmatch":
                    # `OP 195` (`FORGPREP`) hashes `type(W[N])` via `string.gmatch(na, ".")`!
                    # Signal special `__FORGPREP__` sentinel so `step_block` shortcuts directly to `__mv_iter__`!
                    raise _ForgprepShortcut()
                if r in ("fn", "unpack_slice", "pack_ret", "closure_ctor"):
                    # Structural dispatch across the 3 Lua VM helper closures (`D`, `C`, `F`):
                    if len(args) == 3 and isinstance(args[0], _RegBank):
                        r = "unpack_slice"
                    elif len(args) == 2 and isinstance(args[0], _ChildProtoRef):
                        r = "closure_ctor"
                    else:
                        r = "pack_ret"
                if r == "unpack_slice":
                    # `D(W, start, stop)`
                    src_tbl, a_idx, b_idx = args[0], int(args[1]), args[2]
                    if isinstance(b_idx, VarTop):
                        # Variable tail `W[a_idx .. b_idx]` where `b_idx = VarTop(N + offset, tail_ast)`!
                        # Note: in `CALL`, `h = N + (v - N) = VarTop(v.base_reg)` and `sa = N + 1`!
                        # In `RETURN`, `pa = (N + ((v - N) + 1)) - 1 = VarTop(v.base_reg)` and `ka = N`!
                        out = [Sym(_ident(rn(k))) for k in range(a_idx, b_idx.base_reg)]
                        out.append(Sym(b_idx.tail_ast))
                        return tuple(out)
                    b_int = int(b_idx)
                    if b_int < a_idx:
                        return ()
                    return tuple(Sym(_ident(rn(k))) for k in range(a_idx, b_int + 1))
                if r == "pack_ret":
                    # `ga[3](MultiRetCall(call_ast))`
                    if len(args) == 1 and isinstance(args[0], MultiRetCall):
                        ca = args[0].call_ast
                        return (RetPack(ca), RetCount(ca))
                    return (RetPack(_lit(None)), 0)
                if r == "table.move":
                    # `table.move(src, a, b, dst_start, dst)`
                    src_m, a_m, b_m, dst_start, dst_m = args[0], int(args[1]), args[2], int(args[3]), args[4]
                    if isinstance(src_m, RetPack) and isinstance(dst_m, _RegBank):
                        src_m.last_dst = dst_start
                        if isinstance(b_m, RetCount):
                            # Variable return `MULTRET`: `v` will be set to `VarTop(dst_start, src_m.call_ast)`!
                            return (dst_m,)
                        cnt = int(b_m) - a_m + 1
                        if cnt <= 0:
                            stmts.append({"type": "CallStatement", "expression": copy.deepcopy(src_m.call_ast)})
                        else:
                            stmts.append({
                                "type": "AssignmentStatement",
                                "variables": [_ident(rn(dst_start + j)) for j in range(cnt)],
                                "init": [copy.deepcopy(src_m.call_ast)],
                            })
                        return (dst_m,)
                    if isinstance(src_m, VarargTable) and isinstance(dst_m, _RegBank):
                        if isinstance(b_m, VarargCount):
                            return (dst_m,)
                        cnt = int(b_m) - a_m + 1
                        if cnt > 0:
                            stmts.append({
                                "type": "AssignmentStatement",
                                "variables": [_ident(rn(dst_start + j)) for j in range(cnt)],
                                "init": [{"type": "VarargLiteral", "value": "...", "raw": "..."}],
                            })
                        return (dst_m,)
                    if isinstance(src_m, _RegBank) and isinstance(dst_m, SymTable):
                        # `SETLIST`: `table.move(W, reg_a, reg_b, dst_idx, tbl)`!
                        tbl_ref = dst_m.reg_ast or _ident(rn(0))
                        if isinstance(b_m, VarTop):
                            for k_i, r_k in enumerate(range(a_m, b_m.base_reg)):
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [{"type": "IndexExpression", "base": copy.deepcopy(tbl_ref), "index": _lit(dst_start + k_i)}],
                                    "init": [_ident(rn(r_k))],
                                })
                            # Variable tail `...` or `f()` into table via `table.insert` or array tail!
                            # If `dst_start == 1` and table was just created empty, replace `r_tbl = {}` with `{r_a, ..., tail}`!
                            if (
                                stmts
                                and stmts[-1 - (b_m.base_reg - a_m) if len(stmts) > (b_m.base_reg - a_m) else 0]["type"] == "AssignmentStatement"
                            ):
                                pass
                            stmts.append({
                                "type": "AssignmentStatement",
                                "variables": [copy.deepcopy(tbl_ref)],
                                "init": [{
                                    "type": "TableConstructorExpression",
                                    "fields": [
                                        {"type": "TableValue", "value": _ident(rn(r_k))}
                                        for r_k in range(a_m, b_m.base_reg)
                                    ] + [{"type": "TableValue", "value": copy.deepcopy(b_m.tail_ast)}],
                                }],
                            })
                        else:
                            for k_i, r_k in enumerate(range(a_m, int(b_m) + 1)):
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [{"type": "IndexExpression", "base": copy.deepcopy(tbl_ref), "index": _lit(dst_start + k_i)}],
                                    "init": [_ident(rn(r_k))],
                                })
                        return (dst_m,)
                    return (dst_m,)
                if r == "closure_ctor":
                    # `ga[12](child_proto_marker, upval_cells_tbl)`
                    # Note: in MoonVeil 2.0.x `CLOSURE`, `ga[12](proto, ka)` is called BEFORE the loop
                    # populates `ka[1..n_upvals]` in place! Store by integer ID so `deepcopy` preserves live `cap_tbl`.
                    ch_marker, cap_tbl = args[0], args[1]
                    def_id = len(deferred_closures)
                    deferred_closures.append((ch_marker.idx, cap_tbl))
                    return (Sym({"type": "__DeferredClosure__", "def_id": def_id}),)

            # Symbolic function call `fn(args...)`!
            call_ast = {
                "type": "CallExpression",
                "base": to_ast(fn_v),
                "arguments": [to_ast(a) for a in args],
            }
            return (MultiRetCall(call_ast),)

        # Lift all child prototypes first (bottom-up)!
        deferred_closures: list[tuple[int, Any]] = []
        lifted_children = [lift_proto(ch) for ch in child_protos]

        def exec_stmt_list(stmt_list: list[dict], env: dict[str, Any], stmts: list[dict]):
            for s in stmt_list:
                st_type = s["type"]
                if st_type in ("AssignmentStatement", "LocalStatement"):
                    vals: list[Any] = []
                    inits = s.get("init", [])
                    for ii, ie in enumerate(inits):
                        v = eval_expr_sym(ie, env, stmts, multi=(ii == len(inits) - 1 and not ie.get("inParens")))
                        if isinstance(v, tuple):
                            vals.extend(v)
                        else:
                            vals.append(v)
                    for vi, lhs in enumerate(s["variables"]):
                        rhs_val = vals[vi] if vi < len(vals) else None
                        if lhs["type"] == "Identifier":
                            env[lhs["name"]] = rhs_val
                        elif lhs["type"] in ("IndexExpression", "MemberExpression"):
                            b_obj = eval_expr_sym(lhs["base"], env, stmts)
                            k_obj = lhs["identifier"]["name"] if lhs["type"] == "MemberExpression" else eval_expr_sym(lhs["index"], env, stmts)
                            if isinstance(b_obj, _RegBank):
                                b_obj.write(int(k_obj), rhs_val, stmts)
                            elif isinstance(b_obj, _ConcreteTable):
                                # Check if `J[x] = _[f]` open-upvalue registration inside `CLOSURE`!
                                if isinstance(rhs_val, _ConcreteTable) and 2 in rhs_val.fields and 3 in rhs_val.fields and isinstance(rhs_val.get(2), _RegBank):
                                    cell = OpenUpvalCell(int(rhs_val.get(3)))
                                    b_obj.put(k_obj, cell)
                                else:
                                    b_obj.put(k_obj, rhs_val)
                            elif isinstance(b_obj, OuterUpvalCell):
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [_ident(f"__up_{b_obj.up_idx}")],
                                    "init": [to_ast(rhs_val)],
                                })
                            elif isinstance(b_obj, OpenUpvalCell):
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [_ident(rn(b_obj.reg_idx))],
                                    "init": [to_ast(rhs_val)],
                                })
                            elif isinstance(b_obj, EnvSentinel):
                                lhs_ast = _ident(k_obj) if isinstance(k_obj, str) and re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", k_obj) and k_obj not in KEYWORDS else _member_or_index(to_ast(b_obj), k_obj)
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [lhs_ast],
                                    "init": [to_ast(rhs_val)],
                                })
                            else:
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [_member_or_index(to_ast(b_obj), k_obj)],
                                    "init": [to_ast(rhs_val)],
                                })
                elif st_type == "CallStatement":
                    eval_expr_sym(s["expression"], env, stmts, multi=False)
                elif st_type == "ReturnStatement":
                    ret_args: list[Any] = []
                    for ri, re_node in enumerate(s["arguments"]):
                        rv = eval_expr_sym(re_node, env, stmts, multi=(ri == len(s["arguments"]) - 1 and not re_node.get("inParens")))
                        if isinstance(rv, tuple):
                            ret_args.extend(rv)
                        else:
                            ret_args.append(rv)
                    stmts.append({
                        "type": "ReturnStatement",
                        "arguments": [to_ast(a) for a in ret_args],
                    })

        # Execute VM prelude from `gr["start"]` up to `dispatch_state`
        init_stmts: list[dict] = []
        exec_stmt_list(gr["prefix"], base_locals, init_stmts)
        cur_s = gr["start"]
        while cur_s != dispatch_state:
            nd = gr["nodes"][cur_s]
            exec_stmt_list(nd["stmts"], base_locals, init_stmts)
            cur_s = nd["term"]["goto"]

        # Find `v` (the stack-top local initialized to `-1` in prelude!)
        v_var_name = None
        for k_nm, k_vl in base_locals.items():
            if k_vl == -1:
                v_var_name = k_nm
                break

        # Helper to step from `(state_id, env, stmts)` until `dispatch_state` or `return`!
        def run_to_dispatch(state_id: int, env: dict[str, Any], stmts: list[dict], first_step: bool = False) -> dict:
            cur = state_id
            steps = 0
            while True:
                steps += 1
                if steps > 400:
                    raise Unsupported("VM symbolic instruction step budget exceeded")
                if not first_step and cur == dispatch_state:
                    next_pc = int(env[pc_var])
                    next_v = env.get(v_var_name) if v_var_name else -1
                    v_out = next_v if isinstance(next_v, VarTop) else None
                    return {"kind": "jump", "pc": next_pc, "stmts": stmts, "var_top": v_out}
                first_step = False
                nd = gr["nodes"][cur]
                try:
                    exec_stmt_list(nd["stmts"], env, stmts)
                except _ForgprepShortcut:
                    # `OP 195` (`FORGPREP`) called `string.gmatch` on `type(W[N])`!
                    # Find base register `N` (`env["N"]`) and jump to the state where `W[N] = za; W[_] = m; W[f] = ka` runs!
                    reg_n = int(env["N"])
                    stmts.append({
                        "type": "AssignmentStatement",
                        "variables": [_ident(rn(reg_n)), _ident(rn(reg_n + 1)), _ident(rn(reg_n + 2))],
                        "init": [{
                            "type": "CallExpression",
                            "base": _ident("__mv_iter__"),
                            "arguments": [_ident(rn(reg_n)), _ident(rn(reg_n + 1)), _ident(rn(reg_n + 2))],
                        }],
                    })
                    # Find the merge state `264` (`W[N] = za`) via BFS from `cur`!
                    q_bfs = [cur]
                    seen_bfs = set()
                    merge_st = None
                    while q_bfs:
                        cand_s = q_bfs.pop(0)
                        if cand_s in seen_bfs or cand_s == dispatch_state:
                            continue
                        seen_bfs.add(cand_s)
                        c_stmts = gr["nodes"][cand_s]["stmts"]
                        if (
                            c_stmts
                            and c_stmts[0]["type"] == "AssignmentStatement"
                            and len(c_stmts[0]["variables"]) == 1
                            and c_stmts[0]["variables"][0]["type"] == "IndexExpression"
                            and c_stmts[0]["variables"][0]["base"].get("name") == w_param_name
                        ):
                            merge_st = cand_s
                            # Populate the 3 RHS vars (`za, m, ka`) with `r_N, r_{N+1}, r_{N+2}` so `W[N] = za` is a self-assign no-op!
                            for off_k in range(3):
                                rhs_id = c_stmts[0 + off_k]["init"][0]["name"]
                                env[rhs_id] = Sym(_ident(rn(reg_n + off_k)))
                            break
                        tm_b = gr["nodes"][cand_s]["term"]
                        if "goto" in tm_b:
                            q_bfs.append(tm_b["goto"])
                        elif "yes" in tm_b:
                            q_bfs.append(tm_b["yes"]["goto"])
                            q_bfs.append(tm_b["no"]["goto"])
                    if merge_st is None:
                        raise Unsupported("Could not locate FORGPREP merge state")
                    cur = merge_st
                    continue

                tm = nd["term"]
                if "return" in tm:
                    return {"kind": "return", "stmts": stmts}
                if "goto" in tm:
                    cur = tm["goto"]
                else:
                    cond_v = eval_expr_sym(tm["cond"], env, stmts)
                    if isinstance(cond_v, (VarTop, RetCount, VarargCount)):
                        cond_v = True
                    if not is_symbolic(cond_v):
                        cur = tm["yes"]["goto"] if (cond_v is not None and cond_v is not False) else tm["no"]["goto"]
                    else:
                        # Fork True & False continuations to dispatch!
                        env_y = dict(env)
                        env_n = dict(env)
                        stmts_y: list[dict] = []
                        stmts_n: list[dict] = []
                        res_y = run_to_dispatch(tm["yes"]["goto"], env_y, stmts_y, first_step=False)
                        res_n = run_to_dispatch(tm["no"]["goto"], env_n, stmts_n, first_step=False)
                        return {
                            "kind": "branch",
                            "stmts": stmts,
                            "cond": to_ast(cond_v),
                            "yes": res_y,
                            "no": res_n,
                        }

        def fresh_step_env(pc_val: int, v_val: Any) -> dict[str, Any]:
            e = {}
            for ek, ev in base_locals.items():
                if isinstance(ev, _ConcreteTable) and not ev.fields:
                    e[ek] = _ConcreteTable()
                else:
                    e[ek] = ev
            e[pc_var] = pc_val
            if v_var_name:
                e[v_var_name] = v_val if v_val is not None else -1
            return e

        # Explore all reachable PCs from `pc = 1`!
        pc_nodes: dict[int, dict] = {}
        todo: list[tuple[int, VarTop | None]] = [(1, None)]
        while todo:
            pc, v_in = todo.pop()
            if pc in pc_nodes:
                continue
            if pc < 1 or pc > len(code):
                pc_nodes[pc] = {"stmts": [{"type": "ReturnStatement", "arguments": []}], "term": {"return": True}}
                continue
            step_env = fresh_step_env(pc, v_in)
            res = run_to_dispatch(dispatch_state, step_env, [], first_step=True)
            if res["kind"] == "return":
                pc_nodes[pc] = {"stmts": res["stmts"], "term": {"return": True}}
            elif res["kind"] == "jump":
                cur_res = res
                acc_stmts = list(res["stmts"])
                while cur_res["kind"] == "jump" and cur_res.get("var_top") is not None:
                    nxt_pc = cur_res["pc"]
                    nxt_env = fresh_step_env(nxt_pc, cur_res["var_top"])
                    cur_res = run_to_dispatch(dispatch_state, nxt_env, [], first_step=True)
                    acc_stmts.extend(cur_res["stmts"])
                if cur_res["kind"] == "return":
                    pc_nodes[pc] = {"stmts": acc_stmts, "term": {"return": True}}
                elif cur_res["kind"] == "jump":
                    pc_nodes[pc] = {"stmts": acc_stmts, "term": {"goto": cur_res["pc"]}}
                    todo.append((cur_res["pc"], None))
                else:
                    pc_nodes[pc] = _finalize_branch_node(acc_stmts, cur_res, pc_nodes, todo, 100000 + pc * 10)
            else:
                pc_nodes[pc] = _finalize_branch_node(res["stmts"], res, pc_nodes, todo, 100000 + pc * 10)

        # Resolve `__DeferredClosure__` nodes now that every `CLOSURE` loop has populated `cap_tbl`!
        def _written_idents(ast_obj: Any) -> set[str]:
            wset: set[str] = set()
            for n in walk(ast_obj):
                if isinstance(n, dict) and n.get("type") == "AssignmentStatement":
                    for lv in n["variables"]:
                        if lv.get("type") == "Identifier":
                            wset.add(lv["name"])
            return wset

        # Find all registers written anywhere inside any child closure (mutable shared upvalues)
        # or written at higher PCs after a given PC!
        written_by_pc: dict[int, set[str]] = {
            nid: _written_idents(nd["stmts"]) for nid, nd in pc_nodes.items()
        }
        # Any backward jump target means loop body PCs can re-execute; conservatively treat all writes
        # in `pc_nodes` except strictly earlier non-loop PCs, or check if `r_k` is written > once in parent!
        write_count_parent: dict[str, int] = {}
        for nd in pc_nodes.values():
            for st_n in nd["stmts"]:
                if st_n.get("type") == "AssignmentStatement":
                    for lv in st_n["variables"]:
                        if lv.get("type") == "Identifier":
                            write_count_parent[lv["name"]] = write_count_parent.get(lv["name"], 0) + 1

        cap_counter = [0]

        # First pass: determine which parent registers `r_k` are EVER mutated inside ANY child closure!
        mutated_parent_regs: set[str] = set()
        for ch_idx, cap_tbl in deferred_closures:
            ch_writes = _written_idents(lifted_children[ch_idx]["body"])
            if isinstance(cap_tbl, _ConcreteTable):
                for u_slot, cell_obj in cap_tbl.fields.items():
                    if f"__up_{int(u_slot)}" in ch_writes:
                        if isinstance(cell_obj, OpenUpvalCell):
                            mutated_parent_regs.add(rn(cell_obj.reg_idx))
                        elif isinstance(cell_obj, _ConcreteTable) and isinstance(cell_obj.get(2), _RegBank):
                            mutated_parent_regs.add(rn(int(cell_obj.get(3))))

        def _rename_ident_all(ast_obj: Any, old_nm: str, new_nm: str) -> Any:
            if isinstance(ast_obj, list):
                return [_rename_ident_all(x, old_nm, new_nm) for x in ast_obj]
            if isinstance(ast_obj, dict):
                nt = ast_obj.get("type")
                if nt == "Identifier" and ast_obj.get("name") == old_nm:
                    return {**ast_obj, "name": new_nm}
                out_d = {}
                for dk, dv in ast_obj.items():
                    if nt == "MemberExpression" and dk == "identifier":
                        out_d[dk] = dv
                    elif nt == "TableKeyString" and dk == "key":
                        out_d[dk] = dv
                    else:
                        out_d[dk] = _rename_ident_all(dv, old_nm, new_nm)
                return out_d
            return ast_obj

        # Detect PCs inside loops (any PC <= max backward-jump source) so loop-body closures
        # snapshot loop-mutated registers into per-iteration `__cap_N` locals!
        max_back_src = 0
        for src_pc, nd in pc_nodes.items():
            if src_pc >= 100000:
                continue
            tm = nd["term"]
            tgts = [tm["goto"]] if "goto" in tm else ([tm["yes"]["goto"], tm["no"]["goto"]] if "yes" in tm else [])
            for tg in tgts:
                if tg < 100000 and tg <= src_pc:
                    max_back_src = max(max_back_src, src_pc)

        def _rename_idents_map(ast_obj: Any, rmap: dict[str, str]) -> Any:
            if not rmap:
                return ast_obj
            if isinstance(ast_obj, list):
                return [_rename_idents_map(x, rmap) for x in ast_obj]
            if isinstance(ast_obj, dict):
                nt = ast_obj.get("type")
                if nt == "Identifier" and ast_obj.get("name") in rmap:
                    return {**ast_obj, "name": rmap[ast_obj["name"]]}
                out_d = {}
                for dk, dv in ast_obj.items():
                    if nt == "MemberExpression" and dk == "identifier":
                        out_d[dk] = dv
                    elif nt == "TableKeyString" and dk == "key":
                        out_d[dk] = dv
                    else:
                        out_d[dk] = _rename_idents_map(dv, rmap)
                return out_d
            return ast_obj

        def _resolve_node_closures(obj: Any, pre_stmts: list[dict], in_loop_pc: bool) -> Any:
            if isinstance(obj, list):
                return [_resolve_node_closures(x, pre_stmts, in_loop_pc) for x in obj]
            if isinstance(obj, dict):
                if obj.get("type") == "__DeferredClosure__":
                    def_id = obj["def_id"]
                    ch_idx, cap_tbl = deferred_closures[def_id]
                    ch_fn = copy.deepcopy(lifted_children[ch_idx])
                    if isinstance(cap_tbl, _ConcreteTable):
                        up_map: dict[str, str] = {}
                        for u_slot, cell_obj in sorted(cap_tbl.fields.items()):
                            u_name = f"__up_{int(u_slot)}"
                            if isinstance(cell_obj, OpenUpvalCell):
                                r_nm = rn(cell_obj.reg_idx)
                            elif isinstance(cell_obj, _ConcreteTable) and isinstance(cell_obj.get(2), _RegBank):
                                r_nm = rn(int(cell_obj.get(3)))
                            elif isinstance(cell_obj, OuterUpvalCell):
                                up_map[u_name] = f"__up_{cell_obj.up_idx}"
                                continue
                            else:
                                continue
                            if in_loop_pc and r_nm not in mutated_parent_regs and write_count_parent.get(r_nm, 0) > 1:
                                cap_counter[0] += 1
                                cap_nm = f"{cap_prefix}{cap_counter[0]}"
                                pre_stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [_ident(cap_nm)],
                                    "init": [_ident(r_nm)],
                                })
                                up_map[u_name] = cap_nm
                            else:
                                up_map[u_name] = r_nm
                        ch_fn["body"] = _rename_idents_map(ch_fn["body"], up_map)
                    return ch_fn
                return {k: _resolve_node_closures(v, pre_stmts, in_loop_pc) for k, v in obj.items()}
            return obj

        for nid, nd in pc_nodes.items():
            in_lp = nid <= max_back_src
            new_s: list[dict] = []
            for st_item in nd["stmts"]:
                pre: list[dict] = []
                resolved_st = _resolve_node_closures(st_item, pre, in_lp)
                new_s.extend(pre)
                new_s.append(resolved_st)
            nd["stmts"] = new_s

        proto_graph = {
            "var": "__pc__",
            "start": 1,
            "prefix": [],
            "nodes": pc_nodes,
            "suffix": [],
        }
        body_stmts = clean_body(clean(Structurer(proto_graph).emit()))
        body_stmts = normalize_cf_deep(body_stmts, at_fn_end=True, allow_short_tail=False)
        local_tmp_cnt = [0]
        body_stmts = _desugar_block_recursive(body_stmts, lambda: f"d{p_id}_{local_tmp_cnt.__setitem__(0, local_tmp_cnt[0] + 1) or local_tmp_cnt[0]}")
        body_stmts = _fold_self_calls_deep(body_stmts)

        uses_vararg = any(isinstance(n, dict) and n.get("type") == "VarargLiteral" for n in walk(body_stmts))
        params = [_ident(rn(i)) for i in range(1, n_params + 1)]
        param_names = {rn(i) for i in range(1, n_params + 1)}
        if uses_vararg:
            params.append({"type": "VarargLiteral", "value": "...", "raw": "..."})

        # Decouple pre-declaration scratch uses of any register `v` captured by nested closures:
        def _has_nested_fn_ref(stmt_node: dict, var_nm: str) -> bool:
            for sub in walk(stmt_node):
                if isinstance(sub, dict) and sub.get("type") == "FunctionDeclaration":
                    for inner in walk(sub["body"]):
                        if isinstance(inner, dict) and inner.get("type") == "Identifier" and inner.get("name") == var_nm:
                            return True
            return False

        cand_captured = {
            n["name"]
            for s_top in body_stmts
            for sub in walk(s_top)
            if isinstance(sub, dict) and sub.get("type") == "FunctionDeclaration"
            for n in walk(sub["body"])
            if isinstance(n, dict) and n.get("type") == "Identifier" and n["name"].startswith(p_prefix) and n["name"] not in param_names
        }
        for cvar in sorted(cand_captured):
            first_cl = next((idx_s for idx_s, s_top in enumerate(body_stmts) if _has_nested_fn_ref(s_top, cvar)), None)
            if first_cl is None or first_cl == 0:
                continue
            decl_idx = None
            for idx_s in range(first_cl - 1, 0, -1):
                st_c = body_stmts[idx_s]
                if (
                    st_c["type"] == "AssignmentStatement"
                    and len(st_c["variables"]) == 1
                    and st_c["variables"][0].get("type") == "Identifier"
                    and st_c["variables"][0]["name"] == cvar
                    and len(st_c.get("init", [])) == 1
                    and not any(
                        isinstance(rn_n, dict) and rn_n.get("type") == "Identifier" and rn_n.get("name") == cvar
                        for rn_n in walk(st_c["init"][0])
                    )
                ):
                    decl_idx = idx_s
                    break
            if decl_idx is not None and decl_idx > 0:
                pre_nm = f"{p_prefix}{1000 + int(cvar.split('_')[-1])}"
                body_stmts = [_rename_ident_all(s_p, cvar, pre_nm) for s_p in body_stmts[:decl_idx]] + body_stmts[decl_idx:]

        # Declare all local registers `r_*` and `__cap_*` referenced/assigned in `body_stmts` (excluding `params`)!
        tmp_prefix = f"__mv_tmp_d{p_id}_"
        own_regs: list[str] = []
        seen_regs: set[str] = set()
        for n in walk(body_stmts):
            if isinstance(n, dict) and n.get("type") == "Identifier":
                nm = n["name"]
                if (nm.startswith(p_prefix) or nm.startswith(cap_prefix) or nm.startswith(tmp_prefix)) and nm not in param_names and nm not in seen_regs:
                    seen_regs.add(nm)
                    own_regs.append(nm)
        if own_regs:
            own_regs.sort(key=lambda s: (0 if s.startswith(p_prefix) else 1, int(s.split("_")[-1])))
            body_stmts = [
                {
                    "type": "LocalStatement",
                    "variables": [_ident(nm) for nm in own_regs],
                    "init": [],
                }
            ] + body_stmts

        return {
            "type": "FunctionDeclaration",
            "identifier": None,
            "isLocal": False,
            "parameters": params,
            "body": body_stmts,
        }

    root_fn = lift_proto(root_proto)
    stmts = root_fn["body"]

    # Polish lifted AST with our full `beautify.py` pipeline!
    counter = [0]

    def fresh_fn():
        counter[0] += 1
        return str(counter[0])

    alpha = _AlphaRenamer()
    renamed_fn = alpha.rename_fn(root_fn)
    stmts = renamed_fn["body"]
    if stmts and stmts[-1]["type"] == "ReturnStatement" and not stmts[-1]["arguments"]:
        stmts.pop()

    stmts = normalize_cf_deep(stmts, at_fn_end=True, allow_short_tail=False)
    stmts = _desugar_block_recursive(stmts, fresh_fn)
    stmts = isolate_cell_creations(stmts, fresh_fn)
    stmts = _optimize_all_functions(stmts, fresh_fn)
    stmts = reconstruct_for_in_loops(stmts)
    stmts = unbox_cells(stmts, fresh_fn)
    stmts = _optimize_all_functions(stmts, fresh_fn)
    stmts = normalize_cf_deep(stmts, at_fn_end=True, allow_short_tail=True)
    stmts = _optimize_all_functions(stmts, fresh_fn)
    stmts = _place_local_declarations(stmts, set(), is_fn_root=True)
    stmts = _inject_residual_shims(stmts)
    stmts = assign_readable_names(stmts)

    out_text = format_block(stmts, 0).strip() + "\n"
    out_bytes = out_text.encode("latin1")
    parse(normalize(out_bytes))
    return out_bytes


class _ForgprepShortcut(Exception):
    pass


def _fold_self_calls_deep(stmts: list[dict]) -> list[dict]:
    """Fold VM `SELF + CALL` sequences (`r_{N+1} = obj; r_N = obj.Method; ...; r_N(r_{N+1}, ...)`) into `obj:Method(...)`."""
    cur = []
    for s in stmts:
        ns = copy.deepcopy(s)
        if ns["type"] == "IfStatement":
            for c in ns["clauses"]:
                c["body"] = _fold_self_calls_deep(c["body"])
        elif ns["type"] in ("WhileStatement", "RepeatStatement", "DoStatement", "ForGenericStatement", "ForNumericStatement"):
            ns["body"] = _fold_self_calls_deep(ns["body"])
        cur.append(ns)

    out: list[dict] = []
    i = 0
    while i < len(cur):
        # Match `s_self: r_{N+1} = obj` (optional if `self_arg == obj`) followed by `s_m: r_N = obj.Method`
        # followed by 0..6 pure assignments not writing `r_N`/`obj`/`self_reg`, followed by call `r_N(self_reg, ...)`!
        matched = False
        if (
            cur[i]["type"] == "AssignmentStatement"
            and len(cur[i]["variables"]) == 1
            and cur[i]["variables"][0]["type"] == "Identifier"
            and len(cur[i].get("init", [])) == 1
        ):
            # Case 1: `cur[i]` is `self_reg = obj` and `cur[i+1]` is `fn_reg = obj.Method`
            # Case 2: `cur[i]` is `fn_reg = obj.Method` directly (`self_reg == obj`)
            cand_pairs = []
            if (
                i + 1 < len(cur)
                and cur[i]["init"][0]["type"] == "Identifier"
                and cur[i + 1]["type"] == "AssignmentStatement"
                and len(cur[i + 1]["variables"]) == 1
                and cur[i + 1]["variables"][0]["type"] == "Identifier"
                and len(cur[i + 1].get("init", [])) == 1
                and cur[i + 1]["init"][0]["type"] == "MemberExpression"
                and cur[i + 1]["init"][0]["indexer"] == "."
                and cur[i + 1]["init"][0]["base"].get("type") == "Identifier"
                and cur[i + 1]["init"][0]["base"]["name"] == cur[i]["init"][0]["name"]
            ):
                cand_pairs.append((i + 2, cur[i]["variables"][0]["name"], cur[i + 1]["variables"][0]["name"], cur[i]["init"][0]["name"], cur[i + 1]["init"][0]["identifier"], True))
            if (
                cur[i]["init"][0]["type"] == "MemberExpression"
                and cur[i]["init"][0]["indexer"] == "."
                and cur[i]["init"][0]["base"].get("type") == "Identifier"
            ):
                obj_nm = cur[i]["init"][0]["base"]["name"]
                cand_pairs.append((i + 1, obj_nm, cur[i]["variables"][0]["name"], obj_nm, cur[i]["init"][0]["identifier"], False))

            for start_k, self_reg, fn_reg, obj_nm, meth_id, has_self_copy in cand_pairs:
                mids: list[dict] = []
                k = start_k
                while k < len(cur) and len(mids) <= 8:
                    sk = cur[k]
                    # Check if `sk` is the matching call `fn_reg(self_reg, ...)`!
                    call_node = None
                    if sk["type"] == "CallStatement" and sk["expression"]["type"] == "CallExpression":
                        call_node = sk["expression"]
                    elif sk["type"] == "AssignmentStatement" and len(sk.get("init", [])) == 1 and sk["init"][0]["type"] == "CallExpression":
                        call_node = sk["init"][0]
                    if (
                        call_node is not None
                        and call_node["base"].get("type") == "Identifier"
                        and call_node["base"]["name"] == fn_reg
                        and len(call_node["arguments"]) >= 1
                        and call_node["arguments"][0].get("type") == "Identifier"
                        and call_node["arguments"][0]["name"] == self_reg
                    ):
                        new_call = {
                            "type": "CallExpression",
                            "base": {
                                "type": "MemberExpression",
                                "base": _ident(obj_nm),
                                "indexer": ":",
                                "identifier": copy.deepcopy(meth_id),
                            },
                            "arguments": copy.deepcopy(call_node["arguments"][1:]),
                        }
                        new_sk = copy.deepcopy(sk)
                        if new_sk["type"] == "CallStatement":
                            new_sk["expression"] = new_call
                        else:
                            new_sk["init"] = [new_call]
                        if has_self_copy and obj_nm != fn_reg:
                            out.append(cur[i])
                        out.extend(mids)
                        out.append(new_sk)
                        i = k + 1
                        matched = True
                        break
                    # Allow pure intervening arg setups `r_x = ...` that don't overwrite `fn_reg`, `self_reg`, or `obj_nm`
                    if (
                        sk["type"] == "AssignmentStatement"
                        and len(sk["variables"]) == 1
                        and sk["variables"][0]["type"] == "Identifier"
                        and sk["variables"][0]["name"] not in {fn_reg, self_reg, obj_nm}
                        and not any(
                            isinstance(n, dict) and n.get("type") == "Identifier" and n.get("name") in {fn_reg, self_reg}
                            for n in walk(sk["init"])
                        )
                    ):
                        mids.append(sk)
                        k += 1
                    else:
                        break
                if matched:
                    break
        if not matched:
            out.append(cur[i])
            i += 1

    # Collapse `v = base; v = v:Method(args...)` -> `v = base:Method(args...)` when `v` is not in `args`
    collapsed: list[dict] = []
    j = 0
    while j < len(out):
        if (
            j + 1 < len(out)
            and out[j]["type"] == "AssignmentStatement"
            and len(out[j]["variables"]) == 1
            and out[j]["variables"][0]["type"] == "Identifier"
            and len(out[j].get("init", [])) == 1
            and out[j]["init"][0]["type"] in ("Identifier", "MemberExpression")
            and out[j + 1]["type"] == "AssignmentStatement"
            and len(out[j + 1]["variables"]) == 1
            and out[j + 1]["variables"][0]["type"] == "Identifier"
            and out[j + 1]["variables"][0]["name"] == out[j]["variables"][0]["name"]
            and len(out[j + 1].get("init", [])) == 1
            and out[j + 1]["init"][0]["type"] == "CallExpression"
            and out[j + 1]["init"][0]["base"].get("type") == "MemberExpression"
            and out[j + 1]["init"][0]["base"]["indexer"] == ":"
            and out[j + 1]["init"][0]["base"]["base"].get("type") == "Identifier"
            and out[j + 1]["init"][0]["base"]["base"]["name"] == out[j]["variables"][0]["name"]
            and not any(
                isinstance(an, dict) and an.get("type") == "Identifier" and an.get("name") == out[j]["variables"][0]["name"]
                for an in walk(out[j + 1]["init"][0]["arguments"])
            )
        ):
            merged = copy.deepcopy(out[j + 1])
            merged["init"][0]["base"]["base"] = copy.deepcopy(out[j]["init"][0])
            collapsed.append(merged)
            j += 2
            continue
        collapsed.append(out[j])
        j += 1
    return collapsed


def _finalize_branch_node(prefix_stmts: list[dict], br: dict, pc_nodes: dict, todo: list, synth_base: int) -> dict:
    def arm_target(arm: dict, synth_id: int) -> int:
        if arm["kind"] == "jump" and not arm["stmts"]:
            todo.append((arm["pc"], None))
            return arm["pc"]
        if arm["kind"] == "jump":
            pc_nodes[synth_id] = {"stmts": arm["stmts"], "term": {"goto": arm["pc"]}}
            todo.append((arm["pc"], None))
            return synth_id
        if arm["kind"] == "return":
            pc_nodes[synth_id] = {"stmts": arm["stmts"], "term": {"return": True}}
            return synth_id
        pc_nodes[synth_id] = _finalize_branch_node(arm["stmts"], arm, pc_nodes, todo, synth_id * 10)
        return synth_id

    y_tgt = arm_target(br["yes"], synth_base + 1)
    n_tgt = arm_target(br["no"], synth_base + 2)
    return {
        "stmts": prefix_stmts,
        "term": {"cond": br["cond"], "yes": {"goto": y_tgt}, "no": {"goto": n_tgt}},
    }


# ---------------------------------------------------------------------------
# MoonVeil 2.1.x Symbolic Bytecode VM Extractor & Lifter
# ---------------------------------------------------------------------------

@dataclass
class _HandlerRef21:
    op: int


class _CodeTable21:
    """Mutable 1-based instruction table `v[code_key]` supporting live basic-block & string decryption."""

    def __init__(self, code_list: list[dict[int, Any]]):
        self.items: dict[int, _ConcreteTable] = {
            idx + 1: _ConcreteTable(dict(ins)) for idx, ins in enumerate(code_list)
        }

    def __len__(self) -> int:
        return len(self.items)

    def get(self, k: Any) -> Any:
        return self.items.get(int(k))

    def put(self, k: Any, v: Any) -> None:
        if isinstance(v, _ConcreteTable):
            self.items[int(k)] = v
        elif isinstance(v, dict):
            self.items[int(k)] = _ConcreteTable(dict(v))


def _eval_concrete_builtin(role: str, args: list[Any]) -> tuple[Any, ...] | None:
    """Evaluate pure `string.*` / `bit32.*` / `math.*` builtins when all args are concrete."""
    if any(is_symbolic(a) for a in args):
        return None
    if role == "string.byte":
        s = args[0] if isinstance(args[0], str) else str(args[0])
        i = int(args[1]) if len(args) >= 2 and args[1] is not None else 1
        j = int(args[2]) if len(args) >= 3 and args[2] is not None else i
        if i < 1:
            i = 1
        return tuple(ord(s[idx - 1]) for idx in range(i, min(j, len(s)) + 1))
    if role == "string.char":
        return ("".join(chr(int(n) & 0xFF) for n in args),)
    if role == "string.sub":
        s = args[0] if isinstance(args[0], str) else str(args[0])
        n = len(s)
        i = int(args[1]) if len(args) >= 2 and args[1] is not None else 1
        j = int(args[2]) if len(args) >= 3 and args[2] is not None else n
        if i < 0:
            i = max(1, n + 1 + i)
        if j < 0:
            j = n + 1 + j
        return (s[max(0, i - 1) : max(0, j)],)
    if role == "bit32.bxor":
        acc = 0
        for a in args:
            acc ^= int(a) & 0xFFFFFFFF
        return (acc & 0xFFFFFFFF,)
    if role == "bit32.band":
        acc = 0xFFFFFFFF
        for a in args:
            acc &= int(a) & 0xFFFFFFFF
        return (acc & 0xFFFFFFFF,)
    if role == "bit32.bor":
        acc = 0
        for a in args:
            acc |= int(a) & 0xFFFFFFFF
        return (acc & 0xFFFFFFFF,)
    if role == "bit32.bnot":
        return ((~int(args[0])) & 0xFFFFFFFF,)
    if role == "bit32.lshift":
        x, d = int(args[0]) & 0xFFFFFFFF, int(args[1])
        if 0 <= d < 32:
            return ((x << d) & 0xFFFFFFFF,)
        if -32 < d < 0:
            return ((x >> (-d)) & 0xFFFFFFFF,)
        return (0,)
    if role == "bit32.rshift":
        x, d = int(args[0]) & 0xFFFFFFFF, int(args[1])
        if 0 <= d < 32:
            return ((x >> d) & 0xFFFFFFFF,)
        if -32 < d < 0:
            return ((x << (-d)) & 0xFFFFFFFF,)
        return (0,)
    if role == "bit32.arshift":
        x, d = int(args[0]) & 0xFFFFFFFF, int(args[1])
        sx = x - 0x100000000 if (x & 0x80000000) else x
        if 0 <= d < 32:
            return ((sx >> d) & 0xFFFFFFFF,)
        if d >= 32:
            return (0xFFFFFFFF if sx < 0 else 0,)
        if -32 < d < 0:
            return ((x << (-d)) & 0xFFFFFFFF,)
        return (0,)
    if role == "tonumber":
        try:
            base = int(args[1]) if len(args) >= 2 and args[1] is not None else 10
            if isinstance(args[0], (int, float)) and len(args) < 2:
                return (args[0],)
            s = str(args[0]).strip()
            return (int(s, base),)
        except Exception:
            try:
                return (float(str(args[0])),)
            except Exception:
                return (None,)
    if role == "tostring":
        if args[0] is None:
            return ("nil",)
        if isinstance(args[0], bool):
            return ("true" if args[0] else "false",)
        return (str(args[0]),)
    if role == "rawequal":
        return (args[0] == args[1] and type(args[0]) is type(args[1]),)
    if role == "string.gmatch":
        s = args[0] if isinstance(args[0], str) else str(args[0])
        pat = args[1] if len(args) >= 2 and isinstance(args[1], str) else "."
        items = list(s) if pat == "." else re.findall(pat, s)
        it_st = {"idx": 0, "items": items}
        return (_BuiltinTag("concrete_gmatch_iter"), it_st, None)
    return None


def _extract_21x_vm_bundle(raw: bytes) -> dict | None:
    """Extract unmutated prototype tree, opcode->export map, and builtin roles for MoonVeil 2.1.x VM."""
    if not LUAU_BIN.is_file():
        return None
    u2 = raw.decode("latin1")
    ret_idx = u2.find("return(")
    tail_off = max(0, len(u2) - 65536)
    m_end = re.search(r"\):([A-Za-z_]\w*)\((\{[^\}]+\}),\"([A-Za-z_]\w*)\",\.\.\.\)\s*$", u2[tail_off:])
    if ret_idx < 0 or not m_end:
        return None
    boot_nm, names_lit, entry_nm = m_end.group(1), m_end.group(2), m_end.group(3)
    body_raw = u2[ret_idx + 7 : tail_off + m_end.start()]

    probe = f"""
local regbank_set = {{}}
local tbl_proxy = setmetatable({{
    create = function(n)
        local t = table.create(n)
        regbank_set[t] = true
        return t
    end,
}}, {{ __index = table }})
local pure_env
local ENV_TAG = setmetatable({{ __mv_env = true }}, {{
    __index = function(_, k)
        return pure_env[k]
    end,
}})
pure_env = {{
    string = string,
    table = tbl_proxy,
    bit32 = bit32,
    math = math,
    select = select,
    type = type,
    tonumber = tonumber,
    tostring = tostring,
    unpack = unpack or table.unpack,
    pairs = pairs,
    ipairs = ipairs,
    next = next,
    pcall = pcall,
    xpcall = xpcall,
    error = error,
    assert = assert,
    setmetatable = setmetatable,
    getmetatable = getmetatable,
    rawget = rawget,
    rawset = rawset,
    rawlen = rawlen,
    rawequal = rawequal,
    getfenv = function() return ENV_TAG end,
    setfenv = function() end,
}}
local fenv_tbl = setmetatable({{ __mv_env = true, table = tbl_proxy, getfenv = function() return ENV_TAG end, setfenv = function() end }}, {{ __index = _G }})
setfenv(1, fenv_tbl)

local raw_arr = {body_raw}
local names = {names_lit}
local wid_map = {{}}
local res_map = {{}}
local res_ups = {{}}
local nd_wid = nil
local pc_wid = nil
local active_stack = {{}}
local nd_handlers = nil
local root_nd_args = nil
local root_frame = nil
local root_va = nil
local nd_arg_roles = {{}}

local function unbox3(c)
    if type(c) ~= "table" then return c end
    local hs = false
    for _, vv in pairs(c) do if vv == c then hs = true end end
    if not hs then return c end
    for kk, vv in pairs(c) do
        if type(vv) == "number" and vv ~= kk and c[vv] ~= nil and c[vv] ~= c then
            return c[vv]
        end
    end
    return nil
end

for k, orig in pairs(raw_arr) do
    if type(orig) == "function" and k ~= "{boot_nm}" then
        local wid = tostring(k)
        local wfn
        wfn = function(...)
            local self, up = ...
            local res_pk = table.pack(orig(...))
            local r1 = res_pk[1]
            if res_pk.n == 1 and type(r1) == "function" then
                res_map[r1] = wid
                res_ups[r1] = up
                if type(up) == "table" and #up == 1 then
                    local cand = unbox3(up[1])
                    if type(cand) == "table" and cand ~= raw_arr then
                        local fcnt = 0
                        for _, fv in pairs(cand) do
                            if type(fv) == "function" then fcnt = fcnt + 1 end
                        end
                        if fcnt >= 20 then
                            nd_wid = wid
                            nd_handlers = cand
                            return function(...)
                                if not root_nd_args then
                                    root_nd_args = table.pack(...)
                                end
                                error("__MV21_CAPTURED__")
                            end
                        end
                    end
                end
            end
            return table.unpack(res_pk, 1, res_pk.n)
        end
        wid_map[wfn] = wid
        raw_arr[k] = wfn
    end
end

pcall(function() raw_arr:{boot_nm}(names, "{entry_nm}") end)
if not root_nd_args or not nd_handlers then
    print("ERR:NO_CAPTURE")
    return
end
for ai = 1, root_nd_args.n do
    local av = root_nd_args[ai]
    if type(av) == "table" and not regbank_set[av] then
        local kc, has_h = 0, false
        for fk, fv in pairs(av) do
            kc = kc + 1
            if fv == nd_handlers or fv == ENV_TAG then has_h = true end
        end
        if has_h or (kc >= 5 and #av == 0) then
            root_frame = av
            break
        end
    end
end
if not root_frame then
    print("ERR:NO_CAPTURE")
    return
end

local id_to_name = {{}}
for k, v in pairs(raw_arr) do
    if type(k) == "string" and wid_map[v] then
        id_to_name[wid_map[v]] = k
    end
end

local builtin_roles = {{
    [ENV_TAG] = "env",
    [fenv_tbl] = "env",
    [string.byte] = "string.byte",
    [string.char] = "string.char",
    [string.sub] = "string.sub",
    [string.gmatch] = "string.gmatch",
    [string.len] = "string.len",
    [table.move] = "table.move",
    [table.create] = "table.create",
    [tbl_proxy.create] = "table.create",
    [table.pack] = "table.pack",
    [table.unpack or unpack] = "unpack_slice",
    [unpack or table.unpack] = "unpack_slice",
    [bit32.bxor] = "bit32.bxor",
    [bit32.band] = "bit32.band",
    [bit32.bor] = "bit32.bor",
    [bit32.bnot] = "bit32.bnot",
    [bit32.lshift] = "bit32.lshift",
    [bit32.rshift] = "bit32.rshift",
    [bit32.arshift] = "bit32.arshift",
    [select] = "select",
    [type] = "type",
    [tonumber] = "tonumber",
    [tostring] = "tostring",
    [pairs] = "pairs",
    [ipairs] = "ipairs",
    [next] = "next",
    [pcall] = "pcall",
    [setmetatable] = "setmetatable",
    [getmetatable] = "getmetatable",
    [rawequal] = "rawequal",
    [rawget] = "rawget",
    [rawset] = "rawset",
    [rawlen] = "rawlen",
}}

local function role_of_val(fv)
    if fv == nil then return "nil" end
    if builtin_roles[fv] then return builtin_roles[fv] end
    if type(fv) == "function" then
        if res_map[fv] then
            return "export_res:" .. tostring(id_to_name[res_map[fv]] or res_map[fv])
        end
        if wid_map[fv] then
            return "export_wid:" .. tostring(id_to_name[wid_map[fv]] or wid_map[fv])
        end
        local ok_u, u1, u2 = pcall(fv, {{10, 20, 30}}, 2, 3)
        if ok_u and u1 == 20 and u2 == 30 then return "unpack_slice" end
    end
    if type(fv) == "table" then
        local ok_e, is_e = pcall(function() return fv.__mv_env end)
        if ok_e and is_e then return "env" end
        if rawget(fv, "__mode") then return "weak_mt" end
        return "table"
    end
    return type(fv)
end

for ai = 1, root_nd_args.n do
    local av = root_nd_args[ai]
    if rawequal(av, root_frame) then
        nd_arg_roles[tostring(ai)] = "frame"
    elseif type(av) == "function" then
        nd_arg_roles[tostring(ai)] = "fn:" .. role_of_val(av)
    elseif type(av) == "table" then
        local matched_fk = nil
        for fk, fv in pairs(root_frame) do
            if rawequal(fv, av) then
                matched_fk = fk
                break
            end
        end
        if matched_fk ~= nil then
            nd_arg_roles[tostring(ai)] = "frame_field:" .. tostring(matched_fk)
        elseif regbank_set[av] then
            nd_arg_roles[tostring(ai)] = "regs"
        else
            local kc, has_t, has_n = 0, false, false
            for _, fv in pairs(av) do
                kc = kc + 1
                if type(fv) == "table" then has_t = true end
                if type(fv) == "number" then has_n = true end
            end
            if kc == 2 and has_t and has_n then
                nd_arg_roles[tostring(ai)] = "vararg"
                root_va = av
            else
                nd_arg_roles[tostring(ai)] = "upvals"
            end
        end
    else
        nd_arg_roles[tostring(ai)] = "upvals"
    end
end

local function json_str(s)
    local out = {{'"'}}
    for i = 1, #s do
        local b = string.byte(s, i)
        if b == 34 then table.insert(out, '\\\\"')
        elseif b == 92 then table.insert(out, '\\\\\\\\')
        elseif b == 10 then table.insert(out, '\\\\n')
        elseif b == 13 then table.insert(out, '\\\\r')
        elseif b == 9 then table.insert(out, '\\\\t')
        elseif b < 32 or b >= 127 then table.insert(out, string.format("\\\\u%04x", b))
        else table.insert(out, string.char(b)) end
    end
    table.insert(out, '"')
    return table.concat(out)
end

local function ser_val(v, depth)
    local tv = type(v)
    if tv == "nil" then return "null"
    elseif tv == "boolean" then return v and "true" or "false"
    elseif tv == "number" then
        if v ~= v or v == math.huge or v == -math.huge then return "0" end
        if math.floor(v) == v and math.abs(v) < 1e15 then return string.format("%d", v) end
        return string.format("%.17g", v)
    elseif tv == "string" then return json_str(v)
    elseif tv == "table" then
        if depth > 14 then return "{{}}" end
        local n = #v
        local cnt = 0
        for _ in pairs(v) do cnt = cnt + 1 end
        if cnt == n and n > 0 then
            local parts = {{}}
            for i = 1, n do parts[i] = ser_val(v[i], depth + 1) end
            return "[" .. table.concat(parts, ",") .. "]"
        end
        local parts = {{}}
        for kk, vv in pairs(v) do
            if type(kk) == "number" or type(kk) == "string" then
                table.insert(parts, json_str(tostring(kk)) .. ":" .. ser_val(vv, depth + 1))
            end
        end
        return "{{" .. table.concat(parts, ",") .. "}}"
    end
    return '"<' .. tv .. '>"'
end

-- Identify `ctx` (`raw_arr`) helper roles (`pack`, `unpack`, `setmult`, `iter`, `bit32.*`)
local ctx_roles = {{}}
for k, v in pairs(raw_arr) do
    if type(k) == "string" and k ~= "{boot_nm}" and k ~= "{entry_nm}" then
        if builtin_roles[v] then
            ctx_roles[k] = builtin_roles[v]
        elseif type(v) == "function" then
            local ok1, r1 = pcall(v, 11, 22)
            if ok1 and type(r1) == "table" and type(r1[1]) == "table" and r1[1][1] == 11 and r1[1][2] == 22 and r1[2] == 2 then
                ctx_roles[k] = "pack"
            else
                local ok2, x1, x2 = pcall(v, {{[1] = {{33, 44}}, [2] = 2}})
                if ok2 and x1 == 33 and x2 == 44 then
                    ctx_roles[k] = "unpack"
                else
                    local t_test = {{}}
                    local ok3 = pcall(v, t_test, 3, 55, 66)
                    if ok3 and t_test[3] == 55 and t_test[4] == 66 then
                        ctx_roles[k] = "setmult"
                    else
                        local t_it = {{ a = 1 }}
                        local ok4, f4, s4 = pcall(v, t_it)
                        if ok4 and type(f4) == "function" and s4 == t_it then
                            ctx_roles[k] = "iter"
                        end
                    end
                end
            end
        end
    end
end

-- Map every opcode in `nd_handlers` to its export name + unboxed upvalue roles!
local op_map = {{}}
local op_ups = {{}}
for op, hfn in pairs(nd_handlers) do
    if type(op) == "number" and type(hfn) == "function" then
        local wid = res_map[hfn]
        local enm = wid and id_to_name[wid] or nil
        if enm then
            op_map[tostring(op)] = enm
            local ups = res_ups[hfn]
            if type(ups) == "table" then
                local ul = {{}}
                for ui = 1, #ups do
                    ul[ui] = role_of_val(unbox3(ups[ui]))
                end
                op_ups[tostring(op)] = ul
            end
        end
    end
end

-- Map `root_frame` slot roles & extract root + child prototypes cleanly!
local frame_roles = {{}}
local root_proto_clean = {{}}
for fk, fv in pairs(root_frame) do
    if fv == nd_handlers then
        frame_roles[tostring(fk)] = "handlers"
    elseif type(fv) ~= "table" or role_of_val(fv) ~= "table" then
        frame_roles[tostring(fk)] = role_of_val(fv)
    else
        root_proto_clean[fk] = fv
    end
end

local va_keys = {{}}
if type(root_va) == "table" then
    for vk, vv in pairs(root_va) do
        va_keys[tostring(vk)] = type(vv)
    end
end

print("MV21_JSON_START")
print("{{"
    .. '"nd_export":' .. json_str(tostring(id_to_name[nd_wid] or "")) .. ","
    .. '"nd_arg_roles":' .. ser_val(nd_arg_roles, 1) .. ","
    .. '"ctx_roles":' .. ser_val(ctx_roles, 1) .. ","
    .. '"frame_roles":' .. ser_val(frame_roles, 1) .. ","
    .. '"va_keys":' .. ser_val(va_keys, 1) .. ","
    .. '"op_map":' .. ser_val(op_map, 1) .. ","
    .. '"op_ups":' .. ser_val(op_ups, 1) .. ","
    .. '"proto":' .. ser_val(root_proto_clean, 0)
    .. "}}")
print("MV21_JSON_END")
"""
    with tempfile.NamedTemporaryFile("w", suffix=".luau", delete=False, encoding="latin1") as tf:
        tf.write(probe)
        tf_path = tf.name
    try:
        proc = subprocess.run(
            [str(LUAU_BIN), tf_path],
            capture_output=True,
            text=True,
            encoding="latin1",
            timeout=25,
        )
    finally:
        try:
            os.unlink(tf_path)
        except OSError:
            pass

    out = proc.stdout
    s_idx = out.find("MV21_JSON_START\n")
    e_idx = out.find("\nMV21_JSON_END")
    if s_idx < 0 or e_idx < 0:
        return None
    return json.loads(out[s_idx + len("MV21_JSON_START\n") : e_idx])


def _extract_21x_env_decrypted_proto(raw: bytes, code_key: str, frame_roles: dict[int, str]) -> dict | None:
    """When `root_proto` is a MoonVeil 2.1.x Environmental Key Loader (`WorldModel:Raycast` + `S` ChaCha20),
    evaluate the pure loader on exact line 2 (preserving `debug.info`/`debug.traceback` anti-tamper) and
    intercept `nd` right BEFORE Instruction 1 of the decrypted inner payload prototype executes!"""
    if not LUAU_BIN.is_file():
        return None
    u2 = raw.decode("latin1")
    ret_idx = u2.find("return(")
    if ret_idx < 0:
        return None

    # Line 1 holds the entire sandboxed geometry + `Destroy` post-anti-tamper hook so `return(` stays on Line 2!
    one_line = (
        "local MV_CTX,CAP_SF=nil,nil;"
        "local function jstr(s)local o={'\"'}for i=1,#s do local b=string.byte(s,i)"
        "if b==34 then o[#o+1]='\\\\\"' elseif b==92 then o[#o+1]='\\\\\\\\' "
        "elseif b==10 then o[#o+1]='\\\\n' elseif b==13 then o[#o+1]='\\\\r' "
        "elseif b==9 then o[#o+1]='\\\\t' elseif b<32 or b>=127 then o[#o+1]=string.format('\\\\u%04x',b)"
        "else o[#o+1]=string.char(b)end end o[#o+1]='\"' return table.concat(o)end;"
        "local function ser(v,d)local t=type(v)if t=='nil'then return'null'elseif t=='boolean'then return v and'true'or'false'"
        "elseif t=='number'then if v~=v or v==1/0 or v==-1/0 then return'0'end "
        "if math.floor(v)==v and math.abs(v)<1e15 then return string.format('%d',v)end return string.format('%.17g',v)"
        "elseif t=='string'then return jstr(v)elseif t=='table'then if d>14 then return'{}'end "
        "local n,c=#v,0 for _ in pairs(v)do c=c+1 end if c==n and n>0 then local p={}for i=1,n do p[i]=ser(v[i],d+1)end return'['..table.concat(p,',')..']'end "
        "local p={}for kk,vv in pairs(v)do if(type(kk)=='number'or type(kk)=='string')and type(vv)~='function'then p[#p+1]=jstr(tostring(kk))..':'..ser(vv,d+1)end end "
        "return'{'..table.concat(p,',')..'}'end return'null'end;"
        "local Vec3={new=function(x,y,z)return{X=x,Y=y,Z=z}end};"
        "local CF={new=function(x,y,z)return{X=x,Y=y,Z=z}end};"
        "local RayParams={new=function()return{IncludeInstances={}}end};"
        "local gm=setmetatable({},{__index=function(_,k)if k=='GetService'then return function(_,s)return{Name=s}end end error('no '..tostring(k))end});"
        "local ws=setmetatable({},{__index=function(_,k)if k=='children'or k=='GetChildren'then return function()return{}end end error('no')end});"
        "local Inst={new=function(c)if c=='WorldModel'then return{"
        "Raycast=function(_,o,d,p)local bt,bp=1e9,nil for _,pt in ipairs(p.IncludeInstances)do "
        "local zf=d.Z<0 and(pt.CFrame.Z+pt.Size.Z*0.5)or(pt.CFrame.Z-pt.Size.Z*0.5)local t=(zf-o.Z)/d.Z "
        "if t>=0 and t<=1 and t<bt then bt=t bp={Position={X=o.X+d.X*t,Y=o.Y+d.Y*t,Z=zf}}end end return bp end,"
        "Destroy=function()local ctx=MV_CTX local orig_ld=nil for k,orig in pairs(ctx)do if type(orig)=='function'then "
        "ctx[k]=function(...)local s,up=... local pk=table.pack(orig(...))local r1=pk[1] "
        "if pk.n==1 and type(r1)=='function'and type(up)=='table'and #up==1 then "
        "return function(...)local ap=table.pack(...)for ai=1,ap.n do local sf=ap[ai]if type(sf)=='table'and type(sf["
        + str(code_key)
        + "])=='table'and(#sf["
        + str(code_key)
        + "]>60 or #(sf[4]or{})>0)then local cl={}for fk,fv in pairs(sf)do "
        "if type(fv)=='table'then local oke,ise=pcall(function()return fv.__mv_env end)if not(oke and ise)and not rawget(fv,'__mode')then "
        "cl[fk]=fv end elseif type(fv)~='function'then cl[fk]=fv end end print('MV21_INNER_START')print(ser(cl,0))print('MV21_INNER_END')error('__MV21_INNER__')end end return r1(...)end end "
        "return table.unpack(pk,1,pk.n)end end end end}end return{Size={X=0,Y=0,Z=0},CFrame={X=0,Y=0,Z=0}}end};"
        "local env=setmetatable({__mv_env=true,Instance=Inst,Vector3=Vec3,CFrame=CF,RaycastParams=RayParams,workspace=ws,game=gm},{__index=_G});"
        "setfenv(1,setmetatable({getfenv=function()return env end},{__index=env}))"
    )
    script = one_line + "\nreturn(function(t)MV_CTX=t return t end)(" + u2[ret_idx + 7 :]
    with tempfile.NamedTemporaryFile("w", suffix=".luau", delete=False, encoding="latin1") as tf:
        tf.write(script)
        tf_path = tf.name
    try:
        proc = subprocess.run(
            [str(LUAU_BIN), tf_path],
            capture_output=True,
            text=True,
            encoding="latin1",
            timeout=25,
        )
    finally:
        try:
            os.unlink(tf_path)
        except OSError:
            pass
    out = proc.stdout
    s_i = out.find("MV21_INNER_START\n")
    e_i = out.find("\nMV21_INNER_END")
    if s_i < 0 or e_i < 0:
        return None
    inner_p = json.loads(out[s_i + len("MV21_INNER_START\n") : e_i])
    for fk in frame_roles:
        inner_p.pop(str(fk), None)
    return inner_p


def lift_moonveil_21x_vm(raw: bytes) -> bytes:
    """Deobfuscate and lift a MoonVeil 2.1.x Bytecode VM script into structured Lua."""
    import moonveil21.core.decoder as dec21
    from moonveil21.extractor import AnalysisEvaluator

    bundle = _extract_21x_vm_bundle(raw)
    if not bundle:
        raise Unsupported("Not a MoonVeil 2.1.x Bytecode VM script or prototype extraction failed")

    dec21.Evaluator = AnalysisEvaluator
    dec = dec21.decode(raw)

    nd_export = bundle["nd_export"]
    ctx_roles: dict[str, str] = bundle["ctx_roles"]
    frame_roles: dict[int, str] = {int(k): v for k, v in bundle["frame_roles"].items() if k.isdigit()}
    va_keys: dict[int, str] = {int(k): v for k, v in bundle["va_keys"].items() if k.isdigit()}
    op_map: dict[int, str] = {int(k): v for k, v in bundle["op_map"].items()}
    op_ups: dict[int, list[str]] = {int(k): v for k, v in bundle["op_ups"].items()}
    root_proto: dict = bundle["proto"]

    # Identify `closure_ctor` export (the export in `dec.exports` that calls `:<nd_export>(`)!
    closure_ctor_exports: set[str] = set()
    outer_wrapper_exports: set[str] = set()
    for enm, efn in dec.exports.items():
        if isinstance(efn, dict) and efn.get("type") == "FunctionDeclaration":
            src_txt = format_expr(efn, 0)
            if f":{nd_export}(" in src_txt:
                closure_ctor_exports.add(enm)

    # Identify `upvals_key` (`l[K] = up_param` inside `closure_ctor`) irrespective of parameter order!
    upvals_key: int | None = None
    for c_nm in closure_ctor_exports:
        cfn = clean(dec.exports[c_nm])
        inner_c = cfn["body"][0]["arguments"][0]
        if len(inner_c["parameters"]) >= 2:
            c_pnames = [p["name"] for p in inner_c["parameters"]]
            indexed_pnames = {
                n["base"]["name"]
                for n in walk(inner_c)
                if isinstance(n, dict) and n.get("type") == "IndexExpression" and n["base"].get("type") == "Identifier"
            }
            non_indexed_pnames = {pn for pn in c_pnames if pn not in indexed_pnames}
            for n in walk(inner_c):
                if isinstance(n, dict) and n.get("type") == "AssignmentStatement":
                    for lv, lr in zip(n["variables"], n["init"]):
                        if (
                            lv.get("type") == "IndexExpression"
                            and lv["index"].get("type") == "NumericLiteral"
                            and lr.get("type") == "Identifier"
                            and lr["name"] in non_indexed_pnames
                        ):
                            upvals_key = int(lv["index"]["value"])
                # Also spot `g:<md_export>(...)` inside `closure_ctor`!
                if (
                    isinstance(n, dict)
                    and n.get("type") in ("CallExpression", "TableCallExpression")
                    and n["base"].get("type") == "MemberExpression"
                    and n["base"]["indexer"] == ":"
                ):
                    m_nm = n["base"]["identifier"]["name"]
                    if m_nm != nd_export:
                        outer_wrapper_exports.add(m_nm)

    # Identify `code_key`, `protos_key`, `params_key` from `root_proto` + `outer_wrapper`!
    code_key: str | None = None
    protos_key: str | None = None
    for k, v in root_proto.items():
        if isinstance(v, list) and len(v) > 0 and isinstance(v[0], dict):
            has_num_ops = any(kk.isdigit() and isinstance(vv, (int, float)) for kk, vv in v[0].items())
            has_sub_list = any(isinstance(vv, list) for vv in v[0].values())
            if has_num_ops and not has_sub_list:
                code_key = k
            elif has_sub_list:
                protos_key = k
    if protos_key is None:
        for k, v in root_proto.items():
            if k != code_key and isinstance(v, list):
                protos_key = k
                break
    if code_key is None:
        raise Unsupported("Could not identify MoonVeil 2.1.x instruction array key")

    # If `root_proto` is an Environmental Key Loader wrapping an encrypted child prototype (`S`),
    # unwrap directly to the decrypted inner payload prototype!
    target_proto = root_proto
    if protos_key and isinstance(root_proto.get(protos_key), list):
        has_enc_child = any(
            isinstance(ch, dict)
            and not ch.get(code_key)
            and any(isinstance(cv, str) and len(cv) > 32 for cv in ch.values())
            for ch in root_proto[protos_key]
        )
        if has_enc_child:
            dec_inner = _extract_21x_env_decrypted_proto(raw, code_key, frame_roles)
            if dec_inner is not None:
                target_proto = dec_inner

    params_key: str | None = None
    sample_ch_list = target_proto.get(protos_key) if protos_key and isinstance(target_proto.get(protos_key), list) else []
    sample_proto = sample_ch_list[0] if sample_ch_list else target_proto
    for w_nm in outer_wrapper_exports:
        if w_nm in dec.exports:
            wfn = clean(dec.exports[w_nm])
            idx_keys = [
                int(n["index"]["value"])
                for n in walk(wfn)
                if isinstance(n, dict)
                and n.get("type") == "IndexExpression"
                and n["index"].get("type") == "NumericLiteral"
                and int(n["index"]["value"]) not in va_keys
                and int(n["index"]["value"]) not in (1, 2, 3)
            ]
            cand_pkeys = [
                str(ik)
                for ik in dict.fromkeys(idx_keys)
                if str(ik) in sample_proto and isinstance(sample_proto[str(ik)], int)
            ]
            if cand_pkeys:
                all_chs = sample_ch_list or [sample_proto]
                nonzero_pkeys = [pk for pk in cand_pkeys if any(int(ch.get(pk, 0)) > 0 for ch in all_chs)]
                pool_pkeys = nonzero_pkeys or cand_pkeys
                params_key = min(pool_pkeys, key=lambda pk: sum(int(ch.get(pk, 0)) for ch in all_chs))
                break

    vararg_tbl_key = next((k for k, t in va_keys.items() if t == "table"), 1)
    vararg_cnt_key = next((k for k, t in va_keys.items() if t == "number"), 2)

    # Decode `nd` (`vm_driver`) CFG once!
    nd_outer = clean(dec.exports[nd_export])
    nd_ctx_param = nd_outer["parameters"][0]["name"]
    nd_up_param = nd_outer["parameters"][1]["name"]
    nd_inner = nd_outer["body"][0]["arguments"][0]
    nd_params = [p["name"] for p in nd_inner["parameters"]]
    nd_gr = build_graph(nd_inner)

    # Detect the 3-slot upvalue cell permutation `(cell_tbl_slot, cell_key_slot)` (`3! = 6` variants)!
    cell_tbl_slot, cell_key_slot = 1, 3
    for n_c in walk(nd_inner):
        if not isinstance(n_c, dict):
            continue
        if (
            n_c.get("type") == "MemberExpression"
            and n_c["identifier"]["name"] == "value"
            and n_c["base"].get("type") == "IndexExpression"
            and n_c["base"]["base"].get("type") == "Identifier"
            and n_c["base"]["base"]["name"] == nd_up_param
        ):
            cell_tbl_slot, cell_key_slot = 2, 3
            break
        if (
            n_c.get("type") == "IndexExpression"
            and n_c["base"].get("type") == "IndexExpression"
            and n_c["base"]["index"].get("type") == "NumericLiteral"
            and n_c["index"].get("type") == "IndexExpression"
            and n_c["index"]["index"].get("type") == "NumericLiteral"
            and n_c["base"]["base"].get("type") == "IndexExpression"
            and n_c["base"]["base"]["base"].get("type") == "Identifier"
            and n_c["base"]["base"]["base"]["name"] == nd_up_param
        ):
            cell_tbl_slot = int(n_c["base"]["index"]["value"])
            cell_key_slot = int(n_c["index"]["index"]["value"])
            break

    # Find `nd` dispatch_state (the loop header node inside `nd_gr` that indexes `code[pc]`)!
    preds_nd: dict[int, int] = {nid: 0 for nid in nd_gr["nodes"]}
    for nid, nd_node in nd_gr["nodes"].items():
        tm = nd_node["term"]
        if "goto" in tm and tm["goto"] in preds_nd:
            preds_nd[tm["goto"]] += 1
        elif "yes" in tm:
            for s_arm in ("yes", "no"):
                if tm[s_arm]["goto"] in preds_nd:
                    preds_nd[tm[s_arm]["goto"]] += 1
    nd_dispatch = max(preds_nd.keys(), key=lambda k: preds_nd[k])

    # Cache decoded & CFG-structured opcode handlers on demand!
    handler_cache: dict[int, dict] = {}

    def get_handler_spec(op: int) -> dict:
        if op in handler_cache:
            return handler_cache[op]
        enm = op_map.get(op)
        if not enm or enm not in dec.exports:
            raise Unsupported(f"Missing MoonVeil 2.1.x handler export for opcode {op}")
        h_outer = clean(dec.exports[enm])
        h_ctx_nm = h_outer["parameters"][0]["name"]
        h_up_nm = h_outer["parameters"][1]["name"] if len(h_outer["parameters"]) >= 2 else None
        h_inner = h_outer["body"][0]["arguments"][0]
        h_params = [p["name"] for p in h_inner["parameters"]]
        h_gr = build_graph(h_inner)
        spec = {
            "export": enm,
            "ctx_nm": h_ctx_nm,
            "up_nm": h_up_nm,
            "params": h_params,
            "gr": h_gr,
            "ups": op_ups.get(op, []),
        }
        handler_cache[op] = spec
        return spec

    proto_uid = [0]

    def lift_proto(proto: dict) -> dict:
        proto_uid[0] += 1
        p_id = proto_uid[0]
        p_prefix = f"__p{p_id}_r_"
        cap_prefix = f"__p{p_id}_cap_"

        def rn(idx: int) -> str:
            return f"{p_prefix}{idx}"

        raw_code = proto.get(code_key, [])
        code_init: list[dict[int, Any]] = []
        for ins in raw_code:
            code_init.append({int(k): v for k, v in ins.items()})

        raw_children = proto.get(protos_key, []) if protos_key else []
        if isinstance(raw_children, dict):
            child_protos = [raw_children[k] for k in sorted(raw_children.keys(), key=lambda x: int(x))]
            child_idx_base = min((int(k) for k in raw_children.keys()), default=1)
        else:
            child_protos = list(raw_children)
            child_idx_base = 1
        n_params = int(proto.get(params_key, 0)) if params_key and params_key in proto else 0

        deferred_closures: list[tuple[int, Any]] = []
        lifted_children = [lift_proto(ch) for ch in child_protos]
        mc_uid = [0]
        consumed_vt = [False]

        def emit_multi_call(ca: dict, count: int, stmts_out: list[dict]) -> tuple[Sym, ...]:
            mc_uid[0] += 1
            base_idx = 900 + mc_uid[0] * 8
            t_vars = [_ident(rn(base_idx + si)) for si in range(count)]
            stmts_out.append({
                "type": "AssignmentStatement",
                "variables": t_vars,
                "init": [copy.deepcopy(ca)],
            })
            return tuple(Sym(_ident(rn(base_idx + si))) for si in range(count))

        W_bank = _RegBank(p_prefix)
        up_bank = _UpvalBank(64)
        code_tbl = _CodeTable21(code_init)
        handlers_tbl = _ConcreteTable({op: _HandlerRef21(op) for op in op_map})

        # Build `s_frame` matching `root_frame` + `proto`!
        frame_tbl = _ConcreteTable({
            int(code_key): code_tbl,
        })
        if protos_key and protos_key.isdigit():
            frame_tbl.put(
                int(protos_key),
                _ConcreteTable({idx + child_idx_base: _ChildProtoRef(idx) for idx in range(len(child_protos))}),
            )
        if upvals_key is not None:
            frame_tbl.put(upvals_key, up_bank)
        for fk, frole in frame_roles.items():
            if frole == "handlers":
                frame_tbl.put(fk, handlers_tbl)
            elif frole == "env":
                frame_tbl.put(fk, EnvSentinel())
            elif frole == "weak_mt":
                frame_tbl.put(fk, _ConcreteTable({"__mode": "vs"}))
            else:
                frame_tbl.put(fk, _BuiltinTag(frole))
        for pk, pv in proto.items():
            if pk not in (code_key, protos_key) and pk.isdigit() and int(pk) not in frame_tbl.fields:
                frame_tbl.put(int(pk), pv if not isinstance(pv, list) else _ConcreteTable())

        def make_up_cell21(role_str: str) -> _ConcreteTable:
            if role_str == "env":
                val_obj: Any = EnvSentinel()
            elif role_str == "weak_mt":
                val_obj = _ConcreteTable({"__mode": "vs"})
            elif role_str.startswith("export_res:") or role_str.startswith("export_wid:"):
                enm_r = role_str.split(":", 1)[1]
                if enm_r in closure_ctor_exports:
                    val_obj = _BuiltinTag("closure_ctor")
                else:
                    val_obj = _BuiltinTag(role_str)
            else:
                val_obj = _BuiltinTag(role_str)
            cell = _ConcreteTable({cell_key_slot: "__V21__", "__V21__": val_obj, "value": val_obj})
            cell.put(cell_tbl_slot, cell)
            return cell

        def eval_expr_sym(node: dict, env: dict[str, Any], stmts: list[dict], multi: bool = False) -> Any:
            nt = node["type"]
            if nt == "NumericLiteral":
                v = node["value"]
                return int(v) if v == int(v) else float(v)
            if nt == "StringLiteral":
                return node["value"]
            if nt == "BooleanLiteral":
                return bool(node["value"])
            if nt == "NilLiteral":
                return None
            if nt == "Identifier":
                return env.get(node["name"])
            if nt == "TableConstructorExpression":
                ct = _ConcreteTable()
                arr_i = 1
                for fld in node["fields"]:
                    if fld["type"] == "TableValue":
                        ct.put(arr_i, eval_expr_sym(fld["value"], env, stmts))
                        arr_i += 1
                    elif fld["type"] == "TableKeyString":
                        ct.put(fld["key"]["name"], eval_expr_sym(fld["value"], env, stmts))
                    else:
                        ct.put(eval_expr_sym(fld["key"], env, stmts), eval_expr_sym(fld["value"], env, stmts))
                return ct
            if nt in ("MemberExpression", "IndexExpression"):
                base = eval_expr_sym(node["base"], env, stmts)
                k = node["identifier"]["name"] if nt == "MemberExpression" else eval_expr_sym(node["index"], env, stmts)
                if isinstance(base, _BuiltinTag) and base.role == "ctx":
                    return _BuiltinTag("ctx." + str(k))
                if isinstance(base, _CodeTable21):
                    return base.get(k)
                if isinstance(base, _ConcreteTable):
                    return base.get(k)
                if isinstance(base, _RegBank):
                    return base.read(int(k))
                if isinstance(base, _UpvalBank):
                    return base.get_cell(int(k))
                if isinstance(base, RetPack):
                    if k == "n":
                        return RetCount(base.call_ast)
                    if k == 1 and base.last_dst is not None:
                        return Sym(_ident(rn(base.last_dst)))
                    return None
                if isinstance(base, OuterUpvalCell):
                    if k == "value":
                        return Sym(_ident(f"__up_{base.up_idx}"))
                    if k == cell_tbl_slot:
                        return base
                    if k == cell_key_slot:
                        return "__VAL__"
                    return Sym(_ident(f"__up_{base.up_idx}"))
                if isinstance(base, OpenUpvalCell):
                    if k == "value":
                        return Sym(_ident(rn(base.reg_idx)))
                    if k == cell_tbl_slot:
                        return W_bank
                    if k == cell_key_slot:
                        return base.reg_idx
                    return Sym(_ident(rn(base.reg_idx)))
                if isinstance(base, EnvSentinel):
                    if isinstance(k, str) and re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", k) and k not in KEYWORDS:
                        return Sym(_ident(k))
                    return Sym(_member_or_index(to_ast(base), k))
                if is_symbolic(base) or is_symbolic(k):
                    return Sym(_member_or_index(to_ast(base), k))
                return None

            if nt == "UnaryExpression":
                op = node["operator"]
                arg = eval_expr_sym(node["argument"], env, stmts)
                if not is_symbolic(arg):
                    if op == "-":
                        v = -arg
                        return int(v) if isinstance(v, float) and v == int(v) else v
                    if op == "not":
                        return not (arg is not None and arg is not False)
                    if op == "#":
                        if isinstance(arg, (str, _CodeTable21)):
                            return len(arg)
                        if isinstance(arg, _ConcreteTable):
                            n = 0
                            while (n + 1) in arg.fields and arg.fields[n + 1] is not None:
                                n += 1
                            return n
                        return 0
                return Sym({"type": "UnaryExpression", "operator": op, "argument": to_ast(arg), "prefix": True})

            if nt in ("BinaryExpression", "LogicalExpression"):
                op = node["operator"]
                lv = eval_expr_sym(node["left"], env, stmts)
                if op == "and":
                    if not is_symbolic(lv):
                        return eval_expr_sym(node["right"], env, stmts) if (lv is not None and lv is not False) else lv
                    rv = eval_expr_sym(node["right"], env, stmts)
                    return Sym({"type": "LogicalExpression", "operator": "and", "left": to_ast(lv), "right": to_ast(rv)})
                if op == "or":
                    if not is_symbolic(lv):
                        return lv if (lv is not None and lv is not False) else eval_expr_sym(node["right"], env, stmts)
                    rv = eval_expr_sym(node["right"], env, stmts)
                    return Sym({"type": "LogicalExpression", "operator": "or", "left": to_ast(lv), "right": to_ast(rv)})

                rv = eval_expr_sym(node["right"], env, stmts)
                if isinstance(lv, VarTop) and isinstance(rv, (int, float)):
                    if op == "-":
                        return VarTop(lv.base_reg - int(rv), lv.tail_ast)
                    if op == "+":
                        return VarTop(lv.base_reg + int(rv), lv.tail_ast)
                if isinstance(rv, VarTop) and isinstance(lv, (int, float)) and op == "+":
                    return VarTop(int(lv) + rv.base_reg, rv.tail_ast)
                if isinstance(lv, RetCount) and isinstance(rv, (int, float)):
                    if op == "-":
                        return VarTop(-int(rv), lv.call_ast)
                    if op == "+":
                        return VarTop(int(rv), lv.call_ast)
                if isinstance(rv, RetCount) and isinstance(lv, (int, float)) and op == "+":
                    return VarTop(int(lv), rv.call_ast)
                if isinstance(lv, VarargCount) and isinstance(rv, (int, float)):
                    va_lit = {"type": "VarargLiteral", "value": "...", "raw": "..."}
                    if op == "-":
                        return VarTop(-int(rv), va_lit)
                    if op == "+":
                        return VarTop(int(rv), va_lit)
                if isinstance(rv, VarargCount) and isinstance(lv, (int, float)) and op == "+":
                    return VarTop(int(lv), {"type": "VarargLiteral", "value": "...", "raw": "..."})

                if not is_symbolic(lv) and not is_symbolic(rv):
                    if op == "+":
                        res = lv + rv
                    elif op == "-":
                        res = lv - rv
                    elif op == "*":
                        res = lv * rv
                    elif op == "/":
                        res = lv / rv
                    elif op == "%":
                        res = lv % rv
                    elif op == "^":
                        res = lv ** rv
                    elif op == "..":
                        res = str(lv) + str(rv)
                    elif op == "==":
                        return lv == rv
                    elif op == "~=":
                        return lv != rv
                    elif op == "<":
                        return lv < rv
                    elif op == "<=":
                        return lv <= rv
                    elif op == ">":
                        return lv > rv
                    elif op == ">=":
                        return lv >= rv
                    else:
                        raise Unsupported(f"Unknown binary op {op}")
                    if isinstance(res, float) and math.isfinite(res) and res == int(res) and abs(res) < 1e15:
                        return int(res)
                    return res

                return Sym({"type": "BinaryExpression", "operator": op, "left": to_ast(lv), "right": to_ast(rv)})

            if nt in ("CallExpression", "TableCallExpression", "StringCallExpression"):
                if nt == "CallExpression" and node["base"]["type"] == "MemberExpression" and node["base"]["indexer"] == ":":
                    self_v = eval_expr_sym(node["base"]["base"], env, stmts)
                    m_name = node["base"]["identifier"]["name"]
                    fn_v = _BuiltinTag("ctx." + m_name) if (isinstance(self_v, _BuiltinTag) and self_v.role == "ctx") else Sym(_member_or_index(to_ast(self_v), m_name))
                    raw_args = node["arguments"]
                    args = [self_v]
                else:
                    fn_v = eval_expr_sym(node["base"], env, stmts)
                    raw_args = (
                        node["arguments"]
                        if nt == "CallExpression"
                        else [node["arguments"] if nt == "TableCallExpression" else node["argument"]]
                    )
                    args = []
                for ai, an in enumerate(raw_args):
                    av = eval_expr_sym(an, env, stmts, multi=(ai == len(raw_args) - 1 and not an.get("inParens")))
                    if isinstance(av, tuple):
                        args.extend(av)
                    else:
                        args.append(av)
                res_tuple = invoke_sym(fn_v, args, env, stmts)
                if multi and not node.get("inParens"):
                    return res_tuple
                return res_tuple[0] if res_tuple else None

            raise Unsupported(f"Unsupported 2.1.x VM expr: {nt}")

        def invoke_sym(fn_v: Any, args: list[Any], env: dict[str, Any], stmts: list[dict]) -> tuple[Any, ...]:
            if isinstance(fn_v, _HandlerRef21):
                raise _HandlerCallSignal(fn_v.op, args)

            if isinstance(fn_v, _BuiltinTag):
                r = fn_v.role
                if r.startswith("ctx."):
                    cname = r.split(".", 1)[1]
                    crole = ctx_roles.get(cname, "")
                    if crole == "pack":
                        return (_ConcreteTable({1: list(args), 2: len(args)}),)
                    if crole == "unpack":
                        packed = args[0]
                        if isinstance(packed, _ConcreteTable):
                            items = packed.get(1)
                            if isinstance(items, list):
                                return tuple(items)
                        return ()
                    if crole == "setmult":
                        dst_t, start_i = args[0], int(args[1])
                        rest = args[2:]
                        if isinstance(dst_t, _ConcreteTable):
                            for off_i, rv_i in enumerate(rest):
                                dst_t.put(start_i + off_i, rv_i)
                        elif isinstance(dst_t, _RegBank):
                            if len(rest) == 1 and isinstance(rest[0], MultiRetCall):
                                # Store result into `start_i` so subsequent `CALL B=0` (`top = start_i + 1 - 1`) reads it!
                                dst_t.write(start_i, Sym(copy.deepcopy(rest[0].call_ast)), stmts)
                            else:
                                for off_i, rv_i in enumerate(rest):
                                    dst_t.write(start_i + off_i, rv_i, stmts)
                        else:
                            tbl_ast = to_ast(dst_t)
                            for off_i, rv_i in enumerate(rest):
                                val_ast = copy.deepcopy(rv_i.call_ast) if isinstance(rv_i, MultiRetCall) else to_ast(rv_i)
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [{"type": "IndexExpression", "base": copy.deepcopy(tbl_ast), "index": _lit(start_i + off_i)}],
                                    "init": [val_ast],
                                })
                        return ()
                    if crole == "iter":
                        if isinstance(args[0], _BuiltinTag):
                            return tuple(args[:3])
                        if isinstance(args[0], _ConcreteTable):
                            keys = list(args[0].fields.keys())
                            it_state = {"idx": 0, "keys": keys, "tbl": args[0]}
                            return (_BuiltinTag("concrete_next"), it_state, None)
                        # Symbolic `g.g(f, s, var)` in `FORGPREP` -> emit `r_N, r_{N+1}, r_{N+2} = __mv_iter__(...)`!
                        call_it = {
                            "type": "CallExpression",
                            "base": _ident("__mv_iter__"),
                            "arguments": [to_ast(a) for a in args[:3]],
                        }
                        return emit_multi_call(call_it, 3, stmts)
                    # Evaluate concrete `ctx.<helper>` (`a.y`, `a.m`, `a.o`, `a.q`, `a.t`, `a.v`, etc.) via `dec.evaluator`!
                    if not any(is_symbolic(a) for a in args):
                        ctx_fn = dec.context.get(cname.encode("ascii"))
                        if ctx_fn is not None:
                            ev_args = [
                                dec.context if (isinstance(a, _BuiltinTag) and a.role == "ctx")
                                else (a.encode("latin1") if isinstance(a, str) else (float(a) if isinstance(a, int) and not isinstance(a, bool) else a))
                                for a in args
                            ]
                            ev_res = dec.evaluator.call(ctx_fn, tuple(ev_args))
                            if not isinstance(ev_res, tuple):
                                ev_res = (ev_res,)
                            return tuple(
                                rv.decode("latin1") if isinstance(rv, bytes)
                                else (int(rv) if isinstance(rv, float) and math.isfinite(rv) and rv == int(rv) and abs(rv) < 1e15 else rv)
                                for rv in ev_res
                            )
                    # Symbolic `ctx.<helper>` (`g.y` = SHA-256, `g.v` = ChaCha20, `g.t` = LZ decompress) when runtime key is symbolic!
                    sym_helper_names = {"y": "__mv_sha256", "v": "__mv_chacha20", "t": "__mv_lz_decomp", "q": "__mv_b85_dec"}
                    fn_ident_nm = sym_helper_names.get(cname, f"__mv_ctx_{cname}")
                    return (
                        Sym({
                            "type": "CallExpression",
                            "base": _ident(fn_ident_nm),
                            "arguments": [to_ast(a) for a in args if not (isinstance(a, _BuiltinTag) and a.role == "ctx")],
                        }),
                    )

                conc = _eval_concrete_builtin(r, args)
                if conc is not None:
                    return conc

                if r == "concrete_gmatch_iter":
                    st_g = args[0]
                    if st_g["idx"] >= len(st_g["items"]):
                        return (None,)
                    ch_g = st_g["items"][st_g["idx"]]
                    st_g["idx"] += 1
                    return (ch_g,)
                if r == "concrete_next":
                    st_d = args[0]
                    if st_d["idx"] >= len(st_d["keys"]):
                        return (None, None)
                    k_next = st_d["keys"][st_d["idx"]]
                    st_d["idx"] += 1
                    return (k_next, st_d["tbl"].get(k_next))
                if r == "setmetatable":
                    return (args[0],)
                if r == "table.create":
                    return (_ConcreteTable(),)
                if r == "getmetatable":
                    return (None,)
                if r == "type":
                    h_ups_cur = env.get("__h_ups__") or ()
                    if "string.gmatch" in h_ups_cur and "tonumber" in h_ups_cur:
                        return ("number",)
                    if "string.gmatch" in h_ups_cur and "pairs" in h_ups_cur:
                        # `FORGPREP` + `TFORLOOP`: normalize iterator triple via `__mv_iter__` once, then fast-path as `"function"`!
                        if not env.get("__forgprep_emitted__") and isinstance(args[0], Sym) and args[0].ast.get("type") == "Identifier":
                            r_nm0 = args[0].ast["name"]
                            if r_nm0.startswith(p_prefix):
                                base_r = int(r_nm0[len(p_prefix) :])
                                env["__forgprep_emitted__"] = True
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [_ident(rn(base_r)), _ident(rn(base_r + 1)), _ident(rn(base_r + 2))],
                                    "init": [{
                                        "type": "CallExpression",
                                        "base": _ident("__mv_iter__"),
                                        "arguments": [_ident(rn(base_r)), _ident(rn(base_r + 1)), _ident(rn(base_r + 2))],
                                    }],
                                })
                        return ("function",)
                    return (Sym({"type": "CallExpression", "base": _ident("type"), "arguments": [to_ast(args[0])]}),)
                if r in ("type", "tostring", "tonumber", "select", "pairs", "ipairs", "next", "pcall", "rawequal", "rawget", "rawset", "rawlen") or r.startswith(("bit32.", "string.", "math.")):
                    base_ast = (
                        {"type": "MemberExpression", "base": _ident(r.split(".")[0]), "indexer": ".", "identifier": _ident(r.split(".")[1])}
                        if "." in r
                        else _ident(r)
                    )
                    call_b = {"type": "CallExpression", "base": base_ast, "arguments": [to_ast(a) for a in args]}
                    if r in ("pairs", "ipairs"):
                        return emit_multi_call(call_b, 3, stmts)
                    return (Sym(call_b),)
                if r == "table.pack":
                    if len(args) == 1 and isinstance(args[0], MultiRetCall):
                        return (RetPack(args[0].call_ast),)
                    ct_p = _ConcreteTable({i + 1: a for i, a in enumerate(args)})
                    ct_p.put("n", len(args))
                    return (ct_p,)
                if r == "unpack_slice":
                    src_tbl = args[0]
                    a_idx = int(args[1]) if len(args) >= 2 and args[1] is not None else 1
                    b_idx = args[2] if len(args) >= 3 else None
                    if isinstance(src_tbl, _ConcreteTable):
                        b_lim = int(b_idx) if b_idx is not None else len(src_tbl.fields)
                        return tuple(src_tbl.get(k) for k in range(a_idx, b_lim + 1))
                    if isinstance(b_idx, VarTop):
                        consumed_vt[0] = True
                        out = [Sym(_ident(rn(k))) for k in range(a_idx, b_idx.base_reg + 1)]
                        out.append(Sym(b_idx.tail_ast))
                        return tuple(out)
                    b_int = int(b_idx) if b_idx is not None else a_idx - 1
                    if b_int < a_idx:
                        return ()
                    return tuple(Sym(_ident(rn(k))) for k in range(a_idx, b_int + 1))
                if r == "table.move":
                    src_m, a_m, b_m, dst_start, dst_m = args[0], int(args[1]), args[2], int(args[3]), args[4]
                    if isinstance(src_m, _RegBank) and isinstance(b_m, VarTop):
                        consumed_vt[0] = True
                    if isinstance(src_m, RetPack) and isinstance(dst_m, _RegBank):
                        src_m.last_dst = dst_start
                        if isinstance(b_m, (RetCount, VarTop)):
                            return (dst_m,)
                        cnt = int(b_m) - a_m + 1
                        if cnt <= 0:
                            stmts.append({"type": "CallStatement", "expression": copy.deepcopy(src_m.call_ast)})
                        else:
                            stmts.append({
                                "type": "AssignmentStatement",
                                "variables": [_ident(rn(dst_start + j)) for j in range(cnt)],
                                "init": [copy.deepcopy(src_m.call_ast)],
                            })
                        return (dst_m,)
                    if isinstance(src_m, VarargTable) and isinstance(dst_m, _RegBank):
                        if isinstance(b_m, (VarargCount, VarTop)):
                            return (dst_m,)
                        cnt = int(b_m) - a_m + 1
                        if cnt > 0:
                            stmts.append({
                                "type": "AssignmentStatement",
                                "variables": [_ident(rn(dst_start + j)) for j in range(cnt)],
                                "init": [{"type": "VarargLiteral", "value": "...", "raw": "..."}],
                            })
                        return (dst_m,)
                    if isinstance(src_m, _RegBank) and isinstance(dst_m, (SymTable, Sym)):
                        tbl_ref = dst_m.reg_ast if isinstance(dst_m, SymTable) else dst_m.ast
                        if tbl_ref is None:
                            tbl_ref = _ident(rn(0))
                        if isinstance(b_m, VarTop):
                            stmts.append({
                                "type": "AssignmentStatement",
                                "variables": [copy.deepcopy(tbl_ref)],
                                "init": [{
                                    "type": "TableConstructorExpression",
                                    "fields": [
                                        {"type": "TableValue", "value": _ident(rn(r_k))}
                                        for r_k in range(a_m, b_m.base_reg + 1)
                                    ] + [{"type": "TableValue", "value": copy.deepcopy(b_m.tail_ast)}],
                                }],
                            })
                        else:
                            for k_i, r_k in enumerate(range(a_m, int(b_m) + 1)):
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [{"type": "IndexExpression", "base": copy.deepcopy(tbl_ref), "index": _lit(dst_start + k_i)}],
                                    "init": [_ident(rn(r_k))],
                                })
                        return (dst_m,)
                    return (dst_m,)
                if r == "closure_ctor":
                    ch_marker = next((a for a in args if isinstance(a, _ChildProtoRef)), args[0])
                    cap_tbl = next((a for a in args if isinstance(a, _ConcreteTable)), args[1] if len(args) > 1 else None)
                    if isinstance(ch_marker, _ChildProtoRef):
                        def_id = len(deferred_closures)
                        deferred_closures.append((ch_marker.idx, cap_tbl))
                        return (Sym({"type": "__DeferredClosure__", "def_id": def_id}),)
                    return (Sym({"type": "CallExpression", "base": _ident("__mv_closure"), "arguments": [to_ast(ch_marker)]}),)
                if r.startswith(("export_res:", "export_wid:")):
                    enm_s = r.split(":", 1)[1]
                    return (Sym({"type": "CallExpression", "base": _ident(f"__mv_proto_dec_{enm_s}"), "arguments": [to_ast(a) for a in args]}),)

            call_ast = {
                "type": "CallExpression",
                "base": to_ast(fn_v),
                "arguments": [to_ast(a) for a in args],
            }
            # Support `e, A, q, i = e(A, q)` multi-assignment inside `TFORLOOP`!
            return (MultiRetCall(call_ast),)

        def exec_stmt_list(stmt_list: list[dict], env: dict[str, Any], stmts: list[dict]) -> list[Any] | None:
            for s in stmt_list:
                st_type = s["type"]
                if st_type in ("AssignmentStatement", "LocalStatement"):
                    vals: list[Any] = []
                    inits = s.get("init", [])
                    n_lhs = len(s["variables"])
                    for ii, ie in enumerate(inits):
                        is_last = ii == len(inits) - 1 and not ie.get("inParens")
                        v = eval_expr_sym(ie, env, stmts, multi=is_last)
                        if isinstance(v, tuple):
                            if is_last and len(v) == 1 and isinstance(v[0], MultiRetCall) and n_lhs - len(vals) > 1:
                                need = n_lhs - len(vals)
                                vals.extend(emit_multi_call(v[0].call_ast, need, stmts))
                            else:
                                vals.extend(v)
                        else:
                            vals.append(v)
                    # Coalesce adjacent `MultiCallSlot` writes into registers!
                    for vi, lhs in enumerate(s["variables"]):
                        rhs_val = vals[vi] if vi < len(vals) else None
                        if lhs["type"] == "Identifier":
                            env[lhs["name"]] = rhs_val
                        elif lhs["type"] in ("IndexExpression", "MemberExpression"):
                            b_obj = eval_expr_sym(lhs["base"], env, stmts)
                            k_obj = lhs["identifier"]["name"] if lhs["type"] == "MemberExpression" else eval_expr_sym(lhs["index"], env, stmts)
                            if isinstance(b_obj, _RegBank):
                                r_written = int(k_obj)
                                b_obj.write(r_written, rhs_val, stmts)
                                if isinstance(rhs_val, Sym):
                                    reg_sym = Sym(_ident(rn(r_written)))
                                    for ek, ev in list(env.items()):
                                        if ev is rhs_val:
                                            env[ek] = reg_sym
                            elif isinstance(b_obj, _CodeTable21):
                                b_obj.put(k_obj, rhs_val)
                            elif isinstance(b_obj, _ConcreteTable):
                                if (
                                    isinstance(rhs_val, _ConcreteTable)
                                    and isinstance(rhs_val.get(cell_tbl_slot), _RegBank)
                                    and isinstance(rhs_val.get(cell_key_slot), (int, float))
                                ):
                                    b_obj.put(k_obj, OpenUpvalCell(int(rhs_val.get(cell_key_slot))))
                                else:
                                    b_obj.put(k_obj, rhs_val)
                            elif isinstance(b_obj, OuterUpvalCell):
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [_ident(f"__up_{b_obj.up_idx}")],
                                    "init": [to_ast(rhs_val)],
                                })
                            elif isinstance(b_obj, OpenUpvalCell):
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [_ident(rn(b_obj.reg_idx))],
                                    "init": [to_ast(rhs_val)],
                                })
                            elif isinstance(b_obj, EnvSentinel):
                                lhs_ast = (
                                    _ident(k_obj)
                                    if isinstance(k_obj, str) and re.fullmatch(r"[A-Za-z_][A-Za-z_0-9]*", k_obj) and k_obj not in KEYWORDS
                                    else _member_or_index(to_ast(b_obj), k_obj)
                                )
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [lhs_ast],
                                    "init": [to_ast(rhs_val)],
                                })
                            else:
                                stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [_member_or_index(to_ast(b_obj), k_obj)],
                                    "init": [to_ast(rhs_val)],
                                })
                elif st_type == "CallStatement":
                    eval_expr_sym(s["expression"], env, stmts, multi=False)
                elif st_type == "ReturnStatement":
                    ret_args: list[Any] = []
                    for ri, re_node in enumerate(s["arguments"]):
                        rv = eval_expr_sym(re_node, env, stmts, multi=(ri == len(s["arguments"]) - 1 and not re_node.get("inParens")))
                        if isinstance(rv, tuple):
                            ret_args.extend(rv)
                        else:
                            ret_args.append(rv)
                    return ret_args
            return None

        def exec_linear_stmts(s_list: list[dict], env_h: dict[str, Any], stmts_h: list[dict]) -> dict:
            for idx_l, st_l in enumerate(s_list):
                if st_l["type"] == "IfStatement":
                    rest_l = s_list[idx_l + 1 :]

                    def eval_clauses(c_idx: int, e_cur: dict[str, Any], st_cur: list[dict]) -> dict:
                        if c_idx >= len(st_l["clauses"]):
                            return exec_linear_stmts(rest_l, e_cur, st_cur)
                        cl = st_l["clauses"][c_idx]
                        if cl["type"] == "ElseClause":
                            return exec_linear_stmts(cl["body"] + rest_l, e_cur, st_cur)
                        cv = eval_expr_sym(cl["condition"], e_cur, st_cur)
                        if isinstance(cv, (VarTop, RetCount, VarargCount)):
                            cv = True
                        if not is_symbolic(cv):
                            if cv is not None and cv is not False:
                                return exec_linear_stmts(cl["body"] + rest_l, e_cur, st_cur)
                            return eval_clauses(c_idx + 1, e_cur, st_cur)
                        ey = dict(e_cur)
                        en = dict(e_cur)
                        ry = exec_linear_stmts(cl["body"] + rest_l, ey, [])
                        rn_a = eval_clauses(c_idx + 1, en, [])
                        return {"kind": "h_branch", "stmts": st_cur, "cond": to_ast(cv), "yes": ry, "no": rn_a}

                    return eval_clauses(0, env_h, stmts_h)
                rv = exec_stmt_list([st_l], env_h, stmts_h)
                if rv is not None:
                    return {"kind": "h_ret", "stmts": stmts_h, "rets": tuple(rv)}
            return {"kind": "h_ret", "stmts": stmts_h, "rets": ()}

        def run_handler(op: int, h_args: list[Any], stmts: list[dict]) -> dict:
            spec = get_handler_spec(op)
            h_gr = spec["gr"]
            h_env: dict[str, Any] = {spec["ctx_nm"]: _BuiltinTag("ctx"), "__h_ups__": tuple(spec["ups"])}
            if spec["up_nm"]:
                up_ct = _ConcreteTable({i + 1: make_up_cell21(r_s) for i, r_s in enumerate(spec["ups"])})
                h_env[spec["up_nm"]] = up_ct
            for pi, pnm in enumerate(spec["params"]):
                h_env[pnm] = h_args[pi] if pi < len(h_args) else None
            if h_gr is None:
                h_inner = clean(dec.exports[spec["export"]])["body"][0]["arguments"][0]
                return exec_linear_stmts(h_inner["body"], h_env, stmts)
            exec_stmt_list(h_gr["prefix"], h_env, stmts)

            def step_h(cur_h: int, env_h: dict[str, Any], stmts_h: list[dict], budget: int = 0) -> dict:
                cur = cur_h
                steps = budget
                while True:
                    steps += 1
                    if steps > 40000:
                        raise Unsupported(f"MoonVeil 2.1.x handler {spec['export']} (op={op}) exceeded step budget")
                    nd_h = h_gr["nodes"][cur]
                    ret_vals = exec_stmt_list(nd_h["stmts"], env_h, stmts_h)
                    if ret_vals is not None:
                        return {"kind": "h_ret", "stmts": stmts_h, "rets": tuple(ret_vals)}
                    tm_h = nd_h["term"]
                    if "return" in tm_h:
                        return {"kind": "h_ret", "stmts": stmts_h, "rets": ()}
                    if "goto" in tm_h:
                        cur = tm_h["goto"]
                    else:
                        cond_v = eval_expr_sym(tm_h["cond"], env_h, stmts_h)
                        if isinstance(cond_v, (VarTop, RetCount, VarargCount)):
                            cond_v = True
                        if not is_symbolic(cond_v):
                            cur = tm_h["yes"]["goto"] if (cond_v is not None and cond_v is not False) else tm_h["no"]["goto"]
                        else:
                            ey = dict(env_h)
                            en = dict(env_h)
                            ry = step_h(tm_h["yes"]["goto"], ey, [], steps)
                            rn_arm = step_h(tm_h["no"]["goto"], en, [], steps)
                            return {
                                "kind": "h_branch",
                                "stmts": stmts_h,
                                "cond": to_ast(cond_v),
                                "yes": ry,
                                "no": rn_arm,
                            }

            return step_h(h_gr["start"], h_env, stmts)

        # Initialize `nd` prelude up to `nd_dispatch` using detected `nd_arg_roles`!
        nd_arg_roles: dict[str, str] = bundle.get("nd_arg_roles") or {"1": "upvals", "2": "frame", "3": "vararg", "4": "regs"}
        role_val_map: dict[str, Any] = {
            "upvals": _ConcreteTable(),
            "frame": frame_tbl,
            "vararg": _ConcreteTable({
                vararg_tbl_key: VarargTable(),
                vararg_cnt_key: VarargCount(),
            }),
            "regs": W_bank,
        }
        nd_up_cell = _ConcreteTable({cell_key_slot: "__V21__", "__V21__": handlers_tbl, "value": handlers_tbl})
        nd_up_cell.put(cell_tbl_slot, nd_up_cell)
        nd_base_env: dict[str, Any] = {
            nd_ctx_param: _BuiltinTag("ctx"),
            nd_up_param: _ConcreteTable({1: nd_up_cell}),
        }
        for p_idx0, p_nm in enumerate(nd_params):
            r_nm = nd_arg_roles.get(str(p_idx0 + 1), "upvals")
            if r_nm.startswith("frame_field:"):
                ff_k = r_nm.split(":", 1)[1]
                nd_base_env[p_nm] = frame_tbl.get(int(ff_k) if ff_k.isdigit() else ff_k)
            elif r_nm.startswith("fn:"):
                nd_base_env[p_nm] = _BuiltinTag(r_nm.split(":", 1)[1])
            else:
                nd_base_env[p_nm] = role_val_map.get(r_nm, _ConcreteTable())
        init_stmts: list[dict] = []
        exec_stmt_list(nd_gr["prefix"], nd_base_env, init_stmts)
        cur_nd = nd_gr["start"]
        while cur_nd != nd_dispatch:
            exec_stmt_list(nd_gr["nodes"][cur_nd]["stmts"], nd_base_env, init_stmts)
            cur_nd = nd_gr["nodes"][cur_nd]["term"]["goto"]

        # Identify `pc_var` (`1`) and `top_var` (`-1`) in `nd_base_env`!
        pc_var = next(k for k, v in nd_base_env.items() if v == 1 and type(v) is int)
        top_var = next((k for k, v in nd_base_env.items() if v == -1 and type(v) is int), None)

        # Find the statement index in `nd_gr["nodes"][nd_dispatch]["stmts"]` that calls the handler!
        disp_stmts = nd_gr["nodes"][nd_dispatch]["stmts"]

        def finish_nd_from_rets(
            h_tree: dict,
            post_stmt_idx: int,
            call_lhs_vars: list[dict],
            env_after_args: dict[str, Any],
        ) -> dict:
            if h_tree["kind"] == "h_branch":
                return {
                    "kind": "branch",
                    "stmts": _coalesce_multicall_stmts(h_tree["stmts"]),
                    "cond": h_tree["cond"],
                    "yes": finish_nd_from_rets(h_tree["yes"], post_stmt_idx, call_lhs_vars, dict(env_after_args)),
                    "no": finish_nd_from_rets(h_tree["no"], post_stmt_idx, call_lhs_vars, dict(env_after_args)),
                }
            env_c = dict(env_after_args)
            stmts_c = _coalesce_multicall_stmts(list(h_tree["stmts"]))
            rets = h_tree["rets"]
            for vi, lhs in enumerate(call_lhs_vars):
                env_c[lhs["name"]] = rets[vi] if vi < len(rets) else None
            ret_nd = exec_stmt_list(disp_stmts[post_stmt_idx + 1 :], env_c, stmts_c)
            if ret_nd is not None:
                stmts_c.append({"type": "ReturnStatement", "arguments": [to_ast(a) for a in ret_nd]})
                return {"kind": "return", "stmts": stmts_c}
            cur = nd_dispatch
            first = True
            steps = 0
            while True:
                steps += 1
                if steps > 100:
                    raise Unsupported("MoonVeil 2.1.x driver post-step exceeded budget")
                if not first and cur == nd_dispatch:
                    nxt_pc = int(env_c[pc_var])
                    nxt_top = env_c.get(top_var) if top_var else -1
                    return {
                        "kind": "jump",
                        "pc": nxt_pc,
                        "stmts": stmts_c,
                        "var_top": nxt_top if isinstance(nxt_top, VarTop) else None,
                    }
                if not first:
                    ret_nd2 = exec_stmt_list(nd_gr["nodes"][cur]["stmts"], env_c, stmts_c)
                    if ret_nd2 is not None:
                        stmts_c.append({"type": "ReturnStatement", "arguments": [to_ast(a) for a in ret_nd2]})
                        return {"kind": "return", "stmts": stmts_c}
                first = False
                tm = nd_gr["nodes"][cur]["term"]
                if "return" in tm:
                    return {"kind": "return", "stmts": stmts_c}
                if "goto" in tm:
                    cur = tm["goto"]
                else:
                    cv = eval_expr_sym(tm["cond"], env_c, stmts_c)
                    cur = tm["yes"]["goto"] if (cv is not None and cv is not False) else tm["no"]["goto"]

        def step_pc(pc_val: int, v_in: VarTop | None) -> dict:
            consumed_vt[0] = False
            env = {
                ek: (_ConcreteTable() if isinstance(ev, _ConcreteTable) and not ev.fields else ev)
                for ek, ev in nd_base_env.items()
            }
            env[pc_var] = pc_val
            if top_var:
                env[top_var] = v_in if v_in is not None else -1
            stmts: list[dict] = []
            for idx_s, st in enumerate(disp_stmts):
                try:
                    exec_stmt_list([st], env, stmts)
                except _HandlerCallSignal as sig:
                    h_tree = run_handler(sig.op, sig.args, stmts)
                    res_out = finish_nd_from_rets(h_tree, idx_s, st["variables"], env)
                    if v_in is not None and consumed_vt[0] and res_out.get("var_top") is v_in:
                        res_out["var_top"] = None
                    return res_out
            raise Unsupported(f"MoonVeil 2.1.x driver did not invoke handler at pc={pc_val}")

        # Explore reachable PCs in FIFO order so basic-block `DECRYPT_BLOCK` / `DECRYPT_STR` headers
        # always execute before subsequent instructions in the same block!
        pc_nodes: dict[int, dict] = {}
        todo: list[tuple[int, VarTop | None]] = [(1, None)]
        while todo:
            pc, v_in = todo.pop(0)
            if pc in pc_nodes:
                continue
            if pc < 1 or pc > len(code_init):
                pc_nodes[pc] = {"stmts": [{"type": "ReturnStatement", "arguments": []}], "term": {"return": True}}
                continue
            res = step_pc(pc, v_in)
            if res["kind"] == "return":
                pc_nodes[pc] = {"stmts": res["stmts"], "term": {"return": True}}
            elif res["kind"] == "jump":
                cur_res = res
                acc_stmts = list(res["stmts"])
                while cur_res["kind"] == "jump" and cur_res.get("var_top") is not None:
                    cur_res = step_pc(cur_res["pc"], cur_res["var_top"])
                    acc_stmts.extend(cur_res["stmts"])
                if cur_res["kind"] == "return":
                    pc_nodes[pc] = {"stmts": acc_stmts, "term": {"return": True}}
                elif cur_res["kind"] == "jump":
                    pc_nodes[pc] = {"stmts": acc_stmts, "term": {"goto": cur_res["pc"]}}
                    todo.append((cur_res["pc"], None))
                else:
                    pc_nodes[pc] = _finalize_branch_node(acc_stmts, cur_res, pc_nodes, todo, 100000 + pc * 10)
            else:
                pc_nodes[pc] = _finalize_branch_node(res["stmts"], res, pc_nodes, todo, 100000 + pc * 10)

        # Resolve `__DeferredClosure__` nodes & structure prototype identically to `2.0.x`!
        def _written_idents(ast_obj: Any) -> set[str]:
            wset: set[str] = set()
            for n in walk(ast_obj):
                if isinstance(n, dict) and n.get("type") == "AssignmentStatement":
                    for lv in n["variables"]:
                        if lv.get("type") == "Identifier":
                            wset.add(lv["name"])
            return wset

        write_count_parent: dict[str, int] = {}
        for nd in pc_nodes.values():
            for st_n in nd["stmts"]:
                if st_n.get("type") == "AssignmentStatement":
                    for lv in st_n["variables"]:
                        if lv.get("type") == "Identifier":
                            write_count_parent[lv["name"]] = write_count_parent.get(lv["name"], 0) + 1

        mutated_parent_regs: set[str] = set()
        for ch_idx, cap_tbl in deferred_closures:
            ch_writes = _written_idents(lifted_children[ch_idx]["body"])
            if isinstance(cap_tbl, _ConcreteTable):
                for u_slot, cell_obj in cap_tbl.fields.items():
                    if isinstance(u_slot, int) and f"__up_{u_slot}" in ch_writes:
                        if isinstance(cell_obj, OpenUpvalCell):
                            mutated_parent_regs.add(rn(cell_obj.reg_idx))
                        elif isinstance(cell_obj, _ConcreteTable) and (isinstance(cell_obj.get(1), _RegBank) or isinstance(cell_obj.get(2), _RegBank)):
                            mutated_parent_regs.add(rn(int(cell_obj.get(3))))

        def _rename_ident_all(ast_obj: Any, old_nm: str, new_nm: str) -> Any:
            if isinstance(ast_obj, list):
                return [_rename_ident_all(x, old_nm, new_nm) for x in ast_obj]
            if isinstance(ast_obj, dict):
                nt = ast_obj.get("type")
                if nt == "Identifier" and ast_obj.get("name") == old_nm:
                    return {**ast_obj, "name": new_nm}
                out_d = {}
                for dk, dv in ast_obj.items():
                    if nt == "MemberExpression" and dk == "identifier":
                        out_d[dk] = dv
                    elif nt == "TableKeyString" and dk == "key":
                        out_d[dk] = dv
                    else:
                        out_d[dk] = _rename_ident_all(dv, old_nm, new_nm)
                return out_d
            return ast_obj

        max_back_src = 0
        for src_pc, nd in pc_nodes.items():
            if src_pc >= 100000:
                continue
            tm = nd["term"]
            tgts = [tm["goto"]] if "goto" in tm else ([tm["yes"]["goto"], tm["no"]["goto"]] if "yes" in tm else [])
            for tg in tgts:
                if tg < 100000 and tg <= src_pc:
                    max_back_src = max(max_back_src, src_pc)

        cap_counter = [0]

        def _rename_idents_map(ast_obj: Any, rmap: dict[str, str]) -> Any:
            if not rmap:
                return ast_obj
            if isinstance(ast_obj, list):
                return [_rename_idents_map(x, rmap) for x in ast_obj]
            if isinstance(ast_obj, dict):
                nt = ast_obj.get("type")
                if nt == "Identifier" and ast_obj.get("name") in rmap:
                    return {**ast_obj, "name": rmap[ast_obj["name"]]}
                out_d = {}
                for dk, dv in ast_obj.items():
                    if nt == "MemberExpression" and dk == "identifier":
                        out_d[dk] = dv
                    elif nt == "TableKeyString" and dk == "key":
                        out_d[dk] = dv
                    else:
                        out_d[dk] = _rename_idents_map(dv, rmap)
                return out_d
            return ast_obj

        def _resolve_node_closures(obj: Any, pre_stmts: list[dict], in_loop_pc: bool) -> Any:
            if isinstance(obj, list):
                return [_resolve_node_closures(x, pre_stmts, in_loop_pc) for x in obj]
            if isinstance(obj, dict):
                if obj.get("type") == "__DeferredClosure__":
                    def_id = obj["def_id"]
                    ch_idx, cap_tbl = deferred_closures[def_id]
                    ch_fn = copy.deepcopy(lifted_children[ch_idx])
                    if isinstance(cap_tbl, _ConcreteTable):
                        up_map: dict[str, str] = {}
                        for u_slot, cell_obj in sorted((k, v) for k, v in cap_tbl.fields.items() if isinstance(k, int)):
                            u_name = f"__up_{int(u_slot)}"
                            if isinstance(cell_obj, OpenUpvalCell):
                                r_nm = rn(cell_obj.reg_idx)
                            elif (
                                isinstance(cell_obj, _ConcreteTable)
                                and isinstance(cell_obj.get(cell_tbl_slot), _RegBank)
                                and isinstance(cell_obj.get(cell_key_slot), (int, float))
                            ):
                                r_nm = rn(int(cell_obj.get(cell_key_slot)))
                            elif isinstance(cell_obj, OuterUpvalCell):
                                up_map[u_name] = f"__up_{cell_obj.up_idx}"
                                continue
                            else:
                                continue
                            if in_loop_pc and r_nm not in mutated_parent_regs and write_count_parent.get(r_nm, 0) > 1:
                                cap_counter[0] += 1
                                cap_nm = f"{cap_prefix}{cap_counter[0]}"
                                pre_stmts.append({
                                    "type": "AssignmentStatement",
                                    "variables": [_ident(cap_nm)],
                                    "init": [_ident(r_nm)],
                                })
                                up_map[u_name] = cap_nm
                            else:
                                up_map[u_name] = r_nm
                        ch_fn["body"] = _rename_idents_map(ch_fn["body"], up_map)
                    return ch_fn
                return {k: _resolve_node_closures(v, pre_stmts, in_loop_pc) for k, v in obj.items()}
            return obj

        for nid, nd in pc_nodes.items():
            in_lp = nid <= max_back_src
            new_s: list[dict] = []
            for st_item in nd["stmts"]:
                pre: list[dict] = []
                resolved_st = _resolve_node_closures(st_item, pre, in_lp)
                new_s.extend(pre)
                new_s.append(resolved_st)
            nd["stmts"] = new_s

        proto_graph = {
            "var": "__pc__",
            "start": 1,
            "prefix": [],
            "nodes": pc_nodes,
            "suffix": [],
        }
        body_stmts = clean_body(clean(Structurer(proto_graph).emit()))
        body_stmts = normalize_cf_deep(body_stmts, at_fn_end=True, allow_short_tail=False)
        local_tmp_cnt = [0]
        body_stmts = _desugar_block_recursive(
            body_stmts,
            lambda: f"d{p_id}_{local_tmp_cnt.__setitem__(0, local_tmp_cnt[0] + 1) or local_tmp_cnt[0]}",
        )
        body_stmts = _fold_self_calls_deep(body_stmts)
        body_stmts = _trim_unused_multiret_tails(body_stmts, p_prefix)

        uses_vararg = any(isinstance(n, dict) and n.get("type") == "VarargLiteral" for n in walk(body_stmts))
        params = [_ident(rn(i)) for i in range(1, n_params + 1)]
        param_names = {rn(i) for i in range(1, n_params + 1)}
        if uses_vararg:
            params.append({"type": "VarargLiteral", "value": "...", "raw": "..."})

        def _has_nested_fn_ref(stmt_node: dict, var_nm: str) -> bool:
            for sub in walk(stmt_node):
                if isinstance(sub, dict) and sub.get("type") == "FunctionDeclaration":
                    for inner in walk(sub["body"]):
                        if isinstance(inner, dict) and inner.get("type") == "Identifier" and inner.get("name") == var_nm:
                            return True
            return False

        cand_captured = {
            n["name"]
            for s_top in body_stmts
            for sub in walk(s_top)
            if isinstance(sub, dict) and sub.get("type") == "FunctionDeclaration"
            for n in walk(sub["body"])
            if isinstance(n, dict) and n.get("type") == "Identifier" and n["name"].startswith(p_prefix) and n["name"] not in param_names
        }
        for cvar in sorted(cand_captured):
            first_cl = next((idx_s for idx_s, s_top in enumerate(body_stmts) if _has_nested_fn_ref(s_top, cvar)), None)
            if first_cl is None or first_cl == 0:
                continue
            decl_idx = None
            for idx_s in range(first_cl - 1, 0, -1):
                st_c = body_stmts[idx_s]
                if (
                    st_c["type"] == "AssignmentStatement"
                    and len(st_c["variables"]) == 1
                    and st_c["variables"][0].get("type") == "Identifier"
                    and st_c["variables"][0]["name"] == cvar
                    and len(st_c.get("init", [])) == 1
                    and not any(
                        isinstance(rn_n, dict) and rn_n.get("type") == "Identifier" and rn_n.get("name") == cvar
                        for rn_n in walk(st_c["init"][0])
                    )
                ):
                    decl_idx = idx_s
                    break
            if decl_idx is not None and decl_idx > 0:
                pre_nm = f"{p_prefix}{1000 + int(cvar.split('_')[-1])}"
                body_stmts = [_rename_ident_all(s_p, cvar, pre_nm) for s_p in body_stmts[:decl_idx]] + body_stmts[decl_idx:]

        tmp_prefix = f"__mv_tmp_d{p_id}_"
        own_regs: list[str] = []
        seen_regs: set[str] = set()
        for n in walk(body_stmts):
            if isinstance(n, dict) and n.get("type") == "Identifier":
                nm = n["name"]
                if (nm.startswith(p_prefix) or nm.startswith(cap_prefix) or nm.startswith(tmp_prefix)) and nm not in param_names and nm not in seen_regs:
                    seen_regs.add(nm)
                    own_regs.append(nm)
        if own_regs:
            own_regs.sort(key=lambda s: (0 if s.startswith(p_prefix) else 1, int(s.split("_")[-1])))
            body_stmts = [
                {
                    "type": "LocalStatement",
                    "variables": [_ident(nm) for nm in own_regs],
                    "init": [],
                }
            ] + body_stmts

        return {
            "type": "FunctionDeclaration",
            "identifier": None,
            "isLocal": False,
            "parameters": params,
            "body": body_stmts,
        }

    root_fn = lift_proto(target_proto)
    counter = [0]

    def fresh_fn():
        counter[0] += 1
        return str(counter[0])

    alpha = _AlphaRenamer()
    renamed_fn = alpha.rename_fn(root_fn)
    stmts = renamed_fn["body"]
    if stmts and stmts[-1]["type"] == "ReturnStatement" and not stmts[-1]["arguments"]:
        stmts.pop()

    stmts = normalize_cf_deep(stmts, at_fn_end=True, allow_short_tail=False)
    stmts = _desugar_block_recursive(stmts, fresh_fn)
    stmts = isolate_cell_creations(stmts, fresh_fn)
    stmts = _optimize_all_functions(stmts, fresh_fn)
    stmts = _fold_mv21_crypto_intrinsics(stmts, dec, raw)
    stmts = _optimize_all_functions(stmts, fresh_fn)
    stmts = reconstruct_for_in_loops(stmts)
    stmts = reconstruct_for_numeric_loops(stmts)
    stmts = unbox_cells(stmts, fresh_fn)
    stmts = _optimize_all_functions(stmts, fresh_fn)
    stmts = normalize_cf_deep(stmts, at_fn_end=True, allow_short_tail=True)
    stmts = _optimize_all_functions(stmts, fresh_fn)
    stmts = reconstruct_for_in_loops(stmts)
    stmts = reconstruct_for_numeric_loops(stmts)
    stmts = _optimize_all_functions(stmts, fresh_fn)
    stmts = _place_local_declarations(stmts, set(), is_fn_root=True)
    stmts = _inject_residual_shims(stmts)
    stmts = assign_readable_names(stmts)

    out_text = format_block(stmts, 0).strip() + "\n"
    out_bytes = out_text.encode("latin1")
    parse(normalize(out_bytes))
    return out_bytes


class _HandlerCallSignal(Exception):
    def __init__(self, op: int, args: list[Any]):
        self.op = op
        self.args = args


def _coalesce_multicall_stmts(stmts: list[dict]) -> list[dict]:
    """Merge consecutive `r_a = MultiCallSlot(call, 0); r_b = MultiCallSlot(call, 1)` assignments into `r_a, r_b = call`."""
    out: list[dict] = []
    i = 0
    while i < len(stmts):
        s = stmts[i]
        if (
            s["type"] == "AssignmentStatement"
            and len(s["variables"]) == 1
            and len(s.get("init", [])) == 1
            and s["init"][0].get("type") == "MultiCallSlot"
            and s["init"][0]["slot"] == 0
        ):
            call_obj = s["init"][0]["call"]
            lhs_list = [s["variables"][0]]
            j = i + 1
            expect = 1
            while (
                j < len(stmts)
                and stmts[j]["type"] == "AssignmentStatement"
                and len(stmts[j]["variables"]) == 1
                and len(stmts[j].get("init", [])) == 1
                and stmts[j]["init"][0].get("type") == "MultiCallSlot"
                and stmts[j]["init"][0]["call"] is call_obj
                and stmts[j]["init"][0]["slot"] == expect
            ):
                lhs_list.append(stmts[j]["variables"][0])
                expect += 1
                j += 1
            out.append({
                "type": "AssignmentStatement",
                "variables": lhs_list,
                "init": [copy.deepcopy(call_obj)],
            })
            i = j
            continue
        out.append(s)
        i += 1
    return out


def _trim_unused_multiret_tails(stmts: list[dict], p_prefix: str) -> list[dict]:
    """Drop dead trailing temporary registers (`a, b, unused1, unused2 = call()`) so `reconstruct_for_in_loops` matches cleanly."""
    # Count all identifier occurrences across `stmts`; any `p_prefix` var appearing ONLY once (its single LHS write) is dead!
    occ: dict[str, int] = {}
    for n in walk(stmts):
        if isinstance(n, dict) and n.get("type") == "Identifier":
            nm = n["name"]
            occ[nm] = occ.get(nm, 0) + 1

    def rewrite(obj: Any) -> Any:
        if isinstance(obj, list):
            return [rewrite(x) for x in obj]
        if isinstance(obj, dict):
            if (
                obj.get("type") == "AssignmentStatement"
                and len(obj.get("variables", [])) > 1
                and len(obj.get("init", [])) == 1
                and obj["init"][0].get("type") == "CallExpression"
            ):
                vs = list(obj["variables"])
                while (
                    len(vs) > 1
                    and vs[-1].get("type") == "Identifier"
                    and vs[-1]["name"].startswith(p_prefix)
                    and occ.get(vs[-1]["name"], 0) <= 1
                ):
                    vs.pop()
                return {**obj, "variables": vs, "init": rewrite(obj["init"])}
            return {k: (v if k in ("identifier", "key") and obj.get("type") in ("MemberExpression", "TableKeyString") else rewrite(v)) for k, v in obj.items()}
        return obj

    return rewrite(stmts)


def _fold_mv21_crypto_intrinsics(stmts: list[dict], dec: Any, raw: bytes = b"") -> list[dict]:
    """Fold `__mv_sha256("...")` and `__mv_chacha20("...", "...", "...")` into exact decrypted string literals."""
    fn_map = {"__mv_sha256": b"y", "__mv_chacha20": b"v", "__mv_lz_decomp": b"t", "__mv_b85_dec": b"q"}

    def fold_py(obj: Any) -> Any:
        if isinstance(obj, list):
            return [fold_py(x) for x in obj]
        if isinstance(obj, dict):
            folded = {k: fold_py(v) for k, v in obj.items()}
            if (
                folded.get("type") == "BinaryExpression"
                and folded.get("operator") == ".."
                and folded["left"].get("type") == "StringLiteral"
                and folded["right"].get("type") == "StringLiteral"
            ):
                return _lit(folded["left"]["value"] + folded["right"]["value"])
            if (
                folded.get("type") == "CallExpression"
                and folded["base"].get("type") == "Identifier"
                and folded["base"]["name"] in fn_map
                and all(a.get("type") == "StringLiteral" for a in folded["arguments"])
            ):
                ctx_fn = dec.context.get(fn_map[folded["base"]["name"]])
                if ctx_fn is not None:
                    b_args = tuple(a["value"].encode("latin1") for a in folded["arguments"])
                    for call_args in (b_args, (dec.context,) + b_args):
                        try:
                            res = dec.evaluator.call(ctx_fn, call_args)
                            if isinstance(res, tuple):
                                res = res[0]
                            if isinstance(res, bytes):
                                return _lit(res.decode("latin1"))
                        except Exception:
                            pass
            return folded
        return obj

    cur = fold_py(stmts)

    # Batch-evaluate any remaining constant `__mv_sha256` / `__mv_chacha20` calls via native `./bin/luau` (`0.2s`!)
    pending: list[tuple[str, tuple[str, ...]]] = []
    seen_set: set[tuple[str, tuple[str, ...]]] = set()
    for n in walk(cur):
        if (
            isinstance(n, dict)
            and n.get("type") == "CallExpression"
            and n["base"].get("type") == "Identifier"
            and n["base"]["name"] in fn_map
            and all(a.get("type") == "StringLiteral" for a in n["arguments"])
        ):
            item = (n["base"]["name"], tuple(a["value"] for a in n["arguments"]))
            if item not in seen_set:
                seen_set.add(item)
                pending.append(item)

    if pending and raw and LUAU_BIN.is_file():
        u2 = raw.decode("latin1")
        ret_idx = u2.find("return(")
        if ret_idx >= 0:
            def _luau_str_lit(s: str) -> str:
                return '"' + "".join(f"\\{ord(ch):03d}" for ch in s) + '"'

            call_snippets = []
            for idx_p, (fn_nm, s_args) in enumerate(pending):
                m_key = fn_map[fn_nm].decode("latin1")
                arg_lits = ",".join(_luau_str_lit(a) for a in s_args)
                call_snippets.append(f"local ok{idx_p},r{idx_p}=pcall(MV_CTX.{m_key},{arg_lits})if ok{idx_p} and type(r{idx_p})=='string'then res[tostring({idx_p})]=r{idx_p} end")

            eval_body = ";".join(call_snippets)
            one_line = (
                "local MV_CTX=nil;"
                "local function jstr(s)local o={'\"'}for i=1,#s do local b=string.byte(s,i)"
                "if b==34 then o[#o+1]='\\\\\"' elseif b==92 then o[#o+1]='\\\\\\\\' "
                "elseif b==10 then o[#o+1]='\\\\n' elseif b==13 then o[#o+1]='\\\\r' "
                "elseif b==9 then o[#o+1]='\\\\t' elseif b<32 or b>=127 then o[#o+1]=string.format('\\\\u%04x',b)"
                "else o[#o+1]=string.char(b)end end o[#o+1]='\"' return table.concat(o)end;"
                "local function run_batch()local res={}"
                + eval_body
                + ";local p={}for k,v in pairs(res)do p[#p+1]=jstr(k)..':'..jstr(v)end "
                "print('MV21_STR_START')print('{'..table.concat(p,',')..'}')print('MV21_STR_END')error('__MV21_STR__')end;"
                "local Vec3={new=function(x,y,z)return{X=x,Y=y,Z=z}end};"
                "local CF={new=function(x,y,z)return{X=x,Y=y,Z=z}end};"
                "local RayParams={new=function()return{IncludeInstances={}}end};"
                "local gm=setmetatable({},{__index=function(_,k)if k=='GetService'then return function(_,s)return{Name=s}end end error('no '..tostring(k))end});"
                "local ws=setmetatable({},{__index=function(_,k)if k=='children'or k=='GetChildren'then return function()return{}end end error('no')end});"
                "local Inst={new=function(c)if c=='WorldModel'then return{"
                "Raycast=function(_,o,d,p)local bt,bp=1e9,nil for _,pt in ipairs(p.IncludeInstances)do "
                "local zf=d.Z<0 and(pt.CFrame.Z+pt.Size.Z*0.5)or(pt.CFrame.Z-pt.Size.Z*0.5)local t=(zf-o.Z)/d.Z "
                "if t>=0 and t<=1 and t<bt then bt=t bp={Position={X=o.X+d.X*t,Y=o.Y+d.Y*t,Z=zf}}end end return bp end,"
                "Destroy=function()run_batch()end}end return{Size={X=0,Y=0,Z=0},CFrame={X=0,Y=0,Z=0}}end};"
                "local tbl_p=setmetatable({create=function(n)if MV_CTX and MV_CTX.v then run_batch()end return table.create(n)end},{__index=table});"
                "local env=setmetatable({__mv_env=true,table=tbl_p,Instance=Inst,Vector3=Vec3,CFrame=CF,RaycastParams=RayParams,workspace=ws,game=gm},{__index=_G});"
                "setfenv(1,setmetatable({table=tbl_p,getfenv=function()return env end},{__index=env}))"
            )
            script = one_line + "\nreturn(function(t)MV_CTX=t return t end)(" + u2[ret_idx + 7 :]
            with tempfile.NamedTemporaryFile("w", suffix=".luau", delete=False, encoding="latin1") as tf:
                tf.write(script)
                tf_path = tf.name
            try:
                proc = subprocess.run([str(LUAU_BIN), tf_path], capture_output=True, text=True, encoding="latin1", timeout=15)
            finally:
                try:
                    os.unlink(tf_path)
                except OSError:
                    pass
            out_s = proc.stdout
            si = out_s.find("MV21_STR_START\n")
            ei = out_s.find("\nMV21_STR_END")
            if si >= 0 and ei > si:
                resolved_idx: dict[str, str] = json.loads(out_s[si + len("MV21_STR_START\n") : ei])
                resolved_map = {pending[int(k)]: v for k, v in resolved_idx.items()}

                def sub_luau(obj: Any) -> Any:
                    if isinstance(obj, list):
                        return [sub_luau(x) for x in obj]
                    if isinstance(obj, dict):
                        f2 = {k: sub_luau(v) for k, v in obj.items()}
                        if (
                            f2.get("type") == "CallExpression"
                            and f2["base"].get("type") == "Identifier"
                            and f2["base"]["name"] in fn_map
                            and all(a.get("type") == "StringLiteral" for a in f2["arguments"])
                        ):
                            key_t = (f2["base"]["name"], tuple(a["value"] for a in f2["arguments"]))
                            if key_t in resolved_map:
                                return _lit(resolved_map[key_t])
                        return f2
                    return obj

                cur = sub_luau(cur)

    return cur


def lift_moonveil_vm(raw: bytes) -> bytes | None:
    """Auto-detect MoonVeil 2.0.x vs 2.1.x Bytecode VM and lift to clean Lua."""
    head = raw[:200].decode("latin1", errors="ignore")
    tail = raw[-32768:].decode("latin1", errors="ignore")
    if "MoonVeil 2.1." in head or re.search(r"\):[A-Za-z_]\w*\(\{[^\}]+\},\"[A-Za-z_]\w*\",\.\.\.\)\s*$", tail):
        return lift_moonveil_21x_vm(raw)
    return lift_moonveil_20x_vm(raw)

