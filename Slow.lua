-- Modern Responsive Animation Modifier (R15 Required)
-- Completely refactored UI, modernized layouts, and absolute fix for character respawn freezes.

pcall(function()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Ensure user is running R15 Rig configuration
    local function checkRig()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid", 5)
        if hum and hum.RigType ~= Enum.HumanoidRigType.R15 then 
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Rig Error", 
                Text = "You are on R6. Please swap to R15 to execute Gaze UI!", 
                Duration = 10
            })
            return false
        end
        return true
    end

    if not checkRig() then return end

    local TweenService = game:GetService("TweenService")
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    local CoreGui = game:GetService("CoreGui")

    local cloneref = cloneref or function(o) return o end
    local TargetGui = cloneref(CoreGui) or LocalPlayer:WaitForChild("PlayerGui")

    -- Anti-duplicate execution gate
    if TargetGui:FindFirstChild("GazeVerificator") or TargetGui:FindFirstChild("DraggableGui") then
        return
    end

    local trackerTag = Instance.new("Folder")
    trackerTag.Name = "GazeVerificator"
    trackerTag.Parent = TargetGui

    ---------------------------------------------------------------------------
    -- Notification Manager (Modern Sleek Layout)
    ---------------------------------------------------------------------------
    local activeNotifications = {}
    
    local function Notify(titleText, msgText, duration)
        coroutine.wrap(function()
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "GazeNotification"
            screenGui.Parent = TargetGui

            local mainFrame = Instance.new("Frame")
            mainFrame.Size = UDim2.new(0, 260, 0, 75)
            mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            mainFrame.BackgroundTransparency = 0.1
            mainFrame.BorderSizePixel = 0
            mainFrame.Parent = screenGui

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 8)
            corner.Parent = mainFrame

            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(60, 60, 60)
            stroke.Thickness = 1
            stroke.Parent = mainFrame

            local titleLabel = Instance.new("TextLabel")
            titleLabel.Size = UDim2.new(1, -20, 0, 25)
            titleLabel.Position = UDim2.new(0, 10, 0, 8)
            titleLabel.Font = Enum.Font.GothamBold
            titleLabel.Text = titleText
            titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLabel.TextSize = 14
            titleLabel.TextXAlignment = Enum.TextXAlignment.Left
            titleLabel.BackgroundTransparency = 1
            titleLabel.Parent = mainFrame

            local messageLabel = Instance.new("TextLabel")
            messageLabel.Size = UDim2.new(1, -20, 0, 35)
            messageLabel.Position = UDim2.new(0, 10, 0, 30)
            messageLabel.Font = Enum.Font.Gotham
            messageLabel.Text = msgText
            messageLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            messageLabel.TextSize = 12
            messageLabel.TextWrapped = true
            messageLabel.TextXAlignment = Enum.TextXAlignment.Left
            messageLabel.TextYAlignment = Enum.TextYAlignment.Top
            messageLabel.BackgroundTransparency = 1
            messageLabel.Parent = mainFrame

            local function updatePositions()
                for idx, frame in ipairs(activeNotifications) do
                    local targetY = 40 + (idx - 1) * 85
                    TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(1, -280, 0, targetY)}):Play()
                end
            end

            mainFrame.Position = UDim2.new(1, 10, 0, 40 + (#activeNotifications * 85))
            table.insert(activeNotifications, mainFrame)
            updatePositions()

            task.wait(0.1)
            TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, -280, 0, mainFrame.Position.Y.Offset)}):Play()

            task.wait(duration or 3)

            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, 10, 0, mainFrame.Position.Y.Offset), BackgroundTransparency = 1}):Play()
            task.wait(0.3)
            
            for idx, frame in ipairs(activeNotifications) do
                if frame == mainFrame then
                    table.remove(activeNotifications, idx)
                    break
                end
            end
            updatePositions()
            screenGui:Destroy()
        end)()
    end

    ---------------------------------------------------------------------------
    -- Core System / Animation Data Mapping
    ---------------------------------------------------------------------------
    local OriginalAnimations = {
        ["Idle"] = {
            ["2016 Animation (mm2)"] = {"387947158", "387947464"},
            ["Astronaut"] = {"891621366", "891633237"},
            ["Bubbly"] = {"910004836", "910009958"},
            ["Cartoony"] = {"742637544", "742638445"},
            ["Ninja"] = {"656117400", "656118341"},
            ["OldSchool"] = {"10921230744", "10921232093"},
            ["Vampire"] = {"1083445855", "1083450166"},
            ["Zombie"] = {"616158929", "616160636"}
        },
        ["Walk"] = {
            ["Patrol"] = "1151231493",
            ["Zombie"] = "616168032",
            ["Cartoony"] = "742640026",
            ["Ninja"] = "656121766",
            ["OldSchool"] = "10921244891"
        },
        ["Run"] = {
            ["Robot"] = "10921250460",
            ["Zombie"] = "616163682",
            ["Cartoony"] = "10921076136",
            ["Ninja"] = "656118852"
        },
        ["Jump"] = {
            ["Robot"] = "616090535",
            ["Cartoony"] = "742637942",
            ["Ninja"] = "656117878"
        },
        ["Fall"] = {
            ["Robot"] = "616087089",
            ["Cartoony"] = "742637151",
            ["Ninja"] = "656115606"
        },
        ["SwimIdle"] = {["Levitation"] = "10921139478"},
        ["Swim"] = {["Levitation"] = "10921138209"},
        ["Climb"] = {["Ninja"] = "656114359"}
    }

    local Animations = OriginalAnimations
    if isfile and readfile and isfile("GreyLikesToSmellUrFeet.json") then
        pcall(function()
            Animations = HttpService:JSONDecode(readfile("GreyLikesToSmellUrFeet.json"))
        end)
    elseif writefile then
        writefile("GreyLikesToSmellUrFeet.json", HttpService:JSONEncode(OriginalAnimations))
    end

    ---------------------------------------------------------------------------
    -- Modern UI Initialization
    ---------------------------------------------------------------------------
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DraggableGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = TargetGui

    local mainUI = Instance.new("Frame")
    mainUI.Name = "GazeMainUI"
    mainUI.Size = UDim2.new(0, 360, 0, 420)
    mainUI.Position = UDim2.new(0.5, -180, 0.5, -210)
    mainUI.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainUI.BorderSizePixel = 0
    mainUI.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = mainUI

    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(55, 55, 55)
    uiStroke.Thickness = 1.5
    uiStroke.Parent = mainUI

    local dragging, dragInput, dragStart, startPos
    mainUI.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainUI.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    mainUI.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local headerTitle = Instance.new("TextLabel")
    headerTitle.Size = UDim2.new(1, 0, 0, 40)
    headerTitle.Font = Enum.Font.GothamBold
    headerTitle.Text = "GAZE ANIMATOR"
    headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    headerTitle.TextSize = 16
    headerTitle.BackgroundTransparency = 1
    headerTitle.Parent = mainUI

    local searchBar = Instance.new("TextBox")
    searchBar.Size = UDim2.new(0.9, 0, 0, 35)
    searchBar.Position = UDim2.new(0.05, 0, 0, 45)
    searchBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    searchBar.Font = Enum.Font.Gotham
    searchBar.PlaceholderText = "Search active track animations..."
    searchBar.Text = ""
    searchBar.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBar.PlaceholderColor3 = Color3.fromRGB(130, 130, 130)
    searchBar.TextSize = 13
    searchBar.Parent = mainUI

    local sbCorner = Instance.new("UICorner")
    sbCorner.CornerRadius = UDim.new(0, 6)
    sbCorner.Parent = searchBar

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(0.9, 0, 0, 310)
    scrollFrame.Position = UDim2.new(0.05, 0, 0, 95)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 3
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    scrollFrame.Parent = mainUI

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Padding = UDim.new(0, 6)
    uiListLayout.Parent = scrollFrame

    ---------------------------------------------------------------------------
    -- Dynamic Character Custom Runtime Swapper & Persistent State Fix
    ---------------------------------------------------------------------------
    local cachedAnimationPreferences = {}

    local function applyCustomAnimationValue(animType, idTable)
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local animateScript = char:WaitForChild("Animate", 5)
        if not animateScript then return end

        local targetNode = animateScript:FindFirstChild(animType:lower())
        if targetNode then
            targetNode:ClearAllChildren()
            if typeof(idTable) == "table" then
                for i, id in ipairs(idTable) do
                    local animObj = Instance.new("Animation")
                    animObj.Name = animType:lower() .. i
                    animObj.AnimationId = "rbxassetid://" .. id
                    animObj.Parent = targetNode
                end
            else
                local animObj = Instance.new("Animation")
                animObj.Name = animType:lower() .. "1"
                animObj.AnimationId = "rbxassetid://" .. id
                animObj.Parent = targetNode
            end
        end
    end

    -- Flawless Reload on Respawn via Toggle Restart
    local function monitorCharacterState(character)
        if not character then return end
        local humanoid = character:WaitForChild("Humanoid", 10)
        local animateScript = character:WaitForChild("Animate", 10)
        if not humanoid or not animateScript then return end

        -- Stop current tracks before modification
        local animTracks = humanoid:GetPlayingAnimationTracks()
        for _, track in ipairs(animTracks) do
            track:Stop()
        end

        -- Re-apply all cached choices instantly
        for category, identity in pairs(cachedAnimationPreferences) do
            applyCustomAnimationValue(category, identity)
        end

        -- Cycle the Animate script to force Roblox to rebuild tracks with new IDs
        animateScript.Enabled = false
        task.wait(0.1)
        animateScript.Enabled = true
    end

    LocalPlayer.CharacterAdded:Connect(monitorCharacterState)
    if LocalPlayer.Character then task.spawn(monitorCharacterState, LocalPlayer.Character) end

    ---------------------------------------------------------------------------
    -- Render & Control Interfaces
    ---------------------------------------------------------------------------
    local itemButtons = {}
    
    local function updateScrollList()
        for _, btn in ipairs(itemButtons) do btn:Destroy() end
        table.clear(itemButtons)

        for category, list in pairs(Animations) do
            for name, ids in pairs(list) do
                local displayTitle = name .. " (" .. category .. ")"
                
                local elementButton = Instance.new("TextButton")
                elementButton.Size = UDim2.new(1, 0, 0, 38)
                elementButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                elementButton.Font = Enum.Font.GothamMedium
                elementButton.Text = "   " .. displayTitle
                elementButton.TextColor3 = Color3.fromRGB(230, 230, 230)
                elementButton.TextSize = 13
                elementButton.TextXAlignment = Enum.TextXAlignment.Left
                elementButton.Parent = scrollFrame

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = elementButton

                elementButton.MouseButton1Click:Connect(function()
                    -- Instantly cache preferences globally so it saves on reset
                    cachedAnimationPreferences[category] = ids
                    
                    applyCustomAnimationValue(category, ids)
                    
                    -- Quick-cycle Animate script on instant select click
                    local char = LocalPlayer.Character
                    if char and char:FindFirstChild("Animate") then
                        char.Animate.Enabled = false
                        task.wait(0.05)
                        char.Animate.Enabled = true
                    end
                    
                    Notify("Synchronized", "Applied " .. name .. " config successfully!", 2.5)
                end)

                table.insert(itemButtons, elementButton)
            end
        end
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y)
    end

    searchBar:GetPropertyChangedSignal("Text"):Connect(function()
        local textFilter = searchBar.Text:lower()
        for _, btn in ipairs(itemButtons) do
            if textFilter == "" or btn.Text:lower():find(textFilter) then
                btn.Visible = true
            else
                btn.Visible = false
            end
        end
    end)

    updateScrollList()
    Notify("Gaze Engine Activated", "Modern Layout Loaded System Secure.", 3)
end)
