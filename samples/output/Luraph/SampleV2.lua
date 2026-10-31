local n
n = 1494280530
local n2
n2 = 93860970
local TweenService, UserInputService, RunService, MarketplaceService, HttpService, httpRequest, localPlayer

do
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
end

local hui
hui = nil

pcall(function()
	if typeof(gethui) ~= "function" then
		return
	end
	hui = gethui()
end)

local home, vrzg9YaNPjUrl, tbl, tbl2, n3, n4, tbl3

do
	local n5 = n - 2783575027

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
		n2 = n2 + n5 + 1289294497
	end

	home = "Free Script Loader"
	vrzg9YaNPjUrl = "https://discord.gg/vrzg9YaNPj"
	tbl = { items = { "Violent District", "Break and Steal", "Anime Dice" } }
	tbl2 = {}
	local n6 = n2 + 95095349
	local n7 = n5 // n6 - 3670288205 + n6
	local n8 = n6 + n7 + n7
	local n9 = (n7 + 1217751808) // n8
	n3 = n8 + n9 + n9
	n4 = n9 - n3
	tbl3 = {}
end

local n32 = bit32.band(n3, 4294967295)
local v = bit32.band(t1926_545_1[1], 65535)
local v2 = bit32.rshift(t1926_545_1[1], 16)
local n322 = bit32.band(n32, 65535)
local v3
v3 = bit32.band(v * n322 + bit32.lshift(bit32.band(v * bit32.rshift(n32, 16) + v2 * n322, 65535), 16), 4294967295)
tbl3.name = "Evomon Gold V4"
tbl3.desc = "Auto hunt / evolve / VIP farm"
tbl3.icon = "rbxassetid://112510549708715"
tbl3.match = { "evomon" }
tbl3.url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/evg.lua"
tbl3.premiumOnly = true

