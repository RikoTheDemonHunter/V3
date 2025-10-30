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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local platform = workspace:FindFirstChild("VoidPlatform")
if not platform then return end

local SAFE_HEIGHT = 30
local platformY = platform.Position.Y
local inSafeZone = false

-- soft aura ring (visual only)
local aura = Instance.new("Part")
aura.Anchored = true
aura.CanCollide = false
aura.Material = Enum.Material.Neon
aura.Color = Color3.fromRGB(0, 200, 255)
aura.Transparency = 0.9
aura.Size = Vector3.new(platform.Size.X, 0.2, platform.Size.Z)
aura.CFrame = platform.CFrame * CFrame.new(0, 2.5, 0)
aura.Name = "ProtectionAura"
aura.Parent = workspace

-- gentle pulse
task.spawn(function()
	while aura.Parent do
		local t = tick() * 2
		local s = 0.9 + math.sin(t) * 0.05
		aura.Transparency = s
		task.wait(0.05)
	end
end)

-- healing / feedback loop
task.spawn(function()
	while humanoid and humanoid.Parent and platform.Parent do
		local posY = hrp.Position.Y
		local isSafe = posY > (platformY - 2) and posY < (platformY + SAFE_HEIGHT)

		if isSafe and not inSafeZone then
			inSafeZone = true
			print("[Aura] Entered peaceful zone")
			TweenService:Create(aura, TweenInfo.new(0.5), {Transparency = 0.7}):Play()
		elseif not isSafe and inSafeZone then
			inSafeZone = false
			print("[Aura] Left peaceful zone")
			TweenService:Create(aura, TweenInfo.new(0.5), {Transparency = 0.9}):Play()
		end

		if inSafeZone and humanoid.Health < humanoid.MaxHealth then
			humanoid.Health = math.min(humanoid.Health + 1, humanoid.MaxHealth)
		end
		task.wait(0.25)
	end
end)

-- cleanup
humanoid.Died:Connect(function()
	if aura and aura.Parent then aura:Destroy() end
end)

