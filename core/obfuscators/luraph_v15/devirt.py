"""Luraph v15 devirtualizer orchestrator (Program, FunctionLifter, lift_program) and public facade."""
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
from obfuscators.luraph_v15 import vmmap
from obfuscators.luraph_v15.dump import (
    PatchLog, Dump, OpaqueFn, FrameArg, RuntimeMaker, SharedFn, JitFrame,
    REG_PREFIX, REG_ARRAY, LAST_DUMP,
)
from obfuscators.luraph_v15.dataflow import (
    OpenUps, OPENUPS, MaybeBox, UpList, REGFILE, FRAME, FrameProxy, BoxProxy, BoxPart,
    walk_expr, meet, fact_of, eval_fact, truth_of, edge_facts, _replace_dict_fact,
    _upval_open_reg, _single_const_fact, _capture_closure_up_facts, apply_stmt_facts,
    frame_call, drop_idle_closes, apply_frame_calls, _check_cff_bin, propagate, expr_regs,
)
from obfuscators.luraph_v15.vm_model import (
    _classify_vm_method, _PlainPrinter, PlainProto, iter_nodes, VMModel, find_ctor_funcs,
    VMCrash, Overlay, _differs, _hv, _pack_sig, State, WALK_MAX_ERRORS, WALK_RESTARTS,
    WALK_LIMIT, _carry_key, MAX_STACK_DEPTHS, STACK_WALK_MAX, _locs_lt,
)
from obfuscators.luraph_v15.stepper import (
    GenIterMaker, _AccessLog, _disp_fetch_expr, Stepper, JIT_ENTRY, JIT_TMP,
    jit_maker_parts, JitModel, JIT_BOTTOM, JitProto, _JIT_NESTED, _JIT_TAGGED,
    _jit_nested_model, _declared_in, _jit_live_in, _fixed_value, JitStepper,
    _jit_forloop, make_stepper, _BT_WARNED, build_tree,
)
from obfuscators.luraph_v15.lifter import ProtoLifter, lst_nkey, pad
from obfuscators.luraph_v15.patches import (
    buffer_patches, stable_patches, format_patches, same_patches,
    WalkCache, PathResolver, collect_requests, _walk_one, _translate,
)

def chunk_key(src):
    """Same key as deob.chunk_key / srcKey() in envlog.luau (the __maker tag prefix)."""
    return harness.chunk_key(src)

_SOURCE_CACHE = {}      

def analyze_source(path):
    """AST, VM models and constructor functions of one VM source file. Depends
    only on the text, so constant rounds reuse it."""
    with open(path, encoding="latin-1", newline="") as f:
        text = f.read()
    hit = _SOURCE_CACHE.get(text)
    if hit is not None:
        return hit
    root = vmmap.load_ast(path)
    key = chunk_key(text)
    disp = vmmap.find_dispatchers(root)
    ctor = find_ctor_funcs(root)
    assign_ctor = vmmap.ctor_assignments(root)
    vms = {}
    for info in vmmap.maker_info(root, disp):
        vm_node = info["vm"]
        ids = {id(n) for n in iter_nodes(vm_node)}
        inside = [d["node"] for d in disp if id(d["node"]) in ids]
        tag = "%s@%d,%d" % ((key,) + tuple(info["at"]))
        vms[tag] = VMModel(info, inside, ctor)
        vms[tag].tag = tag
        vms[tag].outer = vmmap.outer_decls(root, vm_node)
        vms[tag].assign_ctor = assign_ctor

    for k, node in ctor.items():
        parts = jit_maker_parts(node)
        if parts is not None:
            try:
                jm = JitModel(node, ctor, parts[0], parts[1])
            except Unsupported:
                continue
            jm.tag = "%s@jit:%s" % (key, k.decode("latin-1") if isinstance(k, bytes) else k)
            vms[jm.tag] = jm

    siblings = {id(vm.maker): vm for vm in vms.values()}
    for vm in vms.values():
        vm.siblings = siblings
    hit = _SOURCE_CACHE[text] = (root, text.split("\n"), vms, ctor)
    return hit

_WALK_HINTS = {}

