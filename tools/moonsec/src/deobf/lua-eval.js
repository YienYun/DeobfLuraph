'use strict';






const { lua, lauxlib, lualib, to_luastring } = require('fengari');
const { PrettyPrinter } = require('../ast/pretty-printer.js');

function solveKeyExpression(node) {
    const L = lauxlib.luaL_newstate();
    lualib.luaL_openlibs(L);

    try {
        const code = `return (${PrettyPrinter.asString(node)})`;
        const status = lauxlib.luaL_loadstring(L, to_luastring(code));

        if (status !== lua.LUA_OK) {
            throw new Error(`Lua syntax error: ${lua.lua_tostring(L, -1)}`);
        }

        const result = lua.lua_pcall(L, 0, 1, 0);

        if (result !== lua.LUA_OK) {
            throw new Error(`Lua runtime error: ${lua.lua_tostring(L, -1)}`);
        }

        return lua.lua_tonumber(L, -1);
    } finally {
        lua.lua_close(L);
    }
}

module.exports = { solveKeyExpression };