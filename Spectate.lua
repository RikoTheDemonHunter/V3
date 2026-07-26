pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    getgenv().AverySelectedPack = getgenv().AverySelectedPack or nil

    -- Clean up previous UI instance
    local cloneref = cloneref or function(o) return o end
    local CoreGui = cloneref(game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")
    local oldGui = CoreGui:FindFirstChild("AveryHubGui")
    if oldGui then oldGui:Destroy() end

    -- R15 Check
    local function checkR15(char)
        local humanoid = char:WaitForChild("Humanoid", 5)
        if humanoid and humanoid.RigType ~= Enum.HumanoidRigType.R15 then 
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Rig Error",
                Text = "R15 Rig required for Animation Swapper!",
                Duration = 5
            })
            return false
        end
        return true
    end

    if LocalPlayer.Character and not checkR15(LocalPlayer.Character) then return end

    -- RAW ANIMATION DATA (USING VERIFIED DIRECT ASSET IDS)
    local AnimationPacks = {
        ["Toy"] = {
            idle1 = "rbxassetid://782841498",
            idle2 = "rbxassetid://782845736",
            walk = "rbxassetid://782843345",
            run = "rbxassetid://782842708",
            jump = "rbxassetid://782841968",
            fall = "rbxassetid://782840523",
            climb = "rbxassetid://782843869"
        },
        ["Zombie"] = {
            idle1 = "rbxassetid://616158082",
            idle2 = "rbxassetid://616160842",
            walk = "rbxassetid://616168032",
            run = "rbxassetid://616163605",
            jump = "rbxassetid://616161984",
            fall = "rbxassetid://616157122",
            climb = "rbxassetid://616156119"
        },
        ["Vampire"] = {
            idle1 = "rbxassetid://1083445855",
            idle2 = "rbxassetid://1083450166",
            walk = "rbxassetid://1083452282",
            run = "rbxassetid://1083450849",
            jump = "rbxassetid://1083450423",
            fall = "rbxassetid://1083443587",
            climb = "rbxassetid://1083442129"
        },
        ["Adidas"] = {
            idle1 = "rbxassetid://18302035987",
            idle2 = "rbxassetid://18302035987",
            walk = "rbxassetid://18302047806",
            run = "rbxassetid://18302041221",
            jump = "rbxassetid://18302038753",
            fall = "rbxassetid://18302033621",
            climb = "rbxassetid://18538170170"
        }
    }

    local activeConnections = {}

    local function ApplyAnimationPack(char, packName)
        if not char or not packName or not AnimationPacks[packName] then return end
        local humanoid = char:WaitForChild("Humanoid", 5)
        local animateScript = char:WaitForChild("Animate", 5)
        if not humanoid or not animateScript then return end

        local pack = AnimationPacks[packName]

        -- Safely overwrite default IDs in the character Animate script
        local function setAnim(folderName, animName, id)
            local folder = animateScript:FindFirstChild(folderName)
            if folder then
                local anim = folder:FindFirstChild(animName) or folder:FindFirstChildOfClass("Animation")
                if anim then
                    anim.AnimationId = id
                end
            end
        end

        setAnim("idle", "Animation1", pack.idle1)
        setAnim("idle", "Animation2", pack.idle2)
        setAnim("walk", "WalkAnim", pack.walk)
        setAnim("run", "RunAnim", pack.run)
        setAnim("jump", "JumpAnim", pack.jump)
        setAnim("fall", "FallAnim", pack.fall)
        setAnim("climb", "ClimbAnim", pack.climb)

        -- Preload assets to avoid Sanitized ID download error blocks
        local ContentProvider = game:GetService("ContentProvider")
        task.spawn(function()
            for _, id in pairs(pack) do
                local tempAnim = Instance.new("Animation")
                tempAnim.AnimationId = id
                pcall(function() ContentProvider:PreloadAsync({tempAnim}) end)
            end
        end)

        -- Restart character Animate script
        animateScript.Disabled = true
        task.wait(0.05)
        animateScript.Disabled = false

        -- Force playing tracks to reload
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:Stop(0)
            end
        end
    end

    local function setupCharacter(char)
        if getgenv().AverySelectedPack and checkR15(char) then
            task.wait(0.3)
            ApplyAnimationPack(char, getgenv().AverySelectedPack)
        end
    end

    if LocalPlayer.Character then
        setupCharacter(LocalPlayer.Character)
    end

    LocalPlayer.CharacterAdded:Connect(setupCharacter)

    -- UI CONSTRUCTION
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "AveryHubGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = CoreGui

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Name = "AveryToggle"
    toggleBtn.Size = UDim2.new(0, 110, 0, 38)
    toggleBtn.Position = UDim2.new(0.02, 0, 0.15, 0)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    toggleBtn.Text = "AVERY HUB"
    toggleBtn.TextColor3 = Color3.fromRGB(0, 230, 255)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 13
    toggleBtn.Active = true
    toggleBtn.Draggable = true
    toggleBtn.Parent = screenGui

    local toggleCorner = Instance.new("UICorner", toggleBtn)
    toggleCorner.CornerRadius = UDim.new(0, 8)

    local toggleStroke = Instance.new("UIStroke", toggleBtn)
    toggleStroke.Color = Color3.fromRGB(0, 180, 220)
    toggleStroke.Thickness = 1.5

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0.85, 0, 0.65, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui

    local aspectConstraint = Instance.new("UIAspectRatioConstraint", mainFrame)
    aspectConstraint.AspectRatio = 1.3
    aspectConstraint.AspectType = Enum.AspectType.FitWithinMaxSize

    local frameCorner = Instance.new("UICorner", mainFrame)
    frameCorner.CornerRadius = UDim.new(0, 12)

    local frameStroke = Instance.new("UIStroke", mainFrame)
    frameStroke.Color = Color3.fromRGB(45, 45, 55)
    frameStroke.Thickness = 1.5

    local header = Instance.new("Frame", mainFrame)
    header.Size = UDim2.new(1, 0, 0.15, 0)
    header.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    header.BorderSizePixel = 0

    local titleLabel = Instance.new("TextLabel", header)
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0.04, 0, 0, 0)
    titleLabel.Text = "AVERY ANIMATION HUB"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextScaled = true
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.BackgroundTransparency = 1

    local closeBtn = Instance.new("TextButton", header)
    closeBtn.Size = UDim2.new(0.12, 0, 0.6, 0)
    closeBtn.Position = UDim2.new(0.85, 0, 0.2, 0)
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextScaled = true
    closeBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
    closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    closeBtn.BorderSizePixel = 0

    local closeCorner = Instance.new("UICorner", closeBtn)
    closeCorner.CornerRadius = UDim.new(0, 6)

    local isOpen = true
    local function setMenuVisible(state)
        isOpen = state
        if state then
            mainFrame.Visible = true
            mainFrame:TweenSize(UDim2.new(0.85, 0, 0.65, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.25, true)
        else
            mainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.2, true, function()
                mainFrame.Visible = false
            end)
        end
    end

    closeBtn.MouseButton1Click:Connect(function() setMenuVisible(false) end)
    toggleBtn.MouseButton1Click:Connect(function() setMenuVisible(not isOpen) end)

    local searchBar = Instance.new("TextBox", mainFrame)
    searchBar.PlaceholderText = "🔍 Search packs..."
    searchBar.Font = Enum.Font.Gotham
    searchBar.TextScaled = true
    searchBar.TextColor3 = Color3.fromRGB(240, 240, 240)
    searchBar.PlaceholderColor3 = Color3.fromRGB(130, 130, 140)
    searchBar.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    searchBar.BorderSizePixel = 0
    searchBar.Size = UDim2.new(0.92, 0, 0.11, 0)
    searchBar.Position = UDim2.new(0.04, 0, 0.18, 0)

    local searchCorner = Instance.new("UICorner", searchBar)
    searchCorner.CornerRadius = UDim.new(0, 6)

    local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
    scrollFrame.Size = UDim2.new(0.92, 0, 0.65, 0)
    scrollFrame.Position = UDim2.new(0.04, 0, 0.31, 0)
    scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 180, 220)
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

    local scrollLayout = Instance.new("UIListLayout", scrollFrame)
    scrollLayout.SortOrder = Enum.SortOrder.Name
    scrollLayout.Padding = UDim.new(0, 6)

    local function updateCanvas()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 10)
    end
    scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    local buttons = {}
    for packName, _ in pairs(AnimationPacks) do
        local btn = Instance.new("TextButton")
        btn.Name = packName
        btn.Text = packName .. " Pack"
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.TextColor3 = Color3.fromRGB(220, 220, 225)
        btn.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
        btn.Size = UDim2.new(0.98, 0, 0, 36)
        btn.BorderSizePixel = 0
        btn.Parent = scrollFrame

        local btnCorner = Instance.new("UICorner", btn)
        btnCorner.CornerRadius = UDim.new(0, 6)

        if getgenv().AverySelectedPack == packName then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 190)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        btn.MouseButton1Click:Connect(function()
            getgenv().AverySelectedPack = packName
            ApplyAnimationPack(LocalPlayer.Character, packName)

            for _, b in ipairs(buttons) do
                b.BackgroundColor3 = Color3.fromRGB(32, 32, 40)
                b.TextColor3 = Color3.fromRGB(220, 220, 225)
            end
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 190)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        table.insert(buttons, btn)
    end

    task.defer(updateCanvas)

    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local filter = searchBar.Text:lower()
        for _, btn in ipairs(buttons) do
            btn.Visible = (filter == "" or btn.Name:lower():find(filter, 1, true) ~= nil)
        end
    end)
end)
