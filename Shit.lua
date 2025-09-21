
-- Avery Hub: Local verification dashboard with animated intro
-- Place this LocalScript in StarterPlayerScripts

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Remote JSON locations (keep as your originals)
local SWITCH_URL = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
local BANLIST_URL = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"

-- Safe helpers
local function safeDecode(json)
	if not json or json == "" then return nil end
	local ok, result = pcall(function() return HttpService:JSONDecode(json) end)
	return ok and result or nil
end

local function safeHttpGet(url)
	local ok, res = pcall(function() return game:HttpGet(url, true) end)
	return ok and res or nil
end

local function isInList(id, list)
	if type(list) ~= "table" then return false end
	for _, v in ipairs(list) do
		if v == id then return true end
	end
	return false
end

-- verifyUser function (returns whitelisted, banned, username, userId)
local function verifyUser(p, whitelist, banlist, killSwitchEnabled)
	local userId = (p and p.UserId) or 0
	local username = (p and p.Name) or "Unknown"
	local whitelisted = isInList(userId, whitelist)
	local banned = isInList(userId, banlist)

	-- server-like prints to local output for debugging
	if whitelisted then
		print(("✅ User verified as WHITELISTED — Name: %s | UserId: %d"):format(username, userId))
	else
		print(("❌ User is NOT whitelisted — Name: %s | UserId: %d"):format(username, userId))
	end

	if banned then
		print(("🚫 User is BANNED — Name: %s | UserId: %d"):format(username, userId))
	end

	-- killSwitchEnabled can be nil; treat nil as true (no whitelist requirement)
	-- In your previous code, enabled==false meant whitelist is required.
	local requiresWhitelist = (killSwitchEnabled == false)

	return whitelisted, banned, username, userId, requiresWhitelist
end

-- GUI creation (responsive + smooth)
local function createGui()
	local gui = Instance.new("ScreenGui")
	gui.Name = "AveryHubIntro"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.Parent = player:WaitForChild("PlayerGui")

	-- container frame (uses scale so it adapts)
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0.46, 0, 0.28, 0)
	frame.Position = UDim2.new(0.5, 0, 0.5, 0)
	frame.AnchorPoint = Vector2.new(0.5, 0.5)
	frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
	frame.BackgroundTransparency = 1 -- start hidden; tween in
	frame.BorderSizePixel = 0
	frame.Name = "AveryHubFrame"
	frame.Parent = gui

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 14)
	corner.Parent = frame

	local aspect = Instance.new("UIAspectRatioConstraint")
	aspect.AspectRatio = 1.8 -- width / height ratio
	aspect.Parent = frame

	local uiScale = Instance.new("UIScale")
	uiScale.Scale = 1
	uiScale.Parent = frame

	-- Title / status area
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(1, -28, 1, -28)
	statusLabel.Position = UDim2.new(0, 14, 0, 14)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Font = Enum.Font.GothamSemibold
	statusLabel.TextSize = 20
	statusLabel.TextColor3 = Color3.fromRGB(245,245,245)
	statusLabel.TextWrapped = true
	statusLabel.TextYAlignment = Enum.TextYAlignment.Top
	statusLabel.TextXAlignment = Enum.TextXAlignment.Center
	statusLabel.Text = "✨ Welcome to Avery Hub\n\nLet's run a few checks first..."
	statusLabel.TextTransparency = 1
	statusLabel.Parent = frame

	-- small footer label for extra status / errors
	local footer = Instance.new("TextLabel")
	footer.Name = "Footer"
	footer.Size = UDim2.new(1, -28, 0, 22)
	footer.Position = UDim2.new(0, 14, 1, -36)
	footer.BackgroundTransparency = 1
	footer.Font = Enum.Font.SourceSans
	footer.TextSize = 14
	footer.TextColor3 = Color3.fromRGB(200,200,200)
	footer.Text = ""
	footer.TextTransparency = 1
	footer.Parent = frame

	return gui, frame, statusLabel, footer
end

