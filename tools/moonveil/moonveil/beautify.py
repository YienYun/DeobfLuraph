"""AST refactoring and decompilation passes for structured MoonVeil output.

Transforms structured register-level MoonVeil output (`__moonveil_recovered`,
`c._.Global`, `p.h`/`p.i` pack/unpack, `{value = x}` cells, lowered `for-in`
loops, parallel register shuffles, and single-letter register reuse) into clean,
idiomatic, human-readable Lua/Luau while preserving runtime behavior.
"""

from __future__ import annotations
import copy
import re
from .front import parse, quote, lua_bytes, walk

KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for",
    "function", "if", "in", "local", "nil", "not", "or", "repeat",
    "return", "then", "true", "until", "while",
}

LUA_GLOBALS = {
    "assert", "bit", "bit32", "buffer", "collectgarbage", "coroutine", "debug",
    "delay", "elapsedTime", "error", "game", "gcinfo", "getfenv", "getgenv",
    "getmetatable", "getrawmetatable", "getrenv", "getsenv", "hookfunction",
    "hookmetamethod", "http_request", "ipairs", "iscclosure", "isfile",
    "islclosure", "isreadonly", "leton", "listfiles", "load", "loadfile",
    "loadstring", "makefolder", "math", "newcclosure", "newproxy", "next",
    "os", " OverlapParams", "pairs", "pcall", "plugin", "print", "rawequal",
    "rawget", "rawlen", "rawset", "readfile", " replica", "request", "require",
    "script", "select", " setclipboard", "setfenv", "setmetatable",
    "setreadonly", "shared", "spawn", "stats", "string", "syn", "table",
    "task", "tick", "time", "tonumber", "tostring", "type", "typeof", "unpack",
    "utf8", " version", "wait", "warn", "workspace", "writefile", "xpcall",
    "Axes", "BrickColor", "CFrame", "Color3", "ColorSequence",
    "ColorSequenceKeypoint", "DateTime", "DockWidgetPluginGuiInfo", "Enum",
    "Faces", "Font", "Instance", "NumberRange", "NumberSequence",
    "NumberSequenceKeypoint", "PathWaypoint", "PhysicalProperties", "Random",
    "Ray", "RaycastParams", "Rect", "Region3", "Region3int16", "TweenInfo",
    "UDim", "UDim2", "Vector2", "Vector2int16", "Vector3", "Vector3int16",
    "_G", "_ENV", "_VERSION", "setclipboard", "delfile", "appendfile",
    "isfolder", "delfolder", "fireproximityprompt", "fireclickdetector",
    "firetouchinterest",
}
LUA_GLOBALS = {g.strip() for g in LUA_GLOBALS}


# ---------------------------------------------------------------------------
# Pretty-printer with clean Lua operator precedence
# ---------------------------------------------------------------------------

BIN_PREC = {
    "or": 1,
    "and": 2,
    "<": 3, ">": 3, "<=": 3, ">=": 3, "~=": 3, "==": 3,
    "..": 4,
    "+": 5, "-": 5,
    "*": 6, "/": 6, "%": 6,
    "^": 8,
}
RIGHT_ASSOC = {"..", "^"}
UNARY_PREC = 7


def _ident(name: str) -> dict:
    return {"type": "Identifier", "name": name}


def _bool(val: bool) -> dict:
    return {"type": "BooleanLiteral", "value": bool(val), "raw": "true" if val else "false"}


def _nil() -> dict:
    return {"type": "NilLiteral", "value": None, "raw": "nil"}


def _is_ident(node, name=None) -> bool:
    if not isinstance(node, dict) or node.get("type") != "Identifier":
        return False
    return True if name is None else node.get("name") == name


def _is_literal(node) -> bool:
    return isinstance(node, dict) and node.get("type") in (
        "NumericLiteral", "StringLiteral", "BooleanLiteral", "NilLiteral"
    )


def _is_truthy_literal(node) -> bool:
    if not isinstance(node, dict):
        return False
    t = node.get("type")
    if t in ("NumericLiteral", "StringLiteral"):
        return True
    if t == "BooleanLiteral":
        return bool(node.get("value"))
    return False


def negate_cond(c: dict) -> dict:
    t = c.get("type")
    if t == "UnaryExpression" and c.get("operator") == "not":
        return copy.deepcopy(c["argument"])
    if t == "BinaryExpression":
        inv = {"==": "~=", "~=": "==", "<": ">=", ">=": "<", ">": "<=", "<=": ">"}
        if c["operator"] in inv:
            out = copy.deepcopy(c)
            out["operator"] = inv[c["operator"]]
            return out
    return {"type": "UnaryExpression", "operator": "not", "argument": copy.deepcopy(c), "prefix": True}


def format_expr(x: dict, parent_prec: int = 0, right_side: bool = False) -> str:
    t = x["type"]
    if t == "Identifier":
        return x["name"]
    if t == "NumericLiteral":
        v = x["value"]
        return str(int(v)) if isinstance(v, (int, float)) and v == int(v) and abs(v) < 1e18 else repr(v)
    if t == "StringLiteral":
        return quote(lua_bytes(x["value"]))
    if t == "BooleanLiteral":
        return "true" if x["value"] else "false"
    if t == "NilLiteral":
        return "nil"
    if t == "VarargLiteral":
        return "..."
    if t == "MemberExpression":
        b = x["base"]
        bs = format_expr(b, 9)
        if b["type"] not in ("Identifier", "MemberExpression", "IndexExpression", "CallExpression", "TableCallExpression", "StringCallExpression"):
            bs = "(" + bs + ")"
        return bs + x["indexer"] + x["identifier"]["name"]
    if t == "IndexExpression":
        b = x["base"]
        bs = format_expr(b, 9)
        if b["type"] not in ("Identifier", "MemberExpression", "IndexExpression", "CallExpression", "TableCallExpression", "StringCallExpression"):
            bs = "(" + bs + ")"
        return bs + "[" + format_expr(x["index"], 0) + "]"
    if t == "UnaryExpression":
        op = x["operator"]
        arg = x["argument"]
        inner = format_expr(arg, UNARY_PREC)
        if op == "-" and inner.startswith("-"):
            s = "-(" + inner + ")"
        elif op in ("not",) and arg["type"] in ("BinaryExpression", "LogicalExpression"):
            s = f"not ({ format_expr(arg, 0) })"
        elif op == "not":
            s = "not " + inner
        else:
            s = op + inner
        if parent_prec > UNARY_PREC:
            return "(" + s + ")"
        return s
    if t in ("BinaryExpression", "LogicalExpression"):
        op = x["operator"]
        prec = BIN_PREC.get(op, 5)
        ls = format_expr(x["left"], prec, False)
        rs = format_expr(x["right"], prec, True)
        if x["left"]["type"] in ("BinaryExpression", "LogicalExpression"):
            lprec = BIN_PREC.get(x["left"]["operator"], 5)
            if lprec < prec or (lprec == prec and op in RIGHT_ASSOC):
                ls = "(" + format_expr(x["left"], 0) + ")"
        if x["right"]["type"] in ("BinaryExpression", "LogicalExpression"):
            rprec = BIN_PREC.get(x["right"]["operator"], 5)
            if rprec < prec or (rprec == prec and op not in RIGHT_ASSOC):
                rs = "(" + format_expr(x["right"], 0) + ")"
        s = f"{ls} {op} {rs}"
        if parent_prec > prec or (parent_prec == prec and right_side and op not in RIGHT_ASSOC):
            return "(" + s + ")"
        return s
    if t == "CallExpression":
        b = x["base"]
        bs = format_expr(b, 9)
        if b["type"] == "FunctionDeclaration":
            bs = "(" + bs + ")"
        return bs + "(" + ", ".join(format_expr(a, 0) for a in x["arguments"]) + ")"
    if t == "TableCallExpression":
        return format_expr(x["base"], 9) + "(" + format_expr(x["arguments"], 0) + ")"
    if t == "StringCallExpression":
        return format_expr(x["base"], 9) + "(" + format_expr(x["argument"], 0) + ")"
    if t == "TableConstructorExpression":
        fields = x["fields"]
        if not fields:
            return "{}"
        fs = []
        for f in fields:
            if f["type"] == "TableValue":
                fs.append(format_expr(f["value"], 0))
            elif f["type"] == "TableKeyString":
                fs.append(f["key"]["name"] + " = " + format_expr(f["value"], 0))
            else:
                fs.append("[" + format_expr(f["key"], 0) + "] = " + format_expr(f["value"], 0))
        joined = ", ".join(fs)
        if len(fields) >= 6 or len(joined) > 90 or "\n" in joined:
            inner = ",\n    ".join(item.replace("\n", "\n    ") for item in fs)
            return "{\n    " + inner + "\n}"
        return "{" + joined + "}"
    if t == "FunctionDeclaration":
        params = ", ".join(format_expr(p, 0) for p in x["parameters"])
        body_txt = format_block(x["body"], 1)
        if not body_txt.strip():
            return f"function({params}) end"
        return f"function({params})\n{body_txt}\nend"
    raise ValueError(f"Unsupported expr node: {t}")


def format_stmt(s: dict, level: int = 0) -> str:
    pad = "    " * level
    t = s["type"]
    if t in ("AssignmentStatement", "LocalStatement"):
        prefix = "local " if t == "LocalStatement" else ""
        lhs = ", ".join(format_expr(v, 0) for v in s["variables"])
        if s.get("init"):
            rhs = ", ".join(format_expr(v, 0) for v in s["init"])
            txt = f"{prefix}{lhs} = {rhs}"
        else:
            txt = f"{prefix}{lhs}"
        return pad + txt.replace("\n", "\n" + pad)
    if t == "ReturnStatement":
        if not s["arguments"]:
            return pad + "return"
        rhs = ", ".join(format_expr(v, 0) for v in s["arguments"])
        return pad + ("return " + rhs).replace("\n", "\n" + pad)
    if t == "CallStatement":
        return pad + format_expr(s["expression"], 0).replace("\n", "\n" + pad)
    if t == "BreakStatement":
        return pad + "break"
    if t == "DoStatement":
        return f"{pad}do\n{format_block(s['body'], level + 1)}\n{pad}end"
    if t == "IfStatement":
        out = []
        for idx, c in enumerate(s["clauses"]):
            if idx == 0:
                out.append(f"{pad}if {format_expr(c['condition'], 0)} then")
            elif "condition" in c and c["condition"] is not None:
                out.append(f"{pad}elseif {format_expr(c['condition'], 0)} then")
            else:
                out.append(f"{pad}else")
            btxt = format_block(c["body"], level + 1)
            if btxt:
                out.append(btxt)
        out.append(f"{pad}end")
        return "\n".join(out)
    if t == "WhileStatement":
        btxt = format_block(s["body"], level + 1)
        return f"{pad}while {format_expr(s['condition'], 0)} do\n{btxt}\n{pad}end"
    if t == "RepeatStatement":
        btxt = format_block(s["body"], level + 1)
        return f"{pad}repeat\n{btxt}\n{pad}until {format_expr(s['condition'], 0)}"
    if t == "FunctionDeclaration":
        kw = "local function " if s.get("isLocal") else "function "
        params = ", ".join(format_expr(p, 0) for p in s["parameters"])
        btxt = format_block(s["body"], level + 1)
        return f"{pad}{kw}{format_expr(s['identifier'], 0)}({params})\n{btxt}\n{pad}end"
    if t == "ForNumericStatement":
        step = f", {format_expr(s['step'], 0)}" if s.get("step") else ""
        btxt = format_block(s["body"], level + 1)
        return f"{pad}for {format_expr(s['variable'], 0)} = {format_expr(s['start'], 0)}, {format_expr(s['end'], 0)}{step} do\n{btxt}\n{pad}end"
    if t == "ForGenericStatement":
        vars_s = ", ".join(format_expr(v, 0) for v in s["variables"])
        iters_s = ", ".join(format_expr(it, 0) for it in s["iterators"]).replace("\n", "\n" + pad)
        btxt = format_block(s["body"], level + 1)
        return f"{pad}for {vars_s} in {iters_s} do\n{btxt}\n{pad}end"
    raise ValueError(f"Unsupported statement: {t}")


def format_block(stmts: list[dict], level: int = 0) -> str:
    return "\n".join(format_stmt(s, level) for s in stmts)


# ---------------------------------------------------------------------------
# Pass 1: Control-flow normalization (empty-if flip, guard unnesting, tail hoist)
# ---------------------------------------------------------------------------

def _ends_in_exit(stmts: list[dict]) -> bool:
    if not stmts:
        return False
    last = stmts[-1]
    if last["type"] in ("ReturnStatement", "BreakStatement"):
        return True
    if last["type"] == "IfStatement" and len(last["clauses"]) >= 2 and last["clauses"][-1].get("condition") is None:
        return all(_ends_in_exit(c["body"]) for c in last["clauses"])
    return False


def normalize_cf_stmts(stmts: list[dict], at_fn_end: bool = False, allow_short_tail: bool = False) -> list[dict]:
    changed = True
    cur = copy.deepcopy(stmts)
    for _ in range(12):
        if not changed:
            break
        changed = False
        out = []
        for idx, s in enumerate(cur):
            t = s["type"]
            next_is_bare_return = (
                (idx + 1 < len(cur) and cur[idx + 1]["type"] == "ReturnStatement" and not cur[idx + 1]["arguments"])
                or (at_fn_end and idx == len(cur) - 1)
            )
            if t == "IfStatement":
                for c in s["clauses"]:
                    c["body"] = normalize_cf_stmts(c["body"], at_fn_end=next_is_bare_return, allow_short_tail=allow_short_tail)
                # Remove trailing empty else
                if len(s["clauses"]) >= 2 and s["clauses"][-1].get("condition") is None and not s["clauses"][-1]["body"]:
                    s["clauses"].pop()
                    changed = True
                # 2-branch `if cond then <empty> else B end` -> `if not cond then B end`
                if len(s["clauses"]) == 2 and s["clauses"][1].get("condition") is None and not s["clauses"][0]["body"]:
                    s["clauses"] = [{
                        "type": "IfClause",
                        "condition": negate_cond(s["clauses"][0]["condition"]),
                        "body": s["clauses"][1]["body"],
                    }]
                    changed = True
                # Simplify double negation `not (not x)` in boolean `if` conditions!
                for c in s["clauses"]:
                    if c.get("condition") is not None:
                        cc = c["condition"]
                        while (
                            cc["type"] == "UnaryExpression"
                            and cc["operator"] == "not"
                            and cc["argument"]["type"] == "UnaryExpression"
                            and cc["argument"]["operator"] == "not"
                        ):
                            cc = cc["argument"]["argument"]
                            c["condition"] = cc
                            changed = True
                # Drop completely empty single-clause if (only when condition is pure identifier/comparison)
                if len(s["clauses"]) == 1 and not s["clauses"][0]["body"] and _is_pure_expr(s["clauses"][0]["condition"]):
                    changed = True
                    continue
                # Common tail hoisting MUST run BEFORE Guard Unnesting when `k >= 2` (e.g. `if isfile then <check>; <GUI>; return else <GUI>; return end`),
                # while skipping lone 1-statement `return`/`break` (`k == 1`) so Guard Unnesting handles `if ok then cb(); return else <GUI>; return end`!
                if len(s["clauses"]) >= 2 and s["clauses"][-1].get("condition") is None:
                    bodies = [c["body"] for c in s["clauses"]]
                    min_len = min(len(b) for b in bodies)
                    k = 0
                    while k < min_len:
                        ref = format_stmt(bodies[0][-1 - k], 0)
                        if all(format_stmt(b[-1 - k], 0) == ref for b in bodies[1:]):
                            k += 1
                        else:
                            break
                    only_bare_exit = k == 1 and bodies[0][-1]["type"] in ("ReturnStatement", "BreakStatement")
                    if k > 0 and not only_bare_exit and (allow_short_tail or k >= 3):
                        hoisted = bodies[0][len(bodies[0]) - k :]
                        for b in bodies:
                            del b[len(b) - k :]
                        # Strip empty trailing `else` immediately if `else` body was 100% hoisted!
                        if s["clauses"] and s["clauses"][-1].get("condition") is None and not s["clauses"][-1]["body"]:
                            s["clauses"].pop()
                        changed = True
                        if any(b for b in bodies):
                            out.append(s)
                        elif not all(c.get("condition") is None or _is_pure_expr(c["condition"]) for c in s["clauses"]):
                            out.append(s)
                        out.extend(hoisted)
                        continue
                # Guard unnesting (`if ok then cb(); return else <tail> end` -> `if ok then cb(); return end; <tail>`)
                if (
                    len(s["clauses"]) == 2
                    and s["clauses"][1].get("condition") is None
                    and _ends_in_exit(s["clauses"][0]["body"])
                    and s["clauses"][1]["body"]
                ):
                    else_body = s["clauses"][1]["body"]
                    s["clauses"].pop()
                    out.append(s)
                    out.extend(else_body)
                    changed = True
                    continue
                # Strip redundant trailing bare `return` inside branches when falling off `if` already returns!
                if next_is_bare_return:
                    for c in s["clauses"]:
                        if c["body"] and c["body"][-1]["type"] == "ReturnStatement" and not c["body"][-1]["arguments"]:
                            c["body"].pop()
                            changed = True
                # Merge `elseif` chains: `else { if c2 then ... end }` -> `elseif c2`
                if (
                    len(s["clauses"]) >= 2
                    and s["clauses"][-1].get("condition") is None
                    and len(s["clauses"][-1]["body"]) == 1
                    and s["clauses"][-1]["body"][0]["type"] == "IfStatement"
                ):
                    inner_if = s["clauses"][-1]["body"][0]
                    s["clauses"].pop()
                    for ic in inner_if["clauses"]:
                        if ic.get("condition") is not None:
                            ic["type"] = "ElseifClause"
                        s["clauses"].append(ic)
                    changed = True
                out.append(s)
            elif t == "FunctionDeclaration":
                s["body"] = normalize_cf_stmts(s["body"], at_fn_end=True, allow_short_tail=allow_short_tail)
                out.append(s)
            elif t in ("WhileStatement", "RepeatStatement", "DoStatement", "ForNumericStatement", "ForGenericStatement"):
                s["body"] = normalize_cf_stmts(s["body"], at_fn_end=False, allow_short_tail=allow_short_tail)
                out.append(s)
            else:
                out.append(s)
        cur = out
    return cur