class Program:
    def __init__(self, source_path, dump_path, chunk_paths=()):
        """source_path: the obfuscated script; chunk_paths: original sources of
        VM chunks it loadstring'd (their protos are tagged with their key)."""
        self.dump = Dump(dump_path)
        self.vms = {}
        self.ctors = {}
        self.plain_makers = {}
        for i, path in enumerate([source_path] + list(chunk_paths)):
            root, lines, vms, ctor = analyze_source(path)
            if i == 0:
                self.root = root
                self.lines = lines
            for tag, vm in vms.items():
                self.vms[tag] = vm
                self.ctors[id(vm)] = ctor
                vm.src_lines = lines
            ckey = harness.chunk_key("\n".join(lines))
            for pm in vmmap.plain_curried_makers(root):
                l2, c2 = pm["at"]
                self.plain_makers["plain:%s@%d,%d" % (ckey, l2, c2)] = (pm["f3"], pm["f2"], lines)
        self.dump.vm_names = {vm.maker["args"][0]["name"] for vm in self.vms.values()} | {
            vm.info["chain"][0]["args"][0]["name"] for vm in self.vms.values()
            if vm.info.get("chain") and vm.info["chain"][0].get("args")
        }

        # dump protos captured under a different chunk name (the harness may
        # tag a captured chunk "payload") still match by their @line,col
        # suffix: rewrite the tag so vm_of finds the analyzed VM model
        by_suffix = {}
        for tag in self.vms:
            by_suffix[tag.rpartition("@")[2]] = tag
        plain_by_suffix = {}
        for tag in self.plain_makers:
            plain_by_suffix[tag.rpartition("@")[2]] = tag
        self.dump.vms = self.vms
        self.dump.by_suffix = by_suffix
        self.dump.plain_makers = self.plain_makers
        self.dump.plain_by_suffix = plain_by_suffix
        for cap in self.dump.protos.values():
            mk = cap.get("__maker")
            if mk is None:
                continue
            tag = mk.decode("latin-1") if isinstance(mk, bytes) else str(mk)
            if tag.startswith("plain:"):
                if tag not in self.plain_makers:
                    hit = plain_by_suffix.get(tag.rpartition("@")[2])
                    if hit is not None:
                        cap["__maker"] = hit.encode("latin-1")
            elif tag not in self.vms:
                hit = by_suffix.get(tag.rpartition("@")[2])
                if hit is not None:
                    cap["__maker"] = hit.encode("latin-1")

        # index the captures by their self table so a lifted child proto finds
        # its own captured state (its W/V/... tables) instead of its parent's
        self.dump.cap_by_self = {}
        self.dump.cap_by_state = {}
        for cap in self.dump.protos.values():
            sv = cap.get("self")
            if isinstance(sv, LTable):
                self.dump.cap_by_self[sv.tid] = cap
            mk = cap.get("__maker")
            vmk = None
            if mk is not None:
                t = mk.decode("latin-1") if isinstance(mk, bytes) else str(mk)
                vmk = self.vms.get(t)
            st = cap.get(vmk.maker["args"][0]["name"]) if vmk is not None and isinstance(vmk.maker, dict) else None
            if isinstance(st, LTable):
                self.dump.cap_by_state[st.tid] = cap

        # VM-wide capture fields every proto's capture agrees on (helpers,
        # shared tables): the values uncaptured children still need
        shared = {}
        caps_list = [
            c for c in self.dump.protos.values()
            if c.get("__maker") is not None
            and not (c["__maker"].decode("latin-1") if isinstance(c["__maker"], bytes) else str(c["__maker"])).startswith("plain:")
        ]
        if caps_list:
            for nm in caps_list[0]:
                if nm in ("self", "__maker", "__seq"):
                    continue
                vs = [c.get(nm) for c in caps_list]
                ids = {v.get("t") if isinstance(v, dict) else id(v) for v in vs}
                if len(ids) == 1:
                    v = vs[0]
                    if v is None or isinstance(v, (LTable, Builtin, OpaqueFn, Opaque,
                                                   int, float, bytes, bool)):
                        shared[nm] = v
        self.dump.shared_cap = shared

        for cap in self.dump.protos.values():
            try:
                vm = self.vm_of(cap)
            except Unsupported:
                # a proto whose __maker tag has no saved VM source (loadstring'd
                # chunk that was not written out): skip it instead of aborting
                # the whole Program construction
                continue
            ctor = self.ctors[id(vm)]
            assign_ctor = getattr(vm, "assign_ctor", {})
            unique_by_key = {}
            ambig_keys = set()
            for (_b, ak), afn in assign_ctor.items():
                if ak in ambig_keys:
                    continue
                if ak in unique_by_key and unique_by_key[ak] is not afn:
                    del unique_by_key[ak]
                    ambig_keys.add(ak)
                else:
                    unique_by_key[ak] = afn
            for nm, e in cap.items():
                if not isinstance(e, LTable):
                    continue
                for k, v in e.h.items():
                    if not isinstance(v, OpaqueFn) or v.node is not None:
                        continue
                    fn = None
                    if k in ctor:
                        fn = ctor[k]
                    elif isinstance(k, int) and k in ctor:
                        fn = ctor[k]
                    elif isinstance(k, int):
                        fn = assign_ctor.get((nm.encode("latin-1"), k)) or unique_by_key.get(k)
                    elif isinstance(k, bytes):
                        ik = S.fix_int(k)
                        fn = assign_ctor.get((nm.encode("latin-1"), ik)) or unique_by_key.get(ik)
                    if fn is not None:
                        v.node = fn
        g = LTable()
        for lib in ("bit32", "string", "table", "math", "buffer", "utf8"):
            t = LTable()
            for nm in list(S.CONCRETE) + ["table.pack", "table.unpack", "table.move", "table.create"]:
                if nm.startswith(lib + "."):
                    t.set(nm.split(".", 1)[1].encode(), Builtin(nm))
            g.set(lib.encode(), t)
        for nm in ("select", "unpack", "getfenv", "setfenv", "tonumber"):
            g.set(nm.encode(), Builtin(nm))
        self.globals = g

    def vm_of(self, cap):
        tag = cap.get("__maker").decode("latin-1")
        if tag not in self.vms:
            raise Unsupported("no source for VM %s (a loadstring'd chunk that was not saved?)" % tag)
        return self.vms[tag]

    def lift_raw(self, key, upvals=None, limit=200000):
        cap = self.dump.protos[key]
        vm = self.vm_of(cap)
        if upvals is None:
            upvals = UpList()
        proto = vm.proto_of(cap)
        lf = ProtoLifter(vm, self.dump, vm.vmobj_of(cap), proto, upvals, self.globals, cap=cap)
        st = make_stepper(vm, lf)
        for _ in range(WALK_RESTARTS):
            s0, order, restart = self._walk(vm, lf, st, limit)
            if not restart:
                break
        return s0, order, lf

    def _walk(self, vm, lf, st, limit):
        """Sparse conditional constant propagation over the instruction graph.
        Each state (mode, pc, loop depth, jump registers, packs) is stepped
        once; register facts (constant / truthy / falsy) flow along edges and
        meet at merges. A branch whose condition the facts decide only enables
        one edge, so Luraph's opaque predicates never lead into junk code
        (which would also run bogus in-place decryptors).
        Returns (entry, [(key, node)], restart)."""
        hkey = (id(vm), getattr(lf.proto, "tid", None))
        if hkey[1] is not None and hkey in _WALK_HINTS:
            hj, hcff, hpu, hcar, hvr, hvrs = _WALK_HINTS[hkey]
            lf.jump_regs |= hj - lf.arith_regs
            lf.cff_regs |= hcff - lf.arith_regs
            lf.pack_unstable |= hpu
            if hasattr(st, "carry") and not getattr(st, "no_carry", False):
                st.carry |= hcar
            if hasattr(st, "vreg_of"):
                st.vreg_of.update(hvr)
                lf.vreg_set |= hvrs
        lf.children.clear()
        lf.captured_regs.clear()
        lf.reg_const_fact = {}
        lf.reg_closure_fact = {}
        lf.rcf_single_val = {}
        lf.rcf_single_used = set()
        lf.rcf_single_restart = False
        lf.rcf_post_cap_val = {}
        lf.rcf_post_cap_used = set()
        lf.mutated_upvals = set()
        lf.up_single_val = {}
        lf.up_single_used = set()
        poisoned0 = lf.__dict__.setdefault("rcf_single_poisoned", set())
        poisoned0.update(range(1, getattr(lf, "numparams", 0) + 1))
        poisoned0.update(lf.jump_regs)
        poisoned0.update(lf.cff_regs)
        s0 = st.initial()
        link = vm.kstack_link
        nodes = {}          
        states = {}         
        facts = {}          
        order = []
        pred = {}          # (walk-local: nothing reads these after the
        edges = {}         #  walk; holding them through lower() OOM'd runs)
        work = deque([s0.key(link)])
        states[work[0]] = s0
        init_f = dict(getattr(lf, "init_facts", None) or {})
        for p_idx in range(1, getattr(lf, "numparams", 0) + 1):
            init_f.setdefault(p_idx, ("any",))
        for vr, iv in getattr(st, "vreg_init", {}).items():
            init_f[vr] = ("c", iv)
        if lf.vreg_set & lf.jump_regs and getattr(st, "vreg_init", None):
            jmap0 = dict(s0.jregs)
            jch0 = False
            for vr in lf.vreg_set & lf.jump_regs:
                iv = st.vreg_init.get(vr)
                if isinstance(iv, int) and not isinstance(iv, bool) and jmap0.get(vr) != iv:
                    jmap0[vr] = iv
                    jch0 = True
            if jch0:
                s0 = State(s0.mode, s0.pc, s0.kstack, tuple(sorted(jmap0.items())), s0.ov, s0.packs, s0.locs)
                work = deque([s0.key(link)])
                states = {work[0]: s0}
        facts[work[0]] = init_f
        inwork = {work[0]}
        pack_sets = {}      
        pending = set()     
        need_restart = False
        depth_at = {}       
        hubs = set()        
        steps = 0
        nerr = 0
        unique_seen = 0
        plateau = 0
        while work and len(order) < limit:
            k = work.popleft()
            inwork.discard(k)
            s = states[k]
            node = nodes.get(k)
            if node is None:
                try:
                    lf.cur_facts = facts.get(k, {})
                    node = st.step(s, "%s_%d_" % (s.pc, len(order)))
                except Unsupported as e:
                    if os.environ.get("DEVIRT_TB"):
                        import traceback
                        print("-- at %s:%s op %s" % (s.mode, s.pc, lf.last_op), file=sys.stderr)
                        for arr in [v_ for v_ in lf.proto.h.values() if isinstance(v_, LTable)]:
                            for pc_ in range(s.pc - 2, s.pc + 2):
                                base = arr.get(pc_)
                                print("   arr#%s[%d] = %s -> %s" % (arr.tid, pc_, base, st.gov.d.get((id(arr), pc_), base)), file=sys.stderr)
                        traceback.print_exc()
                    node = Node([], outcome=None)
                    node.error = str(e)
                    nerr += 1
                if getattr(st, "new_carry", False):

                    st.new_carry = False
                    lf.__dict__.get("rcf_single_poisoned", set()).clear()
                    lf.__dict__.get("rcf_post_cap_poisoned", set()).clear()
                    lf.__dict__.get("up_single_poisoned", set()).clear()
                    return s0, order, True
                if getattr(lf, "cff_dropped", False):
                    lf.cff_dropped = False
                    return s0, order, True
                nodes[k] = node
                order.append((k, node))
                if len(order) % 5000 == 0:
                    seen_now = len(set((kk[0], kk[1]) for kk, _ in order))
                    if seen_now == unique_seen:
                        plateau += 5000
                        if plateau >= 25000:
                            break
                    else:
                        unique_seen = seen_now
                        plateau = 0
                if lf.walk_only and nerr > WALK_MAX_ERRORS:

                    break
            steps += 1
            if steps > limit * 20:
                break
            if lf.stack_base is not None and len(order) > STACK_WALK_MAX and getattr(st, "carry", None):

                st.carry = set()
                st.no_carry = True
                lf.stack_base = None
                lf.jump_regs = set()
                return s0, order, True
            succ = []
            restart = propagate(node, dict(facts[k]), succ, lf)
            if restart == "cff_restart":
                return s0, order, True
            if restart:
                node.error = restart
            for ns, nf in succ:
                sym_mode, sym_pc = getattr(node, "_sym_outcome", (ns.mode, ns.pc))
                if not isinstance(sym_pc, int) or not isinstance(sym_mode, int):
                    node._sym_outcome = (sym_mode, sym_pc)
                    regs = {r.n for x in (sym_pc, sym_mode) if not isinstance(x, int)
                            for r in expr_regs(x)} - lf.jump_regs
                    if regs and lf.stack_base is not None:

                        pending |= regs
                        continue
                    npc, nmode = sym_pc, sym_mode
                    if not isinstance(npc, int):
                        pf = eval_fact(npc, nf)
                        if pf and pf[0] == "c" and isinstance(pf[1], int) and not isinstance(pf[1], bool):
                            npc = pf[1]
                    if not isinstance(nmode, int):
                        mf = eval_fact(nmode, nf)
                        if mf and mf[0] == "c" and isinstance(mf[1], int) and not isinstance(mf[1], bool):
                            nmode = mf[1]
                    resolved = isinstance(npc, int) and isinstance(nmode, int)
                    if regs and not resolved:
                        valid_regs = set()
                        for r in regs:
                            if r not in lf.int_regs:
                                continue
                            rf = eval_fact(Reg(r), nf)
                            if r in lf.merged_int_regs or (rf and rf[0] == "c" and isinstance(rf[1], int) and not isinstance(rf[1], bool)):
                                valid_regs.add(r)
                        if valid_regs:
                            lf.jump_regs |= valid_regs
                            need_restart = True
                    if resolved:
                        ns = State(nmode, npc, ns.kstack, ns.jregs, ns.ov, ns.packs, ns.locs)
                        if node.cond is None and isinstance(node.outcome, Next):
                            node.outcome = Next(ns)
                    else:
                        if need_restart:
                            return s0, order, True
                        node.error = "symbolic next pc/mode: %s / %s" % (fmt_any(sym_pc), fmt_any(sym_mode))
                        continue
                if ns.locs:

                    if ns.pc != s.pc + 1 and s.locs and _locs_lt(ns.locs, s.locs):
                        hubs.add((s.mode, s.pc))
                    seen_locs = depth_at.setdefault(
                        (ns.mode, ns.pc, tuple((rk, _hv(rv)) for rk, rv in ns.jregs)), set())
                    # the depth limiter tracks the STACK POINTER value only:
                    # keying on the whole locs tuple multiplied states wherever
                    # a carried local held a concrete object (a decryptor's
                    # buffer, an opaque helper), exhausting MAX_STACK_DEPTHS
                    # on semantically equal states
                    spv = st._sp_value(ns.locs)
                    if spv not in seen_locs and len(seen_locs) >= MAX_STACK_DEPTHS \
                            and (ns.mode, ns.pc) not in hubs:
                        node.error = "stack depth %s at %s:%s (seen %s)" % (
                            st._sp_value(ns.locs), ns.mode, ns.pc,
                            sorted(seen_locs, key=repr))
                        continue
                    seen_locs.add(spv)
                if lf.vreg_set & lf.jump_regs:
                    jmap = dict(ns.jregs)
                    jchanged = False
                    for vr in lf.vreg_set & lf.jump_regs:
                        vf = nf.get(vr)
                        if vf and vf[0] == "c" and isinstance(vf[1], int) and not isinstance(vf[1], bool):
                            if jmap.get(vr) != vf[1]:
                                jmap[vr] = vf[1]
                                jchanged = True
                    if jchanged:
                        old_ns = ns
                        ns = State(ns.mode, ns.pc, ns.kstack, tuple(sorted(jmap.items())), ns.ov, ns.packs, ns.locs)
                        nstack = [node]
                        while nstack:
                            cn = nstack.pop()
                            if cn is None:
                                continue
                            if isinstance(cn.outcome, Next) and cn.outcome.state is old_ns:
                                cn.outcome = Next(ns)
                            nstack.append(cn.then)
                            nstack.append(cn.els)
                nk = ns.key(link)

                core = nk[:5]
                seen = pack_sets.setdefault(core, nk[5])
                if seen != nk[5]:
                    bad = (set(seen) ^ set(nk[5])) & lf.pack_killed
                    if bad - lf.pack_unstable:
                        lf.pack_unstable |= bad
                        return s0, order, True
                edges.setdefault(k, set()).add(nk)
                if nk not in facts:
                    facts[nk] = nf
                    states[nk] = ns
                    pred[nk] = k
                    changed = True
                else:
                    old = facts[nk]
                    for rk, ov in old.items():
                        nv = nf.get(rk)
                        if (ov and nv and ov[0] == "c" and nv[0] == "c"
                                and isinstance(ov[1], int) and not isinstance(ov[1], bool)
                                and isinstance(nv[1], int) and not isinstance(nv[1], bool)
                                and ov[1] != nv[1]):
                            lf.merged_int_regs.add(rk)
                    m = meet(old, nf)
                    changed = m != old
                    facts[nk] = m
                if changed and nk not in inwork:
                    if nk in nodes:
                        work.appendleft(nk)
                    else:
                        work.append(nk)
                    inwork.add(nk)
        self.facts = facts
        if lf.need_jump_regs - lf.jump_regs:
            pending |= (lf.need_jump_regs - lf.jump_regs)
        if pending or need_restart:
            lf.jump_regs |= pending
            return s0, order, True
        if hkey[1] is not None:
            _WALK_HINTS[hkey] = (
                set(lf.jump_regs), set(lf.cff_regs), set(lf.pack_unstable),
                set(getattr(st, "carry", ())), dict(getattr(st, "vreg_of", {})), set(lf.vreg_set)
            )
        return s0, order, False