-- Tween helpers
local function tweenObject(obj, props, time, style, direction)
	local info = TweenInfo.new(time or 0.45, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
	local tw = TweenService:Create(obj, info, props)
	tw:Play()
	return tw
end

-- Kick helper (safe pcall)
local function safeKick(reason)
	local ok, _ = pcall(function()
		-- Local kick; server is authoritative but this will disconnect the local client view
		if player and player.Kick then
			player:Kick(reason or "Kicked by kill switch.")
		else
			-- fallback: force close by setting CoreGui? keep simple and just warn
			warn("Unable to call player:Kick() from LocalScript.")
		end
	end)
	return ok
end

-- Main flow
local function run()
	-- create GUI
	local gui, frame, statusLabel, footer = createGui()

	-- fade in frame and text
	tweenObject(frame, {BackgroundTransparency = 0.06}, 0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	tweenObject(statusLabel, {TextTransparency = 0}, 0.6)

	-- small initial pause
	task.wait(1.2)

	-- animated check sequence
	local function step(text, delayTime)
		-- fade out text
		local out = tweenObject(statusLabel, {TextTransparency = 1}, 0.35)
		out.Completed:Wait()
		statusLabel.Text = text
		-- fade in
		tweenObject(statusLabel, {TextTransparency = 0}, 0.35)
		task.wait(delayTime or 1.4)
	end

	step("🔍 Checking Whitelist...", 1.3)
	step("🛡️ Checking Kill Switch Status...", 1.3)
	step("🚫 Checking Banned Users...", 1.3)

	-- Fetch banlist (safe)
	local banlistRaw = safeHttpGet(BANLIST_URL)
	local banlist = {}
	if banlistRaw then
		local decoded = safeDecode(banlistRaw)
		if decoded and type(decoded) == "table" then
			banlist = decoded.banned or {}
		end
	else
		footer.Text = "⚠️ Could not fetch banlist."
		footer.TextTransparency = 0
		tweenObject(footer, {TextTransparency = 0}, 0.4)
		task.wait(1.2)
		tweenObject(footer, {TextTransparency = 1}, 0.4)
	end

	-- Fetch switcher
	local switchRaw = safeHttpGet(SWITCH_URL)
	local whitelist = {}
	local enabled = true -- default: kill-switch not actively requiring whitelist
	if switchRaw then
		local decoded = safeDecode(switchRaw)
		if decoded and type(decoded) == "table" then
			enabled = decoded.enabled == nil and enabled or decoded.enabled
			whitelist = decoded.whitelist or {}
		end
	else
		footer.Text = "⚠️ Could not fetch kill switch status."
		footer.TextTransparency = 0
		tweenObject(footer, {TextTransparency = 0}, 0.4)
		task.wait(1.2)
		tweenObject(footer, {TextTransparency = 1}, 0.4)
	end

	-- Compute verification results
	local whitelisted, banned, username, userId, requiresWhitelist =
		verifyUser(player, whitelist, banlist, enabled)

	-- Build the final message and action logic
	local whitelistMsg = whitelisted and "✅ Yes — you are whitelisted." or "❌ No — you are NOT whitelisted."
	local bannedMsg = banned and "🚫 Yes — you are BANNED." or "❌ No"
	local killSwitchStateMsg
	if enabled == false then
		killSwitchStateMsg = "Kill switch: ON — whitelist required."
	else
		killSwitchStateMsg = "Kill switch: OFF — whitelist NOT required."
	end

	-- Compose display text
	local finalText = string.format(
		"✅ Verification Complete\n\nName: %s\nUserId: %d\n\nWhitelist: %s\nBanned: %s\n\n%s",
		tostring(username), tonumber(userId) or 0, (whitelisted and "✅ Yes" or "❌ No"), (banned and "🚫 Yes" or "❌ No"),
		killSwitchStateMsg
	)

	-- Fade into final text smoothly
	step(finalText, 2.6)

	-- Additional friendly messages and actions
	-- Priority: if banned -> show banned message and kick
	-- Next: if kill-switch requires whitelist and user not whitelisted -> show kick message and kick
	-- Else: show friendly "you can continue" message

	if banned then
		step("🚫 You are BANNED — you will be kicked in an instant.", 1.6)
		-- brief pause so player sees message
		task.wait(0.8)
		safeKick("You are permanently banned.")
		return
	end

	if requiresWhitelist and not whitelisted then
		step("⚠️ Sorry — you are NOT whitelisted. You will be kicked in an instant.", 1.6)
		task.wait(0.9)
		-- attempt client-side kick
		safeKick("Your UserID is not whitelisted.")
		return
	end

	-- If kill switch is off (whitelist not required), show that as info
	if not requiresWhitelist then
		step("ℹ️ Kill switch is OFF — whitelist not required. You may continue.", 1.6)
		task.wait(1)
	else
		-- whitelisted and whitelist required
		step("🎉 Great — you are whitelisted! You may continue.", 1.6)
		task.wait(1)
	end

	-- End animation: fade out frame & text
	tweenObject(statusLabel, {TextTransparency = 1}, 0.55)
	local outFrame = tweenObject(frame, {BackgroundTransparency = 1}, 0.8)
	outFrame.Completed:Wait()
	-- Clean up
	if gui and gui.Parent then
		gui:Destroy()
	end
end

-- Run the flow in a protected pcall so script doesn't error unexpectedly
local ok, err = pcall(run)
if not ok then
	warn("AveryHubIntro LocalScript error:", tostring(err))
end
-- ENABLES THE SCRIPT AND LOADS THE GUI performs safety checks first
local lib = {}
		
function lib:Gui(title)
	
	local DarkLib = Instance.new("ScreenGui")
	local Main = Instance.new("Frame")
	local TabSide = Instance.new("ScrollingFrame")
	local UICorner = Instance.new("UICorner")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local UICorner_3 = Instance.new("UICorner")
	local UICorner_5 = Instance.new("UICorner")
	local SectionSide = Instance.new("Frame")
	local close = Instance.new("ImageButton")
	local SectionCorner = Instance.new("UICorner")
	local Title = Instance.new("TextLabel")

	DarkLib.Name = "DarkLib"
	DarkLib.Parent = game.CoreGui
	DarkLib.ResetOnSpawn = false
	
	game:GetService("UserInputService").InputBegan:Connect(function(key, gameProcessedEvent)
		if key.KeyCode == Enum.KeyCode.LeftAlt then
			if DarkLib.Enabled then
			DarkLib.Enabled = false
		else
			DarkLib.Enabled = true
			end
		end
	end)

	Main.Name = "Main"
	Main.Parent = DarkLib
	Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	Main.Position = UDim2.new(0.367263854, 0, 0.263959408, 0)
	Main.Size = UDim2.new(0, 382, 0, 219)
	
	local Drag = Main
	local CoreGui = game:GetService("CoreGui")
	local Tween = game:GetService("TweenService")
	local UserInputService = game:GetService("UserInputService")
	local dragging
	local dragInput
	local dragStart
	local startPos
	local function update(input)
		local delta = input.Position - dragStart
		local dragTime = 0.06
		local SmoothDrag = {}
		SmoothDrag.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		local dragSmoothFunction = Tween:Create(Drag, TweenInfo.new(dragTime, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), SmoothDrag)
		dragSmoothFunction:Play()
	end
	Drag.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = Drag.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	Drag.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging and Drag.Size then
			update(input)
		end
	end)

	TabSide.Name = "TabSide"
	TabSide.Parent = Main
	TabSide.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	TabSide.BorderSizePixel = 0
	TabSide.Position = UDim2.new(0.021, 0,0.038, 0)
	TabSide.Size = UDim2.new(0, 92,0, 203)
	TabSide.ScrollingDirection = Enum.ScrollingDirection.Y
	TabSide.ScrollBarThickness = 5
	TabSide.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
	TabSide.ClipsDescendants = true

	UICorner.Parent = TabSide
	UICorner.CornerRadius = UDim.new(0, 8)

	UIListLayout_1.Parent = TabSide
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.Padding = UDim.new(0, 10)
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout_1.Changed:Connect(function()
		TabSide.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_1.AbsoluteContentSize.Y)
	end)

	SectionSide.Name = "SectionSide"
	SectionSide.Parent = Main
	SectionSide.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	SectionSide.Position = UDim2.new(0.29842931, 0, 0.146118715, 0)
	SectionSide.Size = UDim2.new(0, 255, 0, 173)
	SectionSide.ClipsDescendants = true
	SectionSide.Visible = true
	
	SectionCorner.Parent = SectionSide
	SectionCorner.CornerRadius = UDim.new(0, 8)

	UICorner_5.Parent = Main
	
	close.Name = "close"
	close.Parent = Main
	close.BackgroundTransparency = 1.000
	close.Position = UDim2.new(0.934554935, 0, -0.00228309631, 0)
	close.Size = UDim2.new(0, 25, 0, 25)
	close.ZIndex = 2
	close.Image = "rbxassetid://3926305904"
	close.ImageRectOffset = Vector2.new(284, 4)
	close.ImageRectSize = Vector2.new(24, 24)
	close.MouseButton1Click:Connect(function()
		DarkLib:Destroy()
	end)
	
	Title.Name = "Title"
	Title.Parent = Main
	Title.BackgroundColor3 = Color3.fromRGB(123, 180, 0)
	Title.BackgroundTransparency = 1.000
	Title.BorderSizePixel = 0
	Title.Position = UDim2.new(0, 90, 0, 0)
	Title.Size = UDim2.new(0, 200, 0, 46)
	Title.Font = Enum.Font.FredokaOne
	Title.TextColor3 = Color3.fromRGB(255, 0, 0)
	Title.TextScaled = false
	Title.TextSize = 30.000
	Title.TextWrapped = true
	Title.Text = title

	local Tabs = {}

	function Tabs:Tab(name)
		local TextButton = Instance.new("TextButton")
		local UICorner_2 = Instance.new("UICorner")

		TextButton.Parent = TabSide
		TextButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
		TextButton.Position = UDim2.new(0, 0, 0.0821917802, 0)
		TextButton.Size = UDim2.new(0, 70, 0, 30)
		TextButton.Font = Enum.Font.Highway
		TextButton.TextColor3 = Color3.fromRGB(0, 0, 255)
		TextButton.TextScaled = true
		TextButton.TextSize = 14.000
		TextButton.TextWrapped = true
		TextButton.Text = name
		TextButton.Name = name

		UICorner_2.Parent = TextButton
		UICorner_2.CornerRadius = UDim.new(0, 8)

		local Sections = {}

		function Sections:Section(name)
			local Page = Instance.new("ScrollingFrame")
			local UIListLayout = Instance.new("UIListLayout")

			Page.Name = name
			Page.Parent = SectionSide
			Page.Active = true
			Page.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			Page.BorderSizePixel = 0
			Page.Position = UDim2.new(0.0470588244, 0, 0.10404624, 0)
			Page.Size = UDim2.new(0, 237, 0, 145)
			Page.ScrollingDirection = Enum.ScrollingDirection.Y
			Page.ScrollBarThickness = 5
			Page.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)

			UIListLayout.Parent = Page
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 10)
			UIListLayout.Changed:Connect(function()
				Page.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y)
			end)

			TextButton.MouseButton1Click:Connect(function()
				for i,v in next, SectionSide:GetChildren() do
					if v:IsA("ScrollingFrame") then
						v.Visible = false
					end
				end
				Page.Visible = true
			end)

			local Elements = {}
			
			function Elements:Toggle(name, callback)
				local ToggleElement = Instance.new("Frame")
				local UICorner = Instance.new("UICorner")
				local ToggleState = Instance.new("TextLabel")
				local Click = Instance.new("TextButton")
				
				ToggleElement.Name = name
				ToggleElement.Parent = Page
				ToggleElement.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				ToggleElement.Size = UDim2.new(0, 220, 0, 30)

				UICorner.Parent = ToggleElement

				ToggleState.Name = "ToggleState"
				ToggleState.Parent = ToggleElement
				ToggleState.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ToggleState.BackgroundTransparency = 1.000
				ToggleState.BorderSizePixel = 0
				ToggleState.Size = UDim2.new(0, 46, 0, 30)
				ToggleState.Font = Enum.Font.FredokaOne
				ToggleState.Text = ""
				ToggleState.TextColor3 = Color3.fromRGB(255, 255, 255)
				ToggleState.TextScaled = true
				ToggleState.TextSize = 14.000
				ToggleState.TextWrapped = true

				Click.Name = "Click"
				Click.Parent = ToggleElement
				Click.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Click.BackgroundTransparency = 1.000
				Click.BorderSizePixel = 0
				Click.Size = UDim2.new(0, 220, 0, 30)
				Click.Font = Enum.Font.Highway
				Click.Text = name
				Click.TextColor3 = Color3.fromRGB(0, 255, 0)
				Click.TextScaled = true
				Click.TextSize = 14.000
				Click.TextWrapped = true
				local toggle = false
				local debounce = false
				Click.MouseButton1Click:Connect(function()
					if debounce == false then
						if toggle == false then
						debounce = true
							ToggleState.Text = "X"
							wait(0.25)
							debounce = false
							toggle = true
							pcall(callback, toggle)
						elseif toggle == true then
							debounce = true
							ToggleState.Text = ""
							wait(0.25)
							debounce = false
							toggle = false
							pcall(callback, toggle)
						end
					end
				end)
			end
			
			function Elements:Label(name)
				local TextLabel = Instance.new("TextLabel")

				TextLabel.Parent = Page
				TextLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				TextLabel.BackgroundTransparency = 1
				TextLabel.Position = UDim2.new(0, 0, 0.0821917802, 0)
				TextLabel.Size = UDim2.new(0, 220, 0, 30)
				TextLabel.Font = Enum.Font.Highway
				TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.TextScaled = true
				TextLabel.TextSize = 14.000
				TextLabel.TextWrapped = true
				TextLabel.Text = name
				TextLabel.Name = name
				
			end
			function Elements:Button(name, callback)
				local TextButton_2 = Instance.new("TextButton")
				local UICorner_4 = Instance.new("UICorner")

				callback = callback or function() end

				TextButton_2.Parent = Page
				TextButton_2.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				TextButton_2.Position = UDim2.new(0, 0, 0.0821917802, 0)
				TextButton_2.Size = UDim2.new(0, 220, 0, 30)
				TextButton_2.Font = Enum.Font.Highway
				TextButton_2.TextColor3 = Color3.fromRGB(0, 255, 0)
				TextButton_2.TextScaled = true
				TextButton_2.TextSize = 14.000
				TextButton_2.TextWrapped = true
				TextButton_2.Text = name
				TextButton_2.Name = name
				TextButton_2.MouseButton1Click:Connect(function()
					callback()
				end)

				UICorner_4.Parent = TextButton_2
			end
			return Elements
		end
		return Sections
	end
	return Tabs
