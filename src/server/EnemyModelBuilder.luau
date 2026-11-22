--!strict
-- ANIME FISSURE | EnemyModelBuilder v0.7 - Carne Village
-- Visual procedural separado de HP, waves e BossService.
-- Build(stats) e UpdateHealth(model, health, maxHealth) continuam compativeis.
-- Modelos estilizados em pecas nativas. MeshParts poderao substitui-los depois.

local Builder = {}
Builder.Version = "0.7.0"

type Stats = {[string]: any}

local PALETTE = {
    Skin = Color3.fromRGB(226, 194, 167),
    Steel = Color3.fromRGB(70, 77, 94),
    DarkSteel = Color3.fromRGB(32, 38, 54),
    Leather = Color3.fromRGB(91, 56, 42),
    Gold = Color3.fromRGB(246, 194, 95),
    White = Color3.fromRGB(242, 231, 207),
    Wine = Color3.fromRGB(124, 38, 52),
}

local function v(s: number, x: number, y: number, z: number): Vector3
    return Vector3.new(x * s, y * s, z * s)
end

local function cf(s: number, x: number, y: number, z: number, rx: number?, ry: number?, rz: number?): CFrame
    return CFrame.new(v(s, x, y, z)) * CFrame.Angles(
        math.rad(rx or 0), math.rad(ry or 0), math.rad(rz or 0)
    )
end

local function part(model: Model, name: string, size: Vector3, pose: CFrame,
    color: Color3, material: Enum.Material?, shape: Enum.PartType?): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = pose
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = name == "Body"
    p.CastShadow = true
    p.Material = material or Enum.Material.SmoothPlastic
    p.Color = color
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    if shape then p.Shape = shape end
    p.Parent = model
    return p
end

local function wedge(model: Model, name: string, size: Vector3, pose: CFrame,
    color: Color3, material: Enum.Material?): WedgePart
    local p = Instance.new("WedgePart")
    p.Name = name
    p.Size = size
    p.CFrame = pose
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = true
    p.Material = material or Enum.Material.SmoothPlastic
    p.Color = color
    p.Parent = model
    return p
end

-- Uma aura discreta no chao (segmentos horizontais, nao cilindro vertical).
local function aura(model: Model, s: number, color: Color3)
    local radius = 1.55 * s
    for i = 1, 12 do
        local a = (i - 1) * math.pi / 6
        local b = i * math.pi / 6
        local p1 = Vector3.new(math.cos(a) * radius, 0.09 * s, math.sin(a) * radius)
        local p2 = Vector3.new(math.cos(b) * radius, 0.09 * s, math.sin(b) * radius)
        local line = part(model, "AuraArc", Vector3.new(0.09 * s, 0.055 * s, (p2 - p1).Magnitude),
            CFrame.lookAt((p1 + p2) / 2, p2), color, Enum.Material.Neon)
        line.Transparency = 0.32
    end
end

local function face(model: Model, s: number, eyeColor: Color3, expression: string?)
    for _, side in ipairs({-1, 1}) do
        part(model, "AnimeEye", v(s, 0.38, 0.10, 0.045),
            cf(s, side * 0.34, 5.10, -0.68, 0, 0, side * -12),
            eyeColor, Enum.Material.SmoothPlastic)
        part(model, "AnimeBrow", v(s, 0.46, 0.075, 0.045),
            cf(s, side * 0.34, 5.32, -0.69, 0, 0, side * 13),
            PALETTE.DarkSteel, Enum.Material.SmoothPlastic)
    end
    part(model, "Mouth", v(s, 0.26, 0.055, 0.055), cf(s, 0, 4.73, -0.69),
        PALETTE.Leather, Enum.Material.SmoothPlastic)
    if expression == "Mask" then
        part(model, "FaceMask", v(s, 1.08, 0.40, 0.19), cf(s, 0, 4.79, -0.72),
            PALETTE.DarkSteel, Enum.Material.Fabric)
    end
end