def show_op(prog, key, mode, pc, force_op=None):
    cap = prog.dump.protos[key]
    vm = prog.vm_of(cap)
    lf = ProtoLifter(vm, prog.dump, vm.vmobj_of(cap), vm.proto_of(cap),
                     LTable(), prog.globals, cap=cap)
    st = make_stepper(vm, lf)
    lines = prog.lines
    for i, ifn, w in st.loops:
        c = st.conds[i]
        k = c["right"] if c["right"]["type"] == "AstExprConstantNumber" else c["left"]
        if S.fix_int(k["value"]) != mode:
            continue
        d = [x for x in vmmap.find_dispatchers(prog.root) if x["node"] is w][0]
        arrs = {}
        for nm, keys in vm.maker_decls.items():
            if len(keys) == 1 and keys[0] in lf.maker_scope.vars:
                v = lf.maker_scope.vars[keys[0]]
                if isinstance(v, LTable) and id(v) in lf.proto_arrays:
                    arrs[nm] = v

        opname = d["arr"]
        cs = st.cs
        it = S.Interp(lf)
        _, inner = st._fresh_scopes(None, it)
        opv = it.eval(_disp_fetch_expr(w)["expr"], inner)
        op = opv.get(pc) if force_op is None else force_op
        print("mode %d pc %d: op %s (array %s)" % (mode, pc, op, opname))
        for nm, v in sorted(arrs.items()):
            print("   %s[%d] = %s" % (nm, pc, fmt_any(v.get(pc))))
        blk = vmmap.resolve(d["tree"], d["op"], op)
        print(vmmap.text_of(lines, blk) if blk else "<no handler>")
        return
    print("no loop for mode", mode)

