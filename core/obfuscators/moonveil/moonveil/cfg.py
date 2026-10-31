"""CFG extraction and Lua emission for the recognized numeric-dispatch profile."""

from collections import deque
import copy, math
from .front import Unsupported, quote, lua_bytes, walk as _walk


def num(v):
    return {
        "type": "NumericLiteral",
        "value": int(v) if int(v) == v else v,
        "raw": str(v),
    }


def truth(v):
    return v is not False and v is not None


UNKNOWN = object()


def eval_const(x, env={}):
    if not isinstance(x, dict):
        return UNKNOWN
    t = x.get("type")
    if t in ("NumericLiteral", "StringLiteral", "BooleanLiteral", "NilLiteral"):
        return x.get("value")
    if t == "Identifier":
        return env.get(x["name"], UNKNOWN)
    if t == "UnaryExpression":
        v = eval_const(x["argument"], env)
        if v is UNKNOWN:
            return UNKNOWN
        if x["operator"] == "-":
            return -v
        if x["operator"] == "not":
            return not truth(v)
        if x["operator"] == "#" and isinstance(v, str):
            return len(v)
    if t in ("BinaryExpression", "LogicalExpression"):
        a, b = eval_const(x["left"], env), eval_const(x["right"], env)
        op = x["operator"]
        if op == "and" and a is not UNKNOWN:
            return b if truth(a) else a
        if op == "or" and a is not UNKNOWN:
            return a if truth(a) else b
        if a is UNKNOWN or b is UNKNOWN:
            return UNKNOWN
        if op == "+":
            return a + b
        if op == "-":
            return a - b
        if op == "*":
            return a * b
        if op == "/":
            return a / b
        if op == "%":
            return a % b
        if op == "^":
            return a**b
        if op == "==":
            return a == b
        if op == "~=":
            return a != b
        if op == ">":
            return a > b
        if op == "<":
            return a < b
        if op == ">=":
            return a >= b
        if op == "<=":
            return a <= b
    return UNKNOWN


def simpl(x, env):
    if isinstance(x, list):
        return [simpl(v, env) for v in x]
    if not isinstance(x, dict):
        return x
    if x.get("type") == "FunctionDeclaration":
        return copy.deepcopy(x)
    if x.get("type") == "Identifier" and x["name"] in env:
        return num(env[x["name"]])
    y = {
        k: (
            copy.deepcopy(v)
            if (k == "identifier" and x.get("type") == "MemberExpression")
            or (k == "key" and x.get("type") == "TableKeyString")
            else simpl(v, env)
        )
        for k, v in x.items()
        if k not in ("range", "loc")
    }
    if y.get("type") in ("BinaryExpression", "UnaryExpression", "LogicalExpression"):
        v = eval_const(y)
        if v is not UNKNOWN:
            if isinstance(v, bool):
                return {"type": "BooleanLiteral", "value": v, "raw": str(v).lower()}
            if isinstance(v, (int, float)):
                return num(v)
    return y


def _expr(x):
    t = x["type"]
    if t == "Identifier":
        return x["name"]
    if t == "NumericLiteral":
        return (
            str(int(x["value"])) if x["value"] == int(x["value"]) else repr(x["value"])
        )
    if t == "StringLiteral":
        return quote(lua_bytes(x["value"]))
    if t == "BooleanLiteral":
        return "true" if x["value"] else "false"
    if t == "NilLiteral":
        return "nil"
    if t == "VarargLiteral":
        return "..."
    if t == "MemberExpression":
        return expr(x["base"]) + x["indexer"] + x["identifier"]["name"]
    if t == "IndexExpression":
        return expr(x["base"]) + "[" + expr(x["index"]) + "]"
    if t == "UnaryExpression":
        return "(" + x["operator"] + " " + expr(x["argument"]) + ")"
    if t in ("BinaryExpression", "LogicalExpression"):
        return (
            "(" + expr(x["left"]) + " " + x["operator"] + " " + expr(x["right"]) + ")"
        )
    if t == "CallExpression":
        return expr(x["base"]) + "(" + ", ".join(expr(a) for a in x["arguments"]) + ")"
    if t == "TableCallExpression":
        return expr(x["base"]) + "(" + expr(x["arguments"]) + ")"
    if t == "StringCallExpression":
        return expr(x["base"]) + "(" + expr(x["argument"]) + ")"
    if t == "TableConstructorExpression":
        fs = []
        for f in x["fields"]:
            if f["type"] == "TableValue":
                fs.append(expr(f["value"]))
            elif f["type"] == "TableKeyString":
                fs.append(f["key"]["name"] + " = " + expr(f["value"]))
            else:
                fs.append("[" + expr(f["key"]) + "] = " + expr(f["value"]))
        return "{" + ", ".join(fs) + "}"
    if t == "FunctionDeclaration":
        return (
            "function("
            + ", ".join(expr(p) for p in x["parameters"])
            + ")\n"
            + block(x["body"], 1)
            + "\nend"
        )
    raise ValueError(t)


