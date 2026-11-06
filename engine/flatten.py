"""Unroll the obfuscator's constant-state dispatch loops.

Luraph flattens control flow into a loop over a range whose three bounds are
constants, and dispatches on the loop counter:

    local step = 67
    local limit = 143
    local counter = 76 - step

    while true do
        counter += step

        if not (step <= 0) then
            if not (counter <= limit) then break end
        elseif not (counter >= limit) then break end

        local state = counter

        if state == 76 then
            setup()
        elseif state == 143 then
            run()
        end
    end

Nothing here is unknown: the loop runs over the literal sequence 76, 143, and
`state` is therefore 76 in the first pass and 143 in the second. Reading it
means holding the sequence in your head and evaluating the comparisons by hand,
which is exactly what the obfuscator is buying. So this pass evaluates it:
every value is computed, the `state` comparisons fold to `true`/`false`, and the
loop is replaced by the statements it really performs, in order.

The rewrite is confined to the loop's own source spans, so comments (including
the `-- devirt:` notes) and formatting everywhere else survive untouched. It is
deliberately timid:

  * the step, limit and counter must be locals that nothing ever assigns after
    their declaration, and the initial values must be integer literals;
  * the loop must have the exact numeric-`for` preamble above (`counter += step`
    then the two signed break checks), not a lookalike;
  * the run length must be finite and at most MAX_ITER iterations;
  * a `break` or `continue` reached after folding stops that iteration, but one
    that is still conditional after folding abandons the whole loop
    (`conditional-jump`), because unrolling cannot express it without inventing
    a control-flow structure of its own;
  * an `if` that does not fold is copied through unchanged, so the rest of the
    body keeps its original text.

A loop that is skipped is left exactly as it was. Nothing is guessed: the only
values this pass uses are the ones the constants already dictate, and a loop
that does not meet every condition above is reported by reason and left alone.
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import ast_polish as AP

MAX_ITER = 256

STATS = {}

_OPEN = {"+": "Add", "-": "Sub", "*": "Mul", "//": "FloorDiv", "%": "Mod"}
_CMP = {"==": "Eq", "~=": "Ne", "<": "Lt", "<=": "Le", ">": "Gt", ">=": "Ge"}
_CMPOPS = {"CompareEq", "CompareNe", "CompareLt", "CompareLe", "CompareGt", "CompareGe"}


def _lines(node):
    """The AST of `text` (latin-1 str), parsed by the same binary as the lift."""
    return AP._parse_ast(node)


def _span(loc, starts):
    return AP._loc_bytes(loc, starts)


def _num(e):
    """The integer a numeric literal node stands for, else None."""
    if not isinstance(e, dict) or e.get("type") != "AstExprConstantNumber":
        return None
    v = e.get("value")
    if isinstance(v, bool) or not isinstance(v, (int, float)):
        return None
    if isinstance(v, float):
        if not v.is_integer():
            return None
        v = int(v)
    return v


def _is_const(e, env):
    """(True, value) when `e` is a literal or a constant local, else (False, None)."""
    if not isinstance(e, dict):
        return False, None
    t = e.get("type")
    if t == "AstExprConstantNumber":
        v = _num(e)
        return (v is not None), v
    if t == "AstExprConstantBool":
        return True, bool(e.get("value"))
    if t == "AstExprGroup" or t == "AstExprInner":
        return _is_const(e.get("expr"), env)
    if t == "AstExprUnary":
        ok, v = _is_const(e.get("expr"), env)
        if not ok:
            return False, None
        if e.get("op") == "Not":
            return True, not v
        if e.get("op") == "Minus" and isinstance(v, int):
            return True, -v
        return False, None
    if t == "AstExprLocal":
        loc = (e.get("local") or {}).get("location")
        if loc in env:
            return True, env[loc]
        return False, None
    if t == "AstExprBinary":
        ok1, a = _is_const(e.get("left"), env)
        ok2, b = _is_const(e.get("right"), env)
        if not (ok1 and ok2):
            return False, None
        op = e.get("op")
        if op == "And":
            return True, (a and b)
        if op == "Or":
            return True, (a or b)
        if not (isinstance(a, int) and isinstance(b, int)):
            return False, None
        try:
            if op == "Add":
                return True, a + b
            if op == "Sub":
                return True, a - b
            if op == "Mul":
                return True, a * b
            if op == "Div":
                return True, a / b if (a % b) else a // b
            if op == "FloorDiv":
                return True, a // b
            if op == "Mod":
                return True, a % b
            if op == "Pow":
                return True, a ** b if b >= 0 else float(a) ** b
            if op in _CMPOPS:
                return True, {"CompareEq": a == b, "CompareNe": a != b, "CompareLt": a < b,
                              "CompareLe": a <= b, "CompareGt": a > b, "CompareGe": a >= b}[op]
        except ZeroDivisionError:
            return False, None
        return False, None
    return False, None


def _eligible(written, loc, block_id):
    """Is `loc`'s value at this point determined by this block's own order?

    True when every write to `loc` happens in this block (so the scan has
    already seen the last one before the point being asked about) or inside a
    dispatch loop's own bookkeeping. A write in another block -- a closure that
    runs later, a branch above -- could land between the assignment and the read,
    so the value is not known there.
    """
    where = written.get(loc)
    if not where:
        return True
    return not (where - {block_id})


def _written_locals(root, dispatch):
    """Local declaration locations the program assigns to, anywhere.

    A local that is written after its declaration is not a constant, even when
    the write sits in a closure this pass never looks at: `local n = 4` followed
    by a closure that sets `n = 9` is not a constant `4`. The exception is the
    bookkeeping of a dispatch loop itself -- its `counter += step` head is the
    loop's own arithmetic, which this pass models exactly, so those writes are
    not counted here (they are checked for interference separately, in
    `_writes_any`).
    """
    out = {}

    def note_target(t, block_id):
        t = _group(t)
        if isinstance(t, dict) and t.get("type") == "AstExprLocal":
            out.setdefault((t.get("local") or {}).get("location"), set()).add(block_id)

    def walk(n, block_id):
        if isinstance(n, dict):
            if id(n) in dispatch:
                if isinstance(dispatch[id(n)], tuple):
                    inner = (n.get("body") or {}).get("body") or []
                    for st in inner[2:]:
                        walk(st, id(n.get("body")))
                return
            if n.get("type") == "AstStatBlock":
                for v in n.get("body") or ():
                    walk(v, id(n))
                return
            if n.get("type") in ("AstStatAssign", "AstStatCompoundAssign"):
                for v in (n.get("vars") or [n.get("var")]):
                    note_target(v, block_id)
            for v in n.values():
                walk(v, block_id)
        elif isinstance(n, list):
            for v in n:
                walk(v, block_id)

    walk(root, None)
    return out


def _block_locals(stmt, env, written, block_id=None):
    """Fold a `local a, b = <const>, <const>` statement into env."""
    if stmt.get("type") != "AstStatLocal":
        return
    vals = stmt.get("values") or []
    for i, var in enumerate(stmt.get("vars") or ()):
        loc = var.get("location")
        if not _eligible(written, loc, block_id):
            continue
        if i >= len(vals):
            return
        ok, v = _is_const(vals[i], env)
        if ok and isinstance(v, int):
            env[loc] = v


def _assign_consts(stmt, env, written, block_id=None):
    """Fold `a, b = <const>, <const>` (plain assignment of declared locals)."""
    if stmt.get("type") != "AstStatAssign":
        return
    tgt = stmt.get("vars") or []
    vals = stmt.get("values") or []
    for i, t in enumerate(tgt):
        if i >= len(vals) or not isinstance(t, dict) or t.get("type") != "AstExprLocal":
            continue
        loc = (t.get("local") or {}).get("location")
        if not _eligible(written, loc, block_id):
            continue
        ok, v = _is_const(vals[i], env)
        if ok and isinstance(v, int):
            env[loc] = v


def _group(e):
    while isinstance(e, dict) and e.get("type") == "AstExprGroup":
        e = e.get("expr")
    return e


def _not(e):
    """`not x` -> x, else None."""
    e = _group(e)
    if isinstance(e, dict) and e.get("type") == "AstExprUnary" and e.get("op") == "Not":
        return _group(e.get("expr"))
    return None


def _cmp(e, op):
    """`a <op> b` -> (a, b), else (None, None)."""
    e = _group(e)
    if isinstance(e, dict) and e.get("type") == "AstExprBinary" and e.get("op") == op:
        return _group(e.get("left")), _group(e.get("right"))
    return None, None


def _local_ref(e, loc):
    e = _group(e)
    return (isinstance(e, dict) and e.get("type") == "AstExprLocal"
            and (e.get("local") or {}).get("location") == loc)


def _else_stmts(stmt):
    """The statements of an `else` branch: a block, or a nested `elseif`."""
    eb = stmt.get("elsebody")
    if not eb:
        return []
    if eb.get("type") == "AstStatIf":
        return [eb]
    return eb.get("body") or []


def _is_break_block(body):
    """A block that is exactly `break`."""
    stmts = (body or {}).get("body") or []
    return len(stmts) == 1 and stmts[0].get("type") == "AstStatBreak"


def _match_preamble(stmt, step_loc, counter_loc, limit_loc, inverted=False):
    """The usual numeric-`for` preamble: two signed break checks.

        if not (step <= 0) then
            if not (counter <= limit) then break end
        elseif not (counter >= limit) then break end
    """
    if stmt.get("type") != "AstStatIf":
        return False
    cond = _not(stmt.get("condition"))
    a, b = _cmp(cond, "CompareLe")
    if not (_local_ref(a, step_loc) and b is not None and _num(_group(b)) == 0):
        return False
    then_body = (stmt.get("thenbody") or {}).get("body") or []
    if len(then_body) != 1:
        return False
    inner = then_body[0]
    if inner.get("type") != "AstStatIf" or inner.get("elsebody") is not None:
        return False
    cond2 = _group(inner.get("condition")) if inverted else _not(inner.get("condition"))
    a2, b2 = _cmp(cond2, "CompareLe")
    if not (_local_ref(a2, counter_loc) and _local_ref(b2, limit_loc)):
        return False
    if not _is_break_block(inner.get("thenbody")):
        return False
    else_body = _else_stmts(stmt)
    if len(else_body) != 1:
        return False
    inner2 = else_body[0]
    if inner2.get("type") != "AstStatIf" or inner2.get("elsebody") is not None:
        return False
    cond3 = _group(inner2.get("condition")) if inverted else _not(inner2.get("condition"))
    a3, b3 = _cmp(cond3, "CompareGe")
    if not (_local_ref(a3, counter_loc) and _local_ref(b3, limit_loc)):
        return False
    return _is_break_block(inner2.get("thenbody"))


def _loop_range(step, limit, counter0):
    """The counter values the loop body sees, or None when the loop is unusable."""
    if step == 0:
        return []
    out = []
    c = counter0
    while len(out) <= MAX_ITER:
        c += step
        if (c > limit) if step > 0 else (c < limit):
            return out
        out.append(c)
    return None


def _reindent(text, old_indent, new_indent):
    """Move a copied block from one nesting level to another."""
    if old_indent == new_indent:
        return text
    lines = text.split("\n")
    out = []
    for i, ln in enumerate(lines):
        if i == 0:
            out.append(ln)
        elif ln.startswith(old_indent):
            out.append(new_indent + ln[len(old_indent):])
        elif ln.strip() == "":
            out.append("")
        else:
            out.append(new_indent + ln.lstrip("\t ")) if ln.strip() else out.append("")
    return "\n".join(out)


def _dispatch_shape(st):
    """(step, counter, limit) local locations when `st` is a dispatch loop.

    The shape is the numeric-`for` preamble Luraph always emits, and nothing
    else: `counter += step` followed by the two signed break checks. A `while`
    that merely looks similar is not one of these.
    """
    if st.get("type") != "AstStatWhile":
        return None
    cond = _group(st.get("condition"))
    if not (isinstance(cond, dict) and cond.get("type") == "AstExprConstantBool"
            and cond.get("value") is True):
        return None
    body = (st.get("body") or {}).get("body") or []
    if len(body) < 2:
        return None
    add = body[0]
    if add.get("type") != "AstStatCompoundAssign" or add.get("op") != "Add":
        return None
    tgt = _group(add.get("var"))
    val = _group(add.get("value"))
    if not (isinstance(tgt, dict) and tgt.get("type") == "AstExprLocal"
            and isinstance(val, dict) and val.get("type") == "AstExprLocal"):
        return None
    counter_loc = (tgt.get("local") or {}).get("location")
    step_loc = (val.get("local") or {}).get("location")
    check = body[1]
    if check.get("type") != "AstStatIf":
        return None
    then_body = (check.get("thenbody") or {}).get("body") or []
    if len(then_body) != 1 or then_body[0].get("type") != "AstStatIf":
        return None
    cond0 = then_body[0].get("condition")
    a, b = _cmp(_not(cond0), "CompareLe")
    if not _local_ref(a, counter_loc):
        a, b = _cmp(_group(cond0), "CompareLe")
    if not _local_ref(a, counter_loc) or not isinstance(b, dict) \
            or b.get("type") != "AstExprLocal":
        return None
    limit_loc = (b.get("local") or {}).get("location")
    if _match_preamble(check, step_loc, counter_loc, limit_loc):
        return ("range", step_loc, counter_loc, limit_loc)
    if _match_preamble(check, step_loc, counter_loc, limit_loc, inverted=True):
        return ("dead", step_loc, counter_loc, limit_loc)
    return None


def _prelude_ids(stmts, idx, locs):
    """Statements just above `idx` that set the loop's three registers.

    The prelude is the loop's own initialisation (`step = 67`, `limit = 143`,
    `counter = 76 - step`), whether it is written as `local` declarations or as
    plain assignments to locals declared earlier. Those statements are not
    ordinary writes: the enumeration this pass performs replaces them exactly.
    """
    want = set(locs)
    seen = set()
    out = set()
    j = idx - 1
    while j >= 0 and idx - j <= 8 and seen != want:
        st = stmts[j]
        tgts = []
        if st.get("type") == "AstStatAssign":
            for t in st.get("vars") or ():
                t = _group(t)
                if isinstance(t, dict) and t.get("type") == "AstExprLocal":
                    tgts.append((t.get("local") or {}).get("location"))
        elif st.get("type") == "AstStatLocal":
            for v in st.get("vars") or ():
                tgts.append(v.get("location"))
        if not want.intersection(tgts):
            break
        out.add(id(st))
        seen.update(want.intersection(tgts))
        j -= 1
    return out if seen == want else set()


def _dispatch_loops(root):
    """{id(while statement): (step, counter, limit) locations} over the file.

    Also returned: the ids of the prelude statements that initialise those
    three registers, so the write-set can leave the loop's own bookkeeping out.
    """
    out = {}

    def walk(n):
        if isinstance(n, dict):
            if n.get("type") == "AstStatBlock":
                stmts = n.get("body") or []
                for i, st in enumerate(stmts):
                    if st.get("type") == "AstStatWhile":
                        locs = _dispatch_shape(st)
                        if locs is not None:
                            out[id(st)] = locs
                            for pid in _prelude_ids(stmts, i, locs):
                                out[pid] = "prelude"
            for v in n.values():
                walk(v)
        elif isinstance(n, list):
            for v in n:
                walk(v)

    walk(root)
    return out


def _pure_expr(e, env):
    """True when evaluating `e` cannot call, index, or fail on a nil operand."""
    if not isinstance(e, dict):
        return False
    t = e.get("type")
    if t in ("AstExprConstantNumber", "AstExprConstantString", "AstExprConstantBool",
             "AstExprConstantNil"):
        return True
    if t == "AstExprTable":
        return all(_pure_expr(it.get("value"), env)
                   for it in (e.get("items") or []) if it.get("value") is not None)
    ok, _v = _is_const(e, env)
    return ok


def _dead_loop(st):
    """True when the loop provably runs zero times, whatever is in it.

    Two shapes reach the output. In the first, the three registers are set
    before the loop; then the first break check fires and the loop is empty of
    effect. In the second the setup sits *inside* the body, so the registers are
    reset on every pass: such a loop can only ever end on its first check, and
    when that check fires it is equally dead. Anything less certain -- a call in
    the setup, an unknown bound -- is not this function's business.
    """
    if st.get("type") != "AstStatWhile":
        return False
    cond = _group(st.get("condition"))
    if not (isinstance(cond, dict) and cond.get("type") == "AstExprConstantBool"
            and cond.get("value") is True):
        return False
    body = (st.get("body") or {}).get("body") or []
    env = {}
    head = None
    for i, sub in enumerate(body[:8]):
        if sub.get("type") == "AstStatCompoundAssign" and sub.get("op") == "Add":
            head = i
            break
        if sub.get("type") == "AstStatLocal":
            if not all(_pure_expr(v, env) for v in (sub.get("values") or [])):
                return False
            _block_locals(sub, env, {}, None)
            continue
        if sub.get("type") == "AstStatAssign":
            if not all(_pure_expr(v, env) for v in (sub.get("values") or [])):
                return False
            _assign_consts(sub, env, {}, None)
            continue
        return False
    if head is None or head + 1 >= len(body):
        return False
    add = body[head]
    tgt = _group(add.get("var"))
    val = _group(add.get("value"))
    if not (isinstance(tgt, dict) and tgt.get("type") == "AstExprLocal"
            and isinstance(val, dict) and val.get("type") == "AstExprLocal"):
        return False
    counter_loc = (tgt.get("local") or {}).get("location")
    step_loc = (val.get("local") or {}).get("location")
    if counter_loc not in env or step_loc not in env:
        return False
    step, counter0 = env[step_loc], env[counter_loc]
    if not isinstance(step, int) or not isinstance(counter0, int) or step == 0:
        return False
    check = body[head + 1]
    if check.get("type") != "AstStatIf":
        return False
    then_body = (check.get("thenbody") or {}).get("body") or []
    if len(then_body) != 1 or then_body[0].get("type") != "AstStatIf":
        return False
    a, b = _cmp(_not(then_body[0].get("condition")), "CompareLe")
    inverted = False
    if not _local_ref(a, counter_loc):
        a, b = _cmp(_group(then_body[0].get("condition")), "CompareLe")
        inverted = True
    if not _local_ref(a, counter_loc) or not isinstance(b, dict) \
            or b.get("type") != "AstExprLocal":
        return False
    limit_loc = (b.get("local") or {}).get("location")
    if limit_loc not in env or not isinstance(env[limit_loc], int):
        return False
    limit = env[limit_loc]
    if not _match_preamble(check, step_loc, counter_loc, limit_loc, inverted=inverted):
        return False
    first = counter0 + step
    if inverted:
        return (first <= limit) if step > 0 else (first >= limit)
    return (first > limit) if step > 0 else (first < limit)


class _Bail(Exception):
    """Abandon one loop: the shape is not one this pass can spell out."""

    def __init__(self, reason):
        self.reason = reason


class Unroller:
    def __init__(self, text, root):
        self.text = text
        self.btext = text.encode("latin-1", "replace")
        self.starts = AP._line_starts(self.btext)
        self.root = root
        self.dispatch = _dispatch_loops(root)
        self.written = _written_locals(root, self.dispatch)
        self.stats = {"found": 0, "unrolled": 0, "iterations": 0, "removed": 0, "dead": 0}
        self.skipped = {}

    def _slice(self, node):
        s, e = _span(node["location"], self.starts)
        return self.btext[s:e].decode("latin-1")

    def _indent_of(self, node):
        s, _e = _span(node["location"], self.starts)
        ls = self.btext.rfind(b"\n", 0, s) + 1
        return self.btext[ls:s].decode("latin-1")

    def _subs_edits(self, node, subs):
        """Every *read* of one of `subs`' locals, as a replacement edit."""
        edits = []
        targets = set()

        def note(n):
            if isinstance(n, dict):
                if n.get("type") in ("AstStatAssign", "AstStatCompoundAssign"):
                    for g in (n.get("vars") or [n.get("var")]):
                        g = _group(g)
                        if isinstance(g, dict) and g.get("type") == "AstExprLocal":
                            targets.add((g.get("local") or {}).get("location"))
                for v in n.values():
                    note(v)
            elif isinstance(n, list):
                for v in n:
                    note(v)

        note(node)

        def walk(n):
            if isinstance(n, dict):
                if n.get("type") == "AstExprLocal":
                    loc = (n.get("local") or {}).get("location")
                    if loc in subs and loc not in targets:
                        s, e = _span(n["location"], self.starts)
                        edits.append((s, e, str(subs[loc]).encode("latin-1")))
                    return
                for v in n.values():
                    walk(v)
            elif isinstance(n, list):
                for v in n:
                    walk(v)

        walk(node)
        return edits

    def _render(self, node, subs):
        """The node's own text with `subs` applied; comments inside it survive."""
        s, e = _span(node["location"], self.starts)
        edits = self._subs_edits(node, subs)
        if not edits:
            return self.btext[s:e].decode("latin-1")
        return AP._apply_edits(self.btext[s:e], [(a - s, b - s, r) for a, b, r in edits]).decode("latin-1")

    def _has_jump(self, node):
        """Does this subtree contain a break/continue, and is one nested?"""
        hits = []

        def walk(n, depth):
            if isinstance(n, dict):
                if n.get("type") in ("AstStatBreak", "AstStatContinue"):
                    hits.append(depth)
                for v in n.values():
                    walk(v, depth)
            elif isinstance(n, list):
                for v in n:
                    walk(v, depth)

        walk(node, 0)
        return hits

    def _emit_block(self, body, subs, out):
        """Append the statements of `body` to `out`, folding what is constant.

        Returns "fall" (reached the end), "break" or "continue" when a jump
        ended the block. Raises _Bail when a jump is still conditional.
        """
        env = dict(subs)
        for st in body.get("body") or ():
            t = st.get("type")
            if t == "AstStatBreak":
                return "break"
            if t == "AstStatContinue":
                return "continue"
            if t in ("AstStatReturn", "AstStatError"):
                out.append(self._render(st, env))
                return "return"
            if t == "AstStatIf":
                ok, v = _is_const(st.get("condition"), env)
                if ok:
                    branch = (st.get("thenbody") or {}) if v else {"body": _else_stmts(st)}
                    res = self._emit_block(branch, env, out)
                    if res != "fall":
                        return res
                    continue
                if self._has_jump(st):
                    raise _Bail("conditional-jump")
                out.append(self._render(st, env))
                continue
            if t == "AstStatLocal":
                vals = st.get("values") or []
                vars_ = st.get("vars") or []
                folded = False
                if len(vars_) == 1 and len(vals) == 1 \
                        and _eligible(self.written, vars_[0].get("location"), None):
                    ok, v = _is_const(vals[0], env)
                    if ok:
                        env[vars_[0].get("location")] = v
                        folded = True
                if folded:
                    continue
                out.append(self._render(st, env))
                continue
            if t in ("AstStatWhile", "AstStatRepeat", "AstStatFor", "AstStatForIn"):
                out.append(self._render(st, env))
                continue
            if self._has_jump(st):
                raise _Bail("nested-jump")
            out.append(self._render(st, env))
            _assign_consts(st, env, self.written)
            _block_locals(st, env, self.written)
        return "fall"

    def _try_loop(self, st, env, block_id=None, stmts=None, idx=0, block=None):
        """Unroll one loop the shape pass already accepted. Returns text or None."""
        cand = self.dispatch.get(id(st))
        if not isinstance(cand, tuple):
            if _dead_loop(st):
                self.stats["dead"] += 1
                self.stats["removed"] += 1
                return ""
            return None
        kind, step_loc, counter_loc, limit_loc = cand
        if counter_loc not in env or step_loc not in env or limit_loc not in env:
            raise _Bail("unknown-bounds")
        step = env[step_loc]
        counter0 = env[counter_loc]
        if not isinstance(step, int) or not isinstance(counter0, int):
            return None
        if limit_loc not in env:
            return None
        limit = env[limit_loc]
        if not isinstance(limit, int):
            return None
        body = (st.get("body") or {}).get("body") or []
        self.stats["found"] += 1
        if kind == "dead":
            first = counter0 + step
            stops = (first <= limit) if step > 0 else (first >= limit)
            if not stops:
                raise _Bail("dead-loop-runs")
            self.stats["dead"] += 1
            self.stats["removed"] += 1
            return ""
        for other in body[2:]:
            if self._writes_any(other, (step_loc, counter_loc, limit_loc)):
                raise _Bail("loop-register-write")

        values = _loop_range(step, limit, counter0)
        if values is None:
            raise _Bail("too-long")
        for v_loc in (step_loc, counter_loc, limit_loc):
            if not _eligible(self.written, v_loc, block_id):
                raise _Bail("loop-register-write")

        body_indent = self._indent_of(body[2]) if len(body) > 2 else self._indent_of(body[0])
        target_indent = self._indent_of(st)
        out = []
        last_c = counter0
        exited = returned = False
        for v in values:
            subs = {counter_loc: v}
            res = self._emit_block({"body": body[2:]}, subs, out)
            last_c = v
            if res == "break":
                exited = True
                break
            if res == "return":
                returned = True
                break
        if not exited:
            last_c = (values[-1] + step) if values else (counter0 + step)
        text = "\n".join(x for x in out if x.strip() != "")
        text = _reindent(text, body_indent, target_indent)
        read_later = self._reads_after_in_block(counter_loc, stmts, idx, st) \
            or self._reads_in_closures(counter_loc, block)
        if not returned and read_later:
            tgt = _group(body[0].get("var")) or {}
            name = (tgt.get("local") or {}).get("name") or "counter"
            follow = "%s%s = %d" % (target_indent, name, last_c)
            text = (text + "\n" + follow) if text.strip() else follow
        self.stats["iterations"] += len(values)
        if not text.strip():
            self.stats["removed"] += 1
        return text

    def _reads_in_closures(self, loc, block):
        """Is `loc` read from inside a function built in this scope?

        A closure can be called long after the loop, so its read still sees the
        counter. Only closures created where `loc` is visible can capture it,
        which is why this walks the loop's own block rather than the file.
        """
        found = []

        def walk(n, in_fn):
            if isinstance(n, dict):
                t = n.get("type")
                if t == "AstExprFunction":
                    in_fn = True
                if t == "AstExprLocal" and (n.get("local") or {}).get("location") == loc:
                    if in_fn:
                        found.append(1)
                    return
                for v in n.values():
                    walk(v, in_fn)
            elif isinstance(n, list):
                for v in n:
                    walk(v, in_fn)

        walk(block, False)
        return bool(found)

    def _reads_after_in_block(self, loc, stmts, idx, skip_stmt):
        """Does the code after the loop read `loc` before overwriting it?

        Walking the rest of the enclosing block is what keeps this honest in
        both directions: a read that comes after an assignment to `loc` is a
        read of *that* assignment, not of the loop's last value, so it does not
        ask for a restore line.
        """
        for sub in stmts[idx + 1:]:
            if sub is skip_stmt:
                continue
            if self._writes_any(sub, (loc,)):
                return False
            if self._reads_local(sub, loc):
                return True
        return False

    def _reads_local(self, node, loc):
        found = []

        def walk(n):
            if isinstance(n, dict):
                t = n.get("type")
                if t in ("AstStatAssign", "AstStatCompoundAssign"):
                    return
                if t == "AstExprLocal" and (n.get("local") or {}).get("location") == loc:
                    found.append(1)
                    return
                for v in n.values():
                    walk(v)
            elif isinstance(n, list):
                for v in n:
                    walk(v)

        walk(node)
        return bool(found)

    def _reads_outside(self, loc, skip_stmt):
        """Can anything still read `loc` after the loop has finished?

        Only a read that comes later in the text, or one inside a nested
        function (which can be called at any time, so its position says
        nothing), can observe the loop's last counter value. Reads before the
        loop cannot, and neither can a read that a later assignment overwrites
        -- but that is not checked here: this is deliberately the conservative
        side, and it only costs one assignment.
        """
        _s, loop_end = _span(skip_stmt["location"], self.starts)
        found = []

        def walk(n, in_fn):
            if isinstance(n, dict):
                if n is skip_stmt:
                    return
                t = n.get("type")
                if t == "AstExprFunction":
                    in_fn = True
                if t == "AstExprLocal" and (n.get("local") or {}).get("location") == loc:
                    start = _span(n["location"], self.starts)[0]
                    if in_fn or start > loop_end:
                        found.append(1)
                    return
                for v in n.values():
                    walk(v, in_fn)
            elif isinstance(n, list):
                for v in n:
                    walk(v, in_fn)

        walk(self.root, False)
        return bool(found)

    def _writes_any(self, node, locs):
        hit = []

        def walk(n):
            if isinstance(n, dict):
                t = n.get("type")
                if t in ("AstStatAssign", "AstStatCompoundAssign"):
                    tgts = n.get("vars") or [n.get("var")]
                    for g in tgts:
                        g = _group(g)
                        if isinstance(g, dict) and g.get("type") == "AstExprLocal" \
                                and (g.get("local") or {}).get("location") in locs:
                            hit.append(1)
                for v in n.values():
                    walk(v)
            elif isinstance(n, list):
                for v in n:
                    walk(v)

        walk(node)
        return bool(hit)

    def run(self):
        """One round: unroll every dispatch loop the AST still holds."""
        edits = []
        self._walk_blocks(self.root, edits)
        if not edits:
            return self.text
        new = AP._apply_edits(self.btext, edits).decode("latin-1")
        self.stats["unrolled"] += len(edits)
        return new

    def _walk_blocks(self, node, edits):
        if isinstance(node, dict):
            if node.get("type") == "AstStatBlock":
                self._scan_block(node, edits)
                for st in node.get("body") or ():
                    self._walk_blocks(st, edits)
                return
            for v in node.values():
                self._walk_blocks(v, edits)
        elif isinstance(node, list):
            for v in node:
                self._walk_blocks(v, edits)

    def _scan_block(self, block, edits):
        stmts = block.get("body") or []
        block_id = id(block)
        env = {}
        for i, st in enumerate(stmts):
            try:
                rep = self._try_loop(st, env, block_id, stmts, i, block)
            except _Bail as b:
                self.skipped[b.reason] = self.skipped.get(b.reason, 0) + 1
                rep = None
            if rep is not None:
                s, e = _span(st["location"], self.starts)
                if not rep.strip():
                    ls = self.btext.rfind(b"\n", 0, s) + 1
                    le = self.btext.find(b"\n", e)
                    s, e = ls, (le + 1 if le != -1 else e)
                edits.append((s, e, rep.encode("latin-1")))
            _block_locals(st, env, self.written, block_id)
            _assign_consts(st, env, self.written, block_id)


