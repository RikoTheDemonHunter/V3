-- Modernized & Fixed Auto-Spawn Script
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

local types = {"[INFO]", "[SYSTEM]", "[WARNING]", "[DEBUG]", "[NOTICE]", "[ALERT]"}
local function randomType() return types[math.random(1, #types)] end

local function generateSessionHash()
	local chars = "ABCDEF0123456789"
	local hash = {}
	for i = 1, 12 do
		local r = math.random(1, #chars)
		hash[i] = chars:sub(r, r)
	end
	return table.concat(hash)
end

local platform = UserInputService.TouchEnabled and "Mobile" or UserInputService.KeyboardEnabled and "Desktop" or "Unknown"
local sessionHash = generateSessionHash()

print(randomType() .. " Initializing secure session...")
print("[SYSTEM] User: " .. player.Name .. " (ID: " .. player.UserId .. ")")
print("[INFO] Account Age: " .. player.AccountAge .. " days")
print("[DEBUG] Platform: " .. platform)
print("[NOTICE] Session Hash: " .. sessionHash)
print("[SYSTEM] Integrity check passed")

-- State Variables
local spawn1, spawn2 = nil, nil
local activeSpawn = nil
local activeTween = nil

local premiumKey = "Avery133"
local premiumAttempts = 0
local premiumLocked = false
local premiumLockSeconds = 300
local premiumLockTimer = nil

local etherealActive = false
local etherealTicker = 0
local verified = false

-- Core Screen GUI
local gui = Instance.new("ScreenGui")
gui.Name = "AverySpawnSuite"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Modern Glassmorphic Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 380)
frame.Position = UDim2.new(0.5, -150, 0.5, -190)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
frame.BackgroundTransparency = 0.15  -- Modern Acrylic Transparency
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = gui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 16) -- Rounded Corners
frameCorner.Parent = frame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.fromRGB(255, 255, 255)
frameStroke.Transparency = 0.85
frameStroke.Thickness = 1
frameStroke.Parent = frame

-- Dynamic Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 45)
title.BackgroundTransparency = 1
title.Text = "Avery's Auto Spawn"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(240, 240, 245)
title.Parent = frame

-- Active Sub-indicator
local indicator = Instance.new("TextLabel")
indicator.Size = UDim2.new(1, -30, 0, 20)
indicator.Position = UDim2.new(0, 15, 0, 45)
indicator.BackgroundTransparency = 1
indicator.Text = "● Active: None"
indicator.TextColor3 = Color3.fromRGB(150, 155, 170)
indicator.Font = Enum.Font.GothamMedium
indicator.TextSize = 13
indicator.TextXAlignment = Enum.TextXAlignment.Left
indicator.Parent = frame

-- Visual Notification Flash
local function flash(color)
	local flashObj = Instance.new("UIStroke")
	flashObj.Thickness = 2
	flashObj.Color = color
	flashObj.Transparency = 0
	flashObj.Parent = frame
	TweenService:Create(flashObj, TweenInfo.new(0.4), {Transparency = 1}):Play()
	Debris:AddItem(flashObj, 0.4)
end

local function updateIndicator()
	if activeSpawn == spawn1 then
		indicator.Text = "● Active: Spawn 1"
		indicator.TextColor3 = Color3.fromRGB(0, 210, 255)
	elseif activeSpawn == spawn2 then
		indicator.Text = "● Active: Spawn 2"
		indicator.TextColor3 = Color3.fromRGB(170, 100, 255)
	else
		indicator.Text = "● Active: None"
		indicator.TextColor3 = Color3.fromRGB(150, 155, 170)
	end
end

-- Scrolling Engine
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, -20, 1, -125)
buttonContainer.Position = UDim2.new(0, 10, 0, 75)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ScrollBarThickness = 2
buttonContainer.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 90)
buttonContainer.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = buttonContainer

listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	buttonContainer.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
end)

-- Universal Modern Button Constructor
local function createButton(text, order, parent, isSecondary)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -4, 0, 36)
	btn.BackgroundColor3 = isSecondary and Color3.fromRGB(30, 30, 40) or Color3.fromRGB(40, 40, 50)
	btn.BackgroundTransparency = 0.3
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(240, 240, 250)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.LayoutOrder = order
	btn.AutoButtonColor = false
	
	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn
	
	local btnStroke = Instance.new("UIStroke")
	btnStroke.Color = Color3.fromRGB(255, 255, 255)
	btnStroke.Transparency = 0.95
	btnStroke.Parent = btn

	btn.Parent = parent

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundTransparency = 0.3, TextColor3 = Color3.fromRGB(240, 240, 250)}):Play()
	end)

	return btn
