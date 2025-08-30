-- Avery Hub Optimized Full Version with Teleport, Misc, and Loader
-- Author: Avery

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- =====================
-- CONFIG / WHITELIST / KILL SWITCH
-- =====================
local killSwitchUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
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

-- Banlist
local success, banData = pcall(function()
    local response = game:HttpGet(banlistUrl, true)
    return HttpService:JSONDecode(response)
end)
if success and banData and isBanned(player.UserId, banData.banned or {}) then
    player:Kick("🚫 You are permanently banned from using this script.")
    return
end

-- Kill switch
local enabled, whitelist = false, {}
local ok, switchData = pcall(function()
    local resp = game:HttpGet(killSwitchUrl, true)
    return HttpService:JSONDecode(resp)
end)
if ok and switchData then
    enabled = switchData.enabled
    whitelist = switchData.whitelist or {}
end
if not enabled and not isWhitelisted(player.UserId, whitelist) then
    player:Kick("⚠️ Unauthorized user detected.")
    return
end

-- =====================
-- TRAP DETECTION
-- =====================
local trapRemote = ReplicatedStorage:FindFirstChild("ExploitTrap")
if trapRemote then
    trapRemote:FireServer()
end

-- =====================
-- GUI SETUP
-- =====================
local DarkLib = Instance.new("ScreenGui")
DarkLib.Name = "DarkLib"
DarkLib.ResetOnSpawn = false
DarkLib.Parent = game.CoreGui

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.BackgroundColor3 = Color3.fromRGB(35,35,35)
Main.Position = UDim2.new(0.367,0,0.263,0)
Main.Size = UDim2.new(0,382,0,219)
Main.Parent = DarkLib

-- Tab Side
local TabSide = Instance.new("ScrollingFrame")
TabSide.Name = "TabSide"
TabSide.BackgroundColor3 = Color3.fromRGB(30,30,30)
TabSide.Position = UDim2.new(0.021,0,0.038,0)
TabSide.Size = UDim2.new(0,92,0,203)
TabSide.ScrollBarThickness = 5
TabSide.ClipsDescendants = true
TabSide.Parent = Main
Instance.new("UICorner", TabSide).CornerRadius = UDim.new(0,8)

-- Section Side
local SectionSide = Instance.new("Frame")
SectionSide.Name = "SectionSide"
SectionSide.BackgroundColor3 = Color3.fromRGB(30,30,30)
SectionSide.Position = UDim2.new(0.298,0,0.146,0)
SectionSide.Size = UDim2.new(0,255,0,173)
SectionSide.ClipsDescendants = true
SectionSide.Parent = Main
Instance.new("UICorner", SectionSide).CornerRadius = UDim.new(0,8)

-- Drag function
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(Main, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)}):Play()
    end
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
end

-- Toggle GUI with LeftAlt
UserInputService.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.LeftAlt then
        DarkLib.Enabled = not DarkLib.Enabled
    end
end)

-- =====================
-- LIBRARY / TAB FUNCTION
-- =====================
local Library = {}
function Library:Tab(name)
    local tabButton = Instance.new("TextButton")
    tabButton.Size = UDim2.new(0,70,0,30)
    tabButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
    tabButton.Text = name
    tabButton.TextScaled = true
    tabButton.TextColor3 = Color3.fromRGB(0,255,0)
    tabButton.Font = Enum.Font.Highway
    tabButton.Parent = TabSide

    local tabPage = Instance.new("ScrollingFrame")
    tabPage.Size = UDim2.new(0,237,0,145)
    tabPage.Position = UDim2.new(0.047,0,0.104,0)
    tabPage.BackgroundColor3 = Color3.fromRGB(30,30,30)
    tabPage.ScrollBarThickness = 5
    tabPage.Visible = false
    tabPage.Parent = SectionSide
    local uiList = Instance.new("UIListLayout", tabPage)
    uiList.SortOrder = Enum.SortOrder.LayoutOrder
    uiList.Padding = UDim.new(0,10)

    tabButton.MouseButton1Click:Connect(function()
        for _,v in pairs(SectionSide:GetChildren()) do
            if v:IsA("ScrollingFrame") then v.Visible = false end
        end
        tabPage.Visible = true
    end)

    local sectionMT = {}
    function sectionMT:Toggle(name, callback)
        local frame = Instance.new("Frame", tabPage)
        frame.Size = UDim2.new(0,220,0,30)
        frame.BackgroundColor3 = Color3.fromRGB(35,35,35)
        local text = Instance.new("TextButton", frame)
        text.Size = UDim2.new(1,0,1,0)
        text.BackgroundTransparency = 1
        text.Text = name
        text.TextColor3 = Color3.fromRGB(0,255,0)
        text.Font = Enum.Font.Highway
        text.TextScaled = true
        local toggle = false
        local debounce = false
        local stateLabel = Instance.new("TextLabel", frame)
        stateLabel.Size = UDim2.new(0,40,1,0)
        stateLabel.BackgroundTransparency = 1
        stateLabel.TextColor3 = Color3.fromRGB(255,255,255)
        stateLabel.Text = ""
        text.MouseButton1Click:Connect(function()
            if debounce then return end
            debounce = true
            toggle = not toggle
            stateLabel.Text = toggle and "X" or ""
            pcall(callback,toggle)
            task.wait(0.25)
            debounce = false
        end)
    end
    function sectionMT:Button(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,220,0,30)
        btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(0,255,0)
        btn.Font = Enum.Font.Highway
        btn.TextScaled = true
        btn.Parent = tabPage
        btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end
    return sectionMT
