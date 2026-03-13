local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
if not player then
    return
end

local function safeDestroy(name)
    local existing = CoreGui:FindFirstChild(name)
    if existing then
        existing:Destroy()
    end
end

safeDestroy("Windows11ConfigPanel")

local palette = {
    appBg = Color3.fromRGB(242, 242, 242),
    panel = Color3.fromRGB(232, 232, 232),
    sectionCard = Color3.fromRGB(236, 236, 236),
    textPrimary = Color3.fromRGB(44, 44, 44),
    textSecondary = Color3.fromRGB(108, 108, 108),
    selected = Color3.fromRGB(223, 232, 255),
    selectedText = Color3.fromRGB(42, 79, 166),
    white = Color3.fromRGB(255, 255, 255),
    stroke = Color3.fromRGB(212, 212, 212),
    primaryBtn = Color3.fromRGB(49, 104, 212),
    neutralBtn = Color3.fromRGB(226, 226, 226),
    shadow = Color3.fromRGB(0, 0, 0),
    toggleOn = Color3.fromRGB(63, 125, 245),
    toggleOff = Color3.fromRGB(191, 191, 191)
}

local gui = Instance.new("ScreenGui")
gui.Name = "Windows11ConfigPanel"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local shadow = Instance.new("Frame")
shadow.Name = "Shadow"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.fromOffset(980, 610)
shadow.BackgroundColor3 = palette.shadow
shadow.BackgroundTransparency = 0.88
shadow.BorderSizePixel = 0
shadow.Parent = gui
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 24)

local window = Instance.new("Frame")
window.Name = "Window"
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.Position = UDim2.fromScale(0.5, 0.5)
window.Size = UDim2.fromOffset(960, 590)
window.BackgroundColor3 = palette.appBg
window.BorderSizePixel = 0
window.Parent = gui
Instance.new("UICorner", window).CornerRadius = UDim.new(0, 22)

local stroke = Instance.new("UIStroke")
stroke.Color = palette.stroke
stroke.Thickness = 1
stroke.Transparency = 0.35
stroke.Parent = window

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.fromOffset(220, 590)
sidebar.BackgroundColor3 = palette.panel
sidebar.BorderSizePixel = 0
sidebar.Parent = window
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0, 22)

local sidebarClip = Instance.new("Frame")
sidebarClip.Name = "SidebarMask"
sidebarClip.Size = UDim2.new(0, 20, 1, 0)
sidebarClip.Position = UDim2.new(1, -20, 0, 0)
sidebarClip.BackgroundColor3 = palette.panel
sidebarClip.BorderSizePixel = 0
sidebarClip.Parent = sidebar

local sidePadding = Instance.new("UIPadding")
sidePadding.PaddingTop = UDim.new(0, 26)
sidePadding.PaddingLeft = UDim.new(0, 14)
sidePadding.PaddingRight = UDim.new(0, 14)
sidePadding.Parent = sidebar

local sidebarList = Instance.new("UIListLayout")
sidebarList.Padding = UDim.new(0, 8)
sidebarList.HorizontalAlignment = Enum.HorizontalAlignment.Center
sidebarList.SortOrder = Enum.SortOrder.LayoutOrder
sidebarList.Parent = sidebar

local navItems = {
    "1Player",
    "2.Troll",
    "3.Visual",
    "5cmd",
    "6; extra el script de mm2 infinite yield"
}

for index, name in ipairs(navItems) do
    local item = Instance.new("Frame")
    item.Size = UDim2.new(1, -4, 0, 46)
    item.BackgroundColor3 = index == 1 and palette.selected or Color3.fromRGB(0, 0, 0)
    item.BackgroundTransparency = index == 1 and 0 or 1
    item.BorderSizePixel = 0
    item.LayoutOrder = index
    item.Parent = sidebar
    Instance.new("UICorner", item).CornerRadius = UDim.new(0, 12)

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.fromOffset(28, 28)
    icon.Position = UDim2.new(0, 8, 0.5, -14)
    icon.BackgroundColor3 = index == 1 and Color3.fromRGB(194, 214, 255) or Color3.fromRGB(214, 214, 214)
    icon.BackgroundTransparency = 0
    icon.Text = "●"
    icon.TextScaled = true
    icon.TextColor3 = index == 1 and palette.selectedText or palette.textSecondary
    icon.Font = Enum.Font.GothamSemibold
    icon.BorderSizePixel = 0
    icon.Parent = item
    Instance.new("UICorner", icon).CornerRadius = UDim.new(1, 0)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 44, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = index == 1 and palette.selectedText or palette.textSecondary
    label.Parent = item
