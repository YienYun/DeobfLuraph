import os
import sys
import threading

def lower(entry_key, order, D, link, prefix, upnames, closure):
    """Luau lines of one function.

    D        the IR module (ir.py, or a front end that re-exports it)
    link     passed to state.key() for successor keys (the front end's loop-stack link)
    prefix   register name prefix for this nesting depth
    upnames  {upvalue index: name} of the function's upvalues
    closure  closure(ClosureExpr, names) -> codegen.FuncE: lifts a child
             function once its captured variables have names

    Returns (lines, params, unlifted block count, unstructured jump count)."""
    import structure as ST
    import codegen as CG
    import loops as LP
    import variables as VR
    import idioms as IDI
    from luasym import ClosureExpr, Pseudo
    entry, blocks = ST.build_cfg(entry_key, order, D, link)
    if os.environ.get("DEVIRT_NO_GUARD_PRUNE") is None:
        ST.prune_constant_guards(entry, blocks)
    ST.prune_after_trap(entry, blocks)
    ST.drop_unreachable(entry, blocks)
    if not os.environ.get("DEVIRT_NO_MERGE"):
        entry, _ = ST.merge_equivalent(entry, blocks, D)
    entry = ST.thread_empty(entry, blocks)
    LP.recognize(entry, blocks, D)

    entry = ST.thread_empty(entry, blocks)
    CG.simplify_blocks(blocks, D)
    own = set(VR.rename(entry, blocks, prefix, set()).values())
    names = {("up", i): nm for i, nm in (upnames or {}).items()}

    # Convert any rare surviving loop Pseudo variables (irreducible state-machine loops)
    # into real declared locals with flat-yielding GenIterE so zero globals ever leak.
    pseudo_map = {}
    pseudo_seq = [0]

    def _conv_pseudo(x):
        if isinstance(x, Pseudo):
            key = (x.name, x.depth)
            nm = pseudo_map.get(key)
            if nm is None:
                # These hold the coroutine-wrapped generator of a loop the
                # structurer could not rebuild as a `for`. `iter_z_1` was a
                # register name wearing a prefix; call the thing what it is.
                pseudo_seq[0] += 1
                nm = "iterator" if pseudo_seq[0] == 1 else "iterator%d" % pseudo_seq[0]
                while nm in own:
                    nm += "_"
                own.add(nm)
                pseudo_map[key] = nm
            return CG.LocalName(nm)
        return None

    def conv(x):
        if isinstance(x, Pseudo):
            return _conv_pseudo(x)
        return closure(x, names) if isinstance(x, ClosureExpr) else None
    for b in blocks.values():
        for i, s_ in enumerate(b.stmts):
            if isinstance(s_, CG.AssignS):
                if len(s_.targets) == 1 and isinstance(s_.targets[0], Pseudo) \
                        and len(s_.values.items) == 1 and isinstance(s_.values.items[0], CG.GenIterE):
                    s_.values.items[0].flat = True
                s_.values = CG.map_multi(s_.values, conv)
                s_.targets = [_conv_pseudo(t) if isinstance(t, Pseudo)
                              else (t if isinstance(t, CG.LocalName) else CG.map_expr(t, conv))
                              for t in s_.targets]
            elif isinstance(s_, (CG.CallS, CG.TempDef, CG.SetListS, CG.ForPrepS)):
                b.stmts[i] = CG.map_stmt(s_, lambda e: CG.map_expr(e, conv), lambda m: CG.map_multi(m, conv))
        if b.kind == "cond":
            b.cond = CG.map_expr(b.cond, conv)
        elif b.kind == "ret" and b.values is not None:
            b.values = CG.map_multi(b.values, conv)

    nerr = sum(1 for b in blocks.values() if b.kind == "error")
    entry, body, sr = ST.structure(entry, blocks, own)
    body = ST.cleanup(body)
    body = IDI.fold_constant_conds(body)
    body = IDI.drop_blank_branches(body)
    body = IDI.fold_pack_idioms(body, own)
    body = IDI.eliminate_dead_code(body, own)
    body = IDI.and_or(body)
    body = IDI.fold_u32_masks(body)
    body = IDI.fold_single_use(body)
    body = IDI.fold_pack_idioms(body, own)
    body = IDI.while_cond(body)
    body = IDI.strip_trailing_continue(body)
    body = IDI.conditions(body)
    body = IDI.while_cond(body)     
    body = IDI.strip_trailing_continue(body)
    body = IDI.loop_vars(body)
    body = IDI.strip_trailing_return(body)
    if getattr(D, "INLINE_CONST_LOCALS", False):
        body = IDI.inline_const_locals(body)
        body = IDI.fold_single_use(body)
    body = IDI.eliminate_dead_code(body, own)
    body = IDI.flatten_nested_ifs(body, own)
    body = _name_stray_regs(body, own)
    body = VR.declare(body, (), own)
    body = VR.limit_locals(body)
    params = VR.extract_params(body)
    rend = CG.Renderer(names)
    text = rend.block(body, "")
    # report the stubs that actually reach the output: a block the structuring
    # pass never emits (behind a return/break) is dead code, not a lost one
    if nerr:
        nerr = text.count('error("devirt:')
    fallbacks = sr.fallbacks + (1 if getattr(sr, "state_machine", False) else 0)
    return text, params, nerr, fallbacks


