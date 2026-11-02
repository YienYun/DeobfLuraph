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
that line from `protocol.json` on every run (and both builders refuse to run if
the line is gone), so the file in `runtime/` is only a fallback for standalone
Studio runs. If you change a protocol value, change it in `protocol.json` only.

## 6. Tests

`npm test` runs `node --test test/*.test.js` -- 55 cases over detection,
argument parsing, the CFG passes (`structure.py`, `bitfold.py`, `namesplit.py`),
the renamer, Luarmor analysis and one end-to-end lift. 49 pass, 5 are skipped
because the sample they need is not in the working tree (`samples/input/` is
local-only), and 1 is a known failure that is marked rather than deleted:

* `renamer prevents variable shadowing, preserves executor guards, and comments
  idempotently` -- it pins a comment layout the renamer no longer produces.

Test names are the stable identifier; the `ok N` numbers shift whenever a case is
added or removed.

There is no CI workflow in this tree, and no Python test runner: everything is
driven from `npm test`.

`samples/differential/` holds two real samples (`RideAPet`, `StealAnEgg`) as
committed input/output pairs, and the `diff-from-baseline.diff` of each against
its oldest recorded output. Rebuilding either input must give a byte-identical
file -- that is the regression check for anything in this document. See its
`README.md`.

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
| `samples/output/Luraph/SampleV1.lua` | 43 | 43 | none | 16 + 27 inline | 186 | 43,771 |

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
| `clampValue2` | 4221 | `clampValue2_2` | 4237 | 4237, 4238, 4239, 4256, 4258 |
| `RunService2` | 7885 | `RunService2_2` | 7912 | 7912, 7914, 8527, 8528 |
| `callback38` | 7936 | `callback38_2` | 7946 | 7946, 7952 |
| `callback39` | 7947 | `callback39_2` | 8424 | 8424, 8425 |
| `callback60` | 10754 | `callback60_2` | 10760 | 10761, 10798, 10798, 10805, 10805, 10806, 10828, 10831, 10833, 10836 |
| `callback39` | 11639 | `callback39_3` | 11658 | 11658, 11659, 11660, 11662, 11662, 11662 |
| `callback58` | 12445 | `callback58_2` | 12449 | 12450, 12453, 12454, 12457, 12458, 12461 |
| `callback66` | 12772 | `callback66_2` | 12835 | 12836, 12840 |
| `callback79` | 13558 | `callback79_2` | 13562 | 13562, 13563, 13564, 13568, 13587, 13588 |
| `listLayout` | 13565 | `listLayout_2` | 13578 | 13578, 13579, 13580, 13581, 13582, 13583, 13584 |
| `callback78` | 13681 | `callback78_2` | 13734 | 13734, 13735, 13736 |
| `callback42` | 15699 | `callback42_2` | 15722 | 15722, 15723 |
| `callback42` | 16478 | `callback42_3` | 16634 | 16634, 16635 |
| `callback43` | 16490 | `callback43_2` | 16496 | 16497, 16499, 16502, 16509, 16514, 16518 |
| `callback43` | 16667 | `callback43_3` | 16682 | 16682, 16683 |
| `colorizeText` | 18598 | `colorizeText_2` | 18741 | 18741, 18742 |
| `callback57` | 20156 | `callback57_2` | 20169 | 20170, 20173, 20175, 20177, 20181 |
| `callback53` | 21614 | `callback53_2` | 21645 | 21646, 21704 |
| `callback124` | 27587 | `callback124_2` | 27681 | 27681, 27682 |
| `callback48` | 29198 | `callback48_2` | 29211 | 29212, 29216 |
| `callback49` | 29224 | `callback49_2` | 29305 | 29305, 29306, 29307, 29308, 29324, 29333, 29338, 29340, 29582 |
| `createTextLabel` | 29897 | `createTextLabel_2` | 29933 | 29933, 29934, 29935, 29936, 29941 |
| `callback59` | 30516 | `callback59_2` | 30553 | 30555, 30557, 30575, 30577, 30577, 30600, 30601 |
| `callback53` | 31776 | `callback53_3` | 31800 | 31800, 31801, 31802 |
| `callback50` | 33134 | `callback50_2` | 33311 | 33311, 33312, 33313, 33314, 33315 |
| `callback48` | 35031 | `callback48_3` | 35191 | 35191, 35192 |
| `callback48` | 35371 | `callback48_4` | 35380 | 35380, 35382, 35382, 35382, 35382, 35384 |
| `callback58` | 36167 | `callback58_3` | 36281 | 36281, 36322, 36322 |
| `readJsonFile` | 37204 | `readJsonFile_2` | 37362 | 37362, 37363 |
| `callback68` | 37963 | `callback68_2` | 38046 | 38046, 38047, 38047 |
| `callback90` | 38798 | `callback90_2` | 38825 | 38826, 38828 |
| `listLayout` | 39108 | `listLayout_3` | 39265 | 39266, 39269, 39501, 39502, 39515, 40228, 40229, 40229, 40229, 40229, 40229, 40230, 40323, 40324 |
| `parent4` | 39608 | `parent4_2` | 39661 | 39661, 39662, 40250, 40251, 40251, 40251, 40251, 40251, 40251, 40252, 40253, 40254, 40255, 40259, 40305 |
| `callback98` | 39617 | `callback98_2` | 39901 | 39925, 39926, 39927, 39928, 40247, 40248, 40306, 40309, 40333, 40334 |
| `uiPadding` | 39638 | `uiPadding_2` | 39786 | 39786, 39788, 39923, 39924, 39924, 40191, 40193, 40201, 40201, 40202, 40202, 40207, 40208, 40215, 40219, 40220 |
| `rsH` | 39839 | `rsH_2` | 40188 | 40211, 40212, 40247, 40249, 40306, 40312 |
| `callback101` | 40177 | `callback101_2` | 40224 | 40224, 40225, 40270, 40271 |
| `home` | 40261 | `home_2` | 40314 | 40315, 40317 |
| `callback95` | 40818 | `callback95_2` | 40847 | 40848, 40849 |
| `callback98` | 41139 | `callback98_3` | 41161 | 41161, 41162, 41162, 41162 |
| `parent2` | 41288 | `parent2_2` | 41354 | 41354, 41355, 41356, 41357, 41358, 41359, 41360, 41363, 41364, 41365 |
| `uiCorner` | 41299 | `uiCorner_2` | 41340 | 41342, 41344, 41361, 41362, 41363 |
| `callback102` | 41322 | `callback102_2` | 41340 | 41342, 41344 |

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

