--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

--// Variables
local activeSpawn = nil
local activeTween = nil

--// THEME COLORS
local Theme = {
	Background = Color3.fromRGB(25, 25, 25),
	Accent = Color3.fromRGB(255, 255, 0),
	Text = Color3.fromRGB(255, 255, 255),
	Button = Color3.fromRGB(40, 40, 40),
	ButtonHover = Color3.fromRGB(60, 60, 60)
}

--// GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpawnSystemUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 200, 0, 120)
Frame.Position = UDim2.new(0.05, 0, 0.4, 0)
Frame.BackgroundColor3 = Theme.Background
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Avery Spawn System"
Title.TextColor3 = Theme.Text
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = Frame

local SetSpawn = Instance.new("TextButton")
SetSpawn.Size = UDim2.new(1, -20, 0, 30)
SetSpawn.Position = UDim2.new(0, 10, 0, 40)
SetSpawn.BackgroundColor3 = Theme.Button
SetSpawn.Text = "Set Spawn"
SetSpawn.TextColor3 = Theme.Text
SetSpawn.Font = Enum.Font.GothamSemibold
SetSpawn.TextScaled = true
SetSpawn.Parent = Frame

local Teleport = Instance.new("TextButton")
Teleport.Size = UDim2.new(1, -20, 0, 30)
Teleport.Position = UDim2.new(0, 10, 0, 80)
Teleport.BackgroundColor3 = Theme.Button
Teleport.Text = "Teleport"
Teleport.TextColor3 = Theme.Text
Teleport.Font = Enum.Font.GothamSemibold
Teleport.TextScaled = true
Teleport.Parent = Frame

--// Button Hover Effect
local function hoverEffect(btn)
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.ButtonHover}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Button}):Play()
	end)
end

hoverEffect(SetSpawn)
hoverEffect(Teleport)

--// Set Spawn Button
SetSpawn.MouseButton1Click:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	activeSpawn = hrp.CFrame
	print("[AverySpawn] Spawn point set.")
end)

--// Teleport Button
Teleport.MouseButton1Click:Connect(function()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	if activeSpawn then
		local tween = TweenService:Create(
			hrp,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{CFrame = activeSpawn}
		)
		tween:Play()
	end
end)

--// Auto Correct Spawn on Character Added
player.CharacterAdded:Connect(function(char)
	local hrp = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:FindFirstChild("Humanoid")
	task.wait(0.5)

	if activeSpawn and hrp then
		local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local tweenGoal = {CFrame = activeSpawn}
		local tween = TweenService:Create(hrp, tweenInfo, tweenGoal)
		activeTween = tween

		local conn
		conn = RunService.RenderStepped:Connect(function()
			if (humanoid and humanoid.MoveDirection.Magnitude > 0) or not activeSpawn then
				tween:Cancel()
				conn:Disconnect()
				activeTween = nil
			end
		end)

		tween:Play()

		tween.Completed:Connect(function()
			if conn then conn:Disconnect() end
			activeTween = nil

			-- 🔹 Second Verification (Failsafe + Flash Effect)
			task.delay(0.3, function()
				if activeSpawn and hrp and (hrp.Position - activeSpawn.Position).Magnitude > 5 then
					local retryTween = TweenService:Create(
						hrp,
						TweenInfo.new(0.2, Enum.EasingStyle.Linear),
						{CFrame = activeSpawn}
					)
					retryTween:Play()

					-- 🟡 Flash (Yellow → Green at Spawn Location)
					local flash = Instance.new("Part")
					flash.Shape = Enum.PartType.Ball
					flash.Color = Color3.fromRGB(255, 255, 0)
					flash.Material = Enum.Material.Neon
					flash.Anchored = true
					flash.CanCollide = false
					flash.Size = Vector3.new(4, 4, 4)
					flash.CFrame = activeSpawn
					flash.Parent = workspace

					local flashTween = TweenService:Create(
						flash,
						TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
						{
							Color = Color3.fromRGB(0, 255, 0),
							Size = Vector3.new(0.5, 0.5, 0.5),
							Transparency = 0.5
						}
					)
					flashTween:Play()

					task.delay(0.6, function()
						flash:Destroy()
					end)

					print("[AverySpawn] ✅ Second verification corrected spawn position.")
				end
			end)
		end)
	end
end)
