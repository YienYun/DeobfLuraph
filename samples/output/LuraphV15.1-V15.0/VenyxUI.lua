--[[
    Venyx UI Library v1.4.5 (Standalone Clean Luau Source)
    Reconstructed & de-minified with full semantic naming for easy reading & remaking.

    QUICK START / API USAGE:
    ----------------------------------------------------------------------------
    local Venyx = loadstring(readfile("VenyxUI.lua"))() -- or require(path.to.VenyxUI)

    local Win = Venyx:Window({
        Title = "My Hub",
        Sub = "v1.0.0",
        Id = "MyHubConfig",                 -- Folder/ID used for saving configs
        Key = Enum.KeyCode.RightControl,    -- Toggle UI keybind
        Theme = "Twilight",                 -- Twilight | Aurora | Ocean | Midnight | Sakura | Onyx | Black | Mono
    })

    -- Optional built-in Home tab
    local Home = Win:Home({
        Discord = "discord.gg/example",
        Info = { { "Version", "1.0.0" }, { "Build", "Stable" } },
    })
    Home:Stats("Overview", { { "FPS", "60", "zap" }, { "Status", "Online", "check" } })
    Home:News({ { "NEW", "Update 1.0 — Initial release" } })

    -- Standard Tab & Section
    local MainTab = Win:Tab("Main", "sparkles")
    local CombatSec = MainTab:Section("Combat", "target", 1) -- column 1 (left) or 2 (right)

    CombatSec:Toggle("Auto Farm", false, function(enabled)
        print("Auto Farm:", enabled)
    end, "Automatically farms nearby targets")

    CombatSec:Slider("WalkSpeed", 16, 150, 32, function(value)
        print("Speed:", value)
    end, " stud/s", 1, "Adjust character movement speed")

    CombatSec:Dropdown("Mode", { "Legit", "Blatant", "Safe" }, "Legit", function(selected)
        print("Selected:", selected)
    end, false, "Select farming mode")

    CombatSec:Input("Webhook URL", "https://...", function(text)
        print("Webhook:", text)
    end, "Optional Discord webhook")

    CombatSec:Key("Dash Key", Enum.KeyCode.Q, function()
        print("Dash triggered!")
    end, function(newKey)
        print("Rebound to:", newKey)
    end, "Press key to trigger dash")

    CombatSec:Button("Teleport Spawn", "Teleport", function()
        print("Teleporting...")
    end, "mint", "Return to spawn zone")

    -- Built-in utility tabs & notifications
    local SettingsTab = Win:Settings() -- Theme switcher, UI scale & keybind tab
    Win:Quick(SettingsTab)             -- Floating quick-pin bar controls inside Settings
    Win:Config()                       -- Config save / load / import / export tab
    Venyx:Notify("Loaded", "UI initialized successfully", "ok", 4)
]]

