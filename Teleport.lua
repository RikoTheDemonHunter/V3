--// SERVICES
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

--// GUI CREATION
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "TeleportGUI"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 250, 0, 140)
MainFrame.Position = UDim2.new(0.5, -125, 0.4, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", MainFrame)
Title.Text = "Teleport GUI"
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local Dropdown = Instance.new("TextButton", MainFrame)
Dropdown.Size = UDim2.new(1, -20, 0, 30)
Dropdown.Position = UDim2.new(0, 10, 0, 40)
Dropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Dropdown.TextColor3 = Color3.new(1, 1, 1)
Dropdown.Text = "Select Player"
Dropdown.Font = Enum.Font.Gotham
Dropdown.TextSize = 14

local PlayerList = Instance.new("Frame", MainFrame)
PlayerList.Size = UDim2.new(1, -20, 0, 60)
PlayerList.Position = UDim2.new(0, 10, 0, 75)
PlayerList.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
PlayerList.Visible = false
PlayerList.ClipsDescendants = true

local UIListLayout = Instance.new("UIListLayout", PlayerList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local MinimizeButton = Instance.new("TextButton", MainFrame)
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Position = UDim2.new(1, -25, 0, 5)
MinimizeButton.Text = "-"
MinimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
MinimizeButton.Font = Enum.Font.Gotham
MinimizeButton.TextSize = 14

--// FUNCTION TO POPULATE PLAYER LIST
local function updatePlayers()
	PlayerList:ClearAllChildren()
	UIListLayout.Parent = PlayerList

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, 0, 0, 25)
			Btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			Btn.TextColor3 = Color3.new(1, 1, 1)
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 12
			Btn.Text = plr.Name
			Btn.Parent = PlayerList

			Btn.MouseButton1Click:Connect(function()
				local char = plr.Character
				if char and char:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
					LocalPlayer.Character:MoveTo(char.HumanoidRootPart.Position + Vector3.new(2, 0, 2))
				end
				Dropdown.Text = "Selected: " .. plr.Name
				PlayerList.Visible = false
			end)
		end
	end
end

--// TOGGLE DROPDOWN
Dropdown.MouseButton1Click:Connect(function()
	PlayerList.Visible = not PlayerList.Visible
	updatePlayers()
end)

--// MINIMIZE BUTTON FUNCTION
local minimized = false
MinimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		for _, obj in pairs(MainFrame:GetChildren()) do
			if obj:IsA("TextButton") or obj:IsA("Frame") or obj:IsA("TextLabel") then
				if obj ~= MinimizeButton then obj.Visible = false end
			end
		end
		MinimizeButton.Text = "+"
		MainFrame.Size = UDim2.new(0, 250, 0, 30)
	else
		for _, obj in pairs(MainFrame:GetChildren()) do
			if obj:IsA("TextButton") or obj:IsA("Frame") or obj:IsA("TextLabel") then
				obj.Visible = true
			end
		end
		MinimizeButton.Text = "-"
		MainFrame.Size = UDim2.new(0, 250, 0, 140)
	end
end)
