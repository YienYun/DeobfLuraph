"""Luarmor v4 track.

Static analysis of the Luarmor client chain (stub -> sephal init -> session
payload) plus routing: when the file carries a Luraph v15 chunk (the sephal
init, or a loader Luarmor served) it is devirtualized by the same engine the
Luraph track uses, and the Luarmor metadata is attached to the result.

Command line (JSON for the Node driver, human text otherwise):

    python3 core/obfuscators/luarmor/analyze.py <file> [--json]
"""
from . import probe, stub  # noqa: F401  (public surface)

__all__ = ["probe", "stub", "analyze", "report_text"]


def analyze(path):
    return probe.analyze(path)


def report_text(meta):
    """The human summary printed for a Luarmor input."""
    lines = ["Luarmor v4: %s" % meta["label"]]
    lines.append("  file        : %s (%d bytes, %d lines)"
                 % (meta["file"], meta["bytes"], meta["lines"]))
    if meta.get("module_id"):
        lines.append("  module id   : %s" % meta["module_id"])
    if meta.get("cache_key"):
        lines.append("  cache key   : %s" % meta["cache_key"])
    if meta.get("init_url"):
        lines.append("  init source : %s" % meta["init_url"])
    bs = meta.get("bsdata0") or {}
    if bs.get("client_tag"):
        tag = bs["client_tag"]
        lines.append("  client tag  : %s (%d chars, alphabet %s)"
                     % (tag["value"], tag["length"], tag["alphabet"]))
    for h in bs.get("hash_fields") or []:
        label = "sha256" if h.get("sha256") else "hex(%dB)" % h["bytes"]
        lines.append("  %-11s : %s" % (label + " [#%d]" % h["index"], h["digest"][:64] + ("..." if h["hex_length"] > 64 else "")))
    if bs.get("build_stamp"):
        st = bs["build_stamp"]
        lines.append("  build stamp : %d (%s)" % (st["value"], st["iso"] or "?"))
    if bs.get("byte_blobs"):
        lines.append("  byte blobs  : %s"
                     % ", ".join("%d B [#%d]" % (b["bytes"], b["index"]) for b in bs["byte_blobs"]))
    if bs.get("ints"):
        lines.append("  int fields  : %s"
                     % ", ".join("%d [#%d]" % (i["value"], i["index"]) for i in bs["ints"][:8]))
    if meta.get("superflow"):
        sf = meta["superflow"]
        lines.append("  superflow   : %d B table literal, Luraph chunk at offset %s"
                     % (sf["blob_bytes"], sf["chunk_at"]))
    for name, vals in (meta.get("iocs") or {}).items():
        lines.append("  %-11s : %s" % (name, ", ".join(str(v)[:70] for v in vals[:3])))
    lines.append("  devirtualize: %s" % ("yes (Luraph v15 chunk found)" if meta.get("luraph_payload")
                                         else "no payload in this file"))
    for note in meta.get("notes") or []:
        lines.append("  note        : %s" % note)
    return "\n".join(lines)
