local Workspace = game:GetService("Workspace")

-- Castle settings
local castleWidth = 5000
local castleDepth = 5000
local wallHeight = 500
local towerHeight = 700
local towerSize = 500
local wallThickness = 100
local floatHeight = 8000 -- How high it floats
local archHeight = 200
local archWidth = 400

-- Create a folder to hold the castle
local castleFolder = Instance.new("Model")
castleFolder.Name = "FloatingCastle"
castleFolder.Parent = Workspace

-- Function to create a block
local function createBlock(size, position, color)
    local part = Instance.new("Part")
    part.Size = size
    part.Position = position
    part.Anchored = true
    part.Color = color or Color3.fromRGB(180,180,180)
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = castleFolder
    return part
end

-- Function to create a tower with battlements
local function createTower(position)
    local tower = createBlock(Vector3.new(towerSize, towerHeight, towerSize), position, Color3.fromRGB(200,200,200))
    -- battlements
    local battlementHeight = 50
    local battlementSize = 100
    local yPos = position.Y + towerHeight/2 + battlementHeight/2
    local offsets = {-towerSize/2 + battlementSize/2, towerSize/2 - battlementSize/2}
    for _, x in pairs(offsets) do
        for _, z in pairs(offsets) do
            createBlock(Vector3.new(battlementSize, battlementHeight, battlementSize), Vector3.new(position.X + x, yPos, position.Z + z), Color3.fromRGB(160,160,160))
        end
    end
end

-- Base platform (optional)
createBlock(Vector3.new(castleWidth, wallThickness, castleDepth), Vector3.new(0, floatHeight - wallThickness/2, 0), Color3.fromRGB(150,150,150))

-- Towers at corners
local towerPositions = {
    Vector3.new(castleWidth/2, floatHeight + towerHeight/2, castleDepth/2),
    Vector3.new(-castleWidth/2, floatHeight + towerHeight/2, castleDepth/2),
    Vector3.new(castleWidth/2, floatHeight + towerHeight/2, -castleDepth/2),
    Vector3.new(-castleWidth/2, floatHeight + towerHeight/2, -castleDepth/2)
}

for _, pos in pairs(towerPositions) do
    createTower(pos)
end

-- Walls
-- Front wall with arch
local frontWall = createBlock(Vector3.new(castleWidth - 2*towerSize, wallHeight, wallThickness), Vector3.new(0, floatHeight + wallHeight/2, castleDepth/2), Color3.fromRGB(180,180,180))
-- Arch space (just removing part)
createBlock(Vector3.new(archWidth, archHeight, wallThickness + 1), Vector3.new(0, floatHeight + archHeight/2, castleDepth/2), Color3.fromRGB(0,0,0)) -- invisible placeholder

-- Back wall
createBlock(Vector3.new(castleWidth - 2*towerSize, wallHeight, wallThickness), Vector3.new(0, floatHeight + wallHeight/2, -castleDepth/2), Color3.fromRGB(180,180,180))
-- Side walls
createBlock(Vector3.new(wallThickness, wallHeight, castleDepth - 2*towerSize), Vector3.new(castleWidth/2, floatHeight + wallHeight/2, 0), Color3.fromRGB(180,180,180))
createBlock(Vector3.new(wallThickness, wallHeight, castleDepth - 2*towerSize), Vector3.new(-castleWidth/2, floatHeight + wallHeight/2, 0), Color3.fromRGB(180,180,180))
