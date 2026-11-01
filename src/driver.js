'use strict';

const fs = require('fs');
const path = require('path');
const vmmap = require('./vmmap');
const harness = require('./harness');
const trace = require('./traceout');
const tidy = require('./tidy');

const SPIN_CHECKS = 24;

function addTraceStatus(job, body) {
  const status = /^-- run status: (.*)$/m.exec(body);
  if (status) {
    job.traceStatus = status[1].trim();
    if (job.traceStatus !== 'finished') {
      job.warnings.push(`Trace did not finish normally: ${job.traceStatus}`);
    }
  }
}

function patchChunk(src, tmpdir, chunkTag) {
  const p = path.join(tmpdir, `_chunk_${harness.chunkKey(src)}.luau`);
  fs.writeFileSync(p, src, 'latin1');
  try {
    return vmmap.patchEntries(src, p, chunkTag);
  } catch (e) {
    process.stderr.write(`[!] could not instrument chunk (${e.message})\n`);
    return src;
  } finally {
    try { fs.unlinkSync(p); } catch {}
  }
}

async function run(job) {
  const { args } = job;
  const devirtOn = !args.noDevirt;
  let source = job.source;

  let patched;
  try {
    patched = args.noHooks ? source : vmmap.patchEntries(source, job.sourcePath, harness.chunkKey(source));
  } catch (e) {
    process.stderr.write(`[!] AST parse failed: ${e.message}\n`);
    throw e;
  }

  let spin = false;

  const cachePath = harness.loadP2dCache(job.input);
  const runner = new harness.Runner(job);

  const skip = [];
  const chunks = {};
  const rawChunks = {};
  let body = null;
  let trapped = null;
  let cfg = null;

  for (let attempt = 1; attempt <= args.maxRuns; attempt++) {
    cfg = {
      time_budget: args.budget,
      dump_strings: args.strings,
      executor: args.executor,
      skip_protos: skip,
      devirt: devirtOn,
    };
    if (args.inputText) cfg.input_text = args.inputText;
    if (args.preludeFile) cfg.prelude = require('fs').readFileSync(args.preludeFile, 'latin1');
    if (args.noFold) cfg.fold = false;
    if (spin) cfg.spin = SPIN_CHECKS;
    if (args.cfgJson) Object.assign(cfg, args.cfgJson);

    process.stderr.write(`[*] tracing ${job.input} (run ${attempt})...\n`);
    const res = await runner.run(patched, cfg, chunks);
    body = res.body;

    if (!body) {
      runner.finish();
      throw new Error(res.err || 'Trace failed without output');
    }

    body = harness.takeP2d(body);

    const { chunks: found, body: cleanBody } = harness.takeChunks(body);
    body = cleanBody;
    let added = 0;
    for (const [key, src] of found) {
      if (!chunks[key] && args.noHooks) {
        chunks[key] = src;
      } else if (!chunks[key]) {
        rawChunks[key] = src;
        chunks[key] = patchChunk(src, job.outdir, key);
        if (spin) chunks[key] = vmmap.patchSpin(chunks[key]);
        added++;
      }
    }
    if (added > 0) {
      if (attempt === args.maxRuns) {
        job.warnings.push('Additional VM chunks were found after the final allowed trace run; the result may be incomplete.');
      }
      process.stderr.write(`[*] script loadstring'd ${added} new VM chunk(s); instrumenting and re-running\n`);
      continue;
    }

    const trig = new RegExp(harness.mark('TRIGGER ') + '(\\d+)').exec(body);
    if (trapped !== null && trace.stmtCount(body) < trace.stmtCount(trapped[0])) {
      process.stderr.write(`[*] disabling function #${skip[skip.length - 1]} made script stop earlier: keeping run ${attempt - 1}\n`);
      body = trapped[0];
      skip.pop();
      break;
    }
    if (!trig) break;

    trapped = [body, harness.getLastRaw()];
    const pid = parseInt(trig[1], 10);
    if (skip.includes(pid)) {
      process.stderr.write(`[!] anti-tamper trigger ${pid} fired again; giving up on reruns\n`);
      job.warnings.push(`Anti-tamper trigger #${pid} fired again; the result may be incomplete.`);
      break;
    }
    if (attempt === args.maxRuns) {
      job.warnings.push(`Anti-tamper trigger #${pid} fired on the final allowed run; the result may be incomplete.`);
      break;
    }
    process.stderr.write(`[*] anti-tamper trap reached through function #${pid}; disabling it and re-running\n`);
    skip.push(pid);
  }

  const runText = harness.traceText(body);
  if (body.includes(harness.mark('P2DMISS'))) {
    job.warnings.push('The offline Path2D model could not answer a call; the result may be incomplete.');
  }
  if (skip.length) {
    job.warnings.push(`Anti-tamper functions ${skip.map(p => '#' + p).join(', ')} were skipped during tracing.`);
  }
  body = harness.p2dMiss(body, cachePath);
  body = body.replace(new RegExp(harness.mark('TRIGGER ') + '\\d+\\n?', 'g'), '');

  const [protosJson, b1] = trace.takeLine(body, 'PROTOS');
  body = b1;
  const [force, b2] = trace.takeLine(body, 'FORCE');
  body = b2;
  if (force && devirtOn) process.stderr.write(`[*] constants decoded on request: ${force}\n`);

  const [unscrambled, b3] = trace.takeLine(body, 'UNSCRAMBLED');
  body = b3;
  if (unscrambled && devirtOn)
    process.stderr.write(`[*] ${unscrambled} function(s) scrambled by LPH_CRASH(): dumped as created\n`);

  const [b4, strings] = trace.takeStrings(body);
  body = b4;

  const notes = skip.length ? [`anti-tamper trap functions disabled: ${skip.map(p => '#' + p).join(', ')}`] : [];
  const text = trace.header(job.input, notes) + body;

  function writeTrace() {
    job.write(job.tracePath, tidy.tidy(text, { preamble: !args.keepPreamble }));
  }

  // In debug mode also keep the trace alongside the intermediate files.
  if (!devirtOn || job.debug) {
    writeTrace();
  }

  if (strings !== null) job.write(job.path('.strings.txt'), strings);

  const dpath = job.path('.devirt.luau');
  let producedLift = false;
  if (protosJson) {
    const ppath = job.path('.protos.json');
    if (protosJson.startsWith('error:')) {
      process.stderr.write(`[!] proto capture failed: ${protosJson}\n`);
    } else {
      job.write(ppath, protosJson);
      if (devirtOn) {
        const chunkPaths = Object.entries(rawChunks).map(([k, src]) =>
          job.write(job.path(`.chunk_${k}.luau`), src, 'latin1')
        );
        // Use a fresh stats file even in --debug mode. Old intermediate
        // outputs must never be mistaken for a result from the current run.
        const statsDir = fs.mkdtempSync(path.join(require('os').tmpdir(), 'deobf-stats-'));
        const statsPath = path.join(statsDir, 'stats.json');
        // `-- run status: ...` from the behaviour trace: an early error means
        // the trace covers only the part of the script that managed to run.
        const statusMatch = /^-- run status: (.*)$/m.exec(body || '');
        const runStatus = statusMatch ? statusMatch[1].trim() : '';
        const cfgData = {
          input: job.input,
          source: job.source,
          source_path: job.sourcePath,
          trace_path: job.tracePath,
          debug: job.debug,
          obfuscator: job.obfuscator,
          luau_exe: runner.luau,
          patched: patched,
          cfg: cfg,
          chunks: chunks,
          run_text: runText,
          run_status: runStatus,
          ppath: ppath,
          dpath: dpath,
          stats_path: statsPath,
          chunk_paths: chunkPaths,
          args: {
            budget: args.budget,
            timeout: args.timeout,
            devirt_rounds: args.devirtRounds || 200,
            loop_fuel: args.loopFuel || 65536,
            spin_fuel: args.spinFuel || 64,
            studio: false,
            no_fold: args.noFold || false,
            strings: args.strings || false,
            executor: args.executor || 'Wave',
          },
        };
        const cfgPath = job.path('.cfg.json');
        try {
          fs.writeFileSync(cfgPath, JSON.stringify(cfgData), 'utf8');
          const { execFileSync } = require('child_process');
          const { getPythonBin, pythonEnv } = require('./pyenv');
          const pythonBin = getPythonBin();
          const bridgePy = path.join(__dirname, 'devirt_bridge.py');
          const coreDir = path.join(__dirname, '..', 'core');
          execFileSync(pythonBin, [bridgePy, 'pipeline', cfgPath], {
            env: pythonEnv({ PYTHONPATH: coreDir }),
            stdio: 'inherit',
          });
          if (fs.existsSync(statsPath)) {
            job.liftStats = JSON.parse(fs.readFileSync(statsPath, 'utf8'));
            producedLift = true;
          }
        } finally {
          try { fs.unlinkSync(cfgPath); } catch {}
          fs.rmSync(statsDir, { recursive: true, force: true });
        }
      }
    }
  }

  runner.finish();
  trace.statusLine(body);
  addTraceStatus(job, body);

  if (devirtOn && producedLift && fs.existsSync(dpath)) {
    const lifted = fs.readFileSync(dpath, 'utf8');
    const nilCalls = (lifted.match(/\(nil\)\(/g) || []).length;
    const lines = lifted.split('\n').length;
    const stats = job.liftStats;
    if (lifted.trim() && stats.functions > 0 && (nilCalls < 50 || nilCalls * 100 < lines)) {
      job.resultType = 'devirtualized';
      if (stats.errors || stats.fallbacks) {
        job.warnings.push(`Lift has ${stats.errors} unlifted blocks and ${stats.fallbacks} unstructured jumps.`);
      }
      if (!stats.converged) {
        job.warnings.push('Constant resolution did not converge; the output may be incomplete.');
      }
      if (/error\(["'](?:devirt:|Luraph runtime function, not devirtualized)/.test(lifted)) {
        job.warnings.push('The output contains unresolved devirtualization stubs; it may be incomplete.');
      }
      // Parsing is only a syntax check, not proof that recovered code has the
      // same behavior as the original. Keep imperfect output but flag it.
      const check = require('child_process').spawnSync(harness.luauAst(), [dpath], {
        stdio: ['ignore', 'ignore', 'pipe'], encoding: 'utf8', timeout: 120000, windowsHide: true,
      });
      if (check.error || check.status !== 0) {
        const detail = (check.stderr || check.error?.message || 'unknown parser error').trim().slice(0, 300);
        const warning = `Output did not pass the Luau syntax check: ${detail}`;
        process.stderr.write(`[!] ${warning}\n`);
        job.warnings.push(warning);
      }
      return dpath;
    }
    const warning = !lifted.trim() || !stats.functions
      ? 'Devirtualization recovered no functions; returning a behaviour trace instead.'
      : `The devirtualized output looks broken (${nilCalls} calls of nil); returning a behaviour trace instead.`;
    process.stderr.write(`[!] ${warning}\n`);
    job.warnings.push(warning);
    if (!job.debug) { try { fs.unlinkSync(dpath); } catch {} }
    writeTrace();
    job.resultType = 'trace';
    return job.tracePath;
  }

  if (devirtOn) {
    const warning = 'Devirtualization produced no output; returning a behaviour trace instead.';
    process.stderr.write(`[!] ${warning}\n`);
    job.warnings.push(warning);
    if (!fs.existsSync(job.tracePath)) writeTrace();
  }
  job.resultType = 'trace';
  return job.tracePath;
}

async function runGeneric(job) {
  const { args } = job;
  const cachePath = harness.loadP2dCache(job.input);
  const runner = new harness.Runner(job);
  const cfg = {
    time_budget: args.budget,
    executor: args.executor,
    dump_strings: args.strings,
  };
  if (args.inputText) cfg.input_text = args.inputText;
  if (args.noFold) cfg.fold = false;
  if (args.cfgJson) Object.assign(cfg, args.cfgJson);

  process.stderr.write(`[*] tracing ${job.input}...\n`);
  const res = await runner.run(job.source, cfg);
  if (!res.body) {
    runner.finish();
    throw new Error(res.err || 'Trace failed without output');
  }
  runner.finish();
  let body = harness.takeP2d(res.body);
  if (body.includes(harness.mark('P2DMISS'))) {
    job.warnings.push('The offline Path2D model could not answer a call; the result may be incomplete.');
  }
  body = harness.p2dMiss(body, cachePath);
  const { body: cleanBody } = harness.takeChunks(body);
  body = cleanBody;
  const [b2, strings] = trace.takeStrings(body);
  body = b2;

  const text = trace.header(job.input) + body;
  job.write(job.tracePath, tidy.tidy(text, { preamble: false }));
  if (strings !== null) job.write(job.path('.strings.txt'), strings);
  trace.statusLine(body);
  addTraceStatus(job, body);
  job.resultType = 'trace';
  if (!args.noDevirt) {
    job.warnings.push('This input is not recognized as Luraph v15; only a behaviour trace was produced.');
  }
  return job.tracePath;
}

module.exports = { run, runGeneric };
