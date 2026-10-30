local function helperFn(arg1, arg2, arg3)
    if type(arg1) == "table" then
        return pairs(arg1)
    end
    return arg1, arg2, arg3
end
print("Aurora Addons is loading..")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local localPlayer = Players.LocalPlayer
if game.GameId ~= 6035872082 then
    warn("Aurora: wrong game")
    return
end
local stateMap = {}
local val = readfile and isfile and isfile("aurora_config.json")
if val then
    local val2 = HttpService
    local ok, res = pcall(function()
        return val2:JSONDecode(readfile("aurora_config.json"))
    end)
    if ok then
        local val3 = type(res)
        ok = val3 == "table"
    end
    if ok then
        stateMap = res
    end
end
local val2 = stateMap
local val3 = HttpService
local function helperFn2(arg1, arg2)
    val2[arg1] = arg2
    if writefile then
        local ok, res = pcall(writefile, "aurora_config.json", val3:JSONEncode(val2))
        if not ok then
            local val4 = "Aurora: config save failed: " .. tostring(res)
            warn(val4)
        end
    else
        warn("Aurora: executor has no writefile, config not saved")
    end
end
local val4 = require(ReplicatedStorage.Modules.ItemLibrary)
local items = val4.Items
local stateMap2 = {}
local stateMap3 = {}
stateMap3.skipExceptions = true
local stateMap4 = {}
stateMap4.ShootSpread = 0
stateMap4.ShootAccuracy = 0
stateMap4.ShootRecoil = 0
stateMap4.ShootCooldown = 0.001
stateMap4.ShootBurstCooldown = 0.001
stateMap3.fields = stateMap4
stateMap2.Gun = stateMap3
local stateMap5 = {}
stateMap5.skipExceptions = false
local stateMap6 = {}
stateMap6.AttackCooldown = 0.001
stateMap6.SwingCooldown = 0.001
stateMap6.MeleeCooldown = 0.001
stateMap6.Cooldown = 0.001
stateMap6.RecoveryTime = 0.001
stateMap6.ResetTime = 0.001
stateMap5.fields = stateMap6
stateMap2.Cooldown = stateMap5
local val5 = stateMap2
local val6 = items
local stateMap7 = {}
local stateMap8 = {}
local function helperFn3(arg1, arg2)
    local val7 = val5[arg1]
    for key, item in pairs(val6) do
        local val8 = typeof(item)
        if val8 == "table" and not (val7.skipExceptions and stateMap8[key]) then
            for key2, item2 in pairs(val7.fields) do
                if arg2 then
                    if item[key2] ~= nil then
                        stateMap7[item] = stateMap7[item] or {}
                        if stateMap7[item][key2] == nil then
                            stateMap7[item][key2] = item[key2]
                        end
                        item[key2] = item2
                    end
                else
                    local val9 = stateMap7[item] and stateMap7[item][key2]
                    if val9 ~= nil then
                        item[key2] = val9
                    end
                end
            end
        end
    end
end
local function helperFn4(arg1)
    local character = arg1.Character
    if not character then
        return false
    end
    local val7 = character:FindFirstChildOfClass("Humanoid")
    local val8 = val7 and val7.Health > 0 and character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Head")
    return val8
end
local val7 = localPlayer
local val8 = Players
local val9 = helperFn4
local function helperFn5()
    local character = val7.Character
    local val10 = character and character:FindFirstChild("HumanoidRootPart")
    if not val10 then
        return nil
    end
    local val11 = nil
    local val12 = nil
    for _, item in ipairs(val8:GetPlayers()) do
        local val13
        if item == val7 then
            val13 = false
        elseif val7.Team and item.Team and val7.Team == item.Team then
            val13 = false
        else
            val13 = true
        end
        if val13 then
            val13 = val9(item)
        end
        if val13 then
            local magnitude = ((item.Character.HumanoidRootPart.Position - val10.Position)).Magnitude
            if not val12 or magnitude < val12 then
                val11 = item
                val12 = magnitude
            end
        end
    end
    return val11
