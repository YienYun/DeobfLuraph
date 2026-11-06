#!/usr/bin/env node
'use strict';

const crypto = require('crypto');
const fs = require('fs');
const path = require('path');
const detectModule = require('./node/detect');
const driver = require('./node/driver');
const engines = require('./node/engines');
const harness = require('./node/harness');
const { injectWatermark } = require('./node/watermark');
const format = require('./node/format');
const { isValidLuaSyntax } = require('./node/luau_check');

const DIRECTORY_EXTENSIONS = ['.lua', '.luau'];
const FILE_EXTENSIONS = ['.lua', '.luau', '.txt'];

function parseArgs(argv) {
  const args = {
    inputs: [],
    output: null,
    detect: false,
    plugin: null,
    noDevirt: false,
    execRec: false,
    noHooks: false,
    noFold: false,
    debug: false,
    strings: false,
    keepHarness: false,
    keepPreamble: false,
    timeout: 90,
    budget: 30,
    loopFuel: 65536,
    spinFuel: 64,
    maxRuns: 12,
    devirtRounds: 200,
    executor: 'Wave',
    inputText: null,
    report: null,
    httpCache: null,
    studio: false,
    studioPort: 34880,
    studioWait: 600,
    stepBudget: 0,
    timePin: 0,
    stats: false,
    rename: false,
    comments: 'light',
    aiProvider: null,
    aiModel: null,
    noDce: false,
    noFormat: false,
    help: false,
  };

  function valueAt(index, option) {
    if (index >= argv.length || (option !== '--input-text' && argv[index].startsWith('-'))) {
      throw new Error(`${option} needs a value`);
    }
    return argv[index];
  }

  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--help' || a === '-h') { args.help = true; }
    else if (a === '--detect') { args.detect = true; }
    else if (a === '--plugin') { args.plugin = valueAt(++i, a); }
    else if (a === '--no-devirt') { args.noDevirt = true; }
    else if (a === '--exec-rec') { args.execRec = true; }
    else if (a === '--no-hooks') { args.noHooks = true; }
    else if (a === '--no-fold') { args.noFold = true; }
    else if (a === '--debug') { args.debug = true; }
    else if (a === '--strings') { args.strings = true; }
    else if (a === '--keep-harness') { args.keepHarness = true; }
    else if (a === '--keep-preamble') { args.keepPreamble = true; }
    else if (a === '-o' || a === '--output') { args.output = valueAt(++i, a); }
    else if (a === '--report') { args.report = valueAt(++i, a); }
    else if (a === '--http-cache') { args.httpCache = valueAt(++i, a); }
    else if (a === '--step-budget') { args.stepBudget = Number(valueAt(++i, a)); }
    else if (a === '--time-pin') { args.timePin = Number(valueAt(++i, a)); }
    else if (a === '--studio') { args.studio = true; }
    else if (a === '--studio-port') { args.studioPort = Number(valueAt(++i, a)); }
    else if (a === '--studio-wait') { args.studioWait = Number(valueAt(++i, a)); }
    else if (a === '--stats') { args.stats = true; }
    else if (a === '--timeout') { args.timeout = Number(valueAt(++i, a)); }
    else if (a === '--prelude-file') { args.preludeFile = valueAt(++i, a); }
    else if (a === '--budget') { args.budget = Number(valueAt(++i, a)); }
    else if (a === '--loop-fuel') { args.loopFuel = Number(valueAt(++i, a)); }
    else if (a === '--spin-fuel') { args.spinFuel = Number(valueAt(++i, a)); }
    else if (a === '--max-runs') { args.maxRuns = Number(valueAt(++i, a)); }
    else if (a === '--devirt-rounds') { args.devirtRounds = Number(valueAt(++i, a)); }
    else if (a === '--executor') { args.executor = valueAt(++i, a); }
    else if (a === '--input-text') { args.inputText = valueAt(++i, a); }
    else if (a === '--rename') { args.rename = true; }
    else if (a === '--no-format') { args.noFormat = true; }
    else if (a === '--comments') {
      args.comments = valueAt(++i, a);
      if (!['none', 'light', 'detailed'].includes(args.comments)) {
        throw new Error('--comments must be none, light, or detailed');
      }
    }
    else if (a === '--ai-provider') { args.aiProvider = valueAt(++i, a); args.rename = true; }
    else if (a === '--ai-model') { args.aiModel = valueAt(++i, a); }
    else if (a === '--no-dce') { args.noDce = true; }
    else if (a === '--cfg-json') {
      let spec = valueAt(++i, a);
      if (spec.startsWith('@')) spec = fs.readFileSync(spec.slice(1), 'utf8');
      args.cfgJson = JSON.parse(spec);
      if (!args.cfgJson || Array.isArray(args.cfgJson) || typeof args.cfgJson !== 'object') {
        throw new Error('--cfg-json must be a JSON object');
      }
    }
    else if (!a.startsWith('-')) { args.inputs.push(a); }
    else { throw new Error(`unknown option: ${a}`); }
  }

  for (const [name, value] of [['--studio-port', args.studioPort], ['--studio-wait', args.studioWait],
    ['--timeout', args.timeout], ['--budget', args.budget],
    ['--loop-fuel', args.loopFuel], ['--spin-fuel', args.spinFuel],
    ['--max-runs', args.maxRuns], ['--devirt-rounds', args.devirtRounds]]) {
    if (!Number.isSafeInteger(value) || value <= 0) throw new Error(`${name} must be a positive integer`);
  }
  // 0 means "off" for the two pins, so they are validated apart from the rest
  for (const [name, value] of [['--step-budget', args.stepBudget], ['--time-pin', args.timePin]]) {
    if (!Number.isSafeInteger(value) || value < 0) throw new Error(`${name} must be zero (off) or a positive integer`);
  }
  return args;
}

