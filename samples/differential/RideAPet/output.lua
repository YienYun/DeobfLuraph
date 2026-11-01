local function u32Trunc(argument)
	argument %= 4294967296
	return if argument == argument then argument // 1 else 0
end

local function u32Mul(argument, argument2)
	argument, argument2 = bit32.band(argument, 4294967295), bit32.band(argument2, 4294967295)
	return bit32.band(bit32.band(argument, 65535) * argument2 + bit32.lshift(bit32.rshift(argument, 16) * bit32.band(argument2, 65535), 16), 4294967295)
end

local number = 1268974647
local number2 = 684062543
task.spawn(pcall, function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/DiscordLink"))()
end)

local function compileChunk()
	local value = loadstring
	local response = game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli%20Library")
	local value2, value3 = value(response)
	assert(value2, value3)
	local value4 = value2()
	assert(type(value4) == "function", "Chilli Library bootstrap is invalid.")
	local list = table.create(45)
	local number3 = 1
	for i = 1, 90, 2 do
		list[number3] = string.char(bit32.bxor(tonumber(string.sub("306908100841206d474f00185f26635b2101387507010810127d7d477a473b6f435a0916573165562900226c00", i, i + 1), 16), string.byte("s9K!2vQ#", (number3 - 1) % 8 + 1)))
		number3 += 1
	end
	return value4(table.concat(list))
end

local uiLibrary = compileChunk(488023178, 180544471)
local value = assert
local condition = type(uiLibrary) == "table" and type(uiLibrary.CreateWindow) == "function"

if condition then
	local value = type
	local finalize = uiLibrary.Finalize
	local number3 = bit32.band(number2, 4294967295)
	local number4 = bit32.band(number, 4294967295)
	local number5 = bit32.band(number3, 65535)
	local number6 = bit32.rshift(number3, 16)
	local number7 = bit32.band(number4, 65535)
	local value2 = bit32.band(number5 * number7 + bit32.lshift(bit32.band(number5 * bit32.rshift(number4, 16) + number6 * number7, 65535), 16), 4294967295)
	condition = value(finalize) == "function"
	number2 = value2 + 2987628886
	number = number + 3798223773 + 496743523
end

value(condition, "Chilli Library returned an invalid API.")
uiLibrary.ManualQuickDefaults = {
	PinnedFeatures = { "Farm > Auto Collect Eggs > Auto Collect Eggs", "Player > Movement > Speed Boost" },
	Keybinds = {},
	PinGroups = {},
	LeftCenterHidden = true,
}
local mainWindow = uiLibrary:CreateWindow({ Name = "Chilli Hub - Ride A Pet", DefaultTab = "Farm" })
local defaultTab = mainWindow:GetDefaultTab()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local localPlayer = Players.LocalPlayer
local game_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Game")
local activeEggs = ReplicatedStorage:WaitForChild("ServerData"):WaitForChild("ActiveEggs")

local function callback(argument)
	local value2 = bit32.bxor(444954721, 0)
	local value
	value, value2 = pcall, u32Trunc((u32Mul(1115083310, value2) + 3588422128) + (u32Mul(3179883987, (bit32.bor(value2, 44799432))) + u32Mul(3179883985, (bit32.band(value2, 44799432)))))
	local value3, value4 = value(function()
		return require(argument())
	end)
	return (value3 and value4) or nil
end

local function callback2()
	local ReplicatedStorage = ReplicatedStorage
	return ReplicatedStorage.GameData.Rebirths
end

local data = {
	Eggs = callback(function()
		local ReplicatedStorage = ReplicatedStorage
		return ReplicatedStorage.GameData.Eggs
	end),
	Pets = callback(function()
		local ReplicatedStorage = ReplicatedStorage
		return ReplicatedStorage.GameData.Pets
	end),
	Foods = callback(function()
		local ReplicatedStorage = ReplicatedStorage
		return ReplicatedStorage.GameData.Foods
	end),
	Shop = callback(function()
		local ReplicatedStorage = ReplicatedStorage
		return ReplicatedStorage.GameData.Shop
	end),
	Rebirths = callback(callback2),
	EggBaskets = callback(function()
		local ReplicatedStorage = ReplicatedStorage
		return ReplicatedStorage.GameData.EggBaskets
	end),
	Mutations = callback(function()
		local ReplicatedStorage = ReplicatedStorage
		return ReplicatedStorage.GameData.Mutations
	end),
}

local function callback3()
	if typeof(gethui) == "function" then
		local ok, response = pcall(gethui)
		if ok and (typeof(response) == "Instance") then
			return response
		end
	end
	local CoreGui = CoreGui
	return CoreGui
end

local value2 = callback3()
local rng = Random.new()
local text = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

local function generateRandomId()
	local rng2 = rng
	local randInt = rng2:NextInteger(12, 20)
	rng2 = table.create(randInt)

	for i = 1, randInt, 1 do
		local rng = rng
		local value3
		local text2 = text
		local randInt2 = rng:NextInteger(1, #text2)
		rng = nil
		rng, rng2[i] = text, string.sub(text, randInt2, randInt2)
	end

	return table.concat(rng2)
end

local arguments = {}
local function registerItem(argument)
	table.insert(arguments, argument)
end
local text2 = "All"

local function callback4(argument)
	local value3 = bit32.bxor(135623784, 0)
	if type(argument) ~= "table" then
		return argument
	end
	local value4 = rawget(argument, "Instance")
	local valueType = typeof(value4)
	value3 = bit32.bxor(value3, 279606389)
	if valueType ~= "Instance" then
		return argument
	end
	local condition2 = false
	local callback5
	value3 = u32Trunc((u32Mul(69228956, value3) + 663714168) + (u32Mul(4156509384, (bit32.bor(value3, 493037554))) + u32Mul(69228957, (bit32.bxor(value3, 493037554)))))

	callback5 = function(argument2)
		local condition = condition2
		if condition then
			return
		end
		condition = argument2.Text == "None"
		if condition then
			condition2 = true
			local text = text2
			argument2.Text = text
			condition2 = false
		end
	end

	local function callback6(descendant)
		local value5 = bit32.bxor(147847961, 0)
		local value = value5
		local isTextLabel
		isTextLabel, value5 = descendant:IsA("TextLabel"), u32Trunc(value + 342306451)
		if not isTextLabel or (descendant.Name ~= "Value") then
			return
		end
		callback5(descendant)
		isTextLabel = nil
		isTextLabel, value5 = descendant:GetPropertyChangedSignal("Text"), u32Trunc(value5 - 37534379)
		local connection = isTextLabel:Connect(function()
			callback5(descendant)
		end)

		registerItem(function()
			local value6 = bit32.bxor(195796890, 0)
			local value
			value, value6 = pcall, u32Trunc((u32Mul(878397957, value6) + 1493368641) + (u32Mul(2538171382, (bit32.bor(value6, 465230093))) + u32Mul(878397958, (bit32.bxor(value6, 465230093)))))
			value(function()
				connection:Disconnect()
			end)
		end)
	end

	for _, descendant in ipairs(value4:GetDescendants()) do
		callback6(descendant)
	end
	local connection = value4.DescendantAdded:Connect(callback6)

	registerItem(function()
		local value5 = bit32.bxor(122548727, 0)
		local value
		value, value5 = pcall, u32Trunc((u32Mul(404622966, value5) + 1023862950) + (u32Mul(3485721364, (bit32.bor(value5, 298706377))) + u32Mul(404622967, (bit32.bxor(value5, 298706377)))))
		value(function()
			connection:Disconnect()
		end)
	end)

	return argument
end

local function callback5()
	local value3 = bit32.bxor(390969618, 0)
	local valueType, chilliHubRapCleanup
	valueType, chilliHubRapCleanup, value3 = typeof, getgenv, u32Trunc(value3 + 406729415)
	local genv = ((valueType(chilliHubRapCleanup) == "function") and getgenv()) or _G
	chilliHubRapCleanup = genv.ChilliHubRapCleanup
	valueType = type(chilliHubRapCleanup)
	value3 = u32Trunc(value3 + 54301051)
	if valueType == "function" then
		pcall(chilliHubRapCleanup)
	end

	genv.ChilliHubRapCleanup = function()
		local arguments2 = arguments
		local number3 = #arguments2
		for i = number3, 1, -1 do
			pcall(arguments[i])
		end
		table.clear(arguments)
	end
end

callback5()
local function callback6(argument, argument2)
	local uiLibrary2, condition2 = uiLibrary, type(uiLibrary.Notify) == "function"
	if condition2 then
		pcall(uiLibrary.Notify, argument, argument2, 5)
	end
end

local data2 = { Toggle = function(argument, argument2)
	local value3 = bit32.bxor(488224972, 0)
	local value
	value, value3 = type, u32Trunc(value3 + 338916698)
	if value(argument) ~= "table" then
		return argument2 == true
	end
	local ok, response = pcall(function()
		local controller = argument._controller
		return ((type(controller) == "table") and (type(controller.GetValue) == "function")) and controller.GetValue()
	end)
	if ok and (type(response) == "boolean") then
		return response
	end
	response = {"Get", "GetValue"}

	for i, value4 in ipairs(response) do
		local value5 = bit32.bxor(24450925, 0)
		ok = nil
		ok, value5 = pcall, u32Trunc((u32Mul(849248436, value5) + 1435284360) + (u32Mul(2596470424, (bit32.bor(value5, 178285482))) + u32Mul(849248437, (bit32.bxor(value5, 178285482)))))
		i, value = ok(function()
			return argument[value4]
		end)
		if i and (type(value) == "function") then
			local ok2, response2 = pcall(value, argument)
			if ok2 and (type(response2) == "boolean") then
				return response2
			end
		end
	end

	return argument2 == true
end }

local function callback7(argument)
	local kMap = {}

	if type(argument) == "table" then
		for k, value3 in pairs(argument) do
			if (value3 == true) and (type(k) == "string") then
				kMap[k] = true
			elseif type(value3) == "string" then
				kMap[value3] = true
			end
		end
	end

	return kMap
end

local data3 = {}

local function callback8()
	local value3, nameList, value4 = bit32.bxor(45689446, 0), {"Common", "Rare", "Epic", "Legendary", "Mythic", "Divine", "Ethereal"}
	local data2 = data3
	data2.RarityOrder = nameList
	data2 = data3
	data2.RarityRank = {}
	data2 = ipairs
	for k, value5 in data2(nameList) do
		local data = data3
		data.RarityRank[value5] = k
	end
	data2 = data3
	data2.RarityChoices = {"Any"}
	data2 = ipairs
	for _, value5 in data2(nameList) do
		table.insert(data3.RarityChoices, value5)
	end
	local data4, rarityColors, color3FromRGB = data3, {Common = Color3.fromRGB(214, 218, 228), Rare = Color3.fromRGB(96, 170, 255)}
	color3FromRGB, value3 = Color3.fromRGB, u32Trunc(value3 + 385745893)
	rarityColors.Epic = color3FromRGB(190, 110, 255)
	rarityColors.Legendary = Color3.fromRGB(255, 196, 66)
	rarityColors.Mythic = Color3.fromRGB(255, 82, 90)
	rarityColors.Divine = Color3.fromRGB(255, 240, 150)
	rarityColors.Ethereal = Color3.fromRGB(125, 225, 255)
	data4.RarityColors = rarityColors
	nameList = data3
	nameList.FlySpeed = 1000
	nameList = data3
	nameList.Status = "Idle"
	data2 = data3
	data2.Movement = {Owner = nil}
	local value5
	local data5 = data3
	data5.Character = function()
		local localPlayer = localPlayer
		return localPlayer.Character
	end
	local data5 = data3

	data5.Humanoid = function()
		local localPlayer = localPlayer
		local character = localPlayer.Character
		localPlayer = character and (character:FindFirstChildOfClass("Humanoid"))
		if localPlayer and (localPlayer.Health > 0) then
			return localPlayer
		end
		return nil
	end

	local data5 = data3

	data5.Root = function()
		local localPlayer = localPlayer
		local character = localPlayer.Character
		localPlayer = character and (character:FindFirstChild("HumanoidRootPart"))
		if localPlayer and localPlayer:IsDescendantOf(workspace) then
			return localPlayer
		end
		return nil
	end

	color3FromRGB = nil

	color3FromRGB, data3.Plot = data3, function()
		local parent = value5 and value5.Parent
		local value6

		if parent then
			local data6 = value5:FindFirstChild("Data")
			local owner = data6 and (data6:FindFirstChild("Owner"))
			local _
			if owner then
				data6 = nil
				data6, _ = localPlayer, owner.Value == localPlayer
			else
				_ = owner
			end
			if _ then
				owner = value5
				return owner
			end
		end

		value5 = nil
		parent = workspace:FindFirstChild("Plots")
		if not parent then
			return nil
		end
		local value, children = ipairs, table.pack(parent:GetChildren())

		for k, value7 in value(table.unpack(children, 1, children.n)) do
			parent = value7:FindFirstChild("Data")
			local owner = parent and (parent:FindFirstChild("Owner"))
			local condition2
			if owner then
				k = nil
				k, condition2 = localPlayer, owner.Value == localPlayer
			else
				condition2 = owner
			end
			if condition2 then
				value5 = value7
				return value7
			end
		end

		return nil
	end

	local data5 = data3

	data5.PlotBase = function()
		local data = data3
		local value6 = data.Plot()
		data = value6 and (value6:FindFirstChild("Baseplate"))
		if data and (data:IsA("BasePart")) then
			return data
		end
		return nil
	end

	local data5 = data3

	data5.PlotTop = function()
		local data = data3
		local value6 = data.PlotBase()
		if not value6 then
			return nil
		end
		return value6.Position + Vector3.new(0, value6.Size.Y / 2, 0)
	end

	data4 = nil

	data4, data3.RandomPlotPoint = data3, function(argument, argument2, argument3)
		local data = data3
		local value6 = data.PlotBase()
		if not value6 then
			return nil
		end
		local number3, number4, number5, vector = math.max(1, (value6.Size.X / 2) - argument), math.max(1, (value6.Size.Z / 2) - argument), value6.Position.Y + (value6.Size.Y / 2)

		for i = 1, 24, 1 do
			data, i, argument = rng, rng, Vector3.new(rng:NextNumber(-number3, number3), 0, rng:NextNumber(-number4, number4))
			local value7 = value6.CFrame:PointToWorldSpace(argument)
			local vector2, condition2 = Vector3.new(value7.X, number5, value7.Z), true

			if argument2 then
				for _, value8 in ipairs(argument2) do
					if Vector3.new(value8.X - vector2.X, 0, value8.Z - vector2.Z).Magnitude < argument3 then
						condition2 = false
						break
					end
				end
			end

			if condition2 then
				return vector2
			end
			vector = vector or vector2
		end

		return vector
	end

	local data5 = data3
	data5.Cash = function()
		local localPlayer = localPlayer
		local savedData = localPlayer:FindFirstChild("SavedData")
		localPlayer = savedData and (savedData:FindFirstChild("Cash"))
		return (localPlayer and tonumber(localPlayer.Value)) or 0
	end
	nameList = nil
	nameList, data3.Saved = data3, function(argument)
		local localPlayer = localPlayer
		local savedData = localPlayer:FindFirstChild("SavedData")
		localPlayer = savedData and (savedData:FindFirstChild(argument))
		return (localPlayer and localPlayer.Value) or nil
	end
	color3FromRGB = nil

	color3FromRGB, data3.Fire = data3, function(argument, ...)
		local pack = bit32.bxor(349617676, 0)
		local pack2 = pack
		local game_ = game_
		local value6 = game_:FindFirstChild(argument)
		pack = bit32.bxor(pack2, 456345114)
		if not value6 or not value6:IsA("RemoteEvent") then
			return false
		end
		pack2 = nil
		pack2, pack = table.pack, u32Trunc((u32Mul(1255102848, pack) + 2471830272) + (u32Mul(3039864449, (bit32.bor(pack, 419778466))) + u32Mul(3039864447, (bit32.band(pack, 419778466)))))
		local value7 = pack2(...)
		return pcall(function()
			value6:FireServer(table.unpack(value7, 1, value7.n))
		end)
	end

	data4 = nil
	data4, data3.EggData = data3, function(argument)
		local data = data
		local eggs = data.Eggs
		data = ((type(eggs) == "table") and eggs[tostring(argument)]) or nil
		return ((type(data) == "table") and data) or nil
	end
	data2 = nil

	data2, data3.EggRank = data3, function(argument)
		local data = data3
		local argument2 = data.EggData(argument)
		data = nil
		if argument2 then
			argument = data3
			data = argument.RarityRank[tostring(argument2.Rarity)]
		else
			data = argument2
		end
		return data or 0
	end

	color3FromRGB = nil
	color3FromRGB, data3.EggRarity = data3, function(argument)
		local data = data3
		local argument2 = data.EggData(argument)
		return (argument2 and tostring(argument2.Rarity)) or "Common"
	end
	color3FromRGB = nil
	color3FromRGB, data3.EggLuck = data3, function(argument)
		local data = data3
		local argument2 = data.EggData(argument)
		return (argument2 and tonumber(argument2.Luck)) or 0
	end
	local data5 = data3
	local value6
	data5.PetAging = callback(function()
		local ReplicatedStorage = ReplicatedStorage
		return ReplicatedStorage.GameServices.PetAging
	end)
	data5 = nil

	data5, data3.EggWeightText = data3, function(argument)
		argument = tonumber(argument) or 0
		local data = data3
		local petAging = data.PetAging
		local argument2
		if (type(petAging) == "table") and (type(petAging.InflateEggWeight) == "function") then
			local ok, response = pcall(petAging.InflateEggWeight, argument)
			argument2 = if ok and (type(response) == "number") then response else argument
		else
			argument2 = argument
		end
		petAging = {"", "K", "M", "B", "T", "Qa"}
		data = 1
		while (argument2 >= 1000) and (data < #petAging) do
			argument2, data = argument2 / 1000, data + 1
		end
		return string.format("%.2f", math.floor((argument2 * 100) + 0.5) / 100) .. (petAging[data] .. " KG")
	end

	nameList = nil

	nameList, data3.EggShownWeight = data3, function(argument)
		argument = tonumber(argument) or 0
		local data = data3
		local petAging = data.PetAging
		if (type(petAging) == "table") and (type(petAging.InflateEggWeight) == "function") then
			local ok, response = pcall(petAging.InflateEggWeight, argument)
			if ok and (type(response) == "number") then
				return response
			end
		end
		return argument
	end

	rarityColors = data3
	rarityColors.MinEggWeight = 0
	nameList = nil

	nameList, data3.EggHeavyEnough = data3, function(argument, argument2)
		if not (argument2) then
			local data = data3
			argument2 = data.MinEggWeight
		end
		local condition2 = argument2 <= 0
		local condition
		if condition2 then
			condition = condition2
		else
			local data = data3
			condition = data.EggShownWeight(argument) >= argument2
		end
		return condition
	end

	local data6 = data3

	data6.WeightSlider = function(argument, argument2)
		local value7 = bit32.bxor(316391088, 0)
		local value = value7
		local number3, number4 = 1000, 0
		value7 = u32Trunc(value + 200216811)
		local number5 = 7
		value7 = u32Trunc(value7 + 88226854)

		local function roundSigFigs(_)
			if _ <= 0 then
				return 0
			end
			local number6 = 10 ^ (math.floor(math.log10(_)) - 2)
			return math.floor((_ / number6) + 0.5) * number6
		end

		local function clampValue(argument3)
			argument3 = math.clamp(tonumber(argument3) or 0, 0, number3)
			if argument3 <= 0 then
				return 0
			end
			return roundSigFigs(10 ^ (number4 + (((number5 - number4) * argument3) / number3)))
		end

		local function roundSigFigs2(argument3)
			argument3 = tonumber(argument3) or 0
			if argument3 <= 0 then
				return 0
			end
			local number6 = ((math.log10(argument3) - number4) / (number5 - number4)) * number3
			return math.clamp(math.floor((number6 * 100) + 0.5) / 100, 0, number3)
		end

		local function callback9(argument3)
			local stringFormat, text3 = string.format, ((argument3 >= 100) and "%.0f") or (((argument3 >= 10) and "%.1f") or "%.2f")
			local text4 = stringFormat(text3, argument3)
			if string.find(text4, ".", 1, true) then
				text4 = string.gsub(text4, "0+$", "")
				text4 = string.gsub(text4, "%.$", "")
			end
			return text4
		end

		local function callback10(argument3)
			local numVal = clampValue(argument3)

			if numVal <= 0 then
				return "Off"
			elseif numVal < 1000 then
				return callback9(numVal) .. " KG"
			elseif numVal < 1000000 then
				return callback9(numVal / 1000) .. "K KG"
			end

			return callback9(numVal / 1000000) .. "M KG"
		end

		local unitMultipliers = {k = 1000, m = 1000000, b = 1000000000}

		local function callback11(argument3)
			local text3 = string.lower(string.gsub(tostring(argument3 or ""), "[%s,]", ""))
			text3 = string.gsub(text3, "kg$", "")
			if (text3 == "") or (text3 == "off") then
				return 0
			end
			local match, match2 = string.match(text3, "^([%d%.]+)([kmb]?)$")
			match = tonumber(match)
			if not match then
				return nil
			end
			return roundSigFigs2(match * (unitMultipliers[match2] or 1))
		end

		value = {Name = argument2.Name, SubOf = argument2.SubOf, Min = 0, Max = number3, Default = 0, AllowDecimals = true, Increment = 0.01, ValueFormat = callback10, ValueParse = callback11, Callback = function(argument3)
			argument2.OnRaw(clampValue(argument3))
		end}
		return argument:CreateSlider(value), roundSigFigs2
	end

	local data6 = data3

	data6.WeightStep = function(argument)
		argument = tonumber(argument) or 0
		if argument <= 0 then
			return 0
		end
		return math.clamp(math.floor((((math.log10(argument) / 7) * 1000) * 100) + 0.5) / 100, 0, 1000)
	end

	data5 = nil
	data5, data3.EggBreakSeconds = data3, function(argument)
		local data = data3
		local argument2 = data.EggData(argument)
		return (argument2 and tonumber(argument2.BreakSeconds)) or 30
	end
	rarityColors = nil
	rarityColors, data3.PetData = data3, function(argument)
		local data = data
		local pets = data.Pets
		data = ((type(pets) == "table") and pets[tostring(argument)]) or nil
		return ((type(data) == "table") and data) or nil
	end
	nameList = nil
	nameList, data3.MutationBonus = data3, function(argument)
		local data = data
		local mutations = data.Mutations
		data = (((type(mutations) == "table") and argument) and mutations[tostring(argument)]) or nil
		return 1 + ((((type(data) == "table") and tonumber(data.StatMultiplier)) or 0) / 100)
	end
	color3FromRGB = nil
	color3FromRGB, data3.PetScore = data3, function(argument, argument2, argument3)
		local data = data3
		local argument4, data = data.PetData(argument), data3
		return (((argument4 and tonumber(argument4.Income)) or 1) * math.max(tonumber(argument2) or 1, 0.1)) * data.MutationBonus(argument3)
	end
	local data6 = data3

	data6.PetNameOf = function(argument)
		local attribute = argument:GetAttribute("PetName")
		if (type(attribute) == "string") and (attribute ~= "") then
			return attribute
		end
		return (string.gsub(argument.Name, "%s*%[.*$", ""))
	end

	data2 = nil

	data2, data3.Tools = data3, function(argument)
		local list = {}
		local value7
		local localPlayer2 = localPlayer
		local backpack = localPlayer2:FindFirstChildOfClass("Backpack")

		if backpack then
			local value, children = ipairs, table.pack(backpack:GetChildren())

			for k, value8 in value(table.unpack(children, 1, children.n)) do
				localPlayer2 = value8:IsA("Tool")
				k = nil
				if localPlayer2 then
					local CollectionService = CollectionService
					k = (CollectionService:HasTag(value8, argument))
				else
					k = localPlayer2
				end
				if k then
					table.insert(list, value8)
				end
			end
		end

		backpack = localPlayer
		localPlayer2 = backpack.Character

		if localPlayer2 then
			local value, children = ipairs, table.pack(localPlayer2:GetChildren())

			for k, value8 in value(table.unpack(children, 1, children.n)) do
				k = value8:IsA("Tool")
				backpack = nil
				if k then
					local CollectionService = CollectionService
					backpack = (CollectionService:HasTag(value8, argument))
				else
					backpack = k
				end
				if backpack then
					table.insert(list, value8)
				end
			end
		end

		return list
	end

	data4 = nil

	data4, data3.Equip = data3, function(argument)
		local value7 = bit32.bxor(254246885, 0)
		local value = value7
		local data = data3
		value7 = u32Trunc((u32Mul(294739373, value) + 1123098831) + (u32Mul(4000227924, (bit32.bor(value, 7278571))) + u32Mul(4000227922, (bit32.band(value, 7278571)))))
		local value8 = data.Humanoid()
		data = localPlayer
		value = data.Character
		if (not value8 or not argument) or not value then
			return false
		end

		if argument.Parent == value then
			return true
		end
		data = nil
		data, value7 = pcall, bit32.bxor(value7, 173695343)
		data(function()
			value8:EquipTool(argument)
		end)
		data = os.clock() + 1
		while (argument.Parent ~= value) and (os.clock() < data) do
			local RunService = RunService
			RunService.Heartbeat:Wait()
		end
		return argument.Parent == value
	end

	local data6 = data3

	data6.Unequip = function()
		local data = data3
		local value7 = data.Humanoid()

		if value7 then
			local value8 = bit32.bxor(132628291, 0)
			data = value8
			local value
			value, value8 = pcall, u32Trunc((u32Mul(708780522, data) + 1593795892) + (u32Mul(3586186775, (bit32.bor(data, 332341234))) + u32Mul(3586186773, (bit32.band(data, 332341234)))))
			value(function()
				value7:UnequipTools()
			end)
		end
	end

	local data6 = data3
	data6.BasketCount = function()
		local localPlayer = localPlayer
		local basket = localPlayer:FindFirstChild("Basket")
		return (basket and #basket:GetChildren()) or 0
	end
	local data6 = data3

	data6.BasketCapacity = function()
		local data2 = data3
		local EquippedEggBasket = data2.Saved("EquippedEggBasket")
		data2 = data
		local eggBaskets = data2.EggBaskets
		data2 = (((type(eggBaskets) == "table") and EquippedEggBasket) and eggBaskets[tostring(EquippedEggBasket)]) or nil
		eggBaskets = ((type(data2) == "table") and tonumber(data2.Capacity)) or 1
		if (eggBaskets == (1 / 0)) or (eggBaskets > 50) then
			return 50
		end
		return math.max(1, eggBaskets)
	end

	nameList = nil

	nameList, data3.BasketDeadline = data3, function()
		local localPlayer = localPlayer
		local basket = localPlayer:FindFirstChild("Basket")
		localPlayer = nil
		if basket then
			for i, child in ipairs(basket:GetChildren()) do
				i = tonumber(child:GetAttribute("BreakAt"))
				localPlayer = if i and ((localPlayer == nil) or (i < localPlayer)) then i else localPlayer
			end
		end
		return localPlayer
	end

	data4 = nil

	data4, data3.Claim = data3, function(owner)
		local data = data3
		local movement = data.Movement
		if (movement.Owner == nil) or (movement.Owner == owner) then
			movement.Owner = owner
			return true
		end
		return false
	end

	data2 = nil

	data2, data3.Release = data3, function(argument)
		local data = data3
		local condition2 = data.Movement.Owner == argument
		if condition2 then
			argument = data3
			argument.Movement.Owner = nil
		end
	end

	local descendantMap = {}

	local function setNoclip(argument)
		local localPlayer = localPlayer
		local character = localPlayer.Character
		if not character then
			return
		end

		for _, descendant in ipairs(character:GetDescendants()) do
			if descendant:IsA("BasePart") then
				if argument then
					if descendantMap[descendant] == nil then
						descendantMap[descendant] = descendant.CanCollide
					end
					descendant.CanCollide = false
				elseif descendantMap[descendant] ~= nil then
					descendant.CanCollide = descendantMap[descendant]
				end
			end
		end

		if not argument then
			table.clear(descendantMap)
		end
	end

	data4 = data3
	data4.SetNoclip = setNoclip
	nameList = data3
	nameList.CruiseHeight = 250
	data5 = data3
	data5.VolcanoTop = {Center = Vector3.new(-5103, 41405, -3490), Half = Vector2.new(150, 156), BaseY = 40281, BaseRadius = 840}

	local function callback9()
		local volcano = workspace:FindFirstChild("Volcano")
		local volcanoTop = volcano and (volcano:FindFirstChild("VolcanoTop"))
		volcano = volcanoTop and (volcanoTop:IsA("BasePart"))
		if volcano then
			local data = data3
			data.VolcanoTop.Center = volcanoTop.Position
			data = data3
			data.VolcanoTop.Half = Vector2.new(volcanoTop.Size.X / 2, volcanoTop.Size.Z / 2)
		end
		volcanoTop = data3
		return volcanoTop.VolcanoTop
	end

	local data = data3

	data.InVolcanoArea = function(argument)
		local value7 = callback9()
		local vector = Vector3.new(argument.X - value7.Center.X, 0, argument.Z - value7.Center.Z)
		if (argument.Y >= (value7.Center.Y + 20)) or (argument.Y < (value7.BaseY - 40)) then
			return false
		end
		local number3, number4 = math.min(value7.Half.X, value7.Half.Y), math.clamp((argument.Y - value7.BaseY) / math.max(1, value7.Center.Y - value7.BaseY), 0, 1)
		argument = value7.BaseRadius + ((number3 - value7.BaseRadius) * number4)
		return vector.Magnitude < (argument - 30)
	end

	local function callback10(vector, vector2)
		if (Vector3.new(vector2.X - vector.X, 0, vector2.Z - vector.Z).Magnitude < 80) and (math.abs(vector2.Y - vector.Y) < 30) then
			return {vector2}
		end
		local _, number3, data = data3, math.max(vector.Y, vector2.Y) + data3.CruiseHeight, data3
		local vector3 = data.InVolcanoArea(vector)
		data = nil
		if vector3 then
			data = vector3
		else
			local data2 = data3
			data = data2.InVolcanoArea(vector2)
		end
		number3 = if data then math.max(number3, callback9().Center.Y + 60) else number3
		vector3 = (vector + vector2) / 2
		return {Vector3.new(vector3.X, number3, vector3.Z), vector2}
	end

	data5 = nil

	data5, data3.TravelTime = data3, function(argument, argument2)
		local argument3, number3 = argument, 0
		for _, value7 in ipairs(callback10(argument, argument2)) do
			argument3, number3 = value7, number3 + (value7 - argument3).Magnitude
		end
		argument3, argument2 = data3, math.max(data3.FlySpeed, 20)
		return number3 / argument2
	end

	data2 = nil

	data2, data3.FlyTo = data3, function(argument, argument2, argument3)
		local value7, data = bit32.bxor(509903669, 0), data3
		local value8 = data.Root()
		if not value8 or (typeof(argument) ~= "Vector3") then
			return false
		end
		argument3 = argument3 or 3
		if (value8.Position - argument).Magnitude <= argument3 then
			return true
		end
		data = nil
		value7, data = bit32.bxor(value7, 54601621), callback10(value8.Position, argument)
		local data2, number3 = data3, (os.clock() + data3.TravelTime(value8.Position, argument)) + 6
		value7 = bit32.bxor(value7, 73721150)
		setNoclip(true)
		local RunService2 = RunService

		local function callback11()
			local localPlayer = localPlayer
			local character = localPlayer.Character
			if not character then
				return
			end
			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then
					descendant.CanCollide = false
				end
			end
		end

		local connection = RunService2.Stepped:Connect(callback11)
		local callback11_2
		callback11_2, RunService2 = 1, false

		while os.clock() < number3 do
			local value9 = bit32.bxor(403387006, 0)
			if argument2 and (argument2()) then
				break
			end
			local RunService = RunService
			local _, data2 = RunService.Heartbeat:Wait(), data3
			value8 = data2.Root()
			if not value8 then
				break
			end
			data2, RunService = data[callback11_2], callback11_2 == #data
			local number4 = data2 - value8.Position
			data2 = number4.Magnitude
			value9 = u32Trunc((value9 + 3442749056) + (u32Mul(4294967294, (bit32.band(value9, 218548909))) + (326973567 + 743793582)))

			if data2 <= ((RunService and argument3) or 2) then
				if RunService then
					RunService2 = true
					break
				end
				callback11_2 += 1
				continue
			end

			local data, number5 = data3, math.min(data2, math.max(data3.FlySpeed, 20) * _)
			RunService = nil
			RunService, value9 = Vector3.new, bit32.bxor(value9, 158644916)
			data2 = RunService(number4.X, 0, number4.Z)
			local cframe = ((data2.Magnitude > 0.1) and CFrame.lookAt(Vector3.new(0, 0, 0), data2.Unit)) or value8.CFrame.Rotation
			pcall(function()
				value8.CFrame = CFrame.new(value8.Position + (number4.Unit * number5)) * cframe
				value8.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				value8.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)
		end

		connection:Disconnect()
		setNoclip(false)
		data = data3
		value8 = data.Root()
		if value8 then
			pcall(function()
				value8.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			end)
			RunService2 = if (value8.Position - argument).Magnitude <= (argument3 + 1) then true else RunService2
		end
		return RunService2
	end

	rarityColors = nil

	rarityColors, data3.MoveLine = data3, function(argument, argument2, argument3)
		local value7, data = bit32.bxor(81050845, 0), data3
		local value8 = data.Root()
		if not value8 or (typeof(argument) ~= "Vector3") then
			return false
		end
		setNoclip(true)
		data = RunService
		value7 = bit32.bxor(value7, 138891685)
		local stepped
		stepped, value7 = data.Stepped, bit32.bxor(value7, 398319705)

		local connection, position = stepped:Connect(function()
			local localPlayer = localPlayer
			local character = localPlayer.Character
			if not character then
				return
			end
			for _, descendant in ipairs(character:GetDescendants()) do
				if descendant:IsA("BasePart") and descendant.CanCollide then
					descendant.CanCollide = false
				end
			end
		end), value8.Position

		local number3, _, condition2 = math.max(0.05, (argument - position).Magnitude / math.max(tonumber(argument2) or 60, 1)), 0, true

		while _ < number3 do
			local value9 = bit32.bxor(57644833, 0)
			if argument3 and (argument3()) then
				condition2 = false
				break
			end
			stepped = RunService
			value9 = u32Trunc((u32Mul(685186496, value9) + 427108544) + (u32Mul(2924594304, (bit32.bor(value9, 468045877))) + u32Mul(685186497, (bit32.bxor(value9, 468045877)))))
			_ += stepped.Heartbeat:Wait()
			data = data3
			value8 = data.Root()
			value9 = bit32.bxor(value9, 231985077)
			if not value8 then
				condition2 = false
				break
			end
			local value10 = position:Lerp(argument, math.min(1, _ / number3))
			pcall(function()
				value8.CFrame = CFrame.new(value10) * value8.CFrame.Rotation
				value8.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				value8.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end)
		end

		connection:Disconnect()
		setNoclip(false)
		return condition2
	end

	data4 = nil
	data4, data3.NeedsVolcano = data3, function(argument)
		local data = data3
		local argument2 = data.EggData(argument)
		return (argument2 ~= nil) and (argument2.RequiresVolcano == true)
	end
	data5 = data3
	data5.DoorCFrame = CFrame.new(-4939.84, 41284.7, -3679.98, 0.746841, 0.03653, -0.663999, 0.066451, 0.989393, 0.129173, 0.661675, -0.140595, 0.736491)
	local data = data3

	data.VolcanoDoor = function()
		local volcano = workspace:FindFirstChild("Volcano")
		local volcanoEntrance = volcano and (volcano:FindFirstChild("VolcanoEntrance"))
		volcano = volcanoEntrance and (volcanoEntrance:IsA("BasePart"))
		if volcano then
			local data = data3
			data.DoorCFrame = volcanoEntrance.CFrame
		end
		volcanoEntrance = data3
		volcano = volcanoEntrance.DoorCFrame
		volcanoEntrance = Vector3.new(volcano.LookVector.X, 0, volcano.LookVector.Z)
		if volcanoEntrance.Magnitude < 0.01 then
			return nil, nil
		end
		volcanoEntrance = volcanoEntrance.Unit
		return volcano.Position + (volcanoEntrance * 30), volcano.Position - (volcanoEntrance * 40)
	end

	local data = data3
	data.VolcanoHover = function()
		return callback9().Center + Vector3.new(0, 60, 0)
	end
	rarityColors = nil

	rarityColors, data3.VolcanoApproach = data3, function(argument, argument2, argument3)
		local localPlayer2 = localPlayer
		local condition2 = localPlayer2:GetAttribute("InVolcano") ~= true
		local condition
		if condition2 then
			condition = condition2
		else
			localPlayer2 = localPlayer
			condition = localPlayer2:GetAttribute("VolcanoValidated") ~= true
		end

		if condition then
			localPlayer2 = data3
			local data7, value7 = localPlayer2.VolcanoDoor()
			condition2 = not data7
			if condition2 then
				local data = data3
				return data.FlyTo(argument, argument2, argument3)
			end
			local data = data3
			data.Status = "Going to the volcano door"
			data = data3
			if not data.FlyTo(data7, argument2, 4) then
				return false
			end
			data = data3
			data.Status = "Entering the lair through its door"
			data7 = data3
			if not data7.MoveLine(value7, 40, argument2) then
				return false
			end
		end

		condition2 = data3
		condition2.Status = "Going down to the Volcanic Egg"
		condition = data3
		condition.MoveLine(argument, 250, argument2)
		localPlayer2 = data3
		condition2 = localPlayer2.Root()
		return (condition2 ~= nil) and ((condition2.Position - argument).Magnitude <= ((argument3 or 3) + 2))
	end

	data2 = nil

	data2, data3.VolcanoExit = data3, function(argument)
		local data = data3
		local value7, value8 = data.VolcanoDoor()
		if not value7 then
			return false
		end
		data = data3
		data.Status = "Escaping the lair through its door"
		data = data3
		if not data.MoveLine(value8, 250, argument) then
			return false
		end
		data = data3
		if not data.MoveLine(value7, 40, argument) then
			return false
		end
		return true
	end

	local data = data3

	data.FirePrompt = function(argument)
		local value7 = bit32.bxor(148812308, 0)
		local value = value7
		local condition2
		value7, condition2 = u32Trunc(value + 264615771), not argument or not argument:IsA("ProximityPrompt")
		if condition2 then
			return false
		end
		value = nil
		value, value7 = typeof, u32Trunc(value7 - 199952989)
		if value(fireproximityprompt) == "function" then
			return pcall(fireproximityprompt, argument)
		end
		return pcall(function()
			argument:InputHoldBegin()
			task.wait(argument.HoldDuration + 0.1)
			argument:InputHoldEnd()
		end)
	end

	registerItem(function()
		setNoclip(false)
	end)
end

callback8()
local farmStatusSection = defaultTab:CreateSection({ Name = "Farm Status", Expanded = true })
local autoCollectEggsSection = defaultTab:CreateSection({ Name = "Auto Collect Eggs", Expanded = true })
local section = defaultTab:CreateSection({ Name = "Auto Place & Hatch", Expanded = false })
local autoPetsSection = defaultTab:CreateSection({ Name = "Auto Pets", Expanded = false })
local autoShopSection = defaultTab:CreateSection({ Name = "Auto Shop", Expanded = false })
local autoProgressSection = defaultTab:CreateSection({ Name = "Auto Progress", Expanded = false })

local data4 = {
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
	Relaying = false,
	DipOn = false,
	DipMinRank = 0,
}

local function callback9()
	local value3 = bit32.bxor(171821349, 0)
	local farmStatusSection = farmStatusSection
	local value4 = farmStatusSection:CreateText({Name = "Farm Status", Text = "Idle"})
	value3 = u32Trunc(value3 + 459039838)
	local status
	value3 = u32Trunc(value3 - 214111027)
	farmStatusSection = RunService

	local connection = farmStatusSection.Heartbeat:Connect(function()
		local data = data3
		local condition2 = data.Status ~= status

		if condition2 then
			data = data3
			status = data.Status
			local value5 = value4 and (type(value4.Set) == "function")
			if value5 then
				pcall(value4.Set, value4, status)
			end
		end
	end)

	registerItem(function()
		connection:Disconnect()
	end)
end

callback9()
local names = {}

local function callback10()
	local value3, data5, value4, eggs, data2 = bit32.bxor(128622297, 0), {}
	eggs, value3, data2 = type, bit32.bxor(value3, 138507007), data
	data2 = eggs(data.Eggs) == "table"

	if data2 then
		local value, data = pairs, data
		eggs = data.Eggs

		for k, egg in value(eggs) do
			data = type(egg) == "table"

			if data then
				local insert, data6, value5 = table.insert, {Name = k}
				local data = data3
				data6.Rank = data.RarityRank[tostring(egg.Rarity)] or 0
				data6.Luck = tonumber(egg.Luck) or 0
				insert(data5, data6)
			end
		end
	end

	eggs = nil
	eggs, value3 = table, u32Trunc((u32Mul(1381030139, value3) + 4023332417) + (u32Mul(2, (bit32.bor(value3, 271634879))) + (1381030140 + u32Mul(1381030140, (bit32.bnot(value3))))))
	eggs.sort(data5, function(argument, argument2)
		if argument.Rank ~= argument2.Rank then
			return argument.Rank > argument2.Rank
		end
		return argument.Luck > argument2.Luck
	end)
	data2 = ipairs
	for _, value5 in data2(data5) do
		table.insert(names, value5.Name)
	end
end

callback10()

local function callback11()
	local value3, data5 = bit32.bxor(349404453, 0), {}
	value3 = u32Trunc(value3 + 117581611)
	data5[1], data5[2], data5[3], data5[4], data5[5] = "Highest Luck", "Highest Rarity", "Nearest", "Farthest", "Heaviest"
	local number3, data6 = 0, {}
	local text3, nameMap, number4 = data5[2], {}, 3
	value3 = u32Trunc(value3 + 387481868)
	local function callback12(_)
		local localPlayer = localPlayer
		local attribute = localPlayer:GetAttribute("CollectedEggs")
		return ((type(attribute) == "string") and (attribute ~= "")) and (string.find(attribute, tostring(_) .. ",", 1, true) ~= nil)
	end
	local rebirth = {On = false, Min = 10, Need = false, Pet = nil, Done = 0, Cap = 6, Owned = false, Chances = {}, Key = "", Status = "Off"}
	local value4
	local data7 = data4
	data7.Rebirth = rebirth
	local data8 = data4

	data8.RebirthChance = function(argument)
		if not rebirth.On or not rebirth.Need then
			return nil
		end
		local chance = rebirth.Chances[argument]
		if chance and ((chance * 100) >= rebirth.Min) then
			return chance
		end
		return nil
	end

	local data8 = data4
	data8.AutoOn = function()
		local data = data2
		local data, collect = data4, data.Toggle(data4.Collect, false) or (rebirth.On and rebirth.Need)
		return collect
	end
	local callback13, value5

	callback13 = function(argument)
		local value6 = bit32.bxor(33160355, 0)
		local value = value6
		local data9, data = {}, data3
		local value7, now = data.PlotTop(), os.clock()
		data = data2
		local data2, collect, value2, value8 = data4, data.Toggle(data4.Collect, false), ipairs
		data = activeEggs
		local children = table.pack(data:GetChildren())
		value6 = u32Trunc((u32Mul(3300540067, value) + 443633670) + (u32Mul(1988854458, (bit32.bor(value, 172150338))) + u32Mul(3300540068, (bit32.bxor(value, 172150338)))))
		value6 = bit32.bxor(value6, 75847243)

		for k, value9 in value2(table.unpack(children, 1, children.n)) do
			local attribute, attribute2, attribute3, nameEntry = value9:GetAttribute("Egg"), value9:GetAttribute("Position"), value9:GetAttribute("PrivateTo"), nameMap[value9.Name]
			value, k = type(attribute) == "string"
			if value then
				data = data4
				k = data.RebirthChance(attribute)
			else
				k = value
			end
			local attribute4, condition2, k2 = k or nil, (type(attribute) == "string") and (typeof(attribute2) == "Vector3")

			if condition2 then
				k = attribute3 == nil
				if k then
					k2 = k
				else
					local localPlayer = localPlayer
					k2 = attribute3 == localPlayer.UserId
				end
			else
				k2 = condition2
			end

			condition2, k = (k2 and not (nameEntry and (nameEntry > now))) and not callback12(attribute)

			if condition2 then
				if attribute4 then
					k = attribute4
				else
					k2 = data3
					k = k2.EggHeavyEnough(value9:GetAttribute("Weight"))
				end
			else
				k = condition2
			end

			if k then
				nameEntry = data3
				attribute3 = nameEntry.EggRank(attribute)
				k2 = attribute4 or ((collect and (attribute3 >= number3)) and ((next(data6) == nil) or data6[attribute]))

				if k2 then
					condition2 = nil
					if value7 then
						local data = data3
						condition2 = data.TravelTime(attribute2, value7)
					else
						condition2 = value7
					end
					local data = data3
					local condition3 = (condition2 or 0) < ((data.EggBreakSeconds(attribute) - number4) - 2)

					if condition3 then
						local insert, data10, data = table.insert, {Config = value9, Name = attribute, Position = attribute2, Rank = attribute3}, data3
						data10.Luck = data.EggLuck(attribute) * (tonumber(value9:GetAttribute("Weight")) or 1)
						data10.Distance = (attribute2 - argument).Magnitude
						data10.Weight = tonumber(value9:GetAttribute("Weight")) or 0
						data10.Rebirth = attribute4 or 0
						insert(data9, data10)
					end
				end
			end
		end

		table.sort(data9, function(argument2, argument3)
			if argument2.Rebirth ~= argument3.Rebirth then
				return argument2.Rebirth > argument3.Rebirth
			end
			local text = text3
			if text == data5[5] then
				if argument2.Weight ~= argument3.Weight then
					return argument2.Weight > argument3.Weight
				end
				return argument2.Distance < argument3.Distance
			end
			text = text3
			local condition2 = text == data5[3]

			if condition2 then
				return argument2.Distance < argument3.Distance
			else
				text = text3
				local condition3 = text == data5[4]

				if condition3 then
					return argument2.Distance > argument3.Distance
				else
					local text = text3

					if text == data5[2] then
						if argument2.Rank ~= argument3.Rank then
							return argument2.Rank > argument3.Rank
						end

						if argument2.Luck ~= argument3.Luck then
							return argument2.Luck > argument3.Luck
						end
						return argument2.Distance < argument3.Distance
					end
				end
			end

			if argument2.Luck ~= argument3.Luck then
				return argument2.Luck > argument3.Luck
			end
			return argument2.Distance < argument3.Distance
		end)

		return data9
	end

	data7 = nil

	data7, data4.EggMatches = data4, function(argument, argument2, argument3)
		local argument4, argument5, data = argument or number3, argument2 or data6, data3
		local value6, value, value7 = data.PlotTop(), ipairs
		data = activeEggs
		local children, number5, data9 = table.pack(data:GetChildren()), 0

		for k, value8 in value(table.unpack(children, 1, children.n)) do
			argument2, data, argument = value8:GetAttribute("Egg"), value8:GetAttribute("Position"), value8:GetAttribute("PrivateTo")
			local condition2 = (type(argument2) == "string") and (typeof(data) == "Vector3")
			local k2

			if condition2 then
				k = argument == nil
				if k then
					k2 = k
				else
					local localPlayer = localPlayer
					k2 = argument == localPlayer.UserId
				end
			else
				k2 = condition2
			end

			condition2, k = k2 and not callback12(argument2)
			if condition2 then
				k2 = data3
				k = k2.EggHeavyEnough(value8:GetAttribute("Weight"), argument3)
			else
				k = condition2
			end

			if k then
				condition2 = data3
				k2 = condition2.EggRank(argument2)
				local condition3 = (k2 >= argument4) and ((next(argument5) == nil) or argument5[argument2])

				if condition3 then
					local attribute
					if value6 then
						local data2 = data3
						attribute = data2.TravelTime(data, value6)
					else
						attribute = value6
					end
					local data2 = data3
					local condition4 = (attribute or 0) < ((data2.EggBreakSeconds(argument2) - number4) - 2)

					if condition4 then
						number5 += 1
						attribute = not data9 or (k2 > data9.Rank)

						if attribute then
							data2 = data3
							local data10, number6 = data2.Root(), tonumber(value8:GetAttribute("Weight")) or 1
							data9 = {Name = argument2, Rank = k2, Distance = (data10 and (data - data10.Position).Magnitude) or nil, Mutation = value8:GetAttribute("Mutation")}
							data10 = data3
							data9.Luck = data10.EggLuck(argument2) * number6
						end
					end
				end
			end
		end

		return number5, data9
	end

	local number5 = 250

	local function callback14(argument, argument2, argument3)
		local value6, data = bit32.bxor(262670958, 0), data3
		local value7 = data.Root()
		data = localPlayer
		local basket = data:FindFirstChild("Basket")
		if not value7 or not basket then
			return
		end
		data = argument.CFrame:PointToObjectSpace(value7.Position)
		local vector = Vector3.new(data.X, 0, data.Z)
		vector = if vector.Magnitude < 1 then Vector3.new(0, 0, 1) else vector
		local number6, RunService2, unit = argument.Size.X / 2, argument.Size.Z / 2, vector.Unit
		data = unit / math.max(math.abs(unit.X) / (number6 + 20), math.abs(unit.Z) / (RunService2 + 20))
		local vector2 = argument.CFrame:PointToWorldSpace(Vector3.new(data.X, 0, data.Z))
		vector2 = Vector3.new(vector2.X, argument2.Y + 4, vector2.Z)
		argument2 = data3
		argument2.FlyTo(vector2, argument3, 4)
		number6 = data3
		value7 = number6.Root()
		if not value7 or ((value7.Position - vector2).Magnitude > 10) then
			return
		end
		data = data3
		data.Status = "Re-picking eggs near base"
		local number7 = os.clock() + 0.3
		local value8

		while os.clock() < number7 do
			argument3 = data3
			local value9 = argument3.Root()

			if value9 then
				local value10 = bit32.bxor(479750839, 0)
				argument2 = value10
				unit, data = pcall, u32Trunc(number7)
				value10 = u32Trunc((1870089403 + argument2) + (u32Mul(1520699420, data) + u32Mul(1520699420, (bit32.bnot(data)))))
				local function callback15()
					value9.CFrame = CFrame.new(vector2) * value9.CFrame.Rotation
					value9.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				end
				unit(callback15)
			end

			argument = RunService
			argument.Heartbeat:Wait()
		end

		local childMap = {}
		local value9
		number7 = activeEggs
		for _, child in ipairs(number7:GetChildren()) do
			childMap[child] = true
		end
		unit = {}
		value6 = u32Trunc(value6 + 289273399)
		argument = {}
		for _, child in ipairs(basket:GetChildren()) do
			number7 = child:GetAttribute("Egg")
			if type(number7) == "string" then
				table.insert(argument, number7)
			end
		end
		argument3 = data4
		argument3.Relaying = true
		RunService2 = ipairs
		for _, value10 in RunService2(argument) do
			number7 = data3
			number7.Fire("BasketDrop", value10)
		end
		local attributeMap = {}
		for _, value10 in ipairs(argument) do
			attributeMap[value10] = (attributeMap[value10] or 0) + 1
		end

		local function callback15(argument4)
			local attribute = argument4:GetAttribute("Egg")
			if (type(attribute) ~= "string") or ((attributeMap[attribute] or 0) <= 0) then
				return false
			end
			attribute = argument4:GetAttribute("DropFrom")
			attribute = if typeof(attribute) ~= "Vector3" then argument4:GetAttribute("Position") else attribute
			if typeof(attribute) ~= "Vector3" then
				return false
			end
			return Vector3.new(attribute.X - vector2.X, 0, attribute.Z - vector2.Z).Magnitude < 80
		end

		number6 = os.clock() + 3

		while (#unit < #argument) and (os.clock() < number6) do
			basket = activeEggs

			for _, child in ipairs(basket:GetChildren()) do
				if (not childMap[child] and (child:GetAttribute("OriginPosition") ~= nil)) and (typeof(child:GetAttribute("Position")) == "Vector3") then
					childMap[child] = true
					if callback15(child) then
						argument2 = child:GetAttribute("Egg")
						attributeMap[argument2] = attributeMap[argument2] - 1
						table.insert(unit, child)
					end
				end
			end

			RunService2 = RunService
			RunService2.Heartbeat:Wait()
		end

		RunService2 = ipairs

		for k, value10 in RunService2(unit) do
			argument, argument3 = value10:GetAttribute("Position"), data3
			k, childMap = argument3.BasketCount(), os.clock() + 3
			local callback15_2 = 0

			while true do
				basket, number7 = value10.Parent ~= nil
				if basket then
					number6 = data3
					number7 = number6.BasketCount() <= k
				else
					number7 = basket
				end
				if not (number7 and (os.clock() < childMap)) then
					break
				end
				data = data3
				argument2 = data.Root()
				local attribute = ((typeof(argument) == "Vector3") and argument2) and ((argument2.Position - argument).Magnitude > 12)
				if attribute then
					local data = data3
					data.FlyTo(argument + Vector3.new(0, 3, 0), nil, 5)
					callback15_2 = 0
				end
				attribute = os.clock() >= callback15_2

				if attribute then
					callback15_2 = os.clock() + 0.1
					local data = data4
					data.LastPickupAt = os.clock()
					data = data3
					data.Fire("EggPickup", value10.Name)
				end

				attribute = RunService
				attribute.Heartbeat:Wait()
				argument = value10:GetAttribute("Position") or argument
			end

			local condition2 = value10.Parent ~= nil
			local condition3
			if condition2 then
				k = nil
				k, condition3 = data4, not table.find(data4.Manual, value10.Name)
			else
				condition3 = condition2
			end
			if condition3 then
				table.insert(data4.Manual, 1, value10.Name)
			end
		end

		number6 = data4
		number6.Relaying = false
	end

	data7 = nil

	data7, data4.Deliver = data4, function(argument)
		local data = data3
		if data.BasketCount() <= 0 then
			return true
		end
		data = data3
		local data9, data2 = data.PlotTop(), data3
		data = data2.PlotBase()
		if not data9 or not data then
			return false
		end
		data2 = data3
		data2.Status = "Bringing eggs home"
		data2 = data3
		local data10, data5 = data2.Root(), data4
		data2 = data5.PickupPos or (data10 and data10.Position)
		data5 = data2 and ((data2 - data9).Magnitude > number5)
		if data5 then
			callback14(data, data9, argument)
			data10 = data3
			data10.Status = "Bringing eggs home"
		end
		data5 = data3
		data5.FlyTo(data9 + Vector3.new(0, 4, 0), argument, 4)
		data2 = os.clock() + 3

		while true do
			data5 = data3
			if not ((data5.BasketCount() > 0) and (os.clock() < data2)) then
				break
			end
			argument = RunService
			argument.Heartbeat:Wait()
		end

		data9 = data3
		data2 = data9.BasketCount() == 0
		if data2 then
			table.clear(data4.Carried)
			data5 = data4
			data5.PickupPos = nil
		end
		data9 = data3
		return data9.BasketCount() == 0
	end

	local function callback15()
		while true do
			local data = data4
			if not (#data.Manual > 0) then
				break
			end
			local data2 = data4
			local value6
			local activeEggs, value7 = activeEggs, activeEggs:FindFirstChild(data2.Manual[1])
			local attribute, attribute2, attribute3 = value7 and (value7:GetAttribute("Egg")), value7 and (value7:GetAttribute("Position")), value7 and (value7:GetAttribute("PrivateTo"))
			data2, data = (type(attribute) == "string") and (typeof(attribute2) == "Vector3")

			if data2 then
				local condition2 = attribute3 == nil
				if condition2 then
					data = condition2
				else
					local localPlayer = localPlayer
					data = attribute3 == localPlayer.UserId
				end
			else
				data = data2
			end

			if data then
				return {Config = value7, Name = attribute, Position = attribute2, Manual = true}
			end
			table.remove(data4.Manual, 1)
		end

		return nil
	end

	local function callback16(argument)
		local data, pos = data4, table.find(data4.Manual, argument)
		if pos then
			table.remove(data4.Manual, pos)
		end
	end
	data7 = nil

	data7, data4.AutoPlan = data4, function(argument)
		local data = data4
		if not data.AutoOn() then
			return {}
		end
		return callback13(argument)
	end

	local number6 = 130
	local data8

	data8, data4.InstantTo = data4, function(argument)
		local data = data3
		local value6 = data.Root()
		if not value6 then
			return false
		end
		value6.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		value6.CFrame = CFrame.new(argument)
		argument = RunService
		argument.Heartbeat:Wait()
		return true
	end

	data8 = nil

	data8, data4.InstantHome = data4, function()
		local data = data3
		local data9, data2 = data.PlotTop(), data3
		data = data2.Root()
		if not data9 or not data then
			return false
		end
		data2 = data3
		if data2.BasketCount() <= 0 then
			return true
		end
		data2 = data3
		data2.Status = "Bringing eggs home"
		local position, number7, data5 = data.Position, data9.Y - number6, ipairs
		data = {Vector3.new(position.X, number7, position.Z), Vector3.new(data9.X, number7, data9.Z), data9 + Vector3.new(0, 3, 0)}
		for k, value6 in data5(data) do
			k = data4
			if not k.InstantTo(value6) then
				return false
			end
		end
		position = os.clock() + 2

		while true do
			data5 = data3
			if not ((data5.BasketCount() > 0) and (os.clock() < position)) then
				break
			end
			data = RunService
			data.Heartbeat:Wait()
		end

		data9 = data3
		data2 = data9.BasketCount() == 0
		if data2 then
			table.clear(data4.Carried)
			data9 = data4
			data9.PickupPos = nil
		end
		data5 = data3
		return data5.BasketCount() == 0
	end

	data8 = nil

	data8, data4.CollectStep = data4, function(argument)
		local data = data3
		local value6 = data.Root()
		if not value6 then
			return false
		end
		data = data3
		local data9 = data.BasketCapacity()
		data = false

		while true do
			local data2 = data3
			if not (data2.BasketCount() < data9) then
				break
			end
			local data10 = bit32.bxor(94182315, 0)
			data2 = data10
			if argument() then
				break
			end
			local data5 = data3
			local data11, data6 = data5.BasketDeadline(), data3
			data5 = data6.PlotTop()
			data6 = data11 and data5

			if data6 then
				local data = data3
				value6 = data.Root()
				local number7 = data11 - workspace:GetServerTimeNow()
				local position
				if value6 then
					data = data3
					position = data.TravelTime(value6.Position, data5)
				else
					position = value6
				end
				if (number7 - (position or 0)) < (number4 + 4) then
					break
				end
			end

			data6 = data3
			value6 = data6.Root()
			if not value6 then
				break
			end
			local value7 = callback15()
			data5, data11 = not value7
			if data5 then
				data6 = data4
				data11 = data6.AutoOn()
			else
				data11 = data5
			end

			if data11 then
				data6, data5 = ipairs, table.pack(callback13(value6.Position))

				for _, value8 in data6(table.unpack(data5, 1, data5.n)) do
					local data, pos = data4, table.find(data4.Manual, value8.Config.Name)
					if not pos then
						value7 = value8
						break
					end
				end
			end

			data11 = not value7

			if data11 then
				data6 = not data
				if data6 then
					data5 = data3
					data5.Status = "No egg matches the filters"
				end
				break
			end

			local name, data7 = value7.Config.Name, data4
			data7.Target = name
			data6 = data4
			data6.TargetManual = value7.Manual == true
			data6 = data4
			data6.Dropped = nil
			data7 = data3
			data7.Status = string.format("Collecting %s", value7.Name)
			data11 = value7.Position + Vector3.new(0, 3, 0)
			data10 = bit32.bxor(data2, 510026178)
			data7 = data3
			data6, data2, data5 = data7.NeedsVolcano, u32Mul(1348794871, data10) + 734225022
			data10, data5 = u32Trunc(data2 + (u32Mul(2946172426, (bit32.bor(data10, 151773682))) + u32Mul(2946172424, (bit32.band(data10, 151773682))))), data6(value7.Name)
			data6 = nil
			if data5 then
				data7 = data3
				data6 = data7.VolcanoApproach
			else
				data6 = data5
			end
			data7 = nil
			if data6 then
				data7 = data6
			else
				data2 = data3
				data7 = data2.FlyTo
			end
			data2 = data4
			data6, data5 = data2.InstantOn
			if data6 then
				data2 = data3
				data5 = not data2.NeedsVolcano(value7.Name)
			else
				data5 = data6
			end
			if data5 then
				data6 = data4
				data7 = data6.InstantTo
			end

			local function callback17()
				local condition2 = argument() or (value7.Config.Parent == nil)
				local condition
				if condition2 then
					condition = condition2
				else
					local data = data4
					condition = data.Dropped == name
				end
				return condition
			end

			data2, data5 = data7(data11, callback17, 6), data4
			local callback17_2 = data5.Dropped == name

			if callback17_2 then
				data11 = data4
				data11.Target = nil
				data6 = data4
				data6.Dropped = nil
				continue
			end

			data5 = (value7.Config.Parent == nil) and not data2
			if data5 then
				callback16(name)
				data6 = data4
				data6.Target = nil
				continue
			end
			data7 = not data2

			if data7 then
				nameMap[name] = os.clock() + 20
				callback16(name)
				callback17_2 = data4
				callback17_2.Target = nil
				break
			end

			data5 = data3
			data11, callback17_2 = data5.BasketCount(), data4
			callback17_2.LastPickupAt = os.clock()
			data5 = data11 == 0
			if data5 then
				callback17_2 = data4
				callback17_2.PickupPos = value7.Position
			end
			callback17_2, data6 = os.clock() + 1.2, data4
			data7 = (data6.InstantOn and (os.clock() + 0.15)) or 0

			while true do
				data6 = data3
				if not (data6.BasketCount() == data11) then
					break
				end
				data5 = (os.clock() >= data7) and (value7.Config.Parent ~= nil)
				if data5 then
					data2 = nil
					data2, data7 = data4, os.clock() + ((data4.InstantOn and 0.3) or 0.1)
					local data = data3
					data.Fire("EggPickup", name)
				end
				if os.clock() >= callback17_2 then
					if (value7.Config.Parent ~= nil) or (os.clock() >= (callback17_2 + 1.5)) then
						break
					end
				end
				local RunService = RunService
				RunService.Heartbeat:Wait()
			end

			callback16(name)
			data5 = data4
			data5.Target = nil
			data5 = data3
			callback17_2 = data5.BasketCount() > data11

			if callback17_2 then
				data6 = data4
				data6.Carried[name] = value7.Config
				data2 = data3
				data7 = data2.NeedsVolcano(value7.Name)
				if data7 then
					data11 = data3
					data11.VolcanoExit(nil)
				end
				data5 = data4
				local instantOn = data5.InstantOn

				if instantOn then
					local data = data4
					local dipOn = data.DipOn
					if dipOn then
						pcall(data4.VolcanoDip)
					end
					dipOn = data4
					dipOn.InstantHome()
				end

				data = true
			else
				nameMap[name] = os.clock() + 20
			end
		end

		data9 = data4
		data9.Target = nil
		data9 = data3
		local condition2 = data9.BasketCount() > 0
		local dipOn
		if condition2 then
			data9 = data4
			dipOn = data9.DipOn
		else
			dipOn = condition2
		end
		if dipOn then
			pcall(data4.VolcanoDip)
		end
		condition2 = data3
		dipOn, data9 = condition2.BasketCount() > 0
		if dipOn then
			condition2 = data4
			data9 = condition2.InstantOn
		else
			data9 = dipOn
		end
		if data9 then
			condition2 = data4
			condition2.InstantHome()
		end
		data9 = data3
		dipOn = data9.BasketCount() > 0
		if dipOn then
			condition2 = data4
			condition2.Deliver(nil)
		end
		return data
	end

	local function callback17()
		local localPlayer = localPlayer
		local basket = localPlayer:FindFirstChild("Basket")
		if not basket then
			return false
		end
		local value, children = ipairs, table.pack(basket:GetChildren())

		for k, value6 in value(table.unpack(children, 1, children.n)) do
			basket, localPlayer, k = value6:GetAttribute("Egg"), value6:GetAttribute("VolcanoDipped") ~= true

			if localPlayer then
				local data = data3
				local data2
				data2, k = data4, data.EggRank(basket) >= data4.DipMinRank
			else
				k = localPlayer
			end

			if k then
				return true
			end
		end

		return false
	end

	local function callback18()
		local localPlayer = localPlayer
		local basket = localPlayer:FindFirstChild("Basket")
		for _, value6 in ipairs((basket and basket:GetChildren()) or {}) do
			if value6:GetAttribute("VolcanoUntil") ~= nil then
				return true
			end
		end
		return false
	end

	data8 = nil

	data8, data4.VolcanoDip = data4, function()
		local ReplicatedStorage2 = ReplicatedStorage
		local packages = ReplicatedStorage2:FindFirstChild("packages")
		ReplicatedStorage2 = nil
		if packages then
			local ReplicatedStorage = ReplicatedStorage
			ReplicatedStorage2 = ReplicatedStorage.packages:FindFirstChild("Net")
		else
			ReplicatedStorage2 = packages
		end
		local reVolcanoDip, data = ReplicatedStorage2 and (ReplicatedStorage2:FindFirstChild("RE/VolcanoDip")), data3
		local value6, data2 = data.VolcanoHover(), data3
		packages, ReplicatedStorage2 = data2.PlotTop(), data3
		data = ReplicatedStorage2.Root()
		if (((not reVolcanoDip or not value6) or not packages) or not data) or not callback17() then
			return
		end
		data2 = data3
		ReplicatedStorage2 = data2.BasketDeadline()

		if ReplicatedStorage2 then
			data2 = data3
			local _, number7, data = data3, (data2.TravelTime(data.Position, value6) + data3.TravelTime(value6, packages)) + number4, data4
			number7 = if data.InstantOn then number4 + 12 else number7
			if (ReplicatedStorage2 - workspace:GetServerTimeNow()) < number7 then
				return
			end
		end

		ReplicatedStorage2 = data3
		ReplicatedStorage2.Status = "Taking the egg to the volcano"
		packages = data4
		data2, data = packages.InstantOn

		if data2 then
			ReplicatedStorage2 = data4
			data = ReplicatedStorage2.InstantTo(value6)
		else
			packages = data3
			data = packages.FlyTo(value6, nil, 6)
		end

		if not data then
			return
		end

		for i = 1, 4, 1 do
			if not callback17() then
				break
			end
			data = data3
			data.Status = "Dipping the egg into the volcano"
			reVolcanoDip:FireServer()
			packages = os.clock()

			while (os.clock() - packages) < 14 do
				ReplicatedStorage2 = data3
				local value7 = ReplicatedStorage2.Root()

				if value7 then
					local value8 = bit32.bxor(93202263, 0)
					data2 = value8
					local value, value9 = pcall, u32Trunc(i)
					value8 = u32Trunc((3186609987 + data2) + (u32Mul(2904648934, value9) + u32Mul(2904648934, (bit32.bnot(value9)))))
					value(function()
						value7.CFrame = CFrame.new(value6) * value7.CFrame.Rotation
						value7.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
					end)
				end

				local RunService = RunService
				RunService.Heartbeat:Wait()
				if ((os.clock() - packages) > 1) and not callback18() then
					break
				end
			end
		end
	end

	local data9 = data4
	local value6
	data8 = autoCollectEggsSection
	data9.Collect = data8:CreateToggle({Name = "Auto Collect Eggs", Default = false, Callback = function()
		local data = data4
		data.Wake()
	end})
	data7, data8 = data4, autoCollectEggsSection

	data7.InstantHandle = data8:CreateToggle({Name = "Instant Steal", Default = false, Callback = function(argument)
		local data = data4
		data.InstantOn = argument == true
		data, argument = data4, type(data4.Wake) == "function"
		if argument then
			local data = data4
			data.Wake()
		end
	end})

	local data8, autoCollectEggsSection2, options, data10 = data4, autoCollectEggsSection, {Name = "Min Egg Rarity"}, data3
	options.Options = data10.RarityChoices
	data7 = data3
	options.Default = data7.RarityChoices[1]

	options.Callback = function(argument)
		local data = data3
		number3 = data.RarityRank[tostring(argument)] or 0
		argument, data = data4, type(data4.OnCollectFilter) == "function"
		if data then
			pcall(data4.OnCollectFilter)
		end
	end

	data8.CollectRarity = autoCollectEggsSection2:CreateDropdown(options)
	local data10 = data4
	local value7
	local callback, autoCollectEggsSection3, options2, value8 = callback4, autoCollectEggsSection, {Name = "Target Eggs"}
	data7 = names
	options2.Options = data7
	options2.Default = {}

	local function callback19(argument)
		data6 = callback7(argument)
		local data, condition2 = data4, type(data4.OnCollectFilter) == "function"
		if condition2 then
			pcall(data4.OnCollectFilter)
		end
	end

	options2.Callback = callback19
	data10.CollectEggs = callback(autoCollectEggsSection3:CreateMultiDropdown(options2))
	local data11 = data4
	data11.CollectFilters = function()
		local number, data, data2 = number3, data6, data3
		return number, data, data2.MinEggWeight
	end
	data10, callback = data4, data3
	local callback19_2
	autoCollectEggsSection2, data8, callback19_2 = callback.WeightSlider, autoCollectEggsSection, {Name = "Min Egg Weight"}

	local function onRaw(minEggWeight)
		local data = data3
		data.MinEggWeight = minEggWeight
		minEggWeight = data4
		minEggWeight.Wake()
		data, minEggWeight = data4, type(data4.OnCollectFilter) == "function"
		if minEggWeight then
			pcall(data4.OnCollectFilter)
		end
	end

	callback19_2.OnRaw = onRaw
	data10.CollectWeight = autoCollectEggsSection2(data8, callback19_2)
	options2 = autoCollectEggsSection
	options2:CreateDropdown({Name = "Collect Priority", Options = data5, Default = data5[2], Callback = function(argument)
		text3 = tostring(argument)
	end})
	options2 = autoCollectEggsSection
	options2:CreateSlider({Name = "Tween Speed", Min = 100, Max = 1300, Default = 1000, Increment = 25, Callback = function(argument)
		local data = data3
		data.FlySpeed = math.clamp(tonumber(argument) or 1000, 100, 1300)
	end})
	data7 = autoCollectEggsSection
	local value9, autoCollectEggsSection2 = data7:CreateText({Name = "Rebirth Pet Status", Text = "Off"}), autoCollectEggsSection

	rebirth.Handle = autoCollectEggsSection2:CreateToggle({Name = "Steal Rebirth Pet Eggs", Note = "Steals eggs that can hatch the pet your next rebirth needs, until you own it", Default = false, Callback = function(argument)
		local condition2 = type(argument) ~= "boolean"
		if condition2 then
			local data = data2
			argument = data.Toggle(rebirth.Handle, false)
		end
		rebirth.On = argument == true
		local data, condition3 = data4, type(data4.Wake) == "function"
		if condition3 then
			condition2 = data4
			condition2.Wake()
		end
	end})

	callback19_2 = autoCollectEggsSection

	callback19_2:CreateSlider({Name = "Min Rebirth Pet Chance", Min = 1, Max = 100, Default = 10, Increment = 1, Unit = "%", SubOf = rebirth.Handle, Callback = function(argument)
		rebirth.Min = math.clamp(tonumber(argument) or 10, 1, 100)
		local data, condition2 = data4, type(data4.Wake) == "function"
		if condition2 then
			argument = data4
			argument.Wake()
		end
	end})

	local function toNumberOrDefault(argument)
		local number7 = (tonumber(argument) or 0) * 100
		if number7 >= 10 then
			return string.format("%.0f%%", number7)
		elseif number7 >= 0.1 then
			return string.format("%.1f%%", number7)
		end
		return "<0.1%"
	end

	local function callback20(argument)
		local value10 = bit32.bxor(78902203, 0)
		local value = value10
		value10 = u32Trunc((u32Mul(2668866128, value) + 887329360) + (u32Mul(3252202336, (bit32.bor(value, 405617793))) + u32Mul(2668866129, (bit32.bxor(value, 405617793)))))

		local function callback21(argument2)
			if not argument2 then
				return false
			end

			for _, child in ipairs(argument2:GetChildren()) do
				if child:IsA("Tool") and child:GetAttribute("PetKey") then
					if ((string.match(child.Name, "^(.-) %[") or child.Name) == argument) or (child:GetAttribute("PetName") == argument) then
						return true
					end
				end
			end

			return false
		end

		value = localPlayer
		local petMountJoint = callback21(value:FindFirstChildOfClass("Backpack"))
		value = nil
		if petMountJoint then
			value = petMountJoint
		else
			local localPlayer = localPlayer
			value = callback21(localPlayer.Character)
		end
		if value then
			return true
		end
		local callback21_2 = localPlayer
		value = callback21_2.Character
		callback21_2 = value and (value:FindFirstChild("HumanoidRootPart"))
		petMountJoint = callback21_2 and (callback21_2:FindFirstChild("PetMountJoint"))
		value = (petMountJoint and petMountJoint.Part1) and petMountJoint.Part1.Parent
		if value and (value:GetAttribute("PetName") == argument) then
			return true
		end
		value, callback21_2 = pcall(function()
			local localPlayer = localPlayer
			return require(localPlayer:WaitForChild("PlayerScripts", 5).Game.Pets.PetRenderer)
		end)
		petMountJoint = (value and (type(callback21_2) == "table")) and (type(callback21_2.GetAll) == "function")

		if petMountJoint then
			local ok, response = pcall(callback21_2.GetAll)
			value = ok and (type(response) == "table")

			if value then
				ok = pairs

				for k, value11 in ok(response) do
					local condition2 = type(value11) == "table"
					local condition3
					if condition2 then
						k = nil
						k, condition3 = localPlayer, value11.OwnerUserId == localPlayer.UserId
					else
						condition3 = condition2
					end
					if ((condition3 and value11.Model) and value11.Model.Parent) and (value11.Model.Name == argument) then
						return true
					end
				end
			end
		end

		return false
	end

	local function callback21()
		local value10 = bit32.bxor(448787253, 0)
		local key = value10
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local General, Rebirths, HatchLuck = require(ReplicatedStorage2.GameData.General), require(ReplicatedStorage2.GameData.Rebirths), require(ReplicatedStorage2.GameData.HatchLuck)
		local rebirthRequirements, cap, data2, saved, number7, done = ((type(General) == "table") and General.RebirthRequirements) or nil, tonumber, data3, data3.Saved, u32Mul(787199801, key) + 4203681519
		value10, done = u32Trunc(number7 + (u32Mul(3507767496, (bit32.bor(key, 504649575))) + u32Mul(3507767494, (bit32.band(key, 504649575))))), cap(saved("Rebirths")) or 0
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
		rebirth.Owned = callback20(ReplicatedStorage2)
		rebirth.Need = not rebirth.Owned
		local number8, number9 = 1, 1
		pcall(function()
			local value11, localPlayer2, data
			localPlayer2, data, number8 = localPlayer, data3, HatchLuck.GetMultiplier(HatchLuck.EffectiveUpgrades(localPlayer, tonumber(data3.Saved("HatchUpgrades")) or 0))
		end)
		pcall(function()
			number9 = HatchLuck.EventMultiplier()
		end)
		key = string.format("%s|%s|%s", tostring(ReplicatedStorage2), tostring(number8), tostring(number9))
		rebirthRequirements = key ~= rebirth.Key

		if rebirthRequirements then
			local kMap = {}
			local value11
			saved, Rebirths = data, type(data.Eggs) == "table"

			if Rebirths then
				number7, General = pairs, data
				local eggs = General.Eggs

				for k, egg in number7(eggs) do
					local condition2 = (type(egg) == "table") and tonumber(egg.Luck)

					if condition2 then
						local ok, response = pcall(HatchLuck.GetBoostedOdds, math.max((tonumber(egg.Luck) or 1) * (tonumber(number8) or 1), 1), tonumber(number9) or 1, egg)

						if ok and (type(response) == "table") then
							for _, value12 in ipairs(response) do
								if (value12.PetName == ReplicatedStorage2) and ((tonumber(value12.Chance) or 0) > 0) then
									kMap[k] = tonumber(value12.Chance)
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
		local function callback22(argument, argument2)
			return argument.Chance > argument2.Chance
		end
		ReplicatedStorage2(done, callback22)
		key, Rebirths = activeEggs, 0
		for _, child in ipairs(key:GetChildren()) do
			rebirthRequirements = child:GetAttribute("Egg")
			Rebirths = if (type(rebirthRequirements) == "string") and (((rebirth.Chances[rebirthRequirements] or 0) * 100) >= rebirth.Min) then Rebirths + 1 else Rebirths
		end
		cap = {}
		for i = 1, math.min(3, #done), 1 do
			table.insert(cap, done[i].Name .. (" " .. toNumberOrDefault(done[i].Chance)))
		end
		if #cap == 0 then
			rebirth.Status = General .. ("  -  no egg reaches " .. (tostring(rebirth.Min) .. "%"))
		else
			rebirth.Status = string.format("%s  -  %d on the map  |  %s", General, Rebirths, table.concat(cap, ", "))
		end
	end

	task.spawn(function()
		local need

		while (value9 and value9.Instance) and value9.Instance.Parent do
			local value10 = bit32.bxor(364148764, 0)
			local value = value10
			local condition2, condition = false, task
			value10 = bit32.bxor(value, 528774268)
			value10 = u32Trunc((u32Mul(528404438, value10) + 1458693516) + (u32Mul(3238158420, (bit32.bor(value10, 88612050))) + u32Mul(528404439, (bit32.bxor(value10, 88612050)))))
			condition.spawn(function()
				pcall(callback21)
				condition2 = true
			end)
			value = 0

			while true do
				condition = not condition2 and (value < 5)
				if not condition then
					break
				end
				value += task.wait(0.1)
			end

			value = (rebirth.On and rebirth.Status) or ("Off  -  " .. tostring(rebirth.Status))
			if type(value9.Set) == "function" then
				pcall(value9.Set, value9, value)
			end
			value = rebirth.Need ~= need

			if value then
				need = rebirth.Need
				local data, condition3 = data4, type(data4.Wake) == "function"
				if condition3 then
					condition = data4
					condition.Wake()
				end
			end

			task.wait(2)
		end
	end)

	data9, data10 = data4, autoCollectEggsSection

	data9.DipHandle = data10:CreateToggle({Name = "Auto Volcano Dip", Note = "Dips each collected egg into the volcano for a 15% Magma chance, then brings it home", Default = false, Callback = function(argument)
		local condition2 = type(argument) ~= "boolean"
		if condition2 then
			local data = data2
			local data2
			data2, argument = data4, data.Toggle(data4.DipHandle, false)
		end
		condition2 = data4
		condition2.DipOn = argument == true
	end})

	local autoCollectEggsSection, options3, data = autoCollectEggsSection, {Name = "Dip Min Rarity"}, data3
	options3.Options = data.RarityChoices
	data10 = data3
	options3.Default = data10.RarityChoices[1]
	options3.Callback = function(argument)
		local data, data2 = data4, data3
		data.DipMinRank = data2.RarityRank[tostring(argument)] or 0
	end
	autoCollectEggsSection:CreateDropdown(options3)
end

callback11()

local function callback12()
	local value3, number3 = bit32.bxor(471841657, 0), 0
	value3 = u32Trunc(value3 + 130672287)
	local number4, number5, number6 = 0, 0, 5
	value3 = u32Trunc(value3 + 107230796)
	local callback13, value4
	callback13 = function()
		local data = data3
		local value5 = data.Plot()
		data = value5 and (value5:FindFirstChild("Eggs"))
		return (data and data:GetChildren()) or {}
	end

	local function callback14()
		local list = {}

		for i, value5 in ipairs(callback13()) do
			local value6 = bit32.bxor(525138104, 0)
			i = value6
			local value
			value, value6 = pcall, u32Trunc((u32Mul(933686597, i) + 431127863) + (u32Mul(2427594102, (bit32.bor(i, 303936075))) + u32Mul(933686598, (bit32.bxor(i, 303936075)))))
			local value7, value8 = value(function()
				return value5:GetPivot().Position
			end)
			if value7 then
				table.insert(list, value8)
			end
		end

		local data = data3
		local value5 = data.Plot()
		data = value5 and (value5:FindFirstChild("Pets"))

		if data then
			for i, child in ipairs(data:GetChildren()) do
				local value6 = bit32.bxor(122586230, 0)
				i = nil
				i, value6 = pcall, u32Trunc(value6 + 458627896)
				local value7, value8 = i(function()
					return child:GetPivot().Position
				end)
				if value7 then
					table.insert(list, value8)
				end
			end
		end

		return list
	end

	local value5, data

	data, data4.PlantStep = data4, function(argument)
		local value6 = bit32.bxor(363411899, 0)
		local value = value6
		local Egg = os
		value6 = u32Trunc(value + 98591070)
		value6 = u32Trunc(value6 + 141454789)
		value = (Egg.clock() < number4) and (#callback13() >= number5)
		if value then
			return false
		end
		local list, callback, data = {}, ipairs, data3
		Egg = table.pack(data.Tools("Egg"))

		for k, value7 in callback(table.unpack(Egg, 1, Egg.n)) do
			value = data3
			data, k = value.EggRank(value7.Name), number3
			if data >= k then
				table.insert(list, value7)
			end
		end

		if #list == 0 then
			return false
		end
		data, callback = table, function(_, argument2)
			local data, data2 = data3, data3
			return data.EggLuck(_.Name) > data2.EggLuck(argument2.Name)
		end
		data.sort(list, callback)
		callback, data = ipairs, 0

		for k, value7 in callback(list) do
			if argument() then
				break
			end

			if not value7.Parent then
				continue
			end
			k = data3
			value = k.RandomPlotPoint(8, callback14(), number6)
			if not value then
				break
			end
			Egg = data3
			Egg.Status = string.format("Placing %s", value7.Name)
			k = data3
			if not k.Equip(value7) then
				break
			end
			value7, k = #callback13(), data3
			k.Fire("EggPlaced", {PlantPosition = value})
			k = os.clock() + 1.2
			while (os.clock() < k) and (#callback13() == value7) do
				local RunService = RunService
				RunService.Heartbeat:Wait()
			end
			k = #callback13() > value7

			if k then
				data += 1
			else
				number4 = os.clock() + 15
				number5 = #callback13()
				break
			end
		end

		argument = data3
		argument.Unequip()
		return data > 0
	end

	local function callback15()
		local list = {}
		for _, value6 in ipairs(callback13()) do
			local timer, hatch = value6:FindFirstChild("Timer", true), value6:FindFirstChild("Hatch", true)
			if ((((value6:GetAttribute("EggKey") ~= nil) or (hatch and hatch:IsA("ProximityPrompt"))) and timer) and timer:IsA("TextLabel")) and (timer.Text == "Ready") then
				table.insert(list, {Egg = value6, Prompt = hatch})
			end
		end
		return list
	end

	local data5 = data4
	data5.HatchWanted = function()
		local data = data2
		local data, hatch = data4, data.Toggle(data4.Hatch, false) and (#callback15() > 0)
		return hatch
	end
	data = nil

	data, data4.HatchStep = data4, function(argument)
		local value, condition2, number7 = ipairs, table.pack(callback15()), 0

		for k, value6 in value(table.unpack(condition2, 1, condition2.n)) do
			local value7 = bit32.bxor(326305905, 0)
			k = value7
			if argument() then
				break
			end
			local egg, data6 = value6.Egg, u32Trunc(number7)
			local condition3
			value7, condition3 = u32Trunc((2939355868 + k) + (u32Mul(2547927602, data6) + u32Mul(2547927602, (bit32.bnot(data6))))), not egg.Parent
			value7 = u32Trunc(value7 - 251355791)
			if condition3 then
				continue
			end
			egg, k = pcall(function()
				return value6.Egg:GetPivot().Position
			end)

			if egg then
				data6 = data3
				data6.Status = "Hatching eggs"
				condition3 = data3
				local data7 = condition3.Root()
				local RunService2 = not data7 or ((data7.Position - k).Magnitude > 24)
				if RunService2 then
					data7 = data3
					data7.FlyTo(k + Vector3.new(0, 3, 3), argument, 5)
				end
				data7 = value6.Egg:GetAttribute("EggKey")
				RunService2 = game_
				local hatch = RunService2:FindFirstChild("Hatch")
				RunService2 = ((data7 ~= nil) and hatch) and hatch:IsA("RemoteEvent")
				if RunService2 then
					pcall(hatch.FireServer, hatch, {EggKey = data7})
				else
					local data = data3
					data.FirePrompt(value6.Prompt)
				end
				hatch = os.clock() + 2
				while (os.clock() < hatch) and value6.Egg.Parent do
					RunService2 = RunService
					RunService2.Heartbeat:Wait()
				end
				number7 = if not value6.Egg.Parent then number7 + 1 else number7
			end
		end

		condition2 = number7 > 0
		if condition2 then
			task.wait(0.5)
			argument = data3
			argument.Unequip()
		end
		return number7 > 0
	end

	local data2 = data4
	local value6
	data = section
	data2.Plant = data:CreateToggle({Name = "Auto Place Eggs", Default = false, Callback = function()
		number4 = 0
		local data = data4
		data.Wake()
	end})
	local section2, options, data = section, {Name = "Place Min Rarity"}, data3
	options.Options = data.RarityChoices
	data = data3
	options.Default = data.RarityChoices[1]
	options.Callback = function(argument)
		local data = data3
		number3 = data.RarityRank[tostring(argument)] or 0
	end
	section2:CreateDropdown(options)
	section2, data2 = data4, section
	section2.Hatch = data2:CreateToggle({Name = "Auto Hatch Eggs", Default = false, Callback = function()
		local data = data4
		data.Wake()
	end})
end

callback12()

local function callback13()
	local value3, data5, attributeMap, names2, value4 = bit32.bxor(359790178, 0), {}, {}, {}
	local condition, data6, data7 = type, data
	data7, value3 = condition(data.Foods), u32Trunc(value3 + 361439918)
	condition = data7 == "table"

	if condition then
		local data8, data = {}, data

		for k, food in pairs(data.Foods) do
			if type(food) == "table" then
				local insert, _ = table.insert, {Name = k}
				_.Cost = tonumber(food.Cost) or 0
				insert(data8, _)
			end
		end

		table.sort(data8, function(argument, argument2)
			return argument.Cost < argument2.Cost
		end)
		for _, value5 in ipairs(data8) do
			table.insert(names2, value5.Name)
		end
	end

	condition = data4
	condition.FoodChoices = names2
	value3 = u32Trunc(value3 - 213669398)
	local function callback14()
		local data = data3
		local value5 = data.Plot()
		data = value5 and (value5:FindFirstChild("Pets"))
		return (data and data:GetChildren()) or {}
	end

	local function callback15()
		local localPlayer, number3 = localPlayer, tonumber(localPlayer:GetAttribute("MaxPets"))
		local number
		if number3 then
			number = number3
		else
			local value5, data
			data, number = data3, tonumber(data3.Saved("MaxPets"))
		end
		number3 = number or 5
		return math.max(1, number3)
	end

	local function callback16(argument)
		local data = data3
		return data.PetScore(argument:GetAttribute("PetName") or argument.Name, argument:GetAttribute("Weight"), argument:GetAttribute("Mutation"))
	end
	local function callback17(argument)
		local data, data2 = data3, data3
		return data.PetScore(data2.PetNameOf(argument), argument:GetAttribute("Weight"), argument:GetAttribute("Mutation"))
	end

	local function callback18()
		local data, _, value = data3, -1
		for i, value5 in ipairs(data.Tools("Pet")) do
			i = callback17(value5)
			if i > _ then
				_, value = i, value5
			end
		end
		return value, _
	end

	local function callback19()
		local number3 = 1 / 0
		local _
		for i, value5 in ipairs(callback14()) do
			i = callback16(value5)
			if i < number3 then
				number3, _ = i, value5
			end
		end
		return _, number3
	end

	local data6 = data4

	data6.PlaceWanted = function()
		local data = data2
		local _, place = data4, data.Toggle(data4.Place, false)
		if not place then
			return false
		end
		place, data = callback18()
		if not place then
			return false
		end

		if #callback14() < callback15() then
			return true
		end
		local _, value5 = callback19()
		return data > (value5 * 1.05)
	end

	local function callback20(_, argument)
		local attribute = _:GetAttribute("PetKey")
		if not attribute then
			return false
		end
		local data = data3
		local RunService2 = data.PlotTop()
		if RunService2 then
			data = data3
			data.FlyTo(RunService2 + Vector3.new(0, 4, 0), argument, 20)
		end
		data = data3
		if not data.Equip(_) then
			return false
		end
		_ = data3
		RunService2, data, argument = _.RandomPlotPoint(10, nil, 0), #callback14(), data3
		argument.Fire("PlacePet", attribute, RunService2 + Vector3.new(0, 2, 0))
		task.wait(0.35)
		attribute = data3
		attribute.Unequip()
		_ = os.clock() + 1.5
		while (os.clock() < _) and (#callback14() == data) do
			RunService2 = RunService
			RunService2.Heartbeat:Wait()
		end
		return #callback14() > data
	end

	condition = nil

	condition, data4.PlaceStep = data4, function(_)
		local value5, number3 = callback15(), 0

		for i = 1, value5, 1 do
			i = _()
			local i2
			if i then
				i2 = i
			else
				local data = data4
				i2 = not data.PlaceWanted()
			end
			if i2 then
				break
			end
			i = callback18()
			if not i then
				break
			end
			local condition2 = #callback14() >= callback15()
			local value6

			if condition2 then
				i2 = callback19()
				local attribute = i2 and (i2:GetAttribute("PetKey"))
				if not attribute then
					break
				end
				local data = data3
				data.Status = "Swapping in a stronger pet"
				data = data3
				local data8 = data.PlotTop()
				if data8 then
					data = data3
					data.FlyTo(data8 + Vector3.new(0, 4, 0), _, 20)
				end
				data8 = data3
				data8.Fire("PickupPet", attribute)
				data = os.clock() + 1.5
				while (os.clock() < data) and i2.Parent do
					attribute = RunService
					attribute.Heartbeat:Wait()
				end
				if i2.Parent then
					break
				end
			end

			local data = data3
			local data2
			data2, data.Status = data3, string.format("Placing %s", data3.PetNameOf(i))
			if callback20(i, _) then
				number3 += 1
			else
				break
			end
		end

		return number3 > 0
	end

	local function callback21()
		local value = ipairs
		local value5
		local data2 = data3
		local Food, _, value2 = table.pack(data2.Tools("Food")), 1 / 0

		for k, value6 in value(table.unpack(Food, 1, Food.n)) do
			k = value6:FindFirstChild("Amount", true)
			local condition2 = ((k and tonumber(k.Value)) or 1) > 0
			local data3

			if condition2 then
				data2 = next(data5) == nil
				if data2 then
					data3 = data2
				else
					k = data5
					data3 = k[value6.Name]
				end
			else
				data3 = condition2
			end

			if data3 then
				local data2, condition3, food = data, type(data.Foods) == "table"
				if condition3 then
					condition2 = data
					food = condition2.Foods[value6.Name]
				else
					food = condition3
				end
				k = food or nil
				condition3 = ((type(k) == "table") and tonumber(k.Cost)) or 0
				if condition3 < _ then
					_, value2 = condition3, value6
				end
			end
		end

		return value2
	end

	data7 = nil

	data7, data4.FeedWanted = data4, function()
		local data = data2
		local data, condition2 = data4, not data.Toggle(data4.Feed, false) or not callback21()
		if condition2 then
			return false
		end
		condition2 = os.clock()
		for i, value5 in ipairs(callback14()) do
			i = value5:GetAttribute("PetKey")
			if i and ((attributeMap[i] or 0) <= condition2) then
				return true
			end
		end
		return false
	end

	data7 = nil

	data7, data4.FeedStep = data4, function(argument)
		local value5 = bit32.bxor(213638765, 0)
		local data8, attribute = callback14(), table
		value5 = u32Trunc(value5 + 339802599)
		local sort = attribute.sort
		value5 = u32Trunc(value5 - 49540720)
		sort(data8, function(argument2, argument3)
			return callback16(argument2) > callback16(argument3)
		end)
		local value, number3, value6 = ipairs, 0

		for k, _ in value(data8) do
			if argument() then
				break
			end
			attribute, sort = _:GetAttribute("PetKey"), callback21()
			if not sort then
				break
			end
			k = attribute and ((attributeMap[attribute] or 0) <= os.clock())

			if k then
				local value7 = bit32.bxor(265390839, 0)
				local data
				data, value7 = pcall, bit32.bxor(value7, 365364058)
				local value8, value9 = data(function()
					return _:GetPivot().Position
				end)

				if value8 then
					data = data3
					data.Status = string.format("Feeding %s", tostring(_:GetAttribute("PetName") or _.Name))
					local data = data3
					data.FlyTo(value9 + Vector3.new(0, 4, 4), argument, 8)
					data = data3
					local sort2 = data.Equip(sort)

					if sort2 then
						local attribute2, data2 = _:GetAttribute("Age"), data3
						data2.Fire("FeedPet", attribute, sort.Name)
						data2 = os.clock() + 1.2
						while (os.clock() < data2) and (_:GetAttribute("Age") == attribute2) do
							data = RunService
							data.Heartbeat:Wait()
						end
						attributeMap[attribute] = os.clock() + 2
						number3 += 1
					end
				end
			end
		end

		data8 = data3
		data8.Unequip()
		return number3 > 0
	end

	local data = data4
	local value5
	condition = autoPetsSection
	data.Place = condition:CreateToggle({Name = "Auto Place Best Pets", Default = false, Callback = function()
		local data = data4
		data.Wake()
	end})
	data7, condition = data4, autoPetsSection
	data7.Feed = condition:CreateToggle({Name = "Auto Feed Pets", Default = false, Callback = function()
		table.clear(attributeMap)
		local data = data4
		data.Wake()
	end})
	local callback, autoPetsSection, options, data = callback4, autoPetsSection, {Name = "Foods To Use", Options = names2, Default = {}}, data4
	options.SubOf = data.Feed
	local function callback22(argument)
		data5 = callback7(argument)
	end
	options.Callback = callback22
	callback(autoPetsSection:CreateMultiDropdown(options))
end

callback13()

local function callback14()
	local value3, condition2 = bit32.bxor(202120524, 0), false
	value3 = u32Trunc(value3 + 277970236)
	local condition3 = true
	value3 = u32Trunc(value3 + 20516274)
	local data = data4
	data.Wake = function()
		condition2 = true
	end
	local data = data4

	data.CollectActive = function()
		local data = data4
		local value4 = data.AutoOn()
		data = nil
		if value4 then
			data = value4
		else
			local data2 = data4
			data = #data2.Manual > 0
		end
		return data
	end

	local function callback15()
		local data = data3
		local condition4 = data.BasketCount() > 0
		local condition

		if condition4 then
			local data2, condition5 = data4, next(data4.Carried) ~= nil
			if condition5 then
				condition = condition5
			else
				data = nil
				data, condition = data4, (os.clock() - data4.LastPickupAt) < 30
			end
		else
			condition = condition4
		end

		return condition
	end

	local function callback16()
		local data = data4
		local value4 = data.CollectActive() or callback15()
		local value, value5

		if value4 then
			value = value4
		else
			local data = data2
			local data2
			data2, value = data4, data.Toggle(data4.Plant, false)
		end

		data = nil

		if value then
			data = value
		else
			local data2 = data2
			local data3
			data3, data = data4, data2.Toggle(data4.Hatch, false)
		end

		value = nil

		if data then
			value = data
		else
			local data = data2
			local data2
			data2, value = data4, data.Toggle(data4.Place, false)
		end

		data = nil

		if value then
			data = value
		else
			local data2 = data2
			local data3
			data3, data = data4, data2.Toggle(data4.Feed, false)
		end

		return data
	end

	local function callback17()
		local condition4 = not condition3 or not callback16()
		return condition4
	end

	local function callback18(argument)
		local function callback19()
			local value4 = callback17()
			local value
			if value4 then
				value = value4
			else
				local data = data2
				value = not data.Toggle(argument, false)
			end
			return value
		end

		return callback19
	end

	task.spawn(function()
		while true do
			local condition = condition3
			if not condition then
				break
			end
			local condition4 = false
			condition = callback16()
			local value4, condition5
			if condition then
				local data = data3
				condition5 = data.Root()
			else
				condition5 = condition
			end
			condition = nil
			if condition5 then
				local data = data3
				condition = data.Plot()
			else
				condition = condition5
			end

			if condition then
				local value5 = bit32.bxor(338085424, 0)
				condition5 = value5
				local data = data4
				value5 = u32Trunc(condition5 + 527524465)
				data.Busy = true
				value5 = u32Trunc(value5 - 197643128)

				data = not pcall(function()
					local data = data3
					local condition6 = data.BasketCount() > 0

					if condition6 then
						data = data4
						local instantOn = data.InstantOn
						if instantOn then
							local data = data4
							data.InstantHome()
						end
						instantOn = data3
						local condition7 = instantOn.BasketCount() > 0
						if condition7 then
							instantOn = data4
							instantOn.Deliver(callback17)
						end
						condition4 = true
					end

					data = data2
					local data2, plant = data4, data.Toggle(data4.Plant, false) and not callback17()

					if plant then
						data = data4
						local data, value6 = data4, data.PlantStep(callback18(data4.Plant))
						if value6 then
							condition4 = true
						end
					end

					condition6 = data4
					plant = condition6.HatchWanted() and not callback17()

					if plant then
						condition6 = data4
						local data, value6 = data4, condition6.HatchStep(callback18(data4.Hatch))
						if value6 then
							condition4 = true
						end
					end

					condition6 = data4
					data = condition6.PlaceWanted() and not callback17()

					if data then
						plant = data4
						local data, value6 = data4, plant.PlaceStep(callback18(data4.Place))
						if value6 then
							condition4 = true
						end
					end

					condition6 = data4
					plant = condition6.FeedWanted() and not callback17()

					if plant then
						condition6 = data4
						local data, value6 = data4, condition6.FeedStep(callback18(data4.Feed))
						if value6 then
							condition4 = true
						end
					end

					plant = data4
					data = plant.CollectActive() and not callback17()

					if data then
						local data5 = bit32.bxor(162203851, 0)
						condition6 = data5
						plant = data4
						data5 = bit32.bxor(condition6, 226555115)
						local collectStep, number3, value6 = plant.CollectStep, u32Mul(1051214039, data5) + 3469102831

						data5, value6 = u32Trunc(number3 + (u32Mul(3243753258, (bit32.bor(data5, 279668649))) + u32Mul(3243753256, (bit32.band(data5, 279668649))))), collectStep(function()
							local value7 = callback17()
							local value
							if value7 then
								value = value7
							else
								local data = data4
								value = not data.CollectActive()
							end
							return value
						end)

						if value6 then
							condition4 = true
						end
					end
				end)

				if data then
					local data = data3
					data.Unequip()
				end
				data = data4
				data.Busy = false
				local condition6 = not condition4
				local condition7
				if condition6 then
					data = data4
					condition7 = not data.AutoOn()
				else
					condition7 = condition6
				end
				if condition7 then
					condition6 = data3
					condition6.Status = "Waiting for work"
				end
			else
				local condition6 = not callback16()
				if condition6 then
					local data = data3
					data.Status = "Idle"
				end
			end

			condition = (condition4 and 0.15) or 1
			condition5 = os.clock() + condition

			while true do
				condition = (condition3 and (os.clock() < condition5)) and not condition2
				if not condition then
					break
				end
				local RunService = RunService
				RunService.Heartbeat:Wait()
			end

			condition2 = false
		end
	end)

	registerItem(function()
		condition3 = false
	end)
end

callback14()

local function callback15()
	local value3 = bit32.bxor(521693183, 0)
	local TweenService = game:GetService("TweenService")
	local value
	value, value3 = TweenInfo, u32Trunc(value3 + 79723123)
	local value4, nameList, number3, number4 = value.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {"Luck", "Rarity", "Distance", "Weight"}, 60, 9
	local data5 = {Collect = Color3.fromRGB(255, 255, 255), Cancel = Color3.fromRGB(255, 120, 120), AutoOn = Color3.fromRGB(120, 255, 120), AutoOff = Color3.fromRGB(255, 255, 255), Busy = Color3.fromRGB(120, 255, 90)}
	local color3FromRGB
	color3FromRGB, value3 = Color3.fromRGB, u32Trunc(value3 + 412002681)
	data5.Queued = color3FromRGB(255, 214, 90)
	data5.Auto = Color3.fromRGB(150, 210, 255)
	data5.Carry = Color3.fromRGB(255, 170, 70)
	local number5 = 1
	local ScreenGui, clone, holder, clone2, textLabel, textLabel2, label, clone3, notification, textLabel3, udim2, value5, number6, callback16
	local condition2, argumentMap, connections, condition3, condition4 = false, {}, {}, true, true
	local function callback17(argument, text3)
		if argument and (argument.Text ~= text3) then
			argument.Text = text3
		end
	end
	local function callback18()
		local localPlayer = localPlayer
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		return playerGui and (playerGui:FindFirstChild("Main"))
	end

	local function destroyAll(argument)
		for _, descendant in ipairs(argument:GetDescendants()) do
			if descendant:IsA("LuaSourceContainer") or descendant:IsA("BindableEvent") then
				descendant:Destroy()
			end
		end
	end

	local function callback19(argument)
		local data = data3
		local argument2 = data.EggData(argument)
		return (argument2 and tostring(argument2.Image or "")) or ""
	end

	local function callback20(argument)
		local attribute, attribute2, attribute3 = argument:GetAttribute("Egg"), argument:GetAttribute("Position"), argument:GetAttribute("PrivateTo")
		local condition5 = (type(attribute) == "string") and (typeof(attribute2) == "Vector3")
		local attribute4

		if condition5 then
			attribute = attribute3 == nil
			if attribute then
				attribute4 = attribute
			else
				attribute2 = localPlayer
				attribute4 = attribute3 == attribute2.UserId
			end
		else
			attribute4 = condition5
		end

		return attribute4
	end

	local function toUDim2(argument)
		local position = argument.Position
		return UDim2.new((1 + (argument.AnchorPoint.X * argument.Size.X.Scale)) + 0.1, position.X.Offset, position.Y.Scale, position.Y.Offset)
	end
	local function callback21(argument, argument2)
		TweenService:Create(argument, value4, {Position = argument2}):Play()
	end

	local function callback22()
		local condition = condition2
		if not condition then
			return
		end
		condition2 = false
		condition = clone
		if condition then
			callback21(clone, value5)
		end
	end

	local function callback23()
		local condition5 = condition2 or not clone
		if condition5 then
			return
		end
		condition2, condition3 = true, true
		clone.Visible = true
		pcall(callback16)
		callback21(clone, udim2)
	end

	local function callback24()
		local data = data4
		local collect = data.Collect
		data = (type(collect) == "table") and (type(collect.Set) == "function")
		if data then
			pcall(collect.Set, collect, not data2.Toggle(collect, false))
		end
		collect = data4
		collect.Wake()
	end

	local function registerItem2(argument)
		local data, condition5 = data4, not table.find(data4.Manual, argument)
		if condition5 then
			table.insert(data4.Manual, argument)
		end
		condition5 = data4
		condition5.Wake()
	end

	local function callback25(dropped)
		local data, pos = data4, table.find(data4.Manual, dropped)
		if pos then
			table.remove(data4.Manual, pos)
		end
		pos = data4
		local condition5 = pos.Target == dropped
		if condition5 then
			pos = data4
			pos.Dropped = dropped
		end
	end

	local function callback26(argument, name, position, size, textXAlignment)
		local clone4 = argument:Clone()
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

	local callback27

	local function callback28(argument, argument2)
		local clone4 = clone2:Clone()
		clone4.Name = generateRandomId()
		clone4.Visible = true
		clone4.Size = UDim2.new(0.888163447, 0, 0, callback27())
		local holder2 = clone4:FindFirstChild("Holder")
		local eggImage = holder2 and (holder2:FindFirstChild("EggImage"))
		local eggWeight, progress = eggImage and (eggImage:FindFirstChild("EggWeight")), clone4:FindFirstChild("Progress")
		local timeLeft, open = progress and (progress:FindFirstChild("TimeLeft")), clone4:FindFirstChild("Open")
		holder2 = open and (open:FindFirstChild("TextLabel"))
		if progress then
			progress.Visible = false
		end
		local eggName, eggInfo, eggStatus = timeLeft and callback26(timeLeft, "EggName", UDim2.fromScale(0.33, 0.1), UDim2.fromScale(0.64, 0.3)), timeLeft and callback26(timeLeft, "EggInfo", UDim2.fromScale(0.33, 0.4), UDim2.fromScale(0.64, 0.2)), timeLeft and callback26(timeLeft, "EggStatus", UDim2.fromScale(0.33, 0.66), UDim2.fromScale(0.3, 0.22))
		progress = {eggName, eggInfo, eggStatus}
		for _, value6 in ipairs(progress) do
			value6.Parent = clone4
		end

		if open then
			local timeLeft2 = bit32.bxor(347821378, 0)
			timeLeft = timeLeft2
			open.Visible = true
			open.AnchorPoint = Vector2.new(0.5, 0.5)
			progress = UDim2.fromScale
			timeLeft2 = bit32.bxor(timeLeft, 322873470)
			local value6 = progress(0.8, 0.74)
			timeLeft2 = u32Trunc((u32Mul(2440134788, timeLeft2) + 4090891476) + (u32Mul(1854832509, (bit32.bor(timeLeft2, 356487317))) + u32Mul(1854832507, (bit32.band(timeLeft2, 356487317)))))
			open.Position = value6
			open.Size = UDim2.fromScale(0.33, 0.38)

			open.Activated:Connect(function()
				local data, pos = data4, table.find(data4.Manual, argument)
				local pos2

				if pos then
					pos2 = pos
				else
					local data = data4
					local condition5 = data.Target == argument
					if condition5 then
						data = data4
						pos2 = data.TargetManual
					else
						pos2 = condition5
					end
				end

				if pos2 then
					callback25(argument)
				else
					registerItem2(argument)
				end
				condition3 = true
			end)
		end

		progress = argument2:GetAttribute("Egg")
		timeLeft = data3
		local attribute = timeLeft.EggRarity(progress)
		if eggImage then
			eggImage.Image = callback19(progress)
		end
		if eggWeight then
			eggImage = data3
			eggWeight.Text = eggImage.EggWeightText(argument2:GetAttribute("Weight"))
		end
		eggName.Text = tostring(progress)
		timeLeft = data3
		eggName.TextColor3 = timeLeft.RarityColors[attribute] or Color3.fromRGB(255, 255, 255)
		clone4.Parent = holder
		eggImage, eggWeight = {Frame = clone4, Config = argument2, Name = progress, Rarity = attribute}, data3
		eggImage.Rank = eggWeight.EggRank(progress)
		timeLeft = data3
		eggImage.Luck = timeLeft.EggLuck(progress) * (tonumber(argument2:GetAttribute("Weight")) or 1)
		eggImage.Position = argument2:GetAttribute("Position")
		eggImage.Info = eggInfo
		eggImage.Status = eggStatus
		eggImage.Button = open
		eggImage.ButtonText = holder2
		return eggImage
	end

	callback27 = function()
		local width = (holder and holder.AbsoluteSize.X) or 0
		return math.max(40, math.floor((width * 0.888163447) / 2.55))
	end

	local function destroyAll2(argument)
		local argumentEntry = argumentMap[argument]

		if argumentEntry then
			local value6 = bit32.bxor(200801328, 0)
			local value = value6
			value6 = bit32.bxor(value, 238179919)
			value6 = u32Trunc((u32Mul(1965050213, value6) + 572527612) + (u32Mul(364866870, (bit32.bor(value6, 140608076))) + u32Mul(1965050214, (bit32.bxor(value6, 140608076)))))
			argumentMap[argument] = nil
			pcall(function()
				argumentEntry.Frame:Destroy()
			end)
		end
	end

	local function callback29(argument, argument2)
		local data = data4
		if data.Carried[argument] then
			return "Bringing home", data5.Carry, nil
		end
		data = data4
		local condition5 = data.Target == argument
		if condition5 then
			data = data4
			return "Collecting...", data5.Busy, (data.TargetManual and "Cancel") or nil
		end
		data, condition5 = data4, table.find(data4.Manual, argument)
		if condition5 then
			return "Queued #" .. condition5, data5.Queued, "Cancel"
		end

		if argument2 then
			return "Auto #" .. argument2, data5.Auto, "Collect"
		end
		return "", data5.Collect, "Collect"
	end

	callback16 = function()
		local value6 = bit32.bxor(313161289, 0)
		local value = value6
		local holder = holder
		if not holder then
			return
		end
		holder = data3
		local data6 = holder.Root()
		local position, nameMap = (data6 and data6.Position) or Vector3.new(0, 0, 0), {}
		value6 = u32Trunc((u32Mul(3624322189, value) + 2177299751) + (u32Mul(670645108, (bit32.bor(value, 361244035))) + u32Mul(670645106, (bit32.band(value, 361244035)))))
		local list, data, value7 = {}, ipairs
		value = activeEggs
		holder = table.pack(value:GetChildren())

		for k, value8 in data(table.unpack(holder, 1, holder.n)) do
			k = callback20(value8)
			value = nil
			if k then
				data6 = data4
				value = not (data6.Relaying and (value8:GetAttribute("OriginPosition") ~= nil))
			else
				value = k
			end
			if value then
				nameMap[value8.Name] = value8
				table.insert(list, value8)
			end
		end

		data6, data = pairs, data4
		holder = data.Carried
		value6 = bit32.bxor(value6, 427808521)
		for k, value8 in data6(holder) do
			if (typeof(value8) == "Instance") and not nameMap[k] then
				nameMap[k] = value8
			end
		end
		value = data4
		holder, data6 = value.Target
		if holder then
			value = data4
			data6 = not nameMap[value.Target]
		else
			data6 = holder
		end
		holder = nil
		if data6 then
			data = data4
			holder = argumentMap[data.Target]
		else
			holder = data6
		end
		if holder then
			value, data6 = data4
			data6, nameMap[value.Target] = data4, argumentMap[data4.Target].Config
		end
		for k in pairs(argumentMap) do
			if not nameMap[k] then
				destroyAll2(k)
			end
		end
		data6, value = {}, ipairs

		for _, value8 in value(list) do
			local attribute, attribute2, insert, data7, data = value8:GetAttribute("Egg"), value8:GetAttribute("Position"), table.insert, {Uid = value8.Name, Config = value8}, data3
			data7.Rank = data.EggRank(attribute)
			holder = data3
			data7.Luck = holder.EggLuck(attribute) * (tonumber(value8:GetAttribute("Weight")) or 1)
			data7.Distance = (attribute2 - position).Magnitude
			data7.Weight = tonumber(value8:GetAttribute("Weight")) or 0
			insert(data6, data7)
		end

		local sort = nameList[number5]
		value = table.sort

		local function callback30(argument, argument2)
			if (sort == "Weight") and (argument.Weight ~= argument2.Weight) then
				return argument.Weight > argument2.Weight
			end

			if sort == "Distance" then
				return argument.Distance < argument2.Distance
			elseif sort == "Rarity" then
				if argument.Rank ~= argument2.Rank then
					return argument.Rank > argument2.Rank
				end

				if argument.Luck ~= argument2.Luck then
					return argument.Luck > argument2.Luck
				end
				return argument.Distance < argument2.Distance
			end

			if argument.Luck ~= argument2.Luck then
				return argument.Luck > argument2.Luck
			end
			return argument.Distance < argument2.Distance
		end

		value(data6, callback30)
		local callback30_2
		data, callback30_2 = {}, data4
		local position2, data3, number7 = callback30_2.AutoPlan(position), ipairs, 0

		for k, value8 in data3(position2) do
			holder = value8.Config.Name
			position, callback30_2, value = data4, not table.find(data4.Manual, holder)
			if callback30_2 then
				k = data4
				value = k.Target ~= holder
			else
				value = callback30_2
			end

			if value then
				number7 += 1
				data[holder] = number7
				if number7 >= number4 then
					break
				end
			end
		end

		position2, data3 = {}, data4
		for k, value8 in pairs(data3.Carried) do
			if nameMap[k] == value8 then
				table.insert(position2, k)
			end
		end
		value = data4
		callback30_2, data3 = value.Target
		if callback30_2 then
			holder = data4
			data3 = nameMap[holder.Target]
		else
			data3 = callback30_2
		end
		holder = nil
		if data3 then
			value, callback30_2 = data4
			callback30_2, holder = data4, not value.Carried[data4.Target]
		else
			holder = data3
		end
		if holder then
			table.insert(position2, data4.Target)
		end
		callback30_2, holder = ipairs, data4
		data3 = holder.Manual

		for k, value8 in callback30_2(data3) do
			k, holder = nameMap[value8]
			if k then
				value = data4
				holder = value8 ~= value.Target
			else
				holder = k
			end
			if holder then
				table.insert(position2, value8)
			end
		end

		holder, value = {}, {}
		for _, value8 in ipairs(position2) do
			value[value8] = true
			table.insert(holder, value8)
		end
		for _, value8 in ipairs(data6) do
			if not value[value8.Uid] then
				value[value8.Uid] = true
				table.insert(holder, value8.Uid)
			end
		end
		value = {}
		for _, value8 in ipairs(data6) do
			value[value8.Uid] = value8.Distance
		end
		data3, position2 = {}, ipairs

		for k, value8 in position2(holder) do
			if k > number3 then
				break
			end
			data3[value8] = true
			callback30_2 = argumentMap[value8]
			if not callback30_2 then
				callback30_2 = callback28(value8, nameMap[value8])
				argumentMap[value8] = callback30_2
			end
			callback30_2.Frame.LayoutOrder = k
			data6 = callback27()
			if callback30_2.Frame.Size.Y.Offset ~= data6 then
				callback30_2.Frame.Size = UDim2.new(0.888163447, 0, 0, data6)
			end
			k = data4
			if k.Carried[value8] then
				callback17(callback30_2.Info, callback30_2.Rarity .. "  |  In basket")
			else
				callback17(callback30_2.Info, string.format("%s  |  %dm", callback30_2.Rarity, math.floor(value[value8] or 0)))
			end
			local value9, value10, value11 = callback29(value8, data[value8])
			callback17(callback30_2.Status, value9)
			callback30_2.Status.TextColor3 = value10

			if callback30_2.Button then
				callback30_2.Button.Visible = value11 ~= nil
				if value11 then
					callback17(callback30_2.ButtonText, value11)
					callback30_2.Button.ImageColor3 = ((value11 == "Cancel") and data5.Cancel) or data5.Collect
				end
			end
		end

		for k in pairs(argumentMap) do
			if not data3[k] then
				destroyAll2(k)
			end
		end
		callback17(label, string.format("Map Eggs (%d)", #list))
		data3 = data2
		holder, data6 = data4, data3.Toggle(data4.Collect, false)
		callback17(textLabel2, (data6 and "Auto: ON") or "Auto: OFF")
		callback30_2 = (textLabel2 and textLabel2.Parent) and textLabel2.Parent:IsA("ImageButton")
		if callback30_2 then
			textLabel2.Parent.ImageColor3 = (data6 and data5.AutoOn) or data5.AutoOff
		end
		callback17(textLabel, "Sort: " .. sort)
		position2 = data4
		value = position2.InstantOn == true
		callback17(textLabel3, (value and "Instant: ON") or "Instant: OFF")
		data3 = (textLabel3 and textLabel3.Parent) and textLabel3.Parent:IsA("ImageButton")
		if data3 then
			textLabel3.Parent.ImageColor3 = (value and data5.AutoOn) or data5.AutoOff
		end
		callback30_2 = notification

		if callback30_2 then
			value = data4
			data6, list, position2 = data4, #value.Manual + ((data4.Target and 1) or 0), notification
			position2.Visible = list > 0
			data3 = notification:FindFirstChild("Count")
			callback17(data3, tostring(list))
		end
	end

	local function callback30()
		local value6 = bit32.bxor(144024351, 0)
		local uiListLayout = callback18()
		local plotEggsTracker, sideBar = uiListLayout and (uiListLayout:FindFirstChild("PlotEggsTracker")), uiListLayout and (uiListLayout:FindFirstChild("SideBar"))
		local egg = sideBar and (sideBar:FindFirstChild("Egg"))
		local eggFrame

		if plotEggsTracker then
			sideBar = plotEggsTracker:FindFirstChild("Handler")
			eggFrame = sideBar and (sideBar:FindFirstChild("EggFrame"))

			if not eggFrame then
				local holder2 = plotEggsTracker:FindFirstChild("Holder")
				for _, value7 in ipairs((holder2 and holder2:GetChildren()) or {}) do
					if value7:IsA("Frame") and value7:FindFirstChild("Holder") then
						eggFrame = value7
						break
					end
				end
			end
		end

		if (not plotEggsTracker or not egg) or not eggFrame then
			return false
		end
		sideBar = nil
		sideBar, value6 = Instance, u32Trunc(value6 + 398668329)
		ScreenGui = sideBar.new("ScreenGui")
		local ScreenGui2 = ScreenGui
		local value7
		ScreenGui2.Name = generateRandomId()
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
		destroyAll(clone2)
		clone = plotEggsTracker:Clone()
		ScreenGui2 = clone
		ScreenGui2.Name = generateRandomId()
		destroyAll(clone)
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
		ScreenGui2, value6 = plotEggsTracker.new(), u32Trunc(value6 - 128727776)
		sideBar.CanvasSize = ScreenGui2
		uiListLayout = holder:FindFirstChildOfClass("UIListLayout")
		if uiListLayout then
			uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		end
		udim2 = UDim2.new(0.99, 0, 0.5, 0)
		clone.Position = udim2
		value5 = toUDim2(clone)
		clone.Position = value5
		plotEggsTracker = clone:FindFirstChild("Header")
		label = plotEggsTracker and plotEggsTracker:FindFirstChild("Label")
		sideBar = label
		if sideBar then
			label.Text = "Map Eggs"
		end
		plotEggsTracker = clone:FindFirstChild("GrowAll")

		if plotEggsTracker then
			local value8 = bit32.bxor(203891498, 0)
			sideBar = value8
			ScreenGui2 = plotEggsTracker:Clone()
			plotEggsTracker.Name = generateRandomId()
			ScreenGui2.Name = generateRandomId()
			plotEggsTracker.Size = UDim2.new(0.185, 0, plotEggsTracker.Size.Y.Scale, 0)
			ScreenGui2.Size = plotEggsTracker.Size
			uiListLayout = nil
			uiListLayout, value8 = UDim2.new, u32Trunc(sideBar + 82541904)
			plotEggsTracker.Position = uiListLayout(0.5175, 0, plotEggsTracker.Position.Y.Scale, 0)
			ScreenGui2.Position = UDim2.new(0.9075, 0, plotEggsTracker.Position.Y.Scale, 0)
			ScreenGui2.Parent = clone
			local clone4 = plotEggsTracker:Clone()
			clone4.Name = generateRandomId()
			clone4.Size = plotEggsTracker.Size
			clone4.Position = UDim2.new(0.7125, 0, plotEggsTracker.Position.Y.Scale, 0)
			clone4.Parent = clone
			local data6 = {plotEggsTracker, ScreenGui2, clone4}

			for i, value9 in ipairs(data6) do
				i = value9:FindFirstChild("TextLabel")
				if i then
					i.AnchorPoint = Vector2.new(0.5, 0.5)
					i.Position = UDim2.fromScale(0.5, 0.5)
					i.Size = UDim2.fromScale(0.86, 0.56)
					i.TextXAlignment = Enum.TextXAlignment.Center
				end
			end

			textLabel = plotEggsTracker:FindFirstChild("TextLabel")
			textLabel2 = ScreenGui2:FindFirstChild("TextLabel")
			textLabel3 = clone4:FindFirstChild("TextLabel")

			clone4.Activated:Connect(function()
				local value9 = bit32.bxor(45841804, 0)
				local value = value9
				local data = data4
				local instantHandle = data.InstantHandle
				local valueType, number7, condition5 = type(instantHandle), u32Mul(526926915, value) + 3012581617
				value9, condition5 = u32Trunc(number7 + (u32Mul(3768040382, (bit32.bor(value, 406181051))) + u32Mul(3768040380, (bit32.band(value, 406181051))))), (valueType == "table") and (type(instantHandle.Set) == "function")
				if condition5 then
					pcall(instantHandle.Set, instantHandle, not (data4.InstantOn == true))
				else
					number7, value = data4, data4
					number7.InstantOn = not (value.InstantOn == true)
				end
				number7 = data4
				number7.Wake()
				condition3 = true
				valueType = nil
				valueType, value9 = task, bit32.bxor(value9, 230978752)
				valueType.delay(0.3, function()
					condition3 = true
				end)
			end)

			plotEggsTracker.Activated:Connect(function()
				local number = number5
				number5, condition3 = (number % #nameList) + 1, true
			end)
			data6 = ScreenGui2.Activated
			local function callback31()
				callback24()
				condition3 = true
			end
			data6:Connect(callback31)
		end

		ScreenGui2 = clone:FindFirstChild("Toggle")
		if ScreenGui2 and (ScreenGui2:IsA("GuiButton")) then
			ScreenGui2.Activated:Connect(callback22)
		end
		clone.Parent = ScreenGui
		clone3 = egg:Clone()
		plotEggsTracker = clone3
		plotEggsTracker.Name = generateRandomId()
		destroyAll(clone3)
		local arrow, clone, value8 = clone3:FindFirstChild("Arrow"), pairs
		egg, plotEggsTracker, sideBar = data, type(data.Eggs) == "table"
		if plotEggsTracker then
			uiListLayout = data
			sideBar = uiListLayout.Eggs
		else
			sideBar = plotEggsTracker
		end
		uiListLayout, plotEggsTracker = -1
		for k, value9 in clone(sideBar or {}) do
			if ((type(value9) == "table") and value9.Image) and ((tonumber(value9.Luck) or 0) > uiListLayout) then
				uiListLayout, plotEggsTracker = tonumber(value9.Luck) or 0, k
			end
		end
		if arrow and plotEggsTracker then
			arrow.Image = callback19(plotEggsTracker)
			arrow.AnchorPoint = Vector2.new(0.5, 0.5)
			arrow.Position = UDim2.fromScale(0.5, 0.42)
			arrow.Size = UDim2.fromScale(0.74, 0.74)
		end
		arrow, sideBar = nil
		arrow, sideBar, value6 = clone3, Color3.fromRGB, u32Trunc(value6 + 94274346)
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
			clone = arrow:Clone()
			clone.Name = generateRandomId()
			clone.AnchorPoint = Vector2.new(0.5, 0.5)
			clone.Position = UDim2.fromScale(0.5, 0.86)
			clone.Size = UDim2.fromScale(0.9, 0.3)
			clone.TextScaled = true
			clone.Text = "MAP"
			clone.TextColor3 = Color3.fromRGB(255, 255, 255)
			clone.ZIndex = 3
			ScreenGui2 = clone:FindFirstChildOfClass("UIStroke")
			if ScreenGui2 then
				ScreenGui2.Color = Color3.fromRGB(44, 8, 86)
			end
			clone.Parent = clone3
		end

		arrow = notification
		if arrow then
			notification.Visible = false
		end
		ScreenGui2 = clone3
		ScreenGui2.AnchorPoint = Vector2.new(0.5, 0.5)
		clone3.Parent = ScreenGui
		plotEggsTracker = clone3.Activated

		local function callback31()
			local condition = condition2
			if condition then
				callback22()
			else
				callback23()
			end
		end

		plotEggsTracker:Connect(callback31)
		clone = value2
		ScreenGui.Parent = clone
		return true
	end

	local function callback31(argument)
		local condition5 = not clone3 or not ScreenGui
		if condition5 then
			return
		end
		condition5 = callback18()
		local sideBar = condition5 and (condition5:FindFirstChild("SideBar"))
		local egg, pets = sideBar and (sideBar:FindFirstChild("Egg")), sideBar and (sideBar:FindFirstChild("Pets"))
		local condition6 = (not egg or not pets) or not condition5.Enabled
		if condition6 then
			clone3.Visible = false
			return
		end
		local absoluteSize, absolutePosition = ScreenGui.AbsoluteSize, ScreenGui.AbsolutePosition
		local number7, number8 = (egg.AbsolutePosition + (egg.AbsoluteSize / 2)) - absolutePosition, (pets.AbsolutePosition + (pets.AbsoluteSize / 2)) - absolutePosition
		condition6 = (sideBar:GetAttribute("Open") == true) and (number8.X < (absoluteSize.X - (pets.AbsoluteSize.X * 0.4)))
		if condition6 then
			number6 = absoluteSize.X - number8.X
		end
		condition6, egg, sideBar = number6 or (pets.AbsoluteSize.X * 0.9), pets.AbsoluteSize, {"BasketTracker", "PlotEggsTracker", "PetsTracker"}
		pets = (Vector2.new(absoluteSize.X - condition6, number7.Y - (number8.Y - number7.Y)))

		for i, value in ipairs(sideBar) do
			i = condition5:FindFirstChild(value)

			if (i and (i:GetAttribute("Open") == true)) and ((i.AbsolutePosition.X - absolutePosition.X) < absoluteSize.X) then
				value, number7 = i.AbsolutePosition.Y, i.AbsolutePosition.X + i.AbsoluteSize.X
				for _, child in ipairs(i:GetChildren()) do
					value = if child:IsA("GuiObject") and child.Visible then math.min(value, child.AbsolutePosition.Y) else value
				end
				pets = Vector2.new(math.min(number7 - absolutePosition.X, absoluteSize.X - 4) - (egg.X / 2), ((value - absolutePosition.Y) - (egg.Y / 2)) - (egg.Y * 0.12))
				break
			end
		end

		number8, sideBar = Vector2.new(clone3.Position.X.Offset, clone3.Position.Y.Offset), math.clamp((argument or 0) * 14, 0, 1)
		sideBar = if not clone3.Visible or ((number8 - pets).Magnitude > absoluteSize.Y) then 1 else sideBar
		condition5, absoluteSize = number8:Lerp(pets, sideBar), clone3
		absoluteSize.Size = UDim2.fromOffset(egg.X, egg.Y)
		sideBar = clone3
		sideBar.Position = UDim2.fromOffset(condition5.X, condition5.Y)
		clone3.Visible = not condition2
	end

	local function callback32()
		local value6 = bit32.bxor(485440866, 0)
		local value = value6
		local ScreenGui = ScreenGui
		value6 = u32Trunc(value + 11415410)
		if ScreenGui then
			return
		end

		if not callback30() then
			return
		end
		local value7, insert, activeEggs2
		insert, value6, activeEggs2 = table.insert, u32Trunc(value6 + 453038717), activeEggs
		insert(connections, activeEggs.ChildAdded:Connect(function()
			condition3 = true
		end))
		table.insert(connections, activeEggs.ChildRemoved:Connect(function()
			condition3 = true
		end))
		local number7 = 0
		local value8

		table.insert(connections, RunService.RenderStepped:Connect(function(deltaTime)
			pcall(callback31, deltaTime)
			number7 += deltaTime
			deltaTime = condition2 and (condition3 or (number7 >= 0.3))

			if deltaTime then
				number7, condition3 = 0, false
				pcall(callback16)
			else
				local condition5 = not condition2 and (number7 >= 0.5)

				if condition5 then
					number7 = 0
					local notification2 = notification
					if notification2 then
						local data = data4
						local data, number8, notification2 = data4, #data.Manual + ((data4.Target and 1) or 0), notification
						notification2.Visible = number8 > 0
						callback17(notification:FindFirstChild("Count"), tostring(number8))
					end
				end
			end
		end))
	end

	local function disconnectAll()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		table.clear(connections)
		condition2 = false
		table.clear(argumentMap)
		local ScreenGui2 = ScreenGui

		if ScreenGui2 then
			local value6 = bit32.bxor(73680770, 0)
			local value = value6
			local value2
			value2, value6 = pcall, u32Trunc(value + 298093352)
			value2(function()
				ScreenGui:Destroy()
			end)
		end

		ScreenGui, clone, holder, clone2, clone3, notification = nil, nil, nil, nil, nil, nil
	end

	task.spawn(function()
		local number7 = os.clock() + 30

		while true do
			local condition5 = condition4 and not ScreenGui
			if not (condition5 and (os.clock() < number7)) then
				break
			end
			pcall(callback32)
			condition5 = ScreenGui
			if not condition5 then
				task.wait(1)
			end
		end
	end)

	registerItem(function()
		condition4 = false
		disconnectAll()
	end)
end

callback15()

local function callback16()
	local value3, kMap = bit32.bxor(276055607, 0), {}
	value3 = bit32.bxor(value3, 209316081)
	kMap.Food = nil
	kMap.Gears = nil
	local configMap, data5 = {Food = {}, Gears = {}}, {}
	value3 = u32Trunc((u32Mul(201531720, value3) + 2003180288) + (u32Mul(3891903856, (bit32.bor(value3, 500438112))) + u32Mul(201531721, (bit32.bxor(value3, 500438112)))))
	local number3, data6 = 0, {}

	local function callback17(argument)
		local value4 = bit32.bxor(152549750, 0)
		local value = value4
		local data7 = {}
		local _
		local data = data
		local shop = data.Shop
		data = ((type(shop) == "table") and shop[argument]) or nil
		shop = type(data)
		value4 = u32Trunc(value + 315903077)
		value4 = u32Trunc(value4 - 290068142)

		if shop == "table" then
			for k, value5 in pairs(data) do
				if type(value5) == "table" then
					value, argument = table.insert, {Name = k}
					argument.Price = tonumber(value5.Price) or 0
					value(data7, argument)
				end
			end
		end

		table.sort(data7, function(argument2, argument3)
			return argument2.Price < argument3.Price
		end)
		argument = {}
		for _, value5 in ipairs(data7) do
			table.insert(argument, value5.Name)
		end
		return argument
	end

	local function toNumberOrDefault(argument, argument2)
		local data = data
		local shop = data.Shop
		data = ((type(shop) == "table") and shop[argument]) or nil
		argument = ((type(data) == "table") and data[argument2]) or nil
		return ((type(argument) == "table") and tonumber(argument.Price)) or (1 / 0)
	end

	local function callback18(argument)
		if type(argument) ~= "table" then
			return
		end

		for k, value4 in pairs(argument) do
			if ((k == "Food") or (k == "Gears")) and (type(value4) == "table") then
				local kMap2 = {}
				for k2, value5 in pairs(value4) do
					if type(value5) == "table" then
						kMap2[k2] = tonumber(value5.Amount) or ((value5.InStock and 1) or 0)
					end
				end
				kMap[k] = kMap2
			end
		end
	end

	local connections, autoShopSection2, nameList = {}, ipairs, {"Restock", "ShopStock"}

	for k, value4 in autoShopSection2(nameList) do
		k = game_
		local value5 = k:FindFirstChild(value4)
		if value5 and (value5:IsA("RemoteEvent")) then
			table.insert(connections, value5.OnClientEvent:Connect(function(argument)
				callback18(argument)
			end))
		end
	end

	nameList = data3
	nameList.Fire("ShopStock")

	local function callback19(argument)
		local value, data7, value4 = ipairs, {}
		local localPlayer, localPlayer2 = localPlayer, localPlayer
		data7[1], data7[2] = localPlayer:FindFirstChildOfClass("Backpack"), localPlayer2.Character
		localPlayer = 0

		for _, value5 in value(data7) do
			if value5 then
				for i, child in ipairs(value5:GetChildren()) do
					if child:IsA("Tool") and (string.gsub(child.Name, "%s*%[.*$", "") == argument) then
						i = child:FindFirstChild("Amount", true)
						localPlayer += (i and tonumber(i.Value)) or 1
					end
				end
			end
		end

		return localPlayer
	end

	local function callback20(argument)
		local _ = data6[argument]
		local value4
		local data = data2
		if not data.Toggle(_, false) then
			return
		end
		local value, value5, condition2 = ipairs, table.pack(callback17(argument)), false

		for k, value6 in value(table.unpack(value5, 1, value5.n)) do
			_ = configMap[argument][value6]

			if _ then
				data, k = toNumberOrDefault(argument, value6), kMap[argument]
				local kEntry = k and k[value6]
				local condition3, number4 = ((kEntry == nil) and ((data5[argument .. value6] or 0) <= os.clock())) or ((kEntry ~= nil) and (kEntry > 0)), 0

				while true do
					local condition4 = condition3 and (number4 < 20)
					local condition5
					if condition4 then
						kEntry = data3
						condition5 = (kEntry.Cash() - data) >= number3
					else
						condition5 = condition4
					end
					if not condition5 then
						break
					end
					condition4 = not condition2
					if condition4 then
						condition5 = data3
						condition5.Fire("SetOpenShop", argument)
						task.wait(0.15)
						condition2 = true
					end
					condition4, condition5 = callback19(value6), data3
					condition5.Fire("BuyWithCash", argument, value6)
					number4 += 1
					condition5 = os.clock() + 0.8
					while (os.clock() < condition5) and (callback19(value6) <= condition4) do
						local RunService = RunService
						RunService.Heartbeat:Wait()
					end

					if callback19(value6) > condition4 then
						if k and k[value6] then
							k[value6] = math.max(0, k[value6] - 1)
							condition3 = k[value6] > 0
						end
					else
						if k then
							k[value6] = 0
						end
						data5[argument .. value6] = os.clock() + 30
						condition3 = false
					end
				end
			end
		end
	end

	local condition2 = true

	task.spawn(function()
		while true do
			local condition = condition2
			if not condition then
				break
			end
			pcall(callback20, "Food")
			pcall(callback20, "Gears")
			task.wait(3)
		end
	end)

	registerItem(function()
		condition2 = false
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
	end)
	autoShopSection2 = autoShopSection
	data6.Food = autoShopSection2:CreateToggle({Name = "Auto Buy Food", Default = false, Callback = function()
	end})
	nameList = autoShopSection
	nameList:CreateMultiDropdown({Name = "Food To Buy", Options = callback17("Food"), Default = {}, SubOf = data6.Food, Callback = function(argument)
		configMap.Food = callback7(argument)
	end})
	nameList = autoShopSection
	data6.Gears = nameList:CreateToggle({Name = "Auto Buy Radars", Default = false, Callback = function()
	end})
	nameList = autoShopSection
	nameList:CreateMultiDropdown({Name = "Radars To Buy", Options = callback17("Gears"), Default = {}, SubOf = data6.Gears, Callback = function(argument)
		configMap.Gears = callback7(argument)
	end})
	autoShopSection2 = autoShopSection
	autoShopSection2:CreateSlider({Name = "Keep Cash", Min = 0, Max = 100000000, Default = 0, Increment = 1000, Callback = function(argument)
		number3 = math.max(0, tonumber(argument) or 0)
	end})
end

callback16()

local function callback17()
	local value3 = bit32.bxor(169514827, 0)
	local autoRebirthToggle
	value3 = u32Trunc(value3 + 168181805)
	local autoClaimIndexRewardToggle
	value3 = u32Trunc(value3 + 322050619)

	local function callback18()
		local data = data
		local rebirths = data.Rebirths
		local value4
		local data2, number3 = data3, tonumber(data3.Saved("Rebirths")) or 0
		if type(rebirths) ~= "table" then
			return nil
		end
		data = tonumber(rebirths.Cap)
		if data and (number3 >= data) then
			return nil
		end
		if type(rebirths.GetCost) == "function" then
			local ok, response = pcall(rebirths.GetCost, number3)
			if ok and tonumber(response) then
				return tonumber(response)
			end
		end
		return nil
	end

	local autoProgressSection2 = autoProgressSection
	autoRebirthToggle = autoProgressSection2:CreateToggle({Name = "Auto Rebirth", Default = false, Callback = function()
	end})
	autoProgressSection2 = autoProgressSection
	autoClaimIndexRewardToggle = autoProgressSection2:CreateToggle({Name = "Auto Claim Index Reward", Default = false, Callback = function()
	end})
	autoProgressSection2 = autoProgressSection
	local autoUpgradeLuckToggle = autoProgressSection2:CreateToggle({Name = "Auto Upgrade Luck", Default = false, Callback = function()
	end})
	local value4, condition2 = callback(function()
		local ReplicatedStorage = ReplicatedStorage
		return ReplicatedStorage.GameData.HatchLuck
	end), false

	local function callback19()
		local game_2 = game_
		local plot = game_2:FindFirstChild("Plot")
		game_2 = nil
		if plot then
			local game_ = game_
			game_2 = game_.Plot:FindFirstChild("Upgrades")
		else
			game_2 = plot
		end
		plot = localPlayer
		local savedData = plot:FindFirstChild("SavedData")
		plot = savedData and (savedData:FindFirstChild("HatchUpgrades"))
		if ((not game_2 or not plot) or (type(value4) ~= "table")) or (type(value4.GetPrice) ~= "function") then
			return
		end
		local localPlayer = localPlayer
		local condition3 = localPlayer:GetAttribute("Setting_LuckMultiplier") == false

		if condition3 then
			localPlayer = not condition2
			if localPlayer then
				condition2 = true
				callback6("Auto Upgrade Luck", "Turn on the Luck Multiplier setting in the game settings first.")
			end
			return
		end

		condition2 = false
		condition3, localPlayer = tonumber(plot.Value) or 0, savedData:FindFirstChild("FreeHatchUpgrades")
		savedData = nil
		local freeHatchUpgrades = localPlayer and ((tonumber(localPlayer.Value) or 0) > 0)

		if freeHatchUpgrades then
			savedData = "MaxFree"
		else
			local ok, response = pcall(value4.GetPrice, condition3)
			response = (ok and tonumber(response)) or nil
			ok = nil
			if response then
				localPlayer = data3
				ok = localPlayer.Cash() >= response
			else
				ok = response
			end
			savedData = if ok then "Max" else savedData
		end

		if not savedData then
			return
		end
		game_2:FireServer(savedData)
		savedData = os.clock() + 1.5
		while (os.clock() < savedData) and ((tonumber(plot.Value) or 0) == condition3) do
			task.wait(0.05)
		end
	end

	local condition3, number3, number4 = true, 0, 0

	task.spawn(function()
		while true do
			local condition = condition3
			if not condition then
				break
			end
			condition = os.clock()
			local data = data2
			local autoRebirthToggle2 = data.Toggle(autoRebirthToggle, false) and (condition >= number3)
			local value5

			if autoRebirthToggle2 then
				data = callback18()
				local condition4
				if data then
					local data2 = data3
					condition4 = data2.Cash() >= data
				else
					condition4 = data
				end

				if condition4 then
					local data = data3
					data.Fire("Rebirth")
					number3 = condition + 15
				else
					number3 = condition + 3
				end
			end

			data = data2
			autoRebirthToggle2 = data.Toggle(autoClaimIndexRewardToggle, false) and (condition >= number4)
			if autoRebirthToggle2 then
				data = data3
				data.Fire("ClaimIndexReward")
				number4 = condition + 60
			end
			data = data2
			if data.Toggle(autoUpgradeLuckToggle, false) then
				pcall(callback19)
			end
			task.wait(1)
		end
	end)

	registerItem(function()
		condition3 = false
	end)
end

callback17()
local playerTab = mainWindow:CreateTab({ Name = "Player", SectionsExpanded = true })
local movementSection = playerTab:CreateSection({ Name = "Movement", Expanded = true })
local espSection = playerTab:CreateSection({ Name = "ESP", Expanded = true })

local function callback18()
	local value3 = bit32.bxor(369474167, 0)
	local speedBoostToggle
	value3 = u32Trunc((u32Mul(951791510, value3) + 3328987136) + (u32Mul(2391384276, (bit32.bor(value3, 340621312))) + u32Mul(951791511, (bit32.bxor(value3, 340621312)))))
	local number3 = 60
	local value4
	local RunService = RunService
	local heartbeat
	heartbeat, value3 = RunService.Heartbeat, bit32.bxor(value3, 169409207)

	local connection = heartbeat:Connect(function()
		local data = data2
		local vector = not data.Toggle(speedBoostToggle, false)
		local vector2
		if vector then
			vector2 = vector
		else
			data = data4
			vector2 = data.Busy
		end
		if vector2 then
			return
		end
		vector2 = data3
		data, vector = vector2.Humanoid(), data3
		vector2 = vector.Root()
		if (not data or not vector2) or data.Sit then
			return
		end
		vector = data.MoveDirection
		data = Vector3.new(vector.X, 0, vector.Z)
		if data.Magnitude < 0.05 then
			return
		end
		vector = vector2.AssemblyLinearVelocity
		vector2.AssemblyLinearVelocity = Vector3.new(0, vector.Y, 0) + (data.Unit * number3)
	end)

	registerItem(function()
		connection:Disconnect()
	end)
	heartbeat = movementSection
	speedBoostToggle = heartbeat:CreateToggle({Name = "Speed Boost", Default = false, Callback = function()
	end})
	heartbeat = movementSection
	heartbeat:CreateSlider({Name = "Boost Speed", Min = 16, Max = 1300, Default = 60, Increment = 1, SubOf = speedBoostToggle, Callback = function(argument)
		number3 = math.clamp(tonumber(argument) or 60, 16, 1300)
	end})
end

callback18()

local function callback19()
	local value3 = bit32.bxor(96988972, 0)
	local infiniteJumpToggle, value4
	local UserInputService = UserInputService
	value3 = u32Trunc((u32Mul(2345165096, value3) + 2128749880) + (u32Mul(1949802201, (bit32.bor(value3, 27069915))) + u32Mul(1949802199, (bit32.band(value3, 27069915)))))
	local jumpRequest
	jumpRequest, value3 = UserInputService.JumpRequest, bit32.bxor(value3, 457573730)

	local connection = jumpRequest:Connect(function()
		local data = data2
		if not data.Toggle(infiniteJumpToggle, false) then
			return
		end
		data = data3
		local value5 = data.Humanoid()

		if value5 then
			local value6 = bit32.bxor(293056948, 0)
			data = value6
			local value
			value, value6 = pcall, u32Trunc(data + 209891882)
			value(function()
				value5:ChangeState(Enum.HumanoidStateType.Jumping)
			end)
		end
	end)

	registerItem(function()
		connection:Disconnect()
	end)
	jumpRequest = movementSection
	infiniteJumpToggle = jumpRequest:CreateToggle({Name = "Infinite Jump", Default = false, Callback = function()
	end})
end

callback19()

local function callback20()
	local value3 = bit32.bxor(162067519, 0)
	local noclipToggle
	value3 = u32Trunc((u32Mul(370339972, value3) + 3951308156) + (u32Mul(3554287352, (bit32.bor(value3, 50911103))) + u32Mul(370339973, (bit32.bxor(value3, 50911103)))))
	local condition2 = false
	local value4
	local RunService = RunService
	value3 = bit32.bxor(value3, 275252811)

	local connection = RunService.Stepped:Connect(function()
		local data = data2
		local noclipToggle2 = data.Toggle(noclipToggle, false)

		if noclipToggle2 then
			condition2 = true
			data = data3
			data.SetNoclip(true)
		else
			local condition = condition2

			if condition then
				condition2 = false
				local data = data4
				local condition3 = not data.Busy
				if condition3 then
					data = data3
					data.SetNoclip(false)
				end
			end
		end
	end)

	registerItem(function()
		connection:Disconnect()
	end)
	RunService = movementSection
	noclipToggle = RunService:CreateToggle({Name = "Noclip", Default = false, Callback = function()
	end})
end

callback20()

local function callback21()
	local value3 = bit32.bxor(215638960, 0)
	local gameRef
	gameRef, value3 = game, u32Trunc(value3 + 527052318)
	local ProximityPromptService, argumentMap, connections = gameRef:GetService("ProximityPromptService"), {}, {}
	value3 = u32Trunc(value3 - 436140358)

	local function callback22(argument)
		if not argument:IsA("ProximityPrompt") then
			return
		end
		if argumentMap[argument] == nil then
			argumentMap[argument] = argument.HoldDuration
		end
		if argument.HoldDuration ~= 0 then
			argument.HoldDuration = 0
		end
	end

	local function disconnectAll()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		table.clear(connections)

		for k, value4 in pairs(argumentMap) do
			if k.Parent then
				local value5 = bit32.bxor(51292530, 0)
				local value = value5
				local value2
				value2, value5 = pcall, u32Trunc((u32Mul(1332784002, value) + 3279114652) + (u32Mul(2962183295, (bit32.bor(value, 339839054))) + u32Mul(2962183293, (bit32.band(value, 339839054)))))
				value2(function()
					k.HoldDuration = value4
				end)
			end
		end

		table.clear(argumentMap)
	end

	local function callback23()
		local value4 = bit32.bxor(139408483, 0)
		local value = value4
		disconnectAll()
		local value2, workspaceRef = ipairs, workspace
		value4 = u32Trunc(value + 484014237)
		value = table.pack(workspaceRef:GetDescendants())
		value4 = u32Trunc(value4 - 447785782)
		for _, value5 in value2(table.unpack(value, 1, value.n)) do
			if value5:IsA("ProximityPrompt") then
				callback22(value5)
			end
		end
		table.insert(connections, workspace.DescendantAdded:Connect(function(descendant)
			if descendant:IsA("ProximityPrompt") then
				task.defer(callback22, descendant)
			end
		end))
		table.insert(connections, ProximityPromptService.PromptShown:Connect(callback22))
	end

	registerItem(disconnectAll)
	gameRef = movementSection

	gameRef:CreateToggle({Name = "Instant Pickup", Default = false, Callback = function(argument)
		if argument then
			callback23()
		else
			disconnectAll()
		end
	end})
end

callback21()

local function callback22()
	local value3 = bit32.bxor(2768428, 0)
	local espSection2
	espSection2, value3 = Font, u32Trunc(value3 + 281794484)
	local json = espSection2.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	local espEggsToggle
	local number3, visible, folder = 0, true
	local childMap, connections = {}, {}

	local function callback23(parent, argument)
		parent.BackgroundTransparency = 1
		parent.FontFace = json
		parent.TextScaled = true
		parent.TextStrokeTransparency = 1
		parent.TextColor3 = Color3.fromRGB(255, 255, 255)
		parent.Size = UDim2.new(1, 0, 0, argument)
		argument = Instance.new("UIStroke")
		argument.Name = generateRandomId()
		argument.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		argument.LineJoinMode = Enum.LineJoinMode.Round
		argument.Color = Color3.fromRGB(0, 0, 0)
		argument.Thickness = 1.8
		argument.Transparency = 0.05
		argument.Parent = parent
	end

	local function destroyAll(child)
		local childEntry = childMap[child]

		if childEntry then
			local value4 = bit32.bxor(7043097, 0)
			local value = value4
			value4 = u32Trunc(value + 78489643)
			childMap[child] = nil
			value4 = u32Trunc(value4 + 138671771)
			pcall(function()
				childEntry.Gui:Destroy()
			end)
		end
	end

	local callback25
	value3 = u32Trunc(value3 + 99060235)

	callback25 = function(argument)
		local childEntry = childMap[argument] or not folder
		if childEntry then
			return
		end
		local attribute, attribute2 = argument:GetAttribute("Egg"), argument:GetAttribute("Position")
		if (type(attribute) ~= "string") or (typeof(attribute2) ~= "Vector3") then
			return
		end
		childEntry = argument:GetAttribute("PrivateTo")
		local parent = childEntry ~= nil
		local parent2
		if parent then
			local localPlayer = localPlayer
			parent2 = childEntry ~= localPlayer.UserId
		else
			parent2 = parent
		end
		if parent2 then
			return
		end
		childEntry = data3
		parent, parent2 = childEntry.EggRank(attribute), number3
		if parent < parent2 then
			return
		end
		parent2 = data3
		childEntry, parent = parent2.EggRarity(attribute), Instance.new("BillboardGui")
		parent.Name = generateRandomId()
		parent.AlwaysOnTop = true
		parent.LightInfluence = 0
		parent.Size = UDim2.fromOffset(170, 46)
		parent.Adornee = workspace.Terrain
		parent.StudsOffsetWorldSpace = attribute2 + Vector3.new(0, 4, 0)
		parent.MaxDistance = 100000
		parent2 = Instance.new("Frame")
		parent2.Name = generateRandomId()
		parent2.BackgroundTransparency = 1
		parent2.Size = UDim2.fromScale(1, 1)
		parent2.Parent = parent
		local uiElement = Instance.new("UIListLayout")
		uiElement.Name = generateRandomId()
		uiElement.SortOrder = Enum.SortOrder.LayoutOrder
		uiElement.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiElement.Parent = parent2
		uiElement = Instance.new("TextLabel")
		uiElement.Name = generateRandomId()
		uiElement.LayoutOrder = 1
		callback23(uiElement, 24)
		uiElement.Text = attribute
		attribute = data3
		uiElement.TextColor3 = attribute.RarityColors[childEntry] or Color3.fromRGB(255, 255, 255)
		uiElement.Parent = parent2
		uiElement = Instance.new("TextLabel")
		uiElement.Name = generateRandomId()
		uiElement.LayoutOrder = 2
		callback23(uiElement, 18)
		uiElement.TextColor3 = Color3.fromRGB(230, 232, 240)
		uiElement.Visible = visible
		uiElement.Parent = parent2
		parent.Parent = folder
		attribute, parent2 = {Gui = parent, Info = uiElement, Rarity = childEntry, Position = attribute2}, data3
		attribute.Weight = parent2.EggWeightText(argument:GetAttribute("Weight"))
		childMap[argument] = attribute
	end

	local function disconnectAll()
		for _, connection in ipairs(connections) do
			connection:Disconnect()
		end
		table.clear(connections)
		for k in pairs(childMap) do
			destroyAll(k)
		end
		local folder2 = folder

		if folder2 then
			local value4 = bit32.bxor(439333131, 0)
			local value = value4
			local value2
			value2, value4 = pcall, u32Trunc((u32Mul(1341494433, value) + 90543077) + (u32Mul(2953472864, (bit32.bor(value, 256488645))) + u32Mul(2953472862, (bit32.band(value, 256488645)))))
			value2(function()
				folder:Destroy()
			end)
			folder = nil
		end
	end

	local function callback24()
		local value4 = bit32.bxor(155163039, 0)
		local value = value4
		disconnectAll()
		folder = Instance.new("Folder")
		local value5, folder2, name
		folder2, name, value4 = folder, generateRandomId(), u32Trunc(value + 347786950)
		folder2.Name = name
		name = value2
		folder.Parent = name
		folder2 = activeEggs
		local children = folder2:GetChildren()
		value = nil
		value, value4 = task, u32Trunc(value4 - 156888294)

		value.spawn(function()
			local number4 = 1

			while true do
				local folder3 = folder and (number4 <= #children)
				if not folder3 then
					break
				end
				folder3 = os.clock() + 0.004
				while (number4 <= #children) and (os.clock() < folder3) do
					callback25(children[number4])
					number4 += 1
				end
				folder3 = RunService
				folder3.Heartbeat:Wait()
			end
		end)

		table.insert(connections, activeEggs.ChildAdded:Connect(function(child)
			task.defer(callback25, child)
		end))
		table.insert(connections, activeEggs.ChildRemoved:Connect(destroyAll))
		local number4 = 0

		table.insert(connections, RunService.Heartbeat:Connect(function(deltaTime)
			number4 += deltaTime
			deltaTime = number4
			if deltaTime < 0.5 then
				return
			end
			number4 = 0
			deltaTime = data3
			local value6 = deltaTime.Root()
			if not value6 or not visible then
				return
			end
			for _, value7 in pairs(childMap) do
				deltaTime = (value7.Position - value6.Position).Magnitude
				value7.Info.Text = string.format("%s  %s  %dm", value7.Rarity, value7.Weight, math.floor(deltaTime))
			end
		end))
	end

	registerItem(disconnectAll)
	espSection2 = espSection

	espEggsToggle = espSection2:CreateToggle({Name = "ESP Eggs", Default = false, Callback = function(argument)
		if argument then
			callback24()
		else
			disconnectAll()
		end
	end})

	local espSection, options, data = espSection, {Name = "ESP Min Rarity"}, data3
	options.Options = data.RarityChoices
	data = data3
	options.Default = data.RarityChoices[1]
	options.SubOf = espEggsToggle

	options.Callback = function(argument)
		local data = data3
		number3 = data.RarityRank[tostring(argument)] or 0
		argument = data2
		if argument.Toggle(espEggsToggle, false) then
			callback24()
		end
	end

	espSection:CreateDropdown(options)
end

callback22()

local function callback23()
	local value3 = bit32.bxor(490017804, 0)
	local font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	local color = Color3.fromRGB(255, 194, 77)
	local espSection2
	espSection2, value3 = Color3, u32Trunc(value3 + 491694390)
	local value4 = espSection2.fromRGB(170, 174, 188)
	value3 = u32Trunc(value3 - 483636244)
	local folder, connection
	local argumentMap, number3 = {}, 0

	local function createTextLabel(parent, layoutOrder, argument)
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = generateRandomId()
		textLabel.LayoutOrder = layoutOrder
		textLabel.BackgroundTransparency = 1
		textLabel.FontFace = font
		textLabel.TextScaled = true
		textLabel.TextStrokeTransparency = 1
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.Size = UDim2.new(1, 0, 0, argument)
		argument = Instance.new("UIStroke")
		argument.Name = generateRandomId()
		argument.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		argument.LineJoinMode = Enum.LineJoinMode.Round
		argument.Color = Color3.fromRGB(0, 0, 0)
		argument.Thickness = 1.8
		argument.Transparency = 0.05
		argument.Parent = textLabel
		textLabel.Parent = parent
		return textLabel
	end

	local function destroyAll(argument)
		local argumentEntry = argumentMap[argument]

		if argumentEntry then
			local value5 = bit32.bxor(270177360, 0)
			local value = value5
			value5 = u32Trunc((u32Mul(1321454627, value) + 1542652887) + (u32Mul(1652058042, (bit32.bor(value, 258693821))) + u32Mul(1321454628, (bit32.bxor(value, 258693821)))))
			argumentMap[argument] = nil
			value5 = bit32.bxor(value5, 415875119)
			pcall(function()
				argumentEntry.Gui:Destroy()
			end)
		end
	end

	local callback24, value5

	callback24 = function(argument)
		local handle = argument:FindFirstChild("Handle") or argument:FindFirstChildWhichIsA("BasePart", true)
		if not handle or not handle:IsA("BasePart") then
			return
		end
		local billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = generateRandomId()
		billboardGui.AlwaysOnTop = true
		billboardGui.LightInfluence = 0
		billboardGui.Size = UDim2.fromOffset(170, 62)
		billboardGui.Adornee = handle
		billboardGui.StudsOffsetWorldSpace = Vector3.new(0, 7, 0)
		billboardGui.MaxDistance = 100000
		handle = Instance.new("Frame")
		handle.Name = generateRandomId()
		handle.BackgroundTransparency = 1
		handle.Size = UDim2.fromScale(1, 1)
		handle.Parent = billboardGui
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.Name = generateRandomId()
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.Parent = handle
		uiListLayout = createTextLabel(handle, 1, 22)
		uiListLayout.Text = argument.Name
		local data = data3
		local data2
		data2, uiListLayout.TextColor3 = data3, data.RarityColors[data3.EggRarity(argument.Name)] or Color3.fromRGB(255, 255, 255)
		data, data2 = createTextLabel(handle, 2, 22), createTextLabel(handle, 3, 18)
		data2.TextColor3 = Color3.fromRGB(230, 232, 240)
		billboardGui.Parent = folder
		argumentMap[argument] = {Gui = billboardGui, Mutation = data, Info = data2}
	end

	local function callback25()
		local data = data3
		local isModel = data.Plot()
		local eggs, _, value = isModel and (isModel:FindFirstChild("Eggs")), {}, ipairs
		data = (eggs and eggs:GetChildren()) or {}

		for k, value6 in value(data) do
			k = value6:FindFirstChild("EggData")
			eggs, isModel = k and (k:FindFirstChild("Weight")), value6:IsA("Model")
			k = nil
			if isModel then
				local data = data3
				k = data.EggHeavyEnough((eggs and eggs.Value) or 0, number3)
			else
				k = isModel
			end

			if k then
				_[value6] = true
				if not argumentMap[value6] then
					callback24(value6)
				end
				local argumentEntry = argumentMap[value6]

				if argumentEntry then
					local attribute = value6:GetAttribute("Mutation")
					local condition2 = (type(attribute) == "string") and (attribute ~= "")
					argumentEntry.Mutation.Text = (condition2 and attribute) or "No Mutation"
					argumentEntry.Mutation.TextColor3 = (condition2 and color) or value4
					condition2, attribute = argumentEntry.Info
					if eggs then
						local data = data3
						attribute = data.EggWeightText(eggs.Value)
					else
						attribute = eggs
					end
					condition2.Text = attribute or ""
				end
			end
		end

		for k in pairs(argumentMap) do
			if not _[k] then
				destroyAll(k)
			end
		end
	end

	local function callback26()
		local connection2 = connection
		if connection2 then
			connection:Disconnect()
			connection = nil
		end
		for k in pairs(argumentMap) do
			destroyAll(k)
		end
		connection2 = folder

		if connection2 then
			local value6 = bit32.bxor(369546234, 0)
			local value = value6
			local value2
			value2, value6 = pcall, u32Trunc((u32Mul(281643640, value) + 2996455784) + (u32Mul(4013323657, (bit32.bor(value, 350168771))) + u32Mul(4013323655, (bit32.band(value, 350168771)))))
			value2(function()
				folder:Destroy()
			end)
			folder = nil
		end
	end

	local function callback27()
		local value6 = bit32.bxor(383900356, 0)
		local parent = value6
		callback26()
		folder = Instance.new("Folder")
		local folder2 = folder
		local value7
		folder2.Name = generateRandomId()
		value6 = u32Trunc(parent + 7788206)
		parent = value2
		folder.Parent = parent
		local number4 = 1
		local value8
		folder2 = RunService
		value6 = u32Trunc(value6 + 513028514)

		connection = folder2.Heartbeat:Connect(function(deltaTime)
			number4 += deltaTime
			deltaTime = number4
			if deltaTime < 0.5 then
				return
			end
			number4 = 0
			pcall(callback25)
		end)
	end

	registerItem(callback26)
	espSection2 = espSection

	local espRanchEggsToggle, data, data2 = espSection2:CreateToggle({Name = "ESP Ranch Eggs", Default = false, Callback = function(argument)
		if argument then
			callback27()
		else
			callback26()
		end
	end}), data3, data3

	local weightSlider, espSection, espMinWeight = data2.WeightSlider, espSection, {Name = "ESP Min Weight", SubOf = espRanchEggsToggle}
	local function onRaw(argument)
		number3 = argument
	end
	espMinWeight.OnRaw = onRaw
	data.RanchEspWeight = weightSlider(espSection, espMinWeight)
end

callback23()

local function callback24()
	local value3 = bit32.bxor(238786159, 0)
	local mainWindow = mainWindow
	local predictorTab = mainWindow:CreateTab({Name = "Predictor", SectionsExpanded = true})
	mainWindow = data2
	mainWindow.WebhookSection = predictorTab:CreateSection({Name = "Webhook", Expanded = false})
	mainWindow = predictorTab:CreateSection({Name = "Egg Predictor", Expanded = true})
	local value4 = callback(function()
		local ReplicatedStorage = ReplicatedStorage
		return ReplicatedStorage.GameData.HatchLuck
	end)
	predictorTab = data
	local pets, eggsList, number3, number4, number5, number6, assetId = predictorTab.Pets, {"My Eggs", "On The Map", "All Eggs"}, 11, 36, 3, 8, "rbxassetid://90325592797235"
	local color = Color3.new(1, 1, 1)
	local color2 = Color3.new(0, 0, 0)
	local color3 = Color3.fromRGB(18, 18, 26)
	local color4 = Color3.fromRGB(62, 64, 84)
	local color5, data5 = Color3.fromRGB(196, 202, 222), {}
	predictorTab = Color3.fromRGB
	value3 = u32Trunc(value3 + 192954663)
	local value5, color3FromRGB = predictorTab(170, 255, 140), Color3.fromRGB
	value3 = u32Trunc(value3 - 139138825)
	do
		local _vals = table.pack(value5, color3FromRGB(40, 230, 90))
		table.move(_vals, 1, _vals.n, 1, data5)
	end
	local colorPalette = {Color3.fromRGB(255, 240, 150), Color3.fromRGB(255, 176, 30)}
	local function callback25(argument, argument2)
		local ok, response = pcall(Font.new, argument, argument2, Enum.FontStyle.Normal)
		return (ok and response) or nil
	end
	local json = callback25("rbxassetid://12187365977", Enum.FontWeight.Bold) or callback25("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular)
	local json2 = callback25("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium)
	local data6 = {Filter = eggsList[1], Selected = nil, Unit = 14, Width = 300, CardW = 120, CardH = 170}

	local function callback26(argument, argument2, parent)
		local instance = Instance.new(argument)
		for k, value6 in pairs(argument2) do
			instance[k] = value6
		end
		if parent then
			instance.Parent = parent
		end
		return instance
	end

	local function callback27(argument, argument2, rotation)
		local paint = argument:FindFirstChild("Paint")
		paint = if not paint then callback26("UIGradient", {Name = "Paint"}, argument) else paint
		paint.Color = ColorSequence.new(argument2[1], argument2[2])
		paint.Rotation = rotation or 90
		return paint
	end

	local function callback28(argument, fontFace, argument2, argument3)
		local TextLabel = callback26("TextLabel", {BackgroundTransparency = 1, Text = "", TextColor3 = color, TextScaled = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center}, argument)
		if fontFace then
			TextLabel.FontFace = fontFace
		else
			TextLabel.Font = Enum.Font.GothamBold
		end
		for k, value6 in pairs(argument2) do
			TextLabel[k] = value6
		end
		callback26("UITextSizeConstraint", {MaxTextSize = 16, MinTextSize = 1}, TextLabel)
		if argument3 then
			callback26("UIStroke", {Color = color2, Thickness = argument3, LineJoinMode = Enum.LineJoinMode.Round}, TextLabel)
		end
		return TextLabel
	end

	local function callback29(argument, maxTextSize)
		local uiTextSizeConstraint = argument:FindFirstChildOfClass("UITextSizeConstraint")
		maxTextSize = math.max(6, math.floor(maxTextSize))

		if uiTextSizeConstraint and (uiTextSizeConstraint.MaxTextSize ~= maxTextSize) then
			uiTextSizeConstraint.MaxTextSize = maxTextSize
			local uiStroke = argument:FindFirstChildOfClass("UIStroke")
			if uiStroke then
				uiStroke.Thickness = math.max(1, maxTextSize * 0.08)
			end
		end
	end

	local function callback30(argument, argument2, argument3)
		if argument[argument2] ~= argument3 then
			argument[argument2] = argument3
		end
	end

	local function toNumberOrDefault(argument)
		local unitSuffixes = {"", "K", "M", "B", "T", "Qa", "Qi", "Sx"}
		argument = tonumber(argument) or 0
		local number7 = 1
		while (argument >= 1000) and (number7 < #unitSuffixes) do
			argument, number7 = argument / 1000, number7 + 1
		end
		local text3 = ((number7 == 1) and tostring(math.floor(argument))) or string.format(((argument >= 100) and "%.0f") or "%.1f", argument)
		return string.gsub(text3, "%.0$", "") .. unitSuffixes[number7]
	end

	local function callback31(argument)
		argument = (tonumber(argument) or 0) * 100

		if argument >= 10 then
			return string.format("%.1f%%", argument)
		elseif argument >= 0.01 then
			return string.format("%.2f%%", argument)
		elseif argument > 0 then
			return "<0.01%"
		end

		return "0%"
	end

	local function callback32(argument)
		local data = data3
		return data.RarityColors[tostring(argument)] or color
	end

	local function callback33()
		local value6 = bit32.bxor(175629414, 0)
		local value = value6
		local number7 = 1
		value6 = u32Trunc((u32Mul(1653317106, value) + 1408919676) + (u32Mul(2641650191, (bit32.bor(value, 360366))) + u32Mul(2641650189, (bit32.band(value, 360366)))))
		value = nil
		value, value6 = pcall, bit32.bxor(value6, 94468160)
		value(function()
			local data, number8, value7, localPlayer2 = data3, tonumber(data3.Saved("HatchUpgrades")) or 0
			localPlayer2, number7 = localPlayer, value4.GetMultiplier(value4.EffectiveUpgrades(localPlayer, number8))
		end)
		local number8 = 1
		pcall(function()
			number8 = value4.EventMultiplier()
		end)
		local number9, number10 = tonumber(number7) or 1, tonumber(number8) or 1
		return number9, number10
	end

	local data7 = {}

	local function callback34(argument)
		local value6, value7 = callback33()
		local text3 = string.format("%s|%s|%s", tostring(argument), tostring(value6), tostring(value7))
		local data8 = data7[text3]
		if data8 then
			return data8
		end
		data8 = data3
		local argument2 = data8.EggData(argument)
		local data9 = {Name = tostring(argument), Rarity = (argument2 and tostring(argument2.Rarity)) or "Common", Image = (argument2 and tostring(argument2.Image or "")) or "", Luck = 0, Pets = {}, Average = 0, Best = nil}

		if argument2 and (type(value4) == "table") then
			local value8 = bit32.bxor(189316488, 0)
			argument = value8
			data8 = nil
			data8, value8 = pcall, u32Trunc((u32Mul(578687298, argument) + 2924362980) + (u32Mul(3716279999, (bit32.bor(429264690, argument))) + u32Mul(3716279997, (bit32.band(argument, 429264690)))))

			data8(function()
				local value9 = bit32.bxor(220743288, 0)
				local value = value9
				local luck = math.max((tonumber(argument2.Luck) or 1) * value6, 1)
				data9.Luck = luck
				local getBoostedOdds, luck2 = value4.GetBoostedOdds, data9.Luck
				value9 = u32Trunc(value + 273143996)

				for i, value10 in ipairs((getBoostedOdds(luck2, value7, argument2))) do
					i = tonumber(value10.Chance) or 0

					if i > 0 then
						value = ((type(pets) == "table") and pets[value10.PetName]) or nil
						local best = {Name = tostring(value10.PetName), Chance = i, Rarity = (value and tostring(value.Rarity)) or "Common", Image = (value and tostring(value.Image or "")) or "", Income = (value and tonumber(value.Income)) or 0}
						table.insert(data9.Pets, best)
						data9.Average = data9.Average + (i * best.Income)
						if not data9.Best or (best.Income > data9.Best.Income) then
							data9.Best = best
						end
					end
				end

				luck2, value = table.sort, u32Trunc(luck)
				value9 = u32Trunc((4017619795 + value9) + (u32Mul(4290365467, value) + u32Mul(4290365467, (bit32.bnot(value)))))
				luck2(data9.Pets, function(argument3, argument4)
					if argument3.Chance ~= argument4.Chance then
						return argument3.Chance > argument4.Chance
					end
					return argument3.Name < argument4.Name
				end)
			end)
		end

		data7[text3] = data9
		return data9
	end

	local function callback35()
		local value6, list, data8 = bit32.bxor(350111907, 0), {}, {Mine = 0}
		value6 = u32Trunc(value6 + 11064279)
		data8.Map = 0
		local data2 = data3
		local timer = data2.Plot()
		local eggs, list2, data4 = timer and (timer:FindFirstChild("Eggs")), {}, ipairs
		data2 = (eggs and eggs:GetChildren()) or {}

		for k, value in data4(data2) do
			timer = value:FindFirstChild("Timer", true)
			eggs = ((timer and timer:IsA("TextLabel")) and timer.Text) or ""
			k = eggs == "Ready"
			table.insert(list2, {Id = "plot:" .. tostring(value:GetAttribute("EggKey") or value.Name), Egg = value.Name, Badge = (k and "READY") or (((eggs ~= "") and eggs) or "GROWING"), BadgeColor = (k and Color3.fromRGB(77, 255, 122)) or Color3.fromRGB(255, 194, 77), Note = "Placed", Mutation = (((type(value:GetAttribute("Mutation")) == "string") and (value:GetAttribute("Mutation") ~= "")) and value:GetAttribute("Mutation")) or nil, Order = (k and 0) or 1})
			k = #list2
			local value7 = list2[k]
			value = value7.Mutation

			if value then
				local value8 = bit32.bxor(426866428, 0)
				local value = value8
				local data2 = data3
				value7.Factor = data2.MutationBonus(value7.Mutation)
				local stringFormat, mutation, value9, value2, value10 = string.format, value7.Mutation, table.pack(tostring(value7.Factor)), value, u32Trunc(k)
				value8 = u32Trunc((204350477 + u32Mul(223057481, value2)) + (u32Mul(223057480, value10) + (u32Mul(3848852336, (bit32.bor(value2, value10))) + u32Mul(223057480, (bit32.bxor(value10, value2))))))
				value7.Note = stringFormat("%s x%s", mutation, table.unpack(value9, 1, value9.n))
				value7.MutationColor = Color3.fromRGB(255, 194, 77)
				value = pcall

				local function callback36()
					local data = data
					local mutation2 = data.Mutations.ColorFor(value7.Mutation)
					if typeof(mutation2) == "Color3" then
						value7.MutationColor = mutation2
					end
				end

				value(callback36)
			end
		end

		data2, timer, data4, eggs = #list2, {}, data3, 0
		for _, value7 in ipairs(data4.Tools("Egg")) do
			eggs += 1
			timer[value7.Name] = (timer[value7.Name] or 0) + 1
		end
		for k, value7 in pairs(timer) do
			local insert, data9 = table.insert, {Id = "bag:" .. k, Egg = k, Badge = "BAG x" .. value7, BadgeColor = Color3.fromRGB(127, 216, 255)}
			data9.Note, data9.Order = ((value7 == 1) and "In your bag") or (value7 .. " in your bag"), 2
			insert(list2, data9)
		end
		data8.Mine = data2 + eggs
		timer, eggs = {}, data3
		data2 = eggs.Root()
		data4 = activeEggs

		for i, child in ipairs(data4:GetChildren()) do
			i, eggs = child:GetAttribute("Egg"), child:GetAttribute("Position")

			if type(i) == "string" then
				data8.Map = data8.Map + 1
				child = timer[i]
				if not child then
					child = {Count = 0, Nearest = 1 / 0}
					timer[i] = child
				end
				child.Count = child.Count + 1
				if data2 and (typeof(eggs) == "Vector3") then
					child.Nearest = math.min(child.Nearest, (eggs - data2.Position).Magnitude)
				end
			end
		end

		eggs = data6.Filter == eggsList[1]

		if eggs then
			list = list2
		else
			data2 = data6.Filter == eggsList[2]

			if data2 then
				for k, value7 in pairs(timer) do
					local insert, data9 = table.insert, {Id = "map:" .. k, Egg = k, Badge = "x" .. value7.Count, BadgeColor = Color3.fromRGB(255, 154, 61)}
					data9.Note, data9.Order = ((value7.Nearest < (1 / 0)) and string.format("Nearest %d studs", math.floor(value7.Nearest))) or "On the map", 0
					insert(list, data9)
				end
			else
				data4 = names
				for _, value7 in ipairs(data4) do
					table.insert(list, {Id = "all:" .. value7, Egg = value7, Badge = (timer[value7] and ("x" .. timer[value7].Count)) or "", BadgeColor = Color3.fromRGB(255, 154, 61), Note = (timer[value7] and "On the map now") or "Not on the map", Order = 0})
				end
			end
		end

		for _, value7 in ipairs(list) do
			value7.Info = callback34(value7.Egg)
		end

		table.sort(list, function(argument, argument2)
			if argument.Order ~= argument2.Order then
				return argument.Order < argument2.Order
			end

			if argument.Info.Luck ~= argument2.Info.Luck then
				return argument.Info.Luck > argument2.Info.Luck
			end
			return argument.Id < argument2.Id
		end)

		return list, data8
	end

	local configMap = {Cards = {}, Chips = {}, Tiles = {}, HeroPets = {}}
	local argument4
	local condition2, number7 = true, 0

	local function callback36(argument)
		local data8 = {Frame = callback26("Frame", {BackgroundTransparency = 1}, argument)}
		data8.Icon = callback26("ImageLabel", {BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, Size = UDim2.fromScale(0.16, 1)}, data8.Frame)
		data8.Name = callback28(data8.Frame, json, {Position = UDim2.fromScale(0.19, 0), Size = UDim2.fromScale(0.46, 0.62)}, 1.2)
		data8.Chance = callback28(data8.Frame, json, {Position = UDim2.fromScale(0.65, 0), Size = UDim2.fromScale(0.35, 0.62), TextXAlignment = Enum.TextXAlignment.Right}, 1.2)
		data8.Back = callback26("Frame", {BackgroundColor3 = Color3.fromRGB(42, 46, 60), BorderSizePixel = 0, Position = UDim2.fromScale(0.19, 0.72), Size = UDim2.fromScale(0.81, 0.16)}, data8.Frame)
		callback26("UICorner", {CornerRadius = UDim.new(1, 0)}, data8.Back)
		data8.Fill = callback26("Frame", {BackgroundColor3 = color, BorderSizePixel = 0, Size = UDim2.fromScale(0, 1)}, data8.Back)
		callback26("UICorner", {CornerRadius = UDim.new(1, 0)}, data8.Fill)
		return data8
	end

	local function clampValue(argument, argument2)
		callback30(argument.Frame, "Visible", argument2 ~= nil)
		if not argument2 then
			return
		end
		local value6 = callback32(argument2.Rarity)
		callback30(argument.Icon, "Image", argument2.Image)
		callback30(argument.Name, "Text", argument2.Name)
		callback30(argument.Name, "TextColor3", value6)
		callback30(argument.Chance, "Text", callback31(argument2.Chance))
		callback30(argument.Fill, "BackgroundColor3", value6)
		callback30(argument.Fill, "Size", UDim2.fromScale(math.clamp(argument2.Chance, 0.02, 1), 1))
	end

	local function callback37(argument)
		local value6 = bit32.bxor(268897540, 0)
		local value = value6
		local data8 = {Rows = {}, Frame = callback26("Frame", {BackgroundColor3 = color3, BackgroundTransparency = 0.04, BorderSizePixel = 0, LayoutOrder = argument, Visible = false}, configMap.Grid)}
		callback26("UICorner", {CornerRadius = UDim.new(0.07, 0)}, data8.Frame)
		value6 = u32Trunc((u32Mul(2325630253, value) + 4076967506) + (u32Mul(2, (bit32.bor(value, 217999790))) + (2325630254 + u32Mul(2325630254, (bit32.bnot(value))))))
		data8.Stroke = callback26("UIStroke", {Color = color4, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, data8.Frame)
		data8.Glow = callback26("Frame", {BackgroundColor3 = color, BackgroundTransparency = 0.55, BorderSizePixel = 0, Size = UDim2.fromScale(1, 0.46)}, data8.Frame)
		callback26("UICorner", {CornerRadius = UDim.new(0.14, 0)}, data8.Glow)
		callback26("UIGradient", {Rotation = 90, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1)})}, data8.Glow)
		local callback, data9, uDim2FromOffset = callback26, {BackgroundTransparency = 1, Image = assetId, ImageTransparency = 0.93, ScaleType = Enum.ScaleType.Tile}, UDim2.fromOffset
		value6 = bit32.bxor(value6, 258049008)
		data9.TileSize = uDim2FromOffset(44, 44)
		data9.Size = UDim2.fromScale(1, 1)
		callback("ImageLabel", data9, data8.Frame)
		data8.Image = callback26("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0), BackgroundTransparency = 1, Position = UDim2.fromScale(0.5, 0.03), ScaleType = Enum.ScaleType.Fit, Size = UDim2.fromScale(0.62, 0.3)}, data8.Frame)
		data8.BadgeBack = callback26("Frame", {BackgroundColor3 = color3, BackgroundTransparency = 0.1, BorderSizePixel = 0, Position = UDim2.fromScale(0.04, 0.03), Size = UDim2.fromScale(0.44, 0.075)}, data8.Frame)
		callback26("UICorner", {CornerRadius = UDim.new(0.4, 0)}, data8.BadgeBack)
		data8.BadgeStroke = callback26("UIStroke", {Color = color, Thickness = 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, data8.BadgeBack)
		data8.Badge = callback28(data8.BadgeBack, json, {Size = UDim2.fromScale(1, 1), TextXAlignment = Enum.TextXAlignment.Center}, nil)
		data8.Mutation = callback28(data8.Frame, json, {Position = UDim2.fromScale(0.5, 0.03), Size = UDim2.fromScale(0.46, 0.075), TextXAlignment = Enum.TextXAlignment.Right, Visible = false}, 1.4)
		value6 = bit32.bxor(value6, 237503935)
		data8.Name = callback28(data8.Frame, json, {Position = UDim2.fromScale(0.05, 0.34), Size = UDim2.fromScale(0.9, 0.085), TextXAlignment = Enum.TextXAlignment.Center}, 1.5)
		data8.Luck = callback28(data8.Frame, json, {Position = UDim2.fromScale(0.05, 0.425), Size = UDim2.fromScale(0.9, 0.065), TextXAlignment = Enum.TextXAlignment.Center}, 1.2)
		callback27(data8.Luck, data5, 90)
		for i = 1, number5, 1 do
			uDim2FromOffset = callback36(data8.Frame)
			uDim2FromOffset.Frame.Position = UDim2.fromScale(0.06, 0.51 + ((i - 1) * 0.125))
			uDim2FromOffset.Frame.Size = UDim2.fromScale(0.88, 0.11)
			data8.Rows[i] = uDim2FromOffset
		end
		data8.Average = callback28(data8.Frame, json, {Position = UDim2.fromScale(0.05, 0.895), Size = UDim2.fromScale(0.9, 0.07), TextXAlignment = Enum.TextXAlignment.Center}, 1.2)
		callback27(data8.Average, colorPalette, 90)
		data8.Button = callback26("TextButton", {AutoButtonColor = false, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Text = "", ZIndex = 10}, data8.Frame)
		callback = data8.Button.Activated

		local function callback38()
			local id = data8.Id

			if id then
				if data6.Selected == data8.Id then
					data6.Selected = nil
					data6.Dismissed = true
				else
					data6.Selected = data8.Id
					data6.Dismissed = false
				end

				condition2 = true
			end
		end

		callback:Connect(callback38)
		return data8
	end

	local function callback38(argument)
		local cardH = data6.CardH
		callback29(argument.Badge, cardH * 0.05)
		callback29(argument.Mutation, cardH * 0.05)
		callback29(argument.Name, cardH * 0.072)
		callback29(argument.Luck, cardH * 0.056)
		callback29(argument.Average, cardH * 0.056)
		for _, row in ipairs(argument.Rows) do
			callback29(row.Name, cardH * 0.058)
			callback29(row.Chance, cardH * 0.058)
		end
	end

	local function callback39(argument, argument2)
		argument.Id = (argument2 and argument2.Id) or nil
		callback30(argument.Frame, "Visible", argument2 ~= nil)
		if not argument2 then
			return
		end
		local info = argument2.Info
		local value6, condition3 = callback32(info.Rarity), data6.Selected == argument2.Id
		callback30(argument.Glow, "BackgroundColor3", value6)
		callback30(argument.Stroke, "Color", (condition3 and Color3.fromRGB(255, 214, 90)) or value6:Lerp(color4, 0.55))
		callback30(argument.Stroke, "Thickness", (condition3 and math.max(2.5, data6.CardH * 0.012)) or 1.5)
		callback30(argument.Image, "Image", info.Image)
		callback30(argument.Name, "Text", info.Name)
		callback30(argument.Name, "TextColor3", value6)
		callback30(argument.Luck, "Text", "LUCK " .. toNumberOrDefault(info.Luck))
		callback30(argument.BadgeBack, "Visible", argument2.Badge ~= "")
		callback30(argument.Badge, "Text", argument2.Badge)
		callback30(argument.Badge, "TextColor3", argument2.BadgeColor)
		callback30(argument.BadgeStroke, "Color", argument2.BadgeColor)
		callback30(argument.Mutation, "Visible", argument2.Mutation ~= nil)
		if argument2.Mutation then
			callback30(argument.Mutation, "Text", argument2.Mutation)
			callback30(argument.Mutation, "TextColor3", argument2.MutationColor)
		end
		for i, row in ipairs(argument.Rows) do
			clampValue(row, info.Pets[i])
		end
		callback30(argument.Average, "Text", "AVG $" .. (toNumberOrDefault(info.Average * (argument2.Factor or 1)) .. "/s"))
	end

	local function callback40(argument)
		local hero, heroShown = configMap.Hero, argument ~= nil
		local condition3 = configMap.HeroShown ~= heroShown

		if condition3 then
			local value6 = bit32.bxor(428512900, 0)
			local value = value6
			value6 = bit32.bxor(value, 227777552)
			configMap.HeroShown = heroShown
			value6 = u32Trunc((u32Mul(1638559932, value6) + 3829936748) + (u32Mul(1017847432, (bit32.bor(value6, 306552661))) + u32Mul(1638559933, (bit32.bxor(value6, 306552661)))))
			pcall(function()
				argument4:SetDock((heroShown and number3) or 0, {Gap = 0.35, Divider = false})
			end)
		end

		callback30(hero.Frame, "Visible", heroShown)
		if not argument then
			return
		end
		condition3 = argument.Info
		local best = callback32(condition3.Rarity)
		callback30(hero.Art, "BackgroundColor3", best)
		callback30(hero.Stroke, "Color", best:Lerp(color4, 0.4))
		callback30(hero.Image, "Image", condition3.Image)
		callback30(hero.Name, "Text", condition3.Name)
		callback30(hero.Name, "TextColor3", best)
		callback30(hero.Rarity, "Text", string.upper(condition3.Rarity) .. ("  |  " .. argument.Note))
		callback30(hero.Luck, "Text", "LUCK " .. toNumberOrDefault(condition3.Luck))
		callback30(hero.Average, "Text", "AVG $" .. (toNumberOrDefault(condition3.Average * (argument.Factor or 1)) .. "/s"))
		best = condition3.Best
		callback30(hero.Best, "Text", (best and ("BEST  " .. (best.Name .. ("  " .. callback31(best.Chance))))) or "")
		callback30(hero.Best, "TextColor3", (best and callback32(best.Rarity)) or color)
		for i, heroPet in ipairs(configMap.HeroPets) do
			clampValue(heroPet, condition3.Pets[i])
		end
	end

	local function callback41()
		local value6 = bit32.bxor(511123379, 0)
		local value = value6
		value6 = u32Trunc((u32Mul(4294967295, value) + 1150367131) + (u32Mul(2, (bit32.bor(value, 465778263))) + (1825720414 + 853101488)))
		if not configMap.Grid then
			return
		end
		local response3, response4
		local number8, number9 = 1, 1
		value6 = bit32.bxor(value6, 114576629)

		task.spawn(function()
			local ok, response, response2 = pcall(callback35)
			if ok then
				response3, response4 = response, response2
			end
			ok, response2, response = pcall(callback33)
			if ok then
				number8, number9 = response2, response
			end
		end)

		value = not response3 or not response4
		if value then
			return
		end
		callback30(configMap.Tiles[1].Value, "Text", "x" .. (toNumberOrDefault(number8) .. (((number9 > 1) and ("  x" .. toNumberOrDefault(number9))) or "")))
		callback30(configMap.Tiles[2].Value, "Text", tostring(response4.Mine))
		callback30(configMap.Tiles[3].Value, "Text", tostring(response4.Map))
		for i, chip in ipairs(configMap.Chips) do
			i = chip.Key == data6.Filter
			callback30(chip.Button, "BackgroundTransparency", (i and 0) or 0.35)
			callback27(chip.Button, (i and data5) or {Color3.fromRGB(46, 48, 62), Color3.fromRGB(30, 32, 44)}, 90)
		end
		value = data6.Selected

		if value then
			local response, condition3 = response3, false
			for _, value7 in ipairs(response) do
				if value7.Id == data6.Selected then
					condition3 = true
					break
				end
			end
			if not condition3 then
				data6.Selected = nil
			end
		end

		value = not data6.Selected and not data6.Dismissed

		if value then
			local response = response3
			local value7
			for _, value8 in ipairs(response) do
				value7 = if not value7 or (value8.Info.Average > value7.Info.Average) then value8 else value7
			end
			data6.Selected = (value7 and value7.Id) or nil
		end

		local value2, cards, value7 = ipairs, configMap.Cards
		for k, card in value2(cards) do
			value = response3[k]
			callback39(card, value)
			value7 = if value and (value.Id == data6.Selected) then value else value7
		end
		cards = data6.Selected and not value7

		if cards then
			value = response3
			for _, value8 in ipairs(value) do
				if value8.Id == data6.Selected then
					value7 = value8
					break
				end
			end
		end

		callback30(configMap.Empty, "Visible", #response3 == 0)
		callback30(configMap.Empty, "Text", ((data6.Filter == eggsList[1]) and "No eggs yet. Place an egg or pick one up to see its pets.") or "No eggs on the map right now.")
		callback30(configMap.Footer, "Text", ((#response3 > number4) and string.format("Showing %d of %d", number4, #response3)) or "Tap an egg to see every pet it can hatch")
		callback40(value7)
	end

	local function callback42()
		if not configMap.Grid then
			return
		end
		local unit, width = data6.Unit, data6.Width
		local number8, number9 = math.max(4, math.floor(unit * 0.3)), math.max(8, math.floor(unit * 0.6))
		local number10 = math.max(1, (width - (number8 * 2)) - math.max(6, math.floor(width * 0.012)))
		configMap.Container.Position = UDim2.fromOffset(number8, number8)
		configMap.Container.Size = UDim2.new(0, number10, 0, 0)
		configMap.Container:FindFirstChildOfClass("UIListLayout").Padding = UDim.new(0, number9)
		width = math.clamp(math.floor((number10 + number9) / ((unit * 8.4) + number9)), 3, 6)
		local cardW = math.floor((number10 - (number9 * (width - 1))) / width)
		width = math.floor(cardW * 1.62)
		data6.CardW = cardW
		data6.CardH = width
		local uiGridLayout = configMap.Grid:FindFirstChildOfClass("UIGridLayout")
		uiGridLayout.CellSize = UDim2.fromOffset(cardW, width)
		uiGridLayout.CellPadding = UDim2.fromOffset(number9, number9)
		configMap.TileRow.Size = UDim2.new(1, 0, 0, math.floor(unit * 2.7))
		configMap.ChipRow.Size = UDim2.new(1, 0, 0, math.floor(unit * 2))
		for _, tile in ipairs(configMap.Tiles) do
			callback29(tile.Value, unit * 1.2)
			callback29(tile.Caption, unit * 0.72)
		end
		for _, chip in ipairs(configMap.Chips) do
			callback29(chip.Label, unit * 0.92)
		end
		callback29(configMap.Empty, unit)
		configMap.Empty.Size = UDim2.new(1, 0, 0, math.floor(unit * 2.4))
		callback29(configMap.Footer, unit * 0.75)
		configMap.Footer.Size = UDim2.new(1, 0, 0, math.floor(unit * 1.4))
		for _, card in ipairs(configMap.Cards) do
			callback38(card)
		end
		number9, cardW = configMap.Hero, (number3 * unit) - (number8 * 2)
		number9.Frame.Position = UDim2.fromOffset(number8, number8)
		number9.Frame.Size = UDim2.new(0, number10, 0, cardW)
		callback29(number9.Name, cardW * 0.13)
		callback29(number9.Rarity, cardW * 0.075)
		callback29(number9.Luck, cardW * 0.095)
		callback29(number9.Average, cardW * 0.095)
		callback29(number9.Best, cardW * 0.085)
		for _, heroPet in ipairs(configMap.HeroPets) do
			callback29(heroPet.Name, cardW * 0.115)
			callback29(heroPet.Chance, cardW * 0.115)
		end
		condition2 = true
	end

	local function callback43(argument)
		local value6 = bit32.bxor(423980799, 0)
		local value = value6
		argument4 = argument
		configMap.Container = callback26("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Size = UDim2.fromScale(1, 0)}, nil)
		callback26("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Vertical}, configMap.Container)
		configMap.TileRow = callback26("Frame", {BackgroundTransparency = 1, LayoutOrder = 1}, configMap.Container)
		callback26("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, configMap.TileRow)
		local callback, data8 = ipairs, {{"HATCH LUCK", data5}, {"MY EGGS", {color, Color3.fromRGB(190, 200, 225)}}, {"ON THE MAP", {Color3.fromRGB(255, 214, 140), Color3.fromRGB(255, 154, 61)}}}

		for k, value7 in callback(data8) do
			local data9 = {Frame = callback26("Frame", {BackgroundColor3 = color3, BackgroundTransparency = 0.12, BorderSizePixel = 0, LayoutOrder = k, Size = UDim2.new(0.3333333333333333, -6, 1, 0)}, configMap.TileRow)}
			callback26("UICorner", {CornerRadius = UDim.new(0.22, 0)}, data9.Frame)
			callback26("UIStroke", {Color = color4, Thickness = 1.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, data9.Frame)
			data9.Value = callback28(data9.Frame, json, {Position = UDim2.fromScale(0.08, 0.1), Size = UDim2.fromScale(0.84, 0.5)}, 1.4)
			callback27(data9.Value, value7[2], 90)
			data9.Caption = callback28(data9.Frame, json2, {Position = UDim2.fromScale(0.08, 0.6), Size = UDim2.fromScale(0.84, 0.3), Text = value7[1], TextColor3 = color5}, nil)
			configMap.Tiles[k] = data9
		end

		configMap.ChipRow = callback26("Frame", {BackgroundTransparency = 1, LayoutOrder = 2}, configMap.Container)
		callback26("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder}, configMap.ChipRow)

		for i, value7 in ipairs(eggsList) do
			local value8, data9 = bit32.bxor(105326462, 0), {Key = value7}
			value8 = bit32.bxor(value8, 373089910)
			data8 = nil
			data8, value8 = {AutoButtonColor = false, BackgroundColor3 = color, BorderSizePixel = 0, LayoutOrder = i, Size = UDim2.new(0.3333333333333333, -6, 1, 0), Text = ""}, bit32.bxor(value8, 244140780)
			data9.Button = callback26("TextButton", data8, configMap.ChipRow)
			callback = callback26
			value8 = bit32.bxor(value8, 176468286)
			value8 = bit32.bxor(value8, 78134308)
			callback("UICorner", {CornerRadius = UDim.new(0.35, 0)}, data9.Button)
			local data10, button
			data10, button, value8 = {Color = color2, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, data9.Button, bit32.bxor(value8, 94752596)
			callback26("UIStroke", data10, button)
			button = callback28
			value8 = bit32.bxor(value8, 152903452)
			local button2, textLabel, uDim2FromScale = data9.Button, {}, UDim2.fromScale
			value8 = bit32.bxor(value8, 128195870)
			textLabel.Size = uDim2FromScale(1, 1)
			textLabel.Text = string.upper(value7)
			textLabel.TextXAlignment = Enum.TextXAlignment.Center
			value8 = bit32.bxor(value8, 276761407)
			value8 = bit32.bxor(value8, 385721846)
			data9.Label = button(button2, json, textLabel, 1.4)
			textLabel = data9.Button.Activated
			local function callback44()
				data6.Filter = value7
				data6.Selected = nil
				data6.Dismissed = false
				condition2 = true
			end
			textLabel:Connect(callback44)
			configMap.Chips[i] = data9
		end

		configMap.Empty = callback28(configMap.Container, json2, {LayoutOrder = 3, TextColor3 = color5, TextXAlignment = Enum.TextXAlignment.Center, Visible = false}, nil)
		configMap.Grid = callback26("Frame", {AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 4, Size = UDim2.fromScale(1, 0)}, configMap.Container)
		callback26("UIGridLayout", {SortOrder = Enum.SortOrder.LayoutOrder, CellSize = UDim2.fromOffset(120, 190)}, configMap.Grid)
		for i = 1, number4, 1 do
			configMap.Cards[i] = callback37(i)
		end
		configMap.Footer = callback28(configMap.Container, json2, {LayoutOrder = 5, TextColor3 = color5, TextXAlignment = Enum.TextXAlignment.Center}, nil)
		callback = {Frame = callback26("Frame", {BackgroundColor3 = color3, BackgroundTransparency = 0.04, BorderSizePixel = 0, Visible = false}, nil)}
		callback26("UICorner", {CornerRadius = UDim.new(0.08, 0)}, callback.Frame)
		callback.Stroke = callback26("UIStroke", {Color = color4, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, callback.Frame)
		-- This Source Was Generated by discord.gg/c3xVMnUUBv
		callback26("ImageLabel", {BackgroundTransparency = 1, Image = assetId, ImageTransparency = 0.94, ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.fromOffset(46, 46), Size = UDim2.fromScale(1, 1)}, callback.Frame)
		callback.Art = callback26("Frame", {BackgroundColor3 = color, BackgroundTransparency = 0.5, BorderSizePixel = 0, Size = UDim2.fromScale(0.22, 1)}, callback.Frame)
		callback26("UICorner", {CornerRadius = UDim.new(0.08, 0)}, callback.Art)
		callback26("UIGradient", {Rotation = 0, Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.1), NumberSequenceKeypoint.new(1, 1)})}, callback.Art)
		callback.Image = callback26("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, Position = UDim2.fromScale(0.11, 0.42), ScaleType = Enum.ScaleType.Fit, Size = UDim2.fromScale(0.18, 0.7)}, callback.Frame)
		callback.Name = callback28(callback.Frame, json, {Position = UDim2.fromScale(0.015, 0.78), Size = UDim2.fromScale(0.2, 0.16), TextXAlignment = Enum.TextXAlignment.Center}, 1.6)
		local callback2, frame, value, value7 = callback28, callback.Frame, value, u32Trunc(number4)
		value6 = u32Trunc((2763770037 + value) + (u32Mul(2432363701, value7) + u32Mul(2432363701, (bit32.bnot(value7)))))
		value7 = u32Trunc(number4)
		value6 = u32Trunc((3913732723 + value6) + (u32Mul(3834349822, value7) + u32Mul(3834349822, (bit32.bnot(value7)))))
		callback.Rarity = callback2(frame, json2, {Position = UDim2.fromScale(0.235, 0.05), Size = UDim2.fromScale(0.2, 0.1), TextColor3 = color5}, nil)
		callback.Luck = callback28(callback.Frame, json, {Position = UDim2.fromScale(0.235, 0.16), Size = UDim2.fromScale(0.2, 0.13)}, 1.4)
		callback27(callback.Luck, data5, 90)
		callback.Average = callback28(callback.Frame, json, {Position = UDim2.fromScale(0.235, 0.3), Size = UDim2.fromScale(0.2, 0.13)}, 1.4)
		callback27(callback.Average, colorPalette, 90)
		callback.Best = callback28(callback.Frame, json, {Position = UDim2.fromScale(0.235, 0.45), Size = UDim2.fromScale(0.2, 0.12)}, 1.4)
		callback.Hint = callback28(callback.Frame, json2, {Position = UDim2.fromScale(0.235, 0.62), Size = UDim2.fromScale(0.2, 0.32), Text = "Chances use your Hatch Luck. The pet is rolled when the egg hatches.", TextColor3 = color5, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top}, nil)
		callback.Hint:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = 12
		callback.List = callback26("Frame", {BackgroundTransparency = 1, Position = UDim2.fromScale(0.455, 0.05), Size = UDim2.fromScale(0.53, 0.9)}, callback.Frame)
		callback26("UIGridLayout", {CellPadding = UDim2.fromScale(0.04, 0.03), CellSize = UDim2.fromScale(0.48, 0.225), SortOrder = Enum.SortOrder.LayoutOrder}, callback.List)
		for i = 1, number6, 1 do
			callback2 = callback36(callback.List)
			callback2.Frame.LayoutOrder = i
			configMap.HeroPets[i] = callback2
		end
		configMap.Hero = callback
		argument:Attach(callback.Frame, argument:Dock())
		argument:Attach(configMap.Container, argument:Root())
		local function callback44(_, argument2, argument3)
			data6.Width = tonumber(argument2) or data6.Width
			data6.Unit = math.max(8, tonumber(argument3) or data6.Unit)
			pcall(callback42)
		end
		argument:OnResize(callback44)
		pcall(callback42)
	end

	local callback25_2 = type(mainWindow.CreateCanvas) ~= "function"

	if callback25_2 then
		mainWindow:CreateText({Name = "Egg Predictor", Text = "This library version cannot draw the predictor."})
	else
		local value6 = bit32.bxor(141097280, 0)
		local eggPredictor = {Name = "Egg Predictor", ShowTitle = false, Layout = "free", Style = {TextScale = 0.84, LineHeight = 1.1, MinLines = 16, MaxLines = 34, BackgroundTransparency = 0.5, ScrollBarColor = Color3.fromRGB(170, 174, 184), TextColor = Color3.fromRGB(255, 255, 255), TextStrokeTransparency = 0.7}}
		value6 = u32Trunc(value6 + 517258551)
		eggPredictor.Build = function(argument)
			callback43(argument)
		end
		local value7 = mainWindow:CreateCanvas(eggPredictor)
		predictorTab = RunService

		local connection = predictorTab.Heartbeat:Connect(function(deltaTime)
			local condition3 = not configMap.Container
			local condition
			if condition3 then
				condition = condition3
			else
				local gameRef = game
				condition = not configMap.Container:IsDescendantOf(gameRef)
			end
			if condition then
				return
			end
			condition3, condition = configMap.Container, true

			while condition3 and (condition3:IsA("GuiObject")) do
				if not condition3.Visible then
					condition = false
					break
				end
				condition3 = condition3.Parent
			end

			if not condition then
				return
			end
			number7 += deltaTime
			deltaTime = condition2 or (number7 >= 1)
			if deltaTime then
				condition2, number7 = false, 0
				pcall(callback41)
			end
		end)

		registerItem(function()
			local value8 = bit32.bxor(29421705, 0)
			local value = value8
			value8 = u32Trunc(value + 50144572)
			connection:Disconnect()
			value = nil
			value, value8 = pcall, u32Trunc(value8 + 56414535)
			value(function()
				value7:Destroy()
			end)
		end)
	end
end

callback24()
local serverSection = mainWindow:CreateTab({ Name = "Server", SectionsExpanded = true }):CreateSection({ Name = "Server", Expanded = true })
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function callback25()
	local value3, text3 = bit32.bxor(232597168, 0), "__ChilliAutoLoadScriptEnabled"
	value3 = bit32.bxor(value3, 325957370)
	local text4 = "local TeleportService = game:GetService(\"TeleportService\")\nlocal enabled = true\npcall(function()\n    enabled = TeleportService:GetTeleportSetting(\"__ChilliAutoLoadScriptEnabled\") == true\nend)\nif enabled then\n    local ok, source = pcall(function()\n        return game:HttpGet(\"https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua\")\n    end)\n    if ok and type(source) == \"string\" then\n        local chunk = loadstring(source)\n        if chunk then\n            chunk()\n        end\n    end\nend\n"
	value3 = u32Trunc((u32Mul(703498875, value3) + 2984697857) + (u32Mul(2887969546, (bit32.bor(value3, 147612851))) + u32Mul(703498876, (bit32.bxor(value3, 147612851)))))

	local function callback26()
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

	local function callback27(argument)
		local value4 = bit32.bxor(262480460, 0)
		local value = value4
		local value2
		value2, value4 = pcall, u32Trunc(value + 491315777)
		value2(function()
			local TeleportService = TeleportService
			TeleportService:SetTeleportSetting(text3, argument)
		end)
		if not argument then
			return true
		end
		value2 = callback26()
		if not value2 then
			return false
		end
		if rawget(_G, "__ChilliAutoLoadQueued") ~= true then
			if not pcall(value2, text4) then
				return false
			end
			_G.__ChilliAutoLoadQueued = true
		end
		return true
	end

	local autoLoadScriptToggle, callback28, value4

	callback28 = function()
		local autoLoadScriptToggle2 = autoLoadScriptToggle
		local autoLoadScriptToggle3
		if autoLoadScriptToggle2 then
			local data = data2
			autoLoadScriptToggle3 = data.Toggle(autoLoadScriptToggle, false)
		else
			autoLoadScriptToggle3 = autoLoadScriptToggle2
		end
		if autoLoadScriptToggle3 then
			callback27(true)
		end
	end

	local serverSection2 = serverSection

	autoLoadScriptToggle = serverSection2:CreateToggle({Name = "Auto Load Script", Default = true, Callback = function(argument)
		local condition2 = argument == true
		argument = not callback27(condition2) and condition2

		if argument then
			local condition3 = bit32.bxor(232910025, 0)
			condition2 = condition3
			local value = task
			condition3 = bit32.bxor(condition2, 5289006)
			local defer = value.defer
			condition3 = u32Trunc((u32Mul(44927722, condition3) + 1147102432) + (u32Mul(4250039575, (bit32.bor(condition3, 226486960))) + u32Mul(4250039573, (bit32.band(condition3, 226486960)))))

			defer(function()
				callback27(false)
				if autoLoadScriptToggle and (type(autoLoadScriptToggle.Set) == "function") then
					pcall(autoLoadScriptToggle.Set, autoLoadScriptToggle, false, false)
				end
				callback6("Auto Load Unavailable", "This executor does not support queue on teleport.")
			end)
		end
	end})

	local text5, number3, number4, number5, number6, id = "Least Players", 10, 0.1, 1, 0
	local argumentMap, condition2, number7, condition3, value = {}, false, 0, false
	local text6, number8, number9 = "", 0, 60
	local function callback29(argument)
		number6, id = 0, nil
		if argument then
			argumentMap[argument] = true
		end
	end

	local function callback30()
		local value5 = bit32.bxor(455388289, 0)
		local value = value5
		local TeleportService = TeleportService
		value5 = u32Trunc(value + 226094834)
		value = nil
		value, value5 = TeleportService.TeleportInitFailed, u32Trunc(value5 + 199402393)

		value:Connect(function(argument, argument2, argument3)
			argument = id
			if not argument then
				return
			end
			argument = id
			callback29(argument)
			condition3 = true
			argument = not condition2
			if argument then
				callback6("Server Hop Failed", tostring(((argument3 ~= "") and argument3) or argument2))
			end
		end)
	end

	pcall(callback30)

	local function callback31(argument)
		local text7, list, condition4, text8 = tostring(game.JobId or ""), {}, argument == "Random", ((argument == "Least Players") and "Asc") or "Desc"
		local condition5 = (condition4 and 3) or 6
		local nextPageCursor

		for i = 1, condition5, 1 do
			local value5 = bit32.bxor(89064137, 0)
			i = value5
			argument = string
			value5 = u32Trunc(i + 163763672)
			local format, gameRef, number10 = argument.format, game, u32Trunc(condition5)
			value5 = u32Trunc((2074417487 + value5) + (u32Mul(2138141206, number10) + u32Mul(2138141206, (bit32.bnot(number10)))))
			local text9 = format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100", gameRef.PlaceId, text8)
			local nextPageCursor2 = nextPageCursor and (nextPageCursor ~= "")
			local value6
			if nextPageCursor2 then
				gameRef = nil
				gameRef, text9 = HttpService, text9 .. ("&cursor=" .. HttpService:UrlEncode(nextPageCursor))
			end
			gameRef, format = pcall(function()
				local HttpService, text = HttpService, text9
				local response = table.pack(game:HttpGet(text))
				return HttpService:JSONDecode(table.unpack(response, 1, response.n))
			end)
			if not gameRef or (type(format) ~= "table") then
				return list, false
			end
			for i2, value7 in ipairs(format.data or {}) do
				i2, number10, nextPageCursor2 = tostring(value7.id or ""), tonumber(value7.playing) or (1 / 0), tonumber(value7.maxPlayers) or 0
				if ((i2 ~= "") and (i2 ~= text7)) and (number10 < nextPageCursor2) then
					list[#list + 1] = {Id = i2, Playing = number10, Room = nextPageCursor2 - number10}
				end
			end
			if (#list > 0) and not condition4 then
				break
			end
			nextPageCursor = format.nextPageCursor
			if not nextPageCursor or (nextPageCursor == "") then
				break
			end
		end

		return list, true
	end

	local function serverHop(argument)
		local value5, data, clock = bit32.bxor(198531718, 0), data2
		clock, value5 = os.clock, bit32.bxor(value5, 250118525)
		data.HopActiveUntil = clock() + 45
		local value2
		value5 = bit32.bxor(value5, 96601767)
		data = (value and (text6 == argument)) and ((os.clock() - number8) < number9)

		if data then
			value2 = value
		else
			clock = nil
			value2, clock = callback31(argument)
			if not clock then
				return "fetch"
			end
			value, text6 = value2, argument
			number8 = os.clock()
		end

		local data3, condition4, hopAvoid = data2, type(data2.HopAvoid) == "table"
		if condition4 then
			data = data2
			hopAvoid = data.HopAvoid
		else
			hopAvoid = condition4
		end
		local condition5 = hopAvoid or {}

		local function callback32(argument2, argument3)
			local list = {}
			for _, value6 in ipairs(value2) do
				if (not argumentMap[value6.Id] and (value6.Room >= argument2)) and not (argument3 and condition5[value6.Id]) then
					list[#list + 1] = value6
				end
			end
			return list
		end

		hopAvoid = callback32(2, true)
		hopAvoid = if #(if #(if #hopAvoid == 0 then callback32(1, true) else hopAvoid) == 0 then callback32(2, false) else if #hopAvoid == 0 then callback32(1, true) else hopAvoid) == 0 then callback32(1, false) else if #(if #hopAvoid == 0 then callback32(1, true) else hopAvoid) == 0 then callback32(2, false) else if #hopAvoid == 0 then callback32(1, true) else hopAvoid
		if (#hopAvoid == 0) and (next(argumentMap) ~= nil) then
			table.clear(argumentMap)
			hopAvoid = (callback32(1))
		end
		local callback32_2 = #hopAvoid
		clock = callback32_2 == 0
		if clock then
			callback29(nil)
			value = nil
			return "empty"
		end
		local id2

		if argument == "Random" then
			id2 = hopAvoid[math.random(1, #hopAvoid)].Id
		else
			local value6, value = bit32.bxor(107711254, 0), table
			data, clock = value6, u32Trunc(callback32_2)
			value6 = u32Trunc((bit32.bxor(data, 234444753) + 4194906337) + (u32Mul(4194906337, clock) + u32Mul(4194906337, (bit32.bnot(clock)))))
			condition4 = value.sort
			value6 = bit32.bxor(value6, 79316318)
			condition4(hopAvoid, function(argument2, argument3)
				if argument == "Least Players" then
					return argument2.Playing < argument3.Playing
				end
				return argument2.Playing > argument3.Playing
			end)
			id2 = hopAvoid[1].Id
		end

		condition3, id = false, id2
		number6 = os.clock() + number3
		pcall(callback28)
		condition4 = pcall(function()
			local TeleportService = TeleportService
			local value6
			TeleportService:TeleportToPlaceInstance(game.PlaceId, id2, localPlayer)
		end)
		if not condition4 then
			callback29(id2)
			return "failed"
		end
		condition4 = os.clock() + number3

		while os.clock() < condition4 do
			hopAvoid = condition3
			if hopAvoid then
				return "denied"
			end
			task.wait(0.25)
		end

		return "waiting"
	end

	local callback30_3 = data2
	callback30_3.ServerHop = serverHop
	callback30_3 = serverSection
	callback30_3:CreateDropdown({Name = "Server Hop Mode", Options = {"Most Players", "Random", "Least Players"}, Default = "Least Players", Callback = function(argument)
		text5 = tostring(argument or "Least Players")
	end})
	callback30_3 = serverSection

	callback30_3:CreateButton({Name = "Server Hop", ButtonText = "Hop", Callback = function()
		local value5 = bit32.bxor(147330473, 0)
		local value2 = value5
		number7 += 1
		value5 = bit32.bxor(value2, 321575231)
		local number = number7
		local value2
		value2, value5 = task, u32Trunc((u32Mul(1214418293, value5) + 321646421) + (u32Mul(1866130710, (bit32.bor(value5, 487210593))) + u32Mul(1214418294, (bit32.bxor(value5, 487210593)))))

		value2.spawn(function()
			condition2 = true
			local number10 = 0

			while true do
				local number2 = number7
				if not (number == number2) then
					break
				end
				number10 += 1
				number2 = data2
				number2.HopActiveUntil = os.clock() + 45
				number2 = serverHop(text5)
				local condition4 = (number2 == "waiting") or (number ~= number7)
				if condition4 then
					break
				end
				condition4 = number2 == "empty"
				if condition4 then
					value = nil
					table.clear(argumentMap)
				end
				condition4 = (number10 % 10) == 0
				if condition4 then
					callback6("Server Hop", string.format("Every server was full so far, %d tries.", number10))
				end
				task.wait(((number2 == "fetch") and number5) or number4)
			end

			local condition4 = number == number7
			if condition4 then
				condition2 = false
			end
		end)
	end})
end

callback25()

local function callback26()
	local value3, number3, number4, text3, jobIdInput = bit32.bxor(363763856, 0), 8, 0, ""
	value3 = u32Trunc((u32Mul(1678698172, value3) + 3774890108) + (u32Mul(937570952, (bit32.bor(value3, 258432145))) + u32Mul(1678698173, (bit32.bxor(value3, 258432145)))))
	local callback27
	value3 = bit32.bxor(value3, 52361646)
	callback27 = function()
		local now, number = os.clock(), number4
		return now < number
	end
	local function runUntilTimeout(argument)
		number4 = (argument and (os.clock() + number3)) or 0
	end
	local function callback28(argument)
		local match = tostring(argument or ""):match("^%s*(.-)%s*$")
		return match:match("%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x") or match
	end

	local function callback29()
		local text = text3

		if jobIdInput then
			local value4 = bit32.bxor(161296243, 0)
			local nameList
			nameList, value4 = pcall, u32Trunc(value4 + 162055202)
			local value5, value6 = nameList(function()
				local controller = jobIdInput._controller
				return (controller and controller.GetValue) and controller.GetValue()
			end)

			if (value5 and (type(value6) == "string")) and (value6 ~= "") then
				text = value6
			else
				nameList = {"Get", "GetValue", "GetText"}

				for i, value7 in ipairs(nameList) do
					local value8 = bit32.bxor(383709334, 0)
					i = value8
					local response
					response, value8 = pcall, u32Trunc(i + 17979432)
					local value9, value10 = response(function()
						return jobIdInput[value7]
					end)

					if value9 and (type(value10) == "function") then
						i, response = pcall(value10, jobIdInput)
						if (i and (type(response) == "string")) and (response ~= "") then
							text = response
							break
						end
					end
				end
			end
		end

		local value4 = callback28(text)

		if value4 == "" then
			local ok, response = pcall(function()
				local value5 = (getclipboard or readclipboard) or getrbxclipboard
				return ((type(value5) == "function") and value5()) or nil
			end)
			value4 = if ok and (type(response) == "string") then callback28(response) else value4
		end

		return value4
	end

	local function callback30(argument)
		local value4 = bit32.bxor(166024301, 0)
		local value = value4
		local condition2
		value4, condition2 = u32Trunc(value + 291500646), not jobIdInput
		value4 = u32Trunc(value4 - 98476869)
		if condition2 then
			return
		end
		pcall(function()
			local controller = jobIdInput._controller
			if controller and controller.SetValue then
				controller.SetValue(argument, false)
			end
		end)
		text3 = callback28(argument)
	end

	local function teleportServer(argument)
		local value4 = bit32.bxor(92664084, 0)
		local value = value4
		runUntilTimeout(true)
		local condition, _
		condition, _, value4 = pcall, AutoLoadBeforeTeleport, u32Trunc((u32Mul(2680712560, value) + 2501527536) + (u32Mul(1614254737, (bit32.bor(value, 391619225))) + u32Mul(1614254735, (bit32.band(value, 391619225)))))
		condition(_)
		value4 = bit32.bxor(value4, 395787240)

		condition = not pcall(function()
			local condition2 = game.JobId ~= ""
			local value5, value6

			if condition2 then
				local TeleportService = TeleportService
				TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
			else
				local TeleportService = TeleportService
				TeleportService:Teleport(game.PlaceId, localPlayer)
			end
		end)

		if condition then
			runUntilTimeout(false)
			callback6(argument, "Roblox could not rejoin the server.")
		end
	end

	local function callback31()
		local value4 = bit32.bxor(363397073, 0)
		local value = value4
		local TeleportService = TeleportService
		value4 = u32Trunc((u32Mul(53257575, value) + 2920053036) + (u32Mul(4241709722, (bit32.bor(value, 401323508))) + u32Mul(4241709720, (bit32.band(value, 401323508)))))
		value4 = bit32.bxor(value4, 440015108)

		local function callback32(_, argument, argument2)
			if not callback27() then
				return
			end
			runUntilTimeout(false)
			callback6("Teleport Failed", tostring(((argument2 ~= "") and argument2) or argument))
		end

		TeleportService.TeleportInitFailed:Connect(callback32)
	end

	pcall(callback31)
	local callback31_2 = serverSection
	jobIdInput = callback31_2:CreateInput({Name = "Job ID", Placeholder = "Paste a server Job ID...", Default = "", MaxLength = 100, Callback = function(argument)
		text3 = callback28(argument)
	end})
	if jobIdInput then
		jobIdInput._configIgnored = true
		if jobIdInput.State and not jobIdInput.State._registered then
			jobIdInput.State._configIgnored = true
		end
	end
	callback31_2 = serverSection

	callback31_2:CreateButton({Name = "Join Job ID", ButtonText = "Join", Callback = function()
		local value4 = bit32.bxor(36465658, 0)
		local value = value4
		local condition2 = callback27()
		if condition2 then
			callback6("Join Job ID Failed", "A teleport is already running, try again shortly.")
			return
		end
		local value5 = callback29()
		condition2 = value5 == ""
		value4 = u32Trunc((u32Mul(1383870147, value) + 671008602) + (u32Mul(1527227002, (bit32.bor(value, 222673310))) + u32Mul(1383870148, (bit32.bxor(value, 222673310)))))
		if condition2 then
			callback6("Join Job ID Failed", "Paste a valid Job ID first.")
			return
		end
		runUntilTimeout(true)
		condition2, value = nil
		condition2, value, value4 = pcall, AutoLoadBeforeTeleport, bit32.bxor(value4, 512635796)
		condition2(value)
		value = not pcall(function()
			local TeleportService = TeleportService
			local value6
			TeleportService:TeleportToPlaceInstance(game.PlaceId, value5, localPlayer)
		end)
		if value then
			runUntilTimeout(false)
			callback6("Join Job ID Failed", "Roblox could not join that server.")
		end
	end})

	callback31_2 = serverSection

	callback31_2:CreateButton({Name = "Copy Current Job ID", ButtonText = "Copy", Callback = function()
		local text4 = tostring(game.JobId or "")
		callback30(text4)
		local value4 = setclipboard or toclipboard
		local ok = ((type(value4) == "function") and pcall(value4, text4)) or false
		local value5
		callback6((ok and "Job ID Copied") or "Job ID Shown", text4)
	end})

	callback31_2 = serverSection

	callback31_2:CreateButton({Name = "Rejoin Server", ButtonText = "Rejoin", Callback = function()
		local value4 = callback27()
		if value4 then
			callback6("Rejoin Failed", "A teleport is already running, try again shortly.")
			return
		end
		teleportServer("Rejoin Failed")
	end})

	local GuiService, data5 = game:GetService("GuiService"), {Option = nil, Fired = false, TeleportingAt = 0}
	local function callback32()
		local CoreGui = CoreGui
		local robloxPromptGui = CoreGui:FindFirstChild("RobloxPromptGui")
		CoreGui = robloxPromptGui and (robloxPromptGui:FindFirstChild("promptOverlay"))
		return (CoreGui ~= nil) and (CoreGui:FindFirstChild("ErrorPrompt") ~= nil)
	end

	local function callback33()
		local onTeleport = bit32.bxor(240111079, 0)
		local onTeleport2 = onTeleport
		local localPlayer = localPlayer
		onTeleport = bit32.bxor(onTeleport2, 121936757)
		onTeleport2 = nil
		onTeleport2, onTeleport = localPlayer.OnTeleport, u32Trunc((u32Mul(446413299, onTeleport) + 1914265514) + (u32Mul(3848553998, (bit32.bor(onTeleport, 195146286))) + u32Mul(3848553996, (bit32.band(onTeleport, 195146286)))))

		local connection = onTeleport2:Connect(function(argument)
			if argument == Enum.TeleportState.Failed then
				data5.TeleportingAt = 0
			else
				data5.TeleportingAt = os.clock()
			end
		end)

		registerItem(function()
			local value4 = bit32.bxor(117417624, 0)
			local value
			value, value4 = pcall, u32Trunc(value4 + 438723356)
			value(function()
				connection:Disconnect()
			end)
		end)
	end

	pcall(callback33)
	callback31_2 = serverSection
	data5.Option = callback31_2:CreateToggle({Name = "Auto Rejoin When Disconnect", Default = true})

	local function callback34()
		local now = os.clock()
		local data, number5 = data2, tonumber(data2.HopActiveUntil) or 0
		if now < number5 then
			return true
		end
		now = data2
		number5 = now.HopHandles
		now = type(number5) == "table"

		if now then
			local value = pairs

			for k, value4 in value(number5) do
				local ok, response = pcall(value4)
				k, value4 = ok and (response ~= nil)
				if k then
					ok = data2
					value4 = ok.Toggle(response, false)
				else
					value4 = k
				end
				if value4 then
					return true
				end
			end
		end

		return false
	end

	local function callback35(argument)
		local value4 = bit32.bxor(345713814, 0)
		local value = value4
		if callback34() then
			return
		end
		local fired, number5, fired2 = data5.Fired, u32Mul(466996281, value) + 425834795
		value4, fired2 = u32Trunc(number5 + (u32Mul(3827971016, (bit32.bor(value, 205256835))) + u32Mul(3827971014, (bit32.band(value, 205256835))))), fired or (data5.Option == nil)
		number5 = nil
		if fired2 then
			number5 = fired2
		else
			fired = data2
			number5 = not fired.Toggle(data5.Option, false)
		end
		if number5 or callback27() then
			return
		end

		if (data5.TeleportingAt > 0) and ((os.clock() - data5.TeleportingAt) < 60) then
			return
		end
		fired2, value = nil
		fired2, value, value4 = string.lower, tostring, bit32.bxor(value4, 387850268)
		number5 = fired2(value(argument or ""))
		if (number5 == "") or string.find(number5, "teleport", 1, true) then
			return
		end
		local errorCode
		pcall(function()
			errorCode = GuiService:GetErrorCode()
		end)
		argument = ((errorCode == Enum.ConnectionError.DisconnectDuplicatePlayer) or string.find(number5, "banned", 1, true)) or string.find(number5, "same account", 1, true)
		if argument then
			return
		end
		data5.Fired = true
		local placeId = game.PlaceId
		local text4 = tostring(game.JobId or "")
		local condition2 = ((string.find(number5, "shut", 1, true) ~= nil) or (string.find(number5, "no longer", 1, true) ~= nil)) or (string.find(number5, "closed", 1, true) ~= nil)
		pcall(AutoLoadBeforeTeleport)
		callback6("Auto Rejoin", (condition2 and "Server closed, joining another one.") or "Disconnected, rejoining now.")

		task.spawn(function()
			local number6 = 0

			while true do
				local value5 = bit32.bxor(19774778, 0)
				local value = value5
				local callback = callback34
				value5 = bit32.bxor(value, 473944218)
				if callback() then
					data5.Fired = false
					break
				end
				number6 += 1
				local condition3 = (not condition2 and (text4 ~= "")) and (number6 <= 2)
				local value
				value, value5 = pcall, u32Trunc((u32Mul(4030474429, value5) + 3873666527) + (u32Mul(264492868, (bit32.bor(value5, 390219979))) + u32Mul(264492866, (bit32.band(value5, 390219979)))))

				value(function()
					local value6, value7

					if condition3 then
						local TeleportService, localPlayer = TeleportService, localPlayer
						TeleportService:TeleportToPlaceInstance(placeId, text4, localPlayer)
					else
						local TeleportService, localPlayer = TeleportService, localPlayer
						TeleportService:Teleport(placeId, localPlayer)
					end
				end)

				task.wait((condition3 and 4) or 5)
			end
		end)
	end

	local function callback36()
		local value4 = bit32.bxor(220574581, 0)
		local value = value4
		value4 = u32Trunc(value + 374382390)
		value = nil
		value, value4 = GuiService.ErrorMessageChanged, u32Trunc(value4 + 107659010)
		local connection = value:Connect(function(argument)
			task.wait(0.3)
			if callback32() then
				callback35(argument)
			end
		end)

		registerItem(function()
			local value5 = bit32.bxor(350802268, 0)
			local value
			value, value5 = pcall, u32Trunc((u32Mul(385378206, value5) + 3423913552) + (u32Mul(3524210884, (bit32.bor(value5, 499067992))) + u32Mul(385378207, (bit32.bxor(value5, 499067992)))))
			value(function()
				connection:Disconnect()
			end)
		end)
	end

	pcall(callback36)

	task.spawn(function()
		local robloxPromptGui = bit32.bxor(76544115, 0)
		local robloxPromptGui2 = robloxPromptGui
		local CoreGui = CoreGui
		robloxPromptGui = bit32.bxor(robloxPromptGui2, 278701570)
		robloxPromptGui2 = CoreGui:WaitForChild("RobloxPromptGui", 30)
		CoreGui = robloxPromptGui2 and (robloxPromptGui2:WaitForChild("promptOverlay", 30))
		robloxPromptGui2 = not CoreGui
		robloxPromptGui = u32Trunc((u32Mul(739934043, robloxPromptGui) + 1335209290) + (u32Mul(2815099210, (bit32.bor(robloxPromptGui, 237749246))) + u32Mul(739934044, (bit32.bxor(robloxPromptGui, 237749246)))))
		if robloxPromptGui2 then
			return
		end

		local connection = CoreGui.ChildAdded:Connect(function(child)
			if child.Name ~= "ErrorPrompt" then
				return
			end
			task.wait(0.2)
			local text4, value = "", ipairs
			local descendants = table.pack(child:GetDescendants())
			for k, value4 in value(table.unpack(descendants, 1, descendants.n)) do
				k = value4:IsA("TextLabel") and (value4.Name == "ErrorMessage")
				if k then
					text4 = value4.Text
				end
			end
			descendants = text4 == ""

			if descendants then
				local value4 = bit32.bxor(411087478, 0)
				value = value4
				child = nil
				child, value4 = pcall, u32Trunc(value + 37811947)
				child(function()
					text4 = GuiService:GetErrorMessage()
				end)
			end

			callback35(((text4 ~= "") and text4) or "disconnected")
		end)

		registerItem(function()
			local value4 = bit32.bxor(156417363, 0)
			local value
			value, value4 = pcall, u32Trunc(value4 + 978819)
			value(function()
				connection:Disconnect()
			end)
		end)
	end)
end

callback26()

local function callback27()
	local value3, kMap = bit32.bxor(271616360, 0), {}
	value3 = u32Trunc((u32Mul(242581773, value3) + 4093352422) + (u32Mul(4052385524, (bit32.bor(value3, 264375294))) + u32Mul(4052385522, (bit32.band(value3, 264375294)))))

	local function callback28(argument)
		local kEntry = kMap[argument]
		if type(kEntry) ~= "string" then
			return ""
		end
		return kEntry
	end

	local callback29
	value3 = bit32.bxor(value3, 234591647)
	callback29 = function(argument, text3)
		argument.AutoLocalize = false
		argument.Text = text3
	end
	local number3 = 0
	local data5

	local function callback30()
		local data = data5
		if not data then
			return
		end
		data = data5
		for _, value4 in ipairs(data) do
			callback29(value4[1], callback28(value4[2]))
		end
	end

	do
		local value4 = bit32.bxor(304330086, 0)
		local UserInputService = UserInputService
		local inputBegan
		inputBegan, value4 = UserInputService.InputBegan, u32Trunc(value4 + 519325705)

		local connection = inputBegan:Connect(function(argument)
			local userInputType = argument.UserInputType
			argument = (((userInputType == Enum.UserInputType.MouseButton1) or (userInputType == Enum.UserInputType.Touch)) or (userInputType == Enum.UserInputType.Keyboard)) or (userInputType == Enum.UserInputType.Gamepad1)
			if argument then
				number3 = os.clock()
			end
		end)

		registerItem(function()
			local value5 = bit32.bxor(17590243, 0)
			local value
			value, value5 = pcall, u32Trunc(value5 + 124987664)
			value(function()
				connection:Disconnect()
			end)
		end)
	end

	local function callback31()
		local number4 = os.clock() - number3
		return number4 <= 1
	end
	local screenGui, uiScale
	local connections = {}
	local value4, value5

	local function clampValue()
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

	local function callback32()
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
		uiStroke.Name = generateRandomId()
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
		uiGradient.Name = generateRandomId()
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
		uiStroke.Name = generateRandomId()
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		uiStroke.Color = Color3.fromRGB(0, 0, 0)
		uiStroke.LineJoinMode = Enum.LineJoinMode.Round
		uiStroke.Thickness = math.max(1, textSize * 0.08)
		uiStroke.Transparency = 0
		uiStroke.Parent = parent
		return uiStroke
	end

	local function callback33(argument, argument2)
		local uiStroke = createUIStroke2(argument, argument2)
		createUIGradient(uiStroke, colorSequence2, 90)
		createUIGradient(argument, colorSequence, 90)
		uiStroke.Thickness = math.max(1, argument2 * 0.065)
	end

	local function callback34()
		local uiElement = bit32.bxor(351158800, 0)
		local uiElement2 = uiElement
		local screenGui2 = screenGui
		if screenGui2 then
			return
		end
		screenGui = Instance.new("ScreenGui")
		local uiElement3 = screenGui
		local value6
		uiElement3.Name = generateRandomId()
		screenGui.DisplayOrder = 2000000000
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		uiElement3 = screenGui
		uiElement3.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.Enabled = false
		screenGui2 = Instance.new("TextButton")
		screenGui2.Name = generateRandomId()
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
		frame.Name = generateRandomId()
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
		uiElement2.Name = generateRandomId()
		uiScale.Parent = frame
		createUIStroke(frame, Enum.ApplyStrokeMode.Border, 2)
		uiElement3 = Instance.new("Frame")
		uiElement3.Name = generateRandomId()
		uiElement3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		uiElement3.BorderSizePixel = 0
		uiElement3.Position = UDim2.fromOffset(22, 22)
		uiElement3.Size = UDim2.fromOffset(5, 26)
		uiElement3.ZIndex = 12
		uiElement3.Parent = frame
		createUIGradient(uiElement3, colorSequence3, 90)
		createUIStroke(uiElement3, Enum.ApplyStrokeMode.Border, 1.4)
		uiElement3 = Instance.new("TextLabel")
		uiElement3.Name = generateRandomId()
		uiElement3.BackgroundTransparency = 1
		uiElement3.Position = UDim2.fromOffset(38, 20)
		uiElement3.Size = UDim2.fromOffset(370, 30)
		uiElement3.TextXAlignment = Enum.TextXAlignment.Left
		uiElement3.TextYAlignment = Enum.TextYAlignment.Center
		uiElement3.ZIndex = 12
		uiElement3.Parent = frame
		callback33(uiElement3, 21)
		callback29(uiElement3, callback28("Title"))
		uiElement2 = Instance.new("Frame")
		uiElement2.Name = generateRandomId()
		uiElement2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		uiElement2.BackgroundTransparency = 0.82
		uiElement2.BorderSizePixel = 0
		uiElement2.Position = UDim2.fromOffset(22, 58)
		uiElement2.Size = UDim2.fromOffset(386, 1)
		uiElement2.ZIndex = 12
		uiElement2.Parent = frame
		uiElement2 = Instance.new("TextLabel")
		uiElement2.Name = generateRandomId()
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
		callback29(uiElement2, callback28("Warn"))
		local textLabel, generateRandomId2, number4, uiElement4 = Instance.new("TextLabel"), generateRandomId, u32Mul(772847437, uiElement) + 2977093471, bit32.bor(uiElement, 188148571)
		local value7, uiElement5 = u32Mul(2749272422, uiElement4), bit32.bxor(uiElement, 188148571)
		uiElement4 = number4 + (value7 + u32Mul(772847438, uiElement5))
		uiElement = u32Trunc(uiElement4)
		textLabel.Name = generateRandomId2()
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
		callback29(textLabel, callback28("Body"))
		number4 = Instance.new("TextLabel")
		number4.Name = generateRandomId()
		number4.BackgroundTransparency = 1
		number4.Position = UDim2.fromOffset(22, 176)
		number4.Size = UDim2.fromOffset(386, 46)
		number4.TextWrapped = true
		number4.TextXAlignment = Enum.TextXAlignment.Left
		number4.TextYAlignment = Enum.TextYAlignment.Top
		number4.ZIndex = 12
		number4.Parent = frame
		createUIStroke2(number4, 14)
		number4.LineHeight = 1.12
		number4.TextColor3 = Color3.fromRGB(255, 176, 120)
		callback29(number4, callback28("Tip"))

		local function callback35(parent, parent2, argument)
			local textButton = Instance.new("TextButton")
			textButton.Name = generateRandomId()
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
			parent.Name = generateRandomId()
			parent.AnchorPoint = Vector2.new(0.5, 0.5)
			parent.BackgroundColor3 = (argument and Color3.fromRGB(175, 0, 0)) or Color3.fromRGB(24, 25, 30)
			parent.BorderSizePixel = 0
			parent.Position = UDim2.fromScale(0.5, 0.5)
			parent.Size = UDim2.fromScale(1, 0.92)
			parent.ZIndex = 12
			parent.Parent = textButton
			createUIStroke(parent, Enum.ApplyStrokeMode.Border, 1.6)
			parent2 = Instance.new("Frame")
			parent2.Name = generateRandomId()
			parent2.AnchorPoint = Vector2.new(0.5, 0)
			parent2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			parent2.BorderSizePixel = 0
			parent2.Position = UDim2.fromScale(0.5, 0)
			parent2.Size = UDim2.fromScale(1, 0.9)
			parent2.ZIndex = 12
			parent2.Parent = parent
			createUIGradient(parent2, (argument and colorSequence3) or colorSequence5, 90)
			parent = Instance.new("Frame")
			parent.Name = generateRandomId()
			parent.AnchorPoint = Vector2.new(0.5, 0.5)
			parent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			parent.BorderSizePixel = 0
			parent.Position = UDim2.fromScale(0.5, 0.5)
			parent.Size = UDim2.fromScale(0.965, 0.88)
			parent.ZIndex = 13
			parent.Parent = parent2
			createUIGradient(parent, (argument and colorSequence4) or colorSequence5, 90)
			parent2 = Instance.new("TextLabel")
			parent2.Name = generateRandomId()
			parent2.AnchorPoint = Vector2.new(0.5, 0.5)
			parent2.BackgroundTransparency = 1
			parent2.Position = UDim2.fromScale(0.5, 0.5)
			parent2.Size = UDim2.fromScale(0.9, 0.6)
			parent2.TextWrapped = true
			parent2.ZIndex = 15
			parent2.Parent = textButton
			callback33(parent2, 17)
			return textButton, parent2
		end

		uiElement4, screenGui2 = callback35(22, 184, false)
		generateRandomId2, uiElement5 = callback35(224, 184, true)
		callback29(screenGui2, callback28("Cancel"))
		callback29(uiElement5, callback28("Accept"))
		data5 = {{uiElement3, "Title"}, {uiElement2, "Warn"}, {textLabel, "Body"}, {number4, "Tip"}, {screenGui2, "Cancel"}, {uiElement5, "Accept"}}
		callback30()
		connections[#connections + 1] = uiElement4.MouseButton1Click:Connect(function()
			local value = value5
			if value then
				value5()
			end
		end)
		uiElement5, uiElement3 = #connections + 1, generateRandomId2.MouseButton1Click
		local function callback36()
			local value = value4
			if value then
				value4()
			end
		end
		connections[uiElement5] = uiElement3:Connect(callback36)
		screenGui2 = workspace.CurrentCamera
		if screenGui2 then
			connections[#connections + 1] = screenGui2:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue)
		end
		clampValue()
		screenGui2 = value2
		screenGui.Parent = screenGui2
	end

	local function callback35()
		callback34()
		clampValue()
		local screenGui2 = screenGui
		if screenGui2 then
			screenGui.Enabled = true
		end
	end

	registerItem(function()
		for i, connection in ipairs(connections) do
			local value6 = bit32.bxor(17299987, 0)
			i = value6
			local value
			value, value6 = pcall, u32Trunc((u32Mul(725667057, i) + 1609749439) + (u32Mul(2843633182, (bit32.bor(i, 14576559))) + u32Mul(725667058, (bit32.bxor(i, 14576559)))))
			value(function()
				connection:Disconnect()
			end)
		end

		table.clear(connections)
		local screenGui2 = screenGui

		if screenGui2 then
			local value6 = bit32.bxor(77892843, 0)
			local value
			value, value6 = pcall, bit32.bxor(value6, 254522842)
			value(function()
				screenGui:Destroy()
			end)
			screenGui = nil
		end
	end)

	local data6 = {Manual = callback31, Hide = callback32, Show = function(argument, argument2, argument3)
		local value6 = bit32.bxor(174746301, 0)
		local value = value6
		local value2 = pairs
		value6 = u32Trunc(value + 464450654)
		for k, value7 in value2(argument) do
			kMap[k] = value7
		end
		value6 = u32Trunc(value6 - 389917866)
		callback30()
		function value4()
			callback32()
			if argument2 then
				argument2()
			end
		end
		function value5()
			callback32()
			if argument3 then
				argument3()
			end
		end
		callback35()
		callback30()
	end}

	return data6
end

data2.HopPrompt = callback27()

local function callback28()
	local value3 = bit32.bxor(284787379, 0)
	local mainWindow = mainWindow
	local autoHopTab = mainWindow:CreateTab({Name = "Auto Hop", SectionsExpanded = true})
	local eggFinderSection, eggList, text3, number3, number4, number5 = autoHopTab:CreateSection({Name = "Egg Finder", Expanded = true}), {"Collect Then Hop", "Until An Egg Matches", "Wait For Target Egg"}, "ChilliLibrary/RAP_AutoHop.json", 1800, 120, 4
	local data5 = {Mode = eggList[1], Sync = true, MinRank = 0}
	value3 = bit32.bxor(value3, 533485198)
	data5.Wanted = {}
	data5.HopDelay = 5
	data5.Wait = 5
	data5.LoadedAt = os.clock()
	data5.Kind = "idle"
	data5.Status = "Idle"
	data5.HopStart = 0
	data5.HopEnd = 0
	data5.Survey = nil
	data5.Generation = 0
	data5.Visited = {}
	data5.Handle = nil
	data5.StopNote = nil
	data5.View = nil
	data5.WindowUntil = 0
	mainWindow = data3
	data5.WaitRank = mainWindow.RarityRank.Divine or 0
	value3 = u32Trunc((u32Mul(2909559185, value3) + 4180039838) + (u32Mul(2770816222, (bit32.bor(109473726, value3))) + u32Mul(2909559186, (bit32.bxor(value3, 109473726)))))
	data5.WaitEggs = {}
	local number6, number7, number8, number9 = 420, 298.5, 120, 10
	local function getServerTimeNow()
		return workspace:GetServerTimeNow()
	end
	local function callback29()
		local number10 = getServerTimeNow() % number6
		return (number10 >= number7) and (number10 < (number7 + number8))
	end

	local function callback30()
		local serverTimeNow = getServerTimeNow()
		local number10 = serverTimeNow % number6
		if number10 < number7 then
			return (serverTimeNow - number10) + number7
		end
		return ((serverTimeNow - number10) + number6) + number7
	end

	local function callback31()
		return (data5.WindowUntil > getServerTimeNow()) and not callback29()
	end
	mainWindow = data2
	mainWindow.AutoHopTab = autoHopTab

	local function saveFile()
		local value4 = bit32.bxor(390010685, 0)
		local value = value4
		local valueType = type(writefile)
		value4 = u32Trunc(value + 239093318)
		value4 = u32Trunc(value4 + 230558737)
		if valueType ~= "function" then
			return
		end

		local function saveFile2()
			if ((type(isfolder) == "function") and (type(makefolder) == "function")) and not isfolder("ChilliLibrary") then
				makefolder("ChilliLibrary")
			end
			local list = {}
			for k, value5 in pairs(data5.Visited) do
				list[#list + 1] = {k, value5}
			end
			writefile(text3, HttpService:JSONEncode({Visited = list, WindowUntil = data5.WindowUntil}))
		end

		pcall(saveFile2)
	end

	local function readJsonFile()
		if type(readfile) ~= "function" then
			return
		end

		if (type(isfile) == "function") and not isfile(text3) then
			return
		end
		local HttpService = HttpService
		local data6 = HttpService:JSONDecode(readfile(text3))
		if type(data6) ~= "table" then
			return
		end
		HttpService = os.time()
		for i, value4 in ipairs(((type(data6.Visited) == "table") and data6.Visited) or {}) do
			i = ((type(value4) == "table") and tonumber(value4[2])) or nil
			if (i and (type(value4[1]) == "string")) and ((HttpService - i) < number3) then
				data5.Visited[value4[1]] = i
			end
		end
		data5.WindowUntil = tonumber(data6.WindowUntil) or 0
	end

	pcall(readJsonFile)
	data5.Visited[tostring(game.JobId)] = os.time()
	mainWindow = data2
	mainWindow.HopAvoid = data5.Visited

	local function callback32(status, valueType)
		data5.Status = status
		data5.Kind = valueType or data5.Kind
		if type(data5.View) == "function" then
			data5.View()
		end
	end

	local toNumberOrDefault, value4

	toNumberOrDefault = function()
		local data6, data, condition2 = {Count = 0, Best = nil}, data4, type(data4.EggMatches) == "function"

		if condition2 then
			local data, ok, response, best = data4, pcall(data4.EggMatches, data5.MinRank, data5.Wanted, data5.MinWeight or 0)
			if ok then
				data6.Count = tonumber(response) or 0
				data6.Best = best
			end
		end

		return data6
	end

	local function callback33()
		local data = data3
		local condition2 = data.BasketCount() > 0
		local condition
		if condition2 then
			condition = condition2
		else
			data = data4
			condition = data.Target ~= nil
		end
		return condition
	end

	local function callback34()
		local localPlayer = localPlayer
		local basket, value = localPlayer:FindFirstChild("Basket"), ipairs
		localPlayer = (basket and basket:GetChildren()) or {}

		for k, value5 in value(localPlayer) do
			k = value5:GetAttribute("Egg")
			local condition2 = type(k) == "string"
			local condition3
			if condition2 then
				basket = data3
				condition3 = basket.EggRank(k) >= data5.MinRank
			else
				condition3 = condition2
			end
			local condition4 = condition3 and ((next(data5.Wanted) == nil) or data5.Wanted[k])
			local attribute
			if condition4 then
				k = data3
				attribute = k.EggHeavyEnough(value5:GetAttribute("Weight"), data5.MinWeight or 0)
			else
				attribute = condition4
			end
			if attribute then
				return true
			end
		end

		return false
	end

	local function callback35()
		local value5 = callback30()
		if data5.WindowUntil < value5 then
			data5.WindowUntil = value5
			saveFile()
		end
	end

	local function callback36()
		if data5.WindowUntil ~= 0 then
			data5.WindowUntil = 0
			saveFile()
		end
	end

	local function toNumberOrDefault2()
		local data, valueType = data4, type(data4.EggMatches)
		if valueType ~= "function" then
			return 0, nil
		end
		local data, ok, response, response2 = data4, pcall(data4.EggMatches, data5.WaitRank, data5.WaitEggs, 0)
		if ok then
			return tonumber(response) or 0, response2
		end
		return 0, nil
	end

	local function callback37()
		local data = data2
		local data, collect = data4, data.Toggle(data4.Collect, false)
		return collect == true
	end
	local function callback38(argument)
		return data5.Mode == eggList[argument]
	end

	local function callback39(argument)
		local condition2 = argument == data5.Generation
		local condition3
		if condition2 then
			argument = data2
			condition3 = argument.Toggle(data5.Handle, false) == true
		else
			condition3 = condition2
		end
		return condition3
	end

	local function callback40(argument)
		callback32("Checking the server one last time", "hop")
		local numVal = toNumberOrDefault()
		data5.Survey = numVal
		if (numVal.Count > 0) or callback33() then
			callback32("A matching egg showed up, hop cancelled", "found")
			return
		end
		data5.Visited[tostring(game.JobId)] = os.time()
		saveFile()
		callback32("Joining a less crowded server", "joining")
		local text4, data, condition2 = "missing", data2, type(data2.ServerHop) == "function"
		if condition2 then
			local data, ok, response = data2, pcall(data2.ServerHop, "Least Players")
			text4 = (ok and tostring(response)) or "error"
		end
		if not callback39(argument) then
			return
		end
		callback32(if text4 == "waiting" then "Teleport is slow, trying another server" else if text4 == "empty" then "Every listed server is full, searching again" else if text4 == "fetch" then "Server list unavailable, waiting a moment" else if text4 == "denied" then "That server filled up on join, taking the next one" else "Hop did not land, trying again", "retry")
		task.wait(((text4 == "fetch") and (number5 + 1)) or 1.5)
	end

	local function callback41(argument)
		data5.HopEnd = 0
		local now, hopEnd

		while callback39(argument) do
			local number10 = 0.5
			local text4, text5
			local condition2, data = false, data3
			local condition3 = not data.Root()
			local condition
			if condition3 then
				condition = condition3
			else
				data = data3
				condition = not data.Plot()
			end

			if condition then
				text4, text5 = "Waiting for the game to load", "scan"
			else
				data = toNumberOrDefault()
				data5.Survey = data
				condition3 = data.Best
				local best = (condition3 and tostring(condition3.Name)) or "an egg"
				if ((callback38(3) and not callback29()) and not callback31()) and (toNumberOrDefault2() > 0) then
					callback35()
				end
				local condition4 = (os.clock() - data5.LoadedAt) < 3

				if condition4 then
					text4, text5 = "Scanning this server", "scan"
				else
					local value5 = callback33()

					if value5 then
						if callback34() and callback38(1) then
							callback35()
						end
						text4, text5, now = "Auto Collect is bringing eggs home, hop waits", "collect", nil
					else
						local condition5 = data.Count > 0

						if condition5 then
							local value6 = callback37()

							if value6 then
								now = now or os.clock()
								local data2, number11 = data4, os.clock() - math.max(now, data4.LastPickupAt or 0)
								if number11 > number4 then
									condition2 = true
								else
									text4, text5 = ((data.Count == 1) and ("Matching egg here (" .. (best .. "), collecting it first"))) or string.format("%d matching eggs here, collecting them first", data.Count), "found"
								end
							else
								if callback38(1) or callback38(3) then
									text4, text5 = "Matching egg here, turn on Auto Collect Eggs to take it", "found"
								else
									text4, text5 = "Found " .. (best .. ", staying here"), "found"
								end
							end
						else
							if (callback38(1) or callback38(3)) and callback29() then
								text4, text5, now = "Night, hopping paused until the next day", "night", nil
							else
								if callback38(3) and not callback31() then
									text4, text5, now = "Waiting for a target egg to spawn in this server", "wait", nil
								else
									if (callback38(1) or callback38(3)) and ((callback30() - getServerTimeNow()) < number9) then
										text4, text5, now = "Night is about to start, staying here", "night", nil
									else
										if callback38(1) and not callback31() then
											now = nil
											if callback37() then
												text4, text5 = "Waiting for Auto Collect to bring home a matching egg", "wait"
											else
												text4, text5 = "Turn on Auto Collect Eggs, hopping starts after it collects a matching egg", "wait"
											end
										else
											condition2, now = true, nil
										end
									end
								end
							end
						end
					end
				end
			end

			if text4 then
				data5.HopEnd = 0
				callback32(text4, text5)
				hopEnd = nil
			else
				if condition2 then
					if not hopEnd then
						hopEnd = math.max(os.clock() + 1.5, (data5.LoadedAt + data5.HopDelay) + data5.Wait)
						data5.HopStart = os.clock()
						data5.HopEnd = hopEnd
					end
					condition = hopEnd - os.clock()

					if condition > 0 then
						callback32(string.format("No matching egg here, hopping in %.1fs", condition), "hop")
						number10 = math.min(0.25, condition)
					else
						data5.HopEnd = 0
						callback40(argument)
						number10, now, hopEnd = 0, nil, nil
					end
				end
			end

			if number10 > 0 then
				task.wait(number10)
			end
		end
	end

	local function callback42()
		data5.Generation = data5.Generation + 1
		local generation = data5.Generation
		callback32("Scanning this server", "scan")
		task.spawn(callback41, generation)
	end

	local function options()
		local value5 = bit32.bxor(421579318, 0)
		local RunService2 = value5

		if type(eggFinderSection.CreateCanvas) ~= "function" then
			local value6 = eggFinderSection:CreateText({Name = "Hop Status", Text = "Idle"})
			function data5.View()
				if value6 and (type(value6.Set) == "function") then
					pcall(value6.Set, value6, data5.Status)
				end
			end
			return
		end

		local function colorizeText(_, argument)
			return string.format("<font color=\"%s\">%s</font>", _, argument)
		end
		value5 = u32Trunc(RunService2 + 96705936)
		local function callback43(_)
			return "<b>" .. (tostring(_) .. "</b>")
		end
		local function callback44(argument)
			return (string.gsub(tostring(argument), "[<>&]", {["<"] = "&lt;", [">"] = "&gt;", ["&"] = "&amp;"}))
		end
		local function callback45(argument, argument2)
			local ok, response = pcall(Font.new, argument, argument2, Enum.FontStyle.Normal)
			return (ok and response) or nil
		end
		local json = callback45("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
		local json2 = callback45("rbxassetid://12187365977", Enum.FontWeight.Bold) or callback45("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular)
		local formattedText = colorizeText("#6B7288", "  " .. (utf8.char(8226) .. "  "))

		local function callback46(argument)
			if (typeof(argument) ~= "Instance") or not argument:IsDescendantOf(game) then
				return false
			end
			local argument = argument

			while argument do
				if argument:IsA("GuiObject") and not argument.Visible then
					return false
				end

				if argument:IsA("LayerCollector") then
					return argument.Enabled
				end
				argument = argument.Parent
			end

			return false
		end

		local function toNumberOrDefault3(argument)
			local unitSuffixes = {"", "K", "M", "B", "T", "Qa", "Qi"}
			argument = tonumber(argument) or 0
			local number10 = 1
			while (argument >= 1000) and (number10 < #unitSuffixes) do
				argument, number10 = argument / 1000, number10 + 1
			end
			local text4 = ((number10 == 1) and tostring(math.floor(argument))) or string.format("%.1f", argument)
			return string.gsub(text4, "%.0$", "") .. unitSuffixes[number10]
		end

		local number10, number11, number12, height, number13, number14, number15, number16, number17, configMap, configMap2, argument5 = 2.6, 0.6, 3.3, 1.2, 2.6, 0.7, 0.3, 0.95, 0.0909, {idle = {Title = "IDLE", Color = "#9AA3B5"}, scan = {Title = "SCANNING", Color = "#7FD8FF"}, found = {Title = "EGG FOUND", Color = "#4DFF7A"}, collect = {Title = "AUTO COLLECT BUSY", Color = "#FFC24D"}, wait = {Title = "WAITING", Color = "#FF7AE0"}, night = {Title = "NIGHT", Color = "#9C8CFF"}, rare = {Title = "WAITING", Color = "#FF7AE0"}, steal = {Title = "AUTO STEAL BUSY", Color = "#FFC24D"}, hop = {Title = "HOPPING SOON", Color = "#FF9A3D"}, joining = {Title = "JOINING SERVER", Color = "#FF9A3D"}, retry = {Title = "RETRYING", Color = "#FF6B6B"}, boss = {Title = "BOSS FIGHT", Color = "#FF5C8A"}}, {Slot = {Text = "ON THE MAP", Color = "#4DFF7A"}, Dropped = {Text = "DROPPED", Color = "#FFC24D"}, Carried = {Text = "BEING CARRIED", Color = "#FF8A5C"}, Mine = {Text = "YOU CARRY", Color = "#7FD8FF"}}
		local options2, number18, number19, number20 = {}, 0, 0, 0.06
		local number21 = -1
		local number22 = -1
		local number23, condition2, number24, condition3, number25, data6 = -1, false, 0, true, 0
		local number26, condition4, condition5 = 0, false, false

		local function callback47(argument)
			local value6 = bit32.bxor(378889257, 0)
			local value = value6
			local diffWrapped
			value6, diffWrapped = u32Trunc(value + 151530042), not argument or argument.DiffWrapped
			if diffWrapped then
				return argument
			end
			local set = argument.Set
			value6 = u32Trunc(value6 + 279515574)
			argument.DiffWrapped = true

			argument.Set = function(argument2)
				if type(argument2) ~= "table" then
					return set(argument2)
				end
				local spec = argument.Spec
				local data7
				for k, value7 in pairs(argument2) do
					if spec[k] ~= value7 then
						data7 = data7 or {}
						data7[k] = value7
					end
				end
				if data7 then
					set(data7)
				end
				return argument
			end

			return argument
		end

		local function callback48(argument)
			local widthKey = tostring(number19) .. ("|" .. string.gsub(tostring(argument.Spec.Text or ""), "%d", "0"))
			if argument.WidthKey == widthKey then
				return argument.WidthUnits
			end
			local textLabel = argument.Get()
			local condition6 = (not textLabel or (number19 <= 0)) or (textLabel.Text ~= tostring(argument.Spec.Text or ""))
			if condition6 then
				return nil
			end
			local size, textWrapped = textLabel.Size, textLabel.TextWrapped
			textLabel.TextWrapped = false
			textLabel.Size = UDim2.fromOffset(100000, math.max(1, size.Y.Offset))
			condition6 = textLabel.TextBounds.X
			textLabel.Size = size
			textLabel.TextWrapped = textWrapped
			if condition6 <= 0 then
				return nil
			end
			argument.WidthKey, argument.WidthUnits = widthKey, condition6 / number19
			return argument.WidthUnits
		end

		local function callback49()
			local survey = data5.Survey
			local best = (survey and survey.Best) or nil
			local condition6 = not best
			local condition
			if condition6 then
				condition = condition6
			else
				local data = data2
				condition = data.Toggle(data5.Handle, false) ~= true
			end
			if condition then
				data6, number26, number24 = nil, 0, 2
				return
			end
			condition = data3
			condition6 = condition.EggData(best.Name)
			local name, data = (condition6 and tostring(condition6.Rarity)) or "Common", data3
			condition = data.RarityColors[name] or Color3.fromRGB(255, 255, 255)
			data6 = {Info = {Name = tostring(best.Name), Rarity = name, Color = condition, Hex = "#" .. string.upper(condition:ToHex()), Icon = ((condition6 and condition6.Image) and tostring(condition6.Image)) or nil}, Mutation = best.Mutation, Area = (best.Distance and string.format("%d studs away", math.floor(best.Distance))) or "", State = "Slot", Value = best.Luck}
			number26, number24 = survey.Count, 2
		end

		local function callback50()
			if not options2.Card then
				return
			end
			local data = data2
			local condition6 = data.Toggle(data5.Handle, false) == true
			data = (condition6 and data5.Kind) or "idle"
			local configEntry = configMap[data] or configMap.idle
			local color, status, condition7, number27 = Color3.fromHex(configEntry.Color), (condition6 and data5.Status) or "Turn on Auto Hop to start hunting", false, 0
			if (condition6 and (data == "hop")) and (data5.HopEnd > data5.HopStart) then
				local number28, number29 = data5.HopEnd - data5.HopStart, math.max(0, data5.HopEnd - os.clock())
				number27 = math.clamp(1 - (number29 / number28), 0, 1)
				status, condition7 = string.format("No matching egg here, hopping in %.1fs", number29), true
			end
			options2.Accent.Set({Background = configEntry.Color})
			options2.Title.Set({Text = configEntry.Title, Color = color})
			local set, data7, _, Players2 = options2.Server.Set, {}, Players, Players
			data7.Text = colorizeText("#9AA3B5", "Players ") .. callback43(colorizeText("#FFFFFF", #Players:GetPlayers() .. ("/" .. tostring(Players.MaxPlayers))))
			set(data7)
			set, data7 = options2.Detail.Set, {}
			data7.Text = colorizeText("#E6ECF5", callback44(status))
			set(data7)
			options2.Bar.Set({Visible = condition7, Alpha = number27, FillColor = color})
			data7 = data6
			data = data7 ~= nil
			set = (condition7 ~= condition4) or (data ~= condition5)
			if set then
				condition4, condition5, number24 = condition7, data, 2
			end
			options2.Divider.Set({Visible = data})
			options2.Name.Set({Visible = data})
			options2.Chip.Set({Visible = data})
			options2.Info.Set({Visible = data})
			if not data then
				options2.Icon.Set({Visible = false})
				return
			end
			data, configEntry = data7.Info, configMap2[data7.State] or configMap2.Slot
			condition6, set = Color3.fromHex(configEntry.Color), data.Icon
			set = if set and tonumber(set) then "rbxassetid://" .. tostring(set) else set
			options2.Icon.Set({Visible = set ~= nil, Image = set or "", StrokeColor = data.Color})
			options2.Name.Set({Text = callback44(data.Name), Color = data.Color, Gradient = nil, GradientRotation = 0})
			options2.Chip.Set({StrokeColor = condition6})
			options2.ChipText.Set({Text = configEntry.Text, Color = condition6})
			condition6 = {callback43(colorizeText("#4DFF7A", "Luck " .. toNumberOrDefault3(data7.Value))), callback43(colorizeText(data.Hex, callback44(string.upper(tostring(data.Rarity))))), colorizeText("#CDE7FF", callback44(data7.Area))}
			if (type(data7.Mutation) == "string") and (data7.Mutation ~= "") then
				condition6[#condition6 + 1] = callback43(colorizeText("#FFC24D", callback44(data7.Mutation)))
			end
			configEntry = number26 > 1
			if configEntry then
				condition6[#condition6 + 1] = colorizeText("#9FB8FF", number26 .. " matches")
			end
			set, color = options2.Info.Set, {}
			color.Text = table.concat(condition6, formattedText)
			set(color)
		end

		local function callback51()
			local condition6 = not options2.Card or (number18 <= 0)
			if condition6 then
				return
			end
			condition2 = false
			local number27, data7 = math.max(1, (number18 - number14) - 0.5), callback48(options2.Server)
			if data7 then
				options2.ServerUnits = data7 + 0.1
			else
				condition2 = true
			end
			local number28, set, data8 = math.min(options2.ServerUnits or 4, number27 * 0.45), options2.Title.Set, {X = number14, Y = 0.3}
			data8.Width, data8.Height = math.max(1, (number27 - number28) - number15), height
			set(data8)
			options2.Server.Set({X = (number14 + number27) - number28, Y = 0.3, Width = math.max(0.5, number28), Height = height})
			options2.Detail.Set({X = number14, Y = 0.3 + height, Width = number27, Height = 1})
			set, condition6 = condition4
			if set then
				options2.Bar.Set({X = number14, Y = number10 - 0.1, Width = number27, Height = 0.3})
				condition6 = number10 + number11
			else
				condition6 = number10
			end
			data7, number28 = condition5

			if data7 then
				set = callback48(options2.ChipText)
				if set then
					options2.ChipUnits = set + 0.9
				else
					condition2 = true
				end
				data8 = (number14 + number13) + 0.5
				local _ = math.max(1, (number18 - data8) - 0.5)
				local number29, number30 = math.min(options2.ChipUnits or 4, _ * 0.5), condition6 + 0.3
				options2.Divider.Set({X = number14, Y = condition6, Width = number27, Height = 0.06})
				options2.Icon.Set({X = number14, Y = number30, Width = number13, Height = number13})
				local set, data9 = options2.Name.Set, {X = data8, Y = number30}
				data9.Width, data9.Height = math.max(1, (_ - number29) - number15), height
				set(data9)
				options2.Chip.Set({X = (data8 + _) - number29, Y = number30 + ((height - number16) / 2), Width = number29, Height = number16})
				options2.ChipText.Set({X = 0, Y = 0, Width = number29, Height = number16})
				options2.Info.Set({X = data8, Y = number30 + height, Width = _, Height = 1})
				number28 = condition6 + number12
			else
				number28 = condition6
			end

			options2.Card.Set({X = 0, Y = 0, Width = number18, Height = number28})
			options2.Accent.Set({X = 0, Y = 0, Width = 0.22, Height = number28})
			data8 = math.abs(number28 - number23) > 0.01
			if data8 then
				number23 = number28
				argument5:SetContentLines(number28)
			end
		end

		local function callback52(argument)
			local value6 = bit32.bxor(339942210, 0)
			local value = value6
			argument5 = argument
			value6 = bit32.bxor(value, 107976459)
			options2.Card = argument:Frame({X = 0, Y = 0, Width = 1, Height = number10, Corner = 0.35, Background = "#000000", BackgroundTransparency = 1})
			options2.Accent = argument:Frame({Parent = options2.Card, X = 0, Y = 0, Width = 0.22, Height = number10, Corner = 0.11, Background = configMap.idle.Color, BackgroundTransparency = 0})
			options2.Title = argument:Text({Parent = options2.Card, X = number14, Y = 0.3, Width = 1, Height = height, Scale = 1.2, Wrap = false, Font = json2, TextStrokeTransparency = 1})
			options2.Server = argument:Text({Parent = options2.Card, X = number14, Y = 0.3, Width = 1, Height = height, Wrap = false, Align = "Right"})
			options2.Detail = argument:Text({Parent = options2.Card, X = number14, Y = 0.3 + height, Width = 1, Height = 1, Wrap = false})
			options2.Bar = argument:Bar({Parent = options2.Card, X = number14, Y = number10, Width = 1, Height = 0.3, Alpha = 0, Corner = 0.15, Background = "#2A2F3A", Visible = false})
			options2.Divider = argument:Frame({Parent = options2.Card, X = number14, Y = number10, Width = 1, Height = 0.06, Background = "#FFFFFF", BackgroundTransparency = 0.85, Visible = false})
			local data7 = {Parent = options2.Card, X = number14, Y = number10, Width = number13, Height = number13, Corner = 0.35, Background = "#000000", BackgroundTransparency = 0.45, StrokeThickness = number17, StrokeTransparency = 0, Visible = false}
			local value7
			value7, value6 = argument:Image(data7), u32Trunc((2147483647 + u32Mul(2147483648, value6)) + (0 + u32Mul(2147483647, (bit32.bnot((bit32.bxor(value6, 251238944)))))))
			options2.Icon = value7
			options2.Name = argument:Text({Parent = options2.Card, X = number14, Y = number10, Width = 1, Height = height, Scale = 1.2, Wrap = false, Font = json, TextStrokeTransparency = 1, StrokeTransparency = 0.2, StrokeThickness = number20, Visible = false})
			options2.Chip = argument:Frame({Parent = options2.Card, X = 0, Y = 0, Width = 1, Height = number16, Corner = 0.3, Background = "#000000", BackgroundTransparency = 0.35, StrokeThickness = number17, StrokeTransparency = 0, Visible = false})
			options2.ChipText = argument:Text({Parent = options2.Chip, X = 0, Y = 0, Width = 1, Height = number16, Scale = 0.78, Wrap = false, Align = "Center", Font = json2, TextStrokeTransparency = 1})
			options2.Info = argument:Text({Parent = options2.Card, X = number14, Y = number10, Width = 1, Height = 1, Wrap = false, Visible = false})
			data7 = {"Card", "Accent", "Title", "Server", "Detail", "Bar", "Divider", "Icon", "Name", "Chip", "ChipText", "Info"}
			for _, value8 in ipairs(data7) do
				callback47(options2[value8])
			end

			local function _(argument2, argument3, argument4)
				argument2 = (argument3 == number21) and (argument4 == number22)
				if argument2 then
					return
				end
				number21, number22 = argument3, argument4
				number18, number19 = argument3 / math.max(argument4, 1), argument4
				number20 = 0.9 / math.max(argument:TextSize(), 1)
				options2.Name.Set({StrokeThickness = number20})
				number24 = 2
			end

			argument:OnResize(_)
			condition3 = true
		end

		function data5.View()
			condition3 = true
		end
		local value6 = eggFinderSection:CreateCanvas({Name = "Hop Status", ShowTitle = false, Layout = "free", Style = {TextScale = 1, LineHeight = 1.1, MinLines = 2, MaxLines = 7, AutoHeight = true, BackgroundTransparency = 0.5, TextColor = Color3.fromRGB(255, 255, 255), TextStrokeTransparency = 0.7}, Build = function(_)
			callback52(_)
		end})
		registerItem(function()
			value6:Destroy()
		end)
		RunService2 = RunService
		local callback45_2 = RunService2.Heartbeat

		local function callback53(argument)
			local condition6 = not argument5 or not callback46(argument5:Root())
			if condition6 then
				return
			end
			number25 += argument
			condition6 = condition3 or (number25 >= 1)
			if condition6 then
				condition3, number25 = false, 0
				pcall(callback49)
			end
			pcall(callback50)
			argument = (number24 > 0) or condition2

			if argument then
				condition6 = number24 > 0
				if condition6 then
					number24 -= 1
				end
				pcall(callback51)
			end
		end

		local connection = callback45_2:Connect(callback53)
		registerItem(function()
			connection:Disconnect()
		end)
	end

	local readJsonFile_2
	readJsonFile_2, autoHopTab = data2, data2
	readJsonFile_2.HopHandles = autoHopTab.HopHandles or {}
	local data = data2
	data.HopHandles.Finder = function()
		return data5.Handle
	end

	data5.Handle = eggFinderSection:CreateToggle({Name = "Auto Hop", Note = "Joins new servers to find eggs that match the filters below", Default = false, Callback = function()
		local data6 = bit32.bxor(318695285, 0)
		local data = data6
		data5.Generation = data5.Generation + 1
		data6 = bit32.bxor(data, 368256243)
		data5.HopEnd = 0
		data = data2
		local condition2 = not data.Toggle(data5.Handle, false)

		if condition2 then
			pcall(data2.HopPrompt.Hide)
			if not data5.StopNote then
				callback36()
			end
			callback32(data5.StopNote or "Idle", "idle")
			data5.StopNote = nil
			return
		end

		condition2 = data2
		data = condition2.HopPrompt.Manual()
		data6 = u32Trunc((u32Mul(463758153, data6) + 2895388757) + (u32Mul(3831209144, (bit32.bor(data6, 495765677))) + u32Mul(3831209142, (bit32.band(data6, 495765677)))))
		if not data then
			callback42()
			return
		end
		callback36()
		callback32("Idle", "idle")

		condition2, data = data2, pcall(data2.HopPrompt.Show, {Title = "Auto Hop", Warn = "WARNING", Body = "Auto Hop keeps joining new servers to find eggs that match its filters. Turn it off to stop.", Tip = "\"Collect Then Hop\" and \"Wait For Target Egg\" hop until night, then wait for the next day.", Cancel = "Cancel", Accept = "Turn On"}, function()
			local data = data2
			if data.Toggle(data5.Handle, false) then
				callback42()
			end
		end, function()
			local value5 = bit32.bxor(333599609, 0)
			local value
			value, value5 = pcall, u32Trunc((u32Mul(1629480073, value5) + 679221750) + (u32Mul(2665487224, (bit32.bor(value5, 18913478))) + u32Mul(2665487222, (bit32.band(value5, 18913478)))))
			value(function()
				data5.Handle:Set(false)
			end)
		end)

		if not data then
			callback42()
		end
	end})

	local data = data2
	data.AutoHopActive = function()
		local data = data2
		return data.Toggle(data5.Handle, false) == true
	end
	options()

	eggFinderSection:CreateDropdown({Name = "Hop Mode", Note = "When to move on to the next server", Options = eggList, Default = eggList[1], SubOf = data5.Handle, Callback = function(argument)
		local argument2 = (table.find(eggList, argument) and argument) or eggList[1]
		if argument2 ~= data5.Mode then
			data5.Mode = argument2
			data5.HopEnd = 0
		end
	end})

	local function callback43(argument)
		local value, data = ipairs, data3
		local rarityChoices = data.RarityChoices
		for _, rarityChoice in value(rarityChoices) do
			data = data3
			if (data.RarityRank[rarityChoice] or 0) == argument then
				return rarityChoice
			end
		end
		data = data3
		return data.RarityChoices[1]
	end

	local function callback44(argument)
		local ks = {}
		for k, value5 in pairs(argument or {}) do
			if value5 == true then
				ks[#ks + 1] = k
			end
		end
		return ks
	end

	local function callback45(argument)
		local kMap = {}
		for k, value5 in pairs(argument or {}) do
			kMap[k] = value5
		end
		return kMap
	end

	local condition2, condition3, dropdown, value5, value6 = false, false

	local function callback46()
		local _ = bit32.bxor(246489386, 0)
		local value = _
		local condition = condition2
		local condition3
		if condition then
			condition3 = condition
		else
			local data
			data, condition3 = data4, type(data4.CollectFilters) ~= "function"
		end
		if condition3 then
			return
		end
		condition2 = true
		condition = data4
		local value7, value8, value9 = condition.CollectFilters()
		_ = u32Trunc((u32Mul(827072780, value) + 858316064) + (u32Mul(3467894517, (bit32.bor(value, 148781848))) + u32Mul(3467894515, (bit32.band(value, 148781848)))))
		data5.MinRank = tonumber(value7) or 0
		data5.Wanted = callback45(value8)
		data5.MinWeight = tonumber(value9) or 0
		value7 = nil
		value7, _ = pcall, bit32.bxor(_, 426182050)
		value7(function()
			value6:Set(data3.WeightStep(data5.MinWeight))
		end)
		pcall(function()
			dropdown:Set(callback43(data5.MinRank))
		end)
		pcall(function()
			value5:Set(callback44(data5.Wanted))
		end)
		condition2 = false
	end

	local function callback47()
		local _ = bit32.bxor(361034203, 0)
		local condition = _
		local condition4
		condition4, _ = condition2, u32Trunc(condition + 340418749)
		condition = (condition4 or not condition3) or not data5.Sync
		if condition then
			return
		end
		_, condition2 = u32Trunc(_ - 321574800), true
		pcall(function()
			local data = data4
			data.CollectRarity:Set(callback43(data5.MinRank))
		end)
		pcall(function()
			local data = data4
			data.CollectEggs:Set(callback44(data5.Wanted))
		end)
		pcall(function()
			local data = data4
			data.CollectWeight:Set(data3.WeightStep(data5.MinWeight or 0))
		end)
		condition2 = false
	end

	local data = data4
	data.OnCollectFilter = function()
		local condition4 = (data5.Sync and condition3) and not condition2
		if condition4 then
			callback46()
		end
	end
	eggFinderSection:CreateLabel({Name = "Collect Filters", Text = "Collect Filters", SubOf = data5.Handle})

	eggFinderSection:CreateToggle({Name = "Sync With Auto Collect Filters", Note = "Changing a filter here also changes it in Auto Collect Eggs, and back", Default = true, SubOf = data5.Handle, Callback = function(argument)
		data5.Sync = argument ~= false
		argument = data5.Sync and condition3
		if argument then
			callback46()
		end
	end})

	local options2, data = {Name = "Min Egg Rarity", Note = "Find eggs of the chosen rarity and every rarity above it"}, data3
	options2.Options = data.RarityChoices
	readJsonFile_2 = data3
	options2.Default = readJsonFile_2.RarityChoices[1]
	options2.SubOf = data5.Handle

	options2.Callback = function(argument)
		local condition = condition2
		if condition then
			return
		end
		condition = data3
		data5.MinRank = condition.RarityRank[tostring(argument)] or 0
		callback47()
	end

	dropdown = eggFinderSection:CreateDropdown(options2)
	local callback, options3, value7 = callback4, {Name = "Target Eggs", Note = "Only look for these eggs (empty = all)"}
	local options_2 = names
	options3.Options = options_2
	options3.Default = {}
	options3.SubOf = data5.Handle

	local function callback48(argument)
		local condition = condition2
		if condition then
			return
		end
		data5.Wanted = callback7(argument)
		callback47()
	end

	options3.Callback = callback48
	value5 = callback(eggFinderSection:CreateMultiDropdown(options3))
	mainWindow = data3
	options3, options_2, autoHopTab = mainWindow.WeightSlider, eggFinderSection, {Name = "Min Egg Weight", SubOf = data5.Handle}

	local function onRaw(minWeight)
		local condition = condition2
		if condition then
			return
		end
		data5.MinWeight = minWeight
		callback47()
	end

	autoHopTab.OnRaw = onRaw
	value6 = options3(options_2, autoHopTab)
	eggFinderSection:CreateLabel({Name = "Wait For Target Egg", Text = "Wait For Target Egg", SubOf = data5.Handle})
	local options4, data = {Name = "Rarity To Wait For"}, data3
	options4.Options = data.RarityChoices
	options4.Default = "Divine"
	options4.SubOf = data5.Handle
	options4.Callback = function(argument)
		local data = data3
		data5.WaitRank = data.RarityRank[tostring(argument)] or 0
	end
	eggFinderSection:CreateDropdown(options4)
	options_2, autoHopTab, mainWindow = callback4, {Name = "Eggs To Wait For"}, names
	autoHopTab.Options = mainWindow
	autoHopTab.Default = {}
	autoHopTab.SubOf = data5.Handle
	local function callback49(argument)
		data5.WaitEggs = callback7(argument)
	end
	autoHopTab.Callback = callback49
	options_2(eggFinderSection:CreateMultiDropdown(autoHopTab))
	eggFinderSection:CreateLabel({Name = "Hop Timing", Text = "Hop Timing", SubOf = data5.Handle})
	eggFinderSection:CreateSlider({Name = "Hop Delay", Note = "Wait this long after the script starts before the first hop", Min = 3, Max = 10, Default = 5, AllowDecimals = true, Increment = 0.5, Unit = "s", SubOf = data5.Handle, Callback = function(argument)
		data5.HopDelay = math.clamp(tonumber(argument) or 5, 3, 10)
	end})
	eggFinderSection:CreateSlider({Name = "Wait In Each Server", Note = "Extra time to wait for a matching egg to spawn before hopping (0 = off)", Min = 0, Max = 120, Default = 5, Increment = 1, Unit = "s", SubOf = data5.Handle, Callback = function(argument)
		data5.Wait = math.clamp(tonumber(argument) or 5, 0, 120)
	end})
	task.delay(5, function()
		condition3 = true
		if data5.Sync then
			callback46()
		end
	end)
	registerItem(function()
		data5.Generation = data5.Generation + 1
		local data = data4
		data.OnCollectFilter = nil
	end)
end

callback28()
local miscTab = mainWindow:CreateTab({ Name = "Misc", SectionsExpanded = true })
local performanceSection = miscTab:CreateSection({ Name = "Performance", Expanded = true })

local function callback29()
	local value3, condition2 = bit32.bxor(402213268, 0), false
	value3 = u32Trunc(value3 + 489645316)
	local performanceSection = performanceSection
	value3 = u32Trunc(value3 - 454747207)

	performanceSection:CreateSlider({Name = "FPS Cap", Min = 30, Max = 1000, Default = 240, AllowDecimals = false, Increment = 1, Unit = " FPS", Callback = function(argument)
		local number3 = math.clamp(math.floor(tonumber(argument) or 240), 30, 1000)
		argument = (type(setfpscap) == "function") and pcall(setfpscap, number3)
		if argument then
			condition2 = false
			return
		end
		argument = not condition2
		if argument then
			condition2 = true
			callback6("FPS Cap Unavailable", "This environment does not support setfpscap.")
		end
	end})
end

callback29()

local function callback30()
	local value3 = bit32.bxor(332516357, 0)
	local Lighting, number3, condition2, number4 = game:GetService("Lighting"), 0.003, false, 0
	value3 = u32Trunc(value3 + 51378870)
	local thread
	local connections, list, performanceSection2, data5 = {}, {}
	performanceSection2, data5, value3 = setmetatable, {__mode = "k"}, u32Trunc(value3 + 383700880)
	local value4, descendants, connection = performanceSection2({}, data5), {}

	local function callback31(argument, _, argument2)
		local ok, response = pcall(argument)
		if not ok then
			return
		end
		list[#list + 1] = {Setter = _, Value = response}
		pcall(_, argument2)
	end

	local function callback32(_, argument, argument2)
		local value5 = bit32.bxor(309826652, 0)
		local argumentMap = value4[_]
		value5 = u32Trunc((u32Mul(1818968999, value5) + 832678798) + (u32Mul(657029298, (bit32.bor(value5, 333267394))) + u32Mul(1818969000, (bit32.bxor(value5, 333267394)))))
		local condition3 = not argumentMap
		value5 = bit32.bxor(value5, 39141397)
		if condition3 then
			argumentMap = {}
			value4[_] = argumentMap
		end

		if argumentMap[argument] == nil then
			local value6 = bit32.bxor(19760633, 0)
			condition3 = nil
			condition3, value6 = pcall, u32Trunc(value6 + 347567795)
			local value7, value8 = condition3(function()
				return _[argument]
			end)
			if not value7 then
				return
			end
			argumentMap[argument] = {Value = value8}
		end

		pcall(function()
			_[argument] = argument2
		end)
	end

	local function callback44(argument)
		local condition3 = not condition2 or not argument.Parent
		if condition3 then
			return
		end

		if argument:IsA("ParticleEmitter") then
			callback32(argument, "Enabled", false)
			callback32(argument, "Rate", 0)
		elseif argument:IsA("Trail") or argument:IsA("Beam") then
			callback32(argument, "Enabled", false)
		elseif (argument:IsA("PointLight") or argument:IsA("SpotLight")) or argument:IsA("SurfaceLight") then
			callback32(argument, "Enabled", false)
			callback32(argument, "Brightness", 0)
		elseif (argument:IsA("Fire") or argument:IsA("Smoke")) or argument:IsA("Sparkles") then
			callback32(argument, "Enabled", false)
		elseif argument:IsA("Explosion") then
			callback32(argument, "Visible", false)
		elseif argument:IsA("SpecialMesh") then
			callback32(argument, "TextureId", "")
		elseif argument:IsA("Decal") or argument:IsA("Texture") then
			if not (((argument.Name == "face") and argument.Parent) and (argument.Parent.Name == "Head")) then
				callback32(argument, "Transparency", 1)
			end
		elseif argument:IsA("MeshPart") then
			callback32(argument, "RenderFidelity", Enum.RenderFidelity.Performance)
			callback32(argument, "TextureID", "")
			callback32(argument, "CastShadow", false)
			callback32(argument, "Reflectance", 0)
			callback32(argument, "Material", Enum.Material.SmoothPlastic)
		elseif argument:IsA("BasePart") then
			callback32(argument, "CastShadow", false)
			callback32(argument, "Reflectance", 0)
			callback32(argument, "Material", Enum.Material.SmoothPlastic)
		elseif argument:IsA("PostEffect") then
			callback32(argument, "Enabled", false)
		elseif argument:IsA("Clouds") then
			callback32(argument, "Cover", 0)
			callback32(argument, "Density", 0)
		elseif argument:IsA("Atmosphere") then
			callback32(argument, "Density", 0)
			callback32(argument, "Haze", 0)
			callback32(argument, "Glare", 0)
		end
	end

	local function disconnectAll()
		for _, connection2 in ipairs(connections) do
			if connection2.Connected then
				connection2:Disconnect()
			end
		end
		table.clear(connections)
		local connection2 = connection

		if connection2 then
			local value5 = bit32.bxor(128232098, 0)
			local value = value5
			local value2
			value2, value5 = pcall, u32Trunc((u32Mul(469229108, value) + 4253186548) + (u32Mul(3356509080, (bit32.bor(value, 53071537))) + u32Mul(469229109, (bit32.bxor(value, 53071537)))))
			value2(function()
				connection:Disconnect()
			end)
			connection = nil
		end
	end

	local function callback33()
		local value5 = bit32.bxor(188569305, 0)
		local value = value5
		local ok, number5, rendering = settings(), u32Mul(2635976427, value) + 3755106693
		value5, rendering = u32Trunc(number5 + (u32Mul(1658990870, (bit32.bor(value, 31642959))) + u32Mul(1658990868, (bit32.band(value, 31642959))))), ok.Rendering
		value5 = bit32.bxor(value5, 284054844)
		value = workspace.Terrain

		local function callback34(argument, argument2, argument3)
			local value6 = bit32.bxor(211810542, 0)
			value6 = u32Trunc((u32Mul(1067892099, value6) + 2423444515) + (u32Mul(3227075198, (bit32.bor(value6, 97610977))) + u32Mul(3227075196, (bit32.band(value6, 97610977)))))
			callback31(function()
				return argument[argument2]
			end, function(argument4)
				argument[argument2] = argument4
			end, argument3)
		end

		callback34(rendering, "QualityLevel", Enum.QualityLevel.Level01)
		callback34(rendering, "MeshPartDetailLevel", Enum.MeshPartDetailLevel.Level01)
		callback34(rendering, "EditQualityLevel", Enum.QualityLevel.Level01)
		ok, rendering = pcall(function()
			return UserSettings():GetService("UserGameSettings")
		end)
		if ok and rendering then
			callback34(rendering, "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
		end
		callback34(Lighting, "GlobalShadows", false)
		callback34(Lighting, "ShadowSoftness", 0)
		callback34(Lighting, "FogEnd", 9000000000)
		callback34(Lighting, "Technology", Enum.Technology.Legacy)
		callback34(Lighting, "EnvironmentDiffuseScale", 0)
		callback34(Lighting, "EnvironmentSpecularScale", 0)
		callback34(value, "Decoration", false)
		callback34(value, "WaterWaveSize", 0)
		callback34(value, "WaterWaveSpeed", 0)
		callback34(value, "WaterReflectance", 0)
		callback34(value, "WaterTransparency", 1)
	end

	local function callback34(argument, argument2)
		local now, value, descendants2 = os.clock(), ipairs, table.pack(argument:GetDescendants())

		for k, value5 in value(table.unpack(descendants2, 1, descendants2.n)) do
			argument = not condition2 or (number4 ~= argument2)
			if argument then
				return false
			end
			callback44(value5)
			value5 = (os.clock() - now) > number3
			if value5 then
				k = RunService
				k.Heartbeat:Wait()
				now = os.clock()
			end
		end

		return true
	end

	local function callback35()
		local condition3 = not condition2 or (#descendants == 0)
		if condition3 then
			return
		end
		condition3 = os.clock()
		while #descendants > 0 do
			callback44((table.remove(descendants)))
			if (os.clock() - condition3) > number3 then
				break
			end
		end
	end

	local function callback36()
		local clock, value = os.clock, pairs
		local now = clock()

		for k, value5 in value(value4) do
			if k.Parent then
				for k2, value6 in pairs(value5) do
					local value7 = bit32.bxor(77944500, 0)
					clock = value7
					local value
					value, value7 = pcall, u32Trunc((u32Mul(1231658332, clock) + 3106393512) + (u32Mul(3063308965, (bit32.bor(368768934, clock))) + u32Mul(3063308963, (bit32.band(368768934, clock)))))
					value(function()
						k[k2] = value6.Value
					end)
				end
			end

			value4[k] = nil
			value5 = (os.clock() - now) > number3
			if value5 then
				local RunService = RunService
				RunService.Heartbeat:Wait()
				now = os.clock()
			end
		end
	end

	local function callback37()
		local condition = condition2
		if not condition then
			return
		end
		condition2 = false
		number4 += 1
		disconnectAll()
		table.clear(descendants)
		condition = thread
		if condition then
			pcall(task.cancel, thread)
			thread = nil
		end
		callback36()
		for i = #list, 1, -1 do
			condition = list[i]
			pcall(condition.Setter, condition.Value)
		end
		table.clear(list)
	end

	local function callback38()
		local value5 = bit32.bxor(436805043, 0)
		local value = value5
		local condition = condition2
		if condition then
			return
		end
		condition2 = true
		number4 += 1
		value5 = u32Trunc((u32Mul(1366993483, value) + 3951777620) + (u32Mul(1560980330, (bit32.bor(value, 524923260))) + u32Mul(1366993484, (bit32.bxor(value, 524923260)))))
		local number = number4
		value5 = bit32.bxor(value5, 91218367)
		callback33()

		local function callback39(argument)
			local value6 = bit32.bxor(94386998, 0)
			local value = value6
			value6 = u32Trunc(value + 207122959)
			value6 = u32Trunc(value6 + 106394840)
			connections[#connections + 1] = argument.DescendantAdded:Connect(function(descendant)
				local condition3 = condition2 and (number4 == number)
				if condition3 then
					descendants[#descendants + 1] = descendant
				end
			end)
		end

		callback39(workspace)
		callback39(Lighting)
		condition = RunService
		connection = condition.Heartbeat:Connect(function()
			local condition3 = condition2 and (number4 == number)
			if condition3 then
				callback35()
			end
		end)
		thread = task.spawn(function()
			if callback34(workspace, number) then
				callback34(Lighting, number)
			end
		end)
	end

	registerItem(callback37)

	do
		local value5, condition3 = bit32.bxor(533105739, 0), false
		value5 = bit32.bxor(value5, 218842940)
		local folder
		local argumentMap, connections2 = {}, {}
		local function callback39()
			local data = data3
			return data.Plot()
		end

		local function callback40(argument)
			local value6 = bit32.bxor(147173083, 0)
			local value = value6
			local condition4 = (not condition3 or not folder) or argumentMap[argument]
			if condition4 then
				return
			end
			value6 = u32Trunc(value + 8351626)
			argumentMap[argument] = argument.Parent
			condition4 = nil
			condition4, value6 = pcall, u32Trunc(value6 + 454790099)
			condition4(function()
				argument.Parent = folder
			end)
		end

		value5 = bit32.bxor(value5, 174683271)

		local function callback41(argument)
			local value6 = bit32.bxor(16091105, 0)
			local value = value6
			local children
			value6, children = u32Trunc(value + 4150605), callback39()
			if argument == children then
				return
			end
			value = argument:FindFirstChild("Pets")
			if not value then
				return
			end
			argument, children = ipairs, table.pack(value:GetChildren())
			value6 = u32Trunc(value6 + 101750717)
			for _, value7 in argument(table.unpack(children, 1, children.n)) do
				callback40(value7)
			end
			connections2[#connections2 + 1] = value.ChildAdded:Connect(function(child)
				task.defer(callback40, child)
			end)
		end

		local function callback42()
			condition3 = false

			for i, value6 in ipairs(connections2) do
				local value7 = bit32.bxor(277977098, 0)
				i = value7
				local value
				value, value7 = pcall, u32Trunc(i + 260883628)
				value(function()
					value6:Disconnect()
				end)
			end

			table.clear(connections2)

			for k, value6 in pairs(argumentMap) do
				local value7 = bit32.bxor(160202711, 0)
				local value
				value, value7 = pcall, bit32.bxor(value7, 382462873)
				value(function()
					if value6 and value6.Parent then
						k.Parent = value6
					end
				end)
			end

			table.clear(argumentMap)
		end

		local function callback43()
			local value6 = bit32.bxor(463131659, 0)
			local value = value6
			local condition = condition3
			value6 = u32Trunc((u32Mul(200540203, value) + 1806556496) + (u32Mul(3893886890, (bit32.bor(value, 66691056))) + u32Mul(200540204, (bit32.bxor(value, 66691056)))))
			if condition then
				return
			end
			condition3 = true
			value = not folder
			if value then
				folder = Instance.new("Folder")
				local folder = folder
				local value7
				folder.Name = generateRandomId()
			end
			condition = workspace:FindFirstChild("Plots")
			if not condition then
				return
			end
			for _, child in ipairs(condition:GetChildren()) do
				callback41(child)
			end
			local number5, childAdded
			number5, childAdded, value6 = #connections2 + 1, condition.ChildAdded, bit32.bxor(value6, 194539231)

			connections2[number5] = childAdded:Connect(function(argument)
				task.wait(1)
				local condition = condition3
				if condition then
					callback41(argument)
				end
			end)
		end

		registerItem(callback42)
		performanceSection2 = performanceSection

		performanceSection2:CreateToggle({Name = "Hide Other Players' Pets", Note = "Hides pets on other plots on your screen only, big FPS gain", Default = false, Callback = function(argument)
			if argument then
				callback43()
			else
				callback42()
			end
		end})

		data5 = performanceSection

		data5:CreateToggle({Name = "Disable 3D Rendering", Note = "Stops drawing the world while you AFK, the farm keeps running", Default = false, Callback = function(argument)
			local value6 = bit32.bxor(11755088, 0)
			local value
			value, value6 = pcall, u32Trunc(value6 + 240987347)
			value(function()
				local RunService = RunService
				RunService:Set3dRenderingEnabled(argument ~= true)
			end)
		end})

		registerItem(function()
			local value6 = bit32.bxor(512085547, 0)
			local value
			value, value6 = pcall, u32Trunc(value6 + 80287363)
			value(function()
				local RunService = RunService
				RunService:Set3dRenderingEnabled(true)
			end)
		end)
	end

	performanceSection2 = performanceSection

	performanceSection2:CreateToggle({Name = "Optimizer", Note = "Strip shadows, textures and effects for the highest FPS", Default = false, Callback = function(argument)
		if argument then
			callback38()
		else
			task.spawn(callback37)
		end
	end})
end

callback30()

local function callback31()
	local value3 = bit32.bxor(456315631, 0)
	local Stats, number3, number4, number5, number6 = game:GetService("Stats"), 132, 34, 0.085, 0.2
	value3 = bit32.bxor(value3, 280438407)
	local number7 = 8
	local value4
	local mainWindow = mainWindow
	local value5 = mainWindow:CreateState({Name = "FPS and Ping Position", Default = {}})
	value3 = u32Trunc((u32Mul(628402222, value3) + 2204163136) + (u32Mul(3038162852, (bit32.bor(value3, 111556320))) + u32Mul(628402223, (bit32.bxor(value3, 111556320)))))

	local function getUDim2()
		local value6 = value5:Get()
		if ((type(value6) == "table") and (type(value6.XOffset) == "number")) and (type(value6.YOffset) == "number") then
			return UDim2.new(tonumber(value6.XScale) or 0, value6.XOffset, tonumber(value6.YScale) or 0, value6.YOffset)
		end
		return UDim2.new(0, 16, 0, 16)
	end

	local function callback32(argument)
		value5:Set({XScale = argument.X.Scale, XOffset = argument.X.Offset, YScale = argument.Y.Scale, YOffset = argument.Y.Offset})
	end
	local color = Color3.fromRGB(58, 255, 55)
	local color2 = Color3.fromRGB(255, 214, 84)
	local color3 = Color3.fromRGB(255, 96, 96)
	local color4, _, connections, screenGui, frame, uiScale, textLabel3, textLabel4 = Color3.fromRGB(150, 150, 158), false, {}
	local number8, number9, number10, text3, text4, font = 1, 0, 0
	pcall(function()
		font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	end)

	local function callback33(argument)
		if argument >= 100 then
			return color
		elseif argument >= 50 then
			return color2
		end
		return color3
	end

	local function callback34(argument)
		if argument <= 90 then
			return color
		elseif argument <= 180 then
			return color2
		end
		return color3
	end

	local function clampValue()
		local uiScale2 = uiScale
		if not uiScale2 then
			return
		end
		uiScale2 = workspace.CurrentCamera
		local viewportSize = (uiScale2 and uiScale2.ViewportSize) or Vector2.new(1280, 720)
		viewportSize = if viewportSize.X < 1 then Vector2.new(1280, 720) else viewportSize
		local number11, uiScale = math.clamp((viewportSize.X * number5) / number3, 0.7, 1.4), uiScale
		uiScale.Scale = number11 * number8
	end

	local function disconnectAll()
		for i, connection in ipairs(connections) do
			local value6 = bit32.bxor(117657434, 0)
			i = nil
			i, value6 = pcall, bit32.bxor(value6, 322222413)
			i(function()
				connection:Disconnect()
			end)
		end

		table.clear(connections)
		local screenGui2 = screenGui

		if screenGui2 then
			local value6 = bit32.bxor(24916775, 0)
			local value = value6
			local value2
			value2, value6 = pcall, u32Trunc(value + 352422289)
			value2(function()
				screenGui:Destroy()
			end)
		end

		screenGui, frame, uiScale, textLabel3, textLabel4, text3, text4, number9 = nil, nil, nil, nil, nil, nil, nil, 0
	end

	local function createTextLabel(parent, argument, argument2, textColor3)
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = generateRandomId()
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.fromOffset(argument, 9)
		textLabel.Size = UDim2.fromOffset(argument2, 16)
		textLabel.Text = ""
		textLabel.TextColor3 = textColor3
		textLabel.TextScaled = true
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		argument2 = font
		if argument2 then
			textLabel.FontFace = font
		else
			textLabel.Font = Enum.Font.GothamBold
		end
		textLabel.Parent = parent
		return textLabel
	end

	local function callback35()
		local value6 = bit32.bxor(188577221, 0)
		local RunService2 = value6
		disconnectAll()
		screenGui = Instance.new("ScreenGui")
		local uiElement = screenGui
		local value7
		uiElement.Name = generateRandomId()
		screenGui.Archivable = false
		screenGui.DisplayOrder = 58
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		uiElement = screenGui
		uiElement.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		frame = Instance.new("Frame")
		uiElement = frame
		uiElement.Name = generateRandomId()
		frame.Active = true
		uiElement = frame
		uiElement.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
		frame.BackgroundTransparency = 0.28
		frame.BorderSizePixel = 0
		uiElement = frame
		uiElement.Position = getUDim2()
		uiElement = frame
		uiElement.Size = UDim2.fromOffset(number3, number4)
		frame.Parent = screenGui
		uiElement = Instance.new("UICorner")
		uiElement.Name = generateRandomId()
		uiElement.CornerRadius = UDim.new(0, 12)
		uiElement.Parent = frame
		uiElement = Instance.new("UIStroke")
		uiElement.Name = generateRandomId()
		uiElement.Color = Color3.fromRGB(255, 255, 255)
		uiElement.Thickness = 1
		uiElement.Transparency = 0.9
		uiElement.Parent = frame
		uiScale = Instance.new("UIScale")
		uiElement = uiScale
		uiElement.Name = generateRandomId()
		uiScale.Parent = frame
		clampValue()
		textLabel3 = createTextLabel(frame, 12, 34, color)
		createTextLabel(frame, 48, 22, color4).Text = "FPS"
		uiElement = Instance.new("Frame")
		uiElement.Name = generateRandomId()
		uiElement.AnchorPoint = Vector2.new(0.5, 0.5)
		uiElement.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		uiElement.BackgroundTransparency = 0.85
		uiElement.BorderSizePixel = 0
		local uDim2New, UserInputService2 = UDim2.new, u32Trunc(number4)
		value6, uiElement.Position = u32Trunc((3830519896 + RunService2) + (u32Mul(3582946353, UserInputService2) + u32Mul(3582946353, (bit32.bnot(UserInputService2))))), uDim2New(0, 74, 0.5, 0)
		uiElement.Size = UDim2.fromOffset(1, 14)
		uiElement.Parent = frame
		textLabel4 = createTextLabel(frame, 82, 30, color)
		createTextLabel(frame, 113, 14, color4).Text = "ms"
		uDim2New = value2
		screenGui.Parent = uDim2New
		uDim2New = workspace.CurrentCamera
		if uDim2New then
			connections[#connections + 1] = uDim2New:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue)
		end
		local condition2 = false
		local input
		local vector2Zero = Vector2.zero
		local position

		connections[#connections + 1] = frame.InputBegan:Connect(function(input2)
			local condition3 = condition2 or (input2.UserInputState ~= Enum.UserInputState.Begin)
			if condition3 then
				return
			end
			local condition4, condition5 = input2.UserInputType == Enum.UserInputType.MouseButton1, input2.UserInputType == Enum.UserInputType.Touch
			if not condition4 and not condition5 then
				return
			end
			condition2 = true
			input = (condition5 and input2) or nil
			vector2Zero = Vector2.new(input2.Position.X, input2.Position.Y)
			position = frame.Position
		end)

		local value8, UserInputService3

		UserInputService3, connections[#connections + 1] = UserInputService, UserInputService.InputChanged:Connect(function(input2)
			local condition3 = (not condition2 or not frame) or not position
			if condition3 then
				return
			end
			condition3 = (input and (input2 == input)) or (not input and (input2.UserInputType == Enum.UserInputType.MouseMovement))
			if not condition3 then
				return
			end
			local number11, frame = Vector2.new(input2.Position.X, input2.Position.Y) - vector2Zero, frame
			frame.Position = UDim2.new(position.X.Scale, position.X.Offset + number11.X, position.Y.Scale, position.Y.Offset + number11.Y)
		end)

		UserInputService2 = nil

		UserInputService2, connections[#connections + 1] = UserInputService, UserInputService.InputEnded:Connect(function(input2)
			local condition = condition2
			if not condition then
				return
			end
			condition = (input and (input2 == input)) or (not input and (input2.UserInputType == Enum.UserInputType.MouseButton1))

			if condition then
				condition2, input, position = false, nil, nil
				input2 = frame
				if input2 then
					callback32(frame.Position)
				end
			end
		end)

		local number11 = #connections + 1
		local value9
		RunService2 = RunService
		UserInputService3 = RunService2.RenderStepped

		local function callback36(argument)
			local textLabel = bit32.bxor(165881902, 0)
			local textLabel2 = textLabel
			local text5 = not _ or not textLabel3
			if text5 then
				return
			end
			text5 = math.clamp(argument, 0.001, 1)
			local text6, condition3 = 1 / text5, number9 <= 0
			if condition3 then
				number9 = text6
			else
				argument = number9
				number9 = argument + ((text6 - argument) * (1 - math.exp(-text5 * number7)))
			end
			text5, condition3 = os.clock(), number10
			if text5 < condition3 then
				return
			end
			argument = text5 + number6
			number10 = argument
			textLabel = bit32.bxor(textLabel2, 383859623)
			text5 = math.floor(number9 + 0.5)
			text6 = tostring(text5)
			condition3 = text6 ~= text3
			if condition3 then
				text3 = text6
				textLabel3.Text = text6
				textLabel2 = textLabel3
				textLabel2.TextColor3 = callback33(text5)
			end
			local number12 = 0
			text5 = u32Trunc(argument)
			textLabel = u32Trunc((bit32.bxor(textLabel, 76000462) + 4087867196) + (u32Mul(4087867196, text5) + u32Mul(4087867196, (bit32.bnot(text5)))))
			pcall(function()
				number12 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
			end)
			text6 = math.floor(number12 + 0.5)
			text5 = tostring(text6)
			textLabel2 = text5 ~= text4
			if textLabel2 then
				text4 = text5
				textLabel4.Text = text5
				argument = textLabel4
				argument.TextColor3 = callback34(text6)
			end
		end

		connections[number11] = UserInputService3:Connect(callback36)
	end

	mainWindow = performanceSection

	performanceSection:CreateSlider({Name = "FPS and Ping Size", Min = 60, Max = 160, Default = 100, AllowDecimals = false, Increment = 1, Unit = "%", SubOf = mainWindow:CreateToggle({Name = "FPS and Ping", Default = true, Callback = function(argument)
		_ = argument == true
		argument = _
		if argument then
			callback35()
		else
			disconnectAll()
		end
	end}), Callback = function(argument)
		number8 = math.clamp((tonumber(argument) or 100) / 100, 0.6, 1.6)
		clampValue()
	end})

	registerItem(disconnectAll)
end

callback31()

local function callback32()
	local value3 = bit32.bxor(3833823, 0)
	local miscTab = miscTab
	local utilitySection, data5 = miscTab:CreateSection({Name = "Utility", Expanded = true}), {Enabled = true}
	value3 = bit32.bxor(value3, 16938084)
	data5.Alive = true
	data5.Silenced = {}
	miscTab = game:GetService("GuiService")
	local gameRef
	gameRef, value3 = game, u32Trunc((u32Mul(133050183, value3) + 559063056) + (u32Mul(4161917114, (bit32.bor(value3, 320145264))) + u32Mul(4161917112, (bit32.band(value3, 320145264)))))
	local TeleportService2 = gameRef:GetService("TeleportService")
	local callback33
	local function callback34()
		if (data5.Alive and data5.Enabled) and callback33 then
			task.defer(callback33)
		end
	end
	local callback35, value4

	callback35 = function()
		if type(getconnections) ~= "function" then
			return {}
		end
		local localPlayer, ok, response = localPlayer, pcall(getconnections, localPlayer.Idled)
		return ((ok and (type(response) == "table")) and response) or {}
	end

	local function callback36()
		local value, value5 = ipairs, table.pack(callback35())

		for k, value6 in value(table.unpack(value5, 1, value5.n)) do
			local value7, condition2 = bit32.bxor(388181626, 0), false
			value7 = u32Trunc(value7 + 371730000)
			k = nil
			k, value7 = pcall, u32Trunc(value7 - 78274133)
			k(function()
				condition2 = value6.Function == callback34
			end)
			local condition3 = not condition2
			local condition4

			if condition3 then
				local value8 = bit32.bxor(128996047, 0)
				k = nil
				k, value8 = pcall, u32Trunc(value8 + 87669104)
				condition4 = k(function()
					value6:Disable()
				end)
			else
				condition4 = condition3
			end

			if condition4 and not table.find(data5.Silenced, value6) then
				data5.Silenced[#data5.Silenced + 1] = value6
			end
		end
	end

	local function callback37()
		local silenced = data5.Silenced
		local number3 = #silenced

		for i, value5 in ipairs(if number3 == 0 then callback35() else silenced) do
			local value6 = bit32.bxor(311375238, 0)
			i = value6
			local value, value7 = pcall, u32Trunc(number3)
			value6 = u32Trunc((4178296146 + i) + (u32Mul(3896042731, value7) + u32Mul(3896042731, (bit32.bnot(value7)))))
			value(function()
				value5:Enable()
			end)
		end

		table.clear(data5.Silenced)
	end

	local localPlayer2, data6 = setmetatable, {__index = function()
		return function()
		end
	end}
	local value5, list = localPlayer2({}, data6), {}

	local function callback38()
		local list2 = {}
		if ((type(getgc) ~= "function") or (type(debug) ~= "table")) or (type(debug.getupvalues) ~= "function") then
			return list2
		end
		local ok, response = pcall(getgc, false)
		if not ok or (type(response) ~= "table") then
			return list2
		end

		for i, value6 in ipairs(response) do
			if (type(value6) == "function") and islclosure(value6) then
				i, ok = pcall(debug.info, value6, "s")

				if (i and (type(ok) == "string")) and string.find(ok, "AntiAFK", 1, true) then
					local ok2, response2 = pcall(debug.getupvalues, value6)

					if ok2 and (type(response2) == "table") then
						for k, value7 in pairs(response2) do
							if (typeof(value7) == "Instance") and (value7.ClassName == "TeleportService") then
								list2[#list2 + 1] = {Fn = value6, Index = k, Original = value7}
							end
						end
					end
				end
			end
		end

		return list2
	end

	local function callback39()
		for _, value6 in ipairs(callback38()) do
			local ok, response = pcall(debug.getupvalue, value6.Fn, value6.Index)
			if ok and (typeof(response) == "Instance") then
				if pcall(debug.setupvalue, value6.Fn, value6.Index, value5) then
					list[#list + 1] = value6
				end
			end
		end
	end

	local function callback40()
		for _, value6 in ipairs(list) do
			pcall(debug.setupvalue, value6.Fn, value6.Index, value6.Original)
		end
		table.clear(list)
	end
	local function callback41()
		callback36()
		if #list == 0 then
			callback39()
		end
	end

	do
		localPlayer2 = localPlayer

		local function callback42()
			local value6 = bit32.bxor(126959718, 0)
			local value = value6
			local value2 = task
			value6 = u32Trunc((u32Mul(2835519536, value) + 1421014816) + (u32Mul(1459447761, (bit32.bor(value, 327549478))) + u32Mul(1459447759, (bit32.band(value, 327549478)))))
			value = value2.delay
			value6 = bit32.bxor(value6, 454745406)
			value(1, function()
				if data5.Alive and data5.Enabled then
					table.clear(data5.Silenced)
					pcall(callback41)
				end
			end)
		end

		local connection = localPlayer2.CharacterAdded:Connect(callback42)

		registerItem(function()
			local value6 = bit32.bxor(25318255, 0)
			local value
			value, value6 = pcall, u32Trunc(value6 + 73255967)
			value(function()
				connection:Disconnect()
			end)
		end)
	end

	localPlayer2 = localPlayer
	local connection = localPlayer2.Idled:Connect(callback34)

	local function callback42(argument)
		local pos = ((data5.Alive and data5.Enabled) and (type(argument) == "string")) and string.find(string.lower(argument), "idle", 1, true)

		if pos then
			local value6 = bit32.bxor(241957022, 0)
			argument = value6
			local value = task
			value6 = u32Trunc((u32Mul(3857139918, argument) + 3203473318) + (u32Mul(875654756, (bit32.band(argument, 452212149))) + u32Mul(437827379, (bit32.bxor(argument, 452212149)))))
			local delay = value.delay
			value6 = bit32.bxor(value6, 340541221)

			delay(2, function()
				local value7 = bit32.bxor(142198169, 0)
				local value
				value, value7 = pcall, u32Trunc(value7 + 506510442)
				value(function()
					TeleportService2:Teleport(game.PlaceId, localPlayer)
				end)
			end)
		end
	end

	local connection2 = miscTab.ErrorMessageChanged:Connect(callback42)

	registerItem(function()
		local value6 = bit32.bxor(405904062, 0)
		local value = value6
		value6 = u32Trunc((u32Mul(736586656, value) + 4060213184) + (u32Mul(2821793984, (bit32.bor(value, 426963862))) + u32Mul(736586657, (bit32.bxor(value, 426963862)))))
		value6 = bit32.bxor(value6, 219517521)
		data5.Alive = false
		pcall(function()
			connection:Disconnect()
		end)
		pcall(function()
			connection2:Disconnect()
		end)
		callback37()
		callback40()
	end)

	local number3, number4 = 600, 0

	callback33 = function()
		callback36()
		number4 += 1
		local condition2 = (#list == 0) or ((number4 % 2) == 0)
		if condition2 then
			callback39()
		end
	end

	task.spawn(function()
		while data5.Alive do
			if data5.Enabled then
				callback33()
			end
			task.wait(number3)
		end
	end)

	utilitySection:CreateToggle({Name = "Anti AFK", Default = true, Callback = function(argument)
		data5.Enabled = argument ~= false
		if data5.Enabled then
			callback41()
		else
			callback37()
			callback40()
		end
	end})
end

callback32()

local function callback33(argument, argument2)
	local HttpService2 = game:GetService("HttpService")
	local httpRequest = syn
	httpRequest = httpRequest and syn.request
	local httpRequest2
	if httpRequest then
		httpRequest2 = httpRequest
	else
		httpRequest = http
		httpRequest2 = httpRequest and http.request
	end
	local httpRequest3 = httpRequest2 or http_request
	local httpRequest4 = httpRequest3 or request
	local webhookSection = data2.WebhookSection or miscTab:CreateSection({ Name = "Webhook", Expanded = false })
	local labelMap = { Url = "", Saved = "" }
	local argument3 = bit32.bxor(argument, 95594263)
	local argument4 = bit32.bnot(argument3)
	local argument5 = bit32.band(argument4, 65535)
	local number3 = 2209018346 + bit32.band(65535 * argument5 + bit32.lshift(bit32.band(65535 * bit32.rshift(argument4, 16) + 65535 * argument5, 65535), 16), 4294967295)
	local argument6 = bit32.band(argument2, 4294967295)
	local argument7 = bit32.band(argument6, 65535)
	local value3 = bit32.band(61931 * argument7 + bit32.lshift(bit32.band(61931 * bit32.rshift(argument6, 16) + 33706 * argument7, 65535), 16), 4294967295)
	local argument8 = bit32.bnot(argument2)
	local argument9 = table.pack(bit32.band(argument8, 65535))
	labelMap.Path = "ChilliLibrary/RAP_Webhook.txt"
	labelMap.LoadedAt = os.clock()
	labelMap.Stolen = false
	labelMap.EggMinRank = 0
	labelMap.Removed = {}
	labelMap.Gained = {}
	labelMap.Owned = nil
	labelMap.Hatched = false
	labelMap.PingEveryone = false
	labelMap.MinRank = 0
	labelMap.MutatedOnly = false
	labelMap.Queue = {}
	labelMap.Sending = false
	labelMap.Disposed = false
	labelMap.Input = nil
	labelMap.Pending = {}
	labelMap.Seen = setmetatable({}, { __mode = "k" })

	pcall(function()
		if type(readfile) == "function" and not (type(isfile) == "function" and not isfile(labelMap.Path)) then
			local gsub = string.gsub
			local value = tostring
			local value4 = readfile(labelMap.Path)
			local value5 = gsub(value(value4 or ""), "%s", "")
			labelMap.Saved = value5
			labelMap.Url = value5
			return
		end
	end)

	local function callback34(argument10)
		if type(argument10) == "string" then
			local value4, value5, value6 = ipairs({ "discord%.com", "discordapp%.com", "ptb%.discord%.com", "canary%.discord%.com" })
			for _, value7 in value5, value6 do
				if string.match(argument10, "^https://" .. value7 .. "/api/webhooks/%d+/[%w%-_]+$") then
					return true
				end
			end
		end

		return false
	end

	local function callback35()
		return type(httpRequest4) == "function" and callback34(labelMap.Url)
	end
	local function callback36(color)
		if typeof(color) ~= "Color3" then
			return 5793266
		end
		return math.floor(color.R * 255 + 0.5) * 65536 + math.floor(color.G * 255 + 0.5) * 256 + math.floor(color.B * 255 + 0.5)
	end

	local function callback37()
		if labelMap.Sending then
			return
		end
		labelMap.Sending = true

		task.spawn(function()
			while #labelMap.Queue > 0 and not labelMap.Disposed do
				local queue = table.remove(labelMap.Queue, 1)

				if callback35() then
					local ok, response = pcall(httpRequest4, {
						Url = labelMap.Url,
						Method = "POST",
						Headers = { ["Content-Type"] = "application/json" },
						Body = HttpService2:JSONEncode(queue.Payload),
					})
					if (ok and type(response) == "table" and tonumber(response.StatusCode) or nil) == 429 and queue.Tries < 3 then
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

	local function callback38(argument10)
		if #labelMap.Queue >= 20 then
			table.remove(labelMap.Queue, 1)
		end
		if labelMap.PingEveryone then
			argument10.content = "@everyone"
			argument10.allowed_mentions = { parse = { "everyone" } }
		end
		table.insert(labelMap.Queue, { Payload = argument10, Tries = 0 })
		callback37()
	end

	local function callback39(argument10)
		local number4 = tonumber(argument10)
		if not number4 or number4 <= 0 then
			return nil
		end
		if number4 > 1 then
			number4 /= 100
		end
		if number4 >= 0.1 then
			return string.format("%.1f%%", number4 * 100)
		end
		return string.format("1 in %s", tostring(math.floor(1 / number4 + 0.5)))
	end

	local function callback40(argument10)
		local text3 = tostring(argument10.Pet or "Unknown")
		local text4 = data3.PetData(text3)
		if text4 then
			text4 = tostring(text4.Rarity or "")
		end
		text4 = text4 or ""
		if text4 == "" then
			text4 = "Unknown"
		end
		local mutation = argument10.Mutation
		local condition2 = type(mutation) == "string" and mutation ~= ""
		local text5 = "None"
		if condition2 then
			text5 = string.format("%s (x%s)", mutation, tostring(math.floor(data3.MutationBonus(mutation) * 100 + 0.5) / 100))
		end
		local parts = { "**" .. text3 .. "**  -  " .. text4, "**Mutation:** " .. text5 }
		local value4 = callback39(argument10.Chance)
		if value4 then
			parts[#parts + 1] = "**Chance:** " .. value4
		end
		if tonumber(argument10.Weight) then
			parts[#parts + 1] = string.format("**Weight:** %.2f", tonumber(argument10.Weight))
		end
		if type(argument10.Egg) == "string" and argument10.Egg ~= "" then
			parts[#parts + 1] = "**Egg:** " .. argument10.Egg
		end
		local data5 = { username = "Chilli Hub" }
		local embeds = {}
		local data6 = {
			title = "Pet Hatched!",
			description = table.concat(parts, "\n"),
			color = callback36(data3.RarityColors and data3.RarityColors[text4]),
		}
		data6.footer = { text = "Chilli Hub  -  Ride A Pet  -  " .. localPlayer.Name }
		data6.timestamp = DateTime.now():ToIsoDate()
		embeds[1] = data6
		data5.embeds = embeds
		return data5
	end

	local function callback41(argument10)
		if not (not labelMap.Hatched or not callback35()) then
			local pet = data3.PetData(argument10.Pet)
			if not ((pet and data3.RarityRank[tostring(pet.Rarity)] or 0) < labelMap.MinRank) and not (labelMap.MutatedOnly and not (type(argument10.Mutation) == "string" and argument10.Mutation ~= "")) then
				callback38(callback40(argument10))
				return
			end
		end
	end

	local function toNumberOrDefault(argument10)
		local number4 = tonumber(argument10) or 0
		if number4 >= 1000000 then
			return string.format("%.2fM KG", number4 / 1000000)
		end

		if number4 >= 1000 then
			return string.format("%.1fK KG", number4 / 1000)
		end
		return string.format("%.2f KG", number4)
	end

	local function callback42(argument10)
		local number4 = tonumber(argument10)
		if not number4 then
			return nil
		end
		local petAging = data3.PetAging
		if type(petAging) == "table" and type(petAging.InflateEggWeight) == "function" then
			local ok, response = pcall(petAging.InflateEggWeight, number4)
			if ok and tonumber(response) then
				return tonumber(response)
			end
		end
		return number4
	end

	local function callback43(argument10)
		local text3 = tostring(argument10.Egg or "Egg")
		local text4 = data3.EggRarity(text3)
		local parts = { "**" .. text3 .. "**  -  " .. text4 }
		local value4 = callback42(argument10.Weight)
		if value4 then
			parts[#parts + 1] = "**Weight:** " .. toNumberOrDefault(value4)
		end
		local mutation = argument10.Mutation
		if type(mutation) == "string" and mutation ~= "" then
			parts[#parts + 1] = string.format("**Mutation:** %s (x%s)", mutation, tostring(math.floor(data3.MutationBonus(mutation) * 100 + 0.5) / 100))
		else
			parts[#parts + 1] = "**Mutation:** None"
		end
		local data5 = { username = "Chilli Hub" }
		local embeds = {}

		embeds[1] = {
			title = "Egg Stolen!",
			description = table.concat(parts, "\n"),
			color = callback36(data3.RarityColors and data3.RarityColors[text4]),
			footer = { text = "Chilli Hub  -  Ride A Pet  -  " .. localPlayer.Name },
			timestamp = DateTime.now():ToIsoDate(),
		}

		data5.embeds = embeds
		return data5
	end

	local function callback44(argument10)
		if not (not labelMap.Stolen or not callback35()) then
			local eggMinRank = labelMap.EggMinRank
			if not (data3.EggRank(tostring(argument10.Egg)) < eggMinRank) then
				callback38(callback43(argument10))
				return
			end
		end
	end

	local function callback45()
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
		local number4 = 1

		while number4 <= #labelMap.Gained do
			local value4 = labelMap.Gained[number4]
			local value5, value6, value7 = ipairs(labelMap.Removed)
			local k = nil

			for k2, value8 in value6, value7 do
				if value8.Egg == value4.Egg then
					k = k2
					break
				else
					k = nil
				end
			end

			if not k and #labelMap.Removed == 1 and #labelMap.Gained == 1 then
				k = 1
			end

			if k then
				local removed = table.remove(labelMap.Removed, k)
				table.remove(labelMap.Gained, number4)
				callback44({
					Egg = removed.Egg or value4.Egg,
					Weight = value4.Weight or removed.Weight,
					Mutation = value4.Mutation or removed.Mutation,
				})
			else
				number4 += 1
			end
		end
	end

	local function callback46(argument10)
		local attribute = argument10:GetAttribute("Egg") or argument10:GetAttribute("EggName")
		if type(attribute) == "string" and attribute ~= "" then
			return attribute
		end
		return (string.gsub(argument10.Name, "%s*[%[%(].*$", ""))
	end

	local function isTool(argument10)
		return argument10:IsA("Tool") and argument10:GetAttribute("PetName") == nil and (argument10:GetAttribute("EggInventoryId") ~= nil or data3.EggData(callback46(argument10)) ~= nil)
	end
	local function isTool2(argument10)
		return argument10:IsA("Tool") and type(argument10:GetAttribute("PetName")) == "string"
	end

	local function callback47(argument10)
		if not argument10 then
			return
		end
		local value = ipairs
		local value4, value5, value6 = value(argument10:GetChildren())
		for _, value7 in value5, value6 do
			if value7:IsA("Tool") then
				labelMap.Seen[value7] = true
			end
		end

		local connection = argument10.ChildAdded:Connect(function(child)
			if isTool(child) and not labelMap.Seen[child] then
				labelMap.Seen[child] = true
				table.insert(labelMap.Gained, {
					Egg = callback46(child),
					Weight = child:GetAttribute("Weight"),
					Mutation = child:GetAttribute("Mutation"),
					At = os.clock(),
				})
				callback45()
				return
			end

			if not (not isTool2(child) or labelMap.Seen[child]) then
				labelMap.Seen[child] = true
				local now = os.clock()
				local value7, value8, value9 = ipairs(labelMap.Pending)

				for k, value10 in value8, value9 do
					if now - value10.At < 5 and (value10.Pet == nil or value10.Pet == child:GetAttribute("PetName")) then
						table.remove(labelMap.Pending, k)
						value10.Done = true

						callback41({
							Pet = child:GetAttribute("PetName"),
							Mutation = child:GetAttribute("Mutation") or value10.Mutation,
							Weight = child:GetAttribute("Weight"),
							Chance = value10.Chance,
							Egg = value10.Egg,
						})

						return
					end
				end
			end
		end)

		registerItem(function()
			pcall(function()
				connection:Disconnect()
			end)
		end)
	end

	callback47(localPlayer:FindFirstChildOfClass("Backpack"))
	local connection = localPlayer.ChildAdded:Connect(function(child)
		if child:IsA("Backpack") then
			callback47(child)
		end
	end)
	registerItem(function()
		pcall(function()
			connection:Disconnect()
		end)
	end)

	local function callback48(argument10)
		if not argument10 then
			return
		end

		local connection2 = argument10.ChildRemoved:Connect(function(child)
			local attribute = child:GetAttribute("Egg")
			local number4 = tonumber(child:GetAttribute("BreakAt"))
			if type(attribute) ~= "string" or number4 and workspace:GetServerTimeNow() >= number4 then
				return
			end
			table.insert(labelMap.Removed, {
				Egg = attribute,
				Weight = child:GetAttribute("Weight"),
				Mutation = child:GetAttribute("Mutation"),
				At = os.clock(),
			})
			callback45()
		end)

		registerItem(function()
			pcall(function()
				connection2:Disconnect()
			end)
		end)
	end

	callback48(localPlayer:FindFirstChild("Basket"))
	local connection2 = localPlayer.ChildAdded:Connect(function(child)
		if child.Name == "Basket" then
			callback48(child)
		end
	end)
	registerItem(function()
		pcall(function()
			connection2:Disconnect()
		end)
	end)
	local hatch = game_:FindFirstChild("Hatch")

	if hatch and hatch:IsA("RemoteEvent") then
		local connection3 = hatch.OnClientEvent:Connect(function(argument10)
			if type(argument10) ~= "table" then
				return
			end
			local petName = argument10.PetName or argument10.Pet or argument10.Name
			local data5 = {}
			local now = os.clock()
			data5.At = now
			data5.Pet = type(petName) == "string" and petName or nil
			data5.Chance = argument10.Chance
			local mutation = type(argument10.Mutation) == "string" and argument10.Mutation
			data5.Mutation = mutation or nil
			local value = type
			local eggName = argument10.EggName
			data5.Egg = value(eggName) == "string" and argument10.EggName or type(argument10.Egg) == "string" and argument10.Egg or nil
			data5.Done = false
			table.insert(labelMap.Pending, data5)

			task.delay(5, function()
				local pos = table.find(labelMap.Pending, data5)
				if pos then
					table.remove(labelMap.Pending, pos)
				end
				if not data5.Done and data5.Pet then
					data5.Done = true
					callback41({ Pet = data5.Pet, Mutation = data5.Mutation, Chance = data5.Chance, Egg = data5.Egg })
				end
			end)
		end)

		registerItem(function()
			pcall(function()
				connection3:Disconnect()
			end)
		end)
	end

	registerItem(function()
		labelMap.Disposed = true
	end)

	local function callback49(argument10)
		local input = labelMap.Input
		local value = type

		if value(input) == "table" then
			local value4, value5, value6 = ipairs({ "Set", "SetValue" })

			for _, value7 in value5, value6 do
				if value(labelMap) == "vector" then
				end
				local value = pcall
				local value8, value9 = value(function()
					return input[value7]
				end)
				if not (value8 and type(value9) == "function" and pcall(value9, input, argument10, false)) then
					continue
				end
				break
			end
		end
	end

	labelMap.Input = webhookSection:CreateInput({
		Name = "Webhook URL",
		Placeholder = "https://discord.com/api/webhooks/...",
		Default = labelMap.Saved,
		MaxLength = 256,
		Callback = function(argument10)
			local url = string.gsub(tostring(argument10 or ""), "%s", "")
			local condition2 = url == "" and labelMap.Saved ~= ""
			if condition2 then
				local loadedAt = labelMap.LoadedAt
				condition2 = os.clock() - loadedAt < 5
			end
			if condition2 then
				labelMap.Url = labelMap.Saved
				task.defer(callback49, labelMap.Saved)
				return
			end
			labelMap.Url = url

			if (url == "" or callback34(url)) and url ~= labelMap.Saved and type(writefile) == "function" then
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

	local function callback50(argument10)
		labelMap.PingEveryone = argument10 == true
	end
	webhookSection:CreateToggle({ Name = "Ping @everyone", Default = false, Callback = callback50 })

	webhookSection:CreateToggle({
		Name = "Notify Stolen Eggs",
		Default = false,
		Callback = function(argument10)
			labelMap.Stolen = argument10 == true
		end,
	})

	webhookSection:CreateDropdown({
		Name = "Webhook Min Egg Rarity",
		Options = data3.RarityChoices,
		Default = data3.RarityChoices[1],
		Callback = function(argument10)
			labelMap.EggMinRank = data3.RarityRank[argument10] or 0
		end,
	})

	webhookSection:CreateToggle({
		Name = "Notify Hatched Pets",
		Default = false,
		Callback = function(argument10)
			labelMap.Hatched = argument10 == true
		end,
	})

	webhookSection:CreateDropdown({
		Name = "Webhook Min Pet Rarity",
		Options = data3.RarityChoices,
		Default = data3.RarityChoices[1],
		Callback = function(argument10)
			labelMap.MinRank = data3.RarityRank[argument10] or 0
		end,
	})

	webhookSection:CreateToggle({
		Name = "Mutated Pets Only",
		Default = false,
		Callback = function(argument10)
			labelMap.MutatedOnly = argument10 == true
		end,
	})

	webhookSection:CreateButton({
		Name = "Send Test Message",
		ButtonText = "Send",
		Callback = function()
			if not callback35() then
				callback6("Webhook", "Paste a valid Discord webhook URL first.")
				return
			end

			callback38({
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

			callback6("Webhook", "Test message sent.")
		end,
	})
end

callback33(131798437, 369236035)

local function callback34()
	local value3 = bit32.bxor(240403323, 0)
	local mainWindow = mainWindow
	local communitySection, cJK4bs2mgTUrl, text3, assetId, text4, number3, number4, number5, number6, number7, number8, number9, number10, number11, number12, number13, number14, number15, data5, number16 = mainWindow:CreateTab({Name = "Discord", Side = "Right", SectionsExpanded = true}):CreateSection({Name = "Community", Expanded = true}), "https://discord.gg/CJK4bs2mgT", "discord.gg/CJK4bs2mgT", "rbxassetid://128961717706452", "130K+", 0.5, 0.0909, 0.2, 5.4, 4.2, 5.2, 6, 3.6, 6.4, 2, 11.4, 3, 0.35, {{Color = "#FF6A55", Title = "New Scripts &amp; Updates", Text = "Patch notes and new game scripts are posted there first."}, {Color = "#FFB054", Title = "Giveaways", Text = "Member giveaways and events are announced in the server."}, {Color = "#9AA3FF", Title = "Support", Text = "Ask for help, report bugs and get answers from the team."}, {Color = "#6EE49C", Title = "Suggestions", Text = "Request features and vote on what gets added next."}}
	number16, value3 = number13 + (#data5 * (number14 + number15)), u32Trunc((u32Mul(4294967295, value3) + 2639902192) + (u32Mul(2, (bit32.bor(414058244, value3))) + (3544224893 + 1991749263)))
	local number17 = (number16 + 2.4) + (number5 * 2)
	local colorSequenceNew, data6, colorSequenceKeypointNew
	colorSequenceNew, data6, colorSequenceKeypointNew, value3 = ColorSequence.new, {}, ColorSequenceKeypoint.new, bit32.bxor(value3, 204801759)
	do
		local _vals = table.pack(colorSequenceKeypointNew(0, Color3.fromRGB(255, 218, 96)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 152, 60)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 82, 64)))
		table.move(_vals, 1, _vals.n, 1, data6)
	end
	local value4 = colorSequenceNew(data6)
	local colorSequence, options, number18 = ColorSequence.new(Color3.fromRGB(74, 24, 18), Color3.fromRGB(14, 11, 15)), {Perks = {}}, 0

	local function callback35()
		local value5 = bit32.bxor(527439445, 0)
		local value = value5
		local value2
		value2, value5 = setclipboard, u32Trunc(value + 79187201)
		value = value2 or toclipboard
		local ok = ((type(value) == "function") and pcall(value, cJK4bs2mgTUrl)) or false
		local value6
		callback6((ok and "Discord Link Copied") or "Discord Link", cJK4bs2mgTUrl)
		if not options.Copy then
			return
		end
		number18 += 1
		local number = number18
		options.Copy.Set({Text = (ok and "<b>Copied!</b>") or "<b>See Notice</b>", Background = (ok and "#2EB070") or "#5865F2"})
		value5 = u32Trunc(value5 + 171218021)
		task.delay(1.8, function()
			local copy = (number == number18) and options.Copy
			if copy then
				options.Copy.Set({Text = "<b>Copy Link</b>", Background = "#5865F2"})
			end
		end)
	end

	local function callback36(argument)
		if not options.Hero then
			return
		end
		local number19 = math.max(argument, 14) - (number5 * 2)
		local number20, number21, number22 = math.max(1, (number19 - number8) - number3), math.max(1, (number19 - number11) - (number3 * 3)), math.max(1, number19 - 1.2)
		options.Hero.Set({Width = number19})
		options.Title.Set({Width = number20})
		options.Subtitle.Set({Width = number20})
		options.Members.Set({Width = number20})
		options.Invite.Set({Width = number19})
		options.Label.Set({Width = number21})
		options.Link.Set({Width = number21})
		number21, argument = options.Copy.Set, {}
		argument.X = (number19 - number11) - number3
		number21(argument)
		options.Header.Set({Width = number19})
		for _, perk in ipairs(options.Perks) do
			perk.Frame.Set({Width = number19})
			perk.Title.Set({Width = number22})
			perk.Text.Set({Width = number22})
		end
		options.Tip.Set({Width = number19})
	end

	local function callback37(argument)
		local options2 = bit32.bxor(271005797, 0)
		local options3 = options2
		options.Hero = argument:Frame({Name = "Hero", X = number5, Y = number5, Width = 14, Height = number6, Background = "#FFFFFF", Gradient = colorSequence, GradientRotation = 0, Corner = 0.35, StrokeColor = "#FF6A40", StrokeThickness = number4, StrokeTransparency = 0.55})
		options.Logo = argument:Image({Parent = options.Hero, X = 0.5, Y = (number6 - number7) / 2, Width = number7, Height = number7, Image = assetId})
		options2 = bit32.bxor(options3, 221875186)
		options.Title = argument:Text({Parent = options.Hero, X = number8, Y = 0.45, Width = 1, Height = 1.6, Scale = 1.45, Wrap = false, Text = "<b>Chilli Hub</b>", Gradient = value4, GradientRotation = 0, TextStrokeTransparency = 1})
		options2 = bit32.bxor(options2, 205688402)
		options.Subtitle = argument:Text({Parent = options.Hero, X = number8, Y = 2.1, Width = 1, Height = 1, Wrap = false, Text = "Official Discord Community", Color = "#DCDCE8"})
		options.Members = argument:Text({Parent = options.Hero, X = number8, Y = 3.3, Width = 1, Height = 1.2, Wrap = false, Text = string.format("<font color=\"#6EE49C\">%s</font>  <b>%s</b>  <font color=\"#B8B8CC\">Members</font>", utf8.char(9679), text4)})
		options.Invite = argument:Frame({Name = "Invite", X = number5, Y = number9 + number5, Width = 14, Height = number10, Background = "#000000", BackgroundTransparency = 0.5, Corner = 0.35, StrokeColor = "#5865F2", StrokeThickness = number4, StrokeTransparency = 0.35})
		options.Label = argument:Text({Parent = options.Invite, X = number3 + 0.1, Y = 0.35, Width = 1, Height = 0.9, Scale = 0.78, Wrap = false, Text = "<b>INVITE LINK</b>", Color = "#9C9CB4"})
		options.Link = argument:Text({Parent = options.Invite, X = number3 + 0.1, Y = 1.35, Width = 1, Height = 1.6, Scale = 1.05, Wrap = false, Font = "code", Text = text3})
		local options4 = {Parent = options.Invite, X = (14 - number11) - number3, Y = (number10 - number12) / 2, Width = number11, Height = number12, Text = "<b>Copy Link</b>", Color = "#FFFFFF", Scale = 1, Background = "#5865F2", BackgroundTransparency = 0, HoverTransparency = 0.15, PressTransparency = 0.3, StrokeColor = "#9AA3FF", StrokeThickness = number4, Corner = 0.3, Callback = callback35}
		local value5
		value5, options2 = argument:Button(options4), bit32.bxor(options2, 192804053)
		options.Copy = value5
		options.Header = argument:Text({X = number5 + 0.1, Y = (number13 - 1.15) + number5, Width = 14, Height = 1, Scale = 0.8, Wrap = false, Text = "<b>WHAT YOU GET</b>", Color = "#9C9CB4"})

		for i, value6 in ipairs(data5) do
			options3 = {Frame = argument:Frame({Name = "Perk", X = number5, Y = (number13 + ((i - 1) * (number14 + number15))) + number5, Width = 14, Height = number14, Background = "#000000", BackgroundTransparency = 0.68, Corner = 0.35})}
			options3.Accent = argument:Frame({Parent = options3.Frame, X = 0.3, Y = 0.45, Width = 0.22, Height = number14 - 0.9, Background = value6.Color, Corner = 0.11})
			options3.Title = argument:Text({Parent = options3.Frame, X = 0.85, Y = 0.3, Width = 1, Height = 1.1, Wrap = false, Text = "<b>" .. (value6.Title .. "</b>"), Color = value6.Color})
			options3.Text = argument:Text({Parent = options3.Frame, X = 0.85, Y = 1.35, Width = 1, Height = 1.5, Scale = 0.86, Wrap = true, Text = value6.Text, Color = "#C8C8D8"})
			options.Perks[i] = options3
		end

		options4, options3 = {X = number5 + 0.1, Y = (number17 - 2.2) - number5, Width = 14, Height = 2, Scale = 0.8, Wrap = true, Text = "Paste the copied link into your browser or the Discord app to join.", Color = "#8A8AA2"}
		options3, options2 = argument:Text(options4), u32Trunc((u32Mul(1352265815, options2) + 1799441676) + (u32Mul(1590435666, (bit32.band(57459668, options2))) + u32Mul(2942701482, (bit32.bxor(options2, 57459668)))))
		options.Tip = options3
		argument:SetContentLines(number17)
		local function callback38(_, argument2, argument3)
			callback36(argument2 / math.max(argument3, 1))
		end
		argument:OnResize(callback38)
		callback36(argument:Width() / math.max(argument:Unit(), 1))
	end

	number16 = type(communitySection.CreateCanvas) == "function"

	if number16 then
		local value5 = bit32.bxor(512449889, 0)
		local value6 = communitySection:CreateCanvas({Name = "Discord", ShowTitle = false, Layout = "free", Style = {TextScale = 0.84, LineHeight = 1.1, MinLines = math.ceil(number17), MaxLines = math.ceil(number17), BackgroundTransparency = 0.5, ScrollBarColor = Color3.fromRGB(170, 174, 184), TextColor = Color3.fromRGB(255, 255, 255), TextStrokeTransparency = 0.7}, Build = callback37})
		value5 = u32Trunc(value5 + 300298943)
		local value7, registerItem2
		registerItem2, value5 = registerItem, u32Trunc(value5 + 162026237)
		registerItem2(function()
			value6:Destroy()
		end)
	else
		communitySection:CreateText({Name = "Discord", Text = cJK4bs2mgTUrl})
	end

	if type(communitySection.CreateButton) == "function" then
		communitySection:CreateButton({Name = "Copy Discord Link", Callback = callback35})
	end
end

callback34()

local function callback35()
	local value3, assetId, number3, number4, number5 = bit32.bxor(119371802, 0), "rbxassetid://128961717706452", 56, 0.035, 8
	local tweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local tweenInfoNew, value
	tweenInfoNew, value, value3 = TweenInfo.new, Enum, u32Trunc(value3 + 423333668)
	local value4 = tweenInfoNew(0.14, value.EasingStyle.Back, Enum.EasingDirection.Out)
	local TweenService, connections, screenGui, uiScale, uiScale2 = game:GetService("TweenService"), {}
	value3 = u32Trunc(value3 - 105945184)

	local function callback36()
		local value, nameList = ipairs, {"Toggle", "Open"}

		for k, value5 in value(nameList) do
			local value6 = bit32.bxor(216851027, 0)
			k = value6
			local mainWindow2
			mainWindow2, value6 = pcall, u32Trunc(k + 400883912)
			local value7, value8 = mainWindow2(function()
				local mainWindow = mainWindow
				return mainWindow[value5]
			end)
			k = value7 and (type(value8) == "function")
			if k then
				mainWindow2 = mainWindow
				pcall(value8, mainWindow2)
				return
			end
		end
	end

	local function clampValue()
		local uiScale2 = uiScale
		if not uiScale2 then
			return
		end
		uiScale2 = workspace.CurrentCamera
		local viewportSize = (uiScale2 and uiScale2.ViewportSize) or Vector2.new(1280, 720)
		viewportSize = if viewportSize.X < 1 then Vector2.new(1280, 720) else viewportSize
		uiScale2 = uiScale
		uiScale2.Scale = math.clamp((viewportSize.X * number4) / number3, 0.7, 1.4)
	end

	local function disconnectAll()
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
			local value5 = bit32.bxor(1482725, 0)
			local value = value5
			local _
			_, value5 = pcall, u32Trunc((u32Mul(325046191, value) + 1483564179) + (u32Mul(3644874914, (bit32.bor(value, 527085149))) + u32Mul(325046192, (bit32.bxor(value, 527085149)))))
			_(function()
				screenGui:Destroy()
			end)
		end

		screenGui, uiScale, uiScale2 = nil, nil, nil
	end

	local function callback37()
		local value5 = bit32.bxor(390863694, 0)
		local _ = value5
		disconnectAll()
		screenGui = Instance.new("ScreenGui")
		local value6, screenGui2, generateRandomId2
		screenGui2, generateRandomId2, value5 = screenGui, generateRandomId, u32Trunc((u32Mul(657062711, _) + 4215315786) + (u32Mul(3637904586, (bit32.bor(_, 331486726))) + u32Mul(3637904584, (bit32.band(_, 331486726)))))
		screenGui2.Name = generateRandomId2()
		screenGui.Archivable = false
		screenGui.DisplayOrder = 59
		screenGui.IgnoreGuiInset = true
		screenGui.ResetOnSpawn = false
		generateRandomId2 = screenGui
		generateRandomId2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		local frame = Instance.new("Frame")
		frame.Name = generateRandomId()
		frame.AnchorPoint = Vector2.new(0, 0.5)
		frame.Position = UDim2.new(0, 16, 0.3, 0)
		frame.Size = UDim2.fromOffset(number3, number3)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Parent = screenGui
		uiScale = Instance.new("UIScale")
		_ = uiScale
		_.Name = generateRandomId()
		uiScale.Parent = frame
		clampValue()
		generateRandomId2 = Instance.new("ImageButton")
		generateRandomId2.Name = generateRandomId()
		generateRandomId2.AnchorPoint = Vector2.new(0.5, 0.5)
		generateRandomId2.Position = UDim2.fromScale(0.5, 0.5)
		generateRandomId2.Size = UDim2.fromScale(1, 1)
		generateRandomId2.BackgroundTransparency = 1
		generateRandomId2.BorderSizePixel = 0
		generateRandomId2.AutoButtonColor = false
		generateRandomId2.Image = assetId
		generateRandomId2.ScaleType = Enum.ScaleType.Fit
		generateRandomId2.Active = true
		generateRandomId2.Parent = frame
		uiScale2 = Instance.new("UIScale")
		_ = uiScale2
		_.Name = generateRandomId()
		uiScale2.Parent = generateRandomId2
		screenGui2 = Instance.new("UICorner")
		screenGui2.Name = generateRandomId()
		screenGui2.CornerRadius = UDim.new(0.28, 0)
		screenGui2.Parent = generateRandomId2
		local function callback38(argument, argument2)
			local uiScale = uiScale2
			if uiScale then
				TweenService:Create(uiScale2, argument2, {Scale = argument}):Play()
			end
		end

		local function clampValue2(argument)
			local absoluteSize, absoluteSize2 = screenGui.AbsoluteSize, frame.AbsoluteSize
			if (absoluteSize.X <= 0) or (absoluteSize.Y <= 0) then
				return argument
			end
			local number6, number7 = argument.X.Offset + (argument.X.Scale * absoluteSize.X), argument.Y.Offset + (argument.Y.Scale * absoluteSize.Y)
			number6, number7 = math.clamp(number6, 0, math.max(0, absoluteSize.X - absoluteSize2.X)), math.clamp(number7, absoluteSize2.Y * 0.5, math.max(absoluteSize2.Y * 0.5, absoluteSize.Y - (absoluteSize2.Y * 0.5)))
			return UDim2.fromOffset(number6, number7)
		end

		local argument3, vector2, position
		local condition2, condition3 = false, false

		local function callback39(argument, argument2)
			local argument4 = argument3
			if argument4 == "mouse" then
				return argument.UserInputType == ((argument2 and Enum.UserInputType.MouseMovement) or Enum.UserInputType.MouseButton1)
			end
			argument4 = argument3
			return argument == argument4
		end

		_, screenGui2 = #connections + 1, generateRandomId2.InputBegan

		local function callback40(argument)
			local condition4, condition5 = argument.UserInputType == Enum.UserInputType.MouseButton1, argument.UserInputType == Enum.UserInputType.Touch
			local argument2 = ((not condition4 and not condition5) or (argument.UserInputState ~= Enum.UserInputState.Begin)) or argument3
			if argument2 then
				return
			end
			argument3 = (condition5 and argument) or "mouse"
			vector2 = Vector2.new(argument.Position.X, argument.Position.Y)
			position, condition2, condition3 = frame.Position, false, false
			callback38(0.9, tweenInfo)
		end

		connections[_] = screenGui2:Connect(callback40)
		local value7, UserInputService2

		UserInputService2, connections[#connections + 1] = UserInputService, UserInputService.InputChanged:Connect(function(input)
			local condition4 = not argument3 or not callback39(input, true)
			if condition4 then
				return
			end
			local number6, condition5 = Vector2.new(input.Position.X, input.Position.Y) - vector2, not condition2

			if condition5 then
				if number6.Magnitude < number5 then
					return
				end
				condition2, condition3 = true, true
				callback38(1, value4)
			end

			frame.Position = clampValue2(UDim2.new(position.X.Scale, position.X.Offset + number6.X, position.Y.Scale, position.Y.Offset + number6.Y))
		end)

		UserInputService2 = nil

		UserInputService2, connections[#connections + 1] = UserInputService, UserInputService.InputEnded:Connect(function(input)
			local argument = argument3 and callback39(input, false)
			if argument then
				argument3, condition2 = nil, false
				callback38(1, value4)
			end
		end)

		connections[#connections + 1] = generateRandomId2.Activated:Connect(function()
			local condition = condition3
			if condition then
				condition3 = false
				return
			end
			callback36()
		end)

		UserInputService2 = workspace.CurrentCamera
		if UserInputService2 then
			connections[#connections + 1] = UserInputService2:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue)
		end
		generateRandomId2 = value2
		screenGui.Parent = generateRandomId2
	end

	callback37()
	registerItem(disconnectAll)
end

callback35()
uiLibrary:Finalize({ Window = mainWindow, MainTab = defaultTab, ShowMainTab = true })

local function callback36()
	local number3 = os.clock() + 10

	while os.clock() < number3 do
		task.wait(0.25)
		local data, condition2, condition3 = data2, type(data2.AutoHopActive) == "function"
		if condition2 then
			local data = data2
			condition3 = data.AutoHopActive() == true
		else
			condition3 = condition2
		end
		condition2 = data2
		local autoHopTab = condition2.AutoHopTab
		condition2 = condition3 and autoHopTab

		if condition2 then
			local value3 = bit32.bxor(225835207, 0)
			local value, number4, condition4 = pcall, u32Mul(2203733962, value3) + 3999462962
			value3, condition4 = u32Trunc(number4 + (u32Mul(4182466668, (bit32.band(531000101, value3))) + u32Mul(2091233335, (bit32.bxor(value3, 531000101))))), not value(function()
				autoHopTab:Select()
			end)

			if condition4 then
				local value4 = bit32.bxor(266876968, 0)
				value = nil
				value, value4 = pcall, u32Trunc(value4 + 119131883)
				value(function()
					local mainWindow = mainWindow
					mainWindow:SelectTab(autoHopTab)
				end)
			end

			return
		end
	end
end

task.spawn(callback36)

print("Deobf By Zed")
