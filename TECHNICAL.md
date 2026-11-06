# Technical notes

Short on purpose. What the engine does, what it guarantees, and what it still
cannot lift — with the numbers, so nothing here has to be taken on trust.

## 1. Pipeline

```
input.lua ──▶ offline Roblox sandbox (runtime/envlog.luau)
                 │  runs the VM, dumps every reachable proto as JSON
                 ▼
             dump ──▶ symbolic walk (engine/obfuscators/luraph_v15/lifter.py)
                 │     decodes instruction cells through the VM model,
                 │     builds a CFG, lifts statements
                 ▼
             IR ──▶ backend.lower ──▶ Luau text ──▶ polish ──▶ output
```

`node/` is the Node orchestration (`driver.js`, `harness.js`, `detect.js`, …).
`engine/*.py` is the shared compiler backend (IR, CFG structuring, SSA/names,
idioms, codegen), and `engine/obfuscators/<family>/` holds the per-family front
ends that feed it. `dev/` holds the test suite, fixtures and gate scripts. `runtime/envlog.luau` is the sandbox and the dump protocol.

A lift runs in rounds: `devirt round N` walks and collects the constants it could
not decode, the sandbox decodes them, and the next round lifts again. Rounds stop
when a full lift asks for nothing new.

`polish` alternates two passes twice: `engine/flatten.py` and the AST cleanup
(`engine/ast_polish.py`). Two AST passes run once everything else has settled: `name_context_slots` gives
the script's own `data[k]` helper slots a name, and `name_from_usage` names the
parameters (`argument5`), handlers (`callback7`) and register locals (`value7`)
the namer left as fallbacks, from the methods they are given to, the calls they
are handed to, the signature of the function that receives them (a local
function *or* a method table -- `module.run = function(self, job)` makes
`module:run(x)` evidence), and, for a `value7` written exactly once, from the
initialiser itself (`part.Position` -> `position`). Both run after naming because the
namer renames locals by use, and an alias it did not write would change what the
namer decides; `name_from_usage` runs last so a slot's new name counts as
evidence. Two more rules keep a lift honest about what it could not see. A branch on a
literal (`if nil then ... else ... end`) is a branch the run already decided, so
the block that ran is kept and the other one is dropped with a `-- devirt:` note
instead of being left for the reader to explain. And a write into a frozen
library table (`data = string` followed by `data[k] = v`) is impossible in Luau:
it means the lift lost the table the code builds, so that table is materialized
as `{}`, noted in the file, and reported as a warning in the run report. The
flattener is what turns the obfuscator's control-flow
flattening back into straight-line code. Luraph encodes it as a loop over a
constant range that dispatches on the counter:

```lua
local step, limit, counter = 67, 143, 76 - 67
while true do
    counter += step
    ...                          -- the numeric-`for` break checks
    local state = counter
    if state ~= 115 then ... else ... end
end
```

Nothing in that is unknown: the loop visits 76 then 143, so `state` is 76 on the
first pass and 143 on the second, and each branch is decided by the constants
alone. The pass enumerates the range, substitutes the counter, folds the
comparisons, and emits the statements in the order they really run -- copied from
the source spans, so comments survive. It also drops loops that provably run zero
times, including the inverted-break shape whose setup sits inside the body.

It is deliberately narrow. A loop is left alone -- and counted by reason, not
silently skipped -- when a bound is a runtime value (`unknown-bounds`), when a
`break`/`continue` is still conditional after folding (`conditional-jump`), or
when an inverted loop would never terminate (`dead-loop-runs`). Two rules keep
the rewrite exact: a variable is only folded when every write to it happens in
the same block, and substitution never touches an assignment target. When the
loop finishes, the counter is left at the value that failed the check, and the
pass writes that value back if anything after the loop can still read it.

### The obfuscator's own arithmetic

A v15 build seeds every protected function with a number it only ever hashes
against itself:

```lua
local state = 135623784
state = bit32.bxor(state, 279606389)
state = u32Trunc(u32Mul(69228956, state) + 663714168)
```

None of that reaches the script — it is the integrity trail the VM used to check
that its code had not been edited, lifted into ordinary statements that only feed
themselves. Three passes take it apart, in this order:

