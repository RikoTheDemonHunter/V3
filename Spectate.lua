pcall(function()
    local Players = game:GetService("Players")
    local ContentProvider = game:GetService("ContentProvider")
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

    -- ANIMATIONS DICTIONARY (Sanitized Public Asset IDs)
    local OriginalAnimations = {
        ["Idle"] = {
            ["2016 Animation (mm2)"] = {"387947158", "387947464"},
            ["Astronaut"] = {"891621366", "891633237"},
            ["Bold"] = {"16738333868", "16738334710"},
            ["Borock"] = {"3293641938", "3293642554"},
            ["Bubbly"] = {"910004836", "910009958"},
            ["Cartoony"] = {"742637544", "742638445"},
            ["Confident"] = {"1069977950", "1069987858"},
            ["Cowboy"] = {"1014390418", "1014398616"},
            ["Elder"] = {"10921101664", "10921102574"},
            ["Knight"] = {"657595757", "657568135"},
            ["Levitation"] = {"616006778", "616008087"},
            ["Mage"] = {"707742142", "707855907"},
            ["Ninja"] = {"656117400", "656118341"},
            ["OldSchool"] = {"10921230744", "10921232093"},
            ["Pirate"] = {"750781874", "750782770"},
            ["Robot"] = {"616088211", "616089559"},
            ["Sneaky"] = {"1132473842", "1132477671"},
            ["Stylish"] = {"616136790", "616138447"},
            ["Superhero"] = {"10921288909", "10921290167"},
            ["Toy"] = {"782841498", "782845736"},
            ["Vampire"] = {"1083445855", "1083450166"},
            ["Werewolf"] = {"1083195517", "1083214717"},
            ["Zombie"] = {"616158929", "616160636"}
        },
        ["Walk"] = {
            ["Patrol"] = "1151231493",
            ["Levitation"] = "616013216",
            ["Knight"] = "10921127095",
            ["Pirate"] = "750785693",
            ["Bold"] = "16738340646",
            ["Zombie"] = "616168032",
            ["Astronaut"] = "891667138",
            ["Cartoony"] = "742640026",
            ["Ninja"] = "656121766",
            ["Confident"] = "1070017263",
            ["Vampire"] = "1083473930",
            ["Mage"] = "707897309",
            ["Bubbly"] = "910034870",
            ["OldSchool"] = "10921244891",
            ["Elder"] = "10921111375",
            ["Stylish"] = "616146177",
            ["Robot"] = "616095330",
            ["Sneaky"] = "1132510133",
            ["Superhero"] = "10921298616",
            ["Toy"] = "782843345",
            ["Cowboy"] = "1014421541"
        },
        ["Run"] = {
            ["Robot"] = "10921250460",
            ["Patrol"] = "1150967949",
            ["Knight"] = "10921121197",
            ["Pirate"] = "750783738",
            ["Bold"] = "16738337225",
            ["Zombie"] = "616163682",
            ["Astronaut"] = "10921039308",
            ["Cartoony"] = "10921076136",
            ["Ninja"] = "656118852",
            ["Sneaky"] = "1132494274",
            ["Mage"] = "10921148209",
            ["Confident"] = "1070001516",
            ["Elder"] = "10921104374",
            ["Werewolf"] = "10921336997",
            ["Stylish"] = "10921276116",
            ["Levitation"] = "616010382",
            ["OldSchool"] = "10921240218",
            ["Vampire"] = "10921320299",
            ["Bubbly"] = "10921057244",
            ["Superhero"] = "10921291831",
            ["Toy"] = "10921306285",
            ["Cowboy"] = "1014401683"
        },
        ["Jump"] = {
            ["Robot"] = "616090535",
            ["Patrol"] = "1148811837",
            ["Levitation"] = "616008936",
            ["Knight"] = "910016857",
            ["Pirate"] = "750782230",
            ["Bold"] = "16738336650",
            ["Zombie"] = "616161997",
            ["Astronaut"] = "891627522",
            ["Cartoony"] = "742637942",
            ["Ninja"] = "656117878",
            ["Confident"] = "1069984524",
            ["Sneaky"] = "1132489853",
            ["Superhero"] = "10921294559",
            ["Elder"] = "10921107367",
            ["OldSchool"] = "10921242013",
            ["Stylish"] = "616139451",
            ["Bubbly"] = "910016857",
            ["Vampire"] = "1083455352",
            ["Toy"] = "10921308158",
            ["Cowboy"] = "1014394726"
        },
        ["Fall"] = {
            ["Robot"] = "616087089",
            ["Patrol"] = "1148863382",
            ["Levitation"] = "616005863",
            ["Knight"] = "10921122579",
            ["Pirate"] = "750780242",
            ["Bold"] = "16738333171",
            ["Zombie"] = "616157476",
            ["Astronaut"] = "891617961",
            ["Cartoony"] = "742637151",
            ["Ninja"] = "656115606",
            ["Confident"] = "1069973677",
            ["Mage"] = "707829716",
            ["OldSchool"] = "10921241244",
            ["Sneaky"] = "1132469004",
            ["Elder"] = "10921105765",
            ["Bubbly"] = "910001910",
            ["Stylish"] = "616134815",
            ["Vampire"] = "1083443587",
            ["Superhero"] = "10921293373",
            ["Toy"] = "782846423",
            ["Cowboy"] = "1014384571"
        },
        ["Climb"] = {
            ["Robot"] = "616086039",
            ["Patrol"] = "1148811837",
            ["Levitation"] = "10921132092",
            ["Knight"] = "10921125160",
            ["Bold"] = "16738332169",
            ["Zombie"] = "616156119",
            ["Astronaut"] = "10921032124",
            ["Cartoony"] = "742636889",
            ["Ninja"] = "656114359",
            ["Confident"] = "1069946257",
            ["Mage"] = "707826056",
            ["OldSchool"] = "10921229866",
            ["Sneaky"] = "1132461372",
            ["Elder"] = "845392038",
            ["Stylish"] = "10921271391",
            ["Superhero"] = "10921286911",
            ["Werewolf"] = "10921329322",
            ["Vampire"] = "1083439238",
            ["Toy"] = "10921300839"
        }
    }

    local function FormatAssetId(id)
        if not id or id == "0" or id == "" then return "" end
        return id:find("rbxassetid://") and id or ("rbxassetid://" .. id)
    end

    local function ApplyAnimationPack(char, packName)
        if not char or not packName then return end
        local humanoid = char:WaitForChild("Humanoid", 5)
        local animateScript = char:WaitForChild("Animate", 5)
        if not humanoid or not animateScript then return end

        local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

        -- Force-stop all running animations to prevent overlaps
        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            track:Stop(0)
        end

        local function getPackAsset(category, name)
            if OriginalAnimations[category] and OriginalAnimations[category][name] then
                return OriginalAnimations[category][name]
            end
            return nil
        end

        local idleAsset = getPackAsset("Idle", packName)
        local walkAsset = getPackAsset("Walk", packName)
        local runAsset = getPackAsset("Run", packName)
        local jumpAsset = getPackAsset("Jump", packName)
        local fallAsset = getPackAsset("Fall", packName)
        local climbAsset = getPackAsset("Climb", packName)

        local function setAnim(folderName, animName, rawId)
            if not rawId then return end
            local folder = animateScript:FindFirstChild(folderName)
            if folder then
                local anim = folder:FindFirstChild(animName) or folder:FindFirstChildOfClass("Animation")
                if anim then
                    anim.AnimationId = FormatAssetId(rawId)
                end
            end
        end

        if idleAsset then
            if type(idleAsset) == "table" then
                setAnim("idle", "Animation1", idleAsset[1])
                setAnim("idle", "Animation2", idleAsset[2] or idleAsset[1])
            else
                setAnim("idle", "Animation1", idleAsset)
            end
        end

        if walkAsset then setAnim("walk", "WalkAnim", walkAsset) end
        if runAsset then setAnim("run", "RunAnim", runAsset) end
        if jumpAsset then setAnim("jump", "JumpAnim", jumpAsset) end
        if fallAsset then setAnim("fall", "FallAnim", fallAsset) end
        if climbAsset then setAnim("climb", "ClimbAnim", climbAsset) end

        -- Preload assets silently
        task.spawn(function()
            local toPreload = {}
            for _, category in pairs({"Idle", "Walk", "Run", "Jump", "Fall", "Climb"}) do
                local asset = getPackAsset(category, packName)
                if type(asset) == "table" then
                    for _, id in ipairs(asset) do
                        local a = Instance.new("Animation")
                        a.AnimationId = FormatAssetId(id)
                        table.insert(toPreload, a)
                    end
                elseif asset then
                    local a = Instance.new("Animation")
                    a.AnimationId = FormatAssetId(asset)
                    table.insert(toPreload, a)
                end
            end
            pcall(function() ContentProvider:PreloadAsync(toPreload) end)
        end)

        -- Refresh state cleanly
        animateScript.Disabled = true
        task.wait(0.1)
        animateScript.Disabled = false

        -- Force character state update so current pose changes immediately
        humanoid:ChangeState(Enum.HumanoidStateType.Landed)
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

    -- UI CREATION
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
    searchBar.PlaceholderText = "🔍 Search animation packs..."
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

    local scrollLayout = Instance.new("UIListLayout", scrollFrame)
    scrollLayout.SortOrder = Enum.SortOrder.Name
    scrollLayout.Padding = UDim.new(0, 6)

    local function updateCanvas()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 10)
    end
    scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    local packNamesList = {}
    local addedPacks = {}

    for _, category in pairs(OriginalAnimations) do
        for packName, _ in pairs(category) do
            if not addedPacks[packName] then
                addedPacks[packName] = true
                table.insert(packNamesList, packName)
            end
        end
    end

    table.sort(packNamesList)

    local buttons = {}
    for _, packName in ipairs(packNamesList) do
        local btn = Instance.new("TextButton")
        btn.Name = packName
        btn.Text = packName
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 13
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
