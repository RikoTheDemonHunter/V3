-- Adaptive FPS Counter GUI (Detects Device Performance & Refresh Rates)
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Remove existing GUI to prevent duplication
if CoreGui:FindFirstChild("FPSCounterGUI") then
    CoreGui.FPSCounterGUI:Destroy()
end

-- Create GUI Container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSCounterGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui

-- Main Window
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 75)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Name = "FPSMain"
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- FPS Display Text
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(1, 0, 0, 40)
fpsLabel.Position = UDim2.new(0, 0, 0, 5)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 20
fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsLabel.Text = "--- FPS"
fpsLabel.Parent = mainFrame

-- Minimize / Expand Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(1, -20, 0, 20)
minimizeButton.Position = UDim2.new(0, 10, 1, -25)
minimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
minimizeButton.TextColor3 = Color3.fromRGB(230, 230, 230)
minimizeButton.Font = Enum.Font.Gotham
minimizeButton.TextSize = 11
minimizeButton.Text = "Minimize"
minimizeButton.AutoButtonColor = true
minimizeButton.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = minimizeButton

---

-- State Variables
local frameTimes = {}
local isMinimized = false
local peakFps = 60 -- Default assumption, adjusts dynamically
local lastPeakUpdate = 0

RunService.RenderStepped:Connect(function(delta)
    local now = os.clock()
    table.insert(frameTimes, now)
    
    -- Keep only frames from the last 1 second
    while frameTimes[1] and (now - frameTimes[1]) > 1 do
        table.remove(frameTimes, 1)
    end
    
    local currentFps = #frameTimes
    
    -- Dynamic Refresh Rate Estimation
    -- If they exceed their old peak, we instantly discover their screen/device capacity
    if currentFps > peakFps then
        peakFps = currentFps
        lastPeakUpdate = now
    elseif now - lastPeakUpdate > 10 then
        -- Decay peak slowly over time if performance dipped permanently,
        -- but clamp it to standard refresh rate targets (60, 120, 144, 240)
        if peakFps > 144 then peakFps = 240
        elseif peakFps > 120 then peakFps = 144
        elseif peakFps > 60 then peakFps = 120
        else peakFps = 60 end
    end

    -- Update Text Display
    fpsLabel.Text = string.format("%d / %d Hz", currentFps, peakFps)
    
    -- Adaptive Color Scaling based on detected hardware capacity
    -- Green = Excellent for their device | Yellow = Minor dip | Red = Severe struggle
    local performanceRatio = currentFps / peakFps
    
    if performanceRatio >= 0.90 then
        fpsLabel.TextColor3 = Color3.fromRGB(85, 255, 120) -- Perfect performance
    elseif performanceRatio >= 0.65 then
        fpsLabel.TextColor3 = Color3.fromRGB(255, 200, 80) -- Modest frame drops
    else
        fpsLabel.TextColor3 = Color3.fromRGB(255, 90, 90) -- Lagging behind target
    end
end)

-- Layout Toggling (Minimize)
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame:TweenSize(UDim2.new(0, 150, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        fpsLabel.Visible = false
        minimizeButton.Position = UDim2.new(0, 10, 0, 5)
        minimizeButton.Text = "Expand"
    else
        mainFrame:TweenSize(UDim2.new(0, 150, 0, 75), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, 0.2, true)
        task.delay(0.1, function() fpsLabel.Visible = true end)
        minimizeButton.Position = UDim2.new(0, 10, 1, -25)
        minimizeButton.Text = "Minimize"
    end
end)

-- Modern Dragging Logic
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
