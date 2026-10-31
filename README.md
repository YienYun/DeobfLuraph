# DeobfLuraph — Modular Multi-Obfuscator Lua / Luau Deobfuscator

Standalone, modular reverse-compilation and deobfuscation toolkit for Lua 5.1 and Roblox Luau scripts.

---

## Supported Obfuscators

| Engine | Module Path | Pipeline |
|---|---|---|
| **Luraph v15.0 / v15.1+** | `core/obfuscators/luraph_v15/` | AST Hooking ➔ Luau Sandbox REPL ➔ Symbolic CFG / SSA Lifter ➔ Plain-Luau `LPH_NO_VIRTUALIZE` Recovery |
| **Luraph v14.7 – v14.9** | `core/obfuscators/luraph_v14/` | Layered v14 VM Mapper & Symbolic Lifter atop `luraph_v15` |
| **MoonVeil v2.0.x & v2.1+** | `core/obfuscators/moonveil/` | Base64+Zstd Unpacker (`deob.js`) + Universal `v2.0.x` / `v2.1+` VM Lifter & AST Beautifier |
| **MoonSec V2 / V3** | `core/obfuscators/moonsec/` | JS Bytecode Lifter ➔ `.luac` ➔ `luadec` / Lua 5.1 Decompiler |
| **IronBrew v2 / AztupBrew** | `core/obfuscators/ironbrew2/` | JS + Python AST VM Lifter ➔ `.luac` ➔ `luadec` |
| **IronBrew v1** | `core/obfuscators/ironbrew1/` | Static VM Deserializer & Lifter |
| **Prometheus** | `core/obfuscators/prometheus/` | AST Constant Array & Control-Flow Unflattener |
| **PSU v4.x** | `core/obfuscators/psu/` | VM Bytecode Deserializer & Lifter |
| **Hercules** | `core/obfuscators/hercules/` | Wrapper & String/State Unpacker |
| **LuaObfuscator / Goofyscator / f77 / xHider** | `core/obfuscators/{luaobfuscator,goofyscator,f77,xhider}/` | Dedicated Unpackers & Constant Decoders |

> **Note:** Client-side licensing/DRM loaders (`Luarmor v4` / `_bsdata0`) are detected and explicitly refused rather than bypassed.

---

## Project Architecture

