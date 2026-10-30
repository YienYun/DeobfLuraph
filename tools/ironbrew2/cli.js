#!/usr/bin/env node
'use strict';

const fs = require('fs');
const path = require('path');
const luamin = require('./utility/luamin');
const ironbrew = require('./obfuscators/ironbrew/deobfuscate');
const moonsecV2 = require('./obfuscators/moonsec/deobfuscate');
const { decompileLua51Bytecode } = require(path.resolve(__dirname, '../../src/luac_decompile.js'));

function deobfuscateSource(script, mode = 'auto', options = {}) {
  const origLog = console.log;
  const origWrite = process.stdout.write.bind(process.stdout);
  if (!options.verbose) {
    console.log = () => {};
    process.stdout.write = () => true;
  }
  let bytecode;
  try {
    let parsed = luamin.Parse(script);
    parsed = luamin.BeautifyAst(parsed, { RenameVariables: true, Format: true });
    if (mode === 'moonsec_v2' || (mode === 'auto' && moonsecV2.detect(script))) {
      bytecode = moonsecV2.deobfuscate(parsed);
    } else if (mode === 'ironbrew2' || mode === 'auto') {
      bytecode = ironbrew.deobfuscate(parsed);
    }
  } finally {
    console.log = origLog;
    process.stdout.write = origWrite;
  }
  if (!bytecode) {
    throw new Error('Failed to recover Lua 5.1 bytecode from payload');
  }
  const buf = Buffer.isBuffer(bytecode) ? bytecode : Buffer.from(bytecode, 'binary');
  return decompileLua51Bytecode(buf, options);
}

if (require.main === module) {
  const args = process.argv.slice(2);
  const input = args.find((a) => !a.startsWith('-'));
  const outIdx = args.indexOf('-o');
  const output = outIdx !== -1 ? args[outIdx + 1] : null;
  const modeIdx = args.indexOf('--mode');
  const mode = modeIdx !== -1 ? args[modeIdx + 1] : 'auto';
  if (!input || !fs.existsSync(input)) {
    process.stderr.write('Usage: node tools/ironbrew2/cli.js <input.lua> [-o <output.lua>] [--mode auto|ironbrew2|moonsec_v2]\n');
    process.exit(1);
  }
  try {
    const src = fs.readFileSync(input, 'latin1');
    const out = deobfuscateSource(src, mode);
    if (output) fs.writeFileSync(output, out, 'utf8');
    else process.stdout.write(out);
  } catch (err) {
    process.stderr.write((err && err.message ? err.message : String(err)) + '\n');
    process.exit(1);
  }
}

module.exports = { deobfuscateSource };
