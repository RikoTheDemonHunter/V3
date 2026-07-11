local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer


local SETTINGS_FILE = "AveryHubConfig.json"
local SavedSettings = {}


local function LoadSettings()
	if isfile and readfile and isfile(SETTINGS_FILE) then
		local success, decoded = pcall(function()
			return HttpService:JSONDecode(readfile(SETTINGS_FILE))
		end)
		if success and type(decoded) == "table" then
			SavedSettings = decoded
		end
	end
end


local function SaveSettings()
	if writefile then
		local success, encoded = pcall(function()
			return HttpService:JSONEncode(SavedSettings)
		end)
		if success then
			writefile(SETTINGS_FILE, encoded)
		end
	end
end


LoadSettings()


local Theme = {
	Background = Color3.fromRGB(15, 15, 25),
	SideBar = Color3.fromRGB(10, 10, 18),
	Accent = Color3.fromRGB(0, 200, 255),
	TextColor = Color3.fromRGB(255, 255, 255),
	Alert = Color3.fromRGB(255, 80, 80),
	Success = Color3.fromRGB(0, 220, 130),
	Highlight = Color3.fromRGB(255, 215, 0)
}


local url = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
local banlistUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"


local function isBanned(userId, banlist)
	if not banlist then return false end
	for _, id in ipairs(banlist) do if id == userId then return true end end
	return false
end

local function isWhitelisted(userId, whitelist)
	if not whitelist then return false end
	for _, id in ipairs(whitelist) do if id == userId then return true end end
	return false
end

local function verifyUser(p, wl, bl)
	local id, name = p.UserId, p.Name or "Unknown"
	return isWhitelisted(id, wl), isBanned(id, bl), name, id
end


local gui = Instance.new("ScreenGui")
gui.Name = "AveryHubIntro"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.48, 0, 0.5, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Theme.Background
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = gui 

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local dateLabel = Instance.new("TextLabel")
dateLabel.AnchorPoint = Vector2.new(0.5, 0)
dateLabel.Position = UDim2.new(0.5, 0, 0, -38)
dateLabel.Size = UDim2.new(0.85, 0, 0, 26)
dateLabel.BackgroundTransparency = 1
dateLabel.Font = Enum.Font.GothamSemibold
dateLabel.TextSize = 14
dateLabel.TextColor3 = Theme.Highlight
dateLabel.TextTransparency = 1
dateLabel.Text = os.date("%A, %B %d %Y  |  %I:%M:%S %p")
dateLabel.Parent = frame

task.spawn(function()
	while gui.Parent do
		dateLabel.Text = os.date("%A, %B %d %Y  |  %I:%M:%S %p")
		task.wait(1)
	end
end)

TweenService:Create(dateLabel, TweenInfo.new(1.2), {TextTransparency = 0}):Play()

local uiScale = Instance.new("UIScale")
uiScale.Scale = UserInputService.TouchEnabled and 1.2 or 1
uiScale.Parent = frame

local glow = Instance.new("UIStroke")
glow.Color = Theme.Accent
glow.Thickness = 2
glow.Transparency = 0.3
glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
glow.Parent = frame

task.spawn(function()
	while gui.Parent do
		TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.6}):Play()
		task.wait(2)
		TweenService:Create(glow, TweenInfo.new(2, Enum.EasingStyle.Sine), {Transparency = 0.25}):Play()
		task.wait(2)
	end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 15, 0, 10)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Theme.TextColor
title.Text = "Avery Hub | Whitelist Verification"
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 35)
status.Position = UDim2.new(0, 15, 0, 50)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 16
status.TextColor3 = Theme.Accent
status.TextXAlignment = Enum.TextXAlignment.Left
status.Text = "✨ Initializing..."
status.Parent = frame

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -30, 0.55, -40)
scrollFrame.Position = UDim2.new(0, 15, 0.25, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 4
scrollFrame.ScrollBarImageColor3 = Theme.Accent
scrollFrame.Parent = frame

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 6)
uiList.Parent = scrollFrame

local outro = Instance.new("TextLabel")
outro.Size = UDim2.new(1, -20, 0, 30)
outro.Position = UDim2.new(0, 10, 0.88, 0)
outro.BackgroundTransparency = 1
outro.Font = Enum.Font.GothamBold
outro.TextSize = 14
outro.TextColor3 = Color3.fromRGB(255, 100, 150)
outro.TextTransparency = 1
outro.Text = "💖 Show your support by following Avery on Discord!"
outro.Parent = frame