def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("source")
    ap.add_argument("protos")
    ap.add_argument("--raw", help="print the raw listing of one proto key")
    ap.add_argument("--lift", help="lift one proto key (with its closures) to Luau")
    ap.add_argument("--op", nargs=2, metavar=("PROTO", "MODE:PC[:OP]"), help="show the handler of one instruction (OP: as decrypted)")
    ap.add_argument("--all", metavar="OUT", help="lift every VM root (what deob.py --devirt writes) into OUT")
    ap.add_argument("--chunk", action="append", default=[], metavar="FILE",
                    help="original source of a loadstring'd VM chunk (*.chunk_<key>.luau written by deob.py)")
    a = ap.parse_args()
    if a.all:
        text, stats, reqs, bufs = lift_program(a.source, a.protos, a.chunk)
        with open(a.all, "w", encoding="utf-8", newline="\n") as f:
            f.write(finish_text(text) + "\n")
        print("%d functions, %d unlifted blocks, %d unstructured jumps, %d constant requests%s"
              % (stats["functions"], stats["errors"], stats["fallbacks"], len(reqs),
                 " (%d dead guard branches dropped)" % stats["guards"] if stats.get("guards") else ""))
        print("missing constants:", LAST_DUMP[0].misses if LAST_DUMP else None)
        return
    prog = Program(a.source, a.protos, a.chunk)
    if a.op:
        show_op(prog, a.op[0], *[int(x) for x in a.op[1].split(":")])
        return
    if a.lift:
        prog.requests = set()
        cap = prog.dump.protos[a.lift]
        vm = prog.vm_of(cap)
        fl = FunctionLifter(prog)
        lines = fl.lift(vm, vm.vmobj_of(cap), vm.proto_of(cap), UpList(), {})
        import codegen
        print("\n".join(lines).replace(codegen.LONG_NL, "\n"))
        print("-- stats %s, %d constant requests" % (fl.stats, len(prog.requests)))
        return
    if a.raw:
        s0, order, lf = prog.lift_raw(a.raw)
        print("-- proto %s entry %s:%s" % (a.raw, s0.mode, s0.pc))
        for k, node in sorted(order, key=lambda kn: kn[0][1]):
            print("[%s:%d d%d]%s" % (k[0], k[1], k[2], " op %s" % (getattr(node, "op", None),) if os.environ.get("DEVIRT_TB") else ""))
            if getattr(node, "error", None):
                print("  !! " + node.error)
            for line in fmt_node(node, "  "):
                print(line)
        print("-- %d constant requests" % len(lf.requests))


