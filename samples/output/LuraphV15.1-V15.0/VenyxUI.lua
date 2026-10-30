--[[
	Venyx UI Library (v1.4.5) - Standalone Luau UI Framework
	Themes: "Twilight", "Aurora", "Ocean", "Midnight", "Sakura", "Onyx", "Black", "Mono"

	Quick Usage:
		local Venyx = loadstring(readfile("VenyxUI.lua"))()
		local win = Venyx:Window({
			Title = "Venyx",
			Version = "v1.4.5",
			Game = "My Script",
			Id = "MyVenyxHub",
			Key = Enum.KeyCode.RightControl,
		})
		win:Home({ Game = "My Script", Key = "Ready", Discord = "https://discord.gg/...", Community = "Discord" })
		local mainTab = win:Tab("Main", "home")
		local genSub = mainTab:Sub("General")
		local sec = genSub:Section("Features", "zap", 1)
		sec:Toggle("Auto Farm", false, function(state) print("Auto Farm:", state) end, "autoFarm")
		sec:Slider("WalkSpeed", 16, 200, 16, function(val) print("Speed:", val) end, " st/s", 1, "walkSpeed")
		sec:Dropdown("Mode", { "Normal", "Fast", "Safe" }, "Normal", function(pick) print("Mode:", pick) end, false, "mode")
		sec:Input("Target", "Player name...", function(txt) print("Target:", txt) end, "target")
		sec:Button("Run Action", "Run", function() Venyx:Notify("Executed", "Action finished", "ok") end, "gold")

		local settingsTab = win:Tab("Settings", "settings")
		win:Settings(settingsTab)
		win:Quick(settingsTab, {})
		win:Config(win:Tab("Config", "save"))
]]

