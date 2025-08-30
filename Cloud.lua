-- Local Cloud Stand Script
-- Put this in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local cloudFolder = Instance.new("Folder")
cloudFolder.Name = "LocalCloudPlatforms"
cloudFolder.Parent = Workspace

-- Settings
local transparency = 1 -- 1 = invisible, 0 = visible
local platformPrefix = "LocalCloudPlatform__"

-- Helper: Check if a part is a "cloud"
local function isCloudPart(part)
	if not part:IsA("BasePart") then return false end
	local name = string.lower(part.Name)
	return string.find(name, "cloud") ~= nil
end

-- Create local platform under the cloud
local function createPlatform(cloudPart)
	if cloudFolder:FindFirstChild(platformPrefix .. cloudPart:GetDebugId()) then return end

	local platform = Instance.new("Part")
	platform.Name = platformPrefix .. cloudPart:GetDebugId()
	platform.Size = cloudPart.Size
	platform.Anchored = true
	platform.CanCollide = true
	platform.Transparency = transparency
	platform.CastShadow = false
	platform.Parent = cloudFolder

	-- Update position every frame
	RunService.RenderStepped:Connect(function()
		if cloudPart.Parent == nil or platform.Parent == nil then
			if platform then platform:Destroy() end
			return
		end
		local offsetY = -(cloudPart.Size.Y/2) + 0.01
		platform.CFrame = cloudPart.CFrame * CFrame.new(0, offsetY, 0)
		platform.Size = cloudPart.Size
	end)
end

-- Scan workspace for clouds
local function generatePlatforms()
	for _, obj in ipairs(Workspace:GetDescendants()) do
		if isCloudPart(obj) then
			createPlatform(obj)
		end
	end
end

-- Detect new clouds
Workspace.DescendantAdded:Connect(function(desc)
	if isCloudPart(desc) then
		createPlatform(desc)
	end
end)

-- Run
generatePlatforms()
print("[LocalCloudStand] Ready! You can now stand on clouds.")
