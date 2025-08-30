--==============================
-- Avery Hub Full Optimized Script
--==============================

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")

--==============================
-- Kill Switch & Whitelist
--==============================
local url = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
local banlistUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"

local function isBanned(userId, banlist)
    for _, id in ipairs(banlist) do
        if id == userId then return true end
    end
    return false
end

local function isWhitelisted(userId, whitelist)
    for _, id in ipairs(whitelist) do
        if id == userId then return true end
    end
    return false
end

-- Fetch banlist
local banSuccess, banData = pcall(function()
    return HttpService:JSONDecode(game:HttpGet(banlistUrl, true))
end)

if banSuccess and banData then
    local banlist = banData.banned or {}
    if isBanned(player.UserId, banlist) then
        player:Kick("🚫 You are permanently banned from using this script.")
        return
    end
else
    warn("⚠️ Could not fetch banlist.")
end

-- Fetch kill switch
local enabled, whitelist = true, {}
local success, result = pcall(function()
    local response = game:HttpGet(url, true)
    return HttpService:JSONDecode(response)
end)

if success and result then
    enabled = result.enabled
    whitelist = result.whitelist or {}
    if not enabled and not isWhitelisted(player.UserId, whitelist) then
        player:Kick("Your UserID IS Not Whitelisted.")
        return
    end
else
    warn("⚠️ Failed to fetch kill switch status.")
end

-- Secondary check
if not enabled and not isWhitelisted(player.UserId, whitelist) then
    player:Kick("⚠️ Unauthorized user detected.")
    return
end

--==============================
-- Exploit Trap
--==============================
local trapRemote = ReplicatedStorage:WaitForChild("ExploitTrap", 1)
if trapRemote then trapRemote:FireServer() end

--==============================
-- GUI Library
--==============================
local lib = {}
function lib:Gui(title)
    local DarkLib = Instance.new("ScreenGui", CoreGui)
    DarkLib.Name = "DarkLib"
    DarkLib.ResetOnSpawn = false

    local Main = Instance.new("Frame", DarkLib)
    Main.Name = "Main"
    Main.BackgroundColor3 = Color3.fromRGB(35,35,35)
    Main.Position = UDim2.new(0.35,0,0.25,0)
    Main.Size = UDim2.new(0,382,0,219)

    -- Drag functionality
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(Main, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), 
            {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}
        ):Play()
    end
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    local TabSide = Instance.new("ScrollingFrame", Main)
    TabSide.Name = "TabSide"
    TabSide.BackgroundColor3 = Color3.fromRGB(30,30,30)
    TabSide.Position = UDim2.new(0.02,0,0.04,0)
    TabSide.Size = UDim2.new(0,92,0,203)
    TabSide.ScrollBarThickness = 5
    TabSide.ClipsDescendants = true

    local SectionSide = Instance.new("Frame", Main)
    SectionSide.Name = "SectionSide"
    SectionSide.BackgroundColor3 = Color3.fromRGB(30,30,30)
    SectionSide.Position = UDim2.new(0.3,0,0.15,0)
    SectionSide.Size = UDim2.new(0,255,0,173)
    SectionSide.ClipsDescendants = true

    local Tabs = {}
    function Tabs:Tab(name)
        local TextButton = Instance.new("TextButton", TabSide)
        TextButton.Text = name
        TextButton.Size = UDim2.new(0,70,0,30)
        local Sections = {}
        function Sections:Section(name)
            local Page = Instance.new("ScrollingFrame", SectionSide)
            Page.Name = name
            Page.Visible = false
            Page.Size = UDim2.new(0,237,0,145)
            Page.ScrollBarThickness = 5
            local Elements = {}
            function Elements:Toggle(name, callback)
                local Frame = Instance.new("Frame", Page)
                Frame.Size = UDim2.new(0,220,0,30)
                local Btn = Instance.new("TextButton", Frame)
                Btn.Size = UDim2.new(1,0,1,0)
                Btn.Text = name
                local toggle = false
                Btn.MouseButton1Click:Connect(function()
                    toggle = not toggle
                    pcall(callback, toggle)
                end)
            end
            function Elements:Button(name, callback)
                local Btn = Instance.new("TextButton", Page)
                Btn.Size = UDim2.new(0,220,0,30)
                Btn.Text = name
                Btn.MouseButton1Click:Connect(callback)
            end
            return Elements
        end
        return Sections
    end
    return Tabs
