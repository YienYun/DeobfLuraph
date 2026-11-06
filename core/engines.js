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
const vmmap = require('./vmmap');

const ROOT = path.resolve(__dirname, '..');
const CORE = path.join(ROOT, 'core');

const V14_SPIN_CHECKS = 24;
const V14_MAX_TRACES = 2;

function getRunStatus(body) {
    const match = /^-- run status: (.*)$/m.exec(body || '');
    return match ? match[1].trim() : '';
}

function runWasAborted(body) {
    return /^aborted\b/i.test(getRunStatus(body));
}

function recordTraceStatus(job, body) {
    const status = getRunStatus(body);
    if (!status) return '';
    job.traceStatus = status;
    if (status !== 'finished') {
        job.warnings.push(`Trace did not finish normally: ${status}`);
    }
    return status;
}


function patchChunkV14(src, bridgePy) {
  const tmpdir = fs.mkdtempSync(path.join(os.tmpdir(), 'v14-chunk-'));
  const p = path.join(tmpdir, 'chunk.luau');
  try {
    fs.writeFileSync(p, src, 'latin1');
    const r = spawnSync(getPythonBin(), [bridgePy, 'patch-entries-v14', p], {
      env: pythonEnv({ PYTHONPATH: CORE }),
      maxBuffer: 64 * 1024 * 1024,
      timeout: 60000,
      windowsHide: true,
    });
    if (!r.error && r.status === 0 && r.stdout && r.stdout.length > 0) return r.stdout.toString('latin1');
    return src;
  } catch {
    return src;
  } finally {
    fs.rmSync(tmpdir, { recursive: true, force: true });
  }
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

    const mapperMatched = args.noHooks || patched !== job.source;
    if (!mapperMatched) {
        const note = 'the v14 mapper found no dispatch loop in the outer file: '
            + 'either a build outside v14.7-v14.9, or a carrier that delivers its '
            + 'payload through loadstring. Tracing to find out which';
        process.stderr.write(`[*] ${note}\n`);
        job.warnings.push(note);
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

    if (!args.noHooks) {
        patched = vmmap.patchSpin(patched);
        cfg.spin = V14_SPIN_CHECKS;
    }
    const chunks = {};
    const rawChunks = {};
    const collectChunks = found => {
        let added = 0;
        for (const [key, src] of found) {
            if (chunks[key]) continue;
            rawChunks[key] = src;
            chunks[key] = args.noHooks ? src : vmmap.patchSpin(patchChunkV14(src, bridgePy));
            added++;
        }
        return added;
    };
    process.stderr.write(`[*] tracing Luraph v14 ${job.input}...\n`);
    let res = await runner.run(patched, cfg, chunks, args.timeout);
    if (!res.body) {
        const stuck = /timed out|no reply|stalled|harness process exited/i.test(res.err || '');
        if (stuck && !cfg.spin) {
            process.stderr.write('[*] the run never answered (the script spins inside its own VM): '
                + 'replaying with the spin watchdog on\n');
            patched = vmmap.patchSpin(patched);
            cfg.spin = V14_SPIN_CHECKS;
            res = await runner.run(patched, cfg, {}, args.timeout);
        }
    }
    if (!res.body) {
        runner.finish();
        if (!mapperMatched) {
            throw new Error('no v14 dispatch loop matched in the outer file and the '
                + `${args.timeout}s behaviour trace produced nothing. This is either a build `
                + 'outside the v14.7-v14.9 range the mapper targets, or a carrier whose '
                + 'payload never arrived (it may need a live session). '
                + `Detail: ${res.err || 'the run returned no output'}`);
        }
        throw new Error(res.err || 'Luraph v14 trace failed without output');
    }

    let body = harness.takeP2d(res.body);
    for (let attempt = 2; attempt <= V14_MAX_TRACES; attempt++) {
        const previousRunAborted = runWasAborted(body);
        const { chunks: found, body: cleanBody } = harness.takeChunks(body);
        body = cleanBody;
        const added = collectChunks(found);
        if (!added) break;
        if (previousRunAborted) {
            process.stderr.write('[!] previous Luraph v14 trace was aborted; '
                + 'skipping the chunk-aware rerun and keeping captured chunks\n');
            break;
        }

        process.stderr.write(`[*] script loadstring'd ${added} new VM chunk(s); instrumenting and re-running\n`);
        const again = await runner.run(patched, cfg, chunks, args.timeout);
        if (!again.body) {
            process.stderr.write('[!] the re-run with the instrumented chunk produced nothing; '
                + 'keeping what the previous run recorded\n');
            break;
        }
        body = harness.takeP2d(again.body);
    }

    const finalChunks = harness.takeChunks(body);
    body = finalChunks.body;
    if (collectChunks(finalChunks.chunks)) {
        const warning = 'Additional VM chunks were found after the final allowed v14 trace run; the result may be incomplete.';
        process.stderr.write(`[!] ${warning}\n`);
        job.warnings.push(warning);
    }
    const runStatus = recordTraceStatus(job, body);
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
                    chunks,
                    run_text: runText,
                    run_status: runStatus,
                    ppath,
                    dpath,
                    stats_path: statsPath,
                    chunk_paths: Object.entries(rawChunks).map(([k, src]) =>
                        job.write(job.path(`.chunk_${k}.luau`), src, 'latin1')),
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
            try { fs.unlinkSync(cfgPath); } catch { }
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

const RUNNERS = {
    luraph_v14: runLuraphV14,
};

const NOT_SHIPPED = {
    luraph_v15: 'handled by core/driver.js',
    luarmor_client: 'analysed by core/luarmor.js',
    moonveil: 'MoonVeil (this build is Luraph-only)',
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
            + '(it ships Luraph v14/v15 and the Luarmor analyzer)');
    }
    if (job.args.noDevirt) {
        return driver.runGeneric(job);
    }
    process.stderr.write(`[*] running the ${pluginName} engine on ${path.basename(job.input)}...\n`);
    return fn(job);
}

module.exports = { runPlugin, NOT_SHIPPED };
