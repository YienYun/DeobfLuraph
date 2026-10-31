import codegen as CG
import structure as ST
from luasym import Un, Bin, Const

def key(e):
    k = CG.expr_key(e)
    return None if k.startswith("X") else k

def single_assign(stmts):
    """stmts is exactly `x = v` (one local target, one value): (name, value)."""
    if len(stmts) != 1:
        return None
    st = stmts[0]
    if isinstance(st, CG.AssignS) and len(st.targets) == 1 and isinstance(st.targets[0], CG.LocalName) \
            and len(st.values.items) == 1 and st.values.tail is None and not getattr(st, "is_local", False):
        return st.targets[0].name, st.values.items[0]
    return None

def reads(e, name):
    return any(isinstance(x, CG.LocalName) and x.name == name for x in CG.walk(e))

def assign(name, value):
    return CG.AssignS([CG.LocalName(name)], CG.Multi([value]))

def match_if(st):
    """An if statement that is really `x = <and/or expression>`, or None."""
    t = single_assign(st.then)
    if t is None:
        return None
    name, a = t
    c = st.cond
    neg = isinstance(c, Un) and c.op == "Not"
    base = c.a if neg else c
    op = "Or" if neg else "And"
    if not st.els:

        if isinstance(base, CG.LocalName) and base.name == name:
            return assign(name, Bin(op, CG.LocalName(name), a))

        kb = key(base)
        if kb is not None and key(a) == kb:
            return assign(name, Bin("And" if neg else "Or", base, CG.LocalName(name)))
        return None
    e = single_assign(st.els)
    if e is None or e[0] != name:
        return None
    kb = key(base)
    if kb is not None and key(e[1]) == kb:

        return assign(name, Bin(op, base, a))
    if kb is not None and key(a) == kb:

        return assign(name, Bin("And" if neg else "Or", base, e[1]))
    return None

def and_or(stmts):
    out = ST.SBlock()
    for st in stmts:
        if isinstance(st, ST.SIf):
            st.then = and_or(st.then)
            st.els = and_or(st.els)
            r = match_if(st)
            if r is not None:
                st = r
        elif isinstance(st, ST.SLoop):
            st.body = and_or(st.body)
        prev = single_assign([out[-1]]) if out and isinstance(out[-1], CG.AssignS) else None

        if prev and isinstance(st, ST.SIf) and not st.els:
            t = single_assign(st.then)
            neg = isinstance(st.cond, Un) and st.cond.op == "Not"
            base = st.cond.a if neg else st.cond
            kb = key(base)
            if t and t[0] == prev[0] and kb is not None and key(prev[1]) == kb \
                    and not reads(base, t[0]) and not reads(t[1], t[0]):
                out[-1] = assign(t[0], Bin("Or" if neg else "And", prev[1], t[1]))
                continue

        if prev and isinstance(st, CG.AssignS):
            cur = single_assign([st])
            if cur and cur[0] == prev[0]:
                v = cur[1]
                if isinstance(v, Bin) and v.op in ("And", "Or") and isinstance(v.a, CG.LocalName) \
                        and v.a.name == cur[0] and not reads(v.b, cur[0]):
                    out[-1] = assign(cur[0], Bin(v.op, prev[1], v.b))
                    continue
        out.append(st)
    return out

def _stmt_exprs(st):
    """Expressions a statement evaluates (not nested statement blocks)."""
    out = []
    if isinstance(st, CG.AssignS):
        out += [t for t in st.targets if not isinstance(t, CG.LocalName)]
        out += list(st.values.items)
        if st.values.tail is not None:
            out.append(CG.TailRef(st.values.tail))
    elif isinstance(st, (CG.CallS, CG.TempDef)):
        out.append(st.call)
    elif isinstance(st, CG.SetListS):
        out.append(st.tbl)
        out += list(st.values.items)
        if st.values.tail is not None:
            out.append(CG.TailRef(st.values.tail))
    elif isinstance(st, CG.ForPrepS):
        out += list(st.exprs)
    elif isinstance(st, ST.SIf):
        out.append(st.cond)
    elif isinstance(st, ST.SLoop):
        if st.cond is not None:
            out.append(st.cond)
        if st.forinfo:
            out += [x for x in st.forinfo[1] if x is not None]
    elif isinstance(st, ST.SReturn) and st.values is not None:
        out += list(st.values.items)
        if st.values.tail is not None:
            out.append(CG.TailRef(st.values.tail))
    return [e for e in out if e is not None]

def _sub_blocks(st):
    if isinstance(st, ST.SIf):
        return [st.then, st.els]
    if isinstance(st, ST.SLoop):
        return [st.body]
    return []

def name_counts(stmts, reads=None, writes=None, text=None):
    """Reads / writes of every LocalName in a function body; `text` collects
    the source of nested functions (FuncE, already rendered)."""
    import re
    if reads is None:
        reads, writes, text = {}, {}, []
    for st in stmts:
        if isinstance(st, CG.AssignS):
            for t in st.targets:
                if isinstance(t, CG.LocalName):
                    writes[t.name] = writes.get(t.name, 0) + 1
        if isinstance(st, ST.SLoop) and st.forinfo:
            for v in (st.forinfo[0] if isinstance(st.forinfo[0], (list, tuple)) else [st.forinfo[0]]):
                if isinstance(v, CG.LocalName):
                    writes[v.name] = writes.get(v.name, 0) + 2
        for e in _stmt_exprs(st):
            for x in CG.walk(e):
                if isinstance(x, CG.LocalName):
                    reads[x.name] = reads.get(x.name, 0) + 1
                elif isinstance(x, CG.FuncE):
                    text.append("\n".join(x.lines))
        for b in _sub_blocks(st):
            name_counts(b, reads, writes, text)
    if not hasattr(name_counts, "_re"):
        name_counts._re = re
    return reads, writes, text

def _positions(body):
    """Pre-order numbering of the statements: id -> [index, last index of its
    subtree, the block holding it, the statement holding that block], plus
    the read sites (name -> ids of the statements whose own expressions read
    it, once per read) and write sites (name -> AssignS statements). None if
    the body has a state machine (no textual order)."""
    pos, rsites, wsites = {}, {}, {}
    n = [0]

    def walk(stmts, parent):
        for st in stmts:
            if isinstance(st, (ST.SStateMachine, ST.SGotoState)):
                raise ValueError
            i = n[0]
            n[0] += 1
            info = [i, i, stmts, parent]
            pos[id(st)] = info
            for e in _stmt_exprs(st):
                for x in CG.walk(e):
                    if isinstance(x, CG.LocalName):
                        rsites.setdefault(x.name, []).append(id(st))
            if isinstance(st, CG.AssignS):
                for t in st.targets:
                    if isinstance(t, CG.LocalName):
                        wsites.setdefault(t.name, []).append(st)
            for b in _sub_blocks(st):
                walk(b, st)
            info[1] = n[0] - 1
    try:
        walk(body, None)
    except ValueError:
        return None
    return pos, rsites, wsites

def _same_text(a, b):
    if a is b:
        return True
    r = CG.Renderer()
    return r.expr(a) == r.expr(b)

def _eval_list(st):
    """What a statement evaluates, in Luau order (post-order nodes), or None.
    A subtree shared by a NAMECALL's object and self argument (`f(x):M()`)
    runs once: only its first occurrence counts."""
    seen = set()
    out = []

    def order(e):
        if e is None:
            return
        kids = CG.children(e)
        if kids and not isinstance(e, CG.ClosureExpr):
            if id(e) in seen:
                return
            seen.add(id(e))
            if isinstance(e, CG.CallE) and isinstance(e.fn, CG.Index) and e.args.items \
                    and type(e.fn.obj) is type(e.args.items[0]) and CG.children(e.fn.obj) \
                    and _same_text(e.fn.obj, e.args.items[0]):

                order(e.fn)
                for c in kids[2:]:
                    order(c)
            elif isinstance(e, CG.NewTableE):
                for k, v in e.items:      
                    order(k)
                    order(v)
                if e.tail is not None:
                    order(CG.TailRef(e.tail))
            else:
                for c in kids:          
                    order(c)
        out.append(e)
    if isinstance(st, ST.SIf):
        order(st.cond)
    elif isinstance(st, CG.CallS):
        order(st.call)
    elif isinstance(st, CG.AssignS):
        for t in st.targets:
            if isinstance(t, CG.Index):
                order(t.obj)
                order(t.key)
        for x in st.values.items:
            order(x)
        if st.values.tail is not None:
            order(CG.TailRef(st.values.tail))
    elif isinstance(st, ST.SReturn) and st.values is not None:
        for x in st.values.items:
            order(x)
        if st.values.tail is not None:
            order(CG.TailRef(st.values.tail))
    else:
        return None
    return out

