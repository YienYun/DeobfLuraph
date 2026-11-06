#!/usr/bin/env node
'use strict';


const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..', '..');
const SKIP_DIRS = new Set([
  'node_modules', '.git', '__pycache__', 'vendor', 'moonveil', 'moonveil21',
  'fixtures', 'results', '.arena', 'coverage',
]);
const JS_EXT = '.js';
const PY_EXT = '.py';

function walk(dir, files = []) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    if (entry.isDirectory()) {
      if (SKIP_DIRS.has(entry.name) || entry.name.startsWith('.')) continue;
      walk(path.join(dir, entry.name), files);
    } else if (entry.isFile()) {
      const ext = path.extname(entry.name);
      if (ext === JS_EXT || ext === PY_EXT) files.push(path.join(dir, entry.name));
    }
  }
  return files;
}

function checkJs(file) {
  const r = spawnSync(process.execPath, ['--check', file], { encoding: 'utf8' });
  return r.status === 0 ? null : (r.stderr || '').split('\n').slice(0, 4).join(' ').trim();
}

function checkPy(file) {
  const code = 'import sys; compile(open(sys.argv[1], "rb").read(), sys.argv[1], "exec")';
  const r = spawnSync(process.env.PYTHON || 'python3', ['-c', code, file], { encoding: 'utf8' });
  return r.status === 0 ? null : (r.stderr || '').split('\n').slice(0, 4).join(' ').trim();
}

function main() {
  const files = walk(ROOT);
  const js = files.filter((f) => f.endsWith(JS_EXT));
  const py = files.filter((f) => f.endsWith(PY_EXT));
  const failures = [];

  for (const file of js) {
    const err = checkJs(file);
    if (err) failures.push({ file, err });
  }
  for (const file of py) {
    const err = checkPy(file);
    if (err) failures.push({ file, err });
  }

  if (failures.length) {
    for (const { file, err } of failures) {
      process.stderr.write(`[!] ${path.relative(ROOT, file)}: ${err}\n`);
    }
    process.stderr.write(`\n[!] ${failures.length} file(s) do not load\n`);
    process.exitCode = 1;
    return;
  }
  process.stdout.write(`[+] ${js.length} JavaScript and ${py.length} Python file(s) load\n`);
}

main();
