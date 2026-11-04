'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');

const detect = require('../src/detect');

const V15_HEADER = '-- This file was protected using Luraph Obfuscator v15.0 [https://lura.ph/]\nreturn setmetatable({},{})';
const V14_HEADER = '-- This file was protected using Luraph Obfuscator v14.8 [https://lura.ph/]\nreturn({})';
const V14_OLD = '-- This file was protected using Luraph Obfuscator v14.2 [https://lura.ph/]\nreturn({})';

test('Luraph header: major 15 is certain, other majors are only a hint', () => {
  const v15 = detect.detect(V15_HEADER);
  assert.equal(v15.plugin.name, 'luraph_v15');
  assert.equal(v15.confidence, 1);

  const v14 = detect.detect(V14_HEADER);
  assert.equal(v14.plugin.name, 'luraph_v14');
  assert.equal(v14.confidence, 1);
});

test('14.7-14.9 score higher than older 14.x builds', () => {
  assert.equal(detect.detect(V14_HEADER).confidence, 1);
  assert.equal(detect.detect(V14_OLD).confidence, 0.8);
});

test('a header-stripped v14 table still names the family', () => {
  const src = 'return({A,B,C},function()return A end)';
  assert.equal(detect.detect(src).plugin.name, 'luraph_v14');
});

test('a v15 VM shape without a header is recognised', () => {
  const src = 'local a = 1\nreturn setmetatable({[1]=bit32.bxor,[2]=buffer.readu8},{})';
  assert.equal(detect.detect(src).plugin.name, 'luraph_v15');
  assert.equal(detect.detect(src).confidence, 0.8);
});

test('plain Lua is not claimed to be obfuscated', () => {
  const r = detect.detect('local x = 1\nprint(x)\n');
  assert.equal(r.plugin.name, 'generic');
  assert.equal(r.confidence, 0);
});

test('the Luarmor chain is recognised ahead of the Luraph chunk it carries', () => {
  const src = [
    'local _bsdata0 = {1,2,3}',
    'local superflow_bytecode = {4,5,6}',
    '-- This file was protected using Luraph Obfuscator v15.0 [https://lura.ph/]',
    'return setmetatable({[1]=bit32.bxor},{})',
  ].join('\n');
  const r = detect.detect(src);
  assert.equal(r.plugin.name, 'luarmor_client');
  assert.ok(r.confidence >= 0.95);
});

test('engine names and aliases resolve, unknown names throw', () => {
  assert.equal(detect.byName('luraph').name, 'luraph_v15');
  assert.equal(detect.byName('luraph_v14_8').name, 'luraph_v14');
  assert.equal(detect.byName('luarmor').name, 'luarmor_client');
  assert.equal(detect.byName('generic').name, 'generic');
  assert.throws(() => detect.byName('nope'), /Unknown obfuscator 'nope'/);
});

test('a header that lost its newline is split back out', () => {
  const broken = '-- This file was protected using Luraph Obfuscator v15.0 [https://lura.ph/]return setmetatable({},{})';
  const fixed = detect.restoreHeaderNewline(broken);
  assert.ok(fixed.startsWith('-- This file was protected using Luraph Obfuscator v15.0 [https://lura.ph/]\n'));
  assert.equal(detect.restoreHeaderNewline(V15_HEADER), V15_HEADER);
});

test('every plugin has a name, a label and a detector', () => {
  for (const plugin of detect.PLUGINS) {
    assert.equal(typeof plugin.name, 'string');
    assert.ok(plugin.name.length > 0);
    assert.equal(typeof plugin.label, 'string');
    assert.equal(typeof plugin.detect, 'function');
  }
  const names = detect.PLUGINS.map((p) => p.name);
  assert.equal(new Set(names).size, names.length, 'plugin names must be unique');
});
