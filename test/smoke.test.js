'use strict';

// The compile gate only says the file parses. These run every result inside the
// stub environment the tracer uses, so a register that lost its value -- "attempt
// to call a table value", "attempt to index nil" -- fails here instead of on the
// user's executor. It is the check that was missing when a copy fold ate a store
// a loop read on its next pass.

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const { smoke } = require(path.join(ROOT, 'scripts', 'smoke.js'));

const DIR = path.join(ROOT, 'results');
const files = fs.existsSync(DIR)
  ? fs.readdirSync(DIR).filter((f) => f.endsWith('.deobf.luau')).sort()
  : [];

for (const file of files) {
  // A carrier build whose script is fetched at run time cannot finish outside its
  // hub. The file says so in its header, and the run has to stop at that message
  // rather than somewhere inside code the reader is meant to follow.
  const source = fs.readFileSync(path.join(DIR, file), 'utf8');
  const delivered = /^-- deobf: needs the hub at run time$/m.test(source);
  test(`result runs without a runtime error: ${file}`, () => {
    const res = smoke(path.join(DIR, file), { timeout: 120 });
    assert.equal(res.status, 0, `luau exited ${res.status}: ${res.stderr.slice(0, 400)}`);
    if (delivered) {
      assert.match(res.runStatus, /\[deobf\] this script needs/,
        `expected the delivery stub to report, got: ${res.runStatus}`);
      return;
    }
    assert.ok(!res.failed, `run stopped: ${res.runStatus}`);
    assert.match(res.runStatus, /finished/, `unexpected run status: ${res.runStatus}`);
  });
}
