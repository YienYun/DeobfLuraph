'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');

const detect = require('../../node/detect');
const engines = require('../../node/engines');

test('this build ships the Luraph engines and refuses the rest', () => {
  assert.equal(engines.NOT_SHIPPED.luraph_v14, undefined, 'v14 must stay dispatchable');
  assert.equal(engines.NOT_SHIPPED.luraph_v15, 'handled by src/driver.js');
  assert.match(engines.NOT_SHIPPED.moonveil, /Luraph-only/);
});

test('MoonVeil is named, then refused with a reason', async () => {
  const src = '-- generated using MoonVeil Obfuscator v2.1\nreturn({},{function(a,b)return function() end end})';
  assert.equal(detect.detect(src).plugin.name, 'moonveil');
  await assert.rejects(
    engines.runPlugin('moonveil', { args: {} }),
    /MoonVeil \(this build is Luraph-only\).*is not part of this build/,
  );
});

test('the removed obfuscators are refused too, and not silently traced', async () => {
  for (const [name, label] of [
    ['moonsec', 'MoonSec'],
    ['prometheus', 'Prometheus'],
    ['ironbrew2', 'IronBrew'],
    ['luraph_v15_unknown_thing', 'luraph_v15_unknown_thing'],
  ]) {
    await assert.rejects(engines.runPlugin(name, { args: {} }), (err) => {
      assert.match(err.message, /is not part of this build/, name);
      assert.ok(err.message.includes(label), `${name}: message lost its label (${err.message})`);
      return true;
    });
  }
});
