// Machine listing -> structured Lua.
//
// The VM decode step emits one `::Lnn::` label per instruction and a `goto` for
// every jump: exact, but it reads like assembly and Luau has no labels at all.
// This pass rebuilds the control flow a Lua compiler would have produced --
// if/else, while, break/continue -- and drops the blocks the VM never reaches.
//
// The rules are pure graph theory on the block graph, so nothing is guessed:
//   * an arm's blocks are the ones its entry dominates (a block reachable from
//     both arms belongs to their join, never to one arm);
//   * the join of a two-way branch is its nearest common post-dominator;
//   * a loop is a natural loop: a back edge whose target dominates its source;
//   * jumping to the enclosing loop's header is `continue`, jumping to one of
//     its exits is `break`.
// A proto whose blocks cannot all be emitted this way is reported, and the
// caller keeps the machine form for the whole file instead of shipping holes.

import {
  parseBlocks, buildCfg, tailOf, isTerminator, reachable, dominators,
  postDominators, naturalLoops,
} from './floor.js';

const STEP = '  ';

class Structurer {
  constructor(parsed, graph) {
    this.parsed = parsed;
    this.reach = graph.reach;
    this.dom = graph.dom;
    this.loops = graph.loops;
    this.entry = graph.entry;
    this.loopOf = new Map();
    for (const loop of this.loops) {
      for (const node of loop.body) {
        const current = this.loopOf.get(node);
        if (!current || loop.body.size < current.body.size) this.loopOf.set(node, loop);
      }
    }
    this.unresolved = [];
    this.duplicated = new Set();
    this.done = new Set();
  }

  block(label) {
    return this.parsed.byLabel.get(label);
  }

  loopAt(label) {
    return this.loops.find((loop) => loop.header === label) || null;
  }

  ownStatements(block) {
    const out = block.stmts.slice();
    while (out.length && isTerminator(out[out.length - 1])) out.pop();
    return out;
  }

  terminator(block) {
    const last = block.stmts[block.stmts.length - 1];
    return last && isTerminator(last) ? last : null;
  }

  dominatedBy(entry, region, stop) {
    const out = new Set();
    for (const label of region) {
      if (label === entry) {
        out.add(label);
        continue;
      }
      if (!this.dom.get(label)?.has(entry)) continue;
      if (stop !== null && stop !== undefined && this.dom.get(label)?.has(stop)) continue;
      out.add(label);
    }
    return out;
  }

  joinOf(a, b, region) {
    if (a === undefined || b === undefined) return null;
    if (a === b) return a;
    const exact = this.postDominatorJoin(a, b, region);
    return exact !== null ? exact : this.closestJoin(a, b, region);
  }

  reaches(from, to, region) {
    const seen = new Set([from]);
    const stack = [from];
    while (stack.length) {
      const node = stack.pop();
      for (const s of this.block(node).succ) {
        if (s === to) return true;
        if (!region.has(s) || seen.has(s)) continue;
        seen.add(s);
        stack.push(s);
      }
    }
    return false;
  }

  /** Closest block both arms reach: `max(dist)` first, then `dist(a)+dist(b)`. */
  closestJoin(a, b, region) {
    const walk = (from) => {
      const dist = new Map([[from, 0]]);
      const queue = [from];
      while (queue.length) {
        const node = queue.shift();
        for (const s of this.block(node).succ) {
          if (!region.has(s) || dist.has(s)) continue;
          dist.set(s, dist.get(node) + 1);
          queue.push(s);
        }
      }
      return dist;
    };
    const da = walk(a);
    const db = walk(b);
    let best = null;
    let bestKey = Infinity;
    for (const [node, x] of da) {
      if (!db.has(node)) continue;
      if (node !== a && node !== b && this.done.has(node)) continue;
      const y = db.get(node);
      const key = Math.max(x, y) * 1000 + x + y;
      if (key < bestKey) {
        bestKey = key;
        best = node;
      }
    }
    return best;
  }

