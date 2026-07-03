local function loadTool(name,url) local ok,err=pcall(function() loadstring(game:HttpGet(url))() end) if ok then print("[Olemad] Loaded "..name) else warn("[Olemad] Failed "..name..": "..tostring(err)) end end

if game:GetService("CoreGui"):FindFirstChild("SettingsPanel") then
	game:GetService("CoreGui").SettingsPanel:Destroy()
end
if _G.SettingsPanelConns then
	for _, c in pairs(_G.SettingsPanelConns) do pcall(function() c:Disconnect() end) end
end
_G.SettingsPanelConns = {}

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local function conn(sig, fn)
	local c = sig:Connect(fn)
	table.insert(_G.SettingsPanelConns, c)
	return c
end

local LUCIDE
pcall(function()
	LUCIDE = loadstring(game:HttpGet("https://raw.githubusercontent.com/latte-soft/lucide-roblox/master/lib/Icons.luau"))()
end)

local function lucide(parent, name, size, color)
	local img = Instance.new("ImageLabel")
	img.BackgroundTransparency = 1
	img.Size = UDim2.fromOffset(size, size)
	img.ImageColor3 = color
	local set = LUCIDE and LUCIDE["48px"] and LUCIDE["48px"][name]
	if set then
		img.Image = "rbxassetid://" .. set[1]
		img.ImageRectSize = Vector2.new(set[2][1], set[2][2])
		img.ImageRectOffset = Vector2.new(set[3][1], set[3][2])
	end
	img.Parent = parent
	return img
end

local C = {
	bg = Color3.fromRGB(17,17,20), header = Color3.fromRGB(23,23,27),
	border = Color3.fromRGB(44,44,51), hover = Color3.fromRGB(34,34,40),
	text = Color3.fromRGB(233,233,238), dim = Color3.fromRGB(150,150,160),
	blue = Color3.fromRGB(72,130,248),
}
local FONTM = Enum.Font.GothamMedium
local FONTB = Enum.Font.GothamBold
local PANEL_W, PANEL_H = 220, 210

local gui = Instance.new("ScreenGui")
gui.Name = "SettingsPanel"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.Parent = game:GetService("CoreGui")

local function corner(p, r) local u = Instance.new("UICorner") u.CornerRadius = UDim.new(0, r or 6) u.Parent = p end
local function stroke(p, col, t) local s = Instance.new("UIStroke") s.Color = col or C.border s.Thickness = 1 s.Transparency = t or 0 s.Parent = p end

-- Panel principal
local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.Parent = gui
corner(main, 12)
stroke(main, C.border, 0)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1,0,0,44)
header.BackgroundColor3 = C.header
header.BorderSizePixel = 0
header.Parent = main
corner(header, 12)

local hfix = Instance.new("Frame")
hfix.Size = UDim2.new(1,0,0,14)
hfix.Position = UDim2.new(0,0,1,-14)
hfix.BackgroundColor3 = C.header
hfix.BorderSizePixel = 0
hfix.Parent = header

local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1,0,0,1)
hLine.Position = UDim2.new(0,0,1,0)
hLine.BackgroundColor3 = C.border
hLine.BorderSizePixel = 0
hLine.Parent = header

lucide(header, "settings", 16, C.blue).Position = UDim2.fromOffset(16,14)

local tlabel = Instance.new("TextLabel")
tlabel.Size = UDim2.new(0.6,0,1,0)
tlabel.Position = UDim2.fromOffset(40,0)
tlabel.BackgroundTransparency = 1
tlabel.Font = FONTB
tlabel.Text = "DatesArabes Gui"
tlabel.TextColor3 = C.text
tlabel.TextSize = 14
tlabel.TextXAlignment = Enum.TextXAlignment.Left
tlabel.Parent = header