class Job {
  constructor(inputPath, source, args, tracePath, debug, obfuscator = '') {
    this.input = inputPath;
    this.source = source;
    this.sourcePath = inputPath;
    this.args = args;
    this.tracePath = tracePath;
    this.debug = debug;
    this.obfuscator = obfuscator;
    this.resultType = null;
    this.traceStatus = null;
    this.liftStats = null;
    this.warnings = [];
  }

  creditHeader() {
    return '';
  }

  get base() {
    return this.tracePath.replace(/\.(deobf\.luau|luau)$/, '');
  }

  path(suffix) {
    return this.base + suffix;
  }

  wrote(p) {
    if (this.debug) process.stderr.write(`[+] wrote ${p}\n`);
  }

  write(p, text, encoding = 'utf8') {
    fs.writeFileSync(p, text, { encoding });
    this.wrote(p);
    return p;
  }

  get outdir() {
    return path.dirname(path.resolve(this.tracePath));
  }
}

function walkInputDir(dirPath, seen, files) {
  const entries = fs.readdirSync(dirPath, { withFileTypes: true });
  for (const entry of entries) {
    if (entry.name.startsWith('.')) continue;
    const full = path.join(dirPath, entry.name);
    if (entry.isDirectory()) {
      const lower = entry.name.toLowerCase();
      if (lower === 'output' || lower === 'node_modules') continue;
      walkInputDir(full, seen, files);
    } else if (entry.isFile() && DIRECTORY_EXTENSIONS.includes(path.extname(entry.name).toLowerCase())) {
      if (!seen.has(full)) {
        seen.add(full);
        files.push(full);
      }
    }
  }
}

function collectInputFiles(rawPaths) {
  const files = [];
  const seen = new Set();

  for (const raw of rawPaths) {
    const abs = path.resolve(raw);
    if (!fs.existsSync(abs)) {
      process.stderr.write(`[!] path not found, skipping: ${raw}\n`);
      continue;
    }
    const stat = fs.statSync(abs);
    if (stat.isDirectory()) {
      walkInputDir(abs, seen, files);
    } else if (stat.isFile()) {
      const ext = path.extname(abs).toLowerCase();
      if (!FILE_EXTENSIONS.includes(ext)) {
        process.stderr.write(`[!] unsupported extension for ${raw} (expected ${FILE_EXTENSIONS.join(', ')})\n`);
        continue;
      }
      if (!seen.has(abs)) {
        seen.add(abs);
        files.push(abs);
      }
    }
  }

  return files;
}

// The numbered fallback names the engine hands out when a register's role is
// not recoverable (engine/names.py has the same family list). Counted rather
// than hidden: it is the readable measure of "how much of this is still
// machine-named", which no other counter reports.
const MECHANICAL_NAME = /\b(?:value|val|data|number|num|text|list|item|obj|result|res|tmp|temp|var|condition|callback|handler|flag|fn|func)[0-9]+\b/g;
const UNEXECUTED_FOOTER = /^-- devirt: (\d+) function\(s\) contain (\d+) pc\(s\)/m;

