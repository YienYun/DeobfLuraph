'use strict';

// MoonVeil is one of the three families this build ships. These cases drive its
// Python beautifier and structurer directly (no sandbox run), then execute the
// recovered Luau on `bin/luau` when that binary is present.
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
test('MoonVeil beautifier folds expressions, unboxes upvalue cells, and reconstructs generic for-loops cleanly', () => {
  const py = spawnSync(
    'python3',
    [
      '-c',
      [
        'import sys',
        'sys.path.insert(0, "core/obfuscators/moonveil")',
        'from moonveil.front import parse',
        'from moonveil.beautify import beautify_reconstructed',
        'sample = b"""',
        'local ctx = {}',
        'ctx._ = getfenv()',
        'ctx.h = function(...) return {[1] = {...}, [2] = select("#", ...)} end',
        'ctx.i = (function() local m = table.unpack or unpack; return function(o) return m(o[1], 1, o[2]) end end)()',
        'ctx.g = (function() return function(f, s, c) local mt = getmetatable(f); if mt and mt.__iter then return mt.__iter(f) end; return f, s, c end end)()',
        'ctx.b = function(c, u) return function() u[1].value = u[1].value + u[2].value end end',
        'ctx.a = function(c) return function()',
        '    local a, b, d, e, f',
        '    a = 0',
        '    a = {value = a}',
        '    b = {}',
        '    b[1] = 10',
        '    b[2] = 20',
        '    b[3] = 30',
        '    d = c._.ipairs',
        '    d, e, f = d(b)',
        '    d, e, f = c.g(d, e, f)',
        '    local k, v = d(e, f)',
        '    f = k',
        '    if f == nil then else',
        '        while true do',
        '            v = {value = v}',
        '            local fn = c:b({a, v})',
        '            fn()',
        '            k, v = d(e, f)',
        '            f = k',
        '            if f == nil then break end',
        '        end',
        '    end',
        '    return a.value',
        'end end',
        'return (function(x, ...) return x:a()(...) end)(ctx, ...)',
        '"""',
        'ast = parse(sample)',
        'selected = {}',
        'for s in ast["body"]:',
        '    if s["type"] == "AssignmentStatement":',
        '        selected[s["variables"][0]["identifier"]["name"]] = s["init"][0]',
        'entry = ast["body"][-1]["arguments"][0]["base"]',
        'out = beautify_reconstructed(selected, entry).decode("utf-8")',
        'print(out)',
      ].join('\n'),
    ],
    { cwd: ROOT, encoding: 'utf8', timeout: 15000 }
  );
  assert.equal(py.status, 0, py.stderr);
  assert.doesNotMatch(py.stdout, /\.value\b/);
  assert.doesNotMatch(py.stdout, /__mv_|__w_|__cell_|__moonveil_recovered/);
  assert.match(py.stdout, /for .+ in ipairs\(\{10, 20, 30\}\) do/);

  const luauBin = path.join(ROOT, 'bin', 'luau');
  if (fs.existsSync(luauBin) && process.platform !== 'win32') {
    const tmp = path.join(os.tmpdir(), `mv-beautify-check-${process.pid}.luau`);
    try {
      fs.writeFileSync(tmp, `local function run()\n${py.stdout}\nend\nassert(run() == 60)\nprint("SUM_60_OK")\n`, 'utf8');
      const run = spawnSync(luauBin, [tmp], { encoding: 'utf8' });
      assert.equal(run.status, 0, run.stderr);
      assert.match(run.stdout, /SUM_60_OK/);
    } finally {
      fs.rmSync(tmp, { force: true });
    }
  }

  const rideOut = path.join(ROOT, 'samples', 'output', 'RideAFish_MoonVeil.lua');
  if (fs.existsSync(rideOut)) {
    const src = fs.readFileSync(rideOut, 'utf8');
    assert.doesNotMatch(src, /__moonveil_recovered/);
    assert.doesNotMatch(src, /\.value\b/);
    assert.match(src, /local function startMainHub\(\)/);
    assert.match(src, /for idx, eggName in ipairs\(/);
  }
});

test('MoonVeil 2.1.1 SCCP opaque-predicate pruning, nested early-return loop structuring, and numeric-for recovery work cleanly', () => {
  const py = spawnSync(
    'python3',
    [
      '-c',
      [
        'import sys; sys.path.insert(0, "core/obfuscators/moonveil")',
        'from moonveil.front import parse',
        'from moonveil.cfg import build_graph, block',
        'from moonveil.structure import Structurer',
        'from moonveil.beautify import beautify_reconstructed',
        'src = b"""',
        'local function f(c, items)',
        '  local st, o, k, i, j, x',
        '  st, i = 1, 1',
        '  while true do',
        '    if st < 5 then',
        '      if st < 3 then',
        '        if st < 2 then',
        '          o, k = 166, 240',
        '          st = (o < k) and 2 or 5',
        '        else',
        '          j = 1',
        '          st = (i <= 2) and 3 or 6',
        '        end',
        '      else',
        '        if st < 4 then',
        '          st = (j <= 2) and 8 or 9',
        '        else',
        '          return x',
        '        end',
        '      end',
        '    else',
        '      if st < 7 then',
        '        if st < 6 then',
        '          st = 2',
        '        else',
        '          return nil',
        '        end',
        '      else',
        '        if st < 8 then',
        '          j = j + 1',
        '          st = 3',
        '        elseif st < 9 then',
        '          x = items[i][j]',
        '          st = (x == 99) and 4 or 7',
        '        else',
        '          i = i + 1',
        '          st = 2',
        '        end',
        '      end',
        '    end',
        '  end',
        'end',
        '"""',
        'fn = parse(src)["body"][0]',
        'g = build_graph(fn)',
        'assert 5 not in g["nodes"], f"dead opaque state 5 was not pruned: {list(g[\'nodes\'])}"',
        'body = Structurer(g).emit()',
        'txt = block(body)',
        'assert "return x" in txt and "return nil" in txt, txt',
        'entry = parse(b"return function(c) local acc = {} local idx = 1 while true do acc[idx] = idx * 2 idx = idx + 1 if idx > 3 then break end end return acc end")["body"][0]["arguments"][0]',
        'pretty = beautify_reconstructed({}, entry).decode("utf-8")',
        'assert "for idx = 1, 3 do" in pretty, pretty',
        'print("MV211_OK")',
      ].join('\n'),
    ],
    { cwd: ROOT, encoding: 'utf8', timeout: 15000 }
  );
  assert.equal(py.status, 0, py.stderr);
  assert.match(py.stdout, /MV211_OK/);
});
