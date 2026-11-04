"""Delete stores whose value nothing can read, statement by statement.

The lifter keeps every register the VM used, so a function often reads like

    local number4 = 316391088
    local number = number4
    number4 = u32Trunc(number + 200216811)
    number4 = u32Trunc(number4 + 88226854)
    ...
    number4 = 0                      -- later, the real use

`number4` is overwritten before anything can look at it, so those stores are
unobservable -- and they are what keeps the seed arithmetic (and its bit32
calls) alive in the text.

Each block is walked backwards, keeping the set of locals that are still read
somewhere ahead of the current statement. A store whose target is not in that
set, and whose value cannot fail and has no side effect, is removed; that in
turn kills the reads it made, so the store behind it can go too.

Safety, in order of how easily it could be got wrong:

  * a value is only removable if it is a literal, a local, arithmetic on those,
    or a u32/bit32 helper -- never a call, never an index that could raise;
  * a local captured by a closure is never touched: the closure may run at any
    time, so the value can always be observed;
  * a block inside a loop is skipped, since an earlier iteration can read what
    this one overwrites.
"""
import sys

HELPERS = {
    "bit32.band", "bit32.bor", "bit32.bxor", "bit32.bnot",
    "bit32.lshift", "bit32.rshift", "bit32.lrotate", "bit32.rrotate",
    "u32Trunc", "u32Mul",
}
ARITH = {"Add", "Sub", "Mul", "Div", "IDiv", "Mod", "Pow", "Concat",
         "CompareNe", "CompareEq", "LessThan", "LessThanEq", "GreaterThan", "GreaterThanEq"}
LOOPS = {"AstStatWhile", "AstStatRepeat", "AstStatFor", "AstStatForIn"}


def _pos(location):
    a, b = location.split(" - ")

    def p(x):
        line, col = x.split(",")
        return int(line) * 10000 + int(col)

    return p(a), p(b)


def _dotted(node):
    t = (node or {}).get("type")
    if t == "AstExprGlobal":
        return node.get("global") or node.get("name")
    if t == "AstExprLocal":                  # `local function u32Trunc`
        return (node.get("local") or {}).get("name")
    if t == "AstExprIndexName":
        base = _dotted(node.get("expr"))
        return base + "." + node["index"] if base else None
    return None


def _is_nil(node):
    return isinstance(node, dict) and node.get("type") == "AstExprConstantNil"


def _harmless(node):
    """Can this expression be dropped without changing anything observable?"""
    t = (node or {}).get("type") or ""
    if t in ("AstExprConstantNumber", "AstExprConstantString", "AstExprConstantBool",
             "AstExprConstantNil", "AstExprLocal"):
        return True
    if t in ("AstExprGroup", "AstExprTypeAssertion"):
        return _harmless(node.get("expr") or {})
    if t == "AstExprUnary":
        return node.get("op") in ("Minus", "Not", "Len") and _harmless(node["expr"])
    if t == "AstExprBinary":
        return node.get("op") in ARITH and _harmless(node["left"]) and _harmless(node["right"])
    if t == "AstExprCall":
        return _dotted(node.get("func")) in HELPERS \
            and all(_harmless(a) for a in node.get("args") or [])
    return False


def _targets(stmt):
    """[(local location, value node or None)] for a store, else None."""
    if stmt.get("type") not in ("AstStatLocal", "AstStatAssign"):
        return None
    vars_ = stmt.get("vars") or []
    vals = stmt.get("values") or []
    out = []
    for i, var in enumerate(vars_):
        local = var.get("local") if var.get("type") == "AstExprLocal" else var
        if var.get("type") not in ("AstExprLocal", "AstLocal"):
            return None                       # a field or a global: not a plain store
        if not isinstance(local, dict) or "location" not in local:
            return None
        out.append((local["location"], vals[i] if i < len(vals) else None))
    return out, len(vals) == len(vars_)


