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

// structure.poison_unknown_callees(): a direct call of a register the finished
// function never defines cannot be Lua, so the call statement is dropped and its
// results become the engine's `Missing` (printed as `nil --[[ constant not
// decoded ]]`) instead of `(nil)(...)`.
const POISON_SCRIPT = `
import sys, json
sys.path.insert(0, ${JSON.stringify(path.join(ROOT, 'core'))})
import structure as ST
import ir as D
from luasym import Reg, Const, Multi, TempTail

def blk(bid, kind, stmts=(), values=None):
    b = ST.Block(bid)
    b.kind, b.stmts, b.values = kind, list(stmts), values
    return b

call = lambda t, fn, args: D.CallStmt(t, fn, Multi(list(args)))

# 1: return (reg 104)(reg 85, reg 104) -- nothing defines 104 or 85
# 2: call through reg 5, which block 3 assigns
# 3: the definition
# 4: call through reg 7, a register a frame binding names
# 5: call through reg 9 with results nobody reads (the printer drops it)
blocks = {
    1: blk(1, 'ret', [call('t1', Reg(104), [Reg(85), Reg(104)])], Multi([], TempTail('t1'))),
    2: blk(2, 'goto', [call('t2', Reg(5), [Reg(1)]), D.Assign(Reg(2), D.TempVal('t2', 1))]),
    3: blk(3, 'goto', [D.Assign(Reg(5), Const(1))]),
    4: blk(4, 'goto', [call('t3', Reg(7), [Reg(1)]), D.Assign(Reg(3), D.TempVal('t3', 1))]),
    5: blk(5, 'end', [call('t4', Reg(9), [Reg(1)])]),
}
for b in blocks.values():
    b.preds = []
n = ST.poison_unknown_callees(1, blocks, D, {7})
ret = blocks[1].values
out = {
    'n': n,
    'dropped': blocks[1].stmts == [],
    'poisoned': len(ret.items) == 1 and type(ret.items[0]).__name__ == 'Missing' and ret.tail is None,
    'defined_kept': isinstance(blocks[2].stmts[0], D.CallStmt),
    'frame_kept': isinstance(blocks[4].stmts[0], D.CallStmt),
    'unused_kept': isinstance(blocks[5].stmts[0], D.CallStmt),
}

# a callee built out of a register is left alone: it names whatever its parts do
blocks2 = {1: blk(1, 'goto', [call('t5', D.Index(Reg(104), Const("JSONEncode")), [Reg(1)]),
                              D.Assign(Reg(2), D.TempVal('t5', 1))])}
blocks2[1].preds = []
m = ST.poison_unknown_callees(1, blocks2, D)
out['expr_callee_kept'] = isinstance(blocks2[1].stmts[0], D.CallStmt) and m == 0
print(json.dumps(out))
`;

test('structure poisons a call of a register the function never defines', () => {
  const res = spawnSync(getPythonBin(), ['-c', POISON_SCRIPT], { cwd: ROOT, encoding: 'utf8' });
  assert.equal(res.status, 0, res.stderr || res.stdout);
  const out = JSON.parse(res.stdout.trim().split('\n').pop());
  assert.equal(out.n, 1);
  for (const k of ['dropped', 'poisoned', 'defined_kept', 'frame_kept', 'unused_kept', 'expr_callee_kept']) {
    assert.equal(out[k], true, k);
  }
});
