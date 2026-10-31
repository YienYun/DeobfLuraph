#!/usr/bin/env node
'use strict';

/**
 * Semantic oracle for deobfuscation pairs.
 *
 * Runs the original script and the deobfuscated one under the same Luau binary
 * and compares the `CHECK ...` lines they print, in order. That is the only
 * honest answer to "is the output equivalent": the tool cannot be fooled by
 * formatting, renaming or reordering that keeps behaviour, and it fails loudly
 * when the deobfuscated copy crashes, prints less, or prints something else.
 *
 *   node tools/oracle/compare.js <original.lua> <deobfuscated.lua>
 *   node tools/oracle/compare.js <original> <deobf> --all     # compare every print, not just CHECK
 *   node tools/oracle/compare.js <original> <deobf> --bin bin/luau
 *
 * Exit code 0 when every line matches, 1 when they differ, 2 when a script
 * would not run at all.
 */

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..', '..');

function parseArgs(argv) {
  const args = { files: [], all: false, bin: path.join(ROOT, 'bin', process.platform === 'win32' ? 'luau.exe' : 'luau') };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--all') args.all = true;
    else if (a === '--bin') args.bin = argv[++i];
    else if (a === '--help' || a === '-h') args.help = true;
    else args.files.push(a);
  }
  return args;
}

function run(file, bin) {
  if (!fs.existsSync(file)) throw new Error(`no such file: ${file}`);
  // cwd is the script's folder: scripts that read siblings keep working
  const r = spawnSync(bin, [path.basename(file)], {
    cwd: path.dirname(path.resolve(file)),
    encoding: 'utf8',
    timeout: 120000,
    maxBuffer: 64 * 1024 * 1024,
  });
  const stdout = r.stdout || '';
  const stderr = (r.stderr || '').trim();
  return {
    lines: stdout.split('\n').map((l) => l.replace(/\s+$/, '')).filter((l) => l.length),
    ok: r.status === 0,
    status: r.status,
    stderr,
  };
}

function checks(lines, all) {
  const out = [];
  for (const line of lines) {
    if (all) out.push(line);
    else if (/^CHECK\b/.test(line.trim())) out.push(line.trim());
  }
  return out;
}

function firstDiff(a, b) {
  const n = Math.max(a.length, b.length);
  for (let i = 0; i < n; i++) {
    if (a[i] !== b[i]) return i;
  }
  return -1;
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help || args.files.length !== 2) {
    process.stderr.write('usage: node tools/oracle/compare.js <original.lua> <deobfuscated.lua> [--all] [--bin <luau>]\n');
    process.exit(args.help ? 0 : 2);
  }
  const [origFile, deobFile] = args.files;
  const want = run(origFile, args.bin);
  if (!want.ok) {
    process.stderr.write(`[!] the original does not run (exit ${want.status}): ${want.stderr.split('\n')[0]}\n`);
    process.exit(2);
  }
  const got = run(deobFile, args.bin);
  if (!got.ok) {
    process.stderr.write(`[!] the deobfuscated copy does not run (exit ${got.status}): ${got.stderr.split('\n')[0]}\n`);
    process.exit(2);
  }

  const a = checks(want.lines, args.all);
  const b = checks(got.lines, args.all);
  const at = firstDiff(a, b);
  const name = path.basename(deobFile);

  if (at === -1 && a.length === b.length) {
    process.stdout.write(`[+] ${name}: ${a.length} checked line(s) identical to ${path.basename(origFile)}\n`);
    process.exit(0);
  }

  process.stdout.write(`[!] ${name}: output differs from ${path.basename(origFile)}\n`);
  process.stdout.write(`    lines: original ${a.length}, deobfuscated ${b.length}\n`);
  if (at >= 0) {
    process.stdout.write(`    first difference at line ${at + 1}:\n`);
    process.stdout.write(`      original     : ${a[at] === undefined ? '<nothing>' : a[at]}\n`);
    process.stdout.write(`      deobfuscated : ${b[at] === undefined ? '<nothing>' : b[at]}\n`);
  }
  process.exit(1);
}

try {
  main();
} catch (err) {
  process.stderr.write(`[!] ${err.message}\n`);
  process.exit(2);
}
