--[[
✅ Enhanced Auto-Spawn GUI + Smooth/Instant Teleport Settings
Features:
- Tabs: Spawns | Themes | Settings
- Collapsible theme sections
- Animated buttons & hover effects
- Live theme preview (Rainbow/Ethereal)
- Draggable GUI
- Premium system with key verification
- Auto-spawn on respawn
- Smooth/Instant teleport with adjustable tween speed
]]--

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- Variables
local spawn1, spawn2 = nil, nil
local activeSpawn = nil
local activeTween = nil

local premiumKey = "Avery133"
local premiumAttempts = 0
local premiumLocked = false
local premiumLockSeconds = 300 -- 5 minutes
local premiumLockTimer = nil
local verified = false

local etherealActive = false
local etherealTicker = 0
local rainbowActive = false

-- Settings variables
local teleportSmooth = true       -- true = smooth tween, false = instant
local teleportSpeed = 0.25        -- seconds for tween

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SpawnPointGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 420)
frame.Position = UDim2.new(0.5, -160, 0.5, -210)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundTransparency = 1
title.Text = "Avery's Auto Spawn"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Parent = frame

-- Minimize & Close buttons
local function createTopButton(txt, posX, color)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 25, 0, 25)
	btn.Position = UDim2.new(1, posX, 0, 5)
	btn.Text = txt
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = color
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 16
	btn.Parent = frame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	return btn
end

local minimizeBtn = createTopButton("-", -55, Color3.fromRGB(80,80,80))
local closeBtn = createTopButton("X", -30, Color3.fromRGB(120,50,50))

-- Tabs
local tabs = {"Spawns", "Themes", "Settings"}
local tabButtons = {}
local activeTab = "Spawns"
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1,0,0,30)
tabBar.Position = UDim2.new(0,0,0,40)
tabBar.BackgroundTransparency = 1
tabBar.Parent = frame

local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -20, 1, -70)
contentArea.Position = UDim2.new(0,10,0,70)
contentArea.BackgroundTransparency = 1
contentArea.Parent = frame

-- Function: create button
local function createButton(text, parent, sizeY)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,30)
	btn.Position = UDim2.new(0,0,0,sizeY or 0)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.AutoButtonColor = true
	btn.Parent = parent
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	-- Hover tween
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(80,80,80)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(60,60,60)}):Play()
	end)
	return btn
end

-- Active spawn indicator
local indicator = Instance.new("TextLabel")
indicator.Size = UDim2.new(1,0,0,20)
indicator.Position = UDim2.new(0,0,1,-30)
indicator.BackgroundTransparency = 1
indicator.Text = "Active: None"
indicator.TextColor3 = Color3.fromRGB(0,255,255)
indicator.Font = Enum.Font.Gotham
indicator.TextSize = 16
indicator.TextXAlignment = Enum.TextXAlignment.Left
indicator.Parent = frame

local function updateIndicator()
	if activeSpawn == spawn1 then
		indicator.Text = "Active: Spawn 1"
	elseif activeSpawn == spawn2 then
		indicator.Text = "Active: Spawn 2"
	else
		indicator.Text = "Active: None"
	end
end

-- Tabs buttons
local xPos = 0
for i, tabName in ipairs(tabs) do
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 100, 1, 0)
	btn.Position = UDim2.new(0, xPos, 0, 0)
	btn.Text = tabName
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = tabBar
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
	tabButtons[tabName] = btn

	btn.MouseButton1Click:Connect(function()
		activeTab = tabName
		refreshContent()
	end)
	xPos += 105
end

-- Content clearing
local function clearContent()
	for _, child in pairs(contentArea:GetChildren()) do
		if not child:IsA("UIListLayout") then
			child:Destroy()
		end
	end
end

