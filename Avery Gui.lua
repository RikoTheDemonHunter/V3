-- Avery Hub Full Optimized Script

-- Services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- URLs
local killSwitchUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
local banlistUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"

-- Safety Functions
local function isInList(userId, list)
	for _, id in ipairs(list or {}) do
		if id == userId then return true end
	end
	return false
end

-- Ban check
pcall(function()
	local banData = HttpService:JSONDecode(game:HttpGet(banlistUrl, true))
	if isInList(LocalPlayer.UserId, banData.banned) then
		LocalPlayer:Kick("🚫 You are permanently banned from using this script.")
	end
end)

-- Kill switch
local enabled, whitelist = false, {}
pcall(function()
	local data = HttpService:JSONDecode(game:HttpGet(killSwitchUrl, true))
	enabled = data.enabled
	whitelist = data.whitelist or {}
end)
if not enabled and not isInList(LocalPlayer.UserId, whitelist) then
	LocalPlayer:Kick("⚠️ Your UserID is not whitelisted.")
end

-- Exploit Trap Trigger
local trapRemote = ReplicatedStorage:FindFirstChild("ExploitTrap")
if trapRemote then trapRemote:FireServer() end

-- GUI Library
local function CreateGUI(title)
	local DarkLib = Instance.new("ScreenGui")
	DarkLib.Name = "DarkLib"
	DarkLib.Parent = game.CoreGui
	DarkLib.ResetOnSpawn = false

	local Main = Instance.new("Frame", DarkLib)
	Main.Size = UDim2.new(0, 382, 0, 219)
	Main.Position = UDim2.new(0.367, 0, 0.264, 0)
	Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

	local TabSide = Instance.new("ScrollingFrame", Main)
	TabSide.Size = UDim2.new(0, 92, 0, 203)
	TabSide.Position = UDim2.new(0.021,0,0.038,0)
	TabSide.BackgroundColor3 = Color3.fromRGB(30,30,30)
	TabSide.ScrollBarThickness = 5

	local SectionSide = Instance.new("Frame", Main)
	SectionSide.Size = UDim2.new(0, 255, 0, 173)
	SectionSide.Position = UDim2.new(0.298,0,0.146,0)
	SectionSide.BackgroundColor3 = Color3.fromRGB(30,30,30)

	local TitleLabel = Instance.new("TextLabel", Main)
	TitleLabel.Text = title
	TitleLabel.Size = UDim2.new(0, 200, 0, 46)
	TitleLabel.Position = UDim2.new(0,90,0,0)
	TitleLabel.Font = Enum.Font.FredokaOne
	TitleLabel.TextSize = 30
	TitleLabel.TextColor3 = Color3.fromRGB(255,0,0)

	-- Tab/Section system
	local Tabs = {}
	function Tabs:Tab(tabName)
		local btn = Instance.new("TextButton", TabSide)
		btn.Size = UDim2.new(0,70,0,30)
		btn.Text = tabName
		local Sections = {}
		function Sections:Section(secName)
			local page = Instance.new("ScrollingFrame", SectionSide)
			page.Name = secName
			page.Size = UDim2.new(0,237,0,145)
			page.BackgroundColor3 = Color3.fromRGB(30,30,30)
			page.Visible = false
			local Elements = {}
			function Elements:Button(name, callback)
				local btn = Instance.new("TextButton", page)
				btn.Size = UDim2.new(0,220,0,30)
				btn.Text = name
				btn.MouseButton1Click:Connect(callback)
			end
			function Elements:Toggle(name, callback)
				local frame = Instance.new("Frame", page)
				frame.Size = UDim2.new(0,220,0,30)
				local state = false
				local btn = Instance.new("TextButton", frame)
				btn.Size = UDim2.new(1,0,1,0)
				btn.Text = name
				btn.MouseButton1Click:Connect(function()
					state = not state
					pcall(callback,state)
				end)
			end
			return Elements
		end
		return Sections
	end
	return Tabs
end

local Library = CreateGUI("⚡Avery-Hub⚡")

-- AutoDrink Tab
local AutoDrinkTab = Library:Tab("AutoDrink")
local AutoDrink = AutoDrinkTab:Section("AutoDrink")