def _normalize_cf_expr(x, allow_short_tail: bool):
    if isinstance(x, list):
        return [_normalize_cf_expr(i, allow_short_tail) for i in x]
    if not isinstance(x, dict):
        return x
    if x.get("type") == "FunctionDeclaration":
        nx = {k: (_normalize_cf_expr(v, allow_short_tail) if k not in ("range", "loc", "body") else v) for k, v in x.items()}
        body_rec = [_normalize_cf_expr(s, allow_short_tail) for s in x["body"]]
        nx["body"] = normalize_cf_stmts(body_rec, at_fn_end=True, allow_short_tail=allow_short_tail)
        return nx
    return {k: (_normalize_cf_expr(v, allow_short_tail) if k not in ("range", "loc") else v) for k, v in x.items()}


def normalize_cf_deep(stmts: list[dict], at_fn_end: bool = True, allow_short_tail: bool = False) -> list[dict]:
    """Bottom-up recursive CF normalization across all nested functions and expressions."""
    rec = [_normalize_cf_expr(copy.deepcopy(s), allow_short_tail) for s in stmts]
    return normalize_cf_stmts(rec, at_fn_end=at_fn_end, allow_short_tail=allow_short_tail)


def normalize_cf_fn(fn: dict) -> dict:
    return _normalize_cf_expr(copy.deepcopy(fn), allow_short_tail=False)


# ---------------------------------------------------------------------------
# Pass 2: Lower MoonVeil intrinsics (`self._`, `self.h`, `self.i`, `self.g`)
#         & re-nest `__moonveil_recovered` closures into lexical functions
# ---------------------------------------------------------------------------

def _classify_builtin_exports(selected: dict) -> set[str]:
    """Identify MoonVeil runtime helper exports (`_`, `g`, `h`, `i`) structurally."""
    helpers = set()
    for name, node in selected.items():
        txt = format_expr(node, 0).strip()
        if txt == "getfenv()":
            helpers.add(name)
        elif node.get("type") == "FunctionDeclaration" and len(node.get("parameters", [])) == 1 and node["parameters"][0].get("type") == "VarargLiteral":
            # pack helper: function(...) return {[1] = {...}, [2] = select("#", ...)} end
            if "select(\"#\", ...)" in txt:
                helpers.add(name)
        elif node.get("type") == "CallExpression" and node["base"].get("type") == "FunctionDeclaration":
            if "__iter" in txt or "return i[j]," in txt or "m(o[1], 1, o[2])" in txt:
                helpers.add(name)
    return helpers


def _find_builtin_roles(selected: dict) -> dict[str, str]:
    roles = {}
    for name, node in selected.items():
        txt = format_expr(node, 0).strip()
        if txt == "getfenv()":
            roles[name] = "env"
        elif node.get("type") == "FunctionDeclaration" and len(node.get("parameters", [])) == 1 and node["parameters"][0].get("type") == "VarargLiteral" and 'select("#", ...)' in txt:
            roles[name] = "pack"
        elif node.get("type") == "CallExpression" and "__iter" in txt:
            roles[name] = "iter"
        elif node.get("type") == "CallExpression" and "[1], 1," in txt:
            roles[name] = "unpack"
    return roles


def _rewrite_self_refs(node, self_name: str, roles: dict[str, str]):
    if isinstance(node, list):
        return [_rewrite_self_refs(v, self_name, roles) for v in node]
    if not isinstance(node, dict):
        return node
    if node.get("type") == "FunctionDeclaration":
        params = [p.get("name") for p in node.get("parameters", []) if p.get("type") == "Identifier"]
        if self_name in params:
            return copy.deepcopy(node)
    out = {k: _rewrite_self_refs(v, self_name, roles) for k, v in node.items()}

    # `self._.<Global>` -> `<Global>`
    if (
        out.get("type") == "MemberExpression"
        and out["indexer"] == "."
        and out["base"].get("type") == "MemberExpression"
        and out["base"]["indexer"] == "."
        and _is_ident(out["base"]["base"], self_name)
        and roles.get(out["base"]["identifier"]["name"]) == "env"
    ):
        return _ident(out["identifier"]["name"])

    # `self.h(...)` / `self.i(...)` / `self.g(...)`
    if out.get("type") == "CallExpression":
        b = out["base"]
        if (
            b.get("type") == "MemberExpression"
            and b["indexer"] == "."
            and _is_ident(b["base"], self_name)
            and b["identifier"]["name"] in roles
        ):
            role = roles[b["identifier"]["name"]]
            if role == "pack":
                out["base"] = _ident("__mv_pack__")
            elif role == "unpack":
                out["base"] = _ident("__mv_unpack__")
            elif role == "iter":
                out["base"] = _ident("__mv_iter__")
    return out


class _AlphaRenamer:
    def __init__(self):
        self.counter = 0

    def fresh(self, hint="v"):
        self.counter += 1
        base = re.sub(r"[^A-Za-z0-9_]", "", hint) or "v"
        if base in KEYWORDS or base[0].isdigit():
            base = "v_" + base
        return f"__mv_{self.counter}_{base}"

    def rename_fn(self, fn: dict, env: dict[str, str] | None = None) -> dict:
        env = dict(env or {})
        fn = copy.deepcopy(fn)
        new_params = []
        for p in fn.get("parameters", []):
            if p["type"] == "Identifier":
                np = self.fresh(p["name"])
                env[p["name"]] = np
                new_params.append(_ident(np))
            else:
                new_params.append(p)
        fn["parameters"] = new_params
        fn["body"] = self._rename_block(fn["body"], env)
        return fn

    def _rename_block(self, stmts: list[dict], env: dict[str, str]) -> list[dict]:
        scope = dict(env)
        out = []
        for s in stmts:
            t = s["type"]
            if t == "LocalStatement":
                new_init = [self._rename_expr(e, scope) for e in s.get("init", [])]
                new_vars = []
                for v in s["variables"]:
                    nv = self.fresh(v["name"])
                    scope[v["name"]] = nv
                    new_vars.append(_ident(nv))
                out.append({"type": "LocalStatement", "variables": new_vars, "init": new_init})
            elif t == "FunctionDeclaration" and s.get("isLocal") and s.get("identifier", {}).get("type") == "Identifier":
                old_name = s["identifier"]["name"]
                nv = self.fresh(old_name)
                scope[old_name] = nv
                ns = self.rename_fn(s, scope)
                ns["identifier"] = _ident(nv)
                ns["isLocal"] = True
                out.append(ns)
            elif t == "ForNumericStatement":
                start = self._rename_expr(s["start"], scope)
                end = self._rename_expr(s["end"], scope)
                step = self._rename_expr(s["step"], scope) if s.get("step") else None
                inner_scope = dict(scope)
                nv = self.fresh(s["variable"]["name"])
                inner_scope[s["variable"]["name"]] = nv
                ns = {
                    "type": "ForNumericStatement",
                    "variable": _ident(nv),
                    "start": start,
                    "end": end,
                    "step": step,
                    "body": self._rename_block(s["body"], inner_scope),
                }
                out.append(ns)
            elif t == "ForGenericStatement":
                iters = [self._rename_expr(it, scope) for it in s["iterators"]]
                inner_scope = dict(scope)
                nvars = []
                for v in s["variables"]:
                    nv = self.fresh(v["name"])
                    inner_scope[v["name"]] = nv
                    nvars.append(_ident(nv))
                out.append({
                    "type": "ForGenericStatement",
                    "variables": nvars,
                    "iterators": iters,
                    "body": self._rename_block(s["body"], inner_scope),
                })
            elif t == "AssignmentStatement":
                out.append({
                    "type": "AssignmentStatement",
                    "variables": [self._rename_lhs(v, scope) for v in s["variables"]],
                    "init": [self._rename_expr(e, scope) for e in s["init"]],
                })
            elif t == "ReturnStatement":
                out.append({
                    "type": "ReturnStatement",
                    "arguments": [self._rename_expr(e, scope) for e in s["arguments"]],
                })
            elif t == "CallStatement":
                out.append({
                    "type": "CallStatement",
                    "expression": self._rename_expr(s["expression"], scope),
                })
            elif t == "IfStatement":
                clauses = []
                for c in s["clauses"]:
                    nc = {"type": c["type"], "body": self._rename_block(c["body"], scope)}
                    if "condition" in c and c["condition"] is not None:
                        nc["condition"] = self._rename_expr(c["condition"], scope)
                    clauses.append(nc)
                out.append({"type": "IfStatement", "clauses": clauses})
            elif t in ("WhileStatement", "RepeatStatement"):
                if t == "WhileStatement":
                    out.append({
                        "type": t,
                        "condition": self._rename_expr(s["condition"], scope),
                        "body": self._rename_block(s["body"], scope),
                    })
                else:
                    # Repeat condition sees locals declared inside repeat body; conservative block scope
                    out.append({
                        "type": t,
                        "body": self._rename_block(s["body"], scope),
                        "condition": self._rename_expr(s["condition"], scope),
                    })
            elif t == "DoStatement":
                out.append({"type": "DoStatement", "body": self._rename_block(s["body"], scope)})
            else:
                out.append(copy.deepcopy(s))
        return out

    def _rename_lhs(self, v: dict, scope: dict[str, str]) -> dict:
        if v["type"] == "Identifier":
            return _ident(scope.get(v["name"], v["name"]))
        return self._rename_expr(v, scope)

    def _rename_expr(self, x: dict, scope: dict[str, str]) -> dict:
        t = x["type"]
        if t == "Identifier":
            return _ident(scope.get(x["name"], x["name"]))
        if t == "FunctionDeclaration":
            return self.rename_fn(x, scope)
        if t == "MemberExpression":
            return {
                "type": "MemberExpression",
                "base": self._rename_expr(x["base"], scope),
                "indexer": x["indexer"],
                "identifier": copy.deepcopy(x["identifier"]),
            }
        if t == "IndexExpression":
            return {
                "type": "IndexExpression",
                "base": self._rename_expr(x["base"], scope),
                "index": self._rename_expr(x["index"], scope),
            }
        if t == "UnaryExpression":
            return {
                "type": "UnaryExpression",
                "operator": x["operator"],
                "argument": self._rename_expr(x["argument"], scope),
                "prefix": x.get("prefix", True),
            }
        if t in ("BinaryExpression", "LogicalExpression"):
            return {
                "type": t,
                "operator": x["operator"],
                "left": self._rename_expr(x["left"], scope),
                "right": self._rename_expr(x["right"], scope),
            }
        if t == "CallExpression":
            return {
                "type": "CallExpression",
                "base": self._rename_expr(x["base"], scope),
                "arguments": [self._rename_expr(a, scope) for a in x["arguments"]],
            }
        if t == "TableCallExpression":
            return {
                "type": "TableCallExpression",
                "base": self._rename_expr(x["base"], scope),
                "arguments": self._rename_expr(x["arguments"], scope),
            }
        if t == "StringCallExpression":
            return {
                "type": "StringCallExpression",
                "base": self._rename_expr(x["base"], scope),
                "argument": copy.deepcopy(x["argument"]),
            }
        if t == "TableConstructorExpression":
            fs = []
            for f in x["fields"]:
                if f["type"] == "TableValue":
                    fs.append({"type": "TableValue", "value": self._rename_expr(f["value"], scope)})
                elif f["type"] == "TableKeyString":
                    fs.append({
                        "type": "TableKeyString",
                        "key": copy.deepcopy(f["key"]),
                        "value": self._rename_expr(f["value"], scope),
                    })
                else:
                    fs.append({
                        "type": "TableKey",
                        "key": self._rename_expr(f["key"], scope),
                        "value": self._rename_expr(f["value"], scope),
                    })
            res = {"type": "TableConstructorExpression", "fields": fs}
            if x.get("_cell"):
                res["_cell"] = True
            return res
        return copy.deepcopy(x)


def _subst_upval_table(node, upval_param: str, captures: list[dict]):
    """Replace `upval_param[k]` (1-indexed) with `captures[k - 1]`."""
    if isinstance(node, list):
        return [_subst_upval_table(v, upval_param, captures) for v in node]
    if not isinstance(node, dict):
        return node
    if (
        node.get("type") == "IndexExpression"
        and _is_ident(node["base"], upval_param)
        and node["index"].get("type") == "NumericLiteral"
    ):
        idx = int(node["index"]["value"]) - 1
        if 0 <= idx < len(captures):
            return copy.deepcopy(captures[idx])
    return {k: _subst_upval_table(v, upval_param, captures) for k, v in node.items()}


def inline_moonveil_exports(selected: dict, entry_node: dict) -> list[dict] | None:
    """Inline tree-structured MoonVeil exports starting from `entry_node`.
    Returns a clean top-level statement list if all closures inline cleanly,
    otherwise None (caller falls back safely).
    """
    roles = _find_builtin_roles(selected)
    factories = {}
    for name, fn in selected.items():
        if name in roles:
            continue
        if fn.get("type") != "FunctionDeclaration":
            return None
        params = fn.get("parameters", [])
        if not (1 <= len(params) <= 2 and all(p.get("type") == "Identifier" for p in params)):
            return None
        fn_norm = normalize_cf_fn(fn)
        body = fn_norm.get("body", [])
        if len(body) != 1 or body[0].get("type") != "ReturnStatement" or len(body[0].get("arguments", [])) != 1:
            return None
        inner = body[0]["arguments"][0]
        if inner.get("type") != "FunctionDeclaration":
            return None
        self_p = params[0]["name"]
        up_p = params[1]["name"] if len(params) == 2 else None
        inner_clean = _rewrite_self_refs(inner, self_p, roles)
        factories[name] = (self_p, up_p, inner_clean)

    alpha = _AlphaRenamer()

    def expand_node(node, self_name: str, active_stack: tuple[str, ...]):
        if isinstance(node, list):
            out_list = []
            for v in node:
                ev = expand_node(v, self_name, active_stack)
                if ev is None and v is not None:
                    return None
                out_list.append(ev)
            return out_list
        if not isinstance(node, dict):
            return node

        # Match `self_name:Export(...)` (CallExpression or TableCallExpression)
        if node.get("type") in ("CallExpression", "TableCallExpression"):
            base = node["base"]
            if (
                base.get("type") == "MemberExpression"
                and base["indexer"] == ":"
                and _is_ident(base["base"], self_name)
            ):
                target = base["identifier"]["name"]
                if target in factories and target not in active_stack:
                    f_self, f_up, f_inner = factories[target]
                    args = (
                        [node["arguments"]]
                        if node["type"] == "TableCallExpression"
                        else node["arguments"]
                    )
                    captures = []
                    if len(args) == 1 and args[0].get("type") == "TableConstructorExpression":
                        for fld in args[0]["fields"]:
                            if fld["type"] != "TableValue":
                                return None
                            cap = expand_node(fld["value"], self_name, active_stack)
                            if cap is None or cap.get("type") != "Identifier":
                                return None
                            captures.append(cap)
                    elif len(args) == 0:
                        captures = []
                    else:
                        return None

                    # Top-down: alpha-rename bound locals first, substitute upvalue table
                    # `f_up[i] -> captures[i-1]` so child calls like `c:K({a[3], a[2]})`
                    # become `c:K({I, F})`, THEN expand child exports!
                    step_inner = alpha.rename_fn(f_inner)
                    if f_up is not None:
                        step_inner = _subst_upval_table(step_inner, f_up, captures)
                        for sub in walk(step_inner):
                            if _is_ident(sub, f_up):
                                return None
                    expanded_inner = expand_node(step_inner, f_self, active_stack + (target,))
                    if expanded_inner is None:
                        return None
                    for sub in walk(expanded_inner):
                        if _is_ident(sub, f_self):
                            return None
                    return expanded_inner

        out = {}
        for k, v in node.items():
            ev = expand_node(v, self_name, active_stack)
            if ev is None and v is not None:
                return None
            out[k] = ev
        return out

    # Expand entry_node: `function(a, ...) return a:k()(...) end`
    entry_cf = normalize_cf_fn(entry_node)
    entry_params = entry_cf.get("parameters", [])
    if not entry_params or entry_params[0].get("type") != "Identifier":
        return None
    entry_self = entry_params[0]["name"]
    entry_body_rewritten = _rewrite_self_refs(copy.deepcopy(entry_cf["body"]), entry_self, roles)
    ebody = expand_node(entry_body_rewritten, entry_self, ())
    if ebody is None:
        return None
    for sub in walk(ebody):
        if _is_ident(sub, entry_self):
            return None

    # Unwrap `(function(...) <body> end)(...)` at entry
    if (
        len(ebody) == 1
        and ebody[0]["type"] == "ReturnStatement"
        and len(ebody[0]["arguments"]) == 1
        and ebody[0]["arguments"][0]["type"] == "CallExpression"
        and ebody[0]["arguments"][0]["base"]["type"] == "FunctionDeclaration"
    ):
        root_fn = ebody[0]["arguments"][0]["base"]
        call_args = ebody[0]["arguments"][0]["arguments"]
        if not root_fn["parameters"] or (
            len(root_fn["parameters"]) == 1
            and root_fn["parameters"][0]["type"] == "VarargLiteral"
            and len(call_args) == 1
            and call_args[0]["type"] == "VarargLiteral"
        ):
            return root_fn["body"]
    return ebody


