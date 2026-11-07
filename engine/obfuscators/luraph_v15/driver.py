import json
import os
import re
import sys
import time

import carrier
from carrier import payload_note
import harness
import traceout as trace

HERE = os.path.dirname(os.path.abspath(__file__))
MAX_RERUNS = 12
SPIN_CHECKS = 24    

def patch_spin(src):
    """Spin watchdog (envlog's --cfg spin): every VM dispatch loop head counts
    steps in __SPIN.n and calls __SPIN.f() every __SPIN.step of them. Table
    operations only, plus that rare call (no locals: see patch_entries)."""
    inj = "__SPIN.n=__SPIN.n+1;if __SPIN.n>=__SPIN.step then __SPIN.f()end;"
    out = re.sub(
        r"while true do (?:[A-Za-z_][A-Za-z0-9_]*\[\d+\]=[A-Za-z_][A-Za-z0-9_]*;\s*)?(?:local )?[A-Za-z_][A-Za-z0-9_]*(?:,[A-Za-z_][A-Za-z0-9_]*)*=(?:[A-Za-z_][A-Za-z0-9_]*,)?\(?[A-Za-z_][A-Za-z0-9_]*\[[A-Za-z_][A-Za-z0-9_]*\]\)?;?(?=\s*(?:if|local)\b)",
        lambda m: (m.group(0) if m.group(0).endswith(";") else m.group(0) + ";") + inj,
        src,
    )
    out = re.sub(
        r"repeat (?:[A-Za-z_][A-Za-z0-9_]*\[\d+\]=[A-Za-z_][A-Za-z0-9_]*;\s*)?(?:local )?[A-Za-z_][A-Za-z0-9_]*(?:,[A-Za-z_][A-Za-z0-9_]*)*=(?:[A-Za-z_][A-Za-z0-9_]*,)?\(?[A-Za-z_][A-Za-z0-9_]*\[[A-Za-z_][A-Za-z0-9_]*\]\)?;?(?=\s*(?:if|local)\b)",
        lambda m: (m.group(0) if m.group(0).endswith(";") else m.group(0) + ";") + inj,
        out,
    )
    return out

def patch_chunk(src, tmpdir):
    """Instrument a loadstring'd VM chunk like the main script."""
    path = os.path.join(tmpdir, "_chunk_%s.luau" % harness.chunk_key(src))
    with open(path, "w", encoding="latin-1", newline="") as f:
        f.write(src)
    try:
        return patch_entries(src, path)
    except Exception as e:  
        print("[!] could not instrument chunk (%s)" % e, file=sys.stderr)
        return src
    finally:
        os.remove(path)

def patch_entries(source, path):
    """Give every VM closure an entry hook. It only uses table operations (no
    calls, no locals), so the stack looks exactly as it would without it: it numbers
    protos in first-entry order, logs recent entries and returns early for the
    protos listed in __SKIPP."""
    from obfuscators.luraph_v15 import vmmap
    root = vmmap.load_ast(path)
    lines = source.split("\n")
    edits = []
    for l1, c1, pv in vmmap.closure_entries(root):

        k = "(%s or __PID)" % pv
        edits.append((l1, c1, ("if not __PID[{k}] then __PID.n=__PID.n+1;__PID[{k}]=__PID.n;end;"
                               "if __PARG1 and not __PARG1[__PID[{k}]] and type((...))==\"number\" then __PARG1[__PID[{k}]]=(...) end;"
                               "__ENT.n=__ENT.n+1;__ENT[__ENT.n%64]=__PID[{k}];__PLAST[__PID[{k}]]=__ENT.n;"
                               "if __SKIPP[__PID[{k}]] then return end;").format(k=k)))

    tag = harness.chunk_key(source)
    for info in vmmap.maker_info(root):
        (l2, c2), var, pv = info["at"], info["var"], info["proto"]
        c3 = info.get("curried3")
        if c3:
            f3, f2, f1 = c3["f3"], c3["f2"], c3.get("f1")
            f3_l0, f3_c0, _, _ = vmmap.loc(f3["body"]["body"][0])
            f3_params = list(dict.fromkeys(
                a["name"] for a in (f3.get("args") or []) if a.get("name") and a["name"] != "..."
            ))
            f3_cap = ",".join("%s=%s" % (nm, nm) for nm in f3_params)
            head_code = ("local __pv={%s};if __PA and __PA.n<8192 then __PA.n=__PA.n+1;"
                         "__PA[__pv]={__seq=__PA.n,__maker=\"%s@%d,%d\",%s} end;"
                         % (f3_cap, tag, l2, c2, f3_cap))
            edits.append((f3_l0, f3_c0, head_code))
            if c3.get("kind") == "named":
                r1_l, r1_c, _, _ = vmmap.loc(c3["retStmt"])
                r2_l, r2_c, _, _ = vmmap.loc(c3["f2Ret"])
                u_name, z_name = c3["uName"], c3["zName"]
                edits.append((r1_l, r1_c, "__PF[%s]=__pv;__PK[__pv]=%s;" % (u_name, u_name)))
                edits.append((r2_l, r2_c, "__PF[%s]=__pv;__PK[__pv]=%s;" % (z_name, z_name)))
            else:
                fn_l1, fn_c1, fn_l2, fn_c2 = vmmap.loc(f2)
                edits.append((fn_l1, fn_c1, "(function(__mk)__PF[__mk]=__pv;__PK[__pv]=__mk;return __mk end)("))
                edits.append((fn_l2, fn_c2, ")"))
                if f1:
                    f1_l1, f1_c1, f1_l2, f1_c2 = vmmap.loc(f1)
                    edits.append((f1_l1, f1_c1, "(function(__fn)__PF[__fn]=__pv;return __fn end)("))
                    edits.append((f1_l2, f1_c2, ")"))
            continue
        code = " __PF[%s]=%s " % (var, info.get("pf_key", pv))

        cap = "".join("__PA[%s].%s=%s;" % (pv, nm, nm) for nm in info["captures"])

        code += ("if __PA and not __PA[%s] then __PA[%s]={};__PA.n=__PA.n+1;__PA[%s].__seq=__PA.n;"
                 "__PA[%s].__maker=\"%s@%d,%d\";__PK[%s]=%s;%s end "
                 % (pv, pv, pv, pv, tag, l2, c2, info.get("pf_key", pv), var, cap))
        edits.append((l2, c2, code))
    for pm in vmmap.plain_curried_makers(root):
        (l2, c2), f3, f2 = pm["at"], pm["f3"], pm["f2"]
        ret_st = f3["body"]["body"][0]
        r_l1, r_c1, _, _ = vmmap.loc(ret_st)
        fn_l1, fn_c1, fn_l2, fn_c2 = vmmap.loc(f2)
        f3_params = list(dict.fromkeys(
            a["name"] for a in (f3.get("args") or []) if a.get("name") and a["name"] != "..."
        ))
        f3_cap = ",".join("%s=%s" % (nm, nm) for nm in f3_params)
        prefix_code = ("local __pv={%s};local __mk=" % f3_cap)
        suffix_code = (";if __PA and __PA.n<8192 then __PA.n=__PA.n+1;"
                       "__PA[__pv]={__seq=__PA.n,__maker=\"plain:%s@%d,%d\",%s};"
                       "__PF[__mk]=__pv;__PK[__pv]=__mk end;return __mk"
                       % (tag, l2, c2, f3_cap))
        if r_l1 == fn_l1:
            lines_pre = lines[r_l1][r_c1:fn_c1]
            if lines_pre.strip() == "return":
                edits.append((r_l1, r_c1, prefix_code + "--[["))
                edits.append((fn_l1, fn_c1, "]]"))
                edits.append((fn_l2, fn_c2, suffix_code))
    for l, c, code in sorted(edits, reverse=True):
        lines[l] = lines[l][:c] + code + lines[l][c:]
    return "\n".join(lines)

