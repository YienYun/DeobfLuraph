'use strict';

const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync, execFileSync } = require('child_process');
const driver = require('./driver');
const harness = require('./harness');
const trace = require('./traceout');
const tidy = require('./tidy');
const { getPythonBin, pythonEnv } = require('./pyenv');
const { isValidLuaSyntax } = require('./luac_decompile');

const ROOT = path.resolve(__dirname, '..');
const CORE = path.join(ROOT, 'core');
const OBFUSCATORS = path.join(CORE, 'obfuscators');

function binPath(name) {
  const ext = process.platform === 'win32' ? '.exe' : '';
  const p = path.join(ROOT, 'bin', name + ext);
  return fs.existsSync(p) ? p : name;
}

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

function runNodeCli(scriptArgs, timeoutSec, opts = {}) {
  const r = spawnSync(process.execPath, scriptArgs, {
    cwd: opts.cwd || ROOT,
    encoding: 'utf8',
    timeout: (timeoutSec || 90) * 1000,
    maxBuffer: 64 * 1024 * 1024,
    windowsHide: true,
    env: Object.assign({}, process.env, opts.env || {}),
  });
  if (r.error) throw r.error;
  if (r.status !== 0) {
    const msg = (r.stderr || r.stdout || `exit ${r.status}`).trim().split('\n').pop();
    throw new Error(msg);
  }
  return r.stdout || '';
}

function runPythonCli(pyArgs, timeoutSec, opts = {}) {
  const r = spawnSync(getPythonBin(), pyArgs, {
    cwd: opts.cwd || ROOT,
    encoding: 'utf8',
    timeout: (timeoutSec || 90) * 1000,
    maxBuffer: 64 * 1024 * 1024,
    windowsHide: true,
    env: pythonEnv(opts.env),
  });
  if (r.error) throw r.error;
  if (r.status !== 0) {
    const msg = (r.stderr || r.stdout || `exit ${r.status}`).trim().split('\n').pop();
    throw new Error(msg);
  }
  return r;
}

async function runPrometheus(job) {
  const cli = path.join(OBFUSCATORS, 'prometheus', 'bin', 'pdeobf.js');
  const out = job.path('.prometheus.lua');
  runNodeCli([cli, job.sourcePath, '-o', out], job.args.timeout);
  return finalizeStaticResult(job, out, 'Prometheus');
}

async function runLuaObfuscator(job) {
  // The static transforms parse Lua with luaparse; without it every sample
  // "fails" and the pipeline quietly hands back a behaviour trace instead.
  try {
    require.resolve('luaparse');
  } catch (err) {
    throw new Error('luaparse is not installed, run `npm install` at the repository root '
      + '(the LuaObfuscator transforms cannot parse Lua without it)');
  }
  const cli = path.join(OBFUSCATORS, 'luaobfuscator', 'src', 'cli.js');
  const reportPath = job.path('.luaobfuscator.json');
  const stdout = runNodeCli([cli, job.sourcePath, '--stdout', '--json-report', reportPath], job.args.timeout);
  if (!stdout.trim()) throw new Error('LuaObfuscator returned empty stdout');
  let report = null;
  try {
    report = JSON.parse(fs.readFileSync(reportPath, 'utf8'));
  } catch (err) {
    report = null;
  }
  const stats = report ? report.stats : null;
  let source = stdout;
  if (stats && stats.vmOutputMode === 'vm-ir') {
    // The VM presets (OBFUSCATE!, Chaotic Evil) ship their script as bytecode
    // for an interpreter whose opcodes are randomised per build. The payload is
    // decoded, but decoding it is not lifting it: label the result as what it
    // is, with the counts, instead of letting a listing pass for source.
    const preserved = stats.vmPreservedInstructions || 0;
    const header = [
      `-- LuaObfuscator: decoded VM payload only (${preserved} instructions preserved as IR).`,
      '-- No source lift: this build\'s interpreter opcodes are randomised, so the',
      '-- listing below is the recovered bytecode plus a best-effort preview.',
      '',
    ].join('\n');
    source = header + stdout;
    job.luaobf = { mode: 'vm-ir', preserved, instructions: stats.vmInstructions || 0 };
    job.warnings.push(`LuaObfuscator preserved ${preserved} VM instructions as IR: the payload is `
      + 'decoded but not lifted back to source (randomised opcodes).');
    process.stderr.write(`[!] VM payload decoded, not lifted: ${preserved} instructions preserved as IR\n`);
  } else if (stats) {
    job.luaobf = { mode: stats.vmOutputMode, decodedStrings: stats.decodedStrings || 0 };
  }
  const out = job.write(job.path('.luaobfuscator.lua'), source);
  const finalized = finalizeStaticResult(job, out, 'LuaObfuscator');
  if (job.luaobf && job.luaobf.mode === 'vm-ir') job.resultType = 'vm-ir';
  return finalized;
}