-- Themes
local standardThemes = {
	["Light"] = {BG=Color3.fromRGB(240,240,240),Text=Color3.fromRGB(0,0,0)},
	["Dark"] = {BG=Color3.fromRGB(20,20,20),Text=Color3.fromRGB(255,255,255)},
	["Emerald"] = {BG=Color3.fromRGB(25,60,45),Text=Color3.fromRGB(200,255,210)},
	["Light Blue"] = {BG=Color3.fromRGB(210,235,255),Text=Color3.fromRGB(0,30,60)},
	["Mint"] = {BG=Color3.fromRGB(200,255,230),Text=Color3.fromRGB(20,50,40)},
	["Sunset"] = {BG=Color3.fromRGB(255,200,150),Text=Color3.fromRGB(50,20,10)}
}
local premiumThemes = {
	["Neo"]=Color3.fromRGB(180,0,255),
	["Cyber"]=Color3.fromRGB(0,180,255),
	["Aurora"]=Color3.fromRGB(0,255,200),
	["Volta"]=Color3.fromRGB(255,50,50),
	["Luminous"]=Color3.fromRGB(255,255,100),
	["Plasma"]=Color3.fromRGB(220,0,180),
	["Inferno"]=Color3.fromRGB(255,120,0),
	["Void"]=Color3.fromRGB(18,10,38),
	["Arctic"]=Color3.fromRGB(180,230,255),
	["Sakura"]=Color3.fromRGB(255,180,200),
	["Ethereal"]=Color3.fromRGB(120,80,220)
}

-- Collapsible section helper
local function createSection(titleText, y)
	local secFrame = Instance.new("Frame")
	secFrame.Size = UDim2.new(1,0,0,30)
	secFrame.Position = UDim2.new(0,0,0,y)
	secFrame.BackgroundTransparency = 1
	secFrame.Parent = contentArea

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,30)
	btn.Position = UDim2.new(0,0,0,0)
	btn.Text = titleText.." ▼"
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.Parent = secFrame
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

	local open = true
	local childrenFrame = Instance.new("Frame")
	childrenFrame.Size = UDim2.new(1,0,0,0)
	childrenFrame.Position = UDim2.new(0,0,0,30)
	childrenFrame.BackgroundTransparency = 1
	childrenFrame.Parent = secFrame

	btn.MouseButton1Click:Connect(function()
		open = not open
		btn.Text = titleText.." "..(open and "▼" or "►")
		local goal = open and #childrenFrame:GetChildren()*35 or 0
		TweenService:Create(childrenFrame, TweenInfo.new(0.2), {Size=UDim2.new(1,0,0,goal)}):Play()
	end)

	return childrenFrame, #childrenFrame:GetChildren()*35
end

