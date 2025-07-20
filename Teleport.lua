--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

--// GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportPanelGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 0) -- Start collapsed
frame.Position = UDim2.new(0.5, -200, 0.5, -100)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Rounded corners & stroke
local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 10)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(50, 50, 60)
stroke.Thickness = 1
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Animate open
TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 400, 0, 300)
}):Play()

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
title.Text = "🚀 Teleport Panel"
title.TextColor3 = Color3.fromRGB(230, 230, 255)
title.Font = Enum.Font.FredokaOne
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Buttons
local function StyleButton(button, color)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = button

	button.BackgroundColor3 = color
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.GothamBold

	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.1)
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = color
	end)
end

-- Minimize
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 5)
minimizeButton.Text = "-"
minimizeButton.Parent = frame
StyleButton(minimizeButton, Color3.fromRGB(60, 60, 70))

-- Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.Parent = frame
StyleButton(closeButton, Color3.fromRGB(120, 30, 30))

-- Scrollable Player List
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 90)
scroll.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
scroll.BorderSizePixel = 0
scroll.Parent = frame

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Player Button Creator
local function createPlayerButton(player)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Text = player.DisplayName .. " (" .. player.Name .. ")"
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	btn.TextColor3 = Color3.fromRGB(240, 240, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	btn.Parent = scroll

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 6)
	btnCorner.Parent = btn

	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
	end)

	btn.MouseButton1Click:Connect(function()
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
			LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(3, 0, 0))
		end
	end)
end

-- Update player list
local function updatePlayerList()
	scroll:ClearAllChildren()
	layout.Parent = scroll
	for _, plr in pairs(Players:GetPlayers()) do
		createPlayerButton(plr)
	end
	task.wait(0.1)
	scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
end

updatePlayerList()

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Minimize logic
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	scroll.Visible = not minimized
	local goalSize = minimized and UDim2.new(0, 400, 0, 40) or UDim2.new(0, 400, 0, 300)
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = goalSize}):Play()
end)

-- Close logic
closeButton.MouseButton1Click:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.3), {
		Size = UDim2.new(0, 400, 0, 0)
	}):Play()
	task.wait(0.35)
	screenGui:Destroy()
end)