The `SampleV1` line numbers and blank counts quoted in this section are the state
at the category-W commit; §13 removes 82 lines from the same file by resolving
captures the namer had left as `nil`. Category W itself is unchanged by that fix
(43 sites, 43 split, 16 declaration lines, 27 inline).

`test/namesplit.test.js` pins the cases that could break the proof: the
declaration is emitted for a single-target and for a multi-target reuse, a read
before the first assignment keeps the closure's name, a read inside a closure
declared before the split is skipped, a read before the assignment in the same
loop is skipped, a closure inside a loop that would capture a per-iteration
variable is skipped, a compound assignment is handled or skipped, the split is
idempotent, the result still parses, and a second binding with the same name gets
the next number rather than `name_22`. 24 tests, 7 of category X and 17 of
category W.

## 13. The Capture That Was Never Followed: an upvalue slot read from the wrong field

### What the output looked like

`samples/output/Luraph/SampleV1.lua` opened with a confession and then used it:

```lua
-- unresolved: 21 captured values the walk could not follow across scopes.
-- They are nil here, so a function that needs one stops where the
-- original had a value; each use below says what shape it expected.
local unresolvedCapture1, unresolvedCapture2, ... unresolvedCapture21

local function reach()
	if unresolvedCapture1() then          -- attempt to call a nil value
```

185 uses of 21 names, every one of them `nil`. In an executor the script died at
the first one that ran; that is what "stuck / crash" was. The names were not a
missing feature -- the values were in the dump the whole time, under the wrong
key.

### Where it came from

Luraph's `W:kk(kp, ku, upv_tbl, ...)` closure maker takes its upvalue table as an
argument: `upv_tbl = {[slot] = holder, ...}`. The body's `upval i` reads
`holder[slot]`, so the name to print is `holder[slot]` and the only thing needed
is `slot` -- which comes from `u_desc`, a flat table of triplets written by the
gentleman as `(tag, field2, field3)`.

`_lift_wkk` (`core/obfuscators/luraph_v15/vm_model.py`) read `slot` from a fixed
field, the third one. That is not where the slot lives, and which of the two
trailing fields carries it depends on the VM that produced the dump:

