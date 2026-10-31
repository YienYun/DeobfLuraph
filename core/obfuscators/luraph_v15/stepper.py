"""Luraph v15 handler symbolic stepper, inline JIT loop lifter, and decision-tree builder."""
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
from obfuscators.luraph_v15.dataflow import BoxProxy, BoxPart, FrameProxy, UpList
from obfuscators.luraph_v15.vm_model import Overlay, PackTop, State, VMCrash, VMModel, iter_nodes

class GenIterMaker:
    """coroutine.wrap(helper) of Luraph's generic-for: called once with
    (vm, f, s, ctl); then stored as the loop state and called per iteration."""

    def __init__(self):
        self.args = None

class _AccessLog(dict):
    """A scope's variables that remember which ones were read before being
    written, and which were written (Stepper.carry)."""
    __slots__ = ("read_first", "written")

    def __init__(self, *a):
        super().__init__(*a)
        self.read_first = set()
        self.written = set()

    def __getitem__(self, k):
        if k not in self.written:
            self.read_first.add(k)
        return dict.__getitem__(self, k)

    def get(self, k, default=None):
        if dict.__contains__(self, k):
            if k not in self.written:
                self.read_first.add(k)
            return dict.__getitem__(self, k)
        return default

    def __setitem__(self, k, v):
        self.written.add(k)
        dict.__setitem__(self, k, v)

def _disp_fetch_expr(w):
    body = w.get("body", {}).get("body") or ()
    for st in body[:2]:
        if st.get("type") not in ("AstStatLocal", "AstStatAssign"):
            continue
        for vl in st.get("values") or ():
            v = vl
            while v.get("type") == "AstExprGroup":
                v = v["expr"]
            if v.get("type") == "AstExprIndexExpr":
                e, idx = v["expr"], v["index"]
                while e.get("type") == "AstExprGroup":
                    e = e["expr"]
                while idx.get("type") == "AstExprGroup":
                    idx = idx["expr"]
                if e.get("type") == "AstExprLocal" and idx.get("type") == "AstExprLocal":
                    return v
    head = body[0]["values"][0]
    while head.get("type") == "AstExprGroup":
        head = head["expr"]
    return head

