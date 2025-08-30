-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer

-- URLs
local switcherUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
local banlistUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"

-- Utility
local function SafeLoad(url)
    pcall(function() loadstring(game:HttpGet(url))() end)
end

local function AutoEquipDrink()
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local backpack = player:WaitForChild("Backpack")
    local drinks = {"Starter Drink","Second Drink","Third Drink","Fourth Drink","Fifth Drink",
                    "Sixth Drink","Seventh Drink","Eighth Drink","Ninth Drink",
                    "Atomic Drink","Omega Burp Juice","Thunder Fizz","Garlic Juice"}
    for _, drink in pairs(drinks) do
        local tool = backpack:FindFirstChild(drink) or char:FindFirstChild(drink)
        if tool then humanoid:EquipTool(tool) end
    end
end

-- Ban + Kill switch
do
    local success, data = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(banlistUrl))
    end)
    if success and data then
        for _, id in ipairs(data.banned or {}) do
            if id == player.UserId then
                player:Kick("🚫 You are banned from this script.")
                return
            end
        end
    end
end

do
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(switcherUrl))
    end)
    if success and result then
        if not result.enabled then
            local whitelist = result.whitelist or {}
            local authorized = false
            for _, id in ipairs(whitelist) do
                if id == player.UserId then authorized = true end
            end
            if not authorized then
                player:Kick("⛔ Unauthorized user.")
                return
            end
        end
    end
end

-- Exploit trap
local trapRemote = ReplicatedStorage:FindFirstChild("ExploitTrap")
if trapRemote then trapRemote:FireServer() end

-- GUI Library
local lib = {}
function lib:Gui(title)
    local screenGui = Instance.new("ScreenGui", CoreGui)
    screenGui.Name = "AveryScriptGUI"
    screenGui.ResetOnSpawn = false

    local main = Instance.new("Frame", screenGui)
    main.Size = UDim2.new(0,400,0,250)
    main.Position = UDim2.new(0.3,0,0.3,0)
    main.BackgroundColor3 = Color3.fromRGB(35,35,35)
    main.ClipsDescendants = true

    -- Drag
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                  startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    main.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then update(input) end
    end)

    -- Title
    local titleLabel = Instance.new("TextLabel", main)
    titleLabel.Size = UDim2.new(0,400,0,40)
    titleLabel.Position = UDim2.new(0,0,0,0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.Font = Enum.Font.FredokaOne
    titleLabel.TextColor3 = Color3.fromRGB(255,0,0)
    titleLabel.TextScaled = true

    -- Section container
    local sectionFrame = Instance.new("Frame", main)
    sectionFrame.Position = UDim2.new(0,10,0,50)
    sectionFrame.Size = UDim2.new(0,380,0,190)
    sectionFrame.BackgroundTransparency = 1

    local layout = Instance.new("UIListLayout", sectionFrame)
    layout.Padding = UDim.new(0,10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder

    local elements = {}

    function elements:Toggle(name, callback)
        local frame = Instance.new("Frame", sectionFrame)
        frame.Size = UDim2.new(0,360,0,30)
        frame.BackgroundColor3 = Color3.fromRGB(45,45,45)
        frame.ClipsDescendants = true

        local label = Instance.new("TextLabel", frame)
        label.Size = UDim2.new(0,300,0,30)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.fromRGB(255,255,255)
        label.Font = Enum.Font.SourceSansBold
        label.TextScaled = true

        local state = false
        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(0,60,0,30)
        btn.Position = UDim2.new(0,300,0,0)
        btn.BackgroundColor3 = Color3.fromRGB(0,150,0)
        btn.Text = "OFF"
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextScaled = true

        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = state and "ON" or "OFF"
            btn.BackgroundColor3 = state and Color3.fromRGB(0,150,0) or Color3.fromRGB(150,0,0)
            callback(state)
        end)
    end

    return elements
end

-- Build GUI
local Window = lib:Gui("Avery Script")

local mainTab = Window
-- Main Section Toggles
mainTab:Toggle("Auto Drink", function(v)
    if v then
        spawn(function()
            while true do
                task.wait(2.4)
                local drinks = {"Starter Drink","Second Drink","Third Drink","Fourth Drink","Fifth Drink",
                                "Sixth Drink","Seventh Drink","Eighth Drink","Ninth Drink",
                                "Atomic Drink","Omega Burp Juice","Thunder Fizz","Garlic Juice"}
                for _, drink in ipairs(drinks) do
                    pcall(function() game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer(drink) end)
                end
            end
        end)
    end
end)

mainTab:Toggle("Auto Equip Drink", function(v)
    if v then spawn(AutoEquipDrink) end
end)

mainTab:Toggle("Cloud Stand", function(v)
    if v then SafeLoad("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Cloud.lua") end
end)

mainTab:Toggle("Fast Drink", function(v)
    if v then SafeLoad("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/FastDrink.lua") end
end)

mainTab:Toggle("Teleport GUI", function(v)
    if v then SafeLoad("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Teleport.lua") end
end)

mainTab:Toggle("LocalPlayer Tweaks", function(v)
    if v then SafeLoad("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/LocalPlayer.lua") end
end)

mainTab:Toggle("Misc Scripts", function(v)
    if v then SafeLoad("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Misc.lua") end
end)

print("✅ Full Avery Script loaded successfully.")
