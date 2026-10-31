'use strict';

const A = require('../lua/ast');
const { Kind } = require('../lua/ast');
const { transform } = require('../lua/walk');
const C = require('../util/const');

const ARITH = new Set(['+', '-', '*', '/', '%', '^', '..']);
const UNARY = new Set(['-']);
const INT_OPS = new Set(['+', '-', '*', '%']);

const BINARY = new Set([...ARITH, '==', '~=', '<', '<=', '>', '>=', 'and', 'or']);
const LOGIC = new Set([...UNARY, 'not']);

const SCI_INT_RE = /^(\d+)(?:\.(\d*))?[eE]([+-]?\d+)$/;
const HEX_INT_RE = /^0[xX][0-9a-fA-F]+$/;
const BIN_INT_RE = /^0[bB][01]+$/;
const DEC_INT_RE = /^\d+$/;

const i64 = (x) => BigInt.asIntN(64, x);

function luaMod64(a, b) {
  if (b === 0n) return null;
  let r = a % b;
  if (r !== 0n && (r < 0n) !== (b < 0n)) r = i64(r + b);
  return i64(r);
}

function parseIntLeaf(node) {
  if (!node || node.kind !== Kind.Number) return null;
  const raw = node.raw;
  if (typeof raw === 'string') {
    if (HEX_INT_RE.test(raw) || BIN_INT_RE.test(raw) || DEC_INT_RE.test(raw)) {
      return { val: i64(BigInt(raw)), half: 0n };
    }
    const m = SCI_INT_RE.exec(raw);
    if (m) {
      const intPart = m[1];
      const fracPart = m[2] || '';
      const exp = parseInt(m[3], 10);
      if (exp < fracPart.length || exp > 20) return null;
      const digits = (intPart + fracPart).replace(/^0+/, '') || '0';
      if (digits === '0') return { val: 0n, half: 0n };
      const scale = exp - fracPart.length;
      const val = i64(BigInt(digits) * (10n ** BigInt(scale)));
      const k = intPart.replace(/^0+/, '').length - 1 + exp;
      const half = k >= 15 ? (10n ** BigInt(k - 14)) / 2n : 0n;
      return { val, half };
    }
    return null;
  }
  if (Number.isSafeInteger(node.value)) {
    return { val: i64(BigInt(node.value)), half: 0n };
  }
  return null;
}

function evalIntAst(node, overrides) {
  if (!node) return null;
  if (node.kind === Kind.Paren) return evalIntAst(node.expression, overrides);
  if (node.kind === Kind.Number) {
    if (overrides && overrides.has(node)) return overrides.get(node);
    const leaf = parseIntLeaf(node);
    return leaf ? leaf.val : null;
  }
  if (node.kind === Kind.Unary && node.operator === '-') {
    const v = evalIntAst(node.argument, overrides);
    return v === null ? null : i64(-v);
  }
  if (node.kind === Kind.Binary && INT_OPS.has(node.operator)) {
    const a = evalIntAst(node.lhs, overrides);
    if (a === null) return null;
    const b = evalIntAst(node.rhs, overrides);
    if (b === null) return null;
    switch (node.operator) {
      case '+': return i64(a + b);
      case '-': return i64(a - b);
      case '*': return i64(a * b);
      case '%': return luaMod64(a, b);
      default: return null;
    }
  }
  return null;
}

function collectIntInfo(node, out) {
  if (!node) return false;
  if (node.kind === Kind.Paren) {
    out.ops += 1;
    return collectIntInfo(node.expression, out);
  }
  if (node.kind === Kind.Number) {
    const leaf = parseIntLeaf(node);
    if (!leaf) return false;
    if (leaf.half > 0n) out.rounded.push({ node, val: leaf.val, half: leaf.half });
    return true;
  }
  if (node.kind === Kind.Unary && node.operator === '-') {
    out.ops += 1;
    return collectIntInfo(node.argument, out);
  }
  if (node.kind === Kind.Binary && INT_OPS.has(node.operator)) {
    out.ops += 1;
    return collectIntInfo(node.lhs, out) && collectIntInfo(node.rhs, out);
  }
  return false;
}

function foldBigIntSubtrees(root, binary, unary) {
  if (!binary.has('%') && !binary.has('+')) return 0;
  let folded = 0;

  const visit = (node) => {
    if (!node || typeof node !== 'object') return node;
    const isCandidate = (node.kind === Kind.Binary && INT_OPS.has(node.operator) && binary.has(node.operator))
      || (node.kind === Kind.Unary && node.operator === '-' && unary.has('-'));
    if (isCandidate) {
      const info = { ops: 0, rounded: [] };
      if (collectIntInfo(node, info) && info.ops > 0) {
        const exact = evalIntAst(node, null);
        if (exact !== null) {
          const numVal = Number(exact);
          const rep = A.number(numVal);
          if (info.rounded.length > 0) {
            let total = 1n;
            for (const r of info.rounded) total *= (2n * r.half + 1n);
            if (total <= 2048n) {
              const seen = new Set();
              const cands = [];
              const overrides = new Map();
              const step = (idx) => {
                if (idx === info.rounded.length) {
                  const sv = evalIntAst(node, overrides);
                  if (sv !== null) {
                    const nv = Number(sv);
                    if (!seen.has(nv)) {
                      seen.add(nv);
                      cands.push(nv);
                    }
                  }
                  return;
                }
                const item = info.rounded[idx];
                for (let d = -item.half; d <= item.half; d += 1n) {
                  overrides.set(item.node, i64(item.val + d));
                  step(idx + 1);
                }
              };
              step(0);
              if (cands.length > 1) rep.roundedCandidates = cands;
            }
          }
          folded += info.ops;
          return rep;
        }
      }
    }
    for (const key of Object.keys(node)) {
      if (key === 'binding' || key === 'bindings' || key === 'roundedCandidates') continue;
      const child = node[key];
      if (Array.isArray(child)) {
        for (let i = 0; i < child.length; i += 1) {
          if (child[i] && typeof child[i] === 'object') child[i] = visit(child[i]);
        }
      } else if (child && typeof child === 'object' && child.kind) {
        node[key] = visit(child);
      }
    }
    return node;
  };

  visit(root);
  return folded;
}

function foldTree(root, options = {}) {
  const binary = options.binary || ARITH;
  const unary = options.unary || UNARY;
  let folded = foldBigIntSubtrees(root, binary, unary);
  transform(root, (node) => {
    if (node.kind === Kind.Binary) {
      if (!binary.has(node.operator)) return node;
      const replacement = C.foldBinary(node.operator, node.lhs, node.rhs);
      if (replacement) {
        folded += 1;
        return replacement;
      }
      return node;
    }
    if (node.kind === Kind.Unary) {
      if (!unary.has(node.operator)) return node;
      const replacement = C.foldUnary(node.operator, node.argument);
      if (replacement) {
        folded += 1;
        return replacement;
      }
      return node;
    }
    if (node.kind === Kind.Paren) {
      const inner = node.expression;
      if (inner && C.isConstant(inner)) {
        folded += 1;
        return inner;
      }
      return node;
    }
    return node;
  });
  return folded;
}

function run(context) {
  const folded = foldTree(context.chunk);
  if (folded) {
    context.note(`folded ${folded} constant expression(s)`, folded);
    context.bump('fold.count', folded);
  }
}

module.exports = {
  name: '02-fold',
  run,
  foldTree,
  BINARY,
  LOGIC,
};
