"""Split printed names that carry more than one binding.

The lifter recovers the obfuscated chunk's own local names (`capnames`, the
wrapper's identifiers) and prints one name per VM register. A register is not a
variable: the VM reuses it, and two registers can carry the same recovered name,
so one printed name can stand for two different locals. Two shapes reach the
output:

    local a, a = f(), g()          -- X: two locals, one name, one statement
    local function f() ... end     -- W: the closure's name, then a reuse value
    f = other
    ... f.field ...                -- reads the reuse value, not the closure

X is unarguable: a `local` declaration's initialisers run before any of the new
locals is in scope, so the earlier `a` can never be read. It is renamed to `_`
only when the AST proves it has no references at all; otherwise the statement is
counted and left alone.

W is only a readability defect when the reuse value really is what the later
reads see, and that is checked, not assumed:

  * a read inside a nested function is a capture: the closure can run long after
    it was written, so that read takes the reuse value only when a reuse
    assignment dominates the point where the closure is *created*. Otherwise
    the site is skipped (`capture-before-split`) -- it may see either value.
  * a write inside a nested function is skipped outright (`write-in-closure`):
    it mutates the parent's binding at a time we cannot place.
  * a same-function read is renamed only when a reuse assignment dominates it
    (path dominance: an earlier statement of a shared block, no conditional in
    between). A read left holding the closure's name must not be able to run
    after a reuse assignment, so it is skipped (`loop-hazard`) when it shares a
    loop with an assignment outside the declaration's own loop chain, and
    (`undominated-read`) otherwise. The `local function f() ... end; f(x);
    f = v` idiom inside a loop is not that hazard: `local function` declares a
    fresh variable on every iteration, so nothing carries across.
  * the new local has to be declared where every renamed read and write can see
    it: in the deepest block containing all of them (the longest common prefix
    of their paths), inline when the first reuse statement is a single-target
    assignment there, else as its own `local name_2` line. A declaration that
    would land inside a loop body a nested closure reads is skipped
    (`loop-capture`): each iteration would get its own variable.

The closure keeps its name. The reuse value gets a new local, used by every read
and write from the reuse point on, so the reader never has to ask which value a
name holds. Every skip is counted by reason and reported; nothing is guessed.
"""
import argparse
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
if HERE not in sys.path:
    sys.path.insert(0, HERE)

import ast_polish as AP


def _line_starts(btext):
    return AP._line_starts(btext)


def _loc_bytes(loc_str, starts):
    return AP._loc_bytes(loc_str, starts)


def _apply(btext, edits):
    """ast_polish's edit applier wants (start, end, replacement) triples."""
    return AP._apply_edits(btext, [(e[0], e[1], e[2]) for e in edits])


def _start(loc_str):
    """'l,c - l,c' -> (line, col) of the first position, 1-based."""
    a = loc_str.split(" - ")[0]
    l, c = a.split(",")
    return int(l) + 1, int(c) + 1


