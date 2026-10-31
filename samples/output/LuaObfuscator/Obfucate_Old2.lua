-- LuaObfuscator: register machine restructured to Luau.
-- Every instruction is classified; labels and goto are rebuilt as if/while/break.
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
    r[2] = 0
    while true do
      if r[2] == 2 then
        break
      end
      if r[2] == 0 then
        if r[1] then
          r[3] = r[1]
        else
          r[3] = 2166136261
        end
        r[4] = #r[0]
        r[2] = 1
      end
      if not (r[2] == 1) then
        continue
      end
      r[6] = 1
      r[7] = r[4]
      r[8] = 1
      local index = 1
      local limit = r[4]
      local step = 1
      if not ((step > 0 and index > limit) or (step <= 0 and index < limit)) then
        r[9] = index
        while true do
          r[10] = 0
          while true do
            if not (r[10] == 0) then
              continue
            end
            r[12] = string.byte(r[0], r[9])
            r[11] = r[12]
            r[13] = r[11] * r[13]
            r[12] = (r[3] * 16777619) + r[13]
            r[3] = r[12] % 4294967296
            local step = r[8]
            local index = r[6] + step
            r[6] = index
            if (step > 0 and index <= r[7]) or (step <= 0 and index >= r[7]) then
              r[9] = index
              break
            end
            r[7] = "%08X"
            r[8] = r[3]
            r[6] = string.format("%08X", r[3])
            r[5] = r[6]
            r[2] = 2
            if r[2] == 2 then
              r[6] = r[3]
              r[7] = r[5]
              r[8] = r[4]
              return r[6], r[7], r[8]
            end
          end
        end
      end
    end
    r[6] = r[3]
    r[7] = r[5]
    r[8] = r[4]
    return r[6], r[7], r[8]
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
    if r[0] < r[1] then
      r[3] = r[1]
      r[4] = "clamped_low"
      return r[3], r[4]
    else
      if r[2] < r[0] then
        r[3] = r[2]
        r[4] = "clamped_high"
        return r[3], r[4]
      else
        r[3] = r[0]
        r[4] = "exact"
        return r[3], r[4]
      end
    end
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
    r[1] = 0
    while true do
      if r[1] == 0 then
        r[2] = 0
        r[1] = 1
      end
      if not (r[1] == 1) then
        continue
      end
      while true do
        if r[2] == 1 then
          break
        end
        if not (r[2] == 0) then
          continue
        end
        r[5] = select
        r[6] = "#"
do local out = pack(r[7](r[8])); top = 7 + out.n - 1; for i = 1, out.n do r[7 + i - 1] = out[i] end end
        r[5] = r[5](unpack(r, 6, top))
        r[3] = r[5]
        r[5] = {}
        r[5].n = r[3]
        r[4] = r[5]
        r[2] = 1
        continue
      end
      r[5] = 1
      r[6] = r[3]
      r[7] = 1
      local index = 1
      local limit = r[3]
      local step = 1
      if not ((step > 0 and index > limit) or (step <= 0 and index < limit)) then
        r[8] = index
        while true do
          top = 11 - 1
          r[4][r[8]] = select(unpack(r, 10, top))
          local step = r[7]
          local index = r[5] + step
          r[5] = index
          if (step > 0 and index <= r[6]) or (step <= 0 and index >= r[6]) then
            r[8] = index
            continue
          end
          r[5] = r[4]
          r[6] = r[3]
          return r[5], r[6]
        end
      end
    end
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
    r[0] = get_upvalue(0)
    r[0] = r[0].JSONDecode
    r[2] = readfile
    r[3] = get_upvalue(1)
