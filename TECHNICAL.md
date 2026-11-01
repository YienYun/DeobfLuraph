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
- `samples/differential/` holds two real samples (`RideAPet`, `StealAnEgg`) as
  committed input/output pairs plus the `diff-from-v0.4.diff` each milestone's
  behavioural claim was made against, so a differential can be re-checked without
  the machine it was measured on. `samples/input/` stays local-only; this is a
  fixed, small audit corpus. See its `README.md`.

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
child proto (shared-frame propagation), which is model work, and is listed as
the next step rather than guessed at here.

Reproduction (baseline, from a clean tree):

```
$ node deob.js samples/input/Luraph/SampleV1.lua -o /tmp/out.lua
$ cmp /tmp/out.lua samples/output/Luraph/SampleV1.lua   # identical
$ python3 scripts/metrics.py samples/output/Luraph/SampleV1.lua
lines 43822  parses True  devirt_errors 0  devirt_comments 11
unresolved_uses 185  unresolved_hints 158  unresolved_unhinted 0
bit32_lines 35  bit32_chain_lines 17  empty_while_true 0
```

## 8. The Endless-Loop Holes Are Spin Loops, Not Lost Bodies

`SampleV1` used to carry 11 `-- devirt: loop body not recovered (the trace
stopped before it ran)` comments. That text was inherited from an older
assumption and it is wrong, so the holes were re-measured from the IR out:

- Every one of them renders through `codegen.Lower.loop`'s endless-loop branch
  with a body the renderer produced nothing for. Captured at the point of
  emission, the body is one `CommentS("")` plus, before renaming,
  `[Assign, SContinue]`: a block that writes one value and jumps straight back
  to itself.
- That value is a scratch/carry register (`800002` style) that `variables.webs`
  finds no reader for, so `rename` drops the store; with the unconditional
  back-jump stripped as well (`idioms.strip_trailing_continue`) the loop body
  is empty. There is no second statement to recover, and the walk reported
  `0 unlifted blocks` for the whole run, so no block was silently skipped.
- The run status is `finished`: this script does not hang where these loops sit,
  which means the code is not reached on the traced path. Nothing about their
  real body is observable, and writing one would be invention.

Emitting `while true do end` is not an option: it spins forever and the script
after it never runs. So the renderer now drops the loop where it knows why it
is empty and leaves one countable marker that states the measured cause:

```
-- devirt: spin loop left out (its body has no effect: its only statement wrote a value nothing reads)
```

`ast_polish._mark_truncated_loops` stays as the net for text the renderer never
produced (a loop that decoded to no statements at all) and now says exactly
that. Both markers are counted by `scripts/metrics.py` as `devirt_comments`.

Result on `SampleV1`: 11 -> 10 holes, 43,822 -> 43,820 lines, and nothing else
moved. The eleventh was the `else` half of an `if` whose two branches each held
only such a loop: with the loop gone to a comment the branch had no statements
left, so `ast_polish` dropped the empty `else` and its comment with it -- an
`if` with an empty `else` is the same program. (`(nil)(...)` was still 7,
`bit32` `nil` operands still 2, `bit32_chain_lines` still 17, unresolved
captures unchanged -- the dangling-callee bug below was found after this step.)
Remaining holes and their enclosing functions:

| line | enclosing function | why |
|---|---|---|
| 8396, 8398 | `local function reach` | both branches of one `if` |
| 8429 | `callback42, data7, character` closure | |
| 8547 | `callback44, state` closure | |
| 9923 | `callback48, ...` closure | |
| 11760 | `callback39, state` closure | |
| 15336 | `local function callback45` | |
| 17000 | `context2.data.fn` closure | |
| 43239 | `callback4` closure | |
| 43813 | `local function callback13` | |

Each of the ten is the same shape: a self-loop whose only lifted statement
wrote an unread scratch value. None of them had a body that could be put back
without inventing one.

## 9. The Dangling Callee Register: `(nil)(...)` Was Dropped Code, Not A Lost Frame Value

`(nil)(...)` was blamed on the shared register frame for a long time. It is not
that. In the unnamed closure that produced most of them (no `pid`, depth 1,
`upnames = [(1, 'r52')]`) register 2 is the VM call slot: the interpreter writes
the function there and the next dispatch calls it. The lifter flags every write
that exists only to feed a VM dispatch as `jump`, and `structure.fill` drops
every `jump`-flagged statement:

```python
b.stmts += [s for s in node.stmts if not getattr(s, "jump", False)]
```

In that closure all 17 writes to register 2 were flagged `jump` -- including the
two that were genuine reads of the script's own values -- while 7 reads of
register 2 survived. A read with no definition left in its function has no web,
`variables.rename` gets `None` for it, and the printer has nothing to say but
`nil`. That is the whole `(nil)(...)` population.