class Scan:
    """The AST index both halves need: locals, reads, writes, duplicates."""

    def __init__(self, text):
        self.text = text
        self.btext = text.encode("utf-8")
        self.starts = _line_starts(self.btext)
        self.root = AP._parse_ast(text)
        self.locals = {}    # local.location -> decl info
        self.reads = []     # one dict per AstExprLocal reference
        self.writes = []    # one dict per assignment target that is a local
        self.dups = []      # (line, [(loc, name, span_start, span_end), ...])
        self.refcount = {}  # local.location -> number of references
        self.fn_info = {}   # id(fn node) -> {"line", "path"} of the creation site
        self.loop_blocks = set()  # ids of loop bodies
        self.all_names = set()  # every identifier in the file (fresh names avoid these)
        self.order = 0
        self.skipped = {}   # reason -> count (fills during analysis)

    # ---- traversal -------------------------------------------------------
    def run(self):
        self.walk_block(self.root, (), False, (), None)
        return self

    def _decl(self, node, kind, fn, order, pos, path=()):
        loc_key = node["location"]
        self.locals.setdefault(loc_key, {
            "name": node["name"], "kind": kind, "fn": fn, "order": order,
            "line": pos[0], "col": pos[1], "path": path})
        self.all_names.add(node["name"])

    def walk_block(self, blk, path, guarded, loops, fn):
        for i, st in enumerate(blk.get("body") or ()):
            self.order += 1
            start = _loc_bytes(st["location"], self.starts)[0]
            self.walk_stat(st, path + ((id(blk), i, guarded, start),), guarded, loops, fn, self.order)

    def walk_stat(self, st, path, guarded, loops, fn, order):
        t = st.get("type")
        start = _start(st["location"])
        if t == "AstStatLocalFunction":
            self.walk_expr(st["func"], path, loops, fn)
            self._decl(st["name"], "LF", fn, order, start, path)
            return
        if t == "AstStatLocal":
            vals = st.get("values") or []
            for v in vals:
                self.walk_expr(v, path, loops, fn)
            group = []
            for i, var in enumerate(st.get("vars") or ()):
                kind = "LV" if i < len(vals) and vals[i].get("type") == "AstExprFunction" else "value"
                self._decl(var, kind, fn, order, start, path)
                s0, e0 = _loc_bytes(var["location"], self.starts)
                group.append((var["location"], var["name"], s0, e0))
            names = [g[1] for g in group]
            if len(set(names)) != len(names):
                self.dups.append((start[0], group))
            return
        if t in ("AstStatAssign", "AstStatCompoundAssign"):
            if t == "AstStatAssign":
                for v in st.get("values") or ():
                    self.walk_expr(v, path, loops, fn)
                vars_ = list(st.get("vars") or ())
            else:
                self.walk_expr(st["value"], path, loops, fn)
                if st["var"].get("type") == "AstExprLocal":
                    self._ref(st["var"], "r", path, loops, fn, self.order, compound=True)
                vars_ = [st["var"]]
            compound = t == "AstStatCompoundAssign"
            st_s0 = _loc_bytes(st["location"], self.starts)[0]
            ls = self.btext.rfind(b"\n", 0, st_s0) + 1
            indent = self.btext[ls:st_s0].decode("utf-8")
            meta = {"s0": st_s0, "line_start": ls, "indent": indent,
                    "n_targets": len(vars_), "at_line_start": indent.strip() == ""}
            for var in vars_:
                if var.get("type") == "AstExprLocal":
                    self._ref(var, "w", path, loops, fn, order, compound=compound, stmt=meta)
                else:
                    self.walk_expr(var, path, loops, fn)
            return
        if t == "AstStatBlock":
            self.walk_block(st, path, guarded, loops, fn)
            return
        if t == "AstStatIf":
            self.walk_expr(st["condition"], path, loops, fn)
            self.walk_block(st["thenbody"], path, True, loops, fn)
            e = st.get("elsebody")
            if e is not None:
                if e.get("type") == "AstStatIf":
                    self.walk_stat(e, path, True, loops, fn, order)
                else:
                    self.walk_block(e, path, True, loops, fn)
            return
        if t in ("AstStatWhile", "AstStatRepeat"):
            self.walk_expr(st["condition"], path, loops, fn)
            self.loop_blocks.add(id(st["body"]))
            self.walk_block(st["body"], path, True, loops + (id(st["body"]),), fn)
            return
        if t in ("AstStatFor", "AstStatForIn"):
            for k in ("from", "to", "step"):
                if st.get(k) is not None:
                    self.walk_expr(st[k], path, loops, fn)
            for v in (st.get("values") or ()):
                self.walk_expr(v, path, loops, fn)
            for var in (st.get("vars") or ([st["var"]] if st.get("var") else [])):
                self._decl(var, "value", fn, order, start, path)
            self.loop_blocks.add(id(st["body"]))
            self.walk_block(st["body"], path, True, loops + (id(st["body"]),), fn)
            return
        if t == "AstStatReturn":
            for v in st.get("list") or ():
                self.walk_expr(v, path, loops, fn)
            return
        if t == "AstStatFunction":
            self.walk_expr(st["func"], path, loops, fn)
            self.walk_expr(st["name"], path, loops, fn)
            return
        # any other statement: visit the expressions it carries
        for v in st.values():
            if isinstance(v, dict) and str(v.get("type", "")).startswith("AstExpr"):
                self.walk_expr(v, path, loops, fn)
            elif isinstance(v, list):
                for x in v:
                    if isinstance(x, dict) and str(x.get("type", "")).startswith("AstExpr"):
                        self.walk_expr(x, path, loops, fn)

    def _ref(self, e, kind, path, loops, fn, order, compound=False, stmt=None):
        loc_key = e["local"]["location"]
        s0, e0 = _loc_bytes(e["location"], self.starts)
        self.all_names.add(e["local"]["name"])
        rec = {"loc": loc_key, "kind": kind, "path": path, "loops": loops,
               "fn": fn, "order": order, "s0": s0, "e0": e0, "compound": compound,
               "stmt": stmt, "line": _start(e["location"])[0]}
        (self.reads if kind == "r" else self.writes).append(rec)
        self.refcount[loc_key] = self.refcount.get(loc_key, 0) + 1

    def walk_expr(self, e, path, loops, fn):
        if not isinstance(e, dict):
            return
        t = e.get("type")
        if t == "AstExprLocal":
            self._ref(e, "r", path, loops, fn, self.order)
            return
        if t == "AstExprGlobal":
            self.all_names.add(e["global"])
            return
        if t == "AstExprFunction":
            fid = id(e)
            self.fn_info[fid] = {"line": _start(e["location"])[0], "path": path}
            self.order += 1
            body_order = self.order
            for a in e.get("args") or ():
                if a.get("name"):
                    self._decl(a, "value", fid, body_order, _start(a["location"]), path)
            self.walk_block(e["body"], path, False, (), fid)
            return
        for v in e.values():
            if isinstance(v, dict) and str(v.get("type", "")).startswith("AstExpr"):
                self.walk_expr(v, path, loops, fn)
            elif isinstance(v, list):
                for x in v:
                    if isinstance(x, dict) and str(x.get("type", "")).startswith("AstExpr"):
                        self.walk_expr(x, path, loops, fn)

    # ---- X: duplicate names in one declaration ---------------------------
    def duplicate_edits(self):
        """[(s0, e0, b'_', reason)] for shadowed duplicates that are unreferenced."""
        out = []
        for line, group in self.dups:
            by_name = {}
            for g in group:
                by_name.setdefault(g[1], []).append(g)
            for nm, same in by_name.items():
                if len(same) < 2 or nm == "_":
                    continue
                for loc_key, name, s0, e0 in same[:-1]:
                    if self.refcount.get(loc_key, 0):
                        self._skip("duplicate-still-referenced")
                        continue
                    out.append((s0, e0, b"_", (line, name)))
        return out

    # ---- W: one name, a closure and later reuse values -------------------
    @staticmethod
    def _dominated(assign, read):
        pa, pr = assign["path"], read["path"]
        deepest = 0
        while deepest < len(pa) and deepest < len(pr) and pa[deepest][0] == pr[deepest][0]:
            deepest += 1
        if deepest == 0:
            return False
        if pa[deepest - 1][1] >= pr[deepest - 1][1]:
            return False
        return not any(pa[k][2] for k in range(deepest, len(pa)))

    def sites(self):
        """{loc: {"info", "asg", "reads", "reason"}} for every reuse site."""
        out = {}
        by_loc = {}
        for w in self.writes:
            by_loc.setdefault(w["loc"], []).append(w)
        for loc_key, info in self.locals.items():
            if info["kind"] not in ("LF", "LV"):
                continue
            asg = sorted((w for w in by_loc.get(loc_key, ()) if w["order"] > info["order"]),
                         key=lambda w: w["order"])
            if not asg:
                continue
            reads = [r for r in self.reads if r["loc"] == loc_key]
            out[loc_key] = {"info": info, "asg": asg, "reads": reads,
                            "reason": self._classify(loc_key, info, asg, reads)}
        return out

    def _skip(self, reason):
        self.skipped[reason] = self.skipped.get(reason, 0) + 1

    @staticmethod
    def _lca(paths):
        """Longest common prefix of statement paths: the block a declaration
        placed for `paths` has to live in to be visible to all of them."""
        common = list(paths[0])
        for p in paths[1:]:
            k = 0
            while k < len(common) and k < len(p) and common[k][0] == p[k][0]:
                k += 1
            common = common[:k]
        return common

    def _renamed_reads(self, info, asg, reads):
        """Reads that take the reuse value.

        Same function: the read is renamed only when an assignment dominates it.
        Nested function: the closure may run at any time, so every read inside it
        needs the assignment to dominate the point where the closure is created.
        """
        out = []
        for r in reads:
            if r["fn"] == info["fn"]:
                if any(self._dominated(a, r) for a in asg):
                    out.append(r)
                continue
            fn_path = self.fn_info.get(r["fn"], {}).get("path")
            if fn_path is not None and any(self._dominated(a, {"path": fn_path}) for a in asg):
                out.append(r)
        return out

    def _classify(self, loc_key, info, asg, reads):
        """None when the split is safe, else the reason it is not.

        One new name covers every write and read from the first reuse assignment
        on, so an ordinary reassigned temp keeps one name instead of being
        numbered per write (`callback21_2`, `callback21_3`, ...).
        """
        if any(w["fn"] != info["fn"] for w in self.writes if w["loc"] == loc_key):
            return "write-in-closure"
        for r in reads:
            if r["fn"] == info["fn"]:
                continue
            fn_path = self.fn_info.get(r["fn"], {}).get("path")
            if fn_path is None:
                return "capture-unknown"
            if not any(self._dominated(a, {"path": fn_path}) for a in asg):
                # the closure can be created (and run) before a reuse value is
                # certainly in the variable, so it may see either one
                return "capture-before-split"
        for a in asg:
            if not a["compound"]:
                continue
            same = [x for x in reads if x["s0"] == a["s0"]]
            if not any(self._dominated(w, x) for w in asg for x in same):
                # `f += 1` reads and writes one token; the token can take only
                # one name, and here the read would have to keep the closure's
                return "compound-assign"
        for r in reads:
            if r["fn"] != info["fn"]:
                continue
            if any(self._dominated(a, r) for a in asg):
                continue
            if r["order"] < asg[0]["order"]:
                decl_blocks = {p[0] for p in info["path"]}
                carried = set()
                for a in asg:
                    carried |= set(r["loops"]) & set(a["loops"])
                if carried - decl_blocks:
                    return "loop-hazard"
                continue
            return "undominated-read"
        renamed = self._renamed_reads(info, asg, reads)
        lca = self._lca([a["path"] for a in asg] + [r["path"] for r in renamed])
        if lca[-1][0] in self.loop_blocks and any(r["fn"] != info["fn"] for r in renamed):
            # the declaration would sit inside the loop body, so a closure made in
            # one iteration would capture that iteration's variable instead of the
            # single variable the obfuscated code shares
            return "loop-capture"
        return None

    def reuse_edits(self):
        """[(s0, e0, new_name_bytes, (decl_line, base_name))] for split sites."""
        out = []
        taken = set(self.all_names)
        for loc_key, site in sorted(self.sites().items(),
                                    key=lambda kv: (kv[1]["info"]["line"], kv[1]["info"]["name"])):
            info, asg, reads, reason = site["info"], site["asg"], site["reads"], site["reason"]
            renamed = self._renamed_reads(info, asg, reads)
            if reason is not None:
                self._skip(reason)
                continue
            # `name_2` for the first split of a binding, then `name_3`, ... --
            # never `name_22`, which reads like a per-write counter.
            bump = 2
            cand = "%s_%d" % (info["name"], bump)
            while cand in taken:
                bump += 1
                cand = "%s_%d" % (info["name"], bump)
            taken.add(cand)
            name = cand.encode("utf-8")
            # The reuse value needs a declaration of its own -- renaming alone
            # would write an undeclared name, i.e. a global -- and it has to be
            # visible to every read and write we rename, so it goes into the
            # deepest block that contains all of them (their longest common
            # prefix), in front of the statement that leads to the first one.
            a0, st = asg[0], asg[0]["stmt"] or {}
            lca = self._lca([a["path"] for a in asg] + [r["path"] for r in renamed])
            if len(lca) == len(a0["path"]) and st.get("n_targets") == 1 \
                    and st.get("s0") == a0["s0"]:
                out.append((a0["s0"], a0["s0"], b"local ", (info["line"], info["name"])))
            else:
                at = lca[-1][3]
                ls = self.btext.rfind(b"\n", 0, at) + 1
                indent = self.btext[ls:at]
                if indent.strip():
                    self._skip("inline-statement")
                    continue
                decl = indent + b"local " + name + b"\n"
                out.append((ls, ls, decl, (info["line"], info["name"])))
            for a in asg:
                out.append((a["s0"], a["e0"], name, (info["line"], info["name"])))
            for r in renamed:
                out.append((r["s0"], r["e0"], name, (info["line"], info["name"])))
        return out


