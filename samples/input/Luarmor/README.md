# Luarmor samples

Real files from the Luarmor v4 chain, plus what the track does with them.

| File | What it is |
| --- | --- |
| `SampleV1_client_stub.lua` | a saved client stub (1.4 KB): `_bsdata0` + cache key + init URL. Carries no script — it downloads one after the licence handshake. |
| `SampleV1.lua` | the full 780 KB chain as delivered (stamp 1793260940): `_bsdata0` + a 10,710-byte superflow blob + a Luraph v15 chunk. The chunk is the loader bootstrap, so it lifts to one function (`while true do end`): every check Luarmor makes fails offline and the kick line is inside the retry loop, so the session payload stays encrypted. |
| `SampleV2_sephal_init.lua` | the sephal init (331 KB): `superflow_bytecode={...}` followed by a Luraph v15 chunk. This *is* code, and it gets devirtualized. |

A Luarmor-*served* payload (a Luraph v15 chunk that references
`api.luarmor.net/files/v4/loaders/<id>.lua`) is filed with the Luraph samples;
`samples/input/Luraph/SampleV3.lua` is exactly that, and both engines agree it
lifts to 42 functions with 0 unlifted blocks.

```bash
node deob.js samples/input/Luarmor            # both samples -> samples/output/Luarmor
python3 core/obfuscators/luarmor/analyze.py samples/input/Luarmor/SampleV1_client_stub.lua
```

Outputs: the devirtualized init, the annotated stub, and a `.luarmor.json`
report (client tag, sha256 fields, build stamp, endpoints, loader ids) for each.
`SampleV1.lua` is reported as `luarmor-blocked` — `blocked.states` says whether
the offline run died on a `StateNNN` kick or never left the loader's own checks —
so a bootstrap-sized file is never mistaken for the protected script.

> Licensing loaders are analysed, not bypassed: the licence check and the
> session payload behind it are server-side steps that stay server-side.
