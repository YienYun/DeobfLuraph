'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('path');
const { spawnSync } = require('child_process');
const { getPythonBin } = require('../src/pyenv');

const ROOT = path.resolve(__dirname, '..');

// structure.prune_constant_guards() runs inside the Python core; drive it with
// synthetic blocks so the tamper-guard pruning stays covered without a trace.
const SCRIPT = `
import sys, json
sys.path.insert(0, ${JSON.stringify(path.join(ROOT, 'core'))})
import structure as ST

def blk(bid, kind, succ=(), stmts=()):
    b = ST.Block(bid)
    b.kind, b.succ, b.stmts = kind, list(succ), list(stmts)
    return b

def link(blocks):
    for b in blocks.values():
        b.preds = []
    for b in blocks.values():
        for s in b.succ:
            blocks[s].preds.append(b.id)

# if not (guard) then <tamper chain> error end; return real
blocks = {1: blk(1, 'cond', (2, 4)), 2: blk(2, 'goto', (3,), ['scratch = 1']),
          3: blk(3, 'goto', (5,)), 4: blk(4, 'ret'), 5: blk(5, 'error')}
blocks[5].error = 'needs a constant that is not decoded yet (at 0:156)'
link(blocks)
n = ST.prune_constant_guards(1, blocks)
cond_ok = blocks[1].kind == 'goto' and blocks[1].cond is None and blocks[1].succ == [4]
chain_ok = blocks[2].kind == 'end' and blocks[2].stmts == [] and blocks[3].kind == 'end'
guard_ok = blocks[5].kind == 'end' and blocks[5].error is None
other_untouched = blocks[4].kind == 'ret'

# a guard with no condition above it keeps what was already lifted
blocks2 = {1: blk(1, 'goto', (2,), ['call_it()']), 2: blk(2, 'error')}
blocks2[2].error = 'needs a constant that is not decoded yet (at 0:7)'
link(blocks2)
m = ST.prune_constant_guards(1, blocks2)
lone_ok = blocks2[2].kind == 'end' and blocks2[2].error is None and blocks2[1].stmts == ['call_it()']

# ordinary errors are left alone
blocks3 = {1: blk(1, 'error')}
blocks3[1].error = 'symbolic next pc/mode: r3 / 0'
link(blocks3)
k = ST.prune_constant_guards(1, blocks3)
plain_ok = blocks3[1].kind == 'error'

print(json.dumps({'n': n, 'm': m, 'k': k, 'cond': cond_ok, 'chain': chain_ok,
                  'guard': guard_ok, 'ret': other_untouched, 'lone': lone_ok,
                  'plain': plain_ok}))
`;

test('structure prunes dead integrity-guard branches but keeps real ones intact', () => {
  const res = spawnSync(getPythonBin(), ['-c', SCRIPT], { cwd: ROOT, encoding: 'utf8' });
  assert.equal(res.status, 0, res.stderr || res.stdout);
  const out = JSON.parse(res.stdout.trim().split('\n').pop());
  assert.equal(out.n, 1);
  assert.equal(out.m, 1);
  assert.equal(out.k, 0);
  for (const k of ['cond', 'chain', 'guard', 'ret', 'lone', 'plain']) {
    assert.equal(out[k], true, k);
  }
});
