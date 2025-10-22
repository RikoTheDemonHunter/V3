-- 🌟 Avery's Advanced Auto Spawn GUI (Themes + Premium + Auto-Spawn)
-- Fully optimized, smooth, error-free

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- Variables
local spawn1, spawn2 = nil, nil
local activeSpawn = nil
local activeTween = nil

-- Flash function for feedback
local function flash(color)
	local flashFrame = Instance.new("Frame")
	flashFrame.Size = UDim2.new(1, 0, 1, 0)
	flashFrame.BackgroundColor3 = color
	flashFrame.BackgroundTransparency = 0.5
	flashFrame.ZIndex = 10
	flashFrame.Parent = frame
	Debris:AddItem(flashFrame, 0.25)
end

-- Active indicator
local function updateIndicator()
	if activeSpawn == spawn1 then
		indicator.Text = "Active: Spawn 1"
	elseif activeSpawn == spawn2 then
		indicator.Text = "Active: Spawn 2"
	else
		indicator.Text = "Active: None"
	end
end

-- 🧱 GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "SpawnPointGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 360)
frame.Position = UDim2.new(0.5, -140, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Avery's Auto Spawn"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Active spawn indicator
local indicator = Instance.new("TextLabel")
indicator.Size = UDim2.new(1, -20, 0, 20)
indicator.Position = UDim2.new(0, 10, 0, 45)
indicator.BackgroundTransparency = 1
indicator.Text = "Active: None"
indicator.TextColor3 = Color3.fromRGB(0, 255, 255)
indicator.Font = Enum.Font.Gotham
indicator.TextSize = 16
indicator.TextXAlignment = Enum.TextXAlignment.Left
indicator.Parent = frame

-- Scrolling buttons
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, -10, 0, 210)
buttonContainer.Position = UDim2.new(0, 5, 0, 70)
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 280)
buttonContainer.ScrollBarThickness = 6
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

-- Button creator
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

-- Minimize & Close
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

-- Button Functions
set1.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn1 = player.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0,255,0))
		updateIndicator()
	end
end)

set2.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn2 = player.Character.HumanoidRootPart.CFrame
		flash(Color3.fromRGB(0,255,0))
		updateIndicator()
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
	local minimized = buttonContainer.Visible
	buttonContainer.Visible = minimized
	indicator.Visible = minimized
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

-- 🌈 THEME SYSTEM (Light, Dark, Emerald, Rainbow, etc.)
local Themes = {
	["Light"] = {BG = Color3.fromRGB(240,240,240), Text = Color3.fromRGB(0,0,0), Accent = Color3.fromRGB(0,170,255)},
	["Dark"] = {BG = Color3.fromRGB(20,20,20), Text = Color3.fromRGB(255,255,255), Accent = Color3.fromRGB(0,150,255)},
	["Emerald"] = {BG = Color3.fromRGB(25,60,45), Text = Color3.fromRGB(200,255,210), Accent = Color3.fromRGB(0,255,150)},
	["Light Blue"] = {BG = Color3.fromRGB(210,235,255), Text = Color3.fromRGB(0,30,60), Accent = Color3.fromRGB(80,160,255)},
	["Mint"] = {BG = Color3.fromRGB(200,255,230), Text = Color3.fromRGB(20,50,40), Accent = Color3.fromRGB(0,200,120)},
	["Sunset"] = {BG = Color3.fromRGB(255,200,150), Text = Color3.fromRGB(50,20,10), Accent = Color3.fromRGB(255,100,50)},
	["Rainbow"] = {} -- handled dynamically
}

local themeNames = {"Light","Dark","Emerald","Rainbow","Light Blue","Mint","Sunset"}
local themeIndex = 1
local rainbowActive = false

local function applyTheme(theme)
	if theme == "Rainbow" then
		rainbowActive = true
	else
		rainbowActive = false
		local t = Themes[theme]
		frame.BackgroundColor3 = t.BG
		title.TextColor3 = t.Text
		buttonContainer.BackgroundColor3 = t.BG
	end
end

local themeBtn = createButton("Change Theme", 245)
themeBtn.MouseButton1Click:Connect(function()
	themeIndex = themeIndex + 1
	if themeIndex > #themeNames then themeIndex = 1 end
	applyTheme(themeNames[themeIndex])
end)

-- Rainbow smooth update
RunService.RenderStepped:Connect(function()
	if rainbowActive then
		local t = tick()*0.2
		frame.BackgroundColor3 = Color3.fromRGB(math.sin(t)*127+128, math.sin(t+2)*127+128, math.sin(t+4)*127+128)
	end
end)

-- 💎 Premium Section with multiple unique themes
local premiumBtn = createButton("Premium Themes", 280)
local premiumFrame = Instance.new("Frame")
premiumFrame.Size = UDim2.new(1,0,1,0)
premiumFrame.Position = UDim2.new(0,0,0,0)
premiumFrame.BackgroundColor3 = Color3.fromRGB(15,15,25)
premiumFrame.Visible = false
premiumFrame.Parent = frame

local backBtn = createButton("Back", 245)
backBtn.Parent = premiumFrame
backBtn.MouseButton1Click:Connect(function()
	premiumFrame.Visible = false
end)

-- Premium theme buttons
local premiumThemes = {
	["Neo"] = Color3.fromRGB(180,0,255),
	["Cyber"] = Color3.fromRGB(0,180,255),
	["Aurora"] = Color3.fromRGB(0,255,200),
	["Volta"] = Color3.fromRGB(255,50,50),
	["Luminous"] = Color3.fromRGB(255,255,100)
}

local yPos = 60
for name,color in pairs(premiumThemes) do
	local btn = createButton(name.." Theme", yPos)
	btn.BackgroundColor3 = color
	btn.Parent = premiumFrame
	btn.MouseButton1Click:Connect(function()
		frame.BackgroundColor3 = color
	end)
	yPos = yPos + 45
end

-- 🔑 Premium key
local premiumKey = "Avery133" -- replace with your key
local verified = false
premiumBtn.MouseButton1Click:Connect(function()
	if not verified then
		local keyPrompt = Instance.new("TextBox")
		keyPrompt.Size = UDim2.new(0.9,0,0,40)
		keyPrompt.Position = UDim2.new(0.05,0,0,160)
		keyPrompt.PlaceholderText = "Enter Key..."
		keyPrompt.BackgroundColor3 = Color3.fromRGB(50,50,50)
		keyPrompt.TextColor3 = Color3.fromRGB(255,255,255)
		keyPrompt.Font = Enum.Font.Gotham
		keyPrompt.TextSize = 16
		keyPrompt.Parent = frame

		local cornerKey = Instance.new("UICorner")
		cornerKey.CornerRadius = UDim.new(0,6)
		cornerKey.Parent = keyPrompt

		keyPrompt.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				if keyPrompt.Text == premiumKey then
					verified = true
					keyPrompt:Destroy()
					premiumFrame.Visible = true
				else
					keyPrompt.PlaceholderText = "Invalid Key"
					keyPrompt.Text = ""
				end
			end
		end)
	else
		premiumFrame.Visible = not premiumFrame.Visible
	end
end)

-- 🏁 Auto-spawn on respawn with smooth cancel logic
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

print("✅ Full GUI with Spawn, Themes, Premium loaded with smooth auto-spawn!")
