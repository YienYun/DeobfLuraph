"""Luraph v15 prototype symbolic walker and bytecode-to-IR lifter (ProtoLifter)."""
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
from obfuscators.luraph_v15.dump import FrameArg, OpaqueFn, RuntimeMaker, SharedFn, JitFrame, REG_ARRAY
from obfuscators.luraph_v15.dataflow import (
    BoxPart, BoxProxy, FRAME, FrameProxy, MaybeBox, OPENUPS, OpenUps, REGFILE, UpList, expr_regs, walk_expr,
)
from obfuscators.luraph_v15.vm_model import (
    Overlay, PlainProto, VMCrash, _classify_vm_method, _differs, _pack_sig, iter_nodes,
)
from obfuscators.luraph_v15.stepper import (
    GenIterMaker, JIT_BOTTOM, JIT_TMP, JitModel, JitProto, _declared_in, _jit_nested_model,
)

class ProtoLifter:
    """Steps the instructions of one proto."""
    walk_only = False   

    def __init__(self, vm, dump, vmobj, proto, upvals, globals_tab, cap=None, shared=None):
        self.vm = vm
        self.vmobj = vmobj
        self.dump = dump
        self.cap = cap
        # by-name fallback for the capture's values (see Interp.getvar):
        # a captured proto gets its own capture; an uncaptured child gets the
        # VM-wide shared fields (A/P/j/l) every proto's capture agrees on
        self.cap_fallback = {}
        src = cap if cap is not None else (shared or {})
        for nm, v in src.items():
            if nm in ("self", "__maker", "__seq"):
                continue
            if v is None or isinstance(v, (LTable, Builtin, OpaqueFn, Opaque,
                                           int, float, bytes, bool)):
                self.cap_fallback[nm] = v
        self.special = vm.special
        self.globals_tab = globals_tab
        self.out = []
        self.temp_prefix = ""
        self.tcount = 0
        self.proto_arrays = set()
        self.reg_arrays = set()      
        self.children = []
        self.requests = set()
        self.jump_regs = set()
        self.need_jump_regs = set()
        self.cff_regs = set()
        self.merged_int_regs = set()
        self.arith_regs = set()
        self.int_regs = set()
        self.jvals = {}
        self.jread = set()
        self.reg_gen = {}
        self.reg_def_idx = {}
        self.war_saved = {}
        self.cur_it = None
        self.stack_base = None       
        self.captured_regs = set()   
        self.frame_uses = set()      
        self.packs = {}         
        self.pack_copies = {}
        self.pack_read = set()
        self.pack_unstable = set()   
        self.pack_killed = set()     
        self.ov = None
        self.ov_base = None
        self.proto_ov = None
        self.proto_ov_base = None
        # (up i|vararg i) -> ("c", value) facts a caller knows about this proto's
        # upvalues/varargs; set by FunctionLifter.lift / _walk_one after construction
        self.init_facts = {}
        self.in_prologue = False
        self.cur_scope = None
        self.reg_prefix = "r"
        self.jstack = None           
        self.proto = proto
        max_cap_int = max(
            (v for v in (cap or {}).values() if isinstance(v, int) and not isinstance(v, bool) and 0 < v < 65536),
            default=0,
        )
        max_proto_int = max(
            (v for v in proto.h.values() if isinstance(v, int) and not isinstance(v, bool) and 0 < v < 65536),
            default=0,
        )
        self.max_reg = max(4096, max_cap_int + 256, max_proto_int + 256)
        for v in proto.h.values():
            if isinstance(v, LTable) and v is not vmobj:
                self.proto_arrays.add(id(v))
        if cap is not None and vm.info.get("mode") == "dispatch_local":
            for k, v in cap.items():
                if isinstance(v, LTable) and v is not vmobj and k not in ("self", "U"):
                    self.proto_arrays.add(id(v))
        self.making = False
        if isinstance(proto, JitProto):

            self.maker_scope = proto.env
            return

        it = S.Interp(self)
        self.making = True
        env0 = Scope()
        if src and getattr(vm, "outer", None):
            # free names of the VM closure the maker's own scope cannot
            # resolve (helpers registered in an enclosing method: A, P, ...)
            # come from the capture (or shared fallback for uncaptured child
            # protos), bound at their real declaration keys so a scope miss
            # falls back to the same values the real run saw.
            for key, nm in vm.outer.items():
                if nm not in src:
                    continue
                v = src[nm]
                if v is None or isinstance(v, (LTable, Builtin, OpaqueFn, Opaque,
                                               int, float, bytes, bool)):
                    env0.vars[key] = v
            for cfn in vm.info.get("chain") or ():
                cbody = cfn.get("body", {}).get("body") or ()
                lstats = [st for st in cbody if st.get("type") == "AstStatLocal"]
                if lstats:
                    try:
                        it.exec_block(lstats, env0)
                    except Exception:
                        pass
        r = it.call_lua(LuaFunc(vm.maker, env0), Multi(vm.maker_args(vmobj, proto, upvals, cap)))
        self.making = False
        f = r.first() if isinstance(r, Multi) else r
        if not isinstance(f, LuaFunc) or f.node is not vm.vm:
            raise Unsupported("closure maker did not return the VM closure")
        self.maker_scope = f.env

    def initial_state(self):
        self.in_prologue = True
        cs = Scope(self.maker_scope)
        cs.vars["..."] = Multi([], VarargTail(1))
        self.cur_scope = cs
        it = S.Interp(self)
        it.exec_block(self.vm.prologue, cs)
        self.in_prologue = False
        self.closure_scope = cs
        return cs

    def state_packs(self):
        """The unread packs carried into the next state."""
        return tuple(sorted(((r, l) for r, l in self.packs.items()
                             if (r not in self.pack_read or isinstance(l.tail, VarargTail))
                             and (r, _pack_sig(l)) not in self.pack_unstable), key=lambda kv: kv[0]))

    def is_dispatch(self, node):
        return self.vm.is_dispatch(node)

    def _fix_war_expr(self, e):
        if not self.reg_gen or e is None:
            return e
        if isinstance(e, Reg):
            g = getattr(e, "_gen", None)
            if g is not None and g < self.reg_gen.get(e.n, 0):
                key = (e.n, g)
                sc = self.war_saved.get(key)
                if sc is None:
                    sc = Reg(810001 + len(self.war_saved))
                    self.war_saved[key] = sc
                    idx = self.reg_def_idx[key]
                    self.out.insert(idx, Assign(sc, Reg(e.n)))
                    for k, v in list(self.reg_def_idx.items()):
                        if v >= idx:
                            self.reg_def_idx[k] = v + 1
                    if self.cur_it is not None:
                        self.cur_it.dlog = [
                            (dp, at + 1 if at >= idx else at, cd, dv)
                            for dp, at, cd, dv in self.cur_it.dlog
                        ]
                return sc
            return e
        if isinstance(e, Index):
            return Index(self._fix_war_expr(e.obj), self._fix_war_expr(e.key))
        if isinstance(e, Bin):
            return Bin(e.op, self._fix_war_expr(e.a), self._fix_war_expr(e.b))
        if isinstance(e, Un):
            return Un(e.op, self._fix_war_expr(e.a))
        if isinstance(e, IfExp):
            return IfExp(self._fix_war_expr(e.c), self._fix_war_expr(e.a), self._fix_war_expr(e.b))
        return e

    def _resolve_jval(self, v, _max_idx=None):
        if isinstance(v, Const) and isinstance(v.v, int) and not isinstance(v.v, bool):
            return v.v
        if isinstance(v, Bin) and v.op in ("Add", "Sub", "Mul", "Mod", "FloorDiv"):
            av = self._resolve_jval(v.a, _max_idx)
            bv = self._resolve_jval(v.b, _max_idx)
            if av is not None and bv is not None:
                if v.op == "Add": return S.fix_int(av + bv)
                if v.op == "Sub": return S.fix_int(av - bv)
                if v.op == "Mul": return S.fix_int(av * bv)
                if v.op == "Mod" and bv != 0: return S.fix_int(av % bv)
                if v.op == "FloorDiv" and bv != 0: return S.fix_int(av // bv)
            return None
        if isinstance(v, Un) and v.op == "Minus":
            av = self._resolve_jval(v.a, _max_idx)
            if av is not None:
                return S.fix_int(-av)
            return None
        if isinstance(v, (Upval, Vararg)):
            k = ("up", v.idx) if isinstance(v, Upval) else ("vararg", v.i)
            for d in (getattr(self, "cur_facts", None), getattr(self, "init_facts", None)):
                if isinstance(d, dict):
                    f = d.get(k)
                    if f and f[0] == "c" and isinstance(f[1], int) and not isinstance(f[1], bool):
                        return f[1]
            return None
        if isinstance(v, Reg):
            end = len(self.out) if _max_idx is None else _max_idx
            for i in range(end - 1, -1, -1):
                prev = self.out[i]
                if isinstance(prev, Assign) and isinstance(prev.target, Reg) and prev.target.n == v.n:
                    return self._resolve_jval(prev.value, i)
            ijv = getattr(self, "init_jvals", self.jvals)
            if v.n in ijv and isinstance(ijv[v.n], int) and not isinstance(ijv[v.n], bool):
                return ijv[v.n]
            if v.n not in self.jump_regs:
                cf = getattr(self, "cur_facts", None)
                if isinstance(cf, dict):
                    f = cf.get(v.n)
                    if f and f[0] == "c" and isinstance(f[1], int) and not isinstance(f[1], bool):
                        return f[1]
        return None

    def emit(self, st):
        if isinstance(st, Assign):
            if not isinstance(st.target, Reg):
                st.target = self._fix_war_expr(st.target)
            st.value = self._fix_war_expr(st.value)
        elif isinstance(st, CallStmt):
            st.fn = self._fix_war_expr(st.fn)
            st.args = Multi([self._fix_war_expr(x) for x in st.args.items], st.args.tail)
        if isinstance(st, Assign) and isinstance(st.target, Reg):
            old = self.packs.pop(st.target.n, None)
            if old is not None and st.target.n not in self.pack_read:
                self.pack_killed.add((st.target.n, _pack_sig(old)))
            self.pack_copies.pop(st.target.n, None)
            self.pack_read.discard(st.target.n)
            pt = getattr(self, "pending_tail", None)
            if pt is not None:
                self.pending_tail = None
                if isinstance(st.value, Bin) and any(isinstance(x, TailCount) and x.tail is pt[1] for x in walk_expr(st.value)):
                    self.packs[st.target.n] = SymList([], pt[1], nkey=pt[0])
                    return
            if isinstance(st.value, SymList):
                self.packs[st.target.n] = st.value
                if isinstance(st.value.nkey, int):
                    return
        if isinstance(st, Assign) and isinstance(st.target, Reg) and (
                self.jvals.get(st.target.n) is FRAME or isinstance(self.jvals.get(st.target.n), (OpaqueFn, LTable))):
            del self.jvals[st.target.n]
        if isinstance(st, Assign) and isinstance(st.target, Reg):
            jv0 = self._resolve_jval(st.value)
            if jv0 is not None:
                self.int_regs.add(st.target.n)
            if isinstance(st.value, Bin) and st.value.op in ("Add", "Sub", "Mul", "Div", "FloorDiv", "Mod", "Pow", "Concat"):
                self.arith_regs.add(st.target.n)
                for rx in (st.value.a, st.value.b):
                    if isinstance(rx, Reg):
                        self.arith_regs.add(rx.n)
            if st.target.n in self.cff_regs and st.target.n in self.jread:
                self.arith_regs.add(st.target.n)
                self.cff_regs.discard(st.target.n)
                self.jump_regs.discard(st.target.n)
                self.jvals.pop(st.target.n, None)
                self.cff_dropped = True
        if isinstance(st, Assign) and isinstance(st.target, Reg) and st.target.n in self.cff_regs:
            jv = self._resolve_jval(st.value)
            if jv is not None:
                self.jvals[st.target.n] = jv
                self.jread.discard(st.target.n)
            else:
                self.jvals.pop(st.target.n, None)
            st.jump = True
        elif isinstance(st, Assign) and isinstance(st.target, Reg) and st.target.n in self.jump_regs \
                and self.stack_base is not None and isinstance(st.target.n, int) and st.target.n > self.stack_base:

            jv = self._resolve_jval(st.value)
            if jv is not None:
                self.jvals[st.target.n] = jv
                self.jread.discard(st.target.n)
            else:
                self.jvals.pop(st.target.n, None)
        elif isinstance(st, Assign) and isinstance(st.target, Reg) and st.target.n in self.jump_regs:
            jv = self._resolve_jval(st.value)
            if jv is not None:
                self.jvals[st.target.n] = jv
                self.jread.discard(st.target.n)
            else:
                self.jvals.pop(st.target.n, None)
            st.jump = True
        elif isinstance(st, Assign) and isinstance(st.target, Reg) and not isinstance(self.jvals.get(st.target.n), JitFrame):
            self.jvals.pop(st.target.n, None)
        if isinstance(st, Assign) and isinstance(st.target, Reg):
            if not (isinstance(st.value, Reg) and st.value.n == st.target.n):
                g = self.reg_gen.get(st.target.n, 0)
                self.reg_def_idx[(st.target.n, g)] = len(self.out)
                self.reg_gen[st.target.n] = g + 1
        self.out.append(st)

    def new_temp(self):
        self.tcount += 1
        return "%s%d" % (self.temp_prefix, self.tcount)

    def special_get(self, sp, it):
        if sp == "sink":
            return OPENUPS
        if sp[0] == "reg":

            return self.index(REGFILE, sp[1], it)
        if sp[0] == "jstack":
            return self.jstack
        if sp[0] == "upval":
            return Upval(sp[1])
        if sp[0] == "pseudo":
            return Pseudo(sp[1], self.depth(it))
        raise Unsupported(sp)

    def special_set(self, sp, v, it):
        if sp == "sink":
            return
        if sp[0] in ("reg", "jstack", "upval") and self.in_prologue:
            return      
        if sp[0] == "upval":
            self.emit(Assign(Upval(sp[1]), self.value_of(v)))
            return
        if sp[0] == "jstack":
            if isinstance(v, Multi):
                v = v.first()
            if v is None:
                self.jstack = JIT_BOTTOM
                return
            if isinstance(v, JitFrame):
                self.jstack = v         
                return
            link = [k for k, x in v.h.items() if isinstance(x, JitFrame)] if isinstance(v, LTable) else []
            if isinstance(v, LTable) and v.tid is None and len(link) <= 1:

                parent = v.h[link[0]] if link else JIT_BOTTOM
                fr = JitFrame(link[0] if link else None, parent.depth + 1)
                if link:
                    fr.h[link[0]] = parent
                for k, x in v.h.items():
                    if not link or k != link[0]:
                        pv = Pseudo("JIT%s" % k, fr.depth)
                        self.emit(Assign(pv, self.value_of(x)))
                        fr.h[k] = pv
                self.jstack = fr
                return
            raise Unsupported("LPH_JIT loop stack set to %r (%s; stack %s)" % (
                v, {k: fmt_any(x) for k, x in v.h.items()} if isinstance(v, LTable) else "", fmt_any(self.jstack)))
        if sp[0] == "reg":
            if isinstance(v, Multi):
                v = v.first()
            if isinstance(v, JitFrame):

                self.jvals[sp[1]] = v
                return
            if isinstance(self.jvals.get(sp[1]), JitFrame):
                del self.jvals[sp[1]]
            if isinstance(v, LTable) and v.tid is None and v.h:

                keys = sorted(v.h, key=lambda k: (not isinstance(k, int), repr(k)))
                seq = keys == list(range(1, len(keys) + 1))
                items = [(None if seq else self.as_expr(k), self.value_of(v.h[k])) for k in keys]
                self.newindex(REGFILE, sp[1], S.NewTable(items), it)
                return
            self.newindex(REGFILE, sp[1], v, it)
            return
        if sp[0] == "pseudo":
            self.emit(Assign(Pseudo(sp[1], self.depth(it)), self.value_of(v)))
            return
        raise Unsupported(sp)

    def depth(self, it):
        if isinstance(getattr(self, "jstack", None), JitFrame):
            return self.jstack.depth
        if not self.vm.kstack_key:
            return 0
        k = self.cur_scope.lookup(self.vm.kstack_key)
        kv = k.vars[self.vm.kstack_key] if k else None
        d = 0
        while isinstance(kv, LTable):
            d += 1
            if d > 8:
                raise Unsupported("kstack depth %d exceeds limit" % d)
            kv = kv.get(self.vm.kstack_link)
        return d

    def jit_closure(self, fn):
        """A Lua function made inside an LPH_JIT function -> ClosureExpr
        lifted with its own JitModel. The outer locals it uses are upvalues:
        registers by reference, instruction temps with a symbolic value
        copied into a register first."""
        jm = _jit_nested_model(fn.node)
        if jm is None:
            raise Unsupported("a Lua function in an LPH_JIT function that is not a state machine")
        declared = _declared_in(fn.node)
        ups, upmap = [], {}
        for n in iter_nodes(fn.node):
            if n.get("type") != "AstExprLocal":
                continue
            loc = n["local"]["location"]
            if loc in declared or loc in upmap:
                continue
            sp = self.special.get(loc)
            if sp is not None and sp[0] == "reg":
                ups.append(Reg(sp[1]))
            elif sp is not None and sp[0] == "upval":
                ups.append(Upval(sp[1]))
            else:
                sc = fn.env.lookup(loc)
                v = sc.vars[loc] if sc is not None else None
                if not is_sym(v):
                    continue        
                self.tmp_regs = getattr(self, "tmp_regs", 0) + 1
                r = Reg(JIT_TMP + self.tmp_regs)
                self.emit(Assign(r, self.value_of(v)))
                ups.append(r)
            upmap[loc] = len(ups)
        c = ClosureExpr(JitProto(fn.env, upmap), ups)
        c.vm = jm
        for u in ups:
            if isinstance(u, Reg):
                self.captured_regs.add(u.n)
        self.children.append(c)
        return c

    def parallel_values(self, targets, vals, it):
        """`a, b = b, a` / `t[1], t[2] = t[2], t[1]`: Lua evaluates every value
        before assigning, but IR assignments are statements in order and
        register reads are references. A value that reads what an earlier
        target of the same statement writes (a register, or any table slot
        when a table store came first) is copied into a fresh register
        first."""
        regs = set()
        stored = False          
        out = list(vals)
        for i, tg in enumerate(targets):
            x = out[i]
            if i > 0 and (regs or stored) and is_sym(x):
                hit = False
                for e in walk_expr(x):
                    if (isinstance(e, Reg) and e.n in regs) or (stored and isinstance(e, (Index, Pseudo))):
                        hit = True
                        break
                if hit:
                    self.tmp_regs = getattr(self, "tmp_regs", 0) + 1
                    t = Reg(JIT_TMP + self.tmp_regs)
                    self.emit(Assign(t, self.value_of(x)))
                    out[i] = t
            if tg[0] == "local":
                sp = self.special.get(tg[1]["location"])
                if sp is not None and sp[0] == "reg":
                    regs.add(sp[1])
            elif tg[0] == "index":
                if isinstance(tg[1], RegFile) and isinstance(tg[2], int):
                    regs.add(S.norm_key(tg[2]))
                elif is_sym(tg[1]) or isinstance(tg[1], JitFrame):
                    stored = True
        return out

    def global_value(self, name):
        v = self.globals_tab.get(name.encode("latin-1"))
        if v is None:

            return Global(name)
        return v

    def reg_array(self, key):
        """`R[base + e]`: Luraph keeps a local array in registers base..
        (fetched.lua: two 256-entry tables at 6 and 262). Lifted as a table
        `Reg(REG_ARRAY + base)` indexed by e, declared `{}` at entry."""
        if not (isinstance(key, S.Bin) and key.op == "Add"):
            return None
        a, b = key.a, key.b
        if isinstance(b, Const) and isinstance(b.v, int) and not isinstance(b.v, bool):
            a, b = b, a
        if not (isinstance(a, Const) and isinstance(a.v, int) and not isinstance(a.v, bool)):
            return None
        self.reg_arrays.add(a.v)
        return Reg(REG_ARRAY + a.v), b

    def library_name(self, t):
        if not hasattr(self, "_lib_names"):
            self._lib_names = {id(v): k.decode("latin-1") for k, v in self.globals_tab.h.items() if isinstance(k, bytes)}
        return self._lib_names.get(id(t))

    def set_global(self, name, v):

        self.emit(Assign(Global(name), self.value_of(v)))

    def varargs(self, scope):
        s = scope
        while s is not None:
            if "..." in s.vars:
                return s.vars["..."]
            s = s.parent
        raise Unsupported("varargs outside vararg function")

    def as_expr(self, v):
        if isinstance(v, MaybeBox):
            return Reg(v.reg)
        if isinstance(v, BoxPart):
            return Index(Upval(v.idx), self.as_expr(v.k))
        if isinstance(v, BoxProxy):
            return Upval(v.idx)
        if isinstance(v, Expr):
            return v
        if v is None or isinstance(v, (bool, int, float, bytes)):
            return Const(v)
        if isinstance(v, Multi):
            return self.as_expr(v.first())
        if isinstance(v, SymList):
            return v
        if isinstance(v, Vec):
            return v
        if isinstance(v, EnvTable):
            return Global("_ENV")
        if isinstance(v, LuaFunc) and isinstance(self.vm, JitModel):
            return self.jit_closure(v)
        if isinstance(v, OpaqueFn) and v.pf_tid is not None and v.node is None:
            n = self.dump.shared.setdefault(v.lfid, len(self.dump.shared) + 1)
            return SharedFn(v, n)
        if isinstance(v, OpaqueFn):
            if v.node is not None:
                clo = self.plain_closure(LuaFunc(v.node, Scope()))
                if clo is not None:
                    return clo
                return Opaque("function", self.plain_function_text(v.node) or "function(...) end")
            n = self.dump.shared.setdefault(v.lfid, len(self.dump.shared) + 1)
            return SharedFn(v, n)
        if isinstance(v, Buf):

            t = self.new_temp()
            self.emit(CallStmt(t, Global("buffer.fromstring"), Multi([Const(bytes(v.data))])))
            return TempVal(t, 1)
        if isinstance(v, Builtin) and v.fn is None:

            return Global(v.name)
        if isinstance(v, LuaFunc):
            clo = self.plain_closure(v)
            if clo is not None:
                return clo
            text = self.plain_function_text(v)
            if text is not None:
                return Opaque("function", text)
            return Opaque("function", "function(...) end")
        raise Unsupported("value %r in an expression" % (v,))

    def plain_closure(self, fn):
        """A plain Lua function that captures outer locals via the maker function."""
        node = fn.node
        src_map = getattr(self.dump, "plain_src_by_node", {})
        lines = src_map.get(id(node)) or getattr(self.vm, "src_lines", None)
        if not isinstance(node, dict) or node.get("type") != "AstExprFunction" or not lines:
            return None
        declared = _declared_in(node)
        undeclared = [n for n in iter_nodes(node) if n.get("type") == "AstExprLocal" and n["local"]["location"] not in declared]
        if not undeclared or not hasattr(fn, "env") or fn.env is None:
            return None

        parent_map = {}
        for n in iter_nodes(node):
            for k, val in n.items():
                if isinstance(val, dict):
                    parent_map[id(val)] = (n, k)
                elif isinstance(val, list):
                    for item in val:
                        if isinstance(item, dict):
                            parent_map[id(item)] = (n, k)

        def _boxed_reg(t):
            if not isinstance(t, LTable) or len(t.h) != 2:
                return None
            sk = ik = rnum = None
            for kk, vv in t.h.items():
                if isinstance(vv, RegFile):
                    sk = kk
                elif isinstance(vv, int) and not isinstance(vv, bool):
                    ik, rnum = kk, vv
            return (sk, ik, rnum) if sk is not None and ik is not None else None

        node_reps = {}
        consumed_ids = set()
        ups = []

        # Pre-scan W:kk(kp, ku, upv_tbl, Z, v, env) child-VM closure calls so Z/v args are marked consumed.
        for n in undeclared:
            loc = n["local"]["location"]
            sc = fn.env.lookup(loc)
            val = sc.vars[loc] if sc is not None else None
            if not isinstance(val, LTable):
                continue
            p, _ = parent_map.get(id(n), (None, None))
            if not (p and p.get("type") == "AstExprIndexName" and p.get("op") == ":"):
                continue
            gp, _ = parent_map.get(id(p), (None, None))
            if not (gp and gp.get("type") == "AstExprCall" and gp.get("self") and gp.get("func") is p):
                continue
            mfn = val.get(p["index"].encode("latin-1"))
            mnode = mfn.node if isinstance(mfn, (OpaqueFn, LuaFunc)) else (mfn if isinstance(mfn, dict) else None)
            mkind = _classify_vm_method(val, mnode)
            cargs = gp.get("args") or []
            if mkind == "closure" and len(cargs) == 6 \
                    and cargs[0].get("type") == "AstExprConstantNumber" \
                    and cargs[1].get("type") == "AstExprConstantNumber":
                kp, ku = int(cargs[0]["value"]), int(cargs[1]["value"])
                z_ast, v_ast, env_ast = cargs[3], cargs[4], cargs[5]
                z_sc = fn.env.lookup(z_ast["local"]["location"]) if z_ast.get("type") == "AstExprLocal" else None
                z_tbl = z_sc.vars[z_ast["local"]["location"]] if z_sc is not None else None
                if isinstance(z_tbl, LTable):
                    p_fn = self.index(z_tbl, kp, None)
                    u_desc = self.index(z_tbl, ku, None)
                    for extra in (z_ast, v_ast, env_ast):
                        if isinstance(extra, dict) and extra.get("type") == "AstExprLocal" \
                                and extra["local"]["location"] not in declared:
                            consumed_ids.add(id(extra))
                    consumed_ids.add(id(n))
                    node_reps[id(gp)] = ("wkk", (p_fn, u_desc, cargs[2], None))
                    if self.walk_only and isinstance(p_fn, OpaqueFn) and p_fn.pf_tid in self.dump.tables:
                        cproto = self.dump.tables[p_fn.pf_tid]
                        ccap = getattr(self.dump, "cap_by_self", {}).get(p_fn.pf_tid)
                        cmk = ccap.get("__maker") if ccap is not None else None
                        ctag = cmk.decode("latin-1") if isinstance(cmk, bytes) else (str(cmk) if cmk is not None else "")
                        cvm = getattr(self.dump, "vms", {}).get(ctag, self.vm)
                        wc = ClosureExpr(cproto, [])
                        wc.vm = cvm
                        self.children.append(wc)

        for n in undeclared:
            if id(n) in consumed_ids:
                continue
            loc = n["local"]["location"]
            sc = fn.env.lookup(loc)
            val = sc.vars[loc] if sc is not None else None
            p, _ = parent_map.get(id(n), (None, None))
            breg = _boxed_reg(val)
            if breg is not None:
                sk, ik, rnum = breg
                gp, _ = parent_map.get(id(p), (None, None)) if p else (None, None)
                if p and p.get("type") == "AstExprIndexExpr" and p["index"].get("type") == "AstExprConstantNumber":
                    pkv = int(p["index"]["value"])
                    if pkv == sk and gp and gp.get("type") == "AstExprIndexExpr" and gp.get("expr") is p:
                        self.captured_regs.add(rnum)
                        ups.append(Reg(rnum))
                        node_reps[id(gp)] = ("reg", rnum)
                        continue
                    if pkv == ik and gp and gp.get("type") == "AstExprIndexExpr" and gp.get("index") is p:
                        continue
                self.captured_regs.add(rnum)
                ups.append(Reg(rnum))
                node_reps[id(n)] = ("reg", rnum)
                continue
            if isinstance(val, LTable) and p and p.get("type") == "AstExprIndexExpr":
                idx_node = p.get("index", {})
                if idx_node.get("type") == "AstExprConstantNumber":
                    k = int(idx_node["value"])
                    item = val.get(k)
                    if item is None and val.tid in self.dump.lazy and val is not self.vmobj:
                        item = self.index(val, k, None)
                    if isinstance(item, Reg):
                        self.captured_regs.add(item.n)
                        ups.append(item)
                        node_reps[id(p)] = ("reg", item.n)
                        continue
                    if isinstance(item, MaybeBox):
                        gp, _ = parent_map.get(id(p), (None, None))
                        ggp, _ = parent_map.get(id(gp), (None, None)) if gp else (None, None)
                        if gp and gp.get("type") == "AstExprIndexExpr" and gp.get("expr") is p \
                                and gp["index"].get("type") == "AstExprConstantNumber" \
                                and ggp and ggp.get("type") == "AstExprIndexExpr":
                            other = ggp["index"] if ggp.get("expr") is gp else (ggp["expr"] if ggp.get("index") is gp else None)
                            oexpr = other.get("expr") if isinstance(other, dict) and other.get("type") == "AstExprIndexExpr" \
                                and other["index"].get("type") == "AstExprConstantNumber" else None
                            if isinstance(oexpr, dict) and oexpr.get("type") == "AstExprIndexExpr" \
                                    and oexpr.get("expr", {}).get("type") == "AstExprLocal" \
                                    and oexpr["expr"]["local"]["location"] == loc \
                                    and oexpr.get("index", {}).get("type") == "AstExprConstantNumber" \
                                    and int(oexpr["index"]["value"]) == k:
                                if ggp.get("expr") is gp:
                                    self.captured_regs.add(item.reg)
                                    ups.append(Reg(item.reg))
                                    node_reps[id(ggp)] = ("reg", item.reg)
                                continue
                        self.captured_regs.add(item.reg)
                        ups.append(Reg(item.reg))
                        node_reps[id(p)] = ("reg", item.reg)
                        continue
                    ibreg = _boxed_reg(item)
                    if ibreg is not None:
                        sk, ik, rnum = ibreg
                        gp, _ = parent_map.get(id(p), (None, None))
                        ggp, _ = parent_map.get(id(gp), (None, None)) if gp else (None, None)
                        if gp and gp.get("type") == "AstExprIndexExpr" and gp["index"].get("type") == "AstExprConstantNumber":
                            gkv = int(gp["index"]["value"])
                            if gkv == sk and ggp and ggp.get("type") == "AstExprIndexExpr" and ggp.get("expr") is gp:
                                self.captured_regs.add(rnum)
                                ups.append(Reg(rnum))
                                node_reps[id(ggp)] = ("reg", rnum)
                                continue
                            if gkv == ik and ggp and ggp.get("type") == "AstExprIndexExpr" and ggp.get("index") is gp:
                                continue
                    if isinstance(item, (Global, Builtin)):
                        node_reps[id(p)] = ("global", item.name)
                        continue
                    if isinstance(item, (int, float, bytes, bool)) or (item is None and k in val.h):
                        node_reps[id(p)] = ("const", item)
                        continue
            elif isinstance(val, LTable) and p and p.get("type") == "AstExprIndexName" and p.get("op") == ":":
                gp, _ = parent_map.get(id(p), (None, None))
                if gp and gp.get("type") == "AstExprCall" and gp.get("self") and gp.get("func") is p:
                    mfn = val.get(p["index"].encode("latin-1"))
                    mnode = mfn.node if isinstance(mfn, (OpaqueFn, LuaFunc)) else (mfn if isinstance(mfn, dict) else None)
                    mkind = _classify_vm_method(val, mnode)
                    cargs = gp.get("args") or []
                    if mkind == "unpack" and len(cargs) == 1:
                        node_reps[id(gp)] = ("unpack", cargs[0])
                        continue
                    if mkind == "setlist" and len(cargs) >= 2:
                        node_reps[id(gp)] = ("setlist", cargs)
                        continue
                    if mkind == "u32_trunc" and len(cargs) == 1:
                        node_reps[id(gp)] = ("u32_trunc", cargs[0])
                        continue
                    if mkind == "u32_mul" and len(cargs) == 2:
                        node_reps[id(gp)] = ("u32_mul", cargs)
                        continue
            elif isinstance(val, Reg):
                self.captured_regs.add(val.n)
                ups.append(val)
                node_reps[id(n)] = ("reg", val.n)
                continue
            elif isinstance(val, MaybeBox):
                gp, _ = parent_map.get(id(p), (None, None)) if p else (None, None)
                if p and p.get("type") == "AstExprIndexExpr" and p.get("expr") is n \
                        and p["index"].get("type") == "AstExprConstantNumber" \
                        and gp and gp.get("type") == "AstExprIndexExpr":
                    other = gp["index"] if gp.get("expr") is p else (gp["expr"] if gp.get("index") is p else None)
                    oexpr = other.get("expr") if isinstance(other, dict) and other.get("type") == "AstExprIndexExpr" \
                        and other["index"].get("type") == "AstExprConstantNumber" else None
                    if isinstance(oexpr, dict) and oexpr.get("type") == "AstExprLocal" \
                            and oexpr["local"]["location"] == loc:
                        if gp.get("expr") is p:
                            self.captured_regs.add(val.reg)
                            ups.append(Reg(val.reg))
                            node_reps[id(gp)] = ("reg", val.reg)
                        continue
                self.captured_regs.add(val.reg)
                ups.append(Reg(val.reg))
                node_reps[id(n)] = ("reg", val.reg)
                continue
            elif isinstance(val, (Global, Builtin)):
                node_reps[id(n)] = ("global", val.name)
                continue
            elif isinstance(val, (int, float, bytes, bool)):
                node_reps[id(n)] = ("const", val)
                continue
            return None

        proto = PlainProto(fn, node, [], lines, node_reps=node_reps)
        c = ClosureExpr(proto, ups)
        self.children.append(c)
        return c

    def plain_function_text(self, fn):
        """A self-contained plain Lua function (e.g. LPH_NO_VIRTUALIZE with no
        outer upvalues): formatted cleanly via luauast.Printer."""
        node = fn.node if not isinstance(fn, dict) else fn
        src_map = getattr(self.dump, "plain_src_by_node", {})
        lines = src_map.get(id(node)) if isinstance(node, dict) else None
        lines = lines or getattr(self.vm, "src_lines", None)
        if not isinstance(node, dict) or node.get("type") != "AstExprFunction" or not lines:
            return None
        declared = _declared_in(node)
        for n in iter_nodes(node):
            if n.get("type") == "AstExprLocal" and n["local"]["location"] not in declared:
                return None
        try:
            return LA.Printer("\t").expr(node, 0)
        except Exception:
            m = re.fullmatch(r"(\d+),(\d+) - (\d+),(\d+)", node["location"])
            if not m:
                return None
            l1, c1, l2, c2 = (int(x) for x in m.groups())
            if l1 == l2:
                return lines[l1][c1:c2]
            return "\n".join([lines[l1][c1:]] + lines[l1 + 1:l2] + [lines[l2][:c2]])

    def sym_binop(self, op, a, b):
        if isinstance(a, SymList) or isinstance(b, SymList):
            if op == "Eq":
                if not isinstance(a, SymList) or not isinstance(b, SymList):
                    return False
                return a is b
            if op == "Ne":
                if not isinstance(a, SymList) or not isinstance(b, SymList):
                    return True
                return a is not b
            raise Unsupported("arith on packed list")
        if a is b and isinstance(a, Bin) and a.op == "Mod":
            if op == "CompareNe":
                return False
            if op == "CompareEq":
                return True
        if op == "Sub" and isinstance(a, Bin) and a.op == "Mod" and isinstance(a.b, Const) and a.b.v == 4294967296:
            if isinstance(b, Bin) and b.op == "Mod" and b.a is a and isinstance(b.b, Const) and b.b.v == 1:
                res = Reg(a.a.n) if isinstance(a.a, Reg) else a.a
                res._u32_trunc = True
                return res
        return Bin(op, self.as_expr(a), self.as_expr(b))

    def sym_unop(self, op, a):
        if isinstance(a, SymList):
            if op == "Len":
                return a.count_expr()
            if op == "Not":
                return False
            raise Unsupported("unop on packed list")
        return Un(op, self.as_expr(a))

    def sym_and_or(self, kind, a, rhs):
        b = rhs()
        return Bin("And" if kind == "and" else "Or", self.as_expr(a), self.as_expr(b))

    def _need_jreg(self, *xs):
        if self.stack_base is not None:
            for x in xs:
                if isinstance(x, Expr):
                    for r in expr_regs(x):
                        if isinstance(r.n, int) and r.n > self.stack_base and r.n not in self.jump_regs:
                            self.need_jump_regs.add(r.n)

    def index(self, obj, key, it):
        if isinstance(obj, Multi):
            obj = obj.first()
        if isinstance(key, Multi):
            key = key.first()
        if isinstance(obj, RegFile):
            if isinstance(key, SymList):
                raise Unsupported("symbolic register index")
            if is_sym(key):
                arr = self.reg_array(key)
                if arr is None:
                    self._need_jreg(key)
                    raise Unsupported("symbolic register index")
                return Index(*arr)
            k = S.norm_key(key)
            if isinstance(k, (int, float)) and k < 1 and self.stack_base is not None:
                raise Unsupported("read below the stack VM's frame (register %s)" % k)
            if isinstance(k, (int, float)) and (k < 0 or (self.max_reg < k < 800000)) and self.stack_base is None:
                raise Unsupported("corrupt/encrypted register index %s" % k)
            if self.jvals.get(k) is FRAME:
                return obj
            if k in self.jvals:
                self.jread.add(k)
                return self.jvals[k]
            if k in self.packs:
                self.pack_read.add(k)
                c = self.pack_copies.get(k)
                if c is None:
                    src = self.packs[k]
                    c = SymList(src.items, src.tail, src.nkey)
                    c.extra = dict(src.extra)
                    self.pack_copies[k] = c
                return c
            r = Reg(k)
            r._gen = self.reg_gen.get(k, 0)
            return r
        if isinstance(obj, EnvTable):
            if isinstance(key, bytes):
                return Global(key.decode("latin-1"))
            return Index(Global("_ENV"), self.as_expr(key))
        if isinstance(obj, UpContainer):
            return Upval(obj.idx)
        if isinstance(obj, UpList):
            if not isinstance(key, int):
                raise Unsupported("upvalue index %r" % (key,))
            return obj.get(key)
        if isinstance(obj, FrameProxy):
            if not isinstance(key, int):
                raise Unsupported("symbolic index into a captured frame")
            self.frame_uses.add((obj.idx, key))
            return Upval((obj.idx, key))
        if isinstance(obj, OpenUps):
            if not isinstance(key, int):
                raise Unsupported("open upvalue index %r" % (key,))
            return MaybeBox(key)
        if isinstance(obj, MaybeBox):
            return None
        if isinstance(obj, BoxProxy):
            if is_sym(key):
                return Index(Upval(obj.idx), self.as_expr(key))
            return BoxPart(obj.idx, key)
        if isinstance(obj, BoxPart):
            if isinstance(key, BoxPart) and key.idx == obj.idx:
                return Upval(obj.idx)
            return Index(self.as_expr(obj), self.as_expr(key))
        if isinstance(obj, LTable):
            if is_sym(key) and obj is self.vmobj and isinstance(key, Index) and isinstance(key.key, Index) \
                    and key.key.obj == key.obj and isinstance(key.key.key, Const):

                return RuntimeMaker()
            if is_sym(key) and id(obj) in self.proto_arrays:
                rk = self._resolve_jval(key)
                if rk is not None:
                    key = rk
                else:
                    for r in expr_regs(key):
                        if isinstance(r.n, int) and r.n not in self.jump_regs:
                            self.need_jump_regs.add(r.n)
            if is_sym(key):
                if self.walk_only and any(isinstance(x, Missing) for x in walk_expr(key)):

                    return Missing(None)
                if os.environ.get("DEVIRT_TB"):
                    print("   table tid=%s path=%s items=%s" % (obj.tid, self.dump.paths().get(obj.tid), str(list(obj.h.items())[:12])), file=sys.stderr)
                raise Unsupported("symbolic index into a concrete VM table (key %s)" % fmt_expr(key))
            v = obj.get(key)
            if getattr(self, "_is_v14", False) and id(obj) in self.proto_arrays:
                pov = self.cur_proto_ov()
                if pov is not None and obj.tid is not None:
                    v = pov.get((id(obj), S.norm_key(key)), v)
            elif self.ov_base is not None and obj.tid is not None:
                v = self.cur_ov().get((id(obj), S.norm_key(key)), v)
            if v is None and (obj.tid, S.norm_key(key)) in self.dump.late:

                return self.dump.late[(obj.tid, S.norm_key(key))]
            if obj.tid in self.dump.lazy and isinstance(key, int) and self.ov_base is not None:

                k0 = obj.get(0)
                if not isinstance(k0, LTable):
                    for nk in (-1, -2, -3, -4):
                        cand = obj.get(nk)
                        if isinstance(cand, LTable) and id(cand) in self.proto_arrays:
                            k0 = cand
                            break
                if isinstance(k0, LTable):
                    base = k0.get(key)
                    k0_ov = self.cur_proto_ov() if (getattr(self, "_is_v14", False) and id(k0) in self.proto_arrays) else self.cur_ov()
                    cur = k0_ov.get((id(k0), key), base) if k0_ov is not None else base
                    if _differs(cur, base):
                        if not self._can_decode_const(obj, cur):
                            return Missing(key)
                        path = self.dump.paths().get(obj.tid)
                        if path is None:
                            self.dump.miss("override without path")
                            return Missing(key)
                        rq = ",".join(str(x) for x in path) + ",%d@%s" % (key, S.fmt_num(cur))
                        if self.dump.overrides.get(rq) is not None:
                            return self.dump.overrides[rq]
                        same = self.dump.same_operand(rq, obj.tid)
                        if same is not None:
                            return same
                        got = self.dump.fetch(rq)
                        if got is not None:
                            return got
                        if self.dump.fetcher is None:
                            self.requests.add(rq)

                        self.dump.miss("override failed" if rq in self.dump.overrides else "override requested")
                        return Missing(key)
            if v is None and obj.tid in self.dump.lazy and obj is not self.vmobj and isinstance(key, (int, bytes)):
                path = self.dump.paths().get(obj.tid)
                k = key.decode("latin-1") if isinstance(key, bytes) else key
                if path is not None and not (isinstance(k, str) and (k.isdigit() or "," in k or ";" in k)):
                    rq = ",".join(str(x) for x in path + [k])
                    if self.dump.overrides.get(rq) is not None:

                        return self.dump.overrides[rq]
                    k0 = obj.get(0)
                    if not isinstance(k0, LTable):
                        for nk in (-1, -2, -3, -4):
                            cand = obj.get(nk)
                            if isinstance(cand, LTable) and id(cand) in self.proto_arrays:
                                k0 = cand
                                break
                    if isinstance(k0, LTable) and isinstance(key, int):
                        k0_ov = self.cur_proto_ov() if (getattr(self, "_is_v14", False) and id(k0) in self.proto_arrays) else (self.cur_ov() if self.ov_base is not None else None)
                        op = k0_ov.get((id(k0), key), k0.get(key)) if k0_ov is not None else k0.get(key)
                    else:
                        op = None
                    if isinstance(key, int) and not self._can_decode_const(obj, op):
                        return Missing(key)
                    if type(op) in (int, float):
                        same = self.dump.same_operand("%d@%s" % (key, S.fmt_num(op)), obj.tid)
                        if same is not None:
                            return same
                    got = self.dump.fetch(rq)
                    if got is not None:
                        return got
                    if self.dump.fetcher is None:
                        self.requests.add(rq)
                if not self.making:
                    self.dump.miss("plain, path" if path is not None else "plain, no path")
                    if os.environ.get("DEVIRT_MISS"):
                        print("-- missing constant tid=%s slot=%r path=%r" % (obj.tid, key, path),
                              file=sys.stderr)
                    v = Missing(key)
            return v
        if isinstance(obj, SymList):
            return self.symlist_get(obj, key)
        if isinstance(obj, Expr):
            return Index(obj, self.as_expr(key))
        if obj is None:
            raise Unsupported("index nil")
        raise Unsupported("index %r" % (obj,))

    def _can_decode_const(self, obj, op):
        if not isinstance(op, (int, float)):
            return True
        if op < 0 or op > 1000000:
            return False
        for nk in (0, -1, -2, -3, -4):
            cand = obj.get(nk)
            if isinstance(cand, LTable):
                b5, t6 = cand.get(5), cand.get(6)
                b6, t7 = cand.get(6), cand.get(7)
                b_obj, k_tab = None, None
                if isinstance(b5, Buf) and isinstance(t6, LTable):
                    b_obj, k_tab = b5, t6
                elif isinstance(b6, Buf) and isinstance(t7, LTable):
                    b_obj, k_tab = b6, t7
                if b_obj is not None and k_tab is not None:
                    off = self.cur_ov().get((id(k_tab), op), k_tab.get(op)) if self.ov_base is not None else k_tab.get(op)
                    if isinstance(off, (int, float)) and (off < 0 or off >= len(b_obj.data)):
                        return False
        return True

    def symlist_get(self, lst, key):
        if key == lst.nkey or (lst.nkey is None and key == b"n"):
            return lst.count_expr()
        if isinstance(key, int) and key >= 1:
            if key <= len(lst.items):
                return lst.items[key - 1]
            if lst.tail is not None:
                return lst.tail.at(key - len(lst.items))
            return None
        if key in lst.extra:
            return lst.extra[key]
        if is_sym(key):
            return Index(self.as_expr(lst), self.as_expr(key))
        raise Unsupported("packed list index %r" % (key,))

    def newindex(self, obj, key, v, it):
        if isinstance(key, Multi):
            key = key.first()
        if isinstance(obj, RegFile):
            if isinstance(key, SymList):
                raise Unsupported("symbolic register store")
            if is_sym(key):
                arr = self.reg_array(key)
                if arr is None:
                    self._need_jreg(key)
                    raise Unsupported("symbolic register store")
                self.emit(Assign(Index(*arr), self.value_of(v)))
                return
            if isinstance(v, RegFile):
                self.jvals[S.norm_key(key)] = FRAME
                self.jread.discard(S.norm_key(key))
                return
            if isinstance(v, OpaqueFn) and v.pf_tid is not None:
                self.jvals[S.norm_key(key)] = v
                self.jread.discard(S.norm_key(key))
                return
            if isinstance(v, LTable) and (
                    id(v) in self.proto_arrays
                    or (-1 in v.h and isinstance(v.h.get(9), LTable))
                    or (v.h and all(isinstance(vv, OpaqueFn) for vv in v.h.values()))):
                self.jvals[S.norm_key(key)] = v
                self.jread.discard(S.norm_key(key))
                return
            if isinstance(key, (int, float)) and key < 1 and self.stack_base is not None:
                raise Unsupported("store below the stack VM's frame (register %s)" % key)
            if isinstance(key, (int, float)) and (key < 0 or (self.max_reg < key < 800000)) and self.stack_base is None:
                raise Unsupported("corrupt/encrypted register store %s" % key)
            self.emit(Assign(Reg(S.norm_key(key)), self.value_of(v)))
            return
        if isinstance(obj, FrameProxy):
            if not isinstance(key, int):
                raise Unsupported("symbolic store into a captured frame")
            self.frame_uses.add((obj.idx, key))
            self.emit(Assign(Upval((obj.idx, key)), self.value_of(v)))
            return
        if isinstance(obj, EnvTable):
            tgt = Global(key.decode("latin-1")) if isinstance(key, bytes) else Index(Global("_ENV"), self.as_expr(key))
            self.emit(Assign(tgt, self.value_of(v)))
            return
        if isinstance(obj, UpContainer):
            self.emit(Assign(Upval(obj.idx), self.value_of(v)))
            return
        if isinstance(obj, OpenUps):
            if v is None and isinstance(key, int):
                self.emit(Close(key))
            return
        if isinstance(obj, MaybeBox):
            return
        if isinstance(obj, BoxPart):
            if isinstance(key, BoxPart) and key.idx == obj.idx:
                self.emit(Assign(Upval(obj.idx), self.value_of(v)))
            else:
                self.emit(Assign(Index(self.as_expr(obj), self.as_expr(key)), self.value_of(v)))
            return
        if isinstance(obj, BoxProxy):
            self.emit(Assign(Index(Upval(obj.idx), self.as_expr(key)), self.value_of(v)))
            return
        if isinstance(obj, JitFrame) and obj.depth > 0:
            k = S.norm_key(key)
            if k == obj.link:
                raise Unsupported("store into an LPH_JIT loop stack link")
            pv = Pseudo("JIT%s" % k, obj.depth)
            self.emit(Assign(pv, self.value_of(v)))
            obj.h[k] = pv
            return
        if isinstance(obj, LTable):
            if id(obj) in self.proto_arrays:
                def _collect_out_regs(ex):
                    out_r = list(expr_regs(ex))
                    tmap = {st.t: st for st in self.out if isinstance(st, CallStmt)}
                    seen_t = set()
                    tqueue = [ex]
                    while tqueue:
                        cur = tqueue.pop()
                        if isinstance(cur, TempVal):
                            if cur.t not in seen_t and cur.t in tmap:
                                seen_t.add(cur.t)
                                cst = tmap[cur.t]
                                out_r.extend(expr_regs(cst.fn))
                                for ax in cst.args.items:
                                    out_r.extend(expr_regs(ax))
                                    tqueue.append(ax)
                        elif isinstance(cur, Bin):
                            tqueue.append(cur.a)
                            tqueue.append(cur.b)
                        elif isinstance(cur, Un):
                            tqueue.append(cur.a)
                        elif isinstance(cur, Index):
                            tqueue.append(cur.obj)
                            tqueue.append(cur.key)
                    return out_r
                if is_sym(key):
                    rk = self._resolve_jval(key)
                    if rk is not None:
                        key = rk
                    else:
                        for r in _collect_out_regs(key):
                            if isinstance(r.n, int) and r.n not in self.jump_regs:
                                self.need_jump_regs.add(r.n)
                if is_sym(v):
                    rv = self._resolve_jval(v)
                    if rv is not None:
                        v = rv
                    else:
                        for r in _collect_out_regs(v):
                            if isinstance(r.n, int) and r.n not in self.jump_regs:
                                self.need_jump_regs.add(r.n)
            if is_sym(key):
                raise Unsupported("symbolic key store into a concrete VM table")
            if id(obj) in self.proto_arrays:
                if is_sym(v):
                    self.out.clear()
                    raise Unsupported("symbolic value store into proto array")
                self.mutated = True
            if getattr(self, "_is_v14", False) and id(obj) in self.proto_arrays and obj.tid is not None:
                self.write_proto_ov((id(obj), S.norm_key(key)), v, obj.get(key))
                return
            if self.ov_base is not None and obj.tid is not None:

                self.write_ov((id(obj), S.norm_key(key)), v, obj.get(key))
                return
            obj.set(key, v)
            return
        if isinstance(obj, SymList):
            if key == lst_nkey(obj):
                return  
            if isinstance(key, int) and key >= 1:
                while len(obj.items) < key and obj.tail is None:
                    obj.items.append(None)
                if key <= len(obj.items):
                    obj.items[key - 1] = v
                    return
            obj.extra[key] = v
            return
        if isinstance(obj, Expr):
            self.emit(Assign(Index(obj, self.as_expr(key)), self.value_of(v)))
            return
        if obj is None:
            # `t[k] = v` where t never materialized at capture (a nil slot of
            # an uncaptured table): skip -- raising used to poison the walk
            return
        raise Unsupported("newindex %r" % (obj,))

    def cur_ov(self):
        return self.ov if self.ov is not None else self.ov_base

    def write_ov(self, key, v, base):
        if self.ov is None:
            self.ov = Overlay(self.ov_base)
        self.ov.set(key, v, base)

    def cur_proto_ov(self):
        return self.proto_ov if self.proto_ov is not None else self.proto_ov_base

    def write_proto_ov(self, key, v, base):
        if self.proto_ov is None:
            self.proto_ov = Overlay(self.proto_ov_base)
        self.proto_ov.set(key, v, base)

    def check_decision(self, cond):
        """A branch on a constant no decoder produced stops the walk here; the
        block becomes the dead guard branch the backend prunes."""
        if any(isinstance(x, Missing) for x in walk_expr(cond)):
            raise Unsupported("needs a constant that is not decoded yet")

    def value_of(self, v):
        """Value for an IR assignment: expressions, constants, closures, lists."""
        if isinstance(v, Multi):
            v = v.first()
        if isinstance(v, GenIterMaker):
            return GenIter(v.args)
        if isinstance(v, (ClosureExpr, GenIter)):
            return v
        if isinstance(v, LuaFunc) and isinstance(self.vm, JitModel):
            return self.jit_closure(v)
        if isinstance(v, SymList):
            return v
        if isinstance(v, LTable):
            if v is self.proto:

                raise VMCrash()
            if v is self.vmobj or id(v) in self.proto_arrays:
                return S.NewTable()
            if v.h:
                lib = self.library_name(v)
                if lib is not None:

                    return Global(lib)
                nkey = b"n"
                if all(isinstance(k, int) or k == nkey for k in v.h):
                    items = [self.value_of(v.h.get(i)) for i in range(1, max((k for k in v.h if isinstance(k, int)), default=0) + 1)]
                    return SymList(items, None, nkey=nkey if nkey in v.h else None)
                return self.table_ctor(v)
            return S.NewTable()
        if isinstance(v, RegFile):
            # the caller's register frame passed as a call argument
            # (`f(b, ...)`, v14.9's frame-holding decryptor calls)
            return FrameArg(0)
        return self.as_expr(v)

    def table_ctor(self, t):
        """A VM table with hash keys -> a table constructor (config-style
        tables the script builds at run time: `{url=..., method=...}`)."""
        stack = self.__dict__.setdefault("_tbl_stack", set())
        if id(t) in stack:
            raise Unsupported("cyclic VM table")
        stack.add(id(t))
        try:
            keys = sorted(t.h, key=lambda k: (not isinstance(k, int), k if isinstance(k, int) else repr(k)))
            # a leading 1..n run of ints renders positionally, the rest keyed
            n = 0
            while n < len(keys) and keys[n] == n + 1:
                n += 1
            items = [(None, self.value_of(t.h[k])) for k in keys[:n]]
            items += [(self.as_expr(k), self.value_of(t.h[k])) for k in keys[n:]]
            return S.NewTable(items)
        finally:
            stack.discard(id(t))

    def call_builtin(self, fn, args, it, stat):
        name = fn.name
        a = args
        if name in ("table.create",):
            if self.in_prologue:
                return RegFile()
            return LTable()
        if name == "getfenv":
            return EnvTable()
        if name == "setfenv":
            return Multi(a.items[:1])
        if name == "table.pack":
            return SymList(a.items, a.tail, nkey=b"n")
        if name in ("unpack", "table.unpack"):
            return self.unpack(a)
        if name == "table.move":
            return self.tmove(a)
        if name == "select":
            n = a.items[0] if a.items else None
            rest = Multi(a.items[1:], a.tail)
            if n == b"#":
                if rest.tail is None:
                    return len(rest.items)
                return TailCount(rest.tail) if not rest.items else Bin("Add", TailCount(rest.tail), Const(len(rest.items)))
            if isinstance(n, int):
                k = n - 1
                if k <= len(rest.items):
                    return Multi(rest.items[k:], rest.tail)
                return Multi([], rest.tail.drop(k - len(rest.items)) if rest.tail else None)
            raise Unsupported("select with %r" % (n,))
        if name == "coroutine.wrap":
            if a.items and isinstance(a.items[0], (ClosureExpr, Expr)):
                t = self.new_temp()
                self.emit(CallStmt(t, Global(name), Multi([self.value_of(x) for x in a.items], a.tail)))
                return Multi([], TempTail(t))
            return GenIterMaker()
        if name == "next" and a.items and isinstance(a.items[0], OpenUps):
            return None
        if name == "type" and len(a.items) == 1 and a.tail is None:
            x0 = a.items[0]
            if isinstance(x0, LTable):
                return b"table"
            if isinstance(x0, int) and not isinstance(x0, bool) and x0 >= 16384:
                return b"number"
        if name.startswith("buffer.") and a.items and isinstance(a.items[0], Buf) and self.ov_base is not None:
            r = self.buffer_op(name, a.items)
            if r is not NotImplemented:
                return r
        if name in S.CONCRETE:
            vset = getattr(self, "vreg_set", ())
            cfacts = getattr(self, "cur_facts", {})
            vals = []
            for x in a.items:
                if isinstance(x, Reg):
                    if x.n in vset and cfacts.get(x.n, (None,))[0] == "c":
                        vals.append(cfacts[x.n][1])
                        continue
                    if name == "bit32.bxor":
                        rv = self._resolve_jval(x)
                        if rv is not None:
                            vals.append(rv)
                            continue
                vals.append(x)
            if a.tail is not None or any(is_sym(x) or isinstance(x, (SymList, Multi)) for x in vals):
                if (name.startswith(("bit32.", "math.", "string.", "utf8.")) or name in ("tonumber",)) \
                        and a.tail is None and not any(isinstance(x, (SymList, Multi)) for x in vals):

                    t = self.new_temp()
                    self.emit(CallStmt(t, Global(name), Multi([self.value_of(x) for x in vals])))
                    return Multi([], TempTail(t))
                raise Unsupported("builtin %s on symbolic values" % name)
            try:
                r = S.CONCRETE[name](*vals)
            except (struct.error, IndexError, ValueError, TypeError, OverflowError) as ex:
                raise Unsupported("%s failed: %s" % (name, ex))
            return r
        t = self.new_temp()
        self.emit(CallStmt(t, Global(name), Multi([self.value_of(x) if not isinstance(x, SymList) else x
                                                   for x in a.items], a.tail)))
        return Multi([], TempTail(t))

    _BUF_FMT = {"i8": "<b", "u8": "<B", "i16": "<h", "u16": "<H", "i32": "<i", "u32": "<I", "f32": "<f", "f64": "<d"}

    def buffer_op(self, name, args):
        """All reads/writes of VM buffers go through the byte-level path overlay."""
        b = args[0] if args else None
        if not isinstance(b, Buf):
            return NotImplemented
        if name.startswith("buffer.read") and len(args) >= 2:
            k = name[len("buffer.read"):]
            if k == "string" and len(args) >= 3 and isinstance(args[1], (int, float)) and isinstance(args[2], (int, float)):
                off, ln = int(args[1]), int(args[2])
                if off < 0 or ln < 0 or off + ln > len(b.data):
                    raise Unsupported("%s failed: offset %d..%d out of range %d" % (name, off, off + ln, len(b.data)))
                ov = self.cur_ov()
                return bytes(ov.get((id(b), off + i), b.data[off + i]) for i in range(ln))
            f = self._BUF_FMT.get(k)
            if f is not None and isinstance(args[1], (int, float)):
                off = int(args[1])
                sz = struct.calcsize(f)
                if off < 0 or off + sz > len(b.data):
                    raise Unsupported("%s failed: offset %d..%d out of range %d" % (name, off, off + sz, len(b.data)))
                ov = self.cur_ov()
                raw = bytes(ov.get((id(b), off + i), b.data[off + i]) for i in range(sz))
                return S.fix_int(struct.unpack(f, raw)[0])
        if name.startswith("buffer.write") and len(args) >= 3:
            k = name[len("buffer.write"):]
            if k == "string" and isinstance(args[1], (int, float)) and isinstance(args[2], (bytes, bytearray)):
                off = int(args[1])
                data = bytes(args[2]) if len(args) < 4 else bytes(args[2][:int(args[3])])
                if off < 0 or off + len(data) > len(b.data):
                    raise Unsupported("%s failed: offset %d..%d out of range %d" % (name, off, off + len(data), len(b.data)))
                for i, byte_v in enumerate(data):
                    self.write_ov((id(b), off + i), byte_v, b.data[off + i])
                return Multi([])
            f = self._BUF_FMT.get(k)
            if f is not None and isinstance(args[1], (int, float)) and isinstance(args[2], (int, float)):
                off = int(args[1])
                sz = struct.calcsize(f)
                if off < 0 or off + sz > len(b.data):
                    raise Unsupported("%s failed: offset %d..%d out of range %d" % (name, off, off + sz, len(b.data)))
                v = args[2]
                if k.startswith(("u", "i")):
                    bits = sz * 8
                    v = int(v) & ((1 << bits) - 1)
                    if k.startswith("i") and v >= 1 << (bits - 1):
                        v -= 1 << bits
                raw = struct.pack(f, v)
                for i, byte_v in enumerate(raw):
                    self.write_ov((id(b), off + i), byte_v, b.data[off + i])
                return Multi([])
        return NotImplemented

    def _ov_keys(self):
        o = self.cur_ov()
        keys = set()
        while o is not None:
            keys |= set(o.d)
            o = o.parent
        return keys

    def _resolve_tail_bound(self, ex):
        if not isinstance(ex, Expr):
            return None
        found_tails = []
        def _ev(node):
            if isinstance(node, Const) and isinstance(node.v, int) and not isinstance(node.v, bool):
                return node.v
            if isinstance(node, TailCount) and isinstance(node.tail, (VarargTail, TempTail)):
                found_tails.append(node.tail)
                return 0
            if isinstance(node, Bin) and node.op in ("Add", "Sub"):
                lv = _ev(node.a)
                rv = _ev(node.b)
                if lv is not None and rv is not None:
                    return lv + rv if node.op == "Add" else lv - rv
            return None
        v0 = _ev(ex)
        if v0 is not None and len(found_tails) == 1:
            return (v0 + 1, found_tails[0])
        return None

    def unpack(self, a):
        t = a.items[0] if a.items else None
        i = a.items[1] if len(a.items) > 1 else 1
        j = a.items[2] if len(a.items) > 2 else None
        if self.stack_base is None:
            if is_sym(i):
                rv = self._resolve_jval(i)
                if rv is not None:
                    i = rv
            if is_sym(j):
                rv = self._resolve_jval(j)
                if rv is not None:
                    j = rv
        if isinstance(t, RegFile):
            if (isinstance(j, Reg) or type(j).__name__ == "PackTop") and j.n in self.packs:
                self.pack_read.add(j.n)
                j = self.packs[j.n]
            elif type(j).__name__ == "PackTop":
                j = max(0, j.n - 1)
            tb = self._resolve_tail_bound(j) if isinstance(i, int) else None
            if tb is not None:
                t_tail, tail_obj = tb
                if i <= t_tail:
                    return Multi([FrameArg(n) if self.jvals.get(n) is FRAME else Reg(n) for n in range(i, t_tail)], tail_obj)
                return Multi([], tail_obj.drop(i - t_tail) if tail_obj else None)
            if isinstance(i, int) and isinstance(j, SymList) and isinstance(j.nkey, int):
                t_tail = j.nkey
                if i <= t_tail:
                    return Multi([FrameArg(n) if self.jvals.get(n) is FRAME else Reg(n) for n in range(i, t_tail)], j.tail)
                return Multi([], j.tail.drop(i - t_tail) if j.tail else None)
            if not isinstance(i, int) or not isinstance(j, int):
                self._need_jreg(i, j)
                raise Unsupported("unpack registers with symbolic range")
            return Multi([FrameArg(n) if self.jvals.get(n) is FRAME else Reg(n) for n in range(i, j + 1)])
        if isinstance(t, SymList):
            if not isinstance(i, int) or i < 1 or i - 1 > len(t.items):
                raise Unsupported("unpack packed list from %r" % (i,))
            items = t.items[i - 1:]
            j_adj = (j - (i - 1)) if isinstance(j, int) else j
            if j_adj is None or is_sym(j_adj) or (isinstance(j_adj, int) and t.tail is not None and j_adj >= len(items)):
                if isinstance(j_adj, int) and t.tail is None:
                    return Multi(pad(items, j_adj))
                return Multi(items, t.tail)
            return Multi(pad(items, j_adj))
        if isinstance(t, LTable):
            if j is None:
                j = t.length()
            return Multi([t.get(n) for n in range(i, j + 1)])
        if isinstance(t, Expr):

            tt = self.new_temp()
            self.emit(CallStmt(tt, Global("table.unpack"),
                               Multi([self.value_of(x) if x is not None else Const(None) for x in a.items], a.tail)))
            return Multi([], TempTail(tt))
        raise Unsupported("unpack %r" % (t,))

    def tmove(self, a):
        src, f, e, t, dst = (a.items + [None] * 5)[:5]
        if dst is None:
            dst = src
        if self.stack_base is None:
            if is_sym(f):
                rv = self._resolve_jval(f)
                if rv is not None:
                    f = rv
            if is_sym(e):
                rv = self._resolve_jval(e)
                if rv is not None:
                    e = rv
            if is_sym(t):
                rv = self._resolve_jval(t)
                if rv is not None:
                    t = rv
        if isinstance(src, SymList) and src is dst:

            if f == 1 and isinstance(t, int) and 0 <= t - 1 <= 4096:
                src.items = [None] * (t - 1) + src.items
                return dst
            raise Unsupported("in-place move of packed list")
        if is_sym(f) or is_sym(t):
            self._need_jreg(f, t)
            raise Unsupported("table.move with symbolic positions")
        if (isinstance(e, Reg) or type(e).__name__ == "PackTop") and e.n in self.packs:
            self.pack_read.add(e.n)
            e = self.packs[e.n]
        elif type(e).__name__ == "PackTop":
            e = max(0, e.n - 1)
        tb_e = self._resolve_tail_bound(e) if isinstance(src, RegFile) and isinstance(f, int) and isinstance(dst, Expr) and isinstance(t, int) else None
        if tb_e is not None:
            t_tail, tail_obj = tb_e
            if f <= t_tail:
                items = [FrameArg(n) if self.jvals.get(n) is FRAME else Reg(n) for n in range(f, t_tail)]
                tail = tail_obj
            else:
                items = []
                tail = tail_obj.drop(f - t_tail) if tail_obj else None
            self.emit(SetList(dst, t, Multi(items, tail)))
            return dst
        if isinstance(src, RegFile) and isinstance(e, SymList) and isinstance(e.nkey, int) \
                and isinstance(f, int) and isinstance(dst, Expr) and isinstance(t, int):
            t_tail = e.nkey
            if f <= t_tail:
                items = [FrameArg(n) if self.jvals.get(n) is FRAME else Reg(n) for n in range(f, t_tail)]
                tail = e.tail
            else:
                items = []
                tail = e.tail.drop(f - t_tail) if e.tail else None
            self.emit(SetList(dst, t, Multi(items, tail)))
            return dst
        if isinstance(e, TailCount) and isinstance(src, SymList) and f == 1 and isinstance(dst, RegFile) and isinstance(t, int):
            for k, v in enumerate(src.items):
                self.put(dst, t + k, v)
            if src.tail is not None:
                self.pending_tail = (t + len(src.items), src.tail)
            return dst
        if is_sym(e) and isinstance(src, SymList) and f == 1 and isinstance(dst, Expr) and isinstance(t, int):

            self.emit(SetList(dst, t, Multi([self.value_of(x) if x is not None else Const(None) for x in src.items],
                                            src.tail)))
            return dst
        if is_sym(e) and isinstance(src, Expr) and isinstance(dst, Expr):

            tt = self.new_temp()
            self.emit(CallStmt(tt, Global("table.move"),
                               Multi([self.value_of(x) if x is not None else Const(None) for x in a.items])))
            return dst
        if is_sym(e):
            self._need_jreg(e)
            raise Unsupported("table.move with symbolic end")
        n = e - f + 1
        if not isinstance(n, int) or n < 0 or n > 4096:
            raise Unsupported("table.move count out of range: %s" % (n,))
        for k in range(n):
            v = self.elem(src, f + k)
            self.put(dst, t + k, v)
        return dst

    def elem(self, src, i):
        if isinstance(src, RegFile):
            return Reg(i)
        if isinstance(src, SymList):
            return self.symlist_get(src, i)
        if isinstance(src, LTable):
            return src.get(i)
        raise Unsupported("move from %r" % (src,))

    def put(self, dst, i, v):
        if isinstance(dst, RegFile):
            self.emit(Assign(Reg(i), self.value_of(v) if v is not None else Const(None)))
        elif isinstance(dst, Expr):
            self.emit(Assign(Index(dst, Const(i)), self.value_of(v) if v is not None else Const(None)))
        elif isinstance(dst, SymList):
            while len(dst.items) < i and dst.tail is None:
                dst.items.append(None)
            if i <= len(dst.items):
                dst.items[i - 1] = v
            else:
                raise Unsupported("store past a packed list's tail")
        elif isinstance(dst, LTable):
            dst.set(i, v)
        else:
            raise Unsupported("move into %r" % (dst,))

    def call_symbolic(self, fn, args, it, stat):
        if isinstance(fn, GenIterMaker):
            fn.args = args
            return Multi([])
        if isinstance(fn, RuntimeMaker):
            vals = args.items
            pi = self.vm.proto_index()
            return Multi([vals[pi] if len(vals) > pi else None])
        if isinstance(fn, OpaqueFn):
            if fn.pf_tid is not None and fn.pf_tid in self.dump.tables:
                if (len(args.items) == 4
                        and isinstance(args.items[0], LTable) and id(args.items[0]) in self.proto_arrays
                        and isinstance(args.items[1], LTable) and id(args.items[1]) in self.proto_arrays
                        and isinstance(args.items[2], int) and isinstance(args.items[3], int)):
                    t_arr, m_arr, s_idx, f_cnt = args.items
                    out = LTable()
                    out.h["_super_op"] = True
                    for idx in range(f_cnt):
                        v1 = self.index(t_arr, s_idx + idx, it)
                        v2 = self.index(m_arr, s_idx + idx, it)
                        if not isinstance(v1, int) or not isinstance(v2, int):
                            raise Unsupported("encrypted superinstruction operand")
                        base = idx * 4
                        out.set(base + 1, v1 // 16384)
                        out.set(base + 2, v1 % 16384)
                        out.set(base + 3, v2 // 32)
                        out.set(base + 4, v2 % 32)
                    return Multi([out])
                q_cand = args.items[0] if len(args.items) >= 1 and isinstance(args.items[0], LTable) else (
                    self.proto.get(12) if isinstance(self.proto, LTable) else None
                )
                if (len(args.items) == 3
                        and isinstance(q_cand, LTable)
                        and isinstance(q_cand.get(6), Buf)
                        and isinstance(q_cand.get(7), LTable)
                        and isinstance(args.items[1], int)
                        and isinstance(args.items[2], int)):
                    self._aead_decrypt_const(q_cand, args.items[1], args.items[2])
                    return Multi([True])
                if len(args.items) == 1 and isinstance(args.items[0], int) and not getattr(self.vm, "info", {}).get("curried3"):
                    return Multi([None])
                cap_fn = getattr(self.dump, "cap_by_self", {}).get(fn.pf_tid)
                mk_fn = cap_fn.get("__maker") if cap_fn is not None else None
                tag_fn = mk_fn.decode("latin-1") if isinstance(mk_fn, bytes) else (str(mk_fn) if mk_fn is not None else "")
                if tag_fn.startswith("plain:"):
                    pm = getattr(self.dump, "plain_makers", {}).get(tag_fn)
                    if pm is not None:
                        f3, f2, src_lines = pm
                        env3 = Scope()
                        for a in (f3.get("args") or []):
                            nm = a.get("name")
                            if nm and nm != "...":
                                env3.vars[a["location"]] = cap_fn.get(nm)
                        r = it.call_lua(LuaFunc(f2, env3), args)
                        src_map = self.dump.__dict__.setdefault("plain_src_by_node", {})
                        for x in r.items:
                            if isinstance(x, LuaFunc) and isinstance(x.node, dict):
                                src_map[id(x.node)] = src_lines
                        return r
                return self.make_curried_closure(fn, args)
            node = self.vm_fn_node(fn)
            if node is not None and node is self.vm.maker:
                return self.make_closure(args)
            target = getattr(self.vm, "siblings", {}).get(id(node)) if node is not None else None
            if target is not None:
                return self.make_closure(args, target)
            if node is not None:
                n_args = node.get("args") or ()
                if len(n_args) == 3 and not node.get("vararg") and len(args.items) >= 2 and isinstance(args.items[0], RegFile) and isinstance(args.items[1], int) and (
                        len(args.items) < 3 or args.items[2] is None or isinstance(args.items[2], int) or type(args.items[2]).__name__ == "PackTop" or (isinstance(args.items[2], Reg) and args.items[2].n in self.packs)):
                    if any(isinstance(sub, dict) and sub.get("type") == "AstExprConstantNumber" and sub.get("value") in (7997, 7998, 7999, 8000)
                           for sub in iter_nodes(node)):
                        return self.unpack(args)
                if not n_args and node.get("vararg") and args.tail is not None:
                    has_hash = any(isinstance(sub, dict) and sub.get("type") == "AstExprConstantString" and sub.get("value") in ("#", b"#")
                                   for sub in iter_nodes(node))
                    has_vtab = any(isinstance(sub, dict) and sub.get("type") == "AstExprTable"
                                   for sub in iter_nodes(node))
                    if has_hash and has_vtab:
                        cnt_e = TailCount(args.tail) if not args.items else Bin("Add", Const(len(args.items)), TailCount(args.tail))
                        return Multi([cnt_e, SymList(list(args.items), args.tail)])
                return it.call_lua(LuaFunc(node, Scope()), args)
            # No AST node: a closure the trace never instantiated through a
            # hooked maker (e.g. a plain, non-virtualized function kept in the
            # VM's constant pool). Fall through and render the call through
            # the SharedFn stub (luraph_runtimeN, defined as error(...)) --
            # raising here would abort the lift of everything else.

        if isinstance(fn, Multi):
            fn = fn.first()
        if isinstance(fn, (GenIterMaker,)):
            return Multi([])
        if self.walk_only and any(isinstance(x, Missing) for x in walk_expr(fn)):

            return Multi([Missing(None)])
        fe = self.as_expr(fn) if not isinstance(fn, (ClosureExpr,)) else fn
        t = self.new_temp()
        self.emit(CallStmt(t, fe, Multi([self.value_of(x) if not isinstance(x, SymList) else x
                                         for x in args.items], args.tail)))
        return Multi([], TempTail(t))

    def _aead_decrypt_const(self, q_tab, n_idx, m_key):
        buf_obj = q_tab.get(6)
        q7 = q_tab.get(7)
        if not isinstance(buf_obj, Buf) or not isinstance(q7, LTable):
            return
        done = getattr(self.dump, "_aead_done", None)
        if done is None:
            done = self.dump._aead_done = set()
            self.dump._fast_bw_delta = {}
            self.dump._fast_tw_delta = {}
        if (q_tab.tid, n_idx) in done:
            return
        ov = self.cur_ov()
        raw_off = ov.get((id(q7), n_idx), q7.get(n_idx)) if ov is not None else q7.get(n_idx)
        if not isinstance(raw_off, int):
            return
        arg3 = raw_off if raw_off < 134217728 else (raw_off ^ 529901011)
        data = buf_obj.data
        if arg3 < 0 or arg3 + 50 > len(data):
            return
        n92 = arg3 + 1
        v97 = data[n92]
        if v97 < 128:
            arg5, arg4 = v97, n92 + 1
        else:
            v98 = data[n92 + 1]
            if v98 < 128:
                arg5, arg4 = v97 * 128 + v98 - 16384, n92 + 2
            else:
                v99 = data[n92 + 2]
                if v99 < 128:
                    arg5, arg4 = v97 * 16384 + v98 + v99 * 128 - 2097280, n92 + 3
                else:
                    v100 = data[n92 + 3]
                    arg5 = v97 + v98 * 2097152 + v99 * 128 + v100 * 16384 - 268451968 + (266338304 if v100 >= 128 else 0)
                    arg4 = n92 + 4
        n2 = arg4 + arg5
        if arg5 < 1 or n2 + 48 > len(data):
            return
        s1 = bytes.fromhex("e9f3e2dbb9d8afca1cdfbd40c1b4e9ef")
        s2 = bytes.fromhex("dacea79868cfeb2821f63ab34ce8463e")
        s3 = bytes.fromhex("3434f49ddbbd6643e274e612eb48ff65")
        v16 = struct.pack("<3I", n_idx & 0xFFFFFFFF, m_key & 0xFFFFFFFF, 3)
        hdr_ct_nonce = bytes(data[arg3:n2 + 16])
        tag32 = bytes(data[n2 + 16:n2 + 48])
        cands = getattr(self.dump, "_aead_keys", None)
        if cands is None:
            cands = []
            for t in self.dump.tables.values():
                for val in t.h.values():
                    if isinstance(val, bytes) and len(val) == 32 and val not in cands:
                        cands.append(val)
            self.dump._aead_keys = cands
        matched_key = None
        for k32 in cands:
            kmac = hmac.new(k32, s1 + v16, hashlib.sha256).digest()
            if hmac.new(kmac, s2 + v16 + hdr_ct_nonce, hashlib.sha256).digest() == tag32:
                matched_key = k32
                break
        if matched_key is None:
            return
        done.add((q_tab.tid, n_idx))
        v18 = hmac.new(matched_key, s3 + v16 + hdr_ct_nonce[arg5 + (arg4 - arg3):], hashlib.sha256).digest()
        kw = struct.unpack("<8I", v18)
        paths = self.dump.paths()
        b_info = self.dump.buf_loc.get(id(buf_obj))
        b_path = ",".join(str(x) for x in paths[b_info[1]]) if b_info and b_info[1] in paths else None
        b_key = b_info[2] if b_info else 6
        fbw = self.dump._fast_bw_delta
        for off in range(0, arg5, 64):
            ctr = (off // 64 + 1) & 0xFFFFFFFF
            st = [0x61707865, 0x3320646e, 0x79622d32, 0x6b206574,
                  kw[0], kw[1], kw[2], kw[3], kw[4], kw[5], kw[6], kw[7],
                  ctr, 0, 0, 0]
            w = list(st)
            for _ in range(10):
                for a, b, c, d in ((0,4,8,12),(1,5,9,13),(2,6,10,14),(3,7,11,15),
                                   (0,5,10,15),(1,6,11,12),(2,7,8,13),(3,4,9,14)):
                    w[a] = (w[a] + w[b]) & 0xFFFFFFFF; x = w[d] ^ w[a]; w[d] = ((x << 16) & 0xFFFFFFFF) | (x >> 16)
                    w[c] = (w[c] + w[d]) & 0xFFFFFFFF; x = w[b] ^ w[c]; w[b] = ((x << 12) & 0xFFFFFFFF) | (x >> 20)
                    w[a] = (w[a] + w[b]) & 0xFFFFFFFF; x = w[d] ^ w[a]; w[d] = ((x << 8) & 0xFFFFFFFF) | (x >> 24)
                    w[c] = (w[c] + w[d]) & 0xFFFFFFFF; x = w[b] ^ w[c]; w[b] = ((x << 7) & 0xFFFFFFFF) | (x >> 25)
            ks = struct.pack("<16I", *(((w[i] + st[i]) & 0xFFFFFFFF) for i in range(16)))
            lim = min(64, arg5 - off)
            for i in range(lim):
                pos = arg4 + off + i
                data[pos] ^= ks[i]
        if b_path is not None:
            fbw[(b_path, b_key, arg4)] = bytes(data[arg4:arg4 + arg5])
        q7.h[n_idx] = arg3
        if q7.tid in paths:
            self.dump._fast_tw_delta[(",".join(str(x) for x in paths[q7.tid]), n_idx)] = arg3
        self.mutated = True

    def vm_fn_node(self, fn):
        return fn.node

    def make_curried_closure(self, fn, args):
        proto = self.dump.tables[fn.pf_tid]
        cap = getattr(self.dump, "cap_by_self", {}).get(fn.pf_tid)
        cvm = self.vm
        if cap is not None and cap.get("__maker") is not None:
            mk = cap["__maker"]
            tag = mk.decode("latin-1") if isinstance(mk, bytes) else str(mk)
            cvm = getattr(self.dump, "vms", {}).get(tag, self.vm)
        vals = args.items
        ups = next((v for v in vals if isinstance(v, LTable)), None)
        entries = []
        if isinstance(ups, LTable):
            for i in range(1, ups.length() + 1):
                entries.append(ups.get(i))
        c = ClosureExpr(proto, entries)
        c.vm = cvm
        c.shared_cap = getattr(self.dump, "shared_cap", None)
        for e in entries:
            if isinstance(e, MaybeBox):
                self.captured_regs.add(e.reg)
            if isinstance(e, LTable):
                for v in e.h.values():
                    if isinstance(v, int) and any(isinstance(x, RegFile) for x in e.h.values()):
                        self.captured_regs.add(v)
        self.children.append(c)
        return c

    def make_closure(self, args, vm=None):
        """A VM closure of the proto in args; vm: the interpreter (VMModel)
        whose maker was called, when it is not this proto's."""
        vals = args.items
        vm = vm or self.vm
        if vm.info.get("mode") == "dispatch_local":
            # this build's factory takes (state table, flag): the state table
            # IS the child's proto container (V/U/Q/... slots). A table the
            # capture ran through maps to its own capture; a table the run
            # built but never called still carries the child's decoded arrays
            # in its slots, so it lifts straight from the state table
            st = vals[0] if vals and isinstance(vals[0], LTable) else None
            cap = self.dump.cap_by_state.get(st.tid) if st is not None else None
            proto = cap["self"] if cap is not None and isinstance(cap.get("self"), LTable) else st
            if proto is not None:
                c = ClosureExpr(proto, [])
                c.vm = vm
                c.state_table = st
                c.shared_cap = self.dump.shared_cap
                self.children.append(c)
                return c
        pi, ui = vm.proto_index(), vm.upvals_index()
        proto = vals[pi] if len(vals) > pi else None
        ups = vals[ui] if len(vals) > ui else None
        if not isinstance(proto, LTable) and vals and isinstance(vals[0], LTable) and vals[0] is not self.vmobj:
            # v14.9's closure op calls the maker positionally as
            # (proto, upvals): `S[60](v, y)` -- the model's proto index points
            # at the wrong slot for that convention. The proto table doubles
            # as the child's VM state (k[3] = register count, k[6] = its
            # instruction arrays), so the child lifts from it directly.
            proto = vals[0]
            ups = vals[1] if len(vals) > 1 else None
            v149_proto_state = True
        else:
            v149_proto_state = False
        if self.walk_only and not isinstance(proto, LTable) and \
                any(isinstance(x, Missing) for x in walk_expr(proto)):

            return Missing(None)
        if not isinstance(proto, LTable):
            if os.environ.get("DEVIRT_MC_DEBUG"):
                desc = []
                dump = self.dump
                for i, v in enumerate(vals):
                    extra = ""
                    if isinstance(v, LTable):
                        ks = sorted((repr(k)[:20], repr(x)[:24]) for k, x in list(v.h.items())[:24])
                        pid = dump.pid_of_table.get(v.tid) if v.tid is not None else None
                        extra = " tid=%r pid=%r keys=%s" % (v.tid, pid, ks)
                    desc.append("%d=%s:%s%s" % (i, type(v).__name__, repr(v)[:50], extra))
                print("[mc] non-proto closure pi=%d ui=%d vals[%d]: %s"
                      % (pi, ui, len(vals), " | ".join(desc)), file=sys.stderr)
                print("[mc] last_op=%r mode=%r pc=%r misses=%r lazy_tids(paths)=%s"
                      % (getattr(self, "last_op", None), getattr(self, "cur_mode", None),
                         getattr(self, "cur_pc", None), dict(dump.misses),
                         {t: dump.paths().get(t) for t in list(dump.lazy)[:12]}), file=sys.stderr)
            raise Unsupported("closure of non-proto")
        entries, upval_base = self._extract_upvals_table(ups)
        c = ClosureExpr(proto, entries)
        c.upval_base = upval_base
        if isinstance(ups, LTable):
            c._ups_tbl = ups
        c.vm = vm
        if v149_proto_state:
            # the child's VM state is its own proto table (see above)
            c.state_table = proto
        self._note_captured_upvals(entries)
        self.children.append(c)
        return c

    def _extract_upvals_table(self, ups):
        if not isinstance(ups, LTable) or not ups.h:
            return [], 1
        int_keys = [k for k in ups.h if isinstance(k, int) and not isinstance(k, bool)]
        if getattr(self, "_is_v14", False):
            # Luraph v14 upvalue tables are 0-based; key 0 is simply absent
            # when that upvalue was nil at closure creation, so the
            # presence test below would shift every index by one.
            if int_keys:
                m = max(int_keys)
                return [ups.get(i) for i in range(0, m + 1)], 0
            return [], 0
        if int_keys and 0 in ups.h:
            m = max(int_keys)
            return [ups.get(i) for i in range(0, m + 1)], 0
        return [ups.get(i) for i in range(1, ups.length() + 1)], 1

    def _note_captured_upvals(self, entries):
        for e in entries:
            if isinstance(e, MaybeBox):
                self.captured_regs.add(e.reg)
            if isinstance(e, LTable):
                for v in e.h.values():
                    if isinstance(v, int) and any(isinstance(x, RegFile) for x in e.h.values()):
                        self.captured_regs.add(v)

    def finalize_step_closures(self):
        for c in self.children:
            ups = getattr(c, "_ups_tbl", None)
            if isinstance(ups, LTable) and not c.upvals and ups.h:
                entries, upval_base = self._extract_upvals_table(ups)
                c.upvals[:] = entries
                c.upval_base = upval_base
                self._note_captured_upvals(entries)

def lst_nkey(lst):
    return lst.nkey if lst.nkey is not None else b"n"

def pad(items, n):
    items = list(items[:n])
    while len(items) < n:
        items.append(None)
    return items

