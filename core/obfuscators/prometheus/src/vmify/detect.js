'use strict';

const { Kind } = require('../lua/ast');
const { resolve } = require('../lua/scope');
const { walk } = require('../lua/walk');

function peel(node) {
  let cur = node;
  while (cur && cur.kind === Kind.Paren) cur = cur.expression;
  return cur;
}

function buildSingleValueMap(chunk) {
  resolve(chunk);
  const defs = new Map();
  const counts = new Map();

  const record = (binding, expr) => {
    if (!binding) return;
    counts.set(binding, (counts.get(binding) || 0) + 1);
    if (expr) defs.set(binding, peel(expr));
  };

  walk(chunk, {
    enter(node) {
      if (node.kind === Kind.LocalDeclaration) {
        const names = node.names || [];
        const bindings = node.bindings || [];
        const exprs = node.expressions || [];
        for (let i = 0; i < bindings.length; i += 1) {
          if (i < exprs.length) record(bindings[i], exprs[i]);
          else if (exprs.length > 0) record(bindings[i], null);
        }
      } else if (node.kind === Kind.LocalFunction) {
        record(node.binding, node.body);
      } else if (node.kind === Kind.Assignment) {
        const targets = node.targets || [];
        const exprs = node.expressions || [];
        for (let i = 0; i < targets.length; i += 1) {
          const t = peel(targets[i]);
          if (t && t.kind === Kind.Name && t.binding) {
            record(t.binding, i < exprs.length ? exprs[i] : null);
          }
        }
      } else if (node.kind === Kind.FunctionDeclaration) {
        const t = peel(node.target);
        if (t && t.kind === Kind.Name && t.binding) {
          record(t.binding, node.body);
        }
      }
      return undefined;
    },
  });

  const single = new Map();
  for (const [binding, expr] of defs) {
    if (counts.get(binding) === 1 && expr) single.set(binding, expr);
  }
  return single;
}

function rootBindingOf(binding, single) {
  let cur = binding;
  const seen = new Set();
  while (cur && !seen.has(cur)) {
    seen.add(cur);
    const val = single.get(cur);
    if (val && val.kind === Kind.Name && val.binding) {
      cur = val.binding;
    } else {
      break;
    }
  }
  return cur;
}

function resolveExpr(node, single) {
  let cur = peel(node);
  const seen = new Set();
  while (cur && cur.kind === Kind.Name && cur.binding && !seen.has(cur.binding)) {
    seen.add(cur.binding);
    const next = single.get(cur.binding);
    if (!next) break;
    cur = peel(next);
  }
  return cur;
}

function evalConstScalar(node) {
  const cur = peel(node);
  if (!cur) return { ok: false };
  switch (cur.kind) {
    case Kind.Nil: return { ok: true, value: null };
    case Kind.True: return { ok: true, value: true };
    case Kind.False: return { ok: true, value: false };
    case Kind.Number: return { ok: true, value: cur.value };
    case Kind.String: return { ok: true, value: cur.value };
    case Kind.Unary:
      if (cur.operator === '-') {
        const inner = evalConstScalar(cur.argument);
        if (inner.ok && typeof inner.value === 'number') {
          return { ok: true, value: -inner.value };
        }
      }
      return { ok: false };
    default:
      return { ok: false };
  }
}

function isGraphDeserializerFn(fn) {
  if (!fn || fn.kind !== Kind.Function) return false;
  if ((fn.params || []).length !== 3 || fn.isVararg) return false;
  const stmts = (fn.body && fn.body.statements) || [];
  if (stmts.length < 4) return false;
  let numericForCount = 0;
  let hasIfRef = false;
  walk(fn.body, {
    enter(node) {
      if (node.kind === Kind.NumericFor) numericForCount += 1;
      if (node.kind === Kind.If) hasIfRef = true;
      return undefined;
    },
  });
  return numericForCount >= 3 && hasIfRef && stmts[stmts.length - 1].kind === Kind.Return;
}

