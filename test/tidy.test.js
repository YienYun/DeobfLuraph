'use strict';


const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const { getPythonBin, pythonEnv } = require('../src/pyenv');

const LUAU = path.join(ROOT, 'bin', 'luau');

function tidy(src) {
  const r = spawnSync(getPythonBin(), [path.join(ROOT, 'core', 'tidy.py'), '-'], {
    cwd: ROOT, input: src, encoding: 'utf8', env: pythonEnv(process.env),
  });
  if (r.status !== 0) throw new Error(r.stderr || 'tidy.py failed');
  return r.stdout;
}

function luau(src) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'tidy-'));
  const file = path.join(dir, 'case.luau');
  fs.writeFileSync(file, src);
  const r = spawnSync(LUAU, [file], { cwd: ROOT, encoding: 'utf8' });
  fs.rmSync(dir, { recursive: true, force: true });
  if (r.error) throw r.error;
  assert.equal(r.status, 0, r.stderr);
  return r.stdout.trim();
}

function same(src) {
  const out = tidy(src);
  assert.equal(luau(out), luau(src));
  return out;
}

test('a group around a whole condition or value is dropped', () => {
  const out = same(`local k = 3
if (k == 3) then print("three") end
local x = (k)
print((x))
`);
  assert.doesNotMatch(out, /if \(/);
  assert.doesNotMatch(out, /= \(k\)/);
});

test('a comparison inside a conjunction loses its brackets', () => {
  const out = same(`local a, b = 1, 2
if (a == 1) and (b == 2) then print("both") end
`);
  assert.match(out, /a == 1 and b == 2/);
});

test('arithmetic keeps the brackets that decide the result', () => {
  const out = same('print((2 + 3) * 4, 2 - (3 - 1), (2 * 3) / 4)\n');
  assert.match(out, /\(2 \+ 3\) \* 4/);
  assert.match(out, /2 - \(3 - 1\)/);
});

test('a disjunction under a conjunction keeps its brackets', () => {
  const out = same('print((1 or 2) and 3)\n');
  assert.match(out, /\(1 or 2\) and 3/);
});

test('a call grouped for truncation keeps its brackets', () => {
  const src = `local function two()
	return 1, 2
end
local function count(...)
	return select("#", ...)
end
print(count(two()), count((two())))
`;
  const out = same(src);
  assert.match(out, /count\(\(two\(\)\)\)/);
});

test('a bare negation loses the brackets but a comparison keeps them', () => {
  const out = same(`local flag = false
print(not (flag), not (1 == 2))
`);
  assert.match(out, /not flag/);
  assert.match(out, /not \(1 == 2\)/);
});

test('a table literal indexed on the spot keeps its brackets', () => {
  const out = same(`local k = "a"
local v = ({a = 1, b = 2})[k] or "z"
print(v, ({1, 2})[2])
`);
  assert.match(out, /\(\{a = 1, b = 2\}\)\[k\]/);
  assert.match(out, /\(\{1, 2\}\)\[2\]/);
});

test('an index base that is already an expression loses its brackets', () => {
  const out = same(`local t = {7, 8}
local k = 2
print((t)[k], ({1})[1]);
`);
  assert.match(out, /print\(t\[k\]/);
});

test('an operator under an index keeps the brackets that hold it together', () => {
  const out = same(`local a, b = nil, {5}
print((a or b)[1])
`);
  assert.ok(!/a or b\[1\]/.test(out), out);
});

test('seed arguments handed to a function that takes none are dropped', () => {
  const src = `local function build()
	return 7
end
print(build(488023178, 180544471))
`;
  const out = same(src);
  assert.match(out, /print\(build\(\)\)/);
});
