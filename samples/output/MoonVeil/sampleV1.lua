local function helperFn(arg1, arg2, arg3)
    if type(arg1) == "table" then
        return pairs(arg1)
    end
    return arg1, arg2, arg3
end
if not shared then
    return warn("No shared, no script.")
end
local stateMap = {}
stateMap[134196333708867] = "Da Strike"
stateMap[71324444457408] = "Da Uphill"
stateMap[139144803593140] = "Da Downhill"
local val = stateMap
if not val[game.PlaceId] then
    return warn("[Potent Strike] Unsupported game. Supported: Da Strike, Da Uphill, Da Downhill.")
end
if shared.PotentHood then
    pcall(shared.PotentHood.detach)
end
if shared.PotentRage then
    pcall(shared.PotentRage.detach)
end
if shared.PotentStrike then
    pcall(shared.PotentStrike.detach)
end
local stateMap2 = {}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local stateMap3 = {}
stateMap3[2] = "HumanoidRootPart"
stateMap3[3] = "UpperTorso"
stateMap3[1] = "Head"
stateMap3[4] = "LowerTorso"
local val2 = stateMap3
local val3 = Color3.fromRGB(255, 60, 60)
local val4 = Color3.fromRGB(60, 255, 120)
local val5 = Color3.fromRGB(70, 140, 255)
local val6 = Color3.fromRGB(60, 220, 90)
local val7 = Color3.fromRGB(160, 110, 255)
local val8 = Color3.fromRGB(255, 255, 255)
local items = {"K.O", "KO", "Knocked", "Downed"}
local stateMap4 = {}
local stateMap5 = {}
stateMap5[2] = "LowerTorso"
stateMap5[1] = "UpperTorso"
local stateMap6 = {}
stateMap6[2] = "LeftUpperArm"
stateMap6[1] = "UpperTorso"
local stateMap7 = {}
stateMap7[2] = "LeftLowerArm"
stateMap7[1] = "LeftUpperArm"
local stateMap8 = {}
stateMap8[2] = "RightUpperArm"
stateMap8[1] = "UpperTorso"
local stateMap9 = {}
stateMap9[2] = "RightHand"
stateMap9[1] = "RightLowerArm"
local stateMap10 = {}
stateMap10[2] = "LeftFoot"
stateMap10[1] = "LeftLowerLeg"
local stateMap11 = {}
stateMap11[2] = "RightLowerLeg"
stateMap11[1] = "RightUpperLeg"
stateMap4[9] = {"LowerTorso", "LeftUpperLeg"}
stateMap4[13] = stateMap11
stateMap4[14] = {"RightLowerLeg", "RightFoot"}
stateMap4[6] = stateMap8
stateMap4[3] = stateMap6
stateMap4[10] = {"LeftUpperLeg", "LeftLowerLeg"}
stateMap4[11] = stateMap10
stateMap4[1] = {"Head", "UpperTorso"}
stateMap4[5] = {"LeftLowerArm", "LeftHand"}
stateMap4[2] = stateMap5
stateMap4[8] = stateMap9
stateMap4[4] = stateMap7
stateMap4[7] = {"RightUpperArm", "RightLowerArm"}
stateMap4[12] = {"LowerTorso", "RightUpperLeg"}
local val9 = stateMap4
local stateMap12 = {}
local stateMap13 = {}
stateMap12[1] = "Head"
stateMap12[2] = "Torso"
local stateMap14 = {}
stateMap14[2] = "Right Arm"
stateMap14[1] = "Torso"
stateMap13[3] = stateMap14
stateMap13[2] = {"Torso", "Left Arm"}
stateMap13[5] = {"Torso", "Right Leg"}
stateMap13[4] = {"Torso", "Left Leg"}
stateMap13[1] = stateMap12
local val10 = stateMap13
local val11 = (function()
    local UserInputService2 = game:GetService("UserInputService")
    local TweenService2 = game:GetService("TweenService")
    local CoreGui2 = game:GetService("CoreGui")
    local HttpService2 = game:GetService("HttpService")
    local code = Enum.Font.Code
    local val11 = TweenInfo.new(0.1, Enum.EasingStyle.Quad)
    local stateMap15 = {}
    stateMap15.window = Color3.fromRGB(18, 18, 18)
    stateMap15.panel = Color3.fromRGB(24, 24, 24)
    stateMap15.border = Color3.fromRGB(48, 48, 48)
    stateMap15.frame = Color3.fromRGB(34, 34, 34)
    stateMap15.frameHover = Color3.fromRGB(48, 48, 48)
    stateMap15.popup = Color3.fromRGB(22, 22, 22)
    stateMap15.text = Color3.fromRGB(220, 220, 220)
    stateMap15.dim = Color3.fromRGB(140, 140, 140)
    local val12 = stateMap15
    local val13 = Color3.fromRGB(245, 130, 185)
    local stateMap16 = {}
    local stateMap17 = {}
    stateMap17.__index = stateMap17
    stateMap17.colors = val12
    local stateMap18 = {}
    stateMap18.__index = stateMap18
    local stateMap19 = {}
    stateMap19.__index = stateMap19
    local stateMap20 = {}
    stateMap20.__index = stateMap20
    local function helperFn2()

    end
    local function helperFn3(arg1, arg2, arg3)
        local val14 = Instance.new(arg1)
        if val14:IsA("GuiObject") then
            val14.BorderSizePixel = 0
        end
        local val15 = val14:IsA("TextLabel") or val14:IsA("TextButton")
        if val15 then
            val14.Font = code
            val14.TextSize = 13
            val14.TextColor3 = val12.text
        end
        for key, item in pairs(arg2) do
            val14[key] = item
        end
        val14.Parent = arg3
        return val14
    end
    stateMap17.create = helperFn3
    local function helperFn4(arg1, arg2, arg3, arg4, arg5)
        local stateMap21 = {}
        stateMap21.BackgroundTransparency = 1
        stateMap21.Text = arg2
        stateMap21.TextColor3 = arg5 or val12.text
        stateMap21.TextXAlignment = Enum.TextXAlignment.Left
        stateMap21.Position = arg3
        stateMap21.Size = arg4
        local val14 = helperFn3("TextLabel", stateMap21, arg1)
        return val14
    end
    local function helperFn5(arg1, arg2, arg3, arg4)
        arg1.MouseEnter:Connect(function()
            local stateMap21 = {}
            stateMap21.BackgroundColor3 = arg4
            local val14 = TweenService2:Create(arg2, val11, stateMap21)
            val14:Play()
        end)
        arg1.MouseLeave:Connect(function()
            local stateMap21 = {}
            stateMap21.BackgroundColor3 = arg3
            local val14 = TweenService2:Create(arg2, val11, stateMap21)
            val14:Play()
        end)
    end
    local function helperFn6(input)
        return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
    end
    local function helperFn7(arg1, arg2)
        local stateMap21 = {}
        stateMap21.CornerRadius = UDim.new(0, 3)
        helperFn3("UICorner", stateMap21, arg1)
        local stateMap22 = {}
        stateMap22.Thickness = 1
        stateMap22.Transparency = 0.6
        local val14 = helperFn3("UIStroke", stateMap22, arg1)
        local text = "Color"
        local function helperFn8(arg12)
            val14[text] = arg12
        end
        helperFn8(val13)
        table.insert(stateMap16, helperFn8)
        helperFn5(arg1, arg1, val12.frame, val12.frameHover)
        local val15 = arg2
        local mouseButton1Click = arg1.MouseButton1Click
        if not val15 then
            val15 = helperFn2
        end
        mouseButton1Click:Connect(val15)
        return arg1
    end
    stateMap17.makeButton = function(arg1, arg2, arg3)
        local stateMap21 = {}
        stateMap21.BackgroundColor3 = val12.frame
        stateMap21.Text = arg2
        stateMap21.AutoButtonColor = false
        local val14 = helperFn3("TextButton", stateMap21, arg1)
        local val15 = helperFn7(val14, arg3)
        return val15
    end
    stateMap17.setAccent = function(arg1)
        for _, item in ipairs(stateMap16) do
            pcall(item, arg1)
        end
    end
    stateMap17.getAccent = function()
        return val13
    end
    stateMap17.inputMatches = function(input, arg2)
        if not arg2 then
            return false
        end
        if arg2.EnumType == Enum.KeyCode then
            return input.KeyCode == arg2
        end
        return input.UserInputType == arg2
    end
    stateMap17.isBindHeld = function(arg1)
        if not arg1 then
            return false
        end
        if arg1.EnumType == Enum.KeyCode then
            return UserInputService2:IsKeyDown(arg1)
        end
        return UserInputService2:IsMouseButtonPressed(arg1)
    end
    stateMap19.new = function(arg1)
        local stateMap21 = {}
        stateMap21.value = arg1
        return setmetatable(stateMap21, stateMap19)
    end
    stateMap19.get = function(arg1)
        return arg1.value
    end
    stateMap19.set = function(arg1, arg2)
        arg1.apply(arg2)
    end
    local function helperFn8(arg1, arg2, arg3, arg4)
        local val14 = arg4
        local stateMap21 = {}
        val14 = val14 or helperFn2
        stateMap21.BackgroundTransparency = 1
        stateMap21.AutomaticSize = Enum.AutomaticSize.X
        stateMap21.AnchorPoint = Vector2.new(1, 0)
        stateMap21.Position = UDim2.fromScale(1, 0)
        stateMap21.Size = UDim2.new(0, 0, 1, 0)
        stateMap21.Text = ""
        stateMap21.AutoButtonColor = false
        local val15 = helperFn3("TextButton", stateMap21, arg2)
        local val16 = stateMap19.new(arg3)
        val16.render = function()
            val15.Text = "[" .. (val16.value and val16.value.Name or "none") .. "]"
            val15.TextColor3 = val12.dim
        end
        val16.apply = function(arg12)
            val16.value = arg12
            val16.render()
            val14(arg12)
        end
        val15.MouseButton1Click:Connect(function()
            if arg1.listening and arg1.listening ~= val16 then
                arg1.listening.render()
            end
            arg1.listening = val16
            val15.Text = "[...]"
            val15.TextColor3 = val13
        end)
        val16:set(arg3)
        return val16, val15
    end
    stateMap18.new = function(arg1, arg2)
        local stateMap21 = {}
        stateMap21.window = arg1
        stateMap21.frame = arg2
        stateMap21.order = 0
        return setmetatable(stateMap21, stateMap18)
    end
    stateMap18.nextOrder = function(arg1)
        arg1.order = arg1.order + 1
        return arg1.order
    end
    stateMap18.item = function(arg1, arg2, arg3)
        local stateMap21 = {}
        stateMap21.Size = UDim2.new(1, 0, 0, 20)
        stateMap21.BackgroundTransparency = 1
        local val14 = arg1:nextOrder()
        stateMap21.LayoutOrder = val14
        local val15 = helperFn3(arg2, stateMap21)
        for key, item in pairs(arg3 or {}) do
            val15[key] = item
        end
        val15.Parent = arg1.frame
        return val15
    end
    stateMap18.text = function(arg1, arg2, arg3)
        local stateMap21 = {}
        stateMap21.Text = arg2
        stateMap21.TextColor3 = arg3 or val12.dim
        stateMap21.TextWrapped = true
        stateMap21.TextXAlignment = Enum.TextXAlignment.Left
        stateMap21.Size = UDim2.new(1, 0, 0, 0)
        stateMap21.AutomaticSize = Enum.AutomaticSize.Y
        return arg1:item("TextLabel", stateMap21)
    end
    stateMap18.button = function(arg1, arg2, arg3)
        local stateMap21 = {}
        stateMap21.BackgroundTransparency = 0
        stateMap21.BackgroundColor3 = val12.frame
        stateMap21.Text = arg2
        stateMap21.AutoButtonColor = false
        local val14 = arg1:item("TextButton", stateMap21)
        local val15 = helperFn7(val14, arg3)
        return val15
    end
    stateMap18.checkbox = function(arg1, arg2, arg3, arg4)
        local val14 = arg4
        val14 = val14 or helperFn2
        local window = arg1.window
        local stateMap21 = {}
        stateMap21.Text = ""
        stateMap21.AutoButtonColor = false
        local val15 = arg1:item("TextButton", stateMap21)
        local stateMap22 = {}
        stateMap22.Size = UDim2.fromOffset(12, 12)
        stateMap22.Position = UDim2.fromOffset(0, 4)
        stateMap22.BackgroundColor3 = val12.frame
        local val16 = helperFn3("Frame", stateMap22, val15)
        local stateMap23 = {}
        stateMap23.Color = val12.border
        stateMap23.Thickness = 1
        helperFn3("UIStroke", stateMap23, val16)
        helperFn4(val15, arg2, UDim2.fromOffset(20, 0), UDim2.new(1, -20, 1, 0))
        local val17 = stateMap19.new(arg3 and true or false)
        val17.apply = function(arg12)
            val17.value = arg12 and true or false
            local stateMap24 = {}
            stateMap24.BackgroundColor3 = val17.value and val13 or val12.frame
            local val18 = TweenService2:Create(val16, val11, stateMap24)
            val18:Play()
            val14(val17.value)
        end
        val17.bind = function(arg12, arg22, arg32)
            local val18 = helperFn8(window, val15, arg22, arg32)
            return val18
        end
        local function helperFn9(arg12)
            if val17.value then
                val16.BackgroundColor3 = arg12
            end
        end
        helperFn9(val13)
        table.insert(stateMap16, helperFn9)
        val15.MouseButton1Click:Connect(function()
            val17:set(not val17.value)
        end)
        val17:set(val17.value)
        return val17
    end
    stateMap18.slider = function(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
        local val14 = arg6
        val14 = val14 or helperFn2
        arg7 = arg7 or {}
        local step = arg7.step or 0
        local format = arg7.format or (step >= 1 and "%d" or "%.2f")
        local stateMap21 = {}
        stateMap21.Size = UDim2.new(1, 0, 0, 34)
        local val15 = arg1:item("Frame", stateMap21)
        helperFn4(val15, arg2, UDim2.new(), UDim2.new(1, 0, 0, 14))
        local stateMap22 = {}
        stateMap22.Position = UDim2.fromOffset(0, 16)
        stateMap22.Size = UDim2.new(1, 0, 0, 14)
        stateMap22.BackgroundColor3 = val12.frame
        local val16 = helperFn3("Frame", stateMap22, val15)
        local stateMap23 = {}
        stateMap23.Size = UDim2.fromScale(0, 1)
        local val17 = helperFn3("Frame", stateMap23, val16)
        local val18 = val17
        local text = "BackgroundColor3"
        local function helperFn9(arg12)
            val18[text] = arg12
        end
        helperFn9(val13)
        table.insert(stateMap16, helperFn9)
        local stateMap24 = {}
        stateMap24.BackgroundTransparency = 1
        stateMap24.Size = UDim2.fromScale(1, 1)
        stateMap24.TextSize = 12
        stateMap24.ZIndex = 2
        local val19 = helperFn3("TextLabel", stateMap24, val16)
        local val20 = stateMap19.new(arg5)
        val20.apply = function(arg12)
            if step > 0 then
                arg12 = math.floor(arg12 / step + 0.5) * step
            end
            arg12 = math.clamp(arg12, arg3, arg4)
            val20.value = arg12
            val17.Size = UDim2.fromScale((arg12 - arg3) / (arg4 - arg3), 1)
            local val21 = string.format(format, arg12)
            local val22 = "/" .. tostring(arg4)
            val19.Text = val21 .. val22
            val14(arg12)
        end
        local function helperFn10(arg12)
            local val21 = (arg4 - arg3) * math.clamp((arg12 - val16.AbsolutePosition.X) / val16.AbsoluteSize.X, 0, 1)
            val20:set(arg3 + val21)
        end
        val16.InputBegan:Connect(function(input)
            local val21 = helperFn6(input)
            if not val21 then
                return
            end
            arg1.window.drag = function(arg12)
                helperFn10(arg12.X)
            end
            helperFn10(input.Position.X)
        end)
        val20:set(arg5)
        return val20
    end
    stateMap18.combo = function(arg1, arg2, arg3, arg4, arg5)
        local val14 = arg5
        val14 = val14 or helperFn2
        local window = arg1.window
        local stateMap21 = {}
        stateMap21.Size = UDim2.new(1, 0, 0, 40)
        local val15 = arg1:item("Frame", stateMap21)
        helperFn4(val15, arg2, UDim2.new(), UDim2.new(1, 0, 0, 14))
        local stateMap22 = {}
        stateMap22.Position = UDim2.fromOffset(0, 16)
        stateMap22.Size = UDim2.new(1, 0, 0, 22)
        stateMap22.BackgroundColor3 = val12.frame
        stateMap22.Text = ""
        stateMap22.AutoButtonColor = false
        local val16 = helperFn3("TextButton", stateMap22, val15)
        local stateMap23 = {}
        stateMap23.CornerRadius = UDim.new(0, 3)
        helperFn3("UICorner", stateMap23, val16)
        local val17 = helperFn4(val16, "", UDim2.fromOffset(6, 0), UDim2.new(1, -24, 1, 0))
        local stateMap24 = {}
        stateMap24.BackgroundTransparency = 1
        stateMap24.Text = "v"
        stateMap24.TextColor3 = val12.dim
        stateMap24.Position = UDim2.new(1, -18, 0, 0)
        stateMap24.Size = UDim2.new(0, 12, 1, 0)
        helperFn3("TextLabel", stateMap24, val16)
        helperFn5(val16, val16, val12.frame, val12.frameHover)
        local val18 = stateMap19.new(arg4)
        val18.apply = function(arg12)
            val18.value = arg12
            val17.Text = tostring(arg12)
            val14(arg12)
        end
        val16.MouseButton1Click:Connect(function()
            local val19 = type(arg3)
            local val20 = val19 == "function" and arg3() or arg3
            local stateMap25 = {}
            stateMap25.Size = UDim2.fromScale(1, 1)
            stateMap25.BackgroundTransparency = 1
            stateMap25.Text = ""
            stateMap25.AutoButtonColor = false
            stateMap25.ZIndex = 50
            local val21 = helperFn3("TextButton", stateMap25, window.gui)
            local stateMap26 = {}
            stateMap26.Position = UDim2.fromOffset(val16.AbsolutePosition.X, val16.AbsolutePosition.Y + val16.AbsoluteSize.Y + 2)
            local x = val16.AbsoluteSize.X
            local val22 = math.max(math.min(#val20, 8), 1) * 20
            stateMap26.Size = UDim2.fromOffset(x, val22)
            stateMap26.CanvasSize = UDim2.fromOffset(0, #val20 * 20)
            stateMap26.ScrollBarThickness = 3
            stateMap26.BackgroundColor3 = val12.popup
            stateMap26.Active = true
            stateMap26.ZIndex = 51
            local val23 = helperFn3("ScrollingFrame", stateMap26, val21)
            local stateMap27 = {}
            stateMap27.CornerRadius = UDim.new(0, 3)
            helperFn3("UICorner", stateMap27, val23)
            local stateMap28 = {}
            stateMap28.Color = val12.border
            stateMap28.Thickness = 1
            helperFn3("UIStroke", stateMap28, val23)
            for idx, item in ipairs(val20) do
                local val24 = item == val18.value
                local val25 = val24 and val12.frameHover or val12.popup
                local stateMap29 = {}
                stateMap29.Size = UDim2.new(1, -4, 0, 20)
                stateMap29.Position = UDim2.fromOffset(0, (idx - 1) * 20)
                stateMap29.BackgroundColor3 = val25
                local val26 = " " .. tostring(item)
                stateMap29.Text = val26
                stateMap29.TextColor3 = val24 and val13 or val12.text
                stateMap29.TextXAlignment = Enum.TextXAlignment.Left
                stateMap29.AutoButtonColor = false
                stateMap29.ZIndex = 52
                local val27 = helperFn3("TextButton", stateMap29, val23)
                local val28 = val27
                local val29 = val25
                local frameHover = val12.frameHover
                val27.MouseEnter:Connect(function()
                    local stateMap30 = {}
                    stateMap30.BackgroundColor3 = frameHover
                    local val30 = TweenService2:Create(val28, val11, stateMap30)
                    val30:Play()
                end)
                val27.MouseLeave:Connect(function()
                    local stateMap30 = {}
                    stateMap30.BackgroundColor3 = val29
                    local val30 = TweenService2:Create(val28, val11, stateMap30)
                    val30:Play()
                end)
                val27.MouseButton1Click:Connect(function()
                    val18:set(item)
                    val21:Destroy()
                end)
            end
            val21.MouseButton1Click:Connect(function()
                val21:Destroy()
            end)
        end)
        val18:set(arg4)
        return val18
    end
    stateMap18.colorpicker = function(arg1, arg2, arg3, arg4)
        local val14 = arg4
        val14 = val14 or helperFn2
        local window = arg1.window
        local val15 = arg1:item("Frame")
        helperFn4(val15, arg2, UDim2.new(), UDim2.new(1, -44, 1, 0))
        local stateMap21 = {}
        stateMap21.AnchorPoint = Vector2.new(1, 0.5)
        stateMap21.Position = UDim2.new(1, 0, 0.5, 0)
        stateMap21.Size = UDim2.fromOffset(34, 14)
        stateMap21.Text = ""
        stateMap21.AutoButtonColor = false
        local val16 = helperFn3("TextButton", stateMap21, val15)
        local stateMap22 = {}
        stateMap22.CornerRadius = UDim.new(0, 3)
        helperFn3("UICorner", stateMap22, val16)
        local stateMap23 = {}
        stateMap23.Color = val12.border
        stateMap23.Thickness = 1
        helperFn3("UIStroke", stateMap23, val16)
        local val17 = stateMap19.new(arg3)
        local val18, val19, val20 = arg3:ToHSV()
        local val21 = nil
        local function helperFn9(arg12)
            val17.value = arg12
            val16.BackgroundColor3 = arg12
            val14(arg12)
            if val21 then
                val21()
            end
        end
        val17.apply = function(arg12)
            val18, val19, val20 = arg12:ToHSV()
            val17.value = arg12
            val16.BackgroundColor3 = arg12
            val14(arg12)
            if val21 then
                val21()
            end
        end
        val16.MouseButton1Click:Connect(function()
            local stateMap24 = {}
            stateMap24.Size = UDim2.fromScale(1, 1)
            stateMap24.BackgroundTransparency = 1
            stateMap24.Text = ""
            stateMap24.AutoButtonColor = false
            stateMap24.ZIndex = 50
            local val22 = helperFn3("TextButton", stateMap24, window.gui)
            local absoluteSize = window.gui.AbsoluteSize
            local val23 = math.clamp(val16.AbsolutePosition.X + val16.AbsoluteSize.X - 200, 4, absoluteSize.X - 200 - 4)
            local val24 = val16.AbsolutePosition.Y + val16.AbsoluteSize.Y + 6
            local val25 = val24 + 158
            if val25 > absoluteSize.Y - 4 then
                val24 = val16.AbsolutePosition.Y - 158 - 6
            end
            local stateMap25 = {}
            stateMap25.Position = UDim2.fromOffset(val23, val24)
            stateMap25.Size = UDim2.fromOffset(200, 158)
            stateMap25.BackgroundColor3 = val12.popup
            stateMap25.Active = true
            stateMap25.ZIndex = 51
            local val26 = helperFn3("Frame", stateMap25, val22)
            local stateMap26 = {}
            stateMap26.CornerRadius = UDim.new(0, 5)
            helperFn3("UICorner", stateMap26, val26)
            local stateMap27 = {}
            stateMap27.Color = val12.border
            stateMap27.Thickness = 1
            helperFn3("UIStroke", stateMap27, val26)
            local stateMap28 = {}
            stateMap28.Position = UDim2.fromOffset(10, 10)
            stateMap28.Size = UDim2.fromOffset(180, 112)
            stateMap28.BackgroundColor3 = Color3.fromHSV(val18, 1, 1)
            stateMap28.ZIndex = 52
            local val27 = helperFn3("Frame", stateMap28, val26)
            local stateMap29 = {}
            stateMap29.Size = UDim2.fromScale(1, 1)
            stateMap29.BackgroundColor3 = Color3.new(1, 1, 1)
            stateMap29.ZIndex = 53
            local val28 = helperFn3("Frame", stateMap29, val27)
            local stateMap30 = {}
            local val29 = NumberSequence.new(0, 1)
            stateMap30.Transparency = val29
            helperFn3("UIGradient", stateMap30, val28)
            local stateMap31 = {}
            stateMap31.Size = UDim2.fromScale(1, 1)
            stateMap31.BackgroundColor3 = Color3.new(0, 0, 0)
            stateMap31.ZIndex = 54
            local val30 = helperFn3("Frame", stateMap31, val27)
            local stateMap32 = {}
            local val31 = NumberSequence.new(1, 0)
            stateMap32.Transparency = val31
            stateMap32.Rotation = 90
            helperFn3("UIGradient", stateMap32, val30)
            local stateMap33 = {}
            stateMap33.AnchorPoint = Vector2.new(0.5, 0.5)
            stateMap33.Size = UDim2.fromOffset(8, 8)
            stateMap33.BackgroundTransparency = 1
            stateMap33.ZIndex = 55
            local val32 = helperFn3("Frame", stateMap33, val27)
            local stateMap34 = {}
            stateMap34.CornerRadius = UDim.new(0, 4)
            helperFn3("UICorner", stateMap34, val32)
            local stateMap35 = {}
            stateMap35.Color = Color3.new(1, 1, 1)
            stateMap35.Thickness = 2
            helperFn3("UIStroke", stateMap35, val32)
            local stateMap36 = {}
            stateMap36.Position = UDim2.fromOffset(10, 132)
            stateMap36.Size = UDim2.fromOffset(180, 10)
            stateMap36.BackgroundColor3 = Color3.new(1, 1, 1)
            stateMap36.ZIndex = 52
            local val33 = helperFn3("Frame", stateMap36, val26)
            local stateMap37 = {}
            for i = 0, 6 do
                table.insert(stateMap37, ColorSequenceKeypoint.new(i / 6, Color3.fromHSV(i / 6, 1, 1)))
            end
            local stateMap38 = {}
            local val34 = ColorSequence.new(stateMap37)
            stateMap38.Color = val34
            helperFn3("UIGradient", stateMap38, val33)
            local stateMap39 = {}
            stateMap39.AnchorPoint = Vector2.new(0.5, 0.5)
            stateMap39.Size = UDim2.fromOffset(6, 14)
            stateMap39.BackgroundTransparency = 1
            stateMap39.ZIndex = 55
            local val35 = helperFn3("Frame", stateMap39, val33)
            local stateMap40 = {}
            stateMap40.Color = Color3.new(1, 1, 1)
            stateMap40.Thickness = 2
            helperFn3("UIStroke", stateMap40, val35)
            local function helperFn10()
                val27.BackgroundColor3 = Color3.fromHSV(val18, 1, 1)
                val32.Position = UDim2.fromScale(val19, 1 - val20)
                val35.Position = UDim2.fromScale(val18, 0.5)
            end
            val21 = helperFn10
            local function helperFn11()
                local val36 = UserInputService2:GetMouseLocation()
                local val37 = math.clamp((val36.X - val27.AbsolutePosition.X) / val27.AbsoluteSize.X, 0, 1)
                local val38 = 1 - math.clamp((val36.Y - val27.AbsolutePosition.Y) / val27.AbsoluteSize.Y, 0, 1)
                local val39 = val18
                val20 = val38
                val18 = val39
                val19 = val37
                helperFn9(Color3.fromHSV(val39, val37, val38))
            end
            local function helperFn12()
                local val36 = UserInputService2:GetMouseLocation()
                local val37 = math.clamp((val36.X - val33.AbsolutePosition.X) / val33.AbsoluteSize.X, 0, 1)
                local val38 = val19
                local val39 = val20
                val18 = val37
                val19 = val38
                val20 = val39
                helperFn9(Color3.fromHSV(val37, val38, val39))
            end
            val27.InputBegan:Connect(function(input)
                local val36 = helperFn6(input)
                if not val36 then
                    return
                end
                window.drag = helperFn11
                helperFn11()
            end)
            val33.InputBegan:Connect(function(input)
                local val36 = helperFn6(input)
                if not val36 then
                    return
                end
                window.drag = helperFn12
                helperFn12()
            end)
            val22.MouseButton1Click:Connect(function()
                val22:Destroy()
            end)
            val22.Destroying:Connect(function()
                val21 = nil
            end)
            helperFn10()
        end)
        val17:set(arg3)
        return val17
    end
    stateMap18.keybind = function(arg1, arg2, arg3, arg4)
        local val14 = arg1:item("Frame")
        helperFn4(val14, arg2, UDim2.new(), UDim2.new(1, -90, 1, 0))
        local val15 = helperFn8(arg1.window, val14, arg3, arg4)
        return val15
    end
    stateMap20.group = function(arg1, arg2, arg3)
        local val14 = arg1.columns[arg3 or 1]
        val14.order = val14.order + 1
        local stateMap21 = {}
        stateMap21.Size = UDim2.new(1, 0, 0, 0)
        stateMap21.AutomaticSize = Enum.AutomaticSize.Y
        stateMap21.BackgroundColor3 = val12.panel
        stateMap21.LayoutOrder = val14.order
        local val15 = helperFn3("Frame", stateMap21, val14.frame)
        local stateMap22 = {}
        stateMap22.CornerRadius = UDim.new(0, 3)
        helperFn3("UICorner", stateMap22, val15)
        local stateMap23 = {}
        stateMap23.Color = val12.border
        stateMap23.Thickness = 1
        helperFn3("UIStroke", stateMap23, val15)
        local stateMap24 = {}
        stateMap24.Padding = UDim.new(0, 4)
        stateMap24.SortOrder = Enum.SortOrder.LayoutOrder
        helperFn3("UIListLayout", stateMap24, val15)
        local stateMap25 = {}
        stateMap25.PaddingTop = UDim.new(0, 6)
        stateMap25.PaddingBottom = UDim.new(0, 8)
        stateMap25.PaddingLeft = UDim.new(0, 8)
        stateMap25.PaddingRight = UDim.new(0, 8)
        helperFn3("UIPadding", stateMap25, val15)
        local stateMap26 = {}
        stateMap26.BackgroundTransparency = 1
        stateMap26.Text = arg2
        stateMap26.TextXAlignment = Enum.TextXAlignment.Left
        stateMap26.Size = UDim2.new(1, 0, 0, 16)
        stateMap26.LayoutOrder = -2
        helperFn3("TextLabel", stateMap26, val15)
        local stateMap27 = {}
        stateMap27.Size = UDim2.new(1, 0, 0, 1)
        stateMap27.LayoutOrder = -1
        local val16 = helperFn3("Frame", stateMap27, val15)
        local text = "BackgroundColor3"
        local function helperFn9(arg12)
            val16[text] = arg12
        end
        helperFn9(val13)
        table.insert(stateMap16, helperFn9)
        return stateMap18.new(arg1.window, val15)
    end
    stateMap17.new = function(input, arg2)
        local val14 = setmetatable({}, stateMap17)
        val14.connections = {}
        val14.inputHandlers = {}
        val14.tabs = {}
        val14.tabNames = {}
        val14.activeTab = nil
        val14.drag = nil
        val14.listening = nil
        stateMap16 = {}
        arg2 = arg2 or Vector2.new(720, 480)
        local val15 = gethui and gethui() or CoreGui2
        local stateMap21 = {}
        local val16 = HttpService2:GenerateGUID(false)
        stateMap21.Name = val16
        stateMap21.ResetOnSpawn = false
        stateMap21.IgnoreGuiInset = true
        stateMap21.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        stateMap21.DisplayOrder = 999
        local val17 = helperFn3("ScreenGui", stateMap21, val15)
        val14.gui = val17
        local stateMap22 = {}
        stateMap22.Size = UDim2.fromOffset(arg2.X, arg2.Y)
        stateMap22.Position = UDim2.new(0.5, -arg2.X / 2, 0.5, -arg2.Y / 2)
        stateMap22.BackgroundColor3 = val12.window
        stateMap22.ClipsDescendants = true
        local val18 = helperFn3("Frame", stateMap22, val14.gui)
        local stateMap23 = {}
        stateMap23.CornerRadius = UDim.new(0, 4)
        helperFn3("UICorner", stateMap23, val18)
        local stateMap24 = {}
        stateMap24.Thickness = 1.5
        stateMap24.Transparency = 0.35
        local val19 = helperFn3("UIStroke", stateMap24, val18)
        local text = "Color"
        local function helperFn9(arg1)
            val19[text] = arg1
        end
        helperFn9(val13)
        table.insert(stateMap16, helperFn9)
        val14.main = val18
        local stateMap25 = {}
        stateMap25.Size = UDim2.new(1, 0, 0, 22)
        stateMap25.BackgroundTransparency = 1
        stateMap25.Active = true
        local val20 = helperFn3("Frame", stateMap25, val18)
        local stateMap26 = {}
        stateMap26.BackgroundTransparency = 1
        stateMap26.Text = input
        stateMap26.TextColor3 = val12.dim
        stateMap26.TextSize = 12
        stateMap26.Size = UDim2.fromScale(1, 1)
        helperFn3("TextLabel", stateMap26, val20)
        val20.InputBegan:Connect(function(input2)
            if input2.UserInputType ~= Enum.UserInputType.MouseButton1 then
                return
            end
            local position = input2.Position
            local position2 = val18.Position
            val14.drag = function(arg1)
                local val21 = arg1 - position
                val18.Position = UDim2.new(position2.X.Scale, position2.X.Offset + val21.X, position2.Y.Scale, position2.Y.Offset + val21.Y)
            end
        end)
        local stateMap27 = {}
        stateMap27.Position = UDim2.fromOffset(6, 24)
        stateMap27.Size = UDim2.new(1, -12, 0, 26)
        stateMap27.BackgroundTransparency = 1
        local val21 = helperFn3("Frame", stateMap27, val18)
        val14.tabBar = val21
        local stateMap28 = {}
        stateMap28.FillDirection = Enum.FillDirection.Horizontal
        stateMap28.Padding = UDim.new(0, 4)
        stateMap28.SortOrder = Enum.SortOrder.LayoutOrder
        helperFn3("UIListLayout", stateMap28, val14.tabBar)
        val14:track(UserInputService2.InputBegan:Connect(function(input2, gameProcessed)
            val14:handleInput(input2, gameProcessed)
        end))
        val14:track(UserInputService2.InputChanged:Connect(function(input2)
            if not val14.drag then
                return
            end
            if input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch then
                val14.drag(input2.Position)
            end
        end))
        val14:track(UserInputService2.InputEnded:Connect(function(input2)
            local val22 = helperFn6(input2)
            if val22 then
                val14.drag = nil
            end
        end))
        return val14
    end
    stateMap17.track = function(arg1, arg2)
        table.insert(arg1.connections, arg2)
        return arg2
    end
    stateMap17.onInput = function(arg1, arg2)
        table.insert(arg1.inputHandlers, arg2)
    end
    stateMap17.handleInput = function(input, arg2, arg3)
        local listening = input.listening
        if listening then
            if arg2.UserInputType == Enum.UserInputType.Keyboard then
                if arg2.KeyCode == Enum.KeyCode.Escape then
                    input.listening = nil
                    listening.render()
                    return
                end
                local val14 = arg2.KeyCode ~= Enum.KeyCode.Backspace and arg2.KeyCode or nil
                input.listening = nil
                listening:set(val14)
                return
            end
            if arg2.UserInputType == Enum.UserInputType.MouseButton2 or arg2.UserInputType == Enum.UserInputType.MouseButton3 then
                local userInputType = arg2.UserInputType
                input.listening = nil
                listening:set(userInputType)
                return
            end
            if arg2.UserInputType == Enum.UserInputType.MouseButton1 then
                input.listening = nil
                listening.render()
            end
            return
        end
        for _, item in ipairs(input.inputHandlers) do
            item(arg2, arg3)
        end
    end
    stateMap17.selectTab = function(arg1, arg2)
        arg1.activeTab = arg2
        for key, item in pairs(arg1.tabs) do
            local val14 = key == arg2
            item.page.Visible = val14
            item.line.Visible = val14
            item.button.TextColor3 = val14 and Color3.new(1, 1, 1) or val12.dim
            local stateMap21 = {}
            local button = item.button
            stateMap21.BackgroundColor3 = val14 and val12.frameHover or val12.frame
            local val15 = TweenService2:Create(button, val11, stateMap21)
            val15:Play()
        end
    end
    stateMap17.tab = function(arg1, arg2, arg3)
        local val14 = nil
        local val15
        if arg3 then
            local stateMap21 = {}
            stateMap21.Position = UDim2.fromOffset(6, 56)
            stateMap21.Size = UDim2.new(1, -12, 1, -62)
            stateMap21.BackgroundTransparency = 1
            stateMap21.Visible = false
            val15 = helperFn3("Frame", stateMap21, arg1.main)
        else
            local stateMap21 = {}
            stateMap21.Position = UDim2.fromOffset(6, 56)
            stateMap21.Size = UDim2.new(1, -12, 1, -62)
            stateMap21.BackgroundTransparency = 1
            stateMap21.ScrollBarThickness = 3
            stateMap21.CanvasSize = UDim2.new()
            stateMap21.AutomaticCanvasSize = Enum.AutomaticSize.Y
            stateMap21.Visible = false
            val15 = helperFn3("ScrollingFrame", stateMap21, arg1.main)
            local val16 = val15
            local text = "ScrollBarImageColor3"
            local function helperFn9(arg12)
                val16[text] = arg12
            end
            helperFn9(val13)
            table.insert(stateMap16, helperFn9)
            local stateMap22 = {}
            stateMap22.Size = UDim2.new(1, -6, 0, 0)
            stateMap22.AutomaticSize = Enum.AutomaticSize.Y
            stateMap22.BackgroundTransparency = 1
            local val17 = helperFn3("Frame", stateMap22, val15)
            local stateMap23 = {}
            stateMap23.FillDirection = Enum.FillDirection.Horizontal
            stateMap23.Padding = UDim.new(0, 8)
            stateMap23.SortOrder = Enum.SortOrder.LayoutOrder
            helperFn3("UIListLayout", stateMap23, val17)
            val14 = {}
            for i = 1, 3 do
                local stateMap24 = {}
                stateMap24.Size = UDim2.new(0.3333333333333333, -6, 0, 0)
                stateMap24.AutomaticSize = Enum.AutomaticSize.Y
                stateMap24.BackgroundTransparency = 1
                stateMap24.LayoutOrder = i
                local val18 = helperFn3("Frame", stateMap24, val17)
                local stateMap25 = {}
                stateMap25.Padding = UDim.new(0, 8)
                stateMap25.SortOrder = Enum.SortOrder.LayoutOrder
                helperFn3("UIListLayout", stateMap25, val18)
                local stateMap26 = {}
                stateMap26.frame = val18
                stateMap26.order = 0
                val14[i] = stateMap26
            end
        end
        table.insert(arg1.tabNames, arg2)
        local stateMap21 = {}
        stateMap21.Size = UDim2.new(1, 0, 1, 0)
        stateMap21.BackgroundColor3 = val12.frame
        stateMap21.Text = arg2
        stateMap21.TextColor3 = val12.dim
        stateMap21.AutoButtonColor = false
        stateMap21.LayoutOrder = #arg1.tabNames
        local val16 = helperFn3("TextButton", stateMap21, arg1.tabBar)
        local stateMap22 = {}
        stateMap22.CornerRadius = UDim.new(0, 3)
        helperFn3("UICorner", stateMap22, val16)
        local stateMap23 = {}
        stateMap23.AnchorPoint = Vector2.new(0, 1)
        stateMap23.Position = UDim2.fromScale(0, 1)
        stateMap23.Size = UDim2.new(1, 0, 0, 2)
        stateMap23.Visible = false
        local val17 = helperFn3("Frame", stateMap23, val16)
        local val18 = val17
        local text = "BackgroundColor3"
        local function helperFn9(arg12)
            val18[text] = arg12
        end
        helperFn9(val13)
        table.insert(stateMap16, helperFn9)
        val16.MouseButton1Click:Connect(function()
            arg1:selectTab(arg2)
        end)
        local stateMap24 = {}
        local tabs = arg1.tabs
        stateMap24.page = val15
        stateMap24.button = val16
        stateMap24.line = val17
        tabs[arg2] = stateMap24
        for _, item in ipairs(arg1.tabNames) do
            arg1.tabs[item].button.Size = UDim2.new(1 / #arg1.tabNames, -4, 1, 0)
        end
        if #arg1.tabNames == 1 then
            arg1:selectTab(arg2)
        end
        local stateMap25 = {}
        stateMap25.window = arg1
        stateMap25.page = val15
        stateMap25.columns = val14
        return setmetatable(stateMap25, stateMap20)
    end
    stateMap17.setVisible = function(arg1, arg2)
        arg1.main.Visible = arg2
    end
    stateMap17.toggle = function(arg1)
        arg1.main.Visible = not arg1.main.Visible
    end
    stateMap17.destroy = function(arg1)
        for _, item in ipairs(arg1.connections) do
            item:Disconnect()
        end
        arg1.connections = {}
        arg1.gui:Destroy()
    end
    return stateMap17
end)()
local localPlayer = Players.LocalPlayer
local currentCamera = workspace.CurrentCamera
local val12 = localPlayer:GetMouse()
local val13 = gethui and gethui() or CoreGui
local stateMap15 = {}
local stateMap16 = {}
local stateMap17 = {}
local stateMap18 = {}
local stateMap19 = {}
local stateMap20 = {}
local val14 = nil
local val15 = nil
local val16 = nil
local val17 = nil
local val18 = nil
local val19 = nil
local val20 = nil
local val21 = nil
local val22 = nil
local val23 = nil
local val24 = nil
local val25 = nil
local val26 = nil
local val27 = nil
local val28 = nil
local val29 = nil
local val30 = nil
local stateMap21 = {}
stateMap21.alive = true
stateMap21.aimbotToggled = false
stateMap21.lock = nil
stateMap21.manualTarget = nil
stateMap21.whitelist = {}
stateMap21.silentTarget = nil
stateMap21.silentTargetPart = nil
stateMap21.rageTarget = nil
stateMap21.rageTimer = 0
stateMap21.rageAngle = 0
stateMap21.orbitTarget = nil
stateMap21.orbitAngle = 0
stateMap21.triggerTimer = 0
stateMap21.shootTimer = 0
stateMap21.katanaTimer = 0
stateMap21.hudText = ""
stateMap21.stompOrigin = nil
stateMap21.stompBack = nil
stateMap21.stompTimer = 0
stateMap21.aaVelocity = nil
stateMap21.aaApplied = false
stateMap21.fpsTime = 0
stateMap21.fpsFrames = 0
stateMap21.listTimer = 0
stateMap21.lastTarget = nil
stateMap21.lastTargetTime = 0
stateMap21.localDead = false
stateMap21.spectatePlayer = nil
stateMap21.flinging = false
stateMap21.flying = false
stateMap21.spinning = false
stateMap21.jumpApplied = false
stateMap21.walkApplied = false
stateMap21.buyingArmor = false
stateMap21.armorDetector = nil
stateMap21.lastFire = 0
stateMap21.wallbangModel = nil
stateMap21.wallbangParams = nil
stateMap21.lastFire = 0
stateMap21.wallbangModel = nil
stateMap21.wallbangParams = nil
stateMap21.armorScanTime = 0
stateMap21.mainEvent = nil
stateMap21.armorCooldown = 0
stateMap21.hudAvatarId = nil
local stateMap22 = {}
stateMap22.__mode = "k"
local val31 = setmetatable({}, stateMap22)
stateMap21.hitboxOriginals = val31
local val32 = stateMap21
local stateMap23 = {}
local stateMap24 = {}
stateMap23.team = false
stateMap23.health = true
stateMap23.minHealth = 1
stateMap23.knocked = true
stateMap24.checks = stateMap23
local stateMap25 = {}
stateMap25.enabled = false
stateMap25.mode = "Camera"
stateMap25.activation = "Hold"
stateMap25.priority = "Cursor"
stateMap25.sticky = true
stateMap25.fov = 150
stateMap25.smoothing = 0.35
stateMap25.autoPrediction = true
stateMap25.pingScale = 1
stateMap25.prediction = 0.13
stateMap25.hitPart = "HumanoidRootPart"
stateMap25.wallCheck = false
stateMap25.showFov = true
stateMap24.aimbot = stateMap25
local stateMap26 = {}
stateMap26.enabled = false
stateMap26.fov = 150
stateMap26.hitChance = 100
stateMap26.autoPrediction = true
stateMap26.pingScale = 1
stateMap26.prediction = 0.13
stateMap26.hitPart = "HumanoidRootPart"
stateMap26.wallCheck = false
stateMap26.showFov = true
stateMap26.hookRemote = true
stateMap26.hookMouse = true
stateMap26.raycast = true
stateMap26.infiniteRange = true
stateMap24.silentAim = stateMap26
local stateMap27 = {}
stateMap27.chams = true
stateMap27.chamsColor = Color3.fromRGB(245, 130, 185)
stateMap27.hit = true
stateMap27.autoShoot = true
stateMap27.autoEquip = true
stateMap27.rate = 12
stateMap27.hud = true
stateMap27.untargetOnKo = false
stateMap27.assist = 60
stateMap24.target = stateMap27
local stateMap28 = {}
stateMap28.enabled = false
stateMap28.threshold = 25
stateMap28.cooldown = 6
stateMap28.keyword = "armor"
stateMap24.armor = stateMap28
local stateMap29 = {}
stateMap29.enabled = false
stateMap29.delay = 0.05
stateMap29.range = 1000
stateMap29.radius = 25
stateMap29.wallCheck = true
stateMap29.method = "Activate"
stateMap24.trigger = stateMap29
local stateMap30 = {}
stateMap30.enabled = false
stateMap24.wallbang = stateMap30
local stateMap31 = {}
stateMap31.enabled = false
stateMap31.player = "Closest"
stateMap31.range = 10
stateMap31.rate = 8
stateMap31.approach = true
stateMap31.distance = 3
stateMap31.maxDistance = 80
stateMap24.katana = stateMap31
local stateMap32 = {}
stateMap32.enabled = false
stateMap32.method = "Reset"
stateMap32.height = 300
stateMap24.antiStomp = stateMap32
local stateMap33 = {}
stateMap33.enabled = true
stateMap33.watermark = true
stateMap33.notify = true
stateMap24.hud = stateMap33
local stateMap34 = {}
stateMap34.enabled = false
stateMap34.size = 12
stateMap34.transparency = 0.7
stateMap34.part = "HumanoidRootPart"
stateMap24.hitbox = stateMap34
local stateMap35 = {}
stateMap35.enabled = false
stateMap35.hitPart = "HumanoidRootPart"
stateMap35.lockCamera = true
stateMap35.orbit = true
stateMap35.autoFire = true
stateMap35.radius = 8
stateMap35.speed = 6
stateMap35.height = 2
stateMap35.rate = 20
stateMap35.autoPrediction = true
stateMap35.pingScale = 1
stateMap35.prediction = 0.13
stateMap24.rage = stateMap35
local stateMap36 = {}
stateMap36.enabled = false
stateMap36.player = "Closest"
stateMap36.target = "Closest"
stateMap36.radius = 10
stateMap36.speed = 3
stateMap36.height = 3
stateMap36.face = true
stateMap24.orbit = stateMap36
local stateMap37 = {}
stateMap37.enabled = false
stateMap37.value = 40
stateMap24.speed = stateMap37
local stateMap38 = {}
stateMap38.enabled = false
stateMap38.value = 32
stateMap24.walk = stateMap38
local stateMap39 = {}
stateMap39.enabled = false
stateMap39.value = 60
stateMap24.fly = stateMap39
local stateMap40 = {}
stateMap40.enabled = false
stateMap40.value = 70
stateMap40.infinite = false
stateMap24.jump = stateMap40
local stateMap41 = {}
stateMap41.enabled = false
stateMap41.value = 30
stateMap24.spinbot = stateMap41
local stateMap42 = {}
stateMap42.enabled = false
stateMap42.range = 12
stateMap42.teleport = true
stateMap42.rate = 8
stateMap24.autoStomp = stateMap42
local stateMap43 = {}
stateMap43.enabled = false
stateMap43.method = "Jitter"
stateMap43.angle = 90
stateMap43.amount = 40
stateMap24.antiAim = stateMap43
local stateMap44 = {}
stateMap44.duration = 3
stateMap24.fling = stateMap44
stateMap24.noclip = false
stateMap24.debug = false
local stateMap45 = {}
stateMap45.enabled = false
stateMap45.box = true
stateMap45.name = true
stateMap45.distance = true
stateMap45.tool = true
stateMap45.health = true
stateMap45.skeleton = true
stateMap45.chams = false
stateMap45.chamsStyle = "Pulse"
stateMap45.color = val7
stateMap45.chamsColor = val7
stateMap45.nameColor = val8
stateMap45.skeletonColor = val7
stateMap45.toolColor = Color3.fromRGB(255, 235, 80)
stateMap45.distanceColor = val8
stateMap45.teamColor = false
stateMap45.maxDistance = 2000
stateMap24.esp = stateMap45
local stateMap46 = {}
stateMap46.kill = true
stateMap46.death = true
stateMap24.overlay = stateMap46
local stateMap47 = {}
stateMap47.aimbot = Enum.KeyCode.C
stateMap47.target = Enum.UserInputType.MouseButton2
stateMap47.clearTarget = Enum.KeyCode.V
stateMap47.silentAim = Enum.KeyCode.E
stateMap47.trigger = Enum.KeyCode.T
stateMap47.speed = Enum.KeyCode.X
stateMap47.fly = Enum.KeyCode.F
stateMap47.noclip = Enum.KeyCode.N
stateMap47.esp = Enum.KeyCode.Z
stateMap47.orbit = Enum.KeyCode.O
stateMap47.rage = Enum.KeyCode.R
stateMap47.autoStomp = Enum.KeyCode.G
stateMap47.antiAim = Enum.KeyCode.H
stateMap47.menu = Enum.KeyCode.RightShift
stateMap24.binds = stateMap47
local val33 = stateMap24
local function helperFn2()
    local ok, res = pcall(function()
        return Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok then
        ok = res
    end
    if not ok then
        ok = 0
    end
    return ok
end
local function helperFn3(arg1)
    return string.format("%02X%02X%02X", math.floor(arg1.R * 255 + 0.5), math.floor(arg1.G * 255 + 0.5), math.floor(arg1.B * 255 + 0.5))
end
local function helperFn4(arg1)
    local bodyEffects = arg1:FindFirstChild("BodyEffects")
    if bodyEffects then
        local val34, val35, val36 = ipairs(items)
        local val37, val38, val39 = helperFn(val34, val35, val36)
        local val40, val41 = val37(val38, val39)
        if val40 == nil then
            local val42 = arg1:GetAttribute("KO")
            local val43 = val42 == true
            if not val43 then
                local val44 = arg1:GetAttribute("Knocked")
                val43 = val44 == true
            end
            return val43
        end
        while true do
            local val42 = bodyEffects:FindFirstChild(val41)
            local val43 = val42 and val42:IsA("ValueBase") and val42.Value == true
            if val43 then
                return true
            end
            val40, val41 = val37(val38, val40)
            if val40 == nil then
                local val44 = arg1:GetAttribute("KO")
                local val45 = val44 == true
                if not val45 then
                    local val46 = arg1:GetAttribute("Knocked")
                    val45 = val46 == true
                end
                return val45
            end
        end
    else
        local val34 = arg1:GetAttribute("KO")
        local val35 = val34 == true
        if not val35 then
            local val36 = arg1:GetAttribute("Knocked")
            val35 = val36 == true
        end
        return val35
    end
end
local function helperFn5(arg1)
    local bodyEffects = arg1:FindFirstChild("BodyEffects")
    local val34 = bodyEffects and bodyEffects:FindFirstChild("Armor")
    local val35 = not val34
    if val35 then
        val34 = arg1:FindFirstChild("Armor", true)
    end
    local val36 = val34 and val34:IsA("ValueBase") and tonumber(val34.Value) or 0
    return val36
end
local function helperFn6(arg1)
    local character = arg1.Character
    local val34 = character and character:FindFirstChildOfClass("Humanoid")
    if not val34 then
        return false
    end
    local val35 = val34.Health <= 0 or helperFn4(character)
    return val35
end
local function helperFn7(arg1)
    if not val33.checks.team then
        return false
    end
    return arg1.Team ~= nil and arg1.Team == localPlayer.Team
end
local function helperFn8(arg1)
    local val34 = RaycastParams.new()
    val34.FilterType = Enum.RaycastFilterType.Exclude
    local stateMap48 = {}
    local parent = arg1.Parent
    stateMap48[1] = localPlayer.Character
    stateMap48[2] = parent
    val34.FilterDescendantsInstances = stateMap48
    local position = currentCamera.CFrame.Position
    local val35 = workspace:Raycast(position, arg1.Position - position, val34)
    return val35 == nil
end
local function helperFn9(arg1, arg2)
    if not arg1 or arg1 == localPlayer or val32.whitelist[arg1] then
        return false
    end
    local val34 = helperFn7(arg1)
    if val34 then
        return false
    end
    local character = arg1.Character
    local val35 = character and character:FindFirstChildOfClass("Humanoid")
    if not val35 or val35.Health <= 0 then
        return false
    end
    if val33.checks.health and val35.Health < val33.checks.minHealth then
        return false
    end
    local knocked = val33.checks.knocked and helperFn4(character)
    if knocked then
        return false
    end
    local val36 = character:FindFirstChild(arg2) ~= nil
    return val36
end
local function helperFn10(arg1)
    local val34 = helperFn6(arg1)
    if val34 then
        return
    end
    val32.lastTarget = arg1
    val32.lastTargetTime = os.clock()
end
local function helperFn11(arg1, arg2, arg3, arg4)
    local val34 = nil
    local huge = math.huge
    local val35 = UserInputService:GetMouseLocation()
    local position = currentCamera.CFrame.Position
    for _, item in ipairs(Players:GetPlayers()) do
        local val36 = helperFn9(item, arg1)
        if val36 then
            local val37 = item.Character[arg1]
            local val38 = arg3
            if val38 then
                local val39 = helperFn8(val37)
                val38 = not val39
            end
            if not val38 then
                local val39, val40 = currentCamera:WorldToViewportPoint(val37.Position)
                if val40 then
                    local magnitude = ((Vector2.new(val39.X, val39.Y) - Vector2.new(val35.X, val35.Y))).Magnitude
                    if magnitude <= arg2 then
                        local val41 = arg4 == "Distance" and ((val37.Position - position)).Magnitude or magnitude
                        if val41 < huge then
                            val34 = item
                            huge = val41
                        end
                    end
                end
            end
        end
    end
    return val34
end
local function helperFn12(arg1, arg2, arg3, arg4)
    local val34 = helperFn9(val32.manualTarget, arg1)
    if val34 then
        return val32.manualTarget
    end
    local val35 = helperFn11(arg1, arg2, arg3, arg4)
    return val35
end
local function helperFn13(arg1, arg2)
    local val34 = helperFn9(val32.manualTarget, arg2)
    if val34 then
        return val32.manualTarget
    end
    local val35 = nil
    local huge = math.huge
    for _, item in ipairs(Players:GetPlayers()) do
        local val36 = helperFn9(item, arg2)
        if val36 then
            local magnitude = ((item.Character[arg2].Position - arg1)).Magnitude
            if magnitude < huge then
                val35 = item
                huge = magnitude
            end
        end
    end
    return val35
end
local function helperFn14(arg1, arg2)
    local val34 = Players:FindFirstChild(arg1)
    local val35 = val34 and val34:IsA("Player")
    if not val35 then
        return nil
    end
    local val36 = helperFn9(val34, arg2) and val34 or nil
    return val36
end
local function helperFn15(arg1, arg2, arg3)
    local character = arg1.Character
    local val34 = character and character:FindFirstChild(arg2)
    local val35 = character and character:FindFirstChild("HumanoidRootPart")
    if not (val34 and val35) then
        return nil
    end
    return val34.Position + val35.AssemblyLinearVelocity * arg3
end
local function helperFn16(arg1, arg2)
    if stateMap19[arg1] then
        arg2(stateMap19[arg1])
        return
    end
    task.spawn(function()
        local ok, res = pcall(function()
            return Players:GetUserThumbnailAsync(arg1, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
        end)
        if ok then
            stateMap19[arg1] = res
            arg2(res)
        end
    end)
end
local function helperFn17()
    val15 = Instance.new("ScreenGui")
    local val34 = val15
    local val35 = HttpService:GenerateGUID(false)
    val34.Name = val35
    val34.ResetOnSpawn = false
    val34.IgnoreGuiInset = true
    val34.DisplayOrder = 998
    val34.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    val34.Parent = val13
end
local function helperFn18(arg1, arg2)
    if not val15 then
        return
    end
    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundColor3 = arg2
    frame.BackgroundTransparency = 0.65
    frame.BorderSizePixel = 0
    frame.ZIndex = 10
    frame.Parent = val15
    local label = Instance.new("TextLabel")
    label.AnchorPoint = Vector2.new(0.5, 0.5)
    label.Position = UDim2.fromScale(0.5, 0.45)
    label.Size = UDim2.fromOffset(700, 80)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 46
    label.Text = arg1
    label.TextColor3 = arg2
    label.TextStrokeTransparency = 0.3
    label.ZIndex = 11
    label.Parent = val15
    local stateMap48 = {}
    stateMap48.BackgroundTransparency = 1
    local val34 = TweenService:Create(frame, TweenInfo.new(1.4, Enum.EasingStyle.Quad), stateMap48)
    val34:Play()
    local stateMap49 = {}
    stateMap49.TextTransparency = 1
    stateMap49.TextStrokeTransparency = 1
    stateMap49.Position = UDim2.fromScale(0.5, 0.4)
    local val35 = TweenService:Create(label, TweenInfo.new(2, Enum.EasingStyle.Quad), stateMap49)
    val35:Play()
    task.delay(2.2, function()
        frame:Destroy()
        label:Destroy()
    end)
end
local function helperFn19()
    local lastTarget = val32.lastTarget
    if not lastTarget then
        return
    end
    local val34 = lastTarget.Parent == nil
    if not val34 then
        local val35 = os.clock() - val32.lastTargetTime
        val34 = val35 > 4
    end
    if val34 then
        val32.lastTarget = nil
        return
    end
    local val35 = helperFn6(lastTarget)
    if not val35 then
        return
    end
    val32.lastTarget = nil
    if val33.overlay.kill then
        local val36 = "ELIMINATED  " .. string.upper(lastTarget.Name)
        helperFn18(val36, Color3.fromRGB(255, 50, 50))
    end
end
local function helperFn20()
    local character = localPlayer.Character
    local val34 = character and character:FindFirstChildOfClass("Humanoid")
    if not val34 then
        return
    end
    if val34.Health <= 0 and not val32.localDead then
        val32.localDead = true
        if val33.overlay.death then
            helperFn18("YOU DIED", Color3.fromRGB(190, 20, 20))
        end
    elseif val34.Health > 0 then
        val32.localDead = false
    end
end
local function helperFn21()
    val19 = Instance.new("Frame")
    local val34 = val19
    val34.AnchorPoint = Vector2.new(0, 0.5)
    val34.Position = UDim2.new(0, 10, 0.5, 0)
    val34.Size = UDim2.new()
    val34.AutomaticSize = Enum.AutomaticSize.XY
    val34.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    val34.BackgroundTransparency = 0.1
    val34.BorderSizePixel = 0
    val34.Visible = false
    val34.Parent = val15
    val21 = Instance.new("UIStroke")
    local val35 = val21
    val35.Thickness = 1
    val35.Parent = val19
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, 8)
    uiPadding.PaddingRight = UDim.new(0, 8)
    uiPadding.PaddingTop = UDim.new(0, 5)
    uiPadding.PaddingBottom = UDim.new(0, 5)
    uiPadding.Parent = val19
    val20 = Instance.new("TextLabel")
    local val36 = val20
    val36.BackgroundTransparency = 1
    val36.Size = UDim2.new()
    val36.AutomaticSize = Enum.AutomaticSize.XY
    val36.Font = Enum.Font.Code
    val36.TextSize = 13
    val36.TextColor3 = Color3.new(1, 1, 1)
    val36.TextXAlignment = Enum.TextXAlignment.Left
    val36.RichText = true
    val36.Parent = val19
end
local function helperFn22()
    if not val19 then
        return
    end
    local val34 = val11.getAccent()
    val21.Color = val34
    local stateMap48 = {}
    local function helperFn23(arg1, arg2, arg3)
        local val35 = arg2 and val33.binds[arg2]
        table.insert(stateMap48, (val35 and "[" .. val35.Name .. "] " or "") .. arg1 .. (arg3 or ""))
    end
    if val33.aimbot.enabled then
        local val35 = " (" .. val33.aimbot.activation
        if val33.aimbot.activation == "Toggle" then
            val35 = val35 .. (val32.aimbotToggled and " ON" or " OFF")
        end
        helperFn23("Aimbot", "aimbot", val35 .. ")")
    end
    if val32.manualTarget then
        helperFn23("Target: " .. val32.manualTarget.DisplayName)
    end
    if val33.silentAim.enabled then
        helperFn23("Silent aim", "silentAim")
    end
    if val33.trigger.enabled then
        helperFn23("Trigger bot", "trigger")
    end
    if val33.rage.enabled then
        helperFn23("Rage", "rage")
    end
    if val33.orbit.enabled then
        helperFn23("Orbit", "orbit")
    end
    if val33.katana.enabled then
        helperFn23("Auto katana")
    end
    if val33.antiStomp.enabled then
        helperFn23("Anti stomp")
    end
    if val33.armor.enabled then
        helperFn23("Auto armor")
    end
    if val33.hitbox.enabled then
        helperFn23("Hitbox")
    end
    if val33.speed.enabled then
        helperFn23("Speed", "speed")
    end
    if val33.fly.enabled then
        helperFn23("Flight", "fly")
    end
    if val33.noclip then
        helperFn23("Noclip", "noclip")
    end
    if val33.spinbot.enabled then
        helperFn23("Spinbot")
    end
    if val33.autoStomp.enabled then
        helperFn23("Auto stomp", "autoStomp")
    end
    if val33.antiAim.enabled then
        helperFn23("Anti aim", "antiAim")
    end
    if val33.esp.enabled then
        helperFn23("ESP", "esp")
    end
    val19.Visible = val33.hud.enabled and #stateMap48 > 0
    local val35 = helperFn3(val34)
    local val36 = table.concat(stateMap48, "\n")
    local val37 = "<font color=\"#" .. val35 .. "\"><b>Keybinds</b></font>\n" .. val36
    if val37 == val32.hudText then
        return
    end
    val32.hudText = val37
    val20.Text = val37
end
local function helperFn23()
    val24 = Instance.new("Frame")
    local val34 = val24
    val34.AnchorPoint = Vector2.new(0, 1)
    val34.Position = UDim2.new(0, 14, 1, -14)
    val34.Size = UDim2.fromOffset(320, 320)
    val34.BackgroundTransparency = 1
    val34.BorderSizePixel = 0
    val34.Parent = val15
    local listLayout = Instance.new("UIListLayout")
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = val24
    val25 = Instance.new("Frame")
    local val35 = val25
    val35.Position = UDim2.fromOffset(12, 12)
    val35.Size = UDim2.new()
    val35.AutomaticSize = Enum.AutomaticSize.XY
    val35.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
    val35.BackgroundTransparency = 0.1
    val35.BorderSizePixel = 0
    val35.Parent = val15
    val27 = Instance.new("UIStroke")
    local val36 = val27
    val36.Thickness = 1
    local val37 = val11.getAccent()
    val36.Color = val37
    val36.Parent = val25
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, 10)
    uiPadding.PaddingRight = UDim.new(0, 10)
    uiPadding.PaddingTop = UDim.new(0, 5)
    uiPadding.PaddingBottom = UDim.new(0, 5)
    uiPadding.Parent = val25
    val26 = Instance.new("TextLabel")
    local val38 = val26
    val38.BackgroundTransparency = 1
    val38.Size = UDim2.new()
    val38.AutomaticSize = Enum.AutomaticSize.XY
    val38.Font = Enum.Font.Code
    val38.TextSize = 14
    val38.TextColor3 = Color3.new(1, 1, 1)
    val38.RichText = true
    val38.Text = "POTENT"
    val38.Parent = val25
end
local function helperFn24(arg1)
    if not val25 then
        return
    end
    val25.Visible = val33.hud.watermark
    val32.fpsTime = val32.fpsTime + arg1
    val32.fpsFrames = val32.fpsFrames + 1
    if val32.fpsTime < 0.5 then
        return
    end
    local val34 = val11.getAccent()
    val27.Color = val34
    local val35 = helperFn3(val34)
    local val36 = math.floor(val32.fpsFrames / val32.fpsTime + 0.5)
    local val37 = helperFn2()
    val26.Text = string.format("<font color=\"#%s\"><b>POTENT</b></font>  |  %d fps  |  %d ms", val35, val36, math.floor(val37 + 0.5))
    val32.fpsTime = 0
    val32.fpsFrames = 0
end
local function helperFn25(arg1)
    if not (val24 and val33.hud.notify) then
        return
    end
    local val34 = val11.getAccent()
    local frame = Instance.new("Frame")
    frame.AutomaticSize = Enum.AutomaticSize.XY
    frame.Size = UDim2.new()
    frame.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    local val35 = os.clock() * 1000
    frame.LayoutOrder = val35
    frame.Parent = val24
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = val34
    uiStroke.Thickness = 1
    uiStroke.Transparency = 1
    uiStroke.Parent = frame
    local uiPadding = Instance.new("UIPadding")
    uiPadding.PaddingLeft = UDim.new(0, 10)
    uiPadding.PaddingRight = UDim.new(0, 10)
    uiPadding.PaddingTop = UDim.new(0, 5)
    uiPadding.PaddingBottom = UDim.new(0, 5)
    uiPadding.Parent = frame
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new()
    label.AutomaticSize = Enum.AutomaticSize.XY
    label.Font = Enum.Font.Code
    label.TextSize = 14
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextTransparency = 1
    label.Text = arg1
    label.Parent = frame
    local val36 = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
    local stateMap48 = {}
    stateMap48.BackgroundTransparency = 0.1
    local val37 = TweenService:Create(frame, val36, stateMap48)
    val37:Play()
    local stateMap49 = {}
    stateMap49.Transparency = 0.4
    local val38 = TweenService:Create(uiStroke, val36, stateMap49)
    val38:Play()
    local stateMap50 = {}
    stateMap50.TextTransparency = 0
    local val39 = TweenService:Create(label, val36, stateMap50)
    val39:Play()
    task.delay(2.5, function()
        local val40 = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
        local stateMap51 = {}
        stateMap51.BackgroundTransparency = 1
        local val41 = TweenService:Create(frame, val40, stateMap51)
        val41:Play()
        local stateMap52 = {}
        stateMap52.Transparency = 1
        local val42 = TweenService:Create(uiStroke, val40, stateMap52)
        val42:Play()
        local stateMap53 = {}
        stateMap53.TextTransparency = 1
        local val43 = TweenService:Create(label, val40, stateMap53)
        val43:Play()
        task.wait(0.35)
        frame:Destroy()
    end)
end
local function helperFn26(arg1, arg2, arg3)
    local frame = Instance.new("Frame")
    frame.Position = UDim2.fromOffset(70, arg2)
    frame.Size = UDim2.new(1, -78, 0, 14)
    frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
    frame.BorderSizePixel = 0
    frame.Parent = arg1
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(50, 50, 50)
    uiStroke.Thickness = 1
    uiStroke.Parent = frame
    local frame2 = Instance.new("Frame")
    frame2.Size = UDim2.fromScale(0, 1)
    frame2.BackgroundColor3 = arg3
    frame2.BorderSizePixel = 0
    frame2.Parent = frame
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.fromScale(1, 1)
    label.Font = Enum.Font.Code
    label.TextSize = 12
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextStrokeTransparency = 0.5
    label.ZIndex = 2
    label.Parent = frame
    return frame2, label
end
local function helperFn27()
    val22 = Instance.new("Frame")
    local val34 = val22
    val34.AnchorPoint = Vector2.new(0.5, 1)
    val34.Position = UDim2.new(0.5, 0, 1, -140)
    val34.Size = UDim2.fromOffset(270, 84)
    val34.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    val34.BackgroundTransparency = 0.05
    val34.BorderSizePixel = 0
    val34.Visible = false
    val34.Parent = val15
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(50, 50, 50)
    uiStroke.Thickness = 1
    uiStroke.Parent = val22
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 2)
    local val35 = val11.getAccent()
    frame.BackgroundColor3 = val35
    frame.BorderSizePixel = 0
    frame.Parent = val22
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Position = UDim2.fromOffset(8, 10)
    imageLabel.Size = UDim2.fromOffset(54, 54)
    imageLabel.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
    imageLabel.BorderSizePixel = 0
    imageLabel.Parent = val22
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(70, 8)
    label.Size = UDim2.new(1, -78, 0, 14)
    label.Font = Enum.Font.Code
    label.TextSize = 13
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = val22
    local label2 = Instance.new("TextLabel")
    label2.BackgroundTransparency = 1
    label2.Position = UDim2.fromOffset(70, 23)
    label2.Size = UDim2.new(1, -78, 0, 14)
    label2.Font = Enum.Font.Code
    label2.TextSize = 12
    label2.TextColor3 = Color3.fromRGB(140, 140, 140)
    label2.TextXAlignment = Enum.TextXAlignment.Left
    label2.Parent = val22
    local val36, val37 = helperFn26(val22, 42, val5)
    local val38, val39 = helperFn26(val22, 62, val6)
    local stateMap48 = {}
    stateMap48.line = frame
    stateMap48.avatar = imageLabel
    stateMap48.name = label
    stateMap48.distance = label2
    stateMap48.armorFill = val36
    stateMap48.armorLabel = val37
    stateMap48.healthFill = val38
    stateMap48.healthLabel = val39
    val23 = stateMap48
end
local function helperFn28()
    if not val22 then
        return
    end
    local manualTarget = val32.manualTarget
    local val34 = manualTarget and manualTarget.Character
    local val35 = val34 and val34:FindFirstChildOfClass("Humanoid")
    local val36 = val34 and val34:FindFirstChild("HumanoidRootPart")
    if not (val33.target.hud and manualTarget and val35 and val36) then
        val22.Visible = false
        return
    end
    val22.Visible = true
    local line = val23.line
    local val37 = val11.getAccent()
    line.BackgroundColor3 = val37
    val23.name.Text = manualTarget.DisplayName .. " (@" .. manualTarget.Name .. ")"
    local character = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    val23.distance.Text = string.format("%d studs", character and ((character.Position - val36.Position)).Magnitude or 0)
    if val32.hudAvatarId ~= manualTarget.UserId then
        val32.hudAvatarId = manualTarget.UserId
        val23.avatar.Image = ""
        helperFn16(manualTarget.UserId, function(arg1)
            if val32.hudAvatarId == manualTarget.UserId then
                val23.avatar.Image = arg1
            end
        end)
    end
    local val38 = helperFn5(val34)
    local val39 = math.max(100, val38)
    val23.armorFill.Size = UDim2.fromScale(math.clamp(val38 / val39, 0, 1), 1)
    val23.armorLabel.Text = string.format("%d/%d", val38, val39)
    local val40 = math.max(val35.Health, 0)
    local val41 = math.max(val35.MaxHealth, 1)
    val23.healthFill.Size = UDim2.fromScale(math.clamp(val40 / val41, 0, 1), 1)
    val23.healthLabel.Text = string.format("%d/%d", val40, val41)
end
local function helperFn29()
    local manualTarget = val32.manualTarget
    local val34 = manualTarget and manualTarget.Character
    if not (val33.target.chams and val34) then
        if val18 then
            val18.Enabled = false
        end
        return
    end
    if not val18 then
        val18 = Instance.new("Highlight")
        local val35 = val18
        val35.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        val35.Parent = val13
    end
    local val35 = val18
    val35.Adornee = val34
    val35.Enabled = true
    val35.FillColor = val33.target.chamsColor
    local val36 = os.clock() * 4
    local val37 = math.sin(val36)
    val35.FillTransparency = 0.5 + val37 * 0.2
    val35.OutlineColor = Color3.new(1, 1, 1)
    val35.OutlineTransparency = 0
end
local function helperFn30()
    local stateMap48 = {}
    for i = 1, #val9 do
        local stateMap49 = {}
        stateMap49.Thickness = 1
        stateMap49.Visible = false
        local val34 = Drawing.new("Line")
        for key, item in pairs(stateMap49) do
            val34[key] = item
        end
        stateMap48[i] = val34
    end
    local stateMap49 = {}
    stateMap49.Size = 13
    stateMap49.Center = true
    stateMap49.Outline = true
    stateMap49.Font = Drawing.Fonts.Monospace
    stateMap49.Visible = false
    local stateMap50 = {}
    local stateMap51 = {}
    stateMap51.Thickness = 1
    stateMap51.Filled = false
    stateMap51.Visible = false
    local val34 = Drawing.new("Square")
    for key, item in pairs(stateMap51) do
        val34[key] = item
    end
    stateMap50.box = val34
    local stateMap52 = {}
    stateMap52.Filled = true
    stateMap52.Color = Color3.new(0, 0, 0)
    stateMap52.Visible = false
    local val35 = Drawing.new("Square")
    for key, item in pairs(stateMap52) do
        val35[key] = item
    end
    stateMap50.healthBack = val35
    local stateMap53 = {}
    stateMap53.Filled = true
    stateMap53.Visible = false
    local val36 = Drawing.new("Square")
    for key, item in pairs(stateMap53) do
        val36[key] = item
    end
    stateMap50.healthBar = val36
    local val37 = Drawing.new("Text")
    for key, item in pairs(stateMap49) do
        val37[key] = item
    end
    stateMap50.name = val37
    local val38 = Drawing.new("Text")
    for key, item in pairs(stateMap49) do
        val38[key] = item
    end
    stateMap50.distance = val38
    local val39 = Drawing.new("Text")
    for key, item in pairs(stateMap49) do
        val39[key] = item
    end
    stateMap50.tool = val39
    stateMap50.lines = stateMap48
    stateMap50.highlight = nil
    return stateMap50
end
local function helperFn31(arg1)
    arg1.box.Visible = false
    arg1.healthBack.Visible = false
    arg1.healthBar.Visible = false
    arg1.name.Visible = false
    arg1.distance.Visible = false
    arg1.tool.Visible = false
    for _, item in ipairs(arg1.lines) do
        item.Visible = false
    end
    if arg1.highlight then
        arg1.highlight.Enabled = false
    end
end
local function helperFn32(arg1)
    arg1.box:Remove()
    arg1.healthBack:Remove()
    arg1.healthBar:Remove()
    arg1.name:Remove()
    arg1.distance:Remove()
    arg1.tool:Remove()
    for _, item in ipairs(arg1.lines) do
        item:Remove()
    end
    if arg1.highlight then
        arg1.highlight:Destroy()
    end
end
local function helperFn33(arg1, arg2)
    local esp = val33.esp
    if not arg1.highlight then
        local highlight = Instance.new("Highlight")
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = val13
        arg1.highlight = highlight
    end
    local highlight = arg1.highlight
    local val34 = os.clock()
    highlight.Adornee = arg2
    highlight.Enabled = true
    highlight.OutlineColor = Color3.new(1, 1, 1)
    highlight.OutlineTransparency = 0
    if esp.chamsStyle == "Rainbow" then
        highlight.FillColor = Color3.fromHSV(val34 % 5 / 5, 1, 1)
        highlight.FillTransparency = 0.45
    elseif esp.chamsStyle == "Pulse" then
        highlight.FillColor = esp.chamsColor
        local val35 = math.sin(val34 * 3)
        highlight.FillTransparency = 0.5 + val35 * 0.3
    elseif esp.chamsStyle == "Outline" then
        highlight.FillColor = esp.chamsColor
        highlight.FillTransparency = 1
        highlight.OutlineColor = esp.chamsColor
    else
        highlight.FillColor = esp.chamsColor
        highlight.FillTransparency = 0.45
    end
end
local function helperFn34()
    local esp = val33.esp
    local position = currentCamera.CFrame.Position
    for _, item in ipairs(Players:GetPlayers()) do
        if item ~= localPlayer then
            local val34 = stateMap16[item]
            local character = item.Character
            local val35 = character and character:FindFirstChild("HumanoidRootPart")
            local val36 = character and character:FindFirstChild("Head")
            local val37 = character and character:FindFirstChildOfClass("Humanoid")
            local val38 = nil
            local enabled = false
            local enabled2 = esp.enabled
            local val39 = nil
            local value = 0
            if enabled2 then
                enabled2 = val35
            end
            if enabled2 then
                enabled2 = val36
            end
            if enabled2 then
                enabled2 = val37
            end
            if enabled2 then
                enabled2 = val37.Health > 0
            end
            if enabled2 then
                local val40
                if not val33.checks.team then
                    val40 = false
                else
                    val40 = item.Team ~= nil and item.Team == localPlayer.Team
                end
                enabled2 = not val40
            end
            if enabled2 then
                value = ((val35.Position - position)).Magnitude
                val38 = currentCamera:WorldToViewportPoint(val36.Position + Vector3.new(0, 0.7, 0))
                val39 = currentCamera:WorldToViewportPoint(val35.Position - Vector3.new(0, 3, 0))
                enabled = value <= esp.maxDistance and val38.Z > 0 and val39.Z > 0
            end
            if not enabled then
                if val34 then
                    helperFn31(val34)
                end
            else
                local val40 = not val34
                if val40 then
                    val34 = helperFn30()
                    stateMap16[item] = val34
                end
                local val41 = nil
                if val32.whitelist[item] then
                    val41 = val4
                elseif val32.manualTarget == item then
                    val41 = val3
                elseif esp.teamColor and item.Team then
                    val41 = item.TeamColor.Color
                end
                local val42 = math.abs(val39.Y - val38.Y)
                local val43 = val42 * 0.6
                local val44 = val38.X - val43 / 2
                local y = val38.Y
                local val45 = val38.Y + val42
                val34.box.Position = Vector2.new(val44, y)
                val34.box.Size = Vector2.new(val43, val42)
                local val46 = val41
                local box = val34.box
                if not val46 then
                    val46 = esp.color
                end
                box.Color = val46
                val34.box.Visible = esp.box
                val34.name.Text = item.DisplayName
                val34.name.Color = val41 or esp.nameColor
                val34.name.Position = Vector2.new(val38.X, y - 16)
                val34.name.Visible = esp.name
                local val47 = val45 + 2
                val34.distance.Text = string.format("[%dm]", value)
                val34.distance.Color = esp.distanceColor
                val34.distance.Position = Vector2.new(val38.X, val47)
                val34.distance.Visible = esp.distance
                if esp.distance then
                    val47 = val47 + 13
                end
                local val48 = character:FindFirstChildOfClass("Tool")
                local val49 = val48
                local tool = val34.tool
                if val49 then
                    val49 = "[" .. val48.Name .. "]"
                end
                if not val49 then
                    val49 = "[None]"
                end
                tool.Text = val49
                val34.tool.Color = esp.toolColor
                val34.tool.Position = Vector2.new(val38.X, val47)
                val34.tool.Visible = esp.tool
                local val50 = val37.Health / math.max(val37.MaxHealth, 1)
                local val51 = math.clamp(val50, 0, 1)
                val34.healthBack.Position = Vector2.new(val44 - 6, y - 1)
                val34.healthBack.Size = Vector2.new(4, val42 + 2)
                val34.healthBack.Visible = esp.health
                val34.healthBar.Position = Vector2.new(val44 - 5, y + val42 * (1 - val51))
                val34.healthBar.Size = Vector2.new(2, val42 * val51)
                val34.healthBar.Color = Color3.fromHSV(val51 * 0.33, 1, 1)
                val34.healthBar.Visible = esp.health
                local val52 = val37.RigType == Enum.HumanoidRigType.R15 and val9 or val10
                for idx, item2 in ipairs(val34.lines) do
                    local skeleton = esp.skeleton and val52[idx]
                    local val53 = skeleton and character:FindFirstChild(skeleton[1])
                    local val54 = skeleton and character:FindFirstChild(skeleton[2])
                    if val53 and val54 then
                        local val55 = currentCamera:WorldToViewportPoint(val53.Position)
                        local val56 = currentCamera:WorldToViewportPoint(val54.Position)
                        if val55.Z > 0 and val56.Z > 0 then
                            item2.From = Vector2.new(val55.X, val55.Y)
                            item2.To = Vector2.new(val56.X, val56.Y)
                            item2.Color = val41 or esp.skeletonColor
                            item2.Visible = true
                        else
                            item2.Visible = false
                        end
                    else
                        item2.Visible = false
                    end
                end
                if esp.chams then
                    helperFn33(val34, character)
                elseif val34.highlight then
                    val34.highlight.Enabled = false
                end
            end
        end
    end
end
local function helperFn35(arg1)
    local frame = Instance.new("Frame")
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.BackgroundTransparency = 1
    frame.BorderSizePixel = 0
    frame.Visible = false
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(1, 0)
    uiCorner.Parent = frame
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = arg1
    uiStroke.Thickness = 1
    uiStroke.Parent = frame
    frame.Parent = val14.gui
    return frame
end
local function helperFn36(arg1, arg2)
    local val34 = UserInputService:GetMouseLocation()
    arg1.Visible = arg2.enabled and arg2.showFov
    arg1.Position = UDim2.fromOffset(val34.X, val34.Y)
    arg1.Size = UDim2.fromOffset(arg2.fov * 2, arg2.fov * 2)
end
local function helperFn37()
    local val34 = UserInputService:GetMouseLocation()
    local val35 = currentCamera:ViewportPointToRay(val34.X, val34.Y)
    local val36 = RaycastParams.new()
    val36.FilterType = Enum.RaycastFilterType.Exclude
    val36.FilterDescendantsInstances = {localPlayer.Character}
    local val37 = workspace:Raycast(val35.Origin, val35.Direction * 5000, val36)
    local val38 = val37 and val37.Instance:FindFirstAncestorOfClass("Model")
    local val39 = val38 and Players:GetPlayerFromCharacter(val38)
    if val39 and val39 ~= localPlayer then
        return val39
    end
    local val40 = helperFn11("HumanoidRootPart", val33.target.assist, false, "Cursor")
    return val40
end
local function helperFn38(arg1)
    val32.manualTarget = arg1
    val32.lock = nil
    val32.rageTarget = nil
    val32.shootTimer = 0
    if arg1 then
        helperFn25("Target: " .. arg1.DisplayName .. " (@" .. arg1.Name .. ")")
    else
        helperFn25("Target cleared")
    end
end
local function helperFn39(arg1)
    local aimbot = val33.aimbot
    local val34
    if aimbot.activation == "Toggle" then
        val34 = val32.aimbotToggled
    else
        val34 = val11.isBindHeld(val33.binds.aimbot)
    end
    if not (aimbot.enabled and val34) then
        val32.lock = nil
        return
    end
    local lock = val32.lock
    local sticky = aimbot.sticky and helperFn9(lock, aimbot.hitPart)
    if not sticky then
        local val35 = helperFn12(aimbot.hitPart, aimbot.fov, aimbot.wallCheck, aimbot.priority)
        local sticky2 = aimbot.sticky
        lock = val35
        if sticky2 then
            sticky2 = lock
        end
        if not sticky2 then
            sticky2 = nil
        end
        val32.lock = sticky2
    end
    if not lock then
        return
    end
    helperFn10(lock)
    local hitPart = aimbot.hitPart
    local val35
    if aimbot.autoPrediction then
        local val36 = helperFn2()
        val35 = val36 / 1000 * aimbot.pingScale
    else
        val35 = aimbot.prediction
    end
    local val36 = helperFn15(lock, hitPart, val35)
    if not val36 then
        return
    end
    local val37 = lock.Character:FindFirstChild(aimbot.hitPart)
    local wallCheck = aimbot.wallCheck
    if wallCheck then
        local val38 = helperFn8(val37)
        wallCheck = not val38
    end
    if wallCheck then
        return
    end
    local val38 = 1 - (1 - aimbot.smoothing) ^ (arg1 * 60)
    if aimbot.mode == "Camera" then
        local cFrame = currentCamera.CFrame
        local val39 = cFrame:Lerp(CFrame.new(cFrame.Position, val36), val38)
        currentCamera.CFrame = val39
        return
    end
    local val39 = isrbxactive()
    if not val39 then
        return
    end
    local val40, val41 = currentCamera:WorldToViewportPoint(val36)
    if not val41 then
        return
    end
    local val42 = UserInputService:GetMouseLocation()
    mousemoverel((val40.X - val42.X) * val38, (val40.Y - val42.Y) * val38)
end
local function helperFn40()
    val32.silentTarget = nil
    val32.silentTargetPart = nil
    local silentAim = val33.silentAim
    local hit = val33.target.hit and val32.manualTarget ~= nil
    if not (silentAim.enabled or hit) then
        return
    end
    local val34 = nil
    local val35 = hit and helperFn9(val32.manualTarget, silentAim.hitPart)
    if val35 then
        val34 = val32.manualTarget
    elseif silentAim.enabled then
        local fov = silentAim.fov
        local wallCheck = silentAim.wallCheck
        local hitPart = silentAim.hitPart
        if wallCheck then
            wallCheck = not val33.wallbang.enabled
        end
        val34 = helperFn11(hitPart, fov, wallCheck, "Cursor")
    end
    if not val34 then
        return
    end
    local val36 = val34 == val32.manualTarget and 100 or silentAim.hitChance
    local val37 = math.random(1, 100)
    if val37 > val36 then
        return
    end
    helperFn10(val34)
    local hitPart = silentAim.hitPart
    local val38
    if silentAim.autoPrediction then
        local val39 = helperFn2()
        val38 = val39 / 1000 * silentAim.pingScale
    else
        val38 = silentAim.prediction
    end
    local val39 = helperFn15(val34, hitPart, val38)
    val32.silentTarget = val39
    val32.silentTargetPart = val34.Character:FindFirstChild(silentAim.hitPart)
end
local function helperFn41()
    local rage = val33.rage
    if not rage.enabled then
        val32.rageTarget = nil
        return
    end
    local character = localPlayer.Character
    local val34 = character and character:FindFirstChild("HumanoidRootPart")
    if not val34 then
        return
    end
    local val35 = helperFn9(val32.rageTarget, rage.hitPart)
    local val36 = not val35 or val32.manualTarget and val32.rageTarget ~= val32.manualTarget and helperFn9(val32.manualTarget, rage.hitPart)
    if val36 then
        local val37 = helperFn13(val34.Position, rage.hitPart)
        val32.rageTarget = val37
    end
    local rageTarget = val32.rageTarget
    if not rageTarget then
        return
    end
    helperFn10(rageTarget)
    local hitPart = rage.hitPart
    local val37
    if rage.autoPrediction then
        local val38 = helperFn2()
        val37 = val38 / 1000 * rage.pingScale
    else
        val37 = rage.prediction
    end
    local val38 = helperFn15(rageTarget, hitPart, val37)
    if not val38 then
        return
    end
    val32.silentTarget = val38
    val32.silentTargetPart = rageTarget.Character:FindFirstChild(rage.hitPart)
    if rage.lockCamera then
        local val39 = CFrame.lookAt(currentCamera.CFrame.Position, val38)
        currentCamera.CFrame = val39
    end
end
local stateMap48 = {}
stateMap48[3] = "UpperTorso"
stateMap48[2] = "HumanoidRootPart"
stateMap48[1] = "Head"
stateMap48[4] = "Torso"
local val34 = stateMap48
local function helperFn42(arg1, arg2)
    local val35 = UserInputService:GetMouseLocation()
    local val36 = currentCamera:ViewportPointToRay(val35.X, val35.Y)
    local val37 = RaycastParams.new()
    val37.FilterType = Enum.RaycastFilterType.Exclude
    val37.FilterDescendantsInstances = {arg2}
    local val38 = workspace:Raycast(val36.Origin, val36.Direction * arg1.range, val37)
    local val39 = val38 and val38.Instance:FindFirstAncestorOfClass("Model")
    local val40 = val39 and Players:GetPlayerFromCharacter(val39)
    local val41 = val40 and helperFn9(val40, "HumanoidRootPart")
    if val41 then
        return val40
    end
    local wallCheck = arg1.wallCheck and not val33.wallbang.enabled
    local position = currentCamera.CFrame.Position
    local val42, val43, val44 = ipairs(Players:GetPlayers())
    local val45, val46, val47 = helperFn(val42, val43, val44)
    local val48, val49 = val45(val46, val47)
    if val48 == nil then
        return nil
    end
    local val50
    while true do
        local val51 = helperFn9(val49, "HumanoidRootPart")
        if not val51 then
            val48, val49 = val45(val46, val48)
            if val48 == nil then
                return nil
            end
        else
            local val52, val53, val54 = ipairs(val34)
            local val55, val56, val57 = helperFn(val52, val53, val54)
            local val58
            val58, val50 = val55(val56, val57)
            if val58 == nil then
                val48, val49 = val45(val46, val48)
                if val48 == nil then
                    return nil
                end
            else
                local val59 = val49.Character:FindFirstChild(val50)
                if not val59 then
                    return nil
                end
                if ((val59.Position - position)).Magnitude > arg1.range then
                    return nil
                end
                local val60, val61 = currentCamera:WorldToViewportPoint(val59.Position)
                if not val61 then
                    return nil
                end
                if ((Vector2.new(val60.X, val60.Y) - val35)).Magnitude > arg1.radius then
                    return nil
                end
                local val62 = wallCheck
                if val62 then
                    local val63 = RaycastParams.new()
                    val63.FilterType = Enum.RaycastFilterType.Exclude
                    local stateMap49 = {}
                    local character = localPlayer.Character
                    stateMap49[2] = val59.Parent
                    stateMap49[1] = character
                    val63.FilterDescendantsInstances = stateMap49
                    local position2 = currentCamera.CFrame.Position
                    local val64 = workspace:Raycast(position2, val59.Position - position2, val63)
                    val62 = not (val64 == nil)
                end
                if val62 then
                    return nil
                end
                return val49
            end
        end
    end
end
local function helperFn43(arg1)
    local trigger = val33.trigger
    if not trigger.enabled then
        val32.triggerTimer = 0
        return
    end
    local character = localPlayer.Character
    local val35 = character and character:FindFirstChildOfClass("Tool")
    if not val35 then
        return
    end
    local val36 = helperFn42(trigger, character)
    if not val36 then
        val32.triggerTimer = 0
        return
    end
    helperFn10(val36)
    if val33.wallbang.enabled and not val32.silentTarget then
        local silentAim = val33.silentAim
        local hitPart = silentAim.hitPart
        local val37
        if silentAim.autoPrediction then
            local val38 = helperFn2()
            val37 = val38 / 1000 * silentAim.pingScale
        else
            val37 = silentAim.prediction
        end
        local val38 = helperFn15(val36, hitPart, val37)
        if val38 then
            val32.silentTarget = val38
            val32.silentTargetPart = val36.Character:FindFirstChild(silentAim.hitPart)
        end
    end
    val32.triggerTimer = val32.triggerTimer + arg1
    if val32.triggerTimer < trigger.delay then
        return
    end
    val32.triggerTimer = 0
    local val37 = trigger.method == "Click" and isrbxactive()
    if val37 then
        val32.lastFire = os.clock()
        mouse1click()
        return
    end
    val32.lastFire = os.clock()
    val35:Deactivate()
    val35:Activate()
end
local function helperFn44(arg1)
    local val35 = localPlayer:FindFirstChildOfClass("Backpack")
    for _, item in ipairs({arg1, val35}) do
        if item then
            for _, child in ipairs(item:GetChildren()) do
                local val36 = child:IsA("Tool") and child:FindFirstChild("Ammo")
                if val36 then
                    return child
                end
            end
        end
    end
    return nil
end
local function helperFn45(arg1, arg2, arg3)
    local target = val33.target
    local autoShoot = target.autoShoot
    local manualTarget = val32.manualTarget
    if autoShoot then
        autoShoot = manualTarget
    end
    if autoShoot then
        autoShoot = helperFn9(manualTarget, "HumanoidRootPart")
    end
    if not autoShoot then
        val32.shootTimer = 0
        return
    end
    local val35 = arg2:FindFirstChildOfClass("Tool")
    local autoEquip = target.autoEquip
    if autoEquip then
        local val36 = val35 and val35:FindFirstChild("Ammo")
        autoEquip = not val36
    end
    if autoEquip then
        local val36 = helperFn44(arg2)
        if val36 and val36.Parent ~= arg2 then
            arg3:EquipTool(val36)
            return
        end
    end
    if not val35 then
        return
    end
    val32.shootTimer = val32.shootTimer + arg1
    if val32.shootTimer >= 1 / target.rate then
        val32.shootTimer = 0
        val32.lastFire = os.clock()
        val35:Deactivate()
        val35:Activate()
    end
end
local function helperFn46(arg1, arg2)
    local hitbox = val33.hitbox
    local val35 = val32.hitboxOriginals[arg1]
    if arg2 then
        if not val35 then
            local stateMap49 = {}
            local hitboxOriginals = val32.hitboxOriginals
            stateMap49.size = arg1.Size
            stateMap49.transparency = arg1.Transparency
            stateMap49.canCollide = arg1.CanCollide
            stateMap49.massless = arg1.Massless
            hitboxOriginals[arg1] = stateMap49
        end
        arg1.Size = Vector3.new(hitbox.size, hitbox.size, hitbox.size)
        arg1.Transparency = hitbox.transparency
        arg1.CanCollide = false
        arg1.CanQuery = true
        arg1.CanTouch = true
        arg1.Massless = true
    elseif val35 then
        arg1.Size = val35.size
        arg1.Transparency = val35.transparency
        arg1.CanCollide = val35.canCollide
        arg1.Massless = val35.massless
        val32.hitboxOriginals[arg1] = nil
    end
end
local function helperFn47()
    local hitbox = val33.hitbox
    local val35 = hitbox.part == "Both" and {"HumanoidRootPart", "Head"} or {hitbox.part}
    for _, item in ipairs(Players:GetPlayers()) do
        if item ~= localPlayer then
            local character = item.Character
            if character then
                local enabled = hitbox.enabled
                if enabled then
                    local val36
                    if not val33.checks.team then
                        val36 = false
                    else
                        val36 = item.Team ~= nil and item.Team == localPlayer.Team
                    end
                    enabled = not val36
                end
                if enabled then
                    enabled = not val32.whitelist[item]
                end
                local stateMap49 = {}
                stateMap49[2] = "Head"
                stateMap49[1] = "HumanoidRootPart"
                for _, item2 in ipairs(stateMap49) do
                    local val36 = character:FindFirstChild(item2)
                    if val36 then
                        local val37 = enabled
                        if val37 then
                            local val38 = table.find(val35, item2)
                            val37 = val38 ~= nil
                        end
                        helperFn46(val36, val37)
                    end
                end
            end
        end
    end
end
local function helperFn48(arg1)
    if arg1.X ~= arg1.X or arg1.Y ~= arg1.Y or arg1.Z ~= arg1.Z then
        return false
    end
    local val35 = math.abs(arg1.X) < 100000 and math.abs(arg1.Y) < 100000 and math.abs(arg1.Z) < 100000
    return val35
end
local function helperFn49(arg1, arg2, arg3, arg4)
    local val35 = helperFn48(arg2) and helperFn48(arg3)
    if not val35 then
        return false
    end
    if arg4 then
        local val36 = Vector3.new(arg2.X, arg3.Y, arg2.Z)
        if ((val36 - arg3)).Magnitude < 0.1 then
            return false
        end
        local val37 = CFrame.lookAt(arg3, val36)
        arg1.CFrame = val37
    else
        arg1.CFrame = CFrame.new(arg3) * arg1.CFrame.Rotation
    end
    arg1.AssemblyLinearVelocity = Vector3.zero
    arg1.AssemblyAngularVelocity = Vector3.zero
    return true
end
local function helperFn50(arg1, arg2)
    local orbit = val33.orbit
    if not orbit.enabled then
        val32.orbitTarget = nil
        return
    end
    local orbitTarget = val32.orbitTarget
    if orbit.player ~= "Closest" then
        orbitTarget = helperFn14(orbit.player, "HumanoidRootPart")
        val32.orbitTarget = orbitTarget
    else
        local val35 = helperFn9(orbitTarget, "HumanoidRootPart")
        if not val35 then
            if orbit.target == "Cursor" then
                orbitTarget = helperFn11("HumanoidRootPart", 5000, false, "Cursor")
            else
                orbitTarget = helperFn13(arg2.Position, "HumanoidRootPart")
            end
            val32.orbitTarget = orbitTarget
        end
    end
    if not orbitTarget then
        return
    end
    local character = orbitTarget.Character and orbitTarget.Character:FindFirstChild("HumanoidRootPart")
    if not character then
        return
    end
    local position = character.Position
    local orbitAngle = val32.orbitAngle
    local val35 = orbit.speed * math.min(arg1, 0.1)
    val32.orbitAngle = (orbitAngle + val35) % (math.pi * 2)
    local val36 = math.cos(val32.orbitAngle)
    local val37 = val36 * orbit.radius
    local height = orbit.height
    local val38 = math.sin(val32.orbitAngle)
    helperFn49(arg2, position, position + Vector3.new(val37, height, val38 * orbit.radius), orbit.face)
end
local function helperFn51(arg1, arg2, arg3)
    local rage = val33.rage
    local enabled = rage.enabled
    local rageTarget = val32.rageTarget
    if enabled then
        enabled = rageTarget
    end
    if enabled then
        enabled = helperFn9(rageTarget, "HumanoidRootPart")
    end
    if not enabled then
        return
    end
    if rage.orbit then
        local position = rageTarget.Character.HumanoidRootPart.Position
        local rageAngle = val32.rageAngle
        local val35 = rage.speed * math.min(arg1, 0.1)
        val32.rageAngle = (rageAngle + val35) % (math.pi * 2)
        local val36 = math.cos(val32.rageAngle)
        local val37 = val36 * rage.radius
        local height = rage.height
        local val38 = math.sin(val32.rageAngle)
        helperFn49(arg3, position, position + Vector3.new(val37, height, val38 * rage.radius), true)
    end
    local val35 = arg2:FindFirstChildOfClass("Tool")
    if not (rage.autoFire and val35) then
        return
    end
    val32.rageTimer = val32.rageTimer + arg1
    if val32.rageTimer >= 1 / rage.rate then
        val32.rageTimer = 0
        val32.lastFire = os.clock()
        val35:Deactivate()
        val35:Activate()
    end
end
local function helperFn52(arg1)
    local parent = arg1.Parent
    if not parent then
        return nil
    end
    if parent:IsA("BasePart") then
        return parent
    end
    if parent:IsA("Attachment") then
        local parent2 = parent.Parent and parent.Parent:IsA("BasePart") and parent.Parent or nil
        return parent2
    end
    if parent:IsA("Model") then
        local primaryPart = parent.PrimaryPart or parent:FindFirstChildWhichIsA("BasePart", true)
        return primaryPart
    end
    return nil
end
local function hatchSelectedEgg(arg1, arg2)
    local stateMap49 = {}
    if arg1:IsA("ProximityPrompt") then
        table.insert(stateMap49, arg1.ObjectText)
        table.insert(stateMap49, arg1.ActionText)
    end
    local parent = arg1.Parent
    for i = 1, 4 do
        if not parent or parent == workspace then
            break
        end
        table.insert(stateMap49, parent.Name)
        parent = parent.Parent
    end
    local value = 0
    for _, item in ipairs(stateMap49) do
        local val35 = string.lower(item)
        local val36 = not string.find(val35, arg2, 1, true)
        if not val36 then
            local value2 = 2
            if string.find(val35, "high", 1, true) then
                value2 = 3
            elseif string.find(val35, "fire", 1, true) then
                value2 = 1
            end
            value = math.max(value, value2)
        end
    end
    return value
end
local function hatchSelectedEgg2()
    local armorDetector = val32.armorDetector
    if armorDetector and armorDetector.Parent then
        return armorDetector
    end
    if os.clock() < val32.armorScanTime then
        return nil
    end
    local val35 = os.clock() + 10
    val32.armorScanTime = val35
    local val36 = string.lower(val33.armor.keyword)
    local value = 0
    local val37 = nil
    for _, desc in ipairs(workspace:GetDescendants()) do
        local val38 = desc:IsA("ClickDetector") or desc:IsA("ProximityPrompt")
        if val38 then
            local val39 = helperFn52(desc)
            if val39 then
                local val40 = hatchSelectedEgg(desc, val36)
                if val40 > value then
                    val37 = desc
                    value = val40
                end
            end
        end
    end
    val32.armorDetector = val37
    return val37
end
local function hatchSelectedEgg3()
    local stateMap49 = {}
    for _, desc in ipairs(workspace:GetDescendants()) do
        local val35 = desc:IsA("ClickDetector") or desc:IsA("ProximityPrompt")
        if val35 then
            local className = desc.ClassName
            local val36 = desc:GetFullName()
            local val37 = className .. " | " .. val36
            if desc:IsA("ProximityPrompt") then
                val37 = val37 .. " | " .. desc.ObjectText .. " / " .. desc.ActionText
            end
            table.insert(stateMap49, val37)
        end
    end
    local val35 = table.concat(stateMap49, "\n")
    warn("[Potent] Interactables:\n" .. val35)
    if setclipboard then
        setclipboard(val35)
    end
    helperFn25("Scan done: " .. #stateMap49 .. " interactables (copied to clipboard)")
end
local function hatchSelectedEgg4()
    local character = localPlayer.Character
    local val35 = character and character:FindFirstChild("HumanoidRootPart")
    if not val35 then
        return
    end
    val32.armorScanTime = 0
    local val36 = hatchSelectedEgg2()
    if not val36 then
        helperFn25("Auto armor: nothing matching '" .. val33.armor.keyword .. "' found")
        return
    end
    local val37 = character
    local val38 = val35
    local val39 = val36
    if not val32.buyingArmor then
        val32.buyingArmor = true
        task.spawn(function()
            local cFrame = val38.CFrame
            local val40 = helperFn5(val37)
            local ok, res = pcall(function()
                local val41 = helperFn52(val39)
                val38.CFrame = val41.CFrame * CFrame.new(0, 1, 3)
                val38.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.3)
                for i = 1, 3 do
                    if val39:IsA("ProximityPrompt") then
                        fireproximityprompt(val39)
                    else
                        fireclickdetector(val39)
                    end
                    task.wait(0.2)
                end
                task.wait(0.4)
            end)
            if val38.Parent then
                val38.CFrame = cFrame
            end
            val32.buyingArmor = false
            if not ok then
                warn("[Potent] Armor buy error:", res)
            end
            local val41 = helperFn5(val37)
            if val41 <= val40 then
                helperFn25("Auto armor: no armor gained (cash or wrong item), use Scan shop")
            end
        end)
    end
end
local function hatchSelectedEgg5(arg1, arg2, arg3)
    local armor = val33.armor
    if not armor.enabled or val32.buyingArmor then
        return
    end
    local val35 = arg2.Health <= 0 or helperFn4(arg1)
    if val35 then
        return
    end
    if os.clock() < val32.armorCooldown then
        return
    end
    local val36 = helperFn5(arg1)
    if val36 > armor.threshold then
        return
    end
    local val37 = hatchSelectedEgg2()
    if not val37 then
        local val38 = os.clock() + 8
        val32.armorCooldown = val38
        helperFn25("Auto armor: nothing matching '" .. armor.keyword .. "' found")
        return
    end
    local val38 = os.clock() + armor.cooldown
    val32.armorCooldown = val38
    local val39 = val37
    if not val32.buyingArmor then
        val32.buyingArmor = true
        task.spawn(function()
            local cFrame = arg3.CFrame
            local val40 = helperFn5(arg1)
            local ok, res = pcall(function()
                local val41 = helperFn52(val39)
                arg3.CFrame = val41.CFrame * CFrame.new(0, 1, 3)
                arg3.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.3)
                for i = 1, 3 do
                    if val39:IsA("ProximityPrompt") then
                        fireproximityprompt(val39)
                    else
                        fireclickdetector(val39)
                    end
                    task.wait(0.2)
                end
                task.wait(0.4)
            end)
            if arg3.Parent then
                arg3.CFrame = cFrame
            end
            val32.buyingArmor = false
            if not ok then
                warn("[Potent] Armor buy error:", res)
            end
            local val41 = helperFn5(arg1)
            if val41 <= val40 then
                helperFn25("Auto armor: no armor gained (cash or wrong item), use Scan shop")
            end
        end)
    end
end
local function helperFn53(arg1)
    local val35 = localPlayer:FindFirstChildOfClass("Backpack")
    for _, item in ipairs({arg1, val35}) do
        if item then
            for _, child in ipairs(item:GetChildren()) do
                local val36 = child:IsA("Tool") and string.find(string.lower(child.Name), "katana", 1, true)
                if val36 then
                    return child
                end
            end
        end
    end
    return nil
end
local function helperFn54(arg1, arg2, arg3, arg4)
    local katana = val33.katana
    if not katana.enabled then
        val32.katanaTimer = 0
        return
    end
    local val35 = helperFn53(arg2)
    if not val35 then
        return
    end
    if val35.Parent ~= arg2 then
        arg3:EquipTool(val35)
        return
    end
    local val36
    if katana.player ~= "Closest" then
        val36 = helperFn14(katana.player, "HumanoidRootPart")
    else
        val36 = helperFn13(arg4.Position, "HumanoidRootPart")
    end
    if not val36 then
        return
    end
    local humanoidRootPart = val36.Character.HumanoidRootPart
    local magnitude = ((humanoidRootPart.Position - arg4.Position)).Magnitude
    if magnitude > katana.maxDistance then
        return
    end
    helperFn10(val36)
    if katana.approach then
        local val37 = CFrame.lookAt(((humanoidRootPart.CFrame * CFrame.new(0, 0, katana.distance))).Position, humanoidRootPart.Position)
        arg4.CFrame = val37
        arg4.AssemblyLinearVelocity = Vector3.zero
        val32.katanaTimer = val32.katanaTimer + arg1
        if val32.katanaTimer >= 1 / katana.rate then
            val32.katanaTimer = 0
            val35:Activate()
        end
        return
    end
    if magnitude <= katana.range then
        local val37 = CFrame.lookAt(arg4.Position, Vector3.new(humanoidRootPart.Position.X, arg4.Position.Y, humanoidRootPart.Position.Z))
        arg4.CFrame = val37
        val32.katanaTimer = val32.katanaTimer + arg1
        if val32.katanaTimer >= 1 / katana.rate then
            val32.katanaTimer = 0
            val35:Activate()
        end
    end
end
local function helperFn55(arg1, arg2, arg3)
    local antiStomp = val33.antiStomp
    if arg2.Health <= 0 then
        val32.stompOrigin = nil
        return
    end
    local enabled = antiStomp.enabled and helperFn4(arg1)
    if not enabled then
        if val32.stompOrigin then
            arg3.CFrame = val32.stompOrigin
            val32.stompOrigin = nil
        end
        return
    end
    if antiStomp.method == "Reset" then
        arg2.Health = 0
        return
    end
    if not val32.stompOrigin then
        val32.stompOrigin = arg3.CFrame
    end
    arg3.CFrame = val32.stompOrigin + Vector3.new(0, antiStomp.height, 0)
    arg3.AssemblyLinearVelocity = Vector3.zero
end
local function helperFn56()
    local mainEvent = val32.mainEvent
    if mainEvent and mainEvent.Parent then
        return mainEvent
    end
    val32.mainEvent = ReplicatedStorage:FindFirstChild("MainEvent", true)
    return val32.mainEvent
end
local function helperFn57(arg1, arg2)
    local autoStomp = val33.autoStomp
    local val35 = nil
    local huge = math.huge
    if autoStomp.enabled then
        for _, item in ipairs(Players:GetPlayers()) do
            if not (item == localPlayer or val32.whitelist[item]) then
                local character = item.Character
                local val36 = character and character:FindFirstChild("HumanoidRootPart")
                local val37 = val36 and helperFn4(character)
                if val37 then
                    local magnitude = ((val36.Position - arg2.Position)).Magnitude
                    local val38 = magnitude < huge and (autoStomp.teleport or magnitude <= autoStomp.range)
                    if val38 then
                        val35 = item
                        huge = magnitude
                    end
                end
            end
        end
    end
    if not val35 then
        if val32.stompBack then
            arg2.CFrame = val32.stompBack
            val32.stompBack = nil
        end
        val32.stompTimer = 0
        return
    end
    if autoStomp.teleport then
        val32.stompBack = val32.stompBack or arg2.CFrame
        arg2.CFrame = val35.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2.5, 0)
        arg2.AssemblyLinearVelocity = Vector3.zero
    end
    val32.stompTimer = val32.stompTimer + arg1
    if val32.stompTimer < 1 / autoStomp.rate then
        return
    end
    val32.stompTimer = 0
    local val36 = helperFn56()
    if val36 then
        val36:FireServer("Stomp")
    else
        local val37 = isrbxactive()
        if val37 then
            keytap(69)
        end
    end
end
local function helperFn58()
    local aaVelocity = val32.aaVelocity
    if not aaVelocity then
        return
    end
    val32.aaVelocity = nil
    local character = localPlayer.Character
    local val35 = character and character:FindFirstChild("HumanoidRootPart")
    if val35 then
        val35.AssemblyLinearVelocity = aaVelocity
    end
end
local function helperFn59(arg1, arg2)
    local antiAim = val33.antiAim
    if not antiAim.enabled or (val33.fly.enabled or val33.spinbot.enabled or val33.orbit.enabled or val33.katana.enabled or val33.rage.enabled or val32.flinging) then
        if val32.aaApplied then
            arg1.AutoRotate = true
            val32.aaApplied = false
        end
        return
    end
    val32.aaApplied = true
    if antiAim.method == "Jitter" then
        arg1.AutoRotate = false
        local cFrame = arg2.CFrame
        local val35 = math.random()
        local val36 = math.rad((val35 * 2 - 1) * antiAim.angle)
        arg2.CFrame = cFrame * CFrame.Angles(0, val36, 0)
        return
    end
    arg1.AutoRotate = true
    val32.aaVelocity = arg2.AssemblyLinearVelocity
    local aaVelocity = val32.aaVelocity
    local val35 = math.random()
    local val36 = (val35 * 2 - 1) * antiAim.amount
    local val37 = math.random()
    arg2.AssemblyLinearVelocity = aaVelocity + Vector3.new(val36, 0, (val37 * 2 - 1) * antiAim.amount)
end
local function helperFn60(arg1, arg2, arg3)
    if not val33.fly.enabled then
        if val32.flying then
            arg2.PlatformStand = false
            val32.flying = false
        end
        return
    end
    val32.flying = true
    arg2.PlatformStand = true
    local cFrame = currentCamera.CFrame
    local zero = Vector3.zero
    local val35 = UserInputService:IsKeyDown(Enum.KeyCode.W)
    if val35 then
        zero = zero + cFrame.LookVector
    end
    local val36 = UserInputService:IsKeyDown(Enum.KeyCode.S)
    if val36 then
        zero = zero - cFrame.LookVector
    end
    local val37 = UserInputService:IsKeyDown(Enum.KeyCode.D)
    if val37 then
        zero = zero + cFrame.RightVector
    end
    local val38 = UserInputService:IsKeyDown(Enum.KeyCode.A)
    if val38 then
        zero = zero - cFrame.RightVector
    end
    local val39 = UserInputService:IsKeyDown(Enum.KeyCode.Space)
    if val39 then
        zero = zero + Vector3.yAxis
    end
    local val40 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
    if val40 then
        zero = zero - Vector3.yAxis
    end
    arg3.AssemblyLinearVelocity = Vector3.zero
    if zero.Magnitude > 0 then
        arg3.CFrame = arg3.CFrame + zero.Unit * val33.fly.value * arg1
    end
end
local function helperFn61(arg1)
    if val32.flinging or not arg1 then
        return
    end
    local character = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local val35 = character and arg1.Character and arg1.Character:FindFirstChild("HumanoidRootPart")
    if not val35 then
        return
    end
    val32.flinging = true
    local cFrame = character.CFrame
    task.spawn(function()
        local val36 = os.clock()
        while true do
            local alive = val32.alive
            if alive then
                local val37 = os.clock() - val36
                alive = val37 < val33.fling.duration
            end
            if alive then
                local character2 = arg1.Character and arg1.Character:FindFirstChild("HumanoidRootPart")
                if not (character2 and character.Parent) then
                    break
                end
                local cFrame2 = character2.CFrame
                local val37 = math.random(-1, 1)
                local val38 = math.random(-1, 1)
                character.CFrame = cFrame2 * CFrame.new(val37 * 0.5, 0, val38 * 0.5)
                character.AssemblyLinearVelocity = Vector3.new(900000, 900000, 900000)
                character.AssemblyAngularVelocity = Vector3.new(0, 900000, 0)
                RunService.Heartbeat:Wait()
            else
                break
            end
        end
        if character.Parent then
            character.AssemblyLinearVelocity = Vector3.zero
            character.AssemblyAngularVelocity = Vector3.zero
            character.CFrame = cFrame
        end
        val32.flinging = false
    end)
end
local function helperFn62(arg1)
    local character = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local val35 = arg1 and arg1.Character and arg1.Character:FindFirstChild("HumanoidRootPart")
    if not (character and val35) then
        return
    end
    character.CFrame = val35.CFrame * CFrame.new(0, 0, 3)
end
local function helperFn63()
    local spectatePlayer = val32.spectatePlayer
    if not spectatePlayer then
        return
    end
    local character = spectatePlayer.Character and spectatePlayer.Character:FindFirstChildOfClass("Humanoid")
    if character and currentCamera.CameraSubject ~= character then
        currentCamera.CameraSubject = character
    end
end
local function helperFn64()
    val32.spectatePlayer = nil
    local character = localPlayer.Character and localPlayer.Character:FindFirstChildOfClass("Humanoid")
    if character then
        currentCamera.CameraSubject = character
    end
end
local function helperFn65(arg1)
    local stateMap49 = {}
    if val32.manualTarget == arg1 then
        local val35 = helperFn3(val3)
        table.insert(stateMap49, "<font color=\"#" .. val35 .. "\">TARGET</font>")
    end
    if val32.whitelist[arg1] then
        local val35 = helperFn3(val4)
        table.insert(stateMap49, "<font color=\"#" .. val35 .. "\">WHITELIST</font>")
    end
    if val32.spectatePlayer == arg1 then
        table.insert(stateMap49, "SPECTATING")
    end
    local val35 = helperFn6(arg1)
    if val35 then
        table.insert(stateMap49, "DOWN")
    end
    return table.concat(stateMap49, "  ")
end
local function helperFn66(arg1)
    if stateMap20[arg1] or arg1 == localPlayer or not val28 then
        return
    end
    local colors = val11.colors
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -6, 0, 44)
    button.BackgroundColor3 = colors.panel
    button.BorderSizePixel = 0
    button.Text = ""
    button.AutoButtonColor = false
    button.Parent = val28
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = colors.border
    uiStroke.Thickness = 1
    uiStroke.Parent = button
    local imageLabel = Instance.new("ImageLabel")
    imageLabel.Position = UDim2.fromOffset(6, 5)
    imageLabel.Size = UDim2.fromOffset(34, 34)
    imageLabel.BackgroundColor3 = colors.window
    imageLabel.BorderSizePixel = 0
    imageLabel.Parent = button
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Position = UDim2.fromOffset(48, 5)
    label.Size = UDim2.new(0.45, -48, 0, 16)
    label.Font = Enum.Font.Code
    label.TextSize = 13
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Text = arg1.DisplayName
    label.Parent = button
    local label2 = Instance.new("TextLabel")
    label2.BackgroundTransparency = 1
    label2.Position = UDim2.fromOffset(48, 23)
    label2.Size = UDim2.new(0.45, -48, 0, 16)
    label2.Font = Enum.Font.Code
    label2.TextSize = 12
    label2.TextColor3 = colors.dim
    label2.TextXAlignment = Enum.TextXAlignment.Left
    label2.TextTruncate = Enum.TextTruncate.AtEnd
    label2.Text = "@" .. arg1.Name
    label2.Parent = button
    local label3 = Instance.new("TextLabel")
    label3.BackgroundTransparency = 1
    label3.Position = UDim2.new(0.45, 0, 0, 5)
    label3.Size = UDim2.new(0.55, -8, 0, 16)
    label3.Font = Enum.Font.Code
    label3.TextSize = 12
    label3.TextColor3 = colors.text
    label3.TextXAlignment = Enum.TextXAlignment.Right
    label3.Parent = button
    local label4 = Instance.new("TextLabel")
    label4.BackgroundTransparency = 1
    label4.Position = UDim2.new(0.45, 0, 0, 23)
    label4.Size = UDim2.new(0.55, -8, 0, 16)
    label4.Font = Enum.Font.Code
    label4.TextSize = 12
    label4.TextColor3 = colors.dim
    label4.TextXAlignment = Enum.TextXAlignment.Right
    label4.RichText = true
    label4.Parent = button
    helperFn16(arg1.UserId, function(arg12)
        imageLabel.Image = arg12
    end)
    button.MouseButton1Click:Connect(function() end)
    local stateMap49 = {}
    stateMap49.row = button
    stateMap49.stroke = uiStroke
    stateMap49.stat = label3
    stateMap49.tags = label4
    stateMap20[arg1] = stateMap49
end
local function helperFn67(arg1)
    local val35 = stateMap20[arg1]
    if not val35 then
        return
    end
    val35.row:Destroy()
    stateMap20[arg1] = nil
    if val30 == arg1 then
        val30 = nil
    end
end
local function helperFn68()
    if not val28 then
        return
    end
    local character = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
    local stateMap49 = {}
    for key in pairs(stateMap20) do
        table.insert(stateMap49, key)
    end
    table.sort(stateMap49, function(arg1, arg2)
        local val35 = string.lower(arg1.DisplayName) < string.lower(arg2.DisplayName)
        return val35
    end)
    for idx, item in ipairs(stateMap49) do
        local val35 = stateMap20[item]
        local character2 = item.Character
        local val36 = character2 and character2:FindFirstChildOfClass("Humanoid")
        local val37 = character2 and character2:FindFirstChild("HumanoidRootPart")
        val35.row.LayoutOrder = idx
        local stroke = val35.stroke
        local val38 = item == val30 and val11.getAccent() or val11.colors.border
        stroke.Color = val38
        local tags = val35.tags
        local val39 = helperFn65(item)
        tags.Text = val39
        if val36 and val37 then
            local val40 = character and ((character.Position - val37.Position)).Magnitude or 0
            local stat = val35.stat
            local val41 = math.max(val36.Health, 0)
            local maxHealth = val36.MaxHealth
            local val42 = helperFn5(character2)
            stat.Text = string.format("HP %d/%d  |  Armor %d  |  %d studs", val41, maxHealth, val42, val40)
        else
            val35.stat.Text = "no character"
        end
    end
    val29.Text = "Players: " .. #stateMap49 .. (val30 and "   |   Selected: " .. val30.DisplayName or "")
end
local function helperFn69(arg1)
    helperFn58()
    currentCamera = workspace.CurrentCamera
    helperFn36(val16, val33.aimbot)
    helperFn36(val17, val33.silentAim)
    helperFn63()
    helperFn40()
    helperFn39(arg1)
    helperFn41()
    helperFn43(arg1)
    helperFn34()
    helperFn29()
    helperFn28()
    helperFn19()
    helperFn20()
    helperFn22()
    -- This Source Was Generated by discord.gg/c3xVMnUUBv
    helperFn24(arg1)
    val32.listTimer = val32.listTimer + arg1
    if val32.listTimer >= 0.4 and val14 and val14.activeTab == "PlayerList" and val14.main.Visible then
        val32.listTimer = 0
        helperFn68()
    end
end
local function helperFn70(arg1)
    helperFn47()
    local character = localPlayer.Character
    local val35 = character and character:FindFirstChildOfClass("Humanoid")
    local val36 = character and character:FindFirstChild("HumanoidRootPart")
    if not (val35 and val36) then
        return
    end
    local untargetOnKo = val33.target.untargetOnKo and val32.manualTarget and helperFn6(val32.manualTarget)
    if untargetOnKo then
        helperFn38(nil)
    end
    hatchSelectedEgg5(character, val35, val36)
    if val32.buyingArmor then
        return
    end
    if val33.walk.enabled then
        val35.WalkSpeed = val33.walk.value
        val32.walkApplied = true
    elseif val32.walkApplied then
        val35.WalkSpeed = 16
        val32.walkApplied = false
    end
    if val33.speed.enabled and not val33.fly.enabled and val35.MoveDirection.Magnitude > 0 then
        val36.CFrame = val36.CFrame + val35.MoveDirection * val33.speed.value * arg1
    end
    if val33.jump.enabled then
        val35.UseJumpPower = true
        val35.JumpPower = val33.jump.value
        val32.jumpApplied = true
    elseif val32.jumpApplied then
        val35.JumpPower = 50
        val32.jumpApplied = false
    end
    if val33.spinbot.enabled then
        val35.AutoRotate = false
        local cFrame = val36.CFrame
        local val37 = math.rad(val33.spinbot.value)
        val36.CFrame = cFrame * CFrame.Angles(0, val37, 0)
        val32.spinning = true
    elseif val32.spinning then
        val35.AutoRotate = true
        val32.spinning = false
    end
    helperFn60(arg1, val35, val36)
    helperFn50(arg1, val36)
    helperFn51(arg1, character, val36)
    helperFn45(arg1, character, val35)
    helperFn54(arg1, character, val35, val36)
    helperFn55(character, val35, val36)
    helperFn57(arg1, val36)
    helperFn59(val35, val36)
end
local function helperFn71()
    helperFn47()
    if not (val33.noclip or val33.fly.enabled or val32.flinging or val33.orbit.enabled or val33.rage.enabled or val33.katana.enabled) then
        return
    end
    local character = localPlayer.Character
    if not character then
        return
    end
    for _, desc in ipairs(character:GetDescendants()) do
        if desc:IsA("BasePart") then
            desc.CanCollide = false
        end
    end
end
local function helperFn72(...)
    local val35, val36 = ...
    local val37 = type(val35)
    local val38 = val37 ~= "string"
    if not val38 then
        local val39 = typeof(val36)
        val38 = val39 ~= "Vector3"
    end
    if val38 then
        return nil
    end
    local val39 = not string.find(string.lower(val35), "mouse", 1, true)
    if val39 then
        return nil
    end
    local val40 = table.pack(...)
    val40[2] = val32.silentTarget
    return val40
end
local function helperFn73()
    local val35 = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
    if not val35 then
        local val36 = os.clock() - val32.lastFire
        val35 = val36 < 0.3
    end
    return val35
end
local function helperFn74(arg1)
    if val32.wallbangModel ~= arg1 or not val32.wallbangParams then
        local val35 = RaycastParams.new()
        val35.FilterType = Enum.RaycastFilterType.Include
        val35.FilterDescendantsInstances = {arg1}
        val32.wallbangModel = arg1
        val32.wallbangParams = val35
    end
    return val32.wallbangParams
end
local function helperFn75(arg1, ...)
    local character = localPlayer.Character
    local val35 = character and character:FindFirstChildOfClass("Tool")
    if not val35 then
        return nil
    end
    local val36 = table.pack(...)
    local silentTargetPart = val32.silentTargetPart
    local val37 = silentTargetPart and silentTargetPart.Parent
    local enabled = val33.wallbang.enabled and val37 ~= nil and helperFn73()
    local handle = val35:FindFirstChild("Handle")
    local val38 = handle and handle.Position
    if not val38 then
        local val39 = character:GetPivot()
        val38 = val39.Position
    end
    local val39 = val38
    local position = currentCamera.CFrame.Position
    local function helperFn76(arg12)
        return ((arg12 - val39)).Magnitude < 20 or ((arg12 - position)).Magnitude < 20
    end
    local val40 = arg1 == "Raycast"
    if val40 then
        local val41 = typeof(val36[1])
        val40 = val41 == "Vector3"
    end
    if val40 then
        local val41 = typeof(val36[2])
        val40 = val41 == "Vector3"
    end
    if val40 then
        local val41 = enabled and helperFn76(val36[1])
        local val42 = (val41 and silentTargetPart.Position or val32.silentTarget) - val36[1]
        if val42.Magnitude < 0.001 then
            return nil
        end
        val36[2] = val42.Unit * ((val33.silentAim.infiniteRange or val41) and 10000 or val36[2].Magnitude)
        if val41 then
            local val43 = helperFn74(val37)
            val36[3] = val43
            val36.n = math.max(val36.n, 3)
        end
        return val36, arg1
    end
    local val41 = arg1 == "FindPartOnRay" or arg1 == "FindPartOnRayWithIgnoreList" or arg1 == "FindPartOnRayWithWhitelist"
    if val41 then
        local val42 = typeof(val36[1])
        val41 = val42 == "Ray"
    end
    if val41 then
        local val42 = enabled
        local val43 = val36[1]
        if val42 then
            val42 = helperFn76(val43.Origin)
        end
        local val44 = (val42 and silentTargetPart.Position or val32.silentTarget) - val43.Origin
        if val44.Magnitude < 0.001 then
            return nil
        end
        local val45 = Ray.new(val43.Origin, val44.Unit * ((val33.silentAim.infiniteRange or val42) and 10000 or val43.Direction.Magnitude))
        if val42 then
            local stateMap49 = {}
            local stateMap50 = {}
            stateMap49[1] = val37
            stateMap50[2] = stateMap49
            stateMap50[1] = val45
            stateMap50.n = 2
            return stateMap50, "FindPartOnRayWithWhitelist"
        end
        val36[1] = val45
        return val36, arg1
    end
    return nil
end
local function helperFn76(arg1, ...)
    local val35, val36 = ...
    local str = tostring(arg1)
    local val37 = ":" .. tostring(val35)
    local val38 = str .. val37
    if stateMap18[val38] then
        return
    end
    stateMap18[val38] = true
    warn("[Potent] FireServer:", tostring(arg1), tostring(val35), typeof(val36))
end
local function helperFn77()
    local val35 = nil
    val35 = hookmetamethod(game, "__namecall", newcclosure(function(arg1, ...)
        local val36 = getnamecallmethod()
        local alive = val32.alive
        if alive then
            local val37 = checkcaller()
            alive = not val37
        end
        if alive then
            if val36 == "FireServer" and val33.debug then
                helperFn76(arg1, ...)
            end
            if val32.silentTarget then
                local val37 = nil
                local val38 = nil
                if val36 == "FireServer" and val33.silentAim.hookRemote then
                    val37 = helperFn72(...)
                elseif arg1 == workspace and val33.silentAim.raycast then
                    local ok, res, val39 = pcall(helperFn75, val36, ...)
                    if ok then
                        val37 = res
                        val38 = val39
                    end
                end
                if val37 then
                    setnamecallmethod(val38 or val36)
                    return val35(arg1, table.unpack(val37, 1, val37.n))
                end
            end
        end
        return val35(arg1, ...)
    end))
    local remoteEvent = Instance.new("RemoteEvent")
    local val36 = nil
    val36 = hookfunction(remoteEvent.FireServer, newcclosure(function(arg1, ...)
        local silentTarget = val32.silentTarget and val32.alive and val33.silentAim.hookRemote
        if silentTarget then
            local val37 = checkcaller()
            silentTarget = not val37
        end
        if silentTarget then
            local val37 = helperFn72(...)
            if val37 then
                return val36(arg1, table.unpack(val37, 1, val37.n))
            end
        end
        return val36(arg1, ...)
    end))
    remoteEvent:Destroy()
    local val37 = nil
    val37 = hookmetamethod(game, "__index", newcclosure(function(arg1, arg2)
        if val32.silentTarget and (arg2 == "Hit" or arg2 == "Target") and val32.alive and val33.silentAim.hookMouse then
            local val38 = arg1 == val12
            if val38 then
                local val39 = checkcaller()
                val38 = not val39
            end
            if val38 then
                if arg2 == "Hit" then
                    return CFrame.new(val32.silentTarget)
                end
                return val32.silentTargetPart
            end
        end
        return val37(arg1, arg2)
    end))
end
local stateMap49 = {}
stateMap49.silentAim = "Silent aim"
stateMap49.trigger = "Trigger bot"
stateMap49.speed = "Speed"
stateMap49.fly = "Flight"
stateMap49.noclip = "Noclip"
stateMap49.esp = "ESP"
stateMap49.orbit = "Orbit"
stateMap49.rage = "Rage mode"
stateMap49.autoStomp = "Auto stomp"
stateMap49.antiAim = "Anti aim"
local val35 = stateMap49
local function helperFn78(arg1, arg2)
    if arg2 then
        return
    end
    for key, item in pairs(val33.binds) do
        local val36 = val11.inputMatches(arg1, item)
        if val36 then
            if key == "aimbot" then
                if val33.aimbot.activation == "Toggle" then
                    val32.aimbotToggled = not val32.aimbotToggled
                    if not val32.aimbotToggled then
                        val32.lock = nil
                    end
                end
            elseif key == "target" then
                local val37 = helperFn37()
                if val37 then
                    helperFn38(val37 ~= val32.manualTarget and val37 or nil)
                end
            elseif key == "clearTarget" then
                if val32.manualTarget then
                    val32.manualTarget = nil
                    val32.lock = nil
                    val32.rageTarget = nil
                    val32.shootTimer = 0
                    helperFn25("Target cleared")
                end
            elseif key == "menu" then
                val14:toggle()
            elseif stateMap17[key] then
                local val37 = stateMap17[key]
                local val38 = stateMap17[key]:get()
                val37:set(not val38)
                local val39 = val35[key] or key
                local val40 = stateMap17[key]:get() and " enabled" or " disabled"
                helperFn25(val39 .. val40)
            end
        end
    end
end
local function helperFn79()
    local stateMap50 = {}
    for _, item in ipairs(Players:GetPlayers()) do
        if item ~= localPlayer then
            table.insert(stateMap50, item.Name)
        end
    end
    return stateMap50
end
local function helperFn80()
    local val36 = helperFn79()
    table.insert(val36, 1, "Closest")
    return val36
end
local function helperFn81()
    local val36 = val14:tab("PlayerList", true)
    local page = val36.page
    local create = val11.create
    local stateMap50 = {}
    stateMap50.Size = UDim2.new(1, 0, 0, 26)
    stateMap50.BackgroundTransparency = 1
    local val37 = create("Frame", stateMap50, page)
    local create2 = val11.create
    local stateMap51 = {}
    stateMap51.FillDirection = Enum.FillDirection.Horizontal
    stateMap51.Padding = UDim.new(0, 4)
    stateMap51.SortOrder = Enum.SortOrder.LayoutOrder
    create2("UIListLayout", stateMap51, val37)
    local stateMap52 = {}
    local stateMap53 = {}
    local function helperFn82()
        if val30 then
            helperFn38(val32.manualTarget ~= val30 and val30 or nil)
        end
    end
    stateMap52[1] = "Target"
    stateMap52[2] = helperFn82
    local stateMap54 = {}
    local function helperFn83()
        if not val30 then
            return
        end
        val32.whitelist[val30] = not val32.whitelist[val30] or nil
        if val32.manualTarget == val30 then
            helperFn38(nil)
        end
    end
    stateMap54[1] = "Whitelist"
    stateMap54[2] = helperFn83
    local stateMap55 = {}
    stateMap55[2] = function()
        val32.spectatePlayer = val30
    end
    stateMap55[1] = "Spectate"
    local stateMap56 = {}
    stateMap56[2] = function()
        helperFn62(val30)
    end
    stateMap56[1] = "Teleport"
    stateMap53[3] = stateMap55
    stateMap53[5] = stateMap56
    stateMap53[4] = {"Stop spec", helperFn64}
    stateMap53[1] = stateMap52
    stateMap53[6] = {
        "Fling",
        function()
            helperFn61(val30)
        end
    }
    stateMap53[2] = stateMap54
    for idx, item in ipairs(stateMap53) do
        local val38 = val11.makeButton(val37, item[1], item[2])
        val38.Size = UDim2.new(1 / #stateMap53, -4, 1, 0)
        val38.LayoutOrder = idx
    end
    local stateMap57 = {}
    local create3 = val11.create
    stateMap57.BackgroundTransparency = 1
    stateMap57.Position = UDim2.fromOffset(0, 30)
    stateMap57.Size = UDim2.new(1, 0, 0, 16)
    stateMap57.TextXAlignment = Enum.TextXAlignment.Left
    stateMap57.TextColor3 = val11.colors.dim
    stateMap57.Text = "Players: 0"
    val29 = create3("TextLabel", stateMap57, page)
    local stateMap58 = {}
    local create4 = val11.create
    stateMap58.Position = UDim2.fromOffset(0, 50)
    stateMap58.Size = UDim2.new(1, 0, 1, -50)
    stateMap58.BackgroundTransparency = 1
    stateMap58.ScrollBarThickness = 3
    stateMap58.CanvasSize = UDim2.new()
    stateMap58.AutomaticCanvasSize = Enum.AutomaticSize.Y
    val28 = create4("ScrollingFrame", stateMap58, page)
    local create5 = val11.create
    local stateMap59 = {}
    stateMap59.Padding = UDim.new(0, 4)
    stateMap59.SortOrder = Enum.SortOrder.LayoutOrder
    create5("UIListLayout", stateMap59, val28)
    for _, item in ipairs(Players:GetPlayers()) do
        helperFn66(item)
    end
    local val38 = Players.PlayerAdded:Connect(helperFn66)
    table.insert(stateMap15, val38)
    local val39 = Players.PlayerRemoving:Connect(helperFn67)
    table.insert(stateMap15, val39)
    helperFn68()
end
local function helperFn82()
    val14 = val11.new("Potent Strike", Vector2.new(720, 480))
    val14:onInput(helperFn78)
    local val36 = val14:tab("Combat")
    local aimbot = val33.aimbot
    local val37 = val36:group("Aimbot", 1)
    local val38 = val37:checkbox("Enabled", aimbot.enabled, function(arg1)
        aimbot.enabled = arg1
    end)
    local text = "aimbot"
    val38:bind(val33.binds[text], function(arg1)
        val33.binds[text] = arg1
    end)
    val37:checkbox("Sticky aim", aimbot.sticky, function(arg1)
        aimbot.sticky = arg1
    end)
    val37:checkbox("Draw FOV", aimbot.showFov, function(arg1)
        aimbot.showFov = arg1
    end)
    val37:checkbox("Wall check", aimbot.wallCheck, function(arg1)
        aimbot.wallCheck = arg1
    end)
    local stateMap50 = {}
    local fov = aimbot.fov
    local function helperFn83(arg1)
        aimbot.fov = arg1
    end
    stateMap50.step = 1
    val37:slider("FOV", 30, 600, fov, helperFn83, stateMap50)
    local smoothing = aimbot.smoothing
    local stateMap51 = {}
    local function helperFn84(arg1)
        aimbot.smoothing = arg1
    end
    stateMap51.step = 0.01
    val37:slider("Strength", 0.05, 1, smoothing, helperFn84, stateMap51)
    val37:combo("Mode", {"Camera", "Mouse"}, aimbot.mode, function(arg1)
        aimbot.mode = arg1
    end)
    local stateMap52 = {}
    stateMap52[2] = "Toggle"
    stateMap52[1] = "Hold"
    val37:combo("Activation", stateMap52, aimbot.activation, function(arg1)
        aimbot.activation = arg1
        val32.aimbotToggled = false
        val32.lock = nil
    end)
    local stateMap53 = {}
    stateMap53[2] = "Distance"
    stateMap53[1] = "Cursor"
    val37:combo("Priority", stateMap53, aimbot.priority, function(arg1)
        aimbot.priority = arg1
    end)
    val37:combo("Hit part", val2, aimbot.hitPart, function(arg1)
        aimbot.hitPart = arg1
    end)
    local val39 = val36:group("Aimbot prediction", 1)
    val39:checkbox("Auto (ping based)", aimbot.autoPrediction, function(arg1)
        aimbot.autoPrediction = arg1
    end)
    local function helperFn85(arg1)
        aimbot.pingScale = arg1
    end
    local pingScale = aimbot.pingScale
    local stateMap54 = {}
    stateMap54.step = 0.05
    val39:slider("Ping scale", 0.5, 2, pingScale, helperFn85, stateMap54)
    local function helperFn86(arg1)
        aimbot.prediction = arg1
    end
    local prediction = aimbot.prediction
    local stateMap55 = {}
    stateMap55.step = 0.005
    stateMap55.format = "%.3f"
    val39:slider("Manual", 0, 0.4, prediction, helperFn86, stateMap55)
    local val40 = val36:group("Trigger bot", 1)
    local val41 = val40:checkbox("Enabled", val33.trigger.enabled, function(arg1)
        val33.trigger.enabled = arg1
    end)
    stateMap17.trigger = val41
    local text2 = "trigger"
    stateMap17.trigger:bind(val33.binds[text2], function(arg1)
        val33.binds[text2] = arg1
    end)
    val40:checkbox("Wall check", val33.trigger.wallCheck, function(arg1)
        val33.trigger.wallCheck = arg1
    end)
    local stateMap56 = {}
    stateMap56[2] = "Click"
    stateMap56[1] = "Activate"
    val40:combo("Fire method", stateMap56, val33.trigger.method, function(arg1)
        val33.trigger.method = arg1
    end)
    local val42 = val33.trigger.delay
    local stateMap57 = {}
    local function helperFn87(arg1)
        val33.trigger.delay = arg1
    end
    stateMap57.step = 0.01
    val40:slider("Delay (s)", 0, 0.5, val42, helperFn87, stateMap57)
    local range = val33.trigger.range
    local function helperFn88(arg1)
        val33.trigger.range = arg1
    end
    local stateMap58 = {}
    stateMap58.step = 50
    val40:slider("Range", 50, 2000, range, helperFn88, stateMap58)
    local stateMap59 = {}
    local radius = val33.trigger.radius
    local function helperFn89(arg1)
        val33.trigger.radius = arg1
    end
    stateMap59.step = 1
    val40:slider("Cursor radius (px)", 5, 120, radius, helperFn89, stateMap59)
    local val43 = val36:group("Wall bang", 1)
    local val44 = val43:checkbox("Enabled", val33.wallbang.enabled, function(arg1)
        val33.wallbang.enabled = arg1
    end)
    stateMap17.wallbang = val44
    val43:text("Shots only hit the silent / locked target, walls are ignored.")
    local silentAim = val33.silentAim
    local val45 = val36:group("Silent aim", 2)
    local val46 = val45:checkbox("Enabled", silentAim.enabled, function(arg1)
        silentAim.enabled = arg1
    end)
    stateMap17.silentAim = val46
    local text3 = "silentAim"
    stateMap17.silentAim:bind(val33.binds[text3], function(arg1)
        val33.binds[text3] = arg1
    end)
    val45:checkbox("Wall check", silentAim.wallCheck, function(arg1)
        silentAim.wallCheck = arg1
    end)
    val45:checkbox("Draw FOV", silentAim.showFov, function(arg1)
        silentAim.showFov = arg1
    end)
    local stateMap60 = {}
    local function helperFn90(arg1)
        silentAim.fov = arg1
    end
    local fov2 = silentAim.fov
    stateMap60.step = 1
    val45:slider("FOV", 30, 600, fov2, helperFn90, stateMap60)
    local function helperFn91(arg1)
        silentAim.hitChance = arg1
    end
    local hitChance = silentAim.hitChance
    local stateMap61 = {}
    stateMap61.step = 1
    stateMap61.format = "%d%%"
    val45:slider("Hit chance", 1, 100, hitChance, helperFn91, stateMap61)
    val45:combo("Hit part", val2, silentAim.hitPart, function(arg1)
        silentAim.hitPart = arg1
    end)
    local val47 = val36:group("Hooks / Ray magic", 2)
    val47:checkbox("Remote hook (FireServer)", silentAim.hookRemote, function(arg1)
        silentAim.hookRemote = arg1
    end)
    val47:checkbox("Mouse hook (Hit / Target)", silentAim.hookMouse, function(arg1)
        silentAim.hookMouse = arg1
    end)
    val47:checkbox("Raycast magic", silentAim.raycast, function(arg1)
        silentAim.raycast = arg1
    end)
    val47:checkbox("Infinite range", silentAim.infiniteRange, function(arg1)
        silentAim.infiniteRange = arg1
    end)
    local val48 = val36:group("Silent prediction", 2)
    val48:checkbox("Auto (ping based)", silentAim.autoPrediction, function(arg1)
        silentAim.autoPrediction = arg1
    end)
    local pingScale2 = silentAim.pingScale
    local function helperFn92(arg1)
        silentAim.pingScale = arg1
    end
    local stateMap62 = {}
    stateMap62.step = 0.05
    val48:slider("Ping scale", 0.5, 2, pingScale2, helperFn92, stateMap62)
    local prediction2 = silentAim.prediction
    local stateMap63 = {}
    local function helperFn93(arg1)
        silentAim.prediction = arg1
    end
    stateMap63.step = 0.005
    stateMap63.format = "%.3f"
    val48:slider("Manual", 0, 0.4, prediction2, helperFn93, stateMap63)
    local val49 = val36:group("Hitbox expander", 2)
    val49:checkbox("Enabled", val33.hitbox.enabled, function(arg1)
        val33.hitbox.enabled = arg1
    end)
    local stateMap64 = {}
    stateMap64[2] = "Head"
    stateMap64[3] = "Both"
    stateMap64[1] = "HumanoidRootPart"
    val49:combo("Part", stateMap64, val33.hitbox.part, function(arg1)
        val33.hitbox.part = arg1
    end)
    local size = val33.hitbox.size
    local stateMap65 = {}
    local function helperFn94(arg1)
        val33.hitbox.size = arg1
    end
    stateMap65.step = 1
    val49:slider("Size", 2, 40, size, helperFn94, stateMap65)
    local transparency = val33.hitbox.transparency
    local function helperFn95(arg1)
        val33.hitbox.transparency = arg1
    end
    local stateMap66 = {}
    stateMap66.step = 0.05
    val49:slider("Transparency", 0, 1, transparency, helperFn95, stateMap66)
    local target = val33.target
    local val50 = val36:group("Target lock (right click)", 3)
    val50:keybind("Target click", val33.binds.target, function(arg1)
        val33.binds.target = arg1
    end)
    val50:keybind("Clear target", val33.binds.clearTarget, function(arg1)
        val33.binds.clearTarget = arg1
    end)
    val50:checkbox("Target chams", target.chams, function(arg1)
        target.chams = arg1
    end)
    val50:checkbox("Always hit target", target.hit, function(arg1)
        target.hit = arg1
    end)
    val50:checkbox("Auto shoot", target.autoShoot, function(arg1)
        target.autoShoot = arg1
    end)
    val50:checkbox("Auto equip gun", target.autoEquip, function(arg1)
        target.autoEquip = arg1
    end)
    val50:checkbox("Target HUD", target.hud, function(arg1)
        target.hud = arg1
    end)
    val50:checkbox("Untarget on KO", target.untargetOnKo, function(arg1)
        target.untargetOnKo = arg1
    end)
    local function helperFn96(arg1)
        target.rate = arg1
    end
    local stateMap67 = {}
    local rate = target.rate
    stateMap67.step = 1
    val50:slider("Shots per second", 1, 30, rate, helperFn96, stateMap67)
    local stateMap68 = {}
    local function helperFn97(arg1)
        target.assist = arg1
    end
    local assist = target.assist
    stateMap68.step = 5
    val50:slider("Click assist (px)", 0, 200, assist, helperFn97, stateMap68)
    val50:colorpicker("Chams color", target.chamsColor, function(arg1)
        target.chamsColor = arg1
    end)
    local rage = val33.rage
    local val51 = val36:group("Rage mode", 3)
    local val52 = val51:checkbox("Enabled", rage.enabled, function(arg1)
        rage.enabled = arg1
        val32.rageTarget = nil
    end)
    stateMap17.rage = val52
    local text4 = "rage"
    stateMap17.rage:bind(val33.binds[text4], function(arg1)
        val33.binds[text4] = arg1
    end)
    val51:checkbox("Lock camera", rage.lockCamera, function(arg1)
        rage.lockCamera = arg1
    end)
    val51:checkbox("Auto fire", rage.autoFire, function(arg1)
        rage.autoFire = arg1
    end)
    val51:checkbox("Orbit target", rage.orbit, function(arg1)
        rage.orbit = arg1
    end)
    val51:checkbox("Auto prediction", rage.autoPrediction, function(arg1)
        rage.autoPrediction = arg1
    end)
    local stateMap69 = {}
    local function helperFn98(arg1)
        rage.rate = arg1
    end
    local rate2 = rage.rate
    stateMap69.step = 1
    val51:slider("Shots per second", 1, 60, rate2, helperFn98, stateMap69)
    local radius2 = rage.radius
    local stateMap70 = {}
    local function helperFn99(arg1)
        rage.radius = arg1
    end
    stateMap70.step = 1
    val51:slider("Orbit radius", 3, 40, radius2, helperFn99, stateMap70)
    local function helperFn100(arg1)
        rage.speed = arg1
    end
    local speed = rage.speed
    local stateMap71 = {}
    stateMap71.step = 0.1
    stateMap71.format = "%.1f"
    val51:slider("Orbit speed", 0.5, 15, speed, helperFn100, stateMap71)
    local stateMap72 = {}
    local function helperFn101(arg1)
        rage.height = arg1
    end
    local height = rage.height
    stateMap72.step = 1
    val51:slider("Orbit height", -5, 20, height, helperFn101, stateMap72)
    val51:combo("Hit part", val2, rage.hitPart, function(arg1)
        rage.hitPart = arg1
    end)
    local val53 = val36:group("Checks", 3)
    val53:checkbox("Team check", val33.checks.team, function(arg1)
        val33.checks.team = arg1
    end)
    val53:checkbox("Knock check", val33.checks.knocked, function(arg1)
        val33.checks.knocked = arg1
    end)
    val53:checkbox("Health check", val33.checks.health, function(arg1)
        val33.checks.health = arg1
    end)
    local minHealth = val33.checks.minHealth
    local function helperFn102(arg1)
        val33.checks.minHealth = arg1
    end
    local stateMap73 = {}
    stateMap73.step = 1
    val53:slider("Min health", 1, 100, minHealth, helperFn102, stateMap73)
    local val54 = val14:tab("Visuals")
    local esp = val33.esp
    local val55 = val54:group("ESP", 1)
    local val56 = val55:checkbox("Enabled", esp.enabled, function(arg1)
        esp.enabled = arg1
    end)
    stateMap17.esp = val56
    local text5 = "esp"
    stateMap17.esp:bind(val33.binds[text5], function(arg1)
        val33.binds[text5] = arg1
    end)
    val55:checkbox("Box", esp.box, function(arg1)
        esp.box = arg1
    end)
    val55:checkbox("Name", esp.name, function(arg1)
        esp.name = arg1
    end)
    val55:checkbox("Skeleton", esp.skeleton, function(arg1)
        esp.skeleton = arg1
    end)
    val55:checkbox("Tool", esp.tool, function(arg1)
        esp.tool = arg1
    end)
    val55:checkbox("Health bar", esp.health, function(arg1)
        esp.health = arg1
    end)
    val55:checkbox("Distance", esp.distance, function(arg1)
        esp.distance = arg1
    end)
    val55:checkbox("Use team color", esp.teamColor, function(arg1)
        esp.teamColor = arg1
    end)
    local maxDistance = esp.maxDistance
    local stateMap74 = {}
    local function helperFn103(arg1)
        esp.maxDistance = arg1
    end
    stateMap74.step = 50
    val55:slider("Max distance", 100, 5000, maxDistance, helperFn103, stateMap74)
    local val57 = val54:group("ESP colors", 2)
    val57:colorpicker("Box", esp.color, function(arg1)
        esp.color = arg1
    end)
    val57:colorpicker("Name", esp.nameColor, function(arg1)
        esp.nameColor = arg1
    end)
    val57:colorpicker("Skeleton", esp.skeletonColor, function(arg1)
        esp.skeletonColor = arg1
    end)
    val57:colorpicker("Tool", esp.toolColor, function(arg1)
        esp.toolColor = arg1
    end)
    val57:colorpicker("Distance", esp.distanceColor, function(arg1)
        esp.distanceColor = arg1
    end)
    val57:colorpicker("Target", val3, function(arg1) end)
    val57:colorpicker("Whitelist", val4, function(arg1) end)
    local val58 = val54:group("Chams (all players)", 2)
    val58:checkbox("Enabled", esp.chams, function(arg1)
        esp.chams = arg1
    end)
    local stateMap75 = {}
    stateMap75[3] = "Rainbow"
    stateMap75[4] = "Outline"
    stateMap75[2] = "Pulse"
    stateMap75[1] = "Solid"
    val58:combo("Style", stateMap75, esp.chamsStyle, function(arg1)
        esp.chamsStyle = arg1
    end)
    val58:colorpicker("Chams color", esp.chamsColor, function(arg1)
        esp.chamsColor = arg1
    end)
    local val59 = val54:group("Overlays", 3)
    val59:checkbox("Kill overlay", val33.overlay.kill, function(arg1)
        val33.overlay.kill = arg1
    end)
    val59:checkbox("Death overlay", val33.overlay.death, function(arg1)
        val33.overlay.death = arg1
    end)
    local val60 = val14:tab("Misc")
    local val61 = val60:group("Movement", 1)
    local val62 = val61:checkbox("Speed (CFrame)", val33.speed.enabled, function(arg1)
        val33.speed.enabled = arg1
    end)
    stateMap17.speed = val62
    local text6 = "speed"
    stateMap17.speed:bind(val33.binds[text6], function(arg1)
        val33.binds[text6] = arg1
    end)
    local val63 = val61:checkbox("Flight", val33.fly.enabled, function(arg1)
        val33.fly.enabled = arg1
    end)
    stateMap17.fly = val63
    local text7 = "fly"
    stateMap17.fly:bind(val33.binds[text7], function(arg1)
        val33.binds[text7] = arg1
    end)
    local val64 = val61:checkbox("Noclip", val33.noclip, function(arg1)
        val33.noclip = arg1
    end)
    stateMap17.noclip = val64
    local text8 = "noclip"
    stateMap17.noclip:bind(val33.binds[text8], function(arg1)
        val33.binds[text8] = arg1
    end)
    val61:checkbox("WalkSpeed", val33.walk.enabled, function(arg1)
        val33.walk.enabled = arg1
    end)
    val61:checkbox("Jump power", val33.jump.enabled, function(arg1)
        val33.jump.enabled = arg1
    end)
    val61:checkbox("Infinite jump", val33.jump.infinite, function(arg1)
        val33.jump.infinite = arg1
    end)
    val61:checkbox("Spinbot", val33.spinbot.enabled, function(arg1)
        val33.spinbot.enabled = arg1
    end)
    local value = val33.speed.value
    local function helperFn104(arg1)
        val33.speed.value = arg1
    end
    local stateMap76 = {}
    stateMap76.step = 1
    val61:slider("Speed", 16, 200, value, helperFn104, stateMap76)
    local value2 = val33.fly.value
    local stateMap77 = {}
    local function helperFn105(arg1)
        val33.fly.value = arg1
    end
    stateMap77.step = 1
    val61:slider("Fly speed", 10, 250, value2, helperFn105, stateMap77)
    local stateMap78 = {}
    local value3 = val33.walk.value
    local function helperFn106(arg1)
        val33.walk.value = arg1
    end
    stateMap78.step = 1
    val61:slider("Walk value", 16, 200, value3, helperFn106, stateMap78)
    local stateMap79 = {}
    local value4 = val33.jump.value
    local function helperFn107(arg1)
        val33.jump.value = arg1
    end
    stateMap79.step = 1
    val61:slider("Jump value", 50, 250, value4, helperFn107, stateMap79)
    local stateMap80 = {}
    local value5 = val33.spinbot.value
    local function helperFn108(arg1)
        val33.spinbot.value = arg1
    end
    stateMap80.step = 1
    val61:slider("Spin speed", 5, 180, value5, helperFn108, stateMap80)
    local val65 = val60:group("Auto armor", 2)
    val65:checkbox("Enabled", val33.armor.enabled, function(arg1)
        val33.armor.enabled = arg1
    end)
    local items2 = {"armor"}
    items2[3] = "shield"
    items2[4] = "kevlar"
    items2[2] = "vest"
    val65:combo("Item keyword", items2, val33.armor.keyword, function(arg1)
        val33.armor.keyword = arg1
        val32.armorDetector = nil
        val32.armorScanTime = 0
    end)
    local threshold = val33.armor.threshold
    local stateMap81 = {}
    local function helperFn109(arg1)
        val33.armor.threshold = arg1
    end
    stateMap81.step = 5
    val65:slider("Buy below", 0, 100, threshold, helperFn109, stateMap81)
    local stateMap82 = {}
    local cooldown = val33.armor.cooldown
    local function helperFn110(arg1)
        val33.armor.cooldown = arg1
    end
    stateMap82.step = 1
    val65:slider("Cooldown (s)", 2, 30, cooldown, helperFn110, stateMap82)
    val65:button("Buy armor now", hatchSelectedEgg4)
    val65:button("Scan shop (copy list)", hatchSelectedEgg3)
    local val66 = val60:group("Anti stomp", 2)
    val66:checkbox("Enabled", val33.antiStomp.enabled, function(arg1)
        val33.antiStomp.enabled = arg1
    end)
    local stateMap83 = {}
    stateMap83[2] = "Sky"
    stateMap83[1] = "Reset"
    val66:combo("Method", stateMap83, val33.antiStomp.method, function(arg1)
        val33.antiStomp.method = arg1
    end)
    local stateMap84 = {}
    local height2 = val33.antiStomp.height
    local function helperFn111(arg1)
        val33.antiStomp.height = arg1
    end
    stateMap84.step = 50
    val66:slider("Sky height", 100, 1000, height2, helperFn111, stateMap84)
    local val67 = val60:group("Auto stomp", 2)
    local val68 = val67:checkbox("Enabled", val33.autoStomp.enabled, function(arg1)
        val33.autoStomp.enabled = arg1
    end)
    stateMap17.autoStomp = val68
    local text9 = "autoStomp"
    stateMap17.autoStomp:bind(val33.binds[text9], function(arg1)
        val33.binds[text9] = arg1
    end)
    val67:checkbox("Teleport to target", val33.autoStomp.teleport, function(arg1)
        val33.autoStomp.teleport = arg1
    end)
    local stateMap85 = {}
    local range2 = val33.autoStomp.range
    local function helperFn112(arg1)
        val33.autoStomp.range = arg1
    end
    stateMap85.step = 1
    val67:slider("Range (no teleport)", 4, 40, range2, helperFn112, stateMap85)
    local stateMap86 = {}
    local rate3 = val33.autoStomp.rate
    local function helperFn113(arg1)
        val33.autoStomp.rate = arg1
    end
    stateMap86.step = 1
    val67:slider("Stomps per second", 1, 20, rate3, helperFn113, stateMap86)
    local val69 = val60:group("Anti aim", 3)
    local val70 = val69:checkbox("Enabled", val33.antiAim.enabled, function(arg1)
        val33.antiAim.enabled = arg1
    end)
    stateMap17.antiAim = val70
    local text10 = "antiAim"
    stateMap17.antiAim:bind(val33.binds[text10], function(arg1)
        val33.binds[text10] = arg1
    end)
    local stateMap87 = {}
    stateMap87[2] = "Velocity"
    stateMap87[1] = "Jitter"
    val69:combo("Method", stateMap87, val33.antiAim.method, function(arg1)
        val33.antiAim.method = arg1
    end)
    local angle = val33.antiAim.angle
    local function helperFn114(arg1)
        val33.antiAim.angle = arg1
    end
    local stateMap88 = {}
    stateMap88.step = 5
    val69:slider("Jitter angle", 10, 180, angle, helperFn114, stateMap88)
    local amount = val33.antiAim.amount
    local stateMap89 = {}
    local function helperFn115(arg1)
        val33.antiAim.amount = arg1
    end
    stateMap89.step = 5
    val69:slider("Velocity amount", 5, 150, amount, helperFn115, stateMap89)
    local val71 = val60:group("Orbit", 3)
    local val72 = val71:checkbox("Enabled", val33.orbit.enabled, function(arg1)
        val33.orbit.enabled = arg1
    end)
    stateMap17.orbit = val72
    local text11 = "orbit"
    stateMap17.orbit:bind(val33.binds[text11], function(arg1)
        val33.binds[text11] = arg1
    end)
    val71:combo("Player", helperFn80, val33.orbit.player, function(arg1)
        val33.orbit.player = arg1
        val32.orbitTarget = nil
    end)
    local stateMap90 = {}
    stateMap90[2] = "Cursor"
    stateMap90[1] = "Closest"
    val71:combo("Target", stateMap90, val33.orbit.target, function(arg1)
        val33.orbit.target = arg1
        val32.orbitTarget = nil
    end)
    val71:checkbox("Face target", val33.orbit.face, function(arg1)
        val33.orbit.face = arg1
    end)
    local stateMap91 = {}
    local radius3 = val33.orbit.radius
    local function helperFn116(arg1)
        val33.orbit.radius = arg1
    end
    stateMap91.step = 1
    val71:slider("Radius", 3, 40, radius3, helperFn116, stateMap91)
    local speed2 = val33.orbit.speed
    local stateMap92 = {}
    local function helperFn117(arg1)
        val33.orbit.speed = arg1
    end
    stateMap92.step = 0.1
    stateMap92.format = "%.1f"
    val71:slider("Speed", 0.5, 15, speed2, helperFn117, stateMap92)
    local stateMap93 = {}
    local height3 = val33.orbit.height
    local function helperFn118(arg1)
        val33.orbit.height = arg1
    end
    stateMap93.step = 1
    val71:slider("Height", -5, 20, height3, helperFn118, stateMap93)
    local val73 = val60:group("Auto katana", 3)
    val73:checkbox("Enabled", val33.katana.enabled, function(arg1)
        val33.katana.enabled = arg1
    end)
    val73:combo("Player", helperFn80, val33.katana.player, function(arg1)
        val33.katana.player = arg1
    end)
    val73:checkbox("Approach target", val33.katana.approach, function(arg1)
        val33.katana.approach = arg1
    end)
    local range3 = val33.katana.range
    local function helperFn119(arg1)
        val33.katana.range = arg1
    end
    local stateMap94 = {}
    stateMap94.step = 1
    val73:slider("Swing range", 4, 25, range3, helperFn119, stateMap94)
    local distance = val33.katana.distance
    local function helperFn120(arg1)
        val33.katana.distance = arg1
    end
    local stateMap95 = {}
    stateMap95.step = 1
    val73:slider("Behind distance", 1, 10, distance, helperFn120, stateMap95)
    local maxDistance2 = val33.katana.maxDistance
    local function helperFn121(arg1)
        val33.katana.maxDistance = arg1
    end
    local stateMap96 = {}
    stateMap96.step = 10
    val73:slider("Max distance", 20, 300, maxDistance2, helperFn121, stateMap96)
    local rate4 = val33.katana.rate
    local stateMap97 = {}
    local function helperFn122(arg1)
        val33.katana.rate = arg1
    end
    stateMap97.step = 1
    val73:slider("Swings per second", 1, 20, rate4, helperFn122, stateMap97)
    helperFn81()
    local val74 = val14:tab("Settings")
    local val75 = val74:group("Menu", 1)
    val75:keybind("Toggle menu", val33.binds.menu, function(arg1)
        val33.binds.menu = arg1
    end)
    local val76 = val11.getAccent()
    val75:colorpicker("Menu accent", val76, function(arg1)
        val11.setAccent(arg1)
    end)
    val75:checkbox("Keybind list", val33.hud.enabled, function(arg1)
        val33.hud.enabled = arg1
    end)
    val75:checkbox("Watermark", val33.hud.watermark, function(arg1)
        val33.hud.watermark = arg1
    end)
    val75:checkbox("Notifications", val33.hud.notify, function(arg1)
        val33.hud.notify = arg1
    end)
    local val77 = val74:group("Misc", 2)
    local stateMap98 = {}
    local duration = val33.fling.duration
    local function helperFn123(arg1)
        val33.fling.duration = arg1
    end
    stateMap98.step = 1
    val77:slider("Fling duration", 1, 8, duration, helperFn123, stateMap98)
    val77:checkbox("Debug (log remotes)", val33.debug, function(arg1)
        val33.debug = arg1
    end)
    val77:button("Unload", function()
        stateMap2.detach()
    end)
    val16 = helperFn35(Color3.fromRGB(255, 255, 255))
    val17 = helperFn35(val7)
end
stateMap2.detach = function()
    val32.alive = false
    val32.silentTarget = nil
    val33.rage.enabled = false
    val33.hitbox.enabled = false
    val33.autoStomp.enabled = false
    val33.antiAim.enabled = false
    val33.armor.enabled = false
    val32.rageTarget = nil
    helperFn58()
    for key, item in pairs(val32.hitboxOriginals) do
        if key.Parent then
            key.Size = item.size
            key.Transparency = item.transparency
            key.CanCollide = item.canCollide
        end
    end
    for _, item in ipairs(stateMap15) do
        item:Disconnect()
    end
    for _, item in pairs(stateMap16) do
        helperFn32(item)
    end
    if val18 then
        val18:Destroy()
    end
    local character = localPlayer.Character
    local val36 = character and character:FindFirstChildOfClass("Humanoid")
    if val36 then
        val36.AutoRotate = true
        val36.PlatformStand = false
        val36.JumpPower = 50
        val36.WalkSpeed = 16
        currentCamera.CameraSubject = val36
    end
    if val15 then
        val15:Destroy()
    end
    if val14 then
        val14:destroy()
    end
    shared.PotentStrike = nil
end
xpcall(function()
    local val36 = game:IsLoaded()
    if not val36 then
        game.Loaded:Wait()
    end
    helperFn17()
    helperFn21()
    helperFn23()
    helperFn27()
    helperFn82()
    helperFn77()
    helperFn25("Potent Strike loaded (" .. val[game.PlaceId] .. ") - right click a player to lock")
    local val37 = RunService.RenderStepped:Connect(helperFn69)
    table.insert(stateMap15, val37)
    local val38 = RunService.Heartbeat:Connect(helperFn70)
    table.insert(stateMap15, val38)
    local val39 = RunService.Stepped:Connect(helperFn71)
    table.insert(stateMap15, val39)
    local val40 = UserInputService.JumpRequest:Connect(function()
        if not val33.jump.infinite then
            return
        end
        local character = localPlayer.Character
        local val40 = character and character:FindFirstChildOfClass("Humanoid")
        if val40 then
            val40:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    table.insert(stateMap15, val40)
    local val41 = Players.PlayerRemoving:Connect(function(arg1)
        if stateMap16[arg1] then
            helperFn32(stateMap16[arg1])
            stateMap16[arg1] = nil
        end
        val32.whitelist[arg1] = nil
        if val32.manualTarget == arg1 then
            val32.manualTarget = nil
            val32.lock = nil
            val32.rageTarget = nil
        end
        if val32.spectatePlayer == arg1 then
            helperFn64()
        end
    end)
    table.insert(stateMap15, val41)
    shared.PotentStrike = stateMap2
end, function(arg1)
    warn("Failed to initialize.")
    warn(arg1)
    warn(debug.traceback())
    stateMap2.detach()
end)
print("Deobf By Zed")