tbl2[1] = {
	name = "Violent District",
	desc = "Survivor / Killer / ESP / OP",
	icon = "rbxthumb://type=GameIcon&id=6739698191&w=150&h=150",
	match = { "violent district", "violence district" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/vd.lua",
}

tbl2[2] = {
	name = "Break and Steal",
	desc = "Auto steal / farm / defense",
	icon = "rbxthumb://type=GameIcon&id=10765288803&w=150&h=150",
	match = { "break and steal", "break steal", "break & steal" },
	url = "https://api.luarmor.net/files/v4/loaders/1c42f17db76929706a530cdc272ffea3.lua",
}

tbl2[3] = {
	name = "Anime Dice",
	desc = "Auto roll / farm / luck",
	icon = "rbxthumb://type=GameIcon&id=10708913337&w=150&h=150",
	match = { "anime dice" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/ad.lua",
}

tbl2[4] = {
	name = "Ride A Pet",
	desc = "Auto farm / egg / ride",
	icon = "rbxthumb://type=GameIcon&id=10035204815&w=150&h=150",
	match = { "ride a pet", "ride pet" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/main/rap.lua",
}

tbl2[5] = {
	name = "Capybara VS Plant",
	desc = "Auto farm",
	icon = "rbxassetid://105645768765428",
	match = { "capybara", "capybara vs plant" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/cvp.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

tbl2[6] = {
	name = "Steal an Egg",
	desc = "Auto steal / farm",
	icon = "rbxassetid://71490087912254",
	match = { "steal an egg", "steal egg" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/sae3.lua",
}

tbl2[7] = {
	name = "Grow a Chicken Fighter",
	desc = "Auto farm / fight",
	icon = "rbxassetid://94197048748373",
	match = { "grow a chicken", "chicken fighter" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/gacf.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

tbl2[8] = {
	name = "Anime Expedition",
	desc = "Auto match / farm",
	icon = "rbxassetid://131974959514318",
	match = { "anime expedition", "expedition" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/ae.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

tbl2[9] = {
	name = "Iron Souls",
	desc = "Auto farm / forge / upgrade",
	icon = "rbxassetid://114063353587790",
	match = { "iron souls", "iron soul" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/is.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

tbl2[10] = {
	name = "Anime Card Farm",
	desc = "Auto farm / cards",
	icon = "rbxassetid://115169947896689",
	match = { "anime card" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/acf.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

tbl2[11] = {
	name = "Roblox Anti AFK",
	desc = "Blocks idle kick / any game",
	icon = "rbxassetid://118103427371929",
	match = {},
	url = "https://api.jnkie.com/api/v1/luascripts/public/cd8dd27757251102a6298aa2c848b792c81ec29f9b0160711ffa8340b1844646/download",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

tbl2[12] = {
	name = "Grow A Garden 2",
	desc = "Auto farm / shop / sell",
	icon = "rbxassetid://103507136591905",
	match = { "grow a garden", "garden" },
	url = "https://raw.githubusercontent.com/JualNasiRendang/gag2/refs/heads/main/gag2.lua",
}

tbl2[13] = {
	name = "Tap Heroes: Pet Simulator 99",
	desc = "Auto tap / farm",
	icon = "rbxassetid://95633120003456",
	match = { "pet simulator", "tap heroes" },
	url = "https://raw.githubusercontent.com/JualNasiRendang/tap-heroes-pet-99/refs/heads/main/tapheroes.lua",
}

tbl2[14] = {
	name = "Haze Seas",
	desc = "Auto punch / farm",
	icon = "rbxassetid://95336994655521",
	match = { "haze seas", "haze" },
	url = "https://raw.githubusercontent.com/unclebitcoin100x-bot/waduhek/refs/heads/main/hs.lua",
	genv = { SCRIPT_KEY = "KEYLESS" },
}

tbl2[15] = {
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

tbl2[16] = {
	name = "Build a Ring Farm",
	desc = "Auto farm",
	icon = "rbxassetid://131809011640166",
	match = { "build a ring", "ring farm" },
	url = "https://raw.githubusercontent.com/JualNasiRendang/nasirendang-barf/refs/heads/main/nasirendang-barf.lua",
}

tbl2[17] = {
	name = "Evomon",
	desc = "Auto hunt / evolve",
	icon = "rbxassetid://112510549708715",
	match = { "evomon" },
	url = "https://raw.githubusercontent.com/JualNasiRendang/nasirendang-evomon/refs/heads/main/nasirendang-evomon.lua",
}

tbl2[18] = tbl3
local fn

fn = function(arg)
	for _, v4 in ipairs(tbl2) do
		if v4.name ~= arg then
			continue
		end
		return v4
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
	local n5 = 86400

	readJsonFile = function()
		local ok, result = pcall(readfile, "nr_loader_autoexec.json")

		if ok and type(result) == "string" and result ~= "" then
			local ok2, result2 = pcall(function()
				return HttpService:JSONDecode(result)
			end)

			if ok2 and type(result2) == "table" and result2.gameName and result2.expiresAt then
				if not (result2.expiresAt <= os.time()) then
					return result2
				end
				pcall(delfile, "nr_loader_autoexec.json")
				return nil
			end
		end

		return nil
	end

	saveFile = function(arg)
		if arg then
			pcall(writefile, "nr_loader_autoexec.json", HttpService:JSONEncode({ gameName = arg, enabledAt = os.time(), expiresAt = os.time() + n5, durationHours = 24 }))
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

local tbl4, backgroundTransparency, tweenInfo, n42, tweenInfo2, tweenInfo3, tweenInfo4, fn2, getUICorner, n5
local fn3, n6, ScreenGui, n7, Frame, UIScale

do
	local n8 = n3 + n4
	local n43 = bit32.rshift(n4, 23)

	tbl4 = {
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
	n42 = bit32.lshift(n43, 9)
	tweenInfo2 = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	tweenInfo3 = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	tweenInfo4 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

	fn2 = function(arg, arg2, arg3)
		local instance = Instance.new(arg)
		local v4 = pairs
		arg2 = arg2 or {}

		for k, v5 in v4(arg2) do
			instance[k] = v5
		end

		local v5 = ipairs
		arg3 = arg3 or {}

		for _, v6 in v5(arg3) do
			v6.Parent = instance
		end

		return instance
	end

	getUICorner = function(arg)
		return fn2("UICorner", { CornerRadius = UDim.new(0, arg or 8) })
	end

	n5 = 325043278

	fn3 = function(arg, thickness, transparency)
		local uiStroke = { Color = arg or tbl4.Border }

		if n5 + 117422833 == 132803028 then
			n5 = bit32.bxor(n5, 3545652547)
		end

		uiStroke.Thickness = thickness
		uiStroke.Transparency = transparency or 0.2
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		return fn2("UIStroke", uiStroke)
	end

	local tbl5 = {}
	n6 = n8 + 494365338
	local huis = { hui, localPlayer:FindFirstChildOfClass("PlayerGui") }
	local v32 = v3
	local n62 = bit32.band(n6, 4294967295)
	local v322 = bit32.band(v32, 65535)
	local v323 = bit32.rshift(v32, 16)
	local n622 = bit32.band(n62, 65535)
	local v4 = bit32.band(v322 * n622 + bit32.lshift(bit32.band(v322 * bit32.rshift(n62, 16) + v323 * n622, 65535), 16), 4294967295)

	pcall(function()
		if gethui then
			huis[#huis + 1] = gethui()
			return
		end
	end)

	pcall(function()
		huis[#huis + 1] = game:GetService("CoreGui")
	end)

	for _, hui2 in ipairs(huis) do
		if hui2 and not tbl5[hui2] then
			tbl5[hui2] = true

			for _, child in ipairs(hui2:GetChildren()) do
				if child.Name == "NR_Loader" then
					pcall(function()
						child:Destroy()
					end)
				end
			end
		end
	end

	ScreenGui = fn2("ScreenGui", {
		Name = "NR_Loader",
		Parent = hui,
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 1000,
	})

	local n9 = 420
	local n10 = 330
	n5 = bit32.bxor(n5, 202264007)
	local n11 = v4 // n42
	n7 = n6 + n42

	Frame = fn2("Frame", {
		Name = "Window",
		Parent = ScreenGui,
		Active = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		Size = UDim2.new(0, 420, 0, 330),
		BackgroundColor3 = tbl4.Window,
		BackgroundTransparency = 0.12,
		BorderSizePixel = 0,
		ClipsDescendants = true,
	}, { getUICorner(14), fn3(tbl4.Border, 1) })

	UIScale = fn2("UIScale", { Parent = Frame })

	local function clampValue()
		local currentCamera = workspace.CurrentCamera
		local viewportSize

		if currentCamera then
			viewportSize = currentCamera.ViewportSize or Vector2.new(800, 600)
		else
			viewportSize = Vector2.new(800, 600)
		end

		local n12 = math.min((viewportSize.X - 20) / n9, (viewportSize.Y - 20) / n10)

		if UserInputService.TouchEnabled then
			n12 *= 0.78
		end

		UIScale.Scale = math.clamp(n12, 0.34, 1)
	end

	clampValue()

	local function fn4()
		local currentCamera = workspace.CurrentCamera

		if currentCamera then
			pcall(function()
				currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue)
			end)

			return
		end
	end

	fn4()
	local n12 = n11 + 523800463

	local function fn5()
		if n12 + 142506498 ~= 403438049 then
			n12 = bit32.bxor(n12, 2796132829)
		end

		clampValue()
		fn4()
	end

	n12 = 260931551
	workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(fn5)
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
local fn4

local Frame2 = fn2("Frame", {
	Name = "Toasts",
	Parent = ScreenGui,
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, -12, 1, -12),
	Size = UDim2.new(0, 250, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
})

fn2("UIListLayout", {
	Parent = Frame2,
	Padding = UDim.new(0, 6),
	VerticalAlignment = Enum.VerticalAlignment.Bottom,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	SortOrder = Enum.SortOrder.LayoutOrder,
})

fn4 = function(arg, arg2, arg3)
	local danger

	if arg2 then
		danger = tbl4.Danger or tbl4.Accent
	else
		danger = tbl4.Accent
	end

	local Frame3 = fn2("Frame", {
		Parent = Frame2,
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = tbl4.Window,
		BackgroundTransparency = 0.05,
		BorderSizePixel = 0,
	}, { getUICorner(8), fn3(danger, 1) })

	fn2("Frame", {
		Parent = Frame3,
		Size = UDim2.new(0, 3, 1, -12),
		Position = UDim2.new(0, 6, 0.5, -16),
		BackgroundColor3 = danger,
		BorderSizePixel = 0,
	}, { getUICorner(2) })

	local TextLabel = fn2("TextLabel", {
		Parent = Frame3,
		Position = UDim2.new(0, 16, 0, 0),
		Size = UDim2.new(1, -26, 1, 0),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = arg,
		TextColor3 = tbl4.Text,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
	})

	TweenService:Create(fn2("UIScale", { Parent = Frame3, Scale = 0.85 }), tweenInfo3, { Scale = 1 }):Play()
	local delay = task.delay
	arg3 = arg3 or 5
	local n8 = 47489607

	local function fn5()
		local Frame4 = Frame3

		if n8 + 171137026 == 305624577 then
			local n82 = n8
			if n8 ~= 490807331 then
				return
			end
			n8 = bit32.bxor(n82, 2293314731)
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

	n8 = 490807331
	delay(arg3, fn5)
end

local Frame3, TextButton, ImageLabel, TextLabel, TextLabel2, TextButton2, n8, n9, TextButton3, fn5
local v4

do
	local v5 = bit32.band(3920625664, n7)

	Frame3 = fn2("Frame", {
		Name = "TopBar",
		Parent = Frame,
		Size = UDim2.new(1, 0, 0, 52),
		BackgroundColor3 = tbl4.TopBar,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
	}, { getUICorner(14) })

	local n10 = n7 + v5

	fn2("Frame", {
		Parent = Frame3,
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 1, -14),
		BackgroundColor3 = tbl4.TopBar,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
	})

	local n11 = v5 // n10

	TextButton = fn2("TextButton", {
		Parent = Frame3,
		Name = "Back",
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(0, 12, 0.5, -13),
		BackgroundColor3 = tbl4.Control,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "<",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = tbl4.SubText,
		Visible = false,
	}, { getUICorner(8) })

	ImageLabel = fn2("ImageLabel", {
		Parent = Frame3,
		Size = UDim2.new(0, 32, 0, 32),
		Position = UDim2.new(0, 14, 0.5, -16),
		BackgroundTransparency = 1,
		Image = "rbxassetid://124947058155926",
	}, { getUICorner(8) })

	local n12 = n10 - 441651735

	TextLabel = fn2("TextLabel", {
		Parent = Frame3,
		Size = UDim2.new(1, -160, 0, 17),
		Position = UDim2.new(0, 56, 0, 10),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = "Nasi Rendang LUA",
		TextColor3 = tbl4.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local n112 = bit32.bor(n11, n12)

	TextLabel2 = fn2("TextLabel", {
		Parent = Frame3,
		Size = UDim2.new(1, -160, 0, 13),
		Position = UDim2.new(0, 56, 0, 27),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = home,
		TextColor3 = tbl4.SubText,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	local n1122 = n112

	TextButton2 = fn2("TextButton", {
		Parent = Frame3,
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(1, -36, 0.5, -13),
		BackgroundColor3 = tbl4.Control,
		BackgroundTransparency = backgroundTransparency,
		Text = "x",
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextColor3 = tbl4.SubText,
		AutoButtonColor = false,
	}, { getUICorner(8) })

	n8 = n112 - n1122
	n9 = n12 + 80861551 - 68467876
	local border = tbl4.Border

	TextButton3 = fn2("TextButton", {
		Parent = Frame3,
		Name = "Logout",
		Size = UDim2.new(0, 58, 0, 24),
		Position = UDim2.new(1, -100, 0.5, -12),
		BackgroundColor3 = tbl4.Control,
		BackgroundTransparency = backgroundTransparency,
		AutoButtonColor = false,
		Text = "Logout",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = tbl4.SubText,
		Visible = false,
	}, { getUICorner(8), fn3(border, 1) })

	fn5 = function(arg, arg2, textColor3)
		arg.MouseEnter:Connect(function()
			local TweenService2 = TweenService
			local create = TweenService.Create
			local tbl5 = {}
			local arg22 = arg2

			if not arg2 then
				arg22 = tbl4.Text
			end

			tbl5.TextColor3 = arg22
			create(TweenService2, arg, tweenInfo, tbl5):Play()
		end)

		arg.MouseLeave:Connect(function()
			local TweenService2 = TweenService
			local create = TweenService.Create
			local tbl5 = {}
			tbl5.TextColor3 = textColor3 or tbl4.SubText
			create(TweenService2, arg, tweenInfo, tbl5):Play()
		end)
	end

	local danger = tbl4.Danger
	local v6 = bit32.band(n1122 - n8, 4294967295)
	local v62 = bit32.band(v6, 65535)
	v4 = bit32.band(v62 * 35151 + bit32.lshift(bit32.band(v62 * 0 + bit32.rshift(v6, 16) * 35151, 65535), 16), 4294967295)
	fn5(TextButton2, danger)
end

fn5(TextButton, tbl4.Text)
fn5(TextButton3, tbl4.Danger)

do
	local flag = nil
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
		flag = true
		position = position3
		position2 = position4
		local connection = nil

		connection = input2.Changed:Connect(function()
			if input2.UserInputState ~= Enum.UserInputState.End then
				return
			end
			flag = false
			connection:Disconnect()
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
		if flag and input2 == input then
			local n10 = input2.Position - position
			Frame.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n10.X, position2.Y.Scale, position2.Y.Offset + n10.Y)
			return
		end
	end)
end

local Frame4, Frame5, Frame6

do
	local Frame7 = fn2("Frame", {
		Name = "Content",
		Parent = Frame,
		Position = UDim2.new(0, 0, 0, 52),
		Size = UDim2.new(1, 0, 1, -52),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	})

	Frame4 = fn2("Frame", {
		Name = "Home",
		Parent = Frame7,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
	})

	Frame5 = fn2("Frame", {
		Name = "Gold",
		Parent = Frame7,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(-1, 0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
	})

	Frame6 = fn2("Frame", {
		Name = "Games",
		Parent = Frame7,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundTransparency = 1,
		Visible = false,
	})
end

local flag
flag = false
local tbl5, tbl6, str, fn6

do
	local tbl7 = { gold = -1, home = 0, games = 1 }
	local tbl8 = { gold = Frame5, home = Frame4, games = Frame6 }
	tbl5 = { gold = "Gold members", home = home, games = "Choose a game" }
	tbl6 = { v = false }
	str = "home"

	fn6 = function(arg)
		if str ~= arg then
			if arg == "games" and not tbl6.v then
				return
			end

			if arg == "gold" and not flag then
				return
			end

			if tbl8[arg] then
				str = arg
				local v5 = tbl7[arg]

				for k, v6 in pairs(tbl8) do
					v6.Visible = true
					TweenService:Create(v6, tweenInfo2, { Position = UDim2.fromScale(tbl7[k] - v5, 0) }):Play()
				end

				local flag2 = arg == "home"
				TextButton.Visible = not flag2
				local TweenService2 = TweenService
				local create = TweenService.Create
				local tbl9 = {}
				local uDim2New = UDim2.new
				local n10

				if flag2 then
					n10 = 14
				else
					n10 = 44
				end

				tbl9.Position = uDim2New(0, n10, 0.5, -16)
				create(TweenService2, ImageLabel, tweenInfo2, tbl9):Play()
				local n11

				if flag2 then
					n11 = 56
				else
					n11 = 86
				end

				TweenService:Create(TextLabel, tweenInfo2, { Position = UDim2.new(0, n11, 0, 10) }):Play()
				TweenService:Create(TextLabel2, tweenInfo2, { Position = UDim2.new(0, n11, 0, 27) }):Play()
				TextLabel2.Text = tbl5[arg]
				local n12 = 376740006

				local function fn7()
					local v6 = pairs

					if bit32.bxor(n12, 111691750) == 300206944 then
						n12 = bit32.bxor(n12, 3591534891)
					end

					for k, v7 in v6(tbl8) do
						if k ~= str then
							v7.Visible = false
						end
					end
				end

				n12 = 375570629
				task.delay(0.28, fn7)
				return
			end
		end
	end
end

do
	local mouseButton1Click = TextButton.MouseButton1Click
	local mouseButton1Click2 = mouseButton1Click
	local connect = mouseButton1Click.Connect
	local n10 = 440146619

	local function fn7()
		if bit32.bxor(n10, 99430202) == 23217081 then
			n10 = bit32.bxor(n10, 1348751597)
		end

		fn6("home")
	end

	n10 = 165499731
	connect(mouseButton1Click2, fn7)
end

local UIStroke, TextLabel3, keyUrl, fn7, fn8, flag2, fn9, fn10, Frame7, TextBox
local fn11, color, TextButton4, TextButton5, TextButton6, TextButton7, configMap, Frame8, TextLabel4, n10
local fn12, TextLabel5, n11, Frame9, TextBox2, TextButton8, n12, n13

do
	local n14 = n9 + v4 + 1954270278

	UIStroke = fn2("UIStroke", {
		Parent = fn2("ImageLabel", {
			Parent = Frame4,
			Size = UDim2.new(0, 60, 0, 60),
			AnchorPoint = Vector2.new(0.5, 0),
			Position = UDim2.new(0.5, 0, 0, 8),
			BackgroundTransparency = 1,
			Image = "rbxassetid://124947058155926",
		}, { getUICorner(14) }),
		Color = tbl4.Accent,
		Thickness = 1.5,
		Transparency = 0.55,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})

	fn2("TextLabel", {
		Parent = Frame4,
		Size = UDim2.new(1, -32, 0, 20),
		Position = UDim2.new(0, 16, 0, 72),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = "Nasi Rendang LUA Free Script",
		TextColor3 = tbl4.Text,
		TextSize = 16,
		TextXAlignment = Enum.TextXAlignment.Center,
	})

	TextLabel3 = fn2("TextLabel", {
		Parent = Frame4,
		Size = UDim2.new(1, -32, 0, 14),
		Position = UDim2.new(0, 16, 0, 92),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = "Detecting game...",
		TextColor3 = tbl4.SubText,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})

	keyUrl = "https://www.nrlscript.com/key"
	local tbl7 = { gold = { service = "1 Months", identifier = "1133593", provider = "1 Months Service" } }

	fn7 = function(arg, arg2, arg3)
		local concat = table.concat
		local tbl8 = {}
		local str2 = tostring(os.time())
		local str3, v5

		if arg2 then
			if arg3 then
				str3 = tostring(arg3) or ""
			else
				str3 = ""
				tbl8[1] = arg
				tbl8[2] = str2
				tbl8[3] = arg2
				tbl8[4] = str3
				v5 = concat(tbl8, "|")
				pcall(writefile, "nr_loader_key.txt", v5)
				return
			end
		else
			arg2 = ""

			if arg3 then
				str3 = tostring(arg3)

				if not str3 then
					str3 = ""
					tbl8[1] = arg
					tbl8[2] = str2
					tbl8[3] = arg2
					tbl8[4] = str3
					v5 = concat(tbl8, "|")
					pcall(writefile, "nr_loader_key.txt", v5)
					return
				end
			else
				str3 = ""
				tbl8[1] = arg
				tbl8[2] = str2
				tbl8[3] = arg2
				tbl8[4] = str3
				v5 = concat(tbl8, "|")
				pcall(writefile, "nr_loader_key.txt", v5)
				return
			end
		end

		tbl8[1] = arg
		tbl8[2] = str2
		tbl8[3] = arg2
		tbl8[4] = str3
		v5 = concat(tbl8, "|")
		pcall(writefile, "nr_loader_key.txt", v5)
	end

	fn8 = function()
		local ok, result = pcall(readfile, "nr_loader_key.txt")

		if ok and type(result) == "string" and result ~= "" then
			local matchs = {}

			for match in (result .. "|"):gmatch("([^|]*)|") do
				matchs[#matchs + 1] = match
			end

			local str2 = (matchs[1] or ""):gsub("%s+", "")

			if str2 ~= "" then
				local num = tonumber(matchs[2])
				local match

				if matchs[3] then
					if matchs[3] ~= "" then
						match = matchs[3] or nil
					else
						match = nil
					end
				else
					match = nil
				end

				local num2 = tonumber(matchs[4])
				if num then
					return str2, os.time() - num, match, num2
				end
				return str2, math.huge, match, num2
			end

			return nil
		end

		return nil
	end

	flag2 = false

	local function fn13()
		local ok, result = pcall(function()
			return gethwid()
		end)

		if ok and type(result) == "string" and result ~= "" then
			return result
		end
		return "uid-" .. tostring(localPlayer.UserId)
	end

	local n15 = n14 + 2579646458
	local v5, v6, v7, v8, v9

	local function fn14(arg)
		if httpRequest then
			local str2 = ("%s?key=%s&hwid=%s"):format("https://www.nrlscript.com/api/verify", HttpService:UrlEncode(arg), HttpService:UrlEncode(fn13()))
			local n16 = 503905154

			local function fn15()
				local requestData = {}
				local str22 = str2

				if n16 == 302681685 then
					n16 = bit32.bxor(n16, 2632809597)
				end

				requestData.Url = str22
				requestData.Method = "GET"
				requestData.Headers = { Accept = "application/json", ["User-Agent"] = "NRL-Loader/1.0", ["Cache-Control"] = "no-cache" }
				return httpRequest(requestData)
			end

			n16 = 488185262
			local ok, result = pcall(fn15)

			if ok and type(result) == "table" then
				local v10 = tostring
				v10(result.Body or result.body or "")
				return false, "Empty response from key server (HTTP " .. tostring(result.StatusCode or result.status_code or result.Status or "?") .. ")"
			end

			return false, "Network error — check your connection"
		end

		return false, "Executor has no HTTP request support"
	end

	local v10 = nil

	local function compileChunk()
		if v10 then
			return v10
		end

		local ok, result = pcall(function()
			return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
		end)

		if ok then
			if type(result) ~= "table" then
				return nil, tostring(result)
			end
			v10 = result
			return v10
		end

		return nil, tostring(result)
	end

	local function fn15(arg, arg2)
		arg.service = arg2.service
		arg.identifier = arg2.identifier
		arg.provider = arg2.provider
	end

	local function fn16(arg)
		local v11, v12 = compileChunk()
		if not v11 then
			return false, "SDK load failed: " .. tostring(v12)
		end
		fn15(v11, tbl7.gold)

		local ok, result = pcall(function()
			return v11.check_key(arg)
		end)

		if ok then
			if result and result.valid then
				return true, "gold"
			end
			return false, "Invalid key"
		end

		return false, "check_key error: " .. tostring(result)
	end

	fn9 = function(arg, arg2)
		if arg then
			if arg ~= "" then
				local scriptKey = arg:gsub("%s", ""):upper()
				local v11, v12, n16

				if arg2 ~= "gold" then
					local v13
					v13, v11, v12 = fn14(scriptKey)

					if v13 then
						getgenv().SCRIPT_KEY = scriptKey

						if v12 then
							n16 = os.time() + v12
						else
							n16 = nil
						end

						fn7(scriptKey, v11, n16)
						return true, v11, n16
					end
				else
					local v13
					v13, v11 = fn16(scriptKey)
					v12 = nil

					if v13 then
						getgenv().SCRIPT_KEY = scriptKey

						if v12 then
							n16 = os.time() + v12
						else
							n16 = nil
						end

						fn7(scriptKey, v11, n16)
						return true, v11, n16
					end
				end

				return false, v11
			end

			return false, "Enter a key first"
		end

		return false, "Enter a key first"
	end

	fn10 = function(arg)
		local v11, v12, v13 = fn9(arg, "free")

		if not v11 then
			if not v12:find("Network error") and not v12:find("HTTP request support") and not v12:find("Empty response") and not v12:match("^HTTP %d") then
				if flag then
					local v14
					v14, v12, v13 = fn9(arg, "gold")
					if v14 then
						return true, v12, v13
					end
				end

				return false, "Invalid key"
			end

			return false, v12
		end

		return true, v12, v13
	end

	local border = tbl4.Border

	Frame7 = fn2("Frame", {
		Parent = Frame4,
		Size = UDim2.new(1, -80, 0, 32),
		Position = UDim2.new(0, 40, 0, 112),
		BackgroundColor3 = tbl4.Control,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
	}, { getUICorner(9), fn3(border, 1) })

	local n16 = n15 + 3448942451 + 3448942451

	TextBox = fn2("TextBox", {
		Parent = Frame7,
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		PlaceholderText = "Paste your key (Standard / Lifetime)",
		PlaceholderColor3 = tbl4.SubText,
		Text = "",
		Font = Enum.Font.GothamBold,
		TextColor3 = tbl4.Text,
		TextSize = 12,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Center,
	})

	fn11 = function(arg, arg2, arg3)
		local arg22, arg32, UIScale2, mouseButton1Down, mouseButton1Down2, connect, fn17

		if arg2 then
			arg22 = arg2
			arg32 = arg3 or 0
		else
			arg22 = 0.1

			if arg3 then
				arg32 = arg3
				UIScale2 = arg3("UIScale", { Parent = arg })

				arg.MouseEnter:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
					TweenService:Create(arg, tweenInfo, { BackgroundTransparency = arg32 }):Play()
				end)

				arg.MouseLeave:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1 }):Play()
					TweenService:Create(arg, tweenInfo, { BackgroundTransparency = arg22 }):Play()
				end)

				mouseButton1Down = arg.MouseButton1Down
				mouseButton1Down2 = mouseButton1Down
				connect = mouseButton1Down.Connect

				fn17 = function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 0.97 }):Play()
				end

				connect(mouseButton1Down2, fn17)

				arg.MouseButton1Up:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
				end)

				return UIScale2
			else
				arg32 = 0
				UIScale2 = arg3("UIScale", { Parent = arg })

				arg.MouseEnter:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
					TweenService:Create(arg, tweenInfo, { BackgroundTransparency = arg32 }):Play()
				end)

				arg.MouseLeave:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1 }):Play()
					TweenService:Create(arg, tweenInfo, { BackgroundTransparency = arg22 }):Play()
				end)

				mouseButton1Down = arg.MouseButton1Down
				mouseButton1Down2 = mouseButton1Down
				connect = mouseButton1Down.Connect

				fn17 = function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 0.97 }):Play()
				end

				connect(mouseButton1Down2, fn17)

				arg.MouseButton1Up:Connect(function()
					TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
				end)

				return UIScale2
			end
		end

		UIScale2 = arg3("UIScale", { Parent = arg })

		arg.MouseEnter:Connect(function()
			TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
			TweenService:Create(arg, tweenInfo, { BackgroundTransparency = arg32 }):Play()
		end)

		arg.MouseLeave:Connect(function()
			TweenService:Create(UIScale2, tweenInfo, { Scale = 1 }):Play()
			TweenService:Create(arg, tweenInfo, { BackgroundTransparency = arg22 }):Play()
		end)

		mouseButton1Down = arg.MouseButton1Down
		mouseButton1Down2 = mouseButton1Down
		connect = mouseButton1Down.Connect

		fn17 = function()
			TweenService:Create(UIScale2, tweenInfo, { Scale = 0.97 }):Play()
		end

		connect(mouseButton1Down2, fn17)

		arg.MouseButton1Up:Connect(function()
			TweenService:Create(UIScale2, tweenInfo, { Scale = 1.03 }):Play()
		end)

		return UIScale2
	end

	color = Color3.new(1, 0.84705883264541626, 0.36078432202339172)
	local border2 = tbl4.Border

	TextButton4 = fn2("TextButton", {
		Parent = Frame4,
		Size = UDim2.new(0.5, -46, 0, 34),
		Position = UDim2.new(0, 40, 0, 152),
		BackgroundColor3 = tbl4.Control,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "GET KEY",
		TextSize = 12,
		TextColor3 = tbl4.Text,
	}, { getUICorner(10), fn3(border2, 1) })

	fn11(TextButton4, 0.2, 0.05)
	local n17 = 0 - n16
	local accent = tbl4.Accent

	TextButton5 = fn2("TextButton", {
		Parent = Frame4,
		Size = UDim2.new(0.5, -46, 0, 34),
		Position = UDim2.new(0.5, 6, 0, 152),
		BackgroundColor3 = tbl4.AccentDim,
		BackgroundTransparency = 0.1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "CHECK KEY",
		TextSize = 12,
		TextColor3 = tbl4.Text,
	}, { getUICorner(10), fn3(accent, 1, 0.15) })

	fn11(TextButton5)
	local n18 = n16 + n17
	local n19 = n17 - 312862738
	local n20 = n18 + n19

	TextButton6 = fn2("TextButton", {
		Parent = Frame4,
		Size = UDim2.new(1, -80, 0, 38),
		Position = UDim2.new(0, 40, 0, 194),
		BackgroundColor3 = tbl4.Control,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "GOLD MEMBER KEY",
		TextSize = 12,
		TextColor3 = color,
		Visible = flag,
	}, { getUICorner(10), fn3(Color3.new(1, 0.84705883264541626, 0.36078432202339172), 1, 0.2) })

	fn11(TextButton6, 0.2, 0.05)
	local v11 = bit32.band(2804890629 // n19, n20)
	local accent2 = tbl4.Accent

	TextButton7 = fn2("TextButton", {
		Parent = Frame4,
		Size = UDim2.new(1, -80, 0, 44),
		Position = UDim2.new(0, 40, 0, 150),
		BackgroundColor3 = tbl4.AccentDim,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = "CHOOSE GAME",
		TextSize = 13,
		TextColor3 = tbl4.Text,
		Visible = false,
	}, { getUICorner(10), fn3(accent2, 1, 1) })

	fn11(TextButton7)

	TextButton7.MouseButton1Click:Connect(function()
		if flag2 then
			fn6("games")
			return
		end
	end)

	local n21 = n20 + 1944484691
	local v112 = bit32.band(v11, n21)

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
		free = { label = "STANDARD", color = tbl4.SubText, toast = "Key valid — access granted." },
	}

	local border3 = tbl4.Border
	local n212 = bit32.bor(n21, v112)

	Frame8 = fn2("Frame", {
		Parent = Frame4,
		Name = "TierBadge",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 110),
		Size = UDim2.new(0, 0, 0, 28),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = tbl4.Control,
		BackgroundTransparency = 0.08,
		BorderSizePixel = 0,
		Visible = false,
	}, { getUICorner(14), fn3(border3, 1) })

	fn2("UIPadding", { Parent = Frame8, PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) })
	local v1122 = bit32.band(v112, 858646822)
	local n22 = n21 - 327345407

	TextLabel4 = fn2("TextLabel", {
		Parent = Frame8,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 28),
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamBold,
		Text = "",
		TextColor3 = tbl4.Text,
		TextSize = 12,
		TextYAlignment = Enum.TextYAlignment.Center,
	})

	n10 = 3888000

	fn12 = function(arg)
		local n23 = math.floor(arg / 86400)
		local n24 = math.floor(arg % 86400 / 3600)
		local n25 = math.floor(arg % 3600 / 60)

		local function fn17(arg2, arg3)
			local str2

			if arg2 ~= 1 then
				str2 = "s"
			else
				str2 = ""
			end

			return arg2 .. " " .. arg3 .. str2
		end

		if not (n23 > 0) then
			if not (n24 > 0) then
				local format = ("Key expires in %s").format
				local v12 = fn17(math.max(n25, 1), "minute")
				return format("Key expires in %s", v12)
			end

			local format = ("Key expires in %s %s").format
			local v12 = fn17(n24, "hour")
			local v13 = fn17(n25, "minute")
			return format("Key expires in %s %s", v12, v13)
		end

		local format = ("Key expires in %s %s").format
		local v12 = fn17(n23, "day")
		local v13 = fn17(n24, "hour")
		return format("Key expires in %s %s", v12, v13)
	end

	local n23 = n212 // 15
	local v11222 = bit32.band(v1122, n22)

	TextLabel5 = fn2("TextLabel", {
		Parent = Frame4,
		Name = "ExpiryLabel",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 204),
		Size = UDim2.new(1, -60, 0, 16),
		BackgroundTransparency = 1,
		Font = Enum.Font.Gotham,
		Text = "",
		TextColor3 = tbl4.SubText,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Visible = false,
	})

	n11 = n22 + n23

	fn2("TextLabel", {
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

	Frame9 = fn2("Frame", {
		Parent = Frame5,
		Size = UDim2.new(1, -80, 0, 34),
		Position = UDim2.new(0, 40, 0, 102),
		BackgroundColor3 = tbl4.Control,
		BackgroundTransparency = backgroundTransparency,
		BorderSizePixel = 0,
	}, { getUICorner(9), fn3(Color3.new(1, 0.84705883264541626, 0.36078432202339172), 1, 0.2) })

	local n24 = v11222 // 85

	TextBox2 = fn2("TextBox", {
		Parent = Frame9,
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		PlaceholderText = "Paste your Gold key",
		PlaceholderColor3 = tbl4.SubText,
		Text = "",
		Font = Enum.Font.GothamBold,
		TextColor3 = color,
		TextSize = 12,
		ClearTextOnFocus = false,
		TextXAlignment = Enum.TextXAlignment.Center,
	})

	local tbl8 = {}
	tbl8.Parent = Frame5
	tbl8.Size = UDim2.new(0.5, -46, 0, 38)
	tbl8.Position = UDim2.new(0, 40, 0, 148)
	tbl8.BackgroundColor3 = tbl4.Control
	tbl8.BackgroundTransparency = backgroundTransparency
	tbl8.BorderSizePixel = 0
	tbl8.AutoButtonColor = false
	local n242 = n24
	tbl8.Font = Enum.Font.GothamBold
	tbl8.Text = "GET GOLD KEY"
	tbl8.TextSize = 11
	tbl8.TextColor3 = color
	TextButton8 = fn2("TextButton", tbl8, { getUICorner(10), fn3(Color3.new(1, 0.84705883264541626, 0.36078432202339172), 1, 0.2) })
	n12 = n24 * 34579
	fn11(TextButton8, 0.2, 0.05)
	n13 = n242 * 43225
end

do
	local TextButton9 = fn2("TextButton", {
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
	}, { getUICorner(10), fn3(Color3.new(1, 0.84705883264541626, 0.36078432202339172), 1, 0.15) })

	fn11(TextButton9)

	local function fn13(arg, arg2)
		if flag2 then
			return
		end
		flag2 = true
		tbl6.v = true
		local nrTier

		if arg then
			if configMap[arg] then
				nrTier = arg
			else
				nrTier = "free"
			end
		else
			nrTier = "free"
		end

		local configEntry = configMap[nrTier]
		local flag3 = nrTier ~= "free"
		getgenv().NR_TIER = nrTier
		local genv = getgenv()
		genv.NR_GOLD = nrTier == "gold" or nrTier == "lifetime"
		local tbl7 = { Frame7, TextButton4, TextButton5, TextButton6, Frame9, TextButton8, TextButton9 }

		for _, v5 in ipairs(tbl7) do
			TweenService:Create(v5, configEntry, { BackgroundTransparency = 1 }):Play()
			local uiStroke = v5:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				TweenService:Create(uiStroke, configEntry, { Transparency = 1 }):Play()
			end

			if v5:IsA("TextButton") then
				TweenService:Create(v5, configEntry, { TextTransparency = 1 }):Play()
			end
		end

		TweenService:Create(TextBox, configEntry, { TextTransparency = 1 }):Play()
		TweenService:Create(TextBox2, configEntry, { TextTransparency = 1 }):Play()
		local v5, v6

		local function fn14()
			for _, v7 in ipairs(tbl7) do
				if v7.Parent then
					v7.Visible = false
				end
			end

			if flag3 then
				TextLabel4.Text = configEntry.label
				TextLabel4.TextColor3 = configEntry.color
				Frame8.UIStroke.Color = configEntry.color
				Frame8.Visible = true
				TweenService:Create(fn2("UIScale", { Parent = Frame8, Scale = 0.8 }), tweenInfo3, { Scale = 1 }):Play()

				if nrTier == "lifetime" then
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
			TweenService:Create(TextButton7, flag3, { BackgroundTransparency = 0.1 }):Play()
			TweenService:Create(TextButton7.UIStroke, flag3, { Transparency = 0.15 }):Play()

			while true do
			end
		end

		task.delay(0.18, fn14)

		if flag3 then
			tbl5.home = configEntry.label
			tbl5.games = configEntry.label
			arg.Text = configEntry.label
			TweenService:Create(arg, configEntry, { TextColor3 = configEntry.color }):Play()

			if arg2 and arg2 - os.time() < n10 then
				TextLabel5.Visible = true

				task.spawn(function()
					while TextLabel5.Visible do
						if TextLabel5.Parent then
							local n14 = arg2 - os.time()

							if not (n14 <= 0) then
								TextLabel5.Text = fn12(n14)
								local TextLabel6 = TextLabel5
								local danger

								if n14 < 3600 then
									danger = tbl4.Danger or tbl4.SubText
								else
									danger = tbl4.SubText
									TextLabel6.TextColor3 = danger
									task.wait(30)
									continue
								end

								TextLabel6.TextColor3 = danger
								task.wait(30)
								continue
							end

							TextLabel5.Text = "Key expired — grab a new one"
							TextLabel5.TextColor3 = tbl4.Danger
							return
						end

						break
					end
				end)
			end
		elseif arg2 and arg2 - os.time() < n10 then
			TextLabel5.Visible = true

			task.spawn(function()
				while TextLabel5.Visible do
					if TextLabel5.Parent then
						local n14 = arg2 - os.time()

						if not (n14 <= 0) then
							TextLabel5.Text = fn12(n14)
							local TextLabel6 = TextLabel5
							local danger

							if n14 < 3600 then
								danger = tbl4.Danger or tbl4.SubText
							else
								danger = tbl4.SubText
								TextLabel6.TextColor3 = danger
								task.wait(30)
								continue
							end

							TextLabel6.TextColor3 = danger
							task.wait(30)
							continue
						end

						TextLabel5.Text = "Key expired — grab a new one"
						TextLabel5.TextColor3 = tbl4.Danger
						return
					end

					break
				end
			end)
		end

		if str ~= "home" then
			fn6("home")
		end

		fn4(configEntry.toast)
	end

	local flag3 = false

	local function fn14(arg, arg2, arg3, arg4, arg5, text, arg6)
		local n14 = 165333668

		local function fn15(...)
			if not flag2 and not flag3 then
				local v5 = arg

				if bit32.bxor(v5, 428331801) ~= 142473909 then
					v5 = bit32.bxor(v5, 630834127)
				end

				local text2 = v5.Text
				flag3 = true
				arg3.Text = "CHECKING..."

				task.spawn(function()
					local ok, result, result2, result3 = pcall(fn9, text2, arg5)
					flag3 = false
					arg3.Text = text

					if ok then
						if result then
							fn13(result2, result3)
							return
						end
						local position = arg2.Position

						for i = 1, 4 do
							local arg22 = arg2
							local uDim2FromOffset = UDim2.fromOffset
							local n15

							if i % 2 == 0 then
								n15 = 5
							else
								n15 = -5
							end

							arg22.Position = position + uDim2FromOffset(n15, 0)
							task.wait(0.04)
						end

						arg2.Position = position
						TweenService:Create(arg2.UIStroke, result3, { Color = tbl4.Danger, Transparency = 0.1 }):Play()
						local n15 = 102754315

						local function fn16()
							if n15 ~= 276785316 then
								n15 = bit32.bxor(n15, 1428776417)
							end

							TweenService:Create(arg2.UIStroke, result3, { Color = arg6, Transparency = 0.2 }):Play()
						end

						n15 = 276785316
						task.delay(0.8, fn16)
						fn4(result2 or "Invalid key.", true, 4)
						return
					end

					pcall(rconsoleerr, "[NRL] validateKey crash: " .. tostring(result) .. "\n")
					fn4("Key check crashed: " .. tostring(result), true, 10)
				end, ...)

				return
			end
		end

		n14 = 301607340
		return fn15
	end

	local v5 = fn14(TextBox, Frame7, TextButton5, n12 + 54569172, "free", "CHECK KEY", tbl4.Border)
	local v6 = fn14(TextBox2, Frame9, TextButton9, 54569172, "gold", "CHECK KEY", Color3.new(1, 0.84705883264541626, 0.36078432202339172))
	TextButton5.MouseButton1Click:Connect(v5)

	TextBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			v5()
			return
		end
	end)

	TextButton9.MouseButton1Click:Connect(v6)

	TextBox2.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			v6()
			return
		end
	end)

	TextButton6.MouseButton1Click:Connect(function()
		fn6("gold")
	end)

	TextButton4.MouseButton1Click:Connect(function()
		if flag2 then
			return
		end
		local ok = pcall(setclipboard, "https://www.nrlscript.com/key")
		local str2

		if ok then
			str2 = "Key page copied — open it in your browser: " .. keyUrl or "Open this in your browser: " .. keyUrl
		else
			str2 = "Open this in your browser: " .. keyUrl
			fn4(str2, not ok, 8)
			return
		end

		fn4(str2, not ok, 8)
	end)

	TextButton8.MouseButton1Click:Connect(function()
		if flag2 then
			return
		end
		local ok = pcall(setclipboard, "https://discord.gg/vrzg9YaNPj")
		local str2

		if ok then
			str2 = "Discord invite copied — join to get Gold key."
		else
			str2 = "Join Discord: " .. vrzg9YaNPjUrl
		end

		fn4(str2, not ok)
	end)

	task.spawn(function()
		local v7 = fn8()

		if v7 then
			local v8, v9, v10 = fn10(v7)

			if v8 then
				getgenv().SCRIPT_KEY = v7
				fn13(v9, v10)
				fn7(v7, v9, v10)
				return
			end

			if v9 == "Invalid key" then
				pcall(delfile, "nr_loader_key.txt")
				return
			end
		end
	end)

	TextButton3.MouseButton1Click:Connect(function()
		local n14 = 913867998
		local n15 = 3190641505

		if flag2 then
			pcall(delfile, "nr_loader_key.txt")
			getgenv().SCRIPT_KEY = nil
			getgenv().NR_TIER = nil
			getgenv().NR_GOLD = nil
			local n16 = n14 // n15
			flag2 = false
			tbl6.v = false

			if str ~= "home" then
				fn6("home")
			end

			TextButton3.Visible = false
			Frame8.Visible = false
			TextLabel5.Visible = false
			TweenService:Create(TextButton7, tweenInfo, { BackgroundTransparency = 1, TextTransparency = 1 }):Play()
			TweenService:Create(TextButton7.UIStroke, tweenInfo, { Transparency = 1 }):Play()
			local n17 = n16 - 4068920330

			local function fn15()
				local TextButton10 = TextButton7

				if bit32.bxor(n17, 366569084) ~= 78120299 then
					n17 = bit32.bxor(n17, 3139527465)
				end

				if TextButton10.Parent then
					TextButton7.Visible = false
					return
				end
			end

			n17 = 292643607
			task.delay(0.18, fn15)
			tbl5.home = home
			tbl5.games = "Choose a game"
			TextLabel2.Text = home
			TweenService:Create(TextLabel2, tweenInfo, { TextColor3 = tbl4.SubText }):Play()
			TextBox.Text = ""
			TextBox2.Text = ""

			for _, v7 in ipairs({
				{ o = Frame7, bg = backgroundTransparency, stroke = 0.2 },
				{ o = TextButton4, bg = backgroundTransparency, stroke = 0.2, text = true },
				{ o = TextButton5, bg = 0.1, stroke = 0.15, text = true },
				{ o = TextButton6, bg = backgroundTransparency, stroke = 0.2, text = true },
				{ o = Frame9, bg = backgroundTransparency, stroke = 0.2 },
				{ o = TextButton8, bg = backgroundTransparency, stroke = 0.2, text = true },
				{ o = TextButton9, bg = 0.1, stroke = 0.15, text = true },
			}) do
				v7.o.Visible = v7.o ~= TextButton6 or false
				TweenService:Create(v7.o, tweenInfo, { BackgroundTransparency = v7.bg }):Play()
				local uiStroke = v7.o:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					TweenService:Create(uiStroke, tweenInfo, { Transparency = v7.stroke }):Play()
				end

				if v7.text and v7.o:IsA("TextButton") then
					TweenService:Create(v7.o, tweenInfo, { TextTransparency = 0 }):Play()
				end
			end

			TweenService:Create(TextBox, tweenInfo, { TextTransparency = 0 }):Play()
			TweenService:Create(TextBox2, tweenInfo, { TextTransparency = 0 }):Play()
			fn4("Key logged out — paste a new key to switch.")
			return
		end
	end)
end

local flag3, n14, ScrollingFrame, str2, str3, flag4

do
	local n122 = bit32.band(n12, n13)
	local n15 = n13 + n122

	local tbl7 = {
		Parent = Frame4,
		Size = UDim2.new(1, -80, 0, 18),
		Position = UDim2.new(0, 40, 0, 240),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Font = Enum.Font.Gotham,
		Text = "Need help? discord.gg/vrzg9YaNPj — click to copy",
		TextSize = 10,
		TextColor3 = tbl4.Accent,
	}

	fn2("TextButton", tbl7).MouseButton1Click:Connect(function()
		local ok = pcall(setclipboard, "https://discord.gg/vrzg9YaNPj")
		local str4

		if ok then
			str4 = "Invite link copied to clipboard"
		else
			str4 = "setclipboard unavailable"
		end

		fn4(str4, not ok)
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

	local function fn13()
		local n16 = 152732062

		local function fn14()
			local v5 = identifyexecutor
			if bit32.bxor(n16, 114914498) ~= 314880253 then
				n16 = bit32.bxor(n16, 888543741)
				return v5()
			end
			return v5()
		end

		n16 = 337495103
		local ok, result = pcall(fn14)
		if ok and result then
			return result
		end
		return "Volt"
	end

	local v5 = fn13(n15 - 3810238358)
	textLabel.Text = format("%d scripts available  |  %s", #tbl2, v5)
	textLabel.TextColor3 = tbl4.SubText
	textLabel.TextSize = 10
	textLabel.TextXAlignment = Enum.TextXAlignment.Center
	fn2("TextLabel", textLabel)
	flag3 = true

	task.spawn(function()
		while flag3 do
			TweenService:Create(UIStroke, TweenInfo.new(1.1, Enum.EasingStyle.Sine), { Transparency = 0.85 }):Play()
			task.wait(1.15)

			if flag3 then
				TweenService:Create(UIStroke, TweenInfo.new(1.1, Enum.EasingStyle.Sine), { Transparency = 0.45 }):Play()
				task.wait(1.15)
				continue
			end

			break
		end
	end)

	n14 = n122 * n15 - n15

	ScrollingFrame = fn2("ScrollingFrame", {
		Parent = Frame6,
		Size = UDim2.new(1, -20, 1, -12),
		Position = UDim2.new(0, 10, 0, 6),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = tbl4.Border,
		ScrollBarImageTransparency = 0.3,
	})

	local n152 = bit32.band(n15, n11)
	fn2("UIListLayout", { Parent = ScrollingFrame, Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder })

	fn2("UIPadding", {
		Parent = ScrollingFrame,
		PaddingTop = UDim.new(0, 4),
		PaddingBottom = UDim.new(0, 6),
		PaddingLeft = UDim.new(0, 2),
		PaddingRight = UDim.new(0, 6),
	})

	str2 = ""
	str3 = ""
	flag4 = false
	local tbl8 = {}

	-- This Source Was Generated by discord.gg/c3xVMnUUBv
	local function fn14()
		for _, v6 in ipairs(tbl8) do
			task.spawn(v6, str2, str3)
		end
	end

	local function fn15(arg)
		if flag4 then
			task.spawn(arg, str2, str3)
		end

		local insert = table.insert
		insert(tbl8, arg)
	end

	local n16 = n152 + 254071946

	local function fn16(arg, arg2, arg3)
		if arg and arg.match and #arg.match ~= 0 then
			local str4 = (arg2 or ""):lower()
			local str5 = (arg3 or ""):lower()
			local v6 = ipairs
			local n162, flag5, v7

			if n16 ~= 382946598 then
				n162, flag5, v7 = v6(arg.match)
			else
				n162 = bit32.bxor(n16, 3282889763)
				flag5 = n16 + 67944929 ~= 270464497

				if nil <= nil then
					n162, flag5, v7 = v6(arg.match)
				end
			end

			for _, v8 in n162, flag5, v7 do
				local str6 = v8:lower()
				if str4 ~= "" and str4:find(str6, 1, true) then
					return true
				end

				if str5 ~= "" and str5:find(str6, 1, true) then
					return true
				end
			end
		end

		return false
	end

	task.spawn(function()
		for i = 1, 5 do
			local n17 = 225940537

			local function fn17()
				if n17 ~= 451973260 then
					n17 = bit32.bxor(n17, 2287805977)
				end

				return MarketplaceService:GetProductInfo(game.PlaceId)
			end

			n17 = 451973260
			local ok, result = pcall(fn17)

			if ok then
				if result then
					if type(result.Name) ~= "string" then
						task.wait(i * 0.4)
					elseif result.Name ~= "" then
						str2 = result.Name
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

		local n17 = 100655444

		local function fn17()
			local function fn18(arg)
				local response

				if typeof(httpRequest) == "function" then
					response = httpRequest({ Url = arg, Method = "GET" })
					if response and response.Body then
						return response.Body
					end
				end

				if typeof(request) == "function" then
					response = request({ Url = arg, Method = "GET" })
					if response and response.Body then
						return response.Body
					end
				end

				while true do
					if game.HttpGet then
						local v6 = pcall
						local httpGet = game.HttpGet
						local gameRef = game
						response = not not arg

						if response then
							local v7, v8 = v6(httpGet, gameRef, arg, true)
							if v7 and v8 then
								return v8
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

			if bit32.bxor(n17, 477423004) ~= 304635019 then
				n17 = bit32.bxor(n17, 1521049049)
			end

			if game.GameId and game.GameId ~= 0 then
				local v6 = fn18("https://games.roblox.com/v1/games?universeIds=" .. tostring(game.GameId))

				if v6 and type(v6) == "string" then
					local match = v6:match("\"name\"%s*:%s*\"([^\"]+)\"")
					if match then
						str3 = match
						return
					end
				end
			end
		end

		n17 = 240957719
		pcall(fn17)

		if str2 == "" and type(game.Name) == "string" and game.Name ~= "" and game.Name ~= "Game" then
			str2 = game.Name
		end

		flag4 = true
		local name

		if str2 ~= "" then
			name = str2

			if not str2 then
				if str3 ~= "" then
					name = str3 or ""
				else
					name = ""
				end
			end
		elseif str3 ~= "" then
			name = str3 or ""
		else
			name = ""
		end

		local TextLabel6 = TextLabel3
		local text

		if name ~= "" then
			text = "In game: " .. name or "Game not identified"
		else
			text = "Game not identified"
			TextLabel6.Text = text
			fn14()
			return
		end

		TextLabel6.Text = text
		fn14()
	end)

	local flag5 = false

	local function fn17()
		local nrTier = getgenv().NR_TIER

		if nrTier ~= "gold" and nrTier ~= "premium" and nrTier ~= "lifetime" then
			local ok, result = pcall(readfile, "nr_loader_key.txt")

			if ok and type(result) == "string" and result ~= "" then
				local parts = result:split("|")
				local str4

				if parts[3] then
					str4 = parts[3]:lower()

					if str4 then
						if str4 ~= "gold" and str4 ~= "premium" and str4 ~= "lifetime" then
							return false
						end
						return true
					end
				end

				str4 = ""
				if str4 == "premium" then
					return true
				end

				if str4 == "lifetime" then
					return true
				end
			end

			return false
		end

		return true
	end

	local function fn18(arg, arg2, arg3)
		task.spawn(function()
			local n17 = 2922779251
			if arg.delayed then
				arg3(false, "Delayed", "This script is currently under maintenance / repair.")
				return
			end

			if arg.premiumOnly then
				if not fn17() then
					arg3(false, "Premium Only", arg.name .. " khusus member Premium / Gold / Lifetime!")
					return
				end
				n17 = 2922779251
			end

			arg2("Fetching...")
			local n18 = 21514261

			local function fn19()
				local gameRef = game

				if bit32.bxor(n18, 406709984) == 159080375 then
					n18 = bit32.bxor(n18, 4107919673)
				end

				return gameRef:HttpGet(arg.url, true)
			end

			n18 = 522309152
			local ok, result = pcall(fn19)

			if ok and type(result) == "string" and result ~= "" then
				if not result:sub(1, 15):lower():find("<!doctype") and not result:lower():find("^404: not found") then
					arg2("Loading...")

					if arg.genv then
						local genv = getgenv()

						for k, v6 in pairs(arg.genv) do
							if k ~= "SCRIPT_KEY" then
								genv[k] = v6
							elseif not flag2 then
								genv[k] = v6
							end
						end
					end

					local v6 = fn8()

					if v6 and getgenv().SCRIPT_KEY == nil then
						getgenv().SCRIPT_KEY = v6
					end

					local chunk, loadErr = loadstring(result, "@" .. arg.name)
					if not chunk then
						arg3(false, "Compile error", ("loadstring: %s"):format(tostring(loadErr)))
						return
					end
					arg3(true, "Loaded", ("%s loaded."):format(arg.name))

					if readJsonFile() and queueOnTeleport then
						pcall(queueOnTeleport, "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua\"))()")
					end

					local n19 = 235668477

					local function fn20()
						local ok2, result2 = pcall(chunk)

						if n19 + 155233870 ~= 187571276 then
							if ok2 then
								return
							end
						else
							n19 = bit32.bxor(n19, 2767411019)
							if ok2 then
								return
							end
						end

						warn(("[NRL] %s runtime error: %s"):format(arg.name, tostring(result2)))
					end

					n19 = 267790901
					task.spawn(fn20)
					return
				end

				arg3(false, "Bad URL", ("%s returned a web page, not Lua. The raw link is wrong or the file is missing."):format(arg.name))
				return
			end

			arg3(false, "Fetch failed", ("HttpGet failed for %s — check the raw URL or your connection."):format(arg.name))
		end)
	end

	local function fn19(arg, arg2, arg3, arg4)
		if flag5 then
			return
		end
		flag5 = true
		arg3.Text = "Fetching..."
		arg3.TextColor3 = tbl4.SubText
		arg4.Visible = true
		local flag6 = true

		task.spawn(function()
			while flag6 do
				if arg4.Parent then
					arg4.Rotation = (arg4.Rotation + 6) % 360
					RunService.Heartbeat:Wait()
					continue
				end

				break
			end
		end)

		local function fn20(arg5, text)
			flag6 = false
			arg4.Visible = false
			arg3.Text = text
			local arg32 = arg3
			local accent

			if arg5 then
				accent = tbl4.Accent or tbl4.Danger
			else
				accent = tbl4.Danger
			end

			arg32.TextColor3 = accent
			local TweenService2 = TweenService
			local create = TweenService.Create
			local uiStroke = arg2.UIStroke
			local allowedProps = {}
			local accent2

			if arg5 then
				accent2 = tbl4.Accent or tbl4.Danger
			else
				accent2 = tbl4.Danger
				allowedProps.Color = accent2
				allowedProps.Transparency = 0.1
				local v6 = create(TweenService2, uiStroke, tweenInfo, allowedProps)
				v6:Play()
				flag5 = false
				return
			end

			allowedProps.Color = accent2
			allowedProps.Transparency = 0.1
			create(TweenService2, uiStroke, tweenInfo, allowedProps):Play()
			flag5 = false
		end

		fn18(arg, function(text)
			arg3.Text = text
		end, function(arg5, arg6, arg7)
			arg5(arg5, arg6)
			fn4(arg7, not arg5, 8)

			if arg5 then
				task.delay(0.6, function()
					TweenService:Create(Frame, tweenInfo4, { BackgroundTransparency = 1 }):Play()
					TweenService:Create(arg5, tweenInfo4, { Scale = arg5.Scale * 0.92 }):Play()
					task.wait(0.32)
					flag3 = false
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

	local function fn20()
		for _, v6 in ipairs(list) do
			pcall(v6)
		end
	end

	n16 = bit32.bxor(n16, 286808282)

	local function fn21(arg, arg2, arg3)
		local n17 = 178670851
		local n18 = 1134156754
		local flag6 = arg.premiumOnly == true
		local color2, n19

		if flag6 then
			color2 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

			if color then
				n19 = 0.35
			else
				color2 = tbl4.Border

				if flag6 then
					n19 = 0.35
				else
					n19 = 0.2
				end
			end
		else
			color2 = tbl4.Border

			if flag6 then
				n19 = 0.35
			else
				n19 = 0.2
			end
		end

		local n20 = n17 // n18

		local TextButton9 = fn2("TextButton", {
			Parent = ScrollingFrame,
			LayoutOrder = arg3,
			Size = UDim2.new(1, 0, 0, 58),
			BackgroundColor3 = tbl4.Control,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "",
		}, { getUICorner(10), fn3(color2, 1, n19) })

		fn2("ImageLabel", {
			Parent = TextButton9,
			Size = UDim2.new(0, 34, 0, 34),
			Position = UDim2.new(0, 12, 0.5, -17),
			BackgroundColor3 = tbl4.Panel,
			BackgroundTransparency = 0.3,
			Image = arg.icon,
		}, { getUICorner(8) })

		local tbl9 = {
			Parent = TextButton9,
			Size = UDim2.new(1, -205, 0, 16),
			Position = UDim2.new(0, 56, 0, 10),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = arg.name,
		}

		local color3

		if flag6 then
			color3 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

			if not color then
				color3 = tbl4.Text
			end
		else
			color3 = tbl4.Text
		end

		tbl9.TextColor3 = color3
		tbl9.TextSize = 13
		tbl9.TextXAlignment = Enum.TextXAlignment.Left
		tbl9.TextTruncate = Enum.TextTruncate.AtEnd
		fn2("TextLabel", tbl9)
		local n21 = 447444964

		local tbl10 = {
			Parent = TextButton9,
			Size = UDim2.new(1, -205, 0, 14),
			Position = UDim2.new(0, 56, 0, 28),
			BackgroundTransparency = 1,
			Font = Enum.Font.Gotham,
			Text = arg.desc,
		}

		tbl10.TextColor3 = tbl4.SubText
		tbl10.TextSize = 11
		tbl10.TextXAlignment = Enum.TextXAlignment.Left
		tbl10.TextTruncate = Enum.TextTruncate.AtEnd
		fn2("TextLabel", tbl10)
		local flag7 = arg.delayed == true

		local textLabel2 = {
			Parent = TextButton9,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -26, 0, 10),
			Size = UDim2.new(0, 116, 0, 16),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
		}

		local text

		if flag7 then
			text = "● DELAYED"
		elseif flag6 then
			text = "★ PREMIUM ONLY"
		else
			text = ""
		end

		textLabel2.Text = text
		local danger

		if flag7 then
			danger = tbl4.Danger

			if not danger then
				if flag6 then
					danger = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

					if not color then
						danger = tbl4.SubText
						n20 = n20 - n21 - 3847522332
					end
				else
					danger = tbl4.SubText
					n20 = n20 - n21 - 3847522332
				end
			end
		elseif flag6 then
			danger = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

			if not color then
				danger = tbl4.SubText
				n20 = n20 - n21 - 3847522332
			end
		else
			danger = tbl4.SubText
			n20 = n20 - n21 - 3847522332
		end

		textLabel2.TextColor3 = danger
		textLabel2.TextSize = 9.5
		textLabel2.TextXAlignment = Enum.TextXAlignment.Right
		local TextLabel6 = fn2("TextLabel", textLabel2)

		local ImageLabel2 = fn2("ImageLabel", {
			Parent = TextButton9,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0, 14, 0, 14),
			BackgroundTransparency = 1,
			Visible = false,
			Image = "rbxasset://textures/loading/robloxTiltRight.png",
			ImageColor3 = tbl4.Accent,
		})

		local n22 = n20 + n21

		local TextLabel7 = fn2("TextLabel", {
			Parent = TextButton9,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -12, 0.5, 0),
			Size = UDim2.new(0, 10, 0, 16),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			Text = ">",
			TextColor3 = tbl4.SubText,
			TextSize = 12,
		})

		local border = tbl4.Border

		local TextButton10 = fn2("TextButton", {
			Parent = TextButton9,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -26, 0, 31),
			Size = UDim2.new(0, 116, 0, 20),
			BackgroundColor3 = tbl4.Control,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Text = "⚡ Auto Execute: OFF",
			Font = Enum.Font.Gotham,
			TextSize = 8.5,
			TextColor3 = tbl4.SubText,
		}, { getUICorner(6), fn3(border, 1) })

		local function fn22()
			local jsonFile = readJsonFile()

			if jsonFile and jsonFile.gameName == arg.name then
				local n23 = math.max(1, math.ceil((jsonFile.expiresAt - os.time()) / 3600))
				TextButton10.BackgroundColor3 = tbl4.AccentDim
				TextButton10.BackgroundTransparency = 0.1
				TextButton10.Text = ("⚡ Auto Execute: %dh"):format(n23)
				TextButton10.TextColor3 = Color3.new(1, 1, 1)
				local TextButton11 = TextButton10
				local font = Enum.Font
				TextButton11.Font = font.GothamBold
				TextButton10.UIStroke.Color = tbl4.Accent
				TextButton10.UIStroke.Transparency = 0.2
				return
			end

			TextButton10.BackgroundColor3 = tbl4.Control
			TextButton10.BackgroundTransparency = backgroundTransparency
			TextButton10.Text = "⚡ Auto Execute: OFF"
			TextButton10.TextColor3 = tbl4.SubText
			TextButton10.Font = Enum.Font.Gotham
			TextButton10.UIStroke.Color = tbl4.Border
			TextButton10.UIStroke.Transparency = 0.5
		end

		fn22()
		table.insert(list, fn22)
		local n23 = 0
		local mouseButton1Down = TextButton10.MouseButton1Down
		local mouseButton1Down2 = mouseButton1Down
		local connect = mouseButton1Down.Connect
		local n24 = n22 + 84920319

		local function fn23()
			local now = os.clock()

			if n24 ~= 30169862 then
				n24 = bit32.bxor(n24, 591718409)
			end

			n23 = now + 0.4
		end

		n24 = 30169862
		connect(mouseButton1Down2, fn23)

		TextButton10.MouseButton1Click:Connect(function()
			local jsonFile = readJsonFile()

			if jsonFile and jsonFile.gameName == arg.name then
				saveFile(nil)
				fn20()
				fn4("Auto Execute turned OFF for " .. arg.name)
				return
			end

			if arg.delayed then
				fn4("This script is currently under maintenance / repair.", true, 5)
				return
			end

			if flag6 and not fn17() then
				fn4("Khusus member Premium / Gold / Lifetime!", true, 5)
				return
			end
			pcall(setclipboard, "loadstring(game:HttpGet(\"https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua\"))()")
			fn4(("[Auto Exec: 24h] %s aktif! Link dicopy ke clipboard."):format(arg.name))
		end)

		local n25 = 179420946

		local function fn24(arg4, arg5)
			if TextButton9.Parent and fn16(arg, arg4, arg5) then
				local TextLabel8 = TextLabel6
				local text2

				if flag6 then
					text2 = "CURRENT (PREMIUM)"
				else
					text2 = "CURRENT GAME"
				end

				TextLabel8.Text = text2
				local TextLabel9 = TextLabel6
				local uiScale, TweenService2, create, uiStroke, allowedProps, color4, v6, n252

				if flag6 then
					local color5 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

					if color then
						TextLabel9.TextColor3 = color5
						TextButton9.LayoutOrder = -1
						uiScale = TextButton9:FindFirstChildOfClass("UIScale")

						if uiScale then
							uiScale.Scale = 0.97
							local tween = TweenService:Create(uiScale, flag6, { Scale = 1 })
							tween:Play()
						end

						TweenService2 = TweenService
						create = TweenService.Create
						uiStroke = TextButton9.UIStroke
						allowedProps = {}

						if flag6 then
							color4 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

							if color then
								allowedProps.Color = color4
								allowedProps.Transparency = 0.1
								v6 = create(TweenService2, uiStroke, n24, allowedProps)
								n252 = n25
								v6:Play()

								while true do
								end
							end
						end

						color4 = tbl4.AccentDim
						allowedProps.Color = color4
						allowedProps.Transparency = 0.1
						v6 = create(TweenService2, uiStroke, n24, allowedProps)
						n252 = n25
						v6:Play()

						while true do
						end
					end
				end

				TextLabel9.TextColor3 = tbl4.Accent
				TextButton9.LayoutOrder = -1
				uiScale = TextButton9:FindFirstChildOfClass("UIScale")

				if uiScale then
					uiScale.Scale = 0.97
					TweenService:Create(uiScale, flag6, { Scale = 1 }):Play()
				end

				TweenService2 = TweenService
				create = TweenService.Create
				uiStroke = TextButton9.UIStroke
				allowedProps = {}

				if flag6 then
					color4 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

					if color then
						allowedProps.Color = color4
						allowedProps.Transparency = 0.1
						v6 = create(TweenService2, uiStroke, n24, allowedProps)
						n252 = n25
						v6:Play()

						while true do
						end
					end
				end

				allowedProps.Color = tbl4.AccentDim
				allowedProps.Transparency = 0.1
				v6 = create(TweenService2, uiStroke, n24, allowedProps)
				n252 = n25
				v6:Play()

				while true do
				end
			end
		end

		n25 = 377145784
		fn15(fn24)
		local UIScale2 = fn2("UIScale", { Parent = TextButton9 })
		local mouseEnter = TextButton9.MouseEnter
		local mouseEnter2 = mouseEnter
		local connect2 = mouseEnter.Connect
		local n26 = n22 - 4258339010

		local function fn25()
			TweenService:Create(TextButton9, n24, { BackgroundTransparency = 0.05 }):Play()

			if n26 + 220569372 == 279743517 then
				n26 = bit32.bxor(n26, 3556695743)
			end

			TweenService:Create(UIScale2, n24, { Scale = 1.015 }):Play()
			local TweenService2 = TweenService
			local create = TweenService.Create
			local tbl11 = {}
			local color4

			if flag6 then
				color4 = Color3.new(1, 0.84705883264541626, 0.36078432202339172)

				if not color then
					color4 = tbl4.Accent
				end
			else
				color4 = tbl4.Accent
				tbl11.TextColor3 = color4
				local v6 = create(TweenService2, TextLabel7, n24, tbl11)
				v6:Play()
				return
			end

			tbl11.TextColor3 = color4
			create(TweenService2, TextLabel7, n24, tbl11):Play()
		end

		n26 = 352978003
		connect2(mouseEnter2, fn25)
		local mouseLeave = TextButton9.MouseLeave
		local mouseLeave2 = mouseLeave
		local connect3 = mouseLeave.Connect
		local n27 = n22 - 339996067

		local function fn26()
			if bit32.bxor(n27, 283816386) ~= 462702415 then
				n27 = bit32.bxor(n27, 3452637031)
			end

			TweenService:Create(TextButton9, n24, { BackgroundTransparency = backgroundTransparency }):Play()
			TweenService:Create(UIScale2, n24, { Scale = 1 }):Play()
			TweenService:Create(TextLabel7, n24, { TextColor3 = tbl4.SubText }):Play()
		end

		n27 = 192870029
		connect3(mouseLeave2, fn26)

		TextButton9.MouseButton1Click:Connect(function()
			if not (os.clock() < n23) then
				if arg.delayed then
					fn4("This script is currently under maintenance / repair.", true, 5)
					return
				end

				if flag5 then
					fn4("Another script is still loading.", true, 3)
					return
				end

				if flag6 and not fn17() then
					fn4("Evomon Gold V4 khusus member Premium / Gold / Lifetime!", true, 5)
					return
				end
				TextLabel7.Visible = false
				fn19(arg, TextButton9, TextLabel6, ImageLabel2)
				return
			end
		end)

		TextButton9.BackgroundTransparency = 1
		UIScale2.Scale = 0.96

		task.delay(0.04 * arg3, function()
			if TextButton9.Parent then
				TweenService:Create(TextButton9, n24, { BackgroundTransparency = backgroundTransparency }):Play()
				TweenService:Create(UIScale2, flag6, { Scale = 1 }):Play()
				return
			end
		end)

		return TextButton9
	end

	for i, v6 in ipairs(tbl2) do
		fn21(v6, n14 + 269302503, i)
	end

	local function fn22()
		local n17 = 2961806243
		local n18 = 1208887655
		if not Frame.Visible then
			return
		end
		local list2 = {}

		for _, item in ipairs(tbl.items) do
			local v6 = fn(item)

			if v6 then
				list2[#list2 + 1] = v6
			end
		end

		if #list2 == 0 then
			print(("[NRL] whats-new: no catalog match for {%s} — check the names in WHATS_NEW.items"):format(table.concat(tbl.items, ", ")))
			return
		end
		local n19 = 46 + #list2 * 34 + 8 + 32
		local n20 = n19 + 14

		local TextButton9 = fn2("TextButton", {
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

		local tbl9 = {
			Parent = TextButton9,
			Active = true,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Size = UDim2.fromOffset(300, n20),
			BackgroundColor3 = tbl4.Window,
			BackgroundTransparency = 0.02,
			BorderSizePixel = 0,
		}

		tbl9.ZIndex = 51
		local accent = tbl4.Accent
		local Frame10 = tbl9("Frame", tbl9, { getUICorner(12), fn3(accent, 1, 0.25) })
		local accent2 = tbl4.Accent

		local tbl10 = {
			Parent = tbl9("Frame", {
				Parent = Frame10,
				Position = UDim2.new(0, 14, 0, 14),
				Size = UDim2.new(0, 42, 0, 16),
				BackgroundColor3 = tbl4.AccentDim,
				BorderSizePixel = 0,
				ZIndex = 52,
			}, { getUICorner(8), fn3(accent2, 1, 0.3) }),
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
		}

		local font = Enum.Font
		tbl10.Font = font.GothamBold
		tbl10.Text = "NEW"
		tbl10.TextSize = 9
		tbl10.TextColor3 = tbl4.Accent
		tbl10.ZIndex = 53
		tbl9("TextLabel", tbl10)

		local textLabel2 = {
			Parent = Frame10,
			Position = UDim2.new(0, 62, 0, 13),
			Size = UDim2.new(1, -100, 0, 18),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
		}

		local text

		if not (#list2 > 1) then
			text = "New Game Added"
		else
			text = "New Games Added"
		end

		textLabel2.Text = text
		textLabel2.TextColor3 = tbl4.Text
		textLabel2.TextSize = 14
		textLabel2.ZIndex = 52
		textLabel2.TextXAlignment = Enum.TextXAlignment.Left
		local textTruncate = Enum.TextTruncate
		textLabel2.TextTruncate = textTruncate.AtEnd
		tbl9("TextLabel", textLabel2)

		local tbl11 = {
			Parent = Frame10,
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -12, 0, 12),
			Size = UDim2.new(0, 20, 0, 20),
			BackgroundColor3 = tbl4.Control,
			BackgroundTransparency = backgroundTransparency,
			AutoButtonColor = false,
			Text = "x",
			Font = Enum.Font.GothamBold,
			TextSize = 12,
		}

		local tbl42 = tbl4
		tbl11.TextColor3 = tbl42.SubText
		tbl11.ZIndex = 52
		local TextButton10 = tbl9("TextButton", tbl11, { getUICorner(6) })
		fn5(TextButton10, tbl4.Danger)
		local tween, fn23

		for i, v6 in ipairs(list2) do
			local Frame11 = tbl9("Frame", {
				Parent = Frame10,
				Position = UDim2.fromOffset(14, 46 + (i - 1) * 34),
				Size = UDim2.new(1, -28, 0, 30),
				BackgroundColor3 = tbl4.Control,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 52,
			}, { getUICorner(8) })

			tbl9("ImageLabel", {
				Parent = Frame11,
				Size = UDim2.new(0, 24, 0, 24),
				Position = UDim2.new(0, 8, 0.5, -12),
				BackgroundColor3 = tbl4.Panel,
				BackgroundTransparency = 0.3,
				Image = v6.icon,
				ZIndex = 53,
			}, { getUICorner(6) })

			tbl9("TextLabel", {
				Parent = Frame11,
				Position = UDim2.new(0, 40, 0, 3),
				Size = UDim2.new(1, -50, 0, 13),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamBold,
				Text = v6.name,
				TextColor3 = tbl4.Text,
				TextSize = 12,
				ZIndex = 53,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			})

			tbl9("TextLabel", {
				Parent = Frame11,
				Position = UDim2.new(0, 40, 0, 16),
				Size = UDim2.new(1, -50, 0, 12),
				BackgroundTransparency = 1,
				Font = Enum.Font.Gotham,
				Text = v6.desc,
				TextColor3 = tbl4.SubText,
				TextSize = 10,
				ZIndex = 53,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextTruncate = Enum.TextTruncate.AtEnd,
			})

			local n21 = n17 + 234209498

			fn23 = function()
				local Frame12 = Frame11

				if n21 + 41790811 ~= 398591706 then
					n21 = bit32.bxor(n21, 2983333227)
				end

				if Frame12.Parent then
					TweenService:Create(Frame11, tween, { BackgroundTransparency = backgroundTransparency }):Play()
					return
				end
			end

			n21 = 356800895
			task.delay(0.05 * i, fn23)
		end

		local tbl12 = {
			Parent = Frame10,
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, -14),
			Size = UDim2.new(1, -28, 0, 32),
			BackgroundColor3 = tbl4.AccentDim,
			BackgroundTransparency = 0.1,
			BorderSizePixel = 0,
			AutoButtonColor = false,
			Font = Enum.Font.GothamBold,
			Text = "GOT IT",
			TextSize = 12,
		}

		local tbl43 = tbl4

		if n17 + 62417772 ~= 62417772 then
			local n172 = bit32.band(bit32.rshift(n17, 29), 7)
			local n173 = bit32.band(bit32.bxor(n17, n172), 536870911)
			local v6 = bit32.bxor(208594413, n173)
			local v62 = bit32.lshift(v6, 13)
			local v63 = bit32.band(bit32.bxor(v6, v62), 536870911)
			local v632 = bit32.rshift(v63, 13)
			local v633 = bit32.bxor(v63, v632)
			local v6332 = bit32.lshift(v633, 14)
			local v6333 = bit32.band(bit32.bxor(v633, v6332), 536870911)
			local v63332 = bit32.lshift(v6333, 13)
			local v63333 = bit32.band(bit32.bxor(v6333, v63332), 536870911)
			local v633332 = bit32.rshift(v63333, 13)
			local v633333 = bit32.bxor(v63333, v633332)
			local v6333332 = bit32.lshift(v633333, 14)
			local v6333333 = bit32.band(bit32.bxor(v633333, v6333332), 536870911)
			local v63333332 = bit32.lshift(v6333333, 13)
			local v63333333 = bit32.band(bit32.bxor(v6333333, v63333332), 536870911)
			local v633333332 = bit32.rshift(v63333333, 13)
			local v633333333 = bit32.bxor(v63333333, v633333332)
			local v6333333332 = bit32.lshift(v633333333, 14)
			local v6333333333 = bit32.band(bit32.bxor(v633333333, v6333333332), 536870911)
			local v63333333332 = bit32.lshift(v6333333333, 13)
			local v63333333333 = bit32.band(bit32.bxor(v6333333333, v63333333332), 536870911)
			local v633333333332 = bit32.rshift(v63333333333, 13)
			local v633333333333 = bit32.bxor(v63333333333, v633333333332)
			local v6333333333332 = bit32.lshift(v633333333333, 14)
			local v6333333333333 = bit32.band(bit32.bxor(v633333333333, v6333333333332), 536870911)
			local v63333333333332 = table.pack(bit32.lshift(v6333333333333, 13))
		end

		tbl12.TextColor3 = tbl43.Text
		tbl12.ZIndex = 52
		local accent3 = tbl4.Accent
		local TextButton11 = tbl9("TextButton", tbl12, { getUICorner(9), fn3(accent3, 1, 0.2) })

		if n18 + 358666450 == 358666456 then
			fn11(TextButton11)
			local UIScale2 = tbl9("UIScale", { Parent = Frame10, Scale = 0.9 })

			if n18 ~= 70470227 then
				Frame10.BackgroundTransparency = 1
				Frame10.UIStroke.Transparency = 1
				TweenService:Create(TextButton9, fn23, { BackgroundTransparency = 0.45 }):Play()
				tween = TweenService:Create(UIScale2, tbl11, { Scale = 1 })
				tween:Play()
				TweenService:Create(Frame10, fn23, { BackgroundTransparency = 0.02 }):Play()
				TweenService:Create(Frame10.UIStroke, fn23, { Transparency = 0.25 }):Play()
				local flag6 = false

				local function fn24()
					if flag6 then
						return
					end
					flag6 = true
					TweenService:Create(TextButton9, fn23, { BackgroundTransparency = 1 }):Play()
					TweenService:Create(UIScale2, fn23, { Scale = 0.92 }):Play()
					TweenService:Create(Frame10, fn23, { BackgroundTransparency = 1 }):Play()
					TweenService:Create(Frame10.UIStroke, fn23, { Transparency = 1 }):Play()

					for _, descendant in ipairs(Frame10:GetDescendants()) do
						local tween2

						if descendant:IsA("TextLabel") then
							tween2 = TweenService:Create(descendant, fn23, { TextTransparency = 1 })
							tween2:Play()
						elseif descendant:IsA("TextButton") then
							tween2 = TweenService:Create(descendant, fn23, { TextTransparency = 1 })
							tween2:Play()
						end

						local tween3

						if descendant:IsA("Frame") then
							tween3 = TweenService:Create(descendant, fn23, { BackgroundTransparency = 1 })
							tween3:Play()
						elseif descendant:IsA("ImageLabel") then
							tween3 = TweenService:Create(descendant, fn23, { BackgroundTransparency = 1 })
							tween3:Play()
						end

						if descendant:IsA("ImageLabel") then
							TweenService:Create(descendant, fn23, { ImageTransparency = 1 }):Play()
						end

						if descendant:IsA("UIStroke") then
							TweenService:Create(descendant, fn23, { Transparency = 1 }):Play()
						end
					end

					local n21 = 25351274

					local function destroyAll()
						local TextButton12 = TextButton9

						if n21 == 18717777 then
							n21 = bit32.bxor(n21, 3473670903)
						end

						if TextButton12.Parent then
							TextButton9:Destroy()
							return
						end
					end

					n21 = 394384446
					task.delay(0.34, destroyAll)
				end

				TextButton11.MouseButton1Click:Connect(fn24)
				TextButton10.MouseButton1Click:Connect(fn24)
				return
			end

			local n182 = bit32.band(bit32.rshift(n18, 29), 7)
			local n183 = bit32.band(bit32.bxor(n18, n182), 536870911)
			local v6 = bit32.bxor(120745192, n183)
			local v62 = table.pack(bit32.lshift(v6, 13))

			while true do
			end
		else
			while true do
			end
		end
	end

	print(("[NRL] whats-new: showing %d item(s)"):format(#tbl.items))
	local n17 = 20

	local function fn23(arg)
		local jsonFile = readJsonFile()

		if jsonFile and jsonFile.gameName then
			local v6 = fn(jsonFile.gameName)

			if v6 then
				math.max(1, math.ceil((jsonFile.expiresAt - os.time()) / 3600))
				local n18 = 204307130

				local function fn24()
					local now = os.clock()

					while true do
						if fn16(v6, str2, str3) then
							if v6.premiumOnly and not fn17() then
								saveFile(nil)
								Frame.Visible = true
								fn4("Auto Execute dibatalkan: " .. v6.name .. " khusus member Premium / Gold / Lifetime!", true, 6)
								arg()
								return
							end

							local whatsNew = Frame:FindFirstChild("WhatsNew")

							if whatsNew then
								whatsNew:Destroy()
							end

							Frame.Visible = false
							local tbl9 = {}
							if n18 == 98192377 then
								continue
							end
							tbl9.Parent = ScreenGui
							tbl9.Active = true
							tbl9.AnchorPoint = Vector2.new(0.5, 0)
							tbl9.Position = UDim2.new(0.5, 0, 0, 24)
							tbl9.Size = UDim2.new(0, 360, 0, 62)

							while true do
							end
						else
							if flag4 then
								break
							end

							if not (n17 < os.clock() - now) then
								task.wait(0.1)
								continue
							end
							break
						end
					end

					print(("[NRL] auto-exec: %s tidak cocok dengan place=%q universe=%q"):format(v6.name, str2, str3))
					arg()
				end

				n18 = 191084961
				task.spawn(fn24)
				return true
			end
		end

		return false
	end

	local function fn24()
		task.delay(0.35, fn22)
	end

	if not fn23(fn24) then
		fn24()
	end
end

local function destroyAll()
	flag3 = false
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

fn4("Nasi Rendang loader ready. Pick a game.")
print("Deobf By Zed")
