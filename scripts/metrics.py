#!/usr/bin/env python3
"""Reproducible numbers for a deobfuscated result.

Every claim about an output file in the reports can be re-derived with this:

    python3 scripts/metrics.py samples/output/Luraph/SampleV1.lua
    python3 scripts/metrics.py a.lua b.lua          # two files, side by side
    python3 scripts/metrics.py a.lua --json         # machine-readable

It only reads the file and runs `bin/luau-ast` (if present) to check that the
text parses; it never runs the script.
"""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
AST = os.path.join(ROOT, "bin", "luau-ast")

UNRESOLVED = re.compile(r"\bunresolvedCapture(\d+)\b")
DEVIRT_ERR = re.compile(r'error\("(devirt:[^"]*)"')
DEVIRT_COMMENT = re.compile(r'--\s*(devirt:[^\n]*)')
BIT32 = re.compile(r"\bbit32\.([a-z0-9]+)")
FUNC_HEAD = re.compile(r"^\s*(?:local\s+)?function\b")
LOCAL_FUNC = re.compile(r"^\s*local\s+function\s+[A-Za-z_]\w*\s*\(")


def parses(path):
    if not os.path.exists(AST):
        return None
    r = subprocess.run([AST, path], stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
    return r.returncode == 0


def bit32_chain(lines):
    """bit32 calls that sit in an unrolled chain rather than in one named helper.

    The lifter emits a cipher (CRC, hash, checksum) as hundreds of consecutive
    one-line arithmetic statements. A fold turns such a chain back into a single
    named function with a few bit32 calls inside it. So "chain" here means: a
    line holding a bit32 call that belongs to a run of at least three
    consecutive statement lines that each hold one. Single calls inside a small
    helper do not count -- those are already hidden behind a name.
    """
    hits = [bool(BIT32.search(l)) for l in lines]
    n = len(lines)
    chain_lines = chain_calls = 0
    i = 0
    while i < n:
        if not hits[i]:
            i += 1
            continue
        j = i
        while j + 1 < n and hits[j + 1]:
            j += 1
        if j - i + 1 >= 3:
            for k in range(i, j + 1):
                chain_lines += 1
                chain_calls += len(BIT32.findall(lines[k]))
        i = j + 1
    return chain_lines, chain_calls


HINT = re.compile(r"--\s*unresolved\b")
DECL = re.compile(r"^\s*local\s+(?:unresolvedCapture\d+(?:\s*,\s*)?)+\s*$")


def unhinted_uses(lines):
    """Uses of an `unresolvedCaptureN` that say nothing about it.

    A use is covered when its own line carries `-- unresolved: ...`, when the
    nearest non-blank line above it does, or when it sits in the declaration
    block those names are introduced by (that block carries one hint for all of
    them). Anything else is a name the reader meets with no explanation.
    """
    total = miss = 0
    decl_hinted = False
    for i, line in enumerate(lines):
        if DECL.match(line):
            # the header above the block holds the one hint for the whole list
            if not decl_hinted:
                j = i - 1
                while j >= 0 and (not lines[j].strip() or lines[j].lstrip().startswith("--")):
                    if HINT.search(lines[j]):
                        decl_hinted = True
                        break
                    j -= 1
            if HINT.search(line):
                decl_hinted = True
            if decl_hinted:
                continue
            n = len(UNRESOLVED.findall(line))
            total += n
            miss += n
            continue
        n = len(UNRESOLVED.findall(line))
        if not n:
            continue
        total += n
        if HINT.search(line):
            continue
        j = i - 1
        while j >= 0 and not lines[j].strip():
            j -= 1
        if j >= 0 and HINT.search(lines[j]):
            continue
        miss += n
    return total, miss


def measure(path):
    text = open(path, encoding="utf-8", errors="surrogateescape").read()
    lines = text.split("\n")
    unresolved = UNRESOLVED.findall(text)
    hints = len(HINT.findall(text))
    _uses, _miss = unhinted_uses(lines)
    errs = DEVIRT_ERR.findall(text)
    comments = DEVIRT_COMMENT.findall(text)
    chain_lines, chain_calls = bit32_chain(lines)
    return {
        "file": path,
        "lines": len(lines) - 1 if text.endswith("\n") else len(lines),
        "bytes": len(text.encode("utf-8", "surrogateescape")),
        "parses": parses(path),
        "devirt_errors": len(errs),
        "devirt_errors_by_message": _tally(errs),
        "devirt_comments": len(comments),
        "devirt_comments_by_message": _tally(comments),
        "unresolved_uses": len(unresolved),
        "unresolved_distinct": len(set(unresolved)),
        "unresolved_hints": hints,
        "unresolved_unhinted": _miss,
        "bit32_calls": len(BIT32.findall(text)),
        "bxor_calls": len(re.findall(r"\bbit32\.bxor\b", text)),
        "bit32_lines": sum(1 for l in lines if BIT32.search(l)),
        "bit32_chain_lines": chain_lines,
        "bit32_chain_calls": chain_calls,
        "empty_while_true": len(re.findall(r"while true do\s*\n\s*end\b", text)),
        "blank_lines": sum(1 for l in lines if not l.strip()),
    }


def _tally(items):
    out = {}
    for it in items:
        key = re.sub(r"\d+", "N", it)
        out[key] = out.get(key, 0) + 1
    return dict(sorted(out.items(), key=lambda kv: -kv[1]))


def main(argv):
    args = [a for a in argv[1:] if not a.startswith("--")]
    as_json = "--json" in argv
    if not args:
        default = os.path.join(ROOT, "samples", "output", "Luraph", "SampleV1.lua")
        if not os.path.exists(default):
            print("usage: metrics.py <file.lua> [more.lua ...] [--json]", file=sys.stderr)
            return 2
        args = [default]
    results = [measure(p) for p in args]
    if as_json:
        print(json.dumps(results, indent=2))
        return 0
    if len(results) == 1:
        r = results[0]
        for k, v in r.items():
            if k in ("file",):
                continue
            if isinstance(v, dict):
                print("%-24s %s" % (k, v if v else 0))
            else:
                print("%-24s %s" % (k, v))
        return 0
    keys = ["lines", "parses", "devirt_errors", "devirt_comments", "unresolved_uses",
            "unresolved_hints", "unresolved_unhinted", "bit32_calls", "bxor_calls", "bit32_lines", "bit32_chain_lines", "bit32_chain_calls",
            "empty_while_true", "blank_lines"]
    print("%-20s %s" % ("metric", "  ".join("r%d" % (i + 1) for i in range(len(results)))))
    for k in keys:
        print("%-20s %s" % (k, "  ".join(str(r[k]) for r in results)))
    for r in results:
        print("%-20s %s" % ("file r%d" % (results.index(r) + 1), r["file"]))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
