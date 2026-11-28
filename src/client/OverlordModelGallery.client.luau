--!strict
-- ANIME FISSURE | Overlord Model Gallery v0.1
-- PREVIEW local somente no Roblox Studio. Nao altera colecao, banner,
-- deck, stats, habilidades, combate ou progressao.
-- ViewportFrame para inspecionar seis rigs R6 com quatro estagios visuais.
-- PC: mouse / setas. Mobile Studio: toque / arraste.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

if not RunService:IsStudio() then return end

local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")
local Roster = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("OverlordUnitRoster"))
local Builder = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("OverlordTowerModelBuilder"))
local Progression = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("OverlordModelProgression"))
local Abilities = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("OverlordAbilityDesign"))
local Motion = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("OverlordMotionController"))
local entries = Roster.GetAll()
local templates: Folder? = nil

local P = {
    Black = Color3.fromRGB(7, 10, 21),
    Dark = Color3.fromRGB(14, 23, 43),
    Card = Color3.fromRGB(24, 37, 65),
    Secondary = Color3.fromRGB(42, 62, 105),
    Stroke = Color3.fromRGB(56, 124, 232),
    Cyan = Color3.fromRGB(106, 223, 255),
    White = Color3.fromRGB(240, 247, 255),
    Faint = Color3.fromRGB(166, 186, 213),
    Gold = Color3.fromRGB(248, 200, 118),
    Blue = Color3.fromRGB(63, 132, 248),
    Purple = Color3.fromRGB(171, 108, 245),
    Red = Color3.fromRGB(242, 100, 143),
    Green = Color3.fromRGB(94, 216, 159),
}

local rarityColors = {
    Common = P.Faint,
    Rare = P.Blue,
    Epic = P.Purple,
    Legendary = P.Gold,
    Mythic = P.Red,
    Secret = P.Cyan,
}

local old = guiParent:FindFirstChild("OverlordModelGallery")
if old then old:Destroy() end

local screen = Instance.new("ScreenGui")
screen.Name = "OverlordModelGallery"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = false
screen.DisplayOrder = 65
screen.Enabled = player:GetAttribute("InArena") ~= true
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Parent = guiParent

local function corner(parent: Instance, radius: number)
    local p = Instance.new("UICorner")
    p.CornerRadius = UDim.new(0, radius)
    p.Parent = parent
end

local function stroke(parent: Instance, color: Color3, thickness: number, transparency: number?)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency or 0
    s.Parent = parent
end

local function frame(parent: Instance, name: string, pos: UDim2,
    size: UDim2, color: Color3, radius: number): Frame
    local f = Instance.new("Frame")
    f.Name = name
    f.Size = size
    f.Position = pos
    f.BorderSizePixel = 0
    f.BackgroundColor3 = color
    f.Parent = parent
    if radius > 0 then corner(f, radius) end
    return f
end

local function label(parent: Instance, name: string, content: string,
    pos: UDim2, size: UDim2, fontSize: number,
    color: Color3, bold: boolean?): TextLabel
    local t = Instance.new("TextLabel")
    t.Name = name
    t.Size = size
    t.Position = pos
    t.BackgroundTransparency = 1
    t.Font = if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    t.TextSize = fontSize
    t.TextColor3 = color
    t.Text = content
    t.TextWrapped = true
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.Parent = parent
    return t
end

local function button(parent: Instance, name: string, value: string,
    pos: UDim2, size: UDim2, color: Color3, fontSize: number): TextButton
    local b = Instance.new("TextButton")
    b.Name = name
    b.Text = value
    b.Position = pos
    b.Size = size
    b.Font = Enum.Font.GothamBold
    b.TextSize = fontSize
    b.TextColor3 = P.White
    b.TextWrapped = true
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.AutoButtonColor = true
    b.Parent = parent
    corner(b, 9)
    return b
end

local toggle = button(screen, "OpenModelGallery", "◈  MODELOS OVERLORD",
    UDim2.new(1, -12, 0, 12), UDim2.fromOffset(216, 45), P.Dark, 13)
toggle.AnchorPoint = Vector2.new(1, 0)
stroke(toggle, P.Stroke, 1.5, 0.07)

