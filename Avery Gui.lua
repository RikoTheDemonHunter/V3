--==========================--
--       Avery Hub v3       --
--   Full Optimized Version --
--==========================--

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")

--==========================--
--       Kill Switch        --
--==========================--

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

-- Ban check
pcall(function()
	local banData = HttpService:JSONDecode(game:HttpGet(banlistUrl,true))
	if banData and isBanned(player.UserId, banData.banned or {}) then
		player:Kick("🚫 You are permanently banned from using this script.")
	end
end)

-- Kill switch check
pcall(function()
	local result = HttpService:JSONDecode(game:HttpGet(url,true))
	local enabled = result.enabled
	local whitelist = result.whitelist or {}
	if not enabled and not isWhitelisted(player.UserId, whitelist) then
		player:Kick("⚠️ Unauthorized user detected.")
	end
end)

--==========================--
--    Exploit Trap Event    --
--==========================--
local trapRemote = ReplicatedStorage:WaitForChild("ExploitTrap",1)
if trapRemote then trapRemote:FireServer() end

--==========================--
--       Anti Kick          --
--==========================--
do
	local mt = getrawmetatable(game)
	local oldNamecall = mt.__namecall
	local protect = newcclosure or protect_function
	setreadonly(mt,false)
	mt.__namecall = protect(function(self,...)
		if getnamecallmethod() == "Kick" then wait(9e9) return end
		return oldNamecall(self,...)
	end)
	setreadonly(mt,true)
	hookfunction(player.Kick,protect(function() wait(9e9) end))
end

--==========================--
--        Anti AFK          --
--==========================--
player.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait(1)
	VirtualUser:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

--==========================--
--       Library Init       --
--==========================--
local lib = {}

function lib:Gui(title)
	local DarkLib = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local TabSide = Instance.new("ScrollingFrame")
	local SectionSide = Instance.new("Frame")
	local close = Instance.new("ImageButton")
	local TitleLabel = Instance.new("TextLabel")

	DarkLib.Name = "DarkLib"
	DarkLib.Parent = game.CoreGui
	DarkLib.ResetOnSpawn = false

	-- Toggle GUI with LeftAlt
	UserInputService.InputBegan:Connect(function(key)
		if key.KeyCode == Enum.KeyCode.LeftAlt then
			DarkLib.Enabled = not DarkLib.Enabled
		end
	end)

	-- Main Frame
	Main.Name = "Main"
	Main.Parent = DarkLib
	Main.BackgroundColor3 = Color3.fromRGB(35,35,35)
	Main.Position = UDim2.new(0.367,0,0.263,0)
	Main.Size = UDim2.new(0,382,0,219)

	-- Draggable
	local dragging, dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		TweenService:Create(Main,TweenInfo.new(0.06,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)}):Play()
	end
	Main.InputBegan:Connect(function(input)
		if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
			dragging=true
			dragStart=input.Position
			startPos=Main.Position
			input.Changed:Connect(function()
				if input.UserInputState==Enum.UserInputState.End then dragging=false end
			end)
		end
	end)
	Main.InputChanged:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseMovement then dragInput=input end end)
	UserInputService.InputChanged:Connect(function(input) if input==dragInput and dragging then update(input) end end)

	-- Tab & Section Containers
	TabSide.Name="TabSide"
	TabSide.Parent=Main
	TabSide.BackgroundColor3=Color3.fromRGB(30,30,30)
	TabSide.Position=UDim2.new(0.021,0,0.038,0)
	TabSide.Size=UDim2.new(0,92,0,203)
	TabSide.ScrollBarThickness=5
	TabSide.ClipsDescendants=true

	SectionSide.Name="SectionSide"
	SectionSide.Parent=Main
	SectionSide.BackgroundColor3=Color3.fromRGB(30,30,30)
	SectionSide.Position=UDim2.new(0.298,0,0.146,0)
	SectionSide.Size=UDim2.new(0,255,0,173)
	SectionSide.ClipsDescendants=true
	SectionSide.Visible=true

	-- Close Button
	close.Name="close"
	close.Parent=Main
	close.BackgroundTransparency=1
	close.Position=UDim2.new(0.935,0,-0.002,0)
	close.Size=UDim2.new(0,25,0,25)
	close.Image="rbxassetid://3926305904"
	close.ImageRectOffset=Vector2.new(284,4)
	close.ImageRectSize=Vector2.new(24,24)
	close.MouseButton1Click:Connect(function() DarkLib:Destroy() end)

	-- Title
	TitleLabel.Name="Title"
	TitleLabel.Parent=Main
	TitleLabel.BackgroundTransparency=1
	TitleLabel.Position=UDim2.new(0,90,0,0)
	TitleLabel.Size=UDim2.new(0,200,0,46)
	TitleLabel.Font=Enum.Font.FredokaOne
	TitleLabel.TextColor3=Color3.fromRGB(255,0,0)
	TitleLabel.TextSize=30
	TitleLabel.TextWrapped=true
	TitleLabel.Text=title

	-- Tabs API
	local Tabs={}
	function Tabs:Tab(name)
		local TextButton=Instance.new("TextButton")
		TextButton.Parent=TabSide
		TextButton.BackgroundColor3=Color3.fromRGB(35,35,35)
		TextButton.Size=UDim2.new(0,70,0,30)
		TextButton.Font=Enum.Font.Highway
		TextButton.TextColor3=Color3.fromRGB(0,255,0)
		TextButton.TextScaled=true
		TextButton.Text=name
		TextButton.Name=name
		local Sections={}
		function Sections:Section(name)
			local Page=Instance.new("ScrollingFrame")
			local UIListLayout=Instance.new("UIListLayout")
			Page.Name=name
			Page.Parent=SectionSide
			Page.Active=true
			Page.BackgroundColor3=Color3.fromRGB(30,30,30)
			Page.BorderSizePixel=0
			Page.Position=UDim2.new(0.047,0,0.104,0)
			Page.Size=UDim2.new(0,237,0,145)
			Page.ScrollingDirection=Enum.ScrollingDirection.Y
			Page.ScrollBarThickness=5
			UIListLayout.Parent=Page
			UIListLayout.SortOrder=Enum.SortOrder.LayoutOrder
			UIListLayout.Padding=UDim.new(0,10)
			UIListLayout.Changed:Connect(function()
				Page.CanvasSize=UDim2.new(0,0,0,UIListLayout.AbsoluteContentSize.Y)
			end)
			TextButton.MouseButton1Click:Connect(function()
				for _,v in next, SectionSide:GetChildren() do if v:IsA("ScrollingFrame") then v.Visible=false end end
				Page.Visible=true
			end)
			local Elements={}
			function Elements:Toggle(name, callback)
				local Frame=Instance.new("Frame")
				local ToggleState=Instance.new("TextLabel")
				local Click=Instance.new("TextButton")
				Frame.Parent=Page
				Frame.Size=UDim2.new(0,220,0,30)
				Frame.BackgroundColor3=Color3.fromRGB(35,35,35)
				ToggleState.Parent=Frame
				ToggleState.Size=UDim2.new(0,46,0,30)
				ToggleState.BackgroundTransparency=1
				ToggleState.Text=""
				ToggleState.TextScaled=true
				ToggleState.TextColor3=Color3.fromRGB(255,255,255)
				Click.Parent=Frame
				Click.Size=UDim2.new(0,220,0,30)
				Click.BackgroundTransparency=1
				Click.Text=name
				Click.Font=Enum.Font.Highway
				Click.TextColor3=Color3.fromRGB(0,255,0)
				Click.TextScaled=true
				local toggle=false
				local debounce=false
				Click.MouseButton1Click:Connect(function()
					if not debounce then
						debounce=true
						toggle=not toggle
						ToggleState.Text=toggle and "X" or ""
						task.spawn(callback,toggle)
						wait(0.25)
						debounce=false
					end
				end)
			end
			function Elements:Button(name,callback)
				local Btn=Instance.new("TextButton")
				Btn.Parent=Page
				Btn.Size=UDim2.new(0,220,0,30)
				Btn.BackgroundColor3=Color3.fromRGB(35,35,35)
				Btn.Font=Enum.Font.Highway
				Btn.TextColor3=Color3.fromRGB(0,255,0)
				Btn.TextScaled=true
				Btn.Text=name
				Btn.MouseButton1Click:Connect(callback)
			end
			return Elements
		end
		return Sections
	end
	return Tabs
