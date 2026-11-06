'use strict';


const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const { formatLuau, available } = require('../src/format');
const { isValidLuaSyntax } = require('../src/luau_check');

const LUAU = path.join(ROOT, 'bin', 'luau');

function run(src) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'fmt-'));
  const file = path.join(dir, 'case.luau');
  fs.writeFileSync(file, src);
  const r = spawnSync(LUAU, [file], { cwd: ROOT, encoding: 'utf8' });
  fs.rmSync(dir, { recursive: true, force: true });
  assert.equal(r.status, 0, r.stderr);
  return r.stdout;
}

const MESSY = [
  'local a=1',
  'local b   =  {1,2,   3}',
  'if a==1 then print( b[1] )  end',
  'for i=1,3 do',
  '  print(i)',
  'end',
  '',
].join('\n');

test('the formatter is installed', () => {
  assert.ok(available(), 'expected @johnnymorganz/stylua to load');
});

test('formatting lays the code out and keeps what it prints', () => {
  const out = formatLuau(MESSY);
  assert.equal(out.ok, true, out.reason);
  assert.match(out.text, /^local a = 1$/m, out.text);
  assert.match(out.text, /^local b = \{ 1, 2, 3 \}$/m, out.text);
  assert.match(out.text, /^if a == 1 then$/m, out.text);
  assert.equal(run(out.text), run(MESSY));
});

test('a formatted result parses', () => {
  const out = formatLuau(MESSY);
  assert.ok(isValidLuaSyntax(out.text));
});

test('formatting its own output is a no-op', () => {
  const once = formatLuau(MESSY);
  const twice = formatLuau(once.text);
  assert.equal(twice.ok, true, twice.reason);
  assert.equal(twice.changed, false, 'the formatter moved bytes on a second run');
  assert.equal(twice.text, once.text);
});

test('indentation is tabs, not spaces', () => {
  const out = formatLuau(MESSY);
  for (const line of out.text.split('\n')) {
    assert.ok(!/^ {2,}\S/.test(line), `space-indented line: ${JSON.stringify(line)}`);
  }
});

test('turning it off returns the text untouched', () => {
  const out = formatLuau(MESSY, { enabled: false });
  assert.equal(out.changed, false);
  assert.equal(out.text, MESSY);
  assert.equal(out.reason, 'disabled');
});

test('text the formatter refuses comes back unchanged, not lost', () => {
  const bad = 'local a = = 1\n';
  const out = formatLuau(bad);
  assert.equal(out.ok, false);
  assert.equal(out.text, bad);
  assert.match(out.reason, /stylua/);
});
