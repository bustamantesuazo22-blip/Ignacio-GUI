-- IGNACIO GUI V6.5 🔥 TK V5 ORIGINAL (la que sí funcionaba) + Fling Infinite Yield OP
-- H: abrir/cerrar ventanas | Botón TELEKINESIS activa el modo + abre ventana | Left Click: Agarrar | Right Click: Fling OP infinite

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- LIMPIEZA
pcall(function()
    player.PlayerGui:FindFirstChild("IGNACIO_GUI_V6"):Destroy()
    player.PlayerGui:FindFirstChild("TK_GUI"):Destroy()
end)

-- GUI PRINCIPAL SCROLLABLE
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "IGNACIO_GUI_V6"
gui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.fromScale(0.36, 0.72)
mainFrame.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromScale(0.18, 0.36) -- Centrado
mainFrame.BackgroundTransparency = 1
mainFrame.Active = true
mainFrame.Draggable = true

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.fromScale(1, 1)
scrollFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
scrollFrame.BackgroundTransparency = 0.45
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0,28) -- iOS rounded

local stroke = Instance.new("UIStroke", scrollFrame)
stroke.Thickness = 1.2
stroke.Transparency = 0.15
stroke.Color = Color3.fromRGB(200,220,255) -- Glow realista

local title = Instance.new("TextLabel", scrollFrame)
title.Size = UDim2.fromScale(1,0.08)
title.BackgroundTransparency = 1
title.Text = "IGNACIO GUI V6.5"
title.TextColor3 = Color3.fromRGB(235,240,255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0,8)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function updateCanvas()
    scrollFrame.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 100)
end
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

local function getChar() return player.Character or player.CharacterAdded:Wait() end
local function getHum() return getChar():WaitForChild("Humanoid") end

local function mkBtn(text, callback)
    local b = Instance.new("TextButton", scrollFrame)
    b.Size = UDim2.fromScale(0.82,0.055)
    b.BackgroundColor3 = Color3.fromRGB(70,80,110)
    b.BackgroundTransparency = 0.35
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.TextScaled = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
    if callback then b.MouseButton1Click:Connect(callback) end
    updateCanvas()
    return b
end

-- Blur effect para liquid glass
local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 0

-- HEADLESS TOGGLE
local headlessEnabled = false
local function toggleHeadless()
    local head = getChar():FindFirstChild("Head")
    if not head then return end
    headlessEnabled = not headlessEnabled
    head.Transparency = headlessEnabled and 1 or 0
    head.CanCollide = not headlessEnabled
    if headlessEnabled then
        for _,v in head:GetChildren() do if v:IsA("Decal") then v:Destroy() end end
    end
end

-- FLY TOGGLE
local flying = false
local bv, bg, flyConn
local flySpeed = 60

local function toggleFly()
    flying = not flying
    if flying then
        local hrp = getChar():WaitForChild("HumanoidRootPart")
        getHum().PlatformStand = true
        bv = Instance.new("BodyVelocity", hrp) bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bg = Instance.new("BodyGyro", hrp) bg.MaxTorque = Vector3.new(1e9,1e9,1e9) bg.P = 1e4
        flyConn = RunService.RenderStepped:Connect(function()
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
    else
        if flyConn then flyConn:Disconnect() end
        getHum().PlatformStand = false
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end

-- SPEED / JUMP
local speed, jump = 16, 50
local function applyStats()
    local hum = getHum()
    hum.WalkSpeed = speed
    hum.JumpPower = jump
end

-- ===== SLIDER CON ICONO (ChatGPT style, iconos visibles) =====
local function mkSlider(iconId, text, min, max, start, callback)
    local container = Instance.new("Frame", scrollFrame)
    container.Size = UDim2.fromScale(0.82, 0.085)
    container.BackgroundTransparency = 1

    local icon = Instance.new("ImageLabel", container)
    icon.Size = UDim2.fromScale(0.15, 1)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://" .. iconId
    icon.ScaleType = Enum.ScaleType.Fit

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.fromScale(0.85, 0.45)
    label.Position = UDim2.fromScale(0.15, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Text = text .. " : " .. start

    local slider = Instance.new("Frame", container)
    slider.Size = UDim2.fromScale(0.85, 0.35)
    slider.Position = UDim2.fromScale(0.15, 0.55)
    slider.BackgroundColor3 = Color3.fromRGB(60,60,80)
    Instance.new("UICorner", slider).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame", slider)
    fill.BackgroundColor3 = Color3.fromRGB(200,220,255)
    fill.Size = UDim2.fromScale(0,1)
    fill.BorderSizePixel = 0
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local dragging = false
    local value = start

    local function setValue(alpha)
        alpha = math.clamp(alpha, 0, 1)
        fill.Size = UDim2.fromScale(alpha,1)
        value = math.floor(min + (max - min) * alpha)
        label.Text = text .. " : " .. value
        callback(value)
    end

    slider.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
    end)

    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            local alpha = (i.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            setValue(alpha)
        end
    end)

    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    setValue((start - min) / (max - min))
    updateCanvas()
    return container
end

mkSlider(6026568198, "SPEED", 4, 200, speed, function(v) speed = v applyStats() end)
mkSlider(6026568198, "JUMP", 20, 200, jump, function(v) jump = v applyStats() end)
mkSlider(6026568198, "FLY SPEED", 30, 200, flySpeed, function(v) flySpeed = v end)

-- TK V5 ORIGINAL
local tkGui = Instance.new("ScreenGui", player.PlayerGui)
tkGui.Name = "TK_GUI"
tkGui.ResetOnSpawn = false
tkGui.Enabled = false

local tkFrame = Instance.new("Frame", tkGui)
tkFrame.Size = UDim2.fromScale(0.32,0.22)
tkFrame.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromScale(0.16, 0.11) -- Centrado
tkFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
tkFrame.BackgroundTransparency = 0.45
tkFrame.Draggable = true
Instance.new("UICorner", tkFrame).CornerRadius = UDim.new(0,28)

local tkTitle = Instance.new("TextLabel", tkFrame)
tkTitle.Size = UDim2.fromScale(1,0.35)
tkTitle.BackgroundTransparency = 1
tkTitle.Text = "TELEKINESIS V5\nLeft Click: Agarrar\nRight Click: Fling Infinite Yield"
tkTitle.TextColor3 = Color3.fromRGB(235,240,255)
tkTitle.TextScaled = true

local eye = Instance.new("TextLabel", tkGui)
eye.Size = UDim2.fromScale(0.04,0.07)
eye.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromScale(0.02, 0.035) -- Centrado
eye.BackgroundTransparency = 1
eye.Text = "👁"
eye.TextScaled = true
eye.Visible = false

local tkEnabled = false
local ghost, tkConn
local holdDist = 12
local grabbedPart = nil

local function getTarget()
    local p = RaycastParams.new()
    p.FilterDescendantsInstances = {player.Character}
    p.FilterType = Enum.RaycastFilterType.Blacklist
    local r = workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector*40, p)
    return r and r.Instance
