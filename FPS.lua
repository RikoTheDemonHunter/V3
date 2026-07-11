-- Modern FPS Counter GUI with Smooth Drag, Toggle, Minimize, and Universal Refresh Rate
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Remove existing GUI to prevent duplication during testing
if game.CoreGui:FindFirstChild("FPSCounterGUI") then
    game.CoreGui.FPSCounterGUI:Destroy()
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FPSCounterGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Main Container Frame (Sleek Dark Theme)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 90)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Name = "FPSMain"
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = mainFrame

-- Title/Drag Bar area
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 0, 25)
titleLabel.Position = UDim2.new(0, 10, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 12
titleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Text = "PERFORMANCE"
titleLabel.Parent = mainFrame

-- FPS Display Label
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Name = "FPSLabel"
fpsLabel.Size = UDim2.new(1, -20, 0, 35)
fpsLabel.Position = UDim2.new(0, 10, 0, 22)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBlack
fpsLabel.TextSize = 28
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 128) -- Modern Emerald Green
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Text = "--- FPS"
fpsLabel.Parent = mainFrame

-- Button Container
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(1, -20, 0, 25)
buttonContainer.Position = UDim2.new(0, 10, 1, -30)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = buttonContainer

-- Helper function to style buttons beautifully
local function createButton(name, text, color, order)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Size = UDim2.new(0.5, -3, 1, 0)
    btn.BackgroundColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.BorderSizePixel = 0
    btn.LayoutOrder = order
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = btn
    
    btn.Parent = buttonContainer
    return btn
end

local minimizeButton = createButton("MinimizeBtn", "Minimize", Color3.fromRGB(45, 45, 45), 1)
local closeButton = createButton("CloseBtn", "Close", Color3.fromRGB(180, 40, 40), 2)

--- UI INTERACTION LOGIC ---

-- 1. Modern Smooth Dragging System (Mobile & PC Friendly)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    TweenService:Create(mainFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
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

-- 2. Minimize & Close Logic
local isMinimized = false
local originalSize = mainFrame.Size

minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        fpsLabel.Visible = false
        buttonContainer.Size = UDim2.new(1, -20, 0, 25)
        buttonContainer.Position = UDim2.new(0, 10, 0, 25)
        
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = UDim2.new(0, 180, 0, 55)}):Play()
        minimizeButton.Text = "Expand"
    else
        fpsLabel.Visible = true
        buttonContainer.Size = UDim2.new(1, -20, 0, 25)
        buttonContainer.Position = UDim2.new(0, 10, 1, -30)
        
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = originalSize}):Play()
        minimizeButton.Text = "Minimize"
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

--- ACCURATE FPS CALCULATION & MODERN COLOR CODING ---

-- We use a rolling average over a 0.5-second sample window to keep the display snappy but steady.
local lastUpdate = os.clock()
local frameTimes = {}
local sampleWindow = 0.5 

RunService.RenderStepped:Connect(function()
    local now = os.clock()
    table.insert(frameTimes, now)
    
    -- Clear out logged frame timestamps older than our sample window
    while frameTimes[1] and frameTimes[1] < now - sampleWindow do
        table.remove(frameTimes, 1)
    end
    
    -- Update GUI every 0.2 seconds to avoid unreadable flickering
    if now - lastUpdate >= 0.2 then
        lastUpdate = now
        local count = #frameTimes
        -- Extrapolate the FPS based on how many frames fell into the sample window
        local fps = math.round(count / sampleWindow)
        
        fpsLabel.Text = tostring(fps) .. " FPS"
        
        -- Better Color Coding Gradient:
        -- Seamless transitions from vibrant emerald green (high) to yellow (mid) to crimson red (low)
        if fps >= 60 then
            -- Clean Emerald Green for smooth performance
            fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
        elseif fps >= 45 then
            -- Light Green/Lime
            fpsLabel.TextColor3 = Color3.fromRGB(160, 230, 60)
        elseif fps >= 30 then
            -- Soft Amber Yellow
            fpsLabel.TextColor3 = Color3.fromRGB(240, 190, 40)
        elseif fps >= 20 then
            -- Deep Orange
            fpsLabel.TextColor3 = Color3.fromRGB(240, 100, 30)
        else
            -- Clean Crimson Red for severe lag
            fpsLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
        end
    end
end)
