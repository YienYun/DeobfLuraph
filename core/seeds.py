"""Strip the per-function state seed a Luraph v15 build carries.

Every protected function opens with a number:

    local number3 = 135623784

and then updates it at each branch with bit32/u32 arithmetic:

    number3 = bit32.bxor(number3, 279606389)
    number3 = u32Trunc((u32Mul(69228956, number3) + 663714168) + ...)

The value never reaches the script. It is the obfuscator's own trail -- an
integrity hash the VM used to check that its code had not been edited, rewritten
by the lifter into ordinary statements that only ever feed themselves. In
RideAPet those updates were 228 of the 252 bit32-family calls left after the
constant folding pass, and none of them touched a Roblox API, a remote, or any
other value the script can observe.

The rule is deliberately narrow, because deleting code is the one thing a
deobfuscator must never get wrong. A local is a seed when

  * its first write is a plain number, and every later write is built from
    number literals, other seeds, and the u32/bit32 helpers -- nothing else, and
  * every read of it sits inside the value part of one of those writes, i.e.
    inside text this pass is about to delete.

Seeds that feed each other are found together: `local n = state` followed by
`state = bxor(n, k)` makes both of them seeds, because the only reads of `n`
live in the `state` update that goes away with it.

`local k = 7 ... return k` is not a seed (the value is used), `local k = f()`
is not a seed (the write is not arithmetic), and a statement that mixes a seed
with real work (`ok, seed = pcall(f), u32Trunc(...)`) only loses its own
assignment -- and only when both sides have the same number of values, so no
multi-value call shifts position.
"""
import sys

HELPERS = {
    "bit32.band", "bit32.bor", "bit32.bxor", "bit32.bnot",
    "bit32.lshift", "bit32.rshift", "bit32.lrotate", "bit32.rrotate",
    "u32Trunc", "u32Mul",
}
ARITH = {"Add", "Sub", "Mul", "Div", "IDiv", "Mod", "Pow"}


def _pos(location):
    """Sortable position for a `line,col - line,col` location string."""
    a, b = location.split(" - ")

    def p(x):
        line, col = x.split(",")
        return int(line) * 10000 + int(col)

    return p(a), p(b)


def _dotted(node):
    t = (node or {}).get("type")
    if t == "AstExprGlobal":
        return node.get("global") or node.get("name")
    if t == "AstExprLocal":
        return (node.get("local") or {}).get("name")
    if t == "AstExprIndexName":
        base = _dotted(node.get("expr"))
        return base + "." + node["index"] if base else None
    return None


def _helper_calls(node, out):
    if isinstance(node, dict):
        if node.get("type") == "AstExprCall" and _dotted(node.get("func")) in HELPERS:
            out.append(_dotted(node.get("func")))
        for k, v in node.items():
            if k != "location":
                _helper_calls(v, out)
    elif isinstance(node, list):
        for x in node:
            _helper_calls(x, out)


def _is_number(node):
    """A plain number literal (`-5` included)."""
    if not isinstance(node, dict):
        return False
    t = node.get("type")
    if t == "AstExprConstantNumber":
        return True
    if t == "AstExprGroup":
        return _is_number(node.get("expr") or {})
    if t == "AstExprUnary":
        return node.get("op") == "Minus" and _is_number(node["expr"])
    return False


def _seed_expr(node, key, known):
    """Is `node` built only from literals, seeds, and the u32 helpers?"""
    t = (node or {}).get("type") or ""
    if t == "AstExprConstantNumber":
        return True
    if t == "AstExprGlobal":
        return (node.get("global") or "") == "bit32"
    if t == "AstExprLocal":
        loc = node["local"]["location"]
        return loc == key or loc in known
    if t in ("AstExprGroup", "AstExprTypeAssertion"):
        return _seed_expr(node.get("expr") or {}, key, known)
    if t == "AstExprUnary":
        return node.get("op") == "Minus" and _seed_expr(node["expr"], key, known)
    if t == "AstExprBinary":
        return node.get("op") in ARITH and _seed_expr(node["left"], key, known) \
            and _seed_expr(node["right"], key, known)
    if t == "AstExprIndexName":                  # `bit32.bxor`
        return _seed_expr(node.get("expr") or {}, key, known)
    if t == "AstExprCall":
        return _dotted(node.get("func")) in HELPERS \
            and all(_seed_expr(a, key, known) for a in node.get("args") or [])
    return False


class Write:
    """One assignment to a tracked local."""

    __slots__ = ("stmt", "index", "nvars", "nvals", "value", "value_span", "impure")

    def __init__(self, stmt, index, nvars, nvals, value, value_span, impure=False):
        self.stmt = stmt
        self.index = index
        self.nvars = nvars
        self.nvals = nvals
        self.value = value
        self.value_span = value_span
        self.impure = impure


