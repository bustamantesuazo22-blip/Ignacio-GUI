-- IGNACIO GUI V7.1 🪼🪐
-- arreglo del fling y fly para celu
-- UPDATE: El panel de Telequinesis ahora no se cierra con el gui btw

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- ==========================================
-- 1. DETECCIÓN DE PLATAFORMA
-- ==========================================
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
-- Nota: Si juegas en PC con pantalla táctil, mantendrá controles de PC si hay teclado.

-- ==========================================
-- 2. LIMPIEZA SEGURA
-- ==========================================
pcall(function()
    local oldGui = player.PlayerGui:FindFirstChild("IGNACIO_GUI_V7") or CoreGui:FindFirstChild("IGNACIO_GUI_V7")
    if oldGui then oldGui:Destroy() end
    local oldTk = player.PlayerGui:FindFirstChild("TK_GUI") or CoreGui:FindFirstChild("TK_GUI")
    if oldTk then oldTk:Destroy() end
    local oldMobile = player.PlayerGui:FindFirstChild("MOBILE_CONTROLS") or CoreGui:FindFirstChild("MOBILE_CONTROLS")
    if oldMobile then oldMobile:Destroy() end
    for _, v in pairs(game:GetService("Lighting"):GetChildren()) do
        if v.Name == "IGNACIO_BLUR" then v:Destroy() end
    end
end)

-- ==========================================
-- 3. CREACIÓN DE GUIS PRINCIPALES
-- ==========================================
local gui = Instance.new("ScreenGui")
gui.Name = "IGNACIO_GUI_V7"
gui.ResetOnSpawn = false
pcall(function() gui.Parent = CoreGui end)
if not gui.Parent then gui.Parent = player.PlayerGui end

-- Contenedor Principal
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = isMobile and UDim2.fromScale(0.45, 0.65) or UDim2.fromScale(0.36, 0.72)
mainFrame.Position = isMobile and UDim2.fromScale(0.5, 0.5) - UDim2.fromScale(0.225, 0.325) or UDim2.fromScale(0.5, 0.5) - UDim2.fromScale(0.18, 0.36)
mainFrame.BackgroundTransparency = 1
mainFrame.Active = true
mainFrame.Draggable = true

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.fromScale(1, 1)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
scrollFrame.BackgroundTransparency = 0.35
scrollFrame.ScrollBarThickness = 6
Instance.new("UICorner", scrollFrame).CornerRadius = UDim.new(0, 20)
local stroke = Instance.new("UIStroke", scrollFrame)
stroke.Thickness = 1.5
stroke.Transparency = 0.1
stroke.Color = Color3.fromRGB(150, 180, 255)

local title = Instance.new("TextLabel", scrollFrame)
title.Size = UDim2.fromScale(1, 0.08)
title.BackgroundTransparency = 1
title.Text = isMobile and "IGNACIO V7 (MOBILE)" or "IGNACIO V7 (PC)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack

local listLayout = Instance.new("UIListLayout", scrollFrame)
listLayout.Padding = UDim.new(0, 10)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function updateCanvas()
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 100)
end
listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

-- Blur
local blur = Instance.new("BlurEffect", game.Lighting)
blur.Name = "IGNACIO_BLUR"
blur.Size = 16 -- Empieza visible

-- ==========================================
-- 4. UTILIDADES & CONTROLES TÁCTILES EXTRA
-- ==========================================
local mobileControls = Instance.new("ScreenGui")
mobileControls.Name = "MOBILE_CONTROLS"
mobileControls.ResetOnSpawn = false
pcall(function() mobileControls.Parent = CoreGui end)
if not mobileControls.Parent then mobileControls.Parent = player.PlayerGui end

-- Botón para abrir/cerrar en móvil
local toggleBtn = nil
if isMobile then
    toggleBtn = Instance.new("TextButton", mobileControls)
    toggleBtn.Size = UDim2.fromOffset(50, 50)
    toggleBtn.Position = UDim2.new(0, 10, 0.5, -25)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    toggleBtn.Text = "🔥"
    toggleBtn.TextScaled = true
    toggleBtn.BackgroundTransparency = 0.5
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)
    toggleBtn.Active = true
    toggleBtn.Draggable = true
end

-- Funciones del personaje
local function getChar() return player.Character or player.CharacterAdded:Wait() end
local function getHum() return getChar():WaitForChild("Humanoid") end
local function getHRP() return getChar():WaitForChild("HumanoidRootPart") end

