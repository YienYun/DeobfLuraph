"""Luraph v15 dataflow, upvalue/closure box analysis, and constant/tuple propagation."""
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
from obfuscators.luraph_v15.dump import FrameArg

class OpenUps:
    """Luraph's table of open upvalue boxes (register -> box). Reads give a
    MaybeBox (a by-reference capture of that register); storing nil into it
    is the close op: the captured local's scope ends there."""

OPENUPS = OpenUps()

class MaybeBox:
    def __init__(self, reg):
        self.reg = reg

    def __repr__(self):     
        return "box(r%s)" % self.reg

class UpList:
    """The upvalue list of the proto being lifted. y[i] is a BoxProxy, or a
    FrameProxy for the upvalues that hold the parent's whole register frame."""

    def __init__(self, frames=()):
        self.boxes = {}
        self.frames = set(frames)

    def get(self, i):
        b = self.boxes.get(i)
        if b is None:
            b = self.boxes[i] = FrameProxy(i) if i in self.frames else BoxProxy(i)
        return b

REGFILE = RegFile()

FRAME = "<frame>"

class FrameProxy:
    """Upvalue i holding the parent's register frame: upv[i][r] is the
    parent's register r (Upval((i, r)))."""

    def __init__(self, idx):
        self.idx = idx

    def __repr__(self):
        return "frameproxy(%s)" % (self.idx,)

class BoxProxy:
    """Upvalue i. Luraph keeps shared upvalues in boxes read as box[a][box[b]];
    by-value upvalues are used directly (y[i], y[i][k])."""

    def __init__(self, idx):
        self.idx = idx

    def __repr__(self):
        return "boxproxy(%s)" % (self.idx,)

class BoxPart(Expr):
    """box[k] of upvalue `idx`: either half of a box access, or (if used any
    other way) the by-value upvalue indexed with constant k."""

    def __init__(self, idx, k):
        self.idx, self.k = idx, k

    def __repr__(self):
        return "boxpart(%s,%s)" % (self.idx, self.k)

def walk_expr(e):
    stack = [e]
    while stack:
        x = stack.pop()
        if isinstance(x, Expr):
            yield x
            stack += [v for v in x.__dict__.values() if isinstance(v, Expr)]
            if isinstance(x, S.NewTable):
                stack += [y for kv in x.items for y in kv if isinstance(y, Expr)]

def meet(a, b):
    """Facts true on both paths: equal facts stay; a constant and a
    truthiness (or two constants) that agree on truthiness give that truthiness."""
    out = {}
    def _num_c(x):
        if x and x[0] in ("c", "may_c") and isinstance(x[1], (int, float)) and not isinstance(x[1], bool):
            return x[1]
        return None

    def _is_nil(x):
        return x is None or (x[0] == "c" and x[1] is None)

    for r, f in a.items():
        if r in (("__live_cap__",), ("__open_ch__",)):
            continue
        g = b.get(r)
        if g is None:
            if f[0] == "c" and ((isinstance(r, int) and 800000 < r < 810000) or (isinstance(r, tuple) and r[0] in ("up", "vararg"))):
                out[r] = f
            elif f[0] == "t" and isinstance(r, tuple) and r[0] in ("up", "vararg"):
                out[r] = ("t",)
            elif isinstance(r, int) and r < 800000:
                nv = _num_c(f)
                if nv is not None:
                    out[r] = ("may_c", nv)
                elif not _is_nil(f):
                    out[r] = ("any",)
            continue
        if g == f:
            out[r] = f
            continue
        if (f[0] == "c" and g[0] == "c"
                and isinstance(f[1], int) and not isinstance(f[1], bool)
                and isinstance(g[1], int) and not isinstance(g[1], bool)
                and (f[1] & 0xFFFFFFFF) == (g[1] & 0xFFFFFFFF)):
            out[r] = ("c", f[1] & 0xFFFFFFFF)
            continue
        if isinstance(r, int) and 800000 < r < 810000:
            if f[0] == "c" and g[0] != "c":
                out[r] = f
                continue
            if g[0] == "c" and f[0] != "c":
                out[r] = g
                continue
        if f[0] == "idx_reg" and g[0] == "c":
            rk = b.get(f[2])
            if rk and rk[0] == "c" and f[1].get(rk[1]) == g[1]:
                out[r] = f
                continue
        if g[0] == "idx_reg" and f[0] == "c":
            rk = a.get(g[2])
            if rk and rk[0] == "c" and g[1].get(rk[1]) == f[1]:
                out[r] = g
                continue
        if f[0] == "tbl" and g[0] == "tbl":
            common = {tk: tv for tk, tv in f[1].items() if tk in g[1] and g[1][tk] == tv}
            out[r] = ("tbl", common)
            continue
        if f[0] == "rng" and g[0] == "rng":
            out[r] = ("rng", min(f[1], g[1]), max(f[2], g[2]))
            continue
        ta, tb = truth_of(f), truth_of(g)
        if ta is not None and ta == tb:
            out[r] = ("t",) if ta else ("f",)
            continue
        if isinstance(r, int) and r < 800000:
            na, nb = _num_c(f), _num_c(g)
            if na is not None and _is_nil(g):
                out[r] = ("may_c", na)
            elif nb is not None and _is_nil(f):
                out[r] = ("may_c", nb)
            elif na is not None and nb is not None and ((int(na) & 0xFFFFFFFF) == (int(nb) & 0xFFFFFFFF) if isinstance(na, int) and isinstance(nb, int) else na == nb):
                out[r] = ("may_c", na)
            elif not (_is_nil(f) and _is_nil(g)):
                out[r] = ("any",)
    for r, g in b.items():
        if r in (("__live_cap__",), ("__open_ch__",)):
            continue
        if r not in a:
            if g[0] == "c" and ((isinstance(r, int) and 800000 < r < 810000) or (isinstance(r, tuple) and r[0] in ("up", "vararg"))):
                out[r] = g
            elif g[0] == "t" and isinstance(r, tuple) and r[0] in ("up", "vararg"):
                out[r] = ("t",)
            elif isinstance(r, int) and r < 800000:
                nv = _num_c(g)
                if nv is not None:
                    out[r] = ("may_c", nv)
                elif not _is_nil(g):
                    out[r] = ("any",)
    lca = a.get(("__live_cap__",))
    lcb = b.get(("__live_cap__",))
    if lca or lcb:
        out[("__live_cap__",)] = ("__live_cap__", (lca[1] if lca else frozenset()) | (lcb[1] if lcb else frozenset()))
    oca = a.get(("__open_ch__",))
    ocb = b.get(("__open_ch__",))
    if oca or ocb:
        out[("__open_ch__",)] = ("__open_ch__", (oca[1] if oca else frozenset()) | (ocb[1] if ocb else frozenset()))
    return out

def fact_of(value):
    """Fact for a register assigned `value` (an IR expression)."""
    if isinstance(value, Const):
        v = value.v
        if isinstance(v, (int, float, bytes, bool)) or v is None:
            return ("c", v)
    if isinstance(value, (Global, Builtin)):
        return ("g", value.name)
    if isinstance(value, S.NewTable) and not value.items:
        return ("tbl", {})
    if isinstance(value, SymList) and value.tail is None and all(isinstance(item, Const) for item in value.items):
        return ("tbl", {i + 1: item.v for i, item in enumerate(value.items)})
    if isinstance(value, ClosureExpr):
        return ("t", value)     
    if isinstance(value, (S.NewTable, Vec, Opaque)):
        return ("t",)
    return None

