'use strict';


const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const BIN_DIR = path.join(path.resolve(__dirname, '..'), 'bin');

function binPath(name) {
  const ext = process.platform === 'win32' ? '.exe' : '';
  const local = path.join(BIN_DIR, name + ext);
  return fs.existsSync(local) ? local : name;
}

function isValidLuaSyntax(source) {
  const astBin = binPath('luau-ast');
  if (!fs.existsSync(astBin)) return true;
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'luau-ast-'));
  const file = path.join(dir, 'check.luau');
  try {
    fs.writeFileSync(file, source, 'utf8');
    const r = spawnSync(astBin, [file], {
      stdio: ['ignore', 'ignore', 'pipe'],
      timeout: 15000,
      windowsHide: true,
    });
    return !r.error && r.status === 0;
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
}

module.exports = { BIN_DIR, binPath, isValidLuaSyntax };
