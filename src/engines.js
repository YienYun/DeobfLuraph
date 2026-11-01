'use strict';

// Dispatch for the engines this build ships besides Luraph v15 (which has its
// own driver): Luraph v14 and MoonVeil. Everything here runs the file in the
// offline harness, so a run costs real time.
//
// Luarmor is not in this list because it is not an engine of its own: its files
// are analysed by src/luarmor.js, and the Luraph chunk they carry is lifted by
// src/driver.js like any other v15 file.

const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync, execFileSync } = require('child_process');
const driver = require('./driver');
const harness = require('./harness');
const trace = require('./traceout');
const tidy = require('./tidy');
const { getPythonBin, pythonEnv } = require('./pyenv');
const { isValidLuaSyntax } = require('./luau_check');

const ROOT = path.resolve(__dirname, '..');
const CORE = path.join(ROOT, 'core');
const OBFUSCATORS = path.join(CORE, 'obfuscators');

// Names as detect.js reports them. `luraph_v15` never reaches this file.
function finalizeStaticResult(job, outPath, label) {
  if (!outPath || !fs.existsSync(outPath) || fs.statSync(outPath).size === 0) {
    throw new Error(`${label} produced an empty output`);
  }
  const code = fs.readFileSync(outPath, 'utf8');
  if (!code.trim()) {
    throw new Error(`${label} produced whitespace-only output`);
  }
  job.resultType = 'devirtualized';
  job.traceStatus = 'static';
  if (!isValidLuaSyntax(code)) {
    const warn = `${label} output did not pass the Luau syntax check; Lua 5.1 constructs or partial recovery may be present.`;
    process.stderr.write(`[!] ${warn}\n`);
    job.warnings.push(warn);
  }
  return outPath;
}

async function runLuraphV14(job) {
  const { args } = job;
  const bridgePy = path.join(__dirname, 'devirt_bridge.py');
  let patched = job.source;
  if (!args.noHooks) {
    const r = spawnSync(getPythonBin(), [bridgePy, 'patch-entries-v14', job.sourcePath], {
      env: pythonEnv({ PYTHONPATH: CORE }),
      maxBuffer: 64 * 1024 * 1024,
      timeout: 60000,
      windowsHide: true,
    });
    if (!r.error && r.status === 0 && r.stdout && r.stdout.length > 0) {
      patched = r.stdout.toString('latin1');
    } else {
      process.stderr.write('[!] Luraph v14 VM hook mapper did not match; running behaviour trace\n');
      return driver.runGeneric(job);
    }
  }

  const cachePath = harness.loadP2dCache(job.input);
  const runner = new harness.Runner(job);
  const cfg = {
    time_budget: args.budget,
    dump_strings: args.strings,
    executor: args.executor,
    skip_protos: [],
    devirt: !args.noDevirt,
  };
  if (args.inputText) cfg.input_text = args.inputText;
  if (args.noFold) cfg.fold = false;
  if (args.cfgJson) Object.assign(cfg, args.cfgJson);

  process.stderr.write(`[*] tracing Luraph v14 ${job.input}...\n`);
  const res = await runner.run(patched, cfg);
  if (!res.body) {
    runner.finish();
    throw new Error(res.err || 'Luraph v14 trace failed without output');
  }
  let body = harness.takeP2d(res.body);
  const { body: cleanBody } = harness.takeChunks(body);
  body = cleanBody;
  const runText = harness.traceText(body);
  body = harness.p2dMiss(body, cachePath);

  const [protosJson, b1] = trace.takeLine(body, 'PROTOS');
  body = b1;
  const [, b2] = trace.takeLine(body, 'FORCE');
  body = b2;
  const [, b3] = trace.takeLine(body, 'UNSCRAMBLED');
  body = b3;
  const [b4, strings] = trace.takeStrings(body);
  body = b4;
  if (strings !== null) job.write(job.path('.strings.txt'), strings);

  const traceText = trace.header(job.input) + body;
  const writeTrace = () => job.write(job.tracePath, tidy.tidy(traceText, { preamble: !args.keepPreamble }));

  const dpath = job.path('.devirt.luau');
  if (protosJson && !protosJson.startsWith('error:') && !args.noDevirt) {
    const ppath = job.write(job.path('.protos.json'), protosJson);
    const statsDir = fs.mkdtempSync(path.join(os.tmpdir(), 'v14-stats-'));
    const statsPath = path.join(statsDir, 'stats.json');
    const cfgPath = job.path('.v14_cfg.json');
    try {
      fs.writeFileSync(
        cfgPath,
        JSON.stringify({
          input: job.input,
          source: job.source,
          source_path: job.sourcePath,
          trace_path: job.tracePath,
          debug: job.debug,
          obfuscator: job.obfuscator,
          luau_exe: runner.luau,
          patched,
          cfg,
          chunks: {},
          run_text: runText,
          ppath,
          dpath,
          stats_path: statsPath,
          chunk_paths: [],
          args: {
            budget: args.budget,
            timeout: args.timeout,
            devirt_rounds: args.devirtRounds || 200,
            studio: false,
            no_fold: args.noFold || false,
            strings: args.strings || false,
            executor: args.executor || 'Wave',
          },
        }),
        'utf8'
      );
      execFileSync(getPythonBin(), [bridgePy, 'pipeline-v14', cfgPath], {
        env: pythonEnv({ PYTHONPATH: CORE }),
        stdio: 'inherit',
      });
      if (fs.existsSync(statsPath)) {
        job.liftStats = JSON.parse(fs.readFileSync(statsPath, 'utf8'));
      }
    } finally {
      try { fs.unlinkSync(cfgPath); } catch {}
      fs.rmSync(statsDir, { recursive: true, force: true });
    }
  }

  runner.finish();
  trace.statusLine(body);
  if (job.liftStats && job.liftStats.functions > 0 && fs.existsSync(dpath)) {
    job.resultType = 'devirtualized';
    return dpath;
  }
  writeTrace();
  job.resultType = 'trace';
  return job.tracePath;
}

