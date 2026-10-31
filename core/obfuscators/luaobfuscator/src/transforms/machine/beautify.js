// Register machine -> source-shaped Lua.
//
// The decode step leaves one register machine per function: every expression the
// original source had is broken into `r[a] = ...` steps, arguments are copied
// into consecutive registers, and results come back through `pack`/`unpack`.
// The structuring pass gave that machine if/while/break; this pass gives it back
// its expressions and names, so the text reads like the script it came from.
//
// Every rewrite is local to one straight-line run and keeps evaluation order:
//   * a pure value written to a register is spliced into the reads that consume
//     it, and its store is dropped when nothing else reads it;
//   * a call is folded into the read that immediately follows it;
//   * `f(x, ...)` where the first argument is the callee's own receiver becomes
//     `x:f(...)`, which is how the VM spelled method calls in the first place;
//   * `{f(...)}` captures with a known result count become plain assignments;
//   * `for i = a, b do r[i] = nil end` is a register clear and goes away;
//   * leftover registers get names taken from what they hold.

const KEYWORDS = new Set(['and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for',
  'function', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 'true',
  'until', 'while', 'continue']);

const CLEAR_RE = /^for i = (\d+), (\d+) do r\[i\] = nil end$/;
const RESULTS_RE = /^do local out = \{([\s\S]*)\}; for i = 0, (-?\d+) do r\[(\d+) \+ i\] = out\[i \+ 1\] end end$/;
const PACK_RE = /^do local out = pack\(([\s\S]*)\); top = (-?\d+) \+ out\.n - 1; for i = 1, out\.n do r\[(\d+) \+ i - 1\] = out\[i\] end end$/;

function isIdentifier(text) {
  return /^[A-Za-z_][A-Za-z0-9_]*$/.test(text) && !KEYWORDS.has(text);
}

/* -------------------------------------------------------------- expressions */

function splitTopLevel(text) {
  const parts = [];
  let depth = 0;
  let quote = null;
  let current = '';
  for (let i = 0; i < text.length; i += 1) {
    const ch = text[i];
    if (quote) {
      current += ch;
      if (ch === '\\') { current += text[i + 1] ?? ''; i += 1; continue; }
      if (ch === quote) quote = null;
      continue;
    }
    if (ch === '"' || ch === "'") { quote = ch; current += ch; continue; }
    if (ch === '(' || ch === '{' || ch === '[') depth += 1;
    if (ch === ')' || ch === '}' || ch === ']') depth -= 1;
    if (ch === ',' && depth === 0) { parts.push(current.trim()); current = ''; continue; }
    current += ch;
  }
  if (current.trim()) parts.push(current.trim());
  return parts;
}

function findOpen(text, end, open, close) {
  let depth = 0;
  let quote = null;
  for (let i = end; i >= 0; i -= 1) {
    const ch = text[i];
    if (quote) {
      if (ch === quote && text[i - 1] !== '\\') quote = null;
      continue;
    }
    if (ch === '"' || ch === "'") { quote = ch; continue; }
    if (ch === close) depth += 1;
    else if (ch === open) {
      depth -= 1;
      if (depth === 0) return i;
    }
  }
  return -1;
}

function parseKey(text) {
  const inner = text.trim();
  if (/^"(?:[^"\\]|\\.)*"$/.test(inner)) return { kind: 'literal', text: inner };
  if (/^-?\d+$/.test(inner)) return { kind: 'literal', text: inner };
  return parseExpr(inner);
}

