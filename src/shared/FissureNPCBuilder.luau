--!strict
-- ANIME FISSURE | FissureNPCBuilder v0.2
-- Virgil e Edward: personagens R6 estilizados feitos de pecas nativas,
-- com Motor6D e acessorios soldados. Nao depende de asset externo.
-- NPCs decorativos e interativos via prompts dos stands EXISTENTES.
local Builder = {}
Builder.Version = "0.2.0"

local C = {
    Skin = Color3.fromRGB(245, 199, 164),
    Shadow = Color3.fromRGB(24, 29, 46),
    Navy = Color3.fromRGB(34, 49, 105),
    Royal = Color3.fromRGB(52, 78, 150),
    Silver = Color3.fromRGB(222, 233, 249),
    Steel = Color3.fromRGB(134, 158, 192),
    Gold = Color3.fromRGB(246, 204, 108),
    Cyan = Color3.fromRGB(82, 224, 255),
    Purple = Color3.fromRGB(142, 79, 245),
    Red = Color3.fromRGB(207, 39, 58),
    RedDark = Color3.fromRGB(120, 29, 46),
    Black = Color3.fromRGB(29, 32, 45),
    Blonde = Color3.fromRGB(242, 205, 84),
    Brown = Color3.fromRGB(83, 61, 47),
    Eye = Color3.fromRGB(58, 138, 212),
}

local function part(parent: Instance, name: string, size: Vector3, cf: CFrame,
    color: Color3, material: Enum.Material?, shape: string?): BasePart
    local p: BasePart
    if shape == "Wedge" then
        p = Instance.new("WedgePart")
    else
        local q = Instance.new("Part")
        if shape == "Ball" then q.Shape = Enum.PartType.Ball end
        if shape == "Cylinder" then q.Shape = Enum.PartType.Cylinder end
        p = q
    end
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = false
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent
    return p
end

local function motor(parent: BasePart, target: BasePart, name: string, c0: CFrame, c1: CFrame)
    local m = Instance.new("Motor6D")
    m.Name = name
    m.Part0 = parent
    m.Part1 = target
    m.C0 = c0
    m.C1 = c1
    m.Parent = parent
    return m
end

local function attach(folder: Folder, limb: BasePart, name: string, sz: Vector3,
    rel: CFrame, color: Color3, material: Enum.Material?, shape: string?): BasePart
    local p = part(folder, name, sz, limb.CFrame * rel, color, material, shape)
    p.Massless = true
    local weld = Instance.new("WeldConstraint")
    weld.Name = "DetailWeld"
    weld.Part0 = limb
    weld.Part1 = p
    weld.Parent = p
    return p
end

local function addFace(head: BasePart, eyeColor: Color3)
    local s = Instance.new("SurfaceGui")
    s.Name = "AnimeFace"
    s.Face = Enum.NormalId.Front
    s.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    s.PixelsPerStud = 100
    s.LightInfluence = 0
    s.Parent = head
    local canvas = Instance.new("Frame")
    canvas.Size = UDim2.fromScale(1, 1)
    canvas.BackgroundTransparency = 1
    canvas.Parent = s
    for _, x in ipairs({0.24, 0.63}) do
        local brow = Instance.new("Frame")
        brow.Position = UDim2.fromScale(x, 0.25)
        brow.Size = UDim2.fromScale(0.14, 0.037)
        brow.BackgroundColor3 = C.Shadow
        brow.BorderSizePixel = 0
        brow.Rotation = if x < 0.5 then -12 else 12
        brow.Parent = canvas
        local eye = Instance.new("Frame")
        eye.Position = UDim2.fromScale(x, 0.39)
        eye.Size = UDim2.fromScale(0.15, 0.23)
        eye.BackgroundColor3 = Color3.fromRGB(250, 252, 255)
        eye.BorderSizePixel = 0
        eye.Parent = canvas
        local round = Instance.new("UICorner")
        round.CornerRadius = UDim.new(0.4, 0)
        round.Parent = eye
        local iris = Instance.new("Frame")
        iris.Position = UDim2.fromScale(0.33, 0.20)
        iris.Size = UDim2.fromScale(0.48, 0.73)
        iris.BackgroundColor3 = eyeColor
        iris.BorderSizePixel = 0
        iris.Parent = eye
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = iris
    end
    local smile = Instance.new("TextLabel")
    smile.BackgroundTransparency = 1
    smile.Position = UDim2.fromScale(0.42, 0.70)
    smile.Size = UDim2.fromScale(0.20, 0.16)
    smile.Text = "⌣"
    smile.TextColor3 = C.Shadow
    smile.TextScaled = true
    smile.Font = Enum.Font.GothamBold
    smile.Parent = canvas