local function hdrBtn(txt, xoff)
	local b = Instance.new("TextButton")
	b.Size = UDim2.fromOffset(26,26)
	b.Position = UDim2.new(1, xoff, 0.5, -13)
	b.BackgroundColor3 = C.hover
	b.BackgroundTransparency = 1
	b.Text = txt
	b.Font = FONTB
	b.TextSize = 15
	b.TextColor3 = C.dim
	b.AutoButtonColor = false
	b.Parent = header
	corner(b, 6)
	b.MouseEnter:Connect(function() b.BackgroundTransparency = 0 b.TextColor3 = C.text end)
	b.MouseLeave:Connect(function() b.BackgroundTransparency = 1 b.TextColor3 = C.dim end)
	return b
end
local closeBtn = hdrBtn("✕", -36)
local minBtn   = hdrBtn("—", -66)

-- Corps
local body = Instance.new("Frame")
body.Size = UDim2.new(1,-24,1,-56)
body.Position = UDim2.fromOffset(12, 52)
body.BackgroundTransparency = 1
body.Parent = main

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0,6)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = body

local function pill(name, iconName, cb)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(1,0,0,32)
	b.BackgroundColor3 = C.hover
	b.BackgroundTransparency = 0.4
	b.Text = ""
	b.AutoButtonColor = false
	b.Parent = body
	corner(b, 6)
	stroke(b, C.border, 0.4)
	if iconName then
		local ic = lucide(b, iconName, 14, C.dim)
		ic.Position = UDim2.new(0,12,0.5,-7)
	end
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1,-40,1,0)
	l.Position = UDim2.fromOffset(iconName and 34 or 14, 0)
	l.BackgroundTransparency = 1
	l.Font = FONTM
	l.Text = name
	l.TextColor3 = C.text
	l.TextSize = 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Parent = b
	b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundTransparency=0}):Play() end)
	b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.12), {BackgroundTransparency=0.4}):Play() end)
	b.MouseButton1Click:Connect(cb)
end

pill("Solix",         "terminal",    function() loadTool("Solix",          "https://raw.githubusercontent.com/bao8jl/solixhub/main/loader") end)
pill("Dex Explorer",  "folder-tree", function() loadTool("Dex",            "https://raw.githubusercontent.com/ltseverydayyou/uuuuuuu/refs/heads/main/DexPlusBackup.luau") end)
pill("Cobalt",        "radar",       function() loadTool("Cobalt",         "https://github.com/notpoiu/cobalt/releases/latest/download/Cobalt.luau") end)
pill("Nameless Admin","bug",         function() loadTool("Nameless Admin", "https://raw.githubusercontent.com/ltseverydayyou/Nameless-Admin/main/Source.lua") end)

-- Bubble (panel minimisé)
local bubble = Instance.new("TextButton")
bubble.Size = UDim2.fromOffset(44,44)
bubble.AnchorPoint = Vector2.new(0.5, 0.5)
bubble.Position = UDim2.new(0.5, 4, 1, -546)
bubble.BackgroundColor3 = C.header
bubble.Text = ""
bubble.AutoButtonColor = false
bubble.Active = true
bubble.Draggable = true
bubble.Visible = false
bubble.ZIndex = 10
bubble.Parent = gui
corner(bubble, 22)
stroke(bubble, C.border, 0)
lucide(bubble, "settings", 20, C.blue).Position = UDim2.fromOffset(12,12)

bubble.MouseEnter:Connect(function() TweenService:Create(bubble, TweenInfo.new(0.12), {BackgroundColor3=C.hover}):Play() end)
bubble.MouseLeave:Connect(function() TweenService:Create(bubble, TweenInfo.new(0.12), {BackgroundColor3=C.header}):Play() end)

local function showPanel()
	main.Visible = true
	bubble.Visible = false
end
local function hidePanel()
	main.Visible = false
	bubble.Visible = true
end

bubble.MouseButton1Click:Connect(showPanel)
minBtn.MouseButton1Click:Connect(hidePanel)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

conn(UIS.InputBegan, function(i, gp)
	if gp then return end
	if i.KeyCode == Enum.KeyCode.RightShift then
		if main.Visible then hidePanel() else showPanel() end
	end
end)

print("[SettingsPanel] chargé | Lucide:" .. tostring(LUCIDE ~= nil))