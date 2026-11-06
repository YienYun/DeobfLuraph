'use strict';

const assert = require('node:assert/strict');
const test = require('node:test');

const {
  WATERMARK_COMMENT,
  WATERMARK_PRINT,
  analyzeLuaLines,
  injectWatermark,
} = require('../../node/watermark');

test('attribution is the first line of the file', () => {
  const out = injectWatermark('local a = 1\nprint(a)\n');
  assert.equal(out.split('\n')[0], WATERMARK_COMMENT);
});

test('a shebang keeps line 1, the credit follows it', () => {
  const out = injectWatermark('#!/usr/bin/env luau\nprint(1)\n');
  const lines = out.split('\n');
  assert.equal(lines[0], '#!/usr/bin/env luau');
  assert.equal(lines[1], WATERMARK_COMMENT);
});

test('injection is idempotent', () => {
  const once = injectWatermark('local a = 1\nprint(a)\n');
  assert.equal(injectWatermark(once), once);
});

test('the output depends only on the input, not on the run', () => {
  const source = 'local a = 1\nif a then\n\tprint(a)\nend\n';
  assert.equal(injectWatermark(source), injectWatermark(source));
  assert.equal(injectWatermark(source), injectWatermark(source));
});

test('a copy left in the body by an older build is moved, never duplicated', () => {
  const legacy = `local a = 1\n${WATERMARK_COMMENT}\nprint(a)\n`;
  const out = injectWatermark(legacy);
  const hits = out.split('\n').filter((line) => line.trim() === WATERMARK_COMMENT);
  assert.equal(hits.length, 1);
  assert.equal(out.split('\n')[0], WATERMARK_COMMENT);
});

test('the debug print is appended once, at the bottom', () => {
  const out = injectWatermark('print(1)\n');
  const lines = out.split('\n').filter(Boolean);
  assert.equal(lines[lines.length - 1], WATERMARK_PRINT);
  assert.equal(out.split(WATERMARK_PRINT).length - 1, 1);
});

test('a formatter-friendly variant of the debug print is still recognised', () => {
  const out = injectWatermark(`print('Deobf By Zed')\nprint(1)\n`);
  assert.equal(out.split('Deobf By Zed').length - 1, 1);
});

test('the debug print goes before a trailing top-level return', () => {
  const out = injectWatermark('local a = 1\nreturn a\n');
  const lines = out.split('\n').filter(Boolean);
  assert.equal(lines[lines.length - 1], 'return a');
  assert.equal(lines[lines.length - 2], WATERMARK_PRINT);
});

test('nested returns are not top-level and are left alone', () => {
  const source = 'local function f()\n\treturn 1\nend\nprint(f())\n';
  const out = injectWatermark(source);
  assert.ok(out.includes('local function f()\n\treturn 1\nend'));
  assert.equal(out.split('\n').filter(Boolean).pop(), WATERMARK_PRINT);
});

test('a string that merely contains the credit text is not touched', () => {
  const source = `local s = "${WATERMARK_COMMENT}"\nprint(s)\n`;
  const out = injectWatermark(source);
  assert.ok(out.includes(`local s = "${WATERMARK_COMMENT}"`));
  assert.equal(out.split('\n').filter((line) => line.trim() === WATERMARK_COMMENT).length, 1);
});

test('CRLF input is normalised to LF', () => {
  const out = injectWatermark('print(1)\r\nprint(2)\r\n');
  assert.ok(!out.includes('\r'));
});

test('leading blank lines do not push the credit down', () => {
  const out = injectWatermark('\n\n\nprint(1)\n');
  assert.equal(out.split('\n')[0], WATERMARK_COMMENT);
});

test('analyzeLuaLines tracks block and bracket depth', () => {
  const meta = analyzeLuaLines('if x then\n\tlocal t = {1,\n\t\t2}\nend\n');
  assert.equal(meta[0].blockDepth, 0);
  assert.equal(meta[1].blockDepth, 1);
  assert.equal(meta[2].bracketDepth, 1);
  assert.equal(meta[3].blockDepth, 1);
});

test('analysis ignores keywords inside strings and comments', () => {
  const meta = analyzeLuaLines('local s = "if end function"\n-- if end\nlocal t = [[\nreturn\n]]\n');
  assert.equal(meta[0].blockDepth, 0);
  assert.equal(meta[1].topLevelReturn, false);
  assert.ok(meta.every((m) => m.topLevelReturn === false || m.safeLineStart === true));
});
