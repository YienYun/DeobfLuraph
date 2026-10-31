"""Luraph v15 runtime dump reader, constant/buffer patch log, and shared value wrappers."""
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

REG_PREFIX = "r"
REG_ARRAY = "__R"
LAST_DUMP = []

class PatchLog(dict):
    """A patch dict that remembers the keys written since the last `take()`
    (live requests send only what changed)."""

    def __init__(self, *a):
        super().__init__(*a)
        self.dirty = set(self)

    def __setitem__(self, k, v):
        super().__setitem__(k, v)
        self.dirty.add(k)

    def update(self, other=(), **kw):
        for k, v in dict(other, **kw).items():
            self[k] = v

    def take(self):
        d, self.dirty = self.dirty, set()
        return d

class Dump:
    def __init__(self, path):
        opener = gzip.open if str(path).endswith(".gz") else open
        with opener(path, "rt", encoding="utf-8") as f:
            d = json.load(f)
        self.raw = d
        self.tables = {}
        self.lfs = {}
        self.shared = {}        
        self.buf_loc = {}       
        self._load_tables(d["tables"])

        self.buf_patch = PatchLog()
        self.misses = {}
        self.vm_names = {"e"}     

        self.tab_patch = PatchLog()
        self.tid_of = {id(t): tid for tid, t in self.tables.items()}
        self.lazy = {int(tid) for tid, t in d["tables"].items() if t.get("mt")}

        self.decoder = {int(tid): json.dumps(t["mtf"]) for tid, t in d["tables"].items() if t.get("mtf")}

        self.overrides = {path: self.val(v) for path, v in d.get("overrides", [])}
        self.pid_of_table = {int(k): v for k, v in d["pid_of_table"].items()}
        self.proto_arg1 = {int(k): v for k, v in (d.get("proto_arg1") or {}).items()}
        self.protos = {}
        for key, cap in d["protos"].items():
            self.protos[key] = {k: self.val(v) for k, v in cap.items()}
        self._paths = None
        self.late = self._lazy_late(d)

        self._by_operand = self._operand_facts()

        self.fetcher = None
        self.fetched = set()
        self._fetched_any = False
        self.fetch_time = [0.0, 0.0, 0.0, 0]    
        self.extra_patches = (PatchLog(), PatchLog())   
        self._sent = {}         

    def _lazy_late(self, d):
        """Lazy constants decoded at run time from an instruction's decoded
        operand, in a proto the runtime restored to its pre-run state (envlog
        CHAIN.unscramble, "late": [slot, ...]). The dump's operand is the
        undecoded one again, so they are not plain slots: they hold for the
        operand the lifter decodes for that instruction (each decodes once).
        -> {(tid, slot): value}"""
        late = {}
        for tid, t in d["tables"].items():
            for k in t.get("late") or ():
                key = S.norm_key(self.val(k))
                v = self.tables[int(tid)].h.pop(key, None)
                if v is not None:
                    late[(int(tid), key)] = v
        return late

    def _load_tables(self, tables):
        for tid in tables:
            self.tables[int(tid)] = LTable(tid=int(tid))
        for tid, t in tables.items():
            tb = self.tables[int(tid)]
            for i, v in enumerate(t["arr"], 1):
                if v is not None:
                    tb.h[i] = self.val(v)
                    if isinstance(tb.h[i], Buf):
                        self.buf_loc[id(tb.h[i])] = (tb.h[i], int(tid), i)
            for k, v in t["kv"]:
                kk = self.val(k)
                vv = self.val(v)
                if vv is not None:
                    tb.h[("opaque", id(kk)) if isinstance(kk, Expr) else S.norm_key(kk)] = vv
                    if isinstance(vv, Buf) and isinstance(kk, int):
                        self.buf_loc[id(vv)] = (vv, int(tid), kk)

    def fetch(self, rq):
        """A missing lazy constant (request path `rq`) decoded right away by
        the live harness, instead of in the next constant round. Its new
        tables join the dump. -> the value, or None (no harness, failed,
        or asked before)."""
        if self.fetcher is None or rq in self.fetched:
            return None
        self.fetched.add(rq)
        t0 = time.time()

        bw, tw = self._patch_delta()
        send = "+" + format_patches(bw, tw) if bw or tw else "="
        t1 = time.time()
        try:

            first = not self._fetched_any
            self._fetched_any = True
            d = json.loads(self.fetcher([("*" if first else "") + rq], send))
            if os.environ.get("DEVIRT_MISS"):
                # per-path answer of the live decode: DEVIRT_MISS=<substr> filters
                want = os.environ.get("DEVIRT_MISS")
                if not want or want in rq:
                    print("-- fetch %r -> %r %s" % (rq, [p_ for p_, _ in (d.get("values") or [])],
                                                    d.get("dbg") or ""), file=sys.stderr)
            ft = self.fetch_time
            ft[0] += t1 - t0
            ft[1] += time.time() - t1
            ft[2] += d.get("t", 0)
            ft[3] += len(send)
        except Exception as ex:  
            print("[!] live constant request failed (%s): back to constant rounds" % str(ex)[:200],
                  file=sys.stderr)
            self.fetcher = None
            return None

        new = {tid: t for tid, t in (d.get("tables") or {}).items() if int(tid) not in self.tables}
        self._load_tables(new)
        for tid, t in new.items():
            if t.get("mt"):
                self.lazy.add(int(tid))
            if t.get("mtf"):
                self.decoder[int(tid)] = json.dumps(t["mtf"])
            self.tid_of[id(self.tables[int(tid)])] = int(tid)
        new_protos = d.get("new_protos") or {}
        if new_protos:
            by_suffix = getattr(self, "by_suffix", {})
            plain_by_suffix = getattr(self, "plain_by_suffix", {})
            for key, cap in new_protos.items():
                pcap = {k: self.val(v) for k, v in cap.items()}
                mk = pcap.get("__maker")
                if mk is not None:
                    tag = mk.decode("latin-1") if isinstance(mk, bytes) else str(mk)
                    if tag.startswith("plain:"):
                        if tag not in getattr(self, "plain_makers", {}):
                            hit = plain_by_suffix.get(tag.rpartition("@")[2])
                            if hit is not None:
                                pcap["__maker"] = hit.encode("latin-1")
                    elif tag not in getattr(self, "vms", {}):
                        hit = by_suffix.get(tag.rpartition("@")[2])
                        if hit is not None:
                            pcap["__maker"] = hit.encode("latin-1")
                self.protos[key] = pcap
                sv = pcap.get("self")
                if isinstance(sv, LTable) and hasattr(self, "cap_by_self"):
                    self.cap_by_self[sv.tid] = pcap
            self._paths = None
        val = None
        for path, v in d.get("values") or []:
            val = self.val(v)
            if val is None:
                continue
            self.overrides[path] = val
            if path.startswith("!"):
                continue
            pre, _, last = path.rpartition(",")
            op = last.partition("@")[2]
            t = PathResolver(self).get(pre)
            if t is not None and op:
                self._add_operand(self._by_operand, t.tid, op, val)
            elif t is not None:

                k = int(last) if re.fullmatch(r"-?\d+", last) else last.encode("latin-1")
                t.h[S.norm_key(k)] = val
            if isinstance(val, LTable) and self._paths is not None and val.tid not in self._paths \
                    and not path.startswith("!"):
                self._extend_paths(val, path.split(","))
        return val

    def _patch_delta(self):
        """Stable patches written since the last live request that the
        harness session does not have yet: (bytes, table entries)."""
        paths = self.paths()
        bw, tw = {}, {}
        fbw = getattr(self, "_fast_bw_delta", None)
        if fbw:
            bw.update(fbw)
            fbw.clear()
        ftw = getattr(self, "_fast_tw_delta", None)
        if ftw:
            tw.update(ftw)
            ftw.clear()
        for d in (self.extra_patches[0], self.extra_patches[1]):
            for k in d.take():
                if k in d:
                    (bw if len(k) == 3 else tw)[k] = d[k]
        for bid, off in self.buf_patch.take():
            v = self.buf_patch.get((bid, off))
            buf, tid, key = self.buf_loc[bid]
            if isinstance(v, int) and buf.data[off] != v and tid in paths:
                bw[(",".join(str(x) for x in paths[tid]), key, off)] = v
        for tid, key in self.tab_patch.take():
            v = self.tab_patch.get((tid, key))
            base = self.tables[tid].h.get(key)
            if tid in paths and not (isinstance(base, (int, float)) and base == v):
                tw[(",".join(str(x) for x in paths[tid]), key)] = v
        for d in (bw, tw):
            for k in [k for k, v in d.items() if self._sent.get(k, d) == v]:
                del d[k]
            if len(self._sent) < 50000:
                self._sent.update(d)
        return bw, tw

    def _extend_paths(self, root, path):
        paths = self._paths
        paths[root.tid] = path
        queue = [root]
        i = 0
        while i < len(queue):
            t = queue[i]
            i += 1
            for k, v in t.h.items():
                if isinstance(v, LTable) and v.tid not in paths and isinstance(k, int):
                    paths[v.tid] = paths[t.tid] + [k]
                    queue.append(v)

    def miss(self, why):
        self.misses[why] = self.misses.get(why, 0) + 1

    def same_operand(self, rq, tid):
        """A lazy constant depends only on the operand it is decoded from
        (`path,slot@v`): the operand indexes the constant pool of the table's
        decoder (its shared `__index` metamethod, "mtf" in the dump; one per
        VM implementation), so any table with the same decoder decoded for
        the same v (a plain slot t[k] with t[0][k] == v, or another `@v`
        result) gives the value without a request. Only scalars and flat
        tables of scalars (upvalue descriptors, rebuilt per decode): child
        protos are distinct objects. Without this a branch on such a constant
        stopped the walk once per round (StealAnEgg: one step per round)."""
        op = rq.rpartition(",")[2].partition("@")[2]
        hit = self._by_operand.get((self.decoder.get(tid, tid), op))
        return hit[1] if hit and hit[0] is not None else None

    def _operand_facts(self):
        """(decoder, operand) -> (signature, value) for same_operand."""
        by = {}

        def add(tid, op, v):
            self._add_operand(by, tid, op, v)
        res = PathResolver(self)
        for path, v in self.overrides.items():
            pre, _, last = path.rpartition(",")
            slot, at, op = last.partition("@")
            if at:
                t = res.get(pre)
                add(t.tid if t is not None else None, op, v)
        for lt in self.lazy:
            t = self.tables[lt]
            k0 = t.h.get(0)
            if not isinstance(k0, LTable):
                for nk in (-1, -2, -3, -4):
                    cand = t.h.get(nk)
                    if isinstance(cand, LTable) and any(isinstance(ck, int) and ck >= 1 for ck in cand.h):
                        k0 = cand
                        break
            if not isinstance(k0, LTable):
                continue
            for k, v in t.h.items():
                op = k0.h.get(k) if type(k) is int and k >= 1 else None
                if type(op) in (int, float):
                    add(lt, S.fmt_num(op), v)
        return by

    def _add_operand(self, by, tid, op, v):
        if v is None or tid is None:
            return
        if isinstance(v, LTable):
            if any(isinstance(x, (LTable, OpaqueFn, Buf)) for x in v.h.values()):
                return
            sig = ("t", tuple(sorted((repr(k), repr(x)) for k, x in v.h.items())))
        elif isinstance(v, (bytes, int, float, bool)):
            sig = ("v", type(v).__name__, repr(v))
        else:
            return
        key = (self.decoder.get(tid, tid), op)
        old = by.get(key)
        if old is None:
            by[key] = (sig, v)
        elif old[0] != sig:
            by[key] = (None, None)      

    def paths(self):
        """Shortest path to every table from a captured proto: [seq, name, key, key, ...]."""
        if self._paths is None:
            paths = {}
            queue = []
            for cap in self.protos.values():
                seq = cap.get("__seq")
                if seq is None:
                    continue
                for nm, v in cap.items():
                    if isinstance(v, LTable) and v.tid not in paths:
                        paths[v.tid] = [seq, nm]
                        if nm not in self.vm_names:   
                            queue.append(v)

            for rq, v in self.overrides.items():
                if isinstance(v, LTable) and v.tid not in paths and not rq.startswith("!"):
                    paths[v.tid] = rq.split(",")
                    queue.append(v)
            i = 0
            while i < len(queue):
                t = queue[i]
                i += 1
                for k, v in t.h.items():
                    if isinstance(v, LTable) and v.tid not in paths and isinstance(k, int):
                        paths[v.tid] = paths[t.tid] + [k]
                        queue.append(v)
            self._paths = paths
        return self._paths

    def val(self, v):
        if v is None or isinstance(v, bool):
            return v
        if isinstance(v, (int, float)):
            return S.fix_int(v)
        if "s" in v:
            return bytes.fromhex(v["s"])
        if "t" in v:
            return self.tables[v["t"]]
        if "f" in v:
            return Builtin(v["f"])
        if "lf" in v:
            f = self.lfs.get(v["lf"])
            if f is None:
                f = self.lfs[v["lf"]] = OpaqueFn(v["lf"])
            pf = v.get("pf")
            if pf is not None and "t" in pf:
                f.pf_tid = pf["t"]
            return f
        if "num" in v:
            return {"inf": float("inf"), "-inf": float("-inf"), "nan": float("nan"), "-0": -0.0}[v["num"]]
        if "b" in v:
            return Buf(bytes.fromhex(v["b"]))
        if "g" in v:
            return EnvTable() if v["g"] == "ENV" else Builtin(v["g"])
        if "vec" in v:
            return Vec([S.fix_int(self.val(x)) for x in v["vec"]])
        src = v.get("src") or ""
        return Opaque(v.get("u"), bytes.fromhex(src).decode("utf-8", "replace") if src else "")

