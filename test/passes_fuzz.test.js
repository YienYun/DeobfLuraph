'use strict';

// A differential test for the text passes. Lifted code is full of register
// patterns -- a value copied into a scratch local, the same local refilled two
// lines later, a temporary read once, a store of nil -- and every pass that
// touches them has to leave the program meaning what it meant. Generated
// programs in that shape go through the whole chain and the two versions are run
// under Luau; anything that prints differently, or fails on one side only, is a
// bug in a pass.
//
// The generator is seeded, so a failure can be replayed as-is.

const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const { getPythonBin, pythonEnv } = require('../core/pyenv');

const LUAU = path.join(ROOT, 'bin', 'luau');

function makeRandom(seed) {
  let s = seed >>> 0;
  return () => {
    s = (s * 1664525 + 1013904223) >>> 0;
    return s / 4294967296;
  };
}

const VALUES = ['1', '2', '0', 'true', 'false', 'nil', 't', 'u', 'n', '-1', '"s"'];

function generate(seed) {
  const rnd = makeRandom(seed);
  const pick = (arr) => arr[Math.floor(rnd() * arr.length)];
  const locals = ['a', 'b', 'c', 'd'];
  const out = [
    'local t = { X = 10, Y = 20 }',
    'local u = { X = 1 }',
    'local n = 3',
    'local a, b, c, d',
    // one temporary every program, so the temp fold is always exercised
    'local probe = t.X',
    'print("probe", probe ~= nil)',
  ];

  const safeRead = (name) => [
    `\tif ${name} == nil then`,
    `\t\tprint("${name} nil")`,
    `\telseif type(${name}) == "table" then`,
    `\t\tprint("${name}", ${name}.X)`,
    `\telse`,
    `\t\tprint("${name}", ${name})`,
    `\tend`,
  ];

  let uid = 0;

  function body(depth, indent) {
    const pad = '\t'.repeat(indent);
    const lines = [];
    const count = 1 + Math.floor(rnd() * 4);
    for (let k = 0; k < count; k += 1) {
      const name = pick(locals);
      const roll = rnd();
      if (roll < 0.16) {
        // the shape the copy pass folds: a register carrying one value, read a
        // couple of times, then refilled
        const v = `s${uid}`;
        uid += 1;
        lines.push(`${pad}local ${v} = ${pick(['t', 'u', 'n'])}`);
        lines.push(`${pad}print("${v}", type(${v}) == "table" and ${v}.X or ${v})`);
        lines.push(`${pad}${v} = ${pick(['5', 'nil', 'n', 'u'])}`);
        lines.push(`${pad}print("${v}b", type(${v}) == "table" and ${v}.X or ${v})`);
      } else if (roll < 0.3) {
        lines.push(`${pad}${name} = ${pick(VALUES)}`);
      } else if (roll < 0.4) {
        // a copy: this is the pattern the copy pass folds
        lines.push(`${pad}${name} = ${pick(['t', 'u', 'a', 'b', 'n'])}`);
      } else if (roll < 0.5) {
        lines.push(`${pad}local ${name} = ${pick(VALUES)}`);
      } else if (roll < 0.62) {
        lines.push(...safeRead(name).map((l) => pad + l.replace(/^\t/, '')));
      } else if (roll < 0.72 && depth < 2) {
        lines.push(`${pad}if ${pick(['n > 1', 'a ~= nil', 'b == nil', 'c', 'true'])} then`);
        lines.push(...body(depth + 1, indent + 1));
        if (rnd() < 0.5) {
          lines.push(`${pad}else`);
          lines.push(...body(depth + 1, indent + 1));
        }
        lines.push(`${pad}end`);
      } else if (roll < 0.82 && depth < 2) {
        lines.push(`${pad}for i = 1, 2 do`);
        lines.push(`${pad}\tlocal seen = ${name}`);
        lines.push(`${pad}\tif seen then print("seen", type(seen) == "table" and seen.X or seen) else print("seen nil") end`);
        lines.push(...body(depth + 1, indent + 1));
        lines.push(`${pad}\t${name} = ${pick(['t', 'u', 'n', '1', 'nil'])}`);
        lines.push(`${pad}end`);
      } else if (roll < 0.86 && depth < 2) {
        // while-loop: the body runs again, so a store at the bottom is read at
        // the top on the next pass
        lines.push(`${pad}local w${depth} = 2`);
        lines.push(`${pad}while w${depth} > 0 do`);
        lines.push(`${pad}\tlocal seen = ${name}`);
        lines.push(`${pad}\tif seen then print("seen", type(seen) == "table" and seen.X or seen) else print("seen nil") end`);
        lines.push(...body(depth + 1, indent + 1));
        lines.push(`${pad}\t${name} = ${pick(['t', 'u', 'n', 'nil'])}`);
        lines.push(`${pad}\tw${depth} -= 1`);
        lines.push(`${pad}end`);
      } else if (roll < 0.86) {
        // a statement that spans lines: positions inside it are not a line each
        lines.push(`${pad}print("multi",`);
        lines.push(`${pad}\t${name} ~= nil,`);
        lines.push(`${pad}\ttype(${name}) == "table")`);
      } else if (roll < 0.9) {
        // a closure over the register: what it reads must stay where it is
        lines.push(`${pad}local function peek${k}() return ${name} end`);
        lines.push(`${pad}print("peek", peek${k}() ~= nil)`);
      } else if (roll < 0.95) {
        // a temporary read once, right below
        lines.push(`${pad}local tmp = ${pick(['t.X', 'n', 'a', 'u'])}`);
        lines.push(`${pad}print("tmp", tmp ~= nil)`);
      } else {
        lines.push(`${pad}${name} = nil`);
      }
    }
    return lines;
  }

  out.push(...body(0, 0));
  locals.forEach((name) => out.push(...safeRead(name)));
  out.push('print("end")');
  return `${out.join('\n')}\n`;
}