def _req_sort_key(r):
    m = re.match(r"^!?(\d+)[,~]", r)
    return (0 if not r.startswith("!") else 1, int(m.group(1)) if m else 10**9, r)

def _served_from_cache(cfg, src):
    """True when this chunk is a body --http-cache handed the script.

    The body travels Python str -> utf-8 bytes -> latin-1 view inside the
    harness, which is exactly what the runtime hex-encodes back to us, so the
    two are comparable once the encoding is undone. Length is checked too: a
    415 KB library must never be mistaken for a 415 KB chunk of the file.
    """
    for entry in (cfg.get("http_map") or {}).values():
        if not isinstance(entry, dict):
            continue
        body = entry.get("body")
        if not isinstance(body, str):
            continue
        view = body.encode("utf-8", "surrogatepass").decode("latin-1")
        if len(view) == len(src) and view == src:
            return True
        # The driver hands the runtime an instrumented copy of every chunk it
        # saw (spin counters in the dispatch heads), so a served body comes back
        # with the same first and last 200 bytes and a different middle.
        head, tail = 200, 200
        if len(view) > head + tail and len(src) > head + tail \
                and view[:head] == src[:head] and view[-tail:] == src[-tail:]:
            return True
    return False


def write_dump(ppath, text, exec_rec_on, seen=None):
    """Write the proto dump a round works from, and refresh its coverage
    sidecar from every run seen so far.

    The dump itself is written byte for byte: re-serialising it turns
    0.94743997235392186 into 0.9474399723539219, and a changed constant changes
    the lift.  The union lives in `<dump>.union.json`, which `dump.Dump` reads
    and applies on top of the dump's own per-run numbers.
    """
    with open(ppath, "w", encoding="utf-8", newline="\n") as f:
        f.write(text)
    if not exec_rec_on or seen is None:
        return
    if not seen:
        seen.append(text)
    elif text not in seen:
        seen.append(text)
    from obfuscators.luraph_v15 import dump as dump_mod
    union, info, scan = dump_mod.union_exec_runs(seen, base_text=text)
    if not union and not (scan["scanned"] or scan["restored"]):
        return
    flags = {str(t): 1 for t in scan["scanned"]}
    flags.update({str(t): 0 for t in scan["restored"]})
    with open(ppath + ".union.json", "w", encoding="utf-8", newline="\n") as f:
        json.dump({"exec": {str(t): dump_mod.exec_str(pcs) for t, pcs in union.items()},
                   "scan": flags,
                   "meta": info}, f)
    print("[*]   [execrec] union over %d run(s): covered %d->%d, cells %s -> %d"
          " (scanned %d, restored %d)"
          % (info.get("runs", 0), info.get("covered_first", 0),
             info.get("covered_union", 0),
             ",".join(str(n) for n in (info.get("per_run") or [])),
             info.get("pcs_union", 0),
             info.get("scan_scanned", 0), info.get("scan_restored", 0)),
          file=sys.stderr)


