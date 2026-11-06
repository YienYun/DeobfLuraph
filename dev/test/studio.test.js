'use strict';

// --studio: the run happens in a real Roblox place. The engine serves the
// harness over 127.0.0.1 to a loader the user pastes into the Studio command
// bar, and the loader posts the trace back. No Roblox exists here, so the test
// stands in for the place with a peer that fetches /harness, runs it with the
// bundled luau and posts the result -- which is the same round trip.

const assert = require('node:assert/strict');
const fs = require('node:fs');
const http = require('node:http');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');
const { spawnSync } = require('node:child_process');

const ROOT = path.resolve(__dirname, '..', '..');
const harness = require(path.join(ROOT, 'node', 'harness'));

let nextPort = 34920 + Math.floor(Math.random() * 40);

function get(port, url) {
    return new Promise((resolve, reject) => {
        const req = http.get({ host: '127.0.0.1', port, path: url }, (res) => {
            const bufs = [];
            res.on('data', (d) => bufs.push(d));
            res.on('end', () => resolve(Buffer.concat(bufs).toString('latin1')));
        });
        req.on('error', reject);
    });
}

function post(port, url, body) {
    return new Promise((resolve, reject) => {
        const req = http.request({ host: '127.0.0.1', port, method: 'POST', path: url }, (res) => {
            res.resume();
            res.on('end', resolve);
        });
        req.on('error', reject);
        req.end(Buffer.from(body, 'latin1'));
    });
}

// one "Studio": fetch a harness, run it, post the output back
async function peer(port, runs) {
    for (let i = 0; i < runs; i++) {
        const src = await get(port, '/harness');
        if (src === '') return i;
        const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'studio-'));
        const file = path.join(dir, 'h.luau');
        fs.writeFileSync(file, src, 'latin1');
        const res = spawnSync(harness.findLuau(), [file], { encoding: 'utf8', timeout: 120000, maxBuffer: 64 * 1024 * 1024 });
        fs.rmSync(dir, { recursive: true, force: true });
        const out = (res.stdout || '') + (res.stderr || '');
        await post(port, '/result?part=1&of=1', out);
    }
    return runs;
}

test('a harness travels to the peer and the trace comes back', async () => {
    const port = nextPort++;
    const bridge = new harness.StudioBridge(port);
    const runs = peer(port, 1);
    const text = await bridge.run('print("hello from the bridge")', 60);
    bridge.finish();
    await runs;

    assert.match(text, /hello from the bridge/);
});

test('a second run reuses the same peer and the finish unblocks it', async () => {
    const port = nextPort++;
    const bridge = new harness.StudioBridge(port);
    const runs = peer(port, 2);
    const first = await bridge.run('print("one")', 60);
    const second = await bridge.run('print("two")', 60);
    bridge.finish();
    const served = await runs;

    assert.match(first, /one/);
    assert.match(second, /two/);
    assert.ok(served >= 1, 'the peer saw the harnesses');
});

test('a peer that never answers times out instead of hanging the engine', async () => {
    const port = nextPort++;
    const bridge = new harness.StudioBridge(port);
    await assert.rejects(() => bridge.run('print("nobody home")', 1), /no answer from Studio/);
    bridge.finish();
});

test('the generated loader names the port and turns HttpService off around the run', () => {
    const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'loader-'));
    const trace = path.join(dir, 'job.trace.luau');
    const file = harness.studioHarnessPath(trace, 34999);
    const text = fs.readFileSync(file, 'utf8');
    fs.rmSync(dir, { recursive: true, force: true });

    assert.match(text, /127\.0\.0\.1:34999/);
    assert.match(text, /HS\.HttpEnabled = false/);
    assert.match(text, /HS\.HttpEnabled = was/);
    assert.match(file, /studio_loader\.luau$/);
});
