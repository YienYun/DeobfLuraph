# Luraph public-sample smoke test

Regenerated **2026-11-04** with the engine in this commit, after the
determinism and attribution fixes: the credit line is now the first line of every
result, and no diagnostic can carry a memory address. Every row is reproducible
from the pinned input and the flags shown; the fast-tier subset is additionally
pinned byte-for-byte in `test/golden.json`.

Inputs are third-party files and are **not** stored in this repository.
`fixtures/manifest.json` pins each one by repository, path, blob id, size and
sha256; `node scripts/fixtures.js fetch` retrieves and verifies them.

| Sample (source Git blob) | Output | Outcome | Flags |
|---|---|---|---|
| [v14.8/0942aaa445539073.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v14.8/0942aaa445539073.lua) `d428c5a6…` | [`Luraph_v14.8_0942aaa445539073.deobf.luau`](Luraph_v14.8_0942aaa445539073.deobf.luau) | **Devirtualized, finished** — 976 lines, 27 functions, 0 unlifted blocks, 0 unstructured jumps. The 976-line baseline is unchanged by the fixes. | `--budget 30 --timeout 45` |
| [v14.8/cd666dfb20c03439.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v14.8/cd666dfb20c03439.lua) `d45584a3…` | [`Luraph_v14.8_cd666dfb20c03439.deobf.luau`](Luraph_v14.8_cd666dfb20c03439.deobf.luau) | **Trace only** — 104 statements, 219 lines. The outer file is a decompressor, not a VM: the payload arrives through `loadstring` and then aborts with `endless loop in the script's own code (no environment access)`. Reported as a trace, with the trace header saying so. | `--budget 30 --timeout 45` |
| [v14.8/e81607b826471087.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v14.8/e81607b826471087.lua) `40eb4636…` | [`Luraph_v14.8_e81607b826471087.deobf.luau`](Luraph_v14.8_e81607b826471087.deobf.luau) | **Partial** — 12 functions lifted into 7 lines; the run stops at `No key provided or invalid`, so the output is the bootstrap, not the decrypted payload. | `--budget 30 --timeout 45` |
| [v14.9/e462eaaccbac09b0.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v14.9/e462eaaccbac09b0.lua) `79df2d5c…` | No output (refused) | **Refused, honestly** — the mapper finds no dispatch loop in the outer file and a 25 s behaviour trace records nothing. The CLI says exactly that instead of writing an empty or traced-at-random file. | `--budget 15 --timeout 25` |
| [v15.0/5ae248d6527b5c01.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v15.0/5ae248d6527b5c01.lua) `3b2dfe1f…` | [`Luraph_v15.0_5ae248d6527b5c01.deobf.luau`](Luraph_v15.0_5ae248d6527b5c01.deobf.luau) | **Devirtualized, finished** — 4 lines, 1 function; recovers `print("hello")`. | `--budget 20 --timeout 45` |
| [v15.0/392628e9da400b8a.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v15.0/392628e9da400b8a.lua) `3e66fead…` | [`Luraph_v15.0_392628e9da400b8a.deobf.luau`](Luraph_v15.0_392628e9da400b8a.deobf.luau) | **Trace only** — 14 lines; the run dies on `attempt to call missing method 'pW'`, so no function is lifted and the result is labelled a trace. | `--budget 20 --timeout 45` |
| [v15.0/f44daa11fdc2663b.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v15.0/f44daa11fdc2663b.lua) `96451c4e…` | [`Luraph_v15.0_f44daa11fdc2663b.deobf.luau`](Luraph_v15.0_f44daa11fdc2663b.deobf.luau) | **Partial devirtualization** — 2,404 lines, 28 functions, 0 unlifted blocks; the run ends on `nil + number` with 192 residual unknown frame reads. | `--budget 20 --timeout 40 --max-runs 2` |
| [v15.1/2153b779fa7a87f2.lua](https://github.com/terrorlua/obfuscator-samples/blob/main/Luraph/v15.1/2153b779fa7a87f2.lua) `b252ab03…` | [`Luraph_v15.1_2153b779fa7a87f2.deobf.luau`](Luraph_v15.1_2153b779fa7a87f2.deobf.luau) | **Devirtualized, finished** — 15 lines, 3 functions. | `--budget 25 --timeout 45` |
| [LphV14/dSAjehr43.lua](https://github.com/YienYun/Luraph/blob/main/SampleLuraph/LphV14/dSAjehr43.lua) `e57349c3…` | [`Luraph_v14_dSAjehr43.deobf.luau`](Luraph_v14_dSAjehr43.deobf.luau) | **Partial devirtualization** — 1,644 lines, 27 functions, 0 unlifted blocks; two unresolved-capture headers remain and the trace ends with the no-progress endless-loop status. | `--budget 30 --timeout 60` |

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
