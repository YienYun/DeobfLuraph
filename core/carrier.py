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
    """Header lines for a carried script that is itself only a delivery stub."""
    try:
        from obfuscators.luarmor import probe
    except Exception:                                    # no Luarmor track loaded
        return []
    hits, confidence = probe.detect(text)
    if confidence < 0.9:
        return []
    notes = ["-- What the loader carries is not the script itself but a Luarmor v4",
             "-- client stub (%d signatures): the real script is fetched from Luarmor" % len(hits),
             "-- after a licence handshake, so it is not in this file."]
    io = probe.iocs(text)
    for key, label in (("api_endpoint", "endpoint"), ("loader_id", "loader")):
        if io.get(key):
            notes.append("--   %-8s : %s" % (label, io[key][0]))
    return notes