async function runPsu(job) {
  const cli = path.join(OBFUSCATORS, 'psu', 'src', 'cli.js');
  const out = job.path('.psu.lua');
  runNodeCli([cli, job.sourcePath, '-o', out], job.args.timeout);
  return finalizeStaticResult(job, out, 'PSU');
}

async function runHercules(job) {
  const cli = path.join(OBFUSCATORS, 'hercules', 'deobfhercules.py');
  const out = job.path('.hercules.lua');
  runPythonCli([cli, job.sourcePath, out, '--timeout', String(job.args.timeout)], job.args.timeout + 10, {
    env: { PYTHONPATH: path.join(OBFUSCATORS, 'hercules') },
  });
  return finalizeStaticResult(job, out, 'Hercules');
}

async function runGoofyscator(job) {
  const cli = path.join(OBFUSCATORS, 'goofyscator', 'cli.js');
  const out = job.path('.goofyscator.lua');
  const luaRuntime = fs.existsSync(binPath('lua5.1')) ? binPath('lua5.1') : binPath('luau');
  runNodeCli([cli, job.sourcePath, '-o', out, '--lua', luaRuntime], job.args.timeout);
  return finalizeStaticResult(job, out, 'Goofyscator');
}

async function runMoonsec(job) {
  const out = job.path('.moonsec.lua');
  const isV2 = job.source.slice(0, 1500).includes('..:::MoonSec::..') || job.source.slice(0, 1500).includes('MoonSec V2');

  const tryV3 = () => {
    const { deobfuscateToSource } = require(path.join(OBFUSCATORS, 'moonsec', 'src', 'decompiler.js'));
    const code = deobfuscateToSource(job.source, { timeout: job.args.timeout * 1000 });
    return job.write(out, code);
  };
  const tryV2 = () => {
    const cli = path.join(OBFUSCATORS, 'ironbrew2', 'cli.js');
    runNodeCli([cli, job.sourcePath, '-o', out, '--mode', 'moonsec_v2'], job.args.timeout);
    return out;
  };

  let lastErr = null;
  for (const step of isV2 ? [tryV2, tryV3] : [tryV3, tryV2]) {
    try {
      const res = step();
      return finalizeStaticResult(job, res, 'MoonSec');
    } catch (e) {
      lastErr = e;
    }
  }
  throw lastErr || new Error('MoonSec devirtualization failed');
}

async function runIronbrew2(job) {
  const cli = path.join(OBFUSCATORS, 'ironbrew2', 'cli.js');
  const out = job.path('.ironbrew2.lua');
  runNodeCli([cli, job.sourcePath, '-o', out, '--mode', 'ironbrew2'], job.args.timeout);
  return finalizeStaticResult(job, out, 'IronBrew v2');
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
      env: { PYTHONPATH: mvDir },
    }
  );
  if (!r.error && r.status === 0 && fs.existsSync(out) && fs.statSync(out).size > 0) {
    return finalizeStaticResult(job, out, 'MoonVeil');
  }
  const detail = ((r.stderr || r.stdout || '') + '').trim().split('\n').pop() || `exit ${r.status}`;
  throw new Error(`MoonVeil static engine unsupported/failed (${detail})`);
}

