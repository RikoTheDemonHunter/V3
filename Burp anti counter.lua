-- Burping Simulator Long-Range Teleport Bot (Put in Executor)
-- Detects targets from far away, instantly teleports to them, and burps them.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Using your exact verified path
local RemoteFolder = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
local BurpEvent = RemoteFolder and RemoteFolder:FindFirstChild("BurpEvent")

if not BurpEvent then
    warn("Revenge Bot: Could not find BurpEvent inside RemoteEvents!")
    return
end

-- Config
local REVENGE_DISTANCE = 60 -- INCREASED RANGE: Tracks and jumps targets from far away
local DETECT_SPEED = 0.05   -- Rapid scanning speed

-- Teleport and face the target
local function teleportAndFace(targetCharacter)
    if not player.Character or not targetCharacter then return end
    local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    
    if myHRP and targetHRP then
        -- Offsets your teleport slightly (2 studs in front of them) so you face them perfectly
        local offset = targetHRP.CFrame.LookVector * 2
        local teleportPosition = targetHRP.Position + offset
        
        -- Teleports you and instantly locks your orientation to face them
        myHRP.CFrame = CFrame.new(teleportPosition, Vector3.new(targetHRP.Position.X, teleportPosition.Y, targetHRP.Position.Z))
    end
end

print("Long-Range Teleport Defense System Activated! Range: " .. tostring(REVENGE_DISTANCE) .. " studs.")

task.spawn(function()
    while true do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = player.Character.HumanoidRootPart
            
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = p.Character.HumanoidRootPart
                    local distance = (targetHRP.Position - myHRP.Position).Magnitude
                    
                    -- Triggered when they enter your long-range tracking zone
                    if distance <= REVENGE_DISTANCE then
                        -- 1. Teleport directly into their face
                        teleportAndFace(p.Character)
                        task.wait(0.02) -- Split-second delay for physics to register
                        
                        -- 2. Unleash the burp
                        pcall(function()
                            BurpEvent:FireServer() 
                        end)
                        
                        -- Break loop turn so it handles one person at a time per scan tick
                        break 
                    end
                end
            end
        end
        task.wait(DETECT_SPEED)
    end
end)