local function humanoid(model: Model, s: number, coat: Color3, trim: Color3, slim: boolean?): BasePart
    local width = if slim then 1.58 else 1.98
    local root = part(model, "Body", v(s, width, 2.08, 1.10), cf(s, 0, 3.05, 0),
        coat, Enum.Material.Fabric)
    model.PrimaryPart = root
    part(model, "Neck", v(s, 0.56, 0.38, 0.55), cf(s, 0, 4.20, 0),
        PALETTE.Skin, Enum.Material.SmoothPlastic)
    part(model, "Head", v(s, 1.34, 1.40, 1.34), cf(s, 0, 5.00, 0),
        PALETTE.Skin, Enum.Material.SmoothPlastic, Enum.PartType.Ball)

    local armX = if slim then 1.13 else 1.35
    for _, side in ipairs({-1, 1}) do
        local arm = part(model, if side < 0 then "LeftArm" else "RightArm",
            v(s, if slim then 0.44 else 0.59, 1.82, 0.62),
            cf(s, side * armX, 3.10, 0, 0, 0, side * -6),
            coat, Enum.Material.Fabric)
        part(model, "Glove", v(s, 0.60, 0.52, 0.69),
            cf(s, side * (armX + 0.07), 2.24, -0.05),
            PALETTE.Leather, Enum.Material.Leather)
        part(model, "Cuff", v(s, 0.62, 0.20, 0.73),
            cf(s, side * (armX + 0.07), 2.65, 0), trim, Enum.Material.Metal)
    end
    for _, side in ipairs({-1, 1}) do
        part(model, if side < 0 then "LeftLeg" else "RightLeg",
            v(s, if slim then 0.57 else 0.69, 1.78, 0.75),
            cf(s, side * 0.47, 1.15, 0), PALETTE.DarkSteel, Enum.Material.Fabric)
        part(model, "Boot", v(s, 0.73, 0.53, 1.07), cf(s, side * 0.47, 0.38, -0.10),
            PALETTE.Leather, Enum.Material.Leather)
    end
    part(model, "Belt", v(s, width + 0.12, 0.25, 1.22), cf(s, 0, 2.30, 0),
        PALETTE.Leather, Enum.Material.Leather)
    part(model, "Buckle", v(s, 0.38, 0.32, 0.12), cf(s, 0, 2.30, -0.68),
        trim, Enum.Material.Metal)
    part(model, "ChestEmblem", v(s, 0.34, 0.65, 0.08), cf(s, 0, 3.30, -0.61),
        trim, Enum.Material.Metal)
    return root
end

local function shoulderArmor(model: Model, s: number, color: Color3, large: boolean?)
    for _, side in ipairs({-1, 1}) do
        wedge(model, "LayeredPauldron", v(s, if large then 1.32 else 0.96, 0.68, 1.20),
            cf(s, side * 1.19, 4.07, 0.03, 0, 0, side * 12),
            color, Enum.Material.Metal)
        part(model, "ShoulderStud", v(s, 0.23, 0.23, 0.23),
            cf(s, side * 1.50, 4.18, -0.35), PALETTE.Gold, Enum.Material.Metal,
            Enum.PartType.Ball)
    end
end

local function cape(model: Model, s: number, color: Color3, ornate: boolean?)
    for _, side in ipairs({-1, 1}) do
        wedge(model, "SplitCape", v(s, 1.18, if ornate then 3.0 else 2.5, 0.28),
            cf(s, side * 0.62, 2.38, 0.82, 12, 0, side * -8),
            color, Enum.Material.Fabric)
    end
    part(model, "CapeCollar", v(s, 1.86, 0.38, 1.44), cf(s, 0, 4.12, 0.16),
        color, Enum.Material.Fabric)
end

local function hair(model: Model, s: number, color: Color3, wild: boolean?)
    part(model, "HairCap", v(s, 1.46, 0.55, 1.48), cf(s, 0, 5.65, 0.02),
        color, Enum.Material.SmoothPlastic, Enum.PartType.Ball)
    for i = 1, (if wild then 7 else 4) do
        local angle = (i / (if wild then 7 else 4)) * math.pi * 2
        wedge(model, "HairSpike", v(s, 0.38, 0.76, 0.53),
            cf(s, math.sin(angle) * 0.55, 5.83, math.cos(angle) * 0.50,
                0, math.deg(angle), (i % 2 == 0 and -18 or 18)),
            color)
    end
end

local function sword(model: Model, s: number, color: Color3)
    part(model, "SwordHandle", v(s, 0.22, 0.87, 0.24),
        cf(s, 1.93, 2.53, -0.08, 0, 0, -12), PALETTE.Leather, Enum.Material.Wood)
    part(model, "SwordGuard", v(s, 0.88, 0.14, 0.28),
        cf(s, 2.07, 3.01, -0.10, 0, 0, -12), PALETTE.Gold, Enum.Material.Metal)
    wedge(model, "SwordBlade", v(s, 0.38, 2.0, 0.16),
        cf(s, 2.31, 4.07, -0.10, 0, 0, -12), color, Enum.Material.Metal)
