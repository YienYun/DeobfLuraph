import copy
import re
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

import luasym as S  
from luasym import Const, Reg, Pseudo, Global, Upval, Index, Bin, Un, TempVal, Vararg, ClosureExpr, Multi  

class Block:
    __slots__ = ("id", "stmts", "kind", "cond", "succ", "values", "error", "preds", "origin", "path")

    def __init__(self, bid):
        self.id = bid
        self.stmts = []
        self.kind = "goto"      
        self.cond = None
        self.succ = []          
        self.values = None      
        self.error = None
        self.preds = []
        self.origin = None      
        self.path = ""          

    def __repr__(self):
        return "B%s(%s->%s)" % (self.id, self.kind, [b for b in self.succ])

def build_cfg(entry_key, order, D, link):
    """order: [(state key, devirt.Node)]; D: the devirt module (IR classes)."""
    nodes = dict(order)
    blocks = {}
    counter = [0]

    def new_block():
        counter[0] += 1
        b = Block(counter[0])
        blocks[b.id] = b
        return b

    head = {}

    def head_of(key):
        b = head.get(key)
        if b is None:
            b = new_block()
            b.origin = (key[0], key[1])
            head[key] = b
        return b

    for key, node in order:
        b = head_of(key)
        fill(b, node, key, new_block, head_of, nodes, D, link)
    entry = head_of(entry_key)
    for b in blocks.values():
        b.preds = []
    for b in blocks.values():
        for s in b.succ:
            blocks[s].preds.append(b.id)
    return entry.id, blocks

GUARD_ERR = "needs a constant that is not decoded yet"
GUARD_DROPS = []

def prune_constant_guards(entry, blocks):
    """Luraph's integrity guards compare a register with a lazily decoded
    constant. When that constant cannot be decoded (a tamper-check slot no
    Lua-side decoder ever produced) the branch behind the guard cannot be
    lifted while its sibling -- the real code -- can. Such a branch is a dead
    end in a healthy run: drop it instead of emitting `error()`. A guard that
    is not the alternative of a condition keeps its (already lifted)
    statements and simply ends there."""
    guards = [b for b in blocks.values()
              if b.kind == "error" and (b.error or "").startswith(GUARD_ERR)]
    if not guards:
        return 0
    gids = {b.id for b in guards}

    def climb(g):
        """The condition whose other branch is the real code, walking up the
        straight-line chain (empty dispatcher hops and the tamper routine's
        own straight-line code) that leads down to the unliftable branch.
        -> (cond block, [chain blocks from the cond's successor down to g])"""
        cur, chain = g, [g]
        while len(cur.preds) == 1:
            p = blocks.get(cur.preds[0])
            if p is None:
                return None, None
            if p.kind == "cond" and len(p.succ) == 2:
                return p, chain
            if p.kind != "goto" or len(p.succ) != 1:
                return None, None
            chain.append(p)
            cur = p
        return None, None

    n = 0
    used = set()
    for g in guards:
        p, chain = climb(g)
        if p is None or any(c.id in used for c in chain):
            continue
        t, e = p.succ
        if chain[-1].id not in (t, e):
            continue
        other = e if chain[-1].id == t else t
        if other in gids or blocks[other].kind == "error":
            continue
        p.kind, p.cond, p.succ = "goto", None, [other]
        for c in chain:
            c.preds, c.kind, c.stmts, c.succ = [], "end", [], []
            c.error = None
            used.add(c.id)
        n += 1
    for g in guards:
        if g.kind == "error":
            g.kind, g.error = "end", None
            n += 1
    if n:
        GUARD_DROPS.append(n)
    return n

def drop_unreachable(entry, blocks):
    """Remove blocks no path from the entry reaches (a decoy handler whose
    predecessor was cut). They are not emitted, so they must not be counted
    as unlifted either."""
    live, stack = set(), [entry]
    while stack:
        bid = stack.pop()
        if bid in live or bid not in blocks:
            continue
        live.add(bid)
        stack.extend(blocks[bid].succ)
    dead = [bid for bid in blocks if bid not in live]
    for bid in dead:
        del blocks[bid]
    for b in blocks.values():
        b.preds = [p for p in b.preds if p in blocks]
    return len(dead)

def prune_after_trap(entry, blocks):
    """Drop the code behind a tamper trap.

    Luraph's anti-tamper handlers end in a call of a constant (`(29)(nil)`):
    calling a number always raises, so nothing after it can run. The states
    that are only reachable through such a call are decoy code -- its pc/mode
    cannot be resolved (the trap never writes them) -- and lifting it is
    pointless. Cut the trap's successors, then remove every block that is no
    longer reachable from the entry. Returns the number of blocks dropped."""
    def callee_of(st):
        call = getattr(st, "call", None)
        return getattr(call, "fn", None) if call is not None else getattr(st, "fn", None)

    def trapped(b):
        if b.kind == "crash":
            return True
        for st in b.stmts:
            fn = callee_of(st)
            if isinstance(fn, Const) and not callable(fn.v):
                return True
        return False

    live = set()
    stack = [entry]
    while stack:
        bid = stack.pop()
        if bid in live or bid not in blocks:
            continue
        live.add(bid)
        b = blocks[bid]
        if trapped(b):
            # the trap call itself stays (it is what the obfuscated code does);
            # only what it can never reach is cut away
            b.kind, b.cond, b.succ = "end", None, []
            continue
        stack.extend(b.succ)
    dead = [bid for bid in blocks if bid not in live]
    for bid in dead:
        del blocks[bid]
    for b in blocks.values():
        b.preds = [p for p in b.preds if p in blocks]
    return len(dead)

def fill(b, node, key, new_block, head_of, nodes, D, link):
    if getattr(node, "error", None):
        b.stmts += node.stmts
        b.kind = "error"
        b.error = "%s (at %s:%s)" % (node.error, key[0], key[1])
        return
    b.stmts += [s for s in node.stmts if not getattr(s, "jump", False)]
    if node.cond is not None:
        dec = getattr(node, "decided", None)
        if dec is True or dec is False:
            sub = node.then if dec else node.els
            fill(b, sub, key, new_block, head_of, nodes, D, link)
            return
        if dec == "unset":

            b.kind = "end"
            return
        t = new_block()
        e = new_block()
        t.origin = e.origin = (key[0], key[1])
        t.path, e.path = b.path + "t", b.path + "e"
        b.kind = "cond"
        b.cond = node.cond
        b.succ = [t.id, e.id]
        fill(t, node.then, key, new_block, head_of, nodes, D, link) if node.then else setattr(t, "kind", "end")
        fill(e, node.els, key, new_block, head_of, nodes, D, link) if node.els else setattr(e, "kind", "end")
        return
    oc = node.outcome
    if isinstance(oc, D.Next):
        nk = oc.state.key(link)
        if nk not in nodes:
            b.kind = "error"
            b.error = "unexplored successor %s:%s" % (nk[0], nk[1])
            return
        b.kind = "goto"
        b.succ = [head_of(nk).id]
    elif isinstance(oc, D.Ret):
        b.kind = "ret"
        b.values = oc.values
    elif isinstance(oc, D.Crash):
        b.kind = "crash"
    else:
        b.kind = "end"

