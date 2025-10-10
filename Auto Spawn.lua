--// Avery's Fancy Auto Spawn GUI (Final Version, Clean + Safe)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Variables
local spawn1, spawn2 = nil, nil
local activeSpawn = nil

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AveryAutoSpawnGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

--// Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 320)
frame.Position = UDim2.new(0.5, -130, 0.5, -160)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Visible = true

-- Rounded corners
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Drop shadow
local shadow = Instance.new("ImageLabel")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.new(0.5, 4, 0.5, 4)
shadow.Size = UDim2.new(1, 20, 1, 20)
shadow.ZIndex = -1
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.4
shadow.Parent = frame

--// Title bar (Draggable)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Avery's Auto Spawn"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

--// Make toolbar draggable
local dragging, dragInput, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)
titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

--// Active indicator
local indicator = Instance.new("TextLabel")
indicator.Size = UDim2.new(1, 0, 0, 25)
indicator.Position = UDim2.new(0, 0, 0, 40)
indicator.BackgroundTransparency = 1
indicator.Text = "Active: None"
indicator.TextColor3 = Color3.fromRGB(0, 255, 255)
indicator.Font = Enum.Font.Gotham
indicator.TextSize = 16
indicator.Parent = frame

-- Flash effect
local function flash(color)
	local flashFrame = Instance.new("Frame")
	flashFrame.Size = UDim2.new(1, 0, 1, 0)
	flashFrame.BackgroundColor3 = color
	flashFrame.BackgroundTransparency = 0.6
	flashFrame.ZIndex = 10
	flashFrame.Parent = frame
	game:GetService("Debris"):AddItem(flashFrame, 0.25)
end

-- Update indicator
local function updateIndicator()
	if activeSpawn == spawn1 then
		indicator.Text = "Active: Spawn 1"
	elseif activeSpawn == spawn2 then
		indicator.Text = "Active: Spawn 2"
	else
		indicator.Text = "Active: None"
	end
end

--// ScrollingFrame for buttons
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, -10, 0, 210)
buttonContainer.Position = UDim2.new(0, 5, 0, 70)
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 280)
buttonContainer.ScrollBarThickness = 5
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

-- Button creator
local function createButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 32)
	btn.Position = UDim2.new(0, 5, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 15
	btn.AutoButtonColor = true
	btn.Parent = buttonContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	return btn
end

-- Buttons
local set1 = createButton("Set Spawn 1", 0)
local set2 = createButton("Set Spawn 2", 38)
local use1 = createButton("Use Spawn 1", 76)
local use2 = createButton("Use Spawn 2", 114)
local tp1 = createButton("Teleport to Spawn 1", 152)
local tp2 = createButton("Teleport to Spawn 2", 190)
local clearBtn = createButton("Clear Active Spawn", 228)

--// Buttons functionality
set1.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		spawn1 = char.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0, 255, 0))
	end
end)

set2.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		spawn2 = char.HumanoidRootPart.CFrame
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
	local char = player.Character
	if spawn1 and char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = spawn1
	end
end)

tp2.MouseButton1Click:Connect(function()
	local char = player.Character
	if spawn2 and char and char:FindFirstChild("HumanoidRootPart") then
		char.HumanoidRootPart.CFrame = spawn2
	end
end)

clearBtn.MouseButton1Click:Connect(function()
	activeSpawn = nil
	updateIndicator()
	flash(Color3.fromRGB(255, 0, 0))
	print("✅ Active spawn cleared.")
end)

--// Minimize + Close
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -55, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = minimizeBtn:Clone()
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Parent = titleBar

--// Toggle button
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 160, 0, 40)
openBtn.Position = UDim2.new(0.5, -80, 0.85, 0)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
openBtn.Text = "🪄 Open Spawn Menu"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.Visible = false
openBtn.Parent = screenGui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 10)

-- Minimize / Maximize logic
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	local targetTransparency = minimized and 1 or 0
	for _, v in pairs({buttonContainer, indicator}) do
		v.Visible = not minimized
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

--// CharacterAdded auto teleport
player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	if hrp and activeSpawn then
		pcall(function()
			task.wait(0.5)
			if (hrp.Position - activeSpawn.Position).Magnitude > 10 then
				hrp.CFrame = activeSpawn
				print("✅ Auto-teleported to active spawn.")
			end
		end)
	end
end)
