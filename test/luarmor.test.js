'use strict';

const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const detect = require('../src/detect');
const { getPythonBin, pythonEnv } = require('../src/pyenv');

const ROOT = path.resolve(__dirname, '..');
const CORE = path.join(ROOT, 'core');
const ANALYZER = path.join(CORE, 'obfuscators', 'luarmor', 'analyze.py');
const STUB = path.join(ROOT, 'samples', 'input', 'Luarmor', 'SampleV1_client_stub.lua');
const INIT = path.join(ROOT, 'samples', 'input', 'Luarmor', 'SampleV2_sephal_init.lua');

function analyze(file) {
  const r = spawnSync(getPythonBin(), [ANALYZER, file, '--json'], {
    encoding: 'utf8',
    env: pythonEnv({ PYTHONPATH: CORE }),
  });
  assert.equal(r.status, 0, r.stderr);
  return JSON.parse(r.stdout);
}

test('luarmor: the detector routes the whole v4 chain to the luarmor track', () => {
  const cases = [
    ['_bsdata0={1,2,"LAC.D_abc"};\nlocal f,b,a="static_content_1","k";\na=game:HttpGet("https://cdn.luarmor.net/v4_init_jan7.lua")', 'luarmor_client'],
    ['superflow_bytecode={"\\1\\2"};\nreturn setmetatable({[1]=bit32.band})', 'luarmor_client'],
    ['-- This file was protected using Luraph Obfuscator v15.0 [https://lura.ph/]\nreturn setmetatable({[1]=bit32.band})', 'luraph_v15'],
    ['-- This file was protected using Luraph Obfuscator v15.0 [https://lura.ph/]\nlocal url="https://api.luarmor.net/files/v4/loaders/9a74869874633cdef1929e4479b1d393.lua"\nreturn setmetatable({[1]=bit32.band})', 'luarmor_client'],
  ];
  for (const [src, want] of cases) {
    assert.equal(detect.detect(src).plugin.name, want, src.slice(0, 60));
  }
});

// The corpus is local-only (samples/README.md); skip rather than fail on a
// fresh clone that has no captured sessions to analyse.
const missingSample = [STUB, INIT].find((f) => !fs.existsSync(f));
const SKIP = missingSample ? `sample not present: ${path.relative(ROOT, missingSample)}` : false;

test('luarmor: a client stub is parsed, not faked', { skip: SKIP }, () => {
  const meta = analyze(STUB);
  assert.equal(meta.kind, 'client_stub');
  assert.equal(meta.luraph_payload, false);
  assert.equal(meta.init_url, 'https://cdn.luarmor.net/v4_init_jan7.lua');
  assert.match(meta.cache_key, /^[0-9a-f]+-beta$/);
  assert.ok(meta.bsdata0.client_tag.value.startsWith('LAC.D_'));
  assert.equal(meta.bsdata0.client_tag.alphabet, '-.012345ABCDELR_');
  assert.ok(meta.bsdata0.hash_fields.length >= 1);
  assert.ok(meta.bsdata0.hash_fields.every((h) => /^[0-9a-f]+$/.test(h.digest)));
  assert.ok(meta.bsdata0.hash_fields.some((h) => h.hex_length % 2 === 0 && h.bytes >= 16));
  assert.equal(meta.bsdata0.build_stamp.value, 1769015477);
  assert.ok(meta.notes.some((n) => n.includes('not in this file')));
});

test('luarmor: the sephal init is recognised as liftable code', { skip: SKIP }, () => {
  const meta = analyze(INIT);
  assert.equal(meta.kind, 'sephal_init');
  assert.equal(meta.luraph_payload, true);
  assert.equal(meta.superflow.has_blob, true);
  assert.equal(meta.superflow.has_vm_chunk, true);
  assert.ok(meta.superflow.blob_bytes > 1000);
});

test('luarmor: sample outputs keep the chain documented', () => {
  const outDir = path.join(ROOT, 'samples', 'output', 'Luarmor');
  const stubOut = path.join(outDir, 'SampleV1_client_stub.lua');
  if (!fs.existsSync(stubOut)) return;                   // outputs are generated, not required
  const stub = fs.readFileSync(stubOut, 'utf8');
  assert.match(stub, /^-- Luarmor v4: Luarmor v4 client stub/);
  assert.match(stub, /_bsdata0=\{/);                     // the stub body is kept verbatim
  assert.match(stub, /not the protected script/);
  const report = JSON.parse(fs.readFileSync(path.join(outDir, 'SampleV1_client_stub.luarmor.json'), 'utf8'));
  assert.equal(report.kind, 'client_stub');

  const initOut = fs.readFileSync(path.join(outDir, 'SampleV2_sephal_init.lua'), 'utf8');
  assert.match(initOut, /^-- Luarmor v4: Luarmor v4 sephal init/);
  assert.ok(initOut.split('\n').length > 100);
  const initReport = JSON.parse(fs.readFileSync(path.join(outDir, 'SampleV2_sephal_init.luarmor.json'), 'utf8'));
  assert.equal(initReport.kind, 'sephal_init');
});