The fix is `dataflow.materialise_read_jump_regs`, called from
`FunctionLifter.lift` just before `apply_frame_calls`: a register in
`jump_regs | cff_regs` that a surviving statement uses as a **call target**
keeps its writes (`st.jump = False`). Nothing is invented and nothing else is
touched -- only those registers, only their `jump` flag. `lf.materialised_jump_regs`
records the hit set and the run prints one `[jread]` line per proto.

The call-target restriction is not cosmetic. Un-flagging every register a
surviving expression *reads* also resurrects bookkeeping stores the lifter
dropped for a reason: on `SampleV1` that added `local number17 = 1889749313`,
`number17 = 1889749313`, `local number18 = 259159099`,
`local value14 = bit32.bor(1171037852, number18)` and `number18 = 78971088`
back into a block whose reads never needed them. A call whose callee is missing
is the defect being fixed; a store nothing calls is not, so only the callee slot
is taken back.

Result on `SampleV1`:

| | before (v0.4) | after |
|---|---|---|
| `(nil)(...)` | 7 | 1 |
| `bit32` `nil` operands | 2 | 0 |
| `unresolved_uses` / `hints` / `unhinted` | 185 / 158 / 0 | 185 / 158 / 0 |
| `bit32_calls` | 50 | 49 |
| `bit32_chain_lines` | 17 | **14** |
| lines / bytes | 43,820 / 1,492,328 | 43,836 / 1,492,727 |
| `blank_lines` | 4,739 | 4,742 |

One `[jread]` line per run: `proto=<tid> depth=1 kept=17 regs=[2]`.

The only `(nil)(...)` left is `return (nil)(nil, nil)` at the end of
`callback11`, where the callee is a value the trace never produced (case 3
below). The old `if nil ~= "table"` in the same function became
`if type(argument) ~= "table"`: the dropped write was the `type` call, so the
old line was permanently true.

### Why `bit32_chain_lines` had to fall with it

`scripts/metrics.py` counts a chain as a run of at least three consecutive
statements holding a `bit32` call. The three lines that fed the cipher in
`callback10` were

```
local value10 = bit32.band(bit32.rshift(nil, 29), 7)
local value11 = bit32.band(bit32.bxor(nil, value10), 536870911)
local value12 = bit32.bxor(146907180, value11)
```

three consecutive lines, five calls -- and `./bin/luau` reports
`invalid argument #1 to 'rshift' (number expected, got nil)` for the first of
them, so this was never the script's own code. Once register 2 is materialised
the same value is one line of real arithmetic
(`local number15 = 3972087808`, `local value5 = bit32.band(bit32.bxor(526889733, number15), 536870911)`),
the run is shorter than three, and the count goes with it: 3 chain lines and 5
chain calls disappear, which is exactly `17 -> 14` and `25 -> 20`.

`bit32_calls` goes 50 -> 49 and that is the whole arithmetic: those three lines
held five calls, and the replacing code holds four (one `band(bxor(...))` in the
new prefix plus two `x = bit32.bxor(x, ...)` stores that were being erased with
the callee slot). The `bit32.bor(1171037852, ...)` store that the wider variant
also resurrected is deliberately not restored (see the call-target restriction
above), which is the one call of the difference. `bit32_lines` stays 35: three
fabricated lines became four real ones, and the fourth is balanced by one
`bit32.bor` line that is no longer resurrected. `(nil)(...)` and the `nil`
`bit32` operands are gone either way -- the restriction only removes the
bookkeeping stores, not the callee.

So the two gates -- `nil` `bit32` operands 0 and `bit32_chain_lines` 17 -- cannot
both hold: the 17 counted three statements that only existed because the operand
was `nil`. The amended gate for this milestone is `bit32_chain_lines 14` with
`bit32_calls` 49, whose per-operation baseline is now **band 14, bnot 1, bor 0,
bxor 16, lshift 6, rshift 12** (the old 50 counted five calls inside the broken
`nil` prefix, so it is not a baseline). Likewise `(nil)(...)` is gated at
**<= 1 and only at the documented site** (line 43579 of the SampleV1 output); any
new site stops the run. The fold is checked against the fold-disabled lift:
`scripts/bitfold_verify.py --before <nofold> --after <fold>` reports
`PASS identical on 512 random inputs`, with the fold now seeing 8 repetitions of
a 6-statement chain instead of 9 (the 9th was the phase-shifted remainder of the
broken prefix).

### The countable run report line

The printer has no honest text for a value the trace never produced, so those
stay plain `nil` instead of a marker. Countability comes from one line per full
lift:

```
[*]   frame_propagation: bound=N residual_unknown=M
```

`bound` is the number of frame registers bound to a parent value by the
shared-frame propagation; `residual_unknown` counts register reads for which
`variables.rename` found no name at all. The second is measured over every
lifted proto, i.e. before dead code is removed, so it is not the number of
visible `(nil)(...)` uses (55 against 1 here). Both counters live in
`variables.LIFT_STATS`, are reset per lift, and are deterministic.

### Differential check on the other samples

The fix was run against the two other lifts in the regression corpus, comparing
the same input before (`1e0d1eb`) and after, in a separate worktree:

- **RideAPet**: `cmp` byte-identical. The fix is inert on that input.
- **StealAnEgg**: 25 hunks, 102 removed / 110 added lines. Normalised comparison
  (identifiers and numeric literals erased) shows 96 of the removed lines differ
  from an added line only in local names: `local value = nil` became
  `local response3 = nil`, which frees the word `value` and shifts every later
  `valueN` in the same scope down by one. The substantive rest -- 6 removed, 12
  added, plus 2 blank lines -- is one block:

| removed | added |
|---|---|
| `local value5, value6 = (nil)()` | `local value4, value5 = callback5()` |
| `if nil then` | `if not value4 then` + `callback4("No supported WebSocket API found")` |
| `number4 = nil` | `number4 += 1` + `callback3("Connecting to", "wss://...", "using", value5)` |
| `local value7 = table.pack((nil)(callback22))[2]` | `local ok, response = pcall(callback22)` |
| `if nil and value7 then` | `if ok and response then` |
| `callback4("Connection failed:", (nil)(value7))` | `callback4("Connection failed:", tostring(response))` |
| -- | `callback6(response3, "OnMessage", "MessageReceived")`, `callback6(response3, "OnClose", "Closed", "OnDisconnect")`, `local callback = callback6`, `callback(response3, "OnError", "Error")` |

That is the WebSocket connect path: five `nil` holes and two permanently-false
guards become the calls the script actually makes. `(nil)(...)` 3 -> 0, lines
50,393 -> 50,401, `luau-ast` exit 0 on both sides, `devirt_errors` 0,
`devirt_comments` 4 on both, `unresolved_uses/hints/unhinted` 0/0/0 on both, and
the `bit32` metrics identical (74 calls, chain 5). The watermark comment moves
from line 4 to line 3229 (cosmetic, same text).

The call-target restriction changes nothing here: on this input the narrowed and
the wide build are byte-identical, because every restored statement *is* a write
to the callee slot (one `[jread] kept=19 regs=[2]`). The restriction only removes
the bookkeeping stores on `SampleV1`.

## 10. The `residual_unknown` Population: Measured, Not Guessed

The shared-frame plan assumed the remaining `nil` reads were frame upvalue reads
whose register the parent had no name for (cases 1 and 2 of that plan). That was
measured before writing any of it, with an env-gated probe that only reads state
(`DEVIRT_NILSRC2`; reverted -- the output was byte-identical with it on, so the
measurement did not perturb the lift).

Method: every `variables.rename` site that resolves to `Const(None)` is recorded
with its proto (lift sequence number, `pid`, depth), the read's register and its
block; for the same proto, the walked IR is scanned for `Assign` whose target is
that register, splitting the count by the `jump` flag, plus the register's
generation, the proto's `frame_uses` and the number of blocks with an
`unexplored successor` error. (`CallStmt` results live in temps, not registers,
so an `Assign` scan does cover register writes.)

55 sites, 39 distinct `(proto, register)` pairs:

| proto | depth | register | read sites | writes in walked IR | category |
|---|---|---|---|---|---|
| pid 32 | 0 | `101` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 105 | 1 | `4` | 1 | 5 | writes exist, only in a condition header or a return |
| unnamed, lift 105 | 1 | `14` | 1 | 0 | caller-side value -- no write in the function |
| pid 40 | 1 | `21` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 13 | 5 | `40` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 13 | 5 | `102` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 13 | 5 | `106` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 13 | 5 | `111` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 2 | 2 | `18` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 20 | 1 | `9` | 2 | 0 | caller-side value -- no write in the function |
| unnamed, lift 21 | 1 | `27` | 3 | 0 | caller-side value -- no write in the function |
| unnamed, lift 23 | 1 | `15` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 25 | 1 | `11` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 34 | 1 | `25` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 34 | 1 | `38` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 36 | 1 | `10` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 38 | 1 | `6` | 1 | 8 | writes exist, only in a condition header or a return |
| unnamed, lift 38 | 1 | `9` | 1 | 5 | writes exist, only in a condition header or a return |
| unnamed, lift 38 | 1 | `12` | 1 | 3 | writes exist, only in a condition header or a return |
| unnamed, lift 38 | 1 | `14` | 1 | 4 | writes exist, only in a condition header or a return |
| unnamed, lift 38 | 1 | `85` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 38 | 1 | `104` | 2 | 0 | caller-side value -- no write in the function |
| unnamed, lift 39 | 1 | `9` | 1 | 1 | writes exist, only in a condition header or a return |
| unnamed, lift 40 | 1 | `39` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 41 | 1 | `9` | 1 | 2 | writes exist, only in a condition header or a return |
| unnamed, lift 43 | 1 | `25` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 46 | 1 | `17` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 47 | 1 | `11` | 2 | 0 | caller-side value -- no write in the function |
| unnamed, lift 47 | 1 | `32` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 59 | 1 | `7` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 60 | 1 | `24` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 63 | 1 | `8` | 2 | 0 | caller-side value -- no write in the function |
| unnamed, lift 63 | 1 | `9` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 63 | 1 | `20` | 2 | 0 | caller-side value -- no write in the function |
| unnamed, lift 64 | 1 | `19` | 9 | 0 | caller-side value -- no write in the function |
| unnamed, lift 70 | 1 | `7` | 1 | 2 | writes exist, only in a condition header or a return |
| unnamed, lift 79 | 2 | `16` | 1 | 0 | caller-side value -- no write in the function |
| unnamed, lift 86 | 1 | `13` | 2 | 0 | caller-side value -- no write in the function |
| pid 39 | 1 | `8` | 1 | 0 | caller-side value -- no write in the function |