function deserializeGraphCall(callNode) {
  if (!callNode || callNode.kind !== Kind.Call) return null;
  const args = callNode.args || [];
  if (args.length !== 3) return null;
  const chunksTbl = peel(args[0]);
  const totalRes = evalConstScalar(args[1]);
  const rootRes = evalConstScalar(args[2]);
  if (!chunksTbl || chunksTbl.kind !== Kind.Table || !totalRes.ok || !rootRes.ok) return null;
  const totalNodes = totalRes.value;
  const rootId = rootRes.value;
  if (!Number.isInteger(totalNodes) || totalNodes < 1 || !Number.isInteger(rootId)) return null;

  const nodes = new Array(totalNodes + 1);
  for (let i = 1; i <= totalNodes; i += 1) nodes[i] = new Map();

  const deferredRounded = [];

  for (const chunkEntry of chunksTbl.entries || []) {
    if (chunkEntry.type !== 'item') return null;
    const subTbl = peel(chunkEntry.value);
    if (!subTbl || subTbl.kind !== Kind.Table) return null;
    for (const tupleEntry of subTbl.entries || []) {
      if (tupleEntry.type !== 'item') return null;
      const tup = peel(tupleEntry.value);
      if (!tup || tup.kind !== Kind.Table) return null;
      const items = tup.entries || [];
      if (items.length < 3 || items.length > 4) return null;
      const tidRawNode = peel(items[0].value);
      const e1 = evalConstScalar(items[0].value);
      const e2 = evalConstScalar(items[1].value);
      const e3 = evalConstScalar(items[2].value);
      const e4 = items.length === 4 ? evalConstScalar(items[3].value) : { ok: true, value: null };
      if (!e1.ok || !e2.ok || !e3.ok || !e4.ok) return null;
      const nodeIdx = e1.value;
      const key = e2.value;
      const val = (e4.value !== null && e4.value !== false) ? nodes[e3.value] : e3.value;
      if (!nodes[nodeIdx]) return null;
      if (tidRawNode && Array.isArray(tidRawNode.roundedCandidates) && tidRawNode.roundedCandidates.length > 1) {
        deferredRounded.push({ nodeIdx, cands: tidRawNode.roundedCandidates, key, val });
      } else {
        nodes[nodeIdx].set(key, val);
      }
    }
  }

  for (const item of deferredRounded) {
    let chosenIdx = item.nodeIdx;
    if (nodes[chosenIdx] && nodes[chosenIdx].has(item.key)) {
      const hasHigherKey = (tbl) => {
        for (const k of tbl.keys()) {
          if (typeof k === 'number' && k > item.key) return 0;
        }
        return 1;
      };
      const sorted = item.cands
        .filter((c) => Number.isInteger(c) && c >= 1 && c <= totalNodes && !nodes[c].has(item.key))
        .sort((a, b) => {
          const ah = hasHigherKey(nodes[a]);
          const bh = hasHigherKey(nodes[b]);
          if (ah !== bh) return ah - bh;
          const aNonEmpty = nodes[a].size > 0 ? 0 : 1;
          const bNonEmpty = nodes[b].size > 0 ? 0 : 1;
          if (aNonEmpty !== bNonEmpty) return aNonEmpty - bNonEmpty;
          return Math.abs(a - item.nodeIdx) - Math.abs(b - item.nodeIdx);
        });
      if (sorted.length > 0) chosenIdx = sorted[0];
    }
    nodes[chosenIdx].set(item.key, item.val);
  }

  return nodes[rootId] || null;
}

function luaLen(map) {
  if (!(map instanceof Map)) return 0;
  let n = 0;
  while (map.has(n + 1)) n += 1;
  return n;
}

function luaArray(map) {
  const len = luaLen(map);
  const out = new Array(len);
  for (let i = 1; i <= len; i += 1) out[i - 1] = map.get(i);
  return out;
}

function extractPackLenKey(chunk) {
  let lenKey = null;
  walk(chunk, {
    enter(node) {
      if (lenKey !== null || node.kind !== Kind.Function) return undefined;
      if (!node.isVararg || (node.params || []).length !== 0) return undefined;
      const stmts = (node.body && node.body.statements) || [];
      if (stmts.length !== 1 || stmts[0].kind !== Kind.Return) return undefined;
      const retExprs = stmts[0].expressions || [];
      if (retExprs.length !== 1) return undefined;
      const tbl = peel(retExprs[0]);
      if (!tbl || tbl.kind !== Kind.Table) return undefined;
      const entries = tbl.entries || [];
      if (entries.length !== 2) return undefined;
      const keyEntry = entries.find((e) => e.type === 'key');
      const itemEntry = entries.find((e) => e.type === 'item');
      if (!keyEntry || !itemEntry) return undefined;
      const itemVal = peel(itemEntry.value);
      if (!itemVal || itemVal.kind !== Kind.Vararg) return undefined;
      const kv = evalConstScalar(keyEntry.key);
      if (kv.ok && typeof kv.value === 'number') lenKey = kv.value;
      return undefined;
    },
  });
  return lenKey;
}

