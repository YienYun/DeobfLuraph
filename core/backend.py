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
    # Registers a frame binding names (`upnames[(up, register)]`) are real
    # values of the enclosing function, not holes of this one.
    frame_bound = {k[1] for k in (upnames or {})
                   if isinstance(k, tuple) and len(k) == 2 and isinstance(k[1], int)}
    dropped = ST.poison_unknown_callees(entry, blocks, D, frame_bound,
                                       lambda s0: VR.LIFT_STATS.setdefault(
                                           "poison_sites", []).append(
                                               (getattr(s0, "pc_mode", None),
                                                getattr(s0, "pc_arrays", None))))
    if dropped:
        VR.LIFT_STATS["unknown_callee"] = VR.LIFT_STATS.get("unknown_callee", 0) + dropped
    CG.simplify_blocks(blocks, D)
    names = {("up", i): nm for i, nm in (upnames or {}).items()}
    # The parent's names are fixed text; this function's own registers must step
    # around them, or a local hides a capture the closure body reads.
    up_taken = {nm for nm in names.values() if isinstance(nm, str) and nm != "nil"}
    own = set(VR.rename(entry, blocks, prefix, set(), avoid=up_taken).values())

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
    # The v15 build seeds every protected function with a number it only ever
    # hashes against itself. Those chains are the obfuscator's integrity trail,
    # never the script's logic: drop the ones nothing can read, then the seeds
    # themselves, and repeat until neither has anything left to say.
    try:
        import deadstore
        import seeds
        totals = {"dead": 0, "seeds": 0, "statements": 0, "calls": 0}
        for _round in range(4):
            text, ds = deadstore.strip(text)
            text, sd = seeds.strip(text)
            totals["dead"] += ds.get("removed", 0)
            totals["seeds"] += sd.get("seeds", 0)
            totals["statements"] += sd.get("statements", 0)
            totals["calls"] += sd.get("calls", 0)
            if not ds.get("removed") and not sd.get("seeds"):
                break
        if totals["dead"] or totals["seeds"]:
            print("[*] seed cleanup: %d dead store(s), %d seed(s), %d statement(s), "
                  "%d u32 call(s) removed"
                  % (totals["dead"], totals["seeds"], totals["statements"], totals["calls"]),
                  file=sys.stderr)
    except Exception as ex:
        print("[!] seed cleanup failed: %s" % ex, file=sys.stderr)
    # Register copies (`data2 = data3` straight before the next use) are the VM
    # refilling a slot, not a decision of the script; naming the source at the
    # use sites takes the hop out.
    try:
        import copies
        text, cp = copies.propagate(text)
        if cp.get("inlined") or cp.get("temps"):
            print("[*] registers: %d copy(ies) inlined, %d temporary(ies) folded, "
                  "%d dead declaration(s) dropped"
                  % (cp.get("inlined", 0), cp.get("temps", 0), cp.get("dropped", 0)),
                  file=sys.stderr)
    except Exception as ex:
        print("[!] copy pass failed: %s" % ex, file=sys.stderr)
    # Folding a copy takes the reads that kept the register alive with it, so
    # the stores it leaves behind are dead and worth a second sweep.
    try:
        import deadstore as _deadstore
        text, after = _deadstore.strip(text)
        if after.get("removed"):
            print("[*] dead stores after copy folding: %d removed"
                  % after["removed"], file=sys.stderr)
    except Exception as ex:
        print("[!] post-copy dead store pass failed: %s" % ex, file=sys.stderr)
    # The u32 arithmetic a v15 build leaves behind is exact: folding it turns a
    # state machine's seed chain into the constants it computes, which is what
    # the control-flow passes need in order to see what a branch tests.
    try:
        import u32fold
        folded, u32stats = u32fold.fold_text(text)
        if u32stats.get("edits"):
            print("[*] u32 fold: %d expression(s) -> constants (%d u32 call(s) left, was %d)"
                  % (u32stats["edits"], u32stats.get("left", -1),
                     len(u32fold._CALL_RE.findall(text))), file=sys.stderr)
            text = folded
    except Exception as ex:
        print("[!] u32 fold pass failed: %s" % ex, file=sys.stderr)
    # Control flow the obfuscator flattened into a loop over constants is
    # unrolled first, then the AST cleanup drops the loop's dead prelude and
    # simplifies what the unrolling exposed -- twice, because the second round
    # sees bounds the first one could not (the prelude is gone, not overwritten).
    try:
        import flatten
        for _ in range(2):
            text, _fl = flatten.apply_text(text)
            text = ast_polish.polish_ast(text, slot_names=False)
    except Exception as ex:
        print("[!] flatten/ast polish pass failed: %s" % ex, file=sys.stderr)
        try:
            text = ast_polish.polish_ast(text, slot_names=False)
        except Exception as ex2:
            print("[!] ast polish pass failed: %s" % ex2, file=sys.stderr)
    # Parentheses the lifter recorded around whole expressions say nothing; the
    # tidier drops the ones no operator can rebind.
    try:
        import tidy
        groups = 0
        for _round in range(3):
            text, removed = tidy.strip_groups(text)
            groups += removed
            if not removed:
                break
        if groups:
            print("[*] parentheses: %d redundant group(s) removed" % groups, file=sys.stderr)
        text, extra = tidy.drop_extra_args(text)
        if extra:
            print("[*] seed arguments: %d call(s) trimmed to the function's arity"
                  % extra, file=sys.stderr)
    except Exception as ex:
        print("[!] parenthesis tidy failed: %s" % ex, file=sys.stderr)
    if not os.environ.get("DEVIRT_NO_NAMES"):
        import names
        try:
            text = names.rename_text(text)
            # A second pass sees the field names the first one invented, so a
            # local that only copies one can take that name (`local state =
            # context.state` instead of `local value5 = ...`). It settles here:
            # a third pass is byte-identical, so stop as soon as one changes
            # nothing.
            for _ in range(2):
                again = names.rename_text(text)
                if again == text:
                    break
                text = again
        except Exception as ex:  
            print("[!] naming pass failed: %s" % ex, file=sys.stderr)
    # One printed name, one binding: a duplicate declaration and a closure's
    # name reused for a later value are split here, after naming (so the names
    # the reader sees are the ones being split) and before the final tidy.
    # DEVIRT_NO_NAMESPLIT keeps the shared names, for bisecting a diff.
    if not os.environ.get("DEVIRT_NO_NAMESPLIT"):
        try:
            import namesplit
            text, _ns = namesplit.apply_duplicates(text)
            text, _ns = namesplit.apply_reuse(text)
        except Exception as ex:
            print("[!] name split pass failed: %s" % ex, file=sys.stderr)
    try:
        text = localfuncs.rewrite(text)
    except Exception as ex:  
        print("[!] local function pass failed: %s" % ex, file=sys.stderr)
    # Last, because it names what the script stores in its own `data[k]` helper
    # table from what is stored there: the passes above rename locals by use, and
    # giving them an alias to reason about first would change their result.
    # DEVIRT_NO_SLOTNAMES keeps the numbered slots, for bisecting a diff.
    if not os.environ.get("DEVIRT_NO_SLOTNAMES"):
        text = ast_polish.name_context_slots(text)
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