class OpaqueFn:
    """A Lua function value from the dump; bound to its AST later if known."""

    def __init__(self, lfid):
        self.lfid = lfid
        self.node = None
        self.pf_tid = None      

class FrameArg(Global):
    """The caller's register frame passed as a call argument (a register
    holding the frame, `s[k] = s`, in the argument range). LPH_ENCSTR-style
    decryptors store their result into it (Program._walk evaluates such calls
    in the runtime, see frame_call); if one stays unevaluated it renders as nil."""

    def __init__(self, reg):
        Global.__init__(self, "nil --[[ the caller's registers ]]")
        self.reg = reg

class RuntimeMaker:
    """The closure maker looked up for a proto that exists only at runtime
    (ProtoLifter.index): calling it gives that value itself."""

class SharedFn(Global):
    """A VM closure the payload gets from the VM object (`R[a] = vmobj[k]`).
    Script code cannot reach the VM object, so this is Luraph's runtime
    (fetched.lua: LPH_ENCFUNC's decryptor, which deserializes the decrypted
    function with the VM's Lua-level loader): not lifted, a stub function
    named after the order of first use (lift_program)."""

    def __init__(self, fn, n):
        Global.__init__(self, "luraph_runtime%d" % n)
        self.fn = fn


class JitFrame(LTable):
    """One entry of an LPH_JIT function's loop stack (`N = {..., N, ...}`,
    the link slot varies per loop): its other slots are Pseudo variables of
    that depth, like the VM's loop stack K. JIT_BOTTOM is the empty stack."""
    __slots__ = ("link", "depth")

    def __init__(self, link, depth):
        LTable.__init__(self)
        self.link, self.depth = link, depth

