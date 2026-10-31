'use strict';

const A = require('../lua/ast');
const { Kind } = A;
const { walk } = require('../lua/walk');
const { resolve } = require('../lua/scope');
const { parse } = require('../lua/parser');
const { unparse } = require('../lua/unparse');
const { detectVmify, buildSingleValueMap } = require('../vmify/detect');
const { analyzeVmOpcodes } = require('../vmify/opcodes');
const { decompileVmifyRoot } = require('../vmify/decompile');
const simplify = require('./07-opt');
const varsStep = require('./08-vars');
const fmtStep = require('./09-fmt');

function normalizeVmFunction(vmFn) {
  const miniSrc = unparse(A.chunk(A.block([
    A.localDecl(['_vmFn'], [vmFn]),
    A.returnStatement([A.name('_vmFn')]),
  ])));
  const miniChunk = parse(miniSrc, { name: 'vmify-fn' });
  const miniCtx = {
    chunk: miniChunk,
    options: {},
    resolve() { return resolve(miniChunk); },
    note() {},
    warn() {},
    bump() {},
  };
  miniCtx.resolve();
  varsStep.run(miniCtx);
  miniCtx.resolve();
  fmtStep.run(miniCtx);
  miniCtx.resolve();

  let fn = null;
  for (const st of miniChunk.body.statements) {
    if (st.kind === Kind.LocalFunction) { fn = st.body; break; }
    if (st.kind === Kind.LocalDeclaration && st.expressions && st.expressions[0]
      && st.expressions[0].kind === Kind.Function) {
      fn = st.expressions[0];
      break;
    }
    if (st.kind === Kind.Return && st.expressions && st.expressions[0]
      && st.expressions[0].kind === Kind.Function) {
      fn = st.expressions[0];
      break;
    }
  }
  if (!fn) fn = vmFn;

  let whileNode = null;
  walk(fn.body, {
    enter(node) {
      if (node.kind === Kind.Function) return false;
      if (!whileNode && node.kind === Kind.While) {
        whileNode = node;
        return false;
      }
      return undefined;
    },
  });

  return {
    vmFn: fn,
    whileNode,
    single: buildSingleValueMap(miniChunk),
  };
}

function run(context) {
  context.resolve();
  const det = detectVmify(context.chunk);
  if (!det) return;

  const norm = normalizeVmFunction(det.vmFn);
  const ana = analyzeVmOpcodes({
    ...det,
    vmFn: norm.vmFn,
    whileNode: norm.whileNode || det.whileNode,
    single: norm.single,
  });
  if (!ana || !ana.opSpecs || ana.opSpecs.size === 0) return;

  const rootFn = decompileVmifyRoot(det.rootProto, ana.keys, ana.opSlot, ana.opSpecs);
  context.chunk.body = rootFn.body;
  context.resolve();
  context.note(`decompiled Vmify bytecode (${ana.opSpecs.size} opcodes)`, ana.opSpecs.size);
  context.bump('vmify.opcodes', ana.opSpecs.size);
}

module.exports = {
  name: '07b-vmify',
  run,
};