return (function()
    local Venyx, State, HttpService, RunService
    local newInstance, mountGui, createFrame, createListLayout, TopRightAnchor
    local serializeValue, configPath, writeJson, readJson, applyConfig, getUserDir, getBaseDir
    local Runtime = {mem = {}}

    function Runtime.unpack(packed)
        return table.unpack(packed, 1, packed.n)
    end
    function Runtime.decodeBase64(data)
        local b64 = [[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/]]
        local map = {}

        for index = 1, #b64 do
            map[b64:sub(index, index)] = index - 1
        end

        local out, acc, bits = {}, 0, 0

        for index2 = 1, #data do
            local current = map[data:sub(index2, index2)]

            if current ~= nil then
                acc = acc * 64 + current

                bits += 6

                if bits >= 8 then
                    bits -= 8

                    local byte = math.floor(acc / (2 ^ bits)) % 256

                    acc = acc % (2 ^ bits)
                    out[#out + 1] = string.char(byte)
                end
            end
        end

        return table.concat(out)
    end
    function Runtime.ensureFolder(filePath)
        if type(makefolder) ~= 'function' then
            return
        end

        local cur = ''

        for part in tostring(filePath):gmatch('([^/\\]+)/') do
            cur = cur == '' and part or (cur .. '/' .. part)

            pcall(function()
                if type(isfolder) ~= 'function' or not isfolder(cur) then
                    makefolder(cur)
                end
            end)
        end
    end
    function Runtime.readRaw(path)
        if type(isfile) == 'function' and type(readfile) == 'function' then
            local ok, content = pcall(function()
                return isfile(path) and readfile(path) or nil
            end)

            if ok and type(content) == 'string' then
                return content
            end
        end

        return Runtime.mem[path]
    end
    function Runtime.writeRaw(path, content)
        Runtime.mem[path] = content

        if type(writefile) == 'function' then
            Runtime.ensureFolder(path)
            pcall(writefile, path, content)
        end
    end
    function Runtime.deleteRaw(path)
        Runtime.mem[path] = nil

        if type(delfile) == 'function' and type(isfile) == 'function' then
            pcall(function()
                if isfile(path) then
                    delfile(path)
                end
            end)
        end
    end
    function Runtime.loadAsset(filePath, sources)
        local getAsset = (type(getcustomasset) == 'function' and getcustomasset) or (type(getsynasset) == 'function' and getsynasset)

        if not getAsset or type(writefile) ~= 'function' then
            return nil
        end

        local hasFile = false

        if type(isfile) == 'function' and type(readfile) == 'function' then
            local ok, data = pcall(function()
                return isfile(filePath) and readfile(filePath) or nil
            end)

            hasFile = ok and type(data) == 'string' and #data > 16
        end
        if not hasFile and type(sources) == 'table' then
            for _, srcUrl in ipairs(sources) do
                if type(srcUrl) == 'string' then
                    local bytes = nil

                    if srcUrl:sub(1, 5) == 'data:' then
                        local b64Body = srcUrl:sub(6):gsub('^[^,]*;base64,', '')
                        local okDec, dec = pcall(Runtime.decodeBase64, b64Body)

                        if okDec and type(dec) == 'string' and #dec > 16 then
                            bytes = dec
                        end
                    else
                        local okHttp, body = pcall(function()
                            return game:HttpGet(srcUrl)
                        end)

                        if okHttp and type(body) == 'string' and #body > 16 then
                            bytes = body
                        end
                    end
                    if bytes then
                        Runtime.ensureFolder(filePath)

                        if pcall(writefile, filePath, bytes) then
                            hasFile = true

                            break
                        end
                    end
                end
            end
        end
        if not hasFile then
            return nil
        end

        local okAsset, assetId = pcall(getAsset, filePath)

        return (okAsset and type(assetId) == 'string' and assetId ~= '') and assetId or nil
    end
    function Runtime.mountWindow(win, id)
        Venyx.Id = id
        Venyx.W = win

        local genv = (type(getgenv) == 'function' and getgenv()) or _G

        genv.VenyxWindows = genv.VenyxWindows or {}

        local prev = genv.VenyxWindows[id]

        if prev and prev ~= win then
            if prev.nt and prev.nt.Parent then
                pcall(prev.nt.Parent.Destroy, prev.nt.Parent)
            end
            if type(prev.Destroy) == 'function' then
                pcall(prev.Destroy, prev)
            end
        end

        local slot = 0

        while true do
            local used = false

            for _, other in next, genv.VenyxWindows do
                if other and other ~= win and other.slot == slot then
                    used = true

                    break
                end
            end

            if not used then
                break
            end

            slot += 1
        end

        win.Id = id
        win.slot = slot
        genv.VenyxWindows[id] = win

        local gui = newInstance('ScreenGui', {
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 100,
        })

        mountGui(gui)

        local notifGui = newInstance('ScreenGui', {
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 200,
        })

        mountGui(notifGui)

        win.nt = createFrame({
            Parent = notifGui,
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -20, 1, -20),
            Size = UDim2.new(0, 320, 1, -40),
            createListLayout(10, nil, Enum.VerticalAlignment.Bottom),
        })

        return gui
    end
    function Runtime.readJson(filePath)
        local raw = Runtime.readRaw(filePath)

        if type(raw) ~= 'string' or raw == '' then
            return nil
        end

        local ok, decoded = pcall(HttpService.JSONDecode, HttpService, raw)

        return ok and type(decoded) == 'table' and decoded or nil
    end
    function Runtime.writeJson(filePath, data)
        local ok, encoded = pcall(HttpService.JSONEncode, HttpService, data)

        if ok and type(encoded) == 'string' then
            Runtime.writeRaw(filePath, encoded)

            return true
        end

        return false
    end
    function Runtime.saveConfig(_self, cfgName)
        local target = (type(cfgName) == 'string' and cfgName ~= '') and cfgName or State.Active or 'Default'
        local payload = {}

        for key, item in next, Venyx.Keys do
            if not item.Skip then
                payload[key] = serializeValue(item.Value)
            end
        end

        return writeJson(configPath(target), payload)
    end
    function Runtime.loadConfig(_self, cfgName)
        local target = (type(cfgName) == 'string' and cfgName ~= '') and cfgName or State.Active or 'Default'
        local data = readJson(configPath(target))

        if type(data) ~= 'table' then
            return false
        end

        applyConfig(data)

        if State.Active ~= target then
            State.Active = target

            Venyx:Persist()
        end

        return true
    end
    function Runtime.listConfigs(_self)
        local names, seen = {}, {}
        local dir = getUserDir()

        pcall(function()
            if type(listfiles) == 'function' then
                for _, fp in ipairs(listfiles(dir)) do
                    local nm = fp:match('([^/\\]+)%.json$')

                    if nm and nm:sub(1, 1) ~= '_' and not seen[nm] then
                        seen[nm] = true
                        names[#names + 1] = nm
                    end
                end
            end
        end)

        local prefix = dir .. '/'

        for fp in next, Runtime.mem do
            if fp:sub(1, #prefix) == prefix then
                local nm = fp:sub(#prefix + 1):match('^([^/\\]+)%.json$')

                if nm and nm:sub(1, 1) ~= '_' and not seen[nm] then
                    seen[nm] = true
                    names[#names + 1] = nm
                end
            end
        end

        if not seen.Default then
            names[#names + 1] = 'Default'
        end

        table.sort(names)

        return names
    end
    function Runtime.deleteConfig(_self, cfgName)
        if type(cfgName) ~= 'string' or cfgName == '' or cfgName:lower() == 'default' then
            return false
        end

        local srcPath = configPath(cfgName)
        local data = readJson(srcPath)

        if data then
            writeJson(getUserDir() .. '/_trash/' .. cfgName .. '.json', data)
        end

        Runtime.deleteRaw(srcPath)

        if State.Active == cfgName then
            State.Active = 'Default'

            Venyx:Persist()
            Venyx:Load('Default')
        end

        return true
    end
    function Runtime.restoreConfig(_self, cfgName)
        if type(cfgName) ~= 'string' or cfgName == '' then
            return nil
        end

        local trashPath = getUserDir() .. '/_trash/' .. cfgName .. '.json'
        local data = readJson(trashPath)

        if type(data) ~= 'table' then
            return nil
        end

        local restoredName = Venyx:Name(cfgName) or cfgName

        writeJson(configPath(restoredName), data)
        Runtime.deleteRaw(trashPath)

        return restoredName
    end
    function Runtime.exportConfig(_self, cfgName)
        local target = (type(cfgName) == 'string' and cfgName ~= '') and cfgName or State.Active or 'Default'
        local data = readJson(configPath(target))

        if type(data) ~= 'table' then
            Venyx:Save(target)

            data = readJson(configPath(target)) or {}
        end

        return HttpService:JSONEncode({
            name = target,
            data = data,
        })
    end
    function Runtime.importConfig(_self, text)
        text = tostring(text or ''):match('^%s*(.-)%s*$')

        if text == '' then
            return nil, 'Paste exported config text first'
        end

        local ok, parsed = pcall(HttpService.JSONDecode, HttpService, text)

        if not ok or type(parsed) ~= 'table' then
            return nil, 'Invalid config format'
        end

        local rawName = type(parsed.name) == 'string' and parsed.name or 'Imported'
        local data = type(parsed.data) == 'table' and parsed.data or parsed
        local safeName, err = Venyx:Name(rawName)

        if not safeName then
            safeName = Venyx:Name('Imported')
        end
        if not safeName then
            return nil, err or 'Could not name imported config'
        end

        writeJson(configPath(safeName), data)

        return safeName
    end
    function Runtime.boot(_self)
        Runtime.ensureFolder(getUserDir() .. '/_trash/x')

        local savedState = readJson(getUserDir() .. '/_state.json')

        if type(savedState) == 'table' then
            if type(savedState.AutoLoad) == 'boolean' then
                State.AutoLoad = savedState.AutoLoad
            end
            if type(savedState.AutoSave) == 'boolean' then
                State.AutoSave = savedState.AutoSave
            end
            if type(savedState.Active) == 'string' and savedState.Active ~= '' then
                State.Active = savedState.Active
            end
            if type(savedState.Theme) == 'string' and savedState.Theme ~= '' then
                State.Theme = savedState.Theme
            end
        end
        if State.Theme then
            Venyx:Theme(State.Theme)
        end

        RunService.Heartbeat:Once(function()
            if not readJson(configPath('Default')) then
                Venyx:Save('Default')
            end
            if State.AutoLoad and State.Active then
                Venyx:Load(State.Active)
            end
        end)
    end

    -- ========================================================================
    -- 1. Roblox Services, Typography & Theme Presets
    -- ========================================================================
    local function getService(serviceName)
        return game:GetService(serviceName)
    end

    local UserInputService = getService('UserInputService')
    local TweenService = getService('TweenService')

    HttpService = getService('HttpService')
    RunService = getService('RunService')

    local localPlayer = getService('Players').LocalPlayer
    local color3FromRGB = Color3.fromRGB
    local _ = UDim2.new
    local uDimNew = UDim.new
    local vector2New = Vector2.new
    local FontSemiBold, FontBold = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.SemiBold), Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.Bold)
    local FontExtraBold = Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.ExtraBold)
    local FontMono = Font.new('rbxasset://fonts/families/RobotoMono.json', Enum.FontWeight.SemiBold)
    local FontDisplay = Font.new('rbxassetid://12187365977', Enum.FontWeight.Bold)
    local GreenTextSeq = ColorSequence.new(color3FromRGB(26, 255, 0), color3FromRGB(0, 255, 0))
    local FontItalic, Palette = Font.new(FontDisplay.Family, FontDisplay.Weight, Enum.FontStyle.Italic), {}

    Palette.bg = color3FromRGB(16, 18, 40)
    Palette.tx = color3FromRGB(242, 244, 255)
    Palette.a1 = color3FromRGB(122, 162, 255)
    Palette.a2 = color3FromRGB(185, 139, 255)
    Palette.g1 = color3FromRGB(255, 229, 138)
    Palette.g2 = color3FromRGB(255, 155, 88)
    Palette.dk = color3FromRGB(42, 18, 0)
    Palette.mint = color3FromRGB(110, 255, 182)
    Palette.red = color3FromRGB(255, 110, 110)
    Palette.sky = color3FromRGB(143, 180, 255)
    Palette.pink = color3FromRGB(255, 158, 207)
    Palette.vio = color3FromRGB(199, 166, 255)
    Palette.gold = color3FromRGB(255, 210, 122)
    Palette.wh = color3FromRGB(255, 255, 255)
    Palette.val = color3FromRGB(217, 222, 255)
    Palette.dc = color3FromRGB(88, 101, 242)
    Palette.pn = color3FromRGB(24, 26, 54)
    Palette.w1 = color3FromRGB(36, 40, 86)
    Palette.w2 = color3FromRGB(14, 15, 34)
    Palette.gv = color3FromRGB(184, 255, 156)
    Palette.on = color3FromRGB(255, 255, 254)

    local Themes = {
        {
            'Twilight',
            color3FromRGB(36, 40, 86),
            color3FromRGB(14, 15, 34),
            color3FromRGB(122, 162, 255),
            color3FromRGB(185, 139, 255),
        },
        {
            'Aurora',
            color3FromRGB(10, 84, 82),
            color3FromRGB(4, 26, 38),
            color3FromRGB(63, 224, 176),
            color3FromRGB(127, 255, 216),
        },
        {
            'Ocean',
            color3FromRGB(8, 70, 128),
            color3FromRGB(3, 20, 52),
            color3FromRGB(47, 185, 221),
            color3FromRGB(127, 220, 255),
        },
        {
            'Midnight',
            color3FromRGB(52, 24, 112),
            color3FromRGB(10, 4, 36),
            color3FromRGB(118, 100, 226),
            color3FromRGB(160, 132, 240),
        },
        {
            'Sakura',
            color3FromRGB(118, 44, 96),
            color3FromRGB(36, 12, 40),
            color3FromRGB(255, 140, 200),
            color3FromRGB(255, 196, 228),
        },
        {
            'Onyx',
            color3FromRGB(58, 46, 22),
            color3FromRGB(8, 6, 2),
            color3FromRGB(255, 206, 110),
            color3FromRGB(255, 150, 80),
        },
        {
            'Black',
            color3FromRGB(50, 50, 56),
            color3FromRGB(16, 16, 19),
            color3FromRGB(250, 251, 255),
            color3FromRGB(176, 182, 198),
            color3FromRGB(14, 14, 18),
        },
        {
            'Mono',
            color3FromRGB(92, 94, 104),
            color3FromRGB(30, 31, 36),
            color3FromRGB(250, 251, 255),
            color3FromRGB(196, 200, 214),
            color3FromRGB(20, 21, 26),
        },
    }
    local QuickBarColors = {
        Palette.gold,
        Palette.mint,
        Palette.sky,
        Palette.pink,
        Palette.vio,
    }
    local KeyLabels = {
        LeftShift = 'LShift',
        RightShift = 'RShift',
        LeftControl = 'LCtrl',
        RightControl = 'RCtrl',
        LeftAlt = 'LAlt',
        RightAlt = 'RAlt',
    }
    local FullSize = UDim2.new(1, 0, 1, 0)
    local CenterPos = UDim2.new(0.5, 0, 0.5, 0)
    local CenterAnchor = vector2New(0.5, 0.5)
    local RightCenterAnchor = vector2New(1, 0.5)
    local AlignCenterX = Enum.TextXAlignment.Center
    local AlignRightX = Enum.HorizontalAlignment.Center
    local FillHorizontal = Enum.FillDirection.Horizontal
    local AutoSizeY = Enum.AutomaticSize.Y
    local AutoSizeX = Enum.AutomaticSize.X
    local TruncateAtEnd = Enum.TextTruncate.AtEnd
    local AlignCenterY = Enum.VerticalAlignment.Center
    local FullWidth = UDim2.new(1, 0, 0, 0)
    local RightMidPos = UDim2.new(1, 0, 0.5, 0)
    local TopRightVec = vector2New(1, 0)

    TopRightAnchor = TopRightVec

    local EaseQuint = Enum.EasingStyle.Quint
    local EaseBack, TopBarHeight, SidebarWidth = Enum.EasingStyle.Back, 46, 54

    local function fromOffset(width, height)
        return UDim2.new(0, width, 0, height)
    end

    -- ========================================================================
    -- 2. Spritesheet Icon Atlas & Custom Asset Loader
    -- ========================================================================
    local IconIndex, IconNames = {}, {
        'home',
        'zap',
        'egg',
        'farm',
        'leaf',
        'eye',
        'user',
        'settings',
        'search',
        'minus',
        'x',
        'shield',
        'target',
        'crosshair',
        'key',
        'palette',
        'folder',
        'star',
        'check',
        'down',
        'gauge',
        'wind',
        'ghost',
        'clock',
        'coins',
        'pin',
        'info',
        'warn',
        'ok',
        'sliders',
        'grid',
        'server',
        'flame',
        'swords',
        'trash',
        'save',
        'copy',
        'plus',
        'refresh',
        'crown',
        'gem',
        'hand',
        'wand',
        'sparkles',
        'discord',
    }

    for index, value in ipairs(IconNames) do
        IconIndex[value] = index - 1
    end

    local iconSheetUrl, iconSheetLoaded = 'tienkhanh1/venyx-assets@main/venyx-icons3.png'
    local loadAsset = Runtime.loadAsset

    local function getIconSheetAsset()
        if iconSheetLoaded == nil then
            iconSheetLoaded = loadAsset('Venyx/icons3.png', {
                'https://raw.githubusercontent.com/' .. iconSheetUrl:gsub('@', '/'),
                [[https://cdn.jsdelivr.net/gh/tienkhanh1/venyx-assets@main/venyx-icons3.png]],
            }) or false
        end

        local current = iconSheetLoaded

        return current
    end

    local venyxTable = {
        Opt = {},
        Keys = {},
        Alias = {},
    }

    Venyx = venyxTable
    Venyx.th = Themes[1][1]

    local stateTable = {
        AutoLoad = true,
        AutoSave = true,
        Active = 'Default',
        Theme = 'Black',
        Cfg = 2,
    }

    State = stateTable
    Venyx.State = State

    local activeConnections = {}

    local function connectSignal(signal, callback)
        local current = activeConnections

        current[#activeConnections + 1] = signal:Connect(callback)
    end
    local function randomGuiName()
        local list = {}

        for index = 1, 10, 1 do
            list[index] = string.char(math.random(97, 122))
        end

        return table.concat(list)
    end

    -- ========================================================================
    -- 3. UI Element Factories, Layout Modifiers & Motion Helpers
    -- ========================================================================
    newInstance = function(parent, param2)
        local current = Instance.new(parent)

        current.Name = randomGuiName()
        parent = param2.Parent
        param2.Parent = nil

        for key, value in next, param2 do
            if type(key) == 'number' then
                value.Parent = current
            else
                current[key] = value
            end
        end

        current.Parent = parent

        return current
    end

    local baseGuiDefaults = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }

    baseGuiDefaults.BackgroundColor3 = Palette.wh

    local function makeElementFactory(className, defaults, scaleText)
        local function updateView(props)
            local items = {defaults, baseGuiDefaults}

            for index, value in ipairs(items) do
                for key, value2 in next, value do
                    if props[key] == nil then
                        props[key] = value2
                    end
                end
            end

            if scaleText then
                if props.TextSize then
                    props.TextSize = math.floor(props.TextSize * 1.18 + 0.5)
                end
            end

            local isMatch = props.TextTruncate == TruncateAtEnd and not props.AutomaticSize and props.TextSize

            if isMatch then
                props.TextTruncate = nil
            end

            local props2 = newInstance(className, props)

            if isMatch then
                local function updateView2()
                    if props2.AbsoluteSize.X < 2 then
                        return
                    elseif props2:GetAttribute('nofit') then
                        return
                    elseif props2.TextSize == isMatch then
                        if props2.TextBounds.X <= props2.AbsoluteSize.X then
                            return
                        end
                    end

                    props2.TextSize = isMatch

                    local alt = props2:GetAttribute('alt')

                    if alt then
                        if props2.Text ~= alt then
                            if props2.TextBounds.X > props2.AbsoluteSize.X then
                                props2.Text = alt

                                return
                            end
                        end
                    end

                    while true do
                        local current, absoluteSize = props2.TextBounds.X, props2.AbsoluteSize

                        if not (current > absoluteSize.X and props2.TextSize > 8) then
                            break
                        end

                        props2.TextSize = props2.TextSize - 1
                    end
                end

                props2:GetPropertyChangedSignal('Text'):Connect(updateView2)
                props2:GetPropertyChangedSignal('AbsoluteSize'):Connect(updateView2)
            end

            return props2
        end

        return updateView
    end

    local baseTextDefaults, rawFrameFactory = {
        FontFace = FontSemiBold,
        TextColor3 = Palette.tx,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, makeElementFactory('Frame', {})

    createFrame = rawFrameFactory

    local createSolidFrame = makeElementFactory('Frame', {BackgroundTransparency = 0})
    local createButton = makeElementFactory('TextButton', {
        Text = '',
        AutoButtonColor = false,
    }, true)
    local createLabel = makeElementFactory('TextLabel', baseTextDefaults, true)
    local createTextBox = makeElementFactory('TextBox', {
        Text = '',
        PlaceholderColor3 = color3FromRGB(178, 180, 188),
        ClearTextOnFocus = false,
        FontFace = FontSemiBold,
        TextColor3 = Palette.tx,
        TextSize = 13,
        TextXAlignment = baseTextDefaults.TextXAlignment,
    }, true)
    local createScrollFrame = makeElementFactory('ScrollingFrame', {
        ScrollBarThickness = 2,
        ScrollBarImageTransparency = 0.6,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = AutoSizeY,
        ScrollingDirection = Enum.ScrollingDirection.Y,
    })
    local rawImageLabel = makeElementFactory('ImageLabel', {})

    local function createImage(props)
        local current = IconIndex[props.Image]

        if current then
            local current2 = getIconSheetAsset()

            props.Image = current2 or ''

            if current2 then
                props.ImageRectOffset = vector2New(current % 8 * 64, current // 8 * 64)
                props.ImageRectSize = vector2New(64, 64)
            end
        end

        return rawImageLabel(props)
    end
    local function createIcon(iconName, size, color, transparency)
        return createImage({
            AnchorPoint = CenterAnchor,
            Position = CenterPos,
            Size = fromOffset(size, size),
            Image = iconName,
            ImageColor3 = color,
            ImageTransparency = transparency,
        })
    end
    local function getAvatarThumb(sizeEnum)
        return 'rbxthumb://type=AvatarHeadShot&id=' .. localPlayer.UserId .. '&w=' .. sizeEnum .. '&h=' .. sizeEnum
    end
    local function createCorner(radius)
        return newInstance('UICorner', {
            CornerRadius = radius and uDimNew(0, radius) or uDimNew(1, 0),
        })
    end
    local function createStroke(transparency, color)
        local items = {
            Transparency = transparency,
            Color = color or Palette.wh,
        }

        items.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        return newInstance('UIStroke', items)
    end
    local function createGradient(startColor, endColor, rotation)
        return newInstance('UIGradient', {
            Color = ColorSequence.new(startColor, endColor),
            Rotation = rotation or 0,
        })
    end
    local function createAlphaGradient(rotation, ...)
        local list, items = {}, {...}

        for index, item in ipairs(items) do
            list[index] = NumberSequenceKeypoint.new(item[1], item[2])
        end

        return newInstance('UIGradient', {
            Rotation = rotation,
            Transparency = NumberSequence.new(list),
        })
    end
    local function createPadding(padTop, padRight, padBottom, padLeft)
        return newInstance('UIPadding', {
            PaddingTop = uDimNew(0, padTop),
            PaddingRight = uDimNew(0, padRight or padTop),
            PaddingBottom = uDimNew(0, padBottom or padTop),
            PaddingLeft = uDimNew(0, padLeft or padRight or padTop),
        })
    end

    createListLayout = function(param1, param2, param3, param4)
        local items = {
            Padding = uDimNew(0, param1 or 0),
            HorizontalAlignment = param2,
            VerticalAlignment = param3,
            FillDirection = param4,
        }

        items.SortOrder = Enum.SortOrder.LayoutOrder

        return newInstance('UIListLayout', items)
    end

    local function createDivider(parent, position, size)
        return createFrame({
            Parent = parent,
            Position = position,
            Size = size,
            BackgroundTransparency = 0.9,
        })
    end
    local function tween(target, goal, duration, easingStyle, easingDir, repeats)
        local tweenInfoNew, count, current, current2 = TweenInfo.new, duration or 0.25, easingStyle or EaseQuint

        if easingDir then
            current2 = easingDir
        else
            current2 = Enum.EasingDirection.Out
        end

        easingDir = TweenService:Create(target, tweenInfoNew(count, current, current2, 0, false, repeats or 0), goal)

        easingDir:Play()

        return easingDir
    end
    local function bindHoverAlpha(target, hoverAlpha, restAlpha)
        connectSignal(target.MouseEnter, function()
            tween(target, {BackgroundTransparency = hoverAlpha}, 0.15)
        end)
        connectSignal(target.MouseLeave, function()
            tween(target, {
                BackgroundTransparency = restAlpha or 1,
            }, 0.25)
        end)
    end
    local function hideOnTweenDone(frame, tweenObj, shouldHide)
        local function updateView()
            if not (shouldHide()) then
                tweenObj.Visible = false
            end
        end

        frame.Completed:Connect(updateView)
    end
    local function safeCall(callback, ...)
        if callback then
            pcall(callback, ...)
        end
    end
    local function isPrimaryPointer(input)
        local isMatch, I12 = input.UserInputType == Enum.UserInputType.MouseButton1

        if isMatch then
            I12 = isMatch
        else
            I12 = input.UserInputType == Enum.UserInputType.Touch
        end

        return I12
    end

    local pointerTracker = {}

    pointerTracker.p = Vector3.zero
    pointerTracker.t = 0
    pointerTracker.m = 0

    connectSignal(UserInputService.InputBegan, function(input)
        if isPrimaryPointer(input) then
            pointerTracker.p, pointerTracker.t = input.Position, os.clock()
            pointerTracker.m = 0
            pointerTracker.s = false
        end
    end)
    connectSignal(UserInputService.InputChanged, function(input)
        local isMatch, isMatch2 = input.UserInputType == Enum.UserInputType.Touch

        if isMatch then
            isMatch2 = isMatch
        else
            isMatch2 = input.UserInputType == Enum.UserInputType.MouseMovement
        end
        if isMatch2 then
            pointerTracker.m = math.max(pointerTracker.m, (input.Position - pointerTracker.p).Magnitude)
        end
    end)

    local function isCleanTap()
        return pointerTracker.m < 14 and os.clock() - pointerTracker.t < 0.45 and not pointerTracker.s
    end
    local function onClick(button, callback)
        connectSignal(button.Activated, function(...)
            if isCleanTap() then
                callback(...)
            end
        end)
    end
    local function formatNumber(numText)
        local text = tostring(numText)
        local current, current2 = text:match('^(%-?%d+)(.*)$')

        if not current then
            return text
        end

        return current:reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^(%-?),', '%1') .. current2
    end
    local function bindPressScale(button, pressScale, hoverProps, onActivate)
        local anchorPoint, pos, bounds = button.AnchorPoint, button.Position, button.Size

        if not (button.Parent:FindFirstChildWhichIsA('UIGridStyleLayout')) then
            button.AnchorPoint = CenterAnchor
            button.Position = pos + UDim2.new((0.5 - anchorPoint.X) * bounds.X.Scale, (0.5 - anchorPoint.X) * bounds.X.Offset, (0.5 - anchorPoint.Y) * bounds.Y.Scale, (0.5 - anchorPoint.Y) * bounds.Y.Offset)
        end

        local uiScale = newInstance('UIScale', {Parent = button})

        hoverProps = hoverProps or button

        connectSignal(hoverProps.InputBegan, function(input)
            if not (isPrimaryPointer(input)) then
                return
            end

            tween(uiScale, {
                Scale = pressScale or 0.96,
            }, 0.12)

            if onActivate then
                onActivate(true)
            end
        end)
        connectSignal(hoverProps.InputEnded, function(input)
            if not (isPrimaryPointer(input)) then
                return
            end

            tween(uiScale, {Scale = 1}, 0.4, EaseBack)

            if onActivate then
                onActivate(false)
            end
        end)
    end
    local function createSpring(stiffness, damping)
        return {
            p = stiffness,
            v = vector2New(),
            t = stiffness,
            a = damping,
        }
    end
    local function stepSpring(spring, dt)
        if (spring.t - spring.p).Magnitude < 0.03 then
            if spring.v.Magnitude < 0.03 then
                return
            end
        end

        dt = math.min(dt, 0.05)

        local ceil = math.ceil(dt * 240)
        local current = dt / ceil

        for _ = 1, ceil, 1 do
            spring.v = spring.v + ((spring.t - spring.p) * 230 - spring.v * 29) * current
            spring.p = spring.p + spring.v * current
        end

        spring.a(spring.p)
    end
    local function bindSpringDrag(handle, targetFrame, getScale)
        local current, entry, current2, enabled

        local function updateView()
            local userInputType, _unused = current.UserInputType

            return userInputType == Enum.UserInputType.Touch
        end

        connectSignal(handle.InputBegan, function(input)
            if not current then
                if isPrimaryPointer(input) then
                    local vec, current3 = vector2New(input.Position.X, input.Position.Y), targetFrame.t

                    current, entry, current2, enabled = input, vec, current3, false
                end
            end
        end)
        connectSignal(UserInputService.InputChanged, function(input)
            if not current then
                return
            end
            if updateView() and input ~= current then
                return
            elseif not (updateView()) then
                if input.UserInputType ~= Enum.UserInputType.MouseMovement then
                    return
                end
            end

            local current3 = vector2New(input.Position.X, input.Position.Y) - entry

            enabled = enabled or current3.Magnitude > 5

            if enabled then
                targetFrame.t = getScale(current2 + current3)
            end
        end)
        connectSignal(UserInputService.InputEnded, function(input)
            if current then
                if input == current then
                    current = nil
                elseif not (updateView()) then
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        current = nil
                    end
                end
            end
        end)

        local function updateView2()
            local current3 = enabled

            return current3
        end

        return updateView2
    end
    local function createCrownIcon(parent, size, color, position, anchorPoint)
        local props, corner, gradient, props2, _unused = {
            Parent = parent,
            AnchorPoint = anchorPoint,
            Position = position,
            Size = fromOffset(size, color),
        }, createCorner(), createGradient(Palette.g1, Palette.g2, 45), {
            AnchorPoint = vector2New(0.5, 1),
        }, UDim2.new

        props2.Position = UDim2.new(0.5, 0, 1, -(color * 0.12 // 1))
        props2.Size = fromOffset(size * 0.45 // 1, size * 0.45 // 1)
        props2.BackgroundColor3 = color3FromRGB(255, 246, 214)
        props2[1] = createCorner()
        props[1], props[2], props[3] = corner, gradient, createSolidFrame(props2)

        return createSolidFrame(props)
    end

    local MarkLogoAsset = {
        'Venyx/mark1.png',
        {
            
[[data:iVBORw0KGgoAAAANSUhEUgAAAIYAAACACAYAAADOIBGMAAAPWklEQVR4nOydedRd0xnGn8/qH6VKQtIEFVESJTGFGKrRIk1Lo9RUZZWlWLS0S9qaaQ1VStAGCdpGzFMQjURVUkPNpVTFGErNbRUd1Oo/PI+7b9Z1c+6Z9rvvOefe81trr/199557hr3f8+7pfd+9DGpqIlgGNTUR1IJRE8kSwXjvvfdWYLqOaRxq+grW+eZMVzMt2/xsiWAMDAz8i9kzTA/xgCNQ0xewrk9idh/TE5SB/zU/H2g76BPMXmb6CNPNTHvw4P+gpudgXQ9hNpvpc0z/ZxrGun6r+f2H+hj84m/MrnD/bs+0iCfYCjU9BetUdfsYGkIhLmoVChHV+Ty/5e8RTHfxRMegpidgXZ7FbD7TsJaPz28/binBoOTcy+yqto9P4QmvZFoONZWEdbcS0wL+OaXtK2mLR9qP7zRcPS/isz2ZHuXJx6OmUrDOvshsEdN2EV9Pj/pNpGBQgu5idm/EV2sxPcAL7Y2aSsC6+g6z3zANj/j6Ntb1g1G/i5vgOj3mu8t4we+jptSwjo5lNi3mkFM7fTGA+BO/xGy1mENOo8QdjZrSwbqbyizu5X2BdTey05dJU+KnJ3x/FG/gUtSUBg0QmG5EvFCI2LpN0hgrMnuVaVnEs5Bpx9aZs5ruw/r6OBr9ic8kHKpZ7lVYX+90OiBWY/CHb6NDr7UN9Xbn88Y+hppCYNkPQuMFTRIKcW6cUIhYjeEuqGny15GOu5m250X/jZquwTpamdltTOunOPxdptVZR/+IOyhx2d1Nk09DOjR9fqtTaTVdwL24v0c6oRBnJgmFSNQY7uJj0JhbT4tW6ybyBv6LmmCwXoYyu4Np3Qw/G816eSbpoFSGOjyRZs1uQXq2YJqDmmC4gYGmuLMIxdw0QiGyWHCdjWxM5M3/GjXmsFyXR2P0sQGycVbaA1M1JS03pOnTTZCN6ymlu6LGBGdl9VumzyIb97AeUptQZLX5nIXs7MKHqZsVO65BdqEQs7IcnFVjaNld0+SDkZ3zKLGHoiY3LP8LmR2I7GhkOTLLBGQmjeEmRc5EPg7hg30XNblg2R2OfEIhzsg6K51JYwg3uym70BWRj0m8yVtRkxqW+WRmc5EPzVloQuvdLD/K7Ffi5iauQH5m80HXQU0qWFZjmV2J/MzMKhQir8PR+cjPCmgIx6dQEwvLaCQanc3lkZ9fIAe5BIMS+Ciz3yE/eguuQk1H3FzFPGSbwGpnHutqMXLg46LoozXEeD58kr1HP3MJ03rwI+0a11Jk7ny2worV+skY+LEXpdqnDe05WK4nMvsh/Lif5boFcuLr1OzTCV1yDhbEhqj5AJbFV+AvFGI2PPDVGJro0tA1ycIrib8wbeT8Z/sW1yFX/83X4EleZav7uJd6aQxe+E1mF8GfNZkuRs1l8BcKcZGvz7FFfIxzYMPOzgeiL+GzH8lsS9hwLjzxakqauEWynWDD+pT2LEZBlYfltxGzh2HDNSy/r8ETq4g6vkPXVmaij3DzFVfDjhkwwEQwKKEyGklrMJyE5jdORv+gfsVo2PAc6+J2GGAZg+tU2HEchSOrQVDl4DN+AXZNsDCbMDTpYwg3dP0n7FA/Y3yeBaAq4JqQB+A35d3O8lYG2GYaww1dLSa8mmg95UfoXU6DrVBcbmmVb6YxBN+CbeC3uBbFBBeWoWdgOclzbwFs2dAtbppgKhiCD30/s81gxxNM43qlSXHGvHLHWBN2PMTy2RSGhAgAewlskbr9MXoHNSGWQiFy2VzEEUJjaEr3r0wrwZa1+VY8iwrDstEy+iLY8nemEdYa1VxjuA6QySRLGz9B9Unt8JOBs0M0s+YaQ/DNWB0NrWGN/GEXooKwTOR05bUU3oGhaZyUsxIkyDxv9EU0vKWs+Rmqy1TYMzeEUIiQuw+EUJtj+ebthorhohyOhD0hyvgDgjQlTVggMsAZCVue4lvyaVQIlsNzsB+JLGY5jEIgQu9XYrnq2mQdFnRlXB3dTg7WQiGs7GAiCa0xPsnsRdgjX8xRZTcFdIFNNMQOEWFoaKj+hQiqMXjjcoD+FexReKEjUX5OQBihODekUIigGkPwrVF/4AmEYZiLEVY6nGFvqAm5UXkdidISfE80PsCTzEI5MZdZa5yEMMwLLRQiuMYQfHt2R8MHMwRDWFBvoETweWWR9RTCsBOfN3gIq67sosgHuRZhZkLFQSgfUxCGxd0QCtHN7TVDaYzDnDVUKeC9rMLsYIQhVBkuRTcFI8ToRGhIaOHSZ8VRCIeFc1cqutLHaMK36ZfM9oc98rpareh5DW0vhUaMMl+XzShm8Pm+jS7RTY0hzkMY1JTsgeLRmkgIoRChyi6SrmoMwbdKIY63hj2P843yDcngBZ9NUXfXhj3z+WxfRhfptsYQeaP+JbGe89MoBF57R4QRCtH1ADNd1xiChagxvpX3VSsL+GYVIhx8pjuZTYA9hWjCIjSGCGWmN9Et3HUVXlO7S4YQClGIu2ZRgiEn3lCzld9C9wk1WniF2qKQIHaFCIYzXs0dOCyBvNFzc+H8RL6JMPwUBVGUxhASjBBbZA1lZXnHh8iAhsmDYI9cPs39RdJSmGBQayhOVCibxa5NBCHcWs3UInelLGRU0sTt/KeZwhC7L45w1urBCGhzISeiNQcK3DqsyKakqTV+jjB0Y9U11GLZmQMF7ydXqMYQzi4yhBXWoyzcoPFDA83H6GUZUfQWpYVqDMECkNoMsQ6wQcg5DZ5bztYhJummFS0UonDBcGTdiC8tSfub+xBiUx51NkMN4zNRCsFwXuwhjFD2RTj2hj3Ty2KmWHgfo0nAHv62LOzbYAjvdXtm82HPYNchL5yyNCXSGnLjCzGvEcLX9auw57SyCIUojcYQfBOHM3sVtrzGAl8FhvA+pe4tA8Oob7GG64iXgtJoDMGCeQ32HdHhrMgvwQieS3E5raMFTSuTUIhSCYZDgWStVeqesMPyXEJzOIUtlnWidILh3pzDYItJ9F0XX2xn2DLFxUgtFWXUGBIO7V1i6aA0iJW6C/zR7kMfhR3P8lktg+aaUUrBcFj7ilg0AdbNyNEoKaUalbTDt/xx2IVVlnHQsLy+JyFipfNe1kdJKbPGEEfADjUBPib41nMX30OJKbVg8I26CbbR/3w6oZYTZXPKvr99qZsS4bbefAQ2vMkKyTUHwfuQG6SVQdFo3sczKDFlb0qkNf4Eu+0pBrOCM5v58zeTYScUM8ouFKL0guE4Aw1zNwv2QXasjItlZ3ECKkAlBMMZxVptrZWpn0FtsRyzHWGD+kxDUAGqojEkHFpDeRL+DHV+pmnZgWlF+KNguNoPdRGvfyPTeBQAr7st02ym2HgllREMh5WXWZahp9Uw9TAK9z1o7PWmGdQHWDk3Ma2DLuAE4kH+qSD9Cnh/U9zxpR+VtMOHuwH+6xVvsZIGpzmQ13ub2Qrw40peby93vqhAdcfz+yCb9bidIKYzTW75eBGvNzbud1XTGEKhjHwj5wxK05y4gPa+QqEFsiVbk7tAdX9oO+ZkXuslJtMFOp7vODR2apzc9tWxSb+tnGCwYGWyPx3+7JXimDwjmHbOibDjjIrqtxrTDazME+GJgtUxaXFOnvLD276+nfdzY9I5KteUCBelT3MBw+HHqiykVztcYwSzF+CHvOxGR7ka8vxz0HmEpKH5xDy7IvK8mzOTh/zIDod8nue9I+E0lWxKpDU0C2nhnxq3FmMRfe+Qgc7+p3GuDXLCulMdRmSAx+ue70Nnobg0jVCISmqMJk5dfh35eYMFNSTivAoM/zL8AsTP4rn3izuA11FY6eMRz0E8z4UJ55EGlZaIWySU9hqTdnW5khqjhRPgx8qug9aObEF8dw1I01dQZKGkuZkLeI8dTf/4nfomdyN55XjfLCYHlRYMPujT8HeKPsZF8/0A/r0Gsx/Aj1N4b88nHeQCyGjkk7QL4hG8r1ntH/KzTZg9xLRBwu/lmpBpB+1KNyWChSM7C3VEffxUVbgKTqvpb3mvJRV0HM+zEjLtaMRnUESeNJGTZYKwm3xb+RtNvF2O5LiiC3n8RGSk8oIh3Pj/BpSDHVgRNyMjfAYtFKbRVH9EQ4jSOILLbnZcHrfHnhAMkbIjF5rjWAmnICd8Bu0sYLVgJyQUDyMHPSMYImBk3jT8mZXg0wQ13RM03BwLf3ZOM5HViaqPStopUmN4W7W7KDrboLES68M+PkIhekowXEzMzO27AVfx2nNggNsET9GN826Gtz/PcSk86ammRFAdr4rG3ECI3QujeJ1pXWtvMj7HODT2kstio7o778Nk//hea0r0xr3CrJsb9h44EMDFkOfU6GNehp9cbyUUoucEQ7CALkG2Qs3LTF5rLgJAjaFdrr+R4Se78DdmEYR6rilpwkLSGohWJ01jY7SgEdDGAwHCLvLeZb+RNxaXyS6LPSsYwu1fYumw1IqEwsrfZQm8Z5nd+TQJml6fwHt7EB70ZFPSxHl7hfAmPyOQUGwJ//vVEsHNbs0nNz2tMQQLaBgaoxSrQPCKFTZ2wDjON+9zY2baDMdqq1BZum2W14m7pzWGYMFoOGkZenH3AEKh/pA6sUlCIQMlLYhpJ8qke5D1+bXISc8LhmBFKvSiRbyNQ90w0prr0LD5jEPW6tvw+lotncm/t2NK6vhOirPliKPnm5JWWEjaWSnvNpwyi7MwDv4QKVdVNTcziddf1PbbTZndguRJsF352+uRgX4TDM2KKhhLVs8yNUdjBoyj9vJ+5HiUtKYhDTU5xmhZ+7EtQGc7T/EOGqOop5GSvmhKmrhZ0TRuA+0cEEAo1Bm+IOEwrXlM6CQUwoXb1sLbYzHnkQFSpt2S+kowhOtvZNn79RgXwMWaqYh3fzhYTRfTO0hAZoQubFOcmePWFMbUM6l91ZS0wkKSit444bB7WOBbwf7acgtY2OFr9SNkvpfLgZvnlkbUdHrUIqJWbEelCU3ddxqjBfmQxu0Lshj2MT2bdJru1sTZ2LxCIVx4SEUhujviaw2LU43O+lZjCL5dCnHQabEtSDgkXlMjm4vbPlbUoP3ymuHFXEvRAbT9d+v8SKq45f2sMZr9jagVyQMGwoVDavVqf8VdayNroRA85wxmo/DhtRdZlU9J+m1fC4ZwS/TntHx0Ij9LY8qfGb7BBzBTWAJ5hR3OtFaoazVR4H4mNZuT0JgmF4fyXmKH7H3dlDRxuy1rLuAlFmKwzXx5HbXvj2WdbDK+BzWfijE6l/fRcRRTC0ZNJH3flNREUwtGTSTvAwAA///2y1mvAAAABklEQVQDALNzu4AFm6hAAAAAAElFTkSuQmCC]],
        },
    }

    local function mountBrandLogo(parent, size, accentColor, position, anchorPoint, zIndex)
        local icon = createCrownIcon(parent, size, accentColor, position, anchorPoint)

        task.spawn(function()
            local asset = loadAsset(MarkLogoAsset[1], MarkLogoAsset[2])

            if asset then
                if not parent.Parent then
                    return
                end
            else
                return
            end

            zIndex.Parent = parent
            zIndex.Image = asset

            createImage(zIndex)
            icon:Destroy()
        end)
    end
    local function createToggleSwitch(parent, width, height)
        local container, props = createFrame({
            Parent = parent,
            AnchorPoint = RightCenterAnchor,
            Position = RightMidPos,
            Size = fromOffset(width, height),
            BackgroundTransparency = 0.84,
            createCorner(),
        }), createFrame
        local entry1 = createFrame({
            Parent = container,
            Size = FullSize,
            createCorner(),
            createGradient(Palette.a1, Palette.a2),
        })

        props = {
            Parent = container,
            AnchorPoint = vector2New(0, 0.5),
        }
        props.Position = UDim2.new(0, 3, 0.5, 0)
        props.Size = fromOffset(height - 6, height - 6)
        props.ZIndex = 2
        props[1], props[2] = createCorner(), createStroke(0.6, color3FromRGB(0, 0, 0))

        local props2 = createSolidFrame(props)

        local function updateView(param1, param2)
            local count = param1 and 0 or 1
            local sizePos = UDim2.new(0, param1 and width - height + 3 or 3, 0.5, 0)

            if param2 then
                entry1.BackgroundTransparency = count
                props2.Position = sizePos

                return
            end

            tween(entry1, {BackgroundTransparency = count}, 0.26)
            tween(props2, {Position = sizePos}, 0.26)
        end

        return updateView
    end
    local function bindInputFocus(textBox, stroke, focusAlpha, restAlpha, onFocusLost)
        connectSignal(textBox.Focused, function()
            tween(stroke, {
                Transparency = focusAlpha,
                Color = Palette.a1,
            }, 0.2)
        end)
        connectSignal(textBox.FocusLost, function()
            tween(stroke, {
                Transparency = restAlpha,
                Color = Palette.wh,
            }, 0.25)

            if onFocusLost then
                onFocusLost()
            end
        end)
    end
    local function createSearchBox(parent, options)
        local stroke = createStroke(0.86)

        parent.BackgroundTransparency = parent.BackgroundTransparency or 0.92
        parent[1] = createCorner(9)
        parent[2] = stroke

        local props = {}

        props.Position = UDim2.new(0, 10, 0.5, -9)
        props.Size = fromOffset(18, 18)
        props.Image = 'search'
        props.ImageTransparency = 0.3
        parent[3] = createImage(props)
        parent.ClipsDescendants = true
        props = {}
        props.Parent = createFrame(parent)
        props.Position = fromOffset(35, 0)
        props.Size = UDim2.new(1, -43, 1, 0)
        props.PlaceholderText = options
        props.TextSize = 14
        props.ClipsDescendants = true
        parent = createTextBox(props)

        bindInputFocus(parent, stroke, 0.55, 0.86)

        return parent
    end

    local StatusColors = {}

    StatusColors.ok = Palette.mint
    StatusColors.warn = Palette.gold
    StatusColors.err = Palette.red

    local StatusIcons = {
        ok = 'ok',
        err = 'x',
        warn = 'warn',
    }

    local function getStatusStyle(kind)
        return StatusColors[kind] or Palette.sky, StatusIcons[kind] or 'info'
    end
    local function clearGuiObjects(container)
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA('GuiObject') then
                child:Destroy()
            end
        end
    end
    local function createStatController(cardRefs)
        return {
            Set = function(param1, key, param3)
                param1 = cardRefs[key]

                if param1 then
                    if param1.Text ~= param3 then
                        param1.Text = param3
                    end
                end
            end,
            Icon = function(imageLabel, key, param3)
                imageLabel = cardRefs[key] and cardRefs[key].Parent:FindFirstChildOfClass('ImageLabel')

                if imageLabel then
                    if imageLabel.Image ~= param3 then
                        imageLabel.Image, imageLabel.ImageColor3 = param3, IconIndex[param3] and Palette.a1 or color3FromRGB(255, 255, 255)
                    end
                end
            end,
        }
    end
    local function createDialogButton(parent, text, isPrimary, accentColor, onPress)
        local btnProps, corner = {Parent = parent}

        btnProps.Position = UDim2.new(isPrimary / accentColor, isPrimary * 8 / accentColor, 0, 0)
        btnProps.Size = UDim2.new(1 / accentColor, 8 / accentColor - 8, 1, 0)
        btnProps.BackgroundTransparency = onPress and 0 or 0.92
        corner, parent = createCorner(13), onPress and createGradient(Palette.a1, Palette.a2, 90)
        accentColor, isPrimary = parent or createStroke(0.84), onPress and createStroke(0.55, Palette.a1:Lerp(Palette.wh, 0.5))

        local current, props = isPrimary or nil, {
            Size = FullSize,
            Text = text,
            FontFace = FontBold,
            TextSize = 16,
        }

        props.TextColor3, props.TextXAlignment = onPress and Palette.on or Palette.wh, AlignCenterX
        btnProps[1], btnProps[2], btnProps[3], btnProps[4] = corner, accentColor, current, createLabel(props)
        onPress = createButton(btnProps)

        bindPressScale(onPress)

        return onPress
    end

    local Section = {}

    Section.__index = Section

    local function layoutSectionColumns(tab)
        if tab.bq then
            return
        elseif tab.done == #tab.list then
            return
        end

        tab.bq = true

        task.defer(function()
            tab.bq = false

            local items, current, list = {0, 0}, table.clone(tab.list), {}

            table.sort(current, function(param1, param2)
                return param1.card.AbsoluteSize.Y > param2.card.AbsoluteSize.Y
            end)

            local enabled, enabled2 = true, true

            for index, item in ipairs(current) do
                index = item.side or (items[1] <= items[2] and 1 or 2)

                if enabled then
                    local side = item.side

                    enabled = if side then item.side == 3 else not side
                end

                list[item] = index

                if index < 3 then
                    items[index] = items[index] + (item.card.AbsoluteSize.Y + 16)
                end

                enabled2 = enabled2 and item.card.AbsoluteSize.Y > 40
            end

            enabled = enabled and list[tab.list[1] ] == 2

            for key, value in next, list do
                value = enabled and value < 3 and 3 - value or value

                if key.card.Parent ~= tab.cols[value] then
                    key.card.Parent = tab.cols[value]
                end
            end

            if enabled2 then
                tab.done = #tab.list
            end
        end)
    end

    mountGui = function(param1)
        if not (pcall(function()
            param1.Parent = gethui()
        end)) then
            param1.Parent = getService('CoreGui')
        end
    end

    local mountWindow = Runtime.mountWindow

    -- ========================================================================
    -- 4. Window Component (Tabs, Home, Settings, Quick Bar, Configs, Dialogs)
    -- ========================================================================
    Venyx.Window = function(self, options2)
        options2 = options2 or {}

        local window = {Tabs = {}}
        local btnProps, props = options2.Key

        if btnProps then
            props = btnProps
        else
            props = Enum.KeyCode.RightControl
        end

        window.Key = props
        window.us = 1
        window.open = true

        local screenGui = mountWindow(window, tostring(options2.Id or 'Venyx'))

        window.Gui = screenGui

        local count, count2, labelProps = 832, 510

        window.dim = createFrame({
            Parent = screenGui,
            Size = FullSize,
            BackgroundColor3 = color3FromRGB(0, 0, 0),
        })

        pcall(function()
            window.dim.Interactable = false
        end)

        window.dz = 0.6

        local props2 = createFrame({
            Parent = screenGui,
            Active = true,
            ZIndex = 3,
            AnchorPoint = CenterAnchor,
            Position = CenterPos,
            Size = fromOffset(count, count2),
        })

        window.Main = props2

        local uIScale, props3 = newInstance('UIScale', {Parent = props2}), newInstance

        btnProps = {
            Parent = props2,
            Position = fromOffset(-3, -3),
        }
        btnProps.Size = UDim2.new(1, 6, 1, 6)
        btnProps.BackgroundTransparency = 1
        btnProps.Visible = false

        local canvas, props4 = newInstance('CanvasGroup', btnProps), createFrame
        local props5, props6 = createFrame({
            Parent = props2,
            Size = FullSize,
        }), createFrame

        window.bg = createFrame({
            Parent = props5,
            Size = FullSize,
            BackgroundTransparency = 0.05,
            createCorner(16),
            createGradient(Palette.w1, Palette.w2, 90),
        })
        window.tone = createFrame({
            Parent = props5,
            Size = FullSize,
            BackgroundColor3 = color3FromRGB(0, 0, 0),
            createCorner(16),
        })
        window.Tint = function(_self)
            local isMatch = State.Theme == 'Black' and color3FromRGB(0, 0, 0)

            window.bg:FindFirstChildOfClass('UIGradient').Color = ColorSequence.new(isMatch or Palette.w1, isMatch or Palette.w2)
        end
        window.Tone = function(_self, tonePercent)
            window.tone.BackgroundColor3 = tonePercent < 0 and Palette.wh or color3FromRGB(0, 0, 0)
            window.tone.BackgroundTransparency = 1 - math.abs(tonePercent) / 100 * (tonePercent < 0 and 0.22 or 0.65)
        end

        window:Tone(70)

        props6 = {Parent = props5}
        props6.Size = UDim2.new(1, 0, 0.55, 0)
        props6[1], props6[2] = createCorner(16), createAlphaGradient(90, {0, 0.86}, {1, 1})

        createSolidFrame(props6)

        props = {
            Parent = props5,
            Position = fromOffset(20, 1),
        }
        props.Size = UDim2.new(1, -40, 0, 1)
        props[1] = createAlphaGradient(0, {0, 1}, {0.5, 0.3}, {1, 1})

        createSolidFrame(props)

        props4, props6 = createStroke(0.7), createFrame

        createFrame({
            Parent = props5,
            Size = FullSize,
            ZIndex = 5,
            createCorner(16),
            props4,
        })

        local function updateView()
            local viewportSize, count3 = workspace.CurrentCamera.ViewportSize, UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and 0.88 or 1

            return math.clamp(math.min((viewportSize.X - 60) / count, (viewportSize.Y - 20) / count2), 0.55, 1.3) * window.us * count3
        end
        local function updateView2()
            if window.open then
                tween(uIScale, {
                    Scale = updateView(),
                }, 0.3)
            end
        end

        connectSignal(workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'), updateView2)

        window.SetScale = function(_self, newScale)
            window.us = newScale

            updateView2()
        end
        self = {
            Parent = screenGui,
            AnchorPoint = CenterAnchor,
        }
        self.Position = UDim2.new(0, 44, 0, 100 + window.slot * 60)
        self.Size = fromOffset(50, 50)
        self.BackgroundTransparency = 0.12
        self.BackgroundColor3 = Palette.bg
        self.Visible = false
        self[1], self[2] = createCorner(18), createStroke(0.75)

        local props7, button = createButton(self), newInstance
        local uiScale = newInstance('UIScale', {
            Parent = props7,
            Scale = 0,
        })

        props = {
            AnchorPoint = CenterAnchor,
            Position = CenterPos,
            Size = fromOffset(29, 28),
        }
        props.ScaleType = Enum.ScaleType.Fit
        props.ImageColor3 = Palette.tx

        mountBrandLogo(props7, 24, 30, CenterPos, CenterAnchor, props)

        local spring = createSpring(vector2New(), function(param1)
            props2.Position = UDim2.new(0.5, param1.X, 0.5, param1.Y)
        end)
        local spring2 = createSpring(vector2New(44, 100 + window.slot * 60), function(param1)
            props7.Position = UDim2.new(0, param1.X, 0, param1.Y)
        end)
        local current, props8, props9 = randomGuiName(), RunService, Enum

        button, self = Enum.RenderPriority.Camera.Value, function(param1)
            stepSpring(spring, param1)

            if props7.Visible then
                stepSpring(spring2, param1)
            end
        end

        RunService:BindToRenderStep(current, button + 1, self)

        btnProps = {Parent = props5}
        btnProps.Size = UDim2.new(1, 0, 0, TopBarHeight)
        btnProps.ClipsDescendants = true
        props9 = {}
        props9.Size = UDim2.new(1, 0, 1, 16)
        props9.BackgroundTransparency = 0.95
        props9[1] = createCorner(16)
        btnProps[1] = createFrame(props9)
        button = createButton(btnProps)

        createDivider(props5, fromOffset(0, TopBarHeight), UDim2.new(1, 0, 0, 1))

        props8, props4, props9 = UDim2.new(0, SidebarWidth / 2, 0.5, 0), {AnchorPoint = CenterAnchor}, UDim2.new
        props4.Position = UDim2.new(0, SidebarWidth / 2, 0.5, 0)
        props4.Size = fromOffset(25, 24)
        props4.ScaleType = Enum.ScaleType.Fit
        props4.ImageColor3 = Palette.tx

        mountBrandLogo(button, 21, 26, props8, CenterAnchor, props4)

        props8 = {
            Parent = button,
            Position = fromOffset(SidebarWidth + 6, 0),
        }
        props8.Size = UDim2.new(1, -SidebarWidth - 190, 1, 0)
        props8.ClipsDescendants = true
        props8[1] = createListLayout(10, nil, AlignCenterY, FillHorizontal)
        self = createFrame(props8)
        props8 = {Parent = self}
        props8.Size = UDim2.new(0, 0, 1, 0)
        props8.AutomaticSize = AutoSizeX
        props8.Text = (options2.Title or 'Venyx'):upper()
        props3 = nil
        props3, props8.FontFace = Enum, Font.new('rbxasset://fonts/families/Montserrat.json', Enum.FontWeight.Heavy)
        props8.TextSize = 22

        createLabel(props8)

        props = {
            Parent = self,
            LayoutOrder = 1,
        }
        props.Size = UDim2.new(0, 0, 1, 0)
        props.AutomaticSize = AutoSizeX
        props.Text = '/'
        props.TextSize = 13
        props.TextTransparency = 0.6

        createLabel(props)

        btnProps = {
            Parent = self,
            LayoutOrder = 2,
        }
        btnProps.Size = UDim2.new(0, 0, 1, 0)
        btnProps.AutomaticSize = AutoSizeX
        btnProps.Text = options2.Game or ''
        btnProps.TextSize = 13
        btnProps.TextTransparency = 0.3
        btnProps.TextTruncate = TruncateAtEnd
        btnProps[1] = newInstance('UISizeConstraint', {
            MaxSize = vector2New(170, 99),
        })

        local label = createLabel(btnProps)

        if options2.Version then
            createLabel({
                Parent = self,
                LayoutOrder = 3,
                Size = fromOffset(0, 20),
                AutomaticSize = AutoSizeX,
                Text = options2.Version,
                FontFace = FontBold,
                TextSize = 11,
                TextTransparency = 0.25,
                TextXAlignment = AlignCenterX,
                BackgroundTransparency = 0.9,
                createCorner(),
                createPadding(0, 8),
            })
        end

        local props10 = createSolidFrame({
            Size = fromOffset(7, 7),
            BackgroundColor3 = Palette.sky,
            createCorner(),
        })

        props9 = {
            Size = fromOffset(0, 22),
            AutomaticSize = AutoSizeX,
            TextSize = 11,
            FontFace = FontBold,
            TextColor3 = Palette.val,
            LayoutOrder = 1,
            TextTruncate = TruncateAtEnd,
        }
        props9[1] = newInstance('UISizeConstraint', {
            MaxSize = vector2New(270, 99),
        })

        local label2, btnProps2 = createLabel(props9), createFrame

        props3 = {
            Parent = self,
            LayoutOrder = 4,
            Size = fromOffset(0, 22),
            AutomaticSize = AutoSizeX,
            Visible = false,
            BackgroundTransparency = 0.9,
            BackgroundColor3 = Palette.sky,
        }
        props3[1], props3[2], props3[3], props3[4], props3[5] = createCorner(), createPadding(0, 10), createListLayout(6, nil, AlignCenterY, FillHorizontal), props10, label2

        local props11 = createFrame(props3)

        window.Status = function(_self, statusText, statusKind)
            local accentColor = getStatusStyle(statusKind)

            props11.Visible = statusText ~= nil and statusText ~= ''

            if label2.Text == statusText then
                if props10.BackgroundColor3 == accentColor then
                    return
                end
            end

            label2.Text = statusText or ''
            props10.BackgroundColor3 = accentColor
            props11.BackgroundColor3 = accentColor
        end

        if not options2.Game then
            task.spawn(function()
                local current2, current3 = pcall(getService('MarketplaceService').GetProductInfo, getService('MarketplaceService'), game.PlaceId)

                label.Text = current2 and current3 and current3.Name or ''
            end)
        end

        props6 = {
            Parent = button,
            AnchorPoint = RightCenterAnchor,
        }
        props6.Position = UDim2.new(1, -10, 0.5, 0)
        props6.Size = fromOffset(26, 26)
        props6.BackgroundTransparency = 0.92
        props6[1], props6[2], props6[3] = createCorner(9), createStroke(0.86), createIcon('minus', 18)
        self = createButton(props6)

        bindPressScale(self)

        props6 = {
            Parent = button,
            AnchorPoint = RightCenterAnchor,
        }
        props6.Position = UDim2.new(1, -44, 0.5, 0)
        props6.Size = fromOffset(128, 26)

        local searchBox, button2 = createSearchBox(props6, 'Search'), createFrame

        props4 = {
            Parent = props5,
            Position = fromOffset(0, TopBarHeight + 1),
        }
        props4.Size = UDim2.new(0, SidebarWidth, 1, -TopBarHeight - 1)
        props4.ClipsDescendants = true
        props9 = {
            Position = fromOffset(0, -16),
        }
        props9.Size = UDim2.new(1, 16, 1, 16)
        props9.BackgroundTransparency = 0.95
        props9[1] = createCorner(16)
        props4[1] = createFrame(props9)
        props9, btnProps2 = createFrame(props4), UDim2.new

        createDivider(props9, UDim2.new(1, -1, 0, 0), UDim2.new(0, 1, 1, 0))

        props6 = {
            Parent = props9,
            AnchorPoint = CenterAnchor,
        }
        props6.Position = UDim2.new(0.5, 0, 0, 29)
        props6.Size = fromOffset(38, 38)
        props6.BackgroundTransparency = 0.82
        props6[1], props6[2] = createCorner(12), createStroke(0.68)

        local props12, newInstance2 = createFrame(props6), newInstance
        local uiScale2 = newInstance('UIScale', {Parent = props12})

        props3 = {
            Parent = props9,
            ZIndex = 2,
            Position = fromOffset(0, 8),
        }
        props3.Size = UDim2.new(1, 0, 1, -60)
        props3.ScrollBarThickness = 0
        props3[1], props3[2] = createPadding(2, 0), createListLayout(4, AlignRightX)

        local scrollFrame = createScrollFrame(props3)

        props6 = {
            Parent = props9,
            AnchorPoint = vector2New(0.5, 1),
        }
        props6.Position = UDim2.new(0.5, 0, 1, -10)
        props6.Size = fromOffset(32, 32)
        props6.Image = getAvatarThumb(48)
        props6.BackgroundTransparency = 0
        props6.BackgroundColor3 = Palette.a2
        props6[1] = createCorner()

        createImage(props6)

        props3 = {
            Parent = props5,
            Position = fromOffset(SidebarWidth + 18, TopBarHeight + 9),
        }
        props3.Size = UDim2.new(1, -SidebarWidth - 36, 0, 26)
        props3.FontFace = FontBold
        props3.TextSize = 20

        local props13 = createLabel(props3)

        newInstance2 = {
            Parent = props5,
            Position = fromOffset(SidebarWidth, TopBarHeight + 41),
        }
        newInstance2.Size = UDim2.new(1, -SidebarWidth, 1, -TopBarHeight - 49)
        newInstance2.ClipsDescendants = true

        local container = createFrame(newInstance2)

        bindSpringDrag(button, spring, function(param1)
            local current2, bounds = workspace.CurrentCamera.ViewportSize, props2.AbsoluteSize
            local current3, current4 = current2.X / 2 + bounds.X / 2 - 90, current2.Y / 2 + bounds.Y / 2 - 60

            return vector2New(math.clamp(param1.X, -current3, current3), math.clamp(param1.Y, -current4, current4))
        end)

        local callbackFn = bindSpringDrag(props7, spring2, function(param1)
            local current2 = workspace.CurrentCamera.ViewportSize

            return vector2New(math.clamp(param1.X, 30, current2.X - 30), math.clamp(param1.Y, 30, current2.Y - 30))
        end)

        props8 = {
            Parent = props5,
            AnchorPoint = vector2New(1, 1),
        }
        props8.Position = UDim2.new(1, -3, 1, -3)
        props8.Size = fromOffset(22, 22)
        props8.ZIndex = 6
        props9, newInstance2 = createButton(props8), {
            {14, 11},
            {7, 16},
        }

        for _, item in ipairs(newInstance2) do
            createSolidFrame({
                Parent = props9,
                AnchorPoint = CenterAnchor,
                Position = fromOffset(item[2], item[2]),
                Size = fromOffset(item[1], 2),
                Rotation = -45,
                BackgroundTransparency = 0.4,
                ZIndex = 6,
                createCorner(),
            })
        end

        connectSignal(props9.InputBegan, function(input)
            if not (isPrimaryPointer(input)) then
                return
            end

            local position = input.Position
            local vec = vector2New(props2.Size.X.Offset, props2.Size.Y.Offset)
            local current2, current3 = uIScale.Scale
            local current4, new = spring.p - vec * current2 / 2

            new, props2.AnchorPoint, props2.Position = UDim2.new, vector2New(), UDim2.new(0.5, current4.X, 0.5, current4.Y)

            local function updateView3(param1)
                if param1 ~= input then
                    if param1.UserInputType ~= Enum.UserInputType.MouseMovement then
                        return
                    end
                end

                local current5, current6 = (param1.Position - position) / current2, workspace.CurrentCamera.ViewportSize / current2

                props2.Size = fromOffset(math.clamp(vec.X + current5.X, count, math.max(count, current6.X - 40)), math.clamp(vec.Y + current5.Y, count2, math.max(count2, current6.Y - 20)))
            end

            local current5 = UserInputService.InputChanged:Connect(updateView3)

            local function updateView4(param1)
                local isMatch, isMatch2 = param1 == input

                if isMatch then
                    isMatch2 = isMatch
                else
                    isMatch2 = param1.UserInputType == Enum.UserInputType.MouseButton1
                end
                if isMatch2 then
                    current5:Disconnect()
                    current3:Disconnect()

                    isMatch = current4 + vector2New(props2.Size.X.Offset, props2.Size.Y.Offset) * current2 / 2
                    props2.AnchorPoint = CenterAnchor
                    spring.t = isMatch
                    spring.p = isMatch

                    spring.a(isMatch)
                end
            end

            current3 = UserInputService.InputEnded:Connect(updateView4)
        end)

        local count3 = 0

        window.Show = function(self2, visible)
            window.open = visible

            count3 += 1

            local current2 = count3

            self2 = updateView()

            if props5.Parent ~= canvas then
                local new

                new, props5.Position, props5.Size = UDim2.new, fromOffset(3, 3), UDim2.new(1, -6, 1, 
-6)
                props5.Parent = canvas
                canvas.GroupTransparency = visible and 1 or 0
            end

            uIScale.Scale = self2
            canvas.Visible = true
            props2.Visible = true

            local dim, stateMap = window.dim, {}

            stateMap.BackgroundTransparency = visible and 1 - window.dz or 1

            tween(dim, stateMap, 0.3)
            tween(canvas, {
                GroupTransparency = visible and 0 or 1,
            }, visible and 0.28 or 0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            task.delay(visible and 0.3 or 0.2, function()
                if count3 ~= current2 then
                    return
                end

                canvas.Visible = false
                props5.Position = UDim2.new()
                props5.Size = FullSize
                props5.Parent = props2

                if not visible then
                    props2.Visible = false
                end
            end)

            if props7.Visible then
                uiScale.Scale = 0.85

                tween(uiScale, {Scale = 1}, 0.3, EaseBack)
            else
                props7.Visible = true
                uiScale.Scale = 0

                tween(uiScale, {Scale = 1}, 0.4, EaseBack)
            end
        end

        onClick(self, function()
            window:Show(false)
        end)
        onClick(props7, function()
            if not (callbackFn()) then
                window:Show(not window.open)
            end
        end)
        connectSignal(UserInputService.InputBegan, function(input, gameProcessed)
            if not gameProcessed then
                if input.KeyCode == window.Key then
                    window:Show(not window.open)
                end
            end
        end)

        local button3 = createButton({
            Parent = props5,
            Size = FullSize,
            BackgroundColor3 = color3FromRGB(5, 6, 16),
            ZIndex = 20,
            Visible = false,
            ClipsDescendants = true,
            createCorner(16),
        })

        btnProps2 = {Parent = button3}
        btnProps2.AnchorPoint = TopRightAnchor
        btnProps2.Position = UDim2.new(1, 420, 0, 6)
        btnProps2.Size = UDim2.new(0, 390, 1, -12)
        btnProps2.BackgroundTransparency = 0.02
        btnProps2.BackgroundColor3 = Palette.pn
        btnProps2[1], btnProps2[2] = createCorner(14), createStroke(0.84)

        local props14 = createButton(btnProps2)

        labelProps = {
            Parent = props14,
            Position = fromOffset(18, 14),
        }
        labelProps.Size = UDim2.new(1, -80, 0, 20)
        labelProps.FontFace = FontBold
        labelProps.TextSize = 15

        local label3 = createLabel(labelProps)

        props8 = {
            Parent = props14,
            Position = fromOffset(18, 34),
        }
        props8.Size = UDim2.new(1, -80, 0, 14)
        props8.TextSize = 11
        props8.TextTransparency = 0.32

        local label4, btnProps3, new = createLabel(props8), {Parent = props14}, TopRightAnchor

        btnProps3.AnchorPoint = TopRightAnchor
        btnProps3.Position = UDim2.new(1, -12, 0, 10)
        btnProps3.Size = fromOffset(40, 40)
        btnProps3.BackgroundTransparency = 0.92
        btnProps3[1], btnProps3[2] = createCorner(12), createIcon('x', 22)
        button2, btnProps2, new = createButton(btnProps3), {
            Parent = props14,
            Position = fromOffset(14, 60),
        }, UDim2.new
        btnProps2.Size = UDim2.new(1, -28, 0, 40)
        btnProps2.BackgroundTransparency = 0.93

        local searchBox2 = createSearchBox(btnProps2, 'Filter')

        props8, props6, btnProps, props, props4 = {
            Parent = props14,
            Position = fromOffset(12, 108),
        }, createPadding(3), newInstance, {}, UDim2.new
        props.CellSize = UDim2.new(0.5, -5, 0, 44)
        props.CellPadding = fromOffset(8, 8)
        props.SortOrder = Enum.SortOrder.LayoutOrder
        props8[1], props8[2] = props6, newInstance('UIGridLayout', props)

        local props15 = createScrollFrame(props8)

        self = {
            Parent = props14,
            AnchorPoint = vector2New(0, 1),
        }
        self.Position = UDim2.new(0, 14, 1, -14)
        self.Size = UDim2.new(1, -28, 0, 44)

        local container2 = createFrame(self)

        props4, button, new = createDialogButton(container2, 'Default', 0, 3), createDialogButton(container2, 'Clear', 1, 3), createDialogButton(container2, 'Select all', 2, 3, true)
        window.Dialog = function(_self, dialogOpts)
            local current2 = dialogOpts or {}

            if window.dlg then
                window.dlg.Close()
            end
            if not window.open then
                window:Show(true)
            end

            local accentColor, iconName = getStatusStyle(current2.Kind)
            local uiScale3 = newInstance('UIScale', {Scale = 0.9})
            local button4 = createButton({
                Parent = props5,
                Size = FullSize,
                BackgroundColor3 = color3FromRGB(5, 6, 16),
                ZIndex = 30,
                createCorner(16),
            })
            local props16, corner, stroke, padding, current3 = {
                Parent = button4,
                AnchorPoint = CenterAnchor,
                Position = CenterPos,
                Size = fromOffset(400, 0),
                AutomaticSize = AutoSizeY,
                BackgroundTransparency = 0.02,
                BackgroundColor3 = Palette.pn,
            }, createCorner(18), createStroke(0.8), createPadding(22), createListLayout
            local listLayout, props17, props18, _unused = createListLayout(16), createFrame, {}, UDim2.new

            props18.Size = UDim2.new(1, 0, 0, 46)

            local container3, labelProps2, _unused2 = createFrame({
                Size = fromOffset(46, 46),
                BackgroundTransparency = 0.8,
                BackgroundColor3 = accentColor,
                createCorner(14),
                createIcon(current2.Icon or iconName, 24, accentColor),
            }), {
                Position = fromOffset(60, 0),
            }, UDim2.new

            labelProps2.Size = UDim2.new(1, -60, 1, 0)
            labelProps2.Text = current2.Title or ''
            labelProps2.FontFace = FontBold
            labelProps2.TextSize = 17
            labelProps2.TextWrapped = true
            props18[1], props18[2] = container3, createLabel(labelProps2)
            props16[1], props16[2], props16[3], props16[4], props16[5], props16[6] = corner, stroke, padding, listLayout, uiScale3, createFrame(props18)

            local button5 = createButton(props16)

            if current2.Text then
                createLabel({
                    Parent = button5,
                    LayoutOrder = 1,
                    Size = FullWidth,
                    AutomaticSize = AutoSizeY,
                    Text = current2.Text,
                    TextSize = 13,
                    TextTransparency = 0.25,
                    TextWrapped = true,
                })
            end

            props17 = {
                Parent = button5,
                LayoutOrder = 2,
            }
            props17.Size = UDim2.new(1, 0, 0, 42)

            local container4, dialog = createFrame(props17), {}

            dialog.Close = function(self2)
                if window.dlg == dialog then
                    window.dlg = nil
                end

                tween(uiScale3, {Scale = 0.92}, 0.18)

                local activeTween, callbackFn2 = tween(button4, {BackgroundTransparency = 1}, 0.2), function(
                )
                    button4:Destroy()
                end

                activeTween.Completed:Connect(callbackFn2)

                button5.Visible = false

                safeCall(self2)
            end
            container3 = current2.Buttons or {
                {
                    'OK',
                },
            }

            for index, item in ipairs(container3) do
                current3, props17, padding = item[1], index - 1, #container3
                accentColor, corner = createDialogButton(container4, current3, props17, padding, item[3]), function(
                )
                    if isCleanTap() then
                        dialog.Close(item[2])
                    end
                end

                accentColor.Activated:Connect(corner)
            end

            local function updateView3()
                if current2.Cancel ~= false then
                    dialog.Close(current2.Cancel)
                end
            end

            button4.Activated:Connect(updateView3)

            window.dlg = dialog

            tween(button4, {BackgroundTransparency = 0.45}, 0.2)
            tween(uiScale3, {Scale = 1}, 0.35, EaseBack)

            return dialog
        end

        local function updateView3(param1, param2, param3, param4, param5, param6)
            window:Dialog({
                Title = param1,
                Text = param2,
                Kind = param3,
                Buttons = {
                    {
                        param6 or 'Cancel',
                    },
                    {param4, param5, true},
                },
            })
        end
        local function updateView4()
            Venyx:Save()
            Venyx:Notify('Config saved', State.Active, 'ok')
        end
        local function updateView5(param1, param2)
            Venyx:Notify(param2, param1 or '', pcall(setclipboard, param1) and 'ok' or 'err')
        end

        bindPressScale(button2)

        local items2 = {
            bt = {},
            sel = {},
        }

        local function updateView6()
            items2.open = false

            tween(button3, {BackgroundTransparency = 1}, 0.22)

            local props16, current2 = {}

            props16.Position = UDim2.new(1, 540, 0, 6)
            current2 = Enum

            hideOnTweenDone(tween(props14, props16, 0.28, EaseQuint, current2.EasingDirection.In), button3, function(
            )
                return items2.open
            end)
        end
        local function updateView7()
            for key, value in next, items2.bt do
                local isMatch = items2.sel[key] ~= nil

                tween(value[1], {
                    BackgroundTransparency = isMatch and 0.72 or 0.93,
                    BackgroundColor3 = isMatch and Palette.a1 or Palette.wh,
                }, 0.18)
                tween(value[2], {
                    Transparency = isMatch and 0.2 or 0.82,
                    Color = isMatch and Palette.a1:Lerp(Palette.wh, 0.35) or Palette.wh,
                }, 0.18)

                local current2, props16 = value[3], {}

                props16.ImageTransparency = isMatch and 0 or 1

                tween(current2, props16, 0.18)
            end
        end
        local function updateView8()
            updateView7()

            local list = {}

            for _, item in ipairs(items2.o) do
                if items2.sel[item] then
                    list[#list + 1] = item
                end
            end

            safeCall(items2.d, list)
        end

        window.Sync = function(_self, control)
            if items2.open then
                if not (items2.ob == control) then
                    return
                end
            else
                return
            end

            items2.sel = {}

            for _, item in ipairs(control.Multi and control.Value or {
                control.Value,
            }) do
                items2.sel[item] = true
            end

            updateView7()
        end
        window.Pick = function(
            self2,
            title,
            optionsList,
            currentVal,
            isMulti,
            onPick,
            defaultVal,
            control
        )
            items2.ob = control
            label3.Text = title
            label4.Text = isMulti and 'Pick any' or 'Pick one'
            searchBox2.Text = ''

            clearGuiObjects(props15)

            title = defaultVal or {}
            items2.bt = {}
            items2.sel = {}
            items2.d = onPick
            items2.o = {}
            items2.def = title

            for _, item in ipairs(isMulti and currentVal or {currentVal}) do
                items2.sel[item] = true
            end

            currentVal, control = type(optionsList[1]) == 'table'
            control, props15:FindFirstChildOfClass('UIGridLayout').CellSize = UDim2.new, UDim2.new(0.5, 
-5, 0, currentVal and 54 or 44)
            props14.Size = UDim2.new(0, currentVal and 500 or 390, 1, -12)

            for index, item2 in ipairs(optionsList) do
                local current2 = currentVal and item2.v or item2

                items2.o[index] = current2
                defaultVal, control = createStroke(0.82), createFrame
                self2 = createFrame({
                    Parent = props15,
                    LayoutOrder = index,
                })
                index = createButton({
                    Parent = self2,
                    AnchorPoint = CenterAnchor,
                    Position = CenterPos,
                    Size = FullSize,
                    BackgroundTransparency = 0.93,
                    createCorner(13),
                    defaultVal,
                })

                if currentVal then
                    local container3, props16, props17, stroke, labelProps2, labelProps3 = createFrame, {
                        Parent = index,
                        Position = fromOffset(5, 5),
                        Size = fromOffset(44, 44),
                        BackgroundTransparency = 0.72,
                        BackgroundColor3 = item2.col or Palette.a1,
                    }, createCorner(12), createStroke(0.6, item2.col), {
                        AnchorPoint = CenterAnchor,
                        Position = CenterPos,
                    }, UDim2.new

                    labelProps2.Size = UDim2.new(1, 2, 1, 2)
                    labelProps2.Image = item2.img or ''
                    labelProps2.ScaleType = Enum.ScaleType.Fit
                    props16[1], props16[2], props16[3] = props17, stroke, rawImageLabel(labelProps2)

                    createFrame(props16)

                    labelProps3 = {
                        Parent = index,
                        Position = fromOffset(56, 3),
                    }
                    labelProps3.Size = UDim2.new(1, -60, 0, 28)
                    labelProps3.Text = item2.t or tostring(current2)
                    labelProps3.FontFace = FontExtraBold
                    labelProps3.TextSize = 17
                    labelProps3.TextTruncate = TruncateAtEnd

                    createLabel(labelProps3)

                    props17, labelProps3 = {
                        Parent = index,
                        Position = fromOffset(57, 32),
                    }, UDim2.new
                    props17.Size = UDim2.new(1, -90, 0, 17)
                    props17.ClipsDescendants = true
                    stroke = createListLayout
                    props17[1] = createListLayout(6, nil, AlignCenterY, FillHorizontal)
                    container3 = createFrame(props17)
                    props16, labelProps2 = {Parent = container3}, UDim2.new
                    props16.Size = UDim2.new(0, 0, 1, 0)
                    props16.AutomaticSize = AutoSizeX
                    props16.Text = (item2.sub or ''):upper()
                    props16.FontFace = FontDisplay
                    props16.TextSize = 12.5
                    props16.TextColor3 = item2.grad and Palette.wh or item2.col or Palette.val
                    props17 = newInstance
                    props16[1] = newInstance('UIStroke', {
                        Thickness = 1.2,
                        Color = color3FromRGB(0, 0, 0),
                    })

                    local label5 = createLabel(props16)

                    if item2.grad then
                        item2.grad:Clone().Parent = label5
                    end
                    if item2.note then
                        labelProps2, props16 = {
                            Parent = container3,
                            LayoutOrder = 1,
                        }, UDim2.new
                        labelProps2.Size = UDim2.new(1, -6, 1, 0)
                        labelProps2.Text = item2.note
                        labelProps2.FontFace = FontBold
                        labelProps2.TextSize = 12.5
                        labelProps2.RichText = true
                        labelProps2.TextTruncate = TruncateAtEnd
                        stroke = newInstance
                        labelProps2[1] = newInstance('UIStroke', {
                            Thickness = 1.2,
                            Color = color3FromRGB(0, 0, 0),
                        })

                        local props18 = createLabel(labelProps2)

                        local function updateView9()
                            props18.Size = UDim2.new(1, -label5.AbsoluteSize.X - 6, 1, 0)
                        end

                        label5:GetPropertyChangedSignal('AbsoluteSize'):Connect(updateView9)
                        updateView9()
                    end
                else
                    local labelProps2, _unused = {
                        Parent = index,
                        Position = fromOffset(14, 0),
                    }, UDim2.new

                    labelProps2.Size = UDim2.new(1, -40, 1, 0)
                    labelProps2.Text = tostring(current2)
                    labelProps2.FontFace = FontBold
                    labelProps2.TextSize = 12
                    labelProps2.TextWrapped = true
                    labelProps2.LineHeight = 0.95

                    createLabel(labelProps2)
                end

                local current3, list, props16, sizePos = items2.bt, {}, {
                    Parent = index,
                    AnchorPoint = currentVal and vector2New(1, 1) or RightCenterAnchor,
                }

                if currentVal then
                    local _ = UDim2.new

                    sizePos = (UDim2.new(1, -9, 1, -8))
                else
                    sizePos = currentVal
                end

                local sizePos2

                if sizePos then
                    sizePos2 = sizePos
                else
                    local _ = UDim2.new

                    sizePos2 = (UDim2.new(1, -12, 0.5, 0))
                end

                props16.Position = sizePos2
                props16.Size = fromOffset(18, 18)
                props16.Image = 'check'
                props16.ImageTransparency = 1
                list[1], list[2], list[3], list[4], list[5] = index, defaultVal, createImage(props16), self2, (tostring(current2) .. ' ' .. (currentVal and (item2.t or '') .. ' ' .. (item2.sub or '') .. ' ' .. (item2.note or '') or '')):lower()
                current3[current2] = list

                bindPressScale(index, 0.95)
                onClick(index, function()
                    if isMulti then
                        local sel, current4 = items2.sel, items2.sel[current2]

                        sel[current2] = if current4 then nil else not current4

                        updateView8()
                    else
                        items2.sel = {[current2] = true}

                        updateView7()
                        updateView6()
                        safeCall(onPick, current2)
                    end
                end)
            end

            container2.Visible = isMulti == true
            props15.Size = UDim2.new(1, -24, 1, isMulti and -176 or -120)

            updateView7()

            items2.open = true
            button3.Visible = true

            tween(button3, {BackgroundTransparency = 0.45}, 0.25)

            control = {}
            control.Position = UDim2.new(1, -6, 0, 6)

            tween(props14, control, 0.45)
        end

        connectSignal(searchBox2:GetPropertyChangedSignal('Text'), function()
            local current2 = searchBox2.Text:lower()

            for _, value in next, items2.bt do
                value[4].Visible = value[5]:find(current2, 1, true) ~= nil
            end
        end)
        onClick(button2, updateView6)
        onClick(button3, updateView6)

        local function updateView9(param1)
            items2.sel = {}

            for _, item in ipairs(param1) do
                items2.sel[item] = true
            end

            updateView8()
        end

        onClick(props4, function()
            updateView9(items2.def)
        end)
        onClick(button, function()
            updateView9({})
        end)
        onClick(new, function()
            updateView9(items2.o)
        end)

        local function updateView10(param1)
            return 29 + (param1.i - 1) * 42 - scrollFrame.CanvasPosition.Y
        end

        connectSignal(scrollFrame:GetPropertyChangedSignal('CanvasPosition'), function()
            if window.Cur then
                props12.Position = UDim2.new(0.5, 0, 0, updateView10(window.Cur))
            end
        end)

        local function updateView11(param1, container3, props16)
            local container4, props17, props18 = nil, {
                Parent = container3,
                LayoutOrder = props16,
                Size = FullWidth,
                AutomaticSize = AutoSizeY,
            }

            props17[1] = createListLayout(16)
            container3, props18 = createFrame(props17), createFrame
            props16 = {
                Parent = container3,
                LayoutOrder = 1,
                Size = FullWidth,
                AutomaticSize = AutoSizeY,
            }
            props16[1] = createListLayout(16, nil, nil, FillHorizontal)
            container4 = createFrame(props16)
            param1.cols = {}
            param1.list = {}
            param1.crow = container3

            for index = 1, 2, 1 do
                local cols, props19, _unused, current2 = param1.cols, {
                    Parent = container4,
                    LayoutOrder = index,
                }, UDim2.new

                props19.Size, props19.AutomaticSize, current2 = UDim2.new(0.5, -8, 0, 0), AutoSizeY, createListLayout
                props19[1] = createListLayout(16)
                cols[index] = createFrame(props19)
            end

            local cols, props19 = param1.cols, {
                Parent = container3,
                LayoutOrder = 2,
            }

            props19.Size, props19.AutomaticSize, props19.Visible, listLayout = UDim2.new(0.5, -8, 0, 0), AutoSizeY, false, createListLayout
            props19[1] = createListLayout(16)
            cols[3] = createFrame(props19)
            props17, props18 = param1.cols, {
                Parent = container3,
                LayoutOrder = 0,
                Size = FullWidth,
                AutomaticSize = AutoSizeY,
                Visible = false,
            }
            props18[1] = createListLayout(16)
            props17[4] = createFrame(props18)
        end
        local function updateView12(param1, param2)
            local chip = param1.on and param1.on.chip

            if chip then
                if chip.AbsoluteSize.X == 0 then
                    return
                end
            else
                return
            end

            local props16 = {
                Position = fromOffset((chip.AbsolutePosition.X - param1.row.AbsolutePosition.X) / uIScale.Scale, 0),
                Size = fromOffset(chip.AbsoluteSize.X / uIScale.Scale, 24),
            }

            if param2 then
                param1.hl.Position, param1.hl.Size = props16.Position, props16.Size
            else
                tween(param1.hl, props16, 0.38)
            end
        end
        local function updateView13(param1, param2)
            if param1.on == param2 then
                return
            end

            param1.on = param2

            for _, item in ipairs(param1.subs) do
                local chip, stateMap = item.chip, {}

                stateMap.TextTransparency = item == param2 and 0 or 0.5

                tween(chip, stateMap, 0.2)
            end

            updateView12(param1)
        end
        local function updateView14(param1)
            if os.clock() < (param1.lock or 0) then
                return
            end

            local current2, current3, current4, current5 = uIScale.Scale, param1.sc.AbsolutePosition.Y, param1.sc.AbsoluteCanvasSize.Y - param1.sc.AbsoluteWindowSize.Y, param1.subs[1]

            for _, item in ipairs(param1.subs) do
                current5 = if item.g.AbsolutePosition.Y - current3 <= 40 * current2 then item else current5
            end

            updateView13(param1, if current4 > 0 then if param1.sc.CanvasPosition.Y >= current4 - 2 then param1.subs[#param1.subs]else current5 else current5)
        end
        local function updateView15(param1, param2, param3)
            local current2 = param1.CanvasPosition.Y + param2.AbsolutePosition.Y - param1.AbsolutePosition.Y - param3 * uIScale.Scale

            tween(param1, {
                CanvasPosition = vector2New(0, math.clamp(current2, 0, math.max(0, param1.AbsoluteCanvasSize.Y - param1.AbsoluteWindowSize.Y))),
            }, 0.45)
        end
        local function updateView16(param1, param2)
            param1.lock = os.clock() + 0.5

            updateView15(param1.sc, param2.g, 4)
            updateView13(param1, param2)
        end

        window.Select = function(self2, tab)
            local cur = window.Cur

            if cur == tab then
                return
            end

            searchBox.Text = ''
            window.Cur = tab

            for index, value in ipairs(tab.subs or {}) do
                layoutSectionColumns(value)
            end

            if tab.list then
                layoutSectionColumns(tab)
            end

            for index, item in ipairs(window.Tabs) do
                if item.bar then
                    item.bar.Visible = item == tab

                    task.defer(updateView12, item, true)
                end

                self2, index = item.im, {}
                index.ImageTransparency = item == tab and 0 or 0.45

                tween(self2, index, 0.3)
            end

            local props16, isMatch = {}

            props16.Position = UDim2.new(0.5, 0, 0, updateView10(tab))

            tween(props12, props16, 0.42)

            uiScale2.Scale = 0.86

            tween(uiScale2, {Scale = 1}, 0.5, EaseBack)

            isMatch = cur and (cur.i > tab.i and -1 or 1) or 0

            if cur then
                cur.k = cur.k + 1

                local current2 = cur.k
                local current3, props17 = cur.fr, {}

                props17.Position = UDim2.new(-isMatch, 0, 0, 0)

                hideOnTweenDone(tween(current3, props17, 0.5), cur.fr, function()
                    return cur.k ~= current2 or window.Cur == cur
                end)
            end

            tab.k = tab.k + 1

            if not tab.fr.Visible then
                self2 = nil
                self2, tab.fr.Position = UDim2.new, UDim2.new(isMatch, 0, 0, 0)
            end

            tab.fr.Visible = true

            local current2, props17 = tab.fr, {}

            props17.Position = UDim2.new()

            tween(current2, props17, 0.5)

            props13.Text = tab.Title or tab.Name
            props13.Position = fromOffset(SidebarWidth + 18 + isMatch * 24, TopBarHeight + 9)
            props13.TextTransparency = 0.7

            tween(props13, {
                Position = fromOffset(SidebarWidth + 18, TopBarHeight + 9),
                TextTransparency = 0,
            }, 0.45)
        end
        window.nest = {}
        window.Grip = function(self2, section, tab)
            local function updateView17()
                return section.AbsoluteCanvasSize.Y / math.max(section.AbsoluteWindowSize.Y, 1)
            end

            local btnProps4, items = {Parent = tab}

            btnProps4.AnchorPoint = TopRightAnchor
            btnProps4.Position = UDim2.new(1, 0, 0, 0)
            btnProps4.Size = UDim2.new(0, 14, 1, 0)
            btnProps4.ZIndex = 8
            btnProps4.Visible = not UserInputService.TouchEnabled
            self2, tab, items = createButton(btnProps4), setmetatable, {
                __index = function()
                    return vector2New(0, section.CanvasPosition.Y / updateView17())
                end,
                __newindex = function(_self, _unused, param3)
                    window.goal = math.clamp(param3.Y * updateView17(), 0, math.max(0, section.AbsoluteCanvasSize.Y - section.AbsoluteWindowSize.Y))
                    window.gf = section
                    section.CanvasPosition = vector2New(0, window.goal)
                end,
            }

            bindSpringDrag(self2, tab({}, items), function(param1)
                return param1
            end)
        end
        window.Tab = function(_self, title, icon, isPlainPage)
            local tab = {
                Name = title,
                W = window,
                Secs = {},
            }

            tab.i = #window.Tabs + 1
            tab.k = 0
            tab.top = tab
            tab.fr = createFrame({
                Parent = container,
                Size = FullSize,
                Visible = false,
            })

            if isPlainPage then
                tab.sc = createFrame({
                    Parent = tab.fr,
                    Size = FullSize,
                    createPadding(6, 16, 6),
                })
            else
                local props16 = {
                    Parent = tab.fr,
                    Size = FullSize,
                    ScrollingEnabled = UserInputService.TouchEnabled,
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = Palette.wh,
                    ScrollBarImageTransparency = 0.7,
                }

                props16.ElasticBehavior = Enum.ElasticBehavior.Always
                props16[1], props16[2] = createPadding(4, 0, 12), createListLayout(12, AlignRightX)
                tab.sc = createScrollFrame(props16)

                local props17 = {
                    Parent = tab.sc,
                }

                props17.Size = UDim2.new(1, -36, 0, 0)
                props17.AutomaticSize = AutoSizeY
                tab.g = createFrame(props17)

                connectSignal(tab.sc.InputChanged, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseWheel then
                        window:Wheel(input.Position.Z)
                    end
                end)
                window:Grip(tab.sc, tab.fr)
                connectSignal(tab.sc.MouseWheelForward, function()
                    window:Wheel(1)
                end)
                connectSignal(tab.sc.MouseWheelBackward, function()
                    window:Wheel(-1)
                end)
                updateView11(tab, tab.g, 0)

                tab.subs = {}
            end

            local tabBtn = createButton({
                Parent = scrollFrame,
                Size = fromOffset(38, 38),
                LayoutOrder = tab.i,
            })
            tab.im = createImage({
                Parent = tabBtn,
                AnchorPoint = CenterAnchor,
                Position = CenterPos,
                Size = fromOffset(24, 24),
                Image = icon or 'grid',
                ImageTransparency = 0.45,
            })

            bindPressScale(tab.im, 0.8, tabBtn, function(param1)
                if window.Cur == tab then
                    tween(uiScale2, {
                        Scale = param1 and 0.9 or 1,
                    }, param1 and 0.12 or 0.45, param1 and EaseQuint or EaseBack)
                end
            end)
            onClick(tabBtn, function()
                window:Select(tab)
            end)

            window.Tabs[tab.i] = tab
            tab.Section = function(_self, title2, icon2, column)
                return Section.new(tab, title2, icon2, column)
            end
            tab.Arrange = function(self2, groups)
                for index, item in ipairs(groups) do
                    for index2, item2 in ipairs(item) do
                        for _, item3 in ipairs(self2.Secs) do
                            if item3.name == item2 then
                                item3.side, item3.card.LayoutOrder = index, index2
                            end
                        end
                    end
                end

                self2.done = -1

                layoutSectionColumns(self2)
            end
            tab.Sub = function(_self, subTitle)
                local tab2 = {}

                tab2.Name = title .. ' / ' .. subTitle
                tab2.W = window
                tab2.Secs = tab.Secs
                tab2.i = #tab.subs + 1
                tab2.sc = tab.sc
                tab2.top = tab

                if #tab.subs == 0 then
                    tab.g.Visible = #tab.Secs > 0

                    local props16, props17 = nil, {Parent = props5}

                    props17.AnchorPoint = TopRightAnchor
                    props17.Position = UDim2.new(1, -18, 0, TopBarHeight + 7)
                    props17.Size = fromOffset(0, 30)
                    props17.AutomaticSize = AutoSizeX
                    props17.Visible = window.Cur == tab
                    props17.BackgroundTransparency = 0.95
                    props17[1], props17[2], props17[3] = createCorner(), createStroke(0.88), createPadding(3)
                    tab.bar = createFrame(props17)
                    tab.hl = createFrame({
                        Parent = tab.bar,
                        Size = fromOffset(0, 24),
                        BackgroundTransparency = 0.84,
                        createCorner(),
                    })
                    props16 = {
                        Parent = tab.bar,
                        Size = fromOffset(0, 24),
                        AutomaticSize = AutoSizeX,
                        ZIndex = 2,
                    }
                    props16[1] = createListLayout(4, nil, AlignCenterY, FillHorizontal)
                    tab.row = createFrame(props16)

                    connectSignal(tab.row:GetPropertyChangedSignal('AbsoluteSize'), function()
                        updateView12(tab, true)
                    end)
                    connectSignal(tab.sc:GetPropertyChangedSignal('CanvasPosition'), function()
                        updateView14(tab)
                    end)
                end

                local btnProps4, labelProps2 = {}

                btnProps4.Size = UDim2.new(1, 0, 0, 18)
                labelProps2 = {}
                labelProps2.Size = UDim2.new(1, -30, 1, 0)
                labelProps2.Text = subTitle:upper()
                labelProps2.FontFace = FontExtraBold
                labelProps2.TextSize = 12
                labelProps2.TextTransparency = 0.35
                btnProps4[1] = createLabel(labelProps2)
                labelProps2 = createButton(btnProps4)
                btnProps4 = {
                    Parent = labelProps2,
                    AnchorPoint = CenterAnchor,
                }
                btnProps4.Position = UDim2.new(1, -9, 0.5, 0)
                btnProps4.Size = fromOffset(13, 13)
                btnProps4.Image = 'down'
                btnProps4.ImageTransparency = 0.55

                local image = createImage(btnProps4)

                btnProps4 = {
                    Parent = tab.sc,
                    LayoutOrder = tab2.i,
                }
                btnProps4.Size = UDim2.new(1, -36, 0, 0)
                btnProps4.AutomaticSize = AutoSizeY
                btnProps4[1], btnProps4[2] = createListLayout(12), labelProps2
                tab2.g = createFrame(btnProps4)

                updateView11(tab2, tab2.g, 1)
                onClick(labelProps2, function()
                    tab2.crow.Visible = not tab2.crow.Visible

                    tween(image, {
                        Rotation = tab2.crow.Visible and 0 or -90,
                    }, 0.25)
                end)

                tab2.chip = createButton({
                    Parent = tab.row,
                    LayoutOrder = tab2.i,
                    Size = fromOffset(0, 24),
                    AutomaticSize = AutoSizeX,
                    Text = subTitle,
                    FontFace = FontBold,
                    TextSize = 12,
                    TextColor3 = Palette.wh,
                    TextTransparency = 0.5,
                    BackgroundTransparency = 1,
                    createCorner(),
                    createPadding(0, 12),
                })

                onClick(tab2.chip, function()
                    updateView16(tab, tab2)
                end)

                tab2.Go = function(_self)
                    if not window.open then
                        window:Show(true)
                    end

                    window:Select(tab)
                    task.delay(0.15, updateView16, tab, tab2)
                end
                tab.subs[tab2.i] = tab2
                tab2.Section = function(_self, title2, icon2, column)
                    return Section.new(tab2, title2, icon2, column)
                end
                tab2.Arrange = tab.Arrange

                if tab2.i == 1 then
                    updateView13(tab, tab2)
                end

                return tab2
            end

            if not window.Cur then
                window:Select(tab)
            end

            return tab
        end
        window.All = {}
        props6 = {Parent = props5}
        props6.AnchorPoint = TopRightAnchor
        props6.Position = UDim2.new(1, -44, 0, TopBarHeight - 4)
        props6.Size = fromOffset(300, 0)
        props6.AutomaticSize = AutoSizeY
        props6.Visible = false
        props6.ZIndex = 15
        props6.BackgroundTransparency = 0.02
        props6.BackgroundColor3 = Palette.pn
        props6[1], props6[2], props6[3], props6[4] = createCorner(12), createStroke(0.82), createPadding(6), createListLayout(2)

        local container3 = createFrame(props6)

        local function updateView17(param1)
            searchBox.Text = ''

            window:Select(param1.tab)
            task.delay(0.55, function()
                updateView15(param1.tab.sc, param1.r, 40)

                param1.r.BackgroundTransparency = 0.8

                tween(param1.r, {BackgroundTransparency = 1}, 1.4)
            end)
        end

        connectSignal(searchBox:GetPropertyChangedSignal('Text'), function()
            local current2 = searchBox.Text:lower()

            clearGuiObjects(container3)

            container3.Visible = current2 ~= ''

            if current2 == '' then
                return
            end

            local props16, count4 = window.All, 0

            for index, item in ipairs(props16) do
                if count4 < 8 then
                    if item.n:find(current2, 1, true) then
                        index = count4 + 1

                        local btnProps4, _unused = {
                            Parent = container3,
                            LayoutOrder = index,
                        }, UDim2.new

                        btnProps4.Size = UDim2.new(1, 0, 0, 42)

                        local corner, labelProps2, new2 = createCorner(9), {
                            Position = fromOffset(10, 4),
                        }, UDim2.new

                        labelProps2.Size = UDim2.new(1, -20, 0, 18)
                        labelProps2.Text = item.title
                        labelProps2.FontFace = FontBold
                        labelProps2.TextTruncate = TruncateAtEnd

                        local label5, labelProps3, udim2 = createLabel(labelProps2), {
                            Position = fromOffset(10, 22),
                        }, UDim2.new

                        labelProps3.Size = UDim2.new(1, -20, 0, 15)
                        labelProps3.Text = item.path
                        labelProps3.TextSize = 11
                        labelProps3.TextTransparency = 0.45
                        labelProps3.TextTruncate = TruncateAtEnd
                        btnProps4[1], btnProps4[2], btnProps4[3] = corner, label5, createLabel(labelProps3)
                        new2 = createButton(btnProps4)

                        bindHoverAlpha(new2, 0.92)

                        local function updateView18()
                            if isCleanTap() then
                                updateView17(item)
                            end
                        end

                        new2.Activated:Connect(updateView18)

                        count4 = index
                    end
                end
            end

            if count4 == 0 then
                props16 = {Parent = container3}
                props16.Size = UDim2.new(1, 0, 0, 32)
                props16.Text = 'No results'
                props16.TextTransparency = 0.45
                props16.TextXAlignment = AlignCenterX

                createLabel(props16)
            end
        end)

        window.Home = function(self2, homeOpts)
            local current2 = homeOpts or {}

            self2 = window:Tab(current2.Name or 'Home', current2.Icon or 'home', true)
            self2.Title = current2.Title or 'Dashboard'

            local new2, props16, labelProps2 = nil, {
                Parent = self2.sc,
                Position = fromOffset(-6, -6),
            }

            props16.Size = UDim2.new(1, 12, 1, 12)

            local container4 = createFrame(props16)

            local function updateView18(param1, param2, param3, param4, param5, param6, param7)
                local props17 = {Parent = container4}

                props17.Position = UDim2.new(param1, 6, param2, 6)
                props17.Size = UDim2.new(param3, -12, param4, -12)
                props17.BackgroundTransparency = param5 or 0.93
                props17.BackgroundColor3 = param6 or Palette.wh
                props17[1], props17[2] = createCorner(18), createStroke(param7 or 0.86, param6 and param6:Lerp(Palette.wh, 0.5))

                return createFrame(props17)
            end
            local function updateView19(param1, param2, param3, labelProps3)
                createImage({
                    Parent = param1,
                    Position = fromOffset(14, 13),
                    Size = fromOffset(14, 14),
                    Image = param3,
                    ImageColor3 = labelProps3,
                })

                labelProps3 = {
                    Parent = param1,
                    Position = fromOffset(34, 12),
                }
                labelProps3.Size = UDim2.new(1, -48, 0, 16)
                labelProps3.Text = param2:upper()
                labelProps3.FontFace = FontExtraBold
                labelProps3.TextSize = 11.5
                labelProps3.TextTransparency = 0.15

                return createLabel(labelProps3)
            end

            new2 = updateView18(0, 0, 0.6666666666666666, 0.3, 0.55)
            createGradient(color3FromRGB(255, 196, 120), color3FromRGB(150, 110, 255)).Parent = new2
            self2 = {Parent = new2}
            self2.Position = UDim2.new(0, 16, 0.5, -28)
            self2.Size = fromOffset(56, 56)
            self2.Image = getAvatarThumb(150)
            self2.BackgroundTransparency = 0
            self2.BackgroundColor3 = Palette.a2
            self2[1], self2[2] = createCorner(), createStroke(0.4)

            createImage(self2)

            props16 = {Parent = new2}
            props16.Position = UDim2.new(0, 86, 0.5, -34)
            props16.Size = UDim2.new(1, -100, 0, 14)
            props16.Text = 'Welcome back'
            props16.TextSize = 11
            props16.TextTransparency = 0.25

            createLabel(props16)

            labelProps2 = {Parent = new2}
            labelProps2.Position = UDim2.new(0, 86, 0.5, -19)
            labelProps2.Size = UDim2.new(1, -100, 0, 24)
            labelProps2.Text = localPlayer.DisplayName
            labelProps2.FontFace = FontBold
            labelProps2.TextSize = 21
            labelProps2.TextTruncate = TruncateAtEnd

            createLabel(labelProps2)

            self2 = {Parent = new2}
            self2.Position = UDim2.new(0, 86, 0.5, 10)
            self2.Size = UDim2.new(1, -100, 0, 20)
            self2[1] = createListLayout(6, nil, nil, FillHorizontal)

            local labelProps3, new3, labelProps4 = createFrame(self2), current2.Executor or identifyexecutor and select(2, pcall(identifyexecutor)), ipairs

            self2 = {
                {
                    current2.Game,
                },
                {
                    type(new3) == 'string' and new3,
                },
                {
                    current2.Key,
                    Palette.mint,
                },
            }

            for index, item in ipairs(self2) do
                if item[1] then
                    labelProps2, new2 = {
                        Parent = labelProps3,
                        LayoutOrder = index,
                    }, UDim2.new
                    labelProps2.Size = UDim2.new(0, 0, 1, 0)
                    labelProps2.AutomaticSize = AutoSizeX
                    labelProps2.Text = tostring(item[1])
                    labelProps2.TextSize = 11
                    labelProps2.TextColor3 = item[2] and item[2]:Lerp(Palette.wh, 0.6)
                    labelProps2.BackgroundTransparency = item[2] and 0.8 or 0.75
                    labelProps2.BackgroundColor3 = item[2] or color3FromRGB(0, 0, 0)
                    labelProps2.TextXAlignment = AlignCenterX
                    labelProps2[1], labelProps2[2] = createCorner(), createPadding(0, 10)

                    createLabel(labelProps2)
                end
            end

            props16 = current2.Notice
            new2 = updateView18(0.6666666666666666, 0, 0.3333333333333333, 0.3, 0.78, props16 and Palette.a1 or Palette.dc, 0.55)

            createSolidFrame({
                Parent = new2,
                Position = fromOffset(14, 14),
                Size = fromOffset(36, 36),
                BackgroundColor3 = props16 and Palette.a1 or Palette.dc,
                createCorner(11),
                createIcon(props16 and 'sparkles' or 'discord', 22),
            })

            labelProps3 = {
                Parent = new2,
                Position = fromOffset(60, 15),
            }
            labelProps3.Size = UDim2.new(1, -72, 0, 17)
            labelProps3.Text = props16 and props16[1] or current2.Community or 'Community'
            labelProps3.FontFace = FontBold
            labelProps3.TextSize = 14
            labelProps3.TextTruncate = TruncateAtEnd

            createLabel(labelProps3)

            if props16 then
                self2 = {
                    Parent = new2,
                    Position = fromOffset(14, 58),
                }
                self2.Size = UDim2.new(1, -28, 1, -70)
                self2.Text = props16[2]
                self2.TextSize = 11
                self2.TextTransparency = 0.22
                self2.TextWrapped = true
                self2.TextYAlignment = Enum.TextYAlignment.Top

                createLabel(self2)
            else
                labelProps4 = {
                    Parent = new2,
                    Position = fromOffset(60, 33),
                }
                labelProps4.Size = UDim2.new(1, -72, 0, 14)
                labelProps4.Text = 'Updates, keys, support'
                labelProps4.TextSize = 11
                labelProps4.TextTransparency = 0.22

                createLabel(labelProps4)

                local btnProps4, button4 = {
                    Parent = new2,
                    AnchorPoint = vector2New(0, 1),
                }

                btnProps4.Position = UDim2.new(0, 14, 1, -12)
                btnProps4.Size = UDim2.new(1, -28, 0, 32)
                btnProps4.BackgroundTransparency = 0
                btnProps4.BackgroundColor3 = Palette.dc
                btnProps4.Text = 'Copy invite'
                btnProps4.FontFace = FontBold
                btnProps4.TextSize = 12
                btnProps4.TextColor3 = Palette.wh
                btnProps4[1] = createCorner(10)
                button4 = createButton(btnProps4)

                bindPressScale(button4)
                onClick(button4, function()
                    updateView5(current2.Discord, 'Invite copied')
                end)
            end

            local teleportService = getService('TeleportService')

            self2, labelProps3 = current2.Actions

            if self2 then
                labelProps3 = self2
            else
                labelProps2, labelProps4, props16, new2, new3 = {}, {
                    'Rejoin',
                    'refresh',
                    function()
                        updateView3('Rejoin this server?', 'You leave and join this same server again.', 'warn', 'Rejoin', function(
                        )
                            teleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, localPlayer)
                        end)
                    end,
                }, {
                    'Server hop',
                    'server',
                    function()
                        updateView3('Hop to another server?', 'You leave this server and join a different one.', 'warn', 'Hop', function(
                        )
                            if current2.Hop then
                                current2.Hop()
                            else
                                teleportService:Teleport(game.PlaceId, localPlayer)
                            end
                        end)
                    end,
                }, {
                    'Copy Job ID',
                    'copy',
                    function()
                        updateView5(game.JobId, 'Job ID copied')
                    end,
                }, current2.Unload

                local items, items3 = new3 and {
                    'Unload hub',
                    'trash',
                    current2.Unload,
                } or {
                    'Save config',
                    'save',
                    updateView4,
                }, current2.Switch or current2.Discord and {
                    'Discord',
                    'discord',
                    function()
                        updateView5(current2.Discord, 'Discord invite copied')
                    end,
                }

                labelProps2[1], labelProps2[2], labelProps2[3], labelProps2[4], labelProps2[5] = labelProps4, props16, new2, items, items3 or {
                    'Hide UI',
                    'eye',
                    function()
                        window:Show(false)
                    end,
                }
                labelProps3 = labelProps2
            end

            self2 = {Parent = container4}
            self2.Position = UDim2.new(0, 6, 0.3, 6)
            self2.Size = UDim2.new(1, -12, 0.16, -12)
            self2[1] = createListLayout(12, nil, nil, FillHorizontal)
            labelProps2, labelProps4 = createFrame(self2), ipairs

            for index2, item2 in ipairs(labelProps3) do
                self2, new2, props16, new3 = QuickBarColors[(index2 - 1) % 5 + 1], createFrame, {
                    Parent = labelProps2,
                    LayoutOrder = index2,
                }, UDim2.new
                props16.Size = UDim2.new(1 / #labelProps3, 12 / #labelProps3 - 12, 1, 0)

                local props17, corner, stroke, props18, new4 = {
                    Parent = createFrame(props16),
                    AnchorPoint = CenterAnchor,
                    Position = CenterPos,
                    Size = FullSize,
                    BackgroundTransparency = 0.94,
                }, createCorner(14), createStroke(0.88), {}, UDim2.new

                props18.Position = UDim2.new(0, 10, 0.5, -15)
                props18.Size = fromOffset(30, 30)
                props18.BackgroundTransparency = 0.82
                props18.BackgroundColor3 = self2
                props18[1], props18[2] = createCorner(9), createIcon(item2[2], 16, self2)

                local container5, labelProps5, udim2 = createFrame(props18), {
                    Position = fromOffset(48, 0),
                }, UDim2.new

                labelProps5.Size = UDim2.new(1, -54, 1, 0)
                labelProps5.Text = item2[1]
                labelProps5.TextSize = 12
                labelProps5.TextWrapped = true
                props17[1], props17[2], props17[3], props17[4] = corner, stroke, container5, createLabel(labelProps5)
                new4 = createButton(props17)

                bindPressScale(new4, 0.95)
                onClick(new4, function()
                    safeCall(item2[3])
                end)
            end

            local current3 = updateView18(0, 0.46, 0.6666666666666666, 0.54)
            local current4 = updateView19(current3, 'Session', 'clock', Palette.gold)

            new2 = updateView18(0.6666666666666666, 0.46, 0.3333333333333333, 0.54)

            updateView19(new2, "What's new", 'sparkles', Palette.pink)

            labelProps2 = {
                Parent = new2,
                Position = fromOffset(14, 40),
            }
            labelProps2.Size = UDim2.new(1, -24, 1, -50)
            labelProps2[1], labelProps2[2] = createPadding(1, 4, 4, 1), createListLayout(10)

            local scrollFrame2, homeView = createScrollFrame(labelProps2), {}

            local function updateView20(param1)
                local num, items = math.max(os.time() - param1, 0), {
                    {
                        86400,
                        'day',
                    },
                    {
                        3600,
                        'hour',
                    },
                    {
                        60,
                        'minute',
                    },
                }

                for _, item in ipairs(items) do
                    param1 = num // item[1]

                    if param1 >= 1 then
                        return ('%d %s%s ago'):format(param1, item[2], param1 > 1 and 's' or '')
                    end
                end

                return 'just now'
            end

            homeView.News = function(_self, entries)
                homeView.list = entries

                clearGuiObjects(scrollFrame2)

                for index, item in ipairs(entries) do
                    local current5, props17, container5 = nil, {
                        Position = fromOffset(44, 0),
                    }

                    props17.Size = UDim2.new(1, -44, 0, 0)
                    props17.AutomaticSize = AutoSizeY
                    props17[1], props17[2] = createListLayout(2), createLabel({
                        Size = FullWidth,
                        AutomaticSize = AutoSizeY,
                        Text = item[2],
                        TextSize = 12,
                        TextWrapped = true,
                    })
                    container5 = createFrame(props17)

                    if item[3] or item[4] then
                        local labelProps5, props18, container6 = createFrame, {
                            Parent = container5,
                            LayoutOrder = 1,
                        }

                        props18.Size = UDim2.new(1, 0, 0, 14)
                        props18[1] = createListLayout(5, nil, AlignCenterY, FillHorizontal)
                        container6 = createFrame(props18)

                        if item[3] then
                            labelProps5, props18 = {Parent = container6}, UDim2.new
                            labelProps5.Size = UDim2.new(0, 0, 1, 0)
                            labelProps5.AutomaticSize = AutoSizeX
                            labelProps5.Text = item[3]
                            labelProps5.FontFace = FontMono
                            labelProps5.TextSize = 10
                            labelProps5.TextTransparency = 0.4

                            createLabel(labelProps5)
                        end
                        if item[4] then
                            local labelProps6, props19, current6 = nil, {
                                Parent = container6,
                                LayoutOrder = 1,
                            }

                            props19.Size = UDim2.new(0, 0, 1, 0)
                            props19.AutomaticSize = AutoSizeX
                            props19.BackgroundTransparency = 0.9
                            current6 = createListLayout
                            props19[1], props19[2], props19[3] = createCorner(), createPadding(0, 6), createListLayout(3, nil, AlignCenterY, FillHorizontal)
                            props17 = createFrame(props19)

                            createImage({
                                Parent = props17,
                                Size = fromOffset(10, 10),
                                Image = 'clock',
                                ImageTransparency = 0.3,
                            })

                            labelProps6, props18 = {
                                Parent = props17,
                                LayoutOrder = 1,
                            }, UDim2.new
                            labelProps6.Size = UDim2.new(0, 0, 1, 0)
                            labelProps6.AutomaticSize = AutoSizeX
                            labelProps6.Text = updateView20(item[4])
                            labelProps6.FontFace = FontMono
                            labelProps6.TextSize = 10
                            labelProps6.TextTransparency = 0.3

                            createLabel(labelProps6)
                        end
                    end

                    current5 = createFrame

                    createFrame({
                        Parent = scrollFrame2,
                        LayoutOrder = index,
                        Size = FullWidth,
                        AutomaticSize = AutoSizeY,
                        container5,
                        createLabel({
                            Size = fromOffset(0, 18),
                            AutomaticSize = AutoSizeX,
                            Text = item[1],
                            FontFace = FontMono,
                            TextSize = 9,
                            TextColor3 = color3FromRGB(16, 20, 42),
                            BackgroundTransparency = 0,
                            BackgroundColor3 = ({
                                NEW = Palette.mint,
                                FIX = Palette.sky,
                                IMP = Palette.gold,
                                UPD = Palette.red,
                            })[item[1] ] or Palette.vio,
                            TextXAlignment = AlignCenterX,
                            createCorner(5),
                            createPadding(0, 6),
                        }),
                    })
                end
            end
            homeView.Stats = function(self3, items, columns)
                current4.Text = items:upper()

                local container5, props17, current5 = nil, {
                    Parent = current3,
                    Position = fromOffset(12, 38),
                }

                props17.Size = UDim2.new(1, -24, 1, -48)
                current5 = {}
                current5.CellSize = UDim2.new(0.3333333333333333, -7, 0.333, -6)
                current5.CellPadding = fromOffset(10, 8)
                current5.SortOrder = Enum.SortOrder.LayoutOrder
                props17[1] = newInstance('UIGridLayout', current5)
                self3, items, current5 = createFrame(props17), {}, ipairs

                for index, item in ipairs(columns) do
                    props17 = createFrame
                    container5 = createFrame({
                        Parent = self3,
                        LayoutOrder = index,
                        BackgroundTransparency = 0.94,
                        createCorner(12),
                    })

                    if item[2] then
                        local props18, current6 = {
                            Parent = container5,
                            AnchorPoint = vector2New(0, 0.5),
                        }

                        props18.Position = UDim2.new(0, 8, 0.5, 0)
                        props18.Size = fromOffset(30, 30)
                        props18.Image = item[2]
                        current6 = Enum
                        props18.ScaleType = Enum.ScaleType.Fit
                        props18.ImageColor3 = IconIndex[item[2] ] and Palette.a1 or nil

                        createImage(props18)
                    end

                    local count4, labelProps5, new4 = item[2] and 44 or 10, {Parent = container5}

                    labelProps5.Position = UDim2.new(0, count4, 0.5, -17)
                    labelProps5.Size = UDim2.new(1, -count4 - 6, 0, 13)
                    labelProps5.Text = item[1]:upper()
                    labelProps5.FontFace = FontExtraBold
                    labelProps5.TextSize = 9.5
                    labelProps5.TextTransparency = 0.38

                    createLabel(labelProps5)

                    labelProps5, index = item[1], {Parent = container5}
                    index.Position = UDim2.new(0, count4, 0.5, -2)
                    new4 = UDim2.new
                    index.Size = UDim2.new(1, -count4 - 6, 0, 18)
                    index.Text = '--'
                    index.FontFace = FontMono
                    index.TextSize = 13.5
                    index.TextTruncate = TruncateAtEnd
                    items[labelProps5] = createLabel(index)

                    if item[3] then
                        index, count4 = {
                            Parent = container5,
                            AnchorPoint = vector2New(1, 0),
                        }, UDim2.new
                        index.Position = UDim2.new(1, -8, 0, 8)
                        index.Size = fromOffset(40, 16)
                        index.Text = 'OPEN'
                        index.FontFace = FontExtraBold
                        index.TextSize = 9
                        index.TextColor3 = Palette.wh
                        index.BackgroundTransparency = 0.82
                        index.BackgroundColor3 = Palette.wh
                        index[1], index[2] = createCorner(), createStroke(0.7)
                        new4 = createButton(index)

                        bindPressScale(new4, 0.92)
                        onClick(new4, function()
                            safeCall(item[3])
                        end)
                    end
                end

                return createStatController(items)
            end

            if current2.News then
                homeView:News(current2.News)
            end

            return homeView
        end

        local function updateView18(options, param2, param3)
            return type(options) == 'table' and options or window:Tab(options or param2, param3)
        end

        window.Settings = function(_self, targetTab)
            local target = updateView18(targetTab, 'Settings', 'settings')

            targetTab = target:Section('Interface', 'sliders')

            targetTab:Slider('UI scale', 60, 140, 100, function(param1)
                window:SetScale(param1 / 100)
            end, '%', 5)

            local function updateView19(param1)
                window.Key = param1
            end

            targetTab:Key('Show / hide UI', window.Key, nil, updateView19)
            targetTab:Slider('Opacity', 50, 100, 95, function(param1)
                window.bg.BackgroundTransparency = 1 - param1 / 100
            end, '%')
            targetTab:Slider('Tone', -100, 100, 70, function(param1)
                window:Tone(param1)
            end, '', 5)
            targetTab:Slider('Dim the game', 0, 80, 60, function(param1)
                window.dz = param1 / 100

                if window.open then
                    window.dim.BackgroundTransparency = 1 - window.dz
                end
            end, '%', 5)

            updateView19, targetTab = target:Section('Theme', 'palette'), createFrame

            local props16, padding, gradient, container4, new2 = {
                Parent = updateView19.f,
                LayoutOrder = 2,
                Name = 'VenyxThemes',
                Size = FullWidth,
                AutomaticSize = AutoSizeY,
            }, createPadding(2, 14, 14), newInstance, {}, UDim2.new

            container4.CellSize = UDim2.new(0.25, -8, 0, 62)
            container4.CellPadding = fromOffset(10, 10)
            container4.SortOrder = Enum.SortOrder.LayoutOrder
            props16[1], props16[2] = padding, newInstance('UIGridLayout', container4)
            container4 = createFrame(props16)
            updateView19.n = updateView19.n + 1
            updateView19 = {}

            for index, theme in ipairs(Themes) do
                local stroke, props17, corner, props18, props19, props20 = createStroke(0.86), {
                    Parent = container4,
                    LayoutOrder = index,
                    BackgroundTransparency = 0.95,
                }, createCorner(12), createFrame, {
                    Position = fromOffset(6, 6),
                }, UDim2.new

                props19.Size = UDim2.new(1, -12, 0, 30)
                props19.BackgroundTransparency = 0
                props16, gradient, new2, props20, index = createCorner(8), createGradient(theme[2], theme[4], 20), createFrame, {
                    AnchorPoint = vector2New(0, 1),
                }, UDim2.new
                props20.Position = UDim2.new(0, 6, 1, -5)
                padding = UDim2.new
                props20.Size = UDim2.new(0.45, 0, 0, 6)
                props20.BackgroundTransparency = 0
                props20.BackgroundColor3 = theme[5]
                props20[1] = createCorner()
                props19[1], props19[2], props19[3] = props16, gradient, createFrame(props20)

                local container5, labelProps2, new3 = createFrame(props19), {
                    Position = fromOffset(8, 40),
                }, UDim2.new

                labelProps2.Size = UDim2.new(1, -26, 0, 16)
                labelProps2.Text = theme[1]
                labelProps2.FontFace = FontBold
                labelProps2.TextSize = 11
                labelProps2.TextTruncate = TruncateAtEnd
                props17[1], props17[2], props17[3], props17[4] = corner, stroke, container5, createLabel(labelProps2)
                labelProps2, new3, container5 = createButton(props17), theme[1], {}
                props18, index = {
                    Parent = labelProps2,
                    AnchorPoint = RightCenterAnchor,
                }, UDim2.new
                props18.Position = UDim2.new(1, -8, 0, 48)
                props18.Size = fromOffset(12, 12)
                props18.Image = 'check'
                props18.ImageColor3 = theme[5]
                props18.ImageTransparency = 1
                container5[1], container5[2] = stroke, createImage(props18)
                updateView19[new3] = container5

                bindPressScale(labelProps2, 0.95)
                onClick(labelProps2, function()
                    Venyx:Theme(theme[1])
                end)
            end

            window.marks = updateView19
            new2 = target:Section('Defaults', 'refresh')

            new2:Button('Reset to defaults', 'Reset', function()
                updateView3('Reset every option?', 
[[All options go back to their built-in values and your active config is saved that way.]], 'warn', 'Reset', function(
                )
                    Venyx:Reset()
                    Venyx:Notify('Reset', 'Every option is back to its default', 'ok')
                end)
            end, 'danger')
            new2:Button('Turn off all toggles', 'Turn off', function()
                Venyx:Notify('Toggles off', Venyx:Off() .. ' switched off', 'ok')
            end)

            return target
        end
        window.Config = function(_self, targetTab)
            local target = updateView18(targetTab, 'Config', 'save')

            targetTab = target:Section('Config', 'folder')

            local current2 = targetTab:Stats({
                'Active',
                'Saved configs',
            })
            local control

            local function updateView19()
                current2:Set('Active', State.Active)
                current2:Set('Saved configs', tostring(#Venyx:Configs()))

                if control then
                    control:Set(State.Active, true)
                end
            end
            local function updateView20(param1, param2, callbackFn2, param4)
                local current3 = param1:Dropdown(param2, function()
                    return Venyx:Configs()
                end, nil, function(param12)
                    if param12 then
                        if callbackFn2 then
                            callbackFn2(param12)
                        end
                    end
                end, param4)

                current3.Skip = true

                return current3
            end

            control = updateView20(targetTab, 'Config', function(param1)
                if param1 ~= State.Active then
                    Venyx:Notify('Config picked', param1 .. ' - press Set active to load it', 'info')
                end
            end)

            targetTab:Button('Set as active config', 'Set active', function()
                local current3 = control.Value

                if not current3 then
                    return Venyx:Notify('Nothing picked', 'Choose a config first', 'warn')
                end
                if Venyx:Load(current3) then
                    updateView19()
                    Venyx:Notify('Active config', current3, 'ok')
                end
            end, 'gold')
            targetTab:Button('Save changes', 'Save', updateView4)

            local state = State

            targetTab:Toggle('Auto load', state.AutoLoad, function(param1)
                if State.AutoLoad ~= param1 then
                    local current3, current4 = 'Auto load ' .. (param1 and 'on' or 'off')

                    if param1 then
                        current4 = State.Active .. ' loads every time Venyx starts'
                    else
                        current4 = param1
                    end

                    Venyx:Notify(current3, current4 or 'Venyx starts with its default options', 'info')
                end

                State.AutoLoad = param1

                Venyx:Persist()
            end).Skip = true
            state = State
            targetTab:Toggle('Auto save', state.AutoSave, function(param1)
                if State.AutoSave == param1 then
                    return
                end

                State.AutoSave = param1

                Venyx:Persist()

                if param1 then
                    Venyx:Save()
                end

                local current3, current4 = 'Auto save ' .. (param1 and 'on' or 'off')

                if param1 then
                    current4 = 'Every change is saved to ' .. State.Active
                else
                    current4 = param1
                end

                Venyx:Notify(current3, current4 or 'Press Save changes to keep your options', 'info')
            end).Skip = true
            state = target:Section('Profiles', 'copy')

            local control2 = state:Input('New config name', 'Auto if empty')

            control2.Skip = true

            state:Button('Create config', 'Create', function()
                local current3, current4 = Venyx:Name(control2.Value)

                if not current3 then
                    return Venyx:Notify('Config not created', current4, 'err')
                end

                Venyx:Save(current3)

                State.Active = current3

                Venyx:Persist()
                control2:Set('', true)
                updateView19()
                Venyx:Notify('Config created', current3 .. ' is now the active config', 'ok')
            end, 'gold')

            local control3 = updateView20(state, 'Pick to delete', nil, true)

            state:Button('Delete picked', 'Delete', function()
                local list, enabled = {}, false

                for _, item in ipairs(control3.Value) do
                    if item:lower() == 'default' then
                        enabled = true
                    else
                        list[#list + 1] = item
                    end
                end

                if #list == 0 then
                    return Venyx:Notify('Nothing to delete', 'Pick configs other than Default', 'warn')
                end

                updateView3('Delete ' .. #list .. ' config(s)?', table.concat(list, ', ') .. (enabled and '\nDefault is kept.' or ''), 'err', 'Delete', function(
                )
                    for index, item in ipairs(list) do
                        index = Venyx

                        Venyx:Delete(item)
                    end

                    control3:Set({}, true)
                    updateView19()
                    Venyx:Notify(#list .. ' config(s) deleted', table.concat(list, ', '), 'ok')
                end)
            end, 'danger')

            local current3

            current3 = state:Dropdown('Restore deleted', function()
                return Venyx:Trash()
            end, nil, function(param1)
                if not param1 then
                    return
                end

                local current4 = Venyx:Restore(param1)

                current3:Set(nil, true)
                updateView19()
                Venyx:Notify(current4 and 'Config restored' or 'Restore failed', current4 or param1, current4 and 'ok' or 'err')
            end)
            current3.Skip = true

            updateView20(state, 'Export config', function(param1)
                local current4 = pcall(setclipboard, Venyx:Export(param1))

                Venyx:Notify(current4 and 'Config copied' or 'Copy failed', current4 and param1 .. ' is on your clipboard' or 'This executor cannot copy text', current4 and 'ok' or 'err')
                window:Dialog({
                    Title = current4 and 'Config copied' or 'Copy failed',
                    Kind = current4 and 'ok' or 'err',
                    Text = current4 and param1 .. 
[[ is on your clipboard. Paste it to share it, then load it with Import config.]] or 'This executor cannot copy text.',
                })
            end)

            local control4 = state:Input('Import text', 'Paste config text')

            control4.Skip = true

            state:Button('Import config', 'Import', function()
                local current4, current5 = Venyx:Import(control4.Value)

                if not current4 then
                    return Venyx:Notify('Import failed', current5, 'err')
                end

                control4:Set('', true)
                updateView3('Config imported', current4 .. ' was added to your configs. Apply it now?', 'ok', 'Apply now', function(
                )
                    Venyx:Load(current4)
                    updateView19()
                    Venyx:Notify('Config loaded', current4, 'ok')
                end, 'Later')
                Venyx:Notify('Config imported', current4 .. ' was added to your configs', 'ok')
            end, 'gold')
            updateView19()

            return target
        end
        window.Quick = function(self2, targetTab, defaultPins)
            local items, items3, control, list, list2, list3, items4, callbackFn2 = {
                pins = {},
                keys = {},
                at = {},
                fold = {},
            }, {
                show = false,
                keys = true,
                size = 1,
            }, {
                Value = '',
            }, {}, {}, {}
            local count4, items5 = 0

            local function updateView19(param1)
                local current2 = items5.tr

                items5.o:Set(items5.o.From(math.clamp((param1.Position.X - current2.AbsolutePosition.X) / current2.AbsoluteSize.X, 0, 1)), false, true)
            end
            local function updateView20(param1)
                return Venyx.Keys[param1].Name
            end
            local function updateView21(target)
                local list4, current2, text = {}, -#updateView20(target) - 2, ''

                for key in target:sub(1, current2):gmatch('[^/]+') do
                    key = key:match('^%s*(.-)%s*$')

                    if key:lower() ~= text then
                        text, list4[#list4 + 1] = key:lower(), key
                    end
                end

                return table.concat(list4, '  /  ')
            end
            local function updateView22(param1)
                local current2 = items.keys[param1]

                return current2 and (KeyLabels[current2] or current2)
            end
            local function updateView23(param1, param2, callbackFn3)
                local uIScale

                if param2 then
                    uIScale = newInstance('UIScale', {Parent = param1})
                else
                    uIScale = param2
                end

                local backgroundTransparency = param1.BackgroundTransparency

                local function updateView24(param12)
                    if isPrimaryPointer(param12) then
                        tween(uIScale or param1, uIScale and {Scale = param2} or {
                            BackgroundTransparency = backgroundTransparency - 0.06,
                        }, 0.12)
                    end
                end

                param1.InputBegan:Connect(updateView24)

                local function updateView25(param12)
                    if isPrimaryPointer(param12) then
                        tween(uIScale or param1, uIScale and {Scale = 1} or {BackgroundTransparency = backgroundTransparency}, 0.35)
                    end
                end

                param1.InputEnded:Connect(updateView25)

                local function updateView26()
                    if isCleanTap() then
                        callbackFn3()
                    end
                end

                param1.Activated:Connect(updateView26)
            end
            local function updateView24(param1, param2, param3)
                local descendants = param1:GetDescendants()

                descendants[#descendants + 1] = param1

                for index, item in ipairs(descendants) do
                    index = {}

                    if item:IsA('GuiObject') then
                        index.BackgroundTransparency = item.BackgroundTransparency
                    end
                    if item:IsA('TextLabel') then
                        index.TextTransparency = item.TextTransparency
                    elseif item:IsA('TextButton') then
                        index.TextTransparency = item.TextTransparency
                    elseif item:IsA('TextBox') then
                        index.TextTransparency = item.TextTransparency
                    end
                    if item:IsA('ImageLabel') then
                        index.ImageTransparency = item.ImageTransparency
                    end
                    if item:IsA('UIStroke') then
                        index.Transparency = item.Transparency
                    end

                    local list4 = {}

                    for key in next, index do
                        list4[key] = 1
                    end

                    if param2 then
                        for key in next, index do
                            item[key] = 1
                        end

                        tween(item, index, 0.3, nil, nil, param3)
                    else
                        tween(item, list4, 0.26, EaseQuint, Enum.EasingDirection.In, param3)
                    end
                end

                if not param2 then
                    param1.Active = false

                    tween(param1, {
                        Position = param1.Position + fromOffset(0, 26),
                    }, 0.3, EaseQuint, Enum.EasingDirection.In, param3)
                    task.delay(0.32 + param3, param1.Destroy, param1)
                end
            end
            local function updateView25()
                for index, value in ipairs(window.All) do
                    local current2 = value.k:sub(1, -#value.title - 2)

                    list3[current2], list3[value.k] = list3[current2] or index, list3[value.k] or index
                end

                local list4 = {}

                for key, value2 in next, Venyx.Keys do
                    if value2.Kind then
                        list4[#list4 + 1] = key
                    end
                end

                table.sort(list4, function(target, key)
                    local current2, current3 = (list3[target:sub(1, -#updateView20(target) - 2)] or 1000000000) * 10000 + (list3[target] or 0), (list3[key:sub(1, 
-#updateView20(key) - 2)] or 1000000000) * 10000 + (list3[key] or 0)

                    if current2 == current3 then
                        return target < key
                    end

                    return current2 < current3
                end)

                return list4
            end
            local function updateView26()
                control:Set(HttpService:JSONEncode(items), true)
            end
            local function updateView27()
                items = {
                    pins = {},
                    keys = {},
                    at = {},
                    fold = {},
                }

                local packedValues = table.pack(updateView25())

                for _, item in ipairs(Runtime.unpack(packedValues)) do
                    local current2 = defaultPins or {}

                    for _, item2 in ipairs(current2) do
                        if item:sub(-#item2) == item2 then
                            items.pins[item] = 1
                        end
                    end
                end
            end
            local function updateView28()
                for index, value in ipairs(list2) do
                    index = table.find(value[1].ls, value[2])

                    if index then
                        table.remove(value[1].ls, index)
                    end
                end

                table.clear(list2)

                for index, value in ipairs(list) do
                    updateView24(value.f, false, (index - 1) * 0.05)
                end

                table.clear(list)

                if callbackFn2 then
                    callbackFn2()
                end
                if not items3.show then
                    return
                end

                local viewportSize, current2, count5 = workspace.CurrentCamera.ViewportSize, updateView25(), 220
                local current3, count6 = math.clamp(viewportSize.Y / 720, 0.75, 1.2) * items3.size, 0

                for index2 = 1, 5, 1 do
                    local list4, text = {}, tostring(index2)

                    for _, item in ipairs(current2) do
                        if items.pins[item] == index2 then
                            list4[#list4 + 1] = item
                        end
                    end

                    if #list4 > 0 then
                        count6 += 1

                        local image
                        local uiScale3, labelProps2 = newInstance('UIScale', {Scale = current3}), createListLayout
                        local listLayout, label5 = createListLayout(5), createFrame
                        local props16, props17, labelProps3 = createFrame({
                            LayoutOrder = 1,
                            Size = FullWidth,
                            AutomaticSize = AutoSizeY,
                            ClipsDescendants = true,
                            createPadding(0, 7, 7),
                            listLayout,
                        }), {AnchorPoint = CenterAnchor}, UDim2.new

                        props17.Position = UDim2.new(1, -17, 0.5, 0)
                        props17.Size = fromOffset(12, 12)
                        props17.Image = 'down'
                        props17.ImageTransparency = 0.4
                        props17.Rotation = items.fold[text] and -90 or 0

                        local image2, btnProps4, new2 = createImage(props17), {}, UDim2.new

                        btnProps4.Size = UDim2.new(1, 0, 0, 34)
                        image, labelProps3, props17 = createImage({
                            Position = fromOffset(12, 10),
                            Size = fromOffset(14, 14),
                            Image = 'zap',
                            ImageColor3 = QuickBarColors[index2],
                        }), {
                            Position = fromOffset(33, 0),
                        }, UDim2.new
                        labelProps3.Size = UDim2.new(1, -90, 1, 0)
                        labelProps3.Text = 'QUICK BAR ' .. index2
                        labelProps3.FontFace = FontExtraBold
                        labelProps3.TextSize = 11
                        label5, labelProps2, new2 = createLabel(labelProps3), {AnchorPoint = RightCenterAnchor}, UDim2.new
                        labelProps2.Position = UDim2.new(1, -32, 0.5, 0)
                        labelProps2.Size = fromOffset(0, 16)
                        labelProps2.AutomaticSize = AutoSizeX
                        labelProps2.Text = #list4
                        labelProps2.FontFace = FontBold
                        labelProps2.TextSize = 9.5
                        labelProps2.TextXAlignment = AlignCenterX
                        labelProps2.BackgroundTransparency = 0.88
                        labelProps2[1], labelProps2[2] = createCorner(), createPadding(0, 6)
                        btnProps4[1], btnProps4[2], btnProps4[3], btnProps4[4] = image2, image, label5, createLabel(labelProps2)
                        labelProps3, labelProps2, props17, label5 = createButton(btnProps4), createFrame, {
                            Parent = window.Gui,
                            AnchorPoint = vector2New(0.5, 0),
                            Size = fromOffset(count5, 0),
                            AutomaticSize = AutoSizeY,
                            BackgroundTransparency = 0.06,
                            Active = true,
                            ZIndex = 2,
                        }, createListLayout
                        props17[1], props17[2], props17[3], props17[4], props17[5], props17[6], props17[7] = createCorner(16), createGradient(Palette.w1, Palette.w2, 90), createStroke(0.74), uiScale3, createListLayout(), labelProps3, props16

                        local props18 = createFrame(props17)
                        local items6, current4 = {
                            f = props18,
                            u = uiScale3,
                            id = text,
                        }, count6

                        items6.place = function(param1, param2)
                            local vec = items.at[text]

                            vec = vec and vector2New(vec[1], vec[2]) or vector2New(param1.X - 18 - count5 * param2 / 2 - (current4 - 1) * (count5 * param2 + 12), math.max(param1.Y * 0.023, 8))
                            items6.sp.t = vector2New(math.clamp(vec.X, 40, param1.X - 40), math.clamp(vec.Y, 0, param1.Y - 40))
                            uiScale3.Scale = param2
                        end
                        items6.sp = createSpring(vector2New(), function(param1)
                            props18.Position = UDim2.new(0, param1.X, 0, param1.Y)
                        end)

                        items6.place(viewportSize, current3)

                        items6.sp.p = items6.sp.t + vector2New(0, 14)
                        list[#list + 1] = items6

                        if items.fold[text] then
                            label5 = Enum
                            props16.AutomaticSize = Enum.AutomaticSize.None
                            props16.Size = FullWidth
                        end

                        labelProps3.InputBegan:Connect(function(input)
                            if isPrimaryPointer(input) then
                                items4 = items4 or {
                                    b = items6,
                                    i = input,
                                    s = vector2New(input.Position.X, input.Position.Y),
                                    p = items6.sp.t,
                                }
                            end
                        end)
                        updateView23(labelProps3, nil, function()
                            local fold, current5 = items.fold, items.fold[text]

                            fold[text] = if current5 then nil else not current5

                            local current6, current7, _unused, props19 = items.fold[text], listLayout.AbsoluteContentSize.Y / math.max(props18.AbsoluteSize.X / count5, 0.01) + 7

                            props19, props16.AutomaticSize, props16.Size = UDim2.new, Enum.AutomaticSize.None, UDim2.new(1, 0, 0, current6 and current7 or 0)

                            tween(image2, {
                                Rotation = current6 and -90 or 0,
                            }, 0.3)

                            props19 = {}
                            props19.Size = UDim2.new(1, 0, 0, current6 and 0 or current7)

                            tween(props16, props19, 0.32).Completed:Connect(function()
                                if not (items.fold[text]) then
                                    props16.AutomaticSize = AutoSizeY
                                end
                            end)
                            updateView26()
                        end)

                        props17 = ipairs

                        for index, item in ipairs(list4) do
                            btnProps4 = Venyx

                            local control2 = Venyx.Keys[item]

                            label5 = updateView22(item)

                            local callbackFn3

                            labelProps2, labelProps3, new2 = control2.Kind, {
                                Parent = props16,
                                LayoutOrder = index,
                            }, UDim2.new
                            labelProps3.Size = UDim2.new(1, 0, 0, labelProps2 == 'slider' and 46 or 34)
                            labelProps3.BackgroundTransparency = 0.93
                            labelProps3[1] = createCorner(11)
                            image, index = createButton(labelProps3), createFrame

                            local container4, new3, props19, current5 = createFrame({
                                Parent = image,
                                Size = FullSize,
                                createCorner(11),
                                createGradient(Palette.a1, Palette.a2),
                            }), createFrame, {Parent = image}, TopRightAnchor

                            props19.AnchorPoint = TopRightAnchor
                            props19.Position = UDim2.new(1, -9, 0, 6)
                            props19.Size = fromOffset(160, 22)
                            props19.ZIndex = 2
                            current5, index = createListLayout, Enum
                            props19[1] = createListLayout(6, Enum.HorizontalAlignment.Right, AlignCenterY, FillHorizontal)

                            local container5, labelProps4, _unused = createFrame(props19), {
                                Parent = image,
                                Position = fromOffset(11, 6),
                            }, UDim2.new

                            labelProps4.Size = UDim2.new(1, -(labelProps2 == 'button' and 96 or labelProps2 == 'input' and 132 or 60) - (label5 and 44 or 0), 0, 22)
                            labelProps4.Text = updateView20(item)
                            labelProps4.FontFace = FontBold
                            labelProps4.TextSize = 12.5
                            labelProps4.TextTruncate = TruncateAtEnd
                            labelProps4.ZIndex = 2

                            createLabel(labelProps4)

                            if label5 then
                                createLabel({
                                    Parent = container5,
                                    Size = fromOffset(0, 18),
                                    AutomaticSize = AutoSizeX,
                                    Text = label5,
                                    FontFace = FontMono,
                                    TextSize = 10,
                                    TextXAlignment = AlignCenterX,
                                    BackgroundTransparency = 0.86,
                                    createCorner(6),
                                    createPadding(0, 6),
                                })
                            end
                            if labelProps2 == 'toggle' then
                                current5 = createFrame

                                local setSwitch = createToggleSwitch(createFrame({
                                    Parent = container5,
                                    LayoutOrder = 1,
                                    Size = fromOffset(38, 20),
                                }), 38, 20)

                                callbackFn3 = function(param1, param2)
                                    setSwitch(param1, param2)

                                    if param2 then
                                        container4.BackgroundTransparency = param1 and 0.78 or 1
                                    else
                                        tween(container4, {
                                            BackgroundTransparency = param1 and 0.78 or 1,
                                        }, 0.25)
                                    end
                                end

                                updateView23(image, nil, function()
                                    Venyx.qb = true

                                    control2:Set(not control2.Value)

                                    Venyx.qb = nil
                                end)
                            else
                                if labelProps2 == 'button' then
                                    local label6 = createLabel({
                                        Parent = container5,
                                        LayoutOrder = 1,
                                        Size = fromOffset(0, 22),
                                        AutomaticSize = AutoSizeX,
                                        Text = control2.Text,
                                        FontFace = FontBold,
                                        TextSize = 11,
                                        TextColor3 = control2.Col:Lerp(Palette.wh, 0.55),
                                        BackgroundTransparency = 0.85,
                                        BackgroundColor3 = control2.Col,
                                        createCorner(8),
                                        createPadding(0, 10),
                                        createStroke(0.5, control2.Col),
                                    })

                                    updateView23(image, nil, function()
                                        control2.Fire()

                                        label6.BackgroundTransparency = 0.5

                                        tween(label6, {BackgroundTransparency = 0.85}, 0.5)
                                    end)
                                else
                                    if labelProps2 == 'input' then
                                        local inputBox = createTextBox({
                                            Parent = container5,
                                            LayoutOrder = 1,
                                            Size = fromOffset(116, 24),
                                            BackgroundTransparency = 0.7,
                                            BackgroundColor3 = color3FromRGB(0, 0, 0),
                                            PlaceholderText = 'Type here',
                                            TextSize = 11.5,
                                            TextTruncate = TruncateAtEnd,
                                            ClipsDescendants = true,
                                            createCorner(7),
                                            createPadding(0, 7),
                                            createStroke(0.8),
                                        })

                                        local function updateView29()
                                            control2:Set(inputBox.Text)
                                        end

                                        inputBox.FocusLost:Connect(updateView29)

                                        callbackFn3 = function(param1)
                                            if not (inputBox:IsFocused()) then
                                                inputBox.Text = tostring(param1 or '')
                                            end
                                        end
                                    else
                                        local label6, props20, props21 = createLabel({
                                            Parent = container5,
                                            LayoutOrder = 1,
                                            Size = fromOffset(0, 22),
                                            AutomaticSize = AutoSizeX,
                                            FontFace = FontMono,
                                            TextSize = 11,
                                            TextColor3 = Palette.val,
                                        }), {Parent = image}, UDim2.new

                                        props20.Position = UDim2.new(0, 11, 1, -13)
                                        labelProps4 = UDim2.new
                                        props20.Size = UDim2.new(1, -22, 0, 5)
                                        props20.BackgroundTransparency = 0.86
                                        props20.ZIndex = 2
                                        props20[1] = createCorner()

                                        local container6 = createFrame(props20)

                                        props21, new3 = {Parent = container6}, UDim2.new
                                        props21.Size = UDim2.new(0, 0, 1, 0)
                                        props21[1], props21[2] = createCorner(), createGradient(Palette.a1, Palette.a2)

                                        local box, props22, _unused = createSolidFrame(props21), {
                                            Parent = container6,
                                            AnchorPoint = CenterAnchor,
                                        }, UDim2.new

                                        props22.Position = UDim2.new(0, 0, 0.5, 0)
                                        props22.Size = fromOffset(13, 13)
                                        props22.ZIndex = 3
                                        props22[1], props22[2] = createCorner(), createStroke(0.65, color3FromRGB(0, 0, 0))

                                        local box2 = createSolidFrame(props22)

                                        callbackFn3 = function(param1, param2)
                                            local num, props23, props24 = math.clamp(control2.Frac(param1), 0, 1), {}, UDim2.new

                                            props23.Size = UDim2.new(num, 0, 1, 0)

                                            tween(box, props23, param2 and 0 or 0.1)

                                            props24 = {}
                                            props24.Position = UDim2.new(num, 0, 0.5, 0)

                                            tween(box2, props24, param2 and 0 or 0.1)

                                            label6.Text = control2.Txt(param1)
                                        end

                                        image.InputBegan:Connect(function(input)
                                            if isPrimaryPointer(input) then
                                                items5 = {
                                                    o = control2,
                                                    tr = container6,
                                                    i = input,
                                                }
                                                pointerTracker.s = true

                                                updateView19(input)
                                            end
                                        end)
                                    end
                                end
                            end
                            if callbackFn3 then
                                callbackFn3(control2.Value, true)

                                control2.ls[#control2.ls + 1] = callbackFn3
                                list2[#list2 + 1] = {control2, callbackFn3}
                            end
                        end

                        items6.sp.a(items6.sp.p)
                        updateView24(props18, true, (count6 - 1) * 0.06)
                    end
                end
            end
            local function updateView29()
                count4 += 1

                local current2 = count4

                task.delay(0.15, function()
                    if current2 == count4 then
                        updateView28()
                    end
                end)
            end

            self2 = RunService

            connectSignal(self2.Heartbeat, function(deltaTime)
                for _, item in ipairs(list) do
                    stepSpring(item.sp, deltaTime)
                end
            end)
            connectSignal(workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'), function(
            )
                local viewportSize = workspace.CurrentCamera.ViewportSize

                if viewportSize.X < 300 then
                    return
                elseif viewportSize.Y < 200 then
                    return
                end

                for _, item in ipairs(list) do
                    item.place(viewportSize, math.clamp(viewportSize.Y / 720, 0.75, 1.2) * items3.size)
                end
            end)
            connectSignal(UserInputService.InputChanged, function(input)
                if items5 then
                    if input == items5.i then
                        updateView19(input)
                    else
                        if items5.i.UserInputType == Enum.UserInputType.MouseButton1 then
                            if input.UserInputType == Enum.UserInputType.MouseMovement then
                                updateView19(input)
                            end
                        end
                    end
                end
                if items4 then
                    if input ~= items4.i then
                        if input.UserInputType ~= Enum.UserInputType.MouseMovement then
                            return
                        end
                    end
                else
                    return
                end

                local current2, current3 = vector2New(input.Position.X, input.Position.Y) - items4.s, items4

                current3.mv = current3.mv or current2.Magnitude > 6

                if items4.mv then
                    current3, input = workspace.CurrentCamera.ViewportSize, items4.p + current2
                    items4.b.sp.t = vector2New(math.clamp(input.X, 40, current3.X - 40), math.clamp(input.Y, 0, current3.Y - 40))
                end
            end)
            connectSignal(UserInputService.InputEnded, function(input)
                if items5 then
                    if input == items5.i then
                        items5 = nil
                    else
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            items5 = nil
                        end
                    end
                end
                if items4 then
                    if input ~= items4.i then
                        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
                            return
                        end
                    end
                else
                    return
                end

                input = items4
                items4 = nil

                if input.mv then
                    items.at[input.b.id] = {
                        input.b.sp.t.X,
                        input.b.sp.t.Y,
                    }

                    updateView26()
                end
            end)

            local function updateView30(param1, param2)
                if param2 then
                    if window.Key then
                        if param2 == window.Key.Name then
                            local current2 = (KeyLabels[param2] or param2) .. ' already shows and hides the menu'

                            return Venyx:Notify('Key not set', current2, 'warn')
                        end
                    end
                end

                local keys = items.keys

                for key, value in next, keys, nil do
                    if param2 then
                        if value == param2 then
                            if key ~= param1 then
                                items.keys[key] = nil

                                Venyx:Notify('Key moved', (KeyLabels[param2] or param2) .. ' now toggles ' .. updateView20(param1) .. ' instead of ' .. updateView20(key), 'info')
                            end
                        end
                    end
                end

                items.keys[param1] = param2

                updateView26()
                updateView28()
            end

            function window.Pin(self3, flagKey)
                local uiScale3, enabled, current2, label5, stroke = newInstance('UIScale', {Scale = 0.9}), false
                local button4 = createButton({
                    Parent = props5,
                    Size = FullSize,
                    BackgroundColor3 = color3FromRGB(5, 6, 16),
                    ZIndex = 30,
                    createCorner(16),
                })
                local btnProps4, btnProps5, stroke2, props16 = {
                    Parent = button4,
                    AnchorPoint = CenterAnchor,
                    Position = CenterPos,
                    Size = fromOffset(390, 0),
                    AutomaticSize = AutoSizeY,
                    BackgroundTransparency = 0.02,
                    BackgroundColor3 = Palette.pn,
                }, createCorner(18), createStroke(0.8), createPadding(20)
                local listLayout, props17, new2 = createListLayout(10), {}, UDim2.new

                props17.Size = UDim2.new(1, 0, 0, 46)

                local container4, labelProps2, props18 = createFrame({
                    Size = fromOffset(46, 46),
                    BackgroundTransparency = 0.8,
                    BackgroundColor3 = Palette.a1,
                    createCorner(14),
                    createIcon('pin', 22, Palette.a1),
                }), {
                    Position = fromOffset(60, 3),
                }, UDim2.new

                labelProps2.Size = UDim2.new(1, -60, 0, 22)
                labelProps2.Text = updateView20(flagKey)
                labelProps2.FontFace = FontBold
                labelProps2.TextSize = 17
                labelProps2.TextTruncate = TruncateAtEnd
                props18, self3, new2 = createLabel(labelProps2), {
                    Position = fromOffset(60, 26),
                }, UDim2.new
                self3.Size = UDim2.new(1, -60, 0, 16)
                self3.Text = updateView21(flagKey)
                self3.TextSize = 11.5
                self3.TextTransparency = 0.42
                self3.TextTruncate = TruncateAtEnd
                props17[1], props17[2], props17[3] = container4, props18, createLabel(self3)
                btnProps4[1], btnProps4[2], btnProps4[3], btnProps4[4], btnProps4[5], btnProps4[6] = btnProps5, stroke2, props16, listLayout, uiScale3, createFrame(props17)

                local button5 = createButton(btnProps4)

                local function updateView31(param1, param2)
                    local labelProps3 = {
                        Parent = button5,
                        LayoutOrder = param1,
                    }

                    labelProps3.Size = UDim2.new(1, 0, 0, 22)
                    labelProps3.Text = param2
                    labelProps3.FontFace = FontExtraBold
                    labelProps3.TextSize = 10
                    labelProps3.TextTransparency = 0.45
                    labelProps3.TextYAlignment = Enum.TextYAlignment.Bottom

                    createLabel(labelProps3)
                end

                updateView31(1, 'SHOW ON QUICK BAR')

                props18 = {
                    Parent = button5,
                    LayoutOrder = 2,
                }
                props18.Size = UDim2.new(1, 0, 0, 40)
                props16 = {}
                props16.CellSize = UDim2.new(0.16666666666666666, -7, 1, 0)
                props16.CellPadding = fromOffset(8, 0)
                props16.SortOrder = Enum.SortOrder.LayoutOrder
                props18[1] = newInstance('UIGridLayout', props16)

                local container5, list4 = createFrame(props18), {}

                local function updateView32(param1)
                    for key, value in next, list4 do
                        local isMatch, current3, stateMap = (items.pins[flagKey] or 0) == key, value[1], {}

                        stateMap.BackgroundTransparency = isMatch and 0 or 1

                        tween(current3, stateMap, param1 and 0 or 0.2)
                        tween(value[2], {
                            Transparency = isMatch and 0.45 or 0.84,
                            Color = isMatch and Palette.a1 or Palette.wh,
                        }, param1 and 0 or 0.2)

                        value[3].TextColor3 = isMatch and Palette.on or Palette.wh
                    end
                end

                for index = 0, 5, 1 do
                    listLayout, props17 = createStroke(0.84), createLabel({
                        Size = FullSize,
                        Text = index == 0 and 'Off' or index,
                        FontFace = FontExtraBold,
                        TextSize = 13,
                        TextXAlignment = AlignCenterX,
                        ZIndex = 2,
                    })
                    props16, labelProps2, props18 = createButton({
                        Parent = container5,
                        LayoutOrder = index,
                        BackgroundTransparency = 0.93,
                        createCorner(12),
                        listLayout,
                        props17,
                    }), {}, createFrame
                    labelProps2[1], labelProps2[2], labelProps2[3] = createFrame({
                        Parent = props16,
                        Size = FullSize,
                        createCorner(12),
                        createGradient(Palette.a1, Palette.a2, 90),
                    }), listLayout, props17
                    list4[index] = labelProps2

                    updateView23(props16, 0.9, function()
                        items.pins[flagKey] = index > 0 and index or nil

                        updateView32()
                        updateView26()
                        updateView28()

                        if index > 0 then
                            if not items3.show then
                                Venyx:Notify('Quick bars are hidden', 'Turn on Show quick bars to see Quick bar ' .. index, 'info')
                            end
                        end
                    end)
                end

                updateView32(true)

                local function updateView33()
                    label5.Text = enabled and 'Press any key  -  Esc cancels' or updateView22(flagKey) or 'Not set'
                    label5.TextTransparency = (enabled or items.keys[flagKey]) and 0 or 0.45

                    tween(stroke, {
                        Transparency = enabled and 0.3 or 0.82,
                        Color = enabled and Palette.a1 or Palette.wh,
                    }, 0.2)
                end

                container4, btnProps4 = UserInputService.KeyboardEnabled

                if container4 then
                    labelProps2 = Venyx.Keys[flagKey].Kind == 'toggle'

                    if labelProps2 then
                        btnProps4 = labelProps2
                    else
                        btnProps4 = Venyx.Keys[flagKey].Kind == 'button'
                    end
                else
                    btnProps4 = container4
                end

                local current3

                if btnProps4 then
                    updateView31(3, 'KEYBIND')

                    stroke = createStroke(0.82)
                    props16 = {
                        Parent = button5,
                        LayoutOrder = 4,
                    }
                    props16.Size = UDim2.new(1, 0, 0, 40)
                    self3 = createFrame(props16)
                    btnProps5 = {Parent = self3}
                    btnProps5.Size = UDim2.new(1, -98, 1, 0)
                    btnProps5.BackgroundTransparency = 0.92
                    btnProps5[1], btnProps5[2] = createCorner(12), stroke
                    container5 = createButton(btnProps5)
                    label5 = createLabel({
                        Parent = container5,
                        Size = FullSize,
                        FontFace = FontMono,
                        TextSize = 14,
                        TextXAlignment = AlignCenterX,
                    })

                    updateView23(container5, 0.96, function()
                        enabled = true
                        Venyx.kw = true

                        updateView33()
                    end)

                    props17 = {Parent = self3}
                    props17.AnchorPoint = TopRightAnchor
                    props17.Position = UDim2.new(1, 0, 0, 0)
                    props17.Size = UDim2.new(0, 88, 1, 0)
                    props17.BackgroundTransparency = 0.92
                    props17[1], props17[2], props17[3] = createCorner(12), createStroke(0.84), createLabel({
                        Size = FullSize,
                        Text = 'Clear',
                        FontFace = FontBold,
                        TextSize = 13,
                        TextXAlignment = AlignCenterX,
                    })

                    updateView23(createButton(props17), 0.92, function()
                        enabled = false
                        Venyx.kw = nil

                        updateView30(flagKey)
                        updateView33()
                    end)

                    current2 = UserInputService.InputBegan:Connect(function(input)
                        if enabled then
                            if input.UserInputType ~= Enum.UserInputType.Keyboard then
                                return
                            end
                        else
                            return
                        end

                        enabled = false

                        task.defer(function()
                            Venyx.kw = nil
                        end)

                        if input.KeyCode ~= Enum.KeyCode.Escape then
                            updateView30(flagKey, input.KeyCode.Name)
                        end

                        updateView33()
                    end)

                    updateView33()

                    current3 = current2
                else
                    current3 = current2
                end

                local function disconnectSignal()
                    if current3 then
                        current3:Disconnect()
                    end
                    if enabled then
                        Venyx.kw = nil
                    end

                    tween(uiScale3, {Scale = 0.92}, 0.18)

                    local activeTween, callbackFn3 = tween(button4, {BackgroundTransparency = 1}, 0.2), function(
                    )
                        button4:Destroy()
                    end

                    activeTween.Completed:Connect(callbackFn3)

                    button5.Visible = false
                end

                btnProps4 = {
                    Parent = button5,
                    LayoutOrder = 5,
                }
                btnProps4.Size = UDim2.new(1, 0, 0, 52)
                btnProps4[1] = createPadding(10, 0, 0)
                new2, stroke2 = createDialogButton(createFrame(btnProps4), 'Done', 0, 1, true), function(
                )
                    if isCleanTap() then
                        disconnectSignal()
                    end
                end

                new2.Activated:Connect(stroke2)
                button4.Activated:Connect(disconnectSignal)
                tween(button4, {BackgroundTransparency = 0.45}, 0.2)
                tween(uiScale3, {Scale = 1}, 0.35, EaseBack)
            end

            self2 = targetTab:Section('Quick bars', 'zap')

            self2:Toggle('Show quick bars', true, function(param1)
                items3.show = param1

                updateView29()
            end)
            self2:Toggle('Keybinds', true, function(param1)
                items3.keys = param1
            end)
            self2:Slider('Bar size', 60, 160, 100, function(param1)
                items3.size = param1 / 100

                for _, item in ipairs(list) do
                    item.u.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 720, 0.75, 1.2) * items3.size
                end
            end, '%', 5)

            control.Set = function(self3, newValue, silent)
                self3.Value = tostring(newValue or '')

                local current2, current3 = pcall(HttpService.JSONDecode, HttpService, self3.Value)

                if current2 and type(current3) == 'table' and type(current3.pins) == 'table' then
                    newValue = {
                        'keys',
                        'at',
                        'fold',
                    }

                    for _, item in ipairs(newValue) do
                        current3[item] = type(current3[item]) == 'table' and current3[item] or {}
                    end

                    items = current3
                else
                    updateView27()
                end
                if not silent then
                    updateView29()
                end
            end

            self2:Reg('Quick bar layout', control)

            local current2 = targetTab:Section('Pins and keybinds', 'pin')

            current2:Text(
[[Tip: you can also hold any feature, or right-click it on PC, to pin it or set a key.]])

            local props16, props17, container4 = nil, {
                Parent = current2.f,
                LayoutOrder = current2.n + 1,
                Size = FullWidth,
                AutomaticSize = AutoSizeY,
            }

            props17[1], props17[2] = createPadding(4, 14, 12), createListLayout(8)
            container4 = createFrame(props17)

            current2:Add(container4, '')

            local container5, props18, container6 = nil, {Parent = container4}

            props18.Size = UDim2.new(1, 0, 0, 34)
            container6 = createFrame(props18)
            props16 = {Parent = container6}
            props16.Size = UDim2.new(1, -150, 1, 0)

            local searchBox3, text, props19, props20 = createSearchBox(props16, 'Find an option'), 'All', createFrame, {Parent = container6}

            props20.AnchorPoint = TopRightAnchor
            props20.Position = UDim2.new(1, 0, 0, 0)
            props20.Size = UDim2.new(0, 142, 1, 0)
            props20.BackgroundTransparency = 0.93
            props20[1], props20[2], props20[3] = createCorner(10), createStroke(0.86), createPadding(3)
            container5 = createFrame(props20)
            props19 = {Parent = container5}
            props19.Size = UDim2.new(0.5, 0, 1, 0)
            props19[1], props19[2] = createCorner(8), createGradient(Palette.a1, Palette.a2, 90)

            local box, props21, _unused = createSolidFrame(props19), {
                Parent = container4,
                LayoutOrder = 1,
            }, UDim2.new

            props21.Size = UDim2.new(1, 0, 0, 300)
            props21[1] = createListLayout(4)

            local scrollFrame2 = createScrollFrame(props21)

            window.nest[scrollFrame2] = targetTab.top or targetTab
            props17 = {Parent = scrollFrame2}
            props17.Size = UDim2.new(1, 0, 0, 60)
            props17.TextSize = 12
            props17.TextTransparency = 0.45
            props17.TextXAlignment = AlignCenterX

            local label5 = createLabel(props17)

            callbackFn2 = function()
                for _, child in ipairs(scrollFrame2:GetChildren()) do
                    if child:IsA('GuiObject') then
                        if child ~= label5 then
                            child:Destroy()
                        end
                    end
                end

                local current3, current4 = searchBox3.Text:lower(), table.pack(updateView25())
                local current5
                local count5 = 0

                for index, item in ipairs(Runtime.unpack(current4)) do
                    if text == 'All' or items.pins[item] or items.keys[item] then
                        if item:lower():find(current3, 1, true) then
                            local new2, current6 = items.pins[item], updateView22(item)

                            index = nil

                            if updateView21(item) ~= current5 then
                                local current7 = updateView21(item)

                                index = count5 + 1

                                local labelProps2, current8 = {
                                    Parent = scrollFrame2,
                                    LayoutOrder = index,
                                }

                                labelProps2.Size = UDim2.new(1, -6, 0, 24)
                                labelProps2.Text = current7:upper()
                                labelProps2.FontFace = FontExtraBold
                                labelProps2.TextSize = 9.5
                                labelProps2.TextTransparency = 0.5
                                current8 = Enum
                                labelProps2.TextYAlignment = Enum.TextYAlignment.Bottom
                                labelProps2[1] = createPadding(0, 0, 3, 6)

                                createLabel(labelProps2)

                                current5 = current7
                            else
                                index = count5
                            end

                            local labelProps2, props22, _unused = nil, {AnchorPoint = RightCenterAnchor}, UDim2.new

                            props22.Position = UDim2.new(1, -10, 0.5, 0)
                            props22.Size = fromOffset(170, 22)

                            local container7, corner
                            local listLayout, props23, btnProps4, padding, gradient, labelProps3, new3 = createListLayout(6, Enum.HorizontalAlignment.Right, AlignCenterY, FillHorizontal), {
                                LayoutOrder = 1,
                                Size = fromOffset(0, 22),
                                AutomaticSize = AutoSizeX,
                                BackgroundTransparency = new2 and 0 or 0.9,
                            }, createCorner(), createPadding(0, 9), new2 and createGradient(Palette.a1, Palette.a2, 90) or nil, {}, UDim2.new

                            labelProps3.Size = UDim2.new(0, 0, 1, 0)
                            labelProps3.AutomaticSize = AutoSizeX
                            labelProps3.Text = new2 and 'QUICK BAR ' .. new2 or '+ PIN'
                            labelProps3.FontFace = FontExtraBold
                            labelProps3.TextSize = 9.5
                            labelProps3.TextTransparency = new2 and 0 or 0.4
                            labelProps3.TextColor3 = new2 and Palette.on or Palette.wh
                            props23[1], props23[2], props23[3], props23[4] = btnProps4, padding, gradient, createLabel(labelProps3)
                            props22[1], props22[2] = listLayout, createSolidFrame(props23)
                            container7 = createFrame(props22)

                            if current6 then
                                createLabel({
                                    Parent = container7,
                                    Size = fromOffset(0, 22),
                                    AutomaticSize = AutoSizeX,
                                    Text = current6,
                                    FontFace = FontMono,
                                    TextSize = 10.5,
                                    TextXAlignment = AlignCenterX,
                                    BackgroundTransparency = 0.88,
                                    createCorner(7),
                                    createPadding(0, 7),
                                })
                            end

                            index += 1

                            btnProps4 = {
                                Parent = scrollFrame2,
                                LayoutOrder = index,
                            }
                            btnProps4.Size = UDim2.new(1, -6, 0, 38)
                            btnProps4.BackgroundTransparency = 0.955
                            corner, props22, labelProps2, new2 = createCorner(12), createStroke(0.9), {
                                Position = fromOffset(12, 0),
                            }, UDim2.new
                            labelProps2.Size = UDim2.new(1, -190, 1, 0)
                            labelProps2.RichText = true
                            props23, listLayout = updateView20(item), Venyx
                            gradient, new3 = Venyx.Keys[item].Kind ~= 'toggle'

                            if gradient then
                                current6 = Venyx
                                new3 = '  <font transparency="0.6">' .. Venyx.Keys[item].Kind .. '</font>'
                            else
                                new3 = gradient
                            end

                            labelProps2.Text = props23 .. (new3 or '')
                            labelProps2.FontFace = FontBold
                            labelProps2.TextSize = 13
                            labelProps2.TextTruncate = TruncateAtEnd
                            btnProps4[1], btnProps4[2], btnProps4[3], btnProps4[4] = corner, props22, container7, createLabel(labelProps2)

                            updateView23(createButton(btnProps4), 0.97, function()
                                window:Pin(item)
                            end)

                            count5 = index
                        end
                    end
                end

                label5.Visible, label5.Text = count5 == 0, text == 'All' and 'No option matches' or 'Nothing pinned or bound yet'
            end

            local list4, items6 = {}, {
                'All',
                'Pinned',
            }

            for index2, item in ipairs(items6) do
                list4[index2] = createLabel({
                    Size = FullSize,
                    Text = item,
                    FontFace = FontBold,
                    TextSize = 12,
                    TextXAlignment = AlignCenterX,
                    TextColor3 = index2 == 1 and Palette.on or Palette.wh,
                })
                props17, props19 = {Parent = container5}, UDim2.new
                props17.Position = UDim2.new((index2 - 1) / 2, 0, 0, 0)
                container6 = UDim2.new
                props17.Size = UDim2.new(0.5, 0, 1, 0)
                props17.ZIndex = 2
                props17[1] = list4[index2]

                updateView23(createButton(props17), 0.95, function()
                    text = item

                    for index, item2 in ipairs(list4) do
                        tween(item2, {
                            TextColor3 = index == index2 and Palette.on or Palette.wh,
                        }, 0.2)
                    end

                    local props22 = {}

                    props22.Position = UDim2.new((index2 - 1) / 2, 0, 0, 0)

                    tween(box, props22, 0.3, EaseBack)
                    callbackFn2()
                end)
            end

            local count5 = 0

            connectSignal(searchBox3:GetPropertyChangedSignal('Text'), function()
                count5 += 1

                local current3 = count5

                task.delay(0.2, function()
                    if current3 == count5 then
                        callbackFn2()
                    end
                end)
            end)
            current2:Button('Clear all quick bars', 'Clear', function()
                updateView3('Clear every quick bar?', 'Features keep their state, they just leave the bars.', 'warn', 'Clear', function(
                )
                    items.pins = {}

                    updateView26()
                    updateView28()
                end)
            end, 'danger')
            current2:Button('Clear all keybinds', 'Clear', function()
                updateView3('Clear every keybind?', 'Keys stop toggling options until you set them again.', 'warn', 'Clear', function(
                )
                    items.keys = {}

                    updateView26()
                    updateView28()
                end)
            end, 'danger')
            connectSignal(UserInputService.InputBegan, function(input, gameProcessed)
                if gameProcessed then
                    return
                else
                    if Venyx.kw then
                        return
                    elseif items3.keys then
                        if input.UserInputType ~= Enum.UserInputType.Keyboard then
                            return
                        end
                    else
                        return
                    end
                end

                local keys = items.keys

                for key, value in next, keys, nil do
                    gameProcessed = Venyx

                    local control2 = Venyx.Keys[key]

                    if control2 then
                        if value == input.KeyCode.Name then
                            if control2.Kind == 'button' then
                                control2.Fire()
                                Venyx:Notify(updateView20(key), 'Pressed', 'ok', 2)
                            else
                                local current3

                                Venyx.qb = true

                                control2:Set(not control2.Value)

                                Venyx.qb = nil
                                current3 = Venyx

                                Venyx:Notify(updateView20(key), control2.Value and 'Turned on' or 'Turned off', control2.Value and 'ok' or 'info', 2)
                            end
                        end
                    end
                end
            end)
            updateView27()
            updateView29()

            return self2
        end
        window.Wheel = function(_self, tab)
            local instance = window.Cur and window.Cur.sc

            if UserInputService.TouchEnabled then
                return
            elseif window.open then
                if items2.open then
                    return
                elseif window.dlg then
                    return
                elseif os.clock() - (window.wt or 0) < 0.015 then
                    return
                elseif instance then
                    if not (instance:IsA('ScrollingFrame')) then
                        return
                    end
                else
                    return
                end
            else
                return
            end

            window.wt = os.clock()

            local current2 = UserInputService:GetMouseLocation() - (window.Gui.IgnoreGuiInset and vector2New() or vector2New(0, 58))

            for key, value in next, window.nest do
                local absPos, bounds, current3 = key.AbsolutePosition, key.AbsoluteSize, key.CanvasPosition.Y

                instance = if key.Parent then if(window.Cur.top or window.Cur) == value then if current2.X >= absPos.X then if current2.Y >= absPos.Y then if current2.X <= absPos.X + bounds.X then if current2.Y <= absPos.Y + bounds.Y then if tab > 0 and current3 > 1 then key else if tab < 0 then if current3 < key.AbsoluteCanvasSize.Y - bounds.Y - 1 then key else instance else instance else instance else instance else instance else instance else instance else instance
            end

            local max, goal, current3 = math.max(0, instance.AbsoluteCanvasSize.Y - instance.AbsoluteWindowSize.Y), window.goal, instance.CanvasPosition.Y

            goal = if goal then if window.gf ~= instance then current3 else if math.abs(goal - current3) > 300 then current3 else goal else current3
            window.goal = math.clamp(goal - tab * 120, 0, max)
            window.gf = instance

            tween(instance, {
                CanvasPosition = vector2New(0, window.goal),
            }, 0.4)
        end

        connectSignal(UserInputService.InputChanged, function(input)
            local current2, enum = window.Cur and window.Cur.sc

            if input.UserInputType ~= Enum.UserInputType.MouseWheel then
                return
            elseif current2 then
            else
                return
            end

            local current3, absolutePosition, absoluteSize = UserInputService:GetMouseLocation() - (window.Gui.IgnoreGuiInset and vector2New() or vector2New(0, 58)), current2.AbsolutePosition, current2.AbsoluteSize

            if current3.X < absolutePosition.X then
                return
            elseif current3.Y < absolutePosition.Y then
                return
            elseif current3.X > absolutePosition.X + absoluteSize.X then
                return
            elseif current3.Y > absolutePosition.Y + absoluteSize.Y then
                return
            end

            window:Wheel(input.Position.Z)
        end)

        window.Destroy = function(_self)
            local current2 = activeConnections

            for index, value in ipairs(current2) do
                value:Disconnect()
            end

            activeConnections = {}

            pcall(RunService.UnbindFromRenderStep, RunService, current)
            screenGui:Destroy()

            current2 = getgenv and getgenv().VenyxWindows

            if current2 then
                if current2[window.Id] == window then
                    current2[window.Id] = nil
                end
            end
        end
        window.Notify = function(_self, ...)
            return Venyx:Notify(...)
        end

        Venyx:Boot()
        window:Show(true)

        return window
    end
    -- ========================================================================
    -- 5. Section Component & Interactive Controls
    -- ========================================================================
    Section.new = function(tab, title, icon, column)
        local current, btnProps, props = setmetatable({
            t = tab,
            W = tab.W,
            n = 0,
            name = title,
            side = column,
        }, Section), {}, UDim2.new

        btnProps.Size = UDim2.new(1, 0, 0, 42)

        local image, labelProps, udim2 = createImage({
            Position = fromOffset(14, 14),
            Size = fromOffset(15, 15),
            Image = icon or 'grid',
            ImageColor3 = QuickBarColors[#tab.Secs % 5 + 1],
        }), {
            Position = fromOffset(37, 12),
        }, UDim2.new

        labelProps.Size = UDim2.new(1, -76, 0, 18)
        labelProps.Text = title:upper()
        labelProps.FontFace = FontExtraBold
        labelProps.TextSize = 12
        labelProps.TextTransparency = 0.06
        labelProps.TextTruncate = TruncateAtEnd
        btnProps[1], btnProps[2] = image, createLabel(labelProps)
        current.hd = createButton(btnProps)
        props = {
            Parent = current.hd,
            AnchorPoint = CenterAnchor,
        }
        props.Position = UDim2.new(1, -22, 0, 21)
        props.Size = fromOffset(14, 14)
        props.Image = 'down'
        props.ImageTransparency = 0.5
        current.ch = createImage(props)
        props = {
            LayoutOrder = 1,
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
            ClipsDescendants = true,
        }
        props[1] = createListLayout()
        current.f = createFrame(props)

        if column then
            if column > 2 then
                tab.cols[column].Visible = true
            end
        end

        props = {
            Parent = tab.cols[column or 1],
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
            BackgroundTransparency = 0.95,
            LayoutOrder = #tab.Secs + 1,
        }
        props[1], props[2], props[3], props[4], props[5] = createCorner(16), createStroke(0.88), createListLayout(), current.hd, current.f
        current.card = createFrame(props)

        onClick(current.hd, function()
            current:Collapse(current.open ~= false)
        end)

        tab.Secs[#tab.Secs + 1] = current
        tab.list[#tab.list + 1] = current

        connectSignal(current.card:GetPropertyChangedSignal('AbsoluteSize'), function()
            layoutSectionColumns(tab)
        end)
        layoutSectionColumns(tab)

        return current
    end
    Section.Collapse = function(self, collapsed)
        self.open = not collapsed

        local props = self.f
        local max = math.max(self.hd.AbsoluteSize.Y / 42, 0.1)
        local current, udim2 = props:FindFirstChildOfClass('UIListLayout').AbsoluteContentSize.Y / max

        props.Size = UDim2.new(1, 0, 0, props.AbsoluteSize.Y / max)
        props.AutomaticSize = Enum.AutomaticSize.None
        max = {}
        max.Size = UDim2.new(1, 0, 0, collapsed and 0 or current)
        udim2, current = tween(props, max, 0.35), function()
            if self.open then
                props.AutomaticSize = AutoSizeY
            end
        end

        udim2.Completed:Connect(current)

        current, udim2 = self.ch, {}
        udim2.Rotation = collapsed and -90 or 0

        tween(current, udim2, 0.3)
    end
    Section.Add = function(self, element, searchText, isInteractive)
        if self.n > 0 then
            createDivider(element, fromOffset(14, 0), UDim2.new(1, -28, 0, 1))
        end

        self.n = self.n + 1

        if isInteractive then
            local all = self.W.All
            local current, items = #all + 1, {
                r = element,
                n = searchText:lower(),
                title = searchText,
                tab = self.t.top,
                path = self.t.Name .. ' / ' .. self.name,
            }

            items.k, all[current] = self.t.Name .. '/' .. self.name .. '/' .. searchText, items
        end
    end
    Section.Row = function(self, label, description, rightWidth)
        local count, btnProps = description and 48 or 42, {
            Parent = self.f,
        }

        btnProps.Size = UDim2.new(1, 0, 0, count)
        btnProps.LayoutOrder = self.n + 1
        btnProps[1] = createCorner(14)

        local button = createButton(btnProps)

        self:Add(button, label, true)
        bindHoverAlpha(button, 0.97)
        connectSignal(button.InputBegan, function(input)
            if isPrimaryPointer(input) then
                tween(button, {BackgroundTransparency = 0.94}, 0.08)
            end
        end)
        connectSignal(button.InputEnded, function(input)
            if isPrimaryPointer(input) then
                tween(button, {BackgroundTransparency = 1}, 0.35)
            end
        end)

        btnProps = {
            Parent = button,
            AnchorPoint = vector2New(0, 0.5),
        }
        btnProps.Position = UDim2.new(0, 14, 0.5, 0)
        btnProps.Size = UDim2.new(1, -rightWidth - 42, 0, description and 42 or 21)

        local listLayout, labelProps, _unused = createListLayout(0, nil, AlignCenterY), {}, UDim2.new

        labelProps.Size, labelProps.Text, labelProps.TextSize, labelProps.TextTruncate = UDim2.new(1, 0, 0, 21), label, 14.5, TruncateAtEnd
        btnProps[1], btnProps[2] = listLayout, createLabel(labelProps)
        listLayout = createFrame(btnProps)

        if description then
            createLabel({
                Parent = listLayout,
                LayoutOrder = 1,
                Size = FullWidth,
                AutomaticSize = AutoSizeY,
                Text = description,
                TextSize = 12,
                TextTransparency = 0.3,
                TextWrapped = true,
            })
        end

        labelProps = {
            Parent = button,
            AnchorPoint = RightCenterAnchor,
        }
        labelProps.Position = UDim2.new(1, -14, 0.5, 0)
        labelProps.Size = fromOffset(rightWidth, 36)

        return button, createFrame(labelProps), listLayout
    end
    Section.Reg = function(self, flagKey, control)
        local value = control.Value

        control.Key, control.Name, control.Def = self.t.Name .. '/' .. self.name .. '/' .. flagKey, flagKey, type(value) == 'table' and table.clone(value) or value
        value, self = Venyx
        Venyx.Opt[flagKey], Venyx.Keys[control.Key] = control, control

        local set = control.Set

        control.Set = function(self2, ...)
            set(self2, ...)

            if State.AutoSave then
                if not Venyx.busy then
                    if not control.Skip then
                        Venyx:Dirty()
                    end
                end
            end
        end

        return control
    end
    Section.Hold = function(self, rowButton, control)
        local count = 0

        connectSignal(rowButton.InputEnded, function(input)
            if isPrimaryPointer(input) then
                count += 1
            end
        end)
        connectSignal(rowButton.InputBegan, function(input)
            local activeWin = self.W

            if not activeWin.Pin then
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton2 then
                local key = control.Key

                return activeWin:Pin(key)
            end
            if not (isPrimaryPointer(input)) then
                return
            end

            count += 1

            local current = count
            local isMatch = input.UserInputType == Enum.UserInputType.MouseButton1

            task.delay(0.6, function()
                local isMatch2, isMatch3 = count == current and pointerTracker.m < 14 and not pointerTracker.s

                if isMatch2 then
                    local current2 = isMatch and UserInputService:IsMouseButtonPressed(input.UserInputType)

                    if current2 then
                        isMatch3 = current2
                    else
                        local current3 = not isMatch

                        if isMatch then
                            isMatch3 = current3
                        else
                            isMatch3 = input.UserInputState ~= Enum.UserInputState.End
                        end
                    end
                else
                    isMatch3 = isMatch2
                end
                if isMatch3 then
                    pointerTracker.s = true

                    activeWin:Pin(control.Key)
                end
            end)
        end)
    end
    Section.Toggle = function(self, label, defaultValue, callback, description)
        local rowFrame, rightSlot = self:Row(label, description, 48)
        local setSwitch, control = createToggleSwitch(rightSlot, 46, 24), {}

        control.Value = not not defaultValue
        control.ls = {}
        control.Tab = self.t.Name
        control.Kind = 'toggle'
        control.Set = function(_self, newValue, silent)
            newValue = not not newValue
            control.Value = newValue

            setSwitch(newValue)

            for _, item in ipairs(control.ls) do
                item(newValue)
            end

            if not silent then
                safeCall(callback, newValue)
            end
        end

        onClick(rowFrame, function()
            control:Set(not control.Value)
        end)
        self:Hold(rowFrame, control)
        setSwitch(control.Value, true)

        if defaultValue then
            safeCall(callback, true)
        end

        return self:Reg(label, control)
    end

    local UnitMultipliers = {
        K = 1000,
        M = 1000000,
        B = 1000000000,
        T = 1000000000000,
    }

    Section.Slider = function(
        self,
        label,
        minValue,
        maxValue,
        defaultValue,
        callback2,
        scaleMode,
        step,
        description
    )
        local isMatch, current, current2 = scaleMode == 'log'

        if isMatch then
            minValue, maxValue = 0, 1000
            current, current2 = minValue, maxValue
        else
            current, current2 = minValue, maxValue
        end

        local count = step or 1
        local rowFrame, props, props2 = self:Row(label, description, 200)
        local textLabel = props2:FindFirstChildOfClass('TextLabel')

        textLabel:SetAttribute('nofit', true)

        textLabel.TextSize = 17

        local items = {w = 0}

        local function updateView()
            props2.Size = UDim2.new(0, items.w, props2.Size.Y.Scale, props2.Size.Y.Offset)
            props.Size = UDim2.new(1, -items.w - 46, 0, 36)
        end

        items[#items + 1] = updateView

        local function updateView2()
            local current3 = textLabel.AbsoluteSize.Y / 21

            if current3 <= 0 then
                return
            elseif textLabel.TextBounds.X <= 0 then
                return
            end

            local max = math.max(math.ceil(textLabel.TextBounds.X / current3) + 6, description and math.min(150, #description * 6.3 + 6) or 0)

            if max <= items.w then
                return updateView()
            end

            items.w = max

            for _, item in ipairs(items) do
                item()
            end
        end

        connectSignal(textLabel:GetPropertyChangedSignal('TextBounds'), updateView2)
        task.defer(updateView2)

        local props3 = {Parent = props}

        props3.Position = UDim2.new(0, 8, 0.5, -3)
        props3.Size = UDim2.new(1, -70, 0, 6)
        props3.BackgroundTransparency = 0.88
        props3[1] = createCorner()

        local container = createFrame(props3)

        props3 = {Parent = container}
        props3.Size = UDim2.new(0, 0, 1, 0)
        props3[1], props3[2] = createCorner(), createGradient(Palette.a1, Palette.a2)

        local box, props4, _unused = createSolidFrame(props3), {
            Parent = container,
            AnchorPoint = CenterAnchor,
        }, UDim2.new

        props4.Position = UDim2.new(0, 0, 0.5, 0)
        props4.Size = fromOffset(20, 20)
        props4.ZIndex = 2
        props4[1], props4[2] = createCorner(), createStroke(0.65, color3FromRGB(0, 0, 0))

        local box2 = createSolidFrame(props4)
        local uiScale = newInstance('UIScale', {Parent = box2})

        items = createStroke(0.8)

        local inputBox = createTextBox({
            Parent = props,
            AnchorPoint = RightCenterAnchor,
            Position = RightMidPos,
            Size = fromOffset(54, 28),
            FontFace = FontExtraBold,
            TextSize = 13,
            TextTruncate = TruncateAtEnd,
            TextColor3 = Palette.val,
            TextXAlignment = AlignCenterX,
            BackgroundTransparency = 0.72,
            BackgroundColor3 = color3FromRGB(0, 0, 0),
            createCorner(8),
            createPadding(4, 4),
            items,
        })

        local function updateView3(param1)
            if param1 <= 0 then
                return 0
            end

            local current3 = 10 ^ (3 + 9 * param1 / 1000)

            param1 = 10 ^ (math.floor(math.log10(current3)) - 2)

            return math.floor(current3 / param1 + 0.5) * param1
        end
        local function updateView4(param1)
            return isMatch and (param1 <= 0 and 0 or math.clamp((math.log10(param1) - 3) / 9 * 1000, 0, 1000)) or param1
        end
        local function updateView5(param1, param2)
            local format, isMatch2 = string.format, param1 >= 100 and '%.0f' or param1 >= 10 and '%.1f'
            local current3 = format(isMatch2 or '%.2f', param1)

            return (current3:find('%.') and current3:gsub('0+$', ''):gsub('%.$', '') or current3) .. param2
        end
        local function updateView6(param1, param2)
            if not isMatch then
                return type(scaleMode) == 'function' and scaleMode(param1) or formatNumber(param1) .. (scaleMode or '')
            end
            if param1 <= 0 then
                return param2 and '0' or 'Off'
            end

            local isMatch2 = param1 < 1000000 and 1000 or param1 < 1000000000 and 1000000 or 1000000000

            return updateView5(param1 / isMatch2, (isMatch2 == 1000 and 'K' or isMatch2 == 1000000 and 'M' or 'B') .. (param2 and '' or '/s'))
        end

        props3 = {
            Parent = props,
            Position = fromOffset(-4, -2),
        }
        props3.Size = UDim2.new(1, -60, 1, 4)
        props3.ZIndex = 3

        local button, control = createButton(props3), {
            ls = {},
            Kind = 'slider',
        }

        control.Set = function(self2, newValue, silent, param4)
            if type(newValue) ~= 'number' then
                local current3, current4 = tostring(newValue):upper():match('^([%d%.]+)(%a?)')
                local num, count2 = tonumber(current3) or 0, UnitMultipliers[current4] or (isMatch and 1000000 or 1)

                newValue = num * count2
            end

            newValue = isMatch and updateView3(updateView4(newValue)) or math.clamp(math.floor((newValue - current) / count + 0.5) * count + current, current, current2)
            self2 = newValue ~= control.Value
            control.Value = newValue

            local current3, props5 = (updateView4(newValue) - current) / (current2 - current), {}

            props5.Size = UDim2.new(current3, 0, 1, 0)

            tween(box, props5, param4 and 0.08 or 0.3)

            props5 = {}
            props5.Position = UDim2.new(current3, 0, 0.5, 0)

            tween(box2, props5, param4 and 0.08 or 0.3)

            if not (inputBox:IsFocused()) then
                inputBox.Text = updateView6(newValue)
            end

            for index, value in ipairs(control.ls) do
                value(newValue)
            end

            if silent then
            elseif self2 then
                safeCall(callback2, newValue)
            end
        end

        local C12

        local function updateView7(param1)
            local current3 = current + (current2 - current) * math.clamp((param1 - container.AbsolutePosition.X) / container.AbsoluteSize.X, 0, 1)

            control:Set(isMatch and updateView3(current3) or current3, false, true)
        end
        local function updateView8(param1)
            C12 = param1

            if self.t.cols then
                if UserInputService.TouchEnabled then
                    self.t.sc.ScrollingEnabled = not param1
                end
            end

            tween(uiScale, {
                Scale = param1 and 1.25 or 1,
            }, 0.22, EaseBack)
        end

        connectSignal(button.InputBegan, function(input)
            local drag = Venyx.drag

            if isPrimaryPointer(input) then
                if drag then
                    if drag ~= control then
                        if drag.d then
                            if drag.d.UserInputState ~= Enum.UserInputState.End then
                                return
                            end
                        end
                    end
                end
            else
                return
            end

            Venyx.drag = control
            control.d = input
            pointerTracker.s = true

            updateView8(input)
            updateView7(input.Position.X)
        end)

        local function updateView9()
            local current3, enum = C12.UserInputType

            return current3 == Enum.UserInputType.MouseButton1
        end

        connectSignal(UserInputService.InputChanged, function(input)
            local C13, isMatch2 = C12

            if C13 then
                local isMatch3 = input == C12

                if isMatch3 then
                    isMatch2 = isMatch3
                else
                    local current3 = updateView9()

                    if current3 then
                        isMatch2 = input.UserInputType == Enum.UserInputType.MouseMovement
                    else
                        isMatch2 = current3
                    end
                end
            else
                isMatch2 = C13
            end
            if isMatch2 then
                updateView7(input.Position.X)
            end
        end)
        connectSignal(UserInputService.InputEnded, function(input)
            local current3, W12 = C12

            if current3 then
                local isMatch2 = input == C12

                if isMatch2 then
                    W12 = isMatch2
                else
                    local current4 = updateView9()

                    if current4 then
                        W12 = input.UserInputType == Enum.UserInputType.MouseButton1
                    else
                        W12 = current4
                    end
                end
            else
                W12 = current3
            end
            if W12 then
                Venyx.drag = nil

                updateView8(nil)
            end
        end)
        connectSignal(inputBox.Focused, function()
            inputBox.Text = isMatch and updateView6(control.Value, true) or tostring(control.Value)

            tween(inputBox, {BackgroundTransparency = 0.75}, 0.15)
        end)
        bindInputFocus(inputBox, items, 0.5, 0.8, function()
            tween(inputBox, {BackgroundTransparency = 0.9}, 0.2)

            local text = inputBox.Text:gsub('[%s,/]', ''):gsub('[sS]$', '')

            text = if isMatch then if text:lower() == 'off'then'0'else text else text

            if text:match('^%-?[%d%.]+%a?$') then
                control:Set(isMatch and text or tonumber(text))
            end

            inputBox.Text = updateView6(control.Value)
        end)

        control.Frac = function(param1)
            return (updateView4(param1) - current) / (current2 - current)
        end
        control.Txt = updateView6
        control.From = function(param1)
            param1 = current + (current2 - current) * param1

            return isMatch and updateView3(param1) or param1
        end

        self:Hold(rowFrame, control)
        control:Set(defaultValue, true)

        return self:Reg(label, control)
    end
    Section.Dropdown = function(self, label, options, defaultValue, callback, isMulti, description)
        local rowFrame, rightSlot = self:Row(label, description, 176)
        local labelProps, props = nil, {
            Parent = rightSlot,
            AnchorPoint = vector2New(0, 0.5),
        }

        props.Position = UDim2.new(0, 0, 0.5, 0)
        props.Size = UDim2.new(1, 0, 0, 32)
        props.BackgroundTransparency = 0.93

        local corner, stroke, props2, new = createCorner(10), createStroke(0.87), {AnchorPoint = RightCenterAnchor}, UDim2.new

        props2.Position = UDim2.new(1, -8, 0.5, 0)
        props2.Size = fromOffset(13, 13)
        props2.Image = 'down'
        props[1], props[2], props[3] = corner, stroke, createImage(props2)
        props2 = createFrame(props)
        labelProps = {
            Parent = props2,
            Position = fromOffset(9, 0),
        }
        labelProps.Size = UDim2.new(1, -34, 1, 0)
        labelProps.FontFace = FontBold
        labelProps.TextSize = 14
        labelProps.TextTruncate = TruncateAtEnd

        local props3, labelProps2, udim2 = createLabel(labelProps), {
            Parent = props2,
            AnchorPoint = RightCenterAnchor,
        }, UDim2.new

        labelProps2.Position = UDim2.new(1, -26, 0.5, 0)
        labelProps2.Size = fromOffset(0, 18)
        labelProps2.AutomaticSize = AutoSizeX
        labelProps2.FontFace = FontBold
        labelProps2.TextSize = 11
        labelProps2.TextColor3 = color3FromRGB(226, 229, 255)
        labelProps2.BackgroundTransparency = 0.72
        labelProps2.BackgroundColor3 = Palette.a1
        labelProps2.TextXAlignment = AlignCenterX
        labelProps2[1], labelProps2[2] = createCorner(), createPadding(0, 6)

        local label2, control = createLabel(labelProps2), {
            Options = options,
            Multi = isMulti,
        }
        local activeWin = self.W

        control.Set = function(_self, newValue, silent)
            control.Value = isMulti and (type(newValue) == 'table' and newValue or {newValue}) or newValue
            newValue = isMulti and type(control.Options) == 'table' and control.Options

            if newValue then
                local list = {}

                for index, item in ipairs(newValue) do
                    list[type(item) == 'table' and item.v or item] = index
                end

                control.Value = table.clone(control.Value)

                table.sort(control.Value, function(key, param2)
                    return (list[key] or 1000000000) < (list[param2] or 1000000000)
                end)
            end

            newValue = isMulti and #control.Value or 0

            props3:SetAttribute('alt', newValue > 1 and control.Value[1] .. '...' or nil)

            props3.Text = isMulti and (newValue == 0 and 'None' or tostring(control.Value[1])) or tostring(control.Value or 'None')
            label2.Text = '+' .. newValue - 1
            label2.Visible = newValue > 1
            props3.Size = UDim2.new(1, newValue > 1 and -70 or -34, 1, 0)
            props3.TextTransparency = 0.6

            tween(props3, {TextTransparency = 0}, 0.3)
            activeWin:Sync(control)

            if not silent then
                safeCall(callback, control.Value)
            end
        end
        control.Refresh = function(_self, newOptions)
            control.Options = newOptions
        end

        onClick(rowFrame, function()
            local isMatch = type(control.Options) == 'function' and control.Options() or control.Options

            self.W:Pick(label, isMatch, control.Value, isMulti, function(param1)
                control:Set(param1)
            end, control.Default, control)
        end)

        control.Default = isMulti and table.clone(defaultValue or {}) or nil
        new = isMulti and (defaultValue or {})

        control:Set(new or defaultValue, true)

        return self:Reg(label, control)
    end
    Section.Input = function(self, label, placeholder, callback, description)
        local rowFrame, udim2 = self:Row(label, description, 176)
        local stroke, props, udim22 = createStroke(0.87), {
            Parent = udim2,
            AnchorPoint = vector2New(0, 0.5),
        }, UDim2.new

        props.Position = UDim2.new(0, 0, 0.5, 0)
        props.Size = UDim2.new(1, 0, 0, 26)
        props.BackgroundTransparency = 0.8
        props.BackgroundColor3 = color3FromRGB(0, 0, 0)
        props.PlaceholderText = placeholder or ''
        props.TextSize = 13
        props.TextTruncate = TruncateAtEnd
        props.TextXAlignment = Enum.TextXAlignment.Left
        props.ClipsDescendants = true
        props[1], props[2], props[3] = createCorner(10), createPadding(0, 10), stroke

        local inputBox, control = createTextBox(props), {
            Value = '',
            ls = {},
            Kind = 'input',
        }

        control.Set = function(_self, newValue, silent)
            control.Value = tostring(newValue or '')
            inputBox.Text = control.Value

            for index, value in ipairs(control.ls) do
                value(control.Value)
            end

            if not silent then
                safeCall(callback, control.Value)
            end
        end

        self:Hold(rowFrame, control)
        bindInputFocus(inputBox, stroke, 0.5, 0.87, function()
            control:Set(inputBox.Text)
        end)
        onClick(rowFrame, function()
            inputBox:CaptureFocus()
        end)

        return self:Reg(label, control)
    end
    Section.Key = function(self, label, defaultKey, onPress, onKeyChanged, description)
        local rowFrame, rightSlot = self:Row(label, description, 60)
        local stroke = createStroke(0.82)
        local props = {
            Parent = rightSlot,
            AnchorPoint = RightCenterAnchor,
            Position = RightMidPos,
            Size = fromOffset(0, 26),
            AutomaticSize = AutoSizeX,
            FontFace = FontMono,
            TextXAlignment = AlignCenterX,
            BackgroundTransparency = 0.92,
        }

        props[1], props[2], props[3], props[4] = createCorner(9), createPadding(0, 12), stroke, newInstance('UISizeConstraint', {
            MinSize = vector2New(36, 26),
        })

        local label2, control, enabled = createLabel(props), {}

        control.Set = function(self2, newValue, silent)
            control.Value = newValue
            self2 = newValue and newValue.Name or 'None'
            label2.Text = KeyLabels[self2] or self2

            tween(stroke, {
                Transparency = 0.82,
                Color = Palette.wh,
            }, 0.2)

            if not silent then
                safeCall(onKeyChanged, newValue)
            end
        end

        onClick(rowFrame, function()
            enabled = true
            Venyx.kw = true
            label2.Text = '...'

            tween(stroke, {
                Transparency = 0.4,
                Color = Palette.a1,
            }, 0.2)
        end)
        connectSignal(UserInputService.InputBegan, function(input, gameProcessed)
            local C14, isMatch = enabled

            if C14 then
                isMatch = input.UserInputType == Enum.UserInputType.Keyboard
            else
                isMatch = C14
            end
            if isMatch then
                enabled = false

                task.defer(function()
                    Venyx.kw = nil
                end)
                control:Set(input.KeyCode ~= Enum.KeyCode.Escape and input.KeyCode or nil)
            elseif gameProcessed then
            elseif control.Value then
                if input.KeyCode == control.Value then
                    safeCall(onPress)
                end
            end
        end)
        control:Set(defaultKey, true)

        return self:Reg(label, control)
    end
    Section.Button = function(self, label2, buttonText, callback2, variant, description)
        local sky, rightSlot, current = ({
            danger = Palette.red,
            gold = Palette.gold,
            mint = Palette.mint,
            pink = Palette.pink,
        })[variant] or Palette.sky, self:Row(label2, description, 110)
        local label = createLabel({
            Parent = current,
            AnchorPoint = RightCenterAnchor,
            Position = RightMidPos,
            Size = fromOffset(0, 26),
            AutomaticSize = AutoSizeX,
            Text = buttonText or 'Run',
            FontFace = FontBold,
            TextSize = 13,
            TextTransparency = 1,
            createPadding(0, 14),
        })

        description = {
            Parent = label,
            AnchorPoint = CenterAnchor,
            Position = CenterPos,
        }
        description.Size = UDim2.new(1, 28, 1, 0)
        description.Text = label.Text
        description.FontFace = FontBold
        description.TextSize = 13
        description.TextColor3 = sky:Lerp(Palette.wh, 0.55)
        description.TextXAlignment = AlignCenterX
        description.BackgroundTransparency = 0.85
        description.BackgroundColor3 = sky
        description[1], description[2] = createCorner(10), createStroke(0.5, sky)

        local label3 = createLabel(description)

        bindPressScale(label3, 0.93, rightSlot, function(bgAlpha)
            tween(label3, {
                BackgroundTransparency = bgAlpha and 0.7 or 0.85,
            }, 0.2)
        end)
        onClick(rightSlot, function()
            safeCall(callback2)
        end)

        description = {
            Kind = 'button',
            Skip = true,
            Text = label.Text,
            Col = sky,
            Name = label2,
            Key = self.t.Name .. '/' .. self.name .. '/' .. label2,
            Fire = function()
                safeCall(callback2)
            end,
            Set = function(param1, text)
                label.Text = text
                label3.Text = text
                param1.Text = text
            end,
        }
        Venyx.Keys[description.Key] = description

        self:Hold(rightSlot, description)

        return description
    end
    Section.Stats = function(self, items, columns)
        local sizePos
        local frame, createFrame2 = createFrame({
            Parent = self.f,
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
            LayoutOrder = self.n + 1,
        }), createFrame
        local props, padding, isMatch, stateMap, isMatch2, sizePos2 = {
            Parent = frame,
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
        }, createPadding(8, 14, 10), newInstance, {}, columns == 1

        if isMatch2 then
            sizePos2 = (UDim2.new(1, 0, 0, 40))
        else
            sizePos2 = isMatch2
        end

        sizePos = nil

        if sizePos2 then
            sizePos = sizePos2
        else
            sizePos = (UDim2.new(0.5, -6, 0, 40))
        end

        stateMap.CellSize = sizePos
        stateMap.CellPadding = fromOffset(12, 6)
        stateMap.SortOrder = Enum.SortOrder.LayoutOrder
        props[1], props[2] = padding, isMatch('UIGridLayout', stateMap)
        padding = createFrame2(props)

        self:Add(frame, '')

        frame = {}

        for index, item in ipairs(items) do
            isMatch = type(item) == 'table' and item[2]
            item = type(item) == 'table' and item[1] or item
            self, sizePos = isMatch and 40 or 10, createFrame
            createFrame2 = createFrame({
                Parent = padding,
                LayoutOrder = index,
                BackgroundTransparency = 0.95,
                createCorner(10),
            })

            if isMatch then
                index, stateMap = {
                    Parent = createFrame2,
                    Position = fromOffset(8, 7),
                    Size = fromOffset(26, 26),
                    Image = isMatch,
                }, Enum
                index.ScaleType = Enum.ScaleType.Fit
                index.ImageColor3 = IconIndex[isMatch] and Palette.a1 or nil

                createImage(index)
            end

            props = {
                Parent = createFrame2,
                Position = fromOffset(self, 4),
            }
            props.Size = UDim2.new(1, -self - 8, 0, 14)
            props.Text = item:upper()
            props.FontFace = FontExtraBold
            props.TextSize = 9.5
            props.TextTransparency = 0.38

            createLabel(props)

            index, sizePos2 = {
                Parent = createFrame2,
                Position = fromOffset(self, 19),
            }, UDim2.new
            index.Size = UDim2.new(1, -self - 8, 0, 17)
            index.Text = '--'
            index.FontFace = FontMono
            index.TextSize = 13
            index.TextTruncate = TruncateAtEnd
            frame[item] = createLabel(index)
        end

        return createStatController(frame)
    end
    Section.List = function(self, rows, emptyText, compact)
        local count = compact and 48 or 64
        local props = {
            Parent = self.f,
            LayoutOrder = self.n + 1,
        }

        props.Size = UDim2.new(1, 0, 0, rows * count + 12)

        local frame = createFrame(props)

        self:Add(frame, '')

        props = {
            Parent = frame,
            Position = fromOffset(10, 6),
        }
        props.Size = UDim2.new(1, -20, 1, -12)
        props[1] = createListLayout(6)

        local scrollFrame = createScrollFrame(props)

        self.W.nest[scrollFrame] = self.t.top or self.t

        local label, list, window, id = createLabel({
            Parent = frame,
            Size = FullSize,
            Text = emptyText or 'Nothing here',
            TextSize = 12,
            TextTransparency = 0.45,
            TextXAlignment = AlignCenterX,
        }), {}, {}

        local function updateBackgroundAlpha(param1)
            local isMatch = param1.it and param1.it.id == id

            param1.s.Color = isMatch and Palette.a1 or Palette.wh
            param1.s.Transparency = isMatch and 0.3 or 0.9
            param1.r.BackgroundTransparency = isMatch and 0.9 or 0.955
        end
        local function applyTextStyle()
            local stateMap = {}

            stateMap.s = createStroke(0.9)

            local btnProps, udim2 = {Parent = scrollFrame}

            btnProps.Size = UDim2.new(1, -6, 0, count - 6)
            btnProps.BackgroundTransparency = 0.955
            btnProps[1], btnProps[2] = createCorner(15), stateMap.s
            stateMap.r = createButton(btnProps)
            udim2 = compact and 30 or 42
            stateMap.box = createFrame({
                Parent = stateMap.r,
                Position = fromOffset(8, compact and 6 or 8),
                Size = fromOffset(udim2, udim2),
                BackgroundTransparency = 0.8,
                createCorner(compact and 10 or 13),
            })

            local props2, props3 = {
                Parent = stateMap.box,
                AnchorPoint = CenterAnchor,
                Position = CenterPos,
                Size = fromOffset(udim2 - 4, udim2 - 4),
            }

            props2.ScaleType = Enum.ScaleType.Fit
            stateMap.im = rawImageLabel(props2)
            props3 = {
                Parent = stateMap.r,
                Position = fromOffset(udim2 + 18, compact and 4 or 5),
            }
            props3.Size = UDim2.new(1, -152, 0, 18)
            props3[1] = createListLayout(8, nil, AlignCenterY, FillHorizontal)
            props2 = createFrame(props3)
            stateMap.a = createLabel({
                Parent = props2,
                Size = fromOffset(0, 18),
                AutomaticSize = AutoSizeX,
                FontFace = FontBold,
                TextSize = 13.5,
            })
            stateMap.pr = createLabel({
                Parent = props2,
                LayoutOrder = 1,
                Size = fromOffset(0, 18),
                AutomaticSize = AutoSizeX,
                FontFace = FontMono,
                TextSize = 12.5,
                TextColor3 = Palette.gv,
            })

            local props4 = {
                Parent = stateMap.r,
                Position = fromOffset(udim2 + 18, compact and 23 or 24),
            }

            props4.Size = UDim2.new(1, -152, 0, 13)
            props4[1] = createListLayout(8, nil, AlignCenterY, FillHorizontal)
            props3 = createFrame(props4)
            stateMap.rar = createLabel({
                Parent = props3,
                Size = fromOffset(0, 13),
                AutomaticSize = AutoSizeX,
                FontFace = FontExtraBold,
                TextSize = 9.5,
            })
            stateMap.l1 = props2
            stateMap.l2 = props3
            props4 = {
                Parent = stateMap.r,
                AnchorPoint = vector2New(1, 0),
            }
            props4.Position = UDim2.new(1, -10, 0, 5)
            props4.Size = fromOffset(0, 12)
            props4.AutomaticSize = AutoSizeX
            props4.FontFace = FontExtraBold
            props4.TextSize = 9
            props4.TextColor3 = Palette.a1
            props4.Text = ''
            stateMap.bd = createLabel(props4)
            stateMap.tg = createLabel({
                Parent = props3,
                LayoutOrder = 1,
                Size = fromOffset(0, 13),
                AutomaticSize = AutoSizeX,
                FontFace = FontBold,
                TextSize = 9.5,
                TextColor3 = color3FromRGB(201, 194, 255),
            })
            props3 = {
                Parent = stateMap.r,
                Position = fromOffset(60, 39),
            }
            props3.Size = UDim2.new(1, -152, 0, 15)
            props3.Visible = not compact
            props3[1] = createListLayout(8, nil, AlignCenterY, FillHorizontal)
            props4 = createFrame(props3)
            stateMap.v = createLabel({
                Parent = props4,
                Size = fromOffset(0, 15),
                AutomaticSize = AutoSizeX,
                FontFace = FontMono,
                TextSize = 12,
                TextColor3 = Palette.gv,
            })
            stateMap.b = createLabel({
                Parent = props4,
                LayoutOrder = 1,
                Size = fromOffset(0, 15),
                AutomaticSize = AutoSizeX,
                TextSize = 11,
                TextTransparency = 0.3,
            })
            props4 = {
                Parent = stateMap.r,
                AnchorPoint = RightCenterAnchor,
            }
            props4.Position = UDim2.new(1, -10, 0.5, 0)
            props4.Size = fromOffset(78, 32)
            props4.BackgroundTransparency = 0
            props4[1], props4[2], props4[3] = createCorner(11), createGradient(Palette.g1, Palette.g2), createLabel({
                Size = FullSize,
                FontFace = FontBold,
                TextSize = 12,
                TextColor3 = Palette.dk,
                TextXAlignment = AlignCenterX,
            })
            stateMap.k = createButton(props4)
            stateMap.kl = stateMap.k:FindFirstChildOfClass('TextLabel')

            bindPressScale(stateMap.k)
            onClick(stateMap.k, function()
                if stateMap.it then
                    if stateMap.it.act then
                        safeCall(stateMap.it.act, stateMap.it)
                    end
                end
            end)
            onClick(stateMap.r, function()
                if not stateMap.it then
                    return
                end

                id = stateMap.it.id

                for key, value in next, list do
                    updateBackgroundAlpha(value)
                end

                safeCall(stateMap.it.pick, stateMap.it)
            end)

            return stateMap
        end

        window.Set = function(_self, newValue, silent)
            label.Visible = #newValue == 0

            if silent then
                label.Text = silent
            end

            frame.Size = UDim2.new(1, 0, 0, #newValue == 0 and 34 or math.min(#newValue, rows) * count + 12)
            silent = {}

            for index2, item in ipairs(newValue) do
                local current = list[item.id] or applyTextStyle()

                list[item.id], silent[item.id] = current, true
                current.it = item
                current.r.LayoutOrder = index2

                local items, items2 = {
                    a = item.title,
                    pr = item.price or item.count,
                    rar = item.rarity,
                    tg = item.tags,
                    v = item.value,
                    b = item.sub,
                    kl = item.button,
                }, {
                    'a',
                    'pr',
                    'rar',
                    'tg',
                    'v',
                    'b',
                    'kl',
                }

                for index, value in ipairs(items2) do
                    index2 = items[value] or ''

                    if current[value].Text ~= index2 then
                        current[value].Text = index2
                    end
                end

                current.k.Visible = item.button ~= nil
                current.rar.Parent, current.rar.LayoutOrder, current.pr.Parent, current.pr.LayoutOrder = item.top and current.l1 or current.l2, item.top and 2 or 0, item.top and current.l2 or current.l1, item.top and 0 or 1

                if current.bd.Text ~= (item.badge or '') then
                    current.bd.Text = item.badge or ''
                end
                if not item.top then
                    current.pr.TextColor3, current.pr.TextSize = item.count and color3FromRGB(201, 194, 255) or Palette.gv, item.count and 13.5 or 12.5
                end
                if item.top and not current.fx then
                    current.fx = true
                    items2 = nil
                    items2, current.pr.FontFace, current.pr.TextSize, current.pr.TextColor3, current.pr.Size, current.l2.Size = UDim2.new, FontItalic, 15, Palette.wh, fromOffset(0, 17), UDim2.new(1, 
-152, 0, 17)
                    current.rar.FontFace, current.rar.TextSize = FontDisplay, 13.5
                    index2 = newInstance

                    newInstance('UIGradient', {
                        Parent = current.pr,
                        Color = GreenTextSeq,
                        Rotation = 90,
                    })

                    local items3 = {
                        current.pr,
                        current.rar,
                    }

                    for index, item2 in ipairs(items3) do
                        index = newInstance

                        newInstance('UIStroke', {
                            Parent = item2,
                            Thickness = 1.6,
                            Color = color3FromRGB(0, 0, 0),
                            Transparency = 0.05,
                        })
                    end
                end
                if current.g ~= item.grad then
                    items = current.rar:FindFirstChildOfClass('UIGradient')

                    if items then
                        items:Destroy()
                    end

                    current.g = item.grad

                    if item.grad then
                        item.grad:Clone().Parent = current.rar
                    end
                end

                current.rar.TextColor3 = item.grad and Palette.wh or item.color or Palette.val
                current.box.BackgroundColor3 = item.color or Palette.a1

                if current.im.Image ~= (item.image or '') then
                    current.im.Image = item.image or ''
                end

                updateBackgroundAlpha(current)
            end
            for key, value in next, list do
                if not (silent[key]) then
                    value.r:Destroy()

                    list[key] = nil
                end
            end
        end
        window.Select = function(_self, tab)
            id = tab

            for key, value in next, list do
                updateBackgroundAlpha(value)
            end
        end

        return window
    end

    -- ========================================================================
    -- 6. Showcase Cards, Rarity Slots & Mutation Badges
    -- ========================================================================
    local function applyClonedGradient(target, gradientTemplate)
        local uIGradient = target:FindFirstChildOfClass('UIGradient')

        if uIGradient then
            uIGradient:Destroy()
        end
        if gradientTemplate then
            gradientTemplate:Clone().Parent = target
        end
    end
    local function createStrokedLabel(props)
        props.FontFace, props.TextColor3 = FontDisplay, props.TextColor3 or Palette.wh
        props.TextTruncate = TruncateAtEnd

        local label = createLabel(props)

        newInstance('UIStroke', {
            Parent = label,
            Thickness = math.max(1.2, props.TextSize / 8),
            Color = color3FromRGB(0, 0, 0),
            Transparency = 0.05,
        })

        return label
    end

    local colorKeypoint, RarityPalettes = ColorSequenceKeypoint.new, {}

    RarityPalettes.COMMON = {
        color3FromRGB(30, 34, 42),
        color3FromRGB(104, 114, 132),
        color3FromRGB(214, 222, 236),
    }
    RarityPalettes.UNCOMMON = {
        color3FromRGB(6, 44, 22),
        color3FromRGB(36, 168, 84),
        color3FromRGB(160, 255, 170),
    }
    RarityPalettes.RARE = {
        color3FromRGB(6, 24, 78),
        color3FromRGB(36, 112, 255),
        color3FromRGB(140, 205, 255),
    }
    RarityPalettes.EPIC = {
        color3FromRGB(34, 8, 74),
        color3FromRGB(146, 56, 255),
        color3FromRGB(220, 170, 255),
    }
    RarityPalettes.LEGENDARY = {
        color3FromRGB(74, 30, 0),
        color3FromRGB(255, 146, 18),
        color3FromRGB(255, 228, 130),
    }
    RarityPalettes.MYTHIC = {
        color3FromRGB(72, 0, 22),
        color3FromRGB(255, 38, 88),
        color3FromRGB(255, 168, 190),
    }
    RarityPalettes.COSMIC = {
        color3FromRGB(22, 0, 40),
        color3FromRGB(128, 0, 154),
        color3FromRGB(236, 150, 255),
        color3FromRGB(92, 0, 190),
    }
    RarityPalettes.SECRET = {
        color3FromRGB(0, 0, 0),
        color3FromRGB(52, 52, 64),
        color3FromRGB(255, 255, 255),
        stars = true,
    }
    RarityPalettes.ETERNAL = {
        color3FromRGB(4, 20, 56),
        color3FromRGB(30, 196, 220),
        color3FromRGB(255, 160, 255),
        color3FromRGB(196, 80, 255),
        shine = true,
    }
    RarityPalettes.DIVINE = {
        color3FromRGB(84, 54, 0),
        color3FromRGB(255, 196, 50),
        color3FromRGB(255, 252, 220),
        color3FromRGB(255, 236, 150),
        shine = true,
        star = color3FromRGB(255, 255, 255),
        rays = true,
    }

    local function getRarityColors(item)
        local color, current, current2 = item.color or Palette.a1, RarityPalettes[item.rarity]

        if current then
            current2 = current
        else
            local list, current3, wh = {}, color:Lerp(color3FromRGB(0, 0, 0), 0.75), Palette.wh

            list[1], list[2], list[3] = current3, color, color:Lerp(wh, 0.6)
            current2 = list
        end

        return current2
    end
    local function createRaritySlot(parent, frameProps, cornerRadius, ringSizes)
        frameProps.Parent = parent
        frameProps.ClipsDescendants = true
        parent = createSolidFrame(frameProps)
        frameProps = {
            f = parent,
            g = createGradient(Palette.wh, Palette.wh, 120),
            h = {},
            st = {},
            ss = {},
            sh = createAlphaGradient(30, {0, 1}, {0.4, 1}, {0.5, 0.55}, {0.6, 1}, {1, 1}),
        }
        createCorner(cornerRadius).Parent, frameProps.g.Parent = parent, parent

        for index, value in ipairs(ringSizes) do
            local current, props = frameProps.h, {
                Parent = parent,
                AnchorPoint = CenterAnchor,
                Position = CenterPos,
                Size = fromOffset(value, value),
            }

            props.BackgroundTransparency = 0.96 - index * 0.1
            props[1] = createCorner()
            current[index] = createSolidFrame(props)
        end

        local items = {
            {0.13, 0.28, 13},
            {0.87, 0.2, 10},
            {0.84, 0.72, 12},
        }

        for index2, item in ipairs(items) do
            local sizePos, ss, props, _unused = fromOffset(item[3] * ringSizes[1] / 95, item[3] * ringSizes[1] / 95), frameProps.ss, {
                Parent = parent,
                AnchorPoint = CenterAnchor,
            }, UDim2.new

            props.Position = UDim2.new(item[1], 1.5, item[2], 1.5)
            props.Size = sizePos
            props.Image = 'sparkles'
            props.ImageColor3 = color3FromRGB(90, 50, 0)
            props.ZIndex = 2
            ss[index2] = createImage(props)
            props, ss, cornerRadius = frameProps.st, {
                Parent = parent,
                AnchorPoint = CenterAnchor,
            }, UDim2.new
            ss.Position = UDim2.new(item[1], 0, item[2], 0)
            ss.Size = sizePos
            ss.Image = 'sparkles'
            ss.ZIndex = 2
            props[index2] = createImage(ss)
        end

        frameProps.sf = createFrame({
            Parent = parent,
            Size = FullSize,
            BackgroundColor3 = Palette.wh,
            BackgroundTransparency = 0,
            ZIndex = 4,
            frameProps.sh,
        })

        return frameProps
    end
    local function applyRaritySlot(slot, palette)
        slot.g.Color = ColorSequence.new({
            colorKeypoint(0, palette[2]),
            colorKeypoint(0.5, palette[4] or palette[1]:Lerp(palette[2], 0.4)),
            colorKeypoint(1, palette[1]),
        })

        for index, value in ipairs(slot.h) do
            value.BackgroundColor3 = palette[3]
        end

        if palette.rays then
            if not slot.ry then
                local labelProps = {
                    Parent = slot.f,
                    AnchorPoint = CenterAnchor,
                    Position = CenterPos,
                }

                labelProps.Size = UDim2.new(1.5, 0, 1.5, 0)
                labelProps.SizeConstraint = Enum.SizeConstraint.RelativeXX
                labelProps.Image = 'rbxassetid://109516122757226'
                labelProps.ImageColor3 = color3FromRGB(255, 250, 215)
                labelProps.ImageTransparency = 0.3
                labelProps.ScaleType = Enum.ScaleType.Fit
                slot.ry = rawImageLabel(labelProps)
            end
        end
        if slot.ry then
            slot.ry.Visible = palette.rays == true
        end

        slot.sf.Visible = slot.live and palette.shine == true

        for index, value in ipairs(slot.st) do
            value.Visible, value.ImageColor3 = palette.shine or palette.stars or false, palette.star or palette[3]
            value.ImageTransparency = 0.15
            slot.ss[index].Visible, slot.ss[index].ImageTransparency = value.Visible and palette.star ~= nil, 0.55
        end
        for index, value in ipairs(slot.tw or {}) do
            value:Cancel()
        end

        slot.tw = {}

        if slot.live then
            if not palette.shine then
                if not palette.rays then
                    return
                end
            end
        else
            return
        end

        local function updateView(param1, param2, param3, enabled, param5)
            local tweenInfoNew, current = TweenInfo.new

            if enabled then
                current = Enum.EasingStyle.Sine
            else
                current = enabled
            end

            local C15

            if current then
                C15 = current
            else
                C15 = Enum.EasingStyle.Linear
            end

            local current2 = TweenService:Create(param1, tweenInfoNew(param2, C15, Enum.EasingDirection.InOut, 
-1, enabled == true, param5 or 0), param3)

            current2:Play()

            slot.tw[#slot.tw + 1] = current2
        end

        slot.h[#slot.h].BackgroundTransparency = 0.82

        updateView(slot.h[#slot.h], 1.3, {BackgroundTransparency = 0.62}, true)

        if palette.rays then
            slot.ry.Rotation = 0

            updateView(slot.ry, 30, {Rotation = 360})
        end
        if palette.shine then
            slot.sh.Offset = vector2New(-1, 0)

            updateView(slot.sh, 1.2, {
                Offset = vector2New(1, 0),
            }, false, 2.2)

            for index, value in ipairs(slot.st) do
                value.ImageTransparency, slot.ss[index].ImageTransparency = 0.4, 0.95

                updateView(value, 0.9 + index * 0.25, {ImageTransparency = 0}, true)
                updateView(slot.ss[index], 0.9 + index * 0.25, {ImageTransparency = 0.55}, true)
            end
        end
    end
    local function applyGreenGradient(label)
        label.FontFace = FontItalic

        newInstance('UIGradient', {
            Parent = label,
            Color = GreenTextSeq,
            Rotation = 90,
        })

        return label
    end
    local function makeTriColorSeq(startCol, midCol, endCol)
        return ColorSequence.new({
            colorKeypoint(0, startCol),
            colorKeypoint(0.5, midCol),
            colorKeypoint(1, endCol),
        })
    end

    local MutationGradients = {}

    MutationGradients.GOLDEN = makeTriColorSeq(color3FromRGB(255, 250, 190), color3FromRGB(255, 204, 40), color3FromRGB(255, 140, 0))
    MutationGradients.SILVER = makeTriColorSeq(color3FromRGB(255, 255, 255), color3FromRGB(196, 214, 246), color3FromRGB(120, 146, 196))
    MutationGradients.RAINBOW = ColorSequence.new({
        colorKeypoint(0, color3FromRGB(255, 70, 70)),
        colorKeypoint(0.25, color3FromRGB(255, 220, 60)),
        colorKeypoint(0.5, color3FromRGB(80, 255, 110)),
        colorKeypoint(0.75, color3FromRGB(80, 170, 255)),
        colorKeypoint(1, color3FromRGB(220, 90, 255)),
    })
    MutationGradients.NITRO = makeTriColorSeq(color3FromRGB(255, 244, 130), color3FromRGB(255, 150, 30), color3FromRGB(255, 60, 20))
    MutationGradients.SCRAMBLED = makeTriColorSeq(color3FromRGB(240, 205, 255), color3FromRGB(186, 110, 255), color3FromRGB(130, 50, 240))
    MutationGradients.FRACTURED = makeTriColorSeq(color3FromRGB(255, 196, 186), color3FromRGB(255, 84, 84), color3FromRGB(200, 20, 40))
    MutationGradients.ENCHANTED = makeTriColorSeq(color3FromRGB(210, 255, 255), color3FromRGB(80, 225, 255), color3FromRGB(30, 150, 255))
    MutationGradients.BLOOM = makeTriColorSeq(color3FromRGB(255, 228, 244), color3FromRGB(255, 140, 210), color3FromRGB(240, 70, 160))
    MutationGradients['SPIRIT BLOOM'] = makeTriColorSeq(color3FromRGB(230, 255, 210), color3FromRGB(130, 245, 130), color3FromRGB(40, 190, 90))
    MutationGradients.PARASITE = makeTriColorSeq(color3FromRGB(236, 255, 180), color3FromRGB(150, 240, 70), color3FromRGB(70, 180, 30))

    local function createMutationGradient(tagData)
        local current, _unused = tagData.c or Palette.a1

        return newInstance('UIGradient', {
            Color = MutationGradients[tagData.n:gsub('^%+', '')] or makeTriColorSeq(current:Lerp(Palette.wh, 0.6), current, current:Lerp(color3FromRGB(0, 0, 0), 0.25)),
            Rotation = tagData.n == 'RAINBOW' and 0 or 90,
        })
    end
    local function renderMutationTags(container, tags, rowHeight, textSize)
        for index, child in ipairs(container:GetChildren()) do
            if child:IsA('GuiObject') then
                child:Destroy()
            end
        end
        for index, value in ipairs(tags or {}) do
            local label = createStrokedLabel({
                Parent = container,
                LayoutOrder = index,
                Size = fromOffset(0, rowHeight),
                AutomaticSize = AutoSizeX,
                TextSize = textSize,
                Text = value.n,
            })

            label:FindFirstChildOfClass('UIStroke').Thickness = textSize / 5
            createMutationGradient(value).Parent = label
        end
    end
    local function setSpriteRect(imageLabel, iconName)
        local current = IconIndex[iconName]

        imageLabel.ImageRectOffset = vector2New(current % 8 * 64, current // 8 * 64)
    end
    local function createGridRow(parent, columns, rowHeight, gap, layoutOrder)
        local props = {
            Parent = parent,
            LayoutOrder = layoutOrder,
        }

        props.Size = UDim2.new(1, 0, 0, rowHeight)
        layoutOrder = {}
        layoutOrder.CellSize = UDim2.new(1 / columns, -gap * (columns - 1) / columns - 1, 0, rowHeight)
        layoutOrder.CellPadding = fromOffset(gap, gap)
        layoutOrder.SortOrder = Enum.SortOrder.LayoutOrder
        props[1] = newInstance('UIGridLayout', layoutOrder)

        return createFrame(props)
    end
    local function createPillBadge(parent, textSize)
        local frame = createFrame({
            Parent = parent,
            Size = fromOffset(0, textSize + 8),
            AutomaticSize = AutoSizeX,
            BackgroundTransparency = 0.05,
            createCorner(),
            createStroke(0.2),
            createPadding(0, 9),
        })

        return frame, createStrokedLabel({
            Parent = frame,
            Size = fromOffset(0, textSize + 8),
            AutomaticSize = AutoSizeX,
            TextSize = textSize,
            TextXAlignment = AlignCenterX,
        })
    end
    local function applyRarityPill(pillFrame, pillLabel, palette, item)
        pillFrame.BackgroundColor3 = palette[1]
        pillFrame:FindFirstChildOfClass('UIStroke').Color = palette[2]
        pillLabel.Text = item.rarity or ''

        applyClonedGradient(pillLabel, item.grad)

        pillLabel.TextColor3 = item.grad and Palette.wh or item.color or Palette.tx
    end
    local function sampleColorSeq(colorSeq, alpha)
        local keypoints = colorSeq.Keypoints

        for index = 2, #keypoints, 1 do
            if alpha <= keypoints[index].Time then
                local value, value2, current = keypoints[index - 1].Value, keypoints[index].Value, (alpha - keypoints[index - 1].Time) / math.max(keypoints[index].Time - keypoints[index - 1].Time, 1E-4)

                return value:Lerp(value2, current)
            end
        end

        return keypoints[#keypoints].Value
    end

    local ClampedGradientCache = {}

    local function applyTopHalfGradient(target, item)
        local isMatch = (item.rarity == 'ETERNAL' or item.rarity == 'DIVINE') and item.grad

        if isMatch then
            if math.abs(isMatch.Rotation) == 90 then
                if not (ClampedGradientCache[isMatch]) then
                    local isMatch2, isMatch3, list = isMatch.Rotation < 0 and 0.53 or 0, isMatch.Rotation < 0 and 1 or 0.5, {}

                    for index = 0, 8, 1 do
                        list[#list + 1] = colorKeypoint(index / 8, sampleColorSeq(isMatch.Color, isMatch2 + (isMatch3 - isMatch2) * index / 8))
                    end

                    ClampedGradientCache[isMatch] = newInstance('UIGradient', {
                        Color = ColorSequence.new(list),
                        Rotation = isMatch.Rotation,
                    })
                end

                isMatch = ClampedGradientCache[isMatch]
            end
        end

        applyClonedGradient(target, isMatch or nil)
    end

    Section.Showcase = function(self, gridCols, categories, onCategory, onAction)
        local top, activeWin, count = self.t.top or self.t, self.W, 364
        local stroke, gradient = createStroke(0.5), createFrame
        local props = createFrame({
            Parent = self.f,
            LayoutOrder = self.n + 1,
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
        })

        self:Add(props, '')

        local props2, props3, props4 = nil, {
            Parent = props,
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
        }

        props3[1], props3[2] = createPadding(2, 14, 6), createListLayout(8)
        props4, gradient = createFrame(props3), createFrame
        props2 = {Parent = props4}
        props2.Size = UDim2.new(1, 0, 0, 30)

        local container, props5, props6, listLayout = createFrame(props2), createFrame, {
            Parent = props4,
            LayoutOrder = 1,
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
        }, createListLayout

        props6[1] = createListLayout(14, nil, nil, FillHorizontal)
        self, listLayout, props, props3 = createFrame(props6), createFrame, {}, createFrame
        props.Parent = createFrame({
            Parent = self,
            Size = fromOffset(250, 370),
            createPadding(3, 0),
        })
        props.Size = FullSize
        props.BackgroundTransparency = 0.45
        props[1], props[2], props[3], props[4] = createCorner(20), stroke, createPadding(9), createListLayout(6, AlignRightX)

        local props7, stateMap, entry2, new = createFrame(props), {}, {}, UDim2.new

        entry2.Size = UDim2.new(1, 0, 0, 145)
        stateMap.a = createRaritySlot(props7, entry2, 14, {170, 126, 84})
        stateMap.a.live = true
        props6 = {
            Parent = stateMap.a.f,
            AnchorPoint = CenterAnchor,
        }
        props6.Position = UDim2.new(0.5, 0, 0.5, 2)
        props6.Size = fromOffset(138, 138)
        props6.ScaleType = Enum.ScaleType.Fit
        props6.ZIndex = 3
        stateMap.im = rawImageLabel(props6)
        props4 = {
            Parent = stateMap.a.f,
        }
        props4.AnchorPoint = TopRightAnchor
        props4.Position = UDim2.new(1, -8, 0, 7)
        props4.Size = fromOffset(0, 0)
        props4.AutomaticSize = Enum.AutomaticSize.XY
        props4.ZIndex = 5
        props4[1] = createListLayout(2, Enum.HorizontalAlignment.Right)
        stateMap.mu = createFrame(props4)
        props6 = {
            Parent = props7,
            LayoutOrder = 1,
        }
        props6.Size = UDim2.new(1, 0, 0, 24)
        props6.Text = 'Pick an egg'
        props6.TextSize = 21
        props6.TextXAlignment = AlignCenterX
        stateMap.ti = createStrokedLabel(props6)
        stateMap.rb, stateMap.ra = createPillBadge(props7, 13)
        stateMap.rb.LayoutOrder = 2
        props = {
            Parent = props7,
            LayoutOrder = 3,
        }
        props.Size = UDim2.new(1, 0, 0, 30)
        props.TextSize = 26
        props.TextXAlignment = AlignCenterX
        stateMap.va = applyGreenGradient(createStrokedLabel(props))

        local props8, list, props9, props10 = createGridRow(props7, 2, 34, 6, 4), {}, ipairs, {
            {
                'gauge',
                'Size',
            },
            {
                'gem',
                'Weight',
            },
        }

        for index, item in ipairs(props10) do
            gradient = createFrame
            listLayout = createFrame({
                Parent = props8,
                LayoutOrder = index,
                BackgroundTransparency = 0.55,
                BackgroundColor3 = color3FromRGB(0, 0, 0),
                createCorner(10),
            })
            props3, props4 = {
                Parent = listLayout,
                AnchorPoint = vector2New(0, 0.5),
            }, UDim2.new
            props3.Position = UDim2.new(0, 8, 0.5, 0)
            props3.Size = fromOffset(15, 15)
            props3.Image = item[1]

            createImage(props3)

            props5, new = {
                Parent = listLayout,
                Position = fromOffset(29, 3),
            }, UDim2.new
            props5.Size = UDim2.new(1, -34, 0, 16)
            props5.TextSize = 13
            list[index] = createStrokedLabel(props5)
            entry2, props6 = {
                Parent = listLayout,
                Position = fromOffset(29, 19),
            }, UDim2.new
            entry2.Size = UDim2.new(1, -34, 0, 11)
            entry2.Text = item[2]:upper()
            entry2.FontFace = FontExtraBold
            entry2.TextSize = 8
            entry2.TextTransparency = 0.45

            createLabel(entry2)
        end

        props2 = {
            Parent = props7,
            LayoutOrder = 5,
        }
        props2.Size = UDim2.new(1, 0, 0, 22)
        props2.BackgroundTransparency = 0.55
        props2.BackgroundColor3 = color3FromRGB(0, 0, 0)
        props2.ClipsDescendants = true
        props2[1] = createCorner(8)
        props10 = createFrame(props2)
        props8 = {
            Parent = props10,
            AnchorPoint = vector2New(0, 0.5),
        }
        props8.Position = UDim2.new(0, 8, 0.5, 0)
        props8.Size = fromOffset(14, 14)
        props8.Image = 'clock'
        stateMap.si = createImage(props8)
        props2 = {
            Parent = props10,
            Position = fromOffset(28, 0),
        }
        props2.Size = UDim2.new(1, -36, 1, 0)
        props2.TextSize = 11
        list[3] = createStrokedLabel(props2)
        props3 = {
            Parent = props10,
            AnchorPoint = vector2New(0, 1),
        }
        props3.Position = UDim2.new(0, 0, 1, 0)
        props3.Size = UDim2.new(0, 0, 0, 3)
        stateMap.bf = createSolidFrame(props3)
        props6, props8 = {}, {
            Parent = props7,
            LayoutOrder = 6,
        }
        props8.Size = UDim2.new(1, 0, 0, 34)
        props6.Parent = createFrame(props8)
        props6.Size = FullSize
        props6.BackgroundTransparency = 0
        props2, gradient, props, new, entry2 = createCorner(12), createGradient(Palette.a1, Palette.a2, 90), Palette.a1, Palette.wh, createListLayout
        props6[1], props6[2], props6[3], props6[4] = props2, gradient, createStroke(0.55, props:Lerp(new, 0.5)), createListLayout(7, AlignRightX, AlignCenterY, FillHorizontal)

        local button = createButton(props6)
        local image = createImage({
            Parent = button,
            Size = fromOffset(17, 17),
            Image = 'hand',
            ImageColor3 = Palette.on,
        })
        local label = createLabel({
            Parent = button,
            LayoutOrder = 1,
            Size = fromOffset(0, 34),
            AutomaticSize = AutoSizeX,
            FontFace = FontBold,
            TextSize = 15,
            TextColor3 = Palette.on,
        })

        bindPressScale(button)

        local current

        onClick(button, function()
            if current then
                safeCall(onAction, current)
            end
        end)

        props = {Parent = container}
        props.Size = UDim2.new(1, -128, 1, 0)
        props.BackgroundTransparency = 0.93
        props[1], props[2], props[3] = createCorner(), createStroke(0.9), createPadding(3)
        listLayout, new, props10, gradient = createFrame(props), createFrame, {Parent = container}, TopRightAnchor
        props10.AnchorPoint = TopRightAnchor
        props10.Position = UDim2.new(1, 0, 0, 0)
        props10.Size = fromOffset(120, 30)
        props10.BackgroundTransparency = 0.8
        props10.BackgroundColor3 = color3FromRGB(60, 210, 80)
        props10[1], props10[2], props10[3] = createCorner(), createStroke(0.5, color3FromRGB(96, 238, 92)), createListLayout(0, AlignRightX, AlignCenterY, FillHorizontal)

        local current2, props11, _unused = applyGreenGradient(createStrokedLabel({
            Parent = createFrame(props10),
            Size = fromOffset(0, 30),
            AutomaticSize = AutoSizeX,
            Text = '--',
            TextSize = 14,
        })), {Parent = listLayout}, UDim2.new

        props11.Size = UDim2.new(1 / #categories, 0, 1, 0)
        props11[1], props11[2] = createCorner(), createGradient(Palette.a1, Palette.a2)

        local box, list2, count2 = createSolidFrame(props11), {}, 1
        local gridRow, list3 = createGridRow(listLayout, #categories, 24, 0), {}

        for index2, item2 in ipairs(categories) do
            props9, props3 = {
                Parent = gridRow,
                LayoutOrder = index2,
            }, createListLayout
            props9[1] = createListLayout(5, AlignRightX, AlignCenterY, FillHorizontal)
            entry2 = createButton(props9)
            list3[index2] = createImage({
                Parent = entry2,
                Size = fromOffset(14, 14),
                Image = item2[2],
                ImageColor3 = index2 == 1 and Palette.dk or Palette.tx,
            })
            list2[index2] = createLabel({
                Parent = entry2,
                LayoutOrder = 1,
                Size = fromOffset(0, 24),
                AutomaticSize = AutoSizeX,
                Text = item2[1]:upper(),
                FontFace = FontExtraBold,
                TextSize = 10,
                TextColor3 = index2 == 1 and Palette.dk or Palette.tx,
            })

            onClick(entry2, function()
                list2[count2].TextColor3, list3[count2].ImageColor3 = Palette.tx, Palette.tx
                count2 = index2
                list2[index2].TextColor3, list3[index2].ImageColor3, list3[index2].Size = Palette.dk, Palette.dk, fromOffset(20, 20)

                tween(list3[index2], {
                    Size = fromOffset(14, 14),
                }, 0.45, EaseBack)

                local props12 = {}

                props12.Position = UDim2.new((index2 - 1) / #categories, 0, 0, 0)

                tween(box, props12, 0.3)
                safeCall(onCategory, item2[1])
            end)
        end

        props11 = {
            Parent = self,
            LayoutOrder = 1,
        }
        props11.Size = UDim2.new(1, -264, 0, 370)

        local props12 = createFrame(props11)
        local scrollFrame = createScrollFrame({
            Parent = props12,
            Size = FullSize,
            ScrollingEnabled = UserInputService.TouchEnabled,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = Palette.wh,
            ScrollBarImageTransparency = 0.6,
        })

        activeWin.nest[scrollFrame] = top

        activeWin:Grip(scrollFrame, props12)

        local props13 = createGridRow(scrollFrame, gridCols, 178, 8)

        props5 = nil
        props5, props13.Position, props13.Size = UDim2.new, fromOffset(3, 3), UDim2.new(1, -16, 0, 0)
        props13.AutomaticSize = AutoSizeY
        createPadding(0, 0, 3, 0).Parent = props13
        props11 = {Parent = scrollFrame}
        props11.Size = UDim2.new(1, 0, 0, 40)
        props11.Text = 'No eggs yet'
        props11.TextSize = 12
        props11.TextTransparency = 0.45
        props11.TextXAlignment = AlignCenterX

        local label2, list4, list5, stateMap2 = createLabel(props11), {}, {}, {}

        local function updateView(text)
            local isMatch = current ~= text and ((if current then not text else not current) or current.id ~= text.id or current.muts ~= text.muts)

            current = text
            text = text or {}

            local palette = getRarityColors(text)

            if isMatch ~= false then
                applyRaritySlot(stateMap.a, palette)
                applyRarityPill(stateMap.rb, stateMap.ra, palette, text)
                applyTopHalfGradient(stateMap.ti, text)

                props7.BackgroundColor3, stroke.Color = palette[1], palette[2]
            end
            if stateMap.m ~= text.muts then
                stateMap.m = text.muts

                renderMutationTags(stateMap.mu, text.muts, 20, 13)
            end

            stateMap.im.Image, stateMap.ti.Text, stateMap.va.Text = text.image or '', text.title or 'Pick an egg', text.value or '--'

            local items2 = {
                text.size,
                text.weight,
                text.status,
            }

            for index, item in ipairs(items2) do
                list[index].Text = item or '--'
            end

            items2 = text.kind == 'Ready' and {
                'sparkles',
                Palette.mint,
            } or text.kind == 'Growing' and {
                'clock',
                Palette.wh,
            } or {
                'egg',
                palette[3],
            }

            setSpriteRect(stateMap.si, items2[1])

            stateMap.si.ImageColor3, list[3].TextColor3 = items2[2], items2[2]
            items2 = nil
            items2, stateMap.bf.Size, stateMap.bf.BackgroundColor3 = UDim2.new, UDim2.new(text.kind == 'Growing' and text.pct or 0, 0, 0, 3), palette[3]
            button.Parent.Visible, label.Text = text.label ~= nil, text.label or ''

            setSpriteRect(image, ({
                ['Hatch now'] = 'sparkles',
                ['Go to egg'] = 'pin',
            })[text.label] or 'hand')
        end
        local function updateViewportVisibility()
            local current3, current4 = scrollFrame.AbsolutePosition.Y, scrollFrame.AbsoluteSize.Y

            for key, value in next, list4 do
                key = value.c.AbsolutePosition.Y - current3

                local isMatch = key > -value.c.AbsoluteSize.Y - 60 and key < current4 + 60

                if value.box.Visible ~= isMatch then
                    value.box.Visible = isMatch
                end
            end
        end

        connectSignal(scrollFrame:GetPropertyChangedSignal('CanvasPosition'), updateViewportVisibility)
        connectSignal(scrollFrame:GetPropertyChangedSignal('AbsoluteSize'), updateViewportVisibility)

        local function updateBackgroundAlpha()
            local current3 = table.remove(list5)

            if current3 then
                current3.c.Visible = true

                return current3
            end

            local stateMap3 = {}

            stateMap3.s = createStroke(0.1)
            stateMap3.c = createButton({
                Parent = props13,
                BackgroundTransparency = 0.3,
                createCorner(18),
                stateMap3.s,
            })

            local props14

            stateMap3.box = createFrame({
                Parent = stateMap3.c,
                Size = FullSize,
            })

            local entry3, props15, udim2 = stateMap3.box, {
                Position = fromOffset(5, 5),
            }

            props15.Size = UDim2.new(1, -10, 0, 108)
            stateMap3.a = createRaritySlot(entry3, props15, 14, {118, 86, 56})
            entry3 = {
                Parent = stateMap3.a.f,
                AnchorPoint = CenterAnchor,
                Position = CenterPos,
                Size = fromOffset(96, 96),
            }
            entry3.ScaleType = Enum.ScaleType.Fit
            entry3.ZIndex = 3
            stateMap3.im = rawImageLabel(entry3)
            stateMap3.rk = createStrokedLabel({
                Parent = stateMap3.a.f,
                Position = fromOffset(7, 5),
                Size = fromOffset(30, 15),
                TextSize = 12,
                ZIndex = 5,
            })
            udim2 = {
                Parent = stateMap3.a.f,
                AnchorPoint = vector2New(0, 1),
            }
            udim2.Position = UDim2.new(0, 7, 1, -6)
            udim2.Size = fromOffset(64, 15)
            udim2.TextSize = 12
            udim2.ZIndex = 5
            stateMap3.tm = createStrokedLabel(udim2)
            props15 = {
                Parent = stateMap3.a.f,
                AnchorPoint = vector2New(1, 1),
            }
            props15.Position = UDim2.new(1, -7, 1, -6)
            props15.Size = fromOffset(48, 15)
            props15.TextSize = 11
            props15.TextXAlignment = Enum.TextXAlignment.Right
            props15.ZIndex = 5
            stateMap3.sz = createStrokedLabel(props15)
            udim2 = {
                Parent = stateMap3.a.f,
            }
            udim2.AnchorPoint = TopRightAnchor
            udim2.Position = UDim2.new(1, -5, 0, 4)
            udim2.Size = fromOffset(0, 0)
            udim2.AutomaticSize = Enum.AutomaticSize.XY
            udim2.ZIndex = 5
            udim2[1] = createListLayout(1, Enum.HorizontalAlignment.Right)
            stateMap3.mt = createFrame(udim2)
            props15 = {
                Parent = stateMap3.box,
                Position = fromOffset(8, 117),
            }
            props15.Size = UDim2.new(1, -16, 0, 18)
            props15.TextSize = 14
            props15.TextXAlignment = AlignCenterX
            stateMap3.ti = createStrokedLabel(props15)
            props15 = {
                Parent = stateMap3.box,
                Position = fromOffset(8, 137),
            }
            props15.Size = UDim2.new(1, -16, 0, 17)
            props15[1] = createListLayout(0, AlignRightX)
            entry3 = createFrame(props15)
            stateMap3.rb, stateMap3.ra = createPillBadge(entry3, 10)
            stateMap3.rb.BackgroundTransparency, stateMap3.rb:FindFirstChildOfClass('UIStroke').Enabled = 1, false

            stateMap3.rb:FindFirstChildOfClass('UIPadding'):Destroy()

            udim2 = {
                Parent = stateMap3.box,
                Position = fromOffset(8, 156),
            }
            udim2.Size = UDim2.new(1, -16, 0, 17)
            udim2.TextSize = 14
            udim2.TextXAlignment = AlignCenterX
            stateMap3.va = applyGreenGradient(createStrokedLabel(udim2))
            props14 = {
                Parent = stateMap3.a.f,
                AnchorPoint = vector2New(0, 1),
            }
            props14.Position = UDim2.new(0, 0, 1, 0)
            props14.Size = UDim2.new(0, 0, 0, 3)
            props14.ZIndex = 5
            stateMap3.bf = createSolidFrame(props14)

            onClick(stateMap3.c, function()
                if not stateMap3.it then
                    return
                end

                stateMap2.sel = stateMap3.it.id

                for _, value in next, list4 do
                    value.s.Thickness = value.it.id == stateMap2.sel and 2.5 or 1.2
                end

                updateView(stateMap3.it)
            end)

            return stateMap3
        end

        stateMap2.Set = function(self2, newValue, silent, param4)
            label2.Visible, current2.Text = #newValue == 0, param4 or '--'

            for index, entry4 in ipairs(categories) do
                list2[index].Text = entry4[1]:upper() .. (silent and silent[entry4[1] ] and '  ' .. silent[entry4[1] ] or '')
            end

            self2, silent, param4 = {}, ipairs

            for index2, entry5 in ipairs(newValue) do
                local current3 = list4[entry5.id] or updateBackgroundAlpha()

                list4[entry5.id], self2[entry5.id] = current3, true
                current3.it = entry5
                current3.c.LayoutOrder = index2

                local palette = getRarityColors(entry5)

                if current3.p ~= palette then
                    current3.p = palette

                    applyRaritySlot(current3.a, palette)
                    applyRarityPill(current3.rb, current3.ra, palette, entry5)
                    applyTopHalfGradient(current3.ti, entry5)

                    current3.c.BackgroundColor3, current3.s.Color = palette[1], palette[2]
                end

                current3.s.Thickness = entry5.id == stateMap2.sel and 2.5 or 1.2

                if current3.im.Image ~= entry5.image then
                    current3.im.Image = entry5.image or ''
                end

                current3.rk.Text, current3.ti.Text, current3.va.Text, current3.tm.Text, current3.sz.Text = '#' .. (entry5.rank or index2), entry5.title, entry5.value, entry5.time or '', entry5.size or ''
                index2 = ''

                for index, value in ipairs(entry5.muts or {}) do
                    index2 ..= value.n .. ','
                end

                if current3.mk ~= index2 then
                    current3.mk = index2

                    renderMutationTags(current3.mt, entry5.muts, 14, 9)
                end

                index2 = nil
                index2, current3.bf.Size, current3.bf.BackgroundColor3 = UDim2.new, UDim2.new(entry5.pct or 0, 0, 0, 3), entry5.ready and Palette.mint or palette[3]
                param4 = if entry5.id == stateMap2.sel then entry5 else param4
            end
            for key, value in next, list4 do
                if not (self2[key]) then
                    value.c.Visible = false
                    value.it = nil
                    value.p = nil
                    value.mk = nil
                    list4[key], list5[#list5 + 1] = nil, value
                end
            end

            task.defer(updateViewportVisibility)

            param4 = param4 or newValue[1]
            stateMap2.sel = param4 and param4.id

            updateView(param4)
        end
        stateMap2.Card = function(callback, visible)
            props7.Parent.Visible = visible
            props12.Size = UDim2.new(1, visible and -264 or 0, 0, count + 6)
        end

        updateView(nil)

        return stateMap2
    end
    Section.Order = function(self, title, items, callback)
        local control = {}

        control.Value = table.clone(items)

        local container, props, udim2 = nil, {
            Parent = self.f,
            LayoutOrder = self.n + 1,
        }

        props.Size = UDim2.new(1, 0, 0, #items * 34 + 12)
        udim2 = createFrame(props)

        self:Add(udim2, title, true)

        local list = {}

        props = #items

        for index = 1, props, 1 do
            local createFrame3, entry6, udim2 = nil, {
                Parent = udim2,
                Position = fromOffset(14, 6 + (index - 1) * 34),
            }, UDim2.new

            entry6.Size = UDim2.new(1, -28, 0, 30)
            entry6.BackgroundTransparency = 0.95
            entry6[1] = createCorner(9)
            container = createFrame(entry6)

            createLabel({
                Parent = container,
                Position = fromOffset(10, 0),
                Size = fromOffset(20, 30),
                Text = tostring(index),
                FontFace = FontMono,
                TextSize = 12,
                TextTransparency = 0.45,
            })

            createFrame3 = {
                Parent = container,
                Position = fromOffset(34, 0),
            }
            createFrame3.Size = UDim2.new(1, -110, 1, 0)
            createFrame3.FontFace = FontBold
            createFrame3.TextSize = 13
            list[index] = createLabel(createFrame3)
            entry6, createFrame3 = ipairs, {
                -1,
                1,
            }

            for index2, item in ipairs(createFrame3) do
                local btnProps, _ = {
                    Parent = container,
                    AnchorPoint = RightCenterAnchor,
                }, UDim2.new

                btnProps.Position = UDim2.new(1, index2 == 1 and -38 or -6, 0.5, 0)
                btnProps.Size = fromOffset(28, 24)
                btnProps.BackgroundTransparency = 0.9
                btnProps[1], btnProps[2] = createCorner(7), createIcon('down', 14)
                index2 = createButton(btnProps)
                index2:FindFirstChildWhichIsA('ImageLabel').Rotation = item < 0 and 180 or 0

                bindPressScale(index2)
                onClick(index2, function()
                    local value, current = control.Value, index + item

                    if current < 1 then
                        return
                    elseif current > #value then
                        return
                    end

                    value[index], value[current] = value[current], value[index]

                    control:Set(value)
                end)
            end
        end

        control.Set = function(self2, newValue, silent)
            local list2, list3 = {}, {}

            for _, entry7 in ipairs(type(newValue) == 'table' and newValue or {}) do
                if table.find(items, entry7) then
                    if not (list2[entry7]) then
                        list2[entry7] = true
                        list3[#list3 + 1] = entry7
                    end
                end
            end
            for entry8, value in ipairs(items) do
                if not (list2[value]) then
                    newValue = #list3 + 1

                    for index = entry8 + 1, #items, 1 do
                        self2 = table.find(list3, items[index])

                        if self2 then
                            newValue = self2

                            break
                        end
                    end

                    table.insert(list3, newValue, value)
                end
            end

            control.Value = list3

            for index, value in ipairs(list) do
                value.Text = list3[index]
            end

            if not silent then
                safeCall(callback, list3)
            end
        end

        control:Set(items, true)

        return self:Reg(title, control)
    end
    Section.Text = function(self, initialText)
        local label = createLabel({
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
            Text = initialText,
            TextSize = 12,
            TextTransparency = 0.22,
            TextWrapped = true,
        })

        self.tn = (self.tn or 0) + 1

        local props = {
            Parent = self.f,
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
            LayoutOrder = -1E3 + self.tn,
            Visible = initialText ~= '',
        }

        props[1] = createFrame({
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
            createPadding(12, 14),
            label,
        })

        local frame = createFrame(props)

        if self.n >= self.tn then
            createDivider(frame, UDim2.new(0, 14, 1, -1), UDim2.new(1, -28, 0, 1))
        end

        self.n = self.n + 1

        return {
            Set = function(_unused, visible)
                label.Text, frame.Visible = visible, visible ~= ''
            end,
        }
    end
    -- ========================================================================
    -- 7. Notifications, Config Persistence & Live Theme Engine
    -- ========================================================================
    Venyx.Notify = function(_self, title, subtitle, kind, duration)
        local callback
        local props = Venyx.W

        if not props then
            return
        end

        duration = duration or 4

        local accentColor, iconName = getStatusStyle(kind)
        local container = createFrame({
            Parent = props.nt,
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
        })

        props = {
            Position = fromOffset(42, 0),
        }
        props.Size = UDim2.new(1, -42, 0, 0)
        props.AutomaticSize = AutoSizeY

        local listLayout, labelProps, entry9 = createListLayout(2), {}, UDim2.new

        labelProps.Size = UDim2.new(1, 0, 0, 17)
        labelProps.Text = title or ''
        labelProps.FontFace = FontBold
        props[1], props[2] = listLayout, createLabel(labelProps)
        entry9 = createFrame(props)

        if subtitle then
            if subtitle ~= '' then
                createLabel({
                    Parent = entry9,
                    LayoutOrder = 1,
                    Size = FullWidth,
                    AutomaticSize = AutoSizeY,
                    Text = subtitle,
                    TextSize = 12,
                    TextTransparency = 0.3,
                    TextWrapped = true,
                })
            end
        end

        kind = {
            AnchorPoint = vector2New(0, 1),
        }
        kind.Position = UDim2.new(0, 0, 1, 10)
        kind.Size = UDim2.new(1, 0, 0, 3)
        kind.BackgroundTransparency = 0.2
        kind.BackgroundColor3 = accentColor
        kind[1] = createCorner()
        labelProps, props, callback, listLayout = createFrame(kind), createFrame, {
            Parent = container,
            Position = fromOffset(360, 0),
            Size = FullWidth,
            AutomaticSize = AutoSizeY,
            BackgroundTransparency = 0.06,
            BackgroundColor3 = color3FromRGB(20, 22, 46),
        }, createFrame
        callback[1], callback[2], callback[3], callback[4], callback[5], callback[6] = createCorner(16), createStroke(0.86), createPadding(14, 14, 18), entry9, labelProps, createFrame({
            Size = fromOffset(30, 30),
            BackgroundTransparency = 0.8,
            BackgroundColor3 = accentColor,
            createCorner(10),
            createIcon(iconName, 16, accentColor),
        })

        local container2, props2, udim2 = createFrame(callback), {}, UDim2.new

        props2.Position = UDim2.new()

        tween(container2, props2, 0.5)
        tween(labelProps, {
            Size = fromOffset(0, 3),
        }, duration, Enum.EasingStyle.Linear)
        task.delay(duration, function()
            tween(container2, {
                Position = fromOffset(360, 0),
            }, 0.35, EaseQuint, Enum.EasingDirection.In)
            task.delay(0.4, container.Destroy, container)
        end)
    end
    getBaseDir = function()
        local current
        local isMatch, gameId = game.GameId ~= 0

        if isMatch then
            gameId = game.GameId
        else
            gameId = isMatch
        end

        current = nil

        if gameId then
            current = gameId
        else
            current = game.PlaceId
        end

        local isMatch2, current2 = Venyx.Id ~= 'Venyx'

        if isMatch2 then
            current2 = '/' .. Venyx.Id
        else
            current2 = isMatch2
        end

        return 'Venyx/' .. current .. (current2 or '')
    end
    getUserDir = function()
        return getBaseDir() .. '/' .. localPlayer.UserId
    end
    configPath = function(param1)
        return getUserDir() .. '/' .. param1 .. '.json'
    end

    local readJsonImpl = Runtime.readJson

    readJson = readJsonImpl

    local writeJsonImpl = Runtime.writeJson

    writeJson = writeJsonImpl
    serializeValue = function(target)
        if target == nil then
            return {z = 1}
        end

        return typeof(target) == 'Color3' and {
            c = target:ToHex(),
        } or typeof(target) == 'EnumItem' and {
            k = target.Name,
        } or target
    end

    local function deserializeValue(raw)
        if type(raw) ~= 'table' then
            return raw
        end
        if raw.z then
            return nil
        end

        local accentColor, current = raw.c and Color3.fromHex(raw.c)

        if accentColor then
            current = accentColor
        else
            local current2 = raw.k

            if current2 then
                current = Enum.KeyCode[raw.k]
            else
                current = current2
            end
        end

        return current or raw
    end
    local function valuesEqual(valA, valB)
        return HttpService:JSONEncode(serializeValue(valA)) == HttpService:JSONEncode(serializeValue(valB))
    end

    applyConfig = function(param1)
        Venyx.busy = true

        for key, value in next, param1, nil do
            local control
            local current, current2 = Venyx.Keys[key]

            if current then
                current2 = current
            else
                current2 = Venyx.Opt[key]
            end

            control = nil

            if current2 then
                control = current2
            else
                current = Venyx
                control = Venyx.Alias[key]
            end

            value = deserializeValue(value)

            if control then
                if not control.Skip then
                    if not (valuesEqual(value, control.Value)) then
                        pcall(control.Set, control, value)
                    end
                end
            end
        end

        Venyx.busy = false
    end
    Venyx.Persist = function(_self)
        writeJson(getUserDir() .. '/_state.json', State)
    end
    Venyx.Dir = getUserDir
    Venyx.Rd = readJson
    Venyx.Wr = writeJson
    Venyx.Save = Runtime.saveConfig
    Venyx.Load = Runtime.loadConfig
    Venyx.Configs = Runtime.listConfigs
    Venyx.Delete = Runtime.deleteConfig
    Venyx.Trash = function(_self)
        local list = {}

        pcall(function()
            for index, value in ipairs(listfiles(getUserDir() .. '/_trash')) do
                list[#list + 1] = value:match('([^/\\]+)%.json$')
            end
        end)
        table.sort(list)

        return list
    end
    Venyx.Restore = Runtime.restoreConfig
    Venyx.Name = function(self, rawName)
        rawName = tostring(rawName or ''):match('^%s*(.-)%s*$')

        if rawName ~= '' then
            if not (rawName:match('^[%w _%-]+$')) then
                return nil, 'Use letters, numbers, spaces, - or _'
            end
        end
        if #rawName > 32 then
            return nil, '32 characters at most'
        end

        self = rawName ~= '' and rawName or 'Config'
        rawName = if rawName == ''then'Config 1'else rawName

        local count = 2

        while true do
            local current, fileExists = isfile

            if current then
                local current2

                current2, fileExists = configPath, isfile(configPath(rawName))
            else
                fileExists = current
            end
            if not fileExists then
                break
            end

            rawName, count = self .. ' ' .. count, count + 1
        end

        return rawName
    end
    Venyx.Export = Runtime.exportConfig
    Venyx.Import = Runtime.importConfig
    Venyx.Dirty = function(_self)
        Venyx.tok = (Venyx.tok or 0) + 1

        local tok = Venyx.tok

        task.delay(1, function()
            if Venyx.tok == tok then
                Venyx:Save()
            end
        end)
    end
    Venyx.Reset = function(_self)
        Venyx.busy = true

        for key, value in next, Venyx.Keys do
            if not value.Skip then
                if not (valuesEqual(value.Def, value.Value)) then
                    pcall(value.Set, value, type(value.Def) == 'table' and table.clone(value.Def) or value.Def)
                end
            end
        end

        Venyx.busy = false

        Venyx:Save()
    end
    Venyx.Off = function(_self)
        local count = 0

        for key, value in next, Venyx.Keys do
            if value.Kind == 'toggle' then
                if value.Value then
                    if value.Skip then
                    else
                        value:Set(false)

                        count += 1
                    end
                end
            end
        end

        return count
    end
    Venyx.Theme = function(_self, themeName)
        local current = nil

        for index, value in ipairs(Themes) do
            current = if value[1] == themeName then value else current
        end

        if not current then
            return
        end

        local current2
        local window, props = Venyx.W

        if Venyx.th ~= themeName then
            Venyx.th = themeName

            local themeColors, colorMap, items = {
                w1 = current[2],
                w2 = current[3],
                a1 = current[4],
                a2 = current[5],
                sky = current[4]:Lerp(Palette.wh, 0.2),
                g1 = current[5]:Lerp(Palette.wh, 0.35),
                g2 = current[4],
                val = current[5]:Lerp(Palette.wh, 0.7),
                pn = current[2]:Lerp(current[3], 0.55),
                bg = current[2]:Lerp(current[3], 0.75),
                on = current[6] or color3FromRGB(255, 255, 254),
            }, {}, {0.35, 0.4, 0.5}

            for index, value in ipairs(items) do
                colorMap[Palette.a1:Lerp(Palette.wh, value):ToHex()] = themeColors.a1:Lerp(Palette.wh, value)
            end

            colorMap[Palette.sky:Lerp(Palette.wh, 0.55):ToHex()] = themeColors.sky:Lerp(Palette.wh, 0.55)

            for key, value in next, themeColors do
                colorMap[Palette[key]:ToHex()] = value
                Palette[key] = value
            end

            colorMap[Palette.wh:ToHex()], colorMap[Palette.tx:ToHex()] = nil, nil

            local function remapColor(color)
                return colorMap[color:ToHex()]
            end

            items = {
                window and window.Gui,
                window and window.nt and window.nt.Parent,
            }

            for _, item in ipairs(items) do
                for index, descendant in ipairs(item and item:GetDescendants() or {}) do
                    if not (descendant:FindFirstAncestor('VenyxThemes') or descendant.Parent == window.bg) then
                        if descendant:IsA('GuiObject') then
                            descendant.BackgroundColor3 = remapColor(descendant.BackgroundColor3) or descendant.BackgroundColor3

                            if descendant:IsA('TextLabel') or descendant:IsA('TextButton') or descendant:IsA('TextBox') then
                                descendant.TextColor3 = remapColor(descendant.TextColor3) or descendant.TextColor3
                            end
                            if descendant:IsA('ImageLabel') or descendant:IsA('ImageButton') then
                                descendant.ImageColor3 = remapColor(descendant.ImageColor3) or descendant.ImageColor3
                            end
                        elseif descendant:IsA('UIStroke') then
                            descendant.Color = remapColor(descendant.Color) or descendant.Color
                        elseif descendant:IsA('UIGradient') then
                            index = {}

                            for index2, keypoint in ipairs(descendant.Color.Keypoints) do
                                index[index2] = ColorSequenceKeypoint.new(keypoint.Time, remapColor(keypoint.Value) or keypoint.Value)
                            end

                            descendant.Color = ColorSequence.new(index)
                        end
                    end
                end
            end
        end

        State.Theme = themeName

        if window then
            window:Tint()
        end

        for key, value in next, window and window.marks or {}, nil do
            tween(value[1], {
                Transparency = key == themeName and 0.3 or 0.86,
                Color = key == themeName and current[4] or Palette.wh,
            }, 0.2)

            current2, props = value[2], {}
            props.ImageTransparency = key == themeName and 0 or 1

            tween(current2, props, 0.2)
        end

        Venyx:Persist()
    end
    Venyx.Boot = Runtime.boot

    return Venyx
end)()
