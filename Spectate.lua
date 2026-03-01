local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Commands
local COMMAND_ANTIVOID = "!antivoid"
local COMMAND_SCARE = "!scare"
local COMMAND_FAKEOUT = "!fakeout"

-- Toggle flag
local antiVoidEnabled = false

-- Function to teleport in front of a target player
local function scarePlayer(targetName)
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and LocalPlayer.Character then
        local targetHRP = target.Character:FindFirstChild("HumanoidRootPart")
        local myHRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and myHRP then
            local frontOffset = targetHRP.CFrame.LookVector * 3
            myHRP.CFrame = targetHRP.CFrame + frontOffset
        end
    end
end

-- Function to do fakeout once
local function fakeout()
    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local originalCFrame = hrp.CFrame
            hrp.CFrame = CFrame.new(0, -5000, 0)
            wait(0.3)
            hrp.CFrame = originalCFrame
        end
    end
end

-- Function to handle AntiVoid when toggled
local function handleAntiVoid()
    local char = LocalPlayer.Character
    if antiVoidEnabled and char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChild("Humanoid")
        if hrp and humanoid and hrp.Position.Y < -50 then
            hrp.Velocity = Vector3.new(0,0,0)
            hrp.Position = Vector3.new(hrp.Position.X, -5, hrp.Position.Z)
            humanoid.Health = humanoid.Health
        end
    end
end

-- Listen to chat
LocalPlayer.Chatted:Connect(function(msg)
    local msgLower = msg:lower()
    
    if msgLower == COMMAND_ANTIVOID then
        antiVoidEnabled = not antiVoidEnabled
        print("AntiVoid " .. (antiVoidEnabled and "Enabled" or "Disabled"))
        -- Run AntiVoid once immediately when toggled
        handleAntiVoid()
    
    elseif msgLower:sub(1, #COMMAND_SCARE) == COMMAND_SCARE then
        local targetName = msg:sub(#COMMAND_SCARE + 2)
        if targetName ~= "" then
            scarePlayer(targetName)
        end
    
    elseif msgLower == COMMAND_FAKEOUT then
        fakeout()
    end
end)
