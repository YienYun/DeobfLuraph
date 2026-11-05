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


# Initial values that cost nothing to skip: a literal, or another local the
# declaration was copying. A field read or a call is not in this set -- those
# can raise, so the slot has to stay.
_FREE_SLOT_VALUES = ("AstExprConstantNil", "AstExprConstantBool",
                     "AstExprConstantNumber", "AstExprConstantString",
                     "AstExprLocal")


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

        # 1b. Dead slots inside a shared declaration. The seed cleanup empties one
        # value of `local a, b = nil, os.clock()` and leaves the name behind; the
        # slot is not a register the script uses, so the name goes with the value.
        # Only slots carrying nothing or a literal move, so no call is lost.
        dead_slots = {}
        for vloc, (decl_st, idx) in local_decls.items():
            vs = decl_st.get("vars", ())
            if len(vs) < 2 or local_refs.get(vloc):
                continue
            vals = decl_st.get("values", ())
            if idx < len(vals) and (vals[idx].get("type") or "") not in _FREE_SLOT_VALUES:
                continue
            dead_slots.setdefault(id(decl_st), (decl_st, set()))[1].add(idx)

        for decl_st, drop_set in dead_slots.values():
            vs = decl_st.get("vars", ())
            vals = decl_st.get("values", ())
            keep = [i for i in range(len(vs)) if i not in drop_set]
            s0, e0 = _loc_bytes(decl_st["location"], starts)
            if not keep:
                s0, e0 = _expand_full_line_delete(btext, s0, e0)
                edits.append((s0, e0, b""))
                continue
            names = b", ".join(btext[slice(*_loc_bytes(vs[i]["location"], starts))] for i in keep)
            live_vals = [i for i in keep if i < len(vals)]
            if live_vals:
                values = b", ".join(btext[slice(*_loc_bytes(vals[i]["location"], starts))]
                                    for i in live_vals)
                edits.append((s0, e0, b"local " + names + b" = " + values))
            else:
                edits.append((s0, e0, b"local " + names))

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
            # Not every pair folds. `local t` / `t = { ... t ... }` is the one
            # shape that cannot: inside its own initialiser the name is not in
            # scope yet, so those reads are globals. Folding rewrote a working
            # self-referential table into reads of a nil global.
            if _has_ident_reference(value, vars_[0]["name"]):
                continue
            vs, ve = rng(value)
            name_s, name_e = rng(vars_[0])
            ds, de = rng(st)
            as0, ae0 = rng(nxt)
            as0, ae0 = _expand_full_line_delete(btext, as0, ae0)
            # the declaration's own indentation is already in front of `ds`; emit
            # only the statement, or the merge would double it
            new_decl = b"local " + btext[name_s:name_e] + b" = " + btext[vs:ve]
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
        # group 2 is the message; group 1 is the indent, and reading it here
        # turned every marker into `-- <tabs>` -- a hole with no explanation.
        msg = m.group(2)
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


# `variables.rename` splits a register into one variable per web, so a
# leftover can be plain (`r6`) or suffixed (`r6_2`).
REG_LEFTOVER = re.compile(r"r\d+(?:_\d+)?")
LOC_RE = re.compile(r"(\d+),(\d+) - (\d+),(\d+)$")


def _declare_unresolved_registers(text):
    """Declare the register names the lift left behind.

    A state machine block that read a register inside the loop it belonged to can
    end up outside that loop once the CFG is structured again. The read survives
    as `tostring(r6)` while the store that defined register 6 stayed behind, so
    nothing declares the name -- and an undeclared name in Luau is a global read,
    silently nil. The value is nil either way, but a global no script has is not
    something a reader can tell apart from a bug in the output, so declare it.

    The parser decides what is a hole: only a name the chunk reads as a *global*
    counts, so a closure parameter legitimately called `r1` in one function is
    never touched, and a hole in another function is never hidden by it.
    """
    if not REG_LEFTOVER.search(text):
        return text
    try:
        root = _parse_ast(text)
    except Exception:
        return text

    reads, writes = [], set()

    def walk(node):
        if isinstance(node, dict):
            t = node.get("type") or ""
            if t == "AstExprGlobal":
                nm = node.get("global") or ""
                if REG_LEFTOVER.fullmatch(nm):
                    reads.append((nm, node.get("location") or ""))
            elif t in ("AstStatAssign", "AstStatCompoundAssign"):
                for var in node.get("vars") or []:
                    if isinstance(var, dict) and var.get("type") == "AstExprGlobal" \
                            and REG_LEFTOVER.fullmatch(var.get("global") or ""):
                        writes.add(var["global"])
            for k, v in node.items():
                if k != "location":
                    walk(v)
        elif isinstance(node, list):
            for x in node:
                walk(x)

    walk(root)

    holes = []
    for nm, loc in reads:
        if nm in writes:
            continue                       # the script assigns it: a real global
        m = LOC_RE.search(loc)
        if not m:
            continue
        holes.append((int(m.group(1)), int(m.group(2)), int(m.group(4)), nm))
    if not holes:
        return text

    holes.sort()
    alias = {}
    for _ln, _c0, _c1, nm in holes:
        if nm not in alias:
            alias[nm] = "unresolvedRegister%d" % (len(alias) + 1)

    lines = text.split("\n")
    for ln, c0, c1, nm in sorted(holes, reverse=True):
        if 0 <= ln < len(lines) and lines[ln][c0:c1] == nm:
            lines[ln] = lines[ln][:c0] + alias[nm] + lines[ln][c1:]
    text = "\n".join(lines)

    n = len(alias)
    decl = ["-- unresolved: %d register name%s the lift never declares; %s nil, so a"
            % (n, "" if n == 1 else "s", "it reads as" if n == 1 else "they read as"),
            "-- value the original held is missing where %s used."
            % ("it is" if n == 1 else "they are"),
            "-- Each use below says what shape that value had."]
    names = sorted(alias.values())
    for i in range(0, len(names), 6):
        decl.append("local " + ", ".join(names[i:i + 6]))
    header = "\n".join(decl) + "\n\n"
    lines = text.split("\n")
    at = 0
    while at < len(lines) and (lines[at].startswith("--") or not lines[at].strip()):
        at += 1
    return "\n".join(lines[:at] + header.rstrip("\n").split("\n") + [""] + lines[at:])