* `engine/deadstore.py` removes stores nothing can read. Each block is walked
  backwards keeping the locals still read ahead; a store whose target is not in
  that set and whose value cannot fail (no call, no index) is deleted, which in
  turn kills the reads that kept the store behind it alive. Loop bodies are
  scanned to their own fixpoint, since what the next iteration reads on entry is
  what this one leaves behind.
* `engine/seeds.py` removes the seed chains themselves, by the same argument
  applied to a whole local at once: every write is literals, other seeds or the
  u32 helpers, and every read sits inside text the pass is deleting.
* `engine/u32fold.py` folds the arithmetic that is left when it is genuinely
  constant, with Luau's own bit32 semantics (shift counts mod 32, `u32Mul` is
  `(a * b) mod 2**32`). An identity such as `band(x, 0xFFFFFFFF) -> x` is only
  applied when the operand is provably already an integer.

What survives is counted and left in place: on RideAPet that is the two helper
definitions, one string decoder that really does use `bit32.bxor`, and register
junk whose value is stored in the same statement as a real one and later read by
a real expression, which cannot be removed without proving the reader never
observes it.

### The VM's register copies

Once the seeds are gone, what is left of the VM's bookkeeping is the moves:

```lua
local module2 = module
module2.RarityOrder = nameList
module2 = module
module2.RarityRank = {}
module2 = ipairs
for k, v in module2(nameList) do
```

`engine/copies.py` folds them. A copy is inlined only when nothing can observe the
register: every read between the copy and the next write to that register is
rewritten to name the source, the source itself is a local with at most one
write (a parameter, or a local assigned once, possibly in an enclosing function),
and neither side is captured by a closure that could run before the copy does.
A plain assignment copy is deleted outright; a `local` keeps its declaration
when the register is refilled later, so the later writes still have a target.
Reads that sit after the refill are untouched, which is what makes the fold safe
inside loops.

Pure sources are folded too -- `local iterate = ipairs` becomes `ipairs(...)` at
the call -- and a `local x` nothing reads is dropped. On RideAPet that is 402
copies inlined and 57 temporaries folded, which is most of the `data2 = data3`
traffic that made the lifted code hard to follow.

What makes the fold safe is the list of things it refuses to do:

* every read of the register must sit between the copy and the next write to it,
  or after a *straight-line* refill in the same block. A read before the copy is
  not dead weight: inside a loop it runs again after this very statement, and in
  an `if`/`else` the other branch reaches it without the refill having happened;
* a read inside a nested loop that also writes the register is left alone: it is
  looking at what the previous pass through the body left there;
* the read has to be in the copy's own block, and the name it is rewritten to has
  to resolve to the same local there -- a `local a` declared in between would
  make the new name mean something else;
* a copy whose source is itself folded in the same round is deferred to the next
  round, and a declaration is only removed when no statement names it any more
  (dropping `local b` would turn a later `b = ...` into a write to an outer `b`).

The dead-store pass follows the same rule for branches: the arms of an `if` are
alternatives, so each is scanned from the same live-out and the results are
unioned. Scanning one arm first used to let its stores mark the other arm's
stores dead, which is how a register read after the `if` ended up nil.

The pass runs before naming on purpose: a register that is one long chain of
copies gets named after the value that started the chain, so `module.RarityRank`
reads as the field it is instead of `module2.RarityRank`.

The last sweep runs after every rewrite above, because they are what leaves a
declaration holding a name nothing reads any more (`local a, b = nil, os.clock()`
once the seed cleanup empties `a`). A slot is dropped when the local is never
read, that declaration is its only write, and the value is a literal or a copy of
another local -- so no call is lost and no read can be moved. What cannot be
dropped is the slot that takes the *first* result of a multi-value call:
`local first, second = f()` would hand `second` the wrong result the moment
`first` goes. Those names stay, and are written `_`, which is what Lua writes for
a value that is discarded on purpose. `_` is only used when the file has no live
`_` of its own, since ours would capture or shadow it.


### Parentheses and longer names

Two cosmetic passes finish the file. `engine/tidy.py` drops a parenthesis group
when no operator is left beside it to rebind what is inside: a condition, a
return value, the value of an assignment, or an operand that already binds
tighter than the operator around it. `(2 + 3) * 4` and `2 - (3 - 1)` keep theirs,
`(a or b) and c` keeps its, and a group around a call is only removed where a
single value is expected -- `f((g()))` truncates `g()` while `f(g())` forwards
it, so that one stays. RideAPet loses 816 groups.

