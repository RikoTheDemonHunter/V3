
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- 🎨 THEME COLORS
local Theme = {
	Background = Color3.fromRGB(25, 25, 35),
	Accent = Color3.fromRGB(0, 170, 255),
	TextColor = Color3.fromRGB(255, 255, 255),
	Alert = Color3.fromRGB(255, 80, 80),
	Success = Color3.fromRGB(0, 200, 100),
	Highlight = Color3.fromRGB(255, 215, 0)
}

-- URLs
local url = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
local banlistUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"

-- Helpers
local function isBanned(userId, banlist)
	for _, id in ipairs(banlist) do
		if id == userId then
			return true
		end
	end
	return false
end

local function isWhitelisted(userId, whitelist)
	for _, id in ipairs(whitelist) do
		if id == userId then
			return true
		end
	end
	return false
end

local function verifyUser(p, wl, bl)
	local userId = p.UserId
	local username = p.Name or "Unknown"
	local whitelisted = isWhitelisted(userId, wl)
	local banned = isBanned(userId, bl)
	return whitelisted, banned, username, userId
end

-- 🌟 GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AveryHubIntro"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.5, 0, 0.55, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Theme.Background
frame.BackgroundTransparency = 0.1
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = frame

local uiScale = Instance.new("UIScale")
uiScale.Parent = frame
uiScale.Scale = UserInputService.TouchEnabled and 1.3 or 1

-- ✨ Status text
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 40)
statusLabel.Position = UDim2.new(0, 10, 0, 10)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 22
statusLabel.TextColor3 = Theme.TextColor
statusLabel.TextWrapped = true
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Top
statusLabel.Text = "✨ Welcome to Avery Hub"
statusLabel.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Theme.Accent
stroke.Transparency = 0.4
stroke.Parent = statusLabel

-- 🔒 Branding
local brandLabel = Instance.new("TextLabel")
brandLabel.Size = UDim2.new(1, -20, 0, 20)
brandLabel.Position = UDim2.new(0, 10, 0, 60)
brandLabel.BackgroundTransparency = 1
brandLabel.Font = Enum.Font.Gotham
brandLabel.TextSize = 16
brandLabel.TextColor3 = Theme.Accent
brandLabel.TextTransparency = 1
brandLabel.TextXAlignment = Enum.TextXAlignment.Left
brandLabel.TextYAlignment = Enum.TextYAlignment.Top
brandLabel.Text = "🔒 This switch is made by Avery"
brandLabel.Parent = frame

-- Outro
local outroLabel = Instance.new("TextLabel")
outroLabel.Size = UDim2.new(1, -20, 0, 40)
outroLabel.Position = UDim2.new(0, 10, 0.85, 0)
outroLabel.BackgroundTransparency = 1
outroLabel.Font = Enum.Font.GothamBold
outroLabel.TextSize = 20
outroLabel.TextColor3 = Color3.fromRGB(255, 100, 150)
outroLabel.TextWrapped = true
outroLabel.TextTransparency = 1
outroLabel.TextXAlignment = Enum.TextXAlignment.Left
outroLabel.TextYAlignment = Enum.TextYAlignment.Top
outroLabel.Text = "💖 Show your support by following Avery on Discord!"
outroLabel.Parent = frame

-- ✅ Scroll frame for whitelisted and banned users
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 0.6, -80)
scrollFrame.Position = UDim2.new(0, 10, 0.15, 0)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = frame

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 4)
uiList.Parent = scrollFrame

-- Tween helpers
local function fadeText(newText, delayTime)
	local fadeOut = TweenService:Create(statusLabel, TweenInfo.new(0.5), {TextTransparency = 1})
	fadeOut:Play()
	fadeOut.Completed:Wait()
	statusLabel.Text = newText
	local fadeIn = TweenService:Create(statusLabel, TweenInfo.new(0.5), {TextTransparency = 0})
	fadeIn:Play()
	task.wait(delayTime or 1.5)
end

local function showBrand(delayTime)
	local fadeIn = TweenService:Create(brandLabel, TweenInfo.new(0.8), {TextTransparency = 0})
	fadeIn:Play()
	task.wait(delayTime or 1.5)
end

local function showOutro(delayTime)
	local fadeIn = TweenService:Create(outroLabel, TweenInfo.new(1), {TextTransparency = 0})
	fadeIn:Play()
	task.wait(delayTime or 2)