def _reads(node, into, skip_targets=False):
    """Every local read inside `node`."""
    if isinstance(node, dict):
        t = node.get("type") or ""
        if t == "AstExprLocal":
            into.add(node["local"]["location"])
        for k, v in node.items():
            if k != "location":
                _reads(v, into)
    elif isinstance(node, list):
        for x in node:
            _reads(x, into)


def _reads_head(stmt, into):
    """Locals read in a statement's header -- its conditions and bounds, but not
    the bodies: those are scanned as blocks of their own."""
    if isinstance(stmt, dict):
        if stmt.get("type") == "AstStatBlock":
            return
        if stmt.get("type") == "AstExprLocal":
            into.add(stmt["local"]["location"])
        for k, v in stmt.items():
            if k != "location":
                _reads_head(v, into)
    elif isinstance(stmt, list):
        for x in stmt:
            _reads_head(x, into)


def _scan(root):
    """Blocks with their statements, and reads per local with the owning function."""
    blocks = []
    reads = {}

    def walk(node, func, in_loop, field=None):
        if isinstance(node, dict):
            t = node.get("type") or ""
            if t == "AstExprFunction":
                func = node.get("location") or id(node)
            if t == "AstStatBlock":
                blocks.append((node, in_loop))
                in_loop = False
            elif t in LOOPS:
                in_loop = True
            if t == "AstStatLocal":
                for var in node.get("vars") or []:
                    if "location" in var:
                        reads.setdefault(var["location"], set()).add(func)
            elif t == "AstExprLocal":
                reads.setdefault(node["local"]["location"], set()).add(func)
            for k, v in node.items():
                walk(v, func, in_loop, k)
        elif isinstance(node, list):
            for x in node:
                walk(x, func, in_loop, field)

    walk(root, None, False)
    return blocks, reads


LOOP_STAT = {"AstStatWhile", "AstStatRepeat", "AstStatFor", "AstStatForIn"}


def find_dead(text):
    """-> (root, [(statement, [drop indexes])]) for every removable store."""
    import ast_polish

    root = ast_polish._parse_ast(text)
    _blocks, read_funcs = _scan(root)

    def captured(key):
        """Touched by more than one function: a closure can read it any time."""
        return len(read_funcs.get(key) or ()) > 1

    plan = []

    def nested_blocks(stmt):
        out = []
        stack = [stmt]
        while stack:
            cur = stack.pop(0)
            if isinstance(cur, dict):
                if cur.get("type") == "AstStatBlock" and cur is not stmt:
                    out.append(cur)
                    continue
                for k, v in cur.items():
                    if k != "location":
                        stack.append(v)
            elif isinstance(cur, list):
                stack.extend(cur)
        return out

    def scan(block, live, sink):
        """Reverse scan of one block; returns the locals that are live on entry.

        Drops are reported into `sink`, so a caller that has to try a block more
        than once can throw away the attempts that did not stick: a store seen
        as dead early in a loop fixpoint may well be live once the reads from
        the end of the body are known.
        """
        body = block.get("body") or []
        live = set(live)                 # the caller keeps its own set
        for stmt in reversed(body):
            head = set()
            _reads_head(stmt, head)      # a loop's condition runs after its body
            kids = nested_blocks(stmt)
            if stmt.get("type") == "AstStatIf" and len(kids) > 1:
                # The branches are alternatives, not a sequence: one branch
                # storing to a local says nothing about whether the code after
                # the statement needs the value the *other* branch left there.
                # Scan each from the same live-out and take the union, including
                # the fall-through path when there is no `else`.
                base = set(live) | head
                out = set(base)
                for child in kids:
                    out |= scan(child, set(base), sink)
                live = out
                kids = []
            for child in reversed(kids):
                if stmt.get("type") in LOOP_STAT:
                    cur = live | head
                    while True:          # the body's live-in is its own live-out
                        attempt = []
                        nxt = scan(child, set(cur), attempt) | cur
                        if nxt == cur:
                            sink.extend(attempt)
                            break
                        cur = nxt
                        if len(cur) > len(live) + len(head) + 64:
                            sink.extend(attempt)   # give up widening: keep all
                            break
                    live = cur
                else:
                    live = scan(child, live | head, sink)
            info = _targets(stmt)
            if info is None:
                use = set()
                _reads(stmt, use)
                live |= use
                continue
            targets, aligned = info
            # `x = nil` is a real store worth deleting when nothing reads x again;
            # inside a declaration it is a no-op (`local a, b = nil, v` would be
            # reprinted unchanged), so nil values are only dropped from a plain
            # assignment.
            is_decl = stmt.get("type") == "AstStatLocal"
            drop = [i for i, (key, val) in enumerate(targets)
                    if key not in live and not captured(key)
                    and val is not None and not (_is_nil(val) and is_decl)
                    and _harmless(val)]
            kept = [(key, val) for i, (key, val) in enumerate(targets) if i not in drop]
            if drop and aligned:
                sink.append((stmt, drop))
            use = set()
            _reads([v for _k, v in kept], use)
            live -= {k for k, _v in kept}
            live |= use
        return live


    scan(root, set(), plan)
    seen = set()
    unique = []
    for stmt, drop in plan:
        key = (stmt["location"], tuple(drop))
        if key not in seen:
            seen.add(key)
            unique.append((stmt, drop))
    return root, unique


