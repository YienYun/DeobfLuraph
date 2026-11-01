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