class Stepper:
    def __init__(self, vm, lifter):
        self.vm = vm
        self.lf = lifter
        cs = lifter.initial_state()
        self.cs = cs

        self.loops = []
        self.first_init = []
        for i, st in enumerate(vm.inner_body):
            if st["type"] == "AstStatIf":
                tb = st["thenbody"]["body"]
                for j, sub in enumerate(tb):
                    if sub["type"] in ("AstStatWhile", "AstStatRepeat") and vm.is_dispatch(sub):
                        if not self.loops and j > 0:
                            self.first_init = tb[:j]
                        self.loops.append((i, st, sub))
                        break
        self.mode_decl = None
        self.mode_init_decl = None
        if not self.loops:

            for i, st in enumerate(vm.inner_body):
                if st["type"] in ("AstStatWhile", "AstStatRepeat") and vm.is_dispatch(st):
                    self.loops.append((i, None, st))
                    break
        if not self.loops:
            raise Unsupported("no dispatch loops in the VM function")
        w = self.loops[0][2]
        head = _disp_fetch_expr(w)
        idx_expr = head["index"]
        while idx_expr.get("type") == "AstExprGroup":
            idx_expr = idx_expr["expr"]
        pcname = idx_expr["local"]
        self.pc_decl = pcname["location"]

        self.conds = {}
        for i, st, _ in self.loops:
            if st is None:
                continue
            cond = st["condition"]
            if cond["type"] == "AstExprLocal":
                cond = self._local_value(cond["local"]["location"], i) or cond
            self.conds[i] = cond
            if cond["type"] == "AstExprBinary":
                mv = cond["left"] if cond["left"]["type"] == "AstExprLocal" else cond["right"]
                if self.mode_init_decl is None:
                    self.mode_init_decl = mv["local"]["location"]
                self.mode_decl = mv["local"]["location"]
        self.first_inner = self.loops[0][0]
        self.gov = Overlay()
        self.gov_ver = 0

        self._detect_regfile()
        self._fix_vararg_pointers()

        self.carry = set()
        self.vreg_of = {}
        self.vreg_init = {}
        self.last_written_val = {}
        self.lf.vreg_set = set()
        self.lf.cur_facts = {}
        self.read_first = set()
        self.written = set()
        self.not_carried = set()
        self.new_carry = False
        self.fixed_decls = {d for d in (self.pc_decl, self.mode_decl, vm.kstack_key) if d}
        for _, _, lw in self.loops:
            lbody = lw.get("body", {}).get("body") or ()
            for st0 in lbody[:2]:
                if st0.get("type") in ("AstStatAssign", "AstStatLocal"):
                    for vr in st0.get("vars", ()):
                        loc = vr.get("local", vr).get("location")
                        if loc:
                            self.fixed_decls.add(loc)
            for n in iter_nodes(lw):
                if n.get("type") == "AstStatLocal":
                    for vr in n.get("vars", ()):
                        loc = vr.get("location")
                        if loc:
                            self.fixed_decls.add(loc)
        self.sp_cands = self._stack_pointer_candidates()
        self._strip_save_restore()
        self._init_vregs()
        if not hasattr(vm, "_mode_loop_cache"):
            vm._mode_loop_cache = {}
        self._mode_loop_cache = vm._mode_loop_cache

    def _strip_save_restore(self):
        """Neutralize Luraph's fake save/restore wrappers (`local l = I; ... I = l`)
        where `l` is never read except to restore `I`, preventing scratch locals
        from being misclassified as cross-instruction carried state."""
        if getattr(self.vm, "_sr_stripped", False):
            return
        self.vm._sr_stripped = True
        valueless_locs = set()
        for st0 in self.vm.inner_body[:self.first_inner]:
            if st0.get("type") == "AstStatLocal" and not st0.get("values"):
                for vr in st0.get("vars", ()):
                    if vr.get("location"):
                        valueless_locs.add(vr["location"])
        for _, _, w in self.loops:
            save_temps = {}
            for n in iter_nodes(w):
                if n.get("type") == "AstStatLocal":
                    for vr, vl in zip(n.get("vars", ()), n.get("values", ())):
                        if (vl.get("type") == "AstExprLocal"
                                and vr.get("location") != vl["local"]["location"]
                                and vl["local"]["location"] in valueless_locs):
                            save_temps[vr["location"]] = vl["local"]["location"]
            if not save_temps:
                continue
            total_reads = {}
            restore_reads = {}
            for n in iter_nodes(w):
                t = n.get("type")
                if t == "AstExprLocal":
                    loc = n["local"]["location"]
                    if loc in save_temps:
                        total_reads[loc] = total_reads.get(loc, 0) + 1
                elif t == "AstStatAssign":
                    for vr, vl in zip(n.get("vars", ()), n.get("values", ())):
                        if vr.get("type") == "AstExprLocal" and vl.get("type") == "AstExprLocal":
                            vloc = vl["local"]["location"]
                            if vloc in save_temps and vr["local"]["location"] == save_temps[vloc]:
                                restore_reads[vloc] = restore_reads.get(vloc, 0) + 1
            pure_sr = {
                vloc: kloc for vloc, kloc in save_temps.items()
                if total_reads.get(vloc, 0) > 0 and total_reads.get(vloc, 0) == restore_reads.get(vloc, 0)
                and kloc not in self.sp_cands and kloc not in self.fixed_decls
            }
            if not pure_sr:
                continue
            for n in iter_nodes(w):
                t = n.get("type")
                if t == "AstStatLocal":
                    vals = n.get("values")
                    if vals:
                        for idx, (vr, vl) in enumerate(zip(n.get("vars", ()), vals)):
                            if vr.get("location") in pure_sr and vl.get("type") == "AstExprLocal":
                                vals[idx] = {"type": "AstExprConstantNil"}
                elif t == "AstStatAssign":
                    vrs = n.get("vars")
                    vls = n.get("values")
                    if vrs and vls:
                        for idx, (vr, vl) in enumerate(zip(vrs, vls)):
                            if vr.get("type") == "AstExprLocal" and vl.get("type") == "AstExprLocal":
                                vloc = vl["local"]["location"]
                                if vloc in pure_sr and vr["local"]["location"] == pure_sr[vloc]:
                                    vrs[idx] = vl

    def _init_vregs(self):
        return
        cache = self.vm.__dict__.setdefault("_static_vregs", {})
        if None not in cache:
            _, inner = self._fresh_scopes(None, S.Interp(self.lf))
            self.lf.out = []
            regfiles = set()
            sc = inner
            while sc is not None:
                for k, v in sc.vars.items():
                    if isinstance(v, RegFile):
                        regfiles.add(k)
                sc = sc.parent
            reads, reg_writes, other_writes = set(), set(), set()
            for _, _, w in self.loops:
                for n in iter_nodes(w):
                    t = n.get("type")
                    if t == "AstExprLocal":
                        reads.add(n["local"]["location"])
                    elif t == "AstStatAssign":
                        for vr, vl in zip(n.get("vars", []), n.get("values", [])):
                            if vr.get("type") == "AstExprLocal":
                                loc = vr["local"]["location"]
                                if (vl.get("type") == "AstExprIndexExpr"
                                        and vl.get("expr", {}).get("type") == "AstExprLocal"
                                        and vl["expr"]["local"]["location"] in regfiles):
                                    reg_writes.add(loc)
                                else:
                                    other_writes.add(loc)
                    elif t == "AstStatCompoundAssign":
                        var = n.get("var")
                        if isinstance(var, dict) and var.get("type") == "AstExprLocal":
                            other_writes.add(var["local"]["location"])
            cands = ((reg_writes - other_writes) & reads & set(inner.vars)) - self.sp_cands - self.fixed_decls
            cache[None] = sorted(cands)
        for loc in cache[None]:
            if loc not in self.vreg_of:
                vreg = 800000 + len(self.vreg_of) + 1
                self.vreg_of[loc] = vreg
                self.lf.vreg_set.add(vreg)

    def _cross_handler_temps(self):
        """Dispatch temps (declared valueless in the loop function) that some
        handler reads and some handler writes: their values live across
        instruction boundaries in this build."""
        reads, writes = set(), set()
        for _, _, w in self.loops:
            for n in iter_nodes(w):
                t = n.get("type")
                if t == "AstExprLocal":
                    reads.add(n["local"]["location"])
                elif t == "AstStatLocal":
                    for v in n.get("vars", []):
                        writes.add(v["location"])
                elif t == "AstStatAssign":
                    for v in n.get("vars", []):
                        if v.get("type") == "AstExprLocal":
                            writes.add(v["local"]["location"])
                elif t == "AstStatCompoundAssign":
                    var = n.get("var")
                    if isinstance(var, dict) and var.get("type") == "AstExprLocal":
                        writes.add(var["local"]["location"])
        out = set()
        for st in self.vm.inner_body[:self.first_inner]:
            if st.get("type") != "AstStatLocal" or st.get("values"):
                continue
            for v in st.get("vars", []):
                k = v["location"]
                if k in reads and k in writes:
                    out.add(k)
        return out

    def _fix_vararg_pointers(self):
        """The prologue places the entry varargs with a VM runtime helper
        (`local w,W = S[59](...)`) the walk cannot evaluate (a stub call). At
        closure entry the multret region is empty: the pointer local is 0 and
        the value table empty, which is all the split handlers need."""
        for st in self.vm.prologue:
            if st.get("type") != "AstStatLocal":
                continue
            vals = st.get("values", [])
            if len(vals) != 1 or vals[0].get("type") != "AstExprCall":
                continue
            call = vals[0]
            args = call.get("args", [])
            if len(args) != 1 or args[0].get("type") != "AstExprVarargs":
                continue
            vars_ = st.get("vars", [])
            if len(vars_) != 2:
                continue
            vd, wd = vars_[0]["location"], vars_[1]["location"]
            if isinstance(self.cs.vars.get(vd), TempVal):
                self.cs.vars[vd] = 0
            if isinstance(self.cs.vars.get(wd), TempVal):
                self.cs.vars[wd] = LTable()

    def _detect_regfile(self):
        """v14.9 builds create the register file with a VM runtime helper call
        in the prologue (`local b = S[32](w)` -- a plain function behind a
        state-table slot), not a direct table.create(), so the walk sees a
        stub call. Detect the prologue local the handlers use as the register
        array -- element calls `b[v](...)`, numeric stores `b[...]=...`,
        regfile copies `p=(b)` -- and model it as a RegFile."""
        cands = {k for k, v in self.cs.vars.items() if isinstance(v, TempVal)}
        if not cands:
            return
        calluse, storeuse, copysrc = set(), set(), set()
        for _, _, w in self.loops:
            for n in iter_nodes(w):
                t = n.get("type")
                if t == "AstExprCall":
                    f = n.get("func")
                    if isinstance(f, dict) and f.get("type") == "AstExprIndexExpr" \
                            and f.get("expr", {}).get("type") == "AstExprLocal":
                        calluse.add(f["expr"]["local"]["location"])
                elif t in ("AstStatAssign", "AstStatCompoundAssign"):
                    vs = n.get("vars") if t == "AstStatAssign" else [n.get("var")]
                    for var in vs:
                        if isinstance(var, dict) and var.get("type") == "AstExprIndexExpr" \
                                and var.get("expr", {}).get("type") == "AstExprLocal":
                            storeuse.add(var["expr"]["local"]["location"])
                    if t == "AstStatAssign":
                        for val in n.get("values", []):
                            if isinstance(val, dict) and val.get("type") == "AstExprLocal":
                                copysrc.add(val["local"]["location"])
                elif t == "AstStatLocal":
                    for val in n.get("values", []):
                        if isinstance(val, dict) and val.get("type") == "AstExprLocal":
                            copysrc.add(val["local"]["location"])
        hits = [k for k in cands if k in calluse and (k in storeuse or k in copysrc)]
        if len(hits) != 1:
            return
        self.cs.vars[hits[0]] = RegFile()

    def _stack_pointer_candidates(self):
        """Prologue locals the handlers use directly as a register index
        (`R[M]`): only these can be a stack pointer. (A register VM's
        multret top is carried too, but the lifter models it otherwise.)"""

        cache = self.vm.__dict__.setdefault("_sp_cands", {})
        if None not in cache:

            pairs = set()
            for _, _, w in self.loops:
                for n in iter_nodes(w):
                    if n.get("type") == "AstExprIndexExpr" and n["expr"].get("type") == "AstExprLocal" \
                            and n["index"].get("type") == "AstExprLocal":
                        pairs.add((n["expr"]["local"]["location"], n["index"]["local"]["location"]))
            cache[None] = pairs
        _, inner = self._fresh_scopes(None, S.Interp(self.lf))
        self.lf.out = []
        regfiles = set()
        sc = inner
        while sc is not None:
            for k, v in sc.vars.items():
                if isinstance(v, RegFile):
                    regfiles.add(k)
            sc = sc.parent
        return {i for r, i in cache[None] if r in regfiles} & set(inner.vars)

    def _local_value(self, loc, before):
        """The expression a local of the loop function is declared or last assigned with."""
        for st in reversed(self.vm.inner_body[:before]):
            if st["type"] == "AstStatLocal":
                for k, v in enumerate(st["vars"]):
                    if v["location"] == loc and k < len(st["values"]):
                        return st["values"][k]
            elif st["type"] == "AstStatAssign":
                for k, v in enumerate(st["vars"]):
                    if v.get("type") == "AstExprLocal" and v["local"]["location"] == loc and k < len(st["values"]):
                        return st["values"][k]
        return None

    def _sp_value(self, locs):
        """The (int) stack-pointer value among the carried locals, if any."""
        cands = getattr(self, "sp_cands", None)
        ints = [v for k, v in locs if (cands is None or k in cands) and isinstance(v, int) and not isinstance(v, bool)]
        return ints[0] if ints else None

    def initial(self):
        if not hasattr(self, "_init_scope_vars"):
            self._init_scope_vars = []
            sc = self.cs
            while sc is not None:
                self._init_scope_vars.append((sc, dict(sc.vars)))
                sc = sc.parent
        else:
            for sc, vdict in self._init_scope_vars:
                sc.vars = dict(vdict)
            self.gov = Overlay()
            self.gov_ver = 0
        it = S.Interp(self.lf)
        cs, inner = self._fresh_scopes(None, it)
        for k, vreg in self.vreg_of.items():
            iv = inner.vars.get(k)
            if isinstance(iv, (int, float, bytes, bool)) or iv is None:
                self.vreg_init[vreg] = iv
        pc = inner.lookup(self.pc_decl).vars[self.pc_decl]
        mode = inner.lookup(self.mode_decl).vars[self.mode_decl] if self.mode_decl else 0
        ks = inner.lookup(self.vm.kstack_key) if self.vm.kstack_key else None
        locs = self._carried(inner)
        if locs:
            sb = self._sp_value(locs)
            if sb is not None:
                self.lf.stack_base = sb
                for k, vreg in list(self.vreg_of.items()):
                    if self.vreg_init.get(vreg) is None:
                        del self.vreg_of[k]
                        self.lf.vreg_set.discard(vreg)
                    else:
                        self.lf.jump_regs.add(vreg)
                        self.lf.cff_regs.add(vreg)
        init_jr = tuple(sorted(
            (vr, iv) for vr, iv in self.vreg_init.items()
            if vr in self.lf.vreg_set and vr in self.lf.jump_regs and iv is not None
        ))
        return State(mode, pc, ks.vars[self.vm.kstack_key] if ks else None, jregs=init_jr, locs=locs)

    @staticmethod
    def _v14_carryable_expr(v, max_nodes=8):
        if not isinstance(v, (Index, Bin, Un)):
            return False
        st = [v]
        cnt = 0
        while st:
            x = st.pop()
            cnt += 1
            if cnt > max_nodes:
                return False
            if isinstance(x, (Reg, Pseudo, Global, Upval, BoxProxy, BoxPart, FrameProxy)):
                continue
            if isinstance(x, Const) and (x.v is None or isinstance(x.v, (bool, int, float, bytes, str))):
                continue
            if isinstance(x, TailCount) and isinstance(x.tail, VarargTail):
                continue
            if isinstance(x, Index):
                st.append(x.obj)
                st.append(x.key)
                continue
            if isinstance(x, Bin):
                st.append(x.a)
                st.append(x.b)
                continue
            if isinstance(x, Un):
                st.append(x.a)
                continue
            return False
        return True

    def _is_carryable_val(self, v, is_v14=False):
        if v is None or isinstance(v, (RegFile, EnvTable, LTable, Builtin, OpaqueFn, Opaque, Buf, PackTop)):
            return True
        if is_v14 and isinstance(v, (UpList, BoxProxy, BoxPart, UpContainer, FrameProxy, Upval)):
            return True
        if isinstance(v, (Reg, Pseudo, Global)):
            return True
        if isinstance(v, Const) and (v.v is None or isinstance(v.v, (bool, int, float, bytes, str))):
            return True
        if isinstance(v, (bytes, str)) or (isinstance(v, (int, float)) and not isinstance(v, complex)):
            return True
        if isinstance(v, TailCount) and isinstance(v.tail, VarargTail):
            return True
        if isinstance(v, SymList) and not v.items and isinstance(v.tail, VarargTail):
            return True
        if is_v14 and self._v14_carryable_expr(v):
            return True
        return False

    def _carried(self, inner):
        """State.locs: the carried locals' current values. Values the state
        cannot represent (impure/symbolic chains) are SKIPPED: the next
        handler then sees nil, the pre-carry behaviour -- raising here would
        discard the whole step's output."""
        is_v14 = getattr(self.lf, "_is_v14", False)
        active_packs = {r for r, _ in self.lf.state_packs()} if is_v14 else ()
        out = []
        for k in sorted(self.carry):
            v = inner.vars.get(k)
            if is_v14 and isinstance(v, Expr) and hasattr(self.lf, "_resolve_tail_bound"):
                tb = self.lf._resolve_tail_bound(v)
                if tb is not None and isinstance(tb[1], TempTail):
                    if tb[0] in active_packs:
                        out.append((k, PackTop(tb[0])))
                    else:
                        out.append((k, max(0, tb[0] - 1)))
                    continue
            if is_v14 and isinstance(v, PackTop):
                if v.n in active_packs:
                    out.append((k, v))
                else:
                    out.append((k, max(0, v.n - 1)))
                continue
            if self._is_carryable_val(v, is_v14=is_v14):
                out.append((k, v))
        return tuple(out)

    def _fresh_scopes(self, state, it):
        """Scopes at the top of the loop function, before the first loop;
        pc / mode / loop stack set from `state` (None: initial values)."""
        cs = Scope(self.cs.parent)
        cs.vars = dict(self.cs.vars)
        if state is not None and self.mode_init_decl:
            sc_init = cs.lookup(self.mode_init_decl)
            if sc_init is not None:
                sc_init.vars[self.mode_init_decl] = state.mode
        inner = Scope(cs)
        inner.vars["..."] = cs.vars["..."]
        self.lf.cur_scope = inner
        self.lf.in_prologue = True
        it.exec_block(self.vm.inner_body[:self.first_inner], inner)
        if self.first_init:
            it.exec_block(self.first_init, inner)
        self.lf.in_prologue = False
        for k, v in cs.vars.items():
            if k not in inner.vars:
                inner.vars[k] = v
        if state is not None:
            inner.lookup(self.pc_decl).vars[self.pc_decl] = state.pc
            if self.mode_decl:
                inner.lookup(self.mode_decl).vars[self.mode_decl] = state.mode
            if self.vm.kstack_key:
                inner.lookup(self.vm.kstack_key).vars[self.vm.kstack_key] = state.kstack
            for k, v in state.locs:
                inner.vars[k] = v
            for k, vreg in self.vreg_of.items():
                inner.vars[k] = Reg(vreg)
        return cs, inner

    def run_once(self, state, decisions, tprefix):
        lf = self.lf
        lf.out = []
        lf.tcount = 0
        lf.temp_prefix = tprefix
        lf.mutated = False
        lf.jvals = dict(state.jregs) if state is not None else {}
        lf.init_jvals = dict(lf.jvals)
        lf.jread = set()
        lf.reg_gen = {}
        lf.reg_def_idx = {}
        lf.war_saved = {}

        lf.ov_base = self.gov
        lf.ov = None
        lf.proto_ov_base = state.ov if (state is not None and isinstance(state.ov, Overlay)) else None
        lf.proto_ov = None
        lf.packs = dict(state.packs) if state is not None else {}
        lf.pack_copies = {}
        lf.pack_read = set()
        lf.pending_tail = None
        it = S.Interp(lf)
        lf.cur_it = it
        it.decisions = list(decisions)
        cs, inner = self._fresh_scopes(state, it)
        inner.vars = acc = _AccessLog(inner.vars)
        loop_i = self._mode_loop_cache.get(state.mode) if state is not None else None
        if loop_i is None:
            for i, st, w in self.loops:
                if st is None or S.truthy(it.eval(self.conds[i], inner)):
                    loop_i = (i, st, w)
                    break
            if loop_i is not None and state is not None:
                self._mode_loop_cache[state.mode] = loop_i
        if loop_i is None:
            raise Unsupported("mode %r selects no dispatch loop" % (state.mode,))
        i, st, w = loop_i
        try:
            lf.last_op = (state.mode, it.eval(_disp_fetch_expr(w), inner))
        except Unsupported:
            lf.last_op = (state.mode, None)
        outcome = None
        try:
            try:
                it.exec_block(w["body"]["body"], Scope(inner))
                outcome = ("next",)
            except BreakSig:

                try:
                    if st is not None:
                        tb = st["thenbody"]["body"]
                        wi = tb.index(w) if w in tb else 0
                        it.exec_block(tb[wi + 1:], Scope(inner))
                    it.exec_block(self.vm.inner_body[i + 1:], inner)
                    outcome = ("ret", Multi([]))
                except YieldSig:
                    outcome = ("next",)
        except VMCrash:
            return it, Crash()
        except ReturnSig as r:
            if self.vm.post is None:
                outcome = ("ret", r.values)
            else:
                for k in list(cs.vars):
                    if k in acc.written:
                        cs.vars[k] = dict.get(acc, k)
                outcome = ("ret", self.post_return(it, cs, r.values))
        if hasattr(lf, "finalize_step_closures"):
            lf.finalize_step_closures()
        if outcome[0] == "ret" and outcome is not None and len(outcome) == 2 and outcome[1] is None:
            outcome = ("ret", Multi([]))
        if outcome[0] == "ret":
            m = outcome[1] if isinstance(outcome[1], Multi) else Multi([outcome[1]])
            outcome = ("ret", Multi([lf.value_of(x) if not isinstance(x, SymList) else x for x in m.items], m.tail))
        self._note_access(acc)
        if outcome[0] == "next":
            for k, vreg in self.vreg_of.items():
                if k in acc.written:
                    v = dict.get(acc, k)
                    if not (isinstance(v, Reg) and v.n == vreg):
                        lf.emit(Assign(Reg(vreg), lf.value_of(v)))
                        if vreg in lf.jump_regs and vreg not in lf.jvals and isinstance(v, Reg):
                            cfv = lf.cur_facts.get(v.n)
                            if cfv and cfv[0] == "c" and isinstance(cfv[1], int) and not isinstance(cfv[1], bool):
                                lf.jvals[vreg] = cfv[1]
            def get(k):
                return inner.lookup(k).vars[k]
            locs = self._carried(inner)
            sb = lf.stack_base
            is_v14 = getattr(lf, "_is_v14", False)
            if sb is not None and locs:
                ints = [v for k, v in locs if k in self.sp_cands and isinstance(v, int) and not isinstance(v, bool)]
                top = max(ints) if ints else -1
                jr = tuple(sorted((k, v) for k, v in lf.jvals.items()
                                  if (k not in lf.jread or k in lf.cff_regs or (is_v14 and k in lf.jump_regs) or isinstance(v, (LTable, OpaqueFn)) or (isinstance(k, int) and sb < k <= top))
                                  and (k in lf.cff_regs or (is_v14 and k in lf.jump_regs) or isinstance(v, (LTable, OpaqueFn)) or not (isinstance(k, int) and k > top))))
            else:
                jr = tuple(sorted((k, v) for k, v in lf.jvals.items() if k not in lf.jread or k in lf.cff_regs or (is_v14 and k in lf.jump_regs) or isinstance(v, (LTable, OpaqueFn))))
            next_ov = (lf.proto_ov.flattened() if lf.proto_ov is not None else lf.proto_ov_base) if is_v14 else None
            nxt = State(get(self.mode_decl) if self.mode_decl else 0, get(self.pc_decl), get(self.vm.kstack_key) if self.vm.kstack_key else None,
                        jr, next_ov, lf.state_packs(), locs)
            return it, Next(nxt)
        return it, Ret(outcome[1])

    def _note_access(self, acc):
        """Collect which prologue locals handlers read first / write; a new
        carried local (see __init__) sets `new_carry`."""
        if getattr(self, "no_carry", False):
            return
        is_v14 = getattr(self.lf, "_is_v14", False)
        for k in acc.written:
            if k not in self.vreg_of:
                self.last_written_val[k] = dict.get(acc, k)
        self.read_first |= acc.read_first
        self.written |= acc.written
        # `- vreg_of`: a local already lifted to a virtual register must not
        # be picked again, or every restart would mint a new register and ask
        # for another restart forever (order stayed empty, block unlifted)
        for k in (self.read_first & self.written & self.sp_cands) - self.carry - self.not_carried \
                - self.fixed_decls - set(self.vreg_of):
            v = dict.get(acc, k)
            lw = self.last_written_val.get(k, v)
            if k in self.lf.special or not (isinstance(lw, int) and not isinstance(lw, bool)):
                if is_v14 and k not in self.lf.special:
                    if self._is_carryable_val(lw, is_v14=True) or self._is_carryable_val(v, is_v14=True):
                        self.carry.add(k)
                        self.new_carry = True
                    continue
                if not is_v14 and self.lf.stack_base is None and isinstance(lw, (Reg, Bin)):
                    vreg = 800000 + len(self.vreg_of) + 1
                    self.vreg_of[k] = vreg
                    self.lf.vreg_set.add(vreg)
                    self.new_carry = True
                    continue
                self.not_carried.add(k)
                continue
            self.carry.add(k)
            self.new_carry = True
        # v14.9: handler temps holding state across instructions (`p=(b)` in
        # one handler, `p=p[y]` in a later one) -- carry only STABLE values:
        # concrete VM objects, register reads, constants. Growing chains
        # (Bin/Index built from the temp's own previous value) would explode
        # the state space over loops, so they stay out.
        for k in (self.read_first & self.written) - self.sp_cands - self.carry - set(self.vreg_of) - self.not_carried - self.fixed_decls:
            v = dict.get(acc, k)
            lw = self.last_written_val.get(k, v)
            if not is_v14 and self.lf.stack_base is None and not (self.carry & self.sp_cands) and (
                    isinstance(lw, Reg) or (isinstance(lw, Bin) and any(isinstance(x, TailCount) for x in self._expr_nodes(lw)))):
                vreg = 800000 + len(self.vreg_of) + 1
                self.vreg_of[k] = vreg
                self.lf.vreg_set.add(vreg)
                self.new_carry = True
                continue
            if self._is_carryable_val(v, is_v14=is_v14) or (is_v14 and self._is_carryable_val(lw, is_v14=True)):
                self.carry.add(k)
                self.new_carry = True
        if not is_v14 and self.lf.stack_base is None and not (self.carry & self.sp_cands):
            for k in list(self.carry):
                lw = self.last_written_val.get(k)
                if (isinstance(lw, Reg) and lw.n not in self.lf.vreg_set) or (
                        isinstance(lw, Bin) and any(isinstance(x, TailCount) for x in self._expr_nodes(lw))):
                    self.carry.discard(k)
                    vreg = 800000 + len(self.vreg_of) + 1
                    self.vreg_of[k] = vreg
                    self.lf.vreg_set.add(vreg)
                    self.new_carry = True

    @staticmethod
    def _expr_nodes(e):
        st = [e]
        while st:
            x = st.pop()
            if isinstance(x, Expr):
                yield x
                st.extend(v for v in x.__dict__.values() if isinstance(v, Expr))

    def post_return(self, it, cs, values):
        """The handler returned from the protected function: run the code after it."""
        ps = Scope(cs)
        names = self.vm.tstat["vars"]
        if len(names) == 1 and getattr(self.vm, "tstat_nested", False):
            ps.vars[names[0]["location"]] = SymList([True] + list(values.items), values.tail)
        else:
            vals = it.adjust(values, 4)
            ps.vars[names[0]["location"]] = True
            for v, x in zip(names[1:], vals):
                ps.vars[v["location"]] = x
        try:
            it.exec_block(self.vm.post, ps)
        except ReturnSig as r:
            return r.values
        return Multi([])

    def step(self, state, tprefix):
        """All paths of one instruction -> Node tree. Decoders re-dispatch."""
        for _ in range(8):
            paths = []
            writes = None
            todo = [[]]
            while todo:
                dec = todo.pop()
                it, oc = self.run_once(state, dec, tprefix)
                if len(paths) > 64:
                    raise Unsupported("too many paths in one instruction")
                taken = [d[3] for d in it.dlog]
                for j in range(len(dec), len(taken)):
                    todo.append(taken[:j] + [not taken[j]])
                paths.append((taken, it.dlog, list(self.lf.out), oc))
                if len(paths) == 1:
                    writes = self.lf.ov
            if writes is not None:
                for k, v in writes.d.items():
                    if k[0] not in self.lf.proto_arrays or not is_sym(v):
                        self.gov.d[k] = v
                dump = self.lf.dump
                for k, v in writes.d.items():
                    if k[0] in dump.buf_loc and isinstance(k[1], int):
                        dump.buf_patch[k] = v
                    elif k[0] in dump.tid_of and k[0] not in self.lf.proto_arrays and                             isinstance(k[1], int) and isinstance(v, (int, float)) and not isinstance(v, bool):
                        dump.tab_patch[(dump.tid_of[k[0]], k[1])] = v
            if len(paths) == 1 and not paths[0][2] and isinstance(paths[0][3], Next) \
                    and self.lf.mutated and paths[0][3].state.pc == state.pc:

                state = paths[0][3].state
                continue
            node = build_tree(paths, 0, 0)
            node.op = self.lf.last_op
            return node
        raise Unsupported("instruction keeps re-decoding itself")