The base of an index is not an ordinary expression: `({a = 1})[k]` needs its
brackets because `{a = 1}[k]` does not parse, and `(a or b)[k]` is not
`a or b[k]`. Both are kept. A build that carried a table literal indexed on the
spot is what made that rule visible -- dropping the group made the whole file
stop parsing.

The seed numbers the VM passed to its own functions survive the arithmetic
passes as arguments nobody reads, so a call to a function that takes none is
trimmed back to its arity -- `compileChunk(488023178, 180544471)` becomes
`compileChunk()` -- but only when the dropped arguments are side-effect free.

The names themselves come from what the value does, never from a guess: a table
handed named functions is the script's `module`, a value answering the Instance
API is an `instance`, and a register that is refilled with different kinds of
value keeps the generic word instead of inheriting the first one's name.

### Loaders that carry the script as a function

Not every v15 build virtualises the script. Some keep it as one field of the
loader's table and call that field with the table itself; the engine prints it
rather than lifting it (`payload-source`) because it already reads as source.
Two things can then be true, and the header of the result says which:

* the carried text is itself a delivery stub -- a Luarmor v4 client, which
  fetches the real script from `api.luarmor.net` after a licence handshake. The
  script is not in the file, and no local pass will find it. The header names the
  endpoint and the loader id, and `engine/carrier.py` writes the marker line
  `-- deobf: needs the hub at run time` so the runtime gate knows that stopping
  at the stub is the expected end;
* the script reaches into the loader's own helper table (`H2`, `g2`, `[72]`).
  Those are the hub's private API, so the bootstrap passes a stub that names the
  missing helper the first time one is used, instead of failing as "attempt to
  index nil" several frames inside code the reader is trying to follow.

### Chaining into the Luarmor track

When the engine prints a carrier's payload, the payload is handed to the Luarmor
analyzer in the same command -- no second run (node/luarmor.js `chainPlan`/`chain`).
The payload alone is what gets read: `emit_payload_source` writes it next to the
intermediates without the header and bootstrap lines this tool adds, so the
analysis is about the loader's script and not about our own comments.

Two outcomes, decided by the analyzer rather than by a pattern match here:

* **the payload carries a Luraph chunk** (a sephal init, or a loader Luarmor
  served): the same engine runs over the payload and the lifted chunk becomes the
  result, with the Luarmor metadata on top. This is the case worth the chain --
  the code is in the file, and it is the code the chain says it is;
* **the payload is only a client stub**: nothing is lifted, and the analysis
  travels with the result as `results/<name>.luarmor.json`, mirrored into the
  report under `chain` and `luarmor`. That is the module id, cache key, client
  tag, build stamp, key link and endpoints -- what the file needs before it can
  do anything, and where the script itself comes from.

Nothing here fetches, decrypts or bypasses a licence check: only bytes that are
already in the file are lifted, and `--no-devirt` turns the chain off with the
rest of the lifting.

### How the text passes are tested

Three kinds of check, because a compiler accepting the file says nothing about
what it prints:

* `dev/test/copies.test.js`, `dev/test/tidy.test.js`, `dev/test/seeds.test.js`,
  `dev/test/polish.test.js` -- each case is run under Luau before and after, so the
  two programs have to print the same thing;
* `dev/test/passes_fuzz.test.js` -- generated programs full of register patterns
  (copies, refills, loop back edges, branches, closures, nil stores) go through
  the whole chain, `ast_polish` included, and are compared the same way, and the test also asserts the
  corpus actually exercised the passes, so a green run cannot mean nothing was
  tried;
* `dev/test/smoke.test.js` -- every file in `results/` is executed inside the same
  stub environment the tracer uses (`dev/scripts/smoke.js`, the runtime's own
  `envlog.luau` harness). A register that lost its value shows up here as
  `attempt to call a table value` or `attempt to index nil`, which is precisely
  what the compile and free-variable gates cannot see.

## 2. Rules the engine does not break

* **A value that was not recorded is printed as a hole**, never guessed:
  `nil --[[ constant not decoded ]]`, `-- devirt: ...` notes, `-- unresolved:`
  headers. Readability is the product; an invented constant is a bug.
