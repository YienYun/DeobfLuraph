from luasym import Const, Reg, Pseudo, Bin, TempVal

def is_pseudo(e, name=None, depth=None):
    return isinstance(e, Pseudo) and (name is None or e.name == name) and (depth is None or e.depth == depth)

def _walk_ir_objs(blocks):
    for b in blocks.values():
        todo = [b.cond, getattr(b, "values", None)] + list(b.stmts)
        while todo:
            x = todo.pop()
            if x is None:
                continue
            yield b.id, x
            if isinstance(x, (list, tuple)):
                todo += list(x)
            elif hasattr(x, "__dict__") and not isinstance(x, type) and type(x).__name__ not in ("LTable", "Scope", "LuaFunc"):
                todo += list(x.__dict__.values())

def _fresh_reg(blocks):
    mx = 990000
    for _, x in _walk_ir_objs(blocks):
        if isinstance(x, Reg) and isinstance(x.n, int) and x.n >= mx:
            mx = x.n + 1
    for b in blocks.values():
        if b.kind == "for" and b.values and isinstance(b.values[0], int) and b.values[0] >= mx:
            mx = b.values[0] + 1
        elif b.kind == "forin" and b.values and isinstance(b.values[0], list):
            for rn in b.values[0]:
                if isinstance(rn, int) and rn >= mx:
                    mx = rn + 1
    return mx + 1

def _reachable_from(starts, blocks):
    seen = set()
    stk = [s for s in starts if s in blocks]
    while stk:
        u = stk.pop()
        if u in seen or u not in blocks:
            continue
        seen.add(u)
        stk.extend(blocks[u].succ)
    return seen

def _pseudo_reads_by_block(blocks, D):
    by_blk = {}
    for bid, b in blocks.items():
        s_set = set()
        todo = [b.cond, getattr(b, "values", None)]
        for s in b.stmts:
            if isinstance(s, D.Assign) and isinstance(s.target, Pseudo):
                todo.append(s.value)
            else:
                todo.append(s)
        while todo:
            x = todo.pop()
            if isinstance(x, Pseudo):
                s_set.add((x.name, x.depth))
            elif isinstance(x, (list, tuple)):
                todo += list(x)
            elif hasattr(x, "__dict__") and not isinstance(x, type) and type(x).__name__ not in ("LTable", "Scope", "LuaFunc"):
                todo += list(x.__dict__.values())
        if s_set:
            by_blk[bid] = s_set
    return by_blk

def _temp_use_counts(blocks, D):
    cnt = {}
    for bid, x in _walk_ir_objs(blocks):
        if isinstance(x, D.CallStmt):
            continue
        t = getattr(x, "t", None)
        if isinstance(t, str) and type(x).__name__ in ("TempVal", "TempTail"):
            cnt[t] = cnt.get(t, 0) + 1
    return cnt

def _push_pre_to_preds(h, pre, blocks):
    """Move pure register/pseudo moves `pre` out of `h` onto every incoming edge of `h`."""
    if not pre:
        return
    import copy
    import structure
    for p in list(h.preds):
        if p not in blocks:
            continue
        lb = blocks[p]
        if lb.kind == "goto" and lb.succ == [h.id]:
            lb.stmts += [copy.copy(s) for s in pre]
        else:
            nb = structure.Block(max(blocks) + 1)
            nb.stmts = [copy.copy(s) for s in pre]
            nb.kind = "goto"
            nb.succ = [h.id]
            nb.origin = lb.origin
            blocks[nb.id] = nb
            lb.succ = [nb.id if x == h.id else x for x in lb.succ]
    h.stmts = [h.stmts[-1]]
    _recompute(blocks)

