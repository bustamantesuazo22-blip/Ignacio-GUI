-- IGNACIO GUI V4
-- HEADLESS + FLY + SPEED + JUMP
-- LIQUID GLASS EDITION | Toggle H

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- limpiar GUI previa
pcall(function()
	player.PlayerGui:FindFirstChild("IGNACIO_GUI_V4"):Destroy()
end)

-- ===== GUI =====
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "IGNACIO_GUI_V4"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.36, 0.55)
frame.Position = UDim2.fromScale(0.32, 0.22)
frame.BackgroundColor3 = Color3.fromRGB(25,25,30)
frame.BackgroundTransparency = 0.45
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,22)

-- ===== LIQUID GLASS STYLE =====
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1.5
stroke.Transparency = 0.25
stroke.Color = Color3.fromRGB(180,200,255)

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255,255,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(170,190,255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120,140,200))
})
gradient.Rotation = 90

local shadow = Instance.new("ImageLabel", frame)
shadow.AnchorPoint = Vector2.new(0.5,0.5)
shadow.Position = UDim2.fromScale(0.5,0.5)
shadow.Size = UDim2.fromScale(1.1,1.15)
shadow.BackgroundTransparency = 1
shadow.Image = "rbxassetid://1316045217"
shadow.ImageTransparency = 0.75
shadow.ZIndex = frame.ZIndex - 1

-- ===== TITLE =====
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.1)
title.BackgroundTransparency = 1
title.Text = "IGNACIO GUI V4\nLIQUID GLASS"
title.TextColor3 = Color3.fromRGB(235,240,255)
title.TextScaled = true

-- ===== HELPERS =====
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function getHum()
	return getChar():WaitForChild("Humanoid")
end

local function mkBtn(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.82,0.075)
	b.Position = UDim2.fromScale(0.09,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(70,80,110)
	b.BackgroundTransparency = 0.35
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)

	local s = Instance.new("UIStroke", b)
	s.Thickness = 1
	s.Transparency = 0.4
	s.Color = Color3.fromRGB(200,220,255)

	return b
end

-- ===== HEADLESS =====
local function applyHeadless()
	local head = getChar():FindFirstChild("Head")
	if not head then return end
	head.Transparency = 1
	head.CanCollide = false
	for _,v in pairs(head:GetChildren()) do
		if v:IsA("Decal") then v:Destroy() end
	end
end

local function removeHeadless()
	local head = getChar():FindFirstChild("Head")
	if not head then return end
	head.Transparency = 0
	head.CanCollide = true
end

-- ===== FLY =====
local flying = false
local bv, bg, flyConn
local flySpeed = 60

local function startFly()
	if flying then return end
	flying = true
	local char = getChar()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = getHum()
	hum.PlatformStand = true

	bv = Instance.new("BodyVelocity", hrp)
	bv.MaxForce = Vector3.new(1e9,1e9,1e9)

	bg = Instance.new("BodyGyro", hrp)
	bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
	bg.P = 1e4

	flyConn = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		bg.CFrame = cam.CFrame

		local dir = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += cam.CFrame.UpVector end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= cam.CFrame.UpVector end

		bv.Velocity = (dir.Magnitude > 0 and dir.Unit or Vector3.zero) * flySpeed
	end)
end

local function stopFly()
	if not flying then return end
	flying = false
	if flyConn then flyConn:Disconnect() end
	getHum().PlatformStand = false
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

-- ===== SPEED & JUMP =====
local speed = 16
local jump = 50

local function applyStats()
	local hum = getHum()
	hum.WalkSpeed = speed
	hum.JumpPower = jump
end

-- ===== BUTTONS =====
mkBtn("HEADLESS ON", 0.12).MouseButton1Click:Connect(applyHeadless)
mkBtn("HEADLESS OFF",0.20).MouseButton1Click:Connect(removeHeadless)

mkBtn("FLY ON",0.30).MouseButton1Click:Connect(startFly)
mkBtn("FLY OFF",0.38).MouseButton1Click:Connect(stopFly)

mkBtn("SPEED +",0.48).MouseButton1Click:Connect(function()
	speed = math.min(200, speed + 5); applyStats()
end)

mkBtn("SPEED -",0.56).MouseButton1Click:Connect(function()
	speed = math.max(4, speed - 5); applyStats()
end)

mkBtn("JUMP +",0.66).MouseButton1Click:Connect(function()
	jump = math.min(200, jump + 10); applyStats()
end)

mkBtn("JUMP -",0.74).MouseButton1Click:Connect(function()
	jump = math.max(20, jump - 10); applyStats()
end)

-- ===== RESPAWN =====
player.CharacterAdded:Connect(function()
	task.wait(1)
	applyStats()
	if flying then startFly() end
end)

applyStats()

-- ===== TOGGLE GUI =====
UIS.InputBegan:Connect(function(i,g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.H then
		frame.Visible = not frame.Visible
	end
end)