async function runMoonveil(job) {
  const out = job.path('.moonveil.lua');
  const mvDir = path.join(OBFUSCATORS, 'moonveil');
  const mvTimeout = Math.max(job.args.timeout || 90, 120);
  const r = spawnSync(
    getPythonBin(),
    ['-m', 'moonveil', 'deobfuscate', job.sourcePath, '-o', out, '--force', '--seconds', String(mvTimeout)],
    {
      cwd: mvDir,
      encoding: 'utf8',
      timeout: (mvTimeout + 30) * 1000,
      maxBuffer: 64 * 1024 * 1024,
      windowsHide: true,
      env: pythonEnv({ PYTHONPATH: mvDir }),
    }
  );
  if (!r.error && r.status === 0 && fs.existsSync(out) && fs.statSync(out).size > 0) {
    return finalizeStaticResult(job, out, 'MoonVeil');
  }
  const detail = ((r.stderr || r.stdout || '') + '').trim().split('\n').pop() || `exit ${r.status}`;
  throw new Error(`MoonVeil static engine unsupported/failed (${detail})`);
}

const RUNNERS = {
  luraph_v14: runLuraphV14,
  moonveil: runMoonveil,
};

// Engines this build does not ship. Saying so is the honest answer: a behaviour
// trace of a file nobody can lift is not a decompilation, so no output is
// written for these instead of handing back the input with a new header.
const NOT_SHIPPED = {
  luraph_v15: 'handled by src/driver.js',
  luarmor_client: 'analysed by src/luarmor.js',
  moonsec: 'MoonSec V2 / V3',
  ironbrew1: 'IronBrew v1',
  ironbrew2: 'IronBrew v2 / AztupBrew',
  ironbrew3: 'IronBrew v3',
  prometheus: 'Prometheus',
  psu: 'PSU v4.x',
  hercules: 'Hercules',
  goofyscator: 'Goofyscator / f77 / xHider',
  luaobfuscator: 'LuaObfuscator',
};

async function runPlugin(pluginName, job) {
  if (pluginName === 'luraph_v15') {
    return driver.run(job);
  }
  if (pluginName === 'luarmor_client') {
    throw new Error('Luarmor files are handled by the Luarmor analyzer, not an engine');
  }
  if (pluginName === 'generic') {
    return driver.runGeneric(job);
  }
  const fn = RUNNERS[pluginName];
  if (!fn) {
    const label = NOT_SHIPPED[pluginName];
    throw new Error(`${label || pluginName} is not part of this build `
      + '(it ships Luraph v14/v15, MoonVeil and the Luarmor analyzer)');
  }
  if (job.args.noDevirt) {
    return driver.runGeneric(job);
  }
  process.stderr.write(`[*] running the ${pluginName} engine on ${path.basename(job.input)}...\n`);
  return fn(job);
}

module.exports = { runPlugin, NOT_SHIPPED };
