"""Fold an unrolled bit32 chain back into one loop.

A checksum the obfuscator unrolled reaches the output as N repetitions of the
same few statements, each repetition handing its result to the next through a
single variable. Read as a whole it is one operation applied N times; read line
by line it is fifty-eight lines of

    local value57 = bit32.band(bit32.bxor(value55, value56), 536870911)

Nothing here guesses. A run is only turned into a loop when the repetitions are
identical statement for statement -- same operations, same constants, same
order, differing only in the names they bind -- and when nothing a repetition
binds is read anywhere but by the next repetition. The loop body is then the
block itself, so the arithmetic the script performs does not change at all;
`scripts/bitfold_verify.py` runs the original lines and the folded helper on
random inputs and compares the results, and `plan()` hands it both halves from
the same description.

`fold_chains` returns the text unchanged whenever anything is unclear: an
unusual expression, a value escaping the chain, a block that repeats twice.
"""

import re
import sys

# Ops whose result is a bit pattern: pure, no side effects, no tables.
BIT_OPS = frozenset("band bor bxor bnot lshift rshift lrotate rrotate extract replace "
                    "countlz countrz byteswap".split())

MAX_PERIOD = 8          # a repetition longer than this is not a repeated shape
MIN_REPEATS = 3         # two matching blocks are a coincidence
_HELPER = "mixBits"


def _walk(node, out):
    """Every AST node under `node`, depth first."""
    stack = [node]
    while stack:
        cur = stack.pop()
        if isinstance(cur, dict):
            out.append(cur)
            stack.extend(v for v in cur.values() if isinstance(v, (dict, list)))
        elif isinstance(cur, list):
            stack.extend(v for v in cur if isinstance(v, (dict, list)))
    return out


def _is_bit32_call(node):
    if node.get("type") != "AstExprCall":
        return False
    fn = node.get("func") or {}
    if fn.get("type") != "AstExprIndexName" or fn.get("op") != ".":
        return False
    base = fn.get("expr") or {}
    return base.get("type") == "AstExprGlobal" and base.get("global") == "bit32" \
        and fn.get("index") in BIT_OPS


def _pure(node):
    """Can this expression be re-evaluated in a new scope without changing
    anything? Only numbers, locals and bit32 calls -- no table access, no other
    calls (those can have side effects or read state that changed since)."""
    nodes = _walk(node, [])
    callees = {id(n.get("func")) for n in nodes
               if n.get("type") == "AstExprCall" and _is_bit32_call(n)}
    calls = 0
    for n in nodes:
        t = n.get("type")
        if t == "AstExprCall":
            if not _is_bit32_call(n):
                return False
            calls += 1
        elif t in ("AstExprConstantNumber", "AstExprLocal", "AstLocal"):
            continue                 # `AstLocal` is the name inside an AstExprLocal
        elif t == "AstExprGlobal":
            if n.get("global") != "bit32":
                return False
        elif t == "AstExprIndexName":
            if id(n) not in callees:
                return False                 # field access: not a bit pattern
        elif t == "AstExprBinary":
            if n.get("op") not in ("+", "-", "*", "%", "//", "^"):
                return False
        elif t == "AstExprUnary":
            continue
        else:
            return False
    return calls > 0


def _canon(node, defined, ext):
    """Structure of an expression with every name replaced by its role.

    `defined` maps a local's declaration location to the index of the statement
    that binds it inside this block; anything else is an outside value and
    becomes `(in)`. Two repetitions of one shape canonicalise the same way.
    """
    t = node.get("type")
    if t == "AstExprConstantNumber":
        return "n:%r" % node.get("value")
    if t == "AstExprConstantString":
        return "s:%r" % node.get("value")
    if t == "AstExprConstantBool":
        return "b:%r" % node.get("value")
    if t == "AstExprLocal":
        loc = (node.get("local") or {}).get("location")
        if loc in defined:
            return "@%d" % defined[loc]
        ext.add(loc)
        return "(in)"
    if t == "AstExprGlobal":
        return "g:%s" % node.get("global")
    if t == "AstExprIndexName":
        return "%s.%s%s" % (_canon(node.get("expr") or {}, defined, ext), node.get("op") or "",
                            node.get("index"))
    if t == "AstExprIndexExpr":
        return "%s[%s]" % (_canon(node.get("expr") or {}, defined, ext),
                           _canon(node.get("index") or {}, defined, ext))
    if t == "AstExprCall":
        return "(%s)(%s)" % (_canon(node.get("func") or {}, defined, ext),
                             ",".join(_canon(a, defined, ext) for a in node.get("args") or []))
    if t == "AstExprBinary":
        return "(%s %s %s)" % (_canon(node.get("left") or {}, defined, ext), node.get("op"),
                               _canon(node.get("right") or {}, defined, ext))
    if t == "AstExprUnary":
        return "(%s %s)" % (node.get("op"), _canon(node.get("expr") or {}, defined, ext))
    return "?%s" % t