return (function()
    local ctx = {}
    local _VX = {mem = {}}

    function _VX.setList(tbl, offset, ...)
        local packed = table.pack(...)

        table.move(packed, 1, packed.n, offset + 1, tbl)
    end
    function _VX.unpack(packed)
        return table.unpack(packed, 1, packed.n)
    end
    function _VX.decodeBase64(data)
        local b64 = [[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/]]
        local map = {}

        for i = 1, #b64 do
            map[b64:sub(i, i)] = i - 1
        end

        local out, acc, bits = {}, 0, 0

        for i = 1, #data do
            local v = map[data:sub(i, i)]

            if v ~= nil then
                acc = acc * 64 + v

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
    function _VX.ensureFolder(filePath)
        if type(makefolder) ~= 'function' then
            return
        end

        local cur = ''

        for part in tostring(filePath):gmatch('([^/\\]+)/')do
            cur = cur == '' and part or (cur .. '/' .. part)

            pcall(function()
                if type(isfolder) ~= 'function' or not isfolder(cur) then
                    makefolder(cur)
                end
            end)
        end
    end
    function _VX.readRaw(path)
        if type(isfile) == 'function' and type(readfile) == 'function' then
            local ok, content = pcall(function()
                return isfile(path) and readfile(path) or nil
            end)

            if ok and type(content) == 'string' then
                return content
            end
        end

        return _VX.mem[path]
    end
    function _VX.writeRaw(path, content)
        _VX.mem[path] = content

        if type(writefile) == 'function' then
            _VX.ensureFolder(path)
            pcall(writefile, path, content)
        end
    end
    function _VX.deleteRaw(path)
        _VX.mem[path] = nil

        if type(delfile) == 'function' and type(isfile) == 'function' then
            pcall(function()
                if isfile(path) then
                    delfile(path)
                end
            end)
        end
    end
    function _VX.loadAsset(filePath, sources)
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
            for _, srcUrl in ipairs(sources)do
                if type(srcUrl) == 'string' then
                    local bytes = nil

                    if srcUrl:sub(1, 5) == 'data:' then
                        local b64Body = srcUrl:sub(6):gsub('^[^,]*;base64,', '')
                        local okDec, dec = pcall(_VX.decodeBase64, b64Body)

                        if okDec and type(dec) == 'string' and #dec > 16 then
                            bytes = dec
                        end
                    else
                        local okHttp, body = pcall(function()
                            return ctx.game:HttpGet(srcUrl)
                        end)

                        if okHttp and type(body) == 'string' and #body > 16 then
                            bytes = body
                        end
                    end
                    if bytes then
                        _VX.ensureFolder(filePath)

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
    function _VX.mountWindow(win, id)
        local lib = ctx.Venyx

        lib.Id = id
        lib.W = win

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

        local gui = ctx.newInstance('ScreenGui', {
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            ZIndexBehavior = ctx.Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 100,
        })

        ctx.mountGui(gui)

        local notifGui = ctx.newInstance('ScreenGui', {
            ResetOnSpawn = false,
            IgnoreGuiInset = true,
            ZIndexBehavior = ctx.Enum.ZIndexBehavior.Sibling,
            DisplayOrder = 200,
        })

        ctx.mountGui(notifGui)

        win.nt = ctx.createFrame({
            Parent = notifGui,
            AnchorPoint = Vector2.new(1, 1),
            Position = ctx.udim2(1, -20, 1, -20),
            Size = ctx.udim2(0, 320, 1, -40),
            ctx.listLayout(10, nil, ctx.Enum.VerticalAlignment.Bottom),
        })

        return gui
    end
    function _VX.readJson(filePath)
        local raw = _VX.readRaw(filePath)

        if type(raw) ~= 'string' or raw == '' then
            return nil
        end

        local ok, decoded = pcall(ctx.HttpService.JSONDecode, ctx.HttpService, raw)

        return ok and type(decoded) == 'table' and decoded or nil
    end
    function _VX.writeJson(filePath, data)
        local ok, encoded = pcall(ctx.HttpService.JSONEncode, ctx.HttpService, data)

        if ok and type(encoded) == 'string' then
            _VX.writeRaw(filePath, encoded)

            return true
        end

        return false
    end
    function _VX.saveConfig(_self, cfgName)
        local lib, state = ctx.Venyx, ctx.State
        local target = (type(cfgName) == 'string' and cfgName ~= '') and cfgName or state.Active or 'Default'
        local payload = {}

        for key, item in next, lib.Keys do
            if not item.Skip then
                payload[key] = ctx.serializeValue(item.Value)
            end
        end

        return ctx.writeJson(ctx.configPath(target), payload)
    end
    function _VX.loadConfig(_self, cfgName)
        local lib, state = ctx.Venyx, ctx.State
        local target = (type(cfgName) == 'string' and cfgName ~= '') and cfgName or state.Active or 'Default'
        local data = ctx.readJson(ctx.configPath(target))

        if type(data) ~= 'table' then
            return false
        end

        ctx.applyConfig(data)

        if state.Active ~= target then
            state.Active = target

            lib:Persist()
        end

        return true
    end
    function _VX.listConfigs(_self)
        local names, seen = {}, {}
        local dir = ctx.userDir()

        pcall(function()
            if type(listfiles) == 'function' then
                for _, fp in ipairs(listfiles(dir))do
                    local nm = fp:match('([^/\\]+)%.json$')

                    if nm and nm:sub(1, 1) ~= '_' and not seen[nm] then
                        seen[nm] = true
                        names[#names + 1] = nm
                    end
                end
            end
        end)

        local prefix = dir .. '/'

        for fp in next, _VX.mem do
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
    function _VX.deleteConfig(_self, cfgName)
        if type(cfgName) ~= 'string' or cfgName == '' or cfgName:lower() == 'default' then
            return false
        end

        local lib, state = ctx.Venyx, ctx.State
        local srcPath = ctx.configPath(cfgName)
        local data = ctx.readJson(srcPath)

        if data then
            ctx.writeJson(ctx.userDir() .. '/_trash/' .. cfgName .. '.json', data)
        end

        _VX.deleteRaw(srcPath)

        if state.Active == cfgName then
            state.Active = 'Default'

            lib:Persist()
            lib:Load('Default')
        end

        return true
    end
    function _VX.restoreConfig(_self, cfgName)
        if type(cfgName) ~= 'string' or cfgName == '' then
            return nil
        end

        local trashPath = ctx.userDir() .. '/_trash/' .. cfgName .. '.json'
        local data = ctx.readJson(trashPath)

        if type(data) ~= 'table' then
            return nil
        end

        local restoredName = ctx.Venyx:Name(cfgName) or cfgName

        ctx.writeJson(ctx.configPath(restoredName), data)
        _VX.deleteRaw(trashPath)

        return restoredName
    end
    function _VX.exportConfig(_self, cfgName)
        local target = (type(cfgName) == 'string' and cfgName ~= '') and cfgName or ctx.State.Active or 'Default'
        local data = ctx.readJson(ctx.configPath(target))

        if type(data) ~= 'table' then
            ctx.Venyx:Save(target)

            data = ctx.readJson(ctx.configPath(target)) or {}
        end

        return ctx.HttpService:JSONEncode({
            name = target,
            data = data,
        })
    end
    function _VX.importConfig(_self, text)
        text = tostring(text or ''):match('^%s*(.-)%s*$')

        if text == '' then
            return nil, 'Paste exported config text first'
        end

        local ok, parsed = pcall(ctx.HttpService.JSONDecode, ctx.HttpService, text)

        if not ok or type(parsed) ~= 'table' then
            return nil, 'Invalid config format'
        end

        local rawName = type(parsed.name) == 'string' and parsed.name or 'Imported'
        local data = type(parsed.data) == 'table' and parsed.data or parsed
        local safeName, err = ctx.Venyx:Name(rawName)

        if not safeName then
            safeName = ctx.Venyx:Name('Imported')
        end
        if not safeName then
            return nil, err or 'Could not name imported config'
        end

        ctx.writeJson(ctx.configPath(safeName), data)

        return safeName
    end
    -- Registers Heartbeat signal callback(s)
    function _VX.boot(_self)
        local lib, state = ctx.Venyx, ctx.State

        _VX.ensureFolder(ctx.userDir() .. '/_trash/x')

        local savedState = ctx.readJson(ctx.userDir() .. '/_state.json')

        if type(savedState) == 'table' then
            if type(savedState.AutoLoad) == 'boolean' then
                state.AutoLoad = savedState.AutoLoad
            end
            if type(savedState.AutoSave) == 'boolean' then
                state.AutoSave = savedState.AutoSave
            end
            if type(savedState.Active) == 'string' and savedState.Active ~= '' then
                state.Active = savedState.Active
            end
            if type(savedState.Theme) == 'string' and savedState.Theme ~= '' then
                state.Theme = savedState.Theme
            end
        end
        if state.Theme then
            lib:Theme(state.Theme)
        end

        ctx.RunService.Heartbeat:Once(function()
            if not ctx.readJson(ctx.configPath('Default')) then
                lib:Save('Default')
            end
            if state.AutoLoad and state.Active then
                lib:Load(state.Active)
            end
        end)
    end

    local H = game

    ctx.game = H

    local function getService(serviceName)
        local r = ctx.game

        return r:GetService(serviceName)
    end

    local UserInputService = getService('UserInputService')
    local TweenService = getService('TweenService')
    local HttpService = getService('HttpService')

    ctx.HttpService = HttpService

    local RunService = getService('RunService')

    ctx.RunService = RunService

    local localPlayer, w = getService('Players').LocalPlayer, Enum

    ctx.Enum = w

    local color3FromRGB = Color3.fromRGB
    local uDim2New = UDim2.new

    ctx.udim2 = uDim2New

    local uDimNew = UDim.new
    local vector2New = Vector2.new
    local font, font6 = Font.new('rbxasset://fonts/families/Montserrat.json', ctx.Enum.FontWeight.SemiBold), Font.new('rbxasset://fonts/families/Montserrat.json', ctx.Enum.FontWeight.Bold)
    local font5 = Font.new('rbxasset://fonts/families/Montserrat.json', ctx.Enum.FontWeight.ExtraBold)
    local font4 = Font.new('rbxasset://fonts/families/RobotoMono.json', ctx.Enum.FontWeight.SemiBold)
    local font3 = Font.new('rbxassetid://12187365977', ctx.Enum.FontWeight.Bold)
    local colorSequence = ColorSequence.new(color3FromRGB(26, 255, 0), color3FromRGB(0, 255, 0))
    local font2, L = Font.new(font3.Family, font3.Weight, ctx.Enum.FontStyle.Italic), {}

    L.bg = color3FromRGB(16, 18, 40)
    L.tx = color3FromRGB(242, 244, 255)
    L.a1 = color3FromRGB(122, 162, 255)
    L.a2 = color3FromRGB(185, 139, 255)
    L.g1 = color3FromRGB(255, 229, 138)
    L.g2 = color3FromRGB(255, 155, 88)
    L.dk = color3FromRGB(42, 18, 0)
    L.mint = color3FromRGB(110, 255, 182)
    L.red = color3FromRGB(255, 110, 110)
    L.sky = color3FromRGB(143, 180, 255)
    L.pink = color3FromRGB(255, 158, 207)
    L.vio = color3FromRGB(199, 166, 255)
    L.gold = color3FromRGB(255, 210, 122)
    L.wh = color3FromRGB(255, 255, 255)
    L.val = color3FromRGB(217, 222, 255)
    L.dc = color3FromRGB(88, 101, 242)
    L.pn = color3FromRGB(24, 26, 54)
    L.w1 = color3FromRGB(36, 40, 86)
    L.w2 = color3FromRGB(14, 15, 34)
    L.gv = color3FromRGB(184, 255, 156)
    L.on = color3FromRGB(255, 255, 254)

    local l = {}

    _VX.setList(l, 0, {
        'Twilight',
        color3FromRGB(36, 40, 86),
        color3FromRGB(14, 15, 34),
        color3FromRGB(122, 162, 255),
        color3FromRGB(185, 139, 255),
    }, {
        'Aurora',
        color3FromRGB(10, 84, 82),
        color3FromRGB(4, 26, 38),
        color3FromRGB(63, 224, 176),
        color3FromRGB(127, 255, 216),
    }, {
        'Ocean',
        color3FromRGB(8, 70, 128),
        color3FromRGB(3, 20, 52),
        color3FromRGB(47, 185, 221),
        color3FromRGB(127, 220, 255),
    }, {
        'Midnight',
        color3FromRGB(52, 24, 112),
        color3FromRGB(10, 4, 36),
        color3FromRGB(118, 100, 226),
        color3FromRGB(160, 132, 240),
    }, {
        'Sakura',
        color3FromRGB(118, 44, 96),
        color3FromRGB(36, 12, 40),
        color3FromRGB(255, 140, 200),
        color3FromRGB(255, 196, 228),
    }, {
        'Onyx',
        color3FromRGB(58, 46, 22),
        color3FromRGB(8, 6, 2),
        color3FromRGB(255, 206, 110),
        color3FromRGB(255, 150, 80),
    }, {
        'Black',
        color3FromRGB(50, 50, 56),
        color3FromRGB(16, 16, 19),
        color3FromRGB(250, 251, 255),
        color3FromRGB(176, 182, 198),
        color3FromRGB(14, 14, 18),
    }, {
        'Mono',
        color3FromRGB(92, 94, 104),
        color3FromRGB(30, 31, 36),
        color3FromRGB(250, 251, 255),
        color3FromRGB(196, 200, 214),
        color3FromRGB(20, 21, 26),
    })

    local F = {}

    _VX.setList(F, 0, L.gold, L.mint, L.sky, L.pink, L.vio)

    local Q = {
        LeftShift = 'LShift',
        RightShift = 'RShift',
        LeftControl = 'LCtrl',
        RightControl = 'RCtrl',
        LeftAlt = 'LAlt',
        RightAlt = 'RAlt',
    }
    local _ = ctx.udim2(1, 0, 1, 0)
    local Z = ctx.udim2(0.5, 0, 0.5, 0)
    local T = vector2New(0.5, 0.5)
    local R = vector2New(1, 0.5)
    local center = ctx.Enum.TextXAlignment.Center
    local center3 = ctx.Enum.HorizontalAlignment.Center
    local horizontal = ctx.Enum.FillDirection.Horizontal
    local g = ctx.Enum.AutomaticSize.Y
    local t = ctx.Enum.AutomaticSize.X
    local atEnd = ctx.Enum.TextTruncate.AtEnd
    local center2 = ctx.Enum.VerticalAlignment.Center
    local f = ctx.udim2(1, 0, 0, 0)
    local b = ctx.udim2(1, 0, 0.5, 0)
    local z = vector2New(1, 0)

    ctx.topRight = z

    local quint = ctx.Enum.EasingStyle.Quint
    local back, N, S = ctx.Enum.EasingStyle.Back, 46, 54

    local function x(B, O)
        local udim2 = ctx.udim2

        return udim2(0, B, 0, O)
    end

    local B, O = {}, {
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

    for index, value in ipairs(O)do
        B[value] = index - 1
    end

    local O, G = 'tienkhanh1/venyx-assets@main/venyx-icons3.png'
    local loadAsset = _VX.loadAsset

    local function u()
        if G == nil then
            G = loadAsset('Venyx/icons3.png', {
                'https://raw.githubusercontent.com/' .. O:gsub('@', '/'),
                [[https://cdn.jsdelivr.net/gh/tienkhanh1/venyx-assets@main/venyx-icons3.png]],
            }) or false
        end

        local O = G

        return O
    end

    local O = {
        Opt = {},
        Keys = {},
        Alias = {},
    }

    ctx.Venyx = O
    ctx.Venyx.th = l[1][1]

    local O = {
        AutoLoad = true,
        AutoSave = true,
        Active = 'Default',
        Theme = 'Black',
        Cfg = 2,
    }

    ctx.State = O
    ctx.Venyx.State = ctx.State

    local O = {}

    local function G(signal, callback)
        local e = O

        e[#O + 1] = signal:Connect(callback)
    end
    local function P()
        local j = {}

        for e = 1, 10, 1 do
            j[e] = string.char(math.random(97, 122))
        end

        return table.concat(j)
    end

    ctx.newInstance = function(parent, e)
        local s = Instance.new(parent)

        s.Name = P()
        parent = e.Parent
        e.Parent = nil

        for key, value in next, e do
            if type(key) == 'number' then
                value.Parent = s
            else
                s[key] = value
            end
        end

        s.Parent = parent

        return s
    end

    local j = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }

    j.BackgroundColor3 = L.wh

    local function e(s, q, Y)
        local function X(K)
            local D1 = {q, j}

            for index, value in ipairs(D1)do
                for key, J1 in next, value do
                    if K[key] == nil then
                        K[key] = J1
                    end
                end
            end

            if Y then
                if K.TextSize then
                    K.TextSize = math.floor(K.TextSize * 1.18 + 0.5)
                end
            end

            local j = K.TextTruncate == atEnd and not K.AutomaticSize and K.TextSize

            if j then
                K.TextTruncate = nil
            end

            D1 = ctx.newInstance

            local q = D1(s, K)

            if j then
                local function s()
                    if q.AbsoluteSize.X < 2 then
                        return
                    elseif q:GetAttribute('nofit') then
                        return
                    elseif q.TextSize == j then
                        if q.TextBounds.X <= q.AbsoluteSize.X then
                            return
                        end
                    end

                    q.TextSize = j

                    local alt = q:GetAttribute('alt')

                    if alt then
                        if q.Text ~= alt then
                            if q.TextBounds.X > q.AbsoluteSize.X then
                                q.Text = alt

                                return
                            end
                        end
                    end

                    while true do
                        local j, absoluteSize = q.TextBounds.X, q.AbsoluteSize

                        if not (j > absoluteSize.X and q.TextSize > 8) then
                            break
                        end

                        q.TextSize = q.TextSize - 1
                    end
                end

                q:GetPropertyChangedSignal('Text'):Connect(s)
                q:GetPropertyChangedSignal('AbsoluteSize'):Connect(s)
            end

            return q
        end

        return X
    end

    local j, frame = {
        FontFace = font,
        TextColor3 = L.tx,
        TextSize = 13,
        TextXAlignment = ctx.Enum.TextXAlignment.Left,
    }, e('Frame', {})

    ctx.createFrame = frame

    local frame = e('Frame', {BackgroundTransparency = 0})
    local textButton = e('TextButton', {
        Text = '',
        AutoButtonColor = false,
    }, true)
    local textLabel = e('TextLabel', j, true)
    local textBox = e('TextBox', {
        Text = '',
        PlaceholderColor3 = color3FromRGB(178, 180, 188),
        ClearTextOnFocus = false,
        FontFace = font,
        TextColor3 = L.tx,
        TextSize = 13,
        TextXAlignment = j.TextXAlignment,
    }, true)
    local scrollingFrame = e('ScrollingFrame', {
        ScrollBarThickness = 2,
        ScrollBarImageTransparency = 0.6,
        CanvasSize = ctx.udim2(),
        AutomaticCanvasSize = g,
        ScrollingDirection = ctx.Enum.ScrollingDirection.Y,
    })
    local imageLabel = e('ImageLabel', {})

    local function e(K)
        local D1 = B[K.Image]

        if D1 then
            local J1 = u()

            K.Image = J1 or ''

            if J1 then
                K.ImageRectOffset = vector2New(D1 % 8 * 64, D1 // 8 * 64)
                K.ImageRectSize = vector2New(64, 64)
            end
        end

        return imageLabel(K)
    end
    local function u(imageId, D1, J1, U1)
        return e({
            AnchorPoint = T,
            Position = Z,
            Size = x(D1, D1),
            Image = imageId,
            ImageColor3 = J1,
            ImageTransparency = U1,
        })
    end
    local function K(D1)
        return 'rbxthumb://type=AvatarHeadShot&id=' .. localPlayer.UserId .. '&w=' .. D1 .. '&h=' .. D1
    end
    local function D1(J1)
        local newInstance = ctx.newInstance

        return newInstance('UICorner', {
            CornerRadius = J1 and uDimNew(0, J1) or uDimNew(1, 0),
        })
    end
    local function J1(transparency, color)
        local H1, k1, enum = ctx.newInstance, {
            Transparency = transparency,
            Color = color or L.wh,
        }, ctx.Enum

        k1.ApplyStrokeMode = enum.ApplyStrokeMode.Border

        return H1('UIStroke', k1)
    end
    local function U1(a1, H1, rotation)
        local newInstance = ctx.newInstance

        return newInstance('UIGradient', {
            Color = ColorSequence.new(a1, H1),
            Rotation = rotation or 0,
        })
    end
    local function a1(H1, ...)
        local k1, r1 = {}, {...}

        for C1, w1 in ipairs(r1)do
            k1[C1] = NumberSequenceKeypoint.new(w1[1], w1[2])
        end

        r1 = ctx.newInstance

        return r1('UIGradient', {
            Rotation = H1,
            Transparency = NumberSequence.new(k1),
        })
    end
    local function H1(k1, r1, C1, w1)
        local newInstance = ctx.newInstance

        return newInstance('UIPadding', {
            PaddingTop = uDimNew(0, k1),
            PaddingRight = uDimNew(0, r1 or k1),
            PaddingBottom = uDimNew(0, C1 or k1),
            PaddingLeft = uDimNew(0, w1 or r1 or k1),
        })
    end

    ctx.listLayout = function(k1, r1, C1, w1)
        local newInstance, W1, I1 = ctx.newInstance, {
            Padding = uDimNew(0, k1 or 0),
            HorizontalAlignment = r1,
            VerticalAlignment = C1,
            FillDirection = w1,
        }, ctx.Enum

        W1.SortOrder = I1.SortOrder.LayoutOrder

        return newInstance('UIListLayout', W1)
    end

    local function V(parent, position, C1)
        local w1 = ctx.createFrame

        return w1({
            Parent = parent,
            Position = position,
            Size = C1,
            BackgroundTransparency = 0.9,
        })
    end
    local function k1(r1, C1, w1, V1, W1, I1)
        local tweenInfoNew, h1, n1, M1 = TweenInfo.new, w1 or 0.25, V1 or quint

        if W1 then
            M1 = W1
        else
            w1 = ctx.Enum
            M1 = w1.EasingDirection.Out
        end

        W1 = TweenService:Create(r1, tweenInfoNew(h1, n1, M1, 0, false, I1 or 0), C1)

        W1:Play()

        return W1
    end
    local function r1(C1, w1, bgAlpha)
        G(C1.MouseEnter, function()
            k1(C1, {BackgroundTransparency = w1}, 0.15)
        end)
        G(C1.MouseLeave, function()
            k1(C1, {
                BackgroundTransparency = bgAlpha or 1,
            }, 0.25)
        end)
    end
    local function C1(w1, V1, W1)
        local function I1()
            if not (W1()) then
                V1.Visible = false
            end
        end

        w1.Completed:Connect(I1)
    end
    local function w1(callback, ...)
        if callback then
            pcall(callback, ...)
        end
    end
    local function V1(W1)
        local I1, I1, I12 = ctx.Enum, W1.UserInputType == ctx.Enum.UserInputType.MouseButton1

        if I1 then
            I12 = I1
        else
            local I1

            I1, I12 = ctx.Enum, W1.UserInputType == ctx.Enum.UserInputType.Touch
        end

        return I12
    end

    local W1 = {}

    W1.p = Vector3.zero
    W1.t = 0
    W1.m = 0

    G(UserInputService.InputBegan, function(I1)
        if V1(I1) then
            W1.p, W1.t = I1.Position, os.clock()
            W1.m = 0
            W1.s = false
        end
    end)
    G(UserInputService.InputChanged, function(I1)
        local enum, v1, h1 = ctx.Enum, I1.UserInputType == ctx.Enum.UserInputType.Touch

        if v1 then
            h1 = v1
        else
            local enum

            enum, h1 = ctx.Enum, I1.UserInputType == ctx.Enum.UserInputType.MouseMovement
        end
        if h1 then
            W1.m = math.max(W1.m, (I1.Position - W1.p).Magnitude)
        end
    end)

    local function I1()
        return W1.m < 14 and os.clock() - W1.t < 0.45 and not W1.s
    end
    local function v1(h1, callback)
        G(h1.Activated, function(...)
            if I1() then
                callback(...)
            end
        end)
    end
    local function h1(n1)
        local M1 = tostring(n1)
        local n1, A1 = M1:match('^(%-?%d+)(.*)$')

        if not n1 then
            return M1
        end

        return n1:reverse():gsub('(%d%d%d)', '%1,'):reverse():gsub('^(%-?),', '%1') .. A1
    end
    local function n1(M1, A1, d1, callback)
        local anchorPoint, F1, Q1 = M1.AnchorPoint, M1.Position, M1.Size

        if not (M1.Parent:FindFirstChildWhichIsA('UIGridStyleLayout')) then
            M1.AnchorPoint = T

            local udim2 = ctx.udim2

            M1.Position = F1 + udim2((0.5 - anchorPoint.X) * Q1.X.Scale, (0.5 - anchorPoint.X) * Q1.X.Offset, (0.5 - anchorPoint.Y) * Q1.Y.Scale, (0.5 - anchorPoint.Y) * Q1.Y.Offset)
        end

        anchorPoint = ctx.newInstance

        local F1 = anchorPoint('UIScale', {Parent = M1})

        d1 = d1 or M1

        G(d1.InputBegan, function(M1)
            if not (V1(M1)) then
                return
            end

            k1(F1, {
                Scale = A1 or 0.96,
            }, 0.12)

            if callback then
                callback(true)
            end
        end)
        G(d1.InputEnded, function(M1)
            if not (V1(M1)) then
                return
            end

            k1(F1, {Scale = 1}, 0.4, back)

            if callback then
                callback(false)
            end
        end)
    end
    local function M1(A1, d1)
        return {
            p = A1,
            v = vector2New(),
            t = A1,
            a = d1,
        }
    end
    local function A1(d1, L1)
        if (d1.t - d1.p).Magnitude < 0.03 then
            if d1.v.Magnitude < 0.03 then
                return
            end
        end

        L1 = math.min(L1, 0.05)

        local ceil = math.ceil(L1 * 240)
        local F1 = L1 / ceil

        for i = 1, ceil, 1 do
            d1.v = d1.v + ((d1.t - d1.p) * 230 - d1.v * 29) * F1
            d1.p = d1.p + d1.v * F1
        end

        d1.a(d1.p)
    end
    local function d1(L1, l1, F1)
        local Q1, _1, Z1, T1

        local function R1()
            local userInputType, m1 = Q1.UserInputType, ctx.Enum

            return userInputType == m1.UserInputType.Touch
        end

        G(L1.InputBegan, function(L1)
            if not Q1 then
                if V1(L1) then
                    local p1, m1 = vector2New(L1.Position.X, L1.Position.Y), l1.t

                    Q1, _1, Z1, T1 = L1, p1, m1, false
                end
            end
        end)
        G(UserInputService.InputChanged, function(L1)
            if not Q1 then
                return
            end
            if R1() and L1 ~= Q1 then
                return
            elseif not (R1()) then
                local enum = ctx.Enum

                if L1.UserInputType ~= enum.UserInputType.MouseMovement then
                    return
                end
            end

            local p1 = vector2New(L1.Position.X, L1.Position.Y) - _1

            T1 = T1 or p1.Magnitude > 5

            if T1 then
                l1.t = F1(Z1 + p1)
            end
        end)
        G(UserInputService.InputEnded, function(L1)
            if Q1 then
                if L1 == Q1 then
                    Q1 = nil
                elseif not (R1()) then
                    local enum = ctx.Enum

                    if L1.UserInputType == enum.UserInputType.MouseButton1 then
                        Q1 = nil
                    end
                end
            end
        end)

        local function L1()
            local T1 = T1

            return T1
        end

        return L1
    end
    local function L1(parent, F1, Q1, position, Z1)
        local T1, R1, p1, m1, c1 = {
            Parent = parent,
            AnchorPoint = Z1,
            Position = position,
            Size = x(F1, Q1),
        }, D1(), U1(L.g1, L.g2, 45), {
            AnchorPoint = vector2New(0.5, 1),
        }, ctx.udim2

        m1.Position = c1(0.5, 0, 1, -(Q1 * 0.12 // 1))
        m1.Size = x(F1 * 0.45 // 1, F1 * 0.45 // 1)
        m1.BackgroundColor3 = color3FromRGB(255, 246, 214)

        _VX.setList(m1, 0, D1())
        _VX.setList(T1, 0, R1, p1, frame(m1))

        return frame(T1)
    end

    local l1 = {
        'Venyx/mark1.png',
        {

[[data:iVBORw0KGgoAAAANSUhEUgAAAIYAAACACAYAAADOIBGMAAAPWklEQVR4nOydedRd0xnGn8/qH6VKQtIEFVESJTGFGKrRIk1Lo9RUZZWlWLS0S9qaaQ1VStAGCdpGzFMQjURVUkPNpVTFGErNbRUd1Oo/PI+7b9Z1c+6Z9rvvOefe81trr/199557hr3f8+7pfd+9DGpqIlgGNTUR1IJRE8kSwXjvvfdWYLqOaRxq+grW+eZMVzMt2/xsiWAMDAz8i9kzTA/xgCNQ0xewrk9idh/TE5SB/zU/H2g76BPMXmb6CNPNTHvw4P+gpudgXQ9hNpvpc0z/ZxrGun6r+f2H+hj84m/MrnD/bs+0iCfYCjU9BetUdfsYGkIhLmoVChHV+Ty/5e8RTHfxRMegpidgXZ7FbD7TsJaPz28/binBoOTcy+yqto9P4QmvZFoONZWEdbcS0wL+OaXtK2mLR9qP7zRcPS/isz2ZHuXJx6OmUrDOvshsEdN2EV9Pj/pNpGBQgu5idm/EV2sxPcAL7Y2aSsC6+g6z3zANj/j6Ntb1g1G/i5vgOj3mu8t4we+jptSwjo5lNi3mkFM7fTGA+BO/xGy1mENOo8QdjZrSwbqbyizu5X2BdTey05dJU+KnJ3x/FG/gUtSUBg0QmG5EvFCI2LpN0hgrMnuVaVnEs5Bpx9aZs5ruw/r6OBr9ic8kHKpZ7lVYX+90OiBWY/CHb6NDr7UN9Xbn88Y+hppCYNkPQuMFTRIKcW6cUIhYjeEuqGny15GOu5m250X/jZquwTpamdltTOunOPxdptVZR/+IOyhx2d1Nk09DOjR9fqtTaTVdwL24v0c6oRBnJgmFSNQY7uJj0JhbT4tW6ybyBv6LmmCwXoYyu4Np3Qw/G816eSbpoFSGOjyRZs1uQXq2YJqDmmC4gYGmuLMIxdw0QiGyWHCdjWxM5M3/GjXmsFyXR2P0sQGycVbaA1M1JS03pOnTTZCN6ymlu6LGBGdl9VumzyIb97AeUptQZLX5nIXs7MKHqZsVO65BdqEQs7IcnFVjaNld0+SDkZ3zKLGHoiY3LP8LmR2I7GhkOTLLBGQmjeEmRc5EPg7hg30XNblg2R2OfEIhzsg6K51JYwg3uym70BWRj0m8yVtRkxqW+WRmc5EPzVloQuvdLD/K7Ffi5iauQH5m80HXQU0qWFZjmV2J/MzMKhQir8PR+cjPCmgIx6dQEwvLaCQanc3lkZ9fIAe5BIMS+Ciz3yE/eguuQk1H3FzFPGSbwGpnHutqMXLg46LoozXEeD58kr1HP3MJ03rwI+0a11Jk7ny2worV+skY+LEXpdqnDe05WK4nMvsh/Lif5boFcuLr1OzTCV1yDhbEhqj5AJbFV+AvFGI2PPDVGJro0tA1ycIrib8wbeT8Z/sW1yFX/83X4EleZav7uJd6aQxe+E1mF8GfNZkuRs1l8BcKcZGvz7FFfIxzYMPOzgeiL+GzH8lsS9hwLjzxakqauEWynWDD+pT2LEZBlYfltxGzh2HDNSy/r8ETq4g6vkPXVmaij3DzFVfDjhkwwEQwKKEyGklrMJyE5jdORv+gfsVo2PAc6+J2GGAZg+tU2HEchSOrQVDl4DN+AXZNsDCbMDTpYwg3dP0n7FA/Y3yeBaAq4JqQB+A35d3O8lYG2GYaww1dLSa8mmg95UfoXU6DrVBcbmmVb6YxBN+CbeC3uBbFBBeWoWdgOclzbwFs2dAtbppgKhiCD30/s81gxxNM43qlSXHGvHLHWBN2PMTy2RSGhAgAewlskbr9MXoHNSGWQiFy2VzEEUJjaEr3r0wrwZa1+VY8iwrDstEy+iLY8nemEdYa1VxjuA6QySRLGz9B9Unt8JOBs0M0s+YaQ/DNWB0NrWGN/GEXooKwTOR05bUU3oGhaZyUsxIkyDxv9EU0vKWs+Rmqy1TYMzeEUIiQuw+EUJtj+ebthorhohyOhD0hyvgDgjQlTVggMsAZCVue4lvyaVQIlsNzsB+JLGY5jEIgQu9XYrnq2mQdFnRlXB3dTg7WQiGs7GAiCa0xPsnsRdgjX8xRZTcFdIFNNMQOEWFoaKj+hQiqMXjjcoD+FexReKEjUX5OQBihODekUIigGkPwrVF/4AmEYZiLEVY6nGFvqAm5UXkdidISfE80PsCTzEI5MZdZa5yEMMwLLRQiuMYQfHt2R8MHMwRDWFBvoETweWWR9RTCsBOfN3gIq67sosgHuRZhZkLFQSgfUxCGxd0QCtHN7TVDaYzDnDVUKeC9rMLsYIQhVBkuRTcFI8ToRGhIaOHSZ8VRCIeFc1cqutLHaMK36ZfM9oc98rpareh5DW0vhUaMMl+XzShm8Pm+jS7RTY0hzkMY1JTsgeLRmkgIoRChyi6SrmoMwbdKIY63hj2P843yDcngBZ9NUXfXhj3z+WxfRhfptsYQeaP+JbGe89MoBF57R4QRCtH1ADNd1xiChagxvpX3VSsL+GYVIhx8pjuZTYA9hWjCIjSGCGWmN9Et3HUVXlO7S4YQClGIu2ZRgiEn3lCzld9C9wk1WniF2qKQIHaFCIYzXs0dOCyBvNFzc+H8RL6JMPwUBVGUxhASjBBbZA1lZXnHh8iAhsmDYI9cPs39RdJSmGBQayhOVCibxa5NBCHcWs3UInelLGRU0sTt/KeZwhC7L45w1urBCGhzISeiNQcK3DqsyKakqTV+jjB0Y9U11GLZmQMF7ydXqMYQzi4yhBXWoyzcoPFDA83H6GUZUfQWpYVqDMECkNoMsQ6wQcg5DZ5bztYhJummFS0UonDBcGTdiC8tSfub+xBiUx51NkMN4zNRCsFwXuwhjFD2RTj2hj3Ty2KmWHgfo0nAHv62LOzbYAjvdXtm82HPYNchL5yyNCXSGnLjCzGvEcLX9auw57SyCIUojcYQfBOHM3sVtrzGAl8FhvA+pe4tA8Oob7GG64iXgtJoDMGCeQ32HdHhrMgvwQieS3E5raMFTSuTUIhSCYZDgWStVeqesMPyXEJzOIUtlnWidILh3pzDYItJ9F0XX2xn2DLFxUgtFWXUGBIO7V1i6aA0iJW6C/zR7kMfhR3P8lktg+aaUUrBcFj7ilg0AdbNyNEoKaUalbTDt/xx2IVVlnHQsLy+JyFipfNe1kdJKbPGEEfADjUBPib41nMX30OJKbVg8I26CbbR/3w6oZYTZXPKvr99qZsS4bbefAQ2vMkKyTUHwfuQG6SVQdFo3sczKDFlb0qkNf4Eu+0pBrOCM5v58zeTYScUM8ouFKL0guE4Aw1zNwv2QXasjItlZ3ECKkAlBMMZxVptrZWpn0FtsRyzHWGD+kxDUAGqojEkHFpDeRL+DHV+pmnZgWlF+KNguNoPdRGvfyPTeBQAr7st02ym2HgllREMh5WXWZahp9Uw9TAK9z1o7PWmGdQHWDk3Ma2DLuAE4kH+qSD9Cnh/U9zxpR+VtMOHuwH+6xVvsZIGpzmQ13ub2Qrw40peby93vqhAdcfz+yCb9bidIKYzTW75eBGvNzbud1XTGEKhjHwj5wxK05y4gPa+QqEFsiVbk7tAdX9oO+ZkXuslJtMFOp7vODR2apzc9tWxSb+tnGCwYGWyPx3+7JXimDwjmHbOibDjjIrqtxrTDazME+GJgtUxaXFOnvLD276+nfdzY9I5KteUCBelT3MBw+HHqiykVztcYwSzF+CHvOxGR7ka8vxz0HmEpKH5xDy7IvK8mzOTh/zIDod8nue9I+E0lWxKpDU0C2nhnxq3FmMRfe+Qgc7+p3GuDXLCulMdRmSAx+ue70Nnobg0jVCISmqMJk5dfh35eYMFNSTivAoM/zL8AsTP4rn3izuA11FY6eMRz0E8z4UJ55EGlZaIWySU9hqTdnW5khqjhRPgx8qug9aObEF8dw1I01dQZKGkuZkLeI8dTf/4nfomdyN55XjfLCYHlRYMPujT8HeKPsZF8/0A/r0Gsx/Aj1N4b88nHeQCyGjkk7QL4hG8r1ntH/KzTZg9xLRBwu/lmpBpB+1KNyWChSM7C3VEffxUVbgKTqvpb3mvJRV0HM+zEjLtaMRnUESeNJGTZYKwm3xb+RtNvF2O5LiiC3n8RGSk8oIh3Pj/BpSDHVgRNyMjfAYtFKbRVH9EQ4jSOILLbnZcHrfHnhAMkbIjF5rjWAmnICd8Bu0sYLVgJyQUDyMHPSMYImBk3jT8mZXg0wQ13RM03BwLf3ZOM5HViaqPStopUmN4W7W7KDrboLES68M+PkIhekowXEzMzO27AVfx2nNggNsET9GN826Gtz/PcSk86ammRFAdr4rG3ECI3QujeJ1pXWtvMj7HODT2kstio7o778Nk//hea0r0xr3CrJsb9h44EMDFkOfU6GNehp9cbyUUoucEQ7CALkG2Qs3LTF5rLgJAjaFdrr+R4Se78DdmEYR6rilpwkLSGohWJ01jY7SgEdDGAwHCLvLeZb+RNxaXyS6LPSsYwu1fYumw1IqEwsrfZQm8Z5nd+TQJml6fwHt7EB70ZFPSxHl7hfAmPyOQUGwJ//vVEsHNbs0nNz2tMQQLaBgaoxSrQPCKFTZ2wDjON+9zY2baDMdqq1BZum2W14m7pzWGYMFoOGkZenH3AEKh/pA6sUlCIQMlLYhpJ8qke5D1+bXISc8LhmBFKvSiRbyNQ90w0prr0LD5jEPW6tvw+lotncm/t2NK6vhOirPliKPnm5JWWEjaWSnvNpwyi7MwDv4QKVdVNTcziddf1PbbTZndguRJsF352+uRgX4TDM2KKhhLVs8yNUdjBoyj9vJ+5HiUtKYhDTU5xmhZ+7EtQGc7T/EOGqOop5GSvmhKmrhZ0TRuA+0cEEAo1Bm+IOEwrXlM6CQUwoXb1sLbYzHnkQFSpt2S+kowhOtvZNn79RgXwMWaqYh3fzhYTRfTO0hAZoQubFOcmePWFMbUM6l91ZS0wkKSit444bB7WOBbwf7acgtY2OFr9SNkvpfLgZvnlkbUdHrUIqJWbEelCU3ddxqjBfmQxu0Lshj2MT2bdJru1sTZ2LxCIVx4SEUhujviaw2LU43O+lZjCL5dCnHQabEtSDgkXlMjm4vbPlbUoP3ymuHFXEvRAbT9d+v8SKq45f2sMZr9jagVyQMGwoVDavVqf8VdayNroRA85wxmo/DhtRdZlU9J+m1fC4ZwS/TntHx0Ij9LY8qfGb7BBzBTWAJ5hR3OtFaoazVR4H4mNZuT0JgmF4fyXmKH7H3dlDRxuy1rLuAlFmKwzXx5HbXvj2WdbDK+BzWfijE6l/fRcRRTC0ZNJH3flNREUwtGTSTvAwAA///2y1mvAAAABklEQVQDALNzu4AFm6hAAAAAAElFTkSuQmCC]],
        },
    }

    local function F1(Q1, _1, Z1, T1, R1, p1)
        local m1 = L1(Q1, _1, Z1, T1, R1)

        task.spawn(function()
            local asset = loadAsset(l1[1], l1[2])

            if asset then
                if not Q1.Parent then
                    return
                end
            else
                return
            end

            p1.Parent = Q1
            p1.Image = asset

            e(p1)
            m1:Destroy()
        end)
    end
    local function E(callback, l1, Q1)
        local createFrame = ctx.createFrame
        local Z1, T1 = createFrame({
            Parent = callback,
            AnchorPoint = R,
            Position = b,
            Size = x(l1, Q1),
            BackgroundTransparency = 0.84,
            D1(),
        }), ctx.createFrame
        local _1 = T1({
            Parent = Z1,
            Size = _,
            D1(),
            U1(L.a1, L.a2),
        })

        T1, callback = {
            Parent = Z1,
            AnchorPoint = vector2New(0, 0.5),
        }, ctx.udim2
        T1.Position = callback(0, 3, 0.5, 0)
        T1.Size = x(Q1 - 6, Q1 - 6)
        T1.ZIndex = 2

        _VX.setList(T1, 0, D1(), J1(0.6, color3FromRGB(0, 0, 0)))

        local L1 = frame(T1)

        local function Z1(T1, R1)
            local p1, m1 = T1 and 0 or 1, ctx.udim2
            local c1 = m1(0, T1 and l1 - Q1 + 3 or 3, 0.5, 0)

            if R1 then
                _1.BackgroundTransparency = p1
                L1.Position = c1

                return
            end

            k1(_1, {BackgroundTransparency = p1}, 0.26)
            k1(L1, {Position = c1}, 0.26)
        end

        return Z1
    end
    local function L1(l1, Q1, transparency, Z1, T1)
        G(l1.Focused, function()
            k1(Q1, {
                Transparency = transparency,
                Color = L.a1,
            }, 0.2)
        end)
        G(l1.FocusLost, function()
            k1(Q1, {
                Transparency = Z1,
                Color = L.wh,
            }, 0.25)

            if T1 then
                T1()
            end
        end)
    end
    local function updateBackgroundAlpha(Q1, _1)
        local Z1 = J1(0.86)

        Q1.BackgroundTransparency = Q1.BackgroundTransparency or 0.92
        Q1[1] = D1(9)
        Q1[2] = Z1

        local T1, udim2 = {}, ctx.udim2

        T1.Position = udim2(0, 10, 0.5, -9)
        T1.Size = x(18, 18)
        T1.Image = 'search'
        T1.ImageTransparency = 0.3
        Q1[3] = e(T1)
        Q1.ClipsDescendants = true
        T1, udim2 = {}, ctx.createFrame
        T1.Parent = udim2(Q1)
        T1.Position = x(35, 0)
        udim2 = ctx.udim2
        T1.Size = udim2(1, -43, 1, 0)
        T1.PlaceholderText = _1
        T1.TextSize = 14
        T1.ClipsDescendants = true
        Q1 = textBox(T1)

        L1(Q1, Z1, 0.55, 0.86)

        return Q1
    end

    local Q1 = {}

    Q1.ok = L.mint
    Q1.warn = L.gold
    Q1.err = L.red

    local _1 = {
        ok = 'ok',
        err = 'x',
        warn = 'warn',
    }

    local function Z1(T1)
        return Q1[T1] or L.sky, _1[T1] or 'info'
    end
    local function Q1(instance)
        for T1, T1 in ipairs(instance:GetChildren())do
            if T1:IsA('GuiObject') then
                T1:Destroy()
            end
        end
    end
    local function _1(T1)
        return {
            Set = function(R1, key, m1)
                R1 = T1[key]

                if R1 then
                    if R1.Text ~= m1 then
                        R1.Text = m1
                    end
                end
            end,
            Icon = function(R1, key, m1)
                R1 = T1[key] and T1[key].Parent:FindFirstChildOfClass('ImageLabel')

                if R1 then
                    if R1.Image ~= m1 then
                        R1.Image, R1.ImageColor3 = m1, B[m1] and L.a1 or color3FromRGB(255, 255, 255)
                    end
                end
            end,
        }
    end
    local function T1(parent, text, m1, c1, g1)
        local t1, o1 = {Parent = parent}, ctx.udim2

        t1.Position = o1(m1 / c1, m1 * 8 / c1, 0, 0)
        o1 = ctx.udim2
        t1.Size = o1(1 / c1, 8 / c1 - 8, 1, 0)
        t1.BackgroundTransparency = g1 and 0 or 0.92
        o1, parent = D1(13), g1 and U1(L.a1, L.a2, 90)
        c1, m1 = parent or J1(0.84), g1 and J1(0.55, L.a1:Lerp(L.wh, 0.5))

        local R1, y1 = m1 or nil, {
            Size = _,
            Text = text,
            FontFace = font6,
            TextSize = 16,
        }

        y1.TextColor3, y1.TextXAlignment = g1 and L.on or L.wh, center

        _VX.setList(t1, 0, o1, c1, R1, textLabel(y1))

        g1 = textButton(t1)

        n1(g1)

        return g1
    end

    local R1 = {}

    R1.__index = R1

    local function p1(m1)
        if m1.bq then
            return
        elseif m1.done == #m1.list then
            return
        end

        m1.bq = true

        task.defer(function()
            m1.bq = false

            local c1, g1, t1 = {0, 0}, table.clone(m1.list), {}

            table.sort(g1, function(o1, y1)
                return o1.card.AbsoluteSize.Y > y1.card.AbsoluteSize.Y
            end)

            local o1, y1 = true, true

            for f1, b1 in ipairs(g1)do
                f1 = b1.side or (c1[1] <= c1[2] and 1 or 2)

                if o1 then
                    local g1 = b1.side

                    o1 = if g1 then b1.side == 3 else not g1
                end

                t1[b1] = f1

                if f1 < 3 then
                    c1[f1] = c1[f1] + (b1.card.AbsoluteSize.Y + 16)
                end

                y1 = y1 and b1.card.AbsoluteSize.Y > 40
            end

            o1 = o1 and t1[m1.list[1] ] == 2

            for c1, g1 in next, t1 do
                g1 = o1 and g1 < 3 and 3 - g1 or g1

                if c1.card.Parent ~= m1.cols[g1] then
                    c1.card.Parent = m1.cols[g1]
                end
            end

            if y1 then
                m1.done = #m1.list
            end
        end)
    end

    ctx.mountGui = function(m1)
        if not (pcall(function()
            m1.Parent = gethui()
        end)) then
            m1.Parent = getService('CoreGui')
        end
    end

    local m1 = _VX.mountWindow

    ctx.Venyx.Window = function(c1, g1)
        g1 = g1 or {}

        local t1 = {Tabs = {}}
        local o1, y1 = g1.Key

        if o1 then
            y1 = o1
        else
            c1 = ctx.Enum
            y1 = c1.KeyCode.RightControl
        end

        t1.Key = y1
        t1.us = 1
        t1.open = true

        local f1 = m1(t1, tostring(g1.Id or 'Venyx'))

        t1.Gui = f1

        local m1, b1, z1 = 832, 510, ctx.createFrame

        t1.dim = z1({
            Parent = f1,
            Size = _,
            BackgroundColor3 = color3FromRGB(0, 0, 0),
        })

        pcall(function()
            t1.dim.Interactable = false
        end)

        t1.dz = 0.6
        z1 = ctx.createFrame

        local i1 = z1({
            Parent = f1,
            Active = true,
            ZIndex = 3,
            AnchorPoint = T,
            Position = Z,
            Size = x(m1, b1),
        })

        t1.Main = i1
        z1 = ctx.newInstance

        local uIScale, S1 = z1('UIScale', {Parent = i1}), ctx.newInstance

        o1, y1 = {
            Parent = i1,
            Position = x(-3, -3),
        }, ctx.udim2
        o1.Size = y1(1, 6, 1, 6)
        o1.BackgroundTransparency = 1
        o1.Visible = false

        local x1, B1 = S1('CanvasGroup', o1), ctx.createFrame
        local O1, G1 = B1({
            Parent = i1,
            Size = _,
        }), ctx.createFrame

        t1.bg = G1({
            Parent = O1,
            Size = _,
            BackgroundTransparency = 0.05,
            D1(16),
            U1(L.w1, L.w2, 90),
        })
        y1 = ctx.createFrame
        t1.tone = y1({
            Parent = O1,
            Size = _,
            BackgroundColor3 = color3FromRGB(0, 0, 0),
            D1(16),
        })
        t1.Tint = function(E1)
            E1 = ctx.State

            local u1 = E1.Theme == 'Black' and color3FromRGB(0, 0, 0)

            t1.bg:FindFirstChildOfClass('UIGradient').Color = ColorSequence.new(u1 or L.w1, u1 or L.w2)
        end
        t1.Tone = function(E1, E1)
            t1.tone.BackgroundColor3 = E1 < 0 and L.wh or color3FromRGB(0, 0, 0)
            t1.tone.BackgroundTransparency = 1 - math.abs(E1) / 100 * (E1 < 0 and 0.22 or 0.65)
        end

        t1:Tone(70)

        G1, y1 = {Parent = O1}, ctx.udim2
        G1.Size = y1(1, 0, 0.55, 0)

        _VX.setList(G1, 0, D1(16), a1(90, {0, 0.86}, {1, 1}))
        frame(G1)

        y1, z1 = {
            Parent = O1,
            Position = x(20, 1),
        }, ctx.udim2
        y1.Size = z1(1, -40, 0, 1)

        _VX.setList(y1, 0, a1(0, {0, 1}, {0.5, 0.3}, {1, 1}))
        frame(y1)

        B1, G1 = J1(0.7), ctx.createFrame

        G1({
            Parent = O1,
            Size = _,
            ZIndex = 5,
            D1(16),
            B1,
        })

        local function E1()
            local viewportSize, P1 = workspace.CurrentCamera.ViewportSize, UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and 0.88 or 1

            return math.clamp(math.min((viewportSize.X - 60) / m1, (viewportSize.Y - 20) / b1), 0.55, 1.3) * t1.us * P1
        end
        local function u1()
            if t1.open then
                k1(uIScale, {
                    Scale = E1(),
                }, 0.3)
            end
        end

        G(workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'), u1)

        t1.SetScale = function(scale, P1)
            t1.us = P1

            u1()
        end
        c1, o1 = {
            Parent = f1,
            AnchorPoint = T,
        }, ctx.udim2
        c1.Position = o1(0, 44, 0, 100 + t1.slot * 60)
        c1.Size = x(50, 50)
        c1.BackgroundTransparency = 0.12
        c1.BackgroundColor3 = L.bg
        c1.Visible = false

        _VX.setList(c1, 0, D1(18), J1(0.75))

        local u1, newInstance = textButton(c1), ctx.newInstance
        local j1 = newInstance('UIScale', {
            Parent = u1,
            Scale = 0,
        })

        y1, newInstance = {
            AnchorPoint = T,
            Position = Z,
            Size = x(29, 28),
        }, ctx.Enum
        y1.ScaleType = newInstance.ScaleType.Fit
        y1.ImageColor3 = L.tx

        F1(u1, 24, 30, Z, T, y1)

        local e1 = M1(vector2New(), function(s1)
            local q1 = ctx.udim2

            i1.Position = q1(0.5, s1.X, 0.5, s1.Y)
        end)
        local s1 = M1(vector2New(44, 100 + t1.slot * 60), function(q1)
            local Y1 = ctx.udim2

            u1.Position = Y1(0, q1.X, 0, q1.Y)
        end)
        local q1, Y1, X1 = P(), ctx.RunService, ctx.Enum

        newInstance, c1 = X1.RenderPriority.Camera.Value, function(P)
            A1(e1, P)

            if u1.Visible then
                A1(s1, P)
            end
        end

        Y1:BindToRenderStep(q1, newInstance + 1, c1)

        o1, z1 = {Parent = O1}, ctx.udim2
        o1.Size = z1(1, 0, 0, N)
        o1.ClipsDescendants = true
        c1, X1, B1 = ctx.createFrame, {}, ctx.udim2
        X1.Size = B1(1, 0, 1, 16)
        X1.BackgroundTransparency = 0.95

        _VX.setList(X1, 0, D1(16))
        _VX.setList(o1, 0, c1(X1))

        newInstance = textButton(o1)

        V(O1, x(0, N), ctx.udim2(1, 0, 0, 1))

        o1 = ctx.udim2
        Y1, B1, X1 = o1(0, S / 2, 0.5, 0), {AnchorPoint = T}, ctx.udim2
        B1.Position = X1(0, S / 2, 0.5, 0)
        B1.Size = x(25, 24)
        y1 = ctx.Enum
        B1.ScaleType = y1.ScaleType.Fit
        B1.ImageColor3 = L.tx

        F1(newInstance, 21, 26, Y1, T, B1)

        X1, Y1, G1 = ctx.createFrame, {
            Parent = newInstance,
            Position = x(S + 6, 0),
        }, ctx.udim2
        Y1.Size = G1(1, -S - 190, 1, 0)
        Y1.ClipsDescendants = true
        B1 = ctx.listLayout

        _VX.setList(Y1, 0, B1(10, nil, center2, horizontal))

        c1 = X1(Y1)
        Y1, B1 = {Parent = c1}, ctx.udim2
        Y1.Size = B1(0, 0, 1, 0)
        Y1.AutomaticSize = t
        Y1.Text = (g1.Title or 'Venyx'):upper()
        S1 = nil
        S1, Y1.FontFace = ctx.Enum, Font.new('rbxasset://fonts/families/Montserrat.json', ctx.Enum.FontWeight.Heavy)
        Y1.TextSize = 22

        textLabel(Y1)

        y1, z1 = {
            Parent = c1,
            LayoutOrder = 1,
        }, ctx.udim2
        y1.Size = z1(0, 0, 1, 0)
        y1.AutomaticSize = t
        y1.Text = '/'
        y1.TextSize = 13
        y1.TextTransparency = 0.6

        textLabel(y1)

        o1, z1 = {
            Parent = c1,
            LayoutOrder = 2,
        }, ctx.udim2
        o1.Size = z1(0, 0, 1, 0)
        o1.AutomaticSize = t
        o1.Text = g1.Game or ''
        o1.TextSize = 13
        o1.TextTransparency = 0.3
        o1.TextTruncate = atEnd
        S1 = ctx.newInstance

        _VX.setList(o1, 0, S1('UISizeConstraint', {
            MaxSize = vector2New(170, 99),
        }))

        local P = textLabel(o1)

        if g1.Version then
            textLabel({
                Parent = c1,
                LayoutOrder = 3,
                Size = x(0, 20),
                AutomaticSize = t,
                Text = g1.Version,
                FontFace = font6,
                TextSize = 11,
                TextTransparency = 0.25,
                TextXAlignment = center,
                BackgroundTransparency = 0.9,
                D1(),
                H1(0, 8),
            })
        end

        local F1 = frame({
            Size = x(7, 7),
            BackgroundColor3 = L.sky,
            D1(),
        })

        X1, B1 = {
            Size = x(0, 22),
            AutomaticSize = t,
            TextSize = 11,
            FontFace = font6,
            TextColor3 = L.val,
            LayoutOrder = 1,
            TextTruncate = atEnd,
        }, ctx.newInstance

        _VX.setList(X1, 0, B1('UISizeConstraint', {
            MaxSize = vector2New(270, 99),
        }))

        local K1, Dq = textLabel(X1), ctx.createFrame

        S1, G1 = {
            Parent = c1,
            LayoutOrder = 4,
            Size = x(0, 22),
            AutomaticSize = t,
            Visible = false,
            BackgroundTransparency = 0.9,
            BackgroundColor3 = L.sky,
        }, ctx.listLayout

        _VX.setList(S1, 0, D1(), H1(0, 10), G1(6, nil, center2, horizontal), F1, K1)

        local Jq = Dq(S1)

        t1.Status = function(Uq, aq, Hq)
            Uq = Z1(Hq)
            Jq.Visible = aq ~= nil and aq ~= ''

            if K1.Text == aq then
                if F1.BackgroundColor3 == Uq then
                    return
                end
            end

            K1.Text = aq or ''
            F1.BackgroundColor3 = Uq
            Jq.BackgroundColor3 = Uq
        end

        if not g1.Game then
            task.spawn(function()
                local F1, F1, g1 = ctx.game, pcall(getService('MarketplaceService').GetProductInfo, getService('MarketplaceService'), ctx.game.PlaceId)

                P.Text = F1 and g1 and g1.Name or ''
            end)
        end

        G1, c1 = {
            Parent = newInstance,
            AnchorPoint = R,
        }, ctx.udim2
        G1.Position = c1(1, -10, 0.5, 0)
        G1.Size = x(26, 26)
        G1.BackgroundTransparency = 0.92

        _VX.setList(G1, 0, D1(9), J1(0.86), u('minus', 18))

        c1 = textButton(G1)

        n1(c1)

        G1, y1 = {
            Parent = newInstance,
            AnchorPoint = R,
        }, ctx.udim2
        G1.Position = y1(1, -44, 0.5, 0)
        G1.Size = x(128, 26)

        local P, F1 = updateBackgroundAlpha(G1, 'Search'), ctx.createFrame

        B1, Dq = {
            Parent = O1,
            Position = x(0, N + 1),
        }, ctx.udim2
        B1.Size = Dq(0, S, 1, -N - 1)
        B1.ClipsDescendants = true
        y1, X1, G1 = ctx.createFrame, {
            Position = x(0, -16),
        }, ctx.udim2
        X1.Size = G1(1, 16, 1, 16)
        X1.BackgroundTransparency = 0.95

        _VX.setList(X1, 0, D1(16))
        _VX.setList(B1, 0, y1(X1))

        X1, Dq = F1(B1), ctx.udim2

        V(X1, Dq(1, -1, 0, 0), ctx.udim2(0, 1, 1, 0))

        S1, G1, o1 = ctx.createFrame, {
            Parent = X1,
            AnchorPoint = T,
        }, ctx.udim2
        G1.Position = o1(0.5, 0, 0, 29)
        G1.Size = x(38, 38)
        G1.BackgroundTransparency = 0.82

        _VX.setList(G1, 0, D1(12), J1(0.68))

        local g1, newInstance2 = S1(G1), ctx.newInstance
        local Jq = newInstance2('UIScale', {Parent = g1})

        S1, y1 = {
            Parent = X1,
            ZIndex = 2,
            Position = x(0, 8),
        }, ctx.udim2
        S1.Size = y1(1, 0, 1, -60)
        S1.ScrollBarThickness = 0
        y1 = ctx.listLayout

        _VX.setList(S1, 0, H1(2, 0), y1(4, center3))

        local Uq = scrollingFrame(S1)

        G1, Y1 = {
            Parent = X1,
            AnchorPoint = vector2New(0.5, 1),
        }, ctx.udim2
        G1.Position = Y1(0.5, 0, 1, -10)
        G1.Size = x(32, 32)
        G1.Image = K(48)
        G1.BackgroundTransparency = 0
        G1.BackgroundColor3 = L.a2

        _VX.setList(G1, 0, D1())
        e(G1)

        S1, F1 = {
            Parent = O1,
            Position = x(S + 18, N + 9),
        }, ctx.udim2
        S1.Size = F1(1, -S - 36, 0, 26)
        S1.FontFace = font6
        S1.TextSize = 20

        local aq, Hq = textLabel(S1), ctx.createFrame

        newInstance2, G1 = {
            Parent = O1,
            Position = x(S, N + 41),
        }, ctx.udim2
        newInstance2.Size = G1(1, -S, 1, -N - 49)
        newInstance2.ClipsDescendants = true

        local kq = Hq(newInstance2)

        d1(newInstance, e1, function(rq)
            local Cq, wq = workspace.CurrentCamera.ViewportSize, i1.AbsoluteSize
            local Vq, Wq = Cq.X / 2 + wq.X / 2 - 90, Cq.Y / 2 + wq.Y / 2 - 60

            return vector2New(math.clamp(rq.X, -Vq, Vq), math.clamp(rq.Y, -Wq, Wq))
        end)

        local rq = d1(u1, s1, function(s1)
            local Cq = workspace.CurrentCamera.ViewportSize

            return vector2New(math.clamp(s1.X, 30, Cq.X - 30), math.clamp(s1.Y, 30, Cq.Y - 30))
        end)

        Y1, newInstance = {
            Parent = O1,
            AnchorPoint = vector2New(1, 1),
        }, ctx.udim2
        Y1.Position = newInstance(1, -3, 1, -3)
        Y1.Size = x(22, 22)
        Y1.ZIndex = 6
        X1, newInstance2 = textButton(Y1), {
            {14, 11},
            {7, 16},
        }

        for s1, s1 in ipairs(newInstance2)do
            frame({
                Parent = X1,
                AnchorPoint = T,
                Position = x(s1[2], s1[2]),
                Size = x(s1[1], 2),
                Rotation = -45,
                BackgroundTransparency = 0.4,
                ZIndex = 6,
                D1(),
            })
        end

        G(X1.InputBegan, function(s1)
            if not (V1(s1)) then
                return
            end

            local position = s1.Position
            local Cq = vector2New(i1.Size.X.Offset, i1.Size.Y.Offset)
            local wq, Vq = uIScale.Scale
            local Wq, Iq = e1.p - Cq * wq / 2

            Iq, i1.AnchorPoint, i1.Position = ctx.udim2, vector2New(), ctx.udim2(0.5, Wq.X, 0.5, Wq.Y)

            local function Iq(vq)
                if vq ~= s1 then
                    local hq = ctx.Enum

                    if vq.UserInputType ~= hq.UserInputType.MouseMovement then
                        return
                    end
                end

                local hq, nq = (vq.Position - position) / wq, workspace.CurrentCamera.ViewportSize / wq

                i1.Size = x(math.clamp(Cq.X + hq.X, m1, math.max(m1, nq.X - 40)), math.clamp(Cq.Y + hq.Y, b1, math.max(b1, nq.Y - 20)))
            end

            local m1 = UserInputService.InputChanged:Connect(Iq)

            local function b1(K1)
                local Cq, Iq = K1 == s1

                if Cq then
                    Iq = Cq
                else
                    local s1

                    s1, Iq = ctx.Enum, K1.UserInputType == ctx.Enum.UserInputType.MouseButton1
                end
                if Iq then
                    m1:Disconnect()
                    Vq:Disconnect()

                    Cq = Wq + vector2New(i1.Size.X.Offset, i1.Size.Y.Offset) * wq / 2
                    i1.AnchorPoint = T
                    e1.t = Cq
                    e1.p = Cq

                    e1.a(Cq)
                end
            end

            Vq = UserInputService.InputEnded:Connect(b1)
        end)

        local m1 = 0

        t1.Show = function(b1, e1)
            t1.open = e1

            m1 += 1

            local s1 = m1

            b1 = E1()

            if O1.Parent ~= x1 then
                local E1

                E1, O1.Position, O1.Size = ctx.udim2, x(3, 3), ctx.udim2(1, -6, 1, -6)
                O1.Parent = x1
                x1.GroupTransparency = e1 and 1 or 0
            end

            uIScale.Scale = b1
            x1.Visible = true
            i1.Visible = true

            local E1, K1 = t1.dim, {}

            K1.BackgroundTransparency = e1 and 1 - t1.dz or 1

            k1(E1, K1, 0.3)

            E1, b1 = ctx.Enum, ctx.Enum

            k1(x1, {
                GroupTransparency = e1 and 0 or 1,
            }, e1 and 0.28 or 0.18, ctx.Enum.EasingStyle.Sine, ctx.Enum.EasingDirection.Out)
            task.delay(e1 and 0.3 or 0.2, function()
                if m1 ~= s1 then
                    return
                end

                x1.Visible = false

                local m1 = ctx.udim2

                O1.Position = m1()
                O1.Size = _
                O1.Parent = i1

                if not e1 then
                    i1.Visible = false
                end
            end)

            if u1.Visible then
                j1.Scale = 0.85

                k1(j1, {Scale = 1}, 0.3, back)
            else
                u1.Visible = true
                j1.Scale = 0

                k1(j1, {Scale = 1}, 0.4, back)
            end
        end

        v1(c1, function()
            t1:Show(false)
        end)
        v1(u1, function()
            if not (rq()) then
                t1:Show(not t1.open)
            end
        end)
        G(UserInputService.InputBegan, function(m1, b1)
            if not b1 then
                if m1.KeyCode == t1.Key then
                    t1:Show(not t1.open)
                end
            end
        end)

        local m1 = textButton({
            Parent = O1,
            Size = _,
            BackgroundColor3 = color3FromRGB(5, 6, 16),
            ZIndex = 20,
            Visible = false,
            ClipsDescendants = true,
            D1(16),
        })

        Dq, c1 = {Parent = m1}, ctx.topRight
        Dq.AnchorPoint = c1
        o1 = ctx.udim2
        Dq.Position = o1(1, 420, 0, 6)
        Hq = ctx.udim2
        Dq.Size = Hq(0, 390, 1, -12)
        Dq.BackgroundTransparency = 0.02
        Dq.BackgroundColor3 = L.pn

        _VX.setList(Dq, 0, D1(14), J1(0.84))

        local b1 = textButton(Dq)

        z1, c1 = {
            Parent = b1,
            Position = x(18, 14),
        }, ctx.udim2
        z1.Size = c1(1, -80, 0, 20)
        z1.FontFace = font6
        z1.TextSize = 15

        local i1 = textLabel(z1)

        Y1, Hq = {
            Parent = b1,
            Position = x(18, 34),
        }, ctx.udim2
        Y1.Size = Hq(1, -80, 0, 14)
        Y1.TextSize = 11
        Y1.TextTransparency = 0.32

        local z1, x1, E1 = textLabel(Y1), {Parent = b1}, ctx.topRight

        x1.AnchorPoint = E1
        Dq = ctx.udim2
        x1.Position = Dq(1, -12, 0, 10)
        x1.Size = x(40, 40)
        x1.BackgroundTransparency = 0.92

        _VX.setList(x1, 0, D1(12), u('x', 22))

        F1, Dq, E1 = textButton(x1), {
            Parent = b1,
            Position = x(14, 60),
        }, ctx.udim2
        Dq.Size = E1(1, -28, 0, 40)
        Dq.BackgroundTransparency = 0.93

        local u1 = updateBackgroundAlpha(Dq, 'Filter')

        Y1, G1, o1, y1, B1 = {
            Parent = b1,
            Position = x(12, 108),
        }, H1(3), ctx.newInstance, {}, ctx.udim2
        y1.CellSize = B1(0.5, -5, 0, 44)
        y1.CellPadding = x(8, 8)
        c1 = ctx.Enum
        y1.SortOrder = c1.SortOrder.LayoutOrder

        _VX.setList(Y1, 0, G1, o1('UIGridLayout', y1))

        local j1, e1 = scrollingFrame(Y1), ctx.createFrame

        c1, Hq = {
            Parent = b1,
            AnchorPoint = vector2New(0, 1),
        }, ctx.udim2
        c1.Position = Hq(0, 14, 1, -14)
        o1 = ctx.udim2
        c1.Size = o1(1, -28, 0, 44)

        local o1 = e1(c1)

        B1, newInstance, E1 = T1(o1, 'Default', 0, 3), T1(o1, 'Clear', 1, 3), T1(o1, 'Select all', 2, 3, true)
        -- Registers Activated signal callback(s)
        t1.Dialog = function(c1, s1)
            local Y1 = s1 or {}

            if t1.dlg then
                t1.dlg.Close()
            end
            if not t1.open then
                t1:Show(true)
            end

            local s1, K1 = Z1(Y1.Kind)

            c1 = ctx.newInstance

            local Dq = c1('UIScale', {Scale = 0.9})
            local c1 = textButton({
                Parent = O1,
                Size = _,
                BackgroundColor3 = color3FromRGB(5, 6, 16),
                ZIndex = 30,
                D1(16),
            })
            local Hq, rq, Cq, wq, Vq = {
                Parent = c1,
                AnchorPoint = T,
                Position = Z,
                Size = x(400, 0),
                AutomaticSize = g,
                BackgroundTransparency = 0.02,
                BackgroundColor3 = L.pn,
            }, D1(18), J1(0.8), H1(22), ctx.listLayout
            local Wq, Iq, vq, hq = Vq(16), ctx.createFrame, {}, ctx.udim2

            vq.Size = hq(1, 0, 0, 46)
            Vq = ctx.createFrame

            local hq, nq, Mq = Vq({
                Size = x(46, 46),
                BackgroundTransparency = 0.8,
                BackgroundColor3 = s1,
                D1(14),
                u(Y1.Icon or K1, 24, s1),
            }), {
                Position = x(60, 0),
            }, ctx.udim2

            nq.Size = Mq(1, -60, 1, 0)
            nq.Text = Y1.Title or ''
            nq.FontFace = font6
            nq.TextSize = 17
            nq.TextWrapped = true

            _VX.setList(vq, 0, hq, textLabel(nq))
            _VX.setList(Hq, 0, rq, Cq, wq, Wq, Dq, Iq(vq))

            local K1 = textButton(Hq)

            if Y1.Text then
                textLabel({
                    Parent = K1,
                    LayoutOrder = 1,
                    Size = f,
                    AutomaticSize = g,
                    Text = Y1.Text,
                    TextSize = 13,
                    TextTransparency = 0.25,
                    TextWrapped = true,
                })
            end

            Wq, Iq, rq = ctx.createFrame, {
                Parent = K1,
                LayoutOrder = 2,
            }, ctx.udim2
            Iq.Size = rq(1, 0, 0, 42)

            local Hq, Cq = Wq(Iq), {}

            -- Registers Completed signal callback(s)
            Cq.Close = function(Wq)
                if t1.dlg == Cq then
                    t1.dlg = nil
                end

                k1(Dq, {Scale = 0.92}, 0.18)

                local vq, nq = k1(c1, {BackgroundTransparency = 1}, 0.2), function()
                    c1:Destroy()
                end

                vq.Completed:Connect(nq)

                K1.Visible = false

                w1(Wq)
            end
            hq = Y1.Buttons or {
                {
                    'OK',
                },
            }

            for index, Wq in ipairs(hq)do
                Vq, Iq, wq = Wq[1], index - 1, #hq
                s1, rq = T1(Hq, Vq, Iq, wq, Wq[3]), function()
                    if I1() then
                        Cq.Close(Wq[2])
                    end
                end

                s1.Activated:Connect(rq)
            end

            local function s1()
                if Y1.Cancel ~= false then
                    Cq.Close(Y1.Cancel)
                end
            end

            c1.Activated:Connect(s1)

            t1.dlg = Cq

            k1(c1, {BackgroundTransparency = 0.45}, 0.2)
            k1(Dq, {Scale = 1}, 0.35, back)

            return Cq
        end

        local function c1(s1, Y1, K1, Dq, Hq, rq)
            t1:Dialog({
                Title = s1,
                Text = Y1,
                Kind = K1,
                Buttons = {
                    {
                        rq or 'Cancel',
                    },
                    {Dq, Hq, true},
                },
            })
        end
        local function s1()
            local Y1 = ctx.Venyx

            Y1:Save()

            local Y1, state = ctx.Venyx, ctx.State

            Y1:Notify('Config saved', state.Active, 'ok')
        end
        local function Y1(K1, Dq)
            local Hq = ctx.Venyx

            Hq:Notify(Dq, K1 or '', pcall(setclipboard, K1) and 'ok' or 'err')
        end

        n1(F1)

        local K1 = {
            bt = {},
            sel = {},
        }

        local function Dq()
            K1.open = false

            k1(m1, {BackgroundTransparency = 1}, 0.22)

            local Hq, rq = {}, ctx.udim2

            Hq.Position = rq(1, 540, 0, 6)
            rq = ctx.Enum

            C1(k1(b1, Hq, 0.28, quint, rq.EasingDirection.In), m1, function()
                return K1.open
            end)
        end
        local function Hq()
            for rq, Cq in next, K1.bt do
                local wq = K1.sel[rq] ~= nil

                k1(Cq[1], {
                    BackgroundTransparency = wq and 0.72 or 0.93,
                    BackgroundColor3 = wq and L.a1 or L.wh,
                }, 0.18)
                k1(Cq[2], {
                    Transparency = wq and 0.2 or 0.82,
                    Color = wq and L.a1:Lerp(L.wh, 0.35) or L.wh,
                }, 0.18)

                local rq, Vq = Cq[3], {}

                Vq.ImageTransparency = wq and 0 or 1

                k1(rq, Vq, 0.18)
            end
        end
        local function rq()
            Hq()

            local Cq = {}

            for wq, wq in ipairs(K1.o)do
                if K1.sel[wq] then
                    Cq[#Cq + 1] = wq
                end
            end

            w1(K1.d, Cq)
        end

        t1.Sync = function(Cq, Cq)
            if K1.open then
                if not (K1.ob == Cq) then
                    return
                end
            else
                return
            end

            K1.sel = {}

            for wq, wq in ipairs(Cq.Multi and Cq.Value or {
                Cq.Value,
            })do
                K1.sel[wq] = true
            end

            Hq()
        end
        t1.Pick = function(Cq, wq, Vq, Wq, Iq, vq, hq, nq)
            K1.ob = nq
            i1.Text = wq
            z1.Text = Iq and 'Pick any' or 'Pick one'
            u1.Text = ''

            Q1(j1)

            wq = hq or {}
            K1.bt = {}
            K1.sel = {}
            K1.d = vq
            K1.o = {}
            K1.def = wq

            for z1, z1 in ipairs(Iq and Wq or {Wq})do
                K1.sel[z1] = true
            end

            Wq, nq = type(Vq[1]) == 'table'
            nq, j1:FindFirstChildOfClass('UIGridLayout').CellSize = ctx.udim2, ctx.udim2(0.5, -5, 0, Wq and 54 or 44)
            nq = ctx.udim2
            b1.Size = nq(0, Wq and 500 or 390, 1, -12)
            wq = ipairs

            for z1, i1 in wq(Vq)do
                local wq = Wq and i1.v or i1

                K1.o[z1] = wq
                hq, nq = J1(0.82), ctx.createFrame
                Cq = nq({
                    Parent = j1,
                    LayoutOrder = z1,
                })
                z1 = textButton({
                    Parent = Cq,
                    AnchorPoint = T,
                    Position = Z,
                    Size = _,
                    BackgroundTransparency = 0.93,
                    D1(13),
                    hq,
                })

                if Wq then
                    local Vq, Mq, Aq, dq, Lq, lq = ctx.createFrame, {
                        Parent = z1,
                        Position = x(5, 5),
                        Size = x(44, 44),
                        BackgroundTransparency = 0.72,
                        BackgroundColor3 = i1.col or L.a1,
                    }, D1(12), J1(0.6, i1.col), {
                        AnchorPoint = T,
                        Position = Z,
                    }, ctx.udim2

                    Lq.Size = lq(1, 2, 1, 2)
                    Lq.Image = i1.img or ''
                    lq = ctx.Enum
                    Lq.ScaleType = lq.ScaleType.Fit

                    _VX.setList(Mq, 0, Aq, dq, imageLabel(Lq))
                    Vq(Mq)

                    lq, dq = {
                        Parent = z1,
                        Position = x(56, 3),
                    }, ctx.udim2
                    lq.Size = dq(1, -60, 0, 28)
                    lq.Text = i1.t or tostring(wq)
                    lq.FontFace = font5
                    lq.TextSize = 17
                    lq.TextTruncate = atEnd

                    textLabel(lq)

                    Mq, Aq, lq = ctx.createFrame, {
                        Parent = z1,
                        Position = x(57, 32),
                    }, ctx.udim2
                    Aq.Size = lq(1, -90, 0, 17)
                    Aq.ClipsDescendants = true
                    dq = ctx.listLayout

                    _VX.setList(Aq, 0, dq(6, nil, center2, horizontal))

                    Vq = Mq(Aq)
                    Mq, Lq = {Parent = Vq}, ctx.udim2
                    Mq.Size = Lq(0, 0, 1, 0)
                    Mq.AutomaticSize = t
                    Mq.Text = (i1.sub or ''):upper()
                    Mq.FontFace = font3
                    Mq.TextSize = 12.5
                    Mq.TextColor3 = i1.grad and L.wh or i1.col or L.val
                    Aq = ctx.newInstance

                    _VX.setList(Mq, 0, Aq('UIStroke', {
                        Thickness = 1.2,
                        Color = color3FromRGB(0, 0, 0),
                    }))

                    local Aq = textLabel(Mq)

                    if i1.grad then
                        i1.grad:Clone().Parent = Aq
                    end
                    if i1.note then
                        Lq, Mq = {
                            Parent = Vq,
                            LayoutOrder = 1,
                        }, ctx.udim2
                        Lq.Size = Mq(1, -6, 1, 0)
                        Lq.Text = i1.note
                        Lq.FontFace = font6
                        Lq.TextSize = 12.5
                        Lq.RichText = true
                        Lq.TextTruncate = atEnd
                        dq = ctx.newInstance

                        _VX.setList(Lq, 0, dq('UIStroke', {
                            Thickness = 1.2,
                            Color = color3FromRGB(0, 0, 0),
                        }))

                        local Vq = textLabel(Lq)

                        local function Mq()
                            local dq = ctx.udim2

                            Vq.Size = dq(1, -Aq.AbsoluteSize.X - 6, 1, 0)
                        end

                        Aq:GetPropertyChangedSignal('AbsoluteSize'):Connect(Mq)
                        Mq()
                    end
                else
                    local Vq, Mq = {
                        Parent = z1,
                        Position = x(14, 0),
                    }, ctx.udim2

                    Vq.Size = Mq(1, -40, 1, 0)
                    Vq.Text = tostring(wq)
                    Vq.FontFace = font6
                    Vq.TextSize = 12
                    Vq.TextWrapped = true
                    Vq.LineHeight = 0.95

                    textLabel(Vq)
                end

                local Vq, Mq, Aq, dq = K1.bt, {}, {
                    Parent = z1,
                    AnchorPoint = Wq and vector2New(1, 1) or R,
                }

                if Wq then
                    local Lq = ctx.udim2

                    dq = (Lq(1, -9, 1, -8))
                else
                    dq = Wq
                end

                local Lq

                if dq then
                    Lq = dq
                else
                    local dq = ctx.udim2

                    Lq = (dq(1, -12, 0.5, 0))
                end

                Aq.Position = Lq
                Aq.Size = x(18, 18)
                Aq.Image = 'check'
                Aq.ImageTransparency = 1

                _VX.setList(Mq, 0, z1, hq, e(Aq), Cq, (tostring(wq) .. ' ' .. (Wq and (i1.t or '') .. ' ' .. (i1.sub or '') .. ' ' .. (i1.note or '') or '')):lower())

                Vq[wq] = Mq

                n1(z1, 0.95)
                v1(z1, function()
                    if Iq then
                        local z1, i1 = K1.sel, K1.sel[wq]

                        z1[wq] = if i1 then nil else not i1

                        rq()
                    else
                        K1.sel = {[wq] = true}

                        Hq()
                        Dq()
                        w1(vq, wq)
                    end
                end)
            end

            o1.Visible = Iq == true
            hq = ctx.udim2
            j1.Size = hq(1, -24, 1, Iq and -176 or -120)

            Hq()

            K1.open = true
            m1.Visible = true

            k1(m1, {BackgroundTransparency = 0.45}, 0.25)

            nq, Cq = {}, ctx.udim2
            nq.Position = Cq(1, -6, 0, 6)

            k1(b1, nq, 0.45)
        end

        G(u1:GetPropertyChangedSignal('Text'), function()
            local o1 = u1.Text:lower()

            for b1, b1 in next, K1.bt do
                b1[4].Visible = b1[5]:find(o1, 1, true) ~= nil
            end
        end)
        v1(F1, Dq)
        v1(m1, Dq)

        local function F1(m1)
            K1.sel = {}

            for o1, o1 in ipairs(m1)do
                K1.sel[o1] = true
            end

            rq()
        end

        v1(B1, function()
            F1(K1.def)
        end)
        v1(newInstance, function()
            F1({})
        end)
        v1(E1, function()
            F1(K1.o)
        end)

        local function F1(m1)
            return 29 + (m1.i - 1) * 42 - Uq.CanvasPosition.Y
        end

        G(Uq:GetPropertyChangedSignal('CanvasPosition'), function()
            if t1.Cur then
                local m1 = ctx.udim2

                g1.Position = m1(0.5, 0, 0, F1(t1.Cur))
            end
        end)

        local function m1(o1, b1, z1)
            local i1, B1, E1 = ctx.createFrame, {
                Parent = b1,
                LayoutOrder = z1,
                Size = f,
                AutomaticSize = g,
            }, ctx.listLayout

            _VX.setList(B1, 0, E1(16))

            b1, E1 = i1(B1), ctx.createFrame
            z1, B1 = {
                Parent = b1,
                LayoutOrder = 1,
                Size = f,
                AutomaticSize = g,
            }, ctx.listLayout

            _VX.setList(z1, 0, B1(16, nil, nil, horizontal))

            i1 = E1(z1)
            o1.cols = {}
            o1.list = {}
            o1.crow = b1

            for z1 = 1, 2, 1 do
                local cols, createFrame, P1, j1, j1 = o1.cols, ctx.createFrame, {
                    Parent = i1,
                    LayoutOrder = z1,
                }, ctx.udim2

                P1.Size, P1.AutomaticSize, j1 = ctx.udim2(0.5, -8, 0, 0), g, ctx.listLayout

                _VX.setList(P1, 0, ctx.listLayout(16))

                cols[z1] = ctx.createFrame(P1)
            end

            local z1, createFrame, u1, udim2, listLayout = o1.cols, ctx.createFrame, {
                Parent = b1,
                LayoutOrder = 2,
            }, ctx.udim2

            u1.Size, u1.AutomaticSize, u1.Visible, listLayout = ctx.udim2(0.5, -8, 0, 0), g, false, ctx.listLayout

            _VX.setList(u1, 0, ctx.listLayout(16))

            z1[3] = ctx.createFrame(u1)
            B1, i1, E1, z1 = o1.cols, ctx.createFrame, {
                Parent = b1,
                LayoutOrder = 0,
                Size = f,
                AutomaticSize = g,
                Visible = false,
            }, ctx.listLayout

            _VX.setList(E1, 0, ctx.listLayout(16))

            B1[4] = ctx.createFrame(E1)
        end
        local function o1(b1, z1)
            local i1 = b1.on and b1.on.chip

            if i1 then
                if i1.AbsoluteSize.X == 0 then
                    return
                end
            else
                return
            end

            local B1 = {
                Position = x((i1.AbsolutePosition.X - b1.row.AbsolutePosition.X) / uIScale.Scale, 0),
                Size = x(i1.AbsoluteSize.X / uIScale.Scale, 24),
            }

            if z1 then
                b1.hl.Position, b1.hl.Size = B1.Position, B1.Size
            else
                k1(b1.hl, B1, 0.38)
            end
        end
        local function b1(z1, i1)
            if z1.on == i1 then
                return
            end

            z1.on = i1

            for B1, B1 in ipairs(z1.subs)do
                local E1, u1 = B1.chip, {}

                u1.TextTransparency = B1 == i1 and 0 or 0.5

                k1(E1, u1, 0.2)
            end

            o1(z1)
        end
        -- Runs polling loop until condition succeeds or timeout expires (os.clock)
        local function z1(i1)
            if os.clock() < (i1.lock or 0) then
                return
            end

            local B1, E1, u1, P1 = uIScale.Scale, i1.sc.AbsolutePosition.Y, i1.sc.AbsoluteCanvasSize.Y - i1.sc.AbsoluteWindowSize.Y, i1.subs[1]

            for j1, j1 in ipairs(i1.subs)do
                P1 = if j1.g.AbsolutePosition.Y - E1 <= 40 * B1 then j1 else P1
            end

            b1(i1, if u1 > 0 then if i1.sc.CanvasPosition.Y >= u1 - 2 then i1.subs[#i1.subs]else P1 else P1)
        end
        local function i1(B1, E1, u1)
            local P1 = B1.CanvasPosition.Y + E1.AbsolutePosition.Y - B1.AbsolutePosition.Y - u1 * uIScale.Scale

            k1(B1, {
                CanvasPosition = vector2New(0, math.clamp(P1, 0, math.max(0, B1.AbsoluteCanvasSize.Y - B1.AbsoluteWindowSize.Y))),
            }, 0.45)
        end
        local function N1(B1, E1)
            B1.lock = os.clock() + 0.5

            i1(B1.sc, E1.g, 4)
            b1(B1, E1)
        end

        t1.Select = function(B1, E1)
            local cur = t1.Cur

            if cur == E1 then
                return
            end

            P.Text = ''
            t1.Cur = E1

            for index, value in ipairs(E1.subs or {})do
                p1(value)
            end

            if E1.list then
                p1(E1)
            end

            for index, j1 in ipairs(t1.Tabs)do
                if j1.bar then
                    j1.bar.Visible = j1 == E1

                    task.defer(o1, j1, true)
                end

                B1, index = j1.im, {}
                index.ImageTransparency = j1 == E1 and 0 or 0.45

                k1(B1, index, 0.3)
            end

            local P1, j1 = {}, ctx.udim2

            P1.Position = j1(0.5, 0, 0, F1(E1))

            k1(g1, P1, 0.42)

            Jq.Scale = 0.86

            k1(Jq, {Scale = 1}, 0.5, back)

            j1 = cur and (cur.i > E1.i and -1 or 1) or 0

            if cur then
                cur.k = cur.k + 1

                local F1 = cur.k
local g1, P1, Dq =cur.fr, {}, ctx.udim2

                P1.Position = ctx.udim2(-j1, 0, 0, 0)

                C1(k1(g1, P1, 0.5), cur.fr, function()
                    return cur.k ~= F1 or t1.Cur == cur
                end)
            end

            E1.k = E1.k + 1

            if not E1.fr.Visible then
                B1 = nil
                B1, E1.fr.Position = ctx.udim2, ctx.udim2(j1, 0, 0, 0)
            end

            E1.fr.Visible = true
local
C1, F1, g1 =E1.fr, {}, ctx.udim2

            F1.Position = ctx.udim2()

            k1(C1, F1, 0.5)

            aq.Text = E1.Title or E1.Name
            aq.Position = x(S + 18 + j1 * 24, N + 9)
            aq.TextTransparency = 0.7

            k1(aq, {
                Position = x(S + 18, N + 9),
                TextTransparency = 0,
            }, 0.45)
        end
        t1.nest = {}
        t1.Grip = function(S, C1, F1)
            local function g1()
                return C1.AbsoluteCanvasSize.Y / math.max(C1.AbsoluteWindowSize.Y, 1)
            end

            local B1, E1 = {Parent = F1}, ctx.topRight

            B1.AnchorPoint = E1
            E1 = ctx.udim2
            B1.Position = E1(1, 0, 0, 0)
            F1 = ctx.udim2
            B1.Size = F1(0, 14, 1, 0)
            B1.ZIndex = 8
            B1.Visible = not UserInputService.TouchEnabled
            S, F1, E1 = textButton(B1), setmetatable, {
                __index = function()
                    return vector2New(0, C1.CanvasPosition.Y / g1())
                end,
                __newindex = function(B1, B1, B1)
                    t1.goal = math.clamp(B1.Y * g1(), 0, math.max(0, C1.AbsoluteCanvasSize.Y - C1.AbsoluteWindowSize.Y))
                    t1.gf = C1
                    C1.CanvasPosition = vector2New(0, t1.goal)
                end,
            }

            d1(S, F1({}, E1), function(S)
                return S
            end)
        end
        t1.Tab = function(callback, C1, d1, F1)
            local g1 = {
                Name = C1,
                W = t1,
                Secs = {},
            }

            g1.i = #t1.Tabs + 1
            g1.k = 0
            g1.top = g1
            callback = ctx.createFrame
            g1.fr = callback({
                Parent = kq,
                Size = _,
                Visible = false,
            })

            if F1 then
                callback = ctx.createFrame
                g1.sc = callback({
                    Parent = g1.fr,
                    Size = _,
                    H1(6, 16, 6),
                })
            else
                local S, B1 = {
                    Parent = g1.fr,
                    Size = _,
                    ScrollingEnabled = UserInputService.TouchEnabled,
                    ScrollBarThickness = 3,
                    ScrollBarImageColor3 = L.wh,
                    ScrollBarImageTransparency = 0.7,
                }, ctx.Enum

                S.ElasticBehavior = B1.ElasticBehavior.Always
                B1 = ctx.listLayout

                _VX.setList(S, 0, H1(4, 0, 12), B1(12, center3))

                g1.sc = scrollingFrame(S)

                local createFrame, B1, E1 = ctx.createFrame, {
                    Parent = g1.sc,
                }, ctx.udim2

                B1.Size = E1(1, -36, 0, 0)
                B1.AutomaticSize = g
                g1.g = createFrame(B1)

                G(g1.sc.InputChanged, function(S)
                    local B1 = ctx.Enum

                    if S.UserInputType == B1.UserInputType.MouseWheel then
                        t1:Wheel(S.Position.Z)
                    end
                end)
                t1:Grip(g1.sc, g1.fr)
                G(g1.sc.MouseWheelForward, function()
                    t1:Wheel(1)
                end)
                G(g1.sc.MouseWheelBackward, function()
                    t1:Wheel(-1)
                end)
                m1(g1, g1.g, 0)

                g1.subs = {}
            end

            F1 = textButton({
                Parent = Uq,
                Size = x(38, 38),
                LayoutOrder = g1.i,
            })
            g1.im = e({
                Parent = F1,
                AnchorPoint = T,
                Position = Z,
                Size = x(24, 24),
                Image = d1 or 'grid',
                ImageTransparency = 0.45,
            })

            n1(g1.im, 0.8, F1, function(S)
                if t1.Cur == g1 then
                    k1(Jq, {
                        Scale = S and 0.9 or 1,
                    }, S and 0.12 or 0.45, S and quint or back)
                end
            end)
            v1(F1, function()
                t1:Select(g1)
            end)

            t1.Tabs[g1.i] = g1
            g1.Section = function(S, S, d1, F1)
                return R1.new(g1, S, d1, F1)
            end
            g1.Arrange = function(S, d1)
                for F1, B1 in ipairs(d1)do
                    for d1, E1 in ipairs(B1)do
                        for B1, B1 in ipairs(S.Secs)do
                            if B1.name == E1 then
                                B1.side, B1.card.LayoutOrder = F1, d1
                            end
                        end
                    end
                end

                S.done = -1

p1(S)
            end
            g1.Sub = function(callback, d1)
                local F1 = {}

                F1.Name = C1 .. ' / ' .. d1
                F1.W = t1
                F1.Secs = g1.Secs
                F1.i = #g1.subs + 1
                F1.sc = g1.sc
                F1.top = g1

                if #g1.subs == 0 then
                    g1.g.Visible = #g1.Secs > 0

                    local C1, B1, E1 = ctx.createFrame, {Parent = O1}, ctx.topRight

                    B1.AnchorPoint = E1
                    callback = ctx.udim2
                    B1.Position = callback(1, -18, 0, N + 7)
                    B1.Size = x(0, 30)
                    B1.AutomaticSize = t
                    B1.Visible = t1.Cur == g1
                    B1.BackgroundTransparency = 0.95

                    _VX.setList(B1, 0, D1(), J1(0.88), H1(3))

                    g1.bar = C1(B1)
                    E1 = ctx.createFrame
                    g1.hl = E1({
                        Parent = g1.bar,
                        Size = x(0, 24),
                        BackgroundTransparency = 0.84,
                        D1(),
                    })
                    E1, C1, B1 = ctx.createFrame, {
                        Parent = g1.bar,
                        Size = x(0, 24),
                        AutomaticSize = t,
                        ZIndex = 2,
                    }, ctx.listLayout

                    _VX.setList(C1, 0, B1(4, nil, center2, horizontal))

                    g1.row = E1(C1)

                    G(g1.row:GetPropertyChangedSignal('AbsoluteSize'), function()
                        o1(g1, true)
                    end)
                    G(g1.sc:GetPropertyChangedSignal('CanvasPosition'), function()
                        z1(g1)
                    end)
                end

                local C1, o1 = {}, ctx.udim2

                C1.Size = o1(1, 0, 0, 18)
                o1, callback = {}, ctx.udim2
                o1.Size = callback(1, -30, 1, 0)
                o1.Text = d1:upper()
                o1.FontFace = font5
                o1.TextSize = 12
                o1.TextTransparency = 0.35

                _VX.setList(C1, 0, textLabel(o1))

                o1 = textButton(C1)
                C1, callback = {
                    Parent = o1,
                    AnchorPoint = T,
                }, ctx.udim2
                C1.Position = callback(1, -9, 0.5, 0)
                C1.Size = x(13, 13)
                C1.Image = 'down'
                C1.ImageTransparency = 0.55

                local z1, B1 = e(C1), ctx.createFrame

                C1, callback = {
                    Parent = g1.sc,
                    LayoutOrder = F1.i,
                }, ctx.udim2
                C1.Size = callback(1, -36, 0, 0)
                C1.AutomaticSize = g
                callback = ctx.listLayout

                _VX.setList(C1, 0, callback(12), o1)

                F1.g = B1(C1)

                m1(F1, F1.g, 1)
                v1(o1, function()
                    F1.crow.Visible = not F1.crow.Visible

                    k1(z1, {
                        Rotation = F1.crow.Visible and 0 or -90,
                    }, 0.25)
                end)

                F1.chip = textButton({
                    Parent = g1.row,
                    LayoutOrder = F1.i,
                    Size = x(0, 24),
                    AutomaticSize = t,
                    Text = d1,
                    FontFace = font6,
                    TextSize = 12,
                    TextColor3 = L.wh,
                    TextTransparency = 0.5,
                    BackgroundTransparency = 1,
                    D1(),
                    H1(0, 12),
                })

                v1(F1.chip, function()
                    N1(g1, F1)
                end)

                F1.Go = function(S)
                    if not t1.open then
                        t1:Show(true)
                    end

                    t1:Select(g1)
                    task.delay(0.15, N1, g1, F1)
                end
                g1.subs[F1.i] = F1
                F1.Section = function(S, S, C1, d1)
                    return R1.new(F1, S, C1, d1)
                end
                F1.Arrange = g1.Arrange

                if F1.i == 1 then
                    b1(g1, F1)
                end

                return F1
            end

            if not t1.Cur then
                t1:Select(g1)
            end

            return g1
        end
        t1.All = {}
        e1, G1, x1 = ctx.createFrame, {Parent = O1}, ctx.topRight
        G1.AnchorPoint = x1
        X1 = ctx.udim2
        G1.Position = X1(1, -44, 0, N - 4)
        G1.Size = x(300, 0)
        G1.AutomaticSize = g
        G1.Visible = false
        G1.ZIndex = 15
        G1.BackgroundTransparency = 0.02
        G1.BackgroundColor3 = L.pn
        y1 = ctx.listLayout

        _VX.setList(G1, 0, D1(12), J1(0.82), H1(6), y1(2))

        local N = e1(G1)

        local function S(C1)
            P.Text = ''

            t1:Select(C1.tab)
            task.delay(0.55, function()
                i1(C1.tab.sc, C1.r, 40)

                C1.r.BackgroundTransparency = 0.8

                k1(C1.r, {BackgroundTransparency = 1}, 1.4)
            end)
        end

        G(P:GetPropertyChangedSignal('Text'), function()
            local C1 = P.Text:lower()

            Q1(N)

            N.Visible = C1 ~= ''

            if C1 == '' then
                return
            end

            local ipairsFn, d1, F1 = ipairs, t1.All, 0

            for m1, g1 in ipairsFn(d1)do
                if F1 < 8 then
                    if g1.n:find(C1, 1, true) then
                        m1 = F1 + 1

                        local P, o1 = {
                            Parent = N,
                            LayoutOrder = m1,
                        }, ctx.udim2

                        P.Size = o1(1, 0, 0, 42)

                        local o1, y1, b1 = D1(9), {
                            Position = x(10, 4),
                        }, ctx.udim2

                        y1.Size = b1(1, -20, 0, 18)
                        y1.Text = g1.title
                        y1.FontFace = font6
                        y1.TextTruncate = atEnd

                        local z1, i1, udim2 = textLabel(y1), {
                            Position = x(10, 22),
                        }, ctx.udim2

                        i1.Size = udim2(1, -20, 0, 15)
                        i1.Text = g1.path
                        i1.TextSize = 11
                        i1.TextTransparency = 0.45
                        i1.TextTruncate = atEnd

                        _VX.setList(P, 0, o1, z1, textLabel(i1))

                        b1 = textButton(P)

                        r1(b1, 0.92)

                        local function P()
                            if I1() then
                                S(g1)
                            end
                        end

                        b1.Activated:Connect(P)

                        F1 = m1
                    end
                end
            end

            if F1 == 0 then
                d1, C1 = {Parent = N}, ctx.udim2
                d1.Size = C1(1, 0, 0, 32)
                d1.Text = 'No results'
                d1.TextTransparency = 0.45
                d1.TextXAlignment = center

                textLabel(d1)
            end
        end)

        t1.Home = function(callback, S)
            local P = S or {}

            callback = t1:Tab(P.Name or 'Home', P.Icon or 'home', true)
            callback.Title = P.Title or 'Dashboard'

            local createFrame, C1, d1 = ctx.createFrame, {
                Parent = callback.sc,
                Position = x(-6, -6),
            }, ctx.udim2

            C1.Size = d1(1, 12, 1, 12)

            local F1 = createFrame(C1)

            local function m1(g1, o1, y1, b1, z1, i1, N1)
                local x1, B1, G1 = ctx.createFrame, {Parent = F1}, ctx.udim2

                B1.Position = G1(g1, 6, o1, 6)
                o1 = ctx.udim2
                B1.Size = o1(y1, -12, b1, -12)
                B1.BackgroundTransparency = z1 or 0.93
                B1.BackgroundColor3 = i1 or L.wh

                _VX.setList(B1, 0, D1(18), J1(N1 or 0.86, i1 and i1:Lerp(L.wh, 0.5)))

                return x1(B1)
            end
            local function g1(o1, y1, b1, z1)
                e({
                    Parent = o1,
                    Position = x(14, 13),
                    Size = x(14, 14),
                    Image = b1,
                    ImageColor3 = z1,
                })

                z1, b1 = {
                    Parent = o1,
                    Position = x(34, 12),
                }, ctx.udim2
                z1.Size = b1(1, -48, 0, 16)
                z1.Text = y1:upper()
                z1.FontFace = font5
                z1.TextSize = 11.5
                z1.TextTransparency = 0.15

                return textLabel(z1)
            end

            createFrame = m1(0, 0, 0.6666666666666666, 0.3, 0.55)
            U1(color3FromRGB(255, 196, 120), color3FromRGB(150, 110, 255)).Parent = createFrame
            callback, d1 = {Parent = createFrame}, ctx.udim2
            callback.Position = d1(0, 16, 0.5, -28)
            callback.Size = x(56, 56)
            callback.Image = K(150)
            callback.BackgroundTransparency = 0
            callback.BackgroundColor3 = L.a2

            _VX.setList(callback, 0, D1(), J1(0.4))
            e(callback)

            C1, callback = {Parent = createFrame}, ctx.udim2
            C1.Position = callback(0, 86, 0.5, -34)
            d1 = ctx.udim2
            C1.Size = d1(1, -100, 0, 14)
            C1.Text = 'Welcome back'
            C1.TextSize = 11
            C1.TextTransparency = 0.25

            textLabel(C1)

            d1, C1 = {Parent = createFrame}, ctx.udim2
            d1.Position = C1(0, 86, 0.5, -19)
            callback = ctx.udim2
            d1.Size = callback(1, -100, 0, 24)
            d1.Text = localPlayer.DisplayName
            d1.FontFace = font6
            d1.TextSize = 21
            d1.TextTruncate = atEnd

            textLabel(d1)

            C1, callback, d1 = ctx.createFrame, {Parent = createFrame}, ctx.udim2
            callback.Position = d1(0, 86, 0.5, 10)
            createFrame = ctx.udim2
            callback.Size = createFrame(1, -100, 0, 20)
            createFrame = ctx.listLayout

            _VX.setList(callback, 0, createFrame(6, nil, nil, horizontal))

            local K, o1, y1 = C1(callback), P.Executor or identifyexecutor and select(2, pcall(identifyexecutor)), ipairs

            callback = {
                {
                    P.Game,
                },
                {
                    type(o1) == 'string' and o1,
                },
                {
                    P.Key,
                    L.mint,
                },
            }

            for b1, z1 in y1(callback)do
                if z1[1] then
                    d1, createFrame = {
                        Parent = K,
                        LayoutOrder = b1,
                    }, ctx.udim2
                    d1.Size = createFrame(0, 0, 1, 0)
                    d1.AutomaticSize = t
                    d1.Text = tostring(z1[1])
                    d1.TextSize = 11
                    d1.TextColor3 = z1[2] and z1[2]:Lerp(L.wh, 0.6)
                    d1.BackgroundTransparency = z1[2] and 0.8 or 0.75
                    d1.BackgroundColor3 = z1[2] or color3FromRGB(0, 0, 0)
                    d1.TextXAlignment = center

                    _VX.setList(d1, 0, D1(), H1(0, 10))
                    textLabel(d1)
                end
            end

            C1 = P.Notice
            createFrame = m1(0.6666666666666666, 0, 0.3333333333333333, 0.3, 0.78, C1 and L.a1 or L.dc, 0.55)

            frame({
                Parent = createFrame,
                Position = x(14, 14),
                Size = x(36, 36),
                BackgroundColor3 = C1 and L.a1 or L.dc,
                D1(11),
                u(C1 and 'sparkles' or 'discord', 22),
            })

            K, y1 = {
                Parent = createFrame,
                Position = x(60, 15),
            }, ctx.udim2
            K.Size = y1(1, -72, 0, 17)
            K.Text = C1 and C1[1] or P.Community or 'Community'
            K.FontFace = font6
            K.TextSize = 14
            K.TextTruncate = atEnd

            textLabel(K)

            if C1 then
                callback, K = {
                    Parent = createFrame,
                    Position = x(14, 58),
                }, ctx.udim2
                callback.Size = K(1, -28, 1, -70)
                callback.Text = C1[2]
                callback.TextSize = 11
                callback.TextTransparency = 0.22
                callback.TextWrapped = true
                d1 = ctx.Enum
                callback.TextYAlignment = d1.TextYAlignment.Top

                textLabel(callback)
            else
                y1, o1 = {
                    Parent = createFrame,
                    Position = x(60, 33),
                }, ctx.udim2
                y1.Size = o1(1, -72, 0, 14)
                y1.Text = 'Updates, keys, support'
                y1.TextSize = 11
                y1.TextTransparency = 0.22

                textLabel(y1)

                local b1, z1 = {
                    Parent = createFrame,
                    AnchorPoint = vector2New(0, 1),
                }, ctx.udim2

                b1.Position = z1(0, 14, 1, -12)
                z1 = ctx.udim2
                b1.Size = z1(1, -28, 0, 32)
                b1.BackgroundTransparency = 0
                b1.BackgroundColor3 = L.dc
                b1.Text = 'Copy invite'
                b1.FontFace = font6
                b1.TextSize = 12
                b1.TextColor3 = L.wh

                _VX.setList(b1, 0, D1(10))

                z1 = textButton(b1)

                n1(z1)
                v1(z1, function()
                    Y1(P.Discord, 'Invite copied')
                end)
            end

            local b1 = getService('TeleportService')

            callback, K = P.Actions

            if callback then
                K = callback
            else
                d1, y1, C1, createFrame, o1 = {}, {
                    'Rejoin',
                    'refresh',
                    function()
                        c1('Rejoin this server?', 'You leave and join this same server again.', 'warn', 'Rejoin', function(
                        )
                            local H = ctx.game

                            b1:TeleportToPlaceInstance(H.PlaceId, ctx.game.JobId, localPlayer)
                        end)
                    end,
                }, {
                    'Server hop',
                    'server',
                    function()
                        c1('Hop to another server?', 'You leave this server and join a different one.', 'warn', 'Hop', function(
                        )
                            if P.Hop then
                                P.Hop()
                            else
                                local H = ctx.game

                                b1:Teleport(H.PlaceId, localPlayer)
                            end
                        end)
                    end,
                }, {
                    'Copy Job ID',
                    'copy',
                    function()
                        local H = ctx.game

                        Y1(H.JobId, 'Job ID copied')
                    end,
                }, P.Unload

                local H, b1 = o1 and {
                    'Unload hub',
                    'trash',
                    P.Unload,
                } or {
                    'Save config',
                    'save',
                    s1,
                }, P.Switch or P.Discord and {
                    'Discord',
                    'discord',
                    function()
                        Y1(P.Discord, 'Discord invite copied')
                    end,
                }

                _VX.setList(d1, 0, y1, C1, createFrame, H, b1 or {
                    'Hide UI',
                    'eye',
                    function()
                        t1:Show(false)
                    end,
                })

                K = d1
            end

            o1, callback, createFrame = ctx.createFrame, {Parent = F1}, ctx.udim2
            callback.Position = createFrame(0, 6, 0.3, 6)
            d1 = ctx.udim2
            callback.Size = d1(1, -12, 0.16, -12)
            d1 = ctx.listLayout

            _VX.setList(callback, 0, d1(12, nil, nil, horizontal))

            d1, y1 = o1(callback), ipairs

            for H, F1 in y1(K)do
                callback, createFrame, C1, o1 = F[(H - 1) % 5 + 1], ctx.createFrame, {
                    Parent = d1,
                    LayoutOrder = H,
                }, ctx.udim2
                C1.Size = o1(1 / #K, 12 / #K - 12, 1, 0)

                local H, K, o1, y1, b1, z1 = {
                    Parent = createFrame(C1),
                    AnchorPoint = T,
                    Position = Z,
                    Size = _,
                    BackgroundTransparency = 0.94,
                }, D1(14), J1(0.88), ctx.createFrame, {}, ctx.udim2

                b1.Position = z1(0, 10, 0.5, -15)
                b1.Size = x(30, 30)
                b1.BackgroundTransparency = 0.82
                b1.BackgroundColor3 = callback

                _VX.setList(b1, 0, D1(9), u(F1[2], 16, callback))

                local N, i1, udim2 = y1(b1), {
                    Position = x(48, 0),
                }, ctx.udim2

                i1.Size = udim2(1, -54, 1, 0)
                i1.Text = F1[1]
                i1.TextSize = 12
                i1.TextWrapped = true

                _VX.setList(H, 0, K, o1, N, textLabel(i1))

                z1 = textButton(H)

                n1(z1, 0.95)
                v1(z1, function()
                    w1(F1[3])
                end)
            end

            local H = m1(0, 0.46, 0.6666666666666666, 0.54)
            local N = g1(H, 'Session', 'clock', L.gold)

            createFrame = m1(0.6666666666666666, 0.46, 0.3333333333333333, 0.54)

            g1(createFrame, "What's new", 'sparkles', L.pink)

            d1, C1 = {
                Parent = createFrame,
                Position = x(14, 40),
            }, ctx.udim2
            d1.Size = C1(1, -24, 1, -50)
            m1 = ctx.listLayout

            _VX.setList(d1, 0, H1(1, 4, 4, 1), m1(10))

            local S, K = scrollingFrame(d1), {}

            local function C1(d1)
                local F1, m1 = math.max(os.time() - d1, 0), {
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

                for g1, g1 in ipairs(m1)do
                    d1 = F1 // g1[1]

                    if d1 >= 1 then
                        return ('%d %s%s ago'):format(d1, g1[2], d1 > 1 and 's' or '')
                    end
                end

                return 'just now'
            end

            K.News = function(d1, F1)
                K.list = F1

                Q1(S)

                d1 = ipairs

                for Q1, m1 in d1(F1)do
                    local d1, F1, g1 = ctx.createFrame, {
                        Position = x(44, 0),
                    }, ctx.udim2

                    F1.Size = g1(1, -44, 0, 0)
                    F1.AutomaticSize = g
                    g1 = ctx.listLayout

                    _VX.setList(F1, 0, g1(2), textLabel({
                        Size = f,
                        AutomaticSize = g,
                        Text = m1[2],
                        TextSize = 12,
                        TextWrapped = true,
                    }))

                    g1 = d1(F1)

                    if m1[3] or m1[4] then
                        local o1, y1, b1 = ctx.createFrame, {
                            Parent = g1,
                            LayoutOrder = 1,
                        }, ctx.udim2

                        y1.Size = b1(1, 0, 0, 14)
                        d1 = ctx.listLayout

                        _VX.setList(y1, 0, d1(5, nil, center2, horizontal))

                        b1 = o1(y1)

                        if m1[3] then
                            o1, y1 = {Parent = b1}, ctx.udim2
                            o1.Size = y1(0, 0, 1, 0)
                            o1.AutomaticSize = t
                            o1.Text = m1[3]
                            o1.FontFace = font4
                            o1.TextSize = 10
                            o1.TextTransparency = 0.4

                            textLabel(o1)
                        end
                        if m1[4] then
                            local o1, z1, i1 = ctx.createFrame, {
                                Parent = b1,
                                LayoutOrder = 1,
                            }, ctx.udim2

                            z1.Size = i1(0, 0, 1, 0)
                            z1.AutomaticSize = t
                            z1.BackgroundTransparency = 0.9
                            i1 = ctx.listLayout

                            _VX.setList(z1, 0, D1(), H1(0, 6), i1(3, nil, center2, horizontal))

                            F1 = o1(z1)

                            e({
                                Parent = F1,
                                Size = x(10, 10),
                                Image = 'clock',
                                ImageTransparency = 0.3,
                            })

                            o1, y1 = {
                                Parent = F1,
                                LayoutOrder = 1,
                            }, ctx.udim2
                            o1.Size = y1(0, 0, 1, 0)
                            o1.AutomaticSize = t
                            o1.Text = C1(m1[4])
                            o1.FontFace = font4
                            o1.TextSize = 10
                            o1.TextTransparency = 0.3

                            textLabel(o1)
                        end
                    end

                    d1 = ctx.createFrame

                    d1({
                        Parent = S,
                        LayoutOrder = Q1,
                        Size = f,
                        AutomaticSize = g,
                        g1,
                        textLabel({
                            Size = x(0, 18),
                            AutomaticSize = t,
                            Text = m1[1],
                            FontFace = font4,
                            TextSize = 9,
                            TextColor3 = color3FromRGB(16, 20, 42),
                            BackgroundTransparency = 0,
                            BackgroundColor3 = ({
                                NEW = L.mint,
                                FIX = L.sky,
                                IMP = L.gold,
                                UPD = L.red,
                            })[m1[1] ] or L.vio,
                            TextXAlignment = center,
                            D1(5),
                            H1(0, 6),
                        }),
                    })
                end
            end
            K.Stats = function(callback, C1, d1)
                N.Text = C1:upper()

                local createFrame, F1, Q1 = ctx.createFrame, {
                    Parent = H,
                    Position = x(12, 38),
                }, ctx.udim2

                F1.Size = Q1(1, -24, 1, -48)
                callback, Q1, C1 = ctx.newInstance, {}, ctx.udim2
                Q1.CellSize = C1(0.3333333333333333, -7, 0.333, -6)
                Q1.CellPadding = x(10, 8)
                C1 = ctx.Enum
                Q1.SortOrder = C1.SortOrder.LayoutOrder

                _VX.setList(F1, 0, callback('UIGridLayout', Q1))

                callback, C1, Q1 = createFrame(F1), {}, ipairs

                for H, m1 in Q1(d1)do
                    F1 = ctx.createFrame
                    createFrame = F1({
                        Parent = callback,
                        LayoutOrder = H,
                        BackgroundTransparency = 0.94,
                        D1(12),
                    })

                    if m1[2] then
                        local S, d1 = {
                            Parent = createFrame,
                            AnchorPoint = vector2New(0, 0.5),
                        }, ctx.udim2

                        S.Position = d1(0, 8, 0.5, 0)
                        S.Size = x(30, 30)
                        S.Image = m1[2]
                        d1 = ctx.Enum
                        S.ScaleType = d1.ScaleType.Fit
                        S.ImageColor3 = B[m1[2] ] and L.a1 or nil

                        e(S)
                    end

                    local S, d1, F1 = m1[2] and 44 or 10, {Parent = createFrame}, ctx.udim2

                    d1.Position = F1(0, S, 0.5, -17)
                    F1 = ctx.udim2
                    d1.Size = F1(1, -S - 6, 0, 13)
                    d1.Text = m1[1]:upper()
                    d1.FontFace = font5
                    d1.TextSize = 9.5
                    d1.TextTransparency = 0.38

                    textLabel(d1)

                    d1, H, F1 = m1[1], {Parent = createFrame}, ctx.udim2
                    H.Position = F1(0, S, 0.5, -2)
                    F1 = ctx.udim2
                    H.Size = F1(1, -S - 6, 0, 18)
                    H.Text = '--'
                    H.FontFace = font4
                    H.TextSize = 13.5
                    H.TextTruncate = atEnd
                    C1[d1] = textLabel(H)

                    if m1[3] then
                        H, S = {
                            Parent = createFrame,
                            AnchorPoint = vector2New(1, 0),
                        }, ctx.udim2
                        H.Position = S(1, -8, 0, 8)
                        H.Size = x(40, 16)
                        H.Text = 'OPEN'
                        H.FontFace = font5
                        H.TextSize = 9
                        H.TextColor3 = L.wh
                        H.BackgroundTransparency = 0.82
                        H.BackgroundColor3 = L.wh

                        _VX.setList(H, 0, D1(), J1(0.7))

                        F1 = textButton(H)

                        n1(F1, 0.92)
                        v1(F1, function()
                            w1(m1[3])
                        end)
                    end
                end

                return _1(C1)
            end

            if P.News then
                K:News(P.News)
            end

            return K
        end

        local function H(options, S, P)
            return type(options) == 'table' and options or t1:Tab(options or S, P)
        end

        t1.Settings = function(target, callback)
            target = H(callback, 'Settings', 'settings')
            callback = target:Section('Interface', 'sliders')

            callback:Slider('UI scale', 60, 140, 100, function(P)
                t1:SetScale(P / 100)
            end, '%', 5)

            local function P(K)
                t1.Key = K
            end

            callback:Key('Show / hide UI', t1.Key, nil, P)
            callback:Slider('Opacity', 50, 100, 95, function(K)
                t1.bg.BackgroundTransparency = 1 - K / 100
            end, '%')
            callback:Slider('Tone', -100, 100, 70, function(K)
                t1:Tone(K)
            end, '', 5)
            callback:Slider('Dim the game', 0, 80, 60, function(K)
                t1.dz = K / 100

                if t1.open then
                    t1.dim.BackgroundTransparency = 1 - t1.dz
                end
            end, '%', 5)

            P, callback = target:Section('Theme', 'palette'), ctx.createFrame

            local K, C1, d1, F1, Q1 = {
                Parent = P.f,
                LayoutOrder = 2,
                Name = 'VenyxThemes',
                Size = f,
                AutomaticSize = g,
            }, H1(2, 14, 14), ctx.newInstance, {}, ctx.udim2

            F1.CellSize = Q1(0.25, -8, 0, 62)
            F1.CellPadding = x(10, 10)
            Q1 = ctx.Enum
            F1.SortOrder = Q1.SortOrder.LayoutOrder

            _VX.setList(K, 0, C1, d1('UIGridLayout', F1))

            F1 = callback(K)
            P.n = P.n + 1
            P, callback = {}, ipairs

            for m1, g1 in callback(l)do
                local S, o1, y1, b1, z1, i1 = J1(0.86), {
                    Parent = F1,
                    LayoutOrder = m1,
                    BackgroundTransparency = 0.95,
                }, D1(12), ctx.createFrame, {
                    Position = x(6, 6),
                }, ctx.udim2

                z1.Size = i1(1, -12, 0, 30)
                z1.BackgroundTransparency = 0
                K, d1, Q1, i1, m1 = D1(8), U1(g1[2], g1[4], 20), ctx.createFrame, {
                    AnchorPoint = vector2New(0, 1),
                }, ctx.udim2
                i1.Position = m1(0, 6, 1, -5)
                C1 = ctx.udim2
                i1.Size = C1(0.45, 0, 0, 6)
                i1.BackgroundTransparency = 0
                i1.BackgroundColor3 = g1[5]

                _VX.setList(i1, 0, D1())
                _VX.setList(z1, 0, K, d1, Q1(i1))

                local K, C1, d1 = b1(z1), {
                    Position = x(8, 40),
                }, ctx.udim2

                C1.Size = d1(1, -26, 0, 16)
                C1.Text = g1[1]
                C1.FontFace = font6
                C1.TextSize = 11
                C1.TextTruncate = atEnd

                _VX.setList(o1, 0, y1, S, K, textLabel(C1))

                C1, d1, K = textButton(o1), g1[1], {}
                b1, m1 = {
                    Parent = C1,
                    AnchorPoint = R,
                }, ctx.udim2
                b1.Position = m1(1, -8, 0, 48)
                b1.Size = x(12, 12)
                b1.Image = 'check'
                b1.ImageColor3 = g1[5]
                b1.ImageTransparency = 1

                _VX.setList(K, 0, S, e(b1))

                P[d1] = K

                n1(C1, 0.95)
                v1(C1, function()
                    local venyx = ctx.Venyx

                    venyx:Theme(g1[1])
                end)
            end

            t1.marks = P
            Q1 = target:Section('Defaults', 'refresh')

            Q1:Button('Reset to defaults', 'Reset', function()
                c1('Reset every option?', 
[[All options go back to their built-in values and your active config is saved that way.]], 'warn', 'Reset', function(
                )
                    local venyx = ctx.Venyx

                    venyx:Reset()

                    venyx = ctx.Venyx

                    venyx:Notify('Reset', 'Every option is back to its default', 'ok')
                end)
            end, 'danger')
            Q1:Button('Turn off all toggles', 'Turn off', function()
                local venyx, venyx2 = ctx.Venyx, ctx.Venyx

                venyx:Notify('Toggles off', venyx2:Off() .. ' switched off', 'ok')
            end)

            return target
        end
        t1.Config = function(target, S)
            target = H(S, 'Config', 'save')
            S = target:Section('Config', 'folder')

            local H = S:Stats({
                'Active',
                'Saved configs',
            })
            local P

            local function K()
                local C1 = ctx.State

                H:Set('Active', C1.Active)
                H:Set('Saved configs', tostring(#ctx.Venyx:Configs()))

                if P then
                    P:Set(ctx.State.Active, true)
                end
            end
            local function H(C1, d1, F1, Q1)
                local m1 = C1:Dropdown(d1, function()
                    local C1 = ctx.Venyx

                    return C1:Configs()
                end, nil, function(C1)
                    if C1 then
                        if F1 then
                            F1(C1)
                        end
                    end
                end, Q1)

                m1.Skip = true

                return m1
            end

            P = H(S, 'Config', function(C1)
                local d1 = ctx.State

                if C1 ~= d1.Active then
                    local d1 = ctx.Venyx

                    d1:Notify('Config picked', C1 .. ' - press Set active to load it', 'info')
                end
            end)

            S:Button('Set as active config', 'Set active', function()
                local C1 = P.Value

                if not C1 then
                    local venyx = ctx.Venyx

                    return venyx:Notify('Nothing picked', 'Choose a config first', 'warn')
                end

                local venyx = ctx.Venyx

                if venyx:Load(C1) then
                    K()

                    local venyx = ctx.Venyx

                    venyx:Notify('Active config', C1, 'ok')
                end
            end, 'gold')
            S:Button('Save changes', 'Save', s1)

            local state = ctx.State

            S:Toggle('Auto load', state.AutoLoad, function(C1)
                local d1 = ctx.State

                if d1.AutoLoad ~= C1 then
                    local F1, Q1, m1 = ctx.Venyx, 'Auto load ' .. (C1 and 'on' or 'off')

                    if C1 then
                        local g1 = ctx.State

                        m1 = g1.Active .. ' loads every time Venyx starts'
                    else
                        m1 = C1
                    end

                    F1:Notify(Q1, m1 or 'Venyx starts with its default options', 'info')
                end

                d1 = ctx.State
                d1.AutoLoad = C1
                C1 = ctx.Venyx

                C1:Persist()
            end).Skip = true
            state = ctx.State
            S:Toggle('Auto save', state.AutoSave, function(S)
                local C1 = ctx.State

                if C1.AutoSave == S then
                    return
                end

                C1 = ctx.State
                C1.AutoSave = S
                C1 = ctx.Venyx

                C1:Persist()

                if S then
                    C1 = ctx.Venyx

                    C1:Save()
                end

                local d1, F1, Q1 = ctx.Venyx, 'Auto save ' .. (S and 'on' or 'off')

                if S then
                    C1 = ctx.State
                    Q1 = 'Every change is saved to ' .. C1.Active
                else
                    Q1 = S
                end

                d1:Notify(F1, Q1 or 'Press Save changes to keep your options', 'info')
            end).Skip = true
            state = target:Section('Profiles', 'copy')

            local S = state:Input('New config name', 'Auto if empty')

            S.Skip = true

            state:Button('Create config', 'Create', function()
                local C1 = ctx.Venyx
                local d1, F1 = C1:Name(S.Value)

                if not d1 then
                    C1 = ctx.Venyx

                    return C1:Notify('Config not created', F1, 'err')
                end

                F1 = ctx.Venyx

                F1:Save(d1)

                F1 = ctx.State
                F1.Active = d1
                C1 = ctx.Venyx

                C1:Persist()
                S:Set('', true)
                K()

                F1 = ctx.Venyx

                F1:Notify('Config created', d1 .. ' is now the active config', 'ok')
            end, 'gold')

            local S = H(state, 'Pick to delete', nil, true)

            state:Button('Delete picked', 'Delete', function()
                local C1, d1 = {}, false

                for F1, F1 in ipairs(S.Value)do
                    if F1:lower() == 'default' then
                        d1 = true
                    else
                        C1[#C1 + 1] = F1
                    end
                end

                if #C1 == 0 then
                    local F1 = ctx.Venyx

                    return F1:Notify('Nothing to delete', 'Pick configs other than Default', 'warn')
                end

                c1('Delete ' .. #C1 .. ' config(s)?', table.concat(C1, ', ') .. (d1 and '\nDefault is kept.' or ''), 'err', 'Delete', function(
                )
                    local d1 = ipairs

                    for F1, Q1 in d1(C1)do
                        F1 = ctx.Venyx

                        F1:Delete(Q1)
                    end

                    S:Set({}, true)
                    K()

                    d1 = ctx.Venyx

                    d1:Notify(#C1 .. ' config(s) deleted', table.concat(C1, ', '), 'ok')
                end)
            end, 'danger')

            local S

            S = state:Dropdown('Restore deleted', function()
                local C1 = ctx.Venyx

                return C1:Trash()
            end, nil, function(C1)
                if not C1 then
                    return
                end

                local d1 = ctx.Venyx
                local F1 = d1:Restore(C1)

                S:Set(nil, true)
                K()

                d1 = ctx.Venyx

                d1:Notify(F1 and 'Config restored' or 'Restore failed', F1 or C1, F1 and 'ok' or 'err')
            end)
            S.Skip = true

            H(state, 'Export config', function(H)
                local venyx, S, C1 = ctx.Venyx, pcall(setclipboard, ctx.Venyx:Export(H)), ctx.Venyx

                C1:Notify(S and 'Config copied' or 'Copy failed', S and H .. ' is on your clipboard' or 'This executor cannot copy text', S and 'ok' or 'err')
                t1:Dialog({
                    Title = S and 'Config copied' or 'Copy failed',
                    Kind = S and 'ok' or 'err',
                    Text = S and H .. 
[[ is on your clipboard. Paste it to share it, then load it with Import config.]] or 'This executor cannot copy text.',
                })
            end)

            local H = state:Input('Import text', 'Paste config text')

            H.Skip = true

            state:Button('Import config', 'Import', function()
                local venyx = ctx.Venyx
                local P, C1 = venyx:Import(H.Value)

                if not P then
                    venyx = ctx.Venyx

                    return venyx:Notify('Import failed', C1, 'err')
                end

                H:Set('', true)
                c1('Config imported', P .. ' was added to your configs. Apply it now?', 'ok', 'Apply now', function(
                )
                    local venyx = ctx.Venyx

                    venyx:Load(P)
                    K()

                    venyx = ctx.Venyx

                    venyx:Notify('Config loaded', P, 'ok')
                end, 'Later')

                C1 = ctx.Venyx

                C1:Notify('Config imported', P .. ' was added to your configs', 'ok')
            end, 'gold')
            K()

            return target
        end
        t1.Quick = function(target, N, S)
            local P, K, C1, d1, F1, Q1, m1, g1 = {
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
            local o1, y1 = 0

            local function b1(z1)
                local i1 = y1.tr

                y1.o:Set(y1.o.From(math.clamp((z1.Position.X - i1.AbsolutePosition.X) / i1.AbsoluteSize.X, 0, 1)), false, true)
            end
            local function z1(i1)
                local venyx = ctx.Venyx

                return venyx.Keys[i1].Name
            end
            local function i1(target)
                local x1, B1, G1 = {}, -#z1(target) - 2, ''

                for E1 in target:sub(1, B1):gmatch('[^/]+')do
                    E1 = E1:match('^%s*(.-)%s*$')

                    if E1:lower() ~= G1 then
                        G1, x1[#x1 + 1] = E1:lower(), E1
                    end
                end

                return table.concat(x1, '  /  ')
            end
            local function N1(x1)
                local B1 = P.keys[x1]

                return B1 and (Q[B1] or B1)
            end
            -- Registers InputBegan, InputEnded, Activated signal callback(s)
            local function x1(B1, G1, E1)
                local uIScale

                if G1 then
                    local newInstance = ctx.newInstance

                    uIScale = newInstance('UIScale', {Parent = B1})
                else
                    uIScale = G1
                end

                local backgroundTransparency = B1.BackgroundTransparency

                local function j1(e1)
                    if V1(e1) then
                        k1(uIScale or B1, uIScale and {Scale = G1} or {
                            BackgroundTransparency = backgroundTransparency - 0.06,
                        }, 0.12)
                    end
                end

                B1.InputBegan:Connect(j1)

                local function G1(j1)
                    if V1(j1) then
                        k1(uIScale or B1, uIScale and {Scale = 1} or {BackgroundTransparency = backgroundTransparency}, 0.35)
                    end
                end

                B1.InputEnded:Connect(G1)

                local function G1()
                    if I1() then
                        E1()
                    end
                end

                B1.Activated:Connect(G1)
            end
            local function B1(G1, E1, u1)
                local descendants = G1:GetDescendants()

                descendants[#descendants + 1] = G1

                local j1 = ipairs

                for e1, s1 in j1(descendants)do
                    e1 = {}

                    if s1:IsA('GuiObject') then
                        e1.BackgroundTransparency = s1.BackgroundTransparency
                    end
                    if s1:IsA('TextLabel') then
                        e1.TextTransparency = s1.TextTransparency
                    elseif s1:IsA('TextButton') then
                        e1.TextTransparency = s1.TextTransparency
                    elseif s1:IsA('TextBox') then
                        e1.TextTransparency = s1.TextTransparency
                    end
                    if s1:IsA('ImageLabel') then
                        e1.ImageTransparency = s1.ImageTransparency
                    end
                    if s1:IsA('UIStroke') then
                        e1.Transparency = s1.Transparency
                    end

                    local P1 = {}

                    for j1 in next, e1 do
                        P1[j1] = 1
                    end

                    if E1 then
                        for j1 in next, e1 do
                            s1[j1] = 1
                        end

                        k1(s1, e1, 0.3, nil, nil, u1)
                    else
                        local j1 = ctx.Enum

                        k1(s1, P1, 0.26, quint, j1.EasingDirection.In, u1)
                    end
                end

                if not E1 then
                    G1.Active = false

                    k1(G1, {
                        Position = G1.Position + x(0, 26),
                    }, 0.3, quint, ctx.Enum.EasingDirection.In, u1)
                    task.delay(0.32 + u1, G1.Destroy, G1)
                end
            end
            local function G1()
                for E1, value in ipairs(t1.All)do
                    local P1 = value.k:sub(1, -#value.title - 2)

                    Q1[P1], Q1[value.k] = Q1[P1] or E1, Q1[value.k] or E1
                end

                local E1, venyx = {}, ctx.Venyx

                for key, j1 in next, venyx.Keys do
                    if j1.Kind then
                        E1[#E1 + 1] = key
                    end
                end

                table.sort(E1, function(target, key)
                    local j1, e1 = (Q1[target:sub(1, -#z1(target) - 2)] or 1000000000) * 10000 + (Q1[target] or 0), (Q1[key:sub(1, 
-#z1(key) - 2)] or 1000000000) * 10000 + (Q1[key] or 0)

                    if j1 == e1 then
                        return target < key
                    end

                    return j1 < e1
                end)

                return E1
            end
            local function Q1()
                local E1 = ctx.HttpService

                C1:Set(E1:JSONEncode(P), true)
            end
            local function E1()
                P = {
                    pins = {},
                    keys = {},
                    at = {},
                    fold = {},
                }

                local ipairsFn, packedValues = ipairs, table.pack(G1())

                for j1, j1 in ipairsFn(_VX.unpack(packedValues))do
                    local ipairsFn, P1 = ipairs, S or {}

                    for S, S in ipairsFn(P1)do
                        if j1:sub(-#S) == S then
                            P.pins[j1] = 1
                        end
                    end
                end
            end
            -- Registers InputBegan signal callback(s)
            local function setFramesAlpha()
                for index, value in ipairs(F1)do
                    index = table.find(value[1].ls, value[2])

                    if index then
                        table.remove(value[1].ls, index)
                    end
                end

                table.clear(F1)

                for index, value in ipairs(d1)do
                    B1(value.f, false, (index - 1) * 0.05)
                end

                table.clear(d1)

                if g1 then
                    g1()
                end
                if not K.show then
                    return
                end

                local viewportSize, P1, j1 = workspace.CurrentCamera.ViewportSize, G1(), 220
                local e1, s1 = math.clamp(viewportSize.Y / 720, 0.75, 1.2) * K.size, 0

                for Y1 = 1, 5, 1 do
                    local X1, Dq = {}, tostring(Y1)

                    for Jq, Jq in ipairs(P1)do
                        if P.pins[Jq] == Y1 then
                            X1[#X1 + 1] = Jq
                        end
                    end

                    if #X1 > 0 then
                        s1 += 1

                        local newInstance = ctx.newInstance
                        local Jq, Uq = newInstance('UIScale', {Scale = e1}), ctx.listLayout
                        local aq, Hq = Uq(5), ctx.createFrame
                        local kq, rq, Cq = Hq({
                            LayoutOrder = 1,
                            Size = f,
                            AutomaticSize = g,
                            ClipsDescendants = true,
                            H1(0, 7, 7),
                            aq,
                        }), {AnchorPoint = T}, ctx.udim2

                        rq.Position = Cq(1, -17, 0.5, 0)
                        rq.Size = x(12, 12)
                        rq.Image = 'down'
                        rq.ImageTransparency = 0.4
                        rq.Rotation = P.fold[Dq] and -90 or 0

                        local wq, Vq, Wq = e(rq), {}, ctx.udim2

                        Vq.Size = Wq(1, 0, 0, 34)
                        newInstance, Cq, rq = e({
                            Position = x(12, 10),
                            Size = x(14, 14),
                            Image = 'zap',
                            ImageColor3 = F[Y1],
                        }), {
                            Position = x(33, 0),
                        }, ctx.udim2
                        Cq.Size = rq(1, -90, 1, 0)
                        Cq.Text = 'QUICK BAR ' .. Y1
                        Cq.FontFace = font5
                        Cq.TextSize = 11
                        Hq, Uq, Wq = textLabel(Cq), {AnchorPoint = R}, ctx.udim2
                        Uq.Position = Wq(1, -32, 0.5, 0)
                        Uq.Size = x(0, 16)
                        Uq.AutomaticSize = t
                        Uq.Text = #X1
                        Uq.FontFace = font6
                        Uq.TextSize = 9.5
                        Uq.TextXAlignment = center
                        Uq.BackgroundTransparency = 0.88

                        _VX.setList(Uq, 0, D1(), H1(0, 6))
                        _VX.setList(Vq, 0, wq, newInstance, Hq, textLabel(Uq))

                        Cq, Uq, rq, Hq = textButton(Vq), ctx.createFrame, {
                            Parent = t1.Gui,
                            AnchorPoint = vector2New(0.5, 0),
                            Size = x(j1, 0),
                            AutomaticSize = g,
                            BackgroundTransparency = 0.06,
                            Active = true,
                            ZIndex = 2,
                        }, ctx.listLayout

                        _VX.setList(rq, 0, D1(16), U1(L.w1, L.w2, 90), J1(0.74), Jq, Hq(), Cq, kq)

                        local Y1 = Uq(rq)
                        local Iq, vq = {
                            f = Y1,
                            u = Jq,
                            id = Dq,
                        }, s1

                        Iq.place = function(hq, nq)
                            local Mq = P.at[Dq]

                            Mq = Mq and vector2New(Mq[1], Mq[2]) or vector2New(hq.X - 18 - j1 * nq / 2 - (vq - 1) * (j1 * nq + 12), math.max(hq.Y * 0.023, 8))
                            Iq.sp.t = vector2New(math.clamp(Mq.X, 40, hq.X - 40), math.clamp(Mq.Y, 0, hq.Y - 40))
                            Jq.Scale = nq
                        end
                        Iq.sp = M1(vector2New(), function(M1)
                            local Jq = ctx.udim2

                            Y1.Position = Jq(0, M1.X, 0, M1.Y)
                        end)

                        Iq.place(viewportSize, e1)

                        Iq.sp.p = Iq.sp.t + vector2New(0, 14)
                        d1[#d1 + 1] = Iq

                        if P.fold[Dq] then
                            Hq = ctx.Enum
                            kq.AutomaticSize = Hq.AutomaticSize.None
                            kq.Size = f
                        end

                        Cq.InputBegan:Connect(function(M1)
                            if V1(M1) then
                                m1 = m1 or {
                                    b = Iq,
                                    i = M1,
                                    s = vector2New(M1.Position.X, M1.Position.Y),
                                    p = Iq.sp.t,
                                }
                            end
                        end)
                        x1(Cq, nil, function()
                            local M1, u1 = P.fold, P.fold[Dq]

                            M1[Dq] = if u1 then nil else not u1

                            local M1, u1, e1, Jq = P.fold[Dq], aq.AbsoluteContentSize.Y / math.max(Y1.AbsoluteSize.X / j1, 0.01) + 7, ctx.Enum

                            Jq, kq.AutomaticSize, kq.Size = ctx.udim2, e1.AutomaticSize.None, ctx.udim2(1, 0, 0, M1 and u1 or 0)

                            k1(wq, {
                                Rotation = M1 and -90 or 0,
                            }, 0.3)

                            Jq, e1 = {}, ctx.udim2
                            Jq.Size = e1(1, 0, 0, M1 and 0 or u1)

                            k1(kq, Jq, 0.32).Completed:Connect(function()
                                if not (P.fold[Dq]) then
                                    kq.AutomaticSize = g
                                end
                            end)
                            Q1()
                        end)

                        rq = ipairs

                        for M1, u1 in rq(X1)do
                            Vq = ctx.Venyx

                            local j1 = Vq.Keys[u1]

                            Hq = N1(u1)

                            local e1

                            Uq, Cq, Wq = j1.Kind, {
                                Parent = kq,
                                LayoutOrder = M1,
                            }, ctx.udim2
                            Cq.Size = Wq(1, 0, 0, Uq == 'slider' and 46 or 34)
                            Cq.BackgroundTransparency = 0.93

                            _VX.setList(Cq, 0, D1(11))

                            newInstance, M1 = textButton(Cq), ctx.createFrame

                            local X1, Dq, Jq, aq = M1({
                                Parent = newInstance,
                                Size = _,
                                D1(11),
                                U1(L.a1, L.a2),
                            }), ctx.createFrame, {Parent = newInstance}, ctx.topRight

                            Jq.AnchorPoint = aq
                            M1 = ctx.udim2
                            Jq.Position = M1(1, -9, 0, 6)
                            Jq.Size = x(160, 22)
                            Jq.ZIndex = 2
                            aq, M1 = ctx.listLayout, ctx.Enum

                            _VX.setList(Jq, 0, aq(6, M1.HorizontalAlignment.Right, center2, horizontal))

                            local M1, kq, rq = Dq(Jq), {
                                Parent = newInstance,
                                Position = x(11, 6),
                            }, ctx.udim2

                            kq.Size = rq(1, -(Uq == 'button' and 96 or Uq == 'input' and 132 or 60) - (Hq and 44 or 0), 0, 22)
                            kq.Text = z1(u1)
                            kq.FontFace = font6
                            kq.TextSize = 12.5
                            kq.TextTruncate = atEnd
                            kq.ZIndex = 2

                            textLabel(kq)

                            if Hq then
                                textLabel({
                                    Parent = M1,
                                    Size = x(0, 18),
                                    AutomaticSize = t,
                                    Text = Hq,
                                    FontFace = font4,
                                    TextSize = 10,
                                    TextXAlignment = center,
                                    BackgroundTransparency = 0.86,
                                    D1(6),
                                    H1(0, 6),
                                })
                            end
                            if Uq == 'toggle' then
                                aq = ctx.createFrame

                                local u1 = E(aq({
                                    Parent = M1,
                                    LayoutOrder = 1,
                                    Size = x(38, 20),
                                }), 38, 20)

                                e1 = function(Jq, aq)
                                    u1(Jq, aq)

                                    if aq then
                                        X1.BackgroundTransparency = Jq and 0.78 or 1
                                    else
                                        k1(X1, {
                                            BackgroundTransparency = Jq and 0.78 or 1,
                                        }, 0.25)
                                    end
                                end

                                x1(newInstance, nil, function()
                                    local venyx = ctx.Venyx

                                    venyx.qb = true

                                    j1:Set(not j1.Value)

                                    venyx = ctx.Venyx
                                    venyx.qb = nil
                                end)
                            else
                                if Uq == 'button' then
                                    local u1 = textLabel({
                                        Parent = M1,
                                        LayoutOrder = 1,
                                        Size = x(0, 22),
                                        AutomaticSize = t,
                                        Text = j1.Text,
                                        FontFace = font6,
                                        TextSize = 11,
                                        TextColor3 = j1.Col:Lerp(L.wh, 0.55),
                                        BackgroundTransparency = 0.85,
                                        BackgroundColor3 = j1.Col,
                                        D1(8),
                                        H1(0, 10),
                                        J1(0.5, j1.Col),
                                    })

                                    x1(newInstance, nil, function()
                                        j1.Fire()

                                        u1.BackgroundTransparency = 0.5

                                        k1(u1, {BackgroundTransparency = 0.85}, 0.5)
                                    end)
                                else
                                    if Uq == 'input' then
                                        local u1 = textBox({
                                            Parent = M1,
                                            LayoutOrder = 1,
                                            Size = x(116, 24),
                                            BackgroundTransparency = 0.7,
                                            BackgroundColor3 = color3FromRGB(0, 0, 0),
                                            PlaceholderText = 'Type here',
                                            TextSize = 11.5,
                                            TextTruncate = atEnd,
                                            ClipsDescendants = true,
                                            D1(7),
                                            H1(0, 7),
                                            J1(0.8),
                                        })

                                        local function X1()
                                            j1:Set(u1.Text)
                                        end

                                        u1.FocusLost:Connect(X1)

                                        e1 = function(X1)
                                            if not (u1:IsFocused()) then
                                                u1.Text = tostring(X1 or '')
                                            end
                                        end
                                    else
                                        local u1, X1, Jq, Uq = textLabel({
                                            Parent = M1,
                                            LayoutOrder = 1,
                                            Size = x(0, 22),
                                            AutomaticSize = t,
                                            FontFace = font4,
                                            TextSize = 11,
                                            TextColor3 = L.val,
                                        }), ctx.createFrame, {Parent = newInstance}, ctx.udim2

                                        Jq.Position = Uq(0, 11, 1, -13)
                                        kq = ctx.udim2
                                        Jq.Size = kq(1, -22, 0, 5)
                                        Jq.BackgroundTransparency = 0.86
                                        Jq.ZIndex = 2

                                        _VX.setList(Jq, 0, D1())

                                        local M1 = X1(Jq)

                                        Uq, Dq = {Parent = M1}, ctx.udim2
                                        Uq.Size = Dq(0, 0, 1, 0)

                                        _VX.setList(Uq, 0, D1(), U1(L.a1, L.a2))

                                        local X1, Dq, Jq = frame(Uq), {
                                            Parent = M1,
                                            AnchorPoint = T,
                                        }, ctx.udim2

                                        Dq.Position = Jq(0, 0, 0.5, 0)
                                        Dq.Size = x(13, 13)
                                        Dq.ZIndex = 3

                                        _VX.setList(Dq, 0, D1(), J1(0.65, color3FromRGB(0, 0, 0)))

                                        local Jq = frame(Dq)

                                        e1 = function(Dq, Uq)
                                            local aq, Hq, kq = math.clamp(j1.Frac(Dq), 0, 1), {}, ctx.udim2

                                            Hq.Size = kq(aq, 0, 1, 0)

                                            k1(X1, Hq, Uq and 0 or 0.1)

                                            kq, Hq = {}, ctx.udim2
                                            kq.Position = Hq(aq, 0, 0.5, 0)

                                            k1(Jq, kq, Uq and 0 or 0.1)

                                            u1.Text = j1.Txt(Dq)
                                        end

                                        newInstance.InputBegan:Connect(function(input)
                                            if V1(input) then
                                                y1 = {
                                                    o = j1,
                                                    tr = M1,
                                                    i = input,
                                                }
                                                W1.s = true

                                                b1(input)
                                            end
                                        end)
                                    end
                                end
                            end
                            if e1 then
                                e1(j1.Value, true)

                                j1.ls[#j1.ls + 1] = e1
                                F1[#F1 + 1] = {j1, e1}
                            end
                        end

                        Iq.sp.a(Iq.sp.p)
                        B1(Y1, true, (s1 - 1) * 0.06)
                    end
                end
            end
            local function M1()
                o1 += 1

                local F1 = o1

                task.delay(0.15, function()
                    if F1 == o1 then
                        setFramesAlpha()
                    end
                end)
            end

            target = ctx.RunService

            G(target.Heartbeat, function(F1)
                for o1, o1 in ipairs(d1)do
                    A1(o1.sp, F1)
                end
            end)
            G(workspace.CurrentCamera:GetPropertyChangedSignal('ViewportSize'), function()
                local viewportSize = workspace.CurrentCamera.ViewportSize

                if viewportSize.X < 300 then
                    return
                elseif viewportSize.Y < 200 then
                    return
                end

                for F1, F1 in ipairs(d1)do
                    F1.place(viewportSize, math.clamp(viewportSize.Y / 720, 0.75, 1.2) * K.size)
                end
            end)
            G(UserInputService.InputChanged, function(A1)
                if y1 then
                    if A1 == y1.i then
                        b1(A1)
                    else
                        local F1 = ctx.Enum

                        if y1.i.UserInputType == F1.UserInputType.MouseButton1 then
                            local F1 = ctx.Enum

                            if A1.UserInputType == F1.UserInputType.MouseMovement then
                                b1(A1)
                            end
                        end
                    end
                end
                if m1 then
                    if A1 ~= m1.i then
                        local F1 = ctx.Enum

                        if A1.UserInputType ~= F1.UserInputType.MouseMovement then
                            return
                        end
                    end
                else
                    return
                end

                local F1, o1 = vector2New(A1.Position.X, A1.Position.Y) - m1.s, m1

                o1.mv = o1.mv or F1.Magnitude > 6

                if m1.mv then
                    o1, A1 = workspace.CurrentCamera.ViewportSize, m1.p + F1
                    m1.b.sp.t = vector2New(math.clamp(A1.X, 40, o1.X - 40), math.clamp(A1.Y, 0, o1.Y - 40))
                end
            end)
            G(UserInputService.InputEnded, function(A1)
                if y1 then
                    if A1 == y1.i then
                        y1 = nil
                    else
                        local F1 = ctx.Enum

                        if A1.UserInputType == F1.UserInputType.MouseButton1 then
                            y1 = nil
                        end
                    end
                end
                if m1 then
                    if A1 ~= m1.i then
                        local F1 = ctx.Enum

                        if A1.UserInputType ~= F1.UserInputType.MouseButton1 then
                            return
                        end
                    end
                else
                    return
                end

                A1 = m1
                m1 = nil

                if A1.mv then
                    P.at[A1.b.id] = {
                        A1.b.sp.t.X,
                        A1.b.sp.t.Y,
                    }

                    Q1()
                end
            end)

            local function A1(F1, m1)
                if m1 then
                    if t1.Key then
                        if m1 == t1.Key.Name then
                            local o1, y1 = ctx.Venyx, (Q[m1] or m1) .. ' already shows and hides the menu'

                            return o1:Notify('Key not set', y1, 'warn')
                        end
                    end
                end

                local o1, y1 = next, P.keys

                for b1, B1 in o1, y1, nil do
                    if m1 then
                        if B1 == m1 then
                            if b1 ~= F1 then
                                P.keys[b1] = nil

                                local o1 = ctx.Venyx

                                o1:Notify('Key moved', (Q[m1] or m1) .. ' now toggles ' .. z1(F1) .. ' instead of ' .. z1(b1), 'info')
                            end
                        end
                    end
                end

                P.keys[F1] = m1

                Q1()
                setFramesAlpha()
            end

            function t1.Pin(F1, m1)
                F1 = ctx.newInstance

                local o1, y1, b1, B1, u1 = F1('UIScale', {Scale = 0.9}), false
                local P1 = textButton({
                    Parent = O1,
                    Size = _,
                    BackgroundColor3 = color3FromRGB(5, 6, 16),
                    ZIndex = 30,
                    D1(16),
                })
                local O1, j1, e1, s1, Y1 = {
                    Parent = P1,
                    AnchorPoint = T,
                    Position = Z,
                    Size = x(390, 0),
                    AutomaticSize = g,
                    BackgroundTransparency = 0.02,
                    BackgroundColor3 = L.pn,
                }, D1(18), J1(0.8), H1(20), ctx.listLayout
                local X1, Dq, Jq, Uq = Y1(10), ctx.createFrame, {}, ctx.udim2

                Jq.Size = Uq(1, 0, 0, 46)
                Y1 = ctx.createFrame

                local aq, Hq, kq = Y1({
                    Size = x(46, 46),
                    BackgroundTransparency = 0.8,
                    BackgroundColor3 = L.a1,
                    D1(14),
                    u('pin', 22, L.a1),
                }), {
                    Position = x(60, 3),
                }, ctx.udim2

                Hq.Size = kq(1, -60, 0, 22)
                Hq.Text = z1(m1)
                Hq.FontFace = font6
                Hq.TextSize = 17
                Hq.TextTruncate = atEnd
                kq, F1, Uq = textLabel(Hq), {
                    Position = x(60, 26),
                }, ctx.udim2
                F1.Size = Uq(1, -60, 0, 16)
                F1.Text = i1(m1)
                F1.TextSize = 11.5
                F1.TextTransparency = 0.42
                F1.TextTruncate = atEnd

                _VX.setList(Jq, 0, aq, kq, textLabel(F1))
                _VX.setList(O1, 0, j1, e1, s1, X1, o1, Dq(Jq))

                local rq = textButton(O1)

                local function Cq(wq, Vq)
                    local Wq, Iq = {
                        Parent = rq,
                        LayoutOrder = wq,
                    }, ctx.udim2

                    Wq.Size = Iq(1, 0, 0, 22)
                    Wq.Text = Vq
                    Wq.FontFace = font5
                    Wq.TextSize = 10
                    Wq.TextTransparency = 0.45
                    Iq = ctx.Enum
                    Wq.TextYAlignment = Iq.TextYAlignment.Bottom

                    textLabel(Wq)
                end

                Cq(1, 'SHOW ON QUICK BAR')

                Dq, kq, F1 = ctx.createFrame, {
                    Parent = rq,
                    LayoutOrder = 2,
                }, ctx.udim2
                kq.Size = F1(1, 0, 0, 40)
                O1, s1, aq = ctx.newInstance, {}, ctx.udim2
                s1.CellSize = aq(0.16666666666666666, -7, 1, 0)
                s1.CellPadding = x(8, 0)
                e1 = ctx.Enum
                s1.SortOrder = e1.SortOrder.LayoutOrder

                _VX.setList(kq, 0, O1('UIGridLayout', s1))

                local wq, Vq = Dq(kq), {}

                local function Dq(Wq)
                    for Iq, vq in next, Vq do
                        local hq, nq, Mq = (P.pins[m1] or 0) == Iq, vq[1], {}

                        Mq.BackgroundTransparency = hq and 0 or 1

                        k1(nq, Mq, Wq and 0 or 0.2)
                        k1(vq[2], {
                            Transparency = hq and 0.45 or 0.84,
                            Color = hq and L.a1 or L.wh,
                        }, Wq and 0 or 0.2)

                        vq[3].TextColor3 = hq and L.on or L.wh
                    end
                end

                for Wq = 0, 5, 1 do
                    X1, Jq = J1(0.84), textLabel({
                        Size = _,
                        Text = Wq == 0 and 'Off' or Wq,
                        FontFace = font5,
                        TextSize = 13,
                        TextXAlignment = center,
                        ZIndex = 2,
                    })
                    s1, Hq, kq = textButton({
                        Parent = wq,
                        LayoutOrder = Wq,
                        BackgroundTransparency = 0.93,
                        D1(12),
                        X1,
                        Jq,
                    }), {}, ctx.createFrame

                    _VX.setList(Hq, 0, kq({
                        Parent = s1,
                        Size = _,
                        D1(12),
                        U1(L.a1, L.a2, 90),
                    }), X1, Jq)

                    Vq[Wq] = Hq

                    x1(s1, 0.9, function()
                        P.pins[m1] = Wq > 0 and Wq or nil

                        Dq()
                        Q1()
                        setFramesAlpha()

                        if Wq > 0 then
                            if not K.show then
                                local Vq = ctx.Venyx

                                Vq:Notify('Quick bars are hidden', 'Turn on Show quick bars to see Quick bar ' .. Wq, 'info')
                            end
                        end
                    end)
                end

                Dq(true)

                local function Dq()
                    B1.Text = y1 and 'Press any key  -  Esc cancels' or N1(m1) or 'Not set'
                    B1.TextTransparency = (y1 or P.keys[m1]) and 0 or 0.45

                    k1(u1, {
                        Transparency = y1 and 0.3 or 0.82,
                        Color = y1 and L.a1 or L.wh,
                    }, 0.2)
                end

                aq, O1 = UserInputService.KeyboardEnabled

                if aq then
                    F1 = ctx.Venyx
                    Hq = F1.Keys[m1].Kind == 'toggle'

                    if Hq then
                        O1 = Hq
                    else
                        Uq = ctx.Venyx
                        O1 = Uq.Keys[m1].Kind == 'button'
                    end
                else
                    O1 = aq
                end

                local aq

                if O1 then
                    Cq(3, 'KEYBIND')

                    u1 = J1(0.82)
                    Uq, s1, Y1 = ctx.createFrame, {
                        Parent = rq,
                        LayoutOrder = 4,
                    }, ctx.udim2
                    s1.Size = Y1(1, 0, 0, 40)
                    F1 = Uq(s1)
                    j1, X1 = {Parent = F1}, ctx.udim2
                    j1.Size = X1(1, -98, 1, 0)
                    j1.BackgroundTransparency = 0.92

                    _VX.setList(j1, 0, D1(12), u1)

                    wq = textButton(j1)
                    B1 = textLabel({
                        Parent = wq,
                        Size = _,
                        FontFace = font4,
                        TextSize = 14,
                        TextXAlignment = center,
                    })

                    x1(wq, 0.96, function()
                        local B1 = ctx.Venyx

                        y1 = true
                        B1.kw = true

                        Dq()
                    end)

                    Jq, kq = {Parent = F1}, ctx.topRight
                    Jq.AnchorPoint = kq
                    e1 = ctx.udim2
                    Jq.Position = e1(1, 0, 0, 0)
                    Hq = ctx.udim2
                    Jq.Size = Hq(0, 88, 1, 0)
                    Jq.BackgroundTransparency = 0.92

                    _VX.setList(Jq, 0, D1(12), J1(0.84), textLabel({
                        Size = _,
                        Text = 'Clear',
                        FontFace = font6,
                        TextSize = 13,
                        TextXAlignment = center,
                    }))
                    x1(textButton(Jq), 0.92, function()
                        local F1 = ctx.Venyx

                        y1 = false
                        F1.kw = nil

                        A1(m1)
                        Dq()
                    end)

                    b1 = UserInputService.InputBegan:Connect(function(F1)
                        if y1 then
                            local B1 = ctx.Enum

                            if F1.UserInputType ~= B1.UserInputType.Keyboard then
                                return
                            end
                        else
                            return
                        end

                        y1 = false

                        task.defer(function()
                            local B1 = ctx.Venyx

                            B1.kw = nil
                        end)

                        local B1 = ctx.Enum

                        if F1.KeyCode ~= B1.KeyCode.Escape then
                            A1(m1, F1.KeyCode.Name)
                        end

                        Dq()
                    end)

                    Dq()

                    aq = b1
                else
                    aq = b1
                end

                -- Registers Completed signal callback(s)
                local function disconnectSignal()
                    if aq then
                        aq:Disconnect()
                    end
                    if y1 then
                        local F1 = ctx.Venyx

                        F1.kw = nil
                    end

                    k1(o1, {Scale = 0.92}, 0.18)

                    local F1, m1 = k1(P1, {BackgroundTransparency = 1}, 0.2), function()
                        P1:Destroy()
                    end

                    F1.Completed:Connect(m1)

                    rq.Visible = false
                end

                Y1, O1, kq = ctx.createFrame, {
                    Parent = rq,
                    LayoutOrder = 5,
                }, ctx.udim2
                O1.Size = kq(1, 0, 0, 52)

                _VX.setList(O1, 0, H1(10, 0, 0))

                Uq, e1 = T1(Y1(O1), 'Done', 0, 1, true), function()
                    if I1() then
                        disconnectSignal()
                    end
                end

                Uq.Activated:Connect(e1)
                P1.Activated:Connect(disconnectSignal)
                k1(P1, {BackgroundTransparency = 0.45}, 0.2)
                k1(o1, {Scale = 1}, 0.35, back)
            end

            target = N:Section('Quick bars', 'zap')

            target:Toggle('Show quick bars', true, function(I1)
                K.show = I1

                M1()
            end)
            target:Toggle('Keybinds', true, function(I1)
                K.keys = I1
            end)
            target:Slider('Bar size', 60, 160, 100, function(I1)
                K.size = I1 / 100

                for I1, I1 in ipairs(d1)do
                    I1.u.Scale = math.clamp(workspace.CurrentCamera.ViewportSize.Y / 720, 0.75, 1.2) * K.size
                end
            end, '%', 5)

            C1.Set = function(I1, A1, d1)
                I1.Value = tostring(A1 or '')

                local F1, F1, F1, T1 = ctx.HttpService, ctx.HttpService, pcall(ctx.HttpService.JSONDecode, ctx.HttpService, I1.Value)

                if F1 and type(T1) == 'table' and type(T1.pins) == 'table' then
                    A1 = {
                        'keys',
                        'at',
                        'fold',
                    }

                    for I1, I1 in ipairs(A1)do
                        T1[I1] = type(T1[I1]) == 'table' and T1[I1] or {}
                    end

                    P = T1
                else
                    E1()
                end
                if not d1 then
                    M1()
                end
            end

            target:Reg('Quick bar layout', C1)

            local C1 = N:Section('Pins and keybinds', 'pin')

            C1:Text(
[[Tip: you can also hold any feature, or right-click it on PC, to pin it or set a key.]])

            local I1, A1, d1 = ctx.createFrame, {
                Parent = C1.f,
                LayoutOrder = C1.n + 1,
                Size = f,
                AutomaticSize = g,
            }, ctx.listLayout

            _VX.setList(A1, 0, H1(4, 14, 12), d1(8))

            d1 = I1(A1)

            C1:Add(d1, '')

            local F1, T1, m1 = ctx.createFrame, {Parent = d1}, ctx.udim2

            T1.Size = m1(1, 0, 0, 34)
            m1 = F1(T1)
            I1, T1 = {Parent = m1}, ctx.udim2
            I1.Size = T1(1, -150, 1, 0)

            local T1, o1, y1, b1, B1 = updateBackgroundAlpha(I1, 'Find an option'), 'All', ctx.createFrame, {Parent = m1}, ctx.topRight

            b1.AnchorPoint = B1
            F1 = ctx.udim2
            b1.Position = F1(1, 0, 0, 0)
            F1 = ctx.udim2
            b1.Size = F1(0, 142, 1, 0)
            b1.BackgroundTransparency = 0.93

            _VX.setList(b1, 0, D1(10), J1(0.86), H1(3))

            F1 = y1(b1)
            y1, I1 = {Parent = F1}, ctx.udim2
            y1.Size = I1(0.5, 0, 1, 0)

            _VX.setList(y1, 0, D1(8), U1(L.a1, L.a2, 90))

            local I1, l1, B1 = frame(y1), {
                Parent = d1,
                LayoutOrder = 1,
            }, ctx.udim2

            l1.Size = B1(1, 0, 0, 300)
            b1 = ctx.listLayout

            _VX.setList(l1, 0, b1(4))

            local b1 = scrollingFrame(l1)

            t1.nest[b1] = N.top or N
            A1, d1 = {Parent = b1}, ctx.udim2
            A1.Size = d1(1, 0, 0, 60)
            A1.TextSize = 12
            A1.TextTransparency = 0.45
            A1.TextXAlignment = center

            local N = textLabel(A1)

            g1 = function()
                for d1, d1 in ipairs(b1:GetChildren())do
                    if d1:IsA('GuiObject') then
                        if d1 ~= N then
                            d1:Destroy()
                        end
                    end
                end

                local d1, ipairsFn, B1 = T1.Text:lower(), ipairs, table.pack(G1())
                local O1
                local G1 = 0

                for u1, P1 in ipairsFn(_VX.unpack(B1))do
                    if o1 == 'All' or P.pins[P1] or P.keys[P1] then
                        if P1:lower():find(d1, 1, true) then
                            local d1, l1 = P.pins[P1], N1(P1)

                            u1 = nil

                            if i1(P1) ~= O1 then
                                local N1 = i1(P1)

                                u1 = G1 + 1

                                local i1, B1 = {
                                    Parent = b1,
                                    LayoutOrder = u1,
                                }, ctx.udim2

                                i1.Size = B1(1, -6, 0, 24)
                                i1.Text = N1:upper()
                                i1.FontFace = font5
                                i1.TextSize = 9.5
                                i1.TextTransparency = 0.5
                                B1 = ctx.Enum
                                i1.TextYAlignment = B1.TextYAlignment.Bottom

                                _VX.setList(i1, 0, H1(0, 0, 3, 6))
                                textLabel(i1)

                                O1 = N1
                            else
                                u1 = G1
                            end

                            local i1, N1, B1 = ctx.createFrame, {AnchorPoint = R}, ctx.udim2

                            N1.Position = B1(1, -10, 0.5, 0)
                            N1.Size = x(170, 22)

                            local B1, O1 = ctx.listLayout, ctx.Enum
                            local j1, e1, s1, Y1, X1, Dq, Jq = B1(6, O1.HorizontalAlignment.Right, center2, horizontal), {
                                LayoutOrder = 1,
                                Size = x(0, 22),
                                AutomaticSize = t,
                                BackgroundTransparency = d1 and 0 or 0.9,
                            }, D1(), H1(0, 9), d1 and U1(L.a1, L.a2, 90) or nil, {}, ctx.udim2

                            Dq.Size = Jq(0, 0, 1, 0)
                            Dq.AutomaticSize = t
                            Dq.Text = d1 and 'QUICK BAR ' .. d1 or '+ PIN'
                            Dq.FontFace = font5
                            Dq.TextSize = 9.5
                            Dq.TextTransparency = d1 and 0 or 0.4
                            Dq.TextColor3 = d1 and L.on or L.wh

                            _VX.setList(e1, 0, s1, Y1, X1, textLabel(Dq))
                            _VX.setList(N1, 0, j1, frame(e1))

                            B1 = i1(N1)

                            if l1 then
                                textLabel({
                                    Parent = B1,
                                    Size = x(0, 22),
                                    AutomaticSize = t,
                                    Text = l1,
                                    FontFace = font4,
                                    TextSize = 10.5,
                                    TextXAlignment = center,
                                    BackgroundTransparency = 0.88,
                                    D1(7),
                                    H1(0, 7),
                                })
                            end

                            u1 += 1

                            s1, e1 = {
                                Parent = b1,
                                LayoutOrder = u1,
                            }, ctx.udim2
                            s1.Size = e1(1, -6, 0, 38)
                            s1.BackgroundTransparency = 0.955
                            O1, N1, i1, d1 = D1(12), J1(0.9), {
                                Position = x(12, 0),
                            }, ctx.udim2
                            i1.Size = d1(1, -190, 1, 0)
                            i1.RichText = true
                            e1, j1 = z1(P1), ctx.Venyx
                            X1, Jq = j1.Keys[P1].Kind ~= 'toggle'

                            if X1 then
                                l1 = ctx.Venyx
                                Jq = '  <font transparency="0.6">' .. l1.Keys[P1].Kind .. '</font>'
                            else
                                Jq = X1
                            end

                            i1.Text = e1 .. (Jq or '')
                            i1.FontFace = font6
                            i1.TextSize = 13
                            i1.TextTruncate = atEnd

                            _VX.setList(s1, 0, O1, N1, B1, textLabel(i1))
                            x1(textButton(s1), 0.97, function()
                                t1:Pin(P1)
                            end)

                            G1 = u1
                        end
                    end
                end

                N.Visible, N.Text = G1 == 0, o1 == 'All' and 'No option matches' or 'Nothing pinned or bound yet'
            end

            local N, d1, l1 = {}, ipairs, {
                'All',
                'Pinned',
            }

            for b1, i1 in d1(l1)do
                N[b1] = textLabel({
                    Size = _,
                    Text = i1,
                    FontFace = font6,
                    TextSize = 12,
                    TextXAlignment = center,
                    TextColor3 = b1 == 1 and L.on or L.wh,
                })
                A1, y1 = {Parent = F1}, ctx.udim2
                A1.Position = y1((b1 - 1) / 2, 0, 0, 0)
                m1 = ctx.udim2
                A1.Size = m1(0.5, 0, 1, 0)
                A1.ZIndex = 2

                _VX.setList(A1, 0, N[b1])
                x1(textButton(A1), 0.95, function()
                    o1 = i1

                    for index, d1 in ipairs(N)do
                        k1(d1, {
                            TextColor3 = index == b1 and L.on or L.wh,
                        }, 0.2)
                    end

                    local N, udim2 = {}, ctx.udim2

                    N.Position = udim2((b1 - 1) / 2, 0, 0, 0)

                    k1(I1, N, 0.3, back)
                    g1()
                end)
            end

            local N = 0

            G(T1:GetPropertyChangedSignal('Text'), function()
                N += 1

                local I1 = N

                task.delay(0.2, function()
                    if I1 == N then
                        g1()
                    end
                end)
            end)
            C1:Button('Clear all quick bars', 'Clear', function()
                c1('Clear every quick bar?', 'Features keep their state, they just leave the bars.', 'warn', 'Clear', function(
                )
                    P.pins = {}

                    Q1()
                    setFramesAlpha()
                end)
            end, 'danger')
            C1:Button('Clear all keybinds', 'Clear', function()
                c1('Clear every keybind?', 'Keys stop toggling options until you set them again.', 'warn', 'Clear', function(
                )
                    P.keys = {}

                    Q1()
                    setFramesAlpha()
                end)
            end, 'danger')
            G(UserInputService.InputBegan, function(N, S)
                if S then
                    return
                else
                    local C1 = ctx.Venyx

                    if C1.kw then
                        return
                    elseif K.keys then
                        local enum = ctx.Enum

                        if N.UserInputType ~= enum.UserInputType.Keyboard then
                            return
                        end
                    else
                        return
                    end
                end

                local nextFn, C1 = next, P.keys

                for P, I1 in nextFn, C1, nil do
                    S = ctx.Venyx

                    local K = S.Keys[P]

                    if K then
                        if I1 == N.KeyCode.Name then
                            if K.Kind == 'button' then
                                K.Fire()

                                local venyx = ctx.Venyx

                                venyx:Notify(z1(P), 'Pressed', 'ok', 2)
                            else
                                local venyx = ctx.Venyx

                                venyx.qb = true

                                K:Set(not K.Value)

                                venyx = ctx.Venyx
                                venyx.qb = nil
                                venyx = ctx.Venyx

                                venyx:Notify(z1(P), K.Value and 'Turned on' or 'Turned off', K.Value and 'ok' or 'info', 2)
                            end
                        end
                    end
                end
            end)
            E1()
            M1()

            return target
        end
        t1.Wheel = function(instance, N)
            instance = t1.Cur and t1.Cur.sc

            if UserInputService.TouchEnabled then
                return
            elseif t1.open then
                if K1.open then
                    return
                elseif t1.dlg then
                    return
                elseif os.clock() - (t1.wt or 0) < 0.015 then
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

            t1.wt = os.clock()

            local S = UserInputService:GetMouseLocation() - (t1.Gui.IgnoreGuiInset and vector2New() or vector2New(0, 58))

            for key, value in next, t1.nest do
                local C1, I1, M1 = key.AbsolutePosition, key.AbsoluteSize, key.CanvasPosition.Y

                instance = if key.Parent then if(t1.Cur.top or t1.Cur) == value then if S.X >= C1.X then if S.Y >= C1.Y then if S.X <= C1.X + I1.X then if S.Y <= C1.Y + I1.Y then if N > 0 and M1 > 1 then key else if N < 0 then if M1 < key.AbsoluteCanvasSize.Y - I1.Y - 1 then key else instance else instance else instance else instance else instance else instance else instance else instance
            end

            local max, goal, K = math.max(0, instance.AbsoluteCanvasSize.Y - instance.AbsoluteWindowSize.Y), t1.goal, instance.CanvasPosition.Y

            goal = if goal then if t1.gf ~= instance then K else if math.abs(goal - K) > 300 then K else goal else K
            t1.goal = math.clamp(goal - N * 120, 0, max)
            t1.gf = instance

            k1(instance, {
                CanvasPosition = vector2New(0, t1.goal),
            }, 0.4)
        end

        G(UserInputService.InputChanged, function(H)
            local N, enum = t1.Cur and t1.Cur.sc, ctx.Enum

            if H.UserInputType ~= enum.UserInputType.MouseWheel then
                return
            elseif N then
            else
                return
            end

            local S, absolutePosition, absoluteSize = UserInputService:GetMouseLocation() - (t1.Gui.IgnoreGuiInset and vector2New() or vector2New(0, 58)), N.AbsolutePosition, N.AbsoluteSize

            if S.X < absolutePosition.X then
                return
            elseif S.Y < absolutePosition.Y then
                return
            elseif S.X > absolutePosition.X + absoluteSize.X then
                return
            elseif S.Y > absolutePosition.Y + absoluteSize.Y then
                return
            end

            t1:Wheel(H.Position.Z)
        end)

        t1.Destroy = function(H)
            H = O

            for index, value in ipairs(H)do
                value:Disconnect()
            end

            O = {}
local _=
ctx.RunService, ctx.RunService

            pcall(ctx.RunService.UnbindFromRenderStep, ctx.RunService, q1)
            f1:Destroy()

            H = getgenv and getgenv().VenyxWindows

            if H then
                if H[t1.Id] == t1 then
                    H[t1.Id] = nil
                end
            end
        end
        t1.Notify = function(target, ...)
            target = ctx.Venyx

            return target:Notify(...)
        end
        S1 = ctx.Venyx

        S1:Boot()
        t1:Show(true)

        return t1
    end
    R1.new = function(parent, callback, imageId, key)
        local P, K, C1 = setmetatable({
            t = parent,
            W = parent.W,
            n = 0,
            name = callback,
            side = key,
        }, R1), {}, ctx.udim2

        K.Size = C1(1, 0, 0, 42)

        local I1, M1, udim2 = e({
            Position = x(14, 14),
            Size = x(15, 15),
            Image = imageId or 'grid',
            ImageColor3 = F[#parent.Secs % 5 + 1],
        }), {
            Position = x(37, 12),
        }, ctx.udim2

        M1.Size = udim2(1, -76, 0, 18)
        M1.Text = callback:upper()
        M1.FontFace = font5
        M1.TextSize = 12
        M1.TextTransparency = 0.06
        M1.TextTruncate = atEnd

        _VX.setList(K, 0, I1, textLabel(M1))

        P.hd = textButton(K)
        C1, I1 = {
            Parent = P.hd,
            AnchorPoint = T,
        }, ctx.udim2
        C1.Position = I1(1, -22, 0, 21)
        C1.Size = x(14, 14)
        C1.Image = 'down'
        C1.ImageTransparency = 0.5
        P.ch = e(C1)
        udim2, C1, callback = ctx.createFrame, {
            LayoutOrder = 1,
            Size = f,
            AutomaticSize = g,
            ClipsDescendants = true,
        }, ctx.listLayout

        _VX.setList(C1, 0, callback())

        P.f = udim2(C1)

        if key then
            if key > 2 then
                parent.cols[key].Visible = true
            end
        end

        K, C1, M1 = ctx.createFrame, {
            Parent = parent.cols[key or 1],
            Size = f,
            AutomaticSize = g,
            BackgroundTransparency = 0.95,
            LayoutOrder = #parent.Secs + 1,
        }, ctx.listLayout

        _VX.setList(C1, 0, D1(16), J1(0.88), M1(), P.hd, P.f)

        P.card = K(C1)

        v1(P.hd, function()
            P:Collapse(P.open ~= false)
        end)

        parent.Secs[#parent.Secs + 1] = P
        parent.list[#parent.list + 1] = P

        G(P.card:GetPropertyChangedSignal('AbsoluteSize'), function()
            p1(parent)
        end)
        p1(parent)

        return P
    end
    -- Registers Completed signal callback(s)
    R1.Collapse = function(H, rotation)
        H.open = not rotation

        local N = H.f
        local max = math.max(H.hd.AbsoluteSize.Y / 42, 0.1)
        local O, udim2 = N:FindFirstChildOfClass('UIListLayout').AbsoluteContentSize.Y / max, ctx.udim2

        N.Size = udim2(1, 0, 0, N.AbsoluteSize.Y / max)
        udim2 = ctx.Enum
        N.AutomaticSize = udim2.AutomaticSize.None
        max, udim2 = {}, ctx.udim2
        max.Size = udim2(1, 0, 0, rotation and 0 or O)
        udim2, O = k1(N, max, 0.35), function()
            if H.open then
                N.AutomaticSize = g
            end
        end

        udim2.Completed:Connect(O)

        O, udim2 = H.ch, {}
        udim2.Rotation = rotation and -90 or 0

        k1(O, udim2, 0.3)
    end
    R1.Add = function(H, F, rawText, S)
        if H.n > 0 then
            V(F, x(14, 0), ctx.udim2(1, -28, 0, 1))
        end

        H.n = H.n + 1

        if S then
            local all = H.W.All
            local O, P = #all + 1, {
                r = F,
                n = rawText:lower(),
                title = rawText,
                tab = H.t.top,
                path = H.t.Name .. ' / ' .. H.name,
            }

            P.k, all[O] = H.t.Name .. '/' .. H.name .. '/' .. rawText, P
        end
    end
    R1.Row = function(callback, F, callback2, S)
        local O, P, udim2 = callback2 and 48 or 42, {
            Parent = callback.f,
        }, ctx.udim2

        P.Size = udim2(1, 0, 0, O)
        P.LayoutOrder = callback.n + 1

        _VX.setList(P, 0, D1(14))

        local C1 = textButton(P)

        callback:Add(C1, F, true)
        r1(C1, 0.97)
        G(C1.InputBegan, function(r1)
            if V1(r1) then
                k1(C1, {BackgroundTransparency = 0.94}, 0.08)
            end
        end)
        G(C1.InputEnded, function(r1)
            if V1(r1) then
                k1(C1, {BackgroundTransparency = 1}, 0.35)
            end
        end)

        O, P, callback = ctx.createFrame, {
            Parent = C1,
            AnchorPoint = vector2New(0, 0.5),
        }, ctx.udim2
        P.Position = callback(0, 14, 0.5, 0)
        callback = ctx.udim2
        P.Size = callback(1, -S - 42, 0, callback2 and 42 or 21)
        udim2 = ctx.listLayout
local
H, r1, I1 =udim2(0, nil, center2), {}, ctx.udim2

        r1.Size, r1.Text, r1.TextSize, r1.TextTruncate = ctx.udim2(1, 0, 0, 21), F, 14.5, atEnd

        _VX.setList(P, 0, H, textLabel(r1))

        H = O(P)

        if callback2 then
            textLabel({
                Parent = H,
                LayoutOrder = 1,
                Size = f,
                AutomaticSize = g,
                Text = callback2,
                TextSize = 12,
                TextTransparency = 0.3,
                TextWrapped = true,
            })
        end

        O, r1, callback2 = ctx.createFrame, {
            Parent = C1,
            AnchorPoint = R,
        }, ctx.udim2
        r1.Position = callback2(1, -14, 0.5, 0)
        r1.Size = x(S, 36)

        return C1, O(r1), H
    end
    R1.Reg = function(H, key, N)
        local value = N.Value

        N.Key, N.Name, N.Def = H.t.Name .. '/' .. H.name .. '/' .. key, key, type(value) == 'table' and table.clone(value) or value
        value, H = ctx.Venyx
        H, value.Opt[key], ctx.Venyx.Keys[N.Key] = ctx.Venyx, N, N

        local set = N.Set

        N.Set = function(F, ...)
            set(F, ...)

            F = ctx.State

            if F.AutoSave then
                local venyx = ctx.Venyx

                if not venyx.busy then
                    if not N.Skip then
                        local venyx = ctx.Venyx

                        venyx:Dirty()
                    end
                end
            end
        end

        return N
    end
    R1.Hold = function(H, F, N)
        local S = 0

        G(F.InputEnded, function(O)
            if V1(O) then
                S += 1
            end
        end)
        G(F.InputBegan, function(F)
            local O = H.W

            if not O.Pin then
                return
            end

            local enum = ctx.Enum

            if F.UserInputType == enum.UserInputType.MouseButton2 then
                local key = N.Key

                return O:Pin(key)
            end
            if not (V1(F)) then
                return
            end

            S += 1

            local H = S
            local enum, P = ctx.Enum, F.UserInputType == ctx.Enum.UserInputType.MouseButton1

            task.delay(0.6, function()
                local K, r1 = S == H and W1.m < 14 and not W1.s

                if K then
                    local H = P and UserInputService:IsMouseButtonPressed(F.UserInputType)

                    if H then
                        r1 = H
                    else
                        local H = not P

                        if P then
                            r1 = H
                        else
                            local enum

                            enum, r1 = ctx.Enum, F.UserInputState ~= ctx.Enum.UserInputState.End
                        end
                    end
                else
                    r1 = K
                end
                if r1 then
                    W1.s = true

                    O:Pin(N.Key)
                end
            end)
        end)
    end
    R1.Toggle = function(target, F, N, S, O)
        local P, K = target:Row(F, O, 48)
        local O, r1 = E(K, 46, 24), {}

        r1.Value = not not N
        r1.ls = {}
        r1.Tab = target.t.Name
        r1.Kind = 'toggle'
        r1.Set = function(E, E, K)
            E = not not E
            r1.Value = E

            O(E)

            for C1, C1 in ipairs(r1.ls)do
                C1(E)
            end

            if not K then
                w1(S, E)
            end
        end

        v1(P, function()
            r1:Set(not r1.Value)
        end)
        target:Hold(P, r1)
        O(r1.Value, true)

        if N then
            w1(S, true)
        end

        return target:Reg(F, r1)
    end

    local H = {
        K = 1000,
        M = 1000000,
        B = 1000000000,
        T = 1000000000000,
    }

    R1.Slider = function(target, N, S, O, E, P, callback, r1, C1)
        local I1, M1, A1 = callback == 'log'

        if I1 then
            S, O = 0, 1000
            M1, A1 = S, O
        else
            M1, A1 = S, O
        end

        local S = r1 or 1
        local O, r1, d1 = target:Row(N, C1, 200)
        local textLabel = d1:FindFirstChildOfClass('TextLabel')

        textLabel:SetAttribute('nofit', true)

        textLabel.TextSize = 17

        local F1 = {w = 0}

        local function Q1()
            local T1 = ctx.udim2

            d1.Size = T1(0, F1.w, d1.Size.Y.Scale, d1.Size.Y.Offset)
            T1 = ctx.udim2
            r1.Size = T1(1, -F1.w - 46, 0, 36)
        end

        F1[#F1 + 1] = Q1

        local function d1()
            local T1 = textLabel.AbsoluteSize.Y / 21

            if T1 <= 0 then
                return
            elseif textLabel.TextBounds.X <= 0 then
                return
            end

            local max = math.max(math.ceil(textLabel.TextBounds.X / T1) + 6, C1 and math.min(150, #C1 * 6.3 + 6) or 0)

            if max <= F1.w then
                return Q1()
            end

            F1.w = max

            for C1, C1 in ipairs(F1)do
                C1()
            end
        end

        G(textLabel:GetPropertyChangedSignal('TextBounds'), d1)
        task.defer(d1)

        local C1, l1, F1 = ctx.createFrame, {Parent = r1}, ctx.udim2

        l1.Position = F1(0, 8, 0.5, -3)
        F1 = ctx.udim2
        l1.Size = F1(1, -70, 0, 6)
        l1.BackgroundTransparency = 0.88

        _VX.setList(l1, 0, D1())

        local Q1 = C1(l1)

        l1, d1 = {Parent = Q1}, ctx.udim2
        l1.Size = d1(0, 0, 1, 0)

        _VX.setList(l1, 0, D1(), U1(L.a1, L.a2))

        local C1, d1, T1 = frame(l1), {
            Parent = Q1,
            AnchorPoint = T,
        }, ctx.udim2

        d1.Position = T1(0, 0, 0.5, 0)
        d1.Size = x(20, 20)
        d1.ZIndex = 2

        _VX.setList(d1, 0, D1(), J1(0.65, color3FromRGB(0, 0, 0)))

        local T1, newInstance = frame(d1), ctx.newInstance
        local d1 = newInstance('UIScale', {Parent = T1})

        F1 = J1(0.8)

        local m1 = textBox({
            Parent = r1,
            AnchorPoint = R,
            Position = b,
            Size = x(54, 28),
            FontFace = font5,
            TextSize = 13,
            TextTruncate = atEnd,
            TextColor3 = L.val,
            TextXAlignment = center,
            BackgroundTransparency = 0.72,
            BackgroundColor3 = color3FromRGB(0, 0, 0),
            D1(8),
            H1(4, 4),
            F1,
        })

        local function c1(g1)
            if g1 <= 0 then
                return 0
            end

            local t1 = 10 ^ (3 + 9 * g1 / 1000)

            g1 = 10 ^ (math.floor(math.log10(t1)) - 2)

            return math.floor(t1 / g1 + 0.5) * g1
        end
        local function g1(t1)
            return I1 and (t1 <= 0 and 0 or math.clamp((math.log10(t1) - 3) / 9 * 1000, 0, 1000)) or t1
        end
        local function t1(o1, y1)
            local f1, b1 = string.format, o1 >= 100 and '%.0f' or o1 >= 10 and '%.1f'
            local z1 = f1(b1 or '%.2f', o1)

            return (z1:find('%.') and z1:gsub('0+$', ''):gsub('%.$', '') or z1) .. y1
        end
        local function o1(y1, f1)
            if not I1 then
                return type(callback) == 'function' and callback(y1) or h1(y1) .. (callback or '')
            end
            if y1 <= 0 then
                return f1 and '0' or 'Off'
            end

            local K = y1 < 1000000 and 1000 or y1 < 1000000000 and 1000000 or 1000000000

            return t1(y1 / K, (K == 1000 and 'K' or K == 1000000 and 'M' or 'B') .. (f1 and '' or '/s'))
        end

        l1, newInstance = {
            Parent = r1,
            Position = x(-4, -2),
        }, ctx.udim2
        l1.Size = newInstance(1, -60, 1, 4)
        l1.ZIndex = 3

        local K, r1 = textButton(l1), {
            ls = {},
            Kind = 'slider',
        }

        r1.Set = function(h1, num, p1, t1)
            if type(num) ~= 'number' then
                local y1, f1 = tostring(num):upper():match('^([%d%.]+)(%a?)')
                local b1, z1 = tonumber(y1) or 0, H[f1] or (I1 and 1000000 or 1)

                num = b1 * z1
            end

            num = I1 and c1(g1(num)) or math.clamp(math.floor((num - M1) / S + 0.5) * S + M1, M1, A1)
            h1 = num ~= r1.Value
            r1.Value = num

            local H, S, y1 = (g1(num) - M1) / (A1 - M1), {}, ctx.udim2

            S.Size = y1(H, 0, 1, 0)

            k1(C1, S, t1 and 0.08 or 0.3)

            S, y1 = {}, ctx.udim2
            S.Position = y1(H, 0, 0.5, 0)

            k1(T1, S, t1 and 0.08 or 0.3)

            if not (m1:IsFocused()) then
                m1.Text = o1(num)
            end

            for index, value in ipairs(r1.ls)do
                value(num)
            end

            if p1 then
            elseif h1 then
                w1(P, num)
            end
        end

        local C12

        local function S(P)
            local C1 = M1 + (A1 - M1) * math.clamp((P - Q1.AbsolutePosition.X) / Q1.AbsoluteSize.X, 0, 1)

            r1:Set(I1 and c1(C1) or C1, false, true)
        end
        local function P(C1)
            C12 = C1

            if target.t.cols then
                if UserInputService.TouchEnabled then
                    target.t.sc.ScrollingEnabled = not C1
                end
            end

            k1(d1, {
                Scale = C1 and 1.25 or 1,
            }, 0.22, back)
        end

        G(K.InputBegan, function(K)
            local C1 = ctx.Venyx
            local h1 = C1.drag

            if V1(K) then
                if h1 then
                    if h1 ~= r1 then
                        if h1.d then
                            C1 = ctx.Enum

                            if h1.d.UserInputState ~= C1.UserInputState.End then
                                return
                            end
                        end
                    end
                end
            else
                return
            end

            C1 = ctx.Venyx
            C1.drag = r1
            r1.d = K
            W1.s = true

            P(K)
            S(K.Position.X)
        end)

        local function K()
            local C1, enum = C12.UserInputType, ctx.Enum

            return C1 == enum.UserInputType.MouseButton1
        end

        G(UserInputService.InputChanged, function(C1)
            local C13, W1 = C12

            if C13 then
                local h1 = C1 == C12

                if h1 then
                    W1 = h1
                else
                    local h1 = K()

                    if h1 then
                        local d1

                        d1, W1 = ctx.Enum, C1.UserInputType == ctx.Enum.UserInputType.MouseMovement
                    else
                        W1 = h1
                    end
                end
            else
                W1 = C13
            end
            if W1 then
                S(C1.Position.X)
            end
        end)
        G(UserInputService.InputEnded, function(S)
            local C1, W12 = C12

            if C1 then
                local W1 = S == C12

                if W1 then
                    W12 = W1
                else
                    local H = K()

                    if H then
                        local enum

                        enum, W12 = ctx.Enum, S.UserInputType == ctx.Enum.UserInputType.MouseButton1
                    else
                        W12 = H
                    end
                end
            else
                W12 = C1
            end
            if W12 then
                S = ctx.Venyx
                S.drag = nil

                P(nil)
            end
        end)
        G(m1.Focused, function()
            m1.Text = I1 and o1(r1.Value, true) or tostring(r1.Value)

            k1(m1, {BackgroundTransparency = 0.75}, 0.15)
        end)
        L1(m1, F1, 0.5, 0.8, function()
            k1(m1, {BackgroundTransparency = 0.9}, 0.2)

            local H = m1.Text:gsub('[%s,/]', ''):gsub('[sS]$', '')

            H = if I1 then if H:lower() == 'off'then'0'else H else H

            if H:match('^%-?[%d%.]+%a?$') then
                r1:Set(I1 and H or tonumber(H))
            end

            m1.Text = o1(r1.Value)
        end)

        r1.Frac = function(H)
            return (g1(H) - M1) / (A1 - M1)
        end
        r1.Txt = o1
        r1.From = function(H)
            H = M1 + (A1 - M1) * H

            return I1 and c1(H) or H
        end

        target:Hold(O, r1)
        r1:Set(E, true)

        return target:Reg(N, r1)
    end
    R1.Dropdown = function(target, F, N, S, O, text, P)
        local K, r1 = target:Row(F, P, 176)
        local createFrame, C1, udim2 = ctx.createFrame, {
            Parent = r1,
            AnchorPoint = vector2New(0, 0.5),
        }, ctx.udim2

        C1.Position = udim2(0, 0, 0.5, 0)
        udim2 = ctx.udim2
        C1.Size = udim2(1, 0, 0, 32)
        C1.BackgroundTransparency = 0.93

        local r1, V1, W1, I1 = D1(10), J1(0.87), {AnchorPoint = R}, ctx.udim2

        W1.Position = I1(1, -8, 0.5, 0)
        W1.Size = x(13, 13)
        W1.Image = 'down'

        _VX.setList(C1, 0, r1, V1, e(W1))

        W1 = createFrame(C1)
        createFrame, r1 = {
            Parent = W1,
            Position = x(9, 0),
        }, ctx.udim2
        createFrame.Size = r1(1, -34, 1, 0)
        createFrame.FontFace = font6
        createFrame.TextSize = 14
        createFrame.TextTruncate = atEnd

        local r1, C1, udim2 = textLabel(createFrame), {
            Parent = W1,
            AnchorPoint = R,
        }, ctx.udim2

        C1.Position = udim2(1, -26, 0.5, 0)
        C1.Size = x(0, 18)
        C1.AutomaticSize = t
        C1.FontFace = font6
        C1.TextSize = 11
        C1.TextColor3 = color3FromRGB(226, 229, 255)
        C1.BackgroundTransparency = 0.72
        C1.BackgroundColor3 = L.a1
        C1.TextXAlignment = center

        _VX.setList(C1, 0, D1(), H1(0, 6))

        local P, V1 = textLabel(C1), {
            Options = N,
            Multi = text,
        }
        local N = target.W

        V1.Set = function(C1, W1, h1)
            V1.Value = text and (type(W1) == 'table' and W1 or {W1}) or W1
            W1 = text and type(V1.Options) == 'table' and V1.Options

            if W1 then
                local M1 = {}

                for index, d1 in ipairs(W1)do
                    M1[type(d1) == 'table' and d1.v or d1] = index
                end

                V1.Value = table.clone(V1.Value)

                table.sort(V1.Value, function(key, d1)
                    return (M1[key] or 1000000000) < (M1[d1] or 1000000000)
                end)
            end

            W1 = text and #V1.Value or 0

            r1:SetAttribute('alt', W1 > 1 and V1.Value[1] .. '...' or nil)

            r1.Text = text and (W1 == 0 and 'None' or tostring(V1.Value[1])) or tostring(V1.Value or 'None')
            P.Text = '+' .. W1 - 1
            P.Visible = W1 > 1
            C1 = ctx.udim2
            r1.Size = C1(1, W1 > 1 and -70 or -34, 1, 0)
            r1.TextTransparency = 0.6

            k1(r1, {TextTransparency = 0}, 0.3)
            N:Sync(V1)

            if not h1 then
                w1(O, V1.Value)
            end
        end
        V1.Refresh = function(N, N)
            V1.Options = N
        end

        v1(K, function()
            local N = type(V1.Options) == 'function' and V1.Options() or V1.Options

            target.W:Pick(F, N, V1.Value, text, function(N)
                V1:Set(N)
            end, V1.Default, V1)
        end)

        V1.Default = text and table.clone(S or {}) or nil
        I1 = text and (S or {})

        V1:Set(I1 or S, true)

        return target:Reg(F, V1)
    end
    R1.Input = function(target, F, N, S, O)
        local E, udim2 = target:Row(F, O, 176)
        local O, K, udim22 = J1(0.87), {
            Parent = udim2,
            AnchorPoint = vector2New(0, 0.5),
        }, ctx.udim2

        K.Position = udim22(0, 0, 0.5, 0)
        udim2 = ctx.udim2
        K.Size = udim2(1, 0, 0, 26)
        K.BackgroundTransparency = 0.8
        K.BackgroundColor3 = color3FromRGB(0, 0, 0)
        K.PlaceholderText = N or ''
        K.TextSize = 13
        K.TextTruncate = atEnd
        udim22 = ctx.Enum
        K.TextXAlignment = udim22.TextXAlignment.Left
        K.ClipsDescendants = true

        _VX.setList(K, 0, D1(10), H1(0, 10), O)

        local N, P = textBox(K), {
            Value = '',
            ls = {},
            Kind = 'input',
        }

        P.Set = function(X, X, K)
            P.Value = tostring(X or '')
            N.Text = P.Value

            for index, value in ipairs(P.ls)do
                value(P.Value)
            end

            if not K then
                w1(S, P.Value)
            end
        end

        target:Hold(E, P)
        L1(N, O, 0.5, 0.87, function()
            P:Set(N.Text)
        end)
        v1(E, function()
            N:CaptureFocus()
        end)

        return target:Reg(F, P)
    end
    R1.Key = function(target, F, N, S, O, E)
        local P, X = target:Row(F, E, 60)
        local E = J1(0.82)
        local K, newInstance = {
            Parent = X,
            AnchorPoint = R,
            Position = b,
            Size = x(0, 26),
            AutomaticSize = t,
            FontFace = font4,
            TextXAlignment = center,
            BackgroundTransparency = 0.92,
        }, ctx.newInstance

        _VX.setList(K, 0, D1(9), H1(0, 12), E, newInstance('UISizeConstraint', {
            MinSize = vector2New(36, 26),
        }))

        local X, r1, C1 = textLabel(K), {}

        r1.Set = function(key, V1, W1)
            r1.Value = V1
            key = V1 and V1.Name or 'None'
            X.Text = Q[key] or key

            k1(E, {
                Transparency = 0.82,
                Color = L.wh,
            }, 0.2)

            if not W1 then
                w1(O, V1)
            end
        end

        v1(P, function()
            local venyx = ctx.Venyx

            C1 = true
            venyx.kw = true
            X.Text = '...'

            k1(E, {
                Transparency = 0.4,
                Color = L.a1,
            }, 0.2)
        end)
        G(UserInputService.InputBegan, function(Q, O)
            local C14, P = C1

            if C14 then
                local enum

                enum, P = ctx.Enum, Q.UserInputType == ctx.Enum.UserInputType.Keyboard
            else
                P = C14
            end
            if P then
                C1 = false

                task.defer(function()
                    local venyx = ctx.Venyx

                    venyx.kw = nil
                end)
                r1:Set(Q.KeyCode ~= ctx.Enum.KeyCode.Escape and Q.KeyCode or nil)
            elseif O then
            elseif r1.Value then
                if Q.KeyCode == r1.Value then
                    w1(S)
                end
            end
        end)
        r1:Set(N, true)

        return target:Reg(F, r1)
    end
    R1.Button = function(target, name, text, N, callback, label)
        local E, P, X = ({
            danger = L.red,
            gold = L.gold,
            mint = L.mint,
            pink = L.pink,
        })[callback] or L.sky, target:Row(name, label, 110)
        local K = textLabel({
            Parent = X,
            AnchorPoint = R,
            Position = b,
            Size = x(0, 26),
            AutomaticSize = t,
            Text = text or 'Run',
            FontFace = font6,
            TextSize = 13,
            TextTransparency = 1,
            H1(0, 14),
        })

        label, callback = {
            Parent = K,
            AnchorPoint = T,
            Position = Z,
        }, ctx.udim2
        label.Size = callback(1, 28, 1, 0)
        label.Text = K.Text
        label.FontFace = font6
        label.TextSize = 13
        label.TextColor3 = E:Lerp(L.wh, 0.55)
        label.TextXAlignment = center
        label.BackgroundTransparency = 0.85
        label.BackgroundColor3 = E

        _VX.setList(label, 0, D1(10), J1(0.5, E))

        local b = textLabel(label)

        n1(b, 0.93, P, function(bgAlpha)
            k1(b, {
                BackgroundTransparency = bgAlpha and 0.7 or 0.85,
            }, 0.2)
        end)
        v1(P, function()
            w1(N)
        end)

        label, text = {
            Kind = 'button',
            Skip = true,
            Text = K.Text,
            Col = E,
            Name = name,
            Key = target.t.Name .. '/' .. target.name .. '/' .. name,
            Fire = function()
                w1(N)
            end,
            Set = function(F, text)
                K.Text = text
                b.Text = text
                F.Text = text
            end,
        }, ctx.Venyx
        text.Keys[label.Key] = label

        target:Hold(P, label)

        return label
    end
    R1.Stats = function(parent, F, callback)
        local createFrame = ctx.createFrame
        local frame, createFrame2 = createFrame({
            Parent = parent.f,
            Size = f,
            AutomaticSize = g,
            LayoutOrder = parent.n + 1,
        }), ctx.createFrame
        local O, E, newInstance, X, K, frame2 = {
            Parent = frame,
            Size = f,
            AutomaticSize = g,
        }, H1(8, 14, 10), ctx.newInstance, {}, callback == 1

        if K then
            createFrame = ctx.udim2
            frame2 = (createFrame(1, 0, 0, 40))
        else
            frame2 = K
        end

        createFrame = nil

        if frame2 then
            createFrame = frame2
        else
            callback = ctx.udim2
            createFrame = (callback(0.5, -6, 0, 40))
        end

        X.CellSize = createFrame
        X.CellPadding = x(12, 6)
        callback = ctx.Enum
        X.SortOrder = callback.SortOrder.LayoutOrder

        _VX.setList(O, 0, E, newInstance('UIGridLayout', X))

        E = createFrame2(O)

        parent:Add(frame, '')

        frame, callback = {}, ipairs

        for K, C1 in callback(F)do
            newInstance = type(C1) == 'table' and C1[2]
            C1 = type(C1) == 'table' and C1[1] or C1
            parent, createFrame = newInstance and 40 or 10, ctx.createFrame
            createFrame2 = createFrame({
                Parent = E,
                LayoutOrder = K,
                BackgroundTransparency = 0.95,
                D1(10),
            })

            if newInstance then
                K, X = {
                    Parent = createFrame2,
                    Position = x(8, 7),
                    Size = x(26, 26),
                    Image = newInstance,
                }, ctx.Enum
                K.ScaleType = X.ScaleType.Fit
                K.ImageColor3 = B[newInstance] and L.a1 or nil

                e(K)
            end

            O, K = {
                Parent = createFrame2,
                Position = x(parent, 4),
            }, ctx.udim2
            O.Size = K(1, -parent - 8, 0, 14)
            O.Text = C1:upper()
            O.FontFace = font5
            O.TextSize = 9.5
            O.TextTransparency = 0.38

            textLabel(O)

            K, frame2 = {
                Parent = createFrame2,
                Position = x(parent, 19),
            }, ctx.udim2
            K.Size = frame2(1, -parent - 8, 0, 17)
            K.Text = '--'
            K.FontFace = font4
            K.TextSize = 13
            K.TextTruncate = atEnd
            frame[C1] = textLabel(K)
        end

        return _1(frame)
    end
    R1.List = function(parent, F, text, b)
        local N, createFrame = b and 48 or 64, ctx.createFrame
        local O, udim2 = {
            Parent = parent.f,
            LayoutOrder = parent.n + 1,
        }, ctx.udim2

        O.Size = udim2(1, 0, 0, F * N + 12)

        local frame = createFrame(O)

        parent:Add(frame, '')

        O, udim2 = {
            Parent = frame,
            Position = x(10, 6),
        }, ctx.udim2
        O.Size = udim2(1, -20, 1, -12)
        createFrame = ctx.listLayout

        _VX.setList(O, 0, createFrame(6))

        local S = scrollingFrame(O)

        parent.W.nest[S] = parent.t.top or parent.t

        local H, O, E, id = textLabel({
            Parent = frame,
            Size = _,
            Text = text or 'Nothing here',
            TextSize = 12,
            TextTransparency = 0.45,
            TextXAlignment = center,
        }), {}, {}

        local function updateBackgroundAlpha(K)
            local r1 = K.it and K.it.id == id

            K.s.Color = r1 and L.a1 or L.wh
            K.s.Transparency = r1 and 0.3 or 0.9
            K.r.BackgroundTransparency = r1 and 0.9 or 0.955
        end
        local function applyTextStyle()
            local r1 = {}

            r1.s = J1(0.9)

            local C1, udim2 = {Parent = S}, ctx.udim2

            C1.Size = udim2(1, -6, 0, N - 6)
            C1.BackgroundTransparency = 0.955

            _VX.setList(C1, 0, D1(15), r1.s)

            r1.r = textButton(C1)
            udim2, C1 = b and 30 or 42, ctx.createFrame
            r1.box = C1({
                Parent = r1.r,
                Position = x(8, b and 6 or 8),
                Size = x(udim2, udim2),
                BackgroundTransparency = 0.8,
                D1(b and 10 or 13),
            })

            local S, W1 = {
                Parent = r1.box,
                AnchorPoint = T,
                Position = Z,
                Size = x(udim2 - 4, udim2 - 4),
            }, ctx.Enum

            S.ScaleType = W1.ScaleType.Fit
            r1.im = imageLabel(S)
            C1, W1, S = ctx.createFrame, {
                Parent = r1.r,
                Position = x(udim2 + 18, b and 4 or 5),
            }, ctx.udim2
            W1.Size = S(1, -152, 0, 18)
            S = ctx.listLayout

            _VX.setList(W1, 0, S(8, nil, center2, horizontal))

            S = C1(W1)
            r1.a = textLabel({
                Parent = S,
                Size = x(0, 18),
                AutomaticSize = t,
                FontFace = font6,
                TextSize = 13.5,
            })
            r1.pr = textLabel({
                Parent = S,
                LayoutOrder = 1,
                Size = x(0, 18),
                AutomaticSize = t,
                FontFace = font4,
                TextSize = 12.5,
                TextColor3 = L.gv,
            })

            local I1, h1, M1 = ctx.createFrame, {
                Parent = r1.r,
                Position = x(udim2 + 18, b and 23 or 24),
            }, ctx.udim2

            h1.Size = M1(1, -152, 0, 13)
            udim2 = ctx.listLayout

            _VX.setList(h1, 0, udim2(8, nil, center2, horizontal))

            W1 = I1(h1)
            r1.rar = textLabel({
                Parent = W1,
                Size = x(0, 13),
                AutomaticSize = t,
                FontFace = font5,
                TextSize = 9.5,
            })
            r1.l1 = S
            r1.l2 = W1
            h1, I1 = {
                Parent = r1.r,
                AnchorPoint = vector2New(1, 0),
            }, ctx.udim2
            h1.Position = I1(1, -10, 0, 5)
            h1.Size = x(0, 12)
            h1.AutomaticSize = t
            h1.FontFace = font5
            h1.TextSize = 9
            h1.TextColor3 = L.a1
            h1.Text = ''
            r1.bd = textLabel(h1)
            r1.tg = textLabel({
                Parent = W1,
                LayoutOrder = 1,
                Size = x(0, 13),
                AutomaticSize = t,
                FontFace = font6,
                TextSize = 9.5,
                TextColor3 = color3FromRGB(201, 194, 255),
            })
            udim2, W1, h1 = ctx.createFrame, {
                Parent = r1.r,
                Position = x(60, 39),
            }, ctx.udim2
            W1.Size = h1(1, -152, 0, 15)
            W1.Visible = not b
            C1 = ctx.listLayout

            _VX.setList(W1, 0, C1(8, nil, center2, horizontal))

            h1 = udim2(W1)
            r1.v = textLabel({
                Parent = h1,
                Size = x(0, 15),
                AutomaticSize = t,
                FontFace = font4,
                TextSize = 12,
                TextColor3 = L.gv,
            })
            r1.b = textLabel({
                Parent = h1,
                LayoutOrder = 1,
                Size = x(0, 15),
                AutomaticSize = t,
                TextSize = 11,
                TextTransparency = 0.3,
            })
            h1, I1 = {
                Parent = r1.r,
                AnchorPoint = R,
            }, ctx.udim2
            h1.Position = I1(1, -10, 0.5, 0)
            h1.Size = x(78, 32)
            h1.BackgroundTransparency = 0

            _VX.setList(h1, 0, D1(11), U1(L.g1, L.g2), textLabel({
                Size = _,
                FontFace = font6,
                TextSize = 12,
                TextColor3 = L.dk,
                TextXAlignment = center,
            }))

            r1.k = textButton(h1)
            r1.kl = r1.k:FindFirstChildOfClass('TextLabel')

            n1(r1.k)
            v1(r1.k, function()
                if r1.it then
                    if r1.it.act then
                        w1(r1.it.act, r1.it)
                    end
                end
            end)
            v1(r1.r, function()
                if not r1.it then
                    return
                end

                id = r1.it.id

                for key, value in next, O do
                    updateBackgroundAlpha(value)
                end

                w1(r1.it.pick, r1.it)
            end)

            return r1
        end

        E.Set = function(callback, S, text)
            H.Visible = #S == 0

            if text then
                H.Text = text
            end

            callback = ctx.udim2
            frame.Size = callback(1, 0, 0, #S == 0 and 34 or math.min(#S, F) * N + 12)
            text, callback = {}, ipairs

            for H, F in callback(S)do
                local b = O[F.id] or applyTextStyle()

                O[F.id], text[F.id] = b, true
                b.it = F
                b.r.LayoutOrder = H

                local N, S = {
                    a = F.title,
                    pr = F.price or F.count,
                    rar = F.rarity,
                    tg = F.tags,
                    v = F.value,
                    b = F.sub,
                    kl = F.button,
                }, {
                    'a',
                    'pr',
                    'rar',
                    'tg',
                    'v',
                    'b',
                    'kl',
                }

                for index, value in ipairs(S)do
                    H = N[value] or ''

                    if b[value].Text ~= H then
                        b[value].Text = H
                    end
                end

                b.k.Visible = F.button ~= nil
                b.rar.Parent, b.rar.LayoutOrder, b.pr.Parent, b.pr.LayoutOrder = F.top and b.l1 or b.l2, F.top and 2 or 0, F.top and b.l2 or b.l1, F.top and 0 or 1

                if b.bd.Text ~= (F.badge or '') then
                    b.bd.Text = F.badge or ''
                end
                if not F.top then
                    b.pr.TextColor3, b.pr.TextSize = F.count and color3FromRGB(201, 194, 255) or L.gv, F.count and 13.5 or 12.5
                end
                if F.top and not b.fx then
                    b.fx = true
                    S = nil
                    S, b.pr.FontFace, b.pr.TextSize, b.pr.TextColor3, b.pr.Size, b.l2.Size = ctx.udim2, font2, 15, L.wh, x(0, 17), ctx.udim2(1, 
-152, 0, 17)
                    b.rar.FontFace, b.rar.TextSize = font3, 13.5
                    H = ctx.newInstance

                    H('UIGradient', {
                        Parent = b.pr,
                        Color = colorSequence,
                        Rotation = 90,
                    })

                    local ipairsFn, S = ipairs, {
                        b.pr,
                        b.rar,
                    }

                    for P, K in ipairsFn(S)do
                        P = ctx.newInstance

                        P('UIStroke', {
                            Parent = K,
                            Thickness = 1.6,
                            Color = color3FromRGB(0, 0, 0),
                            Transparency = 0.05,
                        })
                    end
                end
                if b.g ~= F.grad then
                    N = b.rar:FindFirstChildOfClass('UIGradient')

                    if N then
                        N:Destroy()
                    end

                    b.g = F.grad

                    if F.grad then
                        F.grad:Clone().Parent = b.rar
                    end
                end

                b.rar.TextColor3 = F.grad and L.wh or F.color or L.val
                b.box.BackgroundColor3 = F.color or L.a1

                if b.im.Image ~= (F.image or '') then
                    b.im.Image = F.image or ''
                end

                updateBackgroundAlpha(b)
            end
            for key, value in next, O do
                if not (text[key]) then
                    value.r:Destroy()

                    O[key] = nil
                end
            end
        end
        E.Select = function(H, H)
            id = H

            for key, value in next, O do
                updateBackgroundAlpha(value)
            end
        end

        return E
    end

    local function H(parent, Q)
        local uIGradient = parent:FindFirstChildOfClass('UIGradient')

        if uIGradient then
            uIGradient:Destroy()
        end
        if Q then
            Q:Clone().Parent = parent
        end
    end
    local function applyTextStyle(label)
        label.FontFace, label.TextColor3 = font3, label.TextColor3 or L.wh
        label.TextTruncate = atEnd

        local M, newInstance = textLabel(label), ctx.newInstance

        newInstance('UIStroke', {
            Parent = M,
            Thickness = math.max(1.2, label.TextSize / 8),
            Color = color3FromRGB(0, 0, 0),
            Transparency = 0.05,
        })

        return M
    end

    local new, Q = ColorSequenceKeypoint.new, {}

    Q.COMMON = {
        color3FromRGB(30, 34, 42),
        color3FromRGB(104, 114, 132),
        color3FromRGB(214, 222, 236),
    }
    Q.UNCOMMON = {
        color3FromRGB(6, 44, 22),
        color3FromRGB(36, 168, 84),
        color3FromRGB(160, 255, 170),
    }
    Q.RARE = {
        color3FromRGB(6, 24, 78),
        color3FromRGB(36, 112, 255),
        color3FromRGB(140, 205, 255),
    }
    Q.EPIC = {
        color3FromRGB(34, 8, 74),
        color3FromRGB(146, 56, 255),
        color3FromRGB(220, 170, 255),
    }
    Q.LEGENDARY = {
        color3FromRGB(74, 30, 0),
        color3FromRGB(255, 146, 18),
        color3FromRGB(255, 228, 130),
    }
    Q.MYTHIC = {
        color3FromRGB(72, 0, 22),
        color3FromRGB(255, 38, 88),
        color3FromRGB(255, 168, 190),
    }
    Q.COSMIC = {
        color3FromRGB(22, 0, 40),
        color3FromRGB(128, 0, 154),
        color3FromRGB(236, 150, 255),
        color3FromRGB(92, 0, 190),
    }
    Q.SECRET = {
        color3FromRGB(0, 0, 0),
        color3FromRGB(52, 52, 64),
        color3FromRGB(255, 255, 255),
        stars = true,
    }
    Q.ETERNAL = {
        color3FromRGB(4, 20, 56),
        color3FromRGB(30, 196, 220),
        color3FromRGB(255, 160, 255),
        color3FromRGB(196, 80, 255),
        shine = true,
    }
    Q.DIVINE = {
        color3FromRGB(84, 54, 0),
        color3FromRGB(255, 196, 50),
        color3FromRGB(255, 252, 220),
        color3FromRGB(255, 236, 150),
        shine = true,
        star = color3FromRGB(255, 255, 255),
        rays = true,
    }

    local function o(b)
        local N, S, O = b.color or L.a1, Q[b.rarity]

        if S then
            O = S
        else
            local Q, b, wh = {}, N:Lerp(color3FromRGB(0, 0, 0), 0.75), L.wh

            _VX.setList(Q, 0, b, N, N:Lerp(wh, 0.6))

            O = Q
        end

        return O
    end
    local function setFramesAlpha(parent, N, callback, O)
        N.Parent = parent
        N.ClipsDescendants = true
        parent = frame(N)
        N = {
            f = parent,
            g = U1(L.wh, L.wh, 120),
            h = {},
            st = {},
            ss = {},
            sh = a1(30, {0, 1}, {0.4, 1}, {0.5, 0.55}, {0.6, 1}, {1, 1}),
        }
        D1(callback).Parent, N.g.Parent = parent, parent

        for index, value in ipairs(O)do
            local X, K = N.h, {
                Parent = parent,
                AnchorPoint = T,
                Position = Z,
                Size = x(value, value),
            }

            K.BackgroundTransparency = 0.96 - index * 0.1

            _VX.setList(K, 0, D1())

            X[index] = frame(K)
        end

        local ipairsFn, P = ipairs, {
            {0.13, 0.28, 13},
            {0.87, 0.2, 10},
            {0.84, 0.72, 12},
        }

        for X, K in ipairsFn(P)do
            local E, ss, r1, C1 = x(K[3] * O[1] / 95, K[3] * O[1] / 95), N.ss, {
                Parent = parent,
                AnchorPoint = T,
            }, ctx.udim2

            r1.Position = C1(K[1], 1.5, K[2], 1.5)
            r1.Size = E
            r1.Image = 'sparkles'
            r1.ImageColor3 = color3FromRGB(90, 50, 0)
            r1.ZIndex = 2
            ss[X] = e(r1)
            r1, ss, callback = N.st, {
                Parent = parent,
                AnchorPoint = T,
            }, ctx.udim2
            ss.Position = callback(K[1], 0, K[2], 0)
            ss.Size = E
            ss.Image = 'sparkles'
            ss.ZIndex = 2
            r1[X] = e(ss)
        end

        P = ctx.createFrame
        N.sf = P({
            Parent = parent,
            Size = _,
            BackgroundColor3 = L.wh,
            BackgroundTransparency = 0,
            ZIndex = 4,
            N.sh,
        })

        return N
    end
    local function setFramesAlpha2(parent, bgColor)
        parent.g.Color = ColorSequence.new({
            new(0, bgColor[2]),
            new(0.5, bgColor[4] or bgColor[1]:Lerp(bgColor[2], 0.4)),
            new(1, bgColor[1]),
        })

        for index, value in ipairs(parent.h)do
            value.BackgroundColor3 = bgColor[3]
        end

        if bgColor.rays then
            if not parent.ry then
                local O, udim2 = {
                    Parent = parent.f,
                    AnchorPoint = T,
                    Position = Z,
                }, ctx.udim2

                O.Size = udim2(1.5, 0, 1.5, 0)
                udim2 = ctx.Enum
                O.SizeConstraint = udim2.SizeConstraint.RelativeXX
                O.Image = 'rbxassetid://109516122757226'
                O.ImageColor3 = color3FromRGB(255, 250, 215)
                O.ImageTransparency = 0.3
                udim2 = ctx.Enum
                O.ScaleType = udim2.ScaleType.Fit
                parent.ry = imageLabel(O)
            end
        end
        if parent.ry then
            parent.ry.Visible = bgColor.rays == true
        end

        parent.sf.Visible = parent.live and bgColor.shine == true

        for index, value in ipairs(parent.st)do
            value.Visible, value.ImageColor3 = bgColor.shine or bgColor.stars or false, bgColor.star or bgColor[3]
            value.ImageTransparency = 0.15
            parent.ss[index].Visible, parent.ss[index].ImageTransparency = value.Visible and bgColor.star ~= nil, 0.55
        end
        for index, value in ipairs(parent.tw or {})do
            value:Cancel()
        end

        parent.tw = {}

        if parent.live then
            if not bgColor.shine then
                if not bgColor.rays then
                    return
                end
            end
        else
            return
        end

        local function O(E, P, X, enabled, a1)
            local tweenInfoNew, C1 = TweenInfo.new

            if enabled then
                local enum = ctx.Enum

                C1 = enum.EasingStyle.Sine
            else
                C1 = enabled
            end

            local C15

            if C1 then
                C15 = C1
            else
                local W1 = ctx.Enum

                C15 = W1.EasingStyle.Linear
            end

            C1 = ctx.Enum

            local W1 = TweenService:Create(E, tweenInfoNew(P, C15, C1.EasingDirection.InOut, -1, enabled == true, a1 or 0), X)

            W1:Play()

            parent.tw[#parent.tw + 1] = W1
        end

        parent.h[#parent.h].BackgroundTransparency = 0.82

        O(parent.h[#parent.h], 1.3, {BackgroundTransparency = 0.62}, true)

        if bgColor.rays then
            parent.ry.Rotation = 0

            O(parent.ry, 30, {Rotation = 360})
        end
        if bgColor.shine then
            parent.sh.Offset = vector2New(-1, 0)

            O(parent.sh, 1.2, {
                Offset = vector2New(1, 0),
            }, false, 2.2)

            for index, value in ipairs(parent.st)do
                value.ImageTransparency, parent.ss[index].ImageTransparency = 0.4, 0.95

                O(value, 0.9 + index * 0.25, {ImageTransparency = 0}, true)
                O(parent.ss[index], 0.9 + index * 0.25, {ImageTransparency = 0.55}, true)
            end
        end
    end
    local function r(parent)
        parent.FontFace = font2

        local newInstance = ctx.newInstance

        newInstance('UIGradient', {
            Parent = parent,
            Color = colorSequence,
            Rotation = 90,
        })

        return parent
    end
    local function A(d, N, S)
        return ColorSequence.new({
            new(0, d),
            new(0.5, N),
            new(1, S),
        })
    end

    local d = {}

    d.GOLDEN = A(color3FromRGB(255, 250, 190), color3FromRGB(255, 204, 40), color3FromRGB(255, 140, 0))
    d.SILVER = A(color3FromRGB(255, 255, 255), color3FromRGB(196, 214, 246), color3FromRGB(120, 146, 196))
    d.RAINBOW = ColorSequence.new({
        new(0, color3FromRGB(255, 70, 70)),
        new(0.25, color3FromRGB(255, 220, 60)),
        new(0.5, color3FromRGB(80, 255, 110)),
        new(0.75, color3FromRGB(80, 170, 255)),
        new(1, color3FromRGB(220, 90, 255)),
    })
    d.NITRO = A(color3FromRGB(255, 244, 130), color3FromRGB(255, 150, 30), color3FromRGB(255, 60, 20))
    d.SCRAMBLED = A(color3FromRGB(240, 205, 255), color3FromRGB(186, 110, 255), color3FromRGB(130, 50, 240))
    d.FRACTURED = A(color3FromRGB(255, 196, 186), color3FromRGB(255, 84, 84), color3FromRGB(200, 20, 40))
    d.ENCHANTED = A(color3FromRGB(210, 255, 255), color3FromRGB(80, 225, 255), color3FromRGB(30, 150, 255))
    d.BLOOM = A(color3FromRGB(255, 228, 244), color3FromRGB(255, 140, 210), color3FromRGB(240, 70, 160))
    d['SPIRIT BLOOM'] = A(color3FromRGB(230, 255, 210), color3FromRGB(130, 245, 130), color3FromRGB(40, 190, 90))
    d.PARASITE = A(color3FromRGB(236, 255, 180), color3FromRGB(150, 240, 70), color3FromRGB(70, 180, 30))

    local function N(rotation)
        local O, newInstance = rotation.c or L.a1, ctx.newInstance

        return newInstance('UIGradient', {
            Color = d[rotation.n:gsub('^%+', '')] or A(O:Lerp(L.wh, 0.6), O, O:Lerp(color3FromRGB(0, 0, 0), 0.25)),
            Rotation = rotation.n == 'RAINBOW' and 0 or 90,
        })
    end
    local function A(parent, S, O, textSize)
        for index, child in ipairs(parent:GetChildren())do
            if child:IsA('GuiObject') then
                child:Destroy()
            end
        end
        for index, value in ipairs(S or {})do
            local S = applyTextStyle({
                Parent = parent,
                LayoutOrder = index,
                Size = x(0, O),
                AutomaticSize = t,
                TextSize = textSize,
                Text = value.n,
            })

            S:FindFirstChildOfClass('UIStroke').Thickness = textSize / 5
            N(value).Parent = S
        end
    end
    local function d(N, key)
        local O = B[key]

        N.ImageRectOffset = vector2New(O % 8 * 64, O // 8 * 64)
    end
    local function N(callback, B, O, E, layoutOrder)
        local createFrame, K, udim2 = ctx.createFrame, {
            Parent = callback,
            LayoutOrder = layoutOrder,
        }, ctx.udim2

        K.Size = udim2(1, 0, 0, O)
        udim2, layoutOrder, callback = ctx.newInstance, {}, ctx.udim2
        layoutOrder.CellSize = callback(1 / B, -E * (B - 1) / B - 1, 0, O)
        layoutOrder.CellPadding = x(E, E)
        O = ctx.Enum
        layoutOrder.SortOrder = O.SortOrder.LayoutOrder

        _VX.setList(K, 0, udim2('UIGridLayout', layoutOrder))

        return createFrame(K)
    end
    local function S(parent, textSize)
        local createFrame = ctx.createFrame
        local frame = createFrame({
            Parent = parent,
            Size = x(0, textSize + 8),
            AutomaticSize = t,
            BackgroundTransparency = 0.05,
            D1(),
            J1(0.2),
            H1(0, 9),
        })

        return frame, applyTextStyle({
            Parent = frame,
            Size = x(0, textSize + 8),
            AutomaticSize = t,
            TextSize = textSize,
            TextXAlignment = center,
        })
    end
    local function B(instance, label, bgColor, text)
        instance.BackgroundColor3 = bgColor[1]
        instance:FindFirstChildOfClass('UIStroke').Color = bgColor[2]
        label.Text = text.rarity or ''

        H(label, text.grad)

        label.TextColor3 = text.grad and L.wh or text.color or L.tx
    end
    local function O(E, P)
        local keypoints = E.Keypoints

        for E = 2, #keypoints, 1 do
            if P <= keypoints[E].Time then
                local value, value2, r1 = keypoints[E - 1].Value, keypoints[E].Value, (P - keypoints[E - 1].Time) / math.max(keypoints[E].Time - keypoints[E - 1].Time, 1E-4)

                return value:Lerp(value2, r1)
            end
        end

        return keypoints[#keypoints].Value
    end

    local E = {}

    local function P(X, callback)
        local a1 = (callback.rarity == 'ETERNAL' or callback.rarity == 'DIVINE') and callback.grad

        if a1 then
            if math.abs(a1.Rotation) == 90 then
                if not (E[a1]) then
                    local r1, C1, V1 = a1.Rotation < 0 and 0.53 or 0, a1.Rotation < 0 and 1 or 0.5, {}

                    for W1 = 0, 8, 1 do
                        V1[#V1 + 1] = new(W1 / 8, O(a1.Color, r1 + (C1 - r1) * W1 / 8))
                    end

                    callback = ctx.newInstance
                    E[a1] = callback('UIGradient', {
                        Color = ColorSequence.new(V1),
                        Rotation = a1.Rotation,
                    })
                end

                a1 = E[a1]
            end
        end

        H(X, a1 or nil)
    end

    R1.Showcase = function(callback, M, O, E, X)
        local K, a1, r1 = callback.t.top or callback.t, callback.W, 364
        local C1, createFrame = J1(0.5), ctx.createFrame
        local W1 = createFrame({
            Parent = callback.f,
            LayoutOrder = callback.n + 1,
            Size = f,
            AutomaticSize = g,
        })

        callback:Add(W1, '')

        local I1, h1, M1 = ctx.createFrame, {
            Parent = W1,
            Size = f,
            AutomaticSize = g,
        }, ctx.listLayout

        _VX.setList(h1, 0, H1(2, 14, 6), M1(8))

        M1, createFrame = I1(h1), ctx.createFrame
        I1, callback = {Parent = M1}, ctx.udim2
        I1.Size = callback(1, 0, 0, 30)

        local frame3, d1, L1, listLayout = createFrame(I1), ctx.createFrame, {
            Parent = M1,
            LayoutOrder = 1,
            Size = f,
            AutomaticSize = g,
        }, ctx.listLayout

        _VX.setList(L1, 0, listLayout(14, nil, nil, horizontal))

        callback, listLayout, W1, h1 = d1(L1), ctx.createFrame, {}, ctx.createFrame
        W1.Parent = h1({
            Parent = callback,
            Size = x(250, 370),
            H1(3, 0),
        })
        W1.Size = _
        W1.BackgroundTransparency = 0.45
        L1 = ctx.listLayout

        _VX.setList(W1, 0, D1(20), C1, H1(9), L1(6, center3))

        local F1, Q1, _1, T1 = listLayout(W1), {}, {}, ctx.udim2

        _1.Size = T1(1, 0, 0, 145)
        Q1.a = setFramesAlpha(F1, _1, 14, {170, 126, 84})
        Q1.a.live = true
        L1, d1 = {
            Parent = Q1.a.f,
            AnchorPoint = T,
        }, ctx.udim2
        L1.Position = d1(0.5, 0, 0.5, 2)
        L1.Size = x(138, 138)
        W1 = ctx.Enum
        L1.ScaleType = W1.ScaleType.Fit
        L1.ZIndex = 3
        Q1.im = imageLabel(L1)
        h1, M1, T1 = ctx.createFrame, {
            Parent = Q1.a.f,
        }, ctx.topRight
        M1.AnchorPoint = T1
        _1 = ctx.udim2
        M1.Position = _1(1, -8, 0, 7)
        M1.Size = x(0, 0)
        d1 = ctx.Enum
        M1.AutomaticSize = d1.AutomaticSize.XY
        M1.ZIndex = 5
        T1, d1 = ctx.listLayout, ctx.Enum

        _VX.setList(M1, 0, T1(2, d1.HorizontalAlignment.Right))

        Q1.mu = h1(M1)
        L1, h1 = {
            Parent = F1,
            LayoutOrder = 1,
        }, ctx.udim2
        L1.Size = h1(1, 0, 0, 24)
        L1.Text = 'Pick an egg'
        L1.TextSize = 21
        L1.TextXAlignment = center
        Q1.ti = applyTextStyle(L1)
        Q1.rb, Q1.ra = S(F1, 13)
        Q1.rb.LayoutOrder = 2
        W1, M1 = {
            Parent = F1,
            LayoutOrder = 3,
        }, ctx.udim2
        W1.Size = M1(1, 0, 0, 30)
        W1.TextSize = 26
        W1.TextXAlignment = center
        Q1.va = r(applyTextStyle(W1))

        local p1, m1, c1, g1 = N(F1, 2, 34, 6, 4), {}, ipairs, {
            {
                'gauge',
                'Size',
            },
            {
                'gem',
                'Weight',
            },
        }

        for t1, o1 in c1(g1)do
            createFrame = ctx.createFrame
            listLayout = createFrame({
                Parent = p1,
                LayoutOrder = t1,
                BackgroundTransparency = 0.55,
                BackgroundColor3 = color3FromRGB(0, 0, 0),
                D1(10),
            })
            h1, M1 = {
                Parent = listLayout,
                AnchorPoint = vector2New(0, 0.5),
            }, ctx.udim2
            h1.Position = M1(0, 8, 0.5, 0)
            h1.Size = x(15, 15)
            h1.Image = o1[1]

            e(h1)

            d1, T1 = {
                Parent = listLayout,
                Position = x(29, 3),
            }, ctx.udim2
            d1.Size = T1(1, -34, 0, 16)
            d1.TextSize = 13
            m1[t1] = applyTextStyle(d1)
            _1, L1 = {
                Parent = listLayout,
                Position = x(29, 19),
            }, ctx.udim2
            _1.Size = L1(1, -34, 0, 11)
            _1.Text = o1[2]:upper()
            _1.FontFace = font5
            _1.TextSize = 8
            _1.TextTransparency = 0.45

            textLabel(_1)
        end

        p1, I1, _1 = ctx.createFrame, {
            Parent = F1,
            LayoutOrder = 5,
        }, ctx.udim2
        I1.Size = _1(1, 0, 0, 22)
        I1.BackgroundTransparency = 0.55
        I1.BackgroundColor3 = color3FromRGB(0, 0, 0)
        I1.ClipsDescendants = true

        _VX.setList(I1, 0, D1(8))

        g1 = p1(I1)
        p1, c1 = {
            Parent = g1,
            AnchorPoint = vector2New(0, 0.5),
        }, ctx.udim2
        p1.Position = c1(0, 8, 0.5, 0)
        p1.Size = x(14, 14)
        p1.Image = 'clock'
        Q1.si = e(p1)
        I1, T1 = {
            Parent = g1,
            Position = x(28, 0),
        }, ctx.udim2
        I1.Size = T1(1, -36, 1, 0)
        I1.TextSize = 11
        m1[3] = applyTextStyle(I1)
        h1, _1 = {
            Parent = g1,
            AnchorPoint = vector2New(0, 1),
        }, ctx.udim2
        h1.Position = _1(0, 0, 1, 0)
        c1 = ctx.udim2
        h1.Size = c1(0, 0, 0, 3)
        Q1.bf = frame(h1)
        L1, g1, p1, _1 = {}, ctx.createFrame, {
            Parent = F1,
            LayoutOrder = 6,
        }, ctx.udim2
        p1.Size = _1(1, 0, 0, 34)
        L1.Parent = g1(p1)
        L1.Size = _
        L1.BackgroundTransparency = 0
        I1, createFrame, W1, T1, _1 = D1(12), U1(L.a1, L.a2, 90), L.a1, L.wh, ctx.listLayout

        _VX.setList(L1, 0, I1, createFrame, J1(0.55, W1:Lerp(T1, 0.5)), _1(7, center3, center2, horizontal))

        local I1 = textButton(L1)
        local L1 = e({
            Parent = I1,
            Size = x(17, 17),
            Image = 'hand',
            ImageColor3 = L.on,
        })
        local t1 = textLabel({
            Parent = I1,
            LayoutOrder = 1,
            Size = x(0, 34),
            AutomaticSize = t,
            FontFace = font6,
            TextSize = 15,
            TextColor3 = L.on,
        })

        n1(I1)

        local o1

        v1(I1, function()
            if o1 then
                w1(X, o1)
            end
        end)

        M1, W1, _1 = ctx.createFrame, {Parent = frame3}, ctx.udim2
        W1.Size = _1(1, -128, 1, 0)
        W1.BackgroundTransparency = 0.93

        _VX.setList(W1, 0, D1(), J1(0.9), H1(3))

        listLayout, T1, g1, createFrame = M1(W1), ctx.createFrame, {Parent = frame3}, ctx.topRight
        g1.AnchorPoint = createFrame
        _1 = ctx.udim2
        g1.Position = _1(1, 0, 0, 0)
        g1.Size = x(120, 30)
        g1.BackgroundTransparency = 0.8
        g1.BackgroundColor3 = color3FromRGB(60, 210, 80)
        M1 = ctx.listLayout

        _VX.setList(g1, 0, D1(), J1(0.5, color3FromRGB(96, 238, 92)), M1(0, center3, center2, horizontal))

        local X, V1, M1 = r(applyTextStyle({
            Parent = T1(g1),
            Size = x(0, 30),
            AutomaticSize = t,
            Text = '--',
            TextSize = 14,
        })), {Parent = listLayout}, ctx.udim2

        V1.Size = M1(1 / #O, 0, 1, 0)

        _VX.setList(V1, 0, D1(), U1(L.a1, L.a2))

        local U1, M1, A1 = frame(V1), {}, 1
        local T1, g1, y1 = N(listLayout, #O, 24, 0), {}, ipairs

        for f1, b1 in y1(O)do
            c1, h1 = {
                Parent = T1,
                LayoutOrder = f1,
            }, ctx.listLayout

            _VX.setList(c1, 0, h1(5, center3, center2, horizontal))

            _1 = textButton(c1)
            g1[f1] = e({
                Parent = _1,
                Size = x(14, 14),
                Image = b1[2],
                ImageColor3 = f1 == 1 and L.dk or L.tx,
            })
            M1[f1] = textLabel({
                Parent = _1,
                LayoutOrder = 1,
                Size = x(0, 24),
                AutomaticSize = t,
                Text = b1[1]:upper(),
                FontFace = font5,
                TextSize = 10,
                TextColor3 = f1 == 1 and L.dk or L.tx,
            })

            v1(_1, function()
                M1[A1].TextColor3, g1[A1].ImageColor3 = L.tx, L.tx
                A1 = f1
                M1[f1].TextColor3, g1[f1].ImageColor3, g1[f1].Size = L.dk, L.dk, x(20, 20)

                k1(g1[f1], {
                    Size = x(14, 14),
                }, 0.45, back)

                local h, udim2 = {}, ctx.udim2

                h.Position = udim2((f1 - 1) / #O, 0, 0, 0)

                k1(U1, h, 0.3)
                w1(E, b1[1])
            end)
        end

        listLayout, V1, W1 = ctx.createFrame, {
            Parent = callback,
            LayoutOrder = 1,
        }, ctx.udim2
        V1.Size = W1(1, -264, 0, 370)

        local H = listLayout(V1)
        local h = scrollingFrame({
            Parent = H,
            Size = _,
            ScrollingEnabled = UserInputService.TouchEnabled,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = L.wh,
            ScrollBarImageTransparency = 0.6,
        })

        a1.nest[h] = K

        a1:Grip(h, H)

        local k = N(h, M, 178, 8)

        d1 = nil
        d1, k.Position, k.Size = ctx.udim2, x(3, 3), ctx.udim2(1, -16, 0, 0)
        k.AutomaticSize = g
        H1(0, 0, 3, 0).Parent = k
        V1, p1 = {Parent = h}, ctx.udim2
        V1.Size = p1(1, 0, 0, 40)
        V1.Text = 'No eggs yet'
        V1.TextSize = 12
        V1.TextTransparency = 0.45
        V1.TextXAlignment = center

        local I, M, c, t = textLabel(V1), {}, {}, {}

        local function y(text)
            local N = o1 ~= text and ((if o1 then not text else not o1) or o1.id ~= text.id or o1.muts ~= text.muts)

            o1 = text
            text = text or {}

            local E = o(text)

            if N ~= false then
                setFramesAlpha2(Q1.a, E)
                B(Q1.rb, Q1.ra, E, text)
                P(Q1.ti, text)

                F1.BackgroundColor3, C1.Color = E[1], E[2]
            end
            if Q1.m ~= text.muts then
                Q1.m = text.muts

                A(Q1.mu, text.muts, 20, 13)
            end

            Q1.im.Image, Q1.ti.Text, Q1.va.Text = text.image or '', text.title or 'Pick an egg', text.value or '--'

            local ipairsFn, e = ipairs, {
                text.size,
                text.weight,
                text.status,
            }

            for K, U1 in ipairsFn(e)do
                m1[K].Text = U1 or '--'
            end

            e = text.kind == 'Ready' and {
                'sparkles',
                L.mint,
            } or text.kind == 'Growing' and {
                'clock',
                L.wh,
            } or {
                'egg',
                E[3],
            }

            d(Q1.si, e[1])

            Q1.si.ImageColor3, m1[3].TextColor3 = e[2], e[2]
            e = nil
            e, Q1.bf.Size, Q1.bf.BackgroundColor3 = ctx.udim2, ctx.udim2(text.kind == 'Growing' and text.pct or 0, 0, 0, 3), E[3]
            I1.Parent.Visible, t1.Text = text.label ~= nil, text.label or ''

            d(L1, ({
                ['Hatch now'] = 'sparkles',
                ['Go to egg'] = 'pin',
            })[text.label] or 'hand')
        end
        local function updateViewportVisibility()
            local i, N = h.AbsolutePosition.Y, h.AbsoluteSize.Y

            for key, value in next, M do
                key = value.c.AbsolutePosition.Y - i

                local i = key > -value.c.AbsoluteSize.Y - 60 and key < N + 60

                if value.box.Visible ~= i then
                    value.box.Visible = i
                end
            end
        end

        G(h:GetPropertyChangedSignal('CanvasPosition'), updateViewportVisibility)
        G(h:GetPropertyChangedSignal('AbsoluteSize'), updateViewportVisibility)

        local function updateBackgroundAlpha()
            local i = table.remove(c)

            if i then
                i.c.Visible = true

                return i
            end

            local i = {}

            i.s = J1(0.1)
            i.c = textButton({
                Parent = k,
                BackgroundTransparency = 0.3,
                D1(18),
                i.s,
            })

            local createFrame = ctx.createFrame

            i.box = createFrame({
                Parent = i.c,
                Size = _,
            })

            local _, N, udim2 = i.box, {
                Position = x(5, 5),
            }, ctx.udim2

            N.Size = udim2(1, -10, 0, 108)
            i.a = setFramesAlpha(_, N, 14, {118, 86, 56})
            _, udim2 = {
                Parent = i.a.f,
                AnchorPoint = T,
                Position = Z,
                Size = x(96, 96),
            }, ctx.Enum
            _.ScaleType = udim2.ScaleType.Fit
            _.ZIndex = 3
            i.im = imageLabel(_)
            i.rk = applyTextStyle({
                Parent = i.a.f,
                Position = x(7, 5),
                Size = x(30, 15),
                TextSize = 12,
                ZIndex = 5,
            })
            udim2, _ = {
                Parent = i.a.f,
                AnchorPoint = vector2New(0, 1),
            }, ctx.udim2
            udim2.Position = _(0, 7, 1, -6)
            udim2.Size = x(64, 15)
            udim2.TextSize = 12
            udim2.ZIndex = 5
            i.tm = applyTextStyle(udim2)
            N, createFrame = {
                Parent = i.a.f,
                AnchorPoint = vector2New(1, 1),
            }, ctx.udim2
            N.Position = createFrame(1, -7, 1, -6)
            N.Size = x(48, 15)
            N.TextSize = 11
            udim2 = ctx.Enum
            N.TextXAlignment = udim2.TextXAlignment.Right
            N.ZIndex = 5
            i.sz = applyTextStyle(N)
            createFrame, udim2, N = ctx.createFrame, {
                Parent = i.a.f,
            }, ctx.topRight
            udim2.AnchorPoint = N
            _ = ctx.udim2
            udim2.Position = _(1, -5, 0, 4)
            udim2.Size = x(0, 0)
            N = ctx.Enum
            udim2.AutomaticSize = N.AutomaticSize.XY
            udim2.ZIndex = 5
            _, N = ctx.listLayout, ctx.Enum

            _VX.setList(udim2, 0, _(1, N.HorizontalAlignment.Right))

            i.mt = createFrame(udim2)
            N, _ = {
                Parent = i.box,
                Position = x(8, 117),
            }, ctx.udim2
            N.Size = _(1, -16, 0, 18)
            N.TextSize = 14
            N.TextXAlignment = center
            i.ti = applyTextStyle(N)
            udim2, N, createFrame = ctx.createFrame, {
                Parent = i.box,
                Position = x(8, 137),
            }, ctx.udim2
            N.Size = createFrame(1, -16, 0, 17)
            _ = ctx.listLayout

            _VX.setList(N, 0, _(0, center3))

            _ = udim2(N)
            i.rb, i.ra = S(_, 10)
            i.rb.BackgroundTransparency, i.rb:FindFirstChildOfClass('UIStroke').Enabled = 1, false

            i.rb:FindFirstChildOfClass('UIPadding'):Destroy()

            udim2, createFrame = {
                Parent = i.box,
                Position = x(8, 156),
            }, ctx.udim2
            udim2.Size = createFrame(1, -16, 0, 17)
            udim2.TextSize = 14
            udim2.TextXAlignment = center
            i.va = r(applyTextStyle(udim2))
            createFrame, _ = {
                Parent = i.a.f,
                AnchorPoint = vector2New(0, 1),
            }, ctx.udim2
            createFrame.Position = _(0, 0, 1, 0)
            udim2 = ctx.udim2
            createFrame.Size = udim2(0, 0, 0, 3)
            createFrame.ZIndex = 5
            i.bf = frame(createFrame)

            v1(i.c, function()
                if not i.it then
                    return
                end

                t.sel = i.it.id

                for k, k in next, M do
                    k.s.Thickness = k.it.id == t.sel and 2.5 or 1.2
                end

                y(i.it)
            end)

            return i
        end

        t.Set = function(k, r, callback, Q)
            I.Visible, X.Text = #r == 0, Q or '--'

            for index, _ in ipairs(O)do
                M1[index].Text = _[1]:upper() .. (callback and callback[_[1] ] and '  ' .. callback[_[1] ] or '')
            end

            k, callback, Q = {}, ipairs

            for I, _ in callback(r)do
                local F = M[_.id] or updateBackgroundAlpha()

                M[_.id], k[_.id] = F, true
                F.it = _
                F.c.LayoutOrder = I

                local h = o(_)

                if F.p ~= h then
                    F.p = h

                    setFramesAlpha2(F.a, h)
                    B(F.rb, F.ra, h, _)
                    P(F.ti, _)

                    F.c.BackgroundColor3, F.s.Color = h[1], h[2]
                end

                F.s.Thickness = _.id == t.sel and 2.5 or 1.2

                if F.im.Image ~= _.image then
                    F.im.Image = _.image or ''
                end

                F.rk.Text, F.ti.Text, F.va.Text, F.tm.Text, F.sz.Text = '#' .. (_.rank or I), _.title, _.value, _.time or '', _.size or ''
                I = ''

                for index, value in ipairs(_.muts or {})do
                    I ..= value.n .. ','
                end

                if F.mk ~= I then
                    F.mk = I

                    A(F.mt, _.muts, 14, 9)
                end

                I = nil
                I, F.bf.Size, F.bf.BackgroundColor3 = ctx.udim2, ctx.udim2(_.pct or 0, 0, 0, 3), _.ready and L.mint or h[3]
                Q = if _.id == t.sel then _ else Q
            end
            for key, value in next, M do
                if not (k[key]) then
                    value.c.Visible = false
                    value.it = nil
                    value.p = nil
                    value.mk = nil
                    M[key], c[#c + 1] = nil, value
                end
            end

            task.defer(updateViewportVisibility)

            Q = Q or r[1]
            t.sel = Q and Q.id

            y(Q)
        end
        t.Card = function(callback, visible)
            F1.Parent.Visible = visible
            callback = ctx.udim2
            H.Size = callback(1, visible and -264 or 0, 0, r1 + 6)
        end

        y(nil)

        return t
    end
    R1.Order = function(parent, k, r, I)
        local h = {}

        h.Value = table.clone(r)

        local createFrame, A, udim2 = ctx.createFrame, {
            Parent = parent.f,
            LayoutOrder = parent.n + 1,
        }, ctx.udim2

        A.Size = udim2(1, 0, 0, #r * 34 + 12)
        udim2 = createFrame(A)

        parent:Add(udim2, k, true)

        local F = {}

        A = #r

        for Q = 1, A, 1 do
            local createFrame3, _, udim2 = ctx.createFrame, {
                Parent = udim2,
                Position = x(14, 6 + (Q - 1) * 34),
            }, ctx.udim2

            _.Size = udim2(1, -28, 0, 30)
            _.BackgroundTransparency = 0.95

            _VX.setList(_, 0, D1(9))

            createFrame = createFrame3(_)

            textLabel({
                Parent = createFrame,
                Position = x(10, 0),
                Size = x(20, 30),
                Text = tostring(Q),
                FontFace = font4,
                TextSize = 12,
                TextTransparency = 0.45,
            })

            createFrame3, _ = {
                Parent = createFrame,
                Position = x(34, 0),
            }, ctx.udim2
            createFrame3.Size = _(1, -110, 1, 0)
            createFrame3.FontFace = font6
            createFrame3.TextSize = 13
            F[Q] = textLabel(createFrame3)
            _, createFrame3 = ipairs, {
-1,
                1,
            }

            for n, d in _(createFrame3)do
                local A, _ = {
                    Parent = createFrame,
                    AnchorPoint = R,
                }, ctx.udim2

                A.Position = _(1, n == 1 and -38 or -6, 0.5, 0)
                A.Size = x(28, 24)
                A.BackgroundTransparency = 0.9

                _VX.setList(A, 0, D1(7), u('down', 14))

                n = textButton(A)
                n:FindFirstChildWhichIsA('ImageLabel').Rotation = d < 0 and 180 or 0

                n1(n)
                v1(n, function()
                    local value, M = h.Value, Q + d

                    if M < 1 then
                        return
                    elseif M > #value then
                        return
                    end

                    value[Q], value[M] = value[M], value[Q]

                    h:Set(value)
                end)
            end
        end

        h.Set = function(n, options, A)
            local d, Q = {}, {}

            for _, _ in ipairs(type(options) == 'table' and options or {})do
                if table.find(r, _) then
                    if not (d[_]) then
                        d[_] = true
                        Q[#Q + 1] = _
                    end
                end
            end
            for _, value in ipairs(r)do
                if not (d[value]) then
                    options = #Q + 1

                    for d = _ + 1, #r, 1 do
                        n = table.find(Q, r[d])

                        if n then
                            options = n

                            break
                        end
                    end

                    table.insert(Q, options, value)
                end
            end

            h.Value = Q

            for index, value in ipairs(F)do
                value.Text = Q[index]
            end

            if not A then
                w1(I, Q)
            end
        end

        h:Set(r, true)

        return parent:Reg(k, h)
    end
    R1.Text = function(parent, text)
        local r = textLabel({
            Size = f,
            AutomaticSize = g,
            Text = text,
            TextSize = 12,
            TextTransparency = 0.22,
            TextWrapped = true,
        })

        parent.tn = (parent.tn or 0) + 1

        local createFrame, h, createFrame4 = ctx.createFrame, {
            Parent = parent.f,
            Size = f,
            AutomaticSize = g,
            LayoutOrder = -1E3+ parent.tn,
            Visible = text ~= '',
        }, ctx.createFrame

        _VX.setList(h, 0, createFrame4({
            Size = f,
            AutomaticSize = g,
            H1(12, 14),
            r,
        }))

        local frame = createFrame(h)

        if parent.n >= parent.tn then
            h = ctx.udim2

            V(frame, h(0, 14, 1, -1), ctx.udim2(1, -28, 0, 1))
        end

        parent.n = parent.n + 1

        return {
            Set = function(H, visible)
                r.Text, frame.Visible = visible, visible ~= ''
            end,
        }
    end
    ctx.Venyx.Notify = function(callback, callback4, callback3, frame, I)
        callback = ctx.Venyx

        local h = callback.W

        if not h then
            return
        end

        I = I or 4

        local n, M = Z1(frame)

        callback = ctx.createFrame

        local A, createFrame = callback({
            Parent = h.nt,
            Size = f,
            AutomaticSize = g,
        }), ctx.createFrame

        h, callback = {
            Position = x(42, 0),
        }, ctx.udim2
        h.Size = callback(1, -42, 0, 0)
        h.AutomaticSize = g
        callback = ctx.listLayout

        local F, Q, _ = callback(2), {}, ctx.udim2

        Q.Size = _(1, 0, 0, 17)
        Q.Text = callback4 or ''
        Q.FontFace = font6

        _VX.setList(h, 0, F, textLabel(Q))

        _ = createFrame(h)

        if callback3 then
            if callback3 ~= '' then
                textLabel({
                    Parent = _,
                    LayoutOrder = 1,
                    Size = f,
                    AutomaticSize = g,
                    Text = callback3,
                    TextSize = 12,
                    TextTransparency = 0.3,
                    TextWrapped = true,
                })
            end
        end

        callback4, frame, callback3 = ctx.createFrame, {
            AnchorPoint = vector2New(0, 1),
        }, ctx.udim2
        frame.Position = callback3(0, 0, 1, 10)
        createFrame = ctx.udim2
        frame.Size = createFrame(1, 0, 0, 3)
        frame.BackgroundTransparency = 0.2
        frame.BackgroundColor3 = n

        _VX.setList(frame, 0, D1())

        Q, h, callback, F = callback4(frame), ctx.createFrame, {
            Parent = A,
            Position = x(360, 0),
            Size = f,
            AutomaticSize = g,
            BackgroundTransparency = 0.06,
            BackgroundColor3 = color3FromRGB(20, 22, 46),
        }, ctx.createFrame

        _VX.setList(callback, 0, D1(16), J1(0.86), H1(14, 14, 18), _, Q, F({
            Size = x(30, 30),
            BackgroundTransparency = 0.8,
            BackgroundColor3 = n,
            D1(10),
            u(M, 16, n),
        }))

        local k, r, udim2 = h(callback), {}, ctx.udim2

        r.Position = udim2()

        k1(k, r, 0.5)
        k1(Q, {
            Size = x(0, 3),
        }, I, ctx.Enum.EasingStyle.Linear)
        task.delay(I, function()
            k1(k, {
                Position = x(360, 0),
            }, 0.35, quint, ctx.Enum.EasingDirection.In)
            task.delay(0.4, A.Destroy, A)
        end)
    end
    ctx.baseDir = function()
        local H = ctx.game
        local k, gameId = H.GameId ~= 0

        if k then
            H = ctx.game
            gameId = H.GameId
        else
            gameId = k
        end

        H = nil

        if gameId then
            H = gameId
        else
            k = ctx.game
            H = k.PlaceId
        end

        gameId = ctx.Venyx

        local V, W = gameId.Id ~= 'Venyx'

        if V then
            k = ctx.Venyx
            W = '/' .. k.Id
        else
            W = V
        end

        return 'Venyx/' .. H .. (W or '')
    end
    ctx.userDir = function()
        local baseDir = ctx.baseDir

        return baseDir() .. '/' .. localPlayer.UserId
    end
    ctx.configPath = function(H)
        local userDir = ctx.userDir

        return userDir() .. '/' .. H .. '.json'
    end

    local readJson = _VX.readJson

    ctx.readJson = readJson

    local writeJson = _VX.writeJson

    ctx.writeJson = writeJson
    ctx.serializeValue = function(target)
        if target == nil then
            return {z = 1}
        end

        return typeof(target) == 'Color3' and {
            c = target:ToHex(),
        } or typeof(target) == 'EnumItem' and {
            k = target.Name,
        } or target
    end

    local function H(options)
        if type(options) ~= 'table' then
            return options
        end
        if options.z then
            return nil
        end

        local r, C = options.c and Color3.fromHex(options.c)

        if r then
            C = r
        else
            local r = options.k

            if r then
                local enum = ctx.Enum

                C = enum.KeyCode[options.k]
            else
                C = r
            end
        end

        return C or options
    end
    local function k(r, C)
        local httpService, serializeValue, httpService2, serializeValue2 = ctx.HttpService, ctx.serializeValue, ctx.HttpService, ctx.serializeValue

        return httpService:JSONEncode(serializeValue(r)) == httpService2:JSONEncode(serializeValue2(C))
    end

    ctx.applyConfig = function(r)
        local venyx = ctx.Venyx

        venyx.busy = true
        venyx = next

        for V, W in venyx, r, nil do
            local venyx = ctx.Venyx
            local I, v = venyx.Keys[V]

            if I then
                v = I
            else
                venyx = ctx.Venyx
                v = venyx.Opt[V]
            end

            venyx = nil

            if v then
                venyx = v
            else
                I = ctx.Venyx
                venyx = I.Alias[V]
            end

            W = H(W)

            if venyx then
                if not venyx.Skip then
                    if not (k(W, venyx.Value)) then
                        pcall(venyx.Set, venyx, W)
                    end
                end
            end
        end

        r = ctx.Venyx
        r.busy = false
    end
    ctx.Venyx.Persist = function(H)
        local writeJson, userDir = ctx.writeJson, ctx.userDir

        writeJson(userDir() .. '/_state.json', ctx.State)
    end
    ctx.Venyx.Dir = ctx.userDir
    ctx.Venyx.Rd = ctx.readJson
    ctx.Venyx.Wr = ctx.writeJson
    ctx.Venyx.Save = _VX.saveConfig
    ctx.Venyx.Load = _VX.loadConfig
    ctx.Venyx.Configs = _VX.listConfigs
    ctx.Venyx.Delete = _VX.deleteConfig
    ctx.Venyx.Trash = function(H)
        local H = {}

        pcall(function()
            local userDir = ctx.userDir

            for index, value in ipairs(listfiles(userDir() .. '/_trash'))do
                H[#H + 1] = value:match('([^/\\]+)%.json$')
            end
        end)
        table.sort(H)

        return H
    end
    ctx.Venyx.Restore = _VX.restoreConfig
    ctx.Venyx.Name = function(H, rawText)
        rawText = tostring(rawText or ''):match('^%s*(.-)%s*$')

        if rawText ~= '' then
            if not (rawText:match('^[%w _%-]+$')) then
                return nil, 'Use letters, numbers, spaces, - or _'
            end
        end
        if #rawText > 32 then
            return nil, '32 characters at most'
        end

        H = rawText ~= '' and rawText or 'Config'
        rawText = if rawText == ''then'Config 1'else rawText

        local C = 2

        while true do
            local V, fileExists = isfile

            if V then
                local configPath

                configPath, fileExists = ctx.configPath, isfile(ctx.configPath(rawText))
            else
                fileExists = V
            end
            if not fileExists then
                break
            end

            rawText, C = H .. ' ' .. C, C + 1
        end

        return rawText
    end
    ctx.Venyx.Export = _VX.exportConfig
    ctx.Venyx.Import = _VX.importConfig
    ctx.Venyx.Dirty = function(H)
        local venyx, venyx3 = ctx.Venyx, ctx.Venyx

        venyx.tok = (venyx3.tok or 0) + 1
        venyx3 = ctx.Venyx

        local tok = venyx3.tok

        task.delay(1, function()
            local venyx = ctx.Venyx

            if venyx.tok == tok then
                local venyx = ctx.Venyx

                venyx:Save()
            end
        end)
    end
    ctx.Venyx.Reset = function(target)
        target = ctx.Venyx
        target.busy = true
        target = ctx.Venyx

        for key, value in next, target.Keys do
            if not value.Skip then
                if not (k(value.Def, value.Value)) then
                    pcall(value.Set, value, type(value.Def) == 'table' and table.clone(value.Def) or value.Def)
                end
            end
        end

        target = ctx.Venyx
        target.busy = false
        target = ctx.Venyx

        target:Save()
    end
    ctx.Venyx.Off = function(H)
        local venyx, k = ctx.Venyx, 0

        for key, value in next, venyx.Keys do
            if value.Kind == 'toggle' then
                if value.Value then
                    if value.Skip then
                    else
                        value:Set(false)

                        k += 1
                    end
                end
            end
        end

        return k
    end
    ctx.Venyx.Theme = function(H, k)
        H = nil

        for index, value in ipairs(l)do
            H = if value[1] == k then value else H
        end

        if not H then
            return
        end

        local venyx = ctx.Venyx
        local C, venyx4 = venyx.W, ctx.Venyx

        if venyx4.th ~= k then
            venyx = ctx.Venyx
            venyx.th = k

            local W, I, v = {
                w1 = H[2],
                w2 = H[3],
                a1 = H[4],
                a2 = H[5],
                sky = H[4]:Lerp(L.wh, 0.2),
                g1 = H[5]:Lerp(L.wh, 0.35),
                g2 = H[4],
                val = H[5]:Lerp(L.wh, 0.7),
                pn = H[2]:Lerp(H[3], 0.55),
                bg = H[2]:Lerp(H[3], 0.75),
                on = H[6] or color3FromRGB(255, 255, 254),
            }, {}, {0.35, 0.4, 0.5}

            for index, value in ipairs(v)do
                I[L.a1:Lerp(L.wh, value):ToHex()] = W.a1:Lerp(L.wh, value)
            end

            I[L.sky:Lerp(L.wh, 0.55):ToHex()] = W.sky:Lerp(L.wh, 0.55)

            for key, value in next, W do
                I[L[key]:ToHex()] = value
                L[key] = value
            end

            I[L.wh:ToHex()], I[L.tx:ToHex()] = nil, nil

            local function w(target)
                return I[target:ToHex()]
            end

            W, v = ipairs, {
                C and C.Gui,
                C and C.nt and C.nt.Parent,
            }

            for I, I in W(v)do
                for index, v in ipairs(I and I:GetDescendants() or {})do
                    if not (v:FindFirstAncestor('VenyxThemes') or v.Parent == C.bg) then
                        if v:IsA('GuiObject') then
                            v.BackgroundColor3 = w(v.BackgroundColor3) or v.BackgroundColor3

                            if v:IsA('TextLabel') or v:IsA('TextButton') or v:IsA('TextBox') then
                                v.TextColor3 = w(v.TextColor3) or v.TextColor3
                            end
                            if v:IsA('ImageLabel') or v:IsA('ImageButton') then
                                v.ImageColor3 = w(v.ImageColor3) or v.ImageColor3
                            end
                        elseif v:IsA('UIStroke') then
                            v.Color = w(v.Color) or v.Color
                        elseif v:IsA('UIGradient') then
                            index = {}

                            for index2, keypoint in ipairs(v.Color.Keypoints)do
                                index[index2] = ColorSequenceKeypoint.new(keypoint.Time, w(keypoint.Value) or keypoint.Value)
                            end

                            v.Color = ColorSequence.new(index)
                        end
                    end
                end
            end
        end

        venyx = ctx.State
        venyx.Theme = k

        if C then
            C:Tint()
        end

        for key, value in next, C and C.marks or {}, nil do
            k1(value[1], {
                Transparency = key == k and 0.3 or 0.86,
                Color = key == k and H[4] or L.wh,
            }, 0.2)

            venyx, venyx4 = value[2], {}
            venyx4.ImageTransparency = key == k and 0 or 1

            k1(venyx, venyx4, 0.2)
        end

        venyx = ctx.Venyx

        venyx:Persist()
    end
    ctx.Venyx.Boot = _VX.boot

    return ctx.Venyx
end)()
