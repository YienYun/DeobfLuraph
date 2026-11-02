import json
import sys
import os
import re

# `upv<slot>`: the name the lifter invents for a capture it could not follow.
UNRESOLVED_CAPTURE = re.compile(r"\bupv(\d+)(?:_(\d+))?\b")
import tempfile

import harness


def _parse_ast(text):
    with tempfile.NamedTemporaryFile("w", suffix=".luau", delete=False, encoding="utf-8", newline="\n") as f:
        f.write(text)
        path = f.name
    try:
        r = harness.run_luau_ast(path)
        if r.returncode != 0:
            raise SyntaxError("not valid Luau: %s" % r.stderr.decode("latin-1").strip()[:500])
        out = r.stdout
    finally:
        os.remove(path)
    return json.loads(out.decode("latin-1"))["root"]


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


def _dotted(node):
    parts = []
    cur = node
    while isinstance(cur, dict):
        t = cur.get("type")
        if t == "AstExprGlobal":
            parts.append(cur.get("global") or cur.get("name") or "")
            return ".".join(reversed(parts))
        if t == "AstExprIndexName":
            parts.append(cur["index"])
            cur = cur["expr"]
            continue
        break
    return None


_PURE_CALLEES = frozenset({
    "bit32.band", "bit32.bor", "bit32.bxor", "bit32.bnot",
    "bit32.lshift", "bit32.rshift", "bit32.arshift", "bit32.lrotate", "bit32.rrotate",
    "bit32.btest", "bit32.extract", "bit32.replace", "bit32.countlz", "bit32.countrz",
    "math.abs", "math.floor", "math.ceil", "math.min", "math.max", "math.sqrt",
    "math.clamp", "math.round", "Vector3.new", "Vector2.new", "CFrame.new",
    "Color3.fromRGB", "Color3.new", "UDim2.new", "UDim2.fromOffset", "UDim2.fromScale",
    "UDim.new", "os.clock", "table.pack", "table.create", "select", "tonumber", "type", "typeof",
})


def _is_pure_expr(node, allow_func=False):
    if not isinstance(node, dict):
        return False
    t = node.get("type")
    if t in ("AstExprConstantNil", "AstExprConstantBool", "AstExprConstantNumber",
             "AstExprConstantString", "AstExprLocal"):
        return True
    if t == "AstExprFunction":
        return allow_func
    if t == "AstExprGroup":
        return _is_pure_expr(node.get("expr"), allow_func=allow_func)
    if t in ("AstExprIndexExpr", "AstExprIndexName"):
        base_ok = _is_pure_expr(node.get("expr"), allow_func=False)
        if t == "AstExprIndexName":
            return base_ok
        return base_ok and _is_pure_expr(node.get("index"), allow_func=False)
    if t == "AstExprUnary":
        return _is_pure_expr(node.get("expr"), allow_func=False)
    if t == "AstExprBinary":
        return _is_pure_expr(node.get("left"), allow_func=False) and _is_pure_expr(node.get("right"), allow_func=False)
    if t == "AstExprIfElse":
        return (_is_pure_expr(node.get("condition"))
                and _is_pure_expr(node.get("trueExpr"))
                and _is_pure_expr(node.get("falseExpr")))
    if t == "AstExprTable":
        return all(
            _is_pure_expr(it.get("value")) and (it.get("key") is None or _is_pure_expr(it.get("key")))
            for it in node.get("items", ())
        )
    if t == "AstExprCall" and not node.get("self"):
        nm = _dotted(node.get("func"))
        if nm in _PURE_CALLEES:
            args = node.get("args", ())
            if nm == "os.clock":
                return len(args) == 0
            if nm in ("type", "typeof", "select") and len(args) == 0:
                return False
            return all(_is_pure_expr(a) and a.get("type") != "AstExprVarargs" for a in args)
    return False


def _is_pure_arg_leaf(node):
    """Strict pure single-valued expression safe to drop from a call site."""
    if not isinstance(node, dict):
        return False
    t = node.get("type")
    if t in ("AstExprConstantNil", "AstExprConstantBool", "AstExprConstantNumber",
             "AstExprConstantString", "AstExprLocal"):
        return True
    if t == "AstExprUnary" and node.get("op") in ("Minus", "Not"):
        return _is_pure_arg_leaf(node.get("expr"))
    return False


def _apply_edits(btext, edits):
    if not edits:
        return btext
    # Sort descending by start offset; skip any edit that overlaps an already-accepted later edit
    ordered = sorted(edits, key=lambda x: (x[0], x[1]), reverse=True)
    accepted = []
    min_start = len(btext) + 1
    for s0, e0, repl in ordered:
        if 0 <= s0 <= e0 <= min_start:
            accepted.append((s0, e0, repl))
            min_start = s0
    chunks = []
    cur = len(btext)
    for s0, e0, repl in accepted:
        if not repl and btext[e0:e0 + 1] == b"(" and _separator_needed(btext, s0, e0):
            # Luau reads a `;` right before a `(` as the previous statement's
            # terminator, so a statement that had to be separated (`;(nil).x=1`
            # after a call) loses its separator when that previous statement is
            # deleted: the two lines would parse as one ambiguous call. Keep the
            # `;` when the deleted text ends on one.
            repl = b";"
        chunks.append(btext[e0:cur])
        chunks.append(repl)
        cur = s0
    chunks.append(btext[:cur])
    chunks.reverse()
    return b"".join(chunks)


def _separator_needed(btext, s0, e0):
    """Does deleting `btext[s0:e0]` have to keep its trailing `;`?

    The renderer separates a statement that opens with `(` from the one before
    it with a `;` of its own, because Luau refuses to guess whether `(...)` is a
    new statement or an argument list. Luau in turn reads that `;` as the
    *previous* statement's terminator, so an edit that deletes the previous
    statement takes the separator with it and the two lines become one
    ambiguous call. Keep it -- but only where a `;` may stand: as the first
    statement of a block it is not valid Luau, so a deleted first statement
    drops it (nothing precedes it, so nothing needs separating)."""
    stripped = btext[s0:e0].rstrip(b" \t\r\n")
    if not stripped.endswith(b";"):
        return False
    semi = s0 + len(stripped) - 1
    line_start = btext.rfind(b"\n", 0, semi) + 1
    if btext[line_start:semi].strip(b" \t"):
        return True                     # mid-line: a `;` there is always legal
    # only text outside the deleted range counts: when the previous statement
    # is what is being deleted, the `(` becomes the block's first statement
    prev = btext[:min(s0, line_start)].rstrip(b" \t\r\n")
    if not prev:
        return False                    # first statement of the file/block
    head = prev[prev.rfind(b"\n") + 1:].strip(b" \t")
    if head.startswith(b"--"):
        return False                    # a comment in the way: do not guess
    last = head.split()[-1]
    # `then do else repeat` and `end` cannot be called, so `(` after them is
    # already unambiguous; anything else may end a call.
    return last not in (b"then", b"do", b"else", b"repeat", b"end")