def _name_stray_regs(node, own):
    """Give a name to every register that the def/use analysis never saw.

    A few handlers build expressions (a shared runtime call's arguments, a
    loop header's expressions) outside the statement list the analysis walks,
    so their registers keep the raw `r<N>` name and would render as reads of
    an undefined global. Those slots are never written in this function, so a
    local (nil) is exactly what they hold."""
    import codegen as CG
    from luasym import Reg

    def fix(x):
        if isinstance(x, Reg):
            nm = "r%s" % x.n
            own.add(nm)
            return CG.LocalName(nm)
        if isinstance(x, list):
            for i, v in enumerate(x):
                x[i] = fix(v)
            return x
        if isinstance(x, tuple):
            return tuple(fix(v) for v in x)
        if isinstance(x, dict):
            for k, v in list(x.items()):
                x[k] = fix(v)
            return x
        if isinstance(x, (str, bytes, int, float, bool, set, frozenset, type)) or x is None:
            return x
        d = getattr(x, "__dict__", None)
        if d is not None:
            for k, v in list(d.items()):
                if k.startswith("_"):
                    continue
                d[k] = fix(v)
        return x

    return fix(node)

def polish(text):
    """Whole-program text passes: localfuncs, AST dead-param/dead-local/IIFE
    cleanup, semantic local naming (names.py, unless DEVIRT_NO_NAMES), and
    final localfuncs tidy. Each pass is skipped with a warning if it fails."""
    import codegen
    import localfuncs
    import ast_polish
    text = text.replace(codegen.LONG_NL, "\n")
    if os.environ.get("POLISH_DUMP"):
        # debugging aid: keep the text exactly as the lifter produced it, so the
        # polish passes can be replayed on it without a two-minute re-lift
        with open(os.environ["POLISH_DUMP"], "w", encoding="utf-8", newline="\n") as fh:
            fh.write(text)
    
    try:
        text = localfuncs.rewrite(text)
    except Exception as ex:  
        print("[!] pre-localfuncs pass failed: %s" % ex, file=sys.stderr)
    try:
        text = ast_polish.polish_ast(text)
    except Exception as ex:
        print("[!] ast polish pass failed: %s" % ex, file=sys.stderr)
    if not os.environ.get("DEVIRT_NO_NAMES"):
        import names
        try:
            text = names.rename_text(text)
        except Exception as ex:  
            print("[!] naming pass failed: %s" % ex, file=sys.stderr)
    try:
        text = localfuncs.rewrite(text)
    except Exception as ex:  
        print("[!] local function pass failed: %s" % ex, file=sys.stderr)
    return text

def finish_text(text):
    """Blank lines between blocks (only for the final output, not every round)."""
    import spacing
    return spacing.space(text)

def run_big_stack(fn, *a):
    """Deeply nested scripts need deep recursion: run in a thread with a big stack."""
    sys.setrecursionlimit(200000)
    threading.stack_size(256 * 1024 * 1024 - 4096)
    res = {}

    def target():
        try:
            res["v"] = fn(*a)
        except BaseException as ex:  
            res["e"] = ex
    t = threading.Thread(target=target)
    t.start()
    t.join()
    if "e" in res:
        raise res["e"]
    return res.get("v")