end
local val10 = nil
local value = 0
local val11 = helperFn5
local val12 = localPlayer
local val13 = RunService
local function helperFn6(arg1)
    if arg1 then
        val10 = val13.Heartbeat:Connect(function(arg12)
            local character = val12.Character
            local val14 = character and character:FindFirstChild("HumanoidRootPart")
            if not val14 then
                return
            end
            local val15 = val11()
            if not val15 then
                return
            end
            value = (value + 100000000000 * arg12) % (2 * math.pi)
            val14.CFrame = CFrame.new(val15.Character.HumanoidRootPart.Position) * CFrame.Angles(0, value, 0) * CFrame.new(0, 0, 6)
            val14.AssemblyLinearVelocity = Vector3.zero
        end)
    elseif val10 then
        val10:Disconnect()
        val10 = nil
    end
end
local val14 = localPlayer
local val15 = RunService
local function helperFn7(arg1)
    if not arg1 then
        return
    end
    task.spawn(function()
        while true do
            if arg1 then
                local character = val14.Character
                local val16 = character and character:FindFirstChild("HumanoidRootPart")
                if val16 then
                    local cFrame = val16.CFrame
                    val16.CFrame = CFrame.new(cFrame.Position.X, -100000000, cFrame.Position.Z)
                    val15.Heartbeat:Wait()
                    local character2 = val14.Character
                    local val17 = character2 and character2:FindFirstChild("HumanoidRootPart")
                    if val17 then
                        val17.CFrame = cFrame
                        val17.AssemblyLinearVelocity = Vector3.zero
                    end
                    val15.Heartbeat:Wait()
                else
                    task.wait(0.1)
                end
            else
                break
            end
        end
    end)
end
local val16 = nil
local val17 = nil
local val18 = helperFn5
local val19 = helperFn4
local val20 = RunService
local val21 = localPlayer
local function helperFn8(arg1)
    if arg1 then
        val16 = val20.Heartbeat:Connect(function()
            local character = val21.Character
            local val22 = character and character:FindFirstChild("HumanoidRootPart")
            if not val22 then
                return
            end
            local val23 = not val17
            if not val23 then
                local val24 = val19(val17)
                val23 = not val24
            end
            if val23 then
                val17 = val18()
            end
            if not val17 then
                return
            end
            local head = val17.Character:FindFirstChild("Head")
            if not head then
                val17 = nil
                return
            end
            val22.CFrame = head.CFrame * CFrame.new(0, 3, 0)
            val22.AssemblyLinearVelocity = Vector3.zero
        end)
    else
        if val16 then
            val16:Disconnect()
            val16 = nil
        end
        val17 = nil
    end
end
local enabled = false
local function fetchRemoteKey(arg1)
    local val22 = getgenv()
    val22.AuroraAutoLoadOff = not arg1
    if not arg1 or enabled then
        return
    end
    if not queue_on_teleport then
        warn("Aurora: executor has no queue_on_teleport")
        return
    end
    queue_on_teleport(("if getgenv().AuroraAutoLoadOff then return end\nlocal ok, err = pcall(function()\n    loadstring(game:HttpGet(\"%s\"))()\nend)\nif not ok then warn(\"Aurora autoload: \" .. tostring(err)) end\n"):format("https://raw.githubusercontent.com/yenkgg/AuroraAddons/refs/heads/main/loader.lua"))
    enabled = true
    print("Aurora: auto load queued")
end
local function helperFn9(arg1, arg2, arg3)
    local val22 = Instance.new(arg1)
    for key, item in pairs(arg2) do
        val22[key] = item
    end
    for _, item in ipairs(arg3 or {}) do
        item.Parent = val22
    end
    return val22