_TEMP_RE = re.compile(r"\bT([^\s\[\]=(),]+)(?=\[| =)")

def _rename_temps(x, m, seen):
    """Rename call temps (TempVal/TempTail/CallStmt .t) inside IR x via map m."""
    st = [x]
    while st:
        o = st.pop()
        if isinstance(o, (list, tuple)):
            st += o
            continue
        if id(o) in seen:
            continue
        seen.add(id(o))
        t = getattr(o, "t", None)
        if isinstance(t, str) and t in m and type(o).__name__ in ("TempVal", "TempTail", "CallStmt"):
            o.t = m[t]
        d = getattr(o, "__dict__", None)
        if d is not None and type(o).__name__ not in ("LTable", "Scope", "LuaFunc"):
            st += [v for v in d.values() if v is not None and not isinstance(v, (str, int, float, bytes, bool))]

def merge_equivalent(entry, blocks, D):
    """Merge blocks that behave identically (same statements up to call-temp
    names, same kind/condition, equivalent successors): the walk keys nodes by
    the in-place decryption overlay, so two paths reaching the same code with
    different overlays produce copies that only converge later. Left alone,
    such copies make loops irreducible (a second entry into the body).
    Runs on the raw per-instruction CFG, where copies line up one to one."""
    def text(b):

        parts = [repr(b.origin), b.path, b.kind]
        parts += [D.fmt_stmt(s) for s in b.stmts]
        if b.cond is not None:
            parts.append("? " + D.fmt_expr(b.cond))
        if b.values is not None:
            parts.append("ret " + D.fmt_multi(b.values))
        if b.error:
            parts.append("err " + b.error)
        return "\n".join(parts)

    merged_any = False
    while True:
        texts, temps, defs = {}, {}, {}
        for bid, b in blocks.items():

            tx = text(b)
            order = []
            for mo in _TEMP_RE.finditer(tx):
                if mo.group(1) not in order:
                    order.append(mo.group(1))
            pos = {t: i for i, t in enumerate(order)}
            texts[bid] = _TEMP_RE.sub(lambda mo: "T#%d" % pos[mo.group(1)], tx)
            temps[bid] = order
            for s in b.stmts:
                if isinstance(s, D.CallStmt):
                    defs[s.t] = bid
        forced = set()
        while True:
            ids = {}
            cls = {}
            for bid in blocks:
                sig = ("forced", bid) if bid in forced else texts[bid]
                cls[bid] = ids.setdefault(sig, len(ids))
            n = len(ids)
            while True:
                ids2 = {}
                new = {}
                for bid, b in blocks.items():
                    new[bid] = ids2.setdefault((cls[bid], tuple(cls.get(s) for s in b.succ)), len(ids2))
                cls = new
                if len(ids2) == n:
                    break
                n = len(ids2)
            groups = {}
            for bid in sorted(blocks):
                groups.setdefault(cls[bid], []).append(bid)
            rep = {}
            for g in groups.values():
                r = entry if entry in g else g[0]
                for bid in g:
                    rep[bid] = r

            rmap = {}
            for bid, r in rep.items():
                if bid != r:
                    for x, y in zip(temps[bid], temps[r]):
                        if x != y and defs.get(x) == bid:
                            rmap[x] = y

            bad = set()
            for bid, r in rep.items():
                if bid == r:
                    continue
                for x, y in zip(temps[bid], temps[r]):
                    if rmap.get(x, x) != rmap.get(y, y):
                        bad.add(bid)
                        break
            if not bad:
                break
            forced |= bad
        if all(bid == r for bid, r in rep.items()):
            return entry, merged_any
        merged_any = True
        for bid in list(blocks):
            if rep[bid] != bid:
                del blocks[bid]
        seen = set()
        for b in blocks.values():
            b.succ = [rep[s] for s in b.succ]
            if rmap:
                _rename_temps(b.stmts, rmap, seen)
                _rename_temps([b.cond, b.values], rmap, seen)
        recompute_preds(blocks)

def _read_temps(x, out):
    """Names of the call temps an IR value reads."""
    st = [x]
    while st:
        o = st.pop()
        if o is None:
            continue
        if isinstance(o, (list, tuple)):
            st.extend(o)
            continue
        if isinstance(o, Multi):
            st.append(o.items)
            st.append(o.tail)
            continue
        if isinstance(o, (S.TempVal, S.TempTail)):
            out.add(o.t)
            d = getattr(o, "__dict__", None)
            if d is not None:
                st.extend(v for v in d.values() if v is not None
                          and not isinstance(v, (str, int, float, bytes, bool)))
            continue
        d = getattr(o, "__dict__", None)
        if d is not None and type(o).__name__ not in ("LTable", "Scope", "LuaFunc"):
            st.extend(v for v in d.values() if v is not None
                      and not isinstance(v, (str, int, float, bytes, bool)))

def _poison_multi(m, dead, D, depth=0):
    """Replace reads of dropped call temps inside one Multi."""
    if m is None or depth > 12:
        return m
    if isinstance(m, D.TempTail) and m.t in dead:
        # a multret outside a Multi: one unknown value is the safe reading
        return D.Missing(None)
    if isinstance(m, D.TempVal) and m.t in dead:
        return D.Missing(None)
    if isinstance(m, D.Multi):
        if isinstance(m.tail, D.TempTail) and m.tail.t in dead:
            # the whole multret came from a call that is not emitted
            m.items = [D.Missing(None)]
            m.tail = None
        else:
            m.items = [_poison_multi(x, dead, D, depth + 1) for x in m.items]
            m.tail = _poison_multi(m.tail, dead, D, depth + 1)
        return m
    if isinstance(m, (list, tuple)):
        return type(m)(_poison_multi(x, dead, D, depth + 1) for x in m)
    if isinstance(m, Reg):
        return m
    d = getattr(m, "__dict__", None)
    if d is not None and type(m).__name__ not in ("LTable", "Scope", "LuaFunc"):
        for k, v in list(d.items()):
            if v is None or isinstance(v, (str, int, float, bytes, bool)):
                continue
            nv = _poison_multi(v, dead, D, depth + 1)
            if nv is not v:
                setattr(m, k, nv)
    return m

