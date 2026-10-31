"""Luarmor v4 -- static parsing of the client chain.

A protected Luarmor script is not one file, it is a chain:

  1. the *client stub* a customer saves (a 5-line file, ``_bsdata0={...}`` plus
     a module id and an init URL; it even says "Do not save this file"),
  2. the *sephal init* it downloads from ``cdn.luarmor.net`` -- itself a Luraph
     v15 chunk with an encrypted ``superflow_bytecode={...}`` table in front,
  3. the licence handshake against ``*.luarmor.net``, which hands back the real
     script the author uploaded.

Only steps 1 and 2 exist on disk. Step 3's payload lives on the server behind a
key, so nothing here pretends to produce it: this module parses what the file
actually carries (tables, ids, endpoints, hashes) and says so plainly.

Format notes: the chain is documented in the `Luarmor-Fetch` research toolkit
(@adi.codz, qweasdzxcahd/Luarmor-Fetch, ``docs/LUARMOR_NOTES.md``). The code
below is an independent implementation -- no network, no key, no sandbox.
"""
import re

# --- Lua literal helpers -----------------------------------------------------


def decode_lua_escapes(s):
    """Decode the escape forms a Lua string literal can carry."""
    out = []
    i = 0
    n = len(s)
    simple = {"a": "\a", "b": "\b", "f": "\f", "n": "\n", "r": "\r",
              "t": "\t", "v": "\v", "\\": "\\", '"': '"', "'": "'"}
    while i < n:
        c = s[i]
        if c != "\\" or i + 1 >= n:
            out.append(c)
            i += 1
            continue
        nxt = s[i + 1]
        if nxt in simple:
            out.append(simple[nxt])
            i += 2
            continue
        if nxt.isdigit():
            j = i + 1
            while j < n and j < i + 4 and s[j].isdigit():
                j += 1
            out.append(chr(int(s[i + 1:j]) & 0xFF))
            i = j
            continue
        if nxt == "x":
            out.append(chr(int(s[i + 2:i + 4], 16) & 0xFF))
            i += 4
            continue
        if nxt == "z":
            i += 2
            while i < n and s[i].isspace():
                i += 1
            continue
        out.append(nxt)
        i += 2
    return "".join(out)


def find_table(text, name):
    """Span of ``name={...}`` including the braces, or None (brace-matched,
    string aware so a ``}`` inside a literal cannot end it early)."""
    m = re.search(re.escape(name) + r"\s*=\s*\{", text)
    if not m:
        return None
    start = m.end() - 1
    depth = 0
    instr = None
    esc = False
    i = start
    while i < len(text):
        c = text[i]
        if instr:
            if esc:
                esc = False
            elif c == "\\":
                esc = True
            elif c == instr:
                instr = None
        elif c in "\"'":
            instr = c
        elif c == "{":
            depth += 1
        elif c == "}":
            depth -= 1
            if depth == 0:
                return text[start:i + 1]
        i += 1
    return None


def split_items(body):
    """Split the inside of a table literal on top-level commas."""
    parts, cur, instr, esc, depth = [], [], None, False, 0
    for c in body:
        if instr:
            cur.append(c)
            if esc:
                esc = False
            elif c == "\\":
                esc = True
            elif c == instr:
                instr = None
        elif c in "\"'":
            instr = c
            cur.append(c)
        elif c in "{([":
            depth += 1
            cur.append(c)
        elif c in "})]":
            depth -= 1
            cur.append(c)
        elif c == "," and depth == 0:
            parts.append("".join(cur))
            cur = []
        else:
            cur.append(c)
    if cur:
        parts.append("".join(cur))
    return [p.strip() for p in parts if p.strip()]


def parse_table_literal(lit):
    """``{1,"a",{2}}`` -> [1, 'a', [2]]. Only the literals Luarmor uses."""
    body = lit.strip()
    if body.startswith("{") and body.endswith("}"):
        body = body[1:-1]
    out = []
    for item in split_items(body):
        if item.startswith("{"):
            out.append(parse_table_literal(item))
        elif item.startswith("\"") or item.startswith("'"):
            out.append(decode_lua_escapes(item[1:-1]))
        else:
            try:
                out.append(int(item, 0))
            except ValueError:
                try:
                    out.append(float(item))
                except ValueError:
                    out.append(item)
    return out


