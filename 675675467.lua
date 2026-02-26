--[[
    ====================================================================================================
                                      🐙 PULPI GUI V12.0 TITAN EDITION 🐙
                                       DESARROLLADOR: PulpoNot_Found
    ====================================================================================================
    [NOVEDADES V12.0 - TITAN EDITION]
    - SISTEMA LOGGER: Ahora envía una notificación push a Discord mediante Webhook al ejecutar.
    - NUEVO TOXIC HUNTER: Lista de jugadores interactiva. Haz clic en un nombre y el Fling en bucle 
      comienza al instante. No más escribir nombres.
    - ANTI-KAMIKAZE FLING: El script ahora suspende tu personaje en el aire con BodyVelocity si
      la víctima muere, evitando que caigas al vacío con ella.
    - SISTEMA DE IDIOMAS Y GUARDADO: Tu configuración se guarda automáticamente en JSON.
    - ESTÉTICA WINDOWS 11: Monocromática, limpia, con botones de minimizar y auto-escala.
    ====================================================================================================
]]

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local cam = Workspace.CurrentCamera
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- ==========================================
-- [ SECCIÓN LOGGER: PUSH NOTIFICATION ]
-- ==========================================
local function enviarNotificacionPush()
    local webhookURL = "https://discord.com/api/webhooks/1476366286689931396/-xQahRx-mm5LhpCh68Bl9AoSB4RBiUP4f6xqo1ptFAC0HOZMJsVSd_SPCAyjPakj_g0I" -- <--- PEGA AQUÍ TU URL DE DISCORD
    
    local gameName = "Desconocido"
    pcall(function()
        gameName = MarketplaceService:GetProductInfo(game.PlaceId).Name
    end)

    local data = {
        ["content"] = nil,
        ["embeds"] = {{
            ["title"] = "🐙 **PULPI GUI V12 - NUEVA EJECUCIÓN**",
            ["description"] = "Se ha detectado una ejecución del script.",
            ["color"] = 0, -- Negro Titan
            ["fields"] = {
                {["name"] = "👤 Jugador", ["value"] = player.Name .. " (@" .. player.DisplayName .. ")", ["inline"] = true},
                {["name"] = "🆔 User ID", ["value"] = "["..player.UserId.."](https://www.roblox.com/users/"..player.UserId.."/profile)", ["inline"] = true},
                {["name"] = "🎮 Juego", ["value"] = gameName .. " ("..game.PlaceId..")", ["inline"] = false},
                {["name"] = "📱 Dispositivo", ["value"] = isMobile and "Móvil" or "PC", ["inline"] = true},
                {["name"] = "🔗 Servidor ID", ["value"] = "```"..game.JobId.."```", ["inline"] = false}
            },
            ["footer"] = {["text"] = "Pulpi GUI Logger System • V12.0"},
            ["timestamp"] = DateTime.now():ToIsoDate()
        }}
    }

    pcall(function()
        local request = syn and syn.request or http_request or request or http and http.request
        if request then
            request({
                Url = webhookURL,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = HttpService:JSONEncode(data)
            })
        end
    end)
end

enviarNotificacionPush() -- Ejecutar logger al inicio

-- ==========================================
-- [ RESTO DEL SCRIPT ]
-- ==========================================

-- Variables de estado
local menuOpen = false

-- Estados de módulos (Guardado JSON)
local SavedConfig = {
    Lang = "es",
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 65,
    RingRadius = 50,
    FlyActive = false,
    ESPActive = false,
    HeadlessActive = false
}

-- Estados Volátiles
local ringActive = false
local tkPanelActive = false
local huntPanelActive = false
local headlessCache = {}

local connections = {fly = nil, ring = nil, esp = nil, tk = nil, hunt = nil, huntNoclip = nil}

-- ==========================================
-- [ SECCIÓN 0: AUTO-EXECUTE (NO FALL DAMAGE FE) ]
-- ==========================================
task.spawn(function()
    if game.PlaceId == 189707 then
        pcall(function() setclipboard("https://discord.gg/ypjMw5xmuj") end)
        local z = Vector3.zero
        local function preventFallDamage(c)
            local r = c:WaitForChild("HumanoidRootPart")
            if r then
                local con
                con = RunService.Heartbeat:Connect(function()
                    if not r.Parent then con:Disconnect() return end
                    local v = r.AssemblyLinearVelocity
                    r.AssemblyLinearVelocity = z
                    RunService.RenderStepped:Wait()
                    r.AssemblyLinearVelocity = v
                end)
            end
        end
        preventFallDamage(player.Character or player.CharacterAdded:Wait())
        player.CharacterAdded:Connect(preventFallDamage)
    end
end)

-- ==========================================
-- [ SECCIÓN 1: SISTEMA DE GUARDADO PERSISTENTE (JSON) ]
-- ==========================================
local ConfigPath = "PULPI_GUI/Config_V12.json"

local function SaveData()
    pcall(function()
        if not isfolder("PULPI_GUI") then makefolder("PULPI_GUI") end
        writefile(ConfigPath, HttpService:JSONEncode(SavedConfig))
    end)
end

local function LoadData()
    pcall(function()
        if isfile(ConfigPath) then
            local decoded = HttpService:JSONDecode(readfile(ConfigPath))
            if decoded then
                for k, v in pairs(decoded) do
                    SavedConfig[k] = v
                end
            end
        end
    end)
end

LoadData()

