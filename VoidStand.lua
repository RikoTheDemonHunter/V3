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

-- 🛡️ Safe Zone Logic (FIXED + SIZE-CHANGE SAFE)
local inSafeZone = false
local SIZE_CHANGE_BUFFER = 6 -- prevents shield from disappearing when you shrink/grow

task.spawn(function()
	while task.wait(0.1) do
		if not (platform and platform.Parent and humanoid and humanoid.Parent) then
			break
		end

		-- Always update platform position in case of respawn / re-exec
		local platformY = platform.Position.Y
		local platformHalf = PLATFORM_SIZE.Y / 2

		-- Safe zone height range
		local zoneBottom = platformY + platformHalf - DETECTION_BUFFER
		local zoneTop = zoneBottom + SAFE_HEIGHT

		local hrpPos = hrp.Position

		-- X/Z check with extra buffer so growing/shrinking doesn't break the zone
		local withinXZ =
			math.abs(hrpPos.X - platform.Position.X) <= (PLATFORM_SIZE.X / 2) + SIZE_CHANGE_BUFFER
			and math.abs(hrpPos.Z - platform.Position.Z) <= (PLATFORM_SIZE.Z / 2) + SIZE_CHANGE_BUFFER

		-- Y check with buffer so sudden height changes don't kick you out
		local withinY =
			hrpPos.Y >= (zoneBottom - SIZE_CHANGE_BUFFER)
			and hrpPos.Y <= (zoneTop + SIZE_CHANGE_BUFFER)

		local isSafe = withinXZ and withinY

		if isSafe and not inSafeZone then
			inSafeZone = true
			humanoid:SetAttribute("IsSafe", true)
			
		elseif not isSafe and inSafeZone then
			inSafeZone = false
			humanoid:SetAttribute("IsSafe", false)
		end

		-- Auto-heal while safe
		if inSafeZone and humanoid.Health < humanoid.MaxHealth then
			humanoid.Health = humanoid.MaxHealth
		end
	end
end)

-- 🧽 Cleanup
humanoid.Died:Connect(function()
	local ff = character:FindFirstChildOfClass("ForceField")
	if ff then ff:Destroy() end
end)