do local out = pack(r[2](r[3])); top = 2 + out.n - 1; for i = 1, out.n do r[2 + i - 1] = out[i] end end
    return unpack(r, 0, top)
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
    r[0] = 0
    while true do
      if r[0] == 0 then
        r[1] = 0
        r[0] = 1
      end
      if not (r[0] == 1) then
        continue
      end
      while true do
        r[4] = 0
        while true do
          if not (r[4] == 0) then
            if not (r[4] == 1) then
              continue
            end
            if not (r[1] == 2) then
              break
            end
            r[5] = true
            r[6] = "loaded"
            return r[5], r[6]
          end
          if not (r[1] == 1) then
            if r[1] == 0 then
              r[5] = isfile
              if r[5] then
                r[5] = readfile
                if r[5] then
                  r[6] = get_upvalue(1)
                  r[5] = isfile(r[6])
                  if not r[5] then
                    r[5] = false
                    r[6] = "no_file"
                    return r[5], r[6]
                  else
                    r[5] = pcall
                    r[6] = protos["0_3_0_0"](env, {
                      [0] = capture_upvalue(2),
                      [1] = capture_upvalue(1),
                    })
                    r[5], r[6] = r[5](r[6])
                    r[3] = r[6]
                    r[2] = r[5]
                    r[1] = 1
                  end
                else
                  r[5] = false
                  r[6] = "no_file"
                  return r[5], r[6]
                end
              else
                r[5] = false
                r[6] = "no_file"
                return r[5], r[6]
              end
            end
            r[4] = 1
            if r[4] == 1 then
              if not (r[1] == 2) then
                r[4] = 0
              end
              break
            end
            continue
          end
          if r[2] then
            r[6] = r[3]
            r[5] = type(r[3])
            if r[5] ~= "table" then
              r[5] = false
              r[6] = "corrupt_json"
              return r[5], r[6]
            else
              r[5] = pairs
              r[6] = r[3]
              r[5], r[6], r[7] = r[5](r[6])
              while true do
                local out = {r[5](r[6], r[7])}
                for i = 1, 2 do r[7 + i] = out[i] end
                if not (out[1]) then
                  break
                end
                  r[7] = out[1]
                r[10] = get_upvalue(0)
                r[10] = r[10][r[8]]
                if not (r[10] ~= nil) then
                  continue
                end
                r[11] = get_upvalue(0)
                r[11] = r[11][r[8]]
                r[10] = type(r[11][r[8]])
                r[11] = type(r[9])
                if not (r[10] == r[11]) then
                  continue
                end
                r[10] = get_upvalue(0)
                r[10][r[8]] = r[9]
                continue
              end
              r[1] = 2
              if not (r[1] == 0) then
                r[4] = 1
              end
            end
          else
            r[5] = false
            r[6] = "corrupt_json"
            return r[5], r[6]
          end
        end
      end
      r[5] = false
      r[6] = "corrupt_json"
      return r[5], r[6]
    end
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
    r[0] = get_upvalue(0)
    r[1] = r[0]
    r[0] = r[0].JSONEncode
    r[2] = get_upvalue(1)
    return r[0](r[1], r[2])
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
    local __pc = 0
    while true do
        if __pc == 0 then
          r[1] = 0
          for i = 2, 5 do r[i] = nil end
          __pc = 3
        end
        if __pc == 3 then
          r[6] = 0
          __pc = 4
        end
        if __pc == 4 then
          if r[6] == 0 then
            if r[1] == 1 then
              if not r[2] then
                r[7] = warn
                r[8] = "[Nebula] Encode failed: "
                r[10] = r[3]
                r[9] = tostring(r[3])
                do local value = r[8]; for i = 9, 9 do value = value .. r[i] end; r[8] = value end
                r[7](r[8])
                r[7] = false
                return r[7]
              else
                r[7] = pcall
                r[8] = writefile
                r[9] = get_upvalue(0)
                r[10] = r[3]
                r[7], r[8] = r[7](r[8])
                r[5] = r[8]
                r[4] = r[7]
                r[1] = 2
                __pc = 27
              end
            else
              __pc = 27
            end
          else
            __pc = 65
          end
        end
        if __pc == 27 then
          if r[1] == 0 then
            r[7] = writefile
            if not r[7] then
              r[7] = 0
              __pc = 34
            else
              r[7] = pcall
              r[8] = protos["0_3_1_0"](env, {
                [0] = capture_upvalue(1),
                [1] = capture_upvalue(2),
              })
              r[7], r[8] = r[7](r[8])
              r[3] = r[8]
              r[2] = r[7]
              r[1] = 1
              __pc = 64
            end
          else
            __pc = 64
          end
        end
        if __pc == 34 then
          if r[7] == 0 then
            r[8] = 0
            __pc = 37
          else
            __pc = 34
          end
        end
        if __pc == 37 then
          if r[8] == 0 then
            r[9] = 0
            __pc = 40
          else
            __pc = 37
          end
        end
        if __pc == 40 then
          if r[9] == 0 then
            r[10] = warn
            r[11] = "[Nebula] Executor missing writefile; skipped save ("
            r[12] = tostring(r[0])
            r[13] = ")"
            do local value = r[11]; for i = 12, 13 do value = value .. r[i] end; r[11] = value end
            r[10](r[11])
            r[10] = false
            return r[10]
          else
            __pc = 40
          end
        end
        if __pc == 64 then
          r[6] = 1
          __pc = 65
        end
        if __pc == 65 then
          if 1 == r[6] then
            if r[1] == 3 then
              r[7] = false
              return r[7]
            else
              if r[1] == 2 then
                if r[4] then
                  r[7] = 0
                  __pc = 77
                else
                  r[7] = warn
                  r[8] = "[Nebula] Save failed: "
                  r[10] = r[5]
                  r[9] = tostring(r[5])
                  do local value = r[8]; for i = 9, 9 do value = value .. r[i] end; r[8] = value end
                  r[7](r[8])
                  r[1] = 3
                  __pc = 3
                end
              else
                __pc = 3
              end
            end
          else
            __pc = 4
          end
        end
        if __pc == 77 then
          if r[7] == 1 then
            set_upvalue(3, 0)
            r[11] = true
            return r[11]
          else
            if 0 == r[7] then
              r[11] = get_upvalue(4)
              r[12] = r[3]
              r[13] = get_upvalue(3)
              r[13] = r[13] + 17
              r[11], r[12], r[13] = r[11](r[12])
              r[10] = r[13]
              r[9] = r[12]
              r[8] = r[11]
              r[11] = get_upvalue(5)
              r[12] = get_upvalue(5)
              r[12] = #r[12]
              r[12] = (#r[12]) + 1
              r[13] = {}
              r[13].tag = r[9]
              r[13].bytes = r[10]
              if r[0] then
                r[14] = r[0]
                __pc = 103
              else
                r[14] = "manual"
                __pc = 103
              end
            else
              __pc = 77
            end
          end
        end
        if __pc == 103 then
          r[13].reason = r[14]
          r[11][r[12]] = r[13]
          r[7] = 1
          __pc = 77
        end
    end
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
    r[3] = 0
    while true do
      if not (r[3] == 0) then
        continue
      end
      r[4] = 0
      while true do
        r[5] = 0
        while true do
          if not (r[5] == 0) then
            if not (r[5] == 1) then
              continue
            end
            if not (r[4] == 1) then
              break
            end
            r[6] = get_upvalue(1)
            r[6] = r[6] + 1
            set_upvalue(1, r[6] + 1)
            if r[2] then
              r[6] = get_upvalue(2)
              r[7] = "set:"
              r[8] = tostring(r[0])
              do local value = r[7]; for i = 8, 8 do value = value .. r[i] end; r[7] = value end
              r[6](r[7])
            end
            r[4] = 2
            break
          end
          if 2 == r[4] then
            r[6] = true
            r[7] = r[1]
            return r[6], r[7]
          else
            if r[4] == 0 then
              r[6] = get_upvalue(0)
              r[6] = r[6][r[0]]
              if r[6] == r[1] then
                r[6] = false
                r[7] = get_upvalue(0)
                r[7] = r[7][r[0]]
                return r[6], r[7]
              else
                r[6] = get_upvalue(0)
                r[6][r[0]] = r[1]
                r[4] = 1
              end
            end
            r[5] = 1
            if r[5] == 1 then
              if r[4] == 1 then
                r[6] = get_upvalue(1)
              end
              break
            end
            continue
          end
        end
      end
      r[6] = true
      r[7] = r[1]
      return r[6], r[7]
    end
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
    r[1] = get_upvalue(0)
    r[1] = r[1][r[0]]
    r[2] = get_upvalue(1)
    return r[1], r[2]
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
    r[1] = 0
    while true do
      if r[1] == 3 then
        break
      end
      if r[1] == 1 then
        r[5] = protos["0_3_0"](env, {
          [0] = capture_register(2),
          [1] = capture_upvalue(0),
          [2] = capture_upvalue(1),
        })
        r[6] = protos["0_3_1"](env, {
          [0] = capture_upvalue(0),
          [1] = capture_upvalue(1),
          [2] = capture_register(2),
          [3] = capture_register(3),
          [4] = capture_upvalue(2),
          [5] = capture_register(4),
        })
        r[1] = 2
      end
      if 0 == r[1] then
        r[9] = {}
        r[2] = r[9]
        r[9] = {}
        r[4] = r[9]
        r[9] = pairs
        r[10] = r[0]
        r[9], r[10], r[11] = r[9](r[10])
        while true do
          local out = {r[9](r[10], r[11])}
          for i = 1, 2 do r[11 + i] = out[i] end
          if not (out[1]) then
            break
          end
            r[11] = out[1]
          r[15] = r[13]
          r[14] = type(r[13])
          if r[14] == "table" then
            r[14] = {}
            r[15] = pairs
            r[16] = r[13]
            r[15], r[16], r[17] = r[15](r[16])
            while true do
              local out = {r[15](r[16], r[17])}
              for i = 1, 2 do r[17 + i] = out[i] end
              if not (out[1]) then
                break
              end
                r[17] = out[1]
              r[14][r[18]] = r[19]
              continue
            end
            r[2][r[12]] = r[14]
            continue
          else
            r[2][r[12]] = r[13]
            continue
          end
        end
        r[1] = 1
      end
      if not (2 == r[1]) then
        continue
      end
      r[7] = protos["0_3_2"](env, {
        [0] = capture_register(2),
        [1] = capture_register(3),
        [2] = capture_register(6),
      })
      r[8] = protos["0_3_3"](env, {
        [0] = capture_register(2),
        [1] = capture_register(3),
      })
      r[1] = 3
      continue
    end
    r[9] = {}
    r[9].load = r[5]
    r[9].save = r[6]
    r[9].set = r[7]
    r[9].get = r[8]
    r[9].raw = r[2]
    r[9].history = r[4]
    return r[9]
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
    r[2] = 0
    while true do
      if r[2] == 3 then
        break
      end
      if 1 == r[2] then
        if r[1] then
          r[4] = r[1]
        else
          r[4] = 8.5
        end
        r[3].maxBudgetMs = r[4]
        r[4] = {}
        r[3].jobs = r[4]
        r[2] = 2
      end
      if r[2] == 2 then
        r[3].totalTicks = 0
        r[3].running = false
        r[2] = 3
      end
      if not (0 == r[2]) then
        continue
      end
      r[5] = {}
      r[4] = setmetatable(r[5], get_upvalue(0))
      r[3] = r[4]
      if r[0] then
        r[4] = r[0]
      else
        r[4] = "MainScheduler"
      end
      r[3].label = r[4]
      r[2] = 1
      continue
    end
    r[3].connection = nil
    return r[3]
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
    r[4] = 0
    while true do
      r[6] = 0
      while true do
        if not (r[6] == 0) then
          continue
        end
        if r[4] == 0 then
          r[7] = 0
          while true do
            if r[7] == 0 then
              r[8] = {}
              r[8].name = r[1]
              r[9] = math.max
              if r[2] then
                r[10] = r[2]
              else
                r[10] = 0.1
              end
              r[9] = r[9](r[10], 0.01)
              r[8].interval = r[9]
              r[8].elapsed = 0
              r[8].runs = 0
              r[8].active = true
              r[8].fn = r[3]
              r[5] = r[8]
              r[8] = r[0].jobs
              r[9] = (#r[0].jobs) + 1
              r[8][r[9]] = r[5]
              r[7] = 1
            end
            if not (r[7] == 1) then
              continue
            end
            r[4] = 1
            if r[4] == 1 then
              return r[5]
            end
          end
        end
        if not (r[4] == 1) then
          break
        end
        return r[5]
      end
    end
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
    r[1] = 0
    while true do
      r[3] = 0
      while true do
        if not (r[3] == 0) then
          continue
        end
        if r[1] == 0 then
          r[2] = 0
          r[4] = #r[0].jobs
          r[5] = 1
          r[6] = -1
          local index = #r[0].jobs
          local limit = 1
          local step = -1
          if not ((step > 0 and index > limit) or (step <= 0 and index < limit)) then
            r[7] = index
            while true do
              r[8] = 0
              while true do
                if not (0 == r[8]) then
                  continue
                end
                r[10] = r[0].jobs[r[7]].active
                if not r[10] then
                  r[10] = 0
                  while true do
                    if not (0 == r[10]) then
                      continue
                    end
                    r[11] = 0
                    while true do
                      if not (r[11] == 0) then
                        continue
                      end
                      table.remove(r[0].jobs, r[7])
                      r[2] = r[2] + 1
                      local step = r[6]
                      local index = r[4] + step
                      r[4] = index
                      if not ((step > 0 and index <= r[5]) or (step <= 0 and index >= r[5])) then
                        r[1] = 1
                      end
                    end
                  end
                end
                local step = r[6]
                local index = r[4] + step
                r[4] = index
                if (step > 0 and index <= r[5]) or (step <= 0 and index >= r[5]) then
                  r[7] = index
                  break
                end
                r[1] = 1
                if r[1] == 1 then
                  return r[2]
                end
              end
            end
          end
        end
        if not (r[1] == 1) then
          break
        end
        return r[2]
      end
    end
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
    local __pc = 0
    while true do
        if __pc == 0 then
          r[2] = 0
          for i = 3, 3 do r[i] = nil end
          __pc = 3
        end
        if __pc == 3 then
          r[4] = 0
          __pc = 4
        end
        if __pc == 4 then
          if r[4] == 1 then
            if r[2] == 2 then
              return r[3]
            else
              __pc = 3
            end
          else
            if r[4] == 0 then
              if r[2] == 1 then
                r[5] = ipairs
                r[6] = r[0].jobs
                r[5], r[6], r[7] = r[5](r[6])
                __pc = 73
              else
                __pc = 82
              end
            else
              __pc = 4
            end
          end
        end
        if __pc == 18 then
          r[10] = r[9].active
          if r[10] then
            r[10] = 0
            __pc = 23
          else
            __pc = 73
          end
        end
        if __pc == 23 then
          if r[10] == 0 then
            r[11] = 0
            __pc = 26
          else
            __pc = 23
          end
        end
        if __pc == 26 then
          if r[11] == 0 then
            r[12] = (r[9].elapsed) + r[1]
            r[9].elapsed = r[12]
            r[12] = r[9].elapsed
            r[13] = r[9].interval
            if r[13] <= r[12] then
              r[9].elapsed = 0
              r[12] = (r[9].runs) + 1
              r[9].runs = r[12]
              r[12] = pcall
              r[13] = r[9].fn
              r[14] = r[9].runs
              r[15] = r[1]
              r[16] = r[0].totalTicks
              r[12], r[13] = r[12](r[13])
              r[3] = r[3] + 1
              if not r[12] then
                r[14] = 0
                __pc = 49
              else
                if r[13] == false then
                  r[9].active = false
                  __pc = 73
                else
                  __pc = 73
                end
              end
            else
              __pc = 73
            end
          else
            __pc = 26
          end
        end
        if __pc == 49 then
          if r[14] == 0 then
            r[15] = warn
            r[16] = string.format
            r[17] = "[Nebula:%s] Job '%s' error: %s"
            r[20] = tostring
            r[21] = r[13]
do local out = pack(r[20](r[21])); top = 20 + out.n - 1; for i = 1, out.n do r[20 + i - 1] = out[i] end end
r[15](r[16](r[17]))
            r[9].active = false
            __pc = 73
          else
            __pc = 49
          end
        end
        if __pc == 73 then
          local out = {r[5](r[6], r[7])}
          for i = 1, 2 do r[7 + i] = out[i] end
          if out[1] then
            r[7] = out[1]
            __pc = 18
          else
            r[5] = (r[0].totalTicks) % 30
            if r[5] == 0 then
              r[6] = r[0]
              r[5] = r[0].pruneInactive
              r[0]:pruneInactive()
              __pc = 81
            else
              __pc = 81
            end
          end
        end
        if __pc == 81 then
          r[2] = 2
          __pc = 82
        end
        if __pc == 82 then
          if r[2] == 0 then
            r[5] = (r[0].totalTicks) + 1
            r[0].totalTicks = r[5]
            r[3] = 0
            r[2] = 1
            __pc = 89
          else
            __pc = 89
          end
        end
        if __pc == 89 then
          r[4] = 1
          __pc = 4
        end
    end
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
    r[1] = 0
    while true do
      if not (r[1] == 0) then
        continue
      end
      r[2] = get_upvalue(0)
      r[2] = r[2].running
      if not r[2] then
        return
      else
        r[2] = get_upvalue(0)
        r[3] = r[2]
        r[2] = r[2].step
        r[2].step(r[3], r[0])
        return
      end
    end
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
    r[1] = 0
    while true do
      if not (0 == r[1]) then
        continue
      end
      r[2] = 0
      while true do
        if not (r[2] == 0) then
          if not (r[2] == 1) then
            continue
          end
          r[3] = get_upvalue(0)
          r[3] = r[3].Heartbeat
          r[4] = r[3].Heartbeat
          r[3] = r[3].Heartbeat.Connect
          r[5] = protos["0_8_0"](env, {
            [0] = capture_register(0),
          })
          r[3] = r[3](r[4], r[5])
          r[0].connection = r[3]
          return
        end
        r[3] = r[0].running
        if r[3] then
          break
        end
        r[0].running = true
        r[2] = 1
        if not (r[2] == 1) then
          if r[2] == 0 then
            r[3] = r[0].running
          end
        end
        break
      end
      return
    end
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
    r[1] = 0
    while true do
      if not (0 == r[1]) then
        continue
      end
      r[0].running = false
      r[2] = r[0].connection
      if r[2] then
        r[2] = 0
        while true do
          if not (r[2] == 0) then
            continue
          end
          r[0].connection:Disconnect()
          r[0].connection = nil
          return
        end
      end
      return
    end
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
    local __pc = 0
    while true do
        if __pc == 0 then
          r[3] = 0
          __pc = 3
        end
        if __pc == 3 then
          if 0 == r[3] then
            r[6] = get_upvalue(0)
            r[4] = r[6][r[0]]
            if r[4] then
              r[7] = r[2]
              r[6] = type(r[2])
              if r[6] ~= "table" then
                __pc = 14
              else
                r[3] = 1
                __pc = 17
              end
            else
              __pc = 14
            end
          else
            __pc = 17
          end
        end
        if __pc == 14 then
          r[6] = 0
          return r[6]
        end
        if __pc == 17 then
          if 1 == r[3] then
            r[5] = 0
            r[6] = pairs
            r[7] = r[2]
            r[6], r[7], r[8] = r[6](r[7])
            __pc = 110
          else
            __pc = 113
          end
        end
        if __pc == 24 then
          r[11] = r[4].skipLocked
          if r[11] then
            r[12] = r[10]
            r[11] = type(r[10])
            if r[11] == "table" then
              r[11] = r[10].Locked
              if r[11] ~= true then
                __pc = 35
              else
                __pc = 36
              end
            else
              __pc = 35
            end
          else
            __pc = 37
          end
        end
        if __pc == 35 then
          r[11] = false
          __pc = 36
        end
        if __pc == 36 then
          r[11] = true
          __pc = 37
        end
        if __pc == 37 then
          r[13] = r[10]
          r[12] = type(r[10])
          if r[12] == "table" then
            if not r[11] then
              r[12] = pairs
              r[13] = r[4].overrides
              r[12], r[13], r[14] = r[12](r[13])
              __pc = 108
            else
              __pc = 110
            end
          else
            __pc = 110
          end
        end
        if __pc == 48 then
          if r[1] then
            r[17] = r[10][r[15]]
            if r[17] ~= nil then
              r[17] = 0
              __pc = 54
            else
              __pc = 108
            end
          else
            r[17] = 0
            __pc = 82
          end
        end
        if __pc == 54 then
          if r[17] == 1 then
            r[10][r[15]] = r[16]
            r[5] = r[5] + 1
            __pc = 108
          else
            if r[17] == 0 then
              r[18] = get_upvalue(1)
              r[19] = get_upvalue(1)
              r[19] = r[19][r[9]]
              if not r[19] then
                r[19] = {}
                __pc = 67
              else
                __pc = 67
              end
            else
              __pc = 54
            end
          end
        end
        if __pc == 67 then
          r[18][r[9]] = r[19]
          r[18] = get_upvalue(1)
          r[18] = r[18][r[9]]
          r[18] = r[18][r[9]][r[15]]
          if r[18] == nil then
            r[18] = get_upvalue(1)
            r[18] = r[18][r[9]]
            r[19] = r[10][r[15]]
            r[18][r[15]] = r[10][r[15]]
            __pc = 77
          else
            __pc = 77
          end
        end
        if __pc == 77 then
          r[17] = 1
          __pc = 54
        end
        if __pc == 82 then
          if r[17] == 0 then
            r[19] = get_upvalue(1)
            r[19] = r[19][r[9]]
            if r[19] then
              r[19] = get_upvalue(1)
              r[19] = r[19][r[9]]
              r[18] = r[19][r[9]][r[15]]
              __pc = 91
            else
              r[18] = r[19]
              __pc = 91
            end
          else
            __pc = 82
          end
        end
        if __pc == 91 then
          if r[18] ~= nil then
            r[19] = 0
            __pc = 95
          else
            __pc = 108
          end
        end
        if __pc == 95 then
          if r[19] == 0 then
            r[20] = 0
            __pc = 98
          else
            __pc = 95
          end
        end
        if __pc == 98 then
          if r[20] == 0 then
            r[10][r[15]] = r[18]
            r[5] = r[5] + 1
            __pc = 108
          else
            __pc = 98
          end
        end
        if __pc == 108 then
          local out = {r[12](r[13], r[14])}
          for i = 1, 2 do r[14 + i] = out[i] end
          if out[1] then
            r[14] = out[1]
            __pc = 48
          else
            __pc = 110
          end
        end
        if __pc == 110 then
          local out = {r[6](r[7], r[8])}
          for i = 1, 2 do r[8 + i] = out[i] end
          if out[1] then
            r[8] = out[1]
            __pc = 24
          else
            r[3] = 2
            __pc = 113
          end
        end
        if __pc == 113 then
          if r[3] == 2 then
            return r[5]
          else
            __pc = 3
          end
        end
    end
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
    local __pc = 0
    while true do
        if __pc == 0 then
          r[2] = 0
          for i = 3, 7 do r[i] = nil end
          __pc = 3
        end
        if __pc == 3 then
          if r[2] == 0 then
            r[3] = 0
            for i = 4, 4 do r[i] = nil end
            r[2] = 1
            __pc = 8
          else
            __pc = 8
          end
        end
        if __pc == 8 then
          if r[2] == 2 then
            __pc = 11
          else
            if r[2] == 1 then
              r[2] = 2
              __pc = 3
            else
              __pc = 3
            end
          end
        end
        if __pc == 11 then
          r[8] = 0
          __pc = 12
        end
        if __pc == 12 then
          if r[8] == 2 then
            if r[3] == 3 then
              r[9] = 0
              __pc = 17
            else
              __pc = 11
            end
          else
            if r[8] == 0 then
              if r[3] == 2 then
                r[9] = r[4]:FindFirstChildOfClass("Humanoid")
                r[5] = r[9]
                r[10] = r[4]
                r[11] = "HumanoidRootPart"
                r[9] = r[4]:FindFirstChild("HumanoidRootPart")
                r[6] = r[9]
                r[3] = 3
                __pc = 55
              else
                __pc = 55
              end
            else
              __pc = 73
            end
          end
        end
        if __pc == 17 then
          if r[9] == 1 then
            r[3] = 4
            __pc = 11
          else
            if r[9] == 0 then
              r[11] = r[4]
              r[10] = r[4]:FindFirstChild("Head")
              r[7] = r[10]
              if r[5] then
                if r[6] then
                  if r[7] then
                    r[10] = r[5].Health
                    if 0 < r[10] then
                      r[9] = 1
                      __pc = 17
                    else
                      __pc = 36
                    end
                  else
                    __pc = 36
                  end
                else
                  __pc = 36
                end
              else
                __pc = 36
              end
            else
              __pc = 17
            end
          end
        end
        if __pc == 36 then
          r[10] = false
          r[11] = "dead_or_incomplete"
          return r[10], r[11]
        end
        if __pc == 55 then
          if r[3] == 1 then
            r[9] = 0
            __pc = 58
          else
            __pc = 72
          end
        end
        if __pc == 58 then
          if r[9] == 0 then
            r[4] = r[0].Character
            if not r[4] then
              r[10] = false
              r[11] = "no_char"
              return r[10], r[11]
            else
              r[9] = 1
              __pc = 67
            end
          else
            __pc = 67
          end
        end
        if __pc == 67 then
          if r[9] == 1 then
            r[3] = 2
            __pc = 72
          else
            __pc = 58
          end
        end
        if __pc == 72 then
          r[8] = 1
          __pc = 73
        end
        if __pc == 73 then
          if r[8] == 1 then
            if r[3] == 4 then
              r[9] = true
              r[10] = r[6]
              return r[9], r[10]
            else
              if r[3] == 0 then
                if r[0] then
                  r[9] = get_upvalue(0)
                  if r[0] == r[9] then
                    __pc = 87
                  else
                    if not r[1] then
                      r[9] = get_upvalue(0)
                      r[9] = r[9].Team
                      if r[9] then
                        r[9] = r[0].Team
                        r[10] = get_upvalue(0)
                        r[10] = r[10].Team
                        if r[9] == r[10] then
                          r[9] = false
                          r[10] = "teammate"
                          return r[9], r[10]
                        else
                          __pc = 104
                        end
                      else
                        __pc = 104
                      end
                    else
                      __pc = 104
                    end
                  end
                else
                  __pc = 87
                end
              else
                __pc = 105
              end
            end
          else
            __pc = 12
          end
        end
        if __pc == 87 then
          r[9] = false
          r[10] = "self_or_nil"
          return r[9], r[10]
        end
        if __pc == 104 then
          r[3] = 1
          __pc = 105
        end
        if __pc == 105 then
          r[8] = 2
          __pc = 12
        end
    end
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
    local __pc = 0
    while true do
        if __pc == 0 then
          r[2] = 0
          for i = 3, 7 do r[i] = nil end
          __pc = 3
        end
        if __pc == 3 then
          if 2 == r[2] then
            __pc = 6
          else
            if r[2] == 0 then
              r[3] = 0
              r[2] = 1
              __pc = 126
            else
              __pc = 126
            end
          end
        end
        if __pc == 6 then
          if r[3] == 2 then
            r[8] = 0
            __pc = 9
          else
            __pc = 82
          end
        end
        if __pc == 9 then
          if r[8] == 0 then
            if r[0] then
              r[7] = r[0]
              __pc = 14
            else
              r[7] = 250
              __pc = 14
            end
          else
            __pc = 77
          end
        end
        if __pc == 14 then
          r[9] = ipairs
          r[10] = get_upvalue(0)
          r[11] = r[10]
          r[10] = r[10].GetPlayers
          r[9], r[10], r[11] = r[9](r[10](r[11]))
          __pc = 74
        end
        if __pc == 20 then
          r[14] = 0
          __pc = 22
        end
        if __pc == 22 then
          if r[14] == 0 then
            r[17] = get_upvalue(1)
            r[18] = r[13]
            r[19] = r[1]
            r[17], r[18] = r[17](r[18])
            r[16] = r[18]
            r[15] = r[17]
            if r[15] then
              r[17] = 0
              __pc = 34
            else
              __pc = 74
            end
          else
            __pc = 22
          end
        end
        if __pc == 34 then
          if r[17] == 0 then
            r[18] = 0
            r[17] = 1
            __pc = 39
          else
            __pc = 39
          end
        end
        if __pc == 39 then
          if r[17] == 1 then
            __pc = 42
          else
            __pc = 34
          end
        end
        if __pc == 42 then
          if r[18] == 0 then
            r[21] = 0
            __pc = 45
          else
            __pc = 57
          end
        end
        if __pc == 45 then
          if r[21] == 1 then
            r[18] = 1
            __pc = 57
          else
            if 0 == r[21] then
              r[23] = r[5].Position
              r[20] = (r[16].Position) - r[23].Magnitude
              r[21] = 1
              __pc = 45
            else
              __pc = 45
            end
          end
        end
        if __pc == 57 then
          if r[18] == 1 then
            if r[20] < r[7] then
              r[21] = 0
              __pc = 62
            else
              __pc = 74
            end
          else
            __pc = 42
          end
        end
        if __pc == 62 then
          if r[21] == 0 then
            r[7] = r[20]
            r[6] = r[13]
            __pc = 74
          else
            __pc = 62
          end
        end
        if __pc == 74 then
          local out = {r[9](r[10], r[11])}
          for i = 1, 2 do r[11 + i] = out[i] end
          if out[1] then
            r[11] = out[1]
            __pc = 20
          else
            r[8] = 1
            __pc = 77
          end
        end
        if __pc == 77 then
          if 1 == r[8] then
            r[3] = 3
            __pc = 82
          else
            __pc = 9
          end
        end
        if __pc == 82 then
          if r[3] == 0 then
            r[8] = 0
            __pc = 85
          else
            __pc = 104
          end
        end
        if __pc == 85 then
          if r[8] == 1 then
            r[3] = 1
            __pc = 104
          else
            if r[8] == 0 then
              r[9] = get_upvalue(2)
              if r[9] then
                r[9] = get_upvalue(2)
                r[4] = r[9].Character
                __pc = 96
              else
                r[4] = r[9]
                __pc = 96
              end
            else
              __pc = 85
            end
          end
        end
        if __pc == 96 then
          if r[4] then
            r[10] = r[4]
            r[11] = "HumanoidRootPart"
            r[9] = r[4]:FindFirstChild("HumanoidRootPart")
            r[5] = r[9]
            __pc = 102
          else
            r[5] = r[4]
            __pc = 102
          end
        end
        if __pc == 102 then
          r[8] = 1
          __pc = 85
        end
        if __pc == 104 then
          if 1 == r[3] then
            if not r[5] then
              for i = 8, 8 do r[i] = nil end
              r[9] = math.huge
              return r[8], r[9]
            else
              for i = 6, 6 do r[i] = nil end
              r[3] = 2
              __pc = 114
            end
          else
            __pc = 114
          end
        end
        if __pc == 114 then
          if r[3] == 3 then
            r[8] = r[6]
            r[9] = r[7]
            return r[8], r[9]
          else
            __pc = 6
          end
        end
        if __pc == 126 then
          if 1 == r[2] then
            r[2] = 2
            __pc = 3
          else
            __pc = 3
          end
        end
    end
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
    r[0] = 0
    while true do
      if not (r[0] == 0) then
        continue
      end
      r[1] = 0
      while true do
        if not (r[1] == 0) then
          continue
        end
        r[2] = 0
        while true do
          if not (r[2] == 0) then
            continue
          end
          r[3] = get_upvalue(0)
          if r[3] == 0 then
            r[3] = get_upvalue(1)
            return r[3]()
          else
            r[3] = get_upvalue(0)
            if r[3] == 1 then
              r[3] = get_upvalue(1)
              r[4] = get_upvalue(2)
              r[4] = r[4][1]
              return r[3](r[4])
            else
              r[3] = get_upvalue(0)
              if r[3] == 2 then
                r[3] = get_upvalue(1)
                r[4] = get_upvalue(2)
                r[4] = r[4][1]
                r[5] = get_upvalue(2)
                r[5] = r[5][2]
                return r[3](r[4], r[5])
              else
                r[3] = get_upvalue(1)
                r[4] = unpack
                r[5] = get_upvalue(2)
                r[6] = 1
                r[7] = get_upvalue(0)
do local out = pack(r[4](r[5], r[6], r[7])); top = 4 + out.n - 1; for i = 1, out.n do r[4 + i - 1] = out[i] end end
                return unpack(r, 3, top)
              end
            end
          end
        end
      end
    end
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
    local __pc = 0
    while true do
        if __pc == 0 then
          r[4] = 0
          for i = 5, 9 do r[i] = nil end
          __pc = 3
        end
        if __pc == 3 then
          r[10] = 0
          __pc = 4
        end
        if __pc == 4 then
          if 0 == r[10] then
            if r[4] == 3 then
              r[11] = false
              r[12] = r[9]
              r[13] = r[7]
              return r[11], r[12], r[13]
            else
              if r[4] == 0 then
                r[11] = 0
                __pc = 15
              else
                __pc = 29
              end
            end
          else
            __pc = 30
          end
        end
        if __pc == 15 then
          if r[11] == 1 then
            r[4] = 1
            __pc = 29
          else
            if r[11] == 0 then
              r[12] = get_upvalue(0)
              r[12], r[13] = r[12](r[13](r[14]))
              r[7] = 0
              r[11] = 1
              __pc = 15
            else
              __pc = 15
            end
          end
        end
        if __pc == 29 then
          r[10] = 1
          __pc = 30
        end
        if __pc == 30 then
          if r[10] == 1 then
            if r[4] == 2 then
              __pc = 34
            else
              __pc = 103
            end
          else
            __pc = 4
          end
        end
        if __pc == 34 then
          r[11] = 0
          __pc = 36
        end
        if __pc == 36 then
          if 1 == r[11] then
            __pc = 39
          else
            if r[11] == 0 then
              r[12] = 0
              r[11] = 1
              __pc = 36
            else
              __pc = 36
            end
          end
        end
        if __pc == 39 then
          if r[12] == 0 then
            r[7] = r[7] + 1
            r[15] = pcall
            r[16] = protos["0_13_0"](env, {
              [0] = capture_register(6),
              [1] = capture_register(2),
              [2] = capture_register(5),
            })
            r[15], r[16] = r[15](r[16])
            r[14] = r[16]
            r[13] = r[15]
            r[12] = 1
            __pc = 51
          else
            __pc = 51
          end
        end
        if __pc == 51 then
          if r[12] == 1 then
            if r[13] then
              r[15] = true
              r[16] = r[14]
              r[17] = r[7]
              return r[15], r[16], r[17]
            else
              r[9] = r[14]
              r[12] = 2
              __pc = 61
            end
          else
            __pc = 61
          end
        end
        if __pc == 61 then
          if r[12] == 2 then
            r[15] = get_upvalue(1)
            r[16] = r[8] * 1.5
            r[17] = 0.05
            r[15] = r[15](r[8] * 1.5, 0.05, 0.5)
            r[8] = r[15]
            r[15] = task
            if r[15] then
              r[15] = task.wait
              if r[15] then
                r[15] = task.wait
                r[16] = r[8]
                task.wait(r[8])
                __pc = 89
              else
                __pc = 89
              end
            else
              __pc = 89
            end
          else
            __pc = 39
          end
        end
        if __pc == 89 then
          if r[1] <= r[7] then
            r[11] = warn
            r[12] = string.format
            r[13] = "[Nebula] '%s' failed after %d attempts: %s"
            r[14] = r[0]
            r[15] = r[7]
            r[16] = tostring
            r[17] = r[9]
do local out = pack(r[16](r[17])); top = 16 + out.n - 1; for i = 1, out.n do r[16 + i - 1] = out[i] end end
r[11](r[12](r[13]))
            r[4] = 3
            __pc = 103
          else
            __pc = 34
          end
        end
        if __pc == 103 then
          if r[4] == 1 then
            r[8] = 0.05
            r[4] = 2
            __pc = 3
          else
            __pc = 3
          end
        end
    end
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
    r[3] = 0
    while true do
      if r[3] == 0 then
        r[6] = r[0]
        r[5] = Instance.new(r[0])
        r[4] = r[5]
        r[5] = pairs
        if r[1] then
          r[6] = r[1]
        else
          r[6] = {}
        end
        r[5], r[6], r[7] = r[5](r[6])
        while true do
          local out = {r[5](r[6], r[7])}
          for i = 1, 2 do r[7 + i] = out[i] end
          if not (out[1]) then
            break
          end
            r[7] = out[1]
          r[4][r[8]] = r[9]
          continue
        end
        r[3] = 1
      end
      if not (r[3] == 1) then
        continue
      end
      if r[2] then
        r[5] = next
        r[6] = r[2]
        for i = 7, 7 do r[i] = nil end
        while true do
          local out = {r[5](r[6], r[7])}
          for i = 1, 2 do r[7 + i] = out[i] end
          if not (out[1]) then
            break
          end
            r[7] = out[1]
          r[9].Parent = r[4]
          continue
        end
      end
      return r[4]
    end
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
    local __pc = 0
    while true do
        if __pc == 0 then
          r[2] = 0
          for i = 3, 7 do r[i] = nil end
          __pc = 3
        end
        if __pc == 3 then
          r[8] = 0
          __pc = 4
        end
        if __pc == 4 then
          if r[8] == 2 then
            if r[2] == 3 then
              if not r[6] then
                r[9] = 0
                __pc = 12
              else
                __pc = 45
              end
            else
              __pc = 3
            end
          else
            if r[8] == 0 then
              if r[2] == 0 then
                r[9] = get_upvalue(1)
                r[9] = r[9].get
                r[10] = "autoOrbit"
                r[9] = r[9].get("autoOrbit")
                r[3] = r[9]
                if not r[3] then
                  r[9] = 0
                  __pc = 102
                else
                  r[2] = 1
                  __pc = 119
                end
              else
                __pc = 119
              end
            else
              __pc = 138
            end
          end
        end
        if __pc == 12 then
          if r[9] == 0 then
            r[11] = get_upvalue(0)
            r[12] = get_upvalue(1)
            r[12] = r[12].get
            r[12] = r[12].get("scanRadius")
            r[11] = r[11](r[12], 25, 500)
            r[10] = r[11]
            r[11] = get_upvalue(3)
            r[12] = r[10]
            r[13] = get_upvalue(1)
            r[13] = r[13].get
            r[14] = "allowTeam"
do local out = pack(r[13](r[14])); top = 13 + out.n - 1; for i = 1, out.n do r[13 + i - 1] = out[i] end end
            r[11] = r[11](r[12](r[13]))
            set_upvalue(2, r[11])
            r[9] = 1
            __pc = 32
          else
            __pc = 32
          end
        end
        if __pc == 32 then
          if 1 == r[9] then
            r[11] = get_upvalue(4)
            r[12] = get_upvalue(2)
            r[13] = get_upvalue(1)
            r[13] = r[13].get
            r[14] = "allowTeam"
do local out = pack(r[13](r[14])); top = 13 + out.n - 1; for i = 1, out.n do r[13 + i - 1] = out[i] end end
            r[11], r[12] = r[11](r[12](r[13]))
            r[7] = r[12]
            r[6] = r[11]
            __pc = 45
          else
            __pc = 12
          end
        end
        if __pc == 45 then
          if r[6] then
            if r[7] then
              r[9] = 0
              __pc = 50
            else
              __pc = 87
            end
          else
            __pc = 87
          end
        end
        if __pc == 50 then
          if r[9] == 1 then
            r[10] = Vector3.zero
            r[5].AssemblyLinearVelocity = Vector3.zero
            __pc = 87
          else
            if r[9] == 0 then
              r[10] = get_upvalue(5)
              r[10] = r[10] + r[11]
              r[11] = (math.pi) * 2
              r[10] = (r[10] + r[11]) % r[11]
              set_upvalue(5, r[10])
              r[10] = CFrame.new(r[7].Position)
              r[13] = get_upvalue(5)
              r[11] = CFrame.Angles(0, r[13], 0)
              r[10] = r[10] * r[11]
              r[12] = 0
              r[13] = 2.5
              r[14] = 6
              r[11] = CFrame.new(0, 2.5, 6)
              r[10] = (r[10] * r[11]) * r[11]
              r[5].CFrame = r[10]
              r[9] = 1
              __pc = 50
            else
              __pc = 50
            end
          end
        end
        if __pc == 87 then
          r[2] = 4
          __pc = 3
        end
        if __pc == 102 then
          if r[9] == 0 then
            r[10] = 0
            __pc = 105
          else
            __pc = 102
          end
        end
        if __pc == 105 then
          if r[10] == 0 then
            r[11] = 0
            __pc = 108
          else
            __pc = 105
          end
        end
        if __pc == 108 then
          if r[11] == 0 then
            for i = 12, 12 do r[i] = nil end
            set_upvalue(2, r[12])
            r[12] = true
            return r[12]
          else
            __pc = 108
          end
        end
        if __pc == 119 then
          if r[2] == 4 then
            r[9] = 0
            __pc = 122
          else
            r[8] = 1
            __pc = 138
          end
        end
        if __pc == 122 then
          if 0 == r[9] then
            r[10] = r[0] % 600
            if r[10] == 0 then
              r[10] = print
              r[11] = string.format
              r[12] = "[Nebula] Orbit heartbeat #%d active"
              r[13] = r[0]
r[10](r[11](r[12], r[13]))
              __pc = 134
            else
              __pc = 134
            end
          else
            __pc = 122
          end
        end
        if __pc == 134 then
          r[10] = true
          return r[10]
        end
        if __pc == 138 then
          if r[8] == 1 then
            if r[2] == 1 then
              r[9] = 0
              __pc = 143
            else
              __pc = 162
            end
          else
            __pc = 4
          end
        end
        if __pc == 143 then
          if r[9] == 0 then
            r[10] = get_upvalue(6)
            if r[10] then
              r[10] = get_upvalue(6)
              r[4] = r[10].Character
              __pc = 150
            else
              r[4] = r[10]
              __pc = 150
            end
          else
            __pc = 157
          end
        end
        if __pc == 150 then
          if r[4] then
            r[11] = r[4]
            r[12] = "HumanoidRootPart"
            r[10] = r[4]:FindFirstChild("HumanoidRootPart")
            r[5] = r[10]
            __pc = 156
          else
            r[5] = r[4]
            __pc = 156
          end
        end
        if __pc == 156 then
          r[9] = 1
          __pc = 157
        end
        if __pc == 157 then
          if 1 == r[9] then
            r[2] = 2
            __pc = 162
          else
            __pc = 143
          end
        end
        if __pc == 162 then
          if r[2] == 2 then
            if not r[5] then
              r[9] = true
              return r[9]
            else
              r[9] = get_upvalue(4)
              r[10] = get_upvalue(2)
              r[11] = get_upvalue(1)
              r[11] = r[11].get
              r[12] = "allowTeam"
do local out = pack(r[11](r[12])); top = 11 + out.n - 1; for i = 1, out.n do r[11 + i - 1] = out[i] end end
              r[9], r[10] = r[9](r[10](r[11]))
              r[7] = r[10]
              r[6] = r[9]
              r[2] = 3
              __pc = 178
            end
          else
            __pc = 178
          end
        end
        if __pc == 178 then
          r[8] = 2
          __pc = 4
        end
    end
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
    local __pc = 0
    while true do
        if __pc == 0 then
          r[0] = 0
          __pc = 3
        end
        if __pc == 3 then
          if r[0] == 0 then
            r[2] = get_upvalue(0)
            r[3] = r[2]
            r[2] = r[2].FindFirstChild
            r[4] = "Modules"
            r[2] = r[2].FindFirstChild(r[3], "Modules")
            if r[2] then
              r[2] = get_upvalue(0)
              r[2] = r[2].Modules
              r[3] = r[2].Modules
              r[2] = r[2].Modules.FindFirstChild
              r[4] = "WeaponRegistry"
              r[2] = r[2].Modules.FindFirstChild(r[3], "WeaponRegistry")
              r[1] = r[2]
              __pc = 17
            else
              r[1] = r[2]
              __pc = 17
            end
          else
            __pc = 3
          end
        end
        if __pc == 17 then
          if r[1] then
            r[3] = r[1]
            r[2] = require(r[1])
            if not r[2] then
              __pc = 24
            else
              __pc = 25
            end
          else
            __pc = 24
          end
        end
        if __pc == 24 then
          r[2] = {}
          __pc = 25
        end
        if __pc == 25 then
          return r[2]
        end
    end
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
    r[1] = get_upvalue(0)
    r[1]("Rifle", r[0], get_upvalue(1))
    return
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
    r[1] = get_upvalue(0)
    r[1]("Melee", r[0], get_upvalue(1))
    return
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
    if r[0] then
      r[1] = get_upvalue(0)
      r[2] = r[1]
      r[1] = r[1].start
      r[1].start(r[2])
    end
    return
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
    return
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
    r[0] = 0
    while true do
      if r[0] == 0 then
        r[1] = get_upvalue(0)
        r[1] = not r[1]
        set_upvalue(0, not r[1])
        r[1] = get_upvalue(1)
        r[2] = get_upvalue(0)
        if r[2] then
          r[3] = 42
          r[4] = 62
          r[5] = 54
          r[2] = Color3.fromRGB(42, 62, 54)
          if not r[2] then
            r[3] = 30
            r[4] = 33
            r[5] = 42
            r[2] = Color3.fromRGB(30, 33, 42)
          end
        else
          r[2] = Color3
        end
        r[1].BackgroundColor3 = r[2]
        r[0] = 1
      end
      if r[0] == 1 then
        r[1] = get_upvalue(1)
        r[2] = get_upvalue(0)
        if r[2] then
          r[3] = 160
          r[4] = 240
          r[5] = 190
          r[2] = Color3.fromRGB(160, 240, 190)
          if not r[2] then
            r[3] = 175
            r[4] = 180
            r[5] = 192
            r[2] = Color3.fromRGB(175, 180, 192)
          end
        else
          r[2] = Color3
        end
        r[1].TextColor3 = r[2]
        r[1] = get_upvalue(1)
        r[2] = get_upvalue(2)
        r[3] = get_upvalue(0)
        if r[3] then
          r[3] = " [ON]"
          if not r[3] then
            r[3] = " [OFF]"
          end
        else
          r[3] = " [OFF]"
        end
        do local value = r[2]; for i = 3, 3 do value = value .. r[i] end; r[2] = value end
        r[1].Text = r[2]
        r[0] = 2
      end
      if not (r[0] == 2) then
        continue
      end
      r[1] = get_upvalue(3)
      r[1] = r[1].set
      r[2] = get_upvalue(4)
      r[3] = get_upvalue(0)
      r[4] = true
      r[1].set(r[2], r[3], true)
      r[1] = get_upvalue(5)
      r[2] = get_upvalue(0)
      r[1](r[2])
      return
    end
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
      -- This Source Was Generated by discord.gg/c3xVMnUUBv
      if i >= 2 then varargs[i - 2] = args[i + 1] else r[i] = args[i + 1] end
    end
    if not r[1] then
      r[2] = r[0].KeyCode
      r[3] = Enum.KeyCode.RightShift
      if r[2] == r[3] then
        r[2] = get_upvalue(0)
        r[3] = get_upvalue(0)
        r[3] = r[3].Enabled
        r[3] = not r[3].Enabled
        r[2].Enabled = not r[3].Enabled
      end
    end
    return
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
    r[1] = r[0].UserInputType
    r[2] = Enum.UserInputType.MouseButton1
    if r[1] ~= r[2] then
      r[1] = r[0].UserInputType
      r[2] = Enum.UserInputType.Touch
      if r[1] == r[2] then
        r[1] = false
        set_upvalue(0, false)
      end
    else
      r[1] = false
    end
    return
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
    r[1] = get_upvalue(0)
    if r[1] then
      r[1] = r[0].UserInputType
      r[2] = Enum.UserInputType.MouseMovement
      if r[1] ~= r[2] then
        r[1] = r[0].UserInputType
        r[2] = Enum.UserInputType.Touch
        if not (r[1] == r[2]) then
          return
        end
      end
      r[1] = 0
      while true do
        if not (r[1] == 0) then
          continue
        end
        r[4] = get_upvalue(1)
        r[2] = (r[0].Position) - r[4]
        r[3] = get_upvalue(2)
        r[5] = get_upvalue(3)
        r[5] = r[5].X
        r[5] = r[5].X.Scale
        r[6] = get_upvalue(3)
        r[6] = r[6].X
        r[6] = r[6].X.Offset
        r[6] = (r[6].X.Offset) + r[7]
        r[7] = get_upvalue(3)
        r[7] = r[7].Y
        r[7] = r[7].Y.Scale
        r[8] = get_upvalue(3)
        r[8] = r[8].Y
        r[8] = r[8].Y.Offset
        r[9] = r[2].Y
        r[8] = (r[8].Y.Offset) + r[9]
        r[4] = UDim2.new(r[5].X.Scale, r[6], r[7].Y.Scale, r[8])
        r[3].Position = r[4]
        return
      end
    end
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
    r[1] = r[0].UserInputType
    r[2] = Enum.UserInputType.MouseButton1
    if r[1] ~= r[2] then
      r[1] = r[0].UserInputType
      r[2] = Enum.UserInputType.Touch
      if r[1] == r[2] then
        r[1] = 0
        while true do
          if r[1] == 0 then
            set_upvalue(0, true)
            r[2] = r[0].Position
            set_upvalue(1, r[0].Position)
            r[1] = 1
          end
          if not (r[1] == 1) then
            continue
          end
          r[2] = get_upvalue(3)
          r[2] = r[2].Position
          set_upvalue(2, r[2].Position)
          return
        end
      end
    else
      r[1] = 0
    end
    return
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
    r[0] = game:GetService("Players")
    r[1] = game:GetService("ReplicatedStorage")
    r[2] = game:GetService("RunService")
    r[3] = game:GetService("UserInputService")
    r[4] = game:GetService("HttpService")
    r[5] = r[0].LocalPlayer
    r[7] = 8472910452
    r[8] = game.PlaceId
    if r[8] ~= 0 then
      r[8] = game.PlaceId
      if r[8] ~= r[7] then
        r[8] = warn
        r[9] = string.format
        r[10] = "[Nebula] Unsupported PlaceId: %d (expected %d)"
        r[11] = game.PlaceId
        r[12] = r[7]
r[8](r[9](r[10], r[11], r[12]))
      end
    end
    r[8] = protos["0_0"](env, {
    })
    r[9] = protos["0_1"](env, {
    })
    r[10] = protos["0_2"](env, {
    })
    r[11] = protos["0_3"](env, {
      [0] = capture_register(6),
      [1] = capture_register(4),
      [2] = capture_register(8),
    })
    r[12] = {}
    r[12].__index = r[12]
    r[13] = protos["0_4"](env, {
      [0] = capture_register(12),
    })
    r[12].new = r[13]
    r[13] = protos["0_5"](env, {
    })
    r[12].register = r[13]
    r[13] = protos["0_6"](env, {
    })
    r[12].pruneInactive = r[13]
    r[13] = protos["0_7"](env, {
    })
    r[12].step = r[13]
    r[13] = protos["0_8"](env, {
      [0] = capture_register(2),
    })
    r[12].start = r[13]
    r[13] = protos["0_9"](env, {
    })
    r[12].stop = r[13]
    r[13] = {}
    r[14] = {}
    r[14].skipLocked = true
    r[15] = {}
    r[15].Spread = 0
    r[15].RecoilPitch = 0.02
    r[15].FireCooldown = 0.045
    r[15].Range = 450
    r[14].overrides = r[15]
    r[13].Rifle = r[14]
    r[14] = {}
    r[14].skipLocked = false
    r[15] = {}
    r[15].SwingCooldown = 0.08
    r[15].HitboxScale = 1.35
    r[15].Recovery = 0.05
    r[14].overrides = r[15]
    r[13].Melee = r[14]
    r[14] = {}
    r[15] = protos["0_10"](env, {
      [0] = capture_register(13),
      [1] = capture_register(14),
    })
    r[16] = protos["0_11"](env, {
      [0] = capture_register(5),
    })
    r[17] = protos["0_12"](env, {
      [0] = capture_register(0),
      [1] = capture_register(16),
      [2] = capture_register(5),
    })
    r[18] = protos["0_13"](env, {
      [0] = capture_register(10),
      [1] = capture_register(9),
    })
    r[19] = protos["0_14"](env, {
    })
    r[21] = {}
    r[21].rifleBypass = false
    r[21].meleeBypass = false
    r[21].autoOrbit = false
    r[21].scanRadius = 180
    r[21].allowTeam = false
    r[20] = r[11](r[21])
    r[20].load()
    r[21] = r[12].new("NebulaCore", 6)
    r[25] = r[21]
    r[24] = r[21].register
    r[26] = "TargetOrbit"
    r[27] = 0.016
    r[28] = protos["0_15"](env, {
      [0] = capture_register(9),
      [1] = capture_register(20),
      [2] = capture_register(23),
      [3] = capture_register(17),
      [4] = capture_register(16),
      [5] = capture_register(22),
      [6] = capture_register(5),
    })
    r[24](r[25], r[26], r[27], r[28])
    r[24] = gethui
    if r[24] then
      r[24] = gethui()
      if not r[24] then
        r[25] = r[5]
        r[26] = "PlayerGui"
        r[24] = r[5]:WaitForChild("PlayerGui")
      end
    else
      r[25] = r[5]
      r[24] = r[5].WaitForChild
    end
    r[26] = r[24]
    r[27] = "NebulaSentinelUI"
    r[25] = r[24]:FindFirstChild("NebulaSentinelUI")
    if r[25] then
      r[27] = r[25]
      r[26] = r[25].Destroy
      r[25]:Destroy()
    end
    r[28] = {}
    r[28].Name = "NebulaSentinelUI"
    r[28].ResetOnSpawn = false
    r[28].ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    r[28].Parent = r[24]
    r[26] = r[19]("ScreenGui", r[28])
    r[27] = r[19]
    r[28] = "Frame"
    r[29] = {}
    r[30] = UDim2.new(0, 240, 0, 280)
    r[29].Size = r[30]
    r[30] = UDim2.new(0, 48, 0, 140)
    r[29].Position = r[30]
    r[30] = Color3.fromRGB(20, 22, 28)
    r[29].BackgroundColor3 = r[30]
    r[29].BorderSizePixel = 0
    r[29].Parent = r[26]
    r[30] = {}
    r[33] = {}
    r[34] = UDim.new(0, 12)
    r[33].CornerRadius = r[34]
    r[31] = r[19]("UICorner", r[33])
    r[32] = r[19]
    r[33] = "UIStroke"
    r[34] = {}
    r[36] = 62
    r[37] = 68
    r[38] = 82
    r[35] = Color3.fromRGB(62, 68, 82)
    r[34].Color = r[35]
    r[34].Thickness = 1
do local out = pack(r[32](r[33], r[34])); top = 32 + out.n - 1; for i = 1, out.n do r[32 + i - 1] = out[i] end end
    for i = 31, top do table.insert(r[30], r[i]) end
    r[27] = r[27](r[28], r[29], r[30])
    r[30] = {}
    r[31] = UDim2.new(1, -20, 0, 32)
    r[30].Size = r[31]
    r[31] = UDim2.new(0, 10, 0, 0)
    r[30].Position = r[31]
    r[30].BackgroundTransparency = 1
    r[30].Text = "Nebula Sentinel v2.4"
    r[31] = Color3.fromRGB(235, 238, 245)
    r[30].TextColor3 = r[31]
    r[30].Font = Enum.Font.Code
    r[30].TextSize = 13
    r[30].TextXAlignment = Enum.TextXAlignment.Left
    r[30].Parent = r[27]
    r[28] = r[19]("TextLabel", r[30])
    r[29] = r[19]
    r[30] = "Frame"
    r[31] = {}
    r[32] = UDim2.new(1, -16, 1, -44)
    r[31].Size = r[32]
    r[32] = UDim2.new(0, 8, 0, 36)
    r[31].Position = r[32]
    r[31].BackgroundTransparency = 1
    r[31].Parent = r[27]
    r[32] = {}
    r[33] = r[19]
    r[34] = "UIListLayout"
    r[35] = {}
    r[37] = 0
    r[38] = 6
    r[36] = UDim.new(0, 6)
    r[35].Padding = r[36]
    r[36] = Enum.SortOrder.LayoutOrder
    r[35].SortOrder = Enum.SortOrder.LayoutOrder
do local out = pack(r[33](r[34], r[35])); top = 33 + out.n - 1; for i = 1, out.n do r[33 + i - 1] = out[i] end end
    for i = 33, top do table.insert(r[32], r[i]) end
    r[29] = r[29](r[30], r[31], r[32])
    r[30] = {}
    r[31] = r[18]
    r[32] = "LoadItemRegistry"
    r[33] = 2
    r[34] = protos["0_16"](env, {
      [0] = capture_register(1),
    })
    r[31], r[32] = r[31](r[32])
    if r[31] then
      r[34] = r[32]
      r[33] = type(r[32])
      if r[33] == "table" then
        r[33] = r[32].Items
        if r[33] then
          r[30] = r[33]
        else
          r[30] = r[32]
        end
      end
    end
    r[33] = {}
    r[34] = {}
    r[35] = "Rifle Fast-Fire"
    r[36] = "rifleBypass"
    r[37] = protos["0_17"](env, {
      [0] = capture_register(15),
      [1] = capture_register(30),
    })
    for i = 1, 3 do r[34][i] = r[34 + i] end
    r[35] = {}
    r[36] = "Melee Cooldown"
    r[37] = "meleeBypass"
    r[38] = protos["0_18"](env, {
      [0] = capture_register(15),
      [1] = capture_register(30),
    })
    for i = 1, 3 do r[35][i] = r[35 + i] end
    r[36] = {}
    r[37] = "Auto Orbit Nearest"
    r[38] = "autoOrbit"
    r[39] = protos["0_19"](env, {
      [0] = capture_register(21),
    })
    for i = 1, 3 do r[36][i] = r[36 + i] end
    r[37] = {}
    r[38] = "Include Teammates"
    r[39] = "allowTeam"
    r[40] = protos["0_20"](env, {
    })
    for i = 1, 3 do r[37][i] = r[37 + i] end
    for i = 1, 4 do r[33][i] = r[33 + i] end
    r[34] = ipairs
    r[35] = r[33]
    r[34], r[35], r[36] = r[34](r[35])
    while true do
      local out = {r[34](r[35], r[36])}
      for i = 1, 2 do r[36 + i] = out[i] end
      if not (out[1]) then
        break
      end
        r[36] = out[1]
      r[39] = r[38][1]
      r[40] = r[38][2]
      r[41] = r[38][3]
      r[43] = r[38][2]
      r[42] = r[20].get(r[38][2])
      if r[42] ~= true then
        r[42] = false
      end
      r[42] = true
      r[43] = r[19]
      r[44] = "TextButton"
      r[45] = {}
      r[47] = 1
      r[48] = 0
      r[49] = 0
      r[50] = 32
      r[46] = UDim2.new(1, 0, 0, 32)
      r[45].Size = r[46]
      if r[42] then
        r[47] = 42
        r[48] = 62
        r[49] = 54
        r[46] = Color3.fromRGB(42, 62, 54)
        if not r[46] then
          r[47] = 30
          r[48] = 33
          r[49] = 42
          r[46] = Color3.fromRGB(30, 33, 42)
        end
      else
        r[46] = Color3
      end
      r[45].BackgroundColor3 = r[46]
      r[45].BorderSizePixel = 0
      r[45].AutoButtonColor = false
      r[46] = r[39]
      if r[42] then
        r[47] = " [ON]"
        if not r[47] then
          r[47] = " [OFF]"
        end
      else
        r[47] = " [OFF]"
      end
      do local value = r[46]; for i = 47, 47 do value = value .. r[i] end; r[46] = value end
      r[45].Text = r[46]
      if r[42] then
        r[47] = 160
        r[48] = 240
        r[49] = 190
        r[46] = Color3.fromRGB(160, 240, 190)
        if not r[46] then
          r[47] = 175
          r[48] = 180
          r[49] = 192
          r[46] = Color3.fromRGB(175, 180, 192)
        end
      else
        r[46] = Color3
      end
      r[45].TextColor3 = r[46]
      r[45].Font = Enum.Font.Code
      r[45].TextSize = 12
      r[45].LayoutOrder = r[37]
      r[45].Parent = r[29]
      r[46] = {}
      r[47] = r[19]
      r[48] = "UICorner"
      r[49] = {}
      r[50] = UDim.new(0, 8)
      r[49].CornerRadius = r[50]
do local out = pack(r[47](r[48], r[49])); top = 47 + out.n - 1; for i = 1, out.n do r[47 + i - 1] = out[i] end end
      for i = 47, top do table.insert(r[46], r[i]) end
      r[43] = r[43](r[44], r[45], r[46])
      r[45] = r[43].MouseButton1Click
      r[44] = r[43].MouseButton1Click.Connect
      r[46] = protos["0_21"](env, {
        [0] = capture_register(42),
        [1] = capture_register(43),
        [2] = capture_register(39),
        [3] = capture_register(20),
        [4] = capture_register(40),
        [5] = capture_register(41),
      })
      r[44](r[45], r[46])
      if r[42] then
        r[44] = r[41]
        r[45] = true
        r[41](true)
      end
      close_upvalues(39)
      continue
    end
    r[34] = 0
    while true do
      if r[34] == 0 then
        r[35] = false
        r[34] = 1
      end
      if 3 == r[34] then
        break
      end
      if r[34] == 2 then
        r[39] = r[3].InputEnded
        r[38] = r[3].InputEnded.Connect
        r[40] = protos["0_23"](env, {
          [0] = capture_register(35),
        })
        r[38](r[39], r[40])
        r[39] = r[3].InputChanged
        r[38] = r[3].InputChanged.Connect
        r[40] = protos["0_24"](env, {
          [0] = capture_register(35),
          [1] = capture_register(36),
          [2] = capture_register(27),
          [3] = capture_register(37),
        })
        r[38](r[39], r[40])
        r[34] = 3
      end
      if not (r[34] == 1) then
        continue
      end
      r[39] = r[28].InputBegan
      r[38] = r[28].InputBegan.Connect
      r[40] = protos["0_25"](env, {
        [0] = capture_register(35),
        [1] = capture_register(36),
        [2] = capture_register(37),
        [3] = capture_register(27),
      })
      r[38](r[39], r[40])
      r[34] = 2
      continue
    end
    r[39] = r[3].InputBegan
    r[38] = r[3].InputBegan.Connect
    r[40] = protos["0_22"](env, {
      [0] = capture_register(26),
    })
    r[38](r[39], r[40])
    close_upvalues(34)
    r[21]:start()
    r[34] = r[8]
    r[35] = "NebulaSentinelReady"
    r[36] = 42
    r[34], r[35], r[36] = r[34](r[35])
    r[37] = print
    r[38] = string.format
    r[39] = "[Nebula] Loaded OK | sig=%s (%d, len=%d)"
    r[40] = r[35]
    r[41] = r[34]
    r[42] = r[36]
r[37](r[38](r[39], r[40], r[41], r[42]))
    close_upvalues(0)
    return
  end
end




































print("Deobf By Zed")
return protos["0"](_ENV, {})()