def _conditional(e, acc):
    """ids of the nodes of e that are evaluated only sometimes (and/or right sides)."""
    def mark(x):
        for y in CG.walk(x):
            acc.add(id(y))
    if isinstance(e, Bin) and e.op in ("And", "Or"):
        mark(e.b)
    elif isinstance(e, CG.IfExp):
        mark(e.a)
        mark(e.b)
    for c in CG.children(e):
        _conditional(c, acc)
    return acc

def _fold_table_store(prev_st, st):
    """x = {...}; x.k = V  ->  x = {..., k = V} (codegen's fold_tables does this
    on the CFG; a V built from and/or branches only becomes one expression
    after structuring). Adjacent statements, V and k don't read x, the table
    has no multret tail; a number key only as the next array slot (explicit
    number keys and positional items don't mix in a constructor)."""
    if not (isinstance(prev_st, CG.AssignS) and len(prev_st.targets) == 1
            and isinstance(prev_st.targets[0], CG.LocalName) and len(prev_st.values.items) == 1
            and prev_st.values.tail is None and isinstance(prev_st.values.items[0], CG.NewTableE)):
        return False
    tbl = prev_st.values.items[0]
    name = prev_st.targets[0].name
    if tbl.tail is not None or not (isinstance(st, CG.AssignS) and len(st.targets) == 1
                                    and len(st.values.items) == 1 and st.values.tail is None):
        return False
    t = st.targets[0]
    if not (isinstance(t, CG.Index) and isinstance(t.obj, CG.LocalName) and t.obj.name == name
            and isinstance(t.key, CG.Const)):
        return False
    v = st.values.items[0]
    if reads(v, name):
        return False
    k = t.key.v
    if isinstance(k, (str, bytes)):
        if any(isinstance(kk, CG.Const) and kk.v == k for kk, _ in tbl.items):
            return False
        prev_st.values = CG.Multi([CG.NewTableE(tbl.items + [(t.key, v)])])
        return True
    if isinstance(k, (int, float)) and not isinstance(k, bool) and k == CG.count_array(tbl) + 1 \
            and not any(kk is not None for kk, _ in tbl.items if not (isinstance(kk, CG.Const) and isinstance(kk.v, (str, bytes)))):
        prev_st.values = CG.Multi([CG.NewTableE(tbl.items + [(None, v)])])
        return True
    return False

def _last_value(e, x):
    """Is x the last value of call e's arguments / constructor e's array items?"""
    if isinstance(e, CG.CallE):
        return e.args.tail is None and bool(e.args.items) and e.args.items[-1] is x
    if isinstance(e, CG.NewTableE):
        return e.tail is None and bool(e.items) and e.items[-1][0] is None and e.items[-1][1] is x
    return False