end

-- 🔎 Intro flow
task.wait(1.5)
fadeText("✨ Welcome to Avery Hub", 1.5)
showBrand(1.8)
fadeText("🔍 Checking Whitelist...", 1.5)
fadeText("🛡️ Checking Kill Switch Status...", 1.5)
fadeText("🚫 Checking Banned Users...", 1.5)

-- 📡 Fetch data
local banData, whitelist, enabled = {}, {}, true

local banSuccess, rawBan = pcall(function()
	return game:HttpGet(banlistUrl, true)
end)
if banSuccess then
	local decode = HttpService:JSONDecode(rawBan)
	banData = decode.banned or {}
end

local success, raw = pcall(function()
	return game:HttpGet(url, true)
end)
if success then
	local result = HttpService:JSONDecode(raw)
	enabled = result.enabled
	whitelist = result.whitelist or {}
end

-- ✅ Verify
local whitelisted, banned, username, userId = verifyUser(player, whitelist, banData)

-- 📝 Show whitelisted users
for _, id in ipairs(whitelist) do
	local name
	local success, plr = pcall(function() return Players:GetNameFromUserIdAsync(id) end)
	if success then name = plr else name = "Unknown" end

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 22)
	label.BackgroundTransparency = 1
	label.Font = Enum.Font.Gotham
	label.TextSize = 16
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextColor3 = (id == player.UserId) and Theme.Highlight or Theme.Success
	label.Text = (id == player.UserId) and ("⭐ %s | UserId: %d (YOU)"):format(name, id)
	                                  or ("✅ %s | UserId: %d"):format(name, id)
	label.Parent = scrollFrame
end

-- 📝 Show banned users
for _, id in ipairs(banData) do
	if not isWhitelisted(id, whitelist) then
		local name
		local success, plr = pcall(function() return Players:GetNameFromUserIdAsync(id) end)
		if success then name = plr else name = "Unknown" end

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -10, 0, 22)
		label.BackgroundTransparency = 1
		label.Font = Enum.Font.Gotham
		label.TextSize = 16
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Center
		label.TextColor3 = Theme.Alert
		label.Text = ("🚫 %s | UserId: %d"):format(name, id)
		label.Parent = scrollFrame
	end
end

-- Update canvas size dynamically
local function updateCanvasSize()
	local total = 0
	for _, child in ipairs(scrollFrame:GetChildren()) do
		if child:IsA("TextLabel") then
			total = total + child.Size.Y.Offset + uiList.Padding.Offset
		end
	end
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, total)
end
updateCanvasSize()

-- 📝 Dashboard + Results
if banned then
	fadeText(("🚫 You are BANNED!\nName: %s\nUserId: %d"):format(username, userId), 3)
	showOutro(2)
	task.wait(1.5)
	player:Kick("🚫 You are banned from Avery Hub.")
	return
elseif not whitelisted and not enabled then
	fadeText(("❌ Not Whitelisted.\nKill switch is ON.\nName: %s\nUserId: %d"):format(username, userId), 3)
	showOutro(2)
	task.wait(1.5)
	player:Kick("❌ You are not whitelisted and kill switch is ON.")
	return
elseif not whitelisted then
	fadeText(("❌ Not Whitelisted.\nName: %s\nUserId: %d"):format(username, userId), 3)
	showOutro(2)
	task.wait(1.5)
	player:Kick("❌ You are not whitelisted.")
	return
else
	local ksStatus = enabled and "DISABLED" or "ENABLED (bypassed)"
	fadeText(("✅ Great! You are whitelisted.\nName: %s\nUserId: %d\nKill switch: %s"):format(username, userId, ksStatus), 2.5)
	showOutro(3)
end

-- ⚠️ Final warning before closing
fadeText("⚠️ You cannot modify this switch now. F*** off.", 2)

-- 🎬 Closing animation
local shrink = TweenService:Create(uiScale, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0})
local fadeOutGui = TweenService:Create(frame, TweenInfo.new(0.6), {BackgroundTransparency = 1})
shrink:Play()
fadeOutGui:Play()
task.wait(0.7)
gui:Destroy()

-- ENABLES THE SCRIPT AND LOADS THE GUI performs safety checks first
-- Mobile-Optimized Avery Dark GUI with Minimize
local lib = {}