def _expand_full_line_delete(btext, s0, e0):
    """If `btext[s0:e0]` is the only content on its line(s), include leading
    indentation and trailing newline so no blank line is left behind."""
    ls = btext.rfind(b"\n", 0, s0)
    line_start = 0 if ls < 0 else ls + 1
    if btext[line_start:s0].strip(b" \t") != b"":
        return s0, e0
    le = btext.find(b"\n", e0)
    if le < 0:
        if btext[e0:].strip(b" \t\r") == b"":
            return line_start, len(btext)
        return s0, e0
    if btext[e0:le].strip(b" \t\r") == b"":
        return line_start, le + 1
    return s0, e0


def _eval_const_ast(node, env):
    """Exact constant evaluator for numeric/boolean/bit32 expressions under `env = {var_loc: val}`."""
    if not isinstance(node, dict):
        return None
    tp = node.get("type")
    if tp == "AstExprGroup":
        return _eval_const_ast(node.get("expr"), env)
    if tp == "AstExprConstantNumber":
        v = node.get("value")
        return int(v) if isinstance(v, float) and v.is_integer() else v
    if tp == "AstExprConstantBool":
        return bool(node.get("value"))
    if tp == "AstExprLocal":
        return env.get(node["local"]["location"])
    if tp == "AstExprUnary":
        v = _eval_const_ast(node.get("expr"), env)
        if v is None:
            return None
        op = node.get("op")
        if op == "Minus" and isinstance(v, (int, float)) and not isinstance(v, bool):
            return -v
        if op == "Not":
            return not bool(v)
        return None
    if tp == "AstExprBinary":
        op = node.get("op")
        lv = _eval_const_ast(node.get("left"), env)
        if lv is None:
            return None
        if op == "And":
            return _eval_const_ast(node.get("right"), env) if lv else lv
        if op == "Or":
            return lv if lv else _eval_const_ast(node.get("right"), env)
        rv = _eval_const_ast(node.get("right"), env)
        if rv is None:
            return None
        if op == "CompareEq":
            return lv == rv
        if op == "CompareNe":
            return lv != rv
        if isinstance(lv, (int, float)) and isinstance(rv, (int, float)) and not isinstance(lv, bool) and not isinstance(rv, bool):
            if op == "Add":
                return lv + rv
            if op == "Sub":
                return lv - rv
            if op == "Mul":
                return lv * rv
            if op == "Mod" and rv != 0:
                return lv % rv
            if op == "CompareLt":
                return lv < rv
            if op == "CompareLe":
                return lv <= rv
            if op == "CompareGt":
                return lv > rv
            if op == "CompareGe":
                return lv >= rv
        return None
    if tp == "AstExprCall" and not node.get("self"):
        nm = _dotted(node.get("func"))
        if nm and nm.startswith("bit32."):
            avs = [_eval_const_ast(a, env) for a in node.get("args", ())]
            if not avs or any(not isinstance(x, (int, float)) or isinstance(x, bool) for x in avs):
                return None
            ivs = [int(x) & 0xFFFFFFFF for x in avs]
            bop = nm.split(".", 1)[1]
            if bop == "bxor":
                r = 0
                for x in ivs:
                    r ^= x
                return r
            if bop == "band":
                r = 0xFFFFFFFF
                for x in ivs:
                    r &= x
                return r
            if bop == "bor":
                r = 0
                for x in ivs:
                    r |= x
                return r
            if bop == "bnot" and len(ivs) >= 1:
                return (~ivs[0]) & 0xFFFFFFFF
            if bop == "lshift" and len(ivs) >= 2 and 0 <= ivs[1] < 32:
                return (ivs[0] << ivs[1]) & 0xFFFFFFFF
            if bop == "rshift" and len(ivs) >= 2 and 0 <= ivs[1] < 32:
                return (ivs[0] >> ivs[1]) & 0xFFFFFFFF
    return None


def _mentions_vloc(node, vloc):
    if isinstance(node, dict):
        if node.get("type") == "AstExprLocal" and node["local"]["location"] == vloc:
            return True
        return any(_mentions_vloc(v, vloc) for v in node.values() if isinstance(v, (dict, list)))
    if isinstance(node, list):
        return any(_mentions_vloc(v, vloc) for v in node)
    return False


