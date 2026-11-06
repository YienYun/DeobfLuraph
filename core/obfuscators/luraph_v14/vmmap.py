"""Static analysis for Luraph v14.7/v14.8/v14.9: maps dispatch loops to their
opcode handlers and closure factories to the runtime capture metadata.

Unlike v15, the maker's prototype parameter can be argument 0, the opcode fetch
is commonly parenthesized (AstExprGroup) or type-asserted, and the dispatcher
can be a `repeat ... until false` loop. The VM closure is identified by the
local that directly declares the dispatcher's program counter, then bound
back to its lexical factory.
"""
import json
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(os.path.dirname(HERE))
BIN_DIR = os.path.join(ROOT, "..", "bin") if os.path.exists(os.path.join(ROOT, "..", "bin")) else os.path.join(ROOT, "bin")

def _normalize(n):
    """Fold parser-only wrappers (parenthesised expressions, type assertions)
    into their operands and turn `repeat ... until false` into `while true`,
    so the shared v15 engine sees one canonical shape."""
    if isinstance(n, dict):
        for k in list(n.keys()):
            v = n[k]
            if isinstance(v, dict) and v.get("type") in ("AstExprGroup", "AstExprTypeAssertion"):
                inner = v.get("expr") or v.get("expression")
                if inner is not None:
                    n[k] = _normalize(inner)
                    continue
            n[k] = _normalize(v)
        if n.get("type") == "AstStatRepeat":
            cond = n.get("condition")
            if isinstance(cond, dict) and cond.get("type") == "AstExprConstantBool" and not cond.get("value"):
                n["type"] = "AstStatWhile"
                n["condition"] = {"type": "AstExprConstantBool", "value": True,
                                  "location": cond.get("location", "")}
        return n
    if isinstance(n, list):
        for i, v in enumerate(n):
            if isinstance(v, dict) and v.get("type") in ("AstExprGroup", "AstExprTypeAssertion"):
                inner = v.get("expr") or v.get("expression")
                if inner is not None:
                    n[i] = _normalize(inner)
                    continue
            _normalize(v)
        return n
    return n


def load_ast(path):
    exe = os.path.join(BIN_DIR, "luau-ast.exe" if os.name == "nt" else "luau-ast")
    r = subprocess.run([exe, path], capture_output=True)
    errs = r.stderr.decode("latin-1").strip().splitlines()
    if r.returncode != 0 or (errs and errs[0].startswith("Parse errors")):
        raise SyntaxError("not valid Luau (%s)" % (errs[1].strip() if len(errs) > 1 else "luau-ast exit %#x"
                                                   % (r.returncode & 0xFFFFFFFF)))
    return _normalize(json.loads(r.stdout.decode("latin-1"))["root"])


def loc(node):
    a, b = node["location"].split(" - ")
    l1, c1 = map(int, a.split(","))
    l2, c2 = map(int, b.split(","))
    return l1, c1, l2, c2


def text_of(lines, node):
    l1, c1, l2, c2 = loc(node)
    if l1 == l2:
        return lines[l1][c1:c2]
    parts = [lines[l1][c1:]] + lines[l1 + 1:l2] + lines[l2][:c2]
    return "\n".join(parts)


def walk(node, fn):
    stack = [node]
    while stack:
        curr = stack.pop()
        if isinstance(curr, dict):
            fn(curr)
            stack.extend(curr.values())
        elif isinstance(curr, list):
            stack.extend(curr)


def unwrap(e):
    while isinstance(e, dict) and e.get("type") in ("AstExprGroup", "AstExprTypeAssertion"):
        e = e.get("expr") or e.get("expression")
    return e


def local_name(expr):
    expr = unwrap(expr)
    if isinstance(expr, dict) and expr.get("type") == "AstExprLocal":
        return expr["local"]["name"]
    return None


def find_dispatchers(root):
    found = []

    def visit(n):
        t = n.get("type")
        if t not in ("AstStatWhile", "AstStatRepeat"):
            return
        cond = unwrap(n.get("condition"))
        if not isinstance(cond, dict) or cond.get("type") != "AstExprConstantBool":
            return
        if t == "AstStatWhile" and not cond.get("value"):
            return
        if t == "AstStatRepeat" and cond.get("value"):
            return
        body = n["body"]["body"]
        if len(body) < 2 or body[0]["type"] not in ("AstStatLocal", "AstStatAssign"):
            return
        st = body[0]
        if len(st["values"]) != 1:
            return
        opname = st["vars"][0]["name"] if st["type"] == "AstStatLocal" else local_name(st["vars"][0])
        if not opname:
            return
        v = unwrap(st["values"][0])
        if not isinstance(v, dict) or v.get("type") != "AstExprIndexExpr":
            return
        arr, pc = local_name(v["expr"]), local_name(v["index"])
        if not arr or not pc or body[1]["type"] != "AstStatIf":
            return
        found.append({"node": n, "op": opname, "arr": arr, "pc": pc, "tree": body[1],
                      "rest": body[2:]})

    walk(root, visit)
    return found