function findVmLoopFunction(chunk, single) {
  let found = null;
  walk(chunk, {
    enter(node) {
      if (found || node.kind !== Kind.Function) return undefined;
      if ((node.params || []).length !== 5 || node.isVararg) return undefined;
      const stmts = (node.body && node.body.statements) || [];
      let whileNode = null;
      for (const s of stmts) {
        if (s.kind === Kind.While) {
          const cond = evalConstScalar(s.condition);
          if (cond.ok && cond.value === true) {
            whileNode = s;
            break;
          }
        }
      }
      if (!whileNode) return undefined;
      let eqCount = 0;
      walk(whileNode.body, {
        enter(sub) {
          if (sub.kind === Kind.Binary && sub.operator === '==') eqCount += 1;
          return undefined;
        },
      });
      if (eqCount >= 25) {
        found = { fn: node, whileNode };
      }
      return undefined;
    },
  });
  return found;
}

function extractEntryKeys(chunk, vmFn, single) {
  let paramsKey = null;
  let isVarargKey = null;

  walk(chunk, {
    enter(node) {
      if (paramsKey !== null && isVarargKey !== null) return false;
      if (node.kind !== Kind.Function || !node.isVararg || (node.params || []).length !== 3) {
        return undefined;
      }
      const p0 = (node.bindings || [])[0];
      if (!p0) return undefined;
      let callsVm = false;
      walk(node.body, {
        enter(sub) {
          if (sub.kind === Kind.Call) {
            const callee = resolveExpr(sub.base, single);
            if (callee === vmFn) callsVm = true;
          }
          return undefined;
        },
      });
      if (!callsVm) return undefined;

      // Scan all `proto[NUM]` accesses in this entry wrapper:
      // 1) `not proto[isVarargKey]` or `if proto[isVarargKey] then`
      // 2) `local params = proto[paramsKey]` (used with `#params`)
      const protoReads = [];
      walk(node.body, {
        enter(sub, parentInfo) {
          if (sub.kind === Kind.Index && !sub.dot) {
            const b = peel(sub.base);
            if (b && b.kind === Kind.Name && rootBindingOf(b.binding, single) === p0) {
              const kv = evalConstScalar(sub.index);
              if (kv.ok && typeof kv.value === 'number') {
                protoReads.push({ key: kv.value, node: sub, parent: parentInfo && parentInfo.parent });
              }
            }
          }
          return undefined;
        },
      });
      for (const r of protoReads) {
        if (r.parent && ((r.parent.kind === Kind.Unary && r.parent.operator === 'not')
          || r.parent.kind === Kind.If)) {
          isVarargKey = r.key;
        }
      }
      for (const r of protoReads) {
        if (r.key !== isVarargKey) {
          paramsKey = r.key;
          break;
        }
      }
      return undefined;
    },
  });

  return { paramsKey, isVarargKey };
}

function detectVmify(chunk) {
  const body = chunk && chunk.body;
  if (!body || !body.statements || body.statements.length < 3) return null;

  const single = buildSingleValueMap(chunk);
  const vmInfo = findVmLoopFunction(chunk, single);
  if (!vmInfo) return null;

  // Locate final `return (closureFactory(protoContainer[idx], {}, env))(...)`
  const lastStmt = body.statements[body.statements.length - 1];
  if (lastStmt.kind !== Kind.Return || (lastStmt.expressions || []).length !== 1) return null;
  const outerCall = peel(lastStmt.expressions[0]);
  if (!outerCall || outerCall.kind !== Kind.Call) return null;
  const innerFactoryCall = peel(outerCall.base);
  if (!innerFactoryCall || innerFactoryCall.kind !== Kind.Call) return null;
  const factoryArgs = innerFactoryCall.args || [];
  if (factoryArgs.length < 2) return null;

  const rootProtoExpr = peel(factoryArgs[0]);
  if (!rootProtoExpr || rootProtoExpr.kind !== Kind.Index) return null;
  const rootSlotRes = evalConstScalar(rootProtoExpr.index);
  const graphCallExpr = resolveExpr(rootProtoExpr.base, single);
  if (!rootSlotRes.ok || !graphCallExpr || graphCallExpr.kind !== Kind.Call) return null;
  const deserializerFn = resolveExpr(graphCallExpr.base, single);
  if (!isGraphDeserializerFn(deserializerFn)) return null;

  const containerMap = deserializeGraphCall(graphCallExpr);
  if (!containerMap) return null;
  const rootProto = containerMap.get(rootSlotRes.value);
  if (!(rootProto instanceof Map)) return null;

  const lenKey = extractPackLenKey(chunk);
  const { paramsKey, isVarargKey } = extractEntryKeys(chunk, vmInfo.fn, single);

  return {
    vmFn: vmInfo.fn,
    whileNode: vmInfo.whileNode,
    single,
    rootProto,
    keys: {
      lenKey,
      paramsKey,
      isVarargKey,
    },
  };
}

module.exports = {
  peel,
  evalConstScalar,
  rootBindingOf,
  resolveExpr,
  buildSingleValueMap,
  luaLen,
  luaArray,
  detectVmify,
};