def _strip_unused_params_and_dead_locals(text):
    for _ in range(6):
        btext = text.encode("utf-8")
        starts = _line_starts(btext)
        root = _parse_ast(text)

        local_refs = {}       # var_loc -> list of AstExprLocal nodes
        callee_refs = {}      # id(AstExprLocal) -> enclosing non-self AstExprCall
        assign_lhs_refs = {}  # id(AstExprLocal) -> enclosing AstStatAssign
        local_decls = {}      # var_loc -> (AstStatLocal, idx)
        local_funcs = {}      # var_loc -> (stat, fn_node, "localfn" | "split")
        dead_stat_cands = []  # AstStatLocal with 1 var and <=1 pure value

        def walk(n):
            if isinstance(n, dict):
                tp = n.get("type")
                if tp == "AstExprLocal":
                    vloc = n["local"]["location"]
                    local_refs.setdefault(vloc, []).append(n)
                elif tp == "AstExprCall" and not n.get("self"):
                    fn = n.get("func")
                    if isinstance(fn, dict) and fn.get("type") == "AstExprLocal":
                        callee_refs[id(fn)] = n
                elif tp == "AstStatAssign":
                    for v in n.get("vars", ()):
                        if isinstance(v, dict) and v.get("type") == "AstExprLocal":
                            assign_lhs_refs[id(v)] = n
                elif tp == "AstStatLocal":
                    vs = n.get("vars", ())
                    vals = n.get("values", ())
                    for idx, v in enumerate(vs):
                        local_decls[v["location"]] = (n, idx)
                    if len(vs) == 1 and len(vals) <= 1:
                        dead_stat_cands.append(n)
                elif tp == "AstStatLocalFunction":
                    vloc = n["name"]["location"]
                    local_funcs[vloc] = (n, n["func"], "localfn")
                for v in n.values():
                    if isinstance(v, (dict, list)):
                        walk(v)
            elif isinstance(n, list):
                for v in n:
                    walk(v)

        walk(root)

        # Also recognize forward-declared local functions: `local f` ... `f = function(...) ... end`
        for vloc, (decl_st, idx) in local_decls.items():
            if vloc in local_funcs:
                continue
            vals = decl_st.get("values", ())
            init_v = vals[idx] if idx < len(vals) else None
            if init_v is not None and init_v.get("type") != "AstExprConstantNil":
                continue
            refs = local_refs.get(vloc, ())
            writes = [r for r in refs if id(r) in assign_lhs_refs]
            if len(writes) != 1:
                continue
            ast_assign = assign_lhs_refs[id(writes[0])]
            if len(ast_assign.get("vars", ())) != 1 or len(ast_assign.get("values", ())) != 1:
                continue
            rhs = ast_assign["values"][0]
            if rhs.get("type") == "AstExprFunction":
                local_funcs[vloc] = (ast_assign, rhs, "split")

        edits = []

        # 1a. State keys left behind by the devirtualizer: `local n` followed by
        # one `n = <number>` and never read anywhere. They are pure junk -- the
        # value only ever fed the VM's own dispatch -- so both statements go.
        writes_by_vloc = {}
        for vloc, refs in local_refs.items():
            sts = [assign_lhs_refs[id(r)] for r in refs if id(r) in assign_lhs_refs]
            if sts:
                writes_by_vloc[vloc] = sts

        dead_key_stmts = []
        for vloc, (decl_st, idx) in local_decls.items():
            if len(decl_st.get("vars", ())) != 1:
                continue
            vals = decl_st.get("values", ())
            init = vals[idx] if idx < len(vals) else None
            if init is not None and init.get("type") != "AstExprConstantNil":
                continue
            if any(id(r) not in assign_lhs_refs for r in local_refs.get(vloc, ())):
                continue
            writes = writes_by_vloc.get(vloc, ())
            if not writes:
                continue
            if any(len(w.get("vars", ())) != 1 or len(w.get("values", ())) != 1 for w in writes):
                continue
            if any(not _is_pure_expr(w["values"][0]) for w in writes):
                continue
            dead_key_stmts.append(decl_st)
            dead_key_stmts.extend(writes)

        for st in dead_key_stmts:
            s0, e0 = _loc_bytes(st["location"], starts)
            s0, e0 = _expand_full_line_delete(btext, s0, e0)
            edits.append((s0, e0, b""))

        # 1. Dead unread single-var pure `local x = ...` statements
        for st in dead_stat_cands:
            vloc = st["vars"][0]["location"]
            if local_refs.get(vloc):
                continue
            vals = st.get("values", ())
            if vals and not _is_pure_expr(vals[0], allow_func=True):
                continue
            s0, e0 = _loc_bytes(st["location"], starts)
            s0, e0 = _expand_full_line_delete(btext, s0, e0)
            edits.append((s0, e0, b""))

        # 2. Unused dummy parameters on private direct-call-only local functions
        for vloc, (def_st, fn_node, kind) in local_funcs.items():
            if fn_node.get("vararg"):
                continue
            params = fn_node.get("args", ())
            if not params:
                continue
            refs = local_refs.get(vloc, ())
            calls = []
            ok = True
            for r in refs:
                if kind == "split" and id(r) in assign_lhs_refs:
                    continue
                cnode = callee_refs.get(id(r))
                if cnode is None:
                    ok = False
                    break
                # Ensure parenthesized call syntax `f(...)`
                fn_s, fn_e = _loc_bytes(r["location"], starts)
                c_s, c_e = _loc_bytes(cnode["location"], starts)
                tail_slice = btext[fn_e:c_e].lstrip(b" \t")
                if not tail_slice.startswith(b"("):
                    ok = False
                    break
                calls.append(cnode)
            if not ok or not calls:
                continue

            cand_drop = []
            for pidx, p in enumerate(params):
                ploc = p["location"]
                prefs = local_refs.get(ploc)
                if prefs:
                    # Check if `p` is an unmutated Luraph state-key parameter (e.g. 147674248)
                    # passed identically at 100% of call sites and used ONLY in constant-foldable `if` conditions
                    if all(id(pr) not in assign_lhs_refs for pr in prefs):
                        const_vals = set()
                        all_const = True
                        for cnode in calls:
                            cargs = cnode.get("args", ())
                            if pidx >= len(cargs) or any(cargs[k].get("type") == "AstExprVarargs" for k in range(pidx + 1)):
                                all_const = False
                                break
                            ca = cargs[pidx]
                            if ca.get("type") == "AstExprConstantNumber" and abs(ca["value"]) >= 100000 and float(ca["value"]).is_integer():
                                const_vals.add(int(ca["value"]))
                            else:
                                all_const = False
                                break
                        if all_const and len(const_vals) == 1:
                            k_val = next(iter(const_vals))
                            if_hits = []

                            def find_ifs(n):
                                if isinstance(n, dict):
                                    if n.get("type") == "AstStatIf" and _mentions_vloc(n.get("condition"), ploc):
                                        if_hits.append(n)
                                    for v in n.values():
                                        if isinstance(v, (dict, list)):
                                            find_ifs(v)
                                elif isinstance(n, list):
                                    for v in n:
                                        find_ifs(v)

                            find_ifs(fn_node.get("body", {}))
                            cond_refs = sum(
                                sum(1 for pr in prefs if _loc_bytes(n["condition"]["location"], starts)[0] <= _loc_bytes(pr["location"], starts)[0]
                                    and _loc_bytes(pr["location"], starts)[1] <= _loc_bytes(n["condition"]["location"], starts)[1])
                                for n in if_hits
                            )
                            if if_hits and cond_refs == len(prefs):
                                for st_if in if_hits:
                                    cval = _eval_const_ast(st_if["condition"], {ploc: k_val})
                                    if cval is False:
                                        if_s, if_e = _loc_bytes(st_if["location"], starts)
                                        eb = st_if.get("elsebody")
                                        if eb is None:
                                            s0, e0 = _expand_full_line_delete(btext, if_s, if_e)
                                            edits.append((s0, e0, b""))
                                        elif eb.get("type") == "AstStatIf":
                                            eb_s, _ = _loc_bytes(eb["location"], starts)
                                            if btext[eb_s:eb_s + 6] == b"elseif":
                                                edits.append((if_s, eb_s + 6, b"if"))
                                            elif btext[eb_s:eb_s + 2] == b"if":
                                                edits.append((if_s, eb_s, b""))
                    continue
                # Check all call sites for parameter pidx
                p_ok = True
                for cnode in calls:
                    cargs = cnode.get("args", ())
                    if any(cargs[k].get("type") == "AstExprVarargs" for k in range(min(pidx + 1, len(cargs)))):
                        p_ok = False
                        break
                    if pidx < len(cargs) and not _is_pure_arg_leaf(cargs[pidx]):
                        p_ok = False
                        break
                if p_ok:
                    cand_drop.append(pidx)
            if not cand_drop:
                continue

            drop_set = set(cand_drop)
            # Multi-return tail guard: dropping trailing args must not expose an earlier Call/Varargs as the new last arg
            while drop_set:
                tail_hazard = False
                for cnode in calls:
                    cargs = cnode.get("args", ())
                    if not cargs:
                        continue
                    kept_c = [i for i in range(len(cargs)) if i not in drop_set]
                    if kept_c and kept_c[-1] != len(cargs) - 1:
                        if cargs[kept_c[-1]].get("type") in ("AstExprCall", "AstExprVarargs"):
                            # Keep the last argument of this call so `kept_c[-1]` stays truncated
                            drop_set.discard(len(cargs) - 1)
                            tail_hazard = True
                            break
                if not tail_hazard:
                    break
            if not drop_set:
                continue

            # Emit disjoint span deletions on `fn_node` params
            _emit_list_deletions(params, drop_set, starts, edits)
            # Emit disjoint span deletions on every call site's args
            for cnode in calls:
                cargs = cnode.get("args", ())
                c_drop = {i for i in drop_set if i < len(cargs)}
                if c_drop:
                    _emit_list_deletions(cargs, c_drop, starts, edits)

        if not edits:
            break
        text = _apply_edits(btext, edits).decode("utf-8")
    return text


def _emit_list_deletions(items, drop_set, starts, edits):
    m = len(items)
    if not m or not drop_set:
        return
    if len(drop_set) == m:
        s0, _ = _loc_bytes(items[0]["location"], starts)
        _, e0 = _loc_bytes(items[-1]["location"], starts)
        edits.append((s0, e0, b""))
        return
    i = 0
    while i < m:
        if i not in drop_set:
            i += 1
            continue
        j = i
        while j + 1 < m and (j + 1) in drop_set:
            j += 1
        if j + 1 < m:
            s0, _ = _loc_bytes(items[i]["location"], starts)
            s_next, _ = _loc_bytes(items[j + 1]["location"], starts)
            edits.append((s0, s_next, b""))
        else:
            _, e_prev = _loc_bytes(items[i - 1]["location"], starts)
            _, e0 = _loc_bytes(items[j]["location"], starts)
            edits.append((e_prev, e0, b""))
        i = j + 1


