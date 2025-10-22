-- Avery's Auto Spawn GUI + Theme + Radar (Part 1/2)
-- Advanced, Clean, Fancy, Safe, and Smooth 🌈

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local spawn1, spawn2 = nil, nil
local activeSpawn = nil
local activeTween = nil
local rainbowConnection = nil
local radarEnabled = false

-- 🖌️ THEMES
local Themes = {
	["Dark"] = {Frame = Color3.fromRGB(35, 35, 35), Button = Color3.fromRGB(60, 60, 60), Text = Color3.fromRGB(255, 255, 255)},
	["Light"] = {Frame = Color3.fromRGB(240, 240, 240), Button = Color3.fromRGB(210, 210, 210), Text = Color3.fromRGB(20, 20, 20)},
	["Emerald"] = {Frame = Color3.fromRGB(20, 80, 60), Button = Color3.fromRGB(40, 140, 100), Text = Color3.fromRGB(255, 255, 255)},
	["Light Blue"] = {Frame = Color3.fromRGB(50, 100, 160), Button = Color3.fromRGB(70, 140, 200), Text = Color3.fromRGB(255, 255, 255)},
	["Sunset"] = {Frame = Color3.fromRGB(255, 130, 80), Button = Color3.fromRGB(200, 80, 60), Text = Color3.fromRGB(255, 255, 255)},
	["Neon"] = {Frame = Color3.fromRGB(10, 10, 30), Button = Color3.fromRGB(0, 255, 180), Text = Color3.fromRGB(255, 255, 255)},
	["Pastel"] = {Frame = Color3.fromRGB(255, 220, 230), Button = Color3.fromRGB(255, 190, 200), Text = Color3.fromRGB(60, 60, 60)},
	["Rainbow"] = {Frame = "Rainbow", Button = "Rainbow", Text = Color3.fromRGB(255, 255, 255)}
}

local currentThemeIndex = 1
local themeOrder = {"Dark", "Light", "Emerald", "Light Blue", "Sunset", "Neon", "Pastel", "Rainbow"}

-- 🪄 Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpawnPointGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 320)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
frame.BackgroundColor3 = Themes["Dark"].Frame
frame.Active = true
frame.Draggable = true
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Avery's Auto Spawn"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local indicator = Instance.new("TextLabel")
indicator.Size = UDim2.new(1, -20, 0, 20)
indicator.Position = UDim2.new(0, 10, 0, 35)
indicator.BackgroundTransparency = 1
indicator.Text = "Active: None"
indicator.TextColor3 = Color3.fromRGB(0, 255, 255)
indicator.Font = Enum.Font.Gotham
indicator.TextSize = 16
indicator.TextXAlignment = Enum.TextXAlignment.Left
indicator.Parent = frame

local function flash(color)
	local flashFrame = Instance.new("Frame")
	flashFrame.Size = UDim2.new(1, 0, 1, 0)
	flashFrame.BackgroundColor3 = color
	flashFrame.BackgroundTransparency = 0.5
	flashFrame.ZIndex = 10
	flashFrame.Parent = frame
	Debris:AddItem(flashFrame, 0.25)
end

local function updateIndicator()
	if activeSpawn == spawn1 then
		indicator.Text = "Active: Spawn 1"
	elseif activeSpawn == spawn2 then
		indicator.Text = "Active: Spawn 2"
	else
		indicator.Text = "Active: None"
	end
end

-- Button Maker
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, -10, 0, 210)
buttonContainer.Position = UDim2.new(0, 5, 0, 60)
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 340)
buttonContainer.ScrollBarThickness = 6
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

local function createButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, posY)
	btn.BackgroundColor3 = Themes["Dark"].Button
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.AutoButtonColor = true
	btn.Parent = buttonContainer
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn
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
local themeBtn = createButton("Switch Theme", 245)
local radarBtn = createButton("Toggle Radar", 280)

-- 🌈 Apply Themes
local function applyTheme(name)
	local theme = Themes[name]
	if rainbowConnection then
		rainbowConnection:Disconnect()
		rainbowConnection = nil
	end

	if theme.Frame == "Rainbow" then
		rainbowConnection = RunService.RenderStepped:Connect(function(dt)
			local t = tick() * 0.2 -- slow rainbow cycle
			local r = math.sin(t) * 127 + 128
			local g = math.sin(t + 2) * 127 + 128
			local b = math.sin(t + 4) * 127 + 128
			local c = Color3.fromRGB(r, g, b)
			frame.BackgroundColor3 = c
			for _,btn in pairs(buttonContainer:GetChildren()) do
				if btn:IsA("TextButton") then
					btn.BackgroundColor3 = c
				end
			end
		end)
	else
		frame.BackgroundColor3 = theme.Frame
		for _,btn in pairs(buttonContainer:GetChildren()) do
			if btn:IsA("TextButton") then
				btn.BackgroundColor3 = theme.Button
				btn.TextColor3 = theme.Text
			end
		end
		title.TextColor3 = theme.Text
		indicator.TextColor3 = theme.Text
	end