def eval_fact(e, facts):
    """Concrete value of an IR expression under the facts, or a truthiness
    ("t"/"f"), or None when unknown."""
    if isinstance(e, Const):
        return ("c", e.v)
    if isinstance(e, (Global, Builtin)):
        return ("g", e.name)
    if isinstance(e, SymList):
        d = {}
        for i, item in enumerate(e.items):
            iv = eval_fact(item, facts)
            if iv and iv[0] == "c":
                d[i + 1] = iv[1]
            elif iv and iv[0] == "rng":
                d[i + 1] = iv
        if e.tail is None:
            if getattr(e, "nkey", None):
                d[e.nkey] = len(e.items)
            return ("tbl", d)
        if isinstance(e.tail, TempTail):
            tf = facts.get(("tmp", e.tail.t))
            if tf and tf[0] == "m":
                rest = tf[1][e.tail.start - 1:]
                for j, tv in enumerate(rest):
                    d[len(e.items) + j + 1] = tv
                if getattr(e, "nkey", None):
                    d[e.nkey] = len(e.items) + len(rest)
                return ("tbl", d)
        return None
    if isinstance(e, Reg):
        f = facts.get(e.n)
        if getattr(e, "_u32_trunc", False) and f and f[0] == "c" and isinstance(f[1], (int, float)) and not isinstance(f[1], bool):
            return ("c", int(f[1]) & 0xFFFFFFFF)
        return f
    if isinstance(e, Upval):
        return facts.get(("up", e.idx))
    if isinstance(e, Vararg):
        return facts.get(("vararg", e.i))
    if isinstance(e, TempVal):
        tf = facts.get(("tmp", e.t))
        if tf and tf[0] == "m" and 1 <= e.i <= len(tf[1]):
            v = tf[1][e.i - 1]
            if isinstance(v, tuple) and v and v[0] == "rng":
                return v
            return ("c", v)
        return None
    if isinstance(e, Index):
        of, kf = eval_fact(e.obj, facts), eval_fact(e.key, facts)
        if of and kf and kf[0] == "c":
            k = kf[1].decode("latin-1") if isinstance(kf[1], bytes) else kf[1]
            if of[0] == "g" and isinstance(k, str) and ((of[1] + "." + k) in S.FACT_CONCRETE or (of[1] == "table" and k == "move")):
                return ("g", of[1] + "." + k)
            if of[0] == "c" and isinstance(of[1], bytes) and isinstance(k, str) and ("string." + k) in S.FACT_CONCRETE:
                return ("g", "string." + k)
            if of[0] == "c" and isinstance(of[1], dict):
                if kf[1] in of[1]:
                    return ("c", of[1][kf[1]])
                if of[1].get(b"__type") == "Instance" and of[1].get(b"ClassName") == b"Path2D" and isinstance(k, str):
                    if k == "SetControlPoints" or ("Path2D." + k) in S.FACT_CONCRETE:
                        return ("g", "Path2D." + k)
                if of[1].get(b"__type") == "Random" and isinstance(k, str):
                    if k in ("NextNumber", "NextInteger", "Clone"):
                        return ("g", "Random." + k)
            if of[0] == "tbl" and kf[1] in of[1]:
                v = of[1][kf[1]]
                if isinstance(v, tuple) and v and v[0] == "rng":
                    return v
                return ("c", v)
        if of and of[0] == "tbl" and isinstance(e.key, Reg):
            return ("idx_reg", of[1], e.key.n)
        return None
    if isinstance(e, Un) and e.op == "Not":
        a = eval_fact(e.a, facts)
        t = truth_of(a)
        return None if t is None else ("c", not t)
    if isinstance(e, Bin) and e.op in ("Add", "Sub", "Mul", "Div", "Mod", "FloorDiv"):
        a, b = eval_fact(e.a, facts), eval_fact(e.b, facts)
        if a and a[0] == "may_c":
            a = ("c", a[1])
        if b and b[0] == "may_c":
            b = ("c", b[1])
        if a and b and e.op in ("Add", "Sub"):
            if a[0] == "rng" and b[0] == "c" and isinstance(b[1], (int, float)) and not isinstance(b[1], bool):
                d = b[1] if e.op == "Add" else -b[1]
                return ("rng", S.fix_int(a[1] + d), S.fix_int(a[2] + d))
            if b[0] == "rng" and a[0] == "c" and isinstance(a[1], (int, float)) and not isinstance(a[1], bool) and e.op == "Add":
                return ("rng", S.fix_int(b[1] + a[1]), S.fix_int(b[2] + a[1]))
        if a and b and a[0] == "c" and b[0] == "c":
            x, y = a[1], b[1]
            if isinstance(x, (int, float)) and not isinstance(x, bool) and isinstance(y, (int, float)) and not isinstance(y, bool):
                try:
                    if e.op == "Add": v = x + y
                    elif e.op == "Sub": v = x - y
                    elif e.op == "Mul": v = x * y
                    elif e.op == "Div": v = x / y
                    elif e.op == "Mod": v = x % y
                    else: v = x // y
                    return ("c", S.fix_int(v))
                except ZeroDivisionError:
                    return ("t",)
        return ("t",)
    if isinstance(e, Bin) and e.op.startswith("Compare"):
        a, b = eval_fact(e.a, facts), eval_fact(e.b, facts)
        if a and b and a[0] == "c" and b[0] == "rng" and isinstance(a[1], (int, float)) and not isinstance(a[1], bool):
            x, lo, hi = a[1], b[1], b[2]
            if e.op == "CompareLe":
                if x <= lo: return ("c", True)
                if x > hi: return ("c", False)
            elif e.op == "CompareLt":
                if x < lo: return ("c", True)
                if x >= hi: return ("c", False)
            elif e.op == "CompareGe":
                if x >= hi: return ("c", True)
                if x < lo: return ("c", False)
            elif e.op == "CompareGt":
                if x > hi: return ("c", True)
                if x <= lo: return ("c", False)
            return None
        if a and b and a[0] == "rng" and b[0] == "c" and isinstance(b[1], (int, float)) and not isinstance(b[1], bool):
            lo, hi, y = a[1], a[2], b[1]
            if e.op == "CompareLe":
                if hi <= y: return ("c", True)
                if lo > y: return ("c", False)
            elif e.op == "CompareLt":
                if hi < y: return ("c", True)
                if lo >= y: return ("c", False)
            elif e.op == "CompareGe":
                if lo >= y: return ("c", True)
                if hi < y: return ("c", False)
            elif e.op == "CompareGt":
                if lo > y: return ("c", True)
                if hi <= y: return ("c", False)
            return None
        if a and b and a[0] == "c" and b[0] == "c":
            try:
                x, y = a[1], b[1]
                if e.op == "CompareEq":
                    return ("c", S.lua_eq(x, y))
                if e.op == "CompareNe":
                    return ("c", not S.lua_eq(x, y))
                if isinstance(x, bool) or isinstance(y, bool) or x is None or y is None or isinstance(x, dict) or isinstance(y, dict):
                    return None
                if isinstance(x, bytes) != isinstance(y, bytes):
                    return None
                return ("c", {"CompareLt": x < y, "CompareLe": x <= y, "CompareGt": x > y,
                              "CompareGe": x >= y}[e.op])
            except TypeError:
                return None
        if e.op in ("CompareEq", "CompareNe"):
            if isinstance(e.a, Reg) and isinstance(e.b, Reg):
                ra = facts[e.a.n][1] if e.a.n in facts and facts[e.a.n][0] == "r" else e.a.n
                rb = facts[e.b.n][1] if e.b.n in facts and facts[e.b.n][0] == "r" else e.b.n
                if ra == rb:
                    fa = facts.get(ra)
                    if fa and (fa[0] in ("non_nan", "rng", "g", "tbl")
                               or (fa[0] in ("c", "may_c") and fa[1] == fa[1])):
                        return ("c", e.op == "CompareEq")
            if isinstance(e.a, Reg) and isinstance(e.b, Const):
                ra = e.a.n
                if ra in facts and facts[ra][0] == "r":
                    ra = facts[ra][1]
                return ("cmp", e.op, ra, e.b.v)
            if isinstance(e.b, Reg) and isinstance(e.a, Const):
                rb = e.b.n
                if rb in facts and facts[rb][0] == "r":
                    rb = facts[rb][1]
                return ("cmp", e.op, rb, e.a.v)
        elif e.op in ("CompareLt", "CompareLe", "CompareGt", "CompareGe"):
            ra = (facts[e.a.n][1] if e.a.n in facts and facts[e.a.n][0] == "r" else e.a.n) if isinstance(e.a, Reg) else None
            rb = (facts[e.b.n][1] if e.b.n in facts and facts[e.b.n][0] == "r" else e.b.n) if isinstance(e.b, Reg) else None
            if ra is not None or rb is not None:
                return ("ord_cmp", ra, rb)
    return None

