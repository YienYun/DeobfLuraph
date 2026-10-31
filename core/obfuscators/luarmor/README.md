# Luarmor v4 track

Luarmor does not obfuscate the way Luraph or MoonSec do. It is a **licence
service around** an obfuscated script, and a "Luarmor protected" download is a
chain of three pieces:

```text
1. client stub        _bsdata0={...}  +  module id  +  init URL      (on disk)
        │                                    5 lines, "Do not save this file"
        ▼  game:HttpGet("https://cdn.luarmor.net/v4_init_*.lua")
2. sephal init        superflow_bytecode={...}  +  Luraph v15 chunk  (on disk)
        │                                    ~330 KB, cached under static_content_
        ▼  licence handshake with *.luarmor.net (/auth/init, /auth/start, /heartbeat)
3. session payload    the script the author uploaded                 (server only)
```

Steps 1 and 2 are files; step 3 is not. This track handles what is actually
present:

| Stage | What this engine does |
| --- | --- |
| client stub | parse `_bsdata0`: client tag, sha256 fields, byte blobs, build stamp, cache key, init URL; write `<out>.luarmor.json`; keep the stub as the (annotated) result |
| sephal init | strip the `superflow_bytecode` table, devirtualize the Luraph v15 chunk that follows it with the normal Luraph engine |
| served loader/payload | a Luraph v15 chunk that references `api.luarmor.net/files/v4/...` is devirtualized and labelled with its loader id |
| licence handshake | **not** performed and **not** bypassed — the session payload exists only behind a key |

## Modules

| Path | Role |
| --- | --- |
| `stub.py` | Lua-literal helpers, `_bsdata0` / sephal-init parsing, field classification |
| `probe.py` | signature scan, kind classification, IOC extraction (endpoints, loader ids, webhooks, kick messages) |
| `analyze.py` | CLI; `--json` is what the Node driver reads |
| `src/luarmor.js` | announce, attach the metadata header, write the JSON report |
| `deob.js` | routes `luarmor_client` files here, then to the Luraph driver when a chunk exists |

## Usage

```bash
# human-readable chain report, no execution
python3 core/obfuscators/luarmor/analyze.py samples/input/Luarmor/SampleV2_sephal_init.lua

# full pipeline (report + devirtualization when possible)
node deob.js samples/input/Luarmor -o /dev/null
node deob.js some_loader.lua --plugin luarmor
```

## Reference results

| Sample | Kind | Result |
| --- | --- | --- |
| `SampleV1_client_stub.lua` (1.4 KB) | client stub | annotated stub + `SampleV1_client_stub.luarmor.json` (client tag, sha256, build stamp 1769015477, init URL) |
| `SampleV2_sephal_init.lua` (331 KB) | sephal init | `24 functions, 0 unlifted blocks, 0 unstructured jumps` → 516 lines of readable bootstrap code |
| Venyx `Steal An Egg` loader (in `samples/input/Luraph/SampleV3.lua`) | served payload | `42 functions, 0 unlifted blocks` → 5 920 lines, loader id `130307ddb90b87125e0a381843ee1563` |

## Notes

- The `LAC.<x>_...` client tag is a 134-character string over a 16-symbol
  alphabet (`-.012345ABCDELR_`). It is reported verbatim with its alphabet; the
  mapping back to a script id is done by the init, which is a server-side step.
- Format knowledge comes from the open research toolkit
  `Luarmor-Fetch` (@adi.codz); the implementation here is independent and does
  no network I/O.
