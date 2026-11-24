--!strict
-- ANIME FISSURE | Economy Model Lab v0.1
-- Interactive Studio-only preview of Gems, Gold and two ORIGINAL reroll tokens.
-- Creates no wallet, prices, purchases, inventory or summon rewards.
-- ViewportFrame rotates 3D models; supports drag and zoom.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

if not RunService:IsStudio() then return end

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Visuals = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("EconomyVisualConfig"))
local items = Visuals.GetAll()

local C = {
    Background = Color3.fromRGB(7, 10, 22),
    Main = Color3.fromRGB(13, 23, 45),
    Card = Color3.fromRGB(23, 35, 64),
    Line = Color3.fromRGB(61, 106, 183),
    Neon = Color3.fromRGB(75, 175, 255),
    White = Color3.fromRGB(237, 246, 255),
    Muted = Color3.fromRGB(163, 187, 218),
    Green = Color3.fromRGB(103, 223, 169),
    Gold = Color3.fromRGB(248, 197, 112),
}
local old = playerGui:FindFirstChild("AnimeFissureEconomyLab")
if old then old:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name = "AnimeFissureEconomyLab"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = false
screen.DisplayOrder = 72
screen.Enabled = player:GetAttribute("InArena") ~= true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = playerGui

local function round(parent: Instance, px: number)
    local v = Instance.new("UICorner")
    v.CornerRadius = UDim.new(0, px)
    v.Parent = parent
end

local function outline(parent: Instance, color: Color3, width: number)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = width
    stroke.Transparency = 0.12
    stroke.Parent = parent
end

local function frame(parent: Instance, name: string, position: UDim2,
    size: UDim2, color: Color3, radius: number): Frame
    local object = Instance.new("Frame")
    object.Name = name
    object.Position = position
    object.Size = size
    object.BorderSizePixel = 0
    object.BackgroundColor3 = color
    object.Parent = parent
    if radius > 0 then round(object, radius) end
    return object
end

local function label(parent: Instance, name: string, value: string,
    position: UDim2, size: UDim2, fontSize: number, color: Color3,
    bold: boolean?): TextLabel
    local t = Instance.new("TextLabel")
    t.Name = name
    t.BackgroundTransparency = 1
    t.Position = position
    t.Size = size
    t.Text = value
    t.Font = if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    t.TextSize = fontSize
    t.TextWrapped = true
    t.TextColor3 = color
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.Parent = parent
    return t
end

local function button(parent: Instance, name: string, value: string,
    position: UDim2, size: UDim2, color: Color3, fontSize: number): TextButton
    local b = Instance.new("TextButton")
    b.Name = name
    b.Text = value
    b.Position = position
    b.Size = size
    b.Font = Enum.Font.GothamBold
    b.TextSize = fontSize
    b.TextWrapped = true
    b.TextColor3 = C.White
    b.BorderSizePixel = 0
    b.BackgroundColor3 = color
    b.Parent = parent
    round(b, 9)
    return b
end

local launch = button(screen, "OpenEconomyLab", "◇  GEMAS & ITENS",
    UDim2.new(1, -12, 0, 65), UDim2.fromOffset(218, 43), C.Main, 14)
launch.AnchorPoint = Vector2.new(1, 0)
outline(launch, C.Neon, 1.4)

local shade = frame(screen, "EconomyBackdrop", UDim2.fromScale(0, 0),
    UDim2.fromScale(1, 1), C.Background, 0)
shade.BackgroundTransparency = 0.12
shade.Active = true
shade.Visible = false

local window = frame(shade, "EconomyWindow", UDim2.fromScale(0.5, 0.5),
    UDim2.fromOffset(800, 512), C.Main, 16)
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.ClipsDescendants = true
outline(window, C.Neon, 1.8)
local scale = Instance.new("UIScale")
scale.Parent = window

local header = frame(window, "Header", UDim2.fromOffset(0, 0),
    UDim2.new(1, 0, 0, 62), C.Background, 0)
label(header, "Title", "ANIME FISSURE   /   ECONOMY LAB",
    UDim2.fromOffset(17, 6), UDim2.new(1, -95, 0, 32), 20, C.White, true)
label(header, "Subtitle", "ITENS AUTORAIS • MODELOS 3D • PREVIEW STUDIO",
    UDim2.fromOffset(17, 36), UDim2.new(1, -95, 0, 19), 11, C.Neon)
local close = button(header, "Close", "X",
    UDim2.new(1, -54, 0, 10), UDim2.fromOffset(42, 42), C.Card, 17)