end

--==========================--
--       Library Setup      --
--==========================--
local Library = lib:Gui("⚡Avery-Hub⚡")

--==========================--
--         Tabs Setup       --
--==========================--
local LocalPlayerTab = Library:Tab("LocalPlayer")
local AutoTab = Library:Tab("AutoFarm")
local TeleportTab = Library:Tab("Teleports")
local MiscTab = Library:Tab("Misc")
local ScriptsTab = Library:Tab("Scripts")
local CreditsTab = Library:Tab("Credits")

-- LocalPlayer Section
local lpSection = LocalPlayerTab:Section("Player Options")
lpSection:Toggle("Inf Jump", function(v)
	game:GetService("UserInputService").JumpRequest:Connect(function()
		if v then
			player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end)
end)

-- AutoFarm Section
local autoSection = AutoTab:Section("Auto Drinks")
autoSection:Toggle("Auto Drink", function(v)
	coroutine.wrap(function()
		while v do
			if game.Players.LocalPlayer and game.ReplicatedStorage:FindFirstChild("RemoteEvents") then
				local drinkEvent = game.ReplicatedStorage.RemoteEvents:FindFirstChild("DrinkEvent")
				if drinkEvent then
					drinkEvent:FireServer("Starter Drink")
					drinkEvent:FireServer("Second Drink")
					drinkEvent:FireServer("Third Drink")
				end
			end
			wait(2.4)
		end
	end)()
end)

-- Teleports Section
local tpSection = TeleportTab:Section("Locations")
tpSection:Button("Spawn", function()
	player.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(0,5,0))
end)

-- Misc Section
local miscSection = MiscTab:Section("Miscellaneous")
miscSection:Button("Rejoin", function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, player)
end)

-- Scripts Section
local scriptSection = ScriptsTab:Section("Load Scripts")
scriptSection:Button("User List", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/User's.lua"))()
end)

-- Credits Section
local creditSection = CreditsTab:Section("Credits")
creditSection:Button("Avery", function()
	print("Script by Avery")
end)

--==========================--
--        Done Setup        --
--==========================--
print("⚡Avery Hub fully loaded and optimized!")
