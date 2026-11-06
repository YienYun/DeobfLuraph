'use strict';


const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const { getPythonBin, pythonEnv } = require('../src/pyenv');

const PY = path.join(ROOT, 'core', 'u32fold.py');
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

function fold(src) {
  const r = spawnSync(getPythonBin(), [PY, '-'], {
    cwd: ROOT, input: src, encoding: 'utf8', env: pythonEnv(process.env),
  });
  if (r.status !== 0) throw new Error(r.stderr || 'u32fold.py failed');
  return r.stdout;
}

function runLuau(src) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'u32fold-'));
  const file = path.join(dir, 'case.luau');
  fs.writeFileSync(file, src);
  const r = spawnSync(LUAU, [file], { cwd: ROOT, encoding: 'utf8' });
  fs.rmSync(dir, { recursive: true, force: true });
  if (r.error) throw r.error;
  const out = (r.stdout || '').trim();
  if (!out) throw new Error(r.stderr || 'luau printed nothing');
  return out;
}

function rng(seed) {
  let s = seed >>> 0;
  return () => {
    s = (Math.imul(s, 1664525) + 1013904223) >>> 0;
    return s;
  };
}

const chain = (a, b, c, d, m, x) =>
  `u32Trunc((u32Mul(${a}, ${x}) + ${b}) + ` +
  `(u32Mul(${c}, bit32.bor(${x}, ${m})) + u32Mul(${d}, bit32.bxor(${x}, ${m}))))`;

test('a constant chain folds to the value Luau computes', () => {
  const next = rng(0x5eed);
  const cases = Array.from({ length: 8 }, () => {
    const x = next();
    return { x, expr: chain(next(), next(), next(), next(), next(), x) };
  });

  const lines = cases.map((c) => `print(${c.expr})`);
  const src = `${HELPERS}${lines.join('\n')}\n`;

  const folded = fold(src);
  for (const line of folded.split('\n').filter((l) => l.startsWith('print('))) {
    assert.doesNotMatch(line, /u32Mul|u32Trunc|bit32\./, line);
    assert.match(line, /^print\(\d+\)$/);
  }
  assert.equal(runLuau(folded), runLuau(src));
});

test('parentheses do not hide a foldable expression', () => {
  const next = rng(0xc0ffee);
  const x = next();
  const inner = chain(next(), next(), next(), next(), next(), x);
  const wrapped = `(((((${inner})))))`;
  const lines = [`print(${wrapped})`, `print(u32Trunc((u32Trunc(((${x}))))) + 0)`];
  const src = `${HELPERS}local x = ${x}\n${lines.join('\n')}\n`;

  const folded = fold(src);
  const printed = folded.split('\n').filter((l) => l.startsWith('print('));
  assert.deepEqual(printed, [`print(${runLuau(src).split('\n')[0]})`,
                             `print(712164981)`].slice(0, printed.length));
  for (const line of printed) assert.doesNotMatch(line, /u32Mul|u32Trunc/);
  assert.equal(runLuau(folded), runLuau(src));
});

test('a fold carries through a local that is written once', () => {
  const next = rng(0xbeef);
  const a = next();
  const x = next();
  const src = `${HELPERS}local seed = ${x}\nlocal s = u32Trunc(seed + ${a})\nprint(s)\nprint(u32Trunc(s * 3))\n`;
  const folded = fold(src);
  const [first, second] = runLuau(src).split('\n').map(Number);
  assert.equal(folded,
    `${HELPERS}local seed = ${x}\nlocal s = ${first}\nprint(s)\nprint(${second})\n`);
});

test('a mask is only dropped when the operand is already an integer', () => {
  const src = [
    HELPERS,
    'local f = 2.5',
    'print(bit32.band(f, 4294967295))',
    'print(bit32.bxor(f, 0))',
    'local i = 4294967259',
    'print(u32Trunc(i))',
    '',
  ].join('\n');

  const folded = fold(src);
  assert.match(folded, /print\(bit32\.band\(f, 4294967295\)\)/);
  assert.match(folded, /print\(bit32\.bxor\(f, 0\)\)/);
  assert.match(folded, /print\(4294967259\)/);
  assert.equal(runLuau(folded), runLuau(src));
});

test('a locally defined helper with another body is not evaluated', () => {
  const src = [
    'local function u32Mul(a, b)',
    '\treturn a + b',
    'end',
    'print(u32Mul(2, 3))',
    '',
  ].join('\n');

  const folded = fold(src);
  assert.match(folded, /print\(u32Mul\(2, 3\)\)/);
  assert.equal(runLuau(folded), runLuau(src));
});