def _collect(root):
    """Writes and reads, by local, plus the local's name."""
    writes = {}
    reads = {}
    names = {}
    order = []

    def note(key, entry, name):
        if key not in writes:
            writes[key] = []
            order.append(key)
            names[key] = name
        writes[key].append(entry)

    def walk(node, parent=None, field=None):
        if isinstance(node, dict):
            t = node.get("type") or ""
            if "location" not in node:
                for k, v in node.items():
                    walk(v, node, k)
                return
            if t in ("AstStatLocal", "AstStatAssign"):
                vars_ = node.get("vars") or []
                vals = node.get("values") or []
                for i, var in enumerate(vars_):
                    local = var.get("local") if var.get("type") == "AstExprLocal" else var
                    if not isinstance(local, dict) or "location" not in local:
                        continue                     # a field or a global target
                    if var.get("type") not in ("AstExprLocal", "AstLocal"):
                        continue
                    value = vals[i] if i < len(vals) else None
                    span = _pos(value["location"]) if value is not None else None
                    note(local["location"],
                         Write(node, i, len(vars_), len(vals), value, span),
                         local.get("name"))
            elif t == "AstStatCompoundAssign":
                var = node.get("var") or {}
                if var.get("type") == "AstExprLocal":
                    note(var["local"]["location"],
                         Write(node, 0, 1, 1, None, None, impure=True),
                         var["local"].get("name"))
            elif t == "AstExprLocal":
                is_target = parent is not None and (
                    (parent.get("type") in ("AstStatLocal", "AstStatAssign") and field == "vars")
                    or (parent.get("type") == "AstStatCompoundAssign" and field == "var"))
                if not is_target:
                    reads.setdefault(node["local"]["location"], []).append(_pos(node["location"])[0])
            for k, v in node.items():
                walk(v, node, k)
        elif isinstance(node, list):
            for x in node:
                walk(x, parent, field)

    walk(root)
    return writes, reads, names, order


def find_seeds(text):
    """-> (root, seeds, drops).

    `seeds` is the set of local locations whose arithmetic is the obfuscator's
    trail; `drops` maps a statement location to the set of value indexes to
    remove from it (all of them for a statement that only writes seeds).
    """
    import ast_polish

    root = ast_polish._parse_ast(text)
    writes, reads, _names, order = _collect(root)

    def drops_for(known):
        drops = {}
        for key in known:
            for w in writes[key]:
                drops.setdefault(w.stmt["location"], set()).add(w.index)
        return drops

    def read_is_dropped(key, known, drops):
        """Every read of `key` must sit in the value part of a write being removed."""
        spans = [w.value_span for k in known for w in writes[k] if w.value_span]
        for r in reads.get(key, ()):
            if not any(a <= r <= b for a, b in spans):
                return False
        return True

    def shape_ok(key, known):
        """Every write is arithmetic over literals and other seeds, nothing else."""
        ws = writes[key]
        if any(w.impure for w in ws):
            return False                 # `x += ...` reads and writes at once
        # A `local x` declaration (no value) is pure nil: it never makes a local
        # a seed on its own, but it does not disqualify one either.
        values = [w.value for w in ws if w.value is not None]
        if not values:
            return False
        return all(_is_number(v) or _seed_expr(v, key, known) for v in values)

    # Seeds feed each other (`state = bxor(alias, k)` while `alias = state`), so
    # the set is the greatest fixpoint: start from everything seed-shaped and
    # drop the ones that lean on something that did not survive.
    tracked = set(order)
    seeds = {key for key in order if shape_ok(key, tracked)}
    changed = True
    while changed:
        changed = False
        drops = drops_for(seeds)
        for key in sorted(seeds):
            if not shape_ok(key, seeds) or not read_is_dropped(key, seeds, drops):
                seeds.discard(key)
                changed = True
    return root, seeds, drops_for(seeds)