end

local Library = lib:Gui("⚡Avery-Hub⚡")
local AutoFarmTab = Library:Tab("AutoDrink")
local AutoFarm = AutoFarmTab:Section("AutoDrink")
local LocalPlayerTab = Library:Tab("LocalPlayer")
local LocalPlayer = LocalPlayerTab:Section("LocalPlayer")
local TeleportTab = Library:Tab("Teleports")
local Teleport = TeleportTab:Section("Teleport")
local MiscTab = Library:Tab("Misc")
local Misc = MiscTab:Section("Misc")
local ScriptsTab = Library:Tab("Scripts")
local Scripts = ScriptsTab:Section("Scripts")
local CreditsTab = Library:Tab("Credits")
local Credits = CreditsTab:Section("Credits")

--==============================
-- AutoDrink System (Optimized)
--==============================
local allDrinks = {
    "Starter Drink","Second Drink","Third Drink","Fourth Drink",
    "Fifth Drink","Sixth Drink","Seventh Drink","Eighth Drink",
    "Ninth Drink","Atomic Drink","Omega Burp Juice","Thunder Fizz","Garlic Juice"
}

AutoFarm:Toggle("Full Auto Drink", function(v)
    getgenv().fullAutoDrink = v
    spawn(function()
        while getgenv().fullAutoDrink do
            for _, drinkName in ipairs(allDrinks) do
                local drinkEvent = ReplicatedStorage:FindFirstChild("RemoteEvents") and ReplicatedStorage.RemoteEvents:FindFirstChild("DrinkEvent")
                if drinkEvent then
                    drinkEvent:FireServer(drinkName)
                end
            end
            task.wait(2.2)
        end
    end)
end)

--==============================
-- FPS Cap Toggle
--==============================
AutoFarm:Toggle("FPS Cap (90)", function(v)
    if setfpscap and type(setfpscap) == "function" then
        setfpscap(v and 90 or 999)
    end
end)

--==============================
-- Teleport System
--==============================
local function teleportToPlayer(target)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame
        end
    end
end

Teleport:Button("Teleport to Player", function()
    local playersList = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then table.insert(playersList, plr.Name) end
    end
    local targetName = playersList[1] -- pick first player
    local target = Players:FindFirstChild(targetName)
    teleportToPlayer(target)
end)

--==============================
-- LocalPlayer Utilities (WalkSpeed, Jump, Sit)
--==============================
LocalPlayer:Toggle("WalkSpeed", function(v)
    spawn(function()
        while v do
            task.wait()
            player.Character.Humanoid.WalkSpeed = 459
        end
    end)
end)

LocalPlayer:Toggle("Inf Jump", function(v)
    UserInputService.JumpRequest:Connect(function()
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end)
end)

LocalPlayer:Toggle("Sit", function(v)
    player.Character.Humanoid.Sit = v
end)

--==============================
-- Misc Utilities
--==============================
Misc:Button("Anti Kick", function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    local protect = newcclosure or protect_function
    setreadonly(mt,false)
    mt.__namecall = protect(function(self,...)
        if getnamecallmethod() == "Kick" then wait(9e9) return end
        return old(self,...)
    end)
    hookfunction(player.Kick, protect(function() wait(9e9) end))
end)

--==============================
-- Credits
--==============================
Credits:Button("Made By Avery")
Credits:Button("Discord: 90averyxx")
Credits:Button("Update: Added WhiteList System")

