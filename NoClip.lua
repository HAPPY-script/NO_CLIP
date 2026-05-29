local NoClipGui = Instance.new("ScreenGui")
NoClipGui.Name = "NoClipGui"
NoClipGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NoClipGui.DisplayOrder = 1000
NoClipGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Name = "Frame"
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.Size = UDim2.new(0, 120, 0, 80)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BackgroundTransparency = 0.30000001192092896
Frame.BorderSizePixel = 0
Frame.BorderColor3 = Color3.new(0, 0, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.Transparency = 0.30000001192092896
Frame.Parent = NoClipGui

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 80, 0, 30)
Title.BackgroundColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.BorderSizePixel = 0
Title.BorderColor3 = Color3.new(0, 0, 0)
Title.Transparency = 1
Title.Text = "No clip"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14
Title.FontFace = Font.new("rbxasset://fonts/families/PatrickHand.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
Title.TextScaled = true
Title.TextWrapped = true
Title.Parent = Frame

local UIDragDetector = Instance.new("UIDragDetector")
UIDragDetector.Name = "UIDragDetector"

UIDragDetector.Parent = Frame

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Position = UDim2.new(1, 0, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.BackgroundColor3 = Color3.new(1, 0, 0)
CloseButton.BackgroundTransparency = 0.5
CloseButton.BorderSizePixel = 0
CloseButton.BorderColor3 = Color3.new(0, 0, 0)
CloseButton.AnchorPoint = Vector2.new(1, 0)
CloseButton.Transparency = 0.5
CloseButton.Text = "x"
CloseButton.TextColor3 = Color3.new(1, 1, 1)
CloseButton.TextSize = 14
CloseButton.FontFace = Font.new("rbxasset://fonts/families/ComicNeueAngular.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
CloseButton.TextScaled = true
CloseButton.TextWrapped = true
CloseButton.Parent = Frame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Position = UDim2.new(0.5, 0, 0.9, 0)
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.BackgroundColor3 = Color3.new(1, 0, 0)
ToggleButton.BackgroundTransparency = 0.25
ToggleButton.BorderSizePixel = 0
ToggleButton.BorderColor3 = Color3.new(0, 0, 0)
ToggleButton.AnchorPoint = Vector2.new(0.5, 1)
ToggleButton.Transparency = 0.25
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.TextSize = 14
ToggleButton.FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
ToggleButton.TextScaled = true
ToggleButton.TextWrapped = true
ToggleButton.Parent = Frame

local UICorner = Instance.new("UICorner")
UICorner.Name = "UICorner"
UICorner.CornerRadius = UDim.new(0, 3)
UICorner.Parent = ToggleButton

for _,v in ipairs(NoClipGui:GetDescendants()) do
	if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
		v.TextTransparency = 0
	end
end

-- MAIN SYSTEM =============================================================================================================================--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local gui = player:WaitForChild("PlayerGui"):WaitForChild("NoClipGui")
local frame = gui:WaitForChild("Frame")

local toggleButton = frame:WaitForChild("ToggleButton")
local closeButton = frame:WaitForChild("CloseButton")

local noclipEnabled = false
local noclipConnection

local function setToggle(state)
	noclipEnabled = state

	toggleButton.Text = state and "ON" or "OFF"
	toggleButton.BackgroundColor3 = state
		and Color3.fromRGB(0, 255, 0)
		or Color3.fromRGB(255, 0, 0)
end

local function disableCollision(char)
	for _, v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end
end

local function enableCollision(char)
	for _, v in ipairs(char:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end
end

local function startNoclip()
	if noclipConnection then
		noclipConnection:Disconnect()
	end

	noclipConnection = RunService.Stepped:Connect(function()
		if noclipEnabled and character then
			disableCollision(character)
		end
	end)
end

local function stopNoclip()
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end

	if character then
		enableCollision(character)
	end
end

setToggle(false)

toggleButton.MouseButton1Click:Connect(function()
	setToggle(not noclipEnabled)

	if noclipEnabled then
		startNoclip()
	else
		stopNoclip()
	end
end)

player.CharacterAdded:Connect(function(char)
	character = char

	task.wait(0.5)

	stopNoclip()
	setToggle(false)
end)

closeButton.MouseButton1Click:Connect(function()
	stopNoclip()
	gui:Destroy()
end)
