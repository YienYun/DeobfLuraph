'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');

const { diagnoseTrace } = require('../src/driver');

test('a finished run has nothing to diagnose', () => {
  assert.equal(diagnoseTrace('finished', ''), null);
  assert.equal(diagnoseTrace(undefined, ''), null);
});

test('a method the file never defines is reported as an incomplete capture', () => {
  const src = 'return setmetatable({ g = function() end }, {}):pW()(...);';
  const out = diagnoseTrace("script error: Script:3: attempt to call missing method 'pW' of table", src);
  assert.match(out, /nothing in the file defines/);
  assert.match(out, /incomplete/);
});

test('a method the file does define is reported as an unanswered call', () => {
  const src = 'local t = { pW = function() return 1 end }; return t:pW();';
  const out = diagnoseTrace("script error: Script:3: attempt to call missing method 'pW' of table", src);
  assert.match(out, /does not answer it/);
  assert.doesNotMatch(out, /incomplete/);
});

test('a quoted key counts as a definition', () => {
  const src = 'local t = { ["pW"] = 1 }; return t;';
  const out = diagnoseTrace("attempt to call missing method 'pW' of table", src);
  assert.doesNotMatch(out, /incomplete/);
});

test('plain nil failures get a structural sentence', () => {
  assert.match(diagnoseTrace("attempt to index nil with 'IFKI'", ''), /indexing a nil value/);
  assert.match(diagnoseTrace('attempt to call a nil value', ''), /nil value where the script expected one/);
});

test('an unmatched status has no diagnosis rather than a guess', () => {
  assert.equal(diagnoseTrace('stopped in an endless loop (truncated)', ''), null);
});