local overlay = frame(screen, "Backdrop", UDim2.fromScale(0, 0),
    UDim2.fromScale(1, 1), P.Black, 0)
overlay.Visible = false
overlay.BackgroundTransparency = 0.12
overlay.Active = true

local window = frame(overlay, "ModelPreviewWindow",
    UDim2.fromScale(0.5, 0.5), UDim2.fromOffset(800, 518), P.Dark, 14)
window.AnchorPoint = Vector2.new(0.5, 0.5)
stroke(window, P.Stroke, 1.8, 0.05)
window.ClipsDescendants = true
local windowScale = Instance.new("UIScale")
windowScale.Parent = window

local head = frame(window, "Header", UDim2.fromOffset(0, 0),
    UDim2.new(1, 0, 0, 63), P.Black, 0)
label(head, "Title", "OVERLORD  /  MODEL LAB",
    UDim2.fromOffset(18, 8), UDim2.new(1, -92, 0, 27),
    20, P.Cyan, true)
label(head, "Subtitle", "PREVIEW STUDIO   •   R6   •   SEM UNLOCK / SUMMON",
    UDim2.fromOffset(18, 35), UDim2.new(1, -92, 0, 19),
    11, P.Faint)
local close = button(head, "Close", "X", UDim2.new(1, -57, 0, 11),
    UDim2.fromOffset(43, 40), P.Card, 17)

local list = Instance.new("ScrollingFrame")
list.Name = "RosterList"
list.Position = UDim2.fromOffset(14, 78)
list.Size = UDim2.fromOffset(177, 362)
list.BackgroundColor3 = P.Black
list.BorderSizePixel = 0
list.ScrollBarThickness = 3
list.ScrollBarImageColor3 = P.Cyan
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.fromOffset(0, 0)
list.Parent = window
corner(list, 9)
local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = list
local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 7)
listPadding.PaddingBottom = UDim.new(0, 7)
listPadding.PaddingLeft = UDim.new(0, 7)
listPadding.PaddingRight = UDim.new(0, 8)
listPadding.Parent = list

local viewport = Instance.new("ViewportFrame")
viewport.Name = "UnitViewport"
viewport.Position = UDim2.fromOffset(206, 78)
viewport.Size = UDim2.fromOffset(347, 362)
viewport.BackgroundColor3 = P.Black
viewport.BorderSizePixel = 0
viewport.LightDirection = Vector3.new(-1, -1, -0.5)
viewport.LightColor = Color3.fromRGB(250, 247, 240)
viewport.Ambient = Color3.fromRGB(194, 191, 204)
viewport.Parent = window
corner(viewport, 9)
stroke(viewport, P.Secondary, 1.2, 0.10)

local previewFX = button(window, "PlayUnitFX", "▶  ANIMAR ATAQUE + VFX",
    UDim2.fromOffset(218, 393), UDim2.fromOffset(198, 35), P.Purple, 12)
previewFX.ZIndex = 15

local world = Instance.new("WorldModel")
world.Name = "PreviewWorld"
world.Parent = viewport
local camera = Instance.new("Camera")
camera.Name = "PreviewCamera"
camera.FieldOfView = 42
camera.Parent = viewport
viewport.CurrentCamera = camera

local infos = frame(window, "UnitInfo",
    UDim2.fromOffset(567, 78), UDim2.fromOffset(218, 362), P.Card, 10)
stroke(infos, P.Secondary, 1.2, 0.25)
local heroName = label(infos, "CharacterName", "CLIMB",
    UDim2.fromOffset(12, 7), UDim2.new(1, -24, 0, 55), 21, P.White, true)
local heroRarity = label(infos, "Rarity", "COMMON",
    UDim2.fromOffset(12, 66), UDim2.new(1, -24, 0, 26), 16, P.Faint, true)
local obtaining = label(infos, "Method", "BANNER (PLANEJADO)",
    UDim2.fromOffset(12, 101), UDim2.new(1, -24, 0, 40), 11, P.Cyan)
local passiveTitle = label(infos, "PassiveTitle", "PASSIVA",
    UDim2.fromOffset(12, 146), UDim2.new(1, -24, 0, 23), 12, P.Gold, true)
