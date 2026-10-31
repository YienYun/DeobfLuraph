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
// A second build of the same script at OBFUSCATE (old): its interpreter has a
// dispatch the analyzer can read, so the whole payload is classified and the
// result is a register machine -- decoded, but still not Luau source.
const MACHINE_PRESETS = ['Obfucate_Old2.lua'];

function hasLuaparse() {
  const probe = spawnSync(process.execPath, ['-e', "require.resolve('luaparse')"], { cwd: ROOT });
  return probe.status === 0;
}
const luaparse = hasLuaparse();
const luaparseSkip = luaparse ? false : 'luaparse is not installed (run npm install)';
// The corpus is local-only (see samples/README.md): the files are not checked
// in, so these tests skip on a fresh clone instead of failing on missing input.
const absent = [...SOURCE_PRESETS, ...VM_PRESETS, ...MACHINE_PRESETS]
  .find((name) => !fs.existsSync(path.join(IN, name)));
const SKIP = luaparseSkip || (absent ? `samples/input/LuaObfuscator/${absent} is not present (corpus is local-only)` : false);

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
  for (const sample of [...SOURCE_PRESETS, ...VM_PRESETS, ...MACHINE_PRESETS]) {
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

for (const sample of MACHINE_PRESETS) {
  test(`LuaObfuscator: ${sample} decodes every instruction and restructures the control flow`, { skip: SKIP }, () => {
    const { code, stats } = deobf(sample);
    assert.equal(stats.outputMode, 'devirtualized', 'no instruction is left unclassified');
    assert.equal(stats.stats.vmPreservedInstructions, 0, 'nothing is preserved as raw IR');
    assert.equal(stats.stats.vmSuperinstructionError, null, 'the interpreter analysis succeeds');
    assert.match(code, /local protos = \{\}/, 'the proto table is rebuilt');
    assert.match(code, /^-- LuaObfuscator: register machine restructured to Luau/m, 'the header says what it is');
    // the listing's labels and gotos are gone: this is Luau, not assembly
    assert.ok(!/^\s*::L\d+::/m.test(code), 'no labels survive');
    assert.ok(!/\bgoto\s+L\d+/.test(code), 'no goto survives');
    assert.match(code, /while true do/, 'loops are rebuilt');
  });

  test(`LuaObfuscator: ${sample} output parses as Luau`, { skip: SKIP }, () => {
    const { code } = deobf(sample);
    assert.ok(isValidLuaSyntax(code), 'the restructured output parses');
    assert.ok(code.split('\n').length > 1000, `expected the whole payload, got ${code.split('\n').length} lines`);
  });

  test(`LuaObfuscator: ${sample} is reported as devirtualized, not machine`, { skip: SKIP }, () => {
    const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'lo-machine-'));
    const out = path.join(dir, 'structured.lua');
    const reportFile = path.join(dir, 'report.json');
    const r = spawnSync(process.execPath, [path.join(ROOT, 'deob.js'), path.join(IN, sample), '-o', out, '--report', reportFile], {
      cwd: ROOT, encoding: 'utf8', timeout: 300000, maxBuffer: 32 * 1024 * 1024,
    });
    assert.equal(r.status, 0);
    assert.match(r.stderr, /result \(devirtualized\)/);
    const report = JSON.parse(fs.readFileSync(reportFile, 'utf8'));
    assert.equal(report.result_type, 'devirtualized');
    fs.rmSync(dir, { recursive: true, force: true });
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
