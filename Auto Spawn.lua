local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local spawnPointCFrame = nil

-- Teleport function
local function teleportToSpawn(char)
	if spawnPointCFrame then
		task.wait(0.5)
		local hrp = char:WaitForChild("HumanoidRootPart")
		hrp.CFrame = spawnPointCFrame
	end
end

-- Hook respawn
LocalPlayer.CharacterAdded:Connect(teleportToSpawn)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 210)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Reopen button (stays visible even if GUI closed)
local reopenBtn = Instance.new("TextButton")
reopenBtn.Size = UDim2.new(0, 80, 0, 30)
reopenBtn.Position = UDim2.new(0, 10, 1, -40)
reopenBtn.Text = "Open Spawn GUI"
reopenBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
reopenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenBtn.Parent = screenGui
reopenBtn.Visible = false -- hidden until GUI is closed

-- Close button (just hides GUI, doesn't clear spawn)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -26, 0, 2)
closeBtn.Text = "X"
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Parent = frame

-- Minimize button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 24, 0, 24)
minimizeBtn.Position = UDim2.new(1, -52, 0, 2)
minimizeBtn.Text = "-"
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Parent = frame

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 30)
statusLabel.Position = UDim2.new(0, 10, 0, 35)
statusLabel.BackgroundTransparency = 1
statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statusLabel.Text = "No Spawn Set"
statusLabel.TextScaled = true
statusLabel.Parent = frame

-- Flash feedback
local function flashStatus(text, color)
	statusLabel.Text = text
	statusLabel.TextColor3 = color
	task.spawn(function()
		task.wait(1.5)
		statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
end

-- Buttons
local setBtn = Instance.new("TextButton")
setBtn.Size = UDim2.new(1, -20, 0, 40)
setBtn.Position = UDim2.new(0, 10, 0, 70)
setBtn.Text = "Set Spawn Point"
setBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
setBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setBtn.Parent = frame

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(1, -20, 0, 40)
clearBtn.Position = UDim2.new(0, 10, 0, 120)
clearBtn.Text = "Clear Spawn Point"
clearBtn.BackgroundColor3 = Color3.fromRGB(12