  postDominatorJoin(a, b, region) {
    const exits = new Set();
    for (const label of region) {
      for (const s of this.block(label).succ) if (!region.has(s)) exits.add(s);
    }
    const pdom = postDominators(this.parsed, region, exits);
    const pa = pdom.get(a);
    const pb = pdom.get(b);
    if (!pa || !pb) return null;
    const common = [...pa].filter((x) => pb.has(x) && region.has(x));
    if (!common.length) return null;
    // The nearest post-dominator has the largest post-dominator set: the one
    // every path meets first.
    let best = null;
    let bestSize = -1;
    let tie = false;
    for (const candidate of common) {
      const size = pdom.get(candidate).size;
      if (size > bestSize) {
        best = candidate;
        bestSize = size;
        tie = false;
      } else if (size === bestSize) {
        tie = true;
      }
    }
    return tie ? null : best;
  }

  emit(entry, region, ctx) {
    const lines = [];
    let node = entry;
    while (node !== null && node !== undefined && region.has(node) && !this.done.has(node)) {
      const block = this.block(node);
      if (!block) break;

      // A loop header is entered through emitLoop, which emits the header's own
      // statements inside the body -- so it must not be marked done here.
      const loop = this.loopAt(node);
      if (loop && !ctx.open.has(loop)) {
        const body = this.loopBody(node, region);
        if (body.size >= 1) {
          const rendered = this.emitLoop(loop, body, region, ctx);
          lines.push(...rendered.lines);
          node = rendered.next;
          continue;
        }
      }

      this.done.add(node);

      const term = this.terminator(block);
      const tail = term ? tailOf(term) : null;
      if (tail?.prefix) {
        for (const piece of tail.prefix.split(/;\s*/).filter(Boolean)) lines.push(ctx.indent + piece.trim());
      }
      for (const text of this.ownStatements(block)) lines.push(ctx.indent + text);

      if (!term) {
        const next = block.succ[0];
        if (next === undefined) break;
        if (!region.has(next) || this.done.has(next)) {
          lines.push(...this.leave(next, ctx));
          break;
        }
        node = next;
        continue;
      }

      if (/^\s*(?:do\s+)?return\b/.test(term)) {
        lines.push(ctx.indent + term.replace(/^do\s+/, '').replace(/\s+end$/, ''));
        break;
      }

      const plainGoto = /^\s*goto\s+L(\d+)\s*$/.exec(term);
      if (plainGoto) {
        const target = Number(plainGoto[1]);
        if (region.has(target) && !this.done.has(target)) {
          node = target;
          continue;
        }
        lines.push(...this.leave(target, ctx));
        break;
      }

      if (!tail) {
        this.unresolved.push(`unparsed tail: ${term}`);
        lines.push(ctx.indent + term);
        break;
      }
      const rendered = this.emitBranch(tail, block, region, ctx);
      lines.push(...rendered.lines);
      node = rendered.next;
    }
    return lines;
  }

  /**
   * Body of the loop at `header`: the blocks it dominates inside `region` that
   * can still get back to it. Tails that only leave the loop (a `return`, or the
   * code after the loop) are not part of it, which keeps `break` meaning
   * `break` instead of "fall into the exit block".
   */
  loopBody(header, region) {
    const out = new Set();
    for (const node of this.dominatedBy(header, region, null)) {
      if (node === header || this.canReach(node, header, region)) out.add(node);
    }
    return out;
  }

  canReach(from, target, region) {
    const seen = new Set([from]);
    const stack = [from];
    while (stack.length) {
      const node = stack.pop();
      for (const s of this.block(node).succ) {
        if (s === target) return true;
        if (!region.has(s) || seen.has(s)) continue;
        seen.add(s);
        stack.push(s);
      }
    }
    return false;
  }

  inside(nodes, region) {
    for (const node of nodes) if (!region.has(node)) return false;
    return true;
  }