def poison_unknown_callees(entry, blocks, D, frame_bound=()):
    """Drop direct calls of a register this function never defines.

    A register the finished CFG assigns nowhere and no frame binding names is
    not a value the deobfuscated function has: it is a caller's frame slot the
    walk never bound (the report's `residual_unknown`) or a slot from a branch
    the trace never took.  Printing such a callee produces `(nil)(...)`, which
    errors the moment that line runs -- and calling a value that does not
    exist is never valid Lua, which is exactly the rule
    `ProtoLifter.call_symbolic` already applies to poisoned callees at lift
    time.  Here the same rule is applied to what only the whole function can
    show: the call statement is dropped and its results become `Missing`, the
    value the rest of the engine prints as `nil --[[ constant not decoded ]]`.

    Only a *direct* register callee is treated.  A callee built out of a
    register (`r40(r102, r106)` may print `context.HttpService:JSONEncode(...)`)
    still names whatever its own parts resolve to, so it is left alone.

    Returns how many call statements were dropped.
    """
    defined = set()
    used = set()
    for bid in blocks:
        b = blocks[bid]
        for s in b.stmts:
            if isinstance(s, D.Assign) and isinstance(s.target, D.Reg):
                defined.add(s.target.n)
        for x in list(b.stmts) + [b.cond, b.values]:
            if x is None:
                continue
            _read_temps(x, used)
    dead = set()
    drops = []
    for bid in sorted(blocks):
        for s in blocks[bid].stmts:
            if not isinstance(s, D.CallStmt):
                continue
            fn = s.fn
            if not isinstance(fn, D.Reg):
                continue
            if fn.n in defined or fn.n in frame_bound:
                continue
            if s.t not in used:
                # nothing reads the results: the printer drops a nil call as a
                # statement on its own, so leave the block as it was
                continue
            dead.add(s.t)
            drops.append((bid, s))
    if not dead:
        return 0
    if os.environ.get("DEVIRT_POISON"):
        # Diagnostic: what was dropped, so a report can show the calls.
        for bid, s in drops:
            print("[poison] block=%r %s" % (bid, D.fmt_stmt(s)), file=sys.stderr)
    for bid, s in drops:
        b = blocks[bid]
        b.stmts = [x for x in b.stmts if x is not s]
    for b in blocks.values():
        if b.cond is not None:
            b.cond = _poison_multi(b.cond, dead, D)
        if b.values is not None:
            b.values = _poison_multi(b.values, dead, D)
        b.stmts = [_poison_multi(s, dead, D) for s in b.stmts]
    return len(drops)

def thread_empty(entry, blocks):
    """Skip empty goto blocks (dispatcher hops, NOPs); merge straight-line chains."""
    def target(bid, seen=None):
        seen = seen or set()
        b = blocks[bid]
        while b.kind == "goto" and not b.stmts and b.succ and b.succ[0] not in seen and b.id != b.succ[0]:
            seen.add(b.id)
            b = blocks[b.succ[0]]
        return b.id
    entry = target(entry)
    for b in blocks.values():
        b.succ = [target(s) for s in b.succ]

    for b in blocks.values():
        if b.kind == "cond" and b.succ[0] == b.succ[1]:
            b.kind = "goto"
            b.succ = [b.succ[0]]
            b.cond = None
    reach = reachable(entry, blocks)
    for bid in list(blocks):
        if bid not in reach:
            del blocks[bid]
    recompute_preds(blocks)

    changed = True
    while changed:
        changed = False
        for b in list(blocks.values()):
            if b.id not in blocks or b.kind != "goto" or not b.succ:
                continue
            s = blocks[b.succ[0]]
            if s.id == b.id or len(s.preds) != 1 or s.id == entry:
                continue
            b.stmts += s.stmts
            b.kind, b.cond, b.succ, b.values, b.error = s.kind, s.cond, s.succ, s.values, s.error
            del blocks[s.id]
            # s vanished: b now feeds s's successors directly. Update their
            # preds in place instead of a full O(V+E) recompute per merge
            # (this loop used to be O(merges x blocks)).
            for x in b.succ:
                if x in blocks:
                    ps = blocks[x].preds
                    for pi, p in enumerate(ps):
                        if p == s.id:
                            ps[pi] = b.id
            changed = True
    recompute_preds(blocks)
    return entry

def reachable(entry, blocks):
    seen = set()
    st = [entry]
    while st:
        x = st.pop()
        if x in seen or x not in blocks:
            continue
        seen.add(x)
        st += blocks[x].succ
    return seen

def recompute_preds(blocks):
    for b in blocks.values():
        b.preds = []
    for b in blocks.values():
        for s in b.succ:
            if s in blocks:
                blocks[s].preds.append(b.id)

def rpo(entry, succ):
    order = []
    seen = set()
    stack = [(entry, iter(succ(entry)))]
    seen.add(entry)
    while stack:
        n, it = stack[-1]
        for s in it:
            if s not in seen:
                seen.add(s)
                stack.append((s, iter(succ(s))))
                break
        else:
            stack.pop()
            order.append(n)
    order.reverse()
    return order

def dominators(entry, succ, preds):
    order = rpo(entry, succ)
    index = {n: i for i, n in enumerate(order)}
    idom = {entry: entry}

    def intersect(a, b):
        while a != b:
            while index[a] > index[b]:
                a = idom[a]
            while index[b] > index[a]:
                b = idom[b]
        return a
    changed = True
    while changed:
        changed = False
        for n in order[1:]:
            ps = [p for p in preds(n) if p in idom and p in index]
            if not ps:
                continue
            new = ps[0]
            for p in ps[1:]:
                new = intersect(p, new)
            if idom.get(n) != new:
                idom[n] = new
                changed = True
    return idom, index

def dominates(idom, a, b):
    """a dominates b"""
    while True:
        if b == a:
            return True
        nb = idom.get(b)
        if nb is None or nb == b:
            return False
        b = nb

class SBlock(list):
    pass

class SIf:
    def __init__(self, cond, then, els):
        self.cond, self.then, self.els = cond, then, els