end

themeBtn.MouseButton1Click:Connect(function()
	currentThemeIndex = currentThemeIndex + 1
	if currentThemeIndex > #themeOrder then currentThemeIndex = 1 end
	local selected = themeOrder[currentThemeIndex]
	applyTheme(selected)
	flash(Color3.fromRGB(255,255,0))
end)

-- 🧭 Radar System
local radarFrame = Instance.new("Frame")
radarFrame.Size = UDim2.new(0,150,0,150)
radarFrame.AnchorPoint = Vector2.new(1,1)
radarFrame.Position = UDim2.new(1,-20,1,-20)
radarFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
radarFrame.BackgroundTransparency = 0.3
radarFrame.Visible = false
radarFrame.Parent = screenGui
local cornerRadar = Instance.new("UICorner")
cornerRadar.CornerRadius = UDim.new(1,0)
cornerRadar.Parent = radarFrame

local radarDot = Instance.new("Frame")
radarDot.Size = UDim2.new(0,6,0,6)
radarDot.AnchorPoint = Vector2.new(0.5,0.5)
radarDot.Position = UDim2.new(0.5,0,0.5,0)
radarDot.BackgroundColor3 = Color3.fromRGB(0,255,0)
radarDot.BorderSizePixel = 0
radarDot.Parent = radarFrame
local radarCorner = Instance.new("UICorner")
radarCorner.CornerRadius = UDim.new(1,0)
radarCorner.Parent = radarDot

local radarLine = Instance.new("Frame")
radarLine.Size = UDim2.new(0,1,0.5,0)
radarLine.Position = UDim2.new(0.5,0,0.5,0)
radarLine.AnchorPoint = Vector2.new(0.5,1)
radarLine.BackgroundColor3 = Color3.fromRGB(0,255,0)
radarLine.BorderSizePixel = 0
radarLine.Parent = radarFrame

radarBtn.MouseButton1Click:Connect(function()
	radarEnabled = not radarEnabled
	radarFrame.Visible = radarEnabled
	if radarEnabled then
		flash(Color3.fromRGB(0,255,0))
	else
		flash(Color3.fromRGB(255,0,0))
	end
end)

RunService.RenderStepped:Connect(function()
	if radarEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = player.Character.HumanoidRootPart
		radarLine.Rotation = -hrp.Orientation.Y
	end
end)

-- ✨ Spawn Button Logic
set1.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn1 = player.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0,255,0))
	end
end)

set2.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn2 = player.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0,255,0))
	end
end)

use1.MouseButton1Click:Connect(function()
	if spawn1 then
		activeSpawn = spawn1
		updateIndicator()
		flash(Color3.fromRGB(0,255,255))
	end
end)

use2.MouseButton1Click:Connect(function()
	if spawn2 then
		activeSpawn = spawn2
		updateIndicator()
		flash(Color3.fromRGB(0,255,255))
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
	if activeTween then
		activeTween:Cancel()
		activeTween = nil
	end
	updateIndicator()
	flash(Color3.fromRGB(255,0,0))
end)

-- 🚀 Auto-Correct Spawn
player.CharacterAdded:Connect(function(char)
	local hrp = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid")
	task.wait(0.5)
	if activeSpawn and hrp then
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tweenGoal = {CFrame = activeSpawn}
		local tween = TweenService:Create(hrp, tweenInfo, tweenGoal)
		activeTween = tween
		local conn
		conn = RunService.RenderStepped:Connect(function()
			if humanoid and humanoid.MoveDirection.Magnitude > 0 then
				tween:Cancel()
				conn:Disconnect()
				activeTween = nil
			elseif not activeSpawn then
				tween:Cancel()
				conn:Disconnect()
				activeTween = nil
			end
		end)
		tween:Play()
		tween.Completed:Connect(function()
			if conn then conn:Disconnect() end
			activeTween = nil
		end)
	end
end)

-- 🧩 Default Theme
applyTheme("Dark")
updateIndicator()
