'use strict';

const { Kind } = require('../lua/ast');
const { walk } = require('../lua/walk');
const { peel, evalConstScalar, rootBindingOf, luaArray } = require('./detect');

const BIN_OPS = new Set(['+', '-', '*', '/', '%', '^', '..', '==', '~=', '<', '<=', '>', '>=']);

function analyzeVmOpcodes(detected) {
  const { vmFn, whileNode, single, rootProto } = detected;
  const params = vmFn.bindings || [];
  if (params.length !== 5) return null;
  const [protoParam, upvalsParam, envParam, regsParam, varargsParam] = params;

  const rootOf = (node) => {
    const p = peel(node);
    if (!p || p.kind !== Kind.Name || !p.binding) return null;
    return rootBindingOf(p.binding, single);
  };

  // 1) Identify `pc` binding, `instsKey`, `constsKey` in vmFn header before `while true`
  let instsBinding = null;
  let instsKey = null;
  let constsBinding = null;
  let constsKey = null;
  let pcBinding = null;

  const protoIndexReads = [];
  walk(vmFn.body, {
    enter(node) {
      if (node === whileNode) return false;
      if (node.kind === Kind.LocalDeclaration) {
        const bs = node.bindings || [];
        const es = node.expressions || [];
        for (let i = 0; i < bs.length && i < es.length; i += 1) {
          const rhs = peel(es[i]);
          if (rhs && rhs.kind === Kind.Number && rhs.value === 1) {
            pcBinding = rootBindingOf(bs[i], single);
          }
          if (rhs && rhs.kind === Kind.Index && rootOf(rhs.base) === protoParam) {
            const kv = evalConstScalar(rhs.index);
            if (kv.ok && typeof kv.value === 'number') {
              protoIndexReads.push({ binding: rootBindingOf(bs[i], single), key: kv.value });
            }
          }
        }
      } else if (node.kind === Kind.Assignment) {
        const ts = node.targets || [];
        const es = node.expressions || [];
        for (let i = 0; i < ts.length && i < es.length; i += 1) {
          const t = peel(ts[i]);
          const rhs = peel(es[i]);
          if (t && t.kind === Kind.Name && t.binding) {
            if (rhs && rhs.kind === Kind.Number && rhs.value === 1) {
              pcBinding = rootBindingOf(t.binding, single);
            }
            if (rhs && rhs.kind === Kind.Index && rootOf(rhs.base) === protoParam) {
              const kv = evalConstScalar(rhs.index);
              if (kv.ok && typeof kv.value === 'number') {
                protoIndexReads.push({ binding: rootBindingOf(t.binding, single), key: kv.value });
              }
            }
          }
        }
      }
      return undefined;
    },
  });

  // 2) Inside `while true`, find `ins = insts[pc]` and `slotBindings: binding -> slot (1..5)`
  let insBinding = null;
  const slotOfBinding = new Map();
  const whileStmts = (whileNode.body && whileNode.body.statements) || [];

  const checkInsAssign = (lhsBinding, rhsNode) => {
    const rhs = peel(rhsNode);
    if (!rhs || rhs.kind !== Kind.Index) return;
    const baseB = rootOf(rhs.base);
    const idxB = rootOf(rhs.index);
    const candInst = protoIndexReads.find((r) => r.binding === baseB);
    if (candInst && idxB === pcBinding) {
      insBinding = rootBindingOf(lhsBinding, single);
      instsBinding = candInst.binding;
      instsKey = candInst.key;
      const other = protoIndexReads.find((r) => r.binding !== instsBinding);
      if (other) {
        constsBinding = other.binding;
        constsKey = other.key;
      }
      return;
    }
    if (insBinding && baseB === insBinding) {
      const sv = evalConstScalar(rhs.index);
      if (sv.ok && Number.isInteger(sv.value)) {
        slotOfBinding.set(rootBindingOf(lhsBinding, single), sv.value);
      }
    }
  };

  for (const s of whileStmts) {
    if (s.kind === Kind.If) break;
    if (s.kind === Kind.LocalDeclaration) {
      const bs = s.bindings || [];
      const es = s.expressions || [];
      for (let i = 0; i < bs.length && i < es.length; i += 1) checkInsAssign(bs[i], es[i]);
    } else if (s.kind === Kind.Assignment) {
      const ts = s.targets || [];
      const es = s.expressions || [];
      for (let i = 0; i < ts.length && i < es.length; i += 1) {
        const t = peel(ts[i]);
        if (t && t.kind === Kind.Name && t.binding) checkInsAssign(t.binding, es[i]);
      }
    }
  }

  if (!insBinding || instsKey === null || constsKey === null) return null;

  const slotOf = (node) => {
    const b = rootOf(node);
    return b && slotOfBinding.has(b) ? slotOfBinding.get(b) : null;
  };

  const isRegIndex = (node) => {
    const p = peel(node);
    return p && p.kind === Kind.Index && rootOf(p.base) === regsParam ? slotOf(p.index) : null;
  };

  const isConstIndex = (node) => {
    const p = peel(node);
    return p && p.kind === Kind.Index && rootOf(p.base) === constsBinding ? slotOf(p.index) : null;
  };

  // 3) Find opcode dispatch tree and collect all `opVar == K` leaf blocks
  let opBinding = null;
  const leaves = new Map();
  let protosKey = null;
  let upvalsKey = null;

  const collectDispatch = (ifNode) => {
    const clauses = [
      { condition: ifNode.condition, body: ifNode.body },
      ...(ifNode.elseIfs || []),
    ];
    for (const cl of clauses) {
      const cond = peel(cl.condition);
      if (cond && cond.kind === Kind.Binary) {
        const lb = rootOf(cond.lhs);
        const rv = evalConstScalar(cond.rhs);
        if (lb && slotOfBinding.has(lb) && rv.ok && Number.isInteger(rv.value)) {
          if (!opBinding) opBinding = lb;
          if (lb === opBinding) {
            if (cond.operator === '==') {
              leaves.set(rv.value, cl.body);
              continue;
            }
            if (cond.operator === '<=' || cond.operator === '<' || cond.operator === '>=' || cond.operator === '>') {
              for (const st of (cl.body && cl.body.statements) || []) {
                if (st.kind === Kind.If) collectDispatch(st);
              }
              continue;
            }
          }
        }
      }
    }
    if (ifNode.elseBody) {
      for (const st of ifNode.elseBody.statements || []) {
        if (st.kind === Kind.If) collectDispatch(st);
      }
    }
  };

  for (const s of whileStmts) {
    if (s.kind === Kind.If) collectDispatch(s);
  }
  if (!opBinding || leaves.size < 30) return null;
  const opSlot = slotOfBinding.get(opBinding);

  // 4) Classify each handler block structurally
  const opSpecs = new Map();
  const setNilOps = [];

  for (const [opCode, block] of leaves) {
    const stmts = (block && block.statements) || [];
    const spec = classifyHandler(
      stmts,
      {
        protoParam, upvalsParam, envParam, regsParam, varargsParam,
        constsBinding, pcBinding, slotOf, isRegIndex, isConstIndex, rootOf,
        onClosureKeys(pk, uk) {
          if (pk !== null) protosKey = pk;
          if (uk !== null) upvalsKey = uk;
        },
      },
    );
    if (!spec) {
      throw new Error(`vmify: failed to classify opcode ${opCode}`);
    }
    if (spec.op === 'SET_NIL') setNilOps.push(opCode);
    opSpecs.set(opCode, spec);
  }

  // 5) Distinguish LOADNIL vs CLEARREG across all prototypes when two SET_NIL opcodes exist
  if (setNilOps.length >= 2 && protosKey !== null) {
    const readCounts = new Map(setNilOps.map((c) => [c, 0]));
    const checkProto = (proto) => {
      if (!(proto instanceof Map)) return;
      const instsMap = proto.get(instsKey);
      const insts = luaArray(instsMap);
      for (let i = 0; i < insts.length; i += 1) {
        const ins = insts[i];
        const op = ins.get(opSlot);
        if (!readCounts.has(op)) continue;
        const reg = ins.get(opSpecs.get(op).dst);
        // Check if `reg` is read before being written in the next 8 linear instructions
        for (let j = i + 1; j < Math.min(insts.length, i + 10); j += 1) {
          const nins = insts[j];
          const nop = nins.get(opSlot);
          const nspec = opSpecs.get(nop);
          if (!nspec) break;
          const rw = instReadsWrites(nins, nspec);
          if (rw.reads.includes(reg)) {
            readCounts.set(op, readCounts.get(op) + 1);
            break;
          }
          if (rw.writes.includes(reg) || rw.jumps) break;
        }
      }
      const kids = luaArray(proto.get(protosKey));
      for (const kid of kids) checkProto(kid);
    };
    checkProto(rootProto);
    for (const op of setNilOps) {
      opSpecs.set(op, {
        op: readCounts.get(op) > 0 ? 'LOADNIL' : 'CLEARREG',
        dst: opSpecs.get(op).dst,
      });
    }
  } else if (setNilOps.length === 1) {
    const only = setNilOps[0];
    opSpecs.set(only, { op: 'LOADNIL', dst: opSpecs.get(only).dst });
  }

  return {
    opSlot,
    opSpecs,
    keys: {
      ...detected.keys,
      instsKey,
      constsKey,
      protosKey,
      upvalsKey,
    },
  };
}

