local function u32Trunc(x)
	x %= 4294967296
	return if x == x then x // 1 else 0
end

local function u32Mul(a, b)
	a, b = bit32.band(a, 4294967295), bit32.band(b, 4294967295)
	return bit32.band(bit32.band(a, 65535) * b + bit32.lshift(bit32.rshift(a, 16) * bit32.band(b, 65535), 16), 4294967295)
end

local n = 488235790
type(0)
local n2 = 1268974647
local n3 = 684062543

task.spawn(pcall, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/DiscordLink"))()
end)

local function fn()
	local v = loadstring
	local response = game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli%20Library")
	local v2, v3 = v(response)
	assert(v2, v3)
	local v4 = v2()
	assert(type(v4) == "function", "Chilli Library bootstrap is invalid.")
	local v5 = table.create(45)
	local n4 = 1

	for i = 1, 90, 2 do
		v5[n4] = string.char(bit32.bxor(tonumber(string.sub("306908100841206d474f00185f26635b2101387507010810127d7d477a473b6f435a0916573165562900226c00", i, i + 1), 16), string.byte("s9K!2vQ#", (n4 - 1) % 8 + 1)))
		n4 += 1
	end

	return v4(table.concat(v5))
end

local v = fn(488023178, 180544471)
local v2 = assert
local n4 = 947395616
local flag = type(v) == "table" and type(v.CreateWindow) == "function"

if flag then
	local v3 = type
	local finalize = v.Finalize
	local n32 = table.pack(bit32.band(n3, 4294967295))
	local n22 = table.pack(bit32.band(n2, 4294967295))
	local v4 = table.pack(bit32.band(n32[1], 65535))
	local v5 = table.pack(bit32.rshift(n32[1], 16))
	local v6 = table.pack(bit32.band(n22[1], 65535))
	local v7 = bit32.band(v4[1] * v6[1] + bit32.lshift(bit32.band(v4[1] * bit32.rshift(n22[1], 16) + v5[1] * v6[1], 65535), 16), 4294967295)
	flag = v3(finalize) == "function"
	n3 = v7 + 2987628886
	n2 = n2 + 3798223773 + 496743523
end

v2(flag, "Chilli Library returned an invalid API.")

local manualQuickDefaults = {
	PinnedFeatures = { "Farm > Auto Collect Eggs > Auto Collect Eggs", "Player > Movement > Speed Boost" },
}

local v3 = bit32.bxor(n, 387410064)
manualQuickDefaults.Keybinds = {}
manualQuickDefaults.PinGroups = {}
manualQuickDefaults.LeftCenterHidden = true
v.ManualQuickDefaults = manualQuickDefaults
local v4 = v:CreateWindow({ Name = "Chilli Hub - Ride A Pet", DefaultTab = "Farm" })
local defaultTab = v4:GetDefaultTab()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local localPlayer = Players.LocalPlayer
local v32 = table.pack(bit32.band(v3, 4294967295))
local v5 = table.pack(bit32.band(v32[1], 65535))
local n5 = 3372741763 + bit32.band(62596 * v5[1] + bit32.lshift(bit32.band(62596 * bit32.rshift(v32[1], 16) + 51463 * v5[1], 65535), 16), 4294967295)
local v33 = bit32.bxor(v3, 353206308)
local v332 = table.pack(bit32.band(bit32.bnot(v33), 4294967295))
local v6 = table.pack(bit32.band(v332[1], 65535))
local v7 = bit32.band(65535 * v6[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(v332[1], 16) + 32767 * v6[1], 65535), 16), 4294967295)
local v34 = table.pack(bit32.band(bit32.bnot(v3), 4294967295))
local v8 = table.pack(bit32.band(v34[1], 65535))
local n6 = n5 + 0 + v7 + bit32.band(62596 * v8[1] + bit32.lshift(bit32.band(62596 * bit32.rshift(v34[1], 16) + 18695 * v8[1], 65535), 16), 4294967295)
local game_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Game")
local activeEggs = ReplicatedStorage:WaitForChild("ServerData"):WaitForChild("ActiveEggs")

local function fn2(B)
	local L = bit32.bxor(444954721, 0)
	local A
	A, L = pcall, u32Trunc((u32Mul(1115083310, L) + 3588422128) + (u32Mul(3179883987, (bit32.bor(L, 44799432))) + u32Mul(3179883985, (bit32.band(L, 44799432)))))

	local I, v9 = A(function()
		return require(B())
	end)

	return (I and v9) or nil
end

local n7 = n2 * 2
local n8 = n4 - 180185261

local tbl = {
	Eggs = fn2(function()
		local I
		local ReplicatedStorage2 = ReplicatedStorage
		return ReplicatedStorage2.GameData.Eggs
	end),
	Pets = fn2(function()
		local I
		local ReplicatedStorage2 = ReplicatedStorage
		return ReplicatedStorage2.GameData.Pets
	end),
	Foods = fn2(function()
		local I
		local ReplicatedStorage2 = ReplicatedStorage
		return ReplicatedStorage2.GameData.Foods
	end),
	Shop = fn2(function()
		local I
		local ReplicatedStorage2 = ReplicatedStorage
		return ReplicatedStorage2.GameData.Shop
	end),
}

local function fn3()
	local I
	local ReplicatedStorage2 = ReplicatedStorage
	return ReplicatedStorage2.GameData.Rebirths
end

local n9 = n3 // bit32.bxor(n8, 0)
tbl.Rebirths = fn2(fn3)

tbl.EggBaskets = fn2(function()
	local I
	local ReplicatedStorage2 = ReplicatedStorage
	return ReplicatedStorage2.GameData.EggBaskets
end)

tbl.Mutations = fn2(function()
	local I
	local ReplicatedStorage2 = ReplicatedStorage
	return ReplicatedStorage2.GameData.Mutations
end)

local function fn4()
	if typeof(gethui) == "function" then
		local ok, L = pcall(gethui)
		if ok and (typeof(L) == "Instance") then
			return L
		end
	end

	local I
	local CoreGui2 = CoreGui
	return CoreGui2
end

local v9 = fn4()
local v10 = Random.new()
local str = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

local function fn5()
	local I
	local v102 = v10
	local A = v102:NextInteger(12, 20)
	v102 = table.create(A)

	for i = 1, A, 1 do
		local v103, q = v10
		local B = str
		local v11 = v103:NextInteger(1, #B)
		v103 = nil
		v103, v102[i] = str, string.sub(str, v11, v11)
	end

	return table.concat(v102)
end

local list = {}

local function fn6(I)
	local L
	table.insert(list, I)
end

local str2 = "All"

local function fn7(B)
	local Z = bit32.bxor(135623784, 0)
	if type(B) ~= "table" then
		return B
	end
	local q = rawget(B, "Instance")
	local h = typeof(q)
	Z = bit32.bxor(Z, 279606389)
	if h ~= "Instance" then
		return B
	end
	local flag2, K = false
	Z = u32Trunc((u32Mul(69228956, Z) + 663714168) + (u32Mul(4156509384, (bit32.bor(Z, 493037554))) + u32Mul(69228957, (bit32.bxor(Z, 493037554)))))

	K = function(arg)
		local flag22 = flag2
		if flag22 then
			return
		end
		flag22 = arg.Text == "None"

		if flag22 then
			flag2 = true
			local V
			local str22 = str2
			arg.Text = str22
			flag2 = false
		end
	end

	local L

	local function fn8(descendant)
		local v11 = bit32.bxor(147847961, 0)
		local v112 = v11
		local isTextLabel
		isTextLabel, v11 = descendant:IsA("TextLabel"), u32Trunc(v112 + 342306451)
		if not isTextLabel or (descendant.Name ~= "Value") then
			return
		end
		K(descendant)
		isTextLabel = nil
		isTextLabel, v11 = descendant:GetPropertyChangedSignal("Text"), u32Trunc(v11 - 37534379)

		local connection = isTextLabel:Connect(function()
			K(descendant)
		end)

		fn6(function()
			local v12 = bit32.bxor(195796890, 0)
			local v13
			v13, v12 = pcall, u32Trunc((u32Mul(878397957, v12) + 1493368641) + (u32Mul(2538171382, (bit32.bor(v12, 465230093))) + u32Mul(878397958, (bit32.bxor(v12, 465230093)))))

			v13(function()
				connection:Disconnect()
			end)
		end)
	end

	for _, descendant in ipairs(q:GetDescendants()) do
		fn8(descendant)
	end

	local connection = q.DescendantAdded:Connect(fn8)

	fn6(function()
		local v11 = bit32.bxor(122548727, 0)
		local A
		A, v11 = pcall, u32Trunc((u32Mul(404622966, v11) + 1023862950) + (u32Mul(3485721364, (bit32.bor(v11, 298706377))) + u32Mul(404622967, (bit32.bxor(v11, 298706377)))))

		A(function()
			connection:Disconnect()
		end)
	end)

	return B
end

local function fn8()
	local B = bit32.bxor(390969618, 0)
	local A, chilliHubRapCleanup
	A, chilliHubRapCleanup, B = typeof, getgenv, u32Trunc(B + 406729415)
	local genv = ((A(chilliHubRapCleanup) == "function") and getgenv()) or _G
	chilliHubRapCleanup = genv.ChilliHubRapCleanup
	A = type(chilliHubRapCleanup)
	B = u32Trunc(B + 54301051)

	if A == "function" then
		pcall(chilliHubRapCleanup)
	end

	genv.ChilliHubRapCleanup = function()
		local I
		local list2 = list
		local n10 = #list2

		for i = n10, 1, -1 do
			pcall(list[i])
		end

		table.clear(list)
	end
end

fn8()

local function fn9(I, L)
	local A
	local v11, flag2 = v, type(v.Notify) == "function"

	if flag2 then
		pcall(v.Notify, I, L, 5)
	end
end

local tbl2 = { Toggle = function(B, L)
	local A = bit32.bxor(488224972, 0)
	local Z
	Z, A = type, u32Trunc(A + 338916698)
	if Z(B) ~= "table" then
		return L == true
	end

	local ok, q = pcall(function()
		local controller = B._controller
		return ((type(controller) == "table") and (type(controller.GetValue) == "function")) and controller.GetValue()
	end)

	if ok and (type(q) == "boolean") then
		return q
	end
	q = {"Get", "GetValue"}

	for i, v11 in ipairs(q) do
		local v12 = bit32.bxor(24450925, 0)
		ok = nil
		ok, v12 = pcall, u32Trunc((u32Mul(849248436, v12) + 1435284360) + (u32Mul(2596470424, (bit32.bor(v12, 178285482))) + u32Mul(849248437, (bit32.bxor(v12, 178285482)))))

		i, Z = ok(function()
			return B[v11]
		end)

		if i and (type(Z) == "function") then
			local ok2, result = pcall(Z, B)
			if ok2 and (type(result) == "boolean") then
				return result
			end
		end
	end

	return L == true
end }

local function fn10(I)
	local kMap = {}

	if type(I) == "table" then
		for k, v11 in pairs(I) do
			if (v11 == true) and (type(k) == "string") then
				kMap[k] = true
			elseif type(v11) == "string" then
				kMap[v11] = true
			end
		end
	end

	return kMap
end

local n10 = n9 - n7
local tbl3 = {}

local function fn11()
	local B, nameList, T = bit32.bxor(45689446, 0), {"Common", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Ethereal"}
	local tbl32 = tbl3
	tbl32.RarityOrder = nameList
	tbl32 = tbl3
	tbl32.RarityRank = {}
	tbl32 = ipairs

	for k, v11 in tbl32(nameList) do
		local tbl33 = tbl3
		tbl33.RarityRank[v11] = k
	end

	tbl32 = tbl3
	tbl32.RarityChoices = {"Any"}
	tbl32 = ipairs

	for _, v11 in tbl32(nameList) do
		table.insert(tbl3.RarityChoices, v11)
	end

	local tbl33, rarityColors, color3FromRGB = tbl3, {Common = Color3.fromRGB(214, 218, 228), Rare = Color3.fromRGB(96, 170, 255)}
	color3FromRGB, B = Color3.fromRGB, u32Trunc(B + 385745893)
	rarityColors.Epic = color3FromRGB(190, 110, 255)
	rarityColors.Legendary = Color3.fromRGB(255, 196, 66)
	rarityColors.Mythic = Color3.fromRGB(255, 82, 90)
	rarityColors.Divine = Color3.fromRGB(255, 240, 150)
	rarityColors.Ethereal = Color3.fromRGB(125, 225, 255)
	tbl33.RarityColors = rarityColors
	nameList = tbl3
	nameList.FlySpeed = 1000
	nameList = tbl3
	nameList.Status = "Idle"
	tbl32 = tbl3
	tbl32.Movement = {Owner = nil}
	local v11
	local tbl34 = tbl3

	tbl34.Character = function()
		local O
		local localPlayer2 = localPlayer
		return localPlayer2.Character
	end

	local tbl35 = tbl3

	tbl35.Humanoid = function()
		local O
		local localPlayer2 = localPlayer
		local character = localPlayer2.Character
		localPlayer2 = character and (character:FindFirstChildOfClass("Humanoid"))
		if localPlayer2 and (localPlayer2.Health > 0) then
			return localPlayer2
		end
		return nil
	end

	local tbl36 = tbl3

	tbl36.Root = function()
		local O
		local localPlayer2 = localPlayer
		local character = localPlayer2.Character
		localPlayer2 = character and (character:FindFirstChild("HumanoidRootPart"))
		if localPlayer2 and localPlayer2:IsDescendantOf(workspace) then
			return localPlayer2
		end
		return nil
	end

	color3FromRGB = nil

	color3FromRGB, tbl3.Plot = tbl3, function()
		local parent, F = v11 and v11.Parent

		if parent then
			local data = v11:FindFirstChild("Data")
			local owner, _ = data and (data:FindFirstChild("Owner"))

			if owner then
				data = nil
				data, _ = localPlayer, owner.Value == localPlayer
			else
				_ = owner
			end

			if _ then
				owner = v11
				return owner
			end
		end

		v11 = nil
		parent = workspace:FindFirstChild("Plots")
		if not parent then
			return nil
		end
		local v12, children = ipairs, table.pack(parent:GetChildren())

		for k, v13 in v12(table.unpack(children, 1, children.n)) do
			parent = v13:FindFirstChild("Data")
			local owner, W = parent and (parent:FindFirstChild("Owner"))

			if owner then
				k = nil
				k, W = localPlayer, owner.Value == localPlayer
			else
				W = owner
			end

			if W then
				v11 = v13
				return v13
			end
		end

		return nil
	end

	local tbl37 = tbl3

	tbl37.PlotBase = function()
		local tbl38 = tbl3
		local O = tbl38.Plot()
		tbl38 = O and (O:FindFirstChild("Baseplate"))
		if tbl38 and (tbl38:IsA("BasePart")) then
			return tbl38
		end
		return nil
	end

	local tbl38 = tbl3

	tbl38.PlotTop = function()
		local tbl39 = tbl3
		local O = tbl39.PlotBase()
		if not O then
			return nil
		end
		return O.Position + Vector3.new(0, O.Size.Y / 2, 0)
	end

	tbl33 = nil

	tbl33, tbl3.RandomPlotPoint = tbl3, function(arg, O, F)
		local tbl39 = tbl3
		local _ = tbl39.PlotBase()
		if not _ then
			return nil
		end
		local N, b, m, vector = math.max(1, (_.Size.X / 2) - arg), math.max(1, (_.Size.Z / 2) - arg), _.Position.Y + (_.Size.Y / 2)

		for i = 1, 24, 1 do
			local P
			tbl39, i, arg = v10, v10, Vector3.new(v10:NextNumber(-N, N), 0, v10:NextNumber(-b, b))
			local Z = _.CFrame:PointToWorldSpace(arg)
			local vector2, W = Vector3.new(Z.X, m, Z.Z), true

			if O then
				for _, v12 in ipairs(O) do
					if Vector3.new(v12.X - vector2.X, 0, v12.Z - vector2.Z).Magnitude < F then
						W = false
						break
					end
				end
			else
			end

			if W then
				return vector2
			end
			vector = vector or vector2
		end

		return vector
	end

	local tbl39 = tbl3

	tbl39.Cash = function()
		local v12
		local localPlayer2 = localPlayer
		local savedData = localPlayer2:FindFirstChild("SavedData")
		localPlayer2 = savedData and (savedData:FindFirstChild("Cash"))
		return (localPlayer2 and tonumber(localPlayer2.Value)) or 0
	end

	nameList = nil

	nameList, tbl3.Saved = tbl3, function(arg)
		local Z
		local localPlayer2 = localPlayer
		local savedData = localPlayer2:FindFirstChild("SavedData")
		localPlayer2 = savedData and (savedData:FindFirstChild(arg))
		return (localPlayer2 and localPlayer2.Value) or nil
	end

	color3FromRGB = nil

	color3FromRGB, tbl3.Fire = tbl3, function(arg, ...)
		local pack = bit32.bxor(349617676, 0)
		local pack2 = pack
		local F
		local game_2 = game_
		local q = game_2:FindFirstChild(arg)
		pack = bit32.bxor(pack2, 456345114)
		if not q or not q:IsA("RemoteEvent") then
			return false
		end
		pack2 = nil
		pack2, pack = table.pack, u32Trunc((u32Mul(1255102848, pack) + 2471830272) + (u32Mul(3039864449, (bit32.bor(pack, 419778466))) + u32Mul(3039864447, (bit32.band(pack, 419778466)))))
		local v12 = pack2(...)

		return pcall(function()
			q:FireServer(table.unpack(v12, 1, v12.n))
		end)
	end

	tbl33 = nil

	tbl33, tbl3.EggData = tbl3, function(arg)
		local Z
		local flag2 = tbl
		local eggs = flag2.Eggs
		flag2 = ((type(eggs) == "table") and eggs[tostring(arg)]) or nil
		return ((type(flag2) == "table") and flag2) or nil
	end

	tbl32 = nil

	tbl32, tbl3.EggRank = tbl3, function(arg)
		local tbl310 = tbl3
		local q = tbl310.EggData(arg)
		tbl310 = nil

		if q then
			arg = tbl3
			tbl310 = arg.RarityRank[tostring(q.Rarity)]
		else
			tbl310 = q
		end

		return tbl310 or 0
	end

	color3FromRGB = nil

	color3FromRGB, tbl3.EggRarity = tbl3, function(arg)
		local tbl310 = tbl3
		local q = tbl310.EggData(arg)
		return (q and tostring(q.Rarity)) or "Common"
	end

	color3FromRGB = nil

	color3FromRGB, tbl3.EggLuck = tbl3, function(arg)
		local tbl310 = tbl3
		local q = tbl310.EggData(arg)
		return (q and tonumber(q.Luck)) or 0
	end

	local tbl310, Z = tbl3

	tbl310.PetAging = fn2(function()
		local v12
		local ReplicatedStorage2 = ReplicatedStorage
		return ReplicatedStorage2.GameServices.PetAging
	end)

	tbl310 = nil

	tbl310, tbl3.EggWeightText = tbl3, function(arg)
		arg = tonumber(arg) or 0
		local tbl311 = tbl3
		local petAging, V = tbl311.PetAging

		if (type(petAging) == "table") and (type(petAging.InflateEggWeight) == "function") then
			local ok, F = pcall(petAging.InflateEggWeight, arg)
			V = if ok and (type(F) == "number") then F else arg
		else
			V = arg
		end

		petAging = {"", "K", "M", "B", "T", "Qa"}
		tbl311 = 1

		while (V >= 1000) and (tbl311 < #petAging) do
			V, tbl311 = V / 1000, tbl311 + 1
		end

		return string.format("%.2f", math.floor((V * 100) + 0.5) / 100) .. (petAging[tbl311] .. " KG")
	end

	nameList = nil

	nameList, tbl3.EggShownWeight = tbl3, function(arg)
		arg = tonumber(arg) or 0
		local tbl311 = tbl3
		local petAging = tbl311.PetAging

		if (type(petAging) == "table") and (type(petAging.InflateEggWeight) == "function") then
			local ok, V = pcall(petAging.InflateEggWeight, arg)
			if ok and (type(V) == "number") then
				return V
			end
		end

		return arg
	end

	rarityColors = tbl3
	rarityColors.MinEggWeight = 0
	nameList = nil

	nameList, tbl3.EggHeavyEnough = tbl3, function(arg, q)
		if q then
		else
			local tbl311 = tbl3
			q = tbl311.MinEggWeight
		end

		local K, V = q <= 0

		if K then
			V = K
		else
			local tbl311 = tbl3
			V = tbl311.EggShownWeight(arg) >= q
		end

		return V
	end

	local tbl311 = tbl3

	tbl311.WeightSlider = function(arg, q)
		local K = bit32.bxor(316391088, 0)
		local options = K
		local O, F = 1000, 0
		K = u32Trunc(options + 200216811)
		local W = 7
		K = u32Trunc(K + 88226854)

		local function fn12(_)
			if _ <= 0 then
				return 0
			end
			local N = 10 ^ (math.floor(math.log10(_)) - 2)
			return math.floor((_ / N) + 0.5) * N
		end

		local function _(N)
			N = math.clamp(tonumber(N) or 0, 0, O)
			if N <= 0 then
				return 0
			end
			return fn12(10 ^ (F + (((W - F) * N) / O)))
		end

		local function fn13(N)
			N = tonumber(N) or 0
			if N <= 0 then
				return 0
			end
			local b = ((math.log10(N) - F) / (W - F)) * O
			return math.clamp(math.floor((b * 100) + 0.5) / 100, 0, O)
		end

		local function fn14(arg2)
			local stringFormat, b = string.format, ((arg2 >= 100) and "%.0f") or (((arg2 >= 10) and "%.1f") or "%.2f")
			local m = stringFormat(b, arg2)

			if string.find(m, ".", 1, true) then
				m = string.gsub(m, "0+$", "")
				m = string.gsub(m, "%.$", "")
			else
			end

			return m
		end

		local function fn15(N)
			local b = _(N)

			if b <= 0 then
				return "Off"
			elseif b < 1000 then
				return fn14(b) .. " KG"
			elseif b < 1000000 then
				return fn14(b / 1000) .. "K KG"
			end

			return fn14(b / 1000000) .. "M KG"
		end

		local unitMultipliers = {k = 1000, m = 1000000, b = 1000000000}

		local function N(b)
			local m = string.lower(string.gsub(tostring(b or ""), "[%s,]", ""))
			m = string.gsub(m, "kg$", "")
			if (m == "") or (m == "off") then
				return 0
			end
			local match, p = string.match(m, "^([%d%.]+)([kmb]?)$")
			match = tonumber(match)
			if not match then
				return nil
			end
			return fn13(match * (unitMultipliers[p] or 1))
		end

		options = {Name = q.Name, SubOf = q.SubOf, Min = 0, Max = O, Default = 0, AllowDecimals = true, Increment = 0.01, ValueFormat = fn15, ValueParse = N, Callback = function(arg2)
			q.OnRaw(_(arg2))
		end}

		return arg:CreateSlider(options), fn13
	end

	local tbl312 = tbl3

	tbl312.WeightStep = function(arg)
		arg = tonumber(arg) or 0
		if arg <= 0 then
			return 0
		end
		return math.clamp(math.floor((((math.log10(arg) / 7) * 1000) * 100) + 0.5) / 100, 0, 1000)
	end

	tbl310 = nil

	tbl310, tbl3.EggBreakSeconds = tbl3, function(arg)
		local tbl313 = tbl3
		local K = tbl313.EggData(arg)
		return (K and tonumber(K.BreakSeconds)) or 30
	end

	rarityColors = nil

	rarityColors, tbl3.PetData = tbl3, function(arg)
		local q
		local flag2 = tbl
		local pets = flag2.Pets
		flag2 = ((type(pets) == "table") and pets[tostring(arg)]) or nil
		return ((type(flag2) == "table") and flag2) or nil
	end

	nameList = nil

	nameList, tbl3.MutationBonus = tbl3, function(arg)
		local q
		local flag2 = tbl
		local mutations = flag2.Mutations
		flag2 = (((type(mutations) == "table") and arg) and mutations[tostring(arg)]) or nil
		return 1 + ((((type(flag2) == "table") and tonumber(flag2.StatMultiplier)) or 0) / 100)
	end

	color3FromRGB = nil

	color3FromRGB, tbl3.PetScore = tbl3, function(arg, q, K)
		local tbl313 = tbl3
		local l, tbl314 = tbl313.PetData(arg), tbl3
		return (((l and tonumber(l.Income)) or 1) * math.max(tonumber(q) or 1, 0.1)) * tbl314.MutationBonus(K)
	end

	local tbl313 = tbl3

	tbl313.PetNameOf = function(arg)
		local attribute = arg:GetAttribute("PetName")
		if (type(attribute) == "string") and (attribute ~= "") then
			return attribute
		end
		return (string.gsub(arg.Name, "%s*%[.*$", ""))
	end

	tbl32 = nil

	tbl32, tbl3.Tools = tbl3, function(arg)
		local list2, K = {}
		local localPlayer2 = localPlayer
		local backpack = localPlayer2:FindFirstChildOfClass("Backpack")
		local l

		if backpack then
			local v12, children = ipairs, table.pack(backpack:GetChildren())

			for k, v13 in v12(table.unpack(children, 1, children.n)) do
				localPlayer2 = v13:IsA("Tool")
				k = nil

				if localPlayer2 then
					local CollectionService2 = CollectionService
					k = (CollectionService2:HasTag(v13, arg))
				else
					k = localPlayer2
				end

				if k then
					table.insert(list2, v13)
				end
			end
		end

		backpack = localPlayer
		localPlayer2 = backpack.Character

		if localPlayer2 then
			local v12, children = ipairs, table.pack(localPlayer2:GetChildren())

			for k, v13 in v12(table.unpack(children, 1, children.n)) do
				k = v13:IsA("Tool")
				backpack = nil

				if k then
					local CollectionService2 = CollectionService
					backpack = (CollectionService2:HasTag(v13, arg))
				else
					backpack = k
				end

				if backpack then
					table.insert(list2, v13)
				end
			end
		end

		return list2
	end

	tbl33 = nil

	tbl33, tbl3.Equip = tbl3, function(arg)
		local q = bit32.bxor(254246885, 0)
		local character = q
		local tbl314 = tbl3
		q = u32Trunc((u32Mul(294739373, character) + 1123098831) + (u32Mul(4000227924, (bit32.bor(character, 7278571))) + u32Mul(4000227922, (bit32.band(character, 7278571)))))
		local x = tbl314.Humanoid()
		local l
		tbl314 = localPlayer
		character = tbl314.Character
		if (not x or not arg) or not character then
			return false
		end

		if arg.Parent == character then
			return true
		end
		tbl314 = nil
		tbl314, q = pcall, bit32.bxor(q, 173695343)

		tbl314(function()
			x:EquipTool(arg)
		end)

		tbl314 = os.clock() + 1

		while (arg.Parent ~= character) and (os.clock() < tbl314) do
			local v12
			local RunService2 = RunService
			RunService2.Heartbeat:Wait()
		end

		return arg.Parent == character
	end

	local tbl314 = tbl3

	tbl314.Unequip = function()
		local tbl315 = tbl3
		local q = tbl315.Humanoid()

		if q then
			local K = bit32.bxor(132628291, 0)
			tbl315 = K
			local V
			V, K = pcall, u32Trunc((u32Mul(708780522, tbl315) + 1593795892) + (u32Mul(3586186775, (bit32.bor(tbl315, 332341234))) + u32Mul(3586186773, (bit32.band(tbl315, 332341234)))))

			V(function()
				q:UnequipTools()
			end)
		end
	end

	local tbl315 = tbl3

	tbl315.BasketCount = function()
		local v12
		local localPlayer2 = localPlayer
		local basket = localPlayer2:FindFirstChild("Basket")
		return (basket and #basket:GetChildren()) or 0
	end

	local tbl316 = tbl3

	tbl316.BasketCapacity = function()
		local tbl317 = tbl3
		local EquippedEggBasket = tbl317.Saved("EquippedEggBasket")
		local K
		tbl317 = tbl
		local eggBaskets = tbl317.EggBaskets
		tbl317 = (((type(eggBaskets) == "table") and EquippedEggBasket) and eggBaskets[tostring(EquippedEggBasket)]) or nil
		eggBaskets = ((type(tbl317) == "table") and tonumber(tbl317.Capacity)) or 1
		if (eggBaskets == (1 / 0)) or (eggBaskets > 50) then
			return 50
		end
		return math.max(1, eggBaskets)
	end

	nameList = nil

	nameList, tbl3.BasketDeadline = tbl3, function()
		local v12
		local localPlayer2 = localPlayer
		local basket = localPlayer2:FindFirstChild("Basket")
		localPlayer2 = nil

		if basket then
			for i, child in ipairs(basket:GetChildren()) do
				i = tonumber(child:GetAttribute("BreakAt"))
				localPlayer2 = if i and ((localPlayer2 == nil) or (i < localPlayer2)) then i else localPlayer2
			end
		else
		end

		return localPlayer2
	end

	tbl33 = nil

	tbl33, tbl3.Claim = tbl3, function(owner)
		local tbl317 = tbl3
		local movement = tbl317.Movement
		if (movement.Owner == nil) or (movement.Owner == owner) then
			movement.Owner = owner
			return true
		end
		return false
	end

	tbl32 = nil

	tbl32, tbl3.Release = tbl3, function(arg)
		local tbl317 = tbl3
		local h = tbl317.Movement.Owner == arg

		if h then
			arg = tbl3
			arg.Movement.Owner = nil
		end
	end

	local descendantMap = {}

	local function setNoclip(h)
		local K
		local localPlayer2 = localPlayer
		local character = localPlayer2.Character
		if not character then
			return
		end

		for _, descendant in ipairs(character:GetDescendants()) do
			if descendant:IsA("BasePart") then
				if h then
					if descendantMap[descendant] == nil then
						descendantMap[descendant] = descendant.CanCollide
					end

					descendant.CanCollide = false
				elseif descendantMap[descendant] ~= nil then
					descendant.CanCollide = descendantMap[descendant]
				end
			end
		end

		if not h then
			table.clear(descendantMap)
		end
	end

	tbl33 = tbl3
	tbl33.SetNoclip = setNoclip
	nameList = tbl3
	nameList.CruiseHeight = 250
	tbl310 = tbl3
	tbl310.VolcanoTop = {Center = Vector3.new(-5103, 41405, -3490), Half = Vector2.new(150, 156), BaseY = 40281, BaseRadius = 840}

	local function fn12()
		local volcano = workspace:FindFirstChild("Volcano")
		local volcanoTop = volcano and (volcano:FindFirstChild("VolcanoTop"))
		volcano = volcanoTop and (volcanoTop:IsA("BasePart"))

		if volcano then
			local tbl317 = tbl3
			tbl317.VolcanoTop.Center = volcanoTop.Position
			tbl317 = tbl3
			tbl317.VolcanoTop.Half = Vector2.new(volcanoTop.Size.X / 2, volcanoTop.Size.Z / 2)
		end

		volcanoTop = tbl3
		return volcanoTop.VolcanoTop
	end

	local tbl317 = tbl3

	tbl317.InVolcanoArea = function(h)
		local K = fn12()
		local vector = Vector3.new(h.X - K.Center.X, 0, h.Z - K.Center.Z)
		if (h.Y >= (K.Center.Y + 20)) or (h.Y < (K.BaseY - 40)) then
			return false
		end
		local x, f = math.min(K.Half.X, K.Half.Y), math.clamp((h.Y - K.BaseY) / math.max(1, K.Center.Y - K.BaseY), 0, 1)
		h = K.BaseRadius + ((x - K.BaseRadius) * f)
		return vector.Magnitude < (h - 30)
	end

	local function h(vector, vector2)
		if (Vector3.new(vector2.X - vector.X, 0, vector2.Z - vector.Z).Magnitude < 80) and (math.abs(vector2.Y - vector.Y) < 30) then
			return {vector2}
		end
		local tbl318, x, tbl319 = tbl3, math.max(vector.Y, vector2.Y) + tbl3.CruiseHeight, tbl3
		local vector3 = tbl319.InVolcanoArea(vector)
		tbl319 = nil

		if vector3 then
			tbl319 = vector3
		else
			local tbl320 = tbl3
			tbl319 = tbl320.InVolcanoArea(vector2)
		end

		x = if tbl319 then math.max(x, fn12().Center.Y + 60) else x
		vector3 = (vector + vector2) / 2
		return {Vector3.new(vector3.X, x, vector3.Z), vector2}
	end

	tbl310 = nil

	tbl310, tbl3.TravelTime = tbl3, function(K, V)
		local tbl318, f = K, 0

		for _, v12 in ipairs(h(K, V)) do
			tbl318, f = v12, f + (v12 - tbl318).Magnitude
		end

		tbl318, V = tbl3, math.max(tbl3.FlySpeed, 20)
		return f / V
	end

	tbl32 = nil

	tbl32, tbl3.FlyTo = tbl3, function(K, V, x)
		local f, tbl318 = bit32.bxor(509903669, 0), tbl3
		local O = tbl318.Root()
		if not O or (typeof(K) ~= "Vector3") then
			return false
		end
		x = x or 3
		if (O.Position - K).Magnitude <= x then
			return true
		end
		tbl318 = nil
		f, tbl318 = bit32.bxor(f, 54601621), h(O.Position, K)
		local tbl319, n11 = tbl3, (os.clock() + tbl3.TravelTime(O.Position, K)) + 6
		f = bit32.bxor(f, 73721150)
		setNoclip(true)
		local v12
		local RunService2 = RunService

		local function F()
			local W
			local localPlayer2 = localPlayer
			local character = localPlayer2.Character
			if not character then
				return
			end

			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then
					descendant.CanCollide = false
				end
			end
		end

		local connection = RunService2.Stepped:Connect(F)
		F, RunService2 = 1, false

		while os.clock() < n11 do
			local v13 = bit32.bxor(403387006, 0)
			if V and (V()) then
				break
			end
			local RunService3 = RunService
			local _, tbl320 = RunService3.Heartbeat:Wait(), tbl3
			O = tbl320.Root()
			if not O then
				break
			end
			tbl320, RunService3 = tbl318[F], F == #tbl318
			local b = tbl320 - O.Position
			tbl320 = b.Magnitude
			v13 = u32Trunc((v13 + 3442749056) + (u32Mul(4294967294, (bit32.band(v13, 218548909))) + (326973567 + 743793582)))

			if tbl320 <= ((RunService3 and x) or 2) then
				if RunService3 then
					RunService2 = true
					break
				end
				F += 1
				continue
			end

			local tbl321, n12 = tbl3, math.min(tbl320, math.max(tbl3.FlySpeed, 20) * _)
			RunService3 = nil
			RunService3, v13 = Vector3.new, bit32.bxor(v13, 158644916)
			tbl320 = RunService3(b.X, 0, b.Z)
			local cframe = ((tbl320.Magnitude > 0.1) and CFrame.lookAt(Vector3.new(0, 0, 0), tbl320.Unit)) or O.CFrame.Rotation

			pcall(function()
				O.CFrame = CFrame.new(O.Position + (b.Unit * n12)) * cframe
				O.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				O.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)
		end

		connection:Disconnect()
		setNoclip(false)
		tbl318 = tbl3
		O = tbl318.Root()

		if O then
			pcall(function()
				O.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end)

			RunService2 = if (O.Position - K).Magnitude <= (x + 1) then true else RunService2
		else
		end

		return RunService2
	end

	rarityColors = nil

	rarityColors, tbl3.MoveLine = tbl3, function(arg, K, V)
		local x, tbl318 = bit32.bxor(81050845, 0), tbl3
		local l = tbl318.Root()
		if not l or (typeof(arg) ~= "Vector3") then
			return false
		end
		setNoclip(true)
		local O
		tbl318 = RunService
		x = bit32.bxor(x, 138891685)
		local stepped
		stepped, x = tbl318.Stepped, bit32.bxor(x, 398319705)

		local connection, position = stepped:Connect(function()
			local W
			local localPlayer2 = localPlayer
			local character = localPlayer2.Character
			if not character then
				return
			end

			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then
					descendant.CanCollide = false
				end
			end
		end), l.Position

		local W, _, N = math.max(0.05, (arg - position).Magnitude / math.max(tonumber(K) or 60, 1)), 0, true

		while _ < W do
			local v12 = bit32.bxor(57644833, 0)
			if V and (V()) then
				N = false
				break
			end
			stepped = RunService
			v12 = u32Trunc((u32Mul(685186496, v12) + 427108544) + (u32Mul(2924594304, (bit32.bor(v12, 468045877))) + u32Mul(685186497, (bit32.bxor(v12, 468045877)))))
			_ += stepped.Heartbeat:Wait()
			tbl318 = tbl3
			l = tbl318.Root()
			v12 = bit32.bxor(v12, 231985077)
			if not l then
				N = false
				break
			end
			local v13 = position:Lerp(arg, math.min(1, _ / W))

			pcall(function()
				l.CFrame = CFrame.new(v13) * l.CFrame.Rotation
				l.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				l.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)
		end

		connection:Disconnect()
		setNoclip(false)
		return N
	end

	tbl33 = nil

	tbl33, tbl3.NeedsVolcano = tbl3, function(arg)
		local tbl318 = tbl3
		local V = tbl318.EggData(arg)
		return (V ~= nil) and (V.RequiresVolcano == true)
	end

	tbl310 = tbl3
	tbl310.DoorCFrame = CFrame.new(-4939.84, 41284.7, -3679.98, 0.746841, 0.03653, -0.663999, 0.066451, 0.989393, 0.129173, 0.661675, -0.140595, 0.736491)
	local tbl318 = tbl3

	tbl318.VolcanoDoor = function()
		local volcano = workspace:FindFirstChild("Volcano")
		local volcanoEntrance = volcano and (volcano:FindFirstChild("VolcanoEntrance"))
		volcano = volcanoEntrance and (volcanoEntrance:IsA("BasePart"))

		if volcano then
			local tbl319 = tbl3
			tbl319.DoorCFrame = volcanoEntrance.CFrame
		end

		volcanoEntrance = tbl3
		volcano = volcanoEntrance.DoorCFrame
		volcanoEntrance = Vector3.new(volcano.LookVector.X, 0, volcano.LookVector.Z)
		if volcanoEntrance.Magnitude < 0.01 then
			return nil, nil
		end
		volcanoEntrance = volcanoEntrance.Unit
		return volcano.Position + (volcanoEntrance * 30), volcano.Position - (volcanoEntrance * 40)
	end

	local tbl319 = tbl3

	tbl319.VolcanoHover = function()
		return fn12().Center + Vector3.new(0, 60, 0)
	end

	rarityColors = nil

	rarityColors, tbl3.VolcanoApproach = tbl3, function(arg, arg2, arg3)
		local K
		local localPlayer2 = localPlayer
		local V, x = localPlayer2:GetAttribute("InVolcano") ~= true

		if V then
			x = V
		else
			localPlayer2 = localPlayer
			x = localPlayer2:GetAttribute("VolcanoValidated") ~= true
		end

		if x then
			localPlayer2 = tbl3
			local tbl320, G = localPlayer2.VolcanoDoor()
			V = not tbl320
			if V then
				local tbl321 = tbl3
				return tbl321.FlyTo(arg, arg2, arg3)
			end
			local tbl321 = tbl3
			tbl321.Status = "Going to the volcano door"
			tbl321 = tbl3
			if not tbl321.FlyTo(tbl320, arg2, 4) then
				return false
			end
			tbl321 = tbl3
			tbl321.Status = "Entering the lair through its door"
			tbl320 = tbl3
			if not tbl320.MoveLine(G, 40, arg2) then
				return false
			end
		end

		V = tbl3
		V.Status = "Going down to the Volcanic Egg"
		x = tbl3
		x.MoveLine(arg, 250, arg2)
		localPlayer2 = tbl3
		V = localPlayer2.Root()
		return (V ~= nil) and ((V.Position - arg).Magnitude <= ((arg3 or 3) + 2))
	end

	tbl32 = nil

	tbl32, tbl3.VolcanoExit = tbl3, function(arg)
		local tbl320 = tbl3
		local v12, v13 = tbl320.VolcanoDoor()
		if not v12 then
			return false
		end
		tbl320 = tbl3
		tbl320.Status = "Escaping the lair through its door"
		tbl320 = tbl3
		if not tbl320.MoveLine(v13, 250, arg) then
			return false
		end
		tbl320 = tbl3
		if not tbl320.MoveLine(v12, 40, arg) then
			return false
		end
		return true
	end

	local tbl320 = tbl3

	tbl320.FirePrompt = function(arg)
		local L = bit32.bxor(148812308, 0)
		local A = L
		local flag2
		L, flag2 = u32Trunc(A + 264615771), not arg or not arg:IsA("ProximityPrompt")
		if flag2 then
			return false
		end
		A = nil
		A, L = typeof, u32Trunc(L - 199952989)
		if A(fireproximityprompt) == "function" then
			return pcall(fireproximityprompt, arg)
		end

		return pcall(function()
			arg:InputHoldBegin()
			task.wait(arg.HoldDuration + 0.1)
			arg:InputHoldEnd()
		end)
	end

	local I

	fn6(function()
		setNoclip(false)
	end)
end

fn11()
local v11 = defaultTab:CreateSection({ Name = "Farm Status", Expanded = true })
local v12 = defaultTab:CreateSection({ Name = "Auto Collect Eggs", Expanded = true })
local v13 = defaultTab:CreateSection({ Name = "Auto Place & Hatch", Expanded = false })
local v14 = defaultTab:CreateSection({ Name = "Auto Pets", Expanded = false })
local v15 = defaultTab:CreateSection({ Name = "Auto Shop", Expanded = false })
local v16 = defaultTab:CreateSection({ Name = "Auto Progress", Expanded = false })
local n11 = n7 - 3202184630

local tbl4 = {
	Collect = nil,
	Plant = nil,
	Hatch = nil,
	Place = nil,
	Swap = nil,
	Feed = nil,
	Busy = false,
	Manual = {},
	Carried = {},
	Target = nil,
	TargetManual = false,
	Dropped = nil,
	LastPickupAt = 0,
}

local n102 = bit32.bxor(n10, n11)
tbl4.Relaying = false
tbl4.DipOn = false
tbl4.DipMinRank = 0

local function fn12()
	local B = bit32.bxor(171821349, 0)
	local h
	local v112 = v11
	local L = v112:CreateText({Name = "Farm Status", Text = "Idle"})
	B = u32Trunc(B + 459039838)
	local status
	B = u32Trunc(B - 214111027)
	local I
	v112 = RunService

	local connection = v112.Heartbeat:Connect(function()
		local v17
		local tbl32 = tbl3
		local A = tbl32.Status ~= status

		if A then
			tbl32 = tbl3
			status = tbl32.Status
			local flag2 = L and (type(L.Set) == "function")

			if flag2 then
				pcall(L.Set, L, status)
			end
		end
	end)

	local v17

	fn6(function()
		connection:Disconnect()
	end)
end

fn12()
local names = {}

local function fn13()
	local B, q, h, eggs, K = bit32.bxor(128622297, 0), {}
	eggs, B, K = type, bit32.bxor(B, 138507007), tbl
	K = eggs(tbl.Eggs) == "table"

	if K then
		local V, x = pairs, tbl
		eggs = x.Eggs

		for k, egg in V(eggs) do
			x = type(egg) == "table"

			if x then
				local insert, tbl5, g = table.insert, {Name = k}
				local tbl32 = tbl3
				tbl5.Rank = tbl32.RarityRank[tostring(egg.Rarity)] or 0
				tbl5.Luck = tonumber(egg.Luck) or 0
				insert(q, tbl5)
			end
		end
	end

	eggs = nil
	eggs, B = table, u32Trunc((u32Mul(1381030139, B) + 4023332417) + (u32Mul(2, (bit32.bor(B, 271634879))) + (1381030140 + u32Mul(1381030140, (bit32.bnot(B))))))

	eggs.sort(q, function(I, arg)
		if I.Rank ~= arg.Rank then
			return I.Rank > arg.Rank
		end
		return I.Luck > arg.Luck
	end)

	K = ipairs

	for _, v17 in K(q) do
		local v18
		table.insert(names, v17.Name)
	end
end

fn13()

local function fn14()
	local B, y = bit32.bxor(349404453, 0), {}
	B = u32Trunc(B + 117581611)
	y[1], y[2], y[3], y[4], y[5] = "Highest Luck", "Highest Rarity", "Nearest", "Farthest", "Heaviest"
	local t, l = 0, {}
	local O, nameMap, W = y[2], {}, 3
	B = u32Trunc(B + 387481868)

	local function fn15(_)
		local N
		local localPlayer2 = localPlayer
		local attribute = localPlayer2:GetAttribute("CollectedEggs")
		return ((type(attribute) == "string") and (attribute ~= "")) and (string.find(attribute, tostring(_) .. ",", 1, true) ~= nil)
	end

	local rebirth, N = {On = false, Min = 10, Need = false, Pet = nil, Done = 0, Cap = 6, Owned = false, Chances = {}, Key = "", Status = "Off"}
	local tbl42 = tbl4
	tbl42.Rebirth = rebirth
	local tbl43 = tbl4

	tbl43.RebirthChance = function(b)
		if not rebirth.On or not rebirth.Need then
			return nil
		end
		local m = rebirth.Chances[b]
		if m and ((m * 100) >= rebirth.Min) then
			return m
		end
		return nil
	end

	local tbl44 = tbl4

	tbl44.AutoOn = function()
		local b
		local tbl22 = tbl2
		local tbl45, collect = tbl4, tbl22.Toggle(tbl4.Collect, false) or (rebirth.On and rebirth.Need)
		return collect
	end

	local b, m

	b = function(arg)
		local p = bit32.bxor(33160355, 0)
		local o = p
		local P, tbl32 = {}, tbl3
		local c, now = tbl32.PlotTop(), os.clock()
		local Y
		tbl32 = tbl2
		local tbl45, collect, i, J = tbl4, tbl32.Toggle(tbl4.Collect, false), ipairs
		tbl32 = activeEggs
		local children = table.pack(tbl32:GetChildren())
		p = u32Trunc((u32Mul(3300540067, o) + 443633670) + (u32Mul(1988854458, (bit32.bor(o, 172150338))) + u32Mul(3300540068, (bit32.bxor(o, 172150338)))))
		p = bit32.bxor(p, 75847243)

		for k, v17 in i(table.unpack(children, 1, children.n)) do
			local attribute, attribute2, attribute3, tbl33 = v17:GetAttribute("Egg"), v17:GetAttribute("Position"), v17:GetAttribute("PrivateTo"), nameMap[v17.Name]
			o, k = type(attribute) == "string"

			if o then
				tbl32 = tbl4
				k = tbl32.RebirthChance(attribute)
			else
				k = o
			end

			local attribute4, r, k2 = k or nil, (type(attribute) == "string") and (typeof(attribute2) == "Vector3")

			if r then
				k = attribute3 == nil

				if k then
					k2 = k
				else
					local u
					local localPlayer2 = localPlayer
					k2 = attribute3 == localPlayer2.UserId
				end
			else
				k2 = r
			end

			r, k = (k2 and not (tbl33 and (tbl33 > now))) and not fn15(attribute)

			if r then
				if attribute4 then
					k = attribute4
				else
					k2 = tbl3
					k = k2.EggHeavyEnough(v17:GetAttribute("Weight"))
				end
			else
				k = r
			end

			if k then
				tbl33 = tbl3
				attribute3 = tbl33.EggRank(attribute)
				k2 = attribute4 or ((collect and (attribute3 >= t)) and ((next(l) == nil) or l[attribute]))

				if k2 then
					r = nil

					if c then
						local tbl34 = tbl3
						r = tbl34.TravelTime(attribute2, c)
					else
						r = c
					end

					local tbl34 = tbl3
					local flag2 = (r or 0) < ((tbl34.EggBreakSeconds(attribute) - W) - 2)

					if flag2 then
						local insert, tbl5, tbl35 = table.insert, {Config = v17, Name = attribute, Position = attribute2, Rank = attribute3}, tbl3
						tbl5.Luck = tbl35.EggLuck(attribute) * (tonumber(v17:GetAttribute("Weight")) or 1)
						tbl5.Distance = (attribute2 - arg).Magnitude
						tbl5.Weight = tonumber(v17:GetAttribute("Weight")) or 0
						tbl5.Rebirth = attribute4 or 0
						insert(P, tbl5)
					end
				end
			end
		end

		table.sort(P, function(arg2, arg3)
			if arg2.Rebirth ~= arg3.Rebirth then
				return arg2.Rebirth > arg3.Rebirth
			end
			local v17 = O

			if v17 == y[5] then
				if arg2.Weight ~= arg3.Weight then
					return arg2.Weight > arg3.Weight
				end
				return arg2.Distance < arg3.Distance
			end

			v17 = O
			local r = v17 == y[3]

			if r then
				return arg2.Distance < arg3.Distance
			else
				v17 = O
				local flag2 = v17 == y[4]

				if flag2 then
					return arg2.Distance > arg3.Distance
				else
					local v18 = O

					if v18 == y[2] then
						if arg2.Rank ~= arg3.Rank then
							return arg2.Rank > arg3.Rank
						end

						if arg2.Luck ~= arg3.Luck then
							return arg2.Luck > arg3.Luck
						end
						return arg2.Distance < arg3.Distance
					end
				end
			end

			if arg2.Luck ~= arg3.Luck then
				return arg2.Luck > arg3.Luck
			end
			return arg2.Distance < arg3.Distance
		end)

		return P
	end

	tbl42 = nil

	tbl42, tbl4.EggMatches = tbl4, function(arg, p, o)
		local P, r, tbl32 = arg or t, p or l, tbl3
		local w, Y, i = tbl32.PlotTop(), ipairs
		tbl32 = activeEggs
		local children, J, j = table.pack(tbl32:GetChildren()), 0

		for k, v17 in Y(table.unpack(children, 1, children.n)) do
			p, tbl32, arg = v17:GetAttribute("Egg"), v17:GetAttribute("Position"), v17:GetAttribute("PrivateTo")
			local flag2, k2 = (type(p) == "string") and (typeof(tbl32) == "Vector3")

			if flag2 then
				k = arg == nil

				if k then
					k2 = k
				else
					local S
					local localPlayer2 = localPlayer
					k2 = arg == localPlayer2.UserId
				end
			else
				k2 = flag2
			end

			flag2, k = k2 and not fn15(p)

			if flag2 then
				k2 = tbl3
				k = k2.EggHeavyEnough(v17:GetAttribute("Weight"), o)
			else
				k = flag2
			end

			if k then
				flag2 = tbl3
				k2 = flag2.EggRank(p)
				local flag3 = (k2 >= P) and ((next(r) == nil) or r[p])

				if flag3 then
					local attribute

					if w then
						local tbl33 = tbl3
						attribute = tbl33.TravelTime(tbl32, w)
					else
						attribute = w
					end

					local tbl33 = tbl3
					local flag4 = (attribute or 0) < ((tbl33.EggBreakSeconds(p) - W) - 2)

					if flag4 then
						J += 1
						attribute = not j or (k2 > j.Rank)

						if attribute then
							tbl33 = tbl3
							local tbl34, n12 = tbl33.Root(), tonumber(v17:GetAttribute("Weight")) or 1
							j = {Name = p, Rank = k2, Distance = (tbl34 and (tbl32 - tbl34.Position).Magnitude) or nil, Mutation = v17:GetAttribute("Mutation")}
							tbl34 = tbl3
							j.Luck = tbl34.EggLuck(p) * n12
						else
						end
					else
					end
				else
				end
			else
			end
		end

		return J, j
	end

	local n12 = 250

	local function fn16(p, o, P)
		local r, tbl32 = bit32.bxor(262670958, 0), tbl3
		local w = tbl32.Root()
		local Y
		tbl32 = localPlayer
		local basket = tbl32:FindFirstChild("Basket")
		if not w or not basket then
			return
		end
		tbl32 = p.CFrame:PointToObjectSpace(w.Position)
		local vector = Vector3.new(tbl32.X, 0, tbl32.Z)
		vector = if vector.Magnitude < 1 then Vector3.new(0, 0, 1) else vector
		local J, RunService2, unit = p.Size.X / 2, p.Size.Z / 2, vector.Unit
		tbl32 = unit / math.max(math.abs(unit.X) / (J + 20), math.abs(unit.Z) / (RunService2 + 20))
		local vector2 = p.CFrame:PointToWorldSpace(Vector3.new(tbl32.X, 0, tbl32.Z))
		vector2 = Vector3.new(vector2.X, o.Y + 4, vector2.Z)
		o = tbl3
		o.FlyTo(vector2, P, 4)
		J = tbl3
		w = J.Root()
		if not w or ((w.Position - vector2).Magnitude > 10) then
			return
		end
		tbl32 = tbl3
		tbl32.Status = "Re-picking eggs near base"
		local n13, a = os.clock() + 0.3

		while os.clock() < n13 do
			P = tbl3
			local v17 = P.Root()

			if v17 then
				local S = bit32.bxor(479750839, 0)
				o = S
				unit, tbl32 = pcall, u32Trunc(n13)
				S = u32Trunc((1870089403 + o) + (u32Mul(1520699420, tbl32) + u32Mul(1520699420, (bit32.bnot(tbl32)))))

				local function fn17()
					v17.CFrame = CFrame.new(vector2) * v17.CFrame.Rotation
					v17.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				end

				unit(fn17)
			end

			p = RunService
			p.Heartbeat:Wait()
		end

		local childMap, S = {}
		n13 = activeEggs

		for _, child in ipairs(n13:GetChildren()) do
			childMap[child] = true
		end

		unit = {}
		r = u32Trunc(r + 289273399)
		p = {}

		for _, child in ipairs(basket:GetChildren()) do
			n13 = child:GetAttribute("Egg")

			if type(n13) == "string" then
				table.insert(p, n13)
			end
		end

		P = tbl4
		P.Relaying = true
		RunService2 = ipairs

		for _, v17 in RunService2(p) do
			n13 = tbl3
			n13.Fire("BasketDrop", v17)
		end

		local attributeMap = {}

		for _, v17 in ipairs(p) do
			attributeMap[v17] = (attributeMap[v17] or 0) + 1
		end

		local function fn17(u)
			local attribute = u:GetAttribute("Egg")
			if (type(attribute) ~= "string") or ((attributeMap[attribute] or 0) <= 0) then
				return false
			end
			attribute = u:GetAttribute("DropFrom")
			attribute = if typeof(attribute) ~= "Vector3" then u:GetAttribute("Position") else attribute
			if typeof(attribute) ~= "Vector3" then
				return false
			end
			return Vector3.new(attribute.X - vector2.X, 0, attribute.Z - vector2.Z).Magnitude < 80
		end

		J = os.clock() + 3

		while (#unit < #p) and (os.clock() < J) do
			basket = activeEggs

			for _, child in ipairs(basket:GetChildren()) do
				if (not childMap[child] and (child:GetAttribute("OriginPosition") ~= nil)) and (typeof(child:GetAttribute("Position")) == "Vector3") then
					childMap[child] = true

					if fn17(child) then
						o = child:GetAttribute("Egg")
						attributeMap[o] = attributeMap[o] - 1
						table.insert(unit, child)
					end
				end
			end

			RunService2 = RunService
			RunService2.Heartbeat:Wait()
		end

		RunService2 = ipairs

		for k, v17 in RunService2(unit) do
			p, P = v17:GetAttribute("Position"), tbl3
			k, childMap = P.BasketCount(), os.clock() + 3
			fn17 = 0

			while true do
				basket, n13 = v17.Parent ~= nil

				if basket then
					J = tbl3
					n13 = J.BasketCount() <= k
				else
					n13 = basket
				end

				if not (n13 and (os.clock() < childMap)) then
					break
				end
				tbl32 = tbl3
				o = tbl32.Root()
				local attribute = ((typeof(p) == "Vector3") and o) and ((o.Position - p).Magnitude > 12)

				if attribute then
					local tbl33 = tbl3
					tbl33.FlyTo(p + Vector3.new(0, 3, 0), nil, 5)
					fn17 = 0
				else
				end

				attribute = os.clock() >= fn17

				if attribute then
					fn17 = os.clock() + 0.1
					local tbl45 = tbl4
					tbl45.LastPickupAt = os.clock()
					tbl45 = tbl3
					tbl45.Fire("EggPickup", v17.Name)
				else
				end

				attribute = RunService
				attribute.Heartbeat:Wait()
				p = v17:GetAttribute("Position") or p
			end

			local flag2, flag3 = v17.Parent ~= nil

			if flag2 then
				k = nil
				k, flag3 = tbl4, not table.find(tbl4.Manual, v17.Name)
			else
				flag3 = flag2
			end

			if flag3 then
				table.insert(tbl4.Manual, 1, v17.Name)
			end
		end

		J = tbl4
		J.Relaying = false
	end

	tbl42 = nil

	tbl42, tbl4.Deliver = tbl4, function(p)
		local tbl32 = tbl3
		if tbl32.BasketCount() <= 0 then
			return true
		end
		tbl32 = tbl3
		local tbl33, tbl34 = tbl32.PlotTop(), tbl3
		tbl32 = tbl34.PlotBase()
		if not tbl33 or not tbl32 then
			return false
		end
		tbl34 = tbl3
		tbl34.Status = "Bringing eggs home"
		tbl34 = tbl3
		local tbl35, tbl45 = tbl34.Root(), tbl4
		tbl34 = tbl45.PickupPos or (tbl35 and tbl35.Position)
		tbl45 = tbl34 and ((tbl34 - tbl33).Magnitude > n12)

		if tbl45 then
			fn16(tbl32, tbl33, p)
			tbl35 = tbl3
			tbl35.Status = "Bringing eggs home"
		end

		tbl45 = tbl3
		tbl45.FlyTo(tbl33 + Vector3.new(0, 4, 0), p, 4)
		tbl34 = os.clock() + 3

		while true do
			tbl45 = tbl3
			if not ((tbl45.BasketCount() > 0) and (os.clock() < tbl34)) then
				break
			end
			local v17
			p = RunService
			p.Heartbeat:Wait()
		end

		tbl33 = tbl3
		tbl34 = tbl33.BasketCount() == 0

		if tbl34 then
			table.clear(tbl4.Carried)
			tbl45 = tbl4
			tbl45.PickupPos = nil
		end

		tbl33 = tbl3
		return tbl33.BasketCount() == 0
	end

	local function fn17()
		while true do
			local tbl45 = tbl4
			if not (#tbl45.Manual > 0) then
				break
			end
			local tbl46, o = tbl4
			local activeEggs2, v17 = activeEggs, activeEggs:FindFirstChild(tbl46.Manual[1])
			local attribute, attribute2, attribute3 = v17 and (v17:GetAttribute("Egg")), v17 and (v17:GetAttribute("Position")), v17 and (v17:GetAttribute("PrivateTo"))
			tbl46, tbl45 = (type(attribute) == "string") and (typeof(attribute2) == "Vector3")

			if tbl46 then
				local w = attribute3 == nil

				if w then
					tbl45 = w
				else
					local v18
					local localPlayer2 = localPlayer
					tbl45 = attribute3 == localPlayer2.UserId
				end
			else
				tbl45 = tbl46
			end

			if tbl45 then
				return {Config = v17, Name = attribute, Position = attribute2, Manual = true}
			end
			table.remove(tbl4.Manual, 1)
		end

		return nil
	end

	local function fn18(p)
		local tbl45, pos = tbl4, table.find(tbl4.Manual, p)

		if pos then
			table.remove(tbl4.Manual, pos)
		end
	end

	tbl42 = nil

	tbl42, tbl4.AutoPlan = tbl4, function(p)
		local tbl45 = tbl4
		if not tbl45.AutoOn() then
			return {}
		end
		return b(p)
	end

	local p, tbl45 = 130

	tbl45, tbl4.InstantTo = tbl4, function(P)
		local tbl32 = tbl3
		local c = tbl32.Root()
		if not c then
			return false
		end
		c.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		c.CFrame = CFrame.new(P)
		local r
		P = RunService
		P.Heartbeat:Wait()
		return true
	end

	tbl45 = nil

	tbl45, tbl4.InstantHome = tbl4, function()
		local tbl32 = tbl3
		local tbl33, tbl34 = tbl32.PlotTop(), tbl3
		tbl32 = tbl34.Root()
		if not tbl33 or not tbl32 then
			return false
		end
		tbl34 = tbl3
		if tbl34.BasketCount() <= 0 then
			return true
		end
		tbl34 = tbl3
		tbl34.Status = "Bringing eggs home"
		local position, Y, tbl35 = tbl32.Position, tbl33.Y - p, ipairs
		tbl32 = {Vector3.new(position.X, Y, position.Z), Vector3.new(tbl33.X, Y, tbl33.Z), tbl33 + Vector3.new(0, 3, 0)}

		for k, v17 in tbl35(tbl32) do
			k = tbl4
			if not k.InstantTo(v17) then
				return false
			end
		end

		position = os.clock() + 2

		while true do
			tbl35 = tbl3
			if not ((tbl35.BasketCount() > 0) and (os.clock() < position)) then
				break
			end
			local v17
			tbl32 = RunService
			tbl32.Heartbeat:Wait()
		end

		tbl33 = tbl3
		tbl34 = tbl33.BasketCount() == 0

		if tbl34 then
			table.clear(tbl4.Carried)
			tbl33 = tbl4
			tbl33.PickupPos = nil
		end

		tbl35 = tbl3
		return tbl35.BasketCount() == 0
	end

	tbl45 = nil

	tbl45, tbl4.CollectStep = tbl4, function(arg)
		local tbl32 = tbl3
		local r = tbl32.Root()
		if not r then
			return false
		end
		tbl32 = tbl3
		local tbl46 = tbl32.BasketCapacity()
		tbl32 = false

		while true do
			local tbl33 = tbl3
			if not (tbl33.BasketCount() < tbl46) then
				break
			end
			local tbl34 = bit32.bxor(94182315, 0)
			tbl33 = tbl34
			if arg() then
				break
			end
			local tbl35 = tbl3
			local tbl352, tbl36 = tbl35.BasketDeadline(), tbl3
			tbl35 = tbl36.PlotTop()
			tbl36 = tbl352 and tbl35

			if tbl36 then
				local tbl37 = tbl3
				r = tbl37.Root()
				local a, position = tbl352 - workspace:GetServerTimeNow()

				if r then
					tbl37 = tbl3
					position = tbl37.TravelTime(r.Position, tbl35)
				else
					position = r
				end

				if (a - (position or 0)) < (W + 4) then
					break
				end
			end

			tbl36 = tbl3
			r = tbl36.Root()
			if not r then
				break
			end
			local d = fn17()
			tbl35, tbl352 = not d

			if tbl35 then
				tbl36 = tbl4
				tbl352 = tbl36.AutoOn()
			else
				tbl352 = tbl35
			end

			if tbl352 then
				tbl36, tbl35 = ipairs, table.pack(b(r.Position))

				for _, v17 in tbl36(table.unpack(tbl35, 1, tbl35.n)) do
					local tbl47, pos = tbl4, table.find(tbl4.Manual, v17.Config.Name)
					if not pos then
						d = v17
						break
					end
				end
			else
			end

			tbl352 = not d

			if tbl352 then
				tbl36 = not tbl32

				if tbl36 then
					tbl35 = tbl3
					tbl35.Status = "No egg matches the filters"
				end

				break
			end

			local name, tbl47 = d.Config.Name, tbl4
			tbl47.Target = name
			tbl36 = tbl4
			tbl36.TargetManual = d.Manual == true
			tbl36 = tbl4
			tbl36.Dropped = nil
			tbl47 = tbl3
			tbl47.Status = string.format("Collecting %s", d.Name)
			tbl352 = d.Position + Vector3.new(0, 3, 0)
			tbl34 = bit32.bxor(tbl33, 510026178)
			tbl47 = tbl3
			tbl36, tbl33, tbl35 = tbl47.NeedsVolcano, u32Mul(1348794871, tbl34) + 734225022
			tbl34, tbl35 = u32Trunc(tbl33 + (u32Mul(2946172426, (bit32.bor(tbl34, 151773682))) + u32Mul(2946172424, (bit32.band(tbl34, 151773682))))), tbl36(d.Name)
			tbl36 = nil

			if tbl35 then
				tbl47 = tbl3
				tbl36 = tbl47.VolcanoApproach
			else
				tbl36 = tbl35
			end

			tbl47 = nil

			if tbl36 then
				tbl47 = tbl36
			else
				tbl33 = tbl3
				tbl47 = tbl33.FlyTo
			end

			tbl33 = tbl4
			tbl36, tbl35 = tbl33.InstantOn

			if tbl36 then
				tbl33 = tbl3
				tbl35 = not tbl33.NeedsVolcano(d.Name)
			else
				tbl35 = tbl36
			end

			if tbl35 then
				tbl36 = tbl4
				tbl47 = tbl36.InstantTo
			else
			end

			local function fn19()
				local Y, a = arg() or (d.Config.Parent == nil)

				if Y then
					a = Y
				else
					local tbl48 = tbl4
					a = tbl48.Dropped == name
				end

				return a
			end

			tbl33, tbl35 = tbl47(tbl352, fn19, 6), tbl4
			fn19 = tbl35.Dropped == name

			if fn19 then
				tbl352 = tbl4
				tbl352.Target = nil
				tbl36 = tbl4
				tbl36.Dropped = nil
				continue
			end

			tbl35 = (d.Config.Parent == nil) and not tbl33

			if tbl35 then
				fn18(name)
				tbl36 = tbl4
				tbl36.Target = nil
				continue
			end

			tbl47 = not tbl33

			if tbl47 then
				nameMap[name] = os.clock() + 20
				fn18(name)
				fn19 = tbl4
				fn19.Target = nil
				break
			end

			tbl35 = tbl3
			tbl352, fn19 = tbl35.BasketCount(), tbl4
			fn19.LastPickupAt = os.clock()
			tbl35 = tbl352 == 0

			if tbl35 then
				fn19 = tbl4
				fn19.PickupPos = d.Position
			end

			fn19, tbl36 = os.clock() + 1.2, tbl4
			tbl47 = (tbl36.InstantOn and (os.clock() + 0.15)) or 0

			while true do
				tbl36 = tbl3
				if not (tbl36.BasketCount() == tbl352) then
					break
				end
				tbl35 = (os.clock() >= tbl47) and (d.Config.Parent ~= nil)

				if tbl35 then
					tbl33 = nil
					tbl33, tbl47 = tbl4, os.clock() + ((tbl4.InstantOn and 0.3) or 0.1)
					local tbl37 = tbl3
					tbl37.Fire("EggPickup", name)
				else
				end

				if os.clock() >= fn19 then
					if (d.Config.Parent ~= nil) or (os.clock() >= (fn19 + 1.5)) then
						break
					end
				end

				local v17
				local RunService2 = RunService
				RunService2.Heartbeat:Wait()
			end

			fn18(name)
			tbl35 = tbl4
			tbl35.Target = nil
			tbl35 = tbl3
			fn19 = tbl35.BasketCount() > tbl352

			if fn19 then
				tbl36 = tbl4
				tbl36.Carried[name] = d.Config
				tbl33 = tbl3
				tbl47 = tbl33.NeedsVolcano(d.Name)

				if tbl47 then
					tbl352 = tbl3
					tbl352.VolcanoExit(nil)
				end

				tbl35 = tbl4
				local instantOn = tbl35.InstantOn

				if instantOn then
					local tbl48 = tbl4
					local dipOn = tbl48.DipOn

					if dipOn then
						pcall(tbl4.VolcanoDip)
					end

					dipOn = tbl4
					dipOn.InstantHome()
				end

				tbl32 = true
			else
				nameMap[name] = os.clock() + 20
			end
		end

		tbl46 = tbl4
		tbl46.Target = nil
		tbl46 = tbl3
		local flag2, dipOn = tbl46.BasketCount() > 0

		if flag2 then
			tbl46 = tbl4
			dipOn = tbl46.DipOn
		else
			dipOn = flag2
		end

		if dipOn then
			pcall(tbl4.VolcanoDip)
		end

		flag2 = tbl3
		dipOn, tbl46 = flag2.BasketCount() > 0

		if dipOn then
			flag2 = tbl4
			tbl46 = flag2.InstantOn
		else
			tbl46 = dipOn
		end

		if tbl46 then
			flag2 = tbl4
			flag2.InstantHome()
		end

		tbl46 = tbl3
		dipOn = tbl46.BasketCount() > 0

		if dipOn then
			flag2 = tbl4
			flag2.Deliver(nil)
		end

		return tbl32
	end

	local function fn19()
		local F
		local localPlayer2 = localPlayer
		local basket = localPlayer2:FindFirstChild("Basket")
		if not basket then
			return false
		end
		local v17, children = ipairs, table.pack(basket:GetChildren())

		for k, v18 in v17(table.unpack(children, 1, children.n)) do
			basket, localPlayer2, k = v18:GetAttribute("Egg"), v18:GetAttribute("VolcanoDipped") ~= true

			if localPlayer2 then
				local tbl32, tbl46 = tbl3
				tbl46, k = tbl4, tbl32.EggRank(basket) >= tbl4.DipMinRank
			else
				k = localPlayer2
			end

			if k then
				return true
			end
		end

		return false
	end

	local function F()
		local v17
		local localPlayer2 = localPlayer
		local basket = localPlayer2:FindFirstChild("Basket")

		for _, v18 in ipairs((basket and basket:GetChildren()) or {}) do
			if v18:GetAttribute("VolcanoUntil") ~= nil then
				return true
			end
		end

		return false
	end

	tbl45 = nil

	tbl45, tbl4.VolcanoDip = tbl4, function()
		local v17
		local ReplicatedStorage2 = ReplicatedStorage
		local packages = ReplicatedStorage2:FindFirstChild("packages")
		ReplicatedStorage2 = nil

		if packages then
			local ReplicatedStorage3 = ReplicatedStorage
			ReplicatedStorage2 = ReplicatedStorage3.packages:FindFirstChild("Net")
		else
			ReplicatedStorage2 = packages
		end

		local reVolcanoDip, tbl32 = ReplicatedStorage2 and (ReplicatedStorage2:FindFirstChild("RE/VolcanoDip")), tbl3
		local P, tbl33 = tbl32.VolcanoHover(), tbl3
		packages, ReplicatedStorage2 = tbl33.PlotTop(), tbl3
		tbl32 = ReplicatedStorage2.Root()
		if (((not reVolcanoDip or not P) or not packages) or not tbl32) or not fn19() then
			return
		end
		tbl33 = tbl3
		ReplicatedStorage2 = tbl33.BasketDeadline()

		if ReplicatedStorage2 then
			tbl33 = tbl3
			local tbl34, c, tbl46 = tbl3, (tbl33.TravelTime(tbl32.Position, P) + tbl3.TravelTime(P, packages)) + W, tbl4
			c = if tbl46.InstantOn then W + 12 else c
			if (ReplicatedStorage2 - workspace:GetServerTimeNow()) < c then
				return
			end
		end

		ReplicatedStorage2 = tbl3
		ReplicatedStorage2.Status = "Taking the egg to the volcano"
		packages = tbl4
		tbl33, tbl32 = packages.InstantOn

		if tbl33 then
			ReplicatedStorage2 = tbl4
			tbl32 = ReplicatedStorage2.InstantTo(P)
		else
			packages = tbl3
			tbl32 = packages.FlyTo(P, nil, 6)
		end

		if not tbl32 then
			return
		end

		for i = 1, 4, 1 do
			if not fn19() then
				break
			end
			tbl32 = tbl3
			tbl32.Status = "Dipping the egg into the volcano"
			reVolcanoDip:FireServer()
			packages = os.clock()

			while (os.clock() - packages) < 14 do
				ReplicatedStorage2 = tbl3
				local v18 = ReplicatedStorage2.Root()

				if v18 then
					local V = bit32.bxor(93202263, 0)
					tbl33 = V
					local v19, v20 = pcall, u32Trunc(i)
					V = u32Trunc((3186609987 + tbl33) + (u32Mul(2904648934, v20) + u32Mul(2904648934, (bit32.bnot(v20)))))

					v19(function()
						v18.CFrame = CFrame.new(P) * v18.CFrame.Rotation
						v18.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					end)
				end

				local v19
				local RunService2 = RunService
				RunService2.Heartbeat:Wait()
				if ((os.clock() - packages) > 1) and not F() then
					break
				end
			end
		end
	end

	local tbl46, K = tbl4
	tbl45 = v12

	tbl46.Collect = tbl45:CreateToggle({Name = "Auto Collect Eggs", Default = false, Callback = function()
		local tbl47 = tbl4
		tbl47.Wake()
	end})

	tbl42, tbl45 = tbl4, v12

	tbl42.InstantHandle = tbl45:CreateToggle({Name = "Instant Steal", Default = false, Callback = function(arg)
		local tbl47 = tbl4
		tbl47.InstantOn = arg == true
		tbl47, arg = tbl4, type(tbl4.Wake) == "function"

		if arg then
			local tbl48 = tbl4
			tbl48.Wake()
		end
	end})

	local tbl47, v122, options, tbl32 = tbl4, v12, {Name = "Min Egg Rarity"}, tbl3
	options.Options = tbl32.RarityChoices
	tbl42 = tbl3
	options.Default = tbl42.RarityChoices[1]

	options.Callback = function(arg)
		local tbl33 = tbl3
		t = tbl33.RarityRank[tostring(arg)] or 0
		arg, tbl33 = tbl4, type(tbl4.OnCollectFilter) == "function"

		if tbl33 then
			pcall(tbl4.OnCollectFilter)
		end
	end

	tbl47.CollectRarity = v122:CreateDropdown(options)
	local tbl48, v17 = tbl4
	local fn72, v123, options2, v18 = fn7, v12, {Name = "Target Eggs"}
	tbl42 = names
	options2.Options = tbl42
	options2.Default = {}

	local function callback(g)
		local v19
		l = fn10(g)
		local tbl49, flag2 = tbl4, type(tbl4.OnCollectFilter) == "function"

		if flag2 then
			pcall(tbl4.OnCollectFilter)
		end
	end

	options2.Callback = callback
	tbl48.CollectEggs = fn72(v123:CreateMultiDropdown(options2))
	local tbl49 = tbl4

	tbl49.CollectFilters = function()
		local g, f, tbl33 = t, l, tbl3
		return g, f, tbl33.MinEggWeight
	end

	tbl48, fn72 = tbl4, tbl3
	v122, tbl47, callback = fn72.WeightSlider, v12, {Name = "Min Egg Weight"}

	local function onRaw(minEggWeight)
		local tbl33 = tbl3
		tbl33.MinEggWeight = minEggWeight
		minEggWeight = tbl4
		minEggWeight.Wake()
		tbl33, minEggWeight = tbl4, type(tbl4.OnCollectFilter) == "function"

		if minEggWeight then
			pcall(tbl4.OnCollectFilter)
		end
	end

	callback.OnRaw = onRaw
	tbl48.CollectWeight = v122(tbl47, callback)
	options2 = v12

	options2:CreateDropdown({Name = "Collect Priority", Options = y, Default = y[2], Callback = function(arg)
		O = tostring(arg)
	end})

	options2 = v12

	options2:CreateSlider({Name = "Tween Speed", Min = 100, Max = 1300, Default = 1000, Increment = 25, Callback = function(arg)
		local tbl33 = tbl3
		tbl33.FlySpeed = math.clamp(tonumber(arg) or 1000, 100, 1300)
	end})

	tbl42 = v12
	local v19, v124 = tbl42:CreateText({Name = "Rebirth Pet Status", Text = "Off"}), v12

	rebirth.Handle = v124:CreateToggle({Name = "Steal Rebirth Pet Eggs", Note = "Steals eggs that can hatch the pet your next rebirth needs, until you own it", Default = false, Callback = function(V)
		local g = type(V) ~= "boolean"

		if g then
			local f
			local tbl22 = tbl2
			V = tbl22.Toggle(rebirth.Handle, false)
		else
		end

		rebirth.On = V == true
		local tbl410, flag2 = tbl4, type(tbl4.Wake) == "function"

		if flag2 then
			g = tbl4
			g.Wake()
		end
	end})

	callback = v12

	callback:CreateSlider({Name = "Min Rebirth Pet Chance", Min = 1, Max = 100, Default = 10, Increment = 1, Unit = "%", SubOf = rebirth.Handle, Callback = function(V)
		rebirth.Min = math.clamp(tonumber(V) or 10, 1, 100)
		local tbl410, G = tbl4, type(tbl4.Wake) == "function"

		if G then
			V = tbl4
			V.Wake()
		end
	end})

	local function V(G)
		local g = (tonumber(G) or 0) * 100

		if g >= 10 then
			return string.format("%.0f%%", g)
		elseif g >= 0.1 then
			return string.format("%.1f%%", g)
		end

		return "<0.1%"
	end

	local function G(g)
		local f = bit32.bxor(78902203, 0)
		local localPlayer2 = f
		f = u32Trunc((u32Mul(2668866128, localPlayer2) + 887329360) + (u32Mul(3252202336, (bit32.bor(localPlayer2, 405617793))) + u32Mul(2668866129, (bit32.bxor(localPlayer2, 405617793)))))

		local function fn20(arg)
			if not arg then
				return false
			end

			for _, child in ipairs(arg:GetChildren()) do
				if child:IsA("Tool") and child:GetAttribute("PetKey") then
					if ((string.match(child.Name, "^(.-) %[") or child.Name) == g) or (child:GetAttribute("PetName") == g) then
						return true
					end
				end
			end

			return false
		end

		local v20
		localPlayer2 = localPlayer
		local petMountJoint = fn20(localPlayer2:FindFirstChildOfClass("Backpack"))
		localPlayer2 = nil

		if petMountJoint then
			localPlayer2 = petMountJoint
		else
			local localPlayer3 = localPlayer
			localPlayer2 = fn20(localPlayer3.Character)
		end

		if localPlayer2 then
			return true
		end
		fn20 = localPlayer
		localPlayer2 = fn20.Character
		fn20 = localPlayer2 and (localPlayer2:FindFirstChild("HumanoidRootPart"))
		petMountJoint = fn20 and (fn20:FindFirstChild("PetMountJoint"))
		localPlayer2 = (petMountJoint and petMountJoint.Part1) and petMountJoint.Part1.Parent
		if localPlayer2 and (localPlayer2:GetAttribute("PetName") == g) then
			return true
		end

		localPlayer2, fn20 = pcall(function()
			local localPlayer3 = localPlayer
			return require(localPlayer3:WaitForChild("PlayerScripts", 5).Game.Pets.PetRenderer)
		end)

		petMountJoint = (localPlayer2 and (type(fn20) == "table")) and (type(fn20.GetAll) == "function")

		if petMountJoint then
			local ok, result = pcall(fn20.GetAll)
			localPlayer2 = ok and (type(result) == "table")

			if localPlayer2 then
				ok = pairs

				for k, v21 in ok(result) do
					local flag2, flag3 = type(v21) == "table"

					if flag2 then
						k = nil
						k, flag3 = localPlayer, v21.OwnerUserId == localPlayer.UserId
					else
						flag3 = flag2
					end

					if ((flag3 and v21.Model) and v21.Model.Parent) and (v21.Model.Name == g) then
						return true
					end
				end
			end
		end

		return false
	end

	local function g()
		local f = bit32.bxor(448787253, 0)
		local key = f
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local General, Rebirths, HatchLuck = require(ReplicatedStorage2.GameData.General), require(ReplicatedStorage2.GameData.Rebirths), require(ReplicatedStorage2.GameData.HatchLuck)
		local rebirthRequirements, cap, tbl33, saved, n13, done = ((type(General) == "table") and General.RebirthRequirements) or nil, tonumber, tbl3, tbl3.Saved, u32Mul(787199801, key) + 4203681519
		f, done = u32Trunc(n13 + (u32Mul(3507767496, (bit32.bor(key, 504649575))) + u32Mul(3507767494, (bit32.band(key, 504649575))))), cap(saved("Rebirths")) or 0
		cap = tonumber((type(Rebirths) == "table") and Rebirths.Cap) or 6
		rebirth.Done = done
		rebirth.Cap = cap

		if ((type(rebirthRequirements) ~= "table") or (#rebirthRequirements == 0)) or (done >= cap) then
			rebirth.Pet = nil
			rebirth.Need = false
			rebirth.Owned = false
			rebirth.Status = ((done >= cap) and "All rebirths are done") or "No rebirth requirement found"
			return
		end

		ReplicatedStorage2 = rebirthRequirements[math.clamp(done + 1, 1, #rebirthRequirements)]
		rebirth.Pet = ReplicatedStorage2
		rebirth.Owned = G(ReplicatedStorage2)
		rebirth.Need = not rebirth.Owned
		local n14, n15 = 1, 1

		pcall(function()
			local P, localPlayer2, tbl34
			localPlayer2, tbl34, n14 = localPlayer, tbl3, HatchLuck.GetMultiplier(HatchLuck.EffectiveUpgrades(localPlayer, tonumber(tbl3.Saved("HatchUpgrades")) or 0))
		end)

		pcall(function()
			n15 = HatchLuck.EventMultiplier()
		end)

		key = string.format("%s|%s|%s", tostring(ReplicatedStorage2), tostring(n14), tostring(n15))
		rebirthRequirements = key ~= rebirth.Key

		if rebirthRequirements then
			local kMap, P = {}
			saved, Rebirths = tbl, type(tbl.Eggs) == "table"

			if Rebirths then
				n13, General = pairs, tbl
				local eggs = General.Eggs

				for k, egg in n13(eggs) do
					local T = (type(egg) == "table") and tonumber(egg.Luck)

					if T then
						local ok, result = pcall(HatchLuck.GetBoostedOdds, math.max((tonumber(egg.Luck) or 1) * (tonumber(n14) or 1), 1), tonumber(n15) or 1, egg)

						if ok and (type(result) == "table") then
							for _, v20 in ipairs(result) do
								if (v20.PetName == ReplicatedStorage2) and ((tonumber(v20.Chance) or 0) > 0) then
									kMap[k] = tonumber(v20.Chance)
								end
							end
						end
					end
				end
			end

			rebirth.Chances = kMap
			rebirth.Key = key
		end

		General = string.format("Rebirth %d/%d needs %s", done + 1, cap, tostring(ReplicatedStorage2))
		if rebirth.Owned then
			rebirth.Status = General .. "  -  you own it, ready to rebirth"
			return
		end
		done = {}

		for k, chance in pairs(rebirth.Chances) do
			if (chance * 100) >= rebirth.Min then
				table.insert(done, {Name = k, Chance = chance})
			end
		end

		ReplicatedStorage2 = table.sort

		local function L(arg, arg2)
			return arg.Chance > arg2.Chance
		end

		ReplicatedStorage2(done, L)
		local v20
		key, Rebirths = activeEggs, 0

		for _, child in ipairs(key:GetChildren()) do
			rebirthRequirements = child:GetAttribute("Egg")
			Rebirths = if (type(rebirthRequirements) == "string") and (((rebirth.Chances[rebirthRequirements] or 0) * 100) >= rebirth.Min) then Rebirths + 1 else Rebirths
		end

		cap = {}

		for i = 1, math.min(3, #done), 1 do
			table.insert(cap, done[i].Name .. (" " .. V(done[i].Chance)))
		end

		if #cap == 0 then
			rebirth.Status = General .. ("  -  no egg reaches " .. (tostring(rebirth.Min) .. "%"))
		else
			rebirth.Status = string.format("%s  -  %d on the map  |  %s", General, Rebirths, table.concat(cap, ", "))
		end
	end

	task.spawn(function()
		local need

		while (v19 and v19.Instance) and v19.Instance.Parent do
			local h = bit32.bxor(364148764, 0)
			local n13 = h
			local flag2, f = false, task
			h = bit32.bxor(n13, 528774268)
			h = u32Trunc((u32Mul(528404438, h) + 1458693516) + (u32Mul(3238158420, (bit32.bor(h, 88612050))) + u32Mul(528404439, (bit32.bxor(h, 88612050)))))

			f.spawn(function()
				pcall(g)
				flag2 = true
			end)

			n13 = 0

			while true do
				f = not flag2 and (n13 < 5)
				if not f then
					break
				end
				n13 += task.wait(0.1)
			end

			n13 = (rebirth.On and rebirth.Status) or ("Off  -  " .. tostring(rebirth.Status))

			if type(v19.Set) == "function" then
				pcall(v19.Set, v19, n13)
			end

			n13 = rebirth.Need ~= need

			if n13 then
				need = rebirth.Need
				local tbl410, I = tbl4, type(tbl4.Wake) == "function"

				if I then
					f = tbl4
					f.Wake()
				end
			else
			end

			task.wait(2)
		end
	end)

	tbl46, tbl48 = tbl4, v12

	tbl46.DipHandle = tbl48:CreateToggle({Name = "Auto Volcano Dip", Note = "Dips each collected egg into the volcano for a 15% Magma chance, then brings it home", Default = false, Callback = function(I)
		local flag2 = type(I) ~= "boolean"

		if flag2 then
			local L
			local tbl22, tbl410 = tbl2
			tbl410, I = tbl4, tbl22.Toggle(tbl4.DipHandle, false)
		else
		end

		flag2 = tbl4
		flag2.DipOn = I == true
	end})

	local v125, options3, tbl33 = v12, {Name = "Dip Min Rarity"}, tbl3
	options3.Options = tbl33.RarityChoices
	tbl48 = tbl3
	options3.Default = tbl48.RarityChoices[1]

	options3.Callback = function(L)
		local tbl410, tbl34 = tbl4, tbl3
		tbl410.DipMinRank = tbl34.RarityRank[tostring(L)] or 0
	end

	v125:CreateDropdown(options3)
end

fn14()

local function fn15()
	local B, V = bit32.bxor(471841657, 0), 0
	B = u32Trunc(B + 130672287)
	local x, G, g = 0, 0, 5
	B = u32Trunc(B + 107230796)
	local fn16, f

	fn16 = function()
		local tbl32 = tbl3
		local T = tbl32.Plot()
		tbl32 = T and (T:FindFirstChild("Eggs"))
		return (tbl32 and tbl32:GetChildren()) or {}
	end

	local function fn17()
		local list2 = {}

		for i, v17 in ipairs(fn16()) do
			local l = bit32.bxor(525138104, 0)
			i = l
			local O
			O, l = pcall, u32Trunc((u32Mul(933686597, i) + 431127863) + (u32Mul(2427594102, (bit32.bor(i, 303936075))) + u32Mul(933686598, (bit32.bxor(i, 303936075)))))

			local y, v18 = O(function()
				return v17:GetPivot().Position
			end)

			if y then
				table.insert(list2, v18)
			end
		end

		local tbl32 = tbl3
		local t = tbl32.Plot()
		tbl32 = t and (t:FindFirstChild("Pets"))

		if tbl32 then
			for i, child in ipairs(tbl32:GetChildren()) do
				local y = bit32.bxor(122586230, 0)
				i = nil
				i, y = pcall, u32Trunc(y + 458627896)

				local v17, O = i(function()
					return child:GetPivot().Position
				end)

				if v17 then
					table.insert(list2, O)
				end
			end
		end

		return list2
	end

	local T, tbl42

	tbl42, tbl4.PlantStep = tbl4, function(y)
		local t = bit32.bxor(363411899, 0)
		local l = t
		local Egg = os
		t = u32Trunc(l + 98591070)
		t = u32Trunc(t + 141454789)
		l = (Egg.clock() < x) and (#fn16() >= G)
		if l then
			return false
		end
		local list2, F, tbl32 = {}, ipairs, tbl3
		Egg = table.pack(tbl32.Tools("Egg"))

		for k, v17 in F(table.unpack(Egg, 1, Egg.n)) do
			l = tbl3
			tbl32, k = l.EggRank(v17.Name), V

			if tbl32 >= k then
				table.insert(list2, v17)
			end
		end

		if #list2 == 0 then
			return false
		end

		tbl32, F = table, function(_, N)
			local tbl33, tbl34 = tbl3, tbl3
			return tbl33.EggLuck(_.Name) > tbl34.EggLuck(N.Name)
		end

		tbl32.sort(list2, F)
		F, tbl32 = ipairs, 0

		for k, v17 in F(list2) do
			if y() then
				break
			end

			if not v17.Parent then
				continue
			end
			k = tbl3
			l = k.RandomPlotPoint(8, fn17(), g)
			if not l then
				break
			end
			Egg = tbl3
			Egg.Status = string.format("Placing %s", v17.Name)
			k = tbl3
			if not k.Equip(v17) then
				break
			end
			v17, k = #fn16(), tbl3
			k.Fire("EggPlaced", {PlantPosition = l})
			k = os.clock() + 1.2

			while (os.clock() < k) and (#fn16() == v17) do
				local v18
				local RunService2 = RunService
				RunService2.Heartbeat:Wait()
			end

			k = #fn16() > v17

			if k then
				tbl32 += 1
			else
				x = os.clock() + 15
				G = #fn16()
				break
			end
		end

		y = tbl3
		y.Unequip()
		return tbl32 > 0
	end

	local function fn18()
		local list2 = {}

		for _, v17 in ipairs(fn16()) do
			local timer, hatch = v17:FindFirstChild("Timer", true), v17:FindFirstChild("Hatch", true)

			if ((((v17:GetAttribute("EggKey") ~= nil) or (hatch and hatch:IsA("ProximityPrompt"))) and timer) and timer:IsA("TextLabel")) and (timer.Text == "Ready") then
				table.insert(list2, {Egg = v17, Prompt = hatch})
			end
		end

		return list2
	end

	local tbl43 = tbl4

	tbl43.HatchWanted = function()
		local v17
		local tbl22 = tbl2
		local tbl44, hatch = tbl4, tbl22.Toggle(tbl4.Hatch, false) and (#fn18() > 0)
		return hatch
	end

	tbl42 = nil

	tbl42, tbl4.HatchStep = tbl4, function(arg)
		local q, flag2, n12 = ipairs, table.pack(fn18()), 0

		for k, v17 in q(table.unpack(flag2, 1, flag2.n)) do
			local v18 = bit32.bxor(326305905, 0)
			k = v18
			if arg() then
				break
			end
			local egg, tbl32 = v17.Egg, u32Trunc(n12)
			local O
			v18, O = u32Trunc((2939355868 + k) + (u32Mul(2547927602, tbl32) + u32Mul(2547927602, (bit32.bnot(tbl32))))), not egg.Parent
			v18 = u32Trunc(v18 - 251355791)
			if O then
				continue
			end

			egg, k = pcall(function()
				return v17.Egg:GetPivot().Position
			end)

			if egg then
				tbl32 = tbl3
				tbl32.Status = "Hatching eggs"
				O = tbl3
				local tbl33 = O.Root()
				local RunService2 = not tbl33 or ((tbl33.Position - k).Magnitude > 24)

				if RunService2 then
					tbl33 = tbl3
					tbl33.FlyTo(k + Vector3.new(0, 3, 3), arg, 5)
				end

				tbl33 = v17.Egg:GetAttribute("EggKey")
				local v19
				RunService2 = game_
				local hatch = RunService2:FindFirstChild("Hatch")
				RunService2 = ((tbl33 ~= nil) and hatch) and hatch:IsA("RemoteEvent")

				if RunService2 then
					pcall(hatch.FireServer, hatch, {EggKey = tbl33})
				else
					local tbl34 = tbl3
					tbl34.FirePrompt(v17.Prompt)
				end

				hatch = os.clock() + 2

				while (os.clock() < hatch) and v17.Egg.Parent do
					local I
					RunService2 = RunService
					RunService2.Heartbeat:Wait()
				end

				n12 = if not v17.Egg.Parent then n12 + 1 else n12
			else
			end
		end

		flag2 = n12 > 0

		if flag2 then
			task.wait(0.5)
			arg = tbl3
			arg.Unequip()
		end

		return n12 > 0
	end

	local tbl44, v17 = tbl4
	tbl42 = v13

	tbl44.Plant = tbl42:CreateToggle({Name = "Auto Place Eggs", Default = false, Callback = function()
		x = 0
		local tbl45 = tbl4
		tbl45.Wake()
	end})

	local v132, options, tbl32 = v13, {Name = "Place Min Rarity"}, tbl3
	options.Options = tbl32.RarityChoices
	tbl32 = tbl3
	options.Default = tbl32.RarityChoices[1]

	options.Callback = function(q)
		local tbl33 = tbl3
		V = tbl33.RarityRank[tostring(q)] or 0
	end

	v132:CreateDropdown(options)
	v132, tbl44 = tbl4, v13

	v132.Hatch = tbl44:CreateToggle({Name = "Auto Hatch Eggs", Default = false, Callback = function()
		local tbl45 = tbl4
		tbl45.Wake()
	end})
end

fn15()

local function fn16()
	local B, g, attributeMap, names2, y = bit32.bxor(359790178, 0), {}, {}, {}
	local flag2, t, tbl42 = type, tbl
	tbl42, B = flag2(tbl.Foods), u32Trunc(B + 361439918)
	flag2 = tbl42 == "table"

	if flag2 then
		local l, O = {}, tbl

		for k, food in pairs(O.Foods) do
			if type(food) == "table" then
				local insert, _ = table.insert, {Name = k}
				_.Cost = tonumber(food.Cost) or 0
				insert(l, _)
			end
		end

		table.sort(l, function(arg, F)
			return arg.Cost < F.Cost
		end)

		for _, v17 in ipairs(l) do
			table.insert(names2, v17.Name)
		end
	end

	local l
	flag2 = tbl4
	flag2.FoodChoices = names2
	B = u32Trunc(B - 213669398)

	local function fn17()
		local v17
		local tbl32 = tbl3
		local O = tbl32.Plot()
		tbl32 = O and (O:FindFirstChild("Pets"))
		return (tbl32 and tbl32:GetChildren()) or {}
	end

	local function fn18()
		local O
		local localPlayer2, num = localPlayer, tonumber(localPlayer:GetAttribute("MaxPets"))
		local q

		if num then
			q = num
		else
			local F, tbl32
			tbl32, q = tbl3, tonumber(tbl3.Saved("MaxPets"))
		end

		num = q or 5
		return math.max(1, num)
	end

	local function q(O)
		local F
		local tbl32 = tbl3
		return tbl32.PetScore(O:GetAttribute("PetName") or O.Name, O:GetAttribute("Weight"), O:GetAttribute("Mutation"))
	end

	local function O(F)
		local W
		local tbl32, tbl33 = tbl3, tbl3
		return tbl32.PetScore(tbl33.PetNameOf(F), F:GetAttribute("Weight"), F:GetAttribute("Mutation"))
	end

	local function F()
		local W
		local tbl32, _, N = tbl3, -1

		for i, v17 in ipairs(tbl32.Tools("Pet")) do
			i = O(v17)

			if i > _ then
				_, N = i, v17
			else
			end
		end

		return N, _
	end

	local function fn19()
		local W, _ = 1 / 0

		for i, v17 in ipairs(fn17()) do
			i = q(v17)

			if i < W then
				W, _ = i, v17
			else
			end
		end

		return _, W
	end

	local tbl43 = tbl4

	tbl43.PlaceWanted = function()
		local W
		local tbl22 = tbl2
		local _, place = tbl4, tbl22.Toggle(tbl4.Place, false)
		if not place then
			return false
		end
		place, tbl22 = F()
		if not place then
			return false
		end

		if #fn17() < fn18() then
			return true
		end
		local _, v17 = fn19()
		return tbl22 > (v17 * 1.05)
	end

	local function W(arg, N)
		local attribute = arg:GetAttribute("PetKey")
		if not attribute then
			return false
		end
		local m
		local tbl32 = tbl3
		local RunService2 = tbl32.PlotTop()

		if RunService2 then
			tbl32 = tbl3
			tbl32.FlyTo(RunService2 + Vector3.new(0, 4, 0), N, 20)
		end

		tbl32 = tbl3
		if not tbl32.Equip(arg) then
			return false
		end
		arg = tbl3
		RunService2, tbl32, N = arg.RandomPlotPoint(10, nil, 0), #fn17(), tbl3
		N.Fire("PlacePet", attribute, RunService2 + Vector3.new(0, 2, 0))
		task.wait(0.35)
		attribute = tbl3
		attribute.Unequip()
		arg = os.clock() + 1.5

		while (os.clock() < arg) and (#fn17() == tbl32) do
			local _
			RunService2 = RunService
			RunService2.Heartbeat:Wait()
		end

		return #fn17() > tbl32
	end

	flag2 = nil

	flag2, tbl4.PlaceStep = tbl4, function(_)
		local N, b = fn18(), 0

		for i = 1, N, 1 do
			i = _()
			local i2

			if i then
				i2 = i
			else
				local tbl44 = tbl4
				i2 = not tbl44.PlaceWanted()
			end

			if i2 then
				break
			end
			i = F()
			if not i then
				break
			end
			local flag3, p = #fn17() >= fn18()

			if flag3 then
				i2 = fn19()
				local attribute = i2 and (i2:GetAttribute("PetKey"))
				if not attribute then
					break
				end
				local tbl32 = tbl3
				tbl32.Status = "Swapping in a stronger pet"
				tbl32 = tbl3
				local tbl33 = tbl32.PlotTop()

				if tbl33 then
					tbl32 = tbl3
					tbl32.FlyTo(tbl33 + Vector3.new(0, 4, 0), _, 20)
				end

				tbl33 = tbl3
				tbl33.Fire("PickupPet", attribute)
				tbl32 = os.clock() + 1.5

				while (os.clock() < tbl32) and i2.Parent do
					local v17
					attribute = RunService
					attribute.Heartbeat:Wait()
				end

				if i2.Parent then
					break
				end
			end

			local tbl32, tbl33 = tbl3
			tbl33, tbl32.Status = tbl3, string.format("Placing %s", tbl3.PetNameOf(i))

			if W(i, _) then
				b += 1
			else
				break
			end
		end

		return b > 0
	end

	local function fn20()
		local v17, v18 = ipairs
		local tbl32 = tbl3
		local Food, _, N = table.pack(tbl32.Tools("Food")), 1 / 0

		for k, v19 in v17(table.unpack(Food, 1, Food.n)) do
			k = v19:FindFirstChild("Amount", true)
			local flag3, tbl322 = ((k and tonumber(k.Value)) or 1) > 0

			if flag3 then
				tbl32 = next(g) == nil

				if tbl32 then
					tbl322 = tbl32
				else
					k = g
					tbl322 = k[v19.Name]
				end
			else
				tbl322 = flag3
			end

			if tbl322 then
				local v20, flag4, flag42 = tbl, type(tbl.Foods) == "table"

				if flag4 then
					flag3 = tbl
					flag42 = flag3.Foods[v19.Name]
				else
					flag42 = flag4
				end

				k = flag42 or nil
				flag4 = ((type(k) == "table") and tonumber(k.Cost)) or 0

				if flag4 < _ then
					_, N = flag4, v19
				else
				end
			else
			end
		end

		return N
	end

	tbl42 = nil

	tbl42, tbl4.FeedWanted = tbl4, function()
		local L
		local tbl22 = tbl2
		local tbl44, h = tbl4, not tbl22.Toggle(tbl4.Feed, false) or not fn20()
		if h then
			return false
		end
		h = os.clock()

		for i, v17 in ipairs(fn17()) do
			i = v17:GetAttribute("PetKey")
			if i and ((attributeMap[i] or 0) <= h) then
				return true
			end
		end

		return false
	end

	tbl42 = nil

	tbl42, tbl4.FeedStep = tbl4, function(L)
		local h = bit32.bxor(213638765, 0)
		local tbl32, attribute = fn17(), table
		h = u32Trunc(h + 339802599)
		local sort = attribute.sort
		h = u32Trunc(h - 49540720)

		sort(tbl32, function(arg, arg2)
			return q(arg) > q(arg2)
		end)

		local v17, n12, v18 = ipairs, 0

		for k, _ in v17(tbl32) do
			if L() then
				break
			end
			attribute, sort = _:GetAttribute("PetKey"), fn20()
			if not sort then
				break
			end
			k = attribute and ((attributeMap[attribute] or 0) <= os.clock())

			if k then
				local v19 = bit32.bxor(265390839, 0)
				local tbl33
				tbl33, v19 = pcall, bit32.bxor(v19, 365364058)

				local I, v20 = tbl33(function()
					return _:GetPivot().Position
				end)

				if I then
					tbl33 = tbl3
					tbl33.Status = string.format("Feeding %s", tostring(_:GetAttribute("PetName") or _.Name))
					local tbl34 = tbl3
					tbl34.FlyTo(v20 + Vector3.new(0, 4, 4), L, 8)
					tbl34 = tbl3
					local sort2 = tbl34.Equip(sort)

					if sort2 then
						local attribute2, tbl35 = _:GetAttribute("Age"), tbl3
						tbl35.Fire("FeedPet", attribute, sort.Name)
						tbl35 = os.clock() + 1.2

						while (os.clock() < tbl35) and (_:GetAttribute("Age") == attribute2) do
							local v21
							tbl34 = RunService
							tbl34.Heartbeat:Wait()
						end

						attributeMap[attribute] = os.clock() + 2
						n12 += 1
					else
					end
				else
				end
			else
			end
		end

		tbl32 = tbl3
		tbl32.Unequip()
		return n12 > 0
	end

	local tbl44, v17 = tbl4
	flag2 = v14

	tbl44.Place = flag2:CreateToggle({Name = "Auto Place Best Pets", Default = false, Callback = function()
		local tbl45 = tbl4
		tbl45.Wake()
	end})

	tbl42, flag2 = tbl4, v14

	tbl42.Feed = flag2:CreateToggle({Name = "Auto Feed Pets", Default = false, Callback = function()
		table.clear(attributeMap)
		local tbl45 = tbl4
		tbl45.Wake()
	end})

	local I
	local fn72, v142, options, tbl45 = fn7, v14, {Name = "Foods To Use", Options = names2, Default = {}}, tbl4
	options.SubOf = tbl45.Feed

	local function callback(Z)
		local v18
		g = fn10(Z)
	end

	options.Callback = callback
	fn72(v142:CreateMultiDropdown(options))
end

fn16()

local function fn17()
	local B, K = bit32.bxor(202120524, 0), false
	B = u32Trunc(B + 277970236)
	local V = true
	B = u32Trunc(B + 20516274)
	local v17
	local tbl42 = tbl4

	tbl42.Wake = function()
		K = true
	end

	local tbl43 = tbl4

	tbl43.CollectActive = function()
		local tbl44 = tbl4
		local x = tbl44.AutoOn()
		tbl44 = nil

		if x then
			tbl44 = x
		else
			local tbl45 = tbl4
			tbl44 = #tbl45.Manual > 0
		end

		return tbl44
	end

	local function fn18()
		local x
		local tbl32 = tbl3
		local G, g = tbl32.BasketCount() > 0

		if G then
			local tbl44, f = tbl4, next(tbl4.Carried) ~= nil

			if f then
				g = f
			else
				tbl32 = nil
				tbl32, g = tbl4, (os.clock() - tbl4.LastPickupAt) < 30
			end
		else
			g = G
		end

		return g
	end

	local function x()
		local tbl44 = tbl4
		local g, plant, T = tbl44.CollectActive() or fn18()

		if g then
			plant = g
		else
			local tbl22, tbl45 = tbl2
			tbl45, plant = tbl4, tbl22.Toggle(tbl4.Plant, false)
		end

		tbl44 = nil

		if plant then
			tbl44 = plant
		else
			local tbl22, tbl45 = tbl2
			tbl45, tbl44 = tbl4, tbl22.Toggle(tbl4.Hatch, false)
		end

		plant = nil

		if tbl44 then
			plant = tbl44
		else
			local tbl22, tbl45 = tbl2
			tbl45, plant = tbl4, tbl22.Toggle(tbl4.Place, false)
		end

		tbl44 = nil

		if plant then
			tbl44 = plant
		else
			local tbl22, tbl45 = tbl2
			tbl45, tbl44 = tbl4, tbl22.Toggle(tbl4.Feed, false)
		end

		return tbl44
	end

	local function fn19()
		local G = not V or not x()
		return G
	end

	local function G(g)
		local function f()
			local T = fn19()
			local y

			if T then
				y = T
			else
				local v18
				local tbl22 = tbl2
				y = not tbl22.Toggle(g, false)
			end

			return y
		end

		return f
	end

	task.spawn(function()
		while true do
			local g = V
			if not g then
				break
			end
			local f = false
			g = x()
			local T, n12

			if g then
				local tbl32 = tbl3
				n12 = tbl32.Root()
			else
				n12 = g
			end

			g = nil

			if n12 then
				local tbl32 = tbl3
				g = tbl32.Plot()
			else
				g = n12
			end

			if g then
				local y = bit32.bxor(338085424, 0)
				n12 = y
				local tbl44 = tbl4
				y = u32Trunc(n12 + 527524465)
				tbl44.Busy = true
				y = u32Trunc(y - 197643128)

				tbl44 = not pcall(function()
					local tbl32 = tbl3
					local l = tbl32.BasketCount() > 0

					if l then
						tbl32 = tbl4
						local instantOn = tbl32.InstantOn

						if instantOn then
							local tbl45 = tbl4
							tbl45.InstantHome()
						end

						instantOn = tbl3
						local F = instantOn.BasketCount() > 0

						if F then
							instantOn = tbl4
							instantOn.Deliver(fn19)
						end

						f = true
					end

					local O
					tbl32 = tbl2
					local tbl45, plant = tbl4, tbl32.Toggle(tbl4.Plant, false) and not fn19()

					if plant then
						tbl32 = tbl4
						local tbl46, v18 = tbl4, tbl32.PlantStep(G(tbl4.Plant))

						if v18 then
							f = true
						end
					end

					l = tbl4
					plant = l.HatchWanted() and not fn19()

					if plant then
						l = tbl4
						local tbl46, v18 = tbl4, l.HatchStep(G(tbl4.Hatch))

						if v18 then
							f = true
						end
					end

					l = tbl4
					tbl32 = l.PlaceWanted() and not fn19()

					if tbl32 then
						plant = tbl4
						local tbl46, v18 = tbl4, plant.PlaceStep(G(tbl4.Place))

						if v18 then
							f = true
						end
					end

					l = tbl4
					plant = l.FeedWanted() and not fn19()

					if plant then
						l = tbl4
						local tbl46, v18 = tbl4, l.FeedStep(G(tbl4.Feed))

						if v18 then
							f = true
						end
					end

					plant = tbl4
					tbl32 = plant.CollectActive() and not fn19()

					if tbl32 then
						local tbl46 = bit32.bxor(162203851, 0)
						l = tbl46
						plant = tbl4
						tbl46 = bit32.bxor(l, 226555115)
						local collectStep, n13, v18 = plant.CollectStep, u32Mul(1051214039, tbl46) + 3469102831

						tbl46, v18 = u32Trunc(n13 + (u32Mul(3243753258, (bit32.bor(tbl46, 279668649))) + u32Mul(3243753256, (bit32.band(tbl46, 279668649))))), collectStep(function()
							local I = fn19()
							local flag2

							if I then
								flag2 = I
							else
								local tbl47 = tbl4
								flag2 = not tbl47.CollectActive()
							end

							return flag2
						end)

						if v18 then
							f = true
						end
					end
				end)

				if tbl44 then
					local tbl32 = tbl3
					tbl32.Unequip()
				end

				tbl44 = tbl4
				tbl44.Busy = false
				local I, flag2 = not f

				if I then
					tbl44 = tbl4
					flag2 = not tbl44.AutoOn()
				else
					flag2 = I
				end

				if flag2 then
					I = tbl3
					I.Status = "Waiting for work"
				end
			else
				local I = not x()

				if I then
					local tbl32 = tbl3
					tbl32.Status = "Idle"
				end
			end

			g = (f and 0.15) or 1
			n12 = os.clock() + g

			while true do
				g = (V and (os.clock() < n12)) and not K
				if not g then
					break
				end
				local I
				local RunService2 = RunService
				RunService2.Heartbeat:Wait()
			end

			K = false
		end
	end)

	local I

	fn6(function()
		V = false
	end)
end

fn17()

local function fn18()
	local B = bit32.bxor(521693183, 0)
	local TweenService = game:GetService("TweenService")
	local T
	T, B = TweenInfo, u32Trunc(B + 79723123)
	local y, nameList, l, O = T.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {"Luck", "Rarity", "Distance", "Weight"}, 60, 9
	local tbl5, color3FromRGB = {Collect = Color3.fromRGB(255, 255, 255), Cancel = Color3.fromRGB(255, 120, 120), AutoOn = Color3.fromRGB(120, 255, 120), AutoOff = Color3.fromRGB(255, 255, 255), Busy = Color3.fromRGB(120, 255, 90)}
	color3FromRGB, B = Color3.fromRGB, u32Trunc(B + 412002681)
	tbl5.Queued = color3FromRGB(255, 214, 90)
	tbl5.Auto = Color3.fromRGB(150, 210, 255)
	tbl5.Carry = Color3.fromRGB(255, 170, 70)
	local n12, ScreenGui, clone, holder, clone2, textLabel, textLabel2, label, clone3, notification, textLabel3, udim2, w, Y, i = 1
	local J, j, connections, a, S = false, {}, {}, true, true

	local function u(z, text)
		if z and (z.Text ~= text) then
			z.Text = text
		end
	end

	local function z()
		local D
		local localPlayer2 = localPlayer
		local playerGui = localPlayer2:FindFirstChildOfClass("PlayerGui")
		return playerGui and (playerGui:FindFirstChild("Main"))
	end

	local function D(X)
		for _, descendant in ipairs(X:GetDescendants()) do
			if descendant:IsA("LuaSourceContainer") or descendant:IsA("BindableEvent") then
				descendant:Destroy()
			end
		end
	end

	local function X(H)
		local R
		local tbl32 = tbl3
		local k = tbl32.EggData(H)
		return (k and tostring(k.Image or "")) or ""
	end

	local function H(R)
		local attribute, attribute2, attribute3 = R:GetAttribute("Egg"), R:GetAttribute("Position"), R:GetAttribute("PrivateTo")
		local flag2, attribute4 = (type(attribute) == "string") and (typeof(attribute2) == "Vector3")

		if flag2 then
			attribute = attribute3 == nil

			if attribute then
				attribute4 = attribute
			else
				local k
				attribute2 = localPlayer
				attribute4 = attribute3 == attribute2.UserId
			end
		else
			attribute4 = flag2
		end

		return attribute4
	end

	local function toUDim2(R)
		local position = R.Position
		return UDim2.new((1 + (R.AnchorPoint.X * R.Size.X.Scale)) + 0.1, position.X.Offset, position.Y.Scale, position.Y.Offset)
	end

	local function R(k, Q)
		TweenService:Create(k, y, {Position = Q}):Play()
	end

	local function f()
		local clone4 = J
		if not clone4 then
			return
		end
		J = false
		clone4 = clone

		if clone4 then
			R(clone, w)
		end
	end

	local function fn19()
		local k = J or not clone
		if k then
			return
		end
		J, a = true, true
		clone.Visible = true
		pcall(i)
		R(clone, udim2)
	end

	local function fn20()
		local k
		local tbl42 = tbl4
		local collect = tbl42.Collect
		tbl42 = (type(collect) == "table") and (type(collect.Set) == "function")

		if tbl42 then
			local v17
			pcall(collect.Set, collect, not tbl2.Toggle(collect, false))
		end

		collect = tbl4
		collect.Wake()
	end

	local function k(Q)
		local M
		local tbl42, flag2 = tbl4, not table.find(tbl4.Manual, Q)

		if flag2 then
			table.insert(tbl4.Manual, Q)
		end

		flag2 = tbl4
		flag2.Wake()
	end

	local function Q(dropped)
		local C
		local tbl42, pos = tbl4, table.find(tbl4.Manual, dropped)

		if pos then
			table.remove(tbl4.Manual, pos)
		end

		pos = tbl4
		local flag2 = pos.Target == dropped

		if flag2 then
			pos = tbl4
			pos.Dropped = dropped
		end
	end

	local function M(C, name, position, size, textXAlignment)
		local clone4 = C:Clone()
		clone4.Name = name
		clone4.AnchorPoint = Vector2.new(0, 0)
		clone4.Position = position
		clone4.Size = size
		clone4.TextXAlignment = textXAlignment or Enum.TextXAlignment.Left
		clone4.TextScaled = true
		clone4.Visible = true
		clone4.Text = ""
		return clone4
	end

	local C

	local function fn21(e, s)
		local clone4 = clone2:Clone()
		local E
		clone4.Name = fn5()
		clone4.Visible = true
		clone4.Size = UDim2.new(0.888163447, 0, 0, C())
		local holder2 = clone4:FindFirstChild("Holder")
		local eggImage = holder2 and (holder2:FindFirstChild("EggImage"))
		local eggWeight, progress = eggImage and (eggImage:FindFirstChild("EggWeight")), clone4:FindFirstChild("Progress")
		local timeLeft, open = progress and (progress:FindFirstChild("TimeLeft")), clone4:FindFirstChild("Open")
		holder2 = open and (open:FindFirstChild("TextLabel"))

		if progress then
			progress.Visible = false
		end

		local eggName, eggInfo, eggStatus = timeLeft and M(timeLeft, "EggName", UDim2.fromScale(0.33, 0.1), UDim2.fromScale(0.64, 0.3)), timeLeft and M(timeLeft, "EggInfo", UDim2.fromScale(0.33, 0.4), UDim2.fromScale(0.64, 0.2)), timeLeft and M(timeLeft, "EggStatus", UDim2.fromScale(0.33, 0.66), UDim2.fromScale(0.3, 0.22))
		progress = {eggName, eggInfo, eggStatus}

		for _, v17 in ipairs(progress) do
			v17.Parent = clone4
		end

		if open then
			local timeLeft2 = bit32.bxor(347821378, 0)
			timeLeft = timeLeft2
			open.Visible = true
			open.AnchorPoint = Vector2.new(0.5, 0.5)
			progress = UDim2.fromScale
			timeLeft2 = bit32.bxor(timeLeft, 322873470)
			local v17 = progress(0.8, 0.74)
			timeLeft2 = u32Trunc((u32Mul(2440134788, timeLeft2) + 4090891476) + (u32Mul(1854832509, (bit32.bor(timeLeft2, 356487317))) + u32Mul(1854832507, (bit32.band(timeLeft2, 356487317)))))
			open.Position = v17
			open.Size = UDim2.fromScale(0.33, 0.38)

			open.Activated:Connect(function()
				local v18
				local tbl42, pos = tbl4, table.find(tbl4.Manual, e)
				local pos2

				if pos then
					pos2 = pos
				else
					local tbl43 = tbl4
					local flag2 = tbl43.Target == e

					if flag2 then
						tbl43 = tbl4
						pos2 = tbl43.TargetManual
					else
						pos2 = flag2
					end
				end

				if pos2 then
					Q(e)
				else
					k(e)
				end

				a = true
			end)
		end

		progress = s:GetAttribute("Egg")
		local v17
		timeLeft = tbl3
		local attribute = timeLeft.EggRarity(progress)

		if eggImage then
			eggImage.Image = X(progress)
		end

		if eggWeight then
			eggImage = tbl3
			eggWeight.Text = eggImage.EggWeightText(s:GetAttribute("Weight"))
		end

		eggName.Text = tostring(progress)
		timeLeft = tbl3
		eggName.TextColor3 = timeLeft.RarityColors[attribute] or Color3.fromRGB(255, 255, 255)
		clone4.Parent = holder
		eggImage, eggWeight = {Frame = clone4, Config = s, Name = progress, Rarity = attribute}, tbl3
		eggImage.Rank = eggWeight.EggRank(progress)
		timeLeft = tbl3
		eggImage.Luck = timeLeft.EggLuck(progress) * (tonumber(s:GetAttribute("Weight")) or 1)
		eggImage.Position = s:GetAttribute("Position")
		eggImage.Info = eggInfo
		eggImage.Status = eggStatus
		eggImage.Button = open
		eggImage.ButtonText = holder2
		return eggImage
	end

	C = function()
		local x = (holder and holder.AbsoluteSize.X) or 0
		return math.max(40, math.floor((x * 0.888163447) / 2.55))
	end

	local function fn22(arg)
		local v17 = j[arg]

		if v17 then
			local e = bit32.bxor(200801328, 0)
			local s = e
			e = bit32.bxor(s, 238179919)
			e = u32Trunc((u32Mul(1965050213, e) + 572527612) + (u32Mul(364866870, (bit32.bor(e, 140608076))) + u32Mul(1965050214, (bit32.bxor(e, 140608076)))))
			j[arg] = nil

			pcall(function()
				v17.Frame:Destroy()
			end)
		end
	end

	local function fn23(arg, e)
		local s
		local tbl42 = tbl4
		if tbl42.Carried[arg] then
			return "Bringing home", tbl5.Carry, nil
		end
		tbl42 = tbl4
		local flag2 = tbl42.Target == arg
		if flag2 then
			tbl42 = tbl4
			return "Collecting...", tbl5.Busy, (tbl42.TargetManual and "Cancel") or nil
		end
		tbl42, flag2 = tbl4, table.find(tbl4.Manual, arg)
		if flag2 then
			return "Queued #" .. flag2, tbl5.Queued, "Cancel"
		end

		if e then
			return "Auto #" .. e, tbl5.Auto, "Collect"
		end
		return "", tbl5.Collect, "Collect"
	end

	i = function()
		local v17 = bit32.bxor(313161289, 0)
		local v172 = v17
		local holder2 = holder
		if not holder2 then
			return
		end
		local v18
		holder2 = tbl3
		local tbl42 = holder2.Root()
		local position, nameMap = (tbl42 and tbl42.Position) or Vector3.new(0, 0, 0), {}
		v17 = u32Trunc((u32Mul(3624322189, v172) + 2177299751) + (u32Mul(670645108, (bit32.bor(v172, 361244035))) + u32Mul(670645106, (bit32.band(v172, 361244035)))))
		local list2, tbl43, v19 = {}, ipairs
		v172 = activeEggs
		holder2 = table.pack(v172:GetChildren())
		local v20

		for k2, v21 in tbl43(table.unpack(holder2, 1, holder2.n)) do
			k2 = H(v21)
			v172 = nil

			if k2 then
				tbl42 = tbl4
				v172 = not (tbl42.Relaying and (v21:GetAttribute("OriginPosition") ~= nil))
			else
				v172 = k2
			end

			if v172 then
				nameMap[v21.Name] = v21
				table.insert(list2, v21)
			end
		end

		tbl42, tbl43 = pairs, tbl4
		holder2 = tbl43.Carried
		v17 = bit32.bxor(v17, 427808521)

		for k2, v21 in tbl42(holder2) do
			if (typeof(v21) == "Instance") and not nameMap[k2] then
				nameMap[k2] = v21
			end
		end

		v172 = tbl4
		holder2, tbl42 = v172.Target

		if holder2 then
			v172 = tbl4
			tbl42 = not nameMap[v172.Target]
		else
			tbl42 = holder2
		end

		holder2 = nil

		if tbl42 then
			tbl43 = tbl4
			holder2 = j[tbl43.Target]
		else
			holder2 = tbl42
		end

		if holder2 then
			v172, tbl42 = tbl4
			tbl42, nameMap[v172.Target] = tbl4, j[tbl4.Target].Config
		end

		for k2 in pairs(j) do
			if not nameMap[k2] then
				fn22(k2)
			end
		end

		tbl42, v172 = {}, ipairs

		for _, v21 in v172(list2) do
			local attribute, attribute2, insert, tbl6, tbl32 = v21:GetAttribute("Egg"), v21:GetAttribute("Position"), table.insert, {Uid = v21.Name, Config = v21}, tbl3
			tbl6.Rank = tbl32.EggRank(attribute)
			holder2 = tbl3
			tbl6.Luck = holder2.EggLuck(attribute) * (tonumber(v21:GetAttribute("Weight")) or 1)
			tbl6.Distance = (attribute2 - position).Magnitude
			tbl6.Weight = tonumber(v21:GetAttribute("Weight")) or 0
			insert(tbl42, tbl6)
		end

		local sort = nameList[n12]
		v172 = table.sort

		local function fn24(arg, arg2)
			if (sort == "Weight") and (arg.Weight ~= arg2.Weight) then
				return arg.Weight > arg2.Weight
			end

			if sort == "Distance" then
				return arg.Distance < arg2.Distance
			elseif sort == "Rarity" then
				if arg.Rank ~= arg2.Rank then
					return arg.Rank > arg2.Rank
				end

				if arg.Luck ~= arg2.Luck then
					return arg.Luck > arg2.Luck
				end
				return arg.Distance < arg2.Distance
			end

			if arg.Luck ~= arg2.Luck then
				return arg.Luck > arg2.Luck
			end
			return arg.Distance < arg2.Distance
		end

		v172(tbl42, fn24)
		tbl43, fn24 = {}, tbl4
		local position2, tbl44, n13 = fn24.AutoPlan(position), ipairs, 0

		for k2, v21 in tbl44(position2) do
			holder2 = v21.Config.Name
			position, fn24, v172 = tbl4, not table.find(tbl4.Manual, holder2)

			if fn24 then
				k2 = tbl4
				v172 = k2.Target ~= holder2
			else
				v172 = fn24
			end

			if v172 then
				n13 += 1
				tbl43[holder2] = n13
				if n13 >= O then
					break
				end
			else
			end
		end

		position2, tbl44 = {}, tbl4

		for k2, v21 in pairs(tbl44.Carried) do
			if nameMap[k2] == v21 then
				table.insert(position2, k2)
			end
		end

		v172 = tbl4
		fn24, tbl44 = v172.Target

		if fn24 then
			holder2 = tbl4
			tbl44 = nameMap[holder2.Target]
		else
			tbl44 = fn24
		end

		holder2 = nil

		if tbl44 then
			v172, fn24 = tbl4
			fn24, holder2 = tbl4, not v172.Carried[tbl4.Target]
		else
			holder2 = tbl44
		end

		if holder2 then
			table.insert(position2, tbl4.Target)
		end

		fn24, holder2 = ipairs, tbl4
		tbl44 = holder2.Manual

		for k2, v21 in fn24(tbl44) do
			k2, holder2 = nameMap[v21]

			if k2 then
				v172 = tbl4
				holder2 = v21 ~= v172.Target
			else
				holder2 = k2
			end

			if holder2 then
				table.insert(position2, v21)
			end
		end

		holder2, v172 = {}, {}

		for _, v21 in ipairs(position2) do
			v172[v21] = true
			table.insert(holder2, v21)
		end

		for _, v21 in ipairs(tbl42) do
			if not v172[v21.Uid] then
				v172[v21.Uid] = true
				table.insert(holder2, v21.Uid)
			end
		end

		v172 = {}

		for _, v21 in ipairs(tbl42) do
			v172[v21.Uid] = v21.Distance
		end

		tbl44, position2 = {}, ipairs

		for k2, v21 in position2(holder2) do
			if k2 > l then
				break
			end
			tbl44[v21] = true
			fn24 = j[v21]

			if not fn24 then
				fn24 = fn21(v21, nameMap[v21])
				j[v21] = fn24
			else
			end

			fn24.Frame.LayoutOrder = k2
			tbl42 = C()

			if fn24.Frame.Size.Y.Offset ~= tbl42 then
				fn24.Frame.Size = UDim2.new(0.888163447, 0, 0, tbl42)
			end

			k2 = tbl4

			if k2.Carried[v21] then
				u(fn24.Info, fn24.Rarity .. "  |  In basket")
			else
				u(fn24.Info, string.format("%s  |  %dm", fn24.Rarity, math.floor(v172[v21] or 0)))
			end

			local v22, v23, v24 = fn23(v21, tbl43[v21])
			u(fn24.Status, v22)
			fn24.Status.TextColor3 = v23

			if fn24.Button then
				fn24.Button.Visible = v24 ~= nil

				if v24 then
					u(fn24.ButtonText, v24)
					fn24.Button.ImageColor3 = ((v24 == "Cancel") and tbl5.Cancel) or tbl5.Collect
				end
			end
		end

		for k2 in pairs(j) do
			if not tbl44[k2] then
				fn22(k2)
			end
		end

		u(label, string.format("Map Eggs (%d)", #list2))
		local v21
		tbl44 = tbl2
		holder2, tbl42 = tbl4, tbl44.Toggle(tbl4.Collect, false)
		u(textLabel2, (tbl42 and "Auto: ON") or "Auto: OFF")
		fn24 = (textLabel2 and textLabel2.Parent) and textLabel2.Parent:IsA("ImageButton")

		if fn24 then
			textLabel2.Parent.ImageColor3 = (tbl42 and tbl5.AutoOn) or tbl5.AutoOff
		end

		u(textLabel, "Sort: " .. sort)
		position2 = tbl4
		v172 = position2.InstantOn == true
		u(textLabel3, (v172 and "Instant: ON") or "Instant: OFF")
		tbl44 = (textLabel3 and textLabel3.Parent) and textLabel3.Parent:IsA("ImageButton")

		if tbl44 then
			textLabel3.Parent.ImageColor3 = (v172 and tbl5.AutoOn) or tbl5.AutoOff
		end

		fn24 = notification

		if fn24 then
			v172 = tbl4
			tbl42, list2, position2 = tbl4, #v172.Manual + ((tbl4.Target and 1) or 0), notification
			position2.Visible = list2 > 0
			tbl44 = notification:FindFirstChild("Count")
			u(tbl44, tostring(list2))
		end
	end

	local function A()
		local q = bit32.bxor(144024351, 0)
		local uiListLayout = z()
		local plotEggsTracker, sideBar = uiListLayout and (uiListLayout:FindFirstChild("PlotEggsTracker")), uiListLayout and (uiListLayout:FindFirstChild("SideBar"))
		local egg, eggFrame = sideBar and (sideBar:FindFirstChild("Egg"))

		if plotEggsTracker then
			sideBar = plotEggsTracker:FindFirstChild("Handler")
			eggFrame = sideBar and (sideBar:FindFirstChild("EggFrame"))

			if not eggFrame then
				local holder2 = plotEggsTracker:FindFirstChild("Holder")

				for _, v17 in ipairs((holder2 and holder2:GetChildren()) or {}) do
					if v17:IsA("Frame") and v17:FindFirstChild("Holder") then
						eggFrame = v17
						break
					end
				end
			else
			end
		else
		end

		if (not plotEggsTracker or not egg) or not eggFrame then
			return false
		end
		sideBar = nil
		sideBar, q = Instance, u32Trunc(q + 398668329)
		ScreenGui = sideBar.new("ScreenGui")
		local ScreenGui2, v17 = ScreenGui
		ScreenGui2.Name = fn5()
		ScreenGui.ResetOnSpawn = false
		sideBar = ScreenGui
		sideBar.IgnoreGuiInset = uiListLayout.IgnoreGuiInset
		ScreenGui2 = ScreenGui
		ScreenGui2.ScreenInsets = uiListLayout.ScreenInsets
		sideBar = ScreenGui
		sideBar.ZIndexBehavior = uiListLayout.ZIndexBehavior
		ScreenGui2 = ScreenGui
		ScreenGui2.DisplayOrder = uiListLayout.DisplayOrder + 1
		clone2 = eggFrame:Clone()
		D(clone2)
		clone = plotEggsTracker:Clone()
		ScreenGui2 = clone
		ScreenGui2.Name = fn5()
		D(clone)
		clone.Visible = true
		holder = clone:FindFirstChild("Holder")
		plotEggsTracker = holder

		for _, child in ipairs(plotEggsTracker:GetChildren()) do
			if not child:IsA("UIListLayout") then
				child:Destroy()
			end
		end

		sideBar = holder
		sideBar.AutomaticCanvasSize = Enum.AutomaticSize.Y
		sideBar, plotEggsTracker, ScreenGui2 = holder, UDim2
		ScreenGui2, q = plotEggsTracker.new(), u32Trunc(q - 128727776)
		sideBar.CanvasSize = ScreenGui2
		uiListLayout = holder:FindFirstChildOfClass("UIListLayout")

		if uiListLayout then
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		end

		udim2 = UDim2.new(0.99, 0, 0.5, 0)
		clone.Position = udim2
		w = toUDim2(clone)
		clone.Position = w
		plotEggsTracker = clone:FindFirstChild("Header")
		label = plotEggsTracker and plotEggsTracker:FindFirstChild("Label")
		sideBar = label

		if sideBar then
			label.Text = "Map Eggs"
		end

		plotEggsTracker = clone:FindFirstChild("GrowAll")

		if plotEggsTracker then
			local L = bit32.bxor(203891498, 0)
			sideBar = L
			ScreenGui2 = plotEggsTracker:Clone()
			plotEggsTracker.Name = fn5()
			ScreenGui2.Name = fn5()
			plotEggsTracker.Size = UDim2.new(0.185, 0, plotEggsTracker.Size.Y.Scale, 0)
			ScreenGui2.Size = plotEggsTracker.Size
			uiListLayout = nil
			uiListLayout, L = UDim2.new, u32Trunc(sideBar + 82541904)
			plotEggsTracker.Position = uiListLayout(0.5175, 0, plotEggsTracker.Position.Y.Scale, 0)
			ScreenGui2.Position = UDim2.new(0.9075, 0, plotEggsTracker.Position.Y.Scale, 0)
			ScreenGui2.Parent = clone
			local clone4 = plotEggsTracker:Clone()
			clone4.Name = fn5()
			clone4.Size = plotEggsTracker.Size
			clone4.Position = UDim2.new(0.7125, 0, plotEggsTracker.Position.Y.Scale, 0)
			clone4.Parent = clone
			local p = {plotEggsTracker, ScreenGui2, clone4}

			for i2, v18 in ipairs(p) do
				i2 = v18:FindFirstChild("TextLabel")

				if i2 then
					i2.AnchorPoint = Vector2.new(0.5, 0.5)
					i2.Position = UDim2.fromScale(0.5, 0.5)
					i2.Size = UDim2.fromScale(0.86, 0.56)
					i2.TextXAlignment = Enum.TextXAlignment.Center
				end
			end

			textLabel = plotEggsTracker:FindFirstChild("TextLabel")
			textLabel2 = ScreenGui2:FindFirstChild("TextLabel")
			textLabel3 = clone4:FindFirstChild("TextLabel")

			clone4.Activated:Connect(function()
				local v18 = bit32.bxor(45841804, 0)
				local v182 = v18
				local m
				local tbl42 = tbl4
				local instantHandle = tbl42.InstantHandle
				local kind, c, flag2 = type(instantHandle), u32Mul(526926915, v182) + 3012581617
				v18, flag2 = u32Trunc(c + (u32Mul(3768040382, (bit32.bor(v182, 406181051))) + u32Mul(3768040380, (bit32.band(v182, 406181051))))), (kind == "table") and (type(instantHandle.Set) == "function")

				if flag2 then
					pcall(instantHandle.Set, instantHandle, not (tbl4.InstantOn == true))
				else
					c, v182 = tbl4, tbl4
					c.InstantOn = not (v182.InstantOn == true)
				end

				c = tbl4
				c.Wake()
				a = true
				kind = nil
				kind, v18 = task, bit32.bxor(v18, 230978752)

				kind.delay(0.3, function()
					a = true
				end)
			end)

			plotEggsTracker.Activated:Connect(function()
				local n122 = n12
				n12, a = (n122 % #nameList) + 1, true
			end)

			p = ScreenGui2.Activated

			local function fn24()
				fn20()
				a = true
			end

			p:Connect(fn24)
		end

		ScreenGui2 = clone:FindFirstChild("Toggle")

		if ScreenGui2 and (ScreenGui2:IsA("GuiButton")) then
			ScreenGui2.Activated:Connect(f)
		end

		clone.Parent = ScreenGui
		clone3 = egg:Clone()
		plotEggsTracker = clone3
		plotEggsTracker.Name = fn5()
		D(clone3)
		local arrow, clone4, t = clone3:FindFirstChild("Arrow"), pairs
		egg, plotEggsTracker, sideBar = tbl, type(tbl.Eggs) == "table"

		if plotEggsTracker then
			uiListLayout = tbl
			sideBar = uiListLayout.Eggs
		else
			sideBar = plotEggsTracker
		end

		uiListLayout, plotEggsTracker = -1

		for k2, v18 in clone4(sideBar or {}) do
			if ((type(v18) == "table") and v18.Image) and ((tonumber(v18.Luck) or 0) > uiListLayout) then
				uiListLayout, plotEggsTracker = tonumber(v18.Luck) or 0, k2
			else
			end
		end

		if arrow and plotEggsTracker then
			arrow.Image = X(plotEggsTracker)
			arrow.AnchorPoint = Vector2.new(0.5, 0.5)
			arrow.Position = UDim2.fromScale(0.5, 0.42)
			arrow.Size = UDim2.fromScale(0.74, 0.74)
		end

		arrow, sideBar = nil
		arrow, sideBar, q = clone3, Color3.fromRGB, u32Trunc(q + 94274346)
		arrow.BackgroundColor3 = sideBar(255, 255, 255)
		arrow = Instance.new("UIGradient")
		arrow.Rotation = 90
		arrow.Color = ColorSequence.new(Color3.fromRGB(196, 110, 255), Color3.fromRGB(112, 40, 214))
		arrow.Parent = clone3
		ScreenGui2 = clone3:FindFirstChildOfClass("UIStroke")

		if ScreenGui2 then
			ScreenGui2.Color = Color3.fromRGB(44, 8, 86)
		end

		notification = clone3:FindFirstChild("Notification")
		arrow = notification and notification:FindFirstChild("Count")

		if arrow then
			clone4 = arrow:Clone()
			clone4.Name = fn5()
			clone4.AnchorPoint = Vector2.new(0.5, 0.5)
			clone4.Position = UDim2.fromScale(0.5, 0.86)
			clone4.Size = UDim2.fromScale(0.9, 0.3)
			clone4.TextScaled = true
			clone4.Text = "MAP"
			clone4.TextColor3 = Color3.fromRGB(255, 255, 255)
			clone4.ZIndex = 3
			ScreenGui2 = clone4:FindFirstChildOfClass("UIStroke")

			if ScreenGui2 then
				ScreenGui2.Color = Color3.fromRGB(44, 8, 86)
			end

			clone4.Parent = clone3
		end

		arrow = notification

		if arrow then
			notification.Visible = false
		end

		ScreenGui2 = clone3
		ScreenGui2.AnchorPoint = Vector2.new(0.5, 0.5)
		clone3.Parent = ScreenGui
		plotEggsTracker = clone3.Activated

		local function fn24()
			local v18 = J

			if v18 then
				f()
			else
				fn19()
			end
		end

		plotEggsTracker:Connect(fn24)
		local v18
		clone4 = v9
		ScreenGui.Parent = clone4
		return true
	end

	local function fn24(L)
		local q = not clone3 or not ScreenGui
		if q then
			return
		end
		q = z()
		local sideBar = q and (q:FindFirstChild("SideBar"))
		local egg, pets = sideBar and (sideBar:FindFirstChild("Egg")), sideBar and (sideBar:FindFirstChild("Pets"))
		local flag2 = (not egg or not pets) or not q.Enabled
		if flag2 then
			clone3.Visible = false
			return
		end
		local absoluteSize, absolutePosition = ScreenGui.AbsoluteSize, ScreenGui.AbsolutePosition
		local t, n13 = (egg.AbsolutePosition + (egg.AbsoluteSize / 2)) - absolutePosition, (pets.AbsolutePosition + (pets.AbsoluteSize / 2)) - absolutePosition
		flag2 = (sideBar:GetAttribute("Open") == true) and (n13.X < (absoluteSize.X - (pets.AbsoluteSize.X * 0.4)))

		if flag2 then
			Y = absoluteSize.X - n13.X
		end

		flag2, egg, sideBar = Y or (pets.AbsoluteSize.X * 0.9), pets.AbsoluteSize, {"BasketTracker", "PlotEggsTracker", "PetsTracker"}
		pets = (Vector2.new(absoluteSize.X - flag2, t.Y - (n13.Y - t.Y)))

		for i2, v17 in ipairs(sideBar) do
			i2 = q:FindFirstChild(v17)

			if (i2 and (i2:GetAttribute("Open") == true)) and ((i2.AbsolutePosition.X - absolutePosition.X) < absoluteSize.X) then
				v17, t = i2.AbsolutePosition.Y, i2.AbsolutePosition.X + i2.AbsoluteSize.X

				for _, child in ipairs(i2:GetChildren()) do
					v17 = if child:IsA("GuiObject") and child.Visible then math.min(v17, child.AbsolutePosition.Y) else v17
				end

				pets = Vector2.new(math.min(t - absolutePosition.X, absoluteSize.X - 4) - (egg.X / 2), ((v17 - absolutePosition.Y) - (egg.Y / 2)) - (egg.Y * 0.12))
				break
			end
		end

		n13, sideBar = Vector2.new(clone3.Position.X.Offset, clone3.Position.Y.Offset), math.clamp((L or 0) * 14, 0, 1)
		sideBar = if not clone3.Visible or ((n13 - pets).Magnitude > absoluteSize.Y) then 1 else sideBar
		q, absoluteSize = n13:Lerp(pets, sideBar), clone3
		absoluteSize.Size = UDim2.fromOffset(egg.X, egg.Y)
		sideBar = clone3
		sideBar.Position = UDim2.fromOffset(q.X, q.Y)
		clone3.Visible = not J
	end

	local function L()
		local q = bit32.bxor(485440866, 0)
		local h = q
		local ScreenGui2 = ScreenGui
		q = u32Trunc(h + 11415410)
		if ScreenGui2 then
			return
		end

		if not A() then
			return
		end
		local v17, insert, activeEggs2
		insert, q, activeEggs2 = table.insert, u32Trunc(q + 453038717), activeEggs

		insert(connections, activeEggs.ChildAdded:Connect(function()
			a = true
		end))

		table.insert(connections, activeEggs.ChildRemoved:Connect(function()
			a = true
		end))

		local n13, v18 = 0

		table.insert(connections, RunService.RenderStepped:Connect(function(deltaTime)
			pcall(fn24, deltaTime)
			n13 += deltaTime
			deltaTime = J and (a or (n13 >= 0.3))

			if deltaTime then
				n13, a = 0, false
				pcall(i)
			else
				local flag2 = not J and (n13 >= 0.5)

				if flag2 then
					n13 = 0
					local notification2 = notification

					if notification2 then
						local v19
						local tbl42 = tbl4
						local tbl43, n14, notification3 = tbl4, #tbl42.Manual + ((tbl4.Target and 1) or 0), notification
						notification3.Visible = n14 > 0
						u(notification:FindFirstChild("Count"), tostring(n14))
					end
				end
			end
		end))
	end

	local function fn25()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end

		table.clear(connections)
		J = false
		table.clear(j)
		local ScreenGui2 = ScreenGui

		if ScreenGui2 then
			local v17 = bit32.bxor(73680770, 0)
			local v172 = v17
			local q
			q, v17 = pcall, u32Trunc(v172 + 298093352)

			q(function()
				ScreenGui:Destroy()
			end)
		end

		ScreenGui, clone, holder, clone2, clone3, notification = nil, nil, nil, nil, nil, nil
	end

	task.spawn(function()
		local I = os.clock() + 30

		while true do
			local flag2 = S and not ScreenGui
			if not (flag2 and (os.clock() < I)) then
				break
			end
			pcall(L)
			flag2 = ScreenGui

			if not flag2 then
				task.wait(1)
			end
		end
	end)

	local I

	fn6(function()
		S = false
		fn25()
	end)
end

fn18()

local function fn19()
	local B, kMap = bit32.bxor(276055607, 0), {}
	B = bit32.bxor(B, 209316081)
	kMap.Food = nil
	kMap.Gears = nil
	local f, T = {Food = {}, Gears = {}}, {}
	B = u32Trunc((u32Mul(201531720, B) + 2003180288) + (u32Mul(3891903856, (bit32.bor(B, 500438112))) + u32Mul(201531721, (bit32.bxor(B, 500438112)))))
	local n12, y = 0, {}

	local function t(l)
		local O = bit32.bxor(152549750, 0)
		local insert = O
		local W, _ = {}
		local flag2 = tbl
		local shop = flag2.Shop
		flag2 = ((type(shop) == "table") and shop[l]) or nil
		shop = type(flag2)
		O = u32Trunc(insert + 315903077)
		O = u32Trunc(O - 290068142)

		if shop == "table" then
			for k, v17 in pairs(flag2) do
				if type(v17) == "table" then
					insert, l = table.insert, {Name = k}
					l.Price = tonumber(v17.Price) or 0
					insert(W, l)
				end
			end
		end

		table.sort(W, function(arg, F)
			return arg.Price < F.Price
		end)

		l = {}

		for _, v17 in ipairs(W) do
			table.insert(l, v17.Name)
		end

		return l
	end

	local function l(O, F)
		local W
		local flag2 = tbl
		local shop = flag2.Shop
		flag2 = ((type(shop) == "table") and shop[O]) or nil
		O = ((type(flag2) == "table") and flag2[F]) or nil
		return ((type(O) == "table") and tonumber(O.Price)) or (1 / 0)
	end

	local function L(O)
		if type(O) ~= "table" then
			return
		end

		for k, v17 in pairs(O) do
			if ((k == "Food") or (k == "Gears")) and (type(v17) == "table") then
				local kMap2 = {}

				for k2, v18 in pairs(v17) do
					if type(v18) == "table" then
						kMap2[k2] = tonumber(v18.Amount) or ((v18.InStock and 1) or 0)
					end
				end

				kMap[k] = kMap2
			end
		end
	end

	local connections, v152, nameList = {}, ipairs, {"Restock", "ShopStock"}

	for k, v17 in v152(nameList) do
		local b
		k = game_
		local A = k:FindFirstChild(v17)

		if A and (A:IsA("RemoteEvent")) then
			table.insert(connections, A.OnClientEvent:Connect(function(arg)
				L(arg)
			end))
		end
	end

	local v17
	nameList = tbl3
	nameList.Fire("ShopStock")

	local function fn20(A)
		local _, N, b = ipairs, {}
		local localPlayer2, localPlayer3 = localPlayer, localPlayer
		N[1], N[2] = localPlayer2:FindFirstChildOfClass("Backpack"), localPlayer3.Character
		localPlayer2 = 0

		for _, v18 in _(N) do
			if v18 then
				for i, child in ipairs(v18:GetChildren()) do
					if child:IsA("Tool") and (string.gsub(child.Name, "%s*%[.*$", "") == A) then
						i = child:FindFirstChild("Amount", true)
						localPlayer2 += (i and tonumber(i.Value)) or 1
					else
					end
				end
			else
			end
		end

		return localPlayer2
	end

	local function A(q)
		local _, N = y[q]
		local tbl22 = tbl2
		if not tbl22.Toggle(_, false) then
			return
		end
		local h, b, m = ipairs, table.pack(t(q)), false

		for k, v18 in h(table.unpack(b, 1, b.n)) do
			_ = f[q][v18]

			if _ then
				tbl22, k = l(q, v18), kMap[q]
				local k2 = k and k[v18]
				local flag2, g = ((k2 == nil) and ((T[q .. v18] or 0) <= os.clock())) or ((k2 ~= nil) and (k2 > 0)), 0

				while true do
					local flag22, flag3 = flag2 and (g < 20)

					if flag22 then
						k2 = tbl3
						flag3 = (k2.Cash() - tbl22) >= n12
					else
						flag3 = flag22
					end

					if not flag3 then
						break
					end
					flag22 = not m

					if flag22 then
						flag3 = tbl3
						flag3.Fire("SetOpenShop", q)
						task.wait(0.15)
						m = true
					else
					end

					flag22, flag3 = fn20(v18), tbl3
					flag3.Fire("BuyWithCash", q, v18)
					g += 1
					flag3 = os.clock() + 0.8

					while (os.clock() < flag3) and (fn20(v18) <= flag22) do
						local I
						local RunService2 = RunService
						RunService2.Heartbeat:Wait()
					end

					if fn20(v18) > flag22 then
						if k and k[v18] then
							k[v18] = math.max(0, k[v18] - 1)
							flag2 = k[v18] > 0
						else
						end
					else
						if k then
							k[v18] = 0
						end

						T[q .. v18] = os.clock() + 30
						flag2 = false
					end
				end
			else
			end
		end
	end

	local I = true

	task.spawn(function()
		while true do
			local v18 = I
			if not v18 then
				break
			end
			pcall(A, "Food")
			pcall(A, "Gears")
			task.wait(3)
		end
	end)

	local v18

	fn6(function()
		I = false

		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
	end)

	local v19
	v152 = v15

	y.Food = v152:CreateToggle({Name = "Auto Buy Food", Default = false, Callback = function()
	end})

	nameList = v15

	nameList:CreateMultiDropdown({Name = "Food To Buy", Options = t("Food"), Default = {}, SubOf = y.Food, Callback = function(arg)
		local v20
		f.Food = fn10(arg)
	end})

	nameList = v15

	y.Gears = nameList:CreateToggle({Name = "Auto Buy Radars", Default = false, Callback = function()
	end})

	nameList = v15

	nameList:CreateMultiDropdown({Name = "Radars To Buy", Options = t("Gears"), Default = {}, SubOf = y.Gears, Callback = function(arg)
		local v20
		f.Gears = fn10(arg)
	end})

	v152 = v15

	v152:CreateSlider({Name = "Keep Cash", Min = 0, Max = 100000000, Default = 0, Increment = 1000, Callback = function(arg)
		n12 = math.max(0, tonumber(arg) or 0)
	end})
end

fn19()

local function fn20()
	local B = bit32.bxor(169514827, 0)
	local f
	B = u32Trunc(B + 168181805)
	local T
	B = u32Trunc(B + 322050619)

	local function I()
		local v17
		local num = tbl
		local rebirths, y = num.Rebirths
		local tbl32, n12 = tbl3, tonumber(tbl3.Saved("Rebirths")) or 0
		if type(rebirths) ~= "table" then
			return nil
		end
		num = tonumber(rebirths.Cap)
		if num and (n12 >= num) then
			return nil
		end

		if type(rebirths.GetCost) == "function" then
			local ok, t = pcall(rebirths.GetCost, n12)
			if ok and tonumber(t) then
				return tonumber(t)
			end
		end

		return nil
	end

	local v17
	local v162 = v16

	f = v162:CreateToggle({Name = "Auto Rebirth", Default = false, Callback = function()
	end})

	v162 = v16

	T = v162:CreateToggle({Name = "Auto Claim Index Reward", Default = false, Callback = function()
	end})

	v162 = v16

	local L = v162:CreateToggle({Name = "Auto Upgrade Luck", Default = false, Callback = function()
	end})

	local v18

	local v19, Z = fn2(function()
		local q
		local ReplicatedStorage2 = ReplicatedStorage
		return ReplicatedStorage2.GameData.HatchLuck
	end), false

	local function q()
		local h
		local game_2 = game_
		local plot = game_2:FindFirstChild("Plot")
		game_2 = nil

		if plot then
			local game_3 = game_
			game_2 = game_3.Plot:FindFirstChild("Upgrades")
		else
			game_2 = plot
		end

		local K
		plot = localPlayer
		local savedData = plot:FindFirstChild("SavedData")
		plot = savedData and (savedData:FindFirstChild("HatchUpgrades"))
		if ((not game_2 or not plot) or (type(v19) ~= "table")) or (type(v19.GetPrice) ~= "function") then
			return
		end
		local localPlayer2 = localPlayer
		local V = localPlayer2:GetAttribute("Setting_LuckMultiplier") == false

		if V then
			localPlayer2 = not Z

			if localPlayer2 then
				Z = true
				local l
				fn9("Auto Upgrade Luck", "Turn on the Luck Multiplier setting in the game settings first.")
			end

			return
		end

		Z = false
		V, localPlayer2 = tonumber(plot.Value) or 0, savedData:FindFirstChild("FreeHatchUpgrades")
		savedData = nil
		local freeHatchUpgrades = localPlayer2 and ((tonumber(localPlayer2.Value) or 0) > 0)

		if freeHatchUpgrades then
			savedData = "MaxFree"
		else
			local ok, x = pcall(v19.GetPrice, V)
			x = (ok and tonumber(x)) or nil
			ok = nil

			if x then
				local v20
				localPlayer2 = tbl3
				ok = localPlayer2.Cash() >= x
			else
				ok = x
			end

			savedData = if ok then "Max" else savedData
		end

		if not savedData then
			return
		end
		game_2:FireServer(savedData)
		savedData = os.clock() + 1.5

		while (os.clock() < savedData) and ((tonumber(plot.Value) or 0) == V) do
			task.wait(0.05)
		end
	end

	local flag2, n12, h = true, 0, 0

	task.spawn(function()
		while true do
			local flag22 = flag2
			if not flag22 then
				break
			end
			flag22 = os.clock()
			local V
			local tbl22 = tbl2
			local x, y = tbl22.Toggle(f, false) and (flag22 >= n12)

			if x then
				tbl22 = I()
				local flag3

				if tbl22 then
					local tbl32 = tbl3
					flag3 = tbl32.Cash() >= tbl22
				else
					flag3 = tbl22
				end

				if flag3 then
					local tbl32 = tbl3
					tbl32.Fire("Rebirth")
					n12 = flag22 + 15
				else
					n12 = flag22 + 3
				end
			end

			tbl22 = tbl2
			x = tbl22.Toggle(T, false) and (flag22 >= h)

			if x then
				tbl22 = tbl3
				tbl22.Fire("ClaimIndexReward")
				h = flag22 + 60
			end

			tbl22 = tbl2

			if tbl22.Toggle(L, false) then
				pcall(q)
			end

			task.wait(1)
		end
	end)

	local v20

	fn6(function()
		flag2 = false
	end)
end

fn20()
local v17 = v4:CreateTab({ Name = "Player", SectionsExpanded = true })
local v18 = v17:CreateSection({ Name = "Movement", Expanded = true })
local v19 = v17:CreateSection({ Name = "ESP", Expanded = true })

local function fn21()
	local B = bit32.bxor(369474167, 0)
	local V
	B = u32Trunc((u32Mul(951791510, B) + 3328987136) + (u32Mul(2391384276, (bit32.bor(B, 340621312))) + u32Mul(951791511, (bit32.bxor(B, 340621312)))))
	local x, G = 60
	local RunService2, heartbeat = RunService
	heartbeat, B = RunService2.Heartbeat, bit32.bxor(B, 169409207)

	local connection = heartbeat:Connect(function()
		local v20
		local tbl22 = tbl2
		local vector, vector2 = not tbl22.Toggle(V, false)

		if vector then
			vector2 = vector
		else
			local v21
			tbl22 = tbl4
			vector2 = tbl22.Busy
		end

		if vector2 then
			return
		end
		local Z
		vector2 = tbl3
		tbl22, vector = vector2.Humanoid(), tbl3
		vector2 = vector.Root()
		if (not tbl22 or not vector2) or tbl22.Sit then
			return
		end
		vector = tbl22.MoveDirection
		tbl22 = Vector3.new(vector.X, 0, vector.Z)
		if tbl22.Magnitude < 0.05 then
			return
		end
		vector = vector2.AssemblyLinearVelocity
		vector2.AssemblyLinearVelocity = Vector3.new(0, vector.Y, 0) + (tbl22.Unit * x)
	end)

	local v20

	fn6(function()
		connection:Disconnect()
	end)

	local I
	heartbeat = v18

	V = heartbeat:CreateToggle({Name = "Speed Boost", Default = false, Callback = function()
	end})

	heartbeat = v18

	heartbeat:CreateSlider({Name = "Boost Speed", Min = 16, Max = 1300, Default = 60, Increment = 1, SubOf = V, Callback = function(arg)
		x = math.clamp(tonumber(arg) or 60, 16, 1300)
	end})
end

bit32.bor(n11, 3442255447)
fn21()

local function fn22()
	local B = bit32.bxor(96988972, 0)
	local K, V
	local UserInputService2 = UserInputService
	B = u32Trunc((u32Mul(2345165096, B) + 2128749880) + (u32Mul(1949802201, (bit32.bor(B, 27069915))) + u32Mul(1949802199, (bit32.band(B, 27069915)))))
	local jumpRequest
	jumpRequest, B = UserInputService2.JumpRequest, bit32.bxor(B, 457573730)

	local connection = jumpRequest:Connect(function()
		local v20
		local tbl22 = tbl2
		if not tbl22.Toggle(K, false) then
			return
		end
		local A
		tbl22 = tbl3
		local v21 = tbl22.Humanoid()

		if v21 then
			local Z = bit32.bxor(293056948, 0)
			tbl22 = Z
			local x
			x, Z = pcall, u32Trunc(tbl22 + 209891882)

			x(function()
				v21:ChangeState(Enum.HumanoidStateType.Jumping)
			end)
		end
	end)

	local I

	fn6(function()
		connection:Disconnect()
	end)

	local v20
	jumpRequest = v18

	K = jumpRequest:CreateToggle({Name = "Infinite Jump", Default = false, Callback = function()
	end})
end

fn22()

local function fn23()
	local B = bit32.bxor(162067519, 0)
	local V
	B = u32Trunc((u32Mul(370339972, B) + 3951308156) + (u32Mul(3554287352, (bit32.bor(B, 50911103))) + u32Mul(370339973, (bit32.bxor(B, 50911103)))))
	local x, G = false
	local RunService2 = RunService
	B = bit32.bxor(B, 275252811)

	local connection = RunService2.Stepped:Connect(function()
		local v20
		local tbl22 = tbl2
		local L = tbl22.Toggle(V, false)
		local A

		if L then
			x = true
			tbl22 = tbl3
			tbl22.SetNoclip(true)
		else
			local v21 = x

			if v21 then
				x = false
				local v22
				local tbl42 = tbl4
				local flag2 = not tbl42.Busy

				if flag2 then
					tbl42 = tbl3
					tbl42.SetNoclip(false)
				end
			end
		end
	end)

	local v20

	fn6(function()
		connection:Disconnect()
	end)

	local I
	RunService2 = v18

	V = RunService2:CreateToggle({Name = "Noclip", Default = false, Callback = function()
	end})
end

fn23()

local function fn24()
	local B = bit32.bxor(215638960, 0)
	local gameRef
	gameRef, B = game, u32Trunc(B + 527052318)
	local ProximityPromptService, h, connections = gameRef:GetService("ProximityPromptService"), {}, {}
	B = u32Trunc(B - 436140358)

	local function fn25(V)
		if not V:IsA("ProximityPrompt") then
			return
		end

		if h[V] == nil then
			h[V] = V.HoldDuration
		end

		if V.HoldDuration ~= 0 then
			V.HoldDuration = 0
		end
	end

	local function V()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end

		table.clear(connections)

		for k, v20 in pairs(h) do
			if k.Parent then
				local g = bit32.bxor(51292530, 0)
				local f = g
				local T
				T, g = pcall, u32Trunc((u32Mul(1332784002, f) + 3279114652) + (u32Mul(2962183295, (bit32.bor(f, 339839054))) + u32Mul(2962183293, (bit32.band(f, 339839054)))))

				T(function()
					k.HoldDuration = v20
				end)
			end
		end

		table.clear(h)
	end

	local function fn26()
		local x = bit32.bxor(139408483, 0)
		local descendants = x
		V()
		local g, workspaceRef = ipairs, workspace
		x = u32Trunc(descendants + 484014237)
		descendants = table.pack(workspaceRef:GetDescendants())
		x = u32Trunc(x - 447785782)

		for _, v20 in g(table.unpack(descendants, 1, descendants.n)) do
			if v20:IsA("ProximityPrompt") then
				fn25(v20)
			end
		end

		table.insert(connections, workspace.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("ProximityPrompt") then
				task.defer(fn25, descendant)
			end
		end))

		table.insert(connections, ProximityPromptService.PromptShown:Connect(fn25))
	end

	local I
	fn6(V)
	local v20
	gameRef = v18

	gameRef:CreateToggle({Name = "Instant Pickup", Default = false, Callback = function(arg)
		if arg then
			fn26()
		else
			V()
		end
	end})
end

fn24()

local function fn25()
	local B = bit32.bxor(2768428, 0)
	local v192
	v192, B = Font, u32Trunc(B + 281794484)
	local json = v192.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	local T
	local y, visible, folder = 0, true
	local childMap, connections = {}, {}

	local function W(parent, N)
		parent.BackgroundTransparency = 1
		parent.FontFace = json
		parent.TextScaled = true
		parent.TextStrokeTransparency = 1
		parent.TextColor3 = Color3.fromRGB(255, 255, 255)
		parent.Size = UDim2.new(1, 0, 0, N)
		N = Instance.new("UIStroke")
		local f
		N.Name = fn5()
		N.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		N.LineJoinMode = Enum.LineJoinMode.Round
		N.Color = Color3.fromRGB(0, 0, 0)
		N.Thickness = 1.8
		N.Transparency = 0.05
		N.Parent = parent
	end

	local function f(child)
		local N = childMap[child]

		if N then
			local b = bit32.bxor(7043097, 0)
			local m = b
			b = u32Trunc(m + 78489643)
			childMap[child] = nil
			b = u32Trunc(b + 138671771)

			pcall(function()
				N.Gui:Destroy()
			end)
		end
	end

	local _
	B = u32Trunc(B + 99060235)
	local v20

	_ = function(arg)
		local N = childMap[arg] or not folder
		if N then
			return
		end
		local attribute, attribute2 = arg:GetAttribute("Egg"), arg:GetAttribute("Position")
		if (type(attribute) ~= "string") or (typeof(attribute2) ~= "Vector3") then
			return
		end
		N = arg:GetAttribute("PrivateTo")
		local parent, parent2 = N ~= nil

		if parent then
			local P
			local localPlayer2 = localPlayer
			parent2 = N ~= localPlayer2.UserId
		else
			parent2 = parent
		end

		if parent2 then
			return
		end
		N = tbl3
		parent, parent2 = N.EggRank(attribute), y
		if parent < parent2 then
			return
		end
		parent2 = tbl3
		N, parent = parent2.EggRarity(attribute), Instance.new("BillboardGui")
		local A
		parent.Name = fn5()
		parent.AlwaysOnTop = true
		parent.LightInfluence = 0
		parent.Size = UDim2.fromOffset(170, 46)
		parent.Adornee = workspace.Terrain
		parent.StudsOffsetWorldSpace = attribute2 + Vector3.new(0, 4, 0)
		parent.MaxDistance = 100000
		parent2 = Instance.new("Frame")
		parent2.Name = fn5()
		parent2.BackgroundTransparency = 1
		parent2.Size = UDim2.fromScale(1, 1)
		parent2.Parent = parent
		local uiElement = Instance.new("UIListLayout")
		uiElement.Name = fn5()
		uiElement.SortOrder = Enum.SortOrder.LayoutOrder
		uiElement.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiElement.Parent = parent2
		uiElement = Instance.new("TextLabel")
		uiElement.Name = fn5()
		uiElement.LayoutOrder = 1
		W(uiElement, 24)
		uiElement.Text = attribute
		attribute = tbl3
		uiElement.TextColor3 = attribute.RarityColors[N] or Color3.fromRGB(255, 255, 255)
		uiElement.Parent = parent2
		uiElement = Instance.new("TextLabel")
		uiElement.Name = fn5()
		uiElement.LayoutOrder = 2
		W(uiElement, 18)
		uiElement.TextColor3 = Color3.fromRGB(230, 232, 240)
		uiElement.Visible = visible
		uiElement.Parent = parent2
		parent.Parent = folder
		attribute, parent2 = {Gui = parent, Info = uiElement, Rarity = N, Position = attribute2}, tbl3
		attribute.Weight = parent2.EggWeightText(arg:GetAttribute("Weight"))
		childMap[arg] = attribute
	end

	local function fn26()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end

		table.clear(connections)

		for k in pairs(childMap) do
			f(k)
		end

		local folder2 = folder

		if folder2 then
			local A = bit32.bxor(439333131, 0)
			local v21 = A
			local N
			N, A = pcall, u32Trunc((u32Mul(1341494433, v21) + 90543077) + (u32Mul(2953472864, (bit32.bor(v21, 256488645))) + u32Mul(2953472862, (bit32.band(v21, 256488645)))))

			N(function()
				folder:Destroy()
			end)

			folder = nil
		end
	end

	local function A()
		local v21 = bit32.bxor(155163039, 0)
		local v212 = v21
		fn26()
		folder = Instance.new("Folder")
		local b, folder2, v92
		folder2, v92, v21 = folder, fn5(), u32Trunc(v212 + 347786950)
		folder2.Name = v92
		local L
		v92 = v9
		folder.Parent = v92
		local v22
		folder2 = activeEggs
		local children = folder2:GetChildren()
		v212 = nil
		v212, v21 = task, u32Trunc(v21 - 156888294)
		local I

		v212.spawn(function()
			local n12 = 1

			while true do
				local folder3 = folder and (n12 <= #children)
				if not folder3 then
					break
				end
				folder3 = os.clock() + 0.004

				while (n12 <= #children) and (os.clock() < folder3) do
					_(children[n12])
					n12 += 1
				end

				folder3 = RunService
				folder3.Heartbeat:Wait()
			end
		end)

		table.insert(connections, activeEggs.ChildAdded:Connect(function(child)
			task.defer(_, child)
		end))

		table.insert(connections, activeEggs.ChildRemoved:Connect(f))
		local n12 = 0

		table.insert(connections, RunService.Heartbeat:Connect(function(deltaTime)
			n12 += deltaTime
			deltaTime = n12
			if deltaTime < 0.5 then
				return
			end
			n12 = 0
			deltaTime = tbl3
			local v23 = deltaTime.Root()
			if not v23 or not visible then
				return
			end

			for _, v24 in pairs(childMap) do
				deltaTime = (v24.Position - v23.Position).Magnitude
				v24.Info.Text = string.format("%s  %s  %dm", v24.Rarity, v24.Weight, math.floor(deltaTime))
			end
		end))
	end

	local I
	fn6(fn26)
	local v21
	v192 = v19

	T = v192:CreateToggle({Name = "ESP Eggs", Default = false, Callback = function(arg)
		if arg then
			A()
		else
			fn26()
		end
	end})

	local v193, options, tbl32 = v19, {Name = "ESP Min Rarity"}, tbl3
	options.Options = tbl32.RarityChoices
	tbl32 = tbl3
	options.Default = tbl32.RarityChoices[1]
	options.SubOf = T

	options.Callback = function(L)
		local tbl33 = tbl3
		y = tbl33.RarityRank[tostring(L)] or 0
		local Z
		L = tbl2

		if L.Toggle(T, false) then
			A()
		end
	end

	v193:CreateDropdown(options)
end

fn25()

local function fn26()
	local B = bit32.bxor(490017804, 0)
	local font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	local color = Color3.fromRGB(255, 194, 77)
	local v192
	v192, B = Color3, u32Trunc(B + 491694390)
	local g = v192.fromRGB(170, 174, 188)
	B = u32Trunc(B - 483636244)
	local folder, connection
	local T, y = {}, 0

	local function createTextLabel(parent, layoutOrder, F)
		local textLabel = Instance.new("TextLabel")
		local _
		textLabel.Name = fn5()
		textLabel.LayoutOrder = layoutOrder
		textLabel.BackgroundTransparency = 1
		textLabel.FontFace = font
		textLabel.TextScaled = true
		textLabel.TextStrokeTransparency = 1
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.Size = UDim2.new(1, 0, 0, F)
		F = Instance.new("UIStroke")
		F.Name = fn5()
		F.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		F.LineJoinMode = Enum.LineJoinMode.Round
		F.Color = Color3.fromRGB(0, 0, 0)
		F.Thickness = 1.8
		F.Transparency = 0.05
		F.Parent = textLabel
		textLabel.Parent = parent
		return textLabel
	end

	local function V(l)
		local O = T[l]

		if O then
			local F = bit32.bxor(270177360, 0)
			local W = F
			F = u32Trunc((u32Mul(1321454627, W) + 1542652887) + (u32Mul(1652058042, (bit32.bor(W, 258693821))) + u32Mul(1321454628, (bit32.bxor(W, 258693821)))))
			T[l] = nil
			F = bit32.bxor(F, 415875119)

			pcall(function()
				O.Gui:Destroy()
			end)
		end
	end

	local l, O

	l = function(arg)
		local handle = arg:FindFirstChild("Handle") or arg:FindFirstChildWhichIsA("BasePart", true)
		if not handle or not handle:IsA("BasePart") then
			return
		end
		local billboardGui = Instance.new("BillboardGui")
		local _
		billboardGui.Name = fn5()
		billboardGui.AlwaysOnTop = true
		billboardGui.LightInfluence = 0
		billboardGui.Size = UDim2.fromOffset(170, 62)
		billboardGui.Adornee = handle
		billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 7, 0)
		billboardGui.MaxDistance = 100000
		handle = Instance.new("Frame")
		handle.Name = fn5()
		handle.BackgroundTransparency = 1
		handle.Size = UDim2.fromScale(1, 1)
		handle.Parent = billboardGui
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.Name = fn5()
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.Parent = handle
		uiListLayout = createTextLabel(handle, 1, 22)
		uiListLayout.Text = arg.Name
		local tbl32, tbl33 = tbl3
		tbl33, uiListLayout.TextColor3 = tbl3, tbl32.RarityColors[tbl3.EggRarity(arg.Name)] or Color3.fromRGB(255, 255, 255)
		tbl32, tbl33 = createTextLabel(handle, 2, 22), createTextLabel(handle, 3, 18)
		tbl33.TextColor3 = Color3.fromRGB(230, 232, 240)
		billboardGui.Parent = folder
		T[arg] = {Gui = billboardGui, Mutation = tbl32, Info = tbl33}
	end

	local function t()
		local tbl32 = tbl3
		local isModel = tbl32.Plot()
		local eggs, _, N = isModel and (isModel:FindFirstChild("Eggs")), {}, ipairs
		tbl32 = (eggs and eggs:GetChildren()) or {}

		for k, v20 in N(tbl32) do
			k = v20:FindFirstChild("EggData")
			eggs, isModel = k and (k:FindFirstChild("Weight")), v20:IsA("Model")
			k = nil

			if isModel then
				local tbl33 = tbl3
				k = tbl33.EggHeavyEnough((eggs and eggs.Value) or 0, y)
			else
				k = isModel
			end

			if k then
				_[v20] = true

				if not T[v20] then
					l(v20)
				end

				local v21 = T[v20]

				if v21 then
					local attribute = v20:GetAttribute("Mutation")
					local F = (type(attribute) == "string") and (attribute ~= "")
					v21.Mutation.Text = (F and attribute) or "No Mutation"
					v21.Mutation.TextColor3 = (F and color) or g
					F, attribute = v21.Info

					if eggs then
						local tbl33 = tbl3
						attribute = tbl33.EggWeightText(eggs.Value)
					else
						attribute = eggs
					end

					F.Text = attribute or ""
				end
			end
		end

		for k in pairs(T) do
			if not _[k] then
				V(k)
			end
		end
	end

	local function x()
		local connection2 = connection

		if connection2 then
			connection:Disconnect()
			connection = nil
		end

		for k in pairs(T) do
			V(k)
		end

		connection2 = folder

		if connection2 then
			local v20 = bit32.bxor(369546234, 0)
			local v202 = v20
			local v21
			v21, v20 = pcall, u32Trunc((u32Mul(281643640, v202) + 2996455784) + (u32Mul(4013323657, (bit32.bor(v202, 350168771))) + u32Mul(4013323655, (bit32.band(v202, 350168771)))))

			v21(function()
				folder:Destroy()
			end)

			folder = nil
		end
	end

	local function fn27()
		local v20 = bit32.bxor(383900356, 0)
		local v202 = v20
		x()
		folder = Instance.new("Folder")
		local folder2, v21 = folder
		folder2.Name = fn5()
		v20 = u32Trunc(v202 + 7788206)
		local L
		v202 = v9
		folder.Parent = v202
		local n12, v22 = 1
		folder2 = RunService
		v20 = u32Trunc(v20 + 513028514)

		connection = folder2.Heartbeat:Connect(function(deltaTime)
			n12 += deltaTime
			deltaTime = n12
			if deltaTime < 0.5 then
				return
			end
			n12 = 0
			pcall(t)
		end)
	end

	local I
	fn6(x)
	local v20
	v192 = v19

	local v21, tbl32, tbl33 = v192:CreateToggle({Name = "ESP Ranch Eggs", Default = false, Callback = function(Z)
		if Z then
			fn27()
		else
			x()
		end
	end}), tbl3, tbl3

	local weightSlider, v193, espMinWeight = tbl33.WeightSlider, v19, {Name = "ESP Min Weight", SubOf = v21}

	local function onRaw(L)
		y = L
	end

	espMinWeight.OnRaw = onRaw
	tbl32.RanchEspWeight = weightSlider(v193, espMinWeight)
end

fn26()

local function fn27()
	local B = bit32.bxor(238786159, 0)
	local T
	local v42 = v4
	local color3FromRGB = v42:CreateTab({Name = "Predictor", SectionsExpanded = true})
	local y
	v42 = tbl2
	v42.WebhookSection = color3FromRGB:CreateSection({Name = "Webhook", Expanded = false})
	v42 = color3FromRGB:CreateSection({Name = "Egg Predictor", Expanded = true})
	local A

	local v20 = fn2(function()
		local Z
		local ReplicatedStorage2 = ReplicatedStorage
		return ReplicatedStorage2.GameData.HatchLuck
	end)

	local Z
	color3FromRGB = tbl
	local pets, eggsList, n12, t, l, O, assetId = color3FromRGB.Pets, {"My Eggs", "On The Map", "All Eggs"}, 11, 36, 3, 8, "rbxassetid://90325592797235"
	local color = Color3.new(1, 1, 1)
	local color2 = Color3.new(0, 0, 0)
	local color3 = Color3.fromRGB(18, 18, 26)
	local color4 = Color3.fromRGB(62, 64, 84)
	local color5, p = Color3.fromRGB(196, 202, 222), {}
	color3FromRGB = Color3.fromRGB
	B = u32Trunc(B + 192954663)
	local o, color3FromRGB2 = color3FromRGB(170, 255, 140), Color3.fromRGB
	B = u32Trunc(B - 139138825)

	do
		local _vals = table.pack(o, color3FromRGB2(40, 230, 90))
		table.move(_vals, 1, _vals.n, 1, p)
	end

	local colorPalette = {Color3.fromRGB(255, 240, 150), Color3.fromRGB(255, 176, 30)}

	local function fn28(P, r)
		local ok, w = pcall(Font.new, P, r, Enum.FontStyle.Normal)
		return (ok and w) or nil
	end

	local json = fn28("rbxassetid://12187365977", Enum.FontWeight.Bold) or fn28("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular)
	local json2 = fn28("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
	local c = {Filter = eggsList[1], Selected = nil, Unit = 14, Width = 300, CardW = 120, CardH = 170}

	local function w(Y, i, parent)
		local instance = Instance.new(Y)

		for k, v21 in pairs(i) do
			instance[k] = v21
		end

		if parent then
			instance.Parent = parent
		end

		return instance
	end

	local function Y(i, J, rotation)
		local paint = i:FindFirstChild("Paint")
		paint = if not paint then w("UIGradient", {Name = "Paint"}, i) else paint
		paint.Color = ColorSequence.new(J[1], J[2])
		paint.Rotation = rotation or 90
		return paint
	end

	local function i(J, fontFace, d, a)
		local TextLabel = w("TextLabel", {BackgroundTransparency = 1, Text = "", TextColor3 = color, TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center}, J)

		if fontFace then
			TextLabel.FontFace = fontFace
		else
			TextLabel.Font = Enum.Font.GothamBold
		end

		for k, v21 in pairs(d) do
			TextLabel[k] = v21
		end

		w("UITextSizeConstraint", {MaxTextSize = 16, MinTextSize = 1}, TextLabel)

		if a then
			w("UIStroke", {Color = color2, Thickness = a, LineJoinMode = Enum.LineJoinMode.Round}, TextLabel)
		end

		return TextLabel
	end

	local function J(j, maxTextSize)
		local uiTextSizeConstraint = j:FindFirstChildOfClass("UITextSizeConstraint")
		maxTextSize = math.max(6, math.floor(maxTextSize))

		if uiTextSizeConstraint and (uiTextSizeConstraint.MaxTextSize ~= maxTextSize) then
			uiTextSizeConstraint.MaxTextSize = maxTextSize
			local uiStroke = j:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				uiStroke.Thickness = math.max(1, maxTextSize * 0.08)
			end
		end
	end

	local function j(d, a, S)
		if d[a] ~= S then
			d[a] = S
		end
	end

	local function formatCompact(a)
		local unitSuffixes = {"", "K", "M", "B", "T", "Qa", "Qi", "Sx"}
		a = tonumber(a) or 0
		local u = 1

		while (a >= 1000) and (u < #unitSuffixes) do
			a, u = a / 1000, u + 1
		end

		local z = ((u == 1) and tostring(math.floor(a))) or string.format(((a >= 100) and "%.0f") or "%.1f", a)
		return string.gsub(z, "%.0$", "") .. unitSuffixes[u]
	end

	local function a(S)
		S = (tonumber(S) or 0) * 100

		if S >= 10 then
			return string.format("%.1f%%", S)
		elseif S >= 0.01 then
			return string.format("%.2f%%", S)
		elseif S > 0 then
			return "<0.01%"
		end

		return "0%"
	end

	local function S(u)
		local z
		local tbl32 = tbl3
		return tbl32.RarityColors[tostring(u)] or color
	end

	local function u()
		local z = bit32.bxor(175629414, 0)
		local D = z
		local X = 1
		z = u32Trunc((u32Mul(1653317106, D) + 1408919676) + (u32Mul(2641650191, (bit32.bor(D, 360366))) + u32Mul(2641650189, (bit32.band(D, 360366)))))
		D = nil
		D, z = pcall, bit32.bxor(z, 94468160)

		D(function()
			local v21
			local tbl32, n13, v22, localPlayer2 = tbl3, tonumber(tbl3.Saved("HatchUpgrades")) or 0
			localPlayer2, X = localPlayer, v20.GetMultiplier(v20.EffectiveUpgrades(localPlayer, n13))
		end)

		local V = 1

		pcall(function()
			V = v20.EventMultiplier()
		end)

		local n13, n14 = tonumber(X) or 1, tonumber(V) or 1
		return n13, n14
	end

	local V = {}

	local function z(D)
		local X, H = u()
		local R = string.format("%s|%s|%s", tostring(D), tostring(X), tostring(H))
		local tbl32 = V[R]
		if tbl32 then
			return tbl32
		end
		local Q
		tbl32 = tbl3
		local v21 = tbl32.EggData(D)
		local M = {Name = tostring(D), Rarity = (v21 and tostring(v21.Rarity)) or "Common", Image = (v21 and tostring(v21.Image or "")) or "", Luck = 0, Pets = {}, Average = 0, Best = nil}

		if v21 and (type(v20) == "table") then
			local C = bit32.bxor(189316488, 0)
			D = C
			tbl32 = nil
			tbl32, C = pcall, u32Trunc((u32Mul(578687298, D) + 2924362980) + (u32Mul(3716279999, (bit32.bor(429264690, D))) + u32Mul(3716279997, (bit32.band(D, 429264690)))))

			tbl32(function()
				local v22 = bit32.bxor(220743288, 0)
				local v222 = v22
				local luck = math.max((tonumber(v21.Luck) or 1) * X, 1)
				M.Luck = luck
				local getBoostedOdds, luck2 = v20.GetBoostedOdds, M.Luck
				v22 = u32Trunc(v222 + 273143996)

				for i2, v23 in ipairs((getBoostedOdds(luck2, H, v21))) do
					i2 = tonumber(v23.Chance) or 0

					if i2 > 0 then
						v222 = ((type(pets) == "table") and pets[v23.PetName]) or nil
						local best = {Name = tostring(v23.PetName), Chance = i2, Rarity = (v222 and tostring(v222.Rarity)) or "Common", Image = (v222 and tostring(v222.Image or "")) or "", Income = (v222 and tonumber(v222.Income)) or 0}
						table.insert(M.Pets, best)
						M.Average = M.Average + (i2 * best.Income)

						if not M.Best or (best.Income > M.Best.Income) then
							M.Best = best
						end
					end
				end

				luck2, v222 = table.sort, u32Trunc(luck)
				v22 = u32Trunc((4017619795 + v22) + (u32Mul(4290365467, v222) + u32Mul(4290365467, (bit32.bnot(v222)))))

				luck2(M.Pets, function(arg, arg2)
					if arg.Chance ~= arg2.Chance then
						return arg.Chance > arg2.Chance
					end
					return arg.Name < arg2.Name
				end)
			end)
		end

		V[R] = M
		return M
	end

	local function fn29()
		local v21, list2, D = bit32.bxor(350111907, 0), {}, {Mine = 0}
		v21 = u32Trunc(v21 + 11064279)
		D.Map = 0
		local v22
		local tbl32 = tbl3
		local timer = tbl32.Plot()
		local eggs, list3, tbl33 = timer and (timer:FindFirstChild("Eggs")), {}, ipairs
		tbl32 = (eggs and eggs:GetChildren()) or {}

		for k, v23 in tbl33(tbl32) do
			timer = v23:FindFirstChild("Timer", true)
			eggs = ((timer and timer:IsA("TextLabel")) and timer.Text) or ""
			k = eggs == "Ready"
			table.insert(list3, {Id = "plot:" .. tostring(v23:GetAttribute("EggKey") or v23.Name), Egg = v23.Name, Badge = (k and "READY") or (((eggs ~= "") and eggs) or "GROWING"), BadgeColor = (k and Color3.fromRGB(77, 255, 122)) or Color3.fromRGB(255, 194, 77), Note = "Placed", Mutation = (((type(v23:GetAttribute("Mutation")) == "string") and (v23:GetAttribute("Mutation") ~= "")) and v23:GetAttribute("Mutation")) or nil, Order = (k and 0) or 1})
			k = #list3
			local C = list3[k]
			v23 = C.Mutation

			if v23 then
				local M = bit32.bxor(426866428, 0)
				local v24 = M
				local tbl34 = tbl3
				C.Factor = tbl34.MutationBonus(C.Mutation)
				local stringFormat, mutation, v25, v242, U = string.format, C.Mutation, table.pack(tostring(C.Factor)), v24, u32Trunc(k)
				M = u32Trunc((204350477 + u32Mul(223057481, v242)) + (u32Mul(223057480, U) + (u32Mul(3848852336, (bit32.bor(v242, U))) + u32Mul(223057480, (bit32.bxor(U, v242))))))
				C.Note = stringFormat("%s x%s", mutation, table.unpack(v25, 1, v25.n))
				C.MutationColor = Color3.fromRGB(255, 194, 77)
				v24 = pcall

				local function Q()
					local v26 = tbl
					local mutation2 = v26.Mutations.ColorFor(C.Mutation)

					if typeof(mutation2) == "Color3" then
						C.MutationColor = mutation2
					end
				end

				v24(Q)
			end
		end

		tbl32, timer, tbl33, eggs = #list3, {}, tbl3, 0

		for _, v23 in ipairs(tbl33.Tools("Egg")) do
			eggs += 1
			timer[v23.Name] = (timer[v23.Name] or 0) + 1
		end

		for k, v23 in pairs(timer) do
			local insert, C = table.insert, {Id = "bag:" .. k, Egg = k, Badge = "BAG x" .. v23, BadgeColor = Color3.fromRGB(127, 216, 255)}
			C.Note, C.Order = ((v23 == 1) and "In your bag") or (v23 .. " in your bag"), 2
			insert(list3, C)
		end

		D.Mine = tbl32 + eggs
		timer, eggs = {}, tbl3
		tbl32 = eggs.Root()
		local h
		tbl33 = activeEggs

		for i2, child in ipairs(tbl33:GetChildren()) do
			i2, eggs = child:GetAttribute("Egg"), child:GetAttribute("Position")

			if type(i2) == "string" then
				D.Map = D.Map + 1
				child = timer[i2]

				if not child then
					child = {Count = 0, Nearest = 1 / 0}
					timer[i2] = child
				else
				end

				child.Count = child.Count + 1

				if tbl32 and (typeof(eggs) == "Vector3") then
					child.Nearest = math.min(child.Nearest, (eggs - tbl32.Position).Magnitude)
				end
			end
		end

		eggs = c.Filter == eggsList[1]

		if eggs then
			list2 = list3
		else
			tbl32 = c.Filter == eggsList[2]

			if tbl32 then
				for k, v23 in pairs(timer) do
					local insert, x = table.insert, {Id = "map:" .. k, Egg = k, Badge = "x" .. v23.Count, BadgeColor = Color3.fromRGB(255, 154, 61)}
					x.Note, x.Order = ((v23.Nearest < (1 / 0)) and string.format("Nearest %d studs", math.floor(v23.Nearest))) or "On the map", 0
					insert(list2, x)
				end
			else
				local v23
				tbl33 = names

				for _, v24 in ipairs(tbl33) do
					table.insert(list2, {Id = "all:" .. v24, Egg = v24, Badge = (timer[v24] and ("x" .. timer[v24].Count)) or "", BadgeColor = Color3.fromRGB(255, 154, 61), Note = (timer[v24] and "On the map now") or "Not on the map", Order = 0})
				end
			end
		end

		for _, v23 in ipairs(list2) do
			v23.Info = z(v23.Egg)
		end

		table.sort(list2, function(arg, arg2)
			if arg.Order ~= arg2.Order then
				return arg.Order < arg2.Order
			end

			if arg.Info.Luck ~= arg2.Info.Luck then
				return arg.Info.Luck > arg2.Info.Luck
			end
			return arg.Id < arg2.Id
		end)

		return list2, D
	end

	local tbl5, h = {Cards = {}, Chips = {}, Tiles = {}, HeroPets = {}}
	local K, n13 = true, 0

	local function x(G)
		local tbl6 = {Frame = w("Frame", {BackgroundTransparency = 1}, G)}
		tbl6.Icon = w("ImageLabel", {BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, Size = UDim2.fromScale(0.16, 1)}, tbl6.Frame)
		tbl6.Name = i(tbl6.Frame, json, {Position = UDim2.fromScale(0.19, 0), Size = UDim2.fromScale(0.46, 0.62)}, 1.2)
		tbl6.Chance = i(tbl6.Frame, json, {Position = UDim2.fromScale(0.65, 0), Size = UDim2.fromScale(0.35, 0.62), TextXAlignment = Enum.TextXAlignment.Right}, 1.2)
		tbl6.Back = w("Frame", {BackgroundColor3 = Color3.fromRGB(42, 46, 60), BorderSizePixel = 0, Position = UDim2.fromScale(0.19, 0.72), Size = UDim2.fromScale(0.81, 0.16)}, tbl6.Frame)
		w("UICorner", {CornerRadius = UDim.new(1, 0)}, tbl6.Back)
		tbl6.Fill = w("Frame", {BackgroundColor3 = color, BorderSizePixel = 0, Size = UDim2.fromScale(0, 1)}, tbl6.Back)
		w("UICorner", {CornerRadius = UDim.new(1, 0)}, tbl6.Fill)
		return tbl6
	end

	local function G(arg, D)
		j(arg.Frame, "Visible", D ~= nil)
		if not D then
			return
		end
		local X = S(D.Rarity)
		j(arg.Icon, "Image", D.Image)
		j(arg.Name, "Text", D.Name)
		j(arg.Name, "TextColor3", X)
		j(arg.Chance, "Text", a(D.Chance))
		j(arg.Fill, "BackgroundColor3", X)
		j(arg.Fill, "Size", UDim2.fromScale(math.clamp(D.Chance, 0.02, 1), 1))
	end

	local function fn30(D)
		local X = bit32.bxor(268897540, 0)
		local H = X
		local R = {Rows = {}, Frame = w("Frame", {BackgroundColor3 = color3, BackgroundTransparency = 0.04, BorderSizePixel = 0, LayoutOrder = D, Visible = false}, tbl5.Grid)}
		w("UICorner", {CornerRadius = UDim.new(0.07, 0)}, R.Frame)
		X = u32Trunc((u32Mul(2325630253, H) + 4076967506) + (u32Mul(2, (bit32.bor(H, 217999790))) + (2325630254 + u32Mul(2325630254, (bit32.bnot(H))))))
		R.Stroke = w("UIStroke", {Color = color4, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, R.Frame)
		R.Glow = w("Frame", {BackgroundColor3 = color, BackgroundTransparency = 0.55, BorderSizePixel = 0, Size = UDim2.fromScale(1, 0.46)}, R.Frame)
		w("UICorner", {CornerRadius = UDim.new(0.14, 0)}, R.Glow)
		w("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1)})}, R.Glow)
		local activated, tbl6, uDim2FromOffset = w, {BackgroundTransparency = 1, Image = assetId, ImageTransparency = 0.93, ScaleType = Enum.ScaleType.Tile}, UDim2.fromOffset
		X = bit32.bxor(X, 258049008)
		tbl6.TileSize = uDim2FromOffset(44, 44)
		tbl6.Size = UDim2.fromScale(1, 1)
		activated("ImageLabel", tbl6, R.Frame)
		R.Image = w("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0.03), ScaleType = Enum.ScaleType.Fit, Size = UDim2.fromScale(0.62, 0.3)}, R.Frame)
		R.BadgeBack = w("Frame", {BackgroundColor3 = color3, BackgroundTransparency = 0.1, BorderSizePixel = 0, Position = UDim2.fromScale(0.04, 0.03), Size = UDim2.fromScale(0.44, 0.075)}, R.Frame)
		w("UICorner", {CornerRadius = UDim.new(0.4, 0)}, R.BadgeBack)
		R.BadgeStroke = w("UIStroke", {Color = color, Thickness = 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, R.BadgeBack)
		R.Badge = i(R.BadgeBack, json, {Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center}, nil)
		R.Mutation = i(R.Frame, json, {Position = UDim2.fromScale(0.5, 0.03), Size = UDim2.fromScale(0.46, 0.075), TextXAlignment = Enum.TextXAlignment.Right, Visible = false}, 1.4)
		X = bit32.bxor(X, 237503935)
		R.Name = i(R.Frame, json, {Position = UDim2.fromScale(0.05, 0.34), Size = UDim2.fromScale(0.9, 0.085), TextXAlignment = Enum.TextXAlignment.Center}, 1.5)
		R.Luck = i(R.Frame, json, {Position = UDim2.fromScale(0.05, 0.425), Size = UDim2.fromScale(0.9, 0.065), TextXAlignment = Enum.TextXAlignment.Center}, 1.2)
		Y(R.Luck, p, 90)

		for i2 = 1, l, 1 do
			uDim2FromOffset = x(R.Frame)
			uDim2FromOffset.Frame.Position = UDim2.fromScale(0.06, 0.51 + ((i2 - 1) * 0.125))
			uDim2FromOffset.Frame.Size = UDim2.fromScale(0.88, 0.11)
			R.Rows[i2] = uDim2FromOffset
		end

		R.Average = i(R.Frame, json, {Position = UDim2.fromScale(0.05, 0.895), Size = UDim2.fromScale(0.9, 0.07), TextXAlignment = Enum.TextXAlignment.Center}, 1.2)
		Y(R.Average, colorPalette, 90)
		R.Button = w("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", ZIndex = 10}, R.Frame)
		activated = R.Button.Activated

		local function fn31()
			local id = R.Id

			if id then
				if c.Selected == R.Id then
					c.Selected = nil
					c.Dismissed = true
				else
					c.Selected = R.Id
					c.Dismissed = false
				end

				K = true
			end
		end

		activated:Connect(fn31)
		return R
	end

	local function fn31(D)
		local cardH = c.CardH
		J(D.Badge, cardH * 0.05)
		J(D.Mutation, cardH * 0.05)
		J(D.Name, cardH * 0.072)
		J(D.Luck, cardH * 0.056)
		J(D.Average, cardH * 0.056)

		for _, row in ipairs(D.Rows) do
			J(row.Name, cardH * 0.058)
			J(row.Chance, cardH * 0.058)
		end
	end

	local function D(X, H)
		X.Id = (H and H.Id) or nil
		j(X.Frame, "Visible", H ~= nil)
		if not H then
			return
		end
		local info = H.Info
		local k, Q = S(info.Rarity), c.Selected == H.Id
		j(X.Glow, "BackgroundColor3", k)
		j(X.Stroke, "Color", (Q and Color3.fromRGB(255, 214, 90)) or k:Lerp(color4, 0.55))
		j(X.Stroke, "Thickness", (Q and math.max(2.5, c.CardH * 0.012)) or 1.5)
		j(X.Image, "Image", info.Image)
		j(X.Name, "Text", info.Name)
		j(X.Name, "TextColor3", k)
		j(X.Luck, "Text", "LUCK " .. formatCompact(info.Luck))
		j(X.BadgeBack, "Visible", H.Badge ~= "")
		j(X.Badge, "Text", H.Badge)
		j(X.Badge, "TextColor3", H.BadgeColor)
		j(X.BadgeStroke, "Color", H.BadgeColor)
		j(X.Mutation, "Visible", H.Mutation ~= nil)

		if H.Mutation then
			j(X.Mutation, "Text", H.Mutation)
			j(X.Mutation, "TextColor3", H.MutationColor)
		end

		for i2, row in ipairs(X.Rows) do
			G(row, info.Pets[i2])
		end

		j(X.Average, "Text", "AVG $" .. (formatCompact(info.Average * (H.Factor or 1)) .. "/s"))
	end

	local function X(H)
		local hero, heroShown = tbl5.Hero, H ~= nil
		local Q = tbl5.HeroShown ~= heroShown

		if Q then
			local M = bit32.bxor(428512900, 0)
			local C = M
			M = bit32.bxor(C, 227777552)
			tbl5.HeroShown = heroShown
			M = u32Trunc((u32Mul(1638559932, M) + 3829936748) + (u32Mul(1017847432, (bit32.bor(M, 306552661))) + u32Mul(1638559933, (bit32.bxor(M, 306552661)))))

			pcall(function()
				h:SetDock((heroShown and n12) or 0, {Gap = 0.35, Divider = false})
			end)
		end

		j(hero.Frame, "Visible", heroShown)
		if not H then
			return
		end
		Q = H.Info
		local best = S(Q.Rarity)
		j(hero.Art, "BackgroundColor3", best)
		j(hero.Stroke, "Color", best:Lerp(color4, 0.4))
		j(hero.Image, "Image", Q.Image)
		j(hero.Name, "Text", Q.Name)
		j(hero.Name, "TextColor3", best)
		j(hero.Rarity, "Text", string.upper(Q.Rarity) .. ("  |  " .. H.Note))
		j(hero.Luck, "Text", "LUCK " .. formatCompact(Q.Luck))
		j(hero.Average, "Text", "AVG $" .. (formatCompact(Q.Average * (H.Factor or 1)) .. "/s"))
		best = Q.Best
		j(hero.Best, "Text", (best and ("BEST  " .. (best.Name .. ("  " .. a(best.Chance))))) or "")
		j(hero.Best, "TextColor3", (best and S(best.Rarity)) or color)

		for i2, heroPet in ipairs(tbl5.HeroPets) do
			G(heroPet, Q.Pets[i2])
		end
	end

	local function fn32()
		local v21 = bit32.bxor(511123379, 0)
		local v212 = v21
		v21 = u32Trunc((u32Mul(4294967295, v212) + 1150367131) + (u32Mul(2, (bit32.bor(v212, 465778263))) + (1825720414 + 853101488)))
		if not tbl5.Grid then
			return
		end
		local H, R
		local k, Q = 1, 1
		v21 = bit32.bxor(v21, 114576629)

		task.spawn(function()
			local ok, M, C = pcall(fn29)

			if ok then
				H, R = M, C
			end

			ok, C, M = pcall(u)

			if ok then
				k, Q = C, M
			end
		end)

		v212 = not H or not R
		if v212 then
			return
		end
		j(tbl5.Tiles[1].Value, "Text", "x" .. (formatCompact(k) .. (((Q > 1) and ("  x" .. formatCompact(Q))) or "")))
		j(tbl5.Tiles[2].Value, "Text", tostring(R.Mine))
		j(tbl5.Tiles[3].Value, "Text", tostring(R.Map))

		for i2, chip in ipairs(tbl5.Chips) do
			i2 = chip.Key == c.Filter
			j(chip.Button, "BackgroundTransparency", (i2 and 0) or 0.35)
			Y(chip.Button, (i2 and p) or {Color3.fromRGB(46, 48, 62), Color3.fromRGB(30, 32, 44)}, 90)
		end

		v212 = c.Selected

		if v212 then
			local v22, d = H, false

			for _, v23 in ipairs(v22) do
				if v23.Id == c.Selected then
					d = true
					break
				end
			end

			if not d then
				c.Selected = nil
			end
		end

		v212 = not c.Selected and not c.Dismissed

		if v212 then
			local v22, d = H

			for _, v23 in ipairs(v22) do
				d = if not d or (v23.Info.Average > d.Info.Average) then v23 else d
			end

			c.Selected = (d and d.Id) or nil
		end

		local v22, cards, v2122 = ipairs, tbl5.Cards

		for k2, card in v22(cards) do
			v212 = H[k2]
			D(card, v212)
			v2122 = if v212 and (v212.Id == c.Selected) then v212 else v2122
		end

		cards = c.Selected and not v2122

		if cards then
			v212 = H

			for _, v23 in ipairs(v212) do
				if v23.Id == c.Selected then
					v2122 = v23
					break
				end
			end
		else
		end

		j(tbl5.Empty, "Visible", #H == 0)
		j(tbl5.Empty, "Text", ((c.Filter == eggsList[1]) and "No eggs yet. Place an egg or pick one up to see its pets.") or "No eggs on the map right now.")
		j(tbl5.Footer, "Text", ((#H > t) and string.format("Showing %d of %d", t, #H)) or "Tap an egg to see every pet it can hatch")
		X(v2122)
	end

	local function fn33()
		if not tbl5.Grid then
			return
		end
		local unit, width = c.Unit, c.Width
		local n14, n15 = math.max(4, math.floor(unit * 0.3)), math.max(8, math.floor(unit * 0.6))
		local n16 = math.max(1, (width - (n14 * 2)) - math.max(6, math.floor(width * 0.012)))
		tbl5.Container.Position = UDim2.fromOffset(n14, n14)
		tbl5.Container.Size = UDim2.new(0, n16, 0, 0)
		tbl5.Container:FindFirstChildOfClass("UIListLayout").Padding = UDim.new(0, n15)
		width = math.clamp(math.floor((n16 + n15) / ((unit * 8.4) + n15)), 3, 6)
		local cardW = math.floor((n16 - (n15 * (width - 1))) / width)
		width = math.floor(cardW * 1.62)
		c.CardW = cardW
		c.CardH = width
		local uiGridLayout = tbl5.Grid:FindFirstChildOfClass("UIGridLayout")
		uiGridLayout.CellSize = UDim2.fromOffset(cardW, width)
		uiGridLayout.CellPadding = UDim2.fromOffset(n15, n15)
		tbl5.TileRow.Size = UDim2.new(1, 0, 0, math.floor(unit * 2.7))
		tbl5.ChipRow.Size = UDim2.new(1, 0, 0, math.floor(unit * 2))

		for _, tile in ipairs(tbl5.Tiles) do
			J(tile.Value, unit * 1.2)
			J(tile.Caption, unit * 0.72)
		end

		for _, chip in ipairs(tbl5.Chips) do
			J(chip.Label, unit * 0.92)
		end

		J(tbl5.Empty, unit)
		tbl5.Empty.Size = UDim2.new(1, 0, 0, math.floor(unit * 2.4))
		J(tbl5.Footer, unit * 0.75)
		tbl5.Footer.Size = UDim2.new(1, 0, 0, math.floor(unit * 1.4))

		for _, card in ipairs(tbl5.Cards) do
			fn31(card)
		end

		n15, cardW = tbl5.Hero, (n12 * unit) - (n14 * 2)
		n15.Frame.Position = UDim2.fromOffset(n14, n14)
		n15.Frame.Size = UDim2.new(0, n16, 0, cardW)
		J(n15.Name, cardW * 0.13)
		J(n15.Rarity, cardW * 0.075)
		J(n15.Luck, cardW * 0.095)
		J(n15.Average, cardW * 0.095)
		J(n15.Best, cardW * 0.085)

		for _, heroPet in ipairs(tbl5.HeroPets) do
			J(heroPet.Name, cardW * 0.115)
			J(heroPet.Chance, cardW * 0.115)
		end

		K = true
	end

	local function fn34(arg)
		local v21 = bit32.bxor(423980799, 0)
		local v212 = v21
		h = arg
		tbl5.Container = w("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 0)}, nil)
		w("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Vertical}, tbl5.Container)
		tbl5.TileRow = w("Frame", {BackgroundTransparency = 1, LayoutOrder = 1}, tbl5.Container)
		w("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, tbl5.TileRow)
		local hero, d = ipairs, {{"HATCH LUCK", p}, {"MY EGGS", {color, Color3.fromRGB(190, 200, 225)}}, {"ON THE MAP", {Color3.fromRGB(255, 214, 140), Color3.fromRGB(255, 154, 61)}}}

		for k, v22 in hero(d) do
			local tbl6 = {Frame = w("Frame", {BackgroundColor3 = color3, BackgroundTransparency = 0.12, BorderSizePixel = 0, LayoutOrder = k, Size = UDim2.new(0.3333333333333333, -6, 1, 0)}, tbl5.TileRow)}
			w("UICorner", {CornerRadius = UDim.new(0.22, 0)}, tbl6.Frame)
			w("UIStroke", {Color = color4, Thickness = 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, tbl6.Frame)
			tbl6.Value = i(tbl6.Frame, json, {Position = UDim2.fromScale(0.08, 0.1), Size = UDim2.fromScale(0.84, 0.5)}, 1.4)
			Y(tbl6.Value, v22[2], 90)
			tbl6.Caption = i(tbl6.Frame, json2, {Position = UDim2.fromScale(0.08, 0.6), Size = UDim2.fromScale(0.84, 0.3), Text = v22[1], TextColor3 = color5}, nil)
			tbl5.Tiles[k] = tbl6
		end

		tbl5.ChipRow = w("Frame", {BackgroundTransparency = 1, LayoutOrder = 2}, tbl5.Container)
		w("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, tbl5.ChipRow)

		for i2, v22 in ipairs(eggsList) do
			local q, tbl6 = bit32.bxor(105326462, 0), {Key = v22}
			q = bit32.bxor(q, 373089910)
			d = nil
			d, q = {AutoButtonColor = false, BackgroundColor3 = color, BorderSizePixel = 0, LayoutOrder = i2, Size = UDim2.new(0.3333333333333333, -6, 1, 0), Text = ""}, bit32.bxor(q, 244140780)
			tbl6.Button = w("TextButton", d, tbl5.ChipRow)
			hero = w
			q = bit32.bxor(q, 176468286)
			q = bit32.bxor(q, 78134308)
			hero("UICorner", {CornerRadius = UDim.new(0.35, 0)}, tbl6.Button)
			local tbl7, button
			tbl7, button, q = {Color = color2, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, tbl6.Button, bit32.bxor(q, 94752596)
			w("UIStroke", tbl7, button)
			button = i
			q = bit32.bxor(q, 152903452)
			local button2, textLabel, uDim2FromScale = tbl6.Button, {}, UDim2.fromScale
			q = bit32.bxor(q, 128195870)
			textLabel.Size = uDim2FromScale(1, 1)
			textLabel.Text = string.upper(v22)
			textLabel.TextXAlignment = Enum.TextXAlignment.Center
			q = bit32.bxor(q, 276761407)
			q = bit32.bxor(q, 385721846)
			tbl6.Label = button(button2, json, textLabel, 1.4)
			textLabel = tbl6.Button.Activated

			local function fn35()
				c.Filter = v22
				c.Selected = nil
				c.Dismissed = false
				K = true
			end

			textLabel:Connect(fn35)
			tbl5.Chips[i2] = tbl6
		end

		tbl5.Empty = i(tbl5.Container, json2, {LayoutOrder = 3, TextColor3 = color5, TextXAlignment = Enum.TextXAlignment.Center, Visible = false}, nil)
		tbl5.Grid = w("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 4, Size = UDim2.fromScale(1, 0)}, tbl5.Container)
		w("UIGridLayout", {SortOrder = Enum.SortOrder.LayoutOrder, CellSize = UDim2.fromOffset(120, 190)}, tbl5.Grid)

		for i2 = 1, t, 1 do
			tbl5.Cards[i2] = fn30(i2)
		end

		tbl5.Footer = i(tbl5.Container, json2, {LayoutOrder = 5, TextColor3 = color5, TextXAlignment = Enum.TextXAlignment.Center}, nil)
		hero = {Frame = w("Frame", {BackgroundColor3 = color3, BackgroundTransparency = 0.04, BorderSizePixel = 0, Visible = false}, nil)}
		w("UICorner", {CornerRadius = UDim.new(0.08, 0)}, hero.Frame)
		hero.Stroke = w("UIStroke", {Color = color4, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, hero.Frame)
		w("ImageLabel", {BackgroundTransparency = 1, Image = assetId, ImageTransparency = 0.94, ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.fromOffset(46, 46), Size = UDim2.fromScale(1, 1)}, hero.Frame)
		hero.Art = w("Frame", {BackgroundColor3 = color, BackgroundTransparency = 0.5, BorderSizePixel = 0, Size = UDim2.fromScale(0.22, 1)}, hero.Frame)
		w("UICorner", {CornerRadius = UDim.new(0.08, 0)}, hero.Art)
		w("UIGradient", {Rotation = 0, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1)})}, hero.Art)
		hero.Image = w("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0.11, 0.42), ScaleType = Enum.ScaleType.Fit, Size = UDim2.fromScale(0.18, 0.7)}, hero.Frame)
		hero.Name = i(hero.Frame, json, {Position = UDim2.fromScale(0.015, 0.78), Size = UDim2.fromScale(0.2, 0.16), TextXAlignment = Enum.TextXAlignment.Center}, 1.6)
		local q, frame, v2122, _ = i, hero.Frame, v212, u32Trunc(t)
		v21 = u32Trunc((2763770037 + v2122) + (u32Mul(2432363701, _) + u32Mul(2432363701, (bit32.bnot(_)))))
		_ = u32Trunc(t)
		v21 = u32Trunc((3913732723 + v21) + (u32Mul(3834349822, _) + u32Mul(3834349822, (bit32.bnot(_)))))
		hero.Rarity = q(frame, json2, {Position = UDim2.fromScale(0.235, 0.05), Size = UDim2.fromScale(0.2, 0.1), TextColor3 = color5}, nil)
		hero.Luck = i(hero.Frame, json, {Position = UDim2.fromScale(0.235, 0.16), Size = UDim2.fromScale(0.2, 0.13)}, 1.4)
		Y(hero.Luck, p, 90)
		hero.Average = i(hero.Frame, json, {Position = UDim2.fromScale(0.235, 0.3), Size = UDim2.fromScale(0.2, 0.13)}, 1.4)
		Y(hero.Average, colorPalette, 90)
		hero.Best = i(hero.Frame, json, {Position = UDim2.fromScale(0.235, 0.45), Size = UDim2.fromScale(0.2, 0.12)}, 1.4)
		hero.Hint = i(hero.Frame, json2, {Position = UDim2.fromScale(0.235, 0.62), Size = UDim2.fromScale(0.2, 0.32), Text = "Chances use your Hatch Luck. The pet is rolled when the egg hatches.", TextColor3 = color5, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top}, nil)
		hero.Hint:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = 12
		hero.List = w("Frame", {BackgroundTransparency = 1, Position = UDim2.fromScale(0.455, 0.05), Size = UDim2.fromScale(0.53, 0.9)}, hero.Frame)
		w("UIGridLayout", {CellPadding = UDim2.fromScale(0.04, 0.03), CellSize = UDim2.fromScale(0.48, 0.225), SortOrder = Enum.SortOrder.LayoutOrder}, hero.List)

		for i2 = 1, O, 1 do
			q = x(hero.List)
			q.Frame.LayoutOrder = i2
			tbl5.HeroPets[i2] = q
		end

		tbl5.Hero = hero
		arg:Attach(hero.Frame, arg:Dock())
		arg:Attach(tbl5.Container, arg:Root())

		local function fn35(_, arg2, arg3)
			c.Width = tonumber(arg2) or c.Width
			c.Unit = math.max(8, tonumber(arg3) or c.Unit)
			pcall(fn33)
		end

		arg:OnResize(fn35)
		pcall(fn33)
	end

	fn28 = type(v42.CreateCanvas) ~= "function"

	if fn28 then
		v42:CreateText({Name = "Egg Predictor", Text = "This library version cannot draw the predictor."})
	else
		local v21 = bit32.bxor(141097280, 0)
		local eggPredictor = {Name = "Egg Predictor", ShowTitle = false, Layout = "free", Style = {TextScale = 0.84, LineHeight = 1.1, MinLines = 16, MaxLines = 34, BackgroundTransparency = 0.5, ScrollBarColor = Color3.fromRGB(170, 174, 184), TextColor = Color3.fromRGB(255, 255, 255), TextStrokeTransparency = 0.7}}
		v21 = u32Trunc(v21 + 517258551)

		eggPredictor.Build = function(arg)
			fn34(arg)
		end

		local v22 = v42:CreateCanvas(eggPredictor)
		local v23
		color3FromRGB = RunService

		local connection = color3FromRGB.Heartbeat:Connect(function(deltaTime)
			local q, flag2 = not tbl5.Container

			if q then
				flag2 = q
			else
				local gameRef = game
				flag2 = not tbl5.Container:IsDescendantOf(gameRef)
			end

			if flag2 then
				return
			end
			q, flag2 = tbl5.Container, true

			while q and (q:IsA("GuiObject")) do
				if not q.Visible then
					flag2 = false
					break
				end
				q = q.Parent
			end

			if not flag2 then
				return
			end
			n13 += deltaTime
			deltaTime = K or (n13 >= 1)

			if deltaTime then
				K, n13 = false, 0
				pcall(fn32)
			end
		end)

		local L

		fn6(function()
			local v24 = bit32.bxor(29421705, 0)
			local v242 = v24
			v24 = u32Trunc(v242 + 50144572)
			connection:Disconnect()
			v242 = nil
			v242, v24 = pcall, u32Trunc(v24 + 56414535)

			v242(function()
				v22:Destroy()
			end)
		end)
	end
end

fn27()
local v20 = v4:CreateTab({ Name = "Server", SectionsExpanded = true }):CreateSection({ Name = "Server", Expanded = true })
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function fn28()
	local B, V = bit32.bxor(232597168, 0), "__ChilliAutoLoadScriptEnabled"
	B = bit32.bxor(B, 325957370)
	local x = "local TeleportService = game:GetService(\"TeleportService\")\nlocal enabled = true\npcall(function()\n    enabled = TeleportService:GetTeleportSetting(\"__ChilliAutoLoadScriptEnabled\") == true\nend)\nif enabled then\n    local ok, source = pcall(function()\n        return game:HttpGet(\"https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua\")\n    end)\n    if ok and type(source) == \"string\" then\n        local chunk = loadstring(source)\n        if chunk then\n            chunk()\n        end\n    end\nend\n"
	B = u32Trunc((u32Mul(703498875, B) + 2984697857) + (u32Mul(2887969546, (bit32.bor(B, 147612851))) + u32Mul(703498876, (bit32.bxor(B, 147612851)))))

	local function fn29()
		if type(queue_on_teleport) == "function" then
			return queue_on_teleport
		end

		if type(queueonteleport) == "function" then
			return queueonteleport
		end

		if (type(syn) == "table") and (type(syn.queue_on_teleport) == "function") then
			return syn.queue_on_teleport
		end

		if (type(fluxus) == "table") and (type(fluxus.queue_on_teleport) == "function") then
			return fluxus.queue_on_teleport
		end
		return nil
	end

	local function G(g)
		local f = bit32.bxor(262480460, 0)
		local T = f
		local y
		y, f = pcall, u32Trunc(T + 491315777)

		y(function()
			local v21
			local TeleportService2 = TeleportService
			TeleportService2:SetTeleportSetting(V, g)
		end)

		if not g then
			return true
		end
		y = fn29()
		if not y then
			return false
		end

		if rawget(_G, "__ChilliAutoLoadQueued") ~= true then
			if not pcall(y, x) then
				return false
			end
			_G.__ChilliAutoLoadQueued = true
		end

		return true
	end

	local v21, fn30, v22

	fn30 = function()
		local v212, v213 = v21

		if v212 then
			local tbl22 = tbl2
			v213 = tbl22.Toggle(v21, false)
		else
			v213 = v212
		end

		if v213 then
			G(true)
		end
	end

	local v23
	local v202 = v20

	v21 = v202:CreateToggle({Name = "Auto Load Script", Default = true, Callback = function(arg)
		local g = arg == true
		arg = not G(g) and g

		if arg then
			local v24 = bit32.bxor(232910025, 0)
			g = v24
			local f = task
			v24 = bit32.bxor(g, 5289006)
			local defer = f.defer
			v24 = u32Trunc((u32Mul(44927722, v24) + 1147102432) + (u32Mul(4250039575, (bit32.bor(v24, 226486960))) + u32Mul(4250039573, (bit32.band(v24, 226486960)))))

			defer(function()
				G(false)

				if v21 and (type(v21.Set) == "function") then
					pcall(v21.Set, v21, false, false)
				end

				local v25
				fn9("Auto Load Unavailable", "This executor does not support queue on teleport.")
			end)
		end
	end})

	local str3, n12, n13, g, f, id = "Least Players", 10, 0.1, 1, 0
	local y, t, l, O, F = {}, false, 0, false
	local W, _, N = "", 0, 60

	local function b(m)
		f, id = 0, nil

		if m then
			y[m] = true
		end
	end

	local function m()
		local p = bit32.bxor(455388289, 0)
		local teleportInitFailed = p
		local P
		local TeleportService2 = TeleportService
		p = u32Trunc(teleportInitFailed + 226094834)
		teleportInitFailed = nil
		teleportInitFailed, p = TeleportService2.TeleportInitFailed, u32Trunc(p + 199402393)

		teleportInitFailed:Connect(function(arg, o, arg2)
			arg = id
			if not arg then
				return
			end
			arg = id
			b(arg)
			O = true
			arg = not t

			if arg then
				local v24
				fn9("Server Hop Failed", tostring(((arg2 ~= "") and arg2) or o))
			end
		end)
	end

	pcall(m)

	local function p(o)
		local P, list2, c, w = tostring(game.JobId or ""), {}, o == "Random", ((o == "Least Players") and "Asc") or "Desc"
		local Y, nextPageCursor = (c and 3) or 6

		for i = 1, Y, 1 do
			local j = bit32.bxor(89064137, 0)
			i = j
			o = string
			j = u32Trunc(i + 163763672)
			local format, gameRef, a = o.format, game, u32Trunc(Y)
			j = u32Trunc((2074417487 + j) + (u32Mul(2138141206, a) + u32Mul(2138141206, (bit32.bnot(a)))))
			local str4 = format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100", gameRef.PlaceId, w)
			local nextPageCursor2, v24 = nextPageCursor and (nextPageCursor ~= "")

			if nextPageCursor2 then
				gameRef = nil
				gameRef, str4 = HttpService, str4 .. ("&cursor=" .. HttpService:UrlEncode(nextPageCursor))
			else
			end

			gameRef, format = pcall(function()
				local HttpService2, str42 = HttpService, str4
				local response = table.pack(game:HttpGet(str42))
				return HttpService2:JSONDecode(table.unpack(response, 1, response.n))
			end)

			if not gameRef or (type(format) ~= "table") then
				return list2, false
			end

			for i2, v25 in ipairs(format.data or {}) do
				i2, a, nextPageCursor2 = tostring(v25.id or ""), tonumber(v25.playing) or (1 / 0), tonumber(v25.maxPlayers) or 0

				if ((i2 ~= "") and (i2 ~= P)) and (a < nextPageCursor2) then
					list2[#list2 + 1] = {Id = i2, Playing = a, Room = nextPageCursor2 - a}
				end
			end

			if (#list2 > 0) and not c then
				break
			end
			nextPageCursor = format.nextPageCursor
			if not nextPageCursor or (nextPageCursor == "") then
				break
			end
		end

		return list2, true
	end

	local function serverHop(o)
		local P, tbl22, clock = bit32.bxor(198531718, 0), tbl2
		clock, P = os.clock, bit32.bxor(P, 250118525)
		tbl22.HopActiveUntil = clock() + 45
		local w
		P = bit32.bxor(P, 96601767)
		tbl22 = (F and (W == o)) and ((os.clock() - _) < N)

		if tbl22 then
			w = F
		else
			clock = nil
			w, clock = p(o)
			if not clock then
				return "fetch"
			end
			F, W = w, o
			_ = os.clock()
		end

		local tbl23, flag2, hopAvoid = tbl2, type(tbl2.HopAvoid) == "table"

		if flag2 then
			tbl22 = tbl2
			hopAvoid = tbl22.HopAvoid
		else
			hopAvoid = flag2
		end

		local flag22 = hopAvoid or {}

		local function fn31(arg, Y)
			local list2 = {}

			for _, v24 in ipairs(w) do
				if (not y[v24.Id] and (v24.Room >= arg)) and not (Y and flag22[v24.Id]) then
					list2[#list2 + 1] = v24
				end
			end

			return list2
		end

		hopAvoid = fn31(2, true)
		hopAvoid = if #(if #(if #hopAvoid == 0 then fn31(1, true) else hopAvoid) == 0 then fn31(2, false) else if #hopAvoid == 0 then fn31(1, true) else hopAvoid) == 0 then fn31(1, false) else if #(if #hopAvoid == 0 then fn31(1, true) else hopAvoid) == 0 then fn31(2, false) else if #hopAvoid == 0 then fn31(1, true) else hopAvoid

		if (#hopAvoid == 0) and (next(y) ~= nil) then
			table.clear(y)
			hopAvoid = (fn31(1))
		else
		end

		fn31 = #hopAvoid
		clock = fn31 == 0

		if clock then
			b(nil)
			F = nil
			return "empty"
		end

		local id2

		if o == "Random" then
			id2 = hopAvoid[math.random(1, #hopAvoid)].Id
		else
			local v24, v25 = bit32.bxor(107711254, 0), table
			tbl22, clock = v24, u32Trunc(fn31)
			v24 = u32Trunc((bit32.bxor(tbl22, 234444753) + 4194906337) + (u32Mul(4194906337, clock) + u32Mul(4194906337, (bit32.bnot(clock)))))
			flag2 = v25.sort
			v24 = bit32.bxor(v24, 79316318)

			flag2(hopAvoid, function(arg, arg2)
				if o == "Least Players" then
					return arg.Playing < arg2.Playing
				end
				return arg.Playing > arg2.Playing
			end)

			id2 = hopAvoid[1].Id
		end

		O, id = false, id2
		f = os.clock() + n12
		pcall(fn30)

		flag2 = pcall(function()
			local v24
			local TeleportService2, v25 = TeleportService
			TeleportService2:TeleportToPlaceInstance(game.PlaceId, id2, localPlayer)
		end)

		if not flag2 then
			b(id2)
			return "failed"
		end
		flag2 = os.clock() + n12

		while os.clock() < flag2 do
			hopAvoid = O
			if hopAvoid then
				return "denied"
			end
			task.wait(0.25)
		end

		return "waiting"
	end

	m = tbl2
	m.ServerHop = serverHop
	m = v20

	m:CreateDropdown({Name = "Server Hop Mode", Options = {"Most Players", "Random", "Least Players"}, Default = "Least Players", Callback = function(L)
		str3 = tostring(L or "Least Players")
	end})

	m = v20

	m:CreateButton({Name = "Server Hop", ButtonText = "Hop", Callback = function()
		local L = bit32.bxor(147330473, 0)
		local Z = L
		l += 1
		L = bit32.bxor(Z, 321575231)
		local v24, K = l
		K, L = task, u32Trunc((u32Mul(1214418293, L) + 321646421) + (u32Mul(1866130710, (bit32.bor(L, 487210593))) + u32Mul(1214418294, (bit32.bxor(L, 487210593)))))

		K.spawn(function()
			t = true
			local I = 0

			while true do
				local tbl22 = l
				if not (v24 == tbl22) then
					break
				end
				I += 1
				tbl22 = tbl2
				tbl22.HopActiveUntil = os.clock() + 45
				tbl22 = serverHop(str3)
				local flag2 = (tbl22 == "waiting") or (v24 ~= l)
				if flag2 then
					break
				end
				flag2 = tbl22 == "empty"

				if flag2 then
					F = nil
					table.clear(y)
				end

				flag2 = (I % 10) == 0

				if flag2 then
					local v25
					fn9("Server Hop", string.format("Every server was full so far, %d tries.", I))
				end

				task.wait(((tbl22 == "fetch") and g) or n13)
			end

			local flag2 = v24 == l

			if flag2 then
				t = false
			end
		end)
	end})
end

fn28()

local function fn29()
	local B, x, G, g, f = bit32.bxor(363763856, 0), 8, 0, ""
	B = u32Trunc((u32Mul(1678698172, B) + 3774890108) + (u32Mul(937570952, (bit32.bor(B, 258432145))) + u32Mul(1678698173, (bit32.bxor(B, 258432145)))))
	local T
	B = bit32.bxor(B, 52361646)

	T = function()
		local now, y = os.clock(), G
		return now < y
	end

	local function fn30(y)
		G = (y and (os.clock() + x)) or 0
	end

	local function fn31(arg)
		local match = tostring(arg or ""):match("^%s*(.-)%s*$")
		return match:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or match
	end

	local function fn32()
		local y = g

		if f then
			local t = bit32.bxor(161296243, 0)
			local nameList
			nameList, t = pcall, u32Trunc(t + 162055202)

			local v21, O = nameList(function()
				local controller = f._controller
				return (controller and controller.GetValue) and controller.GetValue()
			end)

			if (v21 and (type(O) == "string")) and (O ~= "") then
				y = O
			else
				nameList = {"Get", "GetValue", "GetText"}

				for i, v22 in ipairs(nameList) do
					local l = bit32.bxor(383709334, 0)
					i = l
					local F
					F, l = pcall, u32Trunc(i + 17979432)

					local v23, W = F(function()
						return f[v22]
					end)

					if v23 and (type(W) == "function") then
						i, F = pcall(W, f)
						if (i and (type(F) == "string")) and (F ~= "") then
							y = F
							break
						end
					end
				end
			end
		else
		end

		local t = fn31(y)

		if t == "" then
			local ok, l = pcall(function()
				local O = (getclipboard or readclipboard) or getrbxclipboard
				return ((type(O) == "function") and O()) or nil
			end)

			t = if ok and (type(l) == "string") then fn31(l) else t
		else
		end

		return t
	end

	local function y(t)
		local l = bit32.bxor(166024301, 0)
		local O = l
		local F
		l, F = u32Trunc(O + 291500646), not f
		l = u32Trunc(l - 98476869)
		if F then
			return
		end

		pcall(function()
			local controller = f._controller

			if controller and controller.SetValue then
				controller.SetValue(t, false)
			end
		end)

		g = fn31(t)
	end

	local function t(l)
		local O = bit32.bxor(92664084, 0)
		local F = O
		fn30(true)
		local W, _
		W, _, O = pcall, AutoLoadBeforeTeleport, u32Trunc((u32Mul(2680712560, F) + 2501527536) + (u32Mul(1614254737, (bit32.bor(F, 391619225))) + u32Mul(1614254735, (bit32.band(F, 391619225)))))
		W(_)
		O = bit32.bxor(O, 395787240)

		W = not pcall(function()
			local flag2, v21, v22 = game.JobId ~= ""

			if flag2 then
				local TeleportService2 = TeleportService
				TeleportService2:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
			else
				local TeleportService2 = TeleportService
				TeleportService2:Teleport(game.PlaceId, localPlayer)
			end
		end)

		if W then
			fn30(false)
			local v21
			fn9(l, "Roblox could not rejoin the server.")
		end
	end

	local function l()
		local O = bit32.bxor(363397073, 0)
		local F = O
		local W
		local TeleportService2 = TeleportService
		O = u32Trunc((u32Mul(53257575, F) + 2920053036) + (u32Mul(4241709722, (bit32.bor(F, 401323508))) + u32Mul(4241709720, (bit32.band(F, 401323508)))))
		O = bit32.bxor(O, 440015108)

		local function fn33(_, arg, arg2)
			if not T() then
				return
			end
			fn30(false)
			local N
			fn9("Teleport Failed", tostring(((arg2 ~= "") and arg2) or arg))
		end

		TeleportService2.TeleportInitFailed:Connect(fn33)
	end

	pcall(l)
	local O
	l = v20

	f = l:CreateInput({Name = "Job ID", Placeholder = "Paste a server Job ID...", Default = "", MaxLength = 100, Callback = function(arg)
		g = fn31(arg)
	end})

	if f then
		f._configIgnored = true

		if f.State and not f.State._registered then
			f.State._configIgnored = true
		end
	end

	l = v20

	l:CreateButton({Name = "Join Job ID", ButtonText = "Join", Callback = function()
		local v21 = bit32.bxor(36465658, 0)
		local v212 = v21
		local flag2 = T()
		local v22
		if flag2 then
			fn9("Join Job ID Failed", "A teleport is already running, try again shortly.")
			return
		end
		local v23 = fn32()
		flag2 = v23 == ""
		v21 = u32Trunc((u32Mul(1383870147, v212) + 671008602) + (u32Mul(1527227002, (bit32.bor(v212, 222673310))) + u32Mul(1383870148, (bit32.bxor(v212, 222673310)))))
		if flag2 then
			fn9("Join Job ID Failed", "Paste a valid Job ID first.")
			return
		end
		fn30(true)
		flag2, v212 = nil
		flag2, v212, v21 = pcall, AutoLoadBeforeTeleport, bit32.bxor(v21, 512635796)
		flag2(v212)

		v212 = not pcall(function()
			local v24
			local TeleportService2, v25 = TeleportService
			TeleportService2:TeleportToPlaceInstance(game.PlaceId, v23, localPlayer)
		end)

		if v212 then
			fn30(false)
			fn9("Join Job ID Failed", "Roblox could not join that server.")
		end
	end})

	l = v20

	l:CreateButton({Name = "Copy Current Job ID", ButtonText = "Copy", Callback = function()
		local str3 = tostring(game.JobId or "")
		y(str3)
		local v21 = setclipboard or toclipboard
		local ok, v22 = ((type(v21) == "function") and pcall(v21, str3)) or false
		fn9((ok and "Job ID Copied") or "Job ID Shown", str3)
	end})

	l = v20

	l:CreateButton({Name = "Rejoin Server", ButtonText = "Rejoin", Callback = function()
		local v21 = T()

		if v21 then
			local v22
			fn9("Rejoin Failed", "A teleport is already running, try again shortly.")
			return
		end

		t("Rejoin Failed")
	end})

	local GuiService, tbl5 = game:GetService("GuiService"), {Option = nil, Fired = false, TeleportingAt = 0}

	local function fn33()
		local v21
		local CoreGui2 = CoreGui
		local robloxPromptGui = CoreGui2:FindFirstChild("RobloxPromptGui")
		CoreGui2 = robloxPromptGui and (robloxPromptGui:FindFirstChild("promptOverlay"))
		return (CoreGui2 ~= nil) and (CoreGui2:FindFirstChild("ErrorPrompt") ~= nil)
	end

	local function fn34()
		local onTeleport = bit32.bxor(240111079, 0)
		local onTeleport2 = onTeleport
		local v21
		local localPlayer2 = localPlayer
		onTeleport = bit32.bxor(onTeleport2, 121936757)
		onTeleport2 = nil
		onTeleport2, onTeleport = localPlayer2.OnTeleport, u32Trunc((u32Mul(446413299, onTeleport) + 1914265514) + (u32Mul(3848553998, (bit32.bor(onTeleport, 195146286))) + u32Mul(3848553996, (bit32.band(onTeleport, 195146286)))))

		local connection = onTeleport2:Connect(function(arg)
			if arg == Enum.TeleportState.Failed then
				tbl5.TeleportingAt = 0
			else
				tbl5.TeleportingAt = os.clock()
			end
		end)

		local v22

		fn6(function()
			local v23 = bit32.bxor(117417624, 0)
			local v24
			v24, v23 = pcall, u32Trunc(v23 + 438723356)

			v24(function()
				connection:Disconnect()
			end)
		end)
	end

	pcall(fn34)
	l = v20
	tbl5.Option = l:CreateToggle({Name = "Auto Rejoin When Disconnect", Default = true})

	local function q()
		local now = os.clock()
		local v21
		local tbl22, n12 = tbl2, tonumber(tbl2.HopActiveUntil) or 0
		if now < n12 then
			return true
		end
		now = tbl2
		n12 = now.HopHandles
		now = type(n12) == "table"

		if now then
			local v22 = pairs

			for k, v23 in v22(n12) do
				local ok, result = pcall(v23)
				k, v23 = ok and (result ~= nil)

				if k then
					ok = tbl2
					v23 = ok.Toggle(result, false)
				else
					v23 = k
				end

				if v23 then
					return true
				end
			end
		end

		return false
	end

	local function fn35(arg)
		local v21 = bit32.bxor(345713814, 0)
		local v212 = v21
		if q() then
			return
		end
		local fired, n12, fired2 = tbl5.Fired, u32Mul(466996281, v212) + 425834795
		v21, fired2 = u32Trunc(n12 + (u32Mul(3827971016, (bit32.bor(v212, 205256835))) + u32Mul(3827971014, (bit32.band(v212, 205256835))))), fired or (tbl5.Option == nil)
		n12 = nil

		if fired2 then
			n12 = fired2
		else
			local W
			fired = tbl2
			n12 = not fired.Toggle(tbl5.Option, false)
		end

		if n12 or T() then
			return
		end

		if (tbl5.TeleportingAt > 0) and ((os.clock() - tbl5.TeleportingAt) < 60) then
			return
		end
		fired2, v212 = nil
		fired2, v212, v21 = string.lower, tostring, bit32.bxor(v21, 387850268)
		n12 = fired2(v212(arg or ""))
		if (n12 == "") or string.find(n12, "teleport", 1, true) then
			return
		end
		local errorCode

		pcall(function()
			errorCode = GuiService:GetErrorCode()
		end)

		arg = ((errorCode == Enum.ConnectionError.DisconnectDuplicatePlayer) or string.find(n12, "banned", 1, true)) or string.find(n12, "same account", 1, true)
		if arg then
			return
		end
		tbl5.Fired = true
		local placeId = game.PlaceId
		local str3 = tostring(game.JobId or "")
		local flag2 = ((string.find(n12, "shut", 1, true) ~= nil) or (string.find(n12, "no longer", 1, true) ~= nil)) or (string.find(n12, "closed", 1, true) ~= nil)
		pcall(AutoLoadBeforeTeleport)
		local v22
		fn9("Auto Rejoin", (flag2 and "Server closed, joining another one.") or "Disconnected, rejoining now.")

		task.spawn(function()
			local Z = 0

			while true do
				local v23 = bit32.bxor(19774778, 0)
				local v232 = v23
				local v24 = q
				v23 = bit32.bxor(v232, 473944218)
				if v24() then
					tbl5.Fired = false
					break
				end
				Z += 1
				local flag3, v25 = (not flag2 and (str3 ~= "")) and (Z <= 2)
				v25, v23 = pcall, u32Trunc((u32Mul(4030474429, v23) + 3873666527) + (u32Mul(264492868, (bit32.bor(v23, 390219979))) + u32Mul(264492866, (bit32.band(v23, 390219979)))))

				v25(function()
					local v26, v27

					if flag3 then
						local TeleportService2, localPlayer2 = TeleportService, localPlayer
						TeleportService2:TeleportToPlaceInstance(placeId, str3, localPlayer2)
					else
						local TeleportService2, localPlayer2 = TeleportService, localPlayer
						TeleportService2:Teleport(placeId, localPlayer2)
					end
				end)

				task.wait((flag3 and 4) or 5)
			end
		end)
	end

	local function L()
		local A = bit32.bxor(220574581, 0)
		local errorMessageChanged = A
		A = u32Trunc(errorMessageChanged + 374382390)
		errorMessageChanged = nil
		errorMessageChanged, A = GuiService.ErrorMessageChanged, u32Trunc(A + 107659010)

		local connection = errorMessageChanged:Connect(function(Z)
			task.wait(0.3)

			if fn33() then
				fn35(Z)
			end
		end)

		local Z

		fn6(function()
			local v21 = bit32.bxor(350802268, 0)
			local v22
			v22, v21 = pcall, u32Trunc((u32Mul(385378206, v21) + 3423913552) + (u32Mul(3524210884, (bit32.bor(v21, 499067992))) + u32Mul(385378207, (bit32.bxor(v21, 499067992)))))

			v22(function()
				connection:Disconnect()
			end)
		end)
	end

	pcall(L)

	task.spawn(function()
		local robloxPromptGui = bit32.bxor(76544115, 0)
		local robloxPromptGui2 = robloxPromptGui
		local Z
		local CoreGui2 = CoreGui
		robloxPromptGui = bit32.bxor(robloxPromptGui2, 278701570)
		robloxPromptGui2 = CoreGui2:WaitForChild("RobloxPromptGui", 30)
		CoreGui2 = robloxPromptGui2 and (robloxPromptGui2:WaitForChild("promptOverlay", 30))
		robloxPromptGui2 = not CoreGui2
		robloxPromptGui = u32Trunc((u32Mul(739934043, robloxPromptGui) + 1335209290) + (u32Mul(2815099210, (bit32.bor(robloxPromptGui, 237749246))) + u32Mul(739934044, (bit32.bxor(robloxPromptGui, 237749246)))))
		if robloxPromptGui2 then
			return
		end

		local connection = CoreGui2.ChildAdded:Connect(function(child)
			if child.Name ~= "ErrorPrompt" then
				return
			end
			task.wait(0.2)
			local str3, v21 = "", ipairs
			local descendants = table.pack(child:GetDescendants())

			for k, v22 in v21(table.unpack(descendants, 1, descendants.n)) do
				k = v22:IsA("TextLabel") and (v22.Name == "ErrorMessage")

				if k then
					str3 = v22.Text
				else
				end
			end

			descendants = str3 == ""

			if descendants then
				local h = bit32.bxor(411087478, 0)
				v21 = h
				child = nil
				child, h = pcall, u32Trunc(v21 + 37811947)

				child(function()
					str3 = GuiService:GetErrorMessage()
				end)
			end

			fn35(((str3 ~= "") and str3) or "disconnected")
		end)

		local v21

		fn6(function()
			local v22 = bit32.bxor(156417363, 0)
			local A
			A, v22 = pcall, u32Trunc(v22 + 978819)

			A(function()
				connection:Disconnect()
			end)
		end)
	end)
end

local flag2 = bit32.bxor(n102, 383148409) == 5732013
fn29()

local function fn30()
	local B, kMap = bit32.bxor(271616360, 0), {}
	B = u32Trunc((u32Mul(242581773, B) + 4093352422) + (u32Mul(4052385524, (bit32.bor(B, 264375294))) + u32Mul(4052385522, (bit32.band(B, 264375294)))))

	local function K(V)
		local x = kMap[V]
		if type(x) ~= "string" then
			return ""
		end
		return x
	end

	local V
	B = bit32.bxor(B, 234591647)

	V = function(arg, text)
		arg.AutoLocalize = false
		arg.Text = text
	end

	local n12, x = 0

	local function G()
		local g = x
		if not g then
			return
		end
		g = x

		for _, v21 in ipairs(g) do
			V(v21[1], K(v21[2]))
		end
	end

	local g

	do
		local v21 = bit32.bxor(304330086, 0)
		local f
		local UserInputService2, inputBegan = UserInputService
		inputBegan, v21 = UserInputService2.InputBegan, u32Trunc(v21 + 519325705)

		local connection = inputBegan:Connect(function(arg)
			local userInputType = arg.UserInputType
			arg = (((userInputType == Enum.UserInputType.MouseButton1) or (userInputType == Enum.UserInputType.Touch)) or (userInputType == Enum.UserInputType.Keyboard)) or (userInputType == Enum.UserInputType.Gamepad1)

			if arg then
				n12 = os.clock()
			end
		end)

		fn6(function()
			local v22 = bit32.bxor(17590243, 0)
			local v23
			v23, v22 = pcall, u32Trunc(v22 + 124987664)

			v23(function()
				connection:Disconnect()
			end)
		end)
	end

	local function L()
		local n13 = os.clock() - n12
		return n13 <= 1
	end

	local screenGui, uiScale
	local connections, T, y = {}

	local function t()
		local uiScale2 = uiScale
		if not uiScale2 then
			return
		end
		uiScale2 = workspace.CurrentCamera
		local viewportSize = (uiScale2 and uiScale2.ViewportSize) or Vector2.new(1280, 720)
		viewportSize = if viewportSize.X < 1 then Vector2.new(1280, 720) else viewportSize
		uiScale2 = uiScale
		uiScale2.Scale = math.clamp(math.min(viewportSize.X / 1280, viewportSize.Y / 720), 0.72, 1.35)
	end

	local function l()
		local screenGui2 = screenGui

		if screenGui2 then
			screenGui.Enabled = false
		end
	end

	local font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	local colorSequence = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.486, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(0.519, Color3.fromRGB(221, 221, 221)), ColorSequenceKeypoint.new(1, Color3.fromRGB(236, 236, 236))})
	local colorSequence2 = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 36, 84)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 31, 54))})
	local colorSequence3 = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 193, 194)), ColorSequenceKeypoint.new(0.057, Color3.fromRGB(255, 132, 123)), ColorSequenceKeypoint.new(1, Color3.fromRGB(239, 28, 28))})
	local colorSequence4 = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 193, 194)), ColorSequenceKeypoint.new(0.015, Color3.fromRGB(255, 132, 123)), ColorSequenceKeypoint.new(1, Color3.fromRGB(239, 28, 28))})
	local colorSequence5 = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(92, 94, 106)), ColorSequenceKeypoint.new(0.057, Color3.fromRGB(70, 71, 82)), ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 39, 46))})

	local function createUIStroke(parent, applyStrokeMode, thickness, color)
		local uiStroke = Instance.new("UIStroke")
		local w
		uiStroke.Name = fn5()
		uiStroke.ApplyStrokeMode = applyStrokeMode
		uiStroke.Color = color or Color3.fromRGB(0, 0, 0)
		uiStroke.LineJoinMode = Enum.LineJoinMode.Round
		uiStroke.Thickness = thickness
		uiStroke.Transparency = 0
		uiStroke.Parent = parent
		return uiStroke
	end

	local function createUIGradient(parent, color, rotation)
		local uiGradient = Instance.new("UIGradient")
		local w
		uiGradient.Name = fn5()
		uiGradient.Color = color
		uiGradient.Rotation = rotation or 90
		uiGradient.Parent = parent
		return uiGradient
	end

	local function createUIStroke2(parent, textSize)
		parent.FontFace = font
		parent.TextColor3 = Color3.fromRGB(255, 255, 255)
		parent.TextStrokeTransparency = 1
		parent.TextSize = textSize
		parent.LineHeight = 1
		local uiStroke = Instance.new("UIStroke")
		local c
		uiStroke.Name = fn5()
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		uiStroke.Color = Color3.fromRGB(0, 0, 0)
		uiStroke.LineJoinMode = Enum.LineJoinMode.Round
		uiStroke.Thickness = math.max(1, textSize * 0.08)
		uiStroke.Transparency = 0
		uiStroke.Parent = parent
		return uiStroke
	end

	local function O(P, r)
		local c = createUIStroke2(P, r)
		createUIGradient(c, colorSequence2, 90)
		createUIGradient(P, colorSequence, 90)
		c.Thickness = math.max(1, r * 0.065)
	end

	local function F()
		local uiElement = bit32.bxor(351158800, 0)
		local uiElement2 = uiElement
		local screenGui2 = screenGui
		if screenGui2 then
			return
		end
		screenGui = Instance.new("ScreenGui")
		local uiElement3, w = screenGui
		uiElement3.Name = fn5()
		screenGui.DisplayOrder = 2000000000
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		uiElement3 = screenGui
		uiElement3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.Enabled = false
		screenGui2 = Instance.new("TextButton")
		screenGui2.Name = fn5()
		screenGui2.AutoButtonColor = false
		screenGui2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		screenGui2.BackgroundTransparency = 0.45
		screenGui2.BorderSizePixel = 0
		screenGui2.Modal = true
		uiElement = bit32.bxor(uiElement2, 172383909)
		screenGui2.Size = UDim2.fromScale(1, 1)
		screenGui2.Text = ""
		screenGui2.ZIndex = 1
		screenGui2.Parent = screenGui
		local frame = Instance.new("Frame")
		frame.Name = fn5()
		frame.Active = true
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BackgroundTransparency = 0.18
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.Size = UDim2.fromOffset(430, 316)
		frame.ZIndex = 10
		frame.Parent = screenGui
		uiScale = Instance.new("UIScale")
		uiElement2 = uiScale
		uiElement2.Name = fn5()
		uiScale.Parent = frame
		createUIStroke(frame, Enum.ApplyStrokeMode.Border, 2)
		uiElement3 = Instance.new("Frame")
		uiElement3.Name = fn5()
		uiElement3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		uiElement3.BorderSizePixel = 0
		uiElement3.Position = UDim2.fromOffset(22, 22)
		uiElement3.Size = UDim2.fromOffset(5, 26)
		uiElement3.ZIndex = 12
		uiElement3.Parent = frame
		createUIGradient(uiElement3, colorSequence3, 90)
		createUIStroke(uiElement3, Enum.ApplyStrokeMode.Border, 1.4)
		uiElement3 = Instance.new("TextLabel")
		uiElement3.Name = fn5()
		uiElement3.BackgroundTransparency = 1
		uiElement3.Position = UDim2.fromOffset(38, 20)
		uiElement3.Size = UDim2.fromOffset(370, 30)
		uiElement3.TextXAlignment = Enum.TextXAlignment.Left
		uiElement3.TextYAlignment = Enum.TextYAlignment.Center
		uiElement3.ZIndex = 12
		uiElement3.Parent = frame
		O(uiElement3, 21)
		V(uiElement3, K("Title"))
		uiElement2 = Instance.new("Frame")
		uiElement2.Name = fn5()
		uiElement2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		uiElement2.BackgroundTransparency = 0.82
		uiElement2.BorderSizePixel = 0
		uiElement2.Position = UDim2.fromOffset(22, 58)
		uiElement2.Size = UDim2.fromOffset(386, 1)
		uiElement2.ZIndex = 12
		uiElement2.Parent = frame
		uiElement2 = Instance.new("TextLabel")
		uiElement2.Name = fn5()
		uiElement = bit32.bxor(uiElement, 248625426)
		uiElement2.BackgroundTransparency = 1
		uiElement2.Position = UDim2.fromOffset(22, 68)
		screenGui2 = nil
		screenGui2, uiElement = UDim2.fromOffset, bit32.bxor(uiElement, 291954114)
		uiElement2.Size = screenGui2(386, 24)
		uiElement2.TextXAlignment = Enum.TextXAlignment.Left
		uiElement2.TextYAlignment = Enum.TextYAlignment.Center
		uiElement2.ZIndex = 12
		uiElement2.Parent = frame
		createUIStroke2(uiElement2, 17)
		uiElement2.TextColor3 = Color3.fromRGB(255, 72, 72)
		createUIGradient(uiElement2, ColorSequence.new(Color3.fromRGB(255, 132, 123), Color3.fromRGB(239, 28, 28)), 90)
		V(uiElement2, K("Warn"))
		local textLabel, fn52, i, uiElement4 = Instance.new("TextLabel"), fn5, u32Mul(772847437, uiElement) + 2977093471, bit32.bor(uiElement, 188148571)
		local j, uiElement5 = u32Mul(2749272422, uiElement4), bit32.bxor(uiElement, 188148571)
		uiElement4 = i + (j + u32Mul(772847438, uiElement5))
		uiElement = u32Trunc(uiElement4)
		textLabel.Name = fn52()
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.fromOffset(22, 98)
		textLabel.Size = UDim2.fromOffset(386, 74)
		textLabel.TextWrapped = true
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Top
		textLabel.ZIndex = 12
		textLabel.Parent = frame
		createUIStroke2(textLabel, 15)
		textLabel.LineHeight = 1.14
		textLabel.TextTransparency = 0.12
		V(textLabel, K("Body"))
		i = Instance.new("TextLabel")
		i.Name = fn5()
		i.BackgroundTransparency = 1
		i.Position = UDim2.fromOffset(22, 176)
		i.Size = UDim2.fromOffset(386, 46)
		i.TextWrapped = true
		i.TextXAlignment = Enum.TextXAlignment.Left
		i.TextYAlignment = Enum.TextYAlignment.Top
		i.ZIndex = 12
		i.Parent = frame
		createUIStroke2(i, 14)
		i.LineHeight = 1.12
		i.TextColor3 = Color3.fromRGB(255, 176, 120)
		V(i, K("Tip"))

		local function W(parent, parent2, a)
			local textButton = Instance.new("TextButton")
			textButton.Name = fn5()
			textButton.Active = true
			textButton.AutoButtonColor = false
			textButton.BackgroundTransparency = 1
			textButton.BorderSizePixel = 0
			textButton.Position = UDim2.fromOffset(parent, 244)
			textButton.Size = UDim2.fromOffset(parent2, 46)
			textButton.Text = ""
			textButton.ZIndex = 14
			textButton.Parent = frame
			parent = Instance.new("Frame")
			parent.Name = fn5()
			parent.AnchorPoint = Vector2.new(0.5, 0.5)
			parent.BackgroundColor3 = (a and Color3.fromRGB(175, 0, 0)) or Color3.fromRGB(24, 25, 30)
			parent.BorderSizePixel = 0
			parent.Position = UDim2.fromScale(0.5, 0.5)
			parent.Size = UDim2.fromScale(1, 0.92)
			parent.ZIndex = 12
			parent.Parent = textButton
			createUIStroke(parent, Enum.ApplyStrokeMode.Border, 1.6)
			parent2 = Instance.new("Frame")
			parent2.Name = fn5()
			parent2.AnchorPoint = Vector2.new(0.5, 0)
			parent2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			parent2.BorderSizePixel = 0
			parent2.Position = UDim2.fromScale(0.5, 0)
			parent2.Size = UDim2.fromScale(1, 0.9)
			parent2.ZIndex = 12
			parent2.Parent = parent
			createUIGradient(parent2, (a and colorSequence3) or colorSequence5, 90)
			parent = Instance.new("Frame")
			parent.Name = fn5()
			parent.AnchorPoint = Vector2.new(0.5, 0.5)
			parent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			parent.BorderSizePixel = 0
			parent.Position = UDim2.fromScale(0.5, 0.5)
			parent.Size = UDim2.fromScale(0.965, 0.88)
			parent.ZIndex = 13
			parent.Parent = parent2
			createUIGradient(parent, (a and colorSequence4) or colorSequence5, 90)
			parent2 = Instance.new("TextLabel")
			parent2.Name = fn5()
			parent2.AnchorPoint = Vector2.new(0.5, 0.5)
			parent2.BackgroundTransparency = 1
			parent2.Position = UDim2.fromScale(0.5, 0.5)
			parent2.Size = UDim2.fromScale(0.9, 0.6)
			parent2.TextWrapped = true
			parent2.ZIndex = 15
			parent2.Parent = textButton
			O(parent2, 17)
			return textButton, parent2
		end

		uiElement4, screenGui2 = W(22, 184, false)
		fn52, uiElement5 = W(224, 184, true)
		V(screenGui2, K("Cancel"))
		V(uiElement5, K("Accept"))
		x = {{uiElement3, "Title"}, {uiElement2, "Warn"}, {textLabel, "Body"}, {i, "Tip"}, {screenGui2, "Cancel"}, {uiElement5, "Accept"}}
		G()

		connections[#connections + 1] = uiElement4.MouseButton1Click:Connect(function()
			local Z = y

			if Z then
				y()
			end
		end)

		uiElement5, uiElement3 = #connections + 1, fn52.MouseButton1Click

		local function Z()
			local v21 = T

			if v21 then
				T()
			end
		end

		connections[uiElement5] = uiElement3:Connect(Z)
		screenGui2 = workspace.CurrentCamera

		if screenGui2 then
			connections[#connections + 1] = screenGui2:GetPropertyChangedSignal("ViewportSize"):Connect(t)
		end

		t()
		local v21
		screenGui2 = v9
		screenGui.Parent = screenGui2
	end

	local function Z()
		F()
		t()
		local screenGui2 = screenGui

		if screenGui2 then
			screenGui.Enabled = true
		end
	end

	fn6(function()
		for i, connection in ipairs(connections) do
			local v21 = bit32.bxor(17299987, 0)
			i = v21
			local v22
			v22, v21 = pcall, u32Trunc((u32Mul(725667057, i) + 1609749439) + (u32Mul(2843633182, (bit32.bor(i, 14576559))) + u32Mul(725667058, (bit32.bxor(i, 14576559)))))

			v22(function()
				connection:Disconnect()
			end)
		end

		table.clear(connections)
		local screenGui2 = screenGui

		if screenGui2 then
			local A = bit32.bxor(77892843, 0)
			local q
			q, A = pcall, bit32.bxor(A, 254522842)

			q(function()
				screenGui:Destroy()
			end)

			screenGui = nil
		end
	end)

	local tbl5 = {Manual = L, Hide = l, Show = function(arg, A, q)
		local v21 = bit32.bxor(174746301, 0)
		local v212 = v21
		local v22 = pairs
		v21 = u32Trunc(v212 + 464450654)

		for k, v23 in v22(arg) do
			kMap[k] = v23
		end

		v21 = u32Trunc(v21 - 389917866)
		G()

		function T()
			l()

			if A then
				A()
			end
		end

		function y()
			l()

			if q then
				q()
			end
		end

		Z()
		G()
	end}

	return tbl5
end

tbl2.HopPrompt = fn30()

local function fn31()
	local B = bit32.bxor(284787379, 0)
	local y
	local v42 = v4
	local tbl22 = v42:CreateTab({Name = "Auto Hop", SectionsExpanded = true})
	local t, eggList, O, F, W, n12 = tbl22:CreateSection({Name = "Egg Finder", Expanded = true}), {"Collect Then Hop", "Until An Egg Matches", "Wait For Target Egg"}, "ChilliLibrary/RAP_AutoHop.json", 1800, 120, 4
	local N = {Mode = eggList[1], Sync = true, MinRank = 0}
	B = bit32.bxor(B, 533485198)
	N.Wanted = {}
	N.HopDelay = 5
	N.Wait = 5
	N.LoadedAt = os.clock()
	N.Kind = "idle"
	N.Status = "Idle"
	N.HopStart = 0
	N.HopEnd = 0
	N.Survey = nil
	N.Generation = 0
	N.Visited = {}
	N.Handle = nil
	N.StopNote = nil
	N.View = nil
	N.WindowUntil = 0
	local b
	v42 = tbl3
	N.WaitRank = v42.RarityRank.Divine or 0
	B = u32Trunc((u32Mul(2909559185, B) + 4180039838) + (u32Mul(2770816222, (bit32.bor(109473726, B))) + u32Mul(2909559186, (bit32.bxor(B, 109473726)))))
	N.WaitEggs = {}
	local n13, n14, m, p = 420, 298.5, 120, 10

	local function getServerTimeNow()
		return workspace:GetServerTimeNow()
	end

	local function P()
		local r = getServerTimeNow() % n13
		return (r >= n14) and (r < (n14 + m))
	end

	local function fn32()
		local r = getServerTimeNow()
		local c = r % n13
		if c < n14 then
			return (r - c) + n14
		end
		return ((r - c) + n13) + n14
	end

	local function fn33()
		return (N.WindowUntil > getServerTimeNow()) and not P()
	end

	local v21
	v42 = tbl2
	v42.AutoHopTab = tbl22

	local function saveFile()
		local r = bit32.bxor(390010685, 0)
		local c = r
		local w = type(writefile)
		r = u32Trunc(c + 239093318)
		r = u32Trunc(r + 230558737)
		if w ~= "function" then
			return
		end

		local function saveFile2()
			if ((type(isfolder) == "function") and (type(makefolder) == "function")) and not isfolder("ChilliLibrary") then
				makefolder("ChilliLibrary")
			end

			local list2 = {}

			for k, v22 in pairs(N.Visited) do
				list2[#list2 + 1] = {k, v22}
			end

			local v22
			writefile(O, HttpService:JSONEncode({Visited = list2, WindowUntil = N.WindowUntil}))
		end

		pcall(saveFile2)
	end

	local function readJsonFile()
		if type(readfile) ~= "function" then
			return
		end

		if (type(isfile) == "function") and not isfile(O) then
			return
		end
		local c
		local HttpService2 = HttpService
		local data = HttpService2:JSONDecode(readfile(O))
		if type(data) ~= "table" then
			return
		end
		HttpService2 = os.time()

		for i, v22 in ipairs(((type(data.Visited) == "table") and data.Visited) or {}) do
			i = ((type(v22) == "table") and tonumber(v22[2])) or nil

			if (i and (type(v22[1]) == "string")) and ((HttpService2 - i) < F) then
				N.Visited[v22[1]] = i
			end
		end

		N.WindowUntil = tonumber(data.WindowUntil) or 0
	end

	pcall(readJsonFile)
	N.Visited[tostring(game.JobId)] = os.time()
	v42 = tbl2
	v42.HopAvoid = N.Visited

	local function q(status, kind)
		N.Status = status
		N.Kind = kind or N.Kind

		if type(N.View) == "function" then
			N.View()
		end
	end

	local fn34, v22

	fn34 = function()
		local tbl5, tbl42, c = {Count = 0, Best = nil}, tbl4, type(tbl4.EggMatches) == "function"

		if c then
			local tbl43, ok, w, best = tbl4, pcall(tbl4.EggMatches, N.MinRank, N.Wanted, N.MinWeight or 0)

			if ok then
				tbl5.Count = tonumber(w) or 0
				tbl5.Best = best
			end
		end

		return tbl5
	end

	local function fn35()
		local tbl32 = tbl3
		local w, Y = tbl32.BasketCount() > 0

		if w then
			Y = w
		else
			tbl32 = tbl4
			Y = tbl32.Target ~= nil
		end

		return Y
	end

	local function c()
		local w
		local localPlayer2 = localPlayer
		local basket, Y = localPlayer2:FindFirstChild("Basket"), ipairs
		localPlayer2 = (basket and basket:GetChildren()) or {}

		for k, v23 in Y(localPlayer2) do
			k = v23:GetAttribute("Egg")
			local flag3, flag4 = type(k) == "string"

			if flag3 then
				basket = tbl3
				flag4 = basket.EggRank(k) >= N.MinRank
			else
				flag4 = flag3
			end

			local flag32, attribute = flag4 and ((next(N.Wanted) == nil) or N.Wanted[k])

			if flag32 then
				k = tbl3
				attribute = k.EggHeavyEnough(v23:GetAttribute("Weight"), N.MinWeight or 0)
			else
				attribute = flag32
			end

			if attribute then
				return true
			end
		end

		return false
	end

	local function K()
		local w = fn32()

		if N.WindowUntil < w then
			N.WindowUntil = w
			saveFile()
		end
	end

	local function w()
		if N.WindowUntil ~= 0 then
			N.WindowUntil = 0
			saveFile()
		end
	end

	local function Y()
		local tbl42, i = tbl4, type(tbl4.EggMatches)
		if i ~= "function" then
			return 0, nil
		end
		local tbl43, ok, J, j = tbl4, pcall(tbl4.EggMatches, N.WaitRank, N.WaitEggs, 0)
		if ok then
			return tonumber(J) or 0, j
		end
		return 0, nil
	end

	local function i()
		local tbl23 = tbl2
		local tbl42, collect = tbl4, tbl23.Toggle(tbl4.Collect, false)
		return collect == true
	end

	local function J(j)
		return N.Mode == eggList[j]
	end

	local function j(d)
		local a, S = d == N.Generation

		if a then
			d = tbl2
			S = d.Toggle(N.Handle, false) == true
		else
			S = a
		end

		return S
	end

	local function d(a)
		q("Checking the server one last time", "hop")
		local S = fn34()
		N.Survey = S
		if (S.Count > 0) or fn35() then
			q("A matching egg showed up, hop cancelled", "found")
			return
		end
		N.Visited[tostring(game.JobId)] = os.time()
		saveFile()
		q("Joining a less crowded server", "joining")
		local str3, tbl23, flag3 = "missing", tbl2, type(tbl2.ServerHop) == "function"

		if flag3 then
			local tbl24, ok, u = tbl2, pcall(tbl2.ServerHop, "Least Players")
			str3 = (ok and tostring(u)) or "error"
		else
		end

		if not j(a) then
			return
		end
		q(if str3 == "waiting" then "Teleport is slow, trying another server" else if str3 == "empty" then "Every listed server is full, searching again" else if str3 == "fetch" then "Server list unavailable, waiting a moment" else if str3 == "denied" then "That server filled up on join, taking the next one" else "Hop did not land, trying again", "retry")
		task.wait(((str3 == "fetch") and (n12 + 1)) or 1.5)
	end

	local function fn36(arg)
		N.HopEnd = 0
		local now, hopEnd

		while j(arg) do
			local n15, u, z = 0.5
			local D, tbl32 = false, tbl3
			local H, R = not tbl32.Root()

			if H then
				R = H
			else
				tbl32 = tbl3
				R = not tbl32.Plot()
			end

			if R then
				u, z = "Waiting for the game to load", "scan"
			else
				tbl32 = fn34()
				N.Survey = tbl32
				H = tbl32.Best
				local best = (H and tostring(H.Name)) or "an egg"

				if ((J(3) and not P()) and not fn33()) and (Y() > 0) then
					K()
				end

				local flag3 = (os.clock() - N.LoadedAt) < 3

				if flag3 then
					u, z = "Scanning this server", "scan"
				else
					local v23 = fn35()

					if v23 then
						if c() and J(1) then
							K()
						end

						u, z, now = "Auto Collect is bringing eggs home, hop waits", "collect", nil
					else
						local flag4 = tbl32.Count > 0

						if flag4 then
							local v24 = i()

							if v24 then
								now = now or os.clock()
								local tbl42, n16 = tbl4, os.clock() - math.max(now, tbl4.LastPickupAt or 0)

								if n16 > W then
									D = true
								else
									u, z = ((tbl32.Count == 1) and ("Matching egg here (" .. (best .. "), collecting it first"))) or string.format("%d matching eggs here, collecting them first", tbl32.Count), "found"
								end
							else
								if J(1) or J(3) then
									u, z = "Matching egg here, turn on Auto Collect Eggs to take it", "found"
								else
									u, z = "Found " .. (best .. ", staying here"), "found"
								end
							end
						else
							if (J(1) or J(3)) and P() then
								u, z, now = "Night, hopping paused until the next day", "night", nil
							else
								if J(3) and not fn33() then
									u, z, now = "Waiting for a target egg to spawn in this server", "wait", nil
								else
									if (J(1) or J(3)) and ((fn32() - getServerTimeNow()) < p) then
										u, z, now = "Night is about to start, staying here", "night", nil
									else
										if J(1) and not fn33() then
											now = nil

											if i() then
												u, z = "Waiting for Auto Collect to bring home a matching egg", "wait"
											else
												u, z = "Turn on Auto Collect Eggs, hopping starts after it collects a matching egg", "wait"
											end
										else
											D, now = true, nil
										end
									end
								end
							end
						end
					end
				end
			end

			if u then
				N.HopEnd = 0
				q(u, z)
				hopEnd = nil
			else
				if D then
					if not hopEnd then
						hopEnd = math.max(os.clock() + 1.5, (N.LoadedAt + N.HopDelay) + N.Wait)
						N.HopStart = os.clock()
						N.HopEnd = hopEnd
					else
					end

					R = hopEnd - os.clock()

					if R > 0 then
						q(string.format("No matching egg here, hopping in %.1fs", R), "hop")
						n15 = math.min(0.25, R)
					else
						N.HopEnd = 0
						d(arg)
						n15, now, hopEnd = 0, nil, nil
					end
				else
				end
			end

			if n15 > 0 then
				task.wait(n15)
			end
		end
	end

	local function fn37()
		N.Generation = N.Generation + 1
		local generation = N.Generation
		q("Scanning this server", "scan")
		task.spawn(fn36, generation)
	end

	local v23

	local function options()
		local v24 = bit32.bxor(421579318, 0)
		local v242 = v24

		if type(t.CreateCanvas) ~= "function" then
			local v25 = t:CreateText({Name = "Hop Status", Text = "Idle"})

			function N.View()
				if v25 and (type(v25.Set) == "function") then
					pcall(v25.Set, v25, N.Status)
				end
			end

			return
		end

		local function colorizeText(_, arg)
			return string.format("<font color=\"%s\">%s</font>", _, arg)
		end

		v24 = u32Trunc(v242 + 96705936)

		local function fn38(_)
			return "<b>" .. (tostring(_) .. "</b>")
		end

		local function fn39(arg)
			return (string.gsub(tostring(arg), "[<>&]", {["<"] = "&lt;", [">"] = "&gt;", ["&"] = "&amp;"}))
		end

		local function fn40(arg, arg2)
			local ok, result = pcall(Font.new, arg, arg2, Enum.FontStyle.Normal)
			return (ok and result) or nil
		end

		local json = fn40("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
		local json2 = fn40("rbxassetid://12187365977", Enum.FontWeight.Bold) or fn40("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular)
		local o = colorizeText("#6B7288", "  " .. (utf8.char(8226) .. "  "))

		local function fn41(arg)
			if (typeof(arg) ~= "Instance") or not arg:IsDescendantOf(game) then
				return false
			end
			local parent = arg

			while parent do
				if parent:IsA("GuiObject") and not parent.Visible then
					return false
				end

				if parent:IsA("LayerCollector") then
					return parent.Enabled
				end
				parent = parent.Parent
			end

			return false
		end

		local function formatCompact(arg)
			local unitSuffixes = {"", "K", "M", "B", "T", "Qa", "Qi"}
			arg = tonumber(arg) or 0
			local n15 = 1

			while (arg >= 1000) and (n15 < #unitSuffixes) do
				arg, n15 = arg / 1000, n15 + 1
			end

			local str3 = ((n15 == 1) and tostring(math.floor(arg))) or string.format("%.1f", arg)
			return string.gsub(str3, "%.0$", "") .. unitSuffixes[n15]
		end

		local n15, n16, n17, height, n18, a, S, u, z, D, X, H = 2.6, 0.6, 3.3, 1.2, 2.6, 0.7, 0.3, 0.95, 0.0909, {idle = {Title = "IDLE", Color = "#9AA3B5"}, scan = {Title = "SCANNING", Color = "#7FD8FF"}, found = {Title = "EGG FOUND", Color = "#4DFF7A"}, collect = {Title = "AUTO COLLECT BUSY", Color = "#FFC24D"}, wait = {Title = "WAITING", Color = "#FF7AE0"}, night = {Title = "NIGHT", Color = "#9C8CFF"}, rare = {Title = "WAITING", Color = "#FF7AE0"}, steal = {Title = "AUTO STEAL BUSY", Color = "#FFC24D"}, hop = {Title = "HOPPING SOON", Color = "#FF9A3D"}, joining = {Title = "JOINING SERVER", Color = "#FF9A3D"}, retry = {Title = "RETRYING", Color = "#FF6B6B"}, boss = {Title = "BOSS FIGHT", Color = "#FF5C8A"}}, {Slot = {Text = "ON THE MAP", Color = "#4DFF7A"}, Dropped = {Text = "DROPPED", Color = "#FFC24D"}, Carried = {Text = "BEING CARRIED", Color = "#FF8A5C"}, Mine = {Text = "YOU CARRY", Color = "#7FD8FF"}}
		local options2, k, Q, M = {}, 0, 0, 0.06
		local C = -1
		local n19 = -1
		local e, s, n20, E, U, tbl5 = -1, false, 0, true, 0
		local n21, flag3, flag4 = 0, false, false

		local function fn42(arg)
			local v25 = bit32.bxor(378889257, 0)
			local v252 = v25
			local diffWrapped
			v25, diffWrapped = u32Trunc(v252 + 151530042), not arg or arg.DiffWrapped
			if diffWrapped then
				return arg
			end
			local set = arg.Set
			v25 = u32Trunc(v25 + 279515574)
			arg.DiffWrapped = true

			arg.Set = function(arg2)
				if type(arg2) ~= "table" then
					return set(arg2)
				end
				local spec, tbl6 = arg.Spec

				for k2, v26 in pairs(arg2) do
					if spec[k2] ~= v26 then
						tbl6 = tbl6 or {}
						tbl6[k2] = v26
					else
					end
				end

				if tbl6 then
					set(tbl6)
				end

				return arg
			end

			return arg
		end

		local function fn43(arg)
			local widthKey = tostring(Q) .. ("|" .. string.gsub(tostring(arg.Spec.Text or ""), "%d", "0"))
			if arg.WidthKey == widthKey then
				return arg.WidthUnits
			end
			local textLabel = arg.Get()
			local flag5 = (not textLabel or (Q <= 0)) or (textLabel.Text ~= tostring(arg.Spec.Text or ""))
			if flag5 then
				return nil
			end
			local size, textWrapped = textLabel.Size, textLabel.TextWrapped
			textLabel.TextWrapped = false
			textLabel.Size = UDim2.fromOffset(100000, math.max(1, size.Y.Offset))
			flag5 = textLabel.TextBounds.X
			textLabel.Size = size
			textLabel.TextWrapped = textWrapped
			if flag5 <= 0 then
				return nil
			end
			arg.WidthKey, arg.WidthUnits = widthKey, flag5 / Q
			return arg.WidthUnits
		end

		local function fn44()
			local survey = N.Survey
			local best = (survey and survey.Best) or nil
			local flag5, flag52 = not best

			if flag5 then
				flag52 = flag5
			else
				local tbl23 = tbl2
				flag52 = tbl23.Toggle(N.Handle, false) ~= true
			end

			if flag52 then
				tbl5, n21, n20 = nil, 0, 2
				return
			end
			flag52 = tbl3
			flag5 = flag52.EggData(best.Name)
			local name, tbl32 = (flag5 and tostring(flag5.Rarity)) or "Common", tbl3
			flag52 = tbl32.RarityColors[name] or Color3.fromRGB(255, 255, 255)
			tbl5 = {Info = {Name = tostring(best.Name), Rarity = name, Color = flag52, Hex = "#" .. string.upper(flag52:ToHex()), Icon = ((flag5 and flag5.Image) and tostring(flag5.Image)) or nil}, Mutation = best.Mutation, Area = (best.Distance and string.format("%d studs away", math.floor(best.Distance))) or "", State = "Slot", Value = best.Luck}
			n21, n20 = survey.Count, 2
		end

		local function fn45()
			if not options2.Card then
				return
			end
			local tbl23 = tbl2
			local flag5 = tbl23.Toggle(N.Handle, false) == true
			tbl23 = (flag5 and N.Kind) or "idle"
			local idle = D[tbl23] or D.idle
			local color, status, flag6, n22 = Color3.fromHex(idle.Color), (flag5 and N.Status) or "Turn on Auto Hop to start hunting", false, 0

			if (flag5 and (tbl23 == "hop")) and (N.HopEnd > N.HopStart) then
				local n23, n24 = N.HopEnd - N.HopStart, math.max(0, N.HopEnd - os.clock())
				n22 = math.clamp(1 - (n24 / n23), 0, 1)
				status, flag6 = string.format("No matching egg here, hopping in %.1fs", n24), true
			else
			end

			options2.Accent.Set({Background = idle.Color})
			options2.Title.Set({Text = idle.Title, Color = color})
			local v25
			local set, tbl6, Players2, Players3 = options2.Server.Set, {}, Players, Players
			tbl6.Text = colorizeText("#9AA3B5", "Players ") .. fn38(colorizeText("#FFFFFF", #Players:GetPlayers() .. ("/" .. tostring(Players.MaxPlayers))))
			set(tbl6)
			set, tbl6 = options2.Detail.Set, {}
			tbl6.Text = colorizeText("#E6ECF5", fn39(status))
			set(tbl6)
			options2.Bar.Set({Visible = flag6, Alpha = n22, FillColor = color})
			tbl6 = tbl5
			tbl23 = tbl6 ~= nil
			set = (flag6 ~= flag3) or (tbl23 ~= flag4)

			if set then
				flag3, flag4, n20 = flag6, tbl23, 2
			end

			options2.Divider.Set({Visible = tbl23})
			options2.Name.Set({Visible = tbl23})
			options2.Chip.Set({Visible = tbl23})
			options2.Info.Set({Visible = tbl23})
			if not tbl23 then
				options2.Icon.Set({Visible = false})
				return
			end
			tbl23, idle = tbl6.Info, X[tbl6.State] or X.Slot
			flag5, set = Color3.fromHex(idle.Color), tbl23.Icon
			set = if set and tonumber(set) then "rbxassetid://" .. tostring(set) else set
			options2.Icon.Set({Visible = set ~= nil, Image = set or "", StrokeColor = tbl23.Color})
			options2.Name.Set({Text = fn39(tbl23.Name), Color = tbl23.Color, Gradient = nil, GradientRotation = 0})
			options2.Chip.Set({StrokeColor = flag5})
			options2.ChipText.Set({Text = idle.Text, Color = flag5})
			flag5 = {fn38(colorizeText("#4DFF7A", "Luck " .. formatCompact(tbl6.Value))), fn38(colorizeText(tbl23.Hex, fn39(string.upper(tostring(tbl23.Rarity))))), colorizeText("#CDE7FF", fn39(tbl6.Area))}

			if (type(tbl6.Mutation) == "string") and (tbl6.Mutation ~= "") then
				flag5[#flag5 + 1] = fn38(colorizeText("#FFC24D", fn39(tbl6.Mutation)))
			end

			idle = n21 > 1

			if idle then
				flag5[#flag5 + 1] = colorizeText("#9FB8FF", n21 .. " matches")
			end

			set, color = options2.Info.Set, {}
			color.Text = table.concat(flag5, o)
			set(color)
		end

		local function V()
			local flag5 = not options2.Card or (k <= 0)
			if flag5 then
				return
			end
			s = false
			local n22, tbl23 = math.max(1, (k - a) - 0.5), fn43(options2.Server)

			if tbl23 then
				options2.ServerUnits = tbl23 + 0.1
			else
				s = true
			end

			local n23, set, tbl6 = math.min(options2.ServerUnits or 4, n22 * 0.45), options2.Title.Set, {X = a, Y = 0.3}
			tbl6.Width, tbl6.Height = math.max(1, (n22 - n23) - S), height
			set(tbl6)
			options2.Server.Set({X = (a + n22) - n23, Y = 0.3, Width = math.max(0.5, n23), Height = height})
			options2.Detail.Set({X = a, Y = 0.3 + height, Width = n22, Height = 1})
			set, flag5 = flag3

			if set then
				options2.Bar.Set({X = a, Y = n15 - 0.1, Width = n22, Height = 0.3})
				flag5 = n15 + n16
			else
				flag5 = n15
			end

			tbl23, n23 = flag4

			if tbl23 then
				set = fn43(options2.ChipText)

				if set then
					options2.ChipUnits = set + 0.9
				else
					s = true
				end

				tbl6 = (a + n18) + 0.5
				local _ = math.max(1, (k - tbl6) - 0.5)
				local n24, n25 = math.min(options2.ChipUnits or 4, _ * 0.5), flag5 + 0.3
				options2.Divider.Set({X = a, Y = flag5, Width = n22, Height = 0.06})
				options2.Icon.Set({X = a, Y = n25, Width = n18, Height = n18})
				local set2, tbl7 = options2.Name.Set, {X = tbl6, Y = n25}
				tbl7.Width, tbl7.Height = math.max(1, (_ - n24) - S), height
				set2(tbl7)
				options2.Chip.Set({X = (tbl6 + _) - n24, Y = n25 + ((height - u) / 2), Width = n24, Height = u})
				options2.ChipText.Set({X = 0, Y = 0, Width = n24, Height = u})
				options2.Info.Set({X = tbl6, Y = n25 + height, Width = _, Height = 1})
				n23 = flag5 + n17
			else
				n23 = flag5
			end

			options2.Card.Set({X = 0, Y = 0, Width = k, Height = n23})
			options2.Accent.Set({X = 0, Y = 0, Width = 0.22, Height = n23})
			tbl6 = math.abs(n23 - e) > 0.01

			if tbl6 then
				e = n23
				H:SetContentLines(n23)
			end
		end

		local function fn46(arg)
			local v25 = bit32.bxor(339942210, 0)
			local v252 = v25
			H = arg
			v25 = bit32.bxor(v252, 107976459)
			options2.Card = arg:Frame({X = 0, Y = 0, Width = 1, Height = n15, Corner = 0.35, Background = "#000000", BackgroundTransparency = 1})
			options2.Accent = arg:Frame({Parent = options2.Card, X = 0, Y = 0, Width = 0.22, Height = n15, Corner = 0.11, Background = D.idle.Color, BackgroundTransparency = 0})
			options2.Title = arg:Text({Parent = options2.Card, X = a, Y = 0.3, Width = 1, Height = height, Scale = 1.2, Wrap = false, Font = json2, TextStrokeTransparency = 1})
			options2.Server = arg:Text({Parent = options2.Card, X = a, Y = 0.3, Width = 1, Height = height, Wrap = false, Align = "Right"})
			options2.Detail = arg:Text({Parent = options2.Card, X = a, Y = 0.3 + height, Width = 1, Height = 1, Wrap = false})
			options2.Bar = arg:Bar({Parent = options2.Card, X = a, Y = n15, Width = 1, Height = 0.3, Alpha = 0, Corner = 0.15, Background = "#2A2F3A", Visible = false})
			options2.Divider = arg:Frame({Parent = options2.Card, X = a, Y = n15, Width = 1, Height = 0.06, Background = "#FFFFFF", BackgroundTransparency = 0.85, Visible = false})
			local tbl6, v26 = {Parent = options2.Card, X = a, Y = n15, Width = n18, Height = n18, Corner = 0.35, Background = "#000000", BackgroundTransparency = 0.45, StrokeThickness = z, StrokeTransparency = 0, Visible = false}
			v26, v25 = arg:Image(tbl6), u32Trunc((2147483647 + u32Mul(2147483648, v25)) + (0 + u32Mul(2147483647, (bit32.bnot((bit32.bxor(v25, 251238944)))))))
			options2.Icon = v26
			options2.Name = arg:Text({Parent = options2.Card, X = a, Y = n15, Width = 1, Height = height, Scale = 1.2, Wrap = false, Font = json, TextStrokeTransparency = 1, StrokeTransparency = 0.2, StrokeThickness = M, Visible = false})
			options2.Chip = arg:Frame({Parent = options2.Card, X = 0, Y = 0, Width = 1, Height = u, Corner = 0.3, Background = "#000000", BackgroundTransparency = 0.35, StrokeThickness = z, StrokeTransparency = 0, Visible = false})
			options2.ChipText = arg:Text({Parent = options2.Chip, X = 0, Y = 0, Width = 1, Height = u, Scale = 0.78, Wrap = false, Align = "Center", Font = json2, TextStrokeTransparency = 1})
			options2.Info = arg:Text({Parent = options2.Card, X = a, Y = n15, Width = 1, Height = 1, Wrap = false, Visible = false})
			tbl6 = {"Card", "Accent", "Title", "Server", "Detail", "Bar", "Divider", "Icon", "Name", "Chip", "ChipText", "Info"}

			for _, v27 in ipairs(tbl6) do
				fn42(options2[v27])
			end

			local function _(arg2, arg3, arg4)
				arg2 = (arg3 == C) and (arg4 == n19)
				if arg2 then
					return
				end
				C, n19 = arg3, arg4
				k, Q = arg3 / math.max(arg4, 1), arg4
				M = 0.9 / math.max(arg:TextSize(), 1)
				options2.Name.Set({StrokeThickness = M})
				n20 = 2
			end

			arg:OnResize(_)
			E = true
		end

		function N.View()
			E = true
		end

		local v25 = t:CreateCanvas({Name = "Hop Status", ShowTitle = false, Layout = "free", Style = {TextScale = 1, LineHeight = 1.1, MinLines = 2, MaxLines = 7, AutoHeight = true, BackgroundTransparency = 0.5, TextColor = Color3.fromRGB(255, 255, 255), TextStrokeTransparency = 0.7}, Build = function(_)
			fn46(_)
		end})

		fn6(function()
			v25:Destroy()
		end)

		local v26
		v242 = RunService
		fn40 = v242.Heartbeat

		local function G(arg)
			local flag5 = not H or not fn41(H:Root())
			if flag5 then
				return
			end
			U += arg
			flag5 = E or (U >= 1)

			if flag5 then
				E, U = false, 0
				pcall(fn44)
			end

			pcall(fn45)
			arg = (n20 > 0) or s

			if arg then
				flag5 = n20 > 0

				if flag5 then
					n20 -= 1
				end

				pcall(V)
			end
		end

		local connection = fn40:Connect(G)

		fn6(function()
			connection:Disconnect()
		end)
	end

	readJsonFile, tbl22 = tbl2, tbl2
	readJsonFile.HopHandles = tbl22.HopHandles or {}
	local tbl23 = tbl2

	tbl23.HopHandles.Finder = function()
		return N.Handle
	end

	N.Handle = t:CreateToggle({Name = "Auto Hop", Note = "Joins new servers to find eggs that match the filters below", Default = false, Callback = function()
		local tbl24 = bit32.bxor(318695285, 0)
		local tbl242 = tbl24
		N.Generation = N.Generation + 1
		tbl24 = bit32.bxor(tbl242, 368256243)
		N.HopEnd = 0
		tbl242 = tbl2
		local flag3 = not tbl242.Toggle(N.Handle, false)

		if flag3 then
			pcall(tbl2.HopPrompt.Hide)

			if not N.StopNote then
				w()
			end

			q(N.StopNote or "Idle", "idle")
			N.StopNote = nil
			return
		end

		flag3 = tbl2
		tbl242 = flag3.HopPrompt.Manual()
		tbl24 = u32Trunc((u32Mul(463758153, tbl24) + 2895388757) + (u32Mul(3831209144, (bit32.bor(tbl24, 495765677))) + u32Mul(3831209142, (bit32.band(tbl24, 495765677)))))
		if not tbl242 then
			fn37()
			return
		end
		w()
		q("Idle", "idle")

		flag3, tbl242 = tbl2, pcall(tbl2.HopPrompt.Show, {Title = "Auto Hop", Warn = "WARNING", Body = "Auto Hop keeps joining new servers to find eggs that match its filters. Turn it off to stop.", Tip = "\"Collect Then Hop\" and \"Wait For Target Egg\" hop until night, then wait for the next day.", Cancel = "Cancel", Accept = "Turn On"}, function()
			local tbl25 = tbl2

			if tbl25.Toggle(N.Handle, false) then
				fn37()
			end
		end, function()
			local v24 = bit32.bxor(333599609, 0)
			local V
			V, v24 = pcall, u32Trunc((u32Mul(1629480073, v24) + 679221750) + (u32Mul(2665487224, (bit32.bor(v24, 18913478))) + u32Mul(2665487222, (bit32.band(v24, 18913478)))))

			V(function()
				N.Handle:Set(false)
			end)
		end)

		if not tbl242 then
			fn37()
		end
	end})

	local tbl24 = tbl2

	tbl24.AutoHopActive = function()
		local tbl25 = tbl2
		return tbl25.Toggle(N.Handle, false) == true
	end

	options()

	t:CreateDropdown({Name = "Hop Mode", Note = "When to move on to the next server", Options = eggList, Default = eggList[1], SubOf = N.Handle, Callback = function(arg)
		local pos = (table.find(eggList, arg) and arg) or eggList[1]

		if pos ~= N.Mode then
			N.Mode = pos
			N.HopEnd = 0
		end
	end})

	local function fn38(Z)
		local v24, tbl32 = ipairs, tbl3
		local rarityChoices = tbl32.RarityChoices

		for _, rarityChoice in v24(rarityChoices) do
			tbl32 = tbl3
			if (tbl32.RarityRank[rarityChoice] or 0) == Z then
				return rarityChoice
			end
		end

		tbl32 = tbl3
		return tbl32.RarityChoices[1]
	end

	local function Z(arg)
		local ks = {}

		for k, v24 in pairs(arg or {}) do
			if v24 == true then
				ks[#ks + 1] = k
			end
		end

		return ks
	end

	local function fn39(V)
		local kMap = {}

		for k, v24 in pairs(V or {}) do
			kMap[k] = v24
		end

		return kMap
	end

	local V, G, l, v24, v25 = false, false

	local function fn40()
		local _ = bit32.bxor(246489386, 0)
		local v26 = _
		local tbl42, tbl422 = V

		if tbl42 then
			tbl422 = tbl42
		else
			local tbl43
			tbl43, tbl422 = tbl4, type(tbl4.CollectFilters) ~= "function"
		end

		if tbl422 then
			return
		end
		V = true
		tbl42 = tbl4
		local v27, o, v28 = tbl42.CollectFilters()
		_ = u32Trunc((u32Mul(827072780, v26) + 858316064) + (u32Mul(3467894517, (bit32.bor(v26, 148781848))) + u32Mul(3467894515, (bit32.band(v26, 148781848)))))
		N.MinRank = tonumber(v27) or 0
		N.Wanted = fn39(o)
		N.MinWeight = tonumber(v28) or 0
		v27 = nil
		v27, _ = pcall, bit32.bxor(_, 426182050)

		v27(function()
			v25:Set(tbl3.WeightStep(N.MinWeight))
		end)

		pcall(function()
			l:Set(fn38(N.MinRank))
		end)

		pcall(function()
			v24:Set(Z(N.Wanted))
		end)

		V = false
	end

	local function fn41()
		local _ = bit32.bxor(361034203, 0)
		local flag3 = _
		local v26
		v26, _ = V, u32Trunc(flag3 + 340418749)
		flag3 = (v26 or not G) or not N.Sync
		if flag3 then
			return
		end
		_, V = u32Trunc(_ - 321574800), true

		pcall(function()
			local tbl42 = tbl4
			tbl42.CollectRarity:Set(fn38(N.MinRank))
		end)

		pcall(function()
			local tbl42 = tbl4
			tbl42.CollectEggs:Set(Z(N.Wanted))
		end)

		pcall(function()
			local tbl42 = tbl4
			tbl42.CollectWeight:Set(tbl3.WeightStep(N.MinWeight or 0))
		end)

		V = false
	end

	local tbl42 = tbl4

	tbl42.OnCollectFilter = function()
		local sync = (N.Sync and G) and not V

		if sync then
			fn40()
		end
	end

	t:CreateLabel({Name = "Collect Filters", Text = "Collect Filters", SubOf = N.Handle})

	t:CreateToggle({Name = "Sync With Auto Collect Filters", Note = "Changing a filter here also changes it in Auto Collect Eggs, and back", Default = true, SubOf = N.Handle, Callback = function(I)
		N.Sync = I ~= false
		I = N.Sync and G

		if I then
			fn40()
		end
	end})

	local options2, tbl32 = {Name = "Min Egg Rarity", Note = "Find eggs of the chosen rarity and every rarity above it"}, tbl3
	options2.Options = tbl32.RarityChoices
	readJsonFile = tbl3
	options2.Default = readJsonFile.RarityChoices[1]
	options2.SubOf = N.Handle

	options2.Callback = function(arg)
		local tbl33 = V
		if tbl33 then
			return
		end
		tbl33 = tbl3
		N.MinRank = tbl33.RarityRank[tostring(arg)] or 0
		fn41()
	end

	l = t:CreateDropdown(options2)
	local I
	local fn72, options3, v26 = fn7, {Name = "Target Eggs", Note = "Only look for these eggs (empty = all)"}
	options = names
	options3.Options = options
	options3.Default = {}
	options3.SubOf = N.Handle

	local function callback(arg)
		local v27 = V
		if v27 then
			return
		end
		local _
		N.Wanted = fn10(arg)
		fn41()
	end

	options3.Callback = callback
	v24 = fn72(t:CreateMultiDropdown(options3))
	v42 = tbl3
	options3, options, tbl22 = v42.WeightSlider, t, {Name = "Min Egg Weight", SubOf = N.Handle}

	local function onRaw(minWeight)
		local v27 = V
		if v27 then
			return
		end
		N.MinWeight = minWeight
		fn41()
	end

	tbl22.OnRaw = onRaw
	v25 = options3(options, tbl22)
	t:CreateLabel({Name = "Wait For Target Egg", Text = "Wait For Target Egg", SubOf = N.Handle})
	local options4, tbl33 = {Name = "Rarity To Wait For"}, tbl3
	options4.Options = tbl33.RarityChoices
	options4.Default = "Divine"
	options4.SubOf = N.Handle

	options4.Callback = function(arg)
		local tbl34 = tbl3
		N.WaitRank = tbl34.RarityRank[tostring(arg)] or 0
	end

	t:CreateDropdown(options4)
	options, tbl22, v42 = fn7, {Name = "Eggs To Wait For"}, names
	tbl22.Options = v42
	tbl22.Default = {}
	tbl22.SubOf = N.Handle

	local function callback2(arg)
		local A
		N.WaitEggs = fn10(arg)
	end

	tbl22.Callback = callback2
	options(t:CreateMultiDropdown(tbl22))
	t:CreateLabel({Name = "Hop Timing", Text = "Hop Timing", SubOf = N.Handle})

	t:CreateSlider({Name = "Hop Delay", Note = "Wait this long after the script starts before the first hop", Min = 3, Max = 10, Default = 5, AllowDecimals = true, Increment = 0.5, Unit = "s", SubOf = N.Handle, Callback = function(arg)
		N.HopDelay = math.clamp(tonumber(arg) or 5, 3, 10)
	end})

	t:CreateSlider({Name = "Wait In Each Server", Note = "Extra time to wait for a matching egg to spawn before hopping (0 = off)", Min = 0, Max = 120, Default = 5, Increment = 1, Unit = "s", SubOf = N.Handle, Callback = function(arg)
		N.Wait = math.clamp(tonumber(arg) or 5, 0, 120)
	end})

	task.delay(5, function()
		G = true

		if N.Sync then
			fn40()
		end
	end)

	fn6(function()
		N.Generation = N.Generation + 1
		local tbl43 = tbl4
		tbl43.OnCollectFilter = nil
	end)
end

fn31()
local v21 = v4:CreateTab({ Name = "Misc", SectionsExpanded = true })
local v22 = v21:CreateSection({ Name = "Performance", Expanded = true })

local function fn32()
	local B, Z = bit32.bxor(402213268, 0), false
	B = u32Trunc(B + 489645316)
	local q
	local v222 = v22
	B = u32Trunc(B - 454747207)

	v222:CreateSlider({Name = "FPS Cap", Min = 30, Max = 1000, Default = 240, AllowDecimals = false, Increment = 1, Unit = " FPS", Callback = function(I)
		local n12 = math.clamp(math.floor(tonumber(I) or 240), 30, 1000)
		I = (type(setfpscap) == "function") and pcall(setfpscap, n12)
		if I then
			Z = false
			return
		end
		I = not Z

		if I then
			Z = true
			local v23
			fn9("FPS Cap Unavailable", "This environment does not support setfpscap.")
		end
	end})
end

fn32()

local function fn33()
	local B = bit32.bxor(332516357, 0)
	local Lighting, V, x, G = game:GetService("Lighting"), 0.003, false, 0
	B = u32Trunc(B + 51378870)
	local thread
	local connections, list2, v222, t = {}, {}
	v222, t, B = setmetatable, {__mode = "k"}, u32Trunc(B + 383700880)
	local v23, descendants, connection = v222({}, t), {}

	local function F(W, _, N)
		local ok, m = pcall(W)
		if not ok then
			return
		end
		list2[#list2 + 1] = {Setter = _, Value = m}
		pcall(_, N)
	end

	local function W(_, N, b)
		local m = bit32.bxor(309826652, 0)
		local p = v23[_]
		m = u32Trunc((u32Mul(1818968999, m) + 832678798) + (u32Mul(657029298, (bit32.bor(m, 333267394))) + u32Mul(1818969000, (bit32.bxor(m, 333267394)))))
		local o = not p
		m = bit32.bxor(m, 39141397)

		if o then
			p = {}
			v23[_] = p
		else
		end

		if p[N] == nil then
			local v24 = bit32.bxor(19760633, 0)
			o = nil
			o, v24 = pcall, u32Trunc(v24 + 347567795)

			local v25, P = o(function()
				return _[N]
			end)

			if not v25 then
				return
			end
			p[N] = {Value = P}
		end

		pcall(function()
			_[N] = b
		end)
	end

	local function _(N)
		local b = not x or not N.Parent
		if b then
			return
		end

		if N:IsA("ParticleEmitter") then
			W(N, "Enabled", false)
			W(N, "Rate", 0)
		elseif N:IsA("Trail") or N:IsA("Beam") then
			W(N, "Enabled", false)
		elseif (N:IsA("PointLight") or N:IsA("SpotLight")) or N:IsA("SurfaceLight") then
			W(N, "Enabled", false)
			W(N, "Brightness", 0)
		elseif (N:IsA("Fire") or N:IsA("Smoke")) or N:IsA("Sparkles") then
			W(N, "Enabled", false)
		elseif N:IsA("Explosion") then
			W(N, "Visible", false)
		elseif N:IsA("SpecialMesh") then
			W(N, "TextureId", "")
		elseif N:IsA("Decal") or N:IsA("Texture") then
			if not (((N.Name == "face") and N.Parent) and (N.Parent.Name == "Head")) then
				W(N, "Transparency", 1)
			end
		elseif N:IsA("MeshPart") then
			W(N, "RenderFidelity", Enum.RenderFidelity.Performance)
			W(N, "TextureID", "")
			W(N, "CastShadow", false)
			W(N, "Reflectance", 0)
			W(N, "Material", Enum.Material.SmoothPlastic)
		elseif N:IsA("BasePart") then
			W(N, "CastShadow", false)
			W(N, "Reflectance", 0)
			W(N, "Material", Enum.Material.SmoothPlastic)
		elseif N:IsA("PostEffect") then
			W(N, "Enabled", false)
		elseif N:IsA("Clouds") then
			W(N, "Cover", 0)
			W(N, "Density", 0)
		elseif N:IsA("Atmosphere") then
			W(N, "Density", 0)
			W(N, "Haze", 0)
			W(N, "Glare", 0)
		end
	end

	local function fn34()
		for _, connection2 in ipairs(connections) do
			if connection2.Connected then
				connection2:Disconnect()
			end
		end

		table.clear(connections)
		local connection2 = connection

		if connection2 then
			local N = bit32.bxor(128232098, 0)
			local b = N
			local m
			m, N = pcall, u32Trunc((u32Mul(469229108, b) + 4253186548) + (u32Mul(3356509080, (bit32.bor(b, 53071537))) + u32Mul(469229109, (bit32.bxor(b, 53071537)))))

			m(function()
				connection:Disconnect()
			end)

			connection = nil
		end
	end

	local function N()
		local b = bit32.bxor(188569305, 0)
		local terrain = b
		local ok, o, rendering = settings(), u32Mul(2635976427, terrain) + 3755106693
		b, rendering = u32Trunc(o + (u32Mul(1658990870, (bit32.bor(terrain, 31642959))) + u32Mul(1658990868, (bit32.band(terrain, 31642959))))), ok.Rendering
		b = bit32.bxor(b, 284054844)
		terrain = workspace.Terrain

		local function fn35(arg, r, c)
			local w = bit32.bxor(211810542, 0)
			w = u32Trunc((u32Mul(1067892099, w) + 2423444515) + (u32Mul(3227075198, (bit32.bor(w, 97610977))) + u32Mul(3227075196, (bit32.band(w, 97610977)))))

			F(function()
				return arg[r]
			end, function(arg2)
				arg[r] = arg2
			end, c)
		end

		fn35(rendering, "QualityLevel", Enum.QualityLevel.Level01)
		fn35(rendering, "MeshPartDetailLevel", Enum.MeshPartDetailLevel.Level01)
		fn35(rendering, "EditQualityLevel", Enum.QualityLevel.Level01)

		ok, rendering = pcall(function()
			return UserSettings():GetService("UserGameSettings")
		end)

		if ok and rendering then
			fn35(rendering, "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
		end

		fn35(Lighting, "GlobalShadows", false)
		fn35(Lighting, "ShadowSoftness", 0)
		fn35(Lighting, "FogEnd", 9000000000)
		fn35(Lighting, "Technology", Enum.Technology.Legacy)
		fn35(Lighting, "EnvironmentDiffuseScale", 0)
		fn35(Lighting, "EnvironmentSpecularScale", 0)
		fn35(terrain, "Decoration", false)
		fn35(terrain, "WaterWaveSize", 0)
		fn35(terrain, "WaterWaveSpeed", 0)
		fn35(terrain, "WaterReflectance", 0)
		fn35(terrain, "WaterTransparency", 1)
	end

	local function fn35(b, m)
		local now, o, descendants2 = os.clock(), ipairs, table.pack(b:GetDescendants())

		for k, v24 in o(table.unpack(descendants2, 1, descendants2.n)) do
			b = not x or (G ~= m)
			if b then
				return false
			end
			_(v24)
			v24 = (os.clock() - now) > V

			if v24 then
				local v25
				k = RunService
				k.Heartbeat:Wait()
				now = os.clock()
			else
			end
		end

		return true
	end

	local function b()
		local m = not x or (#descendants == 0)
		if m then
			return
		end
		m = os.clock()

		while #descendants > 0 do
			_((table.remove(descendants)))
			if (os.clock() - m) > V then
				break
			end
		end
	end

	local function fn36()
		local clock, p = os.clock, pairs
		local now = clock()

		for k, v24 in p(v23) do
			if k.Parent then
				for k2, v25 in pairs(v24) do
					local w = bit32.bxor(77944500, 0)
					clock = w
					local Y
					Y, w = pcall, u32Trunc((u32Mul(1231658332, clock) + 3106393512) + (u32Mul(3063308965, (bit32.bor(368768934, clock))) + u32Mul(3063308963, (bit32.band(368768934, clock)))))

					Y(function()
						k[k2] = v25.Value
					end)
				end
			end

			v23[k] = nil
			v24 = (os.clock() - now) > V

			if v24 then
				local v25
				local RunService2 = RunService
				RunService2.Heartbeat:Wait()
				now = os.clock()
			else
			end
		end
	end

	local function fn37()
		local thread2 = x
		if not thread2 then
			return
		end
		x = false
		G += 1
		fn34()
		table.clear(descendants)
		thread2 = thread

		if thread2 then
			pcall(task.cancel, thread)
			thread = nil
		end

		fn36()

		for i = #list2, 1, -1 do
			thread2 = list2[i]
			pcall(thread2.Setter, thread2.Value)
		end

		table.clear(list2)
	end

	local function fn38()
		local T = bit32.bxor(436805043, 0)
		local v24 = T
		local RunService2 = x
		if RunService2 then
			return
		end
		x = true
		G += 1
		T = u32Trunc((u32Mul(1366993483, v24) + 3951777620) + (u32Mul(1560980330, (bit32.bor(v24, 524923260))) + u32Mul(1366993484, (bit32.bxor(v24, 524923260)))))
		local v25 = G
		T = bit32.bxor(T, 91218367)
		N()

		local function fn39(arg)
			local m = bit32.bxor(94386998, 0)
			local p = m
			m = u32Trunc(p + 207122959)
			m = u32Trunc(m + 106394840)

			connections[#connections + 1] = arg.DescendantAdded:Connect(function(descendant)
				local flag3 = x and (G == v25)

				if flag3 then
					descendants[#descendants + 1] = descendant
				end
			end)
		end

		fn39(workspace)
		fn39(Lighting)
		local f
		RunService2 = RunService

		connection = RunService2.Heartbeat:Connect(function()
			local flag3 = x and (G == v25)

			if flag3 then
				b()
			end
		end)

		thread = task.spawn(function()
			if fn35(workspace, v25) then
				fn35(Lighting, v25)
			end
		end)
	end

	local K
	fn6(fn37)
	local v24

	do
		local v25, flag3 = bit32.bxor(533105739, 0), false
		v25 = bit32.bxor(v25, 218842940)
		local folder
		local g, connections2 = {}, {}

		local function T()
			local l
			local tbl32 = tbl3
			return tbl32.Plot()
		end

		local function Z(l)
			local O = bit32.bxor(147173083, 0)
			local v26 = O
			local flag4 = (not flag3 or not folder) or g[l]
			if flag4 then
				return
			end
			O = u32Trunc(v26 + 8351626)
			g[l] = l.Parent
			flag4 = nil
			flag4, O = pcall, u32Trunc(O + 454790099)

			flag4(function()
				l.Parent = folder
			end)
		end

		v25 = bit32.bxor(v25, 174683271)

		local function fn39(l)
			local O = bit32.bxor(16091105, 0)
			local pets = O
			local children
			O, children = u32Trunc(pets + 4150605), T()
			if l == children then
				return
			end
			pets = l:FindFirstChild("Pets")
			if not pets then
				return
			end
			l, children = ipairs, table.pack(pets:GetChildren())
			O = u32Trunc(O + 101750717)

			for _, v26 in l(table.unpack(children, 1, children.n)) do
				Z(v26)
			end

			connections2[#connections2 + 1] = pets.ChildAdded:Connect(function(child)
				task.defer(Z, child)
			end)
		end

		local function fn40()
			flag3 = false

			for i, v26 in ipairs(connections2) do
				local O = bit32.bxor(277977098, 0)
				i = O
				local v27
				v27, O = pcall, u32Trunc(i + 260883628)

				v27(function()
					v26:Disconnect()
				end)
			end

			table.clear(connections2)

			for k, v26 in pairs(g) do
				local O = bit32.bxor(160202711, 0)
				local v27
				v27, O = pcall, bit32.bxor(O, 382462873)

				v27(function()
					if v26 and v26.Parent then
						k.Parent = v26
					end
				end)
			end

			table.clear(g)
		end

		local function fn41()
			local v26 = bit32.bxor(463131659, 0)
			local v262 = v26
			local flag32 = flag3
			v26 = u32Trunc((u32Mul(200540203, v262) + 1806556496) + (u32Mul(3893886890, (bit32.bor(v262, 66691056))) + u32Mul(200540204, (bit32.bxor(v262, 66691056)))))
			if flag32 then
				return
			end
			flag3 = true
			v262 = not folder

			if v262 then
				folder = Instance.new("Folder")
				local folder2, v27 = folder
				folder2.Name = fn5()
			end

			flag32 = workspace:FindFirstChild("Plots")
			if not flag32 then
				return
			end

			for _, child in ipairs(flag32:GetChildren()) do
				fn39(child)
			end

			local q, childAdded
			q, childAdded, v26 = #connections2 + 1, flag32.ChildAdded, bit32.bxor(v26, 194539231)

			connections2[q] = childAdded:Connect(function(arg)
				task.wait(1)
				local flag33 = flag3

				if flag33 then
					fn39(arg)
				end
			end)
		end

		fn6(fn40)
		v222 = v22

		v222:CreateToggle({Name = "Hide Other Players' Pets", Note = "Hides pets on other plots on your screen only, big FPS gain", Default = false, Callback = function(q)
			if q then
				fn41()
			else
				fn40()
			end
		end})

		t = v22

		t:CreateToggle({Name = "Disable 3D Rendering", Note = "Stops drawing the world while you AFK, the farm keeps running", Default = false, Callback = function(arg)
			local q = bit32.bxor(11755088, 0)
			local v26
			v26, q = pcall, u32Trunc(q + 240987347)

			v26(function()
				local v27
				local RunService2 = RunService
				RunService2:Set3dRenderingEnabled(arg ~= true)
			end)
		end})

		fn6(function()
			local A = bit32.bxor(512085547, 0)
			local v26
			v26, A = pcall, u32Trunc(A + 80287363)

			v26(function()
				local I
				local RunService2 = RunService
				RunService2:Set3dRenderingEnabled(true)
			end)
		end)
	end

	v222 = v22

	v222:CreateToggle({Name = "Optimizer", Note = "Strip shadows, textures and effects for the highest FPS", Default = false, Callback = function(I)
		if I then
			fn38()
		else
			task.spawn(fn37)
		end
	end})
end

fn33()

local function fn34()
	local B = bit32.bxor(456315631, 0)
	local Stats, G, g, f, T = game:GetService("Stats"), 132, 34, 0.085, 0.2
	B = bit32.bxor(B, 280438407)
	local y, t = 8
	local v42 = v4
	local L = v42:CreateState({Name = "FPS and Ping Position", Default = {}})
	B = u32Trunc((u32Mul(628402222, B) + 2204163136) + (u32Mul(3038162852, (bit32.bor(B, 111556320))) + u32Mul(628402223, (bit32.bxor(B, 111556320)))))

	local function getUDim2()
		local l = L:Get()
		if ((type(l) == "table") and (type(l.XOffset) == "number")) and (type(l.YOffset) == "number") then
			return UDim2.new(tonumber(l.XScale) or 0, l.XOffset, tonumber(l.YScale) or 0, l.YOffset)
		end
		return UDim2.new(0, 16, 0, 16)
	end

	local function l(O)
		L:Set({XScale = O.X.Scale, XOffset = O.X.Offset, YScale = O.Y.Scale, YOffset = O.Y.Offset})
	end

	local color = Color3.fromRGB(58, 255, 55)
	local color2 = Color3.fromRGB(255, 214, 84)
	local color3 = Color3.fromRGB(255, 96, 96)
	local color4, _, connections, screenGui, frame, uiScale, o, P = Color3.fromRGB(150, 150, 158), false, {}
	local r, c, w, text, text2, font = 1, 0, 0

	pcall(function()
		font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	end)

	local function j(d)
		if d >= 100 then
			return color
		elseif d >= 50 then
			return color2
		end

		return color3
	end

	local function d(a)
		if a <= 90 then
			return color
		elseif a <= 180 then
			return color2
		end

		return color3
	end

	local function O()
		local uiScale2 = uiScale
		if not uiScale2 then
			return
		end
		uiScale2 = workspace.CurrentCamera
		local viewportSize = (uiScale2 and uiScale2.ViewportSize) or Vector2.new(1280, 720)
		viewportSize = if viewportSize.X < 1 then Vector2.new(1280, 720) else viewportSize
		local F, uiScale3 = math.clamp((viewportSize.X * f) / G, 0.7, 1.4), uiScale
		uiScale3.Scale = F * r
	end

	local function fn35()
		for i, connection in ipairs(connections) do
			local S = bit32.bxor(117657434, 0)
			i = nil
			i, S = pcall, bit32.bxor(S, 322222413)

			i(function()
				connection:Disconnect()
			end)
		end

		table.clear(connections)
		local screenGui2 = screenGui

		if screenGui2 then
			local F = bit32.bxor(24916775, 0)
			local a = F
			local S
			S, F = pcall, u32Trunc(a + 352422289)

			S(function()
				screenGui:Destroy()
			end)
		end

		screenGui, frame, uiScale, o, P, text, text2, c = nil, nil, nil, nil, nil, nil, nil, 0
	end

	local function createTextLabel(parent, S, u, textColor3)
		local textLabel = Instance.new("TextLabel")
		local X
		textLabel.Name = fn5()
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.fromOffset(S, 9)
		textLabel.Size = UDim2.fromOffset(u, 16)
		textLabel.Text = ""
		textLabel.TextColor3 = textColor3
		textLabel.TextScaled = true
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		u = font

		if u then
			textLabel.FontFace = font
		else
			textLabel.Font = Enum.Font.GothamBold
		end

		textLabel.Parent = parent
		return textLabel
	end

	local function J()
		local a = bit32.bxor(188577221, 0)
		local RunService2 = a
		fn35()
		screenGui = Instance.new("ScreenGui")
		local uiElement, z = screenGui
		uiElement.Name = fn5()
		screenGui.Archivable = false
		screenGui.DisplayOrder = 58
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		uiElement = screenGui
		uiElement.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		frame = Instance.new("Frame")
		uiElement = frame
		uiElement.Name = fn5()
		frame.Active = true
		uiElement = frame
		uiElement.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
		frame.BackgroundTransparency = 0.28
		frame.BorderSizePixel = 0
		uiElement = frame
		uiElement.Position = getUDim2()
		uiElement = frame
		uiElement.Size = UDim2.fromOffset(G, g)
		frame.Parent = screenGui
		uiElement = Instance.new("UICorner")
		uiElement.Name = fn5()
		uiElement.CornerRadius = UDim.new(0, 12)
		uiElement.Parent = frame
		uiElement = Instance.new("UIStroke")
		uiElement.Name = fn5()
		uiElement.Color = Color3.fromRGB(255, 255, 255)
		uiElement.Thickness = 1
		uiElement.Transparency = 0.9
		uiElement.Parent = frame
		uiScale = Instance.new("UIScale")
		uiElement = uiScale
		uiElement.Name = fn5()
		uiScale.Parent = frame
		O()
		o = createTextLabel(frame, 12, 34, color)
		createTextLabel(frame, 48, 22, color4).Text = "FPS"
		uiElement = Instance.new("Frame")
		uiElement.Name = fn5()
		uiElement.AnchorPoint = Vector2.new(0.5, 0.5)
		uiElement.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		uiElement.BackgroundTransparency = 0.85
		uiElement.BorderSizePixel = 0
		local uDim2New, UserInputService2 = UDim2.new, u32Trunc(g)
		a, uiElement.Position = u32Trunc((3830519896 + RunService2) + (u32Mul(3582946353, UserInputService2) + u32Mul(3582946353, (bit32.bnot(UserInputService2))))), uDim2New(0, 74, 0.5, 0)
		uiElement.Size = UDim2.fromOffset(1, 14)
		uiElement.Parent = frame
		P = createTextLabel(frame, 82, 30, color)
		createTextLabel(frame, 113, 14, color4).Text = "ms"
		local v23
		uDim2New = v9
		screenGui.Parent = uDim2New
		uDim2New = workspace.CurrentCamera

		if uDim2New then
			connections[#connections + 1] = uDim2New:GetPropertyChangedSignal("ViewportSize"):Connect(O)
		end

		local flag3, input = false
		local vector2Zero, position = Vector2.zero

		connections[#connections + 1] = frame.InputBegan:Connect(function(input2)
			local flag32 = flag3 or (input2.UserInputState ~= Enum.UserInputState.Begin)
			if flag32 then
				return
			end
			local F, W = input2.UserInputType == Enum.UserInputType.MouseButton1, input2.UserInputType == Enum.UserInputType.Touch
			if not F and not W then
				return
			end
			flag3 = true
			input = (W and input2) or nil
			vector2Zero = Vector2.new(input2.Position.X, input2.Position.Y)
			position = frame.Position
		end)

		local v24, UserInputService3

		UserInputService3, connections[#connections + 1] = UserInputService, UserInputService.InputChanged:Connect(function(input2)
			local W = (not flag3 or not frame) or not position
			if W then
				return
			end
			W = (input and (input2 == input)) or (not input and (input2.UserInputType == Enum.UserInputType.MouseMovement))
			if not W then
				return
			end
			local n12, frame2 = Vector2.new(input2.Position.X, input2.Position.Y) - vector2Zero, frame
			frame2.Position = UDim2.new(position.X.Scale, position.X.Offset + n12.X, position.Y.Scale, position.Y.Offset + n12.Y)
		end)

		UserInputService2 = nil

		UserInputService2, connections[#connections + 1] = UserInputService, UserInputService.InputEnded:Connect(function(input2)
			local flag32 = flag3
			if not flag32 then
				return
			end
			flag32 = (input and (input2 == input)) or (not input and (input2.UserInputType == Enum.UserInputType.MouseButton1))

			if flag32 then
				flag3, input, position = false, nil, nil
				input2 = frame

				if input2 then
					l(frame.Position)
				end
			end
		end)

		local n12, v25 = #connections + 1
		RunService2 = RunService
		UserInputService3 = RunService2.RenderStepped

		local function fn36(A)
			local Z = bit32.bxor(165881902, 0)
			local q = Z
			local text3 = not _ or not o
			if text3 then
				return
			end
			text3 = math.clamp(A, 0.001, 1)
			local text4, flag4 = 1 / text3, c <= 0

			if flag4 then
				c = text4
			else
				A = c
				c = A + ((text4 - A) * (1 - math.exp(-text3 * y)))
			end

			text3, flag4 = os.clock(), w
			if text3 < flag4 then
				return
			end
			A = text3 + T
			w = A
			Z = bit32.bxor(q, 383859623)
			text3 = math.floor(c + 0.5)
			text4 = tostring(text3)
			flag4 = text4 ~= text

			if flag4 then
				text = text4
				o.Text = text4
				q = o
				q.TextColor3 = j(text3)
			end

			local n13 = 0
			text3 = u32Trunc(A)
			Z = u32Trunc((bit32.bxor(Z, 76000462) + 4087867196) + (u32Mul(4087867196, text3) + u32Mul(4087867196, (bit32.bnot(text3)))))

			pcall(function()
				n13 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
			end)

			text4 = math.floor(n13 + 0.5)
			text3 = tostring(text4)
			q = text3 ~= text2

			if q then
				text2 = text3
				P.Text = text3
				A = P
				A.TextColor3 = d(text4)
			end
		end

		connections[n12] = UserInputService3:Connect(fn36)
	end

	local I
	v42 = v22

	v22:CreateSlider({Name = "FPS and Ping Size", Min = 60, Max = 160, Default = 100, AllowDecimals = false, Increment = 1, Unit = "%", SubOf = v42:CreateToggle({Name = "FPS and Ping", Default = true, Callback = function(arg)
		_ = arg == true
		arg = _

		if arg then
			J()
		else
			fn35()
		end
	end}), Callback = function(arg)
		r = math.clamp((tonumber(arg) or 100) / 100, 0.6, 1.6)
		O()
	end})

	local v23
	fn6(fn35)
end

fn34()

local function fn35()
	local B = bit32.bxor(3833823, 0)
	local q
	local v212 = v21
	local L, h = v212:CreateSection({Name = "Utility", Expanded = true}), {Enabled = true}
	B = bit32.bxor(B, 16938084)
	h.Alive = true
	h.Silenced = {}
	v212 = game:GetService("GuiService")
	local gameRef
	gameRef, B = game, u32Trunc((u32Mul(133050183, B) + 559063056) + (u32Mul(4161917114, (bit32.bor(B, 320145264))) + u32Mul(4161917112, (bit32.band(B, 320145264)))))
	local TeleportService2 = gameRef:GetService("TeleportService")
	local K

	local function V()
		if (h.Alive and h.Enabled) and K then
			task.defer(K)
		end
	end

	local x, G

	x = function()
		if type(getconnections) ~= "function" then
			return {}
		end
		local localPlayer2, ok, g = localPlayer, pcall(getconnections, localPlayer.Idled)
		return ((ok and (type(g) == "table")) and g) or {}
	end

	local function fn36()
		local g, f = ipairs, table.pack(x())

		for k, v23 in g(table.unpack(f, 1, f.n)) do
			local v24, flag3 = bit32.bxor(388181626, 0), false
			v24 = u32Trunc(v24 + 371730000)
			k = nil
			k, v24 = pcall, u32Trunc(v24 - 78274133)

			k(function()
				flag3 = v23.Function == V
			end)

			local flag4, flag42 = not flag3

			if flag4 then
				local v25 = bit32.bxor(128996047, 0)
				k = nil
				k, v25 = pcall, u32Trunc(v25 + 87669104)

				flag42 = k(function()
					v23:Disable()
				end)
			else
				flag42 = flag4
			end

			if flag42 and not table.find(h.Silenced, v23) then
				h.Silenced[#h.Silenced + 1] = v23
			end
		end
	end

	local function g()
		local silenced = h.Silenced
		local T = #silenced

		for i, v23 in ipairs(if T == 0 then x() else silenced) do
			local v24 = bit32.bxor(311375238, 0)
			i = v24
			local f, l = pcall, u32Trunc(T)
			v24 = u32Trunc((4178296146 + i) + (u32Mul(3896042731, l) + u32Mul(3896042731, (bit32.bnot(l)))))

			f(function()
				v23:Enable()
			end)
		end

		table.clear(h.Silenced)
	end

	local localPlayer2, f = setmetatable, {__index = function()
		return function()
		end
	end}

	local T, list2 = localPlayer2({}, f), {}

	local function fn37()
		local list3 = {}
		if ((type(getgc) ~= "function") or (type(debug) ~= "table")) or (type(debug.getupvalues) ~= "function") then
			return list3
		end
		local ok, O = pcall(getgc, false)
		if not ok or (type(O) ~= "table") then
			return list3
		end

		for i, v23 in ipairs(O) do
			if (type(v23) == "function") and islclosure(v23) then
				i, ok = pcall(debug.info, v23, "s")

				if (i and (type(ok) == "string")) and string.find(ok, "AntiAFK", 1, true) then
					local ok2, result = pcall(debug.getupvalues, v23)

					if ok2 and (type(result) == "table") then
						for k, v24 in pairs(result) do
							if (typeof(v24) == "Instance") and (v24.ClassName == "TeleportService") then
								list3[#list3 + 1] = {Fn = v23, Index = k, Original = v24}
							end
						end
					end
				end
			end
		end

		return list3
	end

	local function t()
		for _, v23 in ipairs(fn37()) do
			local ok, O = pcall(debug.getupvalue, v23.Fn, v23.Index)

			if ok and (typeof(O) == "Instance") then
				if pcall(debug.setupvalue, v23.Fn, v23.Index, T) then
					list2[#list2 + 1] = v23
				end
			end
		end
	end

	local function fn38()
		for _, v23 in ipairs(list2) do
			pcall(debug.setupvalue, v23.Fn, v23.Index, v23.Original)
		end

		table.clear(list2)
	end

	local function fn39()
		fn36()

		if #list2 == 0 then
			t()
		end
	end

	local l

	do
		localPlayer2 = localPlayer

		local function fn40()
			local O = bit32.bxor(126959718, 0)
			local delay = O
			local W = task
			O = u32Trunc((u32Mul(2835519536, delay) + 1421014816) + (u32Mul(1459447761, (bit32.bor(delay, 327549478))) + u32Mul(1459447759, (bit32.band(delay, 327549478)))))
			delay = W.delay
			O = bit32.bxor(O, 454745406)

			delay(1, function()
				if h.Alive and h.Enabled then
					table.clear(h.Silenced)
					pcall(fn39)
				end
			end)
		end

		local connection = localPlayer2.CharacterAdded:Connect(fn40)

		fn6(function()
			local v23 = bit32.bxor(25318255, 0)
			local F
			F, v23 = pcall, u32Trunc(v23 + 73255967)

			F(function()
				connection:Disconnect()
			end)
		end)
	end

	localPlayer2 = localPlayer
	local connection = localPlayer2.Idled:Connect(V)

	local function fn40(arg)
		local pos = ((h.Alive and h.Enabled) and (type(arg) == "string")) and string.find(string.lower(arg), "idle", 1, true)

		if pos then
			local O = bit32.bxor(241957022, 0)
			arg = O
			local F = task
			O = u32Trunc((u32Mul(3857139918, arg) + 3203473318) + (u32Mul(875654756, (bit32.band(arg, 452212149))) + u32Mul(437827379, (bit32.bxor(arg, 452212149)))))
			local delay = F.delay
			O = bit32.bxor(O, 340541221)

			delay(2, function()
				local v23 = bit32.bxor(142198169, 0)
				local v24
				v24, v23 = pcall, u32Trunc(v23 + 506510442)

				v24(function()
					TeleportService2:Teleport(game.PlaceId, localPlayer)
				end)
			end)
		end
	end

	local connection2 = v212.ErrorMessageChanged:Connect(fn40)

	fn6(function()
		local A = bit32.bxor(405904062, 0)
		local Z = A
		A = u32Trunc((u32Mul(736586656, Z) + 4060213184) + (u32Mul(2821793984, (bit32.bor(Z, 426963862))) + u32Mul(736586657, (bit32.bxor(Z, 426963862)))))
		A = bit32.bxor(A, 219517521)
		h.Alive = false

		pcall(function()
			connection:Disconnect()
		end)

		pcall(function()
			connection2:Disconnect()
		end)

		g()
		fn38()
	end)

	local I, n12 = 600, 0

	K = function()
		fn36()
		n12 += 1
		local A = (#list2 == 0) or ((n12 % 2) == 0)

		if A then
			t()
		end
	end

	task.spawn(function()
		while h.Alive do
			if h.Enabled then
				K()
			end

			task.wait(I)
		end
	end)

	L:CreateToggle({Name = "Anti AFK", Default = true, Callback = function(arg)
		h.Enabled = arg ~= false

		if h.Enabled then
			fn39()
		else
			g()
			fn38()
		end
	end})
end

fn35()

local function fn36(arg, arg2)
	type(arg2)
	local arg22 = bit32.bxor(arg2, 0)
	local n12 = 1717504164
	local n13 = 3294331307
	local HttpService2 = game:GetService("HttpService")
	local httpRequest = syn
	local n14 = 9016275551
	httpRequest = httpRequest and syn.request
	local httpRequest2

	if httpRequest then
		httpRequest2 = httpRequest
	else
		httpRequest2 = http and http.request
	end

	local httpRequest3 = httpRequest2 or http_request or request
	local webhookSection = tbl2.WebhookSection or v21:CreateSection({ Name = "Webhook", Expanded = false })
	local labelMap = { Url = "", Saved = "" }
	local n142 = bit32.bxor(n14, 438853517)
	local n15 = n13 // n12
	bit32.bxor(arg22, arg2)
	local v23 = bit32.bxor(arg, 95594263)
	local v232 = table.pack(bit32.band(bit32.bnot(v23), 4294967295))
	local v24 = table.pack(bit32.band(v232[1], 65535))
	local n16 = 2209018346 + bit32.band(65535 * v24[1] + bit32.lshift(bit32.band(65535 * bit32.rshift(v232[1], 16) + 65535 * v24[1], 65535), 16), 4294967295)
	local arg23 = table.pack(bit32.band(arg2, 4294967295))
	local v25 = table.pack(bit32.band(arg23[1], 65535))
	local v26 = bit32.band(61931 * v25[1] + bit32.lshift(bit32.band(61931 * bit32.rshift(arg23[1], 16) + 33706 * v25[1], 65535), 16), 4294967295)
	local arg24 = table.pack(bit32.band(bit32.bnot(arg2), 4294967295))
	local v27 = table.pack(bit32.band(arg24[1], 65535))
	local n17 = n16 + v26 + bit32.band(61931 * v27[1] + bit32.lshift(bit32.band(61931 * bit32.rshift(arg24[1], 16) + 33706 * v27[1], 65535), 16), 4294967295)
	labelMap.Path = "ChilliLibrary/RAP_Webhook.txt"
	labelMap.LoadedAt = os.clock()
	labelMap.Stolen = false
	labelMap.EggMinRank = 0
	labelMap.Removed = {}
	labelMap.Gained = {}
	labelMap.Owned = nil
	local n18 = n12 + n15
	labelMap.Hatched = false
	labelMap.PingEveryone = false
	labelMap.MinRank = 0
	local n152 = bit32.bor(n15, 2602493359)
	local n172 = bit32.bxor(n17, 212855458)
	labelMap.MutatedOnly = false
	labelMap.Queue = {}
	labelMap.Sending = false
	labelMap.Disposed = false
	labelMap.Input = nil
	labelMap.Pending = {}
	labelMap.Seen = setmetatable({}, { __mode = "k" })

	pcall(function()
		if type(readfile) ~= "function" then
			return
		end

		if type(isfile) == "function" and not isfile(labelMap.Path) then
			return
		end
		local gsub = string.gsub
		local v28 = tostring
		local v29 = readfile(labelMap.Path)
		local v30 = gsub(v28(v29 or ""), "%s", "")
		labelMap.Saved = v30
		labelMap.Url = v30
	end)

	local function fn37(arg3)
		if type(arg3) ~= "string" then
			return false
		end

		for _, v28 in ipairs({ "discord%.com", "discordapp%.com", "ptb%.discord%.com", "canary%.discord%.com" }) do
			if string.match(arg3, "^https://" .. v28 .. "/api/webhooks/%d+/[%w%-_]+$") then
				return true
			end
		end

		return false
	end

	local function fn38()
		return type(httpRequest3) == "function" and fn37(labelMap.Url)
	end

	local function fn39(color)
		if typeof(color) ~= "Color3" then
			return 5793266
		end
		return math.floor(color.R * 255 + 0.5) * 65536 + math.floor(color.G * 255 + 0.5) * 256 + math.floor(color.B * 255 + 0.5)
	end

	local function fn40()
		local n19 = 4809645426
		if labelMap.Sending then
			return
		end
		local labelMap2 = labelMap
		local n192 = bit32.bxor(n19, 187872839)
		labelMap2.Sending = true

		task.spawn(function()
			bit32.bxor(n192, 4049128260)

			while #labelMap.Queue > 0 and not labelMap.Disposed do
				local queue = table.remove(labelMap.Queue, 1)

				if fn38() then
					local ok, result = pcall(httpRequest3, {
						Url = labelMap.Url,
						Method = "POST",
						Headers = { ["Content-Type"] = "application/json" },
						Body = HttpService2:JSONEncode(queue.Payload),
					})

					if (ok and type(result) == "table" and tonumber(result.StatusCode) or nil) == 429 and queue.Tries < 3 then
						queue.Tries = queue.Tries + 1
						table.insert(labelMap.Queue, 1, queue)
						task.wait(3)
					end
				end

				task.wait(1.2)
			end

			labelMap.Sending = false
		end)
	end

	local function fn41(arg3)
		if #labelMap.Queue >= 20 then
			table.remove(labelMap.Queue, 1)
		end

		if labelMap.PingEveryone then
			arg3.content = "@everyone"
			arg3.allowed_mentions = { parse = { "everyone" } }
		end

		table.insert(labelMap.Queue, { Payload = arg3, Tries = 0 })
		fn40()
	end

	local function fn42(arg3)
		local num = tonumber(arg3)
		if not num or num <= 0 then
			return nil
		end

		if num > 1 then
			num /= 100
		end

		if num >= 0.1 then
			return string.format("%.1f%%", num * 100)
		end
		return string.format("1 in %s", tostring(math.floor(1 / num + 0.5)))
	end

	local function fn43(arg3)
		local n19 = 2798749589
		local n20 = 4058837393
		local str3 = tostring(arg3.Pet or "Unknown")
		local str32 = tbl3.PetData(str3)

		if str32 then
			str32 = tostring(str32.Rarity or "")
		end

		str32 = str32 or ""
		local n202 = bit32.band(n20, 2588122532)

		if str32 == "" then
			str32 = "Unknown"
		end

		local mutation = arg3.Mutation
		local flag3 = type(mutation) == "string" and mutation ~= ""
		local str4 = "None"

		if flag3 then
			str4 = string.format("%s (x%s)", mutation, tostring(math.floor(tbl3.MutationBonus(mutation) * 100 + 0.5) / 100))
			n19 = bit32.bxor(n19 + 2980873839, 4272916881)
		end

		local parts = { "**" .. str3 .. "**  -  " .. str32, "**Mutation:** " .. str4 }
		local v28 = fn42(arg3.Chance)

		if v28 then
			parts[#parts + 1] = "**Chance:** " .. v28
		end

		if tonumber(arg3.Weight) then
			local n21 = #parts + 1
			local stringFormat = string.format
			local v29 = tonumber
			local n203 = bit32.bxor(n202, 4294967295)
			parts[n21] = stringFormat("**Weight:** %.2f", v29(arg3.Weight))
			n202 = n203 - 3749633279
		end

		if type(arg3.Egg) == "string" and arg3.Egg ~= "" then
			parts[#parts + 1] = "**Egg:** " .. arg3.Egg
		end

		local tbl5 = { username = "Chilli Hub" }
		local embeds = {}

		local tbl6 = {
			title = "Pet Hatched!",
			description = table.concat(parts, "\n"),
			color = fn39(tbl3.RarityColors and tbl3.RarityColors[str32]),
		}

		local footer = {}
		local text = "Chilli Hub  -  Ride A Pet  -  " .. localPlayer.Name
		bit32.band(n19, n202)
		footer.text = text
		tbl6.footer = footer
		tbl6.timestamp = DateTime.now():ToIsoDate()
		embeds[1] = tbl6
		tbl5.embeds = embeds
		return tbl5
	end

	local n19 = n18 + 1621396968

	local function fn44(arg3)
		if not labelMap.Hatched or not fn38() then
			return
		end
		local pet = tbl3.PetData(arg3.Pet)
		if (pet and tbl3.RarityRank[tostring(pet.Rarity)] or 0) < labelMap.MinRank then
			return
		end
		local flag3 = type(arg3.Mutation) == "string" and arg3.Mutation ~= ""
		if labelMap.MutatedOnly and not flag3 then
			return
		end
		fn41(fn43(arg3))
	end

	local function fn45(arg3)
		local n20 = tonumber(arg3) or 0
		if n20 >= 1000000 then
			return string.format("%.2fM KG", n20 / 1000000)
		end

		if n20 >= 1000 then
			return string.format("%.1fK KG", n20 / 1000)
		end
		return string.format("%.2f KG", n20)
	end

	local n1722 = bit32.bxor(n172, 294990933)

	local function fn46(arg3)
		local num = tonumber(arg3)
		if not num then
			return nil
		end
		local petAging = tbl3.PetAging

		if type(petAging) == "table" and type(petAging.InflateEggWeight) == "function" then
			local ok, result = pcall(petAging.InflateEggWeight, num)
			if ok and tonumber(result) then
				return tonumber(result)
			end
		end

		return num
	end

	local function fn47(arg3)
		local n20 = 1197844971
		local n21 = 1751173504
		local str3 = tostring(arg3.Egg or "Egg")
		local str32 = tbl3.EggRarity(str3)
		local parts = { "**" .. str3 .. "**  -  " .. str32 }
		local n22 = n20 + n21
		local v28 = fn46(arg3.Weight)

		if v28 then
			parts[#parts + 1] = "**Weight:** " .. fn45(v28)
		end

		local mutation = arg3.Mutation

		if type(mutation) == "string" and mutation ~= "" then
			local n23 = #parts + 1
			local stringFormat = string.format
			local v29 = tostring
			local floor = math.floor
			local mutation2 = tbl3.MutationBonus(mutation)
			local n212 = bit32.band(n21, n22)
			parts[n23] = stringFormat("**Mutation:** %s (x%s)", mutation, v29(floor(mutation2 * 100 + 0.5) / 100))
			n21 = n212 + 1075873920
		else
			parts[#parts + 1] = "**Mutation:** None"
		end

		local tbl5 = { username = "Chilli Hub" }
		local embeds = {}
		local tbl6 = { title = "Egg Stolen!" }
		bit32.bxor(n21, n22)
		tbl6.description = table.concat(parts, "\n")
		tbl6.color = fn39(tbl3.RarityColors and tbl3.RarityColors[str32])
		tbl6.footer = { text = "Chilli Hub  -  Ride A Pet  -  " .. localPlayer.Name }
		tbl6.timestamp = DateTime.now():ToIsoDate()
		embeds[1] = tbl6
		tbl5.embeds = embeds
		return tbl5
	end

	local function fn48(arg3)
		if not labelMap.Stolen or not fn38() then
			return
		end
		local eggMinRank = labelMap.EggMinRank
		if tbl3.EggRank(tostring(arg3.Egg)) < eggMinRank then
			return
		end
		fn41(fn47(arg3))
	end

	local function fn49()
		local now = os.clock()

		for i = #labelMap.Removed, 1, -1 do
			if now - labelMap.Removed[i].At > 6 then
				table.remove(labelMap.Removed, i)
			end
		end

		for i = #labelMap.Gained, 1, -1 do
			if now - labelMap.Gained[i].At > 6 then
				table.remove(labelMap.Gained, i)
			end
		end

		local n20 = 1

		while n20 <= #labelMap.Gained do
			local v28 = labelMap.Gained[n20]
			local i = nil

			for i2, v29 in ipairs(labelMap.Removed) do
				if v29.Egg == v28.Egg then
					i = i2
					break
				else
					i = nil
				end
			end

			if not i and #labelMap.Removed == 1 and #labelMap.Gained == 1 then
				i = 1
			end

			if i then
				local removed = table.remove(labelMap.Removed, i)
				table.remove(labelMap.Gained, n20)

				fn48({
					Egg = removed.Egg or v28.Egg,
					Weight = v28.Weight or removed.Weight,
					Mutation = v28.Mutation or removed.Mutation,
				})
			else
				n20 += 1
			end
		end
	end

	local function fn50(arg3)
		local attribute = arg3:GetAttribute("Egg") or arg3:GetAttribute("EggName")
		if type(attribute) == "string" and attribute ~= "" then
			return attribute
		end
		return (string.gsub(arg3.Name, "%s*[%[%(].*$", ""))
	end

	local function isTool(arg3)
		return arg3:IsA("Tool") and arg3:GetAttribute("PetName") == nil and (arg3:GetAttribute("EggInventoryId") ~= nil or tbl3.EggData(fn50(arg3)) ~= nil)
	end

	local n17222 = bit32.bxor(n1722, 0)
	local n1522 = table.pack(bit32.band(n152, 4294967295))
	local n172222 = table.pack(bit32.band(n17222, 4294967295))
	local v28 = table.pack(bit32.band(n1522[1], 65535))
	local v29 = table.pack(bit32.rshift(n1522[1], 16))
	local v30 = table.pack(bit32.band(n172222[1], 65535))
	bit32.band(v28[1] * v30[1] + bit32.lshift(bit32.band(v28[1] * bit32.rshift(n172222[1], 16) + v29[1] * v30[1], 65535), 16), 4294967295)

	local function isTool2(arg3)
		return arg3:IsA("Tool") and type(arg3:GetAttribute("PetName")) == "string"
	end

	local function fn51(arg3)
		local n20 = 238703589
		if not arg3 then
			return
		end
		local v31 = ipairs
		local n202 = table.pack(bit32.band(n20, 4294967295))
		local v35 = table.pack(bit32.band(n202[1], 65535))
		local n21 = bit32.band(62333 * v35[1] + bit32.lshift(bit32.band(62333 * bit32.rshift(n202[1], 16) + 3298 * v35[1], 65535), 16), 4294967295) + 1815506609
		local n203 = table.pack(bit32.band(bit32.bor(n20, 248735301), 4294967295))
		local v36 = table.pack(bit32.band(n203[1], 65535))
		local v37 = bit32.band(6406 * v36[1] + bit32.lshift(bit32.band(6406 * bit32.rshift(n203[1], 16) + 58938 * v36[1], 65535), 16), 4294967295)
		local n204 = table.pack(bit32.band(bit32.bxor(n20, 248735301), 4294967295))
		local v38 = table.pack(bit32.band(n204[1], 65535))
		local n22 = n21 + v37 + bit32.band(62334 * v38[1] + bit32.lshift(bit32.band(62334 * bit32.rshift(n204[1], 16) + 3298 * v38[1], 65535), 16), 4294967295)

		for _, child in v31(arg3:GetChildren()) do
			if child:IsA("Tool") then
				labelMap.Seen[child] = true
			end
		end

		local connection = arg3.ChildAdded:Connect(function(child)
			local n222 = bit32.bxor(n22, 93276738)
			local n23 = 2231203622

			if isTool(child) and not labelMap.Seen[child] then
				labelMap.Seen[child] = true

				table.insert(labelMap.Gained, {
					Egg = fn50(child),
					Weight = child:GetAttribute("Weight"),
					Mutation = child:GetAttribute("Mutation"),
					At = os.clock(),
				})

				local fn492 = fn49
				bit32.bxor(n23, n222)
				fn492()
				return
			end

			if not isTool2(child) or labelMap.Seen[child] then
				return
			end
			labelMap.Seen[child] = true
			local now = os.clock()

			for i, v39 in ipairs(labelMap.Pending) do
				if now - v39.At < 5 and (v39.Pet == nil or v39.Pet == child:GetAttribute("PetName")) then
					table.remove(labelMap.Pending, i)
					v39.Done = true

					fn44({
						Pet = child:GetAttribute("PetName"),
						Mutation = child:GetAttribute("Mutation") or v39.Mutation,
						Weight = child:GetAttribute("Weight"),
						Chance = v39.Chance,
						Egg = v39.Egg,
					})

					return
				end
			end
		end)

		fn6(function()
			local n23 = 284670731

			pcall(function()
				connection:Disconnect()
			end)
		end)
	end

	fn51(localPlayer:FindFirstChildOfClass("Backpack"))

	local connection = localPlayer.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			fn51(child)
		end
	end)

	fn6(function()
		local n20 = 308757433

		pcall(function()
			connection:Disconnect()
		end)
	end)

	local function fn52(arg3)
		local flag3 = type(0) ~= "number"
		local n20 = 417658305
		if not arg3 then
			return
		end
		local n21 = n20 + 208906228

		local connection2 = arg3.ChildRemoved:Connect(function(child)
			local attribute = child:GetAttribute("Egg")
			local num = tonumber(child:GetAttribute("BreakAt"))
			if type(attribute) ~= "string" or num and workspace:GetServerTimeNow() >= num then
				return
			end

			table.insert(labelMap.Removed, {
				Egg = attribute,
				Weight = child:GetAttribute("Weight"),
				Mutation = child:GetAttribute("Mutation"),
				At = os.clock(),
			})

			fn49()
		end)

		fn6(function()
			local n22 = 13054431027

			pcall(function()
				connection2:Disconnect()
			end)
		end)
	end

	fn52(localPlayer:FindFirstChild("Basket"))

	local connection2 = localPlayer.ChildAdded:Connect(function(child)
		if child.Name == "Basket" then
			fn52(child)
		end
	end)

	fn6(function()
		local n20 = 575595596

		pcall(function()
			connection2:Disconnect()
		end)
	end)

	local hatch = game_:FindFirstChild("Hatch")
	local isRemoteEvent

	if hatch then
		isRemoteEvent = hatch:IsA("RemoteEvent")
		bit32.bxor(bit32.bxor(n1722, 506419496), 506419496)
	else
		isRemoteEvent = hatch
	end

	if isRemoteEvent then
		local connection3 = hatch.OnClientEvent:Connect(function(arg3)
			local n20 = 332951733
			type(332951733)
			local n21 = 1429045223
			local n22 = 663336378
			if type(arg3) ~= "table" then
				return
			end
			local petName = arg3.PetName or arg3.Pet or arg3.Name
			local tbl5 = {}
			local now = os.clock()
			tbl5.At = now
			tbl5.Pet = type(petName) == "string" and petName or nil
			local n222 = n22
			tbl5.Chance = arg3.Chance
			tbl5.Mutation = type(arg3.Mutation) == "string" and arg3.Mutation or nil
			local v31 = type
			local eggName = arg3.EggName
			local v35 = table.pack(bit32.band(bit32.band(78267403, n20), 4294967295))
			local v36 = table.pack(bit32.band(v35[1], 65535))
			local n23 = n20 + 78267403 + bit32.band(65534 * v36[1] + bit32.lshift(bit32.band(65534 * bit32.rshift(v35[1], 16) + 65535 * v36[1], 65535), 16), 4294967295)
			local now2 = table.pack(bit32.band(now, 4294967295))
			local v37 = table.pack(bit32.band(now2[1], 65535))
			local v38 = bit32.band(37479 * v37[1] + bit32.lshift(bit32.band(37479 * bit32.rshift(now2[1], 16) + 27078 * v37[1], 65535), 16), 4294967295)
			local now3 = table.pack(bit32.band(bit32.bnot(now), 4294967295))
			local v39 = table.pack(bit32.band(now3[1], 65535))
			local n24 = n23 + 1774621287 + v38 + bit32.band(37479 * v39[1] + bit32.lshift(bit32.band(37479 * bit32.rshift(now3[1], 16) + 27078 * v39[1], 65535), 16), 4294967295)
			local eggName2 = v31(eggName) == "string" and arg3.EggName
			local eggName3

			if eggName2 then
				eggName3 = eggName2
			else
				eggName3 = type(arg3.Egg) == "string" and arg3.Egg

				if not eggName3 then
					bit32.bxor(bit32.lshift(n21, 21), 2848817127)
					eggName3 = nil
				end
			end

			tbl5.Egg = eggName3
			tbl5.Done = false
			table.insert(labelMap.Pending, tbl5)
			local n2222 = bit32.bxor(n222, 3290956937)
			local n242 = bit32.bxor(n24, 338852641)

			task.delay(5, function()
				local pos = table.find(labelMap.Pending, tbl5)

				if pos then
					table.remove(labelMap.Pending, pos)
				end

				if not tbl5.Done and tbl5.Pet then
					tbl5.Done = true
					fn44({ Pet = tbl5.Pet, Mutation = tbl5.Mutation, Chance = tbl5.Chance, Egg = tbl5.Egg })
				end
			end)
		end)

		local fn62 = fn6
		local n192 = bit32.bxor(n19, 1964261842)

		fn62(function()
			local n20 = 995432859

			pcall(function()
				connection3:Disconnect()
			end)
		end)
	end

	fn6(function()
		labelMap.Disposed = true
	end)

	local function fn53(arg3)
		local input = labelMap.Input
		local v31 = type
		if v31(input) ~= "table" then
			return
		end

		for _, v35 in ipairs({ "Set", "SetValue" }) do
			local n20 = 130495681

			if v31(labelMap) == "vector" then
				bit32.bxor(n20, 2078363509)
			end

			local v36 = pcall
			local n202 = table.pack(bit32.band(n20, 4294967295))
			local v37 = table.pack(bit32.band(n202[1], 65535))
			local n21 = bit32.band(60229 * v37[1] + bit32.lshift(bit32.band(60229 * bit32.rshift(n202[1], 16) + 17907 * v37[1], 65535), 16), 4294967295) + 156860888
			local n203 = table.pack(bit32.band(bit32.bor(n20, 242559992), 4294967295))
			local v38 = table.pack(bit32.band(n203[1], 65535))
			local v39 = bit32.band(5308 * v38[1] + bit32.lshift(bit32.band(5308 * bit32.rshift(n203[1], 16) + 47628 * v38[1], 65535), 16), 4294967295)
			local n204 = table.pack(bit32.band(bit32.band(n20, 242559992), 4294967295))
			local v40 = table.pack(bit32.band(n204[1], 65535))
			local n22 = n21 + v39 + bit32.band(5306 * v40[1] + bit32.lshift(bit32.band(5306 * bit32.rshift(n204[1], 16) + 47628 * v40[1], 65535), 16), 4294967295)

			local v41, v42 = v36(function()
				return input[v35]
			end)

			if v41 and type(v42) == "function" and pcall(v42, input, arg3, false) then
				return
			end
		end
	end

	labelMap.Input = webhookSection:CreateInput({
		Name = "Webhook URL",
		Placeholder = "https://discord.com/api/webhooks/...",
		Default = labelMap.Saved,
		MaxLength = 256,
		Callback = function(arg3)
			local url = string.gsub(tostring(arg3 or ""), "%s", "")
			local flag3 = url == "" and labelMap.Saved ~= ""

			if flag3 then
				local loadedAt = labelMap.LoadedAt
				flag3 = os.clock() - loadedAt < 5
			end

			if flag3 then
				labelMap.Url = labelMap.Saved
				task.defer(fn53, labelMap.Saved)
				return
			end

			labelMap.Url = url
			local str3 = ""

			if (url == "" or fn37(url)) and url ~= labelMap.Saved and type(writefile) == "function" then
				local n20 = 730420231

				pcall(function()
					if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder("ChilliLibrary") then
						makefolder("ChilliLibrary")
					end

					writefile(labelMap.Path, url)
					labelMap.Saved = url
				end)
			end
		end,
	})

	local createToggle = webhookSection.CreateToggle
	local options = { Name = "Ping @everyone", Default = false }

	local function callback(arg3)
		labelMap.PingEveryone = arg3 == true
	end

	type("__mode")
	options.Callback = callback
	createToggle(webhookSection, options)

	webhookSection:CreateToggle({
		Name = "Notify Stolen Eggs",
		Default = false,
		Callback = function(arg3)
			labelMap.Stolen = arg3 == true
		end,
	})

	webhookSection:CreateDropdown({
		Name = "Webhook Min Egg Rarity",
		Options = tbl3.RarityChoices,
		Default = tbl3.RarityChoices[1],
		Callback = function(arg3)
			labelMap.EggMinRank = tbl3.RarityRank[arg3] or 0
		end,
	})

	webhookSection:CreateToggle({
		Name = "Notify Hatched Pets",
		Default = false,
		Callback = function(arg3)
			labelMap.Hatched = arg3 == true
		end,
	})

	webhookSection:CreateDropdown({
		Name = "Webhook Min Pet Rarity",
		Options = tbl3.RarityChoices,
		Default = tbl3.RarityChoices[1],
		Callback = function(arg3)
			labelMap.MinRank = tbl3.RarityRank[arg3] or 0
		end,
	})

	webhookSection:CreateToggle({
		Name = "Mutated Pets Only",
		Default = false,
		Callback = function(arg3)
			labelMap.MutatedOnly = arg3 == true
		end,
	})

	webhookSection:CreateButton({
		Name = "Send Test Message",
		ButtonText = "Send",
		Callback = function()
			if not fn38() then
				fn9("Webhook", "Paste a valid Discord webhook URL first.")
				return
			end

			fn41({
				username = "Chilli Hub",
				embeds = {
					{
						title = "Webhook connected",
						description = "Stolen eggs and hatched pets will be posted here.",
						color = 5793266,
						footer = { text = "Chilli Hub  -  Ride A Pet  -  " .. localPlayer.Name },
					},
				},
			})

			fn9("Webhook", "Test message sent.")
		end,
	})
end

fn36(131798437, 369236035)

local function fn37()
	local B = bit32.bxor(240403323, 0)
	local q
	local v42 = v4
	local L, cJK4bs2mgTUrl, K, assetId, x, G, g, f, T, y, t, l, O, F, W, _, N, b, m, p = v42:CreateTab({Name = "Discord", Side = "Right", SectionsExpanded = true}):CreateSection({Name = "Community", Expanded = true}), "https://discord.gg/CJK4bs2mgT", "discord.gg/CJK4bs2mgT", "rbxassetid://128961717706452", "130K+", 0.5, 0.0909, 0.2, 5.4, 4.2, 5.2, 6, 3.6, 6.4, 2, 11.4, 3, 0.35, {{Color = "#FF6A55", Title = "New Scripts &amp; Updates", Text = "Patch notes and new game scripts are posted there first."}, {Color = "#FFB054", Title = "Giveaways", Text = "Member giveaways and events are announced in the server."}, {Color = "#9AA3FF", Title = "Support", Text = "Ask for help, report bugs and get answers from the team."}, {Color = "#6EE49C", Title = "Suggestions", Text = "Request features and vote on what gets added next."}}
	p, B = _ + (#m * (N + b)), u32Trunc((u32Mul(4294967295, B) + 2639902192) + (u32Mul(2, (bit32.bor(414058244, B))) + (3544224893 + 1991749263)))
	local n12, colorSequenceNew, P, new = (p + 2.4) + (f * 2)
	colorSequenceNew, P, new, B = ColorSequence.new, {}, ColorSequenceKeypoint.new, bit32.bxor(B, 204801759)

	do
		local _vals = table.pack(new(0, Color3.fromRGB(255, 218, 96)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 152, 60)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 82, 64)))
		table.move(_vals, 1, _vals.n, 1, P)
	end

	local v23 = colorSequenceNew(P)
	local colorSequence, options, r = ColorSequence.new(Color3.fromRGB(74, 24, 18), Color3.fromRGB(14, 11, 15)), {Perks = {}}, 0

	local function c()
		local w = bit32.bxor(527439445, 0)
		local Y = w
		local i
		i, w = setclipboard, u32Trunc(Y + 79187201)
		Y = i or toclipboard
		local ok, J = ((type(Y) == "function") and pcall(Y, cJK4bs2mgTUrl)) or false
		fn9((ok and "Discord Link Copied") or "Discord Link", cJK4bs2mgTUrl)
		if not options.Copy then
			return
		end
		r += 1
		local A = r
		options.Copy.Set({Text = (ok and "<b>Copied!</b>") or "<b>See Notice</b>", Background = (ok and "#2EB070") or "#5865F2"})
		w = u32Trunc(w + 171218021)

		task.delay(1.8, function()
			local copy = (A == r) and options.Copy

			if copy then
				options.Copy.Set({Text = "<b>Copy Link</b>", Background = "#5865F2"})
			end
		end)
	end

	local function A(arg)
		if not options.Hero then
			return
		end
		local w = math.max(arg, 14) - (f * 2)
		local Y, i, J = math.max(1, (w - t) - G), math.max(1, (w - F) - (G * 3)), math.max(1, w - 1.2)
		options.Hero.Set({Width = w})
		options.Title.Set({Width = Y})
		options.Subtitle.Set({Width = Y})
		options.Members.Set({Width = Y})
		options.Invite.Set({Width = w})
		options.Label.Set({Width = i})
		options.Link.Set({Width = i})
		i, arg = options.Copy.Set, {}
		arg.X = (w - F) - G
		i(arg)
		options.Header.Set({Width = w})

		for _, perk in ipairs(options.Perks) do
			perk.Frame.Set({Width = w})
			perk.Title.Set({Width = J})
			perk.Text.Set({Width = J})
		end

		options.Tip.Set({Width = w})
	end

	local function fn38(w)
		local options2 = bit32.bxor(271005797, 0)
		local options3 = options2
		options.Hero = w:Frame({Name = "Hero", X = f, Y = f, Width = 14, Height = T, Background = "#FFFFFF", Gradient = colorSequence, GradientRotation = 0, Corner = 0.35, StrokeColor = "#FF6A40", StrokeThickness = g, StrokeTransparency = 0.55})
		options.Logo = w:Image({Parent = options.Hero, X = 0.5, Y = (T - y) / 2, Width = y, Height = y, Image = assetId})
		options2 = bit32.bxor(options3, 221875186)
		options.Title = w:Text({Parent = options.Hero, X = t, Y = 0.45, Width = 1, Height = 1.6, Scale = 1.45, Wrap = false, Text = "<b>Chilli Hub</b>", Gradient = v23, GradientRotation = 0, TextStrokeTransparency = 1})
		options2 = bit32.bxor(options2, 205688402)
		options.Subtitle = w:Text({Parent = options.Hero, X = t, Y = 2.1, Width = 1, Height = 1, Wrap = false, Text = "Official Discord Community", Color = "#DCDCE8"})
		options.Members = w:Text({Parent = options.Hero, X = t, Y = 3.3, Width = 1, Height = 1.2, Wrap = false, Text = string.format("<font color=\"#6EE49C\">%s</font>  <b>%s</b>  <font color=\"#B8B8CC\">Members</font>", utf8.char(9679), x)})
		options.Invite = w:Frame({Name = "Invite", X = f, Y = l + f, Width = 14, Height = O, Background = "#000000", BackgroundTransparency = 0.5, Corner = 0.35, StrokeColor = "#5865F2", StrokeThickness = g, StrokeTransparency = 0.35})
		options.Label = w:Text({Parent = options.Invite, X = G + 0.1, Y = 0.35, Width = 1, Height = 0.9, Scale = 0.78, Wrap = false, Text = "<b>INVITE LINK</b>", Color = "#9C9CB4"})
		options.Link = w:Text({Parent = options.Invite, X = G + 0.1, Y = 1.35, Width = 1, Height = 1.6, Scale = 1.05, Wrap = false, Font = "code", Text = K})
		local options4, v24 = {Parent = options.Invite, X = (14 - F) - G, Y = (O - W) / 2, Width = F, Height = W, Text = "<b>Copy Link</b>", Color = "#FFFFFF", Scale = 1, Background = "#5865F2", BackgroundTransparency = 0, HoverTransparency = 0.15, PressTransparency = 0.3, StrokeColor = "#9AA3FF", StrokeThickness = g, Corner = 0.3, Callback = c}
		v24, options2 = w:Button(options4), bit32.bxor(options2, 192804053)
		options.Copy = v24
		options.Header = w:Text({X = f + 0.1, Y = (_ - 1.15) + f, Width = 14, Height = 1, Scale = 0.8, Wrap = false, Text = "<b>WHAT YOU GET</b>", Color = "#9C9CB4"})

		for i, v25 in ipairs(m) do
			options3 = {Frame = w:Frame({Name = "Perk", X = f, Y = (_ + ((i - 1) * (N + b))) + f, Width = 14, Height = N, Background = "#000000", BackgroundTransparency = 0.68, Corner = 0.35})}
			options3.Accent = w:Frame({Parent = options3.Frame, X = 0.3, Y = 0.45, Width = 0.22, Height = N - 0.9, Background = v25.Color, Corner = 0.11})
			options3.Title = w:Text({Parent = options3.Frame, X = 0.85, Y = 0.3, Width = 1, Height = 1.1, Wrap = false, Text = "<b>" .. (v25.Title .. "</b>"), Color = v25.Color})
			options3.Text = w:Text({Parent = options3.Frame, X = 0.85, Y = 1.35, Width = 1, Height = 1.5, Scale = 0.86, Wrap = true, Text = v25.Text, Color = "#C8C8D8"})
			options.Perks[i] = options3
		end

		options4, options3 = {X = f + 0.1, Y = (n12 - 2.2) - f, Width = 14, Height = 2, Scale = 0.8, Wrap = true, Text = "Paste the copied link into your browser or the Discord app to join.", Color = "#8A8AA2"}
		options3, options2 = w:Text(options4), u32Trunc((u32Mul(1352265815, options2) + 1799441676) + (u32Mul(1590435666, (bit32.band(57459668, options2))) + u32Mul(2942701482, (bit32.bxor(options2, 57459668)))))
		options.Tip = options3
		w:SetContentLines(n12)

		local function fn39(_, arg, V)
			A(arg / math.max(V, 1))
		end

		w:OnResize(fn39)
		A(w:Width() / math.max(w:Unit(), 1))
	end

	p = type(L.CreateCanvas) == "function"

	if p then
		local v24 = bit32.bxor(512449889, 0)
		local v25 = L:CreateCanvas({Name = "Discord", ShowTitle = false, Layout = "free", Style = {TextScale = 0.84, LineHeight = 1.1, MinLines = math.ceil(n12), MaxLines = math.ceil(n12), BackgroundTransparency = 0.5, ScrollBarColor = Color3.fromRGB(170, 174, 184), TextColor = Color3.fromRGB(255, 255, 255), TextStrokeTransparency = 0.7}, Build = fn38})
		v24 = u32Trunc(v24 + 300298943)
		local v26, fn62
		fn62, v24 = fn6, u32Trunc(v24 + 162026237)

		fn62(function()
			v25:Destroy()
		end)
	else
		L:CreateText({Name = "Discord", Text = cJK4bs2mgTUrl})
	end

	if type(L.CreateButton) == "function" then
		L:CreateButton({Name = "Copy Discord Link", Callback = c})
	end
end

fn37()

local function fn38()
	local B, assetId, V, x, G = bit32.bxor(119371802, 0), "rbxassetid://128961717706452", 56, 0.035, 8
	local tweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfoNew, T
	tweenInfoNew, T, B = TweenInfo.new, Enum, u32Trunc(B + 423333668)
	local y = tweenInfoNew(0.14, T.EasingStyle.Back, Enum.EasingDirection.Out)
	local TweenService, connections, screenGui, uiScale, uiScale2 = game:GetService("TweenService"), {}
	B = u32Trunc(B - 105945184)

	local function fn39()
		local F, nameList = ipairs, {"Toggle", "Open"}

		for k, v23 in F(nameList) do
			local v24 = bit32.bxor(216851027, 0)
			k = v24
			local v42
			v42, v24 = pcall, u32Trunc(k + 400883912)
			local v25

			local v26, b = v42(function()
				local v43 = v4
				return v43[v23]
			end)

			k = v26 and (type(b) == "function")

			if k then
				v42 = v4
				pcall(b, v42)
				return
			end
		end
	end

	local function L()
		local uiScale3 = uiScale
		if not uiScale3 then
			return
		end
		uiScale3 = workspace.CurrentCamera
		local viewportSize = (uiScale3 and uiScale3.ViewportSize) or Vector2.new(1280, 720)
		viewportSize = if viewportSize.X < 1 then Vector2.new(1280, 720) else viewportSize
		uiScale3 = uiScale
		uiScale3.Scale = math.clamp((viewportSize.X * x) / V, 0.7, 1.4)
	end

	local function fn40()
		for i, connection in ipairs(connections) do
			local _ = bit32.bxor(1649003, 0)
			i = nil
			i, _ = pcall, u32Trunc(_ + 424865530)

			i(function()
				connection:Disconnect()
			end)
		end

		table.clear(connections)
		local screenGui2 = screenGui

		if screenGui2 then
			local F = bit32.bxor(1482725, 0)
			local W = F
			local _
			_, F = pcall, u32Trunc((u32Mul(325046191, W) + 1483564179) + (u32Mul(3644874914, (bit32.bor(W, 527085149))) + u32Mul(325046192, (bit32.bxor(W, 527085149)))))

			_(function()
				screenGui:Destroy()
			end)
		end

		screenGui, uiScale, uiScale2 = nil, nil, nil
	end

	local function F()
		local W = bit32.bxor(390863694, 0)
		local uiScale3 = W
		fn40()
		screenGui = Instance.new("ScreenGui")
		local N, screenGui2, fn52
		screenGui2, fn52, W = screenGui, fn5, u32Trunc((u32Mul(657062711, uiScale3) + 4215315786) + (u32Mul(3637904586, (bit32.bor(uiScale3, 331486726))) + u32Mul(3637904584, (bit32.band(uiScale3, 331486726)))))
		screenGui2.Name = fn52()
		screenGui.Archivable = false
		screenGui.DisplayOrder = 59
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		fn52 = screenGui
		fn52.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		local frame = Instance.new("Frame")
		frame.Name = fn5()
		frame.AnchorPoint = Vector2.new(0, 0.5)
		frame.Position = UDim2.new(0, 16, 0.3, 0)
		frame.Size = UDim2.fromOffset(V, V)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Parent = screenGui
		uiScale = Instance.new("UIScale")
		uiScale3 = uiScale
		uiScale3.Name = fn5()
		uiScale.Parent = frame
		L()
		fn52 = Instance.new("ImageButton")
		fn52.Name = fn5()
		fn52.AnchorPoint = Vector2.new(0.5, 0.5)
		fn52.Position = UDim2.fromScale(0.5, 0.5)
		fn52.Size = UDim2.fromScale(1, 1)
		fn52.BackgroundTransparency = 1
		fn52.BorderSizePixel = 0
		fn52.AutoButtonColor = false
		fn52.Image = assetId
		fn52.ScaleType = Enum.ScaleType.Fit
		fn52.Active = true
		fn52.Parent = frame
		uiScale2 = Instance.new("UIScale")
		uiScale3 = uiScale2
		uiScale3.Name = fn5()
		uiScale2.Parent = fn52
		screenGui2 = Instance.new("UICorner")
		screenGui2.Name = fn5()
		screenGui2.CornerRadius = UDim.new(0.28, 0)
		screenGui2.Parent = fn52

		local function A(K, arg)
			local uiScale4 = uiScale2

			if uiScale4 then
				TweenService:Create(uiScale2, arg, {Scale = K}):Play()
			end
		end

		local function K(arg)
			local absoluteSize, absoluteSize2 = screenGui.AbsoluteSize, frame.AbsoluteSize
			if (absoluteSize.X <= 0) or (absoluteSize.Y <= 0) then
				return arg
			end
			local O, n12 = arg.X.Offset + (arg.X.Scale * absoluteSize.X), arg.Y.Offset + (arg.Y.Scale * absoluteSize.Y)
			O, n12 = math.clamp(O, 0, math.max(0, absoluteSize.X - absoluteSize2.X)), math.clamp(n12, absoluteSize2.Y * 0.5, math.max(absoluteSize2.Y * 0.5, absoluteSize.Y - (absoluteSize2.Y * 0.5)))
			return UDim2.fromOffset(O, n12)
		end

		local str3, vector2, position
		local O, flag3 = false, false

		local function m(p, o)
			local str32 = str3
			if str32 == "mouse" then
				return p.UserInputType == ((o and Enum.UserInputType.MouseMovement) or Enum.UserInputType.MouseButton1)
			end
			str32 = str3
			return p == str32
		end

		uiScale3, screenGui2 = #connections + 1, fn52.InputBegan

		local function p(o)
			local P, r = o.UserInputType == Enum.UserInputType.MouseButton1, o.UserInputType == Enum.UserInputType.Touch
			local str32 = ((not P and not r) or (o.UserInputState ~= Enum.UserInputState.Begin)) or str3
			if str32 then
				return
			end
			str3 = (r and o) or "mouse"
			vector2 = Vector2.new(o.Position.X, o.Position.Y)
			position, O, flag3 = frame.Position, false, false
			A(0.9, tweenInfo)
		end

		connections[uiScale3] = screenGui2:Connect(p)
		local g, UserInputService2

		UserInputService2, connections[#connections + 1] = UserInputService, UserInputService.InputChanged:Connect(function(input)
			local flag4 = not str3 or not m(input, true)
			if flag4 then
				return
			end
			local n12, flag5 = Vector2.new(input.Position.X, input.Position.Y) - vector2, not O

			if flag5 then
				if n12.Magnitude < G then
					return
				end
				O, flag3 = true, true
				A(1, y)
			end

			frame.Position = K(UDim2.new(position.X.Scale, position.X.Offset + n12.X, position.Y.Scale, position.Y.Offset + n12.Y))
		end)

		UserInputService2 = nil

		UserInputService2, connections[#connections + 1] = UserInputService, UserInputService.InputEnded:Connect(function(input)
			local str32 = str3 and m(input, false)

			if str32 then
				str3, O = nil, false
				A(1, y)
			end
		end)

		connections[#connections + 1] = fn52.Activated:Connect(function()
			local flag32 = flag3
			if flag32 then
				flag3 = false
				return
			end
			fn39()
		end)

		UserInputService2 = workspace.CurrentCamera

		if UserInputService2 then
			connections[#connections + 1] = UserInputService2:GetPropertyChangedSignal("ViewportSize"):Connect(L)
		end

		local I
		fn52 = v9
		screenGui.Parent = fn52
	end

	F()
	local I
	fn6(fn40)
end

fn38()
v:Finalize({ Window = v4, MainTab = defaultTab, ShowMainTab = true })

local function fn39()
	local B = os.clock() + 10

	while os.clock() < B do
		task.wait(0.25)
		local v23
		local tbl22, flag3, Z = tbl2, type(tbl2.AutoHopActive) == "function"

		if flag3 then
			local tbl23 = tbl2
			Z = tbl23.AutoHopActive() == true
		else
			Z = flag3
		end

		flag3 = tbl2
		local autoHopTab = flag3.AutoHopTab
		flag3 = Z and autoHopTab

		if flag3 then
			local v24 = bit32.bxor(225835207, 0)
			local v25, q, h = pcall, u32Mul(2203733962, v24) + 3999462962

			v24, h = u32Trunc(q + (u32Mul(4182466668, (bit32.band(531000101, v24))) + u32Mul(2091233335, (bit32.bxor(v24, 531000101))))), not v25(function()
				autoHopTab:Select()
			end)

			if h then
				local v26 = bit32.bxor(266876968, 0)
				v25 = nil
				v25, v26 = pcall, u32Trunc(v26 + 119131883)

				v25(function()
					local I
					local v42 = v4
					v42:SelectTab(autoHopTab)
				end)
			end

			return
		end
	end
end

task.spawn(fn39)