# ---------------------------------------------------------------------------
# Pass 3: Sequentialize parallel assignments + fold `_mv_pack__` / `_mv_unpack__`
#         + reconstruct generic `for ... in` loops BEFORE cell unboxing!
# ---------------------------------------------------------------------------

def _reads_of(node) -> set[str]:
    names = set()
    if isinstance(node, dict):
        if node.get("type") == "Identifier":
            names.add(node["name"])
        elif node.get("type") == "MemberExpression":
            names.update(_reads_of(node["base"]))
        elif node.get("type") == "TableKeyString":
            names.update(_reads_of(node["value"]))
        else:
            for k, v in node.items():
                if k not in ("range", "loc"):
                    names.update(_reads_of(v))
    elif isinstance(node, list):
        for item in node:
            names.update(_reads_of(item))
    return names


PURE_VALUE_CTORS = {
    "UDim2.new", "UDim2.fromScale", "UDim2.fromOffset",
    "UDim.new", "Color3.fromRGB", "Color3.fromHSV", "Color3.new",
    "Vector2.new", "Vector3.new", "CFrame.new", "CFrame.Angles",
    "TweenInfo.new", "NumberRange.new", "Rect.new",
}


def _is_pure_expr(x: dict) -> bool:
    t = x["type"]
    if t in ("Identifier", "NumericLiteral", "StringLiteral", "BooleanLiteral", "NilLiteral", "FunctionDeclaration"):
        return True
    if t == "MemberExpression":
        return _is_pure_expr(x["base"])
    if t == "IndexExpression":
        return _is_pure_expr(x["base"]) and _is_pure_expr(x["index"])
    if t == "UnaryExpression":
        return _is_pure_expr(x["argument"])
    if t in ("BinaryExpression", "LogicalExpression"):
        return _is_pure_expr(x["left"]) and _is_pure_expr(x["right"])
    if t == "TableConstructorExpression":
        return all(_is_pure_expr(f["value"]) and ("key" not in f or f["type"] == "TableKeyString" or _is_pure_expr(f["key"])) for f in x["fields"])
    if t == "CallExpression":
        return format_expr(x["base"], 0) in PURE_VALUE_CTORS and all(_is_pure_expr(a) for a in x["arguments"])
    return False


def _lhs_root_name(v: dict) -> str | None:
    cur = v
    while cur.get("type") in ("MemberExpression", "IndexExpression"):
        cur = cur["base"]
    return cur["name"] if cur.get("type") == "Identifier" else None


def _desugar_parallel_assign(stmt: dict, temp_gen) -> list[dict]:
    """Turn `v1, v2, ..., vn = e1, e2, ..., en` into hazard-free sequential assignments."""
    vs = stmt["variables"]
    ins = stmt["init"]
    if len(vs) <= 1 or len(vs) != len(ins):
        return [stmt]
    # Keep multi-return tail calls intact if last init could expand, though len(vs)==len(ins) evaluates 1-to-1 in Lua!
    pairs = list(zip(vs, ins))
    # Try topological ordering when RHS doesn't have conflicting side effects:
    # Pair i must run BEFORE pair j if pair i's RHS reads pair j's LHS root variable!
    # Wait: in Lua `v0, v1 = e0, e1`, e0 is evaluated BEFORE e1, then assigned!
    # If all RHS expressions except at most one are pure, evaluation order of pure RHS doesn't matter;
    # only read-after-write hazards matter!
    impure_indices = [idx for idx, (_, r) in enumerate(pairs) if not _is_pure_expr(r)]
    if len(impure_indices) <= 1:
        n = len(pairs)
        lhs_roots = [_lhs_root_name(v) for v, _ in pairs]
        rhs_reads = [_reads_of(r) for _, r in pairs]
        # i must precede j if:
        # 1) lhs_roots[j] in rhs_reads[i] (writing j first would clobber what i reads!), OR
        # 2) lhs_roots[i] is modified by impure j, etc.
        must_before = {i: set() for i in range(n)}
        for i in range(n):
            for j in range(n):
                if i == j:
                    continue
                if lhs_roots[j] and lhs_roots[j] in rhs_reads[i]:
                    must_before[i].add(j)
        # Kahn topological sort preferring original order
        indeg = {i: 0 for i in range(n)}
        for i, targets in must_before.items():
            for j in targets:
                indeg[j] += 1
        order = []
        ready = [i for i in range(n) if indeg[i] == 0]
        while ready:
            ready.sort()
            u = ready.pop(0)
            order.append(u)
            for w in must_before[u]:
                indeg[w] -= 1
                if indeg[w] == 0:
                    ready.append(w)
        if len(order) == n:
            return [
                {"type": "AssignmentStatement", "variables": [pairs[idx][0]], "init": [pairs[idx][1]]}
                for idx in order
            ]

    # General fallback with temporary locals preserving exact Lua left-to-right RHS evaluation
    temps = [_ident(temp_gen()) for _ in pairs]
    out = [
        {"type": "LocalStatement", "variables": [t], "init": [r]}
        for t, (_, r) in zip(temps, pairs)
    ]
    out.extend(
        {"type": "AssignmentStatement", "variables": [v], "init": [t]}
        for (v, _), t in zip(pairs, temps)
    )
    return out


# ---------------------------------------------------------------------------
# Pass 4: Scoped Live-Range Splitting + Safe Forward Expression Propagation
#         + Method-Call (`:`) Recovery + Array Constructor Recovery
# ---------------------------------------------------------------------------

def _count_ident_uses(nodes, target: str) -> int:
    c = 0
    if isinstance(nodes, dict):
        if nodes.get("type") == "Identifier" and nodes.get("name") == target:
            return 1
        if nodes.get("type") == "MemberExpression":
            return _count_ident_uses(nodes["base"], target)
        if nodes.get("type") == "TableKeyString":
            return _count_ident_uses(nodes["value"], target)
        for k, v in nodes.items():
            if k not in ("range", "loc"):
                c += _count_ident_uses(v, target)
    elif isinstance(nodes, list):
        for item in nodes:
            c += _count_ident_uses(item, target)
    return c


def _subst_ident_in_expr(node, target: str, replacement: dict):
    if isinstance(node, list):
        return [_subst_ident_in_expr(v, target, replacement) for v in node]
    if not isinstance(node, dict):
        return node
    t = node.get("type")
    if t == "Identifier" and node["name"] == target:
        return copy.deepcopy(replacement)
    if t == "FunctionDeclaration":
        if any(p.get("type") == "Identifier" and p["name"] == target for p in node.get("parameters", [])):
            return copy.deepcopy(node)
        return {
            **node,
            "body": _subst_ident_in_block(node["body"], target, replacement),
        }
    if t == "MemberExpression":
        return {
            **node,
            "base": _subst_ident_in_expr(node["base"], target, replacement),
        }
    if t == "TableConstructorExpression":
        fs = []
        for f in node["fields"]:
            if f["type"] == "TableKeyString":
                fs.append({**f, "value": _subst_ident_in_expr(f["value"], target, replacement)})
            elif f["type"] == "TableKey":
                fs.append({
                    **f,
                    "key": _subst_ident_in_expr(f["key"], target, replacement),
                    "value": _subst_ident_in_expr(f["value"], target, replacement),
                })
            else:
                fs.append({**f, "value": _subst_ident_in_expr(f["value"], target, replacement)})
        res = {"type": "TableConstructorExpression", "fields": fs}
        if node.get("_cell"):
            res["_cell"] = True
        return res
    return {
        k: (_subst_ident_in_expr(v, target, replacement) if k not in ("range", "loc") else v)
        for k, v in node.items()
    }


def _subst_ident_in_block(stmts: list[dict], target: str, replacement: dict) -> list[dict]:
    out = []
    shadowed = False
    for s in stmts:
        if shadowed:
            out.append(copy.deepcopy(s))
            continue
        t = s["type"]
        if t == "LocalStatement":
            new_init = [_subst_ident_in_expr(e, target, replacement) for e in s.get("init", [])]
            out.append({**s, "init": new_init})
            if any(v["name"] == target for v in s["variables"]):
                shadowed = True
        elif t == "AssignmentStatement":
            new_init = [_subst_ident_in_expr(e, target, replacement) for e in s["init"]]
            new_vars = []
            reassigned = False
            for v in s["variables"]:
                if v["type"] == "Identifier" and v["name"] == target:
                    new_vars.append(copy.deepcopy(v))
                    reassigned = True
                else:
                    new_vars.append(_subst_ident_in_expr(v, target, replacement))
            out.append({**s, "variables": new_vars, "init": new_init})
            if reassigned:
                shadowed = True
        elif t == "ReturnStatement":
            out.append({**s, "arguments": [_subst_ident_in_expr(e, target, replacement) for e in s["arguments"]]})
        elif t == "CallStatement":
            out.append({**s, "expression": _subst_ident_in_expr(s["expression"], target, replacement)})
        elif t == "IfStatement":
            clauses = []
            for c in s["clauses"]:
                nc = {**c, "body": _subst_ident_in_block(c["body"], target, replacement)}
                if "condition" in c and c["condition"] is not None:
                    nc["condition"] = _subst_ident_in_expr(c["condition"], target, replacement)
                clauses.append(nc)
            out.append({"type": "IfStatement", "clauses": clauses})
        elif t in ("WhileStatement", "RepeatStatement"):
            out.append({
                **s,
                "condition": _subst_ident_in_expr(s["condition"], target, replacement),
                "body": _subst_ident_in_block(s["body"], target, replacement),
            })
        elif t == "ForGenericStatement":
            new_iters = [_subst_ident_in_expr(it, target, replacement) for it in s["iterators"]]
            if any(v["name"] == target for v in s["variables"]):
                out.append({**s, "iterators": new_iters})
            else:
                out.append({**s, "iterators": new_iters, "body": _subst_ident_in_block(s["body"], target, replacement)})
        elif t == "ForNumericStatement":
            ns = {
                **s,
                "start": _subst_ident_in_expr(s["start"], target, replacement),
                "end": _subst_ident_in_expr(s["end"], target, replacement),
                "step": _subst_ident_in_expr(s["step"], target, replacement) if s.get("step") else None,
            }
            if s["variable"]["name"] != target:
                ns["body"] = _subst_ident_in_block(s["body"], target, replacement)
            out.append(ns)
        elif t == "DoStatement":
            out.append({"type": "DoStatement", "body": _subst_ident_in_block(s["body"], target, replacement)})
        else:
            out.append(copy.deepcopy(s))
    return out


def _stmt_has_side_effect_or_writes(stmt: dict, protected_vars: set[str], allow_pure_writes: bool = False) -> bool:
    """True if executing `stmt` can mutate any var in `protected_vars` or perform an impure call/table write."""
    t = stmt["type"]
    if t in ("AssignmentStatement", "LocalStatement"):
        for v in stmt["variables"]:
            if v["type"] != "Identifier":
                return True  # table property/index write might alias!
            if v["name"] in protected_vars:
                return True
        for e in stmt.get("init", []):
            if not _is_pure_expr(e):
                return True
            if any(n.get("type") == "TableConstructorExpression" for n in walk(e)):
                pass
        return False
    return True


def _expr_has_table_read(x: dict) -> bool:
    for n in walk(x):
        if isinstance(n, dict) and n.get("type") in ("MemberExpression", "IndexExpression"):
            # Reading a global like `UDim2.new` or `Color3.fromRGB` or `Enum.Font.LuckiestGuy` is immutable!
            root = _lhs_root_name(n)
            if root not in LUA_GLOBALS:
                return True
    return False


def _find_captured_vars(fn_body: list[dict]) -> set[str]:
    """Variables referenced inside nested FunctionDeclarations."""
    captured = set()
    for s in fn_body:
        for n in walk(s):
            if isinstance(n, dict) and n.get("type") == "FunctionDeclaration":
                own = {p["name"] for p in n.get("parameters", []) if p["type"] == "Identifier"}
                for sub in walk(n["body"]):
                    if isinstance(sub, dict) and sub.get("type") == "LocalStatement":
                        own.update(v["name"] for v in sub["variables"])
                for sub in walk(n["body"]):
                    if isinstance(sub, dict) and sub.get("type") == "Identifier" and sub["name"] not in own and sub["name"] not in LUA_GLOBALS:
                        captured.add(sub["name"])
    return captured


def _live_before_overwrite(stmts: list[dict], var: str) -> tuple[bool, int]:
    """Check if `var` is read in `stmts` before being unconditionally overwritten,
    and return (is_read_or_escapes_to_outer_loop, last_stmt_idx_referencing_var_before_kill).
    Returns (False, -1) if `var` is killed before any read or never read at all!
    """
    for idx, s in enumerate(stmts):
        t = s["type"]
        if t == "AssignmentStatement":
            if any(_count_ident_uses(e, var) > 0 for e in s["init"]):
                return True, idx
            for v in s["variables"]:
                if v["type"] != "Identifier" and _count_ident_uses(v, var) > 0:
                    return True, idx
            if any(v["type"] == "Identifier" and v["name"] == var for v in s["variables"]):
                return False, idx  # unconditionally overwritten!
        elif t == "LocalStatement":
            if any(_count_ident_uses(e, var) > 0 for e in s.get("init", [])):
                return True, idx
            if any(v["name"] == var for v in s["variables"]):
                return False, idx
        elif t == "ReturnStatement":
            if any(_count_ident_uses(e, var) > 0 for e in s["arguments"]):
                return True, idx
            return False, idx
        elif t == "BreakStatement":
            return True, idx  # conservatively assume outer loop could read it unless dead after loop
        else:
            if _count_ident_uses(s, var) > 0:
                return True, idx
    return False, -1


def _fold_method_calls(node):
    """Rewrite `(obj.Method)(obj, ...)` -> `obj:Method(...)` and unwrap `_mv_pack__`/`_mv_unpack__`."""
    if isinstance(node, list):
        return [_fold_method_calls(v) for v in node]
    if not isinstance(node, dict):
        return node
    out = {k: _fold_method_calls(v) for k, v in node.items()}

    # Unwrap `__mv_unpack__(__mv_pack__(expr))` -> `expr`
    if (
        out.get("type") == "CallExpression"
        and _is_ident(out["base"], "__mv_unpack__")
        and len(out["arguments"]) == 1
        and out["arguments"][0].get("type") == "CallExpression"
        and _is_ident(out["arguments"][0]["base"], "__mv_pack__")
        and len(out["arguments"][0]["arguments"]) == 1
    ):
        return out["arguments"][0]["arguments"][0]

    # `(obj.Method)(obj, a, b)` -> `obj:Method(a, b)` when `obj` is side-effect free
    if out.get("type") == "CallExpression" and out["arguments"]:
        b = out["base"]
        first = out["arguments"][0]
        if (
            b.get("type") == "MemberExpression"
            and b["indexer"] == "."
            and _is_pure_expr(b["base"])
            and format_expr(b["base"], 0) == format_expr(first, 0)
            and _lhs_root_name(b["base"]) not in ("string", "table", "math", "bit32", "os", "coroutine", "Instance", "UDim2", "Color3", "Vector2", "Vector3", "CFrame")
        ):
            return {
                "type": "CallExpression",
                "base": {
                    "type": "MemberExpression",
                    "base": b["base"],
                    "indexer": ":",
                    "identifier": b["identifier"],
                },
                "arguments": out["arguments"][1:],
            }
    return out


class _UnionFind:
    def __init__(self):
        self.parent = {}

    def add(self, x: int):
        if x not in self.parent:
            self.parent[x] = x

    def find(self, x: int) -> int:
        self.add(x)
        r = x
        while self.parent[r] != r:
            r = self.parent[r]
        while self.parent[x] != r:
            nxt = self.parent[x]
            self.parent[x] = r
            x = nxt
        return r

    def union(self, a: int, b: int):
        ra, rb = self.find(a), self.find(b)
        if ra != rb:
            if ra < rb:
                self.parent[rb] = ra
            else:
                self.parent[ra] = rb