-- Sistema de botones del GUI
local function mkBtn(text, callback)
    local b = Instance.new("TextButton", scrollFrame)
    b.Size = UDim2.fromScale(0.85, 0.06)
    b.BackgroundColor3 = Color3.fromRGB(50, 60, 90)
    b.BackgroundTransparency = 0.2
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.TextScaled = true
    b.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    if callback then b.MouseButton1Click:Connect(callback) end
    updateCanvas()
    return b
end

-- ==========================================
-- 5. LÓGICA DE FUNCIONES
-- ==========================================

-- HEADLESS
local headlessEnabled = false
local function toggleHeadless()
    local head = getChar():FindFirstChild("Head")
    if not head then return end
    headlessEnabled = not headlessEnabled
    head.Transparency = headlessEnabled and 1 or 0
    local face = head:FindFirstChildOfClass("Decal")
    if face then face.Transparency = headlessEnabled and 1 or 0 end
end

-- ESP
local espEnabled = false
local espLoop
local function toggleESP()
    espEnabled = not espEnabled
    if espEnabled then
        espLoop = RunService.RenderStepped:Connect(function()
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and not p.Character:FindFirstChild("IGNACIO_ESP") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "IGNACIO_ESP"
                    hl.FillColor = Color3.fromRGB(255, 50, 50)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.Parent = p.Character
                end
            end
        end)
    else
        if espLoop then espLoop:Disconnect() end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("IGNACIO_ESP")
                if hl then hl:Destroy() end
            end
        end
    end
end

-- FLY ADAPTATIVO (PC + MÓVIL)
local flying = false
local bvFly, bgFly, flyConn
local flySpeed = 60
local mobileFlyUp, mobileFlyDown = false, false

-- Botones de Fly en Móvil
local btnFlyUp, btnFlyDown
if isMobile then
    btnFlyUp = Instance.new("TextButton", mobileControls)
    btnFlyUp.Size = UDim2.fromOffset(60, 60)
    btnFlyUp.Position = UDim2.new(1, -80, 0.5, -70)
    btnFlyUp.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btnFlyUp.BackgroundTransparency = 0.5
    btnFlyUp.Text = "⬆️"
    btnFlyUp.TextScaled = true
    btnFlyUp.Visible = false
    Instance.new("UICorner", btnFlyUp).CornerRadius = UDim.new(1,0)
    
    btnFlyDown = btnFlyUp:Clone()
    btnFlyDown.Parent = mobileControls
    btnFlyDown.Position = UDim2.new(1, -80, 0.5, 10)
    btnFlyDown.Text = "⬇️"
    
    btnFlyUp.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then mobileFlyUp = true end end)
    btnFlyUp.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then mobileFlyUp = false end end)
    btnFlyDown.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then mobileFlyDown = true end end)
    btnFlyDown.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.Touch then mobileFlyDown = false end end)
end

local function toggleFly()
    flying = not flying
    if isMobile and btnFlyUp and btnFlyDown then
        btnFlyUp.Visible = flying
        btnFlyDown.Visible = flying
    end
    
    if flying then
        local hrp = getHRP()
        local hum = getHum()
        hum.PlatformStand = true
        bvFly = Instance.new("BodyVelocity", hrp) 
        bvFly.MaxForce = Vector3.new(1e9,1e9,1e9)
        bgFly = Instance.new("BodyGyro", hrp) 
        bgFly.MaxTorque = Vector3.new(1e9,1e9,1e9) 
        bgFly.P = 1e4
        
        flyConn = RunService.RenderStepped:Connect(function()
            bgFly.CFrame = cam.CFrame
            local dir = Vector3.zero
            
            if isMobile then
                -- El thumbstick de móvil actualiza hum.MoveDirection automáticamente!
                dir = hum.MoveDirection
                if mobileFlyUp then dir += Vector3.new(0, 1, 0) end
                if mobileFlyDown then dir -= Vector3.new(0, 1, 0) end
            else
                -- PC Controls
                if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += cam.CFrame.UpVector end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= cam.CFrame.UpVector end
            end
            
            bvFly.Velocity = (dir.Magnitude > 0 and dir.Unit or Vector3.zero) * flySpeed
        end)
    else
        if flyConn then flyConn:Disconnect() end
        getHum().PlatformStand = false
        if bvFly then bvFly:Destroy() end
        if bgFly then bgFly:Destroy() end
    end
end

-- ==========================================
-- 6. SLIDERS (TÁCTIL Y RATÓN)
-- ==========================================
local speed, jump = 16, 50
local function applyStats()
    local hum = getHum()
    hum.WalkSpeed = speed
    hum.JumpPower = jump
    hum.UseJumpPower = true
end

