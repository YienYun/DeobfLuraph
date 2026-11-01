'use strict';

// Attribution is part of every shipped output: exactly one author comment and one
// `print("Deobf By Zed")`, never inside a long string, and idempotent.
const test = require('node:test');
const assert = require('node:assert/strict');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const ROOT = path.resolve(__dirname, '..');
test('post-deobfuscation watermark preserves valid Luau syntax across scripts, return modules, and multiline strings', () => {
  const { WATERMARK_COMMENT, WATERMARK_PRINT, injectWatermark } = require('../src/watermark');
  const luauAst = path.join(ROOT, 'bin', 'luau-ast');
  const hasAst = fs.existsSync(luauAst) && process.platform !== 'win32';

  const samples = [
    [
      'local Players = game:GetService("Players")',
      'local msg = [[',
      'multiline line 1',
      'multiline line 2',
      ']]',
      'if Players then',
      '  print(msg)',
      'end',
    ].join('\n'),
    [
      'local Module = {}',
      'function Module.init(x)',
      '  if x == nil then',
      '    return false',
      '  end',
      '  return true',
      'end',
      'return Module',
    ].join('\n'),
    'return (function(a, b)\n  local sum = a + b\n  return sum\nend)(10, 20)\n',
    'local M = { a = 1 } do M.b = 2 end return M\n',
  ];

  for (const rngVal of [0, 0.35, 0.75, 0.999]) {
    for (const src of samples) {
      const out = injectWatermark(src, { rng: () => rngVal });
      assert.ok(out.includes(WATERMARK_COMMENT), 'expected watermark comment');
      assert.ok(out.includes(WATERMARK_PRINT), 'expected watermark print');
      assert.ok(!out.includes('multiline line 1\n' + WATERMARK_COMMENT), 'must never inject inside [[...]]');
      // Idempotency check
      const twice = injectWatermark(out, { rng: () => rngVal });
      assert.equal(twice.split(WATERMARK_COMMENT).length - 1, 1);
      assert.equal(twice.split(WATERMARK_PRINT).length - 1, 1);

      if (hasAst) {
        const tmp = path.join(os.tmpdir(), `wm-ast-${process.pid}-${Math.random().toString(36).slice(2)}.luau`);
        try {
          fs.writeFileSync(tmp, out, 'utf8');
          const r = spawnSync(luauAst, [tmp], { encoding: 'utf8' });
          assert.equal(r.status, 0, `luau-ast failed on watermarked code:\n${out}\nstderr: ${r.stderr}`);
        } finally {
          fs.rmSync(tmp, { force: true });
        }
      }
    }
  }
});
