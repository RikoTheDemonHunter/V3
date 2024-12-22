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

local Library = lib:Gui("Puro-Hub V1.0")

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

AutoFarm:Toggle("Auto Equip", function(bool)
	getgenv().equip = bool
	if bool then
		AutoEquip()
	end
end)

AutoFarm:Toggle("Auto Collect Gem", function(v)
	while wait(0.6) do
		local gem = game.Workspace.Diamonds:WaitForChild("Diamond")
		local Char = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		gem.CFrame = Char.CFrame
	end
end)

AutoFarm:Toggle("Auto Drink", function(v)
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

LocalPlayer:Button("WalkSpeed", function(v)
	while wait() do
		game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = 459
	end
end)

LocalPlayer:Button("Inf Jump", function(v)
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

Teleport:Button("FavSpot", function()
        local New_CFrame = CFrame.new(60, 40, -72)

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

Teleport:Button("Safeplace v2", function()
        local New_CFrame = CFrame.new(531, 1223, 0)

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

Misc:Button("SafePlace", function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/SafePlace"))()
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
		
Misc:Button("Safeplace v2",  function()
				loadstring(game:HttpGet("https://sonic998.github.io/sonichub/Shit/HackerMansion.lua"))()
			end)

Credits:Button("Made By 90PuroXx")

Credits:Button("Discord: rikothedemonlord")
Credits:Button("Note: Auto Drink is 2.4")
Credits:Button("Note: Copy Stealers Fuck Off")
Credits:Button("Update: Script is Up")
Scripts:Button("SimonHub", function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/SimonHub"))()
end)
Scripts:Button("SimonHax", function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/main/SimonHax"))()
end)
Scripts:Button("Drinkhaxx", function()
           loadstring(game:HttpGet("https://raw.githubusercontent.com/RikoTheDemonHunter/V3/main/drinkhaxx"))()
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