| fixture | `field2` in a table of 17 | `field3` in a table of 17 | holder keys |
|---|---|---|---|
| `SampleV1` | `8, 9, 10, ...` (the slots) | `3, 3, 3, ...` (a small tag) | `8..24` |
| `StealAnEgg` | `5394, 5394, 5394, ...` (a constant tag) | `8, 9, 10, ...` (the slots) | `8..24` |

So on one sample every lookup missed (156 misses, 10 distinct tables) and the
name fell through to `upv%d`, an undeclared identifier -- nil by accident rather
than by evidence. On the other sample the fixed field sometimes *did* land on a
key (`1` and `3` are ordinary slots too), which is worse: it printed a real name
belonging to a different capture, silently. `SampleV1`'s `callback34` read
`context.rigState.Character` and `context.rigState()` where the same hub function
in `StealAnEgg` -- lifted from the already-correct encoding -- read
`context.localPlayer.Character` and `context.callback()`.

### The rule

The upvalue table is its own oracle: its keys *are* the slots. Take `field2` when
it is a key of that table, else `field3` when it is, else leave the honest
`upvN` hole. No guess, no invented name, and the choice is per upvalue, not per
table -- the two encodings can be mixed inside one program.

### Evidence

| | `SampleV1` before | after |
|---|---|---|
| `unresolved_uses` / `distinct` | 185 / 21 | **0 / 0** |
| `-- unresolved:` header lines | 8 | 0 |
| `unresolvedCapture` identifiers | 161 | 0 |
| lines / bytes | 43,853 / 1,493,490 | 43,771 / 1,487,897 |
| `blank_lines` | 4,743 | 4,740 |
| `bit32_calls` | 49 | 49 |
| `bit32_chain_lines` | 14 | 14 |
| `(nil)(` | 1 at 43,596 | 1 at 43,514 |
| globals touched | 91 | 91 (same set) |

Only names and the comments that described them changed; the statement stream did
not. Counted syntactically (comments and strings stripped, identifiers collapsed
to one class): `local` -4 and `,` -17 are exactly the removed header (`4`
declarations, `17` commas between 21 names); `NAME` +143 and `.` +164 are
`unresolvedCapture7` becoming `context.callback19` and the like. No keyword and no
operator count moved.

`StealAnEgg` and `RideAPet` rebuild **byte-identical** to their committed outputs,
so the fix does not disturb the encoding that was already read correctly, and
`SampleV1` is deterministic (two builds, same bytes).

Cross-sample check, `callback34`, the same function in both hub scripts:

```lua
-- StealAnEgg (unchanged, correct before and after)
local character = context.localPlayer.Character
if not context.callback() and humanoid and not (humanoid.Health <= 0) then
	local at = context.rigState.at
	if context.lastMV then
-- SampleV1 before this fix
local character = context.rigState.Character
if not context.rigState() and humanoid and not (humanoid.Health <= 0) then
	local at = context.rigState.at
	if context.localPlayer then
-- SampleV1 after
local character = context.localPlayer.Character
if not context.callback() and humanoid and not (humanoid.Health <= 0) then
	local at = context.rigState.at
	if context.lastMV then
```

Gates unchanged: `bit32_calls` 49 with per-op `band 14, bnot 1, bor 0, bxor 16,
lshift 6, rshift 12` (inside the bound 14 / 1 / 0 / 16 / 6 / 12 and equal to the
previous exact count), `bit32_chain_lines` 14, `empty_while_true` 0, and the one
remaining `(nil)(` site moved only because 82 lines above it went away.

### What this does not fix

Three holes are still in the output, and they are gaps, not bugs:

- **One `return (nil)(nil, nil)`** (line 43,514): a tamper trap whose callee is a
  constant nil no decoder produced. `codegen` already drops such a call when it is
  a statement (`structure.prune_after_trap` cuts its successors); in *return*
  position there is nothing to cut, and the honest replacement -- `return nil` --
  would change control flow at a point where the original always raised. It stays
  visible so it can be counted; naming the callee `Color3.fromRGB` would be a
  guess, not a lift. **This one site is gone as of §14** (the callee turned out to
  be a register the function never defines, not a constant); the paragraph above
  is kept as the state §13 shipped with.
