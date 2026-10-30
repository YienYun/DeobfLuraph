local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local localPlayer = Players.LocalPlayer
if game.PlaceId ~= 0 and game.PlaceId ~= 8472910452 then
    warn(string.format("[Nebula] Unsupported PlaceId: %d (expected %d)", game.PlaceId, 8472910452))
end
local function helperFn(arg1, arg2)
    local val = arg2 or 2166136261
    local val2 = #arg1
    for i = 1, val2 do
        local val3 = string.byte(arg1, i)
        val = (val * 16777619 + val3 * (i + 7)) % 4294967296
    end
    local val3 = string.format("%08X", val)
    return val, val3, val2
end
local function helperFn2(...)
    local val = select("#", ...)
    local stateMap = {}
    stateMap.n = val
    for i = 1, val do
        local val2 = select(i, ...)
        stateMap[i] = val2
    end
    return stateMap, val
end
local val = helperFn
local val2 = HttpService
local function helperFn3(arg1)
    local stateMap = {}
    local value = 0
    local stateMap2 = {}
    for key, item in pairs(arg1) do
        local val3 = type(item)
        if val3 == "table" then
            local stateMap3 = {}
            for key2, item2 in pairs(item) do
                stateMap3[key2] = item2
            end
            stateMap[key] = stateMap3
        else
            stateMap[key] = item
        end
    end
    local function helperFn4(arg12)
        if not writefile then
            local val3 = tostring(arg12) .. ")"
            warn("[Nebula] Executor missing writefile; skipped save (" .. val3)
            return false
        end
        local ok, res = pcall(function()
            return val2:JSONEncode(stateMap)
        end)
        if not ok then
            local val3 = "[Nebula] Encode failed: " .. tostring(res)
            warn(val3)
            return false
        end
        local ok2, res2 = pcall(writefile, "nebula_sentinel_v2.json", res)
        if ok2 then
            local _, val3, val4 = val(res, value + 17)
            local stateMap3 = {}
            stateMap3.tag = val3
            stateMap3.bytes = val4
            stateMap3.reason = arg12 or "manual"
            stateMap2[#stateMap2 + 1] = stateMap3
            value = 0
            return true
        end
        local val3 = "[Nebula] Save failed: " .. tostring(res2)
        warn(val3)
        return false
    end
    local val3 = helperFn4
    local function helperFn5(arg12, arg2, arg3)
        if stateMap[arg12] == arg2 then
            return false, stateMap[arg12]
        end
        stateMap[arg12] = arg2
        value = value + 1
        if arg3 then
            local val4 = "set:" .. tostring(arg12)
            val3(val4)
        end
        return true, arg2
    end
    local function helperFn6(arg12)
        return stateMap[arg12], value
    end
    local stateMap3 = {}
    stateMap3.load = function()
        local val4 = isfile and readfile and isfile("nebula_sentinel_v2.json")
        if not val4 then
            return false, "no_file"
        end
        local ok, res = pcall(function()
            return val2:JSONDecode(readfile("nebula_sentinel_v2.json"))
        end)
        local val5 = not ok
        if not val5 then
            local val6 = type(res)
            val5 = val6 ~= "table"
        end
        if val5 then
            return false, "corrupt_json"
        end
        for key, item in pairs(res) do
            local val6 = stateMap[key] ~= nil
            if val6 then
                local val7 = type(stateMap[key])
                local val8 = type(item)
                val6 = val7 == val8
            end
            if val6 then
                stateMap[key] = item
            end
        end
        return true, "loaded"
    end
    stateMap3.save = helperFn4
    stateMap3.set = helperFn5
    stateMap3.get = helperFn6
    stateMap3.raw = stateMap
    stateMap3.history = stateMap2
    return stateMap3
end
local stateMap = {}
stateMap.__index = stateMap
local val3 = stateMap
stateMap.new = function(arg1, arg2)
    local val4 = setmetatable({}, val3)
    val4.label = arg1 or "MainScheduler"
    val4.maxBudgetMs = arg2 or 8.5
    val4.jobs = {}
    val4.totalTicks = 0
    val4.running = false
    val4.connection = nil
    return val4
end
stateMap.register = function(arg1, arg2, arg3, arg4)
    local stateMap2 = {}
    stateMap2.name = arg2
    stateMap2.interval = math.max(arg3 or 0.1, 0.01)
    stateMap2.elapsed = 0
    stateMap2.runs = 0
    stateMap2.active = true
    stateMap2.fn = arg4
    arg1.jobs[#arg1.jobs + 1] = stateMap2
    return stateMap2
end
stateMap.pruneInactive = function(arg1)
    local value = 0
    for i = #arg1.jobs, 1, -1 do
        if not arg1.jobs[i].active then
            table.remove(arg1.jobs, i)
            value = value + 1
        end
    end
    return value
end
stateMap.step = function(arg1, arg2)
    arg1.totalTicks = arg1.totalTicks + 1
    local value = 0
    for _, item in ipairs(arg1.jobs) do
        if item.active then
            item.elapsed = item.elapsed + arg2
            if item.elapsed >= item.interval then
                item.elapsed = 0
                item.runs = item.runs + 1
                local ok, res = pcall(item.fn, item.runs, arg2, arg1.totalTicks)
                value = value + 1
                if not ok then
                    warn(string.format("[Nebula:%s] Job '%s' error: %s", arg1.label, item.name, tostring(res)))
                    item.active = false
                elseif res == false then
                    item.active = false
                end
            end
        end
    end
    if arg1.totalTicks % 30 == 0 then
        arg1:pruneInactive()
    end
    return value
end
local val4 = RunService
stateMap.start = function(arg1)
    if arg1.running then
        return
    end
    arg1.running = true
    local val5 = val4.Heartbeat:Connect(function(arg12)
        if not arg1.running then
            return
        end
        arg1:step(arg12)
    end)
    arg1.connection = val5
end
stateMap.stop = function(arg1)
    arg1.running = false
    if arg1.connection then
        arg1.connection:Disconnect()
        arg1.connection = nil
    end
end
local stateMap2 = {}
local stateMap3 = {}
stateMap3.skipLocked = true
local stateMap4 = {}
stateMap4.Spread = 0
stateMap4.RecoilPitch = 0.02
stateMap4.FireCooldown = 0.045
stateMap4.Range = 450
stateMap3.overrides = stateMap4
stateMap2.Rifle = stateMap3
local stateMap5 = {}
stateMap5.skipLocked = false
local stateMap6 = {}
stateMap6.SwingCooldown = 0.08
stateMap6.HitboxScale = 1.35
stateMap6.Recovery = 0.05
stateMap5.overrides = stateMap6
stateMap2.Melee = stateMap5
local stateMap7 = {}
local val5 = stateMap2
local function helperFn4(arg1, arg2, arg3)
    local val6 = val5[arg1]
    local val7 = not val6
    if not val7 then
        local val8 = type(arg3)
        val7 = val8 ~= "table"
    end
    if val7 then
        return 0
    end
    local value = 0
    for key, item in pairs(arg3) do
        local skipLocked = val6.skipLocked
        if skipLocked then
            local val8 = type(item)
            skipLocked = val8 == "table"
        end
        if skipLocked then
            skipLocked = item.Locked == true
        end
        local val8 = type(item)
        if val8 == "table" and not skipLocked then
            for key2, item2 in pairs(val6.overrides) do
                if arg2 then
                    if item[key2] ~= nil then
                        stateMap7[key] = stateMap7[key] or {}
                        if stateMap7[key][key2] == nil then
                            stateMap7[key][key2] = item[key2]
                        end
                        item[key2] = item2
                        value = value + 1
                    end
                else
                    local val9 = stateMap7[key] and stateMap7[key][key2]
                    if val9 ~= nil then
                        item[key2] = val9
                        value = value + 1
                    end
                end
            end
        end
    end
    return value
end
local val6 = localPlayer
local function helperFn5(arg1, arg2)
    if not arg1 or arg1 == val6 then
        return false, "self_or_nil"
    end
    if not arg2 and val6.Team and arg1.Team == val6.Team then
        return false, "teammate"
    end
    local character = arg1.Character
    if not character then
        return false, "no_char"
    end
    local val7 = character:FindFirstChildOfClass("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local val8 = val7 and humanoidRootPart and character:FindFirstChild("Head") and val7.Health > 0
    if not val8 then
        return false, "dead_or_incomplete"
    end
    return true, humanoidRootPart
end
local val7 = helperFn5
local val8 = localPlayer
local val9 = Players
local function helperFn6(arg1, arg2)
    local val10 = val8 and val8.Character
    local val11 = val10 and val10:FindFirstChild("HumanoidRootPart")
    if not val11 then
        return nil, math.huge
    end
    local val12 = nil
    local val13 = arg1 or 250
    for _, item in ipairs(val9:GetPlayers()) do
        local val14, val15 = val7(item, arg2)
        if val14 then
            local magnitude = ((val15.Position - val11.Position)).Magnitude
            if magnitude < val13 then
                val13 = magnitude
                val12 = item
            end
        end
    end
    return val12, val13
end
local val10 = helperFn2
local function helperFn7(arg1, arg2, arg3, ...)
    local val11, val12 = val10(...)
    local value = 0
    local value2 = 0.05
    local val13
    while true do
        value = value + 1
        val13 = val11
        local ok, res = pcall(function()
            if val12 == 0 then
                return arg3()
            end
            if val12 == 1 then
                return arg3(val13[1])
            end
            if val12 == 2 then
                return arg3(val13[1], val13[2])
            end
            return arg3(unpack(val13, 1, val12))
        end)
        if ok then
            return true, res, value
        end
        local val14 = value2 * 1.5
        if val14 < 0.05 then
            value2 = 0.05
        elseif val14 > 0.5 then
            value2 = 0.5
        else
            value2 = val14
        end
        if task and task.wait then
            task.wait(value2)
        end
        if value >= arg2 then
            warn(string.format("[Nebula] '%s' failed after %d attempts: %s", arg1, value, tostring(res)))
            return false, res, value
        end
    end
end
local function helperFn8(arg1, arg2, arg3)
    local val11 = Instance.new(arg1)
    for key, item in pairs(arg2 or {}) do
        val11[key] = item
    end
    if arg3 then
        for _, item in next, arg3, nil do
            item.Parent = val11
        end
    end
    return val11
end
local stateMap8 = {}
stateMap8.rifleBypass = false
stateMap8.meleeBypass = false
stateMap8.autoOrbit = false
stateMap8.scanRadius = 180
stateMap8.allowTeam = false
local val11 = helperFn3(stateMap8)
val11.load()
local val12 = stateMap.new("NebulaCore", 6)
local value = 0
local val13 = nil
local val14 = localPlayer
local val15 = helperFn5
local val16 = helperFn6
local val17 = val11
val12:register("TargetOrbit", 0.016, function(arg1, arg2)
    local val18 = val17.get("autoOrbit")
    if not val18 then
        val13 = nil
        return true
    end
    local val19 = val14 and val14.Character
    local val20 = val19 and val19:FindFirstChild("HumanoidRootPart")
    if not val20 then
        return true
    end
    local val21, val22 = val15(val13, val17.get("allowTeam"))
    if not val21 then
        local val23 = val17.get("scanRadius")
        local val24
        if val23 < 25 then
            val24 = 25
        elseif val23 > 500 then
            val24 = 500
        else
            val24 = val23
        end
        val13 = val16(val24, val17.get("allowTeam"))
        val21, val22 = val15(val13, val17.get("allowTeam"))
    end
    if val21 and val22 then
        value = (value + arg2 * 4.5) % (math.pi * 2)
        val20.CFrame = CFrame.new(val22.Position) * CFrame.Angles(0, value, 0) * CFrame.new(0, 2.5, 6)
        val20.AssemblyLinearVelocity = Vector3.zero
    end
    if arg1 % 600 == 0 then
        print(string.format("[Nebula] Orbit heartbeat #%d active", arg1))
    end
    return true
end)
local val18 = gethui and gethui() or localPlayer:WaitForChild("PlayerGui")
local nebulaSentinelUi = val18:FindFirstChild("NebulaSentinelUI")
if nebulaSentinelUi then
    nebulaSentinelUi:Destroy()
end
local stateMap9 = {}
stateMap9.Name = "NebulaSentinelUI"
stateMap9.ResetOnSpawn = false
stateMap9.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
stateMap9.Parent = val18
local val19 = helperFn8("ScreenGui", stateMap9)
local stateMap10 = {}
stateMap10.Size = UDim2.new(0, 240, 0, 280)
stateMap10.Position = UDim2.new(0, 48, 0, 140)
stateMap10.BackgroundColor3 = Color3.fromRGB(20, 22, 28)
stateMap10.BorderSizePixel = 0
stateMap10.Parent = val19
local stateMap11 = {}
local stateMap12 = {}
stateMap12.CornerRadius = UDim.new(0, 12)
local val20 = helperFn8("UICorner", stateMap12)
local stateMap13 = {}
stateMap13.Color = Color3.fromRGB(62, 68, 82)
stateMap13.Thickness = 1
local val21 = helperFn8("UIStroke", stateMap13)
stateMap11[1] = val20
stateMap11[2] = val21
local val22 = helperFn8("Frame", stateMap10, stateMap11)
local stateMap14 = {}
stateMap14.Size = UDim2.new(1, -20, 0, 32)
stateMap14.Position = UDim2.new(0, 10, 0, 0)
stateMap14.BackgroundTransparency = 1
stateMap14.Text = "Nebula Sentinel v2.4"
stateMap14.TextColor3 = Color3.fromRGB(235, 238, 245)
stateMap14.Font = Enum.Font.Code
stateMap14.TextSize = 13
stateMap14.TextXAlignment = Enum.TextXAlignment.Left
stateMap14.Parent = val22
local val23 = helperFn8("TextLabel", stateMap14)
local stateMap15 = {}
stateMap15.Size = UDim2.new(1, -16, 1, -44)
stateMap15.Position = UDim2.new(0, 8, 0, 36)
stateMap15.BackgroundTransparency = 1
stateMap15.Parent = val22
local stateMap16 = {}
local stateMap17 = {}
stateMap17.Padding = UDim.new(0, 6)
stateMap17.SortOrder = Enum.SortOrder.LayoutOrder
local val24 = helperFn8("UIListLayout", stateMap17)
stateMap16[1] = val24
local val25 = helperFn8("Frame", stateMap15, stateMap16)
local stateMap18 = {}
local val26 = ReplicatedStorage
local val27, val28 = helperFn7("LoadItemRegistry", 2, function()
    local modules = val26:FindFirstChild("Modules") and val26.Modules:FindFirstChild("WeaponRegistry")
    local val27 = modules and require(modules) or {}
    return val27
end)
if val27 then
    local val29 = type(val28)
    val27 = val29 == "table"
end
if val27 then
    stateMap18 = val28.Items or val28
end
local stateMap19 = {}
local stateMap20 = {}
local val29 = stateMap18
local val30 = helperFn4
stateMap20[1] = "Rifle Fast-Fire"
stateMap20[2] = "rifleBypass"
stateMap20[3] = function(arg1)
    val30("Rifle", arg1, val29)
end
local stateMap21 = {}
local val31 = stateMap18
local val32 = helperFn4
stateMap21[1] = "Melee Cooldown"
stateMap21[2] = "meleeBypass"
stateMap21[3] = function(arg1)
    val32("Melee", arg1, val31)
end
local stateMap22 = {}
local val33 = val12
local function helperFn9(arg1)
    if arg1 then
        val33:start()
    end
end
stateMap22[1] = "Auto Orbit Nearest"
stateMap22[2] = "autoOrbit"
stateMap22[3] = helperFn9
local stateMap23 = {}
local function helperFn10(arg1)

end
stateMap23[1] = "Include Teammates"
stateMap23[2] = "allowTeam"
stateMap23[3] = helperFn10
stateMap19[1] = stateMap20
stateMap19[2] = stateMap21
stateMap19[3] = stateMap22
stateMap19[4] = stateMap23
for idx, item in ipairs(stateMap19) do
    local val34 = item[1]
    local val35 = item[2]
    local val36 = item[3]
    local val37 = val11.get(val35)
    helperFn10 = val37 == true
    local stateMap24 = {}
    stateMap24.Size = UDim2.new(1, 0, 0, 32)
    stateMap24.BackgroundColor3 = helperFn10 and Color3.fromRGB(42, 62, 54) or Color3.fromRGB(30, 33, 42)
    stateMap24.BorderSizePixel = 0
    stateMap24.AutoButtonColor = false
    stateMap24.Text = val34 .. (helperFn10 and " [ON]" or " [OFF]")
    stateMap24.TextColor3 = helperFn10 and Color3.fromRGB(160, 240, 190) or Color3.fromRGB(175, 180, 192)
    stateMap24.Font = Enum.Font.Code
    stateMap24.TextSize = 12
    stateMap24.LayoutOrder = idx
    stateMap24.Parent = val25
    local stateMap25 = {}
    local stateMap26 = {}
    stateMap26.CornerRadius = UDim.new(0, 8)
    local uiCorner = Instance.new("UICorner")
    for key, item2 in pairs(stateMap26 or {}) do
        uiCorner[key] = item2
    end
    stateMap25[1] = uiCorner
    local button = Instance.new("TextButton")
    for key, item2 in pairs(stateMap24 or {}) do
        button[key] = item2
    end
    if stateMap25 then
        for _, item2 in next, stateMap25, nil do
            item2.Parent = button
        end
    end
    local val38 = val34
    local val39 = val11
    local val40 = val36
    local val41 = val35
    local val42 = button
    button.MouseButton1Click:Connect(function()
        helperFn10 = not helperFn10
        val42.BackgroundColor3 = helperFn10 and Color3.fromRGB(42, 62, 54) or Color3.fromRGB(30, 33, 42)
        val42.TextColor3 = helperFn10 and Color3.fromRGB(160, 240, 190) or Color3.fromRGB(175, 180, 192)
        val42.Text = val38 .. (helperFn10 and " [ON]" or " [OFF]")
        local val43 = helperFn10
        val39.set(val41, val43, true)
        val40(val43)
    end)
    if helperFn10 then
        val36(true)
    end
end
local enabled = false
local val34 = nil
local val35 = nil
local val36 = val22
val23.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        enabled = true
        val34 = input.Position
        val35 = val36.Position
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        enabled = false
    end
end)
local val37 = val22
UserInputService.InputChanged:Connect(function(input)
    if enabled and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local val38 = input.Position - val34
        val37.Position = UDim2.new(val35.X.Scale, val35.X.Offset + val38.X, val35.Y.Scale, val35.Y.Offset + val38.Y)
    end
end)
local val38 = val19
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        val38.Enabled = not val38.Enabled
    end
end)
val34 = val12
val34:start()
enabled = helperFn
val34 = "NebulaSentinelReady"
val35 = 42
enabled, val34, val35 = enabled(val34, val35)
helperFn10 = val35
print(string.format("[Nebula] Loaded OK | sig=%s (%d, len=%d)", val34, enabled, helperFn10))