end

local function armor(model: Model, s: number, color: Color3)
    part(model, "Breastplate", v(s, 1.93, 1.72, 0.34),
        cf(s, 0, 3.22, -0.65), color, Enum.Material.Metal)
    for _, side in ipairs({-1, 1}) do
        wedge(model, "SkirtArmor", v(s, 0.88, 1.26, 0.75),
            cf(s, side * 0.53, 1.91, -0.20, 0, 0, side * 8),
            color, Enum.Material.Metal)
    end
end

local function shield(model: Model, s: number, metal: Color3, glow: Color3)
    wedge(model, "KiteShield", v(s, 1.54, 2.3, 0.22),
        cf(s, -2.00, 3.0, -0.18, 0, 0, -8), metal, Enum.Material.Metal)
    part(model, "ShieldSigil", v(s, 0.54, 0.82, 0.12),
        cf(s, -2.02, 3.25, -0.36), glow, Enum.Material.Neon)
end

local function staff(model: Model, s: number, glow: Color3)
    part(model, "Staff", v(s, 0.18, 4.1, 0.18),
        cf(s, 1.87, 3.03, -0.16, 0, 0, -7), PALETTE.Leather, Enum.Material.Wood)
    part(model, "StaffGem", v(s, 0.72, 0.87, 0.72),
        cf(s, 2.12, 5.32, -0.16), glow, Enum.Material.Neon, Enum.PartType.Ball)
    for _, side in ipairs({-1, 1}) do
        part(model, "StaffProng", v(s, 0.18, 0.72, 0.23),
            cf(s, 2.12 + side * 0.44, 5.27, -0.16, 0, 0, side * -18),
            PALETTE.Gold, Enum.Material.Metal)
    end
end

local function halo(model: Model, s: number, color: Color3, radius: number?)
    local r = (radius or 1.13) * s
    for i = 1, 12 do
        local a = (i - 1) * math.pi / 6
        local b = i * math.pi / 6
        local p1 = Vector3.new(math.cos(a) * r, 6.66 * s, math.sin(a) * r)
        local p2 = Vector3.new(math.cos(b) * r, 6.66 * s, math.sin(b) * r)
        part(model, "HaloArc", v(s, 0.10, 0.10, (p2 - p1).Magnitude / s + 0.03),
            CFrame.lookAt((p1 + p2) / 2, p2), color, Enum.Material.Neon)
    end
end

local function wings(model: Model, s: number, feathersColor: Color3, royal: boolean?)
    local rows = if royal then 5 else 4
    for _, side in ipairs({-1, 1}) do
        part(model, "WingBone", v(s, 2.75, 0.23, 0.42),
            cf(s, side * 2.25, 4.20, 0.68, 0, 0, side * -17),
            feathersColor, Enum.Material.SmoothPlastic)
        for i = 1, rows do
            wedge(model, "Feather", v(s, 0.63, 1.63 + i * 0.13, 0.34),
                cf(s, side * (1.78 + i * 0.48), 3.76 - i * 0.09, 0.95,
                    -10, 0, side * (26 + i * 7)),
                feathersColor)
        end
    end
end