def _strip_kstack_pops_and_thread(entry, blocks, D):
    """Remove cross-depth VM loop-stack pop assignments (`J_2 = J_1`, `J_1 = J_0`),
    thread resulting empty `goto` blocks, and merge semantically identical blocks
    across distinct VM PCs (`origin`/`path`) so FORPREP and FORLOOP exit paths unify."""
    changed = False
    for b in blocks.values():
        new_stmts = [
            s for s in b.stmts
            if not (
                isinstance(s, D.Assign) and isinstance(s.target, Pseudo)
                and (
                    (isinstance(s.value, Pseudo) and s.value.depth != s.target.depth)
                    or (isinstance(s.value, Const) and s.value.v is None)
                )
            )
        ]
        if len(new_stmts) != len(b.stmts):
            b.stmts = new_stmts
            changed = True
    while True:
        step = False
        # 1. Thread empty non-entry goto blocks (`B -> succ` when `B.stmts == []`)
        for bid in list(blocks):
            if bid == entry or bid not in blocks:
                continue
            b = blocks[bid]
            if b.kind == "goto" and not b.stmts and len(b.succ) == 1 and b.succ[0] != bid:
                tgt = b.succ[0]
                for ob in blocks.values():
                    if bid in ob.succ:
                        ob.succ = [tgt if x == bid else x for x in ob.succ]
                blocks.pop(bid, None)
                step = True
                changed = True
        # 2. Merge non-loop-latch blocks with identical semantics & successors
        by_sig = {}
        remap = {}
        for bid in sorted(blocks):
            b = blocks[bid]
            # Do not merge self-looping blocks directly
            if bid in b.succ:
                continue
            sig = (
                b.kind,
                tuple(D.fmt_stmt(s) for s in b.stmts),
                D.fmt_expr(b.cond) if b.cond is not None else None,
                D.fmt_multi(b.values) if b.values is not None else None,
                tuple(b.succ),
            )
            canon = by_sig.get(sig)
            if canon is None:
                by_sig[sig] = bid
            elif bid != entry:
                remap[bid] = canon
            else:
                # Keep `entry` alive if `entry` matched an earlier block id
                remap[canon] = bid
                by_sig[sig] = bid
        if remap:
            for old_id in remap:
                blocks.pop(old_id, None)
            for ob in blocks.values():
                ob.succ = [remap.get(x, x) for x in ob.succ]
            step = True
            changed = True
        if not step:
            break
    if changed:
        _recompute(blocks)

def _has_sibling_loop_header(blocks, b_id, kind, p_name, p_depth, D):
    for obid, ob in blocks.items():
        if obid == b_id or ob.kind != "cond" or not ob.stmts:
            continue
        last = ob.stmts[-1]
        if kind == "for":
            if isinstance(last, D.Assign) and is_pseudo(last.target, p_name, p_depth) \
                    and isinstance(last.value, Bin) and last.value.op == "Add":
                return True
        elif kind == "forin":
            if isinstance(last, D.CallStmt) and is_pseudo(last.fn, p_name, p_depth) \
                    and not last.args.items and last.args.tail is None:
                return True
    return False

def _split_prep_headers(blocks, D):
    """When Luau's FORNPREP / FORGPREP is fused into the entry loop-test block `b`
    (which has no back-edges because iterations 2..N jump to a sibling FORNLOOP /
    FORGLOOP block), split `b.stmts[:-1]` into a predecessor block so the header
    can unify cleanly with its sibling latch header."""
    import structure
    changed = False
    for bid in list(blocks):
        b = blocks.get(bid)
        if b is None or b.kind != "cond" or len(b.stmts) <= 1:
            continue
        pre, last = b.stmts[:-1], b.stmts[-1]
        if _pure_moves(pre, D):
            continue
        has_self_backedge = b.id in _reachable_from(b.succ, blocks)
        split_ok = False
        if isinstance(last, D.Assign) and is_pseudo(last.target) and isinstance(last.value, Bin) \
                and last.value.op == "Add" and is_pseudo(last.value.a, last.target.name, last.target.depth) \
                and is_pseudo(last.value.b):
            d = last.target.depth
            c = b.cond
            if isinstance(c, Bin) and c.op == "CompareLe" and is_pseudo(c.a, last.value.b.name, d) \
                    and isinstance(c.b, Const) and c.b.v == 0:
                if has_self_backedge or _has_sibling_loop_header(blocks, b.id, "for", last.target.name, d, D):
                    split_ok = True
        elif isinstance(last, D.CallStmt) and is_pseudo(last.fn) and not last.args.items and last.args.tail is None:
            if isinstance(b.cond, TempVal) and b.cond.t == last.t and b.cond.i == 1:
                if has_self_backedge or _has_sibling_loop_header(blocks, b.id, "forin", last.fn.name, last.fn.depth, D):
                    split_ok = True
        if split_ok:
            nb = structure.Block(max(blocks) + 1)
            nb.stmts = [last]
            nb.kind = "cond"
            nb.cond = b.cond
            nb.succ = list(b.succ)
            nb.origin = b.origin
            blocks[nb.id] = nb
            b.stmts = pre
            b.kind = "goto"
            b.cond = None
            b.succ = [nb.id]
            changed = True
    if changed:
        _recompute(blocks)

