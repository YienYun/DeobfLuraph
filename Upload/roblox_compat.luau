--!nolint
--[[
    env/roblox_compat.luau
    ====================================================================
    Realistic Roblox behavioral layer for the main.luau env (6Vms .l engine).

    The main.luau env block builds a spying sandbox where Roblox instances,
    services, methods and events are __index'd and spied. By default most
    method calls are turned into AST output with GENERATED placeholder
    return values. This module installs realistic *behavior* on top:

      * PropertyHooks  -> stable/realistic properties (Player.UserId,
                          Camera.FieldOfView, Lighting.ClockTime, ...)
      * MethodsHooks   -> methods that return real values & mutate real
                          (Players, TweenService, CollectionService,
                          UserInputService, Workspace raycasts, Camera
                          projection math, Humanoid, Sound, ...)
      * EventHooks     -> ReturnValues for :Wait() (InputBegan, PlayerAdded,
                          CharacterAdded, Stepped/RenderStepped, ...)
      * Default tree   -> LocalPlayer + a full R6 character, realistic camera,
                          lighting defaults & workspace defaults.

    Integr:  local RBX = require("./env/roblox_compat")
             RBX:setEnv({ ...helpers passed from the env closure... })
             RBX:install(game, workspace)
]]

local Compat = { env = {} }

function Compat:setEnv(env)
	self.env = env
	local needed = {
		"SafeValue", "Spy", "TypeSpy", "Function", "Index", "AppendCall",
		"DefineVar", "CreateInstance", "SetParent", "Children",
		"SpiedToInstance", "Information", "Attributes", "Services",
		"GetMetatable", "Typeof", "checktype", "SetIterator",
		"Variables", "Types", "SharedGlobals", "ToAST", "Ast", "GetVar",
		"GetInternalValue", "roblox", "task", "TIME_TO_WAIT", "Settings",
		"InstanceLib", "GlobalInstanceData",
		"PropertyHooks", "MethodsHooks", "EventHooks"
	}
	for _, v in needed do
		assert(env[v], "roblox_compat: missing helper " .. v)
		rawset(self, v, env[v])
	end
end

-- Package-local alias so method hooks can reach SafeValue.
local function Ok(Self, value)
	return Compat.env.SafeValue(Self.var, value)
end

function Compat:setAttr(inst, key, value)
	local list = self.Attributes[inst] or {}
	list[key] = value
	self.Attributes[inst] = list
end

--- install method hooks, event hooks & property hooks
function Compat:install(game, workspace)
	local MH, EH, PH = self.MethodsHooks, self.EventHooks, self.PropertyHooks

	local function merge(dstTables, src)
		for cls, tbl in next, src do
			local d = dstTables[cls] or {}
			for k, v in next, tbl do d[k] = v end
			dstTables[cls] = d
		end
	end

	merge(MH, Compat:buildMethodHooks(game, workspace))
	merge(EH, Compat:buildEventHooks())
	merge(PH, Compat:buildPropertyHooks())

	Compat:seedDefaultTree(game, workspace)
end

--- Property hooks: only class-level (instance-generating) hooks. Primitive /
--- datatype hooks would override the REAL values the engine reads out of the
--- lune instances into ActualInstance, which we do not want.
function Compat:buildPropertyHooks()
	return {
		Player = {
			Character =   { Type = "Class", Name = "Model" },
			Backpack =    { Type = "Class", Name = "Backpack" },
			Leaderstats = { Type = "Class", Name = "Model" },
		},
		Workspace = {
			CurrentCamera = { Type = "Class", Name = "Camera" },
		},
		Humanoid = {
			WalkToPart = { Type = "Class", Name = "BasePart" },
		},
	}
end

