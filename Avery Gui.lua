-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer

-- URLs
local switcherUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
local banlistUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"

-- Helper Functions
local function isInList(userId, list)
	for _, id in ipairs(list or {}) do
		if id == userId then return true end
	end
	return false
end

-- Fetch Banlist
local banData
pcall(function()
	local response = game:HttpGet(banlistUrl, true)
	banData = HttpService:JSONDecode(response)
end)

if banData and isInList(player.UserId, banData.banned) then
	player:Kick("🚫 You are permanently banned from using this script.")
	return
end

-- Fetch Kill Switch
local switchData
pcall(function()
	local response = game:HttpGet(switcherUrl, true)
	switchData = HttpService:JSONDecode(response)
end)

local enabled = switchData and switchData.enabled
local whitelist = switchData and switchData.whitelist

if enabled == false and not isInList(player.UserId, whitelist) then
	player:Kick("Your UserID is not whitelisted.")
	return
end

-- Exploit Trap Trigger
local trapRemote = ReplicatedStorage:FindFirstChild("ExploitTrap")
if trapRemote then
	pcall(function()
		trapRemote:FireServer()
	end)
end

-- GUI
local lib = {}
function lib:Gui(title)
	local DarkLib = Instance.new("ScreenGui")
	DarkLib.Name = "DarkLib"
	DarkLib.Parent = game.CoreGui
	DarkLib.ResetOnSpawn = false

	local Main = Instance.new("Frame", DarkLib)
	Main.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Main.Position = UDim2.new(0.367,0,0.264,0)
	Main.Size = UDim2.new(0,382,0,219)

	local TabSide = Instance.new("ScrollingFrame", Main)
	TabSide.BackgroundColor3 = Color3.fromRGB(30,30,30)
	TabSide.Position = UDim2.new(0.021,0,0.038,0)
	TabSide.Size = UDim2.new(0,92,0,203)
	TabSide.ScrollBarThickness = 5
	local UIListLayout_1 = Instance.new("UIListLayout", TabSide)
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.Padding = UDim.new(0,10)
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

	local SectionSide = Instance.new("Frame", Main)
	SectionSide.BackgroundColor3 = Color3.fromRGB(30,30,30)
	SectionSide.Position = UDim2.new(0.298,0,0.146,0)
	SectionSide.Size = UDim2.new(0,255,0,173)
	local SectionCorner = Instance.new("UICorner", SectionSide)

	local Title = Instance.new("TextLabel", Main)
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,90,0,0)
	Title.Size = UDim2.new(0,200,0,46)
	Title.Font = Enum.Font.FredokaOne
	Title.TextColor3 = Color3.fromRGB(255,0,0)
	Title.TextSize = 30
	Title.Text = title

	local Tabs = {}

	function Tabs:Tab(name)
		local TextButton = Instance.new("TextButton", TabSide)
		TextButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
		TextButton.Size = UDim2.new(0,70,0,30)
		TextButton.Font = Enum.Font.Highway
		TextButton.TextColor3 = Color3.fromRGB(0,255,0)
		TextButton.Text = name

		local Sections = {}
		function Sections:Section(name)
			local Page = Instance.new("ScrollingFrame", SectionSide)
			Page.Size = UDim2.new(0,237,0,145)
			Page.BackgroundColor3 = Color3.fromRGB(30,30,30)
			Page.ScrollBarThickness = 5
			local UIListLayout = Instance.new("UIListLayout", Page)
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0,10)

			TextButton.MouseButton1Click:Connect(function()
				for i,v in pairs(SectionSide:GetChildren()) do
					if v:IsA("ScrollingFrame") then
						v.Visible = false
					end
				end
				Page.Visible = true
			end)

			local Elements = {}

			function Elements:Toggle(name, callback)
				local ToggleElement = Instance.new("Frame", Page)
				ToggleElement.Size = UDim2.new(0,220,0,30)
				ToggleElement.BackgroundColor3 = Color3.fromRGB(35,35,35)
				local ToggleState = Instance.new("TextLabel", ToggleElement)
				ToggleState.Size = UDim2.new(0,46,0,30)
				ToggleState.BackgroundTransparency = 1
				ToggleState.TextColor3 = Color3.fromRGB(255,255,255)
				ToggleState.TextScaled = true
				local Click = Instance.new("TextButton", ToggleElement)
				Click.Size = UDim2.new(0,220,0,30)
				Click.BackgroundTransparency = 1
				Click.Text = name
				Click.TextColor3 = Color3.fromRGB(0,255,0)
				Click.TextScaled = true

				local toggle = false
				local debounce = false
				Click.MouseButton1Click:Connect(function()
					if debounce then return end
					debounce = true
					toggle = not toggle
					ToggleState.Text = toggle and "X" or ""
					pcall(callback,toggle)
					wait(0.2)
					debounce = false
				end)
			end

			function Elements:Button(name,callback)
				local btn = Instance.new("TextButton", Page)
				btn.Size = UDim2.new(0,220,0,30)
				btn.BackgroundColor3 = Color3.fromRGB(35,35,35)
				btn.Text = name
				btn.TextColor3 = Color3.fromRGB(0,255,0)
				btn.TextScaled = true
				btn.MouseButton1Click:Connect(callback)
			end

			return Elements
		end
		return Sections
	end
	return Tabs