JIT_ENTRY = -(1 << 40)     
JIT_TMP = 900000           

def jit_maker_parts(node):
    """LPH_JIT functions are VM-object methods `function(g, upvals, P) local
    W = P[P[k]]; return function(params) <prologue> while c do <if tree on
    a state variable> end end`: plain Lua (a control-flow-flattened state
    machine over the constant array W), not bytecode. -> (index of the proto
    parameter, the inner function) for such a maker, else None."""
    if not isinstance(node, dict) or node.get("type") != "AstExprFunction":
        return None
    body = node["body"]["body"]
    if len(body) != 2 or body[0]["type"] != "AstStatLocal" or body[1]["type"] != "AstStatReturn":
        return None
    vals, ret = body[0]["values"], body[1]["list"]
    if len(vals) != 1 or len(ret) != 1 or ret[0]["type"] != "AstExprFunction":
        return None
    v = vals[0]
    if v["type"] != "AstExprIndexExpr" or v["expr"]["type"] != "AstExprLocal" \
            or v["index"]["type"] != "AstExprIndexExpr" or v["index"]["expr"]["type"] != "AstExprLocal":
        return None
    p = v["expr"]["local"]["location"]
    if v["index"]["expr"]["local"]["location"] != p:
        return None
    pis = [i for i, a in enumerate(node["args"]) if a["location"] == p]
    inner = ret[0]
    if not pis or not any(st["type"] == "AstStatWhile" for st in inner["body"]["body"]):
        return None
    return pis[-1], inner

