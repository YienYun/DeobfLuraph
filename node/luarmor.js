'use strict';


const fs = require('fs');
const path = require('path');
const { execFileSync } = require('child_process');

const { getPythonBin, pythonEnv } = require('./pyenv');

const CORE = path.join(__dirname, '..', 'engine');
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
  const stubKind = meta.kind === 'client_stub' || meta.kind === 'hub_pointer';
  lines.push(meta.luraph_payload
    ? '[*] luarmor: devirtualizing the Luraph v15 chunk this file carries'
    : stubKind
      ? '[*] luarmor: no payload in this file — the script is fetched after the licence handshake'
      : '[*] luarmor: nothing to lift here — the Luarmor url is a loader this script fetches');
  process.stderr.write(lines.join('\n') + '\n');
}


function blockedStates(stats) {
  const states = ((stats && stats.luarmor_states) || []).filter((s) => /^State\d+$/.test(s));
  if (states.length) return states;
  if (stats && typeof stats.functions === 'number' && stats.functions <= 2) return ['the loader checks did not pass'];
  return [];
}

function headerLines(meta, stats) {
  const out = [`-- Luarmor v4: ${meta.label}`];
  if (meta.module_id) out.push(`-- module id : ${meta.module_id}`);
  if (meta.cache_key) out.push(`-- cache key : ${meta.cache_key}`);
  if (meta.init_url) {
    const tag = meta.kind === 'hub_pointer' ? 'loader    ' : 'init      ';
    out.push(`-- ${tag}: ${meta.init_url}`);
  }
  const bs = meta.bsdata0 || {};
  if (bs.client_tag) out.push(`-- client tag: ${bs.client_tag.value}`);
  if (bs.build_stamp) out.push(`-- build stamp: ${bs.build_stamp.value} (${bs.build_stamp.iso})`);
  const iocs = meta.iocs || {};
  if (iocs.loader_id) out.push(`-- loader id : ${iocs.loader_id.join(', ')}`);
  if (iocs.get_key_link) out.push(`-- key link  : ads.luarmor.net/get_key?for=${iocs.get_key_link[0]}`);
  const states = blockedStates(stats);
  if (states.length && stats && stats.functions === 0) {
    out.push(`-- Luarmor blocked the offline run (${states.join(', ')}): the payload this file runs is`);
    out.push('-- decrypted by the live session, so nothing in its own bytes executes without it.');
  } else if (states.length) {
    out.push(`-- Luarmor blocked the offline run (${states.join(', ')}): the session payload was never`);
    out.push('-- decrypted, so only the loader in this file was recovered. Capture the loader\'s');
    out.push('-- loadstring/HttpGet output from a real executor to get the payload itself.');
  } else {
    out.push('-- The licence check itself is not bypassed: only the code in this file was lifted.');
  }
  const status = (stats && stats.run_status) || '';
  if (/^script error/.test(status)) {
    out.push(`-- The offline run stopped early (${status.replace(/^script status: /, '')}), so code that`);
    out.push('-- never ran in this sandbox is lifted from its protos alone; the trace is partial.');
  }
  if (stats && stats.runtime_stubs) {
    out.push(`-- ${stats.runtime_stubs} Luraph VM runtime function(s) (LPH_ENCFUNC) are named but not lifted:`
      + ' they live in the VM object.');
  }
  return out.join('\n');
}

function prependHeader(resultPath, meta, stats) {
  let text = fs.readFileSync(resultPath, 'latin1');
  if (text.startsWith('-- Luarmor v4:')) return;
  fs.writeFileSync(resultPath, headerLines(meta, stats) + '\n\n' + text, 'latin1');
}


function annotateStub(source, meta, stats) {
  const notes = ['--'];
  if (meta.kind === 'hub_pointer') {
    notes.push('-- This file is only a pointer to a Luarmor loader. Fetch the url in the');
    notes.push('-- header, and run the file it returns through this same command.');
  } else {
    notes.push('-- This file is a loader stub, not the protected script. It fetches its init');
    notes.push('-- and asks the Luarmor server for the script at runtime; the script text is');
    notes.push('-- not present in these bytes, so there is nothing here to devirtualize.');
  }
  return headerLines(meta, stats) + '\n' + notes.join('\n') + '\n\n' + source;
}


function chainPlan(payloadPath) {
  if (!payloadPath || !fs.existsSync(payloadPath)) return null;
  const text = fs.readFileSync(payloadPath, 'latin1');
  const det = require('./detect').detect(text);
  if (!det || det.plugin.name !== 'luarmor_client') return null;
  const meta = analyze(payloadPath);
  return { meta, lift: !!meta.luraph_payload, confidence: det.confidence };
}


async function chain(job, resultPath, deps = {}) {
  const payloadPath = job.path('.payload.luau');
  const plan = chainPlan(payloadPath);
  if (!plan) return null;
  const meta = plan.meta;
  meta.file = `${job.input}#payload`;
  meta.carried_from = job.input;
  if (!meta.luraph_payload) {
    meta.notes.push('the script itself is downloaded after the licence handshake, so it is '
      + 'not in this file');
  }
  job.luarmor = meta;
  job.chain = (job.chain || []).concat([`luarmor:${meta.kind}`]);
  process.stderr.write('[*] the script the loader carried is Luarmor: ' + meta.label + '\n');
  announce(meta);
  if (!plan.lift) {
    const stubKind = meta.kind === 'client_stub' || meta.kind === 'hub_pointer';
    job.warnings.push(stubKind
      ? `The loader carries a Luarmor client stub (${meta.kind}): the script is fetched `
        + 'at run time, so it is not in this file.'
      : `The script names a Luarmor-hosted loader (${meta.kind}); the code at that url is not `
        + 'in this file, and nothing here needed lifting.');
    return null;
  }
  const saved = {
    input: job.input, source: job.source, sourcePath: job.sourcePath,
    tracePath: job.tracePath,
  };
  job.input = payloadPath;
  job.source = fs.readFileSync(payloadPath, 'latin1');
  job.sourcePath = payloadPath;
  job.tracePath = job.tracePath.replace(/(\.deobf\.luau)$/, '.carried$1');
  job.resultType = null;
  job.liftStats = null;
  job.traceStatus = null;
  const driver = deps.driver || require('./driver');
  let lifted = null;
  try {
    lifted = await driver.run(job);
  } catch (e) {
    job.warnings.push(`The carried Luarmor payload could not be lifted: ${e.message}`);
    process.stderr.write(`[!] carried Luarmor payload: ${e.message}\n`);
  } finally {
    job.input = saved.input;
    job.source = saved.source;
    job.sourcePath = saved.sourcePath;
    job.tracePath = saved.tracePath;
  }
  if (!lifted || !fs.existsSync(lifted)) return null;
  prependHeader(lifted, meta, job.liftStats || {});
  job.chain = job.chain.concat(['luraph_v15']);
  return lifted;
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

module.exports = { analyze, announce, prependHeader, annotateStub, writeReport, reportPath,
  blockedStates, headerLines, chainPlan, chain };
