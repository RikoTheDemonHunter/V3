function AutoEquipDrink()
	spawn(function()
			if not game.Players.LocalPlayer.Backpack:FindFirstChild("Starter Drink") then
				if not game.Players.LocalPlayer.Character:FindFirstChild("Starter Drink") then
					game.Players.LocalPlayer.Character:BreakJoints()
				end
			end
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

			if game.Players.LocalPlayer.Backpack:FindFirstChild("Thunder Fizz") then
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

			if game.Players.LocalPlayer.Backpack:FindFirstChild("Garlic Juice") then
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
	end)
end


local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/.github/workflows/Avery%20GUI.lua"))()
local Window = Library.CreateLib("Avery-Hub v2", "BloodTheme")

local Tab = Window:NewTab("AutoFarm")
local AutoFarmSection = Tab:NewSection("AutoFarm")

AutoFarmSection:NewButton("Auto Equip","Equips ur drink for you.", function()
    while wait(2.34) do
    AutoEquipDrink()
    end
end)

AutoFarmSection:NewToggle("Starter Drink","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Starter Drink")
    end
end)
    
AutoFarmSection:NewToggle("Second Drink","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Second Drink")
    end
end)
    
AutoFarmSection:NewToggle("Third Drink","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Third Drink")
    end
end)
    
AutoFarmSection:NewToggle("Fourth Drink","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Fourth Drink")
    end
end)
    
AutoFarmSection:NewToggle("Fifth Drink","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Fifth Drink")
    end
end)
    
AutoFarmSection:NewToggle("Sixth Drink","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Sixth Drink")
    end
end)
    
AutoFarmSection:NewButton("Seventh Drink","Auto Drink For You", function()
    while wait(2.34) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Seventh Drink")
    end
end)
    
AutoFarmSection:NewButton("Eighth Drink","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Eighth Drink")
    end
end)
    
AutoFarmSection:NewToggle("Ninth Drink","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Ninth Drink")
    end
end)
    
AutoFarmSection:NewToggle("Atomic Drink","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Atomic Drink")
    end
end)
    
AutoFarmSection:NewToggle("Omega Burp Juice","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Omega Burp Juice")
    end
end)
    
AutoFarmSection:NewToggle("Thunder Fizz","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Thunder Fizz")
    end
end)
    
AutoFarmSection:NewToggle("Garlic Juice","Auto Drink For You", function()
    while wait(2.4) do
        game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Garlic Juice")
    end
end)

local Tab = Window:NewTab("LocalPlayer")
local LocalPlayerSection = Tab:NewSection("LocalPlayer")

LocalPlayerSection:NewButton("Walkspeed","Makes You Run At The Speed Of 850",function()
    while wait() do
        game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 850
    end
end)
    
LocalPlayerSection:NewButton("Inf Jump","You Can Jump Unlimited Times",function()
    game:GetService("UserInputService").JumpRequest:connect(function()
        game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
    end)
end)

local Tab = Window:NewTab("Teleport")
local TeleportSection = Tab:NewSection("Teleport")

TeleportSection:NewButton("Safe Zone","Teleports You To Safe Zone",function()
    local New_CFrame = CFrame.new(-46, 48, -15)
    
    local ts = game:GetService("TweenService")
    local char = game.Players.LocalPlayer.Character
    
    local part = char.HumanoidRootPart
    local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)
    local tp = {CFrame = New_CFrame}
    ts:Create(part, ti, tp):Play()
end)
    
TeleportSection:NewButton("Pet Shop","Teleports You To Pet Shop",function()
    local New_CFrame = CFrame.new(311, 52, 103)
    
    local ts = game:GetService("TweenService")
    local char = game.Players.LocalPlayer.Character
    
    local part = char.HumanoidRootPart
    local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)
    local tp = {CFrame = New_CFrame}
    ts:Create(part, ti, tp):Play()
end)
    
TeleportSection:NewButton("Disco Island","Teleports You To Disco Island",function()
    local New_CFrame = CFrame.new(63, 48, 636)
    
    local ts = game:GetService("TweenService")
    local char = game.Players.LocalPlayer.Character
    
    local part = char.HumanoidRootPart
    local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)
    local tp = {CFrame = New_CFrame}
    ts:Create(part, ti, tp):Play()
end)
    
TeleportSection:NewButton("Cloud 1","Teleports You To Cloud",function()
    local New_CFrame = CFrame.new(296, 566, 689)
    
    local ts = game:GetService("TweenService")
    local char = game.Players.LocalPlayer.Character
    
    local part = char.HumanoidRootPart
    local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)
    local tp = {CFrame = New_CFrame}
    ts:Create(part, ti, tp):Play()
end)
    
TeleportSection:NewButton("Cloud 2","Teleports You To Cloud",function()
    local New_CFrame = CFrame.new(-1224, 557, -318)
    
    local ts = game:GetService("TweenService")
    local char = game.Players.LocalPlayer.Character
    
    local part = char.HumanoidRootPart
    local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)
    local tp = {CFrame = New_CFrame}
    ts:Create(part, ti, tp):Play()
end)
    
TeleportSection:NewButton("Sky Island","Teleports You To Sky Island",function()
    local New_CFrame = CFrame.new(2132, 1456, -1034)
    
    local ts = game:GetService("TweenService")
    local char = game.Players.LocalPlayer.Character
    
    local part = char.HumanoidRootPart
    local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)
    local tp = {CFrame = New_CFrame}
    ts:Create(part, ti, tp):Play()
end)

local Tab = Window:NewTab("Misc")
local MiscSection = Tab:NewSection("Misc")

MiscSection:NewButton("Auto Prestige","Auto Pestiges for you", function()
    while wait(2.5) do
        game.ReplicatedStorage.RemoteEvents.PrestigeEvent:FireServer()
    end
end)

MiscSection:NewButton("Auto Gems","Auto Collect Gems for you", function()
    while wait() do
        local gem = game.Workspace.Diamonds:WaitForChild("Diamond")
        local Char = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
        gem.CFrame = Char.CFrame
    end
end)

MiscSection:NewButton("Infinite yield","Gets You Inf Yield",function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

MiscSection:NewButton("Anti Kick","Prevents You From Being Timer Kick",function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    local protect = newcclosure or protect_function
    
    setreadonly(mt, false)
    mt.__namecall = protect(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then
            wait(9e9)
            return
        end
        return old(self, ...)
    end)
    hookfunction(game.Players.LocalPlayer.Kick,protect(function() wait(9e9) end))
end)
    
MiscSection:NewButton("Anti Afk","Prevents You From Being Afk Kick",function()
    loadstring(game:HttpGet("https://pastebin.com/raw/KHZ8pYx9", true))()
end)

MiscSection:NewButton("BP Counter","Counts ur Burp Points", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/XCXxhZht", true))()
end)

MiscSection:NewButton("Baseplate","Makes a baseplate to walk on", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/wYnd92Av"))()
end)

local Tab = Window:NewTab("Credits")
local CreditsSection = Tab:NewSection("Credits")

local CreditsSection = Tab:NewSection("Made By Avery")
local CreditsSection = Tab:NewSection("Whitelist System")
