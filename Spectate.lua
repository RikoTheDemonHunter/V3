--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

--// Load DarkLib manually
local DarkLib = require(ReplicatedStorage:WaitForChild("DarkLib"))

--// GUI Setup
local Window = DarkLib:CreateWindow("Spectate GUI", Vector2.new(450, 350), Enum.KeyCode.RightControl)
local Tab = Window:CreateTab("Spectate")
local Section = Tab:CreateSection("Spectate Player")

--// Minimize Button
local minimized = false
Section:CreateButton("Minimize", function()
    if minimized then
        Window:Maximize()
    else
        Window:Minimize()
    end
    minimized = not minimized
end)

--// Dropdown Setup
local selectedPlayer = nil
local function getPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local dropdown = Section:CreateDropdown("Select Player", getPlayerNames(), function(name)
    selectedPlayer = name
end)

--// Label: Current Spectated Player
local spectateLabel = Section:CreateLabel("Not Spectating")

--// Update dropdown when players join/leave
local function updateDropdown()
    local names = getPlayerNames()
    dropdown:Clear()
    dropdown:Add(names)
    if #names > 0 then
        selectedPlayer = names[1]
        dropdown:Set(names[1])
    else
        selectedPlayer = nil
    end
end

Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(updateDropdown)
updateDropdown()

--// Spectate Logic
local spectating = false
local spectateConnection

local function stopSpectate()
    spectating = false
    Camera.CameraSubject = LocalPlayer.Character:WaitForChild("Humanoid")
    spectateLabel:Set("Not Spectating")
    if spectateConnection then
        spectateConnection:Disconnect()
        spectateConnection = nil
    end
end

local function startSpectate(playerName)
    local player = Players:FindFirstChild(playerName)
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        spectating = true
        spectateLabel:Set("Spectating: " .. playerName)

        spectateConnection = RunService.RenderStepped:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                Camera.CameraSubject = player.Character.Humanoid
            else
                stopSpectate()
            end
        end)
    end
end

--// Toggle Button
Section:CreateButton("Toggle Spectate", function()
    if not selectedPlayer then return end

    if not spectating then
        startSpectate(selectedPlayer)
    else
        stopSpectate()
    end
end)
Spec
