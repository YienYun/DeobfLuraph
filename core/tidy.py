"""Take out the parentheses nothing needs.

The lifter prints a grouped expression the way the VM recorded it, so conditions
end up as `if (a == b) then` and assignments as `local x = (y)`. A group that is
the *whole* expression of a slot -- a condition, a return value, the value of an
assignment -- never needs to be there: nothing is left beside it to bind tighter.

A group around a call or `...` is only removed where a single value is expected,
because `f((g()))` truncates `g()` to one result while `f(g())` passes them all.
Everything else is left exactly as written.
"""
import sys

# Luau's binding powers, tightest last.
PREC = {
    "Or": 1, "And": 2,
    "CompareNe": 3, "CompareEq": 3, "CompareLt": 3, "CompareLe": 3, "CompareGt": 3, "CompareGe": 3,
    "Concat": 9,
    "Add": 10, "Sub": 10,
    "Mul": 11, "Div": 11, "FloorDiv": 11, "Mod": 11,
    "Pow": 14,
}
UNARY_PREC = 12
ATOMIC = {"AstExprLocal", "AstExprGlobal", "AstExprConstantString", "AstExprConstantNumber",
          "AstExprConstantBool", "AstExprConstantNil", "AstExprIndexName", "AstExprCall",
          "AstExprTable", "AstExprFunction", "AstExprIfElse"}

# Only a prefix expression can start an index: `({a = 1})[k]` needs its brackets,
# `{a = 1}[k]` does not parse, and `(a or b)[k]` is not `a or b[k]`.
PREFIX_EXPR = {"AstExprLocal", "AstExprGlobal", "AstExprCall", "AstExprIndexExpr",
               "AstExprIndexName", "AstExprGroup"}


def _is_group(e):
    return isinstance(e, dict) and e.get("type") == "AstExprGroup"


def _spreads(e):
    """True if `e` can produce more than one value."""
    return isinstance(e, dict) and e.get("type") in ("AstExprCall", "AstExprVarargs")


def strip_groups(text):
    """-> (text, removed)."""
    import ast_polish

    try:
        root = ast_polish._parse_ast(text)
    except Exception as ex:
        print("[!] group tidy skipped: %s" % str(ex)[:160], file=sys.stderr)
        return text, 0

    btext = text.encode("utf-8")
    starts = ast_polish._line_starts(btext)
    edits = []

    def inner_span(g):
        inner = g["expr"]
        s, e = ast_polish._loc_bytes(inner["location"], starts)
        return inner, btext[s:e]

    def mark(g, multi_value):
        inner, body = inner_span(g)
        if multi_value and _spreads(inner):
            return
        s, e = ast_polish._loc_bytes(g["location"], starts)
        edits.append((s, e, body))

    def prec_of(e):
        """Binding power of the expression's top node (atomic ones bind tightest)."""
        if not isinstance(e, dict):
            return 100
        t = e.get("type")
        if t == "AstExprBinary":
            return PREC.get(e.get("op"), 0)
        if t == "AstExprUnary":
            return UNARY_PREC
        return 100

    def fold_operand(group, parent, side):
        """A group inside a binary expression only needs to stay when it binds
        looser than the operator around it."""
        inner = group["expr"]
        if inner.get("type") in ATOMIC:
            mark(group, False)
            return
        pp = PREC.get(parent.get("op"), 0)
        ip = prec_of(inner)
        if ip > pp:
            mark(group, False)
            return
        # comparisons never chain in Lua (`a == b == c` will not parse), so they
        # are only folded when the inner expression is atomic
        if ip == pp and side == "left" and parent.get("op") in ("And", "Or", "Add", "Mul"):
            mark(group, False)          # (a and b) and c reads the same as a and b and c

    def walk(node, multi_value=False):
        if isinstance(node, dict):
            t = node.get("type") or ""
            if t in ("AstStatIf", "AstStatWhile", "AstStatRepeat"):
                cond = node.get("condition")
                if _is_group(cond):
                    mark(cond, False)
            elif t == "AstStatReturn":
                for v in node.get("exprs") or []:
                    if _is_group(v):
                        mark(v, True)
            elif t in ("AstStatLocal", "AstStatAssign"):
                for v in node.get("values") or []:
                    if _is_group(v):
                        mark(v, True)
            elif t == "AstExprCall":
                for v in node.get("args") or []:
                    if _is_group(v):
                        mark(v, True)
            elif t == "AstExprBinary":
                for side in ("left", "right"):
                    if _is_group(node.get(side)):
                        fold_operand(node[side], node, side)
            elif t == "AstExprUnary":
                inner = node.get("expr")
                # `not (x)` is `not x`; `not (a == b)` is not `not a == b`
                if _is_group(inner) and inner["expr"].get("type") in ATOMIC:
                    mark(inner, False)
            elif t == "AstExprIndexExpr":
                # the base has to stay a prefix expression; the slot inside the
                # brackets is a full expression, so its group can always go
                base = node.get("expr")
                if _is_group(base) and (base.get("expr") or {}).get("type") in PREFIX_EXPR:
                    mark(base, False)
                if _is_group(node.get("index")):
                    mark(node["index"], False)
            for k, v in node.items():
                if k != "location":
                    walk(v, False)
        elif isinstance(node, list):
            for x in node:
                walk(x, False)

    walk(root)
    if not edits:
        return text, 0
    return ast_polish._apply_edits(btext, edits).decode("utf-8"), len(edits)


