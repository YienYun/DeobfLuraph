'use strict';

// --stats digest: the one place that answers "what is still not promised by
// this output?" without reading the whole log. Kept honest: coverage and
// unexecuted pcs are printed when they exist, and the numbering counter is
// counted from the emitted text rather than assumed.

const assert = require('node:assert/strict');
const test = require('node:test');

const { statsDigest } = require('../../deob.js');

const SAMPLE = [
    '-- header',
    'local number4 = 420',
    'local data2 = {}',
    'local plain = 1',
    'local function f() return number4 end',
    'local function g() return plain end',
    '-- devirt: 3 function(s) contain 42 pc(s) the recorded run never executed;',
    '-- what they decode is the walk\'s value, not the program\'s',
    '',
].join('\n');

function job(extra = {}) {
    return {
        resultType: 'devirtualized',
        traceStatus: 'finished',
        warnings: [],
        liftStats: {
            functions: 2, walked: 0, fallbacks: 0, errors: 0,
            exec_runs: 4, exec_covered: 51, exec_no_arrays: 75,
            exec_pcs: 1999, exec_window: 328377, residual_unknown: 22,
        },
        ...extra,
    };
}

test('digest reports coverage, unexecuted pcs and numbered names', () => {
    const text = statsDigest(SAMPLE, job(), 'out.luau');

    assert.match(text, /stats: out\.luau/);
    assert.match(text, /devirtualized \(trace: finished\)/);
    assert.match(text, /pcs 1999 of 328377/);
    assert.match(text, /3 function\(s\) \/ 42 pc\(s\)/);
    assert.match(text, /2 numbered identifier\(s\), 3 use\(s\)/);
    assert.match(text, /22 unknown register read\(s\) kept/);
});

test('numbered names match whole identifiers only', () => {
    const text = statsDigest('local MyData2 = 1\nlocal data3 = 2\n', {}, 'x.luau');

    // MyData2 is not a numbered fallback name; data3 is.
    assert.match(text, /1 numbered identifier\(s\), 1 use\(s\)/);
});

test('digest never claims "none" for something it did not measure', () => {
    const text = statsDigest('local a = 1\n', { resultType: 'trace' }, 'x.luau');

    assert.doesNotMatch(text, /coverage/, 'no exec stats means no coverage line');
    assert.match(text, /unexecuted\s+none flagged by the lift/);
    assert.match(text, /naming\s+0 numbered identifier\(s\).*none left/);
});