local passive = label(infos, "Passive", "A DEFINIR",
    UDim2.fromOffset(12, 166), UDim2.new(1, -24, 0, 55), 13, P.White, true)
local attackTitle = label(infos, "AttackTitle", "PADRAO DE ATAQUE",
    UDim2.fromOffset(12, 228), UDim2.new(1, -24, 0, 22), 12, P.Gold, true)
local attack = label(infos, "AttackName", "BASE",
    UDim2.fromOffset(12, 250), UDim2.new(1, -24, 0, 54), 14, P.Cyan, true)
local infoNote = label(infos, "Note",
    "Trocas visuais de ataque. Danos e skills ainda nao ativos.",
    UDim2.fromOffset(12, 308), UDim2.new(1, -24, 0, 47), 10, P.Faint)

local footer = frame(window, "Footer",
    UDim2.new(0, 0, 1, -67), UDim2.new(1, 0, 0, 67), P.Black, 0)
local stageButtons: {TextButton} = {}
for i, title in ipairs({"BASE", "ATAQUE 1", "ATAQUE 2", "ATAQUE 3"}) do
    local b = button(footer, "ModelStage" .. tostring(i - 1), title,
        UDim2.fromOffset(13 + (i - 1) * 143, 12),
        UDim2.fromOffset(135, 44), P.Card, 13)
    stageButtons[i] = b
end
local rotateLeft = button(footer, "RotateLeft", "⟲",
    UDim2.fromOffset(594, 12), UDim2.fromOffset(78, 44), P.Secondary, 21)
local rotateRight = button(footer, "RotateRight", "⟳",
    UDim2.fromOffset(686, 12), UDim2.fromOffset(98, 44), P.Secondary, 21)

local current = "OVL_Climb"
local visualStage = 0
local yaw = math.rad(25)
local selectedButtons: {[string]: TextButton} = {}
local previewMotion: any = nil

local function aimCamera()
    local focus = Vector3.new(0, 3.2, 0)
    local orbit = Vector3.new(math.sin(yaw) * 12.2, 4.2,
        math.cos(yaw) * 12.2)
    camera.CFrame = CFrame.lookAt(focus + orbit, focus)
end

local function updateSelection()
    for id, b in pairs(selectedButtons) do
        b.BackgroundColor3 = if id == current then P.Blue else P.Card
    end
    for index, b in ipairs(stageButtons) do
        b.BackgroundColor3 = if index - 1 == visualStage then P.Blue else P.Card
    end
end

-- Preview local no ViewportFrame (nao causa dano no jogo).
-- Ataques reais da arena usam o OverlordCombatVFX.client.luau.
local function fxStroke(name: string, a: Vector3, b: Vector3,
    color: Color3, width: number)
    local d = b - a
    if d.Magnitude < 0.01 then return end
    local p = Instance.new("Part")
    p.Name = name
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.Material = Enum.Material.Neon
    p.Color = color
    p.Size = Vector3.new(width, width, d.Magnitude)
    p.CFrame = CFrame.lookAt((a + b) / 2, b)
    p.Parent = world
    TweenService:Create(p, TweenInfo.new(0.48), {
        Transparency = 1,
        Size = Vector3.new(0.02, 0.02, d.Magnitude),
    }):Play()
    Debris:AddItem(p, 0.6)
end

