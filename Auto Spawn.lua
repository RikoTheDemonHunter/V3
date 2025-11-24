local types = {
    "[INFO]",
    "[SYSTEM]",
    "[WARNING]",
    "[DEBUG]",
    "[NOTICE]",
    "[ALERT]"
}

local function randomType()
    return types[math.random(1, #types)]
end

local function randomIP()
    local function part()
        return math.random(0, 255)
    end
    return part().."."..part().."."..part().."."..part()
end

print(randomType() .. " Generated IP: " .. randomIP())

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- Variables
local spawn1, spawn2 = nil, nil
local activeSpawn = nil
local activeTween = nil

-- Premium attempt & lock variables
local premiumKey = "Avery133"
local premiumAttempts = 0
local premiumLocked = false
local premiumLockSeconds = 300 -- 5 minutes
local premiumLockTimer = nil

-- Ethereal animation control
local etherealActive = false
local etherealTicker = 0

-- GUI Setup (same visual layout you requested)
local gui = Instance.new("ScreenGui")
gui.Name = "SpawnPointGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 280, 0, 360)
frame.Position = UDim2.new(0.5, -140, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
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

-- Flash effect
local function flash(color)
	local flashFrame = Instance.new("Frame")
	flashFrame.Size = UDim2.new(1, 0, 1, 0)
	flashFrame.BackgroundColor3 = color
	flashFrame.BackgroundTransparency = 0.5
	flashFrame.ZIndex = 10
	flashFrame.Parent = frame
	TweenService:Create(flashFrame, TweenInfo.new(0.25), {BackgroundTransparency = 1}):Play()
	Debris:AddItem(flashFrame, 0.25)
end

-- Update active spawn indicator
local function updateIndicator()
	if activeSpawn == spawn1 then
		indicator.Text = "Active: Spawn 1"
	elseif activeSpawn == spawn2 then
		indicator.Text = "Active: Spawn 2"
	else
		indicator.Text = "Active: None"
	end
end

-- Button container
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1, -10, 0, 210)
buttonContainer.Position = UDim2.new(0, 5, 0, 70)
buttonContainer.CanvasSize = UDim2.new(0, 0, 0, 280)
buttonContainer.ScrollBarThickness = 6
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

-- Button creator (keeps original visual)
local function createButton(text, posY, parent)
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

	btn.Parent = parent
	-- optional hover visual polish (no layout change)
	btn.MouseEnter:Connect(function()
		pcall(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(80, 80, 80)}):Play()
		end)
	end)
	btn.MouseLeave:Connect(function()
		pcall(function()
			TweenService:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
		end)
	end)

	return btn
end

-- Main buttons
local set1 = createButton("Set Spawn 1", 0, buttonContainer)
local set2 = createButton("Set Spawn 2", 35, buttonContainer)
local use1 = createButton("Use Spawn 1", 70, buttonContainer)
local use2 = createButton("Use Spawn 2", 105, buttonContainer)
local tp1 = createButton("Teleport to Spawn 1", 140, buttonContainer)
local tp2 = createButton("Teleport to Spawn 2", 175, buttonContainer)
local clearBtn = createButton("Clear Active Spawn", 210, buttonContainer)
local themeBtn = createButton("Change Theme", 245, buttonContainer)
local premiumBtn = createButton("Premium Themes", 280, buttonContainer)

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
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 5)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundColor3 = Color3.fromRGB(120, 50, 50)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = frame
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 140, 0, 40)
openBtn.Position = UDim2.new(0, 15, 0.8, 0)
openBtn.Text = "Open Spawn Menu"
openBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
openBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
openBtn.Visible = false
openBtn.Active = true
openBtn.Draggable = true
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

-- Spawn button functions
set1.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn1 = player.Character.HumanoidRootPart.CFrame
		updateIndicator()
		flash(Color3.fromRGB(0, 255, 0))
	end
end)
set2.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn2 = player.Character.HumanoidRootPart.CFrame
		updateIndicator()
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
	if activeTween then
		activeTween:Cancel()
		activeTween = nil
	end
	updateIndicator()
	flash(Color3.fromRGB(255, 0, 0))
end)