def _extract_gen_vars(bb, call_t, D):
    vars_pairs = []
    rest = []
    last_i = 1
    for s in bb.stmts:
        if not rest and isinstance(s, D.Assign) and isinstance(s.target, Reg) and isinstance(s.value, TempVal) \
                and s.value.t == call_t and s.value.i > last_i:
            vars_pairs.append((s.value.i, s.target.n))
            last_i = s.value.i
        else:
            rest.append(s)
    return vars_pairs, rest

def _numeric_sig(h, blocks, D):
    if h.kind != "cond" or not h.stmts:
        return None
    pre, s = h.stmts[:-1], h.stmts[-1]
    if not _pure_moves(pre, D):
        return None
    if not (isinstance(s, D.Assign) and is_pseudo(s.target) and isinstance(s.value, Bin) and s.value.op == "Add"
            and is_pseudo(s.value.a, s.target.name, s.target.depth) and is_pseudo(s.value.b)):
        return None
    a, z = s.target, s.value.b
    d = a.depth
    c = h.cond
    if not (isinstance(c, Bin) and c.op == "CompareLe" and is_pseudo(c.a, z.name, d) and isinstance(c.b, Const)
            and c.b.v == 0):
        return None
    body = exit_ = None
    var = "UNSET"
    lim = None
    for side in h.succ:
        sb = blocks.get(side)
        if sb is None or sb.kind != "cond" or sb.stmts:
            return None
        cc = sb.cond
        if not (isinstance(cc, Bin) and cc.op in ("CompareGe", "CompareLe") and is_pseudo(cc.a, a.name, d)
                and is_pseudo(cc.b, None, d)):
            return None
        if lim is not None and cc.b.name != lim.name:
            return None
        lim = cc.b
        t, e = [blocks[x] for x in sb.succ]
        if t.kind == "goto" and len(t.stmts) == 1 and isinstance(t.stmts[0], D.Assign) \
                and isinstance(t.stmts[0].target, Reg) and is_pseudo(t.stmts[0].value, a.name, d):
            cur_var = t.stmts[0].target.n
            cur_body = t.succ[0]
        elif t.kind == "goto" and len(t.stmts) == 0:
            cur_var = None
            cur_body = t.succ[0]
        else:
            return None
        if var != "UNSET" and (var != cur_var or body != cur_body or exit_ != e.id):
            return None
        var, body, exit_ = cur_var, cur_body, e.id
    return ("for", a.name, z.name, lim.name, d, var, body, exit_)