def _has_shallow_return(block_node):
    for st in block_node.get("body", ()):
        tp = st.get("type")
        if tp == "AstStatReturn":
            return True
        if tp == "AstStatBlock" and _has_shallow_return(st):
            return True
        if tp == "AstStatIf":
            if _has_shallow_return(st["thenbody"]):
                return True
            eb = st.get("elsebody")
            if eb:
                if eb.get("type") == "AstStatBlock" and _has_shallow_return(eb):
                    return True
                if eb.get("type") == "AstStatIf" and _has_shallow_return({"body": [eb]}):
                    return True
        if tp in ("AstStatWhile", "AstStatRepeat", "AstStatFor", "AstStatForIn"):
            if _has_shallow_return(st["body"]):
                return True
    return False


def _unwrap_top_level_iife(text):
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    root = _parse_ast(text)
    edits = []
    iife_idx = 0
    for st in root.get("body", ()):
        if st.get("type") != "AstStatExpr":
            continue
        ex = st.get("expr")
        if not (isinstance(ex, dict) and ex.get("type") == "AstExprCall"
                and not ex.get("self") and len(ex.get("args", ())) == 0):
            continue
        fn = ex.get("func")
        while isinstance(fn, dict) and fn.get("type") == "AstExprGroup":
            fn = fn.get("expr")
        if not (isinstance(fn, dict) and fn.get("type") == "AstExprFunction"
                and len(fn.get("args", ())) == 0 and not fn.get("vararg")):
            continue
        st_s, st_e = _loc_bytes(st["location"], starts)
        # Include any leading `;` on the same line right before `(`
        ls = btext.rfind(b"\n", 0, st_s)
        line_start = 0 if ls < 0 else ls + 1
        prefix_same_line = btext[line_start:st_s]
        if prefix_same_line.strip(b" \t") == b";":
            st_s = line_start + prefix_same_line.find(b";")

        body_node = fn["body"]
        if not body_node.get("body"):
            s0, e0 = _expand_full_line_delete(btext, st_s, st_e)
            edits.append((s0, e0, b""))
            continue

        b_s, b_e = _loc_bytes(body_node["location"], starts)
        # Match header `...(function()` up to first statement line and footer `end)()`
        head_chunk = btext[st_s:b_s]
        tail_chunk = btext[b_e:st_e]
        if not (re.match(rb"^;?\s*\(\s*function\s*\(\s*\)", head_chunk)
                and re.search(rb"end\s*\)\s*\(\s*\)\s*$", tail_chunk)):
            continue
        m_head = re.match(rb"^;?\s*\(\s*function\s*\(\s*\)", head_chunk)
        m_tail = re.search(rb"end\s*\)\s*\(\s*\)\s*$", tail_chunk)
        if not _has_shallow_return(body_node):
            edits.append((st_s, st_s + m_head.end(), b"do"))
            edits.append((b_e + m_tail.start(), st_e, b"end"))
        else:
            iife_idx += 1
            fn_name = b"initModule" if iife_idx == 1 else (b"initModule%d" % iife_idx)
            edits.append((st_s, st_s + m_head.end(), b"local function " + fn_name + b"()"))
            edits.append((b_e + m_tail.start(), st_e, b"end\n" + fn_name + b"()"))
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8")


def _has_ident_reference(node, ident_name):
    """Return True if subtree `node` contains any local or global reference to `ident_name`."""
    stk = [node]
    while stk:
        cur = stk.pop()
        if not isinstance(cur, dict):
            continue
        tp = cur.get("type")
        if tp == "AstExprLocal":
            loc_node = cur.get("local") or {}
            if loc_node.get("name") == ident_name:
                return True
        elif tp == "AstExprGlobal":
            if (cur.get("global") or cur.get("name")) == ident_name:
                return True
        for k, v in cur.items():
            if k == "local":
                continue
            if isinstance(v, dict):
                stk.append(v)
            elif isinstance(v, list):
                stk.extend(x for x in v if isinstance(x, dict))
    return False


def _sugar_local_functions(text):
    """Rewrite `local foo = function(...)` -> `local function foo(...)` when `foo`
    is not referenced inside its own initializer body (100% scope-equivalent)."""
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    root = _parse_ast(text)
    edits = []

    def walk_block(blk):
        for st in blk.get("body", ()):
            tp = st.get("type")
            if tp == "AstStatLocal":
                vars_ = st.get("vars") or ()
                vals = st.get("values") or ()
                if len(vars_) == 1 and len(vals) == 1 and vals[0].get("type") == "AstExprFunction":
                    vnode = vars_[0]
                    fn = vals[0]
                    nm = vnode.get("name") or ""
                    if nm and nm != "_" and not _has_ident_reference(fn.get("body"), nm):
                        st_s, _ = _loc_bytes(st["location"], starts)
                        fn_s, _ = _loc_bytes(fn["location"], starts)
                        prefix = btext[st_s:fn_s]
                        # Match exact `local <name> = function(` prefix
                        target_re = rb"^local\s+" + re.escape(nm.encode("utf-8")) + rb"\s*=\s*$"
                        if re.match(target_re, prefix) and btext[fn_s:fn_s + 8] == b"function":
                            edits.append((st_s, fn_s + 8, b"local function " + nm.encode("utf-8")))
                    walk_block(fn["body"])
                    continue
            for v in st.values():
                if isinstance(v, dict):
                    if v.get("type") == "AstStatBlock":
                        walk_block(v)
                    else:
                        walk_expr(v)
                elif isinstance(v, list):
                    for x in v:
                        if isinstance(x, dict):
                            if x.get("type") == "AstStatBlock":
                                walk_block(x)
                            else:
                                walk_expr(x)

    def walk_expr(ex):
        if ex.get("type") == "AstExprFunction":
            walk_block(ex["body"])
            return
        for v in ex.values():
            if isinstance(v, dict):
                if v.get("type") == "AstStatBlock":
                    walk_block(v)
                elif "type" in v:
                    walk_expr(v)
            elif isinstance(v, list):
                for x in v:
                    if isinstance(x, dict) and "type" in x:
                        walk_expr(x)

    walk_block(root)
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8")