end

-- Layout Population
local set1     = createButton("Set Spawn Point 1", 1, buttonContainer, false)
local use1     = createButton("Toggle Auto Spawn 1", 2, buttonContainer, true)
local tp1      = createButton("Teleport to Spawn 1", 3, buttonContainer, true)
local set2     = createButton("Set Spawn Point 2", 4, buttonContainer, false)
local use2     = createButton("Toggle Auto Spawn 2", 5, buttonContainer, true)
local tp2      = createButton("Teleport to Spawn 2", 6, buttonContainer, true)
local clearBtn = createButton("Clear Active Targets", 7, buttonContainer, false)
local themeBtn = createButton("Cycle Visual Themes", 8, buttonContainer, false)
local premiumBtn = createButton("✨ Access Premium Themes", 9, buttonContainer, false)

-- Modern Window Controls
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -38, 0, 10)
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.fromRGB(180, 185, 200)
closeBtn.BackgroundTransparency = 1
closeBtn.Font = Enum.Font.GothamMedium
closeBtn.TextSize = 22
closeBtn.Parent = frame

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 50, 0, 50)
openBtn.Position = UDim2.new(0, 20, 1, -70)
openBtn.Text = "⚙️"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
openBtn.BackgroundTransparency = 0.2
openBtn.Visible = false
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 20
openBtn.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0) -- Perfect Circle
openCorner.Parent = openBtn

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(255, 255, 255)
openStroke.Transparency = 0.8
openStroke.Parent = openBtn

-- Smooth Window Management Toggle Animations
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	frame.Size = UDim2.new(0, 300, 0, 0)
	buttonContainer.Visible = false
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, 380)}):Play()
	task.delay(0.15, function() buttonContainer.Visible = true end)
	openBtn.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
	buttonContainer.Visible = false
	local t = TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 300, 0, 0)})
	t:Play()
	t.Completed:Connect(function()
		frame.Visible = false
		openBtn.Visible = true
	end)
end)

-- Dynamic Smooth Draggable UI System Engine
local function makeDraggable(targetFrame)
	local dragging, dragInput, dragStart, startPos
	targetFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = targetFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	targetFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			TweenService:Create(targetFrame, TweenInfo.new(0.08, Enum.EasingStyle.Out), {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			}):Play()
		end
	end)
end
makeDraggable(frame)
makeDraggable(openBtn)

-- Core Functional Bindings
set1.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		spawn1 = char.HumanoidRootPart.CFrame
		updateIndicator()
		flash(Color3.fromRGB(0, 210, 255))
	end
end)

set2.MouseButton1Click:Connect(function()
	local char = player.Character
	if char and char:FindFirstChild("HumanoidRootPart") then
		spawn2 = char.HumanoidRootPart.CFrame
		updateIndicator()
		flash(Color3.fromRGB(170, 100, 255))
	end
end)

use1.MouseButton1Click:Connect(function()
	if spawn1 then activeSpawn = spawn1 updateIndicator() flash(Color3.fromRGB(255, 255, 255)) end
end)

use2.MouseButton1Click:Connect(function()
	if spawn2 then activeSpawn = spawn2 updateIndicator() flash(Color3.fromRGB(255, 255, 255)) end
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
	if activeTween then activeTween:Cancel() activeTween = nil end
	updateIndicator()
	flash(Color3.fromRGB(240, 70, 70))
end)

-- Clean Theme Engine Configuration
local Themes = {
	["Dark"] = {BG = Color3.fromRGB(15, 15, 20), Text = Color3.fromRGB(240, 240, 245)},
	["Light"] = {BG = Color3.fromRGB(245, 245, 250), Text = Color3.fromRGB(20, 20, 30)},
	["Emerald"] = {BG = Color3.fromRGB(10, 28, 20), Text = Color3.fromRGB(190, 255, 210)},
	["Nordic Ocean"] = {BG = Color3.fromRGB(15, 25, 35), Text = Color3.fromRGB(200, 230, 255)},
	["Cyberpunk"] = {BG = Color3.fromRGB(25, 10, 25), Text = Color3.fromRGB(255, 100, 200)},
	["Rainbow"] = {}
}
local themeNames = {"Dark", "Light", "Emerald", "Nordic Ocean", "Cyberpunk", "Rainbow"}
local themeIndex = 1
local rainbowActive = false

