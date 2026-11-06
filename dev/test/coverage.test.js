'use strict';
const test = require('node:test');
const assert = require('node:assert');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..', '..');
const PY = process.env.PYTHON || 'python3';

const PRELUDE = `
import json, os, sys
sys.path.insert(0, 'engine')
sys.path.insert(0, os.path.join('engine', 'obfuscators', 'luraph_v15'))
import dump as D
`;

function run(body) {
  const r = spawnSync(PY, ['-c', PRELUDE + body], { cwd: ROOT, encoding: 'utf8' });
  assert.equal(r.status, 0, r.stderr);
  return JSON.parse(r.stdout.trim());
}

test('the scan flag is read per array, and silence is not a zero', () => {
  const out = run(`
d = {"tables": {"1": {"arr": [], "kv": [], "scan": 1},
                "2": {"arr": [], "kv": [], "scan": 0},
                "3": {"arr": [], "kv": []}}, "protos": {}}
s, r = D._scan_flags(d)
print(json.dumps({"scanned": sorted(s), "restored": sorted(r)}))
`);
  assert.deepEqual(out, { scanned: [1], restored: [2] });
});

test('a merge keeps an array scanned when any run walked it', () => {
  const out = run(`
a = {"tables": {"1": {"arr": [], "kv": [], "scan": 1},
                "2": {"arr": [], "kv": [], "scan": 0}}, "protos": {}}
b = {"tables": {"1": {"arr": [], "kv": [], "scan": 0},
                "2": {"arr": [], "kv": [], "scan": 0}}, "protos": {}}
u, info, scan = D.union_exec_runs([json.dumps(a), json.dumps(b)], base_text=json.dumps(a))
print(json.dumps({"scanned": sorted(scan["scanned"]), "restored": sorted(scan["restored"]),
                  "exec": sorted(u)}))
`);
  assert.deepEqual(out, { scanned: [1], restored: [2], exec: [] });
});

test('a dump with no flags leaves every verdict unspoken', () => {
  const out = run(`
d = {"tables": {"1": {"arr": [], "kv": []}}, "protos": {}}
s, r = D._scan_flags(d)
print(json.dumps({"scanned": sorted(s), "restored": sorted(r)}))
`);
  assert.deepEqual(out, { scanned: [], restored: [] });
});
