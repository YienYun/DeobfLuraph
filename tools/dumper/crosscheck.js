#!/usr/bin/env node
'use strict';

/**
 * Cross-check a deobfuscated script against independent evidence.
 *
 * Two questions, both of them about not making things up:
 *
 *   1. Does the output parse? A file that only looks like Lua is not a result.
 *   2. Is every string literal in the output accounted for? Each one has to come
 *      from a constant dump we did not write ourselves -- the dumper's protos
 *      (`--dump`), the engine's own string dump (`--strings`), or the literal
 *      text of the obfuscated input. A literal nothing else can see is either a
 *      lifter invention or an unverified decryption, and this tool says which
 *      instead of assuming it is fine.
 *
 *   node tools/dumper/crosscheck.js samples/output/Luraph/SampleV1.lua \
 *        --input samples/input/Luraph/SampleV1.lua --dump /tmp/dump1
 *
 * Exit code 0 when everything is accounted for, 1 when something is not.
 */

const fs = require('fs');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..', '..');
const AST_BIN = path.join(ROOT, 'bin', process.platform === 'win32' ? 'luau-ast.exe' : 'luau-ast');

function parseArgs(argv) {
  const args = { files: [], input: null, dump: null, strings: null };
  for (let i = 0; i < argv.length; i++) {
    const a = argv[i];
    if (a === '--input') args.input = argv[++i];
    else if (a === '--dump') args.dump = argv[++i];
    else if (a === '--strings') args.strings = argv[++i];
    else if (a === '--help' || a === '-h') args.help = true;
    else args.files.push(a);
  }
  return args;
}