function instReadsWrites(ins, spec) {
  const g = (slot) => (slot ? ins.get(slot) : null);
  const reads = [];
  const writes = [];
  let jumps = false;
  switch (spec.op) {
    case 'MOVE': case 'UNOP': case 'NEWBOX': case 'GETBOX':
      reads.push(g(spec.src)); writes.push(g(spec.dst)); break;
    case 'SETBOX':
      reads.push(g(spec.dst), g(spec.src)); break;
    case 'BINOP': case 'GETTABLE':
      reads.push(g(spec.lhs), g(spec.rhs)); writes.push(g(spec.dst)); break;
    case 'GETTABLE_IMM':
      reads.push(g(spec.src)); writes.push(g(spec.dst)); break;
    case 'SETTABLE':
      reads.push(g(spec.tbl), g(spec.key), g(spec.val)); break;
    case 'LOADK': case 'GETGLOBAL': case 'GETUPVAL': case 'NEWTABLE':
    case 'VARARG': case 'CLOSURE':
      writes.push(g(spec.dst)); break;
    case 'SETGLOBAL': case 'SETUPVAL':
      reads.push(g(spec.src)); break;
    case 'SET_NIL': case 'LOADNIL': case 'CLEARREG':
      writes.push(g(spec.dst)); break;
    case 'CLEARREGS': {
      const list = g(spec.list);
      if (list instanceof Map) writes.push(...luaArray(list));
      break;
    }
    case 'RETURN_FIXED':
      for (const s of spec.srcs) reads.push(g(s));
      jumps = true;
      break;
    case 'RETURN_UNPACK':
      reads.push(g(spec.src)); jumps = true; break;
    case 'JMP': case 'JMP_COND':
      if (spec.cond) reads.push(g(spec.cond));
      jumps = true;
      break;
    default:
      jumps = true;
      break;
  }
  return { reads, writes, jumps };
}

