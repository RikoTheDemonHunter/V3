-- Local Cloud Stand Script (On Top of Clouds)
-- Put this LocalScript in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Folder to hold your local collision platforms
local cloudFolder = Instance.new("Folder")
cloudFolder.Name = "LocalCloudPlatforms"
cloudFolder.Parent = Workspace

-- Settings
local transparency = 1 -- 1 = invisible, 0 = visible
local platformPrefix = "LocalCloudPlatform__"

-- Check if a part looks like a cloud
local function isCloudPart(part)
	if not part:IsA("BasePart") then
		return false
	end
	local name = string.lower(part.Name)
	return string.find(name, "cloud") ~= nil
end

-- Create an invisible platform on top of the cloud
local function createPlatform(cloudPart)
	-- Prevent duplicates
	if cloudFolder:FindFirstChild(platformPrefix .. cloudPart:GetDebugId()) then
		return
	end

	local platform = Instance.new("Part")
	platform.Name = platformPrefix .. cloudPart:GetDebugId()
	platform.Anchored = true
	platform.CanCollide = true
	platform.Transparency = transparency
	platform.CastShadow = false
	platform.Size = cloudPart.Size
	platform.Parent = cloudFolder

	-- Keep platform following the top of the cloud
	RunService.RenderStepped:Connect(function()
		if not cloudPart or not cloudPart.Parent or not platform or not platform.Parent then
			if platform then
				platform:Destroy()
			end
			return
		end

		-- Place the platform on *top* of the cloud
		local offsetY = (cloudPart.Size.Y / 2) + 0.01
		platform.CFrame = cloudPart.CFrame * CFrame.new(0, offsetY, 0)
		platform.Size = cloudPart.Size
	end)
end

-- Scan for all existing clouds
local function generatePlatforms()
	for _, obj in Workspace:GetDescendants() do
		if isCloudPart(obj) then
			createPlatform(obj)
		end
	end
end

-- Listen for new clouds
Workspace.DescendantAdded:Connect(function(desc)
	if isCloudPart(desc) then
		createPlatform(desc)
	end
end)

-- Run at startup
generatePlatforms()
print("[LocalCloudStand] You can now stand on top of clouds!")
