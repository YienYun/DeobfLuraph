"""Luraph v15 static VM dispatcher/constructor model and LPH_NO_VIRTUALIZE plain-Luau printer."""
from collections import deque
import gzip
import hashlib
import hmac
import json
import math
import os
import re
import struct
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
if ROOT not in sys.path:
    sys.path.insert(0, ROOT)

import backend
import harness
import luauast as LA
import luasym as S
from luasym import (
    LTable, Builtin, LuaFunc, Buf, Unsupported, Expr, Const, Reg, Pseudo, Global,
    Upval, Index, Bin, Un, IfExp, TempVal, Vararg, ClosureExpr, Multi, TempTail,
    VarargTail, SymList, TailCount, RegFile, EnvTable, UpContainer, Scope,
    BreakSig, ReturnSig, YieldSig, ContinueSig, is_sym,
)
from ir import (
    IRStmt, Assign, CallStmt, SetList, GenIter, Outcome, Next, Ret, Crash, Node,
    ForPrep, Close, Opaque, Vec, Missing, fmt_expr, fmt_any, fmt_tail, fmt_multi,
    fmt_const, fmt_stmt, fmt_node,
)
from obfuscators.luraph_v15.dump import OpaqueFn, JitFrame
from obfuscators.luraph_v15.dataflow import BoxProxy, UpList

def _get_vmmap():
    from obfuscators.luraph_v15 import devirt as _d
    return _d.vmmap

def _classify_vm_method(vmobj, fn_node):
    """Identify Luraph v15 helper methods on the VM object by AST shape rather
    than obfuscated 2-letter method names:
      - 'unpack':  function(W, Z) return W[k](Z, 1, Z.n) end
      - 'setlist': function(W, Z, v, ...) local p = W[kp](...); W[km](p, 1, p.n, v + 1, Z) end
      - 'closure': function(W, Z, v, a, c, X, p) ... end (7 args, creates child VM closure)
    """
    if not isinstance(fn_node, dict) or fn_node.get("type") != "AstExprFunction":
        return None
    args = fn_node.get("args") or []
    body = (fn_node.get("body") or {}).get("body") or []
    if len(args) == 2 and not fn_node.get("vararg") and len(body) == 1 and body[0].get("type") == "AstStatReturn":
        rl = body[0].get("list") or []
        if len(rl) == 1 and rl[0].get("type") == "AstExprCall":
            ca = rl[0].get("args") or []
            fc = rl[0].get("func") or {}
            if len(ca) == 3 and fc.get("type") == "AstExprIndexExpr" and fc["index"].get("type") == "AstExprConstantNumber":
                target = vmobj.get(int(fc["index"]["value"])) if isinstance(vmobj, LTable) else None
                if isinstance(target, Builtin) and "unpack" in target.name:
                    return "unpack"
    if fn_node.get("vararg") and len(args) == 3 and len(body) >= 2:
        for st in body:
            if st.get("type") == "AstStatExpr" and st["expr"].get("type") == "AstExprCall":
                fc = st["expr"].get("func") or {}
                if fc.get("type") == "AstExprIndexExpr" and fc["index"].get("type") == "AstExprConstantNumber":
                    target = vmobj.get(int(fc["index"]["value"])) if isinstance(vmobj, LTable) else None
                    if isinstance(target, Builtin) and target.name == "table.move":
                        return "setlist"
    if len(args) == 7 and not fn_node.get("vararg"):
        return "closure"
    if len(args) == 2 and not fn_node.get("vararg") and len(body) <= 5:
        nums = {int(n["value"]) for n in iter_nodes(fn_node) if n.get("type") == "AstExprConstantNumber" and float(n["value"]).is_integer()}
        if 4294967296 in nums and 65535 not in nums:
            return "u32_trunc"
    if len(args) == 3 and not fn_node.get("vararg"):
        nums = {int(n["value"]) for n in iter_nodes(fn_node) if n.get("type") == "AstExprConstantNumber" and float(n["value"]).is_integer()}
        if 4294967295 in nums and 65535 in nums:
            return "u32_mul"
    return None


