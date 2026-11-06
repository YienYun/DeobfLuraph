'use strict';

// Static guard: every literal relative `require()` in the repo must resolve.
// This is what caught renamer/garbage.js still pointing at ../engine/pyenv
// after the helpers moved to node/ — deob.js --rename crashed at startup and
// no test covered renamer/.

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');
const test = require('node:test');

const ROOT = path.resolve(__dirname, '..', '..');
const SKIP_DIRS = new Set([
    'node_modules', '.git', 'vendor', 'output', 'results', 'dev/fixtures',
]);
const REQUIRE = /require\(\s*['"](\.[^'"`]+)['"]\s*\)/g;

function jsFiles(dir, out = []) {
    for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
        if (entry.isDirectory()) {
            if (SKIP_DIRS.has(entry.name)) continue;
            jsFiles(path.join(dir, entry.name), out);
        } else if (entry.name.endsWith('.js')) {
            out.push(path.join(dir, entry.name));
        }
    }

    return out;
}

test('every literal relative require resolves', () => {
    const files = jsFiles(ROOT);
    assert.ok(files.length > 25, `expected the repo to expose sources, got ${files.length}`);

    const broken = [];

    for (const file of files) {
        const src = fs.readFileSync(file, 'utf8');

        for (const match of src.matchAll(REQUIRE)) {
            // Interpolated paths are dynamic, and a require call inside a
            // generated-Lua template string is not a Node require at all.
            if (match[1].includes('${') || match[1].includes('\\')) continue;

            try {
                require.resolve(path.resolve(path.dirname(file), match[1]));
            } catch {
                broken.push(`${path.relative(ROOT, file)} -> ${match[1]}`);
            }
        }
    }

    assert.deepEqual(broken, [], `unresolved require():\n${broken.join('\n')}`);
});
