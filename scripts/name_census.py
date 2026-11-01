#!/usr/bin/env python3
"""Census of locals that hold a function and are later assigned something else.

The lifter stores a closure in a register and renders it as a named local
(`local function X(...) ... end`, or `local X = function ... end`). The same
register is often reused afterwards for an unrelated value, and both writes share
one local, so the reuse is printed as an assignment to the function's own name:

    local function RunService2(argument) ... end
    RunService2 = context.state
    ... RunService2.AREAS ...          -- reads the reuse value, not the closure

That is confusing but not automatically wrong -- after the assignment the
variable really does hold the reuse value. The dangerous shape is a read that is
*not* dominated by the assignment (the assignment sits inside a branch the read
is outside of): there the variable may still hold the closure, and one name
hides which value the code sees.

Scope awareness: a local is identified by the AST's `local.location`, so a
*different* local reusing the same name in another scope (real shadowing, which
is correct code) is never counted as a site. Shadowing is reported separately.

Dominance: an assignment dominates a read when, at the deepest block the two
share, the assignment's statement comes first, and nothing between that point and
the assignment executes conditionally (an `if`/loop body makes it a maybe). A
read inside a nested function is never dominated by an assignment in the parent
(the closure runs later, possibly many times), and vice versa.

Usage:
    python3 scripts/name_census.py [--json] FILE...

Exit code 1 if any site has an undominated read (the stop-and-ask shape).
"""
import argparse
import json
import os
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
AST = os.path.join(ROOT, "bin", "luau-ast")


def loc(s):
    """'l1,c1 - l2,c2' -> ((l1, c1), (l2, c2)) with 1-based lines."""
    a, b = s.split(" - ")
    l1, c1 = a.split(",")
    l2, c2 = b.split(",")
    return (int(l1) + 1, int(c1) + 1), (int(l2) + 1, int(c2) + 1)