function statsDigest(content, job, outputPath) {
  const stats = job.liftStats || {};
  const lines = content.split('\n').length - (content.endsWith('\n') ? 1 : 0);
  const functions = (content.match(/\bfunction\b/g) || []).length;
  const names = Object.create(null);
  let uses = 0;
  for (const m of content.matchAll(MECHANICAL_NAME)) { names[m[0]] = true; uses++; }
  const unexec = content.match(UNEXECUTED_FOOTER);
  const rows = [];
  const row = (label, value) => rows.push(`    ${label.padEnd(12)} ${value}`);

  row('result', `${job.resultType}${job.traceStatus ? ` (trace: ${job.traceStatus})` : ''}`);
  row('source', `${lines} lines, ${(Buffer.byteLength(content, 'utf8') / 1024).toFixed(1)} KB, ${functions} function(s)`);
  if (stats.payload_source) row('payload', `${stats.payload_source} line(s) printed from source, not lifted`);
  if (stats.functions || stats.walked) {
    row('lift', `${stats.functions || 0} function(s), ${stats.walked || 0} walked, `
      + `${stats.fallbacks || 0} fallback(s), ${stats.errors || 0} error(s)`);
  }
  if (stats.exec_runs || stats.exec_covered) {
    const window = stats.exec_window ? ` of ${stats.exec_window}` : '';
    row('coverage', `runs ${stats.exec_runs || 0}, ${stats.exec_covered || 0} array(s) covered, `
      + `${stats.exec_no_arrays || 0} with no arrays, pcs ${stats.exec_pcs || 0}${window}`);
  }
  row('unexecuted', unexec
    ? `${unexec[1]} function(s) / ${unexec[2]} pc(s) — the walk's value there, not the program's`
    : 'none flagged by the lift');
  const named = Object.keys(names).length;
  row('naming', `${named} numbered identifier(s), ${uses} use(s) — ${named ? 'run --rename to shrink that' : 'none left'}`);
  if (stats.residual_unknown) row('residual', `${stats.residual_unknown} unknown register read(s) kept`);
  for (const warning of job.warnings || []) row('warning', String(warning).split('\n')[0]);
  return `[i] stats: ${path.basename(outputPath)}\n${rows.join('\n')}\n`;
}

function resolveDefaultOutdir(absInput) {
  const parentDir = path.dirname(absInput);
  const parts = parentDir.split(path.sep);
  let inputIdx = -1;
  for (let i = parts.length - 1; i >= 0; i--) {
    if (parts[i].toLowerCase() === 'input') {
      inputIdx = i;
      break;
    }
  }
  if (inputIdx >= 0) {
    const baseDir = parts.slice(0, inputIdx).join(path.sep) || path.sep;
    const subParts = parts.slice(inputIdx + 1);
    return path.join(baseDir, 'output', ...subParts);
  }
  return path.join(parentDir, 'output');
}

function sameExistingFile(a, b) {
  if (path.resolve(a) === path.resolve(b)) return true;
  try {
    const left = fs.statSync(a);
    const right = fs.statSync(b);
    return left.dev === right.dev && left.ino === right.ino;
  } catch {
    return false;
  }
}

function writeAtomically(destination, content) {
  const dir = path.dirname(path.resolve(destination));
  fs.mkdirSync(dir, { recursive: true });
  const temp = fs.mkdtempSync(path.join(dir, '.deobf-write-'));
  try {
    const staged = path.join(temp, 'result');
    fs.writeFileSync(staged, content, 'utf8');
    fs.renameSync(staged, destination);
  } finally {
    fs.rmSync(temp, { recursive: true, force: true });
  }
}

