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

**Builds outside the v14.7–v14.9 range are refused, quickly.** The v14 mapper
rewrites dispatch-loop heads; a build whose loop shape it does not know (the
14.0/14.4/14.6 samples in the fixture set) matches nothing. Rather than spend a
full trace budget on it, the runner probes once with a bounded 15 s trace, then
reports that no dispatch loop matched and that older builds are not lifted. The
refusal is a fixture expectation in `test/golden.json`, not an untested path.

## 4. Checks

```bash
npm test          # syntax gate + watermark/detector/diagnostics/fixtures suites
npm run test:e2e  # golden regression: exact bytes, run twice, Luau syntax gate,
                  # report sha256 matches the file, no internal repr, trace labelled
npm run test:all  # both
```

`test/golden.json` pins the result of each fast-tier sample: sha256, md5, line
count, result type and lifted function count. A deterministic engine makes such
a table meaningful, so a regression is a diff rather than a judgement call.

## 5. Diagnostics

The run prints one line per measurable fact: `devirt round`, `functions /
unlifted blocks / unstructured jumps / new constant requests`,
`frame_propagation: bound= residual_unknown= unknown_callee=`, and with
`--exec-rec` also `[execrec] runs= covered= ... pcs_visited=`, plus
`poison_pc_covered=` when a call is dropped.