local list = Instance.new("ScrollingFrame")
list.Name = "EconomyItemList"
list.Position = UDim2.fromOffset(12, 75)
list.Size = UDim2.fromOffset(190, 360)
list.BackgroundColor3 = C.Background
list.BorderSizePixel = 0
list.ScrollBarThickness = 3
list.ScrollBarImageColor3 = C.Neon
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.fromOffset(0, 0)
list.Parent = window
round(list, 10)
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 8)
listLayout.Parent = list
local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 8)
listPadding.PaddingBottom = UDim.new(0, 8)
listPadding.PaddingLeft = UDim.new(0, 6)
listPadding.PaddingRight = UDim.new(0, 8)
listPadding.Parent = list

local viewport = Instance.new("ViewportFrame")
viewport.Name = "EconomyViewport"
viewport.Position = UDim2.fromOffset(215, 75)
viewport.Size = UDim2.fromOffset(343, 360)
viewport.BorderSizePixel = 0
viewport.BackgroundColor3 = C.Background
viewport.LightColor = Color3.fromRGB(232, 239, 250)
viewport.Ambient = Color3.fromRGB(155, 183, 216)
viewport.LightDirection = Vector3.new(-1, -1, -0.55)
viewport.Active = true
viewport.Parent = window
round(viewport, 10)
outline(viewport, C.Line, 1.2)

local world = Instance.new("WorldModel")
world.Name = "PreviewWorld"
world.Parent = viewport
local camera = Instance.new("Camera")
camera.Name = "EconomyCamera"
camera.FieldOfView = 43
camera.Parent = viewport
viewport.CurrentCamera = camera

local summary = frame(window, "Info", UDim2.fromOffset(570, 75),
    UDim2.fromOffset(218, 360), C.Card, 12)
outline(summary, C.Line, 1.1)
local itemName = label(summary, "ItemTitle", "GEMAS DA FISSURA",
    UDim2.fromOffset(12, 14), UDim2.new(1, -24, 0, 57),
    21, C.White, true)
local category = label(summary, "Category", "PREMIUM CURRENCY",
    UDim2.fromOffset(12, 78), UDim2.new(1, -24, 0, 26),
    12, C.Neon, true)
label(summary, "UseCaption", "UTILIDADE PLANEJADA",
    UDim2.fromOffset(12, 113), UDim2.new(1, -24, 0, 22),
    12, C.Gold, true)
local usage = label(summary, "Usage", "",
    UDim2.fromOffset(12, 136), UDim2.new(1, -24, 0, 74),
    13, C.White)
label(summary, "VisualCaption", "ASSINATURA VISUAL",
    UDim2.fromOffset(12, 219), UDim2.new(1, -24, 0, 22),
    12, C.Gold, true)
local identity = label(summary, "VisualIdentity", "",
    UDim2.fromOffset(12, 243), UDim2.new(1, -24, 0, 71),
    12, C.Muted)
local status = label(summary, "Status", "MODELO • SEM ECONOMIA",
    UDim2.fromOffset(12, 320), UDim2.new(1, -24, 0, 27),
    11, C.Green, true)

local footer = frame(window, "Controls", UDim2.new(0, 0, 1, -65),
    UDim2.new(1, 0, 0, 65), C.Background, 0)
local left = button(footer, "RotateLeft", "↶  ESQUERDA",
    UDim2.fromOffset(14, 10), UDim2.fromOffset(138, 45), C.Card, 12)
local right = button(footer, "RotateRight", "DIREITA  ↷",
    UDim2.fromOffset(164, 10), UDim2.fromOffset(138, 45), C.Card, 12)
local auto = button(footer, "AutoRotate", "AUTO: ON",
    UDim2.fromOffset(314, 10), UDim2.fromOffset(156, 45), C.Line, 13)
local zoomOut = button(footer, "ZoomOut", "−",
    UDim2.fromOffset(493, 10), UDim2.fromOffset(127, 45), C.Card, 21)
local zoomIn = button(footer, "ZoomIn", "+",
    UDim2.fromOffset(634, 10), UDim2.fromOffset(152, 45), C.Card, 21)

local selected = "FissureGems"
local choices: {[string]: TextButton} = {}
local models: Folder? = nil
local liveModel: Model? = nil
local yaw = math.rad(18)
local distance = 6.4
local spinning = true
local dragging = false
local dragInput: InputObject? = nil
local previousX = 0

local function aim()
    local point = Vector3.new(0, 0, 0)
    camera.CFrame = CFrame.lookAt(
        point + Vector3.new(math.sin(math.rad(12)) * distance,
            distance * 0.18, math.cos(math.rad(12)) * distance),
        point
    )
end
local function redrawAngle()
    if liveModel then liveModel:PivotTo(CFrame.Angles(0, yaw, 0)) end
end