def _unify_loop_headers(entry, blocks, D):
    """Split leading TempVal extractions out of generic-for body heads so
    unrolled / secondary TFORLOOP & FORLOOP headers with identical signatures
    can merge into one canonical loop header."""
    import structure
    tcounts = _temp_use_counts(blocks, D)
    split_any = False
    for bid in list(blocks):
        h = blocks.get(bid)
        if h is None or h.kind != "cond" or not h.stmts or not isinstance(h.stmts[-1], D.CallStmt):
            continue
        call = h.stmts[-1]
        if not _pure_moves(h.stmts[:-1], D) or not is_pseudo(call.fn) or call.args.items or call.args.tail is not None:
            continue
        if not (isinstance(h.cond, TempVal) and h.cond.t == call.t and h.cond.i == 1):
            continue
        bb = blocks.get(h.succ[0])
        if bb is None or len(bb.preds) != 1:
            continue
        vpairs, rest = _extract_gen_vars(bb, call.t, D)
        if not vpairs or tcounts.get(call.t, 0) != 1 + len(vpairs):
            continue
        if rest or bb.kind != "goto":
            rb = structure.Block(max(blocks) + 1)
            rb.stmts = rest
            rb.kind = bb.kind
            rb.cond = bb.cond
            rb.succ = list(bb.succ)
            rb.values = bb.values
            rb.error = bb.error
            rb.origin = bb.origin
            blocks[rb.id] = rb
            bb.stmts = bb.stmts[:len(vpairs)]
            bb.kind = "goto"
            bb.cond = None
            bb.values = None
            bb.succ = [rb.id]
            split_any = True
    if split_any:
        _recompute(blocks)

    tcounts = _temp_use_counts(blocks, D)
    gen_groups = {}
    for bid in sorted(blocks):
        h = blocks.get(bid)
        if h is None or h.kind != "cond" or not h.stmts or not isinstance(h.stmts[-1], D.CallStmt):
            continue
        call = h.stmts[-1]
        if not _pure_moves(h.stmts[:-1], D) or not is_pseudo(call.fn) or call.args.items or call.args.tail is not None:
            continue
        if not (isinstance(h.cond, TempVal) and h.cond.t == call.t and h.cond.i == 1):
            continue
        bb = blocks.get(h.succ[0])
        if bb is None or len(bb.preds) != 1 or bb.kind != "goto":
            continue
        vpairs, rest = _extract_gen_vars(bb, call.t, D)
        if not vpairs or rest or tcounts.get(call.t, 0) != 1 + len(vpairs):
            continue
        sig = ("forin", call.fn.name, call.fn.depth, tuple(vpairs), bb.succ[0], h.succ[1])
        gen_groups.setdefault(sig, []).append(bid)

    for sig, bids in gen_groups.items():
        if len(bids) <= 1:
            continue
        _, it_name, it_depth, _, _, _ = sig
        canon = bids[0]
        for bid in bids:
            h = blocks[bid]
            has_prep = any(
                any(isinstance(s, D.Assign) and is_pseudo(s.target, it_name, it_depth) and isinstance(s.value, D.GenIter)
                    for s in blocks[p].stmts)
                for p in h.preds if p in blocks
            )
            if has_prep:
                canon = bid
                break
        h0 = blocks[canon]
        if h0.stmts[:-1]:
            _push_pre_to_preds(h0, h0.stmts[:-1], blocks)
        for bid in bids:
            if bid == canon or bid not in blocks:
                continue
            hd = blocks[bid]
            if hd.stmts[:-1]:
                _push_pre_to_preds(hd, hd.stmts[:-1], blocks)
            for p in list(hd.preds):
                if p in blocks:
                    blocks[p].succ = [canon if x == bid else x for x in blocks[p].succ]
            bbd_id = hd.succ[0]
            if bid != entry:
                blocks.pop(bid, None)
                if bbd_id in blocks and bbd_id != h0.succ[0]:
                    blocks.pop(bbd_id, None)
            _recompute(blocks)

    num_groups = {}
    for bid in sorted(blocks):
        h = blocks.get(bid)
        if h is None:
            continue
        sig = _numeric_sig(h, blocks, D)
        if sig is not None:
            num_groups.setdefault(sig, []).append(bid)

    for sig, bids in num_groups.items():
        if len(bids) <= 1:
            continue
        _, a_nm, z_nm, lim_nm, d, _, _, _ = sig
        canon = bids[0]
        for bid in bids:
            if find_prep(blocks[bid], blocks, D, (z_nm, lim_nm, a_nm), d):
                canon = bid
                break
        h0 = blocks[canon]
        if h0.stmts[:-1]:
            _push_pre_to_preds(h0, h0.stmts[:-1], blocks)
        for bid in bids:
            if bid == canon or bid not in blocks:
                continue
            hd = blocks[bid]
            if hd.stmts[:-1]:
                _push_pre_to_preds(hd, hd.stmts[:-1], blocks)
            old_sides = list(hd.succ)
            for p in list(hd.preds):
                if p in blocks:
                    blocks[p].succ = [canon if x == bid else x for x in blocks[p].succ]
            if bid != entry:
                blocks.pop(bid, None)
            _recompute(blocks)
            for side in old_sides:
                sb = blocks.get(side)
                if sb is not None and not sb.preds and side != entry:
                    t_cands = list(sb.succ)
                    blocks.pop(side, None)
                    _recompute(blocks)
                    for tc in t_cands:
                        tb = blocks.get(tc)
                        if tb is not None and not tb.preds and tc != entry:
                            blocks.pop(tc, None)
                            _recompute(blocks)

