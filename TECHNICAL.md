# Technical notes

Short on purpose. What the engine does, what it guarantees, and what it still
cannot lift — with the numbers, so nothing here has to be taken on trust.

## 1. Pipeline

```
input.lua ──▶ offline Roblox sandbox (runtime/envlog.luau)
                 │  runs the VM, dumps every reachable proto as JSON
                 ▼
             dump ──▶ symbolic walk (core/obfuscators/luraph_v15/)
                 │     decodes instruction cells through the VM model,
                 │     builds a CFG, lifts statements
                 ▼
             IR ──▶ backend.lower ──▶ Luau text ──▶ polish ──▶ output
```

`core/` is the compiler backend (IR, CFG structuring, SSA/names, idioms, codegen);
`src/` is the Node orchestration around it; `runtime/envlog.luau` is the sandbox
and the dump protocol.

A lift runs in rounds: `devirt round N` walks and collects the constants it could
not decode, the sandbox decodes them, and the next round lifts again. Rounds stop
when a full lift asks for nothing new.

`polish` alternates two passes twice: `core/flatten.py` and the AST cleanup
(`core/ast_polish.py`). The flattener is what turns the obfuscator's control-flow
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

* `core/deadstore.py` removes stores nothing can read. Each block is walked
  backwards keeping the locals still read ahead; a store whose target is not in
  that set and whose value cannot fail (no call, no index) is deleted, which in
  turn kills the reads that kept the store behind it alive. Loop bodies are
  scanned to their own fixpoint, since what the next iteration reads on entry is
  what this one leaves behind.
* `core/seeds.py` removes the seed chains themselves, by the same argument
  applied to a whole local at once: every write is literals, other seeds or the
  u32 helpers, and every read sits inside text the pass is deleting.
* `core/u32fold.py` folds the arithmetic that is left when it is genuinely
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

`core/copies.py` folds them. A copy is inlined only when nothing can observe the
register: every read between the copy and the next write to that register is
rewritten to name the source, the source itself is a local with at most one
write (a parameter, or a local assigned once, possibly in an enclosing function),
and neither side is captured by a closure that could run before the copy does.
A plain assignment copy is deleted outright; a `local` keeps its declaration
when the register is refilled later, so the later writes still have a target.
Reads that sit after the refill are untouched, which is what makes the fold safe
inside loops.

Pure sources are folded too -- `local iterate = ipairs` becomes `ipairs(...)` at
the call -- and a `local x` nothing reads is dropped. On RideAPet that is 684
copies inlined and 54 dead declarations gone, which is most of the `data2 =
data3` traffic that made the lifted code hard to follow.

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

### Parentheses and longer names

Two cosmetic passes finish the file. `core/tidy.py` drops a parenthesis group
when no operator is left beside it to rebind what is inside: a condition, a
return value, the value of an assignment, or an operand that already binds
tighter than the operator around it. `(2 + 3) * 4` and `2 - (3 - 1)` keep theirs,
`(a or b) and c` keeps its, and a group around a call is only removed where a
single value is expected -- `f((g()))` truncates `g()` while `f(g())` forwards
it, so that one stays. RideAPet loses 816 groups.

The seed numbers the VM passed to its own functions survive the arithmetic
passes as arguments nobody reads, so a call to a function that takes none is
trimmed back to its arity -- `compileChunk(488023178, 180544471)` becomes
`compileChunk()` -- but only when the dropped arguments are side-effect free.

The names themselves come from what the value does, never from a guess: a table
handed named functions is the script's `module`, a value answering the Instance
API is an `instance`, and a register that is refilled with different kinds of
value keeps the generic word instead of inheriting the first one's name.

### How the text passes are tested

Three kinds of check, because a compiler accepting the file says nothing about
what it prints:

* `test/copies.test.js`, `test/tidy.test.js`, `test/seeds.test.js` -- each case is
  run under Luau before and after, so the two programs have to print the same
  thing;
* `test/passes_fuzz.test.js` -- generated programs full of register patterns
  (copies, refills, loop back edges, branches, closures, nil stores) go through
  the whole chain and are compared the same way, and the test also asserts the
  corpus actually exercised the passes, so a green run cannot mean nothing was
  tried;
* `test/smoke.test.js` -- every file in `results/` is executed inside the same
  stub environment the tracer uses (`scripts/smoke.js`, the runtime's own
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
  This is enforced, not hoped for — `test/e2e.test.js` runs every golden sample
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

**Replaying undecoded cells was tried and rejected.** Asking the live VM to
decode the cells behind the dropped call returns a value derived from an
already-decoded word (those arrays carry no per-cell coverage at all), so the
second lift has no trustworthy denominator: it lost 4 blocks and moved 265 lines
of the reference output. What a sound version needs first is a per-array
"decoded in place" flag from the runtime, so `unrecorded` can become `no`.

**One file can carry two scripts, and the wrapper is not the script.** The
Chilli-hub build in the fixture set (`StealAnEggg`, pinned as `lph-v15-1-5`) is a
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
refusal is a fixture expectation in `test/golden.json`, not an untested path.

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

**Compiling is not enough, and the gates say so.** `scripts/luac.js` feeds each
output to the real Luau compiler; `scripts/freevars.js` parses it with
`bin/luau-ast` and separates two things that look alike in a diff: a register the
lifter could not name (`r4`, `r34` — a hole, exit 1) and a global the payload or
the executor owns (`syn`, `fluxus`, `Webhook` — a note). `npm run gate` is strict
about the first and silent about the second. CI runs the compile gate as a test
and the free-variable gate as a report until the remaining notes are understood.

`test/golden.json` pins the result of each fast-tier sample: sha256, md5, line
count, result type and lifted function count. A deterministic engine makes such
a table meaningful, so a regression is a diff rather than a judgement call.

## 5. Diagnostics

The run prints one line per measurable fact: `devirt round`, `functions /
unlifted blocks / unstructured jumps / new constant requests`,
`frame_propagation: bound= residual_unknown= unknown_callee=`, and with
`--exec-rec` also `[execrec] runs= covered= ... pcs_visited=`, plus
`poison_pc_covered=` when a call is dropped.