class _PlainPrinter(LA.Printer):
    def __init__(self, indent="\t", node_reps=None, capnames=None, fl=None, vm=None, vmobj=None, base_depth=0, parent_lf=None):
        super().__init__(indent)
        self.node_reps = node_reps or {}
        self.capnames = capnames or {}
        self.fl = fl
        self.vm = vm
        self.vmobj = vmobj
        self.base_depth = base_depth
        self.parent_lf = parent_lf

    def _const_lit(self, v):
        if v is None:
            return "nil"
        if isinstance(v, bool):
            return "true" if v else "false"
        if isinstance(v, (int, float)):
            return LA.num(float(v) if isinstance(v, int) and abs(v) >= 2 ** 53 else v)
        if isinstance(v, bytes):
            return LA.quote(v.decode("latin-1"))
        if isinstance(v, str):
            return LA.quote(v)
        return "nil"

    def _lift_wkk(self, spec, depth):
        p_fn, u_desc, upv_tbl_ast, capnames = spec
        fl = self.fl
        if fl is None or not isinstance(p_fn, OpaqueFn) or p_fn.pf_tid is None:
            return "function(...) end"
        dump = fl.prog.dump
        proto = dump.tables.get(p_fn.pf_tid)
        cap = getattr(dump, "cap_by_self", {}).get(p_fn.pf_tid)
        if not isinstance(proto, LTable) or cap is None:
            return "function(...) end"
        mk = cap.get("__maker")
        tag = mk.decode("latin-1") if isinstance(mk, bytes) else (str(mk) if mk is not None else "")
        cvm = dump.vms.get(tag) or self.vm
        cvmobj = cvm.vmobj_of(cap) if hasattr(cvm, "vmobj_of") else self.vmobj

        slot_holders = {}
        if isinstance(upv_tbl_ast, dict) and upv_tbl_ast.get("type") == "AstExprTable":
            for it in upv_tbl_ast.get("items") or []:
                k = it.get("key")
                val = it.get("value")
                if isinstance(k, dict) and k.get("type") == "AstExprConstantNumber" and isinstance(val, dict):
                    slot_holders[int(k["value"])] = self.expr(val, depth)

        entries = []
        upnames = {}
        if isinstance(u_desc, LTable):
            # `u_desc` is a flat run of triplets, one per upvalue:
            #
            #     (tag, field2, field3)
            #
            # The upvalue table the caller passes as the closure's upvalue list
            # is `{[slot] = holder, ...}`, so the body's `upval i` reads
            # `holder[slot]`. Which of the two trailing fields carries that slot
            # is not fixed across the VMs this engine reads: one sample puts it
            # in field2 with field3 a small kind tag (1 / 3), another puts it in
            # field3 with field2 a constant tag. Reading a fixed field therefore
            # named the capture after whatever sat under key 1 or 3, and when
            # nothing did it printed `upvN` -- an undeclared name, i.e. nil, which
            # crashed the moment the script called one.
            #
            # The holder table itself says which field is the slot: its keys are
            # exactly the slots, so the field whose value is present there is the
            # one to use. Anything else stays an honest `upvN` hole.
            count = u_desc.length() // 3
            for idx in range(1, count + 1):
                f2 = u_desc.get((idx - 1) * 3 + 2)
                f3 = u_desc.get((idx - 1) * 3 + 3)
                if isinstance(f2, int) and f2 in slot_holders:
                    slot = f2
                elif isinstance(f3, int) and f3 in slot_holders:
                    slot = f3
                else:
                    slot = None
                entries.append(BoxProxy(idx) if f3 == 2 else UpContainer(idx))
                if slot is not None:
                    upnames[idx] = "%s[%d]" % (slot_holders[slot], slot)
                else:
                    upnames[idx] = "upv%d" % idx
        try:
            sh = dict(getattr(dump, "shared_cap", None) or {})
            for k, v in cap.items():
                if k not in ("self", "__maker", "__seq"):
                    sh.setdefault(k, v)
            lines = fl.lift(cvm, cvmobj, proto, UpList(entries), upnames, self.base_depth + depth + 1, shared=sh)
            params = list(fl.params)
            ind = self.ind * depth
            body = "\n".join(self.ind * (depth + 1) + l for l in lines)
            return "function(" + ", ".join(params) + ")\n" + body + ("\n" if body else "") + ind + "end"
        except Exception:
            return "function(...) end"

    def expr(self, e, depth=0):
        rep = self.node_reps.get(id(e))
        if rep is not None:
            kind = rep[0]
            if kind == "reg":
                return self.capnames.get(rep[1], "r%d" % rep[1])
            if kind in ("global", "builtin"):
                return rep[1]
            if kind == "const":
                return self._const_lit(rep[1])
            if kind == "unpack":
                arg = rep[1]
                s = self.expr(arg, depth)
                if arg.get("type") == "AstExprLocal":
                    return "table.unpack(%s, 1, %s.n)" % (s, s)
                return "(function(_t) return table.unpack(_t, 1, _t.n) end)(%s)" % s
            if kind == "setlist":
                if self.fl is not None:
                    self.fl.prog.dump.needs_setlist = True
                return "_lph_setlist(%s)" % ", ".join(self.expr(a, depth) for a in rep[1])
            if kind == "u32_trunc":
                cv = self._eval_const_num(rep[1])
                if cv is not None:
                    return str((math.floor(cv) % 4294967296) if math.isfinite(cv) else 0)
                if self.fl is not None:
                    self.fl.prog.dump.needs_u32_trunc = True
                return "u32Trunc(%s)" % self.expr(rep[1], depth)
            if kind == "u32_mul":
                ca = self._eval_const_num(rep[1][0])
                cb = self._eval_const_num(rep[1][1])
                if ca is not None and cb is not None and math.isfinite(ca) and math.isfinite(cb):
                    ua = int(math.floor(ca)) & 0xFFFFFFFF
                    ub = int(math.floor(cb)) & 0xFFFFFFFF
                    return str((ua * ub) & 0xFFFFFFFF)
                if self.fl is not None:
                    self.fl.prog.dump.needs_u32_mul = True
                return "u32Mul(%s, %s)" % (self.expr(rep[1][0], depth), self.expr(rep[1][1], depth))
            if kind == "wkk":
                return self._lift_wkk(rep[1], depth)
        return super().expr(e, depth)

    def _eval_const_num(self, e):
        if not isinstance(e, dict):
            return None
        while e.get("type") == "AstExprGroup":
            e = e["expr"]
        rep = self.node_reps.get(id(e))
        if rep is not None:
            k = rep[0]
            if k == "const" and isinstance(rep[1], (int, float)) and not isinstance(rep[1], bool):
                return rep[1]
            if k == "u32_trunc":
                cv = self._eval_const_num(rep[1])
                return ((math.floor(cv) % 4294967296) if math.isfinite(cv) else 0) if cv is not None else None
            if k == "u32_mul":
                ca, cb = self._eval_const_num(rep[1][0]), self._eval_const_num(rep[1][1])
                if ca is not None and cb is not None and math.isfinite(ca) and math.isfinite(cb):
                    return ((int(math.floor(ca)) & 0xFFFFFFFF) * (int(math.floor(cb)) & 0xFFFFFFFF)) & 0xFFFFFFFF
                return None
            return None
        t = e.get("type")
        if t == "AstExprConstantNumber":
            v = e["value"]
            return int(v) if isinstance(v, float) and v.is_integer() else v
        if t == "AstExprUnary" and e.get("op") == "Minus":
            a = self._eval_const_num(e["expr"])
            return -a if a is not None else None
        if t == "AstExprBinary":
            op = e.get("op")
            a, b = self._eval_const_num(e["left"]), self._eval_const_num(e["right"])
            if a is not None and b is not None:
                if op == "Add": return a + b
                if op == "Sub": return a - b
                if op == "Mul": return a * b
                if op == "Mod" and b != 0: return a % b
            return None
        if t == "AstExprCall" and not e.get("self"):
            fn_rep = self.node_reps.get(id(e.get("func")))
            fname = fn_rep[1] if fn_rep and fn_rep[0] in ("global", "builtin") else None
            if fname and fname.startswith("bit32."):
                vals = [self._eval_const_num(a) for a in (e.get("args") or [])]
                if vals and all(v is not None and math.isfinite(v) for v in vals):
                    ivs = [int(math.floor(v)) & 0xFFFFFFFF for v in vals]
                    op = fname.split(".", 1)[1]
                    if op == "band":
                        acc = 0xFFFFFFFF
                        for x in ivs: acc &= x
                        return acc
                    if op == "bor":
                        acc = 0
                        for x in ivs: acc |= x
                        return acc
                    if op == "bxor":
                        acc = 0
                        for x in ivs: acc ^= x
                        return acc
                    if op == "bnot" and len(ivs) >= 1:
                        return (~ivs[0]) & 0xFFFFFFFF
                    if op == "lshift" and len(ivs) >= 2:
                        s = ivs[1] if ivs[1] < 0x80000000 else ivs[1] - 0x100000000
                        return ((ivs[0] << s) & 0xFFFFFFFF) if 0 <= s < 32 else ((ivs[0] >> -s) if -32 < s < 0 else 0)
                    if op == "rshift" and len(ivs) >= 2:
                        s = ivs[1] if ivs[1] < 0x80000000 else ivs[1] - 0x100000000
                        return (ivs[0] >> s) if 0 <= s < 32 else (((ivs[0] << -s) & 0xFFFFFFFF) if -32 < s < 0 else 0)
        return None

    def prefix(self, e, depth):
        rep = self.node_reps.get(id(e))
        if rep is not None and rep[0] == "wkk":
            return "(" + self.expr(e, depth) + ")"
        return super().prefix(e, depth)

    def function(self, e, head, depth):
        params = [a["name"] for a in e["args"]]
        if e.get("vararg"):
            params.append("...")
        sub = _PlainPrinter(self.ind, self.node_reps, self.capnames, fl=self.fl,
                            vm=self.vm, vmobj=self.vmobj, base_depth=self.base_depth, parent_lf=self.parent_lf)
        sub.block(e["body"], depth + 1)
        body = "\n".join(sub.lines)
        return head + "(" + ", ".join(params) + ")\n" + body + ("\n" if body else "") + self.ind * depth + "end"

    @staticmethod
    def _mentions_local(nodes, loc_key):
        for root in nodes:
            for n in iter_nodes(root):
                if n.get("type") == "AstExprLocal" and n.get("local", {}).get("location") == loc_key:
                    return True
        return False

    def block(self, b, depth):
        body = b["body"]
        i = 0
        while i < len(body):
            s = body[i]
            st = s["type"]
            if st in ("AstStatLocal", "AstStatAssign") and len(s["vars"]) == 1 and len(s.get("values") or []) == 1 \
                    and s["values"][0]["type"] == "AstExprTable":
                tgt = s["vars"][0]
                tbl_ast = s["values"][0]
                tgt_loc = tgt["location"] if st == "AstStatLocal" else (
                    tgt["local"]["location"] if tgt["type"] == "AstExprLocal" else None
                )
                can_fold = st == "AstStatLocal" or tgt["type"] in ("AstExprLocal", "AstExprIndexName", "AstExprIndexExpr")
                if can_fold:
                    arr_items = [it for it in tbl_ast["items"] if it["kind"] == "item"]
                    key_items = [it for it in tbl_ast["items"] if it["kind"] != "item"]
                    extra = []
                    j = i
                    while j + 1 < len(body):
                        nxt = body[j + 1]
                        if nxt["type"] != "AstStatExpr":
                            break
                        rep = self.node_reps.get(id(nxt["expr"]))
                        if not (rep and rep[0] == "setlist" and len(rep[1]) >= 2):
                            break
                        s_tbl, s_off = rep[1][0], rep[1][1]
                        vals = rep[1][2:]
                        off_iv = int(s_off["value"]) if s_off.get("type") == "AstExprConstantNumber" else self._eval_const_int(s_off)
                        if off_iv is None or off_iv != len(arr_items) + len(extra):
                            break
                        if st == "AstStatLocal":
                            if not (s_tbl.get("type") == "AstExprLocal" and s_tbl["local"]["location"] == tgt_loc):
                                break
                        else:
                            if self.expr(s_tbl, depth) != self.expr(tgt, depth):
                                break
                        if tgt_loc is not None and self._mentions_local(vals, tgt_loc):
                            break
                        extra.extend({"kind": "item", "value": v} for v in vals)
                        j += 1
                        last_rep = self.node_reps.get(id(vals[-1])) if vals else None
                        last_is_const = last_rep is not None and last_rep[0] == "const"
                        if vals and vals[-1]["type"] in ("AstExprCall", "AstExprVarargs") and not last_is_const:
                            break
                    if extra:
                        merged_tbl = dict(tbl_ast)
                        merged_tbl["items"] = key_items + arr_items + extra
                        merged_s = dict(s)
                        merged_s["values"] = [merged_tbl]
                        self.stat(merged_s, depth)
                        i = j + 1
                        continue
            self.stat(s, depth)
            i += 1

    def stat(self, s, depth):
        if s["type"] == "AstStatExpr":
            rep = self.node_reps.get(id(s["expr"]))
            if rep and rep[0] == "setlist" and len(rep[1]) >= 2:
                s_tbl, s_off = rep[1][0], rep[1][1]
                vals = rep[1][2:]
                if not vals:
                    return
                off_iv = int(s_off["value"]) if s_off.get("type") == "AstExprConstantNumber" else self._eval_const_int(s_off)
                last_rep = self.node_reps.get(id(vals[-1]))
                last_is_const = last_rep is not None and last_rep[0] == "const"
                if off_iv is not None and (vals[-1]["type"] not in ("AstExprCall", "AstExprVarargs") or last_is_const):
                    t_s = self.prefix(s_tbl, depth)
                    lhs = ", ".join("%s[%d]" % (t_s, off_iv + k + 1) for k in range(len(vals)))
                    rhs = ", ".join(self.expr(v, depth) for v in vals)
                    self.emit(depth, lhs + " = " + rhs)
                    return
                t_s = self.expr(s_tbl, depth)
                off_s = str(int(s_off["value"]) + 1) if s_off.get("type") == "AstExprConstantNumber" else (self.expr(s_off, depth) + " + 1")
                rhs = ", ".join(self.expr(v, depth) for v in vals)
                self.emit(depth, "do")
                self.emit(depth + 1, "local _vals = table.pack(%s)" % rhs)
                self.emit(depth + 1, "table.move(_vals, 1, _vals.n, %s, %s)" % (off_s, t_s))
                self.emit(depth, "end")
                return
        super().stat(s, depth)


