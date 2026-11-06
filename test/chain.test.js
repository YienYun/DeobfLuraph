'use strict';


const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..');
const luarmor = require(path.join(ROOT, 'src', 'luarmor'));

const STUB = `local _bsdata0 = { module_id = "abc", cache_key = "def" }
local url = "https://api.luarmor.net/files/v4/loaders/0123456789abcdef0123456789abcdef.lua"
local function kick(msg)
\tgame.Players.LocalPlayer:Kick("[Luarmor] " .. msg)
end
writefile("luarmor-error-log.txt", "")
kick("no")
`;

const WITH_CHUNK = `local _bsdata0 = { module_id = "abc", cache_key = "def" }
local superflow_bytecode = { [1] = 0, [2] = 0, [3] = 1 }
local url = "https://cdn.luarmor.net/v4_init_0123.lua"
local function boot()
\treturn setmetatable({[1]=bit32.bxor,[2]=string.sub,[3]=table.concat}, {})
end
kick = boot
`;

const PLAIN = `local function f(a)
\treturn a + 1
end
print(f(1))
`;

function payloadFile(text) {
  const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'chain-'));
  const p = path.join(dir, 'job.payload.luau');
  fs.writeFileSync(p, text);
  return { path: p, dir };
}

function fakeJob(dir) {
  return {
    warnings: [],
    input: path.join(dir, 'input.lua'),
    source: 'input source',
    sourcePath: path.join(dir, 'input.lua'),
    tracePath: path.join(dir, 'job.deobf.luau'),
    path: (suffix) => path.join(dir, 'job' + suffix),
  };
}

test('a payload that is not Luarmor is left alone', () => {
  const f = payloadFile(PLAIN);
  try {
    assert.equal(luarmor.chainPlan(f.path), null);
  } finally {
    fs.rmSync(f.dir, { recursive: true, force: true });
  }
});

test('a Luarmor client stub is recognised and has nothing to lift', () => {
  const f = payloadFile(STUB);
  try {
    const plan = luarmor.chainPlan(f.path);
    assert.ok(plan, 'expected the payload to be recognised as Luarmor');
    assert.equal(plan.meta.kind, 'client_stub');
    assert.equal(plan.lift, false);
    assert.match(plan.meta.label, /payload is fetched at runtime/);
  } finally {
    fs.rmSync(f.dir, { recursive: true, force: true });
  }
});

test('a payload that carries a Luraph chunk is marked for lifting', () => {
  const f = payloadFile(WITH_CHUNK);
  try {
    const plan = luarmor.chainPlan(f.path);
    assert.ok(plan);
    assert.equal(plan.lift, true);
    assert.equal(plan.meta.kind, 'sephal_init');
  } finally {
    fs.rmSync(f.dir, { recursive: true, force: true });
  }
});

test('the chain records the stub analysis and keeps the result it was given', async () => {
  const f = payloadFile(STUB);
  const job = fakeJob(f.dir);
  try {
    const out = await luarmor.chain(job, '/nonexistent/result.luau');
    assert.equal(out, null, 'a stub has no chunk, so no new result');
    assert.equal(job.luarmor.kind, 'client_stub');
    assert.deepEqual(job.chain, ['luarmor:client_stub']);
    assert.match(job.warnings.join('\n'), /fetched at run time/);
  } finally {
    fs.rmSync(f.dir, { recursive: true, force: true });
  }
});

test('the chain stays quiet when the payload is not Luarmor', async () => {
  const f = payloadFile(PLAIN);
  const job = fakeJob(f.dir);
  try {
    assert.equal(await luarmor.chain(job, '/nonexistent/result.luau'), null);
    assert.equal(job.luarmor, undefined);
    assert.equal(job.chain, undefined);
    assert.deepEqual(job.warnings, []);
  } finally {
    fs.rmSync(f.dir, { recursive: true, force: true });
  }
});

test('a payload that carries a chunk is handed to the engine and keeps its metadata', async () => {
  const f = payloadFile(WITH_CHUNK);
  const job = fakeJob(f.dir);
  const liftedPath = path.join(f.dir, 'lifted.luau');
  const seen = [];
  const fakeDriver = {
    run: async (subJob) => {
      seen.push({ input: subJob.input, tracePath: subJob.tracePath, source: subJob.source.length });
      subJob.resultType = 'devirtualized';
      subJob.liftStats = { functions: 3, walked: 3 };
      fs.writeFileSync(liftedPath, 'local function boot() return 1 end\nprint(boot())\n');
      return liftedPath;
    },
  };
  try {
    const out = await luarmor.chain(job, '/nonexistent/result.luau', { driver: fakeDriver });
    assert.equal(out, liftedPath);
    assert.equal(seen.length, 1, 'the engine ran once, over the payload');
    assert.equal(seen[0].input, f.path, 'the engine is pointed at the payload file');
    assert.match(seen[0].tracePath, /\.carried\.deobf\.luau$/, 'intermediates do not overwrite the first run');
    assert.deepEqual(job.chain, ['luarmor:sephal_init', 'luraph_v15']);
    const text = fs.readFileSync(liftedPath, 'utf8');
    assert.match(text, /^-- Luarmor v4:/, 'the lifted chunk keeps the Luarmor header');
    assert.equal(job.input, path.join(f.dir, 'input.lua'), 'the job points at the original input again');
    assert.match(job.tracePath, /job\.deobf\.luau$/, 'and at the original trace path');
  } finally {
    fs.rmSync(f.dir, { recursive: true, force: true });
  }
});

test('the job is put back the way it was when the engine run fails', async () => {
  const f = payloadFile(WITH_CHUNK);
  const job = fakeJob(f.dir);
  job.input = 'original/input.lua';
  job.source = 'original source';
  job.sourcePath = 'original/input.lua';
  job.tracePath = path.join(f.dir, 'job.deobf.luau');
  const fakeDriver = { run: async () => { throw new Error('harness died'); } };
  try {
    const out = await luarmor.chain(job, '/nonexistent/result.luau', { driver: fakeDriver });
    assert.equal(out, null);
    assert.equal(job.input, 'original/input.lua');
    assert.equal(job.source, 'original source');
    assert.equal(job.sourcePath, 'original/input.lua');
    assert.equal(job.tracePath, path.join(f.dir, 'job.deobf.luau'));
    assert.match(job.warnings.join('\n'), /could not be lifted: harness died/);
  } finally {
    fs.rmSync(f.dir, { recursive: true, force: true });
  }
});