local function combatAppearance(model: Model, id: string, s: number, coat: Color3, accent: Color3)
    if id == "Invader" then
        humanoid(model, s, PALETTE.Wine, PALETTE.Gold)
        armor(model, s, Color3.fromRGB(111, 77, 73))
        shoulderArmor(model, s, PALETTE.Steel)
        face(model, s, Color3.fromRGB(38, 26, 31), "Mask")
        part(model, "IronHelmet", v(s, 1.49, 0.44, 1.35),
            cf(s, 0, 5.68, 0), PALETTE.DarkSteel, Enum.Material.Metal)
        sword(model, s, PALETTE.Steel)

    elseif id == "Scout" then
        humanoid(model, s, Color3.fromRGB(104, 99, 66), PALETTE.Gold, true)
        face(model, s, Color3.fromRGB(46, 45, 30), "Mask")
        hair(model, s, Color3.fromRGB(77, 50, 35), true)
        part(model, "Scarf", v(s, 1.55, 0.38, 1.22),
            cf(s, 0, 4.20, 0), Color3.fromRGB(174, 112, 59), Enum.Material.Fabric)
        wedge(model, "ScarfTail", v(s, 0.45, 1.27, 0.22),
            cf(s, -0.63, 3.58, 0.72, 16, 0, 12),
            Color3.fromRGB(174, 112, 59), Enum.Material.Fabric)
        sword(model, s, PALETTE.Steel)

    elseif id == "Armored" then
        humanoid(model, s, PALETTE.DarkSteel, PALETTE.Gold)
        armor(model, s, PALETTE.Steel)
        shoulderArmor(model, s, PALETTE.DarkSteel, true)
        face(model, s, PALETTE.Gold, "Mask")
        part(model, "HeavyHelm", v(s, 1.56, 0.91, 1.53),
            cf(s, 0, 5.61, 0), PALETTE.Steel, Enum.Material.Metal)
        shield(model, s, PALETTE.DarkSteel, accent)
        part(model, "WarHammerHandle", v(s, 0.22, 2.25, 0.21),
            cf(s, 2.00, 2.83, 0), PALETTE.Leather, Enum.Material.Wood)
        part(model, "WarHammer", v(s, 1.02, 0.86, 1.08),
            cf(s, 2.00, 4.13, 0), PALETTE.Steel, Enum.Material.Metal)

    elseif id == "WarAngel" then
        humanoid(model, s, PALETTE.White, PALETTE.Gold, true)
        face(model, s, PALETTE.Gold)
        hair(model, s, Color3.fromRGB(234, 210, 129))
        wings(model, s, PALETTE.White)
        halo(model, s, PALETTE.Gold)
        sword(model, s, PALETTE.Gold)

    elseif id == "CaptainInvader" then
        humanoid(model, s, Color3.fromRGB(78, 43, 54), PALETTE.Gold)
        armor(model, s, PALETTE.DarkSteel)
        shoulderArmor(model, s, Color3.fromRGB(108, 45, 53), true)
        face(model, s, Color3.fromRGB(80, 26, 30))
        hair(model, s, Color3.fromRGB(55, 37, 37), true)
        cape(model, s, Color3.fromRGB(133, 36, 48), true)
        sword(model, s, PALETTE.Gold)

    elseif id == "Nigun" then
        humanoid(model, s, PALETTE.White, PALETTE.Gold, true)
        face(model, s, Color3.fromRGB(64, 49, 44))
        hair(model, s, Color3.fromRGB(98, 84, 75))
        cape(model, s, Color3.fromRGB(238, 224, 191), true)
        part(model, "PriestFront", v(s, 1.53, 2.94, 0.21),
            cf(s, 0, 2.26, -0.56), PALETTE.White, Enum.Material.Fabric)
        for _, side in ipairs({-1, 1}) do
            part(model, "GoldenRobeTrim", v(s, 0.10, 2.75, 0.11),
                cf(s, side * 0.62, 2.2, -0.69), PALETTE.Gold, Enum.Material.Metal)
        end
        part(model, "SunEmblem", v(s, 0.58, 0.86, 0.16),
            cf(s, 0, 3.29, -0.74), PALETTE.Gold, Enum.Material.Metal)
        staff(model, s, PALETTE.Gold)

    elseif id == "DominionAuthority" then
        humanoid(model, s, PALETTE.White, PALETTE.Gold)
        face(model, s, PALETTE.Gold)
        armor(model, s, Color3.fromRGB(220, 204, 160))
        shoulderArmor(model, s, PALETTE.Gold, true)
        wings(model, s, Color3.fromRGB(244, 227, 176), true)
        halo(model, s, PALETTE.Gold, 1.35)
        sword(model, s, PALETTE.Gold)

    else
        humanoid(model, s, coat, accent)
        face(model, s, accent)
        hair(model, s, PALETTE.DarkSteel)
    end
end

