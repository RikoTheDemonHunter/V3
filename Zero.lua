--========================================================
-- 🔒 WHITELIST / BANLIST / KILL SWITCH
--========================================================
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function fetchJSON(url)
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    return success and result or nil
end

-- Kill switch
local switchData = fetchJSON("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json")
if switchData and switchData.Enabled == false then
    LocalPlayer:Kick("Script disabled by owner.")
    return
end

-- Banlist
local banData = fetchJSON("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json")
if banData and table.find(banData.BannedUsers, LocalPlayer.UserId) then
    LocalPlayer:Kick("You are banned from using this script.")
    return
end

-- Whitelist
local whitelistData = fetchJSON("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json")
if whitelistData and not table.find(whitelistData.WhitelistedUsers, LocalPlayer.UserId) then
    LocalPlayer:Kick("You are not whitelisted to use this script.")
    return
end

-- Exploit trap
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local trapRemote = ReplicatedStorage:FindFirstChild("ExploitTrap")
if trapRemote then
    trapRemote:FireServer()
end

--========================================================
-- 🎨 MODERN GUI CREATION
--========================================================
local UIS = game:GetService("UserInputService")
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- Title Bar
local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleBar.Text = "Custom Script Hub"
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.TextSize = 18
TitleBar.Font = Enum.Font.GothamBold
TitleBar.Parent = MainFrame
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12)

-- Tab Buttons Holder
local TabHolder = Instance.new("Frame")
TabHolder.Size = UDim2.new(1, 0, 0, 30)
TabHolder.Position = UDim2.new(0, 0, 0, 30)
TabHolder.BackgroundTransparency = 1
TabHolder.Parent = MainFrame

-- Content Frame
local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -20, 1, -70)
ContentFrame.Position = UDim2.new(0, 10, 0, 60)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Create Tabs
local Tabs = {}
local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = TabHolder
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ContentFrame

    Tabs[name] = {Button = btn, Page = page}
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Page.Visible = false end
        page.Visible = true
    end)
    return page
end

-- Create Tab Pages
local MainTab = createTab("Main")
local TeleportTab = createTab("Teleports")
local PlayerTab = createTab("Player Mods")
local FunTab = createTab("Fun Stuff")

-- Position Tab Buttons
local offset = 0
for _, t in pairs(Tabs) do
    t.Button.Position = UDim2.new(0, offset, 0, 0)
    offset = offset + 105
end

--========================================================
-- ⚙ FEATURES (WIRED TO BUTTONS)
--========================================================
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 150, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Example features (replace with your real ones)
createButton(MainTab, "Auto Drink", function()
    print("Auto Drink Enabled")
    -- Your auto drink logic here
	while wait(2.4) do 
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Starter Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Second Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Third Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Fourth Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Fifth Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Sixth Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Seventh Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Eighth Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Ninth Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Atomic Drink")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Omega Burp Juice")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Thunder Fizz")
		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Garlic Juice")

	end
end)
end).Position = UDim2.new(0, 10, 0, 10)

createButton(TeleportTab, "Teleport to Spawn", function()
    LocalPlayer.Character:MoveTo(Vector3.new(0, 5, 0))
end).Position = UDim2.new(0, 10, 0, 10)

createButton(PlayerTab, "Set WalkSpeed 50", function()
    LocalPlayer.Character.Humanoid.WalkSpeed = 50
end).Position = UDim2.new(0, 10, 0, 10)

createButton(FunTab, "Spam Burp", function()
    print("Burp spam started")
    -- Your burp spam code here
function()
	   while true do
                        task.wait()
                        game:GetService("ReplicatedStorage").RemoteEvents.BurpEvent:FireServer()
                    end
                    end)

end).Position = UDim2.new(0, 10, 0, 10)

-- Show first tab by default
Tabs["Main"].Page.Visible = true

-- Hotkey to toggle GUI
UIS.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightControl then
        MainFrame.Visible = not MainFrame.Visible
    end
end)
