-- LuaObfuscator: decoded register machine (2152 labelled blocks, 2181 instructions).
-- Every instruction is classified and the control flow is intact, but this is
-- still a machine listing: labels/goto are not Luau. Structural lift pending.
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
    r[2] = 0
    ::L2::
    for i = 3, 5 do r[i] = nil end
    ::L3::
    if r[2] == 2 then goto L5 else goto L9 end
    ::L4::
    goto L9
    ::L5::
    r[6] = r[3]
    ::L6::
    r[7] = r[5]
    ::L7::
    r[8] = r[4]
    ::L8::
    do return unpack(r, 6, 8) end
    ::L9::
    if r[2] == 0 then goto L11 else goto L16 end
    ::L10::
    goto L16
    ::L11::
    if r[1] then r[3] = r[1]; goto L14 else goto L13 end
    ::L12::
    goto L14
    ::L13::
    r[3] = 2166136261
    ::L14::
    r[4] = #r[0]
    ::L15::
    r[2] = 1
    ::L16::
    if r[2] == 1 then goto L18 else goto L3 end
    ::L17::
    goto L3
    ::L18::
    r[6] = 1
    ::L19::
    r[7] = r[4]
    ::L20::
    r[8] = 1
    ::L21::
    do local index = r[6]; local limit = r[7]; local step = r[8]; if (step > 0 and index > limit) or (step <= 0 and index < limit) then goto L40 else r[9] = index end end
    ::L22::
    r[10] = 0
    ::L23::
    for i = 11, 11 do r[i] = nil end
    ::L24::
    if r[10] == 0 then goto L26 else goto L24 end
    ::L25::
    goto L24
    ::L26::
    r[12] = env["string"]
    ::L27::
    r[12] = r[12]["byte"]
    ::L28::
    r[13] = r[0]
    ::L29::
    r[14] = r[9]
    ::L30::
    r[12] = r[12](unpack(r, 13, 14))
    ::L31::
    r[11] = r[12]
    ::L32::
    r[12] = r[3] * 16777619
    ::L33::
    r[13] = r[9] + 7
    ::L34::
    r[13] = r[11] * r[13]
    ::L35::
    r[12] = r[12] + r[13]
    ::L36::
    r[3] = r[12] % 4294967296
    ::L37::
    goto L39
    ::L38::
    goto L24
    ::L39::
    do local step = r[8]; local index = r[6] + step; r[6] = index; if (step > 0 and index <= r[7]) or (step <= 0 and index >= r[7]) then r[9] = index; goto L22 end end
    ::L40::
    r[6] = env["string"]
    ::L41::
    r[6] = r[6]["format"]
    ::L42::
    r[7] = "%08X"
    ::L43::
    r[8] = r[3]
    ::L44::
    r[6] = r[6](unpack(r, 7, 8))
    ::L45::
    r[5] = r[6]
    ::L46::
    r[2] = 2
    ::L47::
    goto L3
    ::L48::
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
      if i >= 3 then varargs[i - 3] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    if r[0] < r[1] then goto L3 else goto L7 end
    ::L2::
    goto L7
    ::L3::
    r[3] = r[1]
    ::L4::
    r[4] = "clamped_low"
    ::L5::
    do return r[3], r[4] end
    ::L6::
    goto L12
    ::L7::
    if r[2] < r[0] then goto L9 else goto L12 end
    ::L8::
    goto L12
    ::L9::
    r[3] = r[2]
    ::L10::
    r[4] = "clamped_high"
    ::L11::
    do return r[3], r[4] end
    ::L12::
    r[3] = r[0]
    ::L13::
    r[4] = "exact"
    ::L14::
    do return r[3], r[4] end
    ::L15::
    do return end
  end
end

protos["0_2"] = function(env, u)
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
    r[1] = 0
    ::L2::
    for i = 2, 4 do r[i] = nil end
    ::L3::
    if r[1] == 0 then goto L5 else goto L8 end
    ::L4::
    goto L8
    ::L5::
    r[2] = 0
    ::L6::
    for i = 3, 3 do r[i] = nil end
    ::L7::
    r[1] = 1
    ::L8::
    if r[1] == 1 then goto L10 else goto L3 end
    ::L9::
    goto L3
    ::L10::
    for i = 4, 4 do r[i] = nil end
    ::L11::
    if r[2] == 1 then goto L13 else goto L26 end
    ::L12::
    goto L26
    ::L13::
    r[5] = 1
    ::L14::
    r[6] = r[3]
    ::L15::
    r[7] = 1
    ::L16::
    do local index = r[5]; local limit = r[6]; local step = r[7]; if (step > 0 and index > limit) or (step <= 0 and index < limit) then goto L23 else r[8] = index end end
    ::L17::
    r[9] = env["select"]
    ::L18::
    r[10] = r[8]
    ::L19::
    do local out = pack(r[11](r[12])); top = 11 + out.n - 1; for i = 1, out.n do r[11 + i - 1] = out[i] end end
    ::L20::
    r[9] = r[9](unpack(r, 10, top))
    ::L21::
    r[4][r[8]] = r[9]
    ::L22::
    do local step = r[7]; local index = r[5] + step; r[5] = index; if (step > 0 and index <= r[6]) or (step <= 0 and index >= r[6]) then r[8] = index; goto L17 end end
    ::L23::
    r[5] = r[4]
    ::L24::
    r[6] = r[3]
    ::L25::
    do return r[5], r[6] end
    ::L26::
    if r[2] == 0 then goto L28 else goto L11 end
    ::L27::
    goto L11
    ::L28::
    r[5] = env["select"]
    ::L29::
    r[6] = "#"
    ::L30::
    do local out = pack(r[7](r[8])); top = 7 + out.n - 1; for i = 1, out.n do r[7 + i - 1] = out[i] end end
    ::L31::
    r[5] = r[5](unpack(r, 6, top))
    ::L32::
    r[3] = r[5]
    ::L33::
    r[5] = {}
    ::L34::
    r[5]["n"] = r[3]
    ::L35::
    r[4] = r[5]
    ::L36::
    r[2] = 1
    ::L37::
    goto L11
    ::L38::
    goto L40
    ::L39::
    goto L3
    ::L40::
    do return end
  end
end

protos["0_3_0_0"] = function(env, u)
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
    r[0] = get_upvalue(0)
    ::L2::
    r[1] = r[0]
    r[0] = r[0]["JSONDecode"]
    ::L3::
    r[2] = env["readfile"]
    ::L4::
    r[3] = get_upvalue(1)
    ::L5::
    do local out = pack(r[2](r[3])); top = 2 + out.n - 1; for i = 1, out.n do r[2 + i - 1] = out[i] end end
    ::L6::
    do return unpack(r, 0, top) end
    ::L7::
    do return unpack(r, 0, top) end
    ::L8::
    do return end
  end
end

protos["0_3_0"] = function(env, u)
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
    r[0] = 0
    ::L2::
    for i = 1, 3 do r[i] = nil end
    ::L3::
    if r[0] == 0 then goto L5 else goto L8 end
    ::L4::
    goto L8
    ::L5::
    r[1] = 0
    ::L6::
    for i = 2, 2 do r[i] = nil end
    ::L7::
    r[0] = 1
    ::L8::
    if r[0] == 1 then goto L10 else goto L3 end
    ::L9::
    goto L3
    ::L10::
    for i = 3, 3 do r[i] = nil end
    ::L11::
    r[4] = 0
    ::L12::
    if r[4] == 0 then goto L14 else goto L73 end
    ::L13::
    goto L73
    ::L14::
    if r[1] == 1 then goto L16 else goto L48 end
    ::L15::
    goto L48
    ::L16::
    if r[2] then goto L18 else goto L23 end
    ::L17::
    goto L23
    ::L18::
    r[5] = env["type"]
    ::L19::
    r[6] = r[3]
    ::L20::
    r[5] = r[5](r[6])
    ::L21::
    if r[5] ~= "table" then goto L23 else goto L26 end
    ::L22::
    goto L26
    ::L23::
    r[5] = false
    ::L24::
    r[6] = "corrupt_json"
    ::L25::
    do return r[5], r[6] end
    ::L26::
    r[5] = env["pairs"]
    ::L27::
    r[6] = r[3]
    ::L28::
    do local out = {r[5](r[6])}; for i = 0, 2 do r[5 + i] = out[i + 1] end end
    ::L29::
    goto L45
    ::L30::
    r[10] = get_upvalue(0)
    ::L31::
    r[10] = r[10][r[8]]
    ::L32::
    if r[10] ~= nil then goto L34 else goto L45 end
    ::L33::
    goto L45
    ::L34::
    r[10] = env["type"]
    ::L35::
    r[11] = get_upvalue(0)
    ::L36::
    r[11] = r[11][r[8]]
    ::L37::
    r[10] = r[10](r[11])
    ::L38::
    r[11] = env["type"]
    ::L39::
    r[12] = r[9]
    ::L40::
    r[11] = r[11](r[12])
    ::L41::
    if r[10] == r[11] then goto L43 else goto L45 end
    ::L42::
    goto L45
    ::L43::
    r[10] = get_upvalue(0)
    ::L44::
    r[10][r[8]] = r[9]
    ::L45::
    do local out = {r[5](r[6], r[7])}; for i = 1, 2 do r[7 + i] = out[i] end; if out[1] then r[7] = out[1]; goto L30 else goto L47 end end
    ::L46::
    goto L30
    ::L47::
    r[1] = 2
    ::L48::
    if r[1] == 0 then goto L50 else goto L72 end
    ::L49::
    goto L72
    ::L50::
    r[5] = env["isfile"]
    ::L51::
    if r[5] then goto L53 else goto L61 end
    ::L52::
    goto L61
    ::L53::
    r[5] = env["readfile"]
    ::L54::
    if r[5] then goto L56 else goto L61 end
    ::L55::
    goto L61
    ::L56::
    r[5] = env["isfile"]
    ::L57::
    r[6] = get_upvalue(1)
    ::L58::
    r[5] = r[5](r[6])
    ::L59::
    if not r[5] then goto L61 else goto L64 end
    ::L60::
    goto L64
    ::L61::
    r[5] = false
    ::L62::
    r[6] = "no_file"
    ::L63::
    do return r[5], r[6] end
    ::L64::
    r[5] = env["pcall"]
    ::L65::
    r[6] = protos["0_3_0_0"](env, {
      [0] = capture_upvalue(2),
      [1] = capture_upvalue(1),
    })
    ::L68::
    do local out = {r[5](r[6])}; for i = 0, 1 do r[5 + i] = out[i + 1] end end
    ::L69::
    r[3] = r[6]
    ::L70::
    r[2] = r[5]
    ::L71::
    r[1] = 1
    ::L72::
    r[4] = 1
    ::L73::
    if r[4] == 1 then goto L75 else goto L12 end
    ::L74::
    goto L12
    ::L75::
    if r[1] == 2 then goto L77 else goto L11 end
    ::L76::
    goto L11
    ::L77::
    r[5] = true
    ::L78::
    r[6] = "loaded"
    ::L79::
    do return r[5], r[6] end
    ::L80::
    goto L11
    ::L81::
    goto L12
    ::L82::
    goto L11
    ::L83::
    goto L85
    ::L84::
    goto L3
    ::L85::
    do return end
  end
end

protos["0_3_1_0"] = function(env, u)
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
    -- This Source Was Generated by discord.gg/c3xVMnUUBv
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
    r[0] = get_upvalue(0)
    ::L2::
    r[1] = r[0]
    r[0] = r[0]["JSONEncode"]
    ::L3::
    r[2] = get_upvalue(1)
    ::L4::
    do return r[0](unpack(r, 1, 2)) end
    ::L5::
    do return unpack(r, 0, top) end
    ::L6::
    do return end
  end
end

protos["0_3_1"] = function(env, u)
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
    r[1] = 0
    ::L2::
    for i = 2, 5 do r[i] = nil end
    ::L3::
    r[6] = 0
    ::L4::
    if r[6] == 0 then goto L6 else goto L65 end
    ::L5::
    goto L65
    ::L6::
    if r[1] == 1 then goto L8 else goto L27 end
    ::L7::
    goto L27
    ::L8::
    if not r[2] then goto L10 else goto L19 end
    ::L9::
    goto L19
    ::L10::
    r[7] = env["warn"]
    ::L11::
    r[8] = "[Nebula] Encode failed: "
    ::L12::
    r[9] = env["tostring"]
    ::L13::
    r[10] = r[3]
    ::L14::
    r[9] = r[9](r[10])
    ::L15::
    do local value = r[8]; for i = 9, 9 do value = value .. r[i] end; r[8] = value end
    ::L16::
    r[7](r[8])
    ::L17::
    r[7] = false
    ::L18::
    do return r[7] end
    ::L19::
    r[7] = env["pcall"]
    ::L20::
    r[8] = env["writefile"]
    ::L21::
    r[9] = get_upvalue(0)
    ::L22::
    r[10] = r[3]
    ::L23::
    do local out = {r[7](r[8])}; for i = 0, 1 do r[7 + i] = out[i + 1] end end
    ::L24::
    r[5] = r[8]
    ::L25::
    r[4] = r[7]
    ::L26::
    r[1] = 2
    ::L27::
    if r[1] == 0 then goto L29 else goto L64 end
    ::L28::
    goto L64
    ::L29::
    r[7] = env["writefile"]
    ::L30::
    if not r[7] then goto L32 else goto L56 end
    ::L31::
    goto L56
    ::L32::
    r[7] = 0
    ::L33::
    for i = 8, 8 do r[i] = nil end
    ::L34::
    if r[7] == 0 then goto L36 else goto L34 end
    ::L35::
    goto L34
    ::L36::
    r[8] = 0
    ::L37::
    if r[8] == 0 then goto L39 else goto L37 end
    ::L38::
    goto L37
    ::L39::
    r[9] = 0
    ::L40::
    if r[9] == 0 then goto L42 else goto L40 end
    ::L41::
    goto L40
    ::L42::
    r[10] = env["warn"]
    ::L43::
    r[11] = "[Nebula] Executor missing writefile; skipped save ("
    ::L44::
    r[12] = env["tostring"]
    ::L45::
    r[13] = r[0]
    ::L46::
    r[12] = r[12](r[13])
    ::L47::
    r[13] = ")"
    ::L48::
    do local value = r[11]; for i = 12, 13 do value = value .. r[i] end; r[11] = value end
    ::L49::
    r[10](r[11])
    ::L50::
    r[10] = false
    ::L51::
    do return r[10] end
    ::L52::
    goto L40
    ::L53::
    goto L37
    ::L54::
    goto L56
    ::L55::
    goto L34
    ::L56::
    r[7] = env["pcall"]
    ::L57::
    r[8] = protos["0_3_1_0"](env, {
      [0] = capture_upvalue(1),
      [1] = capture_upvalue(2),
    })
    ::L60::
    do local out = {r[7](r[8])}; for i = 0, 1 do r[7 + i] = out[i + 1] end end
    ::L61::
    r[3] = r[8]
    ::L62::
    r[2] = r[7]
    ::L63::
    r[1] = 1
    ::L64::
    r[6] = 1
    ::L65::
    if 1 == r[6] then goto L67 else goto L4 end
    ::L66::
    goto L4
    ::L67::
    if r[1] == 3 then goto L69 else goto L71 end
    ::L68::
    goto L71
    ::L69::
    r[7] = false
    ::L70::
    do return r[7] end
    ::L71::
    if r[1] == 2 then goto L73 else goto L3 end
    ::L72::
    goto L3
    ::L73::
    if r[4] then goto L75 else goto L107 end
    ::L74::
    goto L107
    ::L75::
    r[7] = 0
    ::L76::
    for i = 8, 10 do r[i] = nil end
    ::L77::
    if r[7] == 1 then goto L79 else goto L83 end
    ::L78::
    goto L83
    ::L79::
    r[11] = 0
    ::L80::
    set_upvalue(3, r[11])
    ::L81::
    r[11] = true
    ::L82::
    do return r[11] end
    ::L83::
    if 0 == r[7] then goto L85 else goto L77 end
    ::L84::
    goto L77
    ::L85::
    r[11] = get_upvalue(4)
    ::L86::
    r[12] = r[3]
    ::L87::
    r[13] = get_upvalue(3)
    ::L88::
    r[13] = r[13] + 17
    ::L89::
    do local out = {r[11](r[12])}; for i = 0, 2 do r[11 + i] = out[i + 1] end end
    ::L90::
    r[10] = r[13]
    ::L91::
    r[9] = r[12]
    ::L92::
    r[8] = r[11]
    ::L93::
    r[11] = get_upvalue(5)
    ::L94::
    r[12] = get_upvalue(5)
    ::L95::
    r[12] = #r[12]
    ::L96::
    r[12] = r[12] + 1
    ::L97::
    r[13] = {}
    ::L98::
    r[13]["tag"] = r[9]
    ::L99::
    r[13]["bytes"] = r[10]
    ::L100::
    if r[0] then r[14] = r[0]; goto L103 else goto L102 end
    ::L101::
    goto L103
    ::L102::
    r[14] = "manual"
    ::L103::
    r[13]["reason"] = r[14]
    ::L104::
    r[11][r[12]] = r[13]
    ::L105::
    r[7] = 1
    ::L106::
    goto L77
    ::L107::
    r[7] = env["warn"]
    ::L108::
    r[8] = "[Nebula] Save failed: "
    ::L109::
    r[9] = env["tostring"]
    ::L110::
    r[10] = r[5]
    ::L111::
    r[9] = r[9](r[10])
    ::L112::
    do local value = r[8]; for i = 9, 9 do value = value .. r[i] end; r[8] = value end
    ::L113::
    r[7](r[8])
    ::L114::
    r[1] = 3
    ::L115::
    goto L3
    ::L116::
    goto L4
    ::L117::
    goto L3
    ::L118::
    do return end
  end