OPS = {"CompareLt": lambda a, b: a < b, "CompareLe": lambda a, b: a <= b,
       "CompareGt": lambda a, b: a > b, "CompareGe": lambda a, b: a >= b,
       "CompareEq": lambda a, b: a == b, "CompareNe": lambda a, b: a != b}
FLIP = {"CompareLt": "CompareGt", "CompareLe": "CompareGe", "CompareGt": "CompareLt",
        "CompareGe": "CompareLe", "CompareEq": "CompareEq", "CompareNe": "CompareNe"}


def eval_cond(cond, var, value):
    if cond["type"] != "AstExprBinary" or cond["op"] not in OPS:
        return None
    l, r = unwrap(cond["left"]), unwrap(cond["right"])
    op = cond["op"]
    if local_name(l) == var and r["type"] == "AstExprConstantNumber":
        return OPS[op](value, r["value"])
    if local_name(r) == var and l["type"] == "AstExprConstantNumber":
        return OPS[FLIP[op]](value, l["value"])
    return None


def resolve(tree, var, value):
    node = tree
    while True:
        if node["type"] == "AstStatBlock":
            if len(node["body"]) >= 1 and node["body"][0]["type"] == "AstStatIf" \
                    and eval_cond(node["body"][0]["condition"], var, value) is not None:
                node = node["body"][0]
                continue
            return node
        if node["type"] == "AstStatIf":
            r = eval_cond(node["condition"], var, value)
            if r is None:
                return node
            node = r and node["thenbody"] or node["elsebody"]
            if node is None:
                return None
            continue
        return node


def decl_key(local):
    return local["location"]


def _decls_in(fn):
    keys = {}

    def visit(n):
        if isinstance(n, dict):
            t = n.get("type")
            if t == "AstExprFunction" and n is not fn:
                return
            if t == "AstStatLocal":
                for v in n["vars"]:
                    keys[decl_key(v)] = v["name"]
            elif t == "AstStatLocalFunction":
                keys[decl_key(n["name"])] = n["name"]["name"]
            elif t == "AstStatFor":
                keys[decl_key(n["var"])] = n["var"]["name"]
            elif t == "AstStatForIn":
                for v in n["vars"]:
                    keys[decl_key(v)] = v["name"]
            for v in n.values():
                visit(v)
        elif isinstance(n, list):
            for v in n:
                visit(v)
    for a in fn["args"]:
        keys[decl_key(a)] = a["name"]
    visit(fn["body"])
    return keys


def _binding_for_closure(clo, stmts, depth=None):
    for st, d in reversed(stmts):
        if depth is not None and d != depth:
            continue
        typ = st.get("type")
        if typ in ("AstStatAssign", "AstStatLocal"):
            for v, e in zip(st.get("vars", []), st.get("values", [])):
                if unwrap(e) is not clo:
                    continue
                name = local_name(v) if typ == "AstStatAssign" else v.get("name")
                if name:
                    return st, name
        elif typ == "AstStatLocalFunction":
            f = unwrap(st.get("func") or st.get("value") or st.get("function"))
            if f is clo:
                name = (st.get("name") or {}).get("name")
                if name:
                    return st, name
    return None, None


def _select_vm_factory(stack, stmts, disp):
    pc = disp.get("pc")
    for vi in range(len(stack) - 1, 0, -1):
        vm = stack[vi]
        try:
            decl_names = set(_decls_in(vm).values())
        except Exception:
            decl_names = set()
        if pc and pc not in decl_names:
            continue
        mi = vi - 1
        maker = stack[mi]
        st, var = _binding_for_closure(vm, stmts, vi)
        if st is not None and maker.get("args"):
            return mi, maker, vm, st, var
    for vi in range(len(stack) - 1, 0, -1):
        vm = stack[vi]
        try:
            decl_names = set(_decls_in(vm).values())
        except Exception:
            decl_names = set()
        if pc and pc not in decl_names:
            continue
        for mi in range(vi - 1, -1, -1):
            maker = stack[mi]
            if not maker.get("args"):
                continue
            st, var = _binding_for_closure(vm, stmts, mi + 1)
            if st is None:
                st, var = _binding_for_closure(vm, stmts)
            if st is not None:
                return mi, maker, vm, st, var
    for mi in range(len(stack) - 2, -1, -1):
        maker = stack[mi]
        if not maker.get("args"):
            continue
        for vi in range(mi + 1, len(stack)):
            vm = stack[vi]
            st, var = _binding_for_closure(vm, stmts, mi + 1)
            if st is not None:
                return mi, maker, vm, st, var
    return None