* **Coverage never deletes code.** `--exec-rec` records which pcs the run decoded
  in place and annotates the rest (`walk_trim_unexecuted`). The set is not proven
  complete, so nothing is pruned on it.
* **The dump is never re-serialised.** A JSON round trip turns
  `0.94743997235392186` into `0.9474399723539219`; a changed constant changes the
  lift. Extra data (e.g. the coverage union) goes to a sidecar file instead.
* **Output is deterministic**: the same input and flags produce the same bytes.
  This is enforced, not hoped for — `dev/test/e2e.test.js` runs every golden sample
  twice and compares the two files byte for byte.
* **No internal identity reaches the output.** Diagnostic text that ends up in
  a file (`-- devirt: ...`, `error("devirt: ...")`) is formatted through
  `luasym.describe_value()`, which never prints a memory address; a class that
  falls back to `object.__repr__` is described by type name. `scrub_addresses()`
  is the second gate, and a unit test rejects any new `Unsupported(... %r)` in
  the Python core, so the class of bug cannot come back one call site at a time.
  (This mattered: `LTable.__repr__` fell back to `id(self)` and one diagnostic
  carried `<luasym.RegFile object at 0x...>`, which changed the output md5 and
  moved the watermark line between runs.)
* **Attribution is one header line plus one `print("Deobf By Zed")`.** The
  credit is the file's first line (after a `#!`, if present) and nothing of ours
  is inserted inside the recovered program; the print goes at the bottom, or
  before a trailing top-level `return` so a module chunk still parses.
* **A trace is labelled a trace.** When a lift is unavailable the result is a
  behaviour trace: values are what the run observed, so a value computed at run
  time appears as its result. The file says so in its header and the report says
  `result_type: trace`; it is never presented as reconstructed source.

## 3. What is still missing (measured)

**The dropped call in the reference sample.** At `pc=50` the walk reaches a state
the recorded run never visited, so the instruction is read out of cells that were
never decoded in place. The finished CFG has no writer for the callee register and
drops the call. The report says so instead of hiding it:

```
poison_pc_covered=unrecorded (pc=50, mode=5, 0/5 arrays the instruction reads
carry coverage, 0 decoded there)
```

Verdict rule: per array, no union shortcuts, and `unrecorded` is never read as
`no`.

**The UI region of the hub script.** The hub object's construction calls are only
partly lifted: our output has 23 `:Create...` calls against 400 in the reference
deobfuscation of the same script, and it never shows `CreateTab` /
`CreateSection`. The tab/section *data* is decoded (names, sides, option lists),
the calls that consume it are not. That is a lift gap, not a naming issue.

**Coverage across runs adds nothing here.** Four runs per fixture (different
pins/fuel, four different dump md5s) decode exactly the same cell set:

| fixture | runs | cells per run | union | protos covered |
|---|---|---|---|---|
| SampleV1 | 4 | 89585 ×4 | 89585 | 38 → 38 |
| RideAPet | 4 | 113791 ×4 | 113791 | 51 → 51 |
| StealAnEgg | 4 | 94239 ×4 | 94239 | 41 → 41 |

So a block with no coverage is not "code the program skips", it is code no
offline run reached.

**Replaying undecoded cells was tried again with the per-array flag, and
rejected for a sharper reason.** With `scan` in the dump (see §5) the engine can
say, per array, whether the recorder walked it. Two rules were measured on that:

* *Replace what the walk read.* Every cell of a never-executed pc whose arrays
  were all walked (state 1) was decoded by the live VM and written back. On
  `Lph1-v15.0` that replaced 680 cells and the lift collapsed from 275 lines to
  14: the words were there, and the VM's answer for an instruction that never
  ran is not the word the walk had decoded.
* *Fill only what the dump does not hold.* Same guard, but a cell is requested
  only when the array carries no value at that slot. `Lph1`: 0 candidates, every
  cell already present. `Lph6-V15.0`: 65 candidates, the VM decoded 0 of them.
  The other 1,195 pc(s) were refused outright because at least one array the
  instruction reads is not walkable (never registered, or rewound).

So on this VM the arrays always carry their words; what is missing is not the
word but whether the instruction it decodes to is the one the program would
have run there, and no post-hoc decode can answer that. Replay was reverted;
what stayed is the flag that makes `unrecorded` mean what it says.