local function playPreviewFX()
    if previewMotion then previewMotion:Attack(visualStage, Vector3.new(1.6,3.05,-2.05)) end
    local colors = {
        OVL_Climb = Color3.fromRGB(122, 210, 255),
        OVL_Brain = Color3.fromRGB(224, 239, 255),
        OVL_Gazef = Color3.fromRGB(255, 200, 110),
        OVL_Shalltear = Color3.fromRGB(245, 64, 110),
        OVL_Albedo = Color3.fromRGB(244, 215, 142),
        OVL_Ainz = Color3.fromRGB(197, 129, 252),
    }
    local color = colors[current]
    if not color then return end
    local from = Vector3.new(0.18, 4.25, -0.55)
    local to = Vector3.new(1.6, 3.05, -2.05)
    if current == "OVL_Climb" then
        fxStroke("Climb_Arc", from, to, color, 0.22)
        fxStroke("Climb_Vertical", to - Vector3.new(0, 0.85, 0),
            to + Vector3.new(0, 0.85, 0), color, 0.17)
    elseif current == "OVL_Brain" then
        for i = 1, 2 + visualStage do
            local offset = (i - (3 + visualStage) / 2) * 0.33
            fxStroke("Brain_GodFlash", from + Vector3.new(offset, 0, 0),
                to - Vector3.new(offset, 0, 0), color, 0.08)
        end
    elseif current == "OVL_Gazef" then
        for i = 1, 2 + visualStage do
            fxStroke("Gazef_Slash", from,
                to + Vector3.new((i - 2) * 0.50, (i - 2) * 0.25, 0),
                color, 0.19)
        end
    elseif current == "OVL_Shalltear" then
        fxStroke("Shalltear_SpuitLance", from, to, color, 0.27)
        for i = 1, 4 do
            local theta = i * math.pi * 0.5
            fxStroke("Blood_Petal", to,
                to + Vector3.new(math.sin(theta) * 0.6,
                    math.cos(theta) * 0.6, -0.15), color, 0.12)
        end
    elseif current == "OVL_Albedo" then
        fxStroke("Albedo_Wings", from, to, color, 0.25)
        fxStroke("Albedo_Guard", to + Vector3.new(-0.85, 0.65, 0),
            to + Vector3.new(0.85, -0.65, 0), color, 0.22)
    elseif current == "OVL_Ainz" then
        for i = 1, 3 + visualStage do
            local offset = (i - 2.5) * 0.35
            fxStroke("Ainz_RealityRift",
                to + Vector3.new(-0.95, 0.85 + offset, 0),
                to + Vector3.new(0.95, -0.85 + offset, 0), color, 0.18)
        end
    end
end
previewFX.Activated:Connect(playPreviewFX)

local function preview()
    updateSelection()
    local unit = Roster.Get(current)
    local design = Abilities.Get(current)
    local visual = Progression.Get(current, visualStage)
    if not unit or not design or not design.Passive or not visual then return end
    heroName.Text = string.upper(unit.FullName)
    heroRarity.Text = string.upper(unit.Rarity)
    heroRarity.TextColor3 = rarityColors[unit.Rarity] or P.White
    obtaining.Text = if unit.BannerCandidate then "BANNER PLANEJADO"
        else "FORA DO BANNER  ·  STAGE ESPECIAL A DECIDIR"
    passiveTitle.Text = "PASSIVA UNIVERSAL"
    passive.Text = design.Passive.Name
    attack.Text = visual.Name .. "\n" .. visual.Pattern
    infoNote.Text = "Etapa visual " .. tostring(visualStage) .. "/3. "
        .. visual.Visual .. ".\nSem liberar unidades ou habilidades."

    if previewMotion then previewMotion:Destroy(); previewMotion = nil end
    world:ClearAllChildren()
    if not templates then
        infoNote.Text = "Preparando os modelos no Studio..."
        return
    end
    local source = templates:FindFirstChild(current .. "_" .. unit.Rarity)
    if not source or not source:IsA("Model") then
        infoNote.Text = "Modelo nao encontrado. Veja o Output do Studio."
        return
    end

    local model = source:Clone()
    model.Parent = world
    -- Builder coloca os pes no Y=0 e Root no Y=3; manter esse pivot.
    model:PivotTo(CFrame.new(0, 3, 0))
    Builder.SetVisualStage(model, visualStage)
    previewMotion = Motion.Attach(model)
    aimCamera()
end

for i, entry in ipairs(entries) do
    local b = button(list, "Select_" .. entry.Id,
        entry.Name .. "\n" .. string.upper(entry.Rarity),
        UDim2.fromOffset(0, 0), UDim2.new(1, -5, 0, 53), P.Card, 12)
    b.TextColor3 = P.White
    b.LayoutOrder = i
    selectedButtons[entry.Id] = b
    b.Activated:Connect(function()
        current = entry.Id
        visualStage = 0
        preview()
    end)
end