def statement(s, level=0):
    pad = "    " * level
    t = s["type"]
    if t in ("AssignmentStatement", "LocalStatement"):
        text = (
            ("local " if t == "LocalStatement" else "")
            + ", ".join(expr(v) for v in s["variables"])
            + (" = " + ", ".join(expr(v) for v in s["init"]) if s["init"] else "")
        )
        return pad + text.replace("\n", "\n" + pad)
    if t == "ReturnStatement":
        return pad + ("return " + ", ".join(expr(v) for v in s["arguments"])).replace(
            "\n", "\n" + pad
        )
    if t == "CallStatement":
        return pad + expr(s["expression"]).replace("\n", "\n" + pad)
    if t == "BreakStatement":
        return pad + "break"
    if t == "IfStatement":
        out = []
        for idx, c in enumerate(s["clauses"]):
            out.append(
                pad
                + (
                    "if " + expr(c["condition"]) + " then"
                    if idx == 0
                    else (
                        "elseif " + expr(c["condition"]) + " then"
                        if "condition" in c
                        else "else"
                    )
                )
            )
            out.append(block(c["body"], level + 1))
        out.append(pad + "end")
        return "\n".join(out)
    if t == "WhileStatement":
        return (
            pad
            + "while "
            + expr(s["condition"])
            + " do\n"
            + block(s["body"], level + 1)
            + "\n"
            + pad
            + "end"
        )
    if t == "RepeatStatement":
        return (
            pad
            + "repeat\n"
            + block(s["body"], level + 1)
            + "\n"
            + pad
            + "until "
            + expr(s["condition"])
        )
    if t == "FunctionDeclaration":
        return (
            pad
            + ("local " if s.get("isLocal") else "")
            + "function "
            + expr(s["identifier"])
            + "("
            + ", ".join(expr(p) for p in s["parameters"])
            + ")\n"
            + block(s["body"], level + 1)
            + "\n"
            + pad
            + "end"
        )
    if t == "ForNumericStatement":
        return (
            pad
            + "for "
            + expr(s["variable"])
            + " = "
            + expr(s["start"])
            + ", "
            + expr(s["end"])
            + (", " + expr(s["step"]) if s.get("step") else "")
            + " do\n"
            + block(s["body"], level + 1)
            + "\n"
            + pad
            + "end"
        )
    if t == "ForGenericStatement":
        return (
            pad
            + "for "
            + ", ".join(expr(v) for v in s["variables"])
            + " in "
            + ", ".join(expr(v) for v in s["iterators"])
            + " do\n"
            + block(s["body"], level + 1)
            + "\n"
            + pad
            + "end"
        )
    if t == "DoStatement":
        return pad + "do\n" + block(s["body"], level + 1) + "\n" + pad + "end"
    raise ValueError(t)


def block(ss, level=0):
    return "\n".join(
        statement(s, level)
        for s in ss
        if not (s["type"] == "LocalStatement" and not s["variables"])
    )


def select(ss, statevar, state):
    selected = []
    for s in ss:
        if s["type"] == "IfStatement":
            for c in s["clauses"]:
                v = (
                    eval_const(c["condition"], {statevar: state})
                    if "condition" in c
                    else True
                )
                if v is UNKNOWN:
                    raise ValueError("not a dispatcher: " + expr(c["condition"]))
                if truth(v):
                    selected.extend(select(c["body"], statevar, state))
                    break
        else:
            selected.append(s)
    return selected


def branch(x):
    val = eval_const(x)
    if val is not UNKNOWN:
        assert isinstance(val, (int, float)) and not isinstance(val, bool), (val, x)
        assert abs(val - round(val)) < 1e-8, (val, x)
        return {"goto": int(round(val))}
    if (
        x["type"] == "LogicalExpression"
        and x["operator"] == "or"
        and x["left"]["type"] == "LogicalExpression"
        and x["left"]["operator"] == "and"
    ):
        return {
            "cond": x["left"]["left"],
            "yes": branch(x["left"]["right"]),
            "no": branch(x["right"]),
        }
    raise ValueError("Unhandled branch " + expr(x))