class JitModel(VMModel):
    """An LPH_JIT function (jit_maker_parts), lifted like a one-mode VM: one
    pass of its dispatch loop is an instruction, the state variable is the
    pc, and its parameters and the locals of its prologue are registers
    (except those holding a fixed value, see JitStepper). Registered as a
    sibling maker: the closure op that calls this maker makes a ClosureExpr
    with this model."""

    def __init__(self, maker, ctor, pi, inner):
        self.info = {"maker": maker, "vm": inner, "proto_index": pi, "upvals_index": 1}
        self.maker, self.vm, self.ctor_funcs = maker, inner, ctor
        self.maker_decls = {}
        self.inner = inner
        self.inner_body = inner["body"]["body"]
        self.prologue, self.tstat, self.post = [], None, None
        self.kstack_key = self.kstack_link = None
        self.wi = next(i for i, st in enumerate(self.inner_body) if st["type"] == "AstStatWhile")
        w = self.inner_body[self.wi]
        self.dispatch = {id(w)}
        c = w["condition"]
        self.cond_decl = c["local"]["location"] if c["type"] == "AstExprLocal" else None
        self.pc_decl = None
        for st in w["body"]["body"]:
            if st["type"] == "AstStatIf":
                c = st["condition"]
                if c["type"] == "AstExprBinary" and c["left"]["type"] == "AstExprLocal":
                    self.pc_decl = c["left"]["local"]["location"]
                break
            if st["type"] != "AstStatLocal" or st["values"]:
                break
        if self.pc_decl is None:
            raise Unsupported("LPH_JIT function without a state dispatch")
        self.assigned = set()       
        for n in iter_nodes(w):
            if n.get("type") == "AstStatAssign":
                self.assigned |= {v["local"]["location"] for v in n["vars"] if v["type"] == "AstExprLocal"}
            elif n.get("type") == "AstStatCompoundAssign" and n["var"]["type"] == "AstExprLocal":
                self.assigned.add(n["var"]["local"]["location"])
        self.params = [a["location"] for a in inner["args"]]
        self.locals = [v["location"] for st in self.inner_body[:self.wi] if st["type"] == "AstStatLocal"
                       for v in st["vars"]]

        self.jstack = None
        for n in iter_nodes(w):
            if n.get("type") == "AstExprTable":
                for it in n["items"]:
                    v = it["value"]
                    if v["type"] == "AstExprLocal" and v["local"]["location"] in self.locals:
                        self.jstack = v["local"]["location"]

        live = _jit_live_in(w, self.pc_decl, set(self.params + self.locals))
        self.special = {}
        if self.jstack is not None:
            self.special[self.jstack] = ("jstack",)
        for loc in self.params + self.locals:
            if loc not in (self.pc_decl, self.cond_decl) and loc not in self.special and loc in live:
                self.special[loc] = ("reg", len(self.special) + 1)