def strip(text):
    """-> (text, stats). Deletes the seed arithmetic, one statement at a time."""
    import ast_polish

    stats = {"seeds": 0, "statements": 0, "calls": 0}
    try:
        root, seeds, drops = find_seeds(text)
    except Exception as ex:
        print("[!] seed pass skipped: %s" % str(ex)[:160], file=sys.stderr)
        return text, stats
    if not seeds:
        return text, stats

    btext = text.encode("utf-8")
    starts = ast_polish._line_starts(btext)
    writes, _reads, names, order = _collect(root)
    by_stmt = {w.stmt["location"]: w for key in order if key in seeds for w in writes[key]}

    edits = []
    for stmt_loc, indexes in drops.items():
        entry = by_stmt[stmt_loc]
        st = entry.stmt
        vals = st.get("values") or []
        if len(indexes) == entry.nvars and st["type"] != "AstStatLocal":
            s, e = ast_polish._loc_bytes(st["location"], starts)
            s, e = ast_polish._expand_full_line_delete(btext, s, e)
            edits.append((s, e, b""))
        elif st["type"] == "AstStatLocal":
            s, e = ast_polish._loc_bytes(st["location"], starts)
            edits.append((s, e, _decl(st, indexes, btext, starts)))
        else:
            if len(vals) != entry.nvars:
                continue                 # `a, seed = f()`: positions would shift
            rebuilt = _rebuild(st, indexes, btext, starts)
            s, e = ast_polish._loc_bytes(st["location"], starts)
            edits.append((s, e, rebuilt))
        stats["statements"] += 1
        for i in indexes:
            if i < len(vals):
                calls = []
                _helper_calls(vals[i], calls)
                stats["calls"] += len(calls)

    edits = [(s0, e0, repl) for s0, e0, repl in edits if repl != btext[s0:e0]]
    if not edits:
        return text, stats
    out = ast_polish._apply_edits(btext, edits).decode("utf-8")
    stats["seeds"] = len(seeds)

    leaked = _leaked_names(out, {names[k] for k in seeds})
    if leaked:
        # A seed is still read somewhere we did not remove: undo rather than
        # hand back code that no longer compiles.
        print("[!] seed pass undone: %s would be left undefined"
              % ", ".join(sorted(leaked)), file=sys.stderr)
        return text, {"seeds": 0, "statements": 0, "calls": 0}
    return out, stats


def _leaked_names(text, seed_names):
    """Seed names that survive as free identifiers (they would become globals)."""
    import ast_polish

    try:
        root = ast_polish._parse_ast(text)
    except Exception as ex:
        print("[!] seed output does not parse: %s" % str(ex)[:160], file=sys.stderr)
        return {"<parse>"}
    declared = set()
    used = set()

    def walk(node):
        if isinstance(node, dict):
            t = node.get("type") or ""
            if t == "AstStatLocal":
                for v in node.get("vars") or []:
                    declared.add(v.get("name"))
            elif t == "AstStatLocalFunction":
                declared.add((node.get("name") or {}).get("name"))
            elif t == "AstExprGlobal":
                used.add(node.get("global") or node.get("name"))
            for k, v in node.items():
                walk(v)
        elif isinstance(node, list):
            for x in node:
                walk(x)

    walk(root)
    return (used & seed_names) - declared


def _decl(st, drop, btext, starts):
    """A declaration with some values removed: names always stay declared."""
    import ast_polish

    def text_of(node):
        s0, e0 = ast_polish._loc_bytes(node["location"], starts)
        return btext[s0:e0]

    vals = st.get("values") or []
    names = b", ".join(text_of(v) for v in st["vars"])
    keep = [i for i in range(len(vals)) if i not in drop]
    last = max(keep, default=-1)
    parts = [text_of(vals[i]) if i in keep else b"nil" for i in range(last + 1)]
    if not parts:
        return b"local " + names
    return b"local " + names + b" = " + b", ".join(parts)


def _rebuild(st, drop, btext, starts):
    """`a, seed = f(), <pure>` with the seed's pair removed, from source text."""
    import ast_polish

    vars_ = st["vars"]
    vals = st.get("values") or []
    keep = [i for i in range(len(vars_)) if i not in drop]

    def text_of(node):
        s, e = ast_polish._loc_bytes(node["location"], starts)
        return btext[s:e]

    lhs = b", ".join(text_of(vars_[i]) for i in keep)
    rhs = b", ".join(text_of(vals[i]) for i in keep)
    head = b"local " if st["type"] == "AstStatLocal" else b""
    return head + lhs + b" = " + rhs


def main(argv):
    import argparse

    ap = argparse.ArgumentParser(description="strip the per-function state seed")
    ap.add_argument("file", help="file to clean, or - for stdin")
    ap.add_argument("-o", "--output")
    args = ap.parse_args(argv)
    if args.file == "-":
        text = sys.stdin.read()
    else:
        with open(args.file, encoding="utf-8") as fh:
            text = fh.read()
    out, stats = strip(text)
    if args.output:
        with open(args.output, "w", encoding="utf-8", newline="\n") as fh:
            fh.write(out)
    else:
        sys.stdout.write(out)
    print("[seeds] %d seed(s), %d statement(s) removed, %d u32 call(s)"
          % (stats["seeds"], stats["statements"], stats["calls"]), file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
