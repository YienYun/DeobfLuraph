'use strict';

/**
 * Luarmor v4 track.
 *
 * A Luarmor-protected script is a chain: a client stub (`_bsdata0`), the
 * "sephal" init it downloads, and the licence handshake that finally hands
 * back the script the author uploaded. This module reads the chain statically
 * (core/obfuscators/luarmor) and reports what the file actually carries.
 *
 * When the file does carry code -- the sephal init, or a loader Luarmor served
 * -- that code is a Luraph v15 chunk, and it is devirtualized by the same
 * engine the Luraph track uses, with the Luarmor metadata attached to the
 * result. Nothing here bypasses a licence check: the session payload stays on
 * Luarmor's server unless the file happens to embed it.
 */

const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const { getPythonBin, pythonEnv } = require('./pyenv');

const CORE = path.join(__dirname, '..', 'core');
const ANALYZER = path.join(CORE, 'obfuscators', 'luarmor', 'analyze.py');

function analyze(sourcePath) {
  const out = execFileSync(getPythonBin(), [ANALYZER, sourcePath, '--json'], {
    encoding: 'utf8',
    maxBuffer: 32 * 1024 * 1024,
    env: pythonEnv({ PYTHONPATH: CORE }),
  });
  return JSON.parse(out);
}

function announce(meta) {
  const lines = [`[*] luarmor: ${meta.label}`];
  if (meta.module_id) lines.push(`[*]   module id    : ${meta.module_id}`);
  if (meta.cache_key) lines.push(`[*]   cache key    : ${meta.cache_key}`);
  if (meta.init_url) lines.push(`[*]   init source  : ${meta.init_url}`);
  const bs = meta.bsdata0 || {};
  if (bs.client_tag) lines.push(`[*]   client tag   : ${bs.client_tag.value}`);
  if (bs.build_stamp) lines.push(`[*]   build stamp  : ${bs.build_stamp.value} (${bs.build_stamp.iso})`);
  for (const h of bs.hash_fields || []) {
    const kind = h.sha256 ? 'sha256' : `hex(${h.bytes}B)`;
    lines.push(`[*]   ${kind.padEnd(10)} #${h.index}: ${h.digest.slice(0, 48)}${h.hex_length > 48 ? '...' : ''}`);
  }
  if (meta.superflow) {
    lines.push(`[*]   superflow    : ${meta.superflow.blob_bytes} B blob + Luraph chunk`);
  }
  const iocs = meta.iocs || {};
  for (const k of Object.keys(iocs)) {
    lines.push(`[*]   ${k.padEnd(13)}: ${iocs[k].slice(0, 2).join(', ')}`);
  }
  for (const note of meta.notes || []) lines.push(`[*]   note         : ${note}`);
  lines.push(meta.luraph_payload
    ? '[*] luarmor: devirtualizing the Luraph v15 chunk this file carries'
    : '[*] luarmor: no payload in this file — the script is fetched after the licence handshake');
  process.stderr.write(lines.join('\n') + '\n');
}

/**
 * States Luarmor kicked with while we ran the chain offline. `State294` is the
 * bootstrap refusing an environment it cannot verify; the payload behind the
 * check never gets decrypted in that case.
 */
function blockedStates(stats) {
  const states = ((stats && stats.luarmor_states) || []).filter((s) => /^State\d+$/.test(s));
  if (states.length) return states;
  // A Luarmor chain that lifts to one or two functions never got past the
  // bootstrap's checks: the payload is still encrypted, whatever the state code
  // (the trace truncates the kick line inside its retry loop).
  if (stats && typeof stats.functions === 'number' && stats.functions <= 2) return ['the loader checks did not pass'];
  return [];
}

function headerLines(meta, stats) {
  const out = [`-- Luarmor v4: ${meta.label}`];
  if (meta.module_id) out.push(`-- module id : ${meta.module_id}`);
  if (meta.cache_key) out.push(`-- cache key : ${meta.cache_key}`);
  if (meta.init_url) out.push(`-- init      : ${meta.init_url}`);
  const bs = meta.bsdata0 || {};
  if (bs.client_tag) out.push(`-- client tag: ${bs.client_tag.value}`);
  if (bs.build_stamp) out.push(`-- build stamp: ${bs.build_stamp.value} (${bs.build_stamp.iso})`);
  const iocs = meta.iocs || {};
  if (iocs.loader_id) out.push(`-- loader id : ${iocs.loader_id.join(', ')}`);
  if (iocs.get_key_link) out.push(`-- key link  : ads.luarmor.net/get_key?for=${iocs.get_key_link[0]}`);
  const states = blockedStates(stats);
  if (states.length) {
    out.push(`-- Luarmor blocked the offline run (${states.join(', ')}): the session payload was never`);
    out.push('-- decrypted, so only the loader in this file was recovered. Capture the loader\'s');
    out.push('-- loadstring/HttpGet output from a real executor to get the payload itself.');
  } else {
    out.push('-- The licence check itself is not bypassed: only the code in this file was lifted.');
  }
  return out.join('\n');
}

/** Comment block documenting what was done, put on top of a lifted chunk. */
function prependHeader(resultPath, meta, stats) {
  let text = fs.readFileSync(resultPath, 'latin1');
  if (text.startsWith('-- Luarmor v4:')) return;
  fs.writeFileSync(resultPath, headerLines(meta, stats) + '\n\n' + text, 'latin1');
}

/**
 * A client stub carries no code: keep the stub byte-for-byte and put the
 * analysis on top, so the result is honest and still a valid Lua file.
 */
function annotateStub(source, meta, stats) {
  const notes = [
    '--',
    '-- This file is a loader stub, not the protected script. It fetches its init',
    '-- and asks the Luarmor server for the script at runtime; the script text is',
    '-- not present in these bytes, so there is nothing here to devirtualize.',
  ];
  return headerLines(meta, stats) + '\n' + notes.join('\n') + '\n\n' + source;
}

function reportPath(finalPath) {
  return finalPath.replace(/(\.(?:lua|luau|txt))?$/i, '') + '.luarmor.json';
}

function writeReport(finalPath, meta) {
  const p = reportPath(finalPath);
  fs.mkdirSync(path.dirname(p), { recursive: true });
  fs.writeFileSync(p, JSON.stringify(meta, null, 2) + '\n', 'utf8');
  return p;
}

module.exports = { analyze, announce, prependHeader, annotateStub, writeReport, reportPath, blockedStates };