-- Auto Equip Function
local function AutoEquipDrink()
	spawn(function()
		for _, toolName in ipairs({
			"Starter Drink","Second Drink","Third Drink","Fourth Drink","Fifth Drink",
			"Sixth Drink","Seventh Drink","Eighth Drink","Ninth Drink","Atomic Drink",
			"Omega Burp Juice","Thunder Fizz","Garlic Juice"
		}) do
			local tool = LocalPlayer.Backpack:FindFirstChild(toolName)
			local humanoid = Character:FindFirstChildOfClass("Humanoid")
			if tool and humanoid then
				humanoid:EquipTool(tool)
			end
		end
	end)
end

-- Auto Drink Toggle
AutoDrink:Toggle("Auto Drink", function(v)
	spawn(function()
		while v do
			for _, drink in ipairs({
				"Starter Drink","Second Drink","Third Drink","Fourth Drink","Fifth Drink",
				"Sixth Drink","Seventh Drink","Eighth Drink","Ninth Drink","Atomic Drink",
				"Omega Burp Juice","Thunder Fizz","Garlic Juice"
			}) do
				ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer(drink)
			end
			task.wait(2.4)
		end
	end)
end)

AutoDrink:Toggle("Auto Equip", function(v)
	spawn(function()
		while v do
			AutoEquipDrink()
			task.wait(0.8)
		end
	end)
end)

-- Cloud Stand
local LocalPlayerTab = Library:Tab("LocalPlayer")
local LocalPlayerSection = LocalPlayerTab:Section("LocalPlayer")

LocalPlayerSection:Toggle("Cloud Stand", function(v)
	if v then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Cloud.lua"))()
	end
end)

-- WalkSpeed Toggle
LocalPlayerSection:Toggle("WalkSpeed", function(v)
	spawn(function()
		while v do
			Character:WaitForChild("Humanoid").WalkSpeed = 459
			task.wait(0.1)
		end
	end)
end)

-- Inf Jump
LocalPlayerSection:Toggle("Inf Jump", function(v)
	if v then
		UserInputService.JumpRequest:Connect(function()
			local humanoid = Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end
end)

-- Sit Toggle
LocalPlayerSection:Toggle("Sit", function(v)
	Character.Humanoid.Sit = v
end)

-- Teleport Tab
local TeleportTab = Library:Tab("Teleports")
local TeleportSection = TeleportTab:Section("Teleports")
local function TeleportTo(pos)
	local hrp = Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		TweenService:Create(hrp,TweenInfo.new(0.2),{CFrame=CFrame.new(pos)}):Play()
	end
end

-- Example teleport buttons
TeleportSection:Button("Safe Zone", function() TeleportTo(Vector3.new(-46,48,-15)) end)
TeleportSection:Button("Cloud One", function() TeleportTo(Vector3.new(296,566,689)) end)

-- Misc Tab
local MiscTab = Library:Tab("Misc")
local MiscSection = MiscTab:Section("Misc")

MiscSection:Toggle("Walk On Water", function(v)
	spawn(function()
		for _, part in pairs(workspace:GetChildren()) do
			if part:IsA("Part") and part.Color == Color3.fromRGB(9,137,207) then
				part.CanCollide = v
			end
		end
	end)
end)

MiscSection:Button("Anti AFK", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Anti%20Afk"))()
end)

MiscSection:Button("Anti Kick", function()
	local mt = getrawmetatable(game)
	local old = mt.__namecall
	local protect = newcclosure or protect_function
	setreadonly(mt,false)
	mt.__namecall = protect(function(self,...)
		if getnamecallmethod()=="Kick" then wait(9e9) return end
		return old(self,...)
	end)
	hookfunction(LocalPlayer.Kick,protect(function() wait(9e9) end))
end)

-- Credits Tab
local CreditsTab = Library:Tab("Credits")
local CreditsSection = CreditsTab:Section("Credits")
CreditsSection:Button("Made by Avery")
CreditsSection:Button("Discord: 90averyxx")
CreditsSection:Button("Note: Auto Drink is 2.4")

-- Script is ready to run
print("✅ Avery Hub loaded successfully")
