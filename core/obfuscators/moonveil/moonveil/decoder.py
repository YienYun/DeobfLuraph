"""Discover the wrapper's own export permutation and evaluate pure constants."""

from __future__ import annotations
import copy
import math
from dataclasses import dataclass
from .front import Unsupported, normalize, parse, walk, quote
from .staticlua import Evaluator, Env, Table, Closure, RuntimeEnvironment


class BootstrapReady(Exception):
    """Stop before the program's entry function is invoked."""


@dataclass
class Decoded:
    source: bytes
    ast: dict
    exports: dict
    entry: Closure
    constants: list
    context: Table
    evaluator: Evaluator
    original_fields: dict


def scalar_literal(v):
    if isinstance(v, bytes):
        return quote(v)
    if v is None:
        return "nil"
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, (float, int)) and math.isfinite(v):
        return str(int(v)) if v == int(v) else repr(v)
    raise Unsupported("Decoder did not return a finite scalar constant")


def scalar_ast_node(v) -> dict:
    if isinstance(v, bytes):
        u_val = "".join(chr(0xF700 + b) if b >= 0x80 else chr(b) for b in v)
        return {"type": "StringLiteral", "value": u_val, "raw": quote(v)}
    if v is None:
        return {"type": "NilLiteral", "value": None, "raw": "nil"}
    if isinstance(v, bool):
        return {"type": "BooleanLiteral", "value": v, "raw": "true" if v else "false"}
    if isinstance(v, (float, int)) and math.isfinite(v):
        if v < 0 or math.copysign(1.0, v) < 0:
            av = -v
            iv = int(av) if av == int(av) else av
            return {
                "type": "UnaryExpression",
                "operator": "-",
                "argument": {"type": "NumericLiteral", "value": iv, "raw": str(iv) if isinstance(iv, int) else repr(iv)},
                "prefix": True,
            }
        iv = int(v) if v == int(v) else v
        return {"type": "NumericLiteral", "value": iv, "raw": str(iv) if isinstance(iv, int) else repr(iv)}
    raise Unsupported("Decoder did not return a finite scalar constant")


