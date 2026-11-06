'use strict';


const path = require('path');

const DEFAULTS = {
  columnWidth: 100,
  indentWidth: 4,
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


function formatLuau(text, opts = {}) {
  const unchanged = { ok: false, text, changed: false };
  if (opts.enabled === false) return { ...unchanged, reason: 'disabled' };
  if (typeof text !== 'string' || text.trim() === '') return { ...unchanged, reason: 'empty' };

  const s = stylua();
  if (!s) return { ...unchanged, reason: `stylua not installed (${loadError})` };

  const maxPasses = opts.maxPasses ?? 4;
  let cur = text;
  let changed = false;
  let passes = 0;
  for (let i = 0; i < maxPasses; i += 1) {
    let out;
    try {
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