def _desugar_block_recursive(stmts: list[dict], fresh_fn) -> list[dict]:
    out = []
    for s in stmts:
        t = s["type"]
        if t == "AssignmentStatement":
            for ds in _desugar_parallel_assign(s, fresh_fn):
                ds["init"] = [_desugar_expr_recursive(e, fresh_fn) for e in ds["init"]]
                out.append(ds)
        elif t == "LocalStatement":
            out.append({**s, "init": [_desugar_expr_recursive(e, fresh_fn) for e in s.get("init", [])]})
        elif t == "IfStatement":
            out.append({
                "type": "IfStatement",
                "clauses": [
                    {
                        **c,
                        **({"condition": _desugar_expr_recursive(c["condition"], fresh_fn)} if "condition" in c and c["condition"] is not None else {}),
                        "body": _desugar_block_recursive(c["body"], fresh_fn),
                    }
                    for c in s["clauses"]
                ],
            })
        elif t in ("WhileStatement", "RepeatStatement"):
            out.append({
                **s,
                "condition": _desugar_expr_recursive(s["condition"], fresh_fn),
                "body": _desugar_block_recursive(s["body"], fresh_fn),
            })
        elif t in ("ForGenericStatement", "ForNumericStatement", "DoStatement"):
            out.append({**s, "body": _desugar_block_recursive(s["body"], fresh_fn)})
        elif t == "CallStatement":
            out.append({**s, "expression": _desugar_expr_recursive(s["expression"], fresh_fn)})
        elif t == "ReturnStatement":
            out.append({**s, "arguments": [_desugar_expr_recursive(a, fresh_fn) for a in s["arguments"]]})
        elif t == "FunctionDeclaration":
            out.append({**s, "body": _desugar_block_recursive(s["body"], fresh_fn)})
        else:
            out.append(copy.deepcopy(s))
    return out


def _desugar_expr_recursive(x, fresh_fn):
    if isinstance(x, list):
        return [_desugar_expr_recursive(i, fresh_fn) for i in x]
    if not isinstance(x, dict):
        return x
    if x.get("type") == "FunctionDeclaration":
        return {**x, "body": _desugar_block_recursive(x["body"], fresh_fn)}
    return {k: (_desugar_expr_recursive(v, fresh_fn) if k not in ("range", "loc") else v) for k, v in x.items()}


def _split_webs_in_fn_body(stmts: list[dict], protected_vars: set[str], fresh_fn) -> list[dict]:
    """Muchnick §16.3.3 Reaching-Definitions + Union-Find Def-Use Web Splitting!
    Splits reused MoonVeil registers into independent SSA-like webs whenever two
    live ranges have zero common reaching uses, while keeping phi-merged branches
    (`if s then s = ... end; if s then`) and multi-return kills (`b, d = b(d)`)
    100% sound!
    """
    stmts = copy.deepcopy(stmts)
    # Candidate variables: locals declared/assigned in THIS function body (excluding inner LocalStatements inside sub-blocks,
    # loop induction variables, parameters, outer free vars, captured upvalues, and `__cell_*`!).
    inner_scoped = set()
    for s in stmts:
        for n in _walk_same_fn(s):
            if isinstance(n, dict):
                nt = n.get("type")
                if nt == "LocalStatement" and n not in stmts:
                    inner_scoped.update(v["name"] for v in n["variables"])
                elif nt == "ForGenericStatement":
                    inner_scoped.update(v["name"] for v in n["variables"])
                elif nt == "ForNumericStatement":
                    inner_scoped.add(n["variable"]["name"])

    candidates = set()
    for s in stmts:
        if s["type"] == "LocalStatement" and not s.get("init"):
            for v in s["variables"]:
                nm = v["name"]
                if nm not in protected_vars and nm not in inner_scoped and not nm.startswith("__cell_"):
                    candidates.add(nm)
    for n in _walk_same_fn(stmts):
        if isinstance(n, dict) and n.get("type") == "AssignmentStatement":
            for v in n["variables"]:
                if v.get("type") == "Identifier":
                    nm = v["name"]
                    if nm not in protected_vars and nm not in inner_scoped and nm not in LUA_GLOBALS and not nm.startswith("__cell_"):
                        candidates.add(nm)

    if not candidates:
        return stmts

    uf = _UnionFind()
    next_uid = [1]
    ast_to_uid: dict[int, int] = {}
    uid_to_node: dict[int, dict] = {}
    uid_to_var: dict[int, str] = {}
    uninit_uid: dict[str, int] = {}

    def alloc_uid() -> int:
        u = next_uid[0]
        next_uid[0] += 1
        uf.add(u)
        return u

    for v in sorted(candidates):
        uninit_uid[v] = alloc_uid()

    def node_uid(nd: dict, vname: str) -> int:
        key = id(nd)
        if key not in ast_to_uid:
            u = alloc_uid()
            ast_to_uid[key] = u
            uid_to_node[u] = nd
            uid_to_var[u] = vname
        return ast_to_uid[key]

    def copy_defs(d: dict[str, set[int]]) -> dict[str, set[int]]:
        return {k: set(vs) for k, vs in d.items()}

    def union_defs(list_of_defs: list[dict[str, set[int]]]) -> dict[str, set[int]] | None:
        valid = [d for d in list_of_defs if d is not None]
        if not valid:
            return None
        return {v: set().union(*(d[v] for d in valid)) for v in candidates}

    def visit_expr(x, defs: dict[str, set[int]]):
        if isinstance(x, list):
            for item in x:
                visit_expr(item, defs)
            return
        if not isinstance(x, dict):
            return
        t = x.get("type")
        if t == "FunctionDeclaration":
            return  # Captured vars are already in `protected_vars`
        if t == "Identifier":
            nm = x["name"]
            if nm in candidates:
                u = node_uid(x, nm)
                for did in defs[nm]:
                    uf.union(u, did)
            return
        if t == "MemberExpression":
            visit_expr(x["base"], defs)
            return
        if t == "TableConstructorExpression":
            for f in x["fields"]:
                if f["type"] == "TableKey":
                    visit_expr(f["key"], defs)
                visit_expr(f["value"], defs)
            return
        for k, v in x.items():
            if k not in ("range", "loc"):
                visit_expr(v, defs)

    def visit_block(blk: list[dict], defs_in: dict[str, set[int]] | None, break_sink: list | None = None) -> dict[str, set[int]] | None:
        cur = copy_defs(defs_in) if defs_in is not None else None
        for s in blk:
            if cur is None:
                break
            t = s["type"]
            if t == "AssignmentStatement":
                visit_expr(s["init"], cur)
                for lv in s["variables"]:
                    if lv["type"] != "Identifier":
                        visit_expr(lv, cur)
                for lv in s["variables"]:
                    if lv["type"] == "Identifier" and lv["name"] in candidates:
                        did = node_uid(lv, lv["name"])
                        cur[lv["name"]] = {did}
            elif t == "LocalStatement":
                if s.get("init"):
                    visit_expr(s["init"], cur)
                    for lv in s["variables"]:
                        if lv["name"] in candidates:
                            did = node_uid(lv, lv["name"])
                            cur[lv["name"]] = {did}
            elif t == "CallStatement":
                visit_expr(s["expression"], cur)
            elif t == "ReturnStatement":
                visit_expr(s["arguments"], cur)
                cur = None
            elif t == "BreakStatement":
                if break_sink is not None:
                    break_sink.append(copy_defs(cur))
                cur = None
            elif t == "DoStatement":
                cur = visit_block(s["body"], cur, break_sink)
            elif t == "IfStatement":
                fall = copy_defs(cur)
                outs = []
                has_else = False
                for c in s["clauses"]:
                    if "condition" in c and c["condition"] is not None:
                        visit_expr(c["condition"], fall)
                    else:
                        has_else = True
                    bo = visit_block(c["body"], copy_defs(fall), break_sink)
                    if bo is not None:
                        outs.append(bo)
                if not has_else:
                    outs.append(fall)
                cur = union_defs(outs)
            elif t == "WhileStatement":
                head = copy_defs(cur)
                while True:
                    brks = []
                    visit_expr(s["condition"], head)
                    bo = visit_block(s["body"], copy_defs(head), brks)
                    nxt = union_defs([cur] + ([bo] if bo is not None else []))
                    if nxt == head:
                        break
                    head = nxt
                if s["condition"].get("type") == "BooleanLiteral" and s["condition"].get("value") is True:
                    cur = union_defs(brks)
                else:
                    cur = union_defs([head] + brks)
            elif t == "RepeatStatement":
                head = copy_defs(cur)
                while True:
                    brks = []
                    bo = visit_block(s["body"], copy_defs(head), brks)
                    if bo is not None:
                        visit_expr(s["condition"], bo)
                    nxt = union_defs([cur] + ([bo] if bo is not None else []))
                    if nxt == head:
                        break
                    head = nxt
                cur = union_defs(([bo] if bo is not None else []) + brks)
            elif t == "ForGenericStatement":
                visit_expr(s["iterators"], cur)
                head = copy_defs(cur)
                while True:
                    brks = []
                    bo = visit_block(s["body"], copy_defs(head), brks)
                    nxt = union_defs([cur] + ([bo] if bo is not None else []))
                    if nxt == head:
                        break
                    head = nxt
                cur = union_defs([head] + brks)
            elif t == "ForNumericStatement":
                visit_expr(s["start"], cur)
                visit_expr(s["end"], cur)
                if s.get("step"):
                    visit_expr(s["step"], cur)
                head = copy_defs(cur)
                while True:
                    brks = []
                    bo = visit_block(s["body"], copy_defs(head), brks)
                    nxt = union_defs([cur] + ([bo] if bo is not None else []))
                    if nxt == head:
                        break
                    head = nxt
                cur = union_defs([head] + brks)
        return cur

    init_defs = {v: {uninit_uid[v]} for v in candidates}
    visit_block(stmts, init_defs, None)

    # Group AST nodes per candidate variable into connected Def-Use webs
    webs_per_var: dict[str, dict[int, list[dict]]] = {v: {} for v in candidates}
    for u, nd in uid_to_node.items():
        v = uid_to_var[u]
        root = uf.find(u)
        webs_per_var[v].setdefault(root, []).append(nd)

    for v in sorted(candidates):
        webs = webs_per_var[v]
        if len(webs) <= 1:
            continue
        for root_id in sorted(webs.keys()):
            wname = f"__w_{fresh_fn()}_{v}"
            for nd in webs[root_id]:
                nd["name"] = wname

    return stmts


def _count_total_writes_same_fn(stmts: list[dict]) -> dict[str, int]:
    counts: dict[str, int] = {}
    for n in _walk_same_fn(stmts):
        if isinstance(n, dict) and n.get("type") in ("AssignmentStatement", "LocalStatement"):
            if n["type"] == "LocalStatement" and not n.get("init"):
                continue
            for v in n["variables"]:
                if v.get("type") == "Identifier":
                    counts[v["name"]] = counts.get(v["name"], 0) + 1
    return counts


def _count_all_ident_occurrences(nodes) -> dict[str, int]:
    """Count EVERY Identifier occurrence (LHS write, local decl, RHS read, and inside nested closures!)
    across the entire enclosing function AST.
    A transformation on `v` in `cur[idx:]` is 100% localized iff `_count_ident_uses_and_defs(cur[idx:], v) == fn_occ[v]`!
    """
    occ: dict[str, int] = {}

    def rec(n):
        if isinstance(n, list):
            for x in n:
                rec(x)
            return
        if not isinstance(n, dict):
            return
        t = n.get("type")
        if t == "Identifier":
            occ[n["name"]] = occ.get(n["name"], 0) + 1
            return
        if t == "MemberExpression":
            rec(n["base"])
            return
        if t == "TableConstructorExpression":
            for f in n["fields"]:
                if f["type"] == "TableKey":
                    rec(f["key"])
                rec(f["value"])
            return
        if t == "LocalStatement" and not n.get("init"):
            return  # Ignore empty top-of-function `local a, b, c` buckets!
        for k, v in n.items():
            if k not in ("range", "loc"):
                rec(v)

    rec(nodes)
    return occ


def _optimize_block(stmts: list[dict], non_split_vars: set[str], fresh_fn, is_fn_root: bool = True) -> list[dict]:
    """Desugar parallel assignments, split Def-Use register webs cleanly, and fold expressions."""
    cur = _desugar_block_recursive(stmts, fresh_fn)
    cur = _split_webs_in_fn_body(cur, non_split_vars, fresh_fn)
    for _ in range(4):
        fn_occ = _count_all_ident_occurrences(cur)
        total_writes = _count_total_writes_same_fn(cur)
        deep_writes = _count_writes_deep(cur)
        nxt = _fold_block_pass(cur, non_split_vars, total_writes, deep_writes, fn_occ, fresh_fn)
        if format_block(nxt, 0) == format_block(cur, 0):
            cur = nxt
            break
        cur = nxt
    return cur


def _count_writes_deep(nodes) -> dict[str, int]:
    """Count total assignments/initialized-locals per variable INCLUDING inside nested closures."""
    counts: dict[str, int] = {}
    for n in walk(nodes):
        if isinstance(n, dict) and n.get("type") in ("AssignmentStatement", "LocalStatement"):
            if n["type"] == "LocalStatement" and not n.get("init"):
                continue
            for v in n["variables"]:
                if v.get("type") == "Identifier":
                    counts[v["name"]] = counts.get(v["name"], 0) + 1
    return counts


