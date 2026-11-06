'use strict';

// --http-cache: the offline sandbox has no network, so a script that bootstraps
// itself with game:HttpGet(url) gets nil and dies on its own assert. A cache
// answers that url with a body that ships next to the sample, through the
// runtime's existing CFG.http_map. The mapping is explicit (url -> file) so a
// body can never be served for a url the script did not ask for.

const assert = require('node:assert/strict');
const fs = require('node:fs');
const os = require('node:os');
const path = require('node:path');
const test = require('node:test');

const { loadHttpCache } = require('../../node/httpcache');

function cacheDir(files, index) {
    const dir = fs.mkdtempSync(path.join(os.tmpdir(), 'deob-http-'));
    for (const [name, body] of Object.entries(files)) {
        fs.writeFileSync(path.join(dir, name), body, 'utf8');
    }
    if (index !== undefined) {
        fs.writeFileSync(path.join(dir, 'index.json'), JSON.stringify(index, null, 2), 'utf8');
    }

    return dir;
}

const URL = 'https://example.test/Chilli%20Library';

test('an index entry becomes a canned 200 response', () => {
    const dir = cacheDir({ 'lib.luau': 'return function() end\n' }, { [URL]: 'lib.luau' });
    const map = loadHttpCache(dir, false);

    assert.equal(map[URL].status, 200);
    assert.equal(map[URL].body, 'return function() end\n');
});

test('status and headers survive the object form', () => {
    const dir = cacheDir({ 'lib.luau': 'x' },
        { [URL]: { file: 'lib.luau', status: 404, headers: { 'X-Test': '1' } } });
    const map = loadHttpCache(dir, false);

    assert.equal(map[URL].status, 404);
    assert.deepEqual(map[URL].headers, { 'X-Test': '1' });
});

test('a prefix entry keeps its trailing star for the runtime matcher', () => {
    const dir = cacheDir({ 'lib.luau': 'x' }, { 'https://example.test/api*': 'lib.luau' });
    const map = loadHttpCache(dir, false);

    assert.ok(map['https://example.test/api*'], 'the runtime matches prefix keys itself');
});

test('a missing body or an escaping path is refused, not silently skipped', () => {
    const missing = cacheDir({}, { [URL]: 'nope.luau' });
    assert.throws(() => loadHttpCache(missing, false), /needs nope\.luau/);

    const escape = cacheDir({ 'lib.luau': 'x' }, { [URL]: '../../etc/passwd' });
    assert.throws(() => loadHttpCache(escape, false), /outside the cache/);
});

test('no index.json means no bodies, and no crash', () => {
    const dir = cacheDir({ 'lib.luau': 'x' });
    assert.deepEqual(Object.keys(loadHttpCache(dir, false)), []);
});

test('a file path is not a cache directory', () => {
    const dir = cacheDir({ 'lib.luau': 'x' });
    assert.throws(() => loadHttpCache(path.join(dir, 'lib.luau'), false), /needs a directory/);
});
