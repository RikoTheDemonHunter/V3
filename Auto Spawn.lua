local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local spawnPointCFrame = nil

-- Teleport function
local function teleportToSpawn(char)
	if spawnPointCFrame then
		task.wait(0.5)
		local hrp = char:WaitForChild("HumanoidRootPart")
		hrp.CFrame = spawnPointCFrame -- ✅ always CFrame
	end
end

-- Hook respawn
LocalPlayer.CharacterAdded:Connect(teleportToSpawn)

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 190)
frame.Position = UDim2.new(0.35, 0, 0.35, 0)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Close button
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

-- Buttons
local setBtn = Instance.new("TextButton")
setBtn.Size = UDim2.new(1, -20, 0, 40)
setBtn.Position = UDim2.new(0, 10, 0, 40)
setBtn.Text = "Set Spawn Point"
setBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 200)
setBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
setBtn.Parent = frame

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(1, -20, 0, 40)
clearBtn.Position = UDim2.new(0, 10, 0, 90)
clearBtn.Text = "Clear Spawn Point"
clearBtn.BackgroundColor3 = Color3.fromRGB(120, 60, 60)
clearBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
clearBtn.Parent = frame

local tpNowBtn = Instance.new("TextButton")
tpNowBtn.Size = UDim2.new(1, -20, 0, 40)
tpNowBtn.Position = UDim2.new(0, 10, 0, 140)
tpNowBtn.Text = "Teleport Now"
tpNowBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
tpNowBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpNowBtn.Parent = frame

-- Logic
setBtn.MouseButton1Click:Connect(function()
	local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if hrp then
		spawnPointCFrame = hrp.CFrame -- ✅ store full CFrame (position + look direction)
	end
end)

clearBtn.MouseButton1Click:Connect(function()
	spawnPointCFrame = nil
end)

tpNowBtn.MouseButton1Click:Connect(function()
	if spawnPointCFrame then
		local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			hrp.CFrame = spawnPointCFrame
		end
	end
end)

closeBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
end)

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	for _, child in pairs(frame:GetChildren()) do
		if child:IsA("TextButton") and child ~= closeBtn and child ~= minimizeBtn then
			child.Visible = not minimized
		end
	end
	frame.Size = minimized and UDim2.new(0, 220, 0, 30) or UDim2.new(0, 220, 0, 190)
end)
