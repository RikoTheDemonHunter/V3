-- Local Cloud Stand Script (Thin Platform, Correct Height)
-- Put this LocalScript in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

-- Folder for local collision platforms
local cloudFolder = Instance.new("Folder")
cloudFolder.Name = "LocalCloudPlatforms"
cloudFolder.Parent = Workspace

-- Settings
local transparency = 1 -- 1 = invisible, 0 = visible
local platformPrefix = "LocalCloudPlatform__"
local platformThickness = 1 -- how thick the collision sheet is

-- Store cloud-to-platform pairs
local cloudPlatforms = {}

-- Check if a part looks like a cloud
local function isCloudPart(part)
	if not part:IsA("BasePart") then
		return false
	end
	local name = string.lower(part.Name)
	return string.find(name, "cloud") ~= nil
end

-- Create platform on top of cloud
local function createPlatform(cloudPart)
	if cloudPlatforms[cloudPart] then
		return
	end

	local platform = Instance.new("Part")
	platform.Name = platformPrefix .. cloudPart:GetDebugId()
	platform.Anchored = true
	platform.CanCollide = true
	platform.Transparency = transparency
	platform.CastShadow = false
	platform.Parent = cloudFolder

	cloudPlatforms[cloudPart] = platform
end

-- Remove platform when cloud is gone
local function removePlatform(cloudPart)
	local platform = cloudPlatforms[cloudPart]
	if platform then
		platform:Destroy()
		cloudPlatforms[cloudPart] = nil
	end
end

-- Update all platforms in one loop
RunService.RenderStepped:Connect(function()
	for cloudPart, platform in pairs(cloudPlatforms) do
		if not cloudPart or not cloudPart.Parent then
			removePlatform(cloudPart)
		else
			-- Match cloud X/Z size, but make Y very thin
			platform.Size = Vector3.new(cloudPart.Size.X, platformThickness, cloudPart.Size.Z)

			-- Place exactly on top surface of the cloud
			local offsetY = (cloudPart.Size.Y / 2) + (platform.Size.Y / 2)
			platform.CFrame = cloudPart.CFrame * CFrame.new(0, offsetY, 0)
		end
	end
end)

-- Initial scan
for _, obj in Workspace:GetDescendants() do
	if isCloudPart(obj) then
		createPlatform(obj)
	end
end

-- Watch for new clouds
Workspace.DescendantAdded:Connect(function(desc)
	if isCloudPart(desc) then
		createPlatform(desc)
	end
end)

-- Cleanup when clouds are removed
Workspace.DescendantRemoving:Connect(function(desc)
	if cloudPlatforms[desc] then
		removePlatform(desc)
	end
end)

print("[LocalCloudStand] You can now stand perfectly on top of clouds!")
