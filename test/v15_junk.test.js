'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('path');
const { spawnSync } = require('child_process');
const { getPythonBin } = require('../src/pyenv');

const ROOT = path.resolve(__dirname, '..');

// A constant of Luraph's anti-tamper check that no decoder produced must never
// reach the output as a value: a write of it is guessing, a call of it raises,
// and a call taking it is meaningless. `None`, on the other hand, is the walk's
// ordinary "no value yet" and must keep lifting.
const SCRIPT = `
import sys, json
sys.path.insert(0, ${JSON.stringify(path.join(ROOT, 'core'))})
import luasym as S
import ir
from obfuscators.luraph_v15.lifter import _poison_stmt
from obfuscators.luraph_v15.devirt import _drop_dead_upvalue_writes

undecoded = ir.Missing(None)
plain_none = S.Const(None)
call = lambda fn, args: ir.CallStmt('t1', fn, S.Multi(args))

checks = {
    # an undecoded constant written anywhere poisons the statement
    'assign_missing': _poison_stmt(ir.Assign(S.Reg(4), undecoded)),
    'assign_nested': _poison_stmt(ir.Assign(S.Reg(4), S.Bin('Mul', undecoded, S.Reg(9)))),
    'call_callee': _poison_stmt(call(undecoded, [S.Const(b'task')])),
    'call_arg': _poison_stmt(call(S.Global('bit32.band'), [undecoded, 4294967295])),
    'call_nil_callee': _poison_stmt(call(None, [S.Const(b'task')])),
    # ordinary code keeps lifting
    'assign_none_ok': not _poison_stmt(ir.Assign(S.Reg(4), plain_none)),
    'assign_const_ok': not _poison_stmt(ir.Assign(S.Reg(4), S.Const(b'items'))),
    'call_ok': not _poison_stmt(call(S.Global('print'), [S.Const(b'x')])),
    'call_nil_arg_ok': not _poison_stmt(call(S.Global('saveFile'), [plain_none])),
}

# a write-only VM upvalue carries a constant decoy; a name that is read
# anywhere is left alone
lines = ['\\tupv84 = "items"', '\\tlocal a = 1', '\\tprint(upv3)', '\\tupv3 = 5']
kept, dropped = _drop_dead_upvalue_writes(lines)
checks['dead_upv_dropped'] = dropped == 1
checks['dead_upv_kept_rest'] = kept == ['\\tlocal a = 1', '\\tprint(upv3)', '\\tupv3 = 5']

print(json.dumps(checks))
`;

test('v15 lifter drops statements built on undecoded constants, keeps real code', () => {
  const res = spawnSync(getPythonBin(), ['-c', SCRIPT], { cwd: ROOT, encoding: 'utf8' });
  assert.equal(res.status, 0, res.stderr || res.stdout);
  const out = JSON.parse(res.stdout.trim().split('\n').pop());
  for (const [k, v] of Object.entries(out)) {
    assert.equal(v, true, k);
  }
});
