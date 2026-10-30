local state
state = 1
local chilliGithubFastManualDefaultsRu, cleanup, animals, result, mutations, result2, color, color2, frame, flag
local flag2, n, flag3, v, v2, v3, v4, jumpBoostSection, characterSection, invisibilitySection
local n2, n3, adjustToolSpeedSlider, flag4, flag5, connection, v5, connection2, connection3, connection4
local connection5, connection6, flag6, flag7, flag8, n4, flag9, v6, beamMap, descendantMap
local v7, connection7, raycastParams, parent, fn, isTool, fn2, v8, fn3, fn4
local fn5, fn6, runUntilTimeout, fn7, fn8, fn9, fn10, fn11, fn12, fn13
local fn14, fn15, fn16, fn17, fn18, fn19, flag10, result3, v9, v10
local v11, v12, v13, v14, v15, v16, v17, v18, v19, v20
local v21, v22, flag11, flag12, cleanup2, cleanup3, brainrotEspSection, brainrotNotificationsSection, ok, result4
local torsoList, font, font2, v23, clamp, num, n5, n6, v24, font3
local ok2, result5, ok3, result6, ok4, result7, ok5, result8, ok6, result9
local v25, v26, flag13, n7, v27, obj, cleanup4, cleanup5, v28

do
	local animals2, ok7, mutations2, ok8, traits, cleanup6, cleanup7, v29, v30, n8
	local n9, n10, n11, n12, n13, flag14, flag15, flag16, flag17, n14
	local n15, str, now, v31, v32, y, now2, n16, str2, n17
	local tool, n18, flag18, flag19, flag20, speedToolDropdown, v33, n132, result10, v34
	local v35, n19
	local value, window, flag21, num2, flag22, flag222, v36, v37, flag23, flag232, mainWindow, defaultTab, helperTab, playerTab, espTab, miscTab, serverTab, tab, Players, RunService, Workspace, Lighting, CoreGui, HttpService, ReplicatedStorage, UserInputService, ContextActionService, TeleportService, ProximityPromptService, TextService, TweenService, Stats, localPlayer, fn20, obj2, tbl, autoStealBrainrotSection, autoKickSection, flag24, flag25, flag26, n20, n21, v38, n22, connections, obj3, fn21, fn22, chilliAutoKickOnStealRuntime, cleanup8, cleanup9, str3, n23, n24, flag27, flag28, flag29, n25, flag30, n26, flag31, n27, RagdollController, UserInputService2, connection8, flag32, n28, n29, n30, prompt, tbl2, n31, list, chilliAutoGetRuntime, cleanup10, chilliAutoGetRuntime2, cleanup11, fn23, fn24, fn25, disconnectAll, v39, result11, v40, datas, ok9, traits2, ok10, result12, ok11, fn26, fn27, fn28, prompt2, fn29, fn30, fn31, str4, fn32, fn33, chilliMacLibTargetGui, fn34, fn35, fn36, fn37, fn38, CoreGui2, chilliAutoGetBarGui, chilliAutoGetBarGui2, fn39, createUIGradient, holder, clampValue, currentCamera, frame2, visible, flag33, n32, n33, n34, n35, fn40, part, destroyAll, v41, fn41, fn42, fn43, fn44, plots, connection9, chilliDropBrainrotRuntime, cleanup12, v42, helperSection, aimbotSection, section, unlockBaseSection, CoreGui3, chilliUnlockBaseRuntime, cleanup13, cleanup14, chilliHelperLocalRuntime, cleanup15, flag34, fn45, tbl3, fn46, fn47, fn48, runUntilTimeout2, fn49, v43, v44, v45, v46, v47, v48, v49, v50, v51, speedBoostSection, respawnSection, n36, n37, n38, n39, n40, n41, n42, n43, n44, toolSpeedBoostToggle, toggle, connection10, flag35, backpack, constraintFlags, tbl4, n45, n46, n47, v52, v53, v54, v55, flag36, flag37, flag38, v56, v57, flag39, connections2, connection11, chilliFastResetRuntime, v58, playerEspSection, baseEspSection, fn50, fn51, disconnectAll2, fn52, fn53, fn54, fn55, isBasePart, tbl5, fn56, fn57, result13, fn58, n48, n49, n50, n51, transparency, enabledFlags, v59, colorSequence, v60, v61, fn59, tbl6, forIter_1, v62, v63, enabledFlags2, v35Map, forIter_2, chilliBrainrotESPRuntime, v64, tbl7, tbl8, tbl9, tbl10, ok12, matchMap, tbl11, forIter_3, performanceSection, tbl12, tbl13, chilliOptimizerRuntime, v65, v66, v67, HttpService2, UserInputService3, localPlayer2, httpRequest, httpRequest2, httpRequest3, discordUrl, keyboardEnabled, httpRequest4, match, v352, chilliFadePlotsRuntime, cleanup16, cleanup17, v622, chilliPlayerESPRuntime, cleanup18, cleanup19

	while true do
		if state <= 106 then
			if state <= 53 then
				if state <= 26 then
					if state <= 13 then
						if state == 1 then
							value = rawget(_G, "__ChilliGithubFastManualDefaultsRun")

							if type(value) ~= "table" then
								state = 13
							else
								state = 2
							end
						elseif state == 2 then
							window = value.Window
							flag21 = type(window) == "table"

							if flag21 then
								state = 3
							else
								state = 4
							end
						elseif state == 3 then
							flag21 = window._destroyed ~= true
							state = 4
						elseif state == 4 then
							if flag21 then
								state = 12
							else
								state = 5
							end
						elseif state == 5 then
							num2 = tonumber(value.StartedAt)

							if num2 then
								state = 7
							else
								state = 6
							end
						elseif state == 6 then
							num2 = os.clock()
							state = 7
						elseif state == 7 then
							flag22 = value.Status == "loading"

							if flag22 then
								state = 9
							else
								state = 8
							end
						elseif state == 8 then
							flag222 = flag22
							state = 10
						elseif state == 9 then
							flag222 = os.clock() - num2 < 30
							state = 10
						elseif state == 10 then
							if flag222 then
								state = 184
							else
								state = 11
							end
						elseif state == 11 then
							state = 13
						elseif state == 12 then
							pcall(function()
								window:Open()
							end)

							return
						elseif state == 13 then
							chilliGithubFastManualDefaultsRu = { Status = "loading", StartedAt = os.clock() }
							_G.__ChilliGithubFastManualDefaultsRun = chilliGithubFastManualDefaultsRu

							do
								local function compileChunk()
									local response = game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/Chilli%20Library")
									local chunk, v68 = loadstring(response)
									assert(chunk, v68)
									local v69 = chunk()
									assert(type(v69) == "function", "Chilli Library bootstrap is invalid.")
									local v70 = table.create(45)
									local n52 = 1

									for i_ = 1, 90, 2 do
										v70[n52] = string.char(bit32.bxor(tonumber(string.sub("306908100841206d474f00185f26635b2101387507010810127d7d477a473b6f435a0916573165562900226c00", i_, i_ + 1), 16), string.byte("s9K!2vQ#", (n52 - 1) % 8 + 1)))
										n52 += 1
									end

									return v69(table.concat(v70))
								end

								v36 = compileChunk()
							end

							v37 = assert
							flag23 = type(v36) == "table"

							if flag23 then
								state = 15
							else
								state = 14
							end
						end
					elseif state == 14 then
						flag232 = flag23
						state = 16
					elseif state == 15 then
						flag232 = type(v36.CreateWindow) == "function"
						state = 16
					elseif state == 16 then
						if flag232 then
							state = 17
						else
							state = 18
						end
					elseif state == 17 then
						flag232 = type(v36.Finalize) == "function"
						state = 18
					elseif state == 18 then
						do
							v37(flag232, "Chilli Library returned an invalid API.")
							chilliGithubFastManualDefaultsRu.Library = v36

							v36.ManualQuickDefaults = {
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

							mainWindow = v36:CreateWindow({ Name = "Chilli Hub", DefaultTab = "Main" })
							chilliGithubFastManualDefaultsRu.Window = mainWindow
							defaultTab = mainWindow:GetDefaultTab()

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
								local str5 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
								local v68 = Random.new()

								fn20 = function()
									local v69 = table.create(64)
									local str6 = HttpService:GenerateGUID(false):gsub("-", "")

									for i_ = 1, #str6 do
										v69[#v69 + 1] = str6:sub(i_, i_)
									end

									for i_ = 1, 32 do
										local v70 = v68:NextInteger(1, #str5)
										v69[#v69 + 1] = ("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"):sub(v70, v70)
									end

									for i_ = #v69, 2, -1 do
										local v70 = v68:NextInteger(1, i_)
										local v71 = v69[i_]
										v69[i_] = v69[v70]
										v69[v70] = v71
									end

									return table.concat(v69)
								end

								obj2 = setmetatable({}, { __mode = "k" })
								tbl = {}
								autoStealBrainrotSection = stealerTab:CreateSection({ Name = "Auto Steal Brainrot", Expanded = true })
								autoKickSection = stealerTab:CreateSection({ Name = "Auto Kick", Expanded = true })
							end
						end

						local formatCompact, toNumberOrDefault

						do
							flag24 = false
							flag25 = true
							flag26 = false
							n20 = 0
							n21 = 1000000
							v38 = nil
							n22 = -math.huge
							connections = {}
							obj3 = setmetatable({}, { __mode = "k" })

							do
								local tbl14 = {}

								pcall(function()
									local Animals = require(ReplicatedStorage.Datas.Animals)

									if type(Animals) == "table" then
										tbl14 = Animals
									end
								end)

								formatCompact = function(arg)
									local match2, v68 = tostring(arg or ""):gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")
									if not match2 then
										return nil
									end
									local num3 = tonumber(match2)
									if not num3 then
										return nil
									end
									return num3 * (({ K = 1000, M = 1000000, B = 1e9, T = 1e12 })[string.upper(v68)] or 1)
								end

								toNumberOrDefault = function(arg)
									local Animal = tbl14[tostring(arg or "")]
									return type(Animal) == "table" and tonumber(Animal.Generation) or 0
								end
							end
						end

						do
							local function fn60()
								local tbl14 = {}
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
													local str5 = tostring(displayName.Text)
													tbl14[str5] = tbl14[str5] or {}
													tbl14[str5][#tbl14[str5] + 1] = { Position = child.Position, Generation = formattedText }
												end
											end
										end
									end
								end

								return tbl14
							end

							fn21 = function(arg, arg2, arg3)
								local numVal = toNumberOrDefault(arg)

								if arg2 then
									local v68, v69, v70 = ipairs((arg3 or fn60())[tostring(arg or "")] or {})
									local n52 = 14

									for _, v71 in v68, v69, v70 do
										local magnitude = (v71.Position - arg2).Magnitude

										if magnitude < n52 then
											numVal = v71.Generation
											n52 = magnitude
										end
									end
								end

								return numVal
							end
						end

						fn22 = function()
							local v68 = Workspace:FindFirstChild(localPlayer.Name)
							if not v68 or not v68:IsA("Model") then
								return nil
							end
							return v68:FindFirstChild("HumanoidRootPart") or v68:FindFirstChild("__HITBOX")
						end

						chilliAutoKickOnStealRuntime = CoreGui:FindFirstChild("__ChilliAutoKickOnStealRuntime")

						if chilliAutoKickOnStealRuntime then
							state = 19
						else
							state = 25
						end
					elseif state == 19 then
						cleanup8 = chilliAutoKickOnStealRuntime:FindFirstChild("Cleanup")

						if cleanup8 then
							state = 21
						else
							state = 20
						end
					elseif state == 20 then
						cleanup9 = cleanup8
						state = 22
					elseif state == 21 then
						cleanup9 = cleanup8:IsA("BindableEvent")
						state = 22
					elseif state == 22 then
						if cleanup9 then
							state = 23
						else
							state = 24
						end
					elseif state == 23 then
						pcall(function()
							cleanup8:Fire()
						end)

						state = 24
					elseif state == 24 then
						pcall(function()
							chilliAutoKickOnStealRuntime:Destroy()
						end)

						state = 25
					elseif state == 25 then
						do
							local chilliAutoKickOnStealRuntime2, cleanup20, disconnectAll3, fn60

							do
								chilliAutoKickOnStealRuntime2 = Instance.new("Folder")
								chilliAutoKickOnStealRuntime2.Name = "__ChilliAutoKickOnStealRuntime"
								chilliAutoKickOnStealRuntime2.Archivable = false
								chilliAutoKickOnStealRuntime2.Parent = CoreGui
								cleanup20 = Instance.new("BindableEvent")
								cleanup20.Name = "Cleanup"
								cleanup20.Parent = chilliAutoKickOnStealRuntime2

								disconnectAll3 = function()
									for _, connection12 in ipairs(connections) do
										if connection12.Connected then
											connection12:Disconnect()
										end
									end

									table.clear(connections)
									table.clear(obj3)
								end

								do
									local fn61 = nil

									fn61 = function(arg, arg2, arg3)
										local kind = typeof(arg)

										if kind == "string" then
											local str5 = string.lower(arg)
											if string.find(str5, "you stole", 1, true) or string.find(str5, "successfully stole", 1, true) then
												return arg
											end
											return nil
										end

										if not (kind ~= "table" or arg3 >= 3 or arg2[arg]) then
											arg2[arg] = true

											for k, v68 in pairs(arg) do
												local v69 = fn61(k, arg2, arg3 + 1) or fn61(v68, arg2, arg3 + 1)
												if v69 then
													return v69
												end
											end
										end

										return nil
									end

									local function fn62(...)
										local v68 = table.pack(...)

										if flag24 then
											local v69 = table.pack(table.unpack(v68, 1, v68.n))
											local tbl14 = {}
											local exitTo = nil
											local v70

											for i_ = 1, v69.n do
												v70 = fn61(v69[i_], tbl14, 0)
												if v70 then
													exitTo = 1
													break
												end
											end

											if exitTo ~= 1 then
												return
											end
											local match2 = string.match(v70, ">([^<>]-)</font>")
											local v71 = fn22()

											if not (fn21(match2, v71 and v71.Position) < n21) then
												local match3 = match2 and match2 ~= ""
												local str5 = "\nAUTO KICK ACTIVATED"

												if match3 then
													str5 = "\nAUTO KICK ACTIVATED" .. "\nYou stole: " .. match2
												end

												flag24 = false
												localPlayer:Kick(str5)
												return
											end
										end
									end

									fn60 = function(descendant)
										if not flag24 or not descendant:IsA("RemoteEvent") or obj3[descendant] then
											return
										end
										obj3[descendant] = true
										connections[#connections + 1] = descendant.OnClientEvent:Connect(fn62)
									end
								end
							end

							do
								local function fn61()
									flag24 = false
									disconnectAll3()
								end

								local function fn62()
									fn61()
									flag24 = true
									local packages = ReplicatedStorage:FindFirstChild("Packages")
									packages = packages and packages:FindFirstChild("Net")
									if not packages then
										flag24 = false
										return
									end

									for _, descendant in ipairs(packages:GetDescendants()) do
										fn60(descendant)
									end

									fn60(packages)
									connections[#connections + 1] = packages.DescendantAdded:Connect(fn60)
								end

								local function fn63()
									flag25 = false
									flag26 = false
									n20 += 1
									fn61()
								end

								cleanup20.Event:Connect(fn63)
								chilliAutoKickOnStealRuntime2.Destroying:Connect(fn63)

								autoKickSection:CreateToggle({
									Name = "Auto Kick on Steal",
									Default = false,
									Callback = function(arg)
										if arg then
											fn62()
										else
											fn61()
										end
									end,
								})
							end
						end

						local configMap, autoKickMinValueSlider, str5, fn60

						do
							configMap = {
								["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
								["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
								["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
							}

							autoKickMinValueSlider = nil

							do
								local n52 = 1
								str5 = "M/s"

								fn60 = function(arg, arg2)
									if arg ~= nil then
										n52 = math.floor(tonumber(arg) or n52)
									end

									if arg2 ~= nil then
										str5 = tostring(arg2)
									elseif autoKickMinValueSlider.GetUnit then
										local unit = autoKickMinValueSlider:GetUnit()

										if unit and unit ~= "" then
											str5 = tostring(unit)
										end
									end

									n21 = n52 * (configMap[str5] or configMap["M/s"]).Mult
									v38 = nil
									n22 = -math.huge
								end
							end
						end

						do
							local function fn61(arg)
								str5 = tostring(arg)
								local configEntry = configMap[str5] or configMap["M/s"]

								if autoKickMinValueSlider.SetRange then
									autoKickMinValueSlider:SetRange(configEntry.Min, configEntry.Max)
									local min = autoKickMinValueSlider:Get() or configEntry.Min
									local min2 = configEntry.Min
									local max = configEntry.Max
									local n52 = math.clamp(math.floor(min + 0.5), min2, max)

									if n52 ~= min then
										autoKickMinValueSlider:Set(n52)
									else
										fn60(n52, str5)
									end
								else
									fn60(nil, str5)
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
										fn61(arg)
									end,
								},
								Quick = false,
								Callback = function(arg)
									fn60(arg, nil)
								end,
							})
						end

						str3 = "Steal"
						n23 = 2
						n24 = 0.25
						flag27 = true
						flag28 = false
						flag29 = false
						n25 = 1000000
						flag30 = false
						n26 = 20
						flag31 = false
						n27 = 0
						RagdollController = nil

						pcall(function()
							RagdollController = require(game:GetService("ReplicatedStorage").Controllers.RagdollController)
						end)

						UserInputService2 = game:GetService("UserInputService")

						connection8 = UserInputService2.InputBegan:Connect(function(input, gameProcessed)
							if not gameProcessed and input.KeyCode == Enum.KeyCode.Backspace then
								n27 = os.clock()
							end
						end)

						flag32 = false
						n28 = 0
						n29 = 0
						n30 = -math.huge
						prompt = nil
						tbl2 = {}
						n31 = -math.huge
						list = {}
						chilliAutoGetRuntime = CoreGui:FindFirstChild("__ChilliAutoGetRuntime")

						if chilliAutoGetRuntime then
							state = 26
						else
							state = 32
						end
					elseif state == 26 then
						cleanup10 = chilliAutoGetRuntime:FindFirstChild("Cleanup")

						if cleanup10 then
							state = 28
						else
							state = 27
						end
					end
				elseif state <= 39 then
					if state == 27 then
						cleanup = cleanup10
						state = 29
					elseif state == 28 then
						cleanup = cleanup10:IsA("BindableEvent")
						state = 29
					elseif state == 29 then
						if cleanup then
							state = 30
						else
							state = 31
						end
					elseif state == 30 then
						pcall(function()
							cleanup10:Fire()
						end)

						state = 31
					elseif state == 31 then
						pcall(function()
							chilliAutoGetRuntime:Destroy()
						end)

						state = 32
					elseif state == 32 then
						chilliAutoGetRuntime2 = Instance.new("Folder")
						chilliAutoGetRuntime2.Name = "__ChilliAutoGetRuntime"
						chilliAutoGetRuntime2.Archivable = false
						chilliAutoGetRuntime2.Parent = CoreGui
						cleanup11 = Instance.new("BindableEvent")
						cleanup11.Name = "Cleanup"
						cleanup11.Parent = chilliAutoGetRuntime2

						fn23 = function(arg)
							list[#list + 1] = arg
							return arg
						end

						do
							local n52 = 10
							local obj4 = setmetatable({}, { __mode = "k" })

							fn24 = function(arg, arg2)
								if not arg or not arg.Parent or not arg.Visible then
									return false
								end
								local absolutePosition = arg.AbsolutePosition
								local absoluteSize = arg.AbsoluteSize
								return arg2.X >= absolutePosition.X and arg2.X <= absolutePosition.X + absoluteSize.X and arg2.Y >= absolutePosition.Y and arg2.Y <= absolutePosition.Y + absoluteSize.Y
							end

							fn23(UserInputService2.InputChanged:Connect(function(input)
								local v68 = obj4[input]

								if v68 then
									local vector2 = Vector2.new(input.Position.X, input.Position.Y)
									v68.Position = vector2

									if (vector2 - v68.Start).Magnitude > n52 then
										v68.Cancelled = true
									end
								end
							end))

							fn23(UserInputService2.InputEnded:Connect(function(input)
								local v68 = obj4[input]
								if not v68 then
									return
								end
								local vector2 = Vector2.new(input.Position.X, input.Position.Y)
								v68.Position = vector2

								if (vector2 - v68.Start).Magnitude > n52 or not fn24(v68.Button, vector2) then
									v68.Cancelled = true
								end

								task.delay(0.2, function()
									if obj4[input] == v68 then
										obj4[input] = nil
									end
								end)
							end))

							fn25 = function(arg, arg2)
								fn23(arg.InputBegan:Connect(function(input)
									if not (input.UserInputType ~= Enum.UserInputType.Touch or input.UserInputState ~= Enum.UserInputState.Begin) then
										local vector2 = Vector2.new(input.Position.X, input.Position.Y)

										if fn24(arg, vector2) then
											obj4[input] = { Button = arg, Start = vector2, Position = vector2, Cancelled = false }
										end
									end
								end))

								return fn23(arg.Activated:Connect(function(inputObject)
									if inputObject and inputObject.UserInputType == Enum.UserInputType.Touch then
										local v68 = obj4[inputObject]
										if not v68 or v68.Button ~= arg or v68.Cancelled or not fn24(arg, v68.Position) then
											return
										end
									end

									arg2()
								end))
							end
						end

						disconnectAll = function()
							for _, v68 in ipairs(list) do
								if v68.Connected then
									v68:Disconnect()
								end
							end

							table.clear(list)
						end

						v39 = nil
						result11 = nil
						v40 = nil
						datas = ReplicatedStorage:FindFirstChild("Datas")

						if datas then
							state = 33
						else
							state = 59
						end
					elseif state == 33 then
						animals2 = datas:FindFirstChild("Animals")

						if animals2 then
							state = 35
						else
							state = 34
						end
					elseif state == 34 then
						animals = animals2
						state = 36
					elseif state == 35 then
						animals = animals2:IsA("ModuleScript")
						state = 36
					elseif state == 36 then
						if animals then
							state = 37
						else
							state = 41
						end
					elseif state == 37 then
						ok7, result = pcall(require, animals2)

						if ok7 then
							state = 38
						else
							state = 39
						end
					elseif state == 38 then
						ok7 = type(result) == "table"
						state = 39
					elseif state == 39 then
						if ok7 then
							state = 40
						else
							state = 41
						end
					end
				elseif state == 40 then
					v39 = result
					state = 41
				elseif state == 41 then
					mutations2 = datas:FindFirstChild("Mutations")

					if mutations2 then
						state = 43
					else
						state = 42
					end
				elseif state == 42 then
					mutations = mutations2
					state = 44
				elseif state == 43 then
					mutations = mutations2:IsA("ModuleScript")
					state = 44
				elseif state == 44 then
					if mutations then
						state = 45
					else
						state = 50
					end
				elseif state == 45 then
					ok8, result2 = pcall(require, mutations2)

					if ok8 then
						state = 47
					else
						state = 46
					end
				elseif state == 46 then
					ok9 = ok8
					state = 48
				elseif state == 47 then
					ok9 = type(result2) == "table"
					state = 48
				elseif state == 48 then
					if ok9 then
						state = 49
					else
						state = 50
					end
				elseif state == 49 then
					result11 = result2
					state = 50
				elseif state == 50 then
					traits2 = datas:FindFirstChild("Traits")

					if traits2 then
						state = 52
					else
						state = 51
					end
				elseif state == 51 then
					traits = traits2
					state = 53
				elseif state == 52 then
					traits = traits2:IsA("ModuleScript")
					state = 53
				elseif state == 53 then
					if traits then
						state = 54
					else
						state = 59
					end
				end
			elseif state <= 79 then
				if state <= 66 then
					if state == 54 then
						ok10, result12 = pcall(require, traits2)

						if ok10 then
							state = 56
						else
							state = 55
						end
					elseif state == 55 then
						ok11 = ok10
						state = 57
					elseif state == 56 then
						ok11 = type(result12) == "table"
						state = 57
					elseif state == 57 then
						if ok11 then
							state = 58
						else
							state = 59
						end
					elseif state == 58 then
						v40 = result12
						state = 59
					elseif state == 59 then
						local fn60, fn61, toNumberOrDefault, brainrotNameTiers, tbl14, tbl15, tbl16

						do
							do
								do
									fn60 = function(arg)
										return string.lower(tostring(arg or ""))
									end

									fn61 = function(arg)
										if arg then
											while true do
												arg = arg.Parent
												local parent2 = arg and arg ~= Workspace

												if parent2 then
													local isBasePart2 = arg:IsA("BasePart")
													local isBasePart3 = isBasePart2 and arg.Name == "Spawn"
													if isBasePart3 then
														return arg
													end
													continue
												end

												break
											end
										elseif arg and arg ~= Workspace then
											if not (arg:IsA("BasePart") and arg.Name == "Spawn") then
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

											return arg
										end

										return nil
									end

									toNumberOrDefault = function(arg)
										if not (not v39 or not arg or arg == "") then
											local v68 = v39[arg]
											if type(v68) == "table" then
												return tonumber(v68.Generation) or 0
											end
										end

										return 0
									end

									brainrotNameTiers = {}
									tbl14 = { Limit = 1000000 }

									do
										local colorSequenceNew = ColorSequence.new
										local tbl17 = {}
										local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
										local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
										local new = ColorSequenceKeypoint.new
										local color3FromRGB = Color3.fromRGB
										tbl17[1] = v68
										tbl17[2] = v69

										do
											local values = table.pack(new(1, color3FromRGB(214, 142, 12)))
											table.move(values, 1, values.n, 3, tbl17)
										end

										tbl14.Text = colorSequenceNew(tbl17)
									end
								end

								do
									local colorSequenceNew = ColorSequence.new
									local tbl17 = {}
									local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
									local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
									local new = ColorSequenceKeypoint.new
									local color3FromRGB = Color3.fromRGB
									tbl17[1] = v68
									tbl17[2] = v69

									do
										local values = table.pack(new(1, color3FromRGB(20, 12, 0)))
										table.move(values, 1, values.n, 3, tbl17)
									end

									tbl14.Stroke = colorSequenceNew(tbl17)
								end

								tbl15 = { Limit = 10000000 }

								do
									local colorSequenceNew = ColorSequence.new
									local tbl17 = {}
									local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
									local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
									local new = ColorSequenceKeypoint.new
									local color3FromRGB = Color3.fromRGB
									tbl17[1] = v68
									tbl17[2] = v69

									do
										local values = table.pack(new(1, color3FromRGB(206, 92, 0)))
										table.move(values, 1, values.n, 3, tbl17)
									end

									tbl15.Text = colorSequenceNew(tbl17)
								end
							end

							do
								local colorSequenceNew = ColorSequence.new
								local tbl17 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 54, 0))
								local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 27, 0))
								local new = ColorSequenceKeypoint.new
								local color3FromRGB = Color3.fromRGB
								tbl17[1] = v68
								tbl17[2] = v69

								do
									local values = table.pack(new(1, color3FromRGB(18, 8, 0)))
									table.move(values, 1, values.n, 3, tbl17)
								end

								tbl15.Stroke = colorSequenceNew(tbl17)
							end

							do
								tbl16 = { Limit = 100000000 }

								do
									local colorSequenceNew = ColorSequence.new
									local tbl17 = {}
									local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 168, 140))
									local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
									local new = ColorSequenceKeypoint.new
									local color3FromRGB = Color3.fromRGB
									tbl17[1] = v68
									tbl17[2] = v69

									do
										local values = table.pack(new(1, color3FromRGB(196, 42, 0)))
										table.move(values, 1, values.n, 3, tbl17)
									end

									tbl16.Text = colorSequenceNew(tbl17)
								end
							end

							do
								local colorSequenceNew = ColorSequence.new
								local tbl17 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 26, 0))
								local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 13, 0))
								local new = ColorSequenceKeypoint.new
								local color3FromRGB = Color3.fromRGB
								tbl17[1] = v68
								tbl17[2] = v69

								do
									local values = table.pack(new(1, color3FromRGB(18, 4, 0)))
									table.move(values, 1, values.n, 3, tbl17)
								end

								tbl16.Stroke = colorSequenceNew(tbl17)
							end
						end

						do
							do
								local tbl17

								do
									tbl17 = { Limit = math.huge }

									do
										local colorSequenceNew = ColorSequence.new
										local tbl18 = {}
										local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
										local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
										local new = ColorSequenceKeypoint.new
										local color3FromRGB = Color3.fromRGB
										tbl18[1] = v68
										tbl18[2] = v69

										do
											local values = table.pack(new(1, color3FromRGB(184, 0, 18)))
											table.move(values, 1, values.n, 3, tbl18)
										end

										tbl17.Text = colorSequenceNew(tbl18)
									end
								end

								do
									local colorSequenceNew = ColorSequence.new
									local tbl18 = {}
									local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
									local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
									local new = ColorSequenceKeypoint.new
									local color3FromRGB = Color3.fromRGB
									tbl18[1] = v68
									tbl18[2] = v69

									do
										local values = table.pack(new(1, color3FromRGB(18, 0, 3)))
										table.move(values, 1, values.n, 3, tbl18)
									end

									tbl17.Stroke = colorSequenceNew(tbl18)
								end

								do
									brainrotNameTiers[1] = tbl14
									brainrotNameTiers[2] = tbl15
									brainrotNameTiers[3] = tbl16
									brainrotNameTiers[4] = tbl17
									chilliGithubFastManualDefaultsRu.BrainrotNameTiers = brainrotNameTiers

									chilliGithubFastManualDefaultsRu.BrainrotNameTier = function(arg)
										local n52 = tonumber(arg) or 0

										for _, brainrotNameTier in ipairs(chilliGithubFastManualDefaultsRu.BrainrotNameTiers) do
											if n52 < brainrotNameTier.Limit then
												return brainrotNameTier
											end
										end

										return chilliGithubFastManualDefaultsRu.BrainrotNameTiers[#chilliGithubFastManualDefaultsRu.BrainrotNameTiers]
									end

									chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle = function(parent2)
										parent2.TextColor3 = Color3.fromRGB(255, 255, 255)
										local uiStroke = Instance.new("UIStroke")
										uiStroke.Color = Color3.fromRGB(255, 255, 255)
										uiStroke.Thickness = 1.15
										uiStroke.Transparency = 0.08
										uiStroke.Parent = parent2
										local uiGradient = Instance.new("UIGradient")
										uiGradient.Rotation = 90
										uiGradient.Parent = uiStroke
										local uiGradient2 = Instance.new("UIGradient")
										uiGradient2.Rotation = 90
										uiGradient2.Parent = parent2
										return { Label = parent2, Outline = uiStroke, Text = uiGradient2, Stroke = uiGradient }
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
										local n52 = 0.5
										local obj4 = setmetatable({}, { __mode = "k" })

										local function fn62(arg)
											local v68 = fn61(arg)

											if v68 then
												if fn60(v68.Name) ~= "lucky block" then
													for _, descendant in ipairs(v68:GetDescendants()) do
														if descendant:IsA("TextLabel") and fn60(descendant.Name) == "stolen" and descendant.Visible and fn60(descendant.Text) == "fusing" then
															return true
														end
													end

													return false
												end

												return true
											end

											return false
										end

										fn26 = function(arg)
											local now3 = os.clock()
											local v68 = obj4[arg]
											if v68 and now3 < v68.ExpiresAt then
												return v68.Value
											end
											local v69 = fn62(arg)

											if v68 then
												v68.Value = v69
												v68.ExpiresAt = now3 + n52
											else
												obj4[arg] = { Value = v69, ExpiresAt = now3 + n52 }
											end

											return v69
										end
									end
								end
							end

							fn27 = function(arg)
								local n52 = tonumber(arg) or 0
								if n52 >= 1e9 then
									return string.format("%.2fB/s", n52 / 1e9)
								end

								if n52 >= 1000000 then
									return string.format("%.2fM/s", n52 / 1000000)
								end

								if n52 >= 1000 then
									return string.format("%.1fK/s", n52 / 1000)
								end
								return string.format("%d/s", math.floor(n52))
							end

							do
								local function fn62(arg)
									if not arg or arg == "" then
										return nil
									end
									local match2, v68 = arg:gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")

									if match2 then
										local n52 = tonumber(match2) or 0
										local str5 = v68:upper()

										if str5 == "K" then
											n52 *= 1000
										elseif str5 == "M" then
											n52 *= 1000000
										elseif str5 == "B" then
											n52 *= 1e9
										elseif str5 == "T" then
											n52 *= 1e12
										end

										return n52
									end

									return nil
								end

								local function fn63(arg, arg2, arg3, arg4)
									local numVal = toNumberOrDefault(arg3)
									arg = arg and arg.Position
									if not arg then
										return numVal
									end
									local arg42 = arg4 and arg4[arg3]
									local overhead = nil

									if arg42 then
										local v68, v69, v70 = ipairs(arg4[arg3])
										local n52 = 14
										overhead = nil

										for _, v71 in v68, v69, v70 do
											local magnitude = (v71.Position - arg).Magnitude

											if magnitude < n52 then
												overhead = v71.Overhead
												n52 = magnitude
											end
										end
									end

									local v68 = nil

									if arg2 then
										local v69, v70, v71 = ipairs(arg2:GetChildren())
										local n52 = 14
										v68 = nil

										for _, v72 in v69, v70, v71 do
											if v72:IsA("Model") and v72.Name == arg3 then
												local rootPart = v72:FindFirstChild("RootPart") or v72.PrimaryPart or v72:FindFirstChildWhichIsA("BasePart")

												if rootPart then
													local magnitude = (rootPart.Position - arg).Magnitude

													if magnitude < n52 then
														n52 = magnitude
														v68 = v72
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

										if v68 then
											local attribute = v68:GetAttribute("Mutation") or v68:GetAttribute("__mutation")
											local attribute2 = attribute and tostring(attribute) ~= ""
											text = nil

											if attribute2 then
												text = tostring(attribute)
											end
										end
									end

									local matchs = {}
									local matchMap2 = {}

									if v68 then
										for _, child in ipairs(v68:GetChildren()) do
											local match2 = child.Name:match("^_Trait%.(.+)$")

											if match2 and not matchMap2[match2] then
												matchMap2[match2] = true
												table.insert(matchs, match2)
											end
										end

										local attribute = v68:GetAttribute("Trait") or v68:GetAttribute("Traits")

										if attribute then
											local str5 = tostring(attribute)

											if not matchMap2[str5] then
												matchMap2[str5] = true
												table.insert(matchs, str5)
											end
										end
									end

									local text2 = text and result11 and result11[text]
									local n52 = 1

									if text2 then
										n52 = 1 + (tonumber(result11[text].Modifier) or 0)
									end

									local flag40 = false

									if v40 then
										for _, match2 in ipairs(matchs) do
											local v69 = v40[match2] or v40[match2:gsub("_", " ")]

											if v69 then
												if match2 == "Sleepy" or v69.Name == "Sleepy" then
													flag40 = true
												else
													n52 += tonumber(v69.MultiplierModifier) or 0
												end
											end
										end
									end

									local v69 = math.round(numVal * n52 * (flag40 and 0.5 or 1))
									local v70 = fn62(overhead and overhead:FindFirstChild("Generation") and overhead.Generation.Text)
									if v70 and v70 > v69 then
										return v70
									end
									return v69 > 0 and v69 or v70 or numVal
								end

								fn28 = function(arg)
									local now3 = os.clock()
									if not arg and now3 - n31 < n23 then
										return
									end
									n31 = now3
									local list2 = {}
									local plots2 = Workspace:FindFirstChild("Plots")

									if plots2 then
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

										for _, child in ipairs(plots2:GetChildren()) do
											local animalPodiums = child:FindFirstChild("AnimalPodiums")

											if animalPodiums then
												for _, child2 in ipairs(animalPodiums:GetChildren()) do
													local base = child2:FindFirstChild("Base")
													base = base and base:FindFirstChild("Spawn")

													if base and base:IsA("BasePart") then
														local promptAttachment = base:FindFirstChild("PromptAttachment")
														local v68 = ipairs
														promptAttachment = promptAttachment or base
														local descendant = nil

														for _, descendant2 in v68(promptAttachment:GetDescendants()) do
															if descendant2:IsA("ProximityPrompt") and tostring(descendant2.ActionText) == str3 then
																descendant = descendant2
																break
															else
																descendant = nil
															end
														end

														if descendant then
															local str5 = tostring(descendant.ObjectText or "")

															list2[#list2 + 1] = {
																Prompt = descendant,
																Plot = child,
																Spawn = base,
																Name = str5,
																Generation = fn63(base, child, str5, textMap),
															}
														end
													end
												end
											end
										end
									end

									tbl2 = list2
								end
							end
						end

						local n52, n53, position, v68, v69, v70, v71, v72, fn62

						do
							local targetCard

							do
								do
									n52 = 0.03
									n53 = -math.huge
									position = nil
									v68 = nil
									v69 = nil
									v70 = nil
									v71 = nil
									v72 = nil

									fn62 = function(arg, arg2, distance, generation)
										local tbl17 = { Prompt = arg.Prompt, Plot = arg.Plot, Position = arg2 }
										local name = arg.Name
										local name2

										if name then
											name2 = name
										else
											name2 = tostring(arg.Prompt.ObjectText or "")
										end

										tbl17.Name = name2
										tbl17.Generation = generation
										tbl17.Distance = distance
										return tbl17
									end

									prompt2 = nil

									fn29 = function(arg)
										if not arg then
											return nil
										end

										for _, v73 in ipairs(tbl2) do
											if v73.Prompt == arg then
												return v73
											end
										end

										return nil
									end

									fn30 = function(arg)
										if prompt2 and prompt2.Parent and arg then
											local v73 = fn29(prompt2)

											if v73 then
												local position2 = v73.Spawn.Position
												local fn622 = fn62
												local magnitude = (arg.Position - position2).Magnitude
												return fn622(v73, position2, magnitude, v73.Generation or 0)
											end
										end

										return nil
									end

									fn31 = function(arg, arg2, arg3, arg4)
										if flag29 then
											arg2 = arg4 or arg2
											if arg2 and arg2.Distance <= n26 then
												return arg2
											end
											return nil
										end

										local v73 = fn30(arg)
										if v73 then
											return v73
										end
										return arg3
									end

									str4 = "Default (Chilli Hub)"
									fn32 = nil
									fn33 = nil
									chilliMacLibTargetGui = Instance.new("ScreenGui")
									chilliMacLibTargetGui.Name = "ChilliMacLibTargetGui"
									chilliMacLibTargetGui.ResetOnSpawn = false
									chilliMacLibTargetGui.IgnoreGuiInset = true
									chilliMacLibTargetGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
									chilliMacLibTargetGui.Enabled = false

									pcall(function()
										chilliMacLibTargetGui.Parent = type(gethui) == "function" and gethui() or CoreGui
									end)

									targetCard = Instance.new("Frame")
									targetCard.Name = "TargetCard"
									targetCard.AnchorPoint = Vector2.new(0.5, 0)
									targetCard.Position = UDim2.new(0.5, 0, 0, 72)
									targetCard.Size = UDim2.fromOffset(270, 48)
									targetCard.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
									targetCard.BackgroundTransparency = 0.15
									targetCard.BorderSizePixel = 0
									targetCard.Parent = chilliMacLibTargetGui
									Instance.new("UICorner", targetCard).CornerRadius = UDim.new(0, 10)

									do
										local uiStroke = Instance.new("UIStroke")
										uiStroke.Color = Color3.fromRGB(58, 255, 55)
										uiStroke.Thickness = 1.2
										uiStroke.Transparency = 0.3
										uiStroke.Parent = targetCard
									end
								end

								do
									local textLabel = Instance.new("TextLabel")
									textLabel.BackgroundTransparency = 1
									textLabel.Position = UDim2.fromOffset(12, 5)
									textLabel.Size = UDim2.new(1, -24, 0, 14)
									textLabel.Font = Enum.Font.GothamBold
									textLabel.TextSize = 11
									textLabel.TextColor3 = Color3.fromRGB(58, 255, 55)
									textLabel.TextXAlignment = Enum.TextXAlignment.Left
									textLabel.Text = "AUTO STEAL (MAC LIB) - MỤC TIÊU GẦN NHẤT"
									textLabel.Parent = targetCard
								end
							end

							local textLabel = Instance.new("TextLabel")
							textLabel.BackgroundTransparency = 1
							textLabel.Position = UDim2.fromOffset(12, 22)
							textLabel.Size = UDim2.new(1, -24, 0, 20)
							textLabel.Font = Enum.Font.GothamBlack
							textLabel.TextSize = 13
							textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
							textLabel.TextXAlignment = Enum.TextXAlignment.Left
							textLabel.TextTruncate = Enum.TextTruncate.AtEnd
							textLabel.Text = "Đang quét tìm brainrot gần nhất..."
							textLabel.Parent = targetCard
							local flag40 = false
							local v73 = nil
							local vector2 = Vector2.new(0, 0)
							local v74 = nil

							fn23(targetCard.InputBegan:Connect(function()
							end))

							fn23(UserInputService2.InputChanged:Connect(function(input)
								if input == v73 or not v73 then
									local n54 = Vector2.new(input.Position.X, input.Position.Y) - vector2
									targetCard.Position = UDim2.new(v74.X.Scale, v74.X.Offset + n54.X, v74.Y.Scale, v74.Y.Offset + n54.Y)
								end
							end))

							fn23(UserInputService2.InputEnded:Connect(function(input)
								local flag41 = input == v73

								if flag41 or not v73 then
									flag40 = false
									v73 = nil
									v74 = nil
								end
							end))

							fn34 = function(arg)
								if chilliMacLibTargetGui.Parent then
									if not (str4 and string.find(str4, "Mac")) then
										chilliMacLibTargetGui.Enabled = false
										return
									end
									chilliMacLibTargetGui.Enabled = true

									if arg and arg.Name then
										local distance = arg.Distance and string.format("%.1fm", arg.Distance) or ""
										local generation = arg.Generation and arg.Generation > 0 and " | " .. fn27(arg.Generation) or ""
										textLabel.Text = string.format("%s (%s)%s", tostring(arg.Name), distance, generation)
									else
										textLabel.Text = "Đang quét tìm brainrot gần nhất..."
									end
								end
							end
						end

						fn35 = function(arg)
							fn34(arg)
						end

						do
							local function formatCompact(arg)
								local match2, v73 = tostring(arg or ""):match("%$?([%d%.]+)%s*([KMB]?)")
								if not match2 then
									return 0
								end
								local n54 = tonumber(match2) or 0

								if v73 == "K" then
									n54 *= 1000
								elseif v73 == "M" then
									n54 *= 1000000
								elseif v73 == "B" then
									n54 *= 1e9
								end

								return n54
							end

							local function fn63()
								local name = localPlayer.Name
								local displayName = localPlayer.DisplayName
								local plots2 = Workspace:FindFirstChild("Plots")

								if plots2 then
									for _, child in ipairs(plots2:GetChildren()) do
										local plotSign = child:FindFirstChild("PlotSign")

										if plotSign then
											local surfaceGui = plotSign:FindFirstChild("SurfaceGui")

											if surfaceGui then
												local frame3 = surfaceGui:FindFirstChild("Frame")

												if frame3 then
													local textLabel = frame3:FindFirstChildOfClass("TextLabel")

													if textLabel and type(textLabel.Text) == "string" then
														local text = textLabel.Text
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

							local function fn64(arg)
								if not (arg and arg:IsA("Model")) then
									return nil
								end

								for _, descendant in ipairs(arg:GetDescendants()) do
									if descendant:IsA("TextLabel") then
										local str5 = string.lower(descendant.Name)
										if str5 == "generation" or str5 == "gen" or str5:find("generation") or str5:find("gen") then
											return descendant
										end
									end
								end

								return nil
							end

							fn36 = function(arg)
								if not arg then
									return nil, nil, 0
								end
								local position2 = arg.Position
								local v73 = nil
								local v74 = nil
								local n54 = -math.huge
								local huge = math.huge
								local n55 = 0

								local function fn65(arg2, arg3, arg4, arg5)
									if arg2 and arg2.Parent and tostring(arg2.ActionText) == str3 and not fn26(arg2) then
										if not arg4 then
											arg4 = tostring(arg2.ObjectText or "")
										end

										if type(arg5) ~= "number" then
											local flag40 = type(arg5) == "string" and arg5 ~= ""
											local n56 = 0

											if flag40 then
												arg5 = formatCompact(arg5)
											else
												arg5 = n56
											end
										end

										if arg5 == 0 then
											arg5 = toNumberOrDefault(arg4)
										end

										if not (arg5 > 0 and arg5 < n25) then
											n55 += 1
											local magnitude = (position2 - arg3).Magnitude

											if magnitude <= n26 then
												local tbl17 = {
													Prompt = arg2,
													Spawn = { Position = arg3 },
													Position = arg3,
													Name = arg4,
													Generation = arg5,
													Distance = magnitude,
												}

												if not v73 or arg5 > n54 then
													v73 = tbl17
													n54 = arg5
												end

												if not v74 or magnitude < huge then
													v74 = tbl17
													huge = magnitude
												end
											end
										end
									end
								end

								local plots2 = Workspace:FindFirstChild("Plots")
								local flag40 = os.clock() < n29

								if plots2 and not flag40 then
									local v75 = fn63()

									for _, child in ipairs(plots2:GetChildren()) do
										if child ~= v75 then
											local animalPodiums = child:FindFirstChild("AnimalPodiums")

											if animalPodiums then
												for _, child2 in ipairs(animalPodiums:GetChildren()) do
													local base = child2:FindFirstChild("Base")
													local spawn = base and base:FindFirstChild("Spawn")

													if spawn and spawn:IsA("BasePart") then
														local promptAttachment = spawn:FindFirstChild("PromptAttachment") or spawn
														local descendant = nil

														for _, descendant2 in ipairs(promptAttachment:GetDescendants()) do
															if descendant2:IsA("ProximityPrompt") and tostring(descendant2.ActionText) == str3 then
																descendant = descendant2
																break
															else
																descendant = nil
															end
														end

														if descendant then
															local str5 = tostring(descendant.ObjectText or "")
															local attachment = spawn:FindFirstChild("Attachment")
															attachment = attachment and attachment:FindFirstChild("AnimalOverhead")
															local str6 = ""

															if attachment then
																local generation = attachment:FindFirstChild("Generation")

																if generation and generation:IsA("TextLabel") then
																	str6 = generation.Text
																end
															end

															if str6 == "" and str5 ~= "" then
																local v76 = child:FindFirstChild(str5) or child:FindFirstChild(str5, true)

																if v76 and v76:IsA("Model") then
																	local v77 = fn64(v76)

																	if v77 then
																		str6 = v77.Text
																	end
																end
															end

															fn65(descendant, spawn.Position, str5, str6, child.Name, tostring(i))
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
										local str5 = string.lower(child.Name or "")

										if str5 ~= "lucky block" and str5 ~= "camera" and not child:IsA("Camera") then
											local descendant = nil

											for _, descendant2 in ipairs(child:GetDescendants()) do
												if descendant2:IsA("ProximityPrompt") and tostring(descendant2.ActionText) == str3 then
													descendant = descendant2
													break
												else
													descendant = nil
												end
											end

											if descendant then
												local position3 = child:IsA("BasePart") and child.Position or child:IsA("Model") and child.PrimaryPart and child.PrimaryPart.Position or descendant.Parent and descendant.Parent:IsA("BasePart") and descendant.Parent.Position

												if position3 then
													local str6 = ""

													if child:IsA("Model") then
														local v75 = fn64(child)

														if v75 then
															str6 = v75.Text
														end
													end

													fn65(descendant, position3, tostring(descendant.ObjectText or child.Name), str6, nil, nil)
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
												if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == str3 then
													fn65(descendant, humanoidRootPart.Position, tostring(descendant.ObjectText or "Carried Brainrot"), "", nil, nil)
												end
											end
										end
									end
								end

								return v73, v74, n55
							end
						end

						fn37 = function(arg)
							if not arg then
								return nil, nil, nil, nil, 0
							end
							local now3 = os.clock()
							local position2 = arg.Position
							if now3 - n53 < n52 and position and (position2 - position).Magnitude < 0.5 then
								return v68, v69, v70, v71, v72
							end
							fn28(false)
							local n54 = 0
							local v73 = nil
							local generation = nil
							local v74 = nil
							local magnitude = nil
							local v75 = nil
							local generation2 = nil
							local v76 = nil
							local magnitude2 = nil

							for _, v77 in ipairs(tbl2) do
								local prompt3 = v77.Prompt

								if prompt3.Parent and prompt3.Enabled and tostring(prompt3.ActionText) == str3 and not fn26(prompt3) then
									local generation3 = v77.Generation or 0
									local flag292 = flag29
									local flag2922

									if flag29 then
										flag2922 = flag292
									else
										flag2922 = generation3 >= n25
									end

									if flag2922 then
										n54 += 1
										local position3 = v77.Spawn.Position
										local magnitude3 = (position2 - position3).Magnitude

										if not v73 or generation3 > generation then
											v73 = fn62(v77, position3, magnitude3, generation3)
											generation = generation3
										end

										if not v74 or magnitude3 < magnitude then
											v74 = fn62(v77, position3, magnitude3, generation3)
											magnitude = magnitude3
										end

										if magnitude3 <= n26 then
											if not v75 or generation3 > generation2 then
												v75 = fn62(v77, position3, magnitude3, generation3)
												generation2 = generation3
											end

											if not v76 or magnitude3 < magnitude2 then
												v76 = fn62(v77, position3, magnitude3, generation3)
												magnitude2 = magnitude3
											end
										end
									end
								end
							end

							n53 = now3
							position = position2
							v68 = v75
							v69 = v76
							v70 = v73
							v71 = v74
							v72 = n54
							return v75, v76, v73, v74, n54
						end

						fn38 = function(arg)
							if not (not arg or not arg:IsA("ProximityPrompt") or not arg.Parent or type(getconnections) ~= "function") then
								local list2 = {}
								local list3 = {}

								if not (not pcall(function()
									for _, v73 in pairs(getconnections(arg.PromptButtonHoldBegan)) do
										if v73 and v73.Function then
											list2[#list2 + 1] = v73.Function
										end
									end

									for _, v73 in pairs(getconnections(arg.Triggered)) do
										if v73 and v73.Function then
											list3[#list3 + 1] = v73.Function
										end
									end
								end) or #list3 == 0) then
									return list2, list3
								end
							end

							return nil
						end

						CoreGui2 = CoreGui

						pcall(function()
							if type(gethui) == "function" then
								local hui = gethui()

								if typeof(hui) == "Instance" then
									CoreGui2 = hui
								end
							end
						end)

						chilliAutoGetBarGui = CoreGui2:FindFirstChild("ChilliAutoGetBarGui")

						if chilliAutoGetBarGui then
							state = 60
						else
							state = 61
						end
					elseif state == 60 then
						pcall(function()
							chilliAutoGetBarGui:Destroy()
						end)

						state = 61
					elseif state == 61 then
						do
							do
								chilliAutoGetBarGui2 = Instance.new("ScreenGui")
								chilliAutoGetBarGui2.Name = "ChilliAutoGetBarGui"
								chilliAutoGetBarGui2.ResetOnSpawn = false
								chilliAutoGetBarGui2.IgnoreGuiInset = true
								chilliAutoGetBarGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
								chilliAutoGetBarGui2.Enabled = false
								chilliAutoGetBarGui2.Parent = CoreGui2
								color = Color3.fromRGB(58, 255, 55)
								color2 = Color3.fromRGB(20, 109, 0)

								do
									local gothamBold = Enum.Font.GothamBold

									pcall(function()
										gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
									end)

									fn39 = function(arg)
										if typeof(gothamBold) == "Font" then
											arg.FontFace = gothamBold
										else
											arg.Font = Enum.Font.GothamBold
										end
									end
								end
							end

							createUIGradient = function(parent2, arg, arg2)
								local uiGradient = Instance.new("UIGradient")
								local new = ColorSequenceKeypoint.new
								uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, arg), new(1, arg2) })
								uiGradient.Rotation = 90
								uiGradient.Parent = parent2
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
							holder.Parent = chilliAutoGetBarGui2
							Instance.new("UICorner", holder).CornerRadius = UDim.new(0, 16)

							do
								local uiStroke = Instance.new("UIStroke")
								uiStroke.Color = Color3.fromRGB(255, 255, 255)
								uiStroke.Thickness = 1
								uiStroke.Transparency = 0.93
								uiStroke.Parent = holder
							end
						end

						do
							local n52 = 0.125
							local n53 = 248
							local n54 = 1
							local uiScale = Instance.new("UIScale")
							uiScale.Parent = holder

							clampValue = function()
								local currentCamera2 = Workspace.CurrentCamera
								local viewportSize = currentCamera2 and currentCamera2.ViewportSize or Vector2.new(1280, 720)

								if viewportSize.X < 1 then
									viewportSize = Vector2.new(1280, 720)
								end

								uiScale.Scale = math.clamp(viewportSize.X * n52 * n54 / n53, 0.6, 1.4)
							end
						end

						clampValue()
						currentCamera = Workspace.CurrentCamera

						if currentCamera then
							state = 62
						else
							state = 63
						end
					elseif state == 62 then
						fn23(currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue))
						state = 63
					elseif state == 63 then
						local runUntilTimeout3

						do
							do
								local textLabel, textLabel2

								do
									do
										fn23(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(clampValue))
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
										fn39(textLabel)
										textLabel.Parent = holder

										do
											local uiTextSizeConstraint = Instance.new("UITextSizeConstraint")
											uiTextSizeConstraint.MinTextSize = 8
											uiTextSizeConstraint.MaxTextSize = 13
											uiTextSizeConstraint.Parent = textLabel
										end
									end

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
									fn39(textLabel2)
									textLabel2.Parent = holder

									do
										local frame3 = Instance.new("Frame")
										frame3.Position = UDim2.fromOffset(14, 30)
										frame3.Size = UDim2.new(1, -28, 0, 6)
										frame3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
										frame3.BackgroundTransparency = 0.88
										frame3.BorderSizePixel = 0
										frame3.Parent = holder
										Instance.new("UICorner", frame3).CornerRadius = UDim.new(1, 0)
										frame2 = Instance.new("Frame")
										frame2.Size = UDim2.new(0, 0, 1, 0)
										frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
										frame2.BorderSizePixel = 0
										frame2.Parent = frame3
									end
								end

								Instance.new("UICorner", frame2).CornerRadius = UDim.new(1, 0)
								createUIGradient(frame2, color, color2)

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
									frame = Instance.new("Frame")
									frame.Size = UDim2.new(0, 0, 1, 0)
									frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
									frame.BackgroundTransparency = 0.55
									frame.BorderSizePixel = 0
									frame.Parent = frame3
									Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
									visible = false
									flag33 = false
									n32 = 0
									n33 = 1
									n34 = 0
									n35 = 0

									fn40 = function()
										flag33 = false
									end

									runUntilTimeout3 = function(arg)
										if not flag30 or not chilliAutoGetBarGui2.Parent then
											flag33 = false
											return
										end
										n33 = math.max(tonumber(arg) or 1, 0.01)
										n32 = os.clock()
										flag33 = true
									end

									local n52 = 0.22
									local color3 = Color3.fromRGB(255, 255, 255)
									part = nil
									local cylinderHandleAdornment = nil
									local radius = 0

									destroyAll = function()
										if connection8 then
											connection8:Disconnect()
											connection8 = nil
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

									local function fn60()
										if part and part.Parent and cylinderHandleAdornment then
											return
										end
										destroyAll()
										local part2 = Instance.new("Part")
										part2.Name = fn20()
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
										cylinderHandleAdornment2.Name = fn20()
										cylinderHandleAdornment2.Adornee = part2
										cylinderHandleAdornment2.AlwaysOnTop = true
										cylinderHandleAdornment2.Color3 = color3
										cylinderHandleAdornment2.Height = 0.05
										cylinderHandleAdornment2.InnerRadius = 0
										cylinderHandleAdornment2.Radius = 0
										cylinderHandleAdornment2.Transparency = 0.25
										cylinderHandleAdornment2.ZIndex = 1
										cylinderHandleAdornment2.Parent = part2
										part = part2
										cylinderHandleAdornment = cylinderHandleAdornment2
									end

									fn41 = function(arg)
										local character_ = localPlayer.Character
										character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

										if not visible or not character_ then
											if part then
												destroyAll()
											end

											return
										end

										fn60()
										local n53 = math.max(tonumber(n26), 1)
										math.min(arg or 0.016, 0.1)
										radius = n53
										part.CFrame = CFrame.new(character_.Position - Vector3.new(0, 2.9, 0)) * CFrame.Angles(-1.5707963267948966, 0, 0)
										cylinderHandleAdornment.Radius = radius
										cylinderHandleAdornment.InnerRadius = math.max(radius - n52, 0)
									end

									fn42 = function(arg)
										visible = arg == true
										frame3.Visible = visible
										holder.Size = UDim2.fromOffset(248, visible and 55 or 46)

										if not visible then
											n35 = 0
											frame.Size = UDim2.new(0, 0, 1, 0)
											destroyAll()
										end
									end
								end

								fn43 = function(arg, arg2, arg3)
									if textLabel.Parent then
										textLabel.Text = tostring(arg or "")
										chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle(chilliGithubFastManualDefaultsRu.AutoStealBarNameStyle, arg3)
									end

									if textLabel2.Parent then
										textLabel2.Text = tostring(arg2 or "")
									end
								end
							end

							do
								local flag40 = false
								local input = nil
								local vector2 = Vector2.new(0, 0)
								local position = nil

								fn23(holder.InputBegan:Connect(function(input2)
									if not (flag40 or input2.UserInputState ~= Enum.UserInputState.Begin) then
										local flag41 = input2.UserInputType == Enum.UserInputType.Touch

										if not (not (input2.UserInputType == Enum.UserInputType.MouseButton1) and not flag41) then
											local vector22 = Vector2.new(input2.Position.X, input2.Position.Y)
											local absolutePosition = holder.AbsolutePosition
											local absoluteSize = holder.AbsoluteSize

											if not (vector22.X < absolutePosition.X or vector22.X > absolutePosition.X + absoluteSize.X or vector22.Y < absolutePosition.Y or vector22.Y > absolutePosition.Y + absoluteSize.Y) then
												flag40 = true
												input = flag41 and input2 or nil
												vector2 = vector22
												position = holder.Position
												return
											end
										end
									end
								end))

								fn23(UserInputService2.InputChanged:Connect(function(input2)
									if flag40 and not (not (input and input2 == input or not input and input2.UserInputType == Enum.UserInputType.MouseMovement) or not position) then
										local n52 = Vector2.new(input2.Position.X, input2.Position.Y) - vector2
										holder.Position = UDim2.new(position.X.Scale, position.X.Offset + n52.X, position.Y.Scale, position.Y.Offset + n52.Y)
										return
									end
								end))

								fn23(UserInputService2.InputEnded:Connect(function(input2)
									if flag40 then
										local input3 = input and input2 == input
										local input4

										if input3 then
											input4 = input3
										else
											input4 = not input and input2.UserInputType == Enum.UserInputType.MouseButton1
										end

										if input4 then
											flag40 = false
											input = nil
											position = nil
										end
									end
								end))
							end
						end

						local fn60

						do
							local n52, n53, fn61

							do
								fn44 = function()
									if chilliAutoGetBarGui2.Parent then
										chilliAutoGetBarGui2.Enabled = flag28 and flag30
									end

									if not flag28 or not flag30 then
										fn40()
										fn43("", "")
									end
								end

								do
									local n54 = 1
									n52 = 0.25
									local n55 = -math.huge
									n53 = -math.huge

									fn61 = function()
										if flag28 then
											local now3 = os.clock()

											if not (now3 - n55 < n54) then
												n55 = now3

												task.spawn(function()
													fn33()
													task.wait(0.05)
													fn32()
												end)

												return
											end
										end
									end
								end
							end

							do
								local function runUntilTimeout4(arg)
									local now3 = os.clock()

									if not (now3 - n53 < n52) then
										n53 = now3

										for _, v68 in ipairs(arg) do
											pcall(v68)
										end
									end
								end

								local function fn62(arg)
									if not (arg and arg.Parent) or type(getconnections) ~= "function" then
										return
									end

									pcall(function()
										for _, v68 in pairs(getconnections(arg.PromptButtonHoldEnded)) do
											if v68 and v68.Function then
												pcall(v68.Function)
											end
										end
									end)
								end

								fn60 = function(arg, arg2, arg3, arg4, arg5)
									local prompt3 = type(arg) == "table" and arg.Prompt or arg
									local plotName = type(arg) == "table" and arg.PlotName or nil
									local slotName = type(arg) == "table" and arg.SlotName or nil
									if not prompt3 then
										return false, "no prompt"
									end

									if str4 == "Fix 1 (Wait Before Fire)" then
										task.wait(0.1)
									end

									local n54 = os.clock() - n30
									local n55 = 0

									if str4 == "Fix 2 (Longer Settle)" then
										n55 = 1.5
									end

									if n54 < n55 then
										task.wait(n55 - n54)
									end

									if not flag27 or not flag28 or arg2 ~= n28 then
										return false, "stopped"
									end
									local v68, v69 = fn38(prompt3)
									if not v68 or not v69 then
										return false, "no handlers"
									end
									local n56 = 1.3

									if flag31 then
										flag31 = false
										n56 = 2
									end

									if arg4 then
										pcall(arg4, n56)
									end

									if str4 == "Xen Hub Source v11" then
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
													local v70
													v70:FireServer(Workspace:GetServerTimeNow() + 67, "579e6c26-5a80-407d-9488-0f84752e8f1f", arg6, tonumber(arg7) or arg7)
												end)
											end

											fireRemote()
											task.wait(1.3)
											fireRemote2(plotName, slotName)
											return true, "fired xen hub source"
										end

										for _, v70 in ipairs(v68) do
											pcall(v70)
										end

										task.wait(1.3)

										for _, v70 in ipairs(v69) do
											pcall(v70)
										end

										return true, "fired fallback"
									end

									if str4 and string.find(str4, "v20") and localPlayer:GetAttribute("Stealing") == true then
										return false, "v20_radar"
									end

									if str4 and string.find(str4, "v21") then
										local now3 = os.clock()

										while not prompt3.Enabled and prompt3.Parent and os.clock() - now3 < 0.6 do
											task.wait(0.02)
										end
									end

									if os.clock() - n30 < 1.5 and str4 and (string.find(str4, "Smart Window") or string.find(str4, "v19") or string.find(str4, "v19")) then
										for _, v70 in ipairs(v68) do
											pcall(v70)
										end

										task.wait(n56)

										for _, v70 in ipairs(v69) do
											pcall(v70)
										end

										n30 = os.clock()
										return true, "fired (v14 protected window)"
									end

									local pos = str4 and string.find(str4, "v23")

									if pos then
										local v70 = globalCacheLockUntil
										pos = os.clock() < v70
									end

									if (isDebris or pos) and str4 and string.find(str4, "v22") then
										for _, v70 in ipairs(v68) do
											pcall(v70)
										end

										task.wait(n56)

										for _, v70 in ipairs(v69) do
											pcall(v70)
										end

										fn62(prompt3)
										n30 = os.clock()
										return true, "fired (v22 debris cache hold)"
									end

									if str4 == "Fix 4 (FireProximityPrompt)" and fireproximityprompt then
										fireproximityprompt(prompt3, 0)
										fireproximityprompt(prompt3, 1)
									end

									for _, v70 in ipairs(v68) do
										pcall(v70)
									end

									local str5 = tostring(prompt3.ObjectText)
									local now3 = os.clock()

									while os.clock() - now3 < n56 do
										task.wait(0.05)
										if not flag27 or not flag28 or arg2 ~= n28 then
											fn62(prompt3)
											return false, "stopped"
										end

										if not arg5 and localPlayer:GetAttribute("Stealing") == true then
											for _, v70 in ipairs(v69) do
												pcall(v70)
											end

											fn62(prompt3)
											return false, "carrying"
										end

										if tostring(prompt3.ObjectText) ~= str5 then
											runUntilTimeout4(v69)
											fn61()
											fn62(prompt3)
											return false, "brainrot changed"
										end

										if not prompt3.Parent or not prompt3.Enabled or not arg3() then
											runUntilTimeout4(v69)
											fn61()
											fn62(prompt3)
											return false, "retargeted"
										end
									end

									local v692

									if str4 == "Default (Chilli Hub)" or str4 == "Fix 3 (Re-fetch Triggers)" then
										local v70
										v70, v692 = fn38(prompt3)
										v692 = v692 or v69
									else
										v692 = v69
									end

									for _, v70 in ipairs(v692) do
										pcall(v70)
									end

									fn62(prompt3)
									n30 = os.clock()
									return true, "fired"
								end
							end
						end

						do
							do
								local function fn61(arg, arg2, arg3)
									if not (not flag27 or not flag28 or arg2 ~= n28) and not (arg3 and localPlayer:GetAttribute("Stealing") ~= true) then
										local character_ = localPlayer.Character
										local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart then
											if flag29 then
												local prompt3 = arg.Prompt
												if not (not prompt3 or not prompt3.Parent or not prompt3.Enabled or tostring(prompt3.ActionText) ~= str3 or fn26(prompt3)) then
													local position = arg.Position
													return not position or (humanoidRootPart.Position - position).Magnitude <= n26
												end
											else
												if prompt2 and prompt2.Parent then
													return arg.Prompt == prompt2
												end
												local v68

												if str4 and (string.find(str4, "Mac Lib") or string.find(str4, "Original")) then
													local v69
													v69, v68 = fn36(humanoidRootPart)
												else
													local v69
													v69, v68 = fn37(humanoidRootPart)
												end

												if v68 then
													if v68.Prompt == arg.Prompt then
														return true
													end
													return v68.Distance >= (humanoidRootPart.Position - arg.Position).Magnitude - n24
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
										local now3 = os.clock()

										while true do
											if flag27 and flag28 and arg == n28 and os.clock() - now3 < 1 and not (prompt3.Enabled and tostring(prompt3.ActionText) == str3) then
												task.wait(0.05)
												continue
											end
											break
										end
									else
										task.wait(0.2)
									end
								end

								local function fn62(arg)
									local flag40 = false

									while true do
										if flag27 and flag28 and arg == n28 then
											local flag41 = localPlayer:GetAttribute("Stealing") == true

											if not flag40 then
												if str4 and string.find(str4, "v19") then
													task.wait()
												else
													task.wait(0.1)
												end
											end

											local flag42 = not flag27 or not flag28 or arg ~= n28
											flag40 = false

											if not flag42 then
												if not (str4 and string.find(str4, "v20")) and localPlayer:GetAttribute("Stealing") == true then
													flag32 = true
													fn40()

													if flag30 then
														fn43("GET READY - carrying brainrot", "")
													end

													while flag27 and flag28 and arg == n28 and localPlayer:GetAttribute("Stealing") == true do
														if str4 and string.find(str4, "v19") then
															task.wait()
														else
															task.wait(0.05)
														end
													end

													if not (str4 and string.find(str4, "v19")) then
														runUntilTimeout4(arg)
													end

													flag32 = false

													if str4 and string.find(str4, "v19") then
														flag40 = true
													end
												else
													if not (str4 and string.find(str4, "v20")) then
														fn35(nil)
													end

													flag32 = false
													local character_ = localPlayer.Character
													character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

													if not character_ then
														fn40()
													else
														local v68, v69, v70

														if flag29 then
															v68, v69, v70 = fn37(character_)
														else
															v68, v69 = fn36(character_)
															v70 = nil
														end

														local v71 = fn31(character_, v68, v69, v70)
														fn34(v71)

														if not v71 then
															fn40()
														else
															prompt = v71.Prompt

															if not fn60(v71, arg, function()
																return fn61(v71, arg, false)
															end, runUntilTimeout3, false) then
																fn40()
															end
														end
													end
												end

												continue
											end
										end

										break
									end
								end

								fn32 = function()
									n28 += 1
									flag28 = true
									flag32 = false
									n31 = -math.huge
									fn44()
									task.spawn(fn62, n28)
								end
							end
						end

						fn33 = function()
							flag28 = false
							flag32 = false
							n28 += 1
							fn40()
							fn35(nil)
							fn44()
						end

						do
							local n52 = 0

							fn23(localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
								if localPlayer:GetAttribute("Stealing") == true then
									n30 = os.clock()
									n52 += 1
									local n522 = n52

									task.spawn(function()
										task.wait(1.5)
										local flag282 = flag28

										if flag28 then
											flag282 = localPlayer:GetAttribute("Stealing") == true
										end

										if flag282 and n52 == n522 then
											fn33()
											task.wait(0.05)
											fn32()
										end
									end)
								else
									n52 += 1

									if not (os.clock() - n27 < 0.5) then
										local flag40 = false

										if RagdollController then
											local ok13, result14 = pcall(function()
												return RagdollController.IsInRagdoll()
											end)

											if ok13 and result14 == true then
												flag40 = true
											end
										end

										if not flag40 then
											local character_ = localPlayer.Character
											character_ = character_ and character_:FindFirstChildOfClass("Humanoid")

											if character_ then
												local state2 = character_:GetState()

												if state2 == Enum.HumanoidStateType.Physics or state2 == Enum.HumanoidStateType.FallingDown or state2 == Enum.HumanoidStateType.Ragdoll then
													flag40 = true
												end
											end
										end

										local flag41

										if not flag40 then
											local character_ = localPlayer.Character

											if character_ and character_:FindFirstChildOfClass("BallSocketConstraint", true) then
												flag41 = true
											else
												flag41 = flag40
											end
										else
											flag41 = flag40
										end

										if flag41 then
											flag31 = true
										end
									end
								end
							end))
						end

						fn23(Workspace.ChildAdded:Connect(function(child)
							if child.Name == "Plots" then
								n31 = -math.huge
							end
						end))

						plots = Workspace:FindFirstChild("Plots")

						if plots then
							state = 64
						else
							state = 65
						end
					elseif state == 64 then
						fn23(plots.ChildAdded:Connect(function()
							n31 = -math.huge
						end))

						fn23(plots.ChildRemoved:Connect(function()
							n31 = -math.huge
						end))

						state = 65
					elseif state == 65 then
						local autoStealToggle, fn60, fn61, n52, n53, n54, color3, n55, n56, n57
						local screenGui, frame3, frame4, iMap, textLabel, frame5, textLabel2, frame6, flag40, n58
						local n59, clampValue2, flag41, n60, plot, n61, str5, fn62, getUDim2, fn63
						local tweenInfo, n62, plot2, fn64, destroyAll2

						do
							do
								local configMap, createSlider, str6, fn65

								do
									autoStealToggle = autoStealBrainrotSection:CreateToggle({
										Name = "Auto Steal",
										Default = true,
										Callback = function(arg)
											str4 = "Auto Get Default"

											if arg then
												fn32()
											else
												fn33()
											end
										end,
									})

									fn60 = function()
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
											flag29 = arg == true
										end,
									})

									configMap = {
										["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
										["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
										["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
									}

									createSlider = nil

									do
										local n63 = 1
										str6 = "M/s"

										fn65 = function(arg, arg2)
											if arg ~= nil then
												n63 = math.floor(tonumber(arg) or n63)
											end

											if arg2 ~= nil then
												str6 = tostring(arg2)
											elseif createSlider and createSlider.GetUnit then
												local unit = createSlider:GetUnit()

												if unit and unit ~= "" then
													str6 = tostring(unit)
												end
											end

											n25 = n63 * (configMap[str6] or configMap["M/s"]).Mult
											n31 = -math.huge
										end
									end
								end

								do
									local function fn66(arg)
										str6 = arg
										local configEntry = configMap[arg] or configMap["M/s"]

										if createSlider and createSlider.SetRange then
											createSlider:SetRange(configEntry.Min, configEntry.Max)
											local min = createSlider:Get() or configEntry.Min
											local min2 = configEntry.Min
											local max = configEntry.Max
											local n63 = math.clamp(math.floor(min + 0.5), min2, max)

											if n63 ~= min then
												createSlider:Set(n63)
											else
												fn65(n63, arg)
											end
										else
											fn65(nil, arg)
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
											Colors = {
												Number = Color3.fromRGB(255, 255, 255),
												Suffix = Color3.fromRGB(58, 255, 55),
											},
											Callback = function(arg)
												fn66(arg)
											end,
										},
										Quick = false,
										SubOf = autoStealToggle,
										Callback = function(arg)
											fn65(arg, nil)
										end,
									})
								end
							end

							do
								local flag42, attachment, beam, parent2, parent3, n63, fn65, fn66

								do
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
											n26 = math.clamp(tonumber(arg) or 20, 10, 200)
										end,
									})

									do
										local color4 = Color3.fromRGB(170, 255, 0)
										local color5 = Color3.fromRGB(240, 255, 210)
										flag42 = false
										attachment = nil
										local attachment2 = nil
										beam = nil
										parent2 = nil
										parent3 = nil
										n63 = -math.huge

										fn61 = function()
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
											parent2 = nil
											parent3 = nil
										end

										fn65 = function()
											local v68 = Workspace:FindFirstChild(localPlayer.Name)

											if not (not v68 or not v68:IsA("Model")) then
												local humanoidRootPart = v68:FindFirstChild("HumanoidRootPart")

												if not (humanoidRootPart and humanoidRootPart:IsA("BasePart") and humanoidRootPart.Parent == v68) then
													humanoidRootPart = v68:FindFirstChild("__HITBOX") or v68:FindFirstChild("__hitbox") or v68:FindFirstChild("Hitbox") or v68:FindFirstChild("HitBox")
													if not (humanoidRootPart and humanoidRootPart:IsA("BasePart")) then
														return nil
													end
												end

												return humanoidRootPart
											end

											return nil
										end

										fn66 = function(parent4, parent5)
											fn61()
											if not (parent4 and parent5) then
												return
											end
											attachment = Instance.new("Attachment")
											attachment.Name = fn20()
											attachment.Position = Vector3.new(0, 0.6, 0)
											attachment.Parent = parent4
											attachment2 = Instance.new("Attachment")
											attachment2.Name = fn20()
											attachment2.Position = Vector3.new(0, 2.6, 0)
											attachment2.Parent = parent5
											beam = Instance.new("Beam")
											beam.Name = fn20()
											beam.Archivable = false
											beam.Attachment0 = attachment
											beam.Attachment1 = attachment2
											beam.Color = ColorSequence.new(color4, color5)
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
											local tbl14 = {}
											local v68 = NumberSequenceKeypoint.new(0, 0)
											local v69 = NumberSequenceKeypoint.new(0.85, 0)
											tbl14[1] = v68
											tbl14[2] = v69

											do
												local values = table.pack(NumberSequenceKeypoint.new(1, 0.25))
												table.move(values, 1, values.n, 3, tbl14)
											end

											beam2.Transparency = numberSequenceNew(tbl14)
											beam.Width0 = 0.34
											beam.Width1 = 0.7
											beam.ZOffset = 0.1
											obj2[beam] = true
											beam.Parent = attachment
											parent2 = parent4
											parent3 = parent5
										end
									end
								end

								do
									local function fn67()
										if not (flag42 and flag28) then
											if beam then
												fn61()
											end
										else
											local now3 = os.clock()

											if not (now3 - n63 < 0.1) then
												n63 = now3
												local character_ = localPlayer.Character
												local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
												local v68 = fn65(character_)
												if not (humanoidRootPart and v68) then
													fn61()
													return
												end
												local v69, v70, v71 = fn37(humanoidRootPart)
												local v72 = fn31(humanoidRootPart, v69, v70, v71)
												local v722 = v72 and fn29(v72.Prompt) or nil
												v722 = v722 and v722.Spawn or nil
												if not v722 then
													fn61()
													return
												end
												local flag43 = parent2 ~= v68 or parent3 ~= v722

												if not flag43 then
													flag43 = not (attachment and attachment.Parent)
												end

												if flag43 then
													fn66(v68, v722)
												end
											end
										end
									end

									fn23(RunService.Heartbeat:Connect(function()
										if flag27 then
											fn67()
										end
									end))
								end

								autoStealBrainrotSection:CreateToggle({
									Name = "Target Beam",
									Note = "Draws a straight amber line to the Brainrot Auto Steal is targeting.",
									Default = true,
									Quick = false,
									SubOf = autoStealToggle,
									Callback = function(arg)
										flag42 = arg == true

										if not flag42 then
											fn61()
										end
									end,
								})
							end

							do
								local v68

								do
									n52 = 140
									n53 = 5
									n54 = 0.5
									color3 = Color3.fromRGB(58, 255, 55)
									n55 = 214
									n56 = 40
									n57 = 44
									screenGui = nil
									frame3 = nil
									frame4 = nil
									iMap = {}
									textLabel = nil
									frame5 = nil
									textLabel2 = nil
									v68 = nil
									frame6 = nil
									flag40 = false
									n58 = 5
									n59 = 1
									clampValue2 = nil
									flag41 = false
									n60 = -math.huge
									plot = nil
									n61 = -math.huge
									str5 = ""

									do
										local gothamBold = Enum.Font.GothamBold

										pcall(function()
											gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
										end)

										fn62 = function(arg)
											if typeof(gothamBold) == "Font" then
												arg.FontFace = gothamBold
											else
												arg.Font = Enum.Font.GothamBold
											end
										end
									end
								end

								do
									local v69 = mainWindow:CreateState({
										Name = "Base Target Panel Position",
										Default = {
											XOffset = 0,
											XScale = 0.78183454275131226,
											YScale = 0.022769367322325706,
											YOffset = 0,
										},
									})

									getUDim2 = function()
										local v70 = v69:Get()
										if type(v70) == "table" and type(v70.XOffset) == "number" and type(v70.YOffset) == "number" then
											return UDim2.new(tonumber(v70.XScale) or 1, v70.XOffset, tonumber(v70.YScale) or 0.5, v70.YOffset)
										end
										return UDim2.new(1, -18, 0.5, 0)
									end

									fn63 = function(arg)
										v69:Set({ XScale = arg.X.Scale, XOffset = arg.X.Offset, YScale = arg.Y.Scale, YOffset = arg.Y.Offset })
									end
								end

								tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
								n62 = 0
								plot2 = nil

								fn64 = function()
									if frame3 then
										local visible2 = not flag40

										if textLabel2 then
											textLabel2.Visible = visible2
											textLabel2.Text = plot2 and "no brainrot left in this base" or "no base nearby"
										end

										local flag402 = flag40 and 0 or n62
										local n63

										if flag402 > 0 then
											n63 = (n56 + 4) * flag402 + 4
										else
											n63 = 0

											if visible2 then
												n63 = 26
											end
										end

										local n64 = n57 + n63

										if v68 ~= n64 then
											v68 = n64

											if frame5 then
												if n63 > 0 then
													frame5.Visible = true
												end

												TweenService:Create(frame5, tweenInfo, { Size = UDim2.new(1, -20, 0, math.max(n63, 1)) }):Play()
											end

											local tween = TweenService:Create(frame3, tweenInfo, { Size = UDim2.fromOffset(214, n64) })

											if n63 <= 0 and frame5 then
												tween.Completed:Connect(function()
													if frame5 and v68 == n64 then
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
									textLabel = nil
									frame5 = nil
									textLabel2 = nil
									v68 = nil
									frame6 = nil
									clampValue2 = nil
									str5 = ""

									if screenGui then
										pcall(function()
											screenGui:Destroy()
										end)

										screenGui = nil
									end
								end
							end
						end

						do
							local fn65, str6, fn66, fn67, fn68

							do
								local fn69

								do
									fn65 = function(arg, arg2)
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

									fn69 = function(arg, arg2, arg3)
										if not (arg and arg2) or arg3 == "" then
											return nil
										end
										local magnitude = nil
										local child = nil

										for _, child2 in ipairs(arg:GetChildren()) do
											if child2:IsA("Model") and child2.Name == arg3 then
												local ok13, result14 = pcall(function()
													return child2:GetPivot()
												end)

												if ok13 then
													local magnitude2 = (result14.Position - arg2.Position).Magnitude

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

									str6 = ""

									do
										local function fn70(arg, painted)
											if arg.Painted ~= painted then
												arg.Painted = painted
												local v68 = ipairs
												local tweens = arg.Tweens or {}

												for _, tween in v68(tweens) do
													pcall(function()
														tween:Cancel()
													end)
												end

												local tweens2 = {}
												local tween = TweenService:Create(arg.Accent, tweenInfo, { Size = UDim2.new(0, painted and 3 or 0, 1, -12) })
												local tween2 = TweenService:Create(arg.Stroke, tweenInfo, { Color = painted and color3 or Color3.fromRGB(255, 255, 255), Transparency = painted and 0.1 or 0.86 })
												local TweenService2 = TweenService
												local create = TweenService2.Create
												local row = arg.Row
												local tbl14 = { BackgroundTransparency = painted and 0.12 or 0.4 }
												local v69 = table.pack(create(TweenService2, row, tweenInfo, tbl14))
												tweens2[1] = tween
												tweens2[2] = tween2

												do
													local values = table.pack(table.unpack(v69, 1, v69.n))
													table.move(values, 1, values.n, 3, tweens2)
												end

												arg.Tweens = tweens2

												for _, tween3 in ipairs(arg.Tweens) do
													tween3:Play()
												end
											end
										end

										fn66 = function()
											for _, v68 in ipairs(iMap) do
												fn70(v68, prompt2 ~= nil and v68.Prompt == prompt2)
											end
										end
									end
								end

								do
									local function fn70(layoutOrder)
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
										local new = ColorSequenceKeypoint.new
										local color3FromRGB = Color3.fromRGB
										uiGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(58, 255, 55)), new(1, color3FromRGB(20, 109, 0)) })
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
										viewportFrame.Size = UDim2.fromOffset(n56 - 6, n56 - 6)
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
										frame8.Position = UDim2.fromOffset(n56 - 3, n56 - 3)
										frame8.Size = UDim2.fromOffset(24, 13)
										frame8.ZIndex = 4
										frame8.Parent = textButton
										Instance.new("UICorner", frame8).CornerRadius = UDim.new(0, 5)
										local textLabel3 = Instance.new("TextLabel")
										textLabel3.BackgroundTransparency = 1
										textLabel3.Size = UDim2.fromScale(1, 1)
										textLabel3.Text = ""
										textLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
										textLabel3.TextScaled = true
										textLabel3.ZIndex = 5
										fn62(textLabel3)
										textLabel3.Parent = frame8
										local uiStroke2 = Instance.new("UIStroke")
										uiStroke2.Color = Color3.fromRGB(0, 0, 0)
										uiStroke2.Thickness = 1.4
										uiStroke2.Transparency = 0.25
										uiStroke2.Parent = textLabel3
										local textLabel4 = Instance.new("TextLabel")
										textLabel4.BackgroundTransparency = 1
										textLabel4.Position = UDim2.fromOffset(n56 + 2, 5)
										textLabel4.Size = UDim2.new(1, -n56 - 10, 0, 13)
										textLabel4.Text = ""
										textLabel4.TextColor3 = Color3.fromRGB(238, 238, 242)
										textLabel4.TextScaled = true
										textLabel4.TextTruncate = Enum.TextTruncate.AtEnd
										textLabel4.TextXAlignment = Enum.TextXAlignment.Left
										fn62(textLabel4)
										textLabel4.Parent = textButton
										local textLabel5 = chilliGithubFastManualDefaultsRu.CreateBrainrotNameStyle(textLabel4)
										local textLabel6 = Instance.new("TextLabel")
										textLabel6.BackgroundTransparency = 1
										textLabel6.Position = UDim2.fromOffset(n56 + 2, 20)
										textLabel6.Size = UDim2.fromOffset(62, 11)
										textLabel6.Text = ""
										textLabel6.TextColor3 = Color3.fromRGB(115, 255, 0)
										textLabel6.TextScaled = true
										textLabel6.TextXAlignment = Enum.TextXAlignment.Left
										fn62(textLabel6)
										textLabel6.Parent = textButton
										local textLabel7 = Instance.new("TextLabel")
										textLabel7.BackgroundTransparency = 1
										textLabel7.Position = UDim2.fromOffset(n56 + 66, 20)
										textLabel7.RichText = true
										textLabel7.Size = UDim2.fromOffset(62, 11)
										textLabel7.Text = ""
										textLabel7.TextScaled = true
										textLabel7.TextXAlignment = Enum.TextXAlignment.Left
										fn62(textLabel7)
										textLabel7.Parent = textButton
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

										local tbl14 = {
											Row = textButton,
											Accent = frame7,
											Stroke = uiStroke,
											Viewport = viewportFrame,
											Camera = camera,
											Rank = textLabel3,
											NameLabel = textLabel4,
											NameStyle = textLabel5,
											ValueLabel = textLabel6,
											MutationLabel = textLabel7,
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

										fn25(textButton, function()
											if not tbl14.Prompt then
												return
											end

											if prompt2 == tbl14.Prompt then
												prompt2 = nil
												str6 = ""
											else
												prompt2 = tbl14.Prompt
												str6 = tbl14.NameLabel.Text
												fn60()
											end

											str5 = ""
											fn66()
										end)

										return tbl14
									end

									fn67 = function()
										if not (screenGui and screenGui.Parent) then
											screenGui = Instance.new("ScreenGui")
											screenGui.Name = "ChilliAutoGetTargetPanel"
											screenGui.DisplayOrder = 5
											screenGui.IgnoreGuiInset = true
											screenGui.ResetOnSpawn = false
											screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
											local CoreGui4 = CoreGui

											if type(gethui) == "function" then
												local ok13
												ok13, CoreGui4 = pcall(gethui)
												ok13 = ok13 and typeof(CoreGui4) == "Instance"
												local CoreGui5 = CoreGui

												if not ok13 then
													CoreGui4 = CoreGui5
												end
											end

											screenGui.Parent = CoreGui4
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

											local function clampValue3()
												local currentCamera2 = Workspace.CurrentCamera
												local viewportSize = currentCamera2 and currentCamera2.ViewportSize or Vector2.new(1280, 720)

												if viewportSize.X < 1 then
													viewportSize = Vector2.new(1280, 720)
												end

												uiScale.Scale = math.clamp(viewportSize.X * 0.15 / n55, 0.7, 1.3) * n59
											end

											clampValue2 = clampValue3
											clampValue3()
											local currentCamera2 = Workspace.CurrentCamera

											if currentCamera2 then
												fn23(currentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue3))
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
											local fn71 = nil
											local flag42 = false
											local v68 = nil
											local flag43 = false
											local vector2 = Vector2.new(0, 0)
											local vector22 = Vector2.new(0, 0)

											handle.InputBegan:Connect(function()
											end)

											fn23(UserInputService2.InputChanged:Connect(function(input)
												if not (not (input == v68 or not v68) or not frame3) then
													local absoluteSize = screenGui.AbsoluteSize

													if not (absoluteSize.X <= 0 or absoluteSize.Y <= 0) then
														local n63 = Vector2.new(input.Position.X, input.Position.Y) - vector2

														if not (not flag43 and n63.Magnitude < 6) then
															flag43 = true
															frame7.Position = UDim2.fromScale(math.clamp(vector22.X + n63.X / absoluteSize.X, math.min(math.max(frame7.AbsoluteSize.X / absoluteSize.X, 0), 0.998), 0.998), math.clamp(vector22.Y + n63.Y / absoluteSize.Y, 0, 0.98))
															return
														end
													end
												end
											end))

											fn23(UserInputService2.InputEnded:Connect(function(input)
												if input.UserInputType == Enum.UserInputType.MouseButton1 or input == v68 then
													flag42 = false
													v68 = nil

													if flag43 then
														fn63(frame7.Position)
													elseif fn71 then
														fn71()
													end
												end
											end))

											local textLabel3 = Instance.new("TextLabel")
											textLabel3.BackgroundTransparency = 1
											textLabel3.Position = UDim2.fromOffset(32, 8)
											textLabel3.Size = UDim2.fromOffset(n55 - 102, 14)
											textLabel3.Text = "Base Targets"
											textLabel3.TextColor3 = Color3.fromRGB(240, 240, 244)
											textLabel3.TextScaled = true
											textLabel3.TextXAlignment = Enum.TextXAlignment.Left
											fn62(textLabel3)
											textLabel3.Parent = handle
											local textLabel4 = Instance.new("TextLabel")
											textLabel4.BackgroundTransparency = 1
											textLabel4.Position = UDim2.fromOffset(32, 23)
											textLabel4.Size = UDim2.fromOffset(n55 - 102, 10)
											textLabel4.Text = "walk into a base"
											textLabel4.TextColor3 = Color3.fromRGB(140, 140, 150)
											textLabel4.TextScaled = true
											textLabel4.TextXAlignment = Enum.TextXAlignment.Left
											fn62(textLabel4)
											textLabel4.Parent = handle
											textLabel = textLabel4
											local textButton = Instance.new("TextButton")
											textButton.AnchorPoint = Vector2.new(0, 0.5)
											textButton.AutoButtonColor = false
											textButton.BackgroundTransparency = 1
											textButton.BorderSizePixel = 0
											textButton.Position = UDim2.new(0, 8, 0, math.floor(n57 * 0.5))
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

											for _, v69 in ipairs({ { 0.335355, 45 }, { 0.664645, -45 } }) do
												local frame9 = Instance.new("Frame")
												frame9.AnchorPoint = Vector2.new(0.5, 0.5)
												frame9.BackgroundColor3 = Color3.fromRGB(58, 255, 55)
												frame9.BorderSizePixel = 0
												frame9.Position = UDim2.fromScale(v69[1], 0.535355)
												frame9.Rotation = v69[2]
												frame9.Size = UDim2.fromScale(0.6657, 0.2)
												frame9.Parent = frame8
											end

											frame6 = frame8
											frame8.Rotation = flag40 and 180 or 0

											fn71 = function()
												flag40 = not flag40
												local TweenService2 = TweenService
												local create = TweenService2.Create
												local tbl14 = {}
												tbl14.Rotation = flag40 and 180 or 0
												create(TweenService2, frame8, tweenInfo, tbl14):Play()
												fn64()
											end

											fn25(textButton, fn71)
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
											local textLabel5 = Instance.new("TextLabel")
											textLabel5.BackgroundTransparency = 1
											textLabel5.Position = UDim2.fromOffset(9, 5)
											textLabel5.Size = UDim2.fromOffset(9, 10)
											textLabel5.Text = "X"
											textLabel5.TextColor3 = Color3.fromRGB(226, 226, 232)
											textLabel5.TextScaled = true
											fn62(textLabel5)
											textLabel5.Parent = textButton2
											local textLabel6 = Instance.new("TextLabel")
											textLabel6.BackgroundTransparency = 1
											textLabel6.Position = UDim2.fromOffset(21, 5)
											textLabel6.Size = UDim2.fromOffset(30, 10)
											textLabel6.Text = "Clear"
											textLabel6.TextColor3 = Color3.fromRGB(226, 226, 232)
											textLabel6.TextScaled = true
											textLabel6.TextXAlignment = Enum.TextXAlignment.Left
											fn62(textLabel6)
											textLabel6.Parent = textButton2

											local function fn72(arg)
												local color4 = arg and Color3.fromRGB(255, 150, 150) or Color3.fromRGB(226, 226, 232)
												TweenService:Create(textButton2, tweenInfo, { BackgroundTransparency = arg and 0.05 or 0.2 }):Play()

												TweenService:Create(uiStroke2, tweenInfo, {
													Color = arg and Color3.fromRGB(255, 120, 120) or Color3.fromRGB(255, 255, 255),
													Transparency = arg and 0.25 or 0.78,
												}):Play()

												TweenService:Create(textLabel5, tweenInfo, { TextColor3 = color4 }):Play()
												TweenService:Create(textLabel6, tweenInfo, { TextColor3 = color4 }):Play()
											end

											textButton2.MouseEnter:Connect(function()
												fn72(true)
											end)

											textButton2.MouseLeave:Connect(function()
												fn72(false)
											end)

											fn25(textButton2, function()
												prompt2 = nil
												str6 = ""
												str5 = ""
												fn66()
											end)

											local frame9 = Instance.new("Frame")
											frame9.BackgroundTransparency = 1
											frame9.Position = UDim2.fromOffset(10, 40)
											frame9.Size = UDim2.new(1, -20, 0, (n56 + 4) * (n53 + 1))
											frame9.Parent = frame7
											local uiListLayout = Instance.new("UIListLayout")
											uiListLayout.FillDirection = Enum.FillDirection.Vertical
											uiListLayout.Padding = UDim.new(0, 4)
											uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
											uiListLayout.Parent = frame9
											frame4 = frame9
											frame5 = frame9
											local textLabel7 = Instance.new("TextLabel")
											textLabel7.BackgroundTransparency = 1
											textLabel7.LayoutOrder = 99
											textLabel7.Size = UDim2.new(1, 0, 0, 22)
											textLabel7.Text = ""
											textLabel7.TextColor3 = Color3.fromRGB(140, 140, 150)
											textLabel7.TextScaled = true
											textLabel7.Visible = false
											fn62(textLabel7)
											textLabel7.Parent = frame9
											textLabel2 = textLabel7
											table.clear(iMap)

											for i_ = 1, n53 + 1 do
												iMap[i_] = fn70(i_)
											end
										end
									end
								end

								fn68 = function(arg, arg2, arg3, arg4, arg5)
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
										local v68 = fn69(arg2, arg3, arg4)

										if v68 then
											arg.ModelKey = modelKey

											local ok13, clone = pcall(function()
												return v68:Clone()
											end)

											if not (not ok13 or not clone) then
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

												local ok14, result14, vector = pcall(function()
													return clone:GetBoundingBox()
												end)

												local vector2 = ok14 and vector
												local n63 = 4

												if vector2 then
													n63 = math.max(vector.X, vector.Y, vector.Z)
												end

												local n64 = math.max(n63 * 1.05, 3)
												ok14 = ok14 and result14.Position or Vector3.zero
												arg.Camera.CFrame = CFrame.lookAt(ok14 + Vector3.new(n64 * 0.28, n64 * 0.08, -n64), ok14, Vector3.new(0, 1, 0))
												arg.Clone = clone
												local humanoid = v68:FindFirstChildWhichIsA("Humanoid") or v68:FindFirstChildWhichIsA("AnimationController")
												humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
												local humanoid2 = clone:FindFirstChildWhichIsA("Humanoid") or clone:FindFirstChildWhichIsA("AnimationController")
												humanoid2 = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")

												if humanoid and humanoid2 then
													local playingAnimationTracks = humanoid:GetPlayingAnimationTracks()
													playingAnimationTracks = playingAnimationTracks and playingAnimationTracks[1]

													if not (not playingAnimationTracks or not playingAnimationTracks.Animation) then
														local animation = Instance.new("Animation")
														animation.AnimationId = playingAnimationTracks.Animation.AnimationId

														local ok15, track = pcall(function()
															return humanoid2:LoadAnimation(animation)
														end)

														if ok15 and track then
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
							end

							local fn69

							do
								local fn70

								do
									fn70 = function()
										for _, v68 in ipairs(iMap) do
											local track = v68.Track
											local sourceTrack = v68.SourceTrack

											if track and sourceTrack and v68.Row.Visible and not pcall(function()
												if not track.IsPlaying then
													track:Play(0)
												end

												if math.abs(track.TimePosition - sourceTrack.TimePosition) > 0.2 then
													track.TimePosition = sourceTrack.TimePosition
												end
											end) then
												v68.Track = nil
												v68.SourceTrack = nil
											end
										end
									end

									do
										local function fn71(arg, arg2)
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

										fn69 = function()
											if not flag41 then
												if screenGui then
													destroyAll2()
												end
											else
												local now3 = os.clock()

												if not (now3 - n60 < n54) then
													n60 = now3
													local character_ = localPlayer.Character
													character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
													if not character_ then
														destroyAll2()
														return
													end
													fn67()
													fn28(false)
													local magnitude = nil
													local plot3 = nil

													for _, v68 in ipairs(tbl2) do
														if v68.Prompt.Parent then
															local magnitude2 = (character_.Position - v68.Spawn.Position).Magnitude

															if magnitude2 <= n52 and (not magnitude or magnitude2 < magnitude) then
																plot3 = v68.Plot
																magnitude = magnitude2
															end
														end
													end

													if plot3 then
														plot = plot3
														n61 = now3
													elseif plot and plot.Parent and now3 - n61 < 3 then
														plot3 = plot
													end

													local list2 = {}

													if plot3 then
														for _, v68 in ipairs(tbl2) do
															local prompt3 = v68.Prompt
															local parent2 = v68.Plot == plot3 and prompt3.Parent

															if parent2 then
																parent2 = tostring(prompt3.ObjectText or "") ~= ""
															end

															if parent2 then
																list2[#list2 + 1] = {
																	Podium = v68,
																	Distance = (character_.Position - v68.Spawn.Position).Magnitude,
																	Generation = v68.Generation or 0,
																}
															end
														end
													end

													local v68 = nil

													for _, v69 in ipairs(list2) do
														if not v68 or v69.Distance < v68.Distance then
															v68 = v69
														end
													end

													table.sort(list2, function(arg, arg2)
														return arg.Generation > arg2.Generation
													end)

													local list3 = {}

													if v68 then
														list3[#list3 + 1] = { Data = v68, Rank = 0 }
													end

													for i_ = 1, math.min(n58, #list2) do
														list3[#list3 + 1] = { Data = list2[i_], Rank = i_ }
													end

													local str7 = tostring(prompt2)

													for _, v69 in ipairs(list3) do
														str7 ..= "|" .. tostring(v69.Data.Podium.Prompt) .. ":" .. tostring(v69.Rank)
													end

													local flag42 = str7 ~= str5
													str5 = str7

													if textLabel then
														textLabel.Text = plot3 and string.format("%d brainrot here", #list2) or "walk into a base"
													end

													n62 = #list3
													plot2 = plot3
													fn64()

													if not flag40 then
														for i_, v69 in ipairs(iMap) do
															local v70 = list3[i_]

															if not v70 then
																v69.Row.Visible = false
																v69.Prompt = nil
																v69.RowKey = nil
																v69.Clone = nil
																v69.Track = nil
																v69.SourceTrack = nil
															else
																local podium = v70.Data.Podium
																local text = tostring(podium.Prompt.ObjectText or "")
																v69.Row.Visible = true
																v69.Prompt = podium.Prompt
																v69.RowKey = tostring(podium.Prompt) .. ":" .. tostring(v70.Rank)

																if v70.Rank == 0 then
																	v69.Rank.Text = "NEAR"
																	v69.Rank.TextColor3 = Color3.fromRGB(125, 205, 255)
																else
																	v69.Rank.Text = "#" .. v70.Rank
																	v69.Rank.TextColor3 = Color3.fromRGB(255, 214, 84)
																end

																v69.NameLabel.Text = text
																chilliGithubFastManualDefaultsRu.ApplyBrainrotNameStyle(v69.NameStyle, v70.Data.Generation)
																v69.ValueLabel.Text = fn27(v70.Data.Generation)

																if flag42 then
																	local v71 = fn65(podium.Spawn, text)
																	local mutation = v71 and v71:FindFirstChild("Mutation")

																	if mutation and mutation:IsA("TextLabel") and mutation.Visible and tostring(mutation.Text) ~= "" then
																		v69.MutationLabel.Text = mutation.Text
																		v69.MutationLabel.TextColor3 = mutation.TextColor3
																		v69.MutationLabel.RichText = mutation.RichText
																	else
																		v69.MutationLabel.Text = ""
																	end

																	fn71(v69, v71)
																end

																fn68(v69, podium.Plot, podium.Spawn, text, podium.Prompt)
															end
														end

														fn66()
														return
													end
												end
											end
										end
									end
								end

								fn23(RunService.Heartbeat:Connect(function()
									if flag27 then
										fn69()
									end
								end))

								do
									local n63 = 0

									fn23(RunService.Heartbeat:Connect(function()
										if flag27 and flag41 and screenGui then
											local now3 = os.clock()

											if not (now3 < n63) then
												n63 = now3 + 0.25
												fn70()
												return
											end
										end
									end))
								end
							end

							autoStealBrainrotSection:CreateToggle({
								Name = "Show Auto Steal Bar",
								Note = "Shows the current Auto Steal target and hold progress.",
								Default = true,
								Quick = false,
								SubOf = autoStealToggle,
								Callback = function(arg)
									flag30 = arg == true
									fn44()
								end,
							})

							autoStealBrainrotSection:CreateToggle({
								Name = "Show Distance Meter",
								Note = "Adds a live distance row to the bar, measured against Auto Steal Distance.",
								Default = false,
								Quick = false,
								SubOf = autoStealToggle,
								Callback = function(arg)
									fn42(arg == true)
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
									n59 = math.clamp((tonumber(arg) or 100) / 100, 0.6, 1.6)

									if clampValue2 then
										clampValue2()
									end
								end,
							})

							do
								local baseTargetPanelToggle = autoStealBrainrotSection:CreateToggle({
									Name = "Base Target Panel",
									Note = "Lists the nearest and highest Brainrots in this base; pick one to take it first.",
									Default = true,
									Quick = false,
									Callback = function(arg)
										flag41 = arg == true

										if not flag41 then
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
										local n63 = math.clamp(math.floor(tonumber(arg) or 5), 1, 5)

										if n58 ~= n63 then
											n58 = n63
											str5 = ""
											n60 = -math.huge

											if flag41 then
												fn69()
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
											fn28(false)
											local magnitude = nil
											local v68 = nil

											for _, v69 in ipairs(tbl2) do
												local prompt3 = v69.Prompt
												local parent2 = prompt3.Parent

												if parent2 then
													parent2 = tostring(prompt3.ObjectText or "") ~= ""
												end

												if parent2 then
													local magnitude2 = (character_.Position - v69.Spawn.Position).Magnitude

													if not magnitude or magnitude2 < magnitude then
														magnitude = magnitude2
														v68 = v69
													end
												end
											end

											if v68 then
												prompt2 = v68.Prompt
												str6 = tostring(v68.Prompt.ObjectText or "")
												fn60()
												str5 = ""
												fn66()
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
										str6 = ""
										str5 = ""
										fn66()
									end,
								})
							end
						end

						do
							local n63 = 0.05
							local n64 = 22
							local n65 = 9
							local v68 = nil
							local n66 = -math.huge
							local n67 = 0
							local flag42 = false
							local flag422 = nil

							fn23(RunService.RenderStepped:Connect(function(deltaTime)
								if flag27 and flag28 then
									fn41(deltaTime)
								elseif part then
									destroyAll()
								end

								if not flag27 or not flag28 or not flag30 then
									v68 = nil
									return
								end
								local now3 = os.clock()

								if now3 - n66 >= n63 then
									n66 = now3
									local str6, str7, generation

									if flag32 or localPlayer:GetAttribute("Stealing") == true then
										n67 = 0
										str6 = "GET READY - carrying brainrot"
										str7 = ""
										generation = nil
									else
										local character_ = localPlayer.Character
										character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

										if character_ then
											local v69, v70

											if flag29 then
												local v71, v72, v73
												v71, v72, v69, v73, v70 = fn37(character_)
											else
												local v71, v72, v73, v74
												v71, v72, v73, v74, v70 = fn37(character_)
												v69 = fn30(character_) or v72 or v74
											end

											if v69 then
												str6 = v69.Name
												str7 = fn27(v69.Generation)
												generation = v69.Generation
												local n68 = math.max(tonumber(n26), 1)
												n67 = 1 - math.clamp(v69.Distance / n68, 0, 1)

												if visible then
													str6 = string.format("%s   %.0f/%d", v69.Name, v69.Distance, n68)
												end

												local n69 = 10

												pcall(function()
													n69 = v69.Prompt.MaxActivationDistance
												end)

												flag42 = v69.Distance <= n69
											else
												str6 = v70 == 0 and "no steal prompts" or ""
												n67 = 0
												flag42 = false
												str7 = ""
												generation = nil
											end
										else
											n67 = 0
											flag42 = false
											str6 = ""
											str7 = ""
											generation = nil
										end
									end

									local str8 = tostring(str6) .. "\0" .. tostring(str7)

									if str8 ~= v68 then
										v68 = str8
										fn43(str6, str7, generation)
									end
								end

								if flag33 and localPlayer:GetAttribute("Stealing") == true then
									flag33 = false
								end

								local n68 = 0

								if flag33 then
									n68 = math.clamp((now3 - n32) / n33, 0, 1)
								end

								local n69 = math.min(deltaTime or 0.016, 0.1)
								n34 += (n68 - n34) * (1 - math.exp(-n69 * n64))

								if n68 <= 0 and n34 < 0.002 then
									n34 = 0
								end

								frame2.Size = UDim2.new(n34, 0, 1, 0)

								if visible then
									n35 += (n67 - n35) * (1 - math.exp(-n69 * n65))
									frame.Size = UDim2.new(n35, 0, 1, 0)

									if flag42 ~= flag422 then
										flag422 = flag42
										frame.BackgroundTransparency = 0.62
									end
								end
							end))
						end

						do
							local function fn65()
								if flag27 then
									flag27 = false
									flag28 = false
									flag32 = false
									n28 += 1
									fn40()
									disconnectAll()
									destroyAll()
									destroyAll2()
									fn61()

									if chilliAutoGetBarGui2 then
										pcall(function()
											chilliAutoGetBarGui2:Destroy()
										end)
									end

									if chilliMacLibTargetGui then
										pcall(function()
											chilliMacLibTargetGui:Destroy()
										end)
									end
								end
							end

							cleanup11.Event:Connect(fn65)
							chilliAutoGetRuntime2.Destroying:Connect(fn65)
						end

						flag = true
						flag2 = false
						n = 0
						connection9 = nil
						chilliDropBrainrotRuntime = CoreGui:FindFirstChild("__ChilliDropBrainrotRuntime")

						if chilliDropBrainrotRuntime then
							state = 66
						else
							state = 72
						end
					elseif state == 66 then
						cleanup12 = chilliDropBrainrotRuntime:FindFirstChild("Cleanup")

						if cleanup12 then
							state = 68
						else
							state = 67
						end
					end
				elseif state == 67 then
					cleanup6 = cleanup12
					state = 69
				elseif state == 68 then
					cleanup6 = cleanup12:IsA("BindableEvent")
					state = 69
				elseif state == 69 then
					if cleanup6 then
						state = 70
					else
						state = 71
					end
				elseif state == 70 then
					pcall(function()
						cleanup12:Fire()
					end)

					state = 71
				elseif state == 71 then
					pcall(function()
						chilliDropBrainrotRuntime:Destroy()
					end)

					state = 72
				elseif state == 72 then
					do
						local chilliDropBrainrotRuntime2 = Instance.new("Folder")
						chilliDropBrainrotRuntime2.Name = "__ChilliDropBrainrotRuntime"
						chilliDropBrainrotRuntime2.Archivable = false
						chilliDropBrainrotRuntime2.Parent = CoreGui
						local cleanup20 = Instance.new("BindableEvent")
						cleanup20.Name = "Cleanup"
						cleanup20.Parent = chilliDropBrainrotRuntime2

						local function fn60(arg)
							localPlayer:SetAttribute("ChilliDropBrainrotActive", arg == true)
						end

						local function fn61()
						end

						local function fn62()
							flag = false
							n += 1
							flag2 = false
							fn60(false)
							connection9:Disconnect()
							connection9 = nil
						end

						fn60(false)

						connection9 = localPlayer.CharacterAdded:Connect(function()
							n += 1
							flag2 = false
							fn60(false)
						end)

						cleanup20.Event:Connect(fn62)
						chilliDropBrainrotRuntime2.Destroying:Connect(fn62)
						autoStealBrainrotSection:CreateButton({ Name = "Drop Brainrot", ButtonText = "Drop", Callback = fn61 })
					end

					helperSection = helperTab:CreateSection({ Name = "Helper", Expanded = true })
					aimbotSection = helperTab:CreateSection({ Name = "Aimbot", Expanded = true })
					section = helperTab:CreateSection({ Name = "Movement & Combat", Expanded = true })
					unlockBaseSection = helperTab:CreateSection({ Name = "Unlock Base", Expanded = true })
					flag3 = false
					CoreGui3 = CoreGui

					pcall(function()
						if type(gethui) == "function" then
							local hui = gethui()

							if typeof(hui) == "Instance" then
								CoreGui3 = hui
							end
						end
					end)

					chilliUnlockBaseRuntime = CoreGui3:FindFirstChild("__ChilliUnlockBaseRuntime")

					if chilliUnlockBaseRuntime then
						state = 73
					else
						state = 79
					end
				elseif state == 73 then
					cleanup13 = chilliUnlockBaseRuntime:FindFirstChild("Cleanup")

					if cleanup13 then
						state = 75
					else
						state = 74
					end
				elseif state == 74 then
					cleanup14 = cleanup13
					state = 76
				elseif state == 75 then
					cleanup14 = cleanup13:IsA("BindableEvent")
					state = 76
				elseif state == 76 then
					if cleanup14 then
						state = 77
					else
						state = 78
					end
				elseif state == 77 then
					pcall(function()
						cleanup13:Fire()
					end)

					state = 78
				elseif state == 78 then
					pcall(function()
						chilliUnlockBaseRuntime:Destroy()
					end)

					state = 79
				elseif state == 79 then
					local chilliUnlockBaseRuntime2, cleanup20, fn60, fn61, fn62

					do
						local fn63

						do
							chilliUnlockBaseRuntime2 = Instance.new("Folder")
							chilliUnlockBaseRuntime2.Name = "__ChilliUnlockBaseRuntime"
							chilliUnlockBaseRuntime2.Archivable = false
							chilliUnlockBaseRuntime2.Parent = CoreGui3
							cleanup20 = Instance.new("BindableEvent")
							cleanup20.Name = "Cleanup"
							cleanup20.Parent = chilliUnlockBaseRuntime2

							fn63 = function()
								local character_ = localPlayer.Character
								if not character_ then
									return nil
								end
								return character_:FindFirstChild("HumanoidRootPart") or character_:FindFirstChild("UpperTorso")
							end

							do
								local function findFirstChild()
									return Workspace:FindFirstChild("Plots")
								end

								local function fn64(arg, arg2)
									local n52 = arg.X - arg2.X
									local n53 = arg.Z - arg2.Z
									return math.sqrt(n52 * n52 + n53 * n53)
								end

								local function fn65(arg, arg2)
									local animalPodiums = arg:FindFirstChild("AnimalPodiums")
									local huge = math.huge

									if animalPodiums then
										for _, child in ipairs(animalPodiums:GetChildren()) do
											local base = child:FindFirstChild("Base")
											base = base and base:FindFirstChild("Spawn")

											if base and base:IsA("BasePart") then
												huge = math.min(huge, fn64(arg2, base.Position))
											end
										end
									end

									if huge == math.huge then
										local ok13, result14 = pcall(function()
											return arg:GetPivot()
										end)

										if ok13 then
											huge = fn64(arg2, result14.Position)
										end
									end

									return huge
								end

								fn60 = function()
									local v68 = fn63()
									local firstChild = findFirstChild()
									if not v68 or not firstChild then
										return nil
									end
									local huge = math.huge
									local child = nil

									for _, child2 in ipairs(firstChild:GetChildren()) do
										local v69 = fn65(child2, v68.Position)

										if v69 < huge then
											huge = v69
											child = child2
										end
									end

									return child
								end

								fn61 = function(arg)
									local firstChild = findFirstChild()

									while arg and arg ~= Workspace do
										if arg.Parent == firstChild then
											return arg
										end
										arg = arg.Parent
									end

									return nil
								end
							end
						end

						do
							local function fn64(arg)
								arg = arg and arg:FindFirstChild("AnimalPodiums")
								local ys = {}
								if not arg then
									return ys
								end

								for _, child in ipairs(arg:GetChildren()) do
									local base = child:FindFirstChild("Base")
									base = base and base:FindFirstChild("Spawn")

									if base and base:IsA("BasePart") then
										local y2 = base.Position.Y
										local flag40 = false

										for _, v68 in ipairs(ys) do
											if math.abs(v68 - y2) < 1 then
												flag40 = true
												break
											end
										end

										if not flag40 then
											ys[#ys + 1] = y2
										end
									end
								end

								table.sort(ys)
								return ys
							end

							local function fn65(arg, arg2)
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

							fn62 = function(arg, arg2)
								local v68 = fn64(arg2)
								local v69 = fn65(arg, arg2)

								if v69 and #v68 > 0 then
									local huge = math.huge
									local n52 = 1

									for i_, v70 in ipairs(v68) do
										local n53 = math.abs(v69 - v70)

										if n53 < huge then
											huge = n53
											n52 = i_
										end
									end

									return math.clamp(n52, 1, 3)
								end

								local v70 = fn63()
								if not v70 or #v68 == 0 then
									return 1
								end
								local y2 = v68[1]

								local ok13, result14 = pcall(function()
									return arg2:GetPivot()
								end)

								if ok13 then
									y2 = result14.Position.Y
								end

								local n52 = v68[1] - y2
								local n53 = 1

								for i_ = 2, math.min(#v68, 3) do
									if v68[i_] - n52 <= v70.Position.Y then
										n53 = i_
									end
								end

								return n53
							end
						end
					end

					local fn63, connection12

					do
						local fn64

						do
							do
								local function fn65(arg)
									arg = arg and arg:FindFirstChild("Unlock")
									local list2 = {}
									if not arg then
										return list2
									end

									for _, child in ipairs(arg:GetChildren()) do
										local position

										if child:IsA("Model") then
											local ok13, result14 = pcall(function()
												return child:GetPivot()
											end)

											position = nil

											if ok13 then
												position = result14.Position
											end
										else
											position = nil

											if child:IsA("BasePart") then
												position = child.Position
											end
										end

										if position then
											list2[#list2 + 1] = { Instance = child, Y = position.Y }
										end
									end

									table.sort(list2, function(arg2, arg3)
										return arg2.Y < arg3.Y
									end)

									return list2
								end

								fn64 = function(arg, arg2)
									local v68 = fireproximityprompt

									if type(v68) == "function" then
										local v69 = fn65(arg)[arg2]

										if v69 then
											local flag40 = false

											for _, descendant in ipairs(v69.Instance:GetDescendants()) do
												if descendant:IsA("ProximityPrompt") then
													flag40 = pcall(v68, descendant) or flag40
												end
											end

											return flag40
										end
									end

									return false
								end
							end
						end

						fn63 = function(arg)
							local v68 = fn60()

							if v68 then
								fn64(v68, arg)
							end
						end

						do
							local function fn65(arg)
								if not arg or not arg:IsA("ProximityPrompt") then
									return false
								end
								return string.find(string.lower(tostring(arg.ActionText or "")), "steal", 1, true) ~= nil
							end

							connection12 = ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt3, player)
								if not (player and player ~= localPlayer or not fn65(prompt3)) then
									local v68 = fn61(prompt3) or fn60()

									if v68 then
										local v69 = fn62(prompt3, v68)
										task.defer(fn64, v68, v69)
										return
									end
								end
							end)
						end
					end

					do
						local function fn64(arg)
							arg._quickBarDefault = 4
							return arg
						end

						fn64(unlockBaseSection:CreateToggle({
							Name = "Auto Unlock Base",
							Note = "Unlocks the current floor when you start stealing. Requires Robux.",
							Default = false,
							Pin = true,
							QuickBar = 4,
							Callback = function(arg)
								flag3 = arg == true
							end,
						}))

						fn64(unlockBaseSection:CreateButton({
							Name = "Unlock Floor 3",
							ButtonText = "Unlock",
							Note = "Unlocks Floor 3 of the nearest base. Requires Robux.",
							Pin = true,
							QuickBar = 4,
							Callback = function()
								fn63(3)
							end,
						}))

						fn64(unlockBaseSection:CreateButton({
							Name = "Unlock Floor 2",
							ButtonText = "Unlock",
							Note = "Unlocks Floor 2 of the nearest base. Requires Robux.",
							Pin = true,
							QuickBar = 4,
							Callback = function()
								fn63(2)
							end,
						}))

						fn64(unlockBaseSection:CreateButton({
							Name = "Unlock Floor 1",
							ButtonText = "Unlock",
							Note = "Unlocks Floor 1 of the nearest base. Requires Robux.",
							Pin = true,
							QuickBar = 4,
							Callback = function()
								fn63(1)
							end,
						}))
					end

					do
						local function fn64()
							flag3 = false
							connection12:Disconnect()
							connection12 = nil
						end

						cleanup20.Event:Connect(fn64)
						chilliUnlockBaseRuntime2.Destroying:Connect(fn64)
					end

					chilliHelperLocalRuntime = CoreGui:FindFirstChild("__ChilliHelperLocalRuntime")

					if chilliHelperLocalRuntime then
						state = 80
					else
						state = 86
					end
				end
			elseif state <= 92 then
				if state == 80 then
					cleanup15 = chilliHelperLocalRuntime:FindFirstChild("Cleanup")

					if cleanup15 then
						state = 82
					else
						state = 81
					end
				elseif state == 81 then
					cleanup7 = cleanup15
					state = 83
				elseif state == 82 then
					cleanup7 = cleanup15:IsA("BindableEvent")
					state = 83
				elseif state == 83 then
					if cleanup7 then
						state = 84
					else
						state = 85
					end
				elseif state == 84 then
					pcall(function()
						cleanup15:Fire()
					end)

					state = 85
				elseif state == 85 then
					pcall(function()
						chilliHelperLocalRuntime:Destroy()
					end)

					state = 86
				elseif state == 86 then
					do
						do
							do
								do
									local n52, humanoid, tbl14, connections3, n53, fn60

									do
										do
											local chilliHelperLocalRuntime2 = Instance.new("Folder")
											chilliHelperLocalRuntime2.Name = "__ChilliHelperLocalRuntime"
											chilliHelperLocalRuntime2.Archivable = false
											chilliHelperLocalRuntime2.Parent = CoreGui
											local cleanup20 = Instance.new("BindableEvent")
											cleanup20.Name = "Cleanup"
											cleanup20.Parent = chilliHelperLocalRuntime2
											flag34 = true
											local list2 = {}

											fn45 = function(arg)
												list2[#list2 + 1] = arg
											end

											local function fn61()
												if not flag34 then
													return
												end
												flag34 = false

												for _, v68 in ipairs(list2) do
													pcall(v68)
												end

												table.clear(list2)
											end

											cleanup20.Event:Connect(fn61)
											chilliHelperLocalRuntime2.Destroying:Connect(fn61)
										end

										do
											local function fn61()
												if localPlayer:GetAttribute("BlockTools") == true then
													localPlayer:SetAttribute("BlockTools", false)
												end
											end

											fn61()
											local connection12 = localPlayer:GetAttributeChangedSignal("BlockTools"):Connect(fn61)

											fn45(function()
												if connection12 then
													connection12:Disconnect()
													connection12 = nil
												end
											end)
										end

										tbl3 = { ProtectedHumanoid = nil, RescueSerial = 0 }
										n52 = 0.5
										humanoid = nil
										tbl14 = nil
										connections3 = {}
										n53 = 0

										do
											local function disconnectAll3()
												for _, v68 in ipairs(connections3) do
													if v68.Connected then
														v68:Disconnect()
													end
												end

												table.clear(connections3)
											end

											fn60 = function()
												disconnectAll3()
												local humanoid2 = humanoid
												local tbl142 = tbl14
												humanoid = nil
												tbl14 = nil
												tbl3.ProtectedHumanoid = nil
												if not humanoid2.Parent or not tbl142 then
													return
												end

												pcall(function()
													humanoid2.BreakJointsOnDeath = tbl142.BreakJointsOnDeath
													humanoid2.RequiresNeck = tbl142.RequiresNeck
													humanoid2:SetStateEnabled(Enum.HumanoidStateType.Dead, tbl142.DeadStateEnabled)
												end)
											end
										end
									end

									do
										do
											local function fn61(arg)
												if not arg or not arg.Parent then
													return false
												end

												return pcall(function()
													arg.BreakJointsOnDeath = false
													arg.RequiresNeck = false
													arg:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
												end) and arg.BreakJointsOnDeath == false and arg.RequiresNeck == false and arg:GetStateEnabled(Enum.HumanoidStateType.Dead) == false
											end

											local function fn62(arg)
												if arg ~= humanoid or not arg or not arg.Parent then
												end

												return false
											end

											local function fn63(arg)
												fn60()

												if not (not flag34 or not arg or arg ~= localPlayer.Character) then
													local humanoid2 = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)

													if not (not flag34 or arg ~= localPlayer.Character or not humanoid2 or not humanoid2:IsA("Humanoid")) then
														humanoid = humanoid2
														tbl3.ProtectedHumanoid = humanoid2

														tbl14 = {
															BreakJointsOnDeath = humanoid2.BreakJointsOnDeath,
															RequiresNeck = humanoid2.RequiresNeck,
															DeadStateEnabled = humanoid2:GetStateEnabled(Enum.HumanoidStateType.Dead),
														}

														if not fn61(humanoid2) or not fn62(humanoid2) then
															fn60()
															return false
														end

														connections3[#connections3 + 1] = humanoid2.HealthChanged:Connect(function()
															fn62(humanoid2)
														end)

														connections3[#connections3 + 1] = humanoid2:GetPropertyChangedSignal("MaxHealth"):Connect(function()
															fn62(humanoid2)
														end)

														connections3[#connections3 + 1] = humanoid2.StateChanged:Connect(function(old, new)
															if new == Enum.HumanoidStateType.Dead then
																fn61(humanoid2)
																fn62(humanoid2)
															end
														end)

														n53 = os.clock()
														return true
													end
												end

												return false
											end

											local connection12 = localPlayer.CharacterAdded:Connect(function(character_)
												fn63(character_)
											end)

											local connection13 = RunService.Heartbeat:Connect(function()
												local now3 = os.clock()

												if now3 - n53 >= n52 then
													n53 = now3
													fn61(humanoid)
													fn62(humanoid)
												end
											end)

											task.spawn(function()
												fn63(localPlayer.Character)
											end)

											fn45(function()
												fn60()
												connection12:Disconnect()
												connection12 = nil
												connection13:Disconnect()
												connection13 = nil
											end)
										end
									end
								end

								do
									do
										local n52 = 2

										fn46 = function(arg)
											local character_ = localPlayer.Character
											local backpack2 = localPlayer:FindFirstChildOfClass("Backpack")
											return character_ and character_:FindFirstChild(arg) or backpack2 and backpack2:FindFirstChild(arg)
										end

										fn47 = function(arg)
											local v68 = fn46(arg)
											if v68 then
												return v68
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
												local ok13, result14 = pcall(getconnections, playerGui.Activated)

												if not (not ok13 or type(result14) ~= "table") then
													local flag40 = false

													for _, v69 in ipairs(result14) do
														if v69.Enabled and type(v69.Fire) == "function" and pcall(function()
															v69:Fire()
														end) then
															flag40 = true
															break
														end
													end

													if flag40 then
														local now3 = os.clock()

														while true do
															local v69 = fn46(arg)

															if v69 then
																return v69
															else
																RunService.Heartbeat:Wait()
																if not (n52 <= os.clock() - now3) then
																	continue
																end
																break
															end
														end

														return fn46(arg), "cash"
													end
												end
											end

											return nil, "unavailable"
										end
									end
								end

								fn48 = function(arg, arg2)
									local str5

									if arg2 == "rebirth" then
										str5 = "A higher Rebirth level is required for " .. arg .. "."
									elseif arg2 == "cash" then
										str5 = "Not enough cash to buy " .. arg .. "."
									else
										str5 = "Unable to buy " .. arg .. " right now."
									end

									v36.Notify("Tool unavailable", str5, 5)
								end

								do
									local n52 = 0

									runUntilTimeout2 = function(arg)
										local max = math.max
										local n522 = n52
										n52 = max(n522, os.clock() + (tonumber(arg) or 1))
									end

									fn49 = function()
										return os.clock() < n52
									end
								end
							end

							do
								local n52, flag40, flag41, n53, connection12, connection13, connection14, n54, v68, fn60
								local fn61, fn62, fn63

								do
									local n55, n56, n57, position, playerMap, n58, fn64

									do
										n55 = 0.02
										n56 = 5
										n57 = 7
										n52 = 2
										flag40 = false
										flag41 = false
										n53 = 0
										connection12 = nil
										connection13 = nil
										connection14 = nil
										position = nil
										playerMap = {}
										n58 = 0
										n54 = 0
										v68 = nil
										fn60 = nil

										fn64 = function(arg)
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

										do
											local function fn65()
												local character_ = localPlayer.Character
												return character_ and character_:FindFirstChild("Body Swap Potion") or localPlayer.Backpack:FindFirstChild("Body Swap Potion")
											end

											fn61 = function(arg)
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
														local tool2 = character_:FindFirstChildWhichIsA("Tool")

														if tool2 == bodySwapTool then
															pcall(function()
																bodySwapTool:Deactivate()
																bodySwapTool.Parent = localPlayer.Backpack
															end)

															tool2 = nil
														end

														if not tool2 and previousToolState and previousToolState.Tool.Parent == localPlayer.Backpack then
															pcall(function()
																runUntilTimeout2(0.5)
																humanoid:EquipTool(previousToolState.Tool)
															end)
														end
													end
												end
											end

											fn62 = function()
												local character_ = localPlayer.Character
												local v69 = fn65()
												if not v69 or not v69.Parent then
													return
												end

												pcall(function()
													v69:Deactivate()
													v69.Enabled = true

													if v69.Parent == character_ then
														v69.Parent = localPlayer.Backpack
													end
												end)
											end
										end
									end

									do
										local function fn65()
										end

										fn60 = function()
											position = nil
											table.clear(playerMap)
											n58 = 0
										end

										fn63 = function(deltaTime)
											if localPlayer:GetAttribute("Stealing") == true then
												n54 = os.clock() + n52
											end

											n58 += deltaTime

											if not (n58 < n55) then
												n58 = 0
												local v69 = fn64(localPlayer)
												if not v69 then
													fn60()
													return
												end
												local position2 = v69.Position

												if position and not flag41 then
													for _, player in ipairs(Players:GetPlayers()) do
														if player ~= localPlayer then
															local v70 = fn64(player)
															local playerEntry = playerMap[player]

															if v70 and playerEntry then
																local position3 = v70.Position
																if (position2 - position).Magnitude >= n56 and (position3 - playerEntry).Magnitude >= n56 and (position2 - playerEntry).Magnitude <= n57 and (position3 - position).Magnitude <= n57 then
																	fn65(position, player, localPlayer:GetAttribute("Stealing") == true or os.clock() <= n54)
																	break
																end
															end
														end
													end
												end

												position = position2

												for _, player in ipairs(Players:GetPlayers()) do
													if player ~= localPlayer then
														local v70 = fn64(player)
														playerMap[player] = v70 and v70.Position or nil
													end
												end
											end
										end
									end
								end

								do
									local function fn64()
										local v682 = v68
										v68 = nil
										flag40 = false
										flag41 = false
										n53 += 1
										fn61(v682)
										fn62()
										fn60()

										if connection12 then
											connection12:Disconnect()
											connection12 = nil
										end

										if connection13 then
											connection13:Disconnect()
											connection13 = nil
										end

										if connection14 then
											connection14:Disconnect()
											connection14 = nil
										end
									end

									local function fn65()
										fn64()
										flag40 = true
										fn60()
										local bodySwapPotion, v69 = fn47("Body Swap Potion")

										if not bodySwapPotion then
											fn48("Body Swap Potion", v69)
										end

										connection13 = localPlayer.CharacterAdded:Connect(function()
											n53 += 1
											local v682 = v68
											v68 = nil
											fn61(v682)
											flag41 = false
											fn60()
											task.defer(fn62)
										end)

										connection14 = localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
											if localPlayer:GetAttribute("Stealing") == true then
												n54 = os.clock() + n52
											end
										end)

										if localPlayer:GetAttribute("Stealing") == true then
											n54 = os.clock() + n52
										end

										connection12 = RunService.Heartbeat:Connect(fn63)
										return true
									end

									fn45(fn64)

									helperSection:CreateToggle({
										Name = "Anti Body Swap",
										Default = true,
										Callback = function(arg)
											if arg then
												fn65()
											else
												fn64()
											end
										end,
									})
								end
							end
						end

						do
							local flag40, connections3, n52, n53, destroyAll2, fn60, disconnectAll3, fn61, fn62, fn63
							local fn64, fn65, fn66, fn67, fn68, fn69

							do
								local connections4, connections5, obj4, obj5, v68, v69, v70, v71, currentCamera2, humanoid
								local flag41, fieldOfView, vector3Zero

								do
									flag40 = false
									connections3 = {}
									connections4 = {}
									connections5 = {}
									obj4 = setmetatable({}, { __mode = "k" })
									obj5 = setmetatable({}, { __mode = "k" })

									do
										local obj6 = setmetatable({}, { __mode = "k" })
										local obj7 = setmetatable({}, { __mode = "k" })
										local obj8 = setmetatable({}, { __mode = "k" })
										v68 = nil
										v69 = nil
										v70 = nil
										v71 = nil
										n52 = 0
										n53 = 0
										currentCamera2 = nil
										humanoid = nil
										flag41 = false
										fieldOfView = 70
										vector3Zero = Vector3.zero

										local enabledFlags3 = {
											Blue = true,
											DiscoEffect = true,
											BeeBlur = true,
											ColorCorrection = true,
										}

										destroyAll2 = nil
										fn60 = nil

										disconnectAll3 = function(arg)
											for _, v72 in ipairs(arg) do
												if typeof(v72) == "RBXScriptConnection" then
													v72:Disconnect()
												end
											end

											table.clear(arg)
										end

										local fn70 = nil

										fn70 = function(arg, arg2, arg3)
											if not (typeof(arg) ~= "function" or arg2 > 3 or arg3[arg]) then
												arg3[arg] = true
												local ok13, result14 = pcall(debug.getconstants, arg)
												local flag42 = false
												local flag43 = false
												local flag44 = false

												if ok13 then
													for _, v72 in ipairs(result14) do
														if type(v72) == "string" then
															local str5 = string.lower(v72)

															if string.find(str5, "discoeffect", 1, true) then
																flag43 = true
															end

															if string.find(str5, "boogie", 1, true) then
																flag42 = true
															end

															if str5 == "fieldofview" then
																flag44 = true
															end
														end
													end
												end

												if not (flag43 and (flag42 or flag44)) then
													local ok14, result15 = pcall(debug.getprotos, arg)

													if ok14 then
														for _, v72 in ipairs(result15) do
															if fn70(v72, arg2 + 1, arg3) then
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

										local function fn71(arg)
											local enabled = nil

											return pcall(function()
												enabled = arg.Enabled
											end) and enabled == true
										end

										local function fn72(arg)
											if typeof(arg) ~= "function" then
												return false
											end
											local ok13, result14 = pcall(debug.info, arg, "s")
											return ok13 and type(result14) == "string" and string.find(string.lower(result14), "paintballguncontroller", 1, true) ~= nil
										end

										local function fn73(arg)
											if flag34 and fn71(arg) and pcall(function()
												arg:Disable()
											end) then
												obj7[arg] = true
											end
										end

										fn61 = function(arg)
											if not (not flag34 or not arg or not arg.Parent or not arg:IsA("RemoteEvent")) then
												local ok13, result14 = pcall(getconnections, arg.OnClientEvent)

												if ok13 then
													for _, v72 in ipairs(result14) do
														if not obj8[v72] then
															obj8[v72] = true
															local function_ = nil

															pcall(function()
																function_ = v72.Function
															end)

															if fn70(function_, 1, {}) or fn72(function_) then
																obj6[v72] = true
																fn73(v72)
															end
														end
													end
												end
											end
										end

										fn62 = function()
											n53 += 1
											local n532 = n53

											task.spawn(function()
												local list2 = { { Object = Lighting, Kind = "Lighting" }, { Object = ReplicatedStorage, Kind = "Remotes" } }
												local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

												if playerScripts then
													list2[#list2 + 1] = { Object = playerScripts, Kind = "Sounds" }
												end

												local n54 = 1

												while flag34 and n53 == n532 and n54 <= #list2 do
													local now3 = os.clock()
													local n55 = 0

													while true do
														local v72 = list2[n54]
														n54 += 1
														local object = v72.Object

														if object and object.Parent then
															if v72.Kind == "Lighting" then
																destroyAll2(object)
															elseif v72.Kind == "Sounds" then
																fn60(object)
															elseif v72.Kind == "Remotes" and object:IsA("RemoteEvent") then
																fn61(object)
															end

															local tbl14 = {}

															pcall(function()
																tbl14 = object:GetChildren()
															end)

															for _, v73 in ipairs(tbl14) do
																list2[#list2 + 1] = { Object = v73, Kind = v72.Kind }
															end
														end

														n55 += 1
														if not (n54 > #list2 or n55 >= 20 or os.clock() - now3 >= 0.0015) then
															continue
														end
														break
													end

													if n54 <= #list2 then
														RunService.Heartbeat:Wait()
													end
												end
											end)
										end

										fn63 = function()
											for k in pairs(obj7) do
												pcall(function()
													if not k.Enabled then
														k:Enable()
													end
												end)
											end

											table.clear(obj7)
											table.clear(obj6)
											table.clear(obj8)
										end

										destroyAll2 = function(arg)
											if arg and arg.Parent and enabledFlags3[arg.Name] then
												pcall(function()
													arg:Destroy()
												end)
											end
										end
									end
								end

								fn64 = function()
									return localPlayer:GetAttribute("ChilliTpMoving") == true or localPlayer:GetAttribute("Teleporting") == true
								end

								fn60 = function(arg)
									if not (not arg or not arg:IsA("Sound") or arg.Name ~= "Buzzing") then
										if obj5[arg] == nil then
											obj5[arg] = arg.Volume
										end

										local flag42 = false

										local function fn70()
											if flag42 or not flag40 or not arg.Parent then
												return
											end
											flag42 = true

											pcall(function()
												if arg.Playing then
													arg:Stop()
												end

												if arg.Volume ~= 0 then
													arg.Volume = 0
												end
											end)

											flag42 = false
										end

										fn70()

										if not obj4[arg] then
											obj4[arg] = true
											connections4[#connections4 + 1] = arg:GetPropertyChangedSignal("Volume"):Connect(fn70)
											connections4[#connections4 + 1] = arg:GetPropertyChangedSignal("Playing"):Connect(fn70)
											return
										end
									end
								end

								do
									local function fn70()
										if flag41 or not flag40 then
											return
										end
										flag41 = true

										pcall(function()
											if currentCamera2 and currentCamera2.Parent and currentCamera2.FieldOfView ~= fieldOfView then
												currentCamera2.FieldOfView = fieldOfView
											end

											if humanoid and humanoid.Parent and humanoid.CameraOffset ~= vector3Zero then
												humanoid.CameraOffset = vector3Zero
											end
										end)

										flag41 = false
									end

									fn65 = function()
										disconnectAll3(connections5)
										currentCamera2 = Workspace.CurrentCamera
										local character_ = localPlayer.Character
										humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
										fn70()

										if currentCamera2 then
											connections5[#connections5 + 1] = currentCamera2:GetPropertyChangedSignal("FieldOfView"):Connect(fn70)
										end

										if humanoid then
											connections5[#connections5 + 1] = humanoid:GetPropertyChangedSignal("CameraOffset"):Connect(fn70)
										end
									end
								end

								fn66 = function()
									disconnectAll3(connections5)
									currentCamera2 = nil
									humanoid = nil
									flag41 = false
								end

								fn67 = function()
									pcall(function()
										v68.moveFunction = v70
									end)

									v68 = nil
									v69 = nil
									v70 = nil
									v71 = nil
								end

								fn68 = function()
									if v68.moveFunction ~= v71 then
										v68.moveFunction = v71
									end
								end

								fn69 = function()
									disconnectAll3(connections4)

									for k, v72 in pairs(obj5) do
										if k and k.Parent then
											pcall(function()
												k.Volume = v72
											end)
										end
									end

									table.clear(obj4)
									table.clear(obj5)
								end
							end

							local flag41, connection12, connection13, isModel, fn70, fn71

							do
								do
									do
										local function fn72()
											flag40 = false
											n52 += 1
											n53 += 1
											disconnectAll3(connections3)
											fn63()
											fn66()
											fn67()
											fn69()
										end

										local function fn73()
											fn72()
											flag40 = true
											n52 += 1
											local n522 = n52
											fn68()
											fn65()
											fn62()

											connections3[#connections3 + 1] = Lighting.DescendantAdded:Connect(function(descendant)
												if flag40 then
													destroyAll2(descendant)
												end
											end)

											connections3[#connections3 + 1] = ReplicatedStorage.DescendantAdded:Connect(function(descendant)
												if flag40 and descendant:IsA("RemoteEvent") then
													task.defer(function()
														fn61(descendant)
													end)

													task.delay(0.5, function()
														fn61(descendant)
													end)
												end
											end)

											local playerScripts = localPlayer:FindFirstChild("PlayerScripts")

											if playerScripts then
												connections3[#connections3 + 1] = playerScripts.DescendantAdded:Connect(function(descendant)
													if flag40 then
														fn60(descendant)
													end
												end)
											end

											connections3[#connections3 + 1] = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
												if flag40 then
													fn65()
												end
											end)

											connections3[#connections3 + 1] = localPlayer.CharacterAdded:Connect(function(character_)
												task.spawn(function()
													character_:WaitForChild("Humanoid", 5)

													if flag40 and character_ == localPlayer.Character then
														fn65()
													end
												end)
											end)

											task.spawn(function()
												while true do
													if flag40 and flag34 and n52 == n522 then
														task.wait(0.1)

														if not (not flag40 or not flag34 or n52 ~= n522) then
															if not fn64() then
																fn68()
															end

															continue
														end
													end

													break
												end
											end)
										end

										fn45(fn72)

										helperSection:CreateToggle({
											Name = "Anti Bee, Disco & Paintball Effect",
											Default = true,
											Callback = function(arg)
												if arg then
													fn73()
												else
													fn72()
												end
											end,
										})
									end
								end

								do
									local n54 = 1.06
									local vector = Vector3.new(2.9, 1.15, 2.9)
									local color3 = Color3.fromRGB(255, 45, 45)
									local lineThickness = 0.03
									flag41 = false
									connection12 = nil
									connection13 = nil
									local tbl14 = {}

									isModel = function(arg)
										return arg:IsA("Model") and arg.Name:match("^Trap") ~= nil
									end

									local function fn72(arg, arg2)
										local v68 = arg:FindFirstChild(arg2)
										if v68 and v68:IsA("BasePart") then
											return v68
										end

										for _, descendant in ipairs(arg:GetDescendants()) do
											if descendant.Name == arg2 and descendant:IsA("BasePart") then
												return descendant
											end
										end

										return nil
									end

									local function fn73(arg)
										local v68 = tbl14[arg]

										if v68 then
											tbl14[arg] = nil

											if v68.Connection then
												pcall(function()
													v68.Connection:Disconnect()
												end)
											end

											for _, propertyConnection in ipairs(v68.PropertyConnections) do
												pcall(function()
													propertyConnection:Disconnect()
												end)
											end

											table.clear(v68.PropertyConnections)

											if v68.Outline then
												pcall(function()
													v68.Outline:Destroy()
												end)
											end

											if v68.Target and v68.Target.Parent then
												pcall(function()
													v68.Target.Size = v68.OriginalSize
													v68.Target.CFrame = v68.OriginalCFrame
													v68.Target.CanCollide = v68.OriginalCanCollide
													v68.Target.CanTouch = v68.OriginalCanTouch
												end)
											end
										end
									end

									fn70 = function()
										for k in pairs(tbl14) do
											fn73(k)
										end

										table.clear(tbl14)
									end

									local function fn74(arg, arg2)
										local character_ = localPlayer.Character
										character_ = character_ and character_:FindFirstChild("HumanoidRootPart")
										if not character_ then
											return false
										end
										local vector2 = arg:PointToObjectSpace(character_.Position)
										local vector3 = arg2 * 0.5
										local x = vector3.X
										local flag42 = math.abs(vector2.X) <= x

										if flag42 then
											local y2 = vector3.Y
											flag42 = math.abs(vector2.Y) <= y2
										end

										if flag42 then
											local z = vector3.Z
											flag42 = math.abs(vector2.Z) <= z
										end

										return flag42
									end

									fn71 = function(arg)
										if not tbl14[arg] then
											local open = fn72(arg, "Open")
											local close = fn72(arg, "Close")

											if not (not open or not close) then
												local boundingBox, v68 = arg:GetBoundingBox()
												local vector2 = v68 * n54 + vector
												local n55 = math.max(vector2.X, vector2.Z)
												local vector3 = Vector3.new(n55, vector2.Y, n55)

												if not fn74(open.CFrame, vector3) then
													local tbl15 = {
														Target = close,
														OriginalSize = close.Size,
														OriginalCFrame = close.CFrame,
														OriginalCanCollide = close.CanCollide,
														OriginalCanTouch = close.CanTouch,
														PropertyConnections = {},
													}

													tbl14[arg] = tbl15
													local flag42 = false

													local function fn75()
														if flag42 or not flag41 or not close.Parent or not open.Parent then
															return
														end
														flag42 = true

														pcall(function()
															close.Size = vector3
															close.CFrame = open.CFrame
															close.CanCollide = true
															close.CanTouch = false
														end)

														flag42 = false
													end

													fn75()
													tbl15.PropertyConnections[#tbl15.PropertyConnections + 1] = close:GetPropertyChangedSignal("Size"):Connect(fn75)
													tbl15.PropertyConnections[#tbl15.PropertyConnections + 1] = close:GetPropertyChangedSignal("CFrame"):Connect(fn75)
													tbl15.PropertyConnections[#tbl15.PropertyConnections + 1] = close:GetPropertyChangedSignal("CanCollide"):Connect(fn75)
													tbl15.PropertyConnections[#tbl15.PropertyConnections + 1] = close:GetPropertyChangedSignal("CanTouch"):Connect(fn75)
													tbl15.PropertyConnections[#tbl15.PropertyConnections + 1] = open:GetPropertyChangedSignal("CFrame"):Connect(fn75)
													local selectionBox = Instance.new("SelectionBox")
													selectionBox.Name = fn20()
													selectionBox.Adornee = close
													selectionBox.Archivable = false
													selectionBox.Color3 = color3
													selectionBox.LineThickness = lineThickness
													selectionBox.SurfaceTransparency = 1
													selectionBox.Transparency = 0
													selectionBox.Parent = close
													tbl15.Outline = selectionBox

													tbl15.Connection = arg.AncestryChanged:Connect(function(child, parent2)
														if not parent2 then
															fn73(arg)
														end
													end)

													return
												end
											end
										end
									end
								end
							end

							do
								local function fn72()
									for _, child in ipairs(Workspace:GetChildren()) do
										if isModel(child) then
											fn71(child)
										end
									end
								end

								local function fn73()
									flag41 = false
									connection13:Disconnect()
									connection13 = nil
									connection12:Disconnect()
									connection12 = nil
									fn70()
								end

								local function fn74()
									fn73()
									flag41 = true
									fn72()

									connection13 = Workspace.ChildAdded:Connect(function(child)
										if not flag41 or not isModel(child) then
											return
										end

										task.defer(function()
											if flag41 and child.Parent then
												fn71(child)
											end
										end)
									end)

									connection12 = localPlayer.CharacterAdded:Connect(function()
										if flag41 then
											task.defer(fn72)
										end
									end)
								end

								fn45(fn73)

								helperSection:CreateToggle({
									Name = "Anti Trap",
									Default = true,
									Callback = function(arg)
										if arg then
											fn74()
										else
											fn73()
										end
									end,
								})
							end
						end
					end

					local flag40, flag41, flag42, n52, fn60, fn61, cleanupRenderStep, fn62, fn63, fn64

					do
						do
							local flag43, n53, connection12, kMap, v68, v69, n54, fn65, fn66, fn67
							local fn68, fn69, fn70, fn71, fn72

							do
								flag43 = false
								n53 = 0
								connection12 = nil
								kMap = {}

								do
									local tbl14 = {}
									v68 = nil
									v69 = nil
									n54 = 0
									local str5 = "Sentry_" .. tostring(localPlayer.UserId)

									fn65 = function(arg)
										local isModel

										if arg then
											isModel = arg:IsA("Model") or arg:IsA("BasePart")
										else
											isModel = arg
										end

										return isModel and arg.Name:match("^Sentry_") ~= nil and arg.Name ~= str5
									end

									fn66 = function(arg)
										if arg:IsA("BasePart") then
											return arg
										end
										return arg:FindFirstChildWhichIsA("BasePart", true)
									end

									fn67 = function(arg)
										return arg:FindFirstChild("SetupReady", true) ~= nil
									end

									fn68 = function(arg)
										arg = arg and arg:FindFirstChildWhichIsA("Tool")
										if arg and arg.Name:lower():find("bat", 1, true) then
											return arg
										end
										local backpack2 = localPlayer:FindFirstChildOfClass("Backpack")

										if backpack2 then
											for _, child in ipairs(backpack2:GetChildren()) do
												if child:IsA("Tool") and child.Name:lower():find("bat", 1, true) then
													return child
												end
											end

											return nil
										end

										return s4
									end

									fn69 = function()
										local v682 = v68
										local v692 = v69
										v68 = nil
										v69 = nil

										if v682.Parent then
											local character_ = localPlayer.Character
											local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
											local backpack2 = localPlayer:FindFirstChildOfClass("Backpack")

											if not (not character_ or not humanoid or humanoid.Health <= 0 or v682.Parent ~= character_ and v682.Parent ~= backpack2) then
												local tool2 = character_:FindFirstChildWhichIsA("Tool")

												if tool2 ~= v682 and not (tool2 and tool2 ~= v692) then
													pcall(function()
														runUntilTimeout2(0.5)
														humanoid:EquipTool(v682)
													end)

													return
												end
											end
										end
									end

									fn70 = function()
										return localPlayer:GetAttribute("Stealing") == true or localPlayer:GetAttribute("ChilliTpMoving") == true or localPlayer:GetAttribute("Teleporting") == true
									end

									fn71 = function(arg)
										if not tbl14[arg] then
											tbl14[arg] = { CanCollide = arg.CanCollide, Transparency = arg.Transparency, Size = arg.Size }
										end

										arg.CanCollide = false
										arg.Transparency = 1
										arg.Size = Vector3.new(10, 10, 10)
									end

									fn72 = function()
										for k, v70 in pairs(tbl14) do
											if k and k.Parent then
												pcall(function()
													k.CanCollide = v70.CanCollide
													k.Transparency = v70.Transparency
													k.Size = v70.Size
												end)
											end
										end

										tbl14 = {}
									end
								end
							end

							do
								local function fn73()
									if not fn70() then
										local character_ = localPlayer.Character
										local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
										local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")

										if not (not humanoid or humanoid.Health <= 0 or not humanoidRootPart) then
											local v70 = nil
											local huge = math.huge
											local k = nil

											for k2 in pairs(kMap) do
												if not k2.Parent then
													kMap[k2] = nil
												elseif fn67(k2) then
													local v71 = fn66(k2)

													if v71 then
														local magnitude = (humanoidRootPart.Position - v71.Position).Magnitude

														if magnitude < huge then
															v70 = v71
															huge = magnitude
															k = k2
														end
													end
												end
											end

											if not (not k or not k.Parent or not v70 or not v70.Parent) then
												pcall(function()
													fn71(v70)
													v70.CFrame = humanoidRootPart.CFrame
												end)

												local v71 = fn68(character_)

												if v71 then
													if v71.Parent ~= character_ then
														local tool2 = character_:FindFirstChildWhichIsA("Tool")

														if tool2 and tool2 ~= v71 then
														end

														v69 = v71

														pcall(function()
															runUntilTimeout2(1)
															humanoid:EquipTool(v71)
														end)
													end

													if v71.Parent == character_ then
														n54 = os.clock()

														pcall(function()
															v71:Activate()
														end)
													end
												end
											end
										end
									end
								end

								local function fn74()
									flag43 = false
									n53 += 1
									n54 = 0
									fn69()
									connection12:Disconnect()
									connection12 = nil
									kMap = {}
									fn72()
								end

								local function fn75()
									fn74()
									flag43 = true
									n53 += 1
									local n532 = n53

									for _, descendant in ipairs(Workspace:GetDescendants()) do
										if fn65(descendant) then
											kMap[descendant] = true
										end
									end

									connection12 = Workspace.DescendantAdded:Connect(function(descendant)
										if flag43 and fn65(descendant) then
											kMap[descendant] = true
										end
									end)

									fn73()

									task.spawn(function()
										local n542 = n54

										while flag43 and n53 == n532 and flag34 do
											if not fn70() then
												local character_ = localPlayer.Character
												local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
												local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")

												if humanoid and humanoid.Health > 0 and humanoidRootPart then
													local v70 = nil
													local huge = math.huge
													local k = nil

													for k2 in pairs(kMap) do
														if not k2.Parent then
															kMap[k2] = nil
														elseif fn67(k2) then
															local v71 = fn66(k2)

															if v71 then
																local magnitude = (humanoidRootPart.Position - v71.Position).Magnitude

																if magnitude < huge then
																	v70 = v71
																	huge = magnitude
																	k = k2
																end
															end
														end
													end

													if k and k.Parent and v70 and v70.Parent then
														pcall(function()
															fn71(v70)
															v70.CFrame = humanoidRootPart.CFrame
														end)

														local now3 = os.clock()

														if now3 - n542 >= 0.01 then
															local v71 = fn68(character_)

															if v71 then
																if v71.Parent ~= character_ then
																	local tool2 = character_:FindFirstChildWhichIsA("Tool")

																	if tool2 and tool2 ~= v71 then
																	end

																	v69 = v71

																	pcall(function()
																		runUntilTimeout2(1)
																		humanoid:EquipTool(v71)
																	end)
																end

																if v71.Parent == character_ then
																	pcall(function()
																		v71:Activate()
																	end)
																end
															end

															n542 = now3
														end
													else
														fn69()
													end
												end
											else
												fn69()
											end

											task.wait()
										end
									end)
								end

								fn45(fn74)

								helperSection:CreateToggle({
									Name = "Auto Destroy Turrets",
									Default = true,
									Callback = function(arg)
										if arg then
											fn75()
										else
											fn74()
										end
									end,
								})
							end
						end

						do
							local n53, n54, PlayerMouse, n55, n56, n57, obj4, connection12, fn65, fn66

							do
								local n58, gunFlags, v68, n59

								do
									helperSection:CreateButton({
										Name = "Instant Clone Swap",
										ButtonText = "Swap",
										Callback = function()
											return false
										end,
									})

									n58 = 0.05
									n53 = 0.05
									n54 = 200

									gunFlags = {
										["Web Slinger"] = true,
										["Taser Gun"] = true,
										["Laser Cape"] = true,
										["Paintball Gun"] = true,
									}

									PlayerMouse = require(ReplicatedStorage:WaitForChild("Packages"):WaitForChild("PlayerMouse"))
									flag40 = false
									flag41 = false
									n55 = 0
									flag42 = false
									n52 = 0

									do
										local flag43 = false
										local hit = nil
										local target = nil
										v68 = nil
										n59 = 0
										n56 = 0
										n57 = 0
										obj4 = setmetatable({}, { __mode = "k" })
										connection12 = nil

										fn60 = function()
											if flag43 then
												return
											end
											flag43 = true
											hit = PlayerMouse.Hit
											target = PlayerMouse.Target
										end
									end
								end

								do
									local function fn67(arg)
										local character_ = arg.Character
										local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")

										if character_ then
											character_ = character_:FindFirstChild("HumanoidRootPart") or character_:FindFirstChild("UpperTorso") or character_:FindFirstChild("Torso")
										end

										if humanoid and humanoid.Health > 0 and character_ then
											return humanoid, character_
										end
									end

									fn65 = function()
										local character_ = localPlayer.Character
										if not character_ then
											return nil
										end

										for k in pairs(gunFlags) do
											local v69 = character_:FindFirstChild(k)
											if v69 and v69:IsA("Tool") then
												return v69
											end
										end
									end

									local function fn68()
										local v69, v70 = fn67(localPlayer)
										if not v70 then
											return nil
										end
										local magnitude = nil
										local v71 = nil

										for _, player in ipairs(Players:GetPlayers()) do
											if player ~= localPlayer then
												local v72, v73 = fn67(player)

												if v73 then
													local magnitude2 = (v73.Position - v70.Position).Magnitude

													if not magnitude or magnitude2 < magnitude then
														magnitude = magnitude2
														v71 = v73
													end
												end
											end
										end

										return v71
									end

									fn66 = function(arg)
										local now3 = os.clock()

										if arg or not v68 or not v68.Parent or now3 - n59 >= n58 then
											n59 = now3
											v68 = fn68()
										end

										return v68
									end
								end
							end

							do
								do
									local function fn67(arg)
										local muzzle = obj4[arg]

										if not muzzle or not muzzle.Parent then
											muzzle = arg:FindFirstChild("Muzzle", true) or arg:FindFirstChild("FirePoint", true) or arg:FindFirstChild("Handle")
											obj4[arg] = muzzle
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

									local function fn68()
										local now3 = os.clock()

										if not (now3 < n57) then
											n57 = now3 + 0.5

											local ok13, result14 = pcall(function()
												return localPlayer:GetNetworkPing()
											end)

											if ok13 and type(result14) == "number" then
												n56 = math.clamp(result14, 0, 0.35)
											end
										end

										return n56
									end

									local function fn69(arg, arg2)
										local n58 = n54 * n54
										local n59 = arg2:Dot(arg2) - n58
										local n60 = 2 * arg:Dot(arg2)
										local v68 = arg:Dot(arg)
										local n61

										if math.abs(n59) < 0.0001 then
											n61 = nil

											if math.abs(n60) > 0.0001 then
												n61 = -v68 / n60
												local v69 = nil

												if not (n61 > 0) then
													n61 = v69
												end
											end
										else
											local n62 = n60 * n60 - 4 * n59 * v68
											n61 = nil

											if n62 >= 0 then
												local n622 = math.sqrt(n62)
												local n63 = (-n60 - n622) / 2 * n59
												local n64 = (-n60 + n622) / 2 * n59

												if n63 > 0 and n64 > 0 then
													n61 = math.min(n63, n64)
												elseif n63 > 0 then
													n61 = n63
												else
													n61 = nil

													if n64 > 0 then
														n61 = n64
													end
												end
											end
										end

										return math.clamp(n61 or arg.Magnitude / n54, 0, 3)
									end

									local function fn70(arg, arg2)
										local v68 = fn67(arg)
										if not v68 then
											return arg2.Position
										end
										local assemblyLinearVelocity = arg2.AssemblyLinearVelocity
										local n58 = arg2.Position + assemblyLinearVelocity * fn68()
										return n58 + assemblyLinearVelocity * fn69(n58 - v68, assemblyLinearVelocity)
									end

									fn61 = function(arg)
										local v68 = fn65()

										if v68 then
											local v69 = fn66(arg)

											if v69 then
												local n58

												if v68.Name == "Paintball Gun" then
													n58 = fn70(v68, v69)
												else
													n58 = v69.Position + v69.AssemblyLinearVelocity * n53
												end

												PlayerMouse.Hit = CFrame.new(n58)
												PlayerMouse.Target = v69
												return true
											end
										end

										return false
									end
								end
							end

							cleanupRenderStep = function()
								flag40 = false
								ContextActionService:UnbindAction("ChilliToolAimbotAction")

								pcall(function()
									RunService:UnbindFromRenderStep("ChilliToolAimbotRender")
								end)

								if connection12 then
									connection12:Disconnect()
									connection12 = nil
								end
							end

							fn62 = function()
								cleanupRenderStep()
								flag40 = true

								ContextActionService:BindActionAtPriority("ChilliToolAimbotAction", function(arg, arg2)
									if arg2 == Enum.UserInputState.Begin and fn65() then
										fn61(true)
									end

									return Enum.ContextActionResult.Pass
								end, false, 10000, Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch)

								connection12 = UserInputService.InputBegan:Connect(function(input)
									local userInputType = input.UserInputType

									if userInputType == Enum.UserInputType.MouseButton1 or userInputType == Enum.UserInputType.Touch then
										fn61(true)
									end
								end)

								RunService:BindToRenderStep("ChilliToolAimbotRender", Enum.RenderPriority.Last.Value + 20, function()
									if fn65() then
										fn60()
										fn61(false)
									end
								end)
							end

							do
								local function fn67()
									local character_ = localPlayer.Character
									character_ = character_ and character_:FindFirstChild("Paintball Gun")
									return character_ and character_:IsA("Tool") and character_ or nil
								end

								fn63 = function()
									flag41 = false
									n55 += 1
									local v68 = fn67()

									if v68 then
										pcall(function()
											v68:Deactivate()
										end)
									end
								end

								fn64 = function()
									fn63()
									local paintballGun, v68 = fn47("Paintball Gun")

									if not paintballGun then
										fn48("Paintball Gun", v68)
									end

									flag41 = true
									n55 += 1
									local n552 = n55

									task.spawn(function()
										while flag41 and n552 == n55 and flag34 do
											local v69 = fn67()

											if v69 then
												fn60()

												if fn61(false) then
													pcall(function()
														v69:Activate()
													end)
												end
											end

											task.wait(0.04)
										end
									end)

									return true
								end
							end
						end
					end

					local n53, n54, n55, flag43, connection12, connection13, connection14, connection15, connection16, flag44
					local humanoid, humanoidRootPart, flag45, flag46, n56, n57, n58, n59, flag47, y2
					local fn65, fn66

					do
						do
							do
								local function fn67()
									local character_ = localPlayer.Character
									character_ = character_ and character_:FindFirstChild("Laser Cape")
									return character_ and character_:IsA("Tool") and character_ or nil
								end

								local function fn68()
									flag42 = false
									n52 += 1
									local v68 = fn67()

									if v68 then
										pcall(function()
											v68:Deactivate()
										end)
									end
								end

								local function fn69()
									fn68()
									local laserCape, v68 = fn47("Laser Cape")

									if not laserCape then
										fn48("Laser Cape", v68)
									end

									flag42 = true
									n52 += 1
									local n522 = n52

									task.spawn(function()
										while flag42 and n522 == n52 and flag34 do
											local v69 = fn67()

											if v69 then
												fn60()

												if fn61(false) then
													pcall(function()
														v69:Activate()
													end)
												end
											end

											task.wait(0.04)
										end
									end)

									return true
								end

								fn45(function()
									fn68()
									fn63()
									cleanupRenderStep()
								end)

								aimbotSection:CreateToggle({
									Name = "Aimbot",
									Default = true,
									Callback = function(arg)
										if arg then
											fn62()
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
											fn64()
										else
											fn63()
										end
									end,
								})

								aimbotSection:CreateToggle({
									Name = "Auto Laser Cape",
									Note = "Automatically uses the Laser Cape while equipped.",
									Default = false,
									Callback = function(arg)
										if arg then
											fn69()
										else
											fn68()
										end
									end,
								})
							end
						end

						speedBoostSection = playerTab:CreateSection({ Name = "Speed Boost" })
						jumpBoostSection = playerTab:CreateSection({ Name = "Jump Boost" })
						characterSection = playerTab:CreateSection({ Name = "Character" })
						invisibilitySection = playerTab:CreateSection({ Name = "Invisibility" })
						respawnSection = playerTab:CreateSection({ Name = "Respawn", Expanded = false })
						n53 = 0.0083333333333333332
						n54 = 4

						do
							local n60 = 0.12
							local n61 = 25
							local n62 = 0.045
							local n63 = 0.03
							n55 = 0.015
							local n64 = 10
							local n65 = 60
							flag43 = false
							connection12 = nil
							connection13 = nil
							connection14 = nil
							connection15 = nil
							connection16 = nil
							flag44 = false
							humanoid = nil
							humanoidRootPart = nil
							flag45 = false
							flag46 = false
							local n66 = 0
							local n67 = 0
							n56 = 0
							local n68 = 0
							n57 = 0
							n58 = 60
							n59 = 19.1
							flag47 = false
							y2 = nil

							local function fn67()
								return math.max(n58 / n65, 0.01)
							end

							fn65 = function()
								if not (not flag43 or not humanoidRootPart or not humanoidRootPart.Parent) and not UserInputService:GetFocusedTextBox() then
									y2 = y2 or humanoidRootPart.Position.Y

									if not (flag47 and humanoidRootPart.Position.Y - y2 >= n59) then
										local v68 = fn67()
										n67 = n65 * v68
										local n69 = n60 / v68
										n66 = os.clock() + n69
										flag46 = true
										n68 = os.clock()
										return
									end
								end
							end

							fn66 = function()
								if not (not humanoid or not humanoidRootPart or not humanoidRootPart.Parent) then
									if humanoid.Health <= 0 then
										flag45 = false
										flag46 = false
										return
									end

									local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
									local flag48 = humanoid.FloorMaterial ~= Enum.Material.Air
									local now3 = os.clock()
									local v68 = fn67()

									if flag48 then
										y2 = humanoidRootPart.Position.Y
									end

									local y3 = flag47 and (flag45 or flag46) and y2 and humanoidRootPart.Position.Y - y2 >= n59

									if flag45 and not y3 and (now3 - n68 >= n62 / v68 or flag46 and n66 - now3 <= n63 / v68) then
										fn65()
									end

									if y3 then
										flag46 = false

										if assemblyLinearVelocity.Y > 0 then
											humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
										end
									elseif flag46 then
										if n66 <= now3 then
											flag46 = false
										else
											local n69 = (Workspace.Gravity * v68 * v68 - Workspace.Gravity) * n53
											humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y + (n67 - assemblyLinearVelocity.Y) * (1 - math.exp(-n61 * v68 * n53)) - n69, assemblyLinearVelocity.Z)
										end
									elseif not flag48 then
										local gravity = Workspace.Gravity

										if assemblyLinearVelocity.Y < 0 then
											gravity += n64
										end

										local n69 = gravity * v68 * v68 - Workspace.Gravity

										if math.abs(n69) > 0.001 then
											humanoidRootPart.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y - n69 * n53, assemblyLinearVelocity.Z)
										end
									end
								end
							end
						end
					end

					local fn67, fn68, fn69, fn70, fn71

					do
						do
							fn67 = function(deltaTime)
								if not (not flag43 or not flag34) then
									n57 += deltaTime

									if not (n57 < n53) then
										local n60 = math.floor(n57 / n53)

										if n54 < n60 then
											n57 = 0
											n60 = 4
										else
											n57 -= n60 * n53
										end

										for i_ = 1, n60 do
											fn66()
										end
									end
								end
							end

							do
								local function fn72(arg, arg2)
									if flag43 then
										if arg2 == Enum.UserInputState.Begin then
											local now3 = os.clock()

											if n55 <= now3 - n56 then
												n56 = now3
												flag45 = true
												y2 = humanoidRootPart and humanoidRootPart.Position.Y or nil
												fn65()
											end
										elseif arg2 == Enum.UserInputState.End or arg2 == Enum.UserInputState.Cancel then
											flag45 = false
										end
									end

									return Enum.ContextActionResult.Pass
								end

								fn68 = function()
									if flag44 then
										ContextActionService:UnbindAction("ChilliInfinityJump2")
										flag44 = false
									end
								end

								fn69 = function()
									fn68()
									ContextActionService:BindAction("ChilliInfinityJump2", fn72, false, Enum.KeyCode.Space, Enum.KeyCode.ButtonA)
									flag44 = true
								end
							end
						end

						do
							local function fn72(arg)
								if connection14 then
									connection14:Disconnect()
								end

								if connection15 then
									connection15:Disconnect()
								end

								connection14 = arg.InputBegan:Connect(function(input)
									if not flag43 or input.UserInputType ~= Enum.UserInputType.Touch then
										return
									end
									local now3 = os.clock()

									if now3 - n56 >= n55 then
										n56 = now3
										y2 = humanoidRootPart and humanoidRootPart.Position.Y or nil
										fn65()
									end

									flag45 = true
								end)

								connection15 = arg.InputEnded:Connect(function(input)
									if input.UserInputType ~= Enum.UserInputType.Touch then
										return
									end
									flag45 = false
								end)
							end

							fn70 = function()
								if connection14 then
									connection14:Disconnect()
									connection14 = nil
								end

								if connection15 then
									connection15:Disconnect()
									connection15 = nil
								end

								if connection16 then
									connection16:Disconnect()
									connection16 = nil
								end
							end

							local function isImageButton(arg)
								return (arg:IsA("ImageButton") or arg:IsA("TextButton")) and arg.Name:lower():find("jump", 1, true) ~= nil
							end

							fn71 = function()
								fn70()

								if UserInputService.TouchEnabled then
									local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")

									if playerGui then
										local touchGui = playerGui:FindFirstChild("TouchGui", true)

										if touchGui then
											for _, descendant in ipairs(touchGui:GetDescendants()) do
												if isImageButton(descendant) then
													fn72(descendant)
													break
												end
											end
										end

										connection16 = playerGui.DescendantAdded:Connect(function(descendant)
											if flag43 and isImageButton(descendant) then
												fn72(descendant)
											end
										end)

										return
									end
								end
							end
						end
					end

					do
						local function fn72(arg)
							humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
							humanoidRootPart = arg:FindFirstChild("HumanoidRootPart") or arg:WaitForChild("HumanoidRootPart", 5)
							flag45 = false
							flag46 = false
							y2 = humanoidRootPart.Position.Y or nil
							n57 = 0
						end

						local function fn73()
							flag43 = false
							flag45 = false
							flag46 = false

							if connection12 then
								connection12:Disconnect()
								connection12 = nil
							end

							if connection13 then
								connection13:Disconnect()
								connection13 = nil
							end

							fn68()
							fn70()
							humanoid = nil
							humanoidRootPart = nil
						end

						local function fn74()
							fn73()
							flag43 = true

							if localPlayer.Character then
								fn72(localPlayer.Character)
							end

							connection13 = localPlayer.CharacterAdded:Connect(function(character_)
								if flag43 then
									fn72(character_)
								end
							end)

							fn69()
							fn71()
							connection12 = RunService.Heartbeat:Connect(fn67)
						end

						fn45(fn73)

						jumpBoostSection:CreateSlider({
							Name = "Jump Speed",
							ShowWhen = jumpBoostSection:CreateToggle({
								Name = "Infinity Jump",
								Default = true,
								Callback = function(arg)
									if arg then
										fn74()
									else
										fn73()
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
								n58 = math.clamp(tonumber(arg) or 60, 20, 100)
							end,
						})
					end

					jumpBoostSection:CreateSlider({
						Name = "Jump Height",
						ShowWhen = jumpBoostSection:CreateToggle({
							Name = "Limit Jump Height",
							Default = false,
							Note = "Limits the height of each jump. Leave this off to keep air jumping upward.",
							Callback = function(arg)
								flag47 = arg == true
								y2 = humanoidRootPart and humanoidRootPart.Position.Y or nil
							end,
						}),
						Min = 1,
						Max = 21,
						Default = 19.1,
						AllowDecimals = true,
						Increment = 0.1,
						Callback = function(arg)
							n59 = math.clamp(tonumber(arg) or 19.1, 1, 21)
						end,
					})

					floatSpeedToolBridge = {}
					n2 = 0.3
					n3 = 200
					n36 = 0.05
					n37 = 0.02
					n38 = 0.5
					n39 = 0.5
					n40 = 2
					n41 = 14
					n42 = 2
					n43 = 19.1
					n44 = 0.2
					n8 = 0
					n9 = 0.52
					n10 = 52
					n11 = 28
					n12 = 240
					n13 = 185
					flag14 = false
					flag15 = true
					flag16 = true
					flag17 = false
					n14 = n11 - n39
					n15 = 1
					str = "Bottom"
					now = os.clock()
					v31 = nil
					v32 = nil
					y = nil
					now2 = os.clock()
					n16 = 0
					str2 = "Grapple Hook"
					n17 = 0.8
					tool = nil
					n18 = 0
					flag18 = false
					toolSpeedBoostToggle = nil
					toggle = nil
					flag19 = false
					flag20 = localPlayer:GetAttribute("Stealing") == true
					speedToolDropdown = nil
					adjustToolSpeedSlider = nil
					flag4 = false
					flag5 = false
					connection = nil
					v5 = nil
					connection2 = nil
					connection3 = nil
					connection4 = nil
					connection5 = nil
					connection6 = nil
					connection10 = nil
					flag6 = false
					flag7 = false
					flag8 = false
					n4 = 0
					flag9 = false
					v6 = nil
					beamMap = {}
					descendantMap = {}
					v7 = nil
					connection7 = nil
					raycastParams = RaycastParams.new()
					parent = nil
					raycastParams.FilterType = Enum.RaycastFilterType.Exclude
					raycastParams.IgnoreWater = true

					pcall(function()
						raycastParams.RespectCanCollide = true
					end)

					fn = function()
						local character_ = localPlayer.Character
						if not character_ then
							return nil, nil
						end
						local findFirstChildOfClass = character_.FindFirstChildOfClass
						return character_:FindFirstChild("HumanoidRootPart"), findFirstChildOfClass(character_, "Humanoid")
					end

					isTool = function(arg)
						return arg and arg:IsA("Tool")
					end

					fn2 = function()
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
							if k ~= str2 and isTool(fn46(k)) then
								ks[#ks + 1] = k
							end
						end

						table.sort(ks, function(arg, arg2)
							return string.lower(arg) < string.lower(arg2)
						end)

						ks[#ks + 1] = str2
						return ks, ks[1] or "Grapple Hook"
					end

					v8, v33 = fn2()
					flag35 = v33 == str2

					if flag35 then
						state = 87
					else
						state = 88
					end
				elseif state == 87 then
					flag35 = n12
					state = 88
				elseif state == 88 then
					if flag35 then
						state = 90
					else
						state = 89
					end
				elseif state == 89 then
					n132 = n13
					state = 91
				elseif state == 90 then
					n132 = flag35
					state = 91
				elseif state == 91 then
					do
						fn3 = function()
							local flag40 = v33 == str2
							local flag402 = flag40 and 270 or 210
							n132 = math.clamp(flag40 and n12 or n13, 50, flag402)
							adjustToolSpeedSlider:SetRange(50, flag402, false)
							adjustToolSpeedSlider:Set(n132, false)
						end

						fn4 = function()
							v7 = nil

							if connection7 then
								connection7:Disconnect()
								connection7 = nil
							end

							for k, v68 in pairs(beamMap) do
								pcall(function()
									k.Attachment0 = v68.Attachment0
									k.Attachment1 = v68.Attachment1
									k.Enabled = v68.Enabled
								end)
							end

							table.clear(beamMap)

							for k, v68 in pairs(descendantMap) do
								pcall(function()
									k.Volume = v68
								end)
							end

							table.clear(descendantMap)
						end

						fn5 = function(arg)
							if v7 ~= arg then
								fn4()
								v7 = arg
								local handle = arg:FindFirstChild("Handle")
								local beam = handle and handle:FindFirstChild("Beam")

								if beam and beam:IsA("Beam") then
									beamMap[beam] = { Enabled = beam.Enabled, Attachment0 = beam.Attachment0, Attachment1 = beam.Attachment1 }
									beam.Enabled = false
									beam.Attachment0 = nil

									connection7 = beam:GetPropertyChangedSignal("Enabled"):Connect(function()
										if v7 == arg and beam.Enabled then
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

						fn6 = function()
							if type(hookfunction) ~= "function" or type(checkcaller) ~= "function" or type(newcclosure) ~= "function" then
								return false
							end

							if v6 then
								flag9 = true
								local flag40 = false

								pcall(function()
									flag40 = checkcaller() == false
								end)

								flag9 = false
								if flag40 then
									return true
								end
								v6 = nil
							end

							return pcall(function()
								v6 = hookfunction(checkcaller, newcclosure(function()
									if flag9 then
										return false
									end
									return v6()
								end))
							end) and v6 ~= nil
						end

						do
							local function fn60(arg)
								if not arg or arg.Parent ~= localPlayer.Character then
									return
								end
								flag9 = true

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
										local v68 = getconnections(arg.Activated)

										if type(v68) == "table" then
											for _, v69 in ipairs(v68) do
												if v69.Enabled then
													if type(v69.Fire) == "function" then
														v69:Fire()
													elseif type(v69.Function) == "function" then
														v69.Function()
													end
												end
											end
										end
									end)
								end

								flag9 = false
							end

							runUntilTimeout = function(arg)
								if not (flag7 or flag8) or not arg or arg.Parent ~= localPlayer.Character or arg:GetAttribute("CooldownTime") ~= nil then
									return
								end
								n4 = os.clock() + n17
								fn60(arg)
							end
						end
					end

					fn7 = function()
						v5 = nil

						if connection then
							connection:Disconnect()
							connection = nil
						end
					end

					fn8 = function(arg)
						if v5 == arg then
							return
						end
						fn7()
						v5 = arg

						connection = arg:GetAttributeChangedSignal("CooldownTime"):Connect(function()
							if (flag7 or flag8) and arg:GetAttribute("CooldownTime") == nil then
								runUntilTimeout(arg)
							end
						end)
					end

					fn9 = function()
						if flag5 then
							flag5 = false
							local v68, humanoid = fn()

							if not (not v68 or not humanoid or humanoid.Health <= 0) then
								local assemblyLinearVelocity = v68.AssemblyLinearVelocity
								local moveDirection = humanoid.MoveDirection
								local vector3Zero = Vector3.zero

								if moveDirection.Magnitude > 0.001 then
									vector3Zero = moveDirection.Unit * humanoid.WalkSpeed
								end

								v68.AssemblyLinearVelocity = Vector3.new(vector3Zero.X, assemblyLinearVelocity.Y, vector3Zero.Z)
								return
							end
						end
					end

					fn10 = function()
						fn9()
						flag17 = false
						flag4 = false
						flag7 = false
						tool = nil

						if not flag8 then
							n4 = 0
							fn7()
							fn4()
						end
					end

					fn11 = function()
						fn10()
						toolSpeedBoostToggle:Set(false, true)
					end

					fn12 = function()
						if flag18 then
							return
						end
						flag18 = true

						task.defer(function()
							flag18 = false
							fn11()
						end)
					end

					fn13 = function(arg, arg2)
						if arg == str2 and arg2 == "rebirth" then
							v36.Notify("Tool unavailable", "Grapple Hook requires 3 Rebirths.", 5)
							return
						end
						fn48(arg, arg2)
					end

					fn14 = function(arg)
						local character_ = localPlayer.Character
						local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
						if not character_ or not humanoid or humanoid.Health <= 0 or not isTool(arg) then
							return nil
						end
						n18 = os.clock() + 1.5
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
						local v68 = character_:FindFirstChild(v33)
						return isTool(v68) and v68 or nil
					end

					fn15 = function()
						local grappleHook = fn46(v33)

						if not isTool(grappleHook) and v33 == str2 then
							local v68
							grappleHook, v68 = fn47("Grapple Hook")
							if not isTool(grappleHook) then
								fn13("Grapple Hook", v68)
								return false
							end
						elseif not isTool(grappleHook) then
							v36.Notify("Tool unavailable", v33 .. " is not currently owned.", 5)
							return false
						end

						tool = fn14(grappleHook)
						if not tool then
							v36.Notify("Tool unavailable", "Unable to equip " .. v33 .. " right now.", 5)
							return false
						end
						flag17 = true
						flag4 = true

						if v33 == str2 then
							fn6()
							flag7 = true
							fn5(tool)
							fn8(tool)
							runUntilTimeout(tool)
						end

						return true
					end

					do
						local function fn60()
							local v68, v69 = fn2()
							local v70, v71, v72 = ipairs(v68)
							local flag40 = false

							for _, v73 in v70, v71, v72 do
								if v73 == v33 then
									flag40 = true
									break
								end
							end

							if not flag40 then
								v33 = v69

								if flag17 then
									fn12()
								end
							end

							fn3()
							speedToolDropdown:SetOptions(v68, v33, false)
						end

						fn16 = function()
							if flag6 then
								return
							end
							flag6 = true

							task.defer(function()
								flag6 = false
								fn60()
							end)
						end
					end

					fn17 = function(arg)
						if connection2 then
							connection2:Disconnect()
						end

						if connection3 then
							connection3:Disconnect()
						end

						if connection4 then
							connection4:Disconnect()
						end

						connection2 = arg.DescendantAdded:Connect(function(descendant)
							if not (not (flag7 or flag8) or os.clock() > n4) and (descendant:IsA("BodyMover") or descendant:IsA("Constraint")) then
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

						connection3 = arg.ChildAdded:Connect(function(child)
							fn16()
							local humanoid = arg:FindFirstChildOfClass("Humanoid")
							humanoid = humanoid and humanoid.Health > 0
							local flag172 = flag17

							if not flag17 then
								humanoid = flag172
							end

							if humanoid and child:IsA("Tool") and child.Name ~= v33 and not fn49() and os.clock() >= n18 then
								fn12()
							end
						end)

						connection4 = arg.ChildRemoved:Connect(function(child)
							fn16()
							local humanoid = arg:FindFirstChildOfClass("Humanoid")
							humanoid = humanoid and humanoid.Health > 0
							local flag172 = flag17

							if not flag17 then
								humanoid = flag172
							end

							if humanoid and child == tool and not fn49() and os.clock() >= n18 then
								task.defer(function()
									local character_ = localPlayer.Character
									local humanoid2 = character_ and character_:FindFirstChildOfClass("Humanoid")

									if not (not humanoid2 or humanoid2.Health <= 0) then
										character_ = character_ and character_:FindFirstChild(v33)

										if flag17 and not isTool(character_) then
											fn12()
										end
									end
								end)
							end
						end)
					end

					fn18 = function(arg)
						if connection5 then
							connection5:Disconnect()
							connection5 = nil
						end

						if connection6 then
							connection6:Disconnect()
							connection6 = nil
						end

						connection10:Disconnect()
						connection10 = nil

						if arg then
							connection5 = arg.ChildAdded:Connect(fn16)
							connection6 = arg.ChildRemoved:Connect(fn16)
						end
					end

					if localPlayer.Character then
						state = 92
					else
						state = 93
					end
				elseif state == 92 then
					fn17(localPlayer.Character)
					state = 93
				end
			elseif state == 93 then
				backpack = localPlayer:FindFirstChildOfClass("Backpack")

				if backpack then
					state = 94
				else
					state = 95
				end
			elseif state == 94 then
				fn18(backpack)
				state = 95
			elseif state == 95 then
				local connection12

				do
					connection10 = localPlayer.ChildAdded:Connect(function(child)
						if child:IsA("Backpack") then
							fn18(child)
							fn16()
						end
					end)

					fn19 = function(arg, arg2)
						str = arg
						now = arg2
						v31 = nil
					end

					do
						local function fn60(arg, arg2)
							if not arg then
								v31 = nil
								return false
							end
							local v312 = v31
							local v3122

							if v31 then
								v3122 = v312
							else
								v3122 = arg2
							end

							v31 = v3122
							return arg2 - v31 >= n37
						end

						local function fn61(arg, arg2)
							local assemblyLinearVelocity = arg.AssemblyLinearVelocity
							arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, arg2, assemblyLinearVelocity.Z)
						end

						local function raycastGround(arg, humanoid)
							local parent2 = arg.Parent

							if parent ~= parent2 then
								parent = parent2
								raycastParams.FilterDescendantsInstances = { parent2 }
							end

							local n52

							if humanoid.RigType == Enum.HumanoidRigType.R6 then
								n52 = 3
							else
								n52 = math.max(arg.Size.Y * 0.5, humanoid.HipHeight + arg.Size.Y * 0.5)
							end

							local hit = Workspace:Raycast(arg.Position, Vector3.new(0, -(n52 + n38), 0), raycastParams)
							return hit ~= nil and hit.Normal.Y > 0.15
						end

						connection12 = RunService.Heartbeat:Connect(function(deltaTime)
							local v68, humanoid = fn()
							local now3 = os.clock()

							if not v68 or not humanoid or humanoid.Health <= 0 then
								v32 = nil
								y = nil
								n16 = 0
								return
							end

							if v68 ~= v32 or not y then
								v32 = v68
								y = v68.Position.Y
								now2 = now3
								n16 = 0
								fn19("Bottom", now3)
							else
								local n52 = now3 - now2

								if n52 > 0 then
									n16 = (v68.Position.Y - y) / n52
								end

								y = v68.Position.Y
								now2 = now3
							end

							if flag14 then
								local n52 = math.max(0.02, n2 / n9)
								local n53 = math.max(0.01, n36 / n9)
								local n54 = n3 * n9
								local n55 = now3 - now

								if str == "Rise" then
									local n56 = math.clamp(n55 / n52, 0, 1)
									local n57 = n43 * 3.1415926535897931 / 2 * n52 * math.cos(n56 * 3.1415926535897931 * 0.5)

									if fn60(n55 >= 0.06 and n57 >= n41 and math.abs(n16) <= n42, now3) then
										fn19("Fall", now3)
									elseif n56 >= 1 then
										fn19("Hold", now3)
										fn61(v68, 0)
									else
										fn61(v68, n57)
									end
								elseif str == "Hold" then
									if n44 <= n55 then
										fn19("Fall", now3)
									else
										fn61(v68, 0)
									end
								elseif str == "Fall" then
									local n56 = math.clamp(n55 / n53, 0, 1)
									local n57 = -n54 * math.sin(n56 * 3.1415926535897931 * 0.5)

									if fn60(n55 >= 0.01 and n57 <= -n41 and n16 >= -n42, now3) or n56 >= 1 then
										fn19("Bottom", now3)
									else
										fn61(v68, n57)
									end
								else
									v31 = nil

									if n55 >= n8 and raycastGround(v68, humanoid) then
										fn19("Rise", now3)
									end
								end
							else
								v31 = nil

								if str ~= "Bottom" then
									fn19("Bottom", now3)
								end
							end

							if flag17 then
								local character_ = localPlayer.Character
								local humanoid2 = character_ and character_:FindFirstChildOfClass("Humanoid")

								if not (humanoid2 and humanoid2.Health > 0) then
									flag4 = false
									n18 = math.max(n18, now3 + 1.5)
								else
									local tool2 = character_:FindFirstChildWhichIsA("Tool")
									flag4 = tool2 ~= nil and tool2.Name == v33

									if not tool2 or tool2.Name ~= v33 then
										if not fn49() and now3 >= n18 then
											fn12()
										end
									elseif v33 == str2 then
										tool = tool2
										flag7 = true
										fn5(tool2)
										fn8(tool2)
										runUntilTimeout(tool2)
									end
								end
							else
								flag4 = false
							end

							local flag40 = localPlayer:GetAttribute("Stealing") == true
							local flag402 = flag40 and not flag20
							flag20 = flag40

							if flag402 and flag15 and toggle and (not flag16 or toggle:Get() ~= true) and not flag19 then
								flag19 = true

								task.defer(function()
									flag19 = false

									if not (not flag34 or localPlayer:GetAttribute("Stealing") ~= true or not flag15 or not toggle) then
										if toggle:Get() ~= true then
											toggle:Set(true, true)
										else
											flag16 = true
											n14 = math.max(20, n11 - n39)
											n15 = 1
										end
									end
								end)
							end

							local flag162 = flag40 and flag16
							local flag42 = flag17 and flag4 and not flag40

							if flag42 then
								local assemblyLinearVelocity = v68.AssemblyLinearVelocity
								local moveDirection = humanoid.MoveDirection
								local vector3Zero = Vector3.zero

								if moveDirection.Magnitude > 0.001 then
									vector3Zero = moveDirection.Unit * n132
								end

								v68.AssemblyLinearVelocity = Vector3.new(vector3Zero.X, assemblyLinearVelocity.Y, vector3Zero.Z)
								flag5 = true
							else
								fn9()
							end

							local n112

							if flag162 then
								local n52 = math.max(20, n11 - n39)
								n14 += n15 * n40 * deltaTime

								if n11 <= n14 then
									n14 = n11
									n15 = -1
								elseif n14 <= n52 then
									n14 = n52
									n15 = 1
								end

								n112 = n14
							else
								local flag152 = not flag40 and flag15 and not flag42
								n112 = nil

								if flag152 then
									n112 = n10
								end
							end

							if n112 then
								local moveDirection = humanoid.MoveDirection
								local n52 = n112 - humanoid.WalkSpeed

								if moveDirection.Magnitude > 0.001 and math.abs(n52) > 0.001 then
									v68.CFrame = v68.CFrame + moveDirection * n52 * deltaTime
								end
							end
						end)
					end
				end

				do
					local connection13 = localPlayer.CharacterAdded:Connect(function(character_)
						v32 = nil
						y = nil
						fn7()
						fn4()
						tool = nil
						flag4 = false
						n18 = os.clock() + 3
						fn17(character_)
						local backpack2 = localPlayer:FindFirstChildOfClass("Backpack")

						if backpack2 then
							fn18(backpack2)
						end

						fn16()

						if flag17 then
							task.spawn(function()
								local humanoid = character_:WaitForChild("Humanoid", 3)

								if humanoid and character_:WaitForChild("HumanoidRootPart", 3) then
									local now3 = os.clock()
									local grappleHook

									while true do
										grappleHook = fn46(v33)

										if isTool(grappleHook) then
											break
										else
											task.wait(0.1)
											if not (isTool(grappleHook) or os.clock() - now3 >= 3 or not flag17) then
												continue
											end
											break
										end
									end

									if flag17 then
										if not isTool(grappleHook) and v33 == str2 then
											grappleHook = fn47("Grapple Hook")
										end

										if isTool(grappleHook) and flag17 and humanoid.Health > 0 then
											task.wait(0.15)
											tool = fn14(grappleHook)

											if tool then
												flag4 = true

												if v33 == str2 then
													fn6()
													flag7 = true
													fn5(tool)
													fn8(tool)
													RunService.Heartbeat:Wait()
													runUntilTimeout(tool)
												end
											else
												fn11()
											end
										elseif flag17 then
											fn11()
										end
									end
								end
							end)
						end
					end)

					fn45(function()
						flag14 = false
						flag15 = false
						flag16 = false
						flag8 = false
						fn10()
						flag9 = false

						if v6 then
							pcall(function()
								hookfunction(checkcaller, v6)
							end)
						end

						connection13:Disconnect()
						connection13 = nil

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

						if connection5 then
							connection5:Disconnect()
							connection5 = nil
						end

						if connection6 then
							connection6:Disconnect()
							connection6 = nil
						end

						connection12:Disconnect()
						connection12 = nil
					end)
				end

				speedBoostSection:CreateSlider({
					Name = "Adjust Speed",
					ShowWhen = speedBoostSection:CreateToggle({
						Name = "Speed Boost",
						Default = true,
						Note = "Moves faster without a tool and pauses while stealing.",
						Callback = function(arg)
							flag15 = arg == true
						end,
					}),
					Min = 20,
					Max = 64,
					Default = 52,
					AllowDecimals = true,
					Increment = 0.1,
					Callback = function(arg)
						n10 = math.clamp(tonumber(arg) or 52, 20, 64)
					end,
				})

				toggle = speedBoostSection:CreateToggle({
					Name = "Speed Boost While Stealing",
					Default = true,
					Note = "Smoothly varies speed while stealing.",
					Callback = function(arg)
						flag16 = arg == true
						n14 = math.max(20, n11 - n39)
						n15 = 1
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
						n11 = math.clamp(tonumber(arg) or 28, 20, 29)
						n14 = math.max(20, n11 - n39)
						n15 = 1
					end,
				})

				toolSpeedBoostToggle = speedBoostSection:CreateToggle({
					Name = "Tool Speed Boost",
					Default = false,
					Keybind = Enum.KeyCode.Q,
					Note = "Equips the selected speed tool. Switching tools turns this off.",
					Callback = function(arg)
						if arg then
							if not fn15() then
								task.defer(function()
									toolSpeedBoostToggle:Set(false, true)
								end)
							end
						else
							fn10()
						end
					end,
				})

				speedToolDropdown = speedBoostSection:CreateDropdown({
					Name = "Speed Tool",
					ShowWhen = toolSpeedBoostToggle,
					Options = v8,
					Default = "Grapple Hook",
					Callback = function(arg)
						local str5 = tostring(arg or "Grapple Hook")

						if str5 ~= v33 then
							v33 = str5
							fn3()

							if flag17 then
								fn11()
							end
						end
					end,
				})

				flag10 = v33 == str2

				if flag10 then
					state = 96
				else
					state = 97
				end
			elseif state == 96 then
				flag10 = 270
				state = 97
			elseif state == 97 then
				if flag10 then
					state = 99
				else
					state = 98
				end
			elseif state == 98 then
				flag10 = 210
				state = 99
			elseif state == 99 then
				do
					local floatToggle, flag40, flag41, fn60, flag42, fn61

					do
						local n52, n53, connection12, n54, v68
						local runUntilTimeout3, fn62

						do
							do
								adjustToolSpeedSlider = speedBoostSection:CreateSlider({
									Name = "Adjust Tool Speed",
									ShowWhen = toolSpeedBoostToggle,
									Min = 50,
									Max = flag10,
									Default = 240,
									AllowDecimals = true,
									Increment = 0.1,
									Callback = function(arg)
										if v33 == str2 then
											n12 = math.clamp(tonumber(arg) or 240, 50, 270)
											n132 = n12
										else
											n13 = math.clamp(tonumber(arg) or 185, 50, 210)
											n132 = n13
										end
									end,
								})

								do
									local autoJumpToggle = jumpBoostSection:CreateToggle({
										Name = "Auto Jump",
										Default = false,
										Note = "Automatically repeats jumps.",
										Callback = function(arg)
											flag14 = arg == true
											fn19("Bottom", os.clock())
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
											n43 = math.clamp(tonumber(arg) or 19.1, 1, 21)
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
											n9 = math.clamp(tonumber(arg) or 52, 20, 110) / 100
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
											n44 = math.clamp(tonumber(arg) or 0.2, 0, 1)
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
											n8 = math.clamp(tonumber(arg) or 0, 0, 1)
										end,
									})
								end
							end

							floatSpeedToolBridge.GetSelectedName = function()
								return v33
							end

							floatSpeedToolBridge.EquipSelected = function()
								local grappleHook = fn46(v33)

								if not isTool(grappleHook) and v33 == str2 then
									local v69
									grappleHook, v69 = fn47("Grapple Hook")
									if not isTool(grappleHook) then
										fn13("Grapple Hook", v69)
										return nil
									end
								elseif not isTool(grappleHook) then
									v36.Notify("Tool unavailable", v33 .. " is not currently owned.", 5)
									return nil
								end

								local v69 = fn14(grappleHook)
								if not v69 then
									v36.Notify("Tool unavailable", "Unable to equip " .. v33 .. " right now.", 5)
									return nil
								end
								return v69
							end

							floatSpeedToolBridge.StartGrappleSpam = function(arg)
								if not isTool(arg) or arg.Name ~= str2 then
									return false
								end
								flag8 = true
								fn6()
								fn5(arg)
								fn8(arg)
								runUntilTimeout(arg)
								return true
							end

							floatSpeedToolBridge.PulseGrapple = function(arg)
								if not flag8 or not isTool(arg) or arg.Name ~= str2 then
									return false
								end
								fn5(arg)
								fn8(arg)
								runUntilTimeout(arg)
								return true
							end

							floatSpeedToolBridge.StopGrappleSpam = function()
								flag8 = false

								if not flag7 then
									n4 = 0
									fn7()
									fn4()
								end
							end

							n52 = 0.0083333333333333332
							n53 = 4

							do
								local n55 = 0.12
								local n56 = 25
								local n57 = 0.045
								local n58 = 0.03
								local n59 = 10
								local n60 = 60
								flag40 = false
								connection12 = nil
								n54 = 0
								local flag43 = false
								local n61 = 0
								local n62 = 0
								local n63 = 0
								v68 = nil
								flag42 = false
								flag41 = false
								floatToggle = nil
								local flag44 = false

								fn60 = function()
									if connection12 then
										connection12:Disconnect()
										connection12 = nil
									end

									flag40 = false
									n54 = 0
									flag43 = false
									n61 = 0
									n62 = 0
									n63 = 0
									v68 = nil
									local stopGrappleSpam = floatSpeedToolBridge.StopGrappleSpam

									if type(stopGrappleSpam) == "function" then
										stopGrappleSpam()
									end
								end

								fn61 = function()
									if flag44 then
										return
									end
									flag44 = true

									task.defer(function()
										flag44 = false
										fn60()

										if floatToggle:Get() == true then
											floatToggle:Set(false, true)
										end
									end)
								end

								runUntilTimeout3 = function(arg)
									if not flag40 or not arg or not arg.Parent then
										return
									end
									local now3 = os.clock()
									n62 = n60
									n61 = now3 + n55
									flag43 = true
									n63 = now3
								end

								fn62 = function(arg, arg2)
									local assemblyLinearVelocity = arg.AssemblyLinearVelocity
									local flag45 = arg2.FloorMaterial ~= Enum.Material.Air
									local now3 = os.clock()

									if now3 - n63 >= n57 or flag43 and n61 - now3 <= n58 then
										runUntilTimeout3(arg)
									end

									if flag43 then
										if n61 <= now3 then
											flag43 = false
										else
											local n64 = (Workspace.Gravity - Workspace.Gravity) * n52
											arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y + (n62 - assemblyLinearVelocity.Y) * (1 - math.exp(-n56 * n52)) - n64, assemblyLinearVelocity.Z)
										end
									elseif not flag45 then
										local gravity = Workspace.Gravity

										if assemblyLinearVelocity.Y < 0 then
											gravity += n59
										end

										local n64 = gravity - Workspace.Gravity

										if math.abs(n64) > 0.001 then
											arg.AssemblyLinearVelocity = Vector3.new(assemblyLinearVelocity.X, assemblyLinearVelocity.Y - n64 * n52, assemblyLinearVelocity.Z)
										end
									end
								end
							end
						end

						do
							do
								local function fn63(arg)
									fn60()
									v68 = arg
									local startGrappleSpam = floatSpeedToolBridge.StartGrappleSpam

									if v68 and type(startGrappleSpam) == "function" and not startGrappleSpam(v68) then
										v68 = nil
									end

									flag40 = true
									local character_ = localPlayer.Character
									character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

									if character_ then
										runUntilTimeout3(character_)
									end

									connection12 = RunService.Heartbeat:Connect(function(deltaTime)
										if flag40 then
											if flag41 and localPlayer:GetAttribute("Stealing") == true then
												fn61()
												return
											end
											local character_2 = localPlayer.Character
											local humanoidRootPart = character_2 and character_2:FindFirstChild("HumanoidRootPart")

											if humanoidRootPart then
												local humanoid = character_2:FindFirstChildOfClass("Humanoid")
												if humanoid and humanoid.Health <= 0 then
													fn61()
													return
												end
												local pulseGrapple = floatSpeedToolBridge.PulseGrapple

												if v68 and type(pulseGrapple) == "function" and not pulseGrapple(v68) then
													v68 = nil
												end

												n54 += deltaTime

												if not (n54 < n52) then
													local n55 = math.floor(n54 / n52)

													if n53 < n55 then
														n54 = 0
														n55 = 4
													else
														n54 -= n55 * n52
													end

													for i_ = 1, n55 do
														fn62(humanoidRootPart, humanoid)
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
											if flag41 and localPlayer:GetAttribute("Stealing") == true then
												fn61()
												return
											end
											local v69 = nil

											if flag42 then
												local equipSelected = floatSpeedToolBridge.EquipSelected

												if type(equipSelected) ~= "function" then
													v36.Notify("Tool unavailable", "The Speed Tool selection is not available right now.", 5)
													fn61()
													return
												end

												v69 = equipSelected()
												if not v69 then
													fn61()
													return
												end
											end

											fn63(v69)
										else
											fn60()
										end
									end,
								})
							end
						end
					end

					local n52, flag43, connection12, n53, destroyAll2, fn62, createPart

					do
						section:CreateToggle({
							Name = "Auto Equip Speed Tool",
							Note = "Equips the current Speed Tool selection before Float starts.",
							Default = true,
							SubOf = floatToggle,
							Callback = function(arg)
								flag42 = arg == true
							end,
						})

						section:CreateToggle({
							Name = "Auto Off After Steal",
							Default = true,
							SubOf = floatToggle,
							Callback = function(arg)
								flag41 = arg == true

								if flag41 and flag40 and localPlayer:GetAttribute("Stealing") == true then
									fn61()
								end
							end,
						})

						fn45(function()
							fn60()
						end)

						n52 = 1
						flag43 = false
						connection12 = nil

						do
							local part2 = nil
							n53 = 5

							destroyAll2 = function()
								pcall(function()
									part2:Destroy()
								end)

								part2 = nil
							end

							fn62 = function()
								connection12:Disconnect()
								connection12 = nil
								flag43 = false
								destroyAll2()
							end

							createPart = function()
								if part2.Parent then
									return part2
								end
								destroyAll2()
								local part3 = Instance.new("Part")
								part3.Name = fn20()
								part3.Anchored = true
								part3.CanCollide = true
								part3.CanQuery = false
								part3.CanTouch = false
								part3.CastShadow = false
								part3.Massless = true
								part3.Size = Vector3.new(6, 1, 6)
								part3.Transparency = 1
								part3.Parent = Workspace
								part2 = part3
								return part3
							end
						end
					end

					do
						local function fn63()
							fn62()
							flag43 = true

							connection12 = RunService.Heartbeat:Connect(function(deltaTime)
								if flag43 then
									local character_ = localPlayer.Character
									local humanoidRootPart = character_ and character_:FindFirstChild("HumanoidRootPart")
									if not humanoidRootPart then
										destroyAll2()
										return
									end
									local part2 = createPart()
									local n54 = math.min(deltaTime, 0.1) * n53
									local humanoid = character_:FindFirstChildOfClass("Humanoid")
									local n55 = 3.2

									if humanoid then
										n55 = humanoid.HipHeight + humanoidRootPart.Size.Y * 0.5
									end

									local n56 = humanoidRootPart.Position.Y - n55
									local y2 = part2.Position.Y
									local n57

									if math.abs(y2 + n52 * 0.5 - n56) > 6 then
										n57 = n56 - n52 * 0.5
									else
										n57 = y2 + n54
									end

									part2.CFrame = CFrame.new(humanoidRootPart.Position.X, n57, humanoidRootPart.Position.Z)
									local n58 = n57 + n52 * 0.5

									if n58 > n56 then
										local n59 = n58 + n55
										local n60 = humanoidRootPart.CFrame - humanoidRootPart.CFrame.Position
										humanoidRootPart.CFrame = CFrame.new(humanoidRootPart.Position.X, n59, humanoidRootPart.Position.Z) * n60
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
										fn63()
									else
										fn62()
									end
								end,
							}),
							Callback = function(arg)
								n53 = math.clamp(tonumber(arg) or 5, 5, 40)
							end,
						})
					end
				end

				local n52, flag40, n53, connection12, connection13, v68, tool2, v69, flag41, flag42
				local n54, fn60, fn61, fn62, fn63, fn64, fn65, fn66

				do
					local v70, autoRotate, obj4

					do
						n52 = 0.01
						flag40 = false
						n53 = 50
						connection12 = nil
						connection13 = nil
						v68 = nil
						v70 = nil
						autoRotate = true
						tool2 = nil
						v69 = nil
						flag41 = false
						flag42 = false
						n54 = 0
						obj4 = setmetatable({}, { __mode = "k" })

						fn60 = function(arg)
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

						fn61 = function(arg)
							local huge = math.huge
							local v71 = nil

							for _, player in ipairs(Players:GetPlayers()) do
								if player ~= localPlayer then
									local v72, v73, v74 = fn60(player)

									if v74 then
										local magnitude = (v74.Position - arg.Position).Magnitude

										if magnitude < huge then
											huge = magnitude
											v71 = v74
										end
									end
								end
							end

							return v71
						end

						do
							local function fn67(arg)
								arg = arg and arg:FindFirstChildWhichIsA("Tool")
								if arg and arg.Name:lower():find("bat", 1, true) then
									return arg
								end
								local backpack2 = localPlayer:FindFirstChildOfClass("Backpack")

								if backpack2 then
									for _, child in ipairs(backpack2:GetChildren()) do
										if child:IsA("Tool") and child.Name:lower():find("bat", 1, true) then
											return child
										end
									end
								end
							end

							fn62 = function(arg, arg2)
								local v71 = fn67(arg)

								if not v71 then
									if not flag42 then
										flag42 = true
										v36.Notify("Bat unavailable", "Bat was not found in your character or Backpack.", 5)
									end

									return nil
								end

								flag42 = false

								if v71.Parent ~= arg then
									local tool3 = arg:FindFirstChildWhichIsA("Tool")

									if tool3 and tool3 ~= v71 and not tool2 then
										tool2 = tool3
									end

									v69 = v71
									flag41 = true

									pcall(function()
										runUntilTimeout2(1)
										arg2:EquipTool(v71)
									end)
								end

								return v71.Parent == arg and v71 or nil
							end
						end
					end

					do
						local function fn67(arg)
							if not arg:IsA("BasePart") then
								return
							end

							if obj4[arg] == nil then
								obj4[arg] = arg.CanCollide
							end

							arg.CanCollide = false
						end

						fn63 = function()
							for k, v71 in pairs(obj4) do
								if k.Parent then
									pcall(function()
										k.CanCollide = v71
									end)
								end

								obj4[k] = nil
							end
						end

						fn64 = function(arg)
							if v68 ~= arg then
								connection13:Disconnect()
								connection13 = nil
								fn63()
								v68 = arg

								if arg then
									for _, descendant in ipairs(arg:GetDescendants()) do
										fn67(descendant)
									end

									connection13 = arg.DescendantAdded:Connect(function(descendant)
										fn67(descendant)
									end)

									return
								end
							end
						end
					end

					fn65 = function()
						local v702 = v70
						v70 = nil
						if not v702.Parent then
							return
						end

						pcall(function()
							v702.AutoRotate = autoRotate
							local physics = Enum.HumanoidStateType.Physics

							if v702:GetState() == physics then
								v702:ChangeState(Enum.HumanoidStateType.Freefall)
							end
						end)
					end

					fn66 = function(arg)
						if v70 ~= arg then
							fn65()
							v70 = arg
							autoRotate = arg.AutoRotate
						end

						arg.AutoRotate = false
						local physics = Enum.HumanoidStateType.Physics

						if arg:GetState() ~= physics then
							arg:ChangeState(Enum.HumanoidStateType.Physics)
						end
					end
				end

				do
					local fn67

					do
						do
							local function fn68()
								local character_ = localPlayer.Character
								local humanoid = character_ and character_:FindFirstChildOfClass("Humanoid")
								local v71 = v69
								local tool3 = tool2
								v69 = nil
								tool2 = nil
								if not flag41 or not character_ or not humanoid or humanoid.Health <= 0 then
									flag41 = false
									return
								end
								flag41 = false
								local tool4 = character_:FindFirstChildWhichIsA("Tool")
								if tool4 and tool4 ~= v71 then
									return
								end

								pcall(function()
									runUntilTimeout2(0.5)

									if tool3 and tool3.Parent then
										humanoid:EquipTool(tool3)
									else
										humanoid:UnequipTools()
									end
								end)
							end

							fn67 = function()
								flag40 = false
								n54 = 0
								flag42 = false
								connection12:Disconnect()
								connection12 = nil
								connection13:Disconnect()
								connection13 = nil
								v68 = nil
								fn65()
								fn63()
								fn68()
							end
						end
					end

					do
						local function fn68()
							fn67()
							flag40 = true

							connection12 = RunService.Heartbeat:Connect(function(deltaTime)
								local v70, v71, v72 = fn60(localPlayer)

								if not v70 or not v71 or not v72 then
									n54 = 0
									fn65()
									return
								end

								fn64(v70)
								local v73 = fn62(v70, v71)
								local v74 = fn61(v72)

								if not v74 then
									n54 = 0
									fn65()
									return
								end

								fn66(v71)
								local lookVector = v74.CFrame.LookVector
								local vector = Vector3.new(lookVector.X, 0, lookVector.Z)
								local vector2

								if vector.Magnitude <= 0.001 then
									vector2 = Vector3.new(0, 0, -1)
								else
									vector2 = vector.Unit
								end

								local position = v74.Position
								local n55 = position - v72.Position
								local magnitude = n55.Magnitude

								if magnitude > 0.001 then
									position = v72.Position + n55.Unit * math.min(magnitude, n53 * deltaTime)
								end

								v72.CFrame = CFrame.lookAt(position, position + vector2, Vector3.new(0, 1, 0))
								v72.AssemblyLinearVelocity = v74.AssemblyLinearVelocity
								v72.AssemblyAngularVelocity = Vector3.zero
								if not v73 then
									n54 = 0
									return
								end
								n54 += deltaTime
								local n56 = math.min(math.floor(n54 / n52), 6)

								if not (n56 <= 0) then
									n54 -= n56 * n52

									for i_ = 1, n56 do
										pcall(function()
											v73:Deactivate()
											v73:Activate()
										end)
									end
								end
							end)
						end

						fn45(fn67)

						section:CreateSlider({
							Name = "Follow Speed",
							DisplayName = "Follow Speed",
							SubOf = section:CreateToggle({
								Name = "Auto Hit Nearest Player",
								Default = false,
								Callback = function(arg)
									if arg then
										fn68()
									else
										fn67()
									end
								end,
							}),
							Min = 20,
							Max = 64,
							Default = 50,
							AllowDecimals = true,
							Increment = 0.1,
							Callback = function(arg)
								n53 = math.clamp(tonumber(arg) or 50, 20, 64)
							end,
						})
					end
				end

				constraintFlags = {
					BallSocketConstraint = true,
					NoCollisionConstraint = true,
					HingeConstraint = true,
				}

				tbl4 = {
					[Enum.HumanoidStateType.Physics] = true,
					[Enum.HumanoidStateType.Ragdoll] = true,
					[Enum.HumanoidStateType.FallingDown] = true,
				}

				n45 = 12
				n46 = 5
				n47 = 0
				result10 = nil

				do
					local ok13

					ok13, result3 = pcall(function()
						return require(ReplicatedStorage.Controllers.RagdollController)
					end)

					if ok13 then
						state = 100
					else
						state = 101
					end
				end
			elseif state == 100 then
				result10 = result3
				state = 101
			elseif state == 101 then
				do
					do
						local fn60, flag40, list2, list3, n52, v68, humanoid, disconnectAll3, fn61, fn62
						local fn63, fn64, fn65, fn66, fn67

						do
							do
								local v69 = nil

								fn60 = function()
									return v69
								end
							end

							flag40 = false

							do
								local connection12 = nil
								local n53 = 0
								list2 = {}
								list3 = {}
								n52 = 0
								v68 = nil
								humanoid = nil

								disconnectAll3 = function(arg)
									for _, v69 in ipairs(arg) do
										if v69.Connected then
											v69:Disconnect()
										end
									end

									table.clear(arg)
								end

								fn61 = function(arg)
									list2[#list2 + 1] = arg
								end

								fn62 = function(arg)
									list3[#list3 + 1] = arg
								end

								fn63 = function()
									if not (not v68 or not humanoid) then
										local humanoidRootPart = v68:FindFirstChild("HumanoidRootPart")

										if humanoidRootPart then
											local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
											local vector = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z)
											local n54 = humanoid.WalkSpeed + n46
											local y2 = assemblyLinearVelocity.Y
											local flag41 = false

											if n54 < vector.Magnitude then
												vector = vector.Unit * n54
												flag41 = true
											end

											if n47 < y2 then
												y2 = n47
												flag41 = true
											end

											if flag41 then
												pcall(function()
													humanoidRootPart.AssemblyLinearVelocity = Vector3.new(vector.X, y2, vector.Z)
												end)
											end
										end
									end
								end

								local function destroyAll2()
									if not (not v68 or not v68.Parent) then
										for _, descendant in ipairs(v68:GetDescendants()) do
											if constraintFlags[descendant.ClassName] then
												pcall(function()
													descendant:Destroy()
												end)
											end
										end
									end
								end

								local function fn68()
									if not (not v68 or not v68.Parent) then
										for _, descendant in ipairs(v68:GetDescendants()) do
											if descendant:IsA("AnimationConstraint") and not descendant.Enabled then
												pcall(function()
													descendant.Enabled = true
												end)
											end
										end
									end
								end

								local function fn69()
									local v69 = fn60()

									if v69 and v69.controlsEnabled == false then
										pcall(function()
											v69:Enable()
										end)
									end
								end

								fn64 = function()
									local currentCamera2 = Workspace.CurrentCamera

									if currentCamera2 and humanoid and currentCamera2.CameraSubject ~= humanoid then
										pcall(function()
											currentCamera2.CameraSubject = humanoid
										end)
									end
								end

								local function fn70()
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

								fn65 = function()
									local ok13, result14 = pcall(function()
										return result10.IsInRagdoll()
									end)

									return ok13 and result14 == true
								end

								fn66 = function()
									if connection12 then
										connection12:Disconnect()
										connection12 = nil
									end
								end

								fn67 = function()
									if not (not v68 or v68 ~= localPlayer.Character or not humanoid or not humanoid:IsDescendantOf(v68)) then
										n53 = os.clock() + n45

										if not connection12 then
											connection12 = RunService.Heartbeat:Connect(function()
												if v68 ~= localPlayer.Character or not humanoid or not humanoid:IsDescendantOf(v68) then
													fn66()
													return
												end
												fn63()
												destroyAll2()
												fn68()
												fn70()
												fn69()
												fn64()

												if os.clock() > n53 or not fn65() then
													fn66()
												end
											end)

											return
										end
									end
								end
							end
						end

						do
							local function fn68(arg)
								n52 += 1
								disconnectAll3(list3)
								fn66()
								v68 = arg
								humanoid = nil

								if arg then
									humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)

									if not (arg ~= localPlayer.Character or not humanoid or not humanoid:IsA("Humanoid")) then
										fn62(humanoid.StateChanged:Connect(function(old, new)
											if tbl4[new] then
												fn67()
											end
										end))

										fn62(arg.DescendantAdded:Connect(function(descendant)
											if constraintFlags[descendant.ClassName] then
												fn67()
											end
										end))

										fn64()

										if fn65() then
											fn67()
										end
									end
								end
							end

							local function fn69()
								flag40 = false
								n52 += 1
								fn66()
								disconnectAll3(list3)
								disconnectAll3(list2)
								v68 = nil
								humanoid = nil
							end

							local function fn70()
								fn69()
								flag40 = true
								fn60()

								fn61(localPlayer.CharacterAdded:Connect(function(character_)
									if flag40 then
										task.defer(function()
											if flag40 and character_ == localPlayer.Character then
												fn68(character_)
											end
										end)
									end
								end))

								fn61(localPlayer.CharacterRemoving:Connect(function(character_)
									if flag40 and character_ == v68 then
										n52 += 1
										fn66()
										disconnectAll3(list3)
										v68 = nil
										humanoid = nil
									end
								end))

								fn61(localPlayer:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
									if flag40 then
										fn67()
									end
								end))

								local packages = ReplicatedStorage:FindFirstChild("Packages")
								local net = packages and packages:FindFirstChild("Net")
								net = net and net:FindFirstChild("RE/CombatService/ApplyImpulse")

								if net then
									fn61(net.OnClientEvent:Connect(function()
										if flag40 then
											fn63()
											fn67()
										end
									end))
								end

								if localPlayer.Character then
									fn68(localPlayer.Character)
								end
							end

							fn45(fn69)

							characterSection:CreateToggle({
								Name = "Anti Ragdoll",
								Default = true,
								Callback = function(arg)
									if arg then
										fn70()
									else
										fn69()
									end
								end,
							})
						end
					end

					do
						local flag40, n52, connection12, connection13, connection14, animator, fn60, fn61, fn62, fn63

						do
							flag40 = false
							n52 = 0
							connection12 = nil
							connection13 = nil
							connection14 = nil
							animator = nil

							do
								local tbl14 = {}

								local function fn64(arg)
									local character_ = localPlayer.Character
									character_ = character_ and character_:FindFirstChildWhichIsA("Tool")
									if not character_ or not character_:IsA("Tool") then
										return false
									end
									local animation = arg.Animation
									local str5 = string.lower(tostring(arg.Name or ""))
									local str6 = string.lower(tostring(animation and animation.Name or ""))
									local priority = arg.Priority
									local flag41 = priority == Enum.AnimationPriority.Action or priority == Enum.AnimationPriority.Action2 or priority == Enum.AnimationPriority.Action3 or priority == Enum.AnimationPriority.Action4
									local flag42 = string.find(str5, "tool", 1, true) ~= nil or string.find(str5, "paint", 1, true) ~= nil or string.find(str5, "gun", 1, true) ~= nil or string.find(str6, "tool", 1, true) ~= nil or string.find(str6, "paint", 1, true) ~= nil or string.find(str6, "gun", 1, true) ~= nil
									return flag42 or flag41, flag42
								end

								fn60 = function()
									connection14:Disconnect()
									connection14 = nil
								end

								fn61 = function()
									connection12:Disconnect()
									connection12 = nil
									connection13:Disconnect()
									connection13 = nil
								end

								local function fn65(arg, arg2)
									local v68 = tbl14[arg]

									if v68 then
										tbl14[arg] = nil

										if v68.WeightConnection then
											v68.WeightConnection:Disconnect()
										end

										if v68.StoppedConnection then
											v68.StoppedConnection:Disconnect()
										end

										if arg2 then
											pcall(function()
												if arg.IsPlaying then
													arg:AdjustWeight(v68.DesiredWeight, 0.1)
												end
											end)
										end
									end
								end

								fn62 = function(arg)
									local ks = {}

									for k in pairs(tbl14) do
										ks[#ks + 1] = k
									end

									for _, v68 in ipairs(ks) do
										fn65(v68, arg)
									end
								end

								fn63 = function(arg)
									local v68, v69 = fn64(arg)

									if v68 then
										if tbl14[arg] then
											fn65(arg, true)
										elseif v69 then
											pcall(function()
												if arg.IsPlaying and arg.WeightTarget <= 0 and arg.WeightCurrent <= 0.01 then
													arg:AdjustWeight(1, 0.05)
												end
											end)
										end
									elseif not tbl14[arg] then
										local n53 = 1

										pcall(function()
											if arg.WeightTarget > 0 then
												n53 = arg.WeightTarget
											elseif arg.WeightCurrent > 0 then
												n53 = arg.WeightCurrent
											end
										end)

										local tbl15 = { Applying = false, DesiredWeight = n53 }
										tbl14[arg] = tbl15

										tbl15.WeightConnection = arg:GetPropertyChangedSignal("WeightTarget"):Connect(function()
											if tbl15.Applying then
												return
											end

											if fn64(arg) then
												fn65(arg, true)
												return
											end

											pcall(function()
												local weightTarget = arg.WeightTarget

												if weightTarget > 0 then
													tbl15.DesiredWeight = weightTarget
												end

												tbl15.Applying = true
												arg:AdjustWeight(0, 0)
											end)

											tbl15.Applying = false
										end)

										tbl15.StoppedConnection = arg.Stopped:Connect(function()
											fn65(arg, false)
										end)

										tbl15.Applying = true

										pcall(function()
											arg:AdjustWeight(0, 0)
										end)

										tbl15.Applying = false
										return
									end
								end
							end
						end

						local fn64, fn65

						do
							do
								local function fn66(arg)
									if arg == animator then
										for _, playingAnimationTrack in ipairs(arg:GetPlayingAnimationTracks()) do
											fn63(playingAnimationTrack)
										end
									end
								end

								fn64 = function(arg)
									fn60()
									fn61()
									fn62(arg)
									animator = nil
								end

								fn65 = function(arg)
									n52 += 1

									task.spawn(function()
										local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)

										if not (arg ~= localPlayer.Character or not humanoid) then
											local animator2 = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator", 5)

											if not (arg ~= localPlayer.Character or not animator2) then
												fn64(false)
												animator = animator2
												fn66(animator2)

												connection14 = animator2.AnimationPlayed:Connect(function(arg2)
													if animator == animator2 then
														fn63(arg2)
													end
												end)

												local function fn67(child)
													if not child:IsA("Tool") then
														return
													end

													task.defer(function()
														if arg == localPlayer.Character and animator == animator2 then
															fn66(animator2)
														end
													end)
												end

												connection12 = arg.ChildAdded:Connect(fn67)
												connection13 = arg.ChildRemoved:Connect(fn67)
												return
											end
										end
									end)
								end
							end
						end

						do
							local connection15 = localPlayer.CharacterAdded:Connect(function(character_)
								fn65(character_)
							end)

							fn45(function()
								flag40 = false
								n52 += 1
								fn64(true)
								connection15:Disconnect()
								connection15 = nil
							end)
						end

						characterSection:CreateToggle({
							Name = "No Animation",
							Default = true,
							Callback = function(arg)
								flag40 = arg == true

								if flag40 then
									local character_ = localPlayer.Character

									if character_ then
										fn65(character_)
									end
								else
									n52 += 1
									fn64(true)
								end
							end,
						})
					end
				end

				do
					local flag40, v68, v69, v70, v71, tbl14, tbl15, fn60, fn61, fn62

					do
						flag40 = false

						do
							local n52 = 0
							v68 = nil
							v69 = nil
							v70 = nil
							v71 = nil
							tbl14 = {}
							tbl15 = {}
							local obj4 = setmetatable({}, { __mode = "k" })

							local function fn63(arg, arg2)
								local v72 = obj4[arg]

								if v72 then
									obj4[arg] = nil

									if v72.CollisionConnection then
										v72.CollisionConnection:Disconnect()
									end

									if v72.DestroyingConnection then
										v72.DestroyingConnection:Disconnect()
									end

									if arg2 and arg.Parent then
										pcall(function()
											v72.Applying = true
											arg.CanCollide = v72.OriginalCanCollide
											v72.Applying = false
										end)
									end
								end
							end

							local function fn64(arg, arg2)
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

									for k in pairs(obj4) do
										if k:IsDescendantOf(character_) then
											ks[#ks + 1] = k
										end
									end

									for _, v72 in ipairs(ks) do
										fn63(v72, arg2)
									end
								end
							end

							fn60 = function(arg, arg2)
								local v72 = tbl15[arg]
								if not v72 then
									return
								end
								tbl15[arg] = nil

								if v72.DestroyingConnection then
									v72.DestroyingConnection:Disconnect()
									v72.DestroyingConnection = nil
								end

								fn64(v72, arg2)
							end

							fn61 = function(arg, arg2)
								local v72 = tbl14[arg]

								if v72 then
									tbl14[arg] = nil
									fn64(v72, arg2)

									if v72.CharacterAddedConnection then
										v72.CharacterAddedConnection:Disconnect()
									end

									if v72.CharacterRemovingConnection then
										v72.CharacterRemovingConnection:Disconnect()
									end

									if v72.WebConnection then
										v72.WebConnection:Disconnect()
									end

									if v72.WebTargetConnection then
										v72.WebTargetConnection:Disconnect()
									end
								end
							end

							fn62 = function()
								flag40 = false
								n52 += 1
								v68:Disconnect()
								v68 = nil
								v69:Disconnect()
								v69 = nil
								v70:Disconnect()
								v70 = nil
								v71:Disconnect()
								v71 = nil
								local ks = {}

								for k in pairs(tbl14) do
									ks[#ks + 1] = k
								end

								for _, v72 in ipairs(ks) do
									fn61(v72, true)
								end

								local ks2 = {}

								for k in pairs(tbl15) do
									ks2[#ks2 + 1] = k
								end

								for _, v72 in ipairs(ks2) do
									fn60(v72, true)
								end

								local ks3 = {}

								for k in pairs(obj4) do
									ks3[#ks3 + 1] = k
								end

								for _, v72 in ipairs(ks3) do
									fn63(v72, true)
								end
							end
						end
					end

					do
						local function fn63()
						end

						fn45(fn62)

						characterSection:CreateToggle({
							Name = "Disable Player Collision",
							Note = "Lets you move through other players and player clones without being blocked.",
							Default = true,
							Callback = function(arg)
								if arg then
									fn63()
								else
									fn62()
								end
							end,
						})
					end
				end

				local flag40, flag41, flag42, flag43, flag44, flag45, n52, n53, v68, v69
				local v70, n54, n55, n56, v71, v72, n57, v73, fn60, fn61
				local fn62, fn63, flag46, fn64

				do
					local v74, v75, n58

					do
						flag40 = false
						flag41 = false
						flag42 = false
						flag43 = true
						flag44 = false
						flag45 = false
						n52 = 0.09
						n53 = 225
						v68 = nil
						v69 = nil
						v70 = nil
						v74 = nil
						v75 = nil
						n54 = 0
						n55 = 0
						n56 = 0

						do
							local tbl14 = {}
							v71 = nil
							v72 = nil
							n58 = 0
							n57 = 0
							v73 = nil

							fn60 = function(arg)
								if arg and arg.Connected then
									arg:Disconnect()
								end
							end

							fn61 = function()
								for _, v76 in ipairs(tbl14) do
									fn60(v76)
								end

								table.clear(tbl14)
							end
						end
					end

					do
						fn62 = function(arg)
							if not arg or tbl3.ProtectedHumanoid ~= arg or arg.Health <= 0 then
								return false
							end

							local ok13, result14 = pcall(function()
								return arg.BreakJointsOnDeath == false and arg.RequiresNeck == false and arg:GetStateEnabled(Enum.HumanoidStateType.Dead) == false
							end)

							return ok13 and result14 == true
						end

						do
							local function fn65(arg, arg2)
								for _, descendant in ipairs(arg:GetDescendants()) do
									if descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
										local part0 = descendant.Part0
										local part1 = descendant.Part1

										if not (part0 and not part0:IsDescendantOf(arg)) then
											local part2 = part1 and not part1:IsDescendantOf(arg)
											local v76 = nil
											local v77 = nil

											if part2 then
												local part3 = part0
												part0 = part1
												part1 = part3
											else
												part0 = v76
												part1 = v77
											end
										end

										if part0 and part0:IsA("BasePart") and part1 and part1:IsA("BasePart") and part1:IsDescendantOf(arg) and (part0.Position - arg2.Position).Magnitude <= 5 then
											return part0, part1
										end
									end
								end

								return nil
							end

							local function fn66(arg)
								if localPlayer:GetAttribute("Stealing") ~= true then
									return nil
								end
								local character_ = localPlayer.Character
								local v69s = { arg }

								if v69 and v69.Parent and v69 ~= arg then
									v69s[#v69s + 1] = v69
								end

								local huge = math.huge
								local child = nil

								for _, child2 in ipairs(Workspace:GetChildren()) do
									if child2:IsA("Model") and child2 ~= character_ and not Players:GetPlayerFromCharacter(child2) and child2.Name:sub(-6) ~= "_Clone" then
										local rootPart = child2:FindFirstChild("RootPart") or child2.PrimaryPart or child2:FindFirstChildWhichIsA("BasePart")

										if rootPart and rootPart:IsA("BasePart") then
											for i_, v692 in ipairs(v69s) do
												local v76, v77 = fn65(child2, v692)

												if v76 and v77 then
													local vector = v692.CFrame:PointToObjectSpace(v76.Position)
													local magnitude = (v77.Position - v692.Position).Magnitude

													if math.abs(vector.X) <= 5 and vector.Y >= -3 and vector.Y <= 7 and vector.Z >= -7 and vector.Z <= 4 and magnitude <= 14 then
														local n59 = (v76.Position - v692.Position).Magnitude + magnitude * 0.05 + (i_ - 1) * 0.01

														if n59 < huge then
															huge = n59
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

							fn63 = function()
								n58 += 1
								local n582 = n58
								v72 = nil
								v73 = nil
								if not flag34 or not flag41 or not flag45 or localPlayer:GetAttribute("Stealing") ~= true then
									return
								end

								task.spawn(function()
									while flag34 and n582 == n58 and flag41 and flag45 and localPlayer:GetAttribute("Stealing") == true do
										local character_ = localPlayer.Character
										character_ = character_ and character_:FindFirstChild("HumanoidRootPart")

										if character_ then
											local v76 = fn66(character_)
											if v76 then
												v72 = v76
												return
											end
										end

										task.wait(0.15)
									end
								end)
							end
						end
					end

					do
						local function fn65()
							local v702 = v70

							if not (not v69 or not v69:IsDescendantOf(game) or not v702) then
								if not (v702 ~= localPlayer.Character or v702.Parent ~= Workspace) then
									local ok13 = pcall(function()
										local model = Instance.new("Model")
										model.Parent = game
										v702.Parent = model
										v69.Parent = v702
										v702.PrimaryPart = v69
										v702.Parent = Workspace
										v69.CanCollide = true

										for _, descendant in ipairs(v702:GetDescendants()) do
											if descendant:IsA("Weld") or descendant:IsA("Motor6D") then
												if descendant.Part0 == v68 then
													descendant.Part0 = v69
												end

												if descendant.Part1 == v68 then
													descendant.Part1 = v69
												end
											end
										end

										if v68 then
											local cFrame = v68.CFrame
											v68:Destroy()
											v68 = nil
											v69.CFrame = cFrame
										end

										local humanoid = v702:FindFirstChildOfClass("Humanoid")

										if humanoid and v74 ~= nil then
											humanoid.HipHeight = v74
										end

										model:Destroy()
									end)

									if not ok13 and v69 and v69.Parent then
										pcall(function()
											v69:Destroy()
										end)
									end

									return ok13
								end

								if v68 and v68.Parent then
									pcall(function()
										v68:Destroy()
									end)
								end

								if v69 and v69.Parent then
									pcall(function()
										v69:Destroy()
									end)
								end
							end

							return false
						end

						flag46 = false

						fn64 = function(arg)
							if arg ~= false then
								n55 += 1
								flag46 = false
							end

							n54 += 1
							n56 += 1
							flag41 = false
							n58 += 1
							v72 = nil
							v73 = nil
							n57 = 0
							v71 = nil

							if v75 then
								pcall(function()
									v75:Stop()
								end)

								pcall(function()
									v75:Destroy()
								end)

								v75 = nil
							end

							fn61()
							fn65()
							v68 = nil
							v69 = nil
							v70 = nil
							v74 = nil
						end
					end
				end

				local fn65, fn66

				do
					do
						local fn67 = nil

						fn67 = function()
							return true
						end

						fn65 = function(arg, arg2)
							n56 += 1
							local n562 = n56

							task.spawn(function()
								if arg2 and arg2 > 0 then
									task.wait(arg2)
								end

								for i_ = 1, 50 do
									if not flag34 or n562 ~= n56 or not flag40 or arg ~= localPlayer.Character then
										return
									end
									local humanoid = arg and arg:FindFirstChildOfClass("Humanoid")
									local humanoidRootPart = arg and arg:FindFirstChild("HumanoidRootPart")
									if humanoid and fn62(humanoid) and humanoidRootPart and humanoidRootPart.Parent == arg and fn67() then
										return
									end
									task.wait(0.1)
								end
							end)
						end
					end

					do
						local invisibleToggle = invisibilitySection:CreateToggle({
							Name = "Invisible",
							Default = false,
							Keybind = Enum.KeyCode.U,
							Callback = function(arg)
								flag40 = arg == true

								if flag40 then
									fn65(localPlayer.Character, 0.15)
								else
									fn64()
								end
							end,
						})

						fn66 = function()
							if not (not flag42 or not invisibleToggle) then
								local flag47 = localPlayer:GetAttribute("Stealing") == true
								if invisibleToggle:Get() ~= flag47 then
									invisibleToggle:Set(flag47, true)
									return
								end

								if flag47 then
									flag40 = true
								else
									flag40 = false
									fn64()
								end
							end
						end
					end
				end

				invisibilitySection:CreateToggle({
					Name = "Auto Invisible On Steal",
					Default = false,
					Callback = function(arg)
						flag42 = arg == true

						if flag42 then
							fn66()
						end
					end,
				})

				invisibilitySection:CreateToggle({
					Name = "Auto Rotation",
					Default = true,
					Callback = function(arg)
						flag45 = arg == true
						n57 = 0
						fn63()
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
						local clamp2 = math.clamp
						local floor = math.floor
						n53 = clamp2(floor((tonumber(arg) or 225) + 0.5), 180, 300)
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
						n52 = math.clamp(tonumber(arg) or 0.09, 0, 0.7)
					end,
				})

				invisibilitySection:CreateToggle({
					Name = "Lagback Detect",
					Default = true,
					Callback = function(arg)
						flag43 = arg == true
					end,
				})

				invisibilitySection:CreateToggle({
					Name = "Auto Fix Lagback",
					Default = false,
					Callback = function(arg)
						flag44 = arg == true

						if not flag44 then
							n55 += 1
							flag46 = false
						end
					end,
				})

				tbl.IsActive = function()
					return flag41 == true
				end

				tbl.GetDrop = function()
					local v702 = v70 or localPlayer.Character
					local humanoid = v702 and v702:FindFirstChildOfClass("Humanoid")

					if v702 then
						v702 = v702.PrimaryPart or v702:FindFirstChild("HumanoidRootPart")
					end

					return (humanoid and humanoid.HipHeight and humanoid.HipHeight > 0 and humanoid.HipHeight or 2) + (v702 and v702.Size and v702.Size.Y or 2) * 0.5 - 1 + n52
				end

				tbl.SuspendForReset = function(arg)
					local v702 = v70
					local v7022

					if v70 then
						v7022 = arg
					else
						v7022 = v702
					end

					if v7022 and arg ~= v70 then
						return false
					end
					local flag412 = flag41
					fn64()
					return flag412
				end

				tbl.ResumeIfRequested = function(arg)
					if arg == localPlayer.Character then
						fn65(arg, 0.05)
					end
				end

				do
					local connection12 = localPlayer:GetAttributeChangedSignal("Stealing"):Connect(function()
						fn66()
						fn63()
					end)

					local connection13 = localPlayer.CharacterRemoving:Connect(function(character_)
						if character_ == localPlayer.Character or character_ == v70 then
							fn64()
						end
					end)

					local connection14 = localPlayer.CharacterAdded:Connect(function(character_)
						if v70 and v70 ~= character_ then
							fn64()
						end

						fn65(character_, 0.35)
					end)

					fn45(function()
						flag40 = false
						flag42 = false
						flag46 = false
						fn64()
						fn60(connection12)
						fn60(connection13)
						fn60(connection14)
						tbl.SuspendForReset = nil
						tbl.ResumeIfRequested = nil
						tbl.IsActive = nil
						tbl.GetDrop = nil
					end)
				end

				flag11 = true
				flag12 = false
				flag36 = true
				flag37 = false
				flag38 = false
				v56 = nil
				v57 = nil
				flag39 = false
				connections2 = {}
				connection11 = nil
				chilliFastResetRuntime = CoreGui:FindFirstChild("__ChilliFastResetRuntime")

				if chilliFastResetRuntime then
					state = 102
				else
					state = 108
				end
			elseif state == 102 then
				cleanup2 = chilliFastResetRuntime:FindFirstChild("Cleanup")

				if cleanup2 then
					state = 104
				else
					state = 103
				end
			elseif state == 103 then
				cleanup3 = cleanup2
				state = 105
			elseif state == 104 then
				cleanup3 = cleanup2:IsA("BindableEvent")
				state = 105
			elseif state == 105 then
				if cleanup3 then
					state = 106
				else
					state = 107
				end
			elseif state == 106 then
				pcall(function()
					cleanup2:Fire()
				end)

				state = 107
			end
		elseif state <= 159 then
			if state <= 132 then
				if state <= 119 then
					if state == 107 then
						pcall(function()
							chilliFastResetRuntime:Destroy()
						end)

						state = 108
					elseif state == 108 then
						local chilliFastResetRuntime2, cleanup20, disconnectAll3, fn60, fn61, fn62, fn63

						do
							chilliFastResetRuntime2 = Instance.new("Folder")
							chilliFastResetRuntime2.Name = "__ChilliFastResetRuntime"
							chilliFastResetRuntime2.Archivable = false
							chilliFastResetRuntime2.Parent = CoreGui
							cleanup20 = Instance.new("BindableEvent")
							cleanup20.Name = "Cleanup"
							cleanup20.Parent = chilliFastResetRuntime2

							disconnectAll3 = function()
								for _, v68 in ipairs(connections2) do
									if v68.Connected then
										v68:Disconnect()
									end
								end

								table.clear(connections2)
							end

							do
								local function fn64()
									return false
								end

								fn60 = function()
									return fn64(localPlayer.Character, false)
								end

								local function fn65()
									local flag40 = not flag37
									if flag40 or flag38 then
										return
									end
									flag38 = true

									task.spawn(function()
										if flag37 then
										end

										flag38 = false
									end)
								end

								fn61 = function()
									if flag39 and v56 and v57 and type(hookfunction) == "function" then
										pcall(function()
											hookfunction(v56, v57)
										end)
									end

									flag39 = false
									v56 = nil
									v57 = nil
								end

								local function fn66()
									if flag39 then
										return true
									end

									if type(hookfunction) == "function" then
										local ok13, result14 = pcall(function()
											return require(ReplicatedStorage.Datas.AdminCommands.balloon).effects.Victim
										end)

										if not (not ok13 or type(result14) ~= "function") then
											v56 = result14
											local v68 = nil

											local ok14, result15 = pcall(function()
												return hookfunction(result14, function(...)
													local v69 = table.pack(v68(...))

													if flag37 then
														task.defer(fn65)
													end

													return table.unpack(v69, 1, v69.n)
												end)
											end)

											if not ok14 or type(result15) ~= "function" then
												v56 = nil
												return false
											end
											v68 = result15
											v57 = result15
											flag39 = true
											return true
										end
									end

									return false
								end

								fn62 = function(arg)
									flag37 = arg == true
									flag38 = false

									if flag37 then
										if not fn66() then
											flag37 = false
										end
									else
										fn61()
									end
								end

								fn63 = function(arg)
									disconnectAll3()
									if not flag36 or not arg then
										return
									end

									task.spawn(function()
										local humanoid = arg:FindFirstChildOfClass("Humanoid") or arg:WaitForChild("Humanoid", 5)
										if not flag36 or not humanoid or arg ~= localPlayer.Character then
											return
										end
										local v68, v69

										local function fn67()
										end

										connections2[#connections2 + 1] = humanoid.HealthChanged:Connect(function(health)
											if health <= 0 then
												fn67()
											end
										end)

										connections2[#connections2 + 1] = humanoid.Died:Connect(fn67)
									end)
								end
							end
						end

						do
							local function fn64(arg)
								flag36 = arg == true

								if flag36 then
									fn63(localPlayer.Character)
								else
									disconnectAll3()
								end
							end

							local function fn65()
								flag11 = false
								flag12 = false
								flag36 = false
								flag37 = false
								flag38 = false
								disconnectAll3()
								fn61()
								connection11:Disconnect()
								connection11 = nil
							end

							connection11 = localPlayer.CharacterAdded:Connect(function(character_)
								flag12 = false

								if flag36 then
									fn63(character_)
								end
							end)

							cleanup20.Event:Connect(fn65)
							chilliFastResetRuntime2.Destroying:Connect(fn65)
							respawnSection:CreateButton({ Name = "Fast Reset", ButtonText = "Reset", Callback = fn60 })
							respawnSection:CreateToggle({ Name = "Auto Fast Reset", Default = true, Callback = fn64 })
						end

						do
							respawnSection:CreateToggle({ Name = "Auto Reset Balloon", Default = false, Callback = fn62 })
							fn63(localPlayer.Character)
							playerEspSection = espTab:CreateSection({ Name = "Player ESP", Expanded = false })
							brainrotEspSection = espTab:CreateSection({ Name = "Brainrot ESP", Expanded = false })
							brainrotNotificationsSection = espTab:CreateSection({ Name = "Brainrot Notifications", Expanded = false })
							baseEspSection = espTab:CreateSection({ Name = "Base ESP", Expanded = false })

							fn50 = function()
								if type(gethui) == "function" then
									local ok13, result14 = pcall(gethui)
									if ok13 and typeof(result14) == "Instance" then
										return result14
									end
								end

								return CoreGui
							end

							fn51 = function(name)
								local v68 = fn50()
								local tbl14 = {}

								for _, v69 in ipairs({ v68, CoreGui }) do
									if v69 and not tbl14[v69] then
										tbl14[v69] = true
										local v70 = v69:FindFirstChild(name)

										if v70 then
											local cleanup21 = v70:FindFirstChild("Cleanup")

											if cleanup21 and cleanup21:IsA("BindableEvent") then
												pcall(function()
													cleanup21:Fire()
												end)
											end

											pcall(function()
												v70:Destroy()
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
								screenGui.Parent = v68
								local cleanup21 = Instance.new("BindableEvent")
								cleanup21.Name = "Cleanup"
								cleanup21.Parent = screenGui
								return screenGui, cleanup21
							end

							disconnectAll2 = function(arg)
								for _, v68 in ipairs(arg) do
									if typeof(v68) == "RBXScriptConnection" then
										v68:Disconnect()
									end
								end

								table.clear(arg)
							end

							fn52 = function()
								local v68 = Workspace:FindFirstChild(localPlayer.Name)

								if not (not v68 or not v68:IsA("Model")) then
									local humanoidRootPart = v68:FindFirstChild("HumanoidRootPart")
									if humanoidRootPart and humanoidRootPart:IsA("BasePart") and humanoidRootPart.Parent == v68 then
										return humanoidRootPart
									end
									local hitbox = v68:FindFirstChild("__HITBOX") or v68:FindFirstChild("__hitbox") or v68:FindFirstChild("Hitbox") or v68:FindFirstChild("HitBox")
									if hitbox and hitbox:IsA("BasePart") then
										return hitbox
									end
								end

								return nil
							end

							fn53 = function(arg)
								arg = arg and arg:FindFirstChild("PlotSign")
								if not arg then
									return nil
								end

								for _, descendant in ipairs(arg:GetDescendants()) do
									if descendant:IsA("TextLabel") then
										local str5 = tostring(descendant.Text or "")
										if str5 ~= "" and string.lower(str5) ~= "your base" and string.find(string.lower(str5), "base", 1, true) then
											return descendant
										end
									end
								end

								return nil
							end

							fn54 = function(arg)
								local str5 = fn53(arg)

								if str5 then
									str5 = tostring(str5.Text or "")
								end

								str5 = str5 or ""
								return str5 ~= "" and str5 or "Base"
							end

							do
								local n52 = 12

								fn55 = function(arg)
									if not arg then
										return nil
									end
									local animalPodiums = arg:FindFirstChild("AnimalPodiums")
									local huge = math.huge
									local n53 = -math.huge
									local n54 = -math.huge
									local huge2 = math.huge
									local huge3 = math.huge

									if animalPodiums then
										for _, child in ipairs(animalPodiums:GetChildren()) do
											local base = child:FindFirstChild("Base")
											base = base and base:FindFirstChild("Spawn")

											if base and base:IsA("BasePart") then
												local position = base.Position
												huge3 = math.min(huge3, position.X)
												n54 = math.max(n54, position.X)
												huge = math.min(huge, position.Z)
												n53 = math.max(n53, position.Z)
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
										x = (huge3 + n54) * 0.5
										z = (huge + n53) * 0.5
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
									return Vector3.new(x, huge2 + n52, z)
								end
							end
						end

						isBasePart = function(arg)
							return arg and arg:IsA("BasePart") and (arg.Name == "PlotSign" or arg.Name == "MainRoot" or arg.Name == "Spawn")
						end

						tbl5 = { YourBaseClear = false, ClearBaseTransparency = 0.8 }

						do
							local list2 = {}

							fn56 = function(arg)
								list2[#list2 + 1] = arg
							end

							fn57 = function(arg, arg2)
								if tbl5[arg] ~= arg2 then
									tbl5[arg] = arg2

									for _, v68 in ipairs(list2) do
										pcall(v68, arg, arg2)
									end
								end
							end
						end

						result13 = nil

						ok, result4 = pcall(function()
							return require(ReplicatedStorage.Datas.Index)
						end)

						if ok then
							state = 109
						else
							state = 110
						end
					elseif state == 109 then
						ok = type(result4) == "table"
						state = 110
					elseif state == 110 then
						if ok then
							state = 111
						else
							state = 112
						end
					elseif state == 111 then
						result13 = result4
						state = 112
					elseif state == 112 then
						local valueMap, tbl14, tbl15

						do
							do
								do
									fn58 = function(arg)
										local baseColors = {}
										local result14 = result13 and result13[arg]

										if result14 then
											if type(result14.BaseColors) == "table" then
												for _, baseColor in pairs(result14.BaseColors) do
													if typeof(baseColor) == "Color3" then
														baseColors[#baseColors + 1] = baseColor
													end
												end
											end

											if #baseColors == 0 and typeof(result14.MainColor) == "Color3" then
												baseColors[#baseColors + 1] = result14.MainColor
											end
										end

										return baseColors
									end

									n48 = 5
									n49 = 12
									n50 = 4.5

									torsoList = {
										"HumanoidRootPart",
										"LowerTorso",
										"UpperTorso",
										"Torso",
										"Head",
									}

									font = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold, Enum.FontStyle.Italic)
									n51 = 0.25
									transparency = 0

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

									font2 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)

									do
										local colorSequenceNew = ColorSequence.new
										local tbl16 = {}
										local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 255, 205))
										local v69 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(125, 225, 255))
										local new = ColorSequenceKeypoint.new
										local color3FromRGB = Color3.fromRGB
										tbl16[1] = v68
										tbl16[2] = v69

										do
											local values = table.pack(new(1, color3FromRGB(210, 135, 255)))
											table.move(values, 1, values.n, 3, tbl16)
										end

										v59 = colorSequenceNew(tbl16)
									end
								end

								do
									local new = ColorSequenceKeypoint.new
									local color3FromRGB = Color3.fromRGB

									colorSequence = ColorSequence.new({
										ColorSequenceKeypoint.new(0, Color3.fromRGB(7, 73, 66)),
										new(1, color3FromRGB(35, 17, 79)),
									})
								end

								do
									local colorSequenceNew = ColorSequence.new
									local tbl16 = {}
									local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
									local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
									local new = ColorSequenceKeypoint.new
									local color3FromRGB = Color3.fromRGB
									tbl16[1] = v68
									tbl16[2] = v69

									do
										local values = table.pack(new(1, color3FromRGB(184, 0, 18)))
										table.move(values, 1, values.n, 3, tbl16)
									end

									v60 = colorSequenceNew(tbl16)
								end
							end

							do
								local colorSequenceNew = ColorSequence.new
								local tbl16 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
								local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
								local new = ColorSequenceKeypoint.new
								local color3FromRGB = Color3.fromRGB
								tbl16[1] = v68
								tbl16[2] = v69

								do
									local values = table.pack(new(1, color3FromRGB(18, 0, 3)))
									table.move(values, 1, values.n, 3, tbl16)
								end

								v61 = colorSequenceNew(tbl16)
							end

							do
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

								tbl14 = {}

								tbl15 = {
									Limit = 1000000,
									Fill = Color3.fromRGB(255, 196, 66),
									Outline = Color3.fromRGB(255, 232, 152),
								}

								do
									local colorSequenceNew = ColorSequence.new
									local tbl16 = {}
									local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
									local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
									local new = ColorSequenceKeypoint.new
									local color3FromRGB = Color3.fromRGB
									tbl16[1] = v68
									tbl16[2] = v69

									do
										local values = table.pack(new(1, color3FromRGB(214, 142, 12)))
										table.move(values, 1, values.n, 3, tbl16)
									end

									tbl15.Text = colorSequenceNew(tbl16)
								end
							end

							do
								local colorSequenceNew = ColorSequence.new
								local tbl16 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
								local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
								local new = ColorSequenceKeypoint.new
								local color3FromRGB = Color3.fromRGB
								tbl16[1] = v68
								tbl16[2] = v69

								do
									local values = table.pack(new(1, color3FromRGB(20, 12, 0)))
									table.move(values, 1, values.n, 3, tbl16)
								end

								tbl15.Stroke = colorSequenceNew(tbl16)
							end
						end

						local tbl16

						do
							do
								tbl16 = {
									Limit = 10000000,
									Fill = Color3.fromRGB(255, 146, 40),
									Outline = Color3.fromRGB(255, 194, 112),
								}

								do
									local colorSequenceNew = ColorSequence.new
									local tbl17 = {}
									local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
									local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
									local new = ColorSequenceKeypoint.new
									local color3FromRGB = Color3.fromRGB
									tbl17[1] = v68
									tbl17[2] = v69

									do
										local values = table.pack(new(1, color3FromRGB(206, 92, 0)))
										table.move(values, 1, values.n, 3, tbl17)
									end

									tbl16.Text = colorSequenceNew(tbl17)
								end
							end

							do
								local colorSequenceNew = ColorSequence.new
								local tbl17 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 50, 0))
								local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 25, 0))
								local new = ColorSequenceKeypoint.new
								local color3FromRGB = Color3.fromRGB
								tbl17[1] = v68
								tbl17[2] = v69

								do
									local values = table.pack(new(1, color3FromRGB(18, 8, 0)))
									table.move(values, 1, values.n, 3, tbl17)
								end

								tbl16.Stroke = colorSequenceNew(tbl17)
							end
						end

						local tbl17

						do
							tbl17 = {
								Limit = 100000000,
								Fill = Color3.fromRGB(255, 82, 38),
								Outline = Color3.fromRGB(255, 140, 96),
							}

							do
								local colorSequenceNew = ColorSequence.new
								local tbl18 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 158, 116))
								local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
								local new = ColorSequenceKeypoint.new
								local color3FromRGB = Color3.fromRGB
								tbl18[1] = v68
								tbl18[2] = v69

								do
									local values = table.pack(new(1, color3FromRGB(196, 40, 0)))
									table.move(values, 1, values.n, 3, tbl18)
								end

								tbl17.Text = colorSequenceNew(tbl18)
							end
						end

						do
							local colorSequenceNew = ColorSequence.new
							local tbl18 = {}
							local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(108, 24, 0))
							local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(54, 12, 0))
							local new = ColorSequenceKeypoint.new
							local color3FromRGB = Color3.fromRGB
							tbl18[1] = v68
							tbl18[2] = v69

							do
								local values = table.pack(new(1, color3FromRGB(18, 4, 0)))
								table.move(values, 1, values.n, 3, tbl18)
							end

							tbl17.Stroke = colorSequenceNew(tbl18)
						end

						do
							local tbl18 = {
								Limit = math.huge,
								Fill = Color3.fromRGB(220, 12, 28),
								Outline = Color3.fromRGB(255, 55, 65),
								Text = v60,
								Stroke = v61,
							}

							tbl14[1] = tbl15
							tbl14[2] = tbl16
							tbl14[3] = tbl17
							tbl14[4] = tbl18
						end

						do
							do
								local function fn60(arg)
									if type(arg) ~= "string" then
										return nil
									end
									local match2, str5 = arg:match("%$%s*([%d%.]+)%s*(%a*)")
									local num3 = tonumber(match2)
									if not num3 then
										return nil
									end

									if str5 ~= "" then
										str5 = str5:sub(1, 1):upper() .. str5:sub(2):lower()
									end

									return num3 * (valueMap[str5] or 1)
								end

								fn59 = function(arg)
									local v68 = fn60(arg)

									if v68 then
										for _, v69 in ipairs(tbl14) do
											if v68 < v69.Limit then
												return v69
											end
										end
									end

									return tbl14[#tbl14]
								end
							end
						end

						do
							local function fn60()
								if type(gethui) == "function" then
									local ok13, result14 = pcall(gethui)
									if ok13 and typeof(result14) == "Instance" then
										return result14
									end
								end

								return CoreGui
							end

							v23 = fn60()
						end

						tbl6 = {}
						forIter_1 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v68, v310, v410, v510, v69, v72, v82, v92, v102 in f, s, var do coroutine.yield(true, {k, v68, v310, v410, v510, v69, v72, v82, v92, v102}) end end); co(); return co end)(ipairs({ v23, CoreGui }))
						state = 113
					elseif state == 113 then
						local forOk_1, forVals_1 = forIter_1()

						if forOk_1 then
							do
								local v68
								v68, v62 = forVals_1[1], forVals_1[2]
							end

							state = 201
						else
							state = 114
						end
					elseif state == 114 then
						do
							local chilliPlayerESPRuntime2, cleanup20, flag40, enabledFlags3, n52, playerMap, connections3, userIdMap, n53, disconnectAll3
							local fn60, fn61, fn62, fn63, fn64, fn65, fn66, fn67, fn68, fn69

							do
								local screenGui, fn70, getTool, parseVector3, fn71

								do
									do
										chilliPlayerESPRuntime2 = Instance.new("ScreenGui")
										chilliPlayerESPRuntime2.Name = "__ChilliPlayerESPRuntime"
										chilliPlayerESPRuntime2.Archivable = false
										chilliPlayerESPRuntime2.ResetOnSpawn = false
										chilliPlayerESPRuntime2.IgnoreGuiInset = true
										chilliPlayerESPRuntime2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
										chilliPlayerESPRuntime2.DisplayOrder = 50
										chilliPlayerESPRuntime2.Parent = v23
										cleanup20 = Instance.new("BindableEvent")
										cleanup20.Name = "Cleanup"
										cleanup20.Parent = chilliPlayerESPRuntime2
										screenGui = chilliPlayerESPRuntime2
										flag40 = false

										enabledFlags3 = {
											Name = true,
											Username = false,
											Avatar = true,
											Tool = true,
											Brainrot = true,
											["Admin Panel"] = true,
										}

										n52 = 1
										playerMap = {}
										connections3 = {}
										userIdMap = {}
										n53 = 0

										disconnectAll3 = function(arg)
											for _, v68 in ipairs(arg) do
												if v68.Connected then
													v68:Disconnect()
												end
											end

											table.clear(arg)
										end

										fn60 = function(arg)
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

										fn61 = function(arg, nameDisplayHumanoid)
											nameDisplayHumanoid = nameDisplayHumanoid and nameDisplayHumanoid:FindFirstChildOfClass("Humanoid")
											if not nameDisplayHumanoid then
												return
											end

											if arg.NameDisplayHumanoid ~= nameDisplayHumanoid then
												fn60(arg)
												arg.NameDisplayHumanoid = nameDisplayHumanoid
												arg.NameDisplayDistance = nameDisplayHumanoid.NameDisplayDistance
											end

											nameDisplayHumanoid.NameDisplayDistance = 0
										end

										do
											local function fn72(arg)
												local str5 = tostring(arg or "")
												if str5 == "" then
													return ""
												end

												if str5:match("^%d+$") then
													return "rbxassetid://" .. str5
												end
												return str5
											end

											fn70 = function(arg)
												if not (not arg or not arg:IsA("Tool")) then
													local v68 = fn72(arg.TextureId)

													if v68 == "" then
														for _, v69 in ipairs({ "Icon", "Image", "Thumbnail", "TextureId" }) do
															local attribute = arg:GetAttribute(v69)
															if type(attribute) ~= "string" then
																continue
															end
															v68 = fn72(attribute)
															if v68 ~= "" then
																return v68
															end
														end

														for _, descendant in ipairs(arg:GetDescendants()) do
															if descendant:IsA("Decal") or descendant:IsA("Texture") then
																v68 = fn72(descendant.Texture)
															elseif descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
																v68 = fn72(descendant.Image)
															end

															if v68 ~= "" then
																return v68
															end
														end

														return ""
													end

													return v68
												end

												return ""
											end
										end
									end

									do
										local fn72, fn73

										do
											getTool = function(arg)
												return arg and arg:FindFirstChildOfClass("Tool") or nil
											end

											fn62 = function(arg, arg2)
												for _, v68 in ipairs(torsoList) do
													local v69 = arg:FindFirstChild(v68)
													if v69 and v69:IsA("BasePart") then
														return v69
													end
												end

												return arg2
											end

											parseVector3 = function(arg, arg2)
												if arg2 == arg then
													return Vector3.new(0, 3.1, 0)
												end
												local n54 = arg.Position.Y - arg2.Position.Y
												if math.abs(n54) <= n50 then
													return Vector3.new(0, math.clamp(n54 + 3.1, 3.8, 6), 0)
												end
												return Vector3.new(0, 4.8, 0)
											end

											fn72 = function(arg, arg2)
												for _, descendant in ipairs(arg:GetDescendants()) do
													if descendant:IsA("Weld") or descendant:IsA("WeldConstraint") then
														local part0 = descendant.Part0
														local part1 = descendant.Part1
														local part2

														if part0 and not part0:IsDescendantOf(arg) then
															part2 = part0
														else
															local part3 = part1 and not part1:IsDescendantOf(arg)
															local v68 = nil
															local v69 = nil

															if part3 then
																part2 = part1
																part1 = part0
															else
																part2 = v68
																part1 = v69
															end
														end

														if part2 and part2:IsA("BasePart") and part2.Parent == Workspace and part1 and part1:IsA("BasePart") and part1:IsDescendantOf(arg) and (part2.Position - arg2.Position).Magnitude <= n48 then
															return part2, part1
														end
													end
												end

												return nil
											end

											do
												local function fn74(arg)
													if type(arg) ~= "string" or not arg:find("/s", 1, true) then
														return false
													end
													local match2 = arg:match("%$([%d%.]+)")
													local flag41 = match2 ~= nil

													if flag41 then
														flag41 = (tonumber(match2) or 0) > 0
													end

													return flag41
												end

												local function fn75(arg, arg2)
													for k, attribute in pairs(arg:GetAttributes()) do
														if k ~= "__AssetDescendantCount" and arg2:GetAttribute(k) ~= attribute then
															return false
														end
													end

													return true
												end

												fn73 = function(arg)
													local generation = arg:FindFirstChild("Generation", true)
													if generation and generation:IsA("TextLabel") and fn74(generation.Text) then
														return generation
													end
													local plots2 = Workspace:FindFirstChild("Plots")
													local debris = Workspace:FindFirstChild("Debris")

													if not (not plots2 or not debris) then
														local positions = {}
														local positions2 = {}

														for _, child in ipairs(plots2:GetChildren()) do
															for _, child2 in ipairs(child:GetChildren()) do
																if child2:IsA("Model") and child2.Name == arg.Name then
																	local position = child2:GetPivot().Position
																	positions2[#positions2 + 1] = position

																	if fn75(arg, child2) then
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

																	if displayName and displayName:IsA("TextLabel") and displayName.Text == arg.Name and generation3 and generation3:IsA("TextLabel") and fn74(generation3.Text) then
																		local huge2 = math.huge

																		for _, position in ipairs(positions) do
																			huge2 = math.min(huge2, (child.Position - position).Magnitude)
																		end

																		local isTextLabel = text and animalOverhead and animalOverhead:IsA("TextLabel") and animalOverhead.Text ~= text
																		local n54 = 0

																		if isTextLabel then
																			n54 = 1000
																		end

																		local n55 = huge2 + n54

																		if n55 < huge then
																			huge = n55
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
											end
										end

										do
											local function fn74(arg)
												if not arg then
													return nil
												end
												local mutation = arg:FindFirstChild("Mutation", true)
												if mutation and mutation:IsA("TextLabel") then
													return mutation
												end
												return nil
											end

											fn71 = function(arg)
												if not (arg and arg.Parent and arg.Visible) then
													return nil
												end
												local str5 = tostring(arg.Text or "")
												if str5 == "" then
													return nil
												end

												local tbl14 = {
													Text = str5,
													RichText = arg.RichText == true,
													Color = arg.TextColor3,
													Font = arg.FontFace,
													Gradient = nil,
													StrokeColor = nil,
												}

												local uiStroke = arg:FindFirstChildOfClass("UIStroke")

												if uiStroke then
													tbl14.StrokeColor = uiStroke.Color
												end

												local uiGradient = arg:FindFirstChildOfClass("UIGradient")

												if uiGradient then
													tbl14.Gradient = { Color = uiGradient.Color, Rotation = uiGradient.Rotation }
												end

												return tbl14
											end

											fn63 = function(arg)
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
																local v68, v69 = fn72(child2, humanoidRootPart)

																if v68 and v69 then
																	local vector = humanoidRootPart.CFrame:PointToObjectSpace(v68.Position)
																	local magnitude = (v69.Position - humanoidRootPart.Position).Magnitude

																	if math.abs(vector.X) <= 4 and vector.Y >= -2 and vector.Y <= 6 and vector.Z >= -6 and vector.Z <= 3 and magnitude <= n49 then
																		local n54 = (v68.Position - humanoidRootPart.Position).Magnitude + magnitude * 0.05

																		if n54 < huge then
																			huge = n54
																			child = child2
																		end
																	end
																end
															end
														end
													end

													if child then
														local v68 = fn73(child)
														return child.Name, child, v68 and v68.Text or nil, v68, fn74(child)
													end
												end

												return nil
											end
										end
									end
								end

								do
									do
										local function clampValue2()
											local currentCamera2 = Workspace.CurrentCamera
											return math.max(1, math.floor(math.clamp((currentCamera2 and currentCamera2.ViewportSize.Y or 1080) * 0.024, 26, 35) * n52))
										end

										local function fn72(text, font4, size)
											local getTextBoundsParams = Instance.new("GetTextBoundsParams")
											getTextBoundsParams.Text = text
											getTextBoundsParams.Font = font4
											getTextBoundsParams.Size = size
											getTextBoundsParams.Width = 1000

											local ok13, result14 = pcall(function()
												return TextService:GetTextBoundsAsync(getTextBoundsParams)
											end)

											getTextBoundsParams:Destroy()
											if ok13 then
												return result14.X
											end
											return (utf8.len(text) or #text) * size * 0.56
										end

										local function fn73(uiStroke, color3, arg, arg2)
											uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
											uiStroke.Color = color3
											uiStroke.Enabled = true
											uiStroke.LineJoinMode = Enum.LineJoinMode.Round
											uiStroke.Transparency = 0

											local ok13 = pcall(function()
												uiStroke.BorderOffset = UDim.new(0, 0)
												uiStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer
												uiStroke.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
											end)

											uiStroke.Thickness = ok13 and arg or arg2
											return ok13
										end

										local function createTextLabel(name, parent2, zIndex)
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
											textLabel.Parent = parent2
											return textLabel
										end

										fn64 = function(arg, hasTool)
											local numVal = clampValue2()
											local visible2 = enabledFlags3.Name == true
											local text = enabledFlags3.Username == true
											local visible3 = enabledFlags3.Avatar == true
											local flag41 = enabledFlags3.Tool == true
											local visible4 = enabledFlags3.Brainrot == true
											local visible5 = enabledFlags3["Admin Panel"] == true
											local visible6 = visible3 and math.floor(numVal * 0.72) or 0
											local flag412 = flag41 and math.floor(numVal * 0.82) or 0
											local n54 = math.floor(numVal * 0.7)
											local n55 = math.max(1, math.floor(numVal * 0.04))
											local targetPlayer = arg.TargetPlayer
											text = text and targetPlayer.Name or targetPlayer.DisplayName
											arg.DisplayName.Text = text
											arg.NameShadow.Text = text
											local n56 = math.floor(math.clamp(fn72(arg.DisplayName.Text, font2, n54) + 4, n54, 230))
											local hasTool2 = flag41 and hasTool
											local n57 = 0
											local n58 = 0

											if visible3 then
												n57 = 0 + visible6
											end

											local n59 = 0

											if visible2 then
												if not (n57 > 0) then
													n59 = n57
												else
													n59 = n57 + n55
												end

												n57 = n59 + n56
											end

											local n60 = 0

											if hasTool2 then
												if not (n57 > 0) then
													n60 = n57
												else
													n60 = n57 + n55
												end

												n57 = n60 + flag412
											end

											local n61 = math.max(n57, 1)
											visible4 = visible4 and type(arg.BrainrotName) == "string" and arg.BrainrotName ~= ""
											local n62 = math.floor(numVal * 0.88)
											local n63 = -math.max(2, math.floor(numVal * 0.16))
											local brainrotName = visible4 and arg.BrainrotName or ""
											local visible7 = visible4 and math.floor(math.clamp(fn72(brainrotName, font2, n62) + 6, n62, 320)) or 0
											local visible8 = visible4 and type(arg.BrainrotGeneration) == "string" and arg.BrainrotGeneration ~= ""
											local brainrotGeneration = visible8 and arg.BrainrotGeneration or ""
											local n64 = math.max(2, math.floor(numVal * 0.12))
											local visible9 = visible8 and math.floor(math.clamp(fn72(brainrotGeneration, font2, n62) + 4, n62, 150)) or 0
											local n65 = visible7 + (visible8 and n64 + visible9 or 0)
											local visible10 = visible2 and n59 + n56 * 0.5 or n61 * 0.5
											local n66 = visible10 - n65 * 0.5
											local n67 = math.min(0, n66)
											local n68 = math.max(n61, n66 + n65)
											local v68 = math.ceil(n68 - n67)
											visible5 = visible5 and arg.IsAdmin == true
											local n69 = math.max(1, math.floor(numVal * 0.6))
											local visible11 = visible5 and math.floor(math.clamp(fn72("Admin Panel", font, n69) + 3, n69, 150)) or 0
											local n70 = n69 + -math.max(2, math.floor(numVal * 0.2))
											local brainrotMutation = visible4 and arg.BrainrotMutation or nil
											local visible12 = brainrotMutation ~= nil
											local n71 = math.floor(numVal * 0.62)
											local n72 = -math.max(1, math.floor(numVal * 0.1))
											local visible13 = visible12 and math.floor(math.clamp(fn72(brainrotMutation.Text:gsub("<[^<>]->", ""), font2, n71) + 6, n71, 260)) or 0
											local visible14 = visible12 and n71 + n72 or 0
											local n73 = visible10 - visible13 * 0.5
											local n74

											if visible12 then
												n74 = math.min(n67, n73)
												v68 = math.ceil(math.max(n68, n73 + visible13) - n74)
											else
												n74 = n67
											end

											local visible15 = visible4 and n62 + n63 or 0
											local n75 = n70 + visible14 + visible15 + numVal
											local n76 = -n74
											local n77 = n76 + n66
											local n78 = (n70 + visible14 + visible15 + numVal * 0.5) / n75
											local visible16 = visible4 and (n70 + visible14 + n62 * 0.5) / n75 or 0
											local visible17 = visible12 and (n70 + n71 * 0.5) / n75 or 0
											local visible18 = visible5 and n69 * 0.5 / n75 or 0
											local n79 = 1 / v68
											local n80 = 1 / n75
											arg.HasTool = hasTool
											arg.Billboard.Size = UDim2.fromOffset(v68, n75)
											arg.DisplayName.Visible = visible2
											arg.NameShadow.Visible = visible2
											arg.Avatar.Visible = visible3
											arg.ToolIcon.Visible = flag41 and arg.ToolIcon.Image ~= ""
											arg.ToolShadow.Visible = flag41 and arg.ToolShadow.Image ~= ""
											arg.Avatar.Position = UDim2.fromScale((n76 + n58) / v68, n78)
											arg.Avatar.Size = UDim2.fromScale(visible6 / v68, visible6 / n75)
											arg.DisplayName.Position = UDim2.fromScale((n76 + n59) / v68, n78)
											arg.DisplayName.Size = UDim2.fromScale(n56 / v68, n54 / n75)
											arg.NameShadow.Position = UDim2.fromScale((n76 + n59) / v68 + n79, n78 + n80)
											arg.NameShadow.Size = arg.DisplayName.Size
											arg.ToolIcon.Position = UDim2.fromScale((n76 + n60) / v68, n78)
											arg.ToolIcon.Size = UDim2.fromScale(flag412 / v68, flag412 / n75)
											arg.ToolShadow.Position = UDim2.fromScale((n76 + n60) / v68 + n79, n78 + n80)
											arg.ToolShadow.Size = arg.ToolIcon.Size
											arg.AdminLine.Visible = visible5

											if visible5 then
												arg.AdminLine.Position = UDim2.fromScale((n76 + visible10) / v68, visible18)
												arg.AdminLine.Size = UDim2.fromScale(visible11 / v68, n69 / n75)
												arg.AdminText.Position = UDim2.fromScale(0, 0.5)
												arg.AdminText.Size = UDim2.fromScale(visible11 / visible11, 1)
												arg.AdminShadow.Position = UDim2.fromScale(1 / visible11, 0.5 + 1 / n69)
												arg.AdminShadow.Size = arg.AdminText.Size
											end

											arg.MutationText.Visible = visible12
											arg.MutationShadow.Visible = visible12

											if visible12 then
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

												arg.MutationText.Position = UDim2.fromScale((n76 + n73) / v68, visible17)
												arg.MutationText.Size = UDim2.fromScale(visible13 / v68, n71 / n75)
												arg.MutationShadow.Position = UDim2.fromScale((n76 + n73) / v68 + n79, visible17 + n80)
												arg.MutationShadow.Size = arg.MutationText.Size
											end

											arg.BrainrotText.Text = brainrotName
											arg.BrainrotShadow.Text = brainrotName
											arg.BrainrotText.Visible = visible4
											arg.BrainrotShadow.Visible = visible4
											arg.GenerationText.Text = brainrotGeneration
											arg.GenerationShadow.Text = brainrotGeneration
											arg.GenerationText.Visible = visible8
											arg.GenerationShadow.Visible = visible8

											if visible4 then
												local n81 = n77 / v68
												arg.BrainrotText.Position = UDim2.fromScale(n81, visible16)
												arg.BrainrotText.Size = UDim2.fromScale(visible7 / v68, n62 / n75)
												arg.BrainrotShadow.Position = UDim2.fromScale(n81 + n79, visible16 + n80)
												arg.BrainrotShadow.Size = arg.BrainrotText.Size

												if visible8 then
													local n82 = (n77 + visible7 + n64) / v68
													arg.GenerationText.Position = UDim2.fromScale(n82, visible16)
													arg.GenerationText.Size = UDim2.fromScale(visible9 / v68, n62 / n75)
													arg.GenerationShadow.Position = UDim2.fromScale(n82 + n79, visible16 + n80)
													arg.GenerationShadow.Size = arg.GenerationText.Size
												end
											end
										end

										fn65 = function(arg, arg2, arg3)
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
											fn73(uiStroke, Color3.fromRGB(255, 255, 255), 0.044, 1.4)
											uiStroke.Parent = textLabel2
											local uiGradient = Instance.new("UIGradient")
											uiGradient.Color = colorSequence
											uiGradient.Rotation = 90
											uiGradient.Parent = uiStroke
											local uiGradient2 = Instance.new("UIGradient")
											uiGradient2.Color = v59
											uiGradient2.Rotation = 90
											uiGradient2.Parent = textLabel2
											local textLabel3 = createTextLabel("BrainrotShadow", content, 3)
											textLabel3.TextColor3 = Color3.fromRGB(25, 0, 4)
											local textLabel4 = createTextLabel("BrainrotText", content, 4)
											textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
											local uiStroke2 = Instance.new("UIStroke")
											fn73(uiStroke2, Color3.fromRGB(124, 0, 15), 0.052, 1.7)
											uiStroke2.Parent = textLabel4
											local uiGradient3 = Instance.new("UIGradient")
											uiGradient3.Color = v61
											uiGradient3.Rotation = 90
											uiGradient3.Parent = uiStroke2
											local uiGradient4 = Instance.new("UIGradient")
											uiGradient4.Color = v60
											uiGradient4.Rotation = 90
											uiGradient4.Parent = textLabel4
											local textLabel5 = createTextLabel("MutationShadow", content, 3)
											textLabel5.TextColor3 = Color3.fromRGB(0, 0, 0)
											textLabel5.TextTransparency = 0.15
											local textLabel6 = createTextLabel("MutationText", content, 4)
											textLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
											textLabel6.RichText = true
											local uiStroke3 = Instance.new("UIStroke")
											fn73(uiStroke3, Color3.fromRGB(0, 0, 0), 0.05, 1.5)
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
											fn73(uiStroke4, Color3.fromRGB(0, 0, 0), 0.05, 1.5)
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
											fn73(uiStroke5, Color3.fromRGB(10, 24, 45), 0.02, 1.45)
											uiStroke5.Transparency = 0.02
											uiStroke5.Parent = textLabel10
											local uiGradient6 = Instance.new("UIGradient")
											local colorSequenceNew = ColorSequence.new
											local tbl14 = {}
											local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
											local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(235, 242, 255))
											tbl14[1] = v68
											tbl14[2] = v69

											do
												local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)))
												table.move(values, 1, values.n, 3, tbl14)
											end

											uiGradient6.Color = colorSequenceNew(tbl14)
											uiGradient6.Rotation = 90
											uiGradient6.Parent = textLabel10

											local tbl15 = {
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

											fn64(tbl15, false)
											return tbl15
										end
									end
								end

								fn66 = function(arg)
									local tag = arg.Tag
									local character_ = arg.Character

									if not (not tag or not character_) then
										local visualHead = tag.VisualHead
										local networkAnchor = tag.NetworkAnchor

										if not (not visualHead or not visualHead:IsDescendantOf(character_) or not networkAnchor or not networkAnchor:IsDescendantOf(character_)) then
											tag.Billboard.Adornee = networkAnchor
											local visible2 = networkAnchor ~= visualHead and (networkAnchor.Position - visualHead.Position).Magnitude >= n50
											tag.PlayerHighlight.Enabled = not visible2
											tag.NetworkTracker.Adornee = networkAnchor
											tag.NetworkTracker.Visible = visible2
											return true
										end
									end

									return false
								end

								do
									local function fn72(arg)
										if arg:GetAttribute("AdminCommands") == true then
											return true
										end
										local attribute = arg:GetAttribute("Role")
										return type(attribute) == "string" and string.find(string.lower(attribute), "admin", 1, true) ~= nil
									end

									fn67 = function(arg, arg2)
										if not arg.Tag then
											return
										end
										arg.Tag.IsAdmin = fn72(arg2)
										fn64(arg.Tag, arg.Tag.HasTool == true)
									end
								end

								fn68 = function(arg)
									if not arg.Tag or not arg.Character then
										return
									end
									local v68 = fn70(getTool(arg.Character))
									local visible2 = v68 ~= ""
									arg.Tag.ToolIcon.Image = v68
									arg.Tag.ToolIcon.Visible = visible2
									arg.Tag.ToolShadow.Image = v68
									arg.Tag.ToolShadow.Visible = visible2
									fn64(arg.Tag, visible2)
								end

								fn69 = function(arg)
									if arg.Tag then
										arg.Tag.BrainrotName = arg.BrainrotName
										arg.Tag.BrainrotGeneration = arg.BrainrotGeneration
										arg.Tag.BrainrotMutation = fn71(arg.BrainrotMutationLabel)
										fn64(arg.Tag, arg.Tag.HasTool == true)
										local v68 = fn59(arg.BrainrotGeneration)

										if arg.Tag.BrainrotGradient then
											arg.Tag.BrainrotGradient.Color = v68.Text
										end

										if arg.Tag.BrainrotStrokeGradient then
											arg.Tag.BrainrotStrokeGradient.Color = v68.Stroke
										end

										if arg.BrainrotHighlight and (enabledFlags3.Brainrot ~= true or arg.BrainrotHighlight.Adornee ~= arg.BrainrotModel) then
											arg.BrainrotHighlight:Destroy()
											arg.BrainrotHighlight = nil
										end

										if enabledFlags3.Brainrot == true and arg.BrainrotModel and arg.BrainrotModel.Parent and not arg.BrainrotHighlight then
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
											arg.BrainrotHighlight.FillColor = v68.Fill
											arg.BrainrotHighlight.OutlineColor = v68.Outline
										end
									end
								end
							end

							local fn70, fn71, fn72

							do
								local fn73, fn74, flag41, fn75, fn76

								do
									do
										fn73 = function(arg)
											if arg.BrainrotGenerationConnection then
												arg.BrainrotGenerationConnection:Disconnect()
												arg.BrainrotGenerationConnection = nil
											end

											local v68 = ipairs
											local brainrotMutationConnections = arg.BrainrotMutationConnections or {}

											for _, brainrotMutationConnection in v68(brainrotMutationConnections) do
												brainrotMutationConnection:Disconnect()
											end

											arg.BrainrotMutationConnections = nil
											arg.BrainrotMutationLabel = nil
										end

										do
											local function fn77(arg, brainrotMutationLabel, arg2)
												if not brainrotMutationLabel then
													return
												end
												arg.BrainrotMutationLabel = brainrotMutationLabel
												local connections4 = {}

												local function fn78()
													if arg.BrainrotModel == arg2 then
														fn69(arg)
													end
												end

												connections4[#connections4 + 1] = brainrotMutationLabel:GetPropertyChangedSignal("Text"):Connect(fn78)
												connections4[#connections4 + 1] = brainrotMutationLabel:GetPropertyChangedSignal("Visible"):Connect(fn78)
												connections4[#connections4 + 1] = brainrotMutationLabel:GetPropertyChangedSignal("TextColor3"):Connect(fn78)
												arg.BrainrotMutationConnections = connections4
											end

											fn70 = function(arg, arg2)
												arg.StealingVersion = arg.StealingVersion + 1
												local stealingVersion = arg.StealingVersion

												if arg2:GetAttribute("Stealing") ~= true then
													fn73(arg)
													arg.BrainrotName = nil
													arg.BrainrotGeneration = nil
													arg.BrainrotModel = nil
													fn69(arg)
													return
												end

												task.spawn(function()
													for i_ = 1, 7 do
														if not flag40 or arg.StealingVersion ~= stealingVersion or playerMap[arg2] ~= arg then
															return
														end
														local v68, v69, v70, v71, v72 = fn63(arg2)

														if v68 then
															fn73(arg)
															arg.BrainrotName = v68
															arg.BrainrotModel = v69
															arg.BrainrotGeneration = v70
															fn77(arg, v72, v69)

															if v71 then
																arg.BrainrotGenerationConnection = v71:GetPropertyChangedSignal("Text"):Connect(function()
																	if arg.BrainrotModel == v69 then
																		arg.BrainrotGeneration = v71.Text
																		fn69(arg)
																	end
																end)
															end

															fn69(arg)
															return
														end

														if i_ < 7 then
															task.wait(0.12)
														end
													end

													if arg.StealingVersion == stealingVersion then
														fn73(arg)
														arg.BrainrotName = nil
														arg.BrainrotGeneration = nil
														arg.BrainrotModel = nil
														fn69(arg)
													end
												end)
											end
										end
									end

									fn74 = function(arg, arg2, arg3)
										local userIdEntry = userIdMap[arg2.UserId]

										if userIdEntry == nil then
											local ok13

											ok13, userIdEntry = pcall(function()
												return Players:GetUserThumbnailAsync(arg2.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
											end)

											userIdEntry = ok13 and userIdEntry or ""
											userIdMap[arg2.UserId] = userIdEntry
										end

										if flag40 and arg.Version == arg3 and arg.Tag and arg.Tag.Avatar.Parent then
											arg.Tag.Avatar.Image = userIdEntry
										end
									end

									flag41 = false

									fn75 = function(arg)
										if arg:IsA("BasePart") then
											return arg.Name ~= "HumanoidRootPart"
										end
										return arg:IsA("Decal") or arg:IsA("Texture")
									end

									do
										local function fn77(arg, arg2)
											if not (flag41 or not arg2.Parent) then
												local transparency2 = arg2.Transparency

												if transparency2 <= n51 then
													arg.RevealOriginals[arg2] = transparency2
													arg.RevealHidden[arg2] = nil
													return
												end

												if arg.RevealOriginals[arg2] ~= nil then
													arg.RevealHidden[arg2] = transparency2
													flag41 = true

													pcall(function()
														arg2.Transparency = transparency

														if arg2:IsA("BasePart") then
															arg2.LocalTransparencyModifier = 0
														end
													end)

													flag41 = false
													return
												end
											end
										end

										fn76 = function(arg, arg2)
											if arg.RevealBound[arg2] then
												return
											end
											arg.RevealBound[arg2] = true
											local transparency2 = arg2.Transparency

											if transparency2 <= n51 then
												arg.RevealOriginals[arg2] = transparency2
											elseif arg2:IsA("BasePart") and enabledFlags[arg2.Name] then
												arg.RevealOriginals[arg2] = 0
											elseif arg2:IsA("Decal") and string.lower(arg2.Name) == "face" then
												arg.RevealOriginals[arg2] = 0
												local n54 = #arg.RevealConnections + 1

												arg.RevealConnections[n54] = arg2:GetPropertyChangedSignal("Transparency"):Connect(function()
													if flag40 then
														fn77(arg, arg2)
													end
												end)

												fn77(arg, arg2)
												return
											end

											arg.RevealConnections[#arg.RevealConnections + 1] = arg2:GetPropertyChangedSignal("Transparency"):Connect(function()
												if flag40 then
													fn77(arg, arg2)
												end
											end)

											fn77(arg, arg2)
										end
									end
								end

								do
									local function fn77(arg, arg2)
										for _, descendant in ipairs(arg2:GetDescendants()) do
											if fn75(descendant) then
												fn76(arg, descendant)
											end
										end

										arg.RevealConnections[#arg.RevealConnections + 1] = arg2.DescendantAdded:Connect(function(descendant)
											if flag40 and fn75(descendant) then
												fn76(arg, descendant)
											end
										end)
									end

									local function fn78(arg)
										disconnectAll3(arg.RevealConnections)
										flag41 = true

										for k, v68 in pairs(arg.RevealHidden) do
											if k.Parent then
												pcall(function()
													k.Transparency = v68
												end)
											end
										end

										flag41 = false
										table.clear(arg.RevealHidden)
										table.clear(arg.RevealOriginals)
										table.clear(arg.RevealBound)
									end

									fn71 = function(arg)
										disconnectAll3(arg.CharacterConnections)
										fn60(arg)
										fn78(arg)
										fn73(arg)

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

									fn72 = nil

									fn72 = function(arg, arg2, character_)
										fn71(arg)
										arg.Version = arg.Version + 1
										local version = arg.Version
										if not flag40 or not character_ then
											return
										end
										arg.Character = character_
										arg.BindingCharacter = character_
										fn61(arg, character_)
										fn77(arg, character_)

										local function fn79()
											task.defer(function()
												if flag40 and arg.Version == version then
													fn68(arg)
												end
											end)
										end

										arg.CharacterConnections[#arg.CharacterConnections + 1] = character_.ChildAdded:Connect(function(child)
											if child:IsA("Tool") then
												fn79()
											elseif child:IsA("Humanoid") then
												fn61(arg, character_)
											end
										end)

										arg.CharacterConnections[#arg.CharacterConnections + 1] = character_.ChildRemoved:Connect(function(child)
											if child:IsA("Tool") then
												fn79()
											end
										end)

										arg.CharacterConnections[#arg.CharacterConnections + 1] = character_.AncestryChanged:Connect(function()
											if not (not flag40 or arg.Version ~= version or character_ ~= arg2.Character) then
												if not character_:IsDescendantOf(Workspace) then
													arg.Version = arg.Version + 1
													fn71(arg)
													return
												end

												if not arg.Tag then
													task.defer(function()
														if flag40 and arg.Version == version then
															fn72(arg, arg2, character_)
														end
													end)
												end
											end
										end)

										task.spawn(function()
											local head = character_:FindFirstChild("Head") or character_:WaitForChild("Head", 5)

											if not flag40 or arg.Version ~= version or character_ ~= arg2.Character or not character_:IsDescendantOf(Workspace) or not head or not head:IsDescendantOf(character_) then
												if arg.Version == version then
													arg.BindingCharacter = nil
												end

												return
											end

											local v68 = fn62(character_, head)
											arg.Tag = fn65(arg2, head, v68)
											fn66(arg)
											arg.BindingCharacter = nil

											arg.CharacterConnections[#arg.CharacterConnections + 1] = head.AncestryChanged:Connect(function()
												if not (not flag40 or arg.Version ~= version or head:IsDescendantOf(character_)) then
													arg.Version = arg.Version + 1
													fn71(arg)
													local character_2 = arg2.Character

													if character_2 and character_2:IsDescendantOf(Workspace) then
														task.defer(function()
															if flag40 and playerMap[arg2] == arg then
																fn72(arg, arg2, character_2)
															end
														end)
													end
												end
											end)

											fn67(arg, arg2)
											fn68(arg)
											fn70(arg, arg2)
											fn74(arg, arg2, version)
										end)
									end
								end
							end

							do
								local function fn73(player)
									local playerEntry = playerMap[player]
									if not playerEntry then
										return
									end
									playerEntry.Version = playerEntry.Version + 1
									playerEntry.StealingVersion = playerEntry.StealingVersion + 1
									fn71(playerEntry)
									disconnectAll3(playerEntry.PlayerConnections)
									playerMap[player] = nil
								end

								local function fn74(player)
									if player == localPlayer or playerMap[player] then
										return
									end

									local tbl14 = {
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

									playerMap[player] = tbl14

									for _, v68 in ipairs({ "AdminCommands", "Role" }) do
										tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player:GetAttributeChangedSignal(v68):Connect(function()
											if flag40 and playerMap[player] == tbl14 then
												fn67(tbl14, player)
											end
										end)
									end

									tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player.CharacterAdded:Connect(function(character_)
										fn72(tbl14, player, character_)
									end)

									tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player.CharacterRemoving:Connect(function(character_)
										if tbl14.Character == character_ then
											tbl14.Version = tbl14.Version + 1
											fn71(tbl14)
										end
									end)

									tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player:GetPropertyChangedSignal("Character"):Connect(function()
										task.defer(function()
											if not (not flag40 or playerMap[player] ~= tbl14) then
												local character_ = player.Character

												if character_ ~= tbl14.Character then
													fn72(tbl14, player, character_)
												elseif tbl14.Tag then
													local adornee = tbl14.Tag.Billboard.Adornee

													if not adornee or not adornee:IsDescendantOf(Workspace) then
														fn72(tbl14, player, character_)
													end
												end
											end
										end)
									end)

									tbl14.PlayerConnections[#tbl14.PlayerConnections + 1] = player:GetAttributeChangedSignal("Stealing"):Connect(function()
										fn70(tbl14, player)
									end)

									fn72(tbl14, player, player.Character)
								end

								local function fn75()
									for k, v68 in pairs(playerMap) do
										local character_ = k.Character

										if character_ and character_:IsDescendantOf(Workspace) then
											local tag = v68.Tag
											local billboard = tag and tag.Billboard
											tag = tag and tag.PlayerHighlight
											local adornee = billboard and billboard.Adornee
											local parent2 = billboard and billboard.Parent and adornee and adornee:IsDescendantOf(character_) and tag and tag.Parent and fn66(v68)

											if (v68.Character ~= character_ or not parent2) and v68.BindingCharacter ~= character_ then
												fn72(v68, k, character_)
											end
										elseif v68.Character then
											v68.Version = v68.Version + 1
											fn71(v68)
										end
									end
								end

								local function fn76()
									flag40 = false
									n53 += 1
									disconnectAll3(connections3)
									local ks = {}

									for k in pairs(playerMap) do
										ks[#ks + 1] = k
									end

									for _, v68 in ipairs(ks) do
										fn73(v68)
									end
								end

								local function fn77()
									for _, v68 in pairs(playerMap) do
										if v68.Tag and v68.Tag.Billboard.Parent then
											fn64(v68.Tag, v68.Tag.HasTool == true)
										end
									end
								end

								local function fn78()
									for _, v68 in pairs(playerMap) do
										if v68.Tag and v68.Tag.Billboard.Parent then
											fn68(v68)
											fn69(v68)
										end
									end
								end

								local function fn79()
									fn76()
									flag40 = true
									local n532 = n53
									connections3[#connections3 + 1] = Players.PlayerAdded:Connect(fn74)
									connections3[#connections3 + 1] = Players.PlayerRemoving:Connect(fn73)
									local currentCamera2 = Workspace.CurrentCamera

									if currentCamera2 then
										connections3[#connections3 + 1] = currentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(fn77)
									end

									for _, player in ipairs(Players:GetPlayers()) do
										fn74(player)
									end

									task.spawn(function()
										while flag40 and n53 == n532 do
											task.wait(0.2)

											if flag40 and n53 == n532 then
												fn75()
											end
										end
									end)
								end

								cleanup20.Event:Connect(fn76)
								chilliPlayerESPRuntime2.Destroying:Connect(fn76)

								playerEspSection:CreateToggle({
									Name = "Player ESP",
									Default = true,
									Callback = function(arg)
										if arg then
											fn79()
										else
											fn76()
										end
									end,
								})

								playerEspSection:CreateMultiDropdown({
									Name = "Show Information",
									Note = "Choose what Player ESP shows. Username replaces the display name.",
									Options = {
										"Name",
										"Username",
										"Avatar",
										"Tool",
										"Brainrot",
										"Admin Panel",
									},
									Default = { "Name", "Tool", "Brainrot", "Admin Panel" },
									Callback = function(arg)
										local enabledFlags4 = {
											Name = false,
											Username = false,
											Avatar = false,
											Tool = false,
											Brainrot = false,
											["Admin Panel"] = false,
										}

										if type(arg) == "table" then
											for k, v68 in pairs(arg) do
												if type(v68) == "string" and enabledFlags4[v68] ~= nil then
													enabledFlags4[v68] = true
												elseif type(k) == "string" and v68 == true and enabledFlags4[k] ~= nil then
													enabledFlags4[k] = true
												end
											end
										end

										enabledFlags3 = enabledFlags4
										fn78()
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
										n52 = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)
										fn77()
									end,
								})
							end
						end

						do
							local chilliBaseLockTimerRuntime, v68, flag40, n52, v69, folder, childMap, connections3, fn60, fn61
							local fn62

							do
								local color3, color4, v70

								do
									chilliBaseLockTimerRuntime, v68 = fn51("__ChilliBaseLockTimerRuntime")
									flag40 = false
									n52 = 1
									v69 = nil
									folder = nil
									childMap = {}
									connections3 = {}
									color3 = Color3.fromRGB(255, 58, 74)
									color4 = Color3.fromRGB(154, 255, 62)

									do
										local colorSequenceNew = ColorSequence.new
										local tbl14 = {}
										local v71 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
										local v72 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(222, 222, 222))
										tbl14[1] = v71
										tbl14[2] = v72

										do
											local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)))
											table.move(values, 1, values.n, 3, tbl14)
										end

										v70 = colorSequenceNew(tbl14)
									end
								end

								do
									do
										do
											local function clampValue2()
												local currentCamera2 = Workspace.CurrentCamera
												local n53 = math.floor(math.clamp((currentCamera2 and currentCamera2.ViewportSize.Y or 1080) * 0.064, 52, 76))
												return math.floor(n53 * 2.8), n53
											end

											fn60 = function(arg)
												if not arg.Tag or not arg.Tag.Gui or not arg.Tag.Gui.Parent then
													return
												end
												local numVal, v71 = clampValue2()
												arg.Tag.Gui.Size = UDim2.fromOffset(math.floor(numVal * n52 + 0.5), math.floor(v71 * n52 + 0.5))
											end
										end
									end

									do
										local function createPart(arg)
											local v71 = fn55(arg)
											if not v71 then
												return nil
											end
											local part2 = Instance.new("Part")
											part2.Name = fn20()
											part2.Size = Vector3.one
											part2.Transparency = 1
											part2.Anchored = true
											part2.CanCollide = false
											part2.CanTouch = false
											part2.CanQuery = false
											part2.Massless = true
											part2.CastShadow = false
											part2.Position = v71
											part2.Parent = folder
											return part2
										end

										fn61 = function(arg)
											local part2 = createPart(arg)
											if not part2 then
												return nil
											end
											local baseLockTimer = Instance.new("BillboardGui")
											baseLockTimer.Name = "BaseLockTimer"
											baseLockTimer.Adornee = part2
											baseLockTimer.AlwaysOnTop = true
											baseLockTimer.LightInfluence = 0
											baseLockTimer.MaxDistance = 2500
											baseLockTimer.Parent = chilliBaseLockTimerRuntime
											local frame3 = Instance.new("Frame")
											frame3.Name = "Frame"
											frame3.BackgroundTransparency = 1
											frame3.BorderSizePixel = 0
											frame3.Size = UDim2.fromScale(1, 1)
											frame3.Parent = baseLockTimer
											local status = Instance.new("TextLabel")
											status.Name = "Status"
											status.BackgroundTransparency = 1
											status.FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
											status.Position = UDim2.fromScale(0.02, 0)
											status.Size = UDim2.fromScale(0.96, 0.53)
											status.Text = "Open"
											status.TextColor3 = color4
											status.TextScaled = true
											status.TextStrokeColor3 = Color3.fromRGB(8, 8, 8)
											status.TextStrokeTransparency = 0
											status.Parent = frame3
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
											sheen.Color = v70
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
											timer.Parent = frame3
											local sheen2 = Instance.new("UIGradient")
											sheen2.Name = "Sheen"
											sheen2.Color = v70
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
												Anchor = part2,
												Status = status,
												StatusStroke = textOutline,
												Timer = timer,
												TimerStroke = textOutline2,
												StatusStyleSource = nil,
												TimerStyleSource = nil,
												StatusMode = nil,
											}
										end
									end
								end

								do
									local function fn63(arg, arg2, arg3, textColor3)
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

									local function fn64(arg)
										local str5 = tostring(arg or "")
										local n53 = tonumber(str5:match("(%d+)%s*[mM]")) or 0
										local num3 = tonumber(str5:match("(%d+)%s*[sS]"))

										if num3 == nil and n53 == 0 then
											num3 = tonumber(str5:match("%d+")) or 0
										end

										return n53 * 60 + (num3 or 0)
									end

									fn62 = function(arg)
										if arg.Tag then
											local anchor = arg.Tag.Anchor
											if not anchor or not anchor.Parent then
												arg.Tag.Gui.Enabled = false
												return
											end
											local v71 = fn55(arg.Base)

											if v71 and anchor.Position ~= v71 then
												anchor.Position = v71
											end

											local locked = nil
											local open = nil
											local flag41 = false
											local n53 = -1
											local v72 = nil
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
														local str5 = tostring(timerLabel2.Text or "")
														local v73 = fn64(str5)
														flag41 = true
														local flag42 = true

														if not (n53 < v73) then
															flag41 = flag42
														else
															n53 = v73
															v72 = str5
															timerLabel = timerLabel2
														end
													end
												end
											end

											arg.Tag.Gui.Enabled = not string.find(string.lower(fn54(arg.Base)), "empty base", 1, true)

											if arg.Tag.Gui.Enabled then
												if flag41 then
													arg.Tag.Status.Position = UDim2.fromScale(0.02, 0)
													arg.Tag.Status.Size = UDim2.fromScale(0.96, 0.53)
													arg.Tag.Status.Text = "Locked:"
													arg.Tag.Timer.Text = v72 or ""
													arg.Tag.Timer.Visible = v72 ~= nil and v72 ~= ""

													if arg.Tag.StatusMode ~= "Locked" or arg.Tag.StatusStyleSource ~= locked then
														arg.Tag.StatusMode = "Locked"
														arg.Tag.StatusStyleSource = locked
														fn63(arg.Tag.Status, arg.Tag.StatusStroke, locked, color3)
													end

													if arg.Tag.TimerStyleSource ~= timerLabel then
														arg.Tag.TimerStyleSource = timerLabel
														fn63(arg.Tag.Timer, arg.Tag.TimerStroke, timerLabel, Color3.fromRGB(255, 255, 255))
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
														fn63(arg.Tag.Status, arg.Tag.StatusStroke, open, color4)
														arg.Tag.Status.TextColor3 = color4
													end
												end
											end
										end
									end
								end
							end

							local fn63, destroyAll2, fn64

							do
								do
									local function fn65(arg)
										disconnectAll2(arg.TimerConnections)
										table.clear(arg.TimerLabels)
										if not arg.Base.Parent then
											return
										end

										for _, descendant in ipairs(arg.Base:GetDescendants()) do
											if descendant:IsA("TextLabel") and descendant.Name == "RemainingTime" then
												arg.TimerLabels[#arg.TimerLabels + 1] = descendant

												arg.TimerConnections[#arg.TimerConnections + 1] = descendant:GetPropertyChangedSignal("Text"):Connect(function()
													fn62(arg)
												end)

												arg.TimerConnections[#arg.TimerConnections + 1] = descendant:GetPropertyChangedSignal("Visible"):Connect(function()
													fn62(arg)
												end)

												local locked = descendant.Parent and descendant.Parent:FindFirstChild("Locked")

												if locked and locked:IsA("GuiObject") then
													arg.TimerConnections[#arg.TimerConnections + 1] = locked:GetPropertyChangedSignal("Visible"):Connect(function()
														fn62(arg)
													end)
												end
											end
										end

										fn62(arg)
									end

									local function destroyAll3(child)
										local childEntry = childMap[child]
										if not childEntry then
											return
										end
										disconnectAll2(childEntry.Connections)
										disconnectAll2(childEntry.TimerConnections)
										local tag = childEntry.Tag

										if tag and childEntry.Tag.Gui then
											childEntry.Tag.Gui:Destroy()
										end

										if childEntry.Tag and childEntry.Tag.Anchor then
											childEntry.Tag.Anchor:Destroy()
										end

										childMap[child] = nil
									end

									local function fn66(child)
										if not (not child:IsA("Model") or childMap[child]) then
											local v70 = fn61(child)

											if v70 then
												local tbl14 = {
													Base = child,
													Tag = v70,
													TimerLabels = {},
													Connections = {},
													TimerConnections = {},
													RefreshPending = false,
												}

												childMap[child] = tbl14
												fn60(tbl14)

												local function fn67(descendant)
													if not (descendant and descendant.Name ~= "RemainingTime" and descendant.Name ~= "Locked" and not isBasePart(descendant)) and not tbl14.RefreshPending then
														tbl14.RefreshPending = true

														task.defer(function()
															tbl14.RefreshPending = false

															if childMap[child] == tbl14 then
																fn65(tbl14)
															end
														end)

														return
													end
												end

												tbl14.Connections[#tbl14.Connections + 1] = child.DescendantAdded:Connect(fn67)
												tbl14.Connections[#tbl14.Connections + 1] = child.DescendantRemoving:Connect(fn67)

												tbl14.Connections[#tbl14.Connections + 1] = child.Destroying:Connect(function()
													destroyAll3(child)
												end)

												local v71 = fn53(child)

												if v71 then
													tbl14.Connections[#tbl14.Connections + 1] = v71:GetPropertyChangedSignal("Text"):Connect(function()
														fn62(tbl14)
													end)
												end

												fn65(tbl14)
												return
											end
										end
									end

									fn63 = function()
										for _, v70 in pairs(childMap) do
											fn60(v70)
										end
									end

									destroyAll2 = function()
										flag40 = false
										disconnectAll2(connections3)
										local ks = {}

										for k in pairs(childMap) do
											ks[#ks + 1] = k
										end

										for _, v70 in ipairs(ks) do
											destroyAll3(v70)
										end

										folder:Destroy()
										folder = nil
										v69 = nil
									end

									fn64 = function(arg)
										v69 = arg
										connections3[#connections3 + 1] = arg.ChildAdded:Connect(fn66)
										connections3[#connections3 + 1] = arg.ChildRemoved:Connect(destroyAll3)

										connections3[#connections3 + 1] = arg.DescendantAdded:Connect(function(descendant)
											if isBasePart(descendant) then
												local parent2 = descendant.Parent

												if parent2 and parent2.Parent == arg then
													fn66(parent2)
												end
											end
										end)

										for _, child in ipairs(arg:GetChildren()) do
											fn66(child)
										end
									end
								end
							end

							do
								local function fn65()
									destroyAll2()
									flag40 = true
									folder = Instance.new("Folder")
									folder.Name = fn20()
									folder.Archivable = false
									folder.Parent = Workspace
									local currentCamera2 = Workspace.CurrentCamera

									if currentCamera2 then
										connections3[#connections3 + 1] = currentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(fn63)
									end

									connections3[#connections3 + 1] = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(fn63)
									local plots2 = Workspace:FindFirstChild("Plots")

									if plots2 then
										fn64(plots2)
									else
										connections3[#connections3 + 1] = Workspace.ChildAdded:Connect(function(child)
											if flag40 and child.Name == "Plots" then
												fn64(child)
											end
										end)
									end
								end

								v68.Event:Connect(destroyAll2)
								chilliBaseLockTimerRuntime.Destroying:Connect(destroyAll2)

								local timerEspToggle = baseEspSection:CreateToggle({
									Name = "Timer ESP",
									Default = true,
									Callback = function(arg)
										if arg then
											fn65()
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
										n52 = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)
										fn63()
									end,
								})
							end
						end

						local chilliYourBaseESPRuntime, v68, flag40, flag41, flag42, v69, v70, v71, v72, v73
						local v74, v75, v76, v77, flag43, flag44, tbl14, tbl15, tbl16, v78
						local fn60, fn61

						do
							local n52, tbl17, obj4, fn62

							do
								chilliYourBaseESPRuntime, v68 = fn51("__ChilliYourBaseESPRuntime")
								Color3.fromRGB(255, 255, 255)

								do
									local enabledFlags3 = {
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

									flag40 = false
									flag41 = false
									flag42 = false
									v69 = nil
									v70 = nil
									v71 = nil
									v72 = nil
									v73 = nil
									v74 = nil
									v75 = nil
									v76 = nil
									v77 = nil
									flag43 = false
									flag44 = false
									tbl14 = {}
									n52 = 0
									tbl17 = {}
									obj4 = setmetatable({}, { __mode = "k" })
									tbl15 = {}
									tbl16 = {}
									v78 = nil

									fn62 = function(arg, arg2)
										local v79 = obj4[arg]
										if v79 ~= nil then
											return v79
										end
										local flag45 = false

										if not enabledFlags3[arg.Name] then
											if arg.Parent == arg2 then
												flag45 = true
											elseif arg:FindFirstChildOfClass("Humanoid") or arg:FindFirstChildOfClass("AnimationController") or arg:GetAttribute("Mutation") ~= nil then
												flag45 = true
											end
										end

										if flag45 or #arg:GetChildren() > 0 then
											obj4[arg] = flag45
										end

										return flag45
									end
								end
							end

							do
								local function fn63(arg, arg2)
									if not (not arg:IsA("BasePart") or arg.Transparency >= 1) and arg.Name ~= "PlotSign" then
										for _, child in ipairs(arg:GetChildren()) do
											if child:IsA("SurfaceGui") or child:IsA("BillboardGui") or child:IsA("Decal") or child:IsA("Texture") then
												return false
											end
										end

										while arg and arg ~= arg2 do
											if arg:IsA("Model") and fn62(arg, arg2) then
												return false
											end
											arg = arg.Parent
										end

										return arg == arg2
									end

									return false
								end

								fn60 = function(arg, arg2)
									if tbl17[arg] ~= nil or not fn63(arg, arg2) or #tbl14 == 0 then
										return
									end
									n52 += 1
									local v79 = tbl14[(n52 - 1) % #tbl14 + 1]
									local color3 = arg.Color
									tbl17[arg] = color3
									arg.Color = color3:Lerp(v79, 0.78)
								end
							end

							fn61 = function()
								for k, v79 in pairs(tbl17) do
									if k.Parent then
										pcall(function()
											k.Color = v79
										end)
									end
								end

								table.clear(tbl17)
								table.clear(obj4)
								table.clear(tbl14)
								n52 = 0
								flag44 = false
							end
						end

						local fn62, destroyAll2

						do
							do
								local function fn63(arg)
									fn61()
									if not arg or not arg.Parent then
										return
									end
									tbl14 = fn58("Phantom")

									for _, descendant in ipairs(arg:GetDescendants()) do
										fn60(descendant, arg)
									end

									flag44 = true
								end

								local function destroyAll3()
									if v72 then
										v72:Destroy()
									end

									if v73 then
										v73:Destroy()
									end

									v72 = nil
									v73 = nil
									v74 = nil
									v75 = nil
									v76 = nil
									v77 = nil
								end

								fn62 = function()
									local flag45 = v70 ~= nil and localPlayer:GetAttribute("Stealing") == true
									local flag412 = flag45 and flag41
									flag45 = flag45 and flag42

									if flag412 and not flag44 then
										fn63(v70)
									elseif not flag412 and flag44 then
										fn61()
									end

									if v71 and v71.Parent then
										v71.Enabled = flag412
									end

									fn57("UnfadedPlot", (flag412 or flag45) and v70 or nil)
								end

								destroyAll2 = function()
									if v78 then
										v78:Disconnect()
										v78 = nil
									end

									destroyAll3()
									fn61()

									if v71 then
										v71:Destroy()
										v71 = nil
									end

									v70 = nil
									fn62()
								end
							end
						end

						do
							local function fn63()
								flag40 = false
								flag43 = false
								disconnectAll2(tbl15)
								disconnectAll2(tbl16)
								destroyAll2()
								v69 = nil
							end

							local function fn64()
								fn62()
							end

							v68.Event:Connect(fn63)
							chilliYourBaseESPRuntime.Destroying:Connect(fn63)

							baseEspSection:CreateToggle({
								Name = "Your Base ESP (While Stealing)",
								Default = false,
								Callback = function(arg)
									flag41 = arg == true
									fn64()
								end,
							})

							baseEspSection:CreateToggle({
								Name = "Beam to Your Base (While Stealing)",
								Default = true,
								Callback = function(arg)
									flag42 = arg == true
									fn64()
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
									fn57("YourBaseClear", arg == true)
								end,
							}),
							Note = "Adjusts base visibility: 0% keeps the original look and 100% makes it invisible.",
							Callback = function(arg)
								fn57("ClearBaseTransparency", math.clamp(tonumber(arg) or 80, 0, 100) / 100)
							end,
						})

						clamp = math.clamp
						num = tonumber(tbl5.ClearBaseTransparency)

						if num then
							state = 116
						else
							state = 115
						end
					elseif state == 115 then
						num = 0.8
						state = 116
					elseif state == 116 then
						n5 = clamp(num, 0, 1)
						n6 = 0.0015

						enabledFlags2 = {
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

						v24 = fn50()
						v35Map = {}
						forIter_2 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v68, v310, v410, v510, v69, v72, v82, v92, v102 in f, s, var do coroutine.yield(true, {k, v68, v310, v410, v510, v69, v72, v82, v92, v102}) end end); co(); return co end)(ipairs({ v24, CoreGui }))
						state = 117
					elseif state == 117 then
						local forOk_2, forVals_2 = forIter_2()

						if forOk_2 then
							do
								local v68
								v68, v35 = forVals_2[1], forVals_2[2]
							end

							state = 189
						else
							state = 118
						end
					elseif state == 118 then
						local tbl14

						do
							do
								local chilliFadePlotsRuntime2, cleanup20, flag40, n52, plots2, connection12, connection13, v68, tbl15, n53
								local flag41, fn60, fn61

								do
									local v69, kMap, fn62

									do
										chilliFadePlotsRuntime2 = Instance.new("Folder")
										chilliFadePlotsRuntime2.Name = "__ChilliFadePlotsRuntime"
										chilliFadePlotsRuntime2.Archivable = false
										chilliFadePlotsRuntime2.Parent = v24
										cleanup20 = Instance.new("BindableEvent")
										cleanup20.Name = "Cleanup"
										cleanup20.Parent = chilliFadePlotsRuntime2
										flag40 = false
										n52 = 0
										plots2 = nil
										connection12 = nil
										connection13 = nil
										v68 = Random.new()
										tbl15 = {}
										n53 = 0
										flag41 = false
										v69 = nil
										kMap = {}

										do
											local obj4 = setmetatable({}, { __mode = "k" })

											fn62 = function(arg)
												while arg do
													local parent2 = arg.Parent
													if parent2 == plots2 then
														return arg
													end

													if not parent2 or parent2 == Workspace then
														break
													end
													arg = parent2
												end

												return nil
											end

											local function fn63(arg, arg2)
												local v70 = obj4[arg]
												if v70 ~= nil then
													return v70
												end
												local flag42 = false

												if not enabledFlags2[arg.Name] then
													if arg.Parent == arg2 then
														flag42 = true
													elseif arg:FindFirstChildOfClass("Humanoid") or arg:FindFirstChildOfClass("AnimationController") then
														flag42 = true
													end
												end

												if flag42 or #arg:GetChildren() > 0 then
													obj4[arg] = flag42
												end

												return flag42
											end

											local function fn64(arg, arg2)
												while arg and arg ~= arg2 do
													if arg:IsA("Model") and fn63(arg, arg2) then
														return true
													end
													arg = arg.Parent
												end

												return false
											end

											fn60 = function(arg)
												if kMap[arg] == nil and arg:IsA("BasePart") and not (arg.Transparency >= 1) then
													local v70 = fn62(arg)

													if not (not v70 or v70 == v69 or fn64(arg, v70)) then
														local localTransparencyModifier = arg.LocalTransparencyModifier

														if math.abs(localTransparencyModifier - n5) <= 0.001 then
															localTransparencyModifier = 0
														end

														kMap[arg] = localTransparencyModifier

														pcall(function()
															arg.LocalTransparencyModifier = math.max(localTransparencyModifier, n5)
														end)

														return
													end
												end
											end

											fn61 = function()
												for k, v70 in pairs(kMap) do
													pcall(function()
														k.LocalTransparencyModifier = v70
													end)
												end

												table.clear(kMap)
												table.clear(obj4)
												table.clear(tbl15)
												n53 = 0
												flag41 = false
											end
										end
									end

									local fn63

									do
										do
											local function fn64(arg)
												for k, v70 in pairs(kMap) do
													if fn62(k) == arg then
														pcall(function()
															k.LocalTransparencyModifier = v70
														end)

														kMap[k] = nil
													end
												end
											end

											local function fn65(arg)
												if not (not arg or not arg.Parent) then
													for _, descendant in ipairs(arg:GetDescendants()) do
														fn60(descendant)
													end
												end
											end

											fn63 = function(arg)
												if v69 ~= arg then
													local v692 = v69
													v69 = arg

													if flag40 then
														if arg then
															fn64(arg)
														end

														if v692 then
															fn65(v692)
														end
													end
												end
											end
										end
									end

									do
										local function clampValue2(arg)
											n5 = math.clamp(tonumber(arg) or 0.8, 0, 1)

											if flag40 then
												for k, v70 in pairs(kMap) do
													if k.Parent then
														pcall(function()
															k.LocalTransparencyModifier = math.max(v70, n5)
														end)
													else
														kMap[k] = nil
													end
												end
											end
										end

										fn56(function(arg, arg2)
											if arg == "UnfadedPlot" then
												local fn632 = fn63
												arg2 = typeof(arg2) == "Instance" and arg2
												fn632(arg2 or nil)
											elseif arg == "ClearBaseTransparency" then
												clampValue2(arg2)
											end
										end)
									end
								end

								do
									local fn62

									do
										do
											local function fn63(arg)
												n53 += 1
												tbl15[n53] = arg
												if flag41 then
													return
												end
												flag41 = true
												local n522 = n52

												task.delay(v68:NextNumber(0.18, 0.42), function()
													flag41 = false

													if not (not flag40 or n522 ~= n52) then
														local tbl152 = tbl15
														local n532 = n53
														tbl15 = {}
														n53 = 0

														for i_ = 1, n532 do
															local v69 = tbl152[i_]

															if v69 and v69.Parent then
																fn60(v69)
															end
														end
													end
												end)
											end

											local function fn64()
												n52 += 1
												local n522 = n52

												task.spawn(function()
													local children = plots2:GetChildren()
													local n54 = 1

													while flag40 and n522 == n52 and n54 <= #children do
														local now3 = os.clock()

														while true do
															local child = children[n54]
															n54 += 1

															if child then
																fn60(child)

																for _, child2 in ipairs(child:GetChildren()) do
																	children[#children + 1] = child2
																end
															end

															if not (n54 > #children or os.clock() - now3 >= n6) then
																continue
															end
															break
														end

														if n54 <= #children then
															RunService.Heartbeat:Wait()
														end
													end
												end)
											end

											fn62 = function()
												connection12:Disconnect()
												connection12 = nil

												connection12 = plots2.DescendantAdded:Connect(function(descendant)
													if flag40 then
														fn63(descendant)
													end
												end)

												fn64()
											end
										end
									end

									do
										local function fn63()
											flag40 = false
											n52 += 1
											connection12:Disconnect()
											connection12 = nil
											connection13:Disconnect()
											connection13 = nil
											fn61()
										end

										local function fn64()
											fn63()
											flag40 = true
											plots2 = Workspace:FindFirstChild("Plots")
											if plots2 then
												fn62()
												return
											end

											connection13 = Workspace.ChildAdded:Connect(function(child)
												if flag40 and child.Name == "Plots" then
													plots2 = child
													connection13:Disconnect()
													connection13 = nil
													fn62()
												end
											end)
										end

										local function fn65()
											local flag42 = tbl5.YourBaseClear == true

											if flag42 and not flag40 then
												fn64()
											elseif not flag42 and flag40 then
												fn63()
											end
										end

										fn56(function(arg)
											if arg == "YourBaseClear" then
												fn65()
											end
										end)

										fn65()
										cleanup20.Event:Connect(fn63)
										chilliFadePlotsRuntime2.Destroying:Connect(fn63)
									end
								end
							end

							chilliBrainrotESPRuntime, v64 = fn51("__ChilliBrainrotESPRuntime")
							font3 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
							tbl7 = {}
							tbl14 = { Limit = 1000000, Outline = Color3.fromRGB(255, 232, 152) }

							do
								local colorSequenceNew = ColorSequence.new
								local tbl15 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 231, 158))
								local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 196, 66))
								tbl15[1] = v68
								tbl15[2] = v69

								do
									local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(214, 142, 12)))
									table.move(values, 1, values.n, 3, tbl15)
								end

								tbl14.Text = colorSequenceNew(tbl15)
							end
						end

						local tbl15

						do
							do
								local colorSequenceNew = ColorSequence.new
								local tbl16 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 76, 0))
								local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(62, 38, 0))
								local new = ColorSequenceKeypoint.new
								local color3FromRGB = Color3.fromRGB
								tbl16[1] = v68
								tbl16[2] = v69

								do
									local values = table.pack(new(1, color3FromRGB(20, 12, 0)))
									table.move(values, 1, values.n, 3, tbl16)
								end

								tbl14.Stroke = colorSequenceNew(tbl16)
							end

							do
								tbl15 = { Limit = 10000000, Outline = Color3.fromRGB(255, 194, 112) }

								do
									local colorSequenceNew = ColorSequence.new
									local tbl16 = {}
									local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 198, 132))
									local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 146, 40))
									tbl16[1] = v68
									tbl16[2] = v69

									do
										local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(206, 92, 0)))
										table.move(values, 1, values.n, 3, tbl16)
									end

									tbl15.Text = colorSequenceNew(tbl16)
								end
							end

							do
								local colorSequenceNew = ColorSequence.new
								local tbl16 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 54, 0))
								local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 27, 0))
								tbl16[1] = v68
								tbl16[2] = v69

								do
									local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 8, 0)))
									table.move(values, 1, values.n, 3, tbl16)
								end

								tbl15.Stroke = colorSequenceNew(tbl16)
							end
						end

						local tbl16

						do
							do
								tbl16 = { Limit = 100000000, Outline = Color3.fromRGB(255, 160, 132) }

								do
									local colorSequenceNew = ColorSequence.new
									local tbl17 = {}
									local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 168, 140))
									local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 82, 38))
									tbl17[1] = v68
									tbl17[2] = v69

									do
										local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(196, 42, 0)))
										table.move(values, 1, values.n, 3, tbl17)
									end

									tbl16.Text = colorSequenceNew(tbl17)
								end
							end

							do
								local colorSequenceNew = ColorSequence.new
								local tbl17 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(112, 26, 0))
								local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(56, 13, 0))
								tbl17[1] = v68
								tbl17[2] = v69

								do
									local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 4, 0)))
									table.move(values, 1, values.n, 3, tbl17)
								end

								tbl16.Stroke = colorSequenceNew(tbl17)
							end
						end

						local tbl17

						do
							tbl17 = { Limit = math.huge, Outline = Color3.fromRGB(255, 128, 138) }

							do
								local colorSequenceNew = ColorSequence.new
								local tbl18 = {}
								local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 105))
								local v69 = ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255, 28, 40))
								tbl18[1] = v68
								tbl18[2] = v69

								do
									local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 0, 18)))
									table.move(values, 1, values.n, 3, tbl18)
								end

								tbl17.Text = colorSequenceNew(tbl18)
							end
						end

						do
							local colorSequenceNew = ColorSequence.new
							local tbl18 = {}
							local v68 = ColorSequenceKeypoint.new(0, Color3.fromRGB(124, 0, 15))
							local v69 = ColorSequenceKeypoint.new(0.55, Color3.fromRGB(61, 0, 9))
							tbl18[1] = v68
							tbl18[2] = v69

							do
								local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 0, 3)))
								table.move(values, 1, values.n, 3, tbl18)
							end

							tbl17.Stroke = colorSequenceNew(tbl18)
						end

						tbl7[1] = tbl14
						tbl7[2] = tbl15
						tbl7[3] = tbl16
						tbl7[4] = tbl17

						ok2, result5 = pcall(function()
							return require(ReplicatedStorage.Datas.Animals)
						end)

						if ok2 then
							state = 119
						else
							state = 120
						end
					elseif state == 119 then
						ok2 = type(result5) == "table"
						state = 120
					end
				elseif state == 120 then
					if ok2 then
						state = 122
					else
						state = 121
					end
				elseif state == 121 then
					result5 = ok2
					state = 122
				elseif state == 122 then
					if result5 then
						state = 124
					else
						state = 123
					end
				elseif state == 123 then
					tbl8 = {}
					state = 125
				elseif state == 124 then
					tbl8 = result5
					state = 125
				elseif state == 125 then
					ok3, result6 = pcall(function()
						return require(ReplicatedStorage.Datas.Rarities)
					end)

					if ok3 then
						state = 126
					else
						state = 127
					end
				elseif state == 126 then
					ok3 = type(result6) == "table"
					state = 127
				elseif state == 127 then
					if ok3 then
						state = 129
					else
						state = 128
					end
				elseif state == 128 then
					result6 = ok3
					state = 129
				elseif state == 129 then
					if result6 then
						state = 131
					else
						state = 130
					end
				elseif state == 130 then
					tbl9 = {}
					state = 132
				elseif state == 131 then
					tbl9 = result6
					state = 132
				elseif state == 132 then
					ok4, result7 = pcall(function()
						return require(ReplicatedStorage.Datas.Mutations)
					end)

					if ok4 then
						state = 133
					else
						state = 134
					end
				end
			elseif state <= 145 then
				if state == 133 then
					ok4 = type(result7) == "table"
					state = 134
				elseif state == 134 then
					if ok4 then
						state = 136
					else
						state = 135
					end
				elseif state == 135 then
					result7 = ok4
					state = 136
				elseif state == 136 then
					if result7 then
						state = 138
					else
						state = 137
					end
				elseif state == 137 then
					tbl10 = {}
					state = 139
				elseif state == 138 then
					tbl10 = result7
					state = 139
				elseif state == 139 then
					ok5, result8 = pcall(function()
						return require(ReplicatedStorage.Packages.Gradients)
					end)

					if ok5 then
						state = 140
					else
						state = 141
					end
				elseif state == 140 then
					ok5 = type(result8) == "table"
					state = 141
				elseif state == 141 then
					if ok5 then
						state = 143
					else
						state = 142
					end
				elseif state == 142 then
					result8 = ok5
					state = 143
				elseif state == 143 then
					if result8 then
						state = 145
					else
						state = 144
					end
				elseif state == 144 then
					ok12 = nil
					state = 146
				elseif state == 145 then
					ok12 = result8
					state = 146
				end
			elseif state == 146 then
				matchMap = {}

				ok6, result9 = pcall(function()
					return require(ReplicatedStorage.Datas.Traits)
				end)

				if ok6 then
					state = 147
				else
					state = 148
				end
			elseif state == 147 then
				ok6 = type(result9) == "table"
				state = 148
			elseif state == 148 then
				if ok6 then
					state = 150
				else
					state = 149
				end
			elseif state == 149 then
				result9 = ok6
				state = 150
			elseif state == 150 then
				if result9 then
					state = 152
				else
					state = 151
				end
			elseif state == 151 then
				tbl11 = {}
				state = 153
			elseif state == 152 then
				tbl11 = result9
				state = 153
			elseif state == 153 then
				forIter_3 = (function(f, s, var) local co = coroutine.wrap(function() coroutine.yield(); for k, v68, v310, v410, v510, v69, v72, v82, v92, v102 in f, s, var do coroutine.yield(true, {k, v68, v310, v410, v510, v69, v72, v82, v92, v102}) end end); co(); return co end)(pairs(tbl11))
				state = 154
			elseif state == 154 then
				local forOk_3, forVals_3 = forIter_3()

				if forOk_3 then
					v25, v26 = forVals_3[1], forVals_3[2]
					state = 185
				else
					state = 155
				end
			elseif state == 155 then
				do
					local n52, enabledFlags3, configMap, flag40, flag41, kMap, n53, fn60, brainrotEspToggle

					do
						local flag42, connections3, getRootPart
						local fn61, fn62, fn63, fn64, fn65, fn66, attachment, parent2, parent3
						local fn67, fn68, destroyAll2

						do
							local fn69, fn70, formatCompact, fn71, fn72, fn73, fn74

							do
								local fn75

								do
									flag42 = false
									connections3 = {}
									kMap = {}
									n53 = 1
									flag41 = false
									flag40 = false
									n52 = 1000000

									enabledFlags3 = {
										Name = true,
										Mutation = true,
										Value = true,
										Trails = true,
										Rarity = false,
									}

									configMap = {
										["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
										["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
										["B/s"] = { Min = 1, Max = 10, Mult = 1e9 },
									}

									fn69 = function(arg)
										for _, v68 in ipairs(tbl7) do
											if arg < v68.Limit then
												return v68
											end
										end

										return tbl7[#tbl7]
									end

									fn70 = function(arg)
										local v68 = tbl8[arg]
										if type(v68) == "table" and v68.Rarity then
											return tostring(v68.Rarity)
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

									fn75 = function(arg, arg2)
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

									fn71 = function(arg)
										if arg.CachedOverhead and arg.CachedOverhead.Parent then
											return arg.CachedOverhead
										end
										local v68 = fn75(arg.Model, arg.Root)
										arg.CachedOverhead = v68
										return v68
									end

									fn72 = function(arg, arg2, arg3)
										local arg32 = arg3 or fn75(arg, arg2)
										arg32 = arg32 and arg32:FindFirstChild("Mutation")
										if not (arg32 and arg32:IsA("TextLabel") and arg32.Visible) then
											return nil
										end
										local str5 = tostring(arg32.Text or "")
										if str5 == "" then
											return nil
										end

										local tbl14 = {
											Text = str5,
											RichText = arg32.RichText == true,
											Color = arg32.TextColor3,
											Font = arg32.FontFace,
											StrokeColor = nil,
											Gradient = nil,
											SourceGrad = arg32:FindFirstChildOfClass("UIGradient"),
										}

										local uiStroke = arg32:FindFirstChildOfClass("UIStroke")

										if uiStroke then
											tbl14.StrokeColor = uiStroke.Color
										end

										if tbl14.SourceGrad then
											tbl14.Gradient = {
												Color = tbl14.SourceGrad.Color,
												Rotation = tbl14.SourceGrad.Rotation,
												Offset = tbl14.SourceGrad.Offset,
											}
										end

										return tbl14
									end

									do
										local function fn76(arg)
											local n54

											if not (not arg or arg == "") then
												local match2, v68 = arg:gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")
												if not match2 then
													return nil
												end
												n54 = tonumber(match2) or 0
												local str5 = v68:upper()

												if str5 == "K" then
													n54 *= 1000
												elseif str5 == "M" then
													n54 *= 1000000
												elseif str5 == "B" then
													n54 *= 1e9
												elseif str5 == "T" then
													n54 *= 1e12
												end
											end

											return n54
										end

										fn73 = function(arg, arg2, arg3, arg4)
											local v68 = tbl8[arg]
											local n54 = type(v68) == "table" and tonumber(v68.Generation) or 0
											local n55

											if n54 <= 0 then
												n55 = fn76(arg4) or 0
											else
												local ok13 = arg2 and tbl10 and tbl10[arg2]
												local n56 = 1

												if ok13 then
													n56 = 1 + (tonumber(tbl10[arg2].Modifier) or 0)
												end

												local ok14 = arg3 and tbl11
												local flag43 = false

												if ok14 then
													for _, v69 in ipairs(arg3) do
														local v70 = tbl11[v69] or tbl11[v69:gsub("_", " ")]

														if v70 then
															if v69 == "Sleepy" or v70.Name == "Sleepy" then
																flag43 = true
															else
																n56 += tonumber(v70.MultiplierModifier) or 0
															end
														end
													end
												end

												n55 = math.round(n54 * n56 * (flag43 and 0.5 or 1))
												local v69 = fn76(arg4)
												if v69 and v69 > n55 then
													return v69
												end
												n55 = n55 > 0 and n55 or v69 or n54
											end

											return n55
										end
									end
								end

								fn74 = function(arg, arg2, arg3)
									local list2 = {}
									local list3 = {}
									local matchMap2 = {}
									local tbl14 = {}

									local function fn76(arg4, arg5)
										if arg4 and not tbl14[arg4] then
											tbl14[arg4] = true
											table.insert(list3, arg4)
										end

										if arg5 and arg5 ~= "" and arg5 ~= "rbxassetid://110835412437000" then
											local match2 = tostring(arg5):match("%d+")
											local match3 = match2 or tostring(arg5)

											if not matchMap2[match3] then
												matchMap2[match3] = true
												local str5 = tostring(arg5)

												if not str5:find("://") and match2 then
													str5 = "rbxassetid://" .. match2
												end

												table.insert(list2, str5)
											end
										end
									end

									local arg32 = arg3 or fn75(arg, arg2)
									arg32 = arg32 and arg32:FindFirstChild("Traits")

									if arg32 and arg32.Visible then
										for _, child in ipairs(arg32:GetChildren()) do
											if child:IsA("ImageLabel") and child.Visible and child.Image and child.Image ~= "" then
												local str5 = tostring(child.Image)
												local match2 = str5:match("%d+")
												local matchEntry = matchMap[str5] or match2 and matchMap[match2]

												if matchEntry then
													matchEntry = matchEntry.TraitKey or matchEntry.Display or matchEntry.Name
												end

												fn76(matchEntry, child.Image)
											end
										end
									end

									for _, child in ipairs(arg:GetChildren()) do
										local match2 = child.Name:match("^_Trait%.(.+)$")

										if match2 then
											local v68 = tbl11[match2] or tbl11[match2:gsub("_", " ")]
											fn76(match2, v68 and v68.Icon)
										end
									end

									local attribute = arg:GetAttribute("Trait") or arg:GetAttribute("Traits")

									if attribute then
										local str5 = tostring(attribute)
										local v68 = tbl11[str5] or tbl11[str5:gsub("_", " ")]
										fn76(str5, v68 and v68.Icon)
									end

									return #list2 > 0 and list2 or nil, #list3 > 0 and list3 or nil
								end

								getRootPart = function(arg)
									return arg:FindFirstChild("RootPart") or arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
								end

								do
									local function fn76(parent4, layoutOrder, arg)
										local frame3 = Instance.new("Frame")
										frame3.BackgroundTransparency = 1
										frame3.LayoutOrder = layoutOrder
										frame3.Size = UDim2.new(1, 0, 0, arg)
										frame3.Parent = parent4
										local textLabel = Instance.new("TextLabel")
										textLabel.BackgroundTransparency = 1
										textLabel.FontFace = font3
										textLabel.Position = UDim2.fromOffset(1, 1)
										textLabel.Size = UDim2.fromScale(1, 1)
										textLabel.Text = ""
										textLabel.TextColor3 = Color3.fromRGB(12, 0, 2)
										textLabel.TextScaled = true
										textLabel.TextStrokeTransparency = 1
										textLabel.TextTransparency = 0.1
										textLabel.ZIndex = 2
										textLabel.Parent = frame3
										local textLabel2 = Instance.new("TextLabel")
										textLabel2.BackgroundTransparency = 1
										textLabel2.FontFace = font3
										textLabel2.Size = UDim2.fromScale(1, 1)
										textLabel2.Text = ""
										textLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
										textLabel2.TextScaled = true
										textLabel2.TextStrokeTransparency = 1
										textLabel2.ZIndex = 3
										textLabel2.Parent = frame3
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
										return { Holder = frame3, Label = textLabel2, Shadow = textLabel, Stroke = uiStroke, StrokeGradient = uiGradient, TextGradient = uiGradient2 }
									end

									local function fn77(parent4, layoutOrder, arg)
										local traitRow = Instance.new("Frame")
										traitRow.Name = "TraitRow"
										traitRow.BackgroundTransparency = 1
										traitRow.LayoutOrder = layoutOrder
										traitRow.Size = UDim2.new(1, 0, 0, arg)
										traitRow.Parent = parent4
										local uiListLayout = Instance.new("UIListLayout")
										uiListLayout.FillDirection = Enum.FillDirection.Horizontal
										uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
										uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
										uiListLayout.Padding = UDim.new(0, 3)
										uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
										uiListLayout.Parent = traitRow
										return { Holder = traitRow, Layout = uiListLayout, Icons = {}, CurrentKey = "" }
									end

									fn61 = function(adornee, adornee2)
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
										local frame3 = Instance.new("Frame")
										frame3.BackgroundTransparency = 1
										frame3.Size = UDim2.fromScale(1, 1)
										frame3.Parent = brainrotTag
										local uiListLayout = Instance.new("UIListLayout")
										uiListLayout.FillDirection = Enum.FillDirection.Vertical
										uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
										uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
										uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
										uiListLayout.Parent = frame3
										local v68 = fn75(adornee, adornee2)
										local text = v68 and v68:FindFirstChild("Generation") and v68.Generation.Text
										local text2 = v68 and v68:FindFirstChild("Mutation") and v68.Mutation.Visible and v68.Mutation.Text

										if not text2 then
											local attribute = adornee:GetAttribute("Mutation") or adornee:GetAttribute("__mutation")

											if attribute and tostring(attribute) ~= "" then
												text2 = tostring(attribute)
											end
										end

										local v69, v70 = fn74(adornee, adornee2)
										local v71 = fn73(adornee.Name, text2, v70, text)

										local tbl14 = {
											Model = adornee,
											Root = adornee2,
											Billboard = brainrotTag,
											Column = frame3,
											RarityRow = fn76(frame3, 0, 16),
											TraitRow = fn77(frame3, 1, 18),
											MutationRow = fn76(frame3, 2, 15),
											NameRow = fn76(frame3, 3, 19),
											ValueRow = fn76(frame3, 4, 16),
											Name = adornee.Name,
											Generation = v71,
										}

										tbl14.RarityRow.Label.RichText = true
										tbl14.MutationRow.Label.RichText = true
										tbl14.RarityRow.Holder.Visible = false
										tbl14.TraitRow.Holder.Visible = false
										local v72 = fn69(tbl14.Generation)
										tbl14.NameRow.TextGradient.Color = v72.Text
										tbl14.NameRow.TextGradient.Enabled = true
										tbl14.NameRow.StrokeGradient.Color = v72.Stroke
										tbl14.NameRow.StrokeGradient.Enabled = true
										tbl14.ValueRow.TextGradient.Enabled = false
										tbl14.ValueRow.StrokeGradient.Enabled = false
										tbl14.ValueRow.Label.TextColor3 = Color3.fromRGB(115, 255, 0)
										tbl14.ValueRow.Shadow.TextColor3 = Color3.fromRGB(18, 48, 0)
										tbl14.ValueRow.Stroke.Transparency = 0.3
										tbl14.NameRow.Label.Text = tbl14.Name
										tbl14.NameRow.Shadow.Text = tbl14.Name
										local formattedText = formatCompact(tbl14.Generation)
										tbl14.ValueRow.Label.Text = formattedText
										tbl14.ValueRow.Shadow.Text = formattedText
										local brainrotHighlight = Instance.new("Highlight")
										brainrotHighlight.Name = "BrainrotHighlight"
										brainrotHighlight.Adornee = adornee
										brainrotHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
										brainrotHighlight.FillColor = v72.Outline
										brainrotHighlight.FillTransparency = 0.86
										brainrotHighlight.OutlineColor = v72.Outline
										brainrotHighlight.OutlineTransparency = 0.3
										brainrotHighlight.Enabled = false
										brainrotHighlight.Parent = adornee
										tbl14.Highlight = brainrotHighlight
										tbl14.BeamTint = v72.Outline
										return tbl14
									end
								end
							end

							fn60 = function(arg)
								local floor = math.floor
								local n54 = 95 * n53
								arg.Billboard.Size = UDim2.fromOffset(math.floor(220 * n53), floor(n54))
								arg.RarityRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(16 * n53))
								local n55 = math.floor(18 * n53)
								arg.TraitRow.Holder.Size = UDim2.new(1, 0, 0, n55)

								for _, icon in ipairs(arg.TraitRow.Icons) do
									icon.Size = UDim2.fromOffset(n55, n55)
								end

								arg.MutationRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(15 * n53))
								arg.NameRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(19 * n53))
								arg.ValueRow.Holder.Size = UDim2.new(1, 0, 0, math.floor(16 * n53))
							end

							do
								local function fn75(arg)
									if arg.RarityGradientCleanup then
										pcall(arg.RarityGradientCleanup)
										arg.RarityGradientCleanup = nil
									end

									arg.ActiveRarityEffect = nil
									arg.SourceRarityGrad = nil
									arg.SourceMutationGrad = nil
								end

								fn62 = function(arg, arg2)
									pcall(function()
										if not enabledFlags3.Mutation then
											arg.MutationShown = false
											arg.MutationRow.Holder.Visible = false
											return
										end

										if arg2 < (arg.MutationCheckedAt or 0) then
											arg.MutationRow.Holder.Visible = arg.MutationShown == true
											return
										end
										arg.MutationCheckedAt = arg2 + 0.4
										local v68 = fn72(arg.Model, arg.Root, fn71(arg))

										if not v68 then
											arg.MutationShown = false
											arg.MutationRow.Holder.Visible = false
											arg.SourceMutationGrad = nil
											return
										end

										arg.MutationShown = true
										local mutationRow = arg.MutationRow
										mutationRow.Holder.Visible = true
										mutationRow.Label.RichText = v68.RichText
										mutationRow.Label.Text = v68.Text

										if v68.Color then
											mutationRow.Label.TextColor3 = v68.Color
										end

										if v68.Font then
											pcall(function()
												mutationRow.Label.FontFace = v68.Font
												mutationRow.Shadow.FontFace = v68.Font
											end)
										end

										if v68.StrokeColor then
											mutationRow.Stroke.Color = v68.StrokeColor
										end

										if v68.Gradient then
											pcall(function()
												mutationRow.TextGradient.Color = v68.Gradient.Color
												mutationRow.TextGradient.Rotation = v68.Gradient.Rotation
												mutationRow.TextGradient.Offset = v68.Gradient.Offset
												mutationRow.TextGradient.Enabled = true
											end)

											arg.SourceMutationGrad = v68.SourceGrad
										else
											mutationRow.TextGradient.Enabled = false
											arg.SourceMutationGrad = nil
										end

										mutationRow.Shadow.RichText = false
										mutationRow.Shadow.Text = v68.Text:gsub("<[^<>]->", "")
									end)
								end

								fn63 = function(arg, arg2)
									if not enabledFlags3.Rarity then
										arg.RarityShown = false
										arg.RarityRow.Holder.Visible = false
										fn75(arg)
										return
									end

									if arg2 < (arg.RarityCheckedAt or 0) then
										arg.RarityRow.Holder.Visible = arg.RarityShown == true
										return
									end
									arg.RarityCheckedAt = arg2 + 0.5
									local text = fn70(arg.Model.Name)
									local v68 = fn71(arg)
									local rarity = v68 and v68:FindFirstChild("Rarity")

									if rarity and rarity:IsA("TextLabel") and rarity.Visible and rarity.Text ~= "" then
										text = rarity.Text
									end

									if not text or text == "" then
										arg.RarityShown = false
										arg.RarityRow.Holder.Visible = false
										fn75(arg)
										return
									end

									arg.RarityShown = true
									local rarityRow = arg.RarityRow
									rarityRow.Holder.Visible = true
									rarityRow.Label.Text = text
									rarityRow.Shadow.Text = text:gsub("<[^<>]->", "")
									local gradientPreset = tbl9[text]
									gradientPreset = gradientPreset and gradientPreset.GradientPreset
									local flag43 = false

									pcall(function()
										if gradientPreset and ok12 and ok12.apply then
											if arg.ActiveRarityEffect ~= gradientPreset then
												if arg.RarityGradientCleanup then
													pcall(arg.RarityGradientCleanup)
													arg.RarityGradientCleanup = nil
												end

												arg.ActiveRarityEffect = gradientPreset

												local ok13, rarityGradientCleanup = pcall(function()
													return ok12.apply(rarityRow.Label, gradientPreset)
												end)

												if ok13 and typeof(rarityGradientCleanup) == "function" then
													arg.RarityGradientCleanup = rarityGradientCleanup
												end
											end

											pcall(function()
												rarityRow.Label.TextColor3 = Color3.fromRGB(255, 255, 255)
											end)

											arg.SourceRarityGrad = nil
											flag43 = true
										end
									end)

									if not flag43 then
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

								fn64 = function(arg, arg2)
									if not enabledFlags3.Trails then
										arg.TraitRow.Holder.Visible = false
										return
									end

									if arg2 < (arg.TraitCheckedAt or 0) then
										arg.TraitRow.Holder.Visible = arg.TraitIcons ~= nil
										return
									end
									arg.TraitCheckedAt = arg2 + 0.5
									local v68, v69 = fn74(arg.Model, arg.Root, fn71(arg))
									arg.ActiveTraitNames = v69

									if not v68 then
										arg.TraitIcons = nil
										arg.TraitRow.Holder.Visible = false
										arg.TraitRow.CurrentKey = ""

										for _, icon in ipairs(arg.TraitRow.Icons) do
											icon.Visible = false
										end
									else
										arg.TraitIcons = v68
										arg.TraitRow.Holder.Visible = true
										local currentKey = table.concat(v68, "|")

										if arg.TraitRow.CurrentKey ~= currentKey then
											arg.TraitRow.CurrentKey = currentKey
											local n54 = math.floor(18 * n53)

											for i_ = 1, #v68 do
												local icon = arg.TraitRow.Icons[i_]

												if not icon then
													icon = Instance.new("ImageLabel")
													icon.BackgroundTransparency = 1
													icon.ScaleType = Enum.ScaleType.Fit
													icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
													icon.ZIndex = 3
													icon.Parent = arg.TraitRow.Holder
													arg.TraitRow.Icons[i_] = icon
												end

												icon.Image = v68[i_]
												icon.Size = UDim2.fromOffset(n54, n54)
												icon.LayoutOrder = i_
												icon.Visible = true
											end

											for i_ = #v68 + 1, #arg.TraitRow.Icons do
												arg.TraitRow.Icons[i_].Visible = false
											end
										end
									end
								end

								fn65 = function(arg, arg2)
									if not (arg2 < (arg.GenerationCheckedAt or 0)) then
										arg.GenerationCheckedAt = arg2 + 0.4
										local mutation = fn71(arg)
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
											local v68
											v68, activeTraitNames = fn74(arg.Model, arg.Root)
											arg.ActiveTraitNames = activeTraitNames
										end

										local v68 = fn73(arg.Name, text2, activeTraitNames, text)

										if v68 ~= arg.Generation and v68 > 0 then
											arg.Generation = v68
											local formattedText = formatCompact(v68)
											arg.ValueRow.Label.Text = formattedText
											arg.ValueRow.Shadow.Text = formattedText
											local v69 = fn69(v68)
											arg.NameRow.TextGradient.Color = v69.Text
											arg.NameRow.StrokeGradient.Color = v69.Stroke
											arg.Highlight.FillColor = v69.Outline
											arg.Highlight.OutlineColor = v69.Outline
											arg.BeamTint = v69.Outline
										end
									end
								end

								fn66 = function(arg, arg2)
									if flag40 then
										return arg2
									end
									return (arg.Generation or 0) >= n52
								end

								attachment = nil
								local attachment2 = nil
								local beam = nil
								local beam2 = nil
								parent2 = nil
								parent3 = nil

								fn67 = function()
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
									parent2 = nil
									parent3 = nil
								end

								fn68 = function(parent4, parent5)
									fn67()
									if not (parent4 and parent5) then
										return
									end
									attachment = Instance.new("Attachment")
									attachment.Name = "BrainrotBeamStart"
									attachment.Position = Vector3.new(0, 1, 0)
									attachment.Parent = parent4
									attachment2 = Instance.new("Attachment")
									attachment2.Name = "BrainrotBeamTarget"
									attachment2.Position = Vector3.new(0, 2.5, 0)
									attachment2.Parent = parent5
									local color3 = Color3.fromRGB(255, 25, 140)
									local color4 = Color3.fromRGB(255, 120, 220)
									local color5 = Color3.fromRGB(180, 35, 255)
									beam = Instance.new("Beam")
									beam.Name = "BrainrotBeamGlow"
									beam.Attachment0 = attachment
									beam.Attachment1 = attachment2
									beam.Color = ColorSequence.new(color3, color5)
									beam.CurveSize0 = 1.8
									beam.CurveSize1 = -1.8
									beam.FaceCamera = true
									beam.LightEmission = 0.55
									beam.Segments = 20
									beam.Transparency = NumberSequence.new(0.65)
									beam.Width0 = 0.42
									beam.Width1 = 0.6
									obj2[beam] = true
									beam.Parent = attachment
									beam2 = Instance.new("Beam")
									beam2.Name = "BrainrotBeamCore"
									beam2.Attachment0 = attachment
									beam2.Attachment1 = attachment2
									local beam3 = beam2
									local colorSequenceNew = ColorSequence.new
									local tbl14 = {}
									local v68 = ColorSequenceKeypoint.new(0, color3)
									local v69 = ColorSequenceKeypoint.new(0.5, color4)
									local new = ColorSequenceKeypoint.new
									tbl14[1] = v68
									tbl14[2] = v69

									do
										local values = table.pack(new(1, color5))
										table.move(values, 1, values.n, 3, tbl14)
									end

									beam3.Color = colorSequenceNew(tbl14)
									beam2.CurveSize0 = 1.8
									beam2.CurveSize1 = -1.8
									beam2.FaceCamera = true
									beam2.LightEmission = 0.6
									beam2.Segments = 20
									beam2.Transparency = NumberSequence.new(0.04)
									beam2.Width0 = 0.12
									beam2.Width1 = 0.22
									obj2[beam2] = true
									beam2.Parent = attachment2
									parent2 = parent4
									parent3 = parent5
								end

								destroyAll2 = function(arg)
									fn75(arg)

									local function destroyAll3()
										arg.Billboard:Destroy()
									end

									pcall(destroyAll3)

									pcall(function()
										arg.Highlight:Destroy()
									end)

									if parent3 == arg.Root then
										fn67()
									end
								end
							end
						end

						local fn69, fn70

						do
							local n54, fn71, fn72

							do
								fn69 = function()
									for k, v68 in pairs(kMap) do
										destroyAll2(v68)
										kMap[k] = nil
									end
								end

								n54 = 14

								do
									local v68 = nil
									local obj4 = setmetatable({}, { __mode = "k" })

									fn71 = function(arg)
										if v68 and v68.Parent then
											return arg == v68
										end
										local plotSign = arg and arg:FindFirstChild("PlotSign")

										if plotSign then
											local str5 = string.lower(localPlayer.Name)
											local str6 = string.lower(localPlayer.DisplayName)

											for _, descendant in ipairs(plotSign:GetDescendants()) do
												if descendant:IsA("TextLabel") then
													local str7 = string.lower(tostring(descendant.Text or ""))
													if str7 == "your base" or string.find(str7, str5, 1, true) or string.find(str7, str6, 1, true) then
														v68 = arg
														return true
													end
												end
											end
										end

										return false
									end

									fn72 = function(arg, arg2)
										local v69 = obj4[arg]
										if v69 and v69.Parent and tostring(v69.ActionText) == "Steal" then
											return v69
										end
										obj4[arg] = nil

										for _, descendant in ipairs(arg2:GetDescendants()) do
											if descendant:IsA("ProximityPrompt") and tostring(descendant.ActionText) == "Steal" then
												obj4[arg] = descendant
												return descendant
											end
										end

										return nil
									end
								end
							end

							do
								local function fn73(arg)
									local tbl14 = {}
									local animalPodiums = arg and arg:FindFirstChild("AnimalPodiums")

									if animalPodiums then
										for _, child in ipairs(animalPodiums:GetChildren()) do
											local base = child:FindFirstChild("Base")
											base = base and base:FindFirstChild("Spawn")

											if base and base:IsA("BasePart") then
												local v68 = fn72(child, base:FindFirstChild("PromptAttachment") or base)

												if v68 then
													local str5 = tostring(v68.ObjectText or "")

													if str5 ~= "" then
														local positions = tbl14[str5]

														if not positions then
															positions = {}
															tbl14[str5] = positions
														end

														positions[#positions + 1] = base.Position
													end
												end
											end
										end
									end

									return tbl14
								end

								local function fn74(arg, arg2)
									if not (arg and arg2) then
										return false
									end

									for _, v68 in ipairs(arg2) do
										if (arg.Position - v68).Magnitude <= n54 then
											return true
										end
									end

									return false
								end

								fn70 = function()
									local plots2 = Workspace:FindFirstChild("Plots")
									if not plots2 then
										fn69()
										return
									end
									local childMap = {}

									for _, child in ipairs(plots2:GetChildren()) do
										if not fn71(child) then
											local v68 = fn73(child)

											for _, child2 in ipairs(child:GetChildren()) do
												if child2:IsA("Model") and tbl8[child2.Name] then
													local rootPart = getRootPart(child2)

													if fn74(rootPart, v68[child2.Name]) then
														childMap[child2] = true
														local kEntry = kMap[child2]

														if kEntry and kEntry.Root ~= rootPart then
															destroyAll2(kEntry)
															kEntry = nil
														end

														if not kEntry then
															local v69 = fn61(child2, rootPart)
															kMap[child2] = v69
															fn60(v69)
														end
													end
												end
											end
										end
									end

									for k, v68 in pairs(kMap) do
										if not childMap[k] or not k.Parent then
											destroyAll2(v68)
											kMap[k] = nil
										end
									end
								end
							end
						end

						do
							do
								local function fn71()
									if not flag42 then
										return
									end
									flag42 = false
									disconnectAll2(connections3)
									fn67()
									fn69()
								end

								local function fn72()
									if flag42 then
										return
									end
									flag42 = true
									fn70()
									local n54 = 0

									connections3[#connections3 + 1] = RunService.RenderStepped:Connect(function()
										if flag42 then
											local now3 = os.clock()

											if n54 <= now3 then
												n54 = now3 + 1
												fn70()
											end

											local generation = nil
											local v68 = nil

											for _, v69 in pairs(kMap) do
												if v69.Root.Parent then
													local flag402 = flag40

													if not flag40 then
														flag402 = (v69.Generation or 0) >= n52
													end

													if flag402 and (not generation or v69.Generation > generation) then
														generation = v69.Generation
														v68 = v69
													end
												end
											end

											for _, v69 in pairs(kMap) do
												local v70 = fn66(v69, v69 == v68)
												v69.Billboard.Enabled = v70
												v69.Highlight.Enabled = v70

												if v70 then
													v69.NameRow.Holder.Visible = enabledFlags3.Name
													v69.ValueRow.Holder.Visible = enabledFlags3.Value
													pcall(fn63, v69, now3)
													pcall(fn62, v69, now3)
													pcall(fn64, v69, now3)
													pcall(fn65, v69, now3)

													if enabledFlags3.Rarity and v69.SourceRarityGrad and v69.SourceRarityGrad.Parent then
														pcall(function()
															v69.RarityRow.TextGradient.Offset = v69.SourceRarityGrad.Offset
															v69.RarityRow.TextGradient.Rotation = v69.SourceRarityGrad.Rotation
															v69.RarityRow.TextGradient.Color = v69.SourceRarityGrad.Color
														end)
													end

													if enabledFlags3.Mutation and v69.SourceMutationGrad and v69.SourceMutationGrad.Parent then
														pcall(function()
															v69.MutationRow.TextGradient.Offset = v69.SourceMutationGrad.Offset
															v69.MutationRow.TextGradient.Rotation = v69.SourceMutationGrad.Rotation
															v69.MutationRow.TextGradient.Color = v69.SourceMutationGrad.Color
														end)
													end
												end
											end

											local v69 = fn52()
											local flag412 = flag41
											local v692

											if flag41 then
												v692 = v68
											else
												v692 = flag412
											end

											if not (v692 and v69) then
												if attachment then
													fn67()
												end
											else
												local flag43 = parent2 ~= v69 or parent3 ~= v68.Root

												if not flag43 then
													flag43 = not (attachment and attachment.Parent)
												end

												if flag43 then
													fn68(v69, v68.Root, v68.BeamTint)
												end
											end
										end
									end)
								end

								v64.Event:Connect(fn71)
								chilliBrainrotESPRuntime.Destroying:Connect(fn71)

								brainrotEspToggle = brainrotEspSection:CreateToggle({
									Name = "Brainrot ESP",
									Default = true,
									Callback = function(arg)
										if arg then
											fn72()
										else
											fn71()
										end
									end,
								})
							end
						end
					end

					do
						local brainrotEspMinValueSlider, str5, fn61

						do
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
									n53 = math.clamp((tonumber(arg) or 100) / 100, 0.5, 2)

									for _, v68 in pairs(kMap) do
										fn60(v68)
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
									local enabledFlags4 = { Name = false, Mutation = false, Value = false, Trails = false, Rarity = false }

									if type(arg) == "table" then
										for k, v68 in pairs(arg) do
											if type(v68) == "string" then
												if enabledFlags4[v68] ~= nil then
													enabledFlags4[v68] = true
												elseif v68 == "Type" then
													enabledFlags4.Rarity = true
												end
											else
												if not (type(k) == "string" and v68 == true) then
													continue
												end

												if enabledFlags4[k] ~= nil then
													enabledFlags4[k] = true
												elseif k == "Type" then
													enabledFlags4.Rarity = true
												end
											end
										end
									end

									enabledFlags3 = enabledFlags4
								end,
							})

							brainrotEspMinValueSlider = nil

							do
								local n54 = 1
								str5 = "M/s"

								fn61 = function(arg, arg2)
									if arg ~= nil then
										n54 = math.floor(tonumber(arg) or n54)
									end

									if arg2 ~= nil then
										str5 = tostring(arg2)
									elseif brainrotEspMinValueSlider and brainrotEspMinValueSlider.GetUnit then
										local unit = brainrotEspMinValueSlider:GetUnit()

										if unit and unit ~= "" then
											str5 = tostring(unit)
										end
									end

									n52 = n54 * (configMap[str5] or configMap["M/s"]).Mult
								end
							end
						end

						do
							local function fn62(arg)
								str5 = arg
								local configEntry = configMap[arg] or configMap["M/s"]

								if brainrotEspMinValueSlider and brainrotEspMinValueSlider.SetRange then
									brainrotEspMinValueSlider:SetRange(configEntry.Min, configEntry.Max)
									local min = brainrotEspMinValueSlider:Get() or configEntry.Min
									local min2 = configEntry.Min
									local max = configEntry.Max
									local n54 = math.clamp(math.floor(min + 0.5), min2, max)

									if n54 ~= min then
										brainrotEspMinValueSlider:Set(n54)
									else
										fn61(n54, arg)
									end
								else
									fn61(nil, arg)
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
									Colors = {
										Number = Color3.fromRGB(255, 255, 255),
										Suffix = Color3.fromRGB(58, 255, 55),
									},
									Callback = function(arg)
										fn62(arg)
									end,
								},
								Quick = false,
								SubOf = brainrotEspToggle,
								Callback = function(arg)
									fn61(arg, nil)
								end,
							})
						end
					end

					brainrotEspSection:CreateToggle({
						Name = "Best Brainrot Only",
						Default = true,
						Quick = false,
						SubOf = brainrotEspToggle,
						Callback = function(arg)
							flag40 = arg == true
						end,
					})

					brainrotEspSection:CreateToggle({
						Name = "Beam To Best",
						Note = "Draws one beam from you to the highest generation Brainrot.",
						Default = true,
						Quick = false,
						SubOf = brainrotEspToggle,
						Callback = function(arg)
							flag41 = arg == true
						end,
					})
				end

				local n52, n53, chilliBrainrotNotificationRuntim, v68, flag40, n54, flag41, n55, n56, connection12
				local obj4, chilliSpecialNotificationSlots, screenGui, notificationStack, tbl14, tbl15, tbl16, fn60, fn61, fn62

				do
					local str5, str6, soundId, str7, TweenService2, font4, tbl17, fn63

					do
						local v69

						do
							str5 = "__ChilliBrainrotNotificationRuntime"
							n52 = 0.75
							n53 = 3
							chilliBrainrotNotificationRuntim, v68 = fn51("__ChilliBrainrotNotificationRuntime")
							flag40 = false
							str6 = ""
							soundId = ""
							str7 = ""
							n54 = 1000000
							flag41 = true
							n55 = 0
							n56 = 0
							connection12 = nil
							obj4 = setmetatable({}, { __mode = "k" })
							v69 = nil

							do
								local Gradients = nil
								chilliSpecialNotificationSlots = {}
								screenGui = nil
								notificationStack = nil
								TweenService2 = game:GetService("TweenService")
								font4 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
								tbl14 = {}
								tbl15 = {}
								tbl16 = {}

								pcall(function()
									local Animals = require(ReplicatedStorage.Datas.Animals)

									if type(Animals) == "table" then
										tbl14 = Animals
									end
								end)

								pcall(function()
									local Mutations = require(ReplicatedStorage.Datas.Mutations)

									if type(Mutations) == "table" then
										tbl15 = Mutations
									end
								end)

								pcall(function()
									local Traits = require(ReplicatedStorage.Datas.Traits)

									if type(Traits) == "table" then
										tbl16 = Traits
									end
								end)

								pcall(function()
									local Gradients2 = require(ReplicatedStorage.Packages.Gradients)

									if type(Gradients2) == "table" then
										Gradients = Gradients2
									end
								end)
							end
						end

						tbl17 = {}

						do
							local tbl18 = { Preset = "Zebra", Background = Color3.fromRGB(16, 16, 20) }
							local colorSequenceNew = ColorSequence.new
							local tbl19 = {}
							local v70 = ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255))
							local v71 = ColorSequenceKeypoint.new(0.24, Color3.fromRGB(45, 45, 55))
							local v72 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255))
							local v73 = ColorSequenceKeypoint.new(0.76, Color3.fromRGB(45, 45, 55))
							tbl19[1] = v70
							tbl19[2] = v71
							tbl19[3] = v72
							tbl19[4] = v73

							do
								local values = table.pack(ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)))
								table.move(values, 1, values.n, 5, tbl19)
							end

							tbl18.Colors = colorSequenceNew(tbl19)
							tbl17["Secret Zebra"] = tbl18
						end

						fn63 = function()
							if not v69 then
								local controllers = ReplicatedStorage:FindFirstChild("Controllers")
								controllers = controllers and controllers:FindFirstChild("NotificationController")
								if not (controllers and controllers:IsA("ModuleScript")) then
									return nil
								end
								local ok13, result14 = pcall(require, controllers)

								if ok13 and type(result14) == "table" then
									v69 = result14
								end
							end

							return v69
						end
					end

					local destroyAll2

					do
						do
							local function fn64(arg)
								local match2 = tostring(arg or ""):match("(%d+)")
								if match2 and tonumber(match2) and tonumber(match2) > 0 then
									return "rbxassetid://" .. match2
								end
								return nil
							end

							local function fn65(arg)
								if not arg then
									return nil
								end

								if arg:IsA("Sound") then
									return fn64(arg.SoundId)
								end
								local v69, sound

								if arg:IsA("StringValue") then
									v69 = fn64(arg.Value)

									if not v69 then
										v69 = fn64(arg:GetAttribute("SoundId"))

										if not v69 then
											sound = arg:FindFirstChildWhichIsA("Sound", true)
											sound = sound and fn64(sound.SoundId) or nil
											return sound
										end
									end
								else
									v69 = fn64(arg:GetAttribute("SoundId"))
									if not v69 then
										sound = arg:FindFirstChildWhichIsA("Sound", true)
										return sound and fn64(sound.SoundId) or nil
									end
								end

								return v69
							end

							local function fn66()
								local v69 = ipairs
								local tbl18 = {}
								local SoundService = table.pack(game:GetService("SoundService"))
								tbl18[1] = ReplicatedStorage

								do
									local values = table.pack(table.unpack(SoundService, 1, SoundService.n))
									table.move(values, 1, values.n, 2, tbl18)
								end

								for _, v70 in v69(tbl18) do
									local crystalSpawn = v70:FindFirstChild("CrystalSpawn", true)
									local v71 = fn65(crystalSpawn)
									if v71 then
										return v71
									end
								end

								return ""
							end

							fn60 = function(arg)
								str6 = tostring(arg or "")
							end

							fn61 = function()
								local v69 = fn64(str6)

								if not v69 then
									soundId = str7
									v36.Notify("Sound ID Failed", "Invalid asset ID. Restored the default Crystal sound.", 5)
									return false
								end

								local chilliSoundIdValidation = Instance.new("Sound")
								chilliSoundIdValidation.Name = "ChilliSoundIdValidation"
								chilliSoundIdValidation.SoundId = v69
								chilliSoundIdValidation.Volume = 0
								chilliSoundIdValidation.Parent = game:GetService("SoundService")
								local flag42 = false

								local flag422 = pcall(function()
									game:GetService("ContentProvider"):PreloadAsync({ chilliSoundIdValidation }, function(arg, arg2)
										if arg2 == Enum.AssetFetchStatus.Success then
											flag42 = true
										end
									end)
								end) and (flag42 or chilliSoundIdValidation.IsLoaded or chilliSoundIdValidation.TimeLength > 0)

								chilliSoundIdValidation:Destroy()

								if not flag422 then
									soundId = str7
									v36.Notify("Sound ID Failed", "Audio unavailable. Restored the default Crystal sound.", 5)
									return false
								end

								soundId = v69
								str6 = v69
								v36.Notify("Sound ID Applied", v69 .. " is now used for Brainrot notifications.", 5)
								return true
							end

							destroyAll2 = function()
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

							str7 = fn66()
						end
					end

					soundId = str7
					str6 = soundId

					do
						local function fn64(parent2, arg)
							local uiGradient = Instance.new("UIGradient")
							uiGradient.Color = arg.Colors
							uiGradient.Rotation = 8
							uiGradient.Parent = parent2
							local tween = TweenService2:Create(uiGradient, TweenInfo.new(1.8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 368 })
							tween:Play()

							return function()
								tween:Cancel()
							end
						end

						local function fn65(arg, parent2, name, text, position, size, textSize)
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
							clone.FontFace = font4
							clone.Parent = parent2
							return clone
						end

						local function fn66(parent2, arg, arg2)
							if arg2 and arg2.Parent then
								local ok13, result14 = pcall(function()
									return arg2:Clone()
								end)

								if not (not ok13 or not result14) then
									for _, descendant in ipairs(result14:GetDescendants()) do
										if descendant:IsA("ParticleEmitter") or descendant:IsA("Beam") or descendant:IsA("Trail") or descendant:IsA("Light") or descendant:IsA("Sound") or descendant:IsA("Script") or descendant:IsA("LocalScript") then
											descendant:Destroy()
										end
									end

									local worldModel = Instance.new("WorldModel")
									worldModel.Parent = parent2
									result14.Parent = worldModel

									pcall(function()
										result14:PivotTo(CFrame.new())
									end)

									local cframe = CFrame.new()

									local ok14, result15, vector = pcall(function()
										return result14:GetBoundingBox()
									end)

									ok14 = ok14 and result15 and vector
									local vector2 = Vector3.new(4, 4, 4)

									if not ok14 then
										vector = vector2
										result15 = cframe
									end

									local position = result15.Position
									local n57 = math.max(math.max(vector.X, vector.Y, vector.Z) * 1.35, 3.5)
									arg.FieldOfView = 40
									arg.CFrame = CFrame.lookAt(position + Vector3.new(n57 * 0.28, n57 * 0.08, -n57), position, Vector3.new(0, 1, 0))
									local humanoid = arg2:FindFirstChildWhichIsA("Humanoid") or arg2:FindFirstChildWhichIsA("AnimationController")
									humanoid = humanoid and humanoid:FindFirstChildOfClass("Animator")
									local humanoid2 = result14:FindFirstChildWhichIsA("Humanoid") or result14:FindFirstChildWhichIsA("AnimationController")
									local animator = humanoid2 and humanoid2:FindFirstChildOfClass("Animator")

									if humanoid and animator then
										local playingAnimationTracks = humanoid:GetPlayingAnimationTracks()
										playingAnimationTracks = playingAnimationTracks and playingAnimationTracks[1]

										if playingAnimationTracks and playingAnimationTracks.Animation then
											local animation = Instance.new("Animation")
											animation.AnimationId = playingAnimationTracks.Animation.AnimationId

											local ok15, result16 = pcall(function()
												return animator:LoadAnimation(animation)
											end)

											if ok15 and result16 then
												pcall(function()
													result16.Looped = true
													result16:Play(0)
													result16.TimePosition = playingAnimationTracks.TimePosition
													result16:AdjustSpeed(playingAnimationTracks.Speed)
												end)
											end
										end
									end

									return true
								end
							end

							return false
						end

						local function fn67(arg)
							local pos = table.find(chilliSpecialNotificationSlots, arg)

							if pos then
								table.remove(chilliSpecialNotificationSlots, pos)
							end
						end

						local function createFrame()
							if notificationStack and notificationStack.Parent then
								return notificationStack
							end
							local CoreGui4 = CoreGui

							if type(gethui) == "function" then
								local ok13
								ok13, CoreGui4 = pcall(gethui)
								ok13 = ok13 and typeof(CoreGui4) == "Instance"
								local CoreGui5 = CoreGui

								if not ok13 then
									CoreGui4 = CoreGui5
								end
							end

							local name = str5 .. "Gui"
							local v69 = CoreGui4:FindFirstChild(name)

							if v69 then
								pcall(function()
									v69:Destroy()
								end)
							end

							local screenGui2 = Instance.new("ScreenGui")
							screenGui2.Name = name
							screenGui2.DisplayOrder = 190
							screenGui2.IgnoreGuiInset = true
							screenGui2.ResetOnSpawn = false
							screenGui2.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
							screenGui2.Parent = CoreGui4
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

						local function clampValue2()
							local currentCamera2 = Workspace.CurrentCamera
							local x = currentCamera2 and currentCamera2.ViewportSize.X or 1280

							if x <= 0 then
								x = 1280
							end

							return math.clamp((x - 24) / 620, 0.44, 0.72)
						end

						fn62 = function(arg, arg2, arg3)
							local secretZebra = tbl17[arg3 or "Secret Zebra"] or tbl17["Secret Zebra"]

							if not (type(arg) ~= "table" or not arg.Model) then
								local playerGui = localPlayer:FindFirstChildOfClass("PlayerGui")
								local notification = playerGui and playerGui:FindFirstChild("Notification")
								notification = notification and notification:FindFirstChild("Notification")
								notification = notification and notification:FindFirstChild("Template")

								if not (notification and notification:IsA("TextLabel")) then
									local v69 = fn63()

									if v69 and type(v69.Notify) == "function" then
										local str8 = string.upper(tostring(arg.Name or "Brainrot")) .. " APPEARED!  " .. tostring(arg.ValueText or "")
										local v70 = pcall
										local notify = v69.Notify
										arg2 = arg2 or 6
										local top = v70(notify, v69, str8, arg2, nil, "Top")

										if top then
											destroyAll2()
										end

										return top
									end
								else
									local frame3 = createFrame()

									if frame3 then
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
										local numVal = clampValue2()
										chilliSpecialNotificationSlot.Size = UDim2.new(1, 0, 0, math.ceil(108 * numVal + 7))
										chilliSpecialNotificationSlot.ZIndex = 179
										chilliSpecialNotificationSlot.Parent = frame3
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
										local colorSequenceNew = ColorSequence.new
										local tbl18 = {}
										local v69 = ColorSequenceKeypoint.new(0, secretZebra.Background)
										local v70 = ColorSequenceKeypoint.new(0.48, secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.12))
										local new = ColorSequenceKeypoint.new
										local background = secretZebra.Background
										tbl18[1] = v69
										tbl18[2] = v70

										do
											local values = table.pack(new(1, background))
											table.move(values, 1, values.n, 3, tbl18)
										end

										uiGradient.Color = colorSequenceNew(tbl18)
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
										local tween = TweenService2:Create(uiGradient2, TweenInfo.new(2.4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), { Rotation = 360 })
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
										fn66(brainrotPreview, camera, arg.Model)
										local brainrotName = fn65(notification, chilliSpecialNotification, "BrainrotName", tostring(arg.Name or "Brainrot"), UDim2.fromOffset(115, 7), UDim2.new(1, -252, 0, 34), 22)
										brainrotName.RichText = false
										brainrotName.TextColor3 = Color3.new(1, 1, 1)
										brainrotName.TextTruncate = Enum.TextTruncate.AtEnd
										brainrotName.Font = Enum.Font.GothamBlack
										brainrotName.ZIndex = 183
										local list2 = {}

										local function fn68(parent2, thickness)
											local specialTextOutline = Instance.new("UIStroke")
											specialTextOutline.Name = "SpecialTextOutline"
											specialTextOutline.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
											specialTextOutline.Color = Color3.fromRGB(0, 0, 0)
											specialTextOutline.Thickness = thickness
											specialTextOutline.Transparency = 0.18
											specialTextOutline.Parent = parent2
											local v71 = fn64(parent2, secretZebra)

											if v71 then
												list2[#list2 + 1] = v71
											end
										end

										fn68(brainrotName, 1.35)
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
										local appearedText = fn65(notification, appearedBadge, "AppearedText", "APPEARED!", UDim2.fromOffset(6, 0), UDim2.new(1, -12, 1, 0), 12)
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
										local brainrotValue = fn65(notification, generationBadge, "BrainrotValue", tostring(arg.ValueText or ""), UDim2.fromOffset(9, 0), UDim2.new(1, -18, 1, 0), 18)
										brainrotValue.RichText = false
										brainrotValue.Font = Enum.Font.RobotoMono
										brainrotValue.TextColor3 = Color3.fromRGB(86, 255, 105)
										brainrotValue.TextStrokeColor3 = Color3.fromRGB(0, 32, 7)
										brainrotValue.TextStrokeTransparency = 0.15
										brainrotValue.ZIndex = 184
										local uiGradient5 = Instance.new("UIGradient")
										local colorSequenceNew2 = ColorSequence.new
										local tbl19 = {}
										local v71 = ColorSequenceKeypoint.new(0, Color3.fromRGB(42, 220, 76))
										local v72 = ColorSequenceKeypoint.new(0.5, Color3.fromRGB(208, 255, 132))
										local new2 = ColorSequenceKeypoint.new
										local color3FromRGB = Color3.fromRGB
										tbl19[1] = v71
										tbl19[2] = v72

										do
											local values = table.pack(new2(1, color3FromRGB(38, 255, 105)))
											table.move(values, 1, values.n, 3, tbl19)
										end

										uiGradient5.Color = colorSequenceNew2(tbl19)
										uiGradient5.Rotation = -8
										uiGradient5.Parent = brainrotValue
										local tween2 = TweenService2:Create(uiGradient5, TweenInfo.new(1.45, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Rotation = 18 })
										tween2:Play()

										list2[#list2 + 1] = function()
											tween2:Cancel()
										end

										if arg.MutationVisible then
											local brainrotMutation = fn65(notification, chilliSpecialNotification, "BrainrotMutation", tostring(arg.MutationText or ""), UDim2.fromOffset(115, 76), UDim2.new(1, -304, 0, 22), 17)
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

										local frame4 = Instance.new("Frame")
										frame4.AnchorPoint = Vector2.new(1, 0)
										frame4.BackgroundTransparency = 1
										frame4.Position = UDim2.new(1, -13, 0, 74)
										frame4.Size = UDim2.fromOffset(174, 28)
										frame4.ZIndex = 183
										frame4.Parent = chilliSpecialNotification
										local uiListLayout = Instance.new("UIListLayout")
										uiListLayout.FillDirection = Enum.FillDirection.Horizontal
										uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
										uiListLayout.Padding = UDim.new(0, 3)
										uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
										uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
										uiListLayout.Parent = frame4
										local v73 = ipairs
										local traitImages = arg.TraitImages or {}

										for k, traitImage in v73(traitImages) do
											if not (k > 6) then
												local traitBadge = Instance.new("Frame")
												traitBadge.Name = "TraitBadge"
												traitBadge.BackgroundColor3 = secretZebra.Background:Lerp(Color3.new(1, 1, 1), 0.16)
												traitBadge.BackgroundTransparency = 0.12
												traitBadge.BorderSizePixel = 0
												traitBadge.LayoutOrder = k
												traitBadge.Size = UDim2.fromOffset(26, 26)
												traitBadge.ZIndex = 183
												traitBadge.Parent = frame4
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
										local tbl20 = {}
										local v74 = NumberSequenceKeypoint.new(0, 1)
										local v75 = NumberSequenceKeypoint.new(0.5, 0)
										local new3 = NumberSequenceKeypoint.new
										tbl20[1] = v74
										tbl20[2] = v75

										do
											local values = table.pack(new3(1, 1))
											table.move(values, 1, values.n, 3, tbl20)
										end

										uiGradient6.Transparency = numberSequenceNew(tbl20)
										uiGradient6.Parent = shine
										TweenService2:Create(uiScale, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = numVal }):Play()
										TweenService2:Create(shine, TweenInfo.new(1.25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), { Position = UDim2.fromScale(1.18, -0.12) }):Play()
										destroyAll2()
										local n57 = tonumber(arg2) or 6

										pcall(function()
											game:GetService("Debris"):AddItem(chilliSpecialNotificationSlot, n57 + 1.5)
										end)

										local flag42 = false

										local function destroyAll3()
											if not flag42 then
												flag42 = true

												for i_ = #list2, 1, -1 do
													pcall(list2[i_])
													list2[i_] = nil
												end

												pcall(function()
													tween:Cancel()
												end)

												fn67(chilliSpecialNotificationSlot)

												if chilliSpecialNotificationSlot.Parent then
													pcall(function()
														chilliSpecialNotificationSlot:Destroy()
													end)
												end
											end
										end

										task.delay(n57, function()
											local flag422 = flag42
											local flag4222

											if flag42 then
												flag4222 = flag422
											else
												flag4222 = not chilliSpecialNotification.Parent
											end

											if flag4222 then
												destroyAll3()
												return
											end

											pcall(function()
												tween:Cancel()
												local tbl21 = { Scale = numVal * 0.78 }
												TweenService2:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), tbl21):Play()

												for _, descendant in ipairs(chilliSpecialNotification:GetDescendants()) do
													if descendant:IsA("TextLabel") then
														TweenService2:Create(descendant, TweenInfo.new(0.28), { TextTransparency = 1, BackgroundTransparency = 1 }):Play()
													elseif descendant:IsA("UIStroke") then
														TweenService2:Create(descendant, TweenInfo.new(0.28), { Transparency = 1 }):Play()
													elseif descendant:IsA("ImageLabel") then
														TweenService2:Create(descendant, TweenInfo.new(0.28), { ImageTransparency = 1 }):Play()
													elseif descendant:IsA("ViewportFrame") then
														TweenService2:Create(descendant, TweenInfo.new(0.28), { BackgroundTransparency = 1, ImageTransparency = 1 }):Play()
													elseif descendant:IsA("Frame") then
														TweenService2:Create(descendant, TweenInfo.new(0.28), { BackgroundTransparency = 1 }):Play()
													end
												end

												TweenService2:Create(chilliSpecialNotification, TweenInfo.new(0.28), { BackgroundTransparency = 1 }):Play()
											end)

											task.delay(0.34, destroyAll3)
										end)

										task.delay(n57 + 1, destroyAll3)
										return true
									end
								end
							end

							return false
						end
					end
				end

				local fn63, fn64

				do
					local fn65

					do
						local formatCompact, getRootPart, fn66

						do
							do
								local function formatCompact2(arg)
									local match2, v69 = tostring(arg or ""):gsub("[%$,/s]", ""):gsub("%s+", ""):match("^([%d%.]+)([KkMmBbTt]?)$")
									local num3 = tonumber(match2)
									if not num3 then
										return nil
									end
									return num3 * (({ K = 1000, M = 1000000, B = 1e9, T = 1e12 })[string.upper(v69)] or 1)
								end

								formatCompact = function(arg)
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

								getRootPart = function(arg)
									return arg:FindFirstChild("RootPart") or arg.PrimaryPart or arg:FindFirstChildWhichIsA("BasePart")
								end

								fn66 = function()
									local tbl17 = {}
									local debris = Workspace:FindFirstChild("Debris")

									if debris then
										for _, child in ipairs(debris:GetChildren()) do
											if child:IsA("BasePart") and child.Name == "FastOverheadTemplate" then
												local animalOverhead = child:FindFirstChild("AnimalOverhead")
												local displayName = animalOverhead and animalOverhead:FindFirstChild("DisplayName")
												local generation = animalOverhead and animalOverhead:FindFirstChild("Generation")

												if displayName and displayName:IsA("TextLabel") and generation and generation:IsA("TextLabel") then
													local str5 = tostring(displayName.Text or "")
													tbl17[str5] = tbl17[str5] or {}
													tbl17[str5][#tbl17[str5] + 1] = { Position = child.Position, Value = formatCompact2(generation.Text), Overhead = animalOverhead }
												end
											end
										end
									end

									return tbl17
								end
							end
						end

						do
							local function fn67(arg, arg2, arg3)
								local v69, v70, v71 = ipairs(arg3[arg] or {})
								local n57 = 14
								local v72 = nil

								for _, v73 in v69, v70, v71 do
									local magnitude = (v73.Position - arg2).Magnitude

									if magnitude < n57 then
										n57 = magnitude
										v72 = v73
									end
								end

								return v72
							end

							local function fn68(arg, arg2)
								local Animal = tbl14[arg.Name]
								local n57 = type(Animal) == "table" and tonumber(Animal.Generation) or 0
								local arg22

								if n57 <= 0 then
									arg2 = arg2 and arg2.Value
									arg22 = arg2 or 0
								else
									local attribute = arg:GetAttribute("Mutation") or arg:GetAttribute("__mutation")
									local mutation = arg2 and arg2.Overhead:FindFirstChild("Mutation")

									if mutation and mutation:IsA("TextLabel") and mutation.Visible and mutation.Text ~= "" then
										attribute = mutation.Text
									end

									attribute = attribute and tbl15[tostring(attribute)]
									local n58 = 1

									if type(attribute) == "table" then
										n58 = 1 + (tonumber(attribute.Modifier) or 0)
									end

									local flag42 = false

									for _, child in ipairs(arg:GetChildren()) do
										local match2 = child.Name:match("^_Trait%.(.+)$")
										local Trait = match2 and (tbl16[match2] or tbl16[match2:gsub("_", " ")])

										if type(Trait) == "table" then
											if match2 == "Sleepy" or Trait.Name == "Sleepy" then
												flag42 = true
											else
												n58 += tonumber(Trait.MultiplierModifier) or 0
											end
										end
									end

									arg22 = math.round(n57 * n58 * (flag42 and 0.5 or 1))
									arg2 = arg2 and arg2.Value
									if arg2 and arg2 > 0 then
										return arg2
									end
								end

								return arg22
							end

							fn65 = function()
								local list2 = {}
								local plots2 = Workspace:FindFirstChild("Plots")
								if not plots2 then
									return list2, 0
								end
								local v69 = fn66()
								local n57 = 0

								for _, child in ipairs(plots2:GetChildren()) do
									for _, child2 in ipairs(child:GetChildren()) do
										if child2:IsA("Model") and tbl14[child2.Name] then
											local rootPart = getRootPart(child2)

											if rootPart then
												local overhead = fn67(child2.Name, rootPart.Position, v69)
												local v70 = fn68(child2, overhead)

												if v70 > 0 then
													local Animal = tbl14[child2.Name]
													overhead = overhead and overhead.Overhead
													local mutation = overhead and overhead:FindFirstChild("Mutation")
													local visible2 = mutation and mutation:IsA("TextLabel") and mutation.Visible

													if visible2 then
														visible2 = tostring(mutation.Text or "") ~= ""
													end

													if visible2 then
														visible2 = string.lower(tostring(mutation.Text or "")) ~= "normal"
													end

													local text = nil
													local flag42 = false
													local textColor3 = nil
													local flag43 = false
													local fontFace = nil
													local textStrokeColor3 = nil
													local textStrokeTransparency = nil
													local color3 = nil
													local rotation = nil
													local transparency2 = nil

													if visible2 then
														text = mutation.Text
														textColor3 = mutation.TextColor3
														flag43 = mutation.RichText
														fontFace = mutation.FontFace
														textStrokeColor3 = mutation.TextStrokeColor3
														textStrokeTransparency = mutation.TextStrokeTransparency
														local uiGradient = mutation:FindFirstChildWhichIsA("UIGradient")
														flag42 = true
														color3 = nil
														rotation = nil
														transparency2 = nil

														if uiGradient then
															color3 = uiGradient.Color
															rotation = uiGradient.Rotation
															transparency2 = uiGradient.Transparency
														end
													end

													local images = {}
													local traits3 = overhead and overhead:FindFirstChild("Traits")

													if traits3 then
														for _, child3 in ipairs(traits3:GetChildren()) do
															if child3:IsA("ImageLabel") and child3.Visible and child3.Image ~= "" and #images < 6 then
																images[#images + 1] = child3.Image
															end
														end
													end

													local rarity = type(Animal) == "table" and (Animal.Rarity or Animal.Tier or Animal.Rank) or nil

													list2[#list2 + 1] = {
														Model = child2,
														Name = child2.Name,
														Value = v70,
														ValueText = formatCompact(v70),
														Rarity = rarity and tostring(rarity) or "",
														MutationVisible = flag42,
														MutationText = text and tostring(text) or nil,
														MutationColor = textColor3,
														MutationRichText = flag43,
														MutationFontFace = fontFace,
														MutationStrokeColor = textStrokeColor3,
														MutationStrokeTransparency = textStrokeTransparency,
														MutationGradientColor = color3,
														MutationGradientRotation = rotation,
														MutationGradientTransparency = transparency2,
														TraitImages = images,
													}

													if n57 < v70 then
														n57 = v70
													end
												end
											end
										end
									end
								end

								return list2, n57
							end
						end
					end

					do
						local function fn66(arg, arg2)
							fn62(arg, 7, arg2 or "Secret Zebra")
						end

						fn63 = function()
							table.clear(obj4)
							local v69, v70 = fn65()

							for _, v71 in ipairs(v69) do
								obj4[v71.Model] = { FirstSeen = -math.huge, Value = v71.Value }
							end

							n55 = v70
						end

						fn64 = function()
							local now3 = os.clock()
							local v69, v70 = fn65()
							local list2 = {}
							local n57 = 0

							for _, v71 in ipairs(v69) do
								local v72 = obj4[v71.Model]
								local isNew = v72 == nil
								local v722 = v72 and now3 - v72.FirstSeen <= n53 and v71.Value > v72.Value
								v71.IsNew = isNew
								v71.IsLateValue = v722 == true

								if isNew then
									obj4[v71.Model] = { FirstSeen = now3, Value = v71.Value }
								elseif v72.Value < v71.Value then
									v72.Value = v71.Value
								end

								if not isNew and not v722 and v71.Value > n57 then
									n57 = v71.Value
								end
							end

							local v71 = nil

							for _, v72 in ipairs(v69) do
								if (v72.IsNew or v72.IsLateValue) and v72.Value >= n54 then
									list2[#list2 + 1] = v72

									if v72.Value > n57 and (not v71 or v72.Value > v71.Value) then
										v71 = v72
									end
								end
							end

							n55 = v70

							if flag41 and v71 then
								fn66(v71)
							elseif not flag41 then
								table.sort(list2, function(arg, arg2)
									return arg.Value > arg2.Value
								end)

								for _, v72 in ipairs(list2) do
									fn66(v72)
								end
							end
						end
					end
				end

				do
					do
						local function fn65()
							flag40 = false

							if connection12 then
								connection12:Disconnect()
								connection12 = nil
							end
						end

						local function fn66()
							fn65()
							fn63()
							flag40 = true
							n56 = os.clock() + n52

							connection12 = RunService.Heartbeat:Connect(function()
								if not flag40 or os.clock() < n56 then
									return
								end
								n56 = os.clock() + n52
								pcall(fn64)
							end)
						end

						local function destroyAll2()
							fn65()

							for i_ = #chilliSpecialNotificationSlots, 1, -1 do
								local chilliSpecialNotificationSlot = chilliSpecialNotificationSlots[i_]

								if chilliSpecialNotificationSlot and chilliSpecialNotificationSlot.Parent then
									chilliSpecialNotificationSlot:Destroy()
								end

								chilliSpecialNotificationSlots[i_] = nil
							end

							if screenGui and screenGui.Parent then
								screenGui:Destroy()
							end

							screenGui = nil
							notificationStack = nil
						end

						v68.Event:Connect(destroyAll2)
						chilliBrainrotNotificationRuntim.Destroying:Connect(destroyAll2)

						brainrotNotificationsSection:CreateToggle({
							Name = "Brainrot Notifications",
							Default = false,
							Callback = function(arg)
								if arg then
									fn66()
								else
									fn65()
								end
							end,
						})
					end
				end

				do
					local configMap, notificationMinValueSlider, str5, fn65

					do
						brainrotNotificationsSection:CreateToggle({
							Name = "Only New Highest",
							Note = "Only notifies when the new Brainrot is worth more than every Brainrot already present.",
							Default = true,
							Callback = function(arg)
								flag41 = arg == true
							end,
						})

						configMap = {
							["K/s"] = { Min = 0, Max = 1000, Mult = 1000 },
							["M/s"] = { Min = 0, Max = 1000, Mult = 1000000 },
							["B/s"] = { Min = 1, Max = 1000, Mult = 1e9 },
							["T/s"] = { Min = 1, Max = 1000, Mult = 1e12 },
						}

						notificationMinValueSlider = nil

						do
							local n57 = 1
							str5 = "M/s"

							fn65 = function(arg, arg2)
								if arg ~= nil then
									n57 = math.floor(tonumber(arg) or n57)
								end

								if arg2 ~= nil then
									str5 = tostring(arg2)
								elseif notificationMinValueSlider and notificationMinValueSlider.GetUnit then
									local unit = notificationMinValueSlider:GetUnit()

									if unit and unit ~= "" then
										str5 = tostring(unit)
									end
								end

								n54 = n57 * (configMap[str5] or configMap["M/s"]).Mult
							end
						end
					end

					do
						local function fn66(arg)
							str5 = tostring(arg)
							local configEntry = configMap[str5] or configMap["M/s"]

							if notificationMinValueSlider and notificationMinValueSlider.SetRange then
								notificationMinValueSlider:SetRange(configEntry.Min, configEntry.Max)
								local min = notificationMinValueSlider:Get() or configEntry.Min
								local min2 = configEntry.Min
								local max = configEntry.Max
								local n57 = math.clamp(math.floor(min + 0.5), min2, max)

								if n57 ~= min then
									notificationMinValueSlider:Set(n57)
								else
									fn65(n57, str5)
								end
							else
								fn65(nil, str5)
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
								Colors = {
									Number = Color3.fromRGB(255, 255, 255),
									Suffix = Color3.fromRGB(58, 255, 55),
								},
								Callback = function(arg)
									fn66(arg)
								end,
							},
							Quick = false,
							Callback = function(arg)
								fn65(arg, nil)
							end,
						})
					end
				end

				brainrotNotificationsSection:CreateInput({
					Name = "Notification Sound ID",
					Note = "Enter an audio asset ID, then press Apply Sound ID.",
					Placeholder = "rbxassetid://123456789",
					Default = "rbxassetid://110902246151945",
					MaxLength = 40,
					Callback = function(arg)
						fn60(arg)
					end,
				})

				brainrotNotificationsSection:CreateButton({
					Name = "Apply Sound ID",
					ButtonText = "Apply",
					Callback = function()
						task.spawn(function()
							fn61()
						end)
					end,
				})

				performanceSection = miscTab:CreateSection({ Name = "Performance", Expanded = true })

				do
					local flag42 = false

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
							local clamp2 = math.clamp
							local floor = math.floor
							local v69 = clamp2(floor(tonumber(arg) or 240), 30, 1000)
							if type(setfpscap) == "function" and pcall(setfpscap, v69) then
								flag42 = false
								return
							end

							if not flag42 then
								flag42 = true
								v36.Notify("FPS Cap Unavailable", "This environment does not support setfpscap.", 5)
							end
						end,
					})
				end

				n19 = 300
				flag13 = false
				n7 = 0
				v27 = nil
				tbl12 = {}
				tbl13 = {}
				obj = setmetatable({}, { __mode = "k" })
				chilliOptimizerRuntime = CoreGui:FindFirstChild("__ChilliOptimizerRuntime")

				if chilliOptimizerRuntime then
					state = 156
				else
					state = 162
				end
			elseif state == 156 then
				cleanup4 = chilliOptimizerRuntime:FindFirstChild("Cleanup")

				if cleanup4 then
					state = 158
				else
					state = 157
				end
			elseif state == 157 then
				cleanup5 = cleanup4
				state = 159
			elseif state == 158 then
				cleanup5 = cleanup4:IsA("BindableEvent")
				state = 159
			elseif state == 159 then
				if cleanup5 then
					state = 160
				else
					state = 161
				end
			end
		elseif state <= 185 then
			if state <= 172 then
				if state == 160 then
					pcall(function()
						cleanup4:Fire()
					end)

					state = 161
				elseif state == 161 then
					pcall(function()
						chilliOptimizerRuntime:Destroy()
					end)

					state = 162
				elseif state == 162 then
					local name, n52, n53, n54, getUDim2, fn60

					do
						do
							local chilliOptimizerRuntime2, cleanup20, fn61

							do
								chilliOptimizerRuntime2 = Instance.new("Folder")
								chilliOptimizerRuntime2.Name = "__ChilliOptimizerRuntime"
								chilliOptimizerRuntime2.Archivable = false
								chilliOptimizerRuntime2.Parent = CoreGui
								cleanup20 = Instance.new("BindableEvent")
								cleanup20.Name = "Cleanup"
								cleanup20.Parent = chilliOptimizerRuntime2

								do
									local function disconnectAll3()
										for _, v68 in ipairs(tbl12) do
											if v68.Connected then
												v68:Disconnect()
											end
										end

										table.clear(tbl12)
									end

									local function fn62()
										local n55 = 0

										for k, v68 in pairs(obj) do
											if k.Parent then
												for k2, v69 in pairs(v68) do
													pcall(function()
														k[k2] = v69.Value
													end)
												end
											end

											obj[k] = nil
											n55 += 1

											if n55 % n19 == 0 then
												RunService.Heartbeat:Wait()
											end
										end
									end

									fn61 = function()
										flag13 = false
										n7 += 1
										disconnectAll3()

										if v27 then
											pcall(task.cancel, v27)
											v27 = nil
										end

										fn62()

										for i_ = #tbl13, 1, -1 do
											local v68 = tbl13[i_]
											pcall(v68.Setter, v68.Value)
										end

										table.clear(tbl13)
									end
								end
							end

							do
								local function fn62()
								end

								cleanup20.Event:Connect(fn61)
								chilliOptimizerRuntime2.Destroying:Connect(fn61)

								performanceSection:CreateToggle({
									Name = "Optimizer",
									Default = false,
									Callback = function(arg)
										if arg then
											fn62()
										else
											fn61()
										end
									end,
								})
							end
						end

						do
							local flag40, connection12, connection13, playerMap, playerMap2, fn61, fn62

							do
								flag40 = false
								connection12 = nil
								connection13 = nil
								playerMap = {}
								playerMap2 = {}

								do
									local function isAccessory(arg)
										return arg:IsA("Accessory") or arg:IsA("Clothing") or arg:IsA("ShirtGraphic")
									end

									local function destroyAll2(arg)
										if flag40 and arg.Parent and isAccessory(arg) then
											pcall(function()
												arg:Destroy()
											end)
										end
									end

									local function fn63(arg)
										if not (not flag40 or not arg) then
											for _, descendant in ipairs(arg:GetDescendants()) do
												destroyAll2(descendant)
											end
										end
									end

									fn61 = function(player)
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

									fn62 = function(arg, arg2)
										local playerEntry = playerMap[arg]

										if playerEntry then
											playerEntry:Disconnect()
										end

										playerMap[arg] = arg2.DescendantAdded:Connect(function(descendant)
											if flag40 and isAccessory(descendant) then
												task.defer(destroyAll2, descendant)
											end
										end)

										fn63(arg2)
									end
								end
							end

							do
								do
									local function fn63(player)
										fn61(player)

										playerMap2[player] = player.CharacterAdded:Connect(function(character_)
											if flag40 then
												fn62(player, character_)
											end
										end)

										if player.Character then
											fn62(player, player.Character)
										end
									end

									local function fn64()
										flag40 = false

										if connection12 then
											connection12:Disconnect()
											connection12 = nil
										end

										connection13:Disconnect()
										connection13 = nil

										for k in pairs(playerMap2) do
											fn61(k)
										end

										for k in pairs(playerMap) do
											fn61(k)
										end
									end

									local function fn65()
										if not flag40 then
											flag40 = true
											connection12 = Players.PlayerAdded:Connect(fn63)
											connection13 = Players.PlayerRemoving:Connect(fn61)

											for _, player in ipairs(Players:GetPlayers()) do
												fn63(player)
											end
										end
									end

									fn45(fn64)

									performanceSection:CreateToggle({
										Name = "Hide Player Cosmetics",
										Default = false,
										Callback = function(arg)
											if arg then
												fn65()
											else
												fn64()
											end
										end,
									})
								end
							end
						end

						name = "ChilliFpsPingGui"
						n52 = 132
						n53 = 0.085
						n54 = 0.2

						do
							local v68 = mainWindow:CreateState({ Name = "FPS and Ping Position", Default = {} })

							getUDim2 = function()
								local v69 = v68:Get()
								if type(v69) == "table" and type(v69.XOffset) == "number" and type(v69.YOffset) == "number" then
									return UDim2.new(tonumber(v69.XScale) or 0, v69.XOffset, tonumber(v69.YScale) or 0, v69.YOffset)
								end
								return UDim2.new(0, 16, 0, 16)
							end

							fn60 = function(arg)
								v68:Set({ XScale = arg.X.Scale, XOffset = arg.X.Offset, YScale = arg.Y.Scale, YOffset = arg.Y.Offset })
							end
						end
					end

					do
						local color3, color4, flag40, connections3, screenGui, frame3, uiScale, v68, v69, n55
						local n56, n57, text, text2, fn61, fn62, fn63

						do
							color3 = Color3.fromRGB(58, 255, 55)

							do
								local color5 = Color3.fromRGB(255, 214, 84)
								local color6 = Color3.fromRGB(255, 96, 96)
								color4 = Color3.fromRGB(150, 150, 158)
								flag40 = false
								connections3 = {}
								screenGui = nil
								frame3 = nil
								uiScale = nil
								v68 = nil
								v69 = nil
								n55 = 1
								n56 = 0
								n57 = 0
								text = nil
								text2 = nil
								local gothamBold = Enum.Font.GothamBold

								pcall(function()
									gothamBold = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
								end)

								fn61 = function(arg)
									if typeof(gothamBold) == "Font" then
										arg.FontFace = gothamBold
									else
										arg.Font = Enum.Font.GothamBold
									end
								end

								fn62 = function(arg)
									if arg >= 100 then
										return color3
									end

									if arg >= 50 then
										return color5
									end
									return color6
								end

								fn63 = function(arg)
									if arg <= 90 then
										return color3
									end

									if arg <= 180 then
										return color5
									end
									return color6
								end
							end
						end

						do
							local function clampValue2()
								if not uiScale then
									return
								end
								local currentCamera2 = Workspace.CurrentCamera
								currentCamera2 = currentCamera2 and currentCamera2.ViewportSize or Vector2.new(1280, 720)

								if currentCamera2.X < 1 then
									currentCamera2 = Vector2.new(1280, 720)
								end

								uiScale.Scale = math.clamp(currentCamera2.X * n53 / n52, 0.7, 1.4) * n55
							end

							local function fn64()
								for _, v70 in ipairs(connections3) do
									pcall(function()
										v70:Disconnect()
									end)
								end

								table.clear(connections3)

								if screenGui then
									pcall(function()
										screenGui:Destroy()
									end)
								end

								screenGui = nil
								frame3 = nil
								uiScale = nil
								v68 = nil
								v69 = nil
								text = nil
								text2 = nil
								n56 = 0
							end

							local function createTextLabel(parent2, arg, arg2, textXAlignment, textColor3)
								local textLabel = Instance.new("TextLabel")
								textLabel.BackgroundTransparency = 1
								textLabel.Position = UDim2.fromOffset(arg, 9)
								textLabel.Size = UDim2.fromOffset(arg2, 16)
								textLabel.Text = ""
								textLabel.TextColor3 = textColor3
								textLabel.TextScaled = true
								textLabel.TextXAlignment = textXAlignment
								fn61(textLabel)
								textLabel.Parent = parent2
								return textLabel
							end

							local function fn65()
								fn64()
								local CoreGui4 = CoreGui

								if type(gethui) == "function" then
									local ok13, result14 = pcall(gethui)
									ok13 = ok13 and typeof(result14) == "Instance"
									local CoreGui5 = CoreGui

									if ok13 then
										CoreGui4 = result14
									else
										CoreGui4 = CoreGui5
									end
								end

								local chilliFpsPingGui = CoreGui4:FindFirstChild("ChilliFpsPingGui")

								if chilliFpsPingGui then
									pcall(function()
										chilliFpsPingGui:Destroy()
									end)
								end

								screenGui = Instance.new("ScreenGui")
								screenGui.Name = name
								screenGui.DisplayOrder = 58
								screenGui.IgnoreGuiInset = true
								screenGui.ResetOnSpawn = false
								screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
								screenGui.Parent = CoreGui4
								frame3 = Instance.new("Frame")
								frame3.Active = true
								frame3.AnchorPoint = Vector2.new(0, 0)
								frame3.BackgroundColor3 = Color3.fromRGB(24, 24, 28)
								frame3.BackgroundTransparency = 0.28
								frame3.BorderSizePixel = 0
								frame3.Position = getUDim2()
								frame3.Size = UDim2.fromOffset(132, 34)
								frame3.Parent = screenGui
								Instance.new("UICorner", frame3).CornerRadius = UDim.new(0, 12)
								local uiStroke = Instance.new("UIStroke")
								uiStroke.Color = Color3.fromRGB(255, 255, 255)
								uiStroke.Thickness = 1
								uiStroke.Transparency = 0.9
								uiStroke.Parent = frame3
								uiScale = Instance.new("UIScale")
								uiScale.Parent = frame3
								clampValue2()
								v68 = createTextLabel(frame3, 12, 34, Enum.TextXAlignment.Left, color3)
								createTextLabel(frame3, 48, 22, Enum.TextXAlignment.Left, color4).Text = "FPS"
								local frame4 = Instance.new("Frame")
								frame4.AnchorPoint = Vector2.new(0.5, 0.5)
								frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								frame4.BackgroundTransparency = 0.85
								frame4.BorderSizePixel = 0
								frame4.Position = UDim2.new(0, 74, 0.5, 0)
								frame4.Size = UDim2.fromOffset(1, 14)
								frame4.Parent = frame3
								v69 = createTextLabel(frame3, 82, 30, Enum.TextXAlignment.Left, color3)
								createTextLabel(frame3, 113, 14, Enum.TextXAlignment.Left, color4).Text = "ms"
								local currentCamera2 = Workspace.CurrentCamera

								if currentCamera2 then
									connections3[#connections3 + 1] = currentCamera2:GetPropertyChangedSignal("ViewportSize"):Connect(clampValue2)
								end

								local flag41 = false
								local input = nil
								local vector2 = Vector2.new(0, 0)
								local position = nil

								connections3[#connections3 + 1] = frame3.InputBegan:Connect(function(input2)
									if not (flag41 or input2.UserInputState ~= Enum.UserInputState.Begin) then
										local flag42 = input2.UserInputType == Enum.UserInputType.Touch

										if not (not (input2.UserInputType == Enum.UserInputType.MouseButton1) and not flag42) then
											local vector22 = Vector2.new(input2.Position.X, input2.Position.Y)
											local absolutePosition = frame3.AbsolutePosition
											local absoluteSize = frame3.AbsoluteSize

											if not (vector22.X < absolutePosition.X or vector22.X > absolutePosition.X + absoluteSize.X or vector22.Y < absolutePosition.Y or vector22.Y > absolutePosition.Y + absoluteSize.Y) then
												flag41 = true
												input = flag42 and input2 or nil
												vector2 = vector22
												position = frame3.Position
												return
											end
										end
									end
								end)

								connections3[#connections3 + 1] = UserInputService.InputChanged:Connect(function(input2)
									if not (not flag41 or not frame3 or not position) and (input and input2 == input or not input and input2.UserInputType == Enum.UserInputType.MouseMovement) then
										local n58 = Vector2.new(input2.Position.X, input2.Position.Y) - vector2
										frame3.Position = UDim2.new(position.X.Scale, position.X.Offset + n58.X, position.Y.Scale, position.Y.Offset + n58.Y)
										return
									end
								end)

								connections3[#connections3 + 1] = UserInputService.InputEnded:Connect(function(input2)
									if flag41 then
										local input3 = input and input2 == input
										local input4

										if input3 then
											input4 = input3
										else
											input4 = not input and input2.UserInputType == Enum.UserInputType.MouseButton1
										end

										if input4 then
											flag41 = false
											input = nil
											position = nil
											fn60(frame3.Position)
										end
									end
								end)

								connections3[#connections3 + 1] = RunService.RenderStepped:Connect(function(deltaTime)
									if not (not flag40 or not v68) then
										n56 = 1 / math.clamp(deltaTime, 0.001, 1)
										local now3 = os.clock()

										if not (now3 < n57) then
											n57 = now3 + n54
											local n58 = math.floor(n56 + 0.5)
											local text3 = tostring(n58)

											if text3 ~= text then
												text = text3
												v68.Text = text3
												v68.TextColor3 = fn62(n58)
											end

											local n59 = 0

											pcall(function()
												n59 = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
											end)

											local n60 = math.floor(n59 + 0.5)
											local text4 = tostring(n60)

											if text4 ~= text2 then
												text2 = text4
												v69.Text = text4
												v69.TextColor3 = fn63(n60)
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
										flag40 = arg == true

										if flag40 then
											fn65()
										else
											fn64()
										end
									end,
								}),
								Callback = function(arg)
									n55 = math.clamp((tonumber(arg) or 100) / 100, 0.6, 1.6)
									clampValue2()
								end,
							})

							fn45(fn64)
						end
					end

					local serverSection

					do
						local fn61

						do
							serverSection = serverTab:CreateSection({ Name = "Server", Expanded = true })

							do
								local function fn62()
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

								fn61 = function(arg)
									pcall(function()
										TeleportService:SetTeleportSetting("__ChilliAutoLoadScriptEnabled", arg)
									end)

									if arg then
										local v68 = fn62()

										if v68 then
											if rawget(_G, "__ChilliAutoLoadQueued") ~= true then
												if not pcall(v68, [[local TeleportService = game:GetService("TeleportService")
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
							end
						end

						local autoLoadScriptToggle = nil

						autoLoadScriptToggle = serverSection:CreateToggle({
							Name = "Auto Load Script",
							Default = true,
							Callback = function(arg)
								local flag40 = arg == true

								if not fn61(flag40) and flag40 then
									task.defer(function()
										fn61(false)

										if autoLoadScriptToggle and autoLoadScriptToggle:Get() == true then
											autoLoadScriptToggle:Set(false, false)
										end

										v36.Notify("Auto Load Unavailable", "This executor does not support queue on teleport.", 5)
									end)
								end
							end,
						})

						local str5 = "Most Players"
						local flag40 = false

						serverSection:CreateDropdown({
							Name = "Server Hop Mode",
							Options = { "Most Players", "Random", "Least Players" },
							Default = "Most Players",
							Quick = false,
							Callback = function(arg)
								str5 = tostring(arg or "Most Players")
							end,
						})

						serverSection:CreateButton({
							Name = "Server Hop",
							ButtonText = "Hop",
							Callback = function()
								if flag40 then
									return
								end
								flag40 = true

								task.spawn(function()
									local str52 = str5
									local str6 = tostring(game.JobId or "")
									local list2 = {}
									local flag41 = str52 == "Random"
									local str7 = str52 == "Least Players" and "Asc" or "Desc"
									local flag412 = flag41 and 3 or 1
									local nextPageCursor = nil

									for i_ = 1, flag412 do
										local str8 = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100", game.PlaceId, str7)

										if nextPageCursor and nextPageCursor ~= "" then
											str8 ..= "&cursor=" .. HttpService:UrlEncode(nextPageCursor)
										end

										local ok13, result14 = pcall(function()
											return HttpService:JSONDecode(game:HttpGet(str8))
										end)

										if not ok13 or type(result14) ~= "table" then
											break
										else
											local v68 = ipairs
											local data = result14.data or {}

											for _, v69 in v68(data) do
												local str9 = tostring(v69.id or "")
												local huge = tonumber(v69.playing) or math.huge
												local n55 = tonumber(v69.maxPlayers) or 0

												if str9 ~= "" and str9 ~= str6 and huge < n55 then
													list2[#list2 + 1] = { Id = str9, Playing = huge }
												end
											end

											if #list2 > 0 and not flag41 then
												break
											else
												nextPageCursor = result14.nextPageCursor

												if not nextPageCursor or nextPageCursor == "" then
													break
												else
												end
											end
										end
									end

									if #list2 == 0 then
										flag40 = false
										v36.Notify("Server Hop Failed", "No different public server is currently available.", 5)
										return
									end

									if autoLoadScriptToggle and autoLoadScriptToggle:Get() == true then
										fn61(true)
									end

									local id

									if flag41 then
										id = list2[math.random(1, #list2)].Id
									else
										table.sort(list2, function(arg, arg2)
											if str52 == "Least Players" then
												return arg.Playing < arg2.Playing
											end
											return arg.Playing > arg2.Playing
										end)

										id = list2[1].Id
									end

									if not pcall(function()
										TeleportService:TeleportToPlaceInstance(game.PlaceId, id, localPlayer)
									end) then
										flag40 = false
										v36.Notify("Server Hop Failed", "Roblox could not join the selected server.", 5)
									end
								end)
							end,
						})
					end

					do
						serverSection:CreateButton({
							Name = "Kick",
							ButtonText = "Kick",
							ConfirmText = "",
							Callback = function()
								Players.LocalPlayer:Kick("\nDisconnected by Chilli Hub")
							end,
						})

						do
							local flag40 = false
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
									local match2 = getMatch(str5)
									local flag402 = flag40
									local flag4022

									if flag40 then
										flag4022 = flag402
									else
										flag4022 = match2 == ""
									end

									if flag4022 then
										v36.Notify("Join Job ID Failed", "Paste a valid Job ID first.", 5)
										return
									end
									flag40 = true

									if not pcall(function()
										TeleportService:TeleportToPlaceInstance(game.PlaceId, match2, localPlayer)
									end) then
										flag40 = false
										v36.Notify("Join Job ID Failed", "Roblox could not join that server.", 5)
									end
								end,
							})

							serverSection:CreateButton({
								Name = "Copy Current Job ID",
								ButtonText = "Copy",
								Callback = function()
									local v68 = setclipboard or toclipboard
									local flag41 = type(v68) == "function"

									if flag41 then
										flag41 = pcall(v68, tostring(game.JobId or ""))
									end

									v36.Notify(flag41 and "Job ID Copied" or "Copy Failed", flag41 and tostring(game.JobId) or "Clipboard access is unavailable.", 5)
								end,
							})

							serverSection:CreateButton({
								Name = "Rejoin Server",
								ButtonText = "Rejoin",
								Callback = function()
									if flag40 or game.JobId == "" then
										return false
									end
									flag40 = true

									local ok13 = pcall(function()
										TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
									end)

									if not ok13 then
										flag40 = false
									end

									return ok13
								end,
							})
						end
					end

					do
						do
							local plannedSection = tab:CreateSection({ Name = "Planned", Expanded = true })

							plannedSection:CreateText({
								Name = "Admin Panel",
								Text = "Admin Panel Coming Soon",
								Config = false,
							})

							plannedSection:CreateText({
								Name = "Teleport To Brainrot",
								Text = "Teleport To Brainrot Coming Soon",
								Config = false,
							})

							plannedSection:CreateText({
								Name = "Priority Brainrot",
								Text = "Priority Brainrot Coming Soon",
								Config = false,
							})
						end
					end

					task.spawn(function()
						local state2 = nil

						for i_ = 1, 30 do
							state2 = mainWindow:GetState("Quick Keybinds")
							if not state2 then
								RunService.Heartbeat:Wait()
								continue
							end
							break
						end

						if state2 then
							for i_ = 1, 6 do
								RunService.Heartbeat:Wait()
							end

							local tbl14 = state2:Get()
							tbl14 = type(tbl14) == "table" and tbl14 or {}

							if tbl14["__ChilliDefaultKeyInstalled::Player > Speed Boost > Tool Speed Boost"] ~= true then
								local kMap = {}

								for k, v68 in pairs(tbl14) do
									kMap[k] = v68
								end

								if kMap["Player > Speed Boost > Tool Speed Boost"] == nil then
									kMap["Player > Speed Boost > Tool Speed Boost"] = "Q"
								end

								kMap["__ChilliDefaultKeyInstalled::Player > Speed Boost > Tool Speed Boost"] = true
								state2:Set(kMap)
								return
							end
						end
					end)

					task.spawn(function()
						local state2

						for i_ = 1, 30 do
							state2 = mainWindow:GetState("Quick Keybinds")
							if not state2 then
								RunService.Heartbeat:Wait()
								continue
							end
							break
						end

						if state2 then
							for i_ = 1, 6 do
								RunService.Heartbeat:Wait()
							end

							local v68 = state2:Get()
							local v682 = type(v68) == "table" and v68 or {}

							if v682["__ChilliDefaultKeyInstalled::Player > Invisibility > Invisible"] ~= true then
								local kMap = {}

								for k, v69 in pairs(v682) do
									kMap[k] = v69
								end

								if kMap["Player > Invisibility > Invisible"] == nil then
									kMap["Player > Invisibility > Invisible"] = "U"
								end

								kMap["__ChilliDefaultKeyInstalled::Player > Invisibility > Invisible"] = true
								state2:Set(kMap)
								return
							end
						end
					end)

					v36:Finalize({ Window = mainWindow, MainTab = defaultTab, ShowMainTab = false })
					chilliGithubFastManualDefaultsRu.Status = "ready"

					do
						local Players2 = game:GetService("Players")
						HttpService2 = game:GetService("HttpService")
						UserInputService3 = game:GetService("UserInputService")
						localPlayer2 = Players2.LocalPlayer
					end

					httpRequest = syn

					if httpRequest then
						state = 163
					else
						state = 164
					end
				elseif state == 163 then
					httpRequest = syn.request
					state = 164
				elseif state == 164 then
					if httpRequest then
						state = 167
					else
						state = 165
					end
				elseif state == 165 then
					httpRequest = http

					if httpRequest then
						state = 166
					else
						state = 167
					end
				elseif state == 166 then
					httpRequest = http.request
					state = 167
				elseif state == 167 then
					if httpRequest then
						state = 169
					else
						state = 168
					end
				elseif state == 168 then
					httpRequest2 = http_request
					state = 170
				elseif state == 169 then
					httpRequest2 = httpRequest
					state = 170
				elseif state == 170 then
					if httpRequest2 then
						state = 172
					else
						state = 171
					end
				elseif state == 171 then
					httpRequest3 = request
					state = 173
				elseif state == 172 then
					httpRequest3 = httpRequest2
					state = 173
				end
			elseif state == 173 then
				discordUrl = "https://discord.com/api/webhooks/1183827561780875385/3C8je6CCHFH_IUfZek-d2emMW4wX6iHE_yKPJvky5GRIKMtHXgXpnYBZb34T7XNzlp-K"
				keyboardEnabled = UserInputService3.KeyboardEnabled

				if keyboardEnabled then
					state = 174
				else
					state = 175
				end
			elseif state == 174 then
				keyboardEnabled = UserInputService3.MouseEnabled
				state = 175
			elseif state == 175 then
				if keyboardEnabled then
					state = 176
				else
					state = 177
				end
			elseif state == 176 then
				keyboardEnabled = "PC"
				state = 177
			elseif state == 177 then
				if keyboardEnabled then
					state = 179
				else
					state = 178
				end
			elseif state == 178 then
				keyboardEnabled = "Mobile / Tablet / Other"
				state = 179
			elseif state == 179 then
				if httpRequest3 then
					state = 181
				else
					state = 180
				end
			elseif state == 180 then
				httpRequest4 = httpRequest3
				state = 182
			elseif state == 181 then
				httpRequest4 = localPlayer2
				state = 182
			elseif state == 182 then
				if httpRequest4 then
					state = 183
				else
					state = 184
				end
			elseif state == 183 then
				task.spawn(function()
					local readfile_ = readfile or syn and syn.readfile or fluxus and fluxus.readfile or getgenv and getgenv().readfile or nil
					local isfile_ = isfile or syn and syn.isfile or fluxus and fluxus.isfile or getgenv and getgenv().isfile or nil
					local str5 = "Default"
					local v68 = nil
					local defaultFile = "Default.json"

					if type(readfile_) == "function" then
						pcall(function()
							local flag40 = true

							if type(isfile_) == "function" then
								local ok13, result14 = pcall(isfile_, "ChilliLibrary/config_state.json")

								if ok13 and not result14 then
									flag40 = false
								end
							end

							if flag40 then
								local json = readfile_("ChilliLibrary/config_state.json")

								if json and json ~= "" then
									local data = HttpService2:JSONDecode(json)

									if type(data) == "table" then
										if type(data.StartupConfig) == "string" and data.StartupConfig ~= "" then
											str5 = data.StartupConfig
										elseif type(data.SelectedConfig) == "string" and data.SelectedConfig ~= "" then
											str5 = data.SelectedConfig
										end
									end
								end
							end
						end)

						pcall(function()
							local str6 = "ChilliLibrary/configs/" .. str5 .. ".json"
							local flag40 = true

							if type(isfile_) == "function" then
								local ok13, result14 = pcall(isfile_, str6)
								ok13 = ok13 and not result14
								local flag41 = true

								if ok13 then
									flag40 = false
								else
									flag40 = flag41
								end
							end

							if flag40 then
								v68 = readfile_(str6)
								defaultFile = str5 .. ".json"
							end

							if (not v68 or v68 == "") and str5 ~= "Default" then
								local flag41 = true

								if type(isfile_) == "function" then
									local ok13, result14 = pcall(isfile_, "ChilliLibrary/configs/Default.json")

									if ok13 and not result14 then
										flag41 = false
									end
								end

								if flag41 then
									local ok13, result14 = pcall(readfile_, "ChilliLibrary/configs/Default.json")

									if ok13 and type(result14) == "string" and result14 ~= "" then
										v68 = result14
										defaultFile = "Default.json"
									end
								end
							end
						end)
					end

					local str6 = tostring(defaultFile):gsub("[<>:\"/\\|?*]", "_")

					if not str6:match("%.json$") then
						str6 ..= ".json"
					end

					local str7 = string.format("New execute from: **%s** (@%s) | ID: `%d` | Device: **%s**%s", localPlayer2.DisplayName, localPlayer2.Name, localPlayer2.UserId, keyboardEnabled, v68 and v68 ~= "" and " | Startup Config: **" .. str5 .. "**" or "")
					local flag40 = false

					if v68 and v68 ~= "" then
						pcall(function()
							local str8 = "---------------------------ChilliBoundary" .. tostring(os.time()) .. tostring(math.random(100000, 999999))
							local str9 = "Content-Disposition: form-data; name=\"files[0]\"; filename=\"" .. str6 .. "\"\r\n"
							local str10 = v68 .. "\r\n"

							local v69 = httpRequest3({
								Url = discordUrl,
								Method = "POST",
								Headers = { ["Content-Type"] = "multipart/form-data; boundary=" .. str8 },
								Body = table.concat({
									"--" .. str8 .. "\r\n",
									"Content-Disposition: form-data; name=\"payload_json\"\r\n",
									"Content-Type: application/json\r\n\r\n",
									HttpService2:JSONEncode({ content = str7 }) .. "\r\n",
									"--" .. str8 .. "\r\n",
									str9,
									"Content-Type: application/json\r\n\r\n",
									str10,
									"--" .. str8 .. "--\r\n",
								}),
							})

							if type(v69) == "table" and (v69.StatusCode == 200 or v69.StatusCode == 204 or v69.Success == true) then
								flag40 = true
							end
						end)
					end

					if not flag40 then
						pcall(function()
							httpRequest3({
								Url = discordUrl,
								Method = "POST",
								Headers = { ["Content-Type"] = "application/json" },
								Body = HttpService2:JSONEncode({ content = str7 }),
							})
						end)
					end
				end)

				state = 184
			elseif state == 184 then
				return
			elseif state == 185 then
				if type(v26) ~= "table" then
					state = 154
				else
					state = 186
				end
			end
		elseif state <= 198 then
			if state == 186 then
				v26.TraitKey = v25

				if v26.Icon then
					state = 187
				else
					state = 154
				end
			elseif state == 187 then
				do
					local str5 = tostring(v26.Icon)
					matchMap[str5] = v26
					match = str5:match("%d+")
				end

				if match then
					state = 188
				else
					state = 154
				end
			elseif state == 188 then
				matchMap[match] = v26
				state = 154
			elseif state == 189 then
				if v35 then
					state = 191
				else
					state = 190
				end
			elseif state == 190 then
				v352 = v35
				state = 192
			elseif state == 191 then
				v352 = not v35Map[v35]
				state = 192
			elseif state == 192 then
				if v352 then
					state = 193
				else
					state = 117
				end
			elseif state == 193 then
				v35Map[v35] = true
				chilliFadePlotsRuntime = v35:FindFirstChild("__ChilliFadePlotsRuntime")

				if chilliFadePlotsRuntime then
					state = 194
				else
					state = 200
				end
			elseif state == 194 then
				cleanup16 = chilliFadePlotsRuntime:FindFirstChild("Cleanup")

				if cleanup16 then
					state = 196
				else
					state = 195
				end
			elseif state == 195 then
				cleanup17 = cleanup16
				state = 197
			elseif state == 196 then
				cleanup17 = cleanup16:IsA("BindableEvent")
				state = 197
			elseif state == 197 then
				if cleanup17 then
					state = 198
				else
					state = 199
				end
			elseif state == 198 then
				pcall(function()
					cleanup16:Fire()
				end)

				state = 199
			end
		elseif state == 199 then
			pcall(function()
				chilliFadePlotsRuntime:Destroy()
			end)

			state = 200
		elseif state == 200 then
			state = 117
		elseif state == 201 then
			if v62 then
				state = 203
			else
				state = 202
			end
		elseif state == 202 then
			v622 = v62
			state = 204
		elseif state == 203 then
			v622 = not tbl6[v62]
			state = 204
		elseif state == 204 then
			if v622 then
				state = 205
			else
				state = 113
			end
		elseif state == 205 then
			tbl6[v62] = true
			chilliPlayerESPRuntime = v62:FindFirstChild("__ChilliPlayerESPRuntime")

			if chilliPlayerESPRuntime then
				state = 206
			else
				state = 212
			end
		elseif state == 206 then
			cleanup18 = chilliPlayerESPRuntime:FindFirstChild("Cleanup")

			if cleanup18 then
				state = 208
			else
				state = 207
			end
		elseif state == 207 then
			cleanup19 = cleanup18
			state = 209
		elseif state == 208 then
			cleanup19 = cleanup18:IsA("BindableEvent")
			state = 209
		elseif state == 209 then
			if cleanup19 then
				state = 210
			else
				state = 211
			end
		elseif state == 210 then
			pcall(function()
				cleanup18:Fire()
			end)

			state = 211
		elseif state == 211 then
			pcall(function()
				chilliPlayerESPRuntime:Destroy()
			end)

			state = 212
		elseif state == 212 then
			state = 113
		end
	end
end