def closure_entries(root):
    dispatches = find_dispatchers(root)
    by_node = {id(d["node"]): d for d in dispatches}
    seen = {}

    def walk_tree(n, stack, stmts):
        if isinstance(n, dict):
            t = n.get("type")
            if t == "AstExprFunction":
                stack = stack + [n]
            if t and t.startswith("AstStat"):
                stmts = stmts + [(n, len(stack) + 1)]
            if t in ("AstStatWhile", "AstStatRepeat") and id(n) in by_node:
                picked = _select_vm_factory(stack, stmts, by_node[id(n)])
                if picked is not None:
                    _, maker, vm, _st, _var = picked
                    body = vm.get("body", {}).get("body", [])
                    if body:
                        l1, c1, _, _ = loc(body[0])
                        pi, _ui = _maker_params(maker)
                        args = maker.get("args", [])
                        if args and pi < len(args):
                            seen[(l1, c1)] = args[pi]["name"]
            for v in n.values():
                walk_tree(v, stack, stmts)
        elif isinstance(n, list):
            for v in n:
                walk_tree(v, stack, stmts)

    walk_tree(root, [], [])
    return [(l, c, name) for (l, c), name in seen.items()]


def maker_info(root, disp=None):
    dispatches = disp if disp is not None else find_dispatchers(root)
    by_node = {id(d["node"]): d for d in dispatches}
    out = {}

    def walk_tree(n, stack, stmts):
        if isinstance(n, dict):
            t = n.get("type")
            pushed_fn = False
            pushed_st = False
            if t == "AstExprFunction":
                stack.append(n)
                pushed_fn = True
            if t and t.startswith("AstStat"):
                stmts.append((n, len(stack) + 1))
                pushed_st = True
            if t in ("AstStatWhile", "AstStatRepeat") and id(n) in by_node:
                picked = _select_vm_factory(stack, stmts, by_node[id(n)])
                if picked is not None:
                    mi, maker, clo, st, var = picked
                    _, _, l2, c2 = loc(st)
                    if (l2, c2) not in out:
                        pi, ui = _maker_params(maker)
                        args = maker.get("args", [])
                        if args and pi < len(args):
                            out[(l2, c2)] = {
                                "at": (l2, c2), "var": var,
                                "proto": args[pi]["name"],
                                "proto_index": pi, "upvals_index": ui,
                                "pf_key": args[pi]["name"],
                                "maker": maker, "vm": clo, "stmt": st,
                                "maker_depth": mi,
                                "chain": list(stack[:mi]),
                                "dispatch_pc": by_node[id(n)].get("pc"),
                                "dispatch_arr": by_node[id(n)].get("arr"),
                            }
            for v in n.values():
                walk_tree(v, stack, stmts)
            if pushed_st:
                stmts.pop()
            if pushed_fn:
                stack.pop()
        elif isinstance(n, list):
            for v in n:
                walk_tree(v, stack, stmts)

    walk_tree(root, [], [])
    for info in out.values():
        info["captures"] = _captures(info)
        info["outer_env"] = _outer_captures(root, info)
    return list(out.values())


