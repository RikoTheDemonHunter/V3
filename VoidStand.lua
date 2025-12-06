-- 🌌 Optimized Void Platform with Reliable Safe Zone
-- No false "entered/left" detection, re-exec safe

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- 🧩 CONFIG
local PLATFORM_SIZE = Vector3.new(2000, 5, 2000)
local PLATFORM_COLOR = Color3.fromRGB(0, 191, 255)
local PLATFORM_OFFSET = -13
local SAFE_HEIGHT = 30
local DETECTION_BUFFER = 1 -- tolerance buffer (anti-flicker)

-- 🧹 Remove old platform
local oldPlatform = workspace:FindFirstChild("VoidPlatform")
if oldPlatform then
	oldPlatform:Destroy()
end

-- 🧍 Setup character
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

-- 🪶 Create platform
local platform = Instance.new("Part")
platform.Name = "VoidPlatform"
platform.Size = PLATFORM_SIZE
platform.Anchored = true
platform.CanCollide = true
platform.Color = PLATFORM_COLOR
platform.Material = Enum.Material.Plastic
platform.Transparency = 0.8
platform.CFrame = hrp.CFrame * CFrame.new(0, PLATFORM_OFFSET, 0)
platform.Parent = workspace