async function runIronbrew1(job) {
  const { args } = job;
  const bridgePy = path.join(__dirname, 'devirt_bridge.py');
  let patched = null;
  try {
    const r = spawnSync(getPythonBin(), [bridgePy, 'ironbrew1-instrument', job.sourcePath], {
      env: { PYTHONPATH: CORE },
      maxBuffer: 64 * 1024 * 1024,
      timeout: 60000,
      windowsHide: true,
    });
    if (!r.error && r.status === 0 && r.stdout && r.stdout.length > 0) {
      patched = r.stdout.toString('latin1');
    } else {
      throw new Error((r.stderr ? r.stderr.toString('utf8') : '') || 'instrumentation failed');
    }
  } catch (e) {
    process.stderr.write(`[!] IronBrew1 VM instrumentation failed (${e.message}); falling back to behaviour trace\n`);
    return driver.runGeneric(job);
  }

  const cachePath = harness.loadP2dCache(job.input);
  const runner = new harness.Runner(job);
  const captureRt = fs.readFileSync(path.join(CORE, 'obfuscators', 'ironbrew1', 'capture.luau'), 'utf8');
  const cfg = {
    time_budget: args.budget,
    executor: args.executor,
    dump_strings: args.strings,
    plugin_rt: captureRt,
    spin: 24 + Math.floor(job.source.length / 10000),
  };
  if (args.inputText) cfg.input_text = args.inputText;
  if (args.noFold) cfg.fold = false;
  if (args.cfgJson) Object.assign(cfg, args.cfgJson);

  process.stderr.write(`[*] tracing & capturing IronBrew v1 protos for ${job.input}...\n`);
  const res = await runner.run(patched, cfg);
  runner.finish();
  if (!res.body) {
    throw new Error(res.err || 'IronBrew v1 trace failed without output');
  }

  let body = res.body;
  let dumpJson = null;
  const m = /\x00IBDUMP ([^\n]*)\n?/.exec(body);
  if (m) {
    dumpJson = m[1];
    body = body.slice(0, m.index) + body.slice(m.index + m[0].length);
  }
  body = harness.takeP2d(body);
  body = harness.p2dMiss(body, cachePath);
  body = harness.takeChunks(body).body;
  const [b2, strings] = trace.takeStrings(body);
  body = b2;
  if (strings !== null) job.write(job.path('.strings.txt'), strings);

  const traceText = trace.header(job.input) + body;
  const writeTrace = () => job.write(job.tracePath, tidy.tidy(traceText, { preamble: !args.keepPreamble }));

  if (!dumpJson) {
    writeTrace();
    job.resultType = 'trace';
    job.warnings.push('IronBrew v1 proto capture returned no dump; returning behaviour trace.');
    return job.tracePath;
  }

  const dumpPath = job.write(job.path('.ibdump.json'), dumpJson);
  const dpath = job.path('.devirt.luau');
  const statsDir = fs.mkdtempSync(path.join(os.tmpdir(), 'ib1-stats-'));
  const statsPath = path.join(statsDir, 'stats.json');
  const cfgPath = job.path('.ib1_cfg.json');
  try {
    fs.writeFileSync(
      cfgPath,
      JSON.stringify({ source_path: job.sourcePath, dump_path: dumpPath, dpath, stats_path: statsPath }),
      'utf8'
    );
    execFileSync(getPythonBin(), [bridgePy, 'ironbrew1-lift', cfgPath], {
      env: { PYTHONPATH: CORE },
      stdio: 'inherit',
    });
    if (fs.existsSync(statsPath)) {
      job.liftStats = JSON.parse(fs.readFileSync(statsPath, 'utf8'));
    }
    if (fs.existsSync(dpath) && fs.statSync(dpath).size > 0) {
      job.resultType = 'devirtualized';
      return dpath;
    }
  } catch (e) {
    process.stderr.write(`[!] IronBrew v1 lift failed (${e.message}); returning behaviour trace\n`);
    job.warnings.push(`IronBrew v1 devirtualization failed (${e.message}); returning behaviour trace.`);
  } finally {
    try { fs.unlinkSync(cfgPath); } catch {}
    fs.rmSync(statsDir, { recursive: true, force: true });
  }
  writeTrace();
  job.resultType = 'trace';
  return job.tracePath;
}

async function runLuraphV14(job) {
  const { args } = job;
  const bridgePy = path.join(__dirname, 'devirt_bridge.py');
  let patched = job.source;
  if (!args.noHooks) {
    const r = spawnSync(getPythonBin(), [bridgePy, 'patch-entries-v14', job.sourcePath], {
      env: { PYTHONPATH: CORE },
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
        env: { PYTHONPATH: CORE },
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

const STATIC_HANDLERS = {
  prometheus: runPrometheus,
  luaobfuscator: runLuaObfuscator,
  psu: runPsu,
  hercules: runHercules,
  goofyscator: runGoofyscator,
  moonsec: runMoonsec,
  ironbrew2: runIronbrew2,
  moonveil: runMoonveil,
};

async function runPlugin(pluginName, job) {
  if (job.args.noDevirt) {
    return driver.runGeneric(job);
  }
  if (pluginName === 'luraph_v14') {
    return runLuraphV14(job);
  }
  if (pluginName === 'ironbrew1') {
    return runIronbrew1(job);
  }
  const fn = STATIC_HANDLERS[pluginName];
  if (fn) {
    try {
      process.stderr.write(`[*] running ${job.obfuscator} deobfuscator on ${path.basename(job.input)}...\n`);
      return await fn(job);
    } catch (err) {
      const msg = err && err.message ? err.message : String(err);
      process.stderr.write(`[!] ${job.obfuscator} static engine failed (${msg}); falling back to behaviour trace\n`);
      job.warnings.push(`${job.obfuscator} static deobfuscation failed (${msg}); fell back to behaviour trace.`);
      return driver.runGeneric(job);
    }
  }
  return driver.runGeneric(job);
}

module.exports = { runPlugin };