end

protos["0_3_2"] = function(env, u)
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
      if i >= 3 then varargs[i - 3] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    r[3] = 0
    ::L2::
    for i = 4, 4 do r[i] = nil end
    ::L3::
    if r[3] == 0 then goto L5 else goto L3 end
    ::L4::
    goto L3
    ::L5::
    r[4] = 0
    ::L6::
    r[5] = 0
    ::L7::
    if r[5] == 0 then goto L9 else goto L28 end
    ::L8::
    goto L28
    ::L9::
    if 2 == r[4] then goto L11 else goto L14 end
    ::L10::
    goto L14
    ::L11::
    r[6] = true
    ::L12::
    r[7] = r[1]
    ::L13::
    do return r[6], r[7] end
    ::L14::
    if r[4] == 0 then goto L16 else goto L27 end
    ::L15::
    goto L27
    ::L16::
    r[6] = get_upvalue(0)
    ::L17::
    r[6] = r[6][r[0]]
    ::L18::
    if r[6] == r[1] then goto L20 else goto L24 end
    ::L19::
    goto L24
    ::L20::
    r[6] = false
    ::L21::
    r[7] = get_upvalue(0)
    ::L22::
    r[7] = r[7][r[0]]
    ::L23::
    do return r[6], r[7] end
    ::L24::
    r[6] = get_upvalue(0)
    ::L25::
    r[6][r[0]] = r[1]
    ::L26::
    r[4] = 1
    ::L27::
    r[5] = 1
    ::L28::
    if r[5] == 1 then goto L30 else goto L7 end
    ::L29::
    goto L7
    ::L30::
    if r[4] == 1 then goto L32 else goto L6 end
    ::L31::
    goto L6
    ::L32::
    r[6] = get_upvalue(1)
    ::L33::
    r[6] = r[6] + 1
    ::L34::
    set_upvalue(1, r[6])
    ::L35::
    if r[2] then goto L37 else goto L44 end
    ::L36::
    goto L44
    ::L37::
    r[6] = get_upvalue(2)
    ::L38::
    r[7] = "set:"
    ::L39::
    r[8] = env["tostring"]
    ::L40::
    r[9] = r[0]
    ::L41::
    r[8] = r[8](r[9])
    ::L42::
    do local value = r[7]; for i = 8, 8 do value = value .. r[i] end; r[7] = value end
    ::L43::
    r[6](r[7])
    ::L44::
    r[4] = 2
    ::L45::
    goto L6
    ::L46::
    goto L7
    ::L47::
    goto L6
    ::L48::
    goto L50
    ::L49::
    goto L3
    ::L50::
    do return end
  end
end

protos["0_3_3"] = function(env, u)
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
    r[1] = get_upvalue(0)
    ::L2::
    r[1] = r[1][r[0]]
    ::L3::
    r[2] = get_upvalue(1)
    ::L4::
    do return r[1], r[2] end
    ::L5::
    do return end
  end
end

protos["0_3"] = function(env, u)
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
    r[1] = 0
    ::L2::
    for i = 2, 8 do r[i] = nil end
    ::L3::
    if r[1] == 3 then goto L5 else goto L13 end
    ::L4::
    goto L13
    ::L5::
    r[9] = {}
    ::L6::
    r[9]["load"] = r[5]
    ::L7::
    r[9]["save"] = r[6]
    ::L8::
    r[9]["set"] = r[7]
    ::L9::
    r[9]["get"] = r[8]
    ::L10::
    r[9]["raw"] = r[2]
    ::L11::
    r[9]["history"] = r[4]
    ::L12::
    do return r[9] end
    ::L13::
    if r[1] == 1 then goto L15 else goto L29 end
    ::L14::
    goto L29
    ::L15::
    for i = 5, 5 do r[i] = nil end
    ::L16::
    r[5] = protos["0_3_0"](env, {
      [0] = capture_upvalue(2),
      [1] = capture_upvalue(0),
      [2] = capture_upvalue(1),
    })
    ::L20::
    for i = 6, 6 do r[i] = nil end
    ::L21::
    r[6] = protos["0_3_1"](env, {
      [0] = capture_upvalue(0),
      [1] = capture_upvalue(1),
      [2] = capture_upvalue(2),
      [3] = capture_upvalue(3),
      [4] = capture_upvalue(2),
      [5] = capture_upvalue(4),
    })
    ::L28::
    r[1] = 2
    ::L29::
    if 0 == r[1] then goto L31 else goto L59 end
    ::L30::
    goto L59
    ::L31::
    r[9] = {}
    ::L32::
    r[2] = r[9]
    ::L33::
    r[3] = 0
    ::L34::
    r[9] = {}
    ::L35::
    r[4] = r[9]
    ::L36::
    r[9] = env["pairs"]
    ::L37::
    r[10] = r[0]
    ::L38::
    do local out = {r[9](r[10])}; for i = 0, 2 do r[9 + i] = out[i + 1] end end
    ::L39::
    goto L56
    ::L40::
    r[14] = env["type"]
    ::L41::
    r[15] = r[13]
    ::L42::
    r[14] = r[14](r[15])
    ::L43::
    if r[14] == "table" then goto L45 else goto L55 end
    ::L44::
    goto L55
    ::L45::
    r[14] = {}
    ::L46::
    r[15] = env["pairs"]
    ::L47::
    r[16] = r[13]
    ::L48::
    do local out = {r[15](r[16])}; for i = 0, 2 do r[15 + i] = out[i + 1] end end
    ::L49::
    goto L51
    ::L50::
    r[14][r[18]] = r[19]
    ::L51::
    do local out = {r[15](r[16], r[17])}; for i = 1, 2 do r[17 + i] = out[i] end; if out[1] then r[17] = out[1]; goto L50 else goto L53 end end
    ::L52::
    goto L50
    ::L53::
    r[2][r[12]] = r[14]
    ::L54::
    goto L56
    ::L55::
    r[2][r[12]] = r[13]
    ::L56::
    do local out = {r[9](r[10], r[11])}; for i = 1, 2 do r[11 + i] = out[i] end; if out[1] then r[11] = out[1]; goto L40 else goto L58 end end
    ::L57::
    goto L40
    ::L58::
    r[1] = 1
    ::L59::
    if 2 == r[1] then goto L61 else goto L3 end
    ::L60::
    goto L3
    ::L61::
    for i = 7, 7 do r[i] = nil end
    ::L62::
    r[7] = protos["0_3_2"](env, {
      [0] = capture_upvalue(2),
      [1] = capture_upvalue(3),
      [2] = capture_upvalue(6),
    })
    ::L66::
    for i = 8, 8 do r[i] = nil end
    ::L67::
    r[8] = protos["0_3_3"](env, {
      [0] = capture_upvalue(2),
      [1] = capture_upvalue(3),
    })
    ::L70::
    r[1] = 3
    ::L71::
    goto L3
    ::L72::
    do return end
  end
end

protos["0_4"] = function(env, u)
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
    r[2] = 0
    ::L2::
    for i = 3, 3 do r[i] = nil end
    ::L3::
    if r[2] == 3 then goto L5 else goto L7 end
    ::L4::
    goto L7
    ::L5::
    r[3]["connection"] = nil
    ::L6::
    do return r[3] end
    ::L7::
    if 1 == r[2] then goto L9 else goto L16 end
    ::L8::
    goto L16
    ::L9::
    if r[1] then r[4] = r[1]; goto L12 else goto L11 end
    ::L10::
    goto L12
    ::L11::
    r[4] = 8.5
    ::L12::
    r[3]["maxBudgetMs"] = r[4]
    ::L13::
    r[4] = {}
    ::L14::
    r[3]["jobs"] = r[4]
    ::L15::
    r[2] = 2
    ::L16::
    if r[2] == 2 then goto L18 else goto L21 end
    ::L17::
    goto L21
    ::L18::
    r[3]["totalTicks"] = 0
    ::L19::
    r[3]["running"] = false
    ::L20::
    r[2] = 3
    ::L21::
    if 0 == r[2] then goto L23 else goto L3 end
    ::L22::
    goto L3
    ::L23::
    r[4] = env["setmetatable"]
    ::L24::
    r[5] = {}
    ::L25::
    r[6] = get_upvalue(0)
    ::L26::
    r[4] = r[4](unpack(r, 5, 6))
    ::L27::
    r[3] = r[4]
    ::L28::
    if r[0] then r[4] = r[0]; goto L31 else goto L30 end
    ::L29::
    goto L31
    ::L30::
    r[4] = "MainScheduler"
    ::L31::
    r[3]["label"] = r[4]
    ::L32::
    r[2] = 1
    ::L33::
    goto L3
    ::L34::
    do return end
  end
end

protos["0_5"] = function(env, u)
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
      if i >= 4 then varargs[i - 4] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    r[4] = 0
    ::L2::
    for i = 5, 5 do r[i] = nil end
    ::L3::
    r[6] = 0
    ::L4::
    if r[6] == 0 then goto L6 else goto L4 end
    ::L5::
    goto L4
    ::L6::
    if r[4] == 0 then goto L8 else goto L37 end
    ::L7::
    goto L37
    ::L8::
    r[7] = 0
    ::L9::
    if r[7] == 0 then goto L11 else goto L32 end
    ::L10::
    goto L32
    ::L11::
    r[8] = {}
    ::L12::
    r[8]["name"] = r[1]
    ::L13::
    r[9] = env["math"]
    ::L14::
    r[9] = r[9]["max"]
    ::L15::
    if r[2] then r[10] = r[2]; goto L18 else goto L17 end
    ::L16::
    goto L18
    ::L17::
    r[10] = 0.1
    ::L18::
    r[11] = 0.01
    ::L19::
    r[9] = r[9](unpack(r, 10, 11))
    ::L20::
    r[8]["interval"] = r[9]
    ::L21::
    r[8]["elapsed"] = 0
    ::L22::
    r[8]["runs"] = 0
    ::L23::
    r[8]["active"] = true
    ::L24::
    r[8]["fn"] = r[3]
    ::L25::
    r[5] = r[8]
    ::L26::
    r[8] = r[0]["jobs"]
    ::L27::
    r[9] = r[0]["jobs"]
    ::L28::
    r[9] = #r[9]
    ::L29::
    r[9] = r[9] + 1
    ::L30::
    r[8][r[9]] = r[5]
    ::L31::
    r[7] = 1
    ::L32::
    if r[7] == 1 then goto L34 else goto L9 end
    ::L33::
    goto L9
    ::L34::
    r[4] = 1
    ::L35::
    goto L37
    ::L36::
    goto L9
    ::L37::
    if r[4] == 1 then goto L39 else goto L3 end
    ::L38::
    goto L3
    ::L39::
    do return r[5] end
    ::L40::
    goto L3
    ::L41::
    goto L4
    ::L42::
    goto L3
    ::L43::
    do return end
  end
end

