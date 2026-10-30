'use strict';

const path = require('path');
const { Deobfuscator } = require('./deobf/deobfuscator.js');
const { Serializer } = require('./deobf/bytecode/serializer.js');
const { Disassembler } = require('./deobf/bytecode/disassembler.js');
const { decompileLua51Bytecode } = require(path.resolve(__dirname, '../../../../src/luac_decompile.js'));

function deobfuscateToBytecode(code) {
  const result = new Deobfuscator().deobfuscate(code);
  return new Serializer().serialize(result);
}

function deobfuscateToSource(code, options = {}) {
  const bytes = deobfuscateToBytecode(code);
  return decompileLua51Bytecode(bytes, options);
}

function deobfuscateToDisassembly(code) {
  const result = new Deobfuscator().deobfuscate(code);
  return new Disassembler(result).disassemble();
}

module.exports = { deobfuscateToBytecode, deobfuscateToSource, deobfuscateToDisassembly };