function parseExpr(text) {
  const src = String(text).trim();
  if (!src) return { kind: 'raw', text: '' };
  let reg = /^r\[(\d+)\]$/.exec(src);
  if (reg) return { kind: 'reg', index: Number(reg[1]) };
  let unary = /^(#|not\s+|-)([\s\S]+)$/.exec(src);
  if (unary && src[0] !== '') {
    const operand = unary[2].trim();
    if (operand) return { kind: 'unary', op: unary[1].trim(), expr: parseExpr(operand) };
  }

  if (src.endsWith(')')) {
    const open = findOpen(src, src.length - 1, '(', ')');
    if (open > 0) {
      const head = src.slice(0, open).trim();
      const args = splitTopLevel(src.slice(open + 1, -1)).map(parseExpr);
      const method = /^([\s\S]+):([A-Za-z_][A-Za-z0-9_]*)$/.exec(head);
      if (method) return { kind: 'method', base: parseExpr(method[1]), name: method[2], args };
      if (/^[A-Za-z_][A-Za-z0-9_]*$/.test(head) || /^r\[\d+\]$/.test(head)
        || /^[A-Za-z_][A-Za-z0-9_]*\.[A-Za-z_][A-Za-z0-9_]*$/.test(head)) {
        return { kind: 'call', fn: parseExpr(head), args };
      }
      return { kind: 'raw', text: src };
    }
  }
  if (src.endsWith(']')) {
    const open = findOpen(src, src.length - 1, '[', ']');
    if (open > 0) {
      return { kind: 'index', base: parseExpr(src.slice(0, open)), key: parseKey(src.slice(open + 1, -1)) };
    }
  }
  if (src.endsWith('}')) {
    const open = findOpen(src, src.length - 1, '{', '}');
    if (open >= 0) return { kind: 'raw', text: src, pure: true };
  }
  let m = null;
  m = /^([A-Za-z_][A-Za-z0-9_]*)\.([A-Za-z_][A-Za-z0-9_]*)$/.exec(src);
  if (m) return { kind: 'index', base: { kind: 'name', text: m[1] }, key: { kind: 'literal', text: `"${m[2]}"` } };
  if (/^-?\d+(?:\.\d+)?$/.test(src) || /^"(?:[^"\\]|\\.)*"$/.test(src)
    || src === 'true' || src === 'false' || src === 'nil' || src === '...') {
    return { kind: 'literal', text: src };
  }
  if (isIdentifier(src)) return { kind: 'name', text: src };
  return { kind: 'raw', text: src };
}

function printExpr(node) {
  switch (node.kind) {
    case 'unary': {
      const inner = printExpr(node.expr);
      const simple = node.expr.kind === 'name' || node.expr.kind === 'literal' || node.expr.kind === 'reg'
        || node.expr.kind === 'index' || node.expr.kind === 'call' || node.expr.kind === 'method';
      const space = node.op === 'not' ? ' ' : '';
      return `${node.op}${space}${simple ? inner : `(${inner})`}`;
    }
    case 'reg': return `r[${node.index}]`;
    case 'name': return node.text;
    case 'literal': return node.text;
    case 'index': {
      const base = printExpr(node.base);
      if (node.key.kind === 'literal' && /^"[A-Za-z_][A-Za-z0-9_]*"$/.test(node.key.text)) {
        return `${base}.${JSON.parse(node.key.text)}`;
      }
      return `${base}[${printExpr(node.key)}]`;
    }
    case 'call': return `${printExpr(node.fn)}(${node.args.map(printExpr).join(', ')})`;
    case 'method': return `${printExpr(node.base)}:${node.name}(${node.args.map(printExpr).join(', ')})`;
    default: return node.text;
  }
}

