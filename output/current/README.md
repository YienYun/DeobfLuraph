# Delivered outputs

The two scripts this engine is judged on, deobfuscated and **committed on
purpose**: every number in `TECHNICAL.md` and every claim about "the same
input gives the same file" has to stay checkable against the exact bytes it was
measured on. Regenerating them overwrites the reference, so a change in the
output is a change in the diff, not a claim in a chat.

| file | lines | how it was produced |
|---|---|---|
| `RideAPet.luau` | 11,034 | `node deob.js dev/fixtures/input/RideAPet.lua -o output/current/RideAPet.luau --exec-rec` |
| `StealAnEggg.luau` | 37,563 | same command on `StealAnEggg.lua`; `payload-source` (the loader carries the script as plain Luau) |
| `RideAPet-cache.luau` | 4,829 | same, plus `--http-cache dev/fixtures/input/http` (the experiment that did **not** pay off, kept for the comparison in TECHNICAL.md §3) |
| `StealAnEggg.luarmor.json` | — | written next to the output by the Luarmor track |

Inputs (not committed, fetched by `node dev/scripts/fixtures.js`):

| fixture | sha256 |
|---|---|
| `lph-v15-1-rideapet` (`RideAPet`, 338,756 B) | `14cd35cc227c94f314b789c2c0cc2afa40b780754262f3017d9aaf65c2660a79` |
| `lph-v15-1-stealaneggg` (`StealAnEggg`, 529,242 B) | `41b5de74cc0fc687a884829357f2a7caf68d5b3519c9f30e1276e2698fdcd9ae` |

Checks that hold for both (run them yourself):

```
node dev/scripts/luac.js output/current/RideAPet.luau      # 1 compiled, 0 failed
node dev/scripts/freevars.js output/current/RideAPet.luau  # 0 unresolved register reads
node deob.js dev/fixtures/input/RideAPet.lua -o /tmp/again.luau --exec-rec
diff output/current/RideAPet.luau /tmp/again.luau          # identical
```

These files are other people's code (Chilli Hub, `tienkhanh1/Chilli-Hub-Script`),
kept as the measurement targets of this engine, exactly like `results/` already
keeps the earlier Chilli artifact.
