import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
CORE_DIR = os.path.join(HERE, "..", "core")
if CORE_DIR not in sys.path:
    sys.path.insert(0, CORE_DIR)

cmd = sys.argv[1]


def _strip_credit_headers(dpath):
    if not os.path.exists(dpath):
        return
    with open(dpath, "r", encoding="utf-8", errors="replace") as f:
        lines = f.readlines()
    clean = []
    skip_header = True
    for line in lines:
        stripped = line.strip()
        if skip_header and (
            stripped.startswith("-- Deobfuscated by") or
            stripped.startswith("-- Detected obfuscation") or
            stripped.startswith("-- Local names are inferred") or
            stripped.startswith("-- source:") or
            stripped.startswith("-- NOTE: reconstructed") or
            stripped.startswith("--       during the trace")
        ):
            continue
        if skip_header and stripped == "":
            continue
        skip_header = False
        clean.append(line)
    with open(dpath, "w", encoding="utf-8", newline="\n") as f:
        f.writelines(clean)


def _run_luraph_pipeline(config_file, v14=False):
    with open(config_file, "r", encoding="utf-8") as f:
        c = json.load(f)

    from obfuscators.base import Job
    if v14:
        from obfuscators.luraph_v14 import driver
    else:
        from obfuscators.luraph_v15 import driver
    import harness

    class DummyArgs:
        DEFAULTS = {
            # --cfg KEY=VALUE list consumed by harness.user_cfg (the node cfg
            # extras already travel inside c["cfg"], so this stays empty)
            "cfg": [],
            "keep_harness": False, "no_hooks": False, "no_devirt": False,
            "max_runs": 1, "raw": None, "input_text": None, "port": None,
        }

        def __init__(self, d):
            for k, v in d.items():
                setattr(self, k, v)

        def __getattr__(self, k):
            # the python driver reads attrs the node CLI never passes
            return DummyArgs.DEFAULTS.get(k, False)

    args = DummyArgs(c["args"])
    job = Job(c["input"], c["source"], args, c["trace_path"], c["debug"], c["obfuscator"])
    job.source_path = c["source_path"]
    job.trace_status = c.get("trace_status")
    job.credit_header = lambda: ""

    runner = harness.Runner(job)
    runner.luau = c["luau_exe"]

    profiler = None
    prof_path = os.environ.get("DEOB_PROFILE")
    if prof_path:
        import cProfile
        profiler = cProfile.Profile()

    if profiler:
        profiler.enable()
    stats = driver.lift(
        job,
        runner,
        c["patched"],
        c["cfg"],
        c.get("chunks", {}),
        c["run_text"],
        c["ppath"],
        c["dpath"],
        c.get("chunk_paths", []),
    )
    if profiler:
        profiler.disable()
        profiler.dump_stats(prof_path)
        sys.stderr.write("[*] cProfile stats written to %s\n" % prof_path)
    runner.finish()
    if stats is not None and c.get("stats_path"):
        with open(c["stats_path"], "w", encoding="utf-8", newline="\n") as f:
            json.dump(stats, f)

    dpath = c["dpath"]
    if stats is not None and os.path.exists(dpath):
        _strip_credit_headers(dpath)


if cmd == "patch-entries":
    # Preserve source bytes: Lua string literals in protected files need not
    # be UTF-8. AST locations and the original Python mapper use latin-1.
    source_path = sys.argv[2]
    with open(source_path, "rb") as f:
        source = f.read().decode("latin-1")
    from obfuscators.luraph_v15 import driver
    sys.stdout.buffer.write(driver.patch_entries(source, source_path).encode("latin-1"))

elif cmd == "patch-entries-v14":
    source_path = sys.argv[2]
    with open(source_path, "rb") as f:
        source = f.read().decode("latin-1")
    from obfuscators.luraph_v14 import driver
    sys.stdout.buffer.write(driver.patch_entries(source, source_path).encode("latin-1"))

elif cmd == "pipeline":
    _run_luraph_pipeline(sys.argv[2], v14=False)

elif cmd == "pipeline-v14":
    _run_luraph_pipeline(sys.argv[2], v14=True)

elif cmd == "ironbrew1-instrument":
    source_path = sys.argv[2]
    with open(source_path, "rb") as f:
        source = f.read().decode("latin-1")
    import backend
    from obfuscators.ironbrew1 import instrument
    patched, _ = backend.run_big_stack(instrument.instrument, source)
    sys.stdout.buffer.write(patched.encode("latin-1"))

elif cmd == "ironbrew1-lift":
    config_file = sys.argv[2]
    with open(config_file, "r", encoding="utf-8") as f:
        c = json.load(f)
    import backend
    from obfuscators.ironbrew1 import devirt
    with open(c["source_path"], "rb") as f:
        source = f.read().decode("latin-1")
    with open(c["dump_path"], "r", encoding="utf-8") as f:
        dump = json.load(f)
    text, prog = backend.run_big_stack(devirt.lift_program, source, dump)
    text = backend.run_big_stack(lambda: backend.finish_text(backend.polish(text)))
    with open(c["dpath"], "w", encoding="utf-8", newline="\n") as f:
        f.write(text.strip() + "\n")
    if c.get("stats_path"):
        st = dict(prog.stats)
        st["converged"] = True
        with open(c["stats_path"], "w", encoding="utf-8", newline="\n") as f:
            json.dump(st, f)

else:
    sys.exit("Unknown command: %s" % cmd)
