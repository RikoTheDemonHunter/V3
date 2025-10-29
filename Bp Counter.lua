--// Avery's Gain Tracker (Clean, Safe, RGB Cycle + Modern Draggable)

-- Remove existing GainUI if already running
for _, v in pairs(game.CoreGui:GetChildren()) do
	if v:IsA("ScreenGui") and v.Name == "GainUI" then
		v:Destroy()
	end
end

-- Create GUI container
local GainUI = Instance.new("ScreenGui")
GainUI.Name = "GainUI"
GainUI.Parent = game.CoreGui
GainUI.ResetOnSpawn = false

-- Main draggable frame (invisible)
local DragFrame = Instance.new("Frame")
DragFrame.Name = "DragFrame"
DragFrame.Parent = GainUI
DragFrame.Size = UDim2.new(0, 220, 0, 60)
DragFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
DragFrame.BackgroundTransparency = 1

-- Prestige Label
local PrestigeGain = Instance.new("TextLabel")
PrestigeGain.Name = "PrestigeGain"
PrestigeGain.Parent = DragFrame
PrestigeGain.BackgroundTransparency = 1
PrestigeGain.Position = UDim2.new(0, 0, 0, 0)
PrestigeGain.Size = UDim2.new(1, 0, 0, 25)
PrestigeGain.Font = Enum.Font.SourceSansBold
PrestigeGain.TextColor3 = Color3.fromRGB(255, 0, 0)
PrestigeGain.TextScaled = true
PrestigeGain.TextWrapped = true
PrestigeGain.Text = "Prestige: 0"

-- BP Gain Label
local BpGain = Instance.new("TextLabel")
BpGain.Name = "BpGain"
BpGain.Parent = DragFrame
BpGain.BackgroundTransparency = 1
BpGain.Position = UDim2.new(0, 0, 0, 30)
BpGain.Size = UDim2.new(1, 0, 0, 25)
BpGain.Font = Enum.Font.SourceSansBold
BpGain.TextColor3 = Color3.fromRGB(255, 0, 0)
BpGain.TextScaled = true
BpGain.TextWrapped = true
BpGain.Text = "BP Gain: 0"

-- Modern draggable system (reliable)
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos

DragFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = DragFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		DragFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Safe stat loading
local player = game.Players.LocalPlayer
local leaderstats = player:WaitForChild("leaderstats", 10)
if not leaderstats then
	warn("[Gain Tracker] leaderstats not found, stopping script.")
	return
end

local bp = leaderstats:WaitForChild("Burp points", 10)
local prestige = leaderstats:WaitForChild("Prestige", 10)
if not bp or not prestige then
	warn("[Gain Tracker] Missing BP or Prestige stat, stopping script.")
	return
end

-- Track gain
local lastBP = bp.Value
local totalGain = 0

-- Rainbow function
local function RainbowColor(hue)
	return Color3.fromHSV(hue, 1, 1)
end

-- Optional: Flash effect when BP increases
local TweenService = game:GetService("TweenService")
local function flashText(label)
	local tweenIn = TweenService:Create(label, TweenInfo.new(0.2), {TextTransparency = 0})
	local tweenOut = TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 0.5})
	tweenIn:Play()
	tweenIn.Completed:Wait()
	tweenOut:Play()
end

-- Update loop
task.spawn(function()
	local hue = 0
	while task.wait(0.08) do
		hue = (hue + 0.005) % 1
		local color = RainbowColor(hue)

		PrestigeGain.TextColor3 = color
		BpGain.TextColor3 = color
		PrestigeGain.Text = "Prestige: " .. tostring(prestige.Value)

		if bp.Value ~= lastBP then
			local gain = bp.Value - lastBP
			if gain > 0 then
				totalGain += gain
				BpGain.Text = string.format("BP Gain: +%d (Total: %d)", gain, totalGain)
				flashText(BpGain)
			end
			lastBP = bp.Value
		end
	end
end)
