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

const FIND = `
import sys, json
sys.path.insert(0, 'core')
import ast_polish, carrier
src = """local function payload(argument, second, third)
\targument:H2({}, 0)
\tfor k in argument:g2(argument[72]) do end
\tlocal untouched = second
end
"""
root = ast_polish._parse_ast(src)
fn = root['body'][0]['func']
names = carrier.helpers(fn)
print(json.dumps({'names': names, 'stub': carrier.stub_source(names),
                  'none': carrier.stub_source([])}))
`;

function carrierInfo() {
  const r = spawnSync(getPythonBin(), ['-c', FIND], { cwd: ROOT, encoding: 'utf8', env: pythonEnv(process.env) });
  if (r.status !== 0) throw new Error(r.stderr || 'carrier query failed');
  return JSON.parse(r.stdout);
}

function luau(src) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'carrier-'));
  const file = path.join(dir, 'case.luau');
  fs.writeFileSync(file, src);
  const r = spawnSync(LUAU, [file], { cwd: ROOT, encoding: 'utf8' });
  fs.rmSync(dir, { recursive: true, force: true });
  if (r.error) throw r.error;
  return { status: r.status, stdout: r.stdout, stderr: r.stderr };
}

test('the helpers a script reads off its first argument are found in order', () => {
  assert.deepEqual(carrierInfo().names, ['H2', 'g2', '[72]']);
});

test('a script that reads nothing off the argument gets no stub', () => {
  assert.deepEqual(carrierInfo().none, []);
});

test('the stub is inert until a helper is used, and names it when one is', () => {
  const { stub } = carrierInfo();
  const out = luau([...stub,
    'local helpers = loaderHelpers()',
    'print(type(helpers))',
    'local ok, err = pcall(function() return helpers.H2({}, 0) end)',
    'print(ok, err)',
    'local ok2, err2 = pcall(function() return helpers[72] end)',
    'print(ok2, err2)',
    '',
  ].join('\n'));
  assert.equal(out.status, 0, out.stderr);
  const lines = out.stdout.trim().split('\n');
  assert.equal(lines[0], 'table');
  assert.match(lines[1], /^false\t/);
  assert.match(lines[1], /needs `H2`/);
  assert.match(lines[1], /helper table \(H2, g2, \[72\]\)/);
  assert.match(lines[2], /needs `72`/);
});