def apply_duplicates(text):
    """X: name the shadowed, unreachable duplicate of a `local` declaration `_`."""
    scan = Scan(text).run()
    edits = scan.duplicate_edits()
    fixed = len(edits)
    new = _apply(scan.btext, edits).decode("utf-8") if edits else text
    return new, {"duplicates_fixed": fixed, "duplicates_skipped": dict(scan.skipped),
                 "duplicates_total": len(scan.dups)}


def apply_reuse(text):
    """W: split a name that stands for a closure and later for a reuse value."""
    scan = Scan(text).run()
    sites = scan.sites()
    edits = scan.reuse_edits()
    new = _apply(scan.btext, edits).decode("utf-8") if edits else text
    safe = sum(1 for s in sites.values() if s["reason"] is None)
    return new, {"reuse_sites": len(sites), "reuse_split": safe,
                 "reuse_skipped": dict(scan.skipped)}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    out = {}
    for path in a.files:
        with open(path, "r", encoding="utf-8") as f:
            text = f.read()
        scan = Scan(text).run()
        dups = scan.duplicate_edits()
        sites = scan.sites()
        reuse = scan.reuse_edits()
        reasons = {}
        for site in sites.values():
            key = site["reason"] or "safe"
            reasons[key] = reasons.get(key, 0) + 1
        out[path] = {"duplicate_decls": len(scan.dups),
                     "duplicates_fixable": len(dups),
                     "reuse_sites": len(sites), "reuse_reasons": reasons,
                     "reuse_edits": len(reuse),
                     "skips": dict(scan.skipped)}
        if a.json:
            continue
        print("== %s" % path)
        print("   duplicate declarations: %d   fixable now: %d" % (len(scan.dups), len(dups)))
        print("   reuse sites: %d   split-safe: %d   edits: %d"
              % (len(sites), reasons.get("safe", 0), len(reuse)))
        for k in sorted(reasons):
            print("     %-34s %d" % (k, reasons[k]))
        for k in sorted(scan.skipped):
            print("     skip: %-28s %d" % (k, scan.skipped[k]))
    if a.json:
        print(json.dumps(out, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