**Driving the connected handlers was tried and rejected too.** The run stops at
the first yield, so every `:Connect`ed handler -- a button click, a remote, a
heartbeat -- never executes. `--drive` queued each handler where the connection
is made and fired the queue after the main chunk, in the VM's own session
(`coroutine.resume`, four rounds, 4,000 calls). Six handlers fired on
`Lph1-v15.0`, sixteen on `Lph6-V15.0`; coverage did not move (147,295 -> 147,414
cells, inside the run-to-run band) and the lift got *worse*: `Lph6` went from
14,895 to 9,614 lines with the same ten `:Create` and twenty-four `GetService`
calls. Firing a handler after the script has finished mutates the VM state the
dump is a photograph of, so the dump stops describing the run that was traced
without contributing code the walk can use. A sound version has to keep the
driven run out of the authoritative dump (coverage-only, mapped by array
identity) and isolate each handler; that is a bigger change than the measured
payoff justifies today.

**One file can carry two scripts, and the wrapper is not the script.** The
Chilli-hub build in the fixture set (`StealAnEggg`, pinned as `lph-v15-1-stealaneggg`) is a
`return setmetatable({...})` table: the hub's UI library is virtualized, and the
Steal-An-Egg script itself sits in one field of that table as *plain Luau*.
Lifting the VM recovers the machine (5,055 lines of ChilliLibrary), which is a
faithful result for the wrapper and the wrong answer for the question "what does
this script do". The engine now reads the carrier first: when one function field
of the returned table clearly reads like a script (services, globals — 477
script-shaped reads against 68 for the next field, out of 92) and parses as Luau,
that field is printed as the result and the report says `result_type:
payload-source`. `DEVIRT_PREFER_VM=1` keeps the old route and lifts the wrapper
instead. Nothing about the payload is guessed: the field is the code the loader
calls, printed through the same polish the lifted text gets.

**A folded declaration used to turn a live table into a nil global.** The
lifter writes a self-referential table the way Lua requires it — declared first,
assigned second:

```lua
local handlers
handlers = { _unpack = function(a) return handlers._unpack(a) end }
```

`ast_polish._merge_local_decls` folded that into `local handlers = {...}`, which
is *not* the same program: inside its own initialiser the name is not in scope, so
Luau resolves it as a global. The result compiled, ran, and then crashed with
`attempt to index nil` the first time the recursive helper was called — and the
free-variable gate reported it as `r4`, the register name the fold had left
behind. The fold now skips any value that mentions the variable being declared
(`_has_ident_reference`), the same guard `_sugar_local_functions` already had for
`local f = function() ... f ... end`. Two sites in `Lph6` and one in `f44daa`
were affected; both files now report zero unresolved register reads.

**Builds outside the v14.7–v14.9 range are refused, quickly.** The v14 mapper
rewrites dispatch-loop heads; a build whose loop shape it does not know (the
14.0/14.4/14.6 samples in the fixture set) matches nothing. Rather than spend a
full trace budget on it, the runner probes once with a bounded 15 s trace, then
reports that no dispatch loop matched and that older builds are not lifted. The
refusal is a fixture expectation in `dev/test/golden.json`, not an untested path.

**Serving the fetched library offline was measured, and it costs more than it
gives.** A hub script bootstraps itself through `game:HttpGet`, which the sandbox
answers with `nil`, so the run dies on the script's own `assert(chunk)`. `--http-cache`
feeds the runtime's existing `CFG.http_map` from an explicit `index.json`
(url -> file), so that url answers with the body instead of `nil`. The Chilli
library the hub fetches is 415 KB of plain Luau, and serving it moved the trace's
death from the bootstrap assert to *inside the library*
(`attempt to compare userdata <= number`, its own `hudRestorePosition.X.Scale
<= -0.5`, a `UDim2` component the proxy model only folds when it can):

| `RideAPet` | without the cache | with the library served |
|---|---|---|
| wall clock | 154 s | 475 s |
| output | 11,034 lines, 716 functions | 10,405 lines, 660 functions |
| `CreateToggle` / `GetService` | 32 / 20 | 28 / 19 |
| verdict | baseline | compiles 1/1, 0 unresolved reads, but strictly less of the hub |

So the flag stays opt-in and refuses to pretend: a run that ends in a `script
error` while the cache is on is reported as such, because reaching *further* into
a body the sandbox cannot execute is not the same as lifting more of the script.
The real blocker is the `UDim2`-component comparison, not the missing body.