def emit_payload_source(job, dpath, chunk_paths, why=None, require_script=False):
    """Write the loadstring'd chunk, printed as Luau, as the result.  A Luraph
    build can keep the script readable and virtualize only the wrapper;
    printing the payload is then the faithful output (names aside) and the only
    route that reaches the code the VM never carries.  -> stats, or None."""
    from obfuscators.luraph_v15 import devirt
    if os.environ.get("DEVIRT_CHUNKDBG"):
        for path in chunk_paths or ():
            try:
                with open(path, encoding="latin-1") as f:
                    head = f.read(300)
                size = os.path.getsize(path)
            except OSError:
                head, size = "", -1
            print("[dbg] payload candidate %s size=%d head=%r" % (os.path.basename(str(path)), size,
                                                                  head[:90]), file=sys.stderr)
    found = payload_source(chunk_paths, require_script=require_script)
    if not found:
        return None
    text, nfun = found[0], found[1]
    note = found[2] if len(found) > 2 else ""
    carried = found[3] if len(found) > 3 else text
    print("[*] payload: printing the loadstring'd chunk as the script (%d lines, %d functions)%s%s"
          % (text.count("\n") + 1, nfun, (" -- " + note) if note else "",
             (" \u2014 " + why) if why else ""), file=sys.stderr)
    try:
        job.write(job.path(".payload.luau"), carried, "latin-1")
    except OSError:
        pass
    import backend
    text = backend.polish(text)
    header = job.credit_header()
    job.write(dpath, ((header + "\n") if header else "") + devirt.finish_text(text) + "\n")
    return dict(functions=nfun, walked=0, errors=0, fallbacks=0,
                payload_source=text.count("\n") + 1)


