-- Rayfield Library Initialization
local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Game Hub",
    LoadingTitle = "Script Loaded",
    LoadingSubtitle = "Deobfuscated & Cleaned",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- Services
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- Configuration & State
local Toggles = {
    Zombies = false,
    Pumpkins = false,
    JerryCans = false,
    Cabins = false,
    ItemSpots = false,
    Shotgun = false,
    Mutant = false,
    Worker = false,
    Ghost = false,
    LiveAmmo = false,
    Names = false,
    Noclip = false,
    Godmode = false,
    InfiniteBattery = false,
    InfiniteStamina = false,
    Fullbright = false,
    CabinWarning = false
}

-- ESP Color Definitions
local Colors = {
    Zombies = Color3.fromRGB(255, 165, 0),
    Pumpkins = Color3.fromRGB(255, 140, 0),
    JerryCans = Color3.fromRGB(255, 0, 0),
    Cabins = Color3.fromRGB(139, 69, 19),
    ItemSpots = Color3.fromRGB(0, 200, 255),
    Marshmallow = Color3.fromRGB(150, 150, 150),
    Camera = Color3.fromRGB(0, 255, 0),
    Battery = Color3.fromRGB(150, 75, 0),
    Shotgun = Color3.fromRGB(150, 150, 150),
    Mutant = Color3.fromRGB(255, 0, 0),
    Worker = Color3.fromRGB(128, 0, 128),
    LiveAmmoLog = Color3.fromRGB(139, 69, 19),
    LiveAmmoShells = Color3.fromRGB(255, 255, 0),
    Ghost = Color3.fromRGB(255, 255, 255)
}

-- Target Body Parts Filtering
local MutantParts = {"LeftClaw1", "Head", "LeftClaw2", "LeftClaw3", "LeftClaw4", "LeftLowerArm", "LeftLowerLeg", "LeftTeeth", "LeftTorso", "LeftUpperArm", "LeftUpperLeg", "RightClaw1", "RightClaw2", "RightClaw3", "RightClaw4", "RightLowerArm", "RightLowerLeg", "RightTeeth", "RightTorso", "RightUpperArm", "RightUpperLeg", "Tongue"}
local WorkerParts = {"LowerLeg1", "LowerLeg3", "LowerLeg2", "L.InnerEye", "Head", "L.OuterEye", "LowerLeg4", "LowerLeg5", "LowerLeg6", "Pumpkin", "R.InnerEye", "R.OuterEye", "Teeth", "UpperLeg1", "UpperLeg2", "UpperLeg3", "UpperLeg4", "UpperLeg5", "UpperLeg6"}
local GhostParts = {"HeadMesh", "Helmet", "Head", "HumanoidRootPart", "Left Arm", "Left Leg", "Right Arm", "Right Leg", "Torso", "GhostChild"}

-- Active ESP Containers
local ActiveHighlights = {}
local ActiveNameTags = {}

-- Connections
local ESPConnection = nil
local NoclipConnection = nil
local GodmodeConnection = nil
local BatteryConnection = nil
local StaminaConnection = nil
local CabinWarningConnection = nil

-- Utility: Resolve instance path from workspace or ReplicatedStorage
local function ResolvePath(pathStr)
    local parts = pathStr:split(".")
    local current = Workspace
    
    if pathStr:find("ReplicatedStorage") == 1 then
        current = ReplicatedStorage
        if parts[1] == "ReplicatedStorage" then
            table.remove(parts, 1)
        end
    end

    if #parts > 0 and (parts[1] == "Mutant" or parts[1] == "WorkerHead" or parts[1] == "GhostChild") then
        local found = ReplicatedStorage:FindFirstChild(parts[1])
        if found then return found end
    end

    for _, name in ipairs(parts) do
        if not current then return nil end
        current = current:FindFirstChild(name)
    end
    return current
end

-- Utility: Manage Highlight ESP
local function SetHighlight(instance, enable, color, outlineOnly)
    local highlight = ActiveHighlights[instance]
    if enable then
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = instance.Name .. "_ESP"
            highlight.OutlineColor = color
            highlight.OutlineTransparency = 0
            highlight.FillColor = color
            highlight.FillTransparency = outlineOnly and 1 or 0.5
            highlight.Enabled = true
            highlight.Parent = instance
            ActiveHighlights[instance] = highlight
        else
            highlight.OutlineColor = color
            highlight.FillColor = color
            highlight.FillTransparency = outlineOnly and 1 or 0.5
            highlight.Enabled = true
        end
    elseif highlight then
        highlight:Destroy()
        ActiveHighlights[instance] = nil
    end