protos["0_6"] = function(env, u)
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
    r[1] = 0
    ::L2::
    for i = 2, 2 do r[i] = nil end
    ::L3::
    r[3] = 0
    ::L4::
    if r[3] == 0 then goto L6 else goto L4 end
    ::L5::
    goto L4
    ::L6::
    if r[1] == 0 then goto L8 else goto L44 end
    ::L7::
    goto L44
    ::L8::
    r[2] = 0
    ::L9::
    r[4] = r[0]["jobs"]
    ::L10::
    r[4] = #r[4]
    ::L11::
    r[5] = 1
    ::L12::
    r[6] = -1
    ::L13::
    do local index = r[4]; local limit = r[5]; local step = r[6]; if (step > 0 and index > limit) or (step <= 0 and index < limit) then goto L43 else r[7] = index end end
    ::L14::
    r[8] = 0
    ::L15::
    for i = 9, 9 do r[i] = nil end
    ::L16::
    if 0 == r[8] then goto L18 else goto L16 end
    ::L17::
    goto L16
    ::L18::
    r[10] = r[0]["jobs"]
    ::L19::
    r[9] = r[10][r[7]]
    ::L20::
    r[10] = r[9]["active"]
    ::L21::
    if not r[10] then goto L23 else goto L42 end
    ::L22::
    goto L42
    ::L23::
    r[10] = 0
    ::L24::
    for i = 11, 11 do r[i] = nil end
    ::L25::
    if 0 == r[10] then goto L27 else goto L25 end
    ::L26::
    goto L25
    ::L27::
    r[11] = 0
    ::L28::
    if r[11] == 0 then goto L30 else goto L28 end
    ::L29::
    goto L28
    ::L30::
    r[12] = env["table"]
    ::L31::
    r[12] = r[12]["remove"]
    ::L32::
    r[13] = r[0]["jobs"]
    ::L33::
    r[14] = r[7]
    ::L34::
    r[12](unpack(r, 13, 14))
    ::L35::
    r[2] = r[2] + 1
    ::L36::
    goto L42
    ::L37::
    goto L28
    ::L38::
    goto L42
    ::L39::
    goto L25
    ::L40::
    goto L42
    ::L41::
    goto L16
    ::L42::
    do local step = r[6]; local index = r[4] + step; r[4] = index; if (step > 0 and index <= r[5]) or (step <= 0 and index >= r[5]) then r[7] = index; goto L14 end end
    ::L43::
    r[1] = 1
    ::L44::
    if r[1] == 1 then goto L46 else goto L3 end
    ::L45::
    goto L3
    ::L46::
    do return r[2] end
    ::L47::
    goto L3
    ::L48::
    goto L4
    ::L49::
    goto L3
    ::L50::
    do return end
  end
end

protos["0_7"] = function(env, u)
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
    r[2] = 0
    ::L2::
    for i = 3, 3 do r[i] = nil end
    ::L3::
    r[4] = 0
    ::L4::
    if r[4] == 1 then goto L6 else goto L10 end
    ::L5::
    goto L10
    ::L6::
    if r[2] == 2 then goto L8 else goto L3 end
    ::L7::
    goto L3
    ::L8::
    do return r[3] end
    ::L9::
    goto L3
    ::L10::
    if r[4] == 0 then goto L12 else goto L4 end
    ::L11::
    goto L4
    ::L12::
    if r[2] == 1 then goto L14 else goto L82 end
    ::L13::
    goto L82
    ::L14::
    r[5] = env["ipairs"]
    ::L15::
    r[6] = r[0]["jobs"]
    ::L16::
    do local out = {r[5](r[6])}; for i = 0, 2 do r[5 + i] = out[i + 1] end end
    ::L17::
    goto L73
    ::L18::
    r[10] = r[9]["active"]
    ::L19::
    if r[10] then goto L21 else goto L73 end
    ::L20::
    goto L73
    ::L21::
    r[10] = 0
    ::L22::
    for i = 11, 11 do r[i] = nil end
    ::L23::
    if r[10] == 0 then goto L25 else goto L23 end
    ::L24::
    goto L23
    ::L25::
    r[11] = 0
    ::L26::
    if r[11] == 0 then goto L28 else goto L26 end
    ::L27::
    goto L26
    ::L28::
    r[12] = r[9]["elapsed"]
    ::L29::
    r[12] = r[12] + r[1]
    ::L30::
    r[9]["elapsed"] = r[12]
    ::L31::
    r[12] = r[9]["elapsed"]
    ::L32::
    r[13] = r[9]["interval"]
    ::L33::
    if r[13] <= r[12] then goto L35 else goto L73 end
    ::L34::
    goto L73
    ::L35::
    r[9]["elapsed"] = 0
    ::L36::
    r[12] = r[9]["runs"]
    ::L37::
    r[12] = r[12] + 1
    ::L38::
    r[9]["runs"] = r[12]
    ::L39::
    r[12] = env["pcall"]
    ::L40::
    r[13] = r[9]["fn"]
    ::L41::
    r[14] = r[9]["runs"]
    ::L42::
    r[15] = r[1]
    ::L43::
    r[16] = r[0]["totalTicks"]
    ::L44::
    do local out = {r[12](r[13])}; for i = 0, 1 do r[12 + i] = out[i + 1] end end
    ::L45::
    r[3] = r[3] + 1
    ::L46::
    if not r[12] then goto L48 else goto L66 end
    ::L47::
    goto L66
    ::L48::
    r[14] = 0
    ::L49::
    if r[14] == 0 then goto L51 else goto L49 end
    ::L50::
    goto L49
    ::L51::
    r[15] = env["warn"]
    ::L52::
    r[16] = env["string"]
    ::L53::
    r[16] = r[16]["format"]
    ::L54::
    r[17] = "[Nebula:%s] Job '%s' error: %s"
    ::L55::
    r[18] = r[0]["label"]
    ::L56::
    r[19] = r[9]["name"]
    ::L57::
    r[20] = env["tostring"]
    ::L58::
    r[21] = r[13]
    ::L59::
    do local out = pack(r[20](r[21])); top = 20 + out.n - 1; for i = 1, out.n do r[20 + i - 1] = out[i] end end
    ::L60::
    do local out = pack(r[16](r[17])); top = 16 + out.n - 1; for i = 1, out.n do r[16 + i - 1] = out[i] end end
    ::L61::
    r[15](unpack(r, 16, top))
    ::L62::
    r[9]["active"] = false
    ::L63::
    goto L73
    ::L64::
    goto L49
    ::L65::
    goto L73
    ::L66::
    if r[13] == false then goto L68 else goto L73 end
    ::L67::
    goto L73
    ::L68::
    r[9]["active"] = false
    ::L69::
    goto L73
    ::L70::
    goto L26
    ::L71::
    goto L73
    ::L72::
    goto L23
    ::L73::
    do local out = {r[5](r[6], r[7])}; for i = 1, 2 do r[7 + i] = out[i] end; if out[1] then r[7] = out[1]; goto L18 else goto L75 end end
    ::L74::
    goto L18
    ::L75::
    r[5] = r[0]["totalTicks"]
    ::L76::
    r[5] = r[5] % 30
    ::L77::
    if r[5] == 0 then goto L79 else goto L81 end
    ::L78::
    goto L81
    ::L79::
    r[6] = r[0]
    r[5] = r[0]["pruneInactive"]
    ::L80::
    r[5](r[6])
    ::L81::
    r[2] = 2
    ::L82::
    if r[2] == 0 then goto L84 else goto L89 end
    ::L83::
    goto L89
    ::L84::
    r[5] = r[0]["totalTicks"]
    ::L85::
    r[5] = r[5] + 1
    ::L86::
    r[0]["totalTicks"] = r[5]
    ::L87::
    r[3] = 0
    ::L88::
    r[2] = 1
    ::L89::
    r[4] = 1
    ::L90::
    goto L4
    ::L91::
    goto L3
    ::L92::
    do return end
  end
end

protos["0_8_0"] = function(env, u)
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
    r[1] = 0
    ::L2::
    if r[1] == 0 then goto L4 else goto L2 end
    ::L3::
    goto L2
    ::L4::
    r[2] = get_upvalue(0)
    ::L5::
    r[2] = r[2]["running"]
    ::L6::
    if not r[2] then goto L8 else goto L9 end
    ::L7::
    goto L9
    ::L8::
    do return end
    ::L9::
    r[2] = get_upvalue(0)
    ::L10::
    r[3] = r[2]
    r[2] = r[2]["step"]
    ::L11::
    r[4] = r[0]
    ::L12::
    r[2](unpack(r, 3, 4))
    ::L13::
    goto L15
    ::L14::
    goto L2
    ::L15::
    do return end
  end
end

protos["0_8"] = function(env, u)
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
    r[1] = 0
    ::L2::
    for i = 2, 2 do r[i] = nil end
    ::L3::
    if 0 == r[1] then goto L5 else goto L3 end
    ::L4::
    goto L3
    ::L5::
    r[2] = 0
    ::L6::
    if r[2] == 0 then goto L8 else goto L14 end
    ::L7::
    goto L14
    ::L8::
    r[3] = r[0]["running"]
    ::L9::
    if r[3] then goto L11 else goto L12 end
    ::L10::
    goto L12
    ::L11::
    do return end
    ::L12::
    r[0]["running"] = true
    ::L13::
    r[2] = 1
    ::L14::
    if r[2] == 1 then goto L16 else goto L6 end
    ::L15::
    goto L6
    ::L16::
    r[3] = get_upvalue(0)
    ::L17::
    r[3] = r[3]["Heartbeat"]
    ::L18::
    r[4] = r[3]
    r[3] = r[3]["Connect"]
    ::L19::
    r[5] = protos["0_8_0"](env, {
      [0] = capture_upvalue(0),
    })
    ::L21::
    r[3] = r[3](unpack(r, 4, 5))
    ::L22::
    r[0]["connection"] = r[3]
    ::L23::
    goto L27
    ::L24::
    goto L6
    ::L25::
    goto L27
    ::L26::
    goto L3
    ::L27::
    do return end
  end
end

protos["0_9"] = function(env, u)
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
    r[1] = 0
    ::L2::
    if 0 == r[1] then goto L4 else goto L2 end
    ::L3::
    goto L2
    ::L4::
    r[0]["running"] = false
    ::L5::
    r[2] = r[0]["connection"]
    ::L6::
    if r[2] then goto L8 else goto L19 end
    ::L7::
    goto L19
    ::L8::
    r[2] = 0
    ::L9::
    if r[2] == 0 then goto L11 else goto L9 end
    ::L10::
    goto L9
    ::L11::
    r[3] = r[0]["connection"]
    ::L12::
    r[4] = r[3]
    r[3] = r[3]["Disconnect"]
    ::L13::
    r[3](r[4])
    ::L14::
    r[0]["connection"] = nil
    ::L15::
    goto L19
    ::L16::
    goto L9
    ::L17::
    goto L19
    ::L18::
    goto L2
    ::L19::
    do return end
  end
end

protos["0_10"] = function(env, u)
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
      if i >= 3 then varargs[i - 3] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    r[3] = 0
    ::L2::
    for i = 4, 5 do r[i] = nil end
    ::L3::
    if 0 == r[3] then goto L5 else goto L17 end
    ::L4::
    goto L17
    ::L5::
    r[6] = get_upvalue(0)
    ::L6::
    r[4] = r[6][r[0]]
    ::L7::
    if r[4] then goto L9 else goto L14 end
    ::L8::
    goto L14
    ::L9::
    r[6] = env["type"]
    ::L10::
    r[7] = r[2]
    ::L11::
    r[6] = r[6](r[7])
    ::L12::
    if r[6] ~= "table" then goto L14 else goto L16 end
    ::L13::
    goto L16
    ::L14::
    r[6] = 0
    ::L15::
    do return r[6] end
    ::L16::
    r[3] = 1
    ::L17::
    if 1 == r[3] then goto L19 else goto L113 end
    ::L18::
    goto L113
    ::L19::
    r[5] = 0
    ::L20::
    r[6] = env["pairs"]
    ::L21::
    r[7] = r[2]
    ::L22::
    do local out = {r[6](r[7])}; for i = 0, 2 do r[6 + i] = out[i + 1] end end
    ::L23::
    goto L110
    ::L24::
    r[11] = r[4]["skipLocked"]
    ::L25::
    if r[11] then goto L27 else goto L37 end
    ::L26::
    goto L37
    ::L27::
    r[11] = env["type"]
    ::L28::
    r[12] = r[10]
    ::L29::
    r[11] = r[11](r[12])
    ::L30::
    if r[11] == "table" then goto L32 else goto L35 end
    ::L31::
    goto L35
    ::L32::
    r[11] = r[10]["Locked"]
    ::L33::
    if r[11] ~= true then goto L35 else goto L36 end
    ::L34::
    goto L36
    ::L35::
    r[11] = false
    ::L36::
    r[11] = true
    ::L37::
    r[12] = env["type"]
    ::L38::
    r[13] = r[10]
    ::L39::
    r[12] = r[12](r[13])
    ::L40::
    if r[12] == "table" then goto L42 else goto L110 end
    ::L41::
    goto L110
    ::L42::
    if not r[11] then goto L44 else goto L110 end
    ::L43::
    goto L110
    ::L44::
    r[12] = env["pairs"]
    ::L45::
    r[13] = r[4]["overrides"]
    ::L46::
    do local out = {r[12](r[13])}; for i = 0, 2 do r[12 + i] = out[i + 1] end end
    ::L47::
    goto L108
    ::L48::
    if r[1] then goto L50 else goto L80 end
    ::L49::
    goto L80
    ::L50::
    r[17] = r[10][r[15]]
    ::L51::
    if r[17] ~= nil then goto L53 else goto L108 end
    ::L52::
    goto L108
    ::L53::
    r[17] = 0
    ::L54::
    if r[17] == 1 then goto L56 else goto L59 end
    ::L55::
    goto L59
    ::L56::
    r[10][r[15]] = r[16]
    ::L57::
    r[5] = r[5] + 1
    ::L58::
    goto L108
    ::L59::
    if r[17] == 0 then goto L61 else goto L54 end
    ::L60::
    goto L54
    ::L61::
    r[18] = get_upvalue(1)
    ::L62::
    r[19] = get_upvalue(1)
    ::L63::
    r[19] = r[19][r[9]]
    ::L64::
    if not r[19] then goto L66 else goto L67 end
    ::L65::
    goto L67
    ::L66::
    r[19] = {}
    ::L67::
    r[18][r[9]] = r[19]
    ::L68::
    r[18] = get_upvalue(1)
    ::L69::
    r[18] = r[18][r[9]]
    ::L70::
    r[18] = r[18][r[15]]
    ::L71::
    if r[18] == nil then goto L73 else goto L77 end
    ::L72::
    goto L77
    ::L73::
    r[18] = get_upvalue(1)
    ::L74::
    r[18] = r[18][r[9]]
    ::L75::
    r[19] = r[10][r[15]]
    ::L76::
    r[18][r[15]] = r[19]
    ::L77::
    r[17] = 1
    ::L78::
    goto L54
    ::L79::
    goto L108
    ::L80::
    r[17] = 0
    ::L81::
    for i = 18, 18 do r[i] = nil end
    ::L82::
    if r[17] == 0 then goto L84 else goto L82 end
    ::L83::
    goto L82
    ::L84::
    r[19] = get_upvalue(1)
    ::L85::
    r[19] = r[19][r[9]]
    ::L86::
    if r[19] then goto L88 else r[18] = r[19]; goto L91 end
    ::L87::
    goto L91
    ::L88::
    r[19] = get_upvalue(1)
    ::L89::
    r[19] = r[19][r[9]]
    ::L90::
    r[18] = r[19][r[15]]
    ::L91::
    if r[18] ~= nil then goto L93 else goto L108 end
    ::L92::
    goto L108
    ::L93::
    r[19] = 0
    ::L94::
    for i = 20, 20 do r[i] = nil end
    ::L95::
    if r[19] == 0 then goto L97 else goto L95 end
    ::L96::
    goto L95
    ::L97::
    r[20] = 0
    ::L98::
    if r[20] == 0 then goto L100 else goto L98 end
    ::L99::
    goto L98
    ::L100::
    r[10][r[15]] = r[18]
    ::L101::
    r[5] = r[5] + 1
    ::L102::
    goto L108
    ::L103::
    goto L98
    ::L104::
    goto L108
    ::L105::
    goto L95
    ::L106::
    goto L108
    ::L107::
    goto L82
    ::L108::
    do local out = {r[12](r[13], r[14])}; for i = 1, 2 do r[14 + i] = out[i] end; if out[1] then r[14] = out[1]; goto L48 else goto L110 end end
    ::L109::
    goto L48
    ::L110::
    do local out = {r[6](r[7], r[8])}; for i = 1, 2 do r[8 + i] = out[i] end; if out[1] then r[8] = out[1]; goto L24 else goto L112 end end
    ::L111::
    goto L24
    ::L112::
    r[3] = 2
    ::L113::
    if r[3] == 2 then goto L115 else goto L3 end
    ::L114::
    goto L3
    ::L115::
    do return r[5] end
    ::L116::
    goto L3
    ::L117::
    do return end
  end
