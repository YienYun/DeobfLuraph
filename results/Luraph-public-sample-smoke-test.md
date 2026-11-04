# Luraph public-sample smoke test

Regenerated **2026-11-04** with the engine in this commit, after the flattening
pass and after the self-referential-initialiser fix in §3: constant-state dispatch loops are unrolled into the code they really run,
and the v15 lifter no longer aborts on a proto whose execution coverage was never
recorded (`exec_cov`), which had made `f44daa` unreproducible. Two v15 stress
samples from the benchmark repository were added, and the per-proto lift
allowance is now proportional to the build instead of a flat 45 s. Every row is reproducible
from the pinned input and the flags shown; the fast-tier subset is additionally
pinned byte-for-byte in `test/golden.json`.

Inputs are third-party files and are **not** stored in this repository.
`fixtures/manifest.json` pins each one by repository, path, blob id, size and
sha256; `node scripts/fixtures.js fetch` retrieves and verifies them.

| Sample (source Git blob) | Output | Outcome | Flags |
|---|---|---|---|
| [v14.8/0942aaa445539073.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v14.8/0942aaa445539073.lua) `d428c5a6…` | [`Luraph_v14.8_0942aaa445539073.deobf.luau`](Luraph_v14.8_0942aaa445539073.deobf.luau) | **Devirtualized, finished** — 738 lines, 15 functions, 0 unlifted blocks, 0 unstructured jumps. The dispatch loops are unrolled, which is 238 lines of flattened control flow gone; the logic they hid is now straight-line code. | `--budget 30 --timeout 45` |
| [v14.8/cd666dfb20c03439.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v14.8/cd666dfb20c03439.lua) `d45584a3…` | [`Luraph_v14.8_cd666dfb20c03439.deobf.luau`](Luraph_v14.8_cd666dfb20c03439.deobf.luau) | **Trace only** — 104 statements, 219 lines. The outer file is a decompressor, not a VM: the payload arrives through `loadstring` and then aborts with `endless loop in the script's own code (no environment access)`. Reported as a trace, with the trace header saying so. | `--budget 30 --timeout 45` |
| [v14.8/e81607b826471087.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v14.8/e81607b826471087.lua) `40eb4636…` | [`Luraph_v14.8_e81607b826471087.deobf.luau`](Luraph_v14.8_e81607b826471087.deobf.luau) | **Partial** — 12 functions lifted into 8 lines; the run stops at `No key provided or invalid`, so the output is the bootstrap, not the decrypted payload. | `--budget 30 --timeout 45` |
| [v14.9/e462eaaccbac09b0.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v14.9/e462eaaccbac09b0.lua) `79df2d5c…` | No output (refused) | **Refused, honestly** — the mapper finds no dispatch loop in the outer file and a 25 s behaviour trace records nothing. The CLI says exactly that instead of writing an empty or traced-at-random file. | `--budget 15 --timeout 25` |
| [v15.0/5ae248d6527b5c01.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v15.0/5ae248d6527b5c01.lua) `3b2dfe1f…` | [`Luraph_v15.0_5ae248d6527b5c01.deobf.luau`](Luraph_v15.0_5ae248d6527b5c01.deobf.luau) | **Devirtualized, finished** — 4 lines, 1 function; recovers `print("hello")`. | `--budget 20 --timeout 45` |
| [v15.0/392628e9da400b8a.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v15.0/392628e9da400b8a.lua) `3e66fead…` | [`Luraph_v15.0_392628e9da400b8a.deobf.luau`](Luraph_v15.0_392628e9da400b8a.deobf.luau) | **Trace only** — 14 lines; the run dies on `attempt to call missing method 'pW'`, so no function is lifted and the result is labelled a trace. | `--budget 20 --timeout 45` |
| [v15.0/f44daa11fdc2663b.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v15.0/f44daa11fdc2663b.lua) `96451c4e…` | [`Luraph_v15.0_f44daa11fdc2663b.deobf.luau`](Luraph_v15.0_f44daa11fdc2663b.deobf.luau) | **Partial devirtualization** — 2,337 lines, 28 functions, 0 unlifted blocks; the run ends on `nil + number` with 194 residual unknown frame reads. | `--budget 20 --timeout 40 --max-runs 2` |
| [v15.1/2153b779fa7a87f2.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v15.1/2153b779fa7a87f2.lua) `b252ab03…` | [`Luraph_v15.1_2153b779fa7a87f2.deobf.luau`](Luraph_v15.1_2153b779fa7a87f2.deobf.luau) | **Devirtualized, finished** — 15 lines, 3 functions. | `--budget 25 --timeout 45` |
| [LphV14/dSAjehr43.lua](https://github.com/YienYun/Luraph/blob/main/SampleLuraph/LphV14/dSAjehr43.lua) `e57349c3…` | [`Luraph_v14_dSAjehr43.deobf.luau`](Luraph_v14_dSAjehr43.deobf.luau) | **Partial devirtualization** — 1,522 lines, 19 functions, 0 unlifted blocks; two unresolved-capture headers remain and the trace ends with the no-progress endless-loop status. | `--budget 30 --timeout 60` |

| [Chilli-Hub-Script/StealAnEggg](https://github.com/tienkhanh1/Chilli-Hub-Script/blob/main/StealAnEggg) `1b8b333d…` (pinned as `lph-v15-1-5`) | [`Luraph_v15.1_Lph5-V15.1.deobf.luau`](Luraph_v15.1_Lph5-V15.1.deobf.luau) | **Script source recovered** — 28,537 lines, 2,190 functions, 0 unlifted, 0 unstructured, 0 free registers. The loader carries the Steal-An-Egg script as plain Luau in one field of its table (field `114`, 477 script-shaped reads against 68 for the next), so it is printed rather than lifted: `:FireServer`, `Humanoid`, `workspace`, the egg/area logic and the hub's own `Window`/`Tab`/`Notify` calls all come out as written (`result_type: payload-source`). The same file also virtualizes the hub library (5,055 lines, ChilliLibrary UI) — `DEVIRT_PREFER_VM=1` lifts that half instead. | `--budget 60 --timeout 120` |
| [LphV15/Lph6-V15.0.lua](https://github.com/YienYun/Luraph/blob/main/SampleLuraph/LphV15/Lph6-V15.0.lua) `76bc2b3e…` | [`Luraph_v15.0_Lph6-V15.0.deobf.luau`](Luraph_v15.0_Lph6-V15.0.deobf.luau) | **Devirtualized, finished** — 9,702 lines, 766 functions, 0 unlifted blocks, 0 unstructured jumps, 185 residual unknown frame reads. The largest build in the set; it needs ~72 s of lifting, which the old flat 45 s per-proto allowance refused. | `--budget 60 --timeout 120` |

Notes that the table cannot show:

* **Every success above is deterministic.** Running the same input with the same
  flags twice produces identical bytes; `test/e2e.test.js` asserts that on the
  fast tier.
* **A trace is not source.** Where the row says *trace only*, the file records
  what the run observed at each step (a value computed at run time appears as its
  result). It says so in its header and the report says `result_type: trace`.
* **A refusal is a result too.** `e462` gets no file because nothing honest could
  be written for it; the CLI explains which two things it could have been (an
  out-of-range build, or a carrier whose payload never arrived).
* The known gaps — the dropped call at `pc=50`, the partly lifted UI region — are
  documented with their numbers in [`../TECHNICAL.md`](../TECHNICAL.md) §3.
* **The lift allowance is proportional, not flat.** One root proto may take
  `2 × captured protos` seconds, floored at 60 s and capped at 900 s
  (`DEVIRT_PROTO_SECONDS` overrides it). A flat 45 s used to reject `Lph6` — a
  single payload proto with 766 functions — after the walk had already finished
  the work; it now lifts in ~72 s and is reported honestly either way.
* **Every file here compiles.** `node scripts/luac.js results/*.luau` feeds each
  output to the Luau compiler (`loadstring` in `bin/luau`) and fails on the first
  syntax error; `npm test` runs it over the committed results.
* **No file here reads an undeclared register.** `node scripts/freevars.js
  results/*.luau` parses each output with `bin/luau-ast` and lists every
  identifier that is read but never declared. Register names (`r4`, `r34`) count
  as a hole and fail the check; unknown globals (`syn`, `fluxus`, `Webhook`) are
  reported as notes, because those belong to the executor or the payload.
  `Lph6` is the only row with notes left (7 of them) and zero holes.