end

local function nameplate(head: BasePart, name: string, role: string, accent: Color3)
    local gui = Instance.new("BillboardGui")
    gui.Name = "NPCNameplate"
    gui.Size = UDim2.fromOffset(185, 45)
    gui.StudsOffset = Vector3.new(0, 2.15, 0)
    gui.MaxDistance = 28
    gui.AlwaysOnTop = true
    gui.Parent = head
    local panel = Instance.new("Frame")
    panel.Size = UDim2.fromScale(1, 1)
    panel.BackgroundColor3 = C.Shadow
    panel.BackgroundTransparency = 0.22
    panel.BorderSizePixel = 0
    panel.Parent = gui
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = panel
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.55, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBlack
    label.TextColor3 = Color3.fromRGB(246, 249, 255)
    label.TextScaled = true
    label.Parent = panel
    local sub = Instance.new("TextLabel")
    sub.Position = UDim2.fromScale(0, 0.55)
    sub.Size = UDim2.fromScale(1, 0.35)
    sub.BackgroundTransparency = 1
    sub.Text = role
    sub.Font = Enum.Font.GothamBold
    sub.TextColor3 = accent
    sub.TextScaled = true
    sub.Parent = panel
end

local function rig(kind: string)
    local model = Instance.new("Model")
    model.Name = if kind == "Virgil" then "VirgilNPC" else "AlchemistNPC"
    model:SetAttribute("NPCId", kind)
    model:SetAttribute("BuilderVersion", Builder.Version)
    model:SetAttribute("R6", true)
    local metal = kind == "Virgil"
    local torsoColor = if metal then C.Navy else C.Black
    local root = part(model, "HumanoidRootPart", Vector3.new(2, 2, 1), CFrame.new(0, 3, 0), C.Shadow)
    root.Anchored = true
    root.Transparency = 1
    local torso = part(model, "Torso", Vector3.new(2, 2, 1), CFrame.new(0, 3, 0), torsoColor)
    local head = part(model, "Head", Vector3.new(2, 1, 1), CFrame.new(0, 4.5, 0), C.Skin)
    local la = part(model, "Left Arm", Vector3.new(1, 2, 1), CFrame.new(-1.5, 3, 0), if metal then C.Navy else C.Red)
    local ra = part(model, "Right Arm", Vector3.new(1, 2, 1), CFrame.new(1.5, 3, 0), if metal then C.Navy else C.Steel)
    local ll = part(model, "Left Leg", Vector3.new(1, 2, 1), CFrame.new(-0.5, 1, 0), C.Black)
    local rl = part(model, "Right Leg", Vector3.new(1, 2, 1), CFrame.new(0.5, 1, 0), C.Black)
    model.PrimaryPart = root
    motor(root, torso, "RootJoint", CFrame.new(), CFrame.new())
    motor(torso, head, "Neck", CFrame.new(0, 1, 0), CFrame.new(0, -0.5, 0))
    motor(torso, la, "Left Shoulder", CFrame.new(-1, 0.5, 0), CFrame.new(0.5, 0.5, 0))
    motor(torso, ra, "Right Shoulder", CFrame.new(1, 0.5, 0), CFrame.new(-0.5, 0.5, 0))
    motor(torso, ll, "Left Hip", CFrame.new(-0.5, -1, 0), CFrame.new(0, 1, 0))
    motor(torso, rl, "Right Hip", CFrame.new(0.5, -1, 0), CFrame.new(0, 1, 0))
    local h = Instance.new("Humanoid")
    h.RigType = Enum.HumanoidRigType.R6
    h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    h.AutoRotate = false
    h.BreakJointsOnDeath = false
    h.Parent = model
    local animator = Instance.new("Animator")
    animator.Parent = h
    local details = Instance.new("Folder")
    details.Name = "ModularAppearance"
    details.Parent = model
    addFace(head, if metal then C.Purple else C.Gold)
    nameplate(head, kind, if metal then "INVOCADOR" else "ALQUIMISTA", if metal then C.Purple else C.Gold)
    return model, details, {root = root, torso = torso, head = head, la = la, ra = ra, ll = ll, rl = rl}