def truth_of(f):
    if f is None or f[0] in ("r", "m", "cmp", "ord_cmp", "idx_reg", "rng", "any", "may_c"):
        return None
    if f[0] == "c":
        return S.truthy(f[1])
    if f[0] in ("tbl", "non_nan"):
        return True
    if f[0] == "g":
        return True if S.is_guaranteed_global(f[1]) else None
    return f[0] == "t"

def edge_facts(cond, taken, facts):
    """Facts implied by taking one side of a branch on `cond`."""
    f = dict(facts)
    c = cond
    neg = False
    while isinstance(c, Un) and c.op == "Not":
        c, neg = c.a, not neg
    t = taken != neg
    learned_reg = None
    if isinstance(c, Reg):
        cf = f.get(c.n)
        if cf and cf[0] == "cmp":
            eq = t if cf[1] == "CompareEq" else not t
            if eq and cf[2] != c.n:
                f[cf[2]] = ("c", cf[3])
                learned_reg = (cf[2], cf[3])
            f[c.n] = ("c", bool(t))
        elif cf and cf[0] == "ord_cmp":
            if t:
                for rr in (cf[1], cf[2]):
                    if rr is not None and rr != c.n:
                        cur = f.get(rr)
                        if cur is None or cur[0] in ("t", "any"):
                            f[rr] = ("non_nan",)
            f[c.n] = ("c", bool(t))
        elif c.n not in f or f[c.n][0] != "c":
            f[c.n] = ("t",) if t else ("f",)
    elif isinstance(c, Bin) and c.op in ("CompareEq", "CompareNe"):
        eq = t if c.op == "CompareEq" else not t
        if eq:
            if isinstance(c.a, Reg) and isinstance(c.b, Const):
                f[c.a.n] = ("c", c.b.v)
                learned_reg = (c.a.n, c.b.v)
            elif isinstance(c.b, Reg) and isinstance(c.a, Const):
                f[c.b.n] = ("c", c.a.v)
                learned_reg = (c.b.n, c.a.v)
    elif isinstance(c, Bin) and c.op in ("CompareLt", "CompareLe", "CompareGt", "CompareGe") and t:
        for operand in (c.a, c.b):
            if isinstance(operand, Reg):
                rr = f[operand.n][1] if operand.n in f and f[operand.n][0] == "r" else operand.n
                cur = f.get(rr)
                if cur is None or cur[0] in ("t", "any"):
                    f[rr] = ("non_nan",)
    if learned_reg is not None:
        lr, lv = learned_reg
        for rk, rv in list(f.items()):
            if rv and rv[0] == "idx_reg" and rv[2] == lr and lv in rv[1]:
                f[rk] = ("c", rv[1][lv])
    return f

def _replace_dict_fact(facts, old_d, key, val, remove=False):
    new_d = dict(old_d)
    if remove:
        new_d.pop(key, None)
    else:
        new_d[key] = val
    for rk, rv in list(facts.items()):
        if rv and rv[0] in ("c", "tbl") and rv[1] is old_d:
            facts[rk] = (rv[0], new_d)
    for rk, rv in list(facts.items()):
        if rv and rv[0] in ("c", "tbl") and isinstance(rv[1], dict):
            for dk, dv in list(rv[1].items()):
                if dv is old_d:
                    nd2 = dict(rv[1])
                    nd2[dk] = new_d
                    facts[rk] = (rv[0], nd2)

def _upval_open_reg(u):
    if isinstance(u, MaybeBox):
        return u.reg
    if isinstance(u, LTable):
        vals = list(u.h.values())
        ints = [v for v in vals if isinstance(v, int)]
        if any(isinstance(v, RegFile) for v in vals) and ints:
            return ints[0]
    return None

def _single_const_fact(lf, reg):
    if lf is None:
        return None
    poisoned = getattr(lf, "rcf_single_poisoned", None)
    if poisoned is not None and reg in poisoned:
        return None
    sv = (getattr(lf, "rcf_single_val", None) or {}).get(reg)
    if sv is not None:
        used = getattr(lf, "rcf_single_used", None)
        if used is not None:
            used.add(reg)
    return sv

def _up_single_const_fact(lf, idx):
    if lf is None:
        return None
    poisoned = getattr(lf, "up_single_poisoned", None)
    if poisoned is not None and idx in poisoned:
        return None
    init_uf = getattr(lf, "init_facts", None)
    if isinstance(init_uf, dict) and ("up", idx) in init_uf:
        return None
    sv = (getattr(lf, "up_single_val", None) or {}).get(idx)
    if sv is not None:
        used = getattr(lf, "up_single_used", None)
        if used is not None:
            used.add(idx)
    return sv

