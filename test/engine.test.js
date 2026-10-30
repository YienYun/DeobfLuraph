'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('path');
const fs = require('fs');
const os = require('os');
const { spawnSync } = require('child_process');
const detect = require('../src/detect');
const harness = require('../src/harness');
const trace = require('../src/traceout');
const vmmap = require('../src/vmmap');
const tidy = require('../src/tidy');
const { parseArgs, collectInputFiles, sameExistingFile } = require('../deob');
const { getPythonBin } = require('../src/pyenv');

const ROOT = path.resolve(__dirname, '..');

test('detects Luraph v15, unsupported v14 and generic sources without execution', t => {
  const synth150 = '-- This file was protected using Luraph Obfuscator v15.0 [https://lura.ph/]\nreturn setmetatable({[1]=bit32.bxor},{})';
  const synth151 = '-- This file was protected using Luraph Obfuscator v15.1 [https://lura.ph/]\nreturn setmetatable({[1]=buffer.create},{})';
  assert.deepEqual([detect.detect(synth150).plugin.name, detect.detect(synth150).confidence], ['luraph_v15', 1]);
  assert.deepEqual([detect.detect(synth151).plugin.name, detect.detect(synth151).confidence], ['luraph_v15', 1]);
  assert.equal(detect.detect('-- This file was protected using Luraph Obfuscator v14.4').plugin.name, 'generic');
  assert.equal(detect.detect('-- This file was protected using Luraph Obfuscator v14.8').plugin.name, 'luraph_v14');
  assert.equal(detect.detect('print("normal Lua")').plugin.name, 'generic');
  assert.equal(detect.detect('luarmor.net; luraph_runtime1()').plugin.name, 'luarmor_client');
  assert.equal(detect.detect('superflow_bytecode={"\\62\\233"}; return setmetatable({[1]=bit32.bxor},{})').plugin.name, 'luarmor_client');
  assert.equal(detect.detect('_bsdata0={1,2}; game:HttpGet("https://cdn.luarmor.net/v4_init_ocendmz.lua")').plugin.name, 'luarmor_client');

  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'deobf-detect-cli-'));
  t.after(() => fs.rmSync(dir, { recursive: true, force: true }));
  const tmpSample = path.join(dir, 'sample150.lua');
  fs.writeFileSync(tmpSample, synth150, 'latin1');
  const result = spawnSync(process.execPath, ['deob.js', tmpSample, '--detect'], {
    cwd: ROOT, env: { ...process.env, LUAU_BIN: '/not/a/runtime', LUAU_AST_BIN: '/not/an/ast' }, encoding: 'utf8',
  });
  assert.equal(result.status, 0, result.stderr);
  assert.match(result.stdout, /luraph_v15\s+1\.00/);
});

test('only restores a lost newline at the beginning, without altering a complete header', () => {
  const header = '-- This file was protected using Luraph Obfuscator v15.1 [https://lura.ph/]';
  assert.equal(detect.restoreHeaderNewline(header + '  return 1'), header + '\nreturn 1');
  assert.equal(detect.restoreHeaderNewline(header + '\nreturn 1'), header + '\nreturn 1');
  assert.equal(detect.restoreHeaderNewline(header), header);
  const later = 'print("hi")\n' + header + ' x';
  assert.equal(detect.restoreHeaderNewline(later), later);
});

test('argument parser fails early for missing, unknown and invalid options', () => {
  assert.throws(() => parseArgs(['x.lua', '--output']), /needs a value/);
  assert.throws(() => parseArgs(['x.lua', '--output', '--detect']), /needs a value/);
  assert.throws(() => parseArgs(['x.lua', '--budget', '3oops']), /positive integer/);
  assert.throws(() => parseArgs(['x.lua', '--max-runs', '0']), /positive integer/);
  assert.throws(() => parseArgs(['x.lua', '--unknown']), /unknown option/);
  assert.throws(() => parseArgs(['x.lua', '--cfg-json', '[]']), /JSON object/);
  assert.equal(parseArgs(['x.lua', '--input-text', '-test']).inputText, '-test');
});