def recognize(entry, blocks, D):
    _strip_kstack_pops_and_thread(entry, blocks, D)
    _split_prep_headers(blocks, D)
    _unify_loop_headers(entry, blocks, D)
    found = {"for": 0, "forin": 0}
    idom = _dom_map(entry, blocks)
    for h in list(blocks.values()):
        if h.id not in blocks:
            continue
        if try_numeric(h, blocks, D, idom):
            found["for"] += 1
        elif try_generic(h, blocks, D, idom):
            found["forin"] += 1

    read_map = _pseudo_reads_by_block(blocks, D)
    read = set()
    for pset in read_map.values():
        read |= pset
    for b in blocks.values():
        b.stmts = [s for s in b.stmts if not (isinstance(s, D.Assign) and isinstance(s.target, Pseudo)
                                              and (s.target.name, s.target.depth) not in read)]
    return found

def find_prep(h, blocks, D, names, depth):
    """Predecessor blocks of h (outside the loop) that assign the pseudo prep values."""
    preps = []
    for p in h.preds:
        pb = blocks[p]
        vals = {}
        for s in pb.stmts:
            if isinstance(s, D.Assign) and isinstance(s.target, Pseudo) and s.target.depth == depth:
                vals[s.target.name] = s.value
        if all(n in vals for n in names):
            preps.append((pb, vals))
    return preps

def _pure_moves(pre, D):
    return all(isinstance(s, D.Assign) and isinstance(s.target, (Reg, Pseudo))
               and isinstance(s.value, (Const, Reg, Pseudo)) for s in pre)

def _moves_to_latches(h, pb, pre, blocks):
    """Register moves at the loop head (before the iterator call / counter
    step) run before every header evaluation: once after the prep and at the
    end of every iteration that continues (a new block per back edge, so
    conditional latches work too)."""
    import copy
    import structure
    for lb in [blocks[p] for p in h.preds if p != pb.id]:
        nb = structure.Block(max(blocks) + 1)
        nb.stmts = [copy.copy(s) for s in pre]
        nb.kind = "goto"
        nb.succ = [h.id]
        nb.origin = lb.origin
        blocks[nb.id] = nb
        lb.succ = [nb.id if x == h.id else x for x in lb.succ]
    _recompute(blocks)

