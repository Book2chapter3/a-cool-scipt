-- LocalScript (exécuté via executor)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Supprime l'ancien
local existing = CoreGui:FindFirstChild("RebirthGui")
if existing then existing:Destroy() end

-- ScreenGui dans CoreGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RebirthGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = CoreGui

-- Fenêtre
local frame = Instance.new("Frame")
frame.Name = "Window"
frame.Size = UDim2.new(0, 220, 0, 100)
frame.Position = UDim2.new(0.5, -110, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0
frame.Parent = screenGui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

local windowStroke = Instance.new("UIStroke")
windowStroke.Color = Color3.fromRGB(255, 255, 255)
windowStroke.Transparency = 0.85
windowStroke.Thickness = 1.5
windowStroke.Parent = frame

-- Titre
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 32)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
titleBar.BackgroundTransparency = 0.95
titleBar.BorderSizePixel = 0
titleBar.Parent = frame

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "Rebirth"
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Bouton Réduire
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "-"
minimizeBtn.Size = UDim2.new(0, 22, 0, 22)
minimizeBtn.Position = UDim2.new(1, -52, 0.5, -11)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 189, 46)
minimizeBtn.TextColor3 = Color3.fromRGB(100, 70, 0)
minimizeBtn.TextSize = 16
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.AutoButtonColor = false
minimizeBtn.Parent = titleBar

Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(1, 0)

-- Bouton Fermer
local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -26, 0.5, -11)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 95, 87)
closeBtn.TextColor3 = Color3.fromRGB(120, 20, 20)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.AutoButtonColor = false
closeBtn.Parent = titleBar

Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- Pill Rebirth
local pill = Instance.new("TextButton")
pill.Name = "RebirthButton"
pill.Text = "Rebirth"
pill.Size = UDim2.new(0, 160, 0, 36)
pill.Position = UDim2.new(0.5, -80, 0, 44)
pill.BackgroundColor3 = Color3.fromRGB(94, 96, 206)
pill.TextColor3 = Color3.fromRGB(255, 255, 255)
pill.TextSize = 13
pill.Font = Enum.Font.GothamBold
pill.BorderSizePixel = 0
pill.AutoButtonColor = false
pill.Parent = frame

Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

local pillStroke = Instance.new("UIStroke")
pillStroke.Color = Color3.fromRGB(155, 95, 255)
pillStroke.Transparency = 0.3
pillStroke.Thickness = 1.5
pillStroke.Parent = pill

-- Drag
local dragging = false
local dragOffsetX = 0
local dragOffsetY = 0

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        local absPos = frame.AbsolutePosition
        dragOffsetX = input.Position.X - absPos.X
        dragOffsetY = input.Position.Y - absPos.Y
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        local vp = screenGui.AbsoluteSize
        local fs = frame.AbsoluteSize
        local newX = math.clamp(input.Position.X - dragOffsetX, 0, vp.X - fs.X)
        local newY = math.clamp(input.Position.Y - dragOffsetY, 0, vp.Y - fs.Y)
        frame.Position = UDim2.new(0, newX, 0, newY)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Minimize / Close
local minimized = false
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)

closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(frame, tweenInfo, {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.2)
    screenGui:Destroy()
end)

minimizeBtn.MouseButton1Click:Connect(function()
    if not minimized then
        minimized = true
        pill.Visible = false
        TweenService:Create(frame, tweenInfo, {
            Size = UDim2.new(0, 220, 0, 32)
        }):Play()
        minimizeBtn.Text = "+"
    else
        minimized = false
        TweenService:Create(frame, tweenInfo, {
            Size = UDim2.new(0, 220, 0, 100)
        }):Play()
        task.wait(0.2)
        pill.Visible = true
        minimizeBtn.Text = "-"
    end
end)

-- Hover pill
pill.MouseEnter:Connect(function()
    TweenService:Create(pill, tweenInfo, {BackgroundColor3 = Color3.fromRGB(120, 100, 240)}):Play()
end)

pill.MouseLeave:Connect(function()
    TweenService:Create(pill, tweenInfo, {BackgroundColor3 = Color3.fromRGB(94, 96, 206)}):Play()
end)

-- Clic Rebirth
pill.MouseButton1Click:Connect(function()
    ReplicatedStorage.Remotes.TryRebirth:FireServer()
    TweenService:Create(pill, tweenInfo, {Size = UDim2.new(0, 150, 0, 36)}):Play()
    task.wait(0.1)
    TweenService:Create(pill, tweenInfo, {Size = UDim2.new(0, 160, 0, 36)}):Play()
end)