def fold_single_use(body):
    """x = V; <stmt reading x once>  ->  <stmt with V>
      local flag = a and b; if flag then   ->  if a and b then
      local u = _G.U; local t = u or {}    ->  local t = _G.U or {}
      local o = up; o.k = a and b or c     ->  up.k = a and b or c
    Consecutive temps fold one after another into the same statement
    (`local f = o.M; local a = g(); f(o, a)`  ->  `o:M(g())`).
    V moves past no call: in the statement's evaluation order only reads,
    indexing and and/or/not come before the read of x (codegen's
    `call_before` rule), and a V with calls is never moved into an and/or
    right side. x is read nowhere else afterwards (also not in closures):
    other reads must come textually before `x = V`, and inside a loop x
    must be written earlier in the same iteration by a statement every
    path to `x = V` runs (Luraph reuses registers, so one variable can
    hold several short-lived values: `x = x and y; use(x)`)."""
    import re
    nreads, writes, text = name_counts(body)
    alltext = "\n".join(text)
    text_tokens = set(re.findall(r"(?<![\w.])[A-Za-z_]\w*", alltext)) if alltext else set()
    where = _positions(body)

    def in_text(name):
        return name in text_tokens

    def dead_after(name, prev_st, st, n_in_v):
        """Is the value `prev_st` gives x read only by st (and x's other reads harmless)?"""
        others = nreads.get(name, 0) - n_in_v
        if where is None:
            return False
        pos, rsites, wsites = where
        sites = rsites.get(name, [])
        ip = pos[id(prev_st)][0]
        idxs = [pos[s][0] for s in sites if s != id(st)]
        if len(sites) != others + n_in_v:
            return False        
        if any(i > ip for i in idxs):
            return False

        chain = []
        cur = prev_st
        loop = None
        while True:
            info = pos.get(id(cur))
            if info is None:
                return False
            chain.append(info[2])
            parent = info[3]
            if parent is None:
                break
            if isinstance(parent, ST.SLoop):
                loop = parent
                break
            cur = parent
        if loop is None:
            return True
        lo, hi = pos[id(loop)][0], pos[id(loop)][1]
        outer = pos[id(loop)][3]
        while outer is not None and not isinstance(outer, ST.SLoop):
            outer = pos[id(outer)][3]
        inside = [i for i in idxs if lo <= i <= hi]
        if len(inside) != len(idxs) and (outer is not None or any(i > lo for i in idxs if i not in inside)):
            return False

        first = min(inside) if inside else None
        for w in wsites.get(name, []):
            info = pos.get(id(w))
            if info is None or not any(info[2] is b for b in chain):
                continue
            iw = info[0]
            if w is prev_st:
                if n_in_v == 0 and (first is None or first > iw):
                    return True
                continue
            if iw < ip and (first is None or first > iw) and \
                    not any(reads(e, name) for e in _stmt_exprs(w)):
                return True
        return False

    def try_fold(prev_st, st):
        prev = single_assign([prev_st])
        if prev is None:
            return False
        name, v = prev
        if in_text(name):
            return False
        if isinstance(v, (CG.FuncE, CG.ClosureExpr)):
            return False        
        order = _eval_list(st)
        if order is None:
            return False
        hits = [x for x in order if isinstance(x, CG.LocalName) and x.name == name]
        if not hits:
            return False

        n_self = sum(1 for x in order if isinstance(x, CG.CallE) and isinstance(x.fn, CG.Index)
                     and isinstance(x.fn.obj, CG.LocalName) and x.fn.obj.name == name and x.args.items
                     and isinstance(x.args.items[0], CG.LocalName) and x.args.items[0].name == name)
        if len(hits) - n_self != 1:
            return False
        if CG.expands(v) and any(_last_value(x, hits[0]) for x in order):
            return False        
        if isinstance(st, ST.SReturn) and CG.expands(v) and st.values.tail is None \
                and st.values.items and st.values.items[-1] is hits[0]:
            return False        
        for x in order:
            if x is hits[0]:
                break
            if isinstance(x, (CG.CallE, CG.ClosureExpr, CG.FuncE)):
                return False
        if CG.has_side_effects(v):
            cond = set()
            for e in _stmt_exprs(st):
                _conditional(e, cond)
            if id(hits[0]) in cond:
                return False
        n_in_v = sum(1 for x in CG.walk(v) if isinstance(x, CG.LocalName) and x.name == name)
        raw_in_st = sum(1 for e in _stmt_exprs(st) for x in CG.walk(e) if isinstance(x, CG.LocalName) and x.name == name)
        simple_case = writes.get(name) == 1 and n_in_v == 0 and nreads.get(name) == raw_in_st
        if not simple_case and not dead_after(name, prev_st, st, n_in_v):
            return False

        def sub(e):
            return CG.map_expr(e, lambda x: v if isinstance(x, CG.LocalName) and x.name == name else None)
        if isinstance(st, ST.SIf):
            st.cond = sub(st.cond)
        elif isinstance(st, CG.CallS):
            st.call = sub(st.call)
        elif isinstance(st, ST.SReturn):
            st.values = CG.map_multi(st.values, lambda x: v if isinstance(x, CG.LocalName)
                                     and x.name == name else None)
        else:
            st.targets = [t if isinstance(t, CG.LocalName) else sub(t) for t in st.targets]
            st.values = CG.map_multi(st.values, lambda x: v if isinstance(x, CG.LocalName)
                                     and x.name == name else None)

        nreads[name] = nreads.get(name, 0) - raw_in_st
        writes[name] = writes.get(name, 0) - 1
        if where is not None:
            pos, rsites, wsites = where
            sites = rsites.get(name, [])
            sites[:] = [s for s in sites if s != id(st)]
            for x in CG.walk(v):
                if isinstance(x, CG.LocalName):
                    lst = rsites.get(x.name, [])
                    lst[:] = [id(st) if s == id(prev_st) else s for s in lst]
            ws = wsites.get(name, [])
            ws[:] = [w for w in ws if w is not prev_st]
        return True

    def try_coalesce(prev_st, st):
        """a, x = f(); y = x  ->  a, y = f()  (x's value read only by the copy).
        Multiple results can't be inlined, and x's register is often reused
        later, so copy propagation leaves the copy."""
        if not (isinstance(prev_st, CG.AssignS) and isinstance(st, CG.AssignS)) \
                or getattr(prev_st, "is_local", False) or getattr(st, "is_local", False):
            return False
        if len(prev_st.targets) < 2 or len(st.targets) != 1 or len(st.values.items) != 1:
            return False
        y, x = st.targets[0], st.values.items[0]
        if not (isinstance(y, CG.LocalName) and isinstance(x, CG.LocalName)) or x.name == y.name:
            return False
        tnames = [t.name for t in prev_st.targets if isinstance(t, CG.LocalName)]
        if len(tnames) != len(prev_st.targets) or tnames.count(x.name) != 1 or y.name in tnames:
            return False
        if in_text(x.name):
            return False        
        if any(isinstance(e, CG.LocalName) and e.name in (x.name, y.name)
               for v in prev_st.values.items for e in CG.walk(v)):
            return False
        if not dead_after(x.name, prev_st, st, 0):
            return False
        prev_st.targets[tnames.index(x.name)] = y
        nreads[x.name] = nreads.get(x.name, 0) - 1
        writes[x.name] = writes.get(x.name, 0) - 1
        if where is not None:
            _pos, rsites, wsites = where
            lst = rsites.get(x.name, [])
            lst[:] = [s for s in lst if s != id(st)]
            ws = wsites.get(x.name, [])
            ws[:] = [w for w in ws if w is not prev_st]
            ws = wsites.get(y.name, [])
            ws[:] = [prev_st if w is st else w for w in ws]
        return True

    def run(stmts):
        out = []
        for st in stmts:
            for b in _sub_blocks(st):
                b[:] = run(b)
            if out and try_coalesce(out[-1], st):
                continue

            blanks = []
            if not isinstance(st, CG.CommentS):
                while out and isinstance(out[-1], CG.CommentS) and not out[-1].text:
                    blanks.append(out.pop())
            folded = False
            while out and isinstance(out[-1], CG.AssignS) and not getattr(out[-1], "is_local", False) \
                    and try_fold(out[-1], st):
                out.pop()
                folded = True
            if not folded:
                out += reversed(blanks)

            if out and not (isinstance(st, CG.AssignS) and len(st.targets) == 1
                            and isinstance(st.targets[0], CG.Index)
                            and isinstance(st.targets[0].obj, CG.LocalName)
                            and in_text(st.targets[0].obj.name)
                            and any(CG.has_side_effects(x) for x in st.values.items)) \
                    and _fold_table_store(out[-1], st):

                tname = st.targets[0].obj.name
                nreads[tname] = nreads.get(tname, 0) - 1
                if where is not None:
                    rs = where[1]
                    lst = rs.get(tname, [])
                    if id(st) in lst:
                        lst.remove(id(st))
                    for lst in rs.values():
                        lst[:] = [id(out[-1]) if s == id(st) else s for s in lst]
                continue
            out.append(st)
        return ST.SBlock(out) if isinstance(stmts, ST.SBlock) else out

    return run(body)

def loop_vars(stmts):
    """for k, v in f() where v is never read -> for k in f(); an unused first
    variable before a used one becomes `_`."""
    import re
    for st in stmts:
        for b in _sub_blocks(st):
            loop_vars(b)
        if isinstance(st, ST.SLoop) and st.kind == "forin" and st.forinfo and len(st.forinfo[0]) > 1:
            vs, it = st.forinfo
            rd, _, text = name_counts(st.body)
            alltext = "\n".join(text)
            text_tokens = set(re.findall(r"(?<![\w.])[A-Za-z_]\w*", alltext)) if alltext else set()

            def used(v):
                return rd.get(v.name, 0) > 0 or v.name in text_tokens

            vs = list(vs)
            while len(vs) > 1 and isinstance(vs[-1], CG.LocalName) and not used(vs[-1]):
                vs.pop()
            if len(vs) > 1 and isinstance(vs[0], CG.LocalName) and not used(vs[0]):
                vs[0] = CG.LocalName("_")
            st.forinfo = (vs, it)
    return stmts

def _truth(e):
    """Simplify an expression used only for its truthiness."""
    if isinstance(e, Bin) and e.op in ("And", "Or"):
        a, b = _truth(e.a), _truth(e.b)
        if e.op == "And" and isinstance(b, CG.Const) and b.v is True:
            return a                        
        if e.op == "Or" and isinstance(b, CG.Const) and b.v is False:
            return a                        
        return Bin(e.op, a, b)
    if isinstance(e, Un) and e.op == "Not" and isinstance(e.a, Un) and e.a.op == "Not":
        return _truth(e.a.a)                
    return e

def conditions(stmts):
    for st in stmts:
        if isinstance(st, ST.SIf):
            st.cond = _truth(st.cond)
        elif isinstance(st, ST.SLoop) and st.cond is not None and st.kind in ("whilecond", "repeat"):
            st.cond = _truth(st.cond)
        for b in _sub_blocks(st):
            conditions(b)
    return stmts

def _only_markers(block):
    """True when a branch holds nothing but this tool's own stubs/comments."""
    for st in block:
        if isinstance(st, (ST.SError, ST.SBreak, ST.SContinue, ST.SGotoState)):
            continue
        if isinstance(st, CG.CommentS):
            continue
        return False
    return True

def fold_constant_conds(stmts):
    """Drop a branch that can never run and holds only our own stub.

    A condition can end up as a literal when the value it tests was modelled
    as nil/true/false. The arm that cannot run is normally only an
    `error("devirt: ...")` marker left for an instruction that was not
    lifted -- removing it keeps the output free of stubs. Anything else is
    left alone: the code in that arm is real script code that a fold would
    silently delete."""
    out = []
    for st in stmts:
        if isinstance(st, ST.SIf):
            st.then = fold_constant_conds(st.then)
            st.els = fold_constant_conds(st.els)
            c = st.cond
            if isinstance(c, (CG.Const, Const)):
                live, dead = (st.then, st.els) if c.v not in (None, False) else (st.els, st.then)
                if _only_markers(dead):
                    out.extend(live)
                    continue
        else:
            for b in _sub_blocks(st):
                b[:] = fold_constant_conds(b)
        out.append(st)
    return out