def devirtualize(job, ppath, dpath, cfg, rerun, chunk_paths=(), live=None, exec_seen=None,
                 payload_paths=None):
    """Lift the captured protos; constants that only Luraph's lazy decoder can
    produce (code that never ran) are requested from further runs. With a
    live harness (`live()` -> fetch function, while the long-lived harness
    made the current dump) the walks ask for them right away (a chain of
    constants, each needed to find the next, then takes one round instead
    of one round per link)."""
    exec_rec_on = bool(os.environ.get("DEVIRT_EXECREC") or getattr(job.args, "exec_rec", False))
    from obfuscators.luraph_v15 import devirt
    import deadline
    if not os.environ.get("DEVIRT_PREFER_VM"):
        out_stats = emit_payload_source(job, dpath,
                                        chunk_paths if payload_paths is None else payload_paths,
                                        "the loader carries the script as source", require_script=True)
        if out_stats is not None:
            return out_stats
    devirt.EXEC_REC = exec_rec_on
    args = job.args
    try:
        import ast_polish
        ast_polish.TRIMMED = []
        ast_polish.TRIM_PATH = (dpath[:-4] if dpath.endswith(".lua") else dpath) + ".trimmed.lua"
        if os.path.exists(ast_polish.TRIM_PATH):
            os.remove(ast_polish.TRIM_PATH)
    except Exception:
        pass
    requested = set()
    ordered_reqs = []
    last_bufs = ""
    text = None
    rounds = args.devirt_rounds

    quick = not os.environ.get("DEVIRT_FULL_ROUNDS")
    cache = devirt.WalkCache()
    t0 = time.time()
    last_errors = None
    last_full_stats = None
    converged = False
    pending_constants = 0
    no_new_full_streak = 0
    for rnd in range(1, rounds + 1):
        t1 = time.time()

        if quick and (last_errors == 0 or (rnd == 1 and (live and live()) is not None)):
            full = True
        else:
            full = not quick

        if not full and quick:
            stats, reqs, bufs = devirt.run_big_stack(devirt.collect_requests, job.source_path, ppath, chunk_paths, cache,
                                                     live and live())
            last_errors = stats.get("errors", 0)
            new = reqs - requested
            print("[*] devirt round %d: %d functions (%d walked), %d unlifted blocks, %d new constant requests%s "
                  "(%.1fs)" % (rnd, stats["functions"], stats["walked"], stats["errors"], len(new),
                               " (%d decoded live)" % stats["fetched"] if stats.get("fetched") else "",
                               time.time() - t1), file=sys.stderr)
            if (not new and (not (requested | reqs) or devirt.same_patches(last_bufs, bufs))) or rnd == rounds:
                full = True
        if full:
            print("[*] devirtualizing (round %d)..." % rnd, file=sys.stderr)
            t1 = time.time()
            try:
                text, stats, reqs, bufs = devirt.run_big_stack(devirt.lift_program, job.source_path, ppath,
                                                               chunk_paths, live and live())
            except (devirt.WalkLost, deadline.LiftTimeout) as ex:
                out_stats = emit_payload_source(job, dpath,
                                                chunk_paths if payload_paths is None else payload_paths,
                                                "the walk lost the script (%s)" % ex)
                if out_stats is not None:
                    return out_stats
                raise
            new = reqs - requested
            last_full_stats = dict(stats)
            pending_constants = len(new)
            no_new_full_streak = (no_new_full_streak + 1) if not new else 0
            converged = not new and (not (requested | reqs) or devirt.same_patches(last_bufs, bufs) or no_new_full_streak >= 2)
            print("[*]   %d functions, %d unlifted blocks, %d unstructured jumps, %d new constant requests%s (%.1fs)"
                  % (stats["functions"], stats["errors"], stats["fallbacks"], len(new),
                     " (%d dead guard branches dropped)" % stats["guards"] if stats.get("guards") else "",
                     time.time() - t1), file=sys.stderr)
            print("[*]   frame_propagation: bound=%d residual_unknown=%d unknown_callee=%d"
                  % (stats.get("frame_bound", 0), stats.get("residual_unknown", 0),
                     stats.get("unknown_callee", 0)), file=sys.stderr)
            if exec_rec_on:
                ru_e, ru_u = stats.get("ru_exec", 0), stats.get("ru_unexec", 0)
                print("[*]   residual_unknown_split: ru_exec=%d ru_unexec=%d"
                      " (of %d unwritten-register reads in %d protos lifted with coverage)"
                      % (ru_e, ru_u, ru_e + ru_u, stats.get("exec_protos", 0)), file=sys.stderr)
            if stats.get("walk_truncated"):
                print("[*]   %d proto(s) were cut at the walk budget (%ds each): their"
                      " statements past the cut are not in the output"
                      % (stats["walk_truncated"], int(devirt.WALK_SECONDS)), file=sys.stderr)
            if stats.get("exec_protos") or stats.get("exec_covered"):
                win = stats.get("exec_window") or 1
                # pcs_visited sums one distinct-pc set per lifted proto, so it is a
                # count, not a fraction of one window: printed as a percentage it
                # read 1276% on a hub whose protos share a pc space.
                print("[*]   [execrec] runs=%d covered=%d scrambled_excluded=%d no_arrays=%d"
                      " pcs_visited=%d (per-proto windows sum to %d) annotated=%d"
                      % (stats.get("exec_runs", 0), stats.get("exec_covered", 0),
                         stats.get("exec_scrambled", 0), stats.get("exec_no_arrays", 0),
                         stats.get("exec_pcs", 0), win,
                         stats.get("walk_trim_unexecuted", 0)), file=sys.stderr)
                print("[*]   [execrec] arrays: scanned=%d restored=%d settled_verdicts=%d"
                      % (stats.get("exec_arrays_scanned", 0),
                         stats.get("exec_arrays_restored", 0),
                         stats.get("poison_settled", 0)), file=sys.stderr)
            seen = []
            for pc, mode, total, rec, hit, verdict in stats.get("poison_sites") or []:
                if (pc, mode) in [(x[0], x[1]) for x in seen]:
                    continue
                seen.append((pc, mode, total, rec, hit, verdict))
            for pc, mode, total, rec, hit, verdict in seen:
                print("[*]   poison_pc_covered=%s (pc=%s, mode=%s, %d/%d arrays the"
                      " instruction reads carry coverage, %d decoded there)"
                      % (verdict, pc, mode, rec, total, hit), file=sys.stderr)
            if converged or rnd == rounds:
                break
            if quick:
                print("[*]   the full lift needs more constants: continuing with full lifts", file=sys.stderr)
                quick = False
        new_batch = sorted(reqs - requested, key=_req_sort_key)
        ordered_reqs.extend(new_batch)
        requested |= reqs
        last_bufs = bufs
        c = dict(cfg)
        c["force_req"] = ";".join(ordered_reqs)

        c["force_buf"] = bufs
        body, err = rerun(c)
        if body is None:
            print("[!] constant request run failed: " + err[-500:], file=sys.stderr)
            break
        m = re.search(re.escape(harness.mark("PROTOS ")) + r"([^\n]*)\n", body)
        if not m or m.group(1).startswith("error:"):
            print("[!] constant request run gave no protos", file=sys.stderr)
            break
        # The dump a round works from is replaced here, but its coverage does not
        # join the union: a round's dump carries whatever the run happened to
        # decode with the constants known so far, so folding it in made the union
        # -- and every trim decision and disclosure count that reads it -- depend
        # on how many rounds the pipeline got through. The union is the recorded
        # runs, and only them.
        write_dump(ppath, m.group(1), exec_rec_on, None)
    header = job.credit_header()
    prefix = (header + "\n") if header else ""
    marks = last_full_stats.get("trim_marks") or []
    n_marks, n_mark_pcs = len(marks), sum(len(pcs) for _, pcs in marks)
    suffix = ""
    if marks:
        # The counts live in the stats, not in the file. A lift round's walk ends
        # where its own coverage runs ended, and two runs that print byte-identical
        # code can report 232 or 259 trimmed functions -- putting that number in the
        # output made the file itself unstable for a fact about the run.
        suffix = ("\n-- devirt: the recorded run did not execute every pc in some of these functions;"
                  " where it did not, what they decode is the walk's value, not the program's\n")
    if text is None:
        sys.exit("[!] no devirtualized output was produced: the constant-request run failed "
                 "before the first full lift (see the error above); re-run with "
                 "DEVIRT_FULL_ROUNDS=1 to lift the first round without extra constant runs")
    job.write(dpath, prefix + devirt.finish_text(text) + "\n" + suffix)
    out_stats = dict(last_full_stats, converged=converged, pending_constant_requests=pending_constants,
                     trim_functions=n_marks, trim_pcs=n_mark_pcs)
    states = getattr(job, "luarmor_states", None)
    if states:
        out_stats["luarmor_states"] = states
    run_status = getattr(job, "run_status", None)
    if run_status and not run_status.endswith("finished"):
        out_stats["run_status"] = run_status
    return out_stats