  emitBranch(tail, block, region, ctx) {
    const thenTarget = tail.then;
    const elseTarget = tail.else === null || tail.else === undefined ? block.next : tail.else;
    const cond = tail.condition;
    const lines = [];
    const loop = ctx.loop;
    const indent = ctx.indent;

    // `goto <loop header>` is a continue, `goto <loop exit>` is a break
    const isContinue = (label) => loop && label === loop.header;
    // Only the loop's own continuation is a `break`; every other way out of the
    // loop is a tail that belongs inside the body and is emitted inline.
    const isBreak = (label) => loop && (loop.exits || [])[0] === label;

    const act = (text) => (text ? [`${indent}${STEP}${text}`] : []);
    if (isContinue(thenTarget) && elseTarget !== undefined) {
      lines.push(`${indent}if ${cond} then`, ...act(tail.thenAction), `${indent}${STEP}continue`, `${indent}end`);
      lines.push(...act(tail.elseAction), ...this.tailEmit(elseTarget, region, ctx, indent));
      return { lines, next: null };
    }
    if (isContinue(elseTarget) && thenTarget !== undefined) {
      lines.push(`${indent}if not (${cond}) then`, ...act(tail.elseAction), `${indent}${STEP}continue`, `${indent}end`);
      lines.push(...act(tail.thenAction), ...this.tailEmit(thenTarget, region, ctx, indent));
      return { lines, next: null };
    }
    if (isBreak(thenTarget)) {
      lines.push(`${indent}if ${cond} then`, ...act(tail.thenAction), `${indent}${STEP}break`, `${indent}end`);
      lines.push(...act(tail.elseAction), ...this.tailEmit(elseTarget, region, ctx, indent));
      return { lines, next: null };
    }
    if (isBreak(elseTarget)) {
      lines.push(`${indent}if not (${cond}) then`, ...act(tail.elseAction), `${indent}${STEP}break`, `${indent}end`);
      lines.push(...act(tail.thenAction), ...this.tailEmit(thenTarget, region, ctx, indent));
      return { lines, next: null };
    }

    // A branch that jumps straight to an enclosing construct's join simply
    // falls out of the arm: that target is the join here too.
    const stopHit = [thenTarget, elseTarget].find((t) => t !== undefined && ctx.stops && ctx.stops.has(t));
    const join = stopHit !== undefined ? stopHit : this.joinOf(thenTarget, elseTarget, region);
    const action = (text) => (text ? [`${indent}${STEP}${text}`] : []);
    const stops = new Set(ctx.stops || []);
    if (join !== null) stops.add(join);

    const arm = (target) => {
      if (target === undefined || target === join) return [];
      if (this.done.has(target)) return null;
      // A block the parent structure owns can still be entered from this arm;
      // widen to the parent region before giving up on it.
      const base = region.has(target) ? region
        : (ctx.outer && ctx.outer.has(target) ? ctx.outer
          : (this.reach.has(target) ? this.reach : null));
      if (!base) return null;
      const sub = this.dominatedBy(target, base, join);
      sub.add(target);
      return this.emit(target, sub, { ...ctx, indent: indent + STEP, stops, outer: base });
    };

    const leaveArm = (target) => this.leave(target, { ...ctx, stops }).map((l) => STEP + l);

    if (join !== null) {
      const thenArm = arm(thenTarget);
      const elseArm = arm(elseTarget);
      const thenBody = thenArm === null ? leaveArm(thenTarget) : thenArm;
      const elseBody = elseArm === null ? leaveArm(elseTarget) : elseArm;
      const thenLines = [...action(tail.thenAction), ...thenBody];
      const elseLines = [...action(tail.elseAction), ...elseBody];

      if (join === thenTarget && !thenLines.length) {
        lines.push(`${indent}if not (${cond}) then`, ...elseLines, `${indent}end`);
      } else if (join === elseTarget && !elseLines.length) {
        lines.push(`${indent}if ${cond} then`, ...thenLines, `${indent}end`);
      } else {
        lines.push(`${indent}if ${cond} then`, ...thenLines);
        if (elseLines.length) lines.push(`${indent}else`, ...elseLines);
        lines.push(`${indent}end`);
      }
      return { lines, next: this.done.has(join) || !region.has(join) ? null : join };
    }

    // No convergence left in this region: both arms leave it.
    const arms = [];
    for (const [target, act] of [[thenTarget, tail.thenAction], [elseTarget, tail.elseAction]]) {
      if (target === undefined) { arms.push(null); continue; }
      if (!region.has(target) || this.done.has(target)) { arms.push(leaveArm(target)); continue; }
      const sub = this.dominatedBy(target, region, null);
      sub.add(target);
      arms.push([...action(act), ...this.emit(target, sub, { ...ctx, indent: indent + STEP, stops })]);
    }
    const [thenBody, elseBody] = arms;
    if (thenBody === null) {
      lines.push(`${indent}if not (${cond}) then`, ...(elseBody || []), `${indent}end`);
    } else {
      lines.push(`${indent}if ${cond} then`, ...thenBody);
      if (elseBody && elseBody.length) lines.push(`${indent}else`, ...elseBody);
      lines.push(`${indent}end`);
    }
    return { lines, next: null };
  }