-- Diccionario de Idiomas
local LangData = {
    es = {
        LangTitle = "Selecciona tu Idioma",
        MadeBy = "Hecho por PulpoNot_Found",
        WelcomeM = "Bienvenido, ",
        WelcomeF = "Bienvenida, ",
        Hello = "Hola, ",
        MenuTitle = "PULPI V12",
        TkTitle = "🔮 PANEL FLING",
        HuntTitle = "🪐 TOXIC HUNTER 🔪",
        Speed = "VELOCIDAD",
        Jump = "SALTO",
        FlySpeed = "VUELO",
        Radius = "RADIO",
        Headless = "FE HEADLESS",
        FlyBtn = "VOLAR",
        EspBtn = "ESP (BLANCO)",
        TornadoBtn = "TORNADO",
        FlingMenuBtn = "PANEL FLING",
        HuntMenuBtn = "TOXIC HUNTER 🪐",
        GrabBtn = "AGARRAR (MIRA)",
        DropBtn = "SOLTAR",
        FlingShoot = "🔥 ¡FLING! 🔥",
        RefreshList = "🔄 REFRESCAR LISTA",
        StopHunt = "🟢 DETENER CAZA"
    },
    en = {
        LangTitle = "Select your Language",
        MadeBy = "Made by PulpoNot_Found",
        WelcomeM = "Welcome, ",
        WelcomeF = "Welcome, ",
        Hello = "Hello, ",
        MenuTitle = "PULPI V12",
        TkTitle = "🔮 FLING PANEL",
        Speed = "SPEED",
        Jump = "JUMP",
        FlySpeed = "FLY SPD",
        Radius = "RADIUS",
        Headless = "FE HEADLESS",
        FlyBtn = "FLY",
        EspBtn = "ESP (WHITE)",
        TornadoBtn = "TORNADO",
        FlingMenuBtn = "FLING PANEL",
        HuntMenuBtn = "TOXIC HUNTER 🪐",
        GrabBtn = "GRAB (AIM)",
        DropBtn = "DROP",
        FlingShoot = "🔥 FLING! 🔥",
        RefreshList = "🔄 REFRESH LIST",
        StopHunt = "🟢 STOP HUNT"
    }
}

local function T(key)
    return LangData[SavedConfig.Lang][key] or key
end

-- ==========================================
-- [ SECCIÓN 2: CONFIGURACIÓN VISUAL ADAPTATIVA Y DRAGGABLE ]
-- ==========================================
local UIConfig = {}
if isMobile then
    UIConfig.Type = "Frame"
    UIConfig.MainSize = UDim2.fromScale(0.65, 0.60)
    UIConfig.MinSize = UDim2.fromScale(0.65, 0.15)
    UIConfig.BtnSize = UDim2.fromScale(0.92, 0.12)
    UIConfig.SliderContSize = UDim2.fromScale(0.92, 0.14)
    UIConfig.SliderTrackSize = UDim2.fromScale(1, 0.15) 
    UIConfig.TkSize = UDim2.fromScale(0.48, 0.45)
    UIConfig.HuntSize = UDim2.fromScale(0.55, 0.60)
    UIConfig.TkMinSize = UDim2.fromScale(0.48, 0.15)
    UIConfig.ScrollThick = 4
else
    UIConfig.Type = "CanvasGroup"
    UIConfig.MainSize = UDim2.fromScale(0.35, 0.70)
    UIConfig.MinSize = UDim2.fromScale(0.35, 0.1)
    UIConfig.BtnSize = UDim2.fromScale(0.85, 0.07)
    UIConfig.SliderContSize = UDim2.fromScale(0.85, 0.10)
    UIConfig.SliderTrackSize = UDim2.fromScale(1, 0.30)
    UIConfig.TkSize = UDim2.fromScale(0.30, 0.35)
    UIConfig.HuntSize = UDim2.fromScale(0.35, 0.60)
    UIConfig.TkMinSize = UDim2.fromScale(0.30, 0.1)
    UIConfig.ScrollThick = 0
end

local function makeDraggable(guiObject)
    local dragging, dragInput, dragStart, startPos
    guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    guiObject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function applyMinimizeSystem(frame, normalSize, minSize, contentToHide)
    local minBtn = Instance.new("TextButton", frame)
    minBtn.Size = UDim2.fromOffset(30, 30)
    minBtn.Position = UDim2.new(1, -35, 0, 5)
    minBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.new(1,1,1)
    minBtn.Font = Enum.Font.GothamBold
    minBtn.TextScaled = true
    Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
    
    local isMinimized = false
    minBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        minBtn.Text = isMinimized and "+" or "-"
        contentToHide.Visible = not isMinimized
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), { Size = isMinimized and minSize or normalSize }):Play()
    end)
end

pcall(function()
    local oldGUIs = {"PULPI_GUI_V12", "PULPI_GUI_V11_6", "TK_GUI_V11", "HUNT_GUI_V12", "MOBILE_CONTROLS", "PULPO_INTRO", "LANG_SELECTOR"}
    for _, name in pairs(oldGUIs) do
        local obj = CoreGui:FindFirstChild(name) or player.PlayerGui:FindFirstChild(name)
        if obj then obj:Destroy() end
    end
    for _, obj in pairs(Lighting:GetChildren()) do
        if obj.Name == "PULPI_BLUR" then obj:Destroy() end
    end
end)

local targetParent = (pcall(function() return CoreGui.Name end)) and CoreGui or player.PlayerGui

