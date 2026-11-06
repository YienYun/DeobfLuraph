'use strict';


const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..', '..');
const { getPythonBin, pythonEnv } = require('../../node/pyenv');

const PY = path.join(ROOT, 'engine', 'flatten.py');

function flatten(src) {
  const r = spawnSync(getPythonBin(), [PY, '--stdin'], {
    cwd: ROOT, input: src, encoding: 'utf8', env: pythonEnv(process.env),
  });
  if (r.status !== 0) throw new Error(r.stderr || 'flatten.py failed');
  return JSON.parse(r.stdout);
}

const OPEN = '\t\twhile true do\n';
const CLOSE = '\t\tend\n';
const HEAD =
  '\t\t\tc += a\n\n' +
  '\t\t\tif not (a <= 0) then\n' +
  '\t\t\t\tif not (c <= b) then\n\t\t\t\t\tbreak\n\t\t\t\tend\n' +
  '\t\t\telseif not (c >= b) then\n\t\t\t\tbreak\n\t\t\tend\n';

const wrap = (body, prelude = '\tlocal a, b, c = 1, 3, 0\n') =>
  `local function f()\n${prelude}\n${OPEN}${HEAD}\n${body}${CLOSE}\tend\n`;

const prints = (text) => [...text.matchAll(/print\(([^()]*)\)/g)].map((m) => m[1]);

test('a constant range is unrolled in the order it runs', () => {
  const { text, stats } = flatten(wrap('\t\t\tprint(c)\n'));
  assert.equal(stats.dispatch_loops_unrolled, 1);
  assert.equal(stats.dispatch_iterations, 3);
  assert.deepEqual(prints(text), ['1', '2', '3']);
  assert.doesNotMatch(text, /while true/);
  assert.doesNotMatch(text, /c \+= a/);
  assert.match(text, /\n\t\tprint\(1\)\n\t\tprint\(2\)\n\t\tprint\(3\)\n\tend\n$/);
});

test('a range that is empty removes the loop entirely', () => {
  const { text, stats } = flatten(wrap('\t\t\tprint(c)\n', '\tlocal a, b, c = 1, 0, 0\n'));
  assert.equal(stats.dispatch_loops_dropped, 1);
  assert.doesNotMatch(text, /while true|print/);
});

test('a branch that continues skips the rest of that pass only', () => {
  const body = '\t\t\tlocal s = c\n\t\t\tif s == 1 then\n\t\t\t\tcontinue\n\t\t\tend\n\t\t\tprint(s)\n';
  const { text } = flatten(wrap(body));
  assert.deepEqual(prints(text), ['2', '3']);
});

test('a branch that breaks ends the loop there', () => {
  const body = '\t\t\tlocal s = c\n\t\t\tif s == 2 then\n\t\t\t\tbreak\n\t\t\tend\n\t\t\tprint(s)\n';
  const { text } = flatten(wrap(body));
  assert.deepEqual(prints(text), ['1']);
});

test('a branch that returns ends the function and stops the unroll', () => {
  const body = '\t\t\tlocal s = c\n\t\t\tif s == 2 then\n\t\t\t\treturn s\n\t\t\tend\n\t\t\tprint(s)\n';
  const { text } = flatten(wrap(body));
  assert.match(text, /return 2/);
  assert.doesNotMatch(text, /print\(3\)/);
  assert.match(text, /\t\treturn 2\n\tend\n$/);
});

test('the counter keeps its post-loop value when anything still reads it', () => {
  const plain = flatten(wrap('\t\t\tprint(c)\n')).text;
  assert.doesNotMatch(plain, /\n\tc = \d/);
  const reading = flatten(
    `local function f()\n\tlocal a, b, c = 1, 3, 0\n${OPEN}${HEAD}\n\t\t\tprint(c)\n${CLOSE}\treturn c\nend\n`);
  assert.match(reading.text, /\tc = 4\n\treturn c\n/);
});

test('a dead loop whose setup is inside the body is dropped', () => {
  const src =
    'local function f()\n' +
    '\twhile true do\n' +
    '\t\tlocal data = {}\n' +
    '\t\tlocal i, lim, n = 1, 255, 0 - 1\n' +
    '\t\tn += i\n\n' +
    '\t\tif not (i <= 0) then\n\t\t\tif n <= lim then\n\t\t\t\tbreak\n\t\t\tend\n' +
    '\t\telseif n >= lim then\n\t\t\tbreak\n\t\tend\n\n' +
    '\t\tdata[1] = 2\n' +
    '\tend\n' +
    '\treturn "after"\n' +
    'end\n';
  const { text, stats } = flatten(src);
  assert.equal(stats.dispatch_dead_loops, 1);
  assert.doesNotMatch(text, /data\[1\]/);
  assert.match(text, /return "after"/);
});

test('a loop with a runtime bound is left untouched and reported', () => {
  const src = wrap('\t\t\tprint(c)\n', '\tlocal a, c = 1, 0\n\tlocal b = #tostring(a) + 0\n');
  const { text, stats } = flatten(src);
  assert.equal(stats.dispatch_loops_unrolled, 0);
  assert.equal(stats.dispatch_skipped['unknown-bounds'], 1);
  assert.equal(text, src);
});

test('a loop whose jump is still conditional is left untouched', () => {
  const body = '\t\t\tlocal s = c\n\t\t\tif flag then\n\t\t\t\tcontinue\n\t\t\tend\n\t\t\tprint(s)\n';
  const src = wrap(body);
  const { text, stats } = flatten(src);
  assert.equal(stats.dispatch_skipped['conditional-jump'], 1);
  assert.equal(text, src);
});

test('an inverted loop that would never end is left alone', () => {
  const src = '\tlocal a, b, c = 1, -5, -1\n';
  const inv = '\t\twhile true do\n\t\t\tc += a\n\n' +
    '\t\t\tif not (a <= 0) then\n\t\t\t\tif c <= b then\n\t\t\t\t\tbreak\n\t\t\t\tend\n' +
    '\t\t\telseif c >= b then\n\t\t\t\tbreak\n\t\t\tend\n\n\t\t\tprint(c)\n\t\tend\n';
  const full = `local function f()\n${src}\n${inv}\tend\n`;
  const { text, stats } = flatten(full);
  assert.equal(stats.dispatch_dead_loops, 0);
  assert.equal(stats.dispatch_skipped['dead-loop-runs'], 1);
  assert.equal(text, full);
});

test('substitution never rewrites an assignment target', () => {
  const body = '\t\t\tlocal s = c\n\t\t\tlocal i = 1\n\t\t\ti += 1\n\t\t\tprint(s + i)\n';
  const { text } = flatten(wrap(body));
  assert.doesNotMatch(text, /\d+ \+=/);
});

test('unrolling is idempotent', () => {
  const src = wrap('\t\t\tprint(c)\n');
  const once = flatten(src).text;
  assert.equal(flatten(once).text, once);
});