Aggregates:

- 31 of 39 pairs (47 of 55 sites) read a register that the walked IR never
  writes. Nothing can be restored there: the value is produced outside the lifted
  body.
- 8 pairs (8 sites) do have writes -- 1 to 8 each -- but none reaches the read.
  Where `webs` does record a definition for such a read, that definition sits in a
  condition header (`block kind 'cond'`, statement 0) or in a `ret` block: a value
  written inside a header is not addressable later, so there is no statement to
  put back.
- `jump` writes: none. This is not the callee-slot class.
- `unexplored successor` in these protos: none, for all 39. The walk did not stop
  early; the register genuinely has no write in the function it is read in.
- `frame_uses`: empty for all 39, and no proto is reached with a frame-valued
  upvalue. There is no parent frame to widen (`fmap`) and nothing for a
  `cap_fallback` lookup to find, so cases 1 and 2 of the shared-frame plan have
  **zero instances** on the only sample available.
- Depth: 46 sites at depth 1, 2 at depth 2, 4 at depth 5, 1 at depth 0.

Conclusion: every one of the 55 is the hard boundary the plan called case 3 -- a
value the trace never produced. The one visible consequence left in the output is
`return (nil)(nil, nil)` in `callback11`. The shared-frame propagation is therefore
closed as **measured, not implemented**: `frame_propagation: bound=0
residual_unknown=55` is the permanent evidence line for `SampleV1`
(`bound=0 residual_unknown=116` for `StealAnEgg`), and writing cases 1 and 2
would add a mechanism with no instance and no test on this corpus. If a future
sample shows a read that *does* go through a frame upvalue with a missing name,
the two cases become testable and can be built then.

## 11. Category X: one name, two locals in one declaration

### The shape

The named output contained declarations like

```lua
local localPlayer, localPlayer, ok, response = ...
local runService, runService = workspace.RunService, workspace.RunService
local data, number3, data = data3, math.max(...) + data3.CruiseHeight, data3
```

Twenty-two of them in `SampleV1`, twenty-one in `StealAnEgg`, three in
`RideAPet`; the pre-naming text (`DEVIRT_NO_NAMES=1`) has 121 / 120 / 60. The
obfuscated input has **zero**: the duplicate is created by this tool, not copied.

### Where it comes from

Names in the lifted text are not invented by the web renamer for these regions.
`_PlainPrinter` (`core/obfuscators/luraph_v15/vm_model.py`, `expr()` and
`PlainProto.render()`) prints `capnames[reg]` -- the input's own local name for a
VM register, recovered from the VM state -- and `render()` splices that name into
spans of copied source. A register is not a variable: the VM reuses it, and two
registers can carry the same recovered name. Printing one name per register
therefore lets two different locals collide, and a `local` declaration that came
from one source statement can end up declaring the same name twice.

A probe confirmed the boundary: `variables.rename` never sees these statements
(`def_web` holds no real-register definitions and the register prefix is always
`r`), so a web split there cannot fix them; the collision exists in the printed
text.

### The rule

A `local` declaration's initialisers are evaluated before any of the new locals
is in scope, so in `local a, a = f(), g()` the first `a` can never be read. The
pass renames it to `_` -- and only when the AST proves it: zero `AstExprLocal`
references and zero assignment targets resolve to that declaration's
`local.location`. If a reference is found (which would mean the scoping
assumption is wrong for that statement) the declaration is counted as
`duplicate-still-referenced` and left untouched; a skipped statement is reported,
never guessed.

Name choice: `_` is the shape the rest of the output already uses for a value
nothing reads, it cannot collide with a real name, and Luau does not report
shadowing for it. `local _, localPlayer, ok, response = ...` says exactly what
the code does.

### Evidence

| fixture | declarations with a duplicate name | fixed | skipped |
|---|---|---|---|
| `samples/output/Luraph/SampleV1.lua` | 22 | 22 | 0 |
| `samples/differential/StealAnEgg/output.lua` | 21 | 21 | 0 |
| `samples/differential/RideAPet/output.lua` | 3 | 3 | 0 |

