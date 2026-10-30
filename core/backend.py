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

    def _conv_pseudo(x):
        if isinstance(x, Pseudo):
            key = (x.name, x.depth)
            nm = pseudo_map.get(key)
            if nm is None:
                nm = "iter_%s_%d" % (x.name, x.depth)
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
    body = IDI.drop_blank_branches(body)
    body = IDI.fold_pack_idioms(body, own)
    body = IDI.eliminate_dead_code(body, own)
    body = IDI.and_or(body)
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
    body = VR.declare(body, (), own)
    body = VR.limit_locals(body)
    params = VR.extract_params(body)
    rend = CG.Renderer(names)
    return rend.block(body, ""), params, nerr, sr.fallbacks

def polish(text):
    """Whole-program text passes: localfuncs, AST dead-param/dead-local/IIFE
    cleanup, semantic local naming (names.py, unless DEVIRT_NO_NAMES), and
    final localfuncs tidy. Each pass is skipped with a warning if it fails."""
    import codegen
    import localfuncs
    import ast_polish
    text = text.replace(codegen.LONG_NL, "\n")     
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