end

local function virgil(details: Folder, r: {[string]: BasePart})
    local t, h = r.torso, r.head
    -- Mechas de cabelo prateado e repartido para tras.
    attach(details, h, "SilverHairCap", Vector3.new(2.10, 0.44, 1.16),
        CFrame.new(0, 0.52, 0), C.Silver, nil, "Ball")
    for i = -2, 2 do
        attach(details, h, "SilverHairStrand", Vector3.new(0.37, 0.83, 0.45),
            CFrame.new(i * 0.34, 0.28, -0.53) * CFrame.Angles(0, 0, math.rad(22 + i * 7)),
            C.Silver, nil, "Wedge")
    end
    for _, side in ipairs({-1, 1}) do
        attach(details, h, "SilverSideLocks", Vector3.new(0.43, 0.60, 0.65),
            CFrame.new(side * 0.99, 0.14, 0.14), C.Silver)
        attach(details, t, "LongCoatPanel", Vector3.new(0.88, 3.25, 0.22),
            CFrame.new(side * 0.60, -0.46, -0.61), C.Royal)
        attach(details, t, "CoatTail", Vector3.new(0.88, 2.2, 0.22),
            CFrame.new(side * 0.56, -1.84, 0.48), C.Navy)
        attach(details, t, "CoatTrim", Vector3.new(0.095, 2.05, 0.09),
            CFrame.new(side * 0.18, -0.17, -0.74), C.Gold, Enum.Material.Metal)
    end
    attach(details, t, "BlackVest", Vector3.new(0.67, 1.72, 0.13),
        CFrame.new(0, -0.05, -0.55), C.Black)
    attach(details, t, "RaisedCollar", Vector3.new(2.3, 0.42, 1.17),
        CFrame.new(0, 0.90, 0.05), C.Navy)
    attach(details, t, "SilverBelt", Vector3.new(2.12, 0.22, 1.11),
        CFrame.new(0, -0.83, 0), C.Steel, Enum.Material.Metal)
    for _, arm in ipairs({r.la, r.ra}) do
        attach(details, arm, "BlueSleeve", Vector3.new(1.08, 1.58, 1.1),
            CFrame.new(0, 0.18, 0), C.Royal)
        attach(details, arm, "Glove", Vector3.new(1.1, 0.62, 1.11),
            CFrame.new(0, -0.71, 0), C.Black)
    end
    for _, leg in ipairs({r.ll, r.rl}) do
        attach(details, leg, "HighBoot", Vector3.new(1.10, 0.91, 1.3),
            CFrame.new(0, -0.57, -0.10), C.Navy)
    end
    -- Espada embainhada atras: so decoracao, sem dano ou ferramenta de ataque.
    attach(details, t, "KatanaScabbard", Vector3.new(0.25, 3.6, 0.25),
        CFrame.new(0.53, -0.10, 0.76) * CFrame.Angles(0, 0, math.rad(-35)), C.Black, Enum.Material.Metal)
    attach(details, t, "KatanaGrip", Vector3.new(0.34, 1.09, 0.34),
        CFrame.new(-0.70, 1.37, 0.77) * CFrame.Angles(0, 0, math.rad(-35)), C.Silver)
    attach(details, t, "KatanaGuard", Vector3.new(0.8, 0.13, 0.34),
        CFrame.new(-0.48, 0.88, 0.77) * CFrame.Angles(0, 0, math.rad(-35)), C.Gold, Enum.Material.Metal)
    local aura = attach(details, t, "FissureEmblem", Vector3.new(0.43, 0.43, 0.13),
        CFrame.new(0, 0.38, -0.63) * CFrame.Angles(0, 0, math.rad(45)), C.Purple, Enum.Material.Neon)
    local light = Instance.new("PointLight")
    light.Color = C.Purple
    light.Range = 9
    light.Brightness = 0.45
    light.Parent = aura
