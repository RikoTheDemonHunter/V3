--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local GuiService = game:GetService("GuiService")

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "MobileStatsHub"
ScreenGui.ResetOnSpawn = false

--// Main Frame
local Main = Instance.new("Frame", ScreenGui)
local screenSize = GuiService:GetScreenResolution()
Main.Size = UDim2.new(0, math.clamp(screenSize.X*0.45, 250, 400), 0, 140)
Main.Position = UDim2.new(0.5, -Main.Size.X.Offset/2, 0.05, 0)
Main.BackgroundColor3 = Color3.fromRGB(35,35,35)
Main.ClipsDescendants = true
local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

-- Title Bar
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(45,45,45)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "⚡Mobile Stats Hub⚡"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.FredokaOne
Title.TextScaled = true

-- Close Button
local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.Size = UDim2.new(0,25,0,25)
CloseButton.Position = UDim2.new(1,-30,0,5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255,0,0)
CloseButton.BackgroundTransparency = 1
CloseButton.Font = Enum.Font.FredokaOne
CloseButton.TextScaled = true

-- Minimize Button
local MinButton = Instance.new("TextButton", TitleBar)
MinButton.Size = UDim2.new(0,25,0,25)
MinButton.Position = UDim2.new(1,-60,0,5)
MinButton.Text = "_"
MinButton.TextColor3 = Color3.fromRGB(0,255,0)
MinButton.BackgroundTransparency = 1
MinButton.Font = Enum.Font.FredokaOne
MinButton.TextScaled = true

-- Content Frame
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1,-10,1,-45)
Content.Position = UDim2.new(0,5,0,40)
Content.BackgroundTransparency = 1

-- Battery (Simulated)
local BatteryBG = Instance.new("Frame", Content)
BatteryBG.Size = UDim2.new(1,0,0,25)
BatteryBG.Position = UDim2.new(0,0,0,0)
BatteryBG.BackgroundColor3 = Color3.fromRGB(55,55,55)
BatteryBG.BorderSizePixel = 0
BatteryBG.ClipsDescendants = true

local BatteryBar = Instance.new("Frame", BatteryBG)
BatteryBar.Size = UDim2.new(0,0,1,0)
BatteryBar.BackgroundColor3 = Color3.fromRGB(0,255,0)

local BatteryLabel = Instance.new("TextLabel", BatteryBG)
BatteryLabel.Size = UDim2.new(1,0,1,0)
BatteryLabel.BackgroundTransparency = 1
BatteryLabel.TextColor3 = Color3.fromRGB(255,255,255)
BatteryLabel.Font = Enum.Font.FredokaOne
BatteryLabel.TextScaled = true
BatteryLabel.Text = "Battery: 100%"

-- Ping
local PingBG = Instance.new("Frame", Content)
PingBG.Size = UDim2.new(1,0,0,25)
PingBG.Position = UDim2.new(0,0,0,35)
PingBG.BackgroundColor3 = Color3.fromRGB(55,55,55)
PingBG.BorderSizePixel = 0
PingBG.ClipsDescendants = true

local PingBar = Instance.new("Frame", PingBG)
PingBar.Size = UDim2.new(0,0,1,0)
PingBar.BackgroundColor3 = Color3.fromRGB(0,255,255)

local PingLabel = Instance.new("TextLabel", PingBG)
PingLabel.Size = UDim2.new(1,0,1,0)
PingLabel.BackgroundTransparency = 1
PingLabel.TextColor3 = Color3.fromRGB(255,255,255)
PingLabel.Font = Enum.Font.FredokaOne
PingLabel.TextScaled = true
PingLabel.Text = "Ping: 0ms"

-- Draggable
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TitleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

TitleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

-- Close & Minimize
CloseButton.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

MinButton.MouseButton1Click:Connect(function()
	Content.Visible = not Content.Visible
	local size = Content.Visible and UDim2.new(0, Main.Size.X.Offset, 0, Main.Size.Y.Offset) or UDim2.new(0, Main.Size.X.Offset, 0, 35)
	TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = size}):Play()
end)

-- Update Stats
local batteryPercent = 100
local batteryDirection = -1
local pingAccumulator = 0
local pingCount = 0
local lastPing = 0

RunService.RenderStepped:Connect(function(dt)
	-- Battery Simulation
	batteryPercent = batteryPercent + batteryDirection
	if batteryPercent <= 20 then batteryDirection = 1 end
	if batteryPercent >= 100 then batteryDirection = -1 end
	BatteryLabel.Text = "Battery: "..batteryPercent.."%"
	TweenService:Create(BatteryBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(batteryPercent/100,0,1,0)}):Play()
	BatteryBar.BackgroundColor3 = Color3.fromHSV(batteryPercent/100*0.3,1,1)

	-- Ping Simulation
	pingAccumulator = pingAccumulator + dt
	pingCount = pingCount + 1
	if pingCount >= 30 then
		lastPing = math.random(30,120) -- random ping between 30-120ms
		PingLabel.Text = "Ping: "..lastPing.."ms"
		local pingPercent = math.clamp(1 - (lastPing/300),0,1)
		TweenService:Create(PingBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(pingPercent,0,1,0)}):Play()
		PingBar.BackgroundColor3 = Color3.fromHSV(pingPercent*0.4,1,1)
		pingAccumulator = 0
		pingCount = 0
	end
end)
