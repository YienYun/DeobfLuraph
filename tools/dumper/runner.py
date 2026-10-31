#!/usr/bin/env python3
"""Run the vendored Luraph dumper on a script, without Lune or Windows.

The dumper in ``engine/`` is written for Lune: it imports ``@lune/fs``,
``@lune/luau`` and ``@lune/process``, and the zip it came from shipped a
Windows-only ``lune.exe``.  This runner bundles the five engine files into a
single script, prepends a small pure-Luau shim for those three Lune modules,
and executes it with the repository's own ``bin/luau``.

    python3 tools/dumper/runner.py samples/input/Luraph/SampleV1.lua --out /tmp/dump

It writes ``<out>/protos.json`` and ``<out>/constants.lua`` and exits non-zero
when the dumper captured nothing, so a caller can tell "no protos because the
VM would not run" from "no protos because there are none".
"""

from __future__ import annotations

import argparse
import json
import os
import re
import subprocess
import sys
import tempfile

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ENGINE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "engine")
MODULES = ("filter", "sandbox", "deserializer", "encoder")

REQUIRE_RE = re.compile(r'^local\s+(\w+)\s*=\s*require\("\./(\w+)"\)\s*$', re.M)

SHIM = r'''
local __FILES, __OUT = __FILES or {}, __OUT or {}
local fs = {
    readFile = function(p)
        local c = __FILES[p]
        if c == nil then error("no such file: " .. tostring(p)) end
        return c
    end,
    isFile = function(p) return __FILES[p] ~= nil end,
    isDir = function() return false end,
    writeFile = function(p, s) __OUT[p] = s end,
    writeDir = function() end,
}
local luau_lib = {
    load = function(code, opts)
        local f = assert(loadstring(code, "=dumper"))
        if opts and opts.environment then setfenv(f, opts.environment) end
        return f
    end,
}
local process_lib = {
    args = __ARGS or {},
    exit = function(code) error({ __exit = code or 0 }, 0) end,
}
local __require = require
require = function(name)
    if name == "@lune/fs" then return fs end
    if name == "@lune/luau" then return luau_lib end
    if name == "@lune/process" then return process_lib end
    return __require(name)
end
'''

TAIL = r'''
for path, content in pairs(__OUT) do
    print("@@FILE@@" .. path .. "@@" .. tostring(#content))
    print(content)
    print("@@ENDFILE@@")
end
'''


def lua_string(data: bytes) -> str:
    """Quote arbitrary bytes as a single-line Luau string literal."""
    out = ['"']
    for byte in data:
        char = chr(byte)
        if char in ('"', "\\"):
            out.append("\\" + char)
        elif char == "\n":
            out.append("\\n")
        elif char == "\r":
            out.append("\\r")
        elif char == "\t":
            out.append("\\t")
        elif 32 <= byte < 127:
            out.append(char)
        else:
            out.append("\\%d" % byte)
    out.append('"')
    return "".join(out)


def read_engine(name: str) -> str:
    with open(os.path.join(ENGINE, name + ".luau"), encoding="utf-8") as handle:
        source = handle.read()
    return REQUIRE_RE.sub(lambda m: "local %s = __MODULES.%s" % (m.group(1), m.group(2)), source)


def build_runner(target: str, protos_path: str, constants_path: str, raw: bytes) -> str:
    parts = [SHIM, "local __MODULES = {}"]
    for name in MODULES:
        parts.append("__MODULES.%s = (function()\n%s\nend)()" % (name, read_engine(name)))
    parts.append(read_engine("luraph_core"))
    parts.append(TAIL)
    args = [target, protos_path, constants_path]
    seed = "local __FILES = { [%s] = %s }\nlocal __ARGS = {%s}\n" % (
        lua_string(target.encode("utf-8")),
        lua_string(raw),
        ", ".join(lua_string(a.encode("utf-8")) for a in args),
    )
    return seed + "do\n" + "\n".join(parts) + "\nend\n"


def split_output(stdout: str):
    files = {}
    lines = stdout.splitlines()
    index = 0
    while index < len(lines):
        line = lines[index]
        if line.startswith("@@FILE@@"):
            rest = line[len("@@FILE@@"):]
            path, _, _length = rest.rpartition("@@")
            body = []
            index += 1
            while index < len(lines) and lines[index] != "@@ENDFILE@@":
                body.append(lines[index])
                index += 1
            files[path] = "\n".join(body)
        index += 1
    return files


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("target", help="obfuscated Luraph script")
    parser.add_argument("--out", default="dump-out", help="directory for protos.json and constants.lua")
    parser.add_argument("--bin", default=os.path.join(ROOT, "bin", "luau"), help="Luau interpreter")
    parser.add_argument("--keep-runner", metavar="PATH", help="write the generated Luau runner here")
    parser.add_argument("--quiet", action="store_true", help="only print the summary line")
    args = parser.parse_args()

    if not os.path.exists(args.target):
        print("no such file: %s" % args.target, file=sys.stderr)
        return 2

    os.makedirs(args.out, exist_ok=True)
    protos_path = os.path.join(args.out, "protos.json")
    constants_path = os.path.join(args.out, "constants.lua")

    with open(args.target, "rb") as handle:
        raw = handle.read()

    runner = build_runner(args.target, protos_path, constants_path, raw)
    if args.keep_runner:
        with open(args.keep_runner, "w", encoding="utf-8") as handle:
            handle.write(runner)

    holder = tempfile.NamedTemporaryFile("w", suffix=".luau", delete=False, encoding="utf-8")
    try:
        holder.write(runner)
        holder.close()
        proc = subprocess.run([args.bin, holder.name], capture_output=True, text=True)
    finally:
        os.unlink(holder.name)

    if proc.returncode != 0:
        sys.stderr.write(proc.stdout)
        sys.stderr.write(proc.stderr)
        return 2

    for path, content in split_output(proc.stdout).items():
        with open(path, "w", encoding="utf-8") as handle:
            handle.write(content + ("\n" if content and not content.endswith("\n") else ""))

    if not args.quiet:
        for line in proc.stdout.splitlines():
            if not line.startswith("@@") and line.strip():
                print(line)

    total = 0
    filled = 0
    if os.path.exists(protos_path):
        try:
            with open(protos_path, encoding="utf-8") as handle:
                protos = json.load(handle).get("prototypes", [])
        except (ValueError, AttributeError):
            protos = []
        total = len(protos)
        # The engine always writes one placeholder prototype, even when the VM
        # never ran; only prototypes with instructions mean it worked.
        filled = sum(1 for proto in protos if proto.get("num_instructions"))

    print("[dumper] %s -> %d of %d proto(s) with instructions, output in %s"
          % (args.target, filled, total, args.out))
    if filled <= 0:
        print("[dumper] the VM never ran, so nothing was captured; the phase-1 "
              "error above is the reason", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