JIT_BOTTOM = JitFrame(None, 0)

class JitProto(LTable):
    """The "proto" of a function an LPH_JIT function defines (a Lua closure,
    itself a state machine): where it was made (env) and which outer locals
    it uses as upvalues (upmap: declaration -> upvalue index)."""
    __slots__ = ("env", "upmap")

    def __init__(self, env, upmap):
        LTable.__init__(self)
        self.env, self.upmap = env, upmap

_JIT_NESTED = {}
_JIT_TAGGED = {}       

def _jit_nested_model(node):
    if id(node) not in _JIT_NESTED:
        try:
            jm = JitModel(None, {}, None, node)
            jm.tag = "jit-nested@%s" % (node.get("location"),)
            _JIT_TAGGED[jm.tag] = jm
            _JIT_NESTED[id(node)] = (node, jm)
        except (Unsupported, StopIteration, KeyError):
            _JIT_NESTED[id(node)] = (node, None)
    return _JIT_NESTED[id(node)][1]

def _declared_in(node):
    cache = node.get("_decl_in")
    if cache is not None:
        return cache
    out = {a["location"] for a in node.get("args", [])}
    for n in iter_nodes(node):
        t = n.get("type")
        if t in ("AstStatLocal", "AstStatForIn"):
            out |= {v["location"] for v in n["vars"]}
        elif t == "AstStatFor":
            out.add(n["var"]["location"])
        elif t == "AstStatLocalFunction":
            out.add(n["name"]["location"])
        elif t == "AstExprFunction":
            out |= {a["location"] for a in n["args"]}
    node["_decl_in"] = out
    return out

