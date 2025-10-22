-- Avery's Auto Spawn GUI (Advanced, Clean, Fancy, Safe, Auto-Save + Active Spawn Memory + Theme System + Hotkey Toggle)
-- Full Stable Build (No Errors)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local DataStoreService = game:GetService("DataStoreService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- Variables
local spawn1, spawn2 = nil, nil
local activeSpawn = nil
local activeTween = nil
local spawnStore
local themeIndex = 1
local themes = {"Dark", "Light", "Emerald", "Rainbow", "LightBlue"}
local currentTheme = "Dark"

local backup = {spawn1=nil, spawn2=nil, active=nil}

-- Safe datastore
pcall(function()
	spawnStore = DataStoreService:GetDataStore("AverySpawnDataV2")
end)
if not spawnStore then
	warn("⚠️ DataStore access failed, backup mode only.")
end

-- Backup save
local function saveBackup()
	backup.spawn1 = spawn1
	backup.spawn2 = spawn2
	backup.active = activeSpawn
end

-- Save Spawns
local function saveSpawns()
	saveBackup()
	if not spawnStore then return end
	pcall(function()
		spawnStore:SetAsync(player.UserId, {
			spawn1 = spawn1 and {CFrame = {spawn1.Position, spawn1.LookVector}} or nil,
			spawn2 = spawn2 and {CFrame = {spawn2.Position, spawn2.LookVector}} or nil,
			active = activeSpawn == spawn1 and 1 or activeSpawn == spawn2 and 2 or nil,
			theme = currentTheme
		})
	end)
end

-- Load Spawns
local function loadSpawns()
	if not spawnStore then return end
	local success, data = pcall(function()
		return spawnStore:GetAsync(player.UserId)
	end)
	if success and data then
		if data.spawn1 then
			spawn1 = CFrame.new(data.spawn1.CFrame[1], data.spawn1.CFrame[1] + data.spawn1.CFrame[2])
		end
		if data.spawn2 then
			spawn2 = CFrame.new(data.spawn2.CFrame[1], data.spawn2.CFrame[1] + data.spawn2.CFrame[2])
		end
		if data.active == 1 then
			activeSpawn = spawn1
		elseif data.active == 2 then
			activeSpawn = spawn2
		end
		if data.theme then
			currentTheme = data.theme
			for i, v in ipairs(themes) do
				if v == currentTheme then
					themeIndex = i
				end
			end
		end
	end)
end

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpawnPointGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 330)
frame.Position = UDim2.new(0.5, -125, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
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

-- Buttons
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, -10, 0, 240)
buttonContainer.Position = UDim2.new(0, 5, 0, 60)
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 310)
buttonContainer.ScrollBarThickness = 6
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

local function createButton(text, posY, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, posY)
	btn.BackgroundColor3 = color or Color3.fromRGB(60, 60, 60)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.AutoButtonColor = true
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 6)
	c.Parent = btn
	btn.Parent = buttonContainer
	return btn
end

local set1 = createButton("Set Spawn 1", 0)
local set2 = createButton("Set Spawn 2", 35)
local use1 = createButton("Use Spawn 1", 70)
local use2 = createButton("Use Spawn 2", 105)
local tp1 = createButton("Teleport to Spawn 1", 140)
local tp2 = createButton("Teleport to Spawn 2", 175)
local clearBtn = createButton("Clear Active Spawn", 210)
local themeBtn = createButton("Change Theme", 245, Color3.fromRGB(40,120,255)) -- highlighted

-- Top controls
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -55, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = frame
local cornerMini = Instance.new("UICorner")
cornerMini.CornerRadius = UDim.new(0, 6)
cornerMini.Parent = minimizeBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = frame
local cornerClose = Instance.new("UICorner")
cornerClose.CornerRadius = UDim.new(0, 6)
cornerClose.Parent = closeBtn

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 140, 0, 40)
openBtn.Position = UDim2.new(0, 15, 0.8, 0)
openBtn.Text = "Open Spawn Menu"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
openBtn.Visible = false
openBtn.Active = true
openBtn.Draggable = true
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.Parent = screenGui
local cornerOpen = Instance.new("UICorner")
cornerOpen.CornerRadius = UDim.new(0, 8)
cornerOpen.Parent = openBtn

-- Theme System
local function applyTheme(name)
	local bkg, text, accent = Color3.fromRGB(35,35,35), Color3.new(1,1,1), Color3.fromRGB(60,60,60)
	if name == "Light" then
		bkg, text, accent = Color3.fromRGB(240,240,240), Color3.new(0,0,0), Color3.fromRGB(220,220,220)
	elseif name == "Emerald" then
		bkg, text, accent = Color3.fromRGB(30,60,40), Color3.fromRGB(200,255,200), Color3.fromRGB(40,100,60)
	elseif name == "LightBlue" then
		bkg, text, accent = Color3.fromRGB(170,200,255), Color3.fromRGB(0,0,60), Color3.fromRGB(120,160,255)
	elseif name == "Rainbow" then
		local t = 0
		RunService:UnbindFromRenderStep("RainbowAnim")
		RunService:BindToRenderStep("RainbowAnim", Enum.RenderPriority.First.Value, function(dt)
			t = t + dt*0.3
			frame.BackgroundColor3 = Color3.fromHSV(t%1, 0.6, 1)
		end)
		return
	else
		RunService:UnbindFromRenderStep("RainbowAnim")
	end
	TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundColor3 = bkg}):Play()
	for _, v in ipairs(buttonContainer:GetChildren()) do
		if v:IsA("TextButton") then
			TweenService:Create(v, TweenInfo.new(0.3), {BackgroundColor3 = accent, TextColor3 = text}):Play()
		end
	end
	title.TextColor3 = text
	indicator.TextColor3 = text
end

themeBtn.MouseButton1Click:Connect(function()
	themeIndex = themeIndex % #themes + 1
	currentTheme = themes[themeIndex]
	flash(Color3.fromRGB(100,200,255))
	applyTheme(currentTheme)
	saveSpawns()
end)

-- Buttons logic
set1.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn1 = player.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0,255,0))
		saveSpawns()
	end
end)

set2.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn2 = player.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0,255,0))
		saveSpawns()
	end
end)

use1.MouseButton1Click:Connect(function()
	if spawn1 then
		activeSpawn = spawn1
		updateIndicator()
		flash(Color3.fromRGB(0,255,255))
		saveSpawns()
	end
end)

use2.MouseButton1Click:Connect(function()
	if spawn2 then
		activeSpawn = spawn2
		updateIndicator()
		flash(Color3.fromRGB(0,255,255))
		saveSpawns()
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
	saveSpawns()
end)

-- Minimize / close
minimizeBtn.MouseButton1Click:Connect(function()
	local minimized = not buttonContainer.Visible
	buttonContainer.Visible = minimized
	indicator.Visible = minimized
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

-- Hotkey toggle (P)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.P then
		frame.Visible = not frame.Visible
		openBtn.Visible = not frame.Visible
	end
end)

-- Load and apply
loadSpawns()
updateIndicator()
applyTheme(currentTheme)

-- Save on leave
game.Players.PlayerRemoving:Connect(function(p)
	if p == player then saveSpawns() end
end)

-- Auto-tp
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
