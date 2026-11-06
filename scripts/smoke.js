'use strict';


const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const { spawnSync } = require('node:child_process');

const ROOT = path.resolve(__dirname, '..');
const harness = require(path.join(ROOT, 'core', 'harness'));

function smoke(file, opts = {}) {
  const source = fs.readFileSync(file, 'latin1');
  const cfg = {
    time_budget: opts.budget || 6000,
    dump_strings: false,
    executor: opts.executor || 'auto',
    offline_http: true,
  };
  const text = harness.buildHarness(source, cfg, {});
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'smoke-'));
  const hpath = path.join(dir, 'harness.luau');
  fs.writeFileSync(hpath, text, 'latin1');
  const r = spawnSync(harness.findLuau(), [hpath], {
    encoding: 'utf8',
    timeout: (opts.timeout || 60) * 1000,
    maxBuffer: 64 * 1024 * 1024,
  });
  fs.rmSync(dir, { recursive: true, force: true });
  const stdout = r.stdout || '';
  const stderr = r.stderr || '';
  const marker = harness.getMark();
  const lines = stdout.split('\n').filter((l) => l && !l.includes(marker));
  const statusLine = (lines.find((l) => /^-- run status:/.test(l)) || '').trim();
  const failed = /error|aborted|timed out/i.test(statusLine) && !/finished/i.test(statusLine);
  return {
    status: r.status,
    signal: r.signal,
    runStatus: statusLine.replace(/^-- run status:\s*/, ''),
    failed,
    error: (stderr.match(/^.*?:(\d+):\s*(.*)$/m) || [])[0] || '',
    stderr,
    lines,
  };
}

function main() {
  const file = process.argv[2];
  if (!file) {
    process.stderr.write('usage: node scripts/smoke.js <file.luau> [-v]\n');
    process.exit(2);
  }
  const res = smoke(file, { timeout: 120 });
  const verbose = process.argv.includes('-v');
  process.stdout.write(`file      ${file}\n`);
  process.stdout.write(`status    ${res.status === null ? `killed (${res.signal})` : res.status}\n`);
  process.stdout.write(`run       ${res.runStatus || '(no status line)'}\n`);
  process.stdout.write(`events    ${res.lines.length}\n`);
  if (res.error) process.stdout.write(`error     ${res.error}\n`);
  if (verbose || res.status !== 0) {
    for (const line of res.lines.slice(0, 40)) process.stdout.write(`  ${line}\n`);
    if (res.stderr) {
      const tail = res.stderr.trim().split('\n').slice(-8).join('\n');
      process.stdout.write(`stderr    ${tail}\n`);
    }
  }
  process.exit(res.status === 0 && !res.failed ? 0 : 1);
}

if (require.main === module) main();

module.exports = { smoke };