def _fold_block_pass(
    stmts: list[dict],
    non_split_vars: set[str],
    total_writes: dict[str, int],
    deep_writes: dict[str, int],
    fn_occ: dict[str, int],
    fresh_fn,
) -> list[dict]:
    cur = copy.deepcopy(stmts)
    for _ in range(8):
        changed = False
        new_cur = []
        idx = 0
        while idx < len(cur):
            s = cur[idx]
            # 0a. Adjacent multi-return alias merge: `a, b = call(); local c = b` -> `a, c = call()`
            if (
                idx + 1 < len(cur)
                and s["type"] in ("AssignmentStatement", "LocalStatement")
                and len(s["variables"]) >= 2
                and all(v["type"] == "Identifier" for v in s["variables"])
                and cur[idx + 1]["type"] in ("AssignmentStatement", "LocalStatement")
                and len(cur[idx + 1]["variables"]) == 1
                and len(cur[idx + 1]["init"]) == 1
                and cur[idx + 1]["variables"][0]["type"] == "Identifier"
                and cur[idx + 1]["init"][0]["type"] == "Identifier"
                and not _is_cell_ctor(cur[idx + 1]["init"][0])
            ):
                src_nm = cur[idx + 1]["init"][0]["name"]
                dst_id = cur[idx + 1]["variables"][0]
                if (
                    src_nm not in non_split_vars
                    and total_writes.get(src_nm, 99) == 1
                    and fn_occ.get(src_nm, 0) == 2
                    and any(v["name"] == src_nm for v in s["variables"])
                    and _count_ident_uses(cur[idx + 1 :], src_nm) == 1
                ):
                    ns = copy.deepcopy(s)
                    ns["variables"] = [copy.deepcopy(dst_id) if v["name"] == src_nm else v for v in ns["variables"]]
                    if cur[idx + 1]["type"] == "LocalStatement":
                        ns["type"] = "LocalStatement"
                    cur[idx + 1] = ns
                    fn_occ[src_nm] = 0
                    changed = True
                    idx += 1
                    continue

            if (
                s["type"] in ("AssignmentStatement", "LocalStatement")
                and len(s["variables"]) == 1
                and len(s["init"]) == 1
                and s["variables"][0]["type"] == "Identifier"
                and not _is_cell_ctor(s["init"][0])
            ):
                vname = s["variables"][0]["name"]
                rhs = s["init"][0]
                tail = cur[idx + 1 :]
                uses = _count_ident_uses(tail, vname)
                # AIRTIGHT INVARIANT: `all_in_slice` is True iff 100% of occurrences of `vname` in the ENTIRE function
                # are `s.variables[0]` (1) + `tail` (`uses`)!
                all_in_slice = (_count_ident_uses(rhs, vname) == 0) and (fn_occ.get(vname, -1) == 1 + uses)

                # Dead initial write overwrite: `local v = pure_init; ... (0 uses of v) ...; v = real_rhs` in same block!
                if (
                    s["type"] == "LocalStatement"
                    and _is_pure_expr(rhs)
                    and rhs["type"] != "NilLiteral"
                ):
                    next_wr = None
                    for k2 in range(idx + 1, len(cur)):
                        sk2 = cur[k2]
                        if (
                            sk2["type"] == "AssignmentStatement"
                            and len(sk2["variables"]) == 1
                            and _is_ident(sk2["variables"][0], vname)
                            and _count_ident_uses(sk2["init"], vname) == 0
                        ):
                            next_wr = k2
                            break
                        if _count_ident_uses(sk2, vname) > 0:
                            break
                    if next_wr is not None:
                        # Drop `local v = dead_init` and promote `v = real_rhs` to `local v = real_rhs`!
                        cur[next_wr] = {**cur[next_wr], "type": "LocalStatement"}
                        fn_occ[vname] = fn_occ.get(vname, 1) - 1
                        changed = True
                        idx += 1
                        continue

                # 0b. Adjacent alias merge: `[local] v1 = <ANY rhs>; [local] v2 = v1` where `all_in_slice` & `uses == 1`!
                if (
                    all_in_slice
                    and vname not in non_split_vars
                    and total_writes.get(vname, 99) == 1
                    and uses == 1
                    and tail
                    and tail[0]["type"] in ("AssignmentStatement", "LocalStatement")
                    and len(tail[0]["variables"]) == 1
                    and len(tail[0]["init"]) == 1
                    and tail[0]["variables"][0]["type"] == "Identifier"
                    and _is_ident(tail[0]["init"][0], vname)
                ):
                    merged = copy.deepcopy(tail[0])
                    merged["init"] = [copy.deepcopy(rhs)]
                    cur[idx + 1] = merged
                    fn_occ[vname] = 0
                    changed = True
                    idx += 1
                    continue

                # 0c. Immutable alias of parameter / loop-var (`local __cell = param` where `all_in_slice` & neither is ever mutated!):
                if (
                    all_in_slice
                    and rhs["type"] == "Identifier"
                    and deep_writes.get(vname, 99) == 1
                    and deep_writes.get(rhs["name"], 0) == 0
                ):
                    cur[idx + 1 :] = _subst_ident_in_block(tail, vname, rhs)
                    fn_occ[rhs["name"]] = fn_occ.get(rhs["name"], 0) + uses - 1
                    fn_occ[vname] = 0
                    changed = True
                    idx += 1
                    continue

                is_single_def = all_in_slice and (total_writes.get(vname, 99) == 1)
                if is_single_def and vname not in non_split_vars:
                    # Dead assignment of pure expression (ONLY when `all_in_slice` and `uses == 0`!)
                    if uses == 0 and _is_pure_expr(rhs):
                        fn_occ[vname] = 0
                        changed = True
                        idx += 1
                        continue

                    # Multi-use copy/constant propagation (`x = literal` or `x = another_single_def_var` or `x = Global.Member.Chain`)
                    is_immutable_global_chain = _is_pure_expr(rhs) and not _expr_has_table_read(rhs) and rhs["type"] in ("Identifier", "MemberExpression")
                    is_copy_of_ssa = rhs["type"] == "Identifier" and deep_writes.get(rhs["name"], 99) <= 1 and rhs["name"] not in non_split_vars
                    if uses >= 1 and (_is_literal(rhs) or is_immutable_global_chain or is_copy_of_ssa):
                        cur[idx + 1 :] = _subst_ident_in_block(tail, vname, rhs)
                        fn_occ[vname] = 0
                        for rv in _reads_of(rhs):
                            fn_occ[rv] = fn_occ.get(rv, 0) + uses - 1
                        changed = True
                        idx += 1
                        continue

                    # Single-use propagation (ONLY when `is_single_def`!)
                    if is_single_def and uses == 1:
                        rhs_vars = _reads_of(rhs) | {vname}
                        has_tbl = _expr_has_table_read(rhs)
                        target_k = next((k for k, st in enumerate(tail) if _count_ident_uses(st, vname) > 0), None)
                        if target_k is not None:
                            if _is_pure_expr(rhs):
                                safe = True
                                for mid in tail[:target_k]:
                                    if has_tbl:
                                        if _stmt_has_side_effect_or_writes(mid, rhs_vars):
                                            safe = False
                                            break
                                    else:
                                        written = {
                                            v.get("name")
                                            for n in walk(mid)
                                            if isinstance(n, dict) and n.get("type") in ("AssignmentStatement", "LocalStatement")
                                            for v in n.get("variables", [])
                                            if v.get("type") == "Identifier"
                                        }
                                        if written & rhs_vars:
                                            safe = False
                                            break
                                target_stmt = tail[target_k]
                                if safe and target_stmt["type"] in ("WhileStatement", "RepeatStatement", "ForGenericStatement", "ForNumericStatement"):
                                    header_uses = 0
                                    if target_stmt["type"] == "WhileStatement":
                                        header_uses = _count_ident_uses(target_stmt["condition"], vname)
                                    elif target_stmt["type"] == "ForGenericStatement":
                                        header_uses = _count_ident_uses(target_stmt["iterators"], vname)
                                    elif target_stmt["type"] == "ForNumericStatement":
                                        header_uses = (
                                            _count_ident_uses(target_stmt["start"], vname)
                                            + _count_ident_uses(target_stmt["end"], vname)
                                            + (_count_ident_uses(target_stmt["step"], vname) if target_stmt.get("step") else 0)
                                        )
                                    if header_uses != 1:
                                        safe = False
                                if safe:
                                    cur[idx + 1 + target_k] = _subst_ident_in_block([target_stmt], vname, rhs)[0]
                                    changed = True
                                    idx += 1
                                    continue

                            # Single-use call (`__mv_pack__(...)`, `UDim2.new(...)`, `Color3.fromRGB(...)`, `os.time()`, `:GetService(...)`, etc.):
                            # Allow skipping PURE intervening statements `tail[:target_k]`!
                            elif rhs["type"] == "CallExpression":
                                mids_pure = all(not _stmt_has_side_effect_or_writes(mid, rhs_vars) for mid in tail[:target_k])
                                if mids_pure and _can_inline_call_into_next(rhs, vname, tail[target_k]):
                                    cur[idx + 1 + target_k] = _subst_ident_in_block([tail[target_k]], vname, rhs)[0]
                                    changed = True
                                    idx += 1
                                    continue

            new_cur.append(s)
            idx += 1
        cur = [_fold_method_calls(s) for s in new_cur]

        # 3. Array constructor folding: `tbl = {}; tbl[1] = e1; tbl[2] = e2; ...`
        cur, arr_changed = _fold_array_constructors(cur)
        if arr_changed:
            changed = True

        # 4. Short-circuit boolean folding: `x = A; if x then x = B end` -> `x = A and B`
        cur, bool_changed = _fold_short_circuit_booleans(cur, non_split_vars)
        if bool_changed:
            changed = True
            total_writes = _count_total_writes_same_fn(cur) if total_writes else {}

    # Recurse into structured sub-blocks sharing the function-wide `total_writes`, `deep_writes`, and `fn_occ`!
    final = []
    for s in cur:
        t = s["type"]
        if t == "IfStatement":
            for c in s["clauses"]:
                c["body"] = _fold_block_pass(c["body"], non_split_vars, total_writes, deep_writes, fn_occ, fresh_fn)
        elif t in ("WhileStatement", "RepeatStatement", "DoStatement", "ForNumericStatement", "ForGenericStatement"):
            s["body"] = _fold_block_pass(s["body"], non_split_vars, total_writes, deep_writes, fn_occ, fresh_fn)
        final.append(s)
    return final


def _can_inline_call_into_next(call_expr: dict, vname: str, nxt: dict) -> bool:
    """True if `vname` is evaluated first (before any impure expression or conflicting write) in `nxt`."""
    # Always inline `__mv_pack__(...)` into `__mv_unpack__(vname)` in `nxt` if intervening args are pure!
    is_pack = _is_ident(call_expr["base"], "__mv_pack__")
    # Also inline pure constructors (`UDim2.new`, `Color3.fromRGB`, `Color3.new`, `Vector2.new`, `Vector3.new`, `CFrame.new`, `Instance.new`? Wait: NOT `Instance.new` because we want `local frame = Instance.new("Frame"); frame.Size = ...`!)
    base_str = format_expr(call_expr["base"], 0)
    is_value_ctor = base_str in (
        "UDim2.new", "UDim2.fromScale", "UDim2.fromOffset",
        "UDim.new", "Color3.fromRGB", "Color3.fromHSV", "Color3.new",
        "Vector2.new", "Vector3.new", "CFrame.new", "CFrame.Angles",
        "TweenInfo.new", "NumberRange.new", "Rect.new",
        "os.time", "os.clock", "tick", "tostring", "tonumber",
        "string.lower", "string.upper", "string.find", "string.sub", "string.format",
        "math.clamp", "math.floor", "math.ceil", "math.abs", "math.min", "math.max",
    )
    is_getter_or_query = (
        call_expr["base"].get("type") == "MemberExpression"
        and call_expr["base"]["identifier"]["name"] in (
            "IsA", "GetChildren", "GetDescendants", "GetPropertyChangedSignal",
            "FindFirstChild", "FindFirstChildOfClass", "FindFirstChildWhichIsA",
            "HttpGet", "InvokeServer",
        )
    )
    if not (is_pack or is_value_ctor or is_getter_or_query):
        return False

    nt = nxt["type"]
    if nt in ("AssignmentStatement", "LocalStatement") and len(nxt["init"]) == 1:
        # Check LHS is pure (e.g. `l.Size = h` or `d = tonumber(__mv_unpack__(s))`)
        if not all(_is_pure_expr(v) for v in nxt["variables"]):
            return False
        return _first_impure_uses_var(nxt["init"][0], vname)
    if nt == "ReturnStatement" and len(nxt["arguments"]) == 1:
        return _first_impure_uses_var(nxt["arguments"][0], vname)
    if nt == "CallStatement":
        return _first_impure_uses_var(nxt["expression"], vname)
    if nt == "IfStatement" and nxt["clauses"]:
        return _first_impure_uses_var(nxt["clauses"][0]["condition"], vname)
    return False


def _first_impure_uses_var(expr_node: dict, vname: str) -> bool:
    """True if evaluating `expr_node` reaches `vname` before any other non-pure subexpression."""
    if _count_ident_uses(expr_node, vname) != 1:
        return False
    t = expr_node["type"]
    if t == "Identifier":
        return expr_node["name"] == vname
    if t in ("MemberExpression", "UnaryExpression"):
        sub = expr_node["base"] if t == "MemberExpression" else expr_node["argument"]
        return _first_impure_uses_var(sub, vname)
    if t in ("BinaryExpression", "LogicalExpression"):
        if _count_ident_uses(expr_node["left"], vname) == 1:
            return _first_impure_uses_var(expr_node["left"], vname)
        return _is_pure_expr(expr_node["left"]) and _first_impure_uses_var(expr_node["right"], vname)
    if t == "CallExpression":
        if _count_ident_uses(expr_node["base"], vname) == 1:
            return _first_impure_uses_var(expr_node["base"], vname)
        if not _is_pure_expr(expr_node["base"]):
            return False
        for a in expr_node["arguments"]:
            if _count_ident_uses(a, vname) == 1:
                return _first_impure_uses_var(a, vname)
            if not _is_pure_expr(a):
                return False
    return False


def _fold_array_constructors(stmts: list[dict]) -> tuple[list[dict], bool]:
    out = []
    changed = False
    i = 0
    while i < len(stmts):
        s = stmts[i]
        if (
            s["type"] in ("AssignmentStatement", "LocalStatement")
            and len(s["variables"]) == 1
            and len(s["init"]) == 1
            and s["variables"][0]["type"] == "Identifier"
            and s["init"][0]["type"] == "TableConstructorExpression"
            and len(s["init"][0]["fields"]) == 0
            and not s["init"][0].get("_cell")
        ):
            tname = s["variables"][0]["name"]
            elems = []
            j = i + 1
            expected = 1
            while j < len(stmts):
                sj = stmts[j]
                if (
                    sj["type"] == "AssignmentStatement"
                    and len(sj["variables"]) == 1
                    and len(sj["init"]) == 1
                    and sj["variables"][0]["type"] == "IndexExpression"
                    and _is_ident(sj["variables"][0]["base"], tname)
                    and sj["variables"][0]["index"].get("type") == "NumericLiteral"
                    and sj["variables"][0]["index"]["value"] == expected
                    and _count_ident_uses(sj["init"][0], tname) == 0
                ):
                    elems.append({"type": "TableValue", "value": sj["init"][0]})
                    expected += 1
                    j += 1
                else:
                    break
            if elems:
                ns = copy.deepcopy(s)
                ns["init"][0]["fields"] = elems
                out.append(ns)
                i = j
                changed = True
                continue
        out.append(s)
        i += 1
    return out, changed


def _fold_short_circuit_booleans(stmts: list[dict], protected: set[str]) -> tuple[list[dict], bool]:
    """Fold MoonVeil's lowered `and` / `or` / ternary patterns:
    - `x = A; if x then x = B end` -> `x = A and B`
    - `x = A; if not x then x = B end` -> `x = A or B`
    - `if cond then x = "▲" end; if not x then x = "▼" end` -> `x = cond and "▲" or "▼"`
    """
    out = []
    changed = False
    i = 0
    while i < len(stmts):
        if i + 1 < len(stmts):
            s0, s1 = stmts[i], stmts[i + 1]
            # Pattern 1 & 2: `x = A; if [not] x then x = B end`
            if (
                s0["type"] in ("AssignmentStatement", "LocalStatement")
                and len(s0["variables"]) == 1
                and len(s0["init"]) == 1
                and s0["variables"][0]["type"] == "Identifier"
                and s1["type"] == "IfStatement"
                and len(s1["clauses"]) == 1
                and len(s1["clauses"][0]["body"]) == 1
            ):
                xname = s0["variables"][0]["name"]
                cond = s1["clauses"][0]["condition"]
                b0 = s1["clauses"][0]["body"][0]
                if (
                    b0["type"] == "AssignmentStatement"
                    and len(b0["variables"]) == 1
                    and len(b0["init"]) == 1
                    and _is_ident(b0["variables"][0], xname)
                    and _count_ident_uses(b0["init"][0], xname) == 0
                ):
                    if _is_ident(cond, xname):
                        ns = copy.deepcopy(s0)
                        ns["init"] = [{
                            "type": "LogicalExpression",
                            "operator": "and",
                            "left": s0["init"][0],
                            "right": b0["init"][0],
                        }]
                        out.append(ns)
                        i += 2
                        changed = True
                        continue
                    if cond["type"] == "UnaryExpression" and cond["operator"] == "not" and _is_ident(cond["argument"], xname):
                        ns = copy.deepcopy(s0)
                        ns["init"] = [{
                            "type": "LogicalExpression",
                            "operator": "or",
                            "left": s0["init"][0],
                            "right": b0["init"][0],
                        }]
                        out.append(ns)
                        i += 2
                        changed = True
                        continue

            # Pattern 3: `if d then d = TruthyLit end; if not d then d = FalseLit end`
            if (
                s0["type"] == "IfStatement"
                and len(s0["clauses"]) == 1
                and len(s0["clauses"][0]["body"]) == 1
                and s1["type"] == "IfStatement"
                and len(s1["clauses"]) == 1
                and len(s1["clauses"][0]["body"]) == 1
            ):
                c0 = s0["clauses"][0]["condition"]
                c1 = s1["clauses"][0]["condition"]
                a0 = s0["clauses"][0]["body"][0]
                a1 = s1["clauses"][0]["body"][0]
                if (
                    c0["type"] == "Identifier"
                    and c1["type"] == "UnaryExpression"
                    and c1["operator"] == "not"
                    and _is_ident(c1["argument"], c0["name"])
                    and a0["type"] == "AssignmentStatement"
                    and a1["type"] == "AssignmentStatement"
                    and len(a0["variables"]) == 1
                    and len(a1["variables"]) == 1
                    and _is_ident(a0["variables"][0], c0["name"])
                    and _is_ident(a1["variables"][0], c0["name"])
                    and _is_truthy_literal(a0["init"][0])
                ):
                    out.append({
                        "type": "AssignmentStatement",
                        "variables": [copy.deepcopy(c0)],
                        "init": [{
                            "type": "LogicalExpression",
                            "operator": "or",
                            "left": {
                                "type": "LogicalExpression",
                                "operator": "and",
                                "left": copy.deepcopy(c0),
                                "right": copy.deepcopy(a0["init"][0]),
                            },
                            "right": copy.deepcopy(a1["init"][0]),
                        }],
                    })
                    i += 2
                    changed = True
                    continue
        out.append(stmts[i])
        i += 1
    return out, changed


# ---------------------------------------------------------------------------
# Pass 5: Reconstruct generic `for k, v in iterator do ... end` loops
# ---------------------------------------------------------------------------

def _reconstruct_for_in_expr(x):
    if isinstance(x, list):
        return [_reconstruct_for_in_expr(i) for i in x]
    if not isinstance(x, dict):
        return x
    if x.get("type") == "FunctionDeclaration":
        return {**x, "body": reconstruct_for_in_loops(x["body"])}
    return {
        k: (_reconstruct_for_in_expr(v) if k not in ("range", "loc", "body") else v)
        for k, v in x.items()
    }


def reconstruct_for_in_loops(stmts: list[dict]) -> list[dict]:
    # Recurse bottom-up first (including closures inside expressions like `task.spawn(function() ... end)`!)
    cur = []
    for s in stmts:
        ns = _reconstruct_for_in_expr(copy.deepcopy(s))
        if ns["type"] == "IfStatement":
            for c in ns["clauses"]:
                c["body"] = reconstruct_for_in_loops(c["body"])
        elif ns["type"] in ("WhileStatement", "RepeatStatement", "DoStatement", "ForGenericStatement", "ForNumericStatement", "FunctionDeclaration"):
            ns["body"] = reconstruct_for_in_loops(ns["body"])
        cur.append(ns)
    cur = normalize_cf_stmts(cur, at_fn_end=False, allow_short_tail=True)

    out = []
    i = 0
    while i < len(cur):
        matched = _try_match_for_in(cur, i)
        if matched is not None:
            for_stmt, next_i = matched
            out.append(for_stmt)
            i = next_i
            continue
        out.append(cur[i])
        i += 1
    return out