# --- stage 1: the client stub ------------------------------------------------

STUB_MODULE_ID = re.compile(r"\"([0-9a-f]{8,}-sephal)\"")
STUB_MODULE_FALLBACK = re.compile(r"local\s+\w+\s*,\s*\w+\s*,\s*\w+\s*=\s*\"[^\"]*\"\s*,\s*\"([^\"]+)\"")
STUB_INIT_URL = re.compile(r"game:HttpGet\(\s*\"([^\"]+)\"")
STUB_READFILE = re.compile(r"readfile\(([^)]*)\)")


def parse_stub(text):
    """The client stub -> {bsdata0, module_id, init_url, cache_reads}."""
    lit = find_table(text, "_bsdata0")
    if lit is None:
        raise ValueError("no _bsdata0 table (not a Luarmor v4 client stub)")
    init = STUB_INIT_URL.search(text)
    mod = STUB_MODULE_ID.search(text)
    cache = STUB_MODULE_FALLBACK.search(text)
    return {
        "bsdata0": parse_table_literal(lit),
        # `<hash>-sephal` is the real module id; the fallback match is the
        # static_content cache key the stub writes the init under.
        "module_id": mod.group(1) if mod else None,
        "cache_key": cache.group(1) if cache else None,
        "init_url": init.group(1) if init else None,
        "cache_reads": [x.strip() for x in STUB_READFILE.findall(text)],
    }


# --- stage 2: the sephal init ------------------------------------------------

INIT_CHUNK = re.compile(r"return setmetatable\(\{")


def parse_init(text):
    """The sephal init -> {blob, chunk_at, has_vm_chunk}."""
    blob = find_table(text, "superflow_bytecode")
    chunk = INIT_CHUNK.search(text)
    return {
        "has_blob": blob is not None,
        "blob_bytes": len(blob) if blob else 0,
        "chunk_at": chunk.start() if chunk else None,
        "has_vm_chunk": chunk is not None,
    }


# --- field classification ----------------------------------------------------

HEX = re.compile(r"^[0-9a-fA-F]{32,}$")


def classify_bsdata0(items, now=None):
    """Label the entries of `_bsdata0` the way the chain uses them.

    Luarmor's stub is a positional table: sizes, hashes and a build stamp
    between the payload hashes and the client tag. We label only what the
    value itself proves (a 64-hex string is a hash, a plausible epoch is a
    build stamp, ``LAC.<x>_`` is the client tag) and leave the rest as ints,
    rather than inventing names for them.
    """
    import time
    now = int(now if now is not None else time.time())
    out = {"ints": [], "hash_fields": [], "hex_fields": [], "byte_blobs": [],
           "client_tag": None, "build_stamp": None, "other_strings": []}
    for i, v in enumerate(items, 1):
        if isinstance(v, int):
            if 1500000000 <= v <= 2500000000 and abs(v - now) < 5 * 365 * 86400:
                out["build_stamp"] = {"index": i, "value": v, "iso": _iso(v)}
            else:
                out["ints"].append({"index": i, "value": v})
        elif isinstance(v, str):
            if HEX.match(v) and len(v) % 2 == 0:
                # Luarmor stores the payload digests as plain hex, not always a
                # single sha256: report the length so 32/64/192-hex stay distinct.
                entry = {"index": i, "hex_length": len(v), "bytes": len(v) // 2,
                         "digest": v.lower()}
                out["hash_fields"].append(entry)
                if len(v) == 64:
                    entry["sha256"] = entry["digest"]
            elif v.startswith("LAC."):
                out["client_tag"] = {"index": i, "value": v, "length": len(v),
                                     "alphabet": "".join(sorted(set(v)))}
            elif v and ord(v[0]) < 32 or any(ord(c) < 32 for c in v):
                out["byte_blobs"].append({"index": i, "bytes": len(v),
                                          "hex": v.encode("latin-1", "replace")[:48].hex()})
            else:
                out["other_strings"].append({"index": i, "value": v[:120], "length": len(v)})
        else:
            out["other_strings"].append({"index": i, "value": repr(v)[:120]})
    return out


def _iso(ts):
    import datetime
    try:
        return datetime.datetime.utcfromtimestamp(ts).strftime("%Y-%m-%dT%H:%M:%SZ")
    except (ValueError, OSError, OverflowError):
        return None
