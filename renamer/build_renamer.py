#!/usr/bin/env python3
"""Reproducible builder for `renamer/bin/betterdecompiler` from `renamer/vendor/betterdecompiler`.

Uses system `go` if installed, or automatically bootstraps `go-bin` into `/tmp/go-sdk` via pip.
Runs the full upstream + Luau VM verification test suite before emitting the static binary.
"""
import os
import shutil
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
SRC_DIR = HERE / "vendor" / "betterdecompiler"
OUT_BIN = HERE / "bin" / ("betterdecompiler.exe" if os.name == "nt" else "betterdecompiler")
LUAU_BIN = ROOT / "bin" / ("luau.exe" if os.name == "nt" else "luau")


def find_or_bootstrap_go() -> str:
    go = shutil.which("go")
    if go:
        return go
    sdk_dir = Path("/tmp/go-sdk")
    candidates = list(sdk_dir.glob("**/bin/go"))
    if candidates:
        return str(candidates[0])
    print("[*] Go not found on PATH; bootstrapping portable go-bin into /tmp/go-sdk ...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "--quiet", "--target", str(sdk_dir), "go-bin"])
    candidates = list(sdk_dir.glob("**/bin/go"))
    if not candidates:
        raise RuntimeError("go-bin installed but `go` binary was not found under /tmp/go-sdk")
    return str(candidates[0])


def main() -> None:
    go = find_or_bootstrap_go()
    OUT_BIN.parent.mkdir(parents=True, exist_ok=True)
    env = os.environ.copy()
    env["CGO_ENABLED"] = "0"
    if LUAU_BIN.exists():
        env["LUAU_BIN"] = str(LUAU_BIN)

    print(f"[*] Running BetterDecompiler verification suite (go={go}) ...")
    subprocess.check_call([go, "test", "./..."], cwd=str(SRC_DIR), env=env)

    print(f"[*] Building static binary -> {OUT_BIN} ...")
    subprocess.check_call(
        [
            go,
            "build",
            "-ldflags=-s -w -X main.version=v2.0.0-deobfluraph",
            "-o",
            str(OUT_BIN),
            "./cmd/betterdecompiler",
        ],
        cwd=str(SRC_DIR),
        env=env,
    )
    print(f"[+] Built {OUT_BIN} ({OUT_BIN.stat().st_size:,} bytes)")


if __name__ == "__main__":
    main()
