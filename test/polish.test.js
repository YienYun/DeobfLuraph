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

// --- usage names ----------------------------------------------------------
// A parameter the lifter called `argument5` is named from what is done with
// it; a handler it called `callback7` from the event or the body it is given.
// Each case prints values, so the Luau comparison in `same()` has something to
// compare and a rename that changed behaviour shows up.

test('a parameter is named from the method it is given to', () => {
  const src = 'local fakeRemote = {FireServer = function(self, payload) return payload end}\n'
    + 'local function send(argument5, argument6)\n\treturn argument5:FireServer(argument6)\nend\n'
    + 'print(send(fakeRemote, 7))\n';
  const out = same(src);
  assert.match(out, /local function send\(remote, payload\)/, out);
  assert.match(out, /return remote:FireServer\(payload\)/, out);
});

test('a parameter is named from the call it is handed to', () => {
  const src = 'local function run(argument5)\n\treturn pcall(argument5)\nend\n'
    + 'print(run(function() return "ran" end))\n';
  const out = same(src);
  assert.match(out, /local function run\(callback\)/, out);
  assert.match(out, /return pcall\(callback\)/, out);
});

test('a parameter is named from how it is read: index, count, arithmetic', () => {
  const src = 'local map = {a = 1}\n'
    + 'local function lookup(argument5)\n\treturn map[argument5]\nend\n'
    + 'local function count(argument6)\n\treturn #argument6\nend\n'
    + 'local function twice(argument7)\n\treturn argument7 * 2\nend\n'
    + 'print(lookup("a"), count({1, 2, 3}), twice(4))\n';
  const out = same(src);
  assert.match(out, /local function lookup\(key\)/, out);
  assert.match(out, /local function count\(list\)/, out);
  assert.match(out, /local function twice\(amount\)/, out);
});

test('a parameter takes the name the function it is passed to uses', () => {
  const src = 'local function place(egg)\n\treturn egg\nend\n'
    + 'local function outer(argument5)\n\treturn place(argument5)\nend\n'
    + 'print(outer("e"))\n';
  const out = same(src);
  assert.match(out, /local function outer\(egg\)/, out);
  assert.match(out, /return place\(egg\)/, out);
});

test('a name already live in that function is not reused for a parameter', () => {
  const src = 'local function f(argument5)\n\tlocal amount = 1\n\treturn amount + argument5 * 2\nend\n'
    + 'print(f(3))\n';
  const out = same(src);
  assert.match(out, /local amount = 1/, out);
  assert.ok(!/local function f\(amount\)/.test(out), out);
});