-- ==========================================
-- [ SECCIÓN 3: PANTALLA DE SELECCIÓN DE IDIOMA ]
-- ==========================================
local function showLangSelector(callback)
    local langGui = Instance.new("ScreenGui", targetParent)
    langGui.Name = "LANG_SELECTOR"
    langGui.IgnoreGuiInset = true
    langGui.DisplayOrder = 10000
    
    local bg = Instance.new("Frame", langGui)
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    bg.BackgroundTransparency = 0.3
    
    local panel = Instance.new("Frame", bg)
    panel.Size = isMobile and UDim2.fromScale(0.6, 0.4) or UDim2.fromScale(0.3, 0.35)
    panel.Position = UDim2.fromScale(0.5, 0.5)
    panel.AnchorPoint = Vector2.new(0.5, 0.5)
    panel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 16)
    
    local title = Instance.new("TextLabel", panel)
    title.Size = UDim2.fromScale(1, 0.3)
    title.BackgroundTransparency = 1
    title.Text = "Language / Idioma"
    title.TextColor3 = Color3.new(1,1,1)
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    
    local btnEs = Instance.new("TextButton", panel)
    btnEs.Size = UDim2.fromScale(0.8, 0.25)
    btnEs.Position = UDim2.fromScale(0.1, 0.35)
    btnEs.BackgroundColor3 = Color3.fromRGB(50, 60, 100)
    btnEs.Text = "🇪🇸 Español"
    btnEs.TextColor3 = Color3.new(1,1,1)
    btnEs.Font = Enum.Font.GothamBold
    btnEs.TextScaled = true
    Instance.new("UICorner", btnEs)
    
    local btnEn = Instance.new("TextButton", panel)
    btnEn.Size = UDim2.fromScale(0.8, 0.25)
    btnEn.Position = UDim2.fromScale(0.1, 0.65)
    btnEn.BackgroundColor3 = Color3.fromRGB(50, 60, 100)
    btnEn.Text = "🇺🇸 English"
    btnEn.TextColor3 = Color3.new(1,1,1)
    btnEn.Font = Enum.Font.GothamBold
    btnEn.TextScaled = true
    Instance.new("UICorner", btnEn)

    local function finalizeSelection(lang)
        SavedConfig.Lang = lang
        SaveData()
        langGui:Destroy()
        callback()
    end

    btnEs.MouseButton1Click:Connect(function() finalizeSelection("es") end)
    btnEn.MouseButton1Click:Connect(function() finalizeSelection("en") end)
end

-- ==========================================
-- [ SECCIÓN 4: INTRODUCCIÓN CINEMATOGRÁFICA ]
-- ==========================================
local function runIntro(onComplete)
    local introLayer = Instance.new("ScreenGui", targetParent)
    introLayer.Name = "PULPO_INTRO"
    introLayer.IgnoreGuiInset = true 
    introLayer.DisplayOrder = 9999

    local bg = Instance.new("Frame", introLayer)
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(5, 5, 8)
    bg.BackgroundTransparency = 1 

    local centerContainer = Instance.new("Frame", bg)
    centerContainer.Size = UDim2.fromOffset(350, 350)
    centerContainer.Position = UDim2.fromScale(0.5, 0.5)
    centerContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    centerContainer.BackgroundTransparency = 1

    local pfp = Instance.new("ImageLabel", centerContainer)
    pfp.Size = UDim2.fromOffset(140, 140)
    pfp.Position = UDim2.fromScale(0.5, 0.35)
    pfp.AnchorPoint = Vector2.new(0.5, 0.5)
    pfp.BackgroundTransparency = 1
    pfp.ImageTransparency = 1
    pfp.Image = "rbxassetid://0"
    
    task.spawn(function()
        local successId, devId = pcall(function() return Players:GetUserIdFromNameAsync("PulpoNot_Found") end)
        if successId and devId then
            local successThumb, thumb = pcall(function()
                return Players:GetUserThumbnailAsync(devId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size420x420)
            end)
            if successThumb and thumb then pfp.Image = thumb end
        end
    end)
    
    Instance.new("UICorner", pfp).CornerRadius = UDim.new(1, 0)
    local pfpStroke = Instance.new("UIStroke", pfp)
    pfpStroke.Thickness = 3
    pfpStroke.Color = Color3.fromRGB(200, 220, 255)
    pfpStroke.Transparency = 1

    local authorTxt = Instance.new("TextLabel", centerContainer)
    authorTxt.Size = UDim2.fromScale(1, 0.2)
    authorTxt.Position = UDim2.fromScale(0.5, 0.7)
    authorTxt.AnchorPoint = Vector2.new(0.5, 0.5)
    authorTxt.BackgroundTransparency = 1
    authorTxt.Text = T("MadeBy")
    authorTxt.TextColor3 = Color3.new(1, 1, 1)
    authorTxt.Font = Enum.Font.GothamBlack
    authorTxt.TextScaled = true
    authorTxt.TextTransparency = 1

    local greeting = T("Hello")
    pcall(function()
        local data = HttpService:JSONDecode(game:HttpGet("https://users.roblox.com/v1/users/" .. player.UserId))
        if data.gender == 2 then greeting = T("WelcomeM")
        elseif data.gender == 3 then greeting = T("WelcomeF") end
    end)

    local userTxt = Instance.new("TextLabel", centerContainer)
    userTxt.Size = UDim2.fromScale(1, 0.15)
    userTxt.Position = UDim2.fromScale(0.5, 0.9)
    userTxt.AnchorPoint = Vector2.new(0.5, 0.5)
    userTxt.BackgroundTransparency = 1
    userTxt.Text = greeting .. player.DisplayName
    userTxt.TextColor3 = Color3.fromRGB(150, 180, 255)
    userTxt.Font = Enum.Font.GothamSemibold
    userTxt.TextScaled = true
    userTxt.TextTransparency = 1

    local tIn = TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    TweenService:Create(bg, tIn, {BackgroundTransparency = 0.1}):Play()
    TweenService:Create(pfp, tIn, {ImageTransparency = 0}):Play()
    TweenService:Create(pfpStroke, tIn, {Transparency = 0}):Play()
    TweenService:Create(authorTxt, tIn, {TextTransparency = 0}):Play()
    TweenService:Create(userTxt, tIn, {TextTransparency = 0}):Play()

    task.wait(3.5)

    local tOut = TweenInfo.new(0.8, Enum.EasingStyle.Cubic, Enum.EasingDirection.InOut)
    TweenService:Create(bg, tOut, {BackgroundTransparency = 1}):Play()
    TweenService:Create(pfp, tOut, {ImageTransparency = 1}):Play()
    TweenService:Create(pfpStroke, tOut, {Transparency = 1}):Play()
    TweenService:Create(authorTxt, tOut, {TextTransparency = 1}):Play()
    TweenService:Create(userTxt, tOut, {TextTransparency = 1}):Play()

    task.wait(1)
    introLayer:Destroy()
    if onComplete then onComplete() end
