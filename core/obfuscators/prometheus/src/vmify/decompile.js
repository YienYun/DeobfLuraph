'use strict';

const A = require('../lua/ast');
const { Kind } = A;
const { isIdentifier } = require('../lua/format');
const { walk } = require('../lua/walk');

const BOX_OFFSET = 10000;
const boxSlot = (r) => r + BOX_OFFSET;

function luaList(tbl, lenKey) {
  if (!(tbl instanceof Map)) return [];
  const explicitLen = lenKey !== undefined && tbl.has(lenKey) ? tbl.get(lenKey) : null;
  const out = [];
  if (typeof explicitLen === 'number' && explicitLen >= 0) {
    for (let i = 1; i <= explicitLen; i += 1) {
      out.push(tbl.has(i) ? tbl.get(i) : null);
    }
    return out;
  }
  for (let i = 1; tbl.has(i); i += 1) {
    out.push(tbl.get(i));
  }
  return out;
}

function literalToAst(val) {
  if (val === null || val === undefined) return A.nil();
  if (typeof val === 'boolean') return A.boolean(val);
  if (typeof val === 'number') {
    if (val < 0 || Object.is(val, -0)) return A.unary('-', A.number(-val));
    return A.number(val);
  }
  if (typeof val === 'string') return A.string(val);
  return A.nil();
}

function globalRef(name) {
  if (typeof name === 'string' && isIdentifier(name)) {
    return A.name(name);
  }
  return A.index(A.name('_G'), A.string(String(name)), false);
}

function negateExpr(expr) {
  if (!expr) return A.unary('not', A.nil());
  if (expr.kind === Kind.Unary && expr.operator === 'not') {
    return expr.argument;
  }
  const flip = {
    '==': '~=',
    '~=': '==',
  };
  if (expr.kind === Kind.Binary && flip[expr.operator]) {
    return A.binary(flip[expr.operator], expr.lhs, expr.rhs);
  }
  return A.unary('not', expr);
}

function mentionsIdent(node, identName) {
  let found = false;
  if (!node) return false;
  walk(node, {
    enter(cur) {
      if (found) return false;
      if (cur.kind === Kind.Name && cur.name === identName) {
        found = true;
        return false;
      }
      return undefined;
    },
  });
  return found;
}

function instructionReadsWrites(ins, childProtos, keys) {
  const reads = [];
  const writes = [];
  const kills = [];
  switch (ins.op) {
    case 'NOP':
      if (Array.isArray(ins.cleared)) kills.push(...ins.cleared);
      break;
    case 'MOVE': case 'UNOP':
      reads.push(ins.src);
      writes.push(ins.dst);
      break;
    case 'NEWBOX':
      reads.push(ins.src);
      writes.push(boxSlot(ins.dst));
      break;
    case 'GETBOX':
      reads.push(boxSlot(ins.src));
      writes.push(ins.dst);
      break;
    case 'SETBOX':
      // Mutates value inside existing box without replacing box identity!
      reads.push(boxSlot(ins.dst), ins.src);
      break;
    case 'LOADK': case 'LOADNIL': case 'GETGLOBAL': case 'GETUPVAL':
    case 'NEWTABLE': case 'VARARG':
      writes.push(ins.dst);
      break;
    case 'CLOSURE': {
      if (childProtos && keys) {
        const cp = childProtos[ins.protoIdx - 1];
        if (cp) {
          const rawUps = luaList(cp.get(keys.upvalsKey), keys.lenKey);
          for (const desc of rawUps) {
            if (desc.get(1) === 0) reads.push(boxSlot(desc.get(2)));
          }
        }
      }
      writes.push(ins.dst);
      break;
    }
    case 'SETGLOBAL': case 'SETUPVAL':
      reads.push(ins.src);
      break;
    case 'GETTABLE':
      reads.push(ins.tbl, ins.key);
      writes.push(ins.dst);
      break;
    case 'GETTABLE_IMM':
      reads.push(ins.src);
      writes.push(ins.dst);
      break;
    case 'SETTABLE':
      reads.push(ins.tbl, ins.key, ins.val);
      break;
    case 'SETLIST_MULTRET':
      reads.push(ins.tbl, ins.pack);
      break;
    case 'BINOP':
      reads.push(ins.lhs, ins.rhs);
      writes.push(ins.dst);
      break;
    case 'PACK_ARGS':
      reads.push(...ins.fixedRegs);
      if (ins.tailReg) reads.push(ins.tailReg);
      writes.push(ins.dst);
      break;
    case 'CALL':
      reads.push(ins.fn, ...ins.argsRegs);
      if (ins.mode !== 0) writes.push(ins.dst);
      break;
    case 'CALL_VAR':
      reads.push(ins.fn, ins.pack);
      if (ins.mode !== 0) writes.push(ins.dst);
      break;
    case 'TAILCALL':
      reads.push(ins.fn, ...ins.argsRegs);
      break;
    case 'TAILCALL_VAR':
      reads.push(ins.fn, ins.pack);
      break;
    case 'RETURN':
      reads.push(...ins.srcs);
      break;
    case 'RETURN_UNPACK':
      reads.push(ins.src);
      break;
    case 'FORPREP':
      reads.push(ins.idx, ins.limit, ins.step);
      writes.push(ins.idx);
      break;
    case 'FORLOOP':
      reads.push(ins.idx, ins.limit, ins.step);
      writes.push(ins.dst);
      break;
    case 'JMP_COND':
      reads.push(ins.cond);
      break;
    default:
      break;
  }
  return {
    reads: reads.filter((r) => typeof r === 'number' && r > 0),
    writes: writes.filter((r) => typeof r === 'number' && r > 0),
    kills: kills.filter((r) => typeof r === 'number' && r > 0),
  };
}

