// Control-flow utilities for the machine listing the VM decode step emits.
//
// The listing is one `::Lnn::` label per instruction with `goto` for every jump.
// Everything here works on that shape only: blocks, edges, dominators,
// post-dominators and natural loops.

export const LABEL_RE = /^\s*::L(\d+)::\s*$/;
export const GOTO_RE = /\bgoto\s+L(\d+)\b/g;


/**
 * Normalised tail of a block. The VM's numeric-for comes in two shapes that
 * carry their own `do ... end` wrapper; both are flattened here so the rest of
 * the pass only ever sees a condition with two destinations.
 */
export function tailOf(text) {
  const src = String(text || '').trim();
  if (!src) return null;

  // `do <setup>; if <cond> then ... end end` -- the VM wraps every conditional
  // instruction so it can carry setup statements. Peel the wrapper first; what
  // is left is always one plain if-statement.
  const wrap = /^do\s+([\s\S]*?;)\s*(if\b[\s\S]*?)\s+end$/.exec(src);
  if (wrap) {
    const inner = tailOf(wrap[2]);
    if (!inner) return null;
    return { ...inner, prefix: inner.prefix ? `${wrap[1]} ${inner.prefix}` : wrap[1] };
  }

  let m = /^if\s+(.+?)\s+then\s+goto\s+L(\d+)\s+else\s+goto\s+L(\d+)\s*end$/.exec(src);
  if (m) return { kind: 'branch', condition: m[1], then: Number(m[2]), else: Number(m[3]) };

  m = /^if\s+(.+?)\s+then\s+(.+?);\s*goto\s+L(\d+)\s+else\s+goto\s+L(\d+)\s*end$/.exec(src);
  if (m) return { kind: 'branch', condition: m[1], then: Number(m[3]), else: Number(m[4]), thenAction: m[2].trim() };

  m = /^if\s+(.+?)\s+then\s+goto\s+L(\d+)\s+else\s+(.+?);\s*goto\s+L(\d+)\s*end$/.exec(src);
  if (m) return { kind: 'branch', condition: m[1], then: Number(m[2]), else: Number(m[4]), elseAction: m[3].trim() };

  // one-sided forms: the missing side is the fall-through
  m = /^if\s+(.+?)\s+then\s+goto\s+L(\d+)\s*end$/.exec(src);
  if (m) return { kind: 'branch', condition: m[1], then: Number(m[2]), else: null };

  m = /^if\s+(.+?)\s+then\s+goto\s+L(\d+)\s+else\s+(.+?)\s*end$/.exec(src);
  if (m) return { kind: 'branch', condition: m[1], then: Number(m[2]), else: null, elseAction: m[3].trim() };

  m = /^if\s+(.+?)\s+then\s+(.+?);\s*goto\s+L(\d+)\s*end$/.exec(src);
  if (m) return { kind: 'branch', condition: m[1], then: Number(m[3]), else: null, thenAction: m[2].trim() };

  return null;
}

export function isTerminator(text) {
  return /^\s*(?:if\b[^\n]*\bgoto\b|goto\s+L\d+|do\s+return\b|return\b)/.test(text) || tailOf(text) !== null;
}

/** Kept for callers that only want the two-target form. */
export function branchOf(text) {
  const tail = tailOf(text);
  return tail && tail.kind === 'branch' && tail.else !== null ? tail : null;
}

/** Blocks of one proto body, in emission order. */
export function parseBlocks(lines) {
  const order = [];
  const byLabel = new Map();
  const prelude = [];
  let current = null;
  for (const raw of lines) {
    const m = LABEL_RE.exec(raw);
    if (m) {
      current = { label: Number(m[1]), stmts: [] };
      order.push(current);
      byLabel.set(current.label, current);
      continue;
    }
    const text = raw.replace(/^\s{4}/, '').replace(/\s+$/, '');
    if (!text.trim()) continue;
    if (!current) prelude.push(text);
    else current.stmts.push(text);
  }
  return { order, byLabel, prelude };
}