def _has_continue(stmts):
    """A `continue` of the enclosing loop (not of loops nested in stmts)."""
    for st in stmts:
        if isinstance(st, ST.SContinue):
            return True
        if isinstance(st, ST.SIf) and (_has_continue(st.then) or _has_continue(st.els)):
            return True
    return False

def _only_break(block):
    real = [x for x in block if not (isinstance(x, CG.CommentS) and not x.text)]
    return len(real) == 1 and isinstance(real[0], ST.SBreak)

def while_cond(stmts):
    """while true do if C then break end ... end  ->  while not C do ... end
    (also `if C then <body> else break end`,
     `if C then <body> continue end break`  ->  while C do <body> end,
     `<body> if C then break end`  ->  repeat <body> until C)."""
    for st in stmts:
        if isinstance(st, ST.SIf):
            while_cond(st.then)
            while_cond(st.els)
        elif isinstance(st, ST.SLoop):
            while_cond(st.body)
            if st.kind != "while" or not st.body:
                continue

            body = [x for x in st.body if not (isinstance(x, CG.CommentS) and not x.text)]
            if not body:
                continue
            first = body[0]
            if isinstance(first, ST.SIf):

                first.then[:] = [x for x in first.then if not (isinstance(x, CG.CommentS) and not x.text)]                     if _only_break(first.then) else first.then
                first.els[:] = [x for x in first.els if not (isinstance(x, CG.CommentS) and not x.text)]                     if _only_break(first.els) else first.els
            if isinstance(first, ST.SIf) and len(first.then) == 1 and isinstance(first.then[0], ST.SBreak):
                st.kind, st.cond = "whilecond", ST.negate(first.cond)
                st.body = ST.SBlock(list(first.els) + list(body[1:]))
            elif isinstance(first, ST.SIf) and len(first.els) == 1 and isinstance(first.els[0], ST.SBreak):
                st.kind, st.cond = "whilecond", first.cond
                st.body = ST.SBlock(list(first.then) + list(body[1:]))
            elif len(body) == 2 and isinstance(first, ST.SIf) and isinstance(body[1], ST.SBreak)                     and not first.els and first.then and isinstance(first.then[-1], ST.SContinue):
                st.kind, st.cond = "whilecond", first.cond
                st.body = ST.SBlock(list(first.then[:-1]))
            elif len(body) >= 2 and isinstance(body[-1], ST.SIf) and not body[-1].els                     and len(body[-1].then) == 1 and isinstance(body[-1].then[0], ST.SBreak)                     and not _has_continue(body[:-1]):
                st.kind, st.cond = "repeat", body[-1].cond
                st.body = ST.SBlock(list(body[:-1]))
    return stmts

def strip_trailing_continue(stmts):
    """A `continue` that is the last thing an iteration does says nothing."""
    def tail(block):
        if block and isinstance(block[-1], ST.SContinue):
            block.pop()
        elif block and isinstance(block[-1], ST.SIf):
            tail(block[-1].then)
            tail(block[-1].els)
    for st in stmts:
        if isinstance(st, ST.SLoop):
            tail(st.body)
        for b in _sub_blocks(st):
            strip_trailing_continue(b)
    return stmts

def strip_trailing_return(body):
    """A bare `return` as the last statement of a function says nothing."""
    if body and isinstance(body[-1], ST.SReturn) and (
            body[-1].values is None or (not body[-1].values.items and body[-1].values.tail is None)):
        body.pop()
    return body

def _map_stmt_exprs(st, fn):
    """replace sub-expressions of a statement's own expressions (fn as in
    CG.map_expr); nested blocks are not visited"""
    if isinstance(st, CG.AssignS):
        st.targets = [t if isinstance(t, CG.LocalName) else CG.map_expr(t, fn) for t in st.targets]
        st.values = CG.map_multi(st.values, fn)
    elif isinstance(st, CG.CallS):
        st.call = CG.map_expr(st.call, fn)
    elif isinstance(st, CG.TempDef):
        st.call = CG.map_expr(st.call, fn)
    elif isinstance(st, CG.SetListS):
        st.tbl = CG.map_expr(st.tbl, fn)
        st.values = CG.map_multi(st.values, fn)
    elif isinstance(st, CG.ForPrepS):
        st.exprs[:] = [CG.map_expr(x, fn) for x in st.exprs]
    elif isinstance(st, ST.SIf):
        st.cond = CG.map_expr(st.cond, fn)
    elif isinstance(st, ST.SLoop):
        if st.cond is not None:
            st.cond = CG.map_expr(st.cond, fn)
        if st.forinfo:
            lst = st.forinfo[1]
            lst[:] = [CG.map_expr(x, fn) if x is not None else None for x in lst]
    elif isinstance(st, ST.SReturn) and st.values is not None:
        st.values = CG.map_multi(st.values, fn)

def _map_body(stmts, fn):
    for st in stmts:
        _map_stmt_exprs(st, fn)
        for b in _sub_blocks(st):
            _map_body(b, fn)

def inline_const_locals(body, params=()):
    """A local written once, with a number, boolean or short string literal,
    and read only after that write in the same block: its reads become the
    literal. Luau's
    compiler folds such locals itself, so in Luau bytecode a register that
    holds a literal is the compiler's or the obfuscator's (a constant hoisted
    out of a loop: `local n = 1 ... t[i][n]`), never the author's name.
    Opt-in (IR module flag INLINE_CONST_LOCALS)."""
    reads, writes, text = name_counts(body)
    nested = "\n".join(text)
    import re

    def candidates(stmts):
        out = []
        for i, st in enumerate(stmts):
            if isinstance(st, CG.AssignS) and len(st.targets) == 1 and isinstance(st.targets[0], CG.LocalName) \
                    and len(st.values.items) == 1 and st.values.tail is None \
                    and isinstance(st.values.items[0], Const):
                v = st.values.items[0].v
                nm = st.targets[0].name
                ok = isinstance(v, bool) or (isinstance(v, (int, float)) and v == v and abs(v) != float("inf")) \
                    or (isinstance(v, bytes) and (len(v) <= 40 or reads.get(nm, 0) <= 1))
                if ok and writes.get(nm) == 1 and nm not in params \
                        and not re.search(r"\b%s\b" % re.escape(nm), nested):
                    after, _, _ = name_counts(stmts[i + 1:])
                    if after.get(nm, 0) == reads.get(nm, 0):
                        out.append((stmts, i, nm, v))
            for b in _sub_blocks(st):
                out += candidates(b)
        return out

    for _ in range(8):
        cands = candidates(body)
        if not cands:
            break
        for stmts, i, nm, v in reversed(cands):
            def fn(x, nm=nm, v=v):
                return Const(v) if isinstance(x, CG.LocalName) and x.name == nm else None
            _map_body(stmts[i + 1:], fn)
            del stmts[i]

        reads, writes, text = name_counts(body)
        nested = "\n".join(text)
    return body

def _blank(block):
    return all(isinstance(x, CG.CommentS) and not x.text for x in block)

def drop_blank_branches(stmts):
    """An if branch holding only blank-line markers (empty comments: code
    that was dropped, e.g. an obfuscator's junk) is empty: no `else end`;
    an empty then-branch with a real else becomes `if not c then`."""
    for st in stmts:
        if isinstance(st, ST.SIf):
            drop_blank_branches(st.then)
            drop_blank_branches(st.els)
            for b in (st.then, st.els):
                while b and isinstance(b[-1], CG.CommentS) and not b[-1].text and not _blank(b):
                    b.pop()
                if not _blank(b) and sum(1 for x in b if not isinstance(x, CG.CommentS)) <= 2:
                    b[:] = [x for x in b if not (isinstance(x, CG.CommentS) and not x.text)]
            if st.els and _blank(st.els):
                st.els[:] = []
            if st.then and _blank(st.then) and st.els:
                st.cond = ST.negate(st.cond)
                st.then[:], st.els[:] = list(st.els), []
        elif isinstance(st, ST.SLoop):
            drop_blank_branches(st.body)
    return stmts