class FunctionLifter:
    """Lifts one proto (and, recursively, the closures it creates) to Luau lines."""

    def __init__(self, prog):
        self.prog = prog
        self.stats = {"functions": 0, "errors": 0, "fallbacks": 0, "guards": 0}
        self.lifted = set()

    def lift(self, vm, vmobj, proto, upvals, upnames, depth=0, shared=None, init_facts=None):
        self.stats["functions"] += 1
        self.lifted.add(id(proto))
        prefix = REG_PREFIX[depth % len(REG_PREFIX)]
        cap = self.prog.dump.cap_by_self.get(proto.tid)
        if cap is None and proto.tid is not None:
            # v14.9: the closure op passes the proto as the maker's first arg,
            # so the child's capture holds it under that name (keyed by its
            # fresh upvalue table) -- adopt it when it really is this proto
            st = self.prog.dump.cap_by_state.get(proto.tid)
            if st is not None:
                k0 = st.get(vm.maker["args"][0]["name"])
                if isinstance(k0, LTable) and k0.tid == proto.tid:
                    cap = st
        if cap is not None:
            # a captured child proto: its own state tables (W/V/...) beat the
            # parent's vmobj the recursive call would otherwise reuse
            w = vm.vmobj_of(cap)
            if isinstance(w, LTable):
                vmobj = w
        lf = ProtoLifter(vm, self.prog.dump, vmobj, proto, upvals, self.prog.globals,
                         cap=cap, shared=shared if cap is None else None)
        lf.init_facts = init_facts
        lf.reg_prefix = prefix
        st = make_stepper(vm, lf)
        for _ in range(WALK_RESTARTS):
            s0, order, restart = self.prog._walk(vm, lf, st, WALK_LIMIT)
            if not restart:
                break
        self._last_lf = lf
        self.prog.requests |= lf.requests
        vreg_init_map = {
            vr: iv for vr, iv in getattr(st, "vreg_init", {}).items()
            if vr in lf.vreg_set and iv is not None
        }
        vreg_inits = []
        if vreg_init_map and order:
            import variables as VR
            used_vr = set()

            def _scan_multi(m):
                if m is None:
                    return
                for ev in getattr(m, "items", ()):
                    used_vr.update(VR.expr_reg_occ(ev))
                tl = getattr(m, "tail", None)
                if tl is not None:
                    used_vr.update(VR.expr_reg_occ(tl))

            for _, root_n in order:
                stk = [root_n]
                while stk:
                    cn = stk.pop()
                    if cn is None:
                        continue
                    for si in (cn.stmts or ()):
                        if isinstance(si, Assign):
                            if not isinstance(si.target, (Reg, Pseudo)):
                                used_vr.update(VR.expr_reg_occ(si.target))
                            if isinstance(si.value, SymList):
                                _scan_multi(si.value)
                            else:
                                used_vr.update(VR.expr_reg_occ(si.value))
                        elif isinstance(si, CallStmt):
                            used_vr.update(VR.expr_reg_occ(si.fn))
                            _scan_multi(si.args)
                        elif isinstance(si, SetList):
                            used_vr.update(VR.expr_reg_occ(si.tbl))
                            _scan_multi(si.values)
                        elif isinstance(si, ForPrep):
                            for ev in si.exprs:
                                used_vr.update(VR.expr_reg_occ(ev))
                    if cn.cond is not None:
                        used_vr.update(VR.expr_reg_occ(cn.cond))
                    if isinstance(cn.outcome, Ret):
                        _scan_multi(cn.outcome.values)
                    stk.append(cn.then)
                    stk.append(cn.els)
            vreg_inits = [
                Assign(Reg(vr), Const(iv))
                for vr, iv in sorted(vreg_init_map.items())
                if vr in used_vr
            ]
        arr_inits = [Assign(Reg("%s%d" % (REG_ARRAY, b)), S.NewTable()) for b in sorted(lf.reg_arrays)]
        if vreg_inits or arr_inits:
            k0 = s0.key(vm.kstack_link)
            for k, node in order:
                if k == k0:
                    node.stmts[0:0] = vreg_inits + arr_inits
                    break
        frames = {}
        for c in lf.children:
            if any(isinstance(e, (RegFile, FrameProxy)) for e in c.upvals):
                if id(c.proto) not in frames:
                    frames[id(c.proto)] = self.frame_regs(vm, vmobj, c)
                c.frame_map = frames[id(c.proto)]
                ub = getattr(c, "upval_base", 1)
                c.frame_regs = sorted({r for i, e in enumerate(c.upvals, ub) if isinstance(e, RegFile)
                                       for r in c.frame_map.get(i, ())})
        me = sys.modules[__name__]
        apply_frame_calls(order)
        drop_idle_closes(order, lf.captured_regs)
        lines, self.params, nerr, fallbacks = backend.lower(
            s0.key(vm.kstack_link), order, me, vm.kstack_link, prefix, upnames,
            lambda x, names: self.closure(vm, vmobj, x, names, depth, lf))
        self.stats["fallbacks"] += fallbacks
        if os.environ.get("DEVIRT_DEBUG"):
            pid = self.prog.dump.pid_of_table.get(proto.tid)
            lines.insert(0, "-- proto %s" % (pid if pid is not None else "t%s" % proto.tid))
        self.stats["errors"] += nerr
        return lines

    def frame_regs(self, vm, vmobj, c, depth=0):
        """{upvalue index: registers} a closure reads or writes through the
        register frames it captured (`s[k] = s`), found by walking it (and
        its own closures that get the frame passed through)."""
        ub = getattr(c, "upval_base", 1)
        idx = [i for i, e in enumerate(c.upvals, ub) if isinstance(e, (RegFile, FrameProxy))]
        cvm = getattr(c, "vm", None) or vm
        memo = self.__dict__.setdefault("_frame_memo", {})
        mkey = (id(c.proto), id(cvm), tuple(idx))
        if mkey in memo:
            return memo[mkey]
        uses = memo[mkey] = {}
        try:
            cap = self.prog.dump.cap_by_self.get(c.proto.tid)
            if cap is not None:
                w = cvm.vmobj_of(cap)
                if isinstance(w, LTable):
                    vmobj = w
            lf = ProtoLifter(cvm, self.prog.dump, vmobj, c.proto, UpList(idx), self.prog.globals, cap=cap)
            init_facts = dict(getattr(c, "up_facts", None) or {})
            init_facts.update(getattr(c, "_call_up_facts", None) or {})
            init_facts.update(getattr(c, "arg_facts", None) or {})
            lf.init_facts = init_facts
            lf.walk_only = True
            st = make_stepper(cvm, lf)
            for _ in range(WALK_RESTARTS):
                _, _, restart = self.prog._walk(cvm, lf, st, WALK_LIMIT)
                if not restart:
                    break
        except Unsupported:
            return uses
        for i, r in lf.frame_uses:
            uses.setdefault(i, set()).add(r)
        if depth < 8:
            for g in lf.children:
                if any(isinstance(e, FrameProxy) for e in g.upvals):
                    g_ub = getattr(g, "upval_base", 1)
                    for gi, regs in self.frame_regs(cvm, vmobj, g, depth + 1).items():
                        e = g.upvals[gi - g_ub]
                        if isinstance(e, FrameProxy):
                            uses.setdefault(e.idx, set()).update(regs)
        return uses

    def closure(self, vm, vmobj, c, parent_names, depth, parent_lf=None):
        import codegen as CG
        proto = c.proto
        ub = getattr(c, "upval_base", 1)
        if isinstance(proto, PlainProto):
            capnames = getattr(c, "capnames", {})
            upnames = {}
            for i, e in enumerate(c.upvals, ub):
                if isinstance(e, Reg):
                    upnames[i] = capnames.get(e.n, "r%s" % e.n)
            text = proto.render(capnames, upnames, fl=self, vm=vm, vmobj=vmobj, depth=depth, parent_lf=parent_lf)
            f = CG.FuncE(text.splitlines())
            f.captures = set(upnames.values())
            return f
        if id(proto) in self.lifted:
            return CG.FuncE(["function(...) --[[ recursive proto ]] end"])
        capnames = getattr(c, "capnames", {})
        upnames = {}
        fmap = getattr(c, "frame_map", {})
        for i, e in enumerate(c.upvals, ub):
            if isinstance(e, RegFile):

                for r in fmap.get(i, ()):
                    upnames[(i, r)] = capnames.get(r, "nil")
            elif isinstance(e, FrameProxy):

                for r in fmap.get(i, ()):
                    upnames[(i, r)] = parent_names.get(("up", (e.idx, r)), "upv%d_%d" % (e.idx, r))
            elif isinstance(e, LTable):
                vals = list(e.h.values())
                ints = [v for v in vals if isinstance(v, int)]
                if any(isinstance(v, RegFile) for v in vals) and ints:
                    upnames[i] = capnames.get(ints[0], "nil")
                else:

                    ups = [v for v in vals if isinstance(v, UpContainer)]
                    upnames[i] = parent_names.get(("up", ups[0].idx), "upv%d" % ups[0].idx) if ups else "nil"
            elif isinstance(e, Reg):
                upnames[i] = capnames.get(e.n, "nil")
            elif isinstance(e, MaybeBox):
                upnames[i] = capnames.get(e.reg, "nil")
            elif isinstance(e, (BoxProxy, Upval)):
                upnames[i] = parent_names.get(("up", e.idx), "upv%d" % e.idx)
            else:
                upnames[i] = "nil"
        params = ["..."]
        fidx = [i for i, e in enumerate(c.upvals, ub) if isinstance(e, (RegFile, FrameProxy))]
        cvm = getattr(c, "vm", None) or vm

        init_facts = dict(getattr(c, "up_facts", None) or {})
        init_facts.update(getattr(c, "_call_up_facts", None) or {})
        init_facts.update(getattr(c, "arg_facts", None) or {})
        ckey = (id(proto), id(cvm), tuple(fidx), depth, tuple(sorted(upnames.items(), key=repr)), tuple(sorted(init_facts.items(), key=repr)))
        memo = self.__dict__.setdefault("_closure_memo", {})
        if ckey in memo:
            lines, params = memo[ckey]
        elif os.environ.get("DEVIRT_SHALLOW"):
            # memory escape hatch: lift each proto's own instructions only;
            # children become markers that a per-proto --lift run fills in
            # (deep single-process chains OOM the container)
            pid = self.prog.dump.pid_of_table.get(proto.tid)
            tag = "p%s" % pid if pid is not None else "t%s" % proto.tid
            memo[ckey] = (["__DEVIRT_CHILD__(%s)" % tag], ["..."])
            lines, params = memo[ckey]
        else:
            try:
                sh = dict(getattr(c, "shared_cap", None) or {})
                # a child without its own capture (a path the trace never
                # took) still needs the VM's shared values (the state table
                # S, ...): fall back to the parent's by-name captures
                sh.update(getattr(parent_lf, "cap_fallback", {}) or {})
                lines = self.lift(cvm, getattr(c, "state_table", None) or vmobj, proto,
                                  UpList(fidx), upnames, depth + 1,
                                  shared=sh, init_facts=init_facts)
                params = self.params
                child_lf = getattr(self, "_last_lf", None)
                if child_lf is not None and parent_lf is not None:
                    mut_ups = getattr(child_lf, "mutated_upvals", None) or ()
                    if mut_ups:
                        for ui, u in enumerate(c.upvals, ub):
                            if ui not in mut_ups:
                                continue
                            if isinstance(u, (BoxProxy, Upval)):
                                parent_lf.__dict__.setdefault("mutated_upvals", set()).add(u.idx)
                            else:
                                from obfuscators.luraph_v15.dataflow import _upval_open_reg
                                ureg = _upval_open_reg(u)
                                if ureg is not None:
                                    parent_lf.__dict__.setdefault("rcf_post_cap_poisoned", set()).add(ureg)
                                    rcf = getattr(parent_lf, "reg_const_fact", None)
                                    if rcf is not None:
                                        rcf.pop(ureg, None)
                                    for sib in getattr(parent_lf, "children", ()):
                                        sib_uf = getattr(sib, "up_facts", None)
                                        sib_open = getattr(sib, "_open_up_regs", None) or {}
                                        if sib_uf:
                                            for sui, sureg in list(sib_open.items()):
                                                if sureg == ureg:
                                                    sib_uf.pop(("up", sui), None)
            except Unsupported as ex:
                lines = ["error(\"devirt: could not lift closure: %s\")" % str(ex).replace("\"", "'")]
                params = ["..."]
            except Exception as ex:
                # one broken function must not abort the whole 1000-function run:
                # mark it explicitly and keep lifting the rest (same convention
                # as the "unexplored successor" markers).
                import traceback
                pid = self.prog.dump.pid_of_table.get(proto.tid)
                tb_last = traceback.extract_tb(ex.__traceback__)[-1] if ex.__traceback__ else None
                loc_s = " at %s:%s" % (os.path.basename(tb_last.filename), tb_last.lineno) if tb_last else ""
                print("[!] lifting closure %s failed: %s: %s%s (stubbed with an error marker)"
                      % ("#%s" % pid if pid is not None else "t%s" % proto.tid,
                         type(ex).__name__, ex, loc_s), file=sys.stderr)
                if os.environ.get("DEVIRT_TB"):
                    traceback.print_exc()
                lines = ["error(\"devirt: could not lift closure: %s: %s\")"
                         % (type(ex).__name__, str(ex).replace("\"", "'"))]
                params = ["..."]
            memo[ckey] = (lines, params)
        self.lifted.discard(id(proto))
        # deep proto chains hold every level's lower() frame; collect the
        # cyclic garbage periodically so the peak stays bounded
        gc_counter = self.__dict__.setdefault("_gc_i", 0) + 1
        self._gc_i = gc_counter
        if gc_counter % 32 == 0:
            import gc
            gc.collect()
        f = CG.FuncE(["function(%s)" % ", ".join(params)] + ["\t" + l for l in lines] + ["end"])
        f.captures = set(upnames.values())
        return f

