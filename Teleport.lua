local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 0)
frame.Position = UDim2.new(0.5, -200, 0.5, -100)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 400, 0, 300)
}):Play()

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -60, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
title.Text = "🧭 Teleport to Player"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 5)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.Gotham
minimizeButton.TextSize = 16
minimizeButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.Gotham
closeButton.TextSize = 16
closeButton.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -45)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 4
scroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scroll.BorderSizePixel = 0
scroll.Parent = frame

-- Add UIListLayout ONCE and don't destroy it during refresh
local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 4)
layout.Parent = scroll

-- Function to update player list
local function updatePlayerList()
	-- Remove only TextButtons (player buttons), NOT the layout
	for _, child in pairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 30)
			btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
			btn.TextColor3 = Color3.fromRGB(200, 200, 255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Text = "🧍 " .. plr.Name
			btn.Parent = scroll

			btn.MouseButton1Click:Connect(function()
				local targetChar = plr.Character
				local myChar = LocalPlayer.Character
				if targetChar and targetChar:FindFirstChild("HumanoidRootPart") and myChar then
					local root = targetChar.HumanoidRootPart
					myChar:MoveTo(root.Position + Vector3.new(2, 0, 2))
				end
			end)
		end
	end

	scroll.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 35)
end

-- Update list now and when players join/leave
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Minimize/Expand
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	scroll.Visible = not minimized
	local newSize = minimized and UDim2.new(0, 400, 0, 40) or UDim2.new(0, 400, 0, 300)
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size = newSize}):Play()
end)

-- Close GUI
closeButton.MouseButton1Click:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.3), {
		Size = UDim2.new(0, 400, 0, 0)
	}):Play()
	task.wait(0.35)
	screenGui:Destroy()
end)
