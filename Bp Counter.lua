-- Modernized Burp Anti-Counter Client Script
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
if not player then
	warn("Burp_AntiCounter: No LocalPlayer found.")
	return
end

-- Safely look for RemoteEvents folder
local remoteFolder = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
if not remoteFolder then
	warn("Burp_AntiCounter: RemoteEvents folder missing from ReplicatedStorage.")
	return
end

local BurpRequest = remoteFolder:WaitForChild("BurpEvent", 2)
local BurpAction = remoteFolder:WaitForChild("BurpAction", 2)

if not (BurpRequest and BurpAction) then
	warn("Burp_AntiCounter: Required RemoteEvents are missing.")
	return
end

-- Visual notification UI for when a counter triggers
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AntiCounterGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

local function showCounterNotification(attackerName)
	local notif = Instance.new("TextLabel")
	notif.Size = UDim2.new(0, 250, 0, 40)
	notif.Position = UDim2.new(0.5, -125, 0.1, -50)
	notif.BackgroundColor3 = Color3.fromRGB(20, 150, 80)
	notif.TextColor3 = Color3.fromRGB(255, 255, 255)
	notif.Text = "⚡ Countered: " .. attackerName .. "!"
	notif.Font = Enum.Font.GothamBold
	notif.TextSize = 14
	notif.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 6)
	corner.Parent = notif
	
	-- Slide down and fade out animation
	TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.QuadOut), {Position = UDim2.new(0.5, -125, 0.1, 0)}):Play()
	task.delay(1.5, function()
		local fade = TweenService:Create(notif, TweenInfo.new(0.5), {TextTransparency = 1, BackgroundTransparency = 1})
		fade:Play()
		fade.Completed:Connect(function() notif:Destroy() end)
	end)
end

-- Automatic Counter Logic
local COUNTER_COOLDOWN = 0.1 -- Ultra fast response time
local lastCounterTime = 0

BurpAction.OnClientEvent:Connect(function(payload)
	if type(payload) ~= "table" or payload.type ~= "burped" then return end
	
	-- If another player attacks us, grab their UserId
	local attackerId = payload.sourceUserId
	if not attackerId or attackerId == player.UserId then return end
	
	-- Anti-spam check
	local currentTime = os.clock()
	if currentTime - lastCounterTime < COUNTER_COOLDOWN then return end
	lastCounterTime = currentTime
	
	-- Automatically fire back immediately
	task.spawn(function()
		local ok, err = pcall(function()
			BurpRequest:FireServer(attackerId)
		end)
		
		if ok then
			-- Resolve username for the visual pop-up notification
			local attacker = Players:GetPlayerByUserId(attackerId)
			local attackerName = attacker and attacker.DisplayName or "Enemy"
			showCounterNotification(attackerName)
		else
			warn("Burp_AntiCounter: Remotes failed to fire back:", tostring(err))
		end
	end)
end)
