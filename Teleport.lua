-- // Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- // Load DarkLib
local DarkLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Dark-Lib/main/source.lua"))()
local Window = DarkLib:CreateWindow(" Avery Teleport GUI", Vector2.new(420, 370), Enum.KeyCode.RightControl)

-- // Tab and section
local Tab = Window:CreateTab("Main")
local Section = Tab:CreateSection("Teleport System")

-- // Minimize toggle
local minimized = false
Section:CreateButton("Minimize", function()
    if not minimized then
        Window:Minimize()
    else
        Window:Maximize()
    end
    minimized = not minimized
end)

-- // Player dropdown setup
local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- // Create dropdown
local selectedPlayer = nil

local dropdown = Section:CreateDropdown("Select Player", getPlayerNames(), function(playerName)
    selectedPlayer = playerName
end)

-- // Teleport Button
Section:CreateButton("Teleport", function()
    if not selectedPlayer then return end

    local targetPlayer = Players:FindFirstChild(selectedPlayer)
    local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        local targetRoot = targetPlayer.Character.HumanoidRootPart

        if myRoot then
            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local goal = {CFrame = targetRoot.CFrame * CFrame.new(0, 3, 0)}
            TweenService:Create(myRoot, tweenInfo, goal):Play()
        end
    else
        warn("Target player not valid or missing HRP")
    end
end)

-- // Update dropdown when players join/leave
Players.PlayerAdded:Connect(function()
    dropdown:Clear()
    dropdown:Add(getPlayerNames())
end)

Players.PlayerRemoving:Connect(function()
    dropdown:Clear()
    dropdown:Add(getPlayerNames())
end)
