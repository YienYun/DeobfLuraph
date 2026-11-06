"""Collapse the register copies the lifter wrote out in full.

The VM moves values between registers, and the lifter keeps every move:

    local data2 = data3
    data2.RarityOrder = nameList
    data2 = data3
    data2.RarityRank = {}

None of that is a decision the script made; it is a register being refilled so
the next instruction has something to point at. Inlining the copy takes the
noise out and lets the names that remain say what they are.

A copy is inlined only when it cannot be observed:

  * the target is written exactly once (this copy) and no closure captures it,
  * the source is a local that is either a parameter or written exactly once,
    before the copy -- so it cannot change between the copy and the reads that
    stand in for it,
  * both live in the same function.

A target that is refilled, a source that is assigned again later, a value a
nested function can see: all left exactly as they are.
"""
import sys


def _pos(location):
    a, b = location.split(" - ")

    def p(x):
        line, col = x.split(",")
        return int(line) * 10000 + int(col)

    return p(a), p(b)


def _scan(root):
    """Write and read sites per local, with the function each one belongs to."""
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

    def walk(node, func, parent=None, field=None):
        if isinstance(node, dict):
            t = node.get("type") or ""
            if "location" not in node:
                for k, v in node.items():
                    walk(v, func, node, k)
                return
            if t == "AstExprFunction":
                func = (func or ()) + ((node.get("location") or id(node)),)
                for arg in node.get("args") or []:
                    names.setdefault(arg["location"], arg.get("name"))
            if t in ("AstStatLocal", "AstStatAssign"):
                vals = node.get("values") or []
                for i, var in enumerate(node.get("vars") or []):
                    local = var.get("local") if var.get("type") == "AstExprLocal" else var
                    if var.get("type") not in ("AstExprLocal", "AstLocal"):
                        continue
                    if not isinstance(local, dict) or "location" not in local:
                        continue
                    note(local["location"],
                         (node, i, vals[i] if i < len(vals) else None, func),
                         local.get("name"))
            elif t == "AstStatCompoundAssign":
                var = node.get("var") or {}
                if var.get("type") == "AstExprLocal":
                    note(var["local"]["location"], (node, 0, None, func),
                         var["local"].get("name"))
            elif t == "AstExprLocal":
                is_target = parent is not None and (
                    (parent.get("type") in ("AstStatLocal", "AstStatAssign") and field == "vars")
                    or (parent.get("type") == "AstStatCompoundAssign" and field == "var"))
                if not is_target:
                    reads.setdefault(node["local"]["location"], []).append((node, func))
                    names.setdefault(node["local"]["location"], node["local"].get("name"))
            for k, v in node.items():
                walk(v, func, node, k)
        elif isinstance(node, list):
            for x in node:
                walk(x, func, parent, field)

    walk(root, None)
    return writes, reads, names, order


def _scope_index(root):
    """Every block, with the locals its direct statements declare."""
    scopes = []

    def walk(node, inherited):
        if isinstance(node, dict):
            t = node.get("type")
            if t == "AstStatBlock":
                table = dict(inherited)
                for stmt in node.get("body") or []:
                    st = stmt.get("type")
                    if st == "AstStatLocal":
                        for v in stmt.get("vars") or []:
                            table[v.get("name")] = v.get("location")
                    elif st == "AstStatLocalFunction":
                        nm = stmt.get("name") or {}
                        table[nm.get("name")] = nm.get("location")
                    elif st == "AstStatFor":
                        var = stmt.get("var") or {}
                        table[var.get("name")] = var.get("location")
                    elif st == "AstStatForIn":
                        for v in stmt.get("vars") or []:
                            table[v.get("name")] = v.get("location")
                s0, s1 = _pos(node["location"])
                scopes.append((s0, s1, table))
                for k, v in node.items():
                    if k != "location":
                        walk(v, table)
                return
            if t == "AstExprFunction":
                params = {a.get("name"): a["location"] for a in node.get("args") or []}
                for k, v in node.items():
                    if k != "location":
                        walk(v, params if k == "body" else inherited)
                return
            for k, v in node.items():
                if k != "location":
                    walk(v, inherited)
        elif isinstance(node, list):
            for x in node:
                walk(x, inherited)

    walk(root, {})
    return scopes


def _resolves(pos, name, key, scopes):
    """Does `name` at this position mean the local `key` (and nothing else)?"""
    best = None
    for s0, s1, table in scopes:
        if s0 <= pos <= s1 and name in table:
            if best is None or (s1 - s0) < (best[1] - best[0]):
                best = (s0, s1, table[name])
    if best is None:
        return False
    return best[2] == key