def _collapse_single_packs(text):
    """`local p = table.pack(x)` + reads of `p[1]`/`p.n` -> `local p = x`.

    Luraph's uint32 helpers wrap every intermediate in a one-slot pack
    (`local n = table.pack(bit32.band(a, 65535))`), which hides the arithmetic
    behind table machinery. A one-slot pack of a value that is not a
    multi-value call is just that value, so the local can hold it directly.
    Scoped by the parser's own local identity, so a same-named local in
    another function is never touched."""
    root = _parse_ast(text)
    btext = text.encode("utf-8", "surrogateescape")
    starts = _line_starts(btext)

    def rng(node):
        return _loc_bytes(node["location"], starts)

    SINGLE = {"bit32", "math", "string"}

    def single_value(e):
        """Does this expression always produce exactly one value?"""
        if not isinstance(e, dict):
            return False
        t = e.get("type")
        if t in ("AstExprVarargs", "AstExprFunction"):
            return False
        if t != "AstExprCall":
            return True
        fn = e.get("func") or {}
        if fn.get("type") != "AstExprIndexName" or fn.get("op") != ".":
            return False
        base = fn.get("expr") or {}
        if base.get("type") != "AstExprGlobal" or base.get("global") not in SINGLE:
            return False
        return all(single_value(a) for a in (e.get("args") or ()))

    decls = {}
    uses = {}
    bad = set()

    def scan(n, parent=None, key=None):
        if not isinstance(n, dict):
            return
        t = n.get("type")
        if t == "AstStatLocal" and len(n.get("vars") or ()) == 1 and len(n.get("values") or ()) == 1:
            v = n["values"][0]
            loc = n["vars"][0]["location"]
            if (v.get("type") == "AstExprCall" and not v.get("self")
                    and v.get("func", {}).get("type") == "AstExprIndexName"
                    and v["func"].get("expr", {}).get("type") == "AstExprGlobal"
                    and v["func"]["expr"].get("global") == "table"
                    and v["func"].get("index") == "pack"
                    and len(v.get("args") or ()) == 1):
                arg = v["args"][0]
                if single_value(arg):
                    decls[loc] = (v, arg)
        if t == "AstExprLocal":
            loc = (n.get("local") or {}).get("location")
            ok = False
            if isinstance(parent, dict):
                pt = parent.get("type")
                if pt == "AstExprIndexExpr" and parent.get("expr") is n \
                        and (parent.get("index") or {}).get("type") == "AstExprConstantNumber" \
                        and parent["index"].get("value") == 1:
                    ok = True
                    uses.setdefault(loc, []).append(("index1", parent, n))
                elif pt == "AstExprIndexName" and parent.get("expr") is n \
                        and parent.get("index") == "n" and parent.get("op") == ".":
                    ok = True
                    uses.setdefault(loc, []).append(("n", parent, n))
            if not ok:
                bad.add(loc)
        if t in ("AstStatAssign", "AstStatCompoundAssign"):
            tgts = n.get("vars") or ([n.get("var")] if n.get("var") else [])
            for v in tgts:
                # anything the statement assigns into may be mutated, so every
                # local on the left-hand side is off limits
                stack = [v]
                while stack:
                    cur = stack.pop()
                    if isinstance(cur, dict):
                        if cur.get("type") == "AstExprLocal":
                            bad.add((cur.get("local") or {}).get("location"))
                        stack.extend(x for x in cur.values() if isinstance(x, (dict, list)))
                    elif isinstance(cur, list):
                        stack.extend(cur)
        for k, v in n.items():
            if isinstance(v, dict):
                scan(v, n, k)
            elif isinstance(v, list):
                for x in v:
                    scan(x, n, k)
        if key is not None and isinstance(n, dict):
            pass

    scan(root)
    edits = []
    for loc, (call, arg) in decls.items():
        if loc in bad or loc not in uses:
            continue
        s0, e0 = rng(arg)
        cs, ce = rng(call)
        # Strip only the `table.pack(` prefix and the closing paren: the
        # argument may itself contain rewrites, and an edit that spans it
        # would swallow them.
        edits.append((cs, s0, b""))
        edits.append((e0, ce, b""))
        for kind, node, self_node in uses[loc]:
            us, ue = rng(node)
            if kind == "n":
                edits.append((us, ue, b"1"))
            else:
                ns, ne = rng(self_node)
                edits.append((us, ue, btext[ns:ne]))
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8", "surrogateescape")

def _merge_local_decls(text):
    """`local x` immediately followed by `x = expr` is one statement: fold the
    first assignment into the declaration. Only adjacent pairs are touched, so
    nothing is evaluated earlier than it was."""
    try:
        root = _parse_ast(text)
    except Exception:
        return text
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    edits = []

    def rng(node):
        return _loc_bytes(node["location"], starts)

    def visit_block(blk):
        body = blk.get("body") or []
        for i, st in enumerate(body[:-1]):
            if st.get("type") != "AstStatLocal":
                continue
            vars_ = st.get("vars") or []
            vals = st.get("values") or []
            if len(vars_) != 1 or len(vals) > 1:
                continue
            if vals and vals[0].get("type") != "AstExprConstantNil":
                continue
            nxt = body[i + 1]
            if nxt.get("type") != "AstStatAssign":
                continue
            avars = nxt.get("vars") or []
            avals = nxt.get("values") or []
            if len(avars) != 1 or len(avals) != 1:
                continue
            if avars[0].get("type") != "AstExprLocal":
                continue
            if avars[0]["local"]["location"] != vars_[0]["location"]:
                continue
            value = avals[0]
            if value.get("type") == "AstExprFunction":
                continue
            vs, ve = rng(value)
            name_s, name_e = rng(vars_[0])
            ds, de = rng(st)
            as0, ae0 = rng(nxt)
            as0, ae0 = _expand_full_line_delete(btext, as0, ae0)
            # keep the indentation of the declaration line
            line_start = btext.rfind(b"\n", 0, ds) + 1
            indent = btext[line_start:ds]
            new_decl = indent + b"local " + btext[name_s:name_e] + b" = " + btext[vs:ve]
            edits.append((ds, de, new_decl))
            edits.append((as0, ae0, b""))
        for st in body:
            if isinstance(st, dict):
                for k, v in st.items():
                    if k == "body" and isinstance(v, dict) and v.get("type") == "AstStatBlock":
                        visit_block(v)
                    elif isinstance(v, dict):
                        _walk_blocks(v)
                    elif isinstance(v, list):
                        for item in v:
                            if isinstance(item, dict):
                                _walk_blocks(item)

    def _walk_blocks(node):
        if not isinstance(node, dict):
            return
        if node.get("type") == "AstStatBlock":
            visit_block(node)
            return
        for v in node.values():
            if isinstance(v, dict):
                _walk_blocks(v)
            elif isinstance(v, list):
                for item in v:
                    if isinstance(item, dict):
                        _walk_blocks(item)

    _walk_blocks(root)
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8", "surrogateescape")


SAFE_CALL_LIBS = {"bit32", "math", "table", "string"}
SAFE_TABLE_FNS = {"pack", "unpack", "create", "move", "concat"}
SAFE_MATH_FNS = {"floor", "ceil", "abs", "min", "max", "sqrt", "fmod"}


