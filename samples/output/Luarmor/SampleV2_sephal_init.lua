-- Luarmor v4: Luarmor v4 sephal init (Luraph v15 chunk + superflow blob)
-- The licence check itself is not bypassed: only the code in this file was lifted.

local localPlayer = game:GetService("Players").LocalPlayer

local function fn(arg)
	local n = 433792055

	local function kickPlayer()
		if bit32.bxor(n, 0) + 352972492 == 156732182 then
			n = bit32.bxor(n, 279904831)
		end

		localPlayer:Kick(arg or "Tamper Detected")
	end

	n = 469563029
	pcall(kickPlayer)
end

local n = 187753939

local function fn2()
	local v = loadstring

	if type(iscclosure) == "function" then
		local ok, result = pcall(iscclosure, v)
		if ok and result == false then
			return true
		end
	end

	if type(islclosure) == "function" then
		local ok, result = pcall(islclosure, v)
		if ok and result == true then
			return true
		end
	end

	if type(isfunctionhooked) == "function" then
		local ok, result = pcall(isfunctionhooked, v)
		if ok and result == true then
			return true
		end
	end

	local v2 = isnewcclosure or iscustomcclosure

	if type(v2) == "function" then
		local ok, result = pcall(v2, v)
		if ok and result == true then
			return true
		end
	end

	local ok, result = pcall(debug.info, v, "s")
	if ok and result ~= "[C]" then
		return true
	end
	return false
end