function isPure(node) {
  if (!node) return true;
  if (node.kind === 'call' || node.kind === 'method') return false;
  // a table constructor makes a new table every time it runs
  if (node.kind === 'raw') return !/[{(]/.test(node.text);
  for (const key of ['base', 'fn', 'key', 'expr']) if (node[key] && !isPure(node[key])) return false;
  if (node.args) for (const arg of node.args) if (!isPure(arg)) return false;
  return true;
}

function collectRegs(node, out) {
  if (!node) return out;
  if (node.kind === 'reg') out.add(node.index);
  for (const key of ['base', 'fn', 'key', 'expr']) if (node[key]) collectRegs(node[key], out);
  if (node.args) for (const arg of node.args) collectRegs(arg, out);
  if (node.kind === 'raw') for (const m of node.text.matchAll(/r\[(\d+)\]/g)) out.add(Number(m[1]));
  return out;
}

function substitute(node, values, onUse) {
  if (!node) return node;
  switch (node.kind) {
    case 'reg': {
      const hit = values.get(node.index);
      if (!hit) return node;
      if (onUse && onUse(node.index) === false) return node;
      return hit.node;
    }
    case 'index': return { ...node, base: substitute(node.base, values, onUse), key: substitute(node.key, values, onUse) };
    case 'unary': return { ...node, expr: substitute(node.expr, values, onUse) };
    case 'call': return { ...node, fn: substitute(node.fn, values, onUse), args: node.args.map((a) => substitute(a, values, onUse)) };
    case 'method': return { ...node, base: substitute(node.base, values, onUse), args: node.args.map((a) => substitute(a, values, onUse)) };
    case 'raw': {
      if (!/r\[\d+\]/.test(node.text)) return node;
      const text = node.text.replace(/r\[(\d+)\]/g, (whole, n) => {
        const hit = values.get(Number(n));
        if (!hit) return whole;
        if (onUse && onUse(Number(n)) === false) return whole;
        const printed = printExpr(hit.node);
        return /^[A-Za-z_][A-Za-z0-9_]*$|^-?\d+$|^"(?:[^"\\]|\\.)*"$/.test(printed) ? printed : `(${printed})`;
      });
      return { kind: 'raw', text };
    }
    default: return node;
  }
}

/** `f(x, ...)` whose first argument is the receiver of `f` is `x:f(...)`. */
function sugar(node) {
  if (!node) return node;
  switch (node.kind) {
    case 'index': return { ...node, base: sugar(node.base), key: sugar(node.key) };
    case 'unary': return { ...node, expr: sugar(node.expr) };
    case 'call': {
      const fn = sugar(node.fn);
      const args = node.args.map(sugar);
      if (fn.kind === 'index' && args.length && printExpr(fn.base) === printExpr(args[0])
        && fn.key.kind === 'literal' && /^"[A-Za-z_][A-Za-z0-9_]*"$/.test(fn.key.text)) {
        return { kind: 'method', base: fn.base, name: JSON.parse(fn.key.text), args: args.slice(1) };
      }
      return { kind: 'call', fn, args };
    }
    case 'method': return { ...node, base: sugar(node.base), args: node.args.map(sugar) };
    default: return node;
  }
}

/* --------------------------------------------------------------- statements */

function parseStatement(line) {
  const indent = /^\s*/.exec(line)[0];
  const text = line.slice(indent.length);
  let m;
  if ((m = /^r\[(\d+)\]\[([\s\S]+)\] = ([\s\S]+)$/.exec(text))) {
    return { kind: 'indexAssign', indent, text, target: Number(m[1]), key: parseKey(m[2]), value: parseExpr(m[3]) };
  }
  if ((m = /^r\[(\d+)\] = ([\s\S]+)$/.exec(text))) {
    return { kind: 'assign', indent, text, target: Number(m[1]), value: parseExpr(m[2]) };
  }
  if ((m = /^(local )?([A-Za-z_][A-Za-z0-9_]*) = ([\s\S]+)$/.exec(text))) {
    return { kind: 'named', indent, text, local: Boolean(m[1]), name: m[2], value: parseExpr(m[3]) };
  }
  if (CALL_STMT.test(text) && !CALL_STMT.test(text.replace(/\)[^()]*$/, ''))) {
    return { kind: 'callStmt', indent, text, value: parseExpr(text) };
  }
  return { kind: 'other', indent, text };
}

const CALL_STMT = /^(?:r\[\d+\]|[A-Za-z_][A-Za-z0-9_.:]*)\s*\([\s\S]*\)$/;

const CONTROL = /^(if|elseif|else|end|while|for|repeat|until|do|function|local function|break|continue|return)\b/;

