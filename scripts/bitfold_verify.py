#!/usr/bin/env python3
"""Prove that a folded bit32 chain computes what the unrolled chain computed.

The fold (`core/bitfold.py`) turns N written-out repetitions of a bit32 step
into a loop. That is only acceptable if the loop is *bit for bit* the same
function, so this script runs the original statements and the folded helper on
the same pseudo-random inputs inside the real Luau interpreter and compares the
results. Any difference, or the fold refusing to fold, is a failure.

Two modes:

    python3 scripts/bitfold_verify.py                 # self-test on a synthetic chain
    python3 scripts/bitfold_verify.py --before b.lua --after a.lua
                                                      # a real lift, before/after

The second mode also asserts that `after` is exactly what the folder produces
from `before`, so the checked helper is the shipped one. Produce `before` with
the fold disabled:

    DEVIRT_NO_BITFOLD=1 node deob.js <input> -o /tmp/before.lua

Inputs come from a fixed-seed generator inside the Luau script, so two runs
compare the same numbers.
"""
import argparse
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "core"))

import bitfold  # noqa: E402

LUAU = os.path.join(ROOT, "bin", "luau")

# A deterministic 32-bit LCG, written in Luau so the inputs are the runtime's
# numbers and not Python's.
LCG = """
local seed = %d
local function nextValue()
	seed = (seed * 1103515245 + 12345) %% 4294967296
	return seed
end
"""


def synthetic(period=6, count=4):
    """An unrolled chain of the shape the lift produces, as source text."""
    lines = ["local function holder(a)", "\tlocal v0 = a"]
    k = 1
    cur = "v0"
    for _ in range(count):
        names = []
        for i in range(period):
            names.append("v%d" % k)
            k += 1
        lines.append("\tlocal %s = bit32.lshift(%s, 14)" % (names[0], cur))
        lines.append("\tlocal %s = bit32.band(bit32.bxor(%s, %s), 536870911)"
                     % (names[1], cur, names[0]))
        lines.append("\tlocal %s = bit32.lshift(%s, 13)" % (names[2], names[1]))
        lines.append("\tlocal %s = bit32.band(bit32.bxor(%s, %s), 536870911)"
                     % (names[3], names[1], names[2]))
        lines.append("\tlocal %s = bit32.rshift(%s, 13)" % (names[4], names[3]))
        lines.append("\tlocal %s = bit32.bxor(%s, %s)" % (names[5], names[3], names[4]))
        cur = names[5]
    lines.append("\tlocal z = bit32.band(%s, 255)" % cur)
    lines.append("\treturn z")
    lines.append("end")
    return "\n".join(lines) + "\n"


def _run_luau(script):
    with tempfile.NamedTemporaryFile("w", suffix=".luau", delete=False, encoding="utf-8") as f:
        f.write(script)
        path = f.name
    try:
        r = subprocess.run([LUAU, path], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    finally:
        os.remove(path)
    return r.returncode, r.stdout.decode("utf-8", "replace"), r.stderr.decode("utf-8", "replace")


def _helper_from_after(after, helper):
    """The helper function's source, as shipped."""
    lines = after.split("\n")
    for i, line in enumerate(lines):
        m = re.match(r"^(\s*)local function %s\(" % re.escape(helper), line)
        if not m:
            continue
        ind = m.group(1)
        out = []
        for j in range(i, len(lines)):
            out.append(lines[j])
            if j > i and lines[j] == ind + "end":
                return "\n".join(out)
    return None


def _original_from_before(before, p):
    """The unrolled statements, wrapped in a function of the carried value."""
    lines = before.split("\n")
    body = lines[p["start"] - 1:p["end"]]
    return "\n".join(["local function original(%s)" % p["param_name"]] + body +
                     ["\treturn %s" % p["final"], "end"])


def verify_pair(before, after, samples=512, origin=""):
    """Check the folded helper in `after` against the unrolled lines in `before`.

    The shipped helper is not textually what `fold_chains` emits, because the
    naming pass that runs after the fold renames its parameter and temporaries.
    So the equivalence is established on the code that actually ships: the
    helper as it appears in `after`, run against the original statements as they
    appear in `before`.
    """
    plans = bitfold.plan(before)
    if not plans:
        return False, "%s: nothing to fold in the original text" % (origin or "before")
    checked = 0
    for p in plans:
        original = _original_from_before(before, p)
        folded = _helper_from_after(after, p["helper"])
        if not folded:
            return False, "%s: helper %s not found in the result" % (origin or "after", p["helper"])
        if not re.search(r"for\s+_\s*=\s*1\s*,\s*%d\s+do" % p["count"], folded):
            return False, "%s: helper %s does not loop %d times" % (
                origin or "after", p["helper"], p["count"])
        script = "\n".join([
            original, "",
            folded, "",
            LCG % 20240517,
            "local mismatches, firstBad = 0, nil",
            "for i = 1, %d do" % samples,
            "\tlocal x = nextValue()",
            "\tlocal want, got = original(x), %s(x)" % p["helper"],
            "\tif want ~= got then",
            "\t\tmismatches += 1",
            "\t\tif not firstBad then firstBad = string.format('%s: want %s got %s', x, tostring(want), tostring(got)) end",
            "\tend",
            "end",
            "print(mismatches, firstBad or '-')",
        ]) + "\n"
        rc, out, err = _run_luau(script)
        if rc != 0:
            return False, "%s: luau failed to run the comparison: %s" % (
                origin or "fold", (err or out).strip()[:400])
        parts = out.split()
        if not parts:
            return False, "%s: no result from the comparison" % (origin or "fold")
        if parts[0] != "0":
            return False, "%s: %s of %d inputs differ (%s)" % (
                origin or "fold", parts[0], samples, " ".join(parts[1:]))
        checked += 1
    return True, "identical on %d random inputs (%d chain%s folded)" % (
        samples, checked, "" if checked == 1 else "s")


def self_test(samples=512):
    src = synthetic()
    plans = bitfold.plan(src)
    if not plans:
        return False, "self-test: the folder found no chain in its own fixture"
    after = bitfold.fold_chains(src)
    if after == src:
        return False, "self-test: the folder changed nothing"
    ok, why = verify_pair(src, after, samples, origin="self-test")
    if not ok:
        return ok, why
    # and a chain that must NOT fold: two repetitions are a coincidence
    weak = synthetic(count=2)
    if bitfold.fold_chains(weak) != weak:
        return False, "self-test: folded a chain that only repeats twice"
    return True, why + "; two repetitions left alone"


def main(argv):
    ap = argparse.ArgumentParser()
    ap.add_argument("--before")
    ap.add_argument("--after")
    ap.add_argument("--samples", type=int, default=512)
    args = ap.parse_args(argv[1:])
    if bool(args.before) != bool(args.after):
        ap.error("--before and --after go together")
    if args.before:
        before = open(args.before, encoding="utf-8").read()
        after = open(args.after, encoding="utf-8").read()
        ok, why = verify_pair(before, after, args.samples, origin="real lift")
    else:
        ok, why = self_test(args.samples)
    print(("PASS " if ok else "FAIL ") + why)
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
