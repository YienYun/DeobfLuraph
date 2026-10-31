# LeakD LuaObfuscator Deobfuscator (third party, vendored)

Upstream: `LuaObfuscator-Deobfuscator-main.zip` uploaded to `Upload/` on
2026-10-31 (author: LeakD, discord.gg/qteAQmfJmP, MIT — see `LICENSE`).
Pasted here unchanged so both engines can be run side by side.

```bash
node core/obfuscators/luaobfuscator_leakd/index.js <input.lua> --out <output.lua>
```

## Measured on this repo's samples (2026-11-01)

Run: `node tools/compare_engines.js` (that script is the source of truth; the
table below is its output at the time of writing).

| Sample | LeakD | This repo's engine |
| --- | --- | --- |
| `ChaoticGood.lua` | output does not parse (`v147true`, statement incomplete at line 446); also returns an unassigned register as the signature | parses, runs in the sandbox, prints the original signature |
| `ObfucateGood.lua` | `det:not_luaobfuscator` — refuses the file | parses, runs, prints the original signature |
| `ChaoticEvil.lua` | emits `::Lnn::` labels and `goto`, 300 lines that do not parse | full VM decode, 2,958 instructions preserved as IR |
| `ObfuscateV1.lua` | `det:incomplete_evil:missing_xor_bootstrap` | 3,553 instructions preserved as IR |
| `Obfuscate_old.lua` | `det:incomplete_evil:missing_xor_bootstrap` | 2,302 instructions preserved as IR |
| `Obfucate_Old2.lua` | `det:incomplete_evil:missing_xor_bootstrap` | every instruction classified: 2,181 instructions, 2,152 blocks, 0 unknown |

So on these files it is not a drop-in replacement: it is faster and produces
shorter output, but that output is not valid Lua on the two files it accepts,
and it refuses four of six.

## Where it is genuinely useful

- its Chaotic Evil reader is worth reading for the `Utils/vm.js` handler table;
- it is a second opinion when a new build breaks this repo's classifier.

Nothing here calls it automatically; the main pipeline still uses
`core/obfuscators/luaobfuscator/`.