class SLoop:
    """while true do body end (refined later into while/repeat/for)."""

    def __init__(self, body):
        self.body = body
        self.kind = "while"
        self.cond = None
        self.forinfo = None

class SBreak:
    pass

class SContinue:
    pass

class SReturn:
    def __init__(self, values):
        self.values = values

class SError:
    def __init__(self, msg):
        self.msg = msg

class SCrash(SError):
    """LPH_CRASH() (Luraph's inlined crash: scrambles the VM, loops forever)."""

    def __init__(self):
        self.msg = "LPH_CRASH"

class SGotoState:
    """Fallback: jump in the state machine used for unstructurable regions."""

    def __init__(self, target):
        self.target = target

class SStateMachine:
    def __init__(self, entry, cases):
        self.entry, self.cases = entry, cases

class Structurer:
    def __init__(self, entry, blocks):
        self.entry = entry
        self.blocks = blocks
        succ = lambda n: blocks[n].succ  
        preds = lambda n: blocks[n].preds  
        self.idom, self.rpo_index = dominators(entry, succ, preds)

        self.loops = {}
        for b in blocks.values():
            for s in b.succ:
                if s in self.idom and b.id in self.idom and dominates(self.idom, s, b.id):
                    self.loops.setdefault(s, set()).add(b.id)
        self.loop_body = {}
        for h, latches in self.loops.items():
            body = {h}
            st = list(latches)
            while st:
                x = st.pop()
                if x in body:
                    continue
                body.add(x)
                st += [p for p in blocks[x].preds if p in self.idom]
            self.loop_body[h] = body

        exits = [b.id for b in blocks.values() if not b.succ]
        rsucc = {n: list(blocks[n].preds) for n in blocks}
        rpred = {n: list(blocks[n].succ) for n in blocks}
        rsucc[0] = exits
        rpred[0] = []
        for e in exits:
            rpred[e] = rpred[e] + [0]

        can = reachable_rev(0, rsucc)
        for n in blocks:
            if n not in can:
                rsucc[0].append(n)
                rpred[n] = rpred[n] + [0]
        self.ipdom, _ = dominators(0, lambda n: rsucc.get(n, []), lambda n: rpred.get(n, []))
        self.emitted = set()
        self.fallbacks = 0
        self.state_machine = False
        self.stub_follows = set()
        self.gotos = []         
        self.loop_exit = {}     

    def ipdom_of(self, n):
        p = self.ipdom.get(n)
        return None if p in (None, 0) else p

    def run(self):
        return self.region(self.entry, None, None)

    def region(self, cur, stop, loop):
        """Statements from `cur` until `stop` (exclusive). loop = (header, body, exit)."""
        out = SBlock()
        guard = 0
        while cur is not None and cur != stop:
            guard += 1
            if guard > 100000:
                out.append(SError("structuring did not terminate"))
                break
            if loop is not None:
                h, body, ex = loop
                if cur == h:
                    out.append(SContinue())
                    return out
                if cur == ex:
                    out.append(SBreak())
                    return out
                if cur not in body:

                    tail = self.terminal_tail(cur, loop)
                    if tail is not None:
                        out += tail
                        return out
                    if self.same_as_exit(cur, ex):

                        out.append(SBreak())
                        return out
                    if self.breaking_region(cur, h, body, ex):

                        out += self.region(cur, ex, None)
                        out.append(SBreak())
                        return out
                    if self.returning_region(cur, body):

                        out += self.region(cur, None, None)
                        return out
                    out.append(SGotoState(cur))
                    self.gotos.append(("exit", h, cur))
                    self.debug_goto("leaves loop %s (exit %s: %s %s, %d stmts)" % (
                        h, ex, self.blocks[ex].kind if ex in self.blocks else "?",
                        self.blocks[ex].succ if ex in self.blocks else "?",
                        len(self.blocks[ex].stmts) if ex in self.blocks else -1), cur)
                    self.fallbacks += 1
                    return out
            if cur in self.emitted and cur not in self.loops:

                tail = self.terminal_tail(cur, loop)
                if tail is not None:
                    out += tail
                    return out
                out.append(SGotoState(cur))
                self.gotos.append(("shared", cur))
                self.debug_goto("already emitted (loop %s)" % (loop[0] if loop else None,), cur)
                self.fallbacks += 1
                return out
            if cur in self.loops and (loop is None or loop[0] != cur):
                cur = self.emit_loop(cur, out, loop)
                lp = out[-1]
                if lp.kind == "while" and not breaks(lp.body):

                    return out
                continue
            if self.blocks[cur].kind in ("for", "forin"):
                out.append(SError("for loop without back edge"))
                return out
            self.emitted.add(cur)
            b = self.blocks[cur]
            out += b.stmts
            if b.kind == "ret":
                out.append(SReturn(b.values))
                return out
            if b.kind == "error":
                out.append(SError(b.error))
                return out
            if b.kind == "crash":
                out.append(SCrash())
                return out
            if b.kind == "end":
                return out
            if b.kind == "goto":
                if not b.succ:      # dead end cut by the trap/reachability passes
                    return out
                cur = b.succ[0]
                continue

            t, e = b.succ
            m = self.ipdom_of(cur)
            if loop is not None and m is not None and m not in loop[1] and (m != loop[2] or m in self.stub_follows):

                m = None
            if loop is not None and m == loop[0]:
                if (t == loop[0] or e == loop[0]) and stop is not None and stop != loop[0] and stop in loop[1]:

                    c = b.cond if t == loop[0] else negate(b.cond)
                    out.append(SIf(c, SBlock([SContinue()]), SBlock()))
                    cur = e if t == loop[0] else t
                    continue

                m = self.common_join(t, e, loop, stop) or (m if stop is None or stop == loop[0] else None)
            if stop is not None and m is not None and m != stop:
                if m not in self.reach_from(t, loop, stop) or m not in self.reach_from(e, loop, stop):
                    m = None
            if m is None:

                m = self.common_join(t, e, loop, stop)
            if m is None:

                then = self.region(t, stop, loop)
                if terminal(then):
                    out.append(SIf(b.cond, then, SBlock()))
                    cur = e
                    continue
                els = self.region(e, stop, loop)
                if terminal(els):
                    out.append(SIf(negate(b.cond), els, SBlock()))
                    out += then
                    return out
                out.append(SIf(b.cond, then, els))
                return out
            then = self.region(t, m, loop)
            els = self.region(e, m, loop)
            out.append(SIf(b.cond, then, els))
            cur = m
        return out

    def emit_loop(self, h, out, outer):
        body = self.loop_body[h]

        exits = []
        for n in body:
            for s in self.blocks[n].succ:
                if s not in body and s not in exits:
                    exits.append(s)
        ex = None
        if len(exits) == 1:
            ex = exits[0]
        elif exits:

            p = self.ipdom_of(h)
            while p is not None and p in body:
                p = self.ipdom_of(p)
            ex = p if p in exits else min(exits, key=lambda x: self.rpo_index.get(x, 1 << 30))
            ex = self.stub_follow(ex, exits, body)
        self.emitted.add(h)
        b = self.blocks[h]
        if b.kind in ("for", "forin"):
            ex = b.succ[1]
        self.loop_exit[h] = ex
        if b.kind in ("for", "forin"):
            loop = (h, body, ex)
            lp = SLoop(self.region(b.succ[0], None, loop))
            lp.kind = b.kind
            lp.forinfo = b.values
            out.append(lp)
            return ex
        inner = SBlock(b.stmts)
        loop = (h, body, ex)
        if b.kind == "goto":
            inner += self.region_after(b.succ[0], loop)
        elif b.kind == "cond":
            t, e = b.succ
            m = self.ipdom_of(h)
            if m is not None and m not in body:
                m = None
            if m is None:
                m = self.common_join(t, e, loop)
            then = self.region(t, m, loop)
            els = self.region(e, m, loop)
            inner.append(SIf(b.cond, then, els))
            if m is not None:
                inner += self.region(m, None, loop)
        elif b.kind == "ret":
            inner.append(SReturn(b.values))
        elif b.kind == "error":
            inner.append(SError(b.error))
        elif b.kind == "crash":
            inner.append(SCrash())
        lp = SLoop(inner)
        out.append(lp)
        return ex

    def is_exit_stub(self, x, body, limit=12):
        """A short straight-line block entered only from the loop body."""
        b = self.blocks.get(x)
        return (b is not None and b.kind == "goto" and x not in self.loops and len(b.stmts) <= limit
                and all(p in body for p in b.preds))

    def stub_follow(self, ex, exits, body):
        """Exits that each run a few statements of their own and then meet in
        one block (`if c then done = false break end ... done = true break`):
        that block is the loop's follow, every stub becomes `stmts; break`
        (terminal_tail copies them)."""
        if not self.is_exit_stub(ex, body):
            return ex
        f = self.blocks[ex].succ[0]
        if f in body or f in self.loops:
            return ex
        n = 0
        for x in exits:
            if x == f:
                n += 1
            elif x != ex and self.is_exit_stub(x, body) and self.blocks[x].succ[0] == f:
                n += 1
        if not n:
            return ex
        self.stub_follows.add(f)
        return f

    def reach_from(self, start, loop, stop=None):
        """Blocks reachable from `start` without passing `stop` or the loop
        header/exit (or leaving the loop body)."""
        seen = set()
        st = [start]
        while st:
            x = st.pop()
            if x in seen:
                continue
            if stop is not None and x == stop:
                seen.add(x)
                continue
            if loop is not None and (x == loop[0] or x == loop[2] or x not in loop[1]):
                continue
            seen.add(x)
            st += self.blocks[x].succ
        return seen

    def common_join(self, t, e, loop, stop=None):
        """The earliest (reverse post-order) block reachable from both branch
        targets before `stop`, not yet emitted; None if there is none."""
        a = self.reach_from(t, loop, stop)
        if not a:
            return None
        both = [x for x in self.reach_from(e, loop, stop) if x in a and (x == stop or x not in self.emitted)]
        if not both:
            return None
        m = min(both, key=lambda x: self.rpo_index.get(x, 1 << 30))

        for h, body in self.loop_body.items():
            if m in body and h != m and (loop is None or h != loop[0]) and (t not in body or e not in body):
                return None
        return m

    def same_as_exit(self, cur, ex):
        """Are blocks cur and ex interchangeable: same statements (as text),
        both simple jumps to the same block?"""
        if ex is None or cur == ex or cur not in self.blocks or ex not in self.blocks:
            return False
        a, b = self.blocks[cur], self.blocks[ex]
        if a.kind != "goto" or b.kind != "goto" or a.succ != b.succ or len(a.stmts) != len(b.stmts):
            return False
        import codegen
        r = codegen.Renderer()
        return all(r.stmt(x, "") == r.stmt(y, "") for x, y in zip(a.stmts, b.stmts))

    def breaking_region(self, cur, h, body, ex, limit=40):
        """Is every block reachable from `cur` (up to the loop exit `ex`) new,
        outside any loop, entered only from itself or the loop `body`, and does
        every path end at `ex`?"""
        if ex is None or ex not in self.blocks:
            return False
        seen = set()
        st = [cur]
        while st:
            x = st.pop()
            if x == ex or x in seen:
                continue
            seen.add(x)
            b = self.blocks[x]
            if len(seen) > limit or x in self.emitted or x in body or b.kind not in ("goto", "cond"):
                return False
            if any(x in lb and h not in lb for lb in self.loop_body.values()):

                return False
            st += b.succ
        return all(p in seen or p in body for x in seen for p in self.blocks[x].preds)

    def returning_region(self, cur, body, limit=400):
        """Is every block reachable from `cur` new (not emitted), outside any
        loop, entered only from itself or from the loop `body`, and does every
        path end in return / error?"""
        seen = set()
        st = [cur]
        while st:
            x = st.pop()
            if x in seen:
                continue
            seen.add(x)
            if len(seen) > limit or x in self.emitted:
                return False
            st += self.blocks[x].succ
        for x in seen:
            if any(p not in seen and p not in body for p in self.blocks[x].preds):
                return False

        for h, lb in self.loop_body.items():
            if (h in seen) != bool(lb & seen) or (h in seen and not lb <= seen):
                return False
        return True

    def debug_goto(self, why, cur):
        if not os.environ.get("DEVIRT_DEBUG"):
            return
        if os.environ.get("DEVIRT_BLOCKS") and not getattr(self, "_dumped", False):
            self._dumped = True
            import codegen
            r = codegen.Renderer()
            for bid in sorted(self.blocks, key=lambda x: self.rpo_index.get(x, 1 << 30)):
                bb = self.blocks[bid]
                print("  B%s %s succ %s preds %s loops %s ipdom %s" % (bid, bb.kind, bb.succ, bb.preds, [h for h, body in self.loop_body.items() if bid in body], self.ipdom_of(bid)), file=sys.stderr)
                for x in bb.stmts:
                    try:
                        print("      " + " ".join(r.stmt(x, "")), file=sys.stderr)
                    except Exception:
                        print("      ?", type(x).__name__, file=sys.stderr)
                if bb.kind == "cond":
                    try:
                        print("      if " + r.expr(bb.cond), file=sys.stderr)
                    except Exception:
                        pass
        b = self.blocks[cur]
        print("[goto] block %s: %s; kind %s succ %s preds %s, %d stmts, origin %s, ipdom %s, loops containing: %s"
              % (cur, why, b.kind, b.succ, b.preds, len(b.stmts), b.origin, self.ipdom_of(cur),
                 [h for h, body in self.loop_body.items() if cur in body]), file=sys.stderr)

    def terminal_tail(self, cur, loop=None, limit=40):
        """If `cur` runs straight (gotos only) into a return / error, or into
        the current loop's header (continue) or exit (break), a copy of that
        code (tail duplication: shared return blocks and loop latches, `return`
        from inside a loop). None when it branches, loops or is too long."""
        out = []
        seen = set()
        while True:
            if loop is not None and cur == loop[0] and out is not None and seen:
                out.append(SContinue())
                return out
            if loop is not None and cur == loop[2] and seen:
                out.append(SBreak())
                return out
            if cur in seen or cur in self.loops:
                return None
            seen.add(cur)
            b = self.blocks[cur]

            out += [copy.deepcopy(s) for s in b.stmts]
            if len(out) > limit:
                return None
            if b.kind == "ret":
                out.append(SReturn(b.values))
                return out
            if b.kind == "error":
                out.append(SError(b.error))
                return out
            if b.kind == "crash":
                out.append(SCrash())
                return out
            if b.kind != "goto":
                return None
            cur = b.succ[0]

    def region_after(self, cur, loop):
        return self.region(cur, None, loop)

