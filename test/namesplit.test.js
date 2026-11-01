'use strict';

// Two locals can share one printed name (core/namesplit.py, category X):
//   local a, a = f(), g()
// A `local` declaration's initialisers run before any of the new locals is in
// scope, so the earlier `a` can never be read; naming it `_` says so. The pass
// proves that from the AST (zero references) instead of assuming it, so these
// tests pin the two things that would make the proof wrong: an outer local of
// the same name (which the initialiser really does read), and a nested closure
// reading the surviving local (which must keep its name untouched).
//
// Category W (a closure's name reused for a later value) is tested here too once
// the reuse split is enabled.

const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('path');
const fs = require('fs');
const os = require('os');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
const CORE = path.join(ROOT, 'core');
const ast = process.env.LUAU_AST_BIN || path.join(ROOT, 'bin', process.platform === 'win32' ? 'luau-ast.exe' : 'luau-ast');
const astAvailable = !spawnSync(ast, ['--help'], { stdio: 'ignore', timeout: 5000 }).error;

// Apply one namesplit pass to `src`. Returns {text, stats}.
function split(mode, src) {
  const driver = [
    'import sys, json',
    'sys.path.insert(0, "core")',
    'import namesplit',
    'text = sys.stdin.read()',
    'fn = getattr(namesplit, "apply_duplicates" if sys.argv[1] == "dups" else "apply_reuse")',
    'new, stats = fn(text)',
    'sys.stdout.write(new)',
    'sys.stderr.write(json.dumps(stats))',
  ].join('\n');
  const r = spawnSync('python3', ['-c', driver, mode], {
    cwd: ROOT, input: src, encoding: 'utf8', timeout: 120000, env: { ...process.env, PYTHONPATH: CORE },
  });
  assert.equal(r.status, 0, r.stderr);
  return { text: r.stdout, stats: JSON.parse(r.stderr) };
}

function parses(text) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'deobf-namesplit-'));
  try {
    const f = path.join(dir, 'snippet.luau');
    fs.writeFileSync(f, text);
    const r = spawnSync(ast, [f], { encoding: 'utf8', timeout: 20000 });
    return r.status === 0;
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
}

test('the shadowed duplicate of a declaration is named _, the surviving one keeps its name', () => {
  const r = split('dups', 'local a, a = 1, 2\nprint(a)\n');
  assert.equal(r.text, 'local _, a = 1, 2\nprint(a)\n');
  assert.equal(r.stats.duplicates_fixed, 1);
  assert.equal(r.stats.duplicates_total, 1);
});

test('an initialiser that reads an outer local of the same name is left alone', () => {
  const src = 'local a = 0\ndo\n\tlocal a, a = a, 3\n\tprint(a)\nend\n';
  const r = split('dups', src);
  assert.equal(r.text, 'local a = 0\ndo\n\tlocal _, a = a, 3\n\tprint(a)\nend\n');
  assert.equal(r.stats.duplicates_fixed, 1);
});

test('a closure reading the surviving local keeps the reference it resolves to', () => {
  const src = 'local a, a = 1, 2\nlocal function f() return a end\nprint(f(), a)\n';
  const r = split('dups', src);
  assert.equal(r.text, 'local _, a = 1, 2\nlocal function f() return a end\nprint(f(), a)\n');
});

test('every shadowed duplicate in one statement is renamed, not just the first', () => {
  const r = split('dups', 'local a, a, a = 1, 2, 3\nprint(a)\n');
  assert.equal(r.text, 'local _, _, a = 1, 2, 3\nprint(a)\n');
  assert.equal(r.stats.duplicates_fixed, 2);
});

test('a statement without duplicate names is untouched', () => {
  const src = 'local a, b = 1, 2\nprint(a, b)\n';
  const r = split('dups', src);
  assert.equal(r.text, src);
  assert.equal(r.stats.duplicates_fixed, 0);
});

test('the pass is idempotent and its output still parses', { skip: astAvailable ? false : 'luau-ast required' }, () => {
  const src = 'local a, a = 1, 2\nlocal b = 3\nprint(a, b)\n';
  const once = split('dups', src);
  assert.equal(split('dups', once.text).text, once.text);
  assert.ok(parses(once.text), 'rewritten snippet must still be valid Luau');
});

test('a duplicate `_` is not renamed again', () => {
  const src = 'local _, _ = 1, 2\nprint(_)\n';
  const r = split('dups', src);
  assert.equal(r.text, src);
  assert.equal(r.stats.duplicates_fixed, 0);
});

// ---- category W: the closure's name reused for a later value ---------------
//
//   local function f() ... end
//   f = other
//   ... f.x ...          -- reads the reuse value, not the closure
//
// The closure keeps its name; the reuse value gets a new local, used by every
// read and write from the reassignment on. Only split where the later reads
// provably see the reuse value: a capture that can run after the split, a read
// the assignment does not dominate, or an assignment inside a loop can all make
// the name ambiguous, and those sites are skipped and counted instead.

test('a value assigned after a closure gets its own local, reads included', () => {
  const src = 'local f = function() return 1 end\nprint(f)\nf = 2\nprint(f)\n';
  const r = split('reuse', src);
  assert.equal(r.text, 'local f = function() return 1 end\nprint(f)\nlocal f_2 = 2\nprint(f_2)\n');
  assert.equal(r.stats.reuse_split, 1);
});

test('later reassignments stay one temp: one new name, not a number per write', () => {
  const src = 'local f = function() return 1 end\nf = 2\nprint(f)\nf = 3\nprint(f)\n';
  const r = split('reuse', src);
  assert.equal(r.text, 'local f = function() return 1 end\nlocal f_2 = 2\nprint(f_2)\nf_2 = 3\nprint(f_2)\n');
});

