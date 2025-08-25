--// Auto Set Spawn Point GUI (Clean, No Safety)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SpawnPointGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 110)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 28)
titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = frame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -55, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Spawn Point"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 25, 1, 0)
minimizeBtn.Position = UDim2.new(1, -55, 0, 0)
minimizeBtn.Text = "–"
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45,45,45)
minimizeBtn.TextColor3 = Color3.fromRGB(255,255,255)
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 1, 0)
closeBtn.Position = UDim2.new(1, -28, 0, 0)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50)
closeBtn.TextColor3 = Color3.fromRGB(255,255,255)
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)

-- Container
local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 1, -28)
container.Position = UDim2.new(0,0,0,28)
container.BackgroundTransparency = 1
container.Parent = frame

-- Set Spawn Button
local setSpawnBtn = Instance.new("TextButton")
setSpawnBtn.Size = UDim2.new(1, -20, 0, 35)
setSpawnBtn.Position = UDim2.new(0, 10, 0, 8)
setSpawnBtn.Text = "Set Spawn Point"
setSpawnBtn.Font = Enum.Font.GothamBold
setSpawnBtn.TextSize = 14
setSpawnBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
setSpawnBtn.TextColor3 = Color3.fromRGB(255,255,255)
setSpawnBtn.BorderSizePixel = 0
setSpawnBtn.Parent = container
Instance.new("UICorner", setSpawnBtn).CornerRadius = UDim.new(0, 8)

-- Info Label
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 30)
infoLabel.Position = UDim2.new(0, 10, 0, 50)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 13
infoLabel.Text = "No spawn point set"
infoLabel.TextColor3 = Color3.fromRGB(200,200,200)
infoLabel.TextWrapped = true
infoLabel.Parent = container

-- Spawn point variable
local spawnPoint = nil

-- Set spawn button
setSpawnBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        spawnPoint = hrp.CFrame -- ✅ store full CFrame
        infoLabel.Text = "✅ Spawn point saved!"
    end
end)

-- Respawn handler
LocalPlayer.CharacterAdded:Connect(function(char)
    if spawnPoint then
        task.wait(0.5) -- short delay to avoid conflicts
        char:WaitForChild("HumanoidRootPart").CFrame = spawnPoint
        infoLabel.Text = "📍 Returned to spawn"
    end
end)

-- Minimize toggle
local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    container.Visible = not minimized
    if minimized then
        minimizeBtn.Text = "+"
        frame.Size = UDim2.new(0,220,0,28)
    else
        minimizeBtn.Text = "–"
        frame.Size = UDim2.new(0,220,0,110)
    end
end)

-- Close button
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Dragging system
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