def leaves(t):
    if "goto" in t:
        return {t["goto"]}
    if "cond" in t:
        return leaves(t["yes"]) | leaves(t["no"])
    return set()


def build_graph(fn):
    loops = [
        (i, s)
        for i, s in enumerate(fn["body"])
        if s["type"] in ("WhileStatement", "RepeatStatement")
    ]
    if not loops:
        return None
    assert len(loops) == 1
    li, loop = loops[0]
    test = loop["body"][0]["clauses"][0]["condition"]
    assert test["type"] == "BinaryExpression"
    var = test["left"]["name"]
    initial = None
    prefix = []
    for s in fn["body"][:li]:
        if s["type"] == "LocalStatement":
            q = copy.deepcopy(s)
            q["variables"] = [v for v in q["variables"] if v.get("name") != var]
            prefix.append(q)
        elif s["type"] == "AssignmentStatement" and any(
            v.get("name") == var for v in s["variables"]
        ):
            q = copy.deepcopy(s)
            vs = []
            vsinit = []
            for k, v in enumerate(q["variables"]):
                if v.get("name") == var:
                    initial = eval_const(q["init"][k])
                else:
                    vs.append(v)
                    vsinit.append(q["init"][k])
            if vs:
                q["variables"] = vs
                q["init"] = vsinit
                prefix.append(q)
        else:
            prefix.append(s)
    assert isinstance(initial, (float, int)), (initial, var)
    used = {
        n.get("name")
        for n in _walk(fn)
        if n.get("type") == "Identifier"
    }
    nodes = {}
    todo = [initial]
    while todo:
        state = todo.pop()
        if state in nodes:
            continue
        if len(nodes) > 10000:
            raise ValueError("too many states")
        body = select(loop["body"], var, state)
        current = num(state)
        stmts = []
        term = None
        for s in body:
            if s["type"] == "AssignmentStatement":
                rhs = (
                    simpl(s["init"], {var: eval_const(current)})
                    if eval_const(current) is not UNKNOWN
                    else copy.deepcopy(s["init"])
                )
                vs = []
                ins = []
                for j, v in enumerate(s["variables"]):
                    if v.get("type") == "Identifier" and v["name"] == var:
                        current = rhs[j]
                        if eval_const(current) is UNKNOWN:
                            decision = branch(current)
                            if (
                                "cond" not in decision
                                or "goto" not in decision["yes"]
                                or "goto" not in decision["no"]
                            ):
                                raise Unsupported(
                                    "Nested state selectors need an additional lowering pass"
                                )
                            # Capture at the original assignment point. Later register writes in this
                            # basic block must not change the already-selected branch.
                            condname = "__mv_branch_" + str(int(state)).replace(
                                "-", "n"
                            )
                            while condname in used:
                                condname += "x"
                            used.add(condname)
                            condnode = {"type": "Identifier", "name": condname}
                            stmts.append(
                                {
                                    "type": "LocalStatement",
                                    "variables": [condnode],
                                    "init": [decision["cond"]],
                                }
                            )
                            current = {
                                "type": "LogicalExpression",
                                "operator": "or",
                                "left": {
                                    "type": "LogicalExpression",
                                    "operator": "and",
                                    "left": condnode,
                                    "right": num(decision["yes"]["goto"]),
                                },
                                "right": num(decision["no"]["goto"]),
                            }
                    else:
                        vs.append(v)
                        if j < len(rhs):
                            ins.append(rhs[j])
                if vs:
                    stmts.append(
                        {"type": "AssignmentStatement", "variables": vs, "init": ins}
                    )
            else:
                stmts.append(s)
                if s["type"] == "ReturnStatement":
                    term = {"return": True}
        if term is None:
            term = branch(current)
        nodes[state] = {"stmts": stmts, "term": term}
        todo.extend(leaves(term) - nodes.keys())
    return sccp_prune_graph(
        {
            "var": var,
            "start": initial,
            "prefix": prefix,
            "nodes": nodes,
            "suffix": fn["body"][li + 1 :],
        }
    )


_SCCP_TOP = object()


def _is_pure_sccp_expr(node) -> bool:
    if not isinstance(node, dict):
        return True
    t = node.get("type")
    if t in ("NumericLiteral", "BooleanLiteral", "NilLiteral", "StringLiteral", "Identifier"):
        return True
    if t == "UnaryExpression":
        return node.get("operator") in ("-", "not", "#") and _is_pure_sccp_expr(node.get("argument"))
    if t in ("BinaryExpression", "LogicalExpression"):
        return _is_pure_sccp_expr(node.get("left")) and _is_pure_sccp_expr(node.get("right"))
    return False