def stmt_exprs(st):
    import codegen as CG
    out = []
    if isinstance(st, CG.AssignS):
        out += [t for t in st.targets]
        out += list(st.values.items)
    elif isinstance(st, (CG.CallS, CG.TempDef)):
        out.append(st.call)
    elif isinstance(st, CG.SetListS):
        out.append(st.tbl)
        out += list(st.values.items)
    return out

def _proto_reaches(src_proto, dst_proto, vmobj):
    if not isinstance(src_proto, LTable) or not isinstance(dst_proto, LTable):
        return False
    if src_proto is dst_proto:
        return True
    seen = {id(src_proto)}
    if vmobj is not None:
        seen.add(id(vmobj))
    stack = [src_proto]
    target = id(dst_proto)
    while stack:
        t = stack.pop()
        for v in t.h.values():
            if isinstance(v, LTable):
                vid = id(v)
                if vid == target:
                    return True
                if vid not in seen:
                    seen.add(vid)
                    stack.append(v)
    return False

def _vm_roots(prog):
    """[(maker tag, [(seq, pid, cap), ...] sorted)] with the payload VM last, and its tag."""
    raw_by_maker = {}
    meta_by_maker = {}
    for key, cap in prog.dump.protos.items():
        mtag = cap.get("__maker")
        if mtag is None:
            continue
        mtag_s = mtag.decode("latin-1") if isinstance(mtag, bytes) else str(mtag)
        if mtag_s.startswith("plain:"):
            continue
        vm = prog.vms.get(mtag_s)
        info = getattr(vm, "info", {}) if vm is not None else {}
        vmobj = vm.vmobj_of(cap) if vm is not None else cap.get("self")
        raw_by_maker.setdefault(mtag, []).append((cap.get("__seq") or 0, key, cap))
        if mtag not in meta_by_maker:
            meta_by_maker[mtag] = (mtag_s, vm, info, vmobj)

    group_tag = {}
    roots_by_gk = {}
    for mtag, lst in sorted(raw_by_maker.items(), key=lambda kv: min(x[0] for x in kv[1])):
        mtag_s, vm, info, vmobj = meta_by_maker[mtag]
        root_cap = min(lst, key=lambda x: (x[0], x[1]))[2]
        root_proto = vm.proto_of(root_cap) if vm is not None else root_cap.get("self")
        if not info.get("curried3") and vmobj is not None and "@" in mtag_s:
            gk = (mtag_s.split("@", 1)[0], id(vmobj))
            merged = None
            for prev_tag, prev_proto in roots_by_gk.get(gk, ()):
                if _proto_reaches(prev_proto, root_proto, vmobj) or _proto_reaches(root_proto, prev_proto, vmobj):
                    merged = prev_tag
                    break
            if merged is not None:
                group_tag[mtag] = merged
            else:
                group_tag[mtag] = mtag
                roots_by_gk.setdefault(gk, []).append((mtag, root_proto))
        else:
            group_tag[mtag] = mtag

    by_vm = {}
    for mtag, lst in raw_by_maker.items():
        by_vm.setdefault(group_tag[mtag], []).extend(lst)

    vms = sorted(by_vm.items(), key=lambda kv: min(x[0] for x in kv[1]))
    payload = vms[-1][0] if vms else None
    vms.sort(key=lambda kv: kv[0] == payload)
    for _, lst in vms:
        lst.sort(key=lambda x: (x[0], x[1]))

    max_min_seq = max((min(x[0] for x in lst) for _, lst in vms), default=0)
    rc = prog.dump.raw.get("root_callee")
    for tag, lst in vms:
        hit = [x for x in lst if rc is not None and str(x[1]) == str(rc)]
        if hit and (tag == payload or hit[0][0] >= max_min_seq):
            lst.remove(hit[0])
            lst.insert(0, hit[0])
            payload = tag
            vms.sort(key=lambda kv: kv[0] == payload)
            break
    return vms, payload