def buffer_patches(dump):
    """The lifter's in-place string decryption as a request for the runtime:
    "path,to,holder,key/offset:hexbytes/...;..." (only bytes that differ)."""
    return format_patches(*stable_patches(dump))

def stable_patches(dump):
    """dump.buf_patch / tab_patch keyed by table path instead of object id
    (table ids differ between runs): ({(holder path, offset): byte},
    {(table path, key): number}), only values that differ from the dump."""
    paths = dump.paths()
    bw = {}
    for (bid, off), v in dump.buf_patch.items():
        buf, tid, key = dump.buf_loc[bid]
        if not isinstance(v, int) or buf.data[off] == v or tid not in paths:
            continue
        bw[(",".join(str(x) for x in paths[tid]), key, off)] = v
    tw = {}
    for (tid, key), v in dump.tab_patch.items():
        base = dump.tables[tid].h.get(key)
        if tid in paths and not (isinstance(base, (int, float)) and base == v):
            tw[(",".join(str(x) for x in paths[tid]), key)] = v
    return bw, tw

def format_patches(bw, tw):
    per = {}
    slice_runs = {}
    for (path, key, off), v in bw.items():
        h = "%s,%s" % (path, key)
        if isinstance(v, (bytes, bytearray)):
            slice_runs.setdefault(h, []).append((off, v))
        else:
            per.setdefault(h, {})[off] = v
    out = []
    for holder in sorted(set(per) | set(slice_runs)):
        runs = list(slice_runs.get(holder, ()))
        bs = per.get(holder, {})
        byte_runs = []
        for off in sorted(bs):
            if byte_runs and byte_runs[-1][0] + len(byte_runs[-1][1]) == off:
                byte_runs[-1][1].append(bs[off])
            else:
                byte_runs.append((off, [bs[off]]))
        runs.extend((off, bytes(b)) for off, b in byte_runs)
        runs.sort(key=lambda x: x[0])
        out.append(holder + "".join("/%d:%s" % (off, b.hex()) for off, b in runs))
    out.sort()      

    tabs = {}
    for (path, key), v in tw.items():
        tabs.setdefault(path, []).append((key, v))
    tab_out = [path + "".join("/=%d:%s" % (k, S.fmt_num(v)) for k, v in sorted(kv))
               for path, kv in tabs.items()]
    return ";".join(out + sorted(tab_out))

