-- SERVICES
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- URLS
local killSwitchUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
local banlistUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"

-- FUNCTIONS
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

-- BAN CHECK
local success, banData = pcall(function()
	local response = game:HttpGet(banlistUrl, true)
	return HttpService:JSONDecode(response)
end)

if success and banData then
	local banlist = banData.banned or {}
	if isBanned(player.UserId, banlist) then
		player:Kick("🚫 You are permanently banned from using this script.")
	end
else
	warn("⚠️ Could not fetch banlist.")
end

-- KILL SWITCH CHECK
local enabled, result = false, nil
local ok, data = pcall(function()
	local response = game:HttpGet(killSwitchUrl, true)
	return HttpService:JSONDecode(response)
end)

if ok and data then
	enabled = data.enabled
	local whitelist = data.whitelist or {}
	if not enabled and not isWhitelisted(player.UserId, whitelist) then
		player:Kick("⚠️ Your UserID is not whitelisted.")
	end
else
	warn("⚠️ Failed to fetch kill switch status.")
end

-- TRAP REMOTE
local trapRemote = ReplicatedStorage:WaitForChild("ExploitTrap", 1)
if trapRemote then trapRemote:FireServer() end

-- LOAD ORION LIB
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Orion%20Library.lua"))()

-- CREATE WINDOW
local Window = OrionLib:MakeWindow({Name = "⚡Avery-Hub⚡", HidePremium = true, SaveConfig = true, ConfigFolder = "AveryHubConfig"})