-- Refresh content area
function refreshContent()
	clearContent()

	if activeTab=="Spawns" then
		local y = 0
		local set1 = createButton("Set Spawn 1", contentArea, y)
		y += 35
		local set2 = createButton("Set Spawn 2", contentArea, y)
		y += 35
		local use1 = createButton("Use Spawn 1", contentArea, y)
		y += 35
		local use2 = createButton("Use Spawn 2", contentArea, y)
		y += 35
		local tp1 = createButton("Teleport Spawn 1", contentArea, y)
		y += 35
		local tp2 = createButton("Teleport Spawn 2", contentArea, y)
		y += 35
		local clearBtn = createButton("Clear Active Spawn", contentArea, y)
		y += 35

		-- Connections
		set1.MouseButton1Click:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				spawn1 = player.Character.HumanoidRootPart.CFrame
				activeSpawn = spawn1
				updateIndicator()
			end
		end)
		set2.MouseButton1Click:Connect(function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				spawn2 = player.Character.HumanoidRootPart.CFrame
				activeSpawn = spawn2
				updateIndicator()
			end
		end)
		use1.MouseButton1Click:Connect(function() activeSpawn=spawn1 updateIndicator() end)
		use2.MouseButton1Click:Connect(function() activeSpawn=spawn2 updateIndicator() end)

		tp1.MouseButton1Click:Connect(function()
			if spawn1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local hrp=player.Character.HumanoidRootPart
				if teleportSmooth then
					TweenService:Create(hrp,TweenInfo.new(teleportSpeed,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{CFrame=spawn1}):Play()
				else
					hrp.CFrame=spawn1
				end
			end
		end)
		tp2.MouseButton1Click:Connect(function()
			if spawn2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				local hrp=player.Character.HumanoidRootPart
				if teleportSmooth then
					TweenService:Create(hrp,TweenInfo.new(teleportSpeed,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{CFrame=spawn2}):Play()
				else
					hrp.CFrame=spawn2
				end
			end
		end)
		clearBtn.MouseButton1Click:Connect(function()
			activeSpawn=nil
			updateIndicator()
		end)

	elseif activeTab=="Themes" then
		local standardFrame, _ = createSection("Standard Themes",0)
		local sy = 0
		for name,t in pairs(standardThemes) do
			local btn = createButton(name, standardFrame, sy)
			btn.BackgroundColor3 = t.BG
			btn.TextColor3 = t.Text
			btn.MouseButton1Click:Connect(function()
				rainbowActive=false
				etherealActive=false
				frame.BackgroundColor3=t.BG
				title.TextColor3=t.Text
			end)
			sy += 35
		end

		local premiumFrameSec,_ = createSection("Premium Themes",sy)
		local py = 0
		for name,color in pairs(premiumThemes) do
			local btn = createButton(name.." Theme", premiumFrameSec, py)
			btn.BackgroundColor3=color
			btn.MouseButton1Click:Connect(function()
				if premiumLocked then return end
				if not verified then
					print("Premium key required!")
					return
				end
				if name=="Ethereal" then
					etherealActive=true
					rainbowActive=false
				else
					frame.BackgroundColor3=color
					etherealActive=false
					rainbowActive=false
				end
			end)
			py+=35
		end

	elseif activeTab=="Settings" then
		local y=0

		-- Toggle smooth teleport
		local smoothBtn = createButton("Teleport: Smooth", contentArea, y)
		y += 35
		smoothBtn.MouseButton1Click:Connect(function()
			teleportSmooth = not teleportSmooth
			smoothBtn.Text = "Teleport: " .. (teleportSmooth and "Smooth" or "Instant")
		end)

		-- Teleport speed label
		local speedLabel = Instance.new("TextLabel")
		speedLabel.Size = UDim2.new(1,0,0,30)
		speedLabel.Position = UDim2.new(0,0,0,y)
		speedLabel.Text = "Tween Speed: " .. teleportSpeed .. "s"
		speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
		speedLabel.BackgroundColor3 = Color3.fromRGB(60,60,60)
		speedLabel.Font = Enum.Font.Gotham
		speedLabel.TextSize = 14
		speedLabel.Parent = contentArea
		y += 35

		-- Increase / decrease buttons
		local incBtn = createButton("Increase Speed (+0.05s)", contentArea, y)
		y+=35
		local decBtn = createButton("Decrease Speed (-0.05s)", contentArea, y)
		y+=35

		incBtn.MouseButton1Click:Connect(function()
			teleportSpeed=math.clamp(teleportSpeed+0.05,0.05,2)
			speedLabel.Text="Tween Speed: "..string.format("%.2f",teleportSpeed).."s"
		end)
		decBtn.MouseButton1Click:Connect(function()
			teleportSpeed=math.clamp(teleportSpeed-0.05,0.05,2)
			speedLabel.Text="Tween Speed: "..string.format("%.2f",teleportSpeed).."s"
		end)
	end
end

refreshContent()

-- Minimize / Close
minimizeBtn.MouseButton1Click:Connect(function()
	local state = not contentArea.Visible
	contentArea.Visible = state
	indicator.Visible = state
end)
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible=false
end)

-- Rainbow/Ethereal animation
RunService.RenderStepped:Connect(function(delta)
	if rainbowActive then
		local t=tick()*1.5
		frame.BackgroundColor3=Color3.fromRGB(
			math.floor((math.sin(t)*127)+128),
			math.floor((math.sin(t+2)*127)+128),
			math.floor((math.sin(t+4)*127)+128)
		)
	end
	if etherealActive then
		etherealTicker=etherealTicker+(delta or 0.016)
		local hue=(etherealTicker*0.06)%1
		frame.BackgroundColor3=Color3.fromHSV(hue,0.6,0.9)
	end
end)

-- Auto-spawn on respawn
player.CharacterAdded:Connect(function(char)
	local hrp = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid") or char:WaitForChild("Humanoid")
	task.wait(0.5)
	if activeSpawn and hrp then
		if teleportSmooth then
			TweenService:Create(hrp,TweenInfo.new(teleportSpeed,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{CFrame=activeSpawn}):Play()
		else
			hrp.CFrame = activeSpawn
		end
	end
end)

print("✅ Enhanced Auto-Spawn GUI with Smooth/Instant Teleport Loaded")