class PlainProto:
    """A plain Lua function (e.g. LPH_NO_VIRTUALIZE) that captures outer locals."""

    def __init__(self, fn, node, replacements, lines, node_reps=None):
        self.fn = fn
        self.node = node
        self.replacements = replacements
        self.lines = lines
        self.node_reps = node_reps

    def render(self, capnames, upnames, fl=None, vm=None, vmobj=None, depth=0, parent_lf=None):
        if self.node_reps is not None:
            p = _PlainPrinter("\t", self.node_reps, capnames, fl=fl, vm=vm, vmobj=vmobj, base_depth=depth, parent_lf=parent_lf)
            return p.expr(self.node, 0)
        m = re.fullmatch(r"(\d+),(\d+) - (\d+),(\d+)", self.node["location"])
        lines = self.lines
        l1, c1, l2, c2 = (int(x) for x in m.groups())
        if l1 == l2:
            text = lines[l1][c1:c2]
        else:
            text = "\n".join([lines[l1][c1:]] + lines[l1 + 1:l2] + [lines[l2][:c2]])

        for start, end, kind, data in sorted(self.replacements, key=lambda x: x[0], reverse=True):
            if kind == "reg":
                rep = capnames.get(data, "r%d" % data)
            elif kind in ("global", "builtin"):
                rep = data
            else:
                continue
            text = text[:start] + " " + rep + " " + text[end:]
        return text

