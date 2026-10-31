'use strict';

const A = require('../lua/ast');
const { Kind } = require('../lua/ast');
const { resolve, isGlobalName } = require('../lua/scope');
const { walk } = require('../lua/walk');

function peel(node) {
  let cur = node;
  while (cur && cur.kind === Kind.Paren) cur = cur.expression;
  return cur;
}

function matchWrapper(body) {
  if (!body || !body.statements.length) return null;
  const statement = body.statements[body.statements.length - 1];
  if (statement.kind !== Kind.Return || statement.expressions.length !== 1) return null;
  const call = statement.expressions[0];
  if (!call || call.kind !== Kind.Call) return null;

  const callee = peel(call.base);
  if (!callee || callee.kind !== Kind.Function) return null;
  if ((callee.params || []).length !== 0) return null;

  for (const arg of call.args) {
    if (arg.kind !== Kind.Vararg) return null;
  }
  if (call.args.length > 1) return null;
  return callee;
}

function collectUsedNames(chunk) {
  const used = new Set();
  walk(chunk, {
    enter(node) {
      if (node.kind === Kind.Name && node.name) used.add(node.name);
      else if (node.kind === Kind.LocalFunction && node.name) used.add(node.name);
      else if (node.kind === Kind.LocalDeclaration) {
        for (const nm of node.names || []) used.add(nm);
      } else if (node.kind === Kind.Function) {
        for (const p of node.params || []) used.add(p);
      }
      return undefined;
    },
  });
  return used;
}

function allocFreshNames(used, count) {
  const out = [];
  let idx = 1;
  while (out.length < count) {
    const cand = `_wrap${idx}`;
    idx += 1;
    if (!used.has(cand)) {
      used.add(cand);
      out.push(cand);
    }
  }
  return out;
}

function collectOwnVarargs(fnBody) {
  const found = [];
  const visit = (node, parent, key, index) => {
    if (!node || typeof node !== 'object') return;
    if (node.kind === Kind.Function || node.kind === Kind.LocalFunction
      || node.kind === Kind.FunctionDeclaration) {
      return;
    }
    if (node.kind === Kind.Vararg) {
      found.push({ node, parent, key, index });
      return;
    }
    for (const k of Object.keys(node)) {
      if (k === 'binding' || k === 'bindings' || k === 'roundedCandidates') continue;
      const v = node[k];
      if (Array.isArray(v)) {
        for (let i = 0; i < v.length; i += 1) visit(v[i], node, k, i);
      } else if (v && typeof v === 'object' && v.kind) {
        visit(v, node, k, null);
      }
    }
  };
  visit(fnBody, null, null, null);
  return found;
}

function isTupleVarargIndex(expr, maxIdx) {
  if (!expr || expr.kind !== Kind.Index || expr.dot) return null;
  const idxNode = peel(expr.index);
  if (!idxNode || idxNode.kind !== Kind.Number) return null;
  const idx = idxNode.value;
  if (!Number.isInteger(idx) || idx < 1 || idx > maxIdx) return null;
  const tbl = peel(expr.base);
  if (!tbl || tbl.kind !== Kind.Table) return null;
  const entries = tbl.entries || [];
  if (entries.length !== 1 || entries[0].type !== 'item') return null;
  const itemVal = peel(entries[0].value);
  if (!itemVal || itemVal.kind !== Kind.Vararg) return null;
  return { index: idx, vararg: itemVal };
}

function isSelectTailCall(expr, maxStart) {
  if (!expr || expr.kind !== Kind.Call) return null;
  const base = peel(expr.base);
  if (!base || base.kind !== Kind.Name || base.name !== 'select' || !isGlobalName(base)) {
    return null;
  }
  const args = expr.args || [];
  if (args.length !== 2) return null;
  const startNode = peel(args[0]);
  const secondNode = args[1];
  if (!startNode || startNode.kind !== Kind.Number || !secondNode || secondNode.kind !== Kind.Vararg) {
    return null;
  }
  const start = startNode.value;
  if (!Number.isInteger(start) || start < 1 || start > maxStart) return null;
  return { start, vararg: secondNode };
}