local function mkSlider(text, min, max, start, callback)
    local container = Instance.new("Frame", scrollFrame)
    container.Size = UDim2.fromScale(0.85, 0.08)
    container.BackgroundTransparency = 1

    local label = Instance.new("TextLabel", container)
    label.Size = UDim2.fromScale(1, 0.45)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.Text = text .. " : " .. start

    local slider = Instance.new("Frame", container)
    slider.Size = UDim2.fromScale(1, 0.35)
    slider.Position = UDim2.fromScale(0, 0.55)
    slider.BackgroundColor3 = Color3.fromRGB(40,40,60)
    Instance.new("UICorner", slider).CornerRadius = UDim.new(1,0)

    local fill = Instance.new("Frame", slider)
    fill.BackgroundColor3 = Color3.fromRGB(150, 180, 255)
    fill.Size = UDim2.fromScale(0,1)
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
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            dragging = true 
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local alpha = (i.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
            setValue(alpha)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            dragging = false 
        end
    end)

    setValue((start - min) / (max - min))
    updateCanvas()
end

mkSlider("WALK SPEED", 16, 200, speed, function(v) speed = v applyStats() end)
mkSlider("JUMP POWER", 50, 200, jump, function(v) jump = v applyStats() end)
mkSlider("FLY SPEED", 30, 200, flySpeed, function(v) flySpeed = v end)

-- ==========================================
-- 7. TELEQUINESIS Y FLING (PC & MOBILE)
-- ==========================================
local tkGui = Instance.new("ScreenGui")
tkGui.Name = "TK_GUI"
tkGui.ResetOnSpawn = false
tkGui.Enabled = false
pcall(function() tkGui.Parent = CoreGui end)
if not tkGui.Parent then tkGui.Parent = player.PlayerGui end

local tkFrame = Instance.new("Frame", tkGui)
tkFrame.Size = isMobile and UDim2.fromScale(0.4, 0.35) or UDim2.fromScale(0.3, 0.25)
tkFrame.Position = isMobile and UDim2.fromScale(0.5, 0.9) - UDim2.fromScale(0.2, 0.35) or UDim2.fromScale(0.5, 0.8) - UDim2.fromScale(0.15, 0.25)
tkFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
tkFrame.BackgroundTransparency = 0.2
tkFrame.Active = true
tkFrame.Draggable = true
Instance.new("UICorner", tkFrame).CornerRadius = UDim.new(0,20)
Instance.new("UIStroke", tkFrame).Color = Color3.fromRGB(255, 50, 50)

local tkTitle = Instance.new("TextLabel", tkFrame)
tkTitle.Size = UDim2.fromScale(1, 0.25)
tkTitle.BackgroundTransparency = 1
tkTitle.Text = "🔮 TK V5 OP"
tkTitle.TextColor3 = Color3.fromRGB(255,100,100)
tkTitle.TextScaled = true
tkTitle.Font = Enum.Font.GothamBold

-- Crosshair (Punto en el centro de la pantalla para apuntar mejor en Móvil)
local crosshair = Instance.new("Frame", tkGui)
crosshair.Size = UDim2.fromOffset(6, 6)
crosshair.Position = UDim2.fromScale(0.5, 0.5) - UDim2.fromOffset(3, 3)
crosshair.BackgroundColor3 = Color3.new(1, 0, 0)
Instance.new("UICorner", crosshair).CornerRadius = UDim.new(1, 0)
crosshair.Visible = false

local tkEnabled = false
local ghost, tkConn
local holdDist = 12
local grabbedPart = nil

-- Raycast desde el centro de la pantalla (Perfecto para táctil y PC)
local function getTarget()
    local viewportSize = cam.ViewportSize
    local ray = cam:ViewportPointToRay(viewportSize.X/2, viewportSize.Y/2)
    local p = RaycastParams.new()
    p.FilterDescendantsInstances = {player.Character}
    p.FilterType = Enum.RaycastFilterType.Blacklist
    local r = workspace:Raycast(ray.Origin, ray.Direction * 400, p)
    return r and r.Instance
end

local function tkRelease()
    if tkConn then tkConn:Disconnect() tkConn=nil end
    if ghost then ghost:Destroy() ghost = nil end
    grabbedPart = nil
end

local function tkStart()
    local part = getTarget()
    if not part or not part:IsA("BasePart") then return end
    grabbedPart = part
    ghost = part:Clone()
    ghost:ClearAllChildren()
    ghost.Anchored = true
    ghost.CanCollide = false
    ghost.Transparency = 0.6
    ghost.Material = Enum.Material.ForceField
    ghost.Parent = workspace

    tkConn = RunService.RenderStepped:Connect(function()
        ghost.CFrame = CFrame.new(cam.CFrame.Position + cam.CFrame.LookVector * holdDist)
    end)