end

protos["0_11"] = function(env, u)
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
    r[2] = 0
    ::L2::
    for i = 3, 7 do r[i] = nil end
    ::L3::
    if r[2] == 0 then goto L5 else goto L8 end
    ::L4::
    goto L8
    ::L5::
    r[3] = 0
    ::L6::
    for i = 4, 4 do r[i] = nil end
    ::L7::
    r[2] = 1
    ::L8::
    if r[2] == 2 then goto L10 else goto L109 end
    ::L9::
    goto L109
    ::L10::
    for i = 7, 7 do r[i] = nil end
    ::L11::
    r[8] = 0
    ::L12::
    if r[8] == 2 then goto L14 else goto L42 end
    ::L13::
    goto L42
    ::L14::
    if r[3] == 3 then goto L16 else goto L11 end
    ::L15::
    goto L11
    ::L16::
    r[9] = 0
    ::L17::
    if r[9] == 1 then goto L19 else goto L21 end
    ::L18::
    goto L21
    ::L19::
    r[3] = 4
    ::L20::
    goto L11
    ::L21::
    if r[9] == 0 then goto L23 else goto L17 end
    ::L22::
    goto L17
    ::L23::
    r[11] = r[4]
    r[10] = r[4]["FindFirstChild"]
    ::L24::
    r[12] = "Head"
    ::L25::
    r[10] = r[10](unpack(r, 11, 12))
    ::L26::
    r[7] = r[10]
    ::L27::
    if r[5] then goto L29 else goto L36 end
    ::L28::
    goto L36
    ::L29::
    if r[6] then goto L31 else goto L36 end
    ::L30::
    goto L36
    ::L31::
    if r[7] then goto L33 else goto L36 end
    ::L32::
    goto L36
    ::L33::
    r[10] = r[5]["Health"]
    ::L34::
    if 0 < r[10] then goto L39 else goto L36 end
    ::L35::
    goto L39
    ::L36::
    r[10] = false
    ::L37::
    r[11] = "dead_or_incomplete"
    ::L38::
    do return r[10], r[11] end
    ::L39::
    r[9] = 1
    ::L40::
    goto L17
    ::L41::
    goto L11
    ::L42::
    if r[8] == 0 then goto L44 else goto L73 end
    ::L43::
    goto L73
    ::L44::
    if r[3] == 2 then goto L46 else goto L55 end
    ::L45::
    goto L55
    ::L46::
    r[10] = r[4]
    r[9] = r[4]["FindFirstChildOfClass"]
    ::L47::
    r[11] = "Humanoid"
    ::L48::
    r[9] = r[9](unpack(r, 10, 11))
    ::L49::
    r[5] = r[9]
    ::L50::
    r[10] = r[4]
    r[9] = r[4]["FindFirstChild"]
    ::L51::
    r[11] = "HumanoidRootPart"
    ::L52::
    r[9] = r[9](unpack(r, 10, 11))
    ::L53::
    r[6] = r[9]
    ::L54::
    r[3] = 3
    ::L55::
    if r[3] == 1 then goto L57 else goto L72 end
    ::L56::
    goto L72
    ::L57::
    r[9] = 0
    ::L58::
    if r[9] == 0 then goto L60 else goto L67 end
    ::L59::
    goto L67
    ::L60::
    r[4] = r[0]["Character"]
    ::L61::
    if not r[4] then goto L63 else goto L66 end
    ::L62::
    goto L66
    ::L63::
    r[10] = false
    ::L64::
    r[11] = "no_char"
    ::L65::
    do return r[10], r[11] end
    ::L66::
    r[9] = 1
    ::L67::
    if r[9] == 1 then goto L69 else goto L58 end
    ::L68::
    goto L58
    ::L69::
    r[3] = 2
    ::L70::
    goto L72
    ::L71::
    goto L58
    ::L72::
    r[8] = 1
    ::L73::
    if r[8] == 1 then goto L75 else goto L12 end
    ::L74::
    goto L12
    ::L75::
    if r[3] == 4 then goto L77 else goto L80 end
    ::L76::
    goto L80
    ::L77::
    r[9] = true
    ::L78::
    r[10] = r[6]
    ::L79::
    do return r[9], r[10] end
    ::L80::
    if r[3] == 0 then goto L82 else goto L105 end
    ::L81::
    goto L105
    ::L82::
    if r[0] then goto L84 else goto L87 end
    ::L83::
    goto L87
    ::L84::
    r[9] = get_upvalue(0)
    ::L85::
    if r[0] == r[9] then goto L87 else goto L90 end
    ::L86::
    goto L90
    ::L87::
    r[9] = false
    ::L88::
    r[10] = "self_or_nil"
    ::L89::
    do return r[9], r[10] end
    ::L90::
    if not r[1] then goto L92 else goto L104 end
    ::L91::
    goto L104
    ::L92::
    r[9] = get_upvalue(0)
    ::L93::
    r[9] = r[9]["Team"]
    ::L94::
    if r[9] then goto L96 else goto L104 end
    ::L95::
    goto L104
    ::L96::
    r[9] = r[0]["Team"]
    ::L97::
    r[10] = get_upvalue(0)
    ::L98::
    r[10] = r[10]["Team"]
    ::L99::
    if r[9] == r[10] then goto L101 else goto L104 end
    ::L100::
    goto L104
    ::L101::
    r[9] = false
    ::L102::
    r[10] = "teammate"
    ::L103::
    do return r[9], r[10] end
    ::L104::
    r[3] = 1
    ::L105::
    r[8] = 2
    ::L106::
    goto L12
    ::L107::
    goto L11
    ::L108::
    goto L114
    ::L109::
    if r[2] == 1 then goto L111 else goto L3 end
    ::L110::
    goto L3
    ::L111::
    for i = 5, 6 do r[i] = nil end
    ::L112::
    r[2] = 2
    ::L113::
    goto L3
    ::L114::
    do return end
  end
end

protos["0_12"] = function(env, u)
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
    r[2] = 0
    ::L2::
    for i = 3, 7 do r[i] = nil end
    ::L3::
    if 2 == r[2] then goto L5 else goto L121 end
    ::L4::
    goto L121
    ::L5::
    for i = 7, 7 do r[i] = nil end
    ::L6::
    if r[3] == 2 then goto L8 else goto L82 end
    ::L7::
    goto L82
    ::L8::
    r[8] = 0
    ::L9::
    if r[8] == 0 then goto L11 else goto L77 end
    ::L10::
    goto L77
    ::L11::
    if r[0] then r[7] = r[0]; goto L14 else goto L13 end
    ::L12::
    goto L14
    ::L13::
    r[7] = 250
    ::L14::
    r[9] = env["ipairs"]
    ::L15::
    r[10] = get_upvalue(0)
    ::L16::
    r[11] = r[10]
    r[10] = r[10]["GetPlayers"]
    ::L17::
    do local out = pack(r[10](r[11])); top = 10 + out.n - 1; for i = 1, out.n do r[10 + i - 1] = out[i] end end
    ::L18::
    do local out = {r[9](unpack(r, 10, top))}; for i = 0, 2 do r[9 + i] = out[i + 1] end end
    ::L19::
    goto L74
    ::L20::
    r[14] = 0
    ::L21::
    for i = 15, 16 do r[i] = nil end
    ::L22::
    if r[14] == 0 then goto L24 else goto L22 end
    ::L23::
    goto L22
    ::L24::
    r[17] = get_upvalue(1)
    ::L25::
    r[18] = r[13]
    ::L26::
    r[19] = r[1]
    ::L27::
    do local out = {r[17](r[18])}; for i = 0, 1 do r[17 + i] = out[i + 1] end end
    ::L28::
    r[16] = r[18]
    ::L29::
    r[15] = r[17]
    ::L30::
    if r[15] then goto L32 else goto L74 end
    ::L31::
    goto L74
    ::L32::
    r[17] = 0
    ::L33::
    for i = 18, 20 do r[i] = nil end
    ::L34::
    if r[17] == 0 then goto L36 else goto L39 end
    ::L35::
    goto L39
    ::L36::
    r[18] = 0
    ::L37::
    for i = 19, 19 do r[i] = nil end
    ::L38::
    r[17] = 1
    ::L39::
    if r[17] == 1 then goto L41 else goto L34 end
    ::L40::
    goto L34
    ::L41::
    for i = 20, 20 do r[i] = nil end
    ::L42::
    if r[18] == 0 then goto L44 else goto L57 end
    ::L43::
    goto L57
    ::L44::
    r[21] = 0
    ::L45::
    if r[21] == 1 then goto L47 else goto L49 end
    ::L46::
    goto L49
    ::L47::
    r[18] = 1
    ::L48::
    goto L57
    ::L49::
    if 0 == r[21] then goto L51 else goto L45 end
    ::L50::
    goto L45
    ::L51::
    r[22] = r[16]["Position"]
    ::L52::
    r[23] = r[5]["Position"]
    ::L53::
    r[19] = r[22] - r[23]
    ::L54::
    r[20] = r[19]["Magnitude"]
    ::L55::
    r[21] = 1
    ::L56::
    goto L45
    ::L57::
    if r[18] == 1 then goto L59 else goto L42 end
    ::L58::
    goto L42
    ::L59::
    if r[20] < r[7] then goto L61 else goto L74 end
    ::L60::
    goto L74
    ::L61::
    r[21] = 0
    ::L62::
    if r[21] == 0 then goto L64 else goto L62 end
    ::L63::
    goto L62
    ::L64::
    r[7] = r[20]
    ::L65::
    r[6] = r[13]
    ::L66::
    goto L74
    ::L67::
    goto L62
    ::L68::
    goto L74
    ::L69::
    goto L42
    ::L70::
    goto L74
    ::L71::
    goto L34
    ::L72::
    goto L74
    ::L73::
    goto L22
    ::L74::
    do local out = {r[9](r[10], r[11])}; for i = 1, 2 do r[11 + i] = out[i] end; if out[1] then r[11] = out[1]; goto L20 else goto L76 end end
    ::L75::
    goto L20
    ::L76::
    r[8] = 1
    ::L77::
    if 1 == r[8] then goto L79 else goto L9 end
    ::L78::
    goto L9
    ::L79::
    r[3] = 3
    ::L80::
    goto L82
    ::L81::
    goto L9
    ::L82::
    if r[3] == 0 then goto L84 else goto L104 end
    ::L83::
    goto L104
    ::L84::
    r[8] = 0
    ::L85::
    if r[8] == 1 then goto L87 else goto L89 end
    ::L86::
    goto L89
    ::L87::
    r[3] = 1
    ::L88::
    goto L104
    ::L89::
    if r[8] == 0 then goto L91 else goto L85 end
    ::L90::
    goto L85
    ::L91::
    r[9] = get_upvalue(2)
    ::L92::
    if r[9] then goto L94 else r[4] = r[9]; goto L96 end
    ::L93::
    goto L96
    ::L94::
    r[9] = get_upvalue(2)
    ::L95::
    r[4] = r[9]["Character"]
    ::L96::
    if r[4] then goto L98 else r[5] = r[4]; goto L102 end
    ::L97::
    goto L102
    ::L98::
    r[10] = r[4]
    r[9] = r[4]["FindFirstChild"]
    ::L99::
    r[11] = "HumanoidRootPart"
    ::L100::
    r[9] = r[9](unpack(r, 10, 11))
    ::L101::
    r[5] = r[9]
    ::L102::
    r[8] = 1
    ::L103::
    goto L85
    ::L104::
    if 1 == r[3] then goto L106 else goto L114 end
    ::L105::
    goto L114
    ::L106::
    if not r[5] then goto L108 else goto L112 end
    ::L107::
    goto L112
    ::L108::
    for i = 8, 8 do r[i] = nil end
    ::L109::
    r[9] = env["math"]
    ::L110::
    r[9] = r[9]["huge"]
    ::L111::
    do return r[8], r[9] end
    ::L112::
    for i = 6, 6 do r[i] = nil end
    ::L113::
    r[3] = 2
    ::L114::
    if r[3] == 3 then goto L116 else goto L6 end
    ::L115::
    goto L6
    ::L116::
    r[8] = r[6]
    ::L117::
    r[9] = r[7]
    ::L118::
    do return r[8], r[9] end
    ::L119::
    goto L6
    ::L120::
    goto L131
    ::L121::
    if r[2] == 0 then goto L123 else goto L126 end
    ::L122::
    goto L126
    ::L123::
    r[3] = 0
    ::L124::
    for i = 4, 4 do r[i] = nil end
    ::L125::
    r[2] = 1
    ::L126::
    if 1 == r[2] then goto L128 else goto L3 end
    ::L127::
    goto L3
    ::L128::
    for i = 5, 6 do r[i] = nil end
    ::L129::
    r[2] = 2
    ::L130::
    goto L3
    ::L131::
    do return end
  end
end

