local Workspace = game:GetService("Workspace")

-- Castle settings
local castleWidth = 400-- adjust as needed
local castleDepth = 400 -- adjust as needed
local castleHeight = 50 -- wall height
local towerSize = 20
local floatHeight = 8000

-- Create the castle base
local base = Instance.new("Part")
base.Size = Vector3.new(castleWidth, 5, castleDepth)
base.Position = Vector3.new(0, floatHeight, 0)
base.Anchored = true
base.BrickColor = BrickColor.new("Medium stone grey")
base.Parent = Workspace

-- Create walls
local function createWall(size, position)
    local wall = Instance.new("Part")
    wall.Size = size
    wall.Position = position
    wall.Anchored = true
    wall.BrickColor = BrickColor.new("Medium stone grey")
    wall.Parent = Workspace
end

-- Front and back walls
createWall(Vector3.new(castleWidth, castleHeight, 5), Vector3.new(0, floatHeight + castleHeight/2, castleDepth/2))
createWall(Vector3.new(castleWidth, castleHeight, 5), Vector3.new(0, floatHeight + castleHeight/2, -castleDepth/2))

-- Side walls
createWall(Vector3.new(5, castleHeight, castleDepth), Vector3.new(castleWidth/2, floatHeight + castleHeight/2, 0))
createWall(Vector3.new(5, castleHeight, castleDepth), Vector3.new(-castleWidth/2, floatHeight + castleHeight/2, 0))

-- Towers
local function createTower(position)
    local tower = Instance.new("Part")
    tower.Size = Vector3.new(towerSize, castleHeight + 20, towerSize)
    tower.Position = position
    tower.Anchored = true
    tower.BrickColor = BrickColor.new("Medium stone grey")
    tower.Parent = Workspace
end

-- Four corners
createTower(Vector3.new(castleWidth/2, floatHeight + (castleHeight + 20)/2, castleDepth/2))
createTower(Vector3.new(-castleWidth/2, floatHeight + (castleHeight + 20)/2, castleDepth/2))
createTower(Vector3.new(castleWidth/2, floatHeight + (castleHeight + 20)/2, -castleDepth/2))
createTower(Vector3.new(-castleWidth/2, floatHeight + (castleHeight + 20)/2, -castleDepth/2))