function isSimple(text) {
  const trimmed = text.trim();
  if (!trimmed || trimmed.startsWith('--')) return false;
  if (RESULTS_RE.test(trimmed) || PACK_RE.test(trimmed) || CLEAR_RE.test(trimmed)) return true;
  if (CONTROL.test(trimmed)) return false;
  return /^r\[\d+\](\[[\s\S]+\])? = /.test(trimmed) || /^(local )?[A-Za-z_][A-Za-z0-9_]* = /.test(trimmed)
    || CALL_STMT.test(trimmed);
}

/* -------------------------------------------------------------- proto scope */

/** How many times each register is read (as opposed to written) in a proto. */
function readCounts(bodyText) {
  const counts = new Map();
  for (const line of bodyText.split('\n')) {
    const trimmed = line.trim();
    if (!trimmed) continue;
    const target = /^r\[(\d+)\](\[[\s\S]+\])? = /.exec(trimmed);
    let rest = trimmed;
    if (target) {
      const reg = Number(target[1]);
      counts.set(reg, counts.get(reg) || 0);
      // `r[n][k] = v` writes through the register: it reads r[n] to index it
      if (target[2]) counts.set(reg, (counts.get(reg) || 0) + 1);
      rest = trimmed.slice(target[0].length);
    }
    for (const m of rest.matchAll(/r\[(\d+)\]/g)) {
      const n = Number(m[1]);
      counts.set(n, (counts.get(n) || 0) + 1);
    }
  }
  return counts;
}

/* ------------------------------------------------------------------ folding */

/**
 * Rewrite one straight-line run. `remaining` is the proto-wide read count, so a
 * store can be dropped once every read of it has been substituted.
 */