def iter_nodes(n):
    stack = [n]
    pop = stack.pop
    while stack:
        curr = pop()
        if type(curr) is dict:
            yield curr
            for v in reversed(curr.values()):
                t = type(v)
                if t is dict or t is list:
                    stack.append(v)
        elif type(curr) is list:
            for v in reversed(curr):
                stack.append(v)

class VMModel:
    def __init__(self, info, dispatch_nodes, ctor_funcs):
        self.info = info
        self.maker = info["maker"]
        self.vm = info["vm"]
        self.dispatch = {id(n) for n in dispatch_nodes}
        self.ctor_funcs = ctor_funcs
        self.maker_decls = {}
        for k, nm in _get_vmmap()._decls_in(self.maker).items():
            self.maker_decls.setdefault(nm, []).append(k)
        body = self.vm["body"]["body"]

        self.tcall_idx = None
        self.tstat_nested = False
        self.inner = self.vm
        for i, st in enumerate(body):
            if st["type"] == "AstStatLocal" and len(st["values"]) == 1 \
                    and st["values"][0]["type"] == "AstExprCall":
                call = st["values"][0]
                depth = 0
                while call and call.get("type") == "AstExprCall" and call.get("args"):
                    a0 = call["args"][0]
                    if a0.get("type") == "AstExprFunction" and \
                            any(id(n) in self.dispatch for n in iter_nodes(a0)):
                        self.tcall_idx = i
                        self.inner = a0
                        self.tstat_nested = (depth > 0)
                        break
                    call = a0 if a0.get("type") == "AstExprCall" else None
                    depth += 1
                if self.tcall_idx is not None:
                    break
        if self.tcall_idx is not None:

            self.prologue = body[:self.tcall_idx]
            self.tstat = body[self.tcall_idx]
            self.post = body[self.tcall_idx + 1:]
        else:

            self.prologue = []
            self.tstat = None
            self.post = None
            self.inner = self.vm
        self.inner_body = self.inner["body"]["body"]
        self._find_state_vars()

    def _find_state_vars(self):
        """Loop-state stack K (K={...,[x]=K}), the values saved in it
        (pseudo for-loop variables) and the open-upvalue list (sink)."""
        vm_decls = {**_get_vmmap()._decls_in(self.vm), **_get_vmmap()._decls_in(self.inner)}
        top_decls = set()
        for fn_node in (self.vm, self.inner):
            for a in fn_node.get("args", ()):
                if a.get("location"):
                    top_decls.add(a["location"])
            for st in fn_node.get("body", {}).get("body", ()):
                if self.is_dispatch(st):
                    continue
                if st.get("type") == "AstStatLocal":
                    for vr in st.get("vars", ()):
                        if vr.get("location"):
                            top_decls.add(vr["location"])
        self.special = {}
        self.kstack_key = None
        self.kstack_link = None

        alias = {}
        iterated = set()
        cleared = set()
        table_assigns = []
        local_copies = []

        for n in iter_nodes(self.vm):
            t = n.get("type")
            if t == "AstStatAssign":
                vars_, vals_ = n["vars"], n["values"]
                for var, val in zip(vars_, vals_):
                    vt = var["type"]
                    if vt == "AstExprLocal":
                        vloc = var["local"]["location"]
                        valt = val["type"]
                        if valt == "AstExprLocal":
                            alias.setdefault(vloc, set()).add(val["local"]["location"])
                        elif valt == "AstExprTable" and vloc in vm_decls:
                            table_assigns.append((vloc, val["items"]))
                    elif vt == "AstExprIndexExpr":
                        if var["expr"]["type"] == "AstExprLocal" and val["type"] == "AstExprConstantNil":
                            cleared.add(var["expr"]["local"]["location"])
            elif t == "AstStatLocal":
                vars_, vals_ = n["vars"], n["values"]
                for var, val in zip(vars_, vals_):
                    if val["type"] == "AstExprLocal":
                        alias.setdefault(var["location"], set()).add(val["local"]["location"])
                        if val["local"]["location"] in vm_decls:
                            local_copies.append((var["location"], val["local"]["location"]))
            elif t == "AstStatForIn":
                vals_ = n["values"]
                if len(vals_) >= 2 and vals_[1]["type"] == "AstExprLocal":
                    iterated.add(vals_[1]["local"]["location"])
                elif len(vals_) == 1 and vals_[0]["type"] == "AstExprLocal":
                    iterated.add(vals_[0]["local"]["location"])

        for me, items in table_assigns:
            link = None
            saved = []
            for it in items:
                v = it["value"]
                if v["type"] == "AstExprLocal" and it["kind"] == "general" and \
                        (v["local"]["location"] == me or alias.get(v["local"]["location"]) == {me}):
                    kn = it["key"]
                    while kn.get("type") == "AstExprGroup":
                        kn = kn["expr"]
                    if kn.get("type") == "AstExprUnary" and kn.get("op") == "Minus" and "value" in kn.get("expr", {}):
                        link = -kn["expr"]["value"]
                    else:
                        link = kn.get("value")
                elif v["type"] == "AstExprLocal":
                    saved.append(v["local"])
            if link is not None:
                self.kstack_key = me
                self.kstack_link = S.fix_int(link)
                for loc in saved:
                    self.special[loc["location"]] = ("pseudo", loc["name"])

        sink_cands = iterated & cleared
        for var_loc, val_loc in local_copies:
            if val_loc in top_decls and val_loc not in self.special and var_loc in sink_cands:
                self.special[val_loc] = "sink"

        for loc in sink_cands:
            if loc in top_decls and loc not in self.special:
                self.special[loc] = "sink"

    def is_dispatch(self, node):
        return id(node) in self.dispatch

    def proto_index(self):
        return self.info.get("proto_index", 1)

    def upvals_index(self):
        return self.info.get("upvals_index", 2)

    def maker_args(self, vmobj, proto, upvals, cap=None):
        n = len(self.maker["args"])
        vals = [None] * max(n, 3)
        if self.info.get("mode") == "dispatch_local" and cap is not None:
            if self.info.get("chain"):
                return [upvals] * max(n, 3)
            # this build's factory does not take (vmobj, proto, upvals): its
            # real arguments were captured per proto (`__PA[pv]` holds every
            # free name, the parameters included)
            for i, a in enumerate(self.maker["args"]):
                nm = a["name"]
                if nm == "..." :
                    continue
                if nm in cap:
                    vals[i] = cap[nm]
            return vals
        vals[0], vals[self.proto_index()], vals[self.upvals_index()] = vmobj, proto, upvals
        return vals

    def proto_of(self, cap):
        p = cap.get("self")
        return p if p is not None else cap.get(self.maker["args"][self.proto_index()]["name"])

    def vmobj_of(self, cap):
        if self.info.get("chain"):
            c0 = self.info["chain"][0]
            if c0.get("args"):
                v = cap.get(c0["args"][0]["name"])
                if v is not None:
                    return v
        return cap.get(self.maker["args"][0]["name"])

