--// Avery GUI with Spawn System //--

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local spawn1, spawn2
local activeSpawn = nil

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AveryGUI"
screenGui.Parent = game.CoreGui

-- Reopen Button
local reopenButton = Instance.new("TextButton")
reopenButton.Size = UDim2.new(0, 120, 0, 40)
reopenButton.Position = UDim2.new(0, 10, 0, 200)
reopenButton.Text = "Open Avery GUI"
reopenButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenButton.Visible = false
reopenButton.Parent = screenGui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Avery Spawn GUI"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = frame

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Parent = frame

-- Active Spawn Indicator
local spawnIndicator = Instance.new("TextLabel")
spawnIndicator.Size = UDim2.new(1, 0, 0, 25)
spawnIndicator.Position = UDim2.new(0, 0, 0, 30)
spawnIndicator.BackgroundTransparency = 1
spawnIndicator.Text = "Active: None"
spawnIndicator.TextColor3 = Color3.fromRGB(255, 255, 0)
spawnIndicator.Font = Enum.Font.SourceSansBold
spawnIndicator.TextScaled = true
spawnIndicator.Parent = frame

-- Buttons
local function createButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = text
	btn.Font = Enum.Font.SourceSans
	btn.TextScaled = true
	btn.Parent = frame
	return btn
end

local setSpawn1Btn = createButton("Set Spawn 1", 70)
local useSpawn1Btn = createButton("Use Spawn 1", 120)
local setSpawn2Btn = createButton("Set Spawn 2", 170)
local useSpawn2Btn = createButton("Use Spawn 2", 220)

-- Watermark
local watermark = Instance.new("TextLabel")
watermark.Size = UDim2.new(1, 0, 0, 20)
watermark.Position = UDim2.new(0, 0, 1, -20)
watermark.BackgroundTransparency = 1
watermark.Text = "Avery GUI"
watermark.TextColor3 = Color3.fromRGB(200, 200, 200)
watermark.TextTransparency = 0.3
watermark.Font = Enum.Font.SourceSansItalic
watermark.TextScaled = true
watermark.Parent = frame

-- Flash Effect
local function flash(color)
	local flashFrame = Instance.new("Frame")
	flashFrame.Size = UDim2.new(1, 0, 1, 0)
	flashFrame.BackgroundColor3 = color
	flashFrame.BackgroundTransparency = 0.5
	flashFrame.Parent = frame
	game:GetService("Debris"):AddItem(flashFrame, 0.3)
end

-- Spawn Logic
setSpawn1Btn.MouseButton1Click:Connect(function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		spawn1 = LocalPlayer.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0, 255, 0))
	end
end)

useSpawn1Btn.MouseButton1Click:Connect(function()
	if spawn1 then
		activeSpawn = spawn1
		spawnIndicator.Text = "Active: Spawn 1"
		flash(Color3.fromRGB(0, 200, 255))
	end
end)

setSpawn2Btn.MouseButton1Click:Connect(function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		spawn2 = LocalPlayer.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0, 255, 0))
	end
end)

useSpawn2Btn.MouseButton1Click:Connect(function()
	if spawn2 then
		activeSpawn = spawn2
		spawnIndicator.Text = "Active: Spawn 2"
		flash(Color3.fromRGB(0, 200, 255))
	end
end)

-- Character Respawn
LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	task.wait(0.2)
	if activeSpawn then
		char:WaitForChild("HumanoidRootPart").CFrame = activeSpawn
	end
end)

-- Close / Minimize Logic
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	reopenButton.Visible = true
end)

minimizeBtn.MouseButton1Click:Connect(function()
	for _, obj in ipairs(frame:GetChildren()) do
		if obj:IsA("TextButton") or obj:IsA("TextLabel") then
			if obj ~= title and obj ~= closeBtn and obj ~= minimizeBtn then
				obj.Visible = not obj.Visible
			end
		end
	end
end)

reopenButton.MouseButton1Click:Connect(function()
	frame.Visible = true
	reopenButton.Visible = false
end)