function matchNamedWrapper(chunk, apply) {
  const body = chunk && chunk.body;
  if (!body || body.statements.length < 1) return false;
  resolve(chunk);
  const stmts = body.statements;
  const ret = stmts[stmts.length - 1];
  if (ret.kind !== Kind.Return || (ret.expressions || []).length !== 1) return false;
  const call = ret.expressions[0];
  if (!call || call.kind !== Kind.Call) return false;
  const callee = peel(call.base);

  let fn = null;
  let spliceStart = stmts.length - 1;
  let spliceCount = 1;

  if (callee && callee.kind === Kind.Function) {
    fn = callee;
  } else if (callee && callee.kind === Kind.Name && stmts.length >= 2) {
    const decl = stmts[stmts.length - 2];
    let declBinding = null;
    if (decl.kind === Kind.LocalFunction) {
      declBinding = decl.binding;
      fn = decl.body;
    } else if (decl.kind === Kind.LocalDeclaration
      && (decl.names || []).length === 1
      && (decl.expressions || []).length === 1
      && peel(decl.expressions[0]) && peel(decl.expressions[0]).kind === Kind.Function) {
      declBinding = (decl.bindings || [])[0];
      fn = peel(decl.expressions[0]);
    }
    if (!declBinding || callee.binding !== declBinding) return false;
    if ((declBinding.writes || []).length !== 0 || (declBinding.reads || []).length !== 1) {
      return false;
    }
    spliceStart = stmts.length - 2;
    spliceCount = 2;
  } else {
    return false;
  }

  if (!fn || !fn.isVararg) return false;
  const callArgs = call.args || [];
  if (callArgs.length < 1 || callArgs[callArgs.length - 1].kind !== Kind.Vararg) return false;
  for (let i = 0; i < callArgs.length - 1; i += 1) {
    if (callArgs[i].kind === Kind.Vararg) return false;
  }
  const prefixArgs = callArgs.slice(0, -1);
  const r = prefixArgs.length;
  const params = fn.params || [];

  // Case A: function(p1, ..., pr, ...) <body> end called with (a1, ..., ar, ...)
  if (params.length === r) {
    if (!apply) return true;
    const replacement = [];
    if (r > 0) replacement.push(A.localDecl([...params], prefixArgs));
    replacement.push(...fn.body.statements);
    stmts.splice(spliceStart, spliceCount, ...replacement);
    return true;
  }

  if (params.length !== 0 || r === 0) return false;

  const ownVarargs = collectOwnVarargs(fn.body);

  // Subcase B1: pure forwarding `return inner(b1, ..., bs, ...)`
  const fnStmts = fn.body.statements || [];
  if (fnStmts.length >= 1) {
    const lastFnStmt = fnStmts[fnStmts.length - 1];
    if (lastFnStmt.kind === Kind.Return && (lastFnStmt.expressions || []).length === 1) {
      const innerCall = lastFnStmt.expressions[0];
      if (innerCall && innerCall.kind === Kind.Call) {
        const innerArgs = innerCall.args || [];
        if (innerArgs.length >= 1 && innerArgs[innerArgs.length - 1].kind === Kind.Vararg
          && ownVarargs.length === 1 && ownVarargs[0].node === innerArgs[innerArgs.length - 1]) {
          if (!apply) return true;
          const used = collectUsedNames(chunk);
          const temps = allocFreshNames(used, r);
          const replacement = [
            A.localDecl(temps, prefixArgs),
            ...fnStmts.slice(0, -1),
            A.returnStatement([
              A.call(innerCall.base, [
                ...innerArgs.slice(0, -1),
                ...temps.map((nm) => A.name(nm)),
                A.vararg(),
              ]),
            ]),
          ];
          stmts.splice(spliceStart, spliceCount, ...replacement);
          return true;
        }
      }
    }
  }

  // Subcase B2: all own-scope `...` are `({ ... })[i]` (1 <= i <= r) or tail `select(c, ...)` (1 <= c <= r + 1)
  if (!ownVarargs.length) {
    if (!apply) return true;
    const used = collectUsedNames(chunk);
    const temps = allocFreshNames(used, r);
    stmts.splice(spliceStart, spliceCount, A.localDecl(temps, prefixArgs), ...fnStmts);
    return true;
  }

  const accountedVarargs = new Set();
  const tupleRewrites = [];
  const selectRewrites = [];

  const scanOwn = (node) => {
    if (!node || typeof node !== 'object') return;
    if (node.kind === Kind.Function || node.kind === Kind.LocalFunction
      || node.kind === Kind.FunctionDeclaration) {
      return;
    }
    for (const k of Object.keys(node)) {
      if (k === 'binding' || k === 'bindings' || k === 'roundedCandidates') continue;
      const v = node[k];
      if (Array.isArray(v)) {
        for (let i = 0; i < v.length; i += 1) {
          const item = v[i];
          if (!item || typeof item !== 'object') continue;
          const tup = isTupleVarargIndex(item, r);
          if (tup) {
            accountedVarargs.add(tup.vararg);
            tupleRewrites.push({ parent: v, key: i, index: tup.index });
            continue;
          }
          const isTailList = (i === v.length - 1) && (
            (node.kind === Kind.Call && k === 'args')
            || (node.kind === Kind.MethodCall && k === 'args')
            || (node.kind === Kind.Return && k === 'expressions')
            || (node.kind === Kind.LocalDeclaration && k === 'expressions')
          );
          if (isTailList) {
            const sel = isSelectTailCall(item, r + 1);
            if (sel) {
              accountedVarargs.add(sel.vararg);
              selectRewrites.push({ list: v, index: i, start: sel.start });
              continue;
            }
          }
          scanOwn(item);
        }
      } else if (v && typeof v === 'object' && v.kind) {
        const tup = isTupleVarargIndex(v, r);
        if (tup) {
          accountedVarargs.add(tup.vararg);
          tupleRewrites.push({ parent: node, key: k, index: tup.index });
          continue;
        }
        scanOwn(v);
      }
    }
  };
  scanOwn(fn.body);

  if (accountedVarargs.size !== ownVarargs.length) return false;
  for (const ov of ownVarargs) {
    if (!accountedVarargs.has(ov.node)) return false;
  }

  if (!apply) return true;
  const used = collectUsedNames(chunk);
  const temps = allocFreshNames(used, r);
  for (const rw of tupleRewrites) {
    rw.parent[rw.key] = A.name(temps[rw.index - 1]);
  }
  for (const sr of selectRewrites) {
    const expanded = [
      ...temps.slice(sr.start - 1).map((nm) => A.name(nm)),
      A.vararg(),
    ];
    sr.list.splice(sr.index, 1, ...expanded);
  }
  stmts.splice(spliceStart, spliceCount, A.localDecl(temps, prefixArgs), ...fnStmts);
  return true;
}

function run(context) {
  let unwrapped = 0;
  for (;;) {
    const body = context.chunk.body;
    const fn = matchWrapper(body);
    if (fn) {
      body.statements.splice(body.statements.length - 1, 1, ...fn.body.statements);
      unwrapped += 1;
    } else if (matchNamedWrapper(context.chunk, true)) {
      unwrapped += 1;
    } else {
      break;
    }
    if (unwrapped > 64) break;
  }
  if (unwrapped) {
    context.note(`removed ${unwrapped} WrapInFunction layer(s)`, unwrapped);
    context.bump('unwrap.layers', unwrapped);
  }
}

module.exports = { name: '01-wrap', run, matchWrapper, matchNamedWrapper };
