getgenv().users = {
  ["Riko"] = 1497286101,
 
}



local whitelist = { "macmacinRoblox", "Rikothedev12", } 
 
local Players = game:GetService("Players")
local player = Players.LocalPlayer -- 
 
local function isWhitelisted(name)
    for _, whitelistedName in ipairs(whitelist) do
        if name == whitelistedName then
            return true
        end
    end
    return false
end
 
if not isWhitelisted(player.Name) then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Access Denied";
        Text = "You are not whitelisted Dumbass!";
        Duration = 5;
    })
    script.Parent:Destroy() -- 
    return
end
 
print("Access granted to " .. player.Name)





local Players = game:GetService("Players")
local player = Players.LocalPlayer 

-- Whitelisted UserIds only works for this  type of users
local whitelist = {
    [1497286101] = true,
    [4441876607] = true,
   
}

-- Check if player is whitelisted
local function isWhitelisted(userId)
    return whitelist[userId] == true
end

-- If not whitelisted, your access has been denied
if not isWhitelisted(player.UserId) then
    return

-- this script is automated by my bot
end

-- For whitelisted users only
print("Access granted. To" .. player.Name)
