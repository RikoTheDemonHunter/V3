--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

--// ScreenGui
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "DarkLibHub"
ScreenGui.ResetOnSpawn = false

--// Main Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 300, 0, 120)
Main.Position = UDim2.new(0.1, 0, 0.1, 0)
Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Main.ClipsDescendants = true

local UICorner = Instance.new("UICorner", Main)
UICorner.CornerRadius = UDim.new(0, 12)

-- Title Bar
local TitleBar = Instance.new("Frame", Main)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

local Title = Instance.new("TextLabel", TitleBar)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Text = "⚡Mobile Stats Hub⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.FredokaOne
Title.TextScaled = true

-- Close Button
local CloseButton = Instance.new("TextButton", TitleBar)
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(1, -30, 0, 5)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BackgroundTransparency = 1
CloseButton.Font = Enum.Font.FredokaOne
CloseButton.TextScaled = true

-- Minimize Button
local MinButton = Instance.new("TextButton", TitleBar)
MinButton.Size = UDim2.new(0, 25, 0, 25)
MinButton.Position = UDim2.new(1, -60, 0, 5)
MinButton.Text = "_"
MinButton.TextColor3 = Color3.fromRGB(0, 255, 0)
MinButton.BackgroundTransparency = 1
MinButton.Font = Enum.Font.FredokaOne
MinButton.TextScaled = true

-- Content Frame
local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -10, 1, -45)
Content.Position = UDim2.new(0, 5, 0, 40)
Content.BackgroundTransparency = 1

-- Battery bar
local BatteryBarBG = Instance.new("Frame", Content)
BatteryBarBG.Size = UDim2.new(1, 0, 0, 20)
BatteryBarBG.Position = UDim2.new(0, 0, 0, 0)
BatteryBarBG.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
BatteryBarBG.BorderSizePixel = 0
BatteryBarBG.ClipsDescendants = true
local BatteryBar = Instance.new("Frame", BatteryBarBG)
BatteryBar.Size = UDim2.new(0, 0, 1, 0)
BatteryBar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

local BatteryLabel = Instance.new("TextLabel", BatteryBarBG)
BatteryLabel.Size = UDim2.new(1, 0, 1, 0)
BatteryLabel.BackgroundTransparency = 1
BatteryLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BatteryLabel.Font = Enum.Font.FredokaOne
BatteryLabel.TextScaled = true
BatteryLabel.Text = "Battery: 0%"

-- Ping bar
local PingBarBG = Instance.new("Frame", Content)
PingBarBG.Size = UDim2.new(1, 0, 0, 20)
PingBarBG.Position = UDim2.new(0, 0, 0, 30)
PingBarBG.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
PingBarBG.BorderSizePixel = 0
PingBarBG.ClipsDescendants = true
local PingBar = Instance.new("Frame", PingBarBG)
PingBar.Size = UDim2.new(0, 0, 1, 0)
PingBar.BackgroundColor3 = Color3.fromRGB(0, 255, 255)

local PingLabel = Instance.new("TextLabel", PingBarBG)
PingLabel.Size = UDim2.new(1, 0, 1, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PingLabel.Font = Enum.Font.FredokaOne
PingLabel.TextScaled = true
PingLabel.Text = "Ping: 0ms"

--// Draggable
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
	local size = Content.Visible and UDim2.new(0, 300, 0, 120) or UDim2.new(0, 300, 0, 35)
	TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = size}):Play()
end)

--// Update Stats
local function getPing()
	local startTime = tick()
	pcall(function()
		game:GetService("HttpService"):GetAsync("https://www.roblox.com")
	end)
	local endTime = tick()
	return math.floor((endTime - startTime) * 1000)
end

RunService.RenderStepped:Connect(function()
	local batteryPercent = math.floor(UserInputService:GetBatteryPercentage() * 100)
	local ping = getPing()

	-- Update battery bar
	BatteryLabel.Text = "Battery: "..batteryPercent.."%"
	TweenService:Create(BatteryBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(batteryPercent/100,0,1,0)}):Play()
	BatteryBar.BackgroundColor3 = Color3.fromHSV(batteryPercent/100 * 0.3,1,1) -- green to red

	-- Update ping bar
	PingLabel.Text = "Ping: "..ping.."ms"
	local pingPercent = math.clamp(1 - (ping/300),0,1)
	TweenService:Create(PingBar, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Size = UDim2.new(pingPercent,0,1,0)}):Play()
	PingBar.BackgroundColor3 = Color3.fromHSV(pingPercent*0.4,1,1) -- cyan to red
end)