def try_numeric(h, blocks, D, idom=None):
    if h.kind != "cond" or not h.stmts:
        return False
    if not _is_loop_header(h, blocks, idom):
        return False

    pre = h.stmts[:-1]
    s = h.stmts[-1]
    if not (isinstance(s, D.Assign) and is_pseudo(s.target) and isinstance(s.value, Bin) and s.value.op == "Add"
            and is_pseudo(s.value.a, s.target.name, s.target.depth) and is_pseudo(s.value.b)):
        return False
    if not _pure_moves(pre, D):

        return _run_once_for(h, s, blocks, D)
    a, z = s.target, s.value.b
    d = a.depth
    c = h.cond
    if not (isinstance(c, Bin) and c.op == "CompareLe" and is_pseudo(c.a, z.name, d) and isinstance(c.b, Const)
            and c.b.v == 0):
        return False
    body = exit_ = None
    var = "UNSET"
    for side in h.succ:
        sb = blocks[side]
        if sb.kind != "cond" or sb.stmts:
            return False
        cc = sb.cond
        if not (isinstance(cc, Bin) and cc.op in ("CompareGe", "CompareLe") and is_pseudo(cc.a, a.name, d)
                and is_pseudo(cc.b)):
            return False
        lim = cc.b
        t, e = [blocks[x] for x in sb.succ]
        if t.kind == "goto" and len(t.stmts) == 1 and isinstance(t.stmts[0], D.Assign) \
                and isinstance(t.stmts[0].target, Reg) and is_pseudo(t.stmts[0].value, a.name, d):
            cur_var = t.stmts[0].target.n
            cur_body = t.succ[0]
        elif t.kind == "goto" and len(t.stmts) == 0:
            cur_var = None
            cur_body = t.succ[0]
        else:
            return False
        if var != "UNSET" and (var != cur_var or body != cur_body or exit_ != e.id):
            return False
        var, body, exit_ = cur_var, cur_body, e.id
    if var is None:
        var = _fresh_reg(blocks)
    if h.id not in _reachable_from([body], blocks):
        return False
    preps = find_prep(h, blocks, D, (z.name, lim.name, a.name), d)
    if len(preps) > 1:
        names = (z.name, lim.name, a.name)
        nb = join_preps(h, blocks, [pb for pb, _ in preps],
                        lambda x: isinstance(x, D.Assign) and is_pseudo(x.target, None, d) and x.target.name in names)
        if nb is not None:
            preps = find_prep(h, blocks, D, names, d)
    if len(preps) != 1:
        return False
    pb, vals = preps[0]
    start = vals[a.name]
    step = strip_plus0(vals[z.name])
    limit = strip_plus0(vals[lim.name])

    if isinstance(start, Bin) and start.op == "Sub" and (is_pseudo(start.b, z.name, d) or
                                                        _same(start.b, step)):
        start = start.a
    elif isinstance(start, Const) and isinstance(step, Const) and _num(start.v) and _num(step.v):
        start = Const(start.v + step.v)
    else:
        return False
    for side in h.succ:
        sb = blocks[side]
        for x in sb.succ:
            blocks.pop(x, None) if blocks.get(x) is not None and blocks[x].kind == "goto" and \
                blocks[x].succ == [body] else None
        blocks.pop(side, None)
    h.stmts = []
    h.kind = "for"
    h.cond = None
    h.succ = [body, exit_]
    lst = LoopExprs([start, limit, step])
    h.values = (var, lst)
    place_prep(pb, lst, D, lambda s: isinstance(s, D.Assign) and isinstance(s.target, Pseudo)
               and s.target.depth == d and s.target.name in (z.name, lim.name, a.name))
    _recompute(blocks)
    if pre:
        import copy
        _moves_to_latches(h, pb, pre, blocks)
        pb.stmts += [copy.copy(x) for x in pre]
    return True

