'use strict';

// Two passes clean out what a Luraph v15 build leaves behind: the per-function
// state seed it only ever hashes against itself, and the stores nothing can
// read. Deleting code is the one thing a deobfuscator must never get wrong, so
// every case here is run under Luau before and after -- the two programs have
// to print the same thing.

const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const { getPythonBin, pythonEnv } = require('../src/pyenv');

const LUAU = path.join(ROOT, 'bin', 'luau');

const HELPERS = [
  'local function u32Trunc(argument)',
  '\targument %= 4294967296',
  '\treturn if argument == argument then argument // 1 else 0',
  'end',
  '',
  'local function u32Mul(argument, argument2)',
  '\targument, argument2 = bit32.band(argument, 4294967295), bit32.band(argument2, 4294967295)',
  '\treturn bit32.band(bit32.band(argument, 65535) * argument2 + bit32.lshift(bit32.rshift(argument, 16) * bit32.band(argument2, 65535), 16), 4294967295)',
  'end',
  '',
  '',
].join('\n');

function run(script, src) {
  const r = spawnSync(getPythonBin(), [path.join(ROOT, 'core', script), '-'], {
    cwd: ROOT, input: src, encoding: 'utf8', env: pythonEnv(process.env),
  });
  if (r.status !== 0) throw new Error(r.stderr || `${script} failed`);
  return r.stdout;
}

// Both passes, in the order the pipeline runs them, until neither has work left.
function clean(src) {
  let text = src;
  for (let i = 0; i < 4; i += 1) {
    const a = run('deadstore.py', text);
    const b = run('seeds.py', a);
    if (b === text) break;
    text = b;
  }
  return text;
}

function luau(src) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'seeds-'));
  const file = path.join(dir, 'case.luau');
  fs.writeFileSync(file, src);
  const r = spawnSync(LUAU, [file], { cwd: ROOT, encoding: 'utf8' });
  fs.rmSync(dir, { recursive: true, force: true });
  if (r.error) throw r.error;
  assert.equal(r.status, 0, r.stderr);
  return r.stdout.trim();
}

test('a seed chain that only feeds itself is removed', () => {
  const src = `${HELPERS}local function f()
\tlocal state = 135623784
\tstate = bit32.bxor(state, 279606389)
\tstate = u32Trunc(u32Mul(69228956, state) + 663714168)
\treturn "done"
end
print(f())
`;
  const out = clean(src);
  const body = out.slice(out.indexOf('local function f()'));
  // the leftover `local state` is only a declaration; the later polish drops it
  assert.doesNotMatch(body, /state\s*=|bit32\.|u32Trunc/);
  assert.equal(luau(out), luau(src));
});

test('a seed that shares a statement with real work keeps the real half', () => {
  const src = `${HELPERS}local function f()
\tlocal state = 1000
\tlocal ok, seed = pcall(function() return 7 end), u32Trunc(state + 5)
\treturn ok
end
print(f())
`;
  const out = clean(src);
  const body = out.slice(out.indexOf('local function f()'));
  // the call stays (it runs code), only the seed's value goes
  assert.match(body, /pcall\(function\(\) return 7 end\)/);
  assert.doesNotMatch(body, /u32Trunc|state\s*=/);
  assert.equal(luau(out), luau(src));
});

test('a seed value that is read is not a seed', () => {
  const src = `${HELPERS}local function f()
\tlocal state = 135623784
\tstate = bit32.bxor(state, 12)
\treturn state
end
print(f())
`;
  const out = clean(src);
  assert.match(out, /bit32\.bxor/);
  assert.equal(luau(out), luau(src));
});

test('a seed captured by a closure stays', () => {
  const src = `${HELPERS}local function f()
\tlocal state = 135623784
\tlocal function bump()
\t\tstate = bit32.bxor(state, 7)
\t\treturn state
\tend
\treturn bump()
end
print(f())
`;
  const out = clean(src);
  assert.match(out, /bit32\.bxor/);
  assert.equal(luau(out), luau(src));
});

test('a seed written from a call is not removed', () => {
  const src = `${HELPERS}local function f()
\tlocal state = 0
\tstate = math.floor(3.5)
\treturn state
end
print(f())
`;
  const out = clean(src);
  assert.match(out, /math\.floor/);
  assert.equal(luau(out), luau(src));
});

test('a store overwritten before any read goes, and the declaration stays', () => {
  const src = `${HELPERS}local function f()
\tlocal slot = 349617676
\tslot = 1
\tslot = 2
\treturn slot
end
print(f())
`;
  const out = clean(src);
  assert.match(out, /local slot\b/);
  assert.doesNotMatch(out, /349617676/);
  assert.equal(luau(out), luau(src));
});

test('a store inside a loop body is kept', () => {
  const src = `${HELPERS}local total = 0
local i = 0
while i < 3 do
\ttotal = 5
\ttotal = total + 1
\ti = i + 1
end
print(total)
`;
  const out = clean(src);
  assert.match(out, /total = 5/);
  assert.equal(luau(out), luau(src));
});

test('a store whose value can call is kept', () => {
  const src = `${HELPERS}local log = {}
local function f()
\tlog[1] = "ran"
\treturn 1
end
local a = f()
a = 2
print(a, log[1])
`;
  const out = clean(src);
  assert.match(out, /local a = f\(\)/);
  assert.equal(luau(out), luau(src));
});

test('a value a loop carries into the next iteration is kept', () => {
  const src = `${HELPERS}local pending = nil
local n = 0
while n < 3 do
	if pending then print(pending) end
	pending = n
	n = n + 1
end
`;
  const out = clean(src);
  // dropping `pending = n` would change what the next iteration prints
  assert.match(out, /pending = n/);
  assert.equal(luau(out), luau(src));
});