def same_patches(old, new):
    """Whether `old` (the patches of an earlier round, paths of that run's
    dump) are the patches `new` of the last lift (LAST_DUMP). The shortest
    path to a table changes between runs on ties, so the old paths are
    resolved in the new dump and written with its paths first."""
    if old == new:
        return True
    if not LAST_DUMP:
        return False
    dump = LAST_DUMP[0]
    res = PathResolver(dump)
    pkey = {tid: ",".join(str(x) for x in p) for tid, p in dump.paths().items()}

    def cur(path):
        t = res.get(path)
        return pkey.get(t.tid, path) if t is not None else path
    out, tabs = [], []
    for spec in old.split(";") if old else []:
        head, sep, rest = spec.partition("/")
        if rest.startswith("="):
            tabs.append(cur(head) + sep + rest)
        else:
            path, _, key = head.rpartition(",")
            out.append("%s,%s" % (cur(path), key) + sep + rest)
    return ";".join(sorted(out) + sorted(tabs)) == new

class PathResolver:
    """A table path as written by Dump.paths() ("seq,name,key,..." with
    "slot@value" steps) -> the table it names in this dump, or None."""

    def __init__(self, dump):
        self.dump = dump
        self.caps = {}
        for cap in dump.protos.values():
            if cap.get("__seq") is not None:
                self.caps[str(cap["__seq"])] = cap
        self.memo = {}

    def get(self, path):
        if path in self.memo:
            return self.memo[path]
        t = self.dump.overrides.get(path)
        if not isinstance(t, LTable):
            parts = path.split(",")
            t = None
            if len(parts) == 2:
                cap = self.caps.get(parts[0])
                t = cap.get(parts[1]) if cap is not None else None
            elif len(parts) > 2 and "@" not in parts[-1]:
                parent = self.get(",".join(parts[:-1]))
                try:
                    k = int(parts[-1])
                except ValueError:
                    k = None
                if isinstance(parent, LTable) and k is not None:
                    t = parent.h.get(k)
            if not isinstance(t, LTable):
                t = None
        self.memo[path] = t
        return t