def _maker_params(maker):
    args = maker.get("args", [])
    if not args:
        return 0, 0
    visible = {}
    for i, a in enumerate(args):
        visible[a["name"]] = i
    direct, nested, used = {}, {}, set()

    def visit(n):
        if isinstance(n, dict):
            if n.get("type") == "AstExprLocal":
                used.add((n.get("local") or {}).get("location"))
            if n.get("type") == "AstExprIndexExpr":
                base = unwrap(n.get("expr"))
                idx = unwrap(n.get("index"))
                if isinstance(base, dict) and base.get("type") == "AstExprLocal":
                    key = (base.get("local") or {}).get("location")
                    if isinstance(idx, dict) and idx.get("type") == "AstExprConstantNumber":
                        direct[key] = direct.get(key, 0) + 4
                    if isinstance(idx, dict) and idx.get("type") == "AstExprIndexExpr":
                        ib = unwrap(idx.get("expr"))
                        if isinstance(ib, dict) and ib.get("type") == "AstExprLocal" \
                                and (ib.get("local") or {}).get("location") == key:
                            nested[key] = nested.get(key, 0) + 8
            for v in n.values():
                visit(v)
        elif isinstance(n, list):
            for v in n:
                visit(v)
    visit(maker.get("body"))
    candidates = list(visible.values())

    def score(i):
        key = args[i].get("location")
        return (nested.get(key, 0) + direct.get(key, 0), direct.get(key, 0), -i)

    pi = max(candidates, key=score) if candidates else 0
    remaining = [i for i in candidates if i != pi]
    if remaining:
        ui = max(remaining, key=lambda i: (args[i].get("location") in used,
                                            direct.get(args[i].get("location"), 0), -i))
    else:
        ui = pi
    return pi, ui


def _loc_start(key):
    a = str(key).split(" - ")[0]
    l, c = a.split(",")
    return int(l), int(c)


def ctor_assignments(root):
    """Functions assigned by index into a captured table anywhere in the
    source: `(d)[0x36]=function(...) ...` -> {(b"d", 54): fn}."""
    out = {}

    def _fix_int(v):
        return int(v) if isinstance(v, (int, float)) and float(v).is_integer() else v

    def visit(n):
        if isinstance(n, dict):
            if n.get("type") == "AstStatAssign":
                for var, val in zip(n.get("vars") or (), n.get("values") or ()):
                    val = unwrap(val)
                    if not isinstance(val, dict) or val.get("type") != "AstExprFunction":
                        continue
                    if var.get("type") == "AstExprIndexExpr":
                        base = local_name(unwrap(var.get("expr")))
                        idx = unwrap(var.get("index"))
                        if not base or not isinstance(idx, dict):
                            continue
                        if idx.get("type") == "AstExprConstantNumber":
                            out.setdefault((base.encode("latin-1"), _fix_int(idx["value"])), val)
                        elif idx.get("type") == "AstExprConstantString":
                            out.setdefault((base.encode("latin-1"), idx["value"].encode("latin-1")), val)
                    elif var.get("type") == "AstExprIndexName":
                        base = local_name(unwrap(var.get("expr")))
                        idx_nm = var.get("index")
                        if base and isinstance(idx_nm, str):
                            out.setdefault((base.encode("latin-1"), idx_nm.encode("latin-1")), val)
            for v in list(n.values()):
                visit(v)
        elif isinstance(n, list):
            for v in n:
                visit(v)
    visit(root)
    return out


def outer_decls(root, target):
    """{decl key: name} of every declaration outside `target` (a function
    node) that encloses it on the root->target path."""
    found = {}

    def visit(n, stack):
        if isinstance(n, dict):
            t = n.get("type")
            pushed = False
            if t == "AstExprFunction":
                stack.append(n)
                pushed = True
            if n is target:
                for fn in stack[:-1]:
                    for k, nm in _decls_in(fn).items():
                        found[k] = nm
            for v in list(n.values()):
                visit(v, stack)
            if pushed:
                stack.pop()
        elif isinstance(n, list):
            for v in n:
                visit(v, stack)
    visit(root, [])
    return found