def _run_once_for(h, s, blocks, D):
    """try_numeric's header with the prep in the same block: substitute the
    prep values (start, limit, step) for the VM's loop slots in the header
    and its two compare blocks. Returns False (not a `for`)."""
    d = s.target.depth
    if h.id in _reachable_from(h.succ, blocks):
        return False
    own_ids = {h.id} | set(h.succ)
    for side in h.succ:
        sb = blocks.get(side)
        if sb is not None:
            for x in sb.succ:
                tb = blocks.get(x)
                if tb is not None and tb.kind == "goto" and len(tb.stmts) <= 1:
                    own_ids.add(x)
    p_reads = _pseudo_reads_by_block(blocks, D)
    if any(any(pd == d for _, pd in pset) for obid, pset in p_reads.items() if obid not in own_ids):
        return False
    vals = {x.target.name: x.value for x in h.stmts[:-1]
            if isinstance(x, D.Assign) and is_pseudo(x.target, None, d)}
    a, z = s.target.name, s.value.b.name
    if a not in vals or z not in vals:
        return False
    step, start = strip_plus0(vals[z]), vals[a]
    if not (isinstance(start, Bin) and start.op == "Sub" and is_pseudo(start.b, z, d)):
        return False
    sub = {nm: strip_plus0(v) for nm, v in vals.items()}
    sub[a], sub[z] = start.a, step
    import codegen

    def fn(x):
        return sub.get(x.name) if isinstance(x, Pseudo) and x.depth == d and x.name in sub else None
    h.stmts = [x for x in h.stmts[:-1] if not (isinstance(x, D.Assign) and is_pseudo(x.target, None, d))]
    h.cond = codegen.map_expr(h.cond, fn)
    for side in h.succ:
        sb = blocks[side]
        if sb.cond is not None:
            sb.cond = codegen.map_expr(sb.cond, fn)
        for t in sb.succ:
            for st in blocks[t].stmts:
                if isinstance(st, D.Assign):
                    st.value = codegen.map_expr(st.value, fn)
    def const_of(x):

        if isinstance(x, Reg):
            for st in reversed(h.stmts):
                if isinstance(st, D.Assign) and isinstance(st.target, Reg) and st.target.n == x.n:
                    return st.value if isinstance(st.value, Const) else None
        return x
    cmp = blocks[h.succ[0]].cond
    lim, step, first = const_of(getattr(cmp, "b", None)), const_of(step), const_of(start.a)
    if all(isinstance(x, Const) and _num(x.v) for x in (first, step, lim)):

        side = blocks[h.succ[0] if step.v <= 0 else h.succ[1]]
        runs = first.v >= lim.v if step.v <= 0 else first.v <= lim.v
        h.kind, h.cond, h.succ = "goto", None, [side.succ[0] if runs else side.succ[1]]
        _recompute(blocks)
    return False

def _num(v):
    return isinstance(v, (int, float)) and not isinstance(v, bool)

def _same(a, b):
    import ir
    return ir.fmt_expr(a) == ir.fmt_expr(b)

def strip_plus0(e):
    if isinstance(e, Bin) and e.op == "Add" and isinstance(e.b, Const) and e.b.v == 0:
        return e.a
    return e

def _dom_map(entry, blocks):
    """Immediate dominators of the current CFG (recomputed from succ edges)."""
    import structure
    succ = {bid: [x for x in b.succ if x in blocks] for bid, b in blocks.items()}
    preds = {bid: [] for bid in blocks}
    for bid, xs in succ.items():
        for x in xs:
            preds[x].append(bid)
    idom, _ = structure.dominators(entry, lambda bid: succ[bid], lambda bid: preds[bid])
    return idom

def _is_loop_header(h, blocks, idom):
    """A loop header dominates the block that jumps back to it. Without that
    the "header" is only re-entered from an enclosing loop, and the structurer
    would have to give up on it ("for loop without back edge")."""
    if idom is None or h.id not in idom:
        return True
    import structure
    return any(structure.dominates(idom, h.id, b.id)
               for b in blocks.values() if h.id in b.succ)

