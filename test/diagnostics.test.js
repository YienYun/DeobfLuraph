'use strict';

const assert = require('node:assert/strict');
const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const CORE = path.join(ROOT, 'core');
const { getPythonBin, pythonEnv } = require('../src/pyenv');

// Diagnostic text ends up inside the output (`-- devirt: ...`). If it carries
// an object address, two runs over one input produce different bytes; that is
// exactly the bug this suite exists to keep out. The values are formatted in
// Python, so the check runs there.
const PROBE = String.raw`
import json, sys
import luasym as S

class Slotted:
    __slots__ = ("a",)
    def __init__(self, a):
        self.a = a

t = S.LTable()
with_tid = S.LTable(); with_tid.tid = 7

print(json.dumps({
    "nil": S.describe_value(None),
    "true": S.describe_value(True),
    "false": S.describe_value(False),
    "int": S.describe_value(42),
    "float": S.describe_value(0.94743997235392186),
    "bytes": S.describe_value(bytes([104, 105, 10])),
    "table_untagged": S.describe_value(t),
    "table_tagged": S.describe_value(with_tid),
    "regfile": S.describe_value(S.RegFile()),
    "env": S.describe_value(S.EnvTable()),
    "upcontainer": S.describe_value(S.UpContainer(3)),
    "buffer": S.describe_value(S.Buf(b"abc")),
    "builtin": S.describe_value(S.Builtin("print")),
    "slotted": S.describe_value(Slotted(1)),
    "plain_object": S.describe_value(object()),
    "table_repr": repr(t),
    "scrub": S.scrub_addresses("len of <luasym.RegFile object at 0x7f00deadbeef>"),
    "scrub_keeps_hex": S.scrub_addresses("constant 0xdeadbeef stays"),
}))
`;

function probe() {
  const r = spawnSync(getPythonBin(), ['-c', PROBE], {
    cwd: CORE,
    encoding: 'utf8',
    env: pythonEnv({ PYTHONPATH: CORE }),
    timeout: 60000,
  });
  assert.equal(r.status, 0, `python probe failed: ${r.stderr}`);
  return JSON.parse(r.stdout);
}

test('internal values are described deterministically, without an address', () => {
  const out = probe();
  assert.equal(out.nil, 'nil');
  assert.equal(out.true, 'true');
  assert.equal(out.false, 'false');
  assert.equal(out.int, '42');
  assert.equal(out.float, '0.9474399723539219');
  assert.equal(out.bytes, '"hi\\10"');
  assert.equal(out.table_untagged, 'table(0 field(s))');
  assert.equal(out.table_tagged, 'table#7');
  assert.equal(out.regfile, 'register file');
  assert.equal(out.env, 'environment table');
  assert.equal(out.upcontainer, 'upvalue container #3');
  assert.equal(out.buffer, 'buffer(3 byte(s))');
  assert.equal(out.builtin, 'Builtin(print)');
  assert.equal(out.slotted, '<Slotted>');
  assert.equal(out.plain_object, '<object>');
});

test('no description or repr contains an object address', () => {
  const out = probe();
  for (const [key, value] of Object.entries(out)) {
    if (key === 'scrub_keeps_hex') continue;
    assert.ok(!/object at 0x/i.test(value), `${key}: ${value}`);
    assert.ok(!/LTable#\d{6,}/.test(value), `${key}: ${value}`);
  }
});

test('the two reprs of the same table agree, with and without a tag', () => {
  const out = probe();
  assert.ok(!/0x/.test(out.table_repr), out.table_repr);
  assert.equal(out.table_repr, 'LTable#-');
});

test('scrub_addresses rewrites addresses and leaves real hex constants alone', () => {
  const out = probe();
  assert.equal(out.scrub, 'len of <luasym.RegFile>');
  assert.equal(out.scrub_keeps_hex, 'constant 0xdeadbeef stays');
});

test('no Python source builds an output message with an object repr', () => {
  // Guards the class of bug rather than one site: `%r` of a VM value in a
  // message that reaches the output. Internal debug prints are fine.
  const offenders = [];
  const walk = (dir) => {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        if (['__pycache__', 'vendor', 'moonveil', 'moonveil21'].includes(entry.name)) continue;
        walk(full);
        continue;
      }
      if (!entry.name.endsWith('.py')) continue;
      const lines = fs.readFileSync(full, 'utf8').split('\n');
      lines.forEach((line, i) => {
        if (/Unsupported\(.*%r/.test(line) || /CommentS\(.*%r/.test(line)) {
          offenders.push(`${path.relative(ROOT, full)}:${i + 1}: ${line.trim()}`);
        }
      });
    }
  };
  walk(CORE);
  assert.deepEqual(offenders, [], `messages that can reach the output must use describe_value():\n${offenders.join('\n')}`);
});