end

-- =====================
-- CREATE TABS
-- =====================
local autoTab = Library:Tab("Auto")
local miscTab = Library:Tab("Misc")
local teleportTab = Library:Tab("Teleport")
local loaderTab = Library:Tab("Loader")

-- =====================
-- AUTO TAB
-- =====================
autoTab:Toggle("Auto Drink", function(v) getgenv().autodrink = v end)
autoTab:Toggle("Auto Equip Drink", function(v) getgenv().equipdrink = v end)
autoTab:Toggle("Auto Prestige", function(v) getgenv().autoprestige = v end)
autoTab:Toggle("Cloud Stand", function(v) getgenv().cloudstand = v end)
autoTab:Toggle("Walk On Water", function(v) getgenv().walkonwater = v end)

-- =====================
-- MISC TAB
-- =====================
miscTab:Toggle("Infinite Jump", function(v) getgenv().infjump = v end)
miscTab:Toggle("WalkSpeed", function(v) getgenv().walkspeed = v end)
miscTab:Toggle("Sit", function(v) getgenv().sit = v end)
miscTab:Toggle("Night Mode", function(v) getgenv().nightmode = v end)

-- =====================
-- TELEPORT TAB
-- =====================
teleportTab:Button("Spawn Area", function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(0,10,0) -- Example spawn location
    end
end)
teleportTab:Button("Shop", function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(50,10,50) -- Example shop
    end
end)

-- =====================
-- LOADER TAB
-- =====================
loaderTab:Button("Load User Script", function()
    local url = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/User's.lua"
    local success, result = pcall(function()
        loadstring(game:HttpGet(url))()
    end)
    if not success then warn("Failed to load user script:", result) end
end)

-- =====================
-- AUTO FUNCTIONS
-- =====================
-- Auto Drink
spawn(function()
    while task.wait(2.4) do
        if getgenv().autodrink then
            local drinks = {"Starter Drink","Second Drink","Third Drink","Fourth Drink","Fifth Drink","Sixth Drink","Seventh Drink","Eighth Drink","Ninth Drink","Atomic Drink","Omega Burp Juice","Thunder Fizz","Garlic Juice"}
            for _, drink in ipairs(drinks) do
                pcall(function() ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer(drink) end)
            end
        end
    end
end)

-- Auto Equip
spawn(function()
    while task.wait(5) do
        if getgenv().equipdrink then
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            local stats = player:FindFirstChild("leaderstats")
            if hum and stats then
                local drinks = {
                    {150,"Second Drink"},{600,"Third Drink"},{1600,"Fourth Drink"},{3500,"Fifth Drink"},
                    {10000,"Sixth Drink"},{25000,"Seventh Drink"},{60000,"Eighth Drink"},{150000,"Ninth Drink"},
                    {230000,"Atomic Drink"},{500000,"Omega Burp Juice"},{1000000,"Thunder Fizz"},{2000000,"Garlic Juice"}
                }
                for _,d in ipairs(drinks) do
                    if stats["Burp points"].Value >= d[1] then
                        local tool = player.Backpack:FindFirstChild(d[2]) or player.Character:FindFirstChild(d[2])
                        if tool then hum:EquipTool(tool) end
                    end
                end
            end
        end
    end
end)

-- Cloud Stand & Walk On Water
spawn(function()
    while task.wait(0.5) do
        if player.Character then
            if getgenv().cloudstand then
                for _,v in pairs(workspace:GetChildren()) do
                    if v:IsA("Part") and v.Name:lower():find("cloud") then
                        v.Anchored = true
                        v.CanCollide = true
                    end
                end
            end
            if getgenv().walkonwater then
                for _,v in pairs(workspace:GetChildren()) do
                    if v:IsA("Part") and v.Color == Color3.fromRGB(9,137,207) then
                        v.CanCollide = true
                    end
                end
            end
        end
    end
end)

-- Auto Prestige
spawn(function()
    while task.wait(0.8) do
        if getgenv().autoprestige then
            pcall(function() ReplicatedStorage.RemoteEvents.PrestigeEvent:FireServer() end)
        end
    end
end)

-- Local Player updates
spawn(function()
    while task.wait(0.1) do
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            if getgenv().walkspeed then hum.WalkSpeed = 459 end
            if getgenv().infjump then hum.JumpPower = 100 end
            if getgenv().sit then hum.Sit = true end
        end
        game.Lighting.ClockTime = getgenv().nightmode and 0 or 14
    end
end)

print("✅ Avery Hub Full Version Loaded with Tabs, Teleports, Loader, and Misc!")
