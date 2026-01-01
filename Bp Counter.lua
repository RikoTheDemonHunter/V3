--// Avery's Gain Tracker (Polished, Clean, Mobile-Friendly + RGB Toggle)

--════════════════════════════════════
-- Cleanup
--════════════════════════════════════
for _, gui in ipairs(game.CoreGui:GetChildren()) do
	if gui:IsA("ScreenGui") and gui.Name == "GainUI" then
		gui:Destroy()
	end
end

--════════════════════════════════════
-- Services
--════════════════════════════════════
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

--════════════════════════════════════
-- UI Root
--════════════════════════════════════
local GainUI = Instance.new("ScreenGui")
GainUI.Name = "GainUI"
GainUI.ResetOnSpawn = false
GainUI.IgnoreGuiInset = true
GainUI.Parent = game.CoreGui

local DragFrame = Instance.new("Frame")
DragFrame.Parent = GainUI
DragFrame.Size = UDim2.fromOffset(220, 60)
DragFrame.Position = UDim2.fromScale(0.05, 0.1)
DragFrame.BackgroundTransparency = 1
DragFrame.Active = true

--════════════════════════════════════
-- Label Factory
--════════════════════════════════════
local function createLabel(y, text)
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 0, 25)
	label.Position = UDim2.fromOffset(0, y)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.SourceSansBold
	label.TextScaled = true
	label.TextWrapped = true
	label.Text = text
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.Parent = DragFrame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1.2
	stroke.Transparency = 0.4
	stroke.Parent = label

	return label
end

local PrestigeLabel = createLabel(0, "Prestige: 0")
local BPLabel = createLabel(30, "BP Gain: 0")

--════════════════════════════════════
-- Drag System (Mouse + Touch)
--════════════════════════════════════
local dragging = false
local dragInput
local dragStart
local startPos

local function clamp(pos)
	return UDim2.fromOffset(
		math.clamp(pos.X.Offset, 0, camera.ViewportSize.X - DragFrame.Size.X.Offset),
		math.clamp(pos.Y.Offset, 0, camera.ViewportSize.Y - DragFrame.Size.Y.Offset)
	)
end

DragFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = DragFrame.Position
		dragInput = input
	end
end)

DragFrame.InputEnded:Connect(function(input)
	if input == dragInput then
		dragging = false
		dragInput = nil
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
		local delta = input.Position - dragStart
		DragFrame.Position = clamp(
			UDim2.fromOffset(
				startPos.X.Offset + delta.X,
				startPos.Y.Offset + delta.Y
			)
		)
	end
end)

--════════════════════════════════════
-- Safe Stat Loading
--════════════════════════════════════
local leaderstats = player:WaitForChild("leaderstats", 10)
if not leaderstats then
	warn("[GainTracker] leaderstats missing")
	return
end

local bp = leaderstats:WaitForChild("Burp points", 10)
local prestige = leaderstats:WaitForChild("Prestige", 10)
if not bp or not prestige then
	warn("[GainTracker] Required stats missing")
	return
end

--════════════════════════════════════
-- Gain Logic
--════════════════════════════════════
local lastBP = bp.Value
local totalGain = 0

local function flash(label)
	local tween = TweenService:Create(
		label,
		TweenInfo.new(0.15),
		{TextTransparency = 0.25}
	)
	tween:Play()
	task.delay(0.2, function()
		label.TextTransparency = 0
	end)
end

prestige.Changed:Connect(function()
	PrestigeLabel.Text = "Prestige: " .. prestige.Value
end)

bp.Changed:Connect(function(newValue)
	local gain = newValue - lastBP
	if gain > 0 then
		totalGain += gain
		BPLabel.Text = string.format(
			"(BP Gain: +%d)",
			gain,
			totalGain
		)
		flash(BPLabel)
	end
	lastBP = newValue
end)

PrestigeLabel.Text = "Prestige: " .. prestige.Value
BPLabel.Text = "BP Gain: 0"

--════════════════════════════════════
-- RGB Toggle System
--════════════════════════════════════
local rgbEnabled = true
local hue = 0
local defaultColor = Color3.fromRGB(173, 216, 230)

RunService.Heartbeat:Connect(function(dt)
	if not rgbEnabled then return end

	hue = (hue + dt * 0.08) % 1
	local color = Color3.fromHSV(hue, 1, 1)

	PrestigeLabel.TextColor3 = color
	BPLabel.TextColor3 = color
end)

--════════════════════════════════════
-- Chat Commands (!RGB On / Off)
--════════════════════════════════════
local glowEnabled = true

-- Predefine your colors
local colorMap = {
	blue = Color3.fromRGB(0, 122, 255),
	lightgreen = Color3.fromRGB(144, 238, 144),
	yellow = Color3.fromRGB(255, 255, 0),
	peppermint = Color3.fromRGB(152, 255, 152),
	strawberry = Color3.fromRGB(255, 80, 120),
	pink = Color3.fromRGB(255, 182, 193),
	ethereal = Color3.fromRGB(180, 200, 255)
}

player.Chatted:Connect(function(msg)
	msg = string.lower(msg)

	-- RGB toggle
	if msg == "!rgb on" then
		rgbEnabled = true
	elseif msg == "!rgb off" then
		rgbEnabled = false
		PrestigeLabel.TextColor3 = defaultColor
		BPLabel.TextColor3 = defaultColor
	end

	-- Glow toggle
	if msg == "!glow on" then
		glowEnabled = true
		for _, label in ipairs({PrestigeLabel, BPLabel}) do
			if not label:FindFirstChild("UIStroke") then
				local stroke = Instance.new("UIStroke")
				stroke.Thickness = 1.2
				stroke.Transparency = 0.4
				stroke.Parent = label
			end
		end
	elseif msg == "!glow off" then
		glowEnabled = false
		for _, label in ipairs({PrestigeLabel, BPLabel}) do
			local stroke = label:FindFirstChild("UIStroke")
			if stroke then stroke:Destroy() end
		end
	end

	-- Hide/Show UI
	if msg == "!hide" then
		GainUI.Enabled = false
	elseif msg == "!show" then
		GainUI.Enabled = true
	end

	-- Color commands
	for name, color in pairs(colorMap) do
		if msg == "!color "..name then
			rgbEnabled = false -- disable RGB when setting static color
			PrestigeLabel.TextColor3 = color
			BPLabel.TextColor3 = color
			break
		end
	end
end)