end

-- Utility: Manage NameTag ESP
local function SetNameTag(instance, enable, text, color)
    local nameTag = ActiveNameTags[instance]
    if enable and Toggles.Names then
        if not nameTag then
            nameTag = Instance.new("BillboardGui")
            nameTag.Name = instance.Name .. "_NameTag"
            nameTag.AlwaysOnTop = true
            nameTag.Size = UDim2.new(0, 80, 0, 12)
            nameTag.StudsOffset = Vector3.new(0, 1.2, 0)
            
            local label = Instance.new("TextLabel")
            label.Text = text
            label.TextScaled = true
            label.Font = Enum.Font.Code
            label.TextSize = 12
            label.TextColor3 = color
            label.BackgroundTransparency = 1
            label.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.Parent = nameTag
            
            nameTag.Parent = instance
            ActiveNameTags[instance] = nameTag
        end
    elseif nameTag then
        nameTag:Destroy()
        ActiveNameTags[instance] = nil
    end
end

-- Main ESP Update Cycle
local function UpdateESP()
    local isAnyESPActive = Toggles.Zombies or Toggles.Pumpkins or Toggles.JerryCans or Toggles.Mutant or Toggles.Worker or Toggles.Cabins or Toggles.ItemSpots or Toggles.Shotgun or Toggles.LiveAmmo or Toggles.Ghost
    if not isAnyESPActive then return end

    local currentTargets = {}

    -- Zombies
    if Toggles.Zombies then
        local container = ResolvePath("Zombies")
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("BasePart") or child:IsA("Model") then
                    SetHighlight(child, true, Colors.Zombies, false)
                    SetNameTag(child, true, "ZOMBIE", Colors.Zombies)
                    currentTargets[child] = true
                end
            end
        end
    end

    -- Pumpkins
    if Toggles.Pumpkins then
        local container = ResolvePath("Halloween.Pumpkins")
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("BasePart") or child:IsA("Model") then
                    SetHighlight(child, true, Colors.Pumpkins, false)
                    SetNameTag(child, true, "PUMPKIN ITEM", Colors.Pumpkins)
                    currentTargets[child] = true
                end
            end
        end
    end

    -- Jerry Cans
    if Toggles.JerryCans then
        local container = ResolvePath("JerryCans")
        if container then
            if container:IsA("BasePart") or container:IsA("Model") then
                SetHighlight(container, true, Colors.JerryCans, false)
                SetNameTag(container, true, "JERRYCAN GAS", Colors.JerryCans)
                currentTargets[container] = true
            else
                for _, child in ipairs(container:GetChildren()) do
                    if child:IsA("BasePart") or child:IsA("Model") then
                        SetHighlight(child, true, Colors.JerryCans, false)
                        SetNameTag(child, true, "JERRYCAN GAS", Colors.JerryCans)
                        currentTargets[child] = true
                    end
                end
            end
        end
    end

    -- Cabins
    if Toggles.Cabins then
        local container = ResolvePath("Cabins")
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("BasePart") or child:IsA("Model") then
                    SetHighlight(child, true, Colors.Cabins, true)
                    SetNameTag(child, true, "CABIN", Colors.Cabins)
                    currentTargets[child] = true
                end
            end
        end
    end

    -- Item Spots
    if Toggles.ItemSpots then
        local container = ResolvePath("ItemSpots")
        if container then
            for _, child in ipairs(container:GetChildren()) do
                local target = child:FindFirstChildOfClass("BasePart") or child:FindFirstChildOfClass("Model")
                if target then
                    local nameUpper = target.Name:upper()
                    local itemColor = Colors.ItemSpots
                    local displayName = nameUpper

                    if nameUpper:find("MARSHMALLOW") then
                        itemColor = Colors.Marshmallow
                        displayName = "MARSHMALLOW"
                    elseif nameUpper:find("CAMERA") then
                        itemColor = Colors.Camera
                        displayName = "CAMERA"
                    elseif nameUpper:find("BATTERY") then
                        itemColor = Colors.Battery
                        displayName = "BATTERY"
                    elseif nameUpper:find("SHOTGUN") or nameUpper:find("AMMO") then
                        itemColor = Colors.Shotgun
                        displayName = "SHOTGUN AMMO"
                    end

                    SetHighlight(target, true, itemColor, false)
                    SetNameTag(target, true, displayName, itemColor)
                    currentTargets[target] = true
                end
            end
        end
    end

    -- Shotgun
    if Toggles.Shotgun then
        local worldShotgun = Workspace:FindFirstChild("Shotgun")
        if worldShotgun and (worldShotgun:IsA("BasePart") or worldShotgun:IsA("Model")) then
            SetHighlight(worldShotgun, true, Colors.Shotgun, false)
            SetNameTag(worldShotgun, true, "SHOTGUN (W)", Colors.Shotgun)
            currentTargets[worldShotgun] = true
        else
            local char = LocalPlayer.Character
            local charShotgun = char and char:FindFirstChild("Shotgun")
            if charShotgun and charShotgun:IsA("Model") then
                local part = charShotgun.PrimaryPart or charShotgun:FindFirstChildOfClass("BasePart")
                if part then
                    SetHighlight(part, true, Colors.Shotgun, false)
                    SetNameTag(part, true, "SHOTGUN (E)", Colors.Shotgun)
                    currentTargets[part] = true
                end
            end
        end
    end

    -- Mutant
    if Toggles.Mutant then
        local mutant = Workspace:FindFirstChild("Mutant") or ReplicatedStorage:FindFirstChild("Mutant")
        if mutant then
            for _, partName in ipairs(MutantParts) do
                local part = mutant:FindFirstChild(partName)
                if part and (part:IsA("BasePart") or part:IsA("Model")) then
                    SetHighlight(part, true, Colors.Mutant, false)
                    if partName == "Head" then
                        SetNameTag(part, true, "MUTANT", Colors.Mutant)
                    end
                    currentTargets[part] = true
                end
            end
        end
    end

    -- Worker / Spider
    if Toggles.Worker then
        local worker = Workspace:FindFirstChild("WorkerHead") or ReplicatedStorage:FindFirstChild("WorkerHead")
        if worker then
            for _, partName in ipairs(WorkerParts) do
                local part = worker:FindFirstChild(partName)
                if part and (part:IsA("BasePart") or part:IsA("Model")) then
                    SetHighlight(part, true, Colors.Worker, false)
                    if partName == "Head" then
                        SetNameTag(part, true, "SPIDER", Colors.Worker)
                    end
                    currentTargets[part] = true
                end
            end
        end
    end

    -- Ghost
    if Toggles.Ghost then
        local ghost = Workspace:FindFirstChild("GhostChild") or ReplicatedStorage:FindFirstChild("GhostChild")
        if ghost then
            for _, partName in ipairs(GhostParts) do
                local part = ghost:FindFirstChild(partName)
                if part and (part:IsA("BasePart") or part:IsA("Model")) then
                    SetHighlight(part, true, Colors.Ghost, false)
                    if partName == "Head" then
                        SetNameTag(part, true, "GHOST", Colors.Ghost)
                    end
                    currentTargets[part] = true
                end
            end
        end
    end

    -- Live Ammo
    if Toggles.LiveAmmo then
        local container = ResolvePath("AmmoPiles")
        if container then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Model") or child:IsA("BasePart") then
                    local log = child:FindFirstChild("Log")
                    local shells = child:FindFirstChild("Shells")
                    if log and shells then
                        SetHighlight(log, true, Colors.LiveAmmoLog, false)
                        SetHighlight(shells, true, Colors.LiveAmmoShells, false)
                        SetNameTag(log, true, "LIVE AMMO", Colors.LiveAmmoShells)
                        currentTargets[log] = true
                        currentTargets[shells] = true
                    end
                end
            end
        end
    end

    -- Cleanup invalid/old instances
    for inst in pairs(ActiveHighlights) do
        if not currentTargets[inst] or not inst.Parent then
            SetHighlight(inst, false)
        end
    end
    for inst in pairs(ActiveNameTags) do
        if not currentTargets[inst] or not inst.Parent or not Toggles.Names then
            SetNameTag(inst, false)
        end
    end
