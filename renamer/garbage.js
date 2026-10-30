'use strict';

const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const { getPythonBin } = require('../src/pyenv');

const ROOT = path.resolve(__dirname, '..');
const CORE_DIR = path.join(ROOT, 'core');
const DARKLUA_PATH = path.join(__dirname, 'vendor', 'darklua', 'darklua_wasm.js');

// Safe, behavior-preserving Luau AST simplification & dead-code rules from seaofvoices/darklua.
// Note: `remove_nil_declaration` is intentionally omitted because converting `local x = nil`
// can interact subtly with multi-assignments; all rules below preserve exact Luau runtime semantics.
const DEFAULT_DARKLUA_RULES = [
  'compute_expression',
  'remove_unused_if_branch',
  'remove_unused_while',
  'remove_empty_do',
  'filter_after_early_return',
  'remove_unused_variable',
  'convert_index_to_field',
];

let _darklua = null;
function loadDarklua() {
  if (!_darklua) {
    _darklua = require(DARKLUA_PATH);
  }
  return _darklua;
}

function luauAstBin() {
  if (process.env.LUAU_AST_BIN) return process.env.LUAU_AST_BIN;
  const ext = process.platform === 'win32' ? '.exe' : '';
  return path.join(ROOT, 'bin', 'luau-ast' + ext);
}

function countNonEmptyLines(text) {
  let count = 0;
  const lines = text.split('\n');
  for (let i = 0; i < lines.length; i++) {
    if (lines[i].trim() !== '') count++;
  }
  return count;
}

function checkLuauAst(source) {
  const bin = luauAstBin();
  if (!fs.existsSync(bin)) return { ok: true, skipped: true };
  const tmp = path.join(os.tmpdir(), `renamer-ast-${process.pid}-${Date.now()}-${Math.random().toString(36).slice(2)}.luau`);
  try {
    fs.writeFileSync(tmp, source, 'utf8');
    const r = spawnSync(bin, [tmp], {
      stdio: ['ignore', 'ignore', 'pipe'],
      encoding: 'utf8',
      timeout: 60000,
      windowsHide: true,
    });
    if (r.error || r.status !== 0) {
      return { ok: false, error: (r.stderr || r.error?.message || 'luau-ast parse error').trim() };
    }
    return { ok: true };
  } finally {
    try { fs.unlinkSync(tmp); } catch {}
  }
}

/**
 * Run Luraph/deobfuscator chaff cleanup via `core/ast_polish.py` (powered by `./bin/luau-ast`).
 * Removes dead MBA `bit32`/`table.pack` locals, unused 7-10 digit state-key arguments,
 * constant-false opaque `if` branches, and top-level `;(function()...end)()` wrappers.
 */
function runDeobfAstPolish(source) {
  const bin = luauAstBin();
  if (!fs.existsSync(bin)) return { source, applied: false };
  const tmpIn = path.join(os.tmpdir(), `renamer-pol-in-${process.pid}-${Date.now()}.luau`);
  const tmpOut = path.join(os.tmpdir(), `renamer-pol-out-${process.pid}-${Date.now()}.luau`);
  try {
    fs.writeFileSync(tmpIn, source, 'utf8');
    const pyCode = [
      'import sys, pathlib, ast_polish',
      'src = pathlib.Path(sys.argv[1]).read_text(encoding="utf-8")',
      'out = ast_polish.polish_ast(src)',
      'pathlib.Path(sys.argv[2]).write_text(out, encoding="utf-8")',
    ].join('\n');
    const r = spawnSync(getPythonBin(), ['-c', pyCode, tmpIn, tmpOut], {
      cwd: ROOT,
      env: { ...process.env, PYTHONPATH: CORE_DIR, LUAU_AST_BIN: bin },
      stdio: ['ignore', 'ignore', 'pipe'],
      encoding: 'utf8',
      timeout: 120000,
      windowsHide: true,
    });
    if (!r.error && r.status === 0 && fs.existsSync(tmpOut)) {
      const polished = fs.readFileSync(tmpOut, 'utf8');
      if (polished && checkLuauAst(polished).ok) {
        return { source: polished, applied: polished !== source };
      }
    }
    return { source, applied: false };
  } finally {
    try { fs.unlinkSync(tmpIn); } catch {}
    try { fs.unlinkSync(tmpOut); } catch {}
  }
}

/**
 * Run seaofvoices/darklua (WASM) AST dead-code elimination & expression folding.
 * Uses `retain_lines` so large data tables never bloat, then lets BetterDecompiler's
 * lexer-safe `CompactBlankLines` collapse any blank gaps left by deleted dead code.
 */
function runDarkluaClean(source, rules = DEFAULT_DARKLUA_RULES) {
  const darklua = loadDarklua();
  const out = darklua.process_code(source, {
    generator: 'retain_lines',
    rules,
  });
  const check = checkLuauAst(out);
  if (!check.ok) {
    return { source, applied: false, warning: `darklua output rejected by luau-ast: ${check.error}` };
  }
  return { source: out, applied: out !== source };
}

/**
 * Full Layer-2 garbage-removal pass:
 *   1. Deobf-aware AST chaff removal (`ast_polish.py`, skipped if already run in Layer 1)
 *   2. Darklua official Rust Luau AST dead-code & constant simplifier
 */
function cleanGarbage(source, opts = {}) {
  const beforeNonEmpty = countNonEmptyLines(source);
  const warnings = [];
  let current = source;
  let deobfPolished = false;
  let darkluaApplied = false;

  if (!opts.fromDeobf && !opts.noDeobfPolish) {
    const p = runDeobfAstPolish(current);
    current = p.source;
    deobfPolished = p.applied;
  }

  if (!opts.noDarklua) {
    try {
      const d = runDarkluaClean(current, opts.darkluaRules || DEFAULT_DARKLUA_RULES);
      current = d.source;
      darkluaApplied = d.applied;
      if (d.warning) warnings.push(d.warning);
    } catch (err) {
      warnings.push(`darklua skipped (${(err && err.message ? err.message : String(err)).slice(0, 180)})`);
    }
  }

  const afterNonEmpty = countNonEmptyLines(current);
  return {
    source: current,
    deobfPolished,
    darkluaApplied,
    nonEmptyBefore: beforeNonEmpty,
    nonEmptyAfter: afterNonEmpty,
    deadLinesRemoved: Math.max(0, beforeNonEmpty - afterNonEmpty),
    warnings,
  };
}

module.exports = {
  DEFAULT_DARKLUA_RULES,
  checkLuauAst,
  countNonEmptyLines,
  runDeobfAstPolish,
  runDarkluaClean,
  cleanGarbage,
};