function buildRegisterWebs(insts, paramSlots, pinnedSlots, protoId, childProtos, keys) {
  const n = insts.length;
  const succs = Array.from({ length: n + 1 }, () => []);
  for (let pc = 1; pc <= n; pc += 1) {
    const ins = insts[pc - 1];
    if (ins.op === 'JMP') {
      if (ins.target >= 1 && ins.target <= n) succs[pc].push(ins.target);
    } else if (ins.op === 'JMP_COND') {
      if (pc + 1 <= n) succs[pc].push(pc + 1);
      if (ins.target >= 1 && ins.target <= n) succs[pc].push(ins.target);
    } else if (ins.op === 'RETURN' || ins.op === 'RETURN_UNPACK'
      || ins.op === 'TAILCALL' || ins.op === 'TAILCALL_VAR') {
      // terminal
    } else if (pc + 1 <= n) {
      succs[pc].push(pc + 1);
    }
  }

  const rw = [null];
  for (let pc = 1; pc <= n; pc += 1) {
    rw.push(instructionReadsWrites(insts[pc - 1], childProtos, keys));
  }

  const inDefs = Array.from({ length: n + 1 }, () => new Map());
  if (n >= 1) {
    for (const slot of paramSlots.keys()) {
      inDefs[1].set(slot, new Set([0]));
    }
  }

  const queue = n >= 1 ? [1] : [];
  const inQueue = new Set(queue);

  while (queue.length > 0) {
    const pc = queue.shift();
    inQueue.delete(pc);

    const curIn = inDefs[pc];
    const out = new Map();
    for (const [r, set] of curIn.entries()) {
      out.set(r, new Set(set));
    }
    for (const w of rw[pc].writes) {
      if (!pinnedSlots.has(w)) {
        out.set(w, new Set([pc]));
      }
    }

    for (const s of succs[pc]) {
      const targetIn = inDefs[s];
      let changed = false;
      for (const [r, set] of out.entries()) {
        let dstSet = targetIn.get(r);
        if (!dstSet) {
          dstSet = new Set(set);
          targetIn.set(r, dstSet);
          changed = true;
        } else {
          for (const d of set) {
            if (!dstSet.has(d)) {
              dstSet.add(d);
              changed = true;
            }
          }
        }
      }
      if (changed && !inQueue.has(s)) {
        queue.push(s);
        inQueue.add(s);
      }
    }
  }

  const parent = new Map();
  const ensure = (key) => {
    if (!parent.has(key)) parent.set(key, key);
    return key;
  };
  const find = (key) => {
    ensure(key);
    let cur = key;
    while (parent.get(cur) !== cur) cur = parent.get(cur);
    let walkCur = key;
    while (parent.get(walkCur) !== cur) {
      const nxt = parent.get(walkCur);
      parent.set(walkCur, cur);
      walkCur = nxt;
    }
    return cur;
  };
  const union = (a, b) => {
    const ra = find(a);
    const rb = find(b);
    if (ra === rb) return;
    if (ra.endsWith(':0')) parent.set(rb, ra);
    else if (rb.endsWith(':0')) parent.set(ra, rb);
    else parent.set(rb, ra);
  };

  for (const slot of paramSlots.keys()) {
    if (!pinnedSlots.has(slot)) ensure(`${slot}:0`);
  }

  const readRepKey = new Map();
  for (let pc = 1; pc <= n; pc += 1) {
    for (const w of rw[pc].writes) {
      if (!pinnedSlots.has(w)) ensure(`${w}:${pc}`);
    }
    for (const r of rw[pc].reads) {
      if (pinnedSlots.has(r)) continue;
      const defs = inDefs[pc].get(r);
      if (!defs || defs.size === 0) {
        const k0 = ensure(`${r}:0`);
        readRepKey.set(`${pc}:${r}`, k0);
      } else {
        const arr = [...defs].map((d) => ensure(`${r}:${d}`));
        for (let i = 1; i < arr.length; i += 1) {
          union(arr[0], arr[i]);
        }
        readRepKey.set(`${pc}:${r}`, arr[0]);
      }
    }
  }

  const rootToName = new Map();
  let webSeq = 0;
  const nameForRoot = (slot, rootKey) => {
    if (rootToName.has(rootKey)) return rootToName.get(rootKey);
    let nm;
    if (rootKey === `${slot}:0` && paramSlots.has(slot)) {
      nm = paramSlots.get(slot);
    } else {
      webSeq += 1;
      const kindTag = slot >= BOX_OFFSET ? `b${slot - BOX_OFFSET}` : `r${slot}`;
      nm = `_p${protoId}_${kindTag}_w${webSeq}`;
    }
    rootToName.set(rootKey, nm);
    return nm;
  };

  return {
    readName(pc, slot) {
      if (pinnedSlots.has(slot)) {
        if (paramSlots.has(slot)) return paramSlots.get(slot);
        return `_p${protoId}_pin${slot}`;
      }
      const rep = readRepKey.get(`${pc}:${slot}`) || ensure(`${slot}:0`);
      return nameForRoot(slot, find(rep));
    },
    writeName(pc, slot) {
      if (pinnedSlots.has(slot)) {
        if (paramSlots.has(slot)) return paramSlots.get(slot);
        return `_p${protoId}_pin${slot}`;
      }
      const root = find(ensure(`${slot}:${pc}`));
      return nameForRoot(slot, root);
    },
  };
}