def try_generic(h, blocks, D, idom=None):
    if h.kind != "cond" or not h.stmts or not isinstance(h.stmts[-1], D.CallStmt):
        return False
    if not _is_loop_header(h, blocks, idom):
        return False
    call = h.stmts[-1]

    pre = h.stmts[:-1]
    if not _pure_moves(pre, D):
        return False
    if not (is_pseudo(call.fn, "a") or is_pseudo(call.fn)) or call.args.items or call.args.tail is not None:
        return False
    it = call.fn
    if not (isinstance(h.cond, TempVal) and h.cond.t == call.t and h.cond.i == 1):
        return False
    bb = blocks[h.succ[0]]
    if h.id not in _reachable_from([bb.id], blocks):
        return False
    vpairs, rest = _extract_gen_vars(bb, call.t, D)
    if not vpairs:
        return False
    if any( i != idx + 2 for idx, (i, _) in enumerate(vpairs) ):
        tcounts = _temp_use_counts(blocks, D)
        if tcounts.get(call.t, 0) != 1 + len(vpairs):
            return False
    vars_ = []
    nxt_slot = 2
    for slot_i, reg_n in vpairs:
        while nxt_slot < slot_i:
            vars_.append(_fresh_reg(blocks) + nxt_slot)
            nxt_slot += 1
        vars_.append(reg_n)
        nxt_slot = slot_i + 1

    preps = []
    for p in h.preds:
        pb = blocks[p]
        for s in pb.stmts:
            if isinstance(s, D.Assign) and isinstance(s.target, Pseudo) and s.target.name == it.name and \
                    s.target.depth == it.depth and isinstance(s.value, D.GenIter):
                preps.append((pb, s))
    if len(preps) > 1:
        def is_it(x):
            return isinstance(x, D.Assign) and isinstance(x.target, Pseudo) and x.target.name == it.name \
                and x.target.depth == it.depth and isinstance(x.value, D.GenIter)
        nb = join_preps(h, blocks, [pb for pb, _ in preps], is_it)
        if nb is not None:
            preps = [(nb, nb.stmts[-1])]
    if len(preps) != 1:
        return False
    pb, ps = preps[0]
    args = ps.value.args
    items = list(args.items[1:]) if args is not None else []   
    if pre:

        written = {s.target.n for s in pre if isinstance(s.target, Reg)}
        if any(isinstance(x, Reg) and x.n in written for e in (args.items if args else []) for x in _walk(e)):
            return False
    bb.stmts = rest
    if pre:
        _moves_to_latches(h, pb, pre, blocks)
    h.stmts = []
    h.kind = "forin"
    h.cond = None
    if args is not None and args.tail is not None:
        import codegen
        items.append(codegen.TailRef(args.tail))      
    lst = LoopExprs(items)
    h.values = (vars_, lst)
    place_prep(pb, lst, D, lambda s: s is ps)
    if pre:
        import copy
        pb.stmts += [copy.copy(s) for s in pre]
    return True

def _walk(e):
    st = [e]
    while st:
        x = st.pop()
        yield x
        if hasattr(x, "__dict__"):
            st += [v for v in x.__dict__.values() if hasattr(v, "__dict__") and not isinstance(v, type)]

class LoopExprs(list):
    """The expressions of a for header (start, limit, step / the iterator
    triple). They are evaluated once, before the loop: the prep block holds a
    ForPrep statement that owns them (uses, renaming, inlining), the header
    keeps this same list for rendering."""

def place_prep(pb, lst, D, is_prep):
    """Put ForPrep(lst) in the prep block after its last loop-prep statement."""
    at = None
    for i, s in enumerate(pb.stmts):
        if is_prep(s):
            at = i
    pb.stmts.insert(len(pb.stmts) if at is None else at + 1, D.ForPrep(lst))

def join_preps(h, blocks, pbs, is_prep):
    """Several predecessors of loop header h end with the same prep
    statements (the header was reached with two front end states, merged
    later): move the prep into one new block that they all go to. Returns
    that block, or None if the preps differ or are not the blocks' last
    statements before a plain jump to h."""
    import ir
    import structure
    tails = []
    for pb in pbs:
        if pb.kind != "goto" or pb.succ != [h.id]:
            return None
        k = len(pb.stmts)
        while k > 0 and is_prep(pb.stmts[k - 1]):
            k -= 1
        if k == len(pb.stmts) or any(is_prep(x) for x in pb.stmts[:k]):
            return None
        tails.append(k)
    texts = {tuple(ir.fmt_stmt(x) for x in pb.stmts[k:]) for pb, k in zip(pbs, tails)}
    if len(texts) != 1:
        return None
    nb = structure.Block(max(blocks) + 1)
    nb.stmts = list(pbs[0].stmts[tails[0]:])
    nb.kind = "goto"
    nb.succ = [h.id]
    nb.origin = pbs[0].origin
    blocks[nb.id] = nb
    for pb, k in zip(pbs, tails):
        del pb.stmts[k:]
        pb.succ = [nb.id]
    _recompute(blocks)
    return nb

def _recompute(blocks):
    for b in blocks.values():
        b.preds = []
    for b in blocks.values():
        for s in b.succ:
            if s in blocks:
                blocks[s].preds.append(b.id)