local function preview()
    for id, b in pairs(choices) do
        local selectedEntry = Visuals.Get(id)
        b.BackgroundColor3 = if id == selected then C.Line else C.Card
        b.TextColor3 = if id == selected then C.White else selectedEntry.Accent
    end
    local info = Visuals.Get(selected)
    if not info then return end
    itemName.Text = string.upper(info.Name)
    category.Text = string.upper(info.Category)
    category.TextColor3 = info.Accent
    usage.Text = info.Usage
    identity.Text = info.VisualIdentity
    status.Text = "SOMENTE VISUAL   •   SEM SALDO"
    world:ClearAllChildren()
    liveModel = nil
    if not models then
        status.Text = "CARREGANDO MODELOS..."
        return
    end
    local source = models:FindFirstChild(info.Id)
    if not source or not source:IsA("Model") then
        status.Text = "MODELO AUSENTE. VER OUTPUT"
        return
    end
    liveModel = source:Clone()
    liveModel.Parent = world
    liveModel:PivotTo(CFrame.Angles(0, yaw, 0))
    aim()
end

for i, entry in ipairs(items) do
    local symbols = {FissureGems = "◇", Gold = "◉",
        TraitRerollCore = "✳", RelicTraitSeal = "✦"}
    local b = button(list, "Choose_" .. entry.Id,
        (symbols[entry.Id] or "◇") .. "  " .. entry.ShortName,
        UDim2.fromOffset(0, 0), UDim2.new(1, -3, 0, 77), C.Card, 14)
    b.LayoutOrder = i
    b.TextColor3 = entry.Accent
    choices[entry.Id] = b
    b.Activated:Connect(function()
        selected = entry.Id
        yaw = math.rad(18)
        preview()
    end)
end

local function rotate(delta: number)
    yaw += delta
    redrawAngle()
end
left.Activated:Connect(function() rotate(-math.rad(26)) end)
right.Activated:Connect(function() rotate(math.rad(26)) end)
auto.Activated:Connect(function()
    spinning = not spinning
    auto.Text = if spinning then "AUTO: ON" else "AUTO: OFF"
    auto.BackgroundColor3 = if spinning then C.Line else C.Card
end)
zoomOut.Activated:Connect(function()
    distance = math.clamp(distance + 0.75, 3.9, 10.0)
    aim()
end)
zoomIn.Activated:Connect(function()
    distance = math.clamp(distance - 0.75, 3.9, 10.0)
    aim()
end)

viewport.InputBegan:Connect(function(input: InputObject)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragInput = input
        previousX = input.Position.X
    end
end)
viewport.InputEnded:Connect(function(input: InputObject)
    if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        dragInput = nil
    end
end)
UserInputService.InputEnded:Connect(function(input: InputObject)
    if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        dragInput = nil
    end
end)
UserInputService.InputChanged:Connect(function(input: InputObject)
    if not dragging or not shade.Visible then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or (input.UserInputType == Enum.UserInputType.Touch and input == dragInput) then
        yaw += math.rad((input.Position.X - previousX) * 0.65)
        previousX = input.Position.X
        redrawAngle()
    end
end)

RunService.RenderStepped:Connect(function(dt: number)
    if shade.Visible and screen.Enabled and spinning and not dragging then
        yaw += math.min(dt, 0.07) * 0.52
        redrawAngle()
    end
end)