def _eval_with_single_consts(expr, facts, lf):
    fv = eval_fact(expr, facts)
    if (fv is None or fv[0] in ("any", "t", "cmp", "ord_cmp")) and lf is not None:
        aug = None
        cand_regs = []
        cand_post_regs = []
        cand_ups = []
        sv_map = getattr(lf, "rcf_single_val", None) or {}
        poisoned = getattr(lf, "rcf_single_poisoned", None) or ()
        rcf_map = getattr(lf, "reg_const_fact", None) or {}
        post_poisoned = getattr(lf, "rcf_post_cap_poisoned", None) or ()
        post_val_map = getattr(lf, "rcf_post_cap_val", None) or {}
        live_lc = facts.get(("__live_cap__",))
        live_cap_regs = live_lc[1] if live_lc else ()
        up_sv = getattr(lf, "up_single_val", None) or {}
        up_poisoned = getattr(lf, "up_single_poisoned", None) or ()
        init_uf = getattr(lf, "init_facts", None)
        stack = [expr]
        while stack:
            x = stack.pop()
            if isinstance(x, Reg):
                cur = facts.get(x.n)
                if cur is None or cur == ("any",):
                    sv = sv_map.get(x.n)
                    if sv is not None and x.n not in poisoned:
                        if aug is None:
                            aug = dict(facts)
                        aug[x.n] = sv
                        cand_regs.append(x.n)
                    elif x.n in live_cap_regs and x.n not in post_poisoned:
                        pv = rcf_map.get(x.n)
                        prev_pv = post_val_map.get(x.n)
                        if pv and pv[0] == "c" and isinstance(pv[1], (int, float)) and not isinstance(pv[1], bool) and (prev_pv is None or prev_pv == pv):
                            if aug is None:
                                aug = dict(facts)
                            aug[x.n] = pv
                            cand_post_regs.append((x.n, pv))
            elif isinstance(x, Upval):
                uk = ("up", x.idx)
                cur = facts.get(uk)
                if (cur is None or cur == ("any",)) and not (isinstance(init_uf, dict) and uk in init_uf):
                    uv = up_sv.get(x.idx)
                    if uv is not None and x.idx not in up_poisoned:
                        if aug is None:
                            aug = dict(facts)
                        aug[uk] = uv
                        cand_ups.append(x.idx)
            elif isinstance(x, Expr):
                stack += [v for v in x.__dict__.values() if isinstance(v, Expr)]
                if isinstance(x, S.NewTable):
                    stack += [y for kv in x.items for y in kv if isinstance(y, Expr)]
        if aug is not None:
            afv = eval_fact(expr, aug)
            if afv and afv[0] == "c" and (isinstance(afv[1], (int, float, bool, bytes)) or afv[1] is None):
                fv = afv
                if cand_regs:
                    used = getattr(lf, "rcf_single_used", None)
                    if used is not None:
                        used.update(cand_regs)
                if cand_post_regs:
                    cap_val = lf.__dict__.setdefault("rcf_post_cap_val", {})
                    post_used = lf.__dict__.setdefault("rcf_post_cap_used", set())
                    for rn, rpv in cand_post_regs:
                        cap_val[rn] = rpv
                        post_used.add(rn)
                if cand_ups:
                    up_used = getattr(lf, "up_single_used", None)
                    if up_used is not None:
                        up_used.update(cand_ups)
    return fv


def _post_cap_const_fact(lf, reg):
    if lf is None:
        return None
    poisoned = getattr(lf, "rcf_post_cap_poisoned", None)
    if poisoned is not None and reg in poisoned:
        return None
    rcf = getattr(lf, "reg_const_fact", None) or {}
    fv = rcf.get(reg)
    if fv and fv[0] == "c" and isinstance(fv[1], (int, float)) and not isinstance(fv[1], bool):
        cap_val = lf.__dict__.setdefault("rcf_post_cap_val", {})
        prev = cap_val.get(reg)
        if prev is not None and prev != fv:
            lf.__dict__.setdefault("rcf_post_cap_poisoned", set()).add(reg)
            cap_val.pop(reg, None)
            return None
        cap_val[reg] = fv
        lf.__dict__.setdefault("rcf_post_cap_used", set()).add(reg)
        return fv
    return None

def _capture_closure_up_facts(c, facts, lf=None):
    if lf is not None and isinstance(c.proto, LTable) and not hasattr(c, "arg_facts"):
        for ch in getattr(lf, "children", ()):
            if ch is not c and isinstance(ch.proto, LTable) and ch.proto.tid == c.proto.tid and hasattr(ch, "arg_facts"):
                c.arg_facts = dict(ch.arg_facts)
                break
    up_facts = getattr(c, "up_facts", None) or {}
    sv_map = getattr(lf, "rcf_single_val", None) or {}
    poisoned = getattr(lf, "rcf_single_poisoned", None) or ()
    ub = getattr(c, "upval_base", 1)
    for i, u in enumerate(c.upvals, ub):
        uf = None
        if isinstance(u, Reg):
            uf = facts.get(u.n)
            if not (uf and uf[0] == "c"):
                uf = _single_const_fact(lf, u.n) or _post_cap_const_fact(lf, u.n)
        elif isinstance(u, MaybeBox):
            uf = facts.get(u.reg)
            if not (uf and uf[0] == "c"):
                uf = _single_const_fact(lf, u.reg) or _post_cap_const_fact(lf, u.reg)
        elif isinstance(u, (BoxProxy, Upval)):
            uf = facts.get(("up", u.idx))
            if not (uf and uf[0] == "c"):
                uf = _up_single_const_fact(lf, u.idx)
        elif isinstance(u, LTable):
            vals = list(u.h.values())
            ints = [v for v in vals if isinstance(v, int) and not isinstance(v, bool)]
            if any(isinstance(v, RegFile) for v in vals) and ints:
                uf = facts.get(ints[0])
                if not (uf and uf[0] == "c"):
                    uf = _single_const_fact(lf, ints[0]) or _post_cap_const_fact(lf, ints[0])
            else:
                ups = [v for v in vals if isinstance(v, UpContainer)]
                if ups:
                    uf = facts.get(("up", ups[0].idx))
                    if not (uf and uf[0] == "c"):
                        uf = _up_single_const_fact(lf, ups[0].idx)
        elif isinstance(u, RegFile):
            for rk, rv in facts.items():
                if isinstance(rk, int) and rk < 800000 and rv and rv[0] == "c" and isinstance(rv[1], (int, float)) and not isinstance(rv[1], bool):
                    up_facts[("up", (i, rk))] = rv
            for rk, rv in sv_map.items():
                if rk not in poisoned and rk not in facts and ("up", (i, rk)) not in up_facts:
                    _single_const_fact(lf, rk)
                    up_facts[("up", (i, rk))] = rv
        elif isinstance(u, FrameProxy):
            for rk, rv in facts.items():
                if isinstance(rk, tuple) and len(rk) == 2 and rk[0] == "up" and isinstance(rk[1], tuple) and rk[1][0] == u.idx and rv and rv[0] == "c" and isinstance(rv[1], (int, float)) and not isinstance(rv[1], bool):
                    up_facts[("up", (i, rk[1][1]))] = rv
        if uf and uf[0] == "c" and isinstance(uf[1], (int, float)) and not isinstance(uf[1], bool):
            up_facts[("up", i)] = uf
        elif isinstance(u, Reg) and ("up", i) not in up_facts:
            rc_c = (getattr(lf, "reg_closure_fact", None) or {}).get(u.n) if lf is not None else None
            if truth_of(uf) is True or (uf is None and isinstance(rc_c, tuple)):
                up_facts[("up", i)] = ("t",)
    c.up_facts = up_facts
    open_regs = {}
    for i, u in enumerate(c.upvals, ub):
        r = _upval_open_reg(u)
        if r is not None:
            cur_f = facts.get(r)
            # Only keep open for post-creation constant init if currently nil/unset or already numeric const
            if cur_f is None or (cur_f[0] == "c" and (cur_f[1] is None or (isinstance(cur_f[1], (int, float)) and not isinstance(cur_f[1], bool)))):
                open_regs[i] = r
    c._open_up_regs = open_regs
    if lf is not None:
        prev_oc = facts.get(("__open_ch__",))
        facts[("__open_ch__",)] = ("__open_ch__",
                                   (prev_oc[1] if prev_oc else frozenset()) | frozenset((id(c),)))
    cregs = set(c._open_up_regs.values())
    if lf is not None and any(isinstance(u, (RegFile, FrameProxy)) for u in c.upvals):
        cregs |= set(lf.captured_regs)
    if cregs:
        prev_lc = facts.get(("__live_cap__",))
        facts[("__live_cap__",)] = ("__live_cap__", (prev_lc[1] if prev_lc else frozenset()) | frozenset(cregs))

