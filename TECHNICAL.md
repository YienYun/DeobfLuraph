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
`bit32_calls` 49, and the fold checked against the fold-disabled lift:
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
