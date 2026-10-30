local val = hookfunction(error, function() end)
error("Hello")
local val2 = hookfunction(warn, function() end)
warn("Hello");
(function()
    local val3 = hookfunction(identifyexecutor, function()
        print("Solara")
    end)
end)()
identifyexecutor()
local val3 = hookfunction(print, function() end)
print("Hello")
local val4 = getgenv()
val4.name = "KLZ0FC"
local descendants, val5 = game:GetDescendants()
for _, item in next, descendants, val5 do
    if item.ClassName == "TextLabel" then
        if string.find(item.Text, game.Players.LocalPlayer.Name) then
            local text = item.Text
            local val6 = getgenv()
            local val7 = text:gsub(game.Players.LocalPlayer.Name, val6.name)
            item.Text = val7
        end
        local localPlayer = game.Players.LocalPlayer
        item:GetPropertyChangedSignal("Text"):Connect(function()
            local text = item.Text
            local name = localPlayer.Name
            local val6 = getgenv()
            local val7 = text:gsub(name, val6.name)
            item.Text = val7
        end)
    end
end
local localPlayer = game.Players.LocalPlayer
game.DescendantAdded:Connect(function(arg1)
    if arg1.ClassName == "TextLabel" then
        local val6 = string.find(arg1.Text, localPlayer.Name)
        arg1:GetPropertyChangedSignal("Text"):Connect(function()
            local text = arg1.Text
            local name = localPlayer.Name
            local val7 = getgenv()
            local val8 = text:gsub(name, val7.name)
            arg1.Text = val8
        end)
        if val6 then
            local text = arg1.Text
            local name = localPlayer.Name
            local val7 = getgenv()
            local val8 = text:gsub(name, val7.name)
            arg1.Text = val8
        end
    end
end)
local val6 = game
val6 = val6:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local val7 = game
val7 = val7:GetService("Teams")
local localPlayer2 = val6.LocalPlayer
local character = localPlayer2.Character or localPlayer2.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local remoteVarrer = ReplicatedStorage:FindFirstChild("RemoteVarrer")
local val8 = workspace
val8 = val8:FindFirstChild("LocaisVarrer")
if not val8 then
    warn("\226\157\140 LocaisVarrer n\195\163o encontrado!")
    return
end
local function helperFn()
    local vassoura = localPlayer2.Backpack:FindFirstChild("Vassoura") or character:FindFirstChild("Vassoura")
    if not vassoura then
        warn("\226\157\140 Vassoura n\195\163o encontrada! Equipe manualmente.")
        return false
    end
    if vassoura.Parent ~= character then
        vassoura.Parent = character
        task.wait(0.3)
    end
    return true
end
helperFn()
humanoid.WalkSpeed = 28
print("\226\156\133 WalkSpeed ajustado para", 28)
local active = true
local active2 = true
local function helperFn2(arg1)
    if not character then
        return
    end
    for _, desc in ipairs(character:GetDescendants()) do
        if desc:IsA("BasePart") then
            desc.CanCollide = not arg1
        end
    end
end
helperFn2(active2)
RunService.Heartbeat:Connect(function()
    if active2 and character then
        for _, desc in ipairs(character:GetDescendants()) do
            if desc:IsA("BasePart") then
                desc.CanCollide = false
            end
        end
    end
end)
local function helperFn3()
    local bibStaff = val7:FindFirstChild("BIB | STAFF")
    if not bibStaff then
        return
    end
    for _, item in ipairs(val6:GetPlayers()) do
        if item.Team == bibStaff then
            localPlayer2:Kick("Staff detectado no servidor.")
            return
        end
    end