def run(job):
    """The whole Luraph pipeline; returns the result file's path."""
    args = job.args
    devirt_on = not args.no_devirt
    source = job.source
    try:
        patched = source if args.no_hooks else patch_entries(source, job.source_path)
    except SyntaxError as e:
        sys.exit("[!] the input is %s: the file is damaged (truncated, or mangled by a paste/upload); "
                 "nothing to run" % e)
    cache_path = harness.load_p2d_cache(job.input, args.studio)
    runner = harness.Runner(job)
    bridge = runner.bridge
    exec_rec_on = bool(os.environ.get("DEVIRT_EXECREC") or getattr(args, "exec_rec", False))

    skip = []

    spin = not os.environ.get("DEOB_SPIN_LATE")
    if spin:
        patched = patch_spin(patched)
    chunks = {}
    raw_chunks = {}
    harness.EXTERNAL_CHUNKS.clear()     
    body = None
    trapped = None      
    cfg = None
    for attempt in range(1, args.max_runs + 1):

        cfg = {"time_budget": args.budget, "dump_strings": args.strings, "executor": args.executor,
               "skip_protos": skip,
               "loop_fuel": getattr(args, "loop_fuel", None) or 65536,
               "spin_fuel": getattr(args, "spin_fuel", None) or 64}
        if args.input_text is not None:
            cfg["input_text"] = args.input_text
        if args.no_fold:
            cfg["fold"] = False
        if devirt_on:
            cfg["devirt"] = True
        if exec_rec_on:
            cfg["exec_rec"] = True
        harness.user_cfg(args, cfg)
        if spin:
            cfg["spin"] = SPIN_CHECKS
        print("[*] tracing %s (run %d)..." % (job.input, attempt), file=sys.stderr)
        body, err = runner.run(patched, cfg, chunks)
        if body is None and not spin and err.startswith("timed out") and not bridge:

            print("[*] the script never finished; re-running with a spin watchdog", file=sys.stderr)
            spin = True
            patched = patch_spin(patched)
            chunks = {k: patch_spin(v) for k, v in chunks.items()}
            cfg["spin"] = SPIN_CHECKS
            body, err = runner.run(patched, cfg, chunks)
        if body is None:
            harness.save_raw(args.raw)
            runner.finish()
            sys.exit("[!] " + err)
        body = harness.take_p2d(body, cache_path, bridge is not None)
        found, body = harness.take_chunks(body)
        added = 0
        for key, src in found:
            if key not in chunks and args.no_hooks:
                chunks[key] = src
            elif key not in chunks:
                raw_chunks[key] = src
                chunks[key] = patch_chunk(src, job.outdir)
                if spin:
                    chunks[key] = patch_spin(chunks[key])
                added += 1
        if added:
            print("[*] script loadstring'd %d new VM chunk(s); instrumenting and re-running" % added, file=sys.stderr)
            continue
        trig = re.search(re.escape(harness.mark("TRIGGER ")) + r"(\d+)", body)
        if trapped is not None and trace.stmt_count(body) < trace.stmt_count(trapped[0]):

            print("[*] disabling function #%d made the script stop earlier: it is the script's own "
                  "crash check; keeping run %d" % (skip[-1], attempt - 1), file=sys.stderr)
            body, harness.LAST_RAW[0] = trapped
            skip.pop()
            break
        if not trig:
            break
        trapped = (body, harness.LAST_RAW[0])
        pid = int(trig.group(1))
        if pid in skip:
            print("[!] anti-tamper trigger %d fired again; giving up on reruns" % pid, file=sys.stderr)
            break
        print("[*] anti-tamper trap reached through function #%d; disabling it and re-running" % pid,
              file=sys.stderr)
        skip.append(pid)

    run_text = harness.trace_text(body)     
    body = harness.p2d_miss(body, cache_path)
    if not devirt_on:
        runner.finish()
    harness.save_raw(args.raw)
    body = re.sub(re.escape(harness.mark("TRIGGER ")) + r"\d+\n?", "", body)
    protos_json, body = trace.take_line(body, "PROTOS")
    force, body = trace.take_line(body, "FORCE")
    if force is not None and devirt_on:
        print("[*] constants decoded on request: " + force, file=sys.stderr)
    unscrambled, body = trace.take_line(body, "UNSCRAMBLED")
    if unscrambled is not None and devirt_on:
        print("[*] %s function(s) scrambled by the script's LPH_CRASH(): dumped as they were "
              "when first created" % unscrambled, file=sys.stderr)
    body, strings = trace.take_strings(body)

    notes = ["anti-tamper trap functions disabled: %s" % ", ".join("#%d" % p for p in skip)] if skip else []
    text = trace.header(job.input, notes) + body

    def write_trace():
        job.write(job.trace_path, trace.render(text, args))

    if not (devirt_on and not job.debug):
        write_trace()
    if strings is not None:
        job.write(job.path(".strings.txt"), strings)
    first = (body.splitlines() or [""])[0]
    job.run_status = first.lstrip("- ").strip() if first else ""
    dpath = job.path(".devirt.luau")
    if protos_json is not None:
        ppath = job.path(".protos.json")
        if protos_json.startswith("error:"):
            print("[!] proto capture failed: " + protos_json, file=sys.stderr)
        else:
            job.write(ppath, protos_json)
            if devirt_on:

                from_cache = [k for k, src in raw_chunks.items()
                              if k in harness.EXTERNAL_CHUNKS or _served_from_cache(cfg, src)]
                if os.environ.get("DEVIRT_CHUNKDBG"):
                    for k, src in raw_chunks.items():
                        print("[dbg] chunk %s len=%d head=%r" % (k, len(src), src[:32]), file=sys.stderr)
                    for url, entry in (cfg.get("http_map") or {}).items():
                        b = entry.get("body") if isinstance(entry, dict) else None
                        print("[dbg] cache %s len=%s head=%r" % (url[-30:], len(b) if isinstance(b, str) else None,
                              (b[:32] if isinstance(b, str) else None)), file=sys.stderr)
                if from_cache:
                    # A body we handed the script from --http-cache is the
                    # library it fetched, not something the file carried: it is
                    # instrumented like any chunk (the nested VM has to run) but
                    # it is never printed as *the* script the loader carries.
                    print("[*] http cache: %d chunk(s) come from the cache; they run and are "
                          "instrumented, but they are not the payload" % len(from_cache),
                          file=sys.stderr)
                chunk_paths = [job.write(job.path(".chunk_%s.luau" % key), src, encoding="latin-1")
                               for key, src in raw_chunks.items()]
                payload_paths = [job.write(job.path(".chunk_%s.luau" % key), src, encoding="latin-1")
                                 for key, src in raw_chunks.items() if key not in from_cache]
                lift(job, runner, patched, cfg, chunks, run_text, ppath, dpath, chunk_paths,
                     payload_paths)
    runner.finish()
    trace.status_line(body)
    if devirt_on and os.path.exists(dpath):

        with open(dpath, encoding="utf-8", errors="replace") as f:
            lifted = f.read()
        nil_calls = lifted.count("(nil)(")
        if nil_calls < 50 or nil_calls * 100 < lifted.count("\n"):
            return dpath
        print("[!] the devirtualized output is broken (%d calls of nil); writing the behaviour trace "
              "instead" % nil_calls, file=sys.stderr)
        if not job.debug:
            os.remove(dpath)
        write_trace()
        return job.trace_path
    if devirt_on:
        print("[!] devirtualization produced no output; writing the behaviour trace instead", file=sys.stderr)
        if not os.path.exists(job.trace_path):
            write_trace()
    return job.trace_path

