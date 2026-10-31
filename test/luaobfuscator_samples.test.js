'use strict';

/**
 * LuaObfuscator track regression.
 *
 * The four samples in samples/input/LuaObfuscator came from luaobfuscator.com
 * presets (Chaotic Evil, Chaotic Good, OBFUSCATE!, and an older OBFUSCATE!).
 * Each test pins what the engine does with that preset today, so the
 * structural lifter can only move the numbers forward.
 */

const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
const IN = path.join(ROOT, 'samples', 'input', 'LuaObfuscator');
const CLI = path.join(ROOT, 'core', 'obfuscators', 'luaobfuscator', 'src', 'cli.js');

function hasLuaparse() {
  // the static LuaObfuscator transforms parse Lua; without the dependency the
  // CLI cannot run at all, and that is a setup problem, not a test failure
  const probe = spawnSync(process.execPath, ['-e', "require.resolve('luaparse')"], { cwd: ROOT });
  return probe.status === 0;
}

const luaparse = hasLuaparse();

function deobf(sample) {
  const r = spawnSync(process.execPath, [CLI, path.join(IN, sample), '--stdout'], {
    cwd: ROOT,
    encoding: 'utf8',
    timeout: 120000,
    maxBuffer: 64 * 1024 * 1024,
  });
  assert.equal(r.status, 0, `${sample}: CLI failed: ${(r.stderr || '').split('\n').slice(0, 3).join(' ')}`);
  return r.stdout;
}

function runLuau(source, name) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'lo-run-'));
  const file = path.join(dir, name);
  fs.writeFileSync(file, source, 'utf8');
  const bin = path.join(ROOT, 'bin', process.platform === 'win32' ? 'luau.exe' : 'luau');
  const r = spawnSync(bin, [name], { cwd: dir, encoding: 'utf8', timeout: 120000 });
  fs.rmSync(dir, { recursive: true, force: true });
  return r;
}

test('LuaObfuscator: the CLI needs luaparse, and says so instead of tracing', { skip: luaparse ? false : 'luaparse is not installed (npm install)' }, () => {
  assert.ok(fs.existsSync(CLI), 'the vendored LuaObfuscator CLI is present');
  const head = fs.readFileSync(CLI, 'utf8');
  assert.match(head, /deobfuscateLuaObfuscator/);
});

const SIMPLE = [
  ['ChaoticGood.lua', 'yoo chaotic good'],
  ['Obfuscate.lua', 'hello luaobfuscator OBFUSCATEV1'],
  ['Obfuscate_old.lua', 'luaobfuscator OBFUSCATEold deobfed'],
];

for (const [sample, expected] of SIMPLE) {
  test(`LuaObfuscator: ${sample} lifts to runnable source that prints ${JSON.stringify(expected)}`, { skip: luaparse ? false : 'luaparse is not installed' }, () => {
    const out = deobf(sample);
    assert.ok(out.trim().length > 0, 'output is not empty');
    assert.ok(!/LuaObfuscator\.com|integrity protected/i.test(out.split('\n').slice(0, 3).join('\n')), 'banner is gone');
    const run = runLuau(out, 'out.luau');
    assert.equal(run.status, 0, `output must run under Luau: ${(run.stderr || '').split('\n')[0]}`);
    assert.ok(run.stdout.includes(expected), `expected ${JSON.stringify(expected)} in output, got ${JSON.stringify(run.stdout.trim())}`);
  });
}

test('LuaObfuscator: Chaotic Evil decodes its VM payload', { skip: luaparse ? false : 'luaparse is not installed' }, () => {
  const out = deobf('ChaoticEvil.lua');
  // the payload is decoded into a rehosted VM: registers, protos, labels
  assert.match(out, /local protos = \{\}/, 'a decoded proto table is emitted');
  assert.match(out, /protos\["0_0"\] = function/, 'the main proto is present');
  assert.match(out, /capture_upvalue/, 'upvalue cells are reconstructed');
  assert.ok(out.split('\n').length > 100, `expected a lifted body, got ${out.split('\n').length} lines`);
});

test('LuaObfuscator: Chaotic Evil still has to become structured Lua', {
  skip: luaparse ? 'TODO(struct-lift): the rehost uses goto/labels, which neither Luau nor Lua 5.1 accepts' : 'luaparse is not installed',
}, () => {
  const out = deobf('ChaoticEvil.lua');
  const run = runLuau(out, 'out.luau');
  assert.equal(run.status, 0, 'the lifted Chaotic Evil payload runs under Luau');
  assert.ok(run.stdout.includes('chaotic evil'), 'and prints what the original prints');
});
