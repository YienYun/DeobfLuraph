-- This file was deobfuscated by VX [ https://discord.gg/qa2fwcB7K ]
-- Fully expanded LuaObfuscator superinstructions

local unpack = table.unpack or unpack
local protos = {}
local function new_closed_cell(initial)
  local value = initial
  return {
    get = function() return value end,
    set = function(next_value) value = next_value end,
  }
end

protos["0_0"] = function(env, u)
  env = env or _ENV
  u = u or {}
  return function(...)
    local r = {}
    local args = {...}
    local argc = select('#', ...) - 1
    local varargs = {}
    local top = -1
    local open_upvalues = {}
    local function pack(...) return { n = select('#', ...), ... } end
    local function capture_register(index)
      local cell = open_upvalues[index]
      if cell == nil then
        cell = {}
        cell.get = function() return r[index] end
        cell.set = function(value) r[index] = value end
        open_upvalues[index] = cell
      end
      return cell
    end
    local function capture_upvalue(index)
      if u[index] == nil then u[index] = new_closed_cell(nil) end
      return u[index]
    end
    local function get_upvalue(index) return capture_upvalue(index).get() end
    local function set_upvalue(index, value) capture_upvalue(index).set(value) end
    local function close_upvalues(first)
      for index, cell in pairs(open_upvalues) do
        if index >= first then
          local value = cell.get()
          local closed = value
          cell.get = function() return closed end
          cell.set = function(next_value) closed = next_value end
          open_upvalues[index] = nil
        end
      end
    end
    for i = 0, argc do
      if i >= 2 then varargs[i - 2] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    r[2] = {}
    ::L2::
    r[3] = 1
    ::L3::
    r[4] = #r[0]
    ::L4::
    r[5] = 1
    ::L5::
    do local index = r[3]; local limit = r[4]; local step = r[5]; if (step > 0 and index > limit) or (step <= 0 and index < limit) then goto L34 else r[6] = index end end
    ::L6::
    r[7] = get_upvalue(0)
    ::L7::
    r[8] = r[2]
    ::L8::
    r[9] = get_upvalue(1)
    ::L9::
    r[10] = get_upvalue(2)
    ::L10::
    r[11] = get_upvalue(3)
    ::L11::
    r[12] = get_upvalue(4)
    ::L12::
    r[13] = r[0]
    ::L13::
    r[14] = r[6]
    ::L14::
    r[15] = r[6] + 1
    ::L15::
    do local out = pack(r[12](r[13])); top = 12 + out.n - 1; for i = 1, out.n do r[12 + i - 1] = out[i] end end
    ::L16::
    r[11] = r[11](unpack(r, 12, top))
    ::L17::
    r[12] = get_upvalue(3)
    ::L18::
    r[13] = get_upvalue(4)
    ::L19::
    r[14] = r[1]
    ::L20::
    r[15] = #r[1]
    ::L21::
    r[15] = r[6] % r[15]
    ::L22::
    r[15] = 1 + r[15]
    ::L23::
    r[16] = #r[1]
    ::L24::
    r[16] = r[6] % r[16]
    ::L25::
    r[16] = 1 + r[16]
    ::L26::
    r[16] = r[16] + 1
    ::L27::
    do local out = pack(r[13](r[14])); top = 13 + out.n - 1; for i = 1, out.n do r[13 + i - 1] = out[i] end end
    ::L28::
    do local out = pack(r[12](r[13])); top = 12 + out.n - 1; for i = 1, out.n do r[12 + i - 1] = out[i] end end
    ::L29::
    r[10] = r[10](unpack(r, 11, top))
    ::L30::
    r[10] = r[10] % 256
    ::L31::
    do local out = pack(r[9](r[10])); top = 9 + out.n - 1; for i = 1, out.n do r[9 + i - 1] = out[i] end end
    ::L32::
    r[7](unpack(r, 8, top))
    ::L33::
    do local step = r[5]; local index = r[3] + step; r[3] = index; if (step > 0 and index <= r[4]) or (step <= 0 and index >= r[4]) then r[6] = index; goto L6 end end
    ::L34::
    r[3] = get_upvalue(5)
    ::L35::
    r[4] = r[2]
    ::L36::
    do return r[3](unpack(r, 4, 4)) end
    ::L37::
    do return unpack(r, 3, top) end
    ::L38::
    do return end
  end
end

protos["0_1_0"] = function(env, u)
  env = env or _ENV
  u = u or {}
  return function(...)
    local r = {}
    local args = {...}
    local argc = select('#', ...) - 1
    local varargs = {}
    local top = -1
    local open_upvalues = {}
    local function pack(...) return { n = select('#', ...), ... } end
    local function capture_register(index)
      local cell = open_upvalues[index]
      if cell == nil then
        cell = {}
        cell.get = function() return r[index] end
        cell.set = function(value) r[index] = value end
        open_upvalues[index] = cell
      end
      return cell
    end
    local function capture_upvalue(index)
      if u[index] == nil then u[index] = new_closed_cell(nil) end
      return u[index]
    end
    local function get_upvalue(index) return capture_upvalue(index).get() end
    local function set_upvalue(index, value) capture_upvalue(index).set(value) end
    local function close_upvalues(first)
      for index, cell in pairs(open_upvalues) do
        if index >= first then
          local value = cell.get()
          local closed = value
          cell.get = function() return closed end
          cell.set = function(next_value) closed = next_value end
          open_upvalues[index] = nil
        end
      end
    end
    for i = 0, argc do
      if i >= 1 then varargs[i - 1] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    if r[0] then goto L3 else goto L10 end
    ::L2::
    goto L10
    ::L3::
    r[1] = env["print"]
    ::L4::
    r[2] = get_upvalue(0)
    ::L5::
    r[3] = "\200\204\212e\235\189\135\029\217\194\2121\239\184\135\027\199\202\215"
    ::L6::
    r[4] = "~\177\163\187E\134\219\167"
    ::L7::
    do local out = pack(r[2](r[3])); top = 2 + out.n - 1; for i = 1, out.n do r[2 + i - 1] = out[i] end end
    ::L8::
    r[1](unpack(r, 2, top))
    ::L9::
    goto L11
    ::L10::
    r[1] = r[0][1]
    ::L11::
    do return end
  end
end

protos["0_1"] = function(env, u)
  env = env or _ENV
  u = u or {}
  return function(...)
    local r = {}
    local args = {...}
    local argc = select('#', ...) - 1
    local varargs = {}
    local top = -1
    local open_upvalues = {}
    local function pack(...) return { n = select('#', ...), ... } end
    local function capture_register(index)
      local cell = open_upvalues[index]
      if cell == nil then
        cell = {}
        cell.get = function() return r[index] end
        cell.set = function(value) r[index] = value end
        open_upvalues[index] = cell
      end
      return cell
    end
    local function capture_upvalue(index)
      if u[index] == nil then u[index] = new_closed_cell(nil) end
      return u[index]
    end
    local function get_upvalue(index) return capture_upvalue(index).get() end
    local function set_upvalue(index, value) capture_upvalue(index).set(value) end
    local function close_upvalues(first)
      for index, cell in pairs(open_upvalues) do
        if index >= first then
          local value = cell.get()
          local closed = value
          cell.get = function() return closed end
          cell.set = function(next_value) closed = next_value end
          open_upvalues[index] = nil
        end
      end
    end
    for i = 0, argc do
      if i >= 0 then varargs[i - 0] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    r[0] = protos["0_1_0"](env, {
      [0] = capture_upvalue(0),
    })
    ::L3::
    r[1] = get_upvalue(1)
    ::L4::
    r[2] = get_upvalue(2)
    ::L5::
    r[3] = get_upvalue(2)
    ::L6::
    r[4] = {}
    ::L7::
    r[5] = get_upvalue(3)
    ::L8::
    r[6] = r[0]
    ::L9::
    for i = 7, 7 do r[i] = nil end
    ::L10::
    do local out = pack(r[5](r[6])); top = 5 + out.n - 1; for i = 1, out.n do r[5 + i - 1] = out[i] end end
    ::L11::
    for i = 5, top do table.insert(r[4], r[i]) end
    ::L12::
    r[4] = r[4][2]
    ::L13::
    r[5] = ":%d+:"
    ::L14::
    r[3] = r[3](unpack(r, 4, 5))
    ::L15::
    r[4] = "%d+"
    ::L16::
    do local out = pack(r[2](r[3])); top = 2 + out.n - 1; for i = 1, out.n do r[2 + i - 1] = out[i] end end
    ::L17::
    r[1] = r[1](unpack(r, 2, top))
    ::L18::
    if r[1] == 1 then goto L20 else goto L25 end
    ::L19::
    goto L25
    ::L20::
    r[1] = r[0]
    ::L21::
    r[2] = {}
    ::L22::
    do return r[1](unpack(r, 2, 2)) end
    ::L23::
    do return unpack(r, 1, top) end
    ::L24::
    goto L28
    ::L25::
    r[1] = get_upvalue(4)
    ::L26::
    do return r[1]() end
    ::L27::
    -- This Source Was Generated by discord.gg/c3xVMnUUBv
    do return unpack(r, 1, top) end
    ::L28::
    do return end
  end
end

protos["0"] = function(env, u)
  env = env or _ENV
  u = u or {}
  return function(...)
    local r = {}
    local args = {...}
    local argc = select('#', ...) - 1
    local varargs = {}
    local top = -1
    local open_upvalues = {}
    local function pack(...) return { n = select('#', ...), ... } end
    local function capture_register(index)
      local cell = open_upvalues[index]
      if cell == nil then
        cell = {}
        cell.get = function() return r[index] end
        cell.set = function(value) r[index] = value end
        open_upvalues[index] = cell
      end
      return cell
    end
    local function capture_upvalue(index)
      if u[index] == nil then u[index] = new_closed_cell(nil) end
      return u[index]
    end
    local function get_upvalue(index) return capture_upvalue(index).get() end
    local function set_upvalue(index, value) capture_upvalue(index).set(value) end
    local function close_upvalues(first)
      for index, cell in pairs(open_upvalues) do
        if index >= first then
          local value = cell.get()
          local closed = value
          cell.get = function() return closed end
          cell.set = function(next_value) closed = next_value end
          open_upvalues[index] = nil
        end
      end
    end
    for i = 0, argc do
      if i >= 0 then varargs[i - 0] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    r[0] = env["string"]
    ::L2::
    r[0] = r[0]["char"]
    ::L3::
    r[1] = env["string"]
    ::L4::
    r[1] = r[1]["byte"]
    ::L5::
    r[2] = env["string"]
    ::L6::
    r[2] = r[2]["sub"]
    ::L7::
    r[3] = env["bit32"]
    ::L8::
    if not r[3] then goto L10 else goto L11 end
    ::L9::
    goto L11
    ::L10::
    r[3] = env["bit"]
    ::L11::
    r[4] = r[3]["bxor"]
    ::L12::
    r[5] = env["table"]
    ::L13::
    r[5] = r[5]["concat"]
    ::L14::
    r[6] = env["table"]
    ::L15::
    r[6] = r[6]["insert"]
    ::L16::
    r[7] = protos["0_0"](env, {
      [0] = capture_upvalue(6),
      [1] = capture_upvalue(0),
      [2] = capture_upvalue(4),
      [3] = capture_upvalue(1),
      [4] = capture_upvalue(2),
      [5] = capture_upvalue(5),
    })
    ::L23::
    r[8] = env["string"]
    ::L24::
    r[8] = r[8]["match"]
    ::L25::
    r[9] = env["tonumber"]
    ::L26::
    r[10] = env["pcall"]
    ::L27::
    r[11] = protos["0_1"](env, {
      [0] = capture_upvalue(7),
      [1] = capture_upvalue(9),
      [2] = capture_upvalue(8),
      [3] = capture_upvalue(10),
      [4] = capture_upvalue(11),
    })
    ::L33::
    r[12] = r[11]
    ::L34::
    do return r[12]() end
    ::L35::
    do return unpack(r, 12, top) end
    ::L36::
    do return end
  end
end

print("Deobf By Zed")
return protos["0"](_ENV, {})()
