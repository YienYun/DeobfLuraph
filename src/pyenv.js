'use strict';

const { execFileSync } = require('child_process');

let _cachedPython = null;

function getPythonBin() {
  if (_cachedPython) return _cachedPython;
  if (process.env.PYTHON_BIN) {
    _cachedPython = process.env.PYTHON_BIN;
    return _cachedPython;
  }
  const candidates = process.platform === 'win32'
    ? ['python', 'py', 'python3']
    : ['python3', 'python'];

  for (const cmd of candidates) {
    try {
      execFileSync(cmd, ['--version'], { stdio: 'ignore' });
      _cachedPython = cmd;
      return cmd;
    } catch {}
  }
  throw new Error('Python not found. Please install Python 3.10+ or set the PYTHON_BIN environment variable.');
}

/**
 * Environment for every Python child we spawn.
 *
 * The lifters walk many `set`/`dict` collections keyed by strings, so Python's
 * per-process hash randomisation used to shuffle local declaration order and
 * make two runs of the same sample produce different text. Pinning the seed
 * keeps the whole pipeline reproducible; the only thing that still moves is
 * the watermark comment, which is intentionally random.
 */
function pythonEnv(extra) {
  return Object.assign({}, process.env, { PYTHONHASHSEED: '0' }, extra || {});
}

module.exports = { getPythonBin, pythonEnv };
