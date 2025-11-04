getgenv().users = {
  ["Riko"] = 1497286101,
 
}



local whitelist = { "macmacinRoblox", "Rikothedev12", } 
 
local Players = game:GetService("Players")
local player = Players.LocalPlayer -- 
 
local function isWhitelisted(name)
    for _, whitelistedName in ipairs(whitelist) do
        if name == whitelistedName then
            return true
        end
    end
    return false
end
 
if not isWhitelisted(player.Name) then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Access Denied";
        Text = "You are not whitelisted Dumbass!";
        Duration = 5;
    })
    script.Parent:Destroy() -- 
    return
end
 
print("Access granted to " .. player.Name)





local Players = game:GetService("Players")
local player = Players.LocalPlayer 

-- Whitelisted UserIds only works for this  type of users
local whitelist = {
    [1497286101] = true,
    [4441876607] = true,
   
}

-- Check if player is whitelisted
local function isWhitelisted(userId)
    return whitelist[userId] == true
end

-- If not whitelisted, your access has been denied
if not isWhitelisted(player.UserId) then
    return

-- this script is automated by my bot
end

-- For whitelisted users only
print("Access granted. To" .. player.Name)








local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Replace with your actual GitHub raw URL
local url = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"

local function isWhitelisted(userId, whitelist)
	for _, id in ipairs(whitelist) do
		if id == userId then
			return true
		end
	end
	return false
end

local success, result = pcall(function()
	local response = game:HttpGet(url, true)
	return HttpService:JSONDecode(response)
end)

if success and result then
	local enabled = result.enabled
	local whitelist = result.whitelist or {}

	if not enabled and not isWhitelisted(player.UserId, whitelist) then
		player:Kick("Your Account Is Terminated.")
		return
	else
		print("Kill switch OFF or user whitelisted. Continuing...")
	end
else
	warn("Failed to fetch kill switch status. Script may proceed anyway.")
end


local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer


local url = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"

local banlistUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"

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

local banSuccess, banData = pcall(function()
	local response = game:HttpGet(banlistUrl, true)
	return HttpService:JSONDecode(response)
end)

if banSuccess and banData then
	local banlist = banData.banned or {}
	if isBanned(player.UserId, banlist) then
		player:Kick("🚫 You are permanently banned from using this script.")
		return
	end
else
	warn("⚠️ Could not fetch banlist.")
end

local success, result = pcall(function()
	local response = game:HttpGet(url, true)
	return HttpService:JSONDecode(response)
end)

if success and result then
	local enabled = result.enabled
	local whitelist = result.whitelist or {}

	if not enabled and not isWhitelisted(player.UserId, whitelist) then
		player:Kick("Your UserID IS Not Whitelisted.")
		return
	else
		print("✅ Kill switch OFF or user whitelisted. Continuing...")
	end
else
	warn("⚠️ Failed to fetch kill switch status. Script may proceed anyway.")
end

task.wait(2) -- Slight delay to allow other parts of script to load (optional)

-- SECONDARY KILL SWITCH CHECK
 if not enabled then
	local stillAuthorized = false
	local retrySuccess, retryResult = pcall(function()
		local response = game:HttpGet(url, true)
		return HttpService:JSONDecode(response)
	end)

	if retrySuccess and retryResult then
		local whitelist = retryResult.whitelist or {}
		if isWhitelisted(player.UserId, whitelist) then
			stillAuthorized = true
		end
	end

	if not stillAuthorized then
		player:Kick("⚠️ Unauthorized user detected.")
		return
	end
end



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