Each refreshed output was checked against the previous one: applying only this
pass to the committed output reproduces the new file byte for byte, apart from
the attribution comment, whose line is chosen from the file's own text
(`src/watermark.js`). The diff is therefore renames and nothing else. Gate
metrics are unchanged: `SampleV1` `bit32_calls` 49 with the per-op band
12 / 1 / 0 / 14 / 4 / 10 (all within 14 / 1 / 0 / 16 / 6 / 12),
`bit32_chain_lines` 14, `(nil)(` still one site at line 43579, blank lines 4742,
lines 43836. `RideAPet` 10,219 lines / `bit32_calls` 430 / blank 1,025;
`StealAnEgg` 50,401 lines / `bit32_calls` 74 / blank 5,612.

The pass is `core/namesplit.py::apply_duplicates`, called from
`backend.polish()` after naming and before the final `localfuncs` tidy, so it
sees the names the reader will see. It runs on both the named and the
`DEVIRT_NO_NAMES` paths. `test/namesplit.test.js` pins the cases that could
break the proof: an initialiser reading an outer local of the same name, a
closure reading the surviving local, three duplicates in one statement, a
statement with no duplicates, `_` not being renamed again, idempotence, and that
the result still parses.

## 12. Category W: one name, a closure and a later reuse value

### The shape

```lua
local function callback11()
	...
end
local connection = RunService2.Stepped:Connect(callback11)
callback11, RunService2 = 1, false          -- the same printed name, a new value

while ... do
	data2, RunService = data[callback11], callback11 == #data   -- reads the counter
	...
	callback11 += 1
end
```

A reader sees a function used as an array index and compared to a number. The
closure and the counter are two different locals at the VM level; the printed
text gives them one name. 13 sites in `RideAPet`, 38 in `StealAnEgg`, 43 in
`SampleV1` (94 in the corpus). Each is a function-valued local whose name a
later write reuses for another value -- usually a scalar or a connection handle,
in 8 of the 94 a different closure -- and all of them are split: the skip table
is empty for the whole corpus.

### Where it comes from

The text these sites live in is not built out of register webs. `_PlainPrinter`
(`core/obfuscators/luraph_v15/vm_model.py`, `expr()` and `PlainProto.render()`)
renders the obfuscated source's own statement and splices `capnames[reg]` in for
each register operand -- the input's own local name, recovered for that register.
A register is not a variable: the VM reuses it, so the name that held a closure
later holds an integer, and the printed text has no way to say so. The namer
(`core/names.py`) then renames whatever it can see, which is how the site arrives
under names like `callback11`, but it neither creates nor can repair the
collision.

Measured, not assumed: with the namer switched off (`DEVIRT_NO_NAMES=1`) the same
sites are still there -- 13 in `RideAPet`, 38 in `StealAnEgg`, 43 in `SampleV1` --
under the lifter's own names (`F`, `S`, `r`, `IM`, ...). So this is a print-level
name collision, not a web-splitting opportunity, and the pass has to work on the
printed text where the two lifetimes meet.

### The rule

The split is `core/namesplit.py::apply_reuse`, called from `backend.polish()`
after naming and before the final `localfuncs` tidy, on both the named and the
`DEVIRT_NO_NAMES` paths.

* The closure keeps its name. The first reuse assignment and everything that
  reads the reuse value get one new local, `name_2` (`name_3` if a second binding
  with that name is split as well -- never `name_22`). One name per binding, not
  one per write.
* The new local is declared, not just named: renaming alone would write an
  undeclared name, i.e. a global. The declaration goes into the deepest block
  that contains every renamed write and read -- the longest common prefix of
  their statement paths -- either as a `local ` prefix on the first reuse
  statement (when that statement is a single-target assignment at the base of
  that block) or as its own `local name_2` line at the block's indent. If the
  insertion point is not at the start of a line the site is skipped as
  `inline-statement`.
* A read keeps the closure's name only when it cannot run after a reuse
  assignment, and that is proved per read:
  * same function: the read is not dominated by any reuse assignment and comes
    before the first one;
  * nested function: the read is a capture, so a reuse assignment must dominate
    the *creation* of that closure, else the closure may be built before any
    reuse value is in the variable (`capture-before-split`).
* A write inside a nested function is skipped (`write-in-closure`), a compound
  assignment whose read and write cannot share the name is skipped
  (`compound-assign`), and an unplaceable capture is skipped
  (`capture-unknown`).
* Loops. Two hazards are checked and both would be reports, not guesses:
  * `loop-hazard`: a read that keeps the closure's name shares a loop with a
    reuse assignment that is *outside* the declaration's own loop chain, so the
    closure's value could still be in the variable on a later iteration. The
    `local function f() ... end; f(x); f = v` idiom inside a loop is *not* this
    hazard -- a `local function` re-declares on every iteration, so nothing
    carries across iterations, and that is why those sites split instead of
    skipping.
  * `loop-capture`: the new declaration would sit inside a loop body while a
    nested closure reads it, which would give each iteration its own variable
    instead of the single one the obfuscated code shares.

A site that fails any check is counted by reason and left untouched; the table is
`reuse sites / split-safe / skipped` in the run log.

### Evidence

