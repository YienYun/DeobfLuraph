'use strict';

const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
const BIN_DIR = path.join(ROOT, 'bin');
const DECOM_LUA = path.join(ROOT, 'tools', 'moonsec-lua', 'decom.lua');

function binPath(name) {
  const ext = process.platform === 'win32' ? '.exe' : '';
  const p = path.join(BIN_DIR, name + ext);
  return fs.existsSync(p) ? p : name;
}

/**
 * Convert 32-bit Lua 5.1 bytecode (sizeof(size_t) === 4) to 64-bit
 * (sizeof(size_t) === 8) so native 64-bit luadec can parse chunks emitted by
 * MoonSec / PSU / IronBrew2 serializers.
 */
function luac32To64(buf) {
  if (!Buffer.isBuffer(buf)) buf = Buffer.from(buf);
  if (buf.length < 12 || buf.readUInt32BE(0) !== 0x1b4c7561 || buf[4] !== 0x51) {
    return buf;
  }
  if (buf[8] === 8 || buf[8] !== 4) return buf;

  const le = buf[6] === 1;
  const intSize = buf[7];
  const numSize = buf[10];
  if (intSize !== 4) return buf;

  const out = [];
  const head = Buffer.from(buf.subarray(0, 12));
  head[8] = 8;
  out.push(head);
  let pos = 12;

  const peekInt = () => (le ? buf.readInt32LE(pos) : buf.readInt32BE(pos));
  const copy = (n) => {
    out.push(buf.subarray(pos, pos + n));
    pos += n;
  };
  const convString = () => {
    const len = le ? buf.readUInt32LE(pos) : buf.readUInt32BE(pos);
    pos += 4;
    const sz = Buffer.alloc(8);
    if (le) sz.writeBigUInt64LE(BigInt(len));
    else sz.writeBigUInt64BE(BigInt(len));
    out.push(sz);
    if (len > 0) copy(len);
  };
  const convFunc = () => {
    convString(); // source name
    copy(intSize * 2 + 4); // linedefined, lastlinedefined, nups, numparams, is_vararg, maxstacksize
    const sizecode = peekInt();
    copy(intSize + sizecode * 4);
    const sizek = peekInt();
    copy(intSize);
    for (let i = 0; i < sizek; i++) {
      const t = buf[pos];
      copy(1);
      if (t === 1) copy(1);
      else if (t === 3) copy(numSize);
      else if (t === 4) convString();
    }
    const sizep = peekInt();
    copy(intSize);
    for (let i = 0; i < sizep; i++) convFunc();
    const sizelineinfo = peekInt();
    copy(intSize + sizelineinfo * intSize);
    const sizelocvars = peekInt();
    copy(intSize);
    for (let i = 0; i < sizelocvars; i++) {
      convString();
      copy(intSize * 2);
    }
    const sizeupvalues = peekInt();
    copy(intSize);
    for (let i = 0; i < sizeupvalues; i++) convString();
  };

  convFunc();
  return Buffer.concat(out);
}

function stripDecompilerBanner(source) {
  return source
    .replace(/^-- Decompiled using luadec[^\n]*\n(?:-- Command line:[^\n]*\n)?\s*/i, '')
    .replace(/^-- filename:[^\n]*\n-- version:[^\n]*\n-- line:[^\n]*\n/i, '')
    .trim() + '\n';
}

function isValidLuaSyntax(source) {
  const astBin = binPath('luau-ast');
  if (!fs.existsSync(astBin)) return true;
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'luac-ast-'));
  const file = path.join(dir, 'check.lua');
  try {
    fs.writeFileSync(file, source, 'utf8');
    const r = spawnSync(astBin, [file], {
      stdio: ['ignore', 'ignore', 'pipe'],
      timeout: 15000,
      windowsHide: true,
    });
    return !r.error && r.status === 0;
  } finally {
    fs.rmSync(dir, { recursive: true, force: true });
  }
}

/**
 * Decompile raw Lua 5.1 `.luac` bytecode buffer into clean Lua source.
 * Tries:
 *  1) Optional `java -jar unluac.jar` if both Java and unluac.jar are present
 *  2) Native `bin/luadec` (with automatic 32->64 bit size_t conversion when needed)
 *  3) `bin/lua5.1 tools/moonsec-lua/decom.lua` (pure Lua 5.1 decompiler fallback)
 */
function decompileLua51Bytecode(bytecode, options = {}) {
  const rawBuf = Buffer.isBuffer(bytecode) ? bytecode : Buffer.from(bytecode, 'binary');
  const timeout = options.timeout || 120000;
  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'luac-dec-'));
  const rawFile = path.join(tmpDir, 'chunk32.luac');
  const normFile = path.join(tmpDir, 'chunk64.luac');
  const decomOut = path.join(tmpDir, 'decom.lua');

  try {
    fs.writeFileSync(rawFile, rawBuf);

    // 1. Optional unluac.jar if user has Java + jar installed
    const jarCandidates = [options.jarPath, process.env.UNLUAC_JAR].filter(Boolean);
    const jar = jarCandidates.find((p) => fs.existsSync(p));
    if (jar) {
      const jr = spawnSync(options.javaPath || process.env.JAVA_EXE || 'java', ['-jar', jar, '--nodebug', rawFile], {
        encoding: 'utf8',
        timeout,
        maxBuffer: 64 * 1024 * 1024,
        windowsHide: true,
      });
      if (!jr.error && jr.status === 0 && jr.stdout && jr.stdout.trim()) {
        return jr.stdout.trim() + '\n';
      }
    }

    // 2. Native luadec
    let luadecCandidate = null;
    const luadecBin = binPath('luadec');
    const targetChunk = process.arch === 'x64' && process.platform !== 'win32'
      ? (fs.writeFileSync(normFile, luac32To64(rawBuf)), normFile)
      : rawFile;
    const lr = spawnSync(luadecBin, [targetChunk], {
      encoding: 'utf8',
      timeout,
      maxBuffer: 64 * 1024 * 1024,
      windowsHide: true,
    });
    if (!lr.error && lr.status === 0 && lr.stdout && lr.stdout.trim()) {
      const cleaned = stripDecompilerBanner(lr.stdout);
      const hasDecompErr = /-- DECOMPILER ERROR/.test(cleaned);
      if (!hasDecompErr && isValidLuaSyntax(cleaned)) {
        return cleaned;
      }
      luadecCandidate = cleaned;
    }

    // 3. Pure Lua 5.1 decom.lua on bin/lua5.1
    if (fs.existsSync(DECOM_LUA)) {
      const lua51Bin = binPath('lua5.1');
      const dr = spawnSync(lua51Bin, [DECOM_LUA, rawFile, decomOut], {
        encoding: 'utf8',
        timeout,
        maxBuffer: 64 * 1024 * 1024,
        windowsHide: true,
      });
      if (!dr.error && dr.status === 0 && fs.existsSync(decomOut)) {
        const text = stripDecompilerBanner(fs.readFileSync(decomOut, 'utf8'));
        if (text.trim()) {
          if (isValidLuaSyntax(text) || !luadecCandidate) {
            return text;
          }
        }
      }
    }

    if (luadecCandidate) return luadecCandidate;
    throw new Error((lr.stderr || 'Lua 5.1 bytecode decompilation failed').trim().slice(0, 300));
  } finally {
    fs.rmSync(tmpDir, { recursive: true, force: true });
  }
}

module.exports = { luac32To64, decompileLua51Bytecode, isValidLuaSyntax };
