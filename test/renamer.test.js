'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const renamer = require('../renamer');
const deob = require('../deob');

const ROOT = path.resolve(__dirname, '..');
const luauBin = path.join(ROOT, 'bin', process.platform === 'win32' ? 'luau.exe' : 'luau');

function runLuau(source) {
  const tmp = path.join(os.tmpdir(), `renamer-exec-${process.pid}-${Date.now()}-${Math.random().toString(36).slice(2)}.luau`);
  try {
    fs.writeFileSync(tmp, source, 'utf8');
    const r = spawnSync(luauBin, [tmp], { encoding: 'utf8', timeout: 10000 });
    assert.equal(r.status, 0, `Luau execution failed: ${r.stderr}\n${source}`);
    return r.stdout;
  } finally {
    try { fs.unlinkSync(tmp); } catch {}
  }
}

test('renamer eliminates Luraph chaff + Darklua dead code while preserving exact Luau behavior', () => {
  const sample = `
local n = 778854720
;(function()
\tlocal v1 = bit32.bxor(123456, 654321)
\tlocal v2 = table.pack(bit32.band(v1, 255))
\tlocal fn1
\tfn1 = function(arg1, arg2, arg3)
\t\tif arg1 + 333714065 == 404309964 then
\t\t\treturn -999
\t\tend
\t\tif false then
\t\t\tprint("DEAD_BRANCH")
\t\tend
\t\treturn arg2 + arg3
\tend
\tlocal tbl = { ["score"] = fn1(147674248, 10, 32) }
\tlocal function calc(x)
\t\tif true then
\t\t\treturn x * 2
\t\tend
\t\tprint("UNREACHABLE_AFTER_RETURN")
\tend
\tprint(tbl.score, calc(5))
end)()
`;

  const origOut = runLuau(sample);
  assert.equal(origOut.trim(), '42\t10');

  const res = renamer.cleanAndRename(sample, { comments: 'light' });
  assert.equal(res.stats.ast_valid, true);
  assert.doesNotMatch(res.source, /778854720/);
  assert.doesNotMatch(res.source, /147674248/);
  assert.doesNotMatch(res.source, /DEAD_BRANCH/);
  assert.doesNotMatch(res.source, /UNREACHABLE_AFTER_RETURN/);
  assert.doesNotMatch(res.source, /bit32\.bxor\(123456/);

  const newOut = runLuau(res.source);
  assert.equal(newOut, origOut);
});

test('renamer keeps multi-name locals without initializers instead of leaking their writes as globals', () => {
  // darklua's remove_unused_variable deletes the whole statement when one name of a
  // `local a, b` (no initializers) is unused, so `a = ...` would become a global write.
  const sample = `
local function collect()
  local kept, neverUsed
  kept = 0
  for i = 1, 3 do
    kept = kept + i
  end
  return kept
end
print(collect(), kept)
`;
  const origOut = runLuau(sample);
  assert.equal(origOut.trim(), '6\tnil');

  const res = renamer.cleanAndRename(sample, { comments: 'none' });
  assert.equal(res.stats.ast_valid, true);
  assert.match(res.source, /local kept, neverUsed/);
  assert.equal(runLuau(res.source), origOut);
});

test('renamer prevents variable shadowing, preserves executor guards, and comments idempotently', () => {
  const sample = `
game = { GetService = function(_, s) return { Name = s } end }
local v1 = game:GetService("Players")
local function fn1(arg)
\tlocal Players = "inner_shadow"
\tif syn and syn.request then
\t\treturn syn.request(arg)
\tend
\tfor _, v2 in ipairs(arg) do
\t\tv2:Disconnect()
\tend
\ttable.clear(arg)
\treturn v1.Name, Players
end
local conns = {
\t{ Disconnect = function() end },
\t{ Disconnect = function() end },
}
print(fn1(conns), #conns)
`;

  const origOut = runLuau(sample);
  const pass1 = renamer.cleanAndRename(sample, { comments: 'detailed' });
  assert.equal(pass1.stats.ast_valid, true);
  assert.ok(pass1.stats.renamed >= 2, 'expected variables/functions to be renamed');
  assert.ok(pass1.stats.comments >= 1, 'expected contextual comments to be added');
  assert.match(pass1.source, /if syn and syn\.request then/);
  assert.match(pass1.source, /local Players2 = game:GetService\("Players"\)/);
  assert.match(pass1.source, /local function disconnectAll\(/);
  assert.equal(runLuau(pass1.source), origOut);

  // Idempotency: running a second pass must not duplicate existing comments
  const pass2 = renamer.cleanAndRename(pass1.source, { comments: 'detailed' });
  assert.equal(pass2.stats.comments, 0);
  assert.equal(runLuau(pass2.source), origOut);
});

test('renamer CLI refuses accidental input overwrite and deob.js accepts --rename options', (t) => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'renamer-cli-'));
  t.after(() => fs.rmSync(dir, { recursive: true, force: true }));

  const inFile = path.join(dir, 'sample.lua');
  fs.writeFileSync(inFile, 'local v1 = Vector3 and Vector3.new(1, 2, 3) or { X = 1 }\nprint(v1.X)\n', 'utf8');

  assert.throws(
    () => renamer.processFile(inFile, { ...renamer.parseArgs([inFile, '-o', inFile]), singleFile: true }),
    /output path resolves to the input file/
  );

  const outFile = path.join(dir, 'out.lua');
  const repFile = path.join(dir, 'report.json');
  const rep = renamer.processFile(inFile, {
    ...renamer.parseArgs([inFile, '-o', outFile, '--comments', 'light', '--report', repFile]),
    singleFile: true,
  });
  assert.equal(rep.rename_stats.ast_valid, true);
  assert.ok(fs.existsSync(outFile));
  assert.ok(fs.existsSync(repFile));

  const dArgs = deob.parseArgs(['input.lua', '-o', 'out.lua', '--rename', '--comments', 'detailed']);
  assert.equal(dArgs.rename, true);
  assert.equal(dArgs.comments, 'detailed');
});