SPLIT_LIMIT = 3500      

def structure(entry, blocks, own=None, rounds=128):
    """Structurer.run, with its goto fallbacks resolved by CFG rewrites:
    - a jump out of a loop to somewhere other than the loop's exit (a
      multi-level break/continue, a second exit): every exit edge sets a
      selector variable and all of them meet in one dispatch after the loop
      (`exitTo = 1 break` ... `if exitTo == 1 then ... end`), see unify_exits;
    - a block reached again after it was emitted (code shared by paths the
      structurer keeps apart): node splitting, a copy per extra predecessor;
    irreducible loops are split first (make_reducible). Repeats until no goto
    is left; if the copy budget runs out, the function becomes a state
    machine. `own` gets the new variables. -> (entry, body, last Structurer)."""

    first = {}
    for bid, b in blocks.items():
        c = first[bid] = copy.copy(b)
        c.stmts, c.succ = list(b.stmts), list(b.succ)
    first = (entry, first)
    make_reducible(entry, blocks)
    copied = 0
    nflag = 0
    for _ in range(rounds):
        recompute_preds(blocks)     # the fixers below read b.preds
        sr = Structurer(entry, blocks)
        body = sr.run()
        if not sr.gotos:
            break
        exits = [g for g in sr.gotos if g[0] == "exit" and g[1] in sr.loop_exit]
        if exits:
            nflag += 1
            name = "exitTo" if nflag == 1 else "exitTo%d" % nflag
            if own is not None:
                own.add(name)
            entry = unify_exits(entry, blocks, sr, exits[0][1], name)
            continue
        seen_targets = []
        for g in sr.gotos:
            if g[0] == "shared" and g[1] in blocks and g[1] not in seen_targets:
                seen_targets.append(g[1])
        n = 0
        for target in seen_targets:
            if copied >= SPLIT_LIMIT:
                break
            k = split_node(blocks, target, sr)
            if not k:
                hs = [h for h, body in sr.loop_body.items() if target in body]
                hs.sort(key=lambda h: len(sr.loop_body[h]))
                for h in hs:
                    k = split_node(blocks, h, sr, [p for p in blocks[h].preds
                                                   if p not in sr.loop_body[h]])
                    if k:
                        break
            if k:
                copied += k
                n += 1
                break
        if not n:
            break
    if sr.fallbacks:
        # irreducible control flow: one dispatch loop for the whole function.
        # Count it as one fallback (not as one per goto) so the run summary
        # says how many functions were not structured.
        if own is not None:
            own.add("state")
        body = state_machine(*first, "state", own)
        sr.fallbacks = 0
        sr.state_machine = True
    return entry, body, sr