| fixture | sites | split | skipped | `local name_2` decls | renamed lines | lines |
|---|---|---|---|---|---|---|
| `samples/differential/RideAPet/output.lua` | 13 | 13 | none | 4 + 9 inline | 96 | 10,223 |
| `samples/differential/StealAnEgg/output.lua` | 38 | 38 | none | 16 + 22 inline | 173 | 50,418 |
| `samples/output/Luraph/SampleV1.lua` | 43 | 43 | none | 16 + 27 inline | 186 | 43,853 |

"4 + 9 inline" means four sites got a declaration line of their own and nine got
a `local ` prefix on the reuse statement.

Every site, with the line the binding was declared on, the name it was split
into, and every line in the shipped file that uses the new name:

`RideAPet` (13):

| binding | declared | split into | declared at | renamed reads and writes |
|---|---|---|---|---|
| `callback11` | 990 | `callback11_2` | 1004 | 1005, 1018, 1018, 1028, 1028 |
| `callback15` | 1640 | `callback15_2` | 1678 | 1678, 1697, 1699, 1702 |
| `callback17` | 2009 | `callback17_2` | 2022 | 2022, 2024, 2044, 2045, 2050, 2051, 2054, 2055, 2057, 2072, 2073, 2085, 2087 |
| `callback19` | 2310 | `callback19_2` | 2326 | 2327, 2340, 2341, 2368, 2370 |
| `callback21` | 2394 | `callback21_2` | 2422 | 2422, 2423, 2424, 2425, 2425, 2430, 2434, 2434, 2437 |
| `callback30` | 3813 | `callback30_2` | 3838 | 3839, 3840, 3844, 3845, 3849, 3868, 3869, 3873, 3877, 3878, 3885, 3888, 3923, 3924, 3925, 3926, 3928, 3930, 3931, 3935, 3935, 3937, 3937, 3940, 3941, 3943, 3944, 3946, 3947, 3961, 3962, 3973, 3975 |
| `callback25` | 5370 | `callback25_2` | 6053 | 6053, 6055 |
| `callback30` | 6219 | `callback30_3` | 6385 | 6385, 6386, 6387, 6388, 6391, 6393 |
| `callback32` | 6318 | `callback32_2` | 6334 | 6334, 6335, 6347 |
| `callback31` | 6554 | `callback31_2` | 6573 | 6573, 6574, 6583, 6585, 6615, 6617, 6626, 6628, 6672, 6673 |
| `readJsonFile` | 7341 | `readJsonFile_2` | 7979 | 7980, 7981, 8162, 8163 |
| `options` | 7633 | `options_2` | 8178 | 8178, 8179, 8195, 8207, 8218, 8226 |
| `callback45` | 7657 | `callback45_2` | 7948 | 7948, 7973 |

`StealAnEgg` (38):