end

local function executeFling()
    if not grabbedPart then return end
    local target = grabbedPart
    tkRelease()
    if target.Anchored then return end

    local char = getChar()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local oldPos = hrp.CFrame
    
    local bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    local bav = Instance.new("BodyAngularVelocity")
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.AngularVelocity = Vector3.new(0, 999999, 0)
    bav.Parent = hrp

    local noclip = RunService.Stepped:Connect(function()
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)

    local startTime = tick()
    local flingLoop
    flingLoop = RunService.Heartbeat:Connect(function()
        if tick() - startTime > 1 or not target or not target.Parent then
            flingLoop:Disconnect()
            noclip:Disconnect()
            if bv then bv:Destroy() end
            if bav then bav:Destroy() end
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
            hrp.Velocity = Vector3.zero
            hrp.CFrame = oldPos
            return
        end
        hrp.CFrame = target.CFrame
    end)
end

-- Botones Físicos en el Panel TK (Sustituye los clics de PC para dar soporte total a Móvil)
local btnGrab = Instance.new("TextButton", tkFrame)
btnGrab.Size = UDim2.fromScale(0.4, 0.3)
btnGrab.Position = UDim2.fromScale(0.05, 0.3)
btnGrab.Text = "AGARRAR (Mira)"
btnGrab.TextScaled = true
btnGrab.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
Instance.new("UICorner", btnGrab).CornerRadius = UDim.new(0, 8)
btnGrab.MouseButton1Click:Connect(function() if grabbedPart then tkRelease() else tkStart() end end)

local btnDrop = Instance.new("TextButton", tkFrame)
btnDrop.Size = UDim2.fromScale(0.4, 0.3)
btnDrop.Position = UDim2.fromScale(0.55, 0.3)
btnDrop.Text = "SOLTAR"
btnDrop.TextScaled = true
btnDrop.BackgroundColor3 = Color3.fromRGB(150, 150, 50)
Instance.new("UICorner", btnDrop).CornerRadius = UDim.new(0, 8)
btnDrop.MouseButton1Click:Connect(tkRelease)

local btnFling = Instance.new("TextButton", tkFrame)
btnFling.Size = UDim2.fromScale(0.9, 0.3)
btnFling.Position = UDim2.fromScale(0.05, 0.65)
btnFling.Text = "🔥 FLING TARGET 🔥"
btnFling.TextScaled = true
btnFling.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Instance.new("UICorner", btnFling).CornerRadius = UDim.new(0, 8)
btnFling.MouseButton1Click:Connect(executeFling)

-- Mantener Shortcuts de PC por si acaso
if not isMobile then
    UIS.InputBegan:Connect(function(i,g)
        if g or not tkEnabled then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            if grabbedPart then tkRelease() else tkStart() end
        elseif i.UserInputType == Enum.UserInputType.MouseButton2 then
            executeFling()
        end
    end)
end

-- ==========================================
-- 8. BOTONES PRINCIPALES
-- ==========================================
mkBtn("HEADLESS TOGGLE", toggleHeadless)
mkBtn("FLY TOGGLE", toggleFly)
mkBtn("ESP PLAYERS TOGGLE", toggleESP)
mkBtn("TELEKINESIS + FLING PANEL", function()
    tkEnabled = not tkEnabled
    tkGui.Enabled = tkEnabled
    crosshair.Visible = tkEnabled
    if not tkEnabled then tkRelease() end
end)
mkBtn("MM2 - ThunderHubX", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Roman34296589/SnapSanixHUB/refs/heads/main/SnapSanixHUB.lua'))()
end)

-- ==========================================
-- 9. SISTEMA DE APERTURA (H PARA PC, BOTÓN PARA MÓVIL)
-- ==========================================
local function toggleUI()
    local vis = not mainFrame.Visible
    mainFrame.Visible = vis
    
    -- ¡ELIMINAMOS LA CONEXIÓN ENTRE EL MENÚ PRINCIPAL Y EL TK GUI!
    -- Ahora el tkGui y el crosshair solo se apagan si le das al botón de "TELEKINESIS + FLING PANEL".
    
    blur.Size = vis and 16 or 0
end

if isMobile and toggleBtn then
    toggleBtn.MouseButton1Click:Connect(toggleUI)
else
    UIS.InputBegan:Connect(function(i,g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.H then toggleUI() end
    end)
end

player.CharacterAdded:Connect(function()
    task.wait(1)
    applyStats()
end)

applyStats()
print("IGNACIO GUI V7.1 Cargado | Plataforma: " .. (isMobile and "MÓVIL" or "PC"))
