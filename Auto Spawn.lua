-- Avery's Auto Spawn GUI (Advanced, Clean, Fancy, Safe, Auto Mode Switcher)
-- Local session only (no DataStore, no backup)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- Variables
local spawn1, spawn2 = nil, nil
local activeSpawn = nil
local activeTween = nil
local rainbowActive = false

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpawnPointGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.5, -125, 0.5, -150)
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

-- Scrolling Frame for buttons
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, -10, 0, 210)
buttonContainer.Position = UDim2.new(0, 5, 0, 60)
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 280)
buttonContainer.ScrollBarThickness = 6
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

local function createButton(text, posY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Position = UDim2.new(0, 5, 0, posY)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.AutoButtonColor = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = btn

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

-- Minimize, Close & Theme Buttons
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 0, 25)
minimizeBtn.Position = UDim2.new(1, -85, 0, 5)
minimizeBtn.Text = "-"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 18
minimizeBtn.Parent = frame
local cornerMini = Instance.new("UICorner")
cornerMini.CornerRadius = UDim.new(0, 6)
cornerMini.Parent = minimizeBtn

local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(0, 25, 0, 25)
themeBtn.Position = UDim2.new(1, -55, 0, 5)
themeBtn.Text = "🎨"
themeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
themeBtn.BackgroundColor3 = Color3.fromRGB(50, 120, 200)
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 14
themeBtn.Parent = frame
local cornerTheme = Instance.new("UICorner")
cornerTheme.CornerRadius = UDim.new(0, 6)
cornerTheme.Parent = themeBtn

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

-- Open Button
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

-- Button Functions
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

minimizeBtn.MouseButton1Click:Connect(function()
	local visible = not buttonContainer.Visible
	buttonContainer.Visible = visible
	indicator.Visible = visible
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)

-- Theme Switcher
local themes = {
	{bg = Color3.fromRGB(35,35,35), text = Color3.fromRGB(255,255,255)}, -- dark
	{bg = Color3.fromRGB(230,230,230), text = Color3.fromRGB(20,20,20)}, -- light
	{bg = Color3.fromRGB(20,80,60), text = Color3.fromRGB(220,255,220)}, -- emerald
	{bg = Color3.fromRGB(40,100,150), text = Color3.fromRGB(230,255,255)}, -- light blue
	"RAINBOW"
}
local themeIndex = 1

local function applyTheme(theme)
	if theme == "RAINBOW" then
		rainbowActive = true
		coroutine.wrap(function()
			while rainbowActive do
				for hue = 0, 1, 0.0025 do
					frame.BackgroundColor3 = Color3.fromHSV(hue, 0.8, 0.8)
					RunService.Heartbeat:Wait()
					if not rainbowActive then break end
				end
			end
		end)()
	else
		rainbowActive = false
		TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = theme.bg}):Play()
		title.TextColor3 = theme.text
		indicator.TextColor3 = theme.text
	end
end

themeBtn.MouseButton1Click:Connect(function()
	themeIndex += 1
	if themeIndex > #themes then themeIndex = 1 end
	applyTheme(themes[themeIndex])
end)

-- Character Auto Teleport
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

updateIndicator()
applyTheme(themes[themeIndex])