def program_roots(prog):
    """[(tag, pid, cap)] of the root protos lift_program lifts, in order."""
    vms, payload = _vm_roots(prog)
    loaders = bool(os.environ.get("DEVIRT_LOADERS"))
    return [(tag, lst[0][1], lst[0][2]) for tag, lst in vms if tag == payload or loaders]

def _drop_dead_upvalue_writes(lines):
    """A VM upvalue that is written exactly once, with a constant, is scratch
    of Luraph's anti-tamper check (the decoy `upv84 = "items"` next to a hash
    that no decoder can reproduce): nothing can read it, so the assignment
    carries no behaviour. Only names that occur once in the whole chunk are
    dropped, so no value the payload can observe is touched."""
    pat = re.compile(r"^\s*(upv\d+)\s*=\s*-?[\w.\"']+\s*$")
    used = {}
    for l in lines:
        for m in re.finditer(r"\bupv\d+\b", l):
            used[m.group(0)] = used.get(m.group(0), 0) + 1
    keep = []
    dropped = 0
    for l in lines:
        m = pat.match(l)
        if m is not None and used.get(m.group(1)) == 1:
            dropped += 1
            continue
        keep.append(l)
    return keep, dropped


def lift_program(source, protos_path, chunk_paths=(), fetch=None):
    """The root proto of every VM -> Luau text (plus stats and constant requests)."""
    prog = Program(source, protos_path, chunk_paths)
    prog.dump.fetcher = fetch
    LAST_DUMP[:] = [prog.dump]
    prog.requests = set()
    fl = FunctionLifter(prog)
    out = []
    vms, payload = _vm_roots(prog)
    payload_pid = None

    loaders = bool(os.environ.get("DEVIRT_LOADERS"))
    for tag, lst in vms:
        _, pid, cap = lst[0]          
        where = tag.decode("latin-1")
        if tag != payload and not loaders:
            if os.environ.get("DEVIRT_DEBUG"):
                out.append("-- (Luraph loader VM %s, %d protos: not part of the script, not lifted)"
                           % (where, len(lst)))
            continue
        try:
            vm = prog.vm_of(cap)
        except Unsupported as ex:
            out.append("-- VM %s: root proto #%s not lifted: %s" % (where, pid, ex))
            out.append("")
            continue
        proto = vm.proto_of(cap)
        vmobj = vm.vmobj_of(cap)
        role = "the script" if tag == payload else "Luraph loader, not called"
        if loaders or os.environ.get("DEVIRT_DEBUG"):
            out.append("-- VM %s: root proto #%s (%d protos captured; %s)" % (where, pid, len(lst), role))
        if tag == payload:
            payload_pid = pid
        arg1 = prog.dump.proto_arg1.get(int(pid)) if str(pid).isdigit() else None
        init_facts = {("vararg", 1): ("c", arg1)} if isinstance(arg1, (int, float)) else None
        lines = fl.lift(vm, vmobj, proto, UpList(), {}, 0, init_facts=init_facts)
        if tag == payload and not loaders:
            out.append("")
            params = [p for p in fl.params if p != "..."]
            if params:
                out.append("local %s = ..." % ", ".join(params))
            out += lines
            payload_pid = None
            continue
        out.append("local function vm_root_%s(%s)" % (pid, ", ".join(fl.params)))
        out += ["\t" + l for l in lines]
        out.append("end")
        out.append("")
    if payload_pid is not None:
        out.append("return vm_root_%s(...)" % payload_pid)

    shared = []
    if getattr(prog.dump, "needs_u32_trunc", False):
        shared += ["local function u32Trunc(x)",
                   "\tx %= 4294967296",
                   "\treturn if x == x then x // 1 else 0",
                   "end", ""]
    if getattr(prog.dump, "needs_u32_mul", False):
        shared += ["local function u32Mul(a, b)",
                   "\ta, b = bit32.band(a, 4294967295), bit32.band(b, 4294967295)",
                   "\treturn bit32.band(bit32.band(a, 65535) * b + bit32.lshift(bit32.rshift(a, 16) * bit32.band(b, 65535), 16), 4294967295)",
                   "end", ""]
    if getattr(prog.dump, "needs_setlist", False):
        shared += ["local function _lph_setlist(t, off, ...)",
                   "\tlocal p = table.pack(...)",
                   "\ttable.move(p, 1, p.n, off + 1, t)",
                   "end", ""]
    for n in sorted(prog.dump.shared.values()):
        shared += ["-- Luraph runtime function (from the VM object, not part of the script: not lifted).",
                   "-- LPH_ENCFUNC decrypts a function this way: (key, encrypted buffer, ...) -> function.",
                   "local function luraph_runtime%d(...)" % n,
                   "\terror(\"Luraph runtime function, not devirtualized\")",
                   "end", ""]
    if shared:
        at = next((i for i, l in enumerate(out) if l and not l.startswith("--")), len(out))
        out[at:at] = shared
    import structure as _ST
    fl.stats["guards"] = sum(_ST.GUARD_DROPS)
    _ST.GUARD_DROPS[:] = []
    out, dead = _drop_dead_upvalue_writes(out)
    if dead:
        fl.stats["dead_upvalue_writes"] = fl.stats.get("dead_upvalue_writes", 0) + dead
    text = backend.polish("\n".join(out))
    if os.environ.get("DEVIRT_MISS"):
        print("[miss] %r" % (dict(prog.dump.misses),), file=sys.stderr)
        print("[miss] fetched=%d requests=%d" % (len(getattr(prog.dump, "fetched", ())), len(prog.requests)),
              file=sys.stderr)
    return text, fl.stats, prog.requests, buffer_patches(prog.dump)

finish_text = backend.finish_text


run_big_stack = backend.run_big_stack

if __name__ == "__main__":
    run_big_stack(main)