async function processFile(absInput, args) {
  const source = fs.readFileSync(absInput, 'latin1');
  let plugin, confidence;
  if (args.plugin) {
    plugin = detectModule.byName(args.plugin);
    confidence = 1.0;
  } else {
    ({ plugin, confidence } = detectModule.detect(source));
  }

  if (args.detect) {
    console.log(`${path.basename(absInput)}\t${plugin.name}\t${confidence.toFixed(2)}\t${plugin.label}`);
    return;
  }

  process.stderr.write(`[*] obfuscator: ${plugin.label} (detected, ${confidence.toFixed(2)})\n`);

  const notes = [];
  if (plugin.name === 'generic') {
    const note = 'the input does not match any obfuscator this build supports; '
      + 'only a behaviour trace is possible, not a lifted script';
    process.stderr.write(`[!] ${note}\n`);
    notes.push(note);
  }

  const outdir = resolveDefaultOutdir(absInput);
  const defaultOutName = path.basename(absInput).replace(/\.txt$/i, '.luau');
  const final = args.output && args.singleFile
    ? path.resolve(args.output)
    : path.join(outdir, defaultOutName);
  if (sameExistingFile(absInput, final)) {
    throw new Error('output must not overwrite the input file');
  }
  if (args.report && (sameExistingFile(absInput, args.report) || sameExistingFile(final, args.report))) {
    throw new Error('report must be different from both input and output');
  }

  const tracename = path.basename(absInput).replace(/(\.luau?|\.txt)?$/i, '.deobf.luau');
  const os = require('os');
  const workdir = args.debug ? null : fs.mkdtempSync(path.join(os.tmpdir(), 'deobf_node_'));
  if (args.debug) fs.mkdirSync(outdir, { recursive: true });
  const tracePath = args.debug ? path.join(outdir, tracename) : path.join(workdir, tracename);

  try {
    const unpacked = detectModule.unwrapPackedEnvelope(source);
    const fixed = detectModule.restoreHeaderNewline(unpacked);
    let jobSource = fixed;
    let sourcePath = absInput;

    if (unpacked !== source) {
      process.stderr.write('[*] unwrapped packed Base64+Zstd envelope\n');
    }
    if (fixed !== unpacked) {
      process.stderr.write('[*] header comment ran into the code: split it\n');
    }
    if (fixed !== source) {
      sourcePath = path.join(workdir || outdir, path.basename(absInput) + '.src.lua');
      fs.writeFileSync(sourcePath, fixed, 'latin1');
    }

    const job = new Job(absInput, jobSource, args, tracePath, args.debug, plugin.label);
    job.sourcePath = sourcePath;
    job.warnings.push(...notes);

    let result;
    if (plugin.name === 'luarmor_client') {
      const luarmor = require('./node/luarmor');
      const meta = luarmor.analyze(job.sourcePath);
      job.luarmor = meta;
      luarmor.announce(meta);
      const reportPath = luarmor.writeReport(final, meta);
      process.stderr.write(`[*] luarmor report: ${reportPath}\n`);
      job.warnings.push(`Luarmor v4 ${meta.kind}: ${meta.label}`);
      if (meta.luraph_payload) {
        result = await driver.run(job);
        const stats = job.liftStats || {};
        const states = luarmor.blockedStates(stats);
        if (states.length) {
          job.warnings.push(`Luarmor blocked the offline run (${states.join(', ')}): `
            + 'the session payload was not decrypted.');
          job.resultType = 'luarmor-blocked';
          if (result && fs.existsSync(result)) luarmor.prependHeader(result, meta, stats);
        } else if (result && fs.existsSync(result)) {
          luarmor.prependHeader(result, meta, stats);
        }
        if (!stats.functions) {
          const note = [luarmor.headerLines(meta, stats), '',
            '-- Nothing was lifted, so this file carries the result of the analysis, not code:',
            '-- a behaviour trace of a bootstrapper that cannot finish offline is not a script.',
            '',
            '-- This Source Was Generated by discord.gg/c3xVMnUUBv',
            'print("Deobf By Zed")',
          ].join('\n') + '\n';
          fs.mkdirSync(path.dirname(result), { recursive: true });
          fs.writeFileSync(result, note, 'utf8');
          job.resultType = 'luarmor-blocked';
        }
        meta.result_type = job.resultType || 'devirtualized';
        if (stats.run_status) meta.run_status = stats.run_status;
        if (stats.runtime_stubs) {
            meta.runtime = { stubs: stats.runtime_stubs, unlifted_blocks: stats.unlifted || 0 };
        }
        meta.blocked = states.length ? { states, payload_decrypted: false } : null;
        luarmor.writeReport(final, meta);
      } else {
        const stubPath = job.path('.luarmor-stub.lua');
        fs.mkdirSync(path.dirname(stubPath), { recursive: true });
        fs.writeFileSync(stubPath, luarmor.annotateStub(fixed, meta), 'latin1');
        job.resultType = meta.kind === 'hub_pointer' ? 'luarmor-hub-pointer' : 'luarmor-client-stub';
        result = stubPath;
      }
    } else if (plugin.name === 'luraph_v15') {
      result = await driver.run(job);
      if (job.resultType === 'payload-source' && !args.noDevirt) {
        const chained = await require('./node/luarmor').chain(job, result);
        if (chained) result = chained;
      }
    } else if (plugin.name === 'generic') {
      result = await driver.runGeneric(job);
    } else {
      result = await engines.runPlugin(plugin.name, job);
    }

    if (job.luarmor && final) {
      try {
        const lp = require('./node/luarmor').writeReport(final, job.luarmor);
        process.stderr.write(`[*] luarmor report: ${lp}\n`);
      } catch (e) {
        job.warnings.push(`Luarmor report could not be written: ${e.message}`);
      }
    }

    if (final && result && fs.existsSync(result)) {
      let content = fs.readFileSync(result, 'utf8');
      content = content.replace(/^(\s*--(?:[ \t]*(?:Deobfuscated by|Detected obfuscation|Local names are inferred|source:|NOTE: reconstructed|during the trace|Input SHA-256:Constants decoded;|Names\/comments lost|This is not a claim)[^\n]*\n?|\s*\n))+/, '');
      let renameStats = undefined;
      if (args.rename && (job.resultType === 'devirtualized' || job.resultType === 'payload-source')) {
        process.stderr.write(`[*] running Layer-2 renamer & dead-code cleaner (comments=${args.comments})...\n`);
        const renamer = require('./renamer');
        const r2 = renamer.cleanAndRename(content, {
          fromDeobf: true,
          comments: args.comments,
          provider: args.aiProvider,
          model: args.aiModel,
          noDce: args.noDce,
        });
        content = r2.source;
        renameStats = r2.stats;
        if (r2.warnings && r2.warnings.length) job.warnings.push(...r2.warnings);
        process.stderr.write(
          `[*]   renamed ${r2.stats.renamed} identifiers, added ${r2.stats.comments} comments, ` +
          `removed ${r2.stats.dead_lines_removed} dead lines (${(r2.stats.elapsed_ms / 1000).toFixed(1)}s)\n`
        );
      }
      const stringsPath = job.path('.strings.txt');
      const stringsFinal = final + '.strings.txt';
      if (args.strings && fs.existsSync(stringsPath)) {
        if (sameExistingFile(absInput, stringsFinal) || (args.report && sameExistingFile(args.report, stringsFinal))) {
          throw new Error('strings output must not overwrite the input or report');
        }
        writeAtomically(stringsFinal, fs.readFileSync(stringsPath, 'utf8'));
      }
      const before = Buffer.byteLength(content, 'utf8');
      const fmt = format.formatLuau(content, { enabled: !args.noFormat });
      if (fmt.ok && fmt.changed && !isValidLuaSyntax(fmt.text)) {
        job.warnings.push('Formatted output did not parse; kept the unformatted result.');
        job.format = { tool: 'stylua', changed: false, skipped: 'output did not parse after formatting' };
      } else if (fmt.ok) {
        content = fmt.text;
        job.format = { tool: fmt.tool, changed: fmt.changed };
        if (fmt.changed) {
          process.stderr.write(
            `[*] formatted with ${fmt.tool}: ${before} B -> ${Buffer.byteLength(content, 'utf8')} B\n`
          );
        }
      } else {
        job.format = { tool: 'stylua', changed: false, skipped: fmt.reason };
        if (!args.noFormat) job.warnings.push(`Formatter skipped: ${fmt.reason}`);
      }
      content = injectWatermark(content);
      writeAtomically(final, content);
      if (job.resultType === 'trace') {
        job.warnings.push('Result is a behaviour trace, not reconstructed source (see the file header).');
        if (job.diagnosis) process.stderr.write(`[!] why: ${job.diagnosis}\n`);
      }
      if (args.httpCache && /script error/i.test(String(job.traceStatus || ''))) {
        job.warnings.push('The run stopped inside code it only reached through --http-cache: '
          + 'the lift saw less of the script than the same file without the cache.');
      }
      const report = {
        schema_version: 1,
        input: path.resolve(absInput),
        output: path.resolve(final),
        output_sha256: crypto.createHash('sha256').update(content, 'utf8').digest('hex'),
        output_bytes: Buffer.byteLength(content, 'utf8'),
        obfuscator: plugin.name,
        engine: plugin.label,
        confidence,
        result_type: job.resultType,
        trace_status: job.traceStatus,
        ...(job.format ? { format: job.format } : {}),
        ...(job.diagnosis ? { diagnosis: job.diagnosis } : {}),
        lift_stats: job.liftStats,
        ...(job.chain ? { chain: job.chain } : {}),
        ...(job.luarmor ? { luarmor: job.luarmor } : {}),
        ...(renameStats ? { rename_stats: renameStats } : {}),
        warnings: job.warnings,
      };
      if (args.report) writeAtomically(path.resolve(args.report), JSON.stringify(report, null, 2) + '\n');
      process.stderr.write(`[+] result (${job.resultType}): ${final}\n`);
      if (args.stats) process.stderr.write(statsDigest(content, job, final));
      return report;
    }
    process.stderr.write(`[!] no result for ${path.basename(absInput)}\n`);
    return null;
  } finally {
    if (workdir && fs.existsSync(workdir)) {
      try { fs.rmSync(workdir, { recursive: true, force: true }); } catch {}
    }
  }
}

