local Library = loadstring(game:HttpGetAsync("https://github.com/ActualMasterOogway/Fluent-Renewed/releases/latest/download/Fluent.luau"))()
local SaveManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/SaveManager.luau"))()
local InterfaceManager = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ActualMasterOogway/Fluent-Renewed/master/Addons/InterfaceManager.luau"))()

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

local Window = Library:CreateWindow{
    Title = "Avery-Hub v2",
    SubTitle = "by Avery",
    TabWidth = 130,
    Size = UDim2.fromOffset(630, 425),
    Resize = true, -- Resize this ^ Size according to a 1920x1080 screen, good for mobile users but may look weird on some devices
    MinSize = Vector2.new(470, 380),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl -- Used when theres no MinimizeKeybind
}

-- Logic for farming. --
function AutoEquip()
    spawn(
        function()
            while getgenv().equip == true do
                task.wait(0.8)
                if game.Players.LocalPlayer.leaderstats["Burp points"].Value == 0 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Starter Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 0 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Starter Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 150 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Second Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end
                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 500 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Third Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 1600 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Fourth Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 3500 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Fifth Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 10000 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Sixth Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 25000 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Seventh Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 60000 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Eighth Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 150000 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Ninth Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 230000 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Atomic Drink")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 500000 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Omega Burp Juice")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end

                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 1000000 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Thunder Fizz")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end
                if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 2000000 then
                    local Players = game:GetService("Players")

                    local player = Players:FindFirstChildOfClass("Player")
                    if player and player.Character then
                        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                        if humanoid then
                            local tool = Players.LocalPlayer.Backpack:FindFirstChild("Garlic Juice")
                            if tool then
                                humanoid:EquipTool(tool)
                            end
                        end
                    end
                end
            end
end)
end

-- Sections go here. --
local FunStuff = {
    Fun = Window:CreateTab{
        Title = "Fun Stuff",
        Icon = "phosphor-smiley-bold"
    },
}

local Farming = {
    Farm = Window:CreateTab{
        Title = "Farming",
        Icon = "phosphor-piggy-bank-bold"
    },
}

local Player = {
    Main = Window:CreateTab{
        Title = "Player",
        Icon = "phosphor-user-bold"
    },
    Settings = Window:CreateTab{
        Title = "Settings",
        Icon = "settings"
    }
}

local Miscellaneous = {
    Misc = Window:CreateTab{
        Title = "Misc.",
        Icon = "phosphor-terminal-window-bold"
    },
}


local Options = Library.Options

Library:Notify{
    Title = "Script executed",
    Content = "Some features may be added or patched.",
    SubContent = "this script contains a whitelist system", -- Optional
    Duration = 5 -- Set to nil to make the notification not disappear
}

local Paragraph = Player.Main:CreateParagraph("Paragraph", {
    Title = "Basic stuff to mess with for the LocalPlayer.",
    Content = ""
})
Player.Main:CreateSection("")