local function resize()
    local cameraLive = Workspace.CurrentCamera
    if not cameraLive then return end
    local view = cameraLive.ViewportSize
    local portrait = view.Y > view.X
    local w, h = if portrait then 378 else 800, if portrait then 665 else 512
    window.Size = UDim2.fromOffset(w, h)
    scale.Scale = math.clamp(math.min((view.X - 14) / w,
        (view.Y - 14) / h, 1), 0.38, 1)
    if portrait then
        list.Position = UDim2.fromOffset(12, 65)
        list.Size = UDim2.fromOffset(354, 101)
        listLayout.FillDirection = Enum.FillDirection.Horizontal
        listLayout.Padding = UDim.new(0, 5)
        list.AutomaticCanvasSize = Enum.AutomaticSize.X
        list.ScrollingDirection = Enum.ScrollingDirection.X
        for _, b in pairs(choices) do
            b.Size = UDim2.fromOffset(118, 84)
            b.TextSize = 12
        end
        viewport.Position = UDim2.fromOffset(12, 179)
        viewport.Size = UDim2.fromOffset(354, 261)
        summary.Position = UDim2.fromOffset(12, 453)
        summary.Size = UDim2.fromOffset(354, 134)
        itemName.Position = UDim2.fromOffset(9, 2)
        itemName.Size = UDim2.fromOffset(219, 35)
        itemName.TextSize = 16
        category.Position = UDim2.fromOffset(229, 2)
        category.Size = UDim2.fromOffset(115, 35)
        category.TextSize = 10
        usage.Position = UDim2.fromOffset(9, 38)
        usage.Size = UDim2.fromOffset(330, 42)
        usage.TextSize = 12
        identity.Position = UDim2.fromOffset(9, 81)
        identity.Size = UDim2.fromOffset(330, 34)
        identity.TextSize = 11
        status.Position = UDim2.fromOffset(9, 115)
        status.Size = UDim2.fromOffset(330, 18)
        status.TextSize = 10
        for _, field in ipairs({"UseCaption", "VisualCaption"}) do
            local t = summary:FindFirstChild(field)
            if t and t:IsA("TextLabel") then t.Visible = false end
        end
        footer.Position = UDim2.new(0, 0, 1, -65)
        left.Position = UDim2.fromOffset(6, 8)
        left.Size = UDim2.fromOffset(109, 25)
        right.Position = UDim2.fromOffset(126, 8)
        right.Size = UDim2.fromOffset(109, 25)
        auto.Position = UDim2.fromOffset(246, 8)
        auto.Size = UDim2.fromOffset(126, 25)
        zoomOut.Position = UDim2.fromOffset(60, 36)
        zoomOut.Size = UDim2.fromOffset(110, 25)
        zoomIn.Position = UDim2.fromOffset(208, 36)
        zoomIn.Size = UDim2.fromOffset(110, 25)
    else
        list.Position = UDim2.fromOffset(12, 75)
        list.Size = UDim2.fromOffset(190, 360)
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.Padding = UDim.new(0, 8)
        list.AutomaticCanvasSize = Enum.AutomaticSize.Y
        list.ScrollingDirection = Enum.ScrollingDirection.Y
        for _, b in pairs(choices) do
            b.Size = UDim2.new(1, -3, 0, 77)
            b.TextSize = 14
        end
        viewport.Position = UDim2.fromOffset(215, 75)
        viewport.Size = UDim2.fromOffset(343, 360)
        summary.Position = UDim2.fromOffset(570, 75)
        summary.Size = UDim2.fromOffset(218, 360)
        itemName.Position = UDim2.fromOffset(12, 14)
        itemName.Size = UDim2.new(1, -24, 0, 57)
        itemName.TextSize = 21
        category.Position = UDim2.fromOffset(12, 78)
        category.Size = UDim2.new(1, -24, 0, 26)
        category.TextSize = 12
        usage.Position = UDim2.fromOffset(12, 136)
        usage.Size = UDim2.new(1, -24, 0, 74)
        usage.TextSize = 13
        identity.Position = UDim2.fromOffset(12, 243)
        identity.Size = UDim2.new(1, -24, 0, 71)
        identity.TextSize = 12
        status.Position = UDim2.fromOffset(12, 320)
        status.Size = UDim2.new(1, -24, 0, 27)
        status.TextSize = 11
        for _, field in ipairs({"UseCaption", "VisualCaption"}) do
            local t = summary:FindFirstChild(field)
            if t and t:IsA("TextLabel") then t.Visible = true end
        end
        left.Position = UDim2.fromOffset(14, 10)
        left.Size = UDim2.fromOffset(138, 45)
        right.Position = UDim2.fromOffset(164, 10)
        right.Size = UDim2.fromOffset(138, 45)
        auto.Position = UDim2.fromOffset(314, 10)
        auto.Size = UDim2.fromOffset(156, 45)
        zoomOut.Position = UDim2.fromOffset(493, 10)
        zoomOut.Size = UDim2.fromOffset(127, 45)
        zoomIn.Position = UDim2.fromOffset(634, 10)
        zoomIn.Size = UDim2.fromOffset(152, 45)
    end
end

local function bindViewport()
    local cam = Workspace.CurrentCamera
    if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
    resize()
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindViewport)
bindViewport()

local function setOpen(open: boolean)
    shade.Visible = open
    if open then
        -- Avoid two model laboratories covering each other.
        local other = playerGui:FindFirstChild("OverlordModelGallery")
        local otherBackdrop = if other then other:FindFirstChild("Backdrop", true) else nil
        if otherBackdrop and otherBackdrop:IsA("Frame") then otherBackdrop.Visible = false end
        preview()
    else
        dragging = false
    end
end
launch.Activated:Connect(function() setOpen(not shade.Visible) end)
close.Activated:Connect(function() setOpen(false) end)
player:GetAttributeChangedSignal("InArena"):Connect(function()
    screen.Enabled = player:GetAttribute("InArena") ~= true
    if not screen.Enabled then setOpen(false) end
end)

task.spawn(function()
    local library = ReplicatedStorage:WaitForChild("EconomyPreviewModels", 40)
    if library and library:IsA("Folder") then
        models = library
        if shade.Visible then preview() end
    else
        warn("[Anime Fissure] Economy Lab: library not found (Studio)")
    end
end)

print("[Anime Fissure] ECONOMY LAB v0.1 • quatro modelos autorais 3D")