def state_machine(entry, blocks, name, own=None):
    """Last resort, always correct: the whole function as a dispatch loop
    over its blocks (`local state = 1 while true do if state == 1 then ...`).
    Numeric and generic `for` headers are desugared into explicit state
    variables initialized at their ForPrepS site."""
    import codegen as CG
    order = rpo(entry, lambda n: blocks[n].succ)
    num = {bid: i for i, bid in enumerate(order, 1)}

    def add_own(nm):
        if own is not None:
            own.add(nm)
        return CG.LocalName(nm)

    prep_repl = {}
    for_meta = {}
    fk = 0
    for bid in order:
        b = blocks[bid]
        if b.kind == "for":
            fk += 1
            var, lst = b.values
            fi = add_own("forIdx_%d" % fk)
            fl = add_own("forLim_%d" % fk)
            fs = add_own("forStep_%d" % fk)
            prep_repl[id(lst)] = CG.AssignS(
                [fi, fl, fs],
                S.Multi([Bin("Sub", lst[0], lst[2]), lst[1], lst[2]]),
            )
            for_meta[bid] = ("for", var, fi, fl, fs, lst[2])
        elif b.kind == "forin":
            fk += 1
            vars_, lst = b.values
            fit = add_own("forIter_%d" % fk)
            fok = add_own("forOk_%d" % fk)
            fvs = add_own("forVals_%d" % fk)
            prep_repl[id(lst)] = CG.AssignS([fit], S.Multi([CG.GenIterE(list(lst))]))
            for_meta[bid] = ("forin", vars_, fit, fok, fvs)

    def goto(t):
        return _set_stmt(name, num[t])
    cases = []
    for bid in order:
        b = blocks[bid]
        stmts = [prep_repl[id(s.exprs)] if isinstance(s, CG.ForPrepS) and id(s.exprs) in prep_repl else s
                 for s in b.stmts]
        out = SBlock(stmts)
        if b.kind == "goto":
            out.append(goto(b.succ[0]))
        elif b.kind == "cond":
            out.append(SIf(b.cond, SBlock([goto(b.succ[0])]), SBlock([goto(b.succ[1])])))
        elif b.kind == "for":
            _, var, fi, fl, fs, step_e = for_meta[bid]
            out.append(CG.AssignS([fi], S.Multi([Bin("Add", fi, fs)])))
            out.append(CG.AssignS([var], S.Multi([fi])))
            if isinstance(step_e, Const) and isinstance(step_e.v, (int, float)) and not isinstance(step_e.v, bool):
                cond = Bin("CompareGe" if step_e.v <= 0 else "CompareLe", fi, fl)
            else:
                cond = Bin("Or",
                           Bin("And", Bin("CompareLe", fs, Const(0)), Bin("CompareGe", fi, fl)),
                           Bin("And", Bin("CompareGt", fs, Const(0)), Bin("CompareLe", fi, fl)))
            out.append(SIf(cond, SBlock([goto(b.succ[0])]), SBlock([goto(b.succ[1])])))
        elif b.kind == "forin":
            _, vars_, fit, fok, fvs = for_meta[bid]
            out.append(CG.AssignS([fok, fvs], S.Multi([], CG.InlineTail(CG.CallE(fit, S.Multi([]))))))
            unpack_stmts = []
            if vars_:
                unpack_stmts.append(CG.AssignS(
                    list(vars_),
                    S.Multi([S.Index(fvs, Const(idx)) for idx in range(1, len(vars_) + 1)]),
                ))
            unpack_stmts.append(goto(b.succ[0]))
            out.append(SIf(fok, SBlock(unpack_stmts), SBlock([goto(b.succ[1])])))
        elif b.kind == "ret":
            out.append(SReturn(b.values))
        elif b.kind == "error":
            out.append(SError(b.error))
        elif b.kind == "crash":
            out.append(SCrash())
        elif b.kind == "end":
            # dead path (a decided-away branch or an outcome-less block): the
            # linear structurer just stops emitting here, which in the state
            # machine form is an implicit return -- falling through instead
            # would leave the state variable unchanged and loop forever
            out.append(SReturn(None))
        else:
            # a new Block kind must be handled here explicitly; silently
            # emitting `return` hid the bug and corrupted the output
            out.append(SError("state machine: unhandled block kind %s" % b.kind))
        cases.append((num[bid], out))

    def build_dispatch(sub):
        if len(sub) <= 24:
            ch = SBlock()
            for k, out in reversed(sub):
                test = Bin("CompareEq", CG.LocalName(name), Const(k))
                ch = SBlock([SIf(test, out, ch)])
            return ch
        mid = len(sub) // 2
        pivot = sub[mid - 1][0]
        left = build_dispatch(sub[:mid])
        right = build_dispatch(sub[mid:])
        return SBlock([SIf(Bin("CompareLe", CG.LocalName(name), Const(pivot)), left, right)])

    chain = build_dispatch(cases)
    return SBlock([_set_stmt(name, 1), SLoop(chain)])