for i, b in ipairs(stageButtons) do
    b.Activated:Connect(function()
        visualStage = i - 1
        preview()
    end)
end
rotateLeft.Activated:Connect(function()
    yaw -= math.rad(26)
    aimCamera()
end)
rotateRight.Activated:Connect(function()
    yaw += math.rad(26)
    aimCamera()
end)

local dragging = false
local lastX = 0
local lastInput: InputObject? = nil
viewport.InputBegan:Connect(function(input: InputObject)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        lastInput = input
        lastX = input.Position.X
    end
end)
viewport.InputEnded:Connect(function(input: InputObject)
    if input == lastInput or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        lastInput = nil
    end
end)
UserInputService.InputChanged:Connect(function(input: InputObject)
    if not dragging or not overlay.Visible then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or (input.UserInputType == Enum.UserInputType.Touch and input == lastInput) then
        local delta = input.Position.X - lastX
        yaw += math.rad(delta * 0.65)
        lastX = input.Position.X
        aimCamera()
    end
end)

local function resize()
    local view = Workspace.CurrentCamera
    if not view then return end
    local v = view.ViewportSize
    local portrait = v.Y > v.X
    local designW = if portrait then 372 else 800
    local designH = if portrait then 665 else 518
    window.Size = UDim2.fromOffset(designW, designH)
    windowScale.Scale = math.clamp(math.min(
        (v.X - 16) / designW, (v.Y - 18) / designH, 1
    ), 0.35, 1)
    if portrait then
        list.Position = UDim2.fromOffset(12, 66)
        list.Size = UDim2.fromOffset(349, 107)
        list.ScrollingDirection = Enum.ScrollingDirection.X
        list.AutomaticCanvasSize = Enum.AutomaticSize.X
        listLayout.FillDirection = Enum.FillDirection.Horizontal
        listLayout.Padding = UDim.new(0, 5)
        for _, b in pairs(selectedButtons) do
            b.Size = UDim2.fromOffset(111, 87)
        end
        viewport.Position = UDim2.fromOffset(12, 181)
        viewport.Size = UDim2.fromOffset(348, 276)
        previewFX.Position = UDim2.fromOffset(22, 415)
        previewFX.Size = UDim2.fromOffset(180, 31)
        infos.Position = UDim2.fromOffset(12, 466)
        infos.Size = UDim2.fromOffset(348, 125)
        heroName.Position = UDim2.fromOffset(10, 3)
        heroName.Size = UDim2.fromOffset(236, 29)
        heroName.TextSize = 16
        heroRarity.Position = UDim2.fromOffset(254, 3)
        heroRarity.Size = UDim2.fromOffset(85, 29)
        heroRarity.TextSize = 13
        obtaining.Position = UDim2.fromOffset(10, 33)
        obtaining.Size = UDim2.fromOffset(323, 17)
        obtaining.TextSize = 10
        passiveTitle.Position = UDim2.fromOffset(10, 51)
        passiveTitle.Size = UDim2.fromOffset(115, 22)
        passive.Position = UDim2.fromOffset(118, 51)
        passive.Size = UDim2.fromOffset(220, 22)
        passive.TextSize = 11
        attackTitle.Position = UDim2.fromOffset(10, 78)
        attackTitle.Size = UDim2.fromOffset(125, 22)
        attack.Position = UDim2.fromOffset(136, 76)
        attack.Size = UDim2.fromOffset(195, 37)
        attack.TextSize = 11
        infoNote.Visible = false
        footer.Position = UDim2.new(0, 0, 1, -67)
        footer.Size = UDim2.new(1, 0, 0, 67)
        for i, b in ipairs(stageButtons) do
            b.Position = UDim2.fromOffset(6 + (i-1)*91, 7)
            b.Size = UDim2.fromOffset(85, 26)
            b.TextSize = 10
        end
        rotateLeft.Position = UDim2.fromOffset(50, 37)
        rotateLeft.Size = UDim2.fromOffset(120, 25)
        rotateRight.Position = UDim2.fromOffset(203, 37)
        rotateRight.Size = UDim2.fromOffset(120, 25)
    else
        list.Position = UDim2.fromOffset(14, 78)
        list.Size = UDim2.fromOffset(177, 362)
        list.ScrollingDirection = Enum.ScrollingDirection.Y
        list.AutomaticCanvasSize = Enum.AutomaticSize.Y
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.Padding = UDim.new(0, 6)
        for _, b in pairs(selectedButtons) do
            b.Size = UDim2.new(1, -5, 0, 53)
        end
        viewport.Position = UDim2.fromOffset(206, 78)
        viewport.Size = UDim2.fromOffset(347, 362)
        previewFX.Position = UDim2.fromOffset(218, 393)
        previewFX.Size = UDim2.fromOffset(198, 35)
        infos.Position = UDim2.fromOffset(567, 78)
        infos.Size = UDim2.fromOffset(218, 362)
        heroName.Position = UDim2.fromOffset(12, 7)
        heroName.Size = UDim2.new(1, -24, 0, 55)
        heroName.TextSize = 21
        heroRarity.Position = UDim2.fromOffset(12, 66)
        heroRarity.Size = UDim2.new(1, -24, 0, 26)
        heroRarity.TextSize = 16
        obtaining.Position = UDim2.fromOffset(12, 101)
        obtaining.Size = UDim2.new(1, -24, 0, 40)
        obtaining.TextSize = 11
        passiveTitle.Position = UDim2.fromOffset(12, 146)
        passiveTitle.Size = UDim2.new(1, -24, 0, 23)
        passive.Position = UDim2.fromOffset(12, 166)
        passive.Size = UDim2.new(1, -24, 0, 55)
        passive.TextSize = 13
        attackTitle.Position = UDim2.fromOffset(12, 228)
        attackTitle.Size = UDim2.new(1, -24, 0, 22)
        attack.Position = UDim2.fromOffset(12, 250)
        attack.Size = UDim2.new(1, -24, 0, 54)
        attack.TextSize = 14
        infoNote.Visible = true
        footer.Position = UDim2.new(0, 0, 1, -67)
        footer.Size = UDim2.new(1, 0, 0, 67)
        for i, b in ipairs(stageButtons) do
            b.Position = UDim2.fromOffset(13 + (i-1)*143, 12)
            b.Size = UDim2.fromOffset(135, 44)
            b.TextSize = 13
        end
        rotateLeft.Position = UDim2.fromOffset(594, 12)
        rotateLeft.Size = UDim2.fromOffset(78, 44)
        rotateRight.Position = UDim2.fromOffset(686, 12)
        rotateRight.Size = UDim2.fromOffset(98, 44)
    end
