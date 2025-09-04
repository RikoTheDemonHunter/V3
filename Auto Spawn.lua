-- Auto Spawn GUI with Dual Save, Indicator, Clear Button, and Toggleable Menu
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Variables for spawn points
local spawn1, spawn2 = nil, nil
local activeSpawn = nil

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpawnPointGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12) -- roundness size
corner.Parent = frame


-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Avery's Auto Spawn"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18
title.Parent = frame

-- Active Spawn Indicator
local indicator = Instance.new("TextLabel")
indicator.Size = UDim2.new(1, 0, 0, 20)
indicator.Position = UDim2.new(0, 0, 0, 30)
indicator.BackgroundTransparency = 1
indicator.Text = "Active: None"
indicator.TextColor3 = Color3.fromRGB(0, 255, 255)
indicator.Font = Enum.Font.SourceSans
indicator.TextSize = 16
indicator.Parent = frame

-- Flash effect
local function flash(color)
	local flashFrame = Instance.new("Frame")
	flashFrame.Size = UDim2.new(1, 0, 1, 0)
	flashFrame.BackgroundColor3 = color
	flashFrame.BackgroundTransparency = 0.5
	flashFrame.Parent = frame
	game:GetService("Debris"):AddItem(flashFrame, 0.3)
end

-- Function to update indicator
local function updateIndicator()
	if activeSpawn == spawn1 then
		indicator.Text = "Active: Spawn 1"
	elseif activeSpawn == spawn2 then
		indicator.Text = "Active: Spawn 2"
	else
		indicator.Text = "Active: None"
	end
end

-- Scrolling container for buttons
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, -10, 0, 210)
buttonContainer.Position = UDim2.new(0, 5, 0, 55)
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 280) -- extra space for buttons
buttonContainer.ScrollBarThickness = 6
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

-- Create Buttons
local function createButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 16
	btn.Parent = buttonContainer
	return btn
end

local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8) -- roundness for buttons
	btnCorner.Parent = btn

	return btn
end

-- Buttons
local set1 = createButton("Set Spawn 1", 0)
local set2 = createButton("Set Spawn 2", 35)
local use1 = createButton("Use Spawn 1", 70)
local use2 = createButton("Use Spawn 2", 105)
local tp1 = createButton("Teleport to Spawn 1", 140)
local tp2 = createButton("Teleport to Spawn 2", 175)
local clearBtn = createButton("Clear Active Spawn", 210)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -55, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
closeBtn.Parent = frame

-- Open Menu Button
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 140, 0, 40)
openBtn.Position = UDim2.new(0, 10, 0.8, 0)
openBtn.Text = "Open Spawn Menu"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
openBtn.Visible = false
openBtn.Parent = screenGui

-- Button Functions
set1.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn1 = player.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0, 255, 0))
	end
end)

set2.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn2 = player.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0, 255, 0))
	end
end)

use1.MouseButton1Click:Connect(function()
	if spawn1 then
		activeSpawn = spawn1
		updateIndicator()
		flash(Color3.fromRGB(0, 255, 255))
	end
end)

use2.MouseButton1Click:Connect(function()
	if spawn2 then
		activeSpawn = spawn2
		updateIndicator()
		flash(Color3.fromRGB(0, 255, 255))
	end
end)

tp1.MouseButton1Click:Connect(function()
	if spawn1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = spawn1
	end
end)

tp2.MouseButton1Click:Connect(function()
	if spawn2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = spawn2
	end
end)

clearBtn.MouseButton1Click:Connect(function()
	activeSpawn = nil
	updateIndicator()
	flash(Color3.fromRGB(255, 0, 0))
end)

-- Minimize
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	buttonContainer.Visible = not minimized
	indicator.Visible = not minimized
end)

-- Close (Hide)
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

-- Reopen
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

-- CharacterAdded teleport
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	task.wait(0.2)
	if activeSpawn then
		char:WaitForChild("HumanoidRootPart").CFrame = activeSpawn
	end
end)