end
helperFn3()
task.spawn(function()
    while true do
        task.wait(30)
        helperFn3()
    end
end)
task.spawn(function()
    local VirtualUser = game:GetService("VirtualUser")
    local val9 = VirtualUser
    pcall(function()
        val9:CaptureController()
    end)
    local val10
    while true do
        task.wait(50)
        val10 = VirtualUser
        pcall(function()
            val10.ClickButton2(Vector2.new())
        end)
    end
end)
local function helperFn4(arg1)
    if not arg1 then
        return false
    end
    if not humanoidRootPart then
        return false
    end
    local val9 = typeof(arg1)
    local val10 = val9 == "Vector3" and arg1 or arg1.Position
    local val11 = Vector3.new(val10.X, humanoidRootPart.Position.Y, val10.Z)
    if ((humanoidRootPart.Position - val11)).Magnitude <= 2.5 then
        local unit = ((val11 - humanoidRootPart.Position)).Unit
        if unit.Magnitude > 0.1 then
            local val12 = CFrame.lookAt(humanoidRootPart.Position, humanoidRootPart.Position + unit)
            humanoidRootPart.CFrame = val12
        end
        return true
    end
    local unit = ((val11 - humanoidRootPart.Position)).Unit
    while true do
        if active then
            if not humanoidRootPart then
                return false
            end
            local val12 = arg1:IsA("BasePart") and arg1:GetAttribute("EmCooldown")
            if val12 then
                print("\226\143\179 Local entrou em cooldown durante o movimento")
                return false
            end
            local position = humanoidRootPart.Position
            if ((val11 - position)).Magnitude <= 2.5 then
                local val13 = Vector3.new(val10.X, humanoidRootPart.Position.Y, val10.Z)
                local val14 = CFrame.lookAt(val13, val13 + unit)
                humanoidRootPart.CFrame = val14
                return true
            end
            local val13 = position + unit * 3.5000000000000004
            local val14 = Vector3.new(val13.X, humanoidRootPart.Position.Y, val13.Z)
            local val15 = CFrame.lookAt(val14, val14 + unit)
            humanoidRootPart.CFrame = val15
            if humanoid then
                humanoid:MoveTo(val14)
            end
            task.wait(0.035)
        else
            return false
        end
    end
end
local function helperFn5(arg1)
    if not arg1 or not arg1.Parent then
        return false
    end
    if remoteVarrer then
        local ok, res = pcall(function()
            remoteVarrer:FireServer(arg1)
        end)
        if ok then
            print("\240\159\167\185 Varreu via Remote:", arg1.Name)
            return true
        end
        print("\226\154\160\239\184\143 Remote falhou:", res)
        return false
    end
    return false
end
local function helperFn6()
    while true do
        if active then
            local stateMap = {}
            for _, child in ipairs(val8:GetChildren()) do
                local val9 = child:IsA("BasePart")
                if val9 then
                    local val10 = child:GetAttribute("EmCooldown")
                    val9 = not val10
                end
                if val9 then
                    table.insert(stateMap, child)
                end
            end
            if #stateMap == 0 then
                task.wait(1)
            else
                table.sort(stateMap, function(arg1, arg2)
                    return ((humanoidRootPart.Position - arg1.Position)).Magnitude < ((humanoidRootPart.Position - arg2.Position)).Magnitude
                end)
                for _, item in ipairs(stateMap) do
                    if not active then
                        break
                    end
                    local val9 = not item.Parent or item:GetAttribute("EmCooldown")
                    if not val9 then
                        print("\240\159\143\131 Indo para:", item.Name)
                        local val10 = helperFn4(item)
                        if val10 then
                            print("\226\143\179 Aguardando 1s antes de varrer...")
                            task.wait(1)
                            helperFn5(item)
                            print("\226\143\179 Aguardando 5s...")
                            task.wait(5)
                        end
                    end
                end
            end
        else
            break
        end
    end
end
task.spawn(helperFn6)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then
        return
    end
    if input.KeyCode == Enum.KeyCode.X then
        active = not active
        if active then
            print("\226\156\133 Auto ativado")
            task.spawn(helperFn6)
        else
            print("\226\155\148 Auto desativado")
        end
    end
    if input.KeyCode == Enum.KeyCode.N then
        active2 = not active2
        local val9 = active2
        helperFn2(val9)
        print(val9 and "\226\156\133 Noclip ativado" or "\226\155\148 Noclip desativado")
    end
end)
localPlayer2.CharacterAdded:Connect(function(arg1)
    humanoid = arg1:WaitForChild("Humanoid")
    humanoidRootPart = arg1:WaitForChild("HumanoidRootPart")
    humanoid.WalkSpeed = 28
    helperFn()
    helperFn2(active2)
end)