end
local val22 = Color3.fromRGB(22, 22, 24)
local val23 = Color3.fromRGB(55, 55, 60)
local val24 = Color3.fromRGB(230, 230, 234)
local stateMap9 = {}
local val25 = stateMap9
local val26 = val24
local val27 = Color3.fromRGB(150, 150, 156)
local val28 = Color3.fromRGB(44, 44, 48)
local val29 = Color3.fromRGB(30, 30, 33)
local val30 = Color3.fromRGB(22, 22, 24)
local val31 = helperFn2
local val32 = val23
local val33 = Color3.fromRGB(140, 190, 120)
local code = Enum.Font.Code
local val34 = Color3.fromRGB(95, 95, 102)
local function helperFn10(arg1, arg2, arg3, arg4)
    local enabled2 = false
    local stateMap10 = {}
    stateMap10.Size = UDim2.new(1, 0, 0, 30)
    stateMap10.BackgroundColor3 = val29
    stateMap10.BorderSizePixel = 0
    stateMap10.AutoButtonColor = false
    stateMap10.Text = ""
    stateMap10.LayoutOrder = arg2
    local stateMap11 = {}
    local stateMap12 = {}
    stateMap12.CornerRadius = UDim.new(0, 8)
    local val35 = helperFn9("UICorner", stateMap12)
    local stateMap13 = {}
    stateMap13.Color = val32
    stateMap13.Thickness = 1
    local val36 = helperFn9("UIStroke", stateMap13)
    local stateMap14 = {}
    stateMap14.Size = UDim2.new(1, -50, 1, 0)
    stateMap14.Position = UDim2.new(0, 10, 0, 0)
    stateMap14.BackgroundTransparency = 1
    stateMap14.Text = arg1
    stateMap14.TextColor3 = val27
    stateMap14.Font = code
    stateMap14.TextSize = 12
    stateMap14.TextXAlignment = Enum.TextXAlignment.Left
    local val37 = helperFn9("TextLabel", stateMap14)
    stateMap11[1] = val35
    stateMap11[2] = val36
    stateMap11[3] = val37
    local val38 = helperFn9("TextButton", stateMap10, stateMap11)
    local val39 = helperFn9
    local stateMap15 = {}
    stateMap15.Size = UDim2.new(0, 24, 0, 12)
    stateMap15.Position = UDim2.new(1, -34, 0.5, -6)
    stateMap15.BackgroundColor3 = val28
    stateMap15.BorderSizePixel = 0
    stateMap15.Parent = val38
    local stateMap16 = {}
    local stateMap17 = {}
    stateMap17.CornerRadius = UDim.new(1, 0)
    local val40 = val39("UICorner", stateMap17)
    stateMap16[1] = val40
    val39 = val39("Frame", stateMap15, stateMap16)
    local val41 = helperFn9
    local stateMap18 = {}
    stateMap18.Size = UDim2.new(0, 8, 0, 8)
    stateMap18.Position = UDim2.new(0, 2, 0.5, -4)
    stateMap18.BackgroundColor3 = val34
    stateMap18.BorderSizePixel = 0
    stateMap18.Parent = val39
    local stateMap19 = {}
    local stateMap20 = {}
    stateMap20.CornerRadius = UDim.new(1, 0)
    local val42 = val41("UICorner", stateMap20)
    stateMap19[1] = val42
    val41 = val41("Frame", stateMap18, stateMap19)
    local val43 = val38:FindFirstChildOfClass("TextLabel")
    local function helperFn11(arg12)
        val39.BackgroundColor3 = arg12 and val33 or val28
        val41.BackgroundColor3 = arg12 and val30 or val34
        val41.Position = arg12 and UDim2.new(1, -10, 0.5, -4) or UDim2.new(0, 2, 0.5, -4)
        val43.TextColor3 = arg12 and val26 or val27
        arg4(arg12)
    end
    val38.MouseButton1Click:Connect(function()
        helperFn11(not enabled2)
        val31(arg3, enabled2)
    end)
    val25[arg3] = helperFn11
    return val38
