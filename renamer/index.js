#!/usr/bin/env node
'use strict';

const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');
const garbage = require('./garbage');
const { WATERMARK_COMMENT, WATERMARK_PRINT, injectWatermark } = require('../src/watermark');

const DIRECTORY_EXTENSIONS = ['.lua', '.luau'];
const FILE_EXTENSIONS = ['.lua', '.luau', '.txt'];

function betterDecompilerBin() {
  if (process.env.BETTERDECOMPILER_BIN) return process.env.BETTERDECOMPILER_BIN;
  const ext = process.platform === 'win32' ? '.exe' : '';
  return path.join(__dirname, 'bin', 'betterdecompiler' + ext);
}

function sameExistingFile(a, b) {
  if (!a || !b || !fs.existsSync(a) || !fs.existsSync(b)) return false;
  const sa = fs.statSync(a);
  const sb = fs.statSync(b);
  return sa.dev === sb.dev && sa.ino === sb.ino;
}

function writeAtomically(dest, content) {
  const abs = path.resolve(dest);
  fs.mkdirSync(path.dirname(abs), { recursive: true });
  const tmp = path.join(path.dirname(abs), `.${path.basename(abs)}.tmp-${process.pid}-${Date.now()}`);
  fs.writeFileSync(tmp, content, 'utf8');
  fs.renameSync(tmp, abs);
}

/**
 * Invoke `renamer/bin/betterdecompiler clean --json` (scope-verified Luau renamer + commenter).
 * Supports both instant offline mode and AI LLM providers (openai, gemini, anthropic, groq,
 * deepseek, openrouter, xai, ollama, lmstudio).
 */
function runBetterDecompiler(source, opts = {}) {
  const bin = betterDecompilerBin();
  if (!fs.existsSync(bin)) {
    throw new Error(`BetterDecompiler binary not found at ${bin} (run: python3 renamer/build_renamer.py)`);
  }

  const mode = opts.mode || (opts.provider && opts.provider !== 'offline' ? 'rename' : 'offline');
  const comments = opts.comments || 'light';
  const cliArgs = ['clean', '--json', '--no-cache', '--mode', mode, '--comments', comments];
  if (!opts.header) cliArgs.push('--no-header');
  if (opts.provider) cliArgs.push('--provider', opts.provider);
  if (opts.model) cliArgs.push('--model', opts.model);
  if (opts.configPath) cliArgs.push('--config', opts.configPath);
  cliArgs.push('-');

  const r = spawnSync(bin, cliArgs, {
    input: source,
    encoding: 'utf8',
    maxBuffer: 128 * 1024 * 1024,
    timeout: opts.timeoutMs || 300000,
    windowsHide: true,
  });

  if (r.error) {
    throw new Error(`BetterDecompiler failed to launch: ${r.error.message}`);
  }
  if (r.status !== 0) {
    throw new Error(`BetterDecompiler exited with code ${r.status}: ${(r.stderr || '').trim()}`);
  }

  const line = (r.stdout || '').trim().split('\n').pop() || '';
  let parsed;
  try {
    parsed = JSON.parse(line);
  } catch (err) {
    throw new Error(`Failed to parse BetterDecompiler JSON output: ${err.message}`);
  }
  const res = parsed.result || parsed;
  return {
    source: res.source || source,
    mode: res.mode || mode,
    provider: res.provider || 'offline',
    model: res.model || '',
    renamed: res.renamed || 0,
    comments: res.comments || 0,
    warnings: res.warnings || [],
    elapsedMs: res.elapsed_ms || 0,
  };
}

/**
 * Full Layer-2 pipeline on an in-memory Luau source string:
 *   1. Deobfuscator-aware AST chaff cleanup + Darklua dead-code elimination
 *   2. BetterDecompiler scope-verified variable/function renaming + AI-style comments
 *   3. Official `./bin/luau-ast` syntax verification gate (with automatic safe fallback)
 */
