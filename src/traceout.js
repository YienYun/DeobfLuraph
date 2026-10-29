'use strict';

const harness = require('./harness');

function stmtCount(body) {
  const match = /-- (\d+) statements recorded/.exec(body);
  return match ? Number(match[1]) : 0;
}

function takeLine(body, name) {
  const prefix = harness.mark(name + ' ');
  const start = body.indexOf(prefix);
  if (start === -1) return [null, body];
  const end = body.indexOf('\n', start);
  if (end === -1) return [null, body];
  return [body.slice(start + prefix.length, end), body.slice(0, start) + body.slice(end + 1)];
}

function takeStrings(body) {
  const marker = harness.mark('ENVLOG-STRINGS\n');
  const start = body.indexOf(marker);
  return start === -1 ? [body, null] : [body.slice(0, start), body.slice(start + marker.length)];
}

function header(_inputPath, notes = []) {
  return notes.map(note => `-- ${note}\n`).join('');
}

function statusLine(body) {
  const status = body ? body.split('\n', 1)[0].replace(/^[- ]+/, '') : '';
  process.stderr.write(`[*] ${status}\n`);
}

module.exports = { stmtCount, takeLine, takeStrings, header, statusLine };