def _counts_no_forprep(stmts, reads=None, writes=None, text=None):
    """Like name_counts, but does not double-count ForPrepS.exprs (which shares
    the exact same list object as SLoop.forinfo[1])."""
    if reads is None:
        reads, writes, text = {}, {}, []
    for st in stmts:
        if isinstance(st, CG.ForPrepS):
            continue
        if isinstance(st, CG.AssignS):
            for t in st.targets:
                if isinstance(t, CG.LocalName):
                    writes[t.name] = writes.get(t.name, 0) + 1
        for e in _stmt_exprs(st):
            for x in CG.walk(e):
                if isinstance(x, CG.LocalName):
                    reads[x.name] = reads.get(x.name, 0) + 1
                elif isinstance(x, CG.FuncE):
                    text.append("\n".join(x.lines))
        for sub in _sub_blocks(st):
            _counts_no_forprep(sub, reads, writes, text)
    return reads, writes, text


def _expr_reads_set(e):
    out = set()
    if e is None:
        return out
    for x in CG.walk(e):
        if isinstance(x, CG.LocalName):
            out.add(x.name)
    return out


def _multi_reads_set(m):
    out = set()
    if m is None:
        return out
    for x in m.items:
        out |= _expr_reads_set(x)
    if m.tail is not None:
        out |= _expr_reads_set(CG.TailRef(m.tail))
    return out


def _multi_has_side_effects(m):
    if m is None:
        return False
    if any(CG.has_side_effects(x) for x in m.items):
        return True
    if m.tail is not None and CG.has_side_effects(CG.TailRef(m.tail)):
        return True
    return False


def _stmt_raw_reads_of(st, name):
    if isinstance(st, CG.ForPrepS):
        return 0
    return sum(1 for e in _stmt_exprs(st) for x in CG.walk(e) if isinstance(x, CG.LocalName) and x.name == name)


def _callee_name(fn):
    if isinstance(fn, CG.Global):
        return fn.name
    if isinstance(fn, CG.Index) and isinstance(fn.obj, CG.Global) and isinstance(fn.key, Const):
        kv = fn.key.v
        if isinstance(kv, bytes):
            kv = kv.decode("latin-1", "replace")
        if isinstance(kv, str):
            return "%s.%s" % (fn.obj.name, kv)
    return None


def _is_n_key(k):
    return isinstance(k, Const) and k.v in (b"n", "n")


def _is_pack_assign(st):
    if not (isinstance(st, CG.AssignS) and not getattr(st, "is_local", False)
            and len(st.targets) == 1 and isinstance(st.targets[0], CG.LocalName)
            and len(st.values.items) == 1 and st.values.tail is None):
        return None
    v = st.values.items[0]
    if isinstance(v, CG.CallE) and v.method is None and _callee_name(v.fn) == "table.pack":
        return st.targets[0].name, v.args
    return None


def _is_full_unpack(e, pname):
    if not (isinstance(e, CG.CallE) and e.method is None
            and _callee_name(e.fn) in ("table.unpack", "unpack")
            and e.args.tail is None and len(e.args.items) == 3):
        return False
    a0, a1, a2 = e.args.items
    return (isinstance(a0, CG.LocalName) and a0.name == pname
            and isinstance(a1, Const) and a1.v == 1
            and isinstance(a2, CG.Index) and isinstance(a2.obj, CG.LocalName) and a2.obj.name == pname
            and _is_n_key(a2.key))


def _subst_unpack_in_stmt(st, pname, repl_items, repl_tail):
    """Replace ONE `table.unpack(pname, 1, pname.n)` expansion inside `st` with
    `(repl_items, repl_tail)` when safe (no impure prefix before an impure replacement).
    Returns True if replaced."""
    rep_impure = any(CG.has_side_effects(x) for x in repl_items) or (
        repl_tail is not None and CG.has_side_effects(CG.TailRef(repl_tail))
    )
    done = [False]

    def fix_multi(m):
        if m is None or done[0]:
            return m
        new_items = [fix_expr(x) for x in m.items]
        if done[0]:
            return CG.Multi(new_items, m.tail)
        if isinstance(m.tail, CG.InlineTail):
            tc = m.tail.call
            if _is_full_unpack(tc, pname):
                if not (rep_impure and any(CG.has_side_effects(x) for x in new_items)):
                    done[0] = True
                    return CG.Multi(new_items + list(repl_items), repl_tail)
            else:
                ntc = fix_expr(tc)
                if done[0]:
                    return CG.Multi(new_items, CG.InlineTail(ntc))
        return CG.Multi(new_items, m.tail)

    def fix_expr(e):
        if e is None or done[0]:
            return e
        if isinstance(e, CG.CallE):
            nfn = fix_expr(e.fn)
            if done[0]:
                return CG.CallE(nfn, e.args, e.method)
            if rep_impure and CG.has_side_effects(nfn):
                return e
            nargs = fix_multi(e.args)
            if done[0]:
                return CG.CallE(nfn, nargs, e.method)
            return e
        if isinstance(e, CG.NewTableE):
            if isinstance(e.tail, CG.InlineTail) and _is_full_unpack(e.tail.call, pname):
                if not (rep_impure and any(CG.has_side_effects(v) or (k is not None and CG.has_side_effects(k)) for k, v in e.items)):
                    done[0] = True
                    return CG.NewTableE(list(e.items) + [(None, x) for x in repl_items], repl_tail)
        return CG.map_expr(e, lambda sub: None if sub is e else fix_expr(sub))

    if isinstance(st, CG.AssignS):
        if rep_impure and any(not isinstance(t, CG.LocalName) and CG.has_side_effects(t) for t in st.targets):
            return False
        nv = fix_multi(st.values)
        if done[0]:
            st.values = nv
            return True
    elif isinstance(st, CG.CallS):
        nc = fix_expr(st.call)
        if done[0]:
            st.call = nc
            return True
    elif isinstance(st, CG.SetListS):
        if not (rep_impure and CG.has_side_effects(st.tbl)):
            nv = fix_multi(st.values)
            if done[0]:
                st.values = nv
                return True
    elif isinstance(st, ST.SIf):
        nc = fix_expr(st.cond)
        if done[0]:
            st.cond = nc
            return True
    elif isinstance(st, ST.SReturn) and st.values is not None:
        nv = fix_multi(st.values)
        if done[0]:
            st.values = nv
            return True
    elif isinstance(st, ST.SLoop) and st.kind == "forin" and st.forinfo:
        exprs = st.forinfo[1]
        if len(exprs) == 1 and isinstance(exprs[0], CG.TailRef) and isinstance(exprs[0].tail, CG.InlineTail) \
                and _is_full_unpack(exprs[0].tail.call, pname):
            exprs[:] = list(repl_items) + ([CG.TailRef(repl_tail)] if repl_tail is not None else [])
            return True
        if len(exprs) == 1 and _is_full_unpack(exprs[0], pname):
            exprs[:] = list(repl_items) + ([CG.TailRef(repl_tail)] if repl_tail is not None else [])
            return True
        for idx, ex in enumerate(exprs):
            if rep_impure and any(CG.has_side_effects(prev) for prev in exprs[:idx]):
                break
            nex = fix_expr(ex)
            if done[0]:
                exprs[idx] = nex
                return True
    return False


def _is_state_independent_multi(m):
    if m.tail is not None:
        return False
    for x in m.items:
        if isinstance(x, Const):
            continue
        if isinstance(x, CG.NewTableE) and not x.items and x.tail is None:
            continue
        if isinstance(x, CG.Global) and x.name in ("ipairs", "pairs", "next", "select", "tostring", "tonumber"):
            continue
        return False
    return True


