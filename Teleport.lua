--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Player
local LocalPlayer = Players.LocalPlayer

--// Load DarkLib from ReplicatedStorage
local DarkLib = require(ReplicatedStorage:WaitForChild("DarkLib"))

--// Create GUI window
local Window = DarkLib:CreateWindow("Player Teleporter", Vector2.new(400, 300), Enum.KeyCode.RightControl)
local Tab = Window:CreateTab("Main")
local Section = Tab:CreateSection("Teleport Menu")

--// Minimize Toggle
local minimized = false
Section:CreateButton("Minimize", function()
    if minimized then
        Window:Maximize()
    else
        Window:Minimize()
    end
    minimized = not minimized
end)

--// Dropdown Logic
local selectedPlayer = nil

-- Get player names excluding LocalPlayer
local function getPlayerList()
    local list = {}
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            table.insert(list, plr.Name)
        end
    end
    return list
end

-- Create dropdown
local dropdown = Section:CreateDropdown("Select Player", getPlayerList(), function(selected)
    selectedPlayer = selected
end)

-- Update dropdown when players join/leave
local function updateDropdown()
    local list = getPlayerList()
    dropdown:Clear()
    dropdown:Add(list)
    if #list > 0 then
        selectedPlayer = list[1]
        dropdown:Set(list[1])
    else
        selectedPlayer = nil
    end
end

Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)
updateDropdown()

--// Teleport Button
Section:CreateButton("Teleport", function()
    if not selectedPlayer then return end

    local targetPlayer = Players:FindFirstChild(selectedPlayer)
    local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myHRP = myChar:FindFirstChild("HumanoidRootPart")
        local targetHRP = targetPlayer.Character.HumanoidRootPart

        if myHRP then
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local goal = {CFrame = targetHRP.CFrame * CFrame.new(0, 3, 0)}
            local tween = TweenService:Create(myHRP, tweenInfo, goal)
            tween:Play()
        end
    end
end)
