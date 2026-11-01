"""Name a local that carries more than one binding (category X).

The lifter recovers the obfuscated chunk's own local names (`capnames`, the
wrapper's identifiers) and prints one name per VM register. A register is not a
variable, though: the VM reuses it, and two registers can carry the same
recovered name, so one printed name can stand for two different locals:

    local a, a = f(), g()      -- two locals, one name, one statement

A `local` declaration's initialisers are evaluated before any of the new locals
is in scope, so the earlier `a` can never be read. It is renamed to `_` -- only
when the AST proves it, i.e. when no read and no assignment target resolves to
that declaration. A statement whose shadowed duplicate does have a reference
would mean the scoping assumption is wrong for it: it is counted as
`duplicate-still-referenced` and left alone. Every skip is reported by reason.
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
        self.fn_info = {}   # id(fn node) -> {"line": declaration line}
        self.all_names = set()  # every identifier in the file (fresh names avoid these)
        self.order = 0
        self.skipped = {}   # reason -> count (fills during analysis)

    # ---- traversal -------------------------------------------------------
    def run(self):
        self.walk_block(self.root, (), False, (), None)
        return self

    def _decl(self, node, kind, fn, order, pos):
        loc_key = node["location"]
        self.locals.setdefault(loc_key, {
            "name": node["name"], "kind": kind, "fn": fn, "order": order,
            "line": pos[0], "col": pos[1]})
        self.all_names.add(node["name"])

    def walk_block(self, blk, path, guarded, loops, fn):
        for i, st in enumerate(blk.get("body") or ()):
            self.order += 1
            self.walk_stat(st, path + ((id(blk), i, guarded),), guarded, loops, fn, self.order)

    def walk_stat(self, st, path, guarded, loops, fn, order):
        t = st.get("type")
        start = _start(st["location"])
        if t == "AstStatLocalFunction":
            self.walk_expr(st["func"], path, loops, fn)
            self._decl(st["name"], "LF", fn, order, start)
            return
        if t == "AstStatLocal":
            vals = st.get("values") or []
            for v in vals:
                self.walk_expr(v, path, loops, fn)
            group = []
            for i, var in enumerate(st.get("vars") or ()):
                kind = "LV" if i < len(vals) and vals[i].get("type") == "AstExprFunction" else "value"
                self._decl(var, kind, fn, order, start)
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
                    self._ref(st["var"], "r", path, loops, fn, self.order)
                vars_ = [st["var"]]
            for var in vars_:
                if var.get("type") == "AstExprLocal":
                    self._ref(var, "w", path, loops, fn, order)
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
            self.walk_block(st["body"], path, True, loops + (id(st["body"]),), fn)
            return
        if t in ("AstStatFor", "AstStatForIn"):
            for k in ("from", "to", "step"):
                if st.get(k) is not None:
                    self.walk_expr(st[k], path, loops, fn)
            for v in (st.get("values") or ()):
                self.walk_expr(v, path, loops, fn)
            for var in (st.get("vars") or ([st["var"]] if st.get("var") else [])):
                self._decl(var, "value", fn, order, start)
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

    def _ref(self, e, kind, path, loops, fn, order):
        loc_key = e["local"]["location"]
        s0, e0 = _loc_bytes(e["location"], self.starts)
        self.all_names.add(e["local"]["name"])
        rec = {"loc": loc_key, "kind": kind, "path": path, "loops": loops,
               "fn": fn, "order": order, "s0": s0, "e0": e0,
               "line": _start(e["location"])[0]}
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
            self.fn_info[fid] = {"line": _start(e["location"])[0]}
            self.order += 1
            body_order = self.order
            for a in e.get("args") or ():
                if a.get("name"):
                    self._decl(a, "value", fid, body_order, _start(a["location"]))
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

    def _skip(self, reason):
        self.skipped[reason] = self.skipped.get(reason, 0) + 1

def apply_duplicates(text):
    """X: name the shadowed, unreachable duplicate of a `local` declaration `_`."""
    scan = Scan(text).run()
    edits = scan.duplicate_edits()
    fixed = len(edits)
    new = _apply(scan.btext, edits).decode("utf-8") if edits else text
    return new, {"duplicates_fixed": fixed, "duplicates_skipped": dict(scan.skipped),
                 "duplicates_total": len(scan.dups)}


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
        out[path] = {"duplicate_decls": len(scan.dups),
                     "duplicates_fixable": len(dups),
                     "skips": dict(scan.skipped)}
        if a.json:
            continue
        print("== %s" % path)
        print("   duplicate declarations: %d   fixable now: %d" % (len(scan.dups), len(dups)))
        for k in sorted(scan.skipped):
            print("     skip: %-28s %d" % (k, scan.skipped[k]))
    if a.json:
        print(json.dumps(out, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
