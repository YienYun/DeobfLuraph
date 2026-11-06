"""Exact constant folding for the u32 arithmetic a Luraph build leaves behind.

The v15 lifter emits `u32Trunc(x)` and `u32Mul(a, b)` -- and keeps `bit32.*`
calls -- wherever the VM did 32-bit arithmetic.  When a state machine is seeded
with literals, that shows up as arithmetic where every operand is known:

    local value2 = bit32.bxor(444954721, 0)
    value, value2 = pcall, u32Trunc((u32Mul(1115083310, value2) + 3588422128)
                                    + (u32Mul(3179883987, bit32.bor(value2, 44799432)) + ...))

Folding it turns the line into the constant it computes, and hands that constant
to the control-flow passes, which can then see what a branch really tests.

Nothing here is approximate.  A value is folded only when

  * every operand is an integer literal or a local proven to hold one,
  * the operation is evaluated in exact Python integers, with `u32*` taken
    modulo 2**32 exactly as the emitted helper does,
  * the result is an integer with |v| < 2**53, so Lua's double holds it exactly.

Otherwise the expression is left byte-for-byte as it was.

A local is only propagated when it is written exactly once in its block and is
never referenced from a nested function body (where it could be written behind
our back); the folder is a straight-line reading, not a claim of purity.
"""

import re
import sys

U32 = 1 << 32
U32_MASK = U32 - 1
TWO53 = 1 << 53

BIT32_OPS = {
    "band": lambda a, b: a & b,
    "bor": lambda a, b: a | b,
    "bxor": lambda a, b: a ^ b,
    "bnot": lambda a: ~a & U32_MASK,
    "lshift": lambda a, b: (a << (b % 32)) & U32_MASK,
    "rshift": lambda a, b: a >> (b % 32),
    "lrotate": lambda a, b: ((a << (b % 32)) | (a >> ((32 - b) % 32))) & U32_MASK,
    "rrotate": lambda a, b: ((a >> (b % 32)) | (a << ((32 - b) % 32))) & U32_MASK,
}

_BIN_OPS = {
    "Add": lambda a, b: a + b,
    "Sub": lambda a, b: a - b,
    "Mul": lambda a, b: a * b,
    "IDiv": lambda a, b: a // b,
    "Mod": lambda a, b: a % b,
}

_MODELED = {"u32Mul", "u32Trunc"}

_CALL_RE = re.compile(r"(?<![\w.])(?:bit32\.(?:band|bor|bxor|bnot|lshift|rshift|lrotate|rrotate)"
                      r"|u32Trunc|u32Mul)\s*\(")


def _line_starts(btext):
    starts = [0]
    pos = 0
    while True:
        nl = btext.find(b"\n", pos)
        if nl < 0:
            break
        starts.append(nl + 1)
        pos = nl + 1
    return starts


def _loc_bytes(loc_str, starts):
    a, b = loc_str.split(" - ")
    l0, c0 = map(int, a.split(","))
    l1, c1 = map(int, b.split(","))
    return starts[l0] + c0, starts[l1] + c1


def _num(node):
    if node.get("type") == "AstExprConstantNumber":
        v = node.get("value")
        if isinstance(v, bool):
            return None
        if isinstance(v, int):
            return v
        if isinstance(v, float) and v.is_integer() and abs(v) < TWO53:
            return int(v)
    return None


def _int_val(v):
    """`v` as an int when it is an exact integer, else None (bit32 coerces)."""
    if isinstance(v, int):
        return v
    if isinstance(v, float) and v == int(v) and abs(v) < TWO53:
        return int(v)
    return None


def _int_known(node):
    """True when a node provably evaluates to an integer, not a float."""
    if not isinstance(node, dict):
        return False
    t = node.get("type") or ""
    if t in ("AstExprGroup", "AstExprTypeAssertion"):
        return _int_known(node.get("expr") or {})
    if t == "AstExprConstantNumber":
        v = _num(node)
        return v is not None and v == int(v)
    if t == "AstExprUnary":
        return node.get("op") == "#"
    if t == "AstExprCall":
        name = _callee(node)
        return name is not None and (name.startswith("bit32.") or name in _MODELED)
    return False


def _callee(node):
    """`bit32.bxor` / `u32Trunc` / `u32Mul` for a call node, else None."""
    if node.get("type") != "AstExprCall":
        return None
    fn = node.get("func") or {}
    if fn.get("type") == "AstExprGlobal":
        name = fn.get("global") or fn.get("name")
        return name if name in _MODELED else None
    if fn.get("type") == "AstExprLocal":
        name = (fn.get("local") or {}).get("name")
        return name if name in _MODELED else None
    if fn.get("type") == "AstExprIndexName":
        base = fn.get("expr") or {}
        if base.get("type") == "AstExprGlobal" and base.get("global") == "bit32":
            return "bit32." + fn["index"]
    return None