def _is_inert_expr(node):
    """True for an expression that cannot fail and has no effect on the world.

    Deliberately narrow: literals, locals, arithmetic/bit32 on those, and the
    handful of library calls that only do arithmetic. Anything else (an index, a
    user call, a metatable op) can raise or mutate, so it does not qualify.
    """
    if not isinstance(node, dict):
        return False
    t = node.get("type")
    if t in ("AstExprConstantNil", "AstExprConstantBool", "AstExprConstantNumber",
             "AstExprConstantString", "AstExprLocal"):
        return True
    if t in ("AstExprGroup",):
        return _is_inert_expr(node.get("expr"))
    if t == "AstExprUnary":
        return _is_inert_expr(node.get("expr"))
    if t == "AstExprBinary":
        return _is_inert_expr(node.get("left")) and _is_inert_expr(node.get("right"))
    if t in ("AstExprIndexExpr", "AstExprIndexName"):
        # Reading a slot of a value we already hold cannot observe anything but
        # the slot, and this only ever runs on code that ends at a marker anyway
        # (see _trim_dead_stub_bodies): the difference is which error is raised,
        # not whether one is.
        base = node.get("expr")
        if not _is_inert_expr(base):
            return False
        return True if t == "AstExprIndexName" else _is_inert_expr(node.get("index"))
    if t == "AstExprCall":
        f = node.get("func") or {}
        if f.get("type") != "AstExprIndexName" or (f.get("expr") or {}).get("type") != "AstExprGlobal":
            return False
        lib, fn = f["expr"].get("global"), f.get("index")
        if lib == "bit32":
            return all(_is_inert_expr(a) for a in node.get("args") or [])
        if lib == "math" and fn in SAFE_MATH_FNS:
            return all(_is_inert_expr(a) for a in node.get("args") or [])
        if lib == "table" and fn == "pack":
            return all(_is_inert_expr(a) for a in node.get("args") or [])
        if lib == "string" and fn in ("format", "rep"):
            return all(_is_inert_expr(a) for a in node.get("args") or [])
        return False
    return False


def _is_devirt_marker(node):
    """`error("devirt: ...")` -- this tool's own "could not lift this" marker."""
    if not isinstance(node, dict):
        return False
    if node.get("type") == "AstStatExpr":            # how luau-ast spells a call statement
        node = node.get("expr") or {}
    if node.get("type") != "AstExprCall":
        return False
    f = node.get("func") or {}
    if f.get("type") != "AstExprGlobal" or f.get("global") != "error":
        return False
    args = node.get("args") or []
    if not args or args[0].get("type") != "AstExprConstantString":
        return False
    return args[0].get("value", "").startswith("devirt: ")


def _marker_shaped(node):
    """A statement whose only action is to raise this tool's marker.

    The marker often arrives wrapped in the dead branch the walk was deciding
    on (`if <inert> then error("devirt: ...") end`), so look through an if whose
    condition cannot fail, and through a plain do-block.
    """
    if not isinstance(node, dict):
        return False
    if _is_devirt_marker(node):
        return True
    t = node.get("type")
    if t == "AstStatIf":
        if not _is_inert_expr(node.get("condition")):
            return False

        def all_markers(blk):
            body = (blk or {}).get("body") or []
            return all(_marker_shaped(st) for st in body)
        then_ok = all_markers(node.get("thenbody"))
        else_body = node.get("elsebody")
        return then_ok and (else_body is None or all_markers(else_body))
    if t == "AstStatBlock":
        return all(_marker_shaped(st) for st in node.get("body") or [])
    return False


# What `_trim_dead_stub_bodies` removes, as (where, lines) pairs, so it can be
# written next to the result instead of disappearing. Set TRIM_PATH to a file
# path and the pass appends to it; the output itself stays clean.
TRIMMED = []
TRIM_PATH = None


def _record_trim(where, chunk):
    TRIMMED.append((where, chunk))
    if not TRIM_PATH:
        return
    try:
        with open(TRIM_PATH, "a", encoding="utf-8", newline="\n") as fh:
            fh.write("-- %s\n" % where)
            fh.write(chunk if chunk.endswith("\n") else chunk + "\n")
            fh.write("\n")
    except OSError:
        pass


def _trim_dead_stub_bodies(text):
    """Drop the bookkeeping a function does before it reaches its own marker.

    When the walk gives up part way through a function it leaves the marker
    `error("devirt: ...")` at the point where it stopped, with everything it did
    lift in front of it. That code runs and then raises -- unless it is inert, in
    which case nothing observable happens before the raise and the whole prefix
    can go. SampleV1 carried 2000 lines of cipher arithmetic in exactly this
    position, all of it dead.
    """
    try:
        root = _parse_ast(text)
    except Exception:
        return text
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    edits = []

    def rng(node):
        return _loc_bytes(node["location"], starts)

    def inert_stmt(st):
        t = st.get("type")
        if t == "AstStatLocal":
            return all(_is_inert_expr(v) for v in st.get("values") or [])
        if t == "AstStatAssign":
            return all(v.get("type") == "AstExprLocal" for v in st.get("vars") or []) \
                and all(_is_inert_expr(v) for v in st.get("values") or [])
        return False

    # A region is only dead if nothing unresolved reads out of it: a capture the
    # walk could not follow may hold a value this "inert" run produced, in which
    # case the run is the only way that value ever reaches the script.
    unresolved = [m.group(0).encode() for m in UNRESOLVED_CAPTURE.finditer(text)]

    def mentions_unresolved(node):
        if not unresolved:
            return False
        try:
            a, b = rng(node)
        except Exception:
            return True                     # cannot prove it dead: keep it
        chunk = btext[a:b]
        return any(re.search(rb"\b" + re.escape(nm) + rb"\b", chunk) for nm in unresolved)

    def visit(node):
        if not isinstance(node, dict):
            return
        if node.get("type") == "AstStatBlock":
            body = node.get("body") or []
            first_marker = next((i for i, st in enumerate(body) if _marker_shaped(st)), None)
            if first_marker is not None:
                # The dead part is the *trailing* run of inert statements just
                # before the marker (the cipher arithmetic the walk got through
                # before it stopped). Real work earlier in the body stays.
                start = first_marker
                while start > 0 and inert_stmt(body[start - 1]):
                    start -= 1
                if start < first_marker and any(mentions_unresolved(st) for st in body[start:first_marker]):
                    # the run feeds a value the trace lost: keep it, it is not dead
                    start = first_marker
                if start < first_marker:
                    s0, _ = rng(body[start])
                    ms, _ = rng(body[first_marker])
                    ls = btext.rfind(b"\n", 0, s0) + 1
                    ml = btext.rfind(b"\n", 0, ms) + 1
                    if btext[ls:s0].strip(b" \t") == b"" and btext[ml:ms].strip(b" \t") == b"":
                        edits.append((ls, ml, b""))
                        _record_trim("inert run before a devirt marker (lines %d-%d of the lift)"
                                     % (btext.count(b"\n", 0, ls) + 1, btext.count(b"\n", 0, ml)),
                                     btext[ls:ml].decode("utf-8", "surrogateescape"))
                for st in body[first_marker + 1:]:
                    if _marker_shaped(st):
                        continue
                    s0, e0 = rng(st)
                    s0, e0 = _expand_full_line_delete(btext, s0, e0)
                    edits.append((s0, e0, b""))
        for v in node.values():
            if isinstance(v, dict):
                visit(v)
            elif isinstance(v, list):
                for item in v:
                    if isinstance(item, dict):
                        visit(item)

    visit(root)
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8", "surrogateescape")


def _replace_error_markers(text):
    """A marker is a note in the output, not a landmine in it.

    `error("devirt: ...")` stops the whole script at the first place the walk
    could not follow -- including the hundreds of statements after it that were
    lifted fine. The same sentence as a `-- devirt: ...` comment keeps the hole
    visible (and countable, which is what this engine's gate measures) while
    letting the rest of the script run. Nothing is invented: the statements that
    could not be lifted are still missing, and still say so.
    """
    def repl(m):
        msg = m.group(1)
        indent = m.group("indent")
        return "%s-- %s" % (indent, msg)
    pat = re.compile(r'^(?P<indent>[ \t]*)error\("(devirt:[^"]*)"\)\s*$', re.M)
    return pat.sub(repl, text)


