-- IGNACIO GUI V4
-- HEADLESS + FLY (LOCAL) | Toggle H

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- limpiar GUI previa
pcall(function()
	player.PlayerGui:FindFirstChild("IGNACIO_GUI_V4"):Destroy()
end)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "IGNACIO_GUI_V4"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.34, 0.36)
frame.Position = UDim2.fromScale(0.33, 0.32)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,18)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1, 0.18)
title.BackgroundTransparency = 1
title.Text = "IGNACIO GUI V4\nHEADLESS + FLY"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true

-- Botones
local function mkBtn(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.8, 0.16)
	b.Position = UDim2.fromScale(0.1, y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	b.TextColor3 = Color3.new(1,1,1)
	b.BorderSizePixel = 0
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	return b
end

local headOn  = mkBtn("HEADLESS ON",  0.22)
local headOff = mkBtn("HEADLESS OFF", 0.40)
local flyOn   = mkBtn("FLY ON",       0.58)
local flyOff  = mkBtn("FLY OFF",      0.76)

-- ===== HEADLESS =====
local function getChar()
	return player.Character or player.CharacterAdded:Wait()
end

local function applyHeadless()
	local char = getChar()
	local head = char:FindFirstChild("Head")
	if not head then return end
	head.Transparency = 1
	head.CanCollide = false
	for _,v in ipairs(head:GetChildren()) do
		if v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		end
	end
end

local function removeHeadless()
	local char = getChar()
	local head = char:FindFirstChild("Head")
	if not head then return end
	head.Transparency = 0
	head.CanCollide = true
end

-- ===== FLY =====
local flying = false
local bv, bg, flyConn
local speed = 60

local function startFly()
	if flying then return end
	flying = true
	local char = getChar()
	local hrp = char:WaitForChild("HumanoidRootPart")
	local hum = char:WaitForChild("Humanoid")
	hum.PlatformStand = true

	bv = Instance.new("BodyVelocity")
	bv.MaxForce = Vector3.new(1e9,1e9,1e9)
	bv.Velocity = Vector3.zero
	bv.Parent = hrp

	bg = Instance.new("BodyGyro")
	bg.MaxTorque = Vector3.new(1e9,1e9,1e9)
	bg.P = 1e4
	bg.CFrame = hrp.CFrame
	bg.Parent = hrp

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

		bv.Velocity = (dir.Magnitude > 0 and dir.Unit or Vector3.zero) * speed
	end)
end

local function stopFly()
	if not flying then return end
	flying = false
	if flyConn then flyConn:Disconnect() end
	local char = getChar()
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then hum.PlatformStand = false end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

-- Clicks
headOn.MouseButton1Click:Connect(function()
	applyHeadless()
	headOn.Text = "HEADLESS ACTIVADO"
end)

headOff.MouseButton1Click:Connect(function()
	removeHeadless()
	headOn.Text = "HEADLESS ON"
end)

flyOn.MouseButton1Click:Connect(function()
	startFly()
	flyOn.Text = "FLY ACTIVADO"
end)

flyOff.MouseButton1Click:Connect(function()
	stopFly()
	flyOn.Text = "FLY ON"
end)

-- Reaplicar en respawn
player.CharacterAdded:Connect(function()
	task.wait(1)
	if headOn.Text ~= "HEADLESS ON" then applyHeadless() end
	if flying then startFly() end
end)

-- Toggle GUI con H
UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.H then
		frame.Visible = not frame.Visible
	end
end)
