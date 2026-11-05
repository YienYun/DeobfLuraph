"""Apply the whole text-pass chain to one file, in the order polish() runs it.

Used by the differential test: a generated program goes through the same passes a
lifted script does, and both versions are run under Luau to compare.
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, os.path.join(HERE, "..", "core"))

import ast_polish  # noqa: E402
import copies      # noqa: E402
import deadstore   # noqa: E402
import seeds       # noqa: E402
import tidy        # noqa: E402


def run(text):
    for _ in range(4):
        text, ds = deadstore.strip(text)
        text, sd = seeds.strip(text)
        if not ds.get("removed") and not sd.get("seeds"):
            break
    text, cp = copies.propagate(text)
    sys.stderr.write("[copies] %d copy(ies) inlined, %d temporary(ies) folded, "
                     "%d unused declaration(s) dropped\n"
                     % (cp.get("inlined", 0), cp.get("temps", 0), cp.get("dropped", 0)))
    for _ in range(3):
        text, n = tidy.strip_groups(text)
        if not n:
            break
    text, _ = tidy.drop_extra_args(text)
    text, _ = deadstore.strip(text)
    # the AST cleanup runs last in the real chain, after every rewrite above
    return ast_polish.polish_ast(text)


def main():
    src = sys.stdin.read()
    sys.stdout.write(run(src))


if __name__ == "__main__":
    main()