def _side_effect_free(e):
    t = (e or {}).get("type") or ""
    if t in ("AstExprConstantNumber", "AstExprConstantString", "AstExprConstantBool",
             "AstExprConstantNil", "AstExprLocal", "AstExprGlobal", "AstExprTable"):
        return True
    if t == "AstExprIndexName":
        return _side_effect_free(e.get("expr"))
    return False


def drop_extra_args(text):
    """-> (text, dropped). The obfuscator's own seed numbers are still handed to
    functions that take no arguments: `compileChunk(488023178, 180544471)`."""
    import ast_polish

    try:
        root = ast_polish._parse_ast(text)
    except Exception:
        return text, 0
    btext = text.encode("utf-8")
    starts = ast_polish._line_starts(btext)
    sigs = {}

    def collect(node):
        if isinstance(node, dict):
            if node.get("type") == "AstStatLocalFunction":
                fn = node["func"]
                sigs[node["name"]["location"]] = (len(fn.get("args") or []), bool(fn.get("vararg")))
            elif node.get("type") == "AstStatLocal":
                vs, vals = node.get("vars") or [], node.get("values") or []
                for v, val in zip(vs, vals):
                    if val.get("type") == "AstExprFunction":
                        sigs[v["location"]] = (len(val.get("args") or []), bool(val.get("vararg")))
            for k, v in node.items():
                if k != "location":
                    collect(v)
        elif isinstance(node, list):
            for x in node:
                collect(x)

    collect(root)
    edits = []

    def walk(node):
        if isinstance(node, dict):
            if node.get("type") == "AstExprCall":
                fn = node.get("func") or {}
                args = node.get("args") or []
                sig = sigs.get(fn["local"]["location"]) if fn.get("type") == "AstExprLocal" else None
                if sig and not sig[1] and len(args) > sig[0] and all(
                        _side_effect_free(a) for a in args[sig[0]:]):
                    kept = b", ".join(
                        btext[slice(*ast_polish._loc_bytes(a["location"], starts))]
                        for a in args[:sig[0]])
                    fs, fe = ast_polish._loc_bytes(fn["location"], starts)
                    _cs, ce = ast_polish._loc_bytes(node["location"], starts)
                    edits.append((fe, ce, b"(" + kept + b")"))
            for k, v in node.items():
                if k != "location":
                    walk(v)
        elif isinstance(node, list):
            for x in node:
                walk(x)

    walk(root)
    if not edits:
        return text, 0
    return ast_polish._apply_edits(btext, edits).decode("utf-8"), len(edits)


def main(argv):
    import argparse

    ap = argparse.ArgumentParser(description="remove redundant parentheses")
    ap.add_argument("file", help="file to tidy, or - for stdin")
    ap.add_argument("-o", "--output")
    args = ap.parse_args(argv)
    text = sys.stdin.read() if args.file == "-" else open(args.file, encoding="utf-8").read()
    out, n = strip_groups(text)
    out, extra = drop_extra_args(out)
    if args.output:
        with open(args.output, "w", encoding="utf-8", newline="\n") as fh:
            fh.write(out)
    else:
        sys.stdout.write(out)
    print("[tidy] %d redundant group(s) removed, %d seed call(s) trimmed"
          % (n, extra), file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
