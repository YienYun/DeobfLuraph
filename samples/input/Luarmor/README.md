# Luarmor samples

Real files from the Luarmor v4 chain, plus what the track does with them.

| File | What it is |
| --- | --- |
| `SampleV1_client_stub.lua` | a saved client stub (1.4 KB): `_bsdata0` + cache key + init URL. Carries no script — it downloads one after the licence handshake. |
| `SampleV1.lua` | the full 780 KB chain as delivered (stamp 1793260940): `_bsdata0` + a 10,710-byte superflow blob + a Luraph v15 chunk. The chunk is the loader bootstrap, so it lifts to one function (`while true do end`): every check Luarmor makes fails offline and the kick line is inside the retry loop, so the session payload stays encrypted. |
| `SampleV3_hub_pointer.lua` | a 108-byte hub script (`loadstring(game:HttpGet(...))()`) that only points at loader `ff2f66df...`. Reported as `hub_pointer`: there is no code here, the header carries the url to fetch next. |
| `SampleV2_sephal_init.lua` | the sephal init (331 KB): `superflow_bytecode={...}` followed by a Luraph v15 chunk. This *is* code, and it gets devirtualized. |

## `DeobCapture/` — one real session, captured with `tools/capture`

Six files from a single Venyx run. They are the whole chain in order, and only
`04` is the script:

| File | What it is | Engine result |
| --- | --- | --- |
| `01_loadstring.lua` (1.3 KB) | the client stub for this build (`_bsdata0`, stamp 1793468710) | `client_stub`, nothing to lift |
| `02_loadstring.lua` (798 KB) | the bootstrapper it downloads (`superflow_bytecode` + Luraph chunk) | `luarmor-blocked`, **0 functions**: what it runs is decrypted by the live session only |
| `03_request.lua` (482 B) | the handshake response (`x.luarmor.net/...&b=...`) | not Lua, kept as evidence |
| `04_loadstring.lua` (1.1 MB) | the payload the loader handed to `loadstring` — the Luraph v15 script | `devirtualized`: 40 functions, 0 unlifted blocks, 4,704 lines |
| `05_request.lua` (358 B) | `as6-roblox-auth.luarmor.net/status` (API health) | not Lua, kept as evidence |
| `06_loadstring.lua` (349 B) | the error-prompt helper chunk | plain Luau, nothing obfuscated |

`04` is the interesting one: 40 functions and no unlifted blocks, but the
offline run stops at `Script:1: invalid argument #1 to 'band'` — a probe call
(`pcall(Folder.Clone, UDim.new(...), 2139543573)`) succeeds in a sandbox that
answers every instance call, so a decoy branch is taken and the run ends after
59 statements. The header and the `.luarmor.json` say so (`run_status`,
`runtime.stubs`), instead of letting a partial trace pass for the whole script.
7 LPH runtime functions live in the VM object and stay named stubs.

A Luarmor-*served* payload (a Luraph v15 chunk that references
`api.luarmor.net/files/v4/loaders/<id>.lua`) is filed with the Luraph samples;
`samples/input/Luraph/SampleV3.lua` is exactly that, and both engines agree it
lifts to 42 functions with 0 unlifted blocks.

```bash
node deob.js samples/input/Luarmor            # every sample -> samples/output/Luarmor
python3 core/obfuscators/luarmor/analyze.py samples/input/Luarmor/SampleV1_client_stub.lua
```

Outputs: the devirtualized init, the annotated stub, and a `.luarmor.json`
report (client tag, sha256 fields, build stamp, endpoints, loader ids) for each.
`SampleV1.lua` is reported as `luarmor-blocked` — `blocked.states` says whether
the offline run died on a `StateNNN` kick or never left the loader's own checks —
so a bootstrap-sized file is never mistaken for the protected script.

> Licensing loaders are analysed, not bypassed: the licence check and the
> session payload behind it are server-side steps that stay server-side.

The payload only exists at runtime, so a working session has to hand it over:
`tools/capture/luarmor_capture.luau` hooks the fetch and `loadstring` calls and
drops every stage into `DeobCapture/`, which `node deob.js` then routes.