local function fadeText(newText, delayTime)
	local out = TweenService:Create(status, TweenInfo.new(0.3), {TextTransparency = 1})
	out:Play() out.Completed:Wait()
	status.Text = newText
	TweenService:Create(status, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
	task.wait(delayTime or 1)
end

task.wait(0.5)
fadeText("✨ Welcome to Avery Hub", 1)
local banData, whitelist, enabled = {}, {}, true

pcall(function()
	local raw = game:HttpGet(banlistUrl)
	local decoded = HttpService:JSONDecode(raw)
	banData = decoded.banned or decoded or {}
end)
pcall(function()
	local raw = game:HttpGet(url)
	local data = HttpService:JSONDecode(raw)
	enabled = (data.enabled ~= false)
	whitelist = data.whitelist or {}
end)

local whitelisted, banned, username, userId = verifyUser(player, whitelist, banData)

if banned then
	fadeText("🚫 You are BANNED!", 2)
	player:Kick("🚫 You are banned from Avery Hub.")
	return
elseif not whitelisted and not enabled then
	fadeText("❌ Verification Disabled via Killswitch.", 2)
	player:Kick("❌ System Kill Switch Active.")
	return
elseif not whitelisted then
	fadeText("❌ Access Denied: Not Whitelisted.", 2)
	player:Kick("❌ You are not whitelisted!")
	return
end

fadeText("✅ Verification Successful!", 1)
TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(uiScale, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0}):Play()
task.wait(0.5)
gui:Destroy()