test('a handler passed to Connect is named after the event', () => {
  const src = 'local signal = {Connect = function(self, fn) self.fn = fn return fn end}\n'
    + 'local callback7 = function() return 1 end\n'
    + 'signal:Connect(callback7)\nprint(signal.fn())\n';
  const out = same(src);
  assert.match(out, /local function onSignal\(/, out);
});

test('a function is named from what its body builds when it is only called', () => {
  const src = 'Instance = {new = function(name) return {Name = name} end}\n'
    + 'local callback7 = function(argument5)\n\treturn Instance.new("Frame"), argument5\nend\n'
    + 'print(callback7(1).Name)\n';
  const out = same(src);
  assert.match(out, /local function newFrame\(/, out);
});

// --- method tables and value locals --------------------------------------
// A hub script defines its modules by hand, so a method body is the contract
// for `module:method(x)`. And `local value7 = <something>` says what the value
// is, which is worth a name when the local is written only once.

test('a parameter is named from the method it is handed to', () => {
  const src = 'local module = {}\nmodule.run = function(self, job)\n\treturn job + 1\nend\n'
    + 'local function start(argument5)\n\treturn module:run(argument5)\nend\n'
    + 'print(start(1), module:run(2))\n';
  const out = same(src);
  assert.match(out, /local function start\(job\)/, out);
  assert.match(out, /return module:run\(job\)/, out);
});

test('a method written in a table literal is the same contract', () => {
  const src = 'local module = {run = function(self, job)\n\treturn job * 2\nend}\n'
    + 'local function start(argument5)\n\treturn module:run(argument5)\nend\n'
    + 'print(start(2))\n';
  const out = same(src);
  assert.match(out, /local function start\(job\)/, out);
});

test('a value local is named from the field it was read from', () => {
  const src = 'local part = {Position = {X = 1}}\nlocal value7 = part.Position\n'
    + 'print(value7.X)\n';
  const out = same(src);
  assert.match(out, /^local position = part\.Position$/m, out);
  assert.match(out, /print\(position\.X\)/, out);
});

test('a value local is named from the lookup it holds', () => {
  const src = 'local character = {FindFirstChild = function(self, name) return {Name = name} end}\n'
    + 'local value7 = character:FindFirstChild("Humanoid")\nprint(value7.Name)\n';
  const out = same(src);
  assert.match(out, /^local humanoid = character:FindFirstChild\("Humanoid"\)$/m, out);
});

test('a value local packed from varargs keeps a name that says so', () => {
  const src = 'local function f(argument5, ...)\n\tlocal value8 = table.pack(...)\n'
    + '\treturn argument5 + value8.n\nend\nprint(f(1, 2, 3))\n';
  const out = same(src);
  assert.match(out, /^\s*local packedValues = table\.pack\(\.\.\.\)$/m, out);
});

test('a value local written more than once takes no name from its first write', () => {
  const src = 'local part = {Position = 1}\nlocal value7 = part.Position\n'
    + 'value7 = value7 + 1\nprint(value7)\n';
  const out = same(src);
  assert.ok(!/^local position = part\.Position$/m.test(out), out);
});

// --- a write into a frozen library ---------------------------------------
// Luau freezes `string`, `table`, `math` and friends. A lift that ends with
// `x = string` followed by `x[k] = v` lost the table the code builds, so the
// table is materialized -- and the file says so instead of dying at run time.

test('a field write into a library global materializes the table', () => {
  // the original cannot be run: it writes into the frozen `string` table
  const src = 'local data\n\nif nil then\n\tdata = string\nelse\n\tdata = string\n'
    + '\tdata["8008"] = true\nend\nprint(data["8008"] and "ok" or "no")\n';
  const out = polish(src);
  assert.match(luau(out), /^ok$/m, out);
  assert.match(out, /^local data = \{\}$/m, out);
  assert.match(out, /-- devirt: string is read-only/, out);
  assert.match(out, /^data\["8008"\] = true$/m, out);
});

test('a library global that is only read is left alone', () => {
  const src = 'local s = string\nprint(s.find("ab", "b"))\n';
  const out = same(src);
  assert.match(out, /^local s = string$/m, out);
});

test('a binding that is also called is not materialized', () => {
  const src = 'local s = string\ns["a"] = true\nprint(s.find("ab", "b"))\n';
  const out = polish(src);
  assert.match(out, /^local s = string$/m, out);
  assert.ok(!/local s = \{\}/.test(out), out);
});

// --- a branch whose condition is a literal -------------------------------
// The run decided it, so the code that ran is the code to keep; a branch that
// never ran is dropped with a note rather than left for the reader to puzzle out.

test('a branch on a literal nil keeps the block that ran', () => {
  const src = 'if nil then\n\tprint("lost")\nelse\n\tprint("ran")\nend\n';
  const out = same(src);
  assert.match(out, /print\("ran"\)/, out);
  assert.ok(!/print\("lost"\)/.test(out), out);
  assert.match(out, /-- devirt: dropped a branch/, out);
});

test('an `if true` block is left to the local merge, not folded here', () => {
  const src = 'if true then\n\tprint("ran")\nend\nprint("after")\n';
  const out = same(src);
  assert.match(out, /print\("ran"\)/, out);
  assert.ok(!/-- devirt/.test(out), out);
});
