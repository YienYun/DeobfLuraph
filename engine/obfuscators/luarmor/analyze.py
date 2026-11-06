#!/usr/bin/env python3
"""CLI for the Luarmor v4 static analyzer.

    python3 core/obfuscators/luarmor/analyze.py sample.lua          # human text
    python3 core/obfuscators/luarmor/analyze.py sample.lua --json   # machine

Exit codes: 0 = analysed (whatever the verdict), 2 = usage/IO error.
"""
import argparse
import json
import os
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))

from obfuscators.luarmor import analyze, report_text  # noqa: E402


def main(argv=None):
    ap = argparse.ArgumentParser(description="Static analysis of a Luarmor v4 client file.")
    ap.add_argument("file")
    ap.add_argument("--json", action="store_true", help="print the report as JSON")
    args = ap.parse_args(argv)
    try:
        meta = analyze(args.file)
    except OSError as ex:
        print("[!] %s" % ex, file=sys.stderr)
        return 2
    if args.json:
        print(json.dumps(meta, indent=1, sort_keys=False))
    else:
        print(report_text(meta))
    return 0


if __name__ == "__main__":
    sys.exit(main())