minimizeBtn.MouseButton1Click:Connect(function()
	local state = not buttonContainer.Visible
	buttonContainer.Visible = state
	indicator.Visible = state
end)

-- Themes
local Themes = {
	["Light"] = {BG = Color3.fromRGB(240, 240, 240), Text = Color3.fromRGB(0, 0, 0)},
	["Dark"] = {BG = Color3.fromRGB(20, 20, 20), Text = Color3.fromRGB(255, 255, 255)},
	["Emerald"] = {BG = Color3.fromRGB(25, 60, 45), Text = Color3.fromRGB(200, 255, 210)},
	["Light Blue"] = {BG = Color3.fromRGB(210, 235, 255), Text = Color3.fromRGB(0, 30, 60)},
	["Mint"] = {BG = Color3.fromRGB(200, 255, 230), Text = Color3.fromRGB(20, 50, 40)},
	["Sunset"] = {BG = Color3.fromRGB(255, 200, 150), Text = Color3.fromRGB(50, 20, 10)},
	["Rainbow"] = {}
}
local themeNames = {"Light", "Dark", "Emerald", "Rainbow", "Light Blue", "Mint", "Sunset"}
local themeIndex = 1
local rainbowActive = false

local function applyTheme(theme)
	-- reset ethereal state if theme changed
	etherealActive = false

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

themeBtn.MouseButton1Click:Connect(function()
	themeIndex += 1
	if themeIndex > #themeNames then themeIndex = 1 end
	applyTheme(themeNames[themeIndex])
end)

RunService.RenderStepped:Connect(function(delta)
	-- rainbow animation
	if rainbowActive then
		local t = tick() * 1.5
		frame.BackgroundColor3 = Color3.fromRGB(
			math.floor((math.sin(t) * 127) + 128),
			math.floor((math.sin(t + 2) * 127) + 128),
			math.floor((math.sin(t + 4) * 127) + 128)
		)
	end

	-- Ethereal animation (only active when Ethereal is selected)
	if etherealActive then
		etherealTicker = etherealTicker + (delta or 0.016)
		-- Color cycle via HSV for smooth gradient
		local hue = (etherealTicker * 0.06) % 1
		local c = Color3.fromHSV(hue, 0.6, 0.9)
		frame.BackgroundColor3 = c
	end
end)

-- Premium Section (expanded themes + Ethereal)
local premiumFrame = Instance.new("Frame")
premiumFrame.Size = UDim2.new(1, 0, 1, 0)
premiumFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
premiumFrame.Visible = false
premiumFrame.Parent = frame
Instance.new("UICorner", premiumFrame).CornerRadius = UDim.new(0, 12)

local backArrow = Instance.new("TextButton")
backArrow.Size = UDim2.new(0, 35, 0, 25)
backArrow.Position = UDim2.new(0, 10, 0, 10)
backArrow.Text = "<"
backArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
backArrow.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
backArrow.Font = Enum.Font.GothamBold
backArrow.TextSize = 20
backArrow.Parent = premiumFrame
Instance.new("UICorner", backArrow).CornerRadius = UDim.new(0, 6)

backArrow.MouseButton1Click:Connect(function()
	premiumFrame.Visible = false
end)

local premiumScroll = Instance.new("ScrollingFrame")
premiumScroll.Size = UDim2.new(1, -10, 1, -50)
premiumScroll.Position = UDim2.new(0, 5, 0, 40)
premiumScroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
premiumScroll.ScrollBarThickness = 6
premiumScroll.BackgroundTransparency = 1
premiumScroll.Parent = premiumFrame

-- Premium themes table (original + added ones; Ethereal is last and animated)
local premiumThemes = {
	["Neo"] = Color3.fromRGB(180, 0, 255),
	["Cyber"] = Color3.fromRGB(0, 180, 255),
	["Aurora"] = Color3.fromRGB(0, 255, 200),
	["Volta"] = Color3.fromRGB(255, 50, 50),
	["Luminous"] = Color3.fromRGB(255, 255, 100),
	["Plasma"] = Color3.fromRGB(220, 0, 180),
	["Inferno"] = Color3.fromRGB(255, 120, 0),
	["Void"] = Color3.fromRGB(18, 10, 38),
	["Arctic"] = Color3.fromRGB(180, 230, 255),
	["Sakura"] = Color3.fromRGB(255, 180, 200),
	["Ethereal"] = Color3.fromRGB(120, 80, 220) -- placeholder base color; this one animated
}