def _jit_live_in(w, pc_decl, cands):
    """Candidates (declarations) some step of the dispatch loop `w` reads
    before it assigns them, or that a function made inside reads. A step is
    the loop body's statements before the dispatch `if` plus one leaf of the
    `if pc <= K` tree."""
    live = set()

    def is_dispatch(st):
        c = st.get("condition") if st.get("type") == "AstStatIf" else None
        return c is not None and c["type"] == "AstExprBinary" and c["left"]["type"] == "AstExprLocal" \
            and c["left"]["local"]["location"] == pc_decl

    def expr(e, done):
        for n in iter_nodes(e):
            t = n.get("type")
            if t == "AstExprLocal" and n["local"]["location"] in cands and n["local"]["location"] not in done:
                live.add(n["local"]["location"])
            elif t == "AstExprFunction":
                live.update(x["local"]["location"] for x in iter_nodes(n)
                            if x.get("type") == "AstExprLocal" and x["local"]["location"] in cands)

    def block(stmts, done):
        done = set(done)
        for st in stmts:
            t = st["type"]
            if t == "AstStatLocal":
                for v in st["values"]:
                    expr(v, done)
            elif t == "AstStatAssign":
                for v in st["values"]:
                    expr(v, done)
                for v in st["vars"]:
                    if v["type"] != "AstExprLocal":
                        expr(v, done)
                for v in st["vars"]:
                    if v["type"] == "AstExprLocal":
                        done.add(v["local"]["location"])
            elif t == "AstStatCompoundAssign":
                expr(st["var"], done)
                expr(st["value"], done)
            elif t == "AstStatIf":
                expr(st["condition"], done)
                a = block(st["thenbody"]["body"], done)
                e = st.get("elsebody")
                if e is None:
                    b = done
                elif e["type"] == "AstStatIf":
                    b = block([e], done)
                else:
                    b = block(e["body"], done)
                done = a & b
            elif t in ("AstStatWhile", "AstStatRepeat"):
                expr(st["condition"], done)
                block(st["body"]["body"], done)
            elif t == "AstStatFor":
                for k in ("from", "to", "step"):
                    if st.get(k):
                        expr(st[k], done)
                block(st["body"]["body"], done)
            elif t == "AstStatForIn":
                for v in st["values"]:
                    expr(v, done)
                block(st["body"]["body"], done)
            elif t == "AstStatBlock":
                done = block(st["body"], done)
            else:
                expr(st, done)
        return done

    def leaves(stmts, done):

        if len(stmts) == 1 and is_dispatch(stmts[0]):
            st = stmts[0]
            leaves(st["thenbody"]["body"], done)
            e = st.get("elsebody")
            if e is not None:
                leaves([e] if e["type"] == "AstStatIf" else e["body"], done)
        else:
            block(stmts, done)

    body = w["body"]["body"]
    i = next((k for k, st in enumerate(body) if is_dispatch(st)), len(body))
    done = block(body[:i], set())
    leaves(body[i:i + 1], done)
    if i + 1 < len(body):
        block(body[i + 1:], set())
    expr(w["condition"], set())
    return live