/** Every string literal in a Luau file, comments excluded. */
function stringLiterals(src) {
  const out = new Set();
  const n = src.length;
  let i = 0;
  while (i < n) {
    const c = src[i];
    if (c === '-' && src[i + 1] === '-') {
      const open = src.slice(i + 2).match(/^\[(=*)\[/);
      if (open) {
        const close = ']' + open[1] + ']';
        const end = src.indexOf(close, i + 2);
        i = end < 0 ? n : end + close.length;
      } else {
        const end = src.indexOf('\n', i);
        i = end < 0 ? n : end + 1;
      }
      continue;
    }
    if (c === '"' || c === "'") {
      let j = i + 1;
      let value = '';
      while (j < n && src[j] !== c) {
        if (src[j] === '\\') {
          const esc = src[j + 1];
          if (esc === 'n') value += '\n';
          else if (esc === 't') value += '\t';
          else if (esc === 'r') value += '\r';
          else if (esc === 'z') {
            j += 2;
            while (j < n && /\s/.test(src[j])) j++;
            continue;
          } else if (esc === 'x') {
            value += String.fromCharCode(parseInt(src.substr(j + 2, 2), 16));
            j += 4;
            continue;
          } else if (esc >= '0' && esc <= '9') {
            const digits = src.substr(j + 1, 3).match(/^\d{1,3}/)[0];
            value += String.fromCharCode(parseInt(digits, 10));
            j += 1 + digits.length;
            continue;
          } else value += esc;
          j += 2;
          continue;
        }
        value += src[j];
        j++;
      }
      out.add(value);
      i = j + 1;
      continue;
    }
    if (c === '[') {
      const open = src.slice(i).match(/^\[(=*)\[/);
      if (open) {
        const close = ']' + open[1] + ']';
        const start = i + open[0].length;
        const end = src.indexOf(close, start);
        if (end >= 0) {
          let body = src.slice(start, end);
          if (body.startsWith('\n')) body = body.slice(1);
          out.add(body);
          i = end + close.length;
          continue;
        }
      }
    }
    i++;
  }
  return out;
}

function dumperStrings(dir) {
  const file = path.join(dir, 'protos.json');
  if (!fs.existsSync(file)) return null;
  const data = JSON.parse(fs.readFileSync(file, 'utf8'));
  const strings = new Set(data.strings || []);
  let instructions = 0;
  const protos = data.prototypes || [];
  for (const proto of protos) {
    instructions += proto.num_instructions || 0;
    for (const s of proto.strings || []) strings.add(s);
  }
  return { strings, instructions, protos: protos.length };
}

function fileStrings(file) {
  const text = fs.readFileSync(file, 'utf8');
  return new Set(text.split('\n').filter((line) => line.length > 0));
}

function parses(file) {
  const r = spawnSync(AST_BIN, [file], { encoding: 'utf8', maxBuffer: 64 * 1024 * 1024 });
  if (r.error) return { ok: false, why: String(r.error.message || r.error) };
  if (r.status !== 0) return { ok: false, why: (r.stderr || r.stdout || '').trim().split('\n').slice(0, 4).join(' ') };
  return { ok: true };
}

function main() {
  const args = parseArgs(process.argv.slice(2));
  if (args.help || args.files.length !== 1) {
    console.log('usage: node tools/dumper/crosscheck.js <deobfuscated.lua> [--input <obfuscated.lua>] [--dump <dir>] [--strings <file>]');
    return args.help ? 0 : 2;
  }
  const outputFile = args.files[0];
  const output = fs.readFileSync(outputFile, 'utf8');
  let status = 0;

  const syntax = parses(outputFile);
  console.log(`${syntax.ok ? 'ok  ' : 'FAIL'}  parses as Luau${syntax.ok ? '' : ': ' + syntax.why}`);
  if (!syntax.ok) status = 1;

  const known = new Set();
  const sources = [];
  // Only a constant dump can confirm a *decrypted* string; the obfuscated input
  // only ever proves that a literal was copied verbatim.
  let canConfirm = false;
  if (args.input) {
    const inputStrings = stringLiterals(fs.readFileSync(args.input, 'utf8'));
    for (const s of inputStrings) known.add(s);
    sources.push(`input ${args.input} (${inputStrings.size})`);
  }
  if (args.strings) {
    const engineStrings = fileStrings(args.strings);
    for (const s of engineStrings) known.add(s);
    sources.push(`engine dump ${args.strings} (${engineStrings.size})`);
    canConfirm = true;
  }
  let dumper = null;
  if (args.dump) {
    dumper = dumperStrings(args.dump);
    if (!dumper) {
      console.log(`warn  no protos.json in ${args.dump}`);
    } else if (dumper.instructions === 0) {
      console.log(`warn  dumper captured no instructions in ${args.dump}; its constants prove nothing`);
    } else {
      for (const s of dumper.strings) known.add(s);
      sources.push(`dumper ${args.dump} (${dumper.protos} proto(s), ${dumper.strings.size} string(s))`);
      if (dumper.strings.size > 0) canConfirm = true;
    }
  }

  const literals = stringLiterals(output);
  const unverified = [];
  for (const s of literals) {
    if (known.has(s)) continue;
    unverified.push(s);
  }

  console.log(`info  ${literals.size} string literal(s) in the output`);
  for (const line of sources) console.log(`info  evidence: ${line}`);

  if (sources.length === 0) {
    console.log('warn  no evidence given, so nothing was actually cross-checked');
    console.log('      pass --input/--dump/--strings to turn this into a real check');
    return status;
  }

  if (unverified.length === 0) {
    console.log('ok    every literal is accounted for');
  } else if (!canConfirm) {
    console.log(`note  ${unverified.length} literal(s) are decrypted strings; no constant dump was`);
    console.log('      available, so they are unconfirmed -- neither proven nor invented');
  } else {
    console.log(`FAIL  ${unverified.length} literal(s) no other source can see:`);
    for (const s of unverified.slice(0, 30)) console.log('        ' + JSON.stringify(s.slice(0, 80)));
    if (unverified.length > 30) console.log(`        ... ${unverified.length - 30} more`);
    status = 1;
  }

  console.log(status === 0 ? 'OK' : 'MISMATCH');
  return status;
}

process.exit(main());
