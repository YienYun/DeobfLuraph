"""The bridge a script needs when its loader carries it as a plain function.

Some Luraph builds do not virtualise the script: they store it as one field of the
loader's table and call it with that table. The script then reaches for helpers on
its first argument -- `H2`, `g2`, `[72]` here -- which are the hub's own API,
renamed by the same protection pass that renamed the script.

A file printed on its own has nothing to put in their place. Handing the script
`nil` fails as "attempt to index nil with 'H2'" several frames inside code the
reader is trying to follow; a stub that names the helper the first time it is
reached says what is actually missing. Inside the hub the real table is passed and
none of this is built.
"""

STUB = "loaderHelpers"


def _base_is_param(node, loc):
    base = node.get("expr")
    return (isinstance(base, dict) and base.get("type") == "AstExprLocal"
            and (base.get("local") or {}).get("location") == loc)


def helpers(fn):
    """Members the function reads off its first parameter, in source order."""
    args = (fn or {}).get("args") or []
    if not args:
        return []
    loc = args[0].get("location")
    found, seen = [], set()

    def note(name):
        if name and name not in seen:
            seen.add(name)
            found.append(name)

    def walk(node):
        if isinstance(node, dict):
            t = node.get("type")
            if t == "AstExprIndexName" and _base_is_param(node, loc):
                note(node.get("index"))
            elif t == "AstExprIndexExpr" and _base_is_param(node, loc):
                idx = node.get("index") or {}
                if idx.get("type") == "AstExprConstantNumber":
                    val = idx.get("value") or 0
                    note("[%d]" % int(val) if float(val).is_integer() else "[%s]" % val)
                elif idx.get("type") == "AstExprConstantString":
                    note("[%r]" % idx.get("value"))
            for k, v in node.items():
                if k != "location":
                    walk(v)
        elif isinstance(node, list):
            for x in node:
                walk(x)

    walk(fn)
    return found


def stub_source(names):
    """The lines that stand in for the loader's table; [] when it is not read."""
    if not names:
        return []
    listing = ", ".join(names)
    return [
        "-- The loader calls this script with a table of its own helpers (%s)." % listing,
        "-- They are the hub's private API, so a file printed on its own has nothing to",
        "-- put in their place: this stub names the helper the first time one is used.",
        "local function %s()" % STUB,
        "\treturn setmetatable({}, {__index = function(_, key)",
        '\t\terror("[deobf] this script needs `" .. tostring(key) ..',
        '\t\t\t"` from the hub loader\'s helper table (%s)", 2)' % listing,
        "\tend})",
        "end",
    ]


def payload_note(text):
    """Header lines describing what the carried script itself is.

    Two very different files can both mention Luarmor: a client stub that fetches
    the script at run time, and a whole script that merely names a Luarmor-hosted
    loader for one of its own features. Saying the second is the first would be a
    false claim about what the reader is holding, so the analyzer decides.
    """
    try:
        import lm_probe as probe
    except Exception:
        return []
    try:
        meta = probe.analyze_bytes(text.encode("latin-1", "replace"), "<carried script>")
    except Exception:
        return []
    if meta.get("confidence", 0) < 0.9:
        return []
    notes = []
    if meta.get("luraph_payload"):
        notes.append("-- The carried script holds a Luraph chunk of its own; the Luarmor track")
        notes.append("-- lifts that chunk instead of printing it.")
    elif meta.get("kind") in ("client_stub", "hub_pointer"):
        notes += ["-- What the loader carries is a Luarmor v4 client stub (%d signatures):"
                  % len(meta.get("signatures") or []),
                  "-- the script it runs is fetched from Luarmor, so it is not in this file."]
    else:
        notes += ["-- This is the script itself. It names a Luarmor-hosted loader, which is",
                  "-- fetched at run time and is not part of this file:"]
    for key, label in (("api_endpoint", "endpoint"), ("loader_id", "loader")):
        vals = (meta.get("iocs") or {}).get(key)
        if vals:
            notes.append("--   %-8s : %s" % (label, vals[0]))
    return notes
