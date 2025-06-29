local Players = game:GetService("Players")
local player = Players.LocalPlayer 

-- Whitelisted UserIds
local whitelist = {
    [1497286101] = true,
  
   
}

-- Check if player is whitelisted
local function isWhitelisted(userId)
    return whitelist[userId] == true
end

-- If not whitelisted, stop execution or kick
if not isWhitelisted(player.UserId) then
    - game.Players.LocalPlayer:Kick("You are not authorized to use this script.")
    return

   
    -- Option 2: Kick player (can only be done server-side)
    -- game.Players.LocalPlayer:Kick("You are not authorized to use this script.")
end

-- Your script continues here for whitelisted users only
print("Access granted. Script running" .. player.Name)

function AutoEquipDrink()

	spawn(function()			if not game.Players.LocalPlayer.Backpack:FindFirstChild("Starter Drink") then

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

local kavoUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/.github/workflows/Avery%20GUI.lua"))()

local window = kavoUi.CreateLib("Rikos-DrinkHaxx V1","BloodTheme")

local Tab1 = window:NewTab("Auto Drink")

local Tab1Section = Tab1:NewSection("Auto Drinks Tab")

local Tab2 = window:NewTab("Utilities")

local Tab2Section = Tab2:NewSection("Afk Tool")

local Tab3 = window:NewTab("Teleport Tab")

local Tab3Section = Tab3:NewSection("Teleport Section")

local Tab4 = window:NewTab("Update Logs")

local Tab4Section = Tab4:NewSection("Added Teleports")

local Tab4Section = Tab4:NewSection("Updated for better scripting")

local Tab4Section = Tab4:NewSection("Running")

local Tab4Section = Tab4:NewSection("Auto Drink is now stable")

local Tab5 = window:NewTab("Credits")

local Tab5Section = Tab5:NewSection("Made By RikoTheDev")

local Tab5Section = Tab5:NewSection("New owner. RikoTheDev!")

Tab1Section:NewToggle("Auto Rebirth","Auto Pestiges for you",function()

while wait(2.0) do

		game.ReplicatedStorage.RemoteEvents.PrestigeEvent:FireServer()

	end

end)

Tab1Section:NewToggle("Auto Gems","Auto Collect Gems for you",function()

while wait() do

		local gem = game.Workspace.Diamonds:WaitForChild("Diamond")

		local Char = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")

		gem.CFrame = Char.CFrame

	end

end)

Tab1Section:NewToggle("Auto Equip","Auto Equips For You",function()

while wait(0.8) do

    AutoEquipDrink()

    end

end)

Tab1Section:NewToggle("Starter Drink","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Starter Drink")

	end

end)

Tab1Section:NewToggle("Second Drink","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Second Drink")

	end

end)

Tab1Section:NewToggle("Third Drink","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Third Drink")

	end

end)

Tab1Section:NewToggle("Fourth Drink","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Fourth Drink")

	end

end)

Tab1Section:NewToggle("Fifth Drink","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Fifth Drink")

	end

end)

Tab1Section:NewToggle("Sixth Drink","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Sixth Drink")

	end

end)

Tab1Section:NewToggle("Seventh Drink","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Seventh Drink")

	end

end)

Tab1Section:NewToggle("Eighth Drink","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Eighth Drink")

	end

end)

Tab1Section:NewToggle("Ninth Drink","Auto Drink For You",function()

while wait(2.33) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Ninth Drink")

	end

end)

Tab1Section:NewToggle("Atomic Drink","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Atomic Drink")

	end

end)

Tab1Section:NewToggle("Omega Burp Juice","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Omega Burp Juice")

	end

end)

Tab1Section:NewToggle("Thunder Fizz","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Thunder Fizz")

	end

end)

Tab1Section:NewToggle("Garlic Juice","Auto Drink For You",function()

while wait(2.34) do

		game.ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer("Garlic Juice")

	end

end)

Tab2Section:NewToggle("Anti Kick","Prevents You From Being Timer Kick",function()

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

Tab2Section:NewToggle("Anti Afk","Prevents You From Being Afk Kick",function()

loadstring(game:HttpGet("https://pastebin.com/raw/KHZ8pYx9", true))()

end)

Tab2Section:NewButton("Infinite yield","Gets You Inf Yield",function()

loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()

end)

Tab2Section:NewButton("Speed 950","Makes You Run At The Speed Of 950",function()

while wait() do

		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 950

	end

end)

Tab2Section:NewButton("Infinity Jump","You Can Jump Unlimited Times",function()

game:GetService("UserInputService").JumpRequest:connect(function()

		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")

	end)

end)

Tab3Section:NewButton("Safe Zone","Teleports You To Safe Zone",function()

local New_CFrame = CFrame.new(-46, 48, -15)

	local ts = game:GetService("TweenService")

	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart

	local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)

	local tp = {CFrame = New_CFrame}

	ts:Create(part, ti, tp):Play()

end)

Tab3Section:NewButton("Pet Shop","Teleports You To Pet Shop",function()

local New_CFrame = CFrame.new(311, 52, 103)

	local ts = game:GetService("TweenService")

	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart

	local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)

	local tp = {CFrame = New_CFrame}

	ts:Create(part, ti, tp):Play()

end)

Tab3Section:NewButton("Disco Island","Teleports You To Disco Island",function()

local New_CFrame = CFrame.new(63, 48, 636)

	local ts = game:GetService("TweenService")

	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart

	local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)

	local tp = {CFrame = New_CFrame}

	ts:Create(part, ti, tp):Play()

end)

Tab3Section:NewButton("Cloud 1","Teleports You To Cloud",function()

local New_CFrame = CFrame.new(296, 566, 689)

	local ts = game:GetService("TweenService")

	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart

	local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)

	local tp = {CFrame = New_CFrame}

	ts:Create(part, ti, tp):Play()

end)

Tab3Section:NewButton("Cloud 2","Teleports You To Cloud",function()

local New_CFrame = CFrame.new(-1224, 557, -318)

	local ts = game:GetService("TweenService")

	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart

	local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)

	local tp = {CFrame = New_CFrame}

	ts:Create(part, ti, tp):Play()

end)

Tab3Section:NewButton("Sky Island","Teleports You To Sky Island",function()

local New_CFrame = CFrame.new(2132, 1456, -1034)

	local ts = game:GetService("TweenService")

	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart

	local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)

	local tp = {CFrame = New_CFrame}

	ts:Create(part, ti, tp):Play()

end)


				
				
