"""Luarmor v4 -- signature scan, kind classification and IOC extraction.

Pure text analysis: no sandbox, no network. Used by `analyze.py` (CLI/JSON) and
by the Node driver to decide whether a Luarmor file carries something that can
be devirtualized locally (the sephal init is a Luraph v15 chunk) or only a stub
whose payload is fetched at runtime behind a key.
"""
import re

from . import stub as _stub

# Signatures of a Luarmor whitelist client / bootstrap (any two => Luarmor).
SIGS = [
    ("luarmor_host", re.compile(r"luarmor\.net|Luarmor", re.I)),
    ("runtime_stub_call", re.compile(r"\bluraph_runtime1\s*\(")),
    ("tutorial_fingerprint", re.compile(r"GetTutorialState\(\s*\"nil\s+nil\s+")),
    ("env_marker_write", re.compile(r"getfenv\(\)\s*\[\s*tbl\w+\s*\]\s*=")),
    ("error_log_write", re.compile(r"writefile\(\s*\"luarmor-error-log\.txt\"")),
    ("auth_host", re.compile(r"[a-z]{1,3}\d-roblox-auth\.luarmor\.net")),
    ("bootstrap_gate", re.compile(r"ce_like_loadstring_fn")),
    ("kick_prefix", re.compile(r"Kick\(\s*\"\[Luarmor\]")),
    ("bsdata0_table", re.compile(r"\b_bsdata0\s*=\s*\{")),
    ("superflow_blob", re.compile(r"\bsuperflow_bytecode\s*=\s*\{")),
    ("init_fetch", re.compile(r"cdn\.luarmor\.net/v4_init_")),
    ("loader_api", re.compile(r"api\.luarmor\.net/files/v(\d)/(loaders|scripts)/([0-9a-f]{32})")),
    ("key_link", re.compile(r"ads\.luarmor\.net/get_key\?for=([\w.\-]+)")),
    ("client_tag", re.compile(r"\"(LAC\.[A-Z]_[A-Za-z0-9._\-]{16,})\"")),
]

IOC_PATTERNS = [
    ("api_endpoint", re.compile(r"https?://(?:api|cdn|ads)\.luarmor\.net/[^\s\"')]+")),
    ("loader_id", re.compile(r"/files/v\d/(?:loaders|scripts)/([0-9a-f]{32})")),
    ("roblox_auth_host", re.compile(r"[a-z]{1,3}\d-roblox-auth\.luarmor\.net")),
    ("webhook", re.compile(r"https?://[^\s\"')]+(?:workers\.dev|discord(?:app)?\.com/api/webhooks|webhook\.site)[^\s\"')]*")),
    ("kick_message", re.compile(r"Kick\(\s*\"([^\"]{8,120})\"")),
    ("get_key_link", re.compile(r"ads\.luarmor\.net/get_key\?for=([\w.\-]+)")),
]

# A Luraph v15 chunk: `return setmetatable({` plus a numeric table of VM funcs.
VM_CHUNK = re.compile(r"return setmetatable\(\{")
VM_SHAPE = re.compile(r"\[\d+\]=(?:bit32|buffer|string|table|math)\.\w+")


def detect(text):
    """(hit names, confidence 0..1)."""
    hits = [name for name, rx in SIGS if rx.search(text)]
    n = len(hits)
    if n >= 4:
        return hits, 1.0
    if n >= 2:
        return hits, 0.9
    if n == 1:
        return hits, 0.5
    return hits, 0.0


def has_luraph_chunk(text):
    m = VM_CHUNK.search(text)
    if not m:
        return False
    window = text[m.start():m.start() + 200000]
    return bool(VM_SHAPE.search(window)) or "LPH" in window


def iocs(text):
    out = {}
    for name, rx in IOC_PATTERNS:
        vals = []
        for m in rx.finditer(text):
            v = m.group(1) if m.groups() else m.group(0)
            if v not in vals:
                vals.append(v)
            if len(vals) >= 12:
                break
        if vals:
            out[name] = vals
    return out


def kind_of(text, meta):
    """Human-facing classification of the file."""
    if meta.get("has_blob"):
        return "sephal_init"
    if meta.get("has_bsdata0"):
        return "client_stub" if len(text) < 20000 else "client_with_payload"
    if has_luraph_chunk(text):
        return "luarmor_payload" if meta.get("signatures") else "luraph_payload_unwrapped"
    if meta.get("signatures"):
        return "keysystem_script"
    return "unknown"


KIND_LABEL = {
    "client_stub": "Luarmor v4 client stub (payload is fetched at runtime)",
    "client_with_payload": "Luarmor v4 client carrying an embedded payload",
    "sephal_init": "Luarmor v4 sephal init (Luraph v15 chunk + superflow blob)",
    "luarmor_payload": "Luarmor-served payload (Luraph v15)",
    "luraph_payload_unwrapped": "Luraph v15 chunk without Luarmor markers",
    "keysystem_script": "plain script that uses the Luarmor key system",
    "unknown": "not a Luarmor file",
}


def analyze_bytes(raw, name="<bytes>"):
    """Full static report for one file's bytes."""
    text = raw.decode("latin-1")
    hits, conf = detect(text)
    meta = {
        "file": name,
        "bytes": len(raw),
        "lines": text.count("\n") + 1,
        "luarmor": conf >= 0.5,
        "confidence": conf,
        "signatures": hits,
        "has_bsdata0": "_bsdata0" in text,
        "has_blob": "superflow_bytecode" in text,
        "luraph_payload": has_luraph_chunk(text),
        "module_id": None,
        "cache_key": None,
        "init_url": None,
        "bsdata0": None,
        "iocs": iocs(text),
        "notes": [],
    }
    meta["kind"] = kind_of(text, meta)
    meta["label"] = KIND_LABEL[meta["kind"]]

    if meta["has_bsdata0"]:
        try:
            st = _stub.parse_stub(text)
        except ValueError as ex:
            # `_bsdata0` can be *referenced* by a chunk without the stub table
            # being defined here (the sephal init does exactly that).
            if meta["kind"] in ("client_stub", "client_with_payload"):
                meta["notes"].append(str(ex))
        else:
            meta["module_id"] = st["module_id"]
            meta["cache_key"] = st["cache_key"]
            meta["init_url"] = st["init_url"]
            fields = _stub.classify_bsdata0(st["bsdata0"])
            meta["bsdata0"] = fields
            if st["cache_reads"]:
                meta["notes"].append("caches the init in a local file: " + ", ".join(st["cache_reads"][:3]))
            if not meta["luraph_payload"]:
                meta["notes"].append("the script itself is downloaded after the licence handshake; "
                                     "it is not in this file")
    if meta["has_blob"]:
        init = _stub.parse_init(text)
        meta["superflow"] = init
        if init["has_vm_chunk"]:
            meta["notes"].append("superflow blob (%d bytes of table literal) sits in front of the "
                                 "Luraph v15 chunk; the chunk is what gets devirtualized" % init["blob_bytes"])
    if meta["kind"] == "client_stub" and meta["init_url"]:
        meta["notes"].append("init source: %s (fetched at runtime, not bundled)" % meta["init_url"])
    return meta


def analyze(path):
    with open(path, "rb") as fh:
        return analyze_bytes(fh.read(), str(path))