end

-- ==========================================
-- [ SECCIÓN 5: LÓGICAS FÍSICAS (FLY, TK, ESP, TORNADO, HEADLESS) ]
-- ==========================================

local function applySpeedAndJump()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = SavedConfig.WalkSpeed
        char.Humanoid.JumpPower = SavedConfig.JumpPower
        char.Humanoid.UseJumpPower = true
    end
end

local function toggleHeadlessFE(forceState)
    if forceState ~= nil then SavedConfig.HeadlessActive = forceState else SavedConfig.HeadlessActive = not SavedConfig.HeadlessActive end
    SaveData()
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if SavedConfig.HeadlessActive then
        if head:FindFirstChildOfClass("SpecialMesh") then
            headlessCache.MeshScale = head:FindFirstChildOfClass("SpecialMesh").Scale
            head:FindFirstChildOfClass("SpecialMesh").Scale = Vector3.new(0,0,0)
        end
        if head:FindFirstChildOfClass("Decal") then head:FindFirstChildOfClass("Decal").Transparency = 1 end
        for _, acc in pairs(char:GetChildren()) do
            if acc:IsA("Accessory") then
                local hnd = acc:FindFirstChild("Handle")
                if hnd and hnd:FindFirstChildOfClass("SpecialMesh") then
                    local att = hnd:FindFirstChildOfClass("Attachment")
                    if att and (string.find(att.Name, "Hat") or string.find(att.Name, "Hair") or string.find(att.Name, "Face")) then
                        headlessCache[acc.Name] = hnd:FindFirstChildOfClass("SpecialMesh").Scale
                        hnd:FindFirstChildOfClass("SpecialMesh").Scale = Vector3.new(0,0,0)
                    end
                end
            end
        end
    else
        if head:FindFirstChildOfClass("SpecialMesh") and headlessCache.MeshScale then
            head:FindFirstChildOfClass("SpecialMesh").Scale = headlessCache.MeshScale
        end
        if head:FindFirstChildOfClass("Decal") then head:FindFirstChildOfClass("Decal").Transparency = 0 end
        for _, acc in pairs(char:GetChildren()) do
            if acc:IsA("Accessory") then
                local hnd = acc:FindFirstChild("Handle")
                if hnd and hnd:FindFirstChildOfClass("SpecialMesh") and headlessCache[acc.Name] then
                    hnd:FindFirstChildOfClass("SpecialMesh").Scale = headlessCache[acc.Name]
                end
            end
        end
    end
end

local bvFly, bgFly
local function manageFlight(state)
    if state ~= nil then SavedConfig.FlyActive = state else SavedConfig.FlyActive = not SavedConfig.FlyActive end
    SaveData()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end
    if SavedConfig.FlyActive then
        hum.PlatformStand = true
        if bvFly then bvFly:Destroy() end
        if bgFly then bgFly:Destroy() end
        bvFly = Instance.new("BodyVelocity", root)
        bvFly.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        bvFly.Velocity = Vector3.zero
        bgFly = Instance.new("BodyGyro", root)
        bgFly.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bgFly.P = 15000

        if connections.fly then connections.fly:Disconnect() end
        connections.fly = RunService.RenderStepped:Connect(function()
            bgFly.CFrame = cam.CFrame
            local finalDirection = Vector3.zero
            if isMobile then
                local inputDir = hum.MoveDirection
                if inputDir.Magnitude > 0 then
                    local camLook = cam.CFrame.LookVector
                    local flatLook = Vector3.new(camLook.X, 0, camLook.Z)
                    if flatLook.Magnitude > 0 then flatLook = flatLook.Unit end
                    local forwardFactor = inputDir:Dot(flatLook)
                    finalDirection = Vector3.new(inputDir.X, camLook.Y * forwardFactor, inputDir.Z)
                end
                if hum.Jump then finalDirection = finalDirection + Vector3.new(0, 1, 0) end
            else
                if UIS:IsKeyDown(Enum.KeyCode.W) then finalDirection = finalDirection + cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then finalDirection = finalDirection - cam.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then finalDirection = finalDirection - cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then finalDirection = finalDirection + cam.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then finalDirection = finalDirection + Vector3.new(0, 1, 0) end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) or UIS:IsKeyDown(Enum.KeyCode.LeftShift) then 
                    finalDirection = finalDirection + Vector3.new(0, -1, 0) 
                end
            end
            if finalDirection.Magnitude > 0 then
                bvFly.Velocity = finalDirection.Unit * SavedConfig.FlySpeed
            else
                bvFly.Velocity = Vector3.new(0, 0.05, 0) 
            end
        end)
    else
        if connections.fly then connections.fly:Disconnect() connections.fly = nil end
        hum.PlatformStand = false
        if bvFly then bvFly:Destroy() bvFly = nil end
        if bgFly then bgFly:Destroy() bgFly = nil end
    end
end

local function toggleTornado()
    ringActive = not ringActive
    if ringActive then
        connections.ring = RunService.Heartbeat:Connect(function()
            pcall(function() sethiddenproperty(player, "SimulationRadius", 1e9) end)
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local cycle = tick() * 6
            for _, p in pairs(Workspace:GetDescendants()) do
                if p:IsA("BasePart") and not p.Anchored and not p:IsDescendantOf(player.Character) then
                    local target = root.Position + Vector3.new(math.cos(cycle)*SavedConfig.RingRadius, 4, math.sin(cycle)*SavedConfig.RingRadius)
                    p.Velocity = (target - p.Position).Unit * 150
                    p.CanCollide = false
                end
            end
        end)
    else
        if connections.ring then connections.ring:Disconnect() connections.ring = nil end
    end
end