function classifyHandler(stmts, ctx) {
  const {
    protoParam, upvalsParam, envParam, regsParam, varargsParam,
    constsBinding, pcBinding, slotOf, isRegIndex, isConstIndex, rootOf, onClosureKeys,
  } = ctx;

  // Map handler-local aliases: `local v = expr`
  const localDefs = new Map();
  for (const s of stmts) {
    if (s.kind === Kind.LocalDeclaration) {
      const bs = s.bindings || [];
      const es = s.expressions || [];
      for (let i = 0; i < bs.length && i < es.length; i += 1) {
        if (bs[i]) localDefs.set(bs[i], peel(es[i]));
      }
    }
  }
  const expandLocal = (node) => {
    const p = peel(node);
    if (p && p.kind === Kind.Name && p.binding && localDefs.has(p.binding)) {
      return localDefs.get(p.binding);
    }
    return p;
  };

  // Single-statement handlers
  if (stmts.length === 1) {
    const s = stmts[0];
    if (s.kind === Kind.Return) {
      const exprs = s.expressions || [];
      const srcs = exprs.map((e) => isRegIndex(e));
      if (srcs.every((x) => x !== null)) {
        return { op: 'RETURN_FIXED', arity: srcs.length, srcs };
      }
    }
    if (s.kind === Kind.Assignment && s.targets.length === 1 && s.expressions.length === 1) {
      const tgt = peel(s.targets[0]);
      const rhs = peel(s.expressions[0]);

      // JMP: `pc = ins[targetSlot]`
      if (rootOf(tgt) === pcBinding) {
        const target = slotOf(rhs);
        if (target !== null) return { op: 'JMP', target };
      }

      // `regs[dst] = ...`
      const dst = isRegIndex(tgt);
      if (dst !== null) {
        if (rhs.kind === Kind.Nil) return { op: 'SET_NIL', dst };
        if (rhs.kind === Kind.Table) {
          const entries = rhs.entries || [];
          if (entries.length === 0) return { op: 'NEWTABLE', dst };
          if (entries.length === 1 && entries[0].type === 'item') {
            const src = isRegIndex(entries[0].value);
            if (src !== null) return { op: 'NEWBOX', dst, src };
          }
        }
        if (rootOf(rhs) === varargsParam) return { op: 'VARARG', dst };
        const moveSrc = isRegIndex(rhs);
        if (moveSrc !== null) return { op: 'MOVE', dst, src: moveSrc };
        const kSrc = isConstIndex(rhs);
        if (kSrc !== null) return { op: 'LOADK', dst, constIdx: kSrc };

        if (rhs.kind === Kind.Unary) {
          const src = isRegIndex(rhs.argument);
          if (src !== null) return { op: 'UNOP', operator: rhs.operator, dst, src };
        }
        if (rhs.kind === Kind.Binary && BIN_OPS.has(rhs.operator)) {
          const lhs = isRegIndex(rhs.lhs);
          const rslot = isRegIndex(rhs.rhs);
          if (lhs !== null && rslot !== null) {
            return { op: 'BINOP', operator: rhs.operator, dst, lhs, rhs: rslot };
          }
        }
        if (rhs.kind === Kind.Index) {
          // GETGLOBAL: `env[consts[slot]]`
          if (rootOf(rhs.base) === envParam) {
            const kSlot = isConstIndex(rhs.index);
            if (kSlot !== null) return { op: 'GETGLOBAL', dst, constIdx: kSlot };
          }
          // GETTABLE / GETTABLE_IMM / GETBOX / GETUPVAL
          const baseReg = isRegIndex(rhs.base);
          if (baseReg !== null) {
            const keyReg = isRegIndex(rhs.index);
            if (keyReg !== null) return { op: 'GETTABLE', dst, lhs: baseReg, rhs: keyReg };
            const immSlot = slotOf(rhs.index);
            if (immSlot !== null) return { op: 'GETTABLE_IMM', dst, src: baseReg, idxSlot: immSlot };
            const kv = evalConstScalar(rhs.index);
            if (kv.ok && kv.value === 1) return { op: 'GETBOX', dst, src: baseReg };
          }
          const baseP = peel(rhs.base);
          if (baseP && baseP.kind === Kind.Index && rootOf(baseP.base) === upvalsParam) {
            const upSlot = slotOf(baseP.index);
            const kv = evalConstScalar(rhs.index);
            if (upSlot !== null && kv.ok && kv.value === 1) {
              return { op: 'GETUPVAL', dst, upIdx: upSlot };
            }
          }
        }
      }

      // Assignments to `regs[tbl][...] = ...`, `env[consts[k]] = ...`, `upvals[u][1] = ...`
      if (tgt.kind === Kind.Index) {
        const rhsReg = isRegIndex(rhs);
        if (rhsReg !== null) {
          if (rootOf(tgt.base) === envParam) {
            const kSlot = isConstIndex(tgt.index);
            if (kSlot !== null) return { op: 'SETGLOBAL', constIdx: kSlot, src: rhsReg };
          }
          const tblReg = isRegIndex(tgt.base);
          if (tblReg !== null) {
            const keyReg = isRegIndex(tgt.index);
            if (keyReg !== null) return { op: 'SETTABLE', tbl: tblReg, key: keyReg, val: rhsReg };
            const kv = evalConstScalar(tgt.index);
            if (kv.ok && kv.value === 1) return { op: 'SETBOX', dst: tblReg, src: rhsReg };
          }
          const baseP = peel(tgt.base);
          if (baseP && baseP.kind === Kind.Index && rootOf(baseP.base) === upvalsParam) {
            const upSlot = slotOf(baseP.index);
            const kv = evalConstScalar(tgt.index);
            if (upSlot !== null && kv.ok && kv.value === 1) {
              return { op: 'SETUPVAL', upIdx: upSlot, src: rhsReg };
            }
          }
        }
      }
    }

    // FORLOOP_CMP: `if regs[step] ~= regs[step] then ... elseif regs[step] > 0 then regs[dst] = regs[idx] <= regs[lim] ...`
    if (s.kind === Kind.If) {
      const cond = peel(s.condition);
      if (cond && cond.kind === Kind.Binary && cond.operator === '~=') {
        const stepSlot = isRegIndex(cond.lhs);
        if (stepSlot !== null && isRegIndex(cond.rhs) === stepSlot && (s.elseIfs || []).length === 1) {
          const eif = s.elseIfs[0];
          const s0 = eif.body.statements[0];
          if (s0 && s0.kind === Kind.Assignment) {
            const dst = isRegIndex(s0.targets[0]);
            const cmp = peel(s0.expressions[0]);
            if (dst !== null && cmp && cmp.kind === Kind.Binary && cmp.operator === '<=') {
              const idxSlot = isRegIndex(cmp.lhs);
              const limitSlot = isRegIndex(cmp.rhs);
              if (idxSlot !== null && limitSlot !== null) {
                return { op: 'FORLOOP', dst, idx: idxSlot, limit: limitSlot, step: stepSlot };
              }
            }
          }
        }
      }
    }

    // CLEARREGS: single NumericFor setting `regs[list[i]] = nil`
    if (s.kind === Kind.NumericFor) {
      let listSlot = null;
      walk(s.body, {
        enter(sub) {
          if (sub.kind === Kind.Assignment && peel(sub.expressions[0]).kind === Kind.Nil) {
            const t = peel(sub.targets[0]);
            if (t && t.kind === Kind.Index && rootOf(t.base) === regsParam) {
              const idx = peel(t.index);
              if (idx && idx.kind === Kind.Index) listSlot = slotOf(idx.base);
            }
          }
          return undefined;
        },
      });
      if (listSlot !== null) return { op: 'CLEARREGS', list: listSlot };
    }
  }

  // Multi-statement handlers
  // 1) RETURN_UNPACK: `local v = regs[src]; return unpack(v, 1, v[lenKey])`
  if (stmts.length === 2 && stmts[1].kind === Kind.Return) {
    const retCall = peel(stmts[1].expressions[0]);
    if (retCall && retCall.kind === Kind.Call && (retCall.args || []).length === 3) {
      const src = isRegIndex(expandLocal(retCall.args[0]));
      if (src !== null) return { op: 'RETURN_UNPACK', src };
    }
  }

  // 2) JMP_COND (consume): `local v = regs[cond]; regs[cond] = nil; if [not] v then pc = ins[target] end`
  if (stmts.length === 3 && stmts[2].kind === Kind.If) {
    const ifSt = stmts[2];
    const bodyStmts = (ifSt.body && ifSt.body.statements) || [];
    if (bodyStmts.length === 1 && bodyStmts[0].kind === Kind.Assignment
      && rootOf(bodyStmts[0].targets[0]) === pcBinding) {
      const target = slotOf(bodyStmts[0].expressions[0]);
      const rawCond = peel(ifSt.condition);
      let truthy = true;
      let condVar = rawCond;
      if (rawCond && rawCond.kind === Kind.Unary && rawCond.operator === 'not') {
        truthy = false;
        condVar = peel(rawCond.argument);
      }
      const condSlot = isRegIndex(expandLocal(condVar));
      if (condSlot !== null && target !== null) {
        return { op: 'JMP_COND', truthy, cond: condSlot, target };
      }
    }
  }

  // 3) FORPREP_CHECK: checks `'for' initial value must be a number`, `'for' limit...`, `'for' step...`
  let hasForInitErr = false;
  walk({ kind: Kind.Block, statements: stmts }, {
    enter(sub) {
      if (sub.kind === Kind.String && sub.value.includes("'for' limit must be a number")) {
        hasForInitErr = true;
      }
      return undefined;
    },
  });
  if (hasForInitErr) {
    const coercedSlots = [];
    for (const s of stmts) {
      if (s.kind === Kind.Assignment && s.targets.length === 1) {
        const r = isRegIndex(s.targets[0]);
        if (r !== null && !coercedSlots.includes(r)) coercedSlots.push(r);
      }
    }
    if (coercedSlots.length === 3) {
      return {
        op: 'FORPREP',
        idx: coercedSlots[0],
        limit: coercedSlots[1],
        step: coercedSlots[2],
      };
    }
  }

  // 4) CLOSURE: accesses `proto[protosKey][protoSlot]` and `childProto[upvalsKey]`
  let closureProtoKey = null;
  let closureProtoSlot = null;
  let closureUpvalsKey = null;
  let closureDstSlot = null;
  for (const s of stmts) {
    if (s.kind === Kind.LocalDeclaration && s.expressions && s.expressions[0]) {
      const e0 = peel(s.expressions[0]);
      if (e0 && e0.kind === Kind.Index) {
        const inner = peel(e0.base);
        if (inner && inner.kind === Kind.Index && rootOf(inner.base) === protoParam) {
          const pk = evalConstScalar(inner.index);
          const ps = slotOf(e0.index);
          if (pk.ok && typeof pk.value === 'number' && ps !== null) {
            closureProtoKey = pk.value;
            closureProtoSlot = ps;
          }
        }
      }
    }
    if (s.kind === Kind.Assignment && s.targets.length === 1) {
      const d = isRegIndex(s.targets[0]);
      if (d !== null) closureDstSlot = d;
    }
  }
  if (closureProtoKey !== null && closureProtoSlot !== null && closureDstSlot !== null) {
    walk({ kind: Kind.Block, statements: stmts }, {
      enter(sub) {
        if (sub.kind === Kind.Index) {
          const kv = evalConstScalar(sub.index);
          if (kv.ok && typeof kv.value === 'number' && kv.value > 1000 && kv.value !== closureProtoKey) {
            closureUpvalsKey = kv.value;
          }
        }
        return undefined;
      },
    });
    onClosureKeys(closureProtoKey, closureUpvalsKey);
    return { op: 'CLOSURE', dst: closureDstSlot, protoIdx: closureProtoSlot };
  }

  // 5) SETLIST_MULTRET: `local pack = regs[packSlot]; for i = 1, pack[lenKey] do regs[tblSlot][startSlot + i - 1] = pack[i] end`
  if (stmts.length === 2 && (stmts[1].kind === Kind.NumericFor || stmts[1].kind === Kind.While)) {
    const packSlot = isRegIndex(stmts[0].expressions && stmts[0].expressions[0]);
    let tblSlot = null;
    let startSlot = null;
    walk(stmts[1], {
      enter(sub) {
        if (sub.kind === Kind.Assignment) {
          const t = peel(sub.targets[0]);
          if (t && t.kind === Kind.Index) {
            const tb = isRegIndex(t.base);
            if (tb !== null) {
              tblSlot = tb;
              walk(t.index, {
                enter(idxSub) {
                  const sl = slotOf(idxSub);
                  if (sl !== null && sl !== packSlot && sl !== tb) startSlot = sl;
                  return undefined;
                },
              });
            }
          }
        }
        return undefined;
      },
    });
    if (packSlot !== null && tblSlot !== null && startSlot !== null) {
      return { op: 'SETLIST_MULTRET', tbl: tblSlot, pack: packSlot, start: startSlot };
    }
  }

  // 6) PACK_ARGS: contains `GenericFor` over `ipairs(fixedListSlot)` + `if tailSlot ~= 0`
  let hasGenericForSlot = null;
  let tailCheckSlot = null;
  let packDstSlot = null;
  for (const s of stmts) {
    if (s.kind === Kind.GenericFor && (s.expressions || []).length === 1) {
      const c = peel(s.expressions[0]);
      if (c && c.kind === Kind.Call && (c.args || []).length === 1) {
        hasGenericForSlot = slotOf(c.args[0]);
      }
    } else if (s.kind === Kind.If) {
      const cond = peel(s.condition);
      if (cond && cond.kind === Kind.Binary && cond.operator === '~=') {
        const zv = evalConstScalar(cond.rhs);
        if (zv.ok && zv.value === 0) tailCheckSlot = slotOf(cond.lhs);
      }
    } else if (s.kind === Kind.Assignment && s.targets.length === 1) {
      const d = isRegIndex(s.targets[0]);
      if (d !== null) packDstSlot = d;
    }
  }
  if (hasGenericForSlot !== null && tailCheckSlot !== null && packDstSlot !== null) {
    return {
      op: 'PACK_ARGS',
      dst: packDstSlot,
      fixedList: hasGenericForSlot,
      tail: tailCheckSlot,
    };
  }

  // 7) TAILCALL_FIXED / TAILCALL_VAR: ends with `return fn(...)`
  const lastStmt = stmts[stmts.length - 1];
  if (lastStmt && lastStmt.kind === Kind.Return && (lastStmt.expressions || []).length === 1) {
    const retCall = peel(lastStmt.expressions[0]);
    if (retCall && retCall.kind === Kind.Call) {
      const fnSlot = isRegIndex(expandLocal(retCall.base));
      const cargs = retCall.args || [];
      if (fnSlot !== null) {
        if (cargs.length === 0) {
          return { op: 'TAILCALL_FIXED', arity: 0, fn: fnSlot, argsList: null };
        }
        // Check if single arg is `unpack(packReg, 1, packReg[lenKey])` -> TAILCALL_VAR
        if (cargs.length === 1 && peel(cargs[0]).kind === Kind.Call) {
          const unp = peel(cargs[0]);
          if ((unp.args || []).length === 3) {
            const packSlot = isRegIndex(expandLocal(unp.args[0]));
            if (packSlot !== null) {
              return { op: 'TAILCALL_VAR', fn: fnSlot, pack: packSlot };
            }
          }
        }
        // Otherwise fixed args `regs[argsSlot[1]], ...`
        let argsSlot = null;
        const okFixed = cargs.every((ca) => {
          const p = peel(ca);
          if (!p || p.kind !== Kind.Index || rootOf(p.base) !== regsParam) return false;
          const idx = peel(p.index);
          if (!idx || idx.kind !== Kind.Index) return false;
          const sl = slotOf(idx.base);
          if (sl === null) return false;
          argsSlot = sl;
          return true;
        });
        if (okFixed && (cargs.length === 0 || argsSlot !== null)) {
          return { op: 'TAILCALL_FIXED', arity: cargs.length, fn: fnSlot, argsList: argsSlot };
        }
      }
    }
  }

  // 8) CALL_FIXED / CALL_VAR: checks `modeSlot == -1` and `modeSlot == 1`, calls `fn(...)`
  let modeSlot = null;
  let callDstSlot = null;
  let callFnSlot = null;
  let callArgsListSlot = null;
  let callPackSlot = null;
  let callArity = null;

  walk({ kind: Kind.Block, statements: stmts }, {
    enter(sub) {
      if (sub.kind === Kind.Binary && sub.operator === '==') {
        const rv = evalConstScalar(sub.rhs);
        if (rv.ok && rv.value === -1) {
          const sl = slotOf(sub.lhs);
          if (sl !== null) modeSlot = sl;
        }
      }
      if (sub.kind === Kind.Assignment && sub.targets.length === 1 && sub.expressions.length === 1) {
        const d = isRegIndex(sub.targets[0]);
        const rhs = peel(sub.expressions[0]);
        if (d !== null && rhs && rhs.kind === Kind.Call) {
          const fnS = isRegIndex(expandLocal(rhs.base));
          if (fnS !== null) {
            callDstSlot = d;
            callFnSlot = fnS;
            const cargs = rhs.args || [];
            if (cargs.length === 0) {
              callArity = 0;
            } else if (cargs.length === 1 && peel(cargs[0]).kind === Kind.Call) {
              const unp = peel(cargs[0]);
              if ((unp.args || []).length === 3) {
                const ps = isRegIndex(expandLocal(unp.args[0]));
                if (ps !== null) callPackSlot = ps;
              }
            } else {
              let asl = null;
              const ok = cargs.every((ca) => {
                const p = peel(ca);
                if (!p || p.kind !== Kind.Index || rootOf(p.base) !== regsParam) return false;
                const idx = peel(p.index);
                if (!idx || idx.kind !== Kind.Index) return false;
                asl = slotOf(idx.base);
                return asl !== null;
              });
              if (ok) {
                callArity = cargs.length;
                callArgsListSlot = asl;
              }
            }
          }
        }
      }
      return undefined;
    },
  });

  if (modeSlot !== null && callDstSlot !== null && callFnSlot !== null) {
    if (callPackSlot !== null) {
      return {
        op: 'CALL_VAR',
        mode: modeSlot,
        dst: callDstSlot,
        fn: callFnSlot,
        pack: callPackSlot,
      };
    }
    if (callArity !== null) {
      return {
        op: 'CALL_FIXED',
        arity: callArity,
        mode: modeSlot,
        dst: callDstSlot,
        fn: callFnSlot,
        argsList: callArgsListSlot,
      };
    }
  }

  return null;
}

module.exports = { analyzeVmOpcodes };
