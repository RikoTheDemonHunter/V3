-- 🌌 Optimized Void Platform with Auto-Fall Recovery (Shields Removed)
-- Re-exec safe, highly performance optimized, lightweight

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- 🧩 CONFIG
local PLATFORM_SIZE = Vector3.new(2000, 5, 2000)
local PLATFORM_COLOR = Color3.fromRGB(0, 191, 255)
local PLATFORM_OFFSET = -20 -- Placed lower for safer falling space
local TELEPORT_HEIGHT = 15   -- Height to teleport you above the platform if you fall off the main map
local CHECK_INTERVAL = 0.1   -- Checks every 0.1s instead of every single frame (saves massive CPU)

-- 🧹 Remove old platform on re-exec
local oldPlatform = Workspace:FindFirstChild("VoidPlatform")
if oldPlatform then oldPlatform:Destroy() end

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
platform.Material = Enum.Material.Plastic -- Changed to plastic for maximum performance
platform.Transparency = 0.8
platform.CFrame = hrp.CFrame * CFrame.new(0, PLATFORM_OFFSET, 0)
platform.Parent = Workspace

-- 📐 Math boundaries for detection
local pCFrame = platform.CFrame
local pSize = platform.Size
local minX, maxX = pCFrame.X - (pSize.X / 2), pCFrame.X + (pSize.X / 2)
local minZ, maxZ = pCFrame.Z - (pSize.Z / 2), pCFrame.Z + (pSize.Z / 2)
local topY = pCFrame.Y + (pSize.Y / 2)

-- 🔄 Ultra-lightweight loop to handle Fall Safety
task.spawn(function()
	while task.wait(CHECK_INTERVAL) do
		-- Safety check to ensure the platform wasn't deleted by the game
		if not platform or not platform.Parent then break end

		if hrp and character:FindFirstChildOfClass("Humanoid") then
			local currentPos = hrp.Position
			
			-- Check if you are hovering inside the 3D zone above/below our void platform
			if currentPos.Y < (topY + 5) and currentPos.Y > (topY - 20) then
				if currentPos.X > minX and currentPos.X < maxX and currentPos.Z > minZ and currentPos.Z < maxZ then
					
					-- If you slip through or fall below the surface line, snap back up instantly
					if currentPos.Y < (topY - 2) then
						hrp.CFrame = CFrame.new(currentPos.X, topY + TELEPORT_HEIGHT, currentPos.Z)
						hrp.AssemblyLinearVelocity = Vector3.zero -- Cancels falling momentum instantly
					end
					
				end
			end
		end
	end
end)
