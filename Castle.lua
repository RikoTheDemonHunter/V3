-- SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- THEME
local Theme = {
    Background = Color3.fromRGB(20,20,30),
    Accent = Color3.fromRGB(0,170,255),
    Success = Color3.fromRGB(0,220,100),
    Warning = Color3.fromRGB(255,180,0),
    Error = Color3.fromRGB(255,80,80),
    Text = Color3.fromRGB(255,255,255)
}

-- URLs (JSON)
local url = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/switcher.json"
local banlistUrl = "https://raw.githubusercontent.com/RikoTheDemonHunter/V3/refs/heads/main/Banlist.json"

-- UTILITIES
local function fetchJSON(targetUrl)
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(targetUrl,true))
    end)
    if success then return result end
    return nil
end

local function isBanned(userId, banlist)
    for _, id in ipairs(banlist or {}) do
        if id == userId then return true end
    end
    return false
end

local function isWhitelisted(userId, whitelist)
    for _, id in ipairs(whitelist or {}) do
        if id == userId then return true end
    end
    return false
end

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "ModernKillSwitch"
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0.45,0,0.55,0)
frame.Position = UDim2.new(0.5,0,0.5,0)
frame.AnchorPoint = Vector2.new(0.5,0.5)
frame.BackgroundColor3 = Theme.Background
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,20)
corner.Parent = frame

local uiScale = Instance.new("UIScale")
uiScale.Parent = frame
uiScale.Scale = UserInputService.TouchEnabled and 1.3 or 1

-- STATUS LABEL
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1,-20,0,40)
statusLabel.Position = UDim2.new(0,10,0,10)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 22
statusLabel.TextColor3 = Theme.Text
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.TextYAlignment = Enum.TextYAlignment.Top
statusLabel.Text = "✨ Initializing..."
statusLabel.Parent = frame

-- UIStroke for accent
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Theme.Accent
stroke.Transparency = 0.5
stroke.Parent = statusLabel

-- SCROLL FRAME
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1,-20,0.6,0)
scrollFrame.Position = UDim2.new(0,10,0,60)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.Parent = frame

local uiList = Instance.new("UIListLayout")
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0,4)
uiList.Parent = scrollFrame

-- FADE TEXT FUNCTION
local function fadeText(text, color, duration)
    local fadeOut = TweenService:Create(statusLabel, TweenInfo.new(0.4), {TextTransparency = 1})
    fadeOut:Play()
    fadeOut.Completed:Wait()
    statusLabel.Text = text
    statusLabel.TextColor3 = color or Theme.Text
    local fadeIn = TweenService:Create(statusLabel, TweenInfo.new(0.4), {TextTransparency = 0})
    fadeIn:Play()
    task.wait(duration or 1.5)
end

-- SECURE DATA FETCH
local function secureFetch()
    fadeText("🔍 Fetching Banlist...", Theme.Warning)
    local banData = fetchJSON(banlistUrl) or {}
    local bans = banData.banned or {}

    fadeText("🛡️ Fetching Kill Switch...", Theme.Warning)
    local switchData = fetchJSON(url) or {}
    local enabled = switchData.enabled
    local whitelist = switchData.whitelist or {}

    return bans, whitelist, enabled
end

-- VERIFY PLAYER
local function verifyPlayer()
    local bans, whitelist, enabled = secureFetch()
    if isBanned(LocalPlayer.UserId, bans) then
        fadeText("🚫 You are BANNED!", Theme.Error)
        task.wait(1.5)
        LocalPlayer:Kick("🚫 You are banned from using this script.")
    elseif not enabled and not isWhitelisted(LocalPlayer.UserId, whitelist) then
        fadeText("❌ Kill Switch ACTIVE, You are NOT whitelisted!", Theme.Error)
        task.wait(1.5)
        LocalPlayer:Kick("❌ Kill switch active, not whitelisted.")
    else
        fadeText("✅ You are authorized!", Theme.Success)
    end

    -- DISPLAY WHITELIST & BANS
    scrollFrame:ClearAllChildren()
    for _, id in ipairs(whitelist) do
        local name = "Unknown"
        pcall(function() name = Players:GetNameFromUserIdAsync(id) end)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,-10,0,24)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.Gotham
        lbl.TextSize = 16
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextColor3 = (id==LocalPlayer.UserId) and Theme.Accent or Theme.Success
        lbl.Text = (id==LocalPlayer.UserId) and ("⭐ %s (YOU)"):format(name) or ("✅ %s"):format(name)
        lbl.Parent = scrollFrame
    end
    for _, id in ipairs(bans) do
        if not isWhitelisted(id, whitelist) then
            local name = "Unknown"
            pcall(function() name = Players:GetNameFromUserIdAsync(id) end)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1,-10,0,24)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 16
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextColor3 = Theme.Error
            lbl.Text = ("🚫 %s"):format(name)
            lbl.Parent = scrollFrame
        end
    end
    scrollFrame.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y+10)
end

-- RUN VERIFICATION
task.spawn(verifyPlayer)

-- CLOSING ANIMATION
task.delay(5, function()
    local shrink = TweenService:Create(uiScale, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale=0})
    local fadeOutGui = TweenService:Create(frame, TweenInfo.new(0.6), {BackgroundTransparency=1})
    shrink:Play()
    fadeOutGui:Play()
    task.wait(0.7)
    gui:Destroy()
end)
--[[
Granny on top
Always bringing high quality scripts
--]]
getgenv().lib = "Granny_Main_UI"
loadstring(game:HttpGet("https://sonic998.github.io/Shadow-Scripts/script.luau"))() 
