# Capturing a loader's payload

A Luarmor delivery is two files, and only the second one is the script:

1. a **loader** — `https://api.luarmor.net/files/v4/loaders/<id>.lua` (a hub
   script is often just a one-line pointer to it);
2. the **payload** — the text the loader decrypts after its handshake and
   passes to `loadstring`.

The loader is devirtualizable offline (it is a Luraph v15 chunk, see
`samples/input/Luarmor/SampleV1.lua`); the payload only exists at runtime, so
it has to be captured from a working session.

## Run order (executor)

1. Execute `luarmor_capture.luau` **first** and wait for its
   `[capture] ready: ...` line.
2. In the same session, execute the loader.
3. Open the executor's workspace folder → `DeobCapture/`. Every captured file
   is `NN_httpget.lua`, `NN_loadstring.lua` or `NN_request.lua`; `_log.txt`
   lists the size and the url of each.
4. Send those files back. `node deob.js <file>` routes each of them:
   Luarmor chain → Luarmor track, Luraph chunk → v15 devirt, plain source →
   generic.

Do not leave the game or rejoin between steps 1 and 2: the loader's handshake
is bound to the live session, and its token rotates.

## What the hooks do

Nothing is blocked or faked — the hooks call the original and save a copy:

| hook | why |
| --- | --- |
| `game:HttpGet` / `HttpGetAsync` | the loader and everything it downloads |
| `request` / `http_request` / `syn.request` / `fluxus.request` | same, for loaders on executor HTTP |
| `loadstring` / `load` | the decrypted script, whatever name the loader uses |

If a file comes back much smaller than expected, `_log.txt` says which hook
fired; if `ready: httpget=false`, that executor has no `hookfunction` and only
`loadstring` was captured (still enough for the payload, not for the loader —
download that url directly in a browser instead).