def find_ctor_funcs(root):
    """Functions in every `setmetatable({...})`-style table constructor:
    key -> AstExprFunction. Luraph can ship several ctor tables (one per VM
    family); every function in any of them can be bound to an OpaqueFn, so
    keys from all tables merge (int keys of later tables offset by their
    position to avoid collisions)."""
    out = {}
    tables = []
    for n in iter_nodes(root):
        if n.get("type") != "AstExprTable":
            continue
        fns = sum(1 for it in n["items"] if it["value"]["type"] == "AstExprFunction")
        if fns:
            tables.append((fns, n))
    tables.sort(key=lambda t: -t[0])
    for rank, (_, table) in enumerate(tables):
        pos = 0
        for it in table["items"]:
            if it["kind"] == "item":
                pos += 1
            if it["value"]["type"] != "AstExprFunction":
                continue
            if it["kind"] == "item":
                out.setdefault(pos if rank == 0 else 100000 * (rank + 1) + pos, it["value"])
            elif it["kind"] == "record":
                out.setdefault(it["key"]["value"].encode("latin-1"), it["value"])
            elif it["kind"] == "general" and it["key"]["type"] == "AstExprConstantNumber":
                out.setdefault(S.fix_int(it["key"]["value"]), it["value"])
            elif it["kind"] == "general" and it["key"]["type"] == "AstExprConstantString":
                out.setdefault(it["key"]["value"].encode("latin-1"), it["value"])
    return out

