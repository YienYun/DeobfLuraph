'use strict';

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const MANIFEST_PATH = path.join(ROOT, 'fixtures', 'manifest.json');
const manifest = JSON.parse(fs.readFileSync(MANIFEST_PATH, 'utf8'));

const SHA256_RE = /^[0-9a-f]{64}$/;
const BLOB_RE = /^[0-9a-f]{40}$/;

test('the manifest declares a supported schema', () => {
  assert.equal(manifest.schema_version, 1);
  assert.ok(Array.isArray(manifest.samples));
  assert.ok(manifest.samples.length > 0);
});

test('every sample is pinned by repo, path, blob id and sha256', () => {
  for (const sample of manifest.samples) {
    assert.match(sample.id, /^[a-z0-9-]+$/, sample.id);
    assert.ok(sample.file.endsWith('.lua'), sample.file);
    assert.ok(['luraph_v14', 'luraph_v15'].includes(sample.family), sample.id);
    assert.ok(['core', 'full'].includes(sample.tier), sample.id);
    assert.ok(sample.source.repo.includes('/'), sample.id);
    assert.ok(/\.lua$/.test(sample.source.path) || /^[\w. -]+$/.test(sample.source.path), sample.id);
    assert.match(sample.source.blob, BLOB_RE, sample.id);
    assert.match(sample.sha256, SHA256_RE, sample.id);
    assert.ok(Number.isSafeInteger(sample.source.bytes) && sample.source.bytes > 0, sample.id);
  }
});

test('ids and file names are unique', () => {
  const ids = manifest.samples.map((s) => s.id);
  const files = manifest.samples.map((s) => s.file);
  assert.equal(new Set(ids).size, ids.length);
  assert.equal(new Set(files).size, files.length);
});

test('the fast tier is small enough for a test run', () => {
  const core = manifest.samples.filter((s) => s.tier === 'core');
  assert.ok(core.length >= 2, 'the core tier needs at least two samples');
  const bytes = core.reduce((n, s) => n + s.source.bytes, 0);
  assert.ok(bytes < 2 * 1024 * 1024, `core tier is ${bytes} bytes`);
});

test('a local copy, when present, matches its sha256', (t) => {
  const dir = path.join(ROOT, 'fixtures', 'input');
  if (!fs.existsSync(dir)) {
    t.skip('fixtures/input is absent; run: node scripts/fixtures.js fetch');
    return;
  }
  const crypto = require('node:crypto');
  for (const sample of manifest.samples) {
    const file = path.join(dir, sample.file);
    if (!fs.existsSync(file)) continue;
    const digest = crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
    assert.equal(digest, sample.sha256, `${sample.file} does not match the manifest`);
  }
});
