#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const detectModule = require('./src/detect');
const driver = require('./src/driver');
const multiDriver = require('./src/multi_driver');

const DIRECTORY_EXTENSIONS = ['.lua', '.luau'];
const FILE_EXTENSIONS = ['.lua', '.luau', '.txt'];

function parseArgs(argv) {
  const args = {
    inputs: [],
    output: null,
    detect: false,
    plugin: null,
    noDevirt: false,
    noHooks: false,
    noFold: false,
    debug: false,
    strings: false,
    keepHarness: false,
    keepPreamble: false,
    timeout: 90,
    budget: 30,
    maxRuns: 12,
    devirtRounds: 200,
    executor: 'Wave',
    inputText: null,
    report: null,
    rename: false,
    comments: 'light',
    aiProvider: null,
    aiModel: null,
    noDce: false,
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
    else if (a === '--no-hooks') { args.noHooks = true; }
    else if (a === '--no-fold') { args.noFold = true; }
    else if (a === '--debug') { args.debug = true; }
    else if (a === '--strings') { args.strings = true; }
    else if (a === '--keep-harness') { args.keepHarness = true; }
    else if (a === '--keep-preamble') { args.keepPreamble = true; }
    else if (a === '-o' || a === '--output') { args.output = valueAt(++i, a); }
    else if (a === '--report') { args.report = valueAt(++i, a); }
    else if (a === '--timeout') { args.timeout = Number(valueAt(++i, a)); }
    else if (a === '--prelude-file') { args.preludeFile = valueAt(++i, a); }
    else if (a === '--budget') { args.budget = Number(valueAt(++i, a)); }
    else if (a === '--max-runs') { args.maxRuns = Number(valueAt(++i, a)); }
    else if (a === '--devirt-rounds') { args.devirtRounds = Number(valueAt(++i, a)); }
    else if (a === '--executor') { args.executor = valueAt(++i, a); }
    else if (a === '--input-text') { args.inputText = valueAt(++i, a); }
    else if (a === '--rename') { args.rename = true; }
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
      // Extra harness CFG as inline JSON or '@file.json'.
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

  for (const [name, value] of [['--timeout', args.timeout], ['--budget', args.budget],
    ['--max-runs', args.maxRuns], ['--devirt-rounds', args.devirtRounds]]) {
    if (!Number.isSafeInteger(value) || value <= 0) throw new Error(`${name} must be a positive integer`);
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
      const entries = fs.readdirSync(abs, { withFileTypes: true });
      for (const entry of entries) {
        if (entry.isFile() && DIRECTORY_EXTENSIONS.includes(path.extname(entry.name).toLowerCase())) {
          const filePath = path.join(abs, entry.name);
          if (!seen.has(filePath)) {
            seen.add(filePath);
            files.push(filePath);
          }
        }
      }
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
    plugin = detectModule.byName(args.plugin); // force a plugin (e.g. v14.x headers score 0.3)
    confidence = 1.0;
  } else {
    ({ plugin, confidence } = detectModule.detect(source));
  }

  if (args.detect) {
    console.log(`${path.basename(absInput)}\t${plugin.name}\t${confidence.toFixed(2)}\t${plugin.label}`);
    return;
  }

  process.stderr.write(`[*] obfuscator: ${plugin.label} (detected, ${confidence.toFixed(2)})\n`);

  const parentDir = path.dirname(absInput);
  const outdir = path.basename(parentDir).toLowerCase() === 'input'
    ? path.join(path.dirname(parentDir), 'output')
    : path.join(parentDir, 'output');
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

    let result;
    if (plugin.name === 'luarmor_client') {
      // Auth-gated loaders are not supported by this checkout. Do not point
      // users at a probe tool that is not actually included in the project.
      throw new Error('Luarmor whitelist client detected — this loader is not supported by this project.');
    } else if (plugin.name === 'luraph_v15') {
      result = await driver.run(job);
    } else if (plugin.name === 'generic') {
      result = await driver.runGeneric(job);
    } else {
      result = await multiDriver.runPlugin(plugin.name, job);
    }

    if (final && result && fs.existsSync(result)) {
      let content = fs.readFileSync(result, 'utf8');
      content = content.replace(/^(\s*--(?:[ \t]*(?:Deobfuscated by|Detected obfuscation|Local names are inferred|source:|NOTE: reconstructed|during the trace|Input SHA-256:|MoonVeil [\d.]+ profile:|Constants decoded;|Names\/comments lost|This is not a claim)[^\n]*\n?|\s*\n))+/, '');
      let renameStats = undefined;
      if (args.rename && job.resultType === 'devirtualized') {
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
      writeAtomically(final, content);
      const report = {
        input: path.resolve(absInput),
        output: path.resolve(final),
        obfuscator: plugin.name,
        confidence,
        result_type: job.resultType,
        trace_status: job.traceStatus,
        lift_stats: job.liftStats,
        ...(renameStats ? { rename_stats: renameStats } : {}),
        warnings: job.warnings,
      };
      if (args.report) writeAtomically(path.resolve(args.report), JSON.stringify(report, null, 2) + '\n');
      process.stderr.write(`[+] result (${job.resultType}): ${final}\n`);
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

  const usage = 'Usage: node deob.js <input.lua | folder> [more_files_or_folders...] [-o <output.lua>] [--rename] [--comments none|light|detailed] [--plugin <name>] [--no-devirt] [--debug] [--detect] [--report <report.json>]';
  if (args.help) {
    console.log(usage);
    console.log('Use --detect to classify without executing, or --no-devirt for a behaviour trace.');
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
      process.stderr.write(`[!] failed on ${path.basename(file)}: ${err.message || err}\n`);
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

module.exports = { parseArgs, collectInputFiles, processFile, sameExistingFile, writeAtomically };