def _args(node):
    out = []
    for a in node.get("args") or []:
        if a.get("type") == "AstExprVarargs":
            return None
        out.append(a)
    return out


def _ev(node, env, depth=0):
    """Exact integer value of `node`, or None when it is not provably constant."""
    if depth > 24:
        return None
    v = _num(node)
    if v is not None:
        return v
    t = node.get("type")
    if t == "AstExprGroup":
        return _ev(node.get("expr") or {}, env, depth + 1)
    if t == "AstExprTypeAssertion":
        return _ev(node.get("expr") or {}, env, depth + 1)
    if t == "AstExprLocal":
        loc = node.get("local") or {}
        return env.get(loc.get("location"))
    if t == "AstExprUnary" and node.get("op") == "Minus":
        x = _ev(node["expr"], env, depth + 1)
        return None if x is None else -x
    if t == "AstExprBinary":
        op = _BIN_OPS.get(node.get("op"))
        if op is None:
            return None
        a = _ev(node["left"], env, depth + 1)
        b = _ev(node["right"], env, depth + 1)
        if a is None or b is None:
            return None
        if node["op"] in ("IDiv", "Mod") and b == 0:
            return None
        try:
            r = op(a, b)
        except (ZeroDivisionError, ValueError):
            return None
        return r if abs(r) < TWO53 else None
    name = _callee(node)
    if name is None:
        return None
    args = _args(node)
    if args is None:
        return None
    vals = [_ev(a, env, depth + 1) for a in args]
    if any(x is None for x in vals):
        return None
    if name == "u32Trunc" and len(vals) == 1:
        return vals[0] % U32
    if name == "u32Mul" and len(vals) == 2:
        return (vals[0] * vals[1]) % U32
    if name.startswith("bit32."):
        fn = BIT32_OPS.get(name.split(".", 1)[1])
        if fn is None:
            return None
        vals = [_int_val(v) for v in vals]
        if any(v is None for v in vals):
            return None
        try:
            r = fn(*vals)
        except (TypeError, ValueError, ZeroDivisionError):
            return None
        return r if 0 <= r < U32 else None
    return None


def _writes_and_captures(block, writes, captured):
    """How often each local of this block is written, and which are captured.

    Nested function bodies are walked for *reads only*: a local they mention can
    be written from inside one, so it is never propagated.  Their own locals are
    a different scope and are ignored.
    """
    def scan_expr(node, inside_fn):
        if isinstance(node, dict):
            t = node.get("type")
            if t == "AstExprLocal":
                loc = (node.get("local") or {}).get("location")
                if inside_fn and loc:
                    captured.add(loc)
                return
            if t == "AstExprFunction":
                for body in (node.get("body") or {}).get("body") or []:
                    scan_expr(body, True)
                return
            for k, v in node.items():
                if k in ("local", "location"):
                    continue
                scan_expr(v, inside_fn)
        elif isinstance(node, list):
            for x in node:
                scan_expr(x, inside_fn)

    def scan_stat(st, inside_fn):
        if not isinstance(st, dict):
            return
        t = st.get("type")
        if t == "AstStatLocal":
            for v in st.get("values") or []:
                scan_expr(v, inside_fn)
            if not inside_fn:
                for var in st.get("vars") or []:
                    loc = var.get("location")
                    writes[loc] = writes.get(loc, 0) + 1
            else:
                for var in st.get("vars") or []:
                    captured.add(var.get("location"))
            return
        if t == "AstStatAssign":
            for v in st.get("values") or []:
                scan_expr(v, inside_fn)
            for var in st.get("vars") or []:
                if var.get("type") == "AstExprLocal":
                    loc = var["local"]["location"]
                    if inside_fn:
                        captured.add(loc)
                    else:
                        writes[loc] = writes.get(loc, 0) + 1
                else:
                    scan_expr(var, inside_fn)
            return
        if t == "AstStatCompoundAssign":
            var = st.get("var") or {}
            if var.get("type") == "AstExprLocal":
                loc = var["local"]["location"]
                if inside_fn:
                    captured.add(loc)
                else:
                    writes[loc] = writes.get(loc, 0) + 1
            scan_expr(st.get("value"), inside_fn)
            return
        for k, v in st.items():
            if k in ("body", "thenbody", "elsebody") and isinstance(v, dict):
                for inner in v.get("body") or []:
                    scan_stat(inner, inside_fn)
                continue
            if isinstance(v, dict) and (v.get("type") or "").startswith("AstStat"):
                scan_stat(v, inside_fn)
                continue
            scan_expr(v, inside_fn)

    for st in block.get("body") or []:
        scan_stat(st, False)


def _int_lit(v):
    return str(v).encode("ascii")


