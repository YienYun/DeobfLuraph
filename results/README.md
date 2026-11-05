# Results

**Empty on purpose.** Every result that used to live here was produced before the
engine could prove it was right about the script and not only about the wrapper,
so they were withdrawn rather than left around to be mistaken for a reference.
The directory fills up again once a run passes the two gates below and the
output is read end to end.

## What goes here

| Path | What it is |
|---|---|
| `*.deobf.luau` | result of a run over a pinned sample (`fixtures/manifest.json`), together with its `*.report.json` |
| `*.report.json` | sidecar: `output_sha256`, `result_type`, lift stats, warnings, and the `chain`/`luarmor` blocks when the run chained into the Luarmor track |
| `*.renamed.luau` | the same result after Layer 2 (`node renamer/index.js`), plus its `*.rename.json` sidecar: names, comments, dead lines |
| `*.luarmor.json` | sidecar from the Luarmor analyzer: kind, module id, cache key, client tag, build stamp, key link, endpoints |
| `Luraph-public-sample-smoke-test.md` | the table those runs add up to, with the flags each one used |

`FreemiumLoader.*` and `Library-obfuscated.*` are a live test, not pinned
fixtures: the first is `gather1231-source/Freemium/FreemiumLoader` (Luraph v15.1,
319,924 B) and the second is `tienkhanh1/spicy/Library (2)-obfuscated.lua` (v15.0,
183,544 B), both fetched by blob sha from GitHub on 2026-11-05 and written with
`node deob.js <file> -o results/<name>.deobf.luau --report ...`. They are kept
next to the pinned results because they are the two files a real user handed us.

`FreemiumLoader` is also the regression this tree was built around: the lift used
to emit `data = string` and then write the whitelist into it, which Luau freezes,
so the output died at line 27 with `attempt to modify a readonly table`. The
read-only rewrite in `core/ast_polish.py` now materializes that table and says so
in a `-- devirt:` note; the run finishes, and the report keeps the warning that
it happened.

`Chilli_StealAnEggg.*` is a carrier sample, not a lift: the v15.1 loader holds the
script as a function field, and what it holds is the script itself in plain Luau
-- not a Luarmor stub. The Luarmor url in its header is the key system it asks
for later, and the code at that url is not in this file. It still says
`-- deobf: needs the hub at run time`, because the script calls helpers the hub
hands it (`H2`, `g2`, `[72]`); that marker is why the runtime gate expects it to
stop at that message instead of finishing.

Three rules for this directory:

1. **Every `.deobf.luau` has a `.report.json` next to it**, and the report's
   `output_sha256` matches the file. A result without its report is not evidence
   of anything and does not belong here.
2. **Nothing here is hand-edited.** If a result is stale, regenerate it; do not
   patch it.
3. **A file only lands here after the gates pass**: `npm test` (which runs the
   Luau compile gate over this directory) and `node scripts/freevars.js results`
   (no undeclared register reads).

## Samples that cannot be lifted

`fixtures/input/392628e9da400b8a.lua` (Luraph v15.0, `t15-0-392628`) is a pinned
sample that produces a trace, and the trace stops on

```
Script:3: attempt to call missing method 'pW' of table
```

That is not the sandbox failing to answer a proxy: the file itself ends with
`setmetatable({...}, {}):pW()(...)`, and the table literal it builds defines 310
named plus 141 integer keys -- none of them `pW`. Nothing in the file defines the
name (checked textually and by the report's `diagnosis` field), and it reads 129
globals it never sets (free globals such as `C`, `z`, `EVEDGU`, `ELW29`), so the
payload it decodes is split across chunks that this capture does not contain.
Vanilla Luau agrees: `bin/luau` stops on the same line with
`attempt to index nil with 'IFKI'`. The capture is incomplete, so it is filed as
such instead of being counted as a hole in the emulation.

## Regenerating an entry

```bash
node scripts/fixtures.js fetch
node deob.js fixtures/input/0942aaa445539073.lua \
  -o results/Luraph_v14.8_0942aaa445539073.deobf.luau \
  --report results/Luraph_v14.8_0942aaa445539073.report.json \
  --budget 30 --timeout 45
node scripts/luac.js results && node scripts/freevars.js results
```

The fast-tier subset is also pinned in `test/golden.json`, so a change that
moves those bytes fails `npm run test:e2e` whether or not this directory is
regenerated.

`result_type` in the report says what the file is: `devirtualized` (lifted from
the VM), `payload-source` (printed from the source the loader carries),
`trace`, or a `luarmor-*` state. A `payload-source` result and a `devirtualized`
one are different claims about the same input; do not read one as the other.
