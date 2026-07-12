

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer


local RemoteFolder = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
local BurpEvent = RemoteFolder and RemoteFolder:FindFirstChild("BurpEvent")

if not BurpEvent then
    warn("Revenge Bot: Could not find BurpEvent inside RemoteEvents!")
    return
end


local REVENGE_DISTANCE = 60 
local DETECT_SPEED = 0.05   


local function teleportAndFace(targetCharacter)
    if not player.Character or not targetCharacter then return end
    local myHRP = player.Character:FindFirstChild("HumanoidRootPart")
    local targetHRP = targetCharacter:FindFirstChild("HumanoidRootPart")
    
    if myHRP and targetHRP then
        
        local offset = targetHRP.CFrame.LookVector * 2
        local teleportPosition = targetHRP.Position + offset
        
        
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
                    
                    
                    if distance <= REVENGE_DISTANCE then
                      
                        teleportAndFace(p.Character)
                        task.wait(0.02) 
                        
                        
                        pcall(function()
                            BurpEvent:FireServer() 
                        end)
                        
                        
                        break 
                    end
                end
            end
        end
        task.wait(DETECT_SPEED)
    end
end)
