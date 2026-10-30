'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const detect = require('../src/detect');
const { luac32To64, decompileLua51Bytecode } = require('../src/luac_decompile');

const ROOT = path.resolve(__dirname, '..');

test('multi-obfuscator detector classifies MoonSec, MoonVeil, Prometheus, PSU, IronBrew, Hercules, LuaObfuscator and more', () => {
  const cases = [
    ['-- This file was protected using Luraph Obfuscator v15.1 [https://lura.ph/]', 'luraph_v15'],
    ['-- This file was protected using Luraph Obfuscator v14.7 [https://lura.ph/]', 'luraph_v14'],
    ['-- This file was protected using Luraph Obfuscator v14.8 [https://lura.ph/]', 'luraph_v14'],
    ['-- This file was protected using Luraph Obfuscator v14.9 [https://lura.ph/]', 'luraph_v14'],
    ['-- This file was generated using Luraph Obfuscator v14.4', 'generic'],
    ['--[[ This file was protected with MoonSec V3 ]] return(function() end)()', 'moonsec'],
    ['-- ..:::MoonSec::.. V2', 'moonsec'],
    ['-- This script was generated using MoonVeil 2.0.26 [https://moonveil.cc]', 'moonveil'],
    ['return({{},function(p,g)return function(k,d)local i=0b10100110 end end})', 'moonveil'],
    ['-- Obfuscated using Prometheus Obfuscator', 'prometheus'],
    ['return(function(...)local w={"\\069\\066\\081","\\104\\101\\108\\108\\111"} end)()', 'prometheus'],
    ['-- Protected by PSU Obfuscator v4.5', 'psu'],
    ['local x = "PSU|102938102938"', 'psu'],
    ['-- this file was generated using ironbrew1\nreturn 1', 'ironbrew1'],
    ['--[[ AztupBrew(Fork of IronBrew2): obfuscation; Version 2.7.2 ]]', 'ironbrew2'],
    ['local p=getfenv or function()return _ENV end;local a=string.byte;local b=setmetatable;', 'ironbrew2'],
    ['-- Obfuscated by Hercules v1.6', 'hercules'],
    ['return WrapState(BcToState("abc"))', 'hercules'],
    ['-- LuaObfuscator.com', 'luaobfuscator'],
    ['local v0=tonumber;local v1=string.byte;local v2=string.char;', 'luaobfuscator'],
    ['-- Protected with Goofyscator', 'goofyscator'],
    ['--[[ Obfuscated using ironveil v1 ]]', 'ironveil'],
    ['-- 77fuscator | 77FUS|abc', 'f77'],
    ['local payload = "XHD:998877"', 'xhider'],
    ['-- herrtt boronide', 'boronide'],
    ['--ironbrew3: payload', 'ironbrew3'],
    ['local SynapseXen_iiiI = 1', 'synapsexen'],
    ['-- wYnFuscate', 'wynfuscate'],
  ];

  for (const [sample, expected] of cases) {
    const got = detect.detect(sample);
    assert.equal(got.plugin.name, expected, `Expected ${expected} for sample: ${sample.slice(0, 60)}`);
    if (expected !== 'generic') {
      assert.ok(got.confidence >= 0.5, `Expected >= 0.5 confidence for ${expected}`);
    }
  }

  assert.equal(detect.byName('luraph_v14_8').name, 'luraph_v14');
  assert.equal(detect.byName('moonsec_v3').name, 'moonsec');
  assert.equal(detect.byName('ib2').name, 'ironbrew2');
});

test('input/ subfolder automatically routes deobfuscated output to sibling output/ folder without auto-rename', t => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'deobf-io-split-'));
  t.after(() => fs.rmSync(dir, { recursive: true, force: true }));

  const inDir = path.join(dir, 'input');
  const outDir = path.join(dir, 'output');
  fs.mkdirSync(inDir, { recursive: true });
  fs.mkdirSync(outDir, { recursive: true });

  const inFile = path.join(inDir, 'hello.lua');
  const reportFile = path.join(dir, 'report.json');
  fs.writeFileSync(inFile, '-- LuaObfuscator.com\nlocal v0 = "Hello Multi Deobf"\nprint(v0)\n', 'utf8');

  const r = spawnSync(process.execPath, [path.join(ROOT, 'deob.js'), inFile, '--report', reportFile], {
    cwd: ROOT,
    encoding: 'utf8',
    timeout: 60000,
  });
  assert.equal(r.status, 0, r.stderr);

  const expectedOut = path.join(outDir, 'hello.lua');
  assert.ok(fs.existsSync(expectedOut), 'expected output inside sibling output/ folder');
  assert.equal(fs.existsSync(path.join(inDir, 'output')), false, 'must not create input/output/ nested folder');

  const outCode = fs.readFileSync(expectedOut, 'utf8');
  assert.match(outCode, /Hello Multi Deobf/);

  const rep = JSON.parse(fs.readFileSync(reportFile, 'utf8'));
  assert.equal(rep.obfuscator, 'luaobfuscator');
  assert.equal(rep.result_type, 'devirtualized');
  assert.equal(rep.rename_stats, undefined, 'renamer must stay off unless --rename is explicitly passed');
});

test('native Lua 5.1 bytecode compiler + luac32To64 + luadec/decom pipeline recovers Lua source cleanly', t => {
  const lua51c = path.join(ROOT, 'bin', 'lua5.1');
  if (!fs.existsSync(lua51c) || process.platform === 'win32') {
    t.skip('native Linux lua5.1 binary not present');
    return;
  }
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'luac-roundtrip-'));
  t.after(() => fs.rmSync(dir, { recursive: true, force: true }));

  const dumpScript = path.join(dir, 'make_chunk.lua');
  const chunkPath = path.join(dir, 'sample.luac');
  fs.writeFileSync(
    dumpScript,
    [
      'local function target(a, b)',
      '  return a + b * 3, "DECOMP_OK"',
      'end',
      `local f = assert(io.open(${JSON.stringify(chunkPath)}, "wb"))`,
      'f:write(string.dump(target))',
      'f:close()',
    ].join('\n'),
    'utf8'
  );
  const build = spawnSync(lua51c, [dumpScript], { encoding: 'utf8' });
  assert.equal(build.status, 0, build.stderr);

  const raw = fs.readFileSync(chunkPath);
  const decompiled = decompileLua51Bytecode(luac32To64(raw));
  assert.match(decompiled, /DECOMP_OK/);
});