**Before / after: what running the live hub scripts changed.** The fixtures were
the reference samples for a long time, and they flattered the engine: small,
self-contained, one script per file. Two builds from the Chilli hub
(`StealAnEggg`, `RideAPet`, both Luraph v15.1) are the first inputs that behave
like what the engine is used for, and they broke something the tests never
touched.

| | before (samples only) | after (live hub builds) |
|---|---|---|
| `--rename` | crashed at startup: `renamer/garbage.js` still required `../engine/pyenv`, a path that moved to `node/` when the helpers were split. No test loaded the renamer, so the gate stayed green. | runs: `RideAPet` gets 59 raised names and 58 comments (11,034 → 13,282 lines, comments only). Guarded by `dev/test/requires.test.js`, which resolves every literal relative `require()` in the tree (40 files). |
| "is it maxed?" | answered by reading the log | `--stats` prints one digest per output: result type, size, coverage, unexecuted pcs, numbered identifiers, residual reads, warnings |
| coverage | 64 % of the decoded pc window on `Lph1` was read as headroom for more runs | 1,999 pcs of 328,377 (0.6 %) on `RideAPet`, unchanged at `DEVIRT_EXECRUNS=4` and `=8`; cell union 113,791 either way, code byte-identical |
| HTTP | `game:HttpGet` answers `nil`, so the hub's bootstrap `assert(chunk)` ends the run at line 20 | `--http-cache` answers a captured body instead; measured on `RideAPet` it moves the stop *inside* the library and lifts slightly less, so it stays opt-in |
| shape | one obfuscated chunk per file | `StealAnEggg` is a loader that carries the hub script as plain Luau: 26,073 printed lines / 2,204 functions, `result_type: payload-source`; the VM wrapper is 5,055 lines of UI library and is deliberately not the answer |

The two numbers that matter for trust: `RideAPet` compiles 1/1 under Luau and
leaves 0 unresolved register reads across 11,034 lines, and the 21 functions that
contain the 590 pcs no offline run reached are named in the footer instead of
being presented as decoded.

## 4. Checks

```bash
npm test          # Luau compile gate over results/ + watermark/detector/
                  # diagnostics/fixtures suites
npm run test:e2e  # golden regression: exact bytes, run twice, Luau syntax gate,
                  # report sha256 matches the file, no internal repr, trace labelled
npm run luac      # every result compiles in Luau (bin/luau + loadstring)
npm run freevars  # every result is closed: no undeclared register read
npm run gate      # both of the above, strict -- this is what a release must pass
npm run test:all  # test + test:e2e
```

**Compiling is not enough, and the gates say so.** `dev/scripts/luac.js` feeds each
output to the real Luau compiler; `dev/scripts/freevars.js` parses it with
`bin/luau-ast` and separates two things that look alike in a diff: a register the
lifter could not name (`r4`, `r34` — a hole, exit 1) and a global the payload or
the executor owns (`syn`, `fluxus`, `Webhook` — a note). `npm run gate` is strict
about the first and silent about the second. CI runs the compile gate as a test
and the free-variable gate as a report until the remaining notes are understood.

`dev/test/golden.json` pins the result of each fast-tier sample: sha256, md5, line
count, result type and lifted function count. A deterministic engine makes such
a table meaningful, so a regression is a diff rather than a judgement call.

## 5. Diagnostics

The run prints one line per measurable fact: `devirt round`, `functions /
unlifted blocks / unstructured jumps / new constant requests`,
`frame_propagation: bound= residual_unknown= unknown_callee=`, and with
`--exec-rec` also `[execrec] runs= covered= ... pcs_visited=`, plus
`poison_pc_covered=` when a call is dropped.

### Which arrays the recorder can speak for

With `--exec-rec` the runtime records, per number array, the pcs it decoded in
place. Silence had two meanings and the dump could not tell them apart: an array
the scan walked and found nothing in, and an array whose proto the restore
rewound (a scramble rewrites every cell, so a diff proves nothing). Every table
now carries `"scan":1` when the walk looked at it and `"scan":0` when its proto
was rewound; an array with neither is one the runtime says nothing about.