end

-- Create Library
local Library = lib:Gui("⚡Avery-Hub⚡")

-- Tabs
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

-- Auto Equip / Auto Drink Optimized
local function AutoEquipDrink()
	coroutine.wrap(function()
		local backpack = player.Backpack
		local char = player.Character
		if not char then return end
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end
		local drinks = {"Starter Drink","Second Drink","Third Drink","Fourth Drink","Fifth Drink","Sixth Drink","Seventh Drink","Eighth Drink","Ninth Drink","Atomic Drink","Omega Burp Juice","Thunder Fizz","Garlic Juice"}
		for _,drinkName in ipairs(drinks) do
			local tool = backpack:FindFirstChild(drinkName) or char:FindFirstChild(drinkName)
			if tool then
				pcall(function() humanoid:EquipTool(tool) end)
			end
		end
	end)()
end

-- Auto Drink Toggle
AutoFarm:Toggle("Auto Drink", function(v)
	getgenv().autoDrink = v
	coroutine.wrap(function()
		while getgenv().autoDrink do
			pcall(function()
				local drinkEvent = ReplicatedStorage.RemoteEvents:FindFirstChild("DrinkEvent")
				if drinkEvent then
					for _, drinkName in ipairs({"Starter Drink","Second Drink","Third Drink","Fourth Drink","Fifth Drink","Sixth Drink","Seventh Drink","Eighth Drink","Ninth Drink","Atomic Drink","Omega Burp Juice","Thunder Fizz","Garlic Juice"}) do
						drinkEvent:FireServer(drinkName)
					end
				end
			end)
			wait(2.4)
		end
	end)()
end)

-- Auto Equip Toggle
AutoFarm:Toggle("Auto Equip", function(v)
	getgenv().equipDrink = v
	coroutine.wrap(function()
		while getgenv().equipDrink do
			AutoEquipDrink()
			wait(0.8)
		end
	end)()
end)

-- Cloud Stand Toggle
LocalPlayer:Toggle("Cloud Stand", function(v)
	getgenv().cloudStand = v
	if v then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Cloud.lua"))()
	end
end)

-- Example Teleport Button
Teleport:Button("Safe Zone", function()
	local char = player.Character
	if char then
		local hrp = char:WaitForChild("HumanoidRootPart")
		TweenService:Create(hrp,TweenInfo.new(0.2,Enum.EasingStyle.Linear),{CFrame=CFrame.new(-46,48,-15)}):Play()
	end
end)

-- Walk On Water Toggle
Misc:Toggle("Walk On Water", function(bool)
	getgenv().walkOnWater = bool
	for _,v in pairs(workspace:GetChildren()) do
		if v:IsA("Part") and v.Color == Color3.fromRGB(9,137,207) then
			v.CanCollide = bool
		end
	end
end)

-- Credits
Credits:Button("Made By Avery")
Credits:Button("Discord: 90averyxx")

-- Add more buttons/toggles as needed...
