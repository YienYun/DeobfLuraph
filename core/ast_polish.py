import json
import os
import re
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
        chunks.append(btext[e0:cur])
        chunks.append(repl)
        cur = s0
    chunks.append(btext[:cur])
    chunks.reverse()
    return b"".join(chunks)


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


def polish_ast(text):
    text = _strip_unused_params_and_dead_locals(text)
    text = _unwrap_top_level_iife(text)
    return text
