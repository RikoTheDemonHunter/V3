-- GUI for Burp Points Counter in Burping Simulator
-- Features: Draggable, Minimize/Expand, Animated updates

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Replace with your actual event and stat access
local burpStatName = "BurpPoints" -- The stat name in leaderstats

-- GUI setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BurpPointsGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0, 10, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.Text = "Burp Points"
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

-- Burp counter label
local burpLabel = Instance.new("TextLabel")
burpLabel.Size = UDim2.new(1, 0, 0, 70)
burpLabel.Position = UDim2.new(0, 0, 0, 30)
burpLabel.BackgroundTransparency = 1
burpLabel.Text = "0"
burpLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
burpLabel.Font = Enum.Font.FredokaOne
burpLabel.TextScaled = true
burpLabel.Parent = frame

-- Animation scale tween
local function animateLabel()
    local grow = TweenService:Create(burpLabel, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
        TextSize = 50
    })
    local shrink = TweenService:Create(burpLabel, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {
        TextSize = 40
    })
    grow:Play()
    grow.Completed:Connect(function()
        shrink:Play()
    end)
end

-- Update loop
local function updateBurpPoints()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats and leaderstats:FindFirstChild(burpStatName) then
        local value = leaderstats[burpStatName].Value
        burpLabel.Text = tostring(value)
        animateLabel()
    end
end

-- Listen for changes
LocalPlayer:WaitForChild("leaderstats"):WaitForChild(burpStatName).Changed:Connect(updateBurpPoints)

-- Initial update
updateBurpPoints()

-- Minimize toggle
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local goalSize = minimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 100)
    TweenService:Create(frame, TweenInfo.new(0.3), {Size = goalSize}):Play()
    burpLabel.Visible = not minimized
end)

-- Close GUI
closeButton.MouseButton1Click:Connect(function()
    TweenService:Create(frame, TweenInfo.new(0.3), {Size = UDim2.new(0, 200, 0, 0)}):Play()
    task.wait(0.35)
    screenGui:Destroy()
end)