local function manageESP(state)
    if state ~= nil then SavedConfig.ESPActive = state else SavedConfig.ESPActive = not SavedConfig.ESPActive end
    SaveData()
    if SavedConfig.ESPActive then
        if not connections.esp then
            connections.esp = RunService.RenderStepped:Connect(function()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        if not p.Character:FindFirstChild("PULPI_ESP_V12") then
                            local hl = Instance.new("Highlight", p.Character)
                            hl.Name = "PULPI_ESP_V12"
                            hl.FillTransparency = 1 
                            hl.OutlineColor = Color3.new(1, 1, 1)
                            hl.OutlineTransparency = 0
                        end
                    end
                end
            end)
        end
    else
        if connections.esp then connections.esp:Disconnect() connections.esp = nil end
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("PULPI_ESP_V12") then p.Character.PULPI_ESP_V12:Destroy() end
        end
    end
end

-- ==========================================
-- [ SECCIÓN 6: SISTEMA TOXIC HUNTER (LISTA DINÁMICA & ANTI-FALL) ]
-- ==========================================
local huntTarget = nil
local huntHighlight = nil
local huntBeam = nil
local att0, att1 = nil, nil
local hunting = false

local function stopHunt()
    hunting = false
    if connections.hunt then connections.hunt:Disconnect() connections.hunt = nil end
    if connections.huntNoclip then connections.huntNoclip:Disconnect() connections.huntNoclip = nil end
    
    if huntHighlight then huntHighlight:Destroy() huntHighlight = nil end
    if huntBeam then huntBeam:Destroy() huntBeam = nil end
    if att0 then att0:Destroy() att0 = nil end
    if att1 then att1:Destroy() att1 = nil end
    
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        local bv = hrp:FindFirstChild("HUNT_BV")
        local bav = hrp:FindFirstChild("HUNT_BAV")
        if bv then bv:Destroy() end
        if bav then bav:Destroy() end
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    huntTarget = nil
end

local function startHunt(targetPlayer)
    stopHunt()
    huntTarget = targetPlayer
    
    if not huntTarget then return end
    
    hunting = true
    StarterGui:SetCore("SendNotification", {Title="TOXIC HUNTER", Text="Cazando a: " .. huntTarget.Name, Duration=3})
    
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    
    -- BodyVelocity principal para sostenernos si el enemigo muere
    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name = "HUNT_BV"
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bv.Velocity = Vector3.zero -- Por defecto te mantiene flotando en el sitio
    
    local bav = Instance.new("BodyAngularVelocity", hrp)
    bav.Name = "HUNT_BAV"
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.AngularVelocity = Vector3.new(0, 999999, 0)
    
    -- Noclip Constante
    connections.huntNoclip = RunService.Stepped:Connect(function()
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end)
    
    -- TRACER ROJO (Láser Visual)
    att0 = Instance.new("Attachment", hrp)
    huntBeam = Instance.new("Beam", hrp)
    huntBeam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    huntBeam.FaceCamera = true
    huntBeam.Width0 = 0.5
    huntBeam.Width1 = 0.5
    huntBeam.Transparency = NumberSequence.new(0.3)
    huntBeam.Attachment0 = att0
    
    -- Loop de Caza Seguro
    connections.hunt = RunService.Heartbeat:Connect(function()
        if not hunting then return end
        if not huntTarget or not huntTarget.Parent then stopHunt() return end
        
        local tChar = huntTarget.Character
        local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
        local tHum = tChar and tChar:FindFirstChild("Humanoid")
        
        if tHrp and tHum and tHum.Health > 0 then
            -- Mantiene el ESP Rojo en la víctima
            if not tChar:FindFirstChild("HUNT_ESP") then
                huntHighlight = Instance.new("Highlight", tChar)
                huntHighlight.Name = "HUNT_ESP"
                huntHighlight.FillColor = Color3.fromRGB(255, 0, 0)
                huntHighlight.FillTransparency = 0.5
                huntHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
            
            -- Actualiza la conexión del láser
            if not att1 or att1.Parent ~= tHrp then
                if att1 then att1:Destroy() end
                att1 = Instance.new("Attachment", tHrp)
                huntBeam.Attachment1 = att1
            end
            
            -- Aplicamos fuerza y TP
            bav.AngularVelocity = Vector3.new(0, 999999, 0)
            hrp.CFrame = tHrp.CFrame
        else
            -- LA VÍCTIMA MURIÓ: NOS MANTENEMOS FLOTANDO ARRIBA SEGUROS
            bav.AngularVelocity = Vector3.zero
            hrp.CFrame = CFrame.new(0, 1500, 0)
            if att1 then att1:Destroy() att1 = nil end
            if huntHighlight then huntHighlight:Destroy() huntHighlight = nil end
        end
    end)
end