def strip(text, rounds=3):
    """-> (text, stats). Removes the dead stores, then looks again."""
    import ast_polish

    stats = {"removed": 0}
    for _ in range(max(1, rounds)):
        try:
            root, plan = find_dead(text)
        except Exception as ex:
            print("[!] dead store pass skipped: %s" % str(ex)[:160], file=sys.stderr)
            return text, stats
        if not plan:
            return text, stats
        btext = text.encode("utf-8")
        starts = ast_polish._line_starts(btext)
        edits = []
        for stmt, drop in plan:
            s, e = ast_polish._loc_bytes(stmt["location"], starts)
            vars_ = stmt["vars"]
            vals = stmt.get("values") or []
            keep = [i for i in range(len(vars_)) if i not in drop]
            lhs = b", ".join(_slice(vars_[i], btext, starts) for i in keep)
            if stmt["type"] == "AstStatLocal":
                # A declaration is never deleted: the local may still be stored
                # to further down, and without `local` that store would write a
                # global. Dropped values become `nil` (they were unobservable),
                # and a dropped tail is simply cut off.
                names = b", ".join(_slice(v, btext, starts) for v in vars_)
                last = max([i for i in keep if i < len(vals)], default=-1)
                parts = [_slice(vals[i], btext, starts) if i in keep else b"nil"
                         for i in range(last + 1)]
                if parts:
                    edits.append((s, e, b"local " + names + b" = " + b", ".join(parts)))
                else:
                    edits.append((s, e, b"local " + names))
            elif not keep:
                s2, e2 = ast_polish._expand_full_line_delete(btext, s, e)
                edits.append((s2, e2, b""))
            else:
                rhs = b", ".join(_slice(vals[i], btext, starts) for i in keep)
                edits.append((s, e, lhs + b" = " + rhs))
            stats["removed"] += len(drop)
        text = ast_polish._apply_edits(btext, edits).decode("utf-8")
    return text, stats


def _slice(node, btext, starts):
    import ast_polish

    s, e = ast_polish._loc_bytes(node["location"], starts)
    return btext[s:e]


def main(argv):
    import argparse

    ap = argparse.ArgumentParser(description="remove stores nothing can read")
    ap.add_argument("file", help="file to clean, or - for stdin")
    ap.add_argument("-o", "--output")
    args = ap.parse_args(argv)
    text = sys.stdin.read() if args.file == "-" else open(args.file, encoding="utf-8").read()
    out, stats = strip(text)
    if args.output:
        with open(args.output, "w", encoding="utf-8", newline="\n") as fh:
            fh.write(out)
    else:
        sys.stdout.write(out)
    print("[deadstore] %d store(s) removed" % stats["removed"], file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