def _can_step_over(mid_st, pname, moving_reads, moving_impure):
    if isinstance(mid_st, CG.ForPrepS):
        return True
    if isinstance(mid_st, CG.CommentS) and not mid_st.text:
        return True
    if isinstance(mid_st, CG.AssignS) and all(isinstance(t, CG.LocalName) for t in mid_st.targets):
        written = {t.name for t in mid_st.targets}
        if pname in written or (written & moving_reads):
            return False
        if _stmt_raw_reads_of(mid_st, pname) > 0:
            return False
        if _multi_has_side_effects(mid_st.values):
            return False
        if moving_impure and not _is_state_independent_multi(mid_st.values):
            return False
        return True
    return False


def fold_pack_idioms(body, own=None):
    """Collapse Luraph / Luau `table.pack` + `table.move` + `table.unpack` idioms:
      1. Prepended pack (`p = table.pack(...); p.n = ...; table.move(p, 1, p.n, K+1, p); p[1..K] = ...; f(table.unpack(p, 1, p.n))`)
         -> `f(x1, ..., xK, ...)`
      2. Forwarding pack (`p = table.pack(X); ... table.unpack(p, 1, p.n)`)
         -> `X`
      3. Single-value pack (`p = table.pack(single_expr)` where `p` is only indexed at `p[1]` / `p.n`)
         -> `p = single_expr`
      4. Fresh array table + SetListS (`t = {}; SetListS(t, 1, X)`)
         -> `t = { X }`
    """
    import re
    for _ in range(4):
        nreads, writes, text = _counts_no_forprep(body)
        alltext = "\n".join(text)
        text_tokens = set(re.findall(r"(?<![\w.])[A-Za-z_]\w*", alltext)) if alltext else set()
        changed = [False]

        def walk_block(stmts):
            for st in stmts:
                for sub in _sub_blocks(st):
                    walk_block(sub)
            # Unbundle multi-target `a, b = ipairs, table.pack(...)` when safe so
            # both `fold_pack_idioms` and `fold_single_use` can inline each part cleanly.
            unbundled = ST.SBlock()
            did_unbundle = False
            for st in stmts:
                if isinstance(st, CG.AssignS) \
                        and len(st.targets) > 1 and st.values.tail is None \
                        and len(st.targets) >= len(st.values.items) >= 1 \
                        and all(isinstance(t, CG.LocalName) for t in st.targets) \
                        and len({t.name for t in st.targets}) == len(st.targets):
                    has_pack = any(
                        isinstance(v, CG.CallE) and v.method is None
                        and _callee_name(v.fn) == "table.pack"
                        for v in st.values.items
                    )
                    if has_pack:
                        is_loc = bool(getattr(st, "is_local", False))
                        order_ok = True
                        written_so_far = set()
                        for t, v in zip(st.targets, st.values.items):
                            if _expr_reads_set(v) & written_so_far:
                                order_ok = False
                                break
                            written_so_far.add(t.name)
                        if order_ok:
                            for t, v in zip(st.targets, st.values.items):
                                unbundled.append(CG.AssignS([t], CG.Multi([v]), is_local=is_loc))
                            extra_tgts = st.targets[len(st.values.items):]
                            if extra_tgts:
                                if is_loc:
                                    unbundled.append(CG.AssignS(list(extra_tgts), CG.Multi([]), is_local=True))
                                else:
                                    for t in extra_tgts:
                                        unbundled.append(CG.AssignS([t], CG.Multi([Const(None)]), is_local=False))
                            did_unbundle = True
                            continue
                unbundled.append(st)
            if did_unbundle:
                stmts[:] = unbundled
                nonlocal nreads, writes
                nreads, writes, _ = _counts_no_forprep(body)
                changed[0] = True

            i = 0
            while i < len(stmts):
                st = stmts[i]
                # Pattern 4: t = { arr_items... }; SetListS(t, len+1, vals)
                if isinstance(st, CG.AssignS) and len(st.targets) == 1 and isinstance(st.targets[0], CG.LocalName) \
                        and len(st.values.items) == 1 and st.values.tail is None \
                        and isinstance(st.values.items[0], CG.NewTableE) and st.values.items[0].tail is None \
                        and all(k is None for k, _ in st.values.items[0].items):
                    tname = st.targets[0].name
                    tbl_e = st.values.items[0]
                    if i + 1 < len(stmts) and isinstance(stmts[i + 1], CG.SetListS):
                        sl = stmts[i + 1]
                        if isinstance(sl.tbl, CG.LocalName) and sl.tbl.name == tname \
                                and sl.start == len(tbl_e.items) + 1 \
                                and tname not in _multi_reads_set(sl.values):
                            st.values = CG.Multi([
                                CG.NewTableE(list(tbl_e.items) + [(None, x) for x in sl.values.items], sl.values.tail)
                            ])
                            del stmts[i + 1]
                            changed[0] = True
                            continue

                pa = _is_pack_assign(st)
                if pa is None:
                    i += 1
                    continue
                pname, pack_m = pa
                if (own is not None and pname not in own) or pname in text_tokens or writes.get(pname, 0) != 1:
                    i += 1
                    continue

                # Pattern 1: Vararg / multi prepend pack
                if i + 3 < len(stmts):
                    s1, s2 = stmts[i + 1], stmts[i + 2]
                    if isinstance(s1, CG.AssignS) and len(s1.targets) == 1 \
                            and isinstance(s1.targets[0], CG.Index) \
                            and isinstance(s1.targets[0].obj, CG.LocalName) and s1.targets[0].obj.name == pname \
                            and _is_n_key(s1.targets[0].key) \
                            and s1.values.tail is None and len(s1.values.items) == 1 \
                            and not CG.has_side_effects(s1.values.items[0]) \
                            and isinstance(s2, CG.CallS) and isinstance(s2.call, CG.CallE) \
                            and s2.call.method is None and _callee_name(s2.call.fn) == "table.move" \
                            and s2.call.args.tail is None \
                            and len(s2.call.args.items) == 5:
                        m0, m1, m2, m3, m4 = s2.call.args.items
                        if isinstance(m0, CG.LocalName) and m0.name == pname \
                                and isinstance(m1, Const) and m1.v == 1 \
                                and isinstance(m2, CG.Index) and isinstance(m2.obj, CG.LocalName) \
                                and m2.obj.name == pname and _is_n_key(m2.key) \
                                and isinstance(m3, Const) and isinstance(m3.v, int) and not isinstance(m3.v, bool) \
                                and m3.v >= 2 and isinstance(m4, CG.LocalName) and m4.name == pname:
                            k_cnt = m3.v - 1
                            if i + 3 + k_cnt < len(stmts):
                                slot_vals = {}
                                ok_slots = True
                                for off in range(k_cnt):
                                    sk = stmts[i + 3 + off]
                                    if not (isinstance(sk, CG.AssignS) and len(sk.targets) == 1
                                            and isinstance(sk.targets[0], CG.Index)
                                            and isinstance(sk.targets[0].obj, CG.LocalName)
                                            and sk.targets[0].obj.name == pname
                                            and isinstance(sk.targets[0].key, Const)
                                            and isinstance(sk.targets[0].key.v, int)
                                            and not isinstance(sk.targets[0].key.v, bool)
                                            and 1 <= sk.targets[0].key.v <= k_cnt
                                            and sk.values.tail is None and len(sk.values.items) == 1
                                            and pname not in _expr_reads_set(sk.values.items[0])):
                                        ok_slots = False
                                        break
                                    slot_vals[sk.targets[0].key.v] = sk.values.items[0]
                                if ok_slots and len(slot_vals) == k_cnt:
                                    prep_list = [slot_vals[idx_k] for idx_k in range(1, k_cnt + 1)]
                                    seq_reads = sum(_stmt_raw_reads_of(stmts[p_i], pname) for p_i in range(i + 1, i + 3 + k_cnt))
                                    if nreads.get(pname, 0) == seq_reads + 2:
                                        mov_reads = _multi_reads_set(pack_m)
                                        for pv in prep_list:
                                            mov_reads |= _expr_reads_set(pv)
                                        mov_impure = _multi_has_side_effects(pack_m) or any(CG.has_side_effects(pv) for pv in prep_list)
                                        j = i + 3 + k_cnt
                                        while j < len(stmts) and _stmt_raw_reads_of(stmts[j], pname) == 0:
                                            if not _can_step_over(stmts[j], pname, mov_reads, mov_impure):
                                                break
                                            j += 1
                                        if j < len(stmts) and _stmt_raw_reads_of(stmts[j], pname) == 2:
                                            if _subst_unpack_in_stmt(stmts[j], pname, prep_list + list(pack_m.items), pack_m.tail):
                                                del stmts[i : i + 3 + k_cnt]
                                                nreads, writes, _ = _counts_no_forprep(body)
                                                changed[0] = True
                                                continue

                # Pattern 2: Forwarding pack -> single table.unpack(p, 1, p.n)
                if nreads.get(pname, 0) == 2:
                    mov_reads = _multi_reads_set(pack_m)
                    mov_impure = _multi_has_side_effects(pack_m)
                    j = i + 1
                    while j < len(stmts) and _stmt_raw_reads_of(stmts[j], pname) == 0:
                        if not _can_step_over(stmts[j], pname, mov_reads, mov_impure):
                            break
                        j += 1
                    if j < len(stmts) and _stmt_raw_reads_of(stmts[j], pname) == 2:
                        if _subst_unpack_in_stmt(stmts[j], pname, list(pack_m.items), pack_m.tail):
                            del stmts[i]
                            nreads, writes, _ = _counts_no_forprep(body)
                            changed[0] = True
                            continue

                i += 1

        walk_block(body)

        # Pattern 3: Single-value pack `p = table.pack(expr1)` where `p` is ONLY indexed as `p[1]` or `p.n`
        nreads, writes, text = _counts_no_forprep(body)
        alltext = "\n".join(text)
        text_tokens = set(re.findall(r"(?<![\w.])[A-Za-z_]\w*", alltext)) if alltext else set()
        single_cands = {}

        def find_single_packs(stmts):
            for st in stmts:
                pa = _is_pack_assign(st)
                if pa is not None:
                    pname, pack_m = pa
                    if (own is None or pname in own) and pname not in text_tokens and writes.get(pname, 0) == 1 \
                            and pack_m.tail is None and len(pack_m.items) == 1:
                        ex1 = pack_m.items[0]
                        from luasym import Vararg
                        if not isinstance(ex1, (CG.CallE, Vararg)) or CG.is_stateless_call_shallow(ex1):
                            single_cands[pname] = (st, ex1)
                for sub in _sub_blocks(st):
                    find_single_packs(sub)

        find_single_packs(body)
        if single_cands:
            bad = set()

            def check_uses_expr(e, parent_ok=False):
                if e is None:
                    return
                if isinstance(e, CG.Index) and isinstance(e.obj, CG.LocalName) and e.obj.name in single_cands:
                    if isinstance(e.key, Const) and e.key.v in (1, b"n"):
                        return
                    bad.add(e.obj.name)
                    check_uses_expr(e.key)
                    return
                if isinstance(e, CG.LocalName) and e.name in single_cands and not parent_ok:
                    bad.add(e.name)
                    return
                for ch in CG.children(e):
                    check_uses_expr(ch)

            def check_uses_block(stmts):
                for st in stmts:
                    if isinstance(st, CG.ForPrepS):
                        continue
                    if isinstance(st, CG.AssignS):
                        for t in st.targets:
                            if not isinstance(t, CG.LocalName):
                                # Assigning to p[1] or p.n disqualifies p!
                                for x in CG.walk(t):
                                    if isinstance(x, CG.LocalName) and x.name in single_cands:
                                        bad.add(x.name)
                        for v in st.values.items:
                            check_uses_expr(v)
                        if st.values.tail is not None:
                            check_uses_expr(CG.TailRef(st.values.tail))
                    else:
                        for e in _stmt_exprs(st):
                            check_uses_expr(e)
                    for sub in _sub_blocks(st):
                        check_uses_block(sub)

            check_uses_block(body)
            good = {nm: pair for nm, pair in single_cands.items() if nm not in bad}
            if good:
                for nm, (def_st, ex1) in good.items():
                    def_st.values = CG.Multi([ex1])

                def rw_idx(x):
                    if isinstance(x, CG.Index) and isinstance(x.obj, CG.LocalName) and x.obj.name in good \
                            and isinstance(x.key, Const):
                        if x.key.v == 1:
                            return CG.LocalName(x.obj.name)
                        if x.key.v == b"n":
                            return Const(1)
                    return None

                _map_body(body, rw_idx)
                changed[0] = True

        if not changed[0]:
            break
    return body


