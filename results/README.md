# Results

What lives here, and where it came from.

| Path | What it is |
|---|---|
| `*.deobf.luau` | result of a run over a pinned sample (`fixtures/manifest.json`), together with its `*.report.json` |
| `Luraph-public-sample-smoke-test.md` | the table those runs add up to, with the flags each one used |
| `RideAPet.lua`, `StealAnEggg.lua` | larger curated deobfuscations kept as readability references |

Two rules for this directory:

1. **Every `.deobf.luau` has a `.report.json` next to it**, and the report's
   `output_sha256` matches the file. A result without its report is not evidence
   of anything and does not belong here.
2. **Nothing here is hand-edited.** If a result is stale, regenerate it; do not
   patch it. The pinned inputs and flags are in the smoke-test table.

The reference files (`RideAPet.lua`, `StealAnEggg.lua`) are **not** output of the
current engine and are not covered by `test/golden.json`. They are the target
the naming work is measured against: semantic identifiers (`compileChunk`,
`uiLibrary`, `mainWindow`, `activeCells`) instead of `value12` / `callback3`.
Treat them as a goal, not as a verified artefact.

## Regenerating an entry

```bash
node scripts/fixtures.js fetch --tier full
node deob.js fixtures/input/0942aaa445539073.lua \
  -o results/Luraph_v14.8_0942aaa445539073.deobf.luau \
  --report results/Luraph_v14.8_0942aaa445539073.report.json \
  --budget 30 --timeout 45
```

The fast-tier subset is also pinned in `test/golden.json`, so a change that
moves those bytes fails `npm run test:e2e` whether or not this directory is
regenerated.