def apply_text(text, rounds=1):
    """Unroll constant-state dispatch loops.

    `rounds` > 1 only helps when something removes the dead prelude between
    rounds; the pipeline alternates this pass with the AST cleanup, which is
    what lets a second round see bounds that a first round could not.
    """
    total = {"rounds": 0, "unrolled": 0, "iterations": 0, "removed": 0, "dead": 0}
    skipped = {}
    for _ in range(max(1, rounds)):
        root = _lines(text)
        u = Unroller(text, root)
        new = u.run()
        total["rounds"] += 1
        total["unrolled"] += u.stats["unrolled"]
        total["iterations"] += u.stats["iterations"]
        total["removed"] += u.stats["removed"]
        total["dead"] = total.get("dead", 0) + u.stats["dead"]
        for k, v in u.skipped.items():
            skipped[k] = skipped.get(k, 0) + v
        if new == text:
            break
        text = new
    STATS.clear()
    STATS.update({"unrolled": total["unrolled"], "iterations": total["iterations"],
                  "dropped": total["removed"], "dead_loops": total["dead"],
                  "skipped": dict(skipped)})
    stats = {"dispatch_loops_unrolled": total["unrolled"],
             "dispatch_iterations": total["iterations"],
             "dispatch_loops_dropped": total["removed"],
             "dispatch_dead_loops": total["dead"],
             "dispatch_skipped": skipped}
    return text, stats


def main(argv):
    import json
    if "--stdin" in argv:
        src = sys.stdin.buffer.read().decode("latin-1")
        out, stats = apply_text(src, rounds=1)
        sys.stdout.write(json.dumps({"text": out, "stats": stats}))
        return 0
    if len(argv) < 2:
        print("usage: flatten.py <file.lua> [--write] [--json]", file=sys.stderr)
        return 2
    path = argv[1]
    src = open(path, encoding="latin-1").read()
    out, stats = apply_text(src)
    if "--json" in argv:
        print(json.dumps(stats, indent=2))
    else:
        print("%-28s %s" % ("lines", src.count("\n")))
        print("%-28s %s" % ("lines after", out.count("\n")))
    if "--write" in argv and out != src:
        with open(path, "w", encoding="latin-1", newline="\n") as fh:
            fh.write(out)
    else:
        sys.stdout.buffer.write(out.encode("latin-1"))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
