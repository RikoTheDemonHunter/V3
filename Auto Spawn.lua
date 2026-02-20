--// SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

--// VARIABLES
local spawn1, spawn2
local activeSpawn
local activeTween

local rainbowActive = false
local etherealActive = false

--// PREMIUM SECURITY (hashed)
local function hashKey(input)
	return string.reverse(input) .. "_SECURE"
end

local storedHash = hashKey("Avery133")
local verified = false
local premiumLocked = false
local premiumAttempts = 0
local premiumLockSeconds = 300

--// GUI SETUP
local gui = Instance.new("ScreenGui")
gui.Name = "SpawnPointGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.35,0,0.6,0)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
frame.Visible = false
frame.Parent = gui

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)



-- Smart scaling
local scale = Instance.new("UIScale", frame)

local function applyResponsiveSize()

	local camera = workspace.CurrentCamera
	if not camera then return end
	
	local viewport = camera.ViewportSize
	local width = viewport.X
	local height = viewport.Y
	
	-- Desktop Large
	if width >= 1600 then
		frame.Size = UDim2.new(0, 550, 0, 650)
		
	-- Desktop Normal
	elseif width >= 1200 then
		frame.Size = UDim2.new(0, 500, 0, 600)
		
	-- Small Laptop
	elseif width >= 900 then
		frame.Size = UDim2.new(0, 440, 0, 540)
		
	-- Tablet
	elseif width >= 700 then
		frame.Size = UDim2.new(0, 400, 0, 500)
		
	-- Mobile
	else
		frame.Size = UDim2.new(0, 340, 0, 480)
	end
	
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
end

applyResponsiveSize()
workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(applyResponsiveSize)

-- Blur
local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "Avery's Auto Spawn"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Parent = frame

--// BUTTON CONTAINER
local buttonContainer = Instance.new("ScrollingFrame")
buttonContainer.Size = UDim2.new(1,-20,1,-80)
buttonContainer.Position = UDim2.new(0,10,0,60)
buttonContainer.ScrollBarThickness = 6
buttonContainer.CanvasSize = UDim2.new(0,0,0,0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = frame

local layout = Instance.new("UIListLayout", buttonContainer)
layout.Padding = UDim.new(0,8)

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	buttonContainer.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end)

--// BUTTON CREATOR
local function createButton(text)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1,0,0,38)
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255,255,255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.Parent = buttonContainer
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(85,85,85)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(60,60,60)}):Play()
	end)

	return btn
end

--// BUTTONS
local set1 = createButton("Set Spawn 1")
local set2 = createButton("Set Spawn 2")
local use1 = createButton("Use Spawn 1")
local use2 = createButton("Use Spawn 2")
local tp1 = createButton("Teleport Spawn 1")
local tp2 = createButton("Teleport Spawn 2")
local clearBtn = createButton("Clear Active")
local themeBtn = createButton("Toggle Rainbow")
local premiumBtn = createButton("Premium Themes")

--// OPEN BUTTON
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0,160,0,45)
openBtn.Position = UDim2.new(0,20,0.8,0)
openBtn.Text = "Open Spawn Menu"
openBtn.BackgroundColor3 = Color3.fromRGB(40,180,40)
openBtn.TextColor3 = Color3.new(1,1,1)
openBtn.Font = Enum.Font.GothamBold
openBtn.TextSize = 16
openBtn.Parent = gui
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0,10)

--// OPEN/CLOSE ANIMATION
local function openMenu()
	frame.Visible = true
	frame.Size = UDim2.new(0,0,0,0)
	TweenService:Create(blur,TweenInfo.new(0.25),{Size=15}):Play()
	TweenService:Create(frame,TweenInfo.new(0.3,Enum.EasingStyle.Back),{
		Size = UDim2.new(0.35,0,0.6,0)
	}):Play()
end

local function closeMenu()
	TweenService:Create(blur,TweenInfo.new(0.2),{Size=0}):Play()
	local tween = TweenService:Create(frame,TweenInfo.new(0.2),{
		Size = UDim2.new(0,0,0,0)
	})
	tween:Play()
	tween.Completed:Wait()
	frame.Visible = false
end

openBtn.MouseButton1Click:Connect(openMenu)

--// SPAWN LOGIC
set1.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn1 = player.Character.HumanoidRootPart.CFrame
	end
end)

set2.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		spawn2 = player.Character.HumanoidRootPart.CFrame
	end
end)

use1.MouseButton1Click:Connect(function() activeSpawn = spawn1 end)
use2.MouseButton1Click:Connect(function() activeSpawn = spawn2 end)

tp1.MouseButton1Click:Connect(function()
	if spawn1 and player.Character then
		player.Character:WaitForChild("HumanoidRootPart").CFrame = spawn1
	end
end)

tp2.MouseButton1Click:Connect(function()
	if spawn2 and player.Character then
		player.Character:WaitForChild("HumanoidRootPart").CFrame = spawn2
	end
end)

clearBtn.MouseButton1Click:Connect(function()
	activeSpawn = nil
	if activeTween then activeTween:Cancel() end
end)

--// RAINBOW
themeBtn.MouseButton1Click:Connect(function()
	rainbowActive = not rainbowActive
	etherealActive = false
end)

RunService.RenderStepped:Connect(function()
	if rainbowActive then
		frame.BackgroundColor3 = Color3.fromHSV((tick()%5)/5,0.7,1)
	elseif etherealActive then
		frame.BackgroundColor3 = Color3.fromHSV((tick()%1),0.4,0.95)
	end
end)

--// PREMIUM
premiumBtn.MouseButton1Click:Connect(function()
	if premiumLocked then return end

	if not verified then
		local box = Instance.new("TextBox")
		box.Size = UDim2.new(1,-20,0,40)
		box.BackgroundColor3 = Color3.fromRGB(50,50,50)
		box.PlaceholderText = "Enter Premium Key"
		box.TextColor3 = Color3.new(1,1,1)
		box.Parent = buttonContainer
		Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)

		box.FocusLost:Connect(function(enter)
			if not enter then return end
			if hashKey(box.Text) == storedHash then
				verified = true
				etherealActive = true
				rainbowActive = false
				box:Destroy()
			else
				premiumAttempts += 1
				box.Text = ""
				box.PlaceholderText = "Invalid Key"
				if premiumAttempts >= 3 then
					premiumLocked = true
					box:Destroy()
					task.delay(premiumLockSeconds,function()
						premiumLocked = false
						premiumAttempts = 0
					end)
				end
			end
		end)
	else
		etherealActive = not etherealActive
		rainbowActive = false
	end
end)

--// AUTO SPAWN ON RESPAWN
player.CharacterAdded:Connect(function(char)
	local hrp = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:WaitForChild("Humanoid")
	task.wait(0.4)

	if activeSpawn then
		local tween = TweenService:Create(hrp,TweenInfo.new(0.25),{CFrame=activeSpawn})
		activeTween = tween
		tween:Play()

		RunService.RenderStepped:Connect(function()
			if humanoid.MoveDirection.Magnitude > 0 then
				tween:Cancel()
			end
		end)
	end
end)