  /** Emit a block that follows a `continue`/`break` guard, widening if needed. */
  tailEmit(target, region, ctx, indent) {
    if (target === undefined || this.done.has(target)) return [];
    const base = region.has(target) ? region
      : (ctx.outer && ctx.outer.has(target) ? ctx.outer
        : (this.reach.has(target) ? this.reach : null));
    if (!base) return this.leave(target, { ...ctx, indent });
    const sub = this.dominatedBy(target, base, null);
    sub.add(target);
    return this.emit(target, sub, { ...ctx, indent, outer: base });
  }

  emitLoop(loop, body, region, ctx) {
    const exits = new Set();
    for (const node of body) {
      for (const s of this.block(node).succ) if (!body.has(s)) exits.add(s);
    }
    // deterministic order: the first exit is where the loop's `end` falls to
    const ordered = [...exits].sort((a, b) => a - b);
    loop.exits = ordered;
    const open = new Set(ctx.open);
    open.add(loop);
    const inner = { ...ctx, indent: ctx.indent + STEP, loop, open, body };
    const emitted = this.emit(loop.header, body, inner);
    const lines = [`${ctx.indent}while true do`, ...emitted, `${ctx.indent}end`];

    const missing = [...body].filter((l) => !this.done.has(l));
    if (missing.length) this.unresolved.push(`loop body left ${missing.length} block(s)`);

    // A branch out of the loop is a `break`, which resumes at the first exit.
    // Other exits are reached by copying their chain at the branch itself.
    const live = ordered.filter((exit) => region.has(exit) && !this.done.has(exit));
    return { lines, next: live.length ? live[0] : null };
  }

  // Last resort for a jump that no enclosing structure can express: copy the
  // straight-line chain the jump lands on. Bounded, and only for short chains
  // that end in something terminal, so the result stays readable.
  duplicate(target, ctx, seen = new Set(), depth = 0) {
    const lines = [];
    if (depth > 3) return null;
    this.duplicated.add(target);
    let node = target;
    for (let step = 0; step < 12; step += 1) {
      if (node === undefined || seen.has(node)) return null;
      const block = this.block(node);
      if (!block) return null;
      seen.add(node);
      this.duplicated.add(node);
      for (const text of this.ownStatements(block)) lines.push(ctx.indent + text);
      const term = this.terminator(block);
      const barrier = (label) => this.done.has(label) ||
        (label !== undefined && ctx.stops instanceof Set && ctx.stops.has(label)) ||
        label === ctx.loop?.header || (ctx.loop?.exits || []).includes(label);
      if (!term) {
        const next = block.next;
        if (next === undefined) return lines;
        if (lines.length && barrier(next)) return lines;
        node = next;
        continue;
      }
      if (/^\s*(?:do\s+)?return\b/.test(term)) {
        lines.push(ctx.indent + term.replace(/^\s*do\s+/, '').replace(/\s+end\s*$/, ''));
        return lines;
      }
      const plain = /^\s*goto\s+L(\d+)\s*$/.exec(term);
      if (plain) {
        const next = Number(plain[1]);
        if (lines.length && barrier(next)) return lines;
        node = next;
        continue;
      }
      const tail = tailOf(term);
      if (!tail) return null;
      if (tail.prefix) {
        for (const piece of tail.prefix.split(/;\s*/).filter(Boolean)) lines.push(ctx.indent + piece.trim());
      }
      const elseTarget = tail.else === null || tail.else === undefined ? block.next : tail.else;
      const hits = [tail.then, elseTarget].filter(barrier);
      if (!hits.length) return null;
      const structural = hits.filter((t) => t === ctx.loop?.header || (ctx.loop?.exits || []).includes(t));
      for (const stop of [...structural, ...hits.filter((t) => !structural.includes(t))]) {
        const other = [tail.then, elseTarget].find((t) => t !== stop);
        if (other === undefined || seen.has(other)) continue;
        const rest = this.duplicate(other, { ...ctx, indent: ctx.indent + STEP }, seen, depth + 1);
        if (!rest) continue;
        lines.push(`${ctx.indent}if ${tail.then === stop ? `not (${tail.condition})` : tail.condition} then`);
        lines.push(...rest, `${ctx.indent}end`);
        if (stop === ctx.loop?.header) lines.push(`${ctx.indent}continue`);
        else if ((ctx.loop?.exits || []).includes(stop)) lines.push(`${ctx.indent}break`);
        return lines;
      }
      return null;
    }
    return null;
  }