UNRESOLVED_USE = re.compile(r"\b(unresolvedCapture\d+|unresolvedRegister\d+)\b")


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
        if not m or line.lstrip().startswith("--") or "-- unresolved:" in line \
                or decl_only.match(line.split("--", 1)[0].rstrip()):
            out.append(line)
            continue
        code = line.split("--", 1)[0]
        names = []
        for mm in UNRESOLVED_USE.finditer(code):
            if mm.group(1) not in names:
                names.append(mm.group(1))
        hints = ", ".join("#%s %s" % (re.sub(r"^unresolved(?:Capture|Register)", "", nm),
                                      _use_hint(code, nm))
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


# --- context slots -------------------------------------------------------
# The lifter keeps the script's own helper table (`local data = {}` filled with
# `data[15] = <function>`), because the script really does index it by number.
# A number says nothing to a reader, so a slot that is written exactly once gets
# a name: either the local it was copied from (`data[20] = state` -> `state`) or,
# for a stored function, what that function looks up or waits on
# (`FindFirstChild("HumanoidRootPart")` -> `humanoidRootPart`). Reads are only
# rewritten where that name really resolves to the same binding -- a slot whose
# name is shadowed somewhere keeps its `data[k]` form there.

_SLOT_METHODS = ("GetService", "WaitForChild", "FindFirstChild", "FindFirstChildOfClass")
# methods that say how a value is used, not what it is
_SLOT_STRUCTURAL = {
    "IsA", "Clone", "Destroy", "Connect", "Disconnect", "GetChildren", "GetDescendants",
    "FindFirstChild", "FindFirstChildOfClass", "FindFirstChildWhichIsA", "WaitForChild",
    "GetService", "GetAttribute", "SetAttribute", "pairs", "Get", "Set",
    # string/table utilities: a slot that formats a line is a logger, not a `format`
    "format", "sub", "gsub", "find", "match", "split", "rep", "upper", "lower",
    "insert", "remove", "concat", "pack", "unpack", "sort", "freeze", "tostring",
    "tonumber", "type", "print", "warn", "spawn", "defer", "delay",
    "gmatch", "byte", "char", "len", "clone", "keys", "values",
}
# a name made only of these words describes the type, not the value
_SLOT_BORING = {"new", "value", "name", "wait", "call", "self", "data", "get", "set"}
# a call on one of these says what the language does, not what the slot is for
_SLOT_NAMESPACES = {
    "os", "math", "table", "string", "task", "coroutine", "utf8", "bit32", "debug",
    "game", "workspace", "script", "Instance", "Enum", "Color3", "UDim2", "UDim",
    "Vector2", "Vector3", "CFrame", "Rect", "NumberRange", "NumberSequence",
    "ColorSequence", "Ray", "Region3", "TweenInfo", "BrickColor", "Random",
}
# a local the lifter invented says no more than the number it replaced
_SLOT_GENERATED = re.compile(
    r"^(?:data|value|valueMap|labelMap|uidMap|condition|response|number|callback|argument"
    r"|toNumberOrDefault|now|value\d*|slot)\d*$"
)
_LUA_KEYWORDS = {
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function",
    "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true",
    "until", "while", "continue", "export", "type",
}


def _iter_nodes(node, type_name):
    """Every node of one type, in source order."""
    out = []
    stack = [node]
    while stack:
        cur = stack.pop()
        if isinstance(cur, dict):
            if cur.get("type") == type_name:
                out.append(cur)
            stack.extend(v for k, v in cur.items() if k != "location")
        elif isinstance(cur, list):
            stack.extend(cur)
    out.sort(key=lambda n: n["location"])
    return out


def _line_indent(btext, pos):
    line = btext.rfind(b"\n", 0, pos) + 1
    end = line
    while end < len(btext) and btext[end:end + 1] in (b"\t", b" "):
        end += 1
    return btext[line:end].decode("utf-8")


def _slot_camel(word):
    """`RunService` -> `runService`, `field_egg_records` -> `fieldEggRecords`."""
    word = re.sub(r"[^0-9A-Za-z]+", "_", str(word)).strip("_")
    parts = [p for p in word.split("_") if p]
    if not parts:
        return None
    out = parts[0][:1].lower() + parts[0][1:]
    for p in parts[1:]:
        out += p[:1].upper() + p[1:]
    return out or None


def _slot_string_arg(node):
    """The single string literal a call was given, if that is all it was given."""
    args = node.get("args") or []
    if len(args) != 1 or args[0].get("type") != "AstExprConstantString":
        return None
    value = args[0].get("value")
    return value if isinstance(value, str) else None


def _slot_method_of(node):
    fn = node.get("func") or {}
    if fn.get("type") == "AstExprIndexName":
        return fn.get("index")
    if fn.get("type") == "AstExprLocal":
        return (fn.get("local") or {}).get("name")
    return None


def _slot_call_name(node):
    """Name for a stored value: `game:GetService("RunService")` -> runService."""
    if node.get("type") == "AstExprIndexName":
        index = node.get("index")
        base = node.get("expr") or {}
        if index == "new" and base.get("type") == "AstExprGlobal":
            name = _slot_camel(base.get("global"))
            return ("new" + name[:1].upper() + name[1:]) if name else None
        return _slot_camel(index)
    if node.get("type") == "AstExprCall":
        literal = _slot_string_arg(node)
        if not literal:
            return None
        method = _slot_method_of(node)
        if method in _SLOT_METHODS or method in ("getService", "service", "child", "find"):
            return _slot_camel(literal)
        return None
    if node.get("type") == "AstExprGlobal":
        return _slot_camel(node.get("global"))
    return None


def _slot_function_name(node):
    """Name for a stored function, from what it looks up or waits on.

    A body that only calls a helper it was handed (`callback7(...)`) or a string
    utility says nothing about the slot, and is left unnamed.

    `function() return character:FindFirstChild("HumanoidRootPart") end` -> humanoidRootPart,
    `function() return heartbeat:Wait() end` -> heartbeatWait.
    """
    literal_name = None
    method_name = None
    params = {p.get("name") for p in node.get("args") or []}
    for call in _iter_nodes(node.get("body") or {}, "AstExprCall"):
        literal = _slot_string_arg(call)
        method = _slot_method_of(call)
        if literal and method in _SLOT_METHODS and literal_name is None:
            literal_name = _slot_camel(literal)
            continue
        if not method or method in _SLOT_STRUCTURAL or method_name is not None:
            continue
        fn_node = call.get("func") or {}
        if fn_node.get("type") == "AstExprLocal":
            callee = (fn_node.get("local") or {}).get("name") or ""
            if callee in params or _SLOT_GENERATED.match(callee):
                continue
        base = fn_node.get("expr") or {}
        if base.get("type") == "AstExprGlobal":
            if base.get("global") in _SLOT_NAMESPACES:
                continue
            base_name = None
        elif base.get("type") == "AstExprLocal":
            base_name = _slot_camel((base.get("local") or {}).get("name"))
        elif base.get("type") == "AstExprIndexName":
            base_name = _slot_camel(base.get("index"))
        else:
            base_name = None
        call_name = _slot_camel(method)
        if not call_name:
            continue
        if base_name and not _SLOT_GENERATED.match((base.get("local") or {}).get("name") or ""):
            if base_name.lower() in _SLOT_BORING:
                method_name = call_name
            else:
                method_name = base_name + call_name[:1].upper() + call_name[1:]
        else:
            method_name = call_name
    return literal_name or method_name


def _slot_name_from(node):
    t = node.get("type")
    if t == "AstExprFunction":
        return _slot_function_name(node) or _slot_call_name(node)
    name = _slot_call_name(node)
    if name and name.lower() not in _SLOT_BORING:
        return name
    return None


def _slot_bindings(root, starts, total, wanted):
    """Where each name of interest is bound, and how far that binding reaches.

    Returns name -> [(decl_start, decl_end, block_end, location)], so a read can
    be tested against the binding that would really win at that spot: a name
    declared again inside a nested function covers that function, a name declared
    earlier in the same block is overwritten the moment the slot is named.
    """
    found = {}

    def walk(node, block_end, depth=0):
        if not isinstance(node, dict) or depth > 400:
            return
        t = node.get("type")
        if t == "AstStatBlock":
            _, block_end = _loc_bytes(node["location"], starts)
        if t == "AstExprFunction":
            fn_start, fn_end = _loc_bytes(node["location"], starts)
            for param in node.get("args") or []:
                name = param.get("name")
                if name in wanted:
                    found.setdefault(name, []).append(
                        (fn_start, fn_start, fn_end, param.get("location")))
        if t in ("AstStatLocal", "AstStatLocalFunction"):
            decl_start, decl_end = _loc_bytes(node["location"], starts)
            declared = node.get("vars") or ([node.get("name")] if t == "AstStatLocalFunction" else [])
            for var in declared:
                if not isinstance(var, dict):
                    continue
                name = var.get("name")
                if name in wanted:
                    found.setdefault(name, []).append(
                        (decl_start, decl_end, block_end, var.get("location")))
        for k, v in node.items():
            if k == "location":
                continue
            if isinstance(v, dict):
                walk(v, block_end, depth + 1)
            elif isinstance(v, list):
                for x in v:
                    walk(x, block_end, depth + 1)

    walk(root, total)
    return found


def _slot_shadow_ranges(bindings, target_location, alias_at):
    """The ranges where a read would resolve to a binding other than the slot's."""
    ranges = []
    for decl_start, decl_end, block_end, location in bindings:
        if target_location is not None and location == target_location:
            continue
        if decl_start < alias_at:
            # declared above the name: it stops applying where the slot is named
            ranges.append((decl_end, alias_at))
        else:
            ranges.append((decl_end, block_end))
    return ranges


def _name_context_slots(text):
    root = _parse_ast(text)
    btext = text.encode("utf-8")
    starts = _line_starts(btext)

    def span(node):
        return _loc_bytes(node["location"], starts)

    tables = set()
    for stmt in _iter_nodes(root, "AstStatLocal"):
        vars_, values = stmt.get("vars") or [], stmt.get("values") or []
        if len(vars_) == 1 and len(values) == 1 and values[0].get("type") == "AstExprTable":
            if not (values[0].get("items") or []):
                tables.add(vars_[0].get("name"))
    if not tables:
        return text

    def key_of(node):
        base = node.get("expr") or {}
        if base.get("type") != "AstExprLocal":
            return None, None
        table = (base.get("local") or {}).get("name")
        index = node.get("index") or {}
        if table not in tables or index.get("type") != "AstExprConstantNumber":
            return None, None
        return table, index.get("value")

    # the statement that stores each slot, and the value it stores
    staged = {}
    for assign in _iter_nodes(root, "AstStatAssign"):
        vars_ = assign.get("vars") or []
        if len(vars_) != 1 or vars_[0].get("type") != "AstExprIndexExpr":
            continue
        table, key = key_of(vars_[0])
        if table is None:
            continue
        staged.setdefault((table, key), []).append((vars_[0], assign))

    targets_ = {id(var) for stores in staged.values() for var, _ in stores}
    reads = {}
    for node in _iter_nodes(root, "AstExprIndexExpr"):
        if id(node) in targets_:
            continue
        table, key = key_of(node)
        if table is not None:
            reads.setdefault((table, key), []).append(node)

    taken = set(re.findall(r"[A-Za-z_][A-Za-z0-9_]*", btext.decode("utf-8", "replace")))
    # `local runService = data[58]` is the alias this pass writes; reading it as
    # a use of the slot would write the alias twice
    alias_echo = set()
    for stmt in _iter_nodes(root, "AstStatLocal"):
        vars_, values = stmt.get("vars") or [], stmt.get("values") or []
        if len(vars_) == 1 and len(values) == 1 and values[0].get("type") == "AstExprIndexExpr":
            alias_echo.add((vars_[0].get("name"), id(values[0])))

    plans = []
    for (table, key), stores in sorted(staged.items(), key=lambda kv: (kv[0][0], kv[0][1])):
        if len(stores) != 1:
            continue
        assign = stores[0][1]
        values = assign.get("values") or []
        if len(values) != 1:
            continue
        slot_reads = reads.get((table, key)) or []
        if not slot_reads:
            continue
        write_start, write_end = span(assign)
        value = values[0]
        origin = None
        if value.get("type") == "AstExprLocal":
            # `data[20] = state`: the name is already there, so the reads can use
            # it directly and no alias line is written
            source = value.get("local") or {}
            name = source.get("name")
            if not name or _SLOT_GENERATED.match(name) or name in _LUA_KEYWORDS:
                continue
            origin = source.get("location")
        else:
            name = _slot_name_from(value)
            if not name or name in _LUA_KEYWORDS:
                continue
        plans.append({"table": table, "key": key, "assign": assign, "name": name,
                      "alias": origin is None, "origin": origin,
                      "reads": slot_reads, "at": write_end})
    if not plans:
        return text

    bindings = _slot_bindings(root, starts, len(btext), {p["name"] for p in plans})
    edits = []
    for plan in plans:
        shadows = _slot_shadow_ranges(bindings.get(plan["name"]) or [], plan["origin"], plan["at"])
        # a read above the write sees nil in the slot, so it keeps its `data[k]`
        usable = [r for r in plan["reads"] if span(r)[0] >= plan["at"]]
        usable = [r for r in usable
                  if (plan["name"], id(r)) not in alias_echo
                  and not any(a <= span(r)[0] < b for a, b in shadows)]
        if not usable:
            continue
        if plan["alias"]:
            indent = _line_indent(btext, span(plan["assign"])[0])
            line = "\n%slocal %s = %s[%d]" % (indent, plan["name"], plan["table"], plan["key"])
            edits.append((plan["at"], plan["at"], line.encode("utf-8")))
        for node in usable:
            start, end = span(node)
            edits.append((start, end, plan["name"].encode("utf-8")))
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8")


def _discard_unread_slots(text):
    """A name nothing reads can still be carrying a value.

    `local first, second = f()` hands the call's first result to `first`. When
    nothing reads `first` the name cannot go -- deleting it would slide `second`
    onto the first result -- so it stays, and `_` is what Lua writes for "this
    result is thrown away on purpose".

    Only used when the file has no live `_` of its own -- a local one would be
    captured by ours, a global one would be shadowed by it.
    """
    try:
        root = _parse_ast(text)
    except Exception:
        return text
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    refs = set()
    underscore = set()
    global_underscore = set()
    slots = []

    def walk(node):
        if isinstance(node, dict):
            t = node.get("type")
            if t == "AstExprLocal":
                refs.add(node["local"]["location"])
            elif t == "AstExprGlobal" and node.get("global") == "_":
                global_underscore.add(True)
            elif t in ("AstStatLocal", "AstStatLocalFunction"):
                for v in ([node["name"]] if t == "AstStatLocalFunction" else node.get("vars") or []):
                    if v.get("name") == "_":
                        underscore.add(v["location"])
                    elif t == "AstStatLocal":
                        slots.append(v)
            for k, v in node.items():
                if k != "location":
                    walk(v)
        elif isinstance(node, list):
            for x in node:
                walk(x)

    walk(root)
    if (underscore & refs) or global_underscore:   # this file already has a `_`
        return text
    edits = []
    for v in slots:
        loc = v["location"]
        if loc in refs or v.get("name") == "_":
            continue
        s, e = _loc_bytes(loc, starts)
        edits.append((s, e, b"_"))
    if not edits:
        return text
    return _apply_edits(btext, edits).decode("utf-8", "surrogateescape")


# --- usage names ---------------------------------------------------------
# The lifter calls a parameter it could not follow `argument5`, and a function
# it could not name `callback7`. Both say nothing, but both are *used*: the
# parameter is the receiver of `:GetAttribute("RacePowerUp")`, the argument of
# `pcall`, the thing indexed by `map[uid]`; the function is the handler handed
# to `:Connect`. This pass names a binding from that evidence, and only renames
# a binding whose references it reaches: a name another live binding already
# holds inside the same range is not used.

_PLACEHOLDER = re.compile(r"^(?:argument\d+|callback\d*)$")
_GENERIC_FIELDS = {
    "Parent": "child",
    "Character": "player",
    "CFrame": "part",
    "Position": "part",
    "AssemblyLinearVelocity": "part",
    "LookVector": "part",
    "Humanoid": "character",
    "HumanoidRootPart": "character",
    "WalkSpeed": "humanoid",
    "Health": "humanoid",
    "UserInputType": "input",
    "KeyCode": "input",
    "Text": "textBox",
    "Transparency": "part",
}
_METHOD_NAMES = {
    "Connect": "signal",
    "FireServer": "remote",
    "InvokeServer": "remote",
    "Destroy": "instance",
    "Clone": "instance",
    "GetChildren": "container",
    "GetDescendants": "container",
    "Kick": "player",
    "Disconnect": "connection",
}
# `("callee", argument index) -> name`, for calls whose meaning is the language's
_USAGE_CALLS = {
    ("pcall", 0): "callback", ("xpcall", 0): "callback",
    ("task.spawn", 0): "callback", ("task.defer", 0): "callback",
    ("task.delay", 1): "callback", ("coroutine.wrap", 0): "callback",
    ("tostring", 0): "value", ("tonumber", 0): "text", ("type", 0): "value",
    ("ipairs", 0): "container", ("pairs", 0): "container", ("next", 0): "container",
    ("table.insert", 1): "value", ("table.insert", 0): "list",
    ("table.remove", 0): "list", ("table.concat", 0): "list",
    ("string.format", 0): "template",
    ("math.max", 0): "amount", ("math.min", 0): "amount",
}

def _usage_callee(call):
    """`name` for `f(...)` and `obj.name(...)`, or None."""
    fn = call.get("func") or {}
    if fn.get("type") == "AstExprGlobal":
        return fn.get("global")
    if fn.get("type") == "AstExprIndexName" and fn.get("op") == ".":
        return fn.get("index")
    return None


def _usage_index(root):
    """Parent of every node, and every reference grouped by the binding it reads."""
    parent, refs, funcs = {}, {}, {}

    def walk(node, par=None, key=None):
        if isinstance(node, dict):
            parent[id(node)] = (par, key)
            t = node.get("type")
            if t == "AstExprLocal":
                loc = (node.get("local") or {}).get("location")
                refs.setdefault(loc, []).append(node)
            elif t == "AstExprFunction":
                funcs.setdefault(id(node), node)
            for k, v in node.items():
                if k != "location":
                    walk(v, node, k)
        elif isinstance(node, list):
            for x in node:
                walk(x, par, key)

    walk(root)
    return parent, refs, funcs


def _usage_function_handles(root):
    """Handle binding location -> the function it holds, for named functions."""
    handles = {}
    for stmt in _iter_nodes(root, "AstStatLocalFunction"):
        name = (stmt.get("name") or {}).get("location")
        fn = stmt.get("func") or {}
        if name and fn.get("type") == "AstExprFunction":
            handles[name] = fn
    for stmt in _iter_nodes(root, "AstStatLocal"):
        vars_, values = stmt.get("vars") or [], stmt.get("values") or []
        if len(vars_) == len(values):
            for var, value in zip(vars_, values):
                if value.get("type") == "AstExprFunction":
                    handles[var.get("location")] = value
    for stmt in _iter_nodes(root, "AstStatAssign"):
        vars_, values = stmt.get("vars") or [], stmt.get("values") or []
        if len(vars_) == len(values):
            for var, value in zip(vars_, values):
                if var.get("type") == "AstExprLocal" and value.get("type") == "AstExprFunction":
                    handles[(var.get("local") or {}).get("location")] = value
    return handles


def _usage_receiver(node):
    """The name a method is called on, when it is a plain local or global."""
    t = (node or {}).get("type")
    if t == "AstExprLocal":
        return (node.get("local") or {}).get("name")
    if t == "AstExprGlobal":
        return node.get("global")
    return None


def _usage_method_handles(root):
    """The contract of a module method, both ways.

    A hub script builds its modules by hand (`module.run = function(job) end`,
    or `local module = {run = function(job) end}`), so `module:run(x)` is the
    same contract a local function would be: the parameter name travels between
    the definition and the call. A match on `receiver.field` wins; a field name
    that only one definition uses is good enough on its own.
    """
    defs = {}

    def add(receiver, field, value):
        if not isinstance(field, str) or (value or {}).get("type") != "AstExprFunction":
            return
        defs.setdefault((receiver, field), []).append(value)

    for stmt in _iter_nodes(root, "AstStatAssign"):
        vars_, values = stmt.get("vars") or [], stmt.get("values") or []
        if len(vars_) != len(values):
            continue
        for var, value in zip(vars_, values):
            receiver = _usage_receiver(var.get("expr") or {})
            if var.get("type") == "AstExprIndexName":
                add(receiver, var.get("index"), value)
            elif var.get("type") == "AstExprIndexExpr":
                key = var.get("index") or {}
                if key.get("type") == "AstExprConstantString":
                    add(receiver, key.get("value"), value)
    for stmt in _iter_nodes(root, "AstStatLocal"):
        vars_, values = stmt.get("vars") or [], stmt.get("values") or []
        for var, value in zip(vars_, values):
            if value.get("type") != "AstExprTable":
                continue
            receiver = var.get("name")
            for item in value.get("items") or []:
                if item.get("type") != "AstExprTableItem":
                    continue
                key = item.get("key") or {}
                if key.get("type") == "AstExprConstantString":
                    add(receiver, key.get("value"), item.get("value"))

    out, by_field = {}, {}
    for (receiver, field), fns in defs.items():
        signatures = {tuple(p.get("name") for p in (fn.get("args") or [])) for fn in fns}
        if len(signatures) != 1:        # definitions that disagree say nothing
            continue
        if receiver:
            out[(receiver, field)] = fns[0]
        by_field.setdefault(field, []).append(fns[0])
    for field, fns in by_field.items():
        signatures = {tuple(p.get("name") for p in (fn.get("args") or [])) for fn in fns}
        if len(signatures) == 1:
            out[(None, field)] = fns[0]
    return out


def _usage_init_name(init):
    """Name for `local value7 = <init>`, when the value says what it is."""
    t = init.get("type")
    if t == "AstExprFunction":
        return _slot_function_name(init) or _usage_body_name(init)
    if t == "AstExprIndexName":
        # a value read out of a field *is* that field: `part.Position` -> position
        return _slot_camel(init.get("index"))
    if t == "AstExprCall":
        if _slot_method_of(init) == "pack" or _usage_callee(init) == "pack":
            return "packedValues"
        return _slot_call_name(init)
    return None


def _usage_owner_names(root):
    """Function node id -> the name it is bound to, so a parameter never takes it.

    `local function key(key)` would make the body read its own argument instead
    of the function, and the name would say the opposite of what it holds.
    """
    owners = {}
    for stmt in _iter_nodes(root, "AstStatLocalFunction"):
        fn = stmt.get("func") or {}
        if fn.get("type") == "AstExprFunction":
            owners[id(fn)] = (stmt.get("name") or {}).get("name")
    for kind in ("AstStatLocal", "AstStatAssign"):
        for stmt in _iter_nodes(root, kind):
            vars_, values = stmt.get("vars") or [], stmt.get("values") or []
            if len(vars_) != len(values):
                continue
            for var, value in zip(vars_, values):
                if value.get("type") != "AstExprFunction":
                    continue
                if var.get("type") == "AstExprLocal":
                    name = (var.get("local") or {}).get("name")
                else:
                    name = var.get("name")
                if name:
                    owners[id(value)] = name
    return owners


def _usage_votes(binding_loc, parent, refs):
    """What the usages suggest, heaviest first."""
    votes = []
    for ref in refs.get(binding_loc) or []:
        par, key = parent.get(id(ref)) or (None, None)
        if par is None:
            continue
        kind = par.get("type")
        if kind == "AstExprIndexName" and par.get("expr") is ref:
            field = par.get("index")
            grand, _ = parent.get(id(par)) or (None, None)
            is_method = (grand is not None and grand.get("type") == "AstExprCall"
                         and grand.get("func") is par)
            if is_method:
                literal = _slot_string_arg(grand)
                if field in ("GetAttribute", "GetAttributeChangedSignal",
                             "GetPropertyChangedSignal"):
                    votes.append((4, "object"))
                elif field in ("FindFirstChild", "WaitForChild") and literal:
                    votes.append((3, "instance"))
                elif field in ("FindFirstChildOfClass", "FindFirstChildWhichIsA") and literal:
                    votes.append((3, "character" if "Humanoid" in literal else "instance"))
                elif field in ("GetAttribute", "GetAttributeChangedSignal",
                               "GetPropertyChangedSignal"):
                    votes.append((2, "object"))
                elif field in _METHOD_NAMES:
                    votes.append((3, _METHOD_NAMES[field]))
                else:
                    votes.append((1, "object"))
            elif field in _GENERIC_FIELDS:
                votes.append((4, _GENERIC_FIELDS[field]))
            else:
                votes.append((1, "object"))
        elif kind == "AstExprCall" and par.get("func") is ref:
            votes.append((2, "callback"))
        elif kind == "AstExprCall" and key == "args":
            name = _usage_callee(par)
            position = next((i for i, a in enumerate(par.get("args") or []) if a is ref), None)
            hit = _USAGE_CALLS.get((name, position))
            if hit:
                votes.append((3, hit))
        elif kind == "AstExprUnary" and par.get("op") in ("Len", "#"):
            votes.append((2, "list"))
        elif kind == "AstExprIndexExpr" and par.get("index") is ref:
            votes.append((3, "key"))
        elif kind == "AstExprIndexExpr" and par.get("expr") is ref:
            votes.append((2, "list"))
        elif kind == "AstExprBinary":
            op = par.get("op") or ""
            other = par.get("right") if par.get("left") is ref else par.get("left")
            if op in ("Eq", "Ne", "Lt", "Le", "Gt", "Ge", "==", "~=", "<", "<=", ">", ">="):
                if (other or {}).get("type") == "AstExprConstantNil":
                    votes.append((3, "object"))
            elif op in ("Add", "Sub", "Mul", "Div", "IDiv", "Mod", "Pow",
                        "+", "-", "*", "/", "%", "//"):
                votes.append((1, "amount"))
            elif op in ("Concat", ".."):
                votes.append((2, "text"))
        elif kind == "AstStatIf" and key == "condition":
            votes.append((1, "object"))
    votes = [(w, n) for w, n in votes if n]
    votes.sort(key=lambda v: -v[0])
    return votes


def _usage_evidence(binding_loc, parent, refs):
    """The strongest name the usages themselves suggest, if any."""
    votes = _usage_votes(binding_loc, parent, refs)
    return votes[0][1] if votes else None


def _usage_closure_name(binding_loc, parent, refs):
    """`callback44` handed to `:Connect` is a handler; name it after the event."""
    for ref in refs.get(binding_loc) or []:
        par, key = parent.get(id(ref)) or (None, None)
        if par is None or key != "args":
            continue
        if par.get("type") != "AstExprCall":
            continue
        fn = par.get("func") or {}
        if fn.get("type") != "AstExprIndexName":
            continue
        if fn.get("index") == "Connect":
            receiver = fn.get("expr") or {}
            if receiver.get("type") == "AstExprCall":
                literal = _slot_string_arg(receiver)
                if literal:
                    stem = _slot_camel(literal)
                    return "on" + stem[:1].upper() + stem[1:] + "Changed"
            if receiver.get("type") == "AstExprIndexName" and receiver.get("index"):
                stem = _slot_camel(receiver.get("index"))
                return "on" + stem[:1].upper() + stem[1:]
            if receiver.get("type") == "AstExprLocal":
                stem = _slot_camel((receiver.get("local") or {}).get("name") or "")
                if stem and not _PLACEHOLDER.match(stem):
                    return "on" + stem[:1].upper() + stem[1:]
        elif fn.get("index") in ("spawn", "defer") and _usage_callee(par) in ("task",):
            return "task"
    return None


def _usage_body_name(fn):
    """What a function does, when it is only ever called.

    `Instance.new("Frame")` in the body means the function makes a frame; a body
    that ends by firing a remote is the remote's sender.
    """
    body = fn.get("body") or {}
    for call in _iter_nodes(body, "AstExprCall"):
        method = _slot_method_of(call)
        fn_node = call.get("func") or {}
        receiver = fn_node.get("expr") or {}
        if method == "new" and receiver.get("type") == "AstExprGlobal":
            if receiver.get("global") == "Instance":
                literal = _slot_string_arg(call)
                if literal:
                    stem = _slot_camel(literal)
                    return "new" + stem[:1].upper() + stem[1:]
            elif receiver.get("global") not in _SLOT_NAMESPACES:
                stem = _slot_camel(receiver.get("global"))
                if stem:
                    return "new" + stem[:1].upper() + stem[1:]
    for method, name in (("FireServer", "fireRemote"), ("InvokeServer", "invokeRemote"),
                         ("Kick", "kickPlayer"), ("Destroy", "cleanup")):
        for call in _iter_nodes(body, "AstExprCall"):
            if _slot_method_of(call) == method:
                return name
    return None


def _usage_zone(bindings, name, location):
    for entry in bindings.get(name) or []:
        if entry[3] == location:
            return (entry[1], entry[2])
    return None


_NUMBERED = re.compile(r"^(?:argument\d+|callback\d+)$")
# a local the lifter filled from a register: `local value7 = ...`
_VALUE_LOCAL = re.compile(r"^value\d+$")
# the namer's own fallbacks: passing one of these on is not a name
_GENERATEDISH = re.compile(
    r"^(?:argument\d+|callback\d+|value\d*|valueMap\d*|labelMap\d*|uidMap\d*"
    r"|condition\d*|response\d*|number\d+|data\d+|k\d+|i\d+|now\d+|parts\d*"
    r"|toNumberOrDefault\d*|slot\d+|index\d+|element\d+)$"
)


def _usage_free(name, zone, bindings, globals_in_zone, assigned=None):
    if not name or name in _LUA_KEYWORDS or _NUMBERED.match(name):
        return False
    if _GENERATEDISH.match(name):
        return False
    for start, end in ((assigned or {}).get(name) or ()):
        if start < zone[1] and zone[0] < end:
            return False        # this pass already used that name here
    if name in globals_in_zone:
        return False
    for entry in bindings.get(name) or []:
        start, end = entry[1], entry[2]
        if start < zone[1] and zone[0] < end:
            return False        # that name is already live inside this range
    return True


def _usage_names(text):
    root = _parse_ast(text)
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    total = len(btext)

    names = set()
    for node in _iter_nodes(root, "AstLocal"):
        names.add(node.get("name"))
    bindings = _slot_bindings(root, starts, total, names)

    parent, refs, _funcs = _usage_index(root)
    handles = _usage_function_handles(root)
    owners = _usage_owner_names(root)
    globals_by_name = {}
    for node in _iter_nodes(root, "AstExprGlobal"):
        start, end = _loc_bytes(node["location"], starts)
        globals_by_name.setdefault(node.get("global"), []).append((start, end))

    prop_fallback = {}
    owner_of_param = {}
    for fn in _iter_nodes(root, "AstExprFunction"):
        for param in fn.get("args") or []:
            owner_of_param[param.get("location")] = id(fn)

    methods = _usage_method_handles(root)
    targets = {}                        # binding location -> (node, kind)
    for node in _iter_nodes(root, "AstLocal"):
        name = node.get("name") or ""
        if _VALUE_LOCAL.match(name):
            targets.setdefault(node.get("location"), (node, "value"))
            continue
        if not _PLACEHOLDER.match(name):
            continue
        is_param = node.get("location") in owner_of_param
        if name.startswith("callback"):
            # `callback` on a parameter is a name this pass chose; only the
            # lifter's numbered fallbacks are worth renaming
            if is_param:
                continue
            targets.setdefault(node.get("location"), (node, "closure"))
        elif is_param:
            targets.setdefault(node.get("location"), (node, "param"))
        else:
            # an `argumentN` that is a plain local, not a parameter: it takes
            # the same usage evidence, just without the parameter guards
            targets.setdefault(node.get("location"), (node, "local"))
    if not targets:
        return text

    # where a `value` local is initialised, and how many times it is written
    init_of, writes = {}, {}
    for stmt in _iter_nodes(root, "AstStatLocal"):
        vars_, values = stmt.get("vars") or [], stmt.get("values") or []
        for var, value in zip(vars_, values):
            init_of.setdefault(var.get("location"), value)
    for stmt in _iter_nodes(root, "AstStatAssign"):
        for var in stmt.get("vars") or []:
            if var.get("type") == "AstExprLocal":
                loc = (var.get("local") or {}).get("location")
                writes[loc] = writes.get(loc, 0) + 1

    def globals_within(zone):
        out = set()
        for name, spans in globals_by_name.items():
            if any(zone[0] <= s and e <= zone[1] for s, e in spans):
                out.add(name)
        return out

    chosen = {}
    assigned = {}
    for _round in range(3):
        changed = False
        # a parameter can be named from what the function it is handed to calls it
        for call in _iter_nodes(root, "AstExprCall"):
            fn = call.get("func") or {}
            params = None
            is_method_call = bool(call.get("self"))
            if fn.get("type") == "AstExprLocal":
                target = handles.get((fn.get("local") or {}).get("location"))
                if target is not None:
                    params = target.get("args") or []
            elif fn.get("type") == "AstExprIndexName":
                field = fn.get("index")
                receiver = _usage_receiver(fn.get("expr") or {})
                target = (methods.get((receiver, field)) if receiver else None) \
                    or methods.get((None, field))
                if target is not None:
                    params = target.get("args") or []
                if params and is_method_call:
                    # `module:run(x)` hands the receiver in as `self`; align past
                    # it, and say nothing when the method does not declare one
                    if (params[0].get("name") or "") in ("self", "_self"):
                        params = params[1:]
                    else:
                        params = []
            if not params:
                continue
            for index, arg in enumerate(call.get("args") or []):
                if index >= len(params) or arg.get("type") != "AstExprLocal":
                    continue
                arg_loc = (arg.get("local") or {}).get("location")
                param_loc = params[index].get("location")
                param_name = chosen.get(param_loc) or params[index].get("name")
                arg_name = chosen.get(arg_loc) or (arg.get("local") or {}).get("name")
                for loc, source in ((arg_loc, param_name), (param_loc, arg_name)):
                    if loc not in targets or loc in chosen:
                        continue
                    if targets[loc][1] == "closure":
                        # a handler says more about what it is than the name its
                        # caller happens to use for it, so keep this only as a
                        # fallback for a handler with no evidence of its own
                        prop_fallback.setdefault(loc, source)
                        continue
                    if _PLACEHOLDER.match(source or ""):
                        continue
                    zone = _usage_zone(bindings, targets[loc][0].get("name"), loc)
                    if zone is None:
                        continue
                    if _usage_free(source, zone, bindings, globals_within(zone), assigned):
                        chosen[loc] = source
                        assigned.setdefault(source, []).append(zone)
                        changed = True
        order = {"param": 0, "local": 1, "closure": 2, "value": 3}
        for loc, (node, kind) in sorted(targets.items(), key=lambda kv: order[kv[1][1]]):
            if loc in chosen:
                continue
            name = node.get("name") or ""
            zone = _usage_zone(bindings, name, loc)
            if zone is None:
                continue
            if kind == "closure":
                candidate = (_usage_closure_name(loc, parent, refs)
                             or _usage_body_name(handles.get(loc) or {})
                             or prop_fallback.get(loc))
            elif kind == "value":
                votes = _usage_votes(loc, parent, refs)
                candidate = votes[0][1] if votes and votes[0][0] >= 2 else None
                if candidate is None and not writes.get(loc):
                    candidate = _usage_init_name(init_of.get(loc) or {})
                if candidate is None and votes:
                    candidate = votes[0][1]
            else:
                candidate = _usage_evidence(loc, parent, refs)
                holder = owner_of_param.get(loc) if kind == "param" else None
                if holder is not None and candidate == owners.get(holder):
                    continue            # the function's own name is not the parameter's
            if not candidate or candidate == name:
                continue
            if _usage_free(candidate, zone, bindings, globals_within(zone), assigned):
                if not (kind == "value" and candidate == name):
                    chosen[loc] = candidate
                    assigned.setdefault(candidate, []).append(zone)
                    changed = True
                continue
            # a live neighbour already owns the plain name: a numbered sibling
            # keeps the meaning and stays distinct (`object` -> `object2`)
            for n in range(2, 6):
                alt = "%s%d" % (candidate, n)
                if _usage_free(alt, zone, bindings, globals_within(zone), assigned):
                    chosen[loc] = alt
                    assigned.setdefault(alt, []).append(zone)
                    changed = True
                    break
        if not changed:
            break

    if not chosen:
        return text
    edits = []
    for loc, name in chosen.items():
        start, end = _loc_bytes(loc, starts)
        edits.append((start, end, name.encode("utf-8")))
        for ref in refs.get(loc) or []:
            rstart, rend = _loc_bytes(ref["location"], starts)
            edits.append((rstart, rend, name.encode("utf-8")))
    return _apply_edits(btext, edits).decode("utf-8")


def name_from_usage(text):
    """Name parameters and handlers from how they are used. Never raises.

    A name this pass picks is evidence for the next one (the caller's argument
    takes the name the callee gave its parameter), so it runs until the text
    stops changing -- two rounds on the carrier sample.
    """
    try:
        for _round in range(3):
            out = _usage_names(text)
            if out == text:
                break
            text = out
        return text
    except Exception as ex:                        # never lose a working output
        print("[!] usage naming pass failed: %s" % ex, file=sys.stderr)
        return text


def name_context_slots(text):
    """Give the script's own `data[k]` helper slots a name. Never raises."""
    try:
        return _name_context_slots(text)
    except Exception as ex:                        # never lose a working output
        print("[!] context slot naming pass failed: %s" % ex, file=sys.stderr)
        return text


def _align_comment_indent(text):
    """A comment sits where the code it introduces sits. The passes above move
    statements between blocks, and a note left at the old column reads like it
    belongs to something else."""
    lines = text.split("\n")
    out = list(lines)
    for i, line in enumerate(lines):
        stripped = line.lstrip()
        if not stripped.startswith("--"):
            continue
        indent = line[:len(line) - len(stripped)]
        for j in range(i + 1, len(lines)):
            nxt = lines[j]
            if not nxt.strip():
                continue
            nindent = nxt[:len(nxt) - len(nxt.lstrip())]
            if nindent != indent:
                out[i] = nindent + stripped
            break
    return "\n".join(out)


def _fold_constant_ifs(text, rounds=4):
    for _ in range(rounds):
        folded = _fold_constant_ifs_once(text)
        if folded == text:
            return text
        text = folded
    return text


def _branch_targets(nodes, into=None):
    """The local names a branch body stores into, at any depth."""
    into = set() if into is None else into
    for node in nodes or []:
        if not isinstance(node, dict):
            if isinstance(node, list):
                _branch_targets(node, into)
            continue
        t = node.get("type") or ""
        if t in ("AstStatAssign", "AstStatCompoundAssign", "AstStatLocal"):
            for var in node.get("vars") or []:
                loc = var.get("local") if isinstance(var, dict) and var.get("type") == "AstExprLocal" else var
                if isinstance(loc, dict) and loc.get("name"):
                    into.add(loc["name"])
        for k, v in node.items():
            if k != "location" and isinstance(v, (dict, list)):
                _branch_targets(v if isinstance(v, list) else [v], into)
    return into


def _fold_constant_ifs_once(text):
    """`if nil then ... else ... end` is a branch the lift could not decide: the
    constant is what runs, so the taken block is what the code does. Keep it and
    drop the rest, rather than leaving a branch no reader can explain."""
    try:
        root = _parse_ast(text)
    except Exception:
        return text
    btext = text.encode("utf-8")
    starts = _line_starts(btext)

    def line_start(pos):
        i = btext.rfind(b"\n", 0, pos)
        return i + 1

    edits = []
    for stmt in _iter_nodes(root, "AstStatIf"):
        cond = stmt.get("condition") or {}
        kind = cond.get("type")
        if kind == "AstExprConstantNil":
            taken = stmt.get("elsebody")
        elif kind == "AstExprConstantBool" and not cond.get("value"):
            taken = stmt.get("elsebody")
        else:
            # `if true then ... end` is harmless and the local merge already
            # looks through it; only a branch the run skipped is worth rewriting
            continue
        start, end = _loc_bytes(stmt["location"], starts)
        body = (taken or {}).get("body") or []
        other = (stmt.get("thenbody") if taken is stmt.get("elsebody")
                 else stmt.get("elsebody")) or {}
        if _branch_targets(other.get("body")) - _branch_targets(body):
            # the block that would go is the only place these values are set: a
            # condition the lift lost prints as `nil`, and deleting the block it
            # guards would leave the frame nil where the original had a value
            continue
        note = b""
        if other.get("body"):
            # say it out loud: a branch that never ran is being dropped
            line = btext.rfind(b"\n", 0, start) + 1
            indent = btext[line:start]
            indent = indent[:len(indent) - len(indent.lstrip())]
            note = (indent + b"-- devirt: dropped a branch the run never took "
                    b"(its condition was a literal)\n")
        if not body:
            edits.append((start, end, note))
            continue
        b0, _ = _loc_bytes(body[0]["location"], starts)
        _, b1 = _loc_bytes(body[-1]["location"], starts)
        chunk = btext[b0:b1]
        stmt_indent = start - line_start(start)
        body_indent = b0 - line_start(b0)
        chunk = note + chunk if note else chunk
        note = b""
        drop = body_indent - stmt_indent
        if drop > 0:
            lines = chunk.split(b"\n")
            fixed = [lines[0]] + [ln[drop:] if ln[:drop].strip() == b"" else ln
                                  for ln in lines[1:]]
            chunk = b"\n".join(fixed)
        edits.append((start, end, note + chunk))

    if not edits:
        return text
    edits.sort(key=lambda e: (e[0], -e[1]))
    kept = []
    for e in edits:
        if any(e[0] >= k[0] and e[1] <= k[1] for k in kept):
            continue                          # nested in a fold we already took
        kept.append(e)
    out = btext
    for start, end, repl in sorted(kept, key=lambda e: -e[0]):
        out = out[:start] + repl + out[end:]
    return out.decode("utf-8")


_LIB_TABLES = ("string", "table", "math", "os", "coroutine", "utf8", "bit32",
               "debug", "buffer")
_READONLY_NOTE = ("-- devirt: %s is read-only, so the table this code builds is "
                  "materialized here")


def _readonly_lib_rewrites(text):
    """`x = string` followed by `x[k] = v` cannot be right: Luau freezes those
    library tables, and the writes prove the code meant a table it builds. The
    lift lost that table, so it is materialized, and the file says so.

    Only a binding with nothing but field writes is touched -- one read and the
    value could still be the library, and guessing would be worse than the crash.
    """
    try:
        root = _parse_ast(text)
    except Exception:
        return text
    btext = text.encode("utf-8")
    starts = _line_starts(btext)
    parent, refs, _funcs = _usage_index(root)

    def par_of(node):
        hit = parent.get(id(node))
        return hit[0] if hit else None

    def is_store_base(ref):
        par = par_of(ref)
        if (par or {}).get("type") not in ("AstExprIndexName", "AstExprIndexExpr"):
            return False
        if par.get("expr") is not ref:
            return False
        gp = par_of(par)
        if (gp or {}).get("type") != "AstStatAssign":
            return False
        return any(v is par for v in (gp.get("vars") or []))

    def is_index_base(ref):
        par = par_of(ref)
        if (par or {}).get("type") not in ("AstExprIndexName", "AstExprIndexExpr"):
            return False
        if par.get("expr") is not ref:
            return False
        gp = par_of(par)
        # `x:find(...)` / `x.find(...)` needs the library itself, not a table
        if (gp or {}).get("type") == "AstExprCall" and gp.get("func") is par:
            return False
        return True

    def is_write_target(ref):
        par = par_of(ref)
        return (par or {}).get("type") == "AstStatAssign" and any(
            v is ref for v in (par.get("vars") or []))

    candidates = {}
    for kind in ("AstStatAssign", "AstStatLocal"):
        for stmt in _iter_nodes(root, kind):
            vars_, values = stmt.get("vars") or [], stmt.get("values") or []
            if len(vars_) != 1 or len(values) != 1:
                continue
            var, value = vars_[0], values[0]
            if value.get("type") != "AstExprGlobal" or value.get("global") not in _LIB_TABLES:
                continue
            if var.get("type") == "AstExprLocal":
                loc = (var.get("local") or {}).get("location")
            elif var.get("type") == "AstLocal":
                loc = var.get("location")
            else:
                continue
            candidates.setdefault(loc, []).append(value)

    edits = []
    for loc, values in candidates.items():
        uses = refs.get(loc) or []
        if not any(is_store_base(ref) for ref in uses):
            continue
        # a field read is fine (the table is what holds those fields); being
        # called, passed on or returned means the value really is the library
        if any(not (is_index_base(ref) or is_write_target(ref)) for ref in uses):
            continue
        for value in values:
            start, end = _loc_bytes(value["location"], starts)
            if not start and not end:
                continue
            tail = btext[end:].split(b"\n", 1)[0]
            if tail.strip():
                continue                 # something else shares the line
            lib = value.get("global")
            line = btext.rfind(b"\n", 0, start) + 1
            indent = btext[line:start]
            indent = indent[:len(indent) - len(indent.lstrip())]
            note = (_READONLY_NOTE % lib).encode("utf-8")
            edits.append((start, end, b"{}"))
            edits.append((line, line, indent + note + b"\n"))
    if not edits:
        return text
    out = btext
    for start, end, repl in sorted(edits, key=lambda e: (-e[0], -e[1])):
        out = out[:start] + repl + out[end:]
    return out.decode("utf-8")


def polish_ast(text, text_names=True):
    text = _strip_unused_params_and_dead_locals(text)
    try:
        text = _align_comment_indent(text)
    except Exception as ex:                        # never lose a working output
        print("[!] comment indent pass failed: %s" % ex, file=sys.stderr)
    try:
        text = _fold_constant_ifs(text)
    except Exception as ex:                        # never lose a working output
        print("[!] constant-if fold failed: %s" % ex, file=sys.stderr)
    try:
        text = _readonly_lib_rewrites(text)
    except Exception as ex:                        # never lose a working output
        print("[!] read-only library rewrite failed: %s" % ex, file=sys.stderr)
    text = _unwrap_top_level_iife(text)
    text = _sugar_local_functions(text)
    if text_names:
        # the script's own helper table is indexed by number; give each slot the
        # name of the thing stored in it before anything else looks at the code
        text = name_context_slots(text)
        # parameters and handlers are named from how they are used, after the
        # slots, so a slot's new name counts as evidence
        text = name_from_usage(text)
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
        text = _declare_unresolved_registers(text)
    except Exception as ex:                        # never lose a working output
        print("[!] unresolved register pass failed: %s" % ex, file=sys.stderr)
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
    try:
        # the passes above rewrite declarations, so the slots they emptied need one
        # more sweep before the file is written out
        text = _strip_unused_params_and_dead_locals(text)
        # what is left is a name that has to stay, because it is holding a call's
        # result apart from the ones the next slots take
        text = _discard_unread_slots(text)
    except Exception as ex:                        # never lose a working output
        print("[!] final dead-slot pass failed: %s" % ex, file=sys.stderr)
    try:
        # notes added while folding and materializing land at the right column
        text = _align_comment_indent(text)
    except Exception as ex:                        # never lose a working output
        print("[!] comment indent pass failed: %s" % ex, file=sys.stderr)
    return text


def main(argv):
    import argparse

    ap = argparse.ArgumentParser(description="apply the whole-program text passes")
    ap.add_argument("file", help="file to polish, or - for stdin")
    ap.add_argument("-o", "--output")
    args = ap.parse_args(argv)
    text = sys.stdin.read() if args.file == "-" else open(args.file, encoding="utf-8").read()
    out = polish_ast(text)
    if args.output:
        with open(args.output, "w", encoding="utf-8", newline="\n") as fh:
            fh.write(out)
    else:
        sys.stdout.write(out)
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
