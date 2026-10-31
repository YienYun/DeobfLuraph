-- Passive capture for a Luarmor chain (or any loader that fetches text and
-- runs it with loadstring). Run this FIRST in the executor, then run the
-- loader in the same session, without leaving the game.
--
-- Nothing is blocked or rewritten: every hook calls the original and then
-- saves a copy. Files land in <executor workspace>/DeobCapture/:
--
--   NN_httpget.lua     body of one HTTP fetch (the loader itself, then
--                      whatever else it pulls: init, session, ...)
--   NN_loadstring.lua  every string handed to loadstring/load (the real script)
--   NN_request.lua     response body of request/http_request/syn.request
--   _log.txt           one line per capture: path, byte count, url
--
-- Then hand the captured files to the engine: node deob.js <file>

local OUT = "DeobCapture"
local MIN_BYTES = 200
local env = (getgenv and getgenv()) or _G
local seq = 0

local function get(key)
    local ok, v = pcall(function() return env[key] end)
    if ok then return v end
    return nil
end

local function log(msg)
    pcall(function() appendfile(OUT .. "/_log.txt", msg .. "\n") end)
    print("[capture] " .. msg)
end

local function save(kind, body, tag)
    if type(body) ~= "string" or #body < MIN_BYTES then return end
    seq = seq + 1
    local path = string.format("%s/%02d_%s.lua", OUT, seq, kind)
    if pcall(writefile, path, body) then
        log(string.format("%-26s %8d bytes  %s", path, #body, tag or ""))
    else
        log(string.format("writefile failed: %s (%d bytes)", path, #body))
    end
end

pcall(function()
    if isfolder and not isfolder(OUT) then makefolder(OUT) end
    writefile(OUT .. "/_log.txt", "-- deob capture log\n")
end)

-- hookfunction returns a callable of the original body; a wrapper has to call
-- that one, calling the hooked function again would recurse forever.
local function hook(fn, make_wrapper)
    if type(hookfunction) ~= "function" or type(fn) ~= "function" then return false end
    local orig
    local ok = pcall(function()
        orig = hookfunction(fn, make_wrapper(function(...) return orig(...) end))
    end)
    return ok and type(orig) == "function"
end

local function want_path(a)
    if type(a) == "table" then return a.Url or a.URL or a.url or "?" end
    return "?"
end

local function want_body(r)
    if type(r) == "string" then return r end
    if type(r) == "table" then return r.Body or r.body end
    return nil
end

-- 1. HTTP fetch: game:HttpGet is the usual path in a Luarmor loader.
local got_http = false
for _, name in ipairs({ "HttpGet", "HttpGetAsync" }) do
    pcall(function()
        if hook(game[name], function(call)
            return function(self, url, ...)
                local body = call(self, url, ...)
                save("httpget", body, tostring(url))
                return body
            end
        end) then got_http = true end
    end)
end

-- 2. The request family, for loaders that use executor HTTP instead.
local got_request = false
local targets = {
    { env, "request" }, { env, "http_request" }, { env, "requestAsync" },
    { get("syn"), "request" }, { get("fluxus"), "request" }, { get("http"), "request" },
}
for _, t in ipairs(targets) do
    local holder, name = t[1], t[2]
    if type(holder) == "table" or type(holder) == "userdata" then
        pcall(function()
            if hook(holder[name], function(call)
                return function(options, ...)
                    local res = call(options, ...)
                    save("request", want_body(res), tostring(want_path(options)))
                    return res
                end
            end) then got_request = true end
        end)
    end
end

-- 3. loadstring/load: the decrypted script always ends up here.
local old_loadstring = get("loadstring") or loadstring
local old_load = get("load")
local swap_loadstring = type(old_loadstring) == "function"
local swap_load = type(old_load) == "function" and old_load ~= old_loadstring

if swap_loadstring then
    local function capture(src, chunk, ...)
        save("loadstring", src, "chunk=" .. tostring(chunk))
        return old_loadstring(src, chunk, ...)
    end
    env.loadstring = capture
    loadstring = capture
end

if swap_load then
    local function capture_load(src, chunk, ...)
        save("loadstring", src, "chunk=" .. tostring(chunk))
        return old_load(src, chunk, ...)
    end
    env.load = capture_load
end

log("ready: httpget=" .. tostring(got_http) .. " request=" .. tostring(got_request)
    .. " loadstring=" .. tostring(swap_loadstring) .. " load=" .. tostring(swap_load))
log("run the loader in this same session, then open workspace/" .. OUT)