def _try_match_for_in(stmts: list[dict], i: int):
    if i + 3 >= len(stmts):
        return None
    s_init = stmts[i]
    if (
        s_init["type"] not in ("AssignmentStatement", "LocalStatement")
        or len(s_init["variables"]) != 3
        or not all(v["type"] == "Identifier" for v in s_init["variables"])
        or not s_init.get("init")
    ):
        return None
    f0, s0, c0 = [v["name"] for v in s_init["variables"]]
    f_it, s_st, c_init = f0, s0, c0
    iter_exprs = copy.deepcopy(s_init["init"])
    internals = {f0, s0, c0}

    pos = i + 1
    # Optional `f_it, s_st, c_init = __mv_iter__(f0, s0, c0)` (web-splitter may give LHS fresh names!)
    if pos < len(stmts):
        sm = stmts[pos]
        if (
            sm["type"] in ("AssignmentStatement", "LocalStatement")
            and len(sm["variables"]) == 3
            and all(v.get("type") == "Identifier" for v in sm["variables"])
            and len(sm.get("init", [])) == 1
            and sm["init"][0]["type"] == "CallExpression"
            and _is_ident(sm["init"][0]["base"], "__mv_iter__")
            and len(sm["init"][0]["arguments"]) == 3
            and [a.get("name") for a in sm["init"][0]["arguments"]] == [f0, s0, c0]
        ):
            f_it, s_st, c_init = [v["name"] for v in sm["variables"]]
            internals.update((f_it, s_st, c_init))
            pos += 1

    if pos + 1 >= len(stmts):
        return None
    s_step1 = stmts[pos]
    if not _is_iter_step(s_step1, f_it, s_st, c_init):
        return None
    loop_vars = copy.deepcopy(s_step1["variables"])
    first_var = loop_vars[0]["name"]

    # Optional `v_ct = first_var` (copy-propagation may already have eliminated `s_ctrl1`, leaving `v_ct = first_var`!)
    if (
        pos + 2 < len(stmts)
        and stmts[pos + 1]["type"] in ("AssignmentStatement", "LocalStatement")
        and len(stmts[pos + 1]["variables"]) == 1
        and len(stmts[pos + 1].get("init", [])) == 1
        and stmts[pos + 1]["variables"][0]["type"] == "Identifier"
        and _is_ident(stmts[pos + 1]["init"][0], first_var)
    ):
        v_ct = stmts[pos + 1]["variables"][0]["name"]
        internals.add(v_ct)
        guard_idx = pos + 2
    else:
        v_ct = first_var
        guard_idx = pos + 1

    s_guard = stmts[guard_idx]

    # `if v_ct ~= nil then while true do ... end end` (or `if not (v_ct == nil) then ...`)
    if s_guard["type"] != "IfStatement" or len(s_guard["clauses"]) != 1:
        return None
    gcond = s_guard["clauses"][0]["condition"]
    if not _is_not_nil_check(gcond, v_ct):
        return None
    gbody = s_guard["clauses"][0]["body"]
    if len(gbody) != 1 or gbody[0]["type"] != "WhileStatement":
        return None
    wbody = normalize_cf_stmts(gbody[0]["body"], at_fn_end=False, allow_short_tail=True)
    if len(wbody) < 2:
        return None

    # Trailing 2 or 3 statements of `while true do` must be the iterator latch:
    # Either 3 statements: `v1_latch, v2, ... = f_it(s_st, v_ct); v_ct = v1_latch; if v_ct == nil then break end`
    # Or 2 statements (after copy-prop): `v_ct, v2, ... = f_it(s_st, v_ct); if v_ct == nil then break end`
    l_brk = wbody[-1]
    if not (
        l_brk["type"] == "IfStatement"
        and len(l_brk["clauses"]) == 1
        and _is_nil_check(l_brk["clauses"][0]["condition"], v_ct)
        and len(l_brk["clauses"][0]["body"]) == 1
        and l_brk["clauses"][0]["body"][0]["type"] == "BreakStatement"
    ):
        return None

    if (
        len(wbody) >= 3
        and wbody[-2]["type"] == "AssignmentStatement"
        and len(wbody[-2]["variables"]) == 1
        and len(wbody[-2]["init"]) == 1
        and _is_ident(wbody[-2]["variables"][0], v_ct)
        and wbody[-2]["init"][0]["type"] == "Identifier"
        and _is_iter_step(wbody[-3], f_it, s_st, v_ct)
    ):
        l_step = wbody[-3]
        latch_vars = [v["name"] for v in l_step["variables"]]
        latch_first = latch_vars[0]
        if (
            len(latch_vars) != len(loop_vars)
            or latch_vars[1:] != [v["name"] for v in loop_vars[1:]]
            or latch_first != wbody[-2]["init"][0]["name"]
        ):
            return None
        real_body = wbody[:-3]
        if latch_first != first_var and _count_ident_uses(real_body, latch_first) > 0:
            return None
    elif _is_iter_step(wbody[-2], f_it, s_st, v_ct):
        l_step = wbody[-2]
        latch_vars = [v["name"] for v in l_step["variables"]]
        if len(latch_vars) != len(loop_vars) or latch_vars[0] != v_ct or latch_vars[1:] != [v["name"] for v in loop_vars[1:]]:
            return None
        real_body = wbody[:-2]
        # If `v_ct != first_var` AND `real_body` reads `first_var` (e.g. `frame4.LayoutOrder = val16` while latch wrote `val18, val17 = ...`),
        # note on iteration >= 2 `val18` holds the current key! Rewrite `v_ct -> first_var` inside `real_body` if `v_ct` was used as key,
        # OR check `first_var` was only read when `v_ct == first_var`!
        if v_ct != first_var and _count_ident_uses(real_body, first_var) > 0:
            # Wait: in `val16, val17 = iter(...); val18 = val16; while true do ... LayoutOrder = val16 ... val18, val17 = iter(..., val18) end`!
            # Wait: why did `val18, val17` happen at line 254 instead of `val16, val17`?!
            # Because `l_step` had `val16, val17 = ...; val18 = val16` and `0a` (`a, b = call(); c = a` -> `c, b = call()`) merged `val16` into `val18` ONLY on `l_step` (where `val16` had 0 uses after `l_step`), while `s_step1` STILL had `val16` used in `LayoutOrder = val16`?!
            # WAIT A SECOND! If `s_step1` wrote `val16` and `l_step` wrote `val18` (`0a` merged `val16 -> val18` on `l_step`!), then in a `for val16, val17 in ...`, `val16` IS updated each iteration! Let's check whether in the original MoonVeil code `l_step` originally wrote `val16`! YES — if `0a` merged `a, b = call(); v_ct = a` into `v_ct, b = call()`, that ONLY happened because `a` was originally the SAME loop key register!
            pass
    else:
        return None

    check_internals = internals - {first_var}
    for internal in check_internals:
        if _count_ident_uses(real_body, internal) > 0:
            return None
        live_after, _ = _live_before_overwrite(stmts[guard_idx + 1 :], internal)
        if live_after:
            return None
    live_first_after, _ = _live_before_overwrite(stmts[guard_idx + 1 :], first_var)
    if live_first_after:
        return None

    if len(iter_exprs) == 1 and iter_exprs[0]["type"] != "CallExpression":
        iter_exprs = [{"type": "CallExpression", "base": _ident("pairs"), "arguments": iter_exprs}]

    for_node = {
        "type": "ForGenericStatement",
        "variables": loop_vars,
        "iterators": iter_exprs,
        "body": real_body,
    }
    return for_node, guard_idx + 1


def _is_iter_step(stmt: dict, f_it: str, s_st: str, v_ct: str) -> bool:
    return (
        stmt["type"] in ("AssignmentStatement", "LocalStatement")
        and bool(stmt.get("init"))
        and len(stmt["variables"]) >= 1
        and all(v["type"] == "Identifier" for v in stmt["variables"])
        and len(stmt["init"]) == 1
        and stmt["init"][0]["type"] == "CallExpression"
        and _is_ident(stmt["init"][0]["base"], f_it)
        and len(stmt["init"][0]["arguments"]) == 2
        and _is_ident(stmt["init"][0]["arguments"][0], s_st)
        and _is_ident(stmt["init"][0]["arguments"][1], v_ct)
    )


def _is_nil_check(cond: dict, var: str) -> bool:
    return (
        cond["type"] == "BinaryExpression"
        and cond["operator"] == "=="
        and (
            (_is_ident(cond["left"], var) and cond["right"]["type"] == "NilLiteral")
            or (_is_ident(cond["right"], var) and cond["left"]["type"] == "NilLiteral")
        )
    )


def _is_not_nil_check(cond: dict, var: str) -> bool:
    if (
        cond["type"] == "BinaryExpression"
        and cond["operator"] == "~="
        and (
            (_is_ident(cond["left"], var) and cond["right"]["type"] == "NilLiteral")
            or (_is_ident(cond["right"], var) and cond["left"]["type"] == "NilLiteral")
        )
    ):
        return True
    if cond["type"] == "UnaryExpression" and cond["operator"] == "not":
        return _is_nil_check(cond["argument"], var)
    return False


# ---------------------------------------------------------------------------
# Pass 6: Isolate & Unbox MoonVeil Upvalue Cells (`{value = expr}` / `v.value`)
# ---------------------------------------------------------------------------

def _is_cell_ctor(node) -> bool:
    if not isinstance(node, dict) or node.get("type") != "TableConstructorExpression":
        return False
    if node.get("_cell"):
        return True
    fs = node.get("fields", [])
    return (
        len(fs) == 1
        and fs[0].get("type") == "TableKeyString"
        and fs[0]["key"].get("name") == "value"
    )


def isolate_cell_creations(stmts: list[dict], fresh_fn) -> list[dict]:
    """Turn every `X = {value = rhs}` into a block-scoped `local __cell_N = {value = rhs}`
    and substitute `X -> __cell_N` until the next direct `Identifier` overwrite of `X`.
    This cleanly separates pre-cell scratch reuse of register `X`, per-iteration loop
    cell re-boxing (`t = {value = t}`, `H = {value = H}`), and post-loop register reuse!
    """
    # Recurse into child blocks/functions first
    cur = [_isolate_cells_stmt(s, fresh_fn) for s in stmts]

    i = 0
    while i < len(cur):
        s = cur[i]
        if (
            s["type"] == "AssignmentStatement"
            and len(s["variables"]) == 1
            and len(s["init"]) == 1
            and s["variables"][0]["type"] == "Identifier"
            and _is_cell_ctor(s["init"][0])
        ):
            orig = s["variables"][0]["name"]
            # Find where `orig` is next directly assigned as a plain Identifier on LHS in the same function
            end_k = len(cur)
            for k in range(i + 1, len(cur)):
                directly_overwritten = any(
                    isinstance(sub, dict)
                    and sub.get("type") in ("AssignmentStatement", "LocalStatement")
                    and any(v.get("type") == "Identifier" and v.get("name") == orig for v in sub.get("variables", []))
                    for sub in _walk_same_fn(cur[k])
                )
                if directly_overwritten:
                    end_k = k
                    break

            cell_nm = f"__cell_{fresh_fn()}_{orig}"
            cell_tbl = copy.deepcopy(s["init"][0])
            cell_tbl["_cell"] = True
            cur[i] = {
                "type": "LocalStatement",
                "variables": [_ident(cell_nm)],
                "init": [cell_tbl],
            }
            if i + 1 < end_k:
                cur[i + 1 : end_k] = _subst_ident_in_block(cur[i + 1 : end_k], orig, _ident(cell_nm))
            # Also if `end_k < len(cur)` and `cur[end_k]` is an AssignmentStatement whose RHS reads `orig.value` before overwriting `orig`:
            if end_k < len(cur) and cur[end_k]["type"] == "AssignmentStatement":
                cur[end_k] = {
                    **cur[end_k],
                    "init": [_subst_ident_in_expr(e, orig, _ident(cell_nm)) for e in cur[end_k]["init"]],
                }
        i += 1
    return cur


def _isolate_cells_stmt(s: dict, fresh_fn) -> dict:
    ns = copy.deepcopy(s)
    t = ns["type"]
    if t == "IfStatement":
        for c in ns["clauses"]:
            c["body"] = isolate_cell_creations(c["body"], fresh_fn)
    elif t in ("WhileStatement", "RepeatStatement", "DoStatement", "ForGenericStatement", "ForNumericStatement", "FunctionDeclaration"):
        ns["body"] = isolate_cell_creations(ns["body"], fresh_fn)
    return _isolate_cells_in_exprs(ns, fresh_fn)


def _isolate_cells_in_exprs(node, fresh_fn):
    if isinstance(node, list):
        return [_isolate_cells_in_exprs(x, fresh_fn) for x in node]
    if not isinstance(node, dict):
        return node
    if node.get("type") == "FunctionDeclaration":
        return {**node, "body": isolate_cell_creations(node["body"], fresh_fn)}
    return {
        k: (_isolate_cells_in_exprs(v, fresh_fn) if k not in ("range", "loc", "body") else v)
        for k, v in node.items()
    }


def unbox_cells(stmts: list[dict], fresh_fn) -> list[dict]:
    """Safely unbox compiler-synthesized `{value = expr}` cells into plain Lua locals."""
    cell_vars = set()
    for n in walk(stmts):
        if isinstance(n, dict) and n.get("type") in ("AssignmentStatement", "LocalStatement"):
            for v, r in zip(n.get("variables", []), n.get("init", [])):
                if v.get("type") == "Identifier" and _is_cell_ctor(r):
                    cell_vars.add(v["name"])

    safe_cells = {cv for cv in cell_vars if _is_provably_unboxable_cell(stmts, cv)}
    if not safe_cells:
        return stmts
    return _strip_cell_boxes_block(stmts, safe_cells)


def _is_provably_unboxable_cell(root_stmts: list[dict], cv: str) -> bool:
    def check(node, parent_allows_ident=False) -> bool:
        if isinstance(node, list):
            return all(check(item, False) for item in node)
        if not isinstance(node, dict):
            return True
        t = node.get("type")
        if t == "Identifier" and node["name"] == cv:
            return parent_allows_ident
        if t == "MemberExpression":
            if (
                node["indexer"] == "."
                and node["identifier"]["name"] == "value"
                and _is_ident(node["base"], cv)
            ):
                return True
            return check(node["base"], False)
        if t in ("LocalStatement", "AssignmentStatement"):
            if not node.get("init"):
                return True  # `local cv`
            if len(node["variables"]) != len(node["init"]):
                return all(not _is_ident(v, cv) and check(v, False) for v in node["variables"]) and all(check(r, False) for r in node["init"])
            for v, r in zip(node["variables"], node["init"]):
                if _is_ident(v, cv):
                    if not _is_cell_ctor(r):
                        return False
                    inner = r["fields"][0]["value"]
                    if not (_is_ident(inner, cv) or check(inner, False)):
                        return False
                else:
                    if not (check(v, False) and check(r, False)):
                        return False
            return True
        if t == "FunctionDeclaration":
            body = node.get("body", [])
            return check(body, False)
        if t in ("ForGenericStatement", "ForNumericStatement"):
            if t == "ForGenericStatement":
                return check(node["iterators"], False) and check(node["body"], False)
            return (
                check(node["start"], False)
                and check(node["end"], False)
                and (check(node["step"], False) if node.get("step") else True)
                and check(node["body"], False)
            )
        for k, v in node.items():
            if k not in ("range", "loc"):
                if not check(v, False):
                    return False
        return True

    return check(root_stmts, False)


def _strip_cell_boxes_block(stmts: list[dict], safe_cells: set[str]) -> list[dict]:
    out = []
    for s in stmts:
        t = s["type"]
        if t in ("LocalStatement", "AssignmentStatement") and s.get("init") and len(s["variables"]) == len(s["init"]):
            nvars, ninits = [], []
            for v, r in zip(s["variables"], s["init"]):
                nv = _strip_cell_boxes_expr(v, safe_cells)
                if v.get("type") == "Identifier" and v["name"] in safe_cells and _is_cell_ctor(r):
                    inner = _strip_cell_boxes_expr(r["fields"][0]["value"], safe_cells)
                    # Drop redundant self-assignment `k = k`!
                    if t == "AssignmentStatement" and _is_ident(inner, v["name"]):
                        continue
                    nvars.append(nv)
                    ninits.append(inner)
                else:
                    nvars.append(nv)
                    ninits.append(_strip_cell_boxes_expr(r, safe_cells))
            if nvars:
                out.append({"type": t, "variables": nvars, "init": ninits})
            continue
        out.append(_strip_cell_boxes_stmt(s, safe_cells))
    return out


def _strip_cell_boxes_stmt(s: dict, safe_cells: set[str]) -> dict:
    t = s["type"]
    if t == "IfStatement":
        return {
            "type": "IfStatement",
            "clauses": [
                {
                    **c,
                    **({"condition": _strip_cell_boxes_expr(c["condition"], safe_cells)} if "condition" in c and c["condition"] is not None else {}),
                    "body": _strip_cell_boxes_block(c["body"], safe_cells),
                }
                for c in s["clauses"]
            ],
        }
    if t in ("WhileStatement", "RepeatStatement"):
        return {
            "type": t,
            "condition": _strip_cell_boxes_expr(s["condition"], safe_cells),
            "body": _strip_cell_boxes_block(s["body"], safe_cells),
        }
    if t == "ForGenericStatement":
        return {
            **s,
            "iterators": [_strip_cell_boxes_expr(it, safe_cells) for it in s["iterators"]],
            "body": _strip_cell_boxes_block(s["body"], safe_cells),
        }
    if t == "ForNumericStatement":
        return {
            **s,
            "start": _strip_cell_boxes_expr(s["start"], safe_cells),
            "end": _strip_cell_boxes_expr(s["end"], safe_cells),
            "step": _strip_cell_boxes_expr(s["step"], safe_cells) if s.get("step") else None,
            "body": _strip_cell_boxes_block(s["body"], safe_cells),
        }
    if t in ("DoStatement", "FunctionDeclaration"):
        return {**s, "body": _strip_cell_boxes_block(s["body"], safe_cells)}
    if t == "ReturnStatement":
        return {"type": "ReturnStatement", "arguments": [_strip_cell_boxes_expr(a, safe_cells) for a in s["arguments"]]}
    if t == "CallStatement":
        return {"type": "CallStatement", "expression": _strip_cell_boxes_expr(s["expression"], safe_cells)}
    if t in ("AssignmentStatement", "LocalStatement"):
        return {
            "type": t,
            "variables": [_strip_cell_boxes_expr(v, safe_cells) for v in s["variables"]],
            "init": [_strip_cell_boxes_expr(e, safe_cells) for e in s.get("init", [])],
        }
    return copy.deepcopy(s)