local ModernLib = {}
function ModernLib:CreateMain(hubTitle)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "AveryHubUI"
	ScreenGui.Parent = game.CoreGui
	ScreenGui.ResetOnSpawn = false

	UserInputService.InputBegan:Connect(function(key, gp)
		if not gp and key.KeyCode == Enum.KeyCode.LeftAlt then
			ScreenGui.Enabled = not ScreenGui.Enabled
		end
	end)

	local MainFrame = Instance.new("Frame")
	MainFrame.Name = "Main"
	MainFrame.Size = UDim2.new(0, 540, 0, 360)
	MainFrame.Position = UDim2.new(0.5, -270, 0.5, -180)
	MainFrame.BackgroundColor3 = Theme.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui

	local MainCorner = Instance.new("UICorner")
	MainCorner.CornerRadius = UDim.new(0, 12)
	MainCorner.Parent = MainFrame

	local MainStroke = Instance.new("UIStroke")
	MainStroke.Color = Theme.Accent
	MainStroke.Thickness = 1.5
	MainStroke.Parent = MainFrame

	local dragging, dragInput, dragStart, startPos
	MainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = MainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	MainFrame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Sine), {
				Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
			}):Play()
		end
	end)

	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, -40, 0, 40)
	TitleLabel.Position = UDim2.new(0, 15, 0, 0)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = hubTitle
	TitleLabel.TextColor3 = Theme.Accent
	TitleLabel.TextSize = 18
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = MainFrame

	local CloseBtn = Instance.new("ImageButton")
	CloseBtn.Size = UDim2.new(0, 22, 0, 22)
	CloseBtn.Position = UDim2.new(1, -32, 0, 9)
	CloseBtn.BackgroundTransparency = 1
	CloseBtn.Image = "rbxassetid://3926305904"
	CloseBtn.ImageRectOffset = Vector2.new(284, 4)
	CloseBtn.ImageRectSize = Vector2.new(24, 24)
	CloseBtn.ImageColor3 = Theme.Alert
	CloseBtn.Parent = MainFrame
	CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

	local SideBar = Instance.new("ScrollingFrame")
	SideBar.Size = UDim2.new(0, 140, 1, -55)
	SideBar.Position = UDim2.new(0, 10, 0, 45)
	SideBar.BackgroundColor3 = Theme.SideBar
	SideBar.BorderSizePixel = 0
	SideBar.ScrollBarThickness = 2
	SideBar.Parent = MainFrame

	local SideCorner = Instance.new("UICorner")
	SideCorner.CornerRadius = UDim.new(0, 8)
	SideCorner.Parent = SideBar

	local SideList = Instance.new("UIListLayout")
	SideList.Padding = UDim.new(0, 5)
	SideList.Parent = SideBar

	local Container = Instance.new("Frame")
	Container.Size = UDim2.new(1, -175, 1, -55)
	Container.Position = UDim2.new(0, 160, 0, 45)
	Container.BackgroundTransparency = 1
	Container.Parent = MainFrame

	local Tabs = { ActivePage = nil }
	function Tabs:Tab(tabName)
		local TabBtn = Instance.new("TextButton")
		TabBtn.Size = UDim2.new(1, 0, 0, 34)
		TabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
		TabBtn.Font = Enum.Font.GothamSemibold
		TabBtn.TextColor3 = Color3.fromRGB(180, 180, 190)
		TabBtn.TextSize = 13
		TabBtn.Text = tabName
		TabBtn.Parent = SideBar
		Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

		local Page = Instance.new("ScrollingFrame")
		Page.Size = UDim2.new(1, 0, 1, 0)
		Page.BackgroundTransparency = 1
		Page.ScrollBarThickness = 3
		Page.Visible = false
		Page.Parent = Container

		local PageList = Instance.new("UIListLayout")
		PageList.Padding = UDim.new(0, 8)
		PageList.Parent = Page

		TabBtn.MouseButton1Click:Connect(function()
			for _, child in ipairs(Container:GetChildren()) do
				if child:IsA("ScrollingFrame") then child.Visible = false end
			end
			for _, btn in ipairs(SideBar:GetChildren()) do
				if btn:IsA("TextButton") then btn.TextColor3 = Color3.fromRGB(180, 180, 190) end
			end
			TabBtn.TextColor3 = Theme.Accent
			Page.Visible = true
		end)

		if not Tabs.ActivePage then
			TabBtn.TextColor3 = Theme.Accent
			Page.Visible = true
			Tabs.ActivePage = Page
		end

		local Elements = {}
		function Elements:Toggle(toggleName, callback)
			local ToggleFrame = Instance.new("Frame")
			ToggleFrame.Size = UDim2.new(1, -5, 0, 36)
			ToggleFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
			ToggleFrame.Parent = Page
			Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.7, 0, 1, 0)
			lbl.Position = UDim2.new(0, 10, 0, 0)
			lbl.BackgroundTransparency = 1
			lbl.Font = Enum.Font.Gotham
			lbl.Text = toggleName
			lbl.TextColor3 = Theme.TextColor
			lbl.TextSize = 14
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = ToggleFrame

			local StatusIndicator = Instance.new("TextButton")
			StatusIndicator.Size = UDim2.new(0, 45, 0, 22)
			StatusIndicator.Position = UDim2.new(1, -55, 0, 7)
			StatusIndicator.BackgroundColor3 = Theme.SideBar
			StatusIndicator.Font = Enum.Font.GothamBold
			StatusIndicator.TextSize = 11
			StatusIndicator.Parent = ToggleFrame
			Instance.new("UICorner").CornerRadius = UDim.new(0, 4)

			
			local state = false
			if SavedSettings[toggleName] ~= nil then
				state = SavedSettings[toggleName]
			end

			StatusIndicator.Text = state and "ON" or "OFF"
			StatusIndicator.TextColor3 = state and Theme.Success or Theme.Alert

			
			if state then
				task.spawn(callback, true)
			end

			StatusIndicator.MouseButton1Click:Connect(function()
				state = not state
				StatusIndicator.Text = state and "ON" or "OFF"
				StatusIndicator.TextColor3 = state and Theme.Success or Theme.Alert
				
				
				SavedSettings[toggleName] = state
				SaveSettings()

				task.spawn(callback, state)
			end)
		end

		function Elements:Button(btnName, callback)
			local Btn = Instance.new("TextButton")
			local c = Instance.new("UICorner")
			Btn.Size = UDim2.new(1, -5, 0, 36)
			Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 40)
			Btn.Font = Enum.Font.GothamSemibold
			Btn.Text = btnName
			Btn.TextColor3 = Theme.Accent
			Btn.TextSize = 14
			Btn.Parent = Page
			c.CornerRadius = UDim.new(0, 6)
			Btn.MouseButton1Click:Connect(callback)
		end

		function Elements:Label(textString)
			local Lbl = Instance.new("TextLabel")
			Lbl.Size = UDim2.new(1, -5, 0, 25)
			Lbl.BackgroundTransparency = 1
			Lbl.Font = Enum.Font.Gotham
			Lbl.Text = textString
			Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
			Lbl.TextSize = 13
			Lbl.TextXAlignment = Enum.TextXAlignment.Left
			Lbl.Parent = Page
		end

		return Elements
	end
	return Tabs
end


local Library = ModernLib:CreateMain("⚡ Avery Hub | Premium Dashboard ⚡")

local AutoFarm = Library:Tab("AutoDrink")
local LocalPlayer = Library:Tab("LocalPlayer")
local Teleport = Library:Tab("Teleports")
local Misc = Library:Tab("Misc")
local Scripts = Library:Tab("Scripts")
local Credits = Library:Tab("Credits")


