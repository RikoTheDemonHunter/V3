-- BurpReceiver.lua
-- Minimal: respond to being "burped" with no sound or animation.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local remoteFolder = ReplicatedStorage:WaitForChild("RemoteEvents")
local BurpAction = remoteFolder:WaitForChild("BurpAction")

-- tiny local cooldown to avoid repeated processing if server fires quickly
local LOCAL_COOLDOWN = 0.5
local lastHandled = 0

BurpAction.OnClientEvent:Connect(function(payload)
    if type(payload) ~= "table" then return end
    if payload.type == "burped" then
        if tick() - lastHandled < LOCAL_COOLDOWN then return end
        lastHandled = tick()

print("You were burped by", payload.sourceUserId)
            
    end
end)
