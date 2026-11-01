# Differential fixtures

Two real Luraph v15 samples kept in the repository so that a behavioural change
can be audited from outside the sandbox it was measured in. `samples/input/`
stays local-only (it is re-uploaded often and can be large); this directory is a
deliberate, small exception: each fixture is the exact pair a differential claim
is made about, and it never changes except when a milestone changes its output.

| fixture | input | output | size |
|---|---|---|---|
| `RideAPet/` | `input.lua` | `output.lua` | 331 KB / 321 KB |
| `StealAnEgg/` | `input.lua` | `output.lua` | 622 KB / 1.61 MB |

Provenance: both inputs were recovered from this repository's own history --
`RideAPet/input.lua` from blob `71a9b6d`, `StealAnEgg/input.lua` from blob
`8d64af1`. They are third-party scripts used only as test material.

## Reproducing a differential

```sh
# the build being audited
node deob.js samples/differential/RideAPet/input.lua   -o /tmp/pet.lua
node deob.js samples/differential/StealAnEgg/input.lua -o /tmp/egg.lua

# the baseline every `diff-from-v0.4.diff` was taken against
git worktree add /tmp/v04 v0.4-p4-spin-holes
(cd /tmp/v04 && node deob.js samples/differential/RideAPet/input.lua   -o /tmp/pet_old.lua)
(cd /tmp/v04 && node deob.js samples/differential/StealAnEgg/input.lua -o /tmp/egg_old.lua)

cmp /tmp/pet.lua samples/differential/RideAPet/output.lua      # expected: identical
diff -u /tmp/pet_old.lua samples/differential/RideAPet/output.lua
diff -u /tmp/egg_old.lua samples/differential/StealAnEgg/output.lua
```

`diff-from-v0.4.diff` in each directory is exactly the last command's output at
the time of the category W milestone (`v0.6` second commit, recorded in
`TECHNICAL.md` §12; no tag until the audit passes), with `--label` headers so the
file does not churn with timestamps, so the claim can be checked without
rebuilding anything. It still starts at `v0.4-p4-spin-holes`, so it
carries the v0.5 ledger plus the v0.6 renames; each later section says which part
is new.

## Expected results at v0.6, category X (`1354e1e`)

The first v0.6 commit named the shadowed duplicate of a `local` declaration `_`:
3 declarations in `RideAPet`, 21 in `StealAnEgg`, 22 in `SampleV1`, 0 skipped.
The mechanical check is that applying only
`core/namesplit.py::apply_duplicates` to the previous committed output reproduces
that commit's file byte for byte, apart from the attribution comment.

## Expected results at v0.6, category W (this commit, no tag until the audit passes)

The second v0.6 commit splits a printed name that a closure and a later value
share: 13 sites in `RideAPet`, 38 in `StealAnEgg` (43 in `SampleV1`, which has no
differential fixture), all split, none skipped. The mechanical check is that
applying only `apply_duplicates` and `apply_reuse` to a `DEVIRT_NO_NAMESPLIT`
build of the same input reproduces the shipped file, apart from the attribution
comment's line and the blank lines the following `localfuncs` tidy re-derives
from the shifted text (net +1 in `StealAnEgg`, none in `RideAPet`).

`RideAPet` -- 40 hunks, 100 removed / 104 added lines against v0.4: 3 duplicate
declarations named `_`, 96 renamed lines in the 13 category W sites, 4 new
`local name_2` lines, and the attribution comment moving. Metrics: lines 10,223,
bytes 328,747, parses True, `bit32_calls` 430, `bit32_chain_lines` 15, blank
1,025, `frame_propagation: bound=0 residual_unknown=22`.

`StealAnEgg` -- 97 hunks, 296 removed / 318 added. It contains the v0.5 ledger
unchanged (watermark, 95 renumbering twins, 6 removed / 12 added substantive
lines in the WebSocket connect block), 21 duplicate declarations named `_`, 173
renamed lines in the 38 category W sites, 16 new `local name_2` lines, one blank
line and the comment's new line. Metrics: lines 50,418, bytes 1,686,933, parses
True, `devirt_comments` 4, `(nil)(...)` 0, `bit32_calls` 74, blank 5,613,
`frame_propagation: bound=0 residual_unknown=116`.

Both outputs are deterministic: running either input twice gives byte-identical
files.

## Expected results at v0.5 (`6c45797`, tag `v0.5-p4-callee-slot`)

`RideAPet` -- **no diff** (`diff-from-v0.4.diff` is empty): the callee-slot fix
does not fire on this input (no `[jread]` line in the run log), and the output is
byte-identical to `v0.4-p4-spin-holes`. Metrics of `RideAPet/output.lua`:
lines 10,219, bytes 328,421, parses True, devirt_errors 0, devirt_comments 0,
unresolved 0/0/0, bit32_calls 430, bit32_chain_lines 15, blank_lines 1,025,
`frame_propagation: bound=0 residual_unknown=22`.

`StealAnEgg` -- 25 hunks, 102 removed / 110 added lines, ledger in
`diff-from-v0.4.diff`: 1 watermark comment moved (line 4 -> line 3229), 95
renumbering twins (identifier-only matches), 0 removed / 2 added blank lines, and
6 removed / 12 added substantive lines -- the WebSocket connect block (`pcall`,
`OnMessage`/`OnClose`/`OnError` registrations, the attempt counter). Metrics:
lines 50,401, parses True, devirt_errors 0, devirt_comments 4,
`(nil)(... )` 3 -> 0, bit32 metrics unchanged, blank_lines 5,612,
`frame_propagation: bound=0 residual_unknown=116`.

Both outputs are deterministic: running either input twice gives byte-identical
files.
