#!/usr/bin/env node
'use strict';

/**
 * Fixture manager.
 *
 * The protected samples are third-party files of 0.1–3 MB. They are not
 * committed; `fixtures/manifest.json` pins each one by repository, path, blob
 * id and sha256, so a test run either gets exactly the bytes the tests were
 * written against or says so and stops.
 *
 *   node scripts/fixtures.js fetch                 # every tier
 *   node scripts/fixtures.js fetch --tier core     # the fast set only
 *   node scripts/fixtures.js fetch --only t14-8-0942,lph-v15-0-lph1
 *   node scripts/fixtures.js fetch --force         # re-download
 *   node scripts/fixtures.js fetch --from ~/samples  # import verified local copies
 *   node scripts/fixtures.js verify                # hash what is on disk
 *
 * GitHub's API allows 60 anonymous requests an hour; set GITHUB_TOKEN to raise
 * it. Files are written atomically, so an interrupted run never leaves a
 * truncated sample behind.
 */

const crypto = require('crypto');
const fs = require('fs');
const os = require('os');
const path = require('path');

const ROOT = path.resolve(__dirname, '..');
const MANIFEST = path.join(ROOT, 'fixtures', 'manifest.json');
const INPUT = path.join(ROOT, 'fixtures', 'input');

function parseArgs(argv) {
  const args = { command: null, tier: 'all', only: null, force: false, quiet: false, from: null };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === 'fetch' || a === 'verify' || a === 'list') args.command = a;
    else if (a === '--tier') args.tier = argv[++i];
    else if (a === '--only') args.only = new Set(String(argv[++i] || '').split(',').filter(Boolean));
    else if (a === '--force') args.force = true;
    else if (a === '--from') args.from = argv[++i];
    else if (a === '--quiet') args.quiet = true;
    else if (a === '-h' || a === '--help') args.command = 'help';
    else throw new Error(`unknown option: ${a}`);
  }
  if (!args.command) args.command = 'help';
  if (!['all', 'core', 'full'].includes(args.tier)) {
    throw new Error('--tier must be all, core, or full');
  }
  return args;
}

function loadManifest() {
  const manifest = JSON.parse(fs.readFileSync(MANIFEST, 'utf8'));
  if (manifest.schema_version !== 1) {
    throw new Error(`fixtures/manifest.json: unsupported schema_version ${manifest.schema_version}`);
  }
  return manifest;
}

function selected(manifest, args) {
  return manifest.samples.filter((s) => {
    if (args.only) return args.only.has(s.id);
    if (args.tier === 'core') return s.tier === 'core';
    return true;
  });
}

function sha256(buf) {
  return crypto.createHash('sha256').update(buf).digest('hex');
}

function human(bytes) {
  if (!bytes) return '-';
  if (bytes >= 1024 * 1024) return `${(bytes / 1024 / 1024).toFixed(1)} MB`;
  return `${Math.max(1, Math.round(bytes / 1024))} KB`;
}

function writeAtomic(dest, buf) {
  fs.mkdirSync(path.dirname(dest), { recursive: true });
  const tmp = path.join(path.dirname(dest), `.${path.basename(dest)}.${process.pid}.tmp`);
  fs.writeFileSync(tmp, buf);
  fs.renameSync(tmp, dest);
}

async function download(sample) {
  const { repo, blob } = sample.source;
  const url = `https://api.github.com/repos/${repo}/git/blobs/${blob}`;
  const headers = { Accept: 'application/vnd.github.raw', 'User-Agent': 'deobfluraph-fixtures' };
  if (process.env.GITHUB_TOKEN) headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;

  let res;
  try {
    res = await fetch(url, { headers, redirect: 'follow' });
  } catch (err) {
    // Node reports every transport failure as "fetch failed"; the cause is what
    // the operator needs (a proxy's certificate, DNS, no network).
    const cause = err.cause ? `${err.cause.code || ''} ${err.cause.message || ''}`.trim() : '';
    throw new Error(`could not reach api.github.com (${cause || err.message}). `
      + 'Behind a TLS-inspecting proxy, either point Node at its CA via NODE_EXTRA_CA_CERTS '
      + 'or import copies you already have with --from <dir>.');
  }
  if (!res.ok) {
    const body = (await res.text().catch(() => '')).slice(0, 200).replace(/\s+/g, ' ');
    throw new Error(`${repo}@${blob.slice(0, 8)}: HTTP ${res.status} ${res.statusText} ${body}`.trim());
  }
  return Buffer.from(await res.arrayBuffer());
}

