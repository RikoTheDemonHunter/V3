-- Void Platform LocalScript (lowered -8)
-- Put inside StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Config
local PLATFORM_SIZE = Vector3.new(20, 1, 20) -- wide platform
local PLATFORM_COLOR = Color3.fromRGB(20, 20, 30)

-- Function to create the void platform
local function createPlatform()
	local platform = Instance.new("Part")
	platform.Name = "VoidPlatform"
	platform.Size = PLATFORM_SIZE
	platform.Anchored = true
	platform.CanCollide = true
	platform.Color = PLATFORM_COLOR
	platform.Material = Enum.Material.Neon
	platform.Transparency = 0.3

	-- Place lower under the player (-8 studs)
	platform.CFrame = humanoidRootPart.CFrame * CFrame.new(0, -8, 0)

	platform.Parent = workspace
end

-- Create platform once when you load in
createPlatform()
