'use strict';

const zlib = require('zlib');

const LURAPH_HEADER = /This file was protected using Luraph Obfuscator v(\d+)(?:\.(\d+))?/;
const LURAPH_VM_SHAPE = /\[\d+\]=(bit32|buffer|string|table|math)\.\w+/;
const VM_CHUNK_START = /[\s\]]*return setmetatable\(\{/;

// Luraph v14 header-stripped shapes (disjoint from v15's `return setmetatable({`)
const LURAPH_V14_TABLE_SHAPE = /^return\(\{[A-Za-z_]/;
const LURAPH_V14_WRAPPER_HEAD = /^return\(function\(\)local [A-Za-z_,]+=/;

// IronBrew v1 header & VM wrapper shape
const IRONBREW1_HEADER = /--\s*this file was generated using ironbrew1\b/i;
const IRONBREW1_SHAPE = /^return\s*\(\s*function\s*\((?:[a-z]{1,2},){20,}\.\.\.\)\s*local [a-z]{1,3}(?:=\{-?\d+,|(?:,[a-z]{1,3}){10,})/;

function detectLuraphV15(source) {
  const head500 = source.slice(0, 500);
  const m = LURAPH_HEADER.exec(head500);
  if (m) {
    return m[1] === '15' ? 1.0 : 0.3;
  }
  const head = source.slice(0, 65536);
  const vm = VM_CHUNK_START.exec(head);
  if (vm) {
    const at = vm.index + vm[0].length - 'return setmetatable({'.length;
    const chunkHead = source.slice(at, at + 200000);
    if (LURAPH_VM_SHAPE.test(chunkHead) || chunkHead.includes('LPH')) {
      return 0.8;
    }
  }
  return 0.0;
}

function detectLuraphV14(source) {
  const m = LURAPH_HEADER.exec(source.slice(0, 500));
  if (m) {
    const major = m[1];
    const minor = m[2] || '0';
    if (major === '14' && (minor === '7' || minor === '8' || minor === '9')) {
      return 1.0;
    }
    return 0.3;
  }
  const head = source.trimStart().slice(0, 2000);
  if (LURAPH_V14_TABLE_SHAPE.test(head)) return 0.8;
  if (LURAPH_V14_WRAPPER_HEAD.test(head) && source.slice(-60000).includes('Luraph decompression error')) {
    return 0.8;
  }
  return 0.0;
}

const HEADER_LINE_RE = /^\s*--[ \t]*This file was protected using Luraph Obfuscator v[\d.]+[ \t]*\[https?:\/\/lura\.ph\/?\]/;

function restoreHeaderNewline(source) {
  const m = HEADER_LINE_RE.exec(source);
  if (m) {
    const end = m.index + m[0].length;
    const next = source[end];
    if (next !== undefined && next !== '\n' && next !== '\r') {
      return source.slice(0, end) + '\n' + source.slice(end).replace(/^[ \t]+/, '');
    }
  }
  return source;
}

// Luarmor whitelist client (auth-gated loader; payload not devirtualizable).
const LUARMOR_SIGS = [
  /luarmor\.net|Luarmor/i,
  /\bluraph_runtime1\s*\(/,
  /GetTutorialState\(\s*"nil\s+nil\s+/,
  /getfenv\(\)\s*\[\s*tbl\w+\s*\]\s*=/,
  /writefile\(\s*"luarmor-error-log\.txt"/,
  /[a-z]{1,3}\d-roblox-auth\.luarmor\.net/,
  /ce_like_loadstring_fn/,
  /Kick\(\s*"\[Luarmor\]/,
];

function detectLuarmor(source) {
  const head = source.slice(0, 2500);
  if (/^\s*superflow_bytecode\s*=\s*\{/.test(head)) return 0.95;
  if (/\b_bsdata0\s*=\s*\{/.test(head) && (/\bsuperflow_bytecode(?:_ext\d+)?\s*=/.test(head) || /luarmor\.net\/v4_init_/i.test(source))) {
    return 0.95;
  }
  let hits = 0;
  for (const rx of LUARMOR_SIGS) {
    if (rx.test(source)) hits += 1;
  }
  if (hits >= 4) return 1.0;
  if (hits >= 3) return 0.9;
  if (hits >= 2) return 0.7;
  return 0.0;
}

function detectMoonsec(source) {
  const head = source.slice(0, 1500);
  if (head.includes('MoonSec V3') || head.includes('Protected_by_MoonSecV')) return 0.95;
  if (head.includes('..:::MoonSec::..') || head.includes('MoonSec V2')) return 0.95;
  // Header-stripped MoonSec V3 cipher bootstrap (`gsub('.+', (function(a) ... end)` + `return(function(`)
  if (/gsub\(['"]\.\+['"]\s*,\s*\(function\([a-zA-Z_]\w*\)/.test(source.slice(0, 4000))) return 0.85;
  return 0.0;
}

function detectMoonveil(source) {
  const head = source.slice(0, 1500);
  if (/generated using MoonVeil/i.test(head) || /\bMoonVeil\b.*(?:Obfuscator|v?\d+\.\d+)/i.test(head)) return 0.95;
  if (/--\s*\[\[[^\]]*MoonVeil/i.test(head)) return 0.95;
  const trimmed = source.trimStart().slice(0, 2000);
  if (/^return\(\{(?:\{\},)?function\([A-Za-z_]\w*,[A-Za-z_]\w*\)return function\(/.test(trimmed) && /\b0b[01]{3,}/.test(trimmed)) {
    return 0.88;
  }
  return 0.0;
}

function detectPrometheus(source) {
  const head500 = source.slice(0, 500);
  if (/rometheus/i.test(head500)) return 0.92;
  const trimmed = source.trimStart().slice(0, 3000);
  if (trimmed.startsWith('return(function(...)') && (trimmed.match(/\\\d{3}/g) || []).length >= 3) {
    return 0.85;
  }
  return 0.0;
}

function detectPsu(source) {
  const head = source.slice(0, 1500);
  if (head.includes('PSU Obfuscator')) return 0.95;
  if (source.slice(0, 8000).includes('PSU|')) return 0.92;
  return 0.0;
}

function detectIronbrew1(source) {
  if (IRONBREW1_HEADER.test(source.slice(0, 400))) return 1.0;
  if (IRONBREW1_SHAPE.test(source.trimStart().slice(0, 600))) return 0.8;
  return 0.0;
}

function detectIronbrew2(source) {
  const head500 = source.slice(0, 600);
  if (/IronBrew:tm:\s*obfuscation|AztupBrew\(Fork of IronBrew2\)/i.test(head500)) return 0.95;
  const head = source.trimStart().slice(0, 3000);
  if (
    head.includes('getfenv or function()return _ENV end') &&
    head.includes('=string.byte') &&
    head.includes('=setmetatable')
  ) {
    return 0.85;
  }
  return 0.0;
}

function detectLuaObfuscator(source) {
  const head = source.slice(0, 2000);
  if (head.includes('LuaObfuscator')) return 0.9;
  if (head.includes('bit32 or bit')) return 0.7;
  if (/^local v0=[\w.]+\s*;\s*local v1=/.test(head.trimStart())) return 0.8;
  return 0.0;
}

function detectHercules(source) {
  if (source.slice(0, 500).includes('Obfuscated by Hercules')) return 1.0;
  if (source.slice(0, 3000).includes('WrapState(BcToState(')) return 0.82;
  return 0.0;
}

function detectGoofyscator(source) {
  if (/Goofyscator/i.test(source.slice(0, 1000))) return 0.95;
  return 0.0;
}

function detectIronveil(source) {
  if (/Obfuscated using ironveil/i.test(source.slice(0, 600))) return 0.95;
  return 0.0;
}

function detectF77(source) {
  const head = source.slice(0, 3000);
  if (head.includes('77fuscator') || head.includes('77FUS|')) return 0.9;
  return 0.0;
}

function detectXhider(source) {
  if (source.slice(0, 3000).includes('XHD:')) return 0.9;
  return 0.0;
}

function detectBoronide(source) {
  if (source.slice(0, 500).toLowerCase().includes('herrtt')) return 0.9;
  return 0.0;
}

function detectIronbrew3(source) {
  if (/--ironbrew3:/i.test(source.slice(0, 300))) return 0.95;
  return 0.0;
}

function detectSynapseXen(source) {
  if (source.slice(0, 2000).includes('SynapseXen_')) return 0.9;
  return 0.0;
}

function detectWynfuscate(source) {
  if (source.slice(0, 500).includes('wYnFuscate')) return 0.9;
  return 0.0;
}

const PLUGINS = [
  { name: 'luraph_v15', label: 'Luraph v15', detect: detectLuraphV15 },
  { name: 'luraph_v14', label: 'Luraph v14 (v14.7–v14.9)', detect: detectLuraphV14 },
  { name: 'luarmor_client', label: 'Luarmor whitelist client (loader; payload not devirtualizable)', detect: detectLuarmor },
  { name: 'moonsec', label: 'MoonSec V3 / V2', detect: detectMoonsec },
  { name: 'moonveil', label: 'MoonVeil', detect: detectMoonveil },
  { name: 'prometheus', label: 'Prometheus', detect: detectPrometheus },
  { name: 'psu', label: 'PSU', detect: detectPsu },
  { name: 'ironbrew1', label: 'IronBrew v1', detect: detectIronbrew1 },
  { name: 'ironbrew2', label: 'IronBrew v2 / AztupBrew', detect: detectIronbrew2 },
  { name: 'hercules', label: 'Hercules', detect: detectHercules },
  { name: 'luaobfuscator', label: 'LuaObfuscator', detect: detectLuaObfuscator },
  { name: 'goofyscator', label: 'Goofyscator', detect: detectGoofyscator },
  { name: 'ironveil', label: 'Ironveil', detect: detectIronveil },
  { name: 'f77', label: '77fuscator', detect: detectF77 },
  { name: 'xhider', label: 'Xhider', detect: detectXhider },
  { name: 'clyde', label: 'Clyde', detect: () => 0.0 },
  { name: 'boronide', label: 'Boronide', detect: detectBoronide },
  { name: 'ironbrew3', label: 'IronBrew v3', detect: detectIronbrew3 },
  { name: 'synapsexen', label: 'SynapseXen', detect: detectSynapseXen },
  { name: 'wynfuscate', label: 'wYnFuscate', detect: detectWynfuscate },
];

const ALIASES = {
  luraph: 'luraph_v15',
  'luraph-v15': 'luraph_v15',
  luraph_v14_7: 'luraph_v14',
  luraph_v14_8: 'luraph_v14',
  luraph_v14_9: 'luraph_v14',
  moonsec_v3: 'moonsec',
  moonsec_v2: 'moonsec',
  ib1: 'ironbrew1',
  ib2: 'ironbrew2',
  aztupbrew: 'ironbrew2',
  '77fuscator': 'f77',
};

const ZSTD_B64_ENVELOPE_RE = /DecompressBuffer\s*\(\s*buffer\.fromstring\s*\(\s*base64\.decode\s*['"]([A-Za-z0-9+/=\s]+)['"]\s*\)\s*,\s*Enum\.CompressionAlgorithm\.Zstd\s*\)/;

function unwrapPackedEnvelope(source) {
  let cur = source;
  for (let depth = 0; depth < 3; depth++) {
    const m = ZSTD_B64_ENVELOPE_RE.exec(cur);
    if (!m || typeof zlib.zstdDecompressSync !== 'function') break;
    try {
      const comp = Buffer.from(m[1].replace(/\s+/g, ''), 'base64');
      const dec = zlib.zstdDecompressSync(comp);
      cur = dec.toString('latin1');
    } catch {
      break;
    }
  }
  return cur;
}

function detect(source) {
  const unpacked = unwrapPackedEnvelope(source);
  let best = { plugin: null, confidence: 0 };
  for (const p of PLUGINS) {
    let c = 0;
    try {
      c = p.detect(unpacked);
    } catch {
      c = 0;
    }
    if (c > best.confidence) best = { plugin: p, confidence: c };
  }
  if (best.confidence < 0.5) {
    return {
      plugin: { name: 'generic', label: 'unknown obfuscator (behaviour trace only)' },
      confidence: 0,
    };
  }
  return { plugin: best.plugin, confidence: best.confidence };
}

function byName(name) {
  const key = ALIASES[name] || name;
  if (key === 'generic') {
    return { name: 'generic', label: 'unknown obfuscator (behaviour trace only)', detect: () => 0.01 };
  }
  const p = PLUGINS.find((x) => x.name === key);
  if (!p) {
    throw new Error(`Unknown obfuscator '${name}' (known: ${PLUGINS.map((x) => x.name).join(', ')})`);
  }
  return p;
}

module.exports = { detect, byName, restoreHeaderNewline, unwrapPackedEnvelope, PLUGINS };
