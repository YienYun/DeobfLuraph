# Luraph v15 Deobfuscation & Devirtualization Internals

This document covers the technical architecture and reverse-engineering pipeline used by this engine to deobfuscate scripts protected with **Luraph v15**.

---

## 1. How Luraph v15 Works

Luraph v15 transforms original Luau scripts into an interpreted virtual machine:

1. **Virtual Instruction Set**: Original Luau bytecode is compiled into a custom register/stack machine with dynamic opcodes and encrypted dispatch tables.
2. **Flattened Control Flow**: Jump targets are flattened into a large state loop (`while true do local op = ARR[PC]; if-tree ... end`), masking the original high-level control structures (`while`, `repeat`, `for`, `if/else`).
3. **Lazy Constant Encryption**: String constants, numeric values, and jump destinations are encrypted in memory buffers (`LPH_ENCSTR`, `LPH_ENCFUNC`). They are only decrypted in-place when execution branches hit them.
4. **Anti-Tamper & Environment Traps**: The VM includes active probes against hook functions, stack depth alteration, and metatable inspection. If tampering is detected, it enters `LPH_CRASH()` (corrupting its own bytecode and spinning in an infinite loop).

---

## 2. Devirtualization Pipeline

To reconstruct valid, clean Luau source code, the engine executes a multi-pass pipeline:

```
[Target Script]
       │
       ▼
1. AST Analysis & Entry Hooking (vmmap)
       │
       ▼
2. Dynamic Sandbox Simulation (harness + envlog)
       │
       ▼
3. Anti-Tamper Isolation & Trap Attribution
       │
       ▼
4. Multi-Round Symbolic Execution & Live REPL Constant Decryption (SCCP)
       │
       ▼
5. Control Flow Graph (CFG) Reconstruction (structure)
       │
       ▼
6. Variable Scoping & Register Web Analysis (variables / codegen)
       │
       ▼
7. AST Polish & Name Restoration (names / localfuncs)
       │
       ▼
[Clean Luau Code]
```

### Stage 1: Static AST Parsing & Hooking (`vmmap.js`)
- The input script is parsed into a Luau AST using `luau-ast`.
- The engine identifies VM dispatch loops and closure maker functions.
- Non-invasive hooks are inserted into each closure maker to capture proto metadata, instruction arrays, and closure environments without changing execution behavior.

### Stage 2: Sandboxed Simulation & Trap Handling (`driver.js`, `harness.js`)
- The hooked script executes inside a sandboxed Luau runtime (`envlog.luau`).
- If an execution path hits an anti-tamper trap (`\0TRIGGER <pid>`), the engine identifies the responsible function, isolates it, and re-executes along stable code paths.

### Stage 3: Symbolic Execution & Live Memory Decryption (`devirt_bridge.py`, `driver.py`, `luasym.py`)
- The Node driver hands the trace to the Python core through `src/devirt_bridge.py` (one `pipeline` invocation per run; a big-stack thread protects the deep recursion).
- Each proto is analyzed using **Sparse Conditional Constant Propagation (SCCP)**.
- When the walker reaches lazy-encrypted constants, it queries the running Luau REPL server in memory (`harness.fetch`) via an IPC pipe.
- The REPL decrypts the values on-the-fly and returns them in milliseconds, resolving thousands of constants in a few fast rounds.
- A slot that the live Luraph decoder itself answers with `nil` (an integrity-check operand that no decoder ever produced) becomes a `Missing` expression. A branch on it cannot be decided, so the walk stops there and the block is flagged with `needs a constant that is not decoded yet`.

### Stage 4: Control Flow Graph (CFG) Reconstruction (`structure.py`, `loops.py`)
- The basic blocks identified during symbolic walking are assembled into a directed CFG.
- Dominator tree analysis identifies loops (`while true`, `for i = a, b, c`, `for k, v in pairs`) and conditionals (`if / elseif / else`).
- Unreachable dead blocks created by opaque predicates are pruned.
- Dead guard branches are pruned (`structure.prune_constant_guards`). A block flagged with `needs a constant that is not decoded yet` is the payload's tamper routine: in a healthy run the guard never fires, so the whole straight-line chain leading to it is dropped and the sibling branch (the real code) takes its place. A guard that is not the alternative of a condition keeps the statements already lifted and simply ends there. The count is reported as `dead guard branches dropped`, and `DEVIRT_NO_GUARD_PRUNE=1` disables the pass.

