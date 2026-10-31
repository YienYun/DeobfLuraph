-- LuaObfuscator test vector 1 — small, dense in features, deterministic.
-- Every line it prints is a check; the deobfuscated copy must print the same
-- lines in the same order. Nothing here depends on time, random or the engine.

local function fib(n)
  if n < 2 then return n end
  return fib(n - 1) + fib(n - 2)
end
print("CHECK fib", fib(16))

local function counter(start)
  local n = start
  return function(step)
    n = n + (step or 1)
    return n
  end
end
local c = counter(10)
print("CHECK counter", c(), c(5), c())

local function sum(...)
  local total, n = 0, select("#", ...)
  for i = 1, n do total = total + (select(i, ...)) end
  return total, n
end
print("CHECK varargs", sum(1, 2, 3, 4, 5))

local t = { 5, 3, 9, 1, 7 }
table.sort(t)
local joined = table.concat(t, ",")
print("CHECK sort", joined)

local parts = {}
for word in string.gmatch("alpha beta gamma", "%a+") do
  parts[#parts + 1] = string.upper(word)
end
print("CHECK gmatch", table.concat(parts, "|"))
print("CHECK format", string.format("%s:%d:%.2f", "x", 42, 3.14159))
print("CHECK sub", string.sub("abcdefgh", 2, 5), #"abcdefgh")

local obj = { name = "base" }
function obj:hello(who)
  return self.name .. "/" .. who
end
print("CHECK method", obj:hello("world"))

local ok, err = pcall(function() error("boom") end)
print("CHECK pcall", tostring(ok), tostring(err):match("boom") ~= nil)

local mt = { __add = function(a, b) return a.v + b.v end }
local a, b = setmetatable({ v = 3 }, mt), setmetatable({ v = 4 }, mt)
print("CHECK metatable", a + b)

local total = 0
for i = 1, 20 do
  if i % 3 == 0 then total = total + i elseif i % 2 == 0 then total = total - 1 end
end
print("CHECK loop", total)

local n, acc = 0, 1
while n < 5 do n = n + 1; acc = acc * 2 end
repeat acc = acc + 1 until acc > 40
print("CHECK while", n, acc)

print("CHECK math", math.floor(7.9), math.max(3, 8, 5), math.abs(-12), math.fmod(10, 3))
print("CHECK tostring", tostring(1.5), tonumber("0x1F"), tonumber("42") + 1)
