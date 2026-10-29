return function(arg, arg2)
	assert(type(arg) == "table" and arg[1] == 1129531443)
	assert(type(arg2) == "string" and #arg2 == 45)
	local n2 = 1831565813
	local n3 = 461845907

	for i = 1, #arg2 do
		local v = string.byte(arg2, i)
		n2 = bit32.bxor(bit32.lrotate(n2, 5), v, i)
		n3 = bit32.bxor(bit32.lrotate(n3, 7), n2, v * 257 + i)
	end

	assert(n2 == 4128922676 and n3 == 842727784)
	local v2 = arg[2]
	local v3 = arg[3]
	local v4 = arg[4]
	local v5 = arg[5]
	local v6 = arg[6]
	local v7 = arg[7]
	local v8 = arg[8]
	local v9 = arg[9]
	local v10 = arg[10]
	local v11 = arg[11]
	local v12 = arg[12]
	local v13 = arg[13]
	local v14 = arg[14]
	local v15 = arg[15]
	local v16 = arg[16]
	local v17 = arg[17]
	local v18 = arg[18]
	local v19 = arg[19]
	local v20 = arg[20]
	local v21 = arg[21]
	local v22 = arg[22]
	local v23 = arg[23]
	local v24 = arg[24]
	local v25 = arg[25]
	local v26 = arg[26]
	local v27 = arg[27]
	local v28 = arg[28]
	local v29 = arg[29]
	local v30 = arg[30]
	local v31 = arg[31]
	local v32 = arg[32]
	local v33 = arg[33]
	local v34 = arg[34]
	local v35 = arg[35]
	local v36 = arg[36]
	local v37 = arg[37]
	local v38 = arg[38]
	local v39 = arg[39]
	local v40 = arg[40]
	local v41 = arg[41]
	local v42 = arg[42]
	local v43 = arg[43]
	local v44 = arg[44]
	local v45 = arg[45]
	local tbl = type(arg[48]) == "table" and arg[48] or {}
	local v46 = arg[46]
	local v47 = arg[47]

	for _, v in ipairs({
		{ 6, "_Apply", 1 },
		{ 6, "Get", 2 },
		{ 6, "Set", 3 },
		{ 6, "Subscribe", 4 },
		{ 6, "Link", 5 },
		{ 6, "LinkWhenTrue", 6 },
		{ 6, "LinkWhenFalse", 7 },
		{ 6, "LinkWhen", 8 },
		{ 6, "LinkMany", 9 },
		{ 6, "LinkManyWhenTrue", 10 },
		{ 6, "LinkInverse", 11 },
		{ 6, "LinkBidirectional", 12 },
		{ 6, "Destroy", 13 },
		{ 7, "_CountActive", 14 },
		{ 7, "_FindOldestActive", 15 },
		{ 7, "_EnforceMaximum", 16 },
		{ 7, "_CanSet", 17 },
		{ 7, "_StateChanged", 18 },
		{ 7, "Add", 19 },
		{ 7, "Remove", 20 },
		{ 7, "AddMany", 21 },
		{ 7, "Select", 22 },
		{ 7, "GetActive", 23 },
		{ 7, "GetLimits", 24 },
		{ 7, "SetMaxActive", 25 },
		{ 7, "SetMinActive", 26 },
		{ 7, "SetAllowNone", 27 },
		{ 7, "Destroy", 28 },
		{ 5, "Get", 29 },
		{ 5, "Set", 30 },
		{ 5, "GetState", 31 },
		{ 5, "BindState", 32 },
		{ 5, "ShareStateWith", 33 },
		{ 5, "Link", 34 },
		{ 5, "LinkWhenTrue", 35 },
		{ 5, "LinkWhenFalse", 36 },
		{ 5, "LinkWhen", 37 },
		{ 5, "LinkMany", 38 },
		{ 5, "LinkManyWhenTrue", 39 },
		{ 5, "LinkInverse", 40 },
		{ 5, "LinkBidirectional", 41 },
		{ 5, "JoinExclusiveGroup", 42 },
		{ 5, "_EnsureVisibilityHost", 43 },
		{ 5, "_ApplyVisibility", 44 },
		{ 5, "SetVisible", 45 },
		{ 5, "IsVisible", 46 },
		{ 5, "ShowWhen", 47 },
		{ 5, "SubOf", 48 },
		{ 5, "GetSubOptions", 49 },
		{ 5, "SubOptions", 50 },
		{ 5, "ShowOptions", 51 },
		{ 5, "GetNote", 52 },
		{ 5, "SetNote", 53 },
		{ 5, "SetOptions", 54 },
		{ 5, "GetRange", 55 },
		{ 5, "SetRange", 56 },
		{ 5, "SetMin", 57 },
		{ 5, "SetMax", 58 },
		{ 5, "GetDecimals", 59 },
		{ 5, "SetDecimals", 60 },
		{ 5, "SetIncrement", 61 },
		{ 5, "GetUnit", 62 },
		{ 5, "SetUnit", 63 },
		{ 5, "SetUnits", 64 },
		{ 5, "SetUnitEnabled", 65 },
		{ 5, "SetUnitSelectorEnabled", 66 },
		{ 5, "SetUnitFormat", 67 },
		{ 5, "SetUnitCallback", 68 },
		{ 5, "SetValueFormat", 69 },
		{ 5, "SetValueParse", 70 },
		{ 5, "GetValueColors", 71 },
		{ 5, "SetValueColors", 72 },
		{ 5, "SetValueColorEnabled", 73 },
		{ 5, "GetQuickPath", 74 },
		{ 5, "GetQuickName", 75 },
		{ 5, "SetQuickName", 76 },
		{ 5, "GetKeybindGroup", 77 },
		{ 5, "SetKeybindGroup", 78 },
		{ 5, "IsQuickEnabled", 79 },
		{ 5, "SetQuickEnabled", 80 },
		{ 5, "Press", 81 },
		{ 5, "Apply", 82 },
		{ 5, "SetHint", 83 },
		{ 5, "SetActionText", 84 },
		{ 5, "Destroy", 85 },
		{ 4, "CreateOption", 86 },
		{ 4, "SetExpanded", 87 },
		{ 4, "Toggle", 88 },
		{ 4, "Destroy", 89 },
		{ 3, "CreateSection", 90 },
		{ 3, "Select", 91 },
		{ 3, "Destroy", 92 },
		{ 2, "_reflowTabs", 93 },
		{ 2, "SelectTab", 94 },
		{ 2, "CreateTab", 95 },
		{ 2, "GetTab", 96 },
		{ 2, "GetDefaultTab", 97 },
		{ 2, "CreateState", 98 },
		{ 2, "GetState", 99 },
		{ 2, "CreateExclusiveGroup", 100 },
		{ 2, "GetExclusiveGroup", 101 },
		{ 2, "Open", 102 },
		{ 2, "Close", 103 },
		{ 2, "Toggle", 104 },
		{ 2, "Destroy", 105 },
		{ 1, "CreateWindow", 106 },
		{ 5, "SetTitle", 107 },
		{ 5, "GetTitle", 108 },
		{ 5, "SetStyle", 109 },
		{ 5, "GetStyle", 110 },
		{ 5, "SetHeader", 111 },
		{ 5, "SetItems", 112 },
		{ 5, "SetGroups", 113 },
		{ 5, "AppendItem", 114 },
		{ 5, "SetSearchEnabled", 115 },
		{ 5, "SetSearchQuery", 116 },
		{ 5, "GetSearchQuery", 117 },
		{ 5, "SetSpotlight", 118 },
		{ 5, "SetSelected", 119 },
		{ 5, "GetSelected", 120 },
		{ 5, "GetSurface", 121 },
		{ 8, "Root", 122 },
		{ 8, "Scroll", 123 },
		{ 8, "Plate", 124 },
		{ 8, "Unit", 125 },
		{ 8, "Width", 126 },
		{ 8, "TextSize", 127 },
		{ 8, "LineHeight", 128 },
		{ 8, "Font", 129 },
		{ 8, "Query", 130 },
		{ 8, "Metrics", 131 },
		{ 8, "SetContentHeight", 132 },
		{ 8, "SetContentLines", 133 },
		{ 8, "Invalidate", 134 },
		{ 8, "Clear", 135 },
		{ 8, "OnResize", 136 },
		{ 8, "SetStyle", 137 },
		{ 8, "GetStyle", 138 },
		{ 8, "SetTitle", 139 },
		{ 8, "SetSearchEnabled", 140 },
		{ 8, "SetSearchQuery", 141 },
		{ 8, "Attach", 142 },
		{ 8, "Frame", 143 },
		{ 8, "Text", 144 },
		{ 8, "Button", 145 },
		{ 8, "Image", 146 },
		{ 8, "Model", 147 },
		{ 8, "Bar", 148 },
		{ 8, "Dock", 149 },
		{ 8, "SetDock", 150 },
	}) do
		v47[v[1]][v[2]] = v46[v[3]]
	end

	local v48 = v47[4]
	local v49 = v46[86]

	for _, v in ipairs({
		{ "CreateButton", "Button" },
		{ "CreateCycleSelector", "CycleSelector" },
		{ "CreateDynamicDropdown", "DynamicDropdown" },
		{ "CreateDropdown", "Dropdown" },
		{ "CreateMultiDropdown", "MultiDropdown" },
		{ "CreateActionDropdown", "ActionDropdown" },
		{ "CreateActionMultiDropdown", "ActionMultiDropdown" },
		{ "CreateInput", "Input" },
		{ "CreateText", "Text" },
		{ "CreateLabel", "Label" },
		{ "CreateSlider", "Slider" },
		{ "CreateSlidebar", "Slidebar" },
		{ "CreateToggle", "Toggle" },
		{ "CreateSwitch", "Switch" },
		{ "CreateParagraph", "Paragraph" },
		{ "CreateCanvas", "Canvas" },
	}) do
		local v50 = v[2]

		v48[v[1]] = function(arg3, arg4)
			return v49(arg3, v50, arg4)
		end
	end

	for _, v in ipairs({
		{ 4, "AddActionMultiDropdown", "CreateActionMultiDropdown" },
		{ 6, "Follow", "Link" },
		{ 6, "Invert", "LinkInverse" },
		{ 7, "AddOption", "Add" },
		{ 7, "AddState", "Add" },
		{ 7, "SetLimit", "SetMaxActive" },
		{ 5, "Mirror", "ShareStateWith" },
		{ 5, "Follow", "Link" },
		{ 5, "Invert", "LinkInverse" },
		{ 5, "DependsOn", "ShowWhen" },
		{ 5, "VisibleWhen", "ShowWhen" },
		{ 5, "ChildOf", "SubOf" },
		{ 5, "Under", "SubOf" },
		{ 4, "AddOption", "CreateOption" },
		{ 4, "AddButton", "CreateButton" },
		{ 4, "AddCycleSelector", "CreateCycleSelector" },
		{ 4, "AddDynamicDropdown", "CreateDynamicDropdown" },
		{ 4, "AddDropdown", "CreateDropdown" },
		{ 4, "AddMultiDropdown", "CreateMultiDropdown" },
		{ 4, "AddActionDropdown", "CreateActionDropdown" },
		{ 4, "AddInput", "CreateInput" },
		{ 4, "AddText", "CreateText" },
		{ 4, "AddLabel", "CreateLabel" },
		{ 4, "AddSlider", "CreateSlider" },
		{ 4, "AddSlidebar", "CreateSlidebar" },
		{ 4, "AddToggle", "CreateToggle" },
		{ 4, "AddSwitch", "CreateSwitch" },
		{ 3, "AddSection", "CreateSection" },
		{ 2, "AddTab", "CreateTab" },
		{ 2, "AddState", "CreateState" },
		{ 2, "AddExclusiveGroup", "CreateExclusiveGroup" },
		{ 2, "CreateSelectionGroup", "CreateExclusiveGroup" },
		{ 2, "AddSelectionGroup", "CreateExclusiveGroup" },
		{ 4, "AddParagraph", "CreateParagraph" },
		{ 4, "CreateRichText", "CreateParagraph" },
		{ 4, "AddCanvas", "CreateCanvas" },
		{ 4, "CreateSurface", "CreateCanvas" },
		{ 4, "AddSurface", "CreateCanvas" },
		{ 8, "Rect", "Frame" },
		{ 8, "Label", "Text" },
		{ 8, "Redraw", "Invalidate" },
	}) do
		local v50 = v47[v[1]]
		v50[v[2]] = v50[v[3]]
	end

	local tbl2 = {
		button = 1,
		cycleselector = 2,
		dynamicdropdown = 2,
		dropdown = 2,
		multidropdown = 3,
		actiondropdown = 4,
		actionmultidropdown = 5,
		multiactiondropdown = 5,
		input = 6,
		textbox = 6,
		label = 7,
		text = 7,
		slider = 8,
		slidebar = 8,
		switch = 9,
		toggle = 9,
		paragraph = 10,
		richtext = 10,
		richparagraph = 10,
		canvas = 11,
		surface = 11,
		freeform = 11,
	}

	v3[101] = function()
		error("devirt: index nil @0,142599 - 0,142605 (at 229:2)")
	end

	local tbl3 = { Height = 0.0749, Gap = 0.022, Tab = nil, Silent = false }

	local function fn()
		local m = Instance.new("Frame")
		m.Name = "SearchBar"
		m.Active = false
		m.AnchorPoint = Vector2.new(0.5, 0)
		m.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		m.BackgroundTransparency = 0.4
		m.BorderSizePixel = 0
		m.Position = UDim2.fromScale(0.5, 1 + tbl3.Gap)
		m.Size = UDim2.fromScale(1, tbl3.Height)
		m.ZIndex = 6
		m.Parent = v11
		v32(m, Enum.ApplyStrokeMode.Border, 0.05)
		local q = Instance.new("TextLabel")
		q.Name = "Caption"
		q.Active = false
		q.AnchorPoint = Vector2.new(0, 0.5)
		q.BackgroundTransparency = 1
		q.BorderSizePixel = 0
		q.Position = UDim2.fromScale(0.02, 0.5)
		q.Size = UDim2.fromScale(0.13, 0.5)
		q.Text = "Search"
		q.TextWrapped = false
		q.TextXAlignment = Enum.TextXAlignment.Left
		q.ZIndex = 7
		q.Parent = m
		v29(q)
		local K = Instance.new("Frame")
		K.Name = "Field"
		K.Active = false
		K.AnchorPoint = Vector2.new(1, 0.5)
		K.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		K.BackgroundTransparency = 0.6
		K.BorderSizePixel = 0
		K.ClipsDescendants = false
		K.Position = UDim2.fromScale(0.982, 0.5)
		K.Size = UDim2.fromScale(0.82, 0.6)
		K.ZIndex = 7
		K.Parent = m
		v32(K, Enum.ApplyStrokeMode.Border, 0.1)
		local f = Instance.new("Frame")
		f.Name = "Underline"
		f.Active = false
		f.AnchorPoint = Vector2.new(0.5, 1)
		f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		f.BorderSizePixel = 0
		f.Position = UDim2.fromScale(0.5, 1)
		f.Size = UDim2.fromScale(0, 0.11)
		f.ZIndex = 9
		f.Parent = K
		local g = Instance.new("TextBox")
		g.Name = "Input"
		g.Active = true
		g.AnchorPoint = Vector2.new(0, 0.5)
		g.BackgroundTransparency = 1
		g.BorderSizePixel = 0
		g.ClearTextOnFocus = false
		g.MultiLine = false
		g.Position = UDim2.fromScale(0.025, 0.5)
		g.Size = UDim2.fromScale(0.9, 0.62)
		g.Text = ""
		g.PlaceholderText = "Filter features..."
		g.PlaceholderColor3 = Color3.fromRGB(198, 198, 198)
		g.TextXAlignment = Enum.TextXAlignment.Left
		g.ZIndex = 8
		g.Parent = K
		v29(g)
		local l = Instance.new("TextButton")
		l.Name = "Clear"
		l.Active = true
		l.AutoButtonColor = false
		l.AnchorPoint = Vector2.new(1, 0.5)
		l.BackgroundTransparency = 1
		l.BorderSizePixel = 0
		l.Position = UDim2.fromScale(0.985, 0.5)
		l.Size = UDim2.fromScale(0.075, 0.74)
		l.Text = ""
		l.Visible = false
		l.ZIndex = 9
		l.Parent = K
		v40(l, 1.12, 0.9)
		q = Instance.new("UIAspectRatioConstraint")
		q.AspectRatio = 1
		q.AspectType = Enum.AspectType.FitWithinMaxSize
		q.DominantAxis = Enum.DominantAxis.Height
		q.Parent = l
		q = {45, -45}

		for u, U in ipairs(q) do
			u = Instance.new("Frame")
			u.Name = "Arm"
			u.Active = false
			u.AnchorPoint = Vector2.new(0.5, 0.5)
			u.BackgroundColor3 = Color3.fromRGB(255, 72, 72)
			u.BackgroundTransparency = 0
			u.BorderSizePixel = 0
			u.Position = UDim2.fromScale(0.5, 0.5)
			u.Rotation = U
			u.Size = UDim2.fromScale(0.82, 0.2)
			u.ZIndex = 10
			u.Parent = l
		end

		v19(l, function()
			if g:IsFocused() then
				g:ReleaseFocus()
			end

			g.Text = ""
		end)

		g:GetPropertyChangedSignal("Text"):Connect(function()
			l.Visible = g.Text ~= ""
		end)

		g.Focused:Connect(function()
			v5:Create(K, TweenInfo.new(0.16), {BackgroundTransparency = 0.42}):Play()
			v5:Create(f, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0.11)}):Play()
		end)

		g.FocusLost:Connect(function()
			v5:Create(K, TweenInfo.new(0.16), {BackgroundTransparency = 0.6}):Play()
			v5:Create(f, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0, 0.11)}):Play()
		end)

		g:GetPropertyChangedSignal("Text"):Connect(function()
			if tbl3.Silent then
				return
			end
			local q = tbl3.Tab

			if q and not q._destroyed then
				q._searchQuery = g.Text
				q._applySearch(g.Text)
			end
		end)

		local q = nil
		local K = nil

		K = function()
			local f = v22.Y
			local l, u = tbl3.Height / f, tbl3.Gap / f
			m.Size = UDim2.fromScale(1, l)
			local U = v11.AbsoluteSize.Y
			f = ((v11.AbsolutePosition.Y + U) + ((l + u) * U)) <= v10.AbsoluteSize.Y
			if f == q then
				return
			end
			q = f

			if f then
				m.AnchorPoint = Vector2.new(0.5, 0)
				m.Position = UDim2.fromScale(0.5, 1 + u)
			else
				m.AnchorPoint = Vector2.new(0.5, 1)
				m.Position = UDim2.fromScale(0.5, -u)
			end
		end

		v22.OnChanged(function()
			q = nil
			K()
		end)

		v11:GetPropertyChangedSignal("AbsolutePosition"):Connect(K)
		v11:GetPropertyChangedSignal("AbsoluteSize"):Connect(K)
		task.defer(K)

		tbl3.SetTab = function(m)
			tbl3.Tab = m
			tbl3.Silent = true
			g.Text = (m and m._searchQuery) or ""
			tbl3.Silent = false
		end
	end

	fn()

	local function fn2(m, q)
		m.Name = q .. "Page"
		m.Active = true
		m.AnchorPoint = Vector2.new(0.5, 0.5)
		m.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		m.BackgroundTransparency = 1
		m.BorderSizePixel = 0
		m.ClipsDescendants = true

		v22.OnChanged(function(K, K)
			if m.Parent == nil then
				return false
			end
			local f, g = 0.1454 / K, 1 - (0.01500005 / K)
			m.Position = UDim2.new(0.5000000596046448, 0, (f + g) / 2, 0)
			m.Size = UDim2.new(0.9900000095367432, 0, g - f, 0)
		end)

		m.ZIndex = 5
		m.AutomaticSize = Enum.AutomaticSize.None
		m.CanvasPosition = Vector2.new(0, 0)
		m.CanvasSize = UDim2.fromOffset(0, 0)
		m.AutomaticCanvasSize = Enum.AutomaticSize.None
		m.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
		m.ScrollBarImageTransparency = 0
		m.ScrollingDirection = Enum.ScrollingDirection.Y
		m.ScrollingEnabled = true
		m.VerticalScrollBarInset = Enum.ScrollBarInset.None
		m.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		m.Visible = false

		for K, K in ipairs(m:GetChildren()) do
			K:Destroy()
		end

		local K = Instance.new("UIListLayout")
		K.Name = "ContentLayout"
		K.FillDirection = Enum.FillDirection.Vertical
		K.HorizontalAlignment = Enum.HorizontalAlignment.Center
		K.VerticalAlignment = Enum.VerticalAlignment.Top
		K.SortOrder = Enum.SortOrder.LayoutOrder
		K.Padding = UDim.new(0, 2)
		K.Parent = m
		q = Instance.new("UIPadding")
		q.Name = "ContentPadding"
		q.PaddingTop = UDim.new(0, 0)
		q.PaddingBottom = UDim.new(0, 0)
		q.PaddingLeft = UDim.new(0.014000000432133675, 0)
		q.PaddingRight = UDim.new(0.014000000432133675, 0)
		q.Parent = m
		local q = -1

		local function f()
			local g, l, u = math.max(0, math.ceil(K.AbsoluteContentSize.Y)), 0, 0

			for U, U in ipairs(m:GetChildren()) do
				if U:IsA("GuiObject") and U.Visible then
					l, u = l + 1, u + math.max(0, U.AbsoluteSize.Y)
				end
			end

			return math.max(g, math.ceil(if l > 1 then u + ((l - 1) * (K.Padding.Offset + (K.Padding.Scale * m.AbsoluteSize.Y))) else u))
		end

		local function g()
			local l, u = f(), math.max(8, (m.AbsoluteSize.Y * 0.06) / v22.Y)
			local f = if l > 0 then (math.ceil(l + u)) else 0

			if math.abs(f - q) >= 1 then
				q = f
				m.CanvasSize = UDim2.new(0, 0, 0, f)
			end

			u = math.max(0, f - m.AbsoluteSize.Y)

			if m.CanvasPosition.Y > u then
				m.CanvasPosition = Vector2.new(m.CanvasPosition.X, u)
			end
		end

		local function q()
			m.ScrollBarThickness = math.max(2, math.floor(((m.AbsoluteSize.X * 0.006) / v22.X) + 0.5))
			g()
		end

		K:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(g)
		m:GetPropertyChangedSignal("AbsoluteSize"):Connect(q)
		task.defer(q)
		return K, g
	end

	local v50 = nil

	local function fn3(m)
		local q = {}

		local function K(f)
			return (tostring(f):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
		end

		local function f(g, l)
			if not g or not g:IsA("TextLabel") then
				return
			end
			local u = q[g]

			if u == nil then
				if g.RichText then
					return
				end
				u = g.Text
				q[g] = u
			end

			if l == "" then
				g.RichText = false
				g.Text = u
				return
			end

			local q, U = u:lower():find(l, 1, true)

			if not q then
				g.RichText = false
				g.Text = u
				return
			end

			g.RichText = true
			g.Text = K(u:sub(1, q - 1)) .. (("<font color=\"rgb(%d,%d,%d)\">"):format(math.floor((v37.R * 255) + 0.5), math.floor((v37.G * 255) + 0.5), math.floor((v37.B * 255) + 0.5)) .. (K(u:sub(q, U)) .. ("</font>" .. K(u:sub(U + 1)))))
		end

		local function q(K)
			local g = K.Instance:FindFirstChild("Main")

			if not g then
				for l, u in ipairs(K.Instance:GetChildren()) do
					l = u:FindFirstChild("Head")
					g = l and (l:FindFirstChild("Main"))
					if g then
						break
					end
				end
			end

			return (g and (g:FindFirstChild("Label"))) or nil
		end

		local function K(g)
			local l = (tostring(g or ""):match("^%s*(.-)%s*$") or ""):lower()

			for u, U in ipairs(m.Sections) do
				if not U._destroyed and not U._isSearchResults then
					u = U.DisplayName or U.Name
					g = (l == "") or (u:lower():find(l, 1, true) ~= nil)
					local u = if U._searchExtra then (U._searchExtra(l) == true) or g else g
					f(U._header, l)

					for s, A in ipairs(U.Options) do
						if A.Instance then
							s = A.DisplayName or A.Name
							local k, r = ((l == "") or g) or (s:lower():find(l, 1, true) ~= nil), A._visibilityHost or A.Instance

							if l == "" then
								if A._preSearchVisible ~= nil then
									r.Visible = A._preSearchVisible
									A._preSearchVisible = nil
									A._searchMatched = nil
								end
							else
								if A._preSearchVisible == nil then
									A._preSearchVisible = A._resolvedVisible ~= false
								end

								A._searchMatched = k
								r.Visible = k and A._preSearchVisible
							end

							f(q(A), l)
							u = if k then true else u
						end
					end

					if l == "" then
						U._container.Visible = true

						if U._preSearchExpanded ~= nil then
							U:SetExpanded(U._preSearchExpanded, false)
							U._preSearchExpanded = nil
						end
					else
						if U._preSearchExpanded == nil then
							U._preSearchExpanded = U.Expanded
						end

						U._container.Visible = u

						if u and not U.Expanded then
							U:SetExpanded(true, false)
						end
					end

					U._refreshHeight()
				end
			end

			if v50[3][v50[5]] then
				v50[3][v50[5]](m, l)
			end

			task.defer(m._updateCanvas)
		end

		m._searchPaint = f
		return K
	end

	local function fn4(m, q)
		local K = q:FindFirstChildOfClass("UIAspectRatioConstraint")
		if not K or (K.AspectRatio <= 0) then
			return function()
			end
		end
		local f, g, l, u, U = K.AspectRatio, q.Size.X.Scale, q.Size.X.Offset, -1, -1
		K:Destroy()
		q.Size = UDim2.new(g, l, 0, 1)
		m._rowUpdaters = m._rowUpdaters or {}
		local K = nil

		K = function(s)
			if m._destroyed or (q.Parent == nil) then
				return
			end

			if not s and (v3.windowAnimating or not m.Tab.Page.Visible) then
				return
			end
			s = m._content.AbsoluteSize.X
			s = if s <= 0 then m.Tab.Page.AbsoluteSize.X else s
			if s <= 0 then
				return
			end
			local A = v22.X
			local k, r = ((s * g) / A) + l, tonumber(q:GetAttribute("ChilliResponsiveAspect")) or f
			r = math.max(0.001, r)
			s = math.max(1, math.floor((k / r) + 0.5))
			k = if v24 then g / A else g

			if (math.abs(s - u) >= 1) or (math.abs(k - U) > 1e-06) then
				u, U = s, k
				q.Size = UDim2.new(k, l, 0, s)
			end

			m._refreshHeight()
		end

		v22.OnChanged(function()
			if m._destroyed or (q.Parent == nil) then
				return false
			end
			K()
		end)

		local M = {m._content:GetPropertyChangedSignal("AbsoluteSize"):Connect(K), m.Tab.Page:GetPropertyChangedSignal("AbsoluteSize"):Connect(K), q:GetAttributeChangedSignal("ChilliResponsiveAspect"):Connect(K)}
		table.insert(m._rowUpdaters, K)
		K(true)

		task.defer(function()
			K(true)
		end)

		return function()
			for q = #m._rowUpdaters, 1, -1 do
				if m._rowUpdaters[q] == K then
					table.remove(m._rowUpdaters, q)
				end
			end

			for m = #M, 1, -1 do
				local q = M[m]

				if q.Connected then
					q:Disconnect()
				end

				M[m] = nil
			end
		end
	end

	local str = "__ChilliSearchResults"
	local v51 = nil
	local str2 = "Other Tabs"
	local n4 = 30

	local function fn5(M)
		local m = tostring(M.DisplayName or M.Name)
		if (m:lower():sub(-4) == " tab") or (m:lower() == "tab") then
			return m
		end
		return m .. " Tab"
	end

	local function fn6(M)
		return table.concat({M.Section.Tab.Name, M.Section.Name, M.Name}, " > ")
	end

	local function fn7(m)
		local q = m._searchResultsSection
		if q and not q._destroyed then
			return q
		end
		q = m:CreateSection({Name = str, DisplayName = str2, Expanded = true})
		q._isSearchResults = true
		q._container.LayoutOrder = 1000000
		q._container.Visible = false
		q._mirrors = {}
		q._groupHeaders = {}
		m._searchResultsSection = q
		return q
	end

	local function fn8(m, q)
		local K = m._groupHeaders[q]
		if K then
			return K
		end
		local f = Instance.new("Frame")
		f.Name = "ResultGroup"
		f.Active = false
		f.AnchorPoint = Vector2.new(0.5, 0.5)
		f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		f.BackgroundTransparency = 0.58
		f.BorderSizePixel = 0
		f.Position = UDim2.fromScale(0.5, 0.5)
		f.Size = UDim2.fromScale(v36, 0.6)
		f.ZIndex = 3
		local g = v32(f, Enum.ApplyStrokeMode.Border, 0.045)
		g.Color = v37
		g.Transparency = 0.62
		local l = Instance.new("UIAspectRatioConstraint")
		l.AspectRatio = 22
		l.AspectType = Enum.AspectType.FitWithinMaxSize
		l.DominantAxis = Enum.DominantAxis.Width
		l.Parent = f
		l = Instance.new("TextLabel")
		l.Name = "Label"
		l.Active = false
		l.AnchorPoint = Vector2.new(0, 0.5)
		l.BackgroundTransparency = 1
		l.BorderSizePixel = 0
		l.Position = UDim2.fromScale(0.025, 0.5)
		l.Size = UDim2.fromScale(0.73, 0.8)
		l.Text = ""
		l.TextWrapped = false
		l.TextTruncate = Enum.TextTruncate.AtEnd
		l.TextXAlignment = Enum.TextXAlignment.Left
		l.ZIndex = 5
		l.Parent = f
		v29(l)
		l.TextColor3 = v37
		local u = Instance.new("Frame")
		u.Name = "Line"
		u.Active = false
		u.AnchorPoint = Vector2.new(1, 0.5)
		u.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		u.BackgroundTransparency = 0.75
		u.BorderSizePixel = 0
		u.Position = UDim2.fromScale(0.79, 0.5)
		u.Size = UDim2.fromScale(0.055, 0.08)
		u.ZIndex = 4
		u.Parent = f
		u = Instance.new("TextLabel")
		u.Name = "OpenHint"
		u.Active = false
		u.AnchorPoint = Vector2.new(1, 0.5)
		u.BackgroundTransparency = 1
		u.BorderSizePixel = 0
		u.Position = UDim2.fromScale(0.975, 0.5)
		u.Size = UDim2.fromScale(0.16, 0.72)
		u.Text = "OPEN  >"
		u.TextWrapped = false
		u.TextXAlignment = Enum.TextXAlignment.Right
		u.ZIndex = 5
		u.Parent = f
		v29(u)
		u.TextColor3 = v37
		local U = Instance.new("TextButton")
		U.Name = "OpenTab"
		U.Active = true
		U.AutoButtonColor = false
		U.BackgroundTransparency = 1
		U.BorderSizePixel = 0
		U.Size = UDim2.fromScale(1, 1)
		U.Text = ""
		U.ZIndex = 6
		U.Parent = f

		U.MouseEnter:Connect(function()
			v5:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = 0.38}):Play()
			v5:Create(g, TweenInfo.new(0.12), {Transparency = 0.22}):Play()
		end)

		U.MouseLeave:Connect(function()
			v5:Create(f, TweenInfo.new(0.12), {BackgroundTransparency = 0.58}):Play()
			v5:Create(g, TweenInfo.new(0.12), {Transparency = 0.62}):Play()
		end)

		f.Parent = m._content
		fn4[3][fn4[5]](m, f)

		K = {Row = f, Label = l, OpenLabel = u, Button = U, Target = nil, Connection = nil, Connection = v19(U, function()
			if K.Target and tbl3.NavigateToOption then
				tbl3.NavigateToOption(K.Target)
			end
		end)}

		m._groupHeaders[q] = K
		return K
	end

	local function fn9(m, q)
		local K = fn6[3][fn6[5]](q)
		local f = m._mirrors[K]
		if f and not f._destroyed then
			return f
		end
		f = q._sourceConfig
		if type(f) ~= "table" then
			return nil
		end
		local g = v44(f)
		g.Name = K
		g.DisplayName = q.DisplayName or q.Name
		g.Save = false
		g.Config = false
		g.Quick = false
		g.Pin = nil
		g.Keybind = nil
		g.QuickName = nil
		g.KeybindGroup = nil
		g.ShowWhen = nil
		g.DependsOn = nil
		g.VisibleWhen = nil
		g.SubOf = nil
		g.ChildOf = nil
		g.Under = nil
		g.Callback = nil
		g.State = q.State

		if not q.State then
			if q.Type ~= "button" then
				return nil
			end
			g.Callback = q._userCallback
		end

		local M
		if not pcall(function()
			M = m:CreateOption(q.Type, g)
		end) or not M then
			return nil
		end
		M._mirrorOf = q
		m._mirrors[K] = M
		return M
	end

	local function fn10(M)
		local m = M._searchResultsSection
		if not m or m._destroyed then
			return
		end
		m._container.Visible = false

		for M, M in pairs(m._groupHeaders or {}) do
			M.Row.Visible = false
		end

		for M, M in pairs(m._mirrors or {}) do
			if M.Instance then
				M.Instance.Visible = false
			end
		end
	end

	tbl3.ActiveScrollTween = nil
	tbl3.NavigationSerial = 0

	tbl3.NavigateToOption = function(m)
		if (((not m or m._destroyed) or not m.Instance) or not m.Section) or m.Section._destroyed then
			return
		end
		local q = m.Section
		local K = q.Tab
		local f = K and K.Window
		if (not K or K._destroyed) or not f then
			return
		end
		tbl3.NavigationSerial = tbl3.NavigationSerial + 1
		local g = tbl3.NavigationSerial

		if tbl3.ActiveScrollTween then
			tbl3.ActiveScrollTween:Cancel()
			tbl3.ActiveScrollTween = nil
		end

		f:SelectTab(K)

		if not q.Expanded then
			q:SetExpanded(true, true)
		end

		task.spawn(function()
			local l = q._heightTween

			if l then
				pcall(function()
					l.Completed:Wait()
				end)
			else
				v6.Heartbeat:Wait()
			end

			v6.Heartbeat:Wait()
			if ((((g ~= tbl3.NavigationSerial) or m._destroyed) or q._destroyed) or K._destroyed) or (f.SelectedTab ~= K) then
				return
			end

			if q._refreshLayout then
				q._refreshLayout()
			end

			K._updateCanvas()
			v6.Heartbeat:Wait()
			local f, l = K.Page, m._visibilityHost or m.Instance
			l = if not l.Visible then q._header else l
			if ((not f or not f.Parent) or not l) or not l.Parent then
				return
			end
			local m = f.CanvasPosition
			local q, K = ((l.AbsolutePosition.Y - f.AbsolutePosition.Y) + m.Y) - (f.AbsoluteSize.Y * 0.28), math.max(0, f.AbsoluteCanvasSize.Y - f.AbsoluteSize.Y)
			q = math.clamp(q, 0, K)
			tbl3.ActiveScrollTween = v5:Create(f, TweenInfo.new(0.46, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(m.X, q)})
			local m = tbl3.ActiveScrollTween
			m:Play()

			pcall(function()
				m.Completed:Wait()
			end)

			if tbl3.ActiveScrollTween == m then
				tbl3.ActiveScrollTween = nil
			end

			if ((g ~= tbl3.NavigationSerial) or not l.Parent) or not l.Visible then
				return
			end
			K = l:FindFirstChild("ChilliSearchNavigationHighlight")

			if K then
				K:Destroy()
			end

			local m = Instance.new("UIStroke")
			m.Name = "ChilliSearchNavigationHighlight"
			m.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			m.Color = v37
			m.LineJoinMode = Enum.LineJoinMode.Round
			m.Thickness = 0.065
			m.Transparency = 1

			pcall(function()
				m.BorderStrokePosition = Enum.BorderStrokePosition.Outer
				m.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			end)

			m.Parent = l
			v5:Create(m, TweenInfo.new(0.16), {Transparency = 0.04}):Play()

			task.delay(0.5, function()
				if m.Parent then
					local q = v5:Create(m, TweenInfo.new(0.28), {Transparency = 1})
					q:Play()

					q.Completed:Connect(function()
						if m.Parent then
							m:Destroy()
						end
					end)
				end
			end)
		end)
	end

	local function fn11(m, q)
		if q == "" then
			fn10[3][fn10[5]](m)
			return
		end
		local K, f = {}, 0

		for g, l in ipairs(m.Window.Tabs) do
			if ((l ~= m) and not l._destroyed) and l.Button.Visible then
				for u, U in ipairs(l.Sections) do
					if not U._destroyed and not U._isSearchResults then
						g, u = {}, tostring(U.DisplayName or U.Name):lower():find(q, 1, true) ~= nil

						for s, s in ipairs(U.Options) do
							if (s.Instance and not s._destroyed) and (f < n4) then
								if u or ((s.DisplayName or s.Name):lower():find(q, 1, true) ~= nil) then
									g[#g + 1] = s
									f += 1
								end
							end
						end

						if #g > 0 then
							K[#K + 1] = {Tab = l, Section = U, Options = g}
						end
					end
				end
			end
		end

		if f == 0 then
			fn10[3][fn10[5]](m)
			return
		end
		local f, g, l, u = fn7[3][fn7[5]](m), {}, {}, 0

		for m, m in ipairs(K) do
			local K = m.Tab.Name .. ("\000" .. m.Section.Name)
			q = fn8[3][fn8[5]](f, K)
			u += 1
			q.Row.LayoutOrder = u
			q.Row.Visible = true
			q.Label.Text = "GO TO  " .. (fn5[3][fn5[5]](m.Tab) .. ("  >  " .. tostring(m.Section.DisplayName or m.Section.Name)))
			q.Target = m.Options[1]
			g[K] = true

			for q, q in ipairs(m.Options) do
				K = fn9[3][fn9[5]](f, q)

				if K and K.Instance then
					u += 1
					K.Instance.LayoutOrder = u
					K.Instance.Visible = true
					l[fn6[3][fn6[5]](q)] = true
				end
			end
		end

		for m, q in pairs(f._groupHeaders) do
			if not g[m] then
				q.Row.Visible = false
			end
		end

		for m, q in pairs(f._mirrors) do
			if not l[m] and q.Instance then
				q.Instance.Visible = false
			end
		end

		f._container.Visible = true

		if not f.Expanded then
			f:SetExpanded(true, false)
		end

		f._refreshHeight()

		if v51[3][v51[5]] then
			v51[3][v51[5]]()
		end
	end

	local n5 = 3
	local n6 = 6
	local n7 = 0.115
	local v52 = nil
	local tbl4 = {}
	local n8 = 0
	local flag = true

	local function fn12()
		if v52[3][v52[5]] and v52[3][v52[5]].Parent then
			return v52[3][v52[5]]
		end
		v52[3][v52[5]] = Instance.new("Frame")
		v52[3][v52[5]].Name = "ChilliNotifyHolder"
		v52[3][v52[5]].Active = false
		v52[3][v52[5]].AnchorPoint = Vector2.new(1, 1)
		v52[3][v52[5]].BackgroundTransparency = 1
		v52[3][v52[5]].BorderSizePixel = 0
		v52[3][v52[5]].ClipsDescendants = false
		v52[3][v52[5]].Position = UDim2.fromScale(0.988, 0.975)
		v52[3][v52[5]].Size = UDim2.fromScale(0.163, 0.74)
		v52[3][v52[5]].ZIndex = 100
		v52[3][v52[5]].Parent = v10
		local m = Instance.new("UIListLayout")
		m.Name = "Layout"
		m.FillDirection = Enum.FillDirection.Vertical
		m.HorizontalAlignment = Enum.HorizontalAlignment.Right
		m.VerticalAlignment = Enum.VerticalAlignment.Bottom
		m.SortOrder = Enum.SortOrder.LayoutOrder
		m.Padding = UDim.new(0.015, 0)
		m.Parent = v52[3][v52[5]]
		return v52[3][v52[5]]
	end

	local function fn13(m)
		for q = #tbl4, 1, -1 do
			if tbl4[q] == m then
				table.remove(tbl4, q)
				return
			end
		end
	end

	local function fn14(m, q)
		if not m or m.Dismissing then
			return
		end
		m.Dismissing = true
		fn13[3][fn13[5]](m)

		if m.Timer then
			pcall(task.cancel, m.Timer)
			m.Timer = nil
		end

		if m.ProgressTween then
			m.ProgressTween:Cancel()
			m.ProgressTween = nil
		end

		if m.CardTween then
			m.CardTween:Cancel()
			m.CardTween = nil
		end

		local K, f = m.Slot, m.Card

		if q then
			if K and K.Parent then
				K:Destroy()
			end

			return
		end

		if ((not K or not K.Parent) or not f) or not f.Parent then
			return
		end
		m.CardTween = v5:Create(f, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.fromScale(2.1, 0.5)})
		m.CardTween:Play()

		task.delay(0.08, function()
			if K.Parent then
				v5:Create(K, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromScale(1, 0)}):Play()
			end
		end)

		task.delay(0.32, function()
			if K.Parent then
				K:Destroy()
			end
		end)
	end

	local function fn15()
		for m = #tbl4, 1, -1 do
			fn14[3][fn14[5]](tbl4[m], true)
		end

		if v52[3][v52[5]] and v52[3][v52[5]].Parent then
			v52[3][v52[5]]:Destroy()
		end

		v52[3][v52[5]] = nil
	end

	v45.SetNotificationsEnabled = function(m)
		m = m ~= false
		if flag[3][flag[5]] == m then
			return m
		end
		flag[3][flag[5]] = m

		if not m then
			fn15[3][fn15[5]]()
		end

		return flag[3][flag[5]]
	end

	v45.AreNotificationsEnabled = function()
		return flag[3][flag[5]]
	end

	v45.Notify = function(m, q, K)
		if not flag[3][flag[5]] then
			return
		end
		local f = fn12[3][fn12[5]]()

		while #tbl4 >= n6 do
			fn14[3][fn14[5]](tbl4[1], true)
		end

		n8[3][n8[5]] += 1
		local g, l = math.max(0, tonumber(K) or n5), Instance.new("Frame")
		l.Name = "NotificationSlot"
		l.Active = false
		l.BackgroundTransparency = 1
		l.BorderSizePixel = 0
		l.ClipsDescendants = false
		l.LayoutOrder = n8[3][n8[5]]
		l.Size = UDim2.fromScale(1, 0)
		l.ZIndex = 100
		l.Parent = f
		f = Instance.new("Frame")
		f.Name = "ChilliNotify"
		f.Active = false
		f.AnchorPoint = Vector2.new(1, 0.5)
		f.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		f.BackgroundTransparency = 0.35
		f.BorderSizePixel = 0
		f.ClipsDescendants = true
		f.Position = UDim2.fromScale(2.1, 0.5)
		f.Size = UDim2.fromScale(1, 1)
		f.ZIndex = 101
		f.Parent = l
		v32(f, Enum.ApplyStrokeMode.Border, 0.045)
		K = Instance.new("Frame")
		K.Name = "Accent"
		K.Active = false
		K.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		K.BorderSizePixel = 0
		K.Position = UDim2.fromScale(0, 0)
		K.Size = UDim2.fromScale(0.026, 1)
		K.ZIndex = 102
		K.Parent = f
		v31(K, "RedGradient", v30)
		K = Instance.new("TextLabel")
		K.Name = "Title"
		K.Active = false
		K.BackgroundTransparency = 1
		K.BorderSizePixel = 0
		K.Position = UDim2.fromScale(0.07, 0.14)
		K.Size = UDim2.fromScale(0.88, 0.28)
		K.Text = tostring(m or "Notification")
		K.TextWrapped = false
		K.TextXAlignment = Enum.TextXAlignment.Left
		K.TextYAlignment = Enum.TextYAlignment.Center
		K.ZIndex = 103
		K.Parent = f
		v28(K, v26)
		m = Instance.new("TextLabel")
		m.Name = "Body"
		m.Active = false
		m.BackgroundTransparency = 1
		m.BorderSizePixel = 0
		m.Position = UDim2.fromScale(0.07, 0.48)
		m.Size = UDim2.fromScale(0.86, 0.3)
		m.Text = tostring(q or "")
		m.TextWrapped = true
		m.TextXAlignment = Enum.TextXAlignment.Left
		m.TextYAlignment = Enum.TextYAlignment.Top
		m.ZIndex = 103
		m.Parent = f
		v29(m)
		m.TextTransparency = 0.28
		q = Instance.new("Frame")
		q.Name = "Track"
		q.Active = false
		q.AnchorPoint = Vector2.new(0.5, 1)
		q.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		q.BackgroundTransparency = 0.45
		q.BorderSizePixel = 0
		q.Position = UDim2.fromScale(0.5, 1)
		q.Size = UDim2.fromScale(1, 0.055)
		q.Visible = g > 0
		q.ZIndex = 102
		q.Parent = f
		m = Instance.new("Frame")
		m.Name = "Fill"
		m.Active = false
		m.AnchorPoint = Vector2.new(0, 0.5)
		m.BackgroundColor3 = Color3.fromRGB(239, 28, 28)
		m.BorderSizePixel = 0
		m.Position = UDim2.fromScale(0, 0.5)
		m.Size = UDim2.fromScale(1, 1)
		m.ZIndex = 103
		m.Parent = q
		local q = {Card = f, CardTween = nil, Dismissing = false, ProgressTween = nil, Slot = l, Timer = nil}
		table.insert(tbl4, q)
		v5:Create(l, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, n7)}):Play()
		q.CardTween = v5:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1, 0.5)})
		q.CardTween:Play()

		if g > 0 then
			q.ProgressTween = v5:Create(m, TweenInfo.new(g, Enum.EasingStyle.Linear), {Size = UDim2.fromScale(0, 1)})
			q.ProgressTween:Play()

			q.Timer = task.delay(g, function()
				q.Timer = nil
				fn14[3][fn14[5]](q, false)
			end)
		end

		return f
	end

	v45.Finalize = function(m, q)
		assert(not m._finalized, "ChilliLibrary:Finalize() chi duoc goi mot lan")
		q = ((type(q) == "table") and q) or {}
		local K = q.Window or m.Window
		local f, g = q.MainTab or (K and K.DefaultTab), q.ShowMainTab == true
		assert(K, "Finalize can Window")
		assert(f, "Finalize can MainTab")
		m._finalized = true

		local function q()
			local l = game:GetService("HttpService")
			local u = tbl.ConfigFolder or "ChilliLibrary"
			local U = u .. "/configs"
			local s, A, k, r = string.gsub(U, "%p", "%%%0"), u .. "/config_state.json", "Default", _G

			pcall(function()
				local Q = type(getgenv)

				if Q == "function" then
					r = getgenv()
				end
			end)

			local function Q(y)
				local Y = if type(r) == "table" then r[y] else nil
				Y = if (type(Y) ~= "function") and (type(_G) == "table") then _G[y] else Y
				return ((type(Y) == "function") and Y) or nil
			end

			local y = {Delete = Q("delfile"), List = Q("listfiles"), MakeFolder = Q("makefolder"), Read = Q("readfile"), Write = Q("writefile")}
			y.Available = ((y.MakeFolder ~= nil) and (y.Read ~= nil)) and (y.Write ~= nil)
			y.CanDelete = y.Delete ~= nil
			y.CanList = y.List ~= nil
			local Y = {}

			local function b(p)
				local o = Y[p]

				if y.Available then
					local c, P = pcall(y.Read, p)
					if not c then
						return nil
					end
					o = P
				end

				if (type(o) ~= "string") or (o == "") then
					return nil
				end

				local p, c = pcall(function()
					return l:JSONDecode(o)
				end)

				return (p and c) or nil
			end

			local function p(o, c)
				local P, t = pcall(function()
					return l:JSONEncode(c)
				end)

				if not P then
					return false, "JSON encode failed: " .. tostring(t)
				end

				if y.Available then
					local c, P = pcall(y.Write, o, t)
					if not c then
						return false, "Write failed: " .. tostring(P)
					end
				else
					Y[o] = t
				end

				return true
			end

			local function o(c)
				if y.Available then
					if not y.CanDelete then
						return false, "Delete is not supported by this executor."
					end
					local P, t = pcall(y.Delete, c)
					if not P then
						return false, "Delete failed: " .. tostring(t)
					end
				else
					Y[c] = nil
				end

				return true
			end

			local function c(P)
				return U .. ("/" .. (P .. ".json"))
			end

			local function P(t)
				local x = tostring(t or ""):match("^%s*(.-)%s*$") or ""
				if x == "" then
					return nil, "Enter a config name."
				end
				t = utf8.len(x)
				if not t or (t > 48) then
					return nil, "Config name is limited to 48 characters."
				end

				if (((x == ".") or (x == "..")) or (x:find("[<>:\"/\\|?*%c]"))) or (x:find("[%.%s]$")) then
					return nil, "Config name contains invalid file characters."
				end
				t = x:upper()
				local V = t:match("^([^%.]+)") or t
				if ((((((V == "CON") or (V == "PRN")) or (V == "AUX")) or (V == "NUL")) or (V == "CLOCK$")) or (V:match("^COM[1-9]$"))) or (V:match("^LPT[1-9]$")) then
					return nil, "This config name is reserved by Windows."
				end
				return x
			end

			local function t()
				local x = {[k:lower()] = k}

				if y.Available and y.CanList then
					local V, W = pcall(y.List, U)

					if V and (type(W) == "table") then
						for V, C in ipairs(W) do
							V = tostring(C):gsub("\\", "/"):match("([^/]+)%.json$")

							if V and (V ~= "") then
								x[V:lower()] = V
							end
						end
					end
				else
					for V in pairs(Y) do
						local Y = tostring(V):gsub("\\", "/"):match("^" .. (s .. "/([^/]+)%.json$"))

						if Y and (Y ~= "") then
							x[Y:lower()] = Y
						end
					end
				end

				local s = {}

				for Y, Y in pairs(x) do
					if Y:lower() ~= k:lower() then
						table.insert(s, Y)
					end
				end

				table.sort(s, function(Y, x)
					return Y:lower() < x:lower()
				end)

				table.insert(s, 1, k)
				return s
			end

			local function s(Y)
				local x = tostring(Y):lower()

				for V, V in ipairs(t()) do
					if V:lower() == x then
						return V
					end
				end

				x = P(Y)
				if x and (type(b(c(x))) == "table") then
					return x
				end
				return nil
			end

			local function Y()
				local x = 1
				local V = "Default " .. tostring(x)

				while s(V) do
					x += 1
					V = "Default " .. tostring(x)
				end

				return V
			end

			local function x(V, W)
				local C = type(V)
				if ((C == "boolean") or (C == "number")) or (C == "string") then
					return V
				end

				if C ~= "table" then
					return nil
				end
				W = W or {}
				if W[V] then
					return nil
				end
				W[V] = true
				C = {}

				for a, j in pairs(V) do
					if (type(a) == "string") or (type(a) == "number") then
						local G = x(j, W)

						if G ~= nil then
							C[a] = G
						end
					end
				end

				W[V] = nil
				return C
			end

			local V = {Active = k, AutoLoad = true, AutoSave = true, Loading = false, Startup = k}

			(function()
				if not y.Available then
					return
				end
				pcall(y.MakeFolder, u)
				pcall(y.MakeFolder, U)
			end)()

			local u = b(A)

			if type(u) == "table" then
				if type(u.AutoSave) == "boolean" then
					V.AutoSave = u.AutoSave
				end

				if type(u.AutoLoad) == "boolean" then
					V.AutoLoad = u.AutoLoad
				end

				if type(u.StartupConfig) == "string" then
					V.Startup = u.StartupConfig
				elseif type(u.SelectedConfig) == "string" then
					V.Startup = u.SelectedConfig
				end
			end

			local function U()
				return p(A, {Version = 2, AutoLoad = V.AutoLoad, AutoSave = V.AutoSave, StartupConfig = V.Startup})
			end

			local function A()
				local y = {}

				for W, C in ipairs(K.Tabs) do
					if not C._destroyed then
						W = {}

						for a, j in ipairs(C.Sections) do
							if not j._destroyed then
								a = {}

								for G, I in ipairs(j.Options) do
									if ((not I._destroyed and not I._configIgnored) and I._controller.GetValue) and not (I.State and I.State._registered) then
										local h, w = pcall(function()
											return I:Get()
										end)

										if h and (w ~= nil) then
											G = x(w)

											if G ~= nil then
												local h = {Type = I.Type, Value = G}

												if I._controller.GetUnit then
													local G, w = pcall(function()
														return I:GetUnit()
													end)

													if G and (type(w) == "string") then
														h.Unit = w
													end
												end

												a[I.Name] = h
											end
										end
									end
								end

								if next(a) ~= nil then
									W[j.Name] = a
								end
							end
						end

						if next(W) ~= nil then
							y[C.Name] = W
						end
					end
				end

				return y
			end

			local function y()
				local W = {}

				for C, a in ipairs(K.States) do
					if not a._destroyed and not a._configIgnored then
						C = x(a:Get())

						if C ~= nil then
							W[a.Name] = {Value = C}
						end
					end
				end

				return W
			end

			local W, C

			local function a()
				if W then
					return
				end
				W = y()
				C = A()
			end

			local j, G, I, h, w, n, e, B, z
			local v, i = 0, "This config loads next time; use Load Config to load now"

			local function N(J)
			end

			local function J()
				local d, E = U()

				if not d then
					N("Config state save failed: " .. tostring(E))
				end

				return d, E
			end

			local function U()
				if j and not j._destroyed then
					j:Set("Startup Config: " .. V.Startup, false)
				end

				if j and not j._destroyed then
					j:SetNote(((V.Startup:lower() ~= V.Active:lower()) and i) or "")
				end
			end

			local function d()
				if e and not e._destroyed then
					e:SetNote("Save: " .. V.Active)
				end

				if B and not B._destroyed then
					B:SetNote("Auto save: " .. V.Active)
				end

				if z and not z._destroyed then
					z:SetNote("Auto load: " .. V.Startup)
				end
			end

			local function E(D)
				local O = {}

				for T = 1, 4, 1 do
					local _ = D[T]

					if _ and not _._destroyed then
						table.insert(O, _)
					end
				end

				return O
			end

			local function D()
				local O, T = t(), {I, h, w, n}

				for _, _ in ipairs((E(T))) do
					_:SetOptions(O, nil, false)
				end

				U()
				d()
			end

			local function O(T)
				local _ = {I, w, n}

				for S, S in ipairs((E(_))) do
					S:Set(T, false)
				end
			end

			local function E(T, _, S)
				local X, F = P(T)

				if not X then
					if _ ~= false then
						N(F)
					end

					return false, F
				end

				T, F = p(c(X), {Version = 2, Profile = X, SavedAt = os.time(), States = (S and S.States) or (y()), Values = (S and S.Values) or (A())})

				if T and (_ ~= false) then
					N("Saved: " .. X)
				elseif not T and (_ ~= false) then
					N(F)
				end

				return T, F
			end

			local A

			local function y(p)
				for T, T in ipairs(K.Tabs) do
					if not T._destroyed then
						for _, _ in ipairs(T.Sections) do
							if not _._destroyed then
								for T, T in ipairs(_.Options) do
									if (not T._destroyed and T._visibilityDependencies) and (#T._visibilityDependencies > 0) then
										T:_ApplyVisibility(p)
									end
								end
							end
						end
					end
				end
			end

			local function p(T, _)
				v += 1
				local S = s(T)

				if not S then
					local X = "Config does not exist: " .. tostring(T)

					if _ ~= false then
						N(X)
					end

					return false, X
				end

				T = b(c(S))

				if (type(T) ~= "table") or ((type(T.Values) ~= "table") and (type(T.States) ~= "table")) then
					local X = "Config file is empty or invalid."

					if _ ~= false then
						N(X)
					end

					return false, X
				end

				a()
				local X, F, R, Z = ((type(T.States) == "table") and T.States) or {}, ((type(T.Values) == "table") and T.Values) or {}, W or {}, C or {}

				local function T(H, L, MB)
					local mB = ((type(H) == "table") and H[MB]) or nil
					if (type(mB) == "table") and (mB.Value ~= nil) then
						return mB
					end
					mB = ((type(L) == "table") and L[MB]) or nil
					if (type(mB) == "table") and (mB.Value ~= nil) then
						return mB
					end
					return nil
				end

				V.Loading = true

				local H, L = xpcall(function()
					local MB = {}

					for mB, qB in ipairs(K.States) do
						mB = T(X, R, qB.Name)

						if (not qB._destroyed and not qB._configIgnored) and mB then
							qB:Set(mB.Value, false)
							MB[qB] = true
						end
					end

					for X, R in ipairs(K.Tabs) do
						local mB, qB = F[R.Name], Z[R.Name]

						for F, Z in ipairs(R.Sections) do
							X, F = ((type(mB) == "table") and mB[Z.Name]) or nil, ((type(qB) == "table") and qB[Z.Name]) or nil

							for R, mB in ipairs(Z.Options) do
								R = T(X, F, mB.Name)

								if (((not mB._destroyed and not mB._configIgnored) and R) and mB._controller.SetValue) and not ((mB.State and mB.State._registered) and MB[mB.State]) then
									local T = R.Unit

									if (type(T) == "string") and mB._controller.SetUnit then
										pcall(function()
											mB:SetUnit(T, true)
										end)

										mB:Set(R.Value, true)
									else
										mB:Set(R.Value, false)
									end
								end
							end
						end
					end
				end, function(T)
					return tostring(T)
				end)

				V.Loading = false

				if H then
					V.Active = S
					U()
					d()
					y(false)

					if v3.configLoadedHook then
						local T, X = pcall(v3.configLoadedHook)

						if not T then
							N("Config hook failed: " .. tostring(X))
						end
					end

					local T, X = pcall(A)

					if not T then
						N("Config callback failed: " .. tostring(X))
					end

					if V.AutoSave then
						v += 1
						E(V.Active, false)
					end

					if _ ~= false then
						N("Loaded: " .. S)
					end

					return true
				end

				if _ ~= false then
					N("Load failed: " .. tostring(L))
				end

				return false, L
			end

			A = function()
				local T = {}

				for _, _ in ipairs(K.Tabs) do
					if not _._destroyed then
						for S, S in ipairs(_.Sections) do
							if not S._destroyed then
								for _, _ in ipairs(S.Options) do
									if (not _._destroyed and not _._configIgnored) and _._controller.GetValue then
										local S = _.State

										if (S and S._registered) and not T[S] then
											T[S] = true
											v43(S.Callback, S:Get(), S, nil)
										end

										if ((not S or not S._registered) or (S._primaryOption == _)) and (type(_._userCallback) == "function") then
											v43(_._userCallback, _:Get())
										end
									end
								end
							end
						end
					end
				end
			end

			local function T()
				if not V.AutoSave or V.Loading then
					return
				end
				v += 1
				local _, S = v, V.Active

				task.delay(0.35, function()
					if ((_ ~= v) or not V.AutoSave) or V.Loading then
						return
					end
					local _, X = E(S, false)

					if _ then
						N("Auto-saved: " .. S)
					else
						N("Auto-save failed: " .. tostring(X))
					end
				end)
			end

			v3.optionChangedHook = function(_)
				if _._configIgnored then
					return
				end
				T()
			end

			v3.stateChangedHook = function(_)
				if _._configIgnored then
					return
				end
				T()
			end

			local function T(_)
				_._configIgnored = true

				if _.State and not _.State._registered then
					_.State._configIgnored = true
				end

				return _
			end

			local _, S, X, F = "ChilliLibraryConfig", 1, 1048576, ((Q("setclipboard") or (Q("toclipboard"))) or (Q("set_clipboard"))) or (Q("writeclipboard"))

			do
				local R = ((type(r) == "table") and r.Clipboard) or nil

				if (not F and (type(R) == "table")) and (type(R.set) == "function") then
					F = function(r)
						return R.set(r)
					end
				end
			end

			local function r(R, Z, H)
				v45.Notify(tostring(R), tostring(Z), H)
			end

			local function R(Z)
				if type(F) ~= "function" then
					return false, "Clipboard copy is not supported by this executor."
				end
				local H, L = pcall(F, tostring(Z or ""))
				if not H then
					return false, "Clipboard copy failed: " .. tostring(L)
				end
				return true
			end

			local function F(Z)
				local H = s(Z)
				if not H then
					return nil, "Selected config does not exist."
				end
				Z = b(c(H))
				if (type(Z) ~= "table") or ((type(Z.Values) ~= "table") and (type(Z.States) ~= "table")) then
					return nil, "Selected config file is empty or invalid."
				end
				local L = x(Z) or {}
				L.Profile = H

				local Z, MB = pcall(function()
					return l:JSONEncode({Format = _, ExportVersion = S, Name = H, Config = L})
				end)

				if not Z then
					return nil, "Config export encode failed: " .. tostring(MB)
				end
				return MB, nil, H
			end

			local function S(Z)
				local H = tostring(Z or "")
				H = H:match("^%s*(.-)%s*$") or ""
				if H == "" then
					return nil, nil, "Paste exported config JSON first."
				end

				if #H > X then
					return nil, nil, "Import is larger than the 1 MB safety limit."
				end

				local X, L = pcall(function()
					return l:JSONDecode(H)
				end)

				if not X or (type(L) ~= "table") then
					return nil, nil, "Import text is not valid JSON."
				end
				Z, X = nil

				if (L.Format == _) and (type(L.Config) == "table") then
					Z, X = (L.Name or L.Profile) or L.Config.Profile, L.Config
				else
					local l = (type(L.Values) == "table") or (type(L.States) == "table")

					if l then
						Z = L.Profile
					else
						return nil, nil, "JSON is not a Chilli config export."
					end

					X = L
				end

				local l, _ = P(Z)
				if not l then
					return nil, nil, "Exported config name is invalid: " .. tostring(_)
				end

				if (type(X.Values) ~= "table") and (type(X.States) ~= "table") then
					return nil, nil, "Imported config has no States or Values."
				end
				return l, {States = ((type(X.States) == "table") and (x(X.States))) or {}, Values = ((type(X.Values) == "table") and (x(X.Values))) or {}}
			end

			local function l(x, _)
				local X = utf8.len(x)
				if not X or (X <= _) then
					return x
				end
				X = utf8.offset(x, _ + 1)
				return (X and (x:sub(1, X - 1))) or x
			end

			local function x(_)
				if not s(_) then
					return _
				end
				local X = 1

				while true do
					local Z = "." .. tostring(X)
					local H = l(_, 48 - #Z):gsub("[%.%s]+$", "")
					local l = (if H == "" then "Imported" else H) .. Z
					if not s(l) then
						return l
					end
					X += 1
				end
			end

			local function l()
				a()
				v += 1
				V.Loading = true

				local _, X = xpcall(function()
					local Z = {}

					for H, L in ipairs(K.States) do
						H = W[L.Name]

						if ((not L._destroyed and not L._configIgnored) and (type(H) == "table")) and (H.Value ~= nil) then
							L:Set(H.Value, false)
							Z[L] = true
						end
					end

					for W, H in ipairs(K.Tabs) do
						W = C[H.Name]

						if type(W) == "table" then
							for C, L in ipairs(H.Sections) do
								C = W[L.Name]

								if type(C) == "table" then
									for W, W in ipairs(L.Options) do
										local H = C[W.Name]

										if ((((not W._destroyed and not W._configIgnored) and (type(H) == "table")) and (H.Value ~= nil)) and W._controller.SetValue) and not ((W.State and W.State._registered) and Z[W.State]) then
											if (type(H.Unit) == "string") and W._controller.SetUnit then
												pcall(function()
													W:SetUnit(H.Unit, true)
												end)

												W:Set(H.Value, true)
											else
												W:Set(H.Value, false)
											end
										end
									end
								end
							end
						end
					end
				end, function(W)
					return tostring(W)
				end)

				V.Loading = false
				if not _ then
					N("Reset failed: " .. tostring(X))
					return
				end
				y(false)

				if v3.configLoadedHook then
					pcall(v3.configLoadedHook)
				end

				pcall(A)

				if V.AutoSave then
					v += 1
					E(V.Active, false)
				end

				N("All features reset to defaults.")
			end

			local A = {Settings = true, Quick = true, Config = true}

			local function y()
				local W = 0

				for C, C in ipairs(K.Tabs) do
					if not C._destroyed and not A[C.Name] then
						for A, A in ipairs(C.Sections) do
							if not A._destroyed then
								for C, C in ipairs(A.Options) do
									if (((not C._destroyed and not C._configIgnored) and ((C.Type == "toggle") or (C.Type == "switch"))) and C._controller.GetValue) and (C:Get() == true) then
										C:Set(false)
										W += 1
									end
								end
							end
						end
					end
				end

				return W
			end

			Q = K:GetTab("Settings")

			if Q then
				u = Q:CreateSection({Name = "Defaults", Expanded = true})
				u:CreateButton({Name = "Reset to Defaults", ButtonText = "Reset", ConfirmText = "Done!", Note = "Reset every feature to its built-in default", Quick = false, Callback = l})

				u:CreateButton({Name = "Turn Off All Toggles", ButtonText = "Turn Off", ConfirmText = "Done!", Note = "Switch off every enabled toggle in the feature tabs", Callback = function()
					N(("Turned off %d toggle(s)."):format((y())))
				end})
			end

			u = K:CreateTab({Name = "Config", Side = "Right"})
			l = u:CreateSection("Config")
			j = T(l:CreateLabel({Name = "Startup Config", Text = "Startup Config: " .. V.Startup, Note = ((V.Startup:lower() ~= V.Active:lower()) and i) or ""}))
			U()

			B = T(l:CreateToggle({Name = "Auto Save Config", Default = V.AutoSave, Note = "Auto save: " .. V.Active, Callback = function(A)
				V.AutoSave = A
				d()
				if not J() then
					return
				end

				if A then
					local A, y = E(V.Active, false)
					if not A then
						N("Auto Save enable failed: " .. tostring(y))
						return
					end
					N("Auto Save enabled: " .. V.Active)
				else
					N("Auto Save disabled.")
				end
			end}))

			z = T(l:CreateToggle({Name = "Auto Load Config", Default = V.AutoLoad, Note = "Auto load: " .. V.Startup, Callback = function(A)
				V.AutoLoad = A
				d()
				if not J() then
					return
				end

				if A then
					D()

					if p(V.Startup, true) and V.AutoSave then
						E(V.Active, false)
					end
				else
					N("Auto Load disabled.")
				end
			end}))

			Q = u:CreateSection("Profiles")
			G = T(Q:CreateInput({Name = "New Config Name", Placeholder = "New config name...", Default = ""}))

			T(Q:CreateButton({Name = "Create New Config", ButtonText = "Create New", ConfirmText = "", Note = "New config copies current settings", Callback = function()
				local A, y, W = tostring(G:Get() or ""):match("^%s*(.-)%s*$") or ""

				if A == "" then
					W = (Y())
				else
					W, y = P(A)
				end

				if not W then
					N(y)
					return
				end

				if s(W) then
					N("Config name already exists.")
					return
				end
				A, y = E(W, false)
				if not A then
					N(y)
					return
				end
				y = J()
				G:Set("", false)
				D()
				O(W)

				if y then
					N("Created from current settings: " .. (W .. ". Open Load Config to make it active."))
				end
			end}))

			h = T(Q:CreateActionMultiDropdown({Name = "Delete Config", Options = t(), Default = {}, Hint = "Tick the configs to remove, then press Delete", ButtonText = "Delete", Callback = function(A)
				local y = ((type(A) == "table") and A) or {A}
				if #y == 0 then
					N("Tick at least one config to delete.")
					return
				end
				local Y, P, W, C, j, G = {}, {}, {}, {}, false, false

				for i, _ in ipairs(y) do
					i = tostring(_)

					if i:lower() == k:lower() then
						table.insert(P, i)
					else
						_ = s(i)

						if not _ then
							table.insert(W, i)
						else
							v += 1
							local v, i = o(c(_))

							if v then
								table.insert(Y, _)
								j, G = if _:lower() == V.Active:lower() then true else j, if _:lower() == V.Startup:lower() then true else G
							else
								table.insert(C, _ .. (" (" .. (tostring(i) .. ")")))
							end
						end
					end
				end

				if G then
					V.Startup = k
				end

				if j then
					if not p(k, false) then
						V.Active = k
						y, A = E(k, false)

						if not y then
							D()
							N("Deleted " .. (table.concat(Y, ", ") .. ("; default recovery failed: " .. tostring(A))))
							return
						end
					end
				end

				G = J()
				D()

				if h and not h._destroyed then
					h:Set({}, false)
				end

				if not G then
					return
				end
				j = {}

				if #Y > 0 then
					table.insert(j, "Deleted: " .. table.concat(Y, ", "))
				end

				if #P > 0 then
					table.insert(j, "Default config cannot be deleted")
				end

				if #W > 0 then
					table.insert(j, "Not found: " .. table.concat(W, ", "))
				end

				if #C > 0 then
					table.insert(j, "Failed: " .. table.concat(C, ", "))
				end

				if #j == 0 then
					table.insert(j, "Nothing was deleted.")
				end

				N(table.concat(j, " | "))
			end}))

			w = T(Q:CreateActionDropdown({Name = "Set Startup Config", Options = t(), Default = V.Startup, Hint = "Pick a config to auto load next time, then press Set", ButtonText = "Set Startup", Callback = function(A)
				local y = s(A)

				if not y then
					N("That config no longer exists.")
					D()
					return
				end

				V.Startup = y
				if not J() then
					return
				end
				U()
				d()
				N("Startup config set: " .. y)
			end}))

			I = T(Q:CreateActionDropdown({Name = "Load Config", Options = t(), Default = V.Active, Hint = "Pick a config, then press Load to apply it now", ButtonText = "Load", Callback = function(U)
				p(U, true)
			end}))

			e = T(Q:CreateButton({Name = "Save Config", ButtonText = "Save", ConfirmText = "", Note = "Save: " .. V.Active, Callback = function()
				E(V.Active, true)
			end}))

			l, Q = u:CreateSection({Name = "Import / Export", Expanded = true}), t()
			u = s(V.Active) or Q[1]

			n = T(l:CreateActionDropdown({Name = "Export Config", Options = Q, Default = u, Hint = "Pick a config, then press Export to copy its text", ButtonText = "Export", Callback = function(U)
				local A, Q, y = F(((s(U) or (s(n and (n:Get())))) or (s(V.Active))) or t()[1])

				if not A then
					N("Export failed: " .. tostring(Q))
					r("Export Failed", Q)
					return
				end

				Q, U = R(A)

				if not Q then
					N(U)
					r("Export Failed", U)
					return
				end

				N("Exported to clipboard: " .. y)
				r("Config Exported", y .. " was copied to the clipboard.")
			end}))

			if u then
				n:Set(u, false)
			end

			local u = T(l:CreateInput({Name = "Import Config Text", Placeholder = "Paste exported config JSON...", Default = ""}))

			T(l:CreateButton({Name = "Import Config", ButtonText = "Import", ConfirmText = "", Note = "Creates a config only; use Load Config or Set Startup after", Quick = false, Callback = function()
				local l, U, A = S(u:Get())

				if not l then
					N("Import failed: " .. tostring(A))
					r("Import Failed", A)
					return
				end

				A = x(l)
				local Q, y = E(A, false, U)

				if not Q then
					N("Import failed: " .. tostring(y))
					r("Import Failed", y)
					return
				end

				Q, l = J()
				u:Set("", false)
				D()
				O(A)

				if not Q then
					U = "Imported as " .. (A .. (", but config state save failed: " .. tostring(l)))
					N(U)
					r("Imported With Warning", U)
					return
				end

				Q = "Imported: " .. (A .. ". Open Load Config to apply, or Set Startup Config for Auto Load.")
				N(Q)
				r("Config Imported", Q, 5)
			end}))

			d()
			V.AutoSaveOption = B
			V.AutoLoadOption = z
			f:Select()

			task.defer(function()
				v6.Heartbeat:Wait()
				a()

				if type(b(c(k))) ~= "table" then
					local l, u = E(k, false)
					if not l then
						N("Default config create failed: " .. tostring(u))
						return
					end
				end

				local l = s(V.Startup)

				if l then
					V.Startup = l
				else
					V.Startup = k
				end

				if not J() then
					return
				end
				D()
				O(V.Startup)

				if V.AutoLoad then
					p(V.Startup, true)

					if V.AutoSave then
						E(V.Active, false)
					end
				else
					N("Ready. Startup " .. (V.Startup .. ("; Active " .. V.Active)))
				end
			end)
		end

		(function()
			local l = (tbl.Namespace and ("ChilliQuick_" .. tbl.Namespace)) or "ChilliQuickBar"
			local u = {button = true, toggle = true, switch = true, slider = true, slidebar = true, input = true, textbox = true}
			local U = {button = true, toggle = true, switch = true}
			local s = 5
			local A = 0.078
			local k = 0.032
			local r = 0.022
			local Q = 0.005
			local y = {0.023, 0.303, 0.7}
			local Y = {0.023, 0.023, 0.42}
			local b = 0.24
			local p = 0.1
			local o = (v4.TouchEnabled and not v4.KeyboardEnabled) and not v4.MouseEnabled
			local c = (o and 150) or 120
			local P, t, x = c / 100, {true, true, true, true, true}, {Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", KeypadZero = "Num0", KeypadOne = "Num1", KeypadTwo = "Num2", KeypadThree = "Num3", KeypadFour = "Num4", KeypadFive = "Num5", KeypadSix = "Num6", KeypadSeven = "Num7", KeypadEight = "Num8", KeypadNine = "Num9", LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift", LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter", Space = "Space", Backspace = "Back"}

			local function V(W)
				if not W then
					return nil
				end
				return x[W] or (tostring(W))
			end

			for x, x in ipairs(v8:GetChildren()) do
				if x:IsA("ScreenGui") and (x.Name == l) then
					x:Destroy()
				end
			end

			local function x(W)
				for C, C in ipairs(K.Tabs) do
					if not C._destroyed then
						for a, a in ipairs(C.Sections) do
							if not a._destroyed then
								for j, j in ipairs(a.Options) do
									if not j._destroyed and j.Instance then
										W(j, a, C)
									end
								end
							end
						end
					end
				end
			end

			local function W(C)
				return (u[C.Type] == true) and (C._quickIgnored ~= true)
			end

			local function u(C)
				return (U[C.Type] == true) and (C._quickIgnored ~= true)
			end

			local function U(C)
				return ("%s > %s > %s"):format(C.Section.Tab.Name, C.Section.Name, C.Name)
			end

			local function C(a)
				local j

				x(function(G)
					local I = not j and (U(G) == a)

					if I then
						j = G
					end
				end)

				return j
			end

			local function a(j)
				if typeof(j) == "EnumItem" then
					return j
				end
				local G = tostring(j or "")
				if G == "" then
					return nil
				end

				local j, I = pcall(function()
					return Enum.KeyCode[G]
				end)

				return (j and I) or nil
			end

			local j = {}

			local function G(I)
				local h = j[I]
				if not h or not h.Parent then
					return
				end
				local I = h:FindFirstChildOfClass("UIScale")
				if not I then
					return
				end
				v5:Create(I, TweenInfo.new(0.055, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.94}):Play()

				task.delay(0.07, function()
					if I.Parent then
						v5:Create(I, TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
					end
				end)
			end

			local function I(h)
				if not h or h._destroyed then
					return
				end

				if h.Type == "button" then
					h:Press()
				else
					h:Set(h:Get() ~= true)
				end
			end

			local h, w, n = {}, {}, {}

			x(function(e)
				if not W(e) then
					return
				end
				local B = U(e)

				if e._quickPinDefault then
					table.insert(h, B)
				end

				local z = tonumber(e._quickBarDefault)

				if z then
					n[B] = math.clamp(math.floor(z), 1, 5)
				end

				z = (u(e) and (a(e._quickKeyDefault))) or nil

				if z then
					w[B] = z.Name
				end
			end)

			local function a(e)
				local B = {}

				for z, v in ipairs(e or {}) do
					B[z] = v
				end

				return B
			end

			local function e(B)
				local z = {}

				for v, i in pairs(B or {}) do
					z[v] = i
				end

				return z
			end

			local B = v45.ManualQuickDefaults

			if (type(B) == "table") and (type(B.PinnedFeatures) == "table") then
				h = a(B.PinnedFeatures)
			end

			if (type(B) == "table") and (type(B.Keybinds) == "table") then
				w = e(B.Keybinds)
			end

			if (type(B) == "table") and (type(B.PinGroups) == "table") then
				n = e(B.PinGroups)
			end

			local z, v, i, N, J, d, E = if type(B) == "table" then B.LeftCenterHidden == true else false, K:CreateState({Name = "Quick Pinned Features", Default = a(h)}), K:CreateState({Name = "Quick Keybinds", Default = e(w)}), K:CreateState({Name = "Quick Panel Position", Default = {}}), K:CreateState({Name = "Quick Panel Collapsed", Default = {}}), K:CreateState({Name = "Quick Pin Groups", Default = e(n)}), K:CreateState({Name = "Quick Open Key", Default = "LeftControl"})
			local D = K:CreateState({Name = "Quick LeftCenter Hidden", Default = z})

			local function O()
				local T = v:Get()
				return ((type(T) == "table") and T) or {}
			end

			local function T()
				local _ = i:Get()
				return ((type(_) == "table") and _) or {}
			end

			local function _()
				local S = J:Get()
				return ((type(S) == "table") and S) or {}
			end

			local function S(X)
				return _()[tostring(X)] == true
			end

			local function X(F, R)
				local Z = e(_())
				Z[tostring(F)] = R == true
				J:Set(Z)
			end

			local function J(_)
				for F, F in ipairs(O()) do
					if F == _ then
						return true
					end
				end

				return false
			end

			local function _(F, R)
				local Z = a(O())
				local H

				for L, MB in ipairs(Z) do
					if MB == F then
						H = L
						break
					end
				end

				if R and not H then
					table.insert(Z, F)
				elseif not R and H then
					table.remove(Z, H)
				else
					return
				end

				v:Set(Z)
			end

			local function F()
				local R = d:Get()
				return ((type(R) == "table") and R) or {}
			end

			local function R(Z)
				local H = tonumber(F()[Z]) or 1
				return math.clamp(math.floor(H), 1, s)
			end

			local function Z(H, L)
				local MB = e(F())
				MB[H] = math.clamp(math.floor(L), 1, s)
				d:Set(MB)
			end

			local function F()
				local H = {}

				for L, L in ipairs(K.States) do
					H[L] = true
				end

				x(function(L)
					if L.State then
						H[L.State] = true
					end
				end)

				return H
			end

			local function H()
				local L = {}

				local function MB(mB)
					while L[mB] and (L[mB] ~= mB) do
						mB = L[mB]
					end

					return mB
				end

				local function mB(qB, KB)
					if not qB or not KB then
						return
					end
					L[qB] = L[qB] or qB
					L[KB] = L[KB] or KB
					local fB, gB = MB(qB), MB(KB)

					if fB ~= gB then
						L[fB] = gB
					end
				end

				local qB = F()

				for F in pairs(qB) do
					L[F] = L[F] or F
				end

				for F in pairs(qB) do
					for L, L in ipairs(F._links) do
						if L.Connected then
							mB(F, L.Target)
						end
					end

					for L in pairs(F._groups) do
						local qB

						for KB in pairs(L._members) do
							if qB then
								mB(qB, KB)
							else
								qB = KB
							end
						end

						mB(F, qB)
					end
				end

				return MB
			end

			local function F(L, MB)
				if not MB then
					return nil
				end
				local mB = C(L)
				if not mB then
					return nil
				end
				local qB, KB = H(), mB._keybindGroup
				local H = (mB.State and (qB(mB.State))) or nil

				for fB, gB in pairs(T()) do
					if (gB == MB) and (fB ~= L) then
						mB = C(fB)

						if mB then
							if KB and (mB._keybindGroup == KB) then
								return mB
							end

							if (H and mB.State) and (qB(mB.State) == H) then
								return mB
							end
						end
					end
				end

				return nil
			end

			local function H(L, MB)
				if (MB and (F(L, MB.Name))) or nil then
					return false
				end
				local F = e(T())
				F[L] = (MB and MB.Name) or nil
				i:Set(F)
				return true
			end

			local F = nil

			F = function(L, MB, mB, qB, KB)
				local fB = Instance.new("Frame")
				fB.Name = "Switch"
				fB.Active = false
				fB.AnchorPoint = Vector2.new(MB, 0.5)
				fB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				fB.BorderSizePixel = 0
				fB.Position = UDim2.fromScale(mB, 0.5)
				fB.Size = UDim2.fromScale(qB, KB)
				fB.ZIndex = 6
				fB.Parent = L
				v32(fB, Enum.ApplyStrokeMode.Border, 0.06)
				local L = Instance.new("UIGradient")
				L.Name = "OFF"
				L.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
				L.Rotation = 90
				L.Transparency = NumberSequence.new(0.6)
				L.Parent = fB
				local MB = Instance.new("UIGradient")
				MB.Name = "ON"
				MB.Color = v34
				MB.Rotation = 90
				MB.Parent = fB
				local KB = Instance.new("Frame")
				KB.Name = "Hold"
				KB.Active = false
				KB.AnchorPoint = Vector2.new(0.5, 0.5)
				KB.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
				KB.BorderSizePixel = 0
				KB.Size = UDim2.fromScale(0.72, 0.72)
				KB.ZIndex = 7
				KB.Parent = fB
				v32(KB, Enum.ApplyStrokeMode.Border, 0.09)
				mB = Instance.new("UIAspectRatioConstraint")
				mB.AspectRatio = 1
				mB.AspectType = Enum.AspectType.FitWithinMaxSize
				mB.DominantAxis = Enum.DominantAxis.Width
				mB.Parent = KB
				qB = Instance.new("Frame")
				qB.Name = "Color"
				qB.Active = false
				qB.AnchorPoint = Vector2.new(0.5, 0)
				qB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				qB.BorderSizePixel = 0
				qB.Position = UDim2.fromScale(0.5, 0)
				qB.Size = UDim2.fromScale(1, 0.9)
				qB.ZIndex = 8
				qB.Parent = KB

				return fB, function(mB, qB)
					L.Enabled = not mB
					MB.Enabled = mB
					local L = UDim2.fromScale((mB and 0.72) or 0.28, 0.5)

					if qB == false then
						KB.Position = L
					else
						v5:Create(KB, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = L}):Play()
					end
				end
			end

			local function L(MB, mB, qB, KB, fB, gB)
				local lB = Instance.new("TextButton")
				lB.AutoButtonColor = false
				lB.Text = ""
				lB.Name = "KeyChip"
				lB.Active = false
				lB.Selectable = false
				lB.AnchorPoint = Vector2.new(mB, 0.5)
				lB.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				lB.BackgroundTransparency = 0.35
				lB.BorderSizePixel = 0
				lB.Position = UDim2.fromScale(qB, 0.5)
				lB.Size = UDim2.fromScale(KB, fB)
				lB.Text = ""
				lB.TextWrapped = false
				lB.ZIndex = gB
				lB.Parent = MB
				v29(lB)
				v32(lB, Enum.ApplyStrokeMode.Border, 0.1)
				return lB
			end

			local function MB(mB, qB)
				if not qB then
					return
				end
				local KB = Instance.new("TextLabel")
				KB.Name = "BarKeyChip"
				KB.Active = false
				KB.AnchorPoint = Vector2.new(0, 0.5)
				KB.BackgroundTransparency = 1
				KB.BorderSizePixel = 0
				KB.Position = UDim2.fromScale(0.025, 0.485)
				KB.Size = UDim2.fromScale(0.153, 0.612)
				KB.Text = "[" .. (tostring(qB) .. "]")
				KB.TextWrapped = false
				KB.TextXAlignment = Enum.TextXAlignment.Left
				KB.TextYAlignment = Enum.TextYAlignment.Center
				KB.ZIndex = 6
				KB.Parent = mB
				v29(KB)
				KB.TextColor3 = Color3.fromRGB(190, 190, 190)
				return KB
			end

			local mB = nil
			local qB = nil

			qB = function()
				local KB, fB = T(), v4.KeyboardEnabled

				x(function(gB)
					local lB = gB._mirrorOf
					lB = if lB and lB._destroyed then nil else lB
					if not u(lB or gB) then
						return
					end
					local uB = gB.Instance:FindFirstChild("Main")
					if not uB then
						return
					end
					local UB, sB, AB, kB = uB:FindFirstChild("Label"), uB:FindFirstChild("Note"), uB:FindFirstChild("OptionKeyChip"), (fB and (V(KB[U(lB or gB)]))) or nil

					if not kB then
						if AB then
							AB:Destroy()
						end

						if UB and gB._quickLabelSize then
							UB.Size = gB._quickLabelSize
						end

						if sB and gB._quickNoteSize then
							sB.Size = gB._quickNoteSize
						end

						gB._quickLabelSize = nil
						gB._quickNoteSize = nil
						return
					end

					local KB, fB = ((gB.Type == "button") and 0.772) or 0.822, 0.082
					local rB = KB - fB
					local QB = (((sB and (sB:IsA("TextLabel"))) and sB.Visible) and ((0.42 * v39) / v35)) or 0.42

					if not AB then
						AB = L(uB, 1, KB, fB, QB, 7)
						AB.Name = "OptionKeyChip"
						AB.Active = true
						v40(AB, 1.06, 0.94)
						local L = U(lB or gB)

						v19(AB, function()
							mB = L
							AB.Text = "?"
						end)
					end

					AB.Position = UDim2.fromScale(KB, 0.5)
					AB.Size = UDim2.fromScale(fB, QB)
					AB.Text = kB
					kB = rB - 0.015

					if UB then
						if not gB._quickLabelSize then
							gB._quickLabelSize = UB.Size
						end

						fB, lB = gB._quickLabelSize, math.max(0.12, kB - UB.Position.X.Scale)
						UB.Size = UDim2.new(math.min(fB.X.Scale, lB), fB.X.Offset, fB.Y.Scale, fB.Y.Offset)
					end

					if sB and (sB:IsA("TextLabel")) then
						if not gB._quickNoteSize then
							gB._quickNoteSize = sB.Size
						end

						lB, KB = gB._quickNoteSize, math.max(0.12, kB - sB.Position.X.Scale)
						sB.Size = UDim2.new(math.min(lB.X.Scale, KB), lB.X.Offset, lB.Y.Scale, lB.Y.Offset)
					end
				end)
			end

			v51[3][v51[5]] = qB
			local L = Instance.new("ScreenGui")
			L.Name = l
			L.ResetOnSpawn = false
			L.IgnoreGuiInset = true
			L.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			L.DisplayOrder = 5
			v10.DisplayOrder = L.DisplayOrder + 1
			L.Enabled = false
			L:SetAttribute(v7, true)

			if tbl.Namespace then
				L:SetAttribute("ChilliNamespace", tbl.Namespace)
			end

			L.Parent = v8
			local l, KB = 0.03, 0.97

			local function fB(gB)
				local lB = A * P
				return math.clamp(gB, 0, math.max(0, 0.998 - (lB * KB)))
			end

			local gB

			local function lB()
				local uB, UB, sB = L.AbsoluteSize, v16.AbsoluteSize, v16.AbsolutePosition

				if ((uB.X > 0) and (UB.X > 0)) and (sB.X >= 0) then
					local AB = (sB.X + (UB.X * 2)) - L.AbsolutePosition.X
					gB = math.clamp(AB / uB.X, 0.018, 0.45)
				end

				return gB or 0.11
			end

			local gB

			local function uB()
				local UB, sB, AB = L.AbsoluteSize, v16.AbsoluteSize, v16.AbsolutePosition

				if ((UB.Y > 0) and (sB.Y > 0)) and (AB.X >= 0) then
					local kB = ((AB.Y + sB.Y) + (sB.Y * 0.15)) - L.AbsolutePosition.Y
					gB = math.clamp(kB / UB.Y, 0.1, 0.66)
				end

				return gB or 0.5
			end

			local gB = 0.021
			local UB = false
			local sB = false
			local AB = nil

			AB = function(kB)
				if ((kB ~= 4) and (kB ~= 5)) or (v15:GetAttribute("EffectiveLeftCenterHidden") ~= true) then
					return 0
				end
				return gB - lB()
			end

			local gB

			local function kB(rB, QB)
				local yB, YB, bB = A * P, gB(rB)
				YB -= AB(rB)
				if QB < 0 then
					return ((YB + (yB * l)) - (yB * p)) - (yB * KB), bB
				end
				return ((YB + (yB * KB)) + (yB * p)) - (yB * l), bB
			end

			local function l(p)
				local KB = ((o and Y) or y)[p] or 0.14
				if (p == 1) or (p == 3) then
					return 1, KB
				end

				if p == 2 then
					if o then
						return kB(1, -1)
					end
					return 1, KB
				end

				if p == 4 then
					return lB(), uB()
				end

				if o then
					return kB(4, 1)
				end
				return lB(), math.min(uB() + b, 0.86)
			end

			gB = function(y)
				local Y, b, p = N:Get(), l(y)

				if type(Y) == "table" then
					if tonumber(Y.X) and (tonumber(Y.Y)) then
						if y == 1 then
							b, p = tonumber(Y.X), (tonumber(Y.Y))
						end
					else
						local l = Y[tostring(y)]

						if type(l) == "table" then
							b, p = tonumber(l.X) or b, tonumber(l.Y) or p
						end
					end
				end

				return fB(b + AB(y)), math.clamp(p, 0, 0.98)
			end

			local function l(y, Y, b)
				Y -= AB(y)
				local p, o = N:Get(), {}

				if (type(p) == "table") and not tonumber(p.X) then
					for KB, lB in pairs(p) do
						if type(lB) == "table" then
							o[KB] = {X = lB.X, Y = lB.Y}
						end
					end
				elseif (type(p) == "table") and (tonumber(p.X)) then
					o["1"] = {X = p.X, Y = p.Y}
				end

				o[tostring(y)] = {X = Y, Y = b}
				N:Set(o)
			end

			local y = {}

			local function Y(b)
				local p = Instance.new("Frame")
				p.Name = "QuickBar" .. tostring(b)
				p.Active = false
				p.AnchorPoint = Vector2.new(0, 0)
				p.BackgroundTransparency = 1
				p.BorderSizePixel = 0
				p.ClipsDescendants = false
				p.Size = UDim2.fromScale(A, k)
				p.Visible = false
				p.ZIndex = 2
				p.Parent = L
				local o = Instance.new("TextButton")
				o.Name = "Handle"
				o.Active = true
				o.AutoButtonColor = false
				o.AnchorPoint = Vector2.new(0.5, 0)
				o.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				o.BackgroundTransparency = 0.35
				o.BorderSizePixel = 0
				o.Position = UDim2.fromScale(0.5, 0)
				o.Size = UDim2.fromScale(0.94, 1)
				o.Text = ""
				o.ZIndex = 3
				o.Parent = p
				v32(o, Enum.ApplyStrokeMode.Border, 0.06)
				local KB = Instance.new("Frame")
				KB.Name = "HeaderAccent"
				KB.Active = false
				KB.AnchorPoint = Vector2.new(0.5, 1)
				KB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KB.BackgroundTransparency = 0.08
				KB.BorderSizePixel = 0
				KB.Position = UDim2.fromScale(0.5, 1)
				KB.Size = UDim2.fromScale(1, 0.07)
				KB.ZIndex = 4
				KB.Parent = o
				KB = Instance.new("TextLabel")
				KB.Name = "Title"
				KB.Active = false
				KB.AnchorPoint = Vector2.new(0, 0.5)
				KB.BackgroundTransparency = 1
				KB.BorderSizePixel = 0
				KB.Position = UDim2.fromScale(0.07, 0.5)
				KB.Size = UDim2.fromScale(0.62, 0.55)
				KB.Text = "Quick Bar " .. tostring(b)
				KB.TextWrapped = false
				KB.TextXAlignment = Enum.TextXAlignment.Left
				KB.ZIndex = 4
				KB.Parent = o
				v28(KB, v26)
				local lB = Instance.new("Frame")
				lB.Name = "Body"
				lB.Active = false
				lB.AnchorPoint = Vector2.new(0.5, 0)
				lB.BackgroundTransparency = 1
				lB.BorderSizePixel = 0
				lB.ClipsDescendants = true
				lB.Position = UDim2.fromScale(0.5, 1)
				lB.Size = UDim2.fromScale(1.32, 0)
				lB.ZIndex = 2
				lB.Parent = p
				KB = Instance.new("UIPadding")
				KB.Name = "BodyPadding"
				KB.PaddingLeft = UDim.new(0.03, 0)
				KB.PaddingRight = UDim.new(0.03, 0)
				KB.Parent = lB
				KB = Instance.new("UIListLayout")
				KB.Name = "BodyLayout"
				KB.FillDirection = Enum.FillDirection.Vertical
				KB.HorizontalAlignment = Enum.HorizontalAlignment.Center
				KB.VerticalAlignment = Enum.VerticalAlignment.Top
				KB.SortOrder = Enum.SortOrder.LayoutOrder
				KB.Parent = lB
				local uB = Instance.new("TextButton")
				uB.Name = "Collapse"
				uB.Active = true
				uB.AutoButtonColor = false
				uB.AnchorPoint = Vector2.new(1, 0.5)
				uB.BackgroundTransparency = 1
				uB.BorderSizePixel = 0
				uB.Position = UDim2.fromScale(0.955, 0.5)
				uB.Size = UDim2.fromScale(0.17, 0.6)
				uB.Text = ""
				uB.ZIndex = 4
				uB.Parent = o
				local AB = Instance.new("Frame")
				AB.Name = "Caret"
				AB.Active = false
				AB.AnchorPoint = Vector2.new(0.5, 0.5)
				AB.BackgroundTransparency = 1
				AB.BorderSizePixel = 0
				AB.Position = UDim2.fromScale(0.5, 0.5)
				AB.Size = UDim2.fromScale(0.85, 0.85)
				AB.ZIndex = 4
				AB.Parent = uB
				local kB = Instance.new("UIAspectRatioConstraint")
				kB.AspectRatio = 1
				kB.AspectType = Enum.AspectType.FitWithinMaxSize
				kB.DominantAxis = Enum.DominantAxis.Height
				kB.Parent = AB
				kB = {{0.335355, 45}, {0.664645, -45}}

				for rB, QB in ipairs(kB) do
					rB = Instance.new("Frame")
					rB.Name = "Arm"
					rB.Active = false
					rB.AnchorPoint = Vector2.new(0.5, 0.5)
					rB.BackgroundColor3 = v38
					rB.BorderSizePixel = 0
					rB.Position = UDim2.fromScale(QB[1], 0.535355)
					rB.Rotation = QB[2]
					rB.Size = UDim2.fromScale(0.6657, 0.2)
					rB.ZIndex = 5
					rB.Parent = AB
				end

				local kB = {Panel = p, Body = lB, BodyLayout = KB, Handle = o, Caret = AB, Items = {}, Connections = {}, Index = b, Collapsed = S(b), BodyFraction = 0, SizeTween = nil}

				local function KB()
					kB.Collapsed = not kB.Collapsed
					X(b, kB.Collapsed)

					if kB.SizeTween then
						kB.SizeTween:Cancel()
					end

					local X = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
					kB.SizeTween = v5:Create(lB, X, {Size = UDim2.fromScale(1.32, (kB.Collapsed and 0) or kB.BodyFraction)})
					kB.SizeTween:Play()
					v5:Create(AB, X, {Rotation = (kB.Collapsed and 180) or 0}):Play()
				end

				v19(uB, KB)
				local X, lB = false
				local AB, rB, QB = false, Vector2.new(0, 0), Vector2.new(0, 0)

				o.InputBegan:Connect(function(yB)
					if X or (yB.UserInputState ~= Enum.UserInputState.Begin) then
						return
					end

					if (yB.UserInputType ~= Enum.UserInputType.MouseButton1) and (yB.UserInputType ~= Enum.UserInputType.Touch) then
						return
					end
					local YB, bB, pB = Vector2.new(yB.Position.X, yB.Position.Y), o.AbsolutePosition, o.AbsoluteSize
					if (((YB.X < bB.X) or (YB.X > (bB.X + pB.X))) or (YB.Y < bB.Y)) or (YB.Y > (bB.Y + pB.Y)) then
						return
					end
					bB, pB = uB.AbsolutePosition, uB.AbsoluteSize
					if (((YB.X >= bB.X) and (YB.X <= (bB.X + pB.X))) and (YB.Y >= bB.Y)) and (YB.Y <= (bB.Y + pB.Y)) then
						return
					end
					X, AB = true, false
					lB = ((yB.UserInputType == Enum.UserInputType.Touch) and yB) or nil
					rB = Vector2.new(yB.Position.X, yB.Position.Y)
					QB = Vector2.new(p.Position.X.Scale, p.Position.Y.Scale)
				end)

				v14(v4.InputChanged:Connect(function(o)
					if not X then
						return
					end

					if not ((lB and (o == lB)) or (not lB and (o.UserInputType == Enum.UserInputType.MouseMovement))) then
						return
					end
					local uB = L.AbsoluteSize
					if (uB.X <= 0) or (uB.Y <= 0) then
						return
					end
					local yB = Vector2.new(o.Position.X, o.Position.Y) - rB
					if not AB and (yB.Magnitude < 6) then
						return
					end
					AB = true
					p.Position = UDim2.fromScale(fB(QB.X + (yB.X / uB.X)), math.clamp(QB.Y + (yB.Y / uB.Y), 0, 0.98))
				end))

				v14(v4.InputEnded:Connect(function(o)
					if not X then
						return
					end

					if (o.UserInputType == Enum.UserInputType.MouseButton1) or (o == lB) then
						X, lB = false, nil

						if AB then
							l(b, p.Position.X.Scale, p.Position.Y.Scale)
						else
							KB()
						end
					end
				end))

				return kB
			end

			for l = 1, s, 1 do
				y[l] = Y(l)
			end

			local function l(b)
				for p = #b.Connections, 1, -1 do
					local o = b.Connections[p]

					if o and o.Disconnect then
						o:Disconnect()
					end

					b.Connections[p] = nil
				end

				for p = #b.Items, 1, -1 do
					b.Items[p]:Destroy()
					b.Items[p] = nil
				end
			end

			local function b(p, o, X, KB, fB)
				local lB = Instance.new("TextButton")
				lB.Name = "Item" .. tostring(KB)
				lB.Active = true
				lB.AutoButtonColor = false
				lB.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				lB.BackgroundTransparency = 0.4
				lB.BorderSizePixel = 0
				lB.LayoutOrder = KB
				lB.Size = UDim2.fromScale(0.7121, fB)
				lB.Text = ""
				lB.ZIndex = 3
				lB.Parent = p.Body
				v32(lB, Enum.ApplyStrokeMode.Border, 0.05)
				fB = Instance.new("TextLabel")
				fB.Name = "Label"
				fB.Active = false
				fB.AnchorPoint = Vector2.new(0, 0.5)
				fB.BackgroundTransparency = 1
				fB.BorderSizePixel = 0
				fB.AnchorPoint = Vector2.new(0, 0.5)
				fB.Position = UDim2.fromScale((X and 0.19) or 0.03, 0.5)
				fB.Size = UDim2.fromScale((X and 0.52) or 0.68, 0.72)
				fB.Text = tostring(o:GetQuickName())
				fB.TextWrapped = false
				fB.TextXAlignment = Enum.TextXAlignment.Center
				fB.ZIndex = 4
				fB.Parent = lB
				v29(fB)
				MB(lB, X)
				local X, X = F(lB, 1, 0.955, 0.23, 0.56)
				local KB = false

				local function fB()
					X(o:Get() == true, KB)
					KB = true
				end

				fB()

				if o.State then
					table.insert(p.Connections, o.State:Subscribe(fB))
				end

				v19(lB, function()
					I(o)
				end)

				table.insert(p.Items, lB)
			end

			local function p(o, X, KB, fB, lB)
				local uB = v33(o.Body, X:GetQuickName(), fB)
				uB.Name = "Item" .. tostring(fB)
				uB.Size = UDim2.fromScale(0.7121, lB)
				uB.ZIndex = 3
				fB = uB:FindFirstChild("Main")
				fB = fB and (fB:FindFirstChild("ColorFrame"))
				lB = fB and (fB:FindFirstChild("Label"))

				if lB then
					lB.AnchorPoint = Vector2.new(0.5, 0.5)
					lB.Position = UDim2.fromScale((KB and 0.58) or 0.5, 0.5)
					lB.Size = UDim2.fromScale((KB and 0.78) or 0.94, 0.68)
					lB.TextXAlignment = Enum.TextXAlignment.Center
					lB.Text = tostring(X:GetQuickName())
				end

				MB(uB, KB)

				v19(uB, function()
					I(X)
				end)

				j[U(X)] = uB
				table.insert(o.Items, uB)
			end

			local function o(X, MB)
				local KB, fB = false, 0

				pcall(function()
					KB, fB = X:GetDecimals()
				end)

				MB = tonumber(MB) or 0
				if KB then
					return string.format("%." .. (tostring(fB or 1) .. "f"), MB)
				end
				return tostring(math.round(MB))
			end

			local function X(MB, KB, fB)
				local lB = Instance.new("Frame")
				lB.Name = "Item" .. tostring(KB)
				lB.Active = false
				lB.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				lB.BackgroundTransparency = 0.4
				lB.BorderSizePixel = 0
				lB.LayoutOrder = KB
				lB.Size = UDim2.fromScale(0.7121, fB)
				lB.ZIndex = 3
				lB.Parent = MB.Body
				v32(lB, Enum.ApplyStrokeMode.Border, 0.05)
				table.insert(MB.Items, lB)
				return lB
			end

			local function MB(KB, fB)
				local lB = Instance.new("TextLabel")
				lB.Name = "Label"
				lB.Active = false
				lB.AnchorPoint = Vector2.new(0, 0.5)
				lB.BackgroundTransparency = 1
				lB.BorderSizePixel = 0
				lB.Text = tostring(fB:GetQuickName())
				lB.TextWrapped = false
				lB.TextXAlignment = Enum.TextXAlignment.Left
				lB.TextYAlignment = Enum.TextYAlignment.Center
				lB.ZIndex = 4
				lB.Parent = KB
				v29(lB)
				return lB
			end

			local function KB(fB, lB, uB, AB)
				local kB = X(fB, uB, AB)
				uB = MB(kB, lB)
				uB.Position = UDim2.fromScale(0.035, 0.255)
				uB.Size = UDim2.fromScale(0.67, 0.34)
				uB = lB.Instance and (lB.Instance:FindFirstChild("Main"))
				local AB, rB = uB and (uB:FindFirstChild("Value", true)), uB and (uB:FindFirstChild("Slider", true))
				local uB, QB = AB and (AB:Clone()), rB and (rB:Clone())

				if uB then
					uB.AnchorPoint = Vector2.new(0.5, 0.5)
					uB.Position = UDim2.fromScale(0.84, 0.255)
					uB.Size = UDim2.fromScale(0.25, 0.34)
					uB.ZIndex = 5
					uB.Parent = kB
				end

				if QB then
					QB.Position = UDim2.fromScale(0.5, 0.735)
					QB.Size = UDim2.fromScale(0.92, 0.24)
					QB.ZIndex = 4
					QB.Parent = kB
				end

				local AB, kB = QB and (QB:FindFirstChild("Bar")), QB and (QB:FindFirstChild("Hold"))
				if (not QB or not AB) or not kB then
					return
				end
				QB.Active = true
				AB.Active = true
				kB.Active = true

				local function rB()
					if not kB.Parent or not QB.Parent then
						return
					end
					local yB = math.max(1, QB.AbsoluteSize.Y * 1.38)
					kB.Size = UDim2.fromOffset(yB, yB)
				end

				rB()
				table.insert(fB.Connections, QB:GetPropertyChangedSignal("AbsoluteSize"):Connect(rB))

				local function rB()
					if lB._destroyed then
						return
					end
					local yB, YB = lB:GetRange()
					local bB = tonumber(lB:Get()) or yB
					local pB = ((YB > yB) and (math.clamp((bB - yB) / (YB - yB), 0, 1))) or 0
					yB = math.clamp(pB, 0.0575, 0.9425)
					AB.Size = UDim2.new(yB, 0, 1, 0)
					kB.Position = UDim2.new(yB, 0, 0.5, 0)

					if uB and not uB:IsFocused() then
						uB.RichText = false
						uB.Text = o(lB, bB)
					end
				end

				rB()

				if lB.State then
					table.insert(fB.Connections, lB.State:Subscribe(rB))
				end

				if uB and (uB:IsA("TextBox")) then
					uB.ClearTextOnFocus = false

					uB.FocusLost:Connect(function()
						local o = tonumber(uB.Text)

						if o ~= nil then
							lB:Set(o, true)
						end

						rB()
					end)
				end

				local o, uB = false

				local function yB(YB)
					if lB._destroyed or (QB.AbsoluteSize.X <= 0) then
						return
					end
					local bB, pB, oB = math.clamp((YB - QB.AbsolutePosition.X) / QB.AbsoluteSize.X, 0, 1), lB:GetRange()
					lB:Set(pB + ((oB - pB) * bB), true)
					rB()
				end

				local function lB(rB)
					if o or (rB.UserInputState ~= Enum.UserInputState.Begin) then
						return
					end

					if rB.UserInputType == Enum.UserInputType.MouseButton1 then
						o, uB = true, nil
						yB(rB.Position.X)
					elseif rB.UserInputType == Enum.UserInputType.Touch then
						o, uB = true, rB
						yB(rB.Position.X)
					end
				end

				QB.InputBegan:Connect(lB)
				AB.InputBegan:Connect(lB)
				kB.InputBegan:Connect(lB)

				table.insert(fB.Connections, v4.InputChanged:Connect(function(lB)
					if not o then
						return
					end

					if uB then
						if lB == uB then
							yB(lB.Position.X)
						end
					elseif lB.UserInputType == Enum.UserInputType.MouseMovement then
						yB(lB.Position.X)
					end
				end))

				table.insert(fB.Connections, v4.InputEnded:Connect(function(fB)
					if (fB.UserInputType == Enum.UserInputType.MouseButton1) or (fB == uB) then
						o, uB = false, nil
					end
				end))
			end

			local function o(fB, lB, uB, AB)
				local kB = X(fB, uB, AB)
				uB = MB(kB, lB)
				uB.Position = UDim2.fromScale(0.035, 0.5)
				uB.Size = UDim2.fromScale(0.43, 0.7)
				AB = lB.Instance and (lB.Instance:FindFirstChild("Main"))
				uB = AB and (AB:FindFirstChild("Field", true))
				local X = uB and (uB:Clone())
				local MB = X and (X:FindFirstChild("Input", true))
				if (not X or not MB) or not MB:IsA("TextBox") then
					return
				end
				X.AnchorPoint = Vector2.new(0.5, 0.5)
				X.Position = UDim2.fromScale(0.72, 0.5)
				X.Size = UDim2.fromScale(0.48, 0.62)
				X.ZIndex = 4
				X.Parent = kB
				MB.ClearTextOnFocus = false
				MB.Text = tostring(lB:Get() or "")
				local uB = X:FindFirstChild("Underline", true)

				local function AB(kB)
					v5:Create(X, TweenInfo.new(0.16), {BackgroundTransparency = (kB and 0.42) or 0.6}):Play()

					if uB and (uB:IsA("GuiObject")) then
						v5:Create(uB, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale((kB and 1) or 0, 0.11)}):Play()
					end
				end

				MB.Focused:Connect(function()
					AB(true)
				end)

				local function X()
					if not MB:IsFocused() then
						MB.Text = tostring(lB:Get() or "")
					end
				end

				if lB.State then
					table.insert(fB.Connections, lB.State:Subscribe(X))
				end

				MB.FocusLost:Connect(function()
					AB(false)
					lB:Set(MB.Text, true)
					X()
				end)
			end

			local function X(MB)
				return 1
			end

			local function MB()
				for fB in pairs(j) do
					j[fB] = nil
				end

				local j, fB, lB = v4.KeyboardEnabled, T(), {}

				for uB = 1, s, 1 do
					lB[uB] = {}
				end

				for uB, AB in ipairs(O()) do
					uB = C(AB)

					if uB and (W(uB)) then
						local O = math.clamp(math.floor(tonumber(R(AB)) or 1), 1, s)
						table.insert(lB[O], {Option = uB, KeyName = (j and (V(fB[AB]))) or nil})
					end
				end

				fB = (t[4] and (#lB[4] > 0)) or (t[5] and (#lB[5] > 0))

				if fB and not UB then
					if D:Get() ~= true then
						D:Set(true)
					end
				end

				UB = fB

				for O = 1, s, 1 do
					j = y[O]
					l(j)
					fB = lB[O]
					local l = #fB

					if not t[O] or (l == 0) then
						j.Panel.Visible = false
					else
						local lB, uB, UB, AB = k * P, r * P, Q * P, {}
						local k = math.max(l - 1, 0) * UB

						for l, r in ipairs(fB) do
							local Q = lB * X(r.Option)
							AB[l] = Q
							k += Q
						end

						lB = (uB + UB) + k
						local l = k / lB

						if j.SizeTween then
							j.SizeTween:Cancel()
							j.SizeTween = nil
						end

						j.BodyFraction = l
						j.Panel.Size = UDim2.fromScale(A * P, lB)
						j.Handle.Size = UDim2.fromScale(0.94, uB / lB)
						j.Body.Position = UDim2.fromScale(0.5, (uB + UB) / lB)
						j.Body.Size = UDim2.fromScale(1.32, (j.Collapsed and 0) or l)
						j.BodyLayout.Padding = UDim.new(UB / k, 0)
						j.Caret.Rotation = (j.Collapsed and 180) or 0

						for A, r in ipairs(fB) do
							lB, l = AB[A] / k, r.Option.Type

							if l == "button" then
								p(j, r.Option, r.KeyName, A, lB)
							elseif (l == "toggle") or (l == "switch") then
								b(j, r.Option, r.KeyName, A, lB)
							elseif (l == "slider") or (l == "slidebar") then
								KB(j, r.Option, A, lB)
							elseif (l == "input") or (l == "textbox") then
								o(j, r.Option, A, lB)
							end
						end

						lB, AB = gB(O)
						j.Panel.Position = UDim2.fromScale(lB, AB)
						j.Panel.Visible = true
					end
				end
			end

			local function l(A)
				for k = 1, s, 1 do
					local r, Q = gB(k)
					local b = UDim2.fromScale(r, Q)

					if A then
						v5:Create(y[k].Panel, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = b}):Play()
					else
						y[k].Panel.Position = b
					end
				end
			end

			v14(v15:GetAttributeChangedSignal("EffectiveLeftCenterHidden"):Connect(function()
				l(true)
			end))

			B = Instance.new("TextButton")
			B.Name = "HudSlideToggle"
			B.Active = true
			B.AutoButtonColor = false
			B.AnchorPoint = Vector2.new(0, 0.5)
			B.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			B.BackgroundTransparency = 0.35
			B.BorderSizePixel = 0
			B.Position = UDim2.fromScale(0.004, 0.5)
			B.Size = UDim2.fromScale(0.018, 0.075)
			B.Text = ""
			B.ZIndex = 40
			B.Parent = v15
			v32(B, Enum.ApplyStrokeMode.Border, 0.08)
			v40(B, 1.08, 0.92)
			z = Instance.new("UIAspectRatioConstraint")
			z.AspectRatio = 0.44
			z.AspectType = Enum.AspectType.FitWithinMaxSize
			z.DominantAxis = Enum.DominantAxis.Height
			z.Parent = B
			local A = Instance.new("Frame")
			A.Name = "Caret"
			A.Active = false
			A.AnchorPoint = Vector2.new(0.5, 0.5)
			A.BackgroundTransparency = 1
			A.BorderSizePixel = 0
			A.Position = UDim2.fromScale(0.5, 0.5)
			A.Rotation = 90
			A.Size = UDim2.fromScale(0.62, 0.62)
			A.ZIndex = 41
			A.Parent = B
			Y = Instance.new("UIAspectRatioConstraint")
			Y.AspectRatio = 1
			Y.AspectType = Enum.AspectType.FitWithinMaxSize
			Y.DominantAxis = Enum.DominantAxis.Width
			Y.Parent = A
			Y = {{0.335355, 45}, {0.664645, -45}}

			for k, r in ipairs(Y) do
				k = Instance.new("Frame")
				k.Name = "Arm"
				k.Active = false
				k.AnchorPoint = Vector2.new(0.5, 0.5)
				k.BackgroundColor3 = v38
				k.BorderSizePixel = 0
				k.Position = UDim2.fromScale(r[1], 0.535355)
				k.Rotation = r[2]
				k.Size = UDim2.fromScale(0.6657, 0.2)
				k.ZIndex = 42
				k.Parent = A
			end

			local function k(r)
				sB = D:Get() == true
				v15:SetAttribute("QuickHudHidden", sB)
				v23(sB or v3.chilliIsOpen)
				local Q = (sB and -90) or 90

				if r then
					v5:Create(A, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = Q}):Play()
				else
					A.Rotation = Q
				end

				l(r)
			end

			v19(B, function()
				D:Set(not (D:Get() == true))
			end)

			D:Subscribe(function()
				k(true)
			end)

			local A, r = K:CreateTab({Name = "Quick", DisplayName = "Quick & Keys", Side = "Right"}), K:CreateTab({Name = "Settings", Side = "Right"}):CreateSection({Name = "Interface", Expanded = true})

			v22.ApplyUiSize = function(Q)
				local Y = v10.AbsoluteSize
				if (Y.X <= 0) or (Y.Y <= 0) then
					return
				end
				local b = (tonumber(Q) or 100) / 100
				local Q = v22.Base
				v25((Q.X.Scale * Y.X) * b, (Q.Y.Scale * Y.Y) * b)
			end

			v22.UiSizeOption = r:CreateSlider({Name = "UI Size", Note = "Scales the main window; the corner grip does the same by hand", Min = 60, Max = 160, Default = 100, AllowDecimals = false, Increment = 1, Unit = "%", Quick = false, Callback = function(Q)
				v22.ApplyUiSize(Q)
			end})

			local Q, Y, b, p, o, j, B, z, D, O = v4.KeyboardEnabled, A:CreateSection({Name = "Pin Pad", DisplayName = "Quick Access", Expanded = true}), A:CreateSection({Name = "Pin & Key List", DisplayName = "Quick Bar & Keybinds", Expanded = true}), {}, {}, {}, {}, {}

			b:CreateButton({Name = "Reset Pins", DisplayName = "Reset Quick Access", ButtonText = "Reset", ConfirmText = "Done!", Note = "Restore default items, bars and positions", Quick = false, Callback = function()
				v:Set(a(h))
				d:Set(e(n))
				N:Set({})
			end})

			b:CreateButton({Name = "Reset Keybinds", ButtonText = "Reset", ConfirmText = "Done!", Note = "Restore the defaults set in code", Quick = false, Callback = function()
				i:Set(e(w))
			end})

			local a, h = Y:CreateToggle({Name = "Enable Keybinds", Note = "Turn off to disable every feature hotkey", Default = true, Quick = false}), Y:CreateToggle({Name = "Show Pin Pads", DisplayName = "Show Quick Bars", Note = "Floating quick bars; drag a header to move one", Default = true, Quick = false, Callback = function(w)
				L.Enabled = w == true
			end})

			Y:CreateMultiDropdown({Name = "Visible Quick Bars", DisplayName = "Visible Quick Bars", Options = {"Quick Bar 1", "Quick Bar 2", "Quick Bar 3", "Quick Bar 4", "Quick Bar 5"}, Default = {"Quick Bar 1", "Quick Bar 2", "Quick Bar 3", "Quick Bar 4", "Quick Bar 5"}, Quick = false, SubOf = h, Callback = function(w)
				local n = {}

				for e, X in ipairs(((type(w) == "table") and w) or {}) do
					e = tonumber(tostring(X):match("(%d+)$"))

					if (e and (e >= 1)) and (e <= s) then
						n[e] = true
					end
				end

				t = n
				MB()
			end})

			local t = Y:CreateSlider({Name = "Pad Size", DisplayName = "Quick Bar Size", Min = 60, Max = 200, Default = c, AllowDecimals = false, Increment = 1, Quick = false, Unit = "%", Callback = function(Y)
				P = (tonumber(Y) or c) / 100
				MB()
			end})

			r:CreateToggle({Name = "Notifications", Note = "Show notification cards; turning this off hides every notify", Quick = false, State = K:CreateState({Name = "Notifications", Default = true, Callback = function(Y)
				v45.SetNotificationsEnabled(Y)
			end})})

			r:CreateToggle({Name = "Open On Launch", Note = "Open the UI automatically when the script starts", Quick = false, State = K:CreateState({Name = "Open On Launch", Default = true})})

			local Y = r:CreateButton({Name = "UI Toggle Key", ButtonText = "Rebind", ConfirmText = "", Note = "Current: " .. tostring((V(E:Get()))), Quick = false, Callback = function()
				mB = "__OPEN__"
				O()
			end})

			O = function()
				if not Y._destroyed then
					Y:SetNote(((mB == "__OPEN__") and "Press any key...") or ("Current: " .. tostring(V(E:Get()))))
				end
			end

			local r, w = 6.2, 0.66

			local function n()
			end

			local function e(X, KB, fB, gB)
				local lB, uB = false
				local UB = Instance.new("NumberValue")
				UB.Name = "BarMenuAlpha"
				UB.Value = 0
				UB.Parent = X

				local function sB(AB)
					local kB = v35 + ((r - v35) * AB)
					local r = v35 / kB
					X:SetAttribute("ChilliResponsiveAspect", kB)
					KB.Size = UDim2.fromScale(1, 0.85 / r)
					KB.Position = UDim2.fromScale(0.5, 0.5 / r)
					kB = 0.925 / r
					r = math.max(0, 1 - kB)
					fB.Size = UDim2.fromScale(0.4, r * w)
					fB.Position = UDim2.fromScale(0.985, kB + (r * 0.5))
					fB.Visible = AB > 0.01
					gB.Rotation = 180 * AB
					b._refreshHeight()
				end

				UB.Changed:Connect(sB)
				sB(0)

				local function r(w)
					if lB == w then
						return
					end
					lB = w

					if w then
						v42()
						n()

						function n()
							r(false)
						end

						v3.activeDropdownCloser = n
					else
						if v3.activeDropdownCloser == n then
							v3.activeDropdownCloser = nil
						end

						function n()
						end
					end

					if uB then
						uB:Cancel()
					end

					uB = v5:Create(UB, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Value = (w and 1) or 0})
					uB:Play()

					if b._stabilizeLayout then
						b._stabilizeLayout()
					end

					task.defer(A._updateCanvas)
				end

				return function()
					r(not lB)
				end, function()
					if lB then
						r(false)
					end
				end
			end

			local function r()
				n()

				for w = #j, 1, -1 do
					j[w]()
					j[w] = nil
				end

				for w = #p, 1, -1 do
					o[p[w]] = nil
					z[p[w]] = nil
					p[w]:Destroy()
					p[w] = nil
				end

				for w = #B, 1, -1 do
					B[w] = nil
				end
			end

			local w = fn5[3][fn5[5]]

			local function n(X, KB)
				local fB = Instance.new("Frame")
				fB.Name = "QuickGroup" .. tostring(KB)
				fB.Active = false
				fB.AnchorPoint = Vector2.new(0.5, 0.5)
				fB.BackgroundTransparency = 1
				fB.BorderSizePixel = 0
				fB.LayoutOrder = KB
				fB.Position = UDim2.fromScale(0.5, 0.5)
				fB.Size = UDim2.fromScale(v36, 0.6)
				fB.ZIndex = 3
				KB = Instance.new("UIAspectRatioConstraint")
				KB.AspectRatio = 22
				KB.AspectType = Enum.AspectType.FitWithinMaxSize
				KB.DominantAxis = Enum.DominantAxis.Width
				KB.Parent = fB
				KB = Instance.new("TextLabel")
				KB.Name = "Label"
				KB.Active = false
				KB.AnchorPoint = Vector2.new(0, 0.5)
				KB.BackgroundTransparency = 1
				KB.BorderSizePixel = 0
				KB.Position = UDim2.fromScale(0.025, 0.5)
				KB.Size = UDim2.fromScale(0.6, 0.8)
				KB.Text = X
				KB.TextWrapped = false
				KB.TextXAlignment = Enum.TextXAlignment.Left
				KB.ZIndex = 5
				KB.Parent = fB
				v29(KB)
				KB.TextColor3 = v37
				KB = Instance.new("Frame")
				KB.Name = "Line"
				KB.Active = false
				KB.AnchorPoint = Vector2.new(1, 0.5)
				KB.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				KB.BackgroundTransparency = 0.75
				KB.BorderSizePixel = 0
				KB.Position = UDim2.fromScale(0.985, 0.5)
				KB.Size = UDim2.fromScale(0.34, 0.08)
				KB.ZIndex = 4
				KB.Parent = fB
				fB.Parent = b._content
				table.insert(j, fn4[3][fn4[5]](b, fB))
				table.insert(p, fB)
				table.insert(B, fB)
				return fB
			end

			local function X(KB, fB, gB, lB)
				local uB = U(KB)
				local U = Q and (u(KB))
				local UB, sB, AB = v41("QuickRow" .. tostring(fB), KB:GetQuickName())
				AB.Size = UDim2.fromScale((U and 0.47) or 0.63, 0.64)
				local kB = Instance.new("TextButton")
				kB.Name = "BarPicker"
				kB.Active = true
				kB.AutoButtonColor = false
				kB.AnchorPoint = Vector2.new(1, 0.5)
				kB.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				kB.BackgroundTransparency = 0.5
				kB.BorderSizePixel = 0
				kB.Position = UDim2.fromScale(0.858, 0.5)
				kB.Size = UDim2.fromScale(0.062, 0.55)
				kB.Text = ""
				kB.TextWrapped = false
				kB.ZIndex = 6
				kB.Parent = sB
				v29(kB)
				v32(kB, Enum.ApplyStrokeMode.Border, 0.1)
				v40(kB, 1.04, 0.96)
				AB = Instance.new("Frame")
				AB.Name = "Caret"
				AB.Active = false
				AB.AnchorPoint = Vector2.new(1, 0)
				AB.BackgroundTransparency = 1
				AB.BorderSizePixel = 0
				AB.Position = UDim2.fromScale(0.99, 0.01)
				AB.Size = UDim2.fromScale(0.44, 0.44)
				AB.ZIndex = 8
				AB.Parent = kB
				local rB = Instance.new("UIAspectRatioConstraint")
				rB.AspectRatio = 1
				rB.AspectType = Enum.AspectType.FitWithinMaxSize
				rB.DominantAxis = Enum.DominantAxis.Height
				rB.Parent = AB
				rB = {{0.335355, 45}, {0.664645, -45}}

				for QB, yB in ipairs(rB) do
					QB = Instance.new("Frame")
					QB.Name = "Arm"
					QB.Active = false
					QB.AnchorPoint = Vector2.new(0.5, 0.5)
					QB.BackgroundColor3 = v38
					QB.BorderSizePixel = 0
					QB.Position = UDim2.fromScale(yB[1], 0.535355)
					QB.Rotation = yB[2]
					QB.Size = UDim2.fromScale(0.6657, 0.22)
					QB.ZIndex = 9
					QB.Parent = AB
				end

				local QB

				if U then
					QB = Instance.new("TextButton")
					QB.Name = "KeyChip"
					QB.Active = true
					QB.AutoButtonColor = false
					QB.AnchorPoint = Vector2.new(1, 0.5)
					QB.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					QB.BackgroundTransparency = 0.35
					QB.BorderSizePixel = 0
					QB.Position = UDim2.fromScale(0.775, 0.5)
					QB.Size = UDim2.fromScale(0.125, 0.5)
					QB.Text = ""
					QB.TextWrapped = false
					QB.ZIndex = 6
					QB.Parent = sB
					v29(QB)
					v32(QB, Enum.ApplyStrokeMode.Border, 0.1)
					v40(QB, 1.04, 0.96)
				end

				U = Instance.new("TextButton")
				U.Name = "QuickAccessToggle"
				U.Active = true
				U.AutoButtonColor = false
				U.AnchorPoint = Vector2.new(1, 0.5)
				U.BackgroundTransparency = 1
				U.BorderSizePixel = 0
				U.Position = UDim2.fromScale(0.985, 0.5)
				U.Size = UDim2.fromScale(0.115, 0.74)
				U.Text = ""
				U.ZIndex = 6
				U.Parent = sB
				local yB, yB = F(U, 0.5, 0.5, 0.95, 0.78)
				rB = Instance.new("Frame")
				rB.Name = "BarMenu"
				rB.Active = false
				rB.AnchorPoint = Vector2.new(1, 0.5)
				rB.BackgroundTransparency = 1
				rB.BorderSizePixel = 0
				rB.Position = UDim2.fromScale(0.985, 0.755)
				rB.Size = UDim2.fromScale(0.4, 0)
				rB.Visible = false
				rB.ZIndex = 5
				rB.Parent = UB
				local F = Instance.new("UIListLayout")
				F.Name = "MenuLayout"
				F.FillDirection = Enum.FillDirection.Horizontal
				F.HorizontalAlignment = Enum.HorizontalAlignment.Right
				F.VerticalAlignment = Enum.VerticalAlignment.Center
				F.SortOrder = Enum.SortOrder.LayoutOrder
				F.Padding = UDim.new(0.024, 0)
				F.Parent = rB
				local YB, bB, pB = {}

				for oB = 1, s, 1 do
					F = Instance.new("TextButton")
					F.Name = "Bar" .. tostring(oB)
					F.Active = true
					F.AutoButtonColor = false
					F.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					F.BackgroundTransparency = 0.4
					F.BorderSizePixel = 0
					F.LayoutOrder = oB
					F.Size = UDim2.fromScale(0.176, 1)
					F.Text = tostring(oB)
					F.TextWrapped = false
					F.ZIndex = 6
					F.Parent = rB
					v29(F)
					v32(F, Enum.ApplyStrokeMode.Border, 0.09)
					v40(F, 1.06, 0.94)
					YB[oB] = F
				end

				local function s()
					local F = J(uB)
					yB(F, false)
					kB.Text = tostring(R(uB))
					kB.TextTransparency = (F and 0) or 0.5
					F = R(uB)

					for R, yB in ipairs(YB) do
						yB.BackgroundTransparency = ((R == F) and 0.15) or 0.4
						yB.TextTransparency = ((R == F) and 0) or 0.2
					end

					if QB then
						if mB == uB then
							QB.Text = "?"
						else
							QB.Text = V(T()[uB]) or "-"
						end
					end
				end

				if QB then
					v19(QB, function()
						mB = uB

						for V, F in ipairs(p) do
							V = o[F]

							if V then
								V()
							end
						end
					end)
				end

				bB, pB = e(UB, sB, rB, AB)

				for V, e in ipairs(YB) do
					v19(e, function()
						Z(uB, V)
						pB()
						s()
					end)
				end

				v19(kB, function()
					bB()
				end)

				v19(U, function()
					_(uB, not J(uB))
					s()
				end)

				o[UB] = s
				z[UB] = {Header = gB, Search = (KB:GetQuickName() .. (" " .. lB)):lower()}
				UB.LayoutOrder = fB
				UB.Parent = b._content
				table.insert(j, fn4[3][fn4[5]](b, UB))
				table.insert(p, UB)
				s()
			end

			D = function()
				r()
				local U, s, r = b._nextOptionOrder

				x(function(x, V, j)
					if not W(x) then
						return
					end
					local W = w(j) .. ("  >  " .. V.Name)

					if W ~= s then
						s = W
						U += 1
						r = n(W, U)
					end

					U += 1
					X(x, U, r, W)
				end)

				b._container.Visible = true
				b._refreshHeight()
				task.defer(A._updateCanvas)
			end

			b._searchExtra = function(U)
				local s, r = {}, A._searchPaint

				local function A(x)
					if not r then
						return
					end
					local V = x:FindFirstChild("Main")
					r((V and (V:FindFirstChild("Label"))) or (x:FindFirstChild("Label")), U)
				end

				local r = false

				for x, V in ipairs(p) do
					x = z[V]

					if x then
						local W = (U == "") or (x.Search:find(U, 1, true) ~= nil)
						V.Visible = W
						A(V)

						if W then
							if x.Header then
								s[x.Header] = true
							end

							r = true
						end
					end
				end

				for x, x in ipairs(B) do
					x.Visible = (U == "") or (s[x] == true)
					A(x)
				end

				return r
			end

			local function U()
				for s, A in ipairs(p) do
					s = o[A]

					if s then
						s()
					end
				end
			end

			v14(v4.InputBegan:Connect(function(s, A)
				if s.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end

				if v4:GetFocusedTextBox() then
					return
				end

				if mB then
					local r = mB
					mB = nil

					if r == "__OPEN__" then
						if s.KeyCode ~= Enum.KeyCode.Escape then
							E:Set(s.KeyCode.Name)
						end

						O()
					else
						if s.KeyCode == Enum.KeyCode.Escape then
							H(r, nil)
						else
							H(r, s.KeyCode)
						end

						U()
					end

					return
				end

				if A then
					return
				end

				if s.KeyCode.Name == tostring(E:Get()) then
					K:Toggle()
					return
				end

				if a._destroyed or (a:Get() ~= true) then
					return
				end

				for r, p in pairs(T()) do
					if p == s.KeyCode.Name then
						A = C(r)

						if A and (u(A)) then
							I(A)
							G(r)
						end
					end
				end
			end))

			v:Subscribe(function()
				MB()
				U()
			end)

			d:Subscribe(function()
				MB()
				U()
			end)

			i:Subscribe(function()
				MB()
				qB()
				U()
			end)

			N:Subscribe(l)
			E:Subscribe(O)

			v3.quickRefreshHook = function()
				MB()
				D()
			end

			v10.Destroying:Connect(function()
				if L.Parent then
					L:Destroy()
				end
			end)

			if not Q then
				a:SetVisible(false)
				Y:SetVisible(false)
			end

			local function u()
				if not h._destroyed then
					L.Enabled = h:Get() == true
				end

				local s = t._destroyed

				if not s then
					P = (tonumber(t:Get()) or c) / 100
				end

				if v22.UiSizeOption and not v22.UiSizeOption._destroyed then
					v22.ApplyUiSize(v22.UiSizeOption:Get())
				end

				O()
				qB()

				for s, A in ipairs(y) do
					A.Collapsed = S(s)
				end

				k(false)
				MB()
				l(false)
				U()
			end

			v3.configLoadedHook = u
			b:SetExpanded(true, false)
			D()
			u()

			task.defer(function()
				for l = 1, 5, 1 do
					v6.Heartbeat:Wait()
				end

				u()
			end)
		end)()

		q()

		if v3.quickRefreshHook then
			v3.quickRefreshHook()
		end

		if not g then
			f.Button.Visible = false
		end

		for q, q in ipairs(K.Tabs) do
			if q.Button.Visible then
				K:SelectTab(q)
				break
			end
		end

		v17()
		v28(v9.obj9, v27)
		v28(v9.obj20, nil)
		v9.obj20.Size = UDim2.new(1.14, 0, 0.98, 0)
		v11.Position = v21()
		v11.Size = v3.menuSize
		v10.Enabled = true

		task.spawn(function()
			for q = 1, 4, 1 do
				v6.Heartbeat:Wait()
			end

			local q = K.SelectedTab

			if q and not q._destroyed then
				for f, f in ipairs(q.Sections) do
					if f._refreshLayout then
						f._refreshLayout()
					end
				end

				q._updateCanvas()
			end

			v6.Heartbeat:Wait()
			q = K:GetState("Open On Launch")

			if not q or (q:Get() ~= false) then
				K:Open()
			end
		end)

		v3.windowDragController = v18(v12, v11, function()
			return v3.chilliIsOpen and not v3.windowAnimating
		end, function(q)
			v3.windowRestPosition = q
		end)

		v20(v13)

		v19(v13, function()
			K:Close()
		end)

		v19(v16, function()
			K:Toggle()
		end)

		local q = Instance.new("UIScale")
		q.Name = "InteractionScale"
		q.Scale = 1
		q.Parent = v16
		local K
		local f = false

		local function g(l, u)
			if K then
				K:Cancel()
			end

			K = v5:Create(q, TweenInfo.new(u, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = l})
			K:Play()
		end

		v16.MouseEnter:Connect(function()
			f = true
			g(1.04, 0.1)
		end)

		v16.MouseLeave:Connect(function()
			f = false
			g(1, 0.1)
		end)

		v16.MouseButton1Down:Connect(function()
			g(0.94, 0.055)
		end)

		v16.MouseButton1Up:Connect(function()
			g((f and 1.04) or 1, 0.085)
		end)

		return m
	end

	v2[1] = fn4

	v2[2] = function(m)
		tbl3.SetTab(m)
	end

	v2[3] = fn2
	v2[4] = fn3
	return 85750186
end