end
local val35 = gethui and gethui() or localPlayer:WaitForChild("PlayerGui")
for _, item in ipairs({"AuroraUI", "AuroraToggle"}) do
    local val36 = val35:FindFirstChild(item)
    if val36 then
        val36:Destroy()
    end
end
local stateMap10 = {}
stateMap10.Name = "AuroraUI"
stateMap10.ResetOnSpawn = false
stateMap10.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
stateMap10.Parent = val35
local val36 = helperFn9("ScreenGui", stateMap10)
local stateMap11 = {}
stateMap11.Size = UDim2.new(0, 210, 0, 250)
stateMap11.Position = UDim2.new(0, 40, 0, 120)
stateMap11.BackgroundColor3 = val22
stateMap11.BorderSizePixel = 0
stateMap11.Parent = val36
local stateMap12 = {}
local stateMap13 = {}
stateMap13.CornerRadius = UDim.new(0, 14)
local val37 = helperFn9("UICorner", stateMap13)
local stateMap14 = {}
stateMap14.Color = val23
stateMap14.Thickness = 1
local val38 = helperFn9("UIStroke", stateMap14)
stateMap12[1] = val37
stateMap12[2] = val38
local val39 = helperFn9("Frame", stateMap11, stateMap12)
local stateMap15 = {}
stateMap15.Size = UDim2.new(1, 0, 0, 30)
stateMap15.BackgroundTransparency = 1
stateMap15.Text = "Aurora Addons"
stateMap15.TextColor3 = val24
stateMap15.Font = Enum.Font.Code
stateMap15.TextSize = 12
stateMap15.TextXAlignment = Enum.TextXAlignment.Left
stateMap15.Parent = val39
local stateMap16 = {}
local stateMap17 = {}
stateMap17.PaddingLeft = UDim.new(0, 12)
local val40 = helperFn9("UIPadding", stateMap17)
stateMap16[1] = val40
local val41 = helperFn9("TextLabel", stateMap15, stateMap16)
local stateMap18 = {}
stateMap18.Size = UDim2.new(1, -24, 0, 1)
stateMap18.Position = UDim2.new(0, 12, 0, 30)
stateMap18.BackgroundColor3 = val23
stateMap18.BorderSizePixel = 0
stateMap18.Parent = val39
helperFn9("Frame", stateMap18)
local stateMap19 = {}
stateMap19.Size = UDim2.new(1, -16, 1, -40)
stateMap19.Position = UDim2.new(0, 8, 0, 38)
stateMap19.BackgroundTransparency = 1
stateMap19.Parent = val39
local stateMap20 = {}
local stateMap21 = {}
stateMap21.Padding = UDim.new(0, 5)
stateMap21.SortOrder = Enum.SortOrder.LayoutOrder
local val42 = helperFn9("UIListLayout", stateMap21)
stateMap20[1] = val42
local val43 = helperFn9("Frame", stateMap19, stateMap20)
local stateMap22 = {}
local stateMap23 = {}
local val44 = helperFn3
stateMap23[1] = "gun bypass"
stateMap23[2] = "gun"
stateMap23[3] = function(arg1)
    val44("Gun", arg1)
end
local stateMap24 = {}
local val45 = helperFn3
stateMap24[1] = "melee bypass"
stateMap24[2] = "melee"
stateMap24[3] = function(arg1)
    val45("Cooldown", arg1)
end
local tbl = {"tp to enemy", "tp", helperFn8}
stateMap22[1] = stateMap23
stateMap22[2] = stateMap24
stateMap22[3] = {"orbit closest", "orbit", helperFn6}
stateMap22[4] = {"void spam", "void", helperFn7}
stateMap22[5] = tbl
stateMap22[6] = {"auto load", "autoload", fetchRemoteKey}
for idx, item in ipairs(stateMap22) do
    tbl = helperFn10
    tbl = tbl(item[1], idx, item[2], item[3])
    tbl.Parent = val43