local function applyTheme(theme)
	etherealActive = false
	if theme == "Rainbow" then
		rainbowActive = true
	else
		rainbowActive = false
		local data = Themes[theme]
		TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundColor3 = data.BG}):Play()
		title.TextColor3 = data.Text
	end
end

themeBtn.MouseButton1Click:Connect(function()
	themeIndex = (themeIndex % #themeNames) + 1
	applyTheme(themeNames[themeIndex])
end)

-- Frame Feedback Messaging Utility
local function showFrameMessage(message, color)
	if frame:FindFirstChild("TempMsg") then frame.TempMsg:Destroy() end
	local msg = Instance.new("TextLabel")
	msg.Name = "TempMsg"
	msg.Size = UDim2.new(1, -30, 0, 30)
	msg.Position = UDim2.new(0, 15, 1, -42)
	msg.BackgroundTransparency = 1
	msg.Text = message
	msg.Font = Enum.Font.GothamMedium
	msg.TextSize = 12
	msg.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	msg.Parent = frame
	Debris:AddItem(msg, 3)
end

-- Premium Interface Overlay Module
local premiumFrame = Instance.new("Frame")
premiumFrame.Size = UDim2.new(1, 0, 1, 0)
premiumFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
premiumFrame.BackgroundTransparency = 0.05
premiumFrame.BorderSizePixel = 0
premiumFrame.Visible = false
premiumFrame.Parent = frame
Instance.new("UICorner", premiumFrame).CornerRadius = UDim.new(0, 16)

local backArrow = Instance.new("TextButton")
backArrow.Size = UDim2.new(0, 30, 0, 30)
backArrow.Position = UDim2.new(0, 12, 0, 12)
backArrow.Text = "←"
backArrow.TextColor3 = Color3.fromRGB(200, 200, 210)
backArrow.BackgroundTransparency = 1
backArrow.Font = Enum.Font.GothamBold
backArrow.TextSize = 18
backArrow.Parent = premiumFrame

backArrow.MouseButton1Click:Connect(function() premiumFrame.Visible = false end)

local premiumScroll = Instance.new("ScrollingFrame")
premiumScroll.Size = UDim2.new(1, -20, 1, -60)
premiumScroll.Position = UDim2.new(0, 10, 0, 50)
premiumScroll.BackgroundTransparency = 1
premiumScroll.ScrollBarThickness = 2
premiumScroll.Parent = premiumFrame

local pListLayout = Instance.new("UIListLayout")
pListLayout.Padding = UDim.new(0, 6)
pListLayout.SortOrder = Enum.SortOrder.LayoutOrder
pListLayout.Parent = premiumScroll

pListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	premiumScroll.CanvasSize = UDim2.new(0, 0, 0, pListLayout.AbsoluteContentSize.Y + 10)
end)

local premiumThemes = {
	{"Neo Aura", Color3.fromRGB(150, 0, 255)},
	{"Cyber Grid", Color3.fromRGB(0, 160, 255)},
	{"Polar Aurora", Color3.fromRGB(0, 235, 170)},
	{"Volcanic Core", Color3.fromRGB(235, 40, 40)},
	{"Deep Plasma", Color3.fromRGB(200, 0, 160)},
	{"Ethereal Drift", Color3.fromRGB(110, 70, 210)}
}

for idx, data in ipairs(premiumThemes) do
	local pName, pColor = data[1], data[2]
	local btn = createButton(pName, idx, premiumScroll, false)
	btn.BackgroundColor3 = pColor
	btn.BackgroundTransparency = 0.6
	
	btn.MouseButton1Click:Connect(function()
		if premiumLocked then return end
		if pName == "Ethereal Drift" then
			etherealActive = true
		else
			etherealActive = false
			TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundColor3 = pColor}):Play()
		end
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
end

-- Security warning prompt creation popup
local function showWarningPopup()
	if gui:FindFirstChild("PremiumWarn") then return end
	local warn = Instance.new("Frame")
	warn.Name = "PremiumWarn"
	warn.Size = UDim2.new(0, 250, 0, 90)
	warn.Position = UDim2.new(0.5, -125, 0.4, -45)
	warn.BackgroundColor3 = Color3.fromRGB(25, 20, 20)
	warn.Parent = gui
	Instance.new("UICorner", warn).CornerRadius = UDim.new(0, 12)
	Instance.new("UIStroke", warn).Color = Color3.fromRGB(230, 80, 80)

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -20, 1, -20)
	txt.Position = UDim2.new(0, 10, 0, 10)
	txt.BackgroundTransparency = 1
	txt.Font = Enum.Font.GothamBold
	txt.TextSize = 12
	txt.TextColor3 = Color3.fromRGB(255, 100, 100)
	txt.Text = "⚠️ LAST ATTEMPT!\nIncorrect access key input will lock modules for 5 minutes."
	txt.TextWrapped = true
	txt.Parent = warn

	Debris:AddItem(warn, 4)
