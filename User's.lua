-- Roblox Lua GUI with whitelist display, draggable frame, minimize/close buttons, and animations

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local whitelist = {
    1497286101-Riko,
}

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WhitelistGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 0) -- Start collapsed
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Animate open
TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 300, 0, 200)
}):Play()

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Whitelisted UserIds"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Minimize button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Parent = frame

-- Close button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = frame

-- Scrollable whitelist
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, 0, 1, -30)
scroll.Position = UDim2.new(0, 0, 0, 30)
scroll.CanvasSize = UDim2.new(0, 0, 0, #whitelist * 30)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.Parent = frame

for i, userId in ipairs(whitelist) do
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 25)
    label.Position = UDim2.new(0, 5, 0, (i - 1) * 30)
    label.BackgroundTransparency = 1
    label.Text = tostring(userId)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = scroll
end

-- Minimize/Expand animation
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    scroll.Visible = not minimized
    local goalSize = minimized and UDim2.new(0, 300, 0, 30) or UDim2.new(0, 300, 0, 200)
    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = goalSize}):Play()
end)

-- Close animation
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(frame, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 300, 0, 0)
    }):Play()
    task.wait(0.35)
    screenGui:Destroy()
end)