test('refuses to treat symlinks and hardlinks to input as safe outputs', t => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'deobf-path-test-'));
  t.after(() => fs.rmSync(dir, { recursive: true, force: true }));
  const input = path.join(dir, 'in.lua');
  fs.writeFileSync(input, 'print(1)');
  assert.equal(sameExistingFile(input, input), true);
  assert.equal(sameExistingFile(input, path.join(dir, 'other.lua')), false);
  const hard = path.join(dir, 'hard.lua');
  fs.linkSync(input, hard);
  assert.equal(sameExistingFile(input, hard), true);
});

test('chunk hash matches the Python backend for latin-1 and large sources', () => {
  const values = [Buffer.alloc(0), Buffer.from('hello'), Buffer.from([0, 128, 255, 10, 93]), Buffer.alloc(10000, 255)];
  const script = [
    'import base64,json,sys',
    'sys.path.insert(0, sys.argv[1])',
    'import harness',
    'print(json.dumps([harness.chunk_key(base64.b64decode(x).decode("latin-1")) for x in json.load(sys.stdin)]))',
  ].join(';');
  const result = spawnSync(getPythonBin(), ['-c', script, path.join(ROOT, 'core')], {
    input: JSON.stringify(values.map(v => v.toString('base64'))), encoding: 'utf8',
  });
  assert.equal(result.status, 0, result.stderr);
  assert.deepEqual(values.map(v => harness.chunkKey(v.toString('latin1'))), JSON.parse(result.stdout));
});

test('protocol nonce changes per harness and forged untagged markers are ignored', () => {
  harness.buildHarness('print(1)', {});
  const first = harness.getMark();
  assert.match(first, /^[a-f0-9]{16}$/);
  harness.buildHarness('print(2)', {});
  assert.notEqual(harness.getMark(), first);
  const forged = '\x00PROTOS forged\nordinary\n';
  assert.deepEqual(trace.takeLine(forged, 'PROTOS'), [null, forged]);
  const real = harness.mark('PROTOS ') + 'value\n' + forged;
  assert.deepEqual(trace.takeLine(real, 'PROTOS'), ['value', forged]);
});

test('Node spin instrumentation agrees with the original Python algorithm', () => {
  const inputs = [
    'while true do local x=a[b]; if x then break end end',
    'repeat x[2]=n; local a,b=c,d[p] if a then end until false',
    'while true do print("not a VM dispatch") end',
    'repeat o=(a[b]);local z=1 until false',
  ];
  const script = [
    'import json,sys',
    'sys.path.insert(0, sys.argv[1])',
    'from obfuscators.luraph_v15.driver import patch_spin',
    'print(json.dumps([patch_spin(s) for s in json.load(sys.stdin)]))',
  ].join(';');
  const result = spawnSync(getPythonBin(), ['-c', script, path.join(ROOT, 'core')], {
    input: JSON.stringify(inputs), encoding: 'utf8',
  });
  assert.equal(result.status, 0, result.stderr);
  assert.deepEqual(inputs.map(vmmap.patchSpin), JSON.parse(result.stdout));
});

test('trace formatting preserves instrumentation and multiline string contents', () => {
  const source = '--@1 5\nprint([=[\n--@2 this is string data\n]=])\n';
  assert.equal(tidy.tidy(source), source);
});

test('collectInputFiles accepts explicit .txt files while scanning folders only for .lua/.luau', t => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'deobf-collect-test-'));
  t.after(() => fs.rmSync(dir, { recursive: true, force: true }));
  const luaFile = path.join(dir, 'a.lua');
  const luauFile = path.join(dir, 'b.luau');
  const txtFile = path.join(dir, 'message.txt');
  fs.writeFileSync(luaFile, 'print(1)');
  fs.writeFileSync(luauFile, 'print(2)');
  fs.writeFileSync(txtFile, 'print(3)');
  assert.deepEqual(collectInputFiles([dir]).sort(), [luaFile, luauFile].sort());
  assert.deepEqual(collectInputFiles([txtFile]), [txtFile]);
});
