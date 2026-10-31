local number, TweenService, UserInputService, RunService, MarketplaceService, HttpService, httpRequest, localPlayer, hui, home
local vrzg9YaNPjUrl, data, data2, number2, number3, data3

do
	local number4 = 1494280530
	number = 93860970
	local Players = game:GetService("Players")
	TweenService = game:GetService("TweenService")
	UserInputService = game:GetService("UserInputService")
	RunService = game:GetService("RunService")
	MarketplaceService = game:GetService("MarketplaceService")
	HttpService = game:GetService("HttpService")
	local httpRequest2

	if syn then
		httpRequest2 = syn.request

		if httpRequest2 then
			httpRequest = httpRequest2
		elseif http then
			httpRequest2 = http.request

			if httpRequest2 then
				httpRequest = httpRequest2
			else
				httpRequest2 = http_request
				httpRequest = httpRequest2 or request
			end
		else
			httpRequest2 = http_request
			httpRequest = httpRequest2 or request
		end
	elseif http then
		httpRequest2 = http.request

		if httpRequest2 then
			httpRequest = httpRequest2
		else
			httpRequest2 = http_request
			httpRequest = httpRequest2 or request
		end
	else
		httpRequest2 = http_request
		httpRequest = httpRequest2 or request
	end

	local gameRef = game

	if not gameRef:IsLoaded() then
		game.Loaded:Wait()
	end

	while not Players.LocalPlayer do
		Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
	end

	localPlayer = Players.LocalPlayer
	hui = nil

	pcall(function()
		if typeof(gethui) ~= "function" then
			return
		end
		hui = gethui()
	end)

	local number5 = number4 - 2783575027

	if not hui then
		pcall(function()
			local CoreGui = game:GetService("CoreGui")
			if CoreGui and typeof(cloneref) == "function" then
				hui = cloneref(CoreGui)
				return
			end
			hui = CoreGui
		end)
	end

	if not hui then
		hui = localPlayer:WaitForChild("PlayerGui")
		number = number + number5 + 1289294497
	end

	home = "Free Script Loader"
	vrzg9YaNPjUrl = "https://discord.gg/vrzg9YaNPj"
	data = { items = { "Violent District", "Break and Steal", "Anime Dice" } }
	data2 = {}
	local number6 = number + 95095349
	local number7 = number5 // number6 - 3670288205 + number6
	local number8 = number6 + number7 + number7
	local number9 = (number7 + 1217751808) // number8
	number2 = number8 + number9 + number9
	number3 = number9 - number2
	data3 = {}
end

local number4 = bit32.band(number2, 4294967295)
local value = bit32.band(t1926_545_1[1], 65535)
local value2 = bit32.rshift(t1926_545_1[1], 16)
local number5 = bit32.band(number4, 65535)
local value3 = bit32.band(value * number5 + bit32.lshift(bit32.band(value * bit32.rshift(number4, 16) + value2 * number5, 65535), 16), 4294967295)
data3.name = "Evomon Gold V4"
data3.desc = "Auto hunt / evolve / VIP farm"
data3.icon = "rbxassetid://112510549708715"
data3.match = { "evomon" }
data3.url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/evg.lua"
data3.premiumOnly = true