def apply_stmt_facts(st, facts, lf, pos=None):
    if isinstance(st, Close):
        facts.pop(st.reg, None)
        if lf is not None:
            rc_clos = getattr(lf, "reg_closure_fact", None)
            if rc_clos is not None:
                rc_clos.pop(st.reg, None)
            for ch in getattr(lf, "children", ()):
                open_ups = getattr(ch, "_open_up_regs", None)
                if open_ups:
                    for ui, ureg in list(open_ups.items()):
                        if ureg == st.reg:
                            open_ups.pop(ui, None)
        return
    if isinstance(st, Assign) and isinstance(st.target, Reg):
        rc_clos = lf.__dict__.setdefault("reg_closure_fact", {}) if lf is not None else None
        is_nil_assign = isinstance(st.value, Const) and st.value.v is None
        if isinstance(st.value, ClosureExpr):
            if pos is not None and not hasattr(st.value, "_created_at"):
                st.value._created_at = pos
            _capture_closure_up_facts(st.value, facts, lf)
            if rc_clos is not None:
                prev_c = rc_clos.get(st.target.n)
                if prev_c is None:
                    rc_clos[st.target.n] = ("t", st.value)
                elif isinstance(prev_c, tuple) and prev_c[1].proto is not st.value.proto:
                    rc_clos[st.target.n] = False
        elif rc_clos is not None:
            if is_nil_assign:
                if st.target.n in rc_clos:
                    rc_clos[st.target.n] = False
            elif isinstance(st.value, Reg):
                src_c = facts.get(st.value.n)
                if not (src_c and src_c[0] == "t" and len(src_c) > 1 and isinstance(src_c[1], ClosureExpr)):
                    src_c = rc_clos.get(st.value.n)
                if isinstance(src_c, tuple):
                    prev_c = rc_clos.get(st.target.n)
                    if prev_c is None:
                        rc_clos[st.target.n] = src_c
                    elif isinstance(prev_c, tuple) and prev_c[1].proto is not src_c[1].proto:
                        rc_clos[st.target.n] = False
                else:
                    rc_clos[st.target.n] = False
            else:
                rc_clos[st.target.n] = False
        fv = fact_of(st.value)
        if fv is None:
            fv = _eval_with_single_consts(st.value, facts, lf)
        if fv is None and isinstance(st.value, Reg):
            src = facts.get(st.value.n)
            fv = src if (src and src[0] == "r") else ("r", st.value.n)
        tn = st.target.n
        if lf is not None:
            poisoned = lf.__dict__.setdefault("rcf_single_poisoned", set())
            sv_map = lf.__dict__.setdefault("rcf_single_val", {})
            used = lf.__dict__.setdefault("rcf_single_used", set())
            if is_nil_assign:
                if tn in sv_map:
                    poisoned.add(tn)
                    sv_map.pop(tn, None)
                    if tn in used:
                        lf.rcf_single_restart = True
            elif tn not in poisoned:
                if fv and fv[0] == "c" and isinstance(fv[1], (int, float)) and not isinstance(fv[1], bool):
                    prev_sv = sv_map.get(tn)
                    if prev_sv is None:
                        sv_map[tn] = fv
                    elif prev_sv != fv:
                        poisoned.add(tn)
                        sv_map.pop(tn, None)
                        if tn in used:
                            lf.rcf_single_restart = True
                else:
                    poisoned.add(tn)
                    sv_map.pop(tn, None)
                    if tn in used:
                        lf.rcf_single_restart = True
        for rk, rv in list(facts.items()):
            if rk != tn and rv and ((rv[0] == "r" and rv[1] == tn) or (rv[0] in ("cmp", "idx_reg") and rv[2] == tn)):
                facts.pop(rk, None)
        if fv and fv[0] == "cmp" and fv[2] == tn:
            fv = None
        rcf = lf.__dict__.setdefault("reg_const_fact", {}) if lf is not None else None
        if lf is not None:
            pc_val = getattr(lf, "rcf_post_cap_val", None)
            if pc_val is not None and st.target.n in pc_val and pc_val[st.target.n] != fv:
                if not (is_nil_assign and st.target.n not in (getattr(lf, "rcf_post_cap_used", None) or ())):
                    lf.__dict__.setdefault("rcf_post_cap_poisoned", set()).add(st.target.n)
                    pc_val.pop(st.target.n, None)
                    if st.target.n in (getattr(lf, "rcf_post_cap_used", None) or ()):
                        lf.rcf_single_restart = True
        if fv is None:
            facts[st.target.n] = ("any",)
            if rcf is not None:
                rcf.pop(st.target.n, None)
            if lf is not None:
                for ch in getattr(lf, "children", ()):
                    cat = getattr(ch, "_created_at", None)
                    if cat is not None and pos is not None and cat[0] == pos[0] and pos[1] <= cat[1]:
                        continue
                    oc_ch = facts.get(("__open_ch__",))
                    if oc_ch is not None and id(ch) not in oc_ch[1]:
                        continue
                    open_ups = getattr(ch, "_open_up_regs", None)
                    uf_map = getattr(ch, "up_facts", None)
                    post_uf = getattr(ch, "_post_up_facts", None)
                    if open_ups:
                        for ui, ureg in list(open_ups.items()):
                            if ureg == st.target.n:
                                open_ups.pop(ui, None)
                                if uf_map is not None:
                                    uf_map.pop(("up", ui), None)
                                if post_uf is not None:
                                    post_uf.pop(("up", ui), None)
                    if uf_map is not None:
                        for ui, u in enumerate(ch.upvals, getattr(ch, "upval_base", 1)):
                            if isinstance(u, RegFile):
                                uf_map.pop(("up", (ui, st.target.n)), None)
                                if post_uf is not None:
                                    post_uf.pop(("up", (ui, st.target.n)), None)
        else:
            facts[st.target.n] = fv
            if fv[0] == "c" and isinstance(fv[1], (int, float)) and not isinstance(fv[1], bool):
                if rcf is not None:
                    rcf[st.target.n] = fv
                if lf is not None:
                    for ch in getattr(lf, "children", ()):
                        cat = getattr(ch, "_created_at", None)
                        if cat is not None and pos is not None and cat[0] == pos[0] and pos[1] <= cat[1]:
                            continue
                        oc_ch = facts.get(("__open_ch__",))
                        if oc_ch is not None and id(ch) not in oc_ch[1]:
                            continue
                        open_ups = getattr(ch, "_open_up_regs", None) or {}
                        uf_map = getattr(ch, "up_facts", None)
                        if uf_map is None:
                            continue
                        post_uf = ch.__dict__.setdefault("_post_up_facts", {})
                        for ui, u in enumerate(ch.upvals, getattr(ch, "upval_base", 1)):
                            ureg = _upval_open_reg(u)
                            if ureg == st.target.n:
                                prev_uf = uf_map.get(("up", ui))
                                if prev_uf is not None and prev_uf != fv:
                                    open_ups.pop(ui, None)
                                    uf_map.pop(("up", ui), None)
                                    post_uf.pop(("up", ui), None)
                                elif ui in open_ups:
                                    uf_map[("up", ui)] = fv
                                    post_uf[("up", ui)] = fv
                            elif isinstance(u, RegFile):
                                prev_fuf = uf_map.get(("up", (ui, st.target.n)))
                                if prev_fuf is not None and prev_fuf != fv:
                                    uf_map.pop(("up", (ui, st.target.n)), None)
                                    post_uf.pop(("up", (ui, st.target.n)), None)
                                else:
                                    uf_map[("up", (ui, st.target.n))] = fv
                                    post_uf[("up", (ui, st.target.n))] = fv
            else:
                if rcf is not None:
                    rcf.pop(st.target.n, None)
                if lf is not None:
                    for ch in getattr(lf, "children", ()):
                        cat = getattr(ch, "_created_at", None)
                        if cat is not None and pos is not None and cat[0] == pos[0] and pos[1] <= cat[1]:
                            continue
                        oc_ch = facts.get(("__open_ch__",))
                        if oc_ch is not None and id(ch) not in oc_ch[1]:
                            continue
                        open_ups = getattr(ch, "_open_up_regs", None)
                        uf_map = getattr(ch, "up_facts", None)
                        post_uf = getattr(ch, "_post_up_facts", None)
                        if open_ups:
                            for ui, ureg in list(open_ups.items()):
                                if ureg == st.target.n:
                                    if not is_nil_assign or ("up", ui) in (uf_map or ()):
                                        open_ups.pop(ui, None)
                                    if uf_map is not None:
                                        uf_map.pop(("up", ui), None)
                                    if post_uf is not None:
                                        post_uf.pop(("up", ui), None)
                        if uf_map is not None:
                            for ui, u in enumerate(ch.upvals, getattr(ch, "upval_base", 1)):
                                if isinstance(u, RegFile):
                                    uf_map.pop(("up", (ui, st.target.n)), None)
                                    if post_uf is not None:
                                        post_uf.pop(("up", (ui, st.target.n)), None)
    elif isinstance(st, Assign) and isinstance(st.target, Upval):
        fv = fact_of(st.value)
        if fv is None:
            fv = eval_fact(st.value, facts)
        uk = ("up", st.target.idx)
        if lf is not None:
            lf.__dict__.setdefault("mutated_upvals", set()).add(st.target.idx)
            init_uf = getattr(lf, "init_facts", None)
            if isinstance(init_uf, dict) and uk in init_uf and init_uf[uk] != fv:
                init_uf.pop(uk, None)
                lf.rcf_single_restart = True
            up_poisoned = lf.__dict__.setdefault("up_single_poisoned", set())
            up_sv = lf.__dict__.setdefault("up_single_val", {})
            up_used = lf.__dict__.setdefault("up_single_used", set())
            u_idx = st.target.idx
            if u_idx not in up_poisoned:
                if fv and fv[0] == "c" and isinstance(fv[1], (int, float)) and not isinstance(fv[1], bool):
                    prev_uv = up_sv.get(u_idx)
                    if prev_uv is None:
                        up_sv[u_idx] = fv
                    elif prev_uv != fv:
                        up_poisoned.add(u_idx)
                        up_sv.pop(u_idx, None)
                        if u_idx in up_used:
                            lf.rcf_single_restart = True
                else:
                    up_poisoned.add(u_idx)
                    up_sv.pop(u_idx, None)
                    if u_idx in up_used:
                        lf.rcf_single_restart = True
        if fv is None:
            facts[uk] = ("any",)
        elif fv[0] in ("r", "cmp", "ord_cmp", "idx_reg", "m"):
            t0 = truth_of(fv)
            facts[uk] = ("t",) if t0 is True else (("f",) if t0 is False else ("any",))
        else:
            facts[uk] = fv
    elif isinstance(st, Assign) and isinstance(st.target, Index) and isinstance(st.target.obj, Reg):
        tf = facts.get(st.target.obj.n)
        kf = eval_fact(st.target.key, facts)
        vf = eval_fact(st.value, facts)
        if tf and kf and kf[0] == "c":
            if tf[0] == "tbl" or (tf[0] == "c" and isinstance(tf[1], dict)):
                if vf and vf[0] in ("c", "tbl"):
                    if (tf[0] == "tbl" and kf[1] in tf[1]
                            and isinstance(tf[1][kf[1]], (int, float))
                            and isinstance(vf[1], (int, float))
                            and tf[1][kf[1]] != vf[1]):
                        _replace_dict_fact(facts, tf[1], kf[1], None, remove=True)
                    else:
                        _replace_dict_fact(facts, tf[1], kf[1], vf[1])
                elif vf and vf[0] == "rng":
                    _replace_dict_fact(facts, tf[1], kf[1], vf)
                elif kf[1] in tf[1]:
                    _replace_dict_fact(facts, tf[1], kf[1], None, remove=True)
    elif isinstance(st, SetList) and isinstance(st.tbl, Reg):
        tf = facts.get(st.tbl.n)
        if tf and tf[0] == "tbl":
            old_d = tf[1]
            new_d = dict(old_d)
            vals = []
            ok = True
            for x in st.values.items:
                xf = eval_fact(x, facts)
                if xf and xf[0] == "c":
                    vals.append(xf[1])
                elif xf and xf[0] == "rng":
                    vals.append(xf)
                else:
                    ok = False
                    break
            if ok and st.values.tail is not None:
                if isinstance(st.values.tail, TempTail):
                    mf = facts.get(("tmp", st.values.tail.t))
                    if mf and mf[0] == "m":
                        vals.extend(mf[1][st.values.tail.start - 1:])
                    else:
                        ok = False
                else:
                    ok = False
            if ok:
                for idx_i, val_i in enumerate(vals):
                    new_d[st.start + idx_i] = val_i
                for rk, rv in list(facts.items()):
                    if rv and rv[0] == "tbl" and rv[1] is old_d:
                        facts[rk] = ("tbl", new_d)
    elif isinstance(st, CallStmt):
        rc_clos_map = (getattr(lf, "reg_closure_fact", None) or {}) if lf is not None else {}
        def _clos_of_expr(ex):
            if isinstance(ex, ClosureExpr):
                return ex
            if isinstance(ex, Reg):
                cf0 = facts.get(ex.n)
                if cf0 and cf0[0] == "t" and len(cf0) > 1 and isinstance(cf0[1], ClosureExpr):
                    return cf0[1]
                rc0 = rc_clos_map.get(ex.n)
                if isinstance(rc0, tuple):
                    return rc0[1]
            return None
        invoked_closures = []
        if isinstance(st.fn, ClosureExpr):
            if pos is not None and not hasattr(st.fn, "_created_at"):
                st.fn._created_at = pos
            _capture_closure_up_facts(st.fn, facts, lf)
        for ax in st.args.items:
            if isinstance(ax, ClosureExpr):
                if pos is not None and not hasattr(ax, "_created_at"):
                    ax._created_at = pos
                _capture_closure_up_facts(ax, facts, lf)
        fc_direct = _clos_of_expr(st.fn)
        if fc_direct is not None:
            invoked_closures.append(fc_direct)
        for ax in st.args.items:
            ac = _clos_of_expr(ax)
            if ac is not None and ac not in invoked_closures:
                invoked_closures.append(ac)
        for ic in list(invoked_closures):
            if lf is not None and isinstance(ic.proto, LTable):
                for ch in getattr(lf, "children", ()):
                    if ch is not ic and isinstance(ch.proto, LTable) and ch.proto.tid == ic.proto.tid and ch not in invoked_closures:
                        invoked_closures.append(ch)
        for tc in invoked_closures:
            open_ups = getattr(tc, "_open_up_regs", None) or {}
            site_uf = {}
            for ui, u in enumerate(tc.upvals, getattr(tc, "upval_base", 1)):
                ureg = _upval_open_reg(u)
                if ureg is not None and ui in open_ups:
                    ufv = facts.get(ureg)
                    if not (ufv and ufv[0] == "c"):
                        ufv = _single_const_fact(lf, ureg)
                    if ufv and ufv[0] == "c" and isinstance(ufv[1], (int, float)) and not isinstance(ufv[1], bool):
                        site_uf[("up", ui)] = ufv
            by_site = tc.__dict__.setdefault("_call_up_by_site", {})
            by_site[pos] = site_uf
            sites = list(by_site.values())
            common_uf = dict(sites[0]) if sites else {}
            for s_uf in sites[1:]:
                common_uf = {k: v for k, v in common_uf.items() if s_uf.get(k) == v}
            tc._call_up_facts = common_uf
        if isinstance(st.fn, Reg):
            ff = facts.get(st.fn.n)
            if not (ff and ff[0] == "t" and len(ff) > 1 and isinstance(ff[1], ClosureExpr)):
                rc_c = rc_clos_map.get(st.fn.n)
                if isinstance(rc_c, tuple):
                    ff = rc_c
            if ff and ff[0] == "t" and len(ff) > 1 and isinstance(ff[1], ClosureExpr) and st.args.tail is None:
                c = ff[1]
                af_map = {}
                for j, ax in enumerate(st.args.items, 1):
                    af = eval_fact(ax, facts)
                    if af and af[0] == "c" and isinstance(af[1], (int, float)) and not isinstance(af[1], bool):
                        af_map[("vararg", j)] = af
                if len(st.args.items) == 3 and all(("vararg", j) in af_map and isinstance(af_map[("vararg", j)][1], int) for j in (1, 2, 3)):
                    lo_v, hi_v = af_map[("vararg", 2)][1], af_map[("vararg", 3)][1]
                    if 1 <= lo_v <= hi_v <= 10000:
                        facts[("tmp", st.t)] = ("m", [("rng", lo_v, hi_v)])
                targets = [c]
                if lf is not None and isinstance(c.proto, LTable):
                    for ch in getattr(lf, "children", ()):
                        if ch is not c and isinstance(ch.proto, LTable) and ch.proto.tid == c.proto.tid:
                            targets.append(ch)
                for tc in targets:
                    if not hasattr(tc, "arg_facts"):
                        tc.arg_facts = dict(af_map)
                    else:
                        tc.arg_facts = {k: v for k, v in tc.arg_facts.items() if tc.arg_facts.get(k) == af_map.get(k)}
        fn_f = eval_fact(st.fn, facts)
        is_pure_g = ("tmp", st.t) in facts
        if fn_f and fn_f[0] == "g" and (fn_f[1] in S.FACT_CONCRETE or fn_f[1] in ("Path2D.SetControlPoints", "Random.NextNumber", "Random.NextInteger", "table.move")):
            is_pure_g = True
            arg_vals = []
            ok = True
            for x in st.args.items:
                xf = eval_fact(x, facts)
                if xf and xf[0] == "may_c" and fn_f[1].startswith("bit32."):
                    xf = ("c", xf[1])
                if xf is None and lf is not None and isinstance(x, Reg) and fn_f[1].startswith("bit32."):
                    xf = _single_const_fact(lf, x.n)
                if xf and xf[0] in ("c", "tbl"):
                    arg_vals.append(xf[1])
                elif xf and xf[0] == "g" and fn_f[1] in ("debug.info", "type", "typeof"):
                    arg_vals.append(xf)
                else:
                    ok = False
                    break
            if ok and st.args.tail is not None:
                if isinstance(st.args.tail, TempTail):
                    mf = facts.get(("tmp", st.args.tail.t))
                    if mf and mf[0] == "m":
                        arg_vals.extend(mf[1][st.args.tail.start - 1:])
                    else:
                        ok = False
                else:
                    ok = False
            if ok:
                if fn_f[1] == "Path2D.SetControlPoints" and len(arg_vals) >= 2 and isinstance(arg_vals[0], dict) and isinstance(arg_vals[1], dict):
                    _replace_dict_fact(facts, arg_vals[0], b"_pts", dict(arg_vals[1]))
                elif fn_f[1] == "table.move" and len(arg_vals) >= 4 and isinstance(arg_vals[0], dict):
                    try:
                        a1_d = arg_vals[0]
                        f_i, e_i, t_i = int(arg_vals[1]), int(arg_vals[2]), int(arg_vals[3])
                        a2_d = arg_vals[4] if len(arg_vals) >= 5 else a1_d
                        if isinstance(a2_d, dict) and e_i - f_i <= 256:
                            new_a2 = dict(a2_d)
                            if e_i >= f_i:
                                moved = [a1_d.get(k) for k in range(f_i, e_i + 1)]
                                for off_i, mv in enumerate(moved):
                                    if mv is None:
                                        new_a2.pop(t_i + off_i, None)
                                    else:
                                        new_a2[t_i + off_i] = mv
                            for rk, rv in list(facts.items()):
                                if rv and rv[0] in ("c", "tbl") and rv[1] is a2_d:
                                    facts[rk] = (rv[0], new_a2)
                            facts[("tmp", st.t)] = ("m", [new_a2])
                    except Exception:
                        pass
                elif fn_f[1] == "Random.NextNumber" and len(arg_vals) >= 1 and isinstance(arg_vals[0], dict) and b"_st" in arg_vals[0]:
                    try:
                        nst, val = S._random_next_number(*arg_vals)
                        _replace_dict_fact(facts, arg_vals[0], b"_st", nst)
                        facts[("tmp", st.t)] = ("m", [val])
                    except Exception:
                        pass
                elif fn_f[1] == "Random.NextInteger" and len(arg_vals) >= 3 and isinstance(arg_vals[0], dict) and b"_st" in arg_vals[0]:
                    try:
                        nst, val = S._random_next_integer(*arg_vals)
                        _replace_dict_fact(facts, arg_vals[0], b"_st", nst)
                        facts[("tmp", st.t)] = ("m", [val])
                    except Exception:
                        pass
                elif fn_f[1] in S.FACT_CONCRETE:
                    try:
                        res = S.FACT_CONCRETE[fn_f[1]](*arg_vals)
                        items = res.items if isinstance(res, Multi) else [res]
                        facts[("tmp", st.t)] = ("m", items)
                    except Exception:
                        pass
            elif fn_f[1] == "table.move" and st.args.items:
                dst_arg = st.args.items[4] if len(st.args.items) >= 5 else st.args.items[0]
                if isinstance(dst_arg, Reg) and (facts.get(dst_arg.n) or (None,))[0] == "tbl":
                    facts[dst_arg.n] = ("t",)
        if any(isinstance(x, FrameArg) for x in st.args.items):
            writes = frame_call(st, facts, lf)
            prev = getattr(st, "frame_eval", None)
            if writes is None or (prev is not None and prev != writes):
                st.frame_eval = False
            elif prev is None:
                st.frame_eval = writes
            if not st.frame_eval:
                facts.clear()       
                return
            for r, v in st.frame_eval.items():
                facts[r] = ("c", v)

        live_lc = facts.get(("__live_cap__",))
        live_cap_regs = live_lc[1] if live_lc else frozenset()
        if live_cap_regs and not is_pure_g:
            kill_regs = live_cap_regs
            ff0 = facts.get(st.fn.n) if isinstance(st.fn, Reg) else None
            is_known_cl = bool(ff0 and ff0[0] == "t" and len(ff0) > 1 and isinstance(ff0[1], ClosureExpr))
            is_global_fn = bool(fn_f and fn_f[0] == "g")
            if is_known_cl or is_global_fn:
                involved = [ff0[1]] if is_known_cl else []
                if not (is_global_fn and fn_f[1] in ("coroutine.wrap", "coroutine.create")):
                    for ax in st.args.items:
                        if isinstance(ax, ClosureExpr):
                            involved.append(ax)
                        elif isinstance(ax, Reg):
                            af0 = facts.get(ax.n)
                            if af0 and af0[0] == "t" and len(af0) > 1 and isinstance(af0[1], ClosureExpr):
                                involved.append(af0[1])
                if not any(isinstance(u, (RegFile, FrameProxy)) for cl in involved for u in cl.upvals):
                    kill_regs = {u.reg for cl in involved for u in cl.upvals if isinstance(u, MaybeBox)} | \
                                {u.n for cl in involved for u in cl.upvals if isinstance(u, Reg)}
            for r in list(facts):
                if r in kill_regs and (not isinstance(facts[r], tuple) or facts[r][0] != "g"):
                    facts[r] = ("any",)

