-- Burping Simulator Blind Network Hook (Put in Executor)
-- Listens to EVERY remote event simultaneously to find the attacker

local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then return end

print("Omni-Hook Active. Monitoring all game traffic... Stand still and let someone burp you!")

-- Keep track of every event we hook onto so we don't duplicate them
local hookedRemotes = {}

local function hookRemote(remote)
    if not remote:IsA("RemoteEvent") or hookedRemotes[remote] then return end
    hookedRemotes[remote] = true
    
    -- Listen to data coming from this remote
    remote.OnClientEvent:Connect(function(...)
        local args = {...}
        
        -- Look inside the game data packet for any Player User IDs
        for _, arg in ipairs(args) do
            local potentialTargetId = nil
            
            if type(arg) == "table" then
                -- Check common dictionary keys developers use for attackers
                potentialTargetId = arg.sourceUserId or arg.attacker or arg.UserId or arg.Sender
            elseif type(arg) == "number" and arg > 1000 then
                -- If the game just sends a raw User ID number
                potentialTargetId = arg
            end
            
            -- If we found an ID and it's NOT you, it's the attacker!
            if potentialTargetId and potentialTargetId ~= player.UserId then
                -- Verify it's a real player in your server
                if Players:GetPlayerByUserId(potentialTargetId) then
                    print("Intercepted attacker ID (" .. tostring(potentialTargetId) .. ") on Remote: " .. remote.Name)
                    
                    -- Fire back immediately on the same channel!
                    pcall(function()
                        remote:FireServer(potentialTargetId)
                    end)
                    return
                end
            end
        end
    end)
end

-- Scan existing game remotes
for _, obj in ipairs(game:GetDescendants()) do
    pcall(hookRemote, obj)
end

-- Watch for any new remotes the game creates while you play
game.DescendantAdded:Connect(function(obj)
    pcall(hookRemote, obj)
end)