local drinkTier = {
	{req = 2000000, name = "Garlic Juice"}, {req = 1000000, name = "Thunder Fizz"},
	{req = 500000, name = "Omega Burp Juice"}, {req = 230000, name = "Atomic Drink"},
	{req = 150000, name = "Ninth Drink"}, {req = 60000, name = "Eighth Drink"},
	{req = 25000, name = "Seventh Drink"}, {req = 10000, name = "Sixth Drink"},
	{req = 3500, name = "Fifth Drink"}, {req = 1600, name = "Fourth Drink"},
	{req = 600, name = "Third Drink"}, {req = 150, name = "Second Drink"},
	{req = 0, name = "Starter Drink"}
}

local function RunAutoEquipEngine()
	local stats = player:FindFirstChild("leaderstats")
	local burpPoints = stats and stats:FindFirstChild("Burp points") and stats["Burp points"].Value or 0
	local bp = player:FindFirstChild("Backpack")
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")

	if not bp or not hum then return end

	for _, drink in ipairs(drinkTier) do
		if burpPoints >= drink.req or bp:FindFirstChild(drink.name) then
			local target = bp:FindFirstChild(drink.name)
			if target then hum:EquipTool(target) end
			break
		end
	end
end


pcall(function()
	loadstring(game:HttpGet("https://gist.githubusercontent.com/RikoTheDemonHunter/78b69f79b7fa24fd0d20faa46c5cf85f/raw/2bc6ab144c95e2463d72060f2936befae2c5ccf1/Modern%2520Equip.lua"))()
end)


AutoFarm:Toggle("Auto Prestige", function(state)
	getgenv().prestige = state
	while getgenv().prestige do
		ReplicatedStorage.RemoteEvents.PrestigeEvent:FireServer()
		task.wait(0.8)
	end
end)

AutoFarm:Toggle("Auto Equip", function(state)
	getgenv().equip = state
	while getgenv().equip do
		RunAutoEquipEngine()
		task.wait(0.8)
	end
end)

AutoFarm:Toggle("Auto Collect Gem", function(state)
	getgenv().collectGems = state
	while getgenv().collectGems do
		local gemsFolder = workspace:FindFirstChild("Diamonds")
		local gem = gemsFolder and gemsFolder:FindFirstChild("Diamond")
		local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if gem and hrp then gem.CFrame = hrp.CFrame end
		task.wait(0.6)
	end
end)

AutoFarm:Toggle("Auto Drink", function(state)
	getgenv().autodrink = state
	while getgenv().autodrink do
		for _, drink in ipairs(drinkTier) do
			ReplicatedStorage.RemoteEvents.DrinkEvent:FireServer(drink.name)
		end
		task.wait(2.4)
	end
end)

AutoFarm:Toggle("Fast Drink", function(state)
	if state then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/v2.lua"))()
	end
end)

AutoFarm:Toggle("Auto Equip Pickaxe", function(state)
	getgenv().equippickaxe = state
	while getgenv().equippickaxe do
		local bp = player:FindFirstChild("Backpack")
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if bp and hum and bp:FindFirstChild("Pickaxe") then
			hum:EquipTool(bp.Pickaxe)
		end
		task.wait(0.5)
	end
end)

AutoFarm:Toggle("Auto Mine Gems", function(state)
	getgenv().minegems = state
	while getgenv().minegems do
		if player.Character and player.Character:FindFirstChild("Pickaxe") then
			player.Character.Pickaxe.Server.Mine:FireServer()
		end
		task.wait(0.1)
	end
end)


LocalPlayer:Button("Fps-Unlocker", function()
	if setfpscap then setfpscap(100000) end
end)

LocalPlayer:Toggle("WalkSpeed", function(state)
	getgenv().speedHack = state
	while getgenv().speedHack do
		if player.Character and player.Character:FindFirstChild("Humanoid") then
			player.Character.Humanoid.WalkSpeed = 459
		end
		task.wait()
	end
end)

LocalPlayer:Toggle("Inf Jump", function(state)
	getgenv().infJump = state
	if state then
		getgenv().jumpConnection = UserInputService.JumpRequest:Connect(function()
			if getgenv().infJump and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
				player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
			end
		end)
	else
		if getgenv().jumpConnection then getgenv().jumpConnection:Disconnect() end
	end
end)

LocalPlayer:Button("Reset", function()
	if player.Character then player.Character:BreakJoints() end
end)

