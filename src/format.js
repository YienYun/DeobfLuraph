'use strict';

// The last step of a run: print the result the way a formatter would.
//
// The lift already lays code out, but a script that came out of a payload field
// is printed as written, and a trace is one statement per line by construction.
// Both read better through StyLua -- the same tool GitHub's "Format with StyLua"
// action runs -- so the engine calls it on every result before the file lands.
//
// If the formatter is not installed (it is an optional dependency) or refuses the
// text, the run keeps its result: a formatting miss must never cost a lift.

const path = require('path');

const DEFAULTS = {
  columnWidth: 100,
  indentWidth: 4,
  // Not every sample is valid Luau as parsed: a trace carries comments and calls
  // on lines the parser accepts, so `All` is the version that never rejects one.
  syntax: 'All',
};

let mod = null;
let loadError = null;

function stylua() {
  if (mod || loadError) return mod;
  try {
    // eslint-disable-next-line global-require, import/no-unresolved
    mod = require('@johnnymorganz/stylua');
  } catch (e) {
    loadError = e.message || String(e);
  }
  return mod;
}

// The wasm build wants a Config instance, not a plain object.
function config(s) {
  const c = s.Config.new();
  c.column_width = DEFAULTS.columnWidth;
  c.indent_type = s.IndentType.Tabs;
  c.indent_width = DEFAULTS.indentWidth;
  c.line_endings = s.LineEndings.Unix;
  c.quote_style = s.QuoteStyle.AutoPreferDouble;
  c.call_parentheses = s.CallParenType.Always;
  c.collapse_simple_statement = s.CollapseSimpleStatement.Never;
  c.space_after_function_names = s.SpaceAfterFunctionNames.Never;
  c.syntax = s.LuaVersion[DEFAULTS.syntax];
  return c;
}

/**
 * Format Luau source with StyLua.
 *
 * @param {string} text
 * @param {{enabled?: boolean}} [opts]
 * @returns {{ok: boolean, text: string, changed: boolean, tool?: string, reason?: string}}
 */
function formatLuau(text, opts = {}) {
  const unchanged = { ok: false, text, changed: false };
  if (opts.enabled === false) return { ...unchanged, reason: 'disabled' };
  if (typeof text !== 'string' || text.trim() === '') return { ...unchanged, reason: 'empty' };

  const s = stylua();
  if (!s) return { ...unchanged, reason: `stylua not installed (${loadError})` };

  // One pass is not always the fixed point: with very long table/call lines the
  // hang decision can move on the second pass (`}, {}` joining). Run until the
  // text stops changing, so formatting twice is a no-op for the reader too.
  const maxPasses = opts.maxPasses ?? 4;
  let cur = text;
  let changed = false;
  let passes = 0;
  for (let i = 0; i < maxPasses; i += 1) {
    let out;
    try {
      // a Config is consumed by the call, so each pass gets its own
      out = s.formatCode(cur, config(s), null, s.OutputVerification.Full);
    } catch (e) {
      if (i === 0) return { ...unchanged, reason: `stylua refused the text: ${e.message || e}` };
      break;
    }
    if (typeof out !== 'string' || out.trim() === '') break;
    if (!out.endsWith('\n')) out += '\n';
    passes += 1;
    if (out === cur) break;
    cur = out;
    changed = true;
  }
  if (passes === 0) return { ...unchanged, reason: 'stylua returned nothing' };
  return {
    ok: true,
    text: cur,
    changed,
    passes,
    tool: 'stylua',
  };
}

function available() {
  return Boolean(stylua());
}

module.exports = { formatLuau, available, DEFAULTS, configPath: path.join(__dirname, '..', '.stylua.toml') };
