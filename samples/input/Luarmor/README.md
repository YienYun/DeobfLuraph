# Luarmor samples

Drop the **raw protected script text** here — the file a Luarmor customer
downloads and runs, not a trace and not a screenshot.

What the Luarmor track needs to start:

| Item | Why |
| --- | --- |
| The protected `.lua` / `.luau` / `.txt` exactly as shipped | the engine reads its loader and encrypted payload |
| Luarmor tier/version, if known (Free / Standard / Pro / v4 / v5) | selects the unpacker and the VM profile |
| (optional) the same script before protection | lets the lift be diffed against ground truth |

Things that do **not** help: executor console output, `print` traces,
screenshots, or the `_bsdata0` blob on its own.

Outputs land in `samples/output/Luarmor/`, one file per input, same naming
as the Luraph track (`SampleV1.lua` -> `SampleV1.lua`).

> Licensing loaders (`Luarmor v4` / `_bsdata0`) are refused by design:
> this track deobfuscates the *script* the loader carries, it does not
> bypass the licence check.