end

local function bindCamera()
    local cam = Workspace.CurrentCamera
    if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
    resize()
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
bindCamera()

RunService.PreSimulation:Connect(function(_dt: number)
    if overlay.Visible and screen.Enabled and previewMotion then
        previewMotion:Update()
    end
end)

local function setOpen(value: boolean)
    overlay.Visible = value
    if value then
        preview()
    else
        dragging = false
        if previewMotion then previewMotion:Destroy(); previewMotion = nil end
        world:ClearAllChildren()
    end
end
toggle.Visible = player:GetAttribute("StudioLabsVisible") == true
player:GetAttributeChangedSignal("StudioLabsVisible"):Connect(function()
    toggle.Visible = player:GetAttribute("StudioLabsVisible") == true
    if not toggle.Visible then setOpen(false) end
end)
toggle.Activated:Connect(function()
    setOpen(not overlay.Visible)
end)
close.Activated:Connect(function()
    setOpen(false)
end)
player:GetAttributeChangedSignal("InArena"):Connect(function()
    screen.Enabled = player:GetAttribute("InArena") ~= true
    if not screen.Enabled then setOpen(false) end
end)

task.spawn(function()
    local folder = ReplicatedStorage:WaitForChild("OverlordTowerModels", 45)
    if folder and folder:IsA("Folder") then
        templates = folder
        if overlay.Visible then preview() end
    else
        warn("[Anime Fissure] OverlordModelGallery: pasta de modelos nao carregou")
    end
end)

print("[Anime Fissure] Model Lab Overlord v0.9 | ataque animado R6 e VFX por etapa")
