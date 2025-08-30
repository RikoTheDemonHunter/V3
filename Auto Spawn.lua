-- Auto Spawn System with Double Spawn Slots + Toggle Button
-- Put this in StarterGui > LocalScript

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local spawn1, spawn2 = nil, nil
local lastSpawn = nil

-- GUI Setup
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
screenGui.Name = "DoubleSpawnGUI"

-- Main Frame
local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 160)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Close Button
local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.new(1,1,1)

-- Toggle Button (floating)
local toggleButton = Instance.new("TextButton", screenGui)
toggleButton.Size = UDim2.new(0, 40, 0, 40)
toggleButton.Position = UDim2.new(0, 10, 0.5, -20)
toggleButton.Text = "☰"
toggleButton.TextSize = 20
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.Active = true
toggleButton.Draggable = true

-- Hide / Show Main Frame
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- Helper: Mini flash near GUI
local function flash(color)
    local flashFrame = Instance.new("Frame", mainFrame)
    flashFrame.Size = UDim2.new(0, 20, 0, 20)
    flashFrame.Position = UDim2.new(1, -60, 1, -30)
    flashFrame.BackgroundColor3 = color
    flashFrame.BorderSizePixel = 0
    flashFrame.BackgroundTransparency = 0.3

    game:GetService("TweenService"):Create(
        flashFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    ):Play()

    game.Debris:AddItem(flashFrame, 0.6)
end

-- Spawn Slot Buttons
local function makeSpawnSection(name, yPos, slot)
    local label = Instance.new("TextLabel", mainFrame)
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Position = UDim2.new(0, 5, 0, yPos)
    label.Text = name
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1

    local setBtn = Instance.new("TextButton", mainFrame)
    setBtn.Size = UDim2.new(0, 70, 0, 25)
    setBtn.Position = UDim2.new(0, 5, 0, yPos + 25)
    setBtn.Text = "Set"
    setBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if slot == 1 then spawn1 = hrp.CFrame; lastSpawn = 1
            else spawn2 = hrp.CFrame; lastSpawn = 2 end
            flash(Color3.fromRGB(0,255,0))
        end
    end)

    local tpBtn = Instance.new("TextButton", mainFrame)
    tpBtn.Size = UDim2.new(0, 70, 0, 25)
    tpBtn.Position = UDim2.new(0, 85, 0, yPos + 25)
    tpBtn.Text = "Teleport"
    tpBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            if slot == 1 and spawn1 then hrp.CFrame = spawn1 end
            if slot == 2 and spawn2 then hrp.CFrame = spawn2 end
        end
    end)

    local clrBtn = Instance.new("TextButton", mainFrame)
    clrBtn.Size = UDim2.new(0, 70, 0, 25)
    clrBtn.Position = UDim2.new(0, 165, 0, yPos + 25)
    clrBtn.Text = "Clear"
    clrBtn.MouseButton1Click:Connect(function()
        if slot == 1 then spawn1 = nil
        else spawn2 = nil end
        flash(Color3.fromRGB(255,0,0))
    end)
end

makeSpawnSection("Spawn 1", 5, 1)
makeSpawnSection("Spawn 2", 70, 2)

-- Respawn Auto Teleport
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(0.2)
    if lastSpawn == 1 and spawn1 then
        char:WaitForChild("HumanoidRootPart").CFrame = spawn1
    elseif lastSpawn == 2 and spawn2 then
        char:WaitForChild("HumanoidRootPart").CFrame = spawn2
    end
end)
