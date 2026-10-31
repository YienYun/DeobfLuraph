# samples/

Working corpus for the engines.

* `samples/input/` is **not** committed (see `.gitignore`): those are the
  obfuscated files, 0.5-1 MB each, and they get re-uploaded constantly.
* `samples/output/` **is** committed: a deobfuscation nobody can open is not a
  result, so the file is tracked and its history is the record of what changed.

## How to use it

```sh
# put the file where the detector expects it
cp ~/Downloads/mystery.lua samples/input/Luraph/

# what does the engine think it is?
node deob.js samples/input/Luraph/mystery.lua -o samples/output/Luraph/mystery.lua
```

`deob.js` prints the detected obfuscator and confidence first, then the engine it
picked. If the guess is wrong the run is wrong too, so read that line before
reading the output.

Output files land in `samples/output/` and are tracked.