class Census:
    def __init__(self, path):
        self.path = path
        r = subprocess.run([AST, path], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        if r.returncode != 0:
            raise SystemExit("%s: luau-ast failed: %s" % (path, r.stderr.decode("latin-1")[:400]))
        self.root = json.loads(r.stdout.decode("latin-1"))["root"]
        self.locals = {}     # location -> decl info
        self.assigns = []    # (location, path, line, pos, fn_depth)
        self.reads = []      # (location, path, line, pos, fn_depth)
        self.dup_decls = []  # one `local a, a = ...`: two locals, one name
        self.fn_depth = 0

    # ---- traversal -------------------------------------------------------
    def run(self):
        self.walk_block(self.root, (), False)
        return self

    def walk_block(self, blk, path, guarded):
        for i, st in enumerate(blk.get("body") or ()):
            self.walk_stat(st, path + ((id(blk), i, guarded),), guarded)

    def _decl(self, node, kind, line, pos):
        self.locals.setdefault(node["location"], {
            "name": node["name"], "kind": kind, "line": line, "pos": pos,
            "fn_depth": self.fn_depth})

    def walk_stat(self, st, path, guarded):
        t = st.get("type")
        s0 = loc(st["location"])[0]
        if t == "AstStatLocalFunction":
            self._decl(st["name"], "LF", s0[0], s0)
            self.walk_expr(st["func"], path)
            return
        if t == "AstStatLocal":
            vals = st.get("values") or []
            for v in vals:
                self.walk_expr(v, path)
            names = [v["name"] for v in st.get("vars") or ()]
            if len(set(names)) != len(names):
                self.dup_decls.append({"line": s0[0], "names": names})
            for i, var in enumerate(st.get("vars") or ()):
                kind = "LV" if i < len(vals) and vals[i].get("type") == "AstExprFunction" else "value"
                self._decl(var, kind, s0[0], s0)
            return
        if t in ("AstStatAssign", "AstStatCompoundAssign"):
            for v in st.get("values") or ():
                self.walk_expr(v, path)
            for var in (st.get("vars") or ([st["var"]] if st.get("var") else [])):
                if var.get("type") == "AstExprLocal":
                    self.assigns.append((var["local"]["location"], path, s0[0], s0, self.fn_depth))
                    self.locals.setdefault(var["local"]["location"], {
                        "name": var["local"]["name"], "kind": "value", "line": s0[0],
                        "pos": s0, "fn_depth": self.fn_depth})
                else:
                    self.walk_expr(var, path)
            return
        if t == "AstStatBlock":
            self.walk_block(st, path, guarded)
            return
        if t == "AstStatIf":
            self.walk_expr(st["condition"], path)
            self.walk_block(st["thenbody"], path, True)
            e = st.get("elsebody")
            if e is not None:
                if e.get("type") == "AstStatIf":
                    self.walk_stat(e, path, True)
                else:
                    self.walk_block(e, path, True)
            return
        if t in ("AstStatWhile", "AstStatRepeat"):
            self.walk_expr(st["condition"], path)
            self.walk_block(st["body"], path, True)
            return
        if t in ("AstStatFor", "AstStatForIn"):
            for k in ("from", "to", "step"):
                if st.get(k):
                    self.walk_expr(st[k], path)
            for v in st.get("values") or ():
                self.walk_expr(v, path)
            self.walk_block(st["body"], path, True)
            return
        for k, v in st.items():
            if isinstance(v, dict) and str(v.get("type", "")).startswith("AstExpr"):
                self.walk_expr(v, path)
            elif isinstance(v, list):
                for x in v:
                    if isinstance(x, dict) and str(x.get("type", "")).startswith("AstExpr"):
                        self.walk_expr(x, path)

    def walk_expr(self, e, path):
        t = e.get("type")
        if t == "AstExprLocal":
            self.reads.append((e["local"]["location"], path, loc(e["location"])[0][0],
                               loc(e["location"])[0], self.fn_depth))
            return
        if t == "AstExprFunction":
            self.fn_depth += 1
            for a in e.get("args") or ():
                if a.get("name"):
                    self._decl(a, "value", loc(a["location"])[0][0], loc(a["location"])[0])
            self.walk_block(e["body"], path, False)
            self.fn_depth -= 1
            return
        for k, v in e.items():
            if isinstance(v, dict) and str(v.get("type", "")).startswith("AstExpr"):
                self.walk_expr(v, path)
            elif isinstance(v, list):
                for x in v:
                    if isinstance(x, dict) and str(x.get("type", "")).startswith("AstExpr"):
                        self.walk_expr(x, path)

    # ---- analysis --------------------------------------------------------
    @staticmethod
    def dominated(assign, read):
        """See the module docstring: first-statement-wins inside the deepest
        shared block, and no conditional between that block and the assignment."""
        pa, pr = assign[1], read[1]
        deepest = 0
        while deepest < len(pa) and deepest < len(pr) and pa[deepest][0] == pr[deepest][0]:
            deepest += 1
        if deepest == 0:
            return False
        ia, ir = pa[deepest - 1][1], pr[deepest - 1][1]
        if ia >= ir:
            return False
        # every statement between the shared block and the assignment must run
        # unconditionally, or the assignment is only a maybe at the read
        return not any(pa[k][2] for k in range(deepest, len(pa)))

    def sites(self):
        by_loc = {}
        for a in self.assigns:
            by_loc.setdefault(a[0], []).append(a)
        out = []
        for key, info in self.locals.items():
            if info["kind"] not in ("LF", "LV"):
                continue
            asg = sorted((a for a in by_loc.get(key, ()) if a[3] > info["pos"]), key=lambda a: a[3])
            if not asg:
                continue
            first = asg[0]
            after = [r for r in self.reads if r[0] == key and r[3] > first[3]]
            def ok(r):
                # the closure is certainly gone at the read once *any* earlier
                # reuse assignment dominates it; the later assignments only
                # change which reuse value is there, not whether the closure is
                return any(self.dominated(a, r) for a in asg if a[3] < r[3] and a[4] == r[4])
            dom = [r for r in after if ok(r)]
            und = [r for r in after if not ok(r)]
            out.append({
                "name": info["name"], "kind": info["kind"], "decl_line": info["line"],
                "assign_line": first[2], "assigns": len(asg),
                "assign_lines": [a[2] for a in asg],
                "reads_after": len(after), "dominated": len(dom), "undominated": len(und),
                "undominated_lines": sorted({r[2] for r in und}),
                "nested_reads": sum(1 for r in after if r[4] > first[4]),
            })
        return sorted(out, key=lambda s: (s["decl_line"], s["name"]))

    def shadowing(self):
        """Same name, *different* locals: correct code the census must not flag."""
        by_name = {}
        for key, info in self.locals.items():
            by_name.setdefault(info["name"], set()).add(key)
        return {nm: len(keys) for nm, keys in by_name.items() if len(keys) > 1}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+")
    ap.add_argument("--json", action="store_true")
    a = ap.parse_args()
    rc = 0
    result = {}
    for path in a.files:
        c = Census(path).run()
        sites = c.sites()
        shadow = c.shadowing()
        result[path] = {"sites": sites, "shadowed_names": len(shadow),
                        "shadow_names": sorted(shadow), "dup_decls": c.dup_decls}
        if a.json:
            continue
        print("== %s" % path)
        print("   sites: %d   names with more than one local (shadowing, not a site): %d"
              % (len(sites), len(shadow)))
        print("   duplicate names in one local declaration: %d%s"
              % (len(c.dup_decls), "".join(
                  "\n     %6d %r" % (d["line"], d["names"]) for d in c.dup_decls[:5])))
        print("   %-26s %-3s %6s %6s %7s %5s %5s %5s" %
              ("name", "kind", "decl", "assign", "assigns", "read+", "dom", "undom"))
        for s in sites:
            print("   %-26s %-3s %6d %6d %7d %5d %5d %5d%s" %
                  (s["name"], s["kind"], s["decl_line"], s["assign_line"], s["assigns"],
                   s["reads_after"], s["dominated"], s["undominated"],
                   "  <-- UNDOMINATED %r" % (s["undominated_lines"][:5],) if s["undominated"] else ""))
        if any(s["undominated"] for s in sites):
            rc = 1
    if a.json:
        print(json.dumps(result, indent=1))
    return rc


if __name__ == "__main__":
    sys.exit(main())
