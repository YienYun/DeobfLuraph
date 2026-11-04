'use strict';

/**
 * Compile every given Luau file with the real Luau compiler and report the
 * result. This is the `luac` gate: a result that does not compile is not a
 * result, whatever it looks like.
 *
 *     node scripts/luac.js results/*.luau
 *     node scripts/luac.js results/foo.luau --verbose
 *
 * Each file is embedded in a long-bracket string and handed to `loadstring`,
 * so the compiler runs exactly as it would in Roblox (locals/upvalue limits and
 * all) without executing a single statement of the file.
 *
 * Exit code: 0 when everything compiles, 1 when anything does not, 2 when the
 * Luau binary is missing or unusable.
 */

const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');

const ROOT = path.resolve(__dirname, '..');

function luauBin() {
  const candidates = ['luau', 'luau.exe'].map((n) => path.join(ROOT, 'bin', n));
  return candidates.find((p) => fs.existsSync(p)) || null;
}

function brackets(text) {
  // Longest run of '=' already inside the text decides the delimiter level.
  let level = 0;
  for (const m of text.matchAll(/\](\=*)\]/g)) level = Math.max(level, m[1].length + 1);
  const eq = '='.repeat(level);
  return { open: '[' + eq + '[', close: ']' + eq + ']' };
}

function checkOne(bin, file) {
  const src = fs.readFileSync(file, 'utf8');
  const { open, close } = brackets(src);
  const wrapper = [
    'local src = ' + open + '\n' + src + '\n' + close,
    'local fn, err = loadstring(src, ' + JSON.stringify(path.basename(file)) + ')',
    'if fn then',
    '  print("OK")',
    'else',
    '  print("ERR\\t" .. tostring(err))',
    'end',
  ].join('\n');
  const tmp = path.join(fs.mkdtempSync(path.join(os.tmpdir(), 'luac_')), 'check.luau');
  fs.writeFileSync(tmp, wrapper);
  const r = spawnSync(bin, [tmp], { encoding: 'utf8', timeout: 120000 });
  fs.rmSync(path.dirname(tmp), { recursive: true, force: true });
  const out = (r.stdout || '') + (r.stderr || '');
  if (out.startsWith('OK')) return { ok: true };
  const m = /^ERR\t(.*)$/m.exec(out);
  if (m) return { ok: false, error: m[1] };
  return { ok: false, error: 'luau produced no verdict: ' + out.trim().split('\n')[0] };
}

function main(argv) {
  const verbose = argv.includes('--verbose');
  const files = argv.slice(2).filter((a) => !a.startsWith('--'));
  if (!files.length) {
    console.error('usage: node scripts/luac.js <file.luau> [...] [--verbose]');
    return 2;
  }
  const bin = luauBin();
  if (!bin) {
    console.error('[!] no bin/luau; run the repository setup first');
    return 2;
  }
  let bad = 0;
  for (const file of files) {
    const rel = path.relative(ROOT, path.resolve(file)) || file;
    let res;
    try {
      res = checkOne(bin, path.resolve(file));
    } catch (ex) {
      res = { ok: false, error: String(ex && ex.message ? ex.message : ex) };
    }
    if (res.ok) {
      if (verbose) console.log('ok       %s', rel);
    } else {
      bad++;
      console.log('FAILED   %s\n           %s', rel, res.error);
    }
  }
  const total = files.length;
  console.log('\n[%s] %d file(s) compiled, %d failed', bad ? '-' : '+', total - bad, bad);
  return bad ? 1 : 0;
}

process.exitCode = main(process.argv);
