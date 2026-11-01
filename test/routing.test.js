'use strict';

// Where a result lands is decided by one function, and it must never write into
// the folder it read from: `samples/input/<sub>/x.lua` goes to
// `samples/output/<sub>/x.lua`, whatever the nesting.

const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('path');

const { resolveDefaultOutdir } = require('../deob');

test('a file under input/ is written to the sibling output/ folder, never back into input/', () => {
  const base = path.join(path.sep, 'repo', 'samples');

  assert.equal(
    resolveDefaultOutdir(path.join(base, 'input', 'Luraph', 'script.lua')),
    path.join(base, 'output', 'Luraph')
  );
  assert.equal(
    resolveDefaultOutdir(path.join(base, 'input', 'Mystery', 'deep', 'script.lua')),
    path.join(base, 'output', 'Mystery', 'deep')
  );
  assert.equal(
    resolveDefaultOutdir(path.join(base, 'input', 'script.lua')),
    path.join(base, 'output')
  );

  // anywhere else: an `output/` folder next to the input
  assert.equal(
    resolveDefaultOutdir(path.join(path.sep, 'tmp', 'script.lua')),
    path.join(path.sep, 'tmp', 'output')
  );

  for (const input of ['a/b/input/x.lua', 'input/x.lua']) {
    const out = resolveDefaultOutdir(path.resolve(path.sep, 'r', input));
    assert.ok(!out.split(path.sep).includes('input'), `output must not nest inside input: ${out}`);
  }
});