end

-- Premium system handler lockdown routine
local function lockPremium()
	if premiumLocked then return end
	premiumLocked = true
	premiumAttempts = 0
	
	local origText = premiumBtn.Text
	premiumBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
	premiumBtn.Text = "Lockout Active (05:00)"
	if premiumFrame.Visible then premiumFrame.Visible = false end

	local remaining = premiumLockSeconds
	premiumLockTimer = task.spawn(function()
		while remaining > 0 do
			local mins, secs = math.floor(remaining / 60), remaining % 60
			premiumBtn.Text = string.format("Locked (%02d:%02d)", mins, secs)
			task.wait(1)
			remaining -= 1
		end
		premiumLocked = false
		premiumBtn.Text = origText
		showFrameMessage("System unlocked. Ready.", Color3.fromRGB(100, 255, 100))
	end)
end

premiumBtn.MouseButton1Click:Connect(function()
	if premiumLocked then return end
	if not verified then
		if frame:FindFirstChild("KeyPrompt") then return end

		local keyPrompt = Instance.new("TextBox")
		keyPrompt.Name = "KeyPrompt"
		keyPrompt.Size = UDim2.new(1, -40, 0, 36)
		keyPrompt.Position = UDim2.new(0, 20, 0, 180)
		keyPrompt.PlaceholderText = "Enter Security Key..."
		keyPrompt.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
		keyPrompt.TextColor3 = Color3.fromRGB(255, 255, 255)
		keyPrompt.Font = Enum.Font.Gotham
		keyPrompt.TextSize = 14
		keyPrompt.Parent = frame
		Instance.new("UICorner", keyPrompt).CornerRadius = UDim.new(0, 8)

		keyPrompt.FocusLost:Connect(function(enterPressed)
			if not enterPressed then return end
			if keyPrompt.Text == premiumKey then
				verified = true
				keyPrompt:Destroy()
				premiumFrame.Visible = true
			else
				premiumAttempts += 1
				if premiumAttempts == 1 then
					keyPrompt.Text = ""
					keyPrompt.PlaceholderText = "Invalid - Verification Failed"
				elseif premiumAttempts == 2 then
					keyPrompt.Text = ""
					showWarningPopup()
					keyPrompt:Destroy()
				elseif premiumAttempts >= 3 then
					keyPrompt:Destroy()
					lockPremium()
				end
			end
		end)
	else
		premiumFrame.Visible = not premiumFrame.Visible
	end
end)

-- Main Render Tracking Animations Loops
RunService.RenderStepped:Connect(function(delta)
	if rainbowActive then
		local t = tick() * 1.2
		frame.BackgroundColor3 = Color3.fromHSV((t * 0.1) % 1, 0.5, 0.15)
	elseif etherealActive then
		etherealTicker += (delta or 0.016)
		frame.BackgroundColor3 = Color3.fromHSV((etherealTicker * 0.05) % 1, 0.45, 0.12)
	end
end)

-- Safely Wrapped Dynamic Respawn Auto-Teleport Mechanics Engine
local function setupCharacter(char)
	local hrp = char:WaitForChild("HumanoidRootPart", 5)
	local hum = char:WaitForChild("Humanoid", 5)
	if not (hrp and hum) then return end
	
	task.wait(0.4) -- Grace delay timeframe
	if activeSpawn and hrp then
		if activeTween then activeTween:Cancel() end
		
		activeTween = TweenService:Create(hrp, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = activeSpawn})
		
		local motionHook
		motionHook = RunService.RenderStepped:Connect(function()
			if (hum and hum.MoveDirection.Magnitude > 0) or (not activeSpawn) then
				if activeTween then activeTween:Cancel() activeTween = nil end
				motionHook:Disconnect()
			end
		end)
		
		activeTween.Completed:Connect(function()
			if motionHook then motionHook:Disconnect() end
			activeTween = nil
		end)
		
		activeTween:Play()
	end

	-- Auto collapse window display on character initialization reset
	if frame.Visible then
		frame.Visible = false
		openBtn.Visible = true
	end
end

player.CharacterAdded:Connect(setupCharacter)
if player.Character then task.spawn(setupCharacter, player.Character) end

print("✅ Avery's Revamped Auto Spawn Suite Loaded Successfully.")