function foldRun(lines, remaining) {
  const statements = lines.map(parseStatement);
  const values = new Map(); // reg -> { node, pure, index }
  const consumed = new Map(); // producer index -> uses
  const unresolved = new Map(); // producer index -> reads left in the register
  const drop = new Set();
  const rendered = new Array(statements.length);

  // Returns false when the value may not be spliced here, so the caller keeps
  // the register read as it is.
  const noteUse = (i) => (reg) => {
    const hit = values.get(reg);
    if (!hit) return false;
    const refuse = () => {
      unresolved.set(hit.index, (unresolved.get(hit.index) || 0) + 1);
      return false;
    };
    // A call (or a value that builds a table) may be moved into the next
    // statement only, and only when that read is its last one: then the store
    // disappears and the call still runs exactly once, in the same order.
    if (!hit.pure && (i !== hit.index + 1 || (remaining.get(reg) || 0) > 1)) return refuse();
    consumed.set(hit.index, (consumed.get(hit.index) || 0) + 1);
    remaining.set(reg, (remaining.get(reg) || 0) - 1);
    return true;
  };

  for (let i = 0; i < statements.length; i += 1) {
    const st = statements[i];

    if (st.kind === 'other') {
      if (CLEAR_RE.test(st.text)) { rendered[i] = null; continue; }
      const results = RESULTS_RE.exec(st.text);
      if (results) {
        const count = Number(results[2]);
        const base = Number(results[3]);
        const call = printExpr(sugar(parseExpr(results[1])));
        const targets = [];
        for (let k = 0; k <= count; k += 1) targets.push(`r[${base + k}]`);
        rendered[i] = `${st.indent}${targets.join(', ')} = ${call}`;
        values.clear();
        continue;
      }
      if (PACK_RE.test(st.text)) { rendered[i] = st.text; values.clear(); continue; }
      values.clear();
      rendered[i] = st.text;
      continue;
    }

    const onUse = noteUse(i);
    const substituted = substitute(st.value, values, onUse);
    const value = sugar(substituted);
    const printed = printExpr(value);

    if (st.kind === 'assign') {
      // A value that is just another register (`r[5] = r[8]`) stops meaning
      // anything as soon as that register is overwritten, so drop those copies.
      for (const [reg, entry] of values) {
        if (entry.index !== i && collectRegs(entry.node, new Set()).has(st.target)) values.delete(reg);
      }
      // A store that the run overwrites before reading the register again is
      // dead, unless its value was a call that has not run yet.
      const previous = values.get(st.target);
      if (previous && !(unresolved.get(previous.index) || 0)
        && ((consumed.get(previous.index) || 0) > 0 || previous.pure)) drop.add(previous.index);
      values.set(st.target, { node: value, pure: isPure(value), index: i });
      // A produced value stays in play for later reads in this run.
      rendered[i] = () => `${st.indent}r[${st.target}] = ${printExpr(sugar(substitute(st.value, values, null)))}`;
      rendered[i] = `${st.indent}r[${st.target}] = ${printed}`;
      continue;
    }

    if (st.kind === 'indexAssign') {
      // the register is read to index into the table, and the key expression
      // is left as written: those reads stay in the machine's registers
      const held = values.get(st.target);
      if (held) unresolved.set(held.index, (unresolved.get(held.index) || 0) + 1);
      for (const reg of collectRegs(st.key, new Set())) {
        const keyValue = values.get(reg);
        if (keyValue) unresolved.set(keyValue.index, (unresolved.get(keyValue.index) || 0) + 1);
      }
      const key = st.key.kind === 'literal' && /^"[A-Za-z_][A-Za-z0-9_]*"$/.test(st.key.text)
        ? `.${JSON.parse(st.key.text)}`
        : `[${printExpr(st.key)}]`;
      values.delete(st.target);
      rendered[i] = `${st.indent}r[${st.target}]${key} = ${printed}`;
      continue;
    }

    if (st.kind === 'callStmt') {
      rendered[i] = `${st.indent}${printed}`;
      continue;
    }

    // named local: the VM's scaffolding, leave the register view intact
    rendered[i] = `${st.indent}${st.local ? 'local ' : ''}${st.name} = ${printed}`;
  }

  // Drop stores whose value went entirely into later reads of this run.
  for (let i = 0; i < statements.length; i += 1) {
    const st = statements[i];
    if (st.kind !== 'assign') continue;
    if (unresolved.get(i)) continue;
    // every read of this register happened in this run and was substituted
    if ((remaining.get(st.target) || 0) > 0) continue;
    if (!(consumed.get(i) || 0) && !statements[i].value) continue;
    if (!(consumed.get(i) || 0) && !isPure(st.value)) continue;
    drop.add(i);
  }

  const out = [];
  for (let i = 0; i < statements.length; i += 1) {
    if (drop.has(i)) continue;
    if (rendered[i] === null || rendered[i] === undefined) continue;
    out.push(rendered[i]);
  }
  return out;
}

/* --------------------------------------------------------------- entry point */

/**
 * `do local out = pack(f(...)); ... end` followed by a call that unpacks those
 * registers is the VM passing every result of f() as the call's trailing
 * arguments. Writing `g(f(...))` says the same thing and drops the bookkeeping.
 */
function inlinePackedCalls(lines) {
  const seen = []; // { text, drop, index }
  const dropped = new Set();
  const pending = new Map(); // register base -> the expression that produced it
  for (const line of lines) {
    const pack = PACK_RE.exec(line.trim());
    if (pack) {
      pending.set(Number(pack[3]), { expr: pack[1], entry: seen.length });
      seen.push({ text: line, pack: Number(pack[3]) });
      continue;
    }
    let text = line;
    let used = null;
    for (const [base, source] of pending) {
      const needle = `unpack(r, ${base}, top)`;
      if (!text.includes(needle)) continue;
      text = text.split(needle).join(source.expr);
      used = source;
    }
    seen.push({ text, consumed: used });
    if (used) dropped.add(used.entry);
  }
  return seen.filter((entry, index) => !(entry.pack !== undefined && dropped.has(index)))
    .map((entry) => entry.text);
}

/**
 * A call whose callee register is never given a value anywhere in the proto
 * cannot come from the script: the lift matched an opcode it did not know and
 * produced a call of `nil`, which only the listing reproduces. Dropping those
 * lines restores the instructions the VM really ran.
 */