def frame_call(st, facts, lf):
    """A call that gets the caller's register frame (FrameArg), of a closure
    without upvalues, all other arguments constant: run it in the runtime on
    a fresh table ("!proto!args" request, envlog callPath). -> {register:
    value} it wrote (LPH_ENCSTR-style decryptors: the plaintext), or None."""
    f = eval_fact(st.fn, facts) if isinstance(st.fn, Reg) else None
    c = f[1] if f and f[0] == "t" and len(f) > 1 else None
    if not isinstance(c, ClosureExpr) or c.upvals or not isinstance(c.proto, LTable) or st.args.tail is not None:
        return None
    path = lf.dump.paths().get(c.proto.tid)
    if path is None:
        return None
    specs = []
    for x in st.args.items:
        v = eval_fact(x, facts) if not isinstance(x, FrameArg) else ("F",)
        if v is None or v[0] not in ("c", "F"):
            return None
        if v[0] == "F":
            specs.append("F")
        elif v[1] is None:
            specs.append("z")
        elif isinstance(v[1], bool):
            specs.append("t" if v[1] else "f")
        elif isinstance(v[1], bytes):
            specs.append("s" + v[1].hex())
        elif isinstance(v[1], (int, float)) and v[1] == v[1] and abs(v[1]) != float("inf"):
            specs.append("n" + S.fmt_num(v[1]))
        else:
            return None
    rq = "!%s!%s" % ("~".join(str(x) for x in path), "/".join(specs))
    got = lf.dump.overrides.get(rq)
    if got is None:
        got = lf.dump.fetch(rq)
        if got is None and lf.dump.fetcher is None:
            lf.requests.add(rq)
    if not isinstance(got, LTable):
        return None
    out = {}
    for k, v in got.h.items():
        if not isinstance(k, int) or not isinstance(v, (bytes, int, float, bool)):
            return None
        out[k] = v
    c.frame_evaluated = True    
    return out

