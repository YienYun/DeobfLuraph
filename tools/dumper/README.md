# Luraph dumper (vendored) + cross-check

`engine/` is the Luraph proto/constant extractor that came in
`Upload/Luraph_Dumper.zip` (by *im_mxrtal*), vendored so it can be run and
compared against this repository's own engine. It is **not** a second
deobfuscator: it recovers prototypes and decrypted constants, it never produces
source. The deobfuscated output you ship still comes from `core/`.

Two things had to change for it to be usable here:

* **It needed Windows.** The zip shipped a 14 MB `lune.exe`. `runner.py` bundles
  the five engine files into one script, supplies a small pure-Luau stand-in for
  `@lune/fs`, `@lune/luau` and `@lune/process`, and runs it on the repository's
  own `bin/luau`. No Lune, no Windows.
* **It hid its failures.** Phase 1 runs the VM inside a `pcall` and only printed
  `status: false`, so a dead sandbox looked like "no protos in this script". The
  error is now printed (`[!] Phase 1 error: ...`), and `runner.py` exits non-zero
  when nothing was captured.

## Running it

```sh
python3 tools/dumper/runner.py samples/input/Luraph/SampleV1.lua --out /tmp/dump1
```

Writes `/tmp/dump1/protos.json` and `/tmp/dump1/constants.lua`. Exit codes:
`0` captured prototypes, `1` the VM never ran, `2` the runner itself failed.

## Cross-checking our output

```sh
node tools/dumper/crosscheck.js samples/output/Luraph/SampleV1.lua
```

Checks that:

1. the output parses (`bin/luau-ast`);
2. every string literal in the output is accounted for — either present in the
   obfuscated input or confirmed by an independent constant dump (`--dump`).

Anything left over is reported instead of being quietly accepted: a literal no
one else can see is either a lifter invention or an unverified decryption, and
the tool says which case applies rather than guessing.

Two more changes, both found by running it on `SampleV1`:

* the sandbox hands the VM a stand-in object where the VM expects a number, and
  `bit32.bxor` then raised `number expected, got table`, killing the run before
  a single proto was captured. Non-number operands now count as 0, which is fine
  for a constant extractor: the value is meaningless, the protos behind it are
  not. Phase 1 now finishes on `SampleV1`.
* the deserializer hooks are written against one specific build (14.8). When none
  of them fires, the engine now walks the VM table itself for proto-shaped
  subtables instead of reporting "nothing here".

## Status on the current samples

Phase 1 completes, and the table walk finds 4 tables that look like prototypes,
but none of them matches the 14.8 schema `register_proto` expects, so the dump
still has no instructions in it. Confirming our constants for this build means
porting the field map from `core/obfuscators/luraph_v15/vmmap.py` into
`engine/deserializer.luau`; that has not been done.

So on these samples the cross-check says **unconfirmed**, not *correct* and not
*wrong*: the runner exits 1, `crosscheck.js` reports the decrypted strings as
unverified, and neither tool pretends otherwise. Our own engine does get past
this point, which is exactly the gap this tool exists to make visible.
