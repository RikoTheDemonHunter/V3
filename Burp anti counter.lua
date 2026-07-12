-- Burping Simulator Confirmed Auto-Aim Bot (Put in Executor)
-- Spams anyone who enters your personal space using your exact folder path.

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
local REVENGE_DISTANCE = 12 -- How close someone must get to trigger your defense loop
local DETECT_SPEED = 0.05    -- Rapid scanning speed (instantly catches them)

-- Helper to turn your character directly toward the target
local function faceTarget(targetCharacter)
    if not player.Character or not targetCharacter then return end
    local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    
    if myHRP and targetHRP then
        -- Snaps your body's orientation right at them
        myHRP.CFrame = CFrame.new(myHRP.Position, Vector3.new(targetHRP.Position.X, myHRP.Position.Y, targetHRP.Position.Z))
    end
end

print("Auto-Aim Personal Defense Bot Activated!")

task.spawn(function()
    while true do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = player.Character.HumanoidRootPart
            
            for _, p in ipairs(Players:GetPlayers()) do
                -- Don't target yourself, check if they have a spawned body
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHRP = p.Character.HumanoidRootPart
                    local distance = (targetHRP.Position - myHRP.Position).Magnitude
                    
                    -- The moment they step into your bubble to attack you
                    if distance <= REVENGE_DISTANCE then
                        -- Snap around and face them
                        faceTarget(p.Character)
                        
                        -- Fire your working spam event right at them!
                        pcall(function()
                            BurpEvent:FireServer() 
                        end)
                    end
                end
            end
        end
        task.wait(DETECT_SPEED)
    end
end)