def _root_name(e):
    while isinstance(e, dict):
        t = e.get("type")
        if t == "AstExprGlobal":
            return e.get("name")
        if t == "AstExprIndexName":
            e = e.get("expr")
            continue
        return None
    return None


def _shadowed(pos, name, scopes):
    for s0, s1, table in scopes:
        if s0 <= pos <= s1 and name in table:
            return True
    return False


def _pure_name(e):
    """A bare global, or a dotted path of them (`Color3.fromRGB`, `table.insert`)."""
    t = e.get("type")
    if t == "AstExprGlobal":
        return True
    if t == "AstExprIndexName":
        return _pure_name(e["expr"])
    return False


def _targets_of(stmt):
    """Locations of every local this statement (or anything inside it) writes."""
    out = set()

    def walk(node, parent=None, field=None):
        if isinstance(node, dict):
            t = node.get("type") or ""
            if t in ("AstStatLocal", "AstStatAssign"):
                for var in node.get("vars") or []:
                    local = var.get("local") if var.get("type") == "AstExprLocal" else var
                    if var.get("type") in ("AstExprLocal", "AstLocal") and isinstance(local, dict):
                        out.add(local.get("location"))
            elif t == "AstStatCompoundAssign":
                var = node.get("var") or {}
                if var.get("type") == "AstExprLocal":
                    out.add(var["local"]["location"])
            elif t == "AstStatLocalFunction":
                out.add((node.get("name") or {}).get("location"))
            for k, v in node.items():
                if k != "location":
                    walk(v, node, k)
        elif isinstance(node, list):
            for x in node:
                walk(x, parent, field)

    walk(stmt)
    return out


def find_copies(text):
    """-> (root, [(statement, target location, source location, keep_decl)]).

    A copy is folded when every read of its target happens after it and before
    the next write to that target -- so nothing can observe the register, and
    the reads can simply name the source instead.
    """
    import ast_polish

    root = ast_polish._parse_ast(text)
    writes, reads, names, order = _scan(root)

    def captured(key):
        funcs = {func for _n, func in reads.get(key, [])}
        funcs |= {w[3] for w in writes.get(key, [])}
        return len(funcs) > 1

    plan = []

    def scan_block(block):
        body = block.get("body") or []
        marks = []
        for stmt in body:
            s0, s1 = _pos(stmt["location"])
            marks.append((s0, s1, _targets_of(stmt)))
        blk_start = _pos(body[0]["location"])[0] if body else 0
        blk_end = _pos(body[-1]["location"])[1] if body else 0
        for i, stmt in enumerate(body):
            if stmt.get("type") not in ("AstStatLocal", "AstStatAssign"):
                continue
            vars_ = stmt.get("vars") or []
            vals = stmt.get("values") or []
            if len(vars_) != 1 or len(vals) != 1:
                continue
            var = vars_[0]
            if var.get("type") not in ("AstExprLocal", "AstLocal"):
                continue
            local = var.get("local") if var.get("type") == "AstExprLocal" else var
            if not isinstance(local, dict) or "location" not in local or local["location"] not in writes:
                continue
            key = local["location"]
            value = vals[0]
            if value.get("type") == "AstExprLocal":
                src = ("local", value["local"]["location"])
            elif _pure_name(value):
                src = ("expr", value["location"])
            else:
                continue
            if src[0] == "local" and (src[1] == key or captured(key)):
                continue
            here = _pos(stmt["location"])[0]
            src_writes = writes.get(src[1]) or [] if src[0] == "local" else []
            if len(src_writes) > 1:
                continue
            if len(src_writes) == 1:
                src_chain = src_writes[0][3] or ()
                own_chain = writes[key][0][3] or ()
                if own_chain[:len(src_chain)] != src_chain:
                    continue
                if _pos(src_writes[0][0]["location"])[0] > here:
                    continue
            stop = None
            stop_end = None
            stop_simple = False
            for j in range(i + 1, len(body)):
                if key in marks[j][2]:
                    stop, stop_end = marks[j][0], marks[j][1]
                    stop_simple = not _child_blocks(body[j])
                    break
            reads_here = [_pos(node["location"])[0] for node, _f in reads.get(key, [])]
            if not reads_here:
                continue
            loops = []
            for j in range(i + 1, len(body)):
                stmt_j = body[j]
                if stmt_j.get("type") not in ("AstStatFor", "AstStatWhile", "AstStatRepeat"):
                    continue
                if key in _targets_of(stmt_j):
                    s0, s1 = _pos(stmt_j["location"])
                    loops.append((s0, s1))
            ok = []
            for r in reads_here:
                if any(s0 <= r <= s1 for s0, s1 in loops):
                    ok.append(None)
                elif not (blk_start <= r <= blk_end):
                    ok.append(None)
                elif here < r and (stop is None or r < stop):
                    ok.append(True)
                elif stop is not None and stop <= r <= stop_end:
                    ok.append(True)
                elif stop is not None and stop_simple:
                    ok.append(False)
                else:
                    ok.append(None)
            scopes = _scope_index(root)
            if src[0] == "local":
                src_name = names.get(src[1])
                for idx, r in enumerate(reads_here):
                    if ok[idx] is True and not _resolves(r, src_name, src[1], scopes):
                        ok[idx] = None
            else:
                src_name = _root_name(value)
                for idx, r in enumerate(reads_here):
                    if ok[idx] is True and _shadowed(r, src_name, scopes):
                        ok[idx] = None
            if any(x is None for x in ok):
                continue
            is_decl = stmt.get("type") == "AstStatLocal"
            writes_later = any(key in t for _p, _e, t in marks[i + 1:])
            keep_decl = is_decl and (writes_later or any(x is False for x in ok))
            plan.append((stmt, key, src, keep_decl, [r for r, k in zip(reads_here, ok) if k]))
        for stmt in body:
            for child in _child_blocks(stmt):
                scan_block(child)

    scan_block(root)
    changed = True
    while changed:
        changed = False
        gone = {entry[1] for entry in plan}
        kept = [entry for entry in plan
                if not (entry[2][0] == "local" and entry[2][1] in gone)]
        if len(kept) != len(plan):
            plan, changed = kept, True
    return root, plan