function normalizeProtoInstructions(proto, keys, opSlot, opSpecs) {
  const rawInsts = luaList(proto.get(keys.instsKey), keys.lenKey);
  const rawConsts = luaList(proto.get(keys.constsKey), keys.lenKey);
  const insts = [];

  for (let i = 0; i < rawInsts.length; i += 1) {
    const pc = i + 1;
    const raw = rawInsts[i];
    const opCode = raw.get(opSlot);
    const spec = opSpecs.get(opCode);
    if (!spec) {
      throw new Error(`Vmify decompiler: unknown opcode ${opCode} at pc=${pc}`);
    }
    const g = (slot) => (slot != null ? raw.get(slot) : undefined);

    switch (spec.op) {
      case 'LOADK':
        insts.push({ pc, op: 'LOADK', dst: g(spec.dst), val: rawConsts[g(spec.constIdx) - 1] });
        break;
      case 'LOADNIL':
        insts.push({ pc, op: 'LOADNIL', dst: g(spec.dst) });
        break;
      case 'CLEARREG':
        insts.push({ pc, op: 'NOP', cleared: [g(spec.dst)] });
        break;
      case 'CLEARREGS':
        insts.push({ pc, op: 'NOP', cleared: luaList(g(spec.list), keys.lenKey) });
        break;
      case 'MOVE':
        insts.push({ pc, op: 'MOVE', dst: g(spec.dst), src: g(spec.src) });
        break;
      case 'NEWBOX':
        insts.push({ pc, op: 'NEWBOX', dst: g(spec.dst), src: g(spec.src) });
        break;
      case 'GETBOX':
        insts.push({ pc, op: 'GETBOX', dst: g(spec.dst), src: g(spec.src) });
        break;
      case 'SETBOX':
        insts.push({ pc, op: 'SETBOX', dst: g(spec.dst), src: g(spec.src) });
        break;
      case 'GETGLOBAL':
        insts.push({ pc, op: 'GETGLOBAL', dst: g(spec.dst), name: rawConsts[g(spec.constIdx) - 1] });
        break;
      case 'SETGLOBAL':
        insts.push({ pc, op: 'SETGLOBAL', name: rawConsts[g(spec.constIdx) - 1], src: g(spec.src) });
        break;
      case 'GETUPVAL':
        insts.push({ pc, op: 'GETUPVAL', dst: g(spec.dst), upIdx: g(spec.upIdx) });
        break;
      case 'SETUPVAL':
        insts.push({ pc, op: 'SETUPVAL', upIdx: g(spec.upIdx), src: g(spec.src) });
        break;
      case 'NEWTABLE':
        insts.push({ pc, op: 'NEWTABLE', dst: g(spec.dst) });
        break;
      case 'GETTABLE':
        insts.push({ pc, op: 'GETTABLE', dst: g(spec.dst), tbl: g(spec.lhs), key: g(spec.rhs) });
        break;
      case 'GETTABLE_IMM':
        insts.push({ pc, op: 'GETTABLE_IMM', dst: g(spec.dst), src: g(spec.src), idx: g(spec.idxSlot) });
        break;
      case 'SETTABLE':
        insts.push({ pc, op: 'SETTABLE', tbl: g(spec.tbl), key: g(spec.key), val: g(spec.val) });
        break;
      case 'SETLIST_MULTRET':
        insts.push({
          pc,
          op: 'SETLIST_MULTRET',
          tbl: g(spec.tbl),
          pack: g(spec.pack),
          startIdx: g(spec.start),
        });
        break;
      case 'BINOP':
        insts.push({
          pc,
          op: 'BINOP',
          operator: spec.operator,
          dst: g(spec.dst),
          lhs: g(spec.lhs),
          rhs: g(spec.rhs),
        });
        break;
      case 'UNOP':
        insts.push({
          pc,
          op: 'UNOP',
          operator: spec.operator,
          dst: g(spec.dst),
          src: g(spec.src),
        });
        break;
      case 'CLOSURE':
        insts.push({ pc, op: 'CLOSURE', dst: g(spec.dst), protoIdx: g(spec.protoIdx) });
        break;
      case 'VARARG':
        insts.push({ pc, op: 'VARARG', dst: g(spec.dst) });
        break;
      case 'PACK_ARGS':
        insts.push({
          pc,
          op: 'PACK_ARGS',
          dst: g(spec.dst),
          fixedRegs: luaList(g(spec.fixedList), keys.lenKey),
          tailReg: g(spec.tail) || 0,
        });
        break;
      case 'CALL_FIXED':
        insts.push({
          pc,
          op: 'CALL',
          mode: g(spec.mode),
          dst: g(spec.dst),
          fn: g(spec.fn),
          argsRegs: spec.arity === 0 ? [] : luaList(g(spec.argsList), keys.lenKey),
        });
        break;
      case 'CALL_VAR':
        insts.push({
          pc,
          op: 'CALL_VAR',
          mode: g(spec.mode),
          dst: g(spec.dst),
          fn: g(spec.fn),
          pack: g(spec.pack),
        });
        break;
      case 'TAILCALL_FIXED':
        insts.push({
          pc,
          op: 'TAILCALL',
          fn: g(spec.fn),
          argsRegs: spec.arity === 0 ? [] : luaList(g(spec.argsList), keys.lenKey),
        });
        break;
      case 'TAILCALL_VAR':
        insts.push({
          pc,
          op: 'TAILCALL_VAR',
          fn: g(spec.fn),
          pack: g(spec.pack),
        });
        break;
      case 'RETURN_FIXED':
        insts.push({
          pc,
          op: 'RETURN',
          srcs: spec.srcs.map((slot) => g(slot)),
        });
        break;
      case 'RETURN_UNPACK':
        insts.push({ pc, op: 'RETURN_UNPACK', src: g(spec.src) });
        break;
      case 'FORPREP':
        insts.push({ pc, op: 'FORPREP', idx: g(spec.idx), limit: g(spec.limit), step: g(spec.step) });
        break;
      case 'FORLOOP':
        insts.push({
          pc,
          op: 'FORLOOP',
          dst: g(spec.dst),
          idx: g(spec.idx),
          limit: g(spec.limit),
          step: g(spec.step),
        });
        break;
      case 'JMP':
        insts.push({ pc, op: 'JMP', target: g(spec.target) });
        break;
      case 'JMP_COND':
        insts.push({
          pc,
          op: 'JMP_COND',
          truthy: spec.truthy,
          cond: g(spec.cond),
          target: g(spec.target),
        });
        break;
      default:
        throw new Error(`Vmify decompiler: unhandled normalized op ${spec.op}`);
    }
  }
  return insts;
}