def _keyname(k):
    if not isinstance(k, dict):
        return None
    v = k.get("value")
    if isinstance(v, bytes):
        return v.decode("latin-1")
    if v is not None:
        return str(v)
    return k.get("name")


SCRIPT_API = ("GetService", "GetChildren", "GetDescendants", "FindFirstChild", "CreateWindow",
              "CreateSection", "HttpGet", "Window", "Tab", "Section", "Notify", "IsA",
              "GetPlayerFromCharacter", "Destroy", "Clone")
SCRIPT_GLOBALS = ("getgenv", "warn", "Instance", "writefile", "makefolder", "readfile", "gethui")


def _script_score(node):
    """How much of a function reads like the script itself, not like a VM."""
    from obfuscators.luraph_v15.vm_model import iter_nodes
    score = 0
    for n in iter_nodes(node):
        t = n.get("type")
        if t == "AstExprIndexName" and n.get("index") in SCRIPT_API:
            score += 1
        elif t == "AstExprGlobal" and n.get("name") in SCRIPT_GLOBALS:
            score += 1
    return score


def _wrapper_depth(fn):
    """How many `return function` levels stand between the field and the script
    body: the loader calls them one by one."""
    d = 0
    node = fn
    while isinstance(node, dict) and node.get("type") == "AstExprFunction":
        d += 1
        body = (node.get("body") or {}).get("body") or []
        if len(body) == 1 and body[0].get("type") == "AstStatReturn" \
                and len(body[0].get("list") or []) == 1 \
                and body[0]["list"][0].get("type") == "AstExprFunction":
            node = body[0]["list"][0]
        else:
            break
    return d


def _library_urls(path):
    """The library URLs the chunk itself carries: the loader fetches one of them
    at run time and hands the result to the script.  Discord/invite links and
    plain asset URLs are not libraries."""
    try:
        with open(path, encoding="latin-1") as f:
            raw = f.read()
    except OSError:
        return []
    urls = []
    for m in re.finditer(r"https://raw\.githubusercontent\.com/[^\s\"'\\]+", raw):
        u = m.group(0)
        low = u.lower()
        if "discord" in low or u in urls:
            continue
        if "chilli" in low or "library" in low or "lib" in low:
            urls.append(u)
    return urls[:3]