function cleanAndRename(source, opts = {}) {
  const t0 = Date.now();
  const warnings = [];

  // Stage 1 & 2: Garbage & dead-code removal
  let working = source;
  let dceStats = {
    deobfPolished: false,
    darkluaApplied: false,
    deadLinesRemoved: 0,
  };
  if (!opts.noDce) {
    const g = garbage.cleanGarbage(working, {
      fromDeobf: Boolean(opts.fromDeobf),
      noDeobfPolish: Boolean(opts.noDeobfPolish),
      noDarklua: Boolean(opts.noDarklua),
    });
    working = g.source;
    dceStats = {
      deobfPolished: g.deobfPolished,
      darkluaApplied: g.darkluaApplied,
      deadLinesRemoved: g.deadLinesRemoved,
    };
    warnings.push(...g.warnings);
  }

  // If StyLua is unavailable, run Darklua readable generator before BetterDecompiler
  // so BetterDecompiler's contextual comments are preserved on formatted output.
  let formatterUsed = 'none';
  if (!opts.noFormat && !garbage.resolveStyluaBin()) {
    const preFmt = garbage.formatLuauCode(working, opts);
    working = preFmt.source;
    formatterUsed = preFmt.formatter;
  }

  // Stage 3: Scope-verified Luau renaming + contextual doc-comments
  const bd = runBetterDecompiler(working, opts);
  warnings.push(...bd.warnings);

  // Stage 4: Official StyLua formatting (preserves comments & normalizes style)
  let candidateSource = bd.source;
  if (!opts.noFormat && garbage.resolveStyluaBin()) {
    const postFmt = garbage.formatLuauCode(candidateSource, opts);
    candidateSource = postFmt.source;
    formatterUsed = postFmt.formatter;
  }

  // Stage 5: Final official Luau AST syntax verification gate
  let finalSource = candidateSource;
  let astCheck = garbage.checkLuauAst(finalSource);
  if (!astCheck.ok) {
    warnings.push(`Renamed output failed luau-ast (${astCheck.error}); falling back to pre-rename cleaned code.`);
    finalSource = working;
    astCheck = garbage.checkLuauAst(finalSource);
    if (!astCheck.ok) {
      finalSource = source;
    }
  }

  if (source.includes(WATERMARK_COMMENT) || source.includes(WATERMARK_PRINT) || opts.fromDeobf) {
    finalSource = injectWatermark(finalSource);
  }

  return {
    source: finalSource,
    stats: {
      mode: bd.mode,
      provider: bd.provider,
      model: bd.model || undefined,
      renamed: bd.renamed,
      comments: bd.comments,
      formatter: formatterUsed,
      dead_lines_removed: dceStats.deadLinesRemoved,
      darklua_applied: dceStats.darkluaApplied,
      deobf_ast_polished: dceStats.deobfPolished,
      ast_valid: Boolean(astCheck.ok),
      elapsed_ms: Date.now() - t0,
    },
    warnings,
  };
}

function collectInputFiles(inputs) {
  const out = [];
  const seen = new Set();
  for (const raw of inputs) {
    const p = path.resolve(raw);
    if (!fs.existsSync(p)) throw new Error(`input not found: ${raw}`);
    const st = fs.statSync(p);
    if (st.isDirectory()) {
      for (const entry of fs.readdirSync(p, { withFileTypes: true })) {
        if (!entry.isFile()) continue;
        const ext = path.extname(entry.name).toLowerCase();
        if (DIRECTORY_EXTENSIONS.includes(ext)) {
          const full = path.join(p, entry.name);
          if (!seen.has(full)) { seen.add(full); out.push(full); }
        }
      }
    } else if (st.isFile()) {
      const ext = path.extname(p).toLowerCase();
      if (!FILE_EXTENSIONS.includes(ext)) {
        throw new Error(`unsupported input extension: ${raw} (expected .lua, .luau, or .txt)`);
      }
      if (!seen.has(p)) { seen.add(p); out.push(p); }
    }
  }
  return out;
}

function defaultOutputPath(inputFile) {
  const dir = path.dirname(inputFile);
  const ext = path.extname(inputFile) || '.luau';
  const stem = path.basename(inputFile, ext);
  return path.join(dir, `${stem}_Renamed${ext}`);
}

function parseArgs(argv) {
  const args = {
    inputs: [],
    output: null,
    inPlace: false,
    mode: 'offline',
    comments: 'light',
    provider: null,
    model: null,
    configPath: null,
    header: false,
    noDce: false,
    noDarklua: false,
    noDeobfPolish: false,
    report: null,
    help: false,
  };

  function valueAt(index, opt) {
    if (index >= argv.length || argv[index].startsWith('-')) {
      throw new Error(`${opt} requires a value`);
    }
    return argv[index];
  }

  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '-h' || a === '--help') args.help = true;
    else if (a === '-o' || a === '--output') args.output = valueAt(++i, a);
    else if (a === '--in-place') args.inPlace = true;
    else if (a === '--mode') args.mode = valueAt(++i, a);
    else if (a === '--ai') args.mode = 'rename';
    else if (a === '--comments') args.comments = valueAt(++i, a);
    else if (a === '-p' || a === '--provider') {
      args.provider = valueAt(++i, a);
      if (args.provider !== 'offline' && args.mode === 'offline') args.mode = 'rename';
    }
    else if (a === '-m' || a === '--model') args.model = valueAt(++i, a);
    else if (a === '--config') args.configPath = valueAt(++i, a);
    else if (a === '--header') args.header = true;
    else if (a === '--no-dce') args.noDce = true;
    else if (a === '--no-darklua') args.noDarklua = true;
    else if (a === '--no-deobf-polish') args.noDeobfPolish = true;
    else if (a === '--report') args.report = valueAt(++i, a);
    else if (!a.startsWith('-')) args.inputs.push(a);
    else throw new Error(`unknown option: ${a}`);
  }

  if (!['offline', 'rename', 'rewrite'].includes(args.mode)) {
    throw new Error(`invalid --mode ${args.mode} (expected offline, rename, or rewrite)`);
  }
  if (!['none', 'light', 'detailed'].includes(args.comments)) {
    throw new Error(`invalid --comments ${args.comments} (expected none, light, or detailed)`);
  }
  return args;
}