DEGENERATE_WRITE = re.compile(
    r"^[ \t]*;?[ \t]*\(nil\)(?:\.\w+|\[[^\]]*\])(?:\s*=\s*[^\n]*)?\s*$", re.M)


def _drop_degenerate_writes(text):
    """`(nil).reason = nil` is what an undecoded register index leaves behind.

    It parses, it is not the script, and running it raises. Drop the write and
    leave one comment where it was: the value that should have been written is
    the same value the marker above it says is missing.
    """
    def repl(m):
        indent = re.match(r"[ \t]*", m.group(0)).group(0)
        return indent + "-- devirt: dropped a write through an undecoded register"
    return DEGENERATE_WRITE.sub(repl, text)


def _mark_truncated_loops(text):
    """An empty `while true do` is not source: it spins forever.

    This is the net for text the renderer did not produce -- `codegen.Lower.loop`
    already turns such a loop into the same marker where it knows why the body
    came out empty (every statement in it wrote a value nothing reads). What is
    left here is a loop with no decoded statements at all. Either way the honest
    replacement is a hole that says what it is and does not run: the body is
    unknown, so inventing one would be worse than admitting it, and raising
    would take the whole script down at the first such point. A `-- devirt: ...`
    comment is also countable, which is what the gate for this engine is.
    """
    try:
        root = _parse_ast(text)
    except Exception:
        return text
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    edits = []
    marker = b'-- devirt: spin loop left out (it decoded to no statements)'

    def visit(node):
        if not isinstance(node, dict):
            return
        if node.get("type") == "AstStatWhile":
            cond = node.get("condition") or {}
            body = (node.get("body") or {}).get("body") or []
            always = cond.get("type") == "AstExprConstantBool" and cond.get("value") is True
            if always and not body:
                s0, e0 = _loc_bytes(node["location"], starts)
                ls = btext.rfind(b"\n", 0, s0) + 1
                if btext[ls:s0].strip(b" \t") == b"":
                    edits.append((ls, e0, btext[ls:s0] + marker))
        for v in node.values():
            if isinstance(v, dict):
                visit(v)
            elif isinstance(v, list):
                for item in v:
                    if isinstance(item, dict):
                        visit(item)

    visit(root)
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8", "surrogateescape")


def _declare_unresolved_captures(text):
    """Declare the upvalue names the lifter could not resolve.

    When a lifted function reaches a captured value that was passed through a
    scope the walk did not follow, the lifter has no name for it and falls back
    to `upv<slot>`. Those names were used but never declared, so the output read
    them as globals -- silently, and with a name no script has. Declaring them
    says what they are: values this walk could not follow.
    """
    names_used = []
    seen = set()
    for m in UNRESOLVED_CAPTURE.finditer(text):
        nm = m.group(0)
        if nm not in seen:
            seen.add(nm)
            names_used.append(nm)
    if not names_used:
        return text

    declared = set()
    for m in re.finditer(r"^\s*local\s+([\w\s,]+?)(?:\s*=|\s*$)", text, re.M):
        for nm in m.group(1).split(","):
            declared.add(nm.strip())
    for m in re.finditer(r"^\s*(?:local\s+)?function\s+(\w+)", text, re.M):
        declared.add(m.group(1))
    free = [f"unresolvedCapture{i + 1}" for i, nm in enumerate(names_used) if nm not in declared]
    if not free:
        return text

    body = text
    for i, nm in enumerate(names_used):
        if nm in declared:
            continue
        body = re.sub(r"\b%s\b" % re.escape(nm), "unresolvedCapture%d" % (i + 1), body)

    decl = ["-- unresolved: %d captured values the walk could not follow across scopes."
            % len(free),
            "-- They are nil here, so a function that needs one stops where the",
            "-- original had a value; each use below says what shape it expected."]
    for i in range(0, len(free), 6):
        # one `local` per line: a bare newline inside a name list is not a
        # continuation in Lua, and repeating `local` with disjoint names is valid
        decl.append("local " + ", ".join(free[i:i + 6]))
    header = "\n".join(decl) + "\n\n"
    lines = body.split("\n")
    at = 0
    while at < len(lines) and (lines[at].startswith("--") or not lines[at].strip()):
        at += 1
    return "\n".join(lines[:at] + header.rstrip("\n").split("\n") + [""] + lines[at:])


UNRESOLVED_USE = re.compile(r"\b(unresolvedCapture\d+)\b")


def _use_hint(line, name):
    """What the code does with `name` on this line -- the closest thing to a
    type the trace still has. Never a guess at the value, only at its shape."""
    rest = line
    kind = []
    if re.search(r"\b%s\s*\(" % re.escape(name), rest):
        kind.append("callable")
    if re.search(r"\b%s\s*[.\[]" % re.escape(name), rest):
        kind.append("table")
    if re.search(r"\b%s\s*(\.\.|[-+*/%%^])" % re.escape(name), rest) or \
            re.search(r"(\.\.|[-+*/%%^])\s*\b%s\b" % re.escape(name), rest):
        kind.append("number")
    if re.search(r"\b(?:tostring|format)\s*\([^)]*\b%s\b" % re.escape(name), rest):
        kind.append("string")
    if re.search(r"\b%s\s*==\s*[\"']" % re.escape(name), rest) or \
            re.search(r"[\"']\s*==\s*\b%s\b" % re.escape(name), rest):
        kind.append("string")
    if re.search(r"\b(?:typeof|type)\s*\(\s*%s\s*\)" % re.escape(name), rest):
        kind.append("checked")
    return "? ".join(kind) if kind else "unknown"


def _hint_unresolved_captures(text):
    """Say, at every use, what the code expects the lost value to be.

    `unresolvedCapture7()` with nothing else told the reader it was a global
    that happens to be nil. The call tells us it was a function; the index tells
    us it was a table. Those hints come from the line itself, so they are a fact
    about the script, not an invented value.
    """
    out = []
    decl_only = re.compile(r"^\s*local\s+[A-Za-z_0-9\s,]+$")
    for line in text.split("\n"):
        m = UNRESOLVED_USE.search(line)
        if not m or line.lstrip().startswith("--") or decl_only.match(line.split("--", 1)[0].rstrip()):
            out.append(line)
            continue
        code = line.split("--", 1)[0]
        names = []
        for mm in UNRESOLVED_USE.finditer(code):
            if mm.group(1) not in names:
                names.append(mm.group(1))
        hints = ", ".join("#%s %s" % (nm.replace("unresolvedCapture", ""), _use_hint(code, nm))
                          for nm in names)
        note = "  -- unresolved: " + hints
        if _line_can_take_comment(code):
            out.append(line.rstrip() + note)
        else:
            # the statement runs on: put the hint above it, at the same indent
            indent = line[:len(line) - len(line.lstrip())]
            out.append(indent + "-- unresolved: " + hints)
            out.append(line)
    return "\n".join(out)