def plain_curried_makers(root):
    """Curried LPH_NO_VIRTUALIZE factories in setmetatable({...}) ctor tables."""
    disp_nodes = {id(d["node"]) for d in find_dispatchers(root)}
    hooked_locs = set()
    for info in maker_info(root):
        c3 = info.get("curried3")
        if c3:
            hooked_locs.add(c3["f3"]["location"])
            hooked_locs.add(c3["f2"]["location"])
            if c3.get("f1"):
                hooked_locs.add(c3["f1"]["location"])

    def _contains_disp(fn):
        st = [fn]
        while st:
            x = st.pop()
            if isinstance(x, dict):
                if id(x) in disp_nodes:
                    return True
                st.extend(x.values())
            elif isinstance(x, list):
                st.extend(x)
        return False

    out = []
    seen = set()

    def visit(n):
        if isinstance(n, dict):
            if n.get("type") == "AstExprCall" and n["func"].get("type") == "AstExprGlobal" \
                    and n["func"]["global"] == "setmetatable" and n["args"] \
                    and n["args"][0]["type"] == "AstExprTable":
                for it in n["args"][0]["items"]:
                    f3 = it.get("value")
                    if not isinstance(f3, dict) or f3.get("type") != "AstExprFunction":
                        continue
                    if f3.get("vararg") or len(f3.get("args") or []) < 2:
                        continue
                    b3 = (f3.get("body") or {}).get("body") or []
                    if len(b3) != 1 or b3[0].get("type") != "AstStatReturn" or len(b3[0].get("list") or []) != 1:
                        continue
                    f2 = b3[0]["list"][0]
                    if not isinstance(f2, dict) or f2.get("type") != "AstExprFunction" or f2.get("vararg"):
                        continue
                    b2 = (f2.get("body") or {}).get("body") or []
                    if not b2 or b2[-1].get("type") != "AstStatReturn" or len(b2[-1].get("list") or []) != 1:
                        continue
                    if not all(st.get("type") == "AstStatLocal" for st in b2[:-1]):
                        continue
                    f1 = b2[-1]["list"][0]
                    if not isinstance(f1, dict) or f1.get("type") != "AstExprFunction":
                        continue
                    b1 = (f1.get("body") or {}).get("body") or []
                    if (len(b1) == 2 and b1[0].get("type") == "AstStatLocal"
                            and b1[1].get("type") == "AstStatWhile"
                            and (b1[1].get("condition") or {}).get("type") == "AstExprConstantBool"
                            and b1[1]["condition"].get("value") is True):
                        continue
                    if f3["location"] in hooked_locs or f2["location"] in hooked_locs or _contains_disp(f1):
                        continue
                    if f2["location"] in seen:
                        continue
                    seen.add(f2["location"])
                    l2, c2, _, _ = loc(f2)
                    out.append({"at": (l2, c2), "f3": f3, "f2": f2, "f1": f1})
            for v in n.values():
                visit(v)
        elif isinstance(n, list):
            for v in n:
                visit(v)
    visit(root)
    return out


def _captures(info):
    maker_decls = _decls_in(info["maker"])
    chain_decls = {}
    if info.get("chain"):
        mk = _loc_start(info["maker"]["location"])
        for fn in info["chain"]:
            for k, nm in _decls_in(fn).items():
                if _loc_start(k) <= mk:
                    chain_decls.setdefault(nm, []).append(k)

    used_maker = {}
    used_chain = {}

    def visit(n):
        if isinstance(n, dict):
            if n.get("type") == "AstExprLocal":
                k = decl_key(n["local"])
                nm = n["local"]["name"]
                if k in maker_decls:
                    used_maker[k] = nm
                elif nm in chain_decls and k in chain_decls[nm]:
                    used_chain[k] = nm
            for v in n.values():
                visit(v)
        elif isinstance(n, list):
            for v in n:
                visit(v)
    visit(info["vm"])

    def single(members, decls_by_name):
        names = {}
        for k, nm in members.items():
            names.setdefault(nm, set()).add(k)
        return {nm for nm, ks in names.items() if len(ks) == 1 and len(decls_by_name.get(nm, [])) == 1}

    maker_by_name = {}
    for k, nm in maker_decls.items():
        maker_by_name.setdefault(nm, []).append(k)
    maker_names = set(maker_by_name.keys())
    caps = single(used_maker, maker_by_name)
    for nm in single(used_chain, chain_decls):
        if nm not in maker_names:
            caps.add(nm)
    return sorted(caps)


def _outer_captures(root, info):
    enclosing = outer_decls(root, info["maker"])
    maker_names = set(_decls_in(info["maker"]).values())
    found = {}

    def visit(n):
        if isinstance(n, dict):
            if n.get("type") == "AstExprLocal":
                loc_ = n.get("local") or {}
                key = decl_key(loc_)
                if key in enclosing and loc_.get("name"):
                    found.setdefault(key, loc_["name"])
            for v in n.values():
                visit(v)
        elif isinstance(n, list):
            for v in n:
                visit(v)
    visit(info["maker"].get("body"))
    by_name = {}
    for key, name in found.items():
        by_name.setdefault(name, []).append(key)
    out = []
    idx = 0
    for key in sorted(found, key=repr):
        name = found[key]
        if len(by_name[name]) != 1:
            continue
        idx += 1
        out.append({
            "decl": key,
            "name": name,
            "field": "__venv%d" % idx,
            "shadowed": name in maker_names,
        })
    return out


if __name__ == "__main__":
    src = sys.argv[1]
    root = load_ast(src)
    print("dispatchers: %d  entries: %d  makers: %d"
          % (len(find_dispatchers(root)), len(closure_entries(root)), len(maker_info(root))))