end

local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -240, 1, -26)
content.Position = UDim2.new(0, 232, 0, 14)
content.BackgroundTransparency = 1
content.Parent = window

local contentPad = Instance.new("UIPadding")
contentPad.PaddingLeft = UDim.new(0, 6)
contentPad.PaddingRight = UDim.new(0, 18)
contentPad.PaddingTop = UDim.new(0, 8)
contentPad.Parent = content

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, -14, 0, 42)
title.Text = "Integrations"
title.Font = Enum.Font.GothamBold
title.TextSize = 33
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = palette.textPrimary
title.Parent = content

local subtitle = Instance.new("TextLabel")
subtitle.BackgroundTransparency = 1
subtitle.Position = UDim2.fromOffset(0, 40)
subtitle.Size = UDim2.new(1, -12, 0, 36)
subtitle.Text = "Configure additional functionality to go alongside Roblox."
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 15
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.TextColor3 = palette.textSecondary
subtitle.Parent = content

local function createToggle(parent, startOn)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.fromOffset(58, 30)
    toggle.BackgroundColor3 = startOn and palette.toggleOn or palette.toggleOff
    toggle.AutoButtonColor = false
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.Parent = parent
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(24, 24)
    knob.Position = startOn and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
    knob.BackgroundColor3 = palette.white
    knob.BorderSizePixel = 0
    knob.Parent = toggle
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local enabled = startOn
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        toggle.BackgroundColor3 = enabled and palette.toggleOn or palette.toggleOff
        knob.Position = enabled and UDim2.new(1, -27, 0.5, -12) or UDim2.new(0, 3, 0.5, -12)
    end)

    return toggle
end

local activityHeader = Instance.new("TextLabel")
activityHeader.BackgroundTransparency = 1
activityHeader.Position = UDim2.fromOffset(0, 98)
activityHeader.Size = UDim2.new(1, -12, 0, 26)
activityHeader.Text = "Activity tracking"
activityHeader.Font = Enum.Font.GothamSemibold
activityHeader.TextSize = 20
activityHeader.TextXAlignment = Enum.TextXAlignment.Left
activityHeader.TextColor3 = palette.textPrimary
activityHeader.Parent = content

local activityContainer = Instance.new("Frame")
activityContainer.BackgroundTransparency = 1
activityContainer.Position = UDim2.fromOffset(0, 130)
activityContainer.Size = UDim2.new(1, -8, 0, 210)
activityContainer.Parent = content

local actLayout = Instance.new("UIListLayout")
actLayout.Padding = UDim.new(0, 12)
actLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
actLayout.Parent = activityContainer

local trackingRows = {
    "Display current game on profile",
    "Record server join timestamps",
    "Sync rich activity status"
}

for _, rowText in ipairs(trackingRows) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 58)
    row.BackgroundColor3 = palette.sectionCard
    row.BorderSizePixel = 0
    row.Parent = activityContainer
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 14)

    local rowStroke = Instance.new("UIStroke")
    rowStroke.Color = palette.stroke
    rowStroke.Thickness = 1
    rowStroke.Transparency = 0.4
    rowStroke.Parent = row

    local rowLabel = Instance.new("TextLabel")
    rowLabel.BackgroundTransparency = 1
    rowLabel.Size = UDim2.new(1, -100, 1, 0)
    rowLabel.Position = UDim2.fromOffset(16, 0)
    rowLabel.Text = rowText
    rowLabel.Font = Enum.Font.Gotham
    rowLabel.TextSize = 14
    rowLabel.TextXAlignment = Enum.TextXAlignment.Left
    rowLabel.TextColor3 = palette.textPrimary
    rowLabel.Parent = row

    local toggle = createToggle(row, false)
    toggle.AnchorPoint = Vector2.new(1, 0.5)
    toggle.Position = UDim2.new(1, -16, 0.5, 0)
end

local discordHeader = Instance.new("TextLabel")
discordHeader.BackgroundTransparency = 1
discordHeader.Position = UDim2.fromOffset(0, 358)
discordHeader.Size = UDim2.new(1, -12, 0, 26)
discordHeader.Text = "Discord Rich Presence"
discordHeader.Font = Enum.Font.GothamSemibold
discordHeader.TextSize = 20
discordHeader.TextXAlignment = Enum.TextXAlignment.Left
discordHeader.TextColor3 = palette.textPrimary
discordHeader.Parent = content

local discordCard = Instance.new("Frame")
discordCard.Position = UDim2.fromOffset(0, 390)
discordCard.Size = UDim2.new(1, -8, 0, 84)
discordCard.BackgroundColor3 = palette.sectionCard
discordCard.BorderSizePixel = 0
discordCard.Parent = content
Instance.new("UICorner", discordCard).CornerRadius = UDim.new(0, 14)

local discordStroke = Instance.new("UIStroke")
discordStroke.Color = palette.stroke
discordStroke.Thickness = 1
discordStroke.Transparency = 0.4
discordStroke.Parent = discordCard

local discordDesc = Instance.new("TextLabel")
discordDesc.BackgroundTransparency = 1
discordDesc.Position = UDim2.fromOffset(16, 12)
discordDesc.Size = UDim2.new(1, -116, 1, -24)
discordDesc.TextWrapped = true
discordDesc.TextXAlignment = Enum.TextXAlignment.Left
discordDesc.TextYAlignment = Enum.TextYAlignment.Top
discordDesc.Text = "This feature requires activity tracking to be enabled and the Discord desktop app to be installed and running."
discordDesc.Font = Enum.Font.Gotham
discordDesc.TextSize = 14
discordDesc.TextColor3 = palette.textSecondary
discordDesc.Parent = discordCard

local discordToggle = createToggle(discordCard, true)
discordToggle.AnchorPoint = Vector2.new(1, 0.5)
discordToggle.Position = UDim2.new(1, -16, 0.5, 0)

local bottom = Instance.new("Frame")
bottom.BackgroundTransparency = 1
bottom.Size = UDim2.new(1, -8, 0, 80)
bottom.Position = UDim2.new(0, 0, 1, -90)
bottom.Parent = content

local testModeLabel = Instance.new("TextLabel")
testModeLabel.BackgroundTransparency = 1
testModeLabel.Size = UDim2.fromOffset(100, 30)
testModeLabel.Position = UDim2.new(0, 48, 0.5, -15)
testModeLabel.Text = "Test mode"
testModeLabel.TextXAlignment = Enum.TextXAlignment.Left
testModeLabel.TextSize = 14
testModeLabel.Font = Enum.Font.Gotham
testModeLabel.TextColor3 = palette.textSecondary
testModeLabel.Parent = bottom

local testModeToggle = createToggle(bottom, false)
testModeToggle.Size = UDim2.fromOffset(50, 26)
testModeToggle.Position = UDim2.new(0, 0, 0.5, -13)

local buttonBar = Instance.new("Frame")
buttonBar.BackgroundTransparency = 1
buttonBar.AnchorPoint = Vector2.new(1, 0.5)
buttonBar.Position = UDim2.new(1, 0, 0.5, 0)
buttonBar.Size = UDim2.fromOffset(430, 42)
buttonBar.Parent = bottom

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.FillDirection = Enum.FillDirection.Horizontal
buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
buttonLayout.Padding = UDim.new(0, 10)
buttonLayout.Parent = buttonBar

local function makeButton(text, bg, fg, width)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(width, 40)
    btn.BackgroundColor3 = bg
    btn.TextColor3 = fg
    btn.Text = text
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.AutoButtonColor = true
    btn.BorderSizePixel = 0
    btn.Parent = buttonBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

    local btnStroke = Instance.new("UIStroke")
    btnStroke.Color = palette.stroke
    btnStroke.Transparency = 0.35
    btnStroke.Thickness = 1
    btnStroke.Parent = btn

    return btn
end

makeButton("Save and Launch", palette.primaryBtn, palette.white, 150)
makeButton("Save", palette.white, palette.textPrimary, 90)
local closeBtn = makeButton("Close", palette.neutralBtn, palette.textPrimary, 90)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)