local function fn3()
	local httpRequests = {}

	if type(request) == "function" then
		local n2 = #httpRequests + 1
		httpRequests[n2] = request
	end

	if type(http_request) == "function" then
		httpRequests[#httpRequests + 1] = http_request
	end

	if type(http) == "table" and type(http.request) == "function" then
		httpRequests[#httpRequests + 1] = http.request
	end

	if type(syn) == "table" and type(syn.request) == "function" then
		httpRequests[#httpRequests + 1] = syn.request
	end

	local n2 = 113318488

	local function fn4()
		local httpGet = game.HttpGet

		if bit32.bxor(n2, 0) == 332394762 then
			n2 = bit32.bxor(n2, 1320427899)
		end

		return httpGet
	end

	n2 = 517921506
	local ok, result = pcall(fn4)

	if ok and type(result) == "function" then
		httpRequests[#httpRequests + 1] = result
	end

	return httpRequests
end

n = 304125664

local function fn4()
	for _, v in ipairs(fn3(147586653)) do
		if type(isfunctionhooked) == "function" then
			local ok, result = pcall(isfunctionhooked, v)
			if ok and result == true then
				return true
			end
		end

		local result = nil

		if type(iscclosure) == "function" then
			local ok
			ok, result = pcall(iscclosure, v)
			local v2 = nil

			if not ok then
				result = v2
			end
		end

		local result2 = nil

		if type(islclosure) == "function" then
			local ok
			ok, result2 = pcall(islclosure, v)
			local v2 = nil

			if not ok then
				result2 = v2
			end
		end

		if result2 == true or result == false then
			return true
		end
		local ok, result3 = pcall(debug.info, v, "s")
		if ok and result3 ~= "[C]" then
			return true
		end
	end

	return false
end

if fn2(31323921) or fn4(241732121) then
	fn()
	return
end

local ok, result = pcall(function()
	local function fn5(arg)
		if type(arg) == "function" then
			if type(isfunctionhooked) == "function" then
				local ok, result = pcall(isfunctionhooked, arg)
				if ok and result == true then
					return true
				end
			end

			if type(iscclosure) == "function" then
				local ok, result = pcall(iscclosure, arg)
				if ok and result == false then
					return true
				end
			end

			if type(islclosure) == "function" then
				local ok, result = pcall(islclosure, arg)
				if ok and result == true then
					return true
				end
			end

			local ok, result = pcall(debug.info, arg, "s")
			if not (ok and result ~= "[C]") then
				return false
			end
		end

		return true
	end

	local flag = fn5(loadstring, 350616455)

	if not flag then
		local v = isnewcclosure or iscustomcclosure

		if type(v) == "function" then
			local ok, result = pcall(v, loadstring)
			ok = ok and result == true

			if ok then
				flag = true
			end
		end
	end

	if not flag then
		local httpRequests = {}

		if type(request) == "function" then
			httpRequests[#httpRequests + 1] = request
		end

		if type(http_request) == "function" then
			httpRequests[#httpRequests + 1] = http_request
		end

		if type(http) == "table" and type(http.request) == "function" then
			httpRequests[#httpRequests + 1] = http.request
		end

		if type(syn) == "table" and type(syn.request) == "function" then
			httpRequests[#httpRequests + 1] = syn.request
		end

		local n2 = 494462360

		local function fn6()
			local httpGet = game.HttpGet

			if bit32.bxor(n2, 0) ~= 521386540 then
				n2 = bit32.bxor(n2, 1584487297)
			end

			return httpGet
		end

		n2 = 521386540
		local ok, result = pcall(fn6)

		if ok and type(result) == "function" then
			httpRequests[#httpRequests + 1] = result
		end

		for _, httpRequest in ipairs(httpRequests) do
			if fn5(httpRequest, 350616455) then
				flag = true
				break
			end
		end
	end

	if flag then
		return 464367618
	end
	return 3237998146
end)

if not ok or result ~= 3237998146 then
	fn()
	return
end

local HttpService = game:GetService("HttpService")

local function fn5(arg, arg2)
	local str = string.gsub(arg, "[^" .. arg2 .. "=]", ""):gsub(".", function(arg3)
		if arg3 == "=" then
			return ""
		end
		local n2 = arg2:find(arg3, 1, true) - 1
		local str = ""

		for i = 6, 1, -1 do
			str ..= n2 % 2 ^ i - n2 % 2 ^ (i - 1) > 0 and "1" or "0"
		end

		return str
	end)

	return (str:gsub("%d%d%d?%d?%d?%d?%d?%d?", function(arg3)
		if #arg3 ~= 8 then
			return ""
		end
		local n2 = 0

		for i = 1, 8 do
			n2 += arg3:sub(i, i) == "1" and 2 ^ (8 - i) or 0
		end

		return string.char(n2)
	end))
end

local function fn6(arg, arg2)
	local iMap = {}

	for i = 0, 255 do
		iMap[i] = i
	end

	local n2 = #arg
	local n3 = 0

	for i = 0, 255 do
		n3 = (n3 + iMap[i] + string.byte(arg, i % n2 + 1)) % 256
		local iEntry = iMap[i]
		iMap[i] = iMap[n3]
		iMap[n3] = iEntry
	end

	local parts = {}
	local n4 = 0
	local n5 = 0

	for i = 1, #arg2 do
		n4 = (n4 + 1) % 256
		n5 = (n5 + iMap[n4]) % 256
		local iEntry = iMap[n4]
		iMap[n4] = iMap[n5]
		iMap[n5] = iEntry
		local iEntry2 = iMap[(iMap[n4] + iMap[n5]) % 256]
		parts[i] = string.char(bit32.bxor(string.byte(arg2, i), iEntry2))
	end

	return table.concat(parts)
end

local n2 = 433199529

local function fn7(arg, arg2)
	local parts = {}
	local n3 = #arg

	if bit32.bxor(n2, 0) == 497955482 then
		n2 = bit32.bxor(n2, 4252064961)
	end

	for i = 1, #arg2 do
		local n4 = i - 1
		parts[i] = string.char(bit32.bxor((string.byte(arg2, i) - n4) % 256, string.byte(arg, n4 % n3 + 1)))
	end

	return table.concat(parts)
end

local function fn8(arg)
	local n3 = 150331670

	local function fn9(arg2)
		local stringFormat = string.format
		local arg22 = table.pack(string.byte(arg2))

		if bit32.bxor(bit32.bxor(stringFormat, 0), 534095864) ~= 386352355 then
			stringFormat = bit32.bxor(stringFormat, 3550593715)
		end

		return stringFormat("%02x", table.unpack(arg22, 1, arg22.n))
	end

	n3 = 148038427
	return (arg:gsub(".", fn9))
end

local function fn9(arg)
	fn("[xhider] " .. tostring(arg))
	return nil
end

if type(_bsdata0) ~= "table" then
	return (fn9("_bsdata0 is missing or malformed"))
end

local ok2, result2 = pcall(function()
	local v = superflow_bytecode[3]
	return string.sub(superflow_bytecode[1], 1401) .. string.sub(superflow_bytecode[2], 1, #superflow_bytecode[2] - 1400) .. string.sub(v, 301, #v - 300)
end)

local v = _bsdata0[3]
local v2 = _bsdata0[4]
local flag = not ok2 or type(result2) ~= "string"
n2 = 129476957
flag = flag or #result2 == 0 or type(v) ~= "number" or type(v2) ~= "string"

if flag then
	return (fn9("_bsdata0 is invalid"))
end

if v < os.time() * 1000 then
	return (fn9("Token has expired, please get a fresh loader"))
end

local ok3, result3 = pcall(fn5, string.reverse(result2), "ZYXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba9876543210_.")

if not ok3 or not result3 then
	return (fn9("Failed to decode _bsdata0"))
end

local ok4, result4 = pcall(fn7, "de99c328035c73d5a9a07411449a1556543431c0e12d7f0a" .. v2, result3)
local flag2 = not ok4
local flag22 = flag2 or not result4

if flag22 then
	return (fn9("Failed to decode _bsdata0"))
end

local ok5, result5 = pcall(fn6, "8a0eb0e1fe9d7915f82a9de464d96451ef31a313ed510a0b", result4)

if not ok5 or not result5 then
	return (fn9("Failed to decrypt _bsdata0"))
end

local ok6, result6 = pcall(function()
	return HttpService:JSONDecode(result5)
end)

if not ok6 or type(result6) ~= "table" or not result6.t or type(result6.exp) ~= "number" then
	return (fn9("_bsdata0 is invalid"))
end

if result6.exp < os.time() * 1000 then
	return (fn9("Token has expired, please get a fresh loader"))
end

local str = string.format("%.0f", result6.exp)

local function fn10(arg)
	local v3 = str
	return fn8(arg("8a0eb0e1fe9d7915f82a9de464d96451ef31a313ed510a0b", arg .. "|" .. v3))
end

local scriptKey = type(script_key) == "string" and script_key or type(_G.script_key) == "string" and _G.script_key or ""
local str2 = scriptKey ~= "" and HttpService:UrlEncode(scriptKey) or ""
local str3 = ""
local n3 = 232350312

local function fn11()
	local v3 = tostring
	local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

	if bit32.bxor(bit32.bxor(n3, 0), 415194723) == 213717254 then
		n3 = bit32.bxor(n3, 1179506991)
	end

	str3 = v3(RbxAnalyticsService:GetClientId())
end

n3 = 8523059
pcall(fn11)
local str4 = str3 ~= "" and HttpService:UrlEncode(str3) or ""

local function fn12(arg, arg2)
	local v3 = fn10(arg2)
	local str5 = str2 ~= "" and "&key=" .. str2 or ""
	local str6 = arg .. arg2 .. "?k=" .. v3 .. str5 .. (str4 ~= "" and "&hwid=" .. str4 or "")
	local n4 = 273189465

	local function fn13()
		-- This Source Was Generated by discord.gg/c3xVMnUUBv
		local gameRef = game

		if bit32.bxor(bit32.bxor(n4, 0), 368863931) == 106334943 then
			n4 = bit32.bxor(n4, 2387331727)
		end

		return gameRef:HttpGet(str6)
	end

	n4 = 341487814
	local ok7, result7 = pcall(fn13)
	if not ok7 then
		return nil, tostring(result7)
	end

	if type(result7) ~= "string" or #result7 == 0 then
		return nil
	end

	if result7:sub(1, 7) == "--error" then
		local str7 = result7:sub(8):gsub("^%s*[:%-]*%s*", ""):gsub("%s+$", "")
		return nil, str7 ~= "" and str7 or nil
	end
	return result7
end

local v3, str5 = fn12("https://roblox-auth.xhider.xyz/auth/pre/", result6.t)

if not v3 then
	str5 = str5 or "Pre-check failed (token may already be used, or server error)"
	return (fn9(str5))
end

local v4, v5 = fn12("https://roblox-auth.xhider.xyz/auth/verify/", v3)

if not v4 then
	return (fn9(v5 or "Verify-check failed (token may already be used, or server error)"))
end

local v6, v7 = fn12("https://roblox-auth.xhider.xyz/auth/check/", v4)

if not v6 then
	return (fn9(v7 or "Failed to fetch the real script (token may already be used, or server error)"))
end

local match = v6:match("^warn%(\"%[xhider loader%] (.-)\"%)\nreturn nil$")

if match then
	return (fn9(match))
end

local ok7, result7 = pcall(loadstring, v6)

if not ok7 or type(result7) ~= "function" then
	return (fn9("Downloaded script is invalid / loadstring failed"))
end

print("Deobf By Zed")
return result7()