```text
DeobfLuraph/
├── deob.js                          # Main CLI entry point (single file & recursive batch routing)
├── src/                             # Node.js orchestration & post-processing
│   ├── detect.js                    # Signature & structural detector (20+ obfuscator profiles)
│   ├── driver.js                    # Luraph v14/v15 sandbox + Python devirt bridge runner
│   ├── multi_driver.js              # Dispatcher for MoonVeil, MoonSec, IronBrew, Prometheus, PSU, etc.
│   ├── devirt_bridge.py             # JSON/IPC bridge between Node driver and Python lifters
│   ├── luac_decompile.js            # 32-to-64-bit Lua 5.1 bytecode converter + luadec wrapper
│   ├── harness.js                   # Offline Roblox sandbox harness builder
│   ├── watermark.js                 # Syntax-safe post-deobfuscation attribution injector
│   ├── vmmap.js / traceout.js       # Fast trace helpers & AST utilities
│   └── pyenv.js / tidy.js           # Python resolver & code formatter
├── core/                            # Shared compiler backend (Python)
│   ├── luasym.py / ir.py            # Symbolic expressions, Lua tables, and intermediate representation
│   ├── structure.py / loops.py      # Dominator-tree CFG structuring (if/elseif/else, while, for, repeat)
│   ├── idioms.py / ast_polish.py    # Idiom folding (table.move, SETLIST, logical chains) & AST cleanup
│   ├── variables.py / names.py      # SSA web coalescing & context-aware Roblox identifier naming
│   ├── codegen.py / backend.py      # Final Luau code emitter & verification passes
│   ├── luauast.py                   # Native `bin/luau-ast` JSON parser & printer
│   └── obfuscators/                 # Modular per-obfuscator engines
│       ├── luraph_v15/              # Modular Luraph v15.0 / v15.1+ engine:
│       │   ├── dump.py              #   Runtime dump reader, constant/buffer patch log & path resolver
│       │   ├── dataflow.py          #   SCCP abstract interpretation, upvalue/box & tuple propagation
│       │   ├── vm_model.py          #   Dispatcher/constructor model & LPH_NO_VIRTUALIZE plain printer
│       │   ├── stepper.py           #   Handler symbolic stepper, inline JIT loop lifter & decision tree
│       │   ├── lifter.py            #   ProtoLifter bytecode-to-IR symbolic walker
│       │   ├── patches.py           #   Multi-round lazy constant request collector & walk cache
│       │   ├── vmmap.py             #   Luau AST dispatcher & closure-maker mapper
│       │   ├── devirt.py            #   Program/FunctionLifter orchestrator & public facade
│       │   └── driver.py            #   End-to-end instrumentation & multi-round lift driver
│       ├── luraph_v14/              # Luraph v14.7–v14.9 adapter (`vmmap.py`, `devirt.py`, `driver.py`)
│       ├── moonveil/                # MoonVeil 2.0.x (`moonveil/`) & 2.1+ (`moonveil21/`, `beautify.py`)
│       └── ...                      # moonsec, ironbrew1, ironbrew2, prometheus, psu, hercules, etc.
├── renamer/                         # Optional Layer-2 Luau cleaner & scope-verified renamer (`--rename`)
├── runtime/envlog.luau              # Offline Roblox VM & environment emulator
├── bin/                             # Bundled native binaries (`luau`, `luau-ast`, `lua5.1`, `luadec`)
├── samples/                         # Clean workspace folders for local scripts
│   ├── input/
│   │   ├── Luraph/                  # Drop Luraph scripts here
│   │   └── MoonVeil/                # Drop MoonVeil scripts here
│   └── output/                      # Deobfuscated outputs automatically mirror input subfolders here
└── test/                            # Automated test suite (`npm test`)
```

---

## Quick Start

### Prerequisites
- **Node.js** `18+`
- **Python** `3.10+`

### Installation
```bash
npm install
```

### Usage
```bash
# Process a single script inside samples/input/<Subfolder>/
# Automatically writes to samples/output/<Subfolder>/<filename>.lua
node deob.js samples/input/Luraph/script.lua

# Process an entire folder recursively
node deob.js samples/input/

# Save a single file to a custom path
node deob.js input.lua -o output.lua

# Detect obfuscator type without deobfuscating
node deob.js input.lua --detect

# Optional manual Layer-2 variable renaming & cleanup on an already-deobfuscated file
node renamer/index.js samples/output/Luraph/script.lua -o samples/output/Luraph/script_clean.lua
```

---

## Maintenance Guide (Updating Obfuscator Versions)

When Luraph or MoonVeil ships a new build, each concern is isolated to a single module:
- **New Luraph outer VM wrapper or `LPH_NO_VIRTUALIZE` layout** ➔ `core/obfuscators/luraph_v15/vmmap.py` & `vm_model.py`
- **New Luraph handler pattern or inline `LPH_JIT` loop** ➔ `core/obfuscators/luraph_v15/stepper.py`
- **New Luraph instruction / stack dispatch semantics** ➔ `core/obfuscators/luraph_v15/lifter.py`
- **Closure capture / upvalue unboxing edge cases** ➔ `core/obfuscators/luraph_v15/dataflow.py`
- **Lazy constant buffer decryption / dump format** ➔ `core/obfuscators/luraph_v15/dump.py` & `patches.py`
- **CFG loop/branch structuring across all VM lifters** ➔ `core/structure.py` & `core/loops.py`
- **MoonVeil 2.1+ permutation / opcode specs** ➔ `core/obfuscators/moonveil/moonveil21/` & `beautify.py`
- **Detector signatures** ➔ `src/detect.js`

---

## Running Tests

```bash
npm test
```
