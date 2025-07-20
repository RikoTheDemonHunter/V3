-- FPS Counter GUI with Drag, Toggle, and Minimize
local RunService = game:GetService("RunService")

-- Remove existing GUI
if game.CoreGui:FindFirstChild("FPSCounterGUI") then
    game.CoreGui.FPSCounterGUI:Destroy()
end

-- Create GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSCounterGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Draggable Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 80)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Name = "FPSMain"
mainFrame.Parent = screenGui

-- FPS Label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(1, -10, 0, 30)
fpsLabel.Position = UDim2.new(0, 5, 0, 5)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.SourceSansBold
fpsLabel.TextSize = 24
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.Text = "FPS: 0"
fpsLabel.Parent = mainFrame

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 60, 0, 25)
minimizeButton.Position = UDim2.new(0, 5, 1, -30)
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 16
minimizeButton.Text = "Minimize"
minimizeButton.Parent = mainFrame

-- FPS calculation
local frameCount = 0
local timeAccumulator = 0
local isMinimized = false

RunService.RenderStepped:Connect(function(delta)
    frameCount += 1
    timeAccumulator += delta

    if timeAccumulator >= 1 then
        local fps = frameCount
        fpsLabel.Text = "FPS: " .. tostring(fps)

        if fps >= 60 then
            fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif fps >= 30 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        else
            fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        end

        frameCount = 0
        timeAccumulator = 0
    end
end)

-- Minimize logic
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    fpsLabel.Visible = not isMinimized
    minimizeButton.Text = isMinimized and "Expand" or "Minimize"
end)