LocalPlayer:Toggle("Rejoin", function(state)
	local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")

GuiService.ErrorMessageChanged:Connect(function()
   
    if GuiService:GetErrorMessage() ~= "" then
        
        task.wait(0.5) 
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
    end
end)

LocalPlayer:Toggle("Night", function(state)
	Lighting.ClockTime = state and 0 or 14
end)

LocalPlayer:Toggle("Sit", function(state)
	if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
		player.Character:FindFirstChildOfClass("Humanoid").Sit = state
	end
end)

LocalPlayer:Button("Auto Spawn", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Auto%20Spawn.lua"))()
end)

LocalPlayer:Button("List", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/User's.lua"))()
end)

LocalPlayer:Button("TP Gui", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Teleport.lua"))()
end)

LocalPlayer:Button("Cloud Stand", function()
	if state then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Cloud.lua"))()
	end
end)

LocalPlayer:Button("VoidStand", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/VoidStand.lua"))()
end)


local function tweenHRP(targetCFrame)
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		TweenService:Create(hrp, TweenInfo.new(0.2, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
	end
end

Teleport:Button("Safe Zone", function() tweenHRP(CFrame.new(-46, 48, -15)) end)
Teleport:Button("Pet Shop", function() tweenHRP(CFrame.new(311, 52, 103)) end)
Teleport:Button("Disco Island", function() tweenHRP(CFrame.new(63, 48, 636)) end)
Teleport:Button("Cloud One", function()
	local New_CFrame = CFrame.new(296, 566, 689)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Teleport:Button("Cloud Second", function()
	local New_CFrame = CFrame.new(-1224, 557, -318)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Teleport:Button("Sky Island", function()
	local New_CFrame = CFrame.new(2132, 1456, -1034)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Teleport:Button("SafePlace", function()
	local New_CFrame = CFrame.new(167, 48.28, -5357)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Teleport:Button("SafePlace v2", function()
	local New_CFrame = CFrame.new(0, 3605, 0)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Teleport:Button("FavSpot", function()
        local New_CFrame = CFrame.new(60.12, 18.25, -72)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Teleport:Button("Water Spot", function()
        local New_CFrame = CFrame.new(-564, 40, 605)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Teleport:Button("Hotel", function()
	 local New_CFrame = CFrame.new(-1198.279052734375, 44.315752029418945, -5.583522319793701)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Misc:Button("Bp Counter",function()
loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Bp%20Counter.lua"))()
end)

Misc:Button("Infinity Yield", function() 
loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)		

Misc:Toggle("Anti Kick", function(state)
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

Misc:Toggle("Anti Afk", function(state) 
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Anti%20Afk"))()
end)	

Misc:Button("Battery", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Battery.lua"))()
end)

Misc:Button("SafePlace", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/SafePlace%20v1"))()
end)

Misc:Button("Plate", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Plate.lua"))()
end)

Misc:Button("Castle", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Castle.lua"))()
end)

Misc:Button("Animation-Hub", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Gazer-Ha/Animated/main/G"))()
end)	

Misc:Toggle("Walk On Water",  function(bool)
				getgenv().walkonwater = bool
				for i,v in pairs(workspace:GetChildren()) do
					if v:IsA("Part") then
						if v.Color == Color3.fromRGB(9, 137, 207) then
							v.CanCollide = getgenv().walkonwater
						end
					end
				end
			end)


Misc:Button("Spam Burp", function()
	    loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Burp%20anti%20counter.lua"))()
	end)

Misc:Button("FPS Gui", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/FPS.lua"))()
	end)

Misc:Button("Spectate Gui", function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Spectate.lua"))()
	end)

Scripts:Button("SimonHax", function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/main/SimonHax"))()
end)
Scripts:Button("Orion V1", function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Orion%20Lib.lua"))()
end)
Scripts:Button("V7", function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/V7"))()
end)
Scripts:Button("Emotes-Hub", function()
           loadstring(game:HttpGet("https://pastebin.com/raw/eCpipCTH"))()
end)
Scripts:Button("Shift-Lock", function()
	   loadstring(game:HttpGet("https://scriptblox.com/raw/Universal-Script-Permanent-Shiftlock-7513"))()
end)		
Scripts:Button("Slow-Drink", function()
	   loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Slow.lua"))()
end)		
Scripts:Button("ZeroHub", function()
           loadstring(game:HttpGet("https://gist.githubusercontent.com/RikoTheDemonHunter/a1bf0423e73a5293c014042960cf4767/raw/faaa622081cbf015f0f54efb256e2ba182b57bca/shit.lua"))()
end)		
Scripts:Button("Avery", function()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Zero.lua"))()
end)
Scripts:Button("FriendList", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/FriendList.lua"))()
end)


Credits:Label("Developer: Avery")
Credits:Label("Build Architecture: Modern UI Premium")
Credits:Label("Discord: 90averyxx")
end)