end

local function tkRelease()
    if tkConn then tkConn:Disconnect() tkConn=nil end
    eye.Visible = false
    if ghost then ghost:Destroy() ghost = nil end
    grabbedPart = nil
end

local function tkStart()
    local part = getTarget()
    if not part or not part:IsA("BasePart") then return end
    grabbedPart = part
    ghost = part:Clone()
    ghost.Anchored = true
    ghost.CanCollide = false
    ghost.Transparency = 0.6
    ghost.Parent = workspace
    eye.Visible = true

    tkConn = RunService.RenderStepped:Connect(function()
        ghost.CFrame = CFrame.new(cam.CFrame.Position + cam.CFrame.LookVector * holdDist)
    end)
end

UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if tkEnabled then
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            if grabbedPart then
                tkRelease()
            else
                tkStart()
            end
        end
        if i.UserInputType == Enum.UserInputType.MouseButton2 then
            if grabbedPart then
                tkRelease()
                local bv = Instance.new("BodyVelocity", grabbedPart)
                bv.MaxForce = Vector3.new(1e9,1e9,1e9)
                local flingConn = RunService.Heartbeat:Connect(function()
                    if grabbedPart and grabbedPart.Parent then
                        grabbedPart.Velocity = cam.CFrame.LookVector * 650 + Vector3.new(0,220,0)
                        grabbedPart.RotVelocity = Vector3.new(400,800,300)
                    end
                end)
                task.delay(2.5, function() flingConn:Disconnect() end)
            end
        end
    end
end)

-- BOTONES
mkBtn("HEADLESS TOGGLE", toggleHeadless)
mkBtn("FLY TOGGLE", toggleFly)
mkBtn("ESP PLAYERS TOGGLE", toggleESP)
mkBtn("TELEKINESIS", function()
    tkEnabled = not tkEnabled
    tkGui.Enabled = tkEnabled  -- Abre ventana cuando se activa
    if not tkEnabled then tkRelease() end
end)
mkBtn("MM2 - ThunderHubX", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Roman34296589/SnapSanixHUB/refs/heads/main/SnapSanixHUB.lua'))()
end)

-- SCROLL
local dragging = false
local lastY = 0
UIS.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true lastY = i.Position.Y end
end)
UIS.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UIS.InputChanged:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseWheel then scrollFrame.CanvasPosition += Vector2.new(0, -i.Position.Z * 60) end
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = lastY - i.Position.Y
        scrollFrame.CanvasPosition += Vector2.new(0, delta * 2)
        lastY = i.Position.Y
    end
end)

-- TOGGLE H
UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.H then
        local vis = not mainFrame.Visible
        mainFrame.Visible = vis
        tkGui.Enabled = vis
        blur.Size = vis and 16 or 0
    end
end)

player.CharacterAdded:Connect(function()
    task.wait(1)
    applyStats()
end)

applyStats()
print("IGNACIO GUI V6.5 lista | Botón TELEKINESIS activa el modo + abre ventana | TK persiste aunque cierres con H")