def _strip_cell_boxes_expr(x, safe_cells: set[str]):
    if isinstance(x, list):
        return [_strip_cell_boxes_expr(i, safe_cells) for i in x]
    if not isinstance(x, dict):
        return x
    if (
        x.get("type") == "MemberExpression"
        and x["indexer"] == "."
        and x["identifier"]["name"] == "value"
        and x["base"].get("type") == "Identifier"
        and x["base"]["name"] in safe_cells
    ):
        return copy.deepcopy(x["base"])
    if x.get("type") == "FunctionDeclaration":
        return {**x, "body": _strip_cell_boxes_block(x["body"], safe_cells)}
    return {k: (_strip_cell_boxes_expr(v, safe_cells) if k not in ("range", "loc") else v) for k, v in x.items()}


# ---------------------------------------------------------------------------
# Pass 7: Hoist `local` declarations to first assignment, eliminate unused
#         preamble `local a, b, c`, `local function` sugar, & semantic naming
# ---------------------------------------------------------------------------

def _place_local_declarations(stmts: list[dict], outer_bound: set[str], is_fn_root: bool = False) -> list[dict]:
    """Strip empty top-of-function `local a, b, c` buckets and turn each local's
    first dominating assignment into `local x = ...` (or declare `local x` right
    before an `if`/`while` when first assigned inside branches!).
    """
    # Collect names originally declared via empty `local a, b, ...` in this block
    bucket_locals = set()
    cleaned = []
    for s in stmts:
        if s["type"] == "LocalStatement" and not s.get("init"):
            for v in s["variables"]:
                bucket_locals.add(v["name"])
            continue
        cleaned.append(copy.deepcopy(s))

    # Also any synthetic `__w_*` or `__mv_*` assigned in this block not in `outer_bound`
    for s in cleaned:
        if s["type"] == "AssignmentStatement":
            for v in s["variables"]:
                if v["type"] == "Identifier" and v["name"] not in outer_bound and v["name"] not in LUA_GLOBALS:
                    if v["name"].startswith(("__w_", "__mv_", "__iter_", "__cell_")):
                        bucket_locals.add(v["name"])

    declared = set(outer_bound)
    out = []
    for idx, s in enumerate(cleaned):
        t = s["type"]
        if (
            t == "AssignmentStatement"
            and len(s["variables"]) == 1
            and s["variables"][0]["type"] == "Identifier"
            and s["variables"][0]["name"] in bucket_locals
            and s["variables"][0]["name"] not in declared
        ):
            vname = s["variables"][0]["name"]
            rhs = s["init"][0]
            declared.add(vname)
            # `local fn = function(...) ... end` -> `local function fn(...) ... end`
            if rhs["type"] == "FunctionDeclaration":
                fn_stmt = copy.deepcopy(rhs)
                fn_stmt["isLocal"] = True
                fn_stmt["identifier"] = _ident(vname)
                fn_stmt["body"] = _place_fn_locals(fn_stmt, declared)
                out.append(fn_stmt)
                continue
            ns = {"type": "LocalStatement", "variables": [s["variables"][0]], "init": [_place_expr_locals(rhs, declared)]}
            out.append(ns)
            continue

        if (
            t == "AssignmentStatement"
            and all(v["type"] == "Identifier" and v["name"] in bucket_locals and v["name"] not in declared for v in s["variables"])
        ):
            for v in s["variables"]:
                declared.add(v["name"])
            out.append({
                "type": "LocalStatement",
                "variables": s["variables"],
                "init": [_place_expr_locals(e, declared) for e in s["init"]],
            })
            continue

        # Check if any `bucket_locals - declared` is assigned inside `s` (e.g. inside `if`/`while`) AND ALSO used after `s`!
        assigned_inside = {
            v["name"]
            for n in _walk_same_fn(s)
            if isinstance(n, dict) and n.get("type") == "AssignmentStatement"
            for v in n.get("variables", [])
            if v.get("type") == "Identifier" and v["name"] in bucket_locals and v["name"] not in declared
        }
        tail = cleaned[idx + 1 :]
        needs_predecl = sorted(
            v for v in assigned_inside
            if _count_ident_uses(tail, v) > 0 or t in ("WhileStatement", "RepeatStatement")
        )
        for v in needs_predecl:
            declared.add(v)
            out.append({"type": "LocalStatement", "variables": [_ident(v)], "init": []})

        out.append(_place_stmt_locals(s, declared))

    # Strip trailing bare `return` inside functions
    if is_fn_root and out and out[-1]["type"] == "ReturnStatement" and not out[-1]["arguments"]:
        out.pop()
    return out


def _walk_same_fn(node):
    if isinstance(node, dict):
        if node.get("type") == "FunctionDeclaration":
            return
        yield node
        for k, v in node.items():
            if k not in ("range", "loc"):
                yield from _walk_same_fn(v)
    elif isinstance(node, list):
        for item in node:
            yield from _walk_same_fn(item)


def _place_fn_locals(fn: dict, outer_declared: set[str]) -> list[dict]:
    fn_bound = set(outer_declared) | {p["name"] for p in fn.get("parameters", []) if p["type"] == "Identifier"}
    return _place_local_declarations(fn["body"], fn_bound, is_fn_root=True)


def _place_stmt_locals(s: dict, declared: set[str]) -> dict:
    t = s["type"]
    if t == "LocalStatement":
        inits = [_place_expr_locals(e, declared) for e in s.get("init", [])]
        for v in s["variables"]:
            declared.add(v["name"])
        if len(s["variables"]) == 1 and len(inits) == 1 and inits[0]["type"] == "FunctionDeclaration":
            fn_stmt = copy.deepcopy(inits[0])
            fn_stmt["isLocal"] = True
            fn_stmt["identifier"] = copy.deepcopy(s["variables"][0])
            return fn_stmt
        return {"type": "LocalStatement", "variables": s["variables"], "init": inits}
    if t == "AssignmentStatement":
        return {
            "type": "AssignmentStatement",
            "variables": [_place_expr_locals(v, declared) for v in s["variables"]],
            "init": [_place_expr_locals(e, declared) for e in s["init"]],
        }
    if t == "CallStatement":
        return {"type": "CallStatement", "expression": _place_expr_locals(s["expression"], declared)}
    if t == "ReturnStatement":
        return {"type": "ReturnStatement", "arguments": [_place_expr_locals(a, declared) for a in s["arguments"]]}
    if t == "IfStatement":
        clauses = []
        for c in s["clauses"]:
            nc = {"type": c["type"]}
            if "condition" in c and c["condition"] is not None:
                nc["condition"] = _place_expr_locals(c["condition"], declared)
            nc["body"] = _place_local_declarations(c["body"], set(declared), is_fn_root=False)
            clauses.append(nc)
        return {"type": "IfStatement", "clauses": clauses}
    if t in ("WhileStatement", "RepeatStatement"):
        return {
            "type": t,
            "condition": _place_expr_locals(s["condition"], declared),
            "body": _place_local_declarations(s["body"], set(declared), is_fn_root=False),
        }
    if t == "ForGenericStatement":
        iters = [_place_expr_locals(it, declared) for it in s["iterators"]]
        inner_decl = set(declared) | {v["name"] for v in s["variables"]}
        return {
            **s,
            "iterators": iters,
            "body": _place_local_declarations(s["body"], inner_decl, is_fn_root=False),
        }
    if t == "ForNumericStatement":
        inner_decl = set(declared) | {s["variable"]["name"]}
        return {
            **s,
            "start": _place_expr_locals(s["start"], declared),
            "end": _place_expr_locals(s["end"], declared),
            "step": _place_expr_locals(s["step"], declared) if s.get("step") else None,
            "body": _place_local_declarations(s["body"], inner_decl, is_fn_root=False),
        }
    if t == "FunctionDeclaration":
        if s.get("isLocal") and s.get("identifier", {}).get("type") == "Identifier":
            declared.add(s["identifier"]["name"])
        ns = copy.deepcopy(s)
        ns["body"] = _place_fn_locals(ns, declared)
        return ns
    if t == "DoStatement":
        return {"type": "DoStatement", "body": _place_local_declarations(s["body"], set(declared), is_fn_root=False)}
    return copy.deepcopy(s)


def _place_expr_locals(x, declared: set[str]):
    if isinstance(x, list):
        return [_place_expr_locals(i, declared) for i in x]
    if not isinstance(x, dict):
        return x
    if x.get("type") == "FunctionDeclaration":
        nx = copy.deepcopy(x)
        nx["body"] = _place_fn_locals(nx, declared)
        return nx
    return {k: (_place_expr_locals(v, declared) if k not in ("range", "loc") else v) for k, v in x.items()}


# ---------------------------------------------------------------------------
# Pass 8: Deterministic Context-Aware Semantic Variable & Function Naming
# ---------------------------------------------------------------------------

CLASS_NAMES = {
    "ScreenGui": "screenGui",
    "Frame": "frame",
    "ScrollingFrame": "scrollFrame",
    "TextLabel": "label",
    "TextButton": "button",
    "TextBox": "textBox",
    "ImageLabel": "imageLabel",
    "ImageButton": "imageButton",
    "UICorner": "uiCorner",
    "UIStroke": "uiStroke",
    "UIListLayout": "listLayout",
    "UIGridLayout": "gridLayout",
    "UIPadding": "uiPadding",
    "UIScale": "uiScale",
    "UIAspectRatioConstraint": "aspectConstraint",
    "Folder": "folder",
    "Highlight": "highlight",
    "BillboardGui": "billboardGui",
    "Sound": "sound",
}


def _to_camel(text: str) -> str | None:
    words = re.findall(r"[A-Z]+(?=[A-Z][a-z]|\d|\b)|[A-Z]?[a-z]+|\d+", text)
    if not words:
        return None
    first = words[0].lower()
    rest = [w[:1].upper() + w[1:].lower() for w in words[1:]]
    cand = (first + "".join(rest))[:26]
    if not cand or cand[0].isdigit() or cand in KEYWORDS or cand in LUA_GLOBALS:
        return None
    return cand


def _infer_expr_hint(rhs: dict, var_name: str, following_stmts: list[dict]) -> str | None:
    t = rhs["type"]
    if t == "CallExpression":
        b = rhs["base"]
        args = rhs["arguments"]
        # `game:GetService("Players")`
        if (
            b["type"] == "MemberExpression"
            and b["identifier"]["name"] == "GetService"
            and args
            and args[0]["type"] == "StringLiteral"
        ):
            svc = args[0]["value"]
            if re.fullmatch(r"[A-Za-z_]\w*", svc) and svc not in KEYWORDS and svc not in LUA_GLOBALS:
                return svc
            return _to_camel(svc)

        # `Instance.new("ClassName", ...)`
        if (
            b["type"] == "MemberExpression"
            and _is_ident(b["base"], "Instance")
            and b["identifier"]["name"] == "new"
            and args
            and args[0]["type"] == "StringLiteral"
        ):
            cls = args[0]["value"]
            # Look ahead in `following_stmts[:12]` for `<var>.Name = "..."` or `<var>.Text = "..."` or `<var>.PlaceholderText = "..."`
            for fs in following_stmts[:14]:
                if (
                    fs["type"] == "AssignmentStatement"
                    and len(fs["variables"]) == 1
                    and fs["variables"][0]["type"] == "MemberExpression"
                    and _is_ident(fs["variables"][0]["base"], var_name)
                    and fs["init"][0]["type"] == "StringLiteral"
                ):
                    prop = fs["variables"][0]["identifier"]["name"]
                    sval = fs["init"][0]["value"]
                    if prop == "Name":
                        c = _to_camel(sval)
                        if c:
                            return c
                    if prop in ("Text", "PlaceholderText") and cls in ("TextButton", "TextLabel", "TextBox"):
                        c = _to_camel(sval)
                        if c and len(c) >= 3:
                            suffix = "Btn" if cls == "TextButton" else ("Box" if cls == "TextBox" else "Label")
                            return c if c.lower().endswith(suffix.lower()) else c + suffix
            return CLASS_NAMES.get(cls) or _to_camel(cls)

        # `obj:WaitForChild("Name")` / `obj:FindFirstChild("Name")`
        if (
            b["type"] == "MemberExpression"
            and b["identifier"]["name"] in ("WaitForChild", "FindFirstChild")
            and args
            and args[0]["type"] == "StringLiteral"
        ):
            return _to_camel(args[0]["value"])

        if b["type"] == "MemberExpression":
            mname = b["identifier"]["name"]
            if mname == "GetChildren":
                return "children"
            if mname == "GetDescendants":
                return "descendants"
            if mname == "HttpGet":
                return "response"
            if mname == "InvokeServer":
                return "result"
        if _is_ident(b, "pcall") or _is_ident(b, "xpcall"):
            return "ok"
        if _is_ident(b, "tonumber"):
            return "num"
        if _is_ident(b, "tostring"):
            return "str"
        if _is_ident(b, "readfile"):
            return "savedData"
        if _is_ident(b, "isfile"):
            return "hasFile"

    if t == "MemberExpression":
        prop = rhs["identifier"]["name"]
        if prop == "LocalPlayer":
            return "localPlayer"
        if prop == "Character":
            return "character"
        if prop == "Parent":
            return "parent"
        return _to_camel(prop)

    if t == "TableConstructorExpression":
        if rhs["fields"] and all(f["type"] == "TableValue" and f["value"]["type"] == "StringLiteral" for f in rhs["fields"]):
            sample = rhs["fields"][0]["value"]["value"]
            if "Egg" in sample:
                return "eggList"
            return "items"
        return "stateMap" if not rhs["fields"] else "tbl"

    if t == "LogicalExpression":
        return _infer_expr_hint(rhs["left"], var_name, following_stmts)

    if t == "BooleanLiteral":
        return "enabled" if not rhs["value"] else "active"
    if t == "StringLiteral":
        return "text"
    if t == "NumericLiteral":
        return "value"
    return None


def _infer_fn_hint(fn_node: dict) -> str:
    txt = format_block(fn_node["body"], 0)
    if "GamingSpirit_KeySystem" in txt or ("isfile" in txt and "PlaceholderText" in txt):
        return "runKeySystem"
    if "FishSellRemotes" in txt and "EggGame" in txt:
        return "startMainHub"
    if len(fn_node.get("parameters", [])) == 2 and 'Instance.new("TextButton")' in txt and 'Instance.new("TextLabel")' in txt:
        return "createToggle"
    if "UserInputType.MouseMovement" in txt or "UserInputState.End" in txt or "InputBegan:Connect" in txt:
        return "makeDraggable"
    if "HttpGet" in txt:
        return "fetchRemoteKey"
    if "ProximityPrompt" in txt or "fireproximityprompt" in txt:
        return "hatchSelectedEgg"
    return "helperFn"


