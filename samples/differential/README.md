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
the time of the `v0.5-p4-callee-slot` milestone, so the claim can be checked
without rebuilding anything.

## Expected results at v0.5 (`678ff63`, tag `v0.5-p4-callee-slot`)

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