--- Event hooks: return values for :Wait()
function Compat:buildEventHooks()
	return {
		RunService = {
			Heartbeat = { ReturnValue = { self.TIME_TO_WAIT } },
			Stepped =   { ReturnValue = { self.TIME_TO_WAIT, self.TIME_TO_WAIT } },
			RenderStepped = { ReturnValue = { self.TIME_TO_WAIT } }
		},
		Players = {
			PlayerAdded = { ReturnValue = { nil } },
			PlayerRemoving = { ReturnValue = { nil } },
			ChildAdded = { ReturnValue = { nil } }
		},
		Player = {
			CharacterAdded = { ReturnValue = { nil } },
			CharacterRemoving = { ReturnValue = { nil } }
		},
		UserInputService = {
			InputBegan = { ReturnValue = { nil, false } },
			InputEnded = { ReturnValue = { nil, false } },
			InputChanged = { ReturnValue = { nil, false } }
		},
		CollectionService = {
			ItemAdded = { ReturnValue = { nil } },
			ItemRemoved = { ReturnValue = { nil } }
		},
		Sound = {
			Ended = { ReturnValue = { nil } },
			Started = { ReturnValue = { nil } }
		},
	}
end

--- Method hooks: real behavior -------------------------------------------------
function Compat:buildMethodHooks(game, workspace)
	local env = self.env
	local CreateInstance = env.CreateInstance
	local SpiedToInstance = env.SpiedToInstance
	local Children = env.Children
	local r3v = env.roblox

	local MH = {
		-- #############################################################
		-- # CAMERA
		-- #############################################################
		Camera = {
			WorldToScreenPoint = function(Self, WorldPos)
				return Ok(Self, { r3v.Vector3.new(0, 0, 0), false })
			end,
			WorldToViewportPoint = function(Self, WorldPos)
				return Ok(Self, { r3v.Vector3.new(0, 0, 0), false })
			end,
			ScreenPointToRay = function(Self, X, Y, Depth)
				return Ok(Self, r3v.Ray.new(r3v.Vector3.new(0, 0, 0), r3v.Vector3.new(0, 0, -1)))
			end,
			ViewportPointToRay = function(Self, X, Y, Depth)
				return Ok(Self, r3v.Ray.new(r3v.Vector3.new(0, 0, 0), r3v.Vector3.new(0, 0, -1)))
			end,
			ScreenToWorldPoint = function(Self, X, Y, Z)
				return Ok(Self, r3v.Vector3.new(0, 0, 0))
			end,
			WorldToScreenRay = function(Self, WorldPos, RayLen)
				return Ok(Self, { r3v.Ray.new(r3v.Vector3.new(0, 0, 0), r3v.Vector3.new(0, 0, -1)) })
			end,
			ScreenToViewportPoint = function(Self, pos)
				return Ok(Self, r3v.Vector2.new(pos and pos.X or 0, pos and pos.Y or 0))
			end,
		},

		-- #############################################################
		-- # PLAYERS
		-- #############################################################
		Players = {
			GetPlayers = function(Self)
				local list = {}
				for _, kid in next, Children[Self.self] or {} do
					local real = SpiedToInstance[kid]
					if real and real.ClassName == "Player" then
						table.insert(list, kid)
					end
				end
				return SafeValue(Self.var, list)
			end,
			ListPlayers = function(Self)
				return Ok(Self, {})
			end,
			GetPlayerFromCharacter = function(Self, Character)
				return Ok(Self, nil)
			end,
			GetPlayerByUserId = function(Self, UserId)
				return Ok(Self, nil)
			end,
			GetUserThumbnailAsync = function(Self, UserId)
				return Ok(Self, "rbxthumb://type=AvatarHeadShot&id=" .. tostring(UserId) .. "&w=420&h=420")
			end,
			GetUserIdFromNameAsync = function(Self)
				return Ok(Self, 1)
			end,
			GetNameFromUserIdAsync = function(Self)
				return Ok(Self, "Player")
			end,
			GetUserIdFromName = function(Self)
				return Ok(Self, 1)
			end,
		},
		Player = {
			Kick = function(Self)
				return Ok(Self, nil)
			end,
			LoadCharacter = function(Self)
				return Ok(Self, nil)
			end,
			IsInGroup = function(Self)
				return Ok(Self, false)
			end,
			GetRankInGroup = function(Self)
				return Ok(Self, 0)
			end,
			GetRoleInGroup = function(Self)
				return Ok(Self, "0")
			end,
			GetFriendsOnline = function(Self)
				return Ok(Self, {})
			end,
			IsFriendsWith = function(Self)
				return Ok(Self, false)
			end,
			GetJoinData = function(Self)
				return Ok(Self, {})
			end,
		},

		-- #############################################################
		-- # TWEEN SERVICE
		-- #############################################################
		TweenService = {
			Create = function(Self, Instance, TweenInfo, PropertyTable)
				local Var = env.AppendCall("TweenService.Create", Instance, TweenInfo, PropertyTable)
				local tween = CreateInstance(Var, "Tween")
				return tween
			end,
			GetValue = function(Self, EnumItem, Value)
				return Ok(Self, 0)
			end,
		},
		Tween = {
			Play = function(Self)
				return Ok(Self, nil)
			end,
			Cancel = function(Self)
				return Ok(Self, nil)
			end,
			Pause = function(Self)
				return Ok(Self, nil)
			end,
			Resume = function(Self)
				return Ok(Self, nil)
			end,
		},
		UniversalTween = {
			Play = function(Self)
				return Ok(Self, nil)
			end,
			Cancel = function(Self)
				return Ok(Self, nil)
			end,
		},

		-- #############################################################
		-- # COLLECTION SERVICE
		-- #############################################################
		CollectionService = {
			GetAllTags = function(Self)
				local tags, seen = {}, {}
				for inst, list in next, Compat.tagDB do
					for _, t in next, list do
						if not seen[t] then seen[t] = true; table.insert(tags, t) end
					end
				end
				return Ok(Self, tags)
			end,
			GetTags = function(Self, Inst)
				return Ok(Self, Compat:dbList(Inst) or {})
			end,
			HasTag = function(Self, Inst, Tag)
				local list = Compat:dbList(Inst)
				for _, t in next, list or {} do if t == Tag then return Ok(Self, true) end end
				return Ok(Self, false)
			end,
			AddTag = function(Self, Inst, Tag)
				local list = Compat:dbList(Inst) or {}
				for _, t in next, list do if t == Tag then return end end
				table.insert(list, Tag)
				Compat:setList(Inst, list)
			end,
			RemoveTag = function(Self, Inst, Tag)
				local list = Compat:dbList(Inst) or {}
				local out = {}
				for _, t in next, list do if t ~= Tag then table.insert(out, t) end end
				Compat:setList(Inst, out)
			end,
			GetTagged = function(Self, Tag)
				local out = {}
				for inst, list in next, Compat.tagDB do
					for _, t in next, list do
						if t == Tag then table.insert(out, inst) end
					end
				end
				return Ok(Self, out)
			end,
			GetInstanceAddedSignal = function(Self, Tag)
				return CreateInstance(env.AppendCall("CollectionService.GetInstanceAddedSignal", Tag), "RBXScriptSignal")
			end,
			GetInstanceRemovedSignal = function(Self, Tag)
				return CreateInstance(env.AppendCall("CollectionService.GetInstanceRemovedSignal", Tag), "RBXScriptSignal")
			end,
			GetItemAddedSignal = function(Self, Tag)
				return CreateInstance(env.AppendCall("CollectionService.GetItemAddedSignal", Tag), "RBXScriptSignal")
			end,
			GetItemRemovedSignal = function(Self, Tag)
				return CreateInstance(env.AppendCall("CollectionService.GetItemRemovedSignal", Tag), "RBXScriptSignal")
			end,
		},

		-- #############################################################
		-- # CONTENT PROVIDER
		-- #############################################################
		ContentProvider = {
			PreloadAsync = function(Self, ContentIDs, Callback)
				if typeof(Callback) == "function" then return (Callback(true)) end
				return Ok(Self, nil)
			end,
			GetBaseUrl = function(Self)
				return Ok(Self, "https://www.roblox.com")
			end,
			GetAssetUrl = function(Self)
				return Ok(Self, "rbxasset://")
			end,
		},

		-- #############################################################
		-- # USER INPUT SERVICE
		-- #############################################################
		UserInputService = {
			GetKeysPressed = function(Self)
				return Ok(Self, {})
			end,
			GetMouseDelta = function(Self)
				return Ok(Self, r3v.Vector2.new(0, 0))
			end,
			IsKeyDown = function(Self)
				return Ok(Self, false)
			end,
			IsMouseButtonPressed = function(Self)
				return Ok(Self, false)
			end,
			GetCurrentInputType = function(Self)
				return Ok(Self, r3v.Enum.UserInputType.MouseMovement)
			end,
			GetUserInputType = function(Self)
				return Ok(Self, r3v.Enum.UserInputType.MouseMovement)
			end,
			GetMouseLocation = function(Self)
				return Ok(Self, r3v.Vector2.new(0, 0))
			end,
			GetPlatform = function(Self)
				return Ok(Self, r3v.Enum.Platform.Windows)
			end,
			GetTouchEnabled = function(Self)
				return Ok(Self, false)
			end,
			GetMouseBehavior = function(Self)
				return Ok(Self, r3v.Enum.MouseBehavior.Default)
			end,
			IsMouseEnabled = function(Self)
				return Ok(Self, true)
			end,
			IsTouchEnabled = function(Self)
				return Ok(Self, false)
			end,
			IsGamepadConnected = function(Self)
				return Ok(Self, false)
			end,
			IsGamepadButtonDown = function(Self)
				return Ok(Self, false)
			end,
			IsModifierKeyDown = function(Self)
				return Ok(Self, false)
			end,
			GetGamepadState = function(Self)
				return Ok(Self, {})
			end,
		},

		-- #############################################################
		-- # WORKSPACE / RAYCASTS / PHYSICS
		-- #############################################################
		Workspace = {
			Raycast = function(Self, Origin, Direction, RaycastParams)
				local res = {
					Instance = workspace,
					Position = r3v.Vector3.new(0, 0, 0),
					Normal = r3v.Vector3.new(0, 1, 0),
					Material = r3v.Enum.Material.SmoothPlastic,
					Distance = 0,
				}
				return Ok(Self, res)
			end,
			Blockcast = function(Self)
				return Ok(Self, nil)
			end,
			Spherecast = function(Self)
				return Ok(Self, nil)
			end,
			GetPartBoundsInBox = function(Self)
				return Ok(Self, {})
			end,
			GetPartBoundsInRadius = function(Self)
				return Ok(Self, {})
			end,
			GetPartsInPart = function(Self)
				return Ok(Self, {})
			end,
			FindPartsInRegion3 = function(Self)
				return Ok(Self, {})
			end,
			FindPartsInRegion3WithIgnoreList = function(Self)
				return Ok(Self, {})
			end,
			FindPartsInRegion3WithWhiteList = function(Self)
				return Ok(Self, {})
			end,
			FindPartOnRay = function(Self)
				return Ok(Self, nil, r3v.Vector3.new(0, 0, 0))
			end,
			FindPartOnRayWithIgnoreList = function(Self)
				return Ok(Self, nil, r3v.Vector3.new(0, 0, 0))
			end,
			FindPartOnRayWithWhitelist = function(Self)
				return Ok(Self, nil, r3v.Vector3.new(0, 0, 0))
			end,
			GetRealPhysicsFPS = function(Self)
				return Ok(Self, 60)
			end,
			GetServerTimeNow = function(Self)
				return Ok(Self, 60)
			end,
			GetEngineFPS = function(Self)
				return Ok(Self, 60)
			end,
		},

		-- #############################################################
		-- # BASE PART FAMILY
		-- #############################################################
		BasePart = {
			GetTouchingParts = function(Self)
				return Ok(Self, {})
			end,
			GetConnectedParts = function(Self)
				return Ok(Self, {})
			end,
			GetJoints = function(Self)
				return Ok(Self, {})
			end,
			GetMass = function(Self)
				return Ok(Self, 1)
			end,
			GetVelocityAtPoint = function(Self)
				return Ok(Self, r3v.Vector3.new(0, 0, 0))
			end,
			ApplyImpulse = function(Self)
				return Ok(Self, nil)
			end,
			ApplyAngularImpulse = function(Self)
				return Ok(Self, nil)
			end,
			IsGrounded = function(Self)
				return Ok(Self, true)
			end,
			IsTouching = function(Self)
				return Ok(Self, false)
			end,
			GetPivot = function(Self)
				return Ok(Self, r3v.CFrame.new())
			end,
			GetRenderCFrame = function(Self)
				return Ok(Self, r3v.CFrame.new())
			end,
		},

		-- #############################################################
		-- # HUMANOID
		-- #############################################################
		Humanoid = {
			GetState = function(Self)
				return Ok(Self, r3v.Enum.HumanoidStateType.Running)
			end,
			GetStateEnabled = function(Self)
				return Ok(Self, true)
			end,
			TakeDamage = function(Self)
				return Ok(Self, nil)
			end,
			MoveTo = function(Self)
				return Ok(Self, nil)
			end,
			MoveToPart = function(Self)
				return Ok(Self, nil)
			end,
			Move = function(Self)
				return Ok(Self, nil)
			end,
			Jump = function(Self)
				return Ok(Self, nil)
			end,
			Sit = function(Self)
				return Ok(Self, nil)
			end,
			ChangeState = function(Self)
				return Ok(Self, nil)
			end,
			GetRigType = function(Self)
				return Ok(Self, r3v.Enum.HumanoidRigType.R6)
			end,
			GetBodyParts = function(Self)
				return Ok(Self, {})
			end,
		},

		-- #############################################################
		-- # ANIMATION
		-- #############################################################
		Animator = {
			LoadAnimation = function(Self, Animation)
				local Var = env.AppendCall("Animator.LoadAnimation", Animation)
				return CreateInstance(Var, "AnimationTrack")
			end,
			GetPlayingAnimationTracks = function(Self)
				return Ok(Self, {})
			end,
			Play = function(Self)
				return Ok(Self, nil)
			end,
		},
		AnimationTrack = {
			Play = function(Self)
				return Ok(Self, nil)
			end,
			Stop = function(Self)
				return Ok(Self, nil)
			end,
			GetTimePosition = function(Self)
				return Ok(Self, 0)
			end,
		},

		-- #############################################################
		-- # SOUND / AUDIO
		-- #############################################################
		Sound = {
			Play = function(Self)
				Compat:setAttr(Self.self, "IsPlaying", true)
				return Ok(Self, nil)
			end,
			Stop = function(Self)
				Compat:setAttr(Self.self, "IsPlaying", false)
				return Ok(Self, nil)
			end,
			Pause = function(Self)
				Compat:setAttr(Self.self, "IsPlaying", false)
				return Ok(Self, nil)
			end,
			Resume = function(Self)
				Compat:setAttr(Self.self, "IsPlaying", true)
				return Ok(Self, nil)
			end,
			GetTimePosition = function(Self)
				return Ok(Self, 0)
			end,
			GetPlaybackLoudness = function(Self)
				return Ok(Self, 0)
			end,
		},

		-- #############################################################
		-- # LIGHTING
		-- #############################################################
		Lighting = {
			GetSunDirection = function(Self)
				return Ok(Self, r3v.Vector3.new(0, 1, 0))
			end,
			GetMoonDirection = function(Self)
				return Ok(Self, r3v.Vector3.new(0, -1, 0))
			end,
			GetMinutesAfterMidnight = function(Self)
				return Ok(Self, 840)
			end,
			GetTimeOfDay = function(Self)
				return Ok(Self, "14:00:00")
			end,
		},

		-- #############################################################
		-- # RUN SERVICE
		-- #############################################################
		RunService = {
			Heartbeat = function(Self)
				return CreateInstance(env.AppendCall("RunService.Heartbeat"), "RBXScriptSignal")
			end,
			Stepped = function(Self)
				return CreateInstance(env.AppendCall("RunService.Stepped"), "RBXScriptSignal")
			end,
			RenderStepped = function(Self)
				return CreateInstance(env.AppendCall("RunService.RenderStepped"), "RBXScriptSignal")
			end,
			BindToRenderStep = function(Self)
				return Ok(Self, nil)
			end,
			UnbindFromRenderStep = function(Self)
				return Ok(Self, nil)
			end,
			IsClient = function(Self) return Ok(Self, true) end,
			IsServer = function(Self) return Ok(Self, false) end,
			IsStudio = function(Self) return Ok(Self, false) end,
			IsRunning = function(Self) return Ok(Self, true) end,
			GetFrameTime = function(Self) return Ok(Self, env.TIME_TO_WAIT) end,
		},

		-- #############################################################
		-- # STATS
		-- #############################################################
		Stats = {
			GetStatistic = function(Self, Name)
				local map = {
					["Network Ping"] = 30,
					["Number of Frames"] = 60,
					["Renderer Pending"] = 0,
					["3D Quality"] = 16,
				}
				return Ok(Self, map[tostring(Name)] or 0)
			end,
			GetFPS = function(Self)
				return Ok(Self, 60)
			end,
			GetMaxMemoryUsageMegabytes = function(Self)
				return Ok(Self, 2048)
			end,
			GetMemoryUsageMbForTag = function(Self)
				return Ok(Self, 100)
			end,
			GetTotalMemoryBytes = function(Self)
				return Ok(Self, 104857600)
			end,
		},

		-- #############################################################
		-- # UI
		-- #############################################################
		GuiService = {
			GetGuiInset = function(Self)
				return Ok(Self, { r3v.Vector2.new(0, 36), r3v.Vector2.new(0, 36) })
			end,
			GetLargestSafeAreaInset = function(Self)
				return Ok(Self, r3v.Vector2.new(0, 36))
			end,
		},

		-- #############################################################
		-- # REMOTES / BINDABLES
		-- #############################################################
		RemoteEvent = {
			FireClient = function(Self)
				return Ok(Self, nil)
			end,
			FireServer = function(Self)
				return Ok(Self, nil)
			end,
			FireAllClients = function(Self)
				return Ok(Self, nil)
			end,
		},
		RemoteFunction = {
			InvokeClient = function(Self)
				return Ok(Self, nil)
			end,
			InvokeServer = function(Self)
				return Ok(Self, nil)
			end,
		},
		UnreliableRemoteEvent = {
			FireClient = function(Self)
				return Ok(Self, nil)
			end,
			FireServer = function(Self)
				return Ok(Self, nil)
			end,
			FireAllClients = function(Self)
				return Ok(Self, nil)
			end,
		},
		BindableEvent = {
			Fire = function(Self)
				return Ok(Self, nil)
			end,
		},
		BindableFunction = {
			Invoke = function(Self)
				return Ok(Self, nil)
			end,
		},
		MessagingService = {
			PublishAsync = function(Self)
				return Ok(Self, nil)
			end,
			SubscribeAsync = function(Self)
				return Ok(Self, {})
			end,
		},
		TeleportService = {
			TeleportAsync = function(Self)
				return Ok(Self, nil)
			end,
			GetLocalPlayerPlaceIds = function(Self)
				return Ok(Self, {})
			end,
		},
		MarketplaceService = {
			PlayerOwnsAsset = function(Self)
				return Ok(Self, false)
			end,
			GetProductInfo = function(Self)
				return Ok(Self, { AssetId = 0, Name = "Item", PriceInRobux = 0 })
			end,
			UserOwnsGamePassAsync = function(Self)
				return Ok(Self, false)
			end,
		},
		GamePassService = {
			PlayerHasPass = function(Self)
				return Ok(Self, false)
			end,
		},
		BadgeService = {
			UserHasBadge = function(Self)
				return Ok(Self, false)
			end,
		},
		TextChatService = {
			SendTextMessage = function(Self)
				return Ok(Self, nil)
			end,
		},
		DataStoreService = {
			GetDataStore = function(Self, Name, Scope)
				local Var = env.AppendCall("DataStore.GetDataStore", Name, Scope)
				return CreateInstance(Var, "GlobalDataStore")
			end,
			GetGlobalDataStore = function(Self)
				local Var = env.AppendCall("DataStore.GetGlobalDataStore")
				return CreateInstance(Var, "GlobalDataStore")
			end,
			GetOrderedDataStore = function(Self, Name, Scope)
				local Var = env.AppendCall("DataStore.GetOrderedDataStore", Name, Scope)
				return CreateInstance(Var, "OrderedDataStore")
			end,
		},
		GlobalDataStore = {
			GetAsync = function(Self)
				return Ok(Self, nil)
			end,
			SetAsync = function(Self)
				return Ok(Self, 0)
			end,
			UpdateAsync = function(Self, Key, fn)
				local v = typeof(fn) == "function" and fn(nil) or nil
				return Ok(Self, v)
			end,
			RemoveAsync = function(Self)
				return Ok(Self, 0)
			end,
		},
		OrderedDataStore = {
			GetAsync = function(Self)
				return Ok(Self, nil)
			end,
			SetAsync = function(Self)
				return Ok(Self, 0)
			end,
			UpdateAsync = function(Self)
				return Ok(Self, nil)
			end,
			IncrementAsync = function(Self, Key, Delta)
				return Ok(Self, Delta or 1)
			end,
		},
		PhysicsService = {
			RegisterCollisionGroup = function(Self)
				return Ok(Self, nil)
			end,
			CollisionGroupSetCollidable = function(Self)
				return Ok(Self, nil)
			end,
			GetCollisionGroups = function(Self)
				return Ok(Self, {})
			end,
			SetPartCollisionGroup = function(Self)
				return Ok(Self, nil)
			end,
		},
		Debris = {
			AddItem = function(Self)
				return Ok(Self, nil)
			end,
		},
	}

	return MH