-- ==================== AUTO DRINK TAB ====================
local AutoTab = Window:MakeTab({Name = "AutoDrink", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local AutoSection = AutoTab:AddSection({Name = "AutoDrink"})

-- AUTO PRESTIGE
AutoSection:AddToggle({
	Name = "Auto Prestige",
	Default = false,
	Callback = function(v)
		while v do
			game.ReplicatedStorage.RemoteEvents.PrestigeEvent:FireServer()
			task.wait(0.8)
		end
	end
})

-- AUTO EQUIP DRINKS
local function AutoEquipDrink()
	local LP = game.Players.LocalPlayer
	local points = LP.leaderstats["Burp points"].Value
	local Backpack = LP.Backpack
	local Character = LP.Character
	local humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	
	local function equip(name)
		local tool = Backpack:FindFirstChild(name) or Character:FindFirstChild(name)
		if tool then humanoid:EquipTool(tool) end
	end
	
	if points >= 0 then equip("Starter Drink") end
	if points >= 150 then equip("Second Drink") end
	if points >= 600 then equip("Third Drink") end
	if points >= 1600 then equip("Fourth Drink") end
	if points >= 3500 then equip("Fifth Drink") end
	if points >= 10000 then equip("Sixth Drink") end
	if points >= 25000 then equip("Seventh Drink") end
	if points >= 60000 then equip("Eighth Drink") end
	if points >= 150000 then equip("Ninth Drink") end
	if points >= 230000 then equip("Atomic Drink") end
	if points >= 500000 then equip("Omega Burp Juice") end
	if points >= 1000000 then equip("Thunder Fizz") end
	if points >= 2000000 then equip("Garlic Juice") end
end

AutoSection:AddToggle({
	Name = "Auto Equip",
	Default = false,
	Callback = function(v)
		getgenv().equipdrink = v
		spawn(function()
			while getgenv().equipdrink do
				AutoEquipDrink()
				task.wait(0.8)
			end
		end)
	end
})

-- AUTO COLLECT GEM
AutoSection:AddToggle({
	Name = "Auto Collect Gem",
	Default = false,
	Callback = function(v)
		getgenv().collectgem = v
		spawn(function()
			while getgenv().collectgem do
				local gem = workspace.Diamonds:FindFirstChild("Diamond")
				if gem and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					gem.CFrame = player.Character.HumanoidRootPart.CFrame
				end
				task.wait(0.6)
			end
		end)
	end
})

-- AUTO DRINK
AutoSection:AddToggle({
	Name = "Auto Drink",
	Default = false,
	Callback = function(v)
		getgenv().autodrink = v
		spawn(function()
			while getgenv().autodrink do
				local drinks = {"Starter Drink","Second Drink","Third Drink","Fourth Drink","Fifth Drink","Sixth Drink","Seventh Drink","Eighth Drink","Ninth Drink","Atomic Drink","Omega Burp Juice","Thunder Fizz","Garlic Juice"}
				for _,drink in ipairs(drinks) do
					game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer(drink)
				end
				task.wait(2.4)
			end
		end)
	end
})

-- FAST DRINK
AutoSection:AddToggle({
	Name = "Fast Drink",
	Default = false,
	Callback = function(v)
		if v then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/v2.lua"))()
		end
	end
})

-- ADD OTHER AUTO FEATURES
AutoSection:AddToggle({
	Name = "Auto Equip Pickaxe",
	Default = false,
	Callback = function(v)
		getgenv().equippickaxe = v
		spawn(function()
			while getgenv().equippickaxe do
				if player.Backpack:FindFirstChild("Pickaxe") and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
					player.Character.Humanoid:EquipTool(player.Backpack.Pickaxe)
				end
				task.wait(0.5)
			end
		end)
	end
})

AutoSection:AddToggle({
	Name = "Auto Mine Gems",
	Default = false,
	Callback = function(v)
		getgenv().minegems = v
		spawn(function()
			while getgenv().minegems do
				if player.Character and player.Character:FindFirstChild("Pickaxe") and player.Character:FindFirstChild("Pickaxe").Server then
					player.Character.Pickaxe.Server.Mine:FireServer()
				end
				task.wait(0.1)
			end
		end)
	end
})

-- ==================== LOCAL PLAYER TAB ====================
local LocalTab = Window:MakeTab({Name = "LocalPlayer", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local LocalSection = LocalTab:AddSection({Name = "LocalPlayer"})

-- WalkSpeed
LocalSection:AddToggle({
	Name = "WalkSpeed",
	Default = false,
	Callback = function(v)
		getgenv().ws = v
		spawn(function()
			while getgenv().ws do
				if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
					player.Character.Humanoid.WalkSpeed = 459
				end
				task.wait()
			end
		end)
	end
})

-- Infinite Jump
LocalSection:AddToggle({
	Name = "Inf Jump",
	Default = false,
	Callback = function(v)
		getgenv().infjump = v
		if v then
			game:GetService("UserInputService").JumpRequest:connect(function()
				if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
					player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
				end
			end)
		end
	end
})

-- Night Mode
LocalSection:AddToggle({
	Name = "Night",
	Default = false,
	Callback = function(v)
		game.Lighting.ClockTime = v and 0 or 14
	end
})

-- Sit
LocalSection:AddToggle({
	Name = "Sit",
	Default = false,
	Callback = function(v)
		if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
			player.Character.Humanoid.Sit = v
		end
	end
})

-- Reset
LocalSection:AddButton({
	Name = "Reset",
	Callback = function() player.Character:BreakJoints() end
})

-- Rejoin
LocalSection:AddButton({
	Name = "Rejoin",
	Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end
})

-- Auto Spawn, TP GUI, Cloud Stand, Void Stand, FPS Unlocker (loadstring)
LocalSection:AddButton({Name = "Auto Spawn", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Auto%20Spawn.lua"))() end})
LocalSection:AddButton({Name = "TP Gui", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Teleport.lua"))() end})
LocalSection:AddToggle({Name = "Cloud Stand", Default = false, Callback = function(v) if v then loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Cloud.lua"))() end end})
LocalSection:AddButton({Name = "VoidStand", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/VoidStand.lua"))() end})

-- ==================== TELEPORT TAB ====================
local TeleportTab = Window:MakeTab({Name = "Teleports", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local TeleSection = TeleportTab:AddSection({Name = "Teleports"})

local function AddTeleport(name, pos)
	TeleSection:AddButton({
		Name = name,
		Callback = function()
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
			end
		end
	})
end

-- Example teleports
AddTeleport("Safe Zone", Vector3.new(0,10,0))
AddTeleport("Pet Shop", Vector3.new(50,10,50))
AddTeleport("Disco Island", Vector3.new(100,10,100))
AddTeleport("Cloud One", Vector3.new(200,10,200))
AddTeleport("Cloud Second", Vector3.new(300,10,300))
AddTeleport("Sky Island", Vector3.new(400,10,400))
AddTeleport("SafePlace", Vector3.new(500,10,500))
AddTeleport("SafePlace v2", Vector3.new(600,10,600))
AddTeleport("FavSpot", Vector3.new(700,10,700))
AddTeleport("Water Spot", Vector3.new(800,10,800))
AddTeleport("Hotel", Vector3.new(900,10,900))

-- ==================== MISC TAB ====================
local MiscTab = Window:MakeTab({Name = "Misc", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local MiscSection = MiscTab:AddSection({Name = "Miscellaneous"})

MiscSection:AddButton({Name = "Bp Counter", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/BpCounter.lua"))() end})
MiscSection:AddButton({Name = "Infinity Yield", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end})
MiscSection:AddButton({Name = "Anti Afk", Callback = function()
	local vu = game:GetService("VirtualUser")
	game:GetService("Players").LocalPlayer.Idled:connect(function()
		vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
		wait(1)
		vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	end)
end})
MiscSection:AddButton({Name = "Anti Kick", Callback = function() game.Players.LocalPlayer.OnKick:Connect(function() end) end})

-- ==================== SCRIPTS TAB ====================
local ScriptsTab = Window:MakeTab({Name = "Scripts", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local ScriptsSection = ScriptsTab:AddSection({Name = "Scripts"})

ScriptsSection:AddButton({Name = "SimonHub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/SimonHub.lua"))() end})
ScriptsSection:AddButton({Name = "SimonHax", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/SimonHax.lua"))() end})
ScriptsSection:AddButton({Name = "Orion V1", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/OrionV1.lua"))() end})
ScriptsSection:AddButton({Name = "Emotes Hub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/EmotesHub.lua"))() end})
ScriptsSection:AddButton({Name = "ZeroHub", Callback = function() loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/ZeroHub.lua"))() end})

-- ==================== CREDITS TAB ====================
local CreditsTab = Window:MakeTab({Name = "Credits", Icon = "rbxassetid://4483345998", PremiumOnly = false})
local CreditsSection = CreditsTab:AddSection({Name = "Credits"})
CreditsSection:AddLabel("Script by Avery")
CreditsSection:AddLabel("Original Hub: RikoTheDemonHunter")
CreditsSection:AddLabel("OrionLib GUI by Orion")

OrionLib:Init()
