-- Gain Tracker (Plain Text + RGB Color Cycle + Draggable)

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

-- Invisible Draggable Frame
local DragFrame = Instance.new("Frame")
DragFrame.Name = "DragFrame"
DragFrame.Parent = GainUI
DragFrame.Size = UDim2.new(0, 200, 0, 60)
DragFrame.Position = UDim2.new(0.05, 0, 0.1, 0)
DragFrame.BackgroundTransparency = 1
DragFrame.Active = true
DragFrame.Draggable = true

-- Prestige Label
local PrestigeGain = Instance.new("TextLabel")
PrestigeGain.Name = "PrestigeGain"
PrestigeGain.Parent = DragFrame
PrestigeGain.BackgroundTransparency = 1
PrestigeGain.Position = UDim2.new(0, 0, 0, 0)
PrestigeGain.Size = UDim2.new(0, 200, 0, 25)
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
BpGain.Position = UDim2.new(0, 0, 25, 0)
BpGain.Size = UDim2.new(0, 200, 0, 25)
BpGain.Font = Enum.Font.SourceSansBold
BpGain.TextColor3 = Color3.fromRGB(255, 0, 0)
BpGain.TextScaled = true
BpGain.TextWrapped = true
BpGain.Text = "BP Gain: 0"

-- Get player stats
local plr = game.Players.LocalPlayer
local bp = plr.leaderstats:WaitForChild("Burp points")
local prestige = plr.leaderstats:WaitForChild("Prestige")

-- Track gain
local lastBP = bp.Value

-- Rainbow function
local function RainbowColor(hue)
    return Color3.fromHSV(hue, 1, 1)
end

-- Update loop
task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        hue = (hue + 0.01) % 1
        local color = RainbowColor(hue)

        PrestigeGain.TextColor3 = color
        BpGain.TextColor3 = color

        PrestigeGain.Text = "Prestige: " .. prestige.Value
        if lastBP ~= bp.Value then
            BpGain.Text = "BP Gain: " .. (bp.Value - lastBP)
            lastBP = bp.Value
        end
    end
end)