- **Ten spin loops** dropped with a `-- devirt:` comment: the original busy-waits,
  the output does not.
- Anything a script does only through those two holes is still missing.

So: the crash that came from calling an unresolved capture is gone, 21 values are
recovered, and the output is now honest about the one call it cannot name.

## 14. A Call Of A Register The Function Never Defines

§13 left exactly one `(nil)(...)` in `SampleV1` and called it "a tamper trap whose
callee is a constant nil". The mechanism is different, and knowing it removes the
site without naming anything:

```lua
local value7 = table.pack(bit32.lshift(value6, 13))
return (nil)(nil, nil)              -- §13
return nil --[[ constant not decoded ]]   -- §14
```

### Where it came from

Lifting in stages (`core/backend.py` is a pipeline of passes over one CFG) shows
the call is already broken before any pass touches it. Instrumenting `lower()`
right after `build_cfg` and watching register 104 for the whole run prints:

```
[cfg:cfg] n=1 U
   U b264 T50_215_1 = r104(r85, r104)
```

One line at the first stage, and it is a *use*: register 104 is read twice (as the
callee and as the second argument) and written nowhere in the function. The
register is not lost by a later pass -- `prune_constant_guards`, `prune_after_trap`,
`drop_unreachable`, `merge_equivalent`, `loops.recognize` and `simplify_blocks` all
leave the count at one. `variables.rename` then has no web for it, and its
documented fallback for a read with no web is `Const(None)` -- the `nil` the printer
writes. Those reads are what the run report has been counting all along:

```
[*]   frame_propagation: bound=0 residual_unknown=55 ...
```

The lifted instruction is genuine, not a decode slip: in this VM's mode-5
dispatcher, opcode 14 is the tail call

```lua
return a[e[L]](a[h[L]], a[j[L]])
```

and the decrypted operand arrays hold `e[50] = 104`, `h[50] = 85`, `j[50] = 104`
for pc 50 -- i.e. `a[104](a[85], a[104])`. The register array `a` is the VM frame
the lifter models as a `RegFile`, and this proto writes neither 85 nor 104: the
values are not in this function at all. Reading them as `nil` and *calling* that
nil is the one thing Lua never allows, so the printed call could only ever raise.

### The rule

`structure.poison_unknown_callees`, called from `lower()` after the loop pass and
before `simplify_blocks` (so it sees the finished statement set, not one block at a
time):

* a `CallStmt` whose callee is a **direct** `Reg(n)` is dropped when nothing in the
  function assigns `n` and no frame binding names it
  (`upnames[(up, n)]` -- those registers are the *enclosing* function's values and
  are real);
* only calls whose result is actually read are treated: an unused nil call is
  already dropped by the printer, and rewriting blocks the printer handles keeps
  the diff to the sites that matter;
* the dropped call's results become `Missing`, the value the rest of the engine
  prints as `nil --[[ constant not decoded ]]`, so nothing is invented and the
  hole stays visible;
* the run report counts them: `unknown_callee=N`.