class VMCrash(Unsupported):
    pass

class Overlay:
    """Path-sensitive writes to the proto's instruction arrays and buffers.
    Luraph decrypts code in place, in XOR layers (several decryptors can cover
    one slot); decryptors on different paths must not see each other's
    effects. Persistent chain of dicts; `h` hashes the content (vs the base)
    so equal overlays from different paths merge."""
    __slots__ = ("parent", "d", "h", "depth")
    MASK = (1 << 64) - 1

    def __init__(self, parent=None):
        self.parent = parent
        self.d = {}
        self.h = parent.h if parent else 0
        self.depth = parent.depth + 1 if parent else 0

    def get(self, key, base):
        o = self
        while o is not None:
            if key in o.d:
                return o.d[key]
            o = o.parent
        return base

    def set(self, key, value, base_value):
        old = self.get(key, base_value)
        if _differs(old, base_value):
            self.h = (self.h - hash((key, _hv(old)))) & self.MASK
        if _differs(value, base_value):
            self.h = (self.h + hash((key, _hv(value)))) & self.MASK
        self.d[key] = value

    def flattened(self):
        if self.depth < 24:
            return self
        o = Overlay()
        chain = []
        x = self
        while x is not None:
            chain.append(x)
            x = x.parent
        for x in reversed(chain):
            o.d.update(x.d)
        o.h = self.h
        return o

