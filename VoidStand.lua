-- 🌌 Upgraded Void Platform with Auto-Shield & Fall Recovery
-- Re-exec safe, multiplayer friendly, completely automated

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- 🧩 CONFIG
local PLATFORM_SIZE = Vector3.new(2000, 5, 2000)
local PLATFORM_COLOR = Color3.fromRGB(0, 191, 255)
local PLATFORM_OFFSET = -20 -- Placed slightly lower for safer falling space
local TELEPORT_HEIGHT = 15   -- Height to teleport you above the platform if you fall off the main map

-- 🧹 Remove old assets on re-exec
local oldPlatform = Workspace:FindFirstChild("VoidPlatform")
if oldPlatform then oldPlatform:Destroy() end

local oldFolder = Workspace:FindFirstChild("PlatformShields")
if oldFolder then oldFolder:Destroy() end

-- 🛡️ Create a folder to manage active shields
local shieldFolder = Instance.new("Folder")
shieldFolder.Name = "PlatformShields"
shieldFolder.Parent = Workspace

-- 🧍 Setup local character references
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(newChar)
	character = newChar
	hrp = newChar:WaitForChild("HumanoidRootPart")
end)

-- 🪶 Create the solid platform
local platform = Instance.new("Part")
platform.Name = "VoidPlatform"
platform.Size = PLATFORM_SIZE
platform.Anchored = true
platform.CanCollide = true
platform.Color = PLATFORM_COLOR
platform.Material = Enum.Material.ForceField -- Visual upgrade: looks like a sci-fi energy grid
platform.Transparency = 0.7
platform.CFrame = hrp.CFrame * CFrame.new(0, PLATFORM_OFFSET, 0)
platform.Parent = Workspace

-- 📐 Math boundaries for detection
local pCFrame = platform.CFrame
local pSize = platform.Size
local minX, maxX = pCFrame.X - (pSize.X / 2), pCFrame.X + (pSize.X / 2)
local minZ, maxZ = pCFrame.Z - (pSize.Z / 2), pCFrame.Z + (pSize.Z / 2)
local topY = pCFrame.Y + (pSize.Y / 2)

-- 🔄 Continuous loop to handle Fall Safety and Multi-Player Shielding
RunService.Heartbeat:Connect(function()
	-- Safety check for the local player's platform
	if not platform or not platform.Parent then return end

	-- 1. LOCAL SAFE ZONE RECOVERY
	if hrp and character:FindFirstChildOfClass("Humanoid") then
		-- If you fall below the main map but are hovering over our void platform
		if hrp.Position.Y < (topY + 5) and hrp.Position.Y > (topY - 20) then
			if hrp.Position.X > minX and hrp.Position.X < maxX and hrp.Position.Z > minZ and hrp.Position.Z < maxZ then
				-- If you fall all the way through the platform, pop back on top
				if hrp.Position.Y < (topY - 2) then
					hrp.CFrame = CFrame.new(hrp.Position.X, topY + TELEPORT_HEIGHT, hrp.Position.Z)
					hrp.AssemblyLinearVelocity = Vector3.zero -- Stop falling momentum instantly
				end
			end
		end
	end

	-- 2. MULTI-PLAYER SHIELD SYSTEM
	for _, p in ipairs(Players:GetPlayers()) do
		local char = p.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		
		if root and hum and hum.Health > 0 then
			local pos = root.Position
			-- Check if the player is physically standing inside the boundaries of the platform
			if pos.X > minX and pos.X < maxX and pos.Z > minZ and pos.Z < maxZ and pos.Y >= (topY - 2) and pos.Y <= (topY + 15) then
				-- Give shield if they don't have one
				if not shieldFolder:FindFirstChild(p.Name .. "_Shield") then
					local ff = Instance.new("ForceField")
					ff.Name = p.Name .. "_Shield"
					ff.Visible = true
					ff.Parent = char
				end
			else
				-- Strip shield if they leave the platform area
				local oldFF = char:FindFirstChild(p.Name .. "_Shield")
				if oldFF then oldFF:Destroy() end
			end
		end
	end
end)
