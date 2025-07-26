-- Admin Panel GUI
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "AdminPanel"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 200)
frame.Position = UDim2.new(0.5, -150, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Admin Panel"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
title.BorderSizePixel = 0

-- Dropdown
local dropdown = Instance.new("TextButton", frame)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.Size = UDim2.new(0, 280, 0, 30)
dropdown.Text = "Select Player"
dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown.TextColor3 = Color3.new(1, 1, 1)

local selectedPlayer = nil

-- Refresh dropdown
local function refreshDropdown()
	dropdown.Text = "Select Player"
	local menu = Instance.new("Frame", frame)
	menu.Name = "DropdownMenu"
	menu.Position = UDim2.new(0, 10, 0, 70)
	menu.Size = UDim2.new(0, 280, 0, 100)
	menu.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	menu.BorderSizePixel = 0

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local btn = Instance.new("TextButton", menu)
			btn.Size = UDim2.new(1, 0, 0, 25)
			btn.Text = p.Name
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			btn.TextColor3 = Color3.new(1, 1, 1)

			btn.MouseButton1Click:Connect(function()
				selectedPlayer = p
				dropdown.Text = "Selected: " .. p.Name
				menu:Destroy()
			end)
		end
	end
end

dropdown.MouseButton1Click:Connect(function()
	if frame:FindFirstChild("DropdownMenu") then
		frame:FindFirstChild("DropdownMenu"):Destroy()
	else
		refreshDropdown()
	end
end)

-- Teleport Button
local tpButton = Instance.new("TextButton", frame)
tpButton.Position = UDim2.new(0, 10, 0, 110)
tpButton.Size = UDim2.new(0, 135, 0, 30)
tpButton.Text = "Teleport to Player"
tpButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
tpButton.TextColor3 = Color3.new(1, 1, 1)

tpButton.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(selectedPlayer.Character.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
	end
end)

-- Kick Button (Client-side only visual; server required for real kick)
local kickButton = Instance.new("TextButton", frame)
kickButton.Position = UDim2.new(0, 155, 0, 110)
kickButton.Size = UDim2.new(0, 135, 0, 30)
kickButton.Text = "Fake Kick"
kickButton.BackgroundColor3 = Color3.fromRGB(90, 30, 30)
kickButton.TextColor3 = Color3.new(1, 1, 1)

kickButton.MouseButton1Click:Connect(function()
	if selectedPlayer then
		warn("You would kick: " .. selectedPlayer.Name .. " (Needs server support)")
	end
end)

-- Minimize Button
local minimize = Instance.new("TextButton", frame)
minimize.Position = UDim2.new(1, -30, 0, 0)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minimize.TextColor3 = Color3.new(1, 1, 1)

minimize.MouseButton1Click:Connect(function()
	frame.Visible = false
end)
