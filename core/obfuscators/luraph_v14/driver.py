"""v14 pipeline: the shared driver driving the v14 mapper and devirt engine."""
import harness


def patch_entries(source, path):
    from obfuscators.luraph_v14 import vmmap
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
        code = " __PF[%s]=%s " % (var, info.get("pf_key", pv))
        cap = "".join("__PA[%s].%s=%s;" % (pv, nm, nm) for nm in info.get("captures", ()))
        code += ("if __PA and not __PA[%s] then __PA[%s]={};__PA.n=__PA.n+1;__PA[%s].__seq=__PA.n;"
                 "__PA[%s].__maker=\"%s@%d,%d\";__PK[%s]=%s;%s end "
                 % (pv, pv, pv, pv, tag, l2, c2, info.get("pf_key", pv), var, cap))
        edits.append((l2, c2, code))

    for l, c, code in sorted(edits, reverse=True):
        lines[l] = lines[l][:c] + code + lines[l][c:]
    return "\n".join(lines)


def lift(job, runner, patched, cfg, chunks, run_text, ppath, dpath, chunk_paths):
    import obfuscators.luraph_v15 as pkg15
    from obfuscators.luraph_v15 import driver as v15_driver
    from obfuscators.luraph_v15 import devirt as v15_devirt
    from obfuscators.luraph_v14 import devirt as v14_devirt

    pkg15.devirt = v14_devirt
    try:
        return v15_driver.lift(job, runner, patched, cfg, chunks, run_text, ppath, dpath, chunk_paths)
    finally:
        pkg15.devirt = v15_devirt
