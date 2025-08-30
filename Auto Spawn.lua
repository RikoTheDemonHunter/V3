-- Double Spawn Point System with Active Spawn Selector
local player = game.Players.LocalPlayer
local spawn1, spawn2
local activeSpawn = nil -- nil until chosen

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 220)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Frame.Active = true
Frame.Draggable = true

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 6)

-- Utility: create buttons
local function createButton(text, parent)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    return btn
end

-- Flash effect near GUI
local Flash = Instance.new("Frame", Frame)
Flash.Size = UDim2.new(1, 0, 0, 5)
Flash.BackgroundTransparency = 1

local function doFlash(color)
    Flash.BackgroundColor3 = color
    Flash.BackgroundTransparency = 0
    game:GetService("TweenService"):Create(Flash, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
end

-- Spawn 1 buttons
local SetSpawn1 = createButton("Set Spawn 1", Frame)
local TpSpawn1 = createButton("Teleport to Spawn 1", Frame)
local ClearSpawn1 = createButton("Clear Spawn 1", Frame)
local UseSpawn1 = createButton("Use Spawn 1", Frame)

-- Spawn 2 buttons
local SetSpawn2 = createButton("Set Spawn 2", Frame)
local TpSpawn2 = createButton("Teleport to Spawn 2", Frame)
local ClearSpawn2 = createButton("Clear Spawn 2", Frame)
local UseSpawn2 = createButton("Use Spawn 2", Frame)

-- Functions
SetSpawn1.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        spawn1 = char.HumanoidRootPart.CFrame
        doFlash(Color3.fromRGB(0, 255, 0))
    end
end)

TpSpawn1.MouseButton1Click:Connect(function()
    if spawn1 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = spawn1
    end
end)

ClearSpawn1.MouseButton1Click:Connect(function()
    spawn1 = nil
    if activeSpawn == 1 then activeSpawn = nil end
    doFlash(Color3.fromRGB(255, 0, 0))
end)

UseSpawn1.MouseButton1Click:Connect(function()
    if spawn1 then
        activeSpawn = 1
        doFlash(Color3.fromRGB(0, 200, 255)) -- cyan flash = selected
    end
end)

SetSpawn2.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        spawn2 = char.HumanoidRootPart.CFrame
        doFlash(Color3.fromRGB(0, 255, 0))
    end
end)

TpSpawn2.MouseButton1Click:Connect(function()
    if spawn2 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = spawn2
    end
end)

ClearSpawn2.MouseButton1Click:Connect(function()
    spawn2 = nil
    if activeSpawn == 2 then activeSpawn = nil end
    doFlash(Color3.fromRGB(255, 0, 0))
end)

UseSpawn2.MouseButton1Click:Connect(function()
    if spawn2 then
        activeSpawn = 2
        doFlash(Color3.fromRGB(0, 200, 255)) -- cyan flash = selected
    end
end)

-- Respawn handler
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("HumanoidRootPart")
    task.wait(0.2)
    if activeSpawn == 1 and spawn1 then
        char.HumanoidRootPart.CFrame = spawn1
    elseif activeSpawn == 2 and spawn2 then
        char.HumanoidRootPart.CFrame = spawn2
    end
end)