def drop_idle_closes(order, captured):
    """Close ops of registers no closure of this function captures: no-ops
    (Luraph closes whole ranges), but they would keep otherwise identical
    copies of an instruction apart (structure.merge_equivalent)."""
    stack = [n for _, n in order]
    while stack:
        n = stack.pop()
        if n is None:
            continue
        if any(isinstance(x, Close) and x.reg not in captured for x in n.stmts):
            n.stmts = [x for x in n.stmts if not (isinstance(x, Close) and x.reg not in captured)]
        stack += [n.then, n.els]

def apply_frame_calls(order):
    """Evaluated frame-writing calls (frame_call) -> the register writes."""
    stack = [n for _, n in order]
    while stack:
        n = stack.pop()
        if n is None:
            continue
        if any(getattr(x, "frame_eval", None) for x in n.stmts):
            new = []
            for x in n.stmts:
                w = getattr(x, "frame_eval", None)
                if w:
                    new += [Assign(Reg(r), Const(v)) for r, v in sorted(w.items())]
                else:
                    new.append(x)
            n.stmts = new
        stack += [n.then, n.els]

def _check_cff_bin(e, f, lf):
    if lf.stack_base is not None:
        return False
    if isinstance(e, Bin) and e.op in ("CompareLe", "CompareLt", "CompareGe", "CompareGt", "CompareEq"):
        for side, other in ((e.a, e.b), (e.b, e.a)):
            if isinstance(side, Reg) and isinstance(other, Const) and isinstance(other.v, int) and not isinstance(other.v, bool):
                r = side.n
                if r in f and f[r][0] == "r":
                    r = f[r][1]
                if (r in lf.merged_int_regs and r not in lf.cff_regs
                        and r not in lf.arith_regs and (r not in f or f[r][0] != "c")):
                    lf.cff_regs.add(r)
                    lf.jump_regs.add(r)
                    return True
    return False