local function healthGui(body: BasePart, displayName: string, boss: boolean, scale: number)
    local gui = Instance.new("BillboardGui")
    gui.Name = "EnemyHealthGui"
    gui.Adornee = body
    gui.Size = UDim2.fromOffset(if boss then 212 else 170, if boss then 66 else 56)
    gui.StudsOffsetWorldSpace = Vector3.new(0, 3.87 * scale, 0)
    gui.AlwaysOnTop = true
    gui.MaxDistance = 140
    gui.Parent = body

    local bg = Instance.new("Frame")
    bg.Name = "Background"
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(9, 13, 27)
    bg.BorderSizePixel = 0
    bg.BackgroundTransparency = 0.12
    bg.Parent = gui
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 7)
    corner.Parent = bg
    local outline = Instance.new("UIStroke")
    outline.Color = if boss then PALETTE.Gold else Color3.fromRGB(98, 155, 215)
    outline.Thickness = if boss then 2 else 1
    outline.Parent = bg

    local nameText = Instance.new("TextLabel")
    nameText.Name = "NameLabel"
    nameText.Text = displayName
    nameText.Size = UDim2.new(1, -12, 0, 23)
    nameText.Position = UDim2.fromOffset(6, 2)
    nameText.BackgroundTransparency = 1
    nameText.Font = Enum.Font.GothamBold
    nameText.TextScaled = true
    nameText.TextColor3 = if boss then PALETTE.Gold else PALETTE.White
    nameText.Parent = bg

    local track = Instance.new("Frame")
    track.Name = "HealthBackground"
    track.Size = UDim2.new(1, -18, 0, 9)
    track.Position = UDim2.new(0, 9, 0, 27)
    track.BackgroundColor3 = Color3.fromRGB(82, 38, 50)
    track.BorderSizePixel = 0
    track.Parent = bg
    local fill = Instance.new("Frame")
    fill.Name = "HealthFill"
    fill.Size = UDim2.fromScale(1, 1)
    fill.BackgroundColor3 = if boss then Color3.fromRGB(251, 174, 91) else Color3.fromRGB(77, 211, 142)
    fill.BorderSizePixel = 0
    fill.Parent = track

    local numbers = Instance.new("TextLabel")
    numbers.Name = "HealthText"
    numbers.Text = ""
    numbers.Position = UDim2.new(0, 9, 1, -20)
    numbers.Size = UDim2.new(1, -18, 0, 18)
    numbers.BackgroundTransparency = 1
    numbers.Font = Enum.Font.Gotham
    numbers.TextSize = 11
    numbers.TextColor3 = PALETTE.White
    numbers.Parent = bg
end

function Builder.UpdateHealth(model: Model, health: number, maxHealth: number)
    local safeMax = math.max(1, math.floor(maxHealth))
    local safeHealth = math.clamp(health, 0, safeMax)
    model:SetAttribute("Health", math.floor(safeHealth))
    model:SetAttribute("MaxHealth", safeMax)
    local body = model.PrimaryPart
    local gui = if body then body:FindFirstChild("EnemyHealthGui") else nil
    local bg = if gui then gui:FindFirstChild("Background") else nil
    if not bg then return end
    local track = bg:FindFirstChild("HealthBackground")
    local fill = if track then track:FindFirstChild("HealthFill") else nil
    local numbers = bg:FindFirstChild("HealthText")
    if fill and fill:IsA("Frame") then
        fill.Size = UDim2.fromScale(safeHealth / safeMax, 1)
    end
    if numbers and numbers:IsA("TextLabel") then
        numbers.Text = string.format("%d / %d", math.floor(safeHealth), safeMax)
    end
end

function Builder.Build(stats: Stats): Model
    local id = tostring(stats.Id or "Invader")
    local s = math.max(0.5, tonumber(stats.Size) or 1)
    local model = Instance.new("Model")
    model.Name = tostring(stats.Name or id)
    model:SetAttribute("EnemyId", id)
    model:SetAttribute("IsBoss", stats.Boss == true)
    model:SetAttribute("Air", stats.Air == true)
    model:SetAttribute("VisualVersion", Builder.Version)
    local baseColor = stats.Color or PALETTE.Wine
    local accent = stats.Accent or PALETTE.Gold
    combatAppearance(model, id, s, baseColor, accent)

    local isBoss = stats.Boss == true
    if isBoss or id == "WarAngel" or id == "DominionAuthority" then
        aura(model, s, accent)
    end

    local root = model.PrimaryPart
    assert(root ~= nil, "EnemyModelBuilder: modelo sem Body")
    healthGui(root, model.Name, isBoss, s)
    local maxHp = stats.MaxHealth or stats.Health or 100
    Builder.UpdateHealth(model, maxHp, maxHp)
    return model
end

return Builder