`dump.exec_scan_state(tid)` returns 1, 0 or None from that, and the
`poison_pc_covered=` verdict only reads a missing pc as "this run did not decode
that cell" when every array the instruction reads returns 1. A verdict of `no`
is therefore a fact about the recorded runs, never a claim that the code is dead;
`unrecorded` still means exactly what it says.

The union sidecar merges the flags the same way it merges pcs: an array counts as
scanned when any run walked it, and as rewound only when a run rewound it and no
run ever walked it. Measured on `Lph6-V15.0` (737 protos, 6,142 arrays, 313,801
cells, four runs): 1,660 arrays / 150,565 cells moved from unspoken to a stated
"nothing decoded here", 0 were rewound, and 2,458 arrays (lazy constants and
tables no proto owns) stayed unspoken -- named, not guessed.

### Naming why a run stopped

A trace that stops early carries `-- run status: ...` in its header, and the
report repeats it in `trace_status`. When that status is an error, the report also
gets a `diagnosis` sentence, because two very different situations produce the
same message: the sandbox meeting a call it cannot answer, and the input not being
self-contained. For `attempt to call missing method 'X'`, the driver looks for a
definition of `X` in the input (`X =`, `["X"] =`); if there is none, the diagnosis
says the capture looks incomplete rather than blaming the environment. The mapping
lives in `diagnoseTrace` (`core/driver.js`) and is covered by
`dev/test/trace_status.test.js`.

### Register names the lift cannot declare

A state machine block can read a register inside the loop it belongs to and, after
the CFG is structured again, end up outside that loop. The read survives as
`tostring(r6)` while the store that filled register 6 stayed behind, so nothing in
the output declares the name -- and in Luau an undeclared name is a global read,
silently nil. `variables.rename` also splits a register into one variable per web,
so the same hole can appear as `r6_2`.

`ast_polish._declare_unresolved_registers` runs after the capture pass and asks the
parser which of those names are really holes: only an `AstExprGlobal` whose name
matches `r<digits>` (optionally `_<digits>`) counts. A closure parameter named `r1`
is a parameter, a name the chunk assigns itself is a real global, and `"r6"` inside
a string is data -- none of them are touched. Each hole is renamed to
`unresolvedRegister<N>` at the exact source span the parser reported, declared at
the top of the file, and annotated at every use with the shape the original value
had (`_hint_unresolved_captures` handles both families). The runtime value does not
change -- it was nil, it stays nil -- but the output stops reading a global that no
script has, and the reader is told what went missing instead of finding a bare
identifier.

### A literal branch is not always a decided branch

`_fold_constant_ifs` keeps the block a literal condition selects and drops the
other one. The condition can be literal because the run decided it, or because the
lift lost the value behind it -- a missing operand prints as `nil`. In the second
case the dropped block can be the only place a variable is set, and deleting it
leaves the frame nil where the original had a value (`f44daa11`: the decoder's
`argument % 256`).

`_fold_constant_ifs_once` therefore drops a branch only when the names it assigns
are also assigned by the block that is kept (`_branch_targets`). A body that sets
nothing new is still folded exactly as before, which is why the pinned results are
byte-identical; a body that is the only initializer stays, and the file keeps the
value it would otherwise have lost.

### Formatting the result

The lift lays its own code out, but a payload printed from a loader field is
printed as written, and a trace is one statement per line by construction. Both
read better through a real formatter, so `core/format.js` calls StyLua (the WASM
build, `@johnnymorganz/stylua`, no platform binary) on the finished text, in
`deob.js` right before the watermark and the write, and in the renamer before its
output.

Two things had to be right for this to be safe:

* **The formatted text is parsed before it replaces the result.** `luau-ast` is
  asked; a formatter that mangles a script is worse than no formatter, so the
  unformatted text wins and the report says `format.skipped`.
* **The formatter is run to a fixed point.** With very long table/call lines the
  hang decision can move on the next pass (`}, {}` joining), so one pass is not
  stable. `formatLuau` repeats (at most 4 passes, each with a fresh `Config`, since
  the wasm Config is consumed by the call) until the text stops changing.
  `dev/test/format.test.js` pins that formatting a formatted result moves no bytes.

Nothing else in the pipeline is allowed to depend on the layout: the passes that
run after the lift work on parsed structure, and the gates (`luac`, `freevars`,
`smoke`) run on the formatted file exactly as a user would run it.
