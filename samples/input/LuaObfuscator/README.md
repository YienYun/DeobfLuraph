# LuaObfuscator samples

`luaobfuscator.com` is free and public, which makes it the one obfuscator in this
repo we can test against a **known original**: obfuscate the same file at every
preset and the output must still print the same checks.

## What is here

| Path | What it is |
| --- | --- |
| `../../test/vectors/luaobfuscator/vector1.lua` | 14 checks: recursion, closures, varargs, `table.sort`, `gmatch`, `format`, metatables, `pcall`, loops, math. Prints `CHECK ...` lines only. |
| `../../test/vectors/luaobfuscator/vector2.lua` | 18 checks: OOP with inheritance, shared upvalues, coroutines, nested closures, vararg forwarding, sort-by-comparator, matrix arithmetic, string histogram, `tonumber` bases. |
| `ChaoticGood.lua` | preset **Chaotic Good**, 1 KB, prints `yoo chaotic good` |
| `Obfuscate.lua` | preset **OBFUSCATE!**, 23 KB |
| `Obfuscate_old.lua` | older **OBFUSCATE!** build, 10 KB |
| `ChaoticEvil.lua` | preset **Chaotic Evil**, 16 KB: XOR strings + VM + integrity banner |

The four samples are the public corpus from
`axom0022/luaobfuscator-deobf-byaxom`; the presets are named after the buttons on
the site (CLEANUP: Junk-If, Reverse-If, CFF v1, Literals, MBAv1, Strings, Table
Indirection, Minify, Beautify, Demo VM — presets: Basic Good, Chaotic Good,
Chaotic Evil, OBFUSCATE!).

## What to send

Obfuscate `test/vectors/luaobfuscator/vector1.lua` and `vector2.lua` once per preset and drop
the results here as `<preset>_v1.lua` / `<preset>_v2.lua`:

1. `OBFUSCATE!`
2. `Basic Good`
3. `Chaotic Good`
4. `Chaotic Evil`
5. the individual actions, one file each: `Strings`, `CFF v1`, `MBAv1`,
   `Table Indirection`, `Junk-If`, `Reverse-If`, `Literals`, `Minify`,
   `Demo VM`
6. anything that makes `Chaotic Evil` heavier (the site's own toggles)

A real Roblox-flavoured script (a hub stub, a GUI builder, a farm loop) at
`Chaotic Evil` is worth having too: vectors keep the engine honest, real scripts
find the shapes the vectors miss.

## Checking a pair

```bash
node deob.js samples/input/LuaObfuscator/chaotic_evil_v1.txt -o /tmp/out.lua
node tools/oracle/compare.js test/vectors/luaobfuscator/vector1.lua /tmp/out.lua
```

`compare.js` runs both files under `bin/luau` and diffs the `CHECK` lines in
order — same lines, same order, or it fails with the first difference. `--all`
compares every printed line instead.

## Where the engine stands (2026-11-01)

| Preset | Result | Runs? |
| --- | --- | --- |
| Chaotic Good | `print("yoo chaotic good")` | yes |
| OBFUSCATE! | payload recovered, strings decoded | yes |
| OBFUSCATE! (old) | payload recovered | yes |
| Chaotic Evil | VM payload decoded into a rehosted machine: 1 proto, 105 labels, 13 `goto` | **no** — `goto`/labels are rejected by both Lua 5.1 and Luau |

So everything up to "string table + VM payload" works, and the open item is the
structural lift: turn the rehosted register machine back into `if`/`for`/`while`
source. That is what `npm test` skips as `TODO(struct-lift)` in
`test/luaobfuscator_samples.test.js`.

Notes:

- the static transforms need `luaparse` (`npm install`); without it the CLI
  cannot parse Lua and the pipeline falls back to a behaviour trace, which for a
  VM preset carries almost nothing. `src/multi_driver.js` now says that out
  loud instead of failing quietly.
- the VM decode path keeps its upstream credit line (`-- This file was deobfuscated
  by VX [...]`) at the top of the file; it is the vendored decoder's provenance,
  the repo watermark is added on top of it.
- `luaobfuscator` output uses `bit32 or bit`, `#` on tables and closures over
  registers — it is plain Lua 5.1, so the oracle runs it under Luau unchanged.