-- ==============================================================================
-- [ SECCIÓN 7: CONSTRUCCIÓN COMPLETA DE GUI Y ORQUESTACIÓN ]
-- ==============================================================================
local function buildAndOrchestrate()
    -- MAIN GUI
    local mainLayer = Instance.new("ScreenGui", targetParent)
    mainLayer.Name = "PULPI_GUI_V12"
    mainLayer.IgnoreGuiInset = true 

    local menuBase = Instance.new(UIConfig.Type, mainLayer)
    menuBase.Size = UIConfig.MainSize
    menuBase.Position = UDim2.fromScale(0.5, 0.5)
    menuBase.AnchorPoint = Vector2.new(0.5, 0.5) 
    menuBase.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    menuBase.Visible = false 
    menuBase.Active = true

    if isMobile then
        menuBase.BackgroundTransparency = 0.15
    else
        menuBase.BackgroundTransparency = 0.25
        menuBase.GroupTransparency = 1
    end

    makeDraggable(menuBase)
    Instance.new("UICorner", menuBase).CornerRadius = UDim.new(0, 20)
    local menuStroke = Instance.new("UIStroke", menuBase)
    menuStroke.Thickness = 2
    menuStroke.Color = Color3.fromRGB(150, 180, 255)
    
    local scroll = Instance.new("ScrollingFrame", menuBase)
    scroll.Size = UDim2.fromScale(1, 0.9)
    scroll.Position = UDim2.fromScale(0, 0.1)
    scroll.BackgroundTransparency = 1 
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = UIConfig.ScrollThick
    scroll.ScrollingDirection = Enum.ScrollingDirection.Y
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y 

    -- SISTEMA DE MINIMIZAR MENÚ PRINCIPAL
    local titleHeader = Instance.new("TextLabel", menuBase)
    titleHeader.Size = UDim2.fromScale(1, 0.1)
    titleHeader.BackgroundTransparency = 1
    titleHeader.Text = T("MenuTitle")
    titleHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleHeader.TextScaled = true
    titleHeader.Font = Enum.Font.GothamBlack
    
    applyMinimizeSystem(menuBase, UIConfig.MainSize, UIConfig.MinSize, scroll)

    local zoomScale = Instance.new("UIScale", menuBase)
    zoomScale.Scale = isMobile and 1 or 0.85

    local scrollLayout = Instance.new("UIListLayout", scroll)
    scrollLayout.Padding = UDim.new(0, 12)
    scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
    scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local bgBlur = Instance.new("BlurEffect", Lighting)
    bgBlur.Name = "PULPI_BLUR"
    bgBlur.Size = 0 

    local function handleMenuToggle()
        menuOpen = not menuOpen
        if isMobile then
            menuBase.Visible = menuOpen
            bgBlur.Size = menuOpen and 15 or 0
        else
            local tInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            if menuOpen then
                menuBase.Visible = true
                TweenService:Create(menuBase, tInfo, {GroupTransparency = 0}):Play()
                TweenService:Create(zoomScale, tInfo, {Scale = 1}):Play()
                TweenService:Create(bgBlur, tInfo, {Size = 18}):Play()
            else
                local hide = TweenService:Create(menuBase, tInfo, {GroupTransparency = 1})
                TweenService:Create(zoomScale, tInfo, {Scale = 0.85}):Play()
                TweenService:Create(bgBlur, tInfo, {Size = 0}):Play()
                hide:Play()
                task.spawn(function()
                    hide.Completed:Wait()
                    if not menuOpen then menuBase.Visible = false end
                end)
            end
        end
    end

    -- ==========================================
    -- TK GUI (PANEL FLING MANUAL)
    -- ==========================================
    local tkGui = Instance.new("ScreenGui", targetParent)
    tkGui.Name = "TK_GUI_V12"
    tkGui.IgnoreGuiInset = true 
    tkGui.Enabled = true

    local tkPanel = Instance.new("Frame", tkGui)
    tkPanel.Size = UIConfig.TkSize
    tkPanel.Position = isMobile and UDim2.fromScale(0.3, 0.85) or UDim2.fromScale(0.3, 0.85)
    tkPanel.AnchorPoint = Vector2.new(0.5, 1)
    tkPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    tkPanel.BackgroundTransparency = 0.15
    tkPanel.Visible = false 
    tkPanel.Active = true

    makeDraggable(tkPanel)
    Instance.new("UICorner", tkPanel).CornerRadius = UDim.new(0,16)
    Instance.new("UIStroke", tkPanel).Color = Color3.new(1, 1, 1)

    local tkContent = Instance.new("Frame", tkPanel)
    tkContent.Size = UDim2.fromScale(1, 0.8)
    tkContent.Position = UDim2.fromScale(0, 0.2)
    tkContent.BackgroundTransparency = 1

    local tkLayoutUI = Instance.new("UIListLayout", tkContent)
    tkLayoutUI.Padding = UDim.new(0, 10)
    tkLayoutUI.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local tkTitle = Instance.new("TextLabel", tkPanel)
    tkTitle.Size = UDim2.fromScale(1, 0.2)
    tkTitle.BackgroundTransparency = 1
    tkTitle.Text = T("TkTitle")
    tkTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    tkTitle.TextScaled = true
    tkTitle.Font = Enum.Font.GothamBold
    
    applyMinimizeSystem(tkPanel, UIConfig.TkSize, UIConfig.TkMinSize, tkContent)

    local crosshair = Instance.new("Frame", tkGui)
    crosshair.Size = UDim2.fromOffset(8, 8)
    crosshair.Position = UDim2.fromScale(0.5, 0.5)
    crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
    crosshair.BackgroundColor3 = Color3.new(1, 1, 1)
    crosshair.Visible = false
    Instance.new("UICorner", crosshair).CornerRadius = UDim.new(1, 0)

    local ignoreFolder = Instance.new("Folder", Workspace)
    ignoreFolder.Name = "PULPI_IGNORE_FOLDER"

    local tkGhost, manualGrabbedTarget
    local function getAimPart()
        local cx = crosshair.AbsolutePosition.X + (crosshair.AbsoluteSize.X / 2)
        local cy = crosshair.AbsolutePosition.Y + (crosshair.AbsoluteSize.Y / 2)
        local ray = cam:ViewportPointToRay(cx, cy)
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = {player.Character, cam, ignoreFolder}
        params.FilterType = Enum.RaycastFilterType.Blacklist
        local hit = Workspace:Raycast(ray.Origin, ray.Direction * 800, params)
        return hit and hit.Instance
    end

    local function releaseTK()
        if connections.tk then connections.tk:Disconnect() connections.tk = nil end
        if tkGhost then tkGhost:Destroy() tkGhost = nil end
        manualGrabbedTarget = nil
        crosshair.BackgroundColor3 = Color3.new(1, 1, 1)
    end

    local function grabTK()
        local part = getAimPart()
        if not part or not part:IsA("BasePart") then return end
        releaseTK()
        manualGrabbedTarget = part
        tkGhost = part:Clone()
        tkGhost:ClearAllChildren()
        tkGhost.Anchored = true
        tkGhost.CanCollide = false
        tkGhost.Transparency = 0.5
        tkGhost.Material = Enum.Material.ForceField
        tkGhost.Color = Color3.fromRGB(255, 255, 255)
        tkGhost.Parent = ignoreFolder
        crosshair.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        connections.tk = RunService.RenderStepped:Connect(function()
            if tkGhost then tkGhost.CFrame = CFrame.new(cam.CFrame.Position + cam.CFrame.LookVector * 15) end
        end)
    end

    local function manualFling()
        if not manualGrabbedTarget then return end
        local target = manualGrabbedTarget
        releaseTK()
        if target.Anchored then return end
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local oldCFrame = root.CFrame
        local forceV = Instance.new("BodyVelocity", root)
        forceV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        forceV.Velocity = Vector3.zero
        local forceA = Instance.new("BodyAngularVelocity", root)
        forceA.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        forceA.AngularVelocity = Vector3.new(0, 999999999, 0)
        local noclipping = RunService.Stepped:Connect(function()
            for _, v in pairs(char:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end
        end)
        
        root.CFrame = CFrame.new(oldCFrame.Position + Vector3.new(0, 500, 0))
        task.wait(0.1) 
        
        local tStart = tick()
        local loopFling
        loopFling = RunService.Heartbeat:Connect(function()
            if tick() - tStart > 0.8 or not target.Parent then
                loopFling:Disconnect() noclipping:Disconnect()
                forceV:Destroy() forceA:Destroy()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                root.CFrame = oldCFrame
                return
            end
            root.CFrame = target.CFrame * CFrame.new(0, 0, 0)
        end)
    end

    -- ==========================================
    -- HUNT GUI (LISTA DE JUGADORES INTERACTIVA)
    -- ==========================================
    local huntGui = Instance.new("ScreenGui", targetParent)
    huntGui.Name = "HUNT_GUI_V12"
    huntGui.IgnoreGuiInset = true 

    local huntPanel = Instance.new("Frame", huntGui)
    huntPanel.Size = UIConfig.HuntSize
    huntPanel.Position = isMobile and UDim2.fromScale(0.7, 0.85) or UDim2.fromScale(0.7, 0.85)
    huntPanel.AnchorPoint = Vector2.new(0.5, 1)
    huntPanel.BackgroundColor3 = Color3.fromRGB(20, 10, 10)
    huntPanel.BackgroundTransparency = 0.15
    huntPanel.Visible = false 
    huntPanel.Active = true

    makeDraggable(huntPanel)
    Instance.new("UICorner", huntPanel).CornerRadius = UDim.new(0,16)
    Instance.new("UIStroke", huntPanel).Color = Color3.fromRGB(255, 50, 50)

    local huntContent = Instance.new("Frame", huntPanel)
    huntContent.Size = UDim2.fromScale(1, 0.8)
    huntContent.Position = UDim2.fromScale(0, 0.2)
    huntContent.BackgroundTransparency = 1

    local huntTitle = Instance.new("TextLabel", huntPanel)
    huntTitle.Size = UDim2.fromScale(1, 0.2)
    huntTitle.BackgroundTransparency = 1
    huntTitle.Text = T("HuntTitle")
    huntTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
    huntTitle.TextScaled = true
    huntTitle.Font = Enum.Font.GothamBold
    
    applyMinimizeSystem(huntPanel, UIConfig.HuntSize, UIConfig.TkMinSize, huntContent)

    -- Botón de refrescar lista
    local btnRefresh = Instance.new("TextButton", huntContent)
    btnRefresh.Size = UDim2.fromScale(0.9, 0.15)
    btnRefresh.Position = UDim2.fromScale(0.05, 0)
    btnRefresh.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btnRefresh.Text = T("RefreshList")
    btnRefresh.TextColor3 = Color3.new(1,1,1)
    btnRefresh.Font = Enum.Font.GothamBold
    btnRefresh.TextScaled = true
    Instance.new("UICorner", btnRefresh).CornerRadius = UDim.new(0,8)

    -- Scroll de Jugadores
    local playerScroll = Instance.new("ScrollingFrame", huntContent)
    playerScroll.Size = UDim2.fromScale(0.9, 0.55)
    playerScroll.Position = UDim2.fromScale(0.05, 0.2)
    playerScroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    playerScroll.BorderSizePixel = 0
    playerScroll.ScrollBarThickness = 4
    playerScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Instance.new("UICorner", playerScroll).CornerRadius = UDim.new(0,8)

    local pLayout = Instance.new("UIListLayout", playerScroll)
    pLayout.Padding = UDim.new(0, 5)
    pLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local function populatePlayers()
        for _, child in pairs(playerScroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player then
                local btn = Instance.new("TextButton", playerScroll)
                btn.Size = UDim2.new(0.95, 0, 0, 35)
                btn.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
                btn.Text = p.DisplayName .. " (@" .. p.Name .. ")"
                btn.TextColor3 = Color3.new(1,1,1)
                btn.Font = Enum.Font.GothamSemibold
                btn.TextSize = 14
                Instance.new("UICorner", btn)
                btn.MouseButton1Click:Connect(function()
                    startHunt(p)
                end)
            end
        end
    end

    btnRefresh.MouseButton1Click:Connect(populatePlayers)

    local btnStopHunt = Instance.new("TextButton", huntContent)
    btnStopHunt.Size = UDim2.fromScale(0.9, 0.15)
    btnStopHunt.Position = UDim2.fromScale(0.05, 0.8)
    btnStopHunt.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
    btnStopHunt.Text = T("StopHunt")
    btnStopHunt.TextColor3 = Color3.new(1,1,1)
    btnStopHunt.Font = Enum.Font.GothamBold
    btnStopHunt.TextScaled = true
    Instance.new("UICorner", btnStopHunt).CornerRadius = UDim.new(0,8)

    btnStopHunt.MouseButton1Click:Connect(function()
        stopHunt()
        StarterGui:SetCore("SendNotification", {Title="TOXIC HUNTER", Text="Caza Detenida.", Duration=2})
    end)

    -- ==========================================
    -- CONSTRUCTORES UI PRINCIPAL
    -- ==========================================
    local function spawnButton(parentUI, name, callback)
        local btn = Instance.new("TextButton", parentUI)
        btn.Size = UIConfig.BtnSize
        btn.BackgroundColor3 = Color3.fromRGB(40, 50, 80)
        btn.Text = name
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.TextScaled = true
        btn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    local function spawnSlider(configKey, min, max, callback)
        local name = T(configKey)
        local start = SavedConfig[configKey]
        
        local container = Instance.new("Frame", scroll)
        container.Size = UIConfig.SliderContSize
        container.BackgroundTransparency = 1
        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.fromScale(1, 0.45)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.new(1,1,1)
        label.TextScaled = true
        label.Font = Enum.Font.Gotham
        label.Text = name .. ": " .. start
        local track = Instance.new("Frame", container)
        track.Size = UIConfig.SliderTrackSize
        track.Position = UDim2.fromScale(0, 0.55)
        track.BackgroundColor3 = Color3.fromRGB(40,40,60)
        Instance.new("UICorner", track).CornerRadius = UDim.new(1,0)
        local fill = Instance.new("Frame", track)
        fill.BackgroundColor3 = Color3.fromRGB(150, 180, 255)
        fill.Size = UDim2.fromScale((start - min)/(max - min), 1)
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

        local dragging = false
        local function processInput(inputObj)
            local rawX = (inputObj.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
            local clampedX = math.clamp(rawX, 0, 1)
            fill.Size = UDim2.fromScale(clampedX, 1)
            local finalVal = math.floor(min + (max - min) * clampedX)
            label.Text = name .. ": " .. finalVal
            SavedConfig[configKey] = finalVal
            callback(finalVal)
            SaveData()
        end

        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                dragging = true processInput(i)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                processInput(i)
            end
        end)
        UIS.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
                dragging = false 
            end
        end)
    end

    -- ==========================================
    -- INSERCIÓN DE ELEMENTOS EN EL MENÚ
    -- ==========================================
    task.spawn(function()
        task.wait(0.1)
        
        spawnSlider("WalkSpeed", 16, 400, function(v) pcall(function() player.Character.Humanoid.WalkSpeed = v end) end)
        spawnSlider("JumpPower", 50, 500, function(v) pcall(function() player.Character.Humanoid.JumpPower = v end) end)
        spawnSlider("FlySpeed", 30, 800, function(v) flySpeed = v end)
        spawnSlider("RingRadius", 5, 1000, function(v) ringRadius = v end)
        
        spawnButton(scroll, T("Headless"), function() toggleHeadlessFE() end)
        spawnButton(scroll, T("FlyBtn"), function() manageFlight() end)
        spawnButton(scroll, T("EspBtn"), function() manageESP() end)
        spawnButton(scroll, T("TornadoBtn"), toggleTornado)
        
        spawnButton(scroll, T("FlingMenuBtn"), function()
            tkPanelActive = not tkPanelActive
            tkPanel.Visible = tkPanelActive
            crosshair.Visible = tkPanelActive
            if not tkPanelActive then releaseTK() end
        end)
        

        spawnButton(scroll, "MM2 (SnapSanix)", function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/Roman34296589/SnapSanixHUB/refs/heads/main/SnapSanixHUB.lua'))()
        end)
        
        -- Botones del panel TK Manual
        local btnG = spawnButton(tkContent, T("GrabBtn"), grabTK)
        btnG.BackgroundColor3 = Color3.fromRGB(60,60,60)
        local btnS = spawnButton(tkContent, T("DropBtn"), releaseTK)
        btnS.BackgroundColor3 = Color3.fromRGB(40,40,70)
        local btnF = spawnButton(tkContent, T("FlingShoot"), manualFling)
        btnF.BackgroundColor3 = Color3.fromRGB(180,40,40)
        btnF.TextColor3 = Color3.new(0,0,0)
    end)

    -- Activadores Globales
    if isMobile then
        local mControls = Instance.new("ScreenGui", targetParent)
        mControls.Name = "MOBILE_CONTROLS"
        local btn = Instance.new("TextButton", mControls)
        btn.Size = UDim2.fromOffset(50, 50)
        btn.Position = UDim2.new(0, 15, 0.5, 0)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        btn.Text = "🐙"
        btn.TextScaled = true
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        makeDraggable(btn)
        btn.MouseButton1Click:Connect(handleMenuToggle)
    else
        UIS.InputBegan:Connect(function(i, g) 
            if not g and i.KeyCode == Enum.KeyCode.H then handleMenuToggle() end 
        end)
        UIS.InputBegan:Connect(function(i, g)
            if not tkPanelActive then return end
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                if manualGrabbedTarget then releaseTK() else grabTK() end
            elseif i.UserInputType == Enum.UserInputType.MouseButton2 then
                manualFling()
            end
        end)
    end

    player.CharacterAdded:Connect(function()
        task.wait(1)
        applySpeedAndJump()
        if SavedConfig.FlyActive then manageFlight(true) end
        if SavedConfig.HeadlessActive then toggleHeadlessFE(true) end
        if SavedConfig.ESPActive then manageESP(true) end
    end)

    applySpeedAndJump()
    if SavedConfig.FlyActive then manageFlight(true) end
    if SavedConfig.HeadlessActive then toggleHeadlessFE(true) end
    if SavedConfig.ESPActive then manageESP(true) end

    handleMenuToggle() 
end

-- ==========================================
-- [ SECCIÓN 8: ORQUESTADOR DE INICIO ]
-- ==========================================
if not isfile(ConfigPath) then
    showLangSelector(function()
        runIntro(buildAndOrchestrate)
    end)
else
    currentLang = SavedConfig.Lang
    runIntro(buildAndOrchestrate)
end

print("🐙 PULPI V12.0 | TOXIC HUNTER Y LISTA DE JUGADORES CARGADA")