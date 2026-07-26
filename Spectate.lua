pcall(function()
    local Players = game:GetService("Players")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local LocalPlayer = Players.LocalPlayer

    -- Global state persistence across resets
    getgenv().AverySelectedPack = getgenv().AverySelectedPack or nil

    -- Check R15 Setup
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

    local cloneref = cloneref or function(o) return o end
    local CoreGui = cloneref(game:GetService("CoreGui")) or LocalPlayer:WaitForChild("PlayerGui")

    -- Clean up previous execution
    local oldGui = CoreGui:FindFirstChild("AveryHubGui")
    if oldGui then oldGui:Destroy() end

    -- OFFICIAL VERIFIED ROBLOX ANIMATION PACK DATABASE
    local OriginalAnimations = {
        Idle = {
            ["Default"] = {507766388, 507766666},
            ["Ninja"] = {656117400, 656118341},
            ["Toy"] = {782841498, 782845736},
            ["Vampire"] = {1083445855, 1083450166},
            ["Werewolf"] = {1083195517, 1083214717},
            ["Zombie"] = {616158082, 616160842},
            ["Mage"] = {707742142, 707855907},
            ["Pirate"] = {750781872, 750782770},
            ["Superhero"] = {616111295, 616113536},
            ["Knight"] = {657593035, 657593251},
            ["Levitation"] = {616006778, 616008087},
            ["Bubbly"] = {910004836, 910009958},
            ["Stylish"] = {616136790, 616138447},
            ["Robot"] = {616088211, 616089859},
            ["Astral"] = {891621366, 891633237},
            ["Oldschool"] = {531982821, 531983108},
            ["Cartoony"] = {742637544, 742638445},
            ["Elder"] = {845397899, 845400520},
            ["Rorro"] = {1092105732, 1092106234}
        },
        Walk = {
            ["Default"] = 913402848,
            ["Ninja"] = 656121766, ["Toy"] = 782843345, ["Vampire"] = 1083452282, ["Werewolf"] = 1083199849,
            ["Zombie"] = 616168032, ["Mage"] = 707897309, ["Pirate"] = 750785693, ["Superhero"] = 616122287,
            ["Knight"] = 657552124, ["Levitation"] = 616013216, ["Bubbly"] = 910025107, ["Stylish"] = 616146170,
            ["Robot"] = 616095330, ["Astral"] = 891662494, ["Oldschool"] = 531984711, ["Cartoony"] = 742640026,
            ["Elder"] = 845403244, ["Rorro"] = 1092107129
        },
        Run = {
            ["Default"] = 913376220,
            ["Ninja"] = 656118852, ["Toy"] = 782842708, ["Vampire"] = 1083450849, ["Werewolf"] = 1083196960,
            ["Zombie"] = 616163605, ["Mage"] = 707861613, ["Pirate"] = 750783738, ["Superhero"] = 616117088,
            ["Knight"] = 657564596, ["Levitation"] = 616008936, ["Bubbly"] = 910016857, ["Stylish"] = 616140816,
            ["Robot"] = 616091570, ["Astral"] = 891639832, ["Oldschool"] = 531984439, ["Cartoony"] = 742638842,
            ["Elder"] = 845401765, ["Rorro"] = 1092106432
        },
        Jump = {
            ["Default"] = 507765000,
            ["Ninja"] = 656117878, ["Toy"] = 782841968, ["Vampire"] = 1083450423, ["Werewolf"] = 1083196303,
            ["Zombie"] = 616161984, ["Mage"] = 707858694, ["Pirate"] = 750783008, ["Superhero"] = 616114845,
            ["Knight"] = 657593688, ["Levitation"] = 616008291, ["Bubbly"] = 910012220, ["Stylish"] = 616139451,
            ["Robot"] = 616090332, ["Astral"] = 891636393, ["Oldschool"] = 531983926, ["Cartoony"] = 742638590,
            ["Elder"] = 845400922, ["Rorro"] = 1092106300
        },
        Fall = {
            ["Default"] = 507767968,
            ["Ninja"] = 656115606, ["Toy"] = 782840523, ["Vampire"] = 1083443587, ["Werewolf"] = 1083193826,
            ["Zombie"] = 616157122, ["Mage"] = 707829716, ["Pirate"] = 750780242, ["Superhero"] = 616108112,
            ["Knight"] = 657560862, ["Levitation"] = 616005863, ["Bubbly"] = 910001910, ["Stylish"] = 616134815,
            ["Robot"] = 616086039, ["Astral"] = 891628189, ["Oldschool"] = 531982238, ["Cartoony"] = 742637151,
            ["Elder"] = 845396048, ["Rorro"] = 1092105310
        }
    }

    -- Robust Animation Injection Core
    local function ApplyAnimationPack(char, packName)
        if not char or not packName then return end
        local humanoid = char:WaitForChild("Humanoid", 5)
        local animateScript = char:WaitForChild("Animate", 5)
        if not humanoid or not animateScript then return end

        local animator = humanoid:FindFirstChildOfClass("Animator") or humanoid:WaitForChild("Animator", 3)

        local function modifyAnimFolder(folderName, animIdData)
            local folder = animateScript:FindFirstChild(folderName)
            if not folder then return end

            if type(animIdData) == "table" then
                local currentAnims = {}
                for _, child in ipairs(folder:GetChildren()) do
                    if child:IsA("Animation") then
                        table.insert(currentAnims, child)
                    end
                end

                for i, id in ipairs(animIdData) do
                    local animInst = currentAnims[i]
                    if not animInst then
                        animInst = Instance.new("Animation")
                        animInst.Name = folderName .. tostring(i)
                        animInst.Parent = folder
                    end
                    animInst.AnimationId = "http://www.roblox.com/asset/?id=" .. tostring(id)

                    local weight = animInst:FindFirstChild("Weight") or Instance.new("NumberValue")
                    weight.Name = "Weight"
                    weight.Value = (i == 1 and 9 or 1)
                    weight.Parent = animInst
                end
            else
                local animInst = folder:FindFirstChildOfClass("Animation")
                if not animInst then
                    animInst = Instance.new("Animation")
                    animInst.Name = folderName .. "1"
                    animInst.Parent = folder
                end
                animInst.AnimationId = "http://www.roblox.com/asset/?id=" .. tostring(animIdData)

                local weight = animInst:FindFirstChild("Weight") or Instance.new("NumberValue")
                weight.Name = "Weight"
                weight.Value = 10
                weight.Parent = animInst
            end
        end

        if animator then
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:Stop(0.1)
            end
        end

        modifyAnimFolder("idle", OriginalAnimations.Idle[packName])
        modifyAnimFolder("walk", OriginalAnimations.Walk[packName])
        modifyAnimFolder("run", OriginalAnimations.Run[packName])
        modifyAnimFolder("jump", OriginalAnimations.Jump[packName])
        modifyAnimFolder("fall", OriginalAnimations.Fall[packName])

        animateScript.Disabled = true
        task.wait(0.1)
        animateScript.Disabled = false

        task.defer(function()
            if humanoid and humanoid.Parent then
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                task.wait(0.05)
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end)
    end

    -- Respawn Handler: Persists selected pack across resets/deaths
    local function setupCharacter(char)
        if getgenv().AverySelectedPack and checkR15(char) then
            task.wait(0.7)
            ApplyAnimationPack(char, getgenv().AverySelectedPack)
        end
    end

    if LocalPlayer.Character then
        setupCharacter(LocalPlayer.Character)
    end

    LocalPlayer.CharacterAdded:Connect(setupCharacter)

    -- UI BUILD (MOBILE OPTIMIZED)
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

    scrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, scrollLayout.AbsoluteContentSize.Y + 10)
    end)

    local buttons = {}
    for packName, _ in pairs(OriginalAnimations["Idle"]) do
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

    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local filter = searchBar.Text:lower()
        for _, btn in ipairs(buttons) do
            btn.Visible = (filter == "" or btn.Name:lower():find(filter, 1, true) ~= nil)
        end
    end)
end)