function processFile(inputFile, args) {
  const absIn = path.resolve(inputFile);
  let outPath;
  if (args.inPlace) {
    outPath = absIn;
  } else if (args.singleFile && args.output) {
    outPath = path.resolve(args.output);
    if (sameExistingFile(absIn, outPath)) {
      throw new Error('output path resolves to the input file (use --in-place to overwrite intentionally)');
    }
  } else {
    outPath = defaultOutputPath(absIn);
  }

  const src = fs.readFileSync(absIn, 'utf8');
  const res = cleanAndRename(src, {
    mode: args.mode,
    comments: args.comments,
    provider: args.provider,
    model: args.model,
    configPath: args.configPath,
    header: args.header,
    noDce: args.noDce,
    noDarklua: args.noDarklua,
    noDeobfPolish: args.noDeobfPolish,
  });

  writeAtomically(outPath, res.source);
  const reportObj = {
    input: absIn,
    output: outPath,
    rename_stats: res.stats,
    warnings: res.warnings,
  };
  if (args.report && args.singleFile) {
    writeAtomically(path.resolve(args.report), JSON.stringify(reportObj, null, 2) + '\n');
  }
  process.stderr.write(
    `[+] renamed: ${outPath} (${res.stats.provider}, ${res.stats.renamed} names, ` +
    `${res.stats.comments} comments, -${res.stats.dead_lines_removed} dead lines, ${res.stats.elapsed_ms}ms)\n`
  );
  return reportObj;
}

function main() {
  const usage = [
    'Usage: node renamer/index.js <input.lua | folder> [-o <output.lua>] [options]',
    '',
    'Options:',
    '  -o, --output <path>       Output file path (default: <input>_Renamed.lua)',
    '  --in-place                Overwrite input file(s) atomically in place',
    '  --comments <level>        Contextual comments: none | light (default) | detailed',
    '  --mode <mode>             offline (default, instant) | rename (AI JSON) | rewrite',
    '  -p, --provider <name>     AI provider: openai, gemini, anthropic, groq, deepseek,',
    '                            openrouter, xai, ollama, lmstudio, or offline',
    '  -m, --model <name>        Override model name for the chosen AI provider',
    '  --no-dce                  Skip Darklua + AST dead-code/garbage cleanup',
    '  --header                  Prepend summary header comment at top of output',
    '  --report <report.json>    Write structured JSON summary report',
  ].join('\n');

  const args = parseArgs(process.argv.slice(2));
  if (args.help) {
    console.log(usage);
    return;
  }
  if (args.inputs.length === 0) {
    console.error(usage);
    process.exit(2);
  }

  const files = collectInputFiles(args.inputs);
  if (files.length === 0) {
    console.error('[!] no .lua / .luau files found');
    process.exit(1);
  }
  args.singleFile = files.length === 1;
  if (files.length > 1 && args.output) {
    process.stderr.write('[!] --output is ignored when multiple files are given\n');
  }

  let ok = 0;
  let failed = 0;
  for (const f of files) {
    try {
      processFile(f, args);
      ok++;
    } catch (err) {
      failed++;
      process.stderr.write(`[!] failed on ${path.basename(f)}: ${err.message || err}\n`);
    }
  }
  process.stderr.write(`[*] renamer done: ${ok} succeeded, ${failed} failed out of ${files.length}\n`);
  if (failed > 0) process.exitCode = 1;
}

if (require.main === module) {
  try {
    main();
  } catch (err) {
    process.stderr.write(`[!] Fatal error: ${err.message || err}\n`);
    process.exit(1);
  }
}

module.exports = {
  betterDecompilerBin,
  runBetterDecompiler,
  cleanAndRename,
  collectInputFiles,
  parseArgs,
  processFile,
  garbage,
};
