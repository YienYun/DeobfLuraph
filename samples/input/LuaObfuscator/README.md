# LuaObfuscator samples

One real Roblox script — **"Nebula Sentinel v2.4"**, a client-side module that
talks to `ReplicatedStorage`, `RunService`, `UserInputService` and
`HttpService` and writes `nebula_sentinel_v2.json` — obfuscated by hand on
luaobfuscator.com, once per preset. That makes it the only track in this repo
where the plaintext is known and every result can be checked instead of
described.

## The files

| File | Preset | Size | What the site produced |
| --- | --- | --- | --- |
| `ChaoticGood.lua` | Chaotic Good | 27 KB | XOR string decoder + flattened `while true do if v==N` control flow |
| `ObfucateGood.lua` | OBFUSCATE! (Good) | 15 KB | same family, lighter |
| `ChaoticEvil.lua` | Chaotic Evil | 87 KB | the above **plus bytecode for a stack VM** (2,958 instructions, 74 distinct opcodes) |
| `ObfuscateV1.lua` | OBFUSCATE! | 108 KB | VM payload, 3,553 instructions |
| `Obfuscate_old.lua` | OBFUSCATE! (older build) | 82 KB | VM payload, 2,302 instructions |
| `Obfucate_Old2.lua` | OBFUSCATE! (old), **second build of the same script** | 81 KB | VM payload, 2,181 instructions — a different opcode table for the same code |

Each build randomises its own interpreter opcodes, which is why the three VM
presets cannot be lifted by an opcode table; see below.

## Results (`node deob.js samples/input/LuaObfuscator`)

| File | Result type | Output | Runs? | Same behaviour as the original? |
| --- | --- | --- | --- | --- |
| `ChaoticGood.lua` | `devirtualized` | 909 lines of source | yes (in the sandbox) | **yes** — prints `[Nebula] Loaded OK \| sig=AD5B10BA (2908426426, len=19)` |
| `ObfucateGood.lua` | `devirtualized` | 608 lines of source | yes | **yes** — same signature line |
| `ChaoticEvil.lua` | `vm-ir` | decoded payload: 2,958 instructions, 149 constants, best-effort preview | no | no — bytecode is recovered, not lifted |
| `ObfuscateV1.lua` | `vm-ir` | decoded payload, 3,553 instructions | no | no |
| `Obfuscate_old.lua` | `vm-ir` | decoded payload, 2,302 instructions | no | no |
| `Obfucate_Old2.lua` | `machine` | decoded register machine: 2,181 instructions, 2,152 labelled blocks, **0 unclassified** | no (labels/goto) | control flow intact, not yet structured |

The two source presets are checked by behaviour, not by inspection: both the
original and the lifted copy are run inside the project's Roblox sandbox
(`runtime/envlog.luau`) and must print the same `[Nebula] Loaded OK` line.
`test/luaobfuscator_samples.test.js` does exactly that on every `npm test`.

A `vm-ir` result is reported as `vm-ir`, with a warning and a header in the
file. It is **not** called `devirtualized`: the payload is decoded, but the
listing is not the script.

## The second old build (`Obfucate_Old2.lua`)

Same script, obfuscated again at the same preset, produced a different opcode
table — which is exactly what makes it useful. In this build the interpreter has
a dispatch the analyzer can read, so the payload is decoded **and** classified
instruction by instruction: 2,181 instructions, 0 left unclassified (three
handler shapes were missing from the classifier and are now covered: range
return through the `unpack` alias, the two-value return, and the
copy-on-truthy test).

What comes out is a faithful register machine: 35 protos, 2,152 labelled
blocks, 274 branches, 122 loops. The CFG is **reducible** (every back edge's
header dominates its tail, 0 irreducible edges), so it can be structured —
but `::Lnn::` and `goto` are neither Luau nor Lua 5.1, so the result is reported
as `machine`, not as source:

```
[!] decoded to a register machine: 2152 labelled blocks, not Luau source
[+] result (machine): samples/output/LuaObfuscator/Obfucate_Old2.lua
```

The remaining work is a relooper over that listing (natural loops, post-dominator
if/else, `break`/`continue` for loop exits), and the oracle to prove it is the
sandbox behaviour comparison the two source presets already pass.

## Why the other VM presets stop at decoded IR

The site's VM presets keep the script as bytecode for an interpreter that is
itself obfuscated:

- the payload is XOR-encoded and versioned by a descriptor per instruction
  (`mode` / `flags` decide which operands are constants), which the decoder
  already handles;
- the interpreter is control-flow-flattened (`while true do if (v110==(438-(262
  +176))) then ...`), and its opcode numbers differ **per build** — the same
  script obfuscated twice yields two different opcode tables.

So the missing piece is not decoding, it is recovering opcode semantics from a
de-CFFed interpreter. The vendored `analyzeSuperinstructionVm` does that for
builds whose interpreter has a simple `[op] = 1; if op == N then ...` dispatch;
these builds have the nested CFF form, so it returns null and the payload is
preserved as IR.

## What still helps

- `test/vectors/luaobfuscator/vector{1,2}.lua` — deterministic `CHECK` vectors
  (14 and 18 assertions) for presets that do lift; compare with
  `node tools/oracle/compare.js <vector> <output>`.
- More builds of the **same** Nebula script at the VM presets are useful: two
  builds with different opcode tables are the honest test for a
  semantics-inference lifter, and they cost nothing to produce.
- More second/third builds of the **same** script at `OBFUSCATE (old)`: each one
  is a fresh opcode table, which is what keeps the classifier honest and what
  lets a structurally-lifted proto be checked against a build it never saw.
- Any preset configured with extra toggles (`CFF v1`, `MBAv1`, `Table
  Indirection`, `Junk-If`, `Reverse-If`, `Minify`, `Demo VM`) as separate
  files: those isolate one transform at a time, which is much easier to pin.

## Checking a pair

```bash
node deob.js samples/input/LuaObfuscator/ChaoticGood.lua -o /tmp/out.lua
node tools/oracle/compare.js test/vectors/luaobfuscator/vector1.lua /tmp/out.lua   # plain-Lua vectors
```

For Roblox-flavoured scripts (these samples) the oracle is the sandbox
comparison: `node deob.js <file> --no-devirt` prints the lines the script
produces, so original and lifted output can be diffed line by line.