def _fixed_value(v):
    """A prologue local's value that is the same on every entry (the
    environment, library functions, constants, dump tables): kept as a value."""
    if v is None or isinstance(v, (bool, int, float, bytes, EnvTable, Builtin, OpaqueFn, LuaFunc,
                                   UpList, BoxProxy, FrameProxy)):
        return True
    if isinstance(v, LTable):
        return v.tid is not None
    if isinstance(v, SymList):
        return not v.items and v.tail is None
    return False

class JitStepper(Stepper):
    """Stepper for a JitModel. The entry (pc JIT_ENTRY) runs the prologue
    and assigns the registers; every other step runs the prologue again
    only to rebuild the fixed values, then one pass of the loop body."""

    def __init__(self, vm, lifter):
        self.vm = vm
        self.lf = lifter
        self.cs = lifter.initial_state()
        self.loops = [(vm.wi, None, vm.inner_body[vm.wi])]
        self.mode_decl = None
        self.pc_decl = vm.pc_decl
        self.conds = {}
        self.first_inner = vm.wi
        self.gov = Overlay()
        lifter.special = dict(vm.special)
        if isinstance(lifter.proto, JitProto):
            for loc, k in lifter.proto.upmap.items():
                lifter.special[loc] = ("upval", k)
        lifter.out = []
        _, inner = self._fresh_scopes(None, S.Interp(lifter))
        for loc in vm.locals:
            if loc in lifter.special and loc not in vm.assigned and _fixed_value(inner.vars.get(loc)):
                del lifter.special[loc]
        lifter.out = []

    def _fresh_scopes(self, state, it, entry=False):
        vm, lf = self.vm, self.lf
        cs = Scope(self.cs.parent)
        cs.vars = dict(self.cs.vars)
        inner = Scope(cs)
        lf.in_prologue = not entry
        lf.jstack = JIT_BOTTOM
        for i, loc in enumerate(vm.params, 1):
            inner.vars[loc] = Vararg(i)
            if lf.special.get(loc):
                lf.special_set(lf.special[loc], Vararg(i), it)
        if vm.inner.get("vararg"):
            inner.vars["..."] = Multi([], VarargTail(len(vm.params) + 1))
        lf.cur_scope = inner
        it.exec_block(vm.inner_body[:vm.wi], inner)
        lf.in_prologue = False
        if state is not None and isinstance(state.kstack, JitFrame):
            lf.jstack = state.kstack
        if not entry and state is not None:
            inner.lookup(self.pc_decl).vars[self.pc_decl] = state.pc
        return cs, inner

    def initial(self):
        return State(0, JIT_ENTRY, JIT_BOTTOM)

    def step(self, state, tprefix):
        node = Stepper.step(self, state, tprefix)
        _jit_forloop(node, self.lf)
        return node

    def run_once(self, state, decisions, tprefix):
        lf = self.lf
        vm = self.vm
        lf.out = []
        lf.tcount = 0
        lf.temp_prefix = tprefix
        lf.mutated = False
        lf.jvals = dict(state.jregs)
        lf.jread = set()
        lf.ov_base = self.gov
        lf.ov = None
        lf.packs = dict(state.packs)
        lf.pack_copies = {}
        lf.pack_read = set()
        it = S.Interp(lf)
        it.decisions = list(decisions)
        lf.last_op = (0, state.pc)
        entry = state.pc == JIT_ENTRY
        try:
            cs, inner = self._fresh_scopes(state, it, entry)
            if not entry:
                lf.out = []         
                ended = False
                try:
                    it.exec_block(vm.inner_body[vm.wi]["body"]["body"], Scope(inner))
                except ContinueSig:
                    pass
                except BreakSig:
                    ended = True
                if not ended and vm.cond_decl is not None:
                    cv = inner.lookup(vm.cond_decl).vars[vm.cond_decl]
                    if is_sym(cv):
                        raise Unsupported("symbolic LPH_JIT loop condition")
                    ended = not S.truthy(cv)
                if ended:
                    it.exec_block(vm.inner_body[vm.wi + 1:], inner)
                    raise ReturnSig(Multi([]))
        except VMCrash:
            return it, Crash()
        except ReturnSig as r:
            m = r.values if isinstance(r.values, Multi) else Multi([r.values])
            return it, Ret(Multi([lf.value_of(x) if not isinstance(x, SymList) else x for x in m.items], m.tail))
        pc = inner.lookup(self.pc_decl).vars[self.pc_decl]
        jr = tuple(sorted((k, v) for k, v in lf.jvals.items() if k not in lf.jread))
        return it, Next(State(0, pc, lf.jstack, jr, None,
                              lf.state_packs()))

