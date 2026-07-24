
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local CONFIG = {
	Transparency = 1,
	PlatformThickness = 0.5,
	PlatformPrefix = "LocalCloudPlatform__",
	DynamicClouds = false,
}

local cloudFolder = Instance.new("Folder")
cloudFolder.Name = "LocalCloudPlatforms"
cloudFolder.Parent = Workspace

local cloudPlatforms = {}

local function isCloudPart(part)
	if not part:IsA("BasePart") then
		return false
	end
	if string.sub(part.Name, 1, #CONFIG.PlatformPrefix) == CONFIG.PlatformPrefix then
		return false
	end
	return string.find(string.lower(part.Name), "cloud") ~= nil
end

local function updatePlatformTransform(cloudPart, platform)
	platform.Size = Vector3.new(cloudPart.Size.X, CONFIG.PlatformThickness, cloudPart.Size.Z)
	local offsetY = (cloudPart.Size.Y / 2) + (platform.Size.Y / 2)
	platform.CFrame = cloudPart.CFrame * CFrame.new(0, offsetY, 0)
end

local function createPlatform(cloudPart)
	if cloudPlatforms[cloudPart] then return end

	local platform = Instance.new("Part")
	platform.Name = CONFIG.PlatformPrefix .. cloudPart:GetDebugId()
	platform.Anchored = true
	platform.CanCollide = true
	platform.Transparency = CONFIG.Transparency
	platform.CastShadow = false
	platform.Material = Enum.Material.SmoothPlastic
	
	updatePlatformTransform(cloudPart, platform)
	platform.Parent = cloudFolder

	cloudPlatforms[cloudPart] = platform
	
	if not CONFIG.DynamicClouds then
		local sizeConn = cloudPart:GetPropertyChangedSignal("Size"):Connect(function()
			if cloudPlatforms[cloudPart] then
				updatePlatformTransform(cloudPart, platform)
			end
		end)
		local cframeConn = cloudPart:GetPropertyChangedSignal("CFrame"):Connect(function()
			if cloudPlatforms[cloudPart] then
				updatePlatformTransform(cloudPart, platform)
			end
		end)
		
		platform:SetAttribute("SizeConn", sizeConn)
		platform:SetAttribute("CFrameConn", cframeConn)
	end
end

local function removePlatform(cloudPart)
	local platform = cloudPlatforms[cloudPart]
	if platform then
		local sizeConn = platform:GetAttribute("SizeConn")
		if sizeConn then sizeConn:Disconnect() end
		
		local cframeConn = platform:GetAttribute("CFrameConn")
		if cframeConn then cframeConn:Disconnect() end
		
		platform:Destroy()
		cloudPlatforms[cloudPart] = nil
	end
end

if CONFIG.DynamicClouds then
	RunService.RenderStepped:Connect(function()
		for cloudPart, platform in pairs(cloudPlatforms) do
			if not cloudPart or not cloudPart.Parent then
				removePlatform(cloudPart)
			else
				updatePlatformTransform(cloudPart, platform)
			end
		end
	end)
end

for _, obj in ipairs(Workspace:GetDescendants()) do
	if isCloudPart(obj) then
		createPlatform(obj)
	end
end

Workspace.DescendantAdded:Connect(function(desc)
	if isCloudPart(desc) then
		createPlatform(desc)
	end
end)

Workspace.DescendantRemoving:Connect(function(desc)
	if cloudPlatforms[desc] then
		removePlatform(desc)
	end
end)

print("[LocalCloudStand] Activated. Standing platforms generated successfully!")