end

local function ToggleESPState()
    local isAnyActive = Toggles.Zombies or Toggles.Pumpkins or Toggles.JerryCans or Toggles.Mutant or Toggles.Worker or Toggles.Cabins or Toggles.ItemSpots or Toggles.Shotgun or Toggles.LiveAmmo or Toggles.Ghost
    if isAnyActive and not ESPConnection then
        ESPConnection = RunService.RenderStepped:Connect(UpdateESP)
    elseif not isAnyActive and ESPConnection then
        ESPConnection:Disconnect()
        ESPConnection = nil
        for inst in pairs(ActiveHighlights) do SetHighlight(inst, false) end
        for inst in pairs(ActiveNameTags) do SetNameTag(inst, false) end
    end
end

-- Teleport Helper
local function TeleportToCFrame(cframe)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = cframe + Vector3.new(0, 5, 0)
    end
end

local function TeleportToNearestContainer(...)
    local containerPaths = {...}
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local closestPart = nil
    local closestDistance = math.huge

    for _, path in ipairs(containerPaths) do
        local container = ResolvePath(path)
        if container then
            for _, child in ipairs(container:GetChildren()) do
                local targetPart = child:IsA("BasePart") and child or (child:IsA("Model") and (child.PrimaryPart or child:FindFirstChildOfClass("BasePart", true)))
                if targetPart and targetPart.Position then
                    local dist = (hrp.Position - targetPart.Position).Magnitude
                    if dist < closestDistance then
                        closestDistance = dist
                        closestPart = targetPart
                    end
                end
            end
        end
    end

    if closestPart then
        TeleportToCFrame(closestPart.CFrame)
    end
end

-- Feature Loop Functions
local function ApplyNoclip()
    local char = LocalPlayer.Character
    if char then
        for _, part in ipairs(char:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function ApplyGodmode()
    local char = LocalPlayer.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.MaxHealth = 10000
        if humanoid.Health < 100 then
            humanoid.Health = 100
        end
        local state = humanoid:GetState()
        if state ~= Enum.HumanoidStateType.Running and state ~= Enum.HumanoidStateType.Jumping and state ~= Enum.HumanoidStateType.Freefall and state ~= Enum.HumanoidStateType.Seated then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
end

local function ApplyInfiniteBattery()
    local char = LocalPlayer.Character
    local flashlight = (char and char:FindFirstChild("Flashlight")) or (LocalPlayer.Backpack:FindFirstChild("Flashlight"))
    local battery = flashlight and flashlight:FindFirstChild("Battery")
    if battery and battery:IsA("NumberValue") then
        battery.Value = math.huge
    end
end

local function ApplyInfiniteStamina()
    local char = LocalPlayer.Character
    local stamina = char and char:FindFirstChild("Sprint") and char.Sprint:FindFirstChild("Stam")
    if stamina and stamina:IsA("NumberValue") then
        stamina.Value = 5
    end
end

-- Cabin Detection Setup
local function Notify(title, message)
    if Rayfield and Rayfield.Notify then
        Rayfield:Notify({Title = title, Content = message, Duration = 3, Image = 4483362458})
    else
        warn("[" .. title .. "] " .. message)
    end
end

local function SetupCabinWarning()
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local openDoorEvent = remotes and remotes:FindFirstChild("OpenDoor")
    
    if not openDoorEvent or not openDoorEvent:IsA("RemoteEvent") then
        Notify("Setup Error", "RemoteEvent 'OpenDoor' not found.")
        return
    end

    if CabinWarningConnection then CabinWarningConnection:Disconnect() end
    
    CabinWarningConnection = openDoorEvent.OnClientEvent:Connect(function(player, door)
        if player and player == LocalPlayer then return end
        local playerName = player and player.Name or "Unknown Entity"
        local doorName = door and door.Name or "a door"
        Notify("INTRUDER ALERT", playerName .. " is opening " .. doorName .. "!")
    end)
    
    Notify("Detector Active", "Monitoring cabin door interactions.")
end

-- UI Window Tabs
local VisualsTab = Window:CreateTab("Visuals / ESP", 4483362458)
local PlayerTab = Window:CreateTab("Player Mods", 4483362458)
local TeleportTab = Window:CreateTab("Teleports", 4483362458)
local MiscTab = Window:CreateTab("Misc / Server", 4483362458)

-- Visuals / ESP Options
VisualsTab:CreateToggle({
    Name = "Display Names",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Names = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Zombie ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Zombies = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Pumpkin ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Pumpkins = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Jerry Can ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.JerryCans = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Cabin ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Cabins = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Item Spot ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.ItemSpots = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Shotgun ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Shotgun = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Mutant ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Mutant = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Spider / Worker ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Worker = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Ghost ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Ghost = Value
        ToggleESPState()
    end
})

VisualsTab:CreateToggle({
    Name = "Live Ammo ESP",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.LiveAmmo = Value
        ToggleESPState()
    end
})

-- Player Mods
PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Noclip = Value
        if Value and not NoclipConnection then
            NoclipConnection = RunService.RenderStepped:Connect(ApplyNoclip)
        elseif not Value and NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
            local char = LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Godmode = Value
        if Value and not GodmodeConnection then
            GodmodeConnection = RunService.Heartbeat:Connect(ApplyGodmode)
        elseif not Value and GodmodeConnection then
            GodmodeConnection:Disconnect()
            GodmodeConnection = nil
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Infinite Battery",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.InfiniteBattery = Value
        if Value and not BatteryConnection then
            BatteryConnection = RunService.Stepped:Connect(ApplyInfiniteBattery)
        elseif not Value and BatteryConnection then
            BatteryConnection:Disconnect()
            BatteryConnection = nil
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Infinite Stamina",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.InfiniteStamina = Value
        if Value and not StaminaConnection then
            StaminaConnection = RunService.Heartbeat:Connect(ApplyInfiniteStamina)
        elseif not Value and StaminaConnection then
            StaminaConnection:Disconnect()
            StaminaConnection = nil
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Fullbright",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.Fullbright = Value
        local nightGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("Night")
        if Value then
            _G.OriginalBrightness = Lighting.Brightness
            _G.OriginalAmbient = Lighting.Ambient
            _G.OriginalOutdoorAmbient = Lighting.OutdoorAmbient
            _G.OriginalSky = Lighting:FindFirstChildOfClass("Sky")
            
            if _G.OriginalSky then _G.OriginalSky.Parent = nil end
            if nightGui then nightGui.Enabled = false end
            
            Lighting.Brightness = 2
            Lighting.Ambient = Color3.fromRGB(255, 255, 255)
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            if _G.OriginalBrightness then Lighting.Brightness = _G.OriginalBrightness end
            if _G.OriginalAmbient then Lighting.Ambient = _G.OriginalAmbient end
            if _G.OriginalOutdoorAmbient then Lighting.OutdoorAmbient = _G.OriginalOutdoorAmbient end
            if _G.OriginalSky then _G.OriginalSky.Parent = Lighting end
            if nightGui then nightGui.Enabled = true end
        end
    end
})

-- Teleports
TeleportTab:CreateButton({
    Name = "Teleport to Nearest Zombie",
    Callback = function()
        TeleportToNearestContainer("Zombies")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Nearest Pumpkin",
    Callback = function()
        TeleportToNearestContainer("Halloween.Pumpkins")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Nearest Jerry Can",
    Callback = function()
        TeleportToNearestContainer("JerryCans")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Nearest Cabin",
    Callback = function()
        TeleportToNearestContainer("Cabins")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Nearest Item Spot",
    Callback = function()
        TeleportToNearestContainer("ItemSpots")
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Nearest Ammo Pile",
    Callback = function()
        TeleportToNearestContainer("AmmoPiles")
    end
})

-- Misc Options
MiscTab:CreateToggle({
    Name = "Cabin Intruder Warning",
    CurrentValue = false,
    Callback = function(Value)
        Toggles.CabinWarning = Value
        if Value then
            SetupCabinWarning()
        elseif CabinWarningConnection then
            CabinWarningConnection:Disconnect()
            CabinWarningConnection = nil
            Notify("Detector Disabled", "Cabin alert system is off.")
        end
    end
})
