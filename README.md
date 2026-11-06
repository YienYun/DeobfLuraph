# DeobfLuraph — Luraph Lua / Luau Deobfuscator

Turns a Luraph-protected script back into readable Luau: it runs the file in an
offline Roblox environment, records what the VM actually does, then rebuilds
source from the recorded instructions.

This is a **Luraph-only build**: v15.0 / v15.1 as the primary engine, v14.7 –
v14.9 lifted through the same backend, plus the Luarmor chain analyzer. Every
other obfuscator — MoonVeil included — has been removed from the tree.

**Where things live:** `engine/obfuscators/luraph_v15/` is the v15 engine,
`engine/obfuscators/luraph_v14/` the v14 engine, `engine/obfuscators/luarmor/`
the Luarmor analyzer. `engine/*.py` is the compiler backend all three feed into,
`node/*.js` the Node side (detection, offline sandbox, formatting, CLI glue),
`renamer/` the optional `--rename` pass. `dev/` holds the test suite, fixtures
and gate scripts — development only, never part of a lift.

| Family | Module | What it does |
|---|---|---|
| **Luraph v15.0 / v15.1+** | `engine/obfuscators/luraph_v15/` | Sandbox run ➔ symbolic CFG / SSA lift ➔ Luau source |
| **Luraph v14.7 – v14.9** | `engine/obfuscators/luraph_v14/` | v14 VM mapper + symbolic lift on the same backend |
| **Luarmor v4** | `engine/obfuscators/luarmor/`, `node/luarmor.js` | Client-chain analysis; when the file carries a Luraph chunk, that chunk is lifted by the v15 engine |

About Luarmor: the licence check is **not** bypassed. The session payload lives
on Luarmor's server behind a key, so a bare `_bsdata0` client stub is reported —
module id, hashes, build stamp, endpoints — instead of being faked into code.

`node/detect.js` still recognises the signatures of the removed obfuscators, so a
file can be named correctly (`--detect`). It cannot be deobfuscated here: the
run stops with `<engine> is not part of this build` and writes no output. That
includes MoonVeil: a MoonVeil file is named as such and refused, never
half-processed by machinery that would only part-lift it.

---

## Run

Needs **Node.js 18+** and **Python 3.10+**.

```bash
npm install

node deob.js protected.lua -o out.lua     # one file
node deob.js folder/                      # a whole folder, recursively
node deob.js protected.lua --detect       # identify the obfuscator, run nothing
node dev/scripts/smoke.js out.lua             # run the result in the offline sandbox
```

### Flags