data2[1] = {
	name = "Violent District",
	desc = "Survivor / Killer / ESP / OP",
	icon = "rbxthumb://type=GameIcon&id=6739698191&w=150&h=150",
	match = { "violent district", "violence district" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/vd.lua",
}

data2[2] = {
	name = "Break and Steal",
	desc = "Auto steal / farm / defense",
	icon = "rbxthumb://type=GameIcon&id=10765288803&w=150&h=150",
	match = { "break and steal", "break steal", "break & steal" },
	url = "https://api.luarmor.net/files/v4/loaders/1c42f17db76929706a530cdc272ffea3.lua",
}

data2[3] = {
	name = "Anime Dice",
	desc = "Auto roll / farm / luck",
	icon = "rbxthumb://type=GameIcon&id=10708913337&w=150&h=150",
	match = { "anime dice" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/ad.lua",
}

data2[4] = {
	name = "Ride A Pet",
	desc = "Auto farm / egg / ride",
	icon = "rbxthumb://type=GameIcon&id=10035204815&w=150&h=150",
	match = { "ride a pet", "ride pet" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/main/rap.lua",
}

data2[5] = {
	name = "Capybara VS Plant",
	desc = "Auto farm",
	icon = "rbxassetid://105645768765428",
	match = { "capybara", "capybara vs plant" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/cvp.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

data2[6] = {
	name = "Steal an Egg",
	desc = "Auto steal / farm",
	icon = "rbxassetid://71490087912254",
	match = { "steal an egg", "steal egg" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/sae3.lua",
}

data2[7] = {
	name = "Grow a Chicken Fighter",
	desc = "Auto farm / fight",
	icon = "rbxassetid://94197048748373",
	match = { "grow a chicken", "chicken fighter" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/gacf.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

data2[8] = {
	name = "Anime Expedition",
	desc = "Auto match / farm",
	icon = "rbxassetid://131974959514318",
	match = { "anime expedition", "expedition" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/ae.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

data2[9] = {
	name = "Iron Souls",
	desc = "Auto farm / forge / upgrade",
	icon = "rbxassetid://114063353587790",
	match = { "iron souls", "iron soul" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/is.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

data2[10] = {
	name = "Anime Card Farm",
	desc = "Auto farm / cards",
	icon = "rbxassetid://115169947896689",
	match = { "anime card" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/acf.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

data2[11] = {
	name = "Roblox Anti AFK",
	desc = "Blocks idle kick / any game",
	icon = "rbxassetid://118103427371929",
	match = {},
	url = "https://api.jnkie.com/api/v1/luascripts/public/cd8dd27757251102a6298aa2c848b792c81ec29f9b0160711ffa8340b1844646/download",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

data2[12] = {
	name = "Grow A Garden 2",
	desc = "Auto farm / shop / sell",
	icon = "rbxassetid://103507136591905",
	match = { "grow a garden", "garden" },
	url = "https://raw.githubusercontent.com/JualNasiRendang/gag2/refs/heads/main/gag2.lua",
}

data2[13] = {
	name = "Tap Heroes: Pet Simulator 99",
	desc = "Auto tap / farm",
	icon = "rbxassetid://95633120003456",
	match = { "pet simulator", "tap heroes" },
	url = "https://raw.githubusercontent.com/JualNasiRendang/tap-heroes-pet-99/refs/heads/main/tapheroes.lua",
}

data2[14] = {
	name = "Haze Seas",
	desc = "Auto punch / farm",
	icon = "rbxassetid://95336994655521",
	match = { "haze seas", "haze" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/hs.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

data2[15] = {
	name = "Build an Anthill",
	desc = "Auto food / collect / sell sugar",
	icon = "rbxassetid://74203696854385",
	match = { "build an anthill", "anthill" },
	url = "https://api.jnkie.com/api/v1/luascripts/public/1b46521ec79efab9d23666289c56d04e6186ca0fd908930cf60ee5e3ec4c4d71/download",
	genv = {
		SCRIPT_KEY = "KEYLESS",
		WEBHOOK = "https://discord.com/api/webhooks/1531130263839572010/-DMrRXLqCovt3DAxh9QQ4IRjxDDwtgEy_nVH_aZafnrzAludWdUSf1jxhAde6zdO0ANB",
	},
}

data2[16] = {
	name = "Build a Ring Farm",
	desc = "Auto farm",
	icon = "rbxassetid://131809011640166",
	match = { "build a ring", "ring farm" },
	url = "https://raw.githubusercontent.com/JualNasiRendang/nasirendang-barf/refs/heads/main/nasirendang-barf.lua",
}

data2[17] = {
	name = "Evomon",
	desc = "Auto hunt / evolve",
	icon = "rbxassetid://112510549708715",
	match = { "evomon" },
	url = "https://raw.githubusercontent.com/JualNasiRendang/nasirendang-evomon/refs/heads/main/nasirendang-evomon.lua",
}

data2[18] = data3
local callback

callback = function(argument)
	local value4, value5, value6 = ipairs(data2)

	for _, value7 in value5, value6 do
		if value7.name ~= argument then
			continue
		end
		return value7
	end

	return nil
end

local queueOnTeleport
local queueOnTeleport2

if syn then
	queueOnTeleport2 = syn.queue_on_teleport

	if queueOnTeleport2 then
		queueOnTeleport = queueOnTeleport2
	else
		queueOnTeleport2 = queue_on_teleport

		if queueOnTeleport2 then
			queueOnTeleport = queueOnTeleport2
		elseif fluxus then
			queueOnTeleport2 = fluxus.queue_on_teleport
			queueOnTeleport = queueOnTeleport2 or queueonteleport
		else
			queueOnTeleport = queueonteleport
		end
	end
else
	queueOnTeleport2 = queue_on_teleport

	if queueOnTeleport2 then
		queueOnTeleport = queueOnTeleport2
	elseif fluxus then
		queueOnTeleport2 = fluxus.queue_on_teleport
		queueOnTeleport = queueOnTeleport2 or queueonteleport
	else
		queueOnTeleport = queueonteleport
	end
end

local readJsonFile, saveFile

do
	local number6 = 86400

	readJsonFile = function()
		local ok, response = pcall(readfile, "nr_loader_autoexec.json")

		if ok and type(response) == "string" and response ~= "" then
			local ok2, response2 = pcall(function()
				return HttpService:JSONDecode(response)
			end)

			if ok2 and type(response2) == "table" and response2.gameName and response2.expiresAt then
				if not (response2.expiresAt <= os.time()) then
					return response2
				end
				pcall(delfile, "nr_loader_autoexec.json")
				return nil
			end
		end

		return nil
	end

	saveFile = function(argument)
		if argument then
			pcall(writefile, "nr_loader_autoexec.json", HttpService:JSONEncode({ gameName = argument, enabledAt = os.time(), expiresAt = os.time() + number6, durationHours = 24 }))
			pcall(writefile, "autoexec/nr_loader.lua", "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua\"))()")
			pcall(writefile, "autoexecute/nr_loader.lua", "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua\"))()")
			if queueOnTeleport then
				pcall(queueOnTeleport, "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua\"))()")
				return
			end
			return
		end

		pcall(delfile, "nr_loader_autoexec.json")
		pcall(delfile, "autoexec/nr_loader.lua")
		pcall(delfile, "autoexecute/nr_loader.lua")
	end
end

local data4, backgroundTransparency, tweenInfo, number6, tweenInfo2, tweenInfo3, tweenInfo4, callback2, getUICorner, number7
local callback3, number8, ScreenGui, number9, Frame, UIScale

do
	local number10 = number2 + number3
	local number11 = bit32.rshift(number3, 23)

	data4 = {
		Window = Color3.new(0.054901961237192154, 0.062745101749897, 0.058823529630899429),
		TopBar = Color3.new(0.070588238537311554, 0.08235294371843338, 0.078431375324726105),
		Panel = Color3.new(0.043137256056070328, 0.050980392843484879, 0.047058824449777603),
		Control = Color3.new(0.094117648899555206, 0.10980392247438431, 0.10196078568696976),
		Border = Color3.new(0.14901961386203766, 0.17254902422428131, 0.16078431904315948),
		Accent = Color3.new(0.62745100259780884, 0.37254902720451355, 0.96078431606292725),
		AccentDim = Color3.new(0.22745098173618317, 0.13333334028720856, 0.36078432202339172),
		Text = Color3.new(0.89411765336990356, 0.90980392694473267, 0.89803922176361084),
		SubText = Color3.new(0.47058823704719543, 0.50196081399917603, 0.48627451062202454),
		Danger = Color3.new(0.86274510622024536, 0.35294118523597717, 0.35294118523597717),
	}

	backgroundTransparency = 0.2
	tweenInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	number6 = bit32.lshift(number11, 9)
	tweenInfo2 = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	tweenInfo3 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	tweenInfo4 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	callback2 = function(argument, argument2, argument3)
		local instance = Instance.new(argument)
		local value4, value5, value6 = pairs(argument2 or {})

		for k, value7 in value5, value6 do
			instance[k] = value7
		end

		local value7, value8, value9 = ipairs(argument3 or {})

		for _, value10 in value8, value9 do
			value10.Parent = instance
		end

		return instance
	end

	getUICorner = function(argument)
		return callback2("UICorner", { CornerRadius = UDim.new(0, argument or 8) })
	end

	number7 = 325043278

	callback3 = function(argument, thickness, transparency)
		local uiStroke = { Color = argument or data4.Border }

		if number7 + 117422833 == 132803028 then
			number7 = bit32.bxor(number7, 3545652547)
		end

		uiStroke.Thickness = thickness
		uiStroke.Transparency = transparency or 0.2
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		return callback2("UIStroke", uiStroke)
	end

	local data5 = {}
	number8 = number10 + 494365338
	local huis = { hui, localPlayer:FindFirstChildOfClass("PlayerGui") }
	local value4 = value3
	local number12 = bit32.band(number8, 4294967295)
	local value5 = bit32.band(value4, 65535)
	local value6 = bit32.rshift(value4, 16)
	local number13 = bit32.band(number12, 65535)
	local value7 = bit32.band(value5 * number13 + bit32.lshift(bit32.band(value5 * bit32.rshift(number12, 16) + value6 * number13, 65535), 16), 4294967295)

	pcall(function()
		if gethui then
			huis[#huis + 1] = gethui()
			return
		end
	end)

	pcall(function()
		huis[#huis + 1] = game:GetService("CoreGui")
	end)

	local value8, value9, value10 = ipairs(huis)

	for _, value11 in value9, value10 do
		if value11 and not data5[value11] then
			data5[value11] = true
			local value12, value13, value14 = ipairs(value11:GetChildren())

			for _, value15 in value13, value14 do
				if value15.Name == "NR_Loader" then
					pcall(function()
						value15:Destroy()
					end)
				end
			end
		end
	end

	ScreenGui = callback2("ScreenGui", {
		Name = "NR_Loader",
		Parent = hui,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 1000,
	})

	local number14 = 420
	local number15 = 330
	number7 = bit32.bxor(number7, 202264007)
	local number16 = value7 // number6
	number9 = number8 + number6

	Frame = callback2("Frame", {
		Name = "Window",
		Parent = ScreenGui,
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 420, 0, 330),
		BackgroundColor3 = data4.Window,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, { getUICorner(14), callback3(data4.Border, 1) })

	UIScale = callback2("UIScale", { Parent = Frame })

	local function clampValue()
		local currentCamera = workspace.CurrentCamera
		local viewportSize

		if currentCamera then
			viewportSize = currentCamera.ViewportSize or Vector2.new(800, 600)
		else
			viewportSize = Vector2.new(800, 600)
		end

		local number17 = math.min((viewportSize.X - 20) / number14, (viewportSize.Y - 20) / number15)

		if UserInputService.TouchEnabled then
			number17 *= 0.78
		end

		UIScale.Scale = math.clamp(number17, 0.34, 1)
	end

	clampValue()

	local function callback4()
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			pcall(function()
				currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue)
			end)

			return
		end
	end

	callback4()
	local number17 = number16 + 523800463

	local function callback5()
		if number17 + 142506498 ~= 403438049 then
			number17 = bit32.bxor(number17, 2796132829)
		end

		clampValue()
		callback4()
	end

	number17 = 260931551
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(callback5)
end

do
	local scale = UIScale.Scale
	UIScale.Scale = scale * 0.9
	Frame.BackgroundTransparency = 1
	Frame.UIStroke.Transparency = 1
	local tween = TweenService:Create(UIScale, tweenInfo3, { Scale = scale })
	tween:Play()
end

TweenService:Create(Frame, tweenInfo4, { BackgroundTransparency = 0.12 }):Play()
TweenService:Create(Frame.UIStroke, tweenInfo4, { Transparency = 0.2 }):Play()
local callback4

local Frame2 = callback2("Frame", {
	Name = "Toasts",
	Parent = ScreenGui,
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -12, 1, -12),
	Size = UDim2.new(0, 250, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
})

callback2("UIListLayout", {
	Parent = Frame2,
	Padding = UDim.new(0, 6),
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	SortOrder = Enum.SortOrder.LayoutOrder,
})

callback4 = function(argument, argument2, argument3)
	local danger

	if argument2 then
		danger = data4.Danger or data4.Accent
	else
		danger = data4.Accent
	end

	local Frame3 = callback2("Frame", {
		Parent = Frame2,
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = data4.Window,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
	}, { getUICorner(8), callback3(danger, 1) })

	callback2("Frame", {
		Parent = Frame3,
		Size = UDim2.new(0, 3, 1, -12),
		Position = UDim2.new(0, 6, 0.5, -16),
		BackgroundColor3 = danger,
		BorderSizePixel = 0,
	}, { getUICorner(2) })

	local TextLabel = callback2("TextLabel", {
		Parent = Frame3,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(1, -26, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = argument,
		TextColor3 = data4.Text,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	TweenService:Create(callback2("UIScale", { Parent = Frame3, Scale = 0.85 }), tweenInfo3, { Scale = 1 }):Play()
	local delay = task.delay
	argument3 = argument3 or 5
	local number10 = 47489607

	local function callback5()
		local Frame4 = Frame3

		if number10 + 171137026 == 305624577 then
			local number11 = number10
			if number10 ~= 490807331 then
				return
			end
			number10 = bit32.bxor(number11, 2293314731)
		end

		if Frame4.Parent then
			TweenService:Create(Frame3, tweenInfo4, { BackgroundTransparency = 1 }):Play()
			TweenService:Create(Frame3.UIStroke, tweenInfo4, { Transparency = 1 }):Play()
			TweenService:Create(TextLabel, tweenInfo4, { TextTransparency = 1 }):Play()
			task.wait(0.32)
			if Frame3.Parent then
				Frame3:Destroy()
				return
			end
			return
		end
	end

	number10 = 490807331
	delay(argument3, callback5)
end

local Frame3, TextButton, ImageLabel, TextLabel, TextLabel2, TextButton2, number10, number11, TextButton3, callback5
local value4

do
	local value5 = bit32.band(3920625664, number9)

	Frame3 = callback2("Frame", {
		Name = "TopBar",
		Parent = Frame,
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = data4.TopBar,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
	}, { getUICorner(14) })

	local number12 = number9 + value5

	callback2("Frame", {
		Parent = Frame3,
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 1, -14),
		BackgroundColor3 = data4.TopBar,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
	})

	local number13 = value5 // number12

	TextButton = callback2("TextButton", {
		Parent = Frame3,
		Name = "Back",
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(0, 12, 0.5, -13),
		BackgroundColor3 = data4.Control,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "<",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = data4.SubText,
		Visible = false,
	}, { getUICorner(8) })

	ImageLabel = callback2("ImageLabel", {
		Parent = Frame3,
		Size = UDim2.new(0, 32, 0, 32),
		Position = UDim2.new(0, 14, 0.5, -16),
		BackgroundTransparency = 1,
		Image = "rbxassetid://124947058155926",
	}, { getUICorner(8) })

	local number14 = number12 - 441651735

	TextLabel = callback2("TextLabel", {
		Parent = Frame3,
		Size = UDim2.new(1, -160, 0, 17),
		Position = UDim2.new(0, 56, 0, 10),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = "Nasi Rendang LUA",
		TextColor3 = data4.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local number15 = bit32.bor(number13, number14)

	TextLabel2 = callback2("TextLabel", {
		Parent = Frame3,
		Size = UDim2.new(1, -160, 0, 13),
		Position = UDim2.new(0, 56, 0, 27),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = home,
		TextColor3 = data4.SubText,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local number16 = number15

	TextButton2 = callback2("TextButton", {
		Parent = Frame3,
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(1, -36, 0.5, -13),
		BackgroundColor3 = data4.Control,
		BackgroundTransparency = backgroundTransparency,
		Text = "x",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = data4.SubText,
		AutoButtonColor = false,
	}, { getUICorner(8) })

	number10 = number15 - number16
	number11 = number14 + 80861551 - 68467876
	local border = data4.Border

	TextButton3 = callback2("TextButton", {
		Parent = Frame3,
		Name = "Logout",
		Size = UDim2.new(0, 58, 0, 24),
		Position = UDim2.new(1, -100, 0.5, -12),
		BackgroundColor3 = data4.Control,
		BackgroundTransparency = backgroundTransparency,
		AutoButtonColor = false,
		Text = "Logout",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = data4.SubText,
		Visible = false,
	}, { getUICorner(8), callback3(border, 1) })

	callback5 = function(argument, argument2, textColor3)
		argument.MouseEnter:Connect(function()
			local TweenService2 = TweenService
			local create = TweenService.Create
			local data5 = {}
			local argument3 = argument2

			if not argument2 then
				argument3 = data4.Text
			end

			data5.TextColor3 = argument3
			create(TweenService2, argument, tweenInfo, data5):Play()
		end)

		argument.MouseLeave:Connect(function()
			local TweenService2 = TweenService
			local create = TweenService.Create
			local data5 = {}
			data5.TextColor3 = textColor3 or data4.SubText
			create(TweenService2, argument, tweenInfo, data5):Play()
		end)
	end

	local danger = data4.Danger
	local value6 = bit32.band(number16 - number10, 4294967295)
	local value7 = bit32.band(value6, 65535)
	value4 = bit32.band(value7 * 35151 + bit32.lshift(bit32.band(value7 * 0 + bit32.rshift(value6, 16) * 35151, 65535), 16), 4294967295)
	callback5(TextButton2, danger)
end

callback5(TextButton, data4.Text)
callback5(TextButton3, data4.Danger)

do
	local condition = nil
	local position = nil
	local position2 = nil
	local input = nil
	Frame3.Active = true

	Frame3.InputBegan:Connect(function(input2)
		if input2.UserInputType ~= Enum.UserInputType.MouseButton1 and input2.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		local position3 = input2.Position
		local position4 = Frame.Position
		condition = true
		position = position3
		position2 = position4

				local connection = input2.Changed:Connect(function()
			if input2.UserInputState ~= Enum.UserInputState.End then
				return
			end
			condition = false
			r3_1:Disconnect()
		end)
	end)

	Frame3.InputChanged:Connect(function(input2)
		if input2.UserInputType ~= Enum.UserInputType.MouseMovement then
			if input2.UserInputType ~= Enum.UserInputType.Touch then
				return
			end
			input = input2
			return
		end

		input = input2
	end)

	UserInputService.InputChanged:Connect(function(input2)
		if condition and input2 == input then
			local number12 = input2.Position - position
			Frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + number12.X, position2.Y.Scale, position2.Y.Offset + number12.Y)
			return
		end
	end)
end

local Frame4, Frame5, Frame6

do
	local Frame7 = callback2("Frame", {
		Name = "Content",
		Parent = Frame,
		Position = UDim2.new(0, 0, 0, 52),
		Size = UDim2.new(1, 0, 1, -52),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	})

	Frame4 = callback2("Frame", {
		Name = "Home",
		Parent = Frame7,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
	})

	Frame5 = callback2("Frame", {
		Name = "Gold",
		Parent = Frame7,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(-1, 0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
	})

	Frame6 = callback2("Frame", {
		Name = "Games",
		Parent = Frame7,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
	})
end

local condition = false
local data5, data6, text, callback6

do
	local data7 = { gold = -1, home = 0, games = 1 }
	local data8 = { gold = Frame5, home = Frame4, games = Frame6 }
	data5 = { gold = "Gold members", home = home, games = "Choose a game" }
	data6 = { v = false }
	text = "home"

	callback6 = function(argument)
		if text ~= argument then
			if argument == "games" and not data6.v then
				return
			end

			if argument == "gold" and not condition then
				return
			end

			if data8[argument] then
				text = argument
				local value5 = data7[argument]
				local value6, value7, value8 = pairs(data8)

				for k, value9 in value7, value8 do
					value9.Visible = true
					TweenService:Create(value9, tweenInfo2, { Position = UDim2.fromScale(data7[k] - value5, 0) }):Play()
				end

				local condition2 = argument == "home"
				TextButton.Visible = not condition2
				local TweenService2 = TweenService
				local create = TweenService.Create
				local data9 = {}
				local uDim2New = UDim2.new
				local number12

				if condition2 then
					number12 = 14
				else
					number12 = 44
				end

				data9.Position = uDim2New(0, number12, 0.5, -16)
				create(TweenService2, ImageLabel, tweenInfo2, data9):Play()
				local number13

				if condition2 then
					number13 = 56
				else
					number13 = 86
				end

				TweenService:Create(TextLabel, tweenInfo2, { Position = UDim2.new(0, number13, 0, 10) }):Play()
				TweenService:Create(TextLabel2, tweenInfo2, { Position = UDim2.new(0, number13, 0, 27) }):Play()
				TextLabel2.Text = data5[argument]
				local number14 = 376740006

				local function callback7()
					local value9 = pairs

					if bit32.bxor(number14, 111691750) == 300206944 then
						number14 = bit32.bxor(number14, 3591534891)
					end

					local value10, value11, value12 = value9(data8)

					for k, value13 in value11, value12 do
						if k ~= text then
							value13.Visible = false
						end
					end
				end

				number14 = 375570629
				task.delay(0.28, callback7)
				return
			end
		end
	end
end

do
	local mouseButton1Click = TextButton.MouseButton1Click
	local mouseButton1Click2 = mouseButton1Click
	local connect = mouseButton1Click.Connect
	local number12 = 440146619

	local function callback7()
		if bit32.bxor(number12, 99430202) == 23217081 then
			number12 = bit32.bxor(number12, 1348751597)
		end

		callback6("home")
	end

	number12 = 165499731
	connect(mouseButton1Click2, callback7)
end

local UIStroke, TextLabel3, keyUrl, callback7, callback8, condition2, callback9, callback10, Frame7, TextBox
local callback11, color, TextButton4, TextButton5, TextButton6, TextButton7, configMap, Frame8, TextLabel4, number12
local callback12, TextLabel5, number13, Frame9, TextBox2, TextButton8, number14, number15

do
	local number16 = number11 + value4 + 1954270278

	UIStroke = callback2("UIStroke", {
		Parent = callback2("ImageLabel", {
			Parent = Frame4,
			Size = UDim2.new(0, 60, 0, 60),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 8),
			BackgroundTransparency = 1,
			Image = "rbxassetid://124947058155926",
		}, { getUICorner(14) }),
		Color = data4.Accent,
		Thickness = 1.5,
		Transparency = 0.55,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})

	callback2("TextLabel", {
		Parent = Frame4,
		Size = UDim2.new(1, -32, 0, 20),
		Position = UDim2.new(0, 16, 0, 72),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = "Nasi Rendang LUA Free Script",
		TextColor3 = data4.Text,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Center,
	})

	TextLabel3 = callback2("TextLabel", {
		Parent = Frame4,
		Size = UDim2.new(1, -32, 0, 14),
		Position = UDim2.new(0, 16, 0, 92),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = "Detecting game...",
		TextColor3 = data4.SubText,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	keyUrl = "https://www.nrlscript.com/key"
	local data7 = { gold = { service = "1 Months", identifier = "1133593", provider = "1 Months Service" } }

	callback7 = function(argument, argument2, argument3)
		local concat = table.concat
		local data8 = {}
		local text2 = tostring(os.time())
		local text3, value5

		if argument2 then
			if argument3 then
				text3 = tostring(argument3) or ""
			else
				text3 = ""
				data8[1] = argument
				data8[2] = text2
				data8[3] = argument2
				data8[4] = text3
				value5 = concat(data8, "|")
				pcall(writefile, "nr_loader_key.txt", value5)
				return
			end
		else
			argument2 = ""

			if argument3 then
				text3 = tostring(argument3)

				if not text3 then
					text3 = ""
					data8[1] = argument
					data8[2] = text2
					data8[3] = argument2
					data8[4] = text3
					value5 = concat(data8, "|")
					pcall(writefile, "nr_loader_key.txt", value5)
					return
				end
			else
				text3 = ""
				data8[1] = argument
				data8[2] = text2
				data8[3] = argument2
				data8[4] = text3
				value5 = concat(data8, "|")
				pcall(writefile, "nr_loader_key.txt", value5)
				return
			end
		end

		data8[1] = argument
		data8[2] = text2
		data8[3] = argument2
		data8[4] = text3
		value5 = concat(data8, "|")
		pcall(writefile, "nr_loader_key.txt", value5)
	end

	callback8 = function()
		local ok, response = pcall(readfile, "nr_loader_key.txt")

		if ok and type(response) == "string" and response ~= "" then
			local ks = {}
			local value5, value6, value7 = (response .. "|"):gmatch("([^|]*)|")

			for k in value6, value7 do
				ks[#ks + 1] = k
			end

			local text2 = (ks[1] or ""):gsub("%s+", "")

			if text2 ~= "" then
				local number17 = tonumber(ks[2])
				local value8

				if ks[3] then
					if ks[3] ~= "" then
						value8 = ks[3] or nil
					else
						value8 = nil
					end
				else
					value8 = nil
				end

				local number18 = tonumber(ks[4])
				if number17 then
					return text2, os.time() - number17, value8, number18
				end
				return text2, math.huge, value8, number18
			end

			return nil
		end

		return nil
	end

	condition2 = false

	local function callback13()
		local ok, response = pcall(function()
			return gethwid()
		end)

		if ok and type(response) == "string" and response ~= "" then
			return response
		end
		return "uid-" .. tostring(localPlayer.UserId)
	end

	local number17 = number16 + 2579646458
	local value5, value6, value7, value8, value9

	local function callback14(argument)
		if httpRequest then
			local text2 = ("%s?key=%s&hwid=%s"):format("https://www.nrlscript.com/api/verify", HttpService:UrlEncode(argument), HttpService:UrlEncode(callback13()))
			local number18 = 503905154

			local function callback15()
				local requestData = {}
				local text3 = text2

				if number18 == 302681685 then
					number18 = bit32.bxor(number18, 2632809597)
				end

				requestData.Url = text3
				requestData.Method = "GET"
				requestData.Headers = { Accept = "application/json", ["User-Agent"] = "NRL-Loader/1.0", ["Cache-Control"] = "no-cache" }
				return httpRequest(requestData)
			end

			number18 = 488185262
			local ok, response = pcall(callback15)

			if ok and type(response) == "table" then
				local value10 = tostring
				value10(response.Body or response.body or "")
				return false, "Empty response from key server (HTTP " .. tostring(response.StatusCode or response.status_code or response.Status or "?") .. ")"
			end

			return false, "Network error — check your connection"
		end

		return false, "Executor has no HTTP request support"
	end

	local value10 = nil

	local function compileChunk()
		if value10 then
			return value10
		end

		local ok, response = pcall(function()
			return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
		end)

		if ok then
			if type(response) ~= "table" then
				return nil, tostring(response)
			end
			value10 = response
			return value10
		end

		return nil, tostring(response)
	end

	local function callback15(argument, argument2)
		argument.service = argument2.service
		argument.identifier = argument2.identifier
		argument.provider = argument2.provider
	end

	local function callback16(argument)
		local value11, value12 = compileChunk()
		if not value11 then
			return false, "SDK load failed: " .. tostring(value12)
		end
		callback15(value11, data7.gold)

		local ok, response = pcall(function()
			return value11.check_key(argument)
		end)

		if ok then
			if response and response.valid then
				return true, "gold"
			end
			return false, "Invalid key"
		end

		return false, "check_key error: " .. tostring(response)
	end

	callback9 = function(argument, argument2)
		if argument then
			if argument ~= "" then
				local scriptKey = argument:gsub("%s", ""):upper()
				local value11, value12, number18

				if argument2 ~= "gold" then
					local value13
					value13, value11, value12 = callback14(scriptKey)

					if value13 then
						getgenv().SCRIPT_KEY = scriptKey

						if value12 then
							number18 = os.time() + value12
						else
							number18 = nil
						end

						callback7(scriptKey, value11, number18)
						return true, value11, number18
					end
				else
					local value13
					value13, value11 = callback16(scriptKey)
					value12 = nil

					if value13 then
						getgenv().SCRIPT_KEY = scriptKey

						if value12 then
							number18 = os.time() + value12
						else
							number18 = nil
						end

						callback7(scriptKey, value11, number18)
						return true, value11, number18
					end
				end

				return false, value11
			end

			return false, "Enter a key first"
		end

		return false, "Enter a key first"
	end

	callback10 = function(argument)
		local value11, value12, value13 = callback9(argument, "free")

		if not value11 then
			if not value12:find("Network error") and not value12:find("HTTP request support") and not value12:find("Empty response") and not value12:match("^HTTP %d") then
				if condition then
					local value14
					value14, value12, value13 = callback9(argument, "gold")
					if value14 then
						return true, value12, value13
					end
				end

				return false, "Invalid key"
			end

			return false, value12
		end

		return true, value12, value13
	end

	local border = data4.Border

	Frame7 = callback2("Frame", {
		Parent = Frame4,
		Size = UDim2.new(1, -80, 0, 32),
		Position = UDim2.new(0, 40, 0, 112),
		BackgroundColor3 = data4.Control,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
	}, { getUICorner(9), callback3(border, 1) })

	local number18 = number17 + 3448942451 + 3448942451

	TextBox = callback2("TextBox", {
		Parent = Frame7,
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		PlaceholderText = "Paste your key (Standard / Lifetime)",
		PlaceholderColor3 = data4.SubText,
		Text = "",
		Font = Enum.Font.GothamBold,
		TextColor3 = data4.Text,
		TextSize = 12,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Center,
	})

	callback11 = function(argument, argument2, argument3)
		local argument4, argument5, UIScale2, mouseButton1Down, mouseButton1Down2, connect, callback17

		if argument2 then
			argument4 = argument2
			argument5 = argument3 or 0
		else
			argument4 = 0.1

			if argument3 then
				argument5 = argument3
				UIScale2 = argument3("UIScale", { Parent = argument })

				argument.MouseEnter:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
					TweenService:Create(argument, tweenInfo, { BackgroundTransparency = argument5 }):Play()
				end)

				argument.MouseLeave:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1 }):Play()
					TweenService:Create(argument, tweenInfo, { BackgroundTransparency = argument4 }):Play()
				end)

				mouseButton1Down = argument.MouseButton1Down
				mouseButton1Down2 = mouseButton1Down
				connect = mouseButton1Down.Connect

				callback17 = function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 0.97 }):Play()
				end

				connect(mouseButton1Down2, callback17)

				argument.MouseButton1Up:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
				end)

				return UIScale2
			else
				argument5 = 0
				UIScale2 = argument3("UIScale", { Parent = argument })

				argument.MouseEnter:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
					TweenService:Create(argument, tweenInfo, { BackgroundTransparency = argument5 }):Play()
				end)

				argument.MouseLeave:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1 }):Play()
					TweenService:Create(argument, tweenInfo, { BackgroundTransparency = argument4 }):Play()
				end)

				mouseButton1Down = argument.MouseButton1Down
				mouseButton1Down2 = mouseButton1Down
				connect = mouseButton1Down.Connect

				callback17 = function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 0.97 }):Play()
				end

				connect(mouseButton1Down2, callback17)

				argument.MouseButton1Up:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
				end)

				return UIScale2
			end
		end

		UIScale2 = argument3("UIScale", { Parent = argument })

		argument.MouseEnter:Connect(function()
			TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
			TweenService:Create(argument, tweenInfo, { BackgroundTransparency = argument5 }):Play()
		end)

		argument.MouseLeave:Connect(function()
			TweenService:Create(UIScale2, tweenInfo, { Scale = 1 }):Play()
			TweenService:Create(argument, tweenInfo, { BackgroundTransparency = argument4 }):Play()
		end)

		mouseButton1Down = argument.MouseButton1Down
		mouseButton1Down2 = mouseButton1Down
		connect = mouseButton1Down.Connect

		callback17 = function()
			TweenService:Create(UIScale2, tweenInfo, { Scale = 0.97 }):Play()
		end

		connect(mouseButton1Down2, callback17)

		argument.MouseButton1Up:Connect(function()
			TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
		end)

		return UIScale2
	end

	color = Color3.new(1, 0.84705883264541626, 0.36078432202339172)
	local border2 = data4.Border

	TextButton4 = callback2("TextButton", {
		Parent = Frame4,
		Size = UDim2.new(0.5, -46, 0, 34),
		Position = UDim2.new(0, 40, 0, 152),
		BackgroundColor3 = data4.Control,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "GET KEY",
		TextSize = 12,
		TextColor3 = data4.Text,
	}, { getUICorner(10), callback3(border2, 1) })

	callback11(TextButton4, 0.2, 0.05)
	local number19 = 0 - number18
	local accent = data4.Accent

	TextButton5 = callback2("TextButton", {
		Parent = Frame4,
		Size = UDim2.new(0.5, -46, 0, 34),
		Position = UDim2.new(0.5, 6, 0, 152),
		BackgroundColor3 = data4.AccentDim,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "CHECK KEY",
		TextSize = 12,
		TextColor3 = data4.Text,
	}, { getUICorner(10), callback3(accent, 1, 0.15) })

	callback11(TextButton5)
	local number20 = number18 + number19
	local number21 = number19 - 312862738
	local number22 = number20 + number21

	TextButton6 = callback2("TextButton", {
		Parent = Frame4,
		Size = UDim2.new(1, -80, 0, 38),
		Position = UDim2.new(0, 40, 0, 194),
		BackgroundColor3 = data4.Control,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "GOLD MEMBER KEY",
		TextSize = 12,
		TextColor3 = color,
		Visible = condition,
	}, { getUICorner(10), callback3(Color3.new(1, 0.84705883264541626, 0.36078432202339172), 1, 0.2) })

	callback11(TextButton6, 0.2, 0.05)
	local value11 = bit32.band(2804890629 // number21, number22)
	local accent2 = data4.Accent

	TextButton7 = callback2("TextButton", {
		Parent = Frame4,
		Size = UDim2.new(1, -80, 0, 44),
		Position = UDim2.new(0, 40, 0, 150),
		BackgroundColor3 = data4.AccentDim,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "CHOOSE GAME",
		TextSize = 13,
		TextColor3 = data4.Text,
		Visible = false,
	}, { getUICorner(10), callback3(accent2, 1, 1) })

	callback11(TextButton7)

	TextButton7.MouseButton1Click:Connect(function()
		if condition2 then
			callback6("games")
			return
		end
	end)

	local number23 = number22 + 1944484691
	local value12 = bit32.band(value11, number23)

	configMap = {
		lifetime = {
			label = "◆  LIFETIME",
			color = Color3.new(0.49019607901573181, 0.88627451658248901, 1),
			toast = "Lifetime key valid — access never expires. Welcome.",
		},
		premium = {
			label = "★  PREMIUM",
			color = Color3.new(0.72156864404678345, 0.51764708757400513, 1),
			toast = "Premium key valid — access granted.",
		},
		gold = { label = "★  GOLD", color = color, toast = "Gold key valid — welcome, member!" },
		free = { label = "STANDARD", color = data4.SubText, toast = "Key valid — access granted." },
	}

	local border3 = data4.Border
	local number24 = bit32.bor(number23, value12)

	Frame8 = callback2("Frame", {
		Parent = Frame4,
		Name = "TierBadge",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 110),
		Size = UDim2.new(0, 0, 0, 28),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = data4.Control,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Visible = false,
	}, { getUICorner(14), callback3(border3, 1) })

	callback2("UIPadding", { Parent = Frame8, PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) })
	local value13 = bit32.band(value12, 858646822)
	local number25 = number23 - 327345407

	TextLabel4 = callback2("TextLabel", {
		Parent = Frame8,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 28),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = "",
		TextColor3 = data4.Text,
		TextSize = 12,
		TextYAlignment = Enum.TextYAlignment.Center,
	})

	number12 = 3888000

	callback12 = function(argument)
		local number26 = math.floor(argument / 86400)
		local number27 = math.floor(argument % 86400 / 3600)
		local number28 = math.floor(argument % 3600 / 60)

		local function callback17(argument2, argument3)
			local text2

			if argument2 ~= 1 then
				text2 = "s"
			else
				text2 = ""
			end

			return argument2 .. " " .. argument3 .. text2
		end

		if not (number26 > 0) then
			if not (number27 > 0) then
				local format = ("Key expires in %s").format
				local value14 = callback17(math.max(number28, 1), "minute")
				return format("Key expires in %s", value14)
			end

			local format = ("Key expires in %s %s").format
			local value14 = callback17(number27, "hour")
			local value15 = callback17(number28, "minute")
			return format("Key expires in %s %s", value14, value15)
		end

		local format = ("Key expires in %s %s").format
		local value14 = callback17(number26, "day")
		local value15 = callback17(number27, "hour")
		return format("Key expires in %s %s", value14, value15)
	end

	local number26 = number24 // 15
	local value14 = bit32.band(value13, number25)

	TextLabel5 = callback2("TextLabel", {
		Parent = Frame4,
		Name = "ExpiryLabel",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 204),
		Size = UDim2.new(1, -60, 0, 16),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = "",
		TextColor3 = data4.SubText,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Visible = false,
	})

	number13 = number25 + number26

	callback2("TextLabel", {
		Parent = Frame5,
		Size = UDim2.new(1, -32, 0, 22),
		Position = UDim2.new(0, 16, 0, 58),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = "GOLD MEMBER",
		TextColor3 = color,
		TextSize = 18,
		TextXAlignment = Enum.TextXAlignment.Center,
	})

	Frame9 = callback2("Frame", {
		Parent = Frame5,
		Size = UDim2.new(1, -80, 0, 34),
		Position = UDim2.new(0, 40, 0, 102),
		BackgroundColor3 = data4.Control,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
	}, { getUICorner(9), callback3(Color3.new(1, 0.84705883264541626, 0.36078432202339172), 1, 0.2) })

	local number27 = value14 // 85

	TextBox2 = callback2("TextBox", {
		Parent = Frame9,
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		PlaceholderText = "Paste your Gold key",
		PlaceholderColor3 = data4.SubText,
		Text = "",
		Font = Enum.Font.GothamBold,
		TextColor3 = color,
		TextSize = 12,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Center,
	})

	local data8 = {}
	data8.Parent = Frame5
	data8.Size = UDim2.new(0.5, -46, 0, 38)
	data8.Position = UDim2.new(0, 40, 0, 148)
	data8.BackgroundColor3 = data4.Control
	data8.BackgroundTransparency = backgroundTransparency
	data8.BorderSizePixel = 0
	data8.AutoButtonColor = false
	local number28 = number27
	data8.Font = Enum.Font.GothamBold
	data8.Text = "GET GOLD KEY"
	data8.TextSize = 11
	data8.TextColor3 = color
	TextButton8 = callback2("TextButton", data8, { getUICorner(10), callback3(Color3.new(1, 0.84705883264541626, 0.36078432202339172), 1, 0.2) })
	number14 = number27 * 34579
	callback11(TextButton8, 0.2, 0.05)
	number15 = number28 * 43225
end

do
	local TextButton9 = callback2("TextButton", {
		Parent = Frame5,
		Size = UDim2.new(0.5, -46, 0, 38),
		Position = UDim2.new(0.5, 6, 0, 148),
		BackgroundColor3 = Color3.new(0.27450981736183167, 0.21960784494876862, 0.078431375324726105),
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "CHECK KEY",
		TextSize = 12,
		TextColor3 = color,
	}, { getUICorner(10), callback3(Color3.new(1, 0.84705883264541626, 0.36078432202339172), 1, 0.15) })

	callback11(TextButton9)

	local function callback13(argument, argument2)
		if condition2 then
			return
		end
		condition2 = true
		data6.v = true
		local argument3

		if argument then
			if configMap[argument] then
				argument3 = argument
			else
				argument3 = "free"
			end
		else
			argument3 = "free"
		end

		local configEntry = configMap[argument3]
		local condition3 = argument3 ~= "free"
		getgenv().NR_TIER = argument3
		local genv = getgenv()
		genv.NR_GOLD = argument3 == "gold" or argument3 == "lifetime"
		local data7 = { Frame7, TextButton4, TextButton5, TextButton6, Frame9, TextButton8, TextButton9 }
		local value5, value6, value7 = ipairs(data7)

		for _, value8 in value6, value7 do
			TweenService:Create(value8, configEntry, { BackgroundTransparency = 1 }):Play()
			local uiStroke = value8:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				TweenService:Create(uiStroke, configEntry, { Transparency = 1 }):Play()
			end

			if value8:IsA("TextButton") then
				TweenService:Create(value8, configEntry, { TextTransparency = 1 }):Play()
			end
		end

		TweenService:Create(TextBox, configEntry, { TextTransparency = 1 }):Play()
		TweenService:Create(TextBox2, configEntry, { TextTransparency = 1 }):Play()
		local value8, value9

		local function callback14()
			local value10, value11, value12 = ipairs(data7)

			for _, value13 in value11, value12 do
				if value13.Parent then
					value13.Visible = false
				end
			end

			if condition3 then
				TextLabel4.Text = configEntry.label
				TextLabel4.TextColor3 = configEntry.color
				Frame8.UIStroke.Color = configEntry.color
				Frame8.Visible = true
				TweenService:Create(callback2("UIScale", { Parent = Frame8, Scale = 0.8 }), tweenInfo3, { Scale = 1 }):Play()

				if argument3 == "lifetime" then
					Frame8.UIStroke.Transparency = 0.05

					task.spawn(function()
						while Frame8.Visible do
							if Frame8.Parent then
								TweenService:Create(Frame8.UIStroke, TweenInfo.new(1, Enum.EasingStyle.Sine), { Transparency = 0.6 }):Play()
								task.wait(1.05)

								if Frame8.Visible and Frame8.Parent then
									TweenService:Create(Frame8.UIStroke, TweenInfo.new(1, Enum.EasingStyle.Sine), { Transparency = 0.05 }):Play()
									task.wait(1.05)
									continue
								end
							end

							break
						end
					end)
				end
			end

			TextButton7.Visible = true
			TweenService:Create(TextButton7, condition3, { BackgroundTransparency = 0.1 }):Play()
			TweenService:Create(TextButton7.UIStroke, condition3, { Transparency = 0.15 }):Play()

			while true do
			end
		end

		task.delay(0.18, callback14)

		if condition3 then
			data5.home = configEntry.label
			data5.games = configEntry.label
			argument.Text = configEntry.label
			TweenService:Create(argument, configEntry, { TextColor3 = configEntry.color }):Play()

			if argument2 and argument2 - os.time() < number12 then
				TextLabel5.Visible = true

				task.spawn(function()
					while TextLabel5.Visible do
						if TextLabel5.Parent then
							local number16 = argument2 - os.time()

							if not (number16 <= 0) then
								TextLabel5.Text = callback12(number16)
								local TextLabel6 = TextLabel5
								local danger

								if number16 < 3600 then
									danger = data4.Danger or data4.SubText
								else
									danger = data4.SubText
									TextLabel6.TextColor3 = danger
									task.wait(30)
									continue
								end

								TextLabel6.TextColor3 = danger
								task.wait(30)
								continue
							end

							TextLabel5.Text = "Key expired — grab a new one"
							TextLabel5.TextColor3 = data4.Danger
							return
						end

						break
					end
				end)
			end
		elseif argument2 and argument2 - os.time() < number12 then
			TextLabel5.Visible = true

			task.spawn(function()
				while TextLabel5.Visible do
					if TextLabel5.Parent then
						local number16 = argument2 - os.time()

						if not (number16 <= 0) then
							TextLabel5.Text = callback12(number16)
							local TextLabel6 = TextLabel5
							local danger

							if number16 < 3600 then
								danger = data4.Danger or data4.SubText
							else
								danger = data4.SubText
								TextLabel6.TextColor3 = danger
								task.wait(30)
								continue
							end

							TextLabel6.TextColor3 = danger
							task.wait(30)
							continue
						end

						TextLabel5.Text = "Key expired — grab a new one"
						TextLabel5.TextColor3 = data4.Danger
						return
					end

					break
				end
			end)
		end

		if text ~= "home" then
			callback6("home")
		end

		callback4(configEntry.toast)
	end

	local condition3 = false

	local function callback14(argument, argument2, argument3, argument4, argument5, text2, argument6)
		local number16 = 165333668

		local function callback15(...)
			if not condition2 and not condition3 then
				local argument7 = argument

				if bit32.bxor(argument7, 428331801) ~= 142473909 then
					argument7 = bit32.bxor(argument7, 630834127)
				end

				local text3 = argument7.Text
				condition3 = true
				argument3.Text = "CHECKING..."

				task.spawn(function()
					local ok, response, response2, response3 = pcall(callback9, text3, argument5)
					condition3 = false
					argument3.Text = text2

					if ok then
						if response then
							callback13(response2, response3)
							return
						end
						local position = argument2.Position

						for i = 1, 4 do
							local argument8 = argument2
							local uDim2FromOffset = UDim2.fromOffset
							local number17

							if i % 2 == 0 then
								number17 = 5
							else
								number17 = -5
							end

							argument8.Position = position + uDim2FromOffset(number17, 0)
							task.wait(0.04)
						end

						argument2.Position = position
						TweenService:Create(argument2.UIStroke, response3, { Color = data4.Danger, Transparency = 0.1 }):Play()
						local number17 = 102754315

						local function callback16()
							if number17 ~= 276785316 then
								number17 = bit32.bxor(number17, 1428776417)
							end

							TweenService:Create(argument2.UIStroke, response3, { Color = argument6, Transparency = 0.2 }):Play()
						end

						number17 = 276785316
						task.delay(0.8, callback16)
						callback4(response2 or "Invalid key.", true, 4)
						return
					end

					pcall(rconsoleerr, "[NRL] validateKey crash: " .. tostring(response) .. "\n")
					callback4("Key check crashed: " .. tostring(response), true, 10)
				end, ...)

				return
			end
		end

		number16 = 301607340
		return callback15
	end

	local value5 = callback14(TextBox, Frame7, TextButton5, number14 + 54569172, "free", "CHECK KEY", data4.Border)
	local value6 = callback14(TextBox2, Frame9, TextButton9, 54569172, "gold", "CHECK KEY", Color3.new(1, 0.84705883264541626, 0.36078432202339172))
	TextButton5.MouseButton1Click:Connect(value5)

	TextBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			value5()
			return
		end
	end)

	TextButton9.MouseButton1Click:Connect(value6)

	TextBox2.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			value6()
			return
		end
	end)

	TextButton6.MouseButton1Click:Connect(function()
		callback6("gold")
	end)

	TextButton4.MouseButton1Click:Connect(function()
		if condition2 then
			return
		end
		local ok = pcall(setclipboard, "https://www.nrlscript.com/key")
		local text2

		if ok then
			text2 = "Key page copied — open it in your browser: " .. keyUrl or "Open this in your browser: " .. keyUrl
		else
			text2 = "Open this in your browser: " .. keyUrl
			callback4(text2, not ok, 8)
			return
		end

		callback4(text2, not ok, 8)
	end)

	TextButton8.MouseButton1Click:Connect(function()
		if condition2 then
			return
		end
		local ok = pcall(setclipboard, "https://discord.gg/vrzg9YaNPj")
		local text2

		if ok then
			text2 = "Discord invite copied — join to get Gold key."
		else
			text2 = "Join Discord: " .. vrzg9YaNPjUrl
		end

		callback4(text2, not ok)
	end)

	task.spawn(function()
		local value7 = callback8()

		if value7 then
			local value8, value9, value10 = callback10(value7)

			if value8 then
				getgenv().SCRIPT_KEY = value7
				callback13(value9, value10)
				callback7(value7, value9, value10)
				return
			end

			if value9 == "Invalid key" then
				pcall(delfile, "nr_loader_key.txt")
				return
			end
		end
	end)

	TextButton3.MouseButton1Click:Connect(function()
		local number16 = 913867998
		local number17 = 3190641505

		if condition2 then
			pcall(delfile, "nr_loader_key.txt")
			getgenv().SCRIPT_KEY = nil
			getgenv().NR_TIER = nil
			getgenv().NR_GOLD = nil
			local number18 = number16 // number17
			condition2 = false
			data6.v = false

			if text ~= "home" then
				callback6("home")
			end

			TextButton3.Visible = false
			Frame8.Visible = false
			TextLabel5.Visible = false
			TweenService:Create(TextButton7, tweenInfo, { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
			TweenService:Create(TextButton7.UIStroke, tweenInfo, { Transparency = 1 }):Play()
			local number19 = number18 - 4068920330

			local function callback15()
				local TextButton10 = TextButton7

				if bit32.bxor(number19, 366569084) ~= 78120299 then
					number19 = bit32.bxor(number19, 3139527465)
				end

				if TextButton10.Parent then
					TextButton7.Visible = false
					return
				end
			end

			number19 = 292643607
			task.delay(0.18, callback15)
			data5.home = home
			data5.games = "Choose a game"
			TextLabel2.Text = home
			TweenService:Create(TextLabel2, tweenInfo, { TextColor3 = data4.SubText }):Play()
			TextBox.Text = ""
			TextBox2.Text = ""

			local value7, value8, value9 = ipairs({
				{ o = Frame7, bg = backgroundTransparency, stroke = 0.2 },
				{ o = TextButton4, bg = backgroundTransparency, stroke = 0.2, text = true },
				{ o = TextButton5, bg = 0.1, stroke = 0.15, text = true },
				{ o = TextButton6, bg = backgroundTransparency, stroke = 0.2, text = true },
				{ o = Frame9, bg = backgroundTransparency, stroke = 0.2 },
				{ o = TextButton8, bg = backgroundTransparency, stroke = 0.2, text = true },
				{ o = TextButton9, bg = 0.1, stroke = 0.15, text = true },
			})

			for _, value10 in value8, value9 do
				value10.o.Visible = value10.o ~= TextButton6 or false
				TweenService:Create(value10.o, tweenInfo, { BackgroundTransparency = value10.bg }):Play()
				local uiStroke = value10.o:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					TweenService:Create(uiStroke, tweenInfo, { Transparency = value10.stroke }):Play()
				end

				if value10.text and value10.o:IsA("TextButton") then
					TweenService:Create(value10.o, tweenInfo, { TextTransparency = 0 }):Play()
				end
			end

			TweenService:Create(TextBox, tweenInfo, { TextTransparency = 0 }):Play()
			TweenService:Create(TextBox2, tweenInfo, { TextTransparency = 0 }):Play()
			callback4("Key logged out — paste a new key to switch.")
			return
		end
	end)
end

local condition3, number16, ScrollingFrame, text2, text3, condition4, callback13

do
	local number17 = bit32.band(number14, number15)
	local number18 = number15 + number17

	local data7 = {
		Parent = Frame4,
		Size = UDim2.new(1, -80, 0, 18),
		Position = UDim2.new(0, 40, 0, 240),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Font = Enum.Font.Gotham,
		Text = "Need help? discord.gg/vrzg9YaNPj — click to copy",
		TextSize = 10,
		TextColor3 = data4.Accent,
	}

	callback2("TextButton", data7).MouseButton1Click:Connect(function()
		local ok = pcall(setclipboard, "https://discord.gg/vrzg9YaNPj")
		local text4

		if ok then
			text4 = "Invite link copied to clipboard"
		else
			text4 = "setclipboard unavailable"
		end

		callback4(text4, not ok)
	end)

	local textLabel = {
		Parent = Frame4,
		Size = UDim2.new(1, -32, 0, 12),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 16, 1, -8),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
	}

	local format = ("%d scripts available  |  %s").format

	local function callback14()
		local number19 = 152732062

		local function callback15()
			local value5 = identifyexecutor
			if bit32.bxor(number19, 114914498) ~= 314880253 then
				number19 = bit32.bxor(number19, 888543741)
				return value5()
			end
			return value5()
		end

		number19 = 337495103
		local ok, response = pcall(callback15)
		if ok and response then
			return response
		end
		return "Volt"
	end

	local value5 = callback14(number18 - 3810238358)
	textLabel.Text = format("%d scripts available  |  %s", #data2, value5)
	textLabel.TextColor3 = data4.SubText
	textLabel.TextSize = 10
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	callback2("TextLabel", textLabel)
	condition3 = true

	task.spawn(function()
		while condition3 do
			TweenService:Create(UIStroke, TweenInfo.new(1.1, Enum.EasingStyle.Sine), { Transparency = 0.85 }):Play()
			task.wait(1.15)

			if condition3 then
				TweenService:Create(UIStroke, TweenInfo.new(1.1, Enum.EasingStyle.Sine), { Transparency = 0.45 }):Play()
				task.wait(1.15)
				continue
			end

			break
		end
	end)

	number16 = number17 * number18 - number18

	ScrollingFrame = callback2("ScrollingFrame", {
		Parent = Frame6,
		Size = UDim2.new(1, -20, 1, -12),
		Position = UDim2.new(0, 10, 0, 6),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = data4.Border,
		ScrollBarImageTransparency = 0.3,
	})

	local number19 = bit32.band(number18, number13)
	callback2("UIListLayout", { Parent = ScrollingFrame, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

	callback2("UIPadding", {
		Parent = ScrollingFrame,
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft = UDim.new(0, 2),
		PaddingRight = UDim.new(0, 6),
	})

	text2 = ""
	text3 = ""
	condition4 = false
	local data8 = {}

	local function callback15()
		local value6, value7, value8 = ipairs(data8)

		for _, value9 in value7, value8 do
			task.spawn(value9, text2, text3)
		end
	end

	local function callback16(argument)
		if condition4 then
			task.spawn(argument, text2, text3)
		end

		local insert = table.insert
		insert(data8, argument)
	end

	local number20 = number19 + 254071946

	callback13 = function(argument, argument2, argument3)
		if argument and argument.match and #argument.match ~= 0 then
			local text4 = (argument2 or ""):lower()
			local text5 = (argument3 or ""):lower()
			local value6 = ipairs
			local value7, condition5, value8

			if number20 ~= 382946598 then
				value7, condition5, value8 = value6(argument.match)
			else
				condition5 = number20 + 67944929 ~= 270464497

				if nil <= nil then
					value7, condition5, value8 = value6(argument.match)
				end
			end

			for _, value9 in condition5, value8 do
				local text6 = value9:lower()
				if text4 ~= "" and text4:find(text6, 1, true) then
					return true
				end

				if text5 ~= "" and text5:find(text6, 1, true) then
					return true
				end
			end
		end

		return false
	end

	task.spawn(function()
		for i = 1, 5 do
			local number21 = 225940537

			local function callback17()
				if number21 ~= 451973260 then
					number21 = bit32.bxor(number21, 2287805977)
				end

				return MarketplaceService:GetProductInfo(game.PlaceId)
			end

			number21 = 451973260
			local ok, response = pcall(callback17)

			if ok then
				if response then
					if type(response.Name) ~= "string" then
						task.wait(i * 0.4)
					elseif response.Name ~= "" then
						text2 = response.Name
						break
					else
						task.wait(i * 0.4)
					end
				else
					task.wait(i * 0.4)
				end
			else
				task.wait(i * 0.4)
			end
		end

		local number21 = 100655444

		local function callback17()
			local function callback18(argument)
				local response

				if typeof(httpRequest) == "function" then
					response = httpRequest({ Url = argument, Method = "GET" })
					if response and response.Body then
						return response.Body
					end
				end

				if typeof(request) == "function" then
					response = request({ Url = argument, Method = "GET" })
					if response and response.Body then
						return response.Body
					end
				end

				while true do
					if game.HttpGet then
						local value6 = pcall
						local httpGet = game.HttpGet
						local gameRef = game
						response = not not argument

						if response then
							local value7, value8 = value6(httpGet, gameRef, argument, true)
							if value7 and value8 then
								return value8
							end
							return nil
						end

						if response.Body then
							break
						end
					else
						return nil
					end
				end

				return response.Body
			end

			if bit32.bxor(number21, 477423004) ~= 304635019 then
				number21 = bit32.bxor(number21, 1521049049)
			end

			if game.GameId and game.GameId ~= 0 then
				local value6 = callback18("https://games.roblox.com/v1/games?universeIds=" .. tostring(game.GameId))

				if value6 and type(value6) == "string" then
					local match = value6:match("\"name\"%s*:%s*\"([^\"]+)\"")
					if match then
						text3 = match
						return
					end
				end
			end
		end

		number21 = 240957719
		pcall(callback17)

		if text2 == "" and type(game.Name) == "string" and game.Name ~= "" and game.Name ~= "Game" then
			text2 = game.Name
		end

		condition4 = true
		local name

		if text2 ~= "" then
			name = text2

			if not text2 then
				if text3 ~= "" then
					name = text3 or ""
				else
					name = ""
				end
			end
		elseif text3 ~= "" then
			name = text3 or ""
		else
			name = ""
		end

		local TextLabel6 = TextLabel3
		local text4

		if name ~= "" then
			text4 = "In game: " .. name or "Game not identified"
		else
			text4 = "Game not identified"
			TextLabel6.Text = text4
			callback15()
			return
		end

		TextLabel6.Text = text4
		callback15()
	end)

	local condition5 = false

	local function callback17()
		local nrTier = getgenv().NR_TIER

		if nrTier ~= "gold" and nrTier ~= "premium" and nrTier ~= "lifetime" then
			local ok, response = pcall(readfile, "nr_loader_key.txt")

			if ok and type(response) == "string" and response ~= "" then
				local parts = response:split("|")
				local text4

				if parts[3] then
					text4 = parts[3]:lower()

					if text4 then
						if text4 ~= "gold" and text4 ~= "premium" and text4 ~= "lifetime" then
							return false
						end
						return true
					end
				end

				text4 = ""
				if text4 == "premium" then
					return true
				end

				if text4 == "lifetime" then
					return true
				end
			end

			return false
		end

		return true
	end

	local function callback18(argument, argument2, argument3)
		task.spawn(function()
			local number21 = 2922779251
			if argument.delayed then
				argument3(false, "Delayed", "This script is currently under maintenance / repair.")
				return
			end

			if argument.premiumOnly then
				if not callback17() then
					argument3(false, "Premium Only", argument.name .. " khusus member Premium / Gold / Lifetime!")
					return
				end
				number21 = 2922779251
			end

			argument2("Fetching...")
			local number22 = 21514261

			local function callback19()
				local gameRef = game

				if bit32.bxor(number22, 406709984) == 159080375 then
					number22 = bit32.bxor(number22, 4107919673)
				end

				return gameRef:HttpGet(argument.url, true)
			end

			number22 = 522309152
			local ok, response = pcall(callback19)

			if ok and type(response) == "string" and response ~= "" then
				if not response:sub(1, 15):lower():find("<!doctype") and not response:lower():find("^404: not found") then
					argument2("Loading...")

					if argument.genv then
						local genv = getgenv()
						local value6, value7, value8 = pairs(argument.genv)

						for k, value9 in value7, value8 do
							if k ~= "SCRIPT_KEY" then
								genv[k] = value9
							elseif not condition2 then
								genv[k] = value9
							end
						end
					end

					local value6 = callback8()

					if value6 and getgenv().SCRIPT_KEY == nil then
						getgenv().SCRIPT_KEY = value6
					end

					local chunk, loadErr = loadstring(response, "@" .. argument.name)
					if not chunk then
						argument3(false, "Compile error", ("loadstring: %s"):format(tostring(loadErr)))
						return
					end
					argument3(true, "Loaded", ("%s loaded."):format(argument.name))

					if readJsonFile() and queueOnTeleport then
						pcall(queueOnTeleport, "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua\"))()")
					end

					local number23 = 235668477

					local function callback20()
						local ok2, response2 = pcall(chunk)

						if number23 + 155233870 ~= 187571276 then
							if ok2 then
								return
							end
						else
							number23 = bit32.bxor(number23, 2767411019)
							if ok2 then
								return
							end
						end

						warn(("[NRL] %s runtime error: %s"):format(argument.name, tostring(response2)))
					end

					number23 = 267790901
					task.spawn(callback20)
					return
				end

				argument3(false, "Bad URL", ("%s returned a web page, not Lua. The raw link is wrong or the file is missing."):format(argument.name))
				return
			end

			argument3(false, "Fetch failed", ("HttpGet failed for %s — check the raw URL or your connection."):format(argument.name))
		end)
	end

	local function callback19(argument, argument2, argument3, argument4)
		if condition5 then
			return
		end
		condition5 = true
		argument3.Text = "Fetching..."
		argument3.TextColor3 = data4.SubText
		argument4.Visible = true
		local condition6 = true

		task.spawn(function()
			while condition6 do
				if argument4.Parent then
					argument4.Rotation = (argument4.Rotation + 6) % 360
					RunService.Heartbeat:Wait()
					continue
				end

				break
			end
		end)

		local function callback20(argument5, text4)
			condition6 = false
			argument4.Visible = false
			argument3.Text = text4
			local argument6 = argument3
			local accent

			if argument5 then
				accent = data4.Accent or data4.Danger
			else
				accent = data4.Danger
			end

			argument6.TextColor3 = accent
			local TweenService2 = TweenService
			local create = TweenService.Create
			local uiStroke = argument2.UIStroke
			local allowedProps = {}
			local accent2

			if argument5 then
				accent2 = data4.Accent or data4.Danger
			else
				accent2 = data4.Danger
				allowedProps.Color = accent2
				allowedProps.Transparency = 0.1
				local value6 = create(TweenService2, uiStroke, tweenInfo, allowedProps)
				value6:Play()
				condition5 = false
				return
			end

			allowedProps.Color = accent2
			allowedProps.Transparency = 0.1
			create(TweenService2, uiStroke, tweenInfo, allowedProps):Play()
			condition5 = false
		end

		callback18(argument, function(text4)
			argument3.Text = text4
		end, function(argument5, argument6, argument7)
			argument5(argument5, argument6)
			callback4(argument7, not argument5, 8)

			if argument5 then
				task.delay(0.6, function()
					TweenService:Create(Frame, tweenInfo4, { BackgroundTransparency = 1 }):Play()
					TweenService:Create(argument5, tweenInfo4, { Scale = argument5.Scale * 0.92 }):Play()
					task.wait(0.32)
					condition3 = false
					if ScreenGui.Parent then
						ScreenGui:Destroy()
						return
					end
				end)

				return
			end
		end)
	end

	local list = {}

	local function callback20()
		local value6, value7, value8 = ipairs(list)

		for _, value9 in value7, value8 do
			pcall(value9)
		end
	end

	number20 = bit32.bxor(number20, 286808282)

	local function callback21(argument, argument2, argument3)
		local number21 = 178670851
		local number22 = 1134156754
		local condition6 = argument.premiumOnly == true
		local color2, number23

		if condition6 then
			color2 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

			if color then
				number23 = 0.35
			else
				color2 = data4.Border

				if condition6 then
					number23 = 0.35
				else
					number23 = 0.2
				end
			end
		else
			color2 = data4.Border

			if condition6 then
				number23 = 0.35
			else
				number23 = 0.2
			end
		end

		local number24 = number21 // number22

		local TextButton9 = callback2("TextButton", {
			Parent = ScrollingFrame,
			LayoutOrder = argument3,
			Size = UDim2.new(1, 0, 0, 58),
			BackgroundColor3 = data4.Control,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
		}, { getUICorner(10), callback3(color2, 1, number23) })

		callback2("ImageLabel", {
			Parent = TextButton9,
			Size = UDim2.new(0, 34, 0, 34),
			Position = UDim2.new(0, 12, 0.5, -17),
			BackgroundColor3 = data4.Panel,
			BackgroundTransparency = 0.3,
			Image = argument.icon,
		}, { getUICorner(8) })

		local data9 = {
			Parent = TextButton9,
			Size = UDim2.new(1, -205, 0, 16),
			Position = UDim2.new(0, 56, 0, 10),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = argument.name,
		}

		local color3

		if condition6 then
			color3 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

			if not color then
				color3 = data4.Text
			end
		else
			color3 = data4.Text
		end

		data9.TextColor3 = color3
		data9.TextSize = 13
		data9.TextXAlignment = Enum.TextXAlignment.Left
		data9.TextTruncate = Enum.TextTruncate.AtEnd
		callback2("TextLabel", data9)
		local number25 = 447444964

		local data10 = {
			Parent = TextButton9,
			Size = UDim2.new(1, -205, 0, 14),
			Position = UDim2.new(0, 56, 0, 28),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			Text = argument.desc,
		}

		data10.TextColor3 = data4.SubText
		data10.TextSize = 11
		data10.TextXAlignment = Enum.TextXAlignment.Left
		data10.TextTruncate = Enum.TextTruncate.AtEnd
		callback2("TextLabel", data10)
		local condition7 = argument.delayed == true

		local textLabel2 = {
			Parent = TextButton9,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -26, 0, 10),
			Size = UDim2.new(0, 116, 0, 16),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
		}

		local text4

		if condition7 then
			text4 = "● DELAYED"
		elseif condition6 then
			text4 = "★ PREMIUM ONLY"
		else
			text4 = ""
		end

		textLabel2.Text = text4
		local danger

		if condition7 then
			danger = data4.Danger

			if not danger then
				if condition6 then
					danger = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

					if not color then
						danger = data4.SubText
						number24 = number24 - number25 - 3847522332
					end
				else
					danger = data4.SubText
					number24 = number24 - number25 - 3847522332
				end
			end
		elseif condition6 then
			danger = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

			if not color then
				danger = data4.SubText
				number24 = number24 - number25 - 3847522332
			end
		else
			danger = data4.SubText
			number24 = number24 - number25 - 3847522332
		end

		textLabel2.TextColor3 = danger
		textLabel2.TextSize = 9.5
		textLabel2.TextXAlignment = Enum.TextXAlignment.Right
		local TextLabel6 = callback2("TextLabel", textLabel2)

		local ImageLabel2 = callback2("ImageLabel", {
			Parent = TextButton9,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			BackgroundTransparency = 1,
			Visible = false,
			Image = "rbxasset://textures/loading/robloxTiltRight.png",
			ImageColor3 = data4.Accent,
		})

		local number26 = number24 + number25

		local TextLabel7 = callback2("TextLabel", {
			Parent = TextButton9,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0, 10, 0, 16),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = ">",
			TextColor3 = data4.SubText,
			TextSize = 12,
		})

		local border = data4.Border

		local TextButton10 = callback2("TextButton", {
			Parent = TextButton9,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -26, 0, 31),
			Size = UDim2.new(0, 116, 0, 20),
			BackgroundColor3 = data4.Control,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "⚡ Auto Execute: OFF",
			Font = Enum.Font.Gotham,
			TextSize = 8.5,
			TextColor3 = data4.SubText,
		}, { getUICorner(6), callback3(border, 1) })

		local function callback22()
			local jsonFile = readJsonFile()

			if jsonFile and jsonFile.gameName == argument.name then
				local number27 = math.max(1, math.ceil((jsonFile.expiresAt - os.time()) / 3600))
				TextButton10.BackgroundColor3 = data4.AccentDim
				TextButton10.BackgroundTransparency = 0.1
				TextButton10.Text = ("⚡ Auto Execute: %dh"):format(number27)
				TextButton10.TextColor3 = Color3.new(1, 1, 1)
				local TextButton11 = TextButton10
				local font = Enum.Font
				TextButton11.Font = font.GothamBold
				TextButton10.UIStroke.Color = data4.Accent
				TextButton10.UIStroke.Transparency = 0.2
				return
			end

			TextButton10.BackgroundColor3 = data4.Control
			TextButton10.BackgroundTransparency = backgroundTransparency
			TextButton10.Text = "⚡ Auto Execute: OFF"
			TextButton10.TextColor3 = data4.SubText
			TextButton10.Font = Enum.Font.Gotham
			TextButton10.UIStroke.Color = data4.Border
			TextButton10.UIStroke.Transparency = 0.5
		end

		callback22()
		table.insert(list, callback22)
		local number27 = 0
		local mouseButton1Down = TextButton10.MouseButton1Down
		local mouseButton1Down2 = mouseButton1Down
		local connect = mouseButton1Down.Connect
		local number28 = number26 + 84920319

		local function callback23()
			local now = os.clock()

			if number28 ~= 30169862 then
				number28 = bit32.bxor(number28, 591718409)
			end

			number27 = now + 0.4
		end

		number28 = 30169862
		connect(mouseButton1Down2, callback23)

		TextButton10.MouseButton1Click:Connect(function()
			local jsonFile = readJsonFile()

			if jsonFile and jsonFile.gameName == argument.name then
				saveFile(nil)
				callback20()
				callback4("Auto Execute turned OFF for " .. argument.name)
				return
			end

			if argument.delayed then
				callback4("This script is currently under maintenance / repair.", true, 5)
				return
			end

			if condition6 and not callback17() then
				callback4("Khusus member Premium / Gold / Lifetime!", true, 5)
				return
			end
			pcall(setclipboard, "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua\"))()")
			callback4(("[Auto Exec: 24h] %s aktif! Link dicopy ke clipboard."):format(argument.name))
		end)

		local number29 = 179420946

		local function callback24(argument4, argument5)
			if TextButton9.Parent and callback13(argument, argument4, argument5) then
				local TextLabel8 = TextLabel6
				local text5

				if condition6 then
					text5 = "CURRENT (PREMIUM)"
				else
					text5 = "CURRENT GAME"
				end

				TextLabel8.Text = text5
				local TextLabel9 = TextLabel6
				local uiScale, TweenService2, create, uiStroke, allowedProps, color4, value6, number30

				if condition6 then
					local color5 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

					if color then
						TextLabel9.TextColor3 = color5
						TextButton9.LayoutOrder = -1
						uiScale = TextButton9:FindFirstChildOfClass("UIScale")

						if uiScale then
							uiScale.Scale = 0.97
							local tween = TweenService:Create(uiScale, condition6, { Scale = 1 })
							tween:Play()
						end

						TweenService2 = TweenService
						create = TweenService.Create
						uiStroke = TextButton9.UIStroke
						allowedProps = {}

						if condition6 then
							color4 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

							if color then
								allowedProps.Color = color4
								allowedProps.Transparency = 0.1
								value6 = create(TweenService2, uiStroke, number28, allowedProps)
								number30 = number29
								value6:Play()

								while true do
								end
							end
						end

						color4 = data4.AccentDim
						allowedProps.Color = color4
						allowedProps.Transparency = 0.1
						value6 = create(TweenService2, uiStroke, number28, allowedProps)
						number30 = number29
						value6:Play()

						while true do
						end
					end
				end

				TextLabel9.TextColor3 = data4.Accent
				TextButton9.LayoutOrder = -1
				uiScale = TextButton9:FindFirstChildOfClass("UIScale")

				if uiScale then
					uiScale.Scale = 0.97
					TweenService:Create(uiScale, condition6, { Scale = 1 }):Play()
				end

				TweenService2 = TweenService
				create = TweenService.Create
				uiStroke = TextButton9.UIStroke
				allowedProps = {}

				if condition6 then
					color4 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

					if color then
						allowedProps.Color = color4
						allowedProps.Transparency = 0.1
						value6 = create(TweenService2, uiStroke, number28, allowedProps)
						number30 = number29
						value6:Play()

						while true do
						end
					end
				end

				allowedProps.Color = data4.AccentDim
				allowedProps.Transparency = 0.1
				value6 = create(TweenService2, uiStroke, number28, allowedProps)
				number30 = number29
				value6:Play()

				while true do
				end
			end
		end

		number29 = 377145784
		callback16(callback24)
		local UIScale2 = callback2("UIScale", { Parent = TextButton9 })
		local mouseEnter = TextButton9.MouseEnter
		local mouseEnter2 = mouseEnter
		local connect2 = mouseEnter.Connect
		local number30 = number26 - 4258339010

		local function callback25()
			TweenService:Create(TextButton9, number28, { BackgroundTransparency = 0.05 }):Play()

			if number30 + 220569372 == 279743517 then
				number30 = bit32.bxor(number30, 3556695743)
			end

			TweenService:Create(UIScale2, number28, { Scale = 1.015 }):Play()
			local TweenService2 = TweenService
			local create = TweenService.Create
			local data11 = {}
			local color4

			if condition6 then
				color4 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

				if not color then
					color4 = data4.Accent
				end
			else
				color4 = data4.Accent
				data11.TextColor3 = color4
				local value6 = create(TweenService2, TextLabel7, number28, data11)
				value6:Play()
				return
			end

			data11.TextColor3 = color4
			create(TweenService2, TextLabel7, number28, data11):Play()
		end

		number30 = 352978003
		connect2(mouseEnter2, callback25)
		local mouseLeave = TextButton9.MouseLeave
		local mouseLeave2 = mouseLeave
		local connect3 = mouseLeave.Connect
		local number31 = number26 - 339996067

		local function callback26()
			if bit32.bxor(number31, 283816386) ~= 462702415 then
				number31 = bit32.bxor(number31, 3452637031)
			end

			TweenService:Create(TextButton9, number28, { BackgroundTransparency = backgroundTransparency }):Play()
			TweenService:Create(UIScale2, number28, { Scale = 1 }):Play()
			TweenService:Create(TextLabel7, number28, { TextColor3 = data4.SubText }):Play()
		end

		number31 = 192870029
		connect3(mouseLeave2, callback26)

		TextButton9.MouseButton1Click:Connect(function()
			if not (os.clock() < number27) then
				if argument.delayed then
					callback4("This script is currently under maintenance / repair.", true, 5)
					return
				end

				if condition5 then
					callback4("Another script is still loading.", true, 3)
					return
				end

				if condition6 and not callback17() then
					callback4("Evomon Gold V4 khusus member Premium / Gold / Lifetime!", true, 5)
					return
				end
				TextLabel7.Visible = false
				callback19(argument, TextButton9, TextLabel6, ImageLabel2)
				return
			end
		end)

		TextButton9.BackgroundTransparency = 1
		UIScale2.Scale = 0.96

		task.delay(0.04 * argument3, function()
			if TextButton9.Parent then
				TweenService:Create(TextButton9, number28, { BackgroundTransparency = backgroundTransparency }):Play()
				TweenService:Create(UIScale2, condition6, { Scale = 1 }):Play()
				return
			end
		end)

		return TextButton9
	end

	local value6, value7, value8 = ipairs(data2)

	for k, value9 in value7, value8 do
		callback21(value9, number16 + 269302503, k)
	end

	local function callback22()
		local number21 = 2961806243
		local number22 = 1208887655
		if not Frame.Visible then
			return
		end
		local list2 = {}
		local value9, value10, value11 = ipairs(data.items)

		for _, value12 in value10, value11 do
			local value13 = callback(value12)

			if value13 then
				list2[#list2 + 1] = value13
			end
		end

		if #list2 == 0 then
			print(("[NRL] whats-new: no catalog match for {%s} — check the names in WHATS_NEW.items"):format(table.concat(data.items, ", ")))
			return
		end
		local number23 = 46 + #list2 * 34 + 8 + 32
		local number24 = number23 + 14

		local TextButton9 = callback2("TextButton", {
			Name = "WhatsNew",
			Parent = Frame,
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundColor3 = Color3.new(0, 0, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
			ZIndex = 50,
		})

		local data9 = {
			Parent = TextButton9,
			Active = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.fromOffset(300, number24),
			BackgroundColor3 = data4.Window,
			BackgroundTransparency = 0.02,
			BorderSizePixel = 0,
		}

		data9.ZIndex = 51
		local accent = data4.Accent
		local Frame10 = data9("Frame", data9, { getUICorner(12), callback3(accent, 1, 0.25) })
		local accent2 = data4.Accent

		local data10 = {
			Parent = data9("Frame", {
				Parent = Frame10,
				Position = UDim2.new(0, 14, 0, 14),
				Size = UDim2.new(0, 42, 0, 16),
				BackgroundColor3 = data4.AccentDim,
				BorderSizePixel = 0,
				ZIndex = 52,
			}, { getUICorner(8), callback3(accent2, 1, 0.3) }),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
		}

		local font = Enum.Font
		data10.Font = font.GothamBold
		data10.Text = "NEW"
		data10.TextSize = 9
		data10.TextColor3 = data4.Accent
		data10.ZIndex = 53
		data9("TextLabel", data10)

		local textLabel2 = {
			Parent = Frame10,
			Position = UDim2.new(0, 62, 0, 13),
			Size = UDim2.new(1, -100, 0, 18),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
		}

		local text4

		if not (#list2 > 1) then
			text4 = "New Game Added"
		else
			text4 = "New Games Added"
		end

		textLabel2.Text = text4
		textLabel2.TextColor3 = data4.Text
		textLabel2.TextSize = 14
		textLabel2.ZIndex = 52
		textLabel2.TextXAlignment = Enum.TextXAlignment.Left
		local textTruncate = Enum.TextTruncate
		textLabel2.TextTruncate = textTruncate.AtEnd
		data9("TextLabel", textLabel2)

		local data11 = {
			Parent = Frame10,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -12, 0, 12),
			Size = UDim2.new(0, 20, 0, 20),
			BackgroundColor3 = data4.Control,
			BackgroundTransparency = backgroundTransparency,
			AutoButtonColor = false,
			Text = "x",
			Font = Enum.Font.GothamBold,
			TextSize = 12,
		}

		local data12 = data4
		data11.TextColor3 = data12.SubText
		data11.ZIndex = 52
		local TextButton10 = data9("TextButton", data11, { getUICorner(6) })
		callback5(TextButton10, data4.Danger)
		local value12, value13, value14 = ipairs(list2)
		local tween, callback23

		for k, value15 in value13, value14 do
			local Frame11 = data9("Frame", {
				Parent = Frame10,
				Position = UDim2.fromOffset(14, 46 + (k - 1) * 34),
				Size = UDim2.new(1, -28, 0, 30),
				BackgroundColor3 = data4.Control,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 52,
			}, { getUICorner(8) })

			data9("ImageLabel", {
				Parent = Frame11,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0, 8, 0.5, -12),
				BackgroundColor3 = data4.Panel,
				BackgroundTransparency = 0.3,
				Image = value15.icon,
				ZIndex = 53,
			}, { getUICorner(6) })

			data9("TextLabel", {
				Parent = Frame11,
				Position = UDim2.new(0, 40, 0, 3),
				Size = UDim2.new(1, -50, 0, 13),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				Text = value15.name,
				TextColor3 = data4.Text,
				TextSize = 12,
				ZIndex = 53,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			})

			data9("TextLabel", {
				Parent = Frame11,
				Position = UDim2.new(0, 40, 0, 16),
				Size = UDim2.new(1, -50, 0, 12),
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				Text = value15.desc,
				TextColor3 = data4.SubText,
				TextSize = 10,
				ZIndex = 53,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			})

			local number25 = number21 + 234209498

			callback23 = function()
				local Frame12 = Frame11

				if number25 + 41790811 ~= 398591706 then
					number25 = bit32.bxor(number25, 2983333227)
				end

				if Frame12.Parent then
					TweenService:Create(Frame11, tween, { BackgroundTransparency = backgroundTransparency }):Play()
					return
				end
			end

			number25 = 356800895
			task.delay(0.05 * k, callback23)
		end

		local data13 = {
			Parent = Frame10,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -14),
			Size = UDim2.new(1, -28, 0, 32),
			BackgroundColor3 = data4.AccentDim,
			BackgroundTransparency = 0.1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Font = Enum.Font.GothamBold,
			Text = "GOT IT",
			TextSize = 12,
		}

		local data14 = data4

		-- This Source Was Generated by discord.gg/c3xVMnUUBv
		if number21 + 62417772 ~= 62417772 then
			local number25 = bit32.band(bit32.rshift(number21, 29), 7)
			local number26 = bit32.band(bit32.bxor(number21, number25), 536870911)
			local value15 = bit32.bxor(208594413, number26)
			local value16 = bit32.lshift(value15, 13)
			local value17 = bit32.band(bit32.bxor(value15, value16), 536870911)
			local value18 = bit32.rshift(value17, 13)
			local value19 = bit32.bxor(value17, value18)
			local value20 = bit32.lshift(value19, 14)
			local value21 = bit32.band(bit32.bxor(value19, value20), 536870911)
			local value22 = bit32.lshift(value21, 13)
			local value23 = bit32.band(bit32.bxor(value21, value22), 536870911)
			local value24 = bit32.rshift(value23, 13)
			local value25 = bit32.bxor(value23, value24)
			local value26 = bit32.lshift(value25, 14)
			local value27 = bit32.band(bit32.bxor(value25, value26), 536870911)
			local value28 = bit32.lshift(value27, 13)
			local value29 = bit32.band(bit32.bxor(value27, value28), 536870911)
			local value30 = bit32.rshift(value29, 13)
			local value31 = bit32.bxor(value29, value30)
			local value32 = bit32.lshift(value31, 14)
			local value33 = bit32.band(bit32.bxor(value31, value32), 536870911)
			local value34 = bit32.lshift(value33, 13)
			local value35 = bit32.band(bit32.bxor(value33, value34), 536870911)
			local value36 = bit32.rshift(value35, 13)
			local value37 = bit32.bxor(value35, value36)
			local value38 = bit32.lshift(value37, 14)
			local value39 = bit32.band(bit32.bxor(value37, value38), 536870911)
			local value40 = table.pack(bit32.lshift(value39, 13))
		end

		data13.TextColor3 = data14.Text
		data13.ZIndex = 52
		local accent3 = data4.Accent
		local TextButton11 = data9("TextButton", data13, { getUICorner(9), callback3(accent3, 1, 0.2) })

		if number22 + 358666450 == 358666456 then
			callback11(TextButton11)
			local UIScale2 = data9("UIScale", { Parent = Frame10, Scale = 0.9 })

			if number22 ~= 70470227 then
				Frame10.BackgroundTransparency = 1
				Frame10.UIStroke.Transparency = 1
				TweenService:Create(TextButton9, callback23, { BackgroundTransparency = 0.45 }):Play()
				tween = TweenService:Create(UIScale2, data11, { Scale = 1 })
				tween:Play()
				TweenService:Create(Frame10, callback23, { BackgroundTransparency = 0.02 }):Play()
				TweenService:Create(Frame10.UIStroke, callback23, { Transparency = 0.25 }):Play()
				local condition6 = false

				local function callback24()
					if condition6 then
						return
					end
					condition6 = true
					TweenService:Create(TextButton9, callback23, { BackgroundTransparency = 1 }):Play()
					TweenService:Create(UIScale2, callback23, { Scale = 0.92 }):Play()
					TweenService:Create(Frame10, callback23, { BackgroundTransparency = 1 }):Play()
					TweenService:Create(Frame10.UIStroke, callback23, { Transparency = 1 }):Play()
					local value15, value16, value17 = ipairs(Frame10:GetDescendants())

					for _, value18 in value16, value17 do
						local tween2

						if value18:IsA("TextLabel") then
							tween2 = TweenService:Create(value18, callback23, { TextTransparency = 1 })
							tween2:Play()
						elseif value18:IsA("TextButton") then
							tween2 = TweenService:Create(value18, callback23, { TextTransparency = 1 })
							tween2:Play()
						end

						local tween3

						if value18:IsA("Frame") then
							tween3 = TweenService:Create(value18, callback23, { BackgroundTransparency = 1 })
							tween3:Play()
						elseif value18:IsA("ImageLabel") then
							tween3 = TweenService:Create(value18, callback23, { BackgroundTransparency = 1 })
							tween3:Play()
						end

						if value18:IsA("ImageLabel") then
							TweenService:Create(value18, callback23, { ImageTransparency = 1 }):Play()
						end

						if value18:IsA("UIStroke") then
							TweenService:Create(value18, callback23, { Transparency = 1 }):Play()
						end
					end

					local number25 = 25351274

					local function destroyAll()
						local TextButton12 = TextButton9

						if number25 == 18717777 then
							number25 = bit32.bxor(number25, 3473670903)
						end

						if TextButton12.Parent then
							TextButton9:Destroy()
							return
						end
					end

					number25 = 394384446
					task.delay(0.34, destroyAll)
				end

				TextButton11.MouseButton1Click:Connect(callback24)
				TextButton10.MouseButton1Click:Connect(callback24)
				return
			end

			local number25 = bit32.band(bit32.rshift(number22, 29), 7)
			local number26 = bit32.band(bit32.bxor(number22, number25), 536870911)
			local value15 = bit32.bxor(120745192, number26)
			local value16 = table.pack(bit32.lshift(value15, 13))

			while true do
			end
		else
			while true do
			end
		end
	end

	print(("[NRL] whats-new: showing %d item(s)"):format(#data.items))
	local number21 = 20

	local function callback23(argument)
		local jsonFile = readJsonFile()

		if jsonFile and jsonFile.gameName then
			local value9 = callback(jsonFile.gameName)

			if value9 then
				math.max(1, math.ceil((jsonFile.expiresAt - os.time()) / 3600))
				local number22 = 204307130

				local function callback24()
					local now = os.clock()

					while true do
						if callback13(value9, text2, text3) then
							if value9.premiumOnly and not callback17() then
								saveFile(nil)
								Frame.Visible = true
								callback4("Auto Execute dibatalkan: " .. value9.name .. " khusus member Premium / Gold / Lifetime!", true, 6)
								argument()
								return
							end

							local whatsNew = Frame:FindFirstChild("WhatsNew")

							if whatsNew then
								whatsNew:Destroy()
							end

							Frame.Visible = false
							local data9 = {}
							if number22 == 98192377 then
								continue
							end
							data9.Parent = ScreenGui
							data9.Active = true
							data9.AnchorPoint = Vector2.new(0.5, 0)
							data9.Position = UDim2.new(0.5, 0, 0, 24)
							data9.Size = UDim2.new(0, 360, 0, 62)

							while true do
							end
						else
							if condition4 then
								break
							end

							if not (number21 < os.clock() - now) then
								task.wait(0.1)
								continue
							end
							break
						end
					end

					print(("[NRL] auto-exec: %s tidak cocok dengan place=%q universe=%q"):format(value9.name, text2, text3))
					argument()
				end

				number22 = 191084961
				task.spawn(callback24)
				return true
			end
		end

		return false
	end

	local function callback24()
		task.delay(0.35, callback22)
	end

	if not callback23(callback24) then
		callback24()
	end
end

local function destroyAll()
	condition3 = false
	TweenService:Create(Frame, tweenInfo4, { BackgroundTransparency = 1 }):Play()
	TweenService:Create(Frame.UIStroke, tweenInfo4, { Transparency = 1 }):Play()
	TweenService:Create(UIScale, tweenInfo4, { Scale = UIScale.Scale * 0.9 }):Play()
	task.wait(0.32)
	if ScreenGui.Parent then
		ScreenGui:Destroy()
		return
	end
end

TextButton2.MouseButton1Click:Connect(function()
	task.spawn(destroyAll)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift and ScreenGui.Parent then
		Frame.Visible = not Frame.Visible
		return
	end
end)

callback4("Nasi Rendang loader ready. Pick a game.")
print("Deobf By Zed")