def _eval_sccp_expr(node, env: dict):
    if not isinstance(node, dict):
        return _SCCP_TOP
    t = node.get("type")
    if t == "NumericLiteral":
        v = node.get("value")
        return float(v) if isinstance(v, (int, float)) and not isinstance(v, bool) else _SCCP_TOP
    if t == "BooleanLiteral":
        return bool(node.get("value"))
    if t == "NilLiteral":
        return None
    if t == "StringLiteral":
        return str(node.get("value", ""))
    if t == "Identifier":
        return env.get(node["name"], _SCCP_TOP)
    if t == "UnaryExpression":
        v = _eval_sccp_expr(node.get("argument"), env)
        if v is _SCCP_TOP:
            return _SCCP_TOP
        op = node.get("operator")
        if op == "-" and isinstance(v, (int, float)) and not isinstance(v, bool):
            return -float(v)
        if op == "not":
            return v is None or v is False
        if op == "#" and isinstance(v, str):
            return float(len(v))
        return _SCCP_TOP
    if t == "LogicalExpression":
        op = node.get("operator")
        lv = _eval_sccp_expr(node.get("left"), env)
        if lv is _SCCP_TOP:
            return _SCCP_TOP
        if op == "and":
            return _eval_sccp_expr(node.get("right"), env) if truth(lv) else lv
        if op == "or":
            return lv if truth(lv) else _eval_sccp_expr(node.get("right"), env)
        return _SCCP_TOP
    if t == "BinaryExpression":
        lv = _eval_sccp_expr(node.get("left"), env)
        rv = _eval_sccp_expr(node.get("right"), env)
        if lv is _SCCP_TOP or rv is _SCCP_TOP:
            return _SCCP_TOP
        op = node.get("operator")
        if op in ("<", "<=", ">", ">=") and isinstance(lv, (int, float)) and isinstance(rv, (int, float)) and not isinstance(lv, bool) and not isinstance(rv, bool):
            if op == "<":
                return lv < rv
            if op == "<=":
                return lv <= rv
            if op == ">":
                return lv > rv
            return lv >= rv
        if op == "==":
            return lv == rv and type(lv) is type(rv)
        if op == "~=":
            return not (lv == rv and type(lv) is type(rv))
        if isinstance(lv, (int, float)) and isinstance(rv, (int, float)) and not isinstance(lv, bool) and not isinstance(rv, bool):
            if op == "+":
                return float(lv + rv)
            if op == "-":
                return float(lv - rv)
            if op == "*":
                return float(lv * rv)
            if op == "/" and rv != 0:
                return float(lv / rv)
            if op == "%" and rv != 0:
                return float(lv % rv)
    return _SCCP_TOP