def sccs(nodes, succ):
    """Strongly connected components of the subgraph on `nodes` (iterative Tarjan)."""
    index, low, on, stack, out = {}, {}, set(), [], []
    n = 0
    for root in nodes:
        if root in index:
            continue
        work = [(root, iter([s for s in succ(root) if s in nodes]))]
        index[root] = low[root] = n
        n += 1
        stack.append(root)
        on.add(root)
        while work:
            v, it = work[-1]
            for w in it:
                if w not in index:
                    index[w] = low[w] = n
                    n += 1
                    stack.append(w)
                    on.add(w)
                    work.append((w, iter([s for s in succ(w) if s in nodes])))
                    break
                if w in on:
                    low[v] = min(low[v], index[w])
            else:
                work.pop()
                if work:
                    low[work[-1][0]] = min(low[work[-1][0]], low[v])
                if low[v] == index[v]:
                    comp = set()
                    while True:
                        w = stack.pop()
                        on.discard(w)
                        comp.add(w)
                        if w == v:
                            break
                    out.append(comp)
    return out

def make_reducible(entry, blocks):
    """Irreducible loops (a cycle entered at more than one block: the
    structurer finds no natural loop there) become reducible by node
    splitting: the entry first in reverse post-order is the header; the
    blocks another entry reaches before the header are copied for the
    edges from outside, and those copies run into the header. Nested cycles
    (the component minus its header) are handled the same way.
    -> number of splits."""
    copied = 0
    for _ in range(200):
        order = rpo(entry, lambda n: blocks[n].succ)
        rank = {n: i for i, n in enumerate(order)}
        if not _split_irreducible(entry, blocks, set(order), rank):
            break
        copied += 1
        if sum(len(b.stmts) + 1 for b in blocks.values()) > 50 * SPLIT_LIMIT:
            break
    return copied

def _split_irreducible(entry, blocks, nodes, rank):
    succ = lambda n: blocks[n].succ  
    for comp in sccs(sorted(nodes, key=lambda n: rank.get(n, 1 << 30)), succ):
        if len(comp) == 1:
            continue
        entries = sorted({n for n in comp if n == entry or any(p not in comp for p in blocks[n].preds)},
                         key=lambda n: rank.get(n, 1 << 30))
        if not entries:
            continue
        h = entries[0]
        if len(entries) > 1:
            e = entries[1]

            region = []
            st = [e]
            while st:
                x = st.pop()
                if x in region or x == h or x not in comp:
                    continue
                region.append(x)
                st += blocks[x].succ
            m = copy_region(blocks, region)
            for p in set(blocks[e].preds):
                if p not in comp:
                    blocks[p].succ = [m[e] if s == e else s for s in blocks[p].succ]
            recompute_preds(blocks)
            return True
        if _split_irreducible(entry, blocks, comp - {h}, rank):
            return True
    return False

def copy_region(blocks, region):
    """New blocks copying `region`; edges inside it go to the copies, edges
    out of it where the originals' go. One deepcopy memo for the region:
    objects shared between its blocks (a ForPrepS and its `for` header's
    LoopExprs) stay shared in the copy. -> {original id: copy id}."""
    m = {}
    for r in region:
        m[r] = _new_id(blocks)
        blocks[m[r]] = Block(m[r])
    memo = {}
    for r in region:
        o, c = blocks[r], blocks[m[r]]
        c.stmts = copy.deepcopy(o.stmts, memo)
        c.cond = copy.deepcopy(o.cond, memo)
        c.values = copy.deepcopy(o.values, memo)
        c.kind, c.error, c.origin, c.path = o.kind, o.error, o.origin, o.path
        c.succ = [m.get(s, s) for s in o.succ]
    return m

