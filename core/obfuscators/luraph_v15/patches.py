"""Luraph v15 dynamic constant/buffer request patching and multi-round walk cache."""
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
from obfuscators.luraph_v15.dump import (
    PatchLog, LAST_DUMP, buffer_patches, stable_patches, format_patches, same_patches, PathResolver,
)
from obfuscators.luraph_v15.dataflow import UpList
from obfuscators.luraph_v15.vm_model import WALK_LIMIT, WALK_RESTARTS
from obfuscators.luraph_v15.stepper import _JIT_TAGGED, make_stepper
from obfuscators.luraph_v15.lifter import ProtoLifter

class WalkCache:
    """Results of walking single protos (collect_requests), kept across
    constant rounds by the proto's table path. A walk that asked for no
    constant (and missed none) sees the same data next round, so it is not
    repeated. Table ids differ between runs and so can the shortest path to a
    table (ties), so stored paths are resolved by walking them (PathResolver)."""

    def __init__(self):
        self.entries = {}       

def collect_requests(source, protos_path, chunk_paths=(), cache=None, fetch=None):
    """What an intermediate constant round needs from lift_program, without
    the structuring/codegen/naming: every proto lift_program would lift is
    walked (SCCP, which is where requests and in-place decryption happen),
    its closures followed. -> (stats, requests, buffer patches)."""
    from obfuscators.luraph_v15 import devirt as _d
    prog = _d.Program(source, protos_path, chunk_paths)
    LAST_DUMP[:] = [prog.dump]
    dump = prog.dump
    if cache is None:
        cache = WalkCache()
    paths = dump.paths()
    pkey = {tid: ",".join(str(x) for x in p) for tid, p in paths.items()}
    res = PathResolver(dump)
    live = {}
    for (path, vmid, fkey), ent in cache.entries.items():
        t = res.get(path)
        if t is not None:
            live[(t.tid, vmid, fkey)] = (path, ent)
    kept = {}
    stats = {"functions": 0, "errors": 0, "fallbacks": 0, "walked": 0}
    requests = set()
    bw, tw = PatchLog(), PatchLog()
    dump.fetcher = fetch
    dump.extra_patches = (bw, tw)
    todo = []
    for tag, pid, cap in reversed(_d.program_roots(prog)):
        try:
            vm = prog.vm_of(cap)
        except Unsupported:
            continue
        arg1 = dump.proto_arg1.get(int(pid)) if str(pid).isdigit() else None
        init_facts = {("vararg", 1): ("c", arg1)} if isinstance(arg1, (int, float)) else {}
        todo.append((vm, vm.vmobj_of(cap), vm.proto_of(cap), init_facts))
    seen = set()
    while todo:
        vm, vmobj, proto, init_facts = todo.pop()
        if id(proto) in seen:
            continue
        seen.add(id(proto))
        fkey = repr(sorted((init_facts or {}).items()))
        found = live.get((proto.tid, id(vm), fkey))
        use = found and _translate(found[1], res, pkey)
        if use:
            kept[(found[0], id(vm), fkey)] = found[1]
            ent = found[1]
            kids, ebw, etw = use
        else:
            ent = _walk_one(prog, vm, vmobj, proto, pkey, init_facts=init_facts)
            stats["walked"] += 1
            key = pkey.get(proto.tid)
            if key is not None and ent["clean"]:
                kept[(key, id(vm), fkey)] = ent
            kids = [res.get(c) if isinstance(c, str) else c for c in ent["children"]]
            ebw, etw = ent["bw"], ent["tw"]
        stats["functions"] += 1
        stats["errors"] += ent["errors"]
        requests |= ent["requests"]
        bw.update(ebw)
        tw.update(etw)
        kvms = [prog.vms.get(t) or _JIT_TAGGED.get(t) or vm for t in ent.get("child_vms") or [None] * len(kids)]
        kfacts = ent.get("child_facts") or [{} for _ in kids]
        todo += [(kvm, vmobj, c, cf) for c, kvm, cf in reversed(list(zip(kids, kvms, kfacts))) if c is not None]
    cache.entries = kept
    stats["fetched"] = len(dump.fetched)
    if os.environ.get("DEVIRT_TIMING") and dump.fetched:
        print("[*]   live requests: %d, patches %.1fs, round trips %.1fs (harness %.1fs), %d KB of patches sent"
              % ((len(dump.fetched),) + tuple(dump.fetch_time[:3]) + (dump.fetch_time[3] // 1024,)),
              file=sys.stderr)
    prog.requests = requests
    return stats, requests, format_patches(bw, tw)

def _walk_one(prog, vm, vmobj, proto, pkey, init_facts=None):
    dump = prog.dump
    saved = dump.buf_patch, dump.tab_patch
    dump.buf_patch, dump.tab_patch = PatchLog(), PatchLog()
    nmiss = sum(dump.misses.values())
    ent = {"requests": set(), "children": [], "child_facts": [], "errors": 0, "clean": False, "bw": {}, "tw": {}}
    try:
        lf = ProtoLifter(vm, dump, vmobj, proto, UpList(), prog.globals,
                         cap=dump.cap_by_self.get(proto.tid))
        if init_facts:
            lf.init_facts.update(init_facts)
        lf.walk_only = True
        st = make_stepper(vm, lf)
        for _ in range(WALK_RESTARTS):
            s0, order, restart = prog._walk(vm, lf, st, WALK_LIMIT)
            if not restart:
                break
    except Unsupported:
        ent["errors"] = 1
        return ent
    finally:
        ent["bw"], ent["tw"] = stable_patches(dump)
        dump.buf_patch, dump.tab_patch = saved
    ent["requests"] = lf.requests
    ent["errors"] = sum(1 for _, n in order if getattr(n, "error", None))
    if os.environ.get("DEVIRT_ERRS"):
        for s, n in order:
            if getattr(n, "error", None):
                print("[walk] %s %s %s" % (pkey.get(proto.tid, proto.tid), s[:2], n.error),
                      file=sys.stderr)
    kids = [c for c in lf.children if isinstance(c.proto, LTable)]
    ent["children"] = [pkey.get(c.proto.tid, c.proto) for c in kids]
    ent["child_vms"] = [getattr(getattr(c, "vm", None), "tag", None) for c in kids]
    cfacts = []
    for c in kids:
        cf = dict(getattr(c, "up_facts", None) or {})
        cf.update(getattr(c, "_call_up_facts", None) or {})
        cf.update(getattr(c, "arg_facts", None) or {})
        cfacts.append(cf)
    ent["child_facts"] = cfacts
    ent["clean"] = not lf.requests and sum(dump.misses.values()) == nmiss and \
        all(isinstance(c, str) for c in ent["children"])
    return ent

def _translate(ent, res, pkey):
    """A cached entry's paths -> this dump: (child tables, buffer patches,
    table patches), patches keyed by the current shortest path (the one the
    runtime looks up); None if a path no longer resolves."""
    kids = []
    for c in ent["children"]:
        t = res.get(c)
        if t is None:
            return None
        kids.append(t)
    out = []
    for d in (ent["bw"], ent["tw"]):
        nd = {}
        for k, v in d.items():
            t = res.get(k[0])
            if t is None or t.tid not in pkey:
                return None
            nd[(pkey[t.tid],) + k[1:]] = v
        out.append(nd)
    return kids, out[0], out[1]