| Flag | What it does |
|---|---|
| `-o, --output <file>` | write the result here (single input only) |
| `--detect` | classify the file and stop; nothing is executed |
| `--plugin <name>` | force an engine (`luraph_v15`, `luraph_v14`, `luarmor`, `generic`) |
| `--no-devirt` | behaviour trace only: no lifting, no `--report`-free guessing |
| `--report <file.json>` | machine-readable run report (schema `1`, includes `output_sha256`) |
| `--http-cache <dir>` | answer `game:HttpGet` from `index.json` (url -> file) instead of `nil`; served bodies are lifted like any chunk but never become the result |
| `--stats` | print a digest of what the output still cannot promise: coverage, unexecuted pcs, numbered identifiers, residual reads |
| `--rename` | extra Layer-2 pass: dead-code removal + scope-verified renaming |
| `--comments <none\|light\|detailed>` | how much the Layer-2 pass annotates (default `light`) |
| `--debug` | keep the sandbox trace and announce every intermediate file |
| `--strings` | also write the strings the run decoded (`<out>.strings.txt`) |
| `--budget <sec>` / `--timeout <sec>` | script-side time budget / harness wall clock (default 30 / 90) |
| `--exec-rec` | record which program counters the run executed (`[execrec]` lines) |
| `--no-hooks` | do not instrument VM functions (no lifting; trace only) |
| `--no-fold` | keep constant folding off in the offline runtime |
| `--max-runs` / `--devirt-rounds` | cap trace replays / lift rounds (defaults 12 / 200) |
| `--keep-harness` / `--keep-preamble` | keep build artifacts for debugging |
| `--cfg-json <json\|@file>` / `--executor <name>` / `--loop-fuel` / `--spin-fuel` / `--prelude-file` / `--input-text` | sandbox controls used when a sample needs a specific host behaviour |
| `--no-dce` / `--ai-provider` / `--ai-model` | Layer-2 controls (the AI path is optional and off by default) |
| `--studio [--studio-port <n>] [--studio-wait <sec>]` | trace inside a real Roblox place instead of the offline sandbox (see [Online runs](#online-runs)) |
| `--no-format` | do not run the result through StyLua (see [Formatting](#formatting)) |

A Luraph run costs roughly one sandbox execution per lifting round: a 1 MB file
takes about a minute on a laptop, a 1.6 MB sample 73 s on the reference machine.

---

## Online runs

The offline sandbox is a Lua 5.3 VM plus `runtime/roblox_api.luau`, a hand-written
approximation of the engine. That approximation is where the coverage stops: a
sample that asks for a DataModel the sandbox does not model, or reads a property
whose type the API dump only half-describes, branches into a path a real place
would not take. `--studio` removes the approximation — the recorded run happens
inside Roblox Studio, on the real engine, and only the *recording* comes back
here.

```bash
node deob.js protected.lua -o out.lua --studio
```

1. The engine starts a small HTTP bridge on `127.0.0.1:34880`
   (`--studio-port`) and prints the path of the loader it wrote next to the input:
   `protected.deobf.studio_loader.luau`.
2. Open the place the sample belongs in, in **Studio, Edit mode**, and paste that
   file into the **command bar**. It needs no script to be added to the place.
3. The loader pulls each harness from the bridge, runs it natively, and posts the
   trace back. The engine lifts from that trace exactly as it does offline, so the
   result is the same kind of file — everything after the trace is unchanged.
4. It stops when the bridge closes (the command bar prints `deobf: done`). The
   engine waits `--studio-wait` seconds per run (default: the `--timeout` value);
   a run with no answer fails that run instead of hanging.

What `--studio` actually buys is fidelity, not more code: real Instances, real
datatypes, real `game:HttpGet` traffic, real `require` of the hub's own modules.
A sample that only needs the VM (the common case) traces identically either way —
see [`TECHNICAL.md` §6](TECHNICAL.md#6-online-runs) for the measured difference.

Studio gives the loader `HttpService` for the duration of the bridge and turns it
back off around each harness, so the harness sees the place's own setting. A
truncated read (`HttpService` is capped) is part of the record, not an error.

---

## Formatting

Every result is printed through [StyLua](https://github.com/JohnnyMorganz/StyLua)
before it is written — the same formatter GitHub's "Format with StyLua" action
runs — so the file opens already laid out: tabs, one statement per line, table and
call arguments wrapped at 100 columns, quotes normalised. The renamed copy from
`--rename` and the renamer's own CLI go through the same pass, so both copies of a
script match.

* The settings live in `node/format.js` and are mirrored in `.stylua.toml`, so an
  editor or a `stylua` on `PATH` formats the same way the engine does.
* StyLua is run to a fixed point (at most 4 passes): formatting is stable, and
  formatting a result a second time moves no bytes.
* The formatted text is parsed before it replaces the result. If it does not
  parse, or if StyLua is not installed, the run keeps its own layout and the
  report says why (`format.skipped`) — a formatting miss never costs a result.
* Turn it off with `--no-format` (or the renamer's `--no-format`); the report then
  records `format: { tool: "stylua", changed: false, skipped: "disabled" }`.

The report carries `format: { tool, changed, passes? }` next to `trace_status`.

---

## Output

Every result starts with the author's `-- This Source Was Generated by ...`
line and carries exactly one `print("Deobf By Zed")`; a lifted result is checked
to parse as Luau before it is written. The attribution is the **first line of
the file**, because a comment dropped somewhere inside a function body is our
text in the middle of the code we recovered — and it made two runs over one
input differ whenever a diagnostic string changed.

Output is **deterministic**: the same input and flags produce the same bytes,
on any machine. The diagnostic text that ends up in the file (`-- devirt: ...`)
is formatted from the input alone, so no allocation address can reach it.

A **behaviour trace** (used when a lift is unavailable, or requested with
`--no-devirt`) says so in its own header. It records values as the run observed
them, so `local x = 1; print(x)` traces as `print(1)`; that is useful, and it is
not a reconstructed script. The report's `result_type` is `trace`, never
`devirtualized`.

What a run cannot recover stays visible instead of being invented:
`nil --[[ constant not decoded ]]`, `-- devirt: ...` notes, and an
`-- unresolved:` header when names are missing. `TECHNICAL.md` lists the two
holes that are still open in the reference sample, with the numbers behind them.

`dev/scripts/metrics.py` prints the numbers used in a report:

```bash
python3 dev/scripts/metrics.py out.lua other.lua
```

---

## Layout

```text
DeobfLuraph/
├── deob.js                 # CLI: single file, or a folder processed recursively
├── engine/                 # Python: the deobfuscation engine
│   ├── obfuscators/        # one folder per protected format
│   │   ├── luraph_v15/     # Luraph v15.0 / v15.1  <- the main engine
│   │   │   ├── driver.py   # sandbox run + devirt rounds
│   │   │   ├── stepper.py  # the recorded instruction stepper
│   │   │   ├── vm_model.py # decodes instruction cells back to operations
│   │   │   ├── lifter.py   # CFG + statement lifting
│   │   │   ├── dataflow.py # dataflow recovery for the lifted body
│   │   │   ├── dump.py     # dump protocol (proto -> JSON)
│   │   │   ├── patches.py  # targeted fixes for known VM shapes
│   │   │   └── vmmap.py    # VM dispatch map recovery
│   │   ├── luraph_v14/     # Luraph v14.7 - v14.9 (devirt, driver, vmmap)
│   │   ├── luarmor/        # Luarmor v4 client chain (probe, stub, analyze)
│   │   ├── base.py         # plugin interface
│   │   └── __init__.py     # plugin registry (PLUGINS)
│   ├── backend.py          # the lowering pipeline, in order
│   ├── ir.py / luasym.py   # IR values and symbolic expressions
│   ├── structure.py        # CFG structuring, guard/trap pruning, poisoning
│   ├── loops.py            # Loop recognition
│   ├── variables.py        # SSA webs, frame propagation, naming input
│   ├── names.py            # Context-aware identifier naming
│   ├── namesplit.py / localfuncs.py / deadline.py / deadstore.py
│   ├── idioms.py           # Idiom folding (table.move, SETLIST, chains)
│   ├── flatten.py          # Unrolls constant-state dispatch loops
│   ├── bitfold.py / u32fold.py / copies.py / seeds.py / spacing.py
│   ├── ast_polish.py       # Source cleanup after printing
│   ├── codegen.py          # Luau emitter
│   ├── luauast.py          # Luau AST -> text
│   ├── carrier.py          # payload extraction from a host file
│   └── harness.py / tidy.py / traceout.py
├── node/                   # Node: detection, sandbox, formatting, CLI glue
│   ├── detect.js           # Signature / structural detector
│   ├── driver.js           # Luraph v15: sandbox run + devirt bridge
│   ├── engines.js          # Engine dispatch (Luraph v14) and refusals
│   ├── luarmor.js          # Luarmor chain analysis + report
│   ├── harness.js          # Offline Roblox sandbox builder
│   ├── devirt_bridge.py    # JSON bridge between Node and the Python lifters
│   ├── format.js           # StyLua pass, applied to every result
│   ├── watermark.js        # Attribution comment + `print("Deobf By Zed")`
│   ├── luau_check.js       # Syntax gate on `bin/luau-ast`
│   └── vmmap.js / traceout.js / pyenv.js / tidy.js
├── runtime/                # Offline Roblox VM + environment (Luau)
├── renamer/                # Optional `--rename` pass (scope-verified renamer)
├── bin/                    # luau, luau-ast (native; .exe for Windows)
├── results/                # Deobfuscated output + its report
├── dev/                    # Development only -- nothing here ships or runs in a lift
│   ├── test/               # node:test suites + golden.json (pinned output)
│   ├── scripts/            # gates: luac, freevars, smoke, fixtures, golden
│   ├── fixtures/           # manifest.json + input/ (downloaded, gitignored)
│   └── build_luau.py       # builds bin/luau from upstream source
├── .github/workflows/ci.yml
├── TECHNICAL.md            # How the lift works, what is checked, what is missing
└── package.json
```

## Tests

```bash
npm test                  # syntax gate + unit suites (no fixtures needed)
npm run fixtures          # download + verify the pinned samples (9 MB, needs network)
npm run test:e2e          # golden regression over dev/fixtures/input, run twice each
npm run test:all          # everything
```

`dev/test/golden.json` is a table of exact outputs (sha256, md5, line count, lifted
function count) for the fast fixture tier. Because the engine is deterministic,
a row is a fact rather than an opinion: a change either moves a byte or it does
not. Regenerate it only for an intended change, in the same commit as the
engine change:

```bash
node dev/scripts/update-golden.js --tier core     # or --tier all
```

Fixtures are third-party files and are never committed. `dev/fixtures/manifest.json`
pins each one by repository, path, blob id, size and sha256; the fetcher
verifies all of that before a file is written, and `fixtures:verify` re-hashes
what is already on disk. Behind a TLS-inspecting proxy (or offline), import
copies you already have:

```bash
node dev/scripts/fixtures.js fetch --from ~/samples
```

CI runs the syntax gate and unit suites on Node 18/20/22, then the golden
regression on Node 20.

`dev/scripts/metrics.py` measures a result rather than describing it: lines, syntax,
devirt markers, unresolved captures, bit32 chains — and how much of the code is
still built from placeholder names (`value12`, `argument2`, `iterator3`):

```bash
python3 dev/scripts/metrics.py out.lua other.lua
```

That last number (`placeholder_pct`, currently 57–67% of non-blank lines on the
large samples) is the readability measurement. It is printed, not asserted, so a
future change has to argue with a number instead of an impression.

License: MIT.
