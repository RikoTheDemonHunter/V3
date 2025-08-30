-- // Auto Spawn Point with Double Slots, Active Selector, Closable, Minimize + Draggable GUI
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local spawn1, spawn2 = nil, nil
local activeSpawn = nil

-- Create GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "SpawnGui"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 260)
frame.Position = UDim2.new(0.35, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Name = "MainFrame"

-- Top bar buttons
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "❌"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)

local minimizeBtn = Instance.new("TextButton", frame)
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -60, 0, 5)
minimizeBtn.Text = "➖"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, -70, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Auto Spawn Manager"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.SourceSansBold
title.TextScaled = true

-- Flash effect
local flash = Instance.new("Frame", frame)
flash.Size = UDim2.new(1,0,0,10)
flash.Position = UDim2.new(0,0,1,-15)
flash.BackgroundTransparency = 1

local function flashColor(color)
	flash.BackgroundColor3 = color
	flash.BackgroundTransparency = 0
	game:GetService("TweenService"):Create(flash, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
end

-- Utility: create buttons
local buttons = {} -- store for minimize/restore
local function makeButton(txt, posY, callback)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.9, 0, 0, 30)
	btn.Position = UDim2.new(0.05, 0, 0, posY)
	btn.Text = txt
	btn.TextColor3 = Color3.new(1,1,1)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.MouseButton1Click:Connect(callback)
	table.insert(buttons, btn)
	return btn
end

-- Spawn 1 buttons
makeButton("Set Spawn 1", 40, function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn1 = player.Character.HumanoidRootPart.CFrame
		flashColor(Color3.fromRGB(0,255,0))
	end
end)

makeButton("Use Spawn 1", 75, function()
	if spawn1 then
		activeSpawn = 1
		flashColor(Color3.fromRGB(0,200,200))
	end
end)

makeButton("Teleport Spawn 1", 110, function()
	if spawn1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = spawn1
	end
end)

-- Spawn 2 buttons
makeButton("Set Spawn 2", 150, function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn2 = player.Character.HumanoidRootPart.CFrame
		flashColor(Color3.fromRGB(0,255,0))
	end
end)

makeButton("Use Spawn 2", 185, function()
	if spawn2 then
		activeSpawn = 2
		flashColor(Color3.fromRGB(0,200,200))
	end
end)

makeButton("Teleport Spawn 2", 220, function()
	if spawn2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		player.Character.HumanoidRootPart.CFrame = spawn2
	end
end)

-- Auto respawn teleport
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	task.wait(0.2)
	if activeSpawn == 1 and spawn1 then
		char.HumanoidRootPart.CFrame = spawn1
	elseif activeSpawn == 2 and spawn2 then
		char.HumanoidRootPart.CFrame = spawn2
	end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- Minimize button
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, btn in ipairs(buttons) do
		btn.Visible = not minimized
	end
	flash.Visible = not minimized
	if minimized then
		frame.Size = UDim2.new(0, 300, 0, 40) -- shrink
	else
		frame.Size = UDim2.new(0, 300, 0, 260) -- restore
	end
end)
