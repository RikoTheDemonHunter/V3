for _, v in pairs(game.CoreGui:GetChildren()) do
	if v:IsA("ScreenGui") and v.Name == "GainUI" then
		v:Destroy()
	end
end

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local SETTINGS_FILE = "GainUI_Settings.json"
local userSettings = {
	Color = "rainbow",
	Glow = "ethereal",
	Visible = true
}

local function saveSettings()
	if writefile then
		pcall(function()
			writefile(SETTINGS_FILE, HttpService:JSONEncode(userSettings))
		end)
	end
end

local function loadSettings()
	if readfile and isfile and isfile(SETTINGS_FILE) then
		pcall(function()
			local data = HttpService:JSONDecode(readfile(SETTINGS_FILE))
			if data then
				for k, v in pairs(data) do
					userSettings[k] = v
				end
			end
		end)
	end
end
loadSettings()

local ColorPalette = {
	["yellow"] = Color3.fromRGB(255, 235, 59),
	["lime"] = Color3.fromRGB(76, 175, 80),
	["pink"] = Color3.fromRGB(233, 30, 99),
	["blue"] = Color3.fromRGB(33, 150, 243),
	["red"] = Color3.fromRGB(244, 67, 54),
	["orange"] = Color3.fromRGB(255, 152, 0),
	["red velvet"] = Color3.fromRGB(128, 0, 32),
	["ethereal"] = Color3.fromRGB(138, 43, 226)
}

local GainUI = Instance.new("ScreenGui")
GainUI.Name = "GainUI"
GainUI.Parent = game.CoreGui
GainUI.ResetOnSpawn = false
GainUI.Enabled = userSettings.Visible

local DragFrame = Instance.new("Frame")
DragFrame.Name = "DragFrame"
DragFrame.Parent = GainUI
DragFrame.Size = UDim2.new(0, 240, 0, 60)
DragFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
DragFrame.BackgroundTransparency = 1
DragFrame.BorderSizePixel = 0
DragFrame.Active = true

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = DragFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 2)

local PrestigeGain = Instance.new("TextLabel")
PrestigeGain.Name = "PrestigeGain"
PrestigeGain.Parent = DragFrame
PrestigeGain.BackgroundTransparency = 1
PrestigeGain.Size = UDim2.new(1, 0, 0.45, 0)
PrestigeGain.Font = Enum.Font.GothamBold
PrestigeGain.TextSize = 18
PrestigeGain.TextColor3 = Color3.fromRGB(255, 255, 255)
PrestigeGain.TextXAlignment = Enum.TextXAlignment.Left
PrestigeGain.Text = "Prestige: 0"

local PrestigeStroke = Instance.new("UIStroke")
PrestigeStroke.Thickness = 1.5
PrestigeStroke.JoinMode = Enum.LineJoinMode.Round
PrestigeStroke.Parent = PrestigeGain

local BpGain = Instance.new("TextLabel")
BpGain.Name = "BpGain"
BpGain.Parent = DragFrame
BpGain.BackgroundTransparency = 1
BpGain.Size = UDim2.new(1, 0, 0.45, 0)
BpGain.Font = Enum.Font.GothamBold
BpGain.TextSize = 18
BpGain.TextColor3 = Color3.fromRGB(255, 255, 255)
BpGain.TextXAlignment = Enum.TextXAlignment.Left
BpGain.Text = "BP Gain: +0"

local BpStroke = Instance.new("UIStroke")
BpStroke.Thickness = 1.5
BpStroke.JoinMode = Enum.LineJoinMode.Round
BpStroke.Parent = BpGain

local leaderstats = LocalPlayer:WaitForChild("leaderstats", 10)
if not leaderstats then
	warn("[Gain Tracker] leaderstats not found.")
	return
end

local bp = leaderstats:WaitForChild("Burp points", 10)
local prestige = leaderstats:WaitForChild("Prestige", 10)
if not bp or not prestige then
	warn("[Gain Tracker] Missing Stats.")
	return
end

local lastBP = bp.Value

local dragToggle, dragStart, startPos
local function updateInput(input)
	local delta = input.Position - dragStart
	local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	TweenService:Create(DragFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = position}):Play()
end

DragFrame.InputBegan:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		dragToggle = true
		dragStart = input.Position
		startPos = DragFrame.Position
		
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragToggle = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
		updateInput(input)
	end
end)

task.spawn(function()
	local hue = 0
	while task.wait(0.03) do
		hue = (hue + 0.006) % 1
		local rainbowColor = Color3.fromHSV(hue, 0.85, 1)
		local etherealColor = Color3.fromHSV((hue * 0.3 + 0.7) % 1, 0.8, 1)

		local targetColor
		if userSettings.Color == "rainbow" then
			targetColor = rainbowColor
		elseif userSettings.Color == "ethereal" then
			targetColor = etherealColor
		else
			targetColor = ColorPalette[userSettings.Color] or Color3.fromRGB(255, 255, 255)
		end

		PrestigeGain.TextColor3 = targetColor
		BpGain.TextColor3 = targetColor

		if userSettings.Glow == "white" then
			PrestigeStroke.Enabled = true
			BpStroke.Enabled = true
			PrestigeStroke.Color = Color3.fromRGB(255, 255, 255)
			BpStroke.Color = Color3.fromRGB(255, 255, 255)
		elseif userSettings.Glow == "ethereal" then
			PrestigeStroke.Enabled = true
			BpStroke.Enabled = true
			PrestigeStroke.Color = etherealColor
			BpStroke.Color = etherealColor
		else
			PrestigeStroke.Enabled = true
			BpStroke.Enabled = true
			PrestigeStroke.Color = Color3.fromRGB(0, 0, 0)
			BpStroke.Color = Color3.fromRGB(0, 0, 0)
		end

		PrestigeGain.Text = "Prestige: " .. tostring(prestige.Value)
		if bp.Value ~= lastBP then
			local gain = bp.Value - lastBP
			if gain > 0 then
				BpGain.Text = string.format("BP Gain: +%d", gain)
			end
			lastBP = bp.Value
		end
	end
end)

LocalPlayer.Chatted:Connect(function(message)
	local args = string.split(string.lower(message), " ")
	local command = args[1]

	if command == "!color" and args[2] then
		local selected = string.gsub(message, "^!color%s+", ""):lower()
		if ColorPalette[selected] or selected == "rainbow" or selected == "ethereal" then
			userSettings.Color = selected
			saveSettings()
		end
	elseif command == "!glow" and args[2] then
		local selectedGlow = args[2]
		if selectedGlow == "white" or selectedGlow == "ethereal" or selectedGlow == "off" then
			userSettings.Glow = selectedGlow
			saveSettings()
		end
	elseif command == "!hide" then
		GainUI.Enabled = false
		userSettings.Visible = false
		saveSettings()
	elseif command == "!show" then
		GainUI.Enabled = true
		userSettings.Visible = true
		saveSettings()
	end
end)