class _Stmt(object):
    """One `local name = <pure bit32 expr>` statement, as it sits in the file."""

    __slots__ = ("node", "var_loc", "var_name", "value")

    def __init__(self, node):
        v = (node.get("vars") or [None])[0]
        self.node = node
        self.var_loc = v["location"]
        self.var_name = v["name"]
        self.value = (node.get("values") or [None])[0]


def _as_stmt(node):
    """The statement, if it is the single-line `local x = <pure bit32 expr>` this
    pass can reason about; None otherwise."""
    if not isinstance(node, dict) or node.get("type") != "AstStatLocal":
        return None
    vars_ = node.get("vars") or []
    vals = node.get("values") or []
    if len(vars_) != 1 or len(vals) != 1:
        return None
    loc = node.get("location") or ""
    try:
        a, b = loc.split(" - ")
        if a.split(",")[0] != b.split(",")[0]:
            return None                      # spans lines: not a chain step
    except ValueError:
        return None
    if not _pure(vals[0]):
        return None
    return _Stmt(node)


def _block_shape(stmts):
    """(canonical statements, {decl loc: index}, external decl locations).

    None when the block reads more than one value from outside itself: a
    repetition that consumes two outside values is not a foldable step.
    """
    defined = {st.var_loc: i for i, st in enumerate(stmts)}
    ext = set()
    canon = [_canon(st.value, defined, ext) for st in stmts]
    if len(ext) > 1:
        return None
    return canon, defined, ext


def _input_name(first, text):
    """The one value the block reads from before it starts."""
    shape = _block_shape(first)
    if shape is None or len(shape[2]) != 1:
        return None
    loc = next(iter(shape[2]))
    for st in first:
        for node in _walk(st.value, []):
            if node.get("type") == "AstExprLocal" and \
                    (node.get("local") or {}).get("location") == loc:
                return node["local"]["name"]
    return None


def _indent_of(line):
    return line[:len(line) - len(line.lstrip(" \t"))]


def _starts(btext):
    starts = [0]
    pos = 0
    while True:
        nl = btext.find(b"\n", pos)
        if nl < 0:
            return starts
        starts.append(nl + 1)
        pos = nl + 1


