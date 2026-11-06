#!/usr/bin/env node
'use strict';


const crypto = require('crypto');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..', '..');
const GOLDEN = path.join(ROOT, 'dev', 'test', 'golden.json');
const MANIFEST = path.join(ROOT, 'dev', 'fixtures', 'manifest.json');
const INPUT = path.join(ROOT, 'dev', 'fixtures', 'input');

const DEFAULT_ARGS = ['--budget', '30', '--timeout', '90'];

function parseArgs(argv) {
  const args = { tier: 'core', only: null };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--tier') args.tier = argv[++i];
    else if (a === '--only') args.only = new Set(String(argv[++i] || '').split(',').filter(Boolean));
    else if (a === '--help' || a === '-h') args.help = true;
    else throw new Error(`unknown option: ${a}`);
  }
  return args;
}

function runEngine(sample, outPath, reportPath) {
  const input = path.join(INPUT, sample.file);
  const r = spawnSync(process.execPath, [
    path.join(ROOT, 'deob.js'), input, '-o', outPath, '--report', reportPath, ...DEFAULT_ARGS,
  ], { cwd: ROOT, encoding: 'utf8', maxBuffer: 64 * 1024 * 1024, timeout: 20 * 60 * 1000 });

  const report = fs.existsSync(reportPath)
    ? JSON.parse(fs.readFileSync(reportPath, 'utf8'))
    : null;
  const out = fs.existsSync(outPath) ? fs.readFileSync(outPath) : null;
  return {
    status: r.status,
    stdout: r.stdout || '',
    stderr: r.stderr || '',
    report,
    bytes: out,
  };
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    process.stdout.write('usage: node dev/scripts/update-golden.js [--tier core|all] [--only id,id]\n');
    return;
  }

  const manifest = JSON.parse(fs.readFileSync(MANIFEST, 'utf8'));
  const samples = manifest.samples.filter((s) => {
    if (args.only) return args.only.has(s.id);
    return args.tier === 'all' ? true : s.tier === 'core';
  });

  const tmp = fs.mkdtempSync(path.join(os.tmpdir(), 'deobf-golden-'));
  const rows = [];
  try {
    for (const sample of samples) {
      const input = path.join(INPUT, sample.file);
      if (!fs.existsSync(input)) {
        process.stderr.write(`[!] ${sample.id}: missing fixture, run scripts/fixtures.js fetch\n`);
        continue;
      }
      process.stdout.write(`[*] ${sample.id} …\n`);
      const outPath = path.join(tmp, `${sample.id}.luau`);
      const reportPath = path.join(tmp, `${sample.id}.json`);
      const res = runEngine(sample, outPath, reportPath);

      const row = {
        id: sample.id,
        file: sample.file,
        args: DEFAULT_ARGS,
        exit_code: res.status,
      };
      if (res.report) {
        row.result_type = res.report.result_type;
        row.lines = res.bytes ? res.bytes.toString('utf8').split('\n').length - 1 : 0;
        row.bytes = res.report.output_bytes;
        row.sha256 = res.report.output_sha256;
        row.md5 = res.bytes ? crypto.createHash('md5').update(res.bytes).digest('hex') : null;
        row.functions = res.report.lift_stats ? res.report.lift_stats.functions : null;
        row.trace_status = res.report.trace_status;
      }
      if (res.status !== 0 && !row.result_type) {
        row.expected_error = true;
        row.message = (res.stderr.split('\n').find((l) => l.includes('failed on')) || '').trim();
      }
      rows.push(row);
    }
  } finally {
    fs.rmSync(tmp, { recursive: true, force: true });
  }

  const doc = {
    schema_version: 1,
    generated_by: 'dev/scripts/update-golden.js',
    note: 'Pinned results of the deterministic engine. Regenerate only with an intended change.',
    node: process.version,
    samples: rows,
  };
  fs.writeFileSync(GOLDEN, JSON.stringify(doc, null, 2) + '\n');
  process.stdout.write(`\n[+] ${rows.length} row(s) written to test/golden.json\n`);
}

main();
