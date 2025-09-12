local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Castle settings
local castleWidth = 200
local castleDepth = 200
local castleHeight = 100
local towerHeight = 150
local towerRadius = 20
local wallThickness = 15
local floatHeight = 8000      -- very high in the sky
local floatAmplitude = 50     -- up-and-down motion
local floatSpeed = 0.1        -- slow gentle floating

-- Create castle folder
local castleFolder = Instance.new("Model")
castleFolder.Name = "SkyCastle"
castleFolder.Parent = Workspace

-- Function to create a part
local function createBlock(size, position, color, shape)
    local part = Instance.new("Part")
    part.Size = size
    part.Position = position
    part.Anchored = true
    part.Color = color or Color3.fromRGB(150,150,150)
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Material = Enum.Material.SmoothPlastic
    if shape == "cylinder" then
        local mesh = Instance.new("CylinderMesh")
        mesh.Parent = part
    elseif shape == "sphere" then
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Sphere
        mesh.Parent = part
    end
    part.Parent = castleFolder
    return part
end

-- Base platform
local base = createBlock(Vector3.new(castleWidth, wallThickness, castleDepth),
    Vector3.new(0, floatHeight, 0),
    Color3.fromRGB(120,120,130)
)

-- Towers
local towerPositions = {
    Vector3.new(castleWidth/2, floatHeight + towerHeight/2, castleDepth/2),
    Vector3.new(-castleWidth/2, floatHeight + towerHeight/2, castleDepth/2),
    Vector3.new(castleWidth/2, floatHeight + towerHeight/2, -castleDepth/2),
    Vector3.new(-castleWidth/2, floatHeight + towerHeight/2, -castleDepth/2)
}

for _, pos in pairs(towerPositions) do
    createBlock(Vector3.new(towerRadius*2, towerHeight, towerRadius*2), pos, Color3.fromRGB(200,200,200), "cylinder")
end

-- Walls with battlements
local function createWall(size, position)
    local wall = createBlock(size, position, Color3.fromRGB(180,180,180))
    local battlementCount = math.floor(size.X / 10)
    for i = 0, battlementCount-1 do
        createBlock(
            Vector3.new(10, 15, 10),
            position + Vector3.new(-size.X/2 + i*10 + 5, size.Y/2 + 7.5, 0),
            Color3.fromRGB(160,160,160)
        )
    end
end

createWall(Vector3.new(castleWidth, castleHeight, wallThickness), Vector3.new(0, floatHeight + castleHeight/2, castleDepth/2))
createWall(Vector3.new(castleWidth, castleHeight, wallThickness), Vector3.new(0, floatHeight + castleHeight/2, -castleDepth/2))
createWall(Vector3.new(wallThickness, castleHeight, castleDepth), Vector3.new(castleWidth/2, floatHeight + castleHeight/2, 0))
createWall(Vector3.new(wallThickness, castleHeight, castleDepth), Vector3.new(-castleWidth/2, floatHeight + castleHeight/2, 0))

-- Clouds folder
local cloudFolder = Instance.new("Folder")
cloudFolder.Name = "Clouds"
cloudFolder.Parent = Workspace

-- Create clouds under castle
local clouds = {}
for i = 1, 20 do
    local x = math.random(-castleWidth*2, castleWidth*2)
    local y = floatHeight - math.random(30, 60)  -- clouds under castle
    local z = math.random(-castleDepth*2, castleDepth*2)
    local size = Vector3.new(math.random(20,40), math.random(10,20), math.random(20,40))
    local cloud = Instance.new("Part")
    cloud.Size = size
    cloud.Position = Vector3.new(x, y, z)
    cloud.Anchored = true
    cloud.Color = Color3.fromRGB(255,255,255)
    cloud.Material = Enum.Material.SmoothPlastic
    cloud.Transparency = 0.5
    cloud.Parent = cloudFolder
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.Sphere
    mesh.Scale = Vector3.new(1,0.5,1)
    mesh.Parent = cloud
    table.insert(clouds, cloud)
end

-- Set PrimaryPart
castleFolder.PrimaryPart = base

-- Floating animation
local startTime = tick()
RunService.Heartbeat:Connect(function(dt)
    local t = tick() - startTime
    local yOffset = math.sin(t * floatSpeed) * floatAmplitude

    -- Float castle
    castleFolder:SetPrimaryPartCFrame(CFrame.new(0, floatHeight + yOffset, 0))

    -- Float clouds with castle + slight horizontal drift
    for i, cloud in ipairs(clouds) do
        local driftX = math.sin(t * 0.05 + i) * 2
        local driftZ = math.cos(t * 0.05 + i) * 2
        cloud.Position = Vector3.new(cloud.Position.X + driftX*dt, floatHeight - 40 + yOffset, cloud.Position.Z + driftZ*dt)
    end
end)