| binding | declared | split into | declared at | renamed reads and writes |
|---|---|---|---|---|
| `callback32` | 3423 | `callback32_2` | 3437 | 3437, 3440, 3451, 3457, 3461 |
| `callback24` | 4019 | `callback24_2` | 4066 | 4066, 4068, 4083, 4086, 4106, 4107, 4107, 4107, 4107 |
| `clampValue2` | 4219 | `clampValue2_2` | 4235 | 4235, 4236, 4237, 4257, 4258, 4261, 4262 |
| `callback37` | 8195 | `callback37_2` | 8222 | 8222, 8224 |
| `callback38` | 8246 | `callback38_2` | 9885 | 9885, 9886 |
| `callback39` | 8257 | `callback39_2` | 8562 | 8563, 8564, 9834, 9835, 15283, 15284 |
| `callback60` | 17254 | `callback60_2` | 17262 | 17264, 17266, 17270, 17356, 17357 |
| `callback58` | 19198 | `callback58_2` | 19202 | 19203, 19206, 19207, 19210, 19211, 19214 |
| `callback79` | 20310 | `callback79_2` | 20314 | 20314, 20315, 20316, 20320, 20339, 20340 |
| `callback80` | 20317 | `callback80_2` | 20323 | 20323, 20343 |
| `callback78` | 20433 | `callback78_2` | 20465 | 20465, 20466, 20467, 20468, 20470, 20471, 20493, 20494, 20495, 20496, 20497, 20498, 20499, 20500, 20506, 20507, 20508, 20509, 20510, 20511, 20512, 20513 |
| `callback42` | 21951 | `callback42_2` | 21963 | 21963, 21968 |
| `callback42` | 23235 | `callback42_3` | 23392 | 23392, 23393 |
| `callback43` | 23247 | `callback43_2` | 23251 | 23252, 23266, 23272, 23276 |
| `callback44` | 23261 | `callback44_2` | 23271 | 23272, 23276 |
| `callback42` | 23425 | `callback42_4` | 23441 | 23442, 23446 |
| `callback55` | 27346 | `callback55_2` | 27353 | 27353, 27354, 27354, 27359, 27362, 27364, 27366, 27370 |
| `callback51` | 28803 | `callback51_2` | 28834 | 28835, 28836, 28837, 28891, 28918, 28919 |
| `callback122` | 34762 | `callback122_2` | 34856 | 34856, 34857 |
| `callback46` | 36366 | `callback46_2` | 36802 | 36802, 36803, 36804, 36812 |
| `callback47` | 36391 | `callback47_2` | 36415 | 36415, 36416 |
| `createTextLabel` | 37055 | `createTextLabel_2` | 37095 | 37095, 37096, 37097, 37098, 37099 |
| `callback57` | 37674 | `callback57_2` | 37711 | 37713, 37715, 37715, 37733, 37735, 37735, 37758, 37759 |
| `callback51` | 38934 | `callback51_3` | 38958 | 38958, 38959, 38960 |
| `callback48` | 40292 | `callback48_2` | 40459 | 40460, 40465, 40469 |
| `getUIGradient` | 40615 | `getUIGradient_2` | 42350 | 42350, 42351 |
| `callback47` | 42203 | `callback47_3` | 42348 | 42348, 42349 |
| `readJsonFile` | 44283 | `readJsonFile_2` | 44440 | 44440, 44441 |
| `listLayout6` | 45693 | `listLayout6_2` | 45850 | 45851, 45852, 45957, 45958, 45959, 45959, 45959, 46195, 46196, 46196, 46201, 46202, 46407, 46408, 46408, 46408, 46408, 46408, 46409, 46411, 46413, 46808, 46809, 46809, 46809, 46810 |
| `parent` | 46148 | `parent_2` | 46497 | 46508, 46509, 46509, 46509, 46510, 46511, 46518, 46824, 46830 |
| `callback95` | 46157 | `callback95_2` | 46832 | 46834, 46835 |
| `callback96` | 46178 | `callback96_2` | 46823 | 46824, 46829, 46852, 46853 |
| `callback98` | 46430 | `callback98_2` | 46806 | 46806, 46807 |
| `callback100` | 46773 | `callback100_2` | 46832 | 46834, 46836, 46858, 46861 |
| `callback95` | 47505 | `callback95_3` | 47527 | 47527, 47528, 47528, 47528 |
| `parent2` | 47624 | `parent2_2` | 47690 | 47690, 47691, 47692, 47693, 47694, 47695, 47696, 47699, 47700, 47701 |
| `callback98` | 47635 | `callback98_3` | 47676 | 47678, 47680 |
| `uiCorner` | 47658 | `uiCorner_2` | 47676 | 47678, 47680, 47697, 47698, 47699 |

`SampleV1` (43):