const CALLEE_PATTERNS = [
  /^do local out = pack\(r\[(\d+)\]\(/,
  /^do local out = \{r\[(\d+)\]\(/,
  /^r\[(\d+)\]\(/,
  /^r\[(\d+)\] = r\[\1\]\(/,
];

function dropOrphanCalls(lines) {
  const assigned = new Set();
  for (const line of lines) {
    const text = line.trim();
    if (CLEAR_RE.test(text)) continue;
    const target = /^r\[(\d+)\](?:\[[\s\S]+\])? = /.exec(text);
    if (target) assigned.add(Number(target[1]));
  }
  const out = [];
  for (const line of lines) {
    const text = line.trim();
    let orphan = null;
    for (const pattern of CALLEE_PATTERNS) {
      const m = pattern.exec(text);
      if (!m) continue;
      if (!assigned.has(Number(m[1]))) orphan = Number(m[1]);
      break;
    }
    if (orphan === null) {
      out.push(line);
      continue;
    }
    // What survives is the part the next instruction depends on: `top` marks
    // where the argument list of the *physical* instruction ended.
    const indent = /^\s*/.exec(line)[0];
    out.push(`${indent}top = ${orphan} - 1`);
  }
  return out;
}


/**
 * `for i = a, b do r[i] = nil end` only forgets registers. It can go unless the
 * proto reads one of those registers before writing it again -- the VM does the
 * same clear before a loop whose control register must start empty.
 */
function unsafeClears(lines) {
  const unsafe = new Set();
  const bounds = [];
  let from = 0;
  for (let i = 0; i <= lines.length; i += 1) {
    if (i === lines.length || /^protos\["/.test(lines[i])) {
      bounds.push([from, i]);
      from = i;
    }
  }
  for (const [start, end] of bounds) {
    for (let i = start; i < end; i += 1) {
      const m = CLEAR_RE.exec(lines[i].trim());
      if (!m) continue;
      const first = Number(m[1]);
      const last = Number(m[2]);
      for (let reg = first; reg <= last; reg += 1) {
        const pattern = new RegExp(`r\\[${reg}\\]`);
        for (let j = i + 1; j < end; j += 1) {
          if (!pattern.test(lines[j])) continue;
          const writes = new RegExp(`^\\s*r\\[${reg}\\](\\[[^\\]]*\\])? = `).test(lines[j]);
          if (!writes) unsafe.add(i);
          break;
        }
      }
    }
  }
  return unsafe;
}

/** Applies `dropOrphanCalls` to every proto body of the file. */
function dropOrphanCallsInFile(lines) {
  const out = [];
  let index = 0;
  while (index < lines.length) {
    if (!/^protos\["/.test(lines[index])) {
      out.push(lines[index]);
      index += 1;
      continue;
    }
    let end = index + 1;
    while (end < lines.length && !/^protos\["/.test(lines[end]) && !/^return protos/.test(lines[end])) end += 1;
    out.push(...dropOrphanCalls(lines.slice(index, end)));
    index = end;
  }
  return out;
}

export function beautifySource(source) {
  const lines = inlinePackedCalls(dropOrphanCallsInFile(source.split('\n')));
  const unsafe = unsafeClears(lines);
  const out = [];
  let run = [];
  let counts = new Map();

  const flush = () => {
    if (!run.length) return;
    out.push(...foldRun(run, new Map(counts)));
    run = [];
  };

  let i = 0;
  while (i < lines.length) {
    const line = lines[i];
    if (/^protos\["/.test(line)) {
      // one proto = one scope: gather its reads before rewriting anything
      let end = i + 1;
      while (end < lines.length && !/^protos\["/.test(lines[end]) && !/^return protos/.test(lines[end])) end += 1;
      counts = readCounts(lines.slice(i, end).join('\n'));
    }
    if (unsafe.has(i) || !isSimple(line)) {
      flush();
      out.push(line);
      i += 1;
      continue;
    }
    run.push(line);
    i += 1;
  }
  flush();
  return out.join('\n');
}