  leave(target, ctx) {
    if (ctx.stops && ctx.stops.has(target)) return [];
    const loop = ctx.loop;
    if (loop) {
      if (target === loop.header) return [`${ctx.indent}continue`];
      if ((loop.exits || [])[0] === target) return [`${ctx.indent}break`];
    }
    // Anything else is expressed by copying the short chain the jump lands on.
    const copy = this.duplicate(target, ctx);
    if (copy) return copy;
    if (loop) {
      this.unresolved.push(`escape L${target}`);
      return [`${ctx.indent}break`];
    }
    this.unresolved.push(`jump to L${target} outside the body`);
    return [`${ctx.indent}-- jump L${target}`];
  }
}

/* ---------------------------------------------------------------- tidy up */

const IDENT = '[A-Za-z_][A-Za-z0-9_]*';

function tidyStatement(text) {
  let out = text;
  out = out.replace(new RegExp(`\\benv\\["(${IDENT})"]`, 'g'), '$1');
  out = out.replace(new RegExp(`\\b(${IDENT})\\["(${IDENT})"]`, 'g'), '$1.$2');
  out = out.replace(/do\s+return\b/, 'return');
  out = out.replace(/unpack\(r, (\d+), (\d+)\)/g, (whole, a, b) => {
    const from = Number(a);
    const to = Number(b);
    if (to < from || to - from > 8) return whole;
    const parts = [];
    for (let i = from; i <= to; i += 1) parts.push(`r[${i}]`);
    return parts.join(', ');
  });
  return out;
}

