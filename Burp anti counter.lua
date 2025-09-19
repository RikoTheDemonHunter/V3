-- Burp_Client.lua (StarterPlayerScripts)
-- Combined sender + receiver (no sound/animation). Press B to burp nearest player.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    warn("Burp_Client: no LocalPlayer found (script not running as LocalScript?).")
    return
end

-- Wait for RemoteEvents folder (server should create it)
local remoteFolder = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
if not remoteFolder then
    warn("Burp_Client: RemoteEvents folder not found in ReplicatedStorage. Server must create it.")
    return
end

local BurpRequest = remoteFolder:FindFirstChild("BurpEvent")
local BurpAction  = remoteFolder:FindFirstChild("BurpAction")
if not (BurpRequest and BurpRequest:IsA("RemoteEvent") and BurpAction and BurpAction:IsA("RemoteEvent")) then
    warn("Burp_Client: BurpEvent or BurpAction RemoteEvent missing. Server must create them.")
    return
end

-- Helper: safe HRP finder
local function getHRP(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("LowerTorso")
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
end

-- Find nearest player within distance
local MAX_TARGET_DISTANCE = 100
local function getNearestPlayer(maxDistance)
    maxDistance = maxDistance or MAX_TARGET_DISTANCE
    if not player.Character then return nil end
    local myHRP = getHRP(player.Character)
    if not myHRP then return nil end

    local nearest, nearestDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Parent then
            local hrp = getHRP(p.Character)
            if hrp then
                local d = (hrp.Position - myHRP.Position).Magnitude
                if d < nearestDist and d <= maxDistance then
                    nearestDist = d
                    nearest = p
                end
            end
        end
    end
    return nearest
end

-- Input: press B to burp
local LOCAL_INPUT_COOLDOWN = 0.75
local lastInput = 0
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.B then
        if tick() - lastInput < LOCAL_INPUT_COOLDOWN then return end
        lastInput = tick()

        local target = getNearestPlayer()
        if target then
            local ok, err = pcall(function()
                BurpRequest:FireServer(target.UserId)
            end)
            if not ok then
                warn("Burp_Client: Failed to fire BurpEvent:", tostring(err))
            end
        else
            -- Optional feedback: no nearby target
            -- print("No valid target nearby to burp.")
        end
    end
end)

-- Receiver: when server notifies you that you were burped
local LOCAL_RECEIVE_COOLDOWN = 0.5
local lastHandled = 0
BurpAction.OnClientEvent:Connect(function(payload)
    if type(payload) ~= "table" then return end
    if payload.type == "burped" then
        if tick() - lastHandled < LOCAL_RECEIVE_COOLDOWN then return end
        lastHandled = tick()
        -- Minimal: no animation/sound. This is where you could add UI cues if wanted.
        -- Example debug:
        -- print("You were burped by", payload.sourceUserId)
    elseif payload.type == "targetTeleported" then
        -- Optional: source confirmation handler
        -- print("Target teleported:", payload.targetUserId)
    end
end)