def plan(text):
    """What would be folded, without touching the text.

    A list of dicts: start/end line (1-based, inclusive), period, count, the
    carried parameter and result names, the block's source lines and the helper
    name. `fold_chains` is this plus the rewrite, so a verifier can build the
    original and the folded version from the same description.
    """
    from ast_polish import _line_starts, _loc_bytes, _parse_ast
    try:
        root = _parse_ast(text)
    except Exception:
        return []
    btext = text.encode("utf-8", "surrogateescape")
    starts = _line_starts(btext)
    lines = text.split("\n")
    plans = []
    taken = set(re.findall(r"\b(mixBits\d*)\b", text))

    def rng(node):
        return _loc_bytes(node["location"], starts)

    def best_fold(run, body, run_start):
        best = None
        n = len(run)
        for period in range(3, MAX_PERIOD + 1):
            if n < period * MIN_REPEATS:
                break
            for s in range(0, n - period * MIN_REPEATS + 1):
                first = run[s:s + period]
                shape = _block_shape(first)
                if shape is None:
                    continue
                canon, defined, ext = shape
                if len(ext) != 1:
                    continue
                count = 1
                while s + (count + 1) * period <= n:
                    nxt = run[s + count * period:s + (count + 1) * period]
                    nshape = _block_shape(nxt)
                    if nshape is None:
                        break
                    ncanon, ndef, next_ext = nshape
                    if ncanon != canon or len(next_ext) != 1:
                        break
                    if next_ext != {run[s + count * period - 1].var_loc}:
                        # the next repetition must consume exactly what this one
                        # produced last; otherwise the chain is not a chain
                        break
                    count += 1
                if count < MIN_REPEATS:
                    continue
                if best is None or count * period > best[0] * best[1]:
                    best = (count, period, s)
        if best is None:
            return None
        count, period, s = best
        first = run[s:s + period]
        last = run[s + (count - 1) * period:s + count * period]
        out_name, out_loc = last[-1].var_name, last[-1].var_loc
        # what follows the folded span (the rest of the chain included: a prefix
        # or a tail is allowed, as long as it only reads the result)
        tail = body[run_start + s + count * period:]
        # every name a repetition binds, except its result, must stay inside the
        # repetitions: a value that escapes would need renaming to survive
        inner_locs = {st.var_loc for st in first[:-1]}
        for st_after in tail:
            for node in _walk(st_after, []):
                if node.get("type") == "AstExprLocal":
                    loc = (node.get("local") or {}).get("location")
                    if loc in inner_locs:
                        return None
        # ...and the result has to be read afterwards, or there is nothing to fold
        used = any(node.get("type") == "AstExprLocal" and
                   (node.get("local") or {}).get("location") == out_loc
                   for st_after in tail for node in _walk(st_after, []))
        if not used:
            return None
        a0, _ = rng(first[0].node)
        _, b0 = rng(run[s + count * period - 1].node)
        line0 = btext.count(b"\n", 0, a0) + 1
        line1 = btext.count(b"\n", 0, b0) + 1
        body_lines = [lines[k - 1] for k in range(line0, line1 + 1)]
        if len(body_lines) != count * period:
            return None
        param = _input_name(first, text)
        if not param:
            return None
        helper = _HELPER
        k = 2
        while helper in taken:
            helper = "%s%d" % (_HELPER, k)
            k += 1
        taken.add(helper)
        return {
            "start": line0,
            "end": line1,
            "period": period,
            "count": count,
            "param_name": param,
            "block_out": first[-1].var_name,
            "final": run[s + count * period - 1].var_name,
            "out": out_name,
            "helper": helper,
            "indent": _indent_of(body_lines[0]),
            "block_lines": body_lines[:period],
        }

    def visit(block):
        body = block.get("body") or []
        i = 0
        while i < len(body):
            st = _as_stmt(body[i])
            if st is None:
                i += 1
                continue
            run = [st]
            j = i + 1
            while j < len(body):
                nxt = _as_stmt(body[j])
                if nxt is None:
                    break
                run.append(nxt)
                j += 1
            if len(run) >= MIN_REPEATS * 3:
                got = best_fold(run, body, i)
                if got is not None:
                    plans.append(got)
            i = j
        return

    try:
        for node in _walk(root, []):
            if node.get("type") == "AstStatBlock":
                visit(node)
    except Exception as ex:                  # never lose a working output
        print("[!] bit32 chain scan failed: %s" % ex, file=sys.stderr)
        return []
    return plans


def fold_chains(text):
    """Replace every foldable unrolled chain with a loop in a named helper."""
    plans = plan(text)
    if not plans:
        return text
    from ast_polish import _apply_edits
    btext = text.encode("utf-8", "surrogateescape")
    starts = _starts(btext)
    edits = []
    for p in plans:
        ind = p["indent"]
        block = list(p["block_lines"])
        last = block[-1]
        # the block's own result becomes the loop's carried value
        m = re.match(r"^(\s*)local\s+\w+\s*=", last)
        if not m:
            continue
        block[-1] = "%s%s =%s" % (m.group(1), p["param_name"], last[m.end():])
        out = ["%s-- folded: %d repetitions of a %d-statement bit32 chain"
               % (ind, p["count"], p["period"]),
               "%slocal function %s(%s)" % (ind, p["helper"], p["param_name"]),
               "%s\tfor _ = 1, %d do" % (ind, p["count"])]
        for bl in block:
            out.append("%s\t\t%s" % (ind, bl.strip()))
        out.append("%s\tend" % ind)
        out.append("%s\treturn %s" % (ind, p["param_name"]))
        out.append("%send" % ind)
        out.append("%slocal %s = %s(%s)" % (ind, p["out"], p["helper"], p["param_name"]))
        s0 = starts[p["start"] - 1]
        e0 = starts[p["end"]] if p["end"] < len(starts) else len(btext)
        edits.append((s0, e0, ("\n".join(out) + "\n").encode("utf-8", "surrogateescape")))
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8", "surrogateescape")