protos["0_13_0"] = function(env, u)
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
    r[0] = 0
    ::L2::
    for i = 1, 1 do r[i] = nil end
    ::L3::
    if r[0] == 0 then goto L5 else goto L3 end
    ::L4::
    goto L3
    ::L5::
    r[1] = 0
    ::L6::
    if r[1] == 0 then goto L8 else goto L6 end
    ::L7::
    goto L6
    ::L8::
    r[2] = 0
    ::L9::
    if r[2] == 0 then goto L11 else goto L9 end
    ::L10::
    goto L9
    ::L11::
    r[3] = get_upvalue(0)
    ::L12::
    if r[3] == 0 then goto L14 else goto L18 end
    ::L13::
    goto L18
    ::L14::
    r[3] = get_upvalue(1)
    ::L15::
    do return r[3]() end
    ::L16::
    do return unpack(r, 3, top) end
    ::L17::
    goto L37
    ::L18::
    r[3] = get_upvalue(0)
    ::L19::
    if r[3] == 1 then goto L21 else goto L27 end
    ::L20::
    goto L27
    ::L21::
    r[3] = get_upvalue(1)
    ::L22::
    r[4] = get_upvalue(2)
    ::L23::
    r[4] = r[4][1]
    ::L24::
    do return r[3](unpack(r, 4, 4)) end
    ::L25::
    do return unpack(r, 3, top) end
    ::L26::
    goto L37
    ::L27::
    r[3] = get_upvalue(0)
    ::L28::
    if r[3] == 2 then goto L30 else goto L37 end
    ::L29::
    goto L37
    ::L30::
    r[3] = get_upvalue(1)
    ::L31::
    r[4] = get_upvalue(2)
    ::L32::
    r[4] = r[4][1]
    ::L33::
    r[5] = get_upvalue(2)
    ::L34::
    r[5] = r[5][2]
    ::L35::
    do return r[3](unpack(r, 4, 5)) end
    ::L36::
    do return unpack(r, 3, top) end
    ::L37::
    r[3] = get_upvalue(1)
    ::L38::
    r[4] = env["unpack"]
    ::L39::
    r[5] = get_upvalue(2)
    ::L40::
    r[6] = 1
    ::L41::
    r[7] = get_upvalue(0)
    ::L42::
    do local out = pack(r[4](r[5])); top = 4 + out.n - 1; for i = 1, out.n do r[4 + i - 1] = out[i] end end
    ::L43::
    do return unpack(r, 3, top) end
    ::L44::
    do return unpack(r, 3, top) end
    ::L45::
    goto L9
    ::L46::
    goto L6
    ::L47::
    goto L49
    ::L48::
    goto L3
    ::L49::
    do return end
  end
end

protos["0_13"] = function(env, u)
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
      if i >= 3 then varargs[i - 3] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    r[4] = 0
    ::L2::
    for i = 5, 9 do r[i] = nil end
    ::L3::
    r[10] = 0
    ::L4::
    if 0 == r[10] then goto L6 else goto L30 end
    ::L5::
    goto L30
    ::L6::
    if r[4] == 3 then goto L8 else goto L12 end
    ::L7::
    goto L12
    ::L8::
    r[11] = false
    ::L9::
    r[12] = r[9]
    ::L10::
    r[13] = r[7]
    ::L11::
    do return unpack(r, 11, 13) end
    ::L12::
    if r[4] == 0 then goto L14 else goto L29 end
    ::L13::
    goto L29
    ::L14::
    r[11] = 0
    ::L15::
    if r[11] == 1 then goto L17 else goto L19 end
    ::L16::
    goto L19
    ::L17::
    r[4] = 1
    ::L18::
    goto L29
    ::L19::
    if r[11] == 0 then goto L21 else goto L15 end
    ::L20::
    goto L15
    ::L21::
    r[12] = get_upvalue(0)
    ::L22::
    do local out = pack(r[13](r[14])); top = 13 + out.n - 1; for i = 1, out.n do r[13 + i - 1] = out[i] end end
    ::L23::
    do local out = {r[12](unpack(r, 13, top))}; for i = 0, 1 do r[12 + i] = out[i + 1] end end
    ::L24::
    r[6] = r[13]
    ::L25::
    r[5] = r[12]
    ::L26::
    r[7] = 0
    ::L27::
    r[11] = 1
    ::L28::
    goto L15
    ::L29::
    r[10] = 1
    ::L30::
    if r[10] == 1 then goto L32 else goto L4 end
    ::L31::
    goto L4
    ::L32::
    if r[4] == 2 then goto L34 else goto L103 end
    ::L33::
    goto L103
    ::L34::
    r[11] = 0
    ::L35::
    for i = 12, 14 do r[i] = nil end
    ::L36::
    if 1 == r[11] then goto L38 else goto L83 end
    ::L37::
    goto L83
    ::L38::
    for i = 14, 14 do r[i] = nil end
    ::L39::
    if r[12] == 0 then goto L41 else goto L51 end
    ::L40::
    goto L51
    ::L41::
    r[7] = r[7] + 1
    ::L42::
    r[15] = env["pcall"]
    ::L43::
    r[16] = protos["0_13_0"](env, {
      [0] = capture_upvalue(6),
      [1] = capture_upvalue(2),
      [2] = capture_upvalue(5),
    })
    ::L47::
    do local out = {r[15](r[16])}; for i = 0, 1 do r[15 + i] = out[i + 1] end end
    ::L48::
    r[14] = r[16]
    ::L49::
    r[13] = r[15]
    ::L50::
    r[12] = 1
    ::L51::
    if r[12] == 1 then goto L53 else goto L61 end
    ::L52::
    goto L61
    ::L53::
    if r[13] then goto L55 else goto L59 end
    ::L54::
    goto L59
    ::L55::
    r[15] = true
    ::L56::
    r[16] = r[14]
    ::L57::
    r[17] = r[7]
    ::L58::
    do return unpack(r, 15, 17) end
    ::L59::
    r[9] = r[14]
    ::L60::
    r[12] = 2
    ::L61::
    if r[12] == 2 then goto L63 else goto L39 end
    ::L62::
    goto L39
    ::L63::
    r[15] = get_upvalue(1)
    ::L64::
    r[16] = r[8] * 1.5
    ::L65::
    r[17] = 0.05
    ::L66::
    r[18] = 0.5
    ::L67::
    r[15] = r[15](unpack(r, 16, 18))
    ::L68::
    r[8] = r[15]
    ::L69::
    r[15] = env["task"]
    ::L70::
    if r[15] then goto L72 else goto L89 end
    ::L71::
    goto L89
    ::L72::
    r[15] = env["task"]
    ::L73::
    r[15] = r[15]["wait"]
    ::L74::
    if r[15] then goto L76 else goto L89 end
    ::L75::
    goto L89
    ::L76::
    r[15] = env["task"]
    ::L77::
    r[15] = r[15]["wait"]
    ::L78::
    r[16] = r[8]
    ::L79::
    r[15](r[16])
    ::L80::
    goto L89
    ::L81::
    goto L39
    ::L82::
    goto L89
    ::L83::
    if r[11] == 0 then goto L85 else goto L36 end
    ::L84::
    goto L36
    ::L85::
    r[12] = 0
    ::L86::
    for i = 13, 13 do r[i] = nil end
    ::L87::
    r[11] = 1
    ::L88::
    goto L36
    ::L89::
    if r[1] <= r[7] then goto L91 else goto L34 end
    ::L90::
    goto L34
    ::L91::
    r[11] = env["warn"]
    ::L92::
    r[12] = env["string"]
    ::L93::
    r[12] = r[12]["format"]
    ::L94::
    r[13] = "[Nebula] '%s' failed after %d attempts: %s"
    ::L95::
    r[14] = r[0]
    ::L96::
    r[15] = r[7]
    ::L97::
    r[16] = env["tostring"]
    ::L98::
    r[17] = r[9]
    ::L99::
    do local out = pack(r[16](r[17])); top = 16 + out.n - 1; for i = 1, out.n do r[16 + i - 1] = out[i] end end
    ::L100::
    do local out = pack(r[12](r[13])); top = 12 + out.n - 1; for i = 1, out.n do r[12 + i - 1] = out[i] end end
    ::L101::
    r[11](unpack(r, 12, top))
    ::L102::
    r[4] = 3
    ::L103::
    if r[4] == 1 then goto L105 else goto L3 end
    ::L104::
    goto L3
    ::L105::
    r[8] = 0.05
    ::L106::
    for i = 9, 9 do r[i] = nil end
    ::L107::
    r[4] = 2
    ::L108::
    goto L3
    ::L109::
    goto L4
    ::L110::
    goto L3
    ::L111::
    do return end
  end
end

protos["0_14"] = function(env, u)
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
      if i >= 3 then varargs[i - 3] = args[i + 1] else r[i] = args[i + 1] end
    end

    ::L0::
    ::L1::
    r[3] = 0
    ::L2::
    for i = 4, 4 do r[i] = nil end
    ::L3::
    if r[3] == 0 then goto L5 else goto L20 end
    ::L4::
    goto L20
    ::L5::
    r[5] = env["Instance"]
    ::L6::
    r[5] = r[5]["new"]
    ::L7::
    r[6] = r[0]
    ::L8::
    r[5] = r[5](r[6])
    ::L9::
    r[4] = r[5]
    ::L10::
    r[5] = env["pairs"]
    ::L11::
    if r[1] then r[6] = r[1]; goto L14 else goto L13 end
    ::L12::
    goto L14
    ::L13::
    r[6] = {}
    ::L14::
    do local out = {r[5](r[6])}; for i = 0, 2 do r[5 + i] = out[i + 1] end end
    ::L15::
    goto L17
    ::L16::
    r[4][r[8]] = r[9]
    ::L17::
    do local out = {r[5](r[6], r[7])}; for i = 1, 2 do r[7 + i] = out[i] end; if out[1] then r[7] = out[1]; goto L16 else goto L19 end end
    ::L18::
    goto L16
    ::L19::
    r[3] = 1
    ::L20::
    if r[3] == 1 then goto L22 else goto L3 end
    ::L21::
    goto L3
    ::L22::
    if r[2] then goto L24 else goto L31 end
    ::L23::
    goto L31
    ::L24::
    r[5] = env["next"]
    ::L25::
    r[6] = r[2]
    ::L26::
    for i = 7, 7 do r[i] = nil end
    ::L27::
    goto L29
    ::L28::
    r[9]["Parent"] = r[4]
    ::L29::
    do local out = {r[5](r[6], r[7])}; for i = 1, 2 do r[7 + i] = out[i] end; if out[1] then r[7] = out[1]; goto L28 else goto L31 end end
    ::L30::
    goto L28
    ::L31::
    do return r[4] end
    ::L32::
    goto L3
    ::L33::
    do return end
  end
end

protos["0_15"] = function(env, u)
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
    r[2] = 0
    ::L2::
    for i = 3, 7 do r[i] = nil end
    ::L3::
    r[8] = 0
    ::L4::
    if r[8] == 2 then goto L6 else goto L89 end
    ::L5::
    goto L89
    ::L6::
    if r[2] == 3 then goto L8 else goto L3 end
    ::L7::
    goto L3
    ::L8::
    if not r[6] then goto L10 else goto L45 end
    ::L9::
    goto L45
    ::L10::
    r[9] = 0
    ::L11::
    for i = 10, 10 do r[i] = nil end
    ::L12::
    if r[9] == 0 then goto L14 else goto L32 end
    ::L13::
    goto L32
    ::L14::
    r[11] = get_upvalue(0)
    ::L15::
    r[12] = get_upvalue(1)
    ::L16::
    r[12] = r[12]["get"]
    ::L17::
    r[13] = "scanRadius"
    ::L18::
    r[12] = r[12](r[13])
    ::L19::
    r[13] = 25
    ::L20::
    r[14] = 500
    ::L21::
    r[11] = r[11](unpack(r, 12, 14))
    ::L22::
    r[10] = r[11]
    ::L23::
    r[11] = get_upvalue(3)
    ::L24::
    r[12] = r[10]
    ::L25::
    r[13] = get_upvalue(1)
    ::L26::
    r[13] = r[13]["get"]
    ::L27::
    r[14] = "allowTeam"
    ::L28::
    do local out = pack(r[13](r[14])); top = 13 + out.n - 1; for i = 1, out.n do r[13 + i - 1] = out[i] end end
    ::L29::
    r[11] = r[11](unpack(r, 12, top))
    ::L30::
    set_upvalue(2, r[11])
    ::L31::
    r[9] = 1
    ::L32::
    if 1 == r[9] then goto L34 else goto L12 end
    ::L33::
    goto L12
    ::L34::
    r[11] = get_upvalue(4)
    ::L35::
    r[12] = get_upvalue(2)
    ::L36::
    r[13] = get_upvalue(1)
    ::L37::
    r[13] = r[13]["get"]
    ::L38::
    r[14] = "allowTeam"
    ::L39::
    do local out = pack(r[13](r[14])); top = 13 + out.n - 1; for i = 1, out.n do r[13 + i - 1] = out[i] end end
    ::L40::
    do local out = {r[11](unpack(r, 12, top))}; for i = 0, 1 do r[11 + i] = out[i + 1] end end
    ::L41::
    r[7] = r[12]
    ::L42::
    r[6] = r[11]
    ::L43::
    goto L45
    ::L44::
    goto L12
    ::L45::
    if r[6] then goto L47 else goto L87 end
    ::L46::
    goto L87
    ::L47::
    if r[7] then goto L49 else goto L87 end
    ::L48::
    goto L87
    ::L49::
    r[9] = 0
    ::L50::
    if r[9] == 1 then goto L52 else goto L56 end
    ::L51::
    goto L56
    ::L52::
    r[10] = env["Vector3"]
    ::L53::
    r[10] = r[10]["zero"]
    ::L54::
    r[5]["AssemblyLinearVelocity"] = r[10]
    ::L55::
    goto L87
    ::L56::
    if r[9] == 0 then goto L58 else goto L50 end
    ::L57::
    goto L50
    ::L58::
    r[10] = get_upvalue(5)
    ::L59::
    r[11] = r[1] * 4.5
    ::L60::
    r[10] = r[10] + r[11]
    ::L61::
    r[11] = env["math"]
    ::L62::
    r[11] = r[11]["pi"]
    ::L63::
    r[11] = r[11] * 2
    ::L64::
    r[10] = r[10] % r[11]
    ::L65::
    set_upvalue(5, r[10])
    ::L66::
    r[10] = env["CFrame"]
    ::L67::
    r[10] = r[10]["new"]
    ::L68::
    r[11] = r[7]["Position"]
    ::L69::
    r[10] = r[10](r[11])
    ::L70::
    r[11] = env["CFrame"]
    ::L71::
    r[11] = r[11]["Angles"]
    ::L72::
    r[12] = 0
    ::L73::
    r[13] = get_upvalue(5)
    ::L74::
    r[14] = 0
    ::L75::
    r[11] = r[11](unpack(r, 12, 14))
    ::L76::
    r[10] = r[10] * r[11]
    ::L77::
    r[11] = env["CFrame"]
    ::L78::
    r[11] = r[11]["new"]
    ::L79::
    r[12] = 0
    ::L80::
    r[13] = 2.5
    ::L81::
    r[14] = 6
    ::L82::
    r[11] = r[11](unpack(r, 12, 14))
    ::L83::
    r[10] = r[10] * r[11]
    ::L84::
    r[5]["CFrame"] = r[10]
    ::L85::
    r[9] = 1
    ::L86::
    goto L50
    ::L87::
    r[2] = 4
    ::L88::
    goto L3
    ::L89::
    if r[8] == 0 then goto L91 else goto L138 end
    ::L90::
    goto L138
    ::L91::
    if r[2] == 0 then goto L93 else goto L119 end
    ::L92::
    goto L119
    ::L93::
    r[9] = get_upvalue(1)
    ::L94::
    r[9] = r[9]["get"]
    ::L95::
    r[10] = "autoOrbit"
    ::L96::
    r[9] = r[9](r[10])
    ::L97::
    r[3] = r[9]
    ::L98::
    if not r[3] then goto L100 else goto L118 end
    ::L99::
    goto L118
    ::L100::
    r[9] = 0
    ::L101::
    for i = 10, 10 do r[i] = nil end
    ::L102::
    if r[9] == 0 then goto L104 else goto L102 end
    ::L103::
    goto L102
    ::L104::
    r[10] = 0
    ::L105::
    if r[10] == 0 then goto L107 else goto L105 end
    ::L106::
    goto L105
    ::L107::
    r[11] = 0
    ::L108::
    if r[11] == 0 then goto L110 else goto L108 end
    ::L109::
    goto L108
    ::L110::
    for i = 12, 12 do r[i] = nil end
    ::L111::
    set_upvalue(2, r[12])
    ::L112::
    r[12] = true
    ::L113::
    do return r[12] end
    ::L114::
    goto L108
    ::L115::
    goto L105
    ::L116::
    goto L118
    ::L117::
    goto L102
    ::L118::
    r[2] = 1
    ::L119::
    if r[2] == 4 then goto L121 else goto L137 end
    ::L120::
    goto L137
    ::L121::
    r[9] = 0
    ::L122::
    if 0 == r[9] then goto L124 else goto L122 end
    ::L123::
    goto L122
    ::L124::
    r[10] = r[0] % 600
    ::L125::
    if r[10] == 0 then goto L127 else goto L134 end
    ::L126::
    goto L134
    ::L127::
    r[10] = env["print"]
    ::L128::
    r[11] = env["string"]
    ::L129::
    r[11] = r[11]["format"]
    ::L130::
    r[12] = "[Nebula] Orbit heartbeat #%d active"
    ::L131::
    r[13] = r[0]
    ::L132::
    do local out = pack(r[11](r[12])); top = 11 + out.n - 1; for i = 1, out.n do r[11 + i - 1] = out[i] end end
    ::L133::
    r[10](unpack(r, 11, top))
    ::L134::
    r[10] = true
    ::L135::
    do return r[10] end
    ::L136::
    goto L122
    ::L137::
    r[8] = 1
    ::L138::
    if r[8] == 1 then goto L140 else goto L4 end
    ::L139::
    goto L4
    ::L140::
    if r[2] == 1 then goto L142 else goto L162 end
    ::L141::
    goto L162
    ::L142::
    r[9] = 0
    ::L143::
    if r[9] == 0 then goto L145 else goto L157 end
    ::L144::
    goto L157
    ::L145::
    r[10] = get_upvalue(6)
    ::L146::
    if r[10] then goto L148 else r[4] = r[10]; goto L150 end
    ::L147::
    goto L150
    ::L148::
    r[10] = get_upvalue(6)
    ::L149::
    r[4] = r[10]["Character"]
    ::L150::
    if r[4] then goto L152 else r[5] = r[4]; goto L156 end
    ::L151::
    goto L156
    ::L152::
    r[11] = r[4]
    r[10] = r[4]["FindFirstChild"]
    ::L153::
    r[12] = "HumanoidRootPart"
    ::L154::
    r[10] = r[10](unpack(r, 11, 12))
    ::L155::
    r[5] = r[10]
    ::L156::
    r[9] = 1
    ::L157::
    if 1 == r[9] then goto L159 else goto L143 end
    ::L158::
    goto L143
    ::L159::
    r[2] = 2
    ::L160::
    goto L162
    ::L161::
    goto L143
    ::L162::
    if r[2] == 2 then goto L164 else goto L178 end
    ::L163::
    goto L178
    ::L164::
    if not r[5] then goto L166 else goto L168 end
    ::L165::
    goto L168
    ::L166::
    r[9] = true
    ::L167::
    do return r[9] end
    ::L168::
    r[9] = get_upvalue(4)
    ::L169::
    r[10] = get_upvalue(2)
    ::L170::
    r[11] = get_upvalue(1)
    ::L171::
    r[11] = r[11]["get"]
    ::L172::
    r[12] = "allowTeam"
    ::L173::
    do local out = pack(r[11](r[12])); top = 11 + out.n - 1; for i = 1, out.n do r[11 + i - 1] = out[i] end end
    ::L174::
    do local out = {r[9](unpack(r, 10, top))}; for i = 0, 1 do r[9 + i] = out[i + 1] end end
    ::L175::
    r[7] = r[10]
    ::L176::
    r[6] = r[9]
    ::L177::
    r[2] = 3
    ::L178::
    r[8] = 2
    ::L179::
    goto L4
    ::L180::
    goto L3
    ::L181::
    do return end
  end