def payload_source(chunk_paths, require_script=False):
    """The script the loader runs, as Luau text.

    A Luraph-style protector can keep the script itself as plain Lua source and
    put it in one field of the table it returns; the other fields are its
    interpreter, which the script does not need in order to be read.  Printing
    that field gives the script's own logic (services, UI, flow) instead of the
    machine around it.  A chunk that is not shaped that way is printed whole.
    -> (text, functions, note) or None when no chunk parses as source."""
    import luauast as LA
    from obfuscators.luraph_v15 import vmmap
    from obfuscators.luraph_v15.vm_model import iter_nodes
    best = None
    for path in chunk_paths or ():
        try:
            root = vmmap.load_ast(path)
        except Exception:
            continue
        whole = LA.Printer("\t")
        for st in root["body"]:
            whole.stat(st, 0)
        nfun = sum(1 for n in iter_nodes(root) if n.get("type") == "AstExprFunction")
        text, note = "\n".join(whole.lines), ""
        carried = text
        body = root.get("body") or []
        field_fn, nfields, runner_up, top_score = None, 0, (0, None), 0
        if len(body) == 1 and body[0].get("type") == "AstStatReturn" \
                and len(body[0].get("list") or []) == 1:
            call = body[0]["list"][0]
            if call.get("type") == "AstExprCall" and (call.get("func") or {}).get("type") == "AstExprIndexName":
                callee = call["func"]["expr"]
                if (callee or {}).get("type") == "AstExprCall" \
                        and (callee.get("func") or {}).get("type") == "AstExprGlobal" \
                        and (callee["func"].get("global") or callee["func"].get("name")) == "setmetatable":
                    tbl = next((a for a in callee.get("args") or []
                                if a.get("type") == "AstExprTable"), None)
                    if tbl is not None:
                        items = [it for it in tbl.get("items") or []
                                 if (it.get("value") or {}).get("type") == "AstExprFunction"]
                        nfields = len(items)
                        scored = sorted(((_script_score(it["value"]), i, it) for i, it in enumerate(items)),
                                        key=lambda x: -x[0])
                        if os.environ.get("DEVIRT_DEBUG"):
                            for sc, i, it in scored[:4]:
                                n = sum(1 for _ in iter_nodes(it["value"]))
                                print("[carrier] score=%d key=%r nodes=%d" % (sc, _keyname(it.get("key")), n),
                                      file=sys.stderr)
                        top = scored[0] if scored else None
                        second = scored[1][0] if len(scored) > 1 else 0
                        if top is not None and top[0] >= 40 and top[0] >= 3 * max(second, 1):
                            field_fn = top[2]
                            top_score = top[0]
                            runner_up = (second, _keyname(scored[1][2].get("key")) if len(scored) > 1 else None)
        if field_fn is not None:
            fn = field_fn["value"]
            pr = LA.Printer("\t")
            pr.stat({"type": "AstStatReturn", "list": [fn]}, 0)
            depth = _wrapper_depth(fn)
            name = _keyname(field_fn.get("key")) or "?"
            lines = list(pr.lines)
            head = lines[0]
            if head.startswith("return "):
                head = head[len("return "):]
            lines[0] = "local payload = " + head
            urls = _library_urls(path)
            out = ["-- The script the loader runs, printed from the source the loader carries:"
                   " field %r of %d in its table." % (name, nfields),
                   "-- It is plain Luau, not virtualized code, so it is printed rather than lifted.",
                   "-- Of the %d function fields this one is the only one that reads like a script"
                   " (%d against %d for the next, field %r)." % (nfields, top_score, runner_up[0], runner_up[1]),
                   "-- The loader calls this with the hub's library object (a table with Window / Tab /"
                   " Notify); the block below loads the library the script itself points at."]
            cands = list(urls)
            for u in urls:
                base, _, tail = u.rpartition("/")
                alt = base + "/Chilli%20Library"
                if "chilli" in u.lower() and alt not in cands:
                    cands.append(alt)
            out += ["-- The loader hands this script the hub's UI library.  Fetch it the way the hub does;",
                    "-- an object already in getgenv().ChilliLibrary wins, so a run inside the full hub is",
                    "-- unaffected.",
                    "local function hubLibrary()",
                    "\tlocal urls = {%s}" % ", ".join('"%s"' % u for u in cands),
                    "\tfor _, url in ipairs(urls) do",
                    "\t\tlocal ok, chunk = pcall(function() return loadstring(game:HttpGet(url)) end)",
                    "\t\tif ok and type(chunk) == \"function\" then",
                    "\t\t\tlocal ok2, lib = pcall(chunk)",
                    "\t\t\t-- the library is either the chunk's result or a bootstrap that takes a key",
                    "\t\t\tif ok2 and type(lib) == \"function\" then",
                    "\t\t\t\tlocal ok3, real = pcall(lib, \"\")",
                    "\t\t\t\tif ok3 then lib = real end",
                    "\t\t\tend",
                    "\t\t\tif type(lib) == \"table\" and lib.Window then return lib end",
                    "\t\tend",
                    "\tend",
                    "end",
                    "local ChilliLibrary = (type(getgenv) == \"function\" and getgenv().ChilliLibrary) or hubLibrary()",
                    "if not ChilliLibrary then",
                    "\twarn(\"[deobf] the hub library (Window / Tab / Notify) could not be loaded;"
                    " the script cannot start without it\")",
                    "\treturn",
                    "end"]
            helper_names = carrier.helpers(fn)
            stub = carrier.stub_source(helper_names)
            notes = payload_note("\n".join(lines))
            if stub:
                notes.append("-- deobf: needs the hub at run time")
                notes += ["-- The script also reaches into the loader's own helper table (%s);"
                          % ", ".join(helper_names),
                          "-- the stub at the bottom names the helper the first time one is used."]
            if notes:
                at = next((i for i, line in enumerate(out) if not line.startswith("--")), len(out))
                out[at:at] = notes
            out += [""] + lines + [""] + stub + [""]
            out.append("local entry = payload(%s)" % ("%s()" % carrier.STUB if stub else "..."))
            for lvl in range(2, depth + 1):
                out.append("entry = entry(%s)" % ("{ChilliLibrary}" if lvl == 2 else ""))
            out += ["entry()", ""]
            text = "\n".join(out)
            carried = "\n".join(lines)
            note = "field %r of %d, %d wrapper level(s)" % (name, nfields, depth)
        if require_script and not note:
            continue
        if best is None or len(text) > len(best[0]):
            best = (text, nfun, note, carried)
    return best


