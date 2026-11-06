'use strict';


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
  const source = fs.readFileSync(path.join(DIR, file), 'utf8');
  const delivered = /^-- deobf: needs the hub at run time$/m.test(source);
  test(`result runs without a runtime error: ${file}`, () => {
    const res = smoke(path.join(DIR, file), { timeout: 120 });
    assert.equal(res.status, 0, `luau exited ${res.status}: ${res.stderr.slice(0, 400)}`);
    if (delivered) {
      const explained = /\[deobf\] this script needs/.test(res.runStatus) || /finished/.test(res.runStatus);
      assert.ok(explained, `expected the delivery stub or a clean stop, got: ${res.runStatus}`);
      return;
    }
    assert.ok(!res.failed, `run stopped: ${res.runStatus}`);
    assert.match(res.runStatus, /finished/, `unexpected run status: ${res.runStatus}`);
  });
}