def propagate(node, facts, succ, lf):
    """Walk one instruction's IR tree under the facts, collecting feasible
    successors with their facts."""
    stack = [(node, facts)]
    while stack:
        n, f = stack.pop()
        if n is None:
            continue
        for idx, st in enumerate(n.stmts):
            if isinstance(st, Assign) and _check_cff_bin(st.value, f, lf):
                return "cff_restart"
            apply_stmt_facts(st, f, lf, pos=(id(n), idx))
            if getattr(lf, "rcf_single_restart", False):
                lf.rcf_single_restart = False
                return "cff_restart"
        if n.cond is not None:
            if _check_cff_bin(n.cond, f, lf):
                return "cff_restart"
            v = truth_of(_eval_with_single_consts(n.cond, f, lf))
            n.decided = getattr(n, "decided", "unset")
            if v is None:
                n.decided = None
                stack.append((n.then, edge_facts(n.cond, True, f)))
                stack.append((n.els, edge_facts(n.cond, False, f)))
            else:
                if n.decided == "unset":
                    n.decided = v
                elif n.decided is not None and n.decided != v:
                    n.decided = None
                stack.append((n.then if v else n.els, f))
        elif isinstance(n.outcome, Next):
            succ.append((n.outcome.state, f))
    return None

def expr_regs(e):
    """Registers read by an expression."""
    out = []
    stack = [e]
    while stack:
        x = stack.pop()
        if isinstance(x, Reg):
            out.append(x)
        elif isinstance(x, Expr):
            stack += [v for v in x.__dict__.values() if isinstance(v, Expr)]
            if isinstance(x, S.NewTable):
                stack += [y for kv in x.items for y in kv if isinstance(y, Expr)]
    return out