def _inner_blocks(stmt, starts):
    """Source span of every block nested inside this statement."""
    import ast_polish

    spans = []

    def walk(node, top):
        if isinstance(node, dict):
            if node is not top and node.get("type") == "AstStatBlock":
                spans.append(ast_polish._loc_bytes(node["location"], starts))
                return
            for k, v in node.items():
                if k != "location":
                    walk(v, top)
        elif isinstance(node, list):
            for x in node:
                walk(x, top)

    walk(stmt, stmt)
    return spans


def _child_blocks(stmt):
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


def propagate(text, rounds=4):
    """-> (text, stats). Inlines the copies, then looks again."""
    import ast_polish

    stats = {"inlined": 0, "dropped": 0, "temps": 0}
    for _ in range(max(1, rounds)):
        try:
            root, plan = find_copies(text)
        except Exception as ex:
            print("[!] copy pass skipped: %s" % str(ex)[:160], file=sys.stderr)
            return text, stats
        if not plan:
            break
        btext = text.encode("utf-8")
        starts = ast_polish._line_starts(btext)
        _writes, reads, names, _order = _scan(root)

        edits = []
        for stmt, tgt, src, keep_decl, window in plan:
            if src[0] == "expr":
                s0, e0 = ast_polish._loc_bytes(src[1], starts)
                name = btext[s0:e0]
            else:
                name = names[src[1]].encode("utf-8")
            for node, _func in reads.get(tgt, []):
                if _pos(node["location"])[0] not in window:
                    continue
                s, e = ast_polish._loc_bytes(node["location"], starts)
                edits.append((s, e, name))
            s, e = ast_polish._loc_bytes(stmt["location"], starts)
            if keep_decl:
                var = stmt["vars"][0]
                _vs, ve = ast_polish._loc_bytes(var["location"], starts)
                edits.append((s, e, btext[s:ve]))
            else:
                s, e = ast_polish._expand_full_line_delete(btext, s, e)
                edits.append((s, e, b""))
        text = ast_polish._apply_edits(btext, edits).decode("utf-8")
        stats["inlined"] += len(plan)
    text, temps = inline_temps(text)
    stats["temps"] = temps["inlined"]
    text, dropped = drop_unused_decls(text)
    stats["dropped"] = dropped
    return text, stats


_ATOMIC = {"AstExprLocal", "AstExprGlobal", "AstExprConstantString", "AstExprConstantNumber",
           "AstExprConstantBool", "AstExprConstantNil", "AstExprIndexName", "AstExprCall"}


