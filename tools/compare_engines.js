#!/usr/bin/env node
'use strict';

/**
 * Head-to-head between the LuaObfuscator engines in this repo.
 *
 * For every sample it runs each engine, then answers three questions that do
 * not care about style: does the output parse as Luau, does it run, and does it
 * still print the behaviour the original prints. Nothing here trusts either
 * engine's own success message.
 *
 *   node tools/compare_engines.js                     # samples/input/LuaObfuscator
 *   node tools/compare_engines.js <dir-or-file>...
 *   node tools/compare_engines.js --engine leakd      # only one engine
 */

const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
const LUAU = path.join(ROOT, 'bin', process.platform === 'win32' ? 'luau.exe' : 'luau');
const LEAKD = path.join(ROOT, 'core', 'obfuscators', 'luaobfuscator_leakd', 'index.js');

function run(cmd, args, opts = {}) {
  return spawnSync(cmd, args, {
    cwd: opts.cwd || ROOT,
    encoding: 'utf8',
    timeout: opts.timeout || 300000,
    maxBuffer: 64 * 1024 * 1024,
  });
}

function collect(targets) {
  const files = [];
  const walk = (p) => {
    const st = fs.statSync(p);
    if (st.isDirectory()) {
      for (const name of fs.readdirSync(p).sort()) walk(path.join(p, name));
      return;
    }
    if (/\.lua$/i.test(p) && !/_Renamed/.test(p)) files.push(p);
  };
  for (const t of targets) walk(path.resolve(t));
  return files;
}

const ENGINES = {
  ours: {
    label: 'this repo',
    run(file, out) {
      const r = run(process.execPath, [path.join(ROOT, 'deob.js'), file, '-o', out]);
      const mode = /result \(([a-z-]+)\)/.exec(r.stderr || '');
      return { ok: fs.existsSync(out), mode: mode ? mode[1] : 'error', detail: (r.stderr || '').split('\n').find((l) => /^\[!\]/.test(l)) || '' };
    },
  },
  leakd: {
    label: 'LeakD',
    run(file, out) {
      const r = run(process.execPath, [LEAKD, file, '--out', out]);
      const text = `${r.stdout || ''}${r.stderr || ''}`;
      const fail = /\[det\] fail ([^\n\u001b]*)/.exec(text);
      const err = /\[err\] ([^\n\u001b]*)/.exec(text);
      return {
        ok: fs.existsSync(out),
        mode: fail || err ? 'refused' : (fs.existsSync(out) ? 'output' : 'error'),
        detail: fail ? fail[1].trim() : err ? err[1].trim() : '',
      };
    },
  },
};

function parses(file) {
  const r = run(LUAU, ['-a', path.basename(file)], { cwd: path.dirname(file) });
  // luau has no -a switch; use the AST parser that ships with the repo
  const ast = run(path.join(ROOT, 'bin', process.platform === 'win32' ? 'luau-ast.exe' : 'luau-ast'),
    [path.basename(file)], { cwd: path.dirname(file) });
  return ast.status === 0 && !/error/i.test(ast.stderr || '');
}

function behaviour(file) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'cmp-'));
  const out = path.join(dir, 'trace.lua');
  const r = run(process.execPath, [path.join(ROOT, 'deob.js'), file, '--no-devirt', '-o', out]);
  const text = fs.existsSync(out) ? fs.readFileSync(out, 'utf8') : '';
  const status = /^-- run status: (.*)$/m.exec(r.stderr || '') || /^-- run status: (.*)$/m.exec(text);
  const prints = text.split('\n')
    .map((l) => l.trim())
    .filter((l) => /^(?:print|warn)\(/.test(l))
    .filter((l) => !/Deobf By Zed/.test(l));
  fs.rmSync(dir, { recursive: true, force: true });
  return { status: status ? status[1].trim() : 'no status', prints };
}

function main() {
  const argv = process.argv.slice(2);
  const only = argv.indexOf('--engine');
  const engineFilter = only >= 0 ? argv[only + 1] : null;
  const targets = argv.filter((a, i) => a !== '--engine' && i !== only + 1);
  const files = collect(targets.length ? targets : [path.join(ROOT, 'samples', 'input', 'LuaObfuscator')]);
  if (!files.length) {
    process.stderr.write('no .lua samples found\n');
    process.exit(2);
  }

  const engines = Object.entries(ENGINES).filter(([name]) => !engineFilter || name === engineFilter);
  const rows = [];
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'cmp-out-'));

  for (const file of files) {
    const name = path.basename(file);
    const want = behaviour(file);
    for (const [key, engine] of engines) {
      const out = path.join(dir, `${name}.${key}.lua`);
      if (fs.existsSync(out)) fs.rmSync(out);
      const result = engine.run(file, out);
      let parsed = false;
      let got = { status: 'not run', prints: [] };
      if (result.ok && fs.existsSync(out) && fs.statSync(out).size > 0) {
        parsed = parses(out);
        if (parsed) got = behaviour(out);
      }
      let sameOutput = '-';
      if (parsed) {
        if (!want.prints.length) sameOutput = 'n/a';
        else if (got.prints.length === 0) sameOutput = 'nothing';
        else sameOutput = JSON.stringify(got.prints) === JSON.stringify(want.prints) ? 'identical' : 'differs';
      }
      rows.push({
        sample: name,
        engine: engine.label,
        mode: result.mode,
        parses: parsed,
        runs: parsed && got.status === 'finished',
        sameOutput,
        prints: `${got.prints.length}/${want.prints.length}`,
        detail: result.detail,
      });
    }
    process.stderr.write(`[.] ${name}\n`);
  }

  const pad = (s, n) => String(s).padEnd(n);
  process.stdout.write(`${pad('sample', 22)}${pad('engine', 11)}${pad('mode', 12)}${pad('parses', 8)}${pad('runs', 6)}${pad('prints', 8)}${pad('behaviour', 12)}note\n`);
  process.stdout.write(`${'-'.repeat(100)}\n`);
  for (const r of rows) {
    process.stdout.write(
      `${pad(r.sample, 22)}${pad(r.engine, 11)}${pad(r.mode, 12)}${pad(r.parses ? 'yes' : 'no', 8)}`
      + `${pad(r.runs ? 'yes' : 'no', 6)}${pad(r.prints, 8)}${pad(r.sameOutput, 12)}${r.detail}\n`);
  }
  fs.rmSync(dir, { recursive: true, force: true });
}

try {
  main();
} catch (err) {
  process.stderr.write(`[!] ${err.message}\n`);
  process.exit(2);
}