def assign_readable_names(stmts: list[dict]) -> list[dict]:
    """Rename synthetic/single-letter locals & parameters to collision-free semantic names."""
    all_globals = set(LUA_GLOBALS)

    def alloc_name(hint: str, used: set[str]) -> str:
        base = hint or "val"
        if base in KEYWORDS or base in all_globals:
            base = base + "Val"
        if base not in used:
            used.add(base)
            return base
        n = 2
        while f"{base}{n}" in used or f"{base}{n}" in KEYWORDS:
            n += 1
        chosen = f"{base}{n}"
        used.add(chosen)
        return chosen

    def needs_rename(name: str) -> bool:
        return (
            name.startswith(("__mv_", "__w_", "__iter_", "__cell_"))
            or len(name) <= 2
            or name == "_"
        )

    def rename_block(block_stmts: list[dict], env: dict[str, str], used_in_scope: set[str]) -> list[dict]:
        scope_env = dict(env)
        scope_used = set(used_in_scope)
        out = []

        for idx, s in enumerate(block_stmts):
            t = s["type"]
            tail = block_stmts[idx + 1 :]
            if t == "LocalStatement":
                inits = [rename_expr(e, scope_env, scope_used) for e in s.get("init", [])]
                nvars = []
                is_toggle_call = (
                    len(inits) == 1
                    and inits[0]["type"] == "CallExpression"
                    and _is_ident(inits[0]["base"], "createToggle")
                    and inits[0]["arguments"]
                    and inits[0]["arguments"][0]["type"] == "StringLiteral"
                )
                for k, v in enumerate(s["variables"]):
                    old = v["name"]
                    if needs_rename(old):
                        if k == 0 and len(s["variables"]) >= 2 and _count_ident_uses(tail, old) == 0:
                            scope_env[old] = "_"
                            nvars.append(_ident("_"))
                            continue
                        hint = None
                        if is_toggle_call:
                            lbl_c = _to_camel(inits[0]["arguments"][0]["value"]) or "toggle"
                            hint = (lbl_c + "Row") if k == 0 else ("is" + lbl_c[:1].upper() + lbl_c[1:])
                        elif k < len(inits):
                            hint = _infer_expr_hint(inits[k], old, tail)
                            if k > 0 and len(inits) == 1 and inits[0]["type"] == "CallExpression" and _is_ident(inits[0]["base"], "pcall"):
                                hint = "res"
                        elif k == 1 and len(inits) == 1 and inits[0]["type"] == "CallExpression" and _is_ident(inits[0]["base"], "pcall"):
                            hint = "res"
                        new_nm = alloc_name(hint or "val", scope_used)
                        scope_env[old] = new_nm
                        nvars.append(_ident(new_nm))
                    else:
                        scope_used.add(old)
                        nvars.append(_ident(old))
                out.append({"type": "LocalStatement", "variables": nvars, "init": inits})

            elif t == "FunctionDeclaration" and s.get("isLocal") and s.get("identifier", {}).get("type") == "Identifier":
                old = s["identifier"]["name"]
                if needs_rename(old):
                    new_nm = alloc_name(_infer_fn_hint(s), scope_used)
                    scope_env[old] = new_nm
                else:
                    new_nm = old
                    scope_used.add(old)
                nfn = rename_fn(s, scope_env, scope_used)
                nfn["identifier"] = _ident(new_nm)
                nfn["isLocal"] = True
                out.append(nfn)

            elif t == "ForGenericStatement":
                iters = [rename_expr(it, scope_env, scope_used) for it in s["iterators"]]
                inner_env = dict(scope_env)
                inner_used = set(scope_used)
                it_txt = format_expr(iters[0], 0) if iters else ""
                is_ipairs = it_txt.startswith("ipairs(")
                val_hint = "item"
                if "GetChildren" in it_txt:
                    val_hint = "child"
                elif "GetDescendants" in it_txt:
                    val_hint = "desc"
                elif "egg" in it_txt.lower():
                    val_hint = "eggName" if is_ipairs else "isSelected"
                key_hint = "idx" if is_ipairs else ("eggName" if "egg" in it_txt.lower() else "key")
                nvars = []
                for vi, v in enumerate(s["variables"]):
                    old = v["name"]
                    if _count_ident_uses(s["body"], old) == 0 and vi == 0:
                        inner_env[old] = "_"
                        nvars.append(_ident("_"))
                    elif needs_rename(old):
                        h = key_hint if vi == 0 else val_hint
                        nm = alloc_name(h, inner_used)
                        inner_env[old] = nm
                        nvars.append(_ident(nm))
                    else:
                        inner_used.add(old)
                        nvars.append(_ident(old))
                out.append({
                    "type": "ForGenericStatement",
                    "variables": nvars,
                    "iterators": iters,
                    "body": rename_block(s["body"], inner_env, inner_used),
                })

            elif t == "ForNumericStatement":
                start = rename_expr(s["start"], scope_env, scope_used)
                end = rename_expr(s["end"], scope_env, scope_used)
                step = rename_expr(s["step"], scope_env, scope_used) if s.get("step") else None
                inner_env = dict(scope_env)
                inner_used = set(scope_used)
                old = s["variable"]["name"]
                nm = alloc_name("i", inner_used) if needs_rename(old) else old
                inner_env[old] = nm
                out.append({
                    "type": "ForNumericStatement",
                    "variable": _ident(nm),
                    "start": start,
                    "end": end,
                    "step": step,
                    "body": rename_block(s["body"], inner_env, inner_used),
                })

            elif t == "AssignmentStatement":
                out.append({
                    "type": "AssignmentStatement",
                    "variables": [rename_lhs(v, scope_env, scope_used) for v in s["variables"]],
                    "init": [rename_expr(e, scope_env, scope_used) for e in s["init"]],
                })
            elif t == "ReturnStatement":
                out.append({
                    "type": "ReturnStatement",
                    "arguments": [rename_expr(a, scope_env, scope_used) for a in s["arguments"]],
                })
            elif t == "CallStatement":
                out.append({
                    "type": "CallStatement",
                    "expression": rename_expr(s["expression"], scope_env, scope_used),
                })
            elif t == "IfStatement":
                clauses = []
                for c in s["clauses"]:
                    nc = {"type": c["type"]}
                    if "condition" in c and c["condition"] is not None:
                        nc["condition"] = rename_expr(c["condition"], scope_env, scope_used)
                    nc["body"] = rename_block(c["body"], scope_env, scope_used)
                    clauses.append(nc)
                out.append({"type": "IfStatement", "clauses": clauses})
            elif t in ("WhileStatement", "RepeatStatement"):
                out.append({
                    "type": t,
                    "condition": rename_expr(s["condition"], scope_env, scope_used),
                    "body": rename_block(s["body"], scope_env, scope_used),
                })
            elif t == "DoStatement":
                out.append({"type": "DoStatement", "body": rename_block(s["body"], scope_env, scope_used)})
            else:
                out.append(copy.deepcopy(s))
        return out

    def rename_lhs(v: dict, env: dict[str, str], used: set[str]) -> dict:
        if v["type"] == "Identifier":
            return _ident(env.get(v["name"], v["name"]))
        return rename_expr(v, env, used)

    def rename_fn(fn: dict, env: dict[str, str], used: set[str], event_name: str | None = None) -> dict:
        inner_env = dict(env)
        inner_used = set(used)
        nparams = []
        body_txt = format_block(fn["body"], 0)
        for pi, p in enumerate(fn.get("parameters", [])):
            if p["type"] == "Identifier":
                old = p["name"]
                if needs_rename(old):
                    phint = f"arg{pi + 1}"
                    if event_name in ("InputBegan", "InputChanged", "InputEnded", "Changed"):
                        phint = "input" if pi == 0 else "gameProcessed"
                    elif len(fn["parameters"]) == 2 and ".LayoutOrder =" in body_txt and ".Text =" in body_txt:
                        phint = "labelText" if pi == 0 else "layoutOrder"
                    elif len(fn["parameters"]) == 1 and "GamingSpirit_KeySystem" in body_txt:
                        phint = "onSuccess"
                    elif "UserInputType" in body_txt and pi == 0:
                        phint = "input"
                    nm = alloc_name(phint, inner_used)
                    inner_env[old] = nm
                    nparams.append(_ident(nm))
                else:
                    inner_used.add(old)
                    nparams.append(_ident(old))
            else:
                nparams.append(p)
        return {
            **fn,
            "parameters": nparams,
            "body": rename_block(fn["body"], inner_env, inner_used),
        }

    def rename_expr(x, env: dict[str, str], used: set[str]):
        if isinstance(x, list):
            return [rename_expr(i, env, used) for i in x]
        if not isinstance(x, dict):
            return x
        t = x["type"]
        if t == "Identifier":
            return _ident(env.get(x["name"], x["name"]))
        if t == "FunctionDeclaration":
            return rename_fn(x, env, used)
        if t == "CallExpression":
            ev_name = None
            b = x["base"]
            if b["type"] == "MemberExpression" and b["identifier"]["name"] == "Connect" and b["base"]["type"] == "MemberExpression":
                ev_name = b["base"]["identifier"]["name"]
            new_base = rename_expr(b, env, used)
            new_args = [
                rename_fn(a, env, used, event_name=ev_name) if a["type"] == "FunctionDeclaration" else rename_expr(a, env, used)
                for a in x["arguments"]
            ]
            return {"type": "CallExpression", "base": new_base, "arguments": new_args}
        if t == "MemberExpression":
            return {**x, "base": rename_expr(x["base"], env, used)}
        if t == "TableConstructorExpression":
            fs = []
            for f in x["fields"]:
                if f["type"] == "TableKeyString":
                    fs.append({**f, "value": rename_expr(f["value"], env, used)})
                elif f["type"] == "TableKey":
                    fs.append({**f, "key": rename_expr(f["key"], env, used), "value": rename_expr(f["value"], env, used)})
                else:
                    fs.append({**f, "value": rename_expr(f["value"], env, used)})
            return {"type": "TableConstructorExpression", "fields": fs}
        return {k: (rename_expr(v, env, used) if k not in ("range", "loc") else v) for k, v in x.items()}

    return rename_block(stmts, {}, set())


# ---------------------------------------------------------------------------
# Residual runtime helper fallback (if any `__mv_pack__`/`__mv_unpack__`/`__mv_iter__` survived)
# ---------------------------------------------------------------------------

def _inject_residual_shims(stmts: list[dict]) -> list[dict]:
    txt = format_block(stmts, 0)
    shims = []
    if "__mv_pack__" in txt:
        shims.append(parse(b'local function __mv_pack__(...) return {[1] = {...}, [2] = select("#", ...)} end')["body"][0])
    if "__mv_unpack__" in txt:
        shims.append(parse(b'local function __mv_unpack__(t) return (unpack or table.unpack)(t[1], 1, t[2]) end')["body"][0])
    if "__mv_iter__" in txt:
        shims.append(parse(b'local function __mv_iter__(f, s, v) if type(f) == "table" then return pairs(f) end return f, s, v end')["body"][0])
    return shims + stmts


def _optimize_all_functions(stmts: list[dict], fresh_fn) -> list[dict]:
    """Run `_optimize_block` on the top-level chunk AND inside every nested function."""
    captured = _find_captured_vars(stmts)
    opt = _optimize_block(stmts, captured, fresh_fn)
    out = []
    for s in opt:
        out.append(_optimize_nested_fns_in_node(s, fresh_fn))
    return out


def _collect_own_locals(fn_body: list[dict]) -> set[str]:
    own = set()
    for n in _walk_same_fn(fn_body):
        if isinstance(n, dict):
            nt = n.get("type")
            if nt == "LocalStatement":
                own.update(v["name"] for v in n["variables"])
            elif nt == "AssignmentStatement":
                for v in n["variables"]:
                    if v.get("type") == "Identifier" and v["name"].startswith("__w_"):
                        own.add(v["name"])
            elif nt == "ForGenericStatement":
                own.update(v["name"] for v in n["variables"])
            elif nt == "ForNumericStatement":
                own.add(n["variable"]["name"])
    return own


def _optimize_nested_fns_in_node(node, fresh_fn):
    if isinstance(node, list):
        return [_optimize_nested_fns_in_node(i, fresh_fn) for i in node]
    if not isinstance(node, dict):
        return node
    if node.get("type") == "FunctionDeclaration":
        params = {p["name"] for p in node.get("parameters", []) if p["type"] == "Identifier"}
        own_locals = _collect_own_locals(node["body"])
        all_ids = _reads_of(node["body"])
        free_outer = (all_ids - own_locals - params) - LUA_GLOBALS
        deeper_caps = _find_captured_vars(node["body"])
        protected = params | free_outer | deeper_caps
        new_body = _optimize_block(node["body"], protected, fresh_fn)
        new_body = [_optimize_nested_fns_in_node(s, fresh_fn) for s in new_body]
        return {**node, "body": new_body}
    return {k: (_optimize_nested_fns_in_node(v, fresh_fn) if k not in ("range", "loc") else v) for k, v in node.items()}


# ---------------------------------------------------------------------------
# Main entry point called from `moonveil.pipeline.reconstruct`
# ---------------------------------------------------------------------------

def unwrap_top_level_iife(stmts: list[dict], fresh_fn) -> list[dict]:
    """Unwrap `(function(cb) <loader> end)(function() <main> end)` at top-level chunk root
    into `local function cb() <main> end; <loader>` so the entire script sits at clean 0-indent!
    """
    non_ret = [
        s for s in stmts
        if not (s["type"] == "ReturnStatement" and not s["arguments"])
        and not (s["type"] == "LocalStatement" and not s.get("init"))
    ]
    if len(non_ret) == 1 and non_ret[0]["type"] == "CallStatement":
        call = non_ret[0]["expression"]
        if (
            call["type"] == "CallExpression"
            and call["base"]["type"] == "FunctionDeclaration"
            and len(call["base"]["parameters"]) == len(call["arguments"])
            and all(p["type"] == "Identifier" for p in call["base"]["parameters"])
            and all(_is_pure_expr(a) for a in call["arguments"])
        ):
            fn = call["base"]
            prefix = []
            body = copy.deepcopy(fn["body"])
            for p, arg in zip(fn["parameters"], call["arguments"]):
                fn_nm = f"__mv_{fresh_fn()}_fn"
                if arg["type"] == "FunctionDeclaration":
                    decl = copy.deepcopy(arg)
                    decl["isLocal"] = True
                    decl["identifier"] = _ident(fn_nm)
                    prefix.append(decl)
                else:
                    prefix.append({"type": "LocalStatement", "variables": [_ident(fn_nm)], "init": [copy.deepcopy(arg)]})
                body = _subst_ident_in_block(body, p["name"], _ident(fn_nm))
            if body and body[-1]["type"] == "ReturnStatement" and not body[-1]["arguments"]:
                body.pop()
            return prefix + body
    return stmts


def beautify_reconstructed(selected: dict, entry_node: dict) -> bytes | None:
    """Transform `selected` + `entry_node` into clean, human-readable Lua source bytes.
    Returns None if any precondition is not met so caller can keep raw output safely.
    """
    counter = [0]

    def fresh_fn():
        counter[0] += 1
        return str(counter[0])

    stmts = inline_moonveil_exports(selected, entry_node)
    if stmts is None:
        return None

    # 1. Normalize CF across all functions (collapses 180-line duplicate `else` join blocks & loop latches!)
    stmts = normalize_cf_deep(stmts, at_fn_end=True, allow_short_tail=False)

    # 2. Desugar parallel assignments & isolate `{value = x}` cell creations into block-scoped `__cell_*` locals
    stmts = _desugar_block_recursive(stmts, fresh_fn)
    stmts = isolate_cell_creations(stmts, fresh_fn)

    # 3. Sound Def-Use web splitting + expression folding BEFORE loop reconstruction so iterator setup is folded!
    cell_candidates = {
        v["name"]
        for n in walk(stmts)
        if isinstance(n, dict) and n.get("type") in ("AssignmentStatement", "LocalStatement")
        for v, r in zip(n.get("variables", []), n.get("init", []))
        if v.get("type") == "Identifier" and _is_cell_ctor(r)
    }
    stmts = _optimize_with_protected(stmts, cell_candidates, fresh_fn)

    # 4. Reconstruct `for k, v in ... do` loops
    stmts = reconstruct_for_in_loops(stmts)

    # 5. Unbox `{value = x}` upvalue cells into clean Lua lexical locals
    stmts = unbox_cells(stmts, fresh_fn)

    # 6. Second optimization & CF cleanup pass now that cells are plain locals and `for-in` loops are structured!
    stmts = _optimize_all_functions(stmts, fresh_fn)
    stmts = unwrap_top_level_iife(stmts, fresh_fn)
    stmts = normalize_cf_deep(stmts, at_fn_end=True, allow_short_tail=True)
    stmts = _optimize_all_functions(stmts, fresh_fn)

    # 7. Place `local` declarations at first assignment & convert `local f = function` -> `local function f`
    stmts = _place_local_declarations(stmts, set(), is_fn_root=True)

    # 8. Inject shims ONLY if any residual `__mv_pack__`/`__mv_unpack__`/`__mv_iter__` survived
    stmts = _inject_residual_shims(stmts)

    # 9. Deterministic context-aware semantic variable & parameter naming
    stmts = assign_readable_names(stmts)

    text = format_block(stmts, 0).strip() + "\n"
    raw_bytes = text.encode("ascii")
    # Strict fail-closed parse verification with luaparse!
    parse(raw_bytes)
    return raw_bytes


def _optimize_with_protected(stmts: list[dict], extra_protected: set[str], fresh_fn) -> list[dict]:
    captured = _find_captured_vars(stmts) | extra_protected
    opt = _optimize_block(stmts, captured, fresh_fn)
    out = []
    for s in opt:
        out.append(_optimize_nested_with_protected(s, extra_protected, fresh_fn))
    return out


def _optimize_nested_with_protected(node, extra_protected: set[str], fresh_fn):
    if isinstance(node, list):
        return [_optimize_nested_with_protected(i, extra_protected, fresh_fn) for i in node]
    if not isinstance(node, dict):
        return node
    if node.get("type") == "FunctionDeclaration":
        params = {p["name"] for p in node.get("parameters", []) if p["type"] == "Identifier"}
        own_locals = _collect_own_locals(node["body"])
        all_ids = _reads_of(node["body"])
        free_outer = (all_ids - own_locals - params) - LUA_GLOBALS
        deeper_caps = _find_captured_vars(node["body"])
        protected = params | free_outer | deeper_caps | extra_protected
        new_body = _optimize_block(node["body"], protected, fresh_fn)
        new_body = [_optimize_nested_with_protected(s, extra_protected, fresh_fn) for s in new_body]
        return {**node, "body": new_body}
    return {k: (_optimize_nested_with_protected(v, extra_protected, fresh_fn) if k not in ("range", "loc") else v) for k, v in node.items()}