def eliminate_dead_code(body, own):
    """Iterative mark-sweep dead-code & dead-store eliminator over `own` locals:
      - Drops standalone discardable expression statements (`bit32.bor(...)`, `type(0)`).
      - Collapses `if pure_cond then X else X end` when both branches render identically.
      - Eliminates dead locals and self-referential dead state chains (`n3 = bit32.band(n3, n4) - ...`,
        64-bit MBA `table.pack(bit32.*)` chains, dead `os.clock()` reads).
      - Eliminates straight-line overwritten dead stores (`x = const1; ...; x = const2`).
    """
    import re
    if not own:
        own = set()
    tok_re = re.compile(r"(?<![\w.])[A-Za-z_]\w*")

    def multi_discardable(m):
        return (m is not None and m.tail is None and len(m.items) == 1
                and CG.is_discardable_expr(m.items[0]))

    for _ in range(8):
        changed = False

        # 1. Drop standalone discardable CallS & collapse identical-branch SIf
        def clean_stmts(stmts):
            nonlocal changed
            out = ST.SBlock()
            for st in stmts:
                if isinstance(st, CG.CallS) and CG.is_discardable_expr(st.call):
                    changed = True
                    continue
                if isinstance(st, ST.SIf):
                    st.then = clean_stmts(st.then)
                    st.els = clean_stmts(st.els)
                    if not st.then and not st.els and CG.is_discardable_expr(st.cond):
                        changed = True
                        continue
                    if st.then and st.els and CG.is_discardable_expr(st.cond):
                        r_tmp = CG.Renderer()
                        if r_tmp.block(st.then, "") == r_tmp.block(st.els, ""):
                            out.extend(st.then)
                            changed = True
                            continue
                elif isinstance(st, ST.SLoop):
                    st.body = clean_stmts(st.body)
                out.append(st)
            return out

        body = clean_stmts(body)

        # 2. Transitive mark-sweep liveness over `own`
        if own:
            live = set()
            deps = {}  # local_name -> set of local_names it depends on when live

            def expr_info(e):
                names = set()
                ftoks = set()
                if e is None:
                    return names, ftoks
                for x in CG.walk(e):
                    if isinstance(x, CG.LocalName):
                        names.add(x.name)
                    elif isinstance(x, CG.FuncE):
                        ftoks.update(tok_re.findall("\n".join(x.lines)))
                return names, ftoks

            def multi_info(m):
                names = set()
                ftoks = set()
                if m is None:
                    return names, ftoks
                for x in m.items:
                    n1, f1 = expr_info(x)
                    names |= n1
                    ftoks |= f1
                if m.tail is not None:
                    n1, f1 = expr_info(CG.TailRef(m.tail))
                    names |= n1
                    ftoks |= f1
                return names, ftoks

            def mark_root_expr(e):
                n1, f1 = expr_info(e)
                live.update(n1 & own)
                live.update(f1 & own)

            def mark_root_multi(m):
                n1, f1 = multi_info(m)
                live.update(n1 & own)
                live.update(f1 & own)

            def scan_liveness(stmts):
                for st in stmts:
                    if isinstance(st, CG.ForPrepS):
                        continue
                    if isinstance(st, CG.AssignS):
                        if len(st.targets) == 1 and isinstance(st.targets[0], CG.LocalName) \
                                and st.targets[0].name in own:
                            tnm = st.targets[0].name
                            n1, f1 = multi_info(st.values)
                            if multi_discardable(st.values):
                                deps.setdefault(tnm, set()).update((n1 | f1) & own)
                            else:
                                # Impure RHS (e.g. call): RHS executes even if target is dead
                                live.update((n1 | f1) & own)
                        else:
                            for t in st.targets:
                                if not isinstance(t, CG.LocalName):
                                    mark_root_expr(t)
                                elif t.name not in own:
                                    # Upvalue assignment — value is externally observable!
                                    pass
                            mark_root_multi(st.values)
                    elif isinstance(st, (CG.CallS, CG.TempDef)):
                        mark_root_expr(st.call)
                    elif isinstance(st, CG.SetListS):
                        mark_root_expr(st.tbl)
                        mark_root_multi(st.values)
                    elif isinstance(st, ST.SIf):
                        mark_root_expr(st.cond)
                        scan_liveness(st.then)
                        scan_liveness(st.els)
                    elif isinstance(st, ST.SLoop):
                        if st.cond is not None:
                            mark_root_expr(st.cond)
                        if st.forinfo:
                            for ex in st.forinfo[1]:
                                mark_root_expr(ex)
                        scan_liveness(st.body)
                    elif isinstance(st, ST.SReturn):
                        mark_root_multi(st.values)

            scan_liveness(body)
            work = list(live)
            while work:
                cur = work.pop()
                for dep in deps.get(cur, ()):
                    if dep not in live:
                        live.add(dep)
                        work.append(dep)

            def sweep_dead(stmts):
                nonlocal changed
                out = ST.SBlock()
                for st in stmts:
                    if isinstance(st, CG.AssignS) and len(st.targets) == 1 \
                            and isinstance(st.targets[0], CG.LocalName) \
                            and st.targets[0].name in own and st.targets[0].name not in live:
                        vals = st.values
                        if multi_discardable(vals):
                            changed = True
                            continue
                        if vals.tail is None and len(vals.items) == 1 and isinstance(vals.items[0], CG.CallE):
                            out.append(CG.CallS(vals.items[0]))
                            changed = True
                            continue
                        if vals.tail is not None and not vals.items and isinstance(vals.tail, CG.InlineTail):
                            out.append(CG.CallS(vals.tail.call))
                            changed = True
                            continue
                    elif isinstance(st, ST.SIf):
                        st.then = sweep_dead(st.then)
                        st.els = sweep_dead(st.els)
                    elif isinstance(st, ST.SLoop):
                        st.body = sweep_dead(st.body)
                    out.append(st)
                return out

            body = sweep_dead(body)

        # 3. Straight-line overwritten dead-store elimination for uncaptured `own` locals
        if own:
            _, _, ftexts = _counts_no_forprep(body)
            cap_toks = set(tok_re.findall("\n".join(ftexts))) if ftexts else set()

            def kill_overwritten(stmts):
                nonlocal changed
                for st in stmts:
                    for sub in _sub_blocks(st):
                        kill_overwritten(sub)
                drop_idxs = set()
                for idx, st in enumerate(stmts):
                    if not (isinstance(st, CG.AssignS) and len(st.targets) == 1
                            and isinstance(st.targets[0], CG.LocalName)):
                        continue
                    nm = st.targets[0].name
                    if nm not in own or nm in cap_toks or not multi_discardable(st.values):
                        continue
                    for k in range(idx + 1, len(stmts)):
                        sk = stmts[k]
                        if isinstance(sk, (CG.ForPrepS, CG.CommentS)):
                            if isinstance(sk, CG.ForPrepS) and any(nm in _expr_reads_set(e) for e in sk.exprs):
                                break
                            continue
                        if not isinstance(sk, (CG.AssignS, CG.CallS, CG.SetListS)):
                            break
                        if _stmt_raw_reads_of(sk, nm) > 0:
                            break
                        if isinstance(sk, CG.AssignS) and any(isinstance(t, CG.LocalName) and t.name == nm for t in sk.targets):
                            drop_idxs.add(idx)
                            break
                if drop_idxs:
                    stmts[:] = [s for idx, s in enumerate(stmts) if idx not in drop_idxs]
                    changed = True

            kill_overwritten(body)

        body = drop_blank_branches(body)
        if not changed:
            break
    return body


