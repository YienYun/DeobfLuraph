'use strict';

/**
 * Report free identifiers: names a result *reads* that nothing ever declares or
 * assigns, and that are not globals Roblox/Luau provide. In a lifted script
 * those are the places where a register could not be resolved, and at run time
 * they are nil -- so `r4._unpack(...)` is a crash waiting for its code path.
 *
 *     node scripts/freevars.js results          # every *.luau under a directory
 *     node scripts/freevars.js file.luau --verbose
 *     node scripts/freevars.js results          # every *.luau under a directory --report-only   # never fails
 *
 * Exit code 0 when every read resolves, 1 when something does not, 2 on usage.
 *
 * The AST comes from bin/luau-ast, the same parser the lift checks its own
 * output with, so a name is judged exactly as the Luau compiler would see it.
 */

const { spawnSync } = require('node:child_process');
const fs = require('node:fs');
const path = require('node:path');

const ROOT = path.resolve(__dirname, '..');

// Globals that exist when a Roblox script runs. A read of one of these is fine.
const KNOWN = new Set(`
_G _VERSION assert bit32 buffer coroutine debug error gcinfo getfenv getmetatable
ipairs loadstring math newproxy next os pairs pcall print rawequal rawget rawlen
rawset require select setfenv setmetatable string table tonumber tostring type
typeof unpack utf8 xpcall
game workspace script shared plugin tick time warn
task wait delay spawn defer cancel
Instance Enum Color3 Vector2 Vector3 Vector4 CFrame UDim UDim2 Rect Region3
Rect BrickColor NumberRange NumberSequence ColorSequence NumberSequenceKeypoint
ColorSequenceKeypoint Ray TweenInfo Font DateTime PhysicalProperties
Random Random.new
Path2DControlPoint Path2D Vector2int16 Rect CFrame new TweenInfo
typeof getgenv getrenv getreg getgc getupvalue setupvalue getinfo isfile
isfolder readfile writefile appendfile listfiles makefolder delfile delfolder
identifyexecutor getexecutorname gethui getconnections ffire getcustomasset
request http symlinkprotect setclipboard hookfunction hookmetamethod newcclosure
checkcaller setreadonly isreadonly getrawmetatable protectgui decompile
getloadedmodules getloadedmodule getscripts getscriptbytecode getcallingscript
getnamecallmethod setnamecallmethod firetouchinterest fireclickdetector
getnilinstances setfpscap queue_on_teleport
syn fluxus krnl http_request cleardrawcache get_extendedmetatable
fireproximityprompt queueonteleport getnameexecutor cloneref load
RaycastParams OverlapParams Content setthreadidentity set_thread_identity
getupvalues islclosure replicatesignal firetouchinterest getconnections
UserSettings gethwid toclipboard crypt base64_decode base64_encode WebSocket
decompile getscriptbytecode getscripthash setreadonly canloadstring
vector settings hookfunction getfunctionhash
`.split(/\s+/).filter(Boolean));

function hasAst() {
  return ['luau-ast', 'luau-ast.exe'].some((n) => fs.existsSync(path.join(ROOT, 'bin', n)));
}

function astBin() {
  const n = ['luau-ast', 'luau-ast.exe'].find((x) => fs.existsSync(path.join(ROOT, 'bin', x)));
  return path.join(ROOT, 'bin', n);
}

function collect(file) {
  const r = spawnSync(astBin(), [file], { encoding: 'utf8', maxBuffer: 256 * 1024 * 1024 });
  if (r.status !== 0) throw new Error('luau-ast failed: ' + (r.stderr || '').split('\n')[0]);
  const root = JSON.parse(r.stdout).root;
  const read = new Map();   // name -> first line number
  const declared = new Set();

  const lineOf = (loc) => Number(String(loc).split(',')[0]) + 1;

  (function walk(n) {
    if (Array.isArray(n)) { n.forEach(walk); return; }
    if (!n || typeof n !== 'object') return;
    switch (n.type) {
      case 'AstExprGlobal':
        if (!read.has(n.global)) read.set(n.global, lineOf(n.location));
        return;
      case 'AstStatLocal':
        for (const v of n.vars || []) declared.add(v.name);
        (n.values || []).forEach(walk);
        return;
      case 'AstStatLocalFunction':
        declared.add(n.name.name);
        walk(n.func);
        return;
      case 'AstStatFunction':
        walk(n.name);
        walk(n.func);
        return;
      case 'AstStatAssign':
      case 'AstStatCompoundAssign': {
        const targets = n.vars || [n.var];
        for (const t of targets) {
          if (t && t.type === 'AstExprGlobal') declared.add(t.global);
          else walk(t);
        }
        (n.values || [n.value]).forEach((v) => v && walk(v));
        return;
      }
      default:
        for (const k of Object.keys(n)) {
          if (k === 'location' || k === 'luauType') continue;
          walk(n[k]);
        }
    }
  })(root);

  // Two different things, and only one of them is a defect:
  //   * a name the lifter made up for a register (`r4`, `r34`) -- that is a
  //     register it could not resolve, and it is a hole in the result;
  //   * an unknown global (`syn`, `fluxus`) -- those belong to the executor the
  //     script targets and are reported, not failed.
  const free = [...read]
    .filter(([name]) => !declared.has(name) && !KNOWN.has(name))
    .map(([name, line]) => ({ name, line, register: /^r\d+$/.test(name) }));
  free.sort((a, b) => (b.register - a.register) || (a.line - b.line));
  return free;
}

function main(argv) {
  const verbose = argv.includes('--verbose');
  const reportOnly = argv.includes('--report-only');
  const targets = argv.slice(2).filter((a) => !a.startsWith('--'));
  if (!targets.length) {
    console.error('usage: node scripts/freevars.js <file.luau|dir> [...] [--verbose]');
    return 2;
  }
  const files = [];
  for (const t of targets) {
    if (!fs.existsSync(t)) continue;         // a glob that matched nothing
    if (fs.statSync(t).isDirectory()) {
      for (const name of fs.readdirSync(t).sort()) {
        if (name.endsWith('.luau') || name.endsWith('.lua')) files.push(path.join(t, name));
      }
    } else {
      files.push(t);
    }
  }
  if (!files.length) {
    console.log('[i] no result files to check yet (nothing under the given paths)');
    return 0;
  }
  if (!hasAst()) {
    console.error('[!] bin/luau-ast not found; build it with `python build_luau.py`');
    return 2;
  }
  let bad = 0;
  for (const f of files) {
    const abs = path.resolve(f);
    const rel = path.relative(ROOT, abs) || f;
    let free;
    try {
      free = collect(abs);
    } catch (ex) {
      bad++;
      console.log('FAILED   %s\n           %s', rel, ex.message);
      continue;
    }
    const regs = free.filter((f) => f.register);
    const globals = free.filter((f) => !f.register);
    if (regs.length) {
      bad++;
      console.log('HOLE     %s  (%d unresolved register read(s))', rel, regs.length);
      for (const r of regs.slice(0, 12)) console.log('           %s:%d  %s', rel, r.line, r.name);
      if (regs.length > 12) console.log('           ... %d more', regs.length - 12);
    } else if (verbose) {
      console.log('ok       %s', rel);
    }
    if (globals.length) {
      console.log('note     %s  %d unknown global(s): %s', rel, globals.length,
        globals.slice(0, 8).map((g) => g.name).join(', '));
    }
  }
  console.log('\n[%s] %d file(s) checked, %d with unresolved register reads',
    bad ? '-' : '+', files.length, bad);
  return (bad && !reportOnly) ? 1 : 0;
}

process.exitCode = main(process.argv);
