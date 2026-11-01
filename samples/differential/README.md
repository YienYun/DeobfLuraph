# Differential fixtures

Two real Luraph v15 samples kept in the repository so a change can be checked
from outside the sandbox it was measured in: each directory holds the
**input** (the protected file) and the **output** this engine produces.

| Fixture | Input | Output |
|---|---|---|
| `RideAPet/` | 331 KB | 321 KB |
| `StealAnEgg/` | 622 KB | 1.61 MB |

Both inputs are third-party scripts recovered from this repository's own
history; they are test material only.

## Reproduce

```bash
node deob.js samples/differential/RideAPet/input.lua   -o /tmp/pet.lua
node deob.js samples/differential/StealAnEgg/input.lua -o /tmp/egg.lua

cmp /tmp/pet.lua samples/differential/RideAPet/output.lua   # must be identical
cmp /tmp/egg.lua samples/differential/StealAnEgg/output.lua  # must be identical
```

Byte-identical is the bar: these two files are the record of what the engine
prints today. If a change moves them, the output in the repository is updated in
the same commit and the reason is in `TECHNICAL.md`.

`diff-from-baseline.diff` in each directory shows every line that differs from
the oldest recorded output of that fixture (`--label` headers, no timestamps, so
the file itself does not churn). It is a ledger, not a claim: read the top of
each hunk to see why a line moved.

## Current numbers

```bash
python3 scripts/metrics.py samples/differential/*/output.lua
```

| | RideAPet | StealAnEgg |
|---|---|---|
| lines | 10,223 | 50,418 |
| parses | yes | yes |
| `devirt_errors` | 0 | 0 |
| `unresolved_uses` | 0 | 0 |
| `bit32_calls` | 430 | 74 |
| `bit32_chain_lines` | 15 | 5 |
| `blank_lines` | 1,025 | 5,613 |
| run report | `bound=0 residual_unknown=22 unknown_callee=0` | `bound=0 residual_unknown=116 unknown_callee=0` |

`unknown_callee=0` on both is the check that the poisoning pass does not fire
where every callee register has a definition: it only removes calls that could
never have run.

Both inputs are deterministic — running either one twice gives byte-identical
output.
