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
| `*.report.json` | sidecar: `output_sha256`, `result_type`, lift stats, warnings |
| `Luraph-public-sample-smoke-test.md` | the table those runs add up to, with the flags each one used |

`Chilli_StealAnEggg.*` is a carrier sample, not a lift: the v15.1 loader holds the
script as a function field and what it holds is a Luarmor v4 client stub, so the
file is the stub in source form. Its header names the endpoint the real script is
fetched from; it says `-- deobf: needs the hub at run time`, which is why the
runtime gate expects it to stop at that message instead of finishing.

Three rules for this directory:

1. **Every `.deobf.luau` has a `.report.json` next to it**, and the report's
   `output_sha256` matches the file. A result without its report is not evidence
   of anything and does not belong here.
2. **Nothing here is hand-edited.** If a result is stale, regenerate it; do not
   patch it.
3. **A file only lands here after the gates pass**: `npm test` (which runs the
   Luau compile gate over this directory) and `node scripts/freevars.js results`
   (no undeclared register reads).

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