def lift(job, runner, patched, cfg, chunks, run_text, ppath, dpath, chunk_paths,
         payload_paths=None):
    """devirtualize() with its constant rounds answered by one long-lived
    harness (started now, so the script runs while round 1 walks); a fresh
    run per round if it fails or behaves differently."""
    args = job.args
    states = sorted(set(re.findall(r"State\d{2,4}", run_text or "")))
    if states:
        job.luarmor_states = states
    from obfuscators.luraph_v15 import devirt
    import deadline

    if os.environ.get("DEVIRT_PAYLOAD_SRC"):
        out_stats = emit_payload_source(job, dpath,
                                        chunk_paths if payload_paths is None else payload_paths,
                                        "asked for by DEVIRT_PAYLOAD_SRC")
        if out_stats is not None:
            return out_stats
        print("[!] payload: no chunk reads as Luau source; lifting the VMs instead", file=sys.stderr)
    exec_rec_on = bool(os.environ.get("DEVIRT_EXECREC") or getattr(args, "exec_rec", False))
    exec_seen = []
    if exec_rec_on:
        from obfuscators.luraph_v15 import dump as dump_mod
        try:
            with open(ppath, encoding="utf-8", errors="replace") as f:
                texts = [f.read()]
        except OSError:
            texts = []
        if texts:
            exec_seen.append(texts[0])
        want = int(os.environ.get("DEVIRT_EXECRUNS") or 3)
        for i in range(1, max(1, want)):
            c = dict(cfg)
            c["time_pin"] = 1700000000 + 7919 * i
            c["clock_pin"] = 0.125 + 0.01 * i
            fuel = int(c.get("loop_fuel") or 65536)
            c["loop_fuel"] = max(64, fuel // 8) if i == 1 else fuel * 16
            c["spin_fuel"] = max(8, int(c.get("spin_fuel") or 64) // 2) if i == 1 else 4096
            body, err = runner.run(patched, c, chunks)
            if body is None:
                print("[!] coverage run %d failed: %s" % (i + 1, str(err)[-200:]), file=sys.stderr)
                continue
            m = re.search(re.escape(harness.mark("PROTOS ")) + r"([^\n]*)\n", body)
            if m and not m.group(1).startswith("error:"):
                texts.append(m.group(1))
        for extra in texts[1:]:
            write_dump(ppath, extra, exec_rec_on, exec_seen)
    bridge = runner.bridge
    server = [None]
    synced = [False]    
    if not bridge and not os.environ.get("DEOB_NO_SERVE"):
        hs = harness.HarnessServer(runner.luau, patched, cfg, chunks)
        server[0] = hs
        first, err = hs.reply(args.timeout)
        server.append(True)
        if first is not None and harness.same_trace(harness.trace_text(first), run_text):
            s_protos, _ = trace.take_line(first, "PROTOS")
            if s_protos and not s_protos.startswith("error:"):
                write_dump(ppath, s_protos, exec_rec_on, exec_seen)
            synced[0] = True
        else:
            if first is None:
                print("[!] the long-lived harness failed: %s; running the script once per round instead" % err[-300:], file=sys.stderr)
            hs.close()
            server[0] = None    

    def live():
        hs = server[0]
        if hs is None or not synced[0] or os.environ.get("DEOB_NO_FETCH"):
            return None

        def fetch_live(paths, bufs):
            cur = server[0]
            if cur is None or not synced[0] or not cur.alive():
                if cur is not None:
                    cur.close()
                server[0] = None
                synced[0] = False
                raise RuntimeError("the long-lived harness is gone")
            return cur.fetch(paths, bufs, args.timeout)
        return fetch_live

    def rerun(c):
        synced[0] = False
        if bridge:
            return runner.run(patched, c, chunks)
        hs = server[0]
        if hs is not None and not server[1]:
            server[1] = True
            first, err = hs.reply(args.timeout)
            if first is None or not harness.same_trace(harness.trace_text(first), run_text):
                print("[!] the long-lived harness %s; running the script once per round instead"
                      % ("failed: " + err[-300:] if first is None else "traced differently"),
                      file=sys.stderr)
                hs.close()
                hs = server[0] = None
        if hs is not None:
            try:
                res = hs.request(c, args.timeout)
            except Exception as e:
                res = (None, "%s: %s" % (type(e).__name__, e))
            if res[0] is not None:
                synced[0] = True
                return res
            print("[!] the long-lived harness failed: %s; running the script once per round "
                  "instead" % str(res[1])[-300:], file=sys.stderr)
            hs.close()
            server[0] = None
        return runner.run(patched, c, chunks)
    try:
        return devirtualize(job, ppath, dpath, cfg, rerun, chunk_paths, live, exec_seen,
                            payload_paths)
    except Exception as e:

        print("[!] devirtualization failed: %s: %s" % (type(e).__name__, e), file=sys.stderr)
        if os.environ.get("DEVIRT_TB"):
            import traceback
            traceback.print_exc()
    finally:
        if server[0] is not None:
            server[0].close()