function report(row) {
  const status = row.ok ? 'ok' : 'MISMATCH';
  process.stdout.write(
    `${status.padEnd(8)} ${row.id.padEnd(18)} ${row.file.padEnd(20)} ${human(row.bytes).padStart(8)}  ${row.detail}\n`
  );
}

function localIndex(dir) {
  const index = new Map();
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (!entry.isFile()) continue;
    const full = path.join(dir, entry.name);
    const stat = fs.statSync(full);
    if (stat.size > 8 * 1024 * 1024) continue;
    index.set(sha256(fs.readFileSync(full)), full);
  }
  return index;
}

async function cmdFetch(args) {
  const manifest = loadManifest();
  const samples = selected(manifest, args);
  if (!samples.length) throw new Error('no sample matched the filter');
  const fromIndex = args.from ? localIndex(path.resolve(args.from)) : null;

  let failures = 0;
  for (const sample of samples) {
    const dest = path.join(INPUT, sample.file);
    if (!args.force && fs.existsSync(dest)) {
      const onDisk = fs.readFileSync(dest);
      const digest = sha256(onDisk);
      if (digest === sample.sha256) {
        if (!args.quiet) report({ ...sample, ok: true, bytes: onDisk.length, detail: 'cached' });
        continue;
      }
      if (!args.quiet) process.stdout.write(`stale    ${sample.id.padEnd(18)} re-downloading\n`);
    }

    let buf;
    try {
      if (fromIndex) {
        const hit = fromIndex.get(sample.sha256);
        if (!hit) throw new Error(`no file in ${args.from} has sha256 ${sample.sha256.slice(0, 12)}…`);
        buf = fs.readFileSync(hit);
      } else {
        buf = await download(sample);
      }
    } catch (err) {
      failures++;
      report({ ...sample, ok: false, bytes: 0, detail: err.message });
      continue;
    }

    const digest = sha256(buf);
    if (digest !== sample.sha256 || buf.length !== sample.source.bytes) {
      failures++;
      report({
        ...sample,
        ok: false,
        bytes: buf.length,
        detail: `expected ${sample.source.bytes} bytes sha256 ${sample.sha256.slice(0, 12)}…, `
          + `got ${buf.length} bytes ${digest.slice(0, 12)}…`,
      });
      continue;
    }

    writeAtomic(dest, buf);
    report({
      ...sample,
      ok: true,
      bytes: buf.length,
      detail: fromIndex ? 'imported + verified' : 'fetched + verified',
    });
  }

  if (failures) {
    throw new Error(`${failures} of ${samples.length} fixture(s) could not be fetched or verified`);
  }
  process.stdout.write(`\n[+] ${samples.length} fixture(s) ready in fixtures/input\n`);
}

function cmdVerify(args) {
  const manifest = loadManifest();
  const samples = selected(manifest, args);
  let missing = 0;
  let bad = 0;
  for (const sample of samples) {
    const dest = path.join(INPUT, sample.file);
    if (!fs.existsSync(dest)) {
      missing++;
      report({ ...sample, ok: false, bytes: 0, detail: 'missing (run: node scripts/fixtures.js fetch)' });
      continue;
    }
    const buf = fs.readFileSync(dest);
    const digest = sha256(buf);
    if (digest !== sample.sha256) {
      bad++;
      report({ ...sample, ok: false, bytes: buf.length, detail: `sha256 ${digest.slice(0, 12)}… != manifest` });
      continue;
    }
    report({ ...sample, ok: true, bytes: buf.length, detail: 'sha256 matches' });
  }
  if (missing || bad) throw new Error(`${missing} missing, ${bad} corrupted`);
  process.stdout.write(`\n[+] ${samples.length} fixture(s) verified\n`);
}

function cmdList() {
  const manifest = loadManifest();
  for (const s of manifest.samples) {
    process.stdout.write(
      `${s.id.padEnd(18)} ${s.tier.padEnd(5)} ${s.family.padEnd(12)} ${String(s.build).padEnd(6)} `
        + `${human(s.source.bytes).padStart(8)}  ${s.source.repo}/${s.source.path}\n`
    );
  }
}

function usage() {
  process.stdout.write(
    'usage: node scripts/fixtures.js <fetch|verify|list> [--tier core|full|all] '
      + '[--only id,id] [--force] [--from DIR] [--quiet]\n'
  );
}

async function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.command === 'help') return usage();
  if (args.command === 'list') return cmdList();
  if (args.command === 'verify') return cmdVerify(args);
  return cmdFetch(args);
}

main().catch((err) => {
  process.stderr.write(`[!] ${err.message}\n`);
  process.exitCode = 1;
});

module.exports = { loadManifest, selected, sha256, INPUT };