end
local val46 = stateMap9
local val47
local val48
val47, val46, val48 = pairs(val46)
local val49
local val50
val49, val46, val50 = helperFn(val47, val46, val48)
local val51, val52 = val49(val46, val50)
local val53 = val51
if val53 ~= nil then
    while true do
        tbl = stateMap[val51]
        if tbl == true then
            tbl = val52
            tbl(true)
        end
        val51, val52 = val49(val46, val53)
        val53 = val51
        if val53 == nil then
            break
        end
    end
end
if UserInputService.TouchEnabled then
    val46 = "ScreenGui"
    val53 = {}
    val51 = "AuroraToggle"
    val53.Name = val51
    val51 = false
    val53.ResetOnSpawn = val51
    tbl = Enum
    val52 = tbl.ZIndexBehavior
    val51 = val52.Sibling
    val53.ZIndexBehavior = val51
    val53.Parent = val35
    local val54 = helperFn9(val46, val53)
    val46 = helperFn9
    val53 = "TextButton"
    val52 = {}
    tbl = UDim2.new
    tbl = tbl(0, 42, 0, 42)
    val52.Size = tbl
    tbl = UDim2.new
    tbl = tbl(0, 10, 0.5, -21)
    val52.Position = tbl
    val52.BackgroundColor3 = val22
    tbl = 0
    val52.BorderSizePixel = tbl
    tbl = false
    val52.AutoButtonColor = tbl
    tbl = "AA"
    val52.Text = tbl
    val52.TextColor3 = val24
    val52.Font = Enum.Font.Code
    tbl = 13
    val52.TextSize = tbl
    val52.Parent = val54
    val51 = val52
    val52 = {}
    tbl = helperFn9
    local stateMap25 = {}
    stateMap25.CornerRadius = UDim.new(1, 0)
    tbl = tbl("UICorner", stateMap25)
    local stateMap26 = {}
    stateMap26.Color = val23
    stateMap26.Thickness = 1
    local val55 = helperFn9("UIStroke", stateMap26)
    val52[1] = tbl
    val52[2] = val55
    val46 = val46(val53, val51, val52)
    val53 = nil
    val51 = nil
    val52 = nil
    tbl = nil
    val46.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            val53 = true
            tbl = false
            val51 = input.Position
            val52 = val46.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if val53 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local val56 = input.Position - val51
            if val56.Magnitude > 5 then
                tbl = true
            end
            val46.Position = UDim2.new(val52.X.Scale, val52.X.Offset + val56.X, val52.Y.Scale, val52.Y.Offset + val56.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            val53 = false
        end
    end)
    local val56 = val36
    val46.MouseButton1Click:Connect(function()
        if not tbl then
            val56.Enabled = not val56.Enabled
        end
    end)
end
local val54 = nil
val46 = nil
val53 = nil
val51 = val41.InputBegan
local val55 = val39
tbl = function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        val54 = true
        val46 = input.Position
        val53 = val55.Position
    end
end
val52 = val51
val52:Connect(tbl)
val51 = UserInputService.InputEnded
tbl = function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        val54 = false
    end
end
val52 = val51
val52:Connect(tbl)
val51 = UserInputService.InputChanged
local val56 = val39
tbl = function(input)
    if val54 and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local val57 = input.Position - val46
        val56.Position = UDim2.new(val53.X.Scale, val53.X.Offset + val57.X, val53.Y.Scale, val53.Y.Offset + val57.Y)
    end
end
val52 = val51
val52:Connect(tbl)
val51 = UserInputService.InputBegan
local val57 = val36
tbl = function(arg1, arg2)
    if not arg2 and arg1.KeyCode == Enum.KeyCode.RightControl then
        val57.Enabled = not val57.Enabled
    end
end
val52 = val51
val52:Connect(tbl)
