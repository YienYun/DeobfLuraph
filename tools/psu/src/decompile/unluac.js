import { createRequire } from "node:module";
import path from "node:path";
import { fileURLToPath } from "node:url";

const require = createRequire(import.meta.url);
const here = path.dirname(fileURLToPath(import.meta.url));
const { decompileLua51Bytecode } = require(path.resolve(here, "../../../../src/luac_decompile.js"));

export function decompileLua51(bytecode, options = {}) {
  return decompileLua51Bytecode(bytecode, options).trim();
}
