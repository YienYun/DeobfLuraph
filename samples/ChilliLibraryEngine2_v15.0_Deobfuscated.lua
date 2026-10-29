return function(arg, arg2)
	assert(type(arg) == "table" and arg[1] == 1129531443)
	assert(type(arg2) == "string" and #arg2 == 45)
	local n = 1831565813
	local n2 = 461845907

	for i = 1, #arg2 do
		local v = string.byte(arg2, i)
		n = bit32.bxor(bit32.lrotate(n, 5), v, i)
		n2 = bit32.bxor(bit32.lrotate(n2, 7), n, v * 257 + i)
	end

	assert(n == 4128922676 and n2 == 842727784)
	local v = arg[2]
	local v2 = arg[3]
	local UserInputService = arg[4]
	local TweenService = arg[5]
	local RunService = arg[6]
	local v3 = arg[7]
	local v4 = arg[8]
	local v5 = arg[9]
	local v6 = arg[10]
	local v7 = arg[11]
	local v8 = arg[12]
	local v9 = arg[13]
	local v10 = arg[14]
	local v11 = arg[15]
	local v12 = arg[16]
	local v13 = arg[17]
	local v14 = arg[18]
	local v15 = arg[19]
	local v16 = arg[20]
	local v17 = arg[21]
	local v18 = arg[22]
	local v19 = arg[23]
	local v20 = arg[24]
	local v21 = arg[25]
	local v22 = arg[26]
	local v23 = arg[27]
	local v24 = arg[28]
	local v25 = arg[29]
	local v26 = arg[30]
	local v27 = arg[31]
	local v28 = arg[32]
	local v29 = arg[33]
	local v30 = arg[34]
	local v31 = arg[35]
	local v32 = arg[36]
	local color = arg[37]
	local v33 = arg[38]
	local v34 = arg[39]
	local v35 = arg[40]
	local v36 = arg[41]
	local v37 = arg[42]
	local v38 = arg[43]
	local v39 = arg[44]
	local v40 = arg[45]
	local tbl = type(arg[48]) == "table" and arg[48] or {}
	local v41 = arg[46]
	local v42 = arg[47]

	for _, v43 in ipairs({
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
		v42[v43[1]][v43[2]] = v41[v43[3]]
	end

	local v43 = v42[4]
	local v44 = v41[86]

	for _, v45 in ipairs({
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
		local v46 = v45[2]

		v43[v45[1]] = function(arg3, arg4)
			return v44(arg3, v46, arg4)
		end
	end

	for _, v45 in ipairs({
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
		local v46 = v42[v45[1]]
		v46[v45[2]] = v46[v45[3]]
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

	v2[101] = function(arg3)
		local str = tostring(arg3):lower():gsub("[%s_%-]", "")
		return tbl2[str], str
	end

	local tbl3 = { Height = 0.0749, Gap = 0.022, Tab = nil, Silent = false }

	local function fn()
		local searchBar = Instance.new("Frame")
		searchBar.Name = "SearchBar"
		searchBar.Active = false
		searchBar.AnchorPoint = Vector2.new(0.5, 0)
		searchBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		searchBar.BackgroundTransparency = 0.4
		searchBar.BorderSizePixel = 0
		searchBar.Position = UDim2.fromScale(0.5, 1 + tbl3.Gap)
		searchBar.Size = UDim2.fromScale(1, tbl3.Height)
		searchBar.ZIndex = 6
		searchBar.Parent = v7
		v28(searchBar, Enum.ApplyStrokeMode.Border, 0.05)
		local uiElement = Instance.new("TextLabel")
		uiElement.Name = "Caption"
		uiElement.Active = false
		uiElement.AnchorPoint = Vector2.new(0, 0.5)
		uiElement.BackgroundTransparency = 1
		uiElement.BorderSizePixel = 0
		uiElement.Position = UDim2.fromScale(0.02, 0.5)
		uiElement.Size = UDim2.fromScale(0.13, 0.5)
		uiElement.Text = "Search"
		uiElement.TextWrapped = false
		uiElement.TextXAlignment = Enum.TextXAlignment.Left
		uiElement.ZIndex = 7
		uiElement.Parent = searchBar
		v25(uiElement)
		local field = Instance.new("Frame")
		field.Name = "Field"
		field.Active = false
		field.AnchorPoint = Vector2.new(1, 0.5)
		field.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		field.BackgroundTransparency = 0.6
		field.BorderSizePixel = 0
		field.ClipsDescendants = false
		field.Position = UDim2.fromScale(0.982, 0.5)
		field.Size = UDim2.fromScale(0.82, 0.6)
		field.ZIndex = 7
		field.Parent = searchBar
		v28(field, Enum.ApplyStrokeMode.Border, 0.1)
		local underline = Instance.new("Frame")
		underline.Name = "Underline"
		underline.Active = false
		underline.AnchorPoint = Vector2.new(0.5, 1)
		underline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		underline.BorderSizePixel = 0
		underline.Position = UDim2.fromScale(0.5, 1)
		underline.Size = UDim2.fromScale(0, 0.11)
		underline.ZIndex = 9
		underline.Parent = field
		local input = Instance.new("TextBox")
		input.Name = "Input"
		input.Active = true
		input.AnchorPoint = Vector2.new(0, 0.5)
		input.BackgroundTransparency = 1
		input.BorderSizePixel = 0
		input.ClearTextOnFocus = false
		input.MultiLine = false
		input.Position = UDim2.fromScale(0.025, 0.5)
		input.Size = UDim2.fromScale(0.9, 0.62)
		input.Text = ""
		input.PlaceholderText = "Filter features..."
		input.PlaceholderColor3 = Color3.fromRGB(198, 198, 198)
		input.TextXAlignment = Enum.TextXAlignment.Left
		input.ZIndex = 8
		input.Parent = field
		v25(input)
		local clear = Instance.new("TextButton")
		clear.Name = "Clear"
		clear.Active = true
		clear.AutoButtonColor = false
		clear.AnchorPoint = Vector2.new(1, 0.5)
		clear.BackgroundTransparency = 1
		clear.BorderSizePixel = 0
		clear.Position = UDim2.fromScale(0.985, 0.5)
		clear.Size = UDim2.fromScale(0.075, 0.74)
		clear.Text = ""
		clear.Visible = false
		clear.ZIndex = 9
		clear.Parent = field
		v35(clear, 1.12, 0.9)
		uiElement = Instance.new("UIAspectRatioConstraint")
		uiElement.AspectRatio = 1
		uiElement.AspectType = Enum.AspectType.FitWithinMaxSize
		uiElement.DominantAxis = Enum.DominantAxis.Height
		uiElement.Parent = clear
		uiElement = {45, -45}

		for i, v45 in ipairs(uiElement) do
			i = Instance.new("Frame")
			i.Name = "Arm"
			i.Active = false
			i.AnchorPoint = Vector2.new(0.5, 0.5)
			i.BackgroundColor3 = Color3.fromRGB(255, 72, 72)
			i.BackgroundTransparency = 0
			i.BorderSizePixel = 0
			i.Position = UDim2.fromScale(0.5, 0.5)
			i.Rotation = v45
			i.Size = UDim2.fromScale(0.82, 0.2)
			i.ZIndex = 10
			i.Parent = clear
		end

		v15(clear, function()
			if input:IsFocused() then
				input:ReleaseFocus()
			end

			input.Text = ""
		end)

		input:GetPropertyChangedSignal("Text"):Connect(function()
			clear.Visible = input.Text ~= ""
		end)

		input.Focused:Connect(function()
			TweenService:Create(field, TweenInfo.new(0.16), {BackgroundTransparency = 0.42}):Play()
			TweenService:Create(underline, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, 0.11)}):Play()
		end)

		input.FocusLost:Connect(function()
			TweenService:Create(field, TweenInfo.new(0.16), {BackgroundTransparency = 0.6}):Play()
			TweenService:Create(underline, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(0, 0.11)}):Play()
		end)

		input:GetPropertyChangedSignal("Text"):Connect(function()
			if tbl3.Silent then
				return
			end
			local tab = tbl3.Tab

			if tab and not tab._destroyed then
				tab._searchQuery = input.Text
				tab._applySearch(input.Text)
			end
		end)

		local y = nil
		local K = nil

		K = function()
			local y2 = v18.Y
			local l, u = tbl3.Height / y2, tbl3.Gap / y2
			searchBar.Size = UDim2.fromScale(1, l)
			local y3 = v7.AbsoluteSize.Y
			y2 = ((v7.AbsolutePosition.Y + y3) + ((l + u) * y3)) <= v6.AbsoluteSize.Y
			if y2 == y then
				return
			end
			y = y2

			if y2 then
				searchBar.AnchorPoint = Vector2.new(0.5, 0)
				searchBar.Position = UDim2.fromScale(0.5, 1 + u)
			else
				searchBar.AnchorPoint = Vector2.new(0.5, 1)
				searchBar.Position = UDim2.fromScale(0.5, -u)
			end
		end

		v18.OnChanged(function()
			y = nil
			K()
		end)

		v7:GetPropertyChangedSignal("AbsolutePosition"):Connect(K)
		v7:GetPropertyChangedSignal("AbsoluteSize"):Connect(K)
		task.defer(K)

		tbl3.SetTab = function(tab)
			tbl3.Tab = tab
			tbl3.Silent = true
			input.Text = (tab and tab._searchQuery) or ""
			tbl3.Silent = false
		end
	end

	fn()

	local function fn2(scrollingFrame, q)
		scrollingFrame.Name = q .. "Page"
		scrollingFrame.Active = true
		scrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		scrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		scrollingFrame.BackgroundTransparency = 1
		scrollingFrame.BorderSizePixel = 0
		scrollingFrame.ClipsDescendants = true

		v18.OnChanged(function(_, K)
			if scrollingFrame.Parent == nil then
				return false
			end
			local f, g = 0.1454 / K, 1 - (0.01500005 / K)
			scrollingFrame.Position = UDim2.new(0.5000000596046448, 0, (f + g) / 2, 0)
			scrollingFrame.Size = UDim2.new(0.9900000095367432, 0, g - f, 0)
		end)

		scrollingFrame.ZIndex = 5
		scrollingFrame.AutomaticSize = Enum.AutomaticSize.None
		scrollingFrame.CanvasPosition = Vector2.new(0, 0)
		scrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
		scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
		scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
		scrollingFrame.ScrollBarImageTransparency = 0
		scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
		scrollingFrame.ScrollingEnabled = true
		scrollingFrame.VerticalScrollBarInset = Enum.ScrollBarInset.None
		scrollingFrame.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		scrollingFrame.Visible = false

		for _, child in ipairs(scrollingFrame:GetChildren()) do
			child:Destroy()
		end

		local contentLayout = Instance.new("UIListLayout")
		contentLayout.Name = "ContentLayout"
		contentLayout.FillDirection = Enum.FillDirection.Vertical
		contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		contentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
		contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
		contentLayout.Padding = UDim.new(0, 2)
		contentLayout.Parent = scrollingFrame
		q = Instance.new("UIPadding")
		q.Name = "ContentPadding"
		q.PaddingTop = UDim.new(0, 0)
		q.PaddingBottom = UDim.new(0, 0)
		q.PaddingLeft = UDim.new(0.014000000432133675, 0)
		q.PaddingRight = UDim.new(0.014000000432133675, 0)
		q.Parent = scrollingFrame
		local n3 = -1

		local function f()
			local g, l, u = math.max(0, math.ceil(contentLayout.AbsoluteContentSize.Y)), 0, 0

			for _, child in ipairs(scrollingFrame:GetChildren()) do
				if child:IsA("GuiObject") and child.Visible then
					l, u = l + 1, u + math.max(0, child.AbsoluteSize.Y)
				end
			end

			return math.max(g, math.ceil(if l > 1 then u + ((l - 1) * (contentLayout.Padding.Offset + (contentLayout.Padding.Scale * scrollingFrame.AbsoluteSize.Y))) else u))
		end

		local function g()
			local l, u = f(), math.max(8, (scrollingFrame.AbsoluteSize.Y * 0.06) / v18.Y)
			local n4 = if l > 0 then (math.ceil(l + u)) else 0

			if math.abs(n4 - n3) >= 1 then
				n3 = n4
				scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, n4)
			end

			u = math.max(0, n4 - scrollingFrame.AbsoluteSize.Y)

			if scrollingFrame.CanvasPosition.Y > u then
				scrollingFrame.CanvasPosition = Vector2.new(scrollingFrame.CanvasPosition.X, u)
			end
		end

		local function fn3()
			scrollingFrame.ScrollBarThickness = math.max(2, math.floor(((scrollingFrame.AbsoluteSize.X * 0.006) / v18.X) + 0.5))
			g()
		end

		contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(g)
		scrollingFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn3)
		task.defer(fn3)
		return contentLayout, g
	end

	local v45 = nil

	local function fn3(m)
		local q = {}

		local function K(f)
			return (tostring(f):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
		end

		local function searchPaint(g, l)
			if not g or not g:IsA("TextLabel") then
				return
			end
			local text = q[g]

			if text == nil then
				if g.RichText then
					return
				end
				text = g.Text
				q[g] = text
			end

			if l == "" then
				g.RichText = false
				g.Text = text
				return
			end

			local pos, U = text:lower():find(l, 1, true)

			if not pos then
				g.RichText = false
				g.Text = text
				return
			end

			g.RichText = true
			g.Text = K(text:sub(1, pos - 1)) .. (("<font color=\"rgb(%d,%d,%d)\">"):format(math.floor((color.R * 255) + 0.5), math.floor((color.G * 255) + 0.5), math.floor((color.B * 255) + 0.5)) .. (K(text:sub(pos, U)) .. ("</font>" .. K(text:sub(U + 1)))))
		end

		local function fn4(arg3)
			local main = arg3.Instance:FindFirstChild("Main")

			if not main then
				for i, child in ipairs(arg3.Instance:GetChildren()) do
					i = child:FindFirstChild("Head")
					main = i and (i:FindFirstChild("Main"))
					if main then
						break
					end
				end
			end

			return (main and (main:FindFirstChild("Label"))) or nil
		end

		local function fn5(g)
			local l = (tostring(g or ""):match("^%s*(.-)%s*$") or ""):lower()

			for i, section in ipairs(m.Sections) do
				if not section._destroyed and not section._isSearchResults then
					i = section.DisplayName or section.Name
					g = (l == "") or (i:lower():find(l, 1, true) ~= nil)
					local visible = if section._searchExtra then (section._searchExtra(l) == true) or g else g
					searchPaint(section._header, l)

					for i2, option in ipairs(section.Options) do
						if option.Instance then
							i2 = option.DisplayName or option.Name
							local searchMatched, visibilityHost = ((l == "") or g) or (i2:lower():find(l, 1, true) ~= nil), option._visibilityHost or option.Instance

							if l == "" then
								if option._preSearchVisible ~= nil then
									visibilityHost.Visible = option._preSearchVisible
									option._preSearchVisible = nil
									option._searchMatched = nil
								end
							else
								if option._preSearchVisible == nil then
									option._preSearchVisible = option._resolvedVisible ~= false
								end

								option._searchMatched = searchMatched
								visibilityHost.Visible = searchMatched and option._preSearchVisible
							end

							searchPaint(fn4(option), l)
							visible = if searchMatched then true else visible
						end
					end

					if l == "" then
						section._container.Visible = true

						if section._preSearchExpanded ~= nil then
							section:SetExpanded(section._preSearchExpanded, false)
							section._preSearchExpanded = nil
						end
					else
						if section._preSearchExpanded == nil then
							section._preSearchExpanded = section.Expanded
						end

						section._container.Visible = visible

						if visible and not section.Expanded then
							section:SetExpanded(true, false)
						end
					end

					section._refreshHeight()
				end
			end

			if v45[3][v45[5]] then
				v45[3][v45[5]](m, l)
			end

			task.defer(m._updateCanvas)
		end

		m._searchPaint = searchPaint
		return fn5
	end

	local function fn4(m, q)
		local uiAspectRatioConstraint = q:FindFirstChildOfClass("UIAspectRatioConstraint")
		if not uiAspectRatioConstraint or (uiAspectRatioConstraint.AspectRatio <= 0) then
			return function()
			end
		end
		local aspectRatio, scale, offset, u, U = uiAspectRatioConstraint.AspectRatio, q.Size.X.Scale, q.Size.X.Offset, -1, -1
		uiAspectRatioConstraint:Destroy()
		q.Size = UDim2.new(scale, offset, 0, 1)
		m._rowUpdaters = m._rowUpdaters or {}
		local K = nil

		K = function(s)
			if m._destroyed or (q.Parent == nil) then
				return
			end

			if not s and (v2.windowAnimating or not m.Tab.Page.Visible) then
				return
			end
			s = m._content.AbsoluteSize.X
			s = if s <= 0 then m.Tab.Page.AbsoluteSize.X else s
			if s <= 0 then
				return
			end
			local x = v18.X
			local k, aspectRatio2 = ((s * scale) / x) + offset, tonumber(q:GetAttribute("ChilliResponsiveAspect")) or aspectRatio
			aspectRatio2 = math.max(0.001, aspectRatio2)
			s = math.max(1, math.floor((k / aspectRatio2) + 0.5))
			k = if v20 then scale / x else scale

			if (math.abs(s - u) >= 1) or (math.abs(k - U) > 1e-06) then
				u, U = s, k
				q.Size = UDim2.new(k, offset, 0, s)
			end

			m._refreshHeight()
		end

		v18.OnChanged(function()
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
			for i = #m._rowUpdaters, 1, -1 do
				if m._rowUpdaters[i] == K then
					table.remove(m._rowUpdaters, i)
				end
			end

			for i = #M, 1, -1 do
				local v46 = M[i]

				if v46.Connected then
					v46:Disconnect()
				end

				M[i] = nil
			end
		end
	end

	local str = "__ChilliSearchResults"
	local v46 = nil
	local str2 = "Other Tabs"
	local n3 = 30

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
		local searchResultsSection = m._searchResultsSection
		if searchResultsSection and not searchResultsSection._destroyed then
			return searchResultsSection
		end
		searchResultsSection = m:CreateSection({Name = str, DisplayName = str2, Expanded = true})
		searchResultsSection._isSearchResults = true
		searchResultsSection._container.LayoutOrder = 1000000
		searchResultsSection._container.Visible = false
		searchResultsSection._mirrors = {}
		searchResultsSection._groupHeaders = {}
		m._searchResultsSection = searchResultsSection
		return searchResultsSection
	end

	local function fn8(m, q)
		local K = m._groupHeaders[q]
		if K then
			return K
		end
		local resultGroup = Instance.new("Frame")
		resultGroup.Name = "ResultGroup"
		resultGroup.Active = false
		resultGroup.AnchorPoint = Vector2.new(0.5, 0.5)
		resultGroup.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		resultGroup.BackgroundTransparency = 0.58
		resultGroup.BorderSizePixel = 0
		resultGroup.Position = UDim2.fromScale(0.5, 0.5)
		resultGroup.Size = UDim2.fromScale(v32, 0.6)
		resultGroup.ZIndex = 3
		local g = v28(resultGroup, Enum.ApplyStrokeMode.Border, 0.045)
		g.Color = color
		g.Transparency = 0.62
		local uiElement = Instance.new("UIAspectRatioConstraint")
		uiElement.AspectRatio = 22
		uiElement.AspectType = Enum.AspectType.FitWithinMaxSize
		uiElement.DominantAxis = Enum.DominantAxis.Width
		uiElement.Parent = resultGroup
		uiElement = Instance.new("TextLabel")
		uiElement.Name = "Label"
		uiElement.Active = false
		uiElement.AnchorPoint = Vector2.new(0, 0.5)
		uiElement.BackgroundTransparency = 1
		uiElement.BorderSizePixel = 0
		uiElement.Position = UDim2.fromScale(0.025, 0.5)
		uiElement.Size = UDim2.fromScale(0.73, 0.8)
		uiElement.Text = ""
		uiElement.TextWrapped = false
		uiElement.TextTruncate = Enum.TextTruncate.AtEnd
		uiElement.TextXAlignment = Enum.TextXAlignment.Left
		uiElement.ZIndex = 5
		uiElement.Parent = resultGroup
		v25(uiElement)
		uiElement.TextColor3 = color
		local uiElement2 = Instance.new("Frame")
		uiElement2.Name = "Line"
		uiElement2.Active = false
		uiElement2.AnchorPoint = Vector2.new(1, 0.5)
		uiElement2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		uiElement2.BackgroundTransparency = 0.75
		uiElement2.BorderSizePixel = 0
		uiElement2.Position = UDim2.fromScale(0.79, 0.5)
		uiElement2.Size = UDim2.fromScale(0.055, 0.08)
		uiElement2.ZIndex = 4
		uiElement2.Parent = resultGroup
		uiElement2 = Instance.new("TextLabel")
		uiElement2.Name = "OpenHint"
		uiElement2.Active = false
		uiElement2.AnchorPoint = Vector2.new(1, 0.5)
		uiElement2.BackgroundTransparency = 1
		uiElement2.BorderSizePixel = 0
		uiElement2.Position = UDim2.fromScale(0.975, 0.5)
		uiElement2.Size = UDim2.fromScale(0.16, 0.72)
		uiElement2.Text = "OPEN  >"
		uiElement2.TextWrapped = false
		uiElement2.TextXAlignment = Enum.TextXAlignment.Right
		uiElement2.ZIndex = 5
		uiElement2.Parent = resultGroup
		v25(uiElement2)
		uiElement2.TextColor3 = color
		local openTab = Instance.new("TextButton")
		openTab.Name = "OpenTab"
		openTab.Active = true
		openTab.AutoButtonColor = false
		openTab.BackgroundTransparency = 1
		openTab.BorderSizePixel = 0
		openTab.Size = UDim2.fromScale(1, 1)
		openTab.Text = ""
		openTab.ZIndex = 6
		openTab.Parent = resultGroup

		openTab.MouseEnter:Connect(function()
			TweenService:Create(resultGroup, TweenInfo.new(0.12), {BackgroundTransparency = 0.38}):Play()
			TweenService:Create(g, TweenInfo.new(0.12), {Transparency = 0.22}):Play()
		end)

		openTab.MouseLeave:Connect(function()
			TweenService:Create(resultGroup, TweenInfo.new(0.12), {BackgroundTransparency = 0.58}):Play()
			TweenService:Create(g, TweenInfo.new(0.12), {Transparency = 0.62}):Play()
		end)

		resultGroup.Parent = m._content
		fn4[3][fn4[5]](m, resultGroup)

		K = {Row = resultGroup, Label = uiElement, OpenLabel = uiElement2, Button = openTab, Target = nil, Connection = nil, Connection = v15(openTab, function()
			if K.Target and tbl3.NavigateToOption then
				tbl3.NavigateToOption(K.Target)
			end
		end)}

		m._groupHeaders[q] = K
		return K
	end

	local function fn9(m, mirrorOf)
		local K = fn6[3][fn6[5]](mirrorOf)
		local sourceConfig = m._mirrors[K]
		if sourceConfig and not sourceConfig._destroyed then
			return sourceConfig
		end
		sourceConfig = mirrorOf._sourceConfig
		if type(sourceConfig) ~= "table" then
			return nil
		end
		local g = v39(sourceConfig)
		g.Name = K
		g.DisplayName = mirrorOf.DisplayName or mirrorOf.Name
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
		g.State = mirrorOf.State

		if not mirrorOf.State then
			if mirrorOf.Type ~= "button" then
				return nil
			end
			g.Callback = mirrorOf._userCallback
		end

		local M
		if not pcall(function()
			M = m:CreateOption(mirrorOf.Type, g)
		end) or not M then
			return nil
		end
		M._mirrorOf = mirrorOf
		m._mirrors[K] = M
		return M
	end

	local function fn10(M)
		local searchResultsSection = M._searchResultsSection
		if not searchResultsSection or searchResultsSection._destroyed then
			return
		end
		searchResultsSection._container.Visible = false

		for _, v47 in pairs(searchResultsSection._groupHeaders or {}) do
			v47.Row.Visible = false
		end

		for _, v47 in pairs(searchResultsSection._mirrors or {}) do
			if v47.Instance then
				v47.Instance.Visible = false
			end
		end
	end

	tbl3.ActiveScrollTween = nil
	tbl3.NavigationSerial = 0

	tbl3.NavigateToOption = function(m)
		if (((not m or m._destroyed) or not m.Instance) or not m.Section) or m.Section._destroyed then
			return
		end
		local section = m.Section
		local tab = section.Tab
		local window = tab and tab.Window
		if (not tab or tab._destroyed) or not window then
			return
		end
		tbl3.NavigationSerial = tbl3.NavigationSerial + 1
		local navigationSerial = tbl3.NavigationSerial

		if tbl3.ActiveScrollTween then
			tbl3.ActiveScrollTween:Cancel()
			tbl3.ActiveScrollTween = nil
		end

		window:SelectTab(tab)

		if not section.Expanded then
			section:SetExpanded(true, true)
		end

		task.spawn(function()
			local heightTween = section._heightTween

			if heightTween then
				pcall(function()
					heightTween.Completed:Wait()
				end)
			else
				RunService.Heartbeat:Wait()
			end

			RunService.Heartbeat:Wait()
			if ((((navigationSerial ~= tbl3.NavigationSerial) or m._destroyed) or section._destroyed) or tab._destroyed) or (window.SelectedTab ~= tab) then
				return
			end

			if section._refreshLayout then
				section._refreshLayout()
			end

			tab._updateCanvas()
			RunService.Heartbeat:Wait()
			local page, visibilityHost = tab.Page, m._visibilityHost or m.Instance
			visibilityHost = if not visibilityHost.Visible then section._header else visibilityHost
			if ((not page or not page.Parent) or not visibilityHost) or not visibilityHost.Parent then
				return
			end
			local canvasPosition = page.CanvasPosition
			local q, K = ((visibilityHost.AbsolutePosition.Y - page.AbsolutePosition.Y) + canvasPosition.Y) - (page.AbsoluteSize.Y * 0.28), math.max(0, page.AbsoluteCanvasSize.Y - page.AbsoluteSize.Y)
			q = math.clamp(q, 0, K)
			tbl3.ActiveScrollTween = TweenService:Create(page, TweenInfo.new(0.46, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {CanvasPosition = Vector2.new(canvasPosition.X, q)})
			local activeScrollTween = tbl3.ActiveScrollTween
			activeScrollTween:Play()

			pcall(function()
				activeScrollTween.Completed:Wait()
			end)

			if tbl3.ActiveScrollTween == activeScrollTween then
				tbl3.ActiveScrollTween = nil
			end

			if ((navigationSerial ~= tbl3.NavigationSerial) or not visibilityHost.Parent) or not visibilityHost.Visible then
				return
			end
			K = visibilityHost:FindFirstChild("ChilliSearchNavigationHighlight")

			if K then
				K:Destroy()
			end

			local chilliSearchNavigationHighlight = Instance.new("UIStroke")
			chilliSearchNavigationHighlight.Name = "ChilliSearchNavigationHighlight"
			chilliSearchNavigationHighlight.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			chilliSearchNavigationHighlight.Color = color
			chilliSearchNavigationHighlight.LineJoinMode = Enum.LineJoinMode.Round
			chilliSearchNavigationHighlight.Thickness = 0.065
			chilliSearchNavigationHighlight.Transparency = 1

			pcall(function()
				chilliSearchNavigationHighlight.BorderStrokePosition = Enum.BorderStrokePosition.Outer
				chilliSearchNavigationHighlight.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			end)

			chilliSearchNavigationHighlight.Parent = visibilityHost
			TweenService:Create(chilliSearchNavigationHighlight, TweenInfo.new(0.16), {Transparency = 0.04}):Play()

			task.delay(0.5, function()
				if chilliSearchNavigationHighlight.Parent then
					local tween = TweenService:Create(chilliSearchNavigationHighlight, TweenInfo.new(0.28), {Transparency = 1})
					tween:Play()

					tween.Completed:Connect(function()
						if chilliSearchNavigationHighlight.Parent then
							chilliSearchNavigationHighlight:Destroy()
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

		for i, tab in ipairs(m.Window.Tabs) do
			if ((tab ~= m) and not tab._destroyed) and tab.Button.Visible then
				for i2, section in ipairs(tab.Sections) do
					if not section._destroyed and not section._isSearchResults then
						i, i2 = {}, tostring(section.DisplayName or section.Name):lower():find(q, 1, true) ~= nil

						for _, option in ipairs(section.Options) do
							if (option.Instance and not option._destroyed) and (f < n3) then
								if i2 or ((option.DisplayName or option.Name):lower():find(q, 1, true) ~= nil) then
									i[#i + 1] = option
									f += 1
								end
							end
						end

						if #i > 0 then
							K[#K + 1] = {Tab = tab, Section = section, Options = i}
						end
					end
				end
			end
		end

		if f == 0 then
			fn10[3][fn10[5]](m)
			return
		end
		local v47, g, l, layoutOrder = fn7[3][fn7[5]](m), {}, {}, 0

		for _, v48 in ipairs(K) do
			local str3 = v48.Tab.Name .. ("\000" .. v48.Section.Name)
			q = fn8[3][fn8[5]](v47, str3)
			layoutOrder += 1
			q.Row.LayoutOrder = layoutOrder
			q.Row.Visible = true
			q.Label.Text = "GO TO  " .. (fn5[3][fn5[5]](v48.Tab) .. ("  >  " .. tostring(v48.Section.DisplayName or v48.Section.Name)))
			q.Target = v48.Options[1]
			g[str3] = true

			for _, option in ipairs(v48.Options) do
				str3 = fn9[3][fn9[5]](v47, option)

				if str3 and str3.Instance then
					layoutOrder += 1
					str3.Instance.LayoutOrder = layoutOrder
					str3.Instance.Visible = true
					l[fn6[3][fn6[5]](option)] = true
				end
			end
		end

		for k, groupHeader in pairs(v47._groupHeaders) do
			if not g[k] then
				groupHeader.Row.Visible = false
			end
		end

		for k, mirror in pairs(v47._mirrors) do
			if not l[k] and mirror.Instance then
				mirror.Instance.Visible = false
			end
		end

		v47._container.Visible = true

		if not v47.Expanded then
			v47:SetExpanded(true, false)
		end

		v47._refreshHeight()

		if v46[3][v46[5]] then
			v46[3][v46[5]]()
		end
	end

	local n4 = 3
	local n5 = 6
	local n6 = 0.115
	local v47 = nil
	local tbl4 = {}
	local n7 = 0
	local flag = true

	local function fn12()
		if v47[3][v47[5]] and v47[3][v47[5]].Parent then
			return v47[3][v47[5]]
		end
		v47[3][v47[5]] = Instance.new("Frame")
		v47[3][v47[5]].Name = "ChilliNotifyHolder"
		v47[3][v47[5]].Active = false
		v47[3][v47[5]].AnchorPoint = Vector2.new(1, 1)
		v47[3][v47[5]].BackgroundTransparency = 1
		v47[3][v47[5]].BorderSizePixel = 0
		v47[3][v47[5]].ClipsDescendants = false
		v47[3][v47[5]].Position = UDim2.fromScale(0.988, 0.975)
		v47[3][v47[5]].Size = UDim2.fromScale(0.163, 0.74)
		v47[3][v47[5]].ZIndex = 100
		v47[3][v47[5]].Parent = v6
		local layout = Instance.new("UIListLayout")
		layout.Name = "Layout"
		layout.FillDirection = Enum.FillDirection.Vertical
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Padding = UDim.new(0.015, 0)
		layout.Parent = v47[3][v47[5]]
		return v47[3][v47[5]]
	end

	local function fn13(m)
		for i = #tbl4, 1, -1 do
			if tbl4[i] == m then
				table.remove(tbl4, i)
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

		local slot, card = m.Slot, m.Card

		if q then
			if slot and slot.Parent then
				slot:Destroy()
			end

			return
		end

		if ((not slot or not slot.Parent) or not card) or not card.Parent then
			return
		end
		m.CardTween = TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Position = UDim2.fromScale(2.1, 0.5)})
		m.CardTween:Play()

		task.delay(0.08, function()
			if slot.Parent then
				TweenService:Create(slot, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.fromScale(1, 0)}):Play()
			end
		end)

		task.delay(0.32, function()
			if slot.Parent then
				slot:Destroy()
			end
		end)
	end

	local function fn15()
		for i = #tbl4, 1, -1 do
			fn14[3][fn14[5]](tbl4[i], true)
		end

		if v47[3][v47[5]] and v47[3][v47[5]].Parent then
			v47[3][v47[5]]:Destroy()
		end

		v47[3][v47[5]] = nil
	end

	v40.SetNotificationsEnabled = function(m)
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

	v40.AreNotificationsEnabled = function()
		return flag[3][flag[5]]
	end

	v40.Notify = function(m, parent, K)
		if not flag[3][flag[5]] then
			return
		end
		local frame = fn12[3][fn12[5]]()

		while #tbl4 >= n5 do
			fn14[3][fn14[5]](tbl4[1], true)
		end

		n7[3][n7[5]] += 1
		local g, notificationSlot = math.max(0, tonumber(K) or n4), Instance.new("Frame")
		notificationSlot.Name = "NotificationSlot"
		notificationSlot.Active = false
		notificationSlot.BackgroundTransparency = 1
		notificationSlot.BorderSizePixel = 0
		notificationSlot.ClipsDescendants = false
		notificationSlot.LayoutOrder = n7[3][n7[5]]
		notificationSlot.Size = UDim2.fromScale(1, 0)
		notificationSlot.ZIndex = 100
		notificationSlot.Parent = frame
		frame = Instance.new("Frame")
		frame.Name = "ChilliNotify"
		frame.Active = false
		frame.AnchorPoint = Vector2.new(1, 0.5)
		frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		frame.BackgroundTransparency = 0.35
		frame.BorderSizePixel = 0
		frame.ClipsDescendants = true
		frame.Position = UDim2.fromScale(2.1, 0.5)
		frame.Size = UDim2.fromScale(1, 1)
		frame.ZIndex = 101
		frame.Parent = notificationSlot
		v28(frame, Enum.ApplyStrokeMode.Border, 0.045)
		K = Instance.new("Frame")
		K.Name = "Accent"
		K.Active = false
		K.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		K.BorderSizePixel = 0
		K.Position = UDim2.fromScale(0, 0)
		K.Size = UDim2.fromScale(0.026, 1)
		K.ZIndex = 102
		K.Parent = frame
		v27(K, "RedGradient", v26)
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
		K.Parent = frame
		v24(K, v22)
		m = Instance.new("TextLabel")
		m.Name = "Body"
		m.Active = false
		m.BackgroundTransparency = 1
		m.BorderSizePixel = 0
		m.Position = UDim2.fromScale(0.07, 0.48)
		m.Size = UDim2.fromScale(0.86, 0.3)
		m.Text = tostring(parent or "")
		m.TextWrapped = true
		m.TextXAlignment = Enum.TextXAlignment.Left
		m.TextYAlignment = Enum.TextYAlignment.Top
		m.ZIndex = 103
		m.Parent = frame
		v25(m)
		m.TextTransparency = 0.28
		parent = Instance.new("Frame")
		parent.Name = "Track"
		parent.Active = false
		parent.AnchorPoint = Vector2.new(0.5, 1)
		parent.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		parent.BackgroundTransparency = 0.45
		parent.BorderSizePixel = 0
		parent.Position = UDim2.fromScale(0.5, 1)
		parent.Size = UDim2.fromScale(1, 0.055)
		parent.Visible = g > 0
		parent.ZIndex = 102
		parent.Parent = frame
		m = Instance.new("Frame")
		m.Name = "Fill"
		m.Active = false
		m.AnchorPoint = Vector2.new(0, 0.5)
		m.BackgroundColor3 = Color3.fromRGB(239, 28, 28)
		m.BorderSizePixel = 0
		m.Position = UDim2.fromScale(0, 0.5)
		m.Size = UDim2.fromScale(1, 1)
		m.ZIndex = 103
		m.Parent = parent
		local q = {Card = frame, CardTween = nil, Dismissing = false, ProgressTween = nil, Slot = notificationSlot, Timer = nil}
		table.insert(tbl4, q)
		TweenService:Create(notificationSlot, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale(1, n6)}):Play()
		q.CardTween = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = UDim2.fromScale(1, 0.5)})
		q.CardTween:Play()

		if g > 0 then
			q.ProgressTween = TweenService:Create(m, TweenInfo.new(g, Enum.EasingStyle.Linear), {Size = UDim2.fromScale(0, 1)})
			q.ProgressTween:Play()

			q.Timer = task.delay(g, function()
				q.Timer = nil
				fn14[3][fn14[5]](q, false)
			end)
		end

		return frame
	end

	v40.Finalize = function(m, q)
		assert(not m._finalized, "ChilliLibrary:Finalize() chi duoc goi mot lan")
		q = ((type(q) == "table") and q) or {}
		local window = q.Window or m.Window
		local mainTab, g = q.MainTab or (window and window.DefaultTab), q.ShowMainTab == true
		assert(window, "Finalize can Window")
		assert(mainTab, "Finalize can MainTab")
		m._finalized = true

		local function fn16()
			local HttpService = game:GetService("HttpService")
			local configFolder = tbl.ConfigFolder or "ChilliLibrary"
			local U = configFolder .. "/configs"
			local s, A, startup, genv = string.gsub(U, "%p", "%%%0"), configFolder .. "/config_state.json", "Default", _G

			pcall(function()
				local Q = type(getgenv)

				if Q == "function" then
					genv = getgenv()
				end
			end)

			local function Q(y)
				local Y = if type(genv) == "table" then genv[y] else nil
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
					local ok, P = pcall(y.Read, p)
					if not ok then
						return nil
					end
					o = P
				end

				if (type(o) ~= "string") or (o == "") then
					return nil
				end

				local ok, c = pcall(function()
					return HttpService:JSONDecode(o)
				end)

				return (ok and c) or nil
			end

			local function p(o, c)
				local ok, t = pcall(function()
					return HttpService:JSONEncode(c)
				end)

				if not ok then
					return false, "JSON encode failed: " .. tostring(t)
				end

				if y.Available then
					local ok2, P = pcall(y.Write, o, t)
					if not ok2 then
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
					local ok, t = pcall(y.Delete, c)
					if not ok then
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
				local match = tostring(t or ""):match("^%s*(.-)%s*$") or ""
				if match == "" then
					return nil, "Enter a config name."
				end
				t = utf8.len(match)
				if not t or (t > 48) then
					return nil, "Config name is limited to 48 characters."
				end

				if (((match == ".") or (match == "..")) or (match:find("[<>:\"/\\|?*%c]"))) or (match:find("[%.%s]$")) then
					return nil, "Config name contains invalid file characters."
				end
				t = match:upper()
				local match2 = t:match("^([^%.]+)") or t
				if ((((((match2 == "CON") or (match2 == "PRN")) or (match2 == "AUX")) or (match2 == "NUL")) or (match2 == "CLOCK$")) or (match2:match("^COM[1-9]$"))) or (match2:match("^LPT[1-9]$")) then
					return nil, "This config name is reserved by Windows."
				end
				return match
			end

			local function t()
				local x = {[startup:lower()] = startup}

				if y.Available and y.CanList then
					local ok, W = pcall(y.List, U)

					if ok and (type(W) == "table") then
						for i, v48 in ipairs(W) do
							i = tostring(v48):gsub("\\", "/"):match("([^/]+)%.json$")

							if i and (i ~= "") then
								x[i:lower()] = i
							end
						end
					end
				else
					for k in pairs(Y) do
						local match = tostring(k):gsub("\\", "/"):match("^" .. (s .. "/([^/]+)%.json$"))

						if match and (match ~= "") then
							x[match:lower()] = match
						end
					end
				end

				local tbl5 = {}

				for _, v48 in pairs(x) do
					if v48:lower() ~= startup:lower() then
						table.insert(tbl5, v48)
					end
				end

				table.sort(tbl5, function(arg3, arg4)
					return arg3:lower() < arg4:lower()
				end)

				table.insert(tbl5, 1, startup)
				return tbl5
			end

			local function fn17(arg3)
				local x = tostring(arg3):lower()

				for _, v48 in ipairs(t()) do
					if v48:lower() == x then
						return v48
					end
				end

				x = P(arg3)
				if x and (type(b(c(x))) == "table") then
					return x
				end
				return nil
			end

			local function fn18()
				local x = 1
				local V = "Default " .. tostring(x)

				while fn17(V) do
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

				for k, v48 in pairs(V) do
					if (type(k) == "string") or (type(k) == "number") then
						local G = x(v48, W)

						if G ~= nil then
							C[k] = G
						end
					end
				end

				W[V] = nil
				return C
			end

			local V = {Active = startup, AutoLoad = true, AutoSave = true, Loading = false, Startup = startup};

			(function()
				if not y.Available then
					return
				end
				pcall(y.MakeFolder, configFolder)
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

			local function fn19()
				return p(A, {Version = 2, AutoLoad = V.AutoLoad, AutoSave = V.AutoSave, StartupConfig = V.Startup})
			end

			local function fn20()
				local tbl5 = {}

				for i, tab in ipairs(window.Tabs) do
					if not tab._destroyed then
						i = {}

						for i2, section in ipairs(tab.Sections) do
							if not section._destroyed then
								i2 = {}

								for i3, option in ipairs(section.Options) do
									if ((not option._destroyed and not option._configIgnored) and option._controller.GetValue) and not (option.State and option.State._registered) then
										local ok, w = pcall(function()
											return option:Get()
										end)

										if ok and (w ~= nil) then
											i3 = x(w)

											if i3 ~= nil then
												local h = {Type = option.Type, Value = i3}

												if option._controller.GetUnit then
													local ok2, unit = pcall(function()
														return option:GetUnit()
													end)

													if ok2 and (type(unit) == "string") then
														h.Unit = unit
													end
												end

												i2[option.Name] = h
											end
										end
									end
								end

								if next(i2) ~= nil then
									i[section.Name] = i2
								end
							end
						end

						if next(i) ~= nil then
							tbl5[tab.Name] = i
						end
					end
				end

				return tbl5
			end

			local function fn21()
				local W = {}

				for i, state in ipairs(window.States) do
					if not state._destroyed and not state._configIgnored then
						i = x(state:Get())

						if i ~= nil then
							W[state.Name] = {Value = i}
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
				W = fn21()
				C = fn20()
			end

			local j, G, I, h, w, v48, e, B, z
			local n8, i = 0, "This config loads next time; use Load Config to load now"

			local function N(J)
			end

			local function J()
				local d, E = fn19()

				if not d then
					N("Config state save failed: " .. tostring(E))
				end

				return d, E
			end

			local function fn22()
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

				for i2 = 1, 4, 1 do
					local _ = D[i2]

					if _ and not _._destroyed then
						table.insert(O, _)
					end
				end

				return O
			end

			local function D()
				local O, T = t(), {I, h, w, v48}

				for _, v49 in ipairs((E(T))) do
					v49:SetOptions(O, nil, false)
				end

				fn22()
				d()
			end

			local function O(T)
				local _ = {I, w, v48}

				for _, v49 in ipairs((E(_))) do
					v49:Set(T, false)
				end
			end

			local function fn23(T, _, S)
				local saved, F = P(T)

				if not saved then
					if _ ~= false then
						N(F)
					end

					return false, F
				end

				T, F = p(c(saved), {Version = 2, Profile = saved, SavedAt = os.time(), States = (S and S.States) or (fn21()), Values = (S and S.Values) or (fn20())})

				if T and (_ ~= false) then
					N("Saved: " .. saved)
				elseif not T and (_ ~= false) then
					N(F)
				end

				return T, F
			end

			local fn24

			local function fn25(arg3)
				for _, tab in ipairs(window.Tabs) do
					if not tab._destroyed then
						for _, section in ipairs(tab.Sections) do
							if not section._destroyed then
								for _, option in ipairs(section.Options) do
									if (not option._destroyed and option._visibilityDependencies) and (#option._visibilityDependencies > 0) then
										option:_ApplyVisibility(arg3)
									end
								end
							end
						end
					end
				end
			end

			local function fn26(T, _)
				n8 += 1
				local loaded = fn17(T)

				if not loaded then
					local X = "Config does not exist: " .. tostring(T)

					if _ ~= false then
						N(X)
					end

					return false, X
				end

				T = b(c(loaded))

				if (type(T) ~= "table") or ((type(T.Values) ~= "table") and (type(T.States) ~= "table")) then
					local X = "Config file is empty or invalid."

					if _ ~= false then
						N(X)
					end

					return false, X
				end

				a()
				local states, values, R, Z = ((type(T.States) == "table") and T.States) or {}, ((type(T.Values) == "table") and T.Values) or {}, W or {}, C or {}

				local function fn27(H, L, arg3)
					local flag2 = ((type(H) == "table") and H[arg3]) or nil
					if (type(flag2) == "table") and (flag2.Value ~= nil) then
						return flag2
					end
					flag2 = ((type(L) == "table") and L[arg3]) or nil
					if (type(flag2) == "table") and (flag2.Value ~= nil) then
						return flag2
					end
					return nil
				end

				V.Loading = true

				local ok, L = xpcall(function()
					local tbl5 = {}

					for i2, state in ipairs(window.States) do
						i2 = fn27(states, R, state.Name)

						if (not state._destroyed and not state._configIgnored) and i2 then
							state:Set(i2.Value, false)
							tbl5[state] = true
						end
					end

					for i2, tab in ipairs(window.Tabs) do
						local v49, v50 = values[tab.Name], Z[tab.Name]

						for i3, section in ipairs(tab.Sections) do
							i2, i3 = ((type(v49) == "table") and v49[section.Name]) or nil, ((type(v50) == "table") and v50[section.Name]) or nil

							for i4, option in ipairs(section.Options) do
								i4 = fn27(i2, i3, option.Name)

								if (((not option._destroyed and not option._configIgnored) and i4) and option._controller.SetValue) and not ((option.State and option.State._registered) and tbl5[option.State]) then
									local unit = i4.Unit

									if (type(unit) == "string") and option._controller.SetUnit then
										pcall(function()
											option:SetUnit(unit, true)
										end)

										option:Set(i4.Value, true)
									else
										option:Set(i4.Value, false)
									end
								end
							end
						end
					end
				end, function(arg3)
					return tostring(arg3)
				end)

				V.Loading = false

				if ok then
					V.Active = loaded
					fn22()
					d()
					fn25(false)

					if v2.configLoadedHook then
						local ok2, X = pcall(v2.configLoadedHook)

						if not ok2 then
							N("Config hook failed: " .. tostring(X))
						end
					end

					local ok2, X = pcall(fn24)

					if not ok2 then
						N("Config callback failed: " .. tostring(X))
					end

					if V.AutoSave then
						n8 += 1
						fn23(V.Active, false)
					end

					if _ ~= false then
						N("Loaded: " .. loaded)
					end

					return true
				end

				if _ ~= false then
					N("Load failed: " .. tostring(L))
				end

				return false, L
			end

			fn24 = function()
				local T = {}

				for _, tab in ipairs(window.Tabs) do
					if not tab._destroyed then
						for _, section in ipairs(tab.Sections) do
							if not section._destroyed then
								for _, option in ipairs(section.Options) do
									if (not option._destroyed and not option._configIgnored) and option._controller.GetValue then
										local state = option.State

										if (state and state._registered) and not T[state] then
											T[state] = true
											v38(state.Callback, state:Get(), state, nil)
										end

										if ((not state or not state._registered) or (state._primaryOption == option)) and (type(option._userCallback) == "function") then
											v38(option._userCallback, option:Get())
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
				n8 += 1
				local n82, active = n8, V.Active

				task.delay(0.35, function()
					if ((n82 ~= n8) or not V.AutoSave) or V.Loading then
						return
					end
					local _, X = fn23(active, false)

					if _ then
						N("Auto-saved: " .. active)
					else
						N("Auto-save failed: " .. tostring(X))
					end
				end)
			end

			v2.optionChangedHook = function(_)
				if _._configIgnored then
					return
				end
				T()
			end

			v2.stateChangedHook = function(_)
				if _._configIgnored then
					return
				end
				T()
			end

			local function fn27(_)
				_._configIgnored = true

				if _.State and not _.State._registered then
					_.State._configIgnored = true
				end

				return _
			end

			local _, S, X, setclipboard = "ChilliLibraryConfig", 1, 1048576, ((Q("setclipboard") or (Q("toclipboard"))) or (Q("set_clipboard"))) or (Q("writeclipboard"))

			do
				local clipboard = ((type(genv) == "table") and genv.Clipboard) or nil

				if (not setclipboard and (type(clipboard) == "table")) and (type(clipboard.set) == "function") then
					setclipboard = function(r)
						return clipboard.set(r)
					end
				end
			end

			local function r(R, Z, H)
				v40.Notify(tostring(R), tostring(Z), H)
			end

			local function R(Z)
				if type(setclipboard) ~= "function" then
					return false, "Clipboard copy is not supported by this executor."
				end
				local ok, L = pcall(setclipboard, tostring(Z or ""))
				if not ok then
					return false, "Clipboard copy failed: " .. tostring(L)
				end
				return true
			end

			local function F(Z)
				local H = fn17(Z)
				if not H then
					return nil, "Selected config does not exist."
				end
				Z = b(c(H))
				if (type(Z) ~= "table") or ((type(Z.Values) ~= "table") and (type(Z.States) ~= "table")) then
					return nil, "Selected config file is empty or invalid."
				end
				local L = x(Z) or {}
				L.Profile = H

				local ok, result = pcall(function()
					return HttpService:JSONEncode({Format = _, ExportVersion = S, Name = H, Config = L})
				end)

				if not ok then
					return nil, "Config export encode failed: " .. tostring(result)
				end
				return result, nil, H
			end

			local function fn28(Z)
				local H = tostring(Z or "")
				H = H:match("^%s*(.-)%s*$") or ""
				if H == "" then
					return nil, nil, "Paste exported config JSON first."
				end

				if #H > X then
					return nil, nil, "Import is larger than the 1 MB safety limit."
				end

				local ok, L = pcall(function()
					return HttpService:JSONDecode(H)
				end)

				if not ok or (type(L) ~= "table") then
					return nil, nil, "Import text is not valid JSON."
				end
				Z, ok = nil

				if (L.Format == _) and (type(L.Config) == "table") then
					Z, ok = (L.Name or L.Profile) or L.Config.Profile, L.Config
				else
					local l = (type(L.Values) == "table") or (type(L.States) == "table")

					if l then
						Z = L.Profile
					else
						return nil, nil, "JSON is not a Chilli config export."
					end

					ok = L
				end

				local l, v49 = P(Z)
				if not l then
					return nil, nil, "Exported config name is invalid: " .. tostring(v49)
				end

				if (type(ok.Values) ~= "table") and (type(ok.States) ~= "table") then
					return nil, nil, "Imported config has no States or Values."
				end
				return l, {States = ((type(ok.States) == "table") and (x(ok.States))) or {}, Values = ((type(ok.Values) == "table") and (x(ok.Values))) or {}}
			end

			local function l(arg3, arg4)
				local v49 = utf8.len(arg3)
				if not v49 or (v49 <= arg4) then
					return arg3
				end
				v49 = utf8.offset(arg3, arg4 + 1)
				return (v49 and (arg3:sub(1, v49 - 1))) or arg3
			end

			local function fn29(arg3)
				if not fn17(arg3) then
					return arg3
				end
				local n9 = 1

				while true do
					local Z = "." .. tostring(n9)
					local H = l(arg3, 48 - #Z):gsub("[%.%s]+$", "")
					local str3 = (if H == "" then "Imported" else H) .. Z
					if not fn17(str3) then
						return str3
					end
					n9 += 1
				end
			end

			local function fn30()
				a()
				n8 += 1
				V.Loading = true

				local ok, result = xpcall(function()
					local Z = {}

					for i2, state in ipairs(window.States) do
						i2 = W[state.Name]

						if ((not state._destroyed and not state._configIgnored) and (type(i2) == "table")) and (i2.Value ~= nil) then
							state:Set(i2.Value, false)
							Z[state] = true
						end
					end

					for i2, tab in ipairs(window.Tabs) do
						i2 = C[tab.Name]

						if type(i2) == "table" then
							for i3, section in ipairs(tab.Sections) do
								i3 = i2[section.Name]

								if type(i3) == "table" then
									for _, option in ipairs(section.Options) do
										local H = i3[option.Name]

										if ((((not option._destroyed and not option._configIgnored) and (type(H) == "table")) and (H.Value ~= nil)) and option._controller.SetValue) and not ((option.State and option.State._registered) and Z[option.State]) then
											if (type(H.Unit) == "string") and option._controller.SetUnit then
												pcall(function()
													option:SetUnit(H.Unit, true)
												end)

												option:Set(H.Value, true)
											else
												option:Set(H.Value, false)
											end
										end
									end
								end
							end
						end
					end
				end, function(arg3)
					return tostring(arg3)
				end)

				V.Loading = false
				if not ok then
					N("Reset failed: " .. tostring(result))
					return
				end
				fn25(false)

				if v2.configLoadedHook then
					pcall(v2.configLoadedHook)
				end

				pcall(fn24)

				if V.AutoSave then
					n8 += 1
					fn23(V.Active, false)
				end

				N("All features reset to defaults.")
			end

			local tbl5 = {Settings = true, Quick = true, Config = true}

			local function fn31()
				local n9 = 0

				for _, tab in ipairs(window.Tabs) do
					if not tab._destroyed and not tbl5[tab.Name] then
						for _, section in ipairs(tab.Sections) do
							if not section._destroyed then
								for _, option in ipairs(section.Options) do
									if (((not option._destroyed and not option._configIgnored) and ((option.Type == "toggle") or (option.Type == "switch"))) and option._controller.GetValue) and (option:Get() == true) then
										option:Set(false)
										n9 += 1
									end
								end
							end
						end
					end
				end

				return n9
			end

			Q = window:GetTab("Settings")

			if Q then
				u = Q:CreateSection({Name = "Defaults", Expanded = true})
				u:CreateButton({Name = "Reset to Defaults", ButtonText = "Reset", ConfirmText = "Done!", Note = "Reset every feature to its built-in default", Quick = false, Callback = fn30})

				u:CreateButton({Name = "Turn Off All Toggles", ButtonText = "Turn Off", ConfirmText = "Done!", Note = "Switch off every enabled toggle in the feature tabs", Callback = function()
					N(("Turned off %d toggle(s)."):format((fn31())))
				end})
			end

			u = window:CreateTab({Name = "Config", Side = "Right"})
			fn30 = u:CreateSection("Config")
			j = fn27(fn30:CreateLabel({Name = "Startup Config", Text = "Startup Config: " .. V.Startup, Note = ((V.Startup:lower() ~= V.Active:lower()) and i) or ""}))
			fn22()

			B = fn27(fn30:CreateToggle({Name = "Auto Save Config", Default = V.AutoSave, Note = "Auto save: " .. V.Active, Callback = function(autoSave)
				V.AutoSave = autoSave
				d()
				if not J() then
					return
				end

				if autoSave then
					local v49, v50 = fn23(V.Active, false)
					if not v49 then
						N("Auto Save enable failed: " .. tostring(v50))
						return
					end
					N("Auto Save enabled: " .. V.Active)
				else
					N("Auto Save disabled.")
				end
			end}))

			z = fn27(fn30:CreateToggle({Name = "Auto Load Config", Default = V.AutoLoad, Note = "Auto load: " .. V.Startup, Callback = function(autoLoad)
				V.AutoLoad = autoLoad
				d()
				if not J() then
					return
				end

				if autoLoad then
					D()

					if fn26(V.Startup, true) and V.AutoSave then
						fn23(V.Active, false)
					end
				else
					N("Auto Load disabled.")
				end
			end}))

			Q = u:CreateSection("Profiles")
			G = fn27(Q:CreateInput({Name = "New Config Name", Placeholder = "New config name...", Default = ""}))

			fn27(Q:CreateButton({Name = "Create New Config", ButtonText = "Create New", ConfirmText = "", Note = "New config copies current settings", Callback = function()
				local match, v49, v50 = tostring(G:Get() or ""):match("^%s*(.-)%s*$") or ""

				if match == "" then
					v50 = (fn18())
				else
					v50, v49 = P(match)
				end

				if not v50 then
					N(v49)
					return
				end

				if fn17(v50) then
					N("Config name already exists.")
					return
				end
				match, v49 = fn23(v50, false)
				if not match then
					N(v49)
					return
				end
				v49 = J()
				G:Set("", false)
				D()
				O(v50)

				if v49 then
					N("Created from current settings: " .. (v50 .. ". Open Load Config to make it active."))
				end
			end}))

			h = fn27(Q:CreateActionMultiDropdown({Name = "Delete Config", Options = t(), Default = {}, Hint = "Tick the configs to remove, then press Delete", ButtonText = "Delete", Callback = function(arg3)
				local arg32 = ((type(arg3) == "table") and arg3) or {arg3}
				if #arg32 == 0 then
					N("Tick at least one config to delete.")
					return
				end
				local tbl6, tbl7, tbl8, tbl9, flag2, flag3 = {}, {}, {}, {}, false, false

				for i2, v49 in ipairs(arg32) do
					i2 = tostring(v49)

					if i2:lower() == startup:lower() then
						table.insert(tbl7, i2)
					else
						v49 = fn17(i2)

						if not v49 then
							table.insert(tbl8, i2)
						else
							n8 += 1
							local v50, v51 = o(c(v49))

							if v50 then
								table.insert(tbl6, v49)
								flag2, flag3 = if v49:lower() == V.Active:lower() then true else flag2, if v49:lower() == V.Startup:lower() then true else flag3
							else
								table.insert(tbl9, v49 .. (" (" .. (tostring(v51) .. ")")))
							end
						end
					end
				end

				if flag3 then
					V.Startup = startup
				end

				if flag2 then
					if not fn26(startup, false) then
						V.Active = startup
						arg32, arg3 = fn23(startup, false)

						if not arg32 then
							D()
							N("Deleted " .. (table.concat(tbl6, ", ") .. ("; default recovery failed: " .. tostring(arg3))))
							return
						end
					end
				end

				flag3 = J()
				D()

				if h and not h._destroyed then
					h:Set({}, false)
				end

				if not flag3 then
					return
				end
				flag2 = {}

				if #tbl6 > 0 then
					table.insert(flag2, "Deleted: " .. table.concat(tbl6, ", "))
				end

				if #tbl7 > 0 then
					table.insert(flag2, "Default config cannot be deleted")
				end

				if #tbl8 > 0 then
					table.insert(flag2, "Not found: " .. table.concat(tbl8, ", "))
				end

				if #tbl9 > 0 then
					table.insert(flag2, "Failed: " .. table.concat(tbl9, ", "))
				end

				if #flag2 == 0 then
					table.insert(flag2, "Nothing was deleted.")
				end

				N(table.concat(flag2, " | "))
			end}))

			w = fn27(Q:CreateActionDropdown({Name = "Set Startup Config", Options = t(), Default = V.Startup, Hint = "Pick a config to auto load next time, then press Set", ButtonText = "Set Startup", Callback = function(arg3)
				local startupConfigSet = fn17(arg3)

				if not startupConfigSet then
					N("That config no longer exists.")
					D()
					return
				end

				V.Startup = startupConfigSet
				if not J() then
					return
				end
				fn22()
				d()
				N("Startup config set: " .. startupConfigSet)
			end}))

			I = fn27(Q:CreateActionDropdown({Name = "Load Config", Options = t(), Default = V.Active, Hint = "Pick a config, then press Load to apply it now", ButtonText = "Load", Callback = function(arg3)
				fn26(arg3, true)
			end}))

			e = fn27(Q:CreateButton({Name = "Save Config", ButtonText = "Save", ConfirmText = "", Note = "Save: " .. V.Active, Callback = function()
				fn23(V.Active, true)
			end}))

			fn30, Q = u:CreateSection({Name = "Import / Export", Expanded = true}), t()
			u = fn17(V.Active) or Q[1]

			v48 = fn27(fn30:CreateActionDropdown({Name = "Export Config", Options = Q, Default = u, Hint = "Pick a config, then press Export to copy its text", ButtonText = "Export", Callback = function(arg3)
				local v49, v50, exportedToClipboard = F(((fn17(arg3) or (fn17(v48 and (v48:Get())))) or (fn17(V.Active))) or t()[1])

				if not v49 then
					N("Export failed: " .. tostring(v50))
					r("Export Failed", v50)
					return
				end

				v50, arg3 = R(v49)

				if not v50 then
					N(arg3)
					r("Export Failed", arg3)
					return
				end

				N("Exported to clipboard: " .. exportedToClipboard)
				r("Config Exported", exportedToClipboard .. " was copied to the clipboard.")
			end}))

			if u then
				v48:Set(u, false)
			end

			local v49 = fn27(fn30:CreateInput({Name = "Import Config Text", Placeholder = "Paste exported config JSON...", Default = ""}))

			fn27(fn30:CreateButton({Name = "Import Config", ButtonText = "Import", ConfirmText = "", Note = "Creates a config only; use Load Config or Set Startup after", Quick = false, Callback = function()
				local v50, str3, v51 = fn28(v49:Get())

				if not v50 then
					N("Import failed: " .. tostring(v51))
					r("Import Failed", v51)
					return
				end

				v51 = fn29(v50)
				local str4, v52 = fn23(v51, false, str3)

				if not str4 then
					N("Import failed: " .. tostring(v52))
					r("Import Failed", v52)
					return
				end

				str4, v50 = J()
				v49:Set("", false)
				D()
				O(v51)

				if not str4 then
					str3 = "Imported as " .. (v51 .. (", but config state save failed: " .. tostring(v50)))
					N(str3)
					r("Imported With Warning", str3)
					return
				end

				str4 = "Imported: " .. (v51 .. ". Open Load Config to apply, or Set Startup Config for Auto Load.")
				N(str4)
				r("Config Imported", str4, 5)
			end}))

			d()
			V.AutoSaveOption = B
			V.AutoLoadOption = z
			mainTab:Select()

			task.defer(function()
				RunService.Heartbeat:Wait()
				a()

				if type(b(c(startup))) ~= "table" then
					local v50, v51 = fn23(startup, false)
					if not v50 then
						N("Default config create failed: " .. tostring(v51))
						return
					end
				end

				local v50 = fn17(V.Startup)

				if v50 then
					V.Startup = v50
				else
					V.Startup = startup
				end

				if not J() then
					return
				end
				D()
				O(V.Startup)

				if V.AutoLoad then
					fn26(V.Startup, true)

					if V.AutoSave then
						fn23(V.Active, false)
					end
				else
					N("Ready. Startup " .. (V.Startup .. ("; Active " .. V.Active)))
				end
			end)
		end;

		(function()
			local namespace = (tbl.Namespace and ("ChilliQuick_" .. tbl.Namespace)) or "ChilliQuickBar"
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
			local touchEnabled = (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) and not UserInputService.MouseEnabled
			local touchEnabled2 = (touchEnabled and 150) or 120
			local P, t, x = touchEnabled2 / 100, {true, true, true, true, true}, {Zero = "0", One = "1", Two = "2", Three = "3", Four = "4", Five = "5", Six = "6", Seven = "7", Eight = "8", Nine = "9", KeypadZero = "Num0", KeypadOne = "Num1", KeypadTwo = "Num2", KeypadThree = "Num3", KeypadFour = "Num4", KeypadFive = "Num5", KeypadSix = "Num6", KeypadSeven = "Num7", KeypadEight = "Num8", KeypadNine = "Num9", LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift", LeftAlt = "LAlt", RightAlt = "RAlt", Return = "Enter", Space = "Space", Backspace = "Back"}

			local function V(W)
				if not W then
					return nil
				end
				return x[W] or (tostring(W))
			end

			for _, child in ipairs(v4:GetChildren()) do
				if child:IsA("ScreenGui") and (child.Name == namespace) then
					child:Destroy()
				end
			end

			local function fn17(W)
				for _, tab in ipairs(window.Tabs) do
					if not tab._destroyed then
						for _, section in ipairs(tab.Sections) do
							if not section._destroyed then
								for _, option in ipairs(section.Options) do
									if not option._destroyed and option.Instance then
										W(option, section, tab)
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

			local function fn18(C)
				return (U[C.Type] == true) and (C._quickIgnored ~= true)
			end

			local function fn19(C)
				return ("%s > %s > %s"):format(C.Section.Tab.Name, C.Section.Name, C.Name)
			end

			local function C(a)
				local j

				fn17(function(G)
					local I = not j and (fn19(G) == a)

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

				local ok, I = pcall(function()
					return Enum.KeyCode[G]
				end)

				return (ok and I) or nil
			end

			local j = {}

			local function G(I)
				local h = j[I]
				if not h or not h.Parent then
					return
				end
				local uiScale = h:FindFirstChildOfClass("UIScale")
				if not uiScale then
					return
				end
				TweenService:Create(uiScale, TweenInfo.new(0.055, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 0.94}):Play()

				task.delay(0.07, function()
					if uiScale.Parent then
						TweenService:Create(uiScale, TweenInfo.new(0.09, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = 1}):Play()
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

			local h, w, tbl5 = {}, {}, {}

			fn17(function(e)
				if not W(e) then
					return
				end
				local B = fn19(e)

				if e._quickPinDefault then
					table.insert(h, B)
				end

				local z = tonumber(e._quickBarDefault)

				if z then
					tbl5[B] = math.clamp(math.floor(z), 1, 5)
				end

				z = (fn18(e) and (a(e._quickKeyDefault))) or nil

				if z then
					w[B] = z.Name
				end
			end)

			local function fn20(e)
				local B = {}

				for i, v48 in ipairs(e or {}) do
					B[i] = v48
				end

				return B
			end

			local function e(B)
				local z = {}

				for k2, v48 in pairs(B or {}) do
					z[k2] = v48
				end

				return z
			end

			local manualQuickDefaults = v40.ManualQuickDefaults

			if (type(manualQuickDefaults) == "table") and (type(manualQuickDefaults.PinnedFeatures) == "table") then
				h = fn20(manualQuickDefaults.PinnedFeatures)
			end

			if (type(manualQuickDefaults) == "table") and (type(manualQuickDefaults.Keybinds) == "table") then
				w = e(manualQuickDefaults.Keybinds)
			end

			if (type(manualQuickDefaults) == "table") and (type(manualQuickDefaults.PinGroups) == "table") then
				tbl5 = e(manualQuickDefaults.PinGroups)
			end

			local z, v48, i, N, J, d, E = if type(manualQuickDefaults) == "table" then manualQuickDefaults.LeftCenterHidden == true else false, window:CreateState({Name = "Quick Pinned Features", Default = fn20(h)}), window:CreateState({Name = "Quick Keybinds", Default = e(w)}), window:CreateState({Name = "Quick Panel Position", Default = {}}), window:CreateState({Name = "Quick Panel Collapsed", Default = {}}), window:CreateState({Name = "Quick Pin Groups", Default = e(tbl5)}), window:CreateState({Name = "Quick Open Key", Default = "LeftControl"})
			local D = window:CreateState({Name = "Quick LeftCenter Hidden", Default = z})

			local function O()
				local T = v48:Get()
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

			local function fn21(arg3)
				for _, v49 in ipairs(O()) do
					if v49 == arg3 then
						return true
					end
				end

				return false
			end

			local function fn22(F, R)
				local Z = fn20(O())
				local i2

				for i3, v49 in ipairs(Z) do
					if v49 == F then
						i2 = i3
						break
					end
				end

				if R and not i2 then
					table.insert(Z, F)
				elseif not R and i2 then
					table.remove(Z, i2)
				else
					return
				end

				v48:Set(Z)
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
				local v49 = e(F())
				v49[H] = math.clamp(math.floor(L), 1, s)
				d:Set(v49)
			end

			local function fn23()
				local H = {}

				for _, state in ipairs(window.States) do
					H[state] = true
				end

				fn17(function(L)
					if L.State then
						H[L.State] = true
					end
				end)

				return H
			end

			local function H()
				local L = {}

				local function fn24(arg3)
					while L[arg3] and (L[arg3] ~= arg3) do
						arg3 = L[arg3]
					end

					return arg3
				end

				local function fn25(arg3, arg4)
					if not arg3 or not arg4 then
						return
					end
					L[arg3] = L[arg3] or arg3
					L[arg4] = L[arg4] or arg4
					local v49, v50 = fn24(arg3), fn24(arg4)

					if v49 ~= v50 then
						L[v49] = v50
					end
				end

				local v49 = fn23()

				for k2 in pairs(v49) do
					L[k2] = L[k2] or k2
				end

				for k2 in pairs(v49) do
					for _, link in ipairs(k2._links) do
						if link.Connected then
							fn25(k2, link.Target)
						end
					end

					for k3 in pairs(k2._groups) do
						local k4

						for k5 in pairs(k3._members) do
							if k4 then
								fn25(k4, k5)
							else
								k4 = k5
							end
						end

						fn25(k2, k4)
					end
				end

				return fn24
			end

			local function fn24(L, arg3)
				if not arg3 then
					return nil
				end
				local v49 = C(L)
				if not v49 then
					return nil
				end
				local v50, keybindGroup = H(), v49._keybindGroup
				local state = (v49.State and (v50(v49.State))) or nil

				for k2, v51 in pairs(T()) do
					if (v51 == arg3) and (k2 ~= L) then
						v49 = C(k2)

						if v49 then
							if keybindGroup and (v49._keybindGroup == keybindGroup) then
								return v49
							end

							if (state and v49.State) and (v50(v49.State) == state) then
								return v49
							end
						end
					end
				end

				return nil
			end

			local function fn25(L, arg3)
				if (arg3 and (fn24(L, arg3.Name))) or nil then
					return false
				end
				local v49 = e(T())
				v49[L] = (arg3 and arg3.Name) or nil
				i:Set(v49)
				return true
			end

			local fn26 = nil

			fn26 = function(parent, arg3, arg4, arg5, arg6)
				local switch = Instance.new("Frame")
				switch.Name = "Switch"
				switch.Active = false
				switch.AnchorPoint = Vector2.new(arg3, 0.5)
				switch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				switch.BorderSizePixel = 0
				switch.Position = UDim2.fromScale(arg4, 0.5)
				switch.Size = UDim2.fromScale(arg5, arg6)
				switch.ZIndex = 6
				switch.Parent = parent
				v28(switch, Enum.ApplyStrokeMode.Border, 0.06)
				local off = Instance.new("UIGradient")
				off.Name = "OFF"
				off.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
				off.Rotation = 90
				off.Transparency = NumberSequence.new(0.6)
				off.Parent = switch
				local on = Instance.new("UIGradient")
				on.Name = "ON"
				on.Color = v30
				on.Rotation = 90
				on.Parent = switch
				local hold = Instance.new("Frame")
				hold.Name = "Hold"
				hold.Active = false
				hold.AnchorPoint = Vector2.new(0.5, 0.5)
				hold.BackgroundColor3 = Color3.fromRGB(89, 89, 89)
				hold.BorderSizePixel = 0
				hold.Size = UDim2.fromScale(0.72, 0.72)
				hold.ZIndex = 7
				hold.Parent = switch
				v28(hold, Enum.ApplyStrokeMode.Border, 0.09)
				arg4 = Instance.new("UIAspectRatioConstraint")
				arg4.AspectRatio = 1
				arg4.AspectType = Enum.AspectType.FitWithinMaxSize
				arg4.DominantAxis = Enum.DominantAxis.Width
				arg4.Parent = hold
				arg5 = Instance.new("Frame")
				arg5.Name = "Color"
				arg5.Active = false
				arg5.AnchorPoint = Vector2.new(0.5, 0)
				arg5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				arg5.BorderSizePixel = 0
				arg5.Position = UDim2.fromScale(0.5, 0)
				arg5.Size = UDim2.fromScale(1, 0.9)
				arg5.ZIndex = 8
				arg5.Parent = hold

				return switch, function(enabled, arg7)
					off.Enabled = not enabled
					on.Enabled = enabled
					local udim2 = UDim2.fromScale((enabled and 0.72) or 0.28, 0.5)

					if arg7 == false then
						hold.Position = udim2
					else
						TweenService:Create(hold, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = udim2}):Play()
					end
				end
			end

			local function createTextButton(parent, arg3, arg4, arg5, arg6, zIndex)
				local keyChip = Instance.new("TextButton")
				keyChip.AutoButtonColor = false
				keyChip.Text = ""
				keyChip.Name = "KeyChip"
				keyChip.Active = false
				keyChip.Selectable = false
				keyChip.AnchorPoint = Vector2.new(arg3, 0.5)
				keyChip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				keyChip.BackgroundTransparency = 0.35
				keyChip.BorderSizePixel = 0
				keyChip.Position = UDim2.fromScale(arg4, 0.5)
				keyChip.Size = UDim2.fromScale(arg5, arg6)
				keyChip.Text = ""
				keyChip.TextWrapped = false
				keyChip.ZIndex = zIndex
				keyChip.Parent = parent
				v25(keyChip)
				v28(keyChip, Enum.ApplyStrokeMode.Border, 0.1)
				return keyChip
			end

			local function createTextLabel(parent, arg3)
				if not arg3 then
					return
				end
				local barKeyChip = Instance.new("TextLabel")
				barKeyChip.Name = "BarKeyChip"
				barKeyChip.Active = false
				barKeyChip.AnchorPoint = Vector2.new(0, 0.5)
				barKeyChip.BackgroundTransparency = 1
				barKeyChip.BorderSizePixel = 0
				barKeyChip.Position = UDim2.fromScale(0.025, 0.485)
				barKeyChip.Size = UDim2.fromScale(0.153, 0.612)
				barKeyChip.Text = "[" .. (tostring(arg3) .. "]")
				barKeyChip.TextWrapped = false
				barKeyChip.TextXAlignment = Enum.TextXAlignment.Left
				barKeyChip.TextYAlignment = Enum.TextYAlignment.Center
				barKeyChip.ZIndex = 6
				barKeyChip.Parent = parent
				v25(barKeyChip)
				barKeyChip.TextColor3 = Color3.fromRGB(190, 190, 190)
				return barKeyChip
			end

			local str3 = nil
			local fn27 = nil

			fn27 = function()
				local v49, keyboardEnabled = T(), UserInputService.KeyboardEnabled

				fn17(function(arg3)
					local mirrorOf = arg3._mirrorOf
					mirrorOf = if mirrorOf and mirrorOf._destroyed then nil else mirrorOf
					if not fn18(mirrorOf or arg3) then
						return
					end
					local main = arg3.Instance:FindFirstChild("Main")
					if not main then
						return
					end
					local label, note, optionKeyChip, keyboardEnabled2 = main:FindFirstChild("Label"), main:FindFirstChild("Note"), main:FindFirstChild("OptionKeyChip"), (keyboardEnabled and (V(v49[fn19(mirrorOf or arg3)]))) or nil

					if not keyboardEnabled2 then
						if optionKeyChip then
							optionKeyChip:Destroy()
						end

						if label and arg3._quickLabelSize then
							label.Size = arg3._quickLabelSize
						end

						if note and arg3._quickNoteSize then
							note.Size = arg3._quickNoteSize
						end

						arg3._quickLabelSize = nil
						arg3._quickNoteSize = nil
						return
					end

					local n8, n9 = ((arg3.Type == "button") and 0.772) or 0.822, 0.082
					local n10 = n8 - n9
					local visible = (((note and (note:IsA("TextLabel"))) and note.Visible) and ((0.42 * v34) / v31)) or 0.42

					if not optionKeyChip then
						optionKeyChip = createTextButton(main, 1, n8, n9, visible, 7)
						optionKeyChip.Name = "OptionKeyChip"
						optionKeyChip.Active = true
						v35(optionKeyChip, 1.06, 0.94)
						local L = fn19(mirrorOf or arg3)

						v15(optionKeyChip, function()
							str3 = L
							optionKeyChip.Text = "?"
						end)
					end

					optionKeyChip.Position = UDim2.fromScale(n8, 0.5)
					optionKeyChip.Size = UDim2.fromScale(n9, visible)
					optionKeyChip.Text = keyboardEnabled2
					keyboardEnabled2 = n10 - 0.015

					if label then
						if not arg3._quickLabelSize then
							arg3._quickLabelSize = label.Size
						end

						n9, mirrorOf = arg3._quickLabelSize, math.max(0.12, keyboardEnabled2 - label.Position.X.Scale)
						label.Size = UDim2.new(math.min(n9.X.Scale, mirrorOf), n9.X.Offset, n9.Y.Scale, n9.Y.Offset)
					end

					if note and (note:IsA("TextLabel")) then
						if not arg3._quickNoteSize then
							arg3._quickNoteSize = note.Size
						end

						mirrorOf, n8 = arg3._quickNoteSize, math.max(0.12, keyboardEnabled2 - note.Position.X.Scale)
						note.Size = UDim2.new(math.min(mirrorOf.X.Scale, n8), mirrorOf.X.Offset, mirrorOf.Y.Scale, mirrorOf.Y.Offset)
					end
				end)
			end

			v46[3][v46[5]] = fn27
			local screenGui = Instance.new("ScreenGui")
			screenGui.Name = namespace
			screenGui.ResetOnSpawn = false
			screenGui.IgnoreGuiInset = true
			screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screenGui.DisplayOrder = 5
			v6.DisplayOrder = screenGui.DisplayOrder + 1
			screenGui.Enabled = false
			screenGui:SetAttribute(v3, true)

			if tbl.Namespace then
				screenGui:SetAttribute("ChilliNamespace", tbl.Namespace)
			end

			screenGui.Parent = v4
			local l, n8 = 0.03, 0.97

			local function fn28(arg3)
				local n9 = A * P
				return math.clamp(arg3, 0, math.max(0, 0.998 - (n9 * n8)))
			end

			local n9

			local function fn29()
				local absoluteSize, absoluteSize2, absolutePosition = screenGui.AbsoluteSize, v12.AbsoluteSize, v12.AbsolutePosition

				if ((absoluteSize.X > 0) and (absoluteSize2.X > 0)) and (absolutePosition.X >= 0) then
					local n10 = (absolutePosition.X + (absoluteSize2.X * 2)) - screenGui.AbsolutePosition.X
					n9 = math.clamp(n10 / absoluteSize.X, 0.018, 0.45)
				end

				return n9 or 0.11
			end

			local n10

			local function fn30()
				local absoluteSize, absoluteSize2, absolutePosition = screenGui.AbsoluteSize, v12.AbsoluteSize, v12.AbsolutePosition

				if ((absoluteSize.Y > 0) and (absoluteSize2.Y > 0)) and (absolutePosition.X >= 0) then
					local n11 = ((absolutePosition.Y + absoluteSize2.Y) + (absoluteSize2.Y * 0.15)) - screenGui.AbsolutePosition.Y
					n10 = math.clamp(n11 / absoluteSize.Y, 0.1, 0.66)
				end

				return n10 or 0.5
			end

			local n11 = 0.021
			local flag2 = false
			local flag3 = false
			local fn31 = nil

			fn31 = function(arg3)
				if ((arg3 ~= 4) and (arg3 ~= 5)) or (v11:GetAttribute("EffectiveLeftCenterHidden") ~= true) then
					return 0
				end
				return n11 - fn29()
			end

			local fn32

			local function fn33(arg3, arg4)
				local n12, v49, v50 = A * P, fn32(arg3)
				v49 -= fn31(arg3)
				if arg4 < 0 then
					return ((v49 + (n12 * l)) - (n12 * p)) - (n12 * n8), v50
				end
				return ((v49 + (n12 * n8)) + (n12 * p)) - (n12 * l), v50
			end

			local function fn34(arg3)
				local n12 = ((touchEnabled and Y) or y)[arg3] or 0.14
				if (arg3 == 1) or (arg3 == 3) then
					return 1, n12
				end

				if arg3 == 2 then
					if touchEnabled then
						return fn33(1, -1)
					end
					return 1, n12
				end

				if arg3 == 4 then
					return fn29(), fn30()
				end

				if touchEnabled then
					return fn33(4, 1)
				end
				return fn29(), math.min(fn30() + b, 0.86)
			end

			fn32 = function(arg3)
				local v49, num, num2 = N:Get(), fn34(arg3)

				if type(v49) == "table" then
					if tonumber(v49.X) and (tonumber(v49.Y)) then
						if arg3 == 1 then
							num, num2 = tonumber(v49.X), (tonumber(v49.Y))
						end
					else
						local v50 = v49[tostring(arg3)]

						if type(v50) == "table" then
							num, num2 = tonumber(v50.X) or num, tonumber(v50.Y) or num2
						end
					end
				end

				return fn28(num + fn31(arg3)), math.clamp(num2, 0, 0.98)
			end

			local function fn35(arg3, arg4, arg5)
				arg4 -= fn31(arg3)
				local v49, o = N:Get(), {}

				if (type(v49) == "table") and not tonumber(v49.X) then
					for k2, v50 in pairs(v49) do
						if type(v50) == "table" then
							o[k2] = {X = v50.X, Y = v50.Y}
						end
					end
				elseif (type(v49) == "table") and (tonumber(v49.X)) then
					o["1"] = {X = v49.X, Y = v49.Y}
				end

				o[tostring(arg3)] = {X = arg4, Y = arg5}
				N:Set(o)
			end

			local tbl6 = {}

			local function fn36(arg3)
				local frame = Instance.new("Frame")
				frame.Name = "QuickBar" .. tostring(arg3)
				frame.Active = false
				frame.AnchorPoint = Vector2.new(0, 0)
				frame.BackgroundTransparency = 1
				frame.BorderSizePixel = 0
				frame.ClipsDescendants = false
				frame.Size = UDim2.fromScale(A, k)
				frame.Visible = false
				frame.ZIndex = 2
				frame.Parent = screenGui
				local handle = Instance.new("TextButton")
				handle.Name = "Handle"
				handle.Active = true
				handle.AutoButtonColor = false
				handle.AnchorPoint = Vector2.new(0.5, 0)
				handle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				handle.BackgroundTransparency = 0.35
				handle.BorderSizePixel = 0
				handle.Position = UDim2.fromScale(0.5, 0)
				handle.Size = UDim2.fromScale(0.94, 1)
				handle.Text = ""
				handle.ZIndex = 3
				handle.Parent = frame
				v28(handle, Enum.ApplyStrokeMode.Border, 0.06)
				local uiElement = Instance.new("Frame")
				uiElement.Name = "HeaderAccent"
				uiElement.Active = false
				uiElement.AnchorPoint = Vector2.new(0.5, 1)
				uiElement.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				uiElement.BackgroundTransparency = 0.08
				uiElement.BorderSizePixel = 0
				uiElement.Position = UDim2.fromScale(0.5, 1)
				uiElement.Size = UDim2.fromScale(1, 0.07)
				uiElement.ZIndex = 4
				uiElement.Parent = handle
				uiElement = Instance.new("TextLabel")
				uiElement.Name = "Title"
				uiElement.Active = false
				uiElement.AnchorPoint = Vector2.new(0, 0.5)
				uiElement.BackgroundTransparency = 1
				uiElement.BorderSizePixel = 0
				uiElement.Position = UDim2.fromScale(0.07, 0.5)
				uiElement.Size = UDim2.fromScale(0.62, 0.55)
				uiElement.Text = "Quick Bar " .. tostring(arg3)
				uiElement.TextWrapped = false
				uiElement.TextXAlignment = Enum.TextXAlignment.Left
				uiElement.ZIndex = 4
				uiElement.Parent = handle
				v24(uiElement, v22)
				local body = Instance.new("Frame")
				body.Name = "Body"
				body.Active = false
				body.AnchorPoint = Vector2.new(0.5, 0)
				body.BackgroundTransparency = 1
				body.BorderSizePixel = 0
				body.ClipsDescendants = true
				body.Position = UDim2.fromScale(0.5, 1)
				body.Size = UDim2.fromScale(1.32, 0)
				body.ZIndex = 2
				body.Parent = frame
				uiElement = Instance.new("UIPadding")
				uiElement.Name = "BodyPadding"
				uiElement.PaddingLeft = UDim.new(0.03, 0)
				uiElement.PaddingRight = UDim.new(0.03, 0)
				uiElement.Parent = body
				uiElement = Instance.new("UIListLayout")
				uiElement.Name = "BodyLayout"
				uiElement.FillDirection = Enum.FillDirection.Vertical
				uiElement.HorizontalAlignment = Enum.HorizontalAlignment.Center
				uiElement.VerticalAlignment = Enum.VerticalAlignment.Top
				uiElement.SortOrder = Enum.SortOrder.LayoutOrder
				uiElement.Parent = body
				local collapse = Instance.new("TextButton")
				collapse.Name = "Collapse"
				collapse.Active = true
				collapse.AutoButtonColor = false
				collapse.AnchorPoint = Vector2.new(1, 0.5)
				collapse.BackgroundTransparency = 1
				collapse.BorderSizePixel = 0
				collapse.Position = UDim2.fromScale(0.955, 0.5)
				collapse.Size = UDim2.fromScale(0.17, 0.6)
				collapse.Text = ""
				collapse.ZIndex = 4
				collapse.Parent = handle
				local caret = Instance.new("Frame")
				caret.Name = "Caret"
				caret.Active = false
				caret.AnchorPoint = Vector2.new(0.5, 0.5)
				caret.BackgroundTransparency = 1
				caret.BorderSizePixel = 0
				caret.Position = UDim2.fromScale(0.5, 0.5)
				caret.Size = UDim2.fromScale(0.85, 0.85)
				caret.ZIndex = 4
				caret.Parent = collapse
				local uiAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
				uiAspectRatioConstraint.AspectRatio = 1
				uiAspectRatioConstraint.AspectType = Enum.AspectType.FitWithinMaxSize
				uiAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
				uiAspectRatioConstraint.Parent = caret
				uiAspectRatioConstraint = {{0.335355, 45}, {0.664645, -45}}

				for i2, v49 in ipairs(uiAspectRatioConstraint) do
					i2 = Instance.new("Frame")
					i2.Name = "Arm"
					i2.Active = false
					i2.AnchorPoint = Vector2.new(0.5, 0.5)
					i2.BackgroundColor3 = v33
					i2.BorderSizePixel = 0
					i2.Position = UDim2.fromScale(v49[1], 0.535355)
					i2.Rotation = v49[2]
					i2.Size = UDim2.fromScale(0.6657, 0.2)
					i2.ZIndex = 5
					i2.Parent = caret
				end

				local tbl7 = {Panel = frame, Body = body, BodyLayout = uiElement, Handle = handle, Caret = caret, Items = {}, Connections = {}, Index = arg3, Collapsed = S(arg3), BodyFraction = 0, SizeTween = nil}

				local function toggleCollapsed()
					tbl7.Collapsed = not tbl7.Collapsed
					X(arg3, tbl7.Collapsed)

					if tbl7.SizeTween then
						tbl7.SizeTween:Cancel()
					end

					local tweenInfo = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
					tbl7.SizeTween = TweenService:Create(body, tweenInfo, {Size = UDim2.fromScale(1.32, (tbl7.Collapsed and 0) or tbl7.BodyFraction)})
					tbl7.SizeTween:Play()
					TweenService:Create(caret, tweenInfo, {Rotation = (tbl7.Collapsed and 180) or 0}):Play()
				end

				v15(collapse, toggleCollapsed)
				local flag4, input = false
				local flag5, vector2, vector22 = false, Vector2.new(0, 0), Vector2.new(0, 0)

				handle.InputBegan:Connect(function(input2)
					if flag4 or (input2.UserInputState ~= Enum.UserInputState.Begin) then
						return
					end

					if (input2.UserInputType ~= Enum.UserInputType.MouseButton1) and (input2.UserInputType ~= Enum.UserInputType.Touch) then
						return
					end
					local vector23, absolutePosition, absoluteSize = Vector2.new(input2.Position.X, input2.Position.Y), handle.AbsolutePosition, handle.AbsoluteSize
					if (((vector23.X < absolutePosition.X) or (vector23.X > (absolutePosition.X + absoluteSize.X))) or (vector23.Y < absolutePosition.Y)) or (vector23.Y > (absolutePosition.Y + absoluteSize.Y)) then
						return
					end
					absolutePosition, absoluteSize = collapse.AbsolutePosition, collapse.AbsoluteSize
					if (((vector23.X >= absolutePosition.X) and (vector23.X <= (absolutePosition.X + absoluteSize.X))) and (vector23.Y >= absolutePosition.Y)) and (vector23.Y <= (absolutePosition.Y + absoluteSize.Y)) then
						return
					end
					flag4, flag5 = true, false
					input = ((input2.UserInputType == Enum.UserInputType.Touch) and input2) or nil
					vector2 = Vector2.new(input2.Position.X, input2.Position.Y)
					vector22 = Vector2.new(frame.Position.X.Scale, frame.Position.Y.Scale)
				end)

				v10(UserInputService.InputChanged:Connect(function(input2)
					if not flag4 then
						return
					end

					if not ((input and (input2 == input)) or (not input and (input2.UserInputType == Enum.UserInputType.MouseMovement))) then
						return
					end
					local absoluteSize = screenGui.AbsoluteSize
					if (absoluteSize.X <= 0) or (absoluteSize.Y <= 0) then
						return
					end
					local n12 = Vector2.new(input2.Position.X, input2.Position.Y) - vector2
					if not flag5 and (n12.Magnitude < 6) then
						return
					end
					flag5 = true
					frame.Position = UDim2.fromScale(fn28(vector22.X + (n12.X / absoluteSize.X)), math.clamp(vector22.Y + (n12.Y / absoluteSize.Y), 0, 0.98))
				end))

				v10(UserInputService.InputEnded:Connect(function(input2)
					if not flag4 then
						return
					end

					if (input2.UserInputType == Enum.UserInputType.MouseButton1) or (input2 == input) then
						flag4, input = false, nil

						if flag5 then
							fn35(arg3, frame.Position.X.Scale, frame.Position.Y.Scale)
						else
							toggleCollapsed()
						end
					end
				end))

				return tbl7
			end

			for i2 = 1, s, 1 do
				tbl6[i2] = fn36(i2)
			end

			local function fn37(arg3)
				for i2 = #arg3.Connections, 1, -1 do
					local o = arg3.Connections[i2]

					if o and o.Disconnect then
						o:Disconnect()
					end

					arg3.Connections[i2] = nil
				end

				for i2 = #arg3.Items, 1, -1 do
					arg3.Items[i2]:Destroy()
					arg3.Items[i2] = nil
				end
			end

			local function fn38(arg3, o, arg4, layoutOrder, arg5)
				local textButton = Instance.new("TextButton")
				textButton.Name = "Item" .. tostring(layoutOrder)
				textButton.Active = true
				textButton.AutoButtonColor = false
				textButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				textButton.BackgroundTransparency = 0.4
				textButton.BorderSizePixel = 0
				textButton.LayoutOrder = layoutOrder
				textButton.Size = UDim2.fromScale(0.7121, arg5)
				textButton.Text = ""
				textButton.ZIndex = 3
				textButton.Parent = arg3.Body
				v28(textButton, Enum.ApplyStrokeMode.Border, 0.05)
				arg5 = Instance.new("TextLabel")
				arg5.Name = "Label"
				arg5.Active = false
				arg5.AnchorPoint = Vector2.new(0, 0.5)
				arg5.BackgroundTransparency = 1
				arg5.BorderSizePixel = 0
				arg5.AnchorPoint = Vector2.new(0, 0.5)
				arg5.Position = UDim2.fromScale((arg4 and 0.19) or 0.03, 0.5)
				arg5.Size = UDim2.fromScale((arg4 and 0.52) or 0.68, 0.72)
				arg5.Text = tostring(o:GetQuickName())
				arg5.TextWrapped = false
				arg5.TextXAlignment = Enum.TextXAlignment.Center
				arg5.ZIndex = 4
				arg5.Parent = textButton
				v25(arg5)
				createTextLabel(textButton, arg4)
				local v49, v50 = fn26(textButton, 1, 0.955, 0.23, 0.56)
				local flag4 = false

				local function fn39()
					v50(o:Get() == true, flag4)
					flag4 = true
				end

				fn39()

				if o.State then
					table.insert(arg3.Connections, o.State:Subscribe(fn39))
				end

				v15(textButton, function()
					I(o)
				end)

				table.insert(arg3.Items, textButton)
			end

			local function fn39(o, arg3, arg4, arg5, arg6)
				local v49 = v29(o.Body, arg3:GetQuickName(), arg5)
				v49.Name = "Item" .. tostring(arg5)
				v49.Size = UDim2.fromScale(0.7121, arg6)
				v49.ZIndex = 3
				arg5 = v49:FindFirstChild("Main")
				arg5 = arg5 and (arg5:FindFirstChild("ColorFrame"))
				arg6 = arg5 and (arg5:FindFirstChild("Label"))

				if arg6 then
					arg6.AnchorPoint = Vector2.new(0.5, 0.5)
					arg6.Position = UDim2.fromScale((arg4 and 0.58) or 0.5, 0.5)
					arg6.Size = UDim2.fromScale((arg4 and 0.78) or 0.94, 0.68)
					arg6.TextXAlignment = Enum.TextXAlignment.Center
					arg6.Text = tostring(arg3:GetQuickName())
				end

				createTextLabel(v49, arg4)

				v15(v49, function()
					I(arg3)
				end)

				j[fn19(arg3)] = v49
				table.insert(o.Items, v49)
			end

			local function o(arg3, arg4)
				local flag4, n12 = false, 0

				pcall(function()
					flag4, n12 = arg3:GetDecimals()
				end)

				arg4 = tonumber(arg4) or 0
				if flag4 then
					return string.format("%." .. (tostring(n12 or 1) .. "f"), arg4)
				end
				return tostring(math.round(arg4))
			end

			local function createFrame(arg3, layoutOrder, arg4)
				local frame = Instance.new("Frame")
				frame.Name = "Item" .. tostring(layoutOrder)
				frame.Active = false
				frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				frame.BackgroundTransparency = 0.4
				frame.BorderSizePixel = 0
				frame.LayoutOrder = layoutOrder
				frame.Size = UDim2.fromScale(0.7121, arg4)
				frame.ZIndex = 3
				frame.Parent = arg3.Body
				v28(frame, Enum.ApplyStrokeMode.Border, 0.05)
				table.insert(arg3.Items, frame)
				return frame
			end

			local function createTextLabel2(parent, arg3)
				local label = Instance.new("TextLabel")
				label.Name = "Label"
				label.Active = false
				label.AnchorPoint = Vector2.new(0, 0.5)
				label.BackgroundTransparency = 1
				label.BorderSizePixel = 0
				label.Text = tostring(arg3:GetQuickName())
				label.TextWrapped = false
				label.TextXAlignment = Enum.TextXAlignment.Left
				label.TextYAlignment = Enum.TextYAlignment.Center
				label.ZIndex = 4
				label.Parent = parent
				v25(label)
				return label
			end

			local function fn40(arg3, arg4, arg5, arg6)
				local v49 = createFrame(arg3, arg5, arg6)
				arg5 = createTextLabel2(v49, arg4)
				arg5.Position = UDim2.fromScale(0.035, 0.255)
				arg5.Size = UDim2.fromScale(0.67, 0.34)
				arg5 = arg4.Instance and (arg4.Instance:FindFirstChild("Main"))
				local main, slider = arg5 and (arg5:FindFirstChild("Value", true)), arg5 and (arg5:FindFirstChild("Slider", true))
				local clone, clone2 = main and (main:Clone()), slider and (slider:Clone())

				if clone then
					clone.AnchorPoint = Vector2.new(0.5, 0.5)
					clone.Position = UDim2.fromScale(0.84, 0.255)
					clone.Size = UDim2.fromScale(0.25, 0.34)
					clone.ZIndex = 5
					clone.Parent = v49
				end

				if clone2 then
					clone2.Position = UDim2.fromScale(0.5, 0.735)
					clone2.Size = UDim2.fromScale(0.92, 0.24)
					clone2.ZIndex = 4
					clone2.Parent = v49
				end

				local bar, hold = clone2 and (clone2:FindFirstChild("Bar")), clone2 and (clone2:FindFirstChild("Hold"))
				if (not clone2 or not bar) or not hold then
					return
				end
				clone2.Active = true
				bar.Active = true
				hold.Active = true

				local function fn41()
					if not hold.Parent or not clone2.Parent then
						return
					end
					local n12 = math.max(1, clone2.AbsoluteSize.Y * 1.38)
					hold.Size = UDim2.fromOffset(n12, n12)
				end

				fn41()
				table.insert(arg3.Connections, clone2:GetPropertyChangedSignal("AbsoluteSize"):Connect(fn41))

				local function fn42()
					if arg4._destroyed then
						return
					end
					local range, v50 = arg4:GetRange()
					local range2 = tonumber(arg4:Get()) or range
					local n12 = ((v50 > range) and (math.clamp((range2 - range) / (v50 - range), 0, 1))) or 0
					range = math.clamp(n12, 0.0575, 0.9425)
					bar.Size = UDim2.new(range, 0, 1, 0)
					hold.Position = UDim2.new(range, 0, 0.5, 0)

					if clone and not clone:IsFocused() then
						clone.RichText = false
						clone.Text = o(arg4, range2)
					end
				end

				fn42()

				if arg4.State then
					table.insert(arg3.Connections, arg4.State:Subscribe(fn42))
				end

				if clone and (clone:IsA("TextBox")) then
					clone.ClearTextOnFocus = false

					clone.FocusLost:Connect(function()
						local num = tonumber(clone.Text)

						if num ~= nil then
							arg4:Set(num, true)
						end

						fn42()
					end)
				end

				local flag4, input = false

				local function fn43(arg7)
					if arg4._destroyed or (clone2.AbsoluteSize.X <= 0) then
						return
					end
					local n12, range, v50 = math.clamp((arg7 - clone2.AbsolutePosition.X) / clone2.AbsoluteSize.X, 0, 1), arg4:GetRange()
					arg4:Set(range + ((v50 - range) * n12), true)
					fn42()
				end

				local function fn44(input2)
					if flag4 or (input2.UserInputState ~= Enum.UserInputState.Begin) then
						return
					end

					if input2.UserInputType == Enum.UserInputType.MouseButton1 then
						flag4, input = true, nil
						fn43(input2.Position.X)
					elseif input2.UserInputType == Enum.UserInputType.Touch then
						flag4, input = true, input2
						fn43(input2.Position.X)
					end
				end

				clone2.InputBegan:Connect(fn44)
				bar.InputBegan:Connect(fn44)
				hold.InputBegan:Connect(fn44)

				table.insert(arg3.Connections, UserInputService.InputChanged:Connect(function(input2)
					if not flag4 then
						return
					end

					if input then
						if input2 == input then
							fn43(input2.Position.X)
						end
					elseif input2.UserInputType == Enum.UserInputType.MouseMovement then
						fn43(input2.Position.X)
					end
				end))

				table.insert(arg3.Connections, UserInputService.InputEnded:Connect(function(input2)
					if (input2.UserInputType == Enum.UserInputType.MouseButton1) or (input2 == input) then
						flag4, input = false, nil
					end
				end))
			end

			local function fn41(arg3, arg4, arg5, arg6)
				local v49 = createFrame(arg3, arg5, arg6)
				arg5 = createTextLabel2(v49, arg4)
				arg5.Position = UDim2.fromScale(0.035, 0.5)
				arg5.Size = UDim2.fromScale(0.43, 0.7)
				arg6 = arg4.Instance and (arg4.Instance:FindFirstChild("Main"))
				arg5 = arg6 and (arg6:FindFirstChild("Field", true))
				local clone = arg5 and (arg5:Clone())
				local input = clone and (clone:FindFirstChild("Input", true))
				if (not clone or not input) or not input:IsA("TextBox") then
					return
				end
				clone.AnchorPoint = Vector2.new(0.5, 0.5)
				clone.Position = UDim2.fromScale(0.72, 0.5)
				clone.Size = UDim2.fromScale(0.48, 0.62)
				clone.ZIndex = 4
				clone.Parent = v49
				input.ClearTextOnFocus = false
				input.Text = tostring(arg4:Get() or "")
				local underline = clone:FindFirstChild("Underline", true)

				local function fn42(arg7)
					TweenService:Create(clone, TweenInfo.new(0.16), {BackgroundTransparency = (arg7 and 0.42) or 0.6}):Play()

					if underline and (underline:IsA("GuiObject")) then
						TweenService:Create(underline, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size = UDim2.fromScale((arg7 and 1) or 0, 0.11)}):Play()
					end
				end

				input.Focused:Connect(function()
					fn42(true)
				end)

				local function fn43()
					if not input:IsFocused() then
						input.Text = tostring(arg4:Get() or "")
					end
				end

				if arg4.State then
					table.insert(arg3.Connections, arg4.State:Subscribe(fn43))
				end

				input.FocusLost:Connect(function()
					fn42(false)
					arg4:Set(input.Text, true)
					fn43()
				end)
			end

			local function fn42(arg3)
				return 1
			end

			local function fn43()
				for k2 in pairs(j) do
					j[k2] = nil
				end

				local keyboardEnabled, flag4, tbl7 = UserInputService.KeyboardEnabled, T(), {}

				for i2 = 1, s, 1 do
					tbl7[i2] = {}
				end

				for i2, v49 in ipairs(O()) do
					i2 = C(v49)

					if i2 and (W(i2)) then
						local n12 = math.clamp(math.floor(tonumber(R(v49)) or 1), 1, s)
						table.insert(tbl7[n12], {Option = i2, KeyName = (keyboardEnabled and (V(flag4[v49]))) or nil})
					end
				end

				flag4 = (t[4] and (#tbl7[4] > 0)) or (t[5] and (#tbl7[5] > 0))

				if flag4 and not flag2 then
					if D:Get() ~= true then
						D:Set(true)
					end
				end

				flag2 = flag4

				for i2 = 1, s, 1 do
					keyboardEnabled = tbl6[i2]
					fn37(keyboardEnabled)
					flag4 = tbl7[i2]
					local n12 = #flag4

					if not t[i2] or (n12 == 0) then
						keyboardEnabled.Panel.Visible = false
					else
						local n13, n14, n15, tbl8 = k * P, r * P, Q * P, {}
						local n16 = math.max(n12 - 1, 0) * n15

						for i3, v49 in ipairs(flag4) do
							local n17 = n13 * fn42(v49.Option)
							tbl8[i3] = n17
							n16 += n17
						end

						n13 = (n14 + n15) + n16
						local bodyFraction = n16 / n13

						if keyboardEnabled.SizeTween then
							keyboardEnabled.SizeTween:Cancel()
							keyboardEnabled.SizeTween = nil
						end

						keyboardEnabled.BodyFraction = bodyFraction
						keyboardEnabled.Panel.Size = UDim2.fromScale(A * P, n13)
						keyboardEnabled.Handle.Size = UDim2.fromScale(0.94, n14 / n13)
						keyboardEnabled.Body.Position = UDim2.fromScale(0.5, (n14 + n15) / n13)
						keyboardEnabled.Body.Size = UDim2.fromScale(1.32, (keyboardEnabled.Collapsed and 0) or bodyFraction)
						keyboardEnabled.BodyLayout.Padding = UDim.new(n15 / n16, 0)
						keyboardEnabled.Caret.Rotation = (keyboardEnabled.Collapsed and 180) or 0

						for i3, v49 in ipairs(flag4) do
							n13, bodyFraction = tbl8[i3] / n16, v49.Option.Type

							if bodyFraction == "button" then
								fn39(keyboardEnabled, v49.Option, v49.KeyName, i3, n13)
							elseif (bodyFraction == "toggle") or (bodyFraction == "switch") then
								fn38(keyboardEnabled, v49.Option, v49.KeyName, i3, n13)
							elseif (bodyFraction == "slider") or (bodyFraction == "slidebar") then
								fn40(keyboardEnabled, v49.Option, i3, n13)
							elseif (bodyFraction == "input") or (bodyFraction == "textbox") then
								fn41(keyboardEnabled, v49.Option, i3, n13)
							end
						end

						n13, tbl8 = fn32(i2)
						keyboardEnabled.Panel.Position = UDim2.fromScale(n13, tbl8)
						keyboardEnabled.Panel.Visible = true
					end
				end
			end

			local function fn44(arg3)
				for i2 = 1, s, 1 do
					local v49, v50 = fn32(i2)
					local udim2 = UDim2.fromScale(v49, v50)

					if arg3 then
						TweenService:Create(tbl6[i2].Panel, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Position = udim2}):Play()
					else
						tbl6[i2].Panel.Position = udim2
					end
				end
			end

			v10(v11:GetAttributeChangedSignal("EffectiveLeftCenterHidden"):Connect(function()
				fn44(true)
			end))

			manualQuickDefaults = Instance.new("TextButton")
			manualQuickDefaults.Name = "HudSlideToggle"
			manualQuickDefaults.Active = true
			manualQuickDefaults.AutoButtonColor = false
			manualQuickDefaults.AnchorPoint = Vector2.new(0, 0.5)
			manualQuickDefaults.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
			manualQuickDefaults.BackgroundTransparency = 0.35
			manualQuickDefaults.BorderSizePixel = 0
			manualQuickDefaults.Position = UDim2.fromScale(0.004, 0.5)
			manualQuickDefaults.Size = UDim2.fromScale(0.018, 0.075)
			manualQuickDefaults.Text = ""
			manualQuickDefaults.ZIndex = 40
			manualQuickDefaults.Parent = v11
			v28(manualQuickDefaults, Enum.ApplyStrokeMode.Border, 0.08)
			v35(manualQuickDefaults, 1.08, 0.92)
			z = Instance.new("UIAspectRatioConstraint")
			z.AspectRatio = 0.44
			z.AspectType = Enum.AspectType.FitWithinMaxSize
			z.DominantAxis = Enum.DominantAxis.Height
			z.Parent = manualQuickDefaults
			local caret = Instance.new("Frame")
			caret.Name = "Caret"
			caret.Active = false
			caret.AnchorPoint = Vector2.new(0.5, 0.5)
			caret.BackgroundTransparency = 1
			caret.BorderSizePixel = 0
			caret.Position = UDim2.fromScale(0.5, 0.5)
			caret.Rotation = 90
			caret.Size = UDim2.fromScale(0.62, 0.62)
			caret.ZIndex = 41
			caret.Parent = manualQuickDefaults
			fn36 = Instance.new("UIAspectRatioConstraint")
			fn36.AspectRatio = 1
			fn36.AspectType = Enum.AspectType.FitWithinMaxSize
			fn36.DominantAxis = Enum.DominantAxis.Width
			fn36.Parent = caret
			fn36 = {{0.335355, 45}, {0.664645, -45}}

			for i2, v49 in ipairs(fn36) do
				i2 = Instance.new("Frame")
				i2.Name = "Arm"
				i2.Active = false
				i2.AnchorPoint = Vector2.new(0.5, 0.5)
				i2.BackgroundColor3 = v33
				i2.BorderSizePixel = 0
				i2.Position = UDim2.fromScale(v49[1], 0.535355)
				i2.Rotation = v49[2]
				i2.Size = UDim2.fromScale(0.6657, 0.2)
				i2.ZIndex = 42
				i2.Parent = caret
			end

			local function fn45(arg3)
				flag3 = D:Get() == true
				v11:SetAttribute("QuickHudHidden", flag3)
				v19(flag3 or v2.chilliIsOpen)
				local flag32 = (flag3 and -90) or 90

				if arg3 then
					TweenService:Create(caret, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Rotation = flag32}):Play()
				else
					caret.Rotation = flag32
				end

				fn44(arg3)
			end

			v15(manualQuickDefaults, function()
				D:Set(not (D:Get() == true))
			end)

			D:Subscribe(function()
				fn45(true)
			end)

			local v49, v50 = window:CreateTab({Name = "Quick", DisplayName = "Quick & Keys", Side = "Right"}), window:CreateTab({Name = "Settings", Side = "Right"}):CreateSection({Name = "Interface", Expanded = true})

			v18.ApplyUiSize = function(arg3)
				local absoluteSize = v6.AbsoluteSize
				if (absoluteSize.X <= 0) or (absoluteSize.Y <= 0) then
					return
				end
				local n12 = (tonumber(arg3) or 100) / 100
				local base = v18.Base
				v21((base.X.Scale * absoluteSize.X) * n12, (base.Y.Scale * absoluteSize.Y) * n12)
			end

			v18.UiSizeOption = v50:CreateSlider({Name = "UI Size", Note = "Scales the main window; the corner grip does the same by hand", Min = 60, Max = 160, Default = 100, AllowDecimals = false, Increment = 1, Unit = "%", Quick = false, Callback = function(arg3)
				v18.ApplyUiSize(arg3)
			end})

			local keyboardEnabled, v51, v52, tbl7, tbl8, handlers, B, tbl9, fn46, fn47 = UserInputService.KeyboardEnabled, v49:CreateSection({Name = "Pin Pad", DisplayName = "Quick Access", Expanded = true}), v49:CreateSection({Name = "Pin & Key List", DisplayName = "Quick Bar & Keybinds", Expanded = true}), {}, {}, {}, {}, {}

			v52:CreateButton({Name = "Reset Pins", DisplayName = "Reset Quick Access", ButtonText = "Reset", ConfirmText = "Done!", Note = "Restore default items, bars and positions", Quick = false, Callback = function()
				v48:Set(fn20(h))
				d:Set(e(tbl5))
				N:Set({})
			end})

			v52:CreateButton({Name = "Reset Keybinds", ButtonText = "Reset", ConfirmText = "Done!", Note = "Restore the defaults set in code", Quick = false, Callback = function()
				i:Set(e(w))
			end})

			local v53, v54 = v51:CreateToggle({Name = "Enable Keybinds", Note = "Turn off to disable every feature hotkey", Default = true, Quick = false}), v51:CreateToggle({Name = "Show Pin Pads", DisplayName = "Show Quick Bars", Note = "Floating quick bars; drag a header to move one", Default = true, Quick = false, Callback = function(arg3)
				screenGui.Enabled = arg3 == true
			end})

			v51:CreateMultiDropdown({Name = "Visible Quick Bars", DisplayName = "Visible Quick Bars", Options = {"Quick Bar 1", "Quick Bar 2", "Quick Bar 3", "Quick Bar 4", "Quick Bar 5"}, Default = {"Quick Bar 1", "Quick Bar 2", "Quick Bar 3", "Quick Bar 4", "Quick Bar 5"}, Quick = false, SubOf = v54, Callback = function(arg3)
				local tbl10 = {}

				for i2, v55 in ipairs(((type(arg3) == "table") and arg3) or {}) do
					i2 = tonumber(tostring(v55):match("(%d+)$"))

					if (i2 and (i2 >= 1)) and (i2 <= s) then
						tbl10[i2] = true
					end
				end

				t = tbl10
				fn43()
			end})

			local v55 = v51:CreateSlider({Name = "Pad Size", DisplayName = "Quick Bar Size", Min = 60, Max = 200, Default = touchEnabled2, AllowDecimals = false, Increment = 1, Quick = false, Unit = "%", Callback = function(arg3)
				P = (tonumber(arg3) or touchEnabled2) / 100
				fn43()
			end})

			v50:CreateToggle({Name = "Notifications", Note = "Show notification cards; turning this off hides every notify", Quick = false, State = window:CreateState({Name = "Notifications", Default = true, Callback = function(arg3)
				v40.SetNotificationsEnabled(arg3)
			end})})

			v50:CreateToggle({Name = "Open On Launch", Note = "Open the UI automatically when the script starts", Quick = false, State = window:CreateState({Name = "Open On Launch", Default = true})})

			local v56 = v50:CreateButton({Name = "UI Toggle Key", ButtonText = "Rebind", ConfirmText = "", Note = "Current: " .. tostring((V(E:Get()))), Quick = false, Callback = function()
				str3 = "__OPEN__"
				fn47()
			end})

			fn47 = function()
				if not v56._destroyed then
					v56:SetNote(((str3 == "__OPEN__") and "Press any key...") or ("Current: " .. tostring(V(E:Get()))))
				end
			end

			local n12, n13 = 6.2, 0.66

			local function activeDropdownCloser()
			end

			local function fn48(parent, arg3, arg4, arg5)
				local flag4, tween = false
				local barMenuAlpha = Instance.new("NumberValue")
				barMenuAlpha.Name = "BarMenuAlpha"
				barMenuAlpha.Value = 0
				barMenuAlpha.Parent = parent

				local function fn49(arg6)
					local n14 = v31 + ((n12 - v31) * arg6)
					local n15 = v31 / n14
					parent:SetAttribute("ChilliResponsiveAspect", n14)
					arg3.Size = UDim2.fromScale(1, 0.85 / n15)
					arg3.Position = UDim2.fromScale(0.5, 0.5 / n15)
					n14 = 0.925 / n15
					n15 = math.max(0, 1 - n14)
					arg4.Size = UDim2.fromScale(0.4, n15 * n13)
					arg4.Position = UDim2.fromScale(0.985, n14 + (n15 * 0.5))
					arg4.Visible = arg6 > 0.01
					arg5.Rotation = 180 * arg6
					v52._refreshHeight()
				end

				barMenuAlpha.Changed:Connect(fn49)
				fn49(0)

				local function fn50(arg6)
					if flag4 == arg6 then
						return
					end
					flag4 = arg6

					if arg6 then
						v37()
						activeDropdownCloser()

						function activeDropdownCloser()
							fn50(false)
						end

						v2.activeDropdownCloser = activeDropdownCloser
					else
						if v2.activeDropdownCloser == activeDropdownCloser then
							v2.activeDropdownCloser = nil
						end

						function activeDropdownCloser()
						end
					end

					if tween then
						tween:Cancel()
					end

					tween = TweenService:Create(barMenuAlpha, TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Value = (arg6 and 1) or 0})
					tween:Play()

					if v52._stabilizeLayout then
						v52._stabilizeLayout()
					end

					task.defer(v49._updateCanvas)
				end

				return function()
					fn50(not flag4)
				end, function()
					if flag4 then
						fn50(false)
					end
				end
			end

			local function fn49()
				activeDropdownCloser()

				for i2 = #handlers, 1, -1 do
					handlers[i2]()
					handlers[i2] = nil
				end

				for i2 = #tbl7, 1, -1 do
					tbl8[tbl7[i2]] = nil
					tbl9[tbl7[i2]] = nil
					tbl7[i2]:Destroy()
					tbl7[i2] = nil
				end

				for i2 = #B, 1, -1 do
					B[i2] = nil
				end
			end

			local v57 = fn5[3][fn5[5]]

			local function createFrame2(text, layoutOrder)
				local frame = Instance.new("Frame")
				frame.Name = "QuickGroup" .. tostring(layoutOrder)
				frame.Active = false
				frame.AnchorPoint = Vector2.new(0.5, 0.5)
				frame.BackgroundTransparency = 1
				frame.BorderSizePixel = 0
				frame.LayoutOrder = layoutOrder
				frame.Position = UDim2.fromScale(0.5, 0.5)
				frame.Size = UDim2.fromScale(v32, 0.6)
				frame.ZIndex = 3
				layoutOrder = Instance.new("UIAspectRatioConstraint")
				layoutOrder.AspectRatio = 22
				layoutOrder.AspectType = Enum.AspectType.FitWithinMaxSize
				layoutOrder.DominantAxis = Enum.DominantAxis.Width
				layoutOrder.Parent = frame
				layoutOrder = Instance.new("TextLabel")
				layoutOrder.Name = "Label"
				layoutOrder.Active = false
				layoutOrder.AnchorPoint = Vector2.new(0, 0.5)
				layoutOrder.BackgroundTransparency = 1
				layoutOrder.BorderSizePixel = 0
				layoutOrder.Position = UDim2.fromScale(0.025, 0.5)
				layoutOrder.Size = UDim2.fromScale(0.6, 0.8)
				layoutOrder.Text = text
				layoutOrder.TextWrapped = false
				layoutOrder.TextXAlignment = Enum.TextXAlignment.Left
				layoutOrder.ZIndex = 5
				layoutOrder.Parent = frame
				v25(layoutOrder)
				layoutOrder.TextColor3 = color
				layoutOrder = Instance.new("Frame")
				layoutOrder.Name = "Line"
				layoutOrder.Active = false
				layoutOrder.AnchorPoint = Vector2.new(1, 0.5)
				layoutOrder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				layoutOrder.BackgroundTransparency = 0.75
				layoutOrder.BorderSizePixel = 0
				layoutOrder.Position = UDim2.fromScale(0.985, 0.5)
				layoutOrder.Size = UDim2.fromScale(0.34, 0.08)
				layoutOrder.ZIndex = 4
				layoutOrder.Parent = frame
				frame.Parent = v52._content
				table.insert(handlers, fn4[3][fn4[5]](v52, frame))
				table.insert(tbl7, frame)
				table.insert(B, frame)
				return frame
			end

			local function fn50(arg3, layoutOrder, arg4, arg5)
				local v58 = fn19(arg3)
				local keyboardEnabled2 = keyboardEnabled and (fn18(arg3))
				local v59, v60, frame = v36("QuickRow" .. tostring(layoutOrder), arg3:GetQuickName())
				frame.Size = UDim2.fromScale((keyboardEnabled2 and 0.47) or 0.63, 0.64)
				local barPicker = Instance.new("TextButton")
				barPicker.Name = "BarPicker"
				barPicker.Active = true
				barPicker.AutoButtonColor = false
				barPicker.AnchorPoint = Vector2.new(1, 0.5)
				barPicker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
				barPicker.BackgroundTransparency = 0.5
				barPicker.BorderSizePixel = 0
				barPicker.Position = UDim2.fromScale(0.858, 0.5)
				barPicker.Size = UDim2.fromScale(0.062, 0.55)
				barPicker.Text = ""
				barPicker.TextWrapped = false
				barPicker.ZIndex = 6
				barPicker.Parent = v60
				v25(barPicker)
				v28(barPicker, Enum.ApplyStrokeMode.Border, 0.1)
				v35(barPicker, 1.04, 0.96)
				frame = Instance.new("Frame")
				frame.Name = "Caret"
				frame.Active = false
				frame.AnchorPoint = Vector2.new(1, 0)
				frame.BackgroundTransparency = 1
				frame.BorderSizePixel = 0
				frame.Position = UDim2.fromScale(0.99, 0.01)
				frame.Size = UDim2.fromScale(0.44, 0.44)
				frame.ZIndex = 8
				frame.Parent = barPicker
				local uiElement = Instance.new("UIAspectRatioConstraint")
				uiElement.AspectRatio = 1
				uiElement.AspectType = Enum.AspectType.FitWithinMaxSize
				uiElement.DominantAxis = Enum.DominantAxis.Height
				uiElement.Parent = frame
				uiElement = {{0.335355, 45}, {0.664645, -45}}

				for i2, v61 in ipairs(uiElement) do
					i2 = Instance.new("Frame")
					i2.Name = "Arm"
					i2.Active = false
					i2.AnchorPoint = Vector2.new(0.5, 0.5)
					i2.BackgroundColor3 = v33
					i2.BorderSizePixel = 0
					i2.Position = UDim2.fromScale(v61[1], 0.535355)
					i2.Rotation = v61[2]
					i2.Size = UDim2.fromScale(0.6657, 0.22)
					i2.ZIndex = 9
					i2.Parent = frame
				end

				local keyChip

				if keyboardEnabled2 then
					keyChip = Instance.new("TextButton")
					keyChip.Name = "KeyChip"
					keyChip.Active = true
					keyChip.AutoButtonColor = false
					keyChip.AnchorPoint = Vector2.new(1, 0.5)
					keyChip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					keyChip.BackgroundTransparency = 0.35
					keyChip.BorderSizePixel = 0
					keyChip.Position = UDim2.fromScale(0.775, 0.5)
					keyChip.Size = UDim2.fromScale(0.125, 0.5)
					keyChip.Text = ""
					keyChip.TextWrapped = false
					keyChip.ZIndex = 6
					keyChip.Parent = v60
					v25(keyChip)
					v28(keyChip, Enum.ApplyStrokeMode.Border, 0.1)
					v35(keyChip, 1.04, 0.96)
				end

				keyboardEnabled2 = Instance.new("TextButton")
				keyboardEnabled2.Name = "QuickAccessToggle"
				keyboardEnabled2.Active = true
				keyboardEnabled2.AutoButtonColor = false
				keyboardEnabled2.AnchorPoint = Vector2.new(1, 0.5)
				keyboardEnabled2.BackgroundTransparency = 1
				keyboardEnabled2.BorderSizePixel = 0
				keyboardEnabled2.Position = UDim2.fromScale(0.985, 0.5)
				keyboardEnabled2.Size = UDim2.fromScale(0.115, 0.74)
				keyboardEnabled2.Text = ""
				keyboardEnabled2.ZIndex = 6
				keyboardEnabled2.Parent = v60
				local v61, v62 = fn26(keyboardEnabled2, 0.5, 0.5, 0.95, 0.78)
				uiElement = Instance.new("Frame")
				uiElement.Name = "BarMenu"
				uiElement.Active = false
				uiElement.AnchorPoint = Vector2.new(1, 0.5)
				uiElement.BackgroundTransparency = 1
				uiElement.BorderSizePixel = 0
				uiElement.Position = UDim2.fromScale(0.985, 0.755)
				uiElement.Size = UDim2.fromScale(0.4, 0)
				uiElement.Visible = false
				uiElement.ZIndex = 5
				uiElement.Parent = v59
				local uiElement2 = Instance.new("UIListLayout")
				uiElement2.Name = "MenuLayout"
				uiElement2.FillDirection = Enum.FillDirection.Horizontal
				uiElement2.HorizontalAlignment = Enum.HorizontalAlignment.Right
				uiElement2.VerticalAlignment = Enum.VerticalAlignment.Center
				uiElement2.SortOrder = Enum.SortOrder.LayoutOrder
				uiElement2.Padding = UDim.new(0.024, 0)
				uiElement2.Parent = uiElement
				local tbl10, v63, v64 = {}

				for i2 = 1, s, 1 do
					uiElement2 = Instance.new("TextButton")
					uiElement2.Name = "Bar" .. tostring(i2)
					uiElement2.Active = true
					uiElement2.AutoButtonColor = false
					uiElement2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
					uiElement2.BackgroundTransparency = 0.4
					uiElement2.BorderSizePixel = 0
					uiElement2.LayoutOrder = i2
					uiElement2.Size = UDim2.fromScale(0.176, 1)
					uiElement2.Text = tostring(i2)
					uiElement2.TextWrapped = false
					uiElement2.ZIndex = 6
					uiElement2.Parent = uiElement
					v25(uiElement2)
					v28(uiElement2, Enum.ApplyStrokeMode.Border, 0.09)
					v35(uiElement2, 1.06, 0.94)
					tbl10[i2] = uiElement2
				end

				local function fn51()
					local v65 = fn21(v58)
					v62(v65, false)
					barPicker.Text = tostring(R(v58))
					barPicker.TextTransparency = (v65 and 0) or 0.5
					v65 = R(v58)

					for i2, v66 in ipairs(tbl10) do
						v66.BackgroundTransparency = ((i2 == v65) and 0.15) or 0.4
						v66.TextTransparency = ((i2 == v65) and 0) or 0.2
					end

					if keyChip then
						if str3 == v58 then
							keyChip.Text = "?"
						else
							keyChip.Text = V(T()[v58]) or "-"
						end
					end
				end

				if keyChip then
					v15(keyChip, function()
						str3 = v58

						for i2, v65 in ipairs(tbl7) do
							i2 = tbl8[v65]

							if i2 then
								i2()
							end
						end
					end)
				end

				v63, v64 = fn48(v59, v60, uiElement, frame)

				for i2, v65 in ipairs(tbl10) do
					v15(v65, function()
						Z(v58, i2)
						v64()
						fn51()
					end)
				end

				v15(barPicker, function()
					v63()
				end)

				v15(keyboardEnabled2, function()
					fn22(v58, not fn21(v58))
					fn51()
				end)

				tbl8[v59] = fn51
				tbl9[v59] = {Header = arg4, Search = (arg3:GetQuickName() .. (" " .. arg5)):lower()}
				v59.LayoutOrder = layoutOrder
				v59.Parent = v52._content
				table.insert(handlers, fn4[3][fn4[5]](v52, v59))
				table.insert(tbl7, v59)
				fn51()
			end

			fn46 = function()
				fn49()
				local nextOptionOrder, v58, v59 = v52._nextOptionOrder

				fn17(function(arg3, arg4, arg5)
					if not W(arg3) then
						return
					end
					local str4 = v57(arg5) .. ("  >  " .. arg4.Name)

					if str4 ~= v58 then
						v58 = str4
						nextOptionOrder += 1
						v59 = createFrame2(str4, nextOptionOrder)
					end

					nextOptionOrder += 1
					fn50(arg3, nextOptionOrder, v59, str4)
				end)

				v52._container.Visible = true
				v52._refreshHeight()
				task.defer(v49._updateCanvas)
			end

			v52._searchExtra = function(arg3)
				local tbl10, searchPaint = {}, v49._searchPaint

				local function fn51(arg4)
					if not searchPaint then
						return
					end
					local main = arg4:FindFirstChild("Main")
					searchPaint((main and (main:FindFirstChild("Label"))) or (arg4:FindFirstChild("Label")), arg3)
				end

				local flag4 = false

				for i2, v58 in ipairs(tbl7) do
					i2 = tbl9[v58]

					if i2 then
						local visible = (arg3 == "") or (i2.Search:find(arg3, 1, true) ~= nil)
						v58.Visible = visible
						fn51(v58)

						if visible then
							if i2.Header then
								tbl10[i2.Header] = true
							end

							flag4 = true
						end
					end
				end

				for _, v58 in ipairs(B) do
					v58.Visible = (arg3 == "") or (tbl10[v58] == true)
					fn51(v58)
				end

				return flag4
			end

			local function fn51()
				for i2, v58 in ipairs(tbl7) do
					i2 = tbl8[v58]

					if i2 then
						i2()
					end
				end
			end

			v10(UserInputService.InputBegan:Connect(function(input, gameProcessed)
				if input.UserInputType ~= Enum.UserInputType.Keyboard then
					return
				end

				if UserInputService:GetFocusedTextBox() then
					return
				end

				if str3 then
					local v58 = str3
					str3 = nil

					if v58 == "__OPEN__" then
						if input.KeyCode ~= Enum.KeyCode.Escape then
							E:Set(input.KeyCode.Name)
						end

						fn47()
					else
						if input.KeyCode == Enum.KeyCode.Escape then
							fn25(v58, nil)
						else
							fn25(v58, input.KeyCode)
						end

						fn51()
					end

					return
				end

				if gameProcessed then
					return
				end

				if input.KeyCode.Name == tostring(E:Get()) then
					window:Toggle()
					return
				end

				if v53._destroyed or (v53:Get() ~= true) then
					return
				end

				for k2, v58 in pairs(T()) do
					if v58 == input.KeyCode.Name then
						gameProcessed = C(k2)

						if gameProcessed and (fn18(gameProcessed)) then
							I(gameProcessed)
							G(k2)
						end
					end
				end
			end))

			v48:Subscribe(function()
				fn43()
				fn51()
			end)

			d:Subscribe(function()
				fn43()
				fn51()
			end)

			i:Subscribe(function()
				fn43()
				fn27()
				fn51()
			end)

			N:Subscribe(fn44)
			E:Subscribe(fn47)

			v2.quickRefreshHook = function()
				fn43()
				fn46()
			end

			v6.Destroying:Connect(function()
				if screenGui.Parent then
					screenGui:Destroy()
				end
			end)

			if not keyboardEnabled then
				v53:SetVisible(false)
				v56:SetVisible(false)
			end

			local function configLoadedHook()
				if not v54._destroyed then
					screenGui.Enabled = v54:Get() == true
				end

				local destroyed = v55._destroyed

				if not destroyed then
					P = (tonumber(v55:Get()) or touchEnabled2) / 100
				end

				if v18.UiSizeOption and not v18.UiSizeOption._destroyed then
					v18.ApplyUiSize(v18.UiSizeOption:Get())
				end

				fn47()
				fn27()

				for i2, v58 in ipairs(tbl6) do
					v58.Collapsed = S(i2)
				end

				fn45(false)
				fn43()
				fn44(false)
				fn51()
			end

			v2.configLoadedHook = configLoadedHook
			v52:SetExpanded(true, false)
			fn46()
			configLoadedHook()

			task.defer(function()
				for i2 = 1, 5, 1 do
					RunService.Heartbeat:Wait()
				end

				configLoadedHook()
			end)
		end)()

		fn16()

		if v2.quickRefreshHook then
			v2.quickRefreshHook()
		end

		if not g then
			mainTab.Button.Visible = false
		end

		for _, tab in ipairs(window.Tabs) do
			if tab.Button.Visible then
				window:SelectTab(tab)
				break
			end
		end

		v13()
		v24(v5.obj9, v23)
		v24(v5.obj20, nil)
		v5.obj20.Size = UDim2.new(1.14, 0, 0.98, 0)
		v7.Position = v17()
		v7.Size = v2.menuSize
		v6.Enabled = true

		task.spawn(function()
			for i = 1, 4, 1 do
				RunService.Heartbeat:Wait()
			end

			local selectedTab = window.SelectedTab

			if selectedTab and not selectedTab._destroyed then
				for _, section in ipairs(selectedTab.Sections) do
					if section._refreshLayout then
						section._refreshLayout()
					end
				end

				selectedTab._updateCanvas()
			end

			RunService.Heartbeat:Wait()
			selectedTab = window:GetState("Open On Launch")

			if not selectedTab or (selectedTab:Get() ~= false) then
				window:Open()
			end
		end)

		v2.windowDragController = v14(v8, v7, function()
			return v2.chilliIsOpen and not v2.windowAnimating
		end, function(windowRestPosition)
			v2.windowRestPosition = windowRestPosition
		end)

		v16(v9)

		v15(v9, function()
			window:Close()
		end)

		v15(v12, function()
			window:Toggle()
		end)

		local interactionScale = Instance.new("UIScale")
		interactionScale.Name = "InteractionScale"
		interactionScale.Scale = 1
		interactionScale.Parent = v12
		local tween
		local f = false

		local function fn17(l, u)
			if tween then
				tween:Cancel()
			end

			tween = TweenService:Create(interactionScale, TweenInfo.new(u, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Scale = l})
			tween:Play()
		end

		v12.MouseEnter:Connect(function()
			f = true
			fn17(1.04, 0.1)
		end)

		v12.MouseLeave:Connect(function()
			f = false
			fn17(1, 0.1)
		end)

		v12.MouseButton1Down:Connect(function()
			fn17(0.94, 0.055)
		end)

		v12.MouseButton1Up:Connect(function()
			fn17((f and 1.04) or 1, 0.085)
		end)

		return m
	end

	v[1] = fn4

	v[2] = function(m)
		tbl3.SetTab(m)
	end

	v[3] = fn2
	v[4] = fn3
	return 85750186
end
