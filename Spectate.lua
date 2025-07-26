local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Replace this with the actual Drop event used in your game
local DropEvent = ReplicatedStorage:WaitForChild("DropDrinkEvent") 

-- Example drink list (you must match names used in the game)
local drinkList = {
    "Omega Burp Juice",
    "Thunder Fizz",
    "Garlic Juice",
    
}

-- GUI Setup
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "DropDrinkGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Text = "Drop Drink Panel"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local dropdown = Instance.new("TextButton", frame)
dropdown.Text = "Select Drink"
dropdown.Size = UDim2.new(1, -20, 0, 30)
dropdown.Position = UDim2.new(0, 10, 0, 40)
dropdown.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)

local dropButton = Instance.new("TextButton", frame)
dropButton.Text = "Drop Drink"
dropButton.Size = UDim2.new(1, -20, 0, 30)
dropButton.Position = UDim2.new(0, 10, 0, 80)
dropButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
dropButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local selectedDrink = drinkList[1]
dropdown.Text = "Selected: " .. selectedDrink

-- Dropdown cycling
local index = 1
dropdown.MouseButton1Click:Connect(function()
	index = (index % #drinkList) + 1
	selectedDrink = drinkList[index]
	dropdown.Text = "Selected: " .. selectedDrink
end)

-- Drop action
dropButton.MouseButton1Click:Connect(function()
	if selectedDrink and DropEvent then
		DropEvent:FireServer(selectedDrink)
	end
end)