export function buildCfg(parsed) {
  for (const [i, block] of parsed.order.entries()) {
    const next = parsed.order[i + 1];
    block.next = next ? next.label : undefined;
    const last = block.stmts.length ? block.stmts[block.stmts.length - 1] : '';
    let succ;
    if (/^\s*(?:do\s+)?return\b/.test(last)) succ = [];
    else {
      const tail = tailOf(last);
      if (tail) {
        // a flattened forprep/forloop falls through when its condition is false
        succ = tail.else === null ? [tail.then, block.next] : [tail.then, tail.else];
      } else {
        const gotos = [...last.matchAll(GOTO_RE)].map((m) => Number(m[1]));
        succ = gotos.length ? [gotos[0]] : (block.next === undefined ? [] : [block.next]);
      }
    }
    block.succ = succ.filter((l) => parsed.byLabel.has(l));
  }
  return parsed;
}

export function reachable(parsed, entry) {
  const seen = new Set();
  const stack = [entry];
  while (stack.length) {
    const label = stack.pop();
    if (seen.has(label) || !parsed.byLabel.has(label)) continue;
    seen.add(label);
    for (const s of parsed.byLabel.get(label).succ) stack.push(s);
  }
  return seen;
}

export function predecessors(parsed, nodes) {
  const preds = new Map();
  for (const label of nodes) preds.set(label, []);
  for (const label of nodes) {
    for (const s of parsed.byLabel.get(label).succ) {
      if (preds.has(s)) preds.get(s).push(label);
    }
  }
  return preds;
}

function sameSet(a, b) {
  if (a.size !== b.size) return false;
  for (const x of a) if (!b.has(x)) return false;
  return true;
}

export function dominators(parsed, nodes, entry) {
  const preds = predecessors(parsed, nodes);
  const all = new Set(nodes);
  const dom = new Map();
  for (const n of nodes) dom.set(n, new Set(all));
  dom.set(entry, new Set([entry]));
  let changed = true;
  while (changed) {
    changed = false;
    for (const n of nodes) {
      if (n === entry) continue;
      const ps = preds.get(n).filter((p) => dom.has(p));
      let next = ps.length ? new Set(dom.get(ps[0])) : new Set();
      for (const p of ps.slice(1)) next = new Set([...next].filter((x) => dom.get(p).has(x)));
      next.add(n);
      if (!sameSet(next, dom.get(n))) {
        dom.set(n, next);
        changed = true;
      }
    }
  }
  return { dom, preds };
}

/** Post-dominators inside a region: every path to one of `exits` (or a return). */
export function postDominators(parsed, nodes, exits) {
  const all = new Set([...nodes, ...exits]);
  const pdom = new Map();
  const EXIT = -1;
  for (const n of all) pdom.set(n, new Set(nodes.has(n) ? [...all] : [n]));
  for (const e of exits) pdom.set(e, new Set([e]));
  pdom.set(EXIT, new Set([EXIT]));
  let changed = true;
  while (changed) {
    changed = false;
    for (const n of nodes) {
      const succ = parsed.byLabel.get(n).succ;
      const outs = succ.filter((s) => pdom.has(s));
      if (!outs.length) {
        const next = new Set([EXIT, n]);
        if (!sameSet(next, pdom.get(n))) {
          pdom.set(n, next);
          changed = true;
        }
        continue;
      }
      let next = new Set(pdom.get(outs[0]));
      for (const s of outs.slice(1)) next = new Set([...next].filter((x) => pdom.get(s).has(x)));
      next.add(n);
      if (!sameSet(next, pdom.get(n))) {
        pdom.set(n, next);
        changed = true;
      }
    }
  }
  return pdom;
}

export function naturalLoops(parsed, nodes, domSet) {
  const loops = [];
  for (const label of nodes) {
    const block = parsed.byLabel.get(label);
    for (const target of block.succ) {
      if (!nodes.has(target)) continue;
      if (!domSet.get(label)?.has(target)) continue;
      const body = new Set([target]);
      const stack = [label];
      while (stack.length) {
        const n = stack.pop();
        if (body.has(n)) continue;
        body.add(n);
        if (n === target) continue;
        for (const p of nodes) if (parsed.byLabel.get(p).succ.includes(n)) stack.push(p);
      }
      loops.push({ header: target, latch: label, body });
    }
  }
  const byHeader = new Map();
  for (const loop of loops) {
    const found = byHeader.get(loop.header);
    if (found) {
      for (const n of loop.body) found.body.add(n);
      found.latches.add(loop.latch);
    } else {
      byHeader.set(loop.header, { header: loop.header, body: new Set(loop.body), latches: new Set([loop.latch]) });
    }
  }
  return [...byHeader.values()].sort((a, b) => a.body.size - b.body.size);
}
