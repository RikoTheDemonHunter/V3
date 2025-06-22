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
