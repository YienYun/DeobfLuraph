'use strict';

// The bit32 chain fold (core/bitfold.py) rewrites fifty-odd written-out steps
// into a loop. That is only allowed if the loop computes exactly what the steps
// computed, so this test runs both on random inputs inside the real Luau
// interpreter (scripts/bitfold_verify.py) and fails on any difference, on a
// chain folded that only repeats twice, and when the verifier can be fooled by a
// deliberately wrong helper.

const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('path');
const fs = require('fs');
const os = require('os');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
const luau = process.env.LUAU_BIN || path.join(ROOT, 'bin', process.platform === 'win32' ? 'luau.exe' : 'luau');
const available = !spawnSync(luau, ['--help'], { stdio: 'ignore', timeout: 5000 }).error;
const skip = available ? false : 'a Luau interpreter is required; set LUAU_BIN';

function verify(args) {
  return spawnSync('python3', [path.join(ROOT, 'scripts', 'bitfold_verify.py'), ...args], {
    cwd: ROOT, encoding: 'utf8', timeout: 120000,
  });
}

test('a folded bit32 chain computes exactly what the unrolled statements computed', { skip }, () => {
  const r = verify([]);
  assert.equal(r.status, 0, r.stdout + r.stderr);
  assert.match(r.stdout, /^PASS /);
});

test('the differential checker rejects a helper with one wrong constant or one repetition too few', { skip }, t => {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'deobf-bitfold-'));
  t.after(() => fs.rmSync(dir, { recursive: true, force: true }));
  const before = path.join(dir, 'before.lua');
  const after = path.join(dir, 'after.lua');
  const bad = path.join(dir, 'bad.lua');

  // fold the fixture the verifier itself uses, so this test needs no sample
  const py = spawnSync('python3', ['-c', [
    'import sys; sys.path.insert(0, "core");',
    'import bitfold, importlib.util;',
    'spec = importlib.util.spec_from_file_location("bv", "scripts/bitfold_verify.py");',
    'bv = importlib.util.module_from_spec(spec); spec.loader.exec_module(bv);',
    'src = bv.synthetic();',
    'open(sys.argv[1], "w").write(src);',
    'open(sys.argv[2], "w").write(bitfold.fold_chains(src));',
  ].join(' '), before, after], { cwd: ROOT, encoding: 'utf8' });
  assert.equal(py.status, 0, py.stderr);

  const good = verify(['--before', before, '--after', after]);
  assert.equal(good.status, 0, good.stdout + good.stderr);

  // one constant off
  fs.writeFileSync(bad, fs.readFileSync(after, 'utf8').replace(/lshift\((\w+), 14\)/, 'lshift($1, 15)'));
  const wrong = verify(['--before', before, '--after', bad]);
  assert.notEqual(wrong.status, 0);
  assert.match(wrong.stdout, /^FAIL /);

  // one repetition short
  fs.writeFileSync(bad, fs.readFileSync(after, 'utf8').replace(/for _ = 1, 4 do/, 'for _ = 1, 3 do'));
  const short = verify(['--before', before, '--after', bad]);
  assert.notEqual(short.status, 0);
  assert.match(short.stdout, /^FAIL /);
});