function lib:Gui(title)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")

    -- ScreenGui
    local DarkLib = Instance.new("ScreenGui")
    DarkLib.Name = "AveryDarkLib"
    DarkLib.Parent = game.CoreGui
    DarkLib.ResetOnSpawn = false
    DarkLib.DisplayOrder = 999

    -- Toggle GUI visibility with LeftAlt
    UserInputService.InputBegan:Connect(function(input, processed)
        if not processed and input.KeyCode == Enum.KeyCode.LeftAlt then
            DarkLib.Enabled = not DarkLib.Enabled
        end
    end)

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = DarkLib
    Main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    Main.Size = UDim2.new(0.8, 0, 0.6, 0)
    Main.Position = UDim2.new(0.1, 0, 0.2, 0)
    local MainCorner = Instance.new("UICorner", Main)
    MainCorner.CornerRadius = UDim.new(0, 12)

    -- UIScale for mobile responsiveness
    local MainScale = Instance.new("UIScale", Main)
    MainScale.Scale = 1

    -- Draggable functionality
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        TweenService:Create(Main, TweenInfo.new(0.06, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
            Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                 startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        }):Play()
    end
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    Main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    -- Close Button
    local Close = Instance.new("ImageButton")
    Close.Name = "Close"
    Close.Parent = Main
    Close.BackgroundTransparency = 1
    Close.Position = UDim2.new(0.95, 0, 0, 0)
    Close.Size = UDim2.new(0, 28, 0, 28)
    Close.Image = "rbxassetid://3926305904"
    Close.ImageRectOffset = Vector2.new(284, 4)
    Close.ImageRectSize = Vector2.new(24, 24)
    Close.MouseButton1Click:Connect(function()
        DarkLib:Destroy()
    end)

    -- Minimize Button
    local Minimize = Instance.new("TextButton")
    Minimize.Name = "Minimize"
    Minimize.Parent = Main
    Minimize.BackgroundTransparency = 1
    Minimize.Position = UDim2.new(0.90, 0, 0, 0)
    Minimize.Size = UDim2.new(0, 28, 0, 28)
    Minimize.Font = Enum.Font.FredokaOne
    Minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
    Minimize.TextScaled = true
    Minimize.Text = "_"
    local minimized = false
    Minimize.MouseButton1Click:Connect(function()
        if not minimized then
            TabSide.Visible = false
            SectionSide.Visible = false
            minimized = true
        else
            TabSide.Visible = true
            SectionSide.Visible = true
            minimized = false
        end
    end)

    -- Title
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Parent = Main
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0.05, 0, 0, 0)
    TitleLabel.Size = UDim2.new(0.85, 0, 0.1, 0)
    TitleLabel.Font = Enum.Font.FredokaOne
    TitleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
    TitleLabel.TextScaled = true
    TitleLabel.TextWrapped = true
    TitleLabel.Text = title

    -- Tab Container
    local TabSide = Instance.new("ScrollingFrame")
    TabSide.Name = "TabSide"
    TabSide.Parent = Main
    TabSide.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    TabSide.BorderSizePixel = 0
    TabSide.Position = UDim2.new(0.02, 0, 0.12, 0)
    TabSide.Size = UDim2.new(0.22, 0, 0.85, 0)
    TabSide.ScrollBarThickness = 6
    TabSide.ClipsDescendants = true
    TabSide.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local TabCorner = Instance.new("UICorner", TabSide)
    TabCorner.CornerRadius = UDim.new(0, 10)
    local TabLayout = Instance.new("UIListLayout", TabSide)
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 10)
    TabLayout.VerticalAlignment = Enum.VerticalAlignment.Top

    -- Section Container
    local SectionSide = Instance.new("Frame")
    SectionSide.Name = "SectionSide"
    SectionSide.Parent = Main
    SectionSide.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    SectionSide.Position = UDim2.new(0.26, 0, 0.12, 0)
    SectionSide.Size = UDim2.new(0.72, 0, 0.85, 0)
    SectionSide.ClipsDescendants = true
    local SectionCorner = Instance.new("UICorner", SectionSide)
    SectionCorner.CornerRadius = UDim.new(0, 10)

    -- Tabs & Sections
    local Tabs = {}
    function Tabs:Tab(name)
        local Button = Instance.new("TextButton")
        Button.Parent = TabSide
        Button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        Button.Size = UDim2.new(1, 0, 0, 40)
        Button.Font = Enum.Font.Highway
        Button.TextColor3 = Color3.fromRGB(0, 255, 0)
        Button.TextScaled = true
        Button.TextWrapped = true
        Button.Text = name
        local ButtonCorner = Instance.new("UICorner", Button)
        ButtonCorner.CornerRadius = UDim.new(0, 8)

        local Sections = {}
        function Sections:Section(name)
            local Page = Instance.new("ScrollingFrame")
            Page.Name = name
            Page.Parent = SectionSide
            Page.Active = true
            Page.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Page.BorderSizePixel = 0
            Page.Size = UDim2.new(1, -20, 1, -20)
            Page.Position = UDim2.new(0, 10, 0, 10)
            Page.ScrollBarThickness = 6
            Page.ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255)
            Page.Visible = false
            local Layout = Instance.new("UIListLayout", Page)
            Layout.SortOrder = Enum.SortOrder.LayoutOrder
            Layout.Padding = UDim.new(0, 12)
            Page.AutomaticCanvasSize = Enum.AutomaticSize.Y

            Button.MouseButton1Click:Connect(function()
                for _, v in next, SectionSide:GetChildren() do
                    if v:IsA("ScrollingFrame") then
                        v.Visible = false
                    end
                end
                Page.Visible = true
            end)

            local Elements = {}
            function Elements:Toggle(name, callback)
                local Toggle = Instance.new("TextButton")
                Toggle.Parent = Page
                Toggle.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Toggle.Size = UDim2.new(1, 0, 0, 35)
                Toggle.Font = Enum.Font.Highway
                Toggle.TextColor3 = Color3.fromRGB(0, 255, 0)
                Toggle.TextScaled = true
                Toggle.TextWrapped = true
                Toggle.Text = name
                local ToggleCorner = Instance.new("UICorner", Toggle)
                ToggleCorner.CornerRadius = UDim.new(0, 8)

                local State = Instance.new("TextLabel")
                State.Parent = Toggle
                State.BackgroundTransparency = 1
                State.Size = UDim2.new(0.2, 0, 1, 0)
                State.Position = UDim2.new(0.8, 0, 0, 0)
                State.Font = Enum.Font.FredokaOne
                State.TextColor3 = Color3.fromRGB(255, 255, 255)
                State.TextScaled = true
                State.Text = ""

                local toggle = false
                local debounce = false
                Toggle.MouseButton1Click:Connect(function()
                    if debounce then return end
                    debounce = true
                    toggle = not toggle
                    State.Text = toggle and "X" or ""
                    pcall(callback, toggle)
                    wait(0.25)
                    debounce = false
                end)
            end

            function Elements:Button(name, callback)
                local Btn = Instance.new("TextButton")
                Btn.Parent = Page
                Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                Btn.Size = UDim2.new(1, 0, 0, 35)
                Btn.Font = Enum.Font.Highway
                Btn.Text = name
                Btn.TextColor3 = Color3.fromRGB(0, 255, 0)
                Btn.TextScaled = true
                Btn.TextWrapped = true
                local BtnCorner = Instance.new("UICorner", Btn)
                BtnCorner.CornerRadius = UDim.new(0, 8)
                Btn.MouseButton1Click:Connect(callback)
            end

            function Elements:Label(name)
                local Label = Instance.new("TextLabel")
                Label.Parent = Page
                Label.BackgroundTransparency = 1
                Label.Size = UDim2.new(1, 0, 0, 35)
                Label.Font = Enum.Font.Highway
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextScaled = true
                Label.TextWrapped = true
                Label.Text = name
            end

            return Elements
        end

        return Sections
    end

    return Tabs
end

-- Example usage
local Library = lib:Gui("⚡Avery-Hub⚡")
local AutoTab = Library:Tab("AutoDrink")
local AutoSection = AutoTab:Section("AutoDrink")
local LocalTab = Library:Tab("LocalPlayer")
local LocalSection = LocalTab:Section("LocalPlayer")
local TeleTab = Library:Tab("Teleports")
local TeleSection = TeleTab:Section("Teleport")
local MiscTab = Library:Tab("Misc")
local MiscSection = MiscTab:Section("Misc")
local ScriptsTab = Library:Tab("Scripts")
local ScriptsSection = ScriptsTab:Section("Scripts")
local CreditsTab = Library:Tab("Credits")
local CreditsSection = CreditsTab:Section("Credits")

return lib

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