def _jit_forloop(node, lf):
    """An LPH_JIT numeric-for header (`c, s, l = N[..]; u = c + s; N[c] = u;
    if (s <= 0 and u >= l) or (s > 0 and u <= l) then var = u; body else
    exit`) in the shape of the VM's FORLOOP handler (loops.try_numeric):
    `c = c + s; if s <= 0 then (if c >= l ...) else (if c <= l ...)`."""
    c0 = node.cond
    if node.stmts or not (isinstance(c0, Bin) and c0.op == "CompareLe" and isinstance(c0.a, Pseudo)
                          and isinstance(c0.b, Const) and c0.b.v == 0):
        return
    step = c0.a
    found = None
    for side, op in ((node.then, "CompareGe"), (node.els, "CompareLe")):
        cc = getattr(side, "cond", None)
        if side is None or len(side.stmts) > 1 or not (isinstance(cc, Bin) and cc.op == op
                                                       and isinstance(cc.b, Pseudo)):
            return
        sm = cc.a
        if not (isinstance(sm, Bin) and sm.op == "Add" and isinstance(sm.a, Pseudo) and sm.b == step
                and sm.a.depth == step.depth and cc.b.depth == step.depth):
            return
        t, e = side.then, side.els
        if t is None or e is None or t.cond is not None or e.cond is not None:
            return
        f = fmt_expr(sm)

        if side.stmts and len(t.stmts) <= 1 and not e.stmts:
            a1, a3 = side.stmts[0], side.stmts[0]
            a2 = t.stmts[0] if t.stmts else None
        elif not side.stmts and len(t.stmts) in (1, 2) and len(e.stmts) == 1:
            a1, a3 = t.stmts[0], e.stmts[0]
            a2 = t.stmts[1] if len(t.stmts) == 2 else None
        else:
            return
        if not all(isinstance(x, Assign) for x in (a1, a2 or a1, a3)):
            return
        if not (a1.target == sm.a and a3.target == sm.a and fmt_expr(a1.value) == f and fmt_expr(a3.value) == f
                and (a2 is None or (isinstance(a2.target, Reg) and fmt_expr(a2.value) == f))):
            return
        key = (sm.a, cc.b, a2.target.n if a2 is not None else None)
        if found is not None and found != key:
            return
        found = key
    cnt, lim, var = found
    if var is None:
        lf.tmp_regs = getattr(lf, "tmp_regs", 0) + 1
        var = JIT_TMP + lf.tmp_regs
    node.stmts = [Assign(cnt, Bin("Add", cnt, step))]
    for side in (node.then, node.els):
        side.stmts = []
        side.cond = Bin(side.cond.op, cnt, lim)
        side.then.stmts = [Assign(Reg(var), cnt)]
        side.els.stmts = []

def make_stepper(vm, lifter):
    return JitStepper(vm, lifter) if isinstance(vm, JitModel) else Stepper(vm, lifter)

_BT_WARNED = [False]

def build_tree(paths, d, start):
    """paths share decisions[:d]; statements before `start` were emitted already."""
    if len(paths) == 1 and len(paths[0][0]) <= d:
        taken, dlog, out, oc = paths[0]
        return Node(out[start:], outcome=oc)

    p0 = paths[0]
    if len(p0[0]) <= d or len(p0[1]) <= d:
        # decisions exhausted -- or the decision log is shorter than the
        # decision list (a re-dispatch edge case): there is no logged branch
        # position at depth d to split on, so the only sound shape is a leaf
        # carrying p0's statements.
        if len(p0[0]) > d and not _BT_WARNED[0]:
            _BT_WARNED[0] = True
            print("[!] devirt: decision log shorter than the decision list at depth %d; "
                  "emitting the prefix as a leaf (one branch may be partial)" % d, file=sys.stderr)
        taken, dlog, out, oc = p0
        return Node(out[start:], outcome=oc)
    _, cond, _ = p0[1][d][1], p0[1][d][2], None
    at = p0[1][d][1]
    stmts = p0[2][start:at]
    tp = [p for p in paths if p[0][d]]
    fp = [p for p in paths if not p[0][d]]
    then = build_tree(tp, d + 1, at) if tp else None
    els = build_tree(fp, d + 1, at) if fp else None
    return Node(stmts, cond=cond, then=then, els=els)