end

protos["0_16"] = function(env, u)
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
    r[0] = 0
    ::L2::
    for i = 1, 1 do r[i] = nil end
    ::L3::
    if r[0] == 0 then goto L5 else goto L3 end
    ::L4::
    goto L3
    ::L5::
    r[2] = get_upvalue(0)
    ::L6::
    r[3] = r[2]
    r[2] = r[2]["FindFirstChild"]
    ::L7::
    r[4] = "Modules"
    ::L8::
    r[2] = r[2](unpack(r, 3, 4))
    ::L9::
    if r[2] then goto L11 else r[1] = r[2]; goto L17 end
    ::L10::
    goto L17
    ::L11::
    r[2] = get_upvalue(0)
    ::L12::
    r[2] = r[2]["Modules"]
    ::L13::
    r[3] = r[2]
    r[2] = r[2]["FindFirstChild"]
    ::L14::
    r[4] = "WeaponRegistry"
    ::L15::
    r[2] = r[2](unpack(r, 3, 4))
    ::L16::
    r[1] = r[2]
    ::L17::
    if r[1] then goto L19 else goto L24 end
    ::L18::
    goto L24
    ::L19::
    r[2] = env["require"]
    ::L20::
    r[3] = r[1]
    ::L21::
    r[2] = r[2](r[3])
    ::L22::
    if not r[2] then goto L24 else goto L25 end
    ::L23::
    goto L25
    ::L24::
    r[2] = {}
    ::L25::
    do return r[2] end
    ::L26::
    goto L3
    ::L27::
    do return end
  end
end

protos["0_17"] = function(env, u)
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
    r[1] = get_upvalue(0)
    ::L2::
    r[2] = "Rifle"
    ::L3::
    r[3] = r[0]
    ::L4::
    r[4] = get_upvalue(1)
    ::L5::
    r[1](unpack(r, 2, 4))
    ::L6::
    do return end
  end
end

protos["0_18"] = function(env, u)
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
    r[1] = get_upvalue(0)
    ::L2::
    r[2] = "Melee"
    ::L3::
    r[3] = r[0]
    ::L4::
    r[4] = get_upvalue(1)
    ::L5::
    r[1](unpack(r, 2, 4))
    ::L6::
    do return end
  end
end

protos["0_19"] = function(env, u)
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
    if r[0] then goto L3 else goto L6 end
    ::L2::
    goto L6
    ::L3::
    r[1] = get_upvalue(0)
    ::L4::
    r[2] = r[1]
    r[1] = r[1]["start"]
    ::L5::
    r[1](r[2])
    ::L6::
    do return end
  end
end

protos["0_20"] = function(env, u)
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
    do return end
  end
end

protos["0_21"] = function(env, u)
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
    r[0] = 0
    ::L2::
    if r[0] == 0 then goto L4 else goto L27 end
    ::L3::
    goto L27
    ::L4::
    r[1] = get_upvalue(0)
    ::L5::
    r[1] = not r[1]
    ::L6::
    set_upvalue(0, r[1])
    ::L7::
    r[1] = get_upvalue(1)
    ::L8::
    r[2] = get_upvalue(0)
    ::L9::
    if r[2] then goto L11 else goto L19 end
    ::L10::
    goto L19
    ::L11::
    r[2] = env["Color3"]
    ::L12::
    r[2] = r[2]["fromRGB"]
    ::L13::
    r[3] = 42
    ::L14::
    r[4] = 62
    ::L15::
    r[5] = 54
    ::L16::
    r[2] = r[2](unpack(r, 3, 5))
    ::L17::
    if not r[2] then goto L19 else goto L25 end
    ::L18::
    goto L25
    ::L19::
    r[2] = env["Color3"]
    ::L20::
    r[2] = r[2]["fromRGB"]
    ::L21::
    r[3] = 30
    ::L22::
    r[4] = 33
    ::L23::
    r[5] = 42
    ::L24::
    r[2] = r[2](unpack(r, 3, 5))
    ::L25::
    r[1]["BackgroundColor3"] = r[2]
    ::L26::
    r[0] = 1
    ::L27::
    if r[0] == 1 then goto L29 else goto L60 end
    ::L28::
    goto L60
    ::L29::
    r[1] = get_upvalue(1)
    ::L30::
    r[2] = get_upvalue(0)
    ::L31::
    if r[2] then goto L33 else goto L41 end
    ::L32::
    goto L41
    ::L33::
    r[2] = env["Color3"]
    ::L34::
    r[2] = r[2]["fromRGB"]
    ::L35::
    r[3] = 160
    ::L36::
    r[4] = 240
    ::L37::
    r[5] = 190
    ::L38::
    r[2] = r[2](unpack(r, 3, 5))
    ::L39::
    if not r[2] then goto L41 else goto L47 end
    ::L40::
    goto L47
    ::L41::
    r[2] = env["Color3"]
    ::L42::
    r[2] = r[2]["fromRGB"]
    ::L43::
    r[3] = 175
    ::L44::
    r[4] = 180
    ::L45::
    r[5] = 192
    ::L46::
    r[2] = r[2](unpack(r, 3, 5))
    ::L47::
    r[1]["TextColor3"] = r[2]
    ::L48::
    r[1] = get_upvalue(1)
    ::L49::
    r[2] = get_upvalue(2)
    ::L50::
    r[3] = get_upvalue(0)
    ::L51::
    if r[3] then goto L53 else goto L56 end
    ::L52::
    goto L56
    ::L53::
    r[3] = " [ON]"
    ::L54::
    if not r[3] then goto L56 else goto L57 end
    ::L55::
    goto L57
    ::L56::
    r[3] = " [OFF]"
    ::L57::
    do local value = r[2]; for i = 3, 3 do value = value .. r[i] end; r[2] = value end
    ::L58::
    r[1]["Text"] = r[2]
    ::L59::
    r[0] = 2
    ::L60::
    if r[0] == 2 then goto L62 else goto L2 end
    ::L61::
    goto L2
    ::L62::
    r[1] = get_upvalue(3)
    ::L63::
    r[1] = r[1]["set"]
    ::L64::
    r[2] = get_upvalue(4)
    ::L65::
    r[3] = get_upvalue(0)
    ::L66::
    r[4] = true
    ::L67::
    r[1](unpack(r, 2, 4))
    ::L68::
    r[1] = get_upvalue(5)
    ::L69::
    r[2] = get_upvalue(0)
    ::L70::
    r[1](r[2])
    ::L71::
    goto L73
    ::L72::
    goto L2
    ::L73::
    do return end
  end
end

protos["0_22"] = function(env, u)
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
    if not r[1] then goto L3 else goto L14 end
    ::L2::
    goto L14
    ::L3::
    r[2] = r[0]["KeyCode"]
    ::L4::
    r[3] = env["Enum"]
    ::L5::
    r[3] = r[3]["KeyCode"]
    ::L6::
    r[3] = r[3]["RightShift"]
    ::L7::
    if r[2] == r[3] then goto L9 else goto L14 end
    ::L8::
    goto L14
    ::L9::
    r[2] = get_upvalue(0)
    ::L10::
    r[3] = get_upvalue(0)
    ::L11::
    r[3] = r[3]["Enabled"]
    ::L12::
    r[3] = not r[3]
    ::L13::
    r[2]["Enabled"] = r[3]
    ::L14::
    do return end
  end
end

protos["0_23"] = function(env, u)
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
    r[1] = r[0]["UserInputType"]
    ::L2::
    r[2] = env["Enum"]
    ::L3::
    r[2] = r[2]["UserInputType"]
    ::L4::
    r[2] = r[2]["MouseButton1"]
    ::L5::
    if r[1] ~= r[2] then goto L7 else goto L13 end
    ::L6::
    goto L13
    ::L7::
    r[1] = r[0]["UserInputType"]
    ::L8::
    r[2] = env["Enum"]
    ::L9::
    r[2] = r[2]["UserInputType"]
    ::L10::
    r[2] = r[2]["Touch"]
    ::L11::
    if r[1] == r[2] then goto L13 else goto L15 end
    ::L12::
    goto L15
    ::L13::
    r[1] = false
    ::L14::
    set_upvalue(0, r[1])
    ::L15::
    do return end
  end
end

protos["0_24"] = function(env, u)
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
    r[1] = get_upvalue(0)
    ::L2::
    if r[1] then goto L4 else goto L46 end
    ::L3::
    goto L46
    ::L4::
    r[1] = r[0]["UserInputType"]
    ::L5::
    r[2] = env["Enum"]
    ::L6::
    r[2] = r[2]["UserInputType"]
    ::L7::
    r[2] = r[2]["MouseMovement"]
    ::L8::
    if r[1] ~= r[2] then goto L10 else goto L16 end
    ::L9::
    goto L16
    ::L10::
    r[1] = r[0]["UserInputType"]
    ::L11::
    r[2] = env["Enum"]
    ::L12::
    r[2] = r[2]["UserInputType"]
    ::L13::
    r[2] = r[2]["Touch"]
    ::L14::
    if r[1] == r[2] then goto L16 else goto L46 end
    ::L15::
    goto L46
    ::L16::
    r[1] = 0
    ::L17::
    for i = 2, 2 do r[i] = nil end
    ::L18::
    if r[1] == 0 then goto L20 else goto L18 end
    ::L19::
    goto L18
    ::L20::
    r[3] = r[0]["Position"]
    ::L21::
    r[4] = get_upvalue(1)
    ::L22::
    r[2] = r[3] - r[4]
    ::L23::
    r[3] = get_upvalue(2)
    ::L24::
    r[4] = env["UDim2"]
    ::L25::
    r[4] = r[4]["new"]
    ::L26::
    r[5] = get_upvalue(3)
    ::L27::
    r[5] = r[5]["X"]
    ::L28::
    r[5] = r[5]["Scale"]
    ::L29::
    r[6] = get_upvalue(3)
    ::L30::
    r[6] = r[6]["X"]
    ::L31::
    r[6] = r[6]["Offset"]
    ::L32::
    r[7] = r[2]["X"]
    ::L33::
    r[6] = r[6] + r[7]
    ::L34::
    r[7] = get_upvalue(3)
    ::L35::
    r[7] = r[7]["Y"]
    ::L36::
    r[7] = r[7]["Scale"]
    ::L37::
    r[8] = get_upvalue(3)
    ::L38::
    r[8] = r[8]["Y"]
    ::L39::
    r[8] = r[8]["Offset"]
    ::L40::
    r[9] = r[2]["Y"]
    ::L41::
    r[8] = r[8] + r[9]
    ::L42::
    r[4] = r[4](unpack(r, 5, 8))
    ::L43::
    r[3]["Position"] = r[4]
    ::L44::
    goto L46
    ::L45::
    goto L18
    ::L46::
    do return end
  end