def _fold_expr(node, env, starts, edits, stats):
    """Fold the outermost constant expression in `node`; recurse for the rest."""
    if not isinstance(node, dict):
        return
    t = node.get("type") or ""
    if not t.startswith("AstExpr"):
        return

    v = _ev(node, env)
    if v is not None and t not in ("AstExprConstantNumber", "AstExprLocal"):
        s, e = _loc_bytes(node["location"], starts)
        edits.append((s, e, _int_lit(v)))
        stats["folded"] += 1
        return

    name = _callee(node)
    if name in ("bit32.bxor", "bit32.bor", "bit32.band"):
        args = _args(node) or []
        if len(args) == 2:
            a, b = args
            zero_l = _num(a) == 0
            zero_r = _num(b) == 0
            mask_l = _num(a) == U32_MASK
            mask_r = _num(b) == U32_MASK
            keep = None
            if name in ("bit32.bxor", "bit32.bor") and (zero_l or zero_r):
                keep = b if zero_l else a
            elif name == "bit32.band" and (mask_l or mask_r):
                keep = b if mask_l else a
            if keep is not None and not _int_known(keep):
                keep = None
            if keep is not None:
                s, e = _loc_bytes(node["location"], starts)
                ks, ke = _loc_bytes(keep["location"], starts)
                edits.append((s, e, ("src", ks, ke)))
                stats["identity"] += 1
                return
    if name == "u32Trunc":
        args = _args(node) or []
        if len(args) == 1 and _callee(args[0]) == "u32Trunc":
            s, e = _loc_bytes(node["location"], starts)
            ks, ke = _loc_bytes(args[0]["location"], starts)
            edits.append((s, e, ("src", ks, ke)))
            stats["identity"] += 1
            return

    if t == "AstExprFunction":
        body = (node.get("body") or {}).get("body") or []
        _fold_block(node.get("body") or {}, starts, edits, stats)
        return

    for k, val in node.items():
        if k in ("location", "local"):
            continue
        if isinstance(val, dict) and (val.get("type") or "").startswith("AstExpr"):
            _fold_expr(val, env, starts, edits, stats)
        elif isinstance(val, list):
            for x in val:
                if isinstance(x, dict) and (x.get("type") or "").startswith("AstExpr"):
                    _fold_expr(x, env, starts, edits, stats)


def _fold_stat(st, env, starts, edits, stats):
    t = st.get("type") or ""
    if t == "AstStatLocal":
        values = st.get("values") or []
        for v in values:
            _fold_expr(v, env, starts, edits, stats)
        if len(values) == 1 and len(st.get("vars") or []) == 1:
            var = st["vars"][0]
            loc = var.get("location")
            val = _ev(values[0], env)
            if val is not None and stats["writes"].get(loc) == 1 and loc not in stats["captured"]:
                env[loc] = val
            else:
                env.pop(loc, None)
        else:
            for var in st.get("vars") or []:
                env.pop(var.get("location"), None)
        return
    if t == "AstStatAssign":
        for v in st.get("values") or []:
            _fold_expr(v, env, starts, edits, stats)
        for var in st.get("vars") or []:
            if var.get("type") == "AstExprLocal":
                env.pop(var["local"]["location"], None)
            else:
                _fold_expr(var, env, starts, edits, stats)
        return
    if t == "AstStatCompoundAssign":
        _fold_expr(st.get("value"), env, starts, edits, stats)
        var = st.get("var") or {}
        if var.get("type") == "AstExprLocal":
            env.pop(var["local"]["location"], None)
        return
    for k, v in st.items():
        if k == "location":
            continue
        if isinstance(v, dict):
            vt = v.get("type") or ""
            if vt == "AstStatBlock":
                _fold_block(v, starts, edits, stats)
            elif vt.startswith("AstStat"):
                _fold_stat(v, env, starts, edits, stats)
            elif vt.startswith("AstExpr"):
                _fold_expr(v, env, starts, edits, stats)
        elif isinstance(v, list):
            for x in v:
                if not isinstance(x, dict):
                    continue
                xt = x.get("type") or ""
                if xt.startswith("AstExpr"):
                    _fold_expr(x, env, starts, edits, stats)
                elif xt.startswith("AstStat"):
                    _fold_stat(x, env, starts, edits, stats)


def _fold_block(block, starts, edits, stats):
    """Fold one block. Every block starts with a fresh environment."""
    env = {}
    body = block.get("body") or []
    writes = dict(stats["writes"])
    captured = set(stats["captured"])
    for st in body:
        _fold_stat(st, env, starts, edits, stats)


_INTRINSIC_MARKER = {"u32Mul": 65535, "u32Trunc": 4294967296}


