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

-- 🛡️ Safe Zone Logic
local platformY = platform.Position.Y
local platformHalf = PLATFORM_SIZE.Y / 2
local inSafeZone = false

task.spawn(function()
	while task.wait(0.25) do
		if not (platform and platform.Parent and humanoid and humanoid.Parent) then break end

		local hrpPos = hrp.Position
		local zoneBottom = platformY + platformHalf - 2 - DETECTION_BUFFER
		local zoneTop = platformY + SAFE_HEIGHT + DETECTION_BUFFER

		local isSafe =
			hrpPos.Y >= zoneBottom
			and hrpPos.Y <= zoneTop
			and math.abs(hrpPos.X - platform.Position.X) <= PLATFORM_SIZE.X / 2
			and math.abs(hrpPos.Z - platform.Position.Z) <= PLATFORM_SIZE.Z / 2

		if isSafe then
			if not inSafeZone then
				inSafeZone = true
				
			end
			if humanoid.Health < humanoid.MaxHealth then
				humanoid.Health = humanoid.MaxHealth
			end
			humanoid:SetAttribute("IsSafe", true)
		else
			if inSafeZone then
				inSafeZone = false
				
			end
			humanoid:SetAttribute("IsSafe", false)
		end
	end
end)

-- 🌀 ForceField protection
task.spawn(function()
	while task.wait(0.5) do
		if not (platform and platform.Parent and humanoid and humanoid.Parent) then break end

		if inSafeZone then
			if not character:FindFirstChildOfClass("ForceField") then
				Instance.new("ForceField", character)
			end
		else
			local ff = character:FindFirstChildOfClass("ForceField")
			if ff then ff:Destroy() end
		end
	end
end)

-- 🧽 Cleanup
humanoid.Died:Connect(function()
	local ff = character:FindFirstChildOfClass("ForceField")
	if ff then ff:Destroy() end
end)
