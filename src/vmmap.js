'use strict';

// The VM mapper and entry instrumentation live in the Python core. Keeping one
// implementation avoids the Node and Python pipelines drifting apart.
const path = require('path');
const { execFileSync } = require('child_process');
const { getPythonBin } = require('./pyenv');

function patchEntries(source, sourcePath) {
  const bridge = path.join(__dirname, 'devirt_bridge.py');
  try {
    const patched = execFileSync(getPythonBin(), [bridge, 'patch-entries', sourcePath], {
      // A patched file can be substantially larger than its input. Do not use
      // execFileSync's default 1 MiB limit on real Luraph scripts.
      maxBuffer: Math.max(16 * 1024 * 1024, Buffer.byteLength(source, 'latin1') * 8),
      timeout: 150000,
      windowsHide: true,
    });
    return patched.toString('latin1');
  } catch (err) {
    const detail = err.stderr ? err.stderr.toString('utf8').trim().split('\n').pop() : err.message;
    throw new Error(`could not instrument Luau source: ${detail}`);
  }
}

// Equivalent to patch_spin in core/obfuscators/luraph_v15/driver.py. This
// only instruments the recognizable VM dispatch heads, not arbitrary loops.
function patchSpin(source) {
  const injection = '__SPIN.n=__SPIN.n+1;if __SPIN.n>=__SPIN.step then __SPIN.f()end;';
  const head = String.raw`(?:[A-Za-z_][A-Za-z0-9_]*\[\d+\]=[A-Za-z_][A-Za-z0-9_]*;\s*)?(?:local )?[A-Za-z_][A-Za-z0-9_]*(?:,[A-Za-z_][A-Za-z0-9_]*)*=(?:[A-Za-z_][A-Za-z0-9_]*,)?\(?[A-Za-z_][A-Za-z0-9_]*\[[A-Za-z_][A-Za-z0-9_]*\]\)?;?(?=\s*(?:if|local)\b)`;
  for (const keyword of ['while true do ', 'repeat ']) {
    source = source.replace(new RegExp(keyword + head, 'g'), match =>
      (match.endsWith(';') ? match : match + ';') + injection);
  }
  return source;
}

module.exports = { patchEntries, patchSpin };
