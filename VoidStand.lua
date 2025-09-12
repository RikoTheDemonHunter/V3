-- Optimized Void Platform (2000x2000, re-exec safe, plastic & transparent)
-- Re-run this script to delete the old platform and spawn a new one

local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Config
local PLATFORM_SIZE = Vector3.new(2000, 5, 2000) -- gigantic void floor
local PLATFORM_COLOR = Color3.fromRGB(0, 191, 255) -- light blue
local PLATFORM_OFFSET = -13 -- studs below HumanoidRootPart

-- delete old one if it exists (safe for re-exec)
local oldPlatform = workspace:FindFirstChild("VoidPlatform")
if oldPlatform then
    oldPlatform:Destroy()
end

-- make sure character exists
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- create platform
local platform = Instance.new("Part")
platform.Name = "VoidPlatform"
platform.Size = PLATFORM_SIZE
platform.Anchored = true
platform.CanCollide = true
platform.Color = PLATFORM_COLOR
platform.Material = Enum.Material.Plastic -- lightweight
platform.Transparency = 0.8 -- very see-through
platform.CFrame = hrp.CFrame * CFrame.new(0, PLATFORM_OFFSET, 0)

platform.Parent = workspace
