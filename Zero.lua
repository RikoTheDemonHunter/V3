-- LOAD ORIONLIB
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Orion%20Library.lua"))()

-- CREATE WINDOW
local Window = OrionLib:MakeWindow({
    Name = "⚡Avery-Hub⚡",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AveryHub"
})

-- TABS
local AutoDrinkTab = Window:MakeTab({Name = "AutoDrink", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local LocalPlayerTab = Window:MakeTab({Name = "LocalPlayer", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TeleportTab = Window:MakeTab({Name = "Teleports", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local ScriptsTab = Window:MakeTab({Name = "Scripts", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local CreditsTab = Window:MakeTab({Name = "Credits", Icon = "rbxassetid://4483345998", PremiumOnly = false})

-- AUTODRINK TOGGLES
AutoDrinkTab:AddToggle({
    Name = "Auto Drink",
    Default = false,
    Callback = function(Value)
        getgenv().AutoDrinkEnabled = Value
        if Value then
            spawn(function()
                while getgenv().AutoDrinkEnabled do
                    wait(2.4)
                    local drinks = {"Starter Drink","Second Drink","Third Drink","Fourth Drink","Fifth Drink","Sixth Drink","Seventh Drink","Eighth Drink","Ninth Drink","Atomic Drink","Omega Burp Juice","Thunder Fizz","Garlic Juice"}
                    for _, drink in pairs(drinks) do
                        pcall(function()
                            game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer(drink)
                        end)
                    end
                end
            end)
        end
    end
})

AutoDrinkTab:AddToggle({
    Name = "Auto Prestige",
    Default = false,
    Callback = function(Value)
        getgenv().AutoPrestige = Value
        if Value then
            spawn(function()
                while getgenv().AutoPrestige do
                    wait(0.8)
                    pcall(function()
                        game.ReplicatedStorage.RemoteEvents.PrestigeEvent:FireServer()
                    end)
                end
            end)
        end
    end
})

AutoDrinkTab:AddToggle({
    Name = "Auto Collect Gems",
    Default = false,
    Callback = function(Value)
        getgenv().AutoGem = Value
        if Value then
            spawn(function()
                while getgenv().AutoGem do
                    wait(0.6)
                    local gem = workspace:FindFirstChild("Diamonds") and workspace.Diamonds:FindFirstChild("Diamond")
                    local Char = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if gem and Char then
                        gem.CFrame = Char.CFrame
                    end
                end
            end)
        end
    end
})

-- LOCALPLAYER TOGGLES & BUTTONS
LocalPlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16,
    Max = 500,
    Default = 16,
    Color = Color3.fromRGB(0,255,0),
    Increment = 1,
    ValueName = "Speed",
    Callback = function(Value)
        local plr = game.Players.LocalPlayer
        if plr.Character then
            plr.Character:WaitForChild("Humanoid").WalkSpeed = Value
        end
    end
})

LocalPlayerTab:AddToggle({
    Name = "Inf Jump",
    Default = false,
    Callback = function(Value)
        getgenv().InfJump = Value
        if Value then
            game:GetService("UserInputService").JumpRequest:connect(function()
                local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

LocalPlayerTab:AddButton({
    Name = "Reset Character",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

LocalPlayerTab:AddButton({
    Name = "Rejoin",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})

LocalPlayerTab:AddToggle({
    Name = "Sit",
    Default = false,
    Callback = function(Value)
        getgenv().sit = Value
        local humanoid = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Sit = Value
        end
    end
})

-- TELEPORT BUTTONS
local Teleports = {
    ["Safe Zone"] = CFrame.new(-46,48,-15),
    ["Pet Shop"] = CFrame.new(311,52,103),
    ["Disco Island"] = CFrame.new(63,48,636),
    ["Cloud One"] = CFrame.new(296,566,689),
    ["Cloud Second"] = CFrame.new(-1224,557,-318),
    ["Sky Island"] = CFrame.new(2132,1456,-1034),
    ["SafePlace"] = CFrame.new(167,48.28,-5357),
    ["SafePlace v2"] = CFrame.new(0,3605,0),
    ["FavSpot"] = CFrame.new(60.12,18.25,-72),
    ["Water Spot"] = CFrame.new(-564,40,605),
    ["Hotel"] = CFrame.new(-1198.28,44.31,-5.58)
}

for Name, CFramePos in pairs(Teleports) do
    TeleportTab:AddButton({
        Name = Name,
        Callback = function()
            local char = game.Players.LocalPlayer.Character
            local ts = game:GetService("TweenService")
            local part = char:FindFirstChild("HumanoidRootPart")
            local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            ts:Create(part, ti, {CFrame = CFramePos}):Play()
        end
    })
end

-- MISC SCRIPTS
MiscTab:AddButton({Name = "Bp Counter", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Bp%20Counter.lua"))()
end})

MiscTab:AddButton({Name = "Infinity Yield", Callback = function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end})

MiscTab:AddButton({Name = "Anti Kick", Callback = function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    local protect = newcclosure or protect_function
    setreadonly(mt, false)
    mt.__namecall = protect(function(self, ...)
        if getnamecallmethod() == "Kick" then wait(9e9) return end
        return old(self, ...)
    end)
    hookfunction(game.Players.LocalPlayer.Kick, protect(function() wait(9e9) end))
end})

-- CREDITS
CreditsTab:AddLabel("Made By Avery")
CreditsTab:AddLabel("Discord: 90averyxx")
CreditsTab:AddLabel("Note: Auto Drink is 2.4")
CreditsTab:AddLabel("Note: Copy Stealers Fuck Off")
CreditsTab:AddLabel("Update: Added WhiteList System & Auto Spawn & Cloud Platform")

-- SCRIPTS TAB
ScriptsTab:AddButton({Name = "SimonHub", Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/SimonHub"))()
end})

ScriptsTab:AddButton({Name = "ZeroHub", Callback = function()
    loadstring(game:HttpGet("https://gist.githubusercontent.com/RikoTheDemonHunter/a1bf0423e73a5293c014042960cf4767/raw/faaa622081cbf015f0f54efb256e2ba182b57bca/shit.lua"))()
end})

-- SHOW THE WINDOW
OrionLib:Init()
