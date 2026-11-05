'use strict';

// The AST cleanup runs last, after every rewrite that can empty a declaration
// out. These cases are about what it leaves behind: names nothing reads, calls
// whose first result is deliberately thrown away, and the indentation a merged
// declaration keeps. Every case is also run under Luau, before and after, so a
// slot can only go when the program still prints the same thing.

const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const { getPythonBin, pythonEnv } = require('../src/pyenv');

const LUAU = path.join(ROOT, 'bin', 'luau');

function polish(src) {
  const r = spawnSync(getPythonBin(), [path.join(ROOT, 'core', 'ast_polish.py'), '-'], {
    cwd: ROOT, input: src, encoding: 'utf8', env: pythonEnv(process.env),
  });
  if (r.status !== 0) throw new Error(r.stderr || 'ast_polish.py failed');
  return r.stdout;
}

function luau(src) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'polish-'));
  const file = path.join(dir, 'case.luau');
  fs.writeFileSync(file, src);
  const r = spawnSync(LUAU, [file], { cwd: ROOT, encoding: 'utf8' });
  fs.rmSync(dir, { recursive: true, force: true });
  if (r.error) throw r.error;
  assert.equal(r.status, 0, r.stderr);
  return r.stdout;
}

function same(src) {
  const out = polish(src);
  assert.equal(luau(out), luau(src), 'behaviour changed:\n' + out);
  return out;
}

test('a slot holding nil and read by nothing is dropped from its declaration', () => {
  const out = same('local a, b = nil, os.clock()\nprint(type(b))\n');
  assert.match(out, /^local b = os\.clock\(\)$/m);
  assert.ok(!/local a/.test(out), out);
});

test('a slot holding a literal is dropped, and so is the value', () => {
  const out = same('local dead, kept = 7, "x"\nprint(kept)\n');
  assert.match(out, /^local kept = "x"$/m);
  assert.ok(!/dead/.test(out), out);
});

test('a declaration nothing reads any more is removed outright', () => {
  const out = same('local unused\nprint("ok")\n');
  assert.ok(!/unused/.test(out), out);
  assert.match(out, /print\("ok"\)/);
});

test('a call in a dead slot is never dropped, only renamed', () => {
  const out = same('local n = 0\nlocal function bump() n = n + 1 return n end\n'
    + 'local dead, kept = bump(), 5\nprint(kept, n)\n');
  assert.match(out, /bump\(\)/, out);
  assert.ok(!/\bdead\b/.test(out), out);
});

test('the first result of a multi-value call keeps a name nothing reads', () => {
  // `local a, b = f()` hands b the *second* result; deleting `a` would give it
  // the first, so the name stays and says that the value is discarded
  const out = same('local function f() return 1, 2 end\nlocal dropped, second = f()\nprint(second)\n');
  assert.match(out, /local _, second = f\(\)/, out);
});

test('no `_` is used while the file has a live one of its own', () => {
  const src = 'local _ = 3\nlocal function f() return 1, 2 end\nlocal gone, second = f()\nprint(second, _)\n';
  const out = same(src);
  assert.ok(!/local _, second/.test(out), out);
  assert.match(out, /^local _ = 3$/m);
});

test('a merged declaration keeps the indentation of the block it sits in', () => {
  const out = same('local v\nif true then\n\tlocal t\nt = 4\nprint(t)\nend\nprint(v)\n');
  assert.match(out, /^\tlocal t = 4$/m, out);
  assert.ok(!/^\t\tlocal t/.test(out), out);
});

// --- context slots --------------------------------------------------------
// The script keeps its own helper table and indexes it by number. These cases
// pin the rule that gives a slot a name: what was stored in it, and only where
// that name really means the same value at the read.

const GAME = 'local game = {GetService = function(_, name) return {Name = name} end}\n';

test('a slot holding a service is named after the service', () => {
  const src = GAME + 'local data = {}\ndata[58] = game:GetService("RunService")\nprint(data[58].Name)\n';
  const out = same(src);
  assert.match(out, /^local runService = data\[58\]$/m, out);
  assert.match(out, /print\(runService\.Name\)/, out);
});

test('a slot copied from a local uses that local and adds no alias', () => {
  const src = 'local state = {note = 0}\nlocal data = {}\ndata[20] = state\nstate.note = 1\n'
    + 'print(data[20].note)\n';
  const out = same(src);
  assert.match(out, /print\(state\.note\)/, out);
  assert.ok(!/local state = data\[20\]/.test(out), out);
});

test('a read the name would not reach keeps its number', () => {
  // `state` inside f is a different binding that is read there, so the slot has
  // to stay indexed: naming it would silently hand the inner table to the read
  const src = 'local state = {note = 1}\nlocal data = {}\ndata[20] = state\n'
    + 'local function f()\n\tlocal state = {note = 2}\n\treturn state.note, data[20].note\nend\n'
    + 'print(f(), state.note)\n';
  const out = same(src);
  assert.match(out, /return state\.note, data\[20\]\.note/, out);
  assert.match(out, /print\(f\(\), state\.note\)/, out);
});

test('a read above the write keeps its number, the ones below take the name', () => {
  const src = GAME + 'local data = {}\nlocal early = data[7]\n'
    + 'data[7] = game:GetService("TeleportService")\nprint(early, data[7].Name)\n';
  const out = same(src);
  assert.match(out, /local early = data\[7\]/, out);
  assert.match(out, /^local teleportService = data\[7\]$/m, out);
  assert.match(out, /print\(early, teleportService\.Name\)/, out);
});

test('naming a slot settles: a second polish changes nothing', () => {
  const src = GAME + 'local data = {}\ndata[58] = game:GetService("RunService")\nprint(data[58].Name)\n';
  const once = polish(src);
  assert.equal(polish(once), once);
});