def _differs(a, b):
    return type(a) is not type(b) or not S.lua_eq(a, b)

def _hv(v):
    if isinstance(v, (int, float, bytes, bool)) or v is None:
        return v
    return id(v)

def _pack_sig(l):
    sig = re.sub(r"\d+_\d+_", "_", fmt_expr(l))
    return "%s@%d" % (sig, l.nkey) if isinstance(getattr(l, "nkey", None), int) else sig

class State:
    """(mode, pc, loop-stack, known jump-register values, array overlay) at an
    instruction boundary."""
    __slots__ = ("mode", "pc", "kstack", "jregs", "ov", "packs", "locs")

    def __init__(self, mode, pc, kstack, jregs=(), ov=None, packs=(), locs=()):
        self.mode, self.pc, self.kstack, self.jregs, self.ov = mode, pc, kstack, jregs, ov
        self.packs = packs    
        self.locs = locs      

    def key(self, link):
        d = 0
        k = self.kstack
        if isinstance(k, JitFrame):
            d, k = k.depth, None
        while isinstance(k, LTable):
            d += 1
            k = k.get(link)
        ov_k = self.ov if isinstance(self.ov, int) else (self.ov.h if self.ov is not None else 0)
        return (self.mode, self.pc, d, tuple((rk, _hv(rv)) for rk, rv in self.jregs), ov_k,
                tuple((r, _pack_sig(l)) for r, l in self.packs),
                tuple((kk, _carry_key(v)) for kk, v in self.locs))

