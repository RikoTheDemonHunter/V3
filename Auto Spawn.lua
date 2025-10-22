-- Avery's Advanced Auto Spawn GUI (Fixed Full Version)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer

-- Variables
local spawn1, spawn2 = nil, nil
local activeSpawn = nil
local activeTween = nil

-- GUI Setup
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

-- Button creator
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
openBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
openBtn.Visible = false
openBtn.Active = true
openBtn.Draggable = true
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.Parent = gui
local cornerOpen = Instance.new("UICorner")
cornerOpen.CornerRadius = UDim.new(0, 8)
cornerOpen.Parent = openBtn

openBtn.MouseButton1Click:Connect(function()
	frame.Visible = true
	openBtn.Visible = false
end)
closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	openBtn.Visible = true
end)

-- Spawn button functions (fixed flash + indicator)
set1.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn1 = player.Character.HumanoidRootPart.CFrame
		updateIndicator()
		flash(Color3.fromRGB(0,255,0))
	end
end)
set2.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn2 = player.Character.HumanoidRootPart.CFrame
		updateIndicator()
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
	buttonContainer.Visible = not buttonContainer.Visible
	indicator.Visible = not indicator.Visible
end)

-- Themes
local Themes = {
	["Light"]={BG=Color3.fromRGB(240,240,240),Text=Color3.fromRGB(0,0,0)},
	["Dark"]={BG=Color3.fromRGB(20,20,20),Text=Color3.fromRGB(255,255,255)},
	["Emerald"]={BG=Color3.fromRGB(25,60,45),Text=Color3.fromRGB(200,255,210)},
	["Light Blue"]={BG=Color3.fromRGB(210,235,255),Text=Color3.fromRGB(0,30,60)},
	["Mint"]={BG=Color3.fromRGB(200,255,230),Text=Color3.fromRGB(20,50,40)},
	["Sunset"]={BG=Color3.fromRGB(255,200,150),Text=Color3.fromRGB(50,20,10)},
	["Rainbow"]={}
}
local themeNames = {"Light","Dark","Emerald","Rainbow","Light Blue","Mint","Sunset"}
local themeIndex = 1
local rainbowActive = false

local function applyTheme(theme)
	if theme=="Rainbow" then
		rainbowActive=true
	else
		rainbowActive=false
		local t=Themes[theme]
		frame.BackgroundColor3=t.BG
		title.TextColor3=t.Text
		buttonContainer.BackgroundColor3=t.BG
	end
end

themeBtn.MouseButton1Click:Connect(function()
	themeIndex=themeIndex+1
	if themeIndex>#themeNames then themeIndex=1 end
	applyTheme(themeNames[themeIndex])
end)

RunService.RenderStepped:Connect(function()
	if rainbowActive then
		local t=tick()*0.2
		frame.BackgroundColor3=Color3.fromRGB(
			math.sin(t)*127+128,
			math.sin(t+2)*127+128,
			math.sin(t+4)*127+128
		)
	end
end)

-- Premium Section
local premiumFrame = Instance.new("Frame")
premiumFrame.Size=UDim2.new(1,0,1,0)
premiumFrame.Position=UDim2.new(0,0,0,0)
premiumFrame.BackgroundColor3=Color3.fromRGB(25,25,25)
premiumFrame.Visible=false
premiumFrame.Parent=frame
local premiumCorner=Instance.new("UICorner")
premiumCorner.CornerRadius=UDim.new(0,12)
premiumCorner.Parent=premiumFrame

local backArrow = Instance.new("TextButton")
backArrow.Size=UDim2.new(0,35,0,25)
backArrow.Position=UDim2.new(0,10,0,10)
backArrow.Text="<"
backArrow.TextColor3=Color3.fromRGB(255,255,255)
backArrow.BackgroundColor3=Color3.fromRGB(50,50,50)
backArrow.Font=Enum.Font.GothamBold
backArrow.TextSize=20
backArrow.Parent=premiumFrame
local backCorner=Instance.new("UICorner")
backCorner.CornerRadius=UDim.new(0,6)
backCorner.Parent=backArrow

backArrow.MouseButton1Click:Connect(function()
	premiumFrame.Visible=false
end)

local premiumScroll=Instance.new("ScrollingFrame")
premiumScroll.Size=UDim2.new(1,-10,1,-50)
premiumScroll.Position=UDim2.new(0,5,0,40)
premiumScroll.CanvasSize=UDim2.new(0,0,0,500)
premiumScroll.ScrollBarThickness=6
premiumScroll.BackgroundTransparency=1
premiumScroll.Parent=premiumFrame

local premiumThemes={
	["Neo"]=Color3.fromRGB(180,0,255),
	["Cyber"]=Color3.fromRGB(0,180,255),
	["Aurora"]=Color3.fromRGB(0,255,200),
	["Volta"]=Color3.fromRGB(255,50,50),
	["Luminous"]=Color3.fromRGB(255,255,100)
}
local yPos=0
for name,color in pairs(premiumThemes) do
	local btn=createButton(name.." Theme",yPos,premiumScroll)
	btn.BackgroundColor3=color
	btn.MouseButton1Click:Connect(function()
		frame.BackgroundColor3=color
	end)
	yPos=yPos+45
end

-- Premium key logic
local premiumKey="Avery133"
local verified=false
premiumBtn.MouseButton1Click:Connect(function()
	if not verified then
		local keyPrompt=Instance.new("TextBox")
		keyPrompt.Size=UDim2.new(0.9,0,0,40)
		keyPrompt.Position=UDim2.new(0.05,0,0,160)
		keyPrompt.PlaceholderText="Enter Key..."
		keyPrompt.BackgroundColor3=Color3.fromRGB(50,50,50)
		keyPrompt.TextColor3=Color3.fromRGB(255,255,255)
		keyPrompt.Font=Enum.Font.Gotham
		keyPrompt.TextSize=16
		keyPrompt.Parent=frame

		local cornerKey=Instance.new("UICorner")
		cornerKey.CornerRadius=UDim.new(0,6)
		cornerKey.Parent=keyPrompt

		keyPrompt.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				if keyPrompt.Text==premiumKey then
					verified=true
					keyPrompt:Destroy()
					premiumFrame.Visible=true
				else
					keyPrompt.PlaceholderText="Invalid Key"
					keyPrompt.Text=""
				end
			end
		end)
	else
		premiumFrame.Visible=not premiumFrame.Visible
	end
end)

-- Auto-spawn logic
player.CharacterAdded:Connect(function(char)
	local hrp=char:WaitForChild("HumanoidRootPart")
	local humanoid=char:FindFirstChild("Humanoid")
	task.wait(0.5)
	if activeSpawn and hrp then
		local tweenInfo=TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
		local tweenGoal={CFrame=activeSpawn}
		local tween=TweenService:Create(hrp,tweenInfo,tweenGoal)
		activeTween=tween

		local conn
		conn=RunService.RenderStepped:Connect(function()
			if humanoid and humanoid.MoveDirection.Magnitude>0 then
				tween:Cancel()
				conn:Disconnect()
				activeTween=nil
			elseif not activeSpawn then
				tween:Cancel()
				conn:Disconnect()
				activeTween=nil
			end
		end)

		tween:Play()
		tween.Completed:Connect(function()
			if conn then conn:Disconnect() end
			activeTween=nil
		end)
	end
end)

print("✅ AUTO Spawn Loaded to access premium key you need to ask avery on discord!")
print("DISCORD USERNAME: 90averyxx")
print("This is officially made on visual studio tryting to copy this script will result in a copyright strike!")