This is the same rule `ProtoLifter.call_symbolic` has always applied at lift time
("calling values that do not exist is never valid Lua, so stay poisoned instead of
emitting `(nil)(...)`"); what was missing was the case only the finished CFG can
see, a callee register whose definition does not exist anywhere in the function.

### Evidence

```
[poison] block=126 T50_215_1 = r104(r85, r104)          # DEVIRT_POISON=1
[*]   frame_propagation: bound=0 residual_unknown=52 unknown_callee=1
```

| metric | §13 (`ac9acce`) | §14 |
|---|---|---|
| `(nil)(...)` in `SampleV1` | 1 | **0** |
| `residual_unknown` | 55 | **52** |
| `unknown_callee` | (not reported) | **1** |
| lines / bytes | 43,771 / 1,487,897 | 43,771 / 1,487,918 |
| `devirt_errors` / `unresolved_uses` | 0 / 0 | 0 / 0 |
| `bit32_calls` / chain lines | 49 / 14 | 49 / 14 |
| `blank_lines` | 4,740 | 4,740 |
| `parses` | yes | yes |

The whole `SampleV1` diff against `ac9acce` is 20 lines, all accounted for:

* the site itself (`return (nil)(nil, nil)` -> `return nil --[[ constant not
  decoded ]]`);
* `callback11` -> `parseColor3` and the `callback11..callback14` renumbering that
  follows it. Dropping the call removes three unnamed reads from the web analysis,
  the naming pass sees a function that only builds a `Color3`, and its heuristic
  name wins over `callbackN`;
* the author's watermark comment moves 148 lines later. `src/watermark.js` seeds
  its RNG from the finished source and picks one safe statement boundary out of
  the pool, so any text change re-picks the line; the comment is still there
  exactly once, still followed by one `print("Deobf By Zed")`.

`RideAPet` and `StealAnEgg` rebuild **byte-identical** to
`samples/differential/*/output.lua`, with `unknown_callee=0`: the pass never fires
where every callee register has a definition. The suite is unchanged at 54 pass /
2 fail / 19 skipped (the two failures are the pre-existing `#39` and `#72`), and
two consecutive `SampleV1` runs produce the same `md5`
(`2bc0ee05dc45c9c9241dc12a6d11c1e5`).

### The ground truth for that site

`samples/differential/StealAnEgg/` is a different obfuscation of the *same* UI
library, and the same function lifts correctly there (`output.lua:49984`):

```lua
return Color3.fromRGB(math.floor(clampValue(number6, 0, 255, 0)),
                      math.floor(clampValue(number7, 0, 255, 0)),
                      math.floor(clampValue(number8, 0, 255, 0)))
```

That is what `parseColor3` does in `SampleV1` too. The lift there keeps the first
two `math.floor(clampValue(...))` calls as *statements whose results nothing
reads*, loses the third, and reaches the call with the callee in frame register
104 -- a register no lifted proto writes (`[walk]` over the whole run shows the
single read and no write). So the value existed at run time but never entered the
dump: that trace segment is the VM's own operand/constant decryptor, and the
user-level `Color3.fromRGB` load was never lifted. Printing a name there would be
inventing it, which is why the site stays a visible hole.

The input for this sample is not in the repository (`samples/input/` is ignored),
but it is recoverable from history: `git show 5abcc5d:Upload/SampleV1.lua`
rebuilds the committed output byte for byte (`md5 2bc0ee05...`), so every change
to this path can be re-measured.

### Where the decode goes symbolic

The walk is a search over states, not a replay, so the trace below is visit order.
`_walk` steps each `(mode, pc, jregs, packs, carried locals)` state once; the
carried locals (`State.locs`) are the dispatcher loop's own variables, keyed by
the source location they were declared at. For the proto that ends in the poison
site, one of them goes from a number to a *register* two instructions before the
operand decryptor runs:

```
pc=61 mode=5 locs=[(141202, '1186662707')] | r2 = 719669459
pc=62 mode=5 locs=[(141202, '1186662707')] | r3 = 1186662707
pc=63 mode=5 locs=[(141202, '1186662707')] | T63_205_1 = bit32.band(r3, 719669459)
pc=65 mode=5 locs=[(141202, '<Reg 2>')]    | T65_207_1 = r4(T60_196_1[1...])
pc=66 mode=5 locs=[(141202, '<Reg 2>')]    | r3 = math["floor"]
pc=67 mode=5 locs=[(141202, '<Reg 2>')]    | T67_209_1 = bit32.rshift(r2, 29) ; ...
pc=48 mode=5 locs=[(141202, '<Reg 2>')]    | r21 = (r3308 CompareNe "id")
pc=50 mode=5 locs=[(141202, '<Reg 2>')]    | T50_215_1 = r104(r85, r104)
```

From pc=67 on, the operand decryptor is fed `r2` -- a register -- where it wants
the number it was fed at pc=61..63. Every constant after that point is a symbolic
mix, so the operand it produces is a *symbolic* index, and a symbolic index into
the frame comes out as concrete-looking nonsense: `r3308`, `r104`, `r85`. That is
also why the bit32 chain (`536870911`, shifts by 13/14) appears only here --
`grep -c 536870911` is 3 in `SampleV1` and 0 in both differential fixtures, i.e.
it is not user code and not normal lifted output.

Turning the carry off entirely is not the answer, and this was measured rather
than assumed: `DEVIRT_NOCARRY=1` (carry disabled inside `_stepper._note_access`)
drops the walk from 112 to 127 functions but explodes `residual_unknown` from 52
to 8,820 and `unknown_callee` from 1 to 207, and the output grows from 43,771 to
64,875 lines. The carry is what keeps the dispatcher's state alive; one value in
it is what goes stale.

So the remaining work is precise: find why the local at `0,141202` is re-read as
`Reg(2)` when the same lifter had the constant `1186662707` in it two steps
earlier, and either keep the constant or refuse to decode from a register (which
would leave the call honestly unknown instead of inventing operands). Naming the
callee `Color3.fromRGB` before that is fixed would be a guess that only looks
right on this one sample.

### The frame slot has no writer at all

Dumping every state the walk visits for that proto (`DEVIRT_PROTODUMP=1`, 936
visit lines) settles where the callee could have come from:

* `r104` and `r85` are read and **never written** -- not in the visited states,
  not anywhere in the lifted text of that proto;
* the proto performs **zero** frame or table stores in the whole walk (a normal
  proto in the same dump has 107), so the branch that would fill `a[104]` was
  never walked at all;
* the only stores that happen are plain register assignments from the VM's own
  decryptor arithmetic.

So the lift of this function covers the dispatcher's arithmetic path, not the
code that would have installed `Color3.fromRGB` in the frame. The value is not
"lost by a pass"; it was never on the path the walk took, which is why printing a
name there would be invention.

Which instruction that is, is now pinned: `DEVIRT_POISON=1` prints the dropped
statement with the proto it came from, and the one drop in `SampleV1` is

```
[poison] proto=809 block=126 T50_215_1 = r104(r85, r104)
```

i.e. a single CALL at pc 50 of the closure whose capability table is 809.

**Corrected:** those operands are not garbage. Instrumenting the emit site shows
the walk feeding the handler the values its own model of the VM decryptor
produced, and that model agrees with the arrays:

```
proto=1151  pc=50  mode=5  opcode=14
h[50]: raw 0   -> decoded 85
j[50]: raw 29  -> decoded 104
m[50]: raw 15  -> decoded 14      (the opcode)
```

The proto's own field `o=105` says slots up to 105 are legitimate, so 85 and 104
are real frame slots, not numbers read out of a corrupted cell. What is missing is
not the operand: it is the slot's **value**, which no proto on the walked path
ever stores (`r104`/`r85` have no writer in 936 visited states, and the whole
proto performs zero frame or table stores). A narrow frame-propagation attempt --
snapshot the caller's registers at the closure's creation site and use them only
for the callee slot -- changed nothing at all: `frame_propagation: bound=0` and a
byte-identical output, so no ancestor knows that slot either.

The construct itself is fine everywhere else: the output has 156
`Color3.fromRGB` calls against the reference lift's 157, and the missing one is
this `return`. The gap is therefore about *which pcs the run actually executed*,
not about decoding: the walk reaches (mode 5, pc 50) in a state the recorded run
never had. `exec_rec` below exists to measure exactly that.

`tor_Reg` is not a way in: with `DEVIRT_BIGREG=1` all 196 events it logs carry
`obj.tid=None`, `L=None`, `z=None`, so the object it is called with is not the
proto's capability table and the big numbers cannot be attributed to a proto
through it.

### Execution coverage (`DEVIRT_EXECREC`)

`DEVIRT_EXECREC=1` makes the run record **which pcs it decoded in place**, so the
walk can say whether a state is one the program actually had. It is a set, never a
log: `envlog` keeps one weak-keyed table per number array (`CHAIN.execArr`) and the
dump emits each array's coverage as a run-length string (`"exec":"3-9,12"`), which
`dump.Dump._exec_pcs` turns back into `{tid: {pcs}}`. There is no per-step cost and
no per-step output; the sample's dump grew by well under a megabyte.

Two limits are load-bearing and are why this is an annotation, not a pruning rule:

* a **scrambled** proto cannot be covered -- the scramble rewrites every cell, so a
  diff says nothing about which instructions ran (`CHAIN.execScan` skips the protos
  the restore touched, `CHAIN.execRestored`);
* coverage is therefore not provably complete. An early version trimmed the walk at
  the first uncovered pc and collapsed the whole lift to four lines, so M1 only ever
  *marks*: `devirt.lift` collects the uncovered pcs and `driver` appends

```
-- devirt: N function(s) contain M pc(s) the recorded run never executed; ...
```

to the output. Nothing is dropped. The footer carries counts only, because dump
table ids follow an allocation order and differ between runs.

The run report gains two lines:

```
[*]   residual_unknown_split: ru_exec=1064 ru_unexec=145
[*]   [execrec] protos=8 pcs_visited=1257 (63% of the decoded window) trimmed=387
```

`ru_exec` is an unwritten-register read at a pc the run really executed (a genuine
caller-value gap); `ru_unexec` is one at a pc it never executed (an artefact of the
walk). They are counted where the lifter gives up on a register (`index` ->
`Reg(k)`), which is the same event the variable pass later reports as
`residual_unknown`; the three numbers do not sum, because that pass counts unbound
uses after structuring. `trimmed` counts annotated steps, the footer counts distinct
pcs.

Known gaps of this milestone: the flag is an environment variable only (there is no
`--exec-rec` switch), mode is not recorded (coverage is per proto and pc), and on a
1.5 MB sample only 8 protos got coverage (151 of 1111 arrays), so the numbers are a
lower bound on what the run executed.

### What this does not fix

The tail it removes is not user code. The statements just above it -- `mixBits`
with `536870911`, the shifts by 13 and 14, `table.pack(bit32.lshift(v, 13))` -- are
the VM's own operand decryptor: in the same source region, mode-5 opcode 91 does
`p = _(U(p, s(p, 13)), 536870911); p = U(p, v(p, 13)); ... h[T] = U(h[T], _(v(p, 0), 127))`
over the operand arrays, and the constants are identical. The walk reaches that
machinery because the state it carries into pc 44..50 holds a **symbolic** local
(`locs` = `T=58, p=None, M='r2'`), so the handler decodes operands from a value
that is a register rather than a number. Fixing that is a walk-level problem
(symbolic carried locals), not a printing problem -- the guard here only stops the
result from being a call of nil. Ten spin loops (§8) are still dropped.

## 15. The Separator Luau Reads as the Previous Statement's Terminator

### What happened

The 1.54 MB v15.1 sample (`s_07ca80aa…`, 608 protos) lifted, but Luau refused the
text:

```
(15486, 2) - (15486, 3) - Ambiguous syntax: this looks like an argument list
for a function call, but could also be a start of new statement; use ';' to
separate statements
```

The polish pass raised on its very first repair, so `polish_ast` returned nothing
and *every* polish step was skipped -- dead locals, IIFE unwrapping, bit32 chain
folding -- while the run still reported success. The shipped text was valid, but
only by luck: the statement it stumbled on had lost a `;`.

### Where the `;` comes from

`Renderer.block` separates a statement that opens with `(` from the one above it
by putting a `;` at the start of that line, because Luau itself refuses to decide
whether `(...)` is a new statement or an argument list:

```
local t = table.pack(bit32.band(...))
;(nil).Height = 80
```

### Where it went

Luau's parser attributes that `;` to the **previous** statement's location, so
when `_strip_unused_params_and_dead_locals` deleted the dead local above it, the
deletion's span ended on the separator and took it with it:

```
edit 611576..611661  (dead `local t = table.pack(...)`, plus "\t\t;")
->  local t = table.pack(...)          (deleted)
    (nil).Height = 80                  (its `;` is gone: ambiguous)
```

### The rule

`_apply_edits` keeps a deleted range's trailing `;` when the next byte is `(` --
but only where a `;` may stand. As the first statement of a block Luau rejects
it (`(0,0) Expected identifier when parsing expression, got ';'`), so a deletion
that also covers the previous statement, or that removes the block's first
statement, still drops it. `_separator_needed` decides by looking at the nearest
line *outside* the deleted range: a line ending in `then`, `do`, `else`, `repeat`
or `end` cannot be called, so nothing needs separating.

### Evidence

* the big sample's round-1 text now polishes (2,578,765 bytes) and parses
  (`bin/luau-ast` exit 0) where the polish chain aborted before;
* the shipped run is 44,365 lines that parse, instead of a 3,577-line trace
  fallback;
* the four small v15.1 samples are byte-identical to their pre-change output,
  and the test suite stays at 55 pass / 1 known failure / 5 skipped.

### What this does not fix

The same file still prints 6,177 `-- devirt: dropped a write through an undecoded
register` markers (`residual_unknown=12244`): the walk reaches the VM's operand
decryptor with a *symbolic* local, the same class of failure as §14, so most of
that file's lifted bodies are partial. The separator fix keeps such a lift
shippable and runnable; it does not make the walk complete.