def _line_can_take_comment(code):
    """A trailing `-- ...` is only safe where the statement ends on this line."""
    code = code.rstrip()
    if not code:
        return False
    if re.search(r"(?:[-+*/%^=<>~.,]|\band|\bor\b|\bnot\b|\bthen|\bdo|\belse|\bin\b)\s*$", code):
        return False
    depth = 0
    for ch in code:
        if ch in "([{":
            depth += 1
        elif ch in ")]}":
            depth -= 1
    return depth == 0


def _split_single_value_locals(text):
    """`local a, b = expr` reads as two values and is not one.

    It comes from the VM writing one register into two slots. The extra names
    are nil until something assigns them, so spelling it out says that:

        local a = expr
        local b

    Calls and `...` are left alone: those really do produce several values.
    """
    try:
        root = _parse_ast(text)
    except Exception:
        return text
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    edits = []

    def walk(node, seen):
        if not isinstance(node, dict) or id(node) in seen:
            return
        seen.add(id(node))
        if node.get("type") == "AstStatBlock":
            for st in node.get("body") or []:
                if not isinstance(st, dict) or st.get("type") != "AstStatLocal":
                    continue
                vars_ = st.get("vars") or []
                vals = st.get("values") or []
                if len(vars_) < 2 or len(vals) != 1:
                    continue
                if vals[0].get("type") in ("AstExprCall", "AstExprVarargs"):
                    continue
                s0, e0 = _loc_bytes(st["location"], starts)
                ls = btext.rfind(b"\n", 0, s0) + 1
                indent = btext[ls:s0]
                s0, e0 = _expand_full_line_delete(btext, s0, e0)
                ls = s0
                vs, ve = _loc_bytes(vars_[0]["location"], starts)
                fs, fe = _loc_bytes(vals[0]["location"], starts)
                rest = [btext[_loc_bytes(v["location"], starts)[0]:_loc_bytes(v["location"], starts)[1]]
                        for v in vars_[1:]]
                new = (indent + b"local " + btext[vs:ve] + b" = " + btext[fs:fe] + b"\n" +
                       indent + b"local " + b", ".join(rest) + b"\n")
                edits.append((ls, e0, new))
        for v in node.values():
            if isinstance(v, dict):
                walk(v, seen)
            elif isinstance(v, list):
                for item in v:
                    walk(item, seen)

    walk(root, set())
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8", "surrogateescape")


def _tidy_blank_lines(text):
    """No blank line where a block opens or closes.

    Everything else in the output is placed deliberately; a blank line right
    after `then` or right before `end` is only ever left over from a statement
    that was removed.
    """
    opener = re.compile(r"\b(then|do|else|repeat)\s*$")
    closer = re.compile(r"^\s*(end|else|elseif\b|until\b)")
    lines = text.split("\n")
    out = []
    for i, line in enumerate(lines):
        if line.strip() == "" and out:
            prev = out[-1]
            nxt = next((l for l in lines[i + 1:] if l.strip() != ""), "")
            if opener.search(prev) or closer.match(nxt or "end"):
                continue
        if line.strip() == "" and not out:
            continue
        out.append(line)
    while out and not out[-1].strip():
        out.pop()
    return "\n".join(out) + "\n"


def _empty_block(node):
    return isinstance(node, dict) and node.get("type") == "AstStatBlock" and not (node.get("body") or [])


def _drop_empty_branches(text):
    """Remove the branches that do nothing.

    The structurer keeps the shape of the VM's dispatch, so it produces a lot of
    `else end`, `do end` and `if C then else <body> end`. None of that is source
    anybody wrote, and all of it can go without changing behaviour: an empty
    `else` and an empty `do` block are no-ops, `if C then else B end` is
    `if not C then B end`, and `if C then end` on its own is a no-op.
    """
    try:
        root = _parse_ast(text)
    except Exception:
        return text
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    edits = []

    def rng(node):
        return _loc_bytes(node["location"], starts)

    def drop_stmt(node):
        s0, e0 = rng(node)
        edits.append(_expand_full_line_delete(btext, s0, e0) + (b"",))

    def handle_body(body):
        for st in body:
            if not isinstance(st, dict):
                continue
            if _empty_block(st):
                drop_stmt(st)                                   # bare `do end`
                continue
            if st.get("type") != "AstStatIf":
                continue
            then_empty = _empty_block(st.get("thenbody"))
            els = st.get("elsebody")
            els_empty = els is None or _empty_block(els)
            if els is None and then_empty:
                if _is_inert_expr(st.get("condition")):
                    drop_stmt(st)
            elif els is not None and els_empty and not then_empty:
                # keep the then-branch, drop "else" and the empty block after it
                _, ts = rng(st["thenbody"])
                _, te = rng(st["elsebody"])
                edits.append((ts, te, b""))
            elif then_empty and not els_empty and els.get("type") == "AstStatBlock":
                # `if C then else B end` -> `if not (C) then B end`
                cs, ce = rng(st["condition"])
                edits.append((cs, cs, b"not ("))
                edits.append((ce, ce, b")"))
                _, ts = rng(st["thenbody"])
                es, _ = rng(st["elsebody"])
                edits.append((ts, es, b""))

    def walk(node, seen):
        if not isinstance(node, dict):
            return
        if id(node) in seen:
            return
        seen.add(id(node))
        if node.get("type") == "AstStatBlock":
            handle_body(node.get("body") or [])
        for v in node.values():
            if isinstance(v, dict):
                walk(v, seen)
            elif isinstance(v, list):
                for item in v:
                    walk(item, seen)

    walk(root, set())
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8", "surrogateescape")


def polish_ast(text):
    text = _strip_unused_params_and_dead_locals(text)
    text = _unwrap_top_level_iife(text)
    text = _sugar_local_functions(text)
    try:
        text = _merge_local_decls(text)
    except Exception as ex:                        # never lose a working output
        print("[!] local merge pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _trim_dead_stub_bodies(text)
    except Exception as ex:                        # never lose a working output
        print("[!] dead stub trim pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _split_single_value_locals(text)
    except Exception as ex:                        # never lose a working output
        print("[!] single-value local pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _drop_empty_branches(text)
    except Exception as ex:                        # never lose a working output
        print("[!] empty branch pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _tidy_blank_lines(text)
    except Exception as ex:                        # never lose a working output
        print("[!] blank line pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _declare_unresolved_captures(text)
    except Exception as ex:                        # never lose a working output
        print("[!] unresolved capture pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _hint_unresolved_captures(text)
    except Exception as ex:                        # never lose a working output
        print("[!] unresolved hint pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _replace_error_markers(text)
    except Exception as ex:                        # never lose a working output
        print("[!] marker comment pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _drop_degenerate_writes(text)
    except Exception as ex:                        # never lose a working output
        print("[!] degenerate write pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _mark_truncated_loops(text)
    except Exception as ex:                        # never lose a working output
        print("[!] truncated loop pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _collapse_single_packs(text)
    except Exception as ex:                        # never lose a working output
        print("[!] single-slot pack pass failed: %s" % ex, file=sys.stderr)
    if not os.environ.get("DEVIRT_NO_BITFOLD"):
        try:
            # an unrolled checksum is one operation written out N times; fold it
            # back into a loop so the reader sees the operation, not the unrolling
            import bitfold
            text = bitfold.fold_chains(text)
        except Exception as ex:                    # never lose a working output
            print("[!] bit32 chain fold pass failed: %s" % ex, file=sys.stderr)
    return text
