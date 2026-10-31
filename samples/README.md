# samples/

Working corpus for the engines. **Nothing in here is committed** -- the folder
layout is tracked, the files are not (see `.gitignore`). Samples are big
(0.5-1 MB each), they change every time somebody tests something, and they make
every clone and every diff heavy for no benefit.

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

Output files land in `samples/output/`, which is also ignored.
