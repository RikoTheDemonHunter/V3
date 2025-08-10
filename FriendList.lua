-- Friends in Server GUI (Closable, Draggable, Minimize) --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Parent = game.CoreGui
gui.Name = "FriendsInServer"

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 300)
frame.Position = UDim2.new(0.3, 0, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "Friends in Server"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = frame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -25, 0, 2)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Minimize Button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 25, 0, 25)
minBtn.Position = UDim2.new(1, -50, 0, 2)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 0)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minBtn.Parent = frame

-- Friends List
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -10, 1, -40)
scrollingFrame.Position = UDim2.new(0, 5, 0, 35)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.Parent = frame

local listLayout = Instance.new("UIListLayout")
listLayout.Parent = scrollingFrame
listLayout.Padding = UDim.new(0, 2)

-- Minimize toggle
local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    scrollingFrame.Visible = not minimized
    frame.Size = minimized and UDim2.new(0, 250, 0, 30) or UDim2.new(0, 250, 0, 300)
end)

-- Function to check if player is a friend
local function isFriend(player)
    local success, result = pcall(function()
        return LocalPlayer:IsFriendsWith(player.UserId)
    end)
    return success and result
end

-- Update list function
local function updateFriendsList()
    for _, child in pairs(scrollingFrame:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and isFriend(player) then
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, -5, 0, 25)
            label.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Text = player.Name
            label.Font = Enum.Font.SourceSans
            label.TextSize = 14
            label.Parent = scrollingFrame
        end
    end
end

-- Detect players joining/leaving
Players.PlayerAdded:Connect(updateFriendsList)
Players.PlayerRemoving:Connect(updateFriendsList)

-- Initial update
updateFriendsList()