def _simplify_bool_ifexp(e):
    """Simplify boolean-context IfExp (`if (if c then P else not c) then` -> `if not c or P then`)."""
    from luasym import IfExp
    if isinstance(e, IfExp) and not CG.has_side_effects(e.c):
        ck = key(e.c)
        # if c then P else not c  ==>  not c or P
        if ck is not None and isinstance(e.b, Un) and e.b.op == "Not" and key(e.b.a) == ck:
            return Bin("Or", ST.negate(e.c), _simplify_bool_ifexp(e.a))
        # if c then P else false/nil  ==>  c and P
        if isinstance(e.b, Const) and (e.b.v is False or e.b.v is None):
            return Bin("And", e.c, _simplify_bool_ifexp(e.a))
        # if c then true else P  ==>  c or P  (in boolean condition context)
        if isinstance(e.a, Const) and e.a.v is True:
            return Bin("Or", e.c, _simplify_bool_ifexp(e.b))
    return e


def flatten_nested_ifs(body, own=None):
    """Polish structured control flow:
      - Simplify boolean `IfExp` conditions (`if if x then x.k ~= v else not x then`).
      - Merge `if A then if B then BODY end end` (both without `else`) into `if A and B then BODY end`.
      - Fold single-use local alias right before a `for` loop (`local t2 = t1; for k, v in next, t2, nil do`).
    """
    import re
    nreads, writes, text = _counts_no_forprep(body)
    alltext = "\n".join(text)
    text_tokens = set(re.findall(r"(?<![\w.])[A-Za-z_]\w*", alltext)) if alltext else set()

    def walk_block(stmts):
        i = 0
        while i < len(stmts):
            st = stmts[i]
            # Fold `a = b; [ForPrepS]; for ... in ... a ...` when `a` is an uncaptured single-use alias
            if isinstance(st, CG.AssignS) and not getattr(st, "is_local", False) \
                    and len(st.targets) == 1 and isinstance(st.targets[0], CG.LocalName) \
                    and len(st.values.items) == 1 and st.values.tail is None \
                    and isinstance(st.values.items[0], CG.LocalName):
                anm = st.targets[0].name
                bnm = st.values.items[0].name
                if (own is None or anm in own) and anm not in text_tokens \
                        and writes.get(anm, 0) == 1 and nreads.get(anm, 0) >= 1:
                    j = i + 1
                    while j < len(stmts) and isinstance(stmts[j], CG.ForPrepS):
                        j += 1
                    if j < len(stmts) and isinstance(stmts[j], ST.SLoop) and stmts[j].kind in ("for", "forin") \
                            and stmts[j].forinfo:
                        hdr_reads = sum(1 for ex in stmts[j].forinfo[1] for x in CG.walk(ex)
                                        if isinstance(x, CG.LocalName) and x.name == anm)
                        if hdr_reads > 0 and hdr_reads == nreads.get(anm, 0):
                            stmts[j].forinfo[1][:] = [
                                CG.map_expr(ex, lambda x, a=anm, b=bnm: CG.LocalName(b) if isinstance(x, CG.LocalName) and x.name == a else None)
                                for ex in stmts[j].forinfo[1]
                            ]
                            del stmts[i]
                            continue

            if isinstance(st, ST.SIf):
                st.cond = _simplify_bool_ifexp(st.cond)
                walk_block(st.then)
                walk_block(st.els)
                while not st.els and len(st.then) == 1 and isinstance(st.then[0], ST.SIf) and not st.then[0].els:
                    inner = st.then[0]
                    st.cond = Bin("And", st.cond, inner.cond)
                    st.then = inner.then
            elif isinstance(st, ST.SLoop):
                if st.cond is not None:
                    st.cond = _simplify_bool_ifexp(st.cond)
                walk_block(st.body)
            i += 1

    walk_block(body)
    return body


