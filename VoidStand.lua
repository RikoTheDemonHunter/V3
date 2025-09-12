-- Void Platform LocalScript (500x500, auto-delete old one)
-- Put inside StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Config
local PLATFORM_SIZE = Vector3.new(500, 1, 500) -- giant void floor
local PLATFORM_COLOR = Color3.fromRGB(0, 191, 255)
local PLATFORM_OFFSET = -13 -- studs below HumanoidRootPart

-- Function to create the void platform
local function createPlatform(character)
	-- delete old one if it exists
	local oldPlatform = workspace:FindFirstChild("VoidPlatform")
	if oldPlatform then
		oldPlatform:Destroy()
	end

	local hrp = character:WaitForChild("HumanoidRootPart")

	local platform = Instance.new("Part")
	platform.Name = "VoidPlatform"
	platform.Size = PLATFORM_SIZE
	platform.Anchored = true
	platform.CanCollide = true
	platform.Color = PLATFORM_COLOR
	platform.Material = Enum.Material.Neon
	platform.Transparency = 0.3
	platform.CFrame = hrp.CFrame * CFrame.new(0, PLATFORM_OFFSET, 0)

	platform.Parent = workspace
end

-- Run when character spawns
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart") -- make sure it exists
	createPlatform(char)
end)

-- Also run for first spawn
if player.Character then
	createPlatform(player.Character)
end
