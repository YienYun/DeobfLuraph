# Delivered outputs

Every script the Chilli hub ships, deobfuscated and **committed on purpose**: each
number in `TECHNICAL.md`, and every claim about "the same input gives the same
file", has to stay checkable against the exact bytes it was measured on.
Regenerating overwrites the reference, so a change in the output is a change in
the diff, not a claim in a chat.

## The hub family

`tienkhanh1/Chilli-Hub-Script` carries `RideAPet`, `StealAnEggg` and
`JumpForAnimals`; `tienkhanh1/spicy` (the hub's own library repo) carries the UI
engine, the join script and the key-system version. All of them are here or
accounted for below.

| file | lines | obfuscator | result | stability |
|---|---|---|---|---|
| `RideAPet.luau` | 11,034 | Luraph v15.1 | devirtualized, 716 functions | byte-identical across runs |
| `StealAnEggg.luau` | 37,563 | Luraph v15.1 carrier | `payload-source`: the loader carries the hub script as plain Luau (2,204 functions) | byte-identical |
| `JumpForAnimals.luau` | 7,103 | Luraph v15.1 | devirtualized, 457 functions, 0 unlifted blocks — the deepest lift in the set | body byte-identical; the closing `devirt:` disclosure line counts trace coverage and moves between runs (244–316 functions), see below |
| `ChilliLibraryEngine.luau` | 3,667 | Luraph v15.1 carrier | `payload-source` (474 functions) — the UI engine the whole hub runs on | byte-identical |
| `PrivateServer.luau` | 904 | Luraph v14.4.2 | devirtualized, 20 functions | byte-identical |
| `RideAPet.studio_loader.luau` | 25 | — | paste-ready loader for `--studio` (port 34880) | written by the engine |
| `StealAnEggg.luarmor.json` | — | — | the Luarmor report the run wrote next to the output | — |

Not delivered, with the reason:

| input | why |
|---|---|
| `JoinScript.lua` (Luraph v14.4.1) | its top level decodes to nothing offline: the lift writes one line, the guard reports a failed lift and the run leaves a behaviour trace instead. Nothing is handed over as a "result" for it. |
| `Grow-a-Garden` | Prometheus (detected 0.85). This build is Luraph-only and a new obfuscator family is not in scope, so it is identified and refused, not half-lifted. |
| `Steal-a-Brainrot` | Luraph v15.1, 1.0 MB. The lift runs past the 30-minute mark in the pipeline; its status is tracked in `TECHNICAL.md` §7. |

## How they were produced

```bash
node deob.js dev/fixtures/input/RideAPet.lua     -o output/current/RideAPet.luau     --exec-rec
node deob.js dev/fixtures/input/StealAnEggg.lua  -o output/current/StealAnEggg.luau  --exec-rec
node deob.js dev/fixtures/input/JumpForAnimals.lua -o output/current/JumpForAnimals.luau --exec-rec
node deob.js dev/fixtures/input/http/chilli-library-engine.lua -o output/current/ChilliLibraryEngine.luau --exec-rec
node deob.js dev/fixtures/input/PrivateServer.lua -o output/current/PrivateServer.luau --exec-rec
```

Inputs are not committed (`.gitignore`: `/dev/fixtures/input/`); their sha256s:

| fixture | bytes | sha256 |
|---|---|---|
| `RideAPet` | 338,756 | `14cd35cc227c94f314b789c2c0cc2afa40b780754262f3017d9aaf65c2660a79` |
| `StealAnEggg` | 529,242 | `41b5de74cc0fc687a884829357f2a7caf68d5b3519c9f30e1276e2698fdcd9ae` |
| `JumpForAnimals` | 503,353 | `f057a69b2c3b08e4e111225cd3ab98247fe0a50425a0f18eff13220be4af455d` |
| `ChilliLibraryEngine` | 183,544 | `ee8e0f4ff77739442fa8bafcbaa82321927501cd3e27f1b955c223f897d9c100` |
| `PrivateServer` | 83,547 | `01770f6d56d1b370bc53e69c027acce1c6208cd16488f8ecb4d2b24a17ba2ce2` |
| `Chilli Library` (plain, reference) | 415,445 | `9a029e0bc3c90b2dc3216438938bdc10100ef7b8d006d551c94135fb0c692fcb` |

## Checks that hold for all of them

```bash
node dev/scripts/luac.js output/current/*.luau      # every file compiles
node dev/scripts/freevars.js output/current/*.luau  # 0 unresolved register reads
node deob.js dev/fixtures/input/RideAPet.lua -o /tmp/again.luau --exec-rec
diff output/current/RideAPet.luau /tmp/again.luau   # identical
```

`JumpForAnimals` is the one exception to the last check, and only in its closing
disclosure line: the trace coverage it reports depends on how much of the
sample's own loop runs before the budget stops it. The lifted body — everything
above that line — is identical between runs. `--step-budget` and `--time-pin`
(constant statement count, frozen clock) shrink the spread but do not close it,
because the hub branches on values the offline runtime cannot pin.

`RideAPet-cache.luau` (the `--http-cache` experiment that produced a *smaller*
result, kept for `TECHNICAL.md` §3) lives in `results/`, next to the earlier
Chilli artifacts.

These files are other people's code (Chilli Hub), kept as the measurement
targets of this engine.