def _num_consts(node, out):
    stack = [node]
    while stack:
        cur = stack.pop()
        if isinstance(cur, dict):
            if cur.get("type") == "AstExprConstantNumber":
                out.add(round(float(cur.get("value") or 0)))
            stack.extend(v for v in cur.values() if isinstance(v, (dict, list)))
        elif isinstance(cur, list):
            stack.extend(cur)


def _local_defs(node, out):
    """Collect (name, function node) for every local function definition."""
    stack = [node]
    while stack:
        cur = stack.pop()
        if isinstance(cur, dict):
            t = cur.get("type") or ""
            if t == "AstStatLocalFunction":
                nm = (cur.get("name") or {}).get("name")
                if nm:
                    out.append((nm, cur.get("func") or {}))
            elif t == "AstStatFunction":
                expr = cur.get("name") or {}
                if expr.get("type") == "AstExprLocal":
                    nm = (expr.get("local") or {}).get("name")
                    if nm:
                        out.append((nm, cur.get("func") or {}))
            stack.extend(v for v in cur.values() if isinstance(v, (dict, list)))
        elif isinstance(cur, list):
            stack.extend(cur)


def _modeled(root):
    """Which intrinsic names may be evaluated in this file."""
    defs = []
    _local_defs(root, defs)
    modeled = set(_MODELED)
    for name, fn in defs:
        marker = _INTRINSIC_MARKER.get(name)
        if marker is None:
            continue
        consts = set()
        _num_consts(fn, consts)
        if marker in consts:
            modeled.add(name)
        else:
            modeled.discard(name)
    return modeled


def _prepare(root, stats):
    """Write counts and captured locals, block by block (nested blocks too)."""
    stats["writes"] = {}
    stats["captured"] = set()
    _writes_and_captures(root, stats["writes"], stats["captured"])


def fold_text(text, rounds=3):
    """-> (text, stats). `stats` counts folds and identities for the log.

    Folding reveals more constants (a local that only becomes constant once its
    initialiser is folded), so the pass runs to a fixpoint.
    """
    stats = {"folded": 0, "identity": 0}
    total = 0
    for _ in range(max(1, rounds)):
        text, one = _fold_once(text)
        total += one.get("edits", 0)
        stats["folded"] += one.get("folded", 0)
        stats["identity"] += one.get("identity", 0)
        stats.update({k: v for k, v in one.items() if k in ("left",)})
        if not one.get("edits"):
            break
    stats["edits"] = total
    return text, stats


def _fold_once(text):
    import ast_polish

    stats = {"folded": 0, "identity": 0}
    try:
        root = ast_polish._parse_ast(text)
    except Exception as ex:
        print("[!] u32 fold skipped: %s" % str(ex)[:160], file=sys.stderr)
        return text, stats

    global _MODELED
    _MODELED = _modeled(root)
    _prepare(root, stats)
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    edits = []
    _fold_block(root, starts, edits, stats)

    if not edits:
        return text, stats

    resolved = []
    for s0, e0, repl in edits:
        identity = isinstance(repl, tuple) and repl and repl[0] == "src"
        if identity:
            repl = btext[repl[1]:repl[2]]
        if repl == btext[s0:e0]:
            stats["identity" if identity else "folded"] -= 1
            continue
        resolved.append((s0, e0, repl))

    out = _apply_descending(btext, resolved)
    folded = len(resolved)
    left = len(_CALL_RE.findall(out.decode("utf-8")))
    stats["left"] = left
    stats["edits"] = folded
    return out.decode("utf-8"), stats


def _apply_descending(btext, edits):
    """Apply non-overlapping edits right to left, dropping anything that nests."""
    accepted = []
    limit = len(btext) + 1
    for s0, e0, repl in sorted(edits, key=lambda x: (x[0], x[1]), reverse=True):
        if 0 <= s0 <= e0 <= limit:
            accepted.append((s0, e0, repl))
            limit = s0
    for s0, e0, repl in accepted:
        btext = btext[:s0] + repl + btext[e0:]
    return btext


def main(argv):
    import argparse
    ap = argparse.ArgumentParser(description="fold u32 arithmetic to constants")
    ap.add_argument("file", help="file to fold, or - for stdin")
    ap.add_argument("-o", "--output")
    a = ap.parse_args(argv)
    if a.file == "-":
        text = sys.stdin.read()
    else:
        with open(a.file, encoding="utf-8") as fh:
            text = fh.read()
    out, stats = fold_text(text)
    if a.output:
        with open(a.output, "w", encoding="utf-8", newline="\n") as fh:
            fh.write(out)
    else:
        sys.stdout.write(out)
    print("[u32fold] folded=%d identities=%d left=%d (was %d)"
          % (stats["edits"], stats["identity"], stats.get("left", -1),
             len(_CALL_RE.findall(text))), file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
