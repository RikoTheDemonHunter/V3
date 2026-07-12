-- Burping Simulator Real Counter-Bot (Put in Executor)
-- Detects who burped you via network events and instantly fires back on the server.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
if not player then return end

-- Locate the real events from Burping Simulator
local BurpEvent = ReplicatedStorage:FindFirstChild("BurpEvent")
local BurpAction = ReplicatedStorage:FindFirstChild("BurpAction")

if not (BurpEvent and BurpAction) then
    warn("Revenge Bot: Missing game remotes. The game may have updated.")
    return
end

print("Anti-Burp Revenge System Online. Waiting for attackers...")

-- Listen to incoming game data sent to your client
BurpAction.OnClientEvent:Connect(function(payload)
    -- Check if the game is telling us someone burped us
    if type(payload) == "table" and payload.type == "burped" then
        local attackerId = payload.sourceUserId
        
        if attackerId and attackerId ~= player.UserId then
            local attacker = Players:GetPlayerByUserId(attackerId)
            local attackerName = attacker and attacker.Name or "Unknown Player"
            
            print("You were burped by " .. attackerName .. "! Launching counter-attack...")
            
            -- Instantly retaliate through the server
            pcall(function()
                -- Fires your burp event directly back at the offender's ID
                BurpEvent:FireServer(attackerId) 
            end)
        end
    end
end)
