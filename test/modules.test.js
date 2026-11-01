'use strict';

// A package that cannot be imported module by module is broken, not a runtime
// surprise: every engine submodule must import on its own.
const test = require('node:test');
const assert = require('node:assert/strict');
const path = require('path');
const { spawnSync } = require('child_process');

const detect = require('../src/detect');

const ROOT = path.resolve(__dirname, '..');
test('modular luraph_v15 subpackages and luraph_v14 layer import cleanly with full backward compatibility', () => {
  const py = spawnSync(
    'python3',
    [
      '-c',
      [
        'import sys; sys.path.insert(0, "core")',
        'from obfuscators.luraph_v15 import dump, dataflow, vm_model, stepper, lifter, patches, devirt, vmmap, driver',
        'from obfuscators.luraph_v14 import devirt as d14, driver as drv14',
        'for sym in ("Dump", "VMModel", "ProtoLifter", "Stepper", "WalkCache", "Program", "FunctionLifter", "lift_program", "collect_requests", "same_patches", "format_patches"):',
        '    assert hasattr(devirt, sym), f"missing {sym} on luraph_v15.devirt"',
        'print("MODULAR_OK")',
      ].join('\n'),
    ],
    { cwd: ROOT, encoding: 'utf8', timeout: 15000 }
  );
  assert.equal(py.status, 0, py.stderr);
  assert.match(py.stdout, /MODULAR_OK/);

  // Verify Luarmor _bsdata0 + superflow_bytecode detection
  const luarmorSample = '_bsdata0={1,2,3}\nsuperflow_bytecode={4,5,6}\n';
  assert.equal(detect.detect(luarmorSample).plugin.name, 'luarmor_client');
});