async function main() {
  const args = parseArgs(process.argv.slice(2));

  const usage = 'Usage: node deob.js <input.lua | folder> [more_files_or_folders...] [-o <output.lua>] [--rename] [--comments none|light|detailed] [--plugin <name>] [--no-devirt] [--no-format] [--debug] [--detect] [--exec-rec] [--report <report.json>] [--http-cache <dir>] [--step-budget <n>] [--studio [--studio-port <n>] [--studio-wait <sec>]] [--stats]';
  if (args.help) {
    console.log(usage);
    console.log('Use --detect to classify without executing, or --no-devirt for a behaviour trace.');
    console.log('Use --exec-rec (or DEVIRT_EXECREC=1) to record which program counters the sample executed.');
    console.log('Use --http-cache <dir> to answer game:HttpGet from index.json instead of nil.');
    console.log('Use --step-budget <n> to cut every traced run at the same statement count (a run that stops on wall-clock time traces different code on a slower machine).');
    console.log('Use --time-pin <unix-seconds> to freeze os.time/tick/os.clock/math.random for the trace (a hub that branches on a cooldown or a nonce traces differently every second otherwise).');
    console.log('Use --studio to trace inside a real Roblox place (paste the generated studio_loader into the Studio command bar).');
    console.log('Use --stats to print what the output still cannot promise (coverage, unexecuted pcs, naming).');
    return;
  }
  if (args.inputs.length === 0) {
    console.error(usage);
    process.exit(2);
  }

  const files = collectInputFiles(args.inputs);
  if (files.length === 0) {
    console.error('[!] no valid .lua / .luau input files found');
    process.exit(1);
  }

  args.singleFile = files.length === 1;
  if (args.report && (args.detect || !args.singleFile)) {
    throw new Error('--report requires exactly one input file and cannot be used with --detect');
  }

  if (args.detect) {
    for (const file of files) {
      const source = fs.readFileSync(file, 'latin1');
      let plugin, confidence;
      if (args.plugin) { plugin = detectModule.byName(args.plugin); confidence = 1.0; }
      else ({ plugin, confidence } = detectModule.detect(source));
      console.log(`${path.basename(file)}\t${plugin.name}\t${confidence.toFixed(2)}\t${plugin.label}`);
    }
    return;
  }

  if (files.length > 1 && args.output) {
    process.stderr.write('[!] --output is ignored for multiple inputs (each file goes into its own output/ folder)\n');
  }

  let succeeded = 0;
  let failed = 0;

  for (const file of files) {
    process.stderr.write(`\n[*] processing ${file}\n`);
    try {
      const res = await processFile(file, args);
      if (res) succeeded++;
      else failed++;
    } catch (err) {
      const detail = harness.clipDiagnostic(err && err.message ? err.message : String(err));
      process.stderr.write(`[!] failed on ${path.basename(file)}: ${detail}\n`);
      failed++;
    }
  }

  process.stderr.write(`\n[*] done: ${succeeded} succeeded, ${failed} failed out of ${files.length}\n`);
  if (failed > 0) process.exitCode = 1;
}

if (require.main === module) {
  main().catch(err => {
    process.stderr.write('[!] Fatal error: ' + (err.message || err) + '\n');
    process.exitCode = 1;
  });
}

module.exports = {
  parseArgs, collectInputFiles, processFile, sameExistingFile, writeAtomically, resolveDefaultOutdir,
  statsDigest,
};