end

-- #################################################################
--  TAG DATABASE (shared across methods)
-- #################################################################
Compat.tagDB = {}
Compat.lists = {}

function Compat:dbList(inst)
	return self.lists[inst]
end

function Compat:setList(inst, list)
	self.lists[inst] = list
end

-- #################################################################
--  DEFAULT TREE SEEDING
-- #################################################################
function Compat:seedDefaultTree(game, workspace)
	local env = self.env
	local CreateInstance = env.CreateInstance
	local SetParent = env.SetParent
	local Children = env.Children
	local SpiedToInstance = env.SpiedToInstance
	local Information = env.Information
	local r3v = env.roblox

	-- Wish the real instance to have CANONICAL defaults.
	local function props(inst, tbl)
		local real = SpiedToInstance[inst]
		if not real then return end
		for k, v in next, tbl do
			pcall(function()
				real[k] = v
			end)
		end
	end

	-- Workspace -----------------------------------------------------------
	props(workspace, {
		Gravity = 196.2,
		DistributedGameTime = 60,
		StreamingEnabled = false,
	})

	-- Camera ---------------------------------------------------------------
	local cam
	for _, child in next, Children[workspace] or {} do
		local real = SpiedToInstance[child]
		if real and real.ClassName == "Camera" then cam = child break end
	end
	if cam then
		props(cam, {
			FieldOfView = 70,
			ViewportSize = r3v.Vector2.new(1920, 1080),
			MaxAxisFieldOfView = 70,
			MinAxisFieldOfView = 70,
			Zoom = 14,
			HeadLocked = false,
			CFrame = r3v.CFrame.new(0, 20, 20),
			Focus = r3v.CFrame.new(0, 0, -5),
		})
	end

	-- Lighting --------------------------------------------------------------
	if env.Services["Lighting"] then
		local lighting = CreateInstance(env.Index("Lighting", "game"), "Lighting", true)
		props(lighting, {
			ClockTime = 14,
			TimeOfDay = "14:00:00",
			Brightness = 2,
			Ambient = r3v.Color3.new(0.3, 0.3, 0.3),
			OutdoorAmbient = r3v.Color3.new(0.3, 0.3, 0.3),
			GlobalShadows = true,
			FogEnd = 99999,
			FogStart = 0,
			FogColor = r3v.Color3.new(0.75, 0.85, 0.95),
			EnvironmentDiffuseScale = 1,
			EnvironmentSpecularScale = 1,
		})
	end

	-- Players + LocalPlayer + R6 character ---------------------------------
	if env.Services["Players"] then
		local players = CreateInstance(env.Index("Players", "game"), "Players", true)
		props(players, {})

		local localPlayer = CreateInstance(env.Index("LocalPlayer", "Players"), "Player", true)
		props(localPlayer, {
			Name = "Player",
			UserId = 1,
			DisplayName = "Player",
			AccountAge = 1,
			MembershipType = 2,
		})

		local playerGui = CreateInstance(env.Index("PlayerGui", "LocalPlayer"), "PlayerGui")
		local backpack = CreateInstance(env.Index("Backpack", "LocalPlayer"), "Backpack")
		SetParent(playerGui, localPlayer)
		SetParent(backpack, localPlayer)

		local character = CreateInstance(env.Index("Character", "LocalPlayer"), "Model")
		props(character, { Name = "Player" })

		local root = CreateInstance(env.Index("HumanoidRootPart", "Character"), "Part")
		local torso = CreateInstance(env.Index("Torso", "Character"), "Part")
		local head = CreateInstance(env.Index("Head", "Character"), "Part")
		local larm = CreateInstance(env.Index("Left Arm", "Character"), "Part")
		local rarm = CreateInstance(env.Index("Right Arm", "Character"), "Part")
		local lleg = CreateInstance(env.Index("Left Leg", "Character"), "Part")
		local rleg = CreateInstance(env.Index("Right Leg", "Character"), "Part")

		for _, part in next, { root, torso, head, larm, rarm, lleg, rleg } do
			SetParent(part, character)
			props(part, {
				Size = (part == head) and r3v.Vector3.new(2, 1, 1) or r3v.Vector3.new(2, 2, 1),
				Anchored = (part == root),
				CanCollide = false,
				Massless = true,
			})
		end

		local humanoid = CreateInstance(env.Index("Humanoid", "Character"), "Humanoid")
		props(humanoid, {
			Health = 100,
			MaxHealth = 100,
			WalkSpeed = 16,
			JumpPower = 50,
			JumpHeight = 7.2,
		})
		SetParent(humanoid, character)
		SetParent(character, workspace)

		-- wire LocalPlayer into Children[Players] so GetPlayers finds it
		local list = Children[players] or {}
		if not table.find(list, localPlayer) then
			table.insert(list, localPlayer)
			Children[players] = list
		end
	end

	-- Well-known services as children of the DataModel so `game.X` works -----
	local function ensureChild(serviceName)
		if not env.Services[serviceName] then return end
		local gameKids = Children[game] or {}
		for _, child in next, gameKids do
			local real = SpiedToInstance[child]
			if real and real.ClassName == serviceName then return end
		end
		local s = CreateInstance(env.Index(serviceName, "game"), serviceName, true)
		SetParent(s, game)
		Information[s] = { service = true, was_created = true }
	end

	for _, svc in next, {
		"Lighting", "ReplicatedStorage", "ReplicatedFirst", "ServerStorage",
		"ServerScriptService", "StarterGui", "StarterPack", "SoundService",
		"Teams", "Players", "RunService", "Stats", "TweenService",
		"HttpService", "CollectionService", "ContentProvider", "UserInputService",
		"GuiService", "CoreGui", "TextChatService", "BadgeService",
		"MarketplaceService", "TeleportService", "GamePassService",
		"MessagingService", "DataStoreService", "MemoryStoreService",
		"PhysicsService", "RbxAnalyticsService", "SocialService", "Debris",
		"ContextActionService", "VoiceChatService", "PointsService",
		"GroupService", "Selection", "StarterPlayer",
	} do
		pcall(ensureChild, svc)
	end
end

return Compat