### Stage 5: Register Web Analysis & Local Naming (`variables.py`, `codegen.py`)
- Virtual registers are mapped across basic block boundaries using Static Single Assignment (SSA) web analysis.
- Variables are assigned clean local names inferred from Roblox API and global usage context (e.g., `Players`, `ReplicatedStorage`, `TweenService`).

### Stage 6: Polish & Formatting (`backend.py`, `tidy.js`)
- Function assignments are converted into idiomatic Luau (`local function name(...) ... end`).
- Code is formatted with proper indentation and verified through `compile_check` to ensure 100% executable syntax.

---

## 3. Fast-Path Optimization

In standard devirtualization, the final verification pass often repeats the entire analysis over all functions. This engine implements a **Fast-Path Controller**:
- Once all constants are resolved live with 0 unlifted blocks, the engine skips redundant collection passes and immediately triggers code generation.
- This cuts 40–60 seconds off the total execution time for massive scripts (500+ functions).

---

## 4. Environment Variables

Debug and tuning hooks used by the Python core and the Node driver. None are required; all default to off.

| Variable | Set by | Effect |
|---|---|---|
| `PYTHON_BIN` | Node | Python executable the driver/bridge spawns (else `python3`, then `python`) |
| `JNKIE_KEY` | Node | Delivery-API key for jnkie loader chains without a `getgenv().SCRIPT_KEY` variable |
| `DEVIRT_WALK_LIMIT` | Python | SCCP walk budget per function (default `250000`; raised automatically for giant single-proto VMs) |
| `DEVIRT_LOADERS` | Python | Also lift loader/VM-constructor protos, not just the payload VM |
| `DEVIRT_FULL_ROUNDS` | Python | Disable quick constant-collection rounds; always run full lifts |
| `DEVIRT_REQS` | Python | Print every pending constant request per round |
| `DEVIRT_TIMING` | Python | Print per-stage timing and fetched-constant statistics |
| `DEVIRT_ERRS` | Python | Print per-block walk errors with proto ids |
| `DEVIRT_TB` | Python | Print full tracebacks for lifted-function errors (and attach one to the uncaught handler) |
| `DEVIRT_DEBUG` | Python | Dump decision logs, block structure and non-payload lifts to stderr |
| `DEVIRT_BLOCKS` | Python | Dump the CFG of the current function once (first hit only) |
| `DEVIRT_NO_MERGE` | Python | Skip `merge_equivalent` CFG simplification |
| `DEVIRT_NO_GUARD_PRUNE` | Python | Keep unliftable integrity-guard branches instead of pruning them |
| `DEVIRT_MISS` | Python | Print every constant the lifter had to leave undecoded, with its path |
| `DEVIRT_NO_NAMES` | Python | Skip the local-name inference pass (`names.py`) |
| `DEOB_PROFILE` | Python | Write a cProfile dump of the `pipeline` branch to this path |
| `DEOB_PRETIDY` | Python | Write the pre-tidy trace text to this path |
| `DEOB_SPIN_LATE` | Python | Do not patch the spin watchdog into the script before the first run |
| `DEOB_NO_SERVE` | Python | Disable the long-lived serve harness (always re-run from scratch) |
| `DEOB_NO_FETCH` | Python | Disable live constant fetching inside the serve harness |
| `DEOB_SERVE_DIFF` | Python | Dump the served vs. run trace texts for comparison |

## 5. Cross-Language Protocol Constants

The harness protocol is shared by three languages: the Python core builds the
harness file, the Node driver parses its output, and the Luau runtime
(`runtime/envlog.luau`) prints it. All protocol constants live in
**`protocol.json`** at the repo root:

- chunk-key hash parameters (`h*31+b` over latin-1 bytes, 4096-byte stride and minimum length) used by `harness.chunk_key`, `harness.js chunkKey` and envlog's `srcKey`;
- the per-run nonce length (`8` bytes, printed as 16 hex chars) that tags every `\0` protocol line;
- heartbeat (2 s) and stall (20 s) watchdog timings;
- the marker name list (`PROTOS`, `TRIGGER`, `CHUNK`, `ENVLOG-BEGIN`, ...).

`runtime/envlog.luau` carries the same values baked into its `local PROTO = {...}`
line (standalone Studio runs depend on them). Both harness builders overwrite
that line from `protocol.json` on every run, and `test/protocol_test.py` fails
CI when any copy drifts. If you change a protocol value, change it in
`protocol.json` only.

## 6. Testing & CI

- `npm test` (or `python test/run_all.py`) runs the fast suite: unit tests for the Python core (chunk-key vectors, Luau pow semantics, config parsing, protocol nonce forging regression) plus the cross-language protocol consistency checks (spawns `node`, no Luau binaries needed).
- `python test/run_all.py --golden` additionally re-runs the full pipeline on the benchmark samples and compares byte-for-byte with the committed reference outputs in `sample/output/` (needs `bin/luau` + `bin/luau-ast` from `python build_luau.py`). If a run differs, the reference file is restored and the test fails.
- `.github/workflows/ci.yml` runs the fast suite on Ubuntu and Windows, syntax-checks every Python/JS file, and builds the patched Luau runtime (cached) for the golden regression.

## 7. Known Gap: `nil` Operands and the Shared Register Frame

`SampleV1` shipped with nine suspicious `nil`s, all inside one lifted function
(`callback10`, lines 43525-43565): seven `(nil)(...)` call targets and two
`bit32` operands (`bit32.band(bit32.rshift(nil, 29), 7)` /
`bit32.band(bit32.bxor(nil, value10), 536870911)`). They are **not** missing
constants. The measured causes:

- **Class (a), not fetched** — `DEVIRT_MISS=1` reports `fetched=761 requests=0`
  over the whole run and exactly two misses (`tid=990 slot=243 path=[43,'f']`).
  Extra fetch rounds cannot move this.
- **Constant decoding** ruled out by instrumentation: `("const", None)` node reps
  (`vm_model._PlainPrinter`), `conv(None)` in `codegen`, `as_expr(None)` in
  `lifter`, and the four explicit `Const(None)` sites in `lifter` all report
  zero hits on this sample.
- **Capture naming** ruled out: zero `[up] nilname`, zero unnamed upvalue
  renders (`upv%d` appears 8 times in 43822 lines).
- **The actual producer** is `variables.webs()`: a register read that no
  definition reaches maps to `None`, and `rename()` renders that as the literal
  `nil` (65 sites across 12 functions on this sample; for 57 of them the
  register is never written anywhere in that function).

Those 57 registers are read from the frame the proto shares with its caller:
the value was set outside the lifted body. Once such a value is unknown the
lift cannot honestly fill it in, and the visible damage is not cosmetic —
`if nil ~= "table" then` is always true, so the lifted `callback10` returns
`nil` before doing any work.

The honest fix is therefore *not* a constant-decoder change and *not*
synthesising a value: it is to carry the caller's register state into the
child proto (shared-frame propagation), and to close the 11
`-- devirt: loop body not recovered` holes whose bodies define some of those
registers. Both are model work, and both are listed as the next step after the
P4 investigation rather than guessed at here.

Reproduction (baseline, from a clean tree):

```
$ node deob.js samples/input/Luraph/SampleV1.lua -o /tmp/out.lua
$ cmp /tmp/out.lua samples/output/Luraph/SampleV1.lua   # identical
$ python3 scripts/metrics.py samples/output/Luraph/SampleV1.lua
lines 43822  parses True  devirt_errors 0  devirt_comments 11
unresolved_uses 185  unresolved_hints 158  unresolved_unhinted 0
bit32_lines 35  bit32_chain_lines 17  empty_while_true 0
```