function foldChains(lines) {
  const out = [];
  const assignRe = new RegExp(`^(\\s*)(${IDENT}) = (.+)$`);
  const useRe = new RegExp(`^(\\s*)(${IDENT}) = (${IDENT})((?:\\.[A-Za-z_][A-Za-z0-9_]*|\\[[^\\]]+\\])+)$`);
  for (const line of lines) {
    const prev = out[out.length - 1];
    const a = assignRe.exec(line);
    const b = prev !== undefined ? useRe.exec(prev) : null;
    if (a && b && a[2] === b[2] && a[3].startsWith(b[2])) {
      const rest = a[3].slice(b[2].length);
      if (/^(?:\.[A-Za-z_]|\[|\s*[-+*/%]|\s*\.\.|\s*\()/.test(rest)) {
        out[out.length - 1] = `${b[1]}${a[2]} = ${b[3]}${b[4]}${rest}`;
        continue;
      }
    }
    out.push(line);
  }
  return out;
}

function trimScaffold(prelude, bodyText) {
  // A helper counts as used when anything in the proto still mentions it -- the
  // body, or another helper that stays.
  const scope = `${bodyText}\n${prelude.join('\n')}`;
  const used = (name) => new RegExp(`\\b${name}\\b`).test(scope);
  const optional = new Set(['pack', 'capture_register', 'capture_upvalue', 'get_upvalue', 'set_upvalue', 'close_upvalues']);
  const indentOf = (line) => /^\s*/.exec(line)[0].length;
  const keep = [];
  for (let i = 0; i < prelude.length; i += 1) {
    const line = prelude[i];
    const start = /^\s*local function ([A-Za-z_][A-Za-z0-9_]*)\(/.exec(line);
    if (start && optional.has(start[1]) && !used(start[1])) {
      // skip the whole body: every line is indented deeper, the block ends with
      // an `end` back at the declaration's own indentation
      const column = indentOf(line);
      let j = i + 1;
      if (/\bend\s*$/.test(line)) { i = j - 1; continue; }
      for (; j < prelude.length; j += 1) {
        if (indentOf(prelude[j]) === column && /^\s*end\s*$/.test(prelude[j])) break;
      }
      i = j;
      continue;
    }
    if (/^\s*local open_upvalues = \{\}\s*$/.test(line) && !used('capture_register') && !used('open_upvalues')) continue;
    if (/^\s*local top = -1\s*$/.test(line) && !/\btop\b/.test(scope)) continue;
    keep.push(line);
  }
  const widths = keep.filter((l) => l.trim()).map(indentOf);
  const common = widths.length ? Math.min(...widths) : 0;
  return keep.map((line) => (line.trim() ? line.slice(common) : ''));
}

/**
 * Exact fallback for a proto whose graph will not fold into if/while: keep the
 * blocks but drive them with a state variable instead of labels and `goto`.
 *
 * `__pc` is the program counter, each block is one `if`, and every jump becomes
 * an assignment. Same order of execution as the listing, no labels, valid Luau.
 */
function dispatchProto(parsed, reach, entry) {
  const order = parsed.order.filter((block) => reach.has(block.label));
  const ind = STEP + STEP + STEP + STEP;
  const body = [`${STEP}${STEP}local __pc = ${entry}`, `${STEP}${STEP}while true do`];
  for (const block of order) {
    body.push(`${ind}if __pc == ${block.label} then`);
    const term = block.stmts.length && isTerminator(block.stmts[block.stmts.length - 1])
      ? block.stmts[block.stmts.length - 1]
      : null;
    const tail = term ? tailOf(term) : null;
    const statements = term ? block.stmts.slice(0, -1) : block.stmts;
    if (tail && tail.prefix) {
      for (const piece of tail.prefix.split(/;\s*/).filter(Boolean)) body.push(`${ind}${STEP}${piece.trim()}`);
    }
    for (const text of statements) body.push(`${ind}${STEP}${text}`);
    if (!term) {
      body.push(`${ind}${STEP}__pc = ${block.next !== undefined ? block.next : 'nil'}`);
    } else if (/^\s*(?:do\s+)?return\b/.test(term)) {
      body.push(`${ind}${STEP}${term.replace(/^\s*do\s+/, '').replace(/\s+end\s*$/, '')}`);
    } else {
      const plain = /^\s*goto\s+L(\d+)\s*$/.exec(term);
      if (plain) {
        body.push(`${ind}${STEP}__pc = ${plain[1]}`);
      } else if (tail && tail.else !== null && tail.else !== undefined) {
        body.push(`${ind}${STEP}if ${tail.condition} then`);
        if (tail.thenAction) body.push(`${ind}${STEP}${STEP}${tail.thenAction}`);
        body.push(`${ind}${STEP}${STEP}__pc = ${tail.then}`, `${ind}${STEP}else`);
        if (tail.elseAction) body.push(`${ind}${STEP}${STEP}${tail.elseAction}`);
        body.push(`${ind}${STEP}${STEP}__pc = ${tail.else}`, `${ind}${STEP}end`);
      } else if (tail) {
        const fall = block.next !== undefined ? block.next : 'nil';
        body.push(`${ind}${STEP}if ${tail.condition} then`);
        if (tail.thenAction) body.push(`${ind}${STEP}${STEP}${tail.thenAction}`);
        body.push(`${ind}${STEP}${STEP}__pc = ${tail.then}`, `${ind}${STEP}else`);
        if (tail.elseAction) body.push(`${ind}${STEP}${STEP}${tail.elseAction}`);
        body.push(`${ind}${STEP}${STEP}__pc = ${fall}`, `${ind}${STEP}end`);
      } else {
        body.push(`${ind}${STEP}${term}`);
      }
    }
    body.push(`${ind}end`);
  }
  body.push(`${STEP}${STEP}end`);
  return body;
}

export function structureProto(name, lines) {
  const parsed = parseBlocks(lines);
  if (!parsed.order.length) return null;
  buildCfg(parsed);
  const entry = parsed.byLabel.has(0) ? 0 : parsed.order[0].label;
  const reach = reachable(parsed, entry);
  const { dom } = dominators(parsed, reach, entry);
  const loops = naturalLoops(parsed, reach, dom);
  const struct = new Structurer(parsed, { reach, dom, loops, entry });

  const ctx = { indent: STEP + STEP, loop: null, open: new Set() };
  const body = struct.emit(entry, reach, ctx);

  const missing = [...reach].filter((l) => !struct.done.has(l) && !struct.duplicated.has(l));
  const unresolved = [...struct.unresolved];
  if (missing.length) unresolved.push(`${missing.length} block(s) not emitted`);

  // A proto that does not fold cleanly keeps every block, driven by a counter.
  const forceDispatch = process.env.LUAOBF_FORCE_DISPATCH === '1';
  const chosen = forceDispatch || unresolved.length ? dispatchProto(parsed, reach, entry) : body;
  const tidied = foldChains(chosen.map(tidyStatement));
  const prelude = trimScaffold(parsed.prelude.filter((line) => line.trim()), tidied.join('\n'));

  return {
    name,
    mode: process.env.LUAOBF_FORCE_DISPATCH === '1' || unresolved.length ? 'dispatch' : 'structured',
    prelude,
    body: tidied,
    blocks: parsed.order.length,
    reachable: reach.size,
    dead: parsed.order.length - reach.size,
    unresolved,
  };
}

export function structureMachineText(text) {
  const lines = text.split('\n');
  const head = [];
  const trail = [];
  const protos = [];
  let current = null;
  for (const line of lines) {
    const start = /^protos\["([^"]+)"\] = function\(env, u\)$/.exec(line);
    if (start) {
      current = { name: start[1], lines: [] };
      protos.push(current);
      continue;
    }
    if (current) {
      if (/^end\s*$/.test(line)) {
        // closes the proto function; structureMachineText re-emits it
        current = null;
        continue;
      }
      if (!line.trim()) continue;
      current.lines.push(line);
      continue;
    }
    (protos.length ? trail : head).push(line);
  }

  const out = [...head];
  const stats = {
    protos: 0, blocks: 0, reachable: 0, dead: 0,
    structured: 0, dispatched: 0, failed: 0, unresolved: 0, problems: [],
  };
  const base = STEP + STEP;
  for (const proto of protos) {
    // the closure that wraps the register machine ends with its own `end`
    let closers = 0;
    while (proto.lines.length && /^\s+end\s*$/.test(proto.lines[proto.lines.length - 1])) {
      proto.lines.pop();
      closers += 1;
    }
    const structured = structureProto(proto.name, proto.lines);
    if (!structured) {
      stats.failed += 1;
      continue;
    }
    stats.protos += 1;
    stats.blocks += structured.blocks;
    stats.reachable += structured.reachable;
    stats.dead += structured.dead;
    if (structured.mode === 'structured') stats.structured += 1;
    else {
      stats.dispatched += 1;
      stats.problems.push(`${proto.name}: dispatch fallback (${structured.unresolved[0] || 'no clean fold'})`);
    }
    out.push(`protos["${proto.name}"] = function(env, u)`);
    for (const line of structured.prelude) out.push(line.trim() ? base + line : '');
    for (const line of structured.body) out.push(line);
    for (let i = 0; i < closers; i += 1) out.push(STEP + 'end');
    out.push('end');
    out.push('');
  }
  out.push(...trail);
  return { code: out.join('\n'), stats };
}