| binding | declared | split into | declared at | renamed reads and writes |
|---|---|---|---|---|
| `S` | 4228 | `S_2` | 4244 | 4244, 4245, 4246, 4263, 4265 |
| `EM` | 7892 | `EM_2` | 7919 | 7919, 7921, 8535, 8536 |
| `FM` | 7943 | `FM_2` | 7953 | 7953, 7959 |
| `TM` | 7954 | `TM_2` | 8432 | 8432, 8433 |
| `IM` | 10833 | `IM_2` | 10839 | 10840, 10877, 10877, 10884, 10884, 10885, 10907, 10910, 10912, 10915 |
| `HM` | 11718 | `HM_2` | 11737 | 11737, 11738, 11739, 11741, 11741, 11741 |
| `gg` | 12524 | `gg_2` | 12528 | 12529, 12532, 12533, 12536, 12537, 12540 |
| `yF` | 12851 | `yF_2` | 12914 | 12915, 12919 |
| `oF` | 13637 | `oF_2` | 13641 | 13641, 13642, 13643, 13647, 13666, 13667 |
| `EM` | 13644 | `EM_3` | 13657 | 13657, 13658, 13659, 13660, 13661, 13662, 13663 |
| `EM` | 13760 | `EM_4` | 13813 | 13813, 13814, 13815 |
| `HM` | 15778 | `HM_3` | 15801 | 15801, 15802 |
| `fM` | 16557 | `fM_2` | 16713 | 16713, 16714 |
| `TM` | 16569 | `TM_3` | 16575 | 16576, 16578, 16581, 16588, 16593, 16597 |
| `I` | 16746 | `I_2` | 16761 | 16761, 16762 |
| `QM` | 18677 | `QM_2` | 18820 | 18820, 18821 |
| `lM` | 20235 | `lM_2` | 20248 | 20249, 20252, 20254, 20256, 20260 |
| `lM` | 21693 | `lM_3` | 21724 | 21725, 21783 |
| `CM` | 27666 | `CM_2` | 27760 | 27760, 27761 |
| `HM` | 29277 | `HM_4` | 29290 | 29291, 29295 |
| `uM` | 29303 | `uM_2` | 29384 | 29384, 29385, 29386, 29387, 29403, 29412, 29417, 29419, 29661 |
| `AM` | 29976 | `AM_2` | 30012 | 30012, 30013, 30014, 30015, 30020 |
| `FM` | 30595 | `FM_3` | 30632 | 30634, 30636, 30654, 30656, 30656, 30679, 30680 |
| `EM` | 31855 | `EM_5` | 31879 | 31879, 31880, 31881 |
| `H` | 33213 | `H_2` | 33390 | 33390, 33391, 33392, 33393, 33394 |
| `e` | 35110 | `e_2` | 35270 | 35270, 35271 |
| `B` | 35450 | `B_2` | 35459 | 35459, 35461, 35461, 35461, 35461, 35463 |
| `A` | 36246 | `A_2` | 36360 | 36360, 36401, 36401 |
| `Y` | 37283 | `Y_2` | 37441 | 37441, 37442 |
| `FM` | 38042 | `FM_4` | 38125 | 38125, 38126, 38126 |
| `IM` | 38877 | `IM_3` | 38904 | 38905, 38907 |
| `Zg` | 39187 | `Zg_2` | 39344 | 39345, 39348, 39580, 39581, 39594, 40309, 40310, 40310, 40310, 40310, 40310, 40311, 40404, 40405 |
| `fg` | 39687 | `fg_2` | 39740 | 39740, 39741, 40331, 40332, 40332, 40332, 40332, 40332, 40332, 40333, 40334, 40335, 40336, 40340, 40386 |
| `eg` | 39696 | `eg_2` | 39982 | 40006, 40007, 40008, 40009, 40328, 40329, 40387, 40390, 40414, 40415 |
| `Lg` | 39717 | `Lg_2` | 39867 | 39867, 39869, 40004, 40005, 40005, 40272, 40274, 40282, 40282, 40283, 40283, 40288, 40289, 40296, 40300, 40301 |
| `m` | 39920 | `m_2` | 40269 | 40292, 40293, 40328, 40330, 40387, 40393 |
| `t` | 40258 | `t_2` | 40305 | 40305, 40306, 40351, 40352 |
| `V` | 40342 | `V_2` | 40395 | 40396, 40398 |
| `a` | 40899 | `a_2` | 40928 | 40929, 40930 |
| `v` | 41220 | `v_2` | 41242 | 41242, 41243, 41243, 41243 |
| `AM` | 41369 | `AM_3` | 41435 | 41435, 41436, 41437, 41438, 41439, 41440, 41441, 41444, 41445, 41446 |
| `mM` | 41380 | `mM_2` | 41421 | 41423, 41425, 41442, 41443, 41444 |
| `jM` | 41403 | `jM_2` | 41421 | 41423, 41425 |

Each refreshed output was compared against the previous committed one, and every
added line is a renamed copy of a removed line, a declaration line, the
attribution comment relocating (its line is chosen from the file's own text), or
one blank line the following `localfuncs` tidy adds next to a new declaration.
`RideAPet` 37 hunks (97 removed / 101 added = 96 renames + 4 declarations + 1
comment), `StealAnEgg` 54 hunks (174 / 191 = 173 + 16 + 1 blank + 1 comment),
`SampleV1` 61 hunks (187 / 204 = 186 + 16 + 1 blank + 1 comment). Nothing else
changed: no statement, no constant, no order.

The same check as category X, one step stronger -- the pass is the whole diff:
applying `apply_duplicates` and `apply_reuse` to a `DEVIRT_NO_NAMESPLIT` build of
the same input reproduces the shipped file, apart from the attribution comment's
line and the blank lines the following `localfuncs` tidy re-derives from the
shifted text: 0 in `RideAPet`, and 2 removed / 3 added (net +1) in `StealAnEgg`
and `SampleV1`, which is exactly the `blank_lines` delta reported below.

Gate metrics are unchanged: `SampleV1`
`bit32_calls` 49 with the per-op band 14 / 1 / 0 / 16 / 6 / 12, `bit32_chain_lines`
14, blank 4,743, lines 43,853 (+17 = 16 declaration lines and the blank one), and
`(nil)(` is still exactly one site, now line 43,596 -- the same 17 lines lower,
which is the whole of the shift. `RideAPet` 10,223 lines (+4, all declarations),
`bit32_calls` 430, `bit32_chain_lines` 15, blank 1,025 unchanged. `StealAnEgg`
50,418 lines (+17), `bit32_calls` 74, `bit32_chain_lines` 5, blank 5,613 (+1).
Every output still parses (`bin/luau-ast`), and the set of globals each file
touches is byte-for-byte the same as before the pass (68 / 93 / 91 names, nothing
added, nothing lost), which is what rules out a new local shadowing a global.

`test/namesplit.test.js` pins the cases that could break the proof: the
declaration is emitted for a single-target and for a multi-target reuse, a read
before the first assignment keeps the closure's name, a read inside a closure
declared before the split is skipped, a read before the assignment in the same
loop is skipped, a closure inside a loop that would capture a per-iteration
variable is skipped, a compound assignment is handled or skipped, the split is
idempotent, the result still parses, and a second binding with the same name gets
the next number rather than `name_22`. 24 tests, 7 of category X and 17 of
category W.