def inline_temps(text, rounds=3):
    """-> (text, stats). A local written once and read once, right below, is a
    temporary: naming it adds a word without saying anything."""
    import ast_polish

    stats = {"inlined": 0}
    for _ in range(max(1, rounds)):
        try:
            root = ast_polish._parse_ast(text)
        except Exception as ex:
            print("[!] temp pass skipped: %s" % str(ex)[:160], file=sys.stderr)
            return text, stats
        writes, reads, _names, _order = _scan(root)
        btext = text.encode("utf-8")
        starts = ast_polish._line_starts(btext)
        edits = []

        def captured(key):
            funcs = {func for _n, func in reads.get(key, [])}
            funcs |= {w[3] for w in writes.get(key, [])}
            return len(funcs) > 1

        def scan_block(block):
            body = block.get("body") or []
            for i, stmt in enumerate(body[:-1]):
                if stmt.get("type") != "AstStatLocal":
                    continue
                vars_, vals = stmt.get("vars") or [], stmt.get("values") or []
                if len(vars_) != 1 or len(vals) != 1:
                    continue
                key = vars_[0].get("location")
                if len(writes.get(key) or []) != 1 or captured(key):
                    continue
                rs = reads.get(key) or []
                if len(rs) != 1:
                    continue
                nxt = body[i + 1]
                ns, ne = ast_polish._loc_bytes(nxt["location"], starts)
                rnode = rs[0][0]
                rs_, re_ = ast_polish._loc_bytes(rnode["location"], starts)
                if not (ns <= rs_ and re_ <= ne):
                    continue
                if any(bs <= rs_ and re_ <= be for bs, be in _inner_blocks(nxt, starts)):
                    continue
                value = vals[0]
                if value.get("type") not in _ATOMIC:
                    continue
                s0, e0 = ast_polish._loc_bytes(value["location"], starts)
                body_src = btext[s0:e0]
                edits.append((rs_, re_, body_src))
                ds, de = ast_polish._loc_bytes(stmt["location"], starts)
                ds, de = ast_polish._expand_full_line_delete(btext, ds, de)
                edits.append((ds, de, b""))
            for stmt in body:
                for child in _child_blocks(stmt):
                    scan_block(child)

        scan_block(root)
        if not edits:
            break
        text = ast_polish._apply_edits(btext, edits).decode("utf-8")
        stats["inlined"] += len(edits) // 2
        text, _dropped = drop_unused_decls(text)
    return text, stats


def drop_unused_decls(text):
    """-> (text, dropped). `local x` with a value nobody reads is pure noise."""
    import ast_polish

    try:
        root = ast_polish._parse_ast(text)
    except Exception:
        return text, 0
    writes, reads, _names, _order = _scan(root)
    btext = text.encode("utf-8")
    starts = ast_polish._line_starts(btext)
    edits = []
    dropped = 0

    def walk(node):
        nonlocal dropped
        if isinstance(node, dict):
            if node.get("type") == "AstStatLocal" and not (node.get("values") or []):
                vars_ = node.get("vars") or []
                keep = [v for v in vars_
                        if reads.get(v["location"]) or len(writes.get(v["location"]) or []) > 1]
                if not keep:
                    s0, e0 = ast_polish._loc_bytes(node["location"], starts)
                    s0, e0 = ast_polish._expand_full_line_delete(btext, s0, e0)
                    edits.append((s0, e0, b""))
                    dropped += len(vars_)
                elif len(keep) != len(vars_):
                    new_decl = b"local " + b", ".join(
                        btext[slice(*ast_polish._loc_bytes(v["location"], starts))] for v in keep)
                    s0, e0 = ast_polish._loc_bytes(node["location"], starts)
                    edits.append((s0, e0, new_decl))
                    dropped += len(vars_) - len(keep)
            for k, v in node.items():
                if k != "location":
                    walk(v)
        elif isinstance(node, list):
            for x in node:
                walk(x)

    walk(root)
    if not edits:
        return text, 0
    return ast_polish._apply_edits(btext, edits).decode("utf-8"), dropped


def main(argv):
    import argparse

    ap = argparse.ArgumentParser(description="inline register copies")
    ap.add_argument("file", help="file to clean, or - for stdin")
    ap.add_argument("-o", "--output")
    args = ap.parse_args(argv)
    text = sys.stdin.read() if args.file == "-" else open(args.file, encoding="utf-8").read()
    out, stats = propagate(text)
    if args.output:
        with open(args.output, "w", encoding="utf-8", newline="\n") as fh:
            fh.write(out)
    else:
        sys.stdout.write(out)
    print("[copies] %d copy(ies) inlined, %d temporary(ies) folded, "
          "%d unused declaration(s) dropped"
          % (stats["inlined"], stats["temps"], stats["dropped"]), file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
