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

function clean(src) {
  const r = spawnSync(getPythonBin(), [path.join(ROOT, 'core', 'copies.py'), '-'], {
    cwd: ROOT, input: src, encoding: 'utf8', env: pythonEnv(process.env),
  });
  if (r.status !== 0) throw new Error(r.stderr || 'copies.py failed');
  return r.stdout;
}

function luau(src) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'copies-'));
  const file = path.join(dir, 'case.luau');
  fs.writeFileSync(file, src);
  const r = spawnSync(LUAU, [file], { cwd: ROOT, encoding: 'utf8' });
  fs.rmSync(dir, { recursive: true, force: true });
  if (r.error) throw r.error;
  assert.equal(r.status, 0, r.stderr);
  return r.stdout.trim();
}

test('a copy used only before the next write is inlined', () => {
  const src = `local t = {}
local u = t
u.x = 1
print(t.x)
`;
  const out = clean(src);
  assert.doesNotMatch(out, /local u/);
  assert.match(out, /t\.x = 1/);
  assert.equal(luau(out), luau(src));
});

test('a register the VM refills still gets its values', () => {
  const src = `local t = { n = 1 }
local r
r = t
r.x = 2
r = 5
print(t.x, r)
`;
  const out = clean(src);
  assert.doesNotMatch(out, /r = t/);
  assert.match(out, /t\.x = 2/);
  assert.match(out, /r = 5/);
  assert.equal(luau(out), luau(src));
});

test('a source that is reassigned after the copy is left alone', () => {
  const src = `local b = { n = 1 }
local a = b
b = { n = 2 }
print(a.n, b.n)
`;
  assert.match(clean(src), /local a = b/);
});

test('a global function parked in a register is called directly', () => {
  const src = `local list = { "a", "b" }
local iterate = ipairs
for i, v in iterate(list) do
	print(i, v)
end
`;
  const out = clean(src);
  assert.doesNotMatch(out, /iterate/);
  assert.match(out, /in ipairs\(list\)/);
  assert.equal(luau(out), luau(src));
});

test('a copy a nested function can read is not folded', () => {
  const src = `local t = { n = 1 }
local u = t
local function peek()
	return u.n
end
u = { n = 9 }
print(peek(), t.n)
`;
  assert.match(clean(src), /local u = t/);
});

test('a declaration nobody reads is dropped', () => {
  const src = `local unused
print("hi")
`;
  const out = clean(src);
  assert.doesNotMatch(out, /local unused/);
  assert.equal(luau(out), luau(src));
});

test('a temporary that is used once, right below, is folded away', () => {
  const src = `local function f()
	return { n = 7 }
end
local t = f()
print(t.n)
`;
  const out = clean(src);
  assert.doesNotMatch(out, /local t = f\(\)/);
  assert.match(out, /print\(f\(\)\.n\)/);
  assert.equal(luau(out), luau(src));
});

test('a temporary holding an expression keeps its name', () => {
  const src = `local a, b = 3, 4
local sum = a + b
print(sum * 2)
`;
  assert.match(clean(src), /local sum = a \+ b/);
});

test('a temporary read further down is left alone', () => {
  const src = `local function f()
	return 1
end
local t = f()
print("x")
print(t)
`;
  assert.match(clean(src), /local t = f\(\)/);
});

test('a copy a loop re-reads on its next pass is kept', () => {
  const src = `local source = { X = 5 }
local a
for i = 1, 3 do
	local seen = a
	if seen then
		print(seen.X)
	end
	a = source
	print(a.X)
end
`;
  assert.match(clean(src), /a = source/);
  assert.equal(luau(clean(src)), luau(src));
});

test('a copy one branch reads without the other writing is kept', () => {
  const src = `local source = { X = 1 }
local a = source
if math.random() > 2 then
	a = { X = 9 }
else
	print(a.X)
end
`;
  const out = clean(src);
  assert.equal(luau(out), luau(src));
});

test('a temporary is not moved into a branch it did not run in', () => {
  const src = `local calls = 0
local function f()
	calls += 1
	return 1
end
local t = f()
if false then
	print(t)
end
print(calls)
`;
  const out = clean(src);
  assert.match(out, /local t = f\(\)/);
  assert.equal(luau(out), luau(src));
});