def decode(raw: bytes, seconds=180, max_steps=250000000) -> Decoded:
    source = normalize(raw)
    ast = parse(source)
    if len(ast.get("body", [])) != 1 or ast["body"][0]["type"] != "ReturnStatement":
        raise Unsupported("Profile mismatch: expected one outer return wrapper")
    args = ast["body"][0]["arguments"]
    if len(args) != 1 or args[0]["type"] != "CallExpression":
        raise Unsupported("Profile mismatch: missing bootstrap call")
    call = args[0]
    base = call["base"]
    if (
        base["type"] != "MemberExpression"
        or base["indexer"] != ":"
        or base["base"]["type"] != "TableConstructorExpression"
    ):
        raise Unsupported("Profile mismatch: expected a table method bootstrap")
    is_permuted_boot = (
        len(call["arguments"]) >= 2
        and call["arguments"][0]["type"] == "TableConstructorExpression"
        and call["arguments"][1]["type"] == "StringLiteral"
    )
    is_direct_named_boot = all(
        f["type"] == "TableKeyString" for f in base["base"]["fields"]
    ) and (
        len(call["arguments"]) == 0
        or (len(call["arguments"]) == 1 and call["arguments"][0]["type"] == "VarargLiteral")
    )
    if not (is_permuted_boot or is_direct_named_boot):
        raise Unsupported("Profile mismatch: expected export names and entry name")
    evaluator = Evaluator(seconds=seconds, max_steps=max_steps)
    context = evaluator.evaluate(base["base"])
    # Capture the original initializer expression for helpers implemented as IIFEs.
    originals = {}
    array_index = 1
    for field in base["base"]["fields"]:
        ft = field["type"]
        if ft == "TableValue":
            k = float(array_index)
            array_index += 1
        elif ft == "TableKeyString":
            k = field["key"]["name"].encode("ascii")
        else:
            k = evaluator.evaluate(field["key"])
        value = context.get(k)
        originals[id(value)] = (field["value"], value)

    if is_permuted_boot:
        entry_name = evaluator.evaluate(call["arguments"][1])
        bootstrap = context.get(base["identifier"]["name"].encode("ascii"))

        def stop_entry(fn, args):
            entry = context.get(entry_name)
            if entry is not None and fn is entry and args and args[0] is context:
                raise BootstrapReady()

        evaluator.call_hook = stop_entry
        try:
            evaluator.call(
                bootstrap, (context,) + evaluator.exprlist(call["arguments"], evaluator.env)
            )
        except BootstrapReady:
            pass
        else:
            raise Unsupported("Bootstrap did not reach the expected entry boundary")
        finally:
            evaluator.call_hook = None
    else:
        entry_name = base["identifier"]["name"].encode("ascii")
    entry = context.get(entry_name)
    if not isinstance(entry, Closure):
        raise Unsupported("Invalid entry factory")
    # Only initialize decoder closures. The final return invokes the payload and is
    # deliberately NOT evaluated, even inside the bounded interpreter.
    entry_body = entry.node["body"]
    if not entry_body or entry_body[-1]["type"] != "ReturnStatement":
        raise Unsupported("Unsupported entry prelude")
    local = Env(entry.env)
    parameters = entry.node["parameters"]
    if not parameters or parameters[0]["type"] != "Identifier":
        raise Unsupported("Missing entry context parameter")
    local.values[parameters[0]["name"]] = context
    if any(s["type"] != "AssignmentStatement" for s in entry_body[:-1]):
        raise Unsupported("Only assignment-only decoder initialization is supported")
    for s in entry_body[:-1]:
        evaluator.statement(s, local)
    exports = {}
    for k, v in context.fields.items():
        if isinstance(k, bytes):
            try:
                name = k.decode("ascii")
            except UnicodeDecodeError:
                continue
            if not name.isidentifier():
                continue
            if id(v) in originals and originals[id(v)][1] is v:
                exports[name] = originals[id(v)][0]
    replacements = []
    records = []
    seen = {}

    def visit(node):
        if isinstance(node, list):
            for v in node:
                visit(v)
        elif isinstance(node, dict):
            if node.get("type") == "LogicalExpression" and node.get("operator") == "or":
                left, right = node["left"], node["right"]
                if (
                    left.get("type") == "IndexExpression"
                    and left["base"].get("type") == "MemberExpression"
                    and right.get("type") == "CallExpression"
                ):
                    lb = left["base"]
                    rb = right["base"]
                    if (
                        lb["base"]["type"] == "Identifier"
                        and rb["type"] == "MemberExpression"
                        and rb["indexer"] == ":"
                        and rb["base"]["type"] == "Identifier"
                        and lb["base"]["name"] == rb["base"]["name"]
                    ):
                        receiver = rb["base"]["name"]
                        cache = context.get(lb["identifier"]["name"].encode("ascii"))
                        if isinstance(cache, Table):
                            bound = Env(evaluator.env)
                            bound.values[receiver] = context
                            index = evaluator.evaluate(left["index"], bound)
                            cachekey = (id(cache), index)
                            if cachekey in seen:
                                literal, ast_lit = seen[cachekey]
                            else:
                                value = evaluator.evaluate(right, bound)
                                literal = scalar_literal(value)
                                ast_lit = scalar_ast_node(value)
                                seen[cachekey] = (literal, ast_lit)
                            start, end = node["range"]
                            replacements.append(
                                (start, end, ("(" + literal + ")").encode("ascii"))
                            )
                            records.append(
                                {
                                    "offset": start,
                                    "end": end,
                                    "cache": lb["identifier"]["name"],
                                    "key": scalar_literal(index),
                                    "method": rb["identifier"]["name"],
                                    "literal": literal,
                                }
                            )
                            node.clear()
                            node.update(copy.deepcopy(ast_lit))
                            node["range"] = [start, end]
                            return
            for k, v in node.items():
                if k not in ("range", "loc", "comments"):
                    visit(v)

    visit(ast)
    if not records:
        raise Unsupported("No supported encrypted constant references were found")
    for start, end, text in sorted(replacements, reverse=True):
        source = source[:start] + text + source[end:]
    exports = {
        name: copy.deepcopy(node)
        for name, node in exports.items()
    }
    return Decoded(
        source, ast, exports, entry, records, context, evaluator, originals
    )