local Slider = Player.Main:CreateSlider("Slider", {
    Title = "Walkspeed",
    Description = "Change the speed here.",
    Default = 2,
    Min = 16,
    Max = 1000,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

Slider:SetValue(3)

local Slider = Player.Main:CreateSlider("Slider", {
    Title = "Jump power",
    Description = "Change the jump power here.",
    Default = 3,
    Min = 50,
    Max = 1000,
    Rounding = 1,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

Slider:SetValue(3)
--Player tab end--


--FunStuff tab begin--
FunStuff.Fun:CreateSection("Burps")

FunStuff.Fun:CreateButton{
    Title = "Spam Birp Func",
    Description = "Once you begin burping, you cannot stop",
    Callback = function()
        Window:Dialog{
            Title = "Spam Burp",
            Content = "Are you sure you want to burp?",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        while true do
                        task.wait()
                        game:GetService("ReplicatedStorage").RemoteEvents.BurpEvent:FireServer()
                    end
                    end
                },
                {
                    Title = "Cancel",
                    Callback = function()
                        print("Cancelled the dialog.")
                    end
                }
            }
        }
    end
}

FunStuff.Fun:CreateSection("Teleport")

FunStuff.Fun:CreateButton{
    Title = "Teleport to safe zone",
    Description = "",
    Callback = function()
     local New_CFrame = CFrame.new(-46, 48, -15)

            local ts = game:GetService("TweenService")
            local char = game.Players.LocalPlayer.Character

            local part = char.HumanoidRootPart
            local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            local tp = {CFrame = New_CFrame}
            ts:Create(part, ti, tp):Play()
    end
}

FunStuff.Fun:CreateButton{
     Title = "Teleport to Pet Shop",
        Callback = function()
            local New_CFrame = CFrame.new(311, 52, 103)

            local ts = game:GetService("TweenService")
            local char = game.Players.LocalPlayer.Character

            local part = char.HumanoidRootPart
            local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            local tp = {CFrame = New_CFrame}
            ts:Create(part, ti, tp):Play()
        end
}

FunStuff.Fun:CreateButton{
   Title = "Teleport to Sky Island",
        Callback = function()
            local New_CFrame = CFrame.new(2117.87109375, 1470.884765625, -1050.54296875)

            local ts = game:GetService("TweenService")
            local char = game.Players.LocalPlayer.Character

            local part = char.HumanoidRootPart
            local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            local tp = {CFrame = New_CFrame}
            ts:Create(part, ti, tp):Play()
        end
}

FunStuff.Fun:CreateButton{
   Title = "Teleport to Hotel",
        Callback = function()
            local New_CFrame = CFrame.new(-1198.279052734375, 44.315752029418945, -5.583522319793701)

            local ts = game:GetService("TweenService")
            local char = game.Players.LocalPlayer.Character

            local part = char.HumanoidRootPart
            local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            local tp = {CFrame = New_CFrame}
            ts:Create(part, ti, tp):Play()
        end
}

FunStuff.Fun:CreateButton{
   Title = "Teleport to First Cloud",
        Callback = function()
            local New_CFrame = CFrame.new(296, 566, 689)

            local ts = game:GetService("TweenService")
            local char = game.Players.LocalPlayer.Character

            local part = char.HumanoidRootPart
            local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            local tp = {CFrame = New_CFrame}
            ts:Create(part, ti, tp):Play()
        end
}

FunStuff.Fun:CreateButton{
   Title = "Teleport to Second Cloud",
        Callback = function()
            local New_CFrame = CFrame.new(-1224, 557, -318)

            local ts = game:GetService("TweenService")
            local char = game.Players.LocalPlayer.Character

            local part = char.HumanoidRootPart
            local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
            local tp = {CFrame = New_CFrame}
            ts:Create(part, ti, tp):Play()
        end
}
--FunStuff tab end--


--Farming tab begin--
Farming.Farm:CreateSection("Farming")
local Toggle = Farming.Farm:CreateToggle("FarmToggle", {Title = "Toggle farm", Default = false })

Toggle:OnChanged(function(bool)
            getgenv().equip = bool
            if bool then
                AutoEquip()
            end
        end)

Farming.Farm:CreateButton{
   Title = "Auto-prestige",
        Callback = function()
             while true do
                task.wait(0.075)
                game.ReplicatedStorage.RemoteEvents.PrestigeEvent:FireServer()
            end
        end
}

Farming.Farm:CreateButton{
   Title = "Bp Counter",
        Callback = function()
            loadstring(game:HttpGet("https://pastefy.app/nqSs54Ez/raw"))()
        end
}


Farming.Farm:CreateSection("Drinks")
local Toggle = Farming.Farm:CreateToggle("Toggle1", {Title = "Starter Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Starter Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle2", {Title = "Second Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Second Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle3", {Title = "Third Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Third Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle4", {Title = "Fourth Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Fourth Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle5", {Title = "Fifth Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Fifth Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle6", {Title = "Sixth Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Sixth Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle7", {Title = "Seventh Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Seventh Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle8", {Title = "Eighth Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Eighth Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle9", {Title = "Ninth Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Ninth Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle10", {Title = "Atomic Drink", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Atomic Drink")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle11", {Title = "Omega Burp Juice", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Omega Burp Juice")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle12", {Title = "⚡ Thunder Fizz ⚡", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Thunder Fizz")
                    end
                end
            else
                _G.Print = false
            end
        end)

local Toggle = Farming.Farm:CreateToggle("Toggle13", {Title = "🧄 Garlic Juice 🧄", Default = false })

Toggle:OnChanged(function(Value)
            if Value then
                _G.Print = true
                while _G.Print do
                    while task.wait(2.4) do
                        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Garlic Juice")
                    end
                end
            else
                _G.Print = false
            end
        end)
-- Farming tab end --


-- Misc. tab begin --
local Paragraph = Miscellaneous.Misc:CreateParagraph("Paragraph", {
    Title = "Other options.",
    Content = ""
})
Miscellaneous.Misc:CreateSection("Client-sided settings")

Miscellaneous.Misc:CreateButton{
   Title = "Load Anti-afk remastered",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/juywvm/-Roblox-Projects-/main/____Anti_Afk_Remastered_______"))()
        end
}


Miscellaneous.Misc:CreateButton{
   Title = "Fps Booter",
        Callback = function()
            if setfpscap and type(setfpscap) == "function" then
                local num = 100000 or 1e6
                if num == "none" then
                    return setfpscap(1e6)
                elseif num > 0 then
                    return setfpscap(num)
                end
            end
        end
}

Miscellaneous.Misc:CreateButton{
   Title = "sky baseplate",
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7000, 22000, -5000)
            baseplatee = Instance.new("Part", workspace)
            baseplatee.Size = Vector3.new(1000, 1, 1000)
            baseplatee.CFrame =
                game.workspace[game.Players.LocalPlayer.Name].HumanoidRootPart.CFrame + Vector3.new(0, -2, 0)
            baseplatee.Anchored = true
        end
}

Miscellaneous.Misc:CreateButton{
   Title = "Client-sided Anti kick",
        Callback = function()
            Library:Notify{
    Title = "Anti kick enabled.",
    Content = "This should stop localscripts from kicking you.",
    SubContent = "Warning: this can be detected by some anti-cheats.", -- Optional
    Duration = 5 -- Set to nil to make the notification not disappear
}
local mt = getrawmetatable(game)
            local old = mt.__namecall
            local protect = newcclosure or protect_function

            setreadonly(mt, false)
            mt.__namecall =
                protect(
                function(self, ...)
                    local method = getnamecallmethod()
                    if method == "Kick" then
                        wait(9e9)
                        return
                    end
                    return old(self, ...)
                end
            )
            hookfunction(
                game.Players.LocalPlayer.Kick,
                protect(
                    function()
                        wait(9e9)
                    end
                )
            )
        end
}

Miscellaneous.Misc:CreateSection("”Admin” <-- Pick & choose")

Miscellaneous.Misc:CreateButton{
   Title = "Load Fate's Admin",
        Callback = function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/ZeroedCode/Executors/main/Fate%20Admin.lua"))()
        end
}

Miscellaneous.Misc:CreateButton{
   Title = "Load IY FE",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end
}

Miscellaneous.Misc:CreateButton{
   Title = "Load CMD-X",
        Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source"))()
        end
}



-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- InterfaceManager (Allows you to have a interface managment system)

-- Hand the library over to our managers
SaveManager:SetLibrary(Library)
InterfaceManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- You can add indexes of elements the save manager should ignore
SaveManager:SetIgnoreIndexes{}

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
InterfaceManager:SetFolder("FluentScriptHub")
SaveManager:SetFolder("FluentScriptHub/specific-game")

InterfaceManager:BuildInterfaceSection(Player.Settings)
SaveManager:BuildConfigSection(Player.Settings)


Window:SelectTab(1)

Library:Notify{
    Title = "Keybind",
    Content = "Press the Left Control key to hide or show the UI.",
    Duration = 5
}

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()