end

protos["0_25"] = function(env, u)
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
    r[1] = r[0]["UserInputType"]
    ::L2::
    r[2] = env["Enum"]
    ::L3::
    r[2] = r[2]["UserInputType"]
    ::L4::
    r[2] = r[2]["MouseButton1"]
    ::L5::
    if r[1] ~= r[2] then goto L7 else goto L13 end
    ::L6::
    goto L13
    ::L7::
    r[1] = r[0]["UserInputType"]
    ::L8::
    r[2] = env["Enum"]
    ::L9::
    r[2] = r[2]["UserInputType"]
    ::L10::
    r[2] = r[2]["Touch"]
    ::L11::
    if r[1] == r[2] then goto L13 else goto L28 end
    ::L12::
    goto L28
    ::L13::
    r[1] = 0
    ::L14::
    if r[1] == 0 then goto L16 else goto L21 end
    ::L15::
    goto L21
    ::L16::
    r[2] = true
    ::L17::
    set_upvalue(0, r[2])
    ::L18::
    r[2] = r[0]["Position"]
    ::L19::
    set_upvalue(1, r[2])
    ::L20::
    r[1] = 1
    ::L21::
    if r[1] == 1 then goto L23 else goto L14 end
    ::L22::
    goto L14
    ::L23::
    r[2] = get_upvalue(3)
    ::L24::
    r[2] = r[2]["Position"]
    ::L25::
    set_upvalue(2, r[2])
    ::L26::
    goto L28
    ::L27::
    goto L14
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
    r[0] = env["game"]
    ::L2::
    r[1] = r[0]
    r[0] = r[0]["GetService"]
    ::L3::
    r[2] = "Players"
    ::L4::
    r[0] = r[0](unpack(r, 1, 2))
    ::L5::
    r[1] = env["game"]
    ::L6::
    r[2] = r[1]
    r[1] = r[1]["GetService"]
    ::L7::
    r[3] = "ReplicatedStorage"
    ::L8::
    r[1] = r[1](unpack(r, 2, 3))
    ::L9::
    r[2] = env["game"]
    ::L10::
    r[3] = r[2]
    r[2] = r[2]["GetService"]
    ::L11::
    r[4] = "RunService"
    ::L12::
    r[2] = r[2](unpack(r, 3, 4))
    ::L13::
    r[3] = env["game"]
    ::L14::
    r[4] = r[3]
    r[3] = r[3]["GetService"]
    ::L15::
    r[5] = "UserInputService"
    ::L16::
    r[3] = r[3](unpack(r, 4, 5))
    ::L17::
    r[4] = env["game"]
    ::L18::
    r[5] = r[4]
    r[4] = r[4]["GetService"]
    ::L19::
    r[6] = "HttpService"
    ::L20::
    r[4] = r[4](unpack(r, 5, 6))
    ::L21::
    r[5] = r[0]["LocalPlayer"]
    ::L22::
    r[6] = "nebula_sentinel_v2.json"
    ::L23::
    r[7] = 8472910452
    ::L24::
    r[8] = env["game"]
    ::L25::
    r[8] = r[8]["PlaceId"]
    ::L26::
    if r[8] ~= 0 then goto L28 else goto L41 end
    ::L27::
    goto L41
    ::L28::
    r[8] = env["game"]
    ::L29::
    r[8] = r[8]["PlaceId"]
    ::L30::
    if r[8] ~= r[7] then goto L32 else goto L41 end
    ::L31::
    goto L41
    ::L32::
    r[8] = env["warn"]
    ::L33::
    r[9] = env["string"]
    ::L34::
    r[9] = r[9]["format"]
    ::L35::
    r[10] = "[Nebula] Unsupported PlaceId: %d (expected %d)"
    ::L36::
    r[11] = env["game"]
    ::L37::
    r[11] = r[11]["PlaceId"]
    ::L38::
    r[12] = r[7]
    ::L39::
    do local out = pack(r[9](r[10])); top = 9 + out.n - 1; for i = 1, out.n do r[9 + i - 1] = out[i] end end
    ::L40::
    r[8](unpack(r, 9, top))
    ::L41::
    r[8] = protos["0_0"](env, {
    })
    ::L42::
    r[9] = protos["0_1"](env, {
    })
    ::L43::
    r[10] = protos["0_2"](env, {
    })
    ::L44::
    r[11] = protos["0_3"](env, {
      [0] = capture_upvalue(6),
      [1] = capture_upvalue(4),
      [2] = capture_upvalue(8),
    })
    ::L48::
    r[12] = {}
    ::L49::
    r[12]["__index"] = r[12]
    ::L50::
    r[13] = protos["0_4"](env, {
      [0] = capture_upvalue(12),
    })
    ::L52::
    r[12]["new"] = r[13]
    ::L53::
    r[13] = protos["0_5"](env, {
    })
    ::L54::
    r[12]["register"] = r[13]
    ::L55::
    r[13] = protos["0_6"](env, {
    })
    ::L56::
    r[12]["pruneInactive"] = r[13]
    ::L57::
    r[13] = protos["0_7"](env, {
    })
    ::L58::
    r[12]["step"] = r[13]
    ::L59::
    r[13] = protos["0_8"](env, {
      [0] = capture_upvalue(2),
    })
    ::L61::
    r[12]["start"] = r[13]
    ::L62::
    r[13] = protos["0_9"](env, {
    })
    ::L63::
    r[12]["stop"] = r[13]
    ::L64::
    r[13] = {}
    ::L65::
    r[14] = {}
    ::L66::
    r[14]["skipLocked"] = true
    ::L67::
    r[15] = {}
    ::L68::
    r[15]["Spread"] = 0
    ::L69::
    r[15]["RecoilPitch"] = 0.02
    ::L70::
    r[15]["FireCooldown"] = 0.045
    ::L71::
    r[15]["Range"] = 450
    ::L72::
    r[14]["overrides"] = r[15]
    ::L73::
    r[13]["Rifle"] = r[14]
    ::L74::
    r[14] = {}
    ::L75::
    r[14]["skipLocked"] = false
    ::L76::
    r[15] = {}
    ::L77::
    r[15]["SwingCooldown"] = 0.08
    ::L78::
    r[15]["HitboxScale"] = 1.35
    ::L79::
    r[15]["Recovery"] = 0.05
    ::L80::
    r[14]["overrides"] = r[15]
    ::L81::
    r[13]["Melee"] = r[14]
    ::L82::
    r[14] = {}
    ::L83::
    r[15] = protos["0_10"](env, {
      [0] = capture_upvalue(13),
      [1] = capture_upvalue(14),
    })
    ::L86::
    r[16] = protos["0_11"](env, {
      [0] = capture_upvalue(5),
    })
    ::L88::
    r[17] = protos["0_12"](env, {
      [0] = capture_upvalue(0),
      [1] = capture_upvalue(16),
      [2] = capture_upvalue(5),
    })
    ::L92::
    r[18] = protos["0_13"](env, {
      [0] = capture_upvalue(10),
      [1] = capture_upvalue(9),
    })
    ::L95::
    r[19] = protos["0_14"](env, {
    })
    ::L96::
    r[20] = r[11]
    ::L97::
    r[21] = {}
    ::L98::
    r[21]["rifleBypass"] = false
    ::L99::
    r[21]["meleeBypass"] = false
    ::L100::
    r[21]["autoOrbit"] = false
    ::L101::
    r[21]["scanRadius"] = 180
    ::L102::
    r[21]["allowTeam"] = false
    ::L103::
    r[20] = r[20](r[21])
    ::L104::
    r[21] = r[20]["load"]
    ::L105::
    r[21]()
    ::L106::
    r[21] = r[12]["new"]
    ::L107::
    r[22] = "NebulaCore"
    ::L108::
    r[23] = 6
    ::L109::
    r[21] = r[21](unpack(r, 22, 23))
    ::L110::
    r[22] = 0
    ::L111::
    for i = 23, 23 do r[i] = nil end
    ::L112::
    r[25] = r[21]
    r[24] = r[21]["register"]
    ::L113::
    r[26] = "TargetOrbit"
    ::L114::
    r[27] = 0.016
    ::L115::
    r[28] = protos["0_15"](env, {
      [0] = capture_upvalue(9),
      [1] = capture_upvalue(20),
      [2] = capture_upvalue(23),
      [3] = capture_upvalue(17),
      [4] = capture_upvalue(16),
      [5] = capture_upvalue(22),
      [6] = capture_upvalue(5),
    })
    ::L123::
    r[24](unpack(r, 25, 28))
    ::L124::
    r[24] = env["gethui"]
    ::L125::
    if r[24] then goto L127 else goto L131 end
    ::L126::
    goto L131
    ::L127::
    r[24] = env["gethui"]
    ::L128::
    r[24] = r[24]()
    ::L129::
    if not r[24] then goto L131 else goto L134 end
    ::L130::
    goto L134
    ::L131::
    r[25] = r[5]
    r[24] = r[5]["WaitForChild"]
    ::L132::
    r[26] = "PlayerGui"
    ::L133::
    r[24] = r[24](unpack(r, 25, 26))
    ::L134::
    r[26] = r[24]
    r[25] = r[24]["FindFirstChild"]
    ::L135::
    r[27] = "NebulaSentinelUI"
    ::L136::
    r[25] = r[25](unpack(r, 26, 27))
    ::L137::
    if r[25] then goto L139 else goto L141 end
    ::L138::
    goto L141
    ::L139::
    r[27] = r[25]
    r[26] = r[25]["Destroy"]
    ::L140::
    r[26](r[27])
    ::L141::
    r[26] = r[19]
    ::L142::
    r[27] = "ScreenGui"
    ::L143::
    r[28] = {}
    ::L144::
    r[28]["Name"] = "NebulaSentinelUI"
    ::L145::
    r[28]["ResetOnSpawn"] = false
    ::L146::
    r[29] = env["Enum"]
    ::L147::
    r[29] = r[29]["ZIndexBehavior"]
    ::L148::
    r[29] = r[29]["Sibling"]
    ::L149::
    r[28]["ZIndexBehavior"] = r[29]
    ::L150::
    r[28]["Parent"] = r[24]
    ::L151::
    r[26] = r[26](unpack(r, 27, 28))
    ::L152::
    r[27] = r[19]
    ::L153::
    r[28] = "Frame"
    ::L154::
    r[29] = {}
    ::L155::
    r[30] = env["UDim2"]
    ::L156::
    r[30] = r[30]["new"]
    ::L157::
    r[31] = 0
    ::L158::
    r[32] = 240
    ::L159::
    r[33] = 0
    ::L160::
    r[34] = 280
    ::L161::
    r[30] = r[30](unpack(r, 31, 34))
    ::L162::
    r[29]["Size"] = r[30]
    ::L163::
    r[30] = env["UDim2"]
    ::L164::
    r[30] = r[30]["new"]
    ::L165::
    r[31] = 0
    ::L166::
    r[32] = 48
    ::L167::
    r[33] = 0
    ::L168::
    r[34] = 140
    ::L169::
    r[30] = r[30](unpack(r, 31, 34))
    ::L170::
    r[29]["Position"] = r[30]
    ::L171::
    r[30] = env["Color3"]
    ::L172::
    r[30] = r[30]["fromRGB"]
    ::L173::
    r[31] = 20
    ::L174::
    r[32] = 22
    ::L175::
    r[33] = 28
    ::L176::
    r[30] = r[30](unpack(r, 31, 33))
    ::L177::
    r[29]["BackgroundColor3"] = r[30]
    ::L178::
    r[29]["BorderSizePixel"] = 0
    ::L179::
    r[29]["Parent"] = r[26]
    ::L180::
    r[30] = {}
    ::L181::
    r[31] = r[19]
    ::L182::
    r[32] = "UICorner"
    ::L183::
    r[33] = {}
    ::L184::
    r[34] = env["UDim"]
    ::L185::
    r[34] = r[34]["new"]
    ::L186::
    r[35] = 0
    ::L187::
    r[36] = 12
    ::L188::
    r[34] = r[34](unpack(r, 35, 36))
    ::L189::
    r[33]["CornerRadius"] = r[34]
    ::L190::
    r[31] = r[31](unpack(r, 32, 33))
    ::L191::
    r[32] = r[19]
    ::L192::
    r[33] = "UIStroke"
    ::L193::
    r[34] = {}
    ::L194::
    r[35] = env["Color3"]
    ::L195::
    r[35] = r[35]["fromRGB"]
    ::L196::
    r[36] = 62
    ::L197::
    r[37] = 68
    ::L198::
    r[38] = 82
    ::L199::
    r[35] = r[35](unpack(r, 36, 38))
    ::L200::
    r[34]["Color"] = r[35]
    ::L201::
    r[34]["Thickness"] = 1
    ::L202::
    do local out = pack(r[32](r[33])); top = 32 + out.n - 1; for i = 1, out.n do r[32 + i - 1] = out[i] end end
    ::L203::
    for i = 31, top do table.insert(r[30], r[i]) end
    ::L204::
    r[27] = r[27](unpack(r, 28, 30))
    ::L205::
    r[28] = r[19]
    ::L206::
    r[29] = "TextLabel"
    ::L207::
    r[30] = {}
    ::L208::
    r[31] = env["UDim2"]
    ::L209::
    r[31] = r[31]["new"]
    ::L210::
    r[32] = 1
    ::L211::
    r[33] = -20
    ::L212::
    r[34] = 0
    ::L213::
    r[35] = 32
    ::L214::
    r[31] = r[31](unpack(r, 32, 35))
    ::L215::
    r[30]["Size"] = r[31]
    ::L216::
    r[31] = env["UDim2"]
    ::L217::
    r[31] = r[31]["new"]
    ::L218::
    r[32] = 0
    ::L219::
    r[33] = 10
    ::L220::
    r[34] = 0
    ::L221::
    r[35] = 0
    ::L222::
    r[31] = r[31](unpack(r, 32, 35))
    ::L223::
    r[30]["Position"] = r[31]
    ::L224::
    r[30]["BackgroundTransparency"] = 1
    ::L225::
    r[30]["Text"] = "Nebula Sentinel v2.4"
    ::L226::
    r[31] = env["Color3"]
    ::L227::
    r[31] = r[31]["fromRGB"]
    ::L228::
    r[32] = 235
    ::L229::
    r[33] = 238
    ::L230::
    r[34] = 245
    ::L231::
    r[31] = r[31](unpack(r, 32, 34))
    ::L232::
    r[30]["TextColor3"] = r[31]
    ::L233::
    r[31] = env["Enum"]
    ::L234::
    r[31] = r[31]["Font"]
    ::L235::
    r[31] = r[31]["Code"]
    ::L236::
    r[30]["Font"] = r[31]
    ::L237::
    r[30]["TextSize"] = 13
    ::L238::
    r[31] = env["Enum"]
    ::L239::
    r[31] = r[31]["TextXAlignment"]
    ::L240::
    r[31] = r[31]["Left"]
    ::L241::
    r[30]["TextXAlignment"] = r[31]
    ::L242::
    r[30]["Parent"] = r[27]
    ::L243::
    r[28] = r[28](unpack(r, 29, 30))
    ::L244::
    r[29] = r[19]
    ::L245::
    r[30] = "Frame"
    ::L246::
    r[31] = {}
    ::L247::
    r[32] = env["UDim2"]
    ::L248::
    r[32] = r[32]["new"]
    ::L249::
    r[33] = 1
    ::L250::
    r[34] = -16
    ::L251::
    r[35] = 1
    ::L252::
    r[36] = -44
    ::L253::
    r[32] = r[32](unpack(r, 33, 36))
    ::L254::
    r[31]["Size"] = r[32]
    ::L255::
    r[32] = env["UDim2"]
    ::L256::
    r[32] = r[32]["new"]
    ::L257::
    r[33] = 0
    ::L258::
    r[34] = 8
    ::L259::
    r[35] = 0
    ::L260::
    r[36] = 36
    ::L261::
    r[32] = r[32](unpack(r, 33, 36))
    ::L262::
    r[31]["Position"] = r[32]
    ::L263::
    r[31]["BackgroundTransparency"] = 1
    ::L264::
    r[31]["Parent"] = r[27]
    ::L265::
    r[32] = {}
    ::L266::
    r[33] = r[19]
    ::L267::
    r[34] = "UIListLayout"
    ::L268::
    r[35] = {}
    ::L269::
    r[36] = env["UDim"]
    ::L270::
    r[36] = r[36]["new"]
    ::L271::
    r[37] = 0
    ::L272::
    r[38] = 6
    ::L273::
    r[36] = r[36](unpack(r, 37, 38))
    ::L274::
    r[35]["Padding"] = r[36]
    ::L275::
    r[36] = env["Enum"]
    ::L276::
    r[36] = r[36]["SortOrder"]
    ::L277::
    r[36] = r[36]["LayoutOrder"]
    ::L278::
    r[35]["SortOrder"] = r[36]
    ::L279::
    do local out = pack(r[33](r[34])); top = 33 + out.n - 1; for i = 1, out.n do r[33 + i - 1] = out[i] end end
    ::L280::
    for i = 33, top do table.insert(r[32], r[i]) end
    ::L281::
    r[29] = r[29](unpack(r, 30, 32))
    ::L282::
    r[30] = {}
    ::L283::
    r[31] = r[18]
    ::L284::
    r[32] = "LoadItemRegistry"
    ::L285::
    r[33] = 2
    ::L286::
    r[34] = protos["0_16"](env, {
      [0] = capture_upvalue(1),
    })
    ::L288::
    do local out = {r[31](r[32])}; for i = 0, 1 do r[31 + i] = out[i + 1] end end
    ::L289::
    if r[31] then goto L291 else goto L300 end
    ::L290::
    goto L300
    ::L291::
    r[33] = env["type"]
    ::L292::
    r[34] = r[32]
    ::L293::
    r[33] = r[33](r[34])
    ::L294::
    if r[33] == "table" then goto L296 else goto L300 end
    ::L295::
    goto L300
    ::L296::
    r[33] = r[32]["Items"]
    ::L297::
    if r[33] then r[30] = r[33]; goto L300 else goto L299 end
    ::L298::
    goto L300
    ::L299::
    r[30] = r[32]
    ::L300::
    r[33] = {}
    ::L301::
    r[34] = {}
    ::L302::
    r[35] = "Rifle Fast-Fire"
    ::L303::
    r[36] = "rifleBypass"
    ::L304::
    r[37] = protos["0_17"](env, {
      [0] = capture_upvalue(15),
      [1] = capture_upvalue(30),
    })
    ::L307::
    for i = 1, 3 do r[34][i] = r[34 + i] end
    ::L308::
    r[35] = {}
    ::L309::
    r[36] = "Melee Cooldown"
    ::L310::
    r[37] = "meleeBypass"
    ::L311::
    r[38] = protos["0_18"](env, {
      [0] = capture_upvalue(15),
      [1] = capture_upvalue(30),
    })
    ::L314::
    for i = 1, 3 do r[35][i] = r[35 + i] end
    ::L315::
    r[36] = {}
    ::L316::
    r[37] = "Auto Orbit Nearest"
    ::L317::
    r[38] = "autoOrbit"
    ::L318::
    r[39] = protos["0_19"](env, {
      [0] = capture_upvalue(21),
    })
    ::L320::
    for i = 1, 3 do r[36][i] = r[36 + i] end
    ::L321::
    r[37] = {}
    ::L322::
    r[38] = "Include Teammates"
    ::L323::
    r[39] = "allowTeam"
    ::L324::
    r[40] = protos["0_20"](env, {
    })
    ::L325::
    for i = 1, 3 do r[37][i] = r[37 + i] end
    ::L326::
    for i = 1, 4 do r[33][i] = r[33 + i] end
    ::L327::
    r[34] = env["ipairs"]
    ::L328::
    r[35] = r[33]
    ::L329::
    do local out = {r[34](r[35])}; for i = 0, 2 do r[34 + i] = out[i + 1] end end
    ::L330::
    goto L433
    ::L331::
    r[39] = r[38][1]
    ::L332::
    r[40] = r[38][2]
    ::L333::
    r[41] = r[38][3]
    ::L334::
    r[42] = r[20]["get"]
    ::L335::
    r[43] = r[40]
    ::L336::
    r[42] = r[42](r[43])
    ::L337::
    if r[42] ~= true then goto L339 else goto L340 end
    ::L338::
    goto L340
    ::L339::
    r[42] = false
    ::L340::
    r[42] = true
    ::L341::
    r[43] = r[19]
    ::L342::
    r[44] = "TextButton"
    ::L343::
    r[45] = {}
    ::L344::
    r[46] = env["UDim2"]
    ::L345::
    r[46] = r[46]["new"]
    ::L346::
    r[47] = 1
    ::L347::
    r[48] = 0
    ::L348::
    r[49] = 0
    ::L349::
    r[50] = 32
    ::L350::
    r[46] = r[46](unpack(r, 47, 50))
    ::L351::
    r[45]["Size"] = r[46]
    ::L352::
    if r[42] then goto L354 else goto L362 end
    ::L353::
    goto L362
    ::L354::
    r[46] = env["Color3"]
    ::L355::
    r[46] = r[46]["fromRGB"]
    ::L356::
    r[47] = 42
    ::L357::
    r[48] = 62
    ::L358::
    r[49] = 54
    ::L359::
    r[46] = r[46](unpack(r, 47, 49))
    ::L360::
    if not r[46] then goto L362 else goto L368 end
    ::L361::
    goto L368
    ::L362::
    r[46] = env["Color3"]
    ::L363::
    r[46] = r[46]["fromRGB"]
    ::L364::
    r[47] = 30
    ::L365::
    r[48] = 33
    ::L366::
    r[49] = 42
    ::L367::
    r[46] = r[46](unpack(r, 47, 49))
    ::L368::
    r[45]["BackgroundColor3"] = r[46]
    ::L369::
    r[45]["BorderSizePixel"] = 0
    ::L370::
    r[45]["AutoButtonColor"] = false
    ::L371::
    r[46] = r[39]
    ::L372::
    if r[42] then goto L374 else goto L377 end
    ::L373::
    goto L377
    ::L374::
    r[47] = " [ON]"
    ::L375::
    if not r[47] then goto L377 else goto L378 end
    ::L376::
    goto L378
    ::L377::
    r[47] = " [OFF]"
    ::L378::
    do local value = r[46]; for i = 47, 47 do value = value .. r[i] end; r[46] = value end
    ::L379::
    r[45]["Text"] = r[46]
    ::L380::
    if r[42] then goto L382 else goto L390 end
    ::L381::
    goto L390
    ::L382::
    r[46] = env["Color3"]
    ::L383::
    r[46] = r[46]["fromRGB"]
    ::L384::
    r[47] = 160
    ::L385::
    r[48] = 240
    ::L386::
    r[49] = 190
    ::L387::
    r[46] = r[46](unpack(r, 47, 49))
    ::L388::
    if not r[46] then goto L390 else goto L396 end
    ::L389::
    goto L396
    ::L390::
    r[46] = env["Color3"]
    ::L391::
    r[46] = r[46]["fromRGB"]
    ::L392::
    r[47] = 175
    ::L393::
    r[48] = 180
    ::L394::
    r[49] = 192
    ::L395::
    r[46] = r[46](unpack(r, 47, 49))
    ::L396::
    r[45]["TextColor3"] = r[46]
    ::L397::
    r[46] = env["Enum"]
    ::L398::
    r[46] = r[46]["Font"]
    ::L399::
    r[46] = r[46]["Code"]
    ::L400::
    r[45]["Font"] = r[46]
    ::L401::
    r[45]["TextSize"] = 12
    ::L402::
    r[45]["LayoutOrder"] = r[37]
    ::L403::
    r[45]["Parent"] = r[29]
    ::L404::
    r[46] = {}
    ::L405::
    r[47] = r[19]
    ::L406::
    r[48] = "UICorner"
    ::L407::
    r[49] = {}
    ::L408::
    r[50] = env["UDim"]
    ::L409::
    r[50] = r[50]["new"]
    ::L410::
    r[51] = 0
    ::L411::
    r[52] = 8
    ::L412::
    r[50] = r[50](unpack(r, 51, 52))
    ::L413::
    r[49]["CornerRadius"] = r[50]
    ::L414::
    do local out = pack(r[47](r[48])); top = 47 + out.n - 1; for i = 1, out.n do r[47 + i - 1] = out[i] end end
    ::L415::
    for i = 47, top do table.insert(r[46], r[i]) end
    ::L416::
    r[43] = r[43](unpack(r, 44, 46))
    ::L417::
    r[44] = r[43]["MouseButton1Click"]
    ::L418::
    r[45] = r[44]
    r[44] = r[44]["Connect"]
    ::L419::
    r[46] = protos["0_21"](env, {
      [0] = capture_upvalue(42),
      [1] = capture_upvalue(43),
      [2] = capture_upvalue(39),
      [3] = capture_upvalue(20),
      [4] = capture_upvalue(40),
      [5] = capture_upvalue(41),
    })
    ::L426::
    r[44](unpack(r, 45, 46))
    ::L427::
    if r[42] then goto L429 else goto L432 end
    ::L428::
    goto L432
    ::L429::
    r[44] = r[41]
    ::L430::
    r[45] = true
    ::L431::
    r[44](r[45])
    ::L432::
    close_upvalues(39)
    ::L433::
    do local out = {r[34](r[35], r[36])}; for i = 1, 2 do r[36 + i] = out[i] end; if out[1] then r[36] = out[1]; goto L331 else goto L435 end end
    ::L434::
    goto L331
    ::L435::
    r[34] = 0
    ::L436::
    for i = 35, 37 do r[i] = nil end
    ::L437::
    if r[34] == 0 then goto L439 else goto L442 end
    ::L438::
    goto L442
    ::L439::
    r[35] = false
    ::L440::
    for i = 36, 36 do r[i] = nil end
    ::L441::
    r[34] = 1
    ::L442::
    if 3 == r[34] then goto L444 else goto L450 end
    ::L443::
    goto L450
    ::L444::
    r[38] = r[3]["InputBegan"]
    ::L445::
    r[39] = r[38]
    r[38] = r[38]["Connect"]
    ::L446::
    r[40] = protos["0_22"](env, {
      [0] = capture_upvalue(26),
    })
    ::L448::
    r[38](unpack(r, 39, 40))
    ::L449::
    goto L479
    ::L450::
    if r[34] == 2 then goto L452 else goto L466 end
    ::L451::
    goto L466
    ::L452::
    r[38] = r[3]["InputEnded"]
    ::L453::
    r[39] = r[38]
    r[38] = r[38]["Connect"]
    ::L454::
    r[40] = protos["0_23"](env, {
      [0] = capture_upvalue(35),
    })
    ::L456::
    r[38](unpack(r, 39, 40))
    ::L457::
    r[38] = r[3]["InputChanged"]
    ::L458::
    r[39] = r[38]
    r[38] = r[38]["Connect"]
    ::L459::
    r[40] = protos["0_24"](env, {
      [0] = capture_upvalue(35),
      [1] = capture_upvalue(36),
      [2] = capture_upvalue(27),
      [3] = capture_upvalue(37),
    })
    ::L464::
    r[38](unpack(r, 39, 40))
    ::L465::
    r[34] = 3
    ::L466::
    if r[34] == 1 then goto L468 else goto L437 end
    ::L467::
    goto L437
    ::L468::
    for i = 37, 37 do r[i] = nil end
    ::L469::
    r[38] = r[28]["InputBegan"]
    ::L470::
    r[39] = r[38]
    r[38] = r[38]["Connect"]
    ::L471::
    r[40] = protos["0_25"](env, {
      [0] = capture_upvalue(35),
      [1] = capture_upvalue(36),
      [2] = capture_upvalue(37),
      [3] = capture_upvalue(27),
    })
    ::L476::
    r[38](unpack(r, 39, 40))
    ::L477::
    r[34] = 2
    ::L478::
    goto L437
    ::L479::
    close_upvalues(34)
    ::L480::
    r[35] = r[21]
    r[34] = r[21]["start"]
    ::L481::
    r[34](r[35])
    ::L482::
    r[34] = r[8]
    ::L483::
    r[35] = "NebulaSentinelReady"
    ::L484::
    r[36] = 42
    ::L485::
    do local out = {r[34](r[35])}; for i = 0, 2 do r[34 + i] = out[i + 1] end end
    ::L486::
    r[37] = env["print"]
    ::L487::
    r[38] = env["string"]
    ::L488::
    r[38] = r[38]["format"]
    ::L489::
    r[39] = "[Nebula] Loaded OK | sig=%s (%d, len=%d)"
    ::L490::
    r[40] = r[35]
    ::L491::
    r[41] = r[34]
    ::L492::
    r[42] = r[36]
    ::L493::
    do local out = pack(r[38](r[39])); top = 38 + out.n - 1; for i = 1, out.n do r[38 + i - 1] = out[i] end end
    ::L494::
    r[37](unpack(r, 38, top))
    ::L495::
    close_upvalues(0)
    ::L496::
    do return end
  end
end

print("Deobf By Zed")
return protos["0"](_ENV, {})()
