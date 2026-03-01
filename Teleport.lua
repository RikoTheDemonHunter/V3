local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TeleportGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 400, 0, 0)
frame.Position = UDim2.new(0.5, -200, 0.5, -150)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Size=UDim2.new(0,400,0,380)}):Play()

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 0, 40)
title.Position = UDim2.new(0,0,0,0)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.Text = "🧭 Teleport to Player"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

-- Buttons
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0,30,0,30)
minimizeButton.Position = UDim2.new(1,-60,0,5)
minimizeButton.Text = "-"
minimizeButton.BackgroundColor3 = Color3.fromRGB(60,60,60)
minimizeButton.TextColor3 = Color3.fromRGB(255,255,255)
minimizeButton.Font = Enum.Font.Gotham
minimizeButton.TextSize = 18
minimizeButton.Parent = frame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,30,0,30)
closeButton.Position = UDim2.new(1,-30,0,5)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(120,20,20)
closeButton.TextColor3 = Color3.fromRGB(255,255,255)
closeButton.Font = Enum.Font.Gotham
closeButton.TextSize = 18
closeButton.Parent = frame

-- Search box
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1,-20,0,30)
searchBox.Position = UDim2.new(0,10,0,45)
searchBox.PlaceholderText = "Search player..."
searchBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
searchBox.TextColor3 = Color3.fromRGB(255,255,255)
searchBox.ClearTextOnFocus = false
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 16
searchBox.Parent = frame

-- Scroll frame
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-10,1,-85)
scroll.Position = UDim2.new(0,5,0,80)
scroll.BackgroundColor3 = Color3.fromRGB(30,30,30)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.Parent = frame

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,5)
layout.Parent = scroll

-- Function to tween teleport
local function tweenTeleport(targetPos)
	local char = LocalPlayer.Character
	if char then
		local hrp = char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local distance = (hrp.Position - targetPos).Magnitude
			local tweenInfo = TweenInfo.new(distance/50, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
			local tween = TweenService:Create(hrp, tweenInfo, {CFrame=CFrame.new(targetPos + Vector3.new(2,0,2))})
			tween:Play()
		end
	end
end

-- Update player list
local function updatePlayerList()
	-- Clear old buttons
	for _, child in pairs(scroll:GetChildren()) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end
	
	local searchText = searchBox.Text:lower()
	
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and (searchText=="" or plr.Name:lower():find(searchText)) then
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-10,0,35)
			btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
			btn.TextColor3 = Color3.fromRGB(200,200,255)
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 15
			btn.TextXAlignment = Enum.TextXAlignment.Left
			btn.Text = "🧍 "..plr.Name
			
			-- Highlight friends (example: use Roblox Friends service if needed)
			if LocalPlayer:IsFriendsWith(plr.UserId) then
				btn.BackgroundColor3 = Color3.fromRGB(60,50,100)
			end
			
			btn.Parent = scroll
			
			btn.MouseEnter:Connect(function()
				btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
			end)
			btn.MouseLeave:Connect(function()
				btn.BackgroundColor3 = LocalPlayer:IsFriendsWith(plr.UserId) and Color3.fromRGB(60,50,100) or Color3.fromRGB(45,45,45)
			end)
			
			btn.MouseButton1Click:Connect(function()
				local targetChar = plr.Character
				if targetChar and targetChar:FindFirstChild("HumanoidRootPart") then
					tweenTeleport(targetChar.HumanoidRootPart.Position)
				end
			end)
		end
	end
	
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
end

-- Update list on join/leave and search
updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
searchBox:GetPropertyChangedSignal("Text"):Connect(updatePlayerList)

-- Minimize/Expand
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	scroll.Visible = not minimized
	searchBox.Visible = not minimized
	local newSize = minimized and UDim2.new(0,400,0,50) or UDim2.new(0,400,0,380)
	TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Sine), {Size=newSize}):Play()
end)

-- Close GUI
closeButton.MouseButton1Click:Connect(function()
	TweenService:Create(frame, TweenInfo.new(0.3), {Size=UDim2.new(0,400,0,0)}):Play()
	task.wait(0.35)
	screenGui:Destroy()
end)
