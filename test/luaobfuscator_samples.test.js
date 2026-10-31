'use strict';

/**
 * LuaObfuscator track regression.
 *
 * The five files in samples/input/LuaObfuscator are one real Roblox script
 * ("Nebula Sentinel v2.4") obfuscated by hand on luaobfuscator.com, one per
 * preset. Two presets lift back to source; three ship a bytecode VM whose
 * opcodes are randomised per build, so they are decoded to IR only. Both facts
 * are pinned here, so a change in either direction shows up immediately.
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
const { isValidLuaSyntax } = require('../src/luac_decompile');

const SOURCE_PRESETS = ['ChaoticGood.lua', 'ObfucateGood.lua'];
const VM_PRESETS = ['ChaoticEvil.lua', 'ObfuscateV1.lua', 'Obfuscate_old.lua'];

function hasLuaparse() {
  const probe = spawnSync(process.execPath, ['-e', "require.resolve('luaparse')"], { cwd: ROOT });
  return probe.status === 0;
}
const luaparse = hasLuaparse();
const SKIP = luaparse ? false : 'luaparse is not installed (run npm install)';

function deobf(sample) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'lo-cli-'));
  const report = path.join(dir, 'report.json');
  const r = spawnSync(process.execPath, [CLI, path.join(IN, sample), '--stdout', '--json-report', report], {
    cwd: ROOT,
    encoding: 'utf8',
    timeout: 120000,
    maxBuffer: 64 * 1024 * 1024,
  });
  assert.equal(r.status, 0, `${sample}: CLI failed: ${(r.stderr || '').split('\n').slice(0, 3).join(' ')}`);
  let stats = null;
  try {
    stats = JSON.parse(fs.readFileSync(report, 'utf8'));
  } catch (err) {
    stats = null;
  }
  fs.rmSync(dir, { recursive: true, force: true });
  return { code: r.stdout, stats };
}

/** Behaviour of a file inside the project's Roblox sandbox: the lines it prints. */
function sandboxPrints(file) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'lo-trace-'));
  const out = path.join(dir, 'trace.lua');
  const r = spawnSync(process.execPath, [path.join(ROOT, 'deob.js'), file, '--no-devirt', '-o', out], {
    cwd: ROOT,
    encoding: 'utf8',
    timeout: 300000,
    maxBuffer: 32 * 1024 * 1024,
  });
  const text = fs.existsSync(out) ? fs.readFileSync(out, 'utf8') : '';
  fs.rmSync(dir, { recursive: true, force: true });
  assert.equal(r.status, 0, `${path.basename(file)}: sandbox run failed: ${(r.stderr || '').split('\n').slice(0, 3).join(' ')}`);
  return text.split('\n').map((l) => l.trim()).filter((l) => /^(?:print|warn)\(/.test(l));
}

test('LuaObfuscator: all five presets are detected and decode without an error', { skip: SKIP }, () => {
  for (const sample of [...SOURCE_PRESETS, ...VM_PRESETS]) {
    const { code, stats } = deobf(sample);
    assert.ok(code.trim().length > 0, `${sample}: output is not empty`);
    assert.ok(!/LuaObfuscator\.com/.test(code), `${sample}: the site banner is gone`);
    assert.ok(stats && stats.stats, `${sample}: a stats report is written`);
  }
});

for (const sample of SOURCE_PRESETS) {
  test(`LuaObfuscator: ${sample} lifts to source, not a listing`, { skip: SKIP }, () => {
    const { code, stats } = deobf(sample);
    assert.equal(stats.outputMode, 'source');
    assert.equal(stats.stats.vmPayloads, 0, 'no VM payload in this preset');
    assert.ok(isValidLuaSyntax(code), 'the lifted source parses as Luau');
    assert.match(code, /game:GetService\("Players"\)/, 'the script identity survives');
    assert.match(code, /nebula_sentinel_v2\.json/, 'string constants survive');
    assert.ok(code.split('\n').length > 300, `expected a full body, got ${code.split('\n').length} lines`);
    assert.ok(!/^\s*::L\d+::/m.test(code), 'no labels');
  });

  test(`LuaObfuscator: ${sample} behaves like the original in the sandbox`, { skip: SKIP }, () => {
    const original = sandboxPrints(path.join(IN, sample));
    const lifted = sandboxPrints(path.join(ROOT, 'samples', 'output', 'LuaObfuscator', sample));
    const signature = (lines) => lines.find((l) => /\[Nebula\] Loaded OK/.test(l));
    assert.ok(signature(original), 'the original reports its signature');
    assert.equal(signature(lifted), signature(original), 'the lifted copy reports the same signature');
  });
}

for (const sample of VM_PRESETS) {
  test(`LuaObfuscator: ${sample} decodes its VM payload and says it is not source`, { skip: SKIP }, () => {
    const { code, stats } = deobf(sample);
    assert.equal(stats.outputMode, 'vm-ir');
    assert.equal(stats.stats.vmPayloads, 1, 'exactly one VM payload');
    assert.ok(stats.stats.vmPreservedInstructions > 500, 'the bytecode is preserved, not dropped');
    assert.match(code, /decoded wrapper strings:|^-- constants:$/m, 'the payload was decoded, not just skipped');
    assert.match(code, /best-effort source preview/, 'a preview of the lifted body is included');
  });
}

test('LuaObfuscator: the CLI keeps the watermark-free contract for vm-ir results', { skip: SKIP }, () => {
  // the engine reports vm-ir as a partial result: "devirtualized" would claim
  // a lift that did not happen
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'lo-run-'));
  const out = path.join(dir, 'ChaoticEvil.lua');
  const reportFile = path.join(dir, 'report.json');
  const r = spawnSync(process.execPath, [path.join(ROOT, 'deob.js'), path.join(IN, 'ChaoticEvil.lua'), '-o', out, '--report', reportFile], {
    cwd: ROOT,
    encoding: 'utf8',
    timeout: 300000,
    maxBuffer: 32 * 1024 * 1024,
  });
  assert.equal(r.status, 0, 'the pipeline accepts the file');
  assert.match(r.stdout + r.stderr, /result \(vm-ir\)/, 'reported as vm-ir, not devirtualized');
  assert.match(r.stdout + r.stderr, /VM payload decoded, not lifted/, 'the reason is printed');

  const report = JSON.parse(fs.readFileSync(reportFile, 'utf8'));
  assert.equal(report.result_type, 'vm-ir');
  assert.ok(report.warnings.some((w) => /preserved \d+ VM instructions as IR/.test(w)), 'the warning is recorded');
  fs.rmSync(dir, { recursive: true, force: true });
});

test('LuaObfuscator: a vm-ir preset still has to become runnable source', {
  skip: luaparse ? 'TODO(struct-lift): the VM presets need the interpreter de-CFFed before the payload can be lifted' : 'luaparse is not installed',
}, () => {
  for (const sample of VM_PRESETS) {
    const original = sandboxPrints(path.join(IN, sample));
    const lifted = sandboxPrints(path.join(ROOT, 'samples', 'output', 'LuaObfuscator', sample));
    const signature = (lines) => lines.find((l) => /\[Nebula\] Loaded OK/.test(l));
    assert.equal(signature(lifted), signature(original), `${sample}: same signature as the original`);
  }
});