function createDecompilerContext(keys, opSlot, opSpecs) {
  let nextProtoId = 0;

  function decompileProto(proto, upvalNames) {
    const protoId = nextProtoId;
    nextProtoId += 1;

    const insts = normalizeProtoInstructions(proto, keys, opSlot, opSpecs);
    const childProtos = luaList(proto.get(keys.protosKey), keys.lenKey);
    const rawParams = luaList(proto.get(keys.paramsKey), keys.lenKey);
    const isVararg = Boolean(proto.get(keys.isVarargKey));

    const paramSlots = new Map();
    const paramNames = [];
    for (const entry of rawParams) {
      const regIdx = entry.get(1);
      const isBoxed = entry.get(2) === true;
      const pName = `_p${protoId}_p${regIdx}`;
      paramNames.push(pName);
      paramSlots.set(isBoxed ? boxSlot(regIdx) : regIdx, pName);
    }
    const paramNameSet = new Set(paramNames);

    const pinnedSlots = new Set();

    const webs = buildRegisterWebs(insts, paramSlots, pinnedSlots, protoId, childProtos, keys);

    const aliasStack = [];
    let loopCounter = 0;

    const lookupAlias = (slot) => {
      for (let i = aliasStack.length - 1; i >= 0; i -= 1) {
        if (aliasStack[i].has(slot)) return aliasStack[i].get(slot);
      }
      return null;
    };

    const readNameAt = (pc, slot) => lookupAlias(slot) || webs.readName(pc, slot);
    const writeNameAt = (pc, slot) => lookupAlias(slot) || webs.writeName(pc, slot);

    const readRef = (pc, slot) => A.name(readNameAt(pc, slot));
    const upvalRef = (upIdx) => A.name(upvalNames[upIdx - 1]);

    const jumpTargets = new Set();
    const backJumpsTo = new Map();
    for (const ins of insts) {
      if (ins.op === 'JMP' || ins.op === 'JMP_COND') {
        jumpTargets.add(ins.target);
        if (ins.op === 'JMP' && ins.target <= ins.pc) {
          if (!backJumpsTo.has(ins.target)) backJumpsTo.set(ins.target, []);
          backJumpsTo.get(ins.target).push(ins.pc);
        }
      }
    }
    for (const list of backJumpsTo.values()) {
      list.sort((a, b) => b - a);
    }

    const at = (pc) => insts[pc - 1];
    const skipNopForward = (pc, endPc) => {
      let cur = pc;
      while (cur < endPc && at(cur).op === 'NOP') cur += 1;
      return cur;
    };
    const skipNopBackward = (pc, startPc) => {
      let cur = pc;
      while (cur >= startPc && at(cur).op === 'NOP') cur -= 1;
      return cur;
    };

    const boxSpans = new Map();
    const noteBoxUse = (varName, pc, isNewbox) => {
      if (!varName) return;
      let sp = boxSpans.get(varName);
      if (!sp) {
        sp = { newboxCount: 0, minPc: pc, maxPc: pc };
        boxSpans.set(varName, sp);
      } else {
        if (pc < sp.minPc) sp.minPc = pc;
        if (pc > sp.maxPc) sp.maxPc = pc;
      }
      if (isNewbox) sp.newboxCount += 1;
    };
    for (const ins of insts) {
      if (ins.op === 'NEWBOX') {
        noteBoxUse(writeNameAt(ins.pc, boxSlot(ins.dst)), ins.pc, true);
      } else if (ins.op === 'GETBOX') {
        noteBoxUse(readNameAt(ins.pc, boxSlot(ins.src)), ins.pc, false);
      } else if (ins.op === 'SETBOX') {
        noteBoxUse(readNameAt(ins.pc, boxSlot(ins.dst)), ins.pc, false);
      } else if (ins.op === 'CLOSURE') {
        const childProto = childProtos ? childProtos[ins.protoIdx - 1] : null;
        const childUpvals = childProto ? luaList(childProto.get(keys.upvalsKey), keys.lenKey) : [];
        for (const desc of childUpvals) {
          if (desc instanceof Map && desc.get(1) === 0) {
            noteBoxUse(readNameAt(ins.pc, boxSlot(desc.get(2))), ins.pc, false);
          }
        }
      }
    }

    const inlineDeclaredBoxSet = new Set();
    const declaredVarNames = [];
    const declaredVarSet = new Set();
    const ensureDeclared = (varName) => {
      if (!varName || paramNameSet.has(varName) || inlineDeclaredBoxSet.has(varName)) return;
      for (let i = aliasStack.length - 1; i >= 0; i -= 1) {
        for (const v of aliasStack[i].values()) {
          if (v === varName) return;
        }
      }
      if (!declaredVarSet.has(varName)) {
        declaredVarSet.add(varName);
        declaredVarNames.push(varName);
      }
    };

    const virtualTuple = new Map();
    const virtualPack = new Map();

    const makeCallExpr = (ins) => {
      const pc = ins.pc;
      if (ins.op === 'CALL' || ins.op === 'TAILCALL') {
        return A.call(readRef(pc, ins.fn), ins.argsRegs.map((r) => readRef(pc, r)));
      }
      const packArgs = virtualPack.get(ins.pack);
      if (packArgs) {
        virtualPack.delete(ins.pack);
        return A.call(readRef(pc, ins.fn), packArgs);
      }
      return A.call(readRef(pc, ins.fn), [A.call(A.name('unpack'), [readRef(pc, ins.pack)])]);
    };

    const consumeTupleExpr = (pc, regIdx) => {
      const vt = virtualTuple.get(regIdx);
      if (vt) {
        virtualTuple.delete(regIdx);
        return vt;
      }
      return A.call(A.name('unpack'), [readRef(pc, regIdx)]);
    };

    function countLaterReadsBeforeOverwrite(fromPc, endPc, targetSlot) {
      let count = 0;
      for (let p = fromPc; p < endPc; p += 1) {
        const ins = at(p);
        const { reads, writes, kills } = instructionReadsWrites(ins, childProtos, keys);
        for (const r of reads) {
          if (r === targetSlot) count += 1;
        }
        if (writes.includes(targetSlot) || kills.includes(targetSlot)) break;
        if (ins.op === 'JMP' || ins.op === 'JMP_COND') {
          return count + 2;
        }
        if (ins.op === 'RETURN' || ins.op === 'RETURN_UNPACK'
          || ins.op === 'TAILCALL' || ins.op === 'TAILCALL_VAR') {
          break;
        }
      }
      return count;
    }

    function matchNumericFor(pc, endPc) {
      const prep = at(pc);
      if (prep.op !== 'FORPREP' || pc + 2 >= endPc) return null;
      const loop = at(pc + 1);
      const jcond = at(pc + 2);
      if (loop.op !== 'JMP_COND' && loop.op !== 'FORLOOP') return null;
      if (loop.op !== 'FORLOOP' || loop.idx !== prep.idx) return null;
      if (jcond.op !== 'JMP_COND' || jcond.truthy !== false || jcond.cond !== loop.dst) return null;
      const exitPc = jcond.target;
      if (exitPc > endPc || exitPc - 1 <= pc + 2) return null;
      const backJmp = at(exitPc - 1);
      if (backJmp.op !== 'JMP' || backJmp.target !== pc + 1) return null;
      const lastBodyPc = skipNopBackward(exitPc - 2, pc + 3);
      if (lastBodyPc < pc + 3) return null;
      let stepAddPc = -1;
      const tail = at(lastBodyPc);
      if (tail.op === 'BINOP' && tail.operator === '+'
        && tail.dst === prep.idx && tail.lhs === prep.idx && tail.rhs === prep.step) {
        stepAddPc = lastBodyPc;
      } else if (tail.op === 'MOVE' && tail.dst === prep.idx) {
        const prevPc = skipNopBackward(lastBodyPc - 1, pc + 3);
        if (prevPc >= pc + 3) {
          const prev = at(prevPc);
          if (prev.op === 'BINOP' && prev.operator === '+'
            && prev.dst === tail.src && prev.lhs === prep.idx && prev.rhs === prep.step) {
            stepAddPc = prevPc;
          }
        }
      }
      if (stepAddPc < pc + 3) return null;

      let bodyStart = skipNopForward(pc + 3, stepAddPc);
      let userSlot = prep.idx;
      if (bodyStart < stepAddPc) {
        const first = at(bodyStart);
        if ((first.op === 'MOVE' || first.op === 'NEWBOX')
          && first.src === prep.idx && !jumpTargets.has(bodyStart + 1)) {
          userSlot = first.op === 'NEWBOX' ? boxSlot(first.dst) : first.dst;
          bodyStart += 1;
        }
      }
      return {
        prep,
        exitPc,
        bodyStart,
        bodyEnd: stepAddPc,
        userSlot,
      };
    }

    function matchGenericFor(pc, endPc) {
      const initCall = at(pc);
      if ((initCall.op !== 'CALL' && initCall.op !== 'CALL_VAR') || initCall.mode !== -1) {
        return null;
      }
      const tupReg = initCall.dst;
      let cur = skipNopForward(pc + 1, endPc);
      const stateRegs = [];
      for (let k = 1; k <= 3; k += 1) {
        if (cur >= endPc) return null;
        const gi = at(cur);
        if (gi.op !== 'GETTABLE_IMM' || gi.src !== tupReg || gi.idx !== k) return null;
        stateRegs.push(gi.dst);
        cur = skipNopForward(cur + 1, endPc);
      }
      const [fReg, sReg, varReg] = stateRegs;
      const hdrPc = cur;
      if (hdrPc >= endPc || !backJumpsTo.has(hdrPc)) return null;
      const backList = backJumpsTo.get(hdrPc).filter((b) => b + 1 <= endPc && b > hdrPc);
      if (!backList.length) return null;
      const backPc = backList[0];
      const exitPc = backPc + 1;

      const stepCall = at(hdrPc);
      if (stepCall.op !== 'CALL' || stepCall.mode !== -1 || stepCall.fn !== fReg) return null;
      if (stepCall.argsRegs.length !== 2
        || stepCall.argsRegs[0] !== sReg || stepCall.argsRegs[1] !== varReg) {
        return null;
      }
      const stepTup = stepCall.dst;
      cur = skipNopForward(hdrPc + 1, backPc);
      if (cur >= backPc) return null;
      const g1 = at(cur);
      if (g1.op !== 'GETTABLE_IMM' || g1.src !== stepTup || g1.idx !== 1) return null;
      const t1Reg = g1.dst;

      cur = skipNopForward(cur + 1, backPc);
      if (cur >= backPc || at(cur).op !== 'LOADNIL') return null;
      const nilReg = at(cur).dst;

      cur = skipNopForward(cur + 1, backPc);
      if (cur >= backPc || at(cur).op !== 'BINOP' || at(cur).operator !== '==') return null;
      const eqIns = at(cur);
      const matchesEq = (eqIns.lhs === t1Reg && eqIns.rhs === nilReg)
        || (eqIns.lhs === nilReg && eqIns.rhs === t1Reg);
      if (!matchesEq) return null;

      cur = skipNopForward(cur + 1, backPc);
      if (cur >= backPc) return null;
      const jc = at(cur);
      if (jc.op !== 'JMP_COND' || jc.truthy !== true
        || jc.cond !== eqIns.dst || jc.target !== exitPc) {
        return null;
      }

      cur = skipNopForward(cur + 1, backPc);
      if (cur >= backPc || at(cur).op !== 'MOVE'
        || at(cur).dst !== varReg || at(cur).src !== t1Reg) {
        return null;
      }

      cur = skipNopForward(cur + 1, backPc);
      const userVarSlots = [];
      let nextIdx = 1;
      while (cur < backPc) {
        const gi = at(cur);
        if (gi.op !== 'GETTABLE_IMM' || gi.src !== stepTup || gi.idx !== nextIdx) break;
        let varSlot = gi.dst;
        const afterGi = skipNopForward(cur + 1, backPc);
        if (afterGi < backPc && (at(afterGi).op === 'MOVE' || at(afterGi).op === 'NEWBOX')
          && at(afterGi).src === gi.dst) {
          varSlot = at(afterGi).op === 'NEWBOX' ? boxSlot(at(afterGi).dst) : at(afterGi).dst;
          cur = skipNopForward(afterGi + 1, backPc);
        } else {
          cur = afterGi;
        }
        userVarSlots.push(varSlot);
        nextIdx += 1;
      }
      if (!userVarSlots.length) return null;

      return {
        initCall,
        exitPc,
        bodyStart: cur,
        bodyEnd: backPc,
        userVarSlots,
      };
    }

    function matchGeneralLoop(pc, endPc, handledHeaders) {
      if (!backJumpsTo.has(pc) || handledHeaders.has(pc)) return null;
      const candidates = backJumpsTo.get(pc).filter((b) => b >= pc && b + 1 <= endPc);
      if (!candidates.length) return null;
      const backPc = candidates[0];
      const exitPc = backPc + 1;

      const lastNonNop = skipNopBackward(backPc - 1, pc);
      if (lastNonNop >= pc) {
        const tailIns = at(lastNonNop);
        if (tailIns.op === 'JMP_COND' && tailIns.target === exitPc) {
          return {
            kind: 'repeat',
            condPc: lastNonNop,
            condIns: tailIns,
            backPc,
            exitPc,
          };
        }
      }
      return {
        kind: 'while',
        backPc,
        exitPc,
      };
    }

    function makeCondExpr(pc, condReg, jumpOnTrue) {
      const ref = readRef(pc, condReg);
      return jumpOnTrue ? ref : negateExpr(ref);
    }

    const handledLoopHeaders = new Set();

    function structureRange(startPc, endPc, loopExitPc) {
      const stmts = [];
      let pc = startPc;

      const assignSlotWrite = (atPc, dstSlot, expr) => {
        const wName = writeNameAt(atPc, dstSlot);
        ensureDeclared(wName);
        stmts.push(A.assignment([A.name(wName)], [expr]));
      };

      const assignSlotMutate = (atPc, dstSlot, expr) => {
        const rName = readNameAt(atPc, dstSlot);
        ensureDeclared(rName);
        stmts.push(A.assignment([A.name(rName)], [expr]));
      };

      while (pc < endPc) {
        const numFor = matchNumericFor(pc, endPc);
        if (numFor) {
          loopCounter += 1;
          const loopVar = `_p${protoId}_i${loopCounter}`;
          const alias = new Map([[numFor.userSlot, loopVar]]);
          if (numFor.userSlot !== numFor.prep.idx) {
            alias.set(numFor.prep.idx, loopVar);
          }
          const startExpr = readRef(pc, numFor.prep.idx);
          const limitExpr = readRef(pc, numFor.prep.limit);
          const stepExpr = readRef(pc, numFor.prep.step);
          aliasStack.push(alias);
          const body = structureRange(numFor.bodyStart, numFor.bodyEnd, numFor.exitPc);
          aliasStack.pop();
          stmts.push(A.numericFor(loopVar, startExpr, limitExpr, stepExpr, body));
          pc = numFor.exitPc;
          continue;
        }

        const genFor = matchGenericFor(pc, endPc);
        if (genFor) {
          const iterExpr = makeCallExpr(genFor.initCall);
          loopCounter += 1;
          const alias = new Map();
          const loopVars = genFor.userVarSlots.map((s, idx) => {
            const vName = `_p${protoId}_v${loopCounter}_${idx + 1}`;
            alias.set(s, vName);
            return vName;
          });
          aliasStack.push(alias);
          const body = structureRange(genFor.bodyStart, genFor.bodyEnd, genFor.exitPc);
          aliasStack.pop();
          stmts.push(A.genericFor(loopVars, [iterExpr], body));
          pc = genFor.exitPc;
          continue;
        }

        const genLoop = matchGeneralLoop(pc, endPc, handledLoopHeaders);
        if (genLoop) {
          handledLoopHeaders.add(pc);
          if (genLoop.kind === 'repeat') {
            const body = structureRange(pc, genLoop.condPc, genLoop.exitPc);
            let untilCond = makeCondExpr(genLoop.condPc, genLoop.condIns.cond, genLoop.condIns.truthy);
            const bodyStmts = body.statements;
            if (bodyStmts.length > 0) {
              const last = bodyStmts[bodyStmts.length - 1];
              const condName = readNameAt(genLoop.condPc, genLoop.condIns.cond);
              if (last.kind === Kind.Assignment
                && last.targets.length === 1
                && last.targets[0].kind === Kind.Name
                && last.targets[0].name === condName
                && countLaterReadsBeforeOverwrite(genLoop.exitPc, insts.length + 1, genLoop.condIns.cond) === 0) {
                const rhs = last.expressions[0];
                bodyStmts.pop();
                untilCond = genLoop.condIns.truthy ? rhs : negateExpr(rhs);
              }
            }
            stmts.push(A.repeatStatement(body, untilCond));
            pc = genLoop.exitPc;
            continue;
          }

          const body = structureRange(pc, genLoop.backPc, genLoop.exitPc);
          stmts.push(A.whileStatement(A.boolean(true), body));
          pc = genLoop.exitPc;
          continue;
        }

        const ins = at(pc);

        if (ins.op === 'NOP') {
          pc += 1;
          continue;
        }

        if (ins.op === 'JMP') {
          if (ins.target === pc + 1) {
            pc += 1;
            continue;
          }
          if (loopExitPc != null && ins.target === loopExitPc) {
            stmts.push(A.breakStatement());
            pc = endPc;
            continue;
          }
          throw new Error(`Vmify decompiler: unexpected JMP at pc=${pc} -> ${ins.target} (end=${endPc}, loopExit=${loopExitPc})`);
        }

        if (ins.op === 'JMP_COND') {
          if (loopExitPc != null && ins.target === loopExitPc) {
            const brkCond = makeCondExpr(pc, ins.cond, ins.truthy);
            stmts.push(A.ifStatement(brkCond, A.block([A.breakStatement()])));
            pc += 1;
            continue;
          }

          const targetPc = ins.target;
          if (targetPc <= pc || targetPc > endPc) {
            throw new Error(`Vmify decompiler: out-of-range JMP_COND at pc=${pc} -> ${targetPc} (end=${endPc})`);
          }

          const stayCond = makeCondExpr(pc, ins.cond, !ins.truthy);
          const prevIns = at(targetPc - 1);
          if (prevIns.op === 'JMP' && prevIns.target >= targetPc && prevIns.target <= endPc) {
            const joinPc = prevIns.target;
            const thenBlock = structureRange(pc + 1, targetPc - 1, loopExitPc);
            if (joinPc === targetPc) {
              if (thenBlock.statements.length > 0) {
                stmts.push(A.ifStatement(stayCond, thenBlock));
              }
              pc = targetPc;
              continue;
            }
            const elseBlock = structureRange(targetPc, joinPc, loopExitPc);
            if (thenBlock.statements.length === 0 && elseBlock.statements.length > 0) {
              stmts.push(A.ifStatement(makeCondExpr(pc, ins.cond, ins.truthy), elseBlock));
            } else if (elseBlock.statements.length === 0) {
              if (thenBlock.statements.length > 0) {
                stmts.push(A.ifStatement(stayCond, thenBlock));
              }
            } else {
              stmts.push(A.ifStatement(stayCond, thenBlock, [], elseBlock));
            }
            pc = joinPc;
            continue;
          }

          const thenBlock = structureRange(pc + 1, targetPc, loopExitPc);
          if (thenBlock.statements.length > 0) {
            stmts.push(A.ifStatement(stayCond, thenBlock));
          }
          pc = targetPc;
          continue;
        }

        switch (ins.op) {
          case 'LOADK':
            assignSlotWrite(pc, ins.dst, literalToAst(ins.val));
            pc += 1;
            break;
          case 'LOADNIL': {
            // Check `local function f`: LOADNIL rX -> NEWBOX bY=rX -> CLOSURE rZ=P -> SETBOX bY=rZ
            const p1 = skipNopForward(pc + 1, endPc);
            if (p1 < endPc && !jumpTargets.has(p1)) {
              const i1 = at(p1);
              if (i1.op === 'CLOSURE' && i1.dst === ins.dst) {
                ensureDeclared(writeNameAt(pc, ins.dst));
                pc += 1;
                break;
              }
              if (i1.op === 'NEWBOX' && i1.src === ins.dst
                && countLaterReadsBeforeOverwrite(p1 + 1, endPc, ins.dst) === 0) {
                const p2 = skipNopForward(p1 + 1, endPc);
                if (p2 < endPc && !jumpTargets.has(p2) && at(p2).op === 'CLOSURE') {
                  const p3 = skipNopForward(p2 + 1, endPc);
                  if (p3 < endPc && !jumpTargets.has(p3)
                    && at(p3).op === 'SETBOX'
                    && at(p3).dst === i1.dst
                    && at(p3).src === at(p2).dst) {
                    ensureDeclared(writeNameAt(p1, boxSlot(i1.dst)));
                    pc = p2;
                    break;
                  }
                }
              }
            }
            assignSlotWrite(pc, ins.dst, A.nil());
            pc += 1;
            break;
          }
          case 'MOVE': {
            const wName = writeNameAt(pc, ins.dst);
            const rName = readNameAt(pc, ins.src);
            if (wName !== rName) {
              assignSlotWrite(pc, ins.dst, A.name(rName));
            }
            pc += 1;
            break;
          }
          case 'NEWBOX': {
            const wName = writeNameAt(pc, boxSlot(ins.dst));
            const sp = boxSpans.get(wName);
            const valExpr = readRef(pc, ins.src);
            if (!paramNameSet.has(wName)
              && sp && sp.newboxCount === 1
              && sp.minPc >= pc && sp.maxPc < endPc) {
              inlineDeclaredBoxSet.add(wName);
              stmts.push(A.localDecl([wName], [valExpr]));
            } else {
              assignSlotWrite(pc, boxSlot(ins.dst), valExpr);
            }
            pc += 1;
            break;
          }
          case 'GETBOX':
            assignSlotWrite(pc, ins.dst, readRef(pc, boxSlot(ins.src)));
            pc += 1;
            break;
          case 'SETBOX':
            assignSlotMutate(pc, boxSlot(ins.dst), readRef(pc, ins.src));
            pc += 1;
            break;
          case 'GETGLOBAL':
            assignSlotWrite(pc, ins.dst, globalRef(ins.name));
            pc += 1;
            break;
          case 'SETGLOBAL':
            stmts.push(A.assignment([globalRef(ins.name)], [readRef(pc, ins.src)]));
            pc += 1;
            break;
          case 'GETUPVAL':
            assignSlotWrite(pc, ins.dst, upvalRef(ins.upIdx));
            pc += 1;
            break;
          case 'SETUPVAL':
            stmts.push(A.assignment([upvalRef(ins.upIdx)], [readRef(pc, ins.src)]));
            pc += 1;
            break;
          case 'NEWTABLE':
            assignSlotWrite(pc, ins.dst, A.table([]));
            pc += 1;
            break;
          case 'GETTABLE':
            assignSlotWrite(pc, ins.dst, A.index(readRef(pc, ins.tbl), readRef(pc, ins.key), false));
            pc += 1;
            break;
          case 'GETTABLE_IMM':
            assignSlotWrite(pc, ins.dst, A.index(readRef(pc, ins.src), A.number(ins.idx), false));
            pc += 1;
            break;
          case 'SETTABLE':
            stmts.push(A.assignment(
              [A.index(readRef(pc, ins.tbl), readRef(pc, ins.key), false)],
              [readRef(pc, ins.val)],
            ));
            pc += 1;
            break;
          case 'SETLIST_MULTRET': {
            const packExprs = virtualPack.get(ins.pack) || [A.call(A.name('unpack'), [readRef(pc, ins.pack)])];
            virtualPack.delete(ins.pack);
            const tblName = readNameAt(pc, ins.tbl);
            let emptyInitIdx = -1;
            if (ins.startIdx === 1) {
              for (let s = stmts.length - 1; s >= 0; s -= 1) {
                const st = stmts[s];
                if (st.kind === Kind.Assignment
                  && st.targets.length === 1
                  && st.targets[0].kind === Kind.Name
                  && st.targets[0].name === tblName
                  && st.expressions.length === 1
                  && st.expressions[0].kind === Kind.Table
                  && st.expressions[0].entries.length === 0) {
                  let mentionedBetween = false;
                  for (let mid = s + 1; mid < stmts.length; mid += 1) {
                    if (mentionsIdent(stmts[mid], tblName)) {
                      mentionedBetween = true;
                      break;
                    }
                  }
                  for (const pe of packExprs) {
                    if (mentionsIdent(pe, tblName)) {
                      mentionedBetween = true;
                      break;
                    }
                  }
                  if (!mentionedBetween) emptyInitIdx = s;
                  break;
                }
                if (mentionsIdent(st, tblName)) break;
              }
            }
            if (emptyInitIdx >= 0) {
              stmts.splice(emptyInitIdx, 1);
              ensureDeclared(tblName);
              stmts.push(A.assignment(
                [A.name(tblName)],
                [A.table(packExprs.map((v) => ({ type: 'item', value: v })))],
              ));
            } else {
              for (let k = 0; k < packExprs.length; k += 1) {
                stmts.push(A.assignment(
                  [A.index(A.name(tblName), A.number(ins.startIdx + k), false)],
                  [packExprs[k]],
                ));
              }
            }
            pc += 1;
            break;
          }
          case 'BINOP':
            assignSlotWrite(pc, ins.dst, A.binary(ins.operator, readRef(pc, ins.lhs), readRef(pc, ins.rhs)));
            pc += 1;
            break;
          case 'UNOP':
            assignSlotWrite(pc, ins.dst, A.unary(ins.operator, readRef(pc, ins.src)));
            pc += 1;
            break;
          case 'CLOSURE': {
            const childProto = childProtos[ins.protoIdx - 1];
            const rawUpvals = luaList(childProto.get(keys.upvalsKey), keys.lenKey);
            const childUpvalNames = rawUpvals.map((desc) => {
              const mode = desc.get(1);
              const idx = desc.get(2);
              if (mode === 0) return readNameAt(pc, boxSlot(idx));
              return upvalNames[idx - 1];
            });
            const fnAst = decompileProto(childProto, childUpvalNames);
            assignSlotWrite(pc, ins.dst, fnAst);
            pc += 1;
            break;
          }
          case 'VARARG':
          case 'CALL':
          case 'CALL_VAR': {
            if (ins.op !== 'VARARG' && ins.mode === 0) {
              stmts.push(A.callStatement(makeCallExpr(ins)));
              pc += 1;
              break;
            }
            if (ins.op !== 'VARARG' && ins.mode === 1) {
              assignSlotWrite(pc, ins.dst, makeCallExpr(ins));
              pc += 1;
              break;
            }
            const multiExpr = ins.op === 'VARARG' ? A.vararg() : makeCallExpr(ins);
            const tupReg = ins.dst;
            const nextPc = skipNopForward(pc + 1, endPc);
            if (nextPc < endPc && !jumpTargets.has(nextPc)) {
              const nextIns = at(nextPc);
              if ((nextIns.op === 'PACK_ARGS' && nextIns.tailReg === tupReg
                && countLaterReadsBeforeOverwrite(nextPc + 1, endPc, tupReg) === 0)
                || (nextIns.op === 'RETURN_UNPACK' && nextIns.src === tupReg)) {
                virtualTuple.set(tupReg, multiExpr);
                pc += 1;
                break;
              }
            }
            const extractedTargets = [];
            let scanPc = nextPc;
            let expectedIdx = 1;
            while (scanPc < endPc && !jumpTargets.has(scanPc)) {
              const gi = at(scanPc);
              if (gi.op !== 'GETTABLE_IMM' || gi.src !== tupReg || gi.idx !== expectedIdx) break;
              if (gi.dst === tupReg) break;
              const tName = writeNameAt(scanPc, gi.dst);
              extractedTargets.push(tName);
              expectedIdx += 1;
              scanPc = skipNopForward(scanPc + 1, endPc);
            }
            if (extractedTargets.length > 0
              && countLaterReadsBeforeOverwrite(scanPc, endPc, tupReg) === 0) {
              for (const nm of extractedTargets) ensureDeclared(nm);
              stmts.push(A.assignment(extractedTargets.map((nm) => A.name(nm)), [multiExpr]));
              pc = scanPc;
              break;
            }
            assignSlotWrite(pc, tupReg, A.table([{ type: 'item', value: multiExpr }]));
            pc += 1;
            break;
          }
          case 'PACK_ARGS': {
            const exprs = ins.fixedRegs.map((r) => readRef(pc, r));
            if (ins.tailReg) {
              exprs.push(consumeTupleExpr(pc, ins.tailReg));
            }
            const laterReads = countLaterReadsBeforeOverwrite(pc + 1, endPc, ins.dst);
            if (laterReads <= 1) {
              virtualPack.set(ins.dst, exprs);
            } else {
              assignSlotWrite(pc, ins.dst, A.table(exprs.map((v) => ({ type: 'item', value: v }))));
            }
            pc += 1;
            break;
          }
          case 'TAILCALL':
          case 'TAILCALL_VAR':
            stmts.push(A.returnStatement([makeCallExpr(ins)]));
            pc += 1;
            break;
          case 'RETURN':
            stmts.push(A.returnStatement(ins.srcs.map((r) => readRef(pc, r))));
            pc += 1;
            break;
          case 'RETURN_UNPACK':
            stmts.push(A.returnStatement([consumeTupleExpr(pc, ins.src)]));
            pc += 1;
            break;
          default:
            throw new Error(`Vmify decompiler: unhandled instruction ${ins.op} at pc=${pc}`);
        }
      }

      return A.block(stmts);
    }

    const bodyBlock = structureRange(1, insts.length + 1, null);
    const bodyStmts = bodyBlock.statements;
    if (bodyStmts.length > 0) {
      const last = bodyStmts[bodyStmts.length - 1];
      if (last.kind === Kind.Return && last.expressions.length === 0) {
        bodyStmts.pop();
      }
    }

    if (declaredVarNames.length > 0) {
      bodyStmts.unshift(A.localDecl(declaredVarNames, []));
    }

    return A.func(paramNames, A.block(bodyStmts), isVararg);
  }

  return { decompileProto };
}