end

local function edward(details: Folder, r: {[string]: BasePart})
    local t, h = r.torso, r.head
    attach(details, h, "GoldenHair", Vector3.new(2.10, 0.43, 1.15),
        CFrame.new(0, 0.52, 0), C.Blonde, nil, "Ball")
    for i = -2, 2 do
        attach(details, h, "GoldenBangs", Vector3.new(0.40, 0.77, 0.40),
            CFrame.new(i * 0.34, 0.24, -0.54) * CFrame.Angles(0, 0, math.rad(8 + i * 11)),
            C.Blonde, nil, "Wedge")
    end
    for i = 1, 5 do
        attach(details, h, "BlondeBraid", Vector3.new(0.42, 0.45, 0.42),
            CFrame.new(0.68, 0.05 - i * 0.32, 0.55), C.Blonde, nil, "Ball")
    end
    attach(details, t, "WhiteCollar", Vector3.new(1.54, 0.38, 1.10),
        CFrame.new(0, 0.85, 0), C.Silver)
    attach(details, t, "BlackUnderShirt", Vector3.new(1.20, 1.7, 0.15),
        CFrame.new(0, -0.05, -0.58), C.Black)
    for _, side in ipairs({-1, 1}) do
        attach(details, t, "RedCoatFront", Vector3.new(0.46, 2.3, 0.20),
            CFrame.new(side * 0.76, -0.40, -0.59), C.Red)
        attach(details, t, "RedCoatTail", Vector3.new(0.90, 2.35, 0.20),
            CFrame.new(side * 0.55, -1.70, 0.48), C.RedDark)
        attach(details, t, "SilverTrim", Vector3.new(0.08, 1.8, 0.10),
            CFrame.new(side * 0.48, -0.20, -0.74), C.Silver)
    end
    attach(details, r.la, "RedSleeve", Vector3.new(1.08, 1.60, 1.09),
        CFrame.new(0, 0.17, 0), C.Red)
    attach(details, r.la, "BlackGlove", Vector3.new(1.11, 0.60, 1.12),
        CFrame.new(0, -0.73, 0), C.Black)
    -- Braco mecanico (lado direito): metal com juntas e detalhes azuis.
    attach(details, r.ra, "AutomailArmor", Vector3.new(1.12, 1.9, 1.10),
        CFrame.new(0, 0, 0), C.Steel, Enum.Material.Metal)
    for _, y in ipairs({0.43, -0.10, -0.59}) do
        attach(details, r.ra, "AutomailJoint", Vector3.new(1.16, 0.15, 1.15),
            CFrame.new(0, y, 0), C.Silver, Enum.Material.Metal)
    end
    attach(details, r.ra, "AutomailGem", Vector3.new(0.26, 0.26, 0.12),
        CFrame.new(0, 0.2, -0.57), C.Cyan, Enum.Material.Neon)
    attach(details, t, "BrownBelt", Vector3.new(2.12, 0.24, 1.14),
        CFrame.new(0, -0.83, 0), C.Brown)
    for _, leg in ipairs({r.ll, r.rl}) do
        attach(details, leg, "BrownBoot", Vector3.new(1.1, 0.83, 1.27),
            CFrame.new(0, -0.60, -0.10), C.Brown)
    end
    local alchemy = attach(details, t, "AlchemyInsignia", Vector3.new(0.42, 0.42, 0.12),
        CFrame.new(0.67, 0.39, -0.70) * CFrame.Angles(0, 0, math.rad(45)), C.Gold, Enum.Material.Neon)
    local light = Instance.new("PointLight")
    light.Color = C.Gold
    light.Range = 7
    light.Brightness = 0.30
    light.Parent = alchemy
end

function Builder.Build(kind: string): Model?
    if kind ~= "Virgil" and kind ~= "Edward" then return nil end
    local model, details, body = rig(kind)
    if kind == "Virgil" then virgil(details, body) else edward(details, body) end
    return model
end

return Builder