-- Build premium buttons
local yPos = 0
for name, color in pairs(premiumThemes) do
	local btn = createButton(name .. " Theme", yPos, premiumScroll)
	btn.BackgroundColor3 = color
	btn.LayoutOrder = yPos
	-- clicking a premium theme applies it (Ethereal will animate)
	btn.MouseButton1Click:Connect(function()
		-- If premium section locked, ignore theme clicks
		if premiumLocked then return end

		if name == "Ethereal" then
			etherealActive = true
			-- initial frame color set; animation will take over
			frame.BackgroundColor3 = color
		else
			etherealActive = false
			frame.BackgroundColor3 = color
		end
		-- keep title text white for readability
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
	yPos += 45
end

-- Helper: show in-theme warning GUI (2nd failed attempt)
local function showWarningPopup()
	-- avoid multiple warnings
	if gui:FindFirstChild("PremiumWarn") then return end

	local warn = Instance.new("Frame")
	warn.Name = "PremiumWarn"
	warn.Size = UDim2.new(0, 260, 0, 110)
	warn.Position = UDim2.new(0.5, -130, 0.5, -55)
	warn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
	warn.ZIndex = 50
	warn.Parent = gui
	Instance.new("UICorner", warn).CornerRadius = UDim.new(0, 10)

	local txt = Instance.new("TextLabel")
	txt.Size = UDim2.new(1, -20, 1, -20)
	txt.Position = UDim2.new(0, 10, 0, 10)
	txt.BackgroundTransparency = 1
	txt.Font = Enum.Font.GothamBold
	txt.TextSize = 14
	txt.TextColor3 = Color3.fromRGB(255, 220, 120)
	txt.Text = "⚠️ This is your last attempt.\nEnter the correct key or you will be locked out for 5 minutes."
	txt.TextWrapped = true
	txt.TextYAlignment = Enum.TextYAlignment.Center
	txt.Parent = warn

	-- animate in and auto-destroy after 4 seconds
	warn.BackgroundTransparency = 1
	local tweenIn = TweenService:Create(warn, TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
	tweenIn:Play()
	task.delay(4, function()
		if warn and warn.Parent then
			local tweenOut = TweenService:Create(warn, TweenInfo.new(0.14, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1})
			tweenOut:Play()
			task.delay(0.16, function()
				if warn then warn:Destroy() end
			end)
		end
	end)
end

-- Helper: show temporary feedback message inside frame (small)
local function showFrameMessage(message, color)
	-- create small label at bottom of frame
	if frame:FindFirstChild("TempMsg") then frame.TempMsg:Destroy() end
	local msg = Instance.new("TextLabel")
	msg.Name = "TempMsg"
	msg.Size = UDim2.new(1, -20, 0, 30)
	msg.Position = UDim2.new(0, 10, 1, -40)
	msg.BackgroundTransparency = 1
	msg.Text = message
	msg.Font = Enum.Font.Gotham
	msg.TextSize = 14
	msg.TextColor3 = color or Color3.fromRGB(255, 255, 255)
	msg.Parent = frame
	Debris:AddItem(msg, 3)
end

-- Lock premium UI (on 3rd fail) — disables premium access for premiumLockSeconds
local function lockPremium()
	if premiumLocked then return end
	premiumLocked = true
	premiumAttempts = 0 -- reset attempts, lock does the rest

	-- Visual: disable premium button & show timer label on it
	local originalText = premiumBtn.Text
	local originalBG = premiumBtn.BackgroundColor3
	premiumBtn.AutoButtonColor = false
	premiumBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	premiumBtn.Text = "Premium Locked (05:00)"
	showFrameMessage("Premium locked for 5 minutes due to repeated wrong keys.", Color3.fromRGB(255, 140, 140))

	-- Disable opening the premium frame while locked
	if premiumFrame.Visible then premiumFrame.Visible = false end

	-- countdown coroutine
	local remaining = premiumLockSeconds
	premiumLockTimer = task.spawn(function()
		while remaining > 0 do
			local mins = math.floor(remaining / 60)
			local secs = remaining % 60
			local fmt = string.format("%02d:%02d", mins, secs)
			premiumBtn.Text = "Premium Locked (" .. fmt .. ")"
			task.wait(1)
			remaining = remaining - 1
		end

		-- unlock
		premiumLocked = false
		premiumBtn.AutoButtonColor = true
		premiumBtn.BackgroundColor3 = originalBG
		premiumBtn.Text = originalText
		showFrameMessage("Premium unlocked — you may try the key again.", Color3.fromRGB(160, 255, 160))
	end)
end

-- Premium key logic (clicking premiumBtn asks for key unless verified or locked)
local verified = false
premiumBtn.MouseButton1Click:Connect(function()
	if premiumLocked then
		showFrameMessage("Premium currently locked. Wait for the timer to finish.", Color3.fromRGB(255, 180, 120))
		return
	end

	if not verified then
		-- avoid multiple prompts
		if frame:FindFirstChild("KeyPrompt") then return end

		local keyPrompt = Instance.new("TextBox")
		keyPrompt.Name = "KeyPrompt"
		keyPrompt.Size = UDim2.new(0.9, 0, 0, 40)
		keyPrompt.Position = UDim2.new(0.05, 0, 0, 160)
		keyPrompt.PlaceholderText = "Enter Key..."
		keyPrompt.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		keyPrompt.TextColor3 = Color3.fromRGB(255, 255, 255)
		keyPrompt.Font = Enum.Font.Gotham
		keyPrompt.TextSize = 16
		keyPrompt.Parent = frame
		Instance.new("UICorner", keyPrompt).CornerRadius = UDim.new(0, 6)

		keyPrompt.FocusLost:Connect(function(enterPressed)
			if not enterPressed then return end
			local entered = keyPrompt.Text or ""
			if entered == premiumKey then
				verified = true
				keyPrompt:Destroy()
				premiumFrame.Visible = true
				showFrameMessage("Premium unlocked — enjoy the themes!", Color3.fromRGB(160, 255, 160))
				premiumAttempts = 0
			else
				-- wrong attempt
				premiumAttempts += 1
				-- first fail: change placeholder & small msg
				if premiumAttempts == 1 then
					keyPrompt.Text = ""
					keyPrompt.PlaceholderText = "Invalid Key"
					showFrameMessage("Invalid key. Try again.", Color3.fromRGB(255, 200, 120))
				elseif premiumAttempts == 2 then
					-- second fail: warning popup
					keyPrompt.Text = ""
					keyPrompt.PlaceholderText = "Invalid Key"
					showWarningPopup()
					showFrameMessage("Last attempt — be careful.", Color3.fromRGB(255, 180, 80))
				elseif premiumAttempts >= 3 then
					-- third fail: lock premium for 5 minutes (no kick)
					keyPrompt:Destroy()
					showFrameMessage("Too many failed attempts. Premium locked for 5 minutes.", Color3.fromRGB(255, 140, 140))
					lockPremium()
				end
			end
		end)
	else
		-- already verified — toggle premium frame
		premiumFrame.Visible = not premiumFrame.Visible
	end
end)

-- Auto-spawn logic + auto-hide on respawn
player.CharacterAdded:Connect(function(char)
	local hrp = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid") or char:WaitForChild("Humanoid")
	task.wait(0.5)

	if activeSpawn and hrp then
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tweenGoal = {CFrame = activeSpawn}
		local tween = TweenService:Create(hrp, tweenInfo, tweenGoal)
		activeTween = tween

		local conn
		conn = RunService.RenderStepped:Connect(function()
			if humanoid and humanoid.MoveDirection.Magnitude > 0 or (not activeSpawn) then
				pcall(function() tween:Cancel() end)
				if conn then conn:Disconnect() end
				activeTween = nil
			end
		end)

		tween.Completed:Connect(function()
			if conn then conn:Disconnect() end
			activeTween = nil
		end)

		tween:Play()
	end

	-- Auto-hide GUI when respawning
	if frame.Visible then
		frame.Visible = false
		openBtn.Visible = true
	end
end)

print("✅ AUTO Spawn Loaded | Premium key: ask Avery on Discord @90averyxx")
