local function startMainHub()
    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local Workspace = game:GetService("Workspace")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local localPlayer = Players.LocalPlayer
    if CoreGui:FindFirstChild("GamingSpiritScriptHub") then
        CoreGui.GamingSpiritScriptHub:Destroy()
    end
    local gamingSpiritScriptHub = Instance.new("ScreenGui")
    gamingSpiritScriptHub.Name = "GamingSpiritScriptHub"
    gamingSpiritScriptHub.ResetOnSpawn = false
    gamingSpiritScriptHub.Parent = CoreGui
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 220)
    mainFrame.Position = UDim2.new(0.5, -100, 0.4, -110)
    mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = gamingSpiritScriptHub
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 6)
    uiCorner.Parent = mainFrame
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0, 160, 0, 18)
    titleLabel.Position = UDim2.new(0, 8, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "RIDE A FISH"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.LuckiestGuy
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = mainFrame
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
    minimizeBtn.Position = UDim2.new(1, -28, 0, 6)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Text = "-"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 14
    minimizeBtn.Font = Enum.Font.LuckiestGuy
    minimizeBtn.Parent = mainFrame
    local uiCorner2 = Instance.new("UICorner")
    uiCorner2.CornerRadius = UDim.new(0, 4)
    uiCorner2.Parent = minimizeBtn
    local scrollContainer = Instance.new("ScrollingFrame")
    scrollContainer.Name = "ScrollContainer"
    scrollContainer.Size = UDim2.new(1, -10, 0, 172)
    scrollContainer.Position = UDim2.new(0, 5, 0, 34)
    scrollContainer.BackgroundTransparency = 1
    scrollContainer.BorderSizePixel = 0
    scrollContainer.ScrollBarThickness = 4
    scrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollContainer.Parent = mainFrame
    local listLayout = Instance.new("UIListLayout")
    listLayout.Parent = scrollContainer
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 6)
    local footerLabel = Instance.new("TextLabel")
    footerLabel.Name = "FooterLabel"
    footerLabel.Size = UDim2.new(1, 0, 0, 24)
    footerLabel.Position = UDim2.new(0, 0, 1, -26)
    footerLabel.BackgroundTransparency = 1
    footerLabel.Text = "YOUTUBE: SPIRITUAL GAMING"
    footerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    footerLabel.TextSize = 11
    footerLabel.Font = Enum.Font.LuckiestGuy
    footerLabel.Parent = mainFrame
    local function createToggle(labelText, layoutOrder)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -6, 0, 28)
        frame.BackgroundTransparency = 1
        frame.LayoutOrder = layoutOrder
        frame.Parent = scrollContainer
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 145, 1, 0)
        label.Position = UDim2.new(0, 4, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = labelText
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 13
        label.Font = Enum.Font.LuckiestGuy
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame
        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 32, 0, 24)
        button.Position = UDim2.new(1, -36, 0, 2)
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        button.BorderSizePixel = 0
        button.Text = ""
        button.Parent = frame
        local uiCorner3 = Instance.new("UICorner")
        uiCorner3.CornerRadius = UDim.new(0, 4)
        uiCorner3.Parent = button
        local enabled = false
        button.MouseButton1Click:Connect(function()
            enabled = not enabled
            if enabled then
                button.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            else
                button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        end)
        return frame, function()
            return enabled
        end
    end
    local enabled = false
    minimizeBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            scrollContainer.Visible = false
            footerLabel.Visible = false
            mainFrame.Size = UDim2.new(0, 200, 0, 36)
            minimizeBtn.Text = "+"
        else
            scrollContainer.Visible = true
            footerLabel.Visible = true
            mainFrame.Size = UDim2.new(0, 200, 0, 220)
            minimizeBtn.Text = "-"
        end
    end)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -6, 0, 28)
    frame.BackgroundTransparency = 1
    frame.LayoutOrder = 1
    frame.Parent = scrollContainer
    local autoStealLabel = Instance.new("TextLabel")
    autoStealLabel.Size = UDim2.new(0, 145, 1, 0)
    autoStealLabel.Position = UDim2.new(0, 4, 0, 0)
    autoStealLabel.BackgroundTransparency = 1
    autoStealLabel.Text = "AUTO STEAL"
    autoStealLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoStealLabel.TextSize = 13
    autoStealLabel.Font = Enum.Font.LuckiestGuy
    autoStealLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoStealLabel.Parent = frame
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 32, 0, 24)
    button.Position = UDim2.new(1, -36, 0, 2)
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.BorderSizePixel = 0
    button.Text = "\226\150\188"
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.LuckiestGuy
    button.Parent = frame
    local uiCorner3 = Instance.new("UICorner")
    uiCorner3.CornerRadius = UDim.new(0, 4)
    uiCorner3.Parent = button
    local frame2 = Instance.new("Frame")
    frame2.Size = UDim2.new(1, 0, 0, 0)
    frame2.BackgroundTransparency = 1
    frame2.Visible = false
    frame2.LayoutOrder = 2
    frame2.Parent = scrollContainer
    local listLayout2 = Instance.new("UIListLayout")
    listLayout2.Parent = frame2
    listLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout2.Padding = UDim.new(0, 4)
    listLayout2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        frame2.Size = UDim2.new(1, 0, 0, listLayout2.AbsoluteContentSize.Y)
    end)
    local stateMap = {}
    for idx, eggName in ipairs({
        "Common Egg",
        "Coral Egg",
        "Reef Egg",
        "Tidal Egg",
        "Deep Egg",
        "Abyss Egg",
        "Trench Egg",
        "Sovereign Egg",
        "Celestial Egg",
        "Eternal Egg",
        "CoralReef Egg",
        "GlacialSpiral Egg",
        "AmethystSpiral Egg",
        "AzureCrown Egg",
        "SolarOrbit Egg",
        "Spikey Egg",
        "Mamba Egg",
        "Inferno Egg",
        "KrakenGlory Egg",
        "Seraph Egg"
    }) do
        stateMap[eggName] = false
        local frame3 = Instance.new("Frame")
        frame3.Size = UDim2.new(1, -6, 0, 22)
        frame3.BackgroundTransparency = 1
        frame3.LayoutOrder = idx
        frame3.Parent = frame2
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 130, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = eggName
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 11
        label.Font = Enum.Font.LuckiestGuy
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame3
        local button2 = Instance.new("TextButton")
        button2.Size = UDim2.new(0, 24, 0, 22)
        button2.Position = UDim2.new(1, -32, 0, 0)
        button2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        button2.BorderSizePixel = 0
        button2.Text = ""
        button2.Parent = frame3
        local uiCorner4 = Instance.new("UICorner")
        uiCorner4.CornerRadius = UDim.new(0, 4)
        uiCorner4.Parent = button2
        button2.MouseButton1Click:Connect(function()
            stateMap[eggName] = not stateMap[eggName]
            if stateMap[eggName] then
                button2.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            else
                button2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            end
        end)
    end
    local enabled2 = false
    local function helperFn()
        enabled2 = not enabled2
        frame2.Visible = enabled2
        button.Text = enabled2 and "\226\150\178" or "\226\150\188"
    end
    button.MouseButton1Click:Connect(helperFn)
    local button2 = Instance.new("TextButton")
    button2.Size = UDim2.new(0, 145, 1, 0)
    button2.Position = UDim2.new(0, 0, 0, 0)
    button2.BackgroundTransparency = 1
    button2.Text = ""
    button2.Parent = frame
    button2.MouseButton1Click:Connect(helperFn)
    task.spawn(function()
        local eggGame = ReplicatedStorage:WaitForChild("EggGame")
        local requests = eggGame:WaitForChild("Requests")
        while true do
            local enabled3 = false
            for _, item in pairs(stateMap) do
                if item then
                    enabled3 = true
                    break
                end
            end
            if enabled3 then
                for key, item in pairs(stateMap) do
                    if item then
                        pcall(function()
                            local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                            local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 3)
                            if not humanoidRootPart then
                                return
                            end
                            local val = nil
                            local eggRuntime = Workspace:FindFirstChild("EggRuntime")
                            if eggRuntime then
                                local wildEggs = eggRuntime:FindFirstChild("WildEggs")
                                if wildEggs then
                                    for _, child in ipairs(wildEggs:GetChildren()) do
                                        if key == "KrakenGlory Egg" then
                                            if string.find(string.lower(child.Name), "krakenglory") then
                                                val = child
                                                break
                                            end
                                        elseif key == "Seraph Egg" then
                                            local val2 = string.lower(child.Name)
                                            local val3 = string.find(val2, "adminabuseseraph") or string.find(val2, "seraph")
                                            if val3 then
                                                val = child
                                                break
                                            end
                                        elseif string.find(string.lower(child.Name), string.lower(key)) then
                                            val = child
                                            break
                                        end
                                    end
                                end
                            end
                            if not val and (key == "KrakenGlory Egg" or key == "Seraph Egg") then
                                for _, desc in ipairs(Workspace:GetDescendants()) do
                                    local enabled4 = false
                                    local parent = desc.Parent
                                    while true do
                                        if parent and parent ~= Workspace then
                                            if parent.Name == "EggRuntime" then
                                                enabled4 = true
                                                break
                                            end
                                            parent = parent.Parent
                                        else
                                            break
                                        end
                                    end
                                    if not enabled4 then
                                        if key == "KrakenGlory Egg" then
                                            if string.find(string.lower(desc.Name), "krakenglory") then
                                                val = desc
                                                break
                                            end
                                        elseif key == "Seraph Egg" then
                                            local val2 = string.lower(desc.Name)
                                            local val3 = string.find(val2, "adminabuseseraph") or string.find(val2, "seraph")
                                            if val3 then
                                                val = desc
                                                break
                                            end
                                        end
                                    end
                                end
                            end
                            if val then
                                local val2 = nil
                                pcall(function()
                                    if val:IsA("Model") then
                                        val2 = val:GetPivot()
                                    elseif val:IsA("BasePart") then
                                        val2 = val.CFrame
                                    end
                                end)
                                if val2 then
                                    character:PivotTo(val2 + Vector3.new(0, 5, 0))
                                    task.wait(0.5)
                                    for _, desc in ipairs(Workspace:GetDescendants()) do
                                        if desc:IsA("ProximityPrompt") then
                                            local parent = desc.Parent
                                            local val3 = parent and (parent:IsA("BasePart") or parent:IsA("Model"))
                                            if val3 then
                                                local val4 = parent:IsA("BasePart") and parent.Position
                                                if not val4 then
                                                    local val5 = parent:GetPivot()
                                                    val4 = val5.Position
                                                end
                                                if ((humanoidRootPart.Position - val4)).Magnitude <= 15 then
                                                    pcall(function()
                                                        desc:InputHoldBegin()
                                                        task.wait((desc.HoldDuration > 0 and desc.HoldDuration or 1.5) + 0.2)
                                                        desc:InputHoldEnd()
                                                    end)
                                                    break
                                                end
                                            end
                                        end
                                    end
                                    task.wait(0.3)
                                    character:PivotTo(CFrame.new(-150, 4, 222))
                                    task.wait(1)
                                    requests:FireServer("StoreEgg")
                                end
                            end
                        end)
                        task.wait(0.2)
                    end
                end
            end
            task.wait(1)
        end
    end)
    local _, isCollectTokens = createToggle("COLLECT TOKENS", 3)
    task.spawn(function()
        while true do
            local val = isCollectTokens()
            if val then
                pcall(function()
                    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart", 3)
                    local activeTokens = Workspace:FindFirstChild("ActiveTokens")
                    if humanoidRootPart and activeTokens then
                        local children = activeTokens:GetChildren()
                        if #children > 0 then
                            local val2 = math.random(1, #children)
                            local val3 = children[val2]
                            local val4 = nil
                            if val3:IsA("Model") then
                                local primaryPart = val3.PrimaryPart and val3.PrimaryPart.Position
                                if not primaryPart then
                                    local val5 = val3:GetPivot()
                                    primaryPart = val5.Position
                                end
                                val4 = primaryPart
                            elseif val3:IsA("BasePart") then
                                val4 = val3.Position
                            end
                            if val4 then
                                humanoidRootPart.CFrame = CFrame.new(val4 + Vector3.new(0, 3, 0))
                            end
                        end
                    end
                end)
            end
            task.wait(0.5)
        end
    end)
    local _, isAutoRebirth = createToggle("AUTO REBIRTH", 4)
    task.spawn(function()
        local eggGame = ReplicatedStorage:WaitForChild("EggGame")
        local requests = eggGame:WaitForChild("Requests")
        while true do
            local val = isAutoRebirth()
            if val then
                pcall(function()
                    requests:FireServer("RebirthState")
                    task.wait(0.3)
                    requests:FireServer("Rebirth")
                end)
                task.wait(1)
            else
                task.wait(0.5)
            end
        end
    end)
    local _, isSellAll = createToggle("SELL ALL", 5)
    task.spawn(function()
        local fishSellRemotes = ReplicatedStorage:WaitForChild("FishSellRemotes")
        local val = fishSellRemotes:WaitForChild("Request")
        while true do
            local val2 = isSellAll()
            if val2 then
                pcall(function()
                    local ok, res = pcall(function()
                        return val:InvokeServer("QuoteAll", nil)
                    end)
                    if ok then
                        local val3 = type(res)
                        ok = val3 == "table"
                    end
                    if ok then
                        ok = res.ok
                    end
                    if ok then
                        if res.count and res.count > 0 and res.token then
                            val:InvokeServer("SellAll", res.token)
                        end
                    end
                end)
                task.wait(5)
            else
                task.wait(0.5)
            end
        end
    end)
end
local val = isfile and readfile and isfile("GamingSpirit_KeySystem.txt")
if val then
    local num = tonumber(readfile("GamingSpirit_KeySystem.txt"))
    local val2 = num
    if val2 then
        local val3 = os.time() - num
        val2 = val3 < 86400
    end
    if val2 then
        startMainHub()
        return
    end
end
local CoreGui = game:GetService("CoreGui")
local ok = pcall(function()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = CoreGui
end)
if not ok then
    local Players = game:GetService("Players")
    CoreGui = Players.LocalPlayer:WaitForChild("PlayerGui")
end
local function makeDraggable(input)
    local UserInputService = game:GetService("UserInputService")
    local val2 = nil
    local val3 = nil
    local val4 = nil
    input.InputBegan:Connect(function(input2)
        if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then
            val2 = true
            val3 = input2.Position
            val4 = input.Position
            input2.Changed:Connect(function()
                if input2.UserInputState == Enum.UserInputState.End then
                    val2 = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input2)
        if val2 and (input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch) then
            local val5 = input2.Position - val3
            input.Position = UDim2.new(val4.X.Scale, val4.X.Offset + val5.X, val4.Y.Scale, val4.Y.Offset + val5.Y)
        end
    end)
end
local function fetchRemoteKey()
    local ok2, res = pcall(function()
        return game:HttpGet("https://pastebin.com/raw/3Yk4R5xS")
    end)
    if ok2 then
        ok2 = res
    end
    if ok2 then
        ok2 = res:gsub("%s+", "")
    end
    if not ok2 then
        ok2 = "GamingSpiritOnTop"
    end
    return ok2
end
local screenGui = Instance.new("ScreenGui", CoreGui)
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 200, 0, 160)
frame.Position = UDim2.new(0.5, -100, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
frame.Active = true
Instance.new("UICorner", frame)
makeDraggable(frame)
local gamingSpiritKeyLabel = Instance.new("TextLabel", frame)
gamingSpiritKeyLabel.Size = UDim2.new(1, 0, 0, 35)
gamingSpiritKeyLabel.Text = "Gaming Spirit Key"
gamingSpiritKeyLabel.TextColor3 = Color3.new(1, 1, 1)
gamingSpiritKeyLabel.BackgroundTransparency = 1
gamingSpiritKeyLabel.Font = Enum.Font.LuckiestGuy
gamingSpiritKeyLabel.TextSize = 14
local enterKeyBox = Instance.new("TextBox", frame)
enterKeyBox.Size = UDim2.new(0, 180, 0, 35)
enterKeyBox.Position = UDim2.new(0.5, -90, 0.3, 0)
enterKeyBox.PlaceholderText = "Enter Key..."
enterKeyBox.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
enterKeyBox.TextColor3 = Color3.new(1, 1, 1)
enterKeyBox.Font = Enum.Font.LuckiestGuy
enterKeyBox.TextSize = 12
Instance.new("UICorner", enterKeyBox)
local verifyBtn = Instance.new("TextButton", frame)
verifyBtn.Size = UDim2.new(0, 180, 0, 35)
verifyBtn.Position = UDim2.new(0.5, -90, 0.58, 0)
verifyBtn.Text = "Verify"
verifyBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
verifyBtn.TextColor3 = Color3.new(1, 1, 1)
verifyBtn.Font = Enum.Font.LuckiestGuy
verifyBtn.TextSize = 14
Instance.new("UICorner", verifyBtn)
local getKeyLinkBtn = Instance.new("TextButton", frame)
getKeyLinkBtn.Size = UDim2.new(0, 180, 0, 25)
getKeyLinkBtn.Position = UDim2.new(0.5, -90, 0.83, 0)
getKeyLinkBtn.Text = "Get Key Link"
getKeyLinkBtn.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
getKeyLinkBtn.TextColor3 = Color3.new(1, 1, 1)
getKeyLinkBtn.Font = Enum.Font.LuckiestGuy
getKeyLinkBtn.TextSize = 12
Instance.new("UICorner", getKeyLinkBtn)
getKeyLinkBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://lootdest.org/s?LqaMr3vF")
        getKeyLinkBtn.Text = "Link Copied!"
    else
        getKeyLinkBtn.Text = "Clipboard not supported"
    end
    task.wait(2)
    getKeyLinkBtn.Text = "Get Key Link"
end)
verifyBtn.MouseButton1Click:Connect(function()
    local text = enterKeyBox.Text
    local val2 = fetchRemoteKey()
    if text == val2 then
        if writefile then
            writefile("GamingSpirit_KeySystem.txt", tostring(os.time()))
        end
        screenGui:Destroy()
        startMainHub()
    else
        enterKeyBox.Text = ""
        enterKeyBox.PlaceholderText = "WRONG KEY!"
    end
end)