function countIdentMentions(root, identName) {
  let count = 0;
  if (!root) return 0;
  walk(root, {
    enter(cur) {
      if (cur.kind === Kind.Name && cur.name === identName) count += 1;
      return undefined;
    },
  });
  return count;
}

function mentionsBindingOrName(node, binding, identName) {
  let found = false;
  if (!node) return false;
  walk(node, {
    enter(cur) {
      if (found) return false;
      if (cur.kind === Kind.Name) {
        if (binding && cur.binding) {
          if (cur.binding === binding) {
            found = true;
            return false;
          }
        } else if (cur.name === identName) {
          found = true;
          return false;
        }
      }
      return undefined;
    },
  });
  return found;
}

function polishDecompiledAst(chunk) {
  let changes = 0;
  walk(chunk, {
    leave(node) {
      if (node.kind === Kind.NumericFor && node.step
        && node.step.kind === Kind.Number && node.step.value === 1) {
        node.step = null;
        changes += 1;
      }
      if (node.kind === Kind.Repeat && node.body && Array.isArray(node.body.statements)) {
        const rStmts = node.body.statements;
        while (rStmts.length > 0) {
          const tail = rStmts[rStmts.length - 1];
          if (tail.kind === Kind.Assignment
            && tail.targets.length === 1
            && tail.targets[0].kind === Kind.Name
            && tail.expressions.length === 1
            && (tail.expressions[0].kind === Kind.Name || A.isLiteral(tail.expressions[0]))) {
            const tb = tail.targets[0].binding;
            if (tb && tb.writes.length === 1 && tb.reads.length === 1
              && mentionsBindingOrName(node.condition, tb, tail.targets[0].name)) {
              const rep = tail.expressions[0];
              const replaceIn = (cur) => {
                if (!cur || typeof cur !== 'object') return cur;
                if (cur.kind === Kind.Name && cur.binding === tb) return rep;
                for (const k of Object.keys(cur)) {
                  if (k === 'binding' || k === 'bindings' || k === 'declaration') continue;
                  if (cur[k] && typeof cur[k] === 'object' && cur[k].kind) {
                    cur[k] = replaceIn(cur[k]);
                  }
                }
                return cur;
              };
              node.condition = replaceIn(node.condition);
              rStmts.pop();
              changes += 1;
              continue;
            }
          }
          break;
        }
      }
      if (node.kind !== Kind.Block || !Array.isArray(node.statements)) return;
      const stmts = node.statements;

      // 0) Fold `local f = next; local st = nil; while true do local k, v = f(tbl, st); if k == nil then break end; st = k; ... end`
      for (let i = 0; i < stmts.length - 2; i += 1) {
        const s0 = stmts[i];
        const s1 = stmts[i + 1];
        const s2 = stmts[i + 2];
        if (s0.kind === Kind.LocalDeclaration && s0.names.length === 1
          && s0.expressions && s0.expressions.length === 1
          && s0.expressions[0].kind === Kind.Name && s0.expressions[0].name === 'next'
          && s1.kind === Kind.LocalDeclaration && s1.names.length === 1
          && (!s1.expressions || s1.expressions.length === 0
            || (s1.expressions.length === 1 && s1.expressions[0].kind === Kind.Nil))
          && s2.kind === Kind.While
          && s2.condition.kind === Kind.True
          && s2.body && s2.body.statements.length >= 3) {
          const wStmts = s2.body.statements;
          const w0 = wStmts[0];
          const w1 = wStmts[1];
          const w2 = wStmts[2];
          if (w0.kind === Kind.LocalDeclaration && w0.names.length >= 1
            && w0.expressions && w0.expressions.length === 1
            && w0.expressions[0].kind === Kind.Call
            && w0.expressions[0].base.kind === Kind.Name
            && w0.expressions[0].base.name === s0.names[0]
            && w0.expressions[0].args.length === 2
            && w0.expressions[0].args[1].kind === Kind.Name
            && w0.expressions[0].args[1].name === s1.names[0]
            && w1.kind === Kind.If
            && w1.body.statements.length === 1 && w1.body.statements[0].kind === Kind.Break
            && w2.kind === Kind.Assignment && w2.targets.length === 1
            && w2.targets[0].kind === Kind.Name && w2.targets[0].name === s1.names[0]
            && w2.expressions.length === 1 && w2.expressions[0].kind === Kind.Name
            && w2.expressions[0].name === w0.names[0]) {
            const tblExpr = w0.expressions[0].args[0];
            const restBody = A.block(wStmts.slice(3));
            stmts.splice(i, 3, A.genericFor(w0.names.slice(), [A.name('next'), tblExpr], restBody));
            changes += 1;
          }
        }
      }

      // 1) Inline single-use literal local keys right before `tbl[k] = val`
      for (let i = 0; i < stmts.length - 1; i += 1) {
        const st = stmts[i];
        const next = stmts[i + 1];
        if (st.kind === Kind.LocalDeclaration
          && st.names.length === 1
          && st.expressions && st.expressions.length === 1
          && A.isLiteral(st.expressions[0])
          && next.kind === Kind.Assignment
          && next.targets.length === 1
          && next.targets[0].kind === Kind.Index
          && next.targets[0].index.kind === Kind.Name
          && next.targets[0].index.name === st.names[0]) {
          const b = st.bindings && st.bindings[0];
          const singleRead = b
            ? (b.writes.length === 0 && b.reads.length === 1 && next.targets[0].index.binding === b)
            : (countIdentMentions(chunk, st.names[0]) === 1);
          if (singleRead) {
            next.targets[0].index = st.expressions[0];
            stmts.splice(i, 1);
            changes += 1;
            i -= 1;
          }
        }
      }

      // 2) Fold consecutive table assignments `tbl.field = val` / `tbl[idx] = val` into `tbl = { ... }`
      for (let i = 0; i < stmts.length; i += 1) {
        const st = stmts[i];
        let tblIdent = null;
        let tblBinding = null;
        let tblNode = null;
        if (st.kind === Kind.LocalDeclaration
          && st.names.length === 1
          && st.expressions && st.expressions.length === 1
          && st.expressions[0].kind === Kind.Table) {
          tblIdent = st.names[0];
          tblBinding = st.bindings && st.bindings[0];
          tblNode = st.expressions[0];
        } else if (st.kind === Kind.Assignment
          && st.targets.length === 1
          && st.targets[0].kind === Kind.Name
          && st.expressions.length === 1
          && st.expressions[0].kind === Kind.Table) {
          tblIdent = st.targets[0].name;
          tblBinding = st.targets[0].binding;
          tblNode = st.expressions[0];
        }
        if (!tblIdent || !tblNode) continue;

        const seenFieldKeys = new Set();
        let nextArrayIdx = 1;
        for (const entry of tblNode.entries) {
          if (entry.type === 'item') nextArrayIdx += 1;
          else {
            nextArrayIdx = -1;
            if (entry.type === 'key' && entry.key && entry.key.kind === Kind.String) {
              seenFieldKeys.add(`s:${entry.key.value}`);
            } else if (entry.type === 'key' && entry.key && entry.key.kind === Kind.Number) {
              seenFieldKeys.add(`n:${entry.key.value}`);
            }
          }
        }

        let j = i + 1;
        while (j < stmts.length) {
          const cur = stmts[j];
          if (cur.kind !== Kind.Assignment
            || cur.targets.length !== 1
            || cur.expressions.length !== 1) {
            break;
          }
          const tgt = cur.targets[0];
          const val = cur.expressions[0];
          if (tgt.kind !== Kind.Index
            || tgt.base.kind !== Kind.Name
            || tgt.base.name !== tblIdent
            || (tblBinding && tgt.base.binding && tgt.base.binding !== tblBinding)) {
            break;
          }
          if (mentionsBindingOrName(tgt.index, tblBinding, tblIdent)
            || mentionsBindingOrName(val, tblBinding, tblIdent)) {
            break;
          }
          const key = tgt.index;
          let keySig = null;
          if (key.kind === Kind.String) keySig = `s:${key.value}`;
          else if (key.kind === Kind.Number) keySig = `n:${key.value}`;
          if (keySig && seenFieldKeys.has(keySig)) break;
          if (keySig) seenFieldKeys.add(keySig);

          if (nextArrayIdx > 0 && key.kind === Kind.Number && key.value === nextArrayIdx) {
            tblNode.entries.push({ type: 'item', value: val });
            nextArrayIdx += 1;
          } else {
            tblNode.entries.push({ type: 'key', key, value: val });
            nextArrayIdx = -1;
          }
          changes += 1;
          j += 1;
        }
        if (j > i + 1) {
          stmts.splice(i + 1, j - (i + 1));
        }
      }
    },
  });
  return changes;
}

function decompileVmifyRoot(rootProto, keys, opSlot, opSpecs) {
  const ctx = createDecompilerContext(keys, opSlot, opSpecs);
  return ctx.decompileProto(rootProto, []);
}

module.exports = {
  decompileVmifyRoot,
  polishDecompiledAst,
};