end

local Library = lib:Gui("⚡Avery-Hub⚡")

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

local CreditsTab =
Library:Tab("Credits")

local Credits =
CreditsTab:Section("Credits")

function AutoEquip()spawn(function(v)
		while getgenv().equip == true do
			wait(0.8)

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
			if game.Players.LocalPlayer.leaderstats["Burp points"].Value >= 600 then
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
		end
	end)
end

AutoFarm:Toggle("Auto Prestige", function(v)
	while wait(0.8) do
		game.ReplicatedStorage.RemoteEvents.PrestigeEvent:FireServer()
	end
end)

AutoFarm:Toggle("Auto Equip", function(v)
				getgenv().equipdrink = v
				while getgenv().equipdrink do wait(0.8)
					AutoEquipDrink()
				end
			end)

loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Auto%20Equip.lua"))()

AutoFarm:Toggle("Auto Collect Gem", function(v)
	while wait(0.6) do
		local gem = game.Workspace.Diamonds:WaitForChild("Diamond")
		local Char = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		gem.CFrame = Char.CFrame
	end
end)

AutoFarm:Toggle("Auto Drink", function(v)
	getgenv().autodrink = v
				while getgenv().autodrink do wait(2.4)
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

AutoFarm:Toggle("Fast Drink", function(v)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/v2.lua"))()
end)

AutoFarm:Toggle("Auto Equip PIckaxe", function(v)
 getgenv().equippickaxe = v
				while getgenv().equippickaxe do wait(0.5)
					if game:GetService("Players").LocalPlayer.Backpack.Pickaxe ~= nil then
						game:GetService("Players").LocalPlayer.Character.Humanoid:EquipTool(game:GetService("Players").LocalPlayer.Backpack.Pickaxe)
					end
				end
			end)

AutoFarm:Toggle("Auto Mine Gems", function(v)
	getgenv().minegems = v
				while getgenv().minegems do wait(0.1)
					game:GetService("Players").LocalPlayer.Character.Pickaxe.Server.Mine:FireServer()
				end
			end)

LocalPlayer:Button("Fps-Unlocker", function(v)
	if setfpscap and type(setfpscap) == "function" then
		local num = 100000 or 1e6
		if num == 'none' then
			return setfpscap(1e6)
		elseif num > 0 then
			return setfpscap(num)
		end
	end
end)

LocalPlayer:Toggle("WalkSpeed", function(v)
	while wait() do
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 459
	end
end)

LocalPlayer:Toggle("Inf Jump", function(v)
	game:GetService("UserInputService").JumpRequest:connect(function()
		game:GetService"Players".LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
	end)
end)

LocalPlayer:Button("Reset", function(v)
				game.Players.LocalPlayer.Character:BreakJoints()
			end)
LocalPlayer:Button("Rejoin", function(v)
				game:GetService("TeleportService"):Teleport(game.PlaceId)
			end)
 
LocalPlayer:Toggle("Night",  function(v)
				if v then
					game.Lighting.ClockTime = 0
				elseif not v then
					game.Lighting.ClockTime = 14
				end
			end)

LocalPlayer:Toggle("Sit", function(v)
				getgenv().sit = v
				game.Players.LocalPlayer.Character.Humanoid.Sit = getgenv().sit
			end)

LocalPlayer:Button("Auto Spawn", function(v)
		loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Auto%20Spawn.lua"))()
	end)

LocalPlayer:Button("List", function(v)
	       loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/User's.lua"))()
	end)

LocalPlayer:Button("TP Gui", function(v) 
	       loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Teleport.lua"))()
	end)

LocalPlayer:Toggle("Cloud Stand", function(v)
           loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Cloud.lua"))()
	end)

LocalPlayer:Button("VoidStand", function(v)
		    loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/VoidStand.lua"))()
	end)

Teleport:Button("Safe Zone", function()
	local New_CFrame = CFrame.new(-46, 48, -15)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Teleport:Button("Pet Shop", function()
	local New_CFrame = CFrame.new(311, 52, 103)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

Teleport:Button("Disco Island", function()
	local New_CFrame = CFrame.new(63, 48, 636)

	local ts = game:GetService("TweenService")
	local char = game.Players.LocalPlayer.Character

	local part = char.HumanoidRootPart
	local ti = TweenInfo.new(0.2, Enum.EasingStyle.Linear)
	local tp = {CFrame = New_CFrame}
	ts:Create(part, ti, tp):Play()
end)

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

Misc:Button("Anti Kick", function()
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

Misc:Button("Anti Afk", function() 
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

Credits:Button("Made By Avery")

Credits:Button("Discord: 90averyxx")
Credits:Button("Note: Auto Drink is 2.4")
Credits:Button("Note: Copy Stealers Fuck Off")
Credits:Button("Update: Added WhiteList System & Auto Spawn & Cloud PLatform")
Credits:Button("Games: Games Tab Soon")
Scripts:Button("SimonHub", function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/SimonHub"))()
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
