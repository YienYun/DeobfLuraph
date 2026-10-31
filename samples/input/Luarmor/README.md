# Luarmor samples

Real files from the Luarmor v4 chain, plus what the track does with them.

| File | What it is |
| --- | --- |
| `SampleV1_client_stub.lua` | a saved client stub (1.4 KB): `_bsdata0` + cache key + init URL. Carries no script — it downloads one after the licence handshake. |
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

> Licensing loaders are analysed, not bypassed: the licence check and the
> session payload behind it are server-side steps that stay server-side.