def sccp_prune_graph(g: dict) -> dict:
    """Wegman-Zadeck Sparse Conditional Constant Propagation along executable CFG edges.
    Safely folds MoonVeil 2.1+ numeric opaque predicates and prunes unreachable cycles.
    Tracks only uncaptured local variables of the current function so external calls
    can never observe or mutate tracked registers.
    """
    nodes = g["nodes"]
    start = g["start"]
    if start not in nodes:
        return g

    own_locals: set[str] = set()
    for s in g["prefix"]:
        if s.get("type") == "LocalStatement":
            for v in s.get("variables", []):
                if v.get("type") == "Identifier":
                    own_locals.add(v["name"])
    for nd in nodes.values():
        for s in nd["stmts"]:
            if s.get("type") == "LocalStatement":
                for v in s.get("variables", []):
                    if v.get("type") == "Identifier":
                        own_locals.add(v["name"])

    closure_vars: set[str] = set()

    def scan_closures(obj, in_closure: bool = False):
        if isinstance(obj, dict):
            if obj.get("type") == "FunctionDeclaration":
                for sub in obj.get("body", []):
                    scan_closures(sub, True)
                return
            if in_closure and obj.get("type") == "Identifier":
                closure_vars.add(obj["name"])
            for k, v in obj.items():
                if k not in ("range", "loc", "comments"):
                    scan_closures(v, in_closure)
        elif isinstance(obj, list):
            for item in obj:
                scan_closures(item, in_closure)

    scan_closures(g["prefix"], False)
    for nd in nodes.values():
        scan_closures(nd["stmts"], False)

    trackable = own_locals - closure_vars
    if not trackable:
        return g

    def step_stmts(stmts: list[dict], env: dict) -> dict:
        cur = dict(env)
        for s in stmts:
            st = s.get("type")
            if st in ("AssignmentStatement", "LocalStatement"):
                targets = s.get("variables", [])
                inits = s.get("init", [])
                vals = [_eval_sccp_expr(x, cur) for x in inits]
                tail_multi = bool(inits) and inits[-1].get("type") in ("CallExpression", "VarargLiteral")
                for idx, tgt in enumerate(targets):
                    if tgt.get("type") == "Identifier" and tgt["name"] in trackable:
                        if idx < len(vals):
                            val = vals[idx]
                        elif tail_multi:
                            val = _SCCP_TOP
                        else:
                            val = None
                        cur[tgt["name"]] = val
            else:
                stack = [s]
                while stack:
                    x = stack.pop()
                    if isinstance(x, dict):
                        if x.get("type") in ("AssignmentStatement", "LocalStatement", "ForNumericStatement", "ForGenericStatement"):
                            vars_list = x.get("variables") or ([x["variable"]] if "variable" in x else [])
                            for tg in vars_list:
                                if isinstance(tg, dict) and tg.get("type") == "Identifier" and tg["name"] in trackable:
                                    cur[tg["name"]] = _SCCP_TOP
                        if x.get("type") != "FunctionDeclaration":
                            for k, v in x.items():
                                if k not in ("range", "loc", "comments") and isinstance(v, (dict, list)):
                                    stack.append(v)
                    elif isinstance(x, list):
                        stack.extend(x)
        return cur

    init_env = step_stmts(g["prefix"], {})
    in_env: dict[Any, dict] = {start: init_env}
    out_env: dict[Any, dict] = {}
    work = deque([start])

    def merge_into(dst, src_env: dict):
        if dst not in nodes:
            return
        if dst not in in_env:
            in_env[dst] = dict(src_env)
            work.append(dst)
            return
        cur = in_env[dst]
        changed = False
        for k in set(cur) | set(src_env):
            v1 = cur.get(k, _SCCP_TOP)
            v2 = src_env.get(k, _SCCP_TOP)
            nv = v1 if (v1 == v2 and type(v1) is type(v2)) else _SCCP_TOP
            if k not in cur or not (cur[k] == nv and type(cur[k]) is type(nv)):
                cur[k] = nv
                changed = True
        if changed:
            work.append(dst)

    while work:
        n = work.popleft()
        after = step_stmts(nodes[n]["stmts"], in_env[n])
        out_env[n] = after
        term = nodes[n]["term"]
        if "goto" in term:
            merge_into(term["goto"], after)
        elif "cond" in term:
            cv = _eval_sccp_expr(term["cond"], after)
            if cv is _SCCP_TOP:
                merge_into(term["yes"]["goto"], after)
                merge_into(term["no"]["goto"], after)
            else:
                chosen = term["yes"]["goto"] if truth(cv) else term["no"]["goto"]
                merge_into(chosen, after)

    new_nodes = {}
    reachable = set()
    q = deque([start])
    while q:
        n = q.popleft()
        if n in reachable or n not in nodes:
            continue
        reachable.add(n)
        nd = copy.deepcopy(nodes[n])
        term = nd["term"]
        if "cond" in term and n in out_env:
            cv = _eval_sccp_expr(term["cond"], out_env[n])
            if cv is not _SCCP_TOP:
                chosen = term["yes"]["goto"] if truth(cv) else term["no"]["goto"]
                cnode = term["cond"]
                if cnode.get("type") == "Identifier" and cnode["name"].startswith("__mv_branch_"):
                    bnm = cnode["name"]
                    nd["stmts"] = [
                        st
                        for st in nd["stmts"]
                        if not (
                            st.get("type") == "LocalStatement"
                            and len(st.get("variables", [])) == 1
                            and st["variables"][0].get("name") == bnm
                            and len(st.get("init", [])) == 1
                            and _is_pure_sccp_expr(st["init"][0])
                        )
                    ]
                nd["term"] = {"goto": chosen}
        new_nodes[n] = nd
        nt = nd["term"]
        if "goto" in nt:
            q.append(nt["goto"])
        elif "cond" in nt:
            q.append(nt["yes"]["goto"])
            q.append(nt["no"]["goto"])

    g_out = dict(g)
    g_out["nodes"] = new_nodes
    return g_out


def expr(x):
    text = _expr(x)
    if x.get("inParens") and x["type"] in (
        "CallExpression",
        "TableCallExpression",
        "StringCallExpression",
        "VarargLiteral",
        "FunctionDeclaration",
        "TableConstructorExpression",
    ):
        return "(" + text + ")"
    return text
