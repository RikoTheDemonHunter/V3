-- Permanent Spawn Point GUI (Draggable, Minimize, Close, Clear)
-- Saves across sessions (permanent until cleared)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpawnPointGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 140)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Spawn Point"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 1, 0)
minimizeBtn.Position = UDim2.new(1, -55, 0, 0)
minimizeBtn.Text = "–"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 1, 0)
closeBtn.Position = UDim2.new(1, -28, 0, 0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -28)
container.Position = UDim2.new(0, 0, 0, 28)
container.BackgroundTransparency = 1
container.Parent = frame

local setSpawnBtn = Instance.new("TextButton")
setSpawnBtn.Size = UDim2.new(1, -20, 0, 35)
setSpawnBtn.Position = UDim2.new(0, 10, 0, 8)
setSpawnBtn.Text = "Set Spawn Point"
setSpawnBtn.Font = Enum.Font.GothamBold
setSpawnBtn.TextSize = 14
setSpawnBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
setSpawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setSpawnBtn.BorderSizePixel = 0
setSpawnBtn.Parent = container
Instance.new("UICorner", setSpawnBtn).CornerRadius = UDim.new(0, 8)

local clearSpawnBtn = Instance.new("TextButton")
clearSpawnBtn.Size = UDim2.new(1, -20, 0, 35)
clearSpawnBtn.Position = UDim2.new(0, 10, 0, 48)
clearSpawnBtn.Text = "Clear Spawn Point"
clearSpawnBtn.Font = Enum.Font.GothamBold
clearSpawnBtn.TextSize = 14
clearSpawnBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
clearSpawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearSpawnBtn.BorderSizePixel = 0
clearSpawnBtn.Parent = container
Instance.new("UICorner", clearSpawnBtn).CornerRadius = UDim.new(0, 8)

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 30)
infoLabel.Position = UDim2.new(0, 10, 0, 88)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 13
infoLabel.Text = "No spawn point set"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextWrapped = true
infoLabel.Parent = container

-- Spawn logic
local spawnPointCFrame = nil

-- Load saved spawn from Attributes
if LocalPlayer:GetAttribute("SavedSpawnX") then
    local x, y, z, rx, ry, rz = 
        LocalPlayer:GetAttribute("SavedSpawnX"),
        LocalPlayer:GetAttribute("SavedSpawnY"),
        LocalPlayer:GetAttribute("SavedSpawnZ"),
        Loc