test('a closure created after the split takes the reuse value with the same name', () => {
  const src = 'local f = function() return 1 end\nf = 2\nlocal function g() return f end\nprint(g())\n';
  const r = split('reuse', src);
  assert.equal(r.text, 'local f = function() return 1 end\nlocal f_2 = 2\nlocal function g() return f_2 end\nprint(g())\n');
});

test('a capture that can run after the split is skipped, not guessed', () => {
  const src = 'local f = function() return 1 end\nlocal function g() return f end\nf = 2\nprint(f, g())\n';
  const r = split('reuse', src);
  assert.equal(r.text, src);
  assert.deepEqual(r.stats.reuse_skipped, { 'capture-before-split': 1 });
});

test('a closure created after the first reuse value takes the new name, even when a later write follows', () => {
  const src = 'local f = function() return 1 end\nf = 2\nlocal function g() return f end\nf = 3\nprint(g())\n';
  const r = split('reuse', src);
  assert.equal(r.text, 'local f = function() return 1 end\nlocal f_2 = 2\nlocal function g() return f_2 end\nf_2 = 3\nprint(g())\n');
});

test('a write inside a nested function is skipped', () => {
  const src = 'local f = function() return 1 end\nlocal function h() f = 2 end\nprint(f)\n';
  const r = split('reuse', src);
  assert.equal(r.text, src);
  assert.deepEqual(r.stats.reuse_skipped, { 'write-in-closure': 1 });
});

test('a read the conditional assignment does not dominate is skipped', () => {
  const src = 'local f = function() return 1 end\nif x then\n\tf = 2\nend\nprint(f)\n';
  const r = split('reuse', src);
  assert.equal(r.text, src);
  assert.deepEqual(r.stats.reuse_skipped, { 'undominated-read': 1 });
});

test('a read before the assignment inside the same loop is skipped', () => {
  const src = 'local f = function() return 1 end\nwhile x do\n\tprint(f)\n\tf = 2\nend\n';
  const r = split('reuse', src);
  assert.equal(r.text, src);
  assert.deepEqual(r.stats.reuse_skipped, { 'loop-hazard': 1 });
});

test('a compound assignment that agrees with itself keeps one name', () => {
  const src = 'local f = function() return 1 end\nf = 1\nf += 1\nprint(f)\n';
  const r = split('reuse', src);
  assert.equal(r.text, 'local f = function() return 1 end\nlocal f_2 = 1\nf_2 += 1\nprint(f_2)\n');
});

test('a compound assignment that is the first reuse is skipped', () => {
  const src = 'local f = function() return 1 end\nf += 1\nprint(f)\n';
  const r = split('reuse', src);
  assert.equal(r.text, src);
  assert.deepEqual(r.stats.reuse_skipped, { 'compound-assign': 1 });
});

test('`local function` form is split the same way', () => {
  const src = 'local function f() return 1 end\nprint(f)\nf = nil\nprint(f)\n';
  const r = split('reuse', src);
  assert.equal(r.text, 'local function f() return 1 end\nprint(f)\nlocal f_2 = nil\nprint(f_2)\n');
});

test('the split is idempotent and still parses', { skip: astAvailable ? false : 'luau-ast required' }, () => {
  const src = 'local f = function() return 1 end\nf = 2\nprint(f)\n';
  const once = split('reuse', src);
  assert.equal(split('reuse', once.text).text, once.text);
  assert.ok(parses(once.text), 'rewritten snippet must still be valid Luau');
});

test('a multi-target assignment declares the new local on its own line', () => {
  const src = 'local g = 1\nlocal f = function() return 1 end\nf, g = 2, 3\nprint(f, g)\n';
  const r = split('reuse', src);
  assert.equal(r.text, 'local g = 1\nlocal f = function() return 1 end\nlocal f_2\nf_2, g = 2, 3\nprint(f_2, g)\n');
});

test('the declaration goes into the block the assignment runs in', () => {
  const src = 'local f = function() return 1 end\nif cond then\n\tf = 2\n\tprint(f)\nend\n';
  const r = split('reuse', src);
  assert.equal(r.text, 'local f = function() return 1 end\nif cond then\n\tlocal f_2 = 2\n\tprint(f_2)\nend\n');
});

test('a loop body whose closure would capture a per-iteration variable is skipped', () => {
  const src = 'local f = function() return 1 end\nwhile cond do\n\tf = 2\n\tlocal function g() return f end\n\tprint(g())\nend\n';
  const r = split('reuse', src);
  assert.equal(r.text, src);
  assert.deepEqual(r.stats.reuse_skipped, { 'loop-capture': 1 });
});

test('the reuse value is a declared local, never a leaked global', { skip: astAvailable ? false : 'luau-ast required' }, () => {
  const src = 'local f = function() return 1 end\nf = 2\nprint(f)\n';
  const out = split('reuse', src).text;
  assert.match(out, /^local f_2 = 2$/m, 'the reuse value must be declared with `local`');
});

test('a second binding with the same name gets the next number, not `f_22`', () => {
  const src = 'local f = function() return 1 end\nf = 2\nprint(f)\ndo\n\tlocal f = function() return 1 end\n\tf = 3\n\tprint(f)\nend\n';
  const r = split('reuse', src);
  assert.match(r.text, /^local f_2 = 2$/m);
  assert.match(r.text, /^\tlocal f_3 = 3$/m);
  assert.doesNotMatch(r.text, /f_2\d/);
});
