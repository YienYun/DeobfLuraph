-- LuaObfuscator test vector 2 — the awkward parts: OOP with inheritance, upvalue
-- sharing, coroutines, nested closures, vararg forwarding, goto, table tricks.
-- Deterministic; every printed line is a check the deobfuscated copy must match.

local Animal = {}
Animal.__index = Animal

function Animal.new(name, sound)
  return setmetatable({ name = name, sound = sound, energy = 3 }, Animal)
end

function Animal:speak()
  self.energy = self.energy - 1
  return self.name .. " says " .. self.sound .. " (" .. self.energy .. ")"
end

local Dog = setmetatable({}, { __index = Animal })
Dog.__index = Dog

function Dog.new(name)
  local self = Animal.new(name, "woof")
  self.tricks = {}
  return setmetatable(self, Dog)
end

function Dog:learn(trick)
  table.insert(self.tricks, trick)
  return #self.tricks
end

function Dog:speak()
  local base = Animal.speak(self)
  return base .. " and knows " .. table.concat(self.tricks, ", ")
end

local d = Dog.new("rex")
d:learn("sit")
d:learn("roll")
print("CHECK oop", d:speak())
print("CHECK inherit", getmetatable(d) == Dog, Dog.__index ~= nil)

local function makeAccount(balance)
  local history = {}
  local function push(kind, amount)
    history[#history + 1] = kind .. ":" .. amount
  end
  return {
    deposit = function(v) balance = balance + v; push("in", v); return balance end,
    withdraw = function(v)
      if v > balance then push("denied", v); return nil, "insufficient" end
      balance = balance - v; push("out", v); return balance
    end,
    history = function() return table.concat(history, " ") end,
  }
end

local acc = makeAccount(100)
acc.deposit(50)
print("CHECK withdraw", acc.withdraw(30))
print("CHECK denied", acc.withdraw(1000))
print("CHECK history", acc.history())

local co = coroutine.create(function(a)
  local b = coroutine.yield(a + 1)
  local c = coroutine.yield(b * 2)
  return a + b + c
end)
print("CHECK coroutine", coroutine.resume(co, 10))
print("CHECK coroutine2", coroutine.resume(co, 5))
print("CHECK coroutine3", coroutine.resume(co, 7))
print("CHECK dead", coroutine.status(co))

local function pack(...)
  return { n = select("#", ...), ... }
end
local function forward(...)
  local p = pack(...)
  local out = {}
  for i = 1, p.n do out[i] = tostring(p[i]) end
  return table.concat(out, "+")
end
print("CHECK forward", forward(1, "two", 3.5, nil, true))

local data = { { name = "b", score = 2 }, { name = "a", score = 9 }, { name = "c", score = 5 } }
table.sort(data, function(x, y) return x.score > y.score end)
local rank = {}
for i, row in ipairs(data) do rank[i] = row.name .. row.score end
print("CHECK sortby", table.concat(rank, ","))

local matrix = {}
for i = 1, 3 do
  matrix[i] = {}
  for j = 1, 3 do matrix[i][j] = i * j end
end
local det = matrix[1][1] * (matrix[2][2] * matrix[3][3] - matrix[2][3] * matrix[3][2])
  - matrix[1][2] * (matrix[2][1] * matrix[3][3] - matrix[2][3] * matrix[3][1])
  + matrix[1][3] * (matrix[2][1] * matrix[3][2] - matrix[2][2] * matrix[3][1])
print("CHECK matrix", det)

-- (no goto: the oracle runs the pairs under Luau, which dropped labels)
local function classify(n)
  local out = {}
  for i = 1, n do
    if i % 15 == 0 then out[#out + 1] = "FizzBuzz"
    elseif i % 3 == 0 then out[#out + 1] = "Fizz"
    elseif i % 5 == 0 then out[#out + 1] = "Buzz"
    else out[#out + 1] = tostring(i) end
  end
  return table.concat(out, "/")
end
print("CHECK fizzbuzz", classify(15))

local deep = function(a)
  return function(b)
    return function(c)
      return function(d) return a + b + c + d, a * b * c * d end
    end
  end
end
local total, product = deep(1)(2)(3)(4)
print("CHECK closures", total, product)

local s = "The quick brown fox jumps over the lazy dog"
local counts = {}
for ch in string.gmatch(s:lower(), "%a") do counts[ch] = (counts[ch] or 0) + 1 end
local keys = {}
for k in pairs(counts) do keys[#keys + 1] = k end
table.sort(keys)
local dump = {}
for _, k in ipairs(keys) do dump[#dump + 1] = k .. counts[k] end
print("CHECK histogram", table.concat(dump, ""))

local ok, res = pcall(function() return nil + 1 end)
print("CHECK nilmath", tostring(ok), type(res))
print("CHECK tonumber", tonumber("  12  "), tonumber("z"), tonumber("ff", 16))
print("CHECK select", select("#", nil, nil, 3), select(2, "a", "b", "c"))