WALK_MAX_ERRORS = 100
WALK_RESTARTS = 64
WALK_LIMIT = int(os.environ.get("DEVIRT_WALK_LIMIT", 250000))

class PackTop:
    __slots__ = ("n",)
    def __init__(self, n):
        self.n = n
    def __repr__(self):
        return "packtop(%d)" % self.n

def _carry_key(v):
    """Canonical state-key form of a carried local's value (equal states must
    merge even when the value objects differ, e.g. two Const(False))."""
    if isinstance(v, PackTop):
        return ("PT", v.n)
    if isinstance(v, RegFile):
        return "RF"
    if isinstance(v, EnvTable):
        return "ENV"
    if isinstance(v, UpList):
        return "UPL"
    if isinstance(v, UpContainer):
        return "UPC%s" % (v.idx,)
    if isinstance(v, SymList):
        return ("SL", tuple(_carry_key(x) for x in v.items), fmt_tail(v.tail) if v.tail is not None else None)
    if isinstance(v, LTable):
        return "T%s" % v.tid
    if isinstance(v, (Builtin, OpaqueFn)):
        return repr(v)
    if isinstance(v, ClosureExpr):
        return "C<%s>" % (getattr(v.proto, "tid", None),)
    if isinstance(v, Expr):
        return fmt_expr(v)
    if isinstance(v, str):
        return sys.intern(v)
    if v is None or isinstance(v, (bytes, int, float, bool)):
        return v
    return id(v)

MAX_STACK_DEPTHS = int(os.environ.get('DEVIRT_MAX_DEPTHS', 32))
STACK_WALK_MAX = 30000

def _locs_lt(a, b):
    """Ordering over carried-local tuples that never raises. The same local
    can carry an int (the stack pointer) in one state and None in another,
    and different states carry different key sets -- raw tuple comparison
    raises (int < None). Keys compare first, then values on a total form."""
    if a == b:
        return False
    def form(l):
        ks, vs = [], []
        for k, v in l:
            ks.append((0, k, "") if isinstance(k, int) else (1, 0, str(k)))
            c = _carry_key(v)
            if isinstance(c, bool):
                c = int(c)
            if isinstance(c, (int, float)):
                vs.append((0, c, ""))
            elif c is None:
                vs.append((1, 0, ""))
            else:
                vs.append((2, 0, str(c)))
        return ks, vs
    return form(a) < form(b)