function runPasses(src) {
  const r = spawnSync(getPythonBin(), [path.join(ROOT, 'scripts', 'passes.py')], {
    cwd: ROOT, input: src, encoding: 'utf8', env: pythonEnv(process.env),
  });
  if (r.status !== 0) throw new Error(r.stderr || 'passes.py failed');
  return { text: r.stdout, err: r.stderr || '' };
}

function countIn(re, text) {
  let total = 0;
  for (const m of text.matchAll(re)) total += Number(m[1]);
  return total;
}

function luau(src) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'fuzz-'));
  const file = path.join(dir, 'case.luau');
  fs.writeFileSync(file, src);
  const r = spawnSync(LUAU, [file], { cwd: ROOT, encoding: 'utf8' });
  fs.rmSync(dir, { recursive: true, force: true });
  return { code: r.status, out: (r.stdout || '').trim(), err: (r.stderr || '').trim() };
}

test('the text passes never change what a register-shaped program prints', () => {
  const failures = [];
  let copies = 0;
  let temps = 0;
  const total = Number(process.env.FUZZ_SEEDS || 400);
  for (let seed = 1; seed <= total; seed += 1) {
    const src = generate(seed);
    const run_ = runPasses(src);
    const after = run_.text;
    copies += countIn(/(\d+) copy\(ies\) inlined/g, run_.err);
    temps += countIn(/(\d+) temporary\(ies\) folded/g, run_.err);
    if (/pass skipped|pass failed/.test(run_.err)) {
      failures.push({ seed, src, after, before: { code: 0, out: '' }, passed: { code: 0, out: '' } });
      break;
    }
    const before = luau(src);
    const passed = luau(after);
    if (before.code !== passed.code || before.out !== passed.out) {
      failures.push({ seed, src, after, before, passed });
      if (failures.length >= 3) break;
    }
  }
  // the corpus has to actually exercise the passes, or a green run means nothing
  assert.ok(copies >= 20, `the corpus only folded ${copies} copies`);
  assert.ok(temps >= total * 0.75, `the corpus only folded ${temps} temporaries`);

  if (failures.length) {
    const f = failures[0];
    assert.fail(
      `passes changed behaviour (${failures.length} case(s), seed ${f.seed})\n` +
      `--- source\n${f.src}\n--- after passes\n${f.after}\n` +
      `--- before: ${JSON.stringify(f.before)}\n--- after:  ${JSON.stringify(f.passed)}`,
    );
  }
});