def _new_id(blocks):
    return max(blocks) + 1

def _set_stmt(name, v):
    import codegen as CG
    return CG.AssignS([CG.LocalName(name)], S.Multi([Const(v)]))

def unify_exits(entry, blocks, sr, h, name):
    """Loop `h` gets a single exit: each other exit x_k is entered through a
    stub `name = k` and a dispatch block after the loop picks the target
    (`if name == k then goto x_k ... else goto <main exit>`). `name` is reset
    on the way into the loop, so a stale value of an earlier run of the loop
    never selects an exit."""
    import codegen as CG
    body = sr.loop_body[h]
    main = sr.loop_exit[h]
    exits = []
    for n in sorted(body, key=lambda x: sr.rpo_index.get(x, 1 << 30)):
        for s in blocks[n].succ:
            if s not in body and s not in exits:
                exits.append(s)
    others = [x for x in exits if x != main]
    if main is None:
        main, others = others[-1], others[:-1]

    disp = []
    for k, x in enumerate(others, 1):
        d = Block(_new_id(blocks))
        blocks[d.id] = d
        d.kind = "cond"
        d.cond = Bin("CompareEq", CG.LocalName(name), Const(k))
        disp.append(d)
    for i, d in enumerate(disp):
        d.succ = [others[i], disp[i + 1].id if i + 1 < len(disp) else main]
    head = disp[0].id if disp else main
    stub = {}
    for k, x in enumerate(others, 1):
        st = Block(_new_id(blocks))
        blocks[st.id] = st
        st.stmts = [_set_stmt(name, k)]
        st.succ = [head]
        stub[x] = st.id
    stub[main] = head
    for n in body:
        b = blocks[n]
        b.succ = [stub.get(s, s) if s not in body else s for s in b.succ]

    pre = Block(_new_id(blocks))
    blocks[pre.id] = pre
    pre.stmts = [_set_stmt(name, None)]
    pre.succ = [h]
    for p in set(blocks[h].preds):
        if p not in body:
            blocks[p].succ = [pre.id if s == h else s for s in blocks[p].succ]
    if h == entry:
        entry = pre.id
    recompute_preds(blocks)
    return entry

def split_node(blocks, x, sr, preds=None):
    """Node splitting: one copy of the region x heads per predecessor but the
    first (reverse post-order). The region is what x dominates up to where the
    paths sharing x meet again, so each copy keeps its inner joins.
    -> number of statements copied."""
    b = blocks[x]
    cand, preds = b.preds if preds is None else preds, []
    for p in cand:
        if p not in preds and p != x:
            preds.append(p)
    if len(preds) < 2:
        return 0
    preds.sort(key=lambda p: sr.rpo_index.get(p, 1 << 30))

    def region_to(stop):
        out = []
        st = [x]
        while st:
            n = st.pop()
            if n in out or n == stop or n not in blocks or not dominates(sr.idom, x, n):
                continue
            out.append(n)
            st += blocks[n].succ
        return out, sum(len(blocks[n].stmts) + 1 for n in out)

    fork = sr.idom.get(x)
    for stop in ([sr.ipdom_of(fork)] if fork is not None and fork != x else []) + [sr.ipdom_of(x)]:
        region, size = region_to(stop)
        if x in region and size <= SPLIT_LIMIT // 4:
            break
    else:
        region, size = [x], len(b.stmts) + 1
    n = 0
    for p in preds[1:]:
        m = copy_region(blocks, region)
        pb = blocks[p]
        pb.succ = [m[x] if s == x else s for s in pb.succ]
        n += size
    recompute_preds(blocks)
    return n

def reachable_rev(start, succ):
    seen = set()
    st = [start]
    while st:
        x = st.pop()
        if x in seen:
            continue
        seen.add(x)
        st += succ.get(x, [])
    return seen

def negate(c):
    from luasym import Un, Bin
    if isinstance(c, Un) and c.op == "Not":
        return c.a
    flip = {"CompareEq": "CompareNe", "CompareNe": "CompareEq"}
    if isinstance(c, Bin) and c.op in flip:
        return Bin(flip[c.op], c.a, c.b)
    return Un("Not", c)

def cleanup(stmts, in_loop_tail=False):
    """Trailing `continue` in loops, empty then-branches, nested cleanups."""
    out = SBlock()
    for i, st in enumerate(stmts):

        dead_after = isinstance(st, SIf) and terminal(st.then) and terminal(st.els)
        last = i == len(stmts) - 1 or dead_after
        if isinstance(st, SIf):
            st.then = cleanup(st.then, in_loop_tail and last)
            st.els = cleanup(st.els, in_loop_tail and last)
            if in_loop_tail and last:

                st.els = _tail_guard_to_if(st.els)
            if not st.then and st.els:
                st.cond, st.then, st.els = negate(st.cond), st.els, SBlock()
            if not st.then and not st.els and not _has_call(st.cond):
                st = None
        elif isinstance(st, SLoop):
            st.body = cleanup(st.body, True)
        elif isinstance(st, SContinue) and last and in_loop_tail:
            st = None
        if st is not None:
            out.append(st)
        if dead_after:
            break
    return out

def _tail_guard_to_if(stmts):
    """At a loop body's tail, `if c then continue end; R` == `if not c then R end`."""
    if (len(stmts) >= 2 and isinstance(stmts[0], SIf) and not stmts[0].els
            and len(stmts[0].then) == 1 and isinstance(stmts[0].then[0], SContinue)):
        return SBlock([SIf(negate(stmts[0].cond), SBlock(stmts[1:]), SBlock())])
    return stmts

def _has_call(e):
    import codegen as CG
    return any(isinstance(x, CG.CallE) for x in CG.walk(e))

def breaks(stmts):
    """Does this loop body contain a `break` of its own loop?"""
    for st in stmts:
        if isinstance(st, SBreak):
            return True
        if isinstance(st, SIf) and (breaks(st.then) or breaks(st.els)):
            return True
    return False

def terminal(stmts):
    """Does this statement list always leave (return, break, continue, error)?"""
    if not stmts:
        return False
    last = stmts[-1]
    if isinstance(last, (SReturn, SBreak, SContinue, SError, SGotoState)):
        return True
    if isinstance(last, SIf):
        return terminal(last.then) and terminal(last.els)
    return False
