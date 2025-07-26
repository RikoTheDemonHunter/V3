local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local giveDrinkEvent = ReplicatedStorage:WaitForChild("GiveDrinkEvent")

-- GUI Elements
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "DrinkGiverGUI"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 150)
frame.Position = UDim2.new(0.5, -125, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(0.8, 0, 0.25, 0)
dropdown.Position = UDim2.new(0.1, 0, 0.15, 0)
dropdown.Text = "Select Drink"
dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.Parent = frame

local giveButton = Instance.new("TextButton")
giveButton.Size = UDim2.new(0.6, 0, 0.2, 0)
giveButton.Position = UDim2.new(0.2, 0, 0.6, 0)
giveButton.Text = "Give Drink"
giveButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
giveButton.TextColor3 = Color3.new(1, 1, 1)
giveButton.Parent = frame

-- List of drinks you support
local drinkList = {
    "Atomic Drink",
    "Omega Burp Juice",
    "Thunder Fizz",
    "Garlic Juice",
    
}

-- Dropdown selector (simple popup)
local currentDrink = drinkList[1]
dropdown.Text = currentDrink

dropdown.MouseButton1Click:Connect(function()
	-- Cycle through drinks
	local currentIndex = table.find(drinkList, currentDrink) or 1
	local nextIndex = currentIndex + 1
	if nextIndex > #drinkList then nextIndex = 1 end
	currentDrink = drinkList[nextIndex]
	dropdown.Text = currentDrink
end)

-- Send the selected drink to the server
giveButton.MouseButton1Click:Connect(function()
	if currentDrink then
		giveDrinkEvent:FireServer(currentDrink)
	end
end)
