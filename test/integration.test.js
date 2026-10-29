'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('path');
const fs = require('fs');
const os = require('os');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
const exe = (name, override) => override || path.join(ROOT, 'bin', process.platform === 'win32' ? name + '.exe' : name);
const luau = exe('luau', process.env.LUAU_BIN);
const ast = exe('luau-ast', process.env.LUAU_AST_BIN);
function executable(file) {
  const result = spawnSync(file, ['--help'], { stdio: 'ignore', timeout: 5000, windowsHide: true });
  return !result.error && result.status === 0;
}
const available = executable(luau) && executable(ast);
const skip = available ? false : 'compatible Luau and luau-ast required; set LUAU_BIN and LUAU_AST_BIN';

function runCli(args, opts = {}) {
  return spawnSync(process.execPath, [path.join(ROOT, 'deob.js'), ...args], {
    cwd: ROOT, encoding: 'utf8', timeout: 240000, maxBuffer: 32 * 1024 * 1024,
    env: { ...process.env, LUAU_BIN: luau, LUAU_AST_BIN: ast }, ...opts,
  });
}
function temp(t) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'deobf-integration-'));
  t.after(() => fs.rmSync(dir, { recursive: true, force: true }));
  return dir;
}

test('refuses to overwrite the input even before starting the runtime', t => {
  const dir = temp(t);
  const input = path.join(dir, 'input.lua');
  fs.writeFileSync(input, 'print("keep me")\n');
  const r = runCli([input, '-o', input]);
  assert.notEqual(r.status, 0);
  assert.match(r.stderr, /must not overwrite the input/);
  assert.equal(fs.readFileSync(input, 'utf8'), 'print("keep me")\n');
});

test('generic trace and errors are labeled in the structured report', { skip }, t => {
  const dir = temp(t);
  const input = path.join(dir, 'input.lua');
  const output = path.join(dir, 'result.lua');
  const report = path.join(dir, 'report.json');
  fs.writeFileSync(input, 'print("integration smoke")\n');
  const r = runCli([input, '-o', output, '--report', report, '--no-devirt']);
  assert.equal(r.status, 0, r.stderr);
  assert.match(fs.readFileSync(output, 'utf8'), /print\("integration smoke"\)/);
  const json = JSON.parse(fs.readFileSync(report));
  assert.equal(json.result_type, 'trace');
  assert.equal(json.trace_status, 'finished');
  assert.equal(json.obfuscator, 'generic');

  fs.writeFileSync(input, 'error("intentional test error")\n');
  const failedTrace = runCli([input, '-o', output, '--report', report]);
  assert.equal(failedTrace.status, 0, failedTrace.stderr);
  const failedReport = JSON.parse(fs.readFileSync(report));
  assert.equal(failedReport.result_type, 'trace');
  assert.match(failedReport.trace_status, /script error/);
  assert.ok(failedReport.warnings.some(w => /did not finish normally/.test(w)));
  assert.ok(failedReport.warnings.some(w => /only a behaviour trace/.test(w)));
});

test('hard Luau timeout fails rather than returning a fake result for a stuck script', { skip }, t => {
  const dir = temp(t);
  const input = path.join(dir, 'loop.lua');
  const output = path.join(dir, 'result.lua');
  const report = path.join(dir, 'report.json');
  fs.writeFileSync(input, 'while true do end');
  const r = runCli([input, '-o', output, '--report', report, '--timeout', '1']);
  assert.notEqual(r.status, 0);
  assert.match(r.stderr, /timed out/);
  assert.equal(fs.existsSync(output), false);
  assert.equal(fs.existsSync(report), false);
});

test('batch mode never overwrites a single -o path for several files', { skip }, t => {
  const dir = temp(t);
  fs.writeFileSync(path.join(dir, 'a.lua'), 'print("a")');
  fs.writeFileSync(path.join(dir, 'b.lua'), 'print("b")');
  const destination = path.join(dir, 'ignored.lua');
  const r = runCli([dir, '-o', destination, '--no-devirt']);
  assert.equal(r.status, 0, r.stderr);
  assert.match(r.stderr, /--output is ignored/);
  assert.equal(fs.existsSync(destination), false);
  assert.match(fs.readFileSync(path.join(dir, 'output', 'a.lua'), 'utf8'), /print\("a"\)/);
  assert.match(fs.readFileSync(path.join(dir, 'output', 'b.lua'), 'utf8'), /print\("b"\)/);
});

test('trace mode in debug still writes a result and strings sidecar', { skip }, t => {
  const dir = temp(t);
  const input = path.join(dir, 'input.lua');
  const output = path.join(dir, 'result.lua');
  fs.writeFileSync(input, 'print("hello debug")');
  const r = runCli([input, '-o', output, '--no-devirt', '--debug', '--strings']);
  assert.equal(r.status, 0, r.stderr);
  assert.ok(fs.existsSync(output));
  assert.ok(fs.existsSync(output + '.strings.txt'));
});

test('full Luraph v15.0 ChilliLibraryEngine2 devirtualizes cleanly into valid Luau', { skip, timeout: 180000 }, t => {
  const dir = temp(t);
  const sample = path.join(ROOT, 'samples', 'ChilliLibraryEngine2_v15.0_obfuscated.lua');
  const output = path.join(dir, 'chilli_out.lua');
  const report = path.join(dir, 'report.json');
  const r = runCli([sample, '-o', output, '--report', report]);
  assert.equal(r.status, 0, r.stderr);
  const text = fs.readFileSync(output, 'utf8');
  assert.match(text, /ChilliLibrary:Finalize\(\)/);
  assert.equal(spawnSync(ast, [output], { stdio: 'ignore' }).status, 0);
  const result = JSON.parse(fs.readFileSync(report, 'utf8'));
  assert.equal(result.result_type, 'devirtualized');
  assert.equal(result.trace_status, 'finished');
  assert.equal(result.lift_stats.errors, 0);
  assert.equal(result.lift_stats.fallbacks, 0);
  assert.doesNotMatch(text, /_lph_setlist/);
  assert.doesNotMatch(text, /error\("devirt:/);
});

test('debug mode never returns a stale devirtualization from a previous run', { skip }, t => {
  const dir = temp(t);
  const input = path.join(dir, 'input.lua');
  const outputDir = path.join(dir, 'output');
  fs.mkdirSync(outputDir);
  fs.writeFileSync(input, '-- This file was protected using Luraph Obfuscator v15.1 [https://lura.ph/]\nprint("fresh")\n');
  fs.writeFileSync(path.join(outputDir, 'input.devirt.luau'), 'print("STALE")\n');
  const output = path.join(dir, 'result.luau');
  const report = path.join(dir, 'report.json');
  const r = runCli([input, '-o', output, '--report', report, '--debug', '--cfg-json', '{"devirt":false}']);
  assert.equal(r.status, 0, r.stderr);
  assert.equal(JSON.parse(fs.readFileSync(report)).result_type, 'trace');
  assert.doesNotMatch(fs.readFileSync(output, 'utf8'), /STALE/);
});
