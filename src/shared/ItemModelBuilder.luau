--!strict
-- ANIME FISSURE | ItemModelBuilder v0.1.0
-- Cinco modelos 3D reutilizaveis, feitos somente com objetos nativos Roblox.
-- Sem IDs de assets, plugins, APIs externas ou dependencias de inventario.
-- Cada Model tem ItemId, Category, PrimaryPart e pode ser clonado/PivotTo.

local ItemModelBuilder = {}
ItemModelBuilder.Version = "0.1.0"

local GOLD = Color3.fromRGB(240, 183, 71)
local DEEP = Color3.fromRGB(25, 30, 53)
local METAL = Color3.fromRGB(145, 153, 174)
local BLUE = Color3.fromRGB(59, 161, 255)
local CYAN = Color3.fromRGB(74, 222, 255)
local VIOLET = Color3.fromRGB(168, 76, 255)
local WHITE = Color3.fromRGB(225, 234, 248)
local RED = Color3.fromRGB(230, 55, 72)

local function part(
    model: Model,
    name: string,
    size: Vector3,
    cf: CFrame,
    color: Color3,
    material: Enum.Material,
    transparency: number?,
    shape: Enum.PartType?
): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = material
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = material ~= Enum.Material.Neon
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Transparency = transparency or 0
    if shape then p.Shape = shape end
    p.Parent = model
    return p
end

local function block(model: Model, name: string, pos: Vector3, size: Vector3,
    color: Color3, material: Enum.Material, transparency: number?): Part
    return part(model, name, size, CFrame.new(pos), color, material, transparency)
end

local function ball(model: Model, name: string, pos: Vector3, diameter: number,
    color: Color3, material: Enum.Material, transparency: number?): Part
    return part(model, name, Vector3.new(diameter, diameter, diameter),
        CFrame.new(pos), color, material, transparency, Enum.PartType.Ball)
end

local function cylinder(model: Model, name: string, pos: Vector3,
    height: number, diameter: number, color: Color3,
    material: Enum.Material, transparency: number?): Part
    return part(model, name, Vector3.new(height, diameter, diameter),
        CFrame.new(pos) * CFrame.Angles(0, 0, math.pi / 2),
        color, material, transparency, Enum.PartType.Cylinder)
end

local function beam(model: Model, name: string, a: Vector3, b: Vector3,
    width: number, color: Color3, material: Enum.Material): Part
    local mid = (a + b) * 0.5
    return part(model, name, Vector3.new(width, width, (b - a).Magnitude),
        CFrame.lookAt(mid, b), color, material)
end

local function lamp(parent: BasePart, color: Color3, range: number, brightness: number)
    local light = Instance.new("PointLight")
    light.Color = color
    light.Range = range
    light.Brightness = brightness
    light.Shadows = false
    light.Parent = parent
end

local function billboardText(parent: Part, value: string, color: Color3)
    -- Usado apenas como detalhe de superficie: elemento nativo do Roblox.
    local ui = Instance.new("SurfaceGui")
    ui.Name = "Insignia"
    ui.Face = Enum.NormalId.Front
    ui.AlwaysOnTop = false
    ui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    ui.PixelsPerStud = 90
    ui.Parent = parent
    local text = Instance.new("TextLabel")
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.Text = value
    text.Font = Enum.Font.GothamBlack
    text.TextScaled = true
    text.TextColor3 = color
    text.TextStrokeColor3 = DEEP
    text.TextStrokeTransparency = 0.4
    text.Parent = ui
end

local function start(name: string, category: string): Model
    local model = Instance.new("Model")
    model.Name = name
    model:SetAttribute("ItemId", name)
    model:SetAttribute("Category", category)
    model:SetAttribute("BuilderVersion", ItemModelBuilder.Version)
    -- PrimaryPart na origem permite clone:PivotTo(CFrame.new(...)).
    local root = block(model, "Pivot", Vector3.zero,
        Vector3.new(0.2, 0.2, 0.2), DEEP, Enum.Material.SmoothPlastic, 1)
    model.PrimaryPart = root
    return model
end

local function moneyCapsule(): Model
    -- Cilindro vertical metalico + nucleo de vidro: elegante e legivel em Roblox.
    local model = start("DB_MoneyCapsule", "Relic")
    model:SetAttribute("DisplayName", "Money Capsule")
    model:SetAttribute("Rarity", "Legendary")
    cylinder(model, "MainShell", Vector3.new(0, 2.15, 0), 3.55, 2.35,
        WHITE, Enum.Material.Metal)
    cylinder(model, "GlowingCoreGlass", Vector3.new(0, 2.18, 0), 1.85, 2.39,
        CYAN, Enum.Material.Glass, 0.54)
    cylinder(model, "CoreEnergy", Vector3.new(0, 2.18, 0), 1.55, 1.28,
        BLUE, Enum.Material.Neon, 0.24)
    cylinder(model, "TopCap", Vector3.new(0, 4.05, 0), 0.5, 2.6,
        DEEP, Enum.Material.Metal)
    cylinder(model, "BottomCap", Vector3.new(0, 0.28, 0), 0.55, 2.6,
        DEEP, Enum.Material.Metal)
    cylinder(model, "UpperGoldBand", Vector3.new(0, 3.72, 0), 0.2, 2.72,
        GOLD, Enum.Material.Metal)
    cylinder(model, "LowerGoldBand", Vector3.new(0, 0.65, 0), 0.2, 2.72,
        GOLD, Enum.Material.Metal)
    cylinder(model, "TopPowerLED", Vector3.new(0, 4.34, 0), 0.08, 1.33,
        CYAN, Enum.Material.Neon)
    for i = 0, 3 do
        local a = i * math.pi / 2 + math.pi / 4
        local x, z = math.cos(a) * 1.25, math.sin(a) * 1.25
        block(model, "GoldBracket", Vector3.new(x, 2.2, z),
            Vector3.new(0.28, 2.0, 0.28), GOLD, Enum.Material.Metal)
    end
    -- Moedas dentro do cilindro; visiveis pelo vidro.
    for i = 1, 3 do
        cylinder(model, "FloatingYenCoin", Vector3.new(-0.14 + i * 0.13, 1.52 + i * 0.42, -0.39),
            0.1, 0.72, GOLD, Enum.Material.Neon)
    end
    local face = block(model, "FrontInsignia", Vector3.new(0, 2.27, -1.37),
        Vector3.new(1.1, 1.05, 0.08), DEEP, Enum.Material.Metal)
    billboardText(face, "¥", GOLD)
    lamp(face, BLUE, 9, 0.9)
    return model
end

local function dragonFragment(): Model
    -- Fragmento rubi/laranja: o mesmo material pode aparecer em muitos sistemas.
    local model = start("DragonFragment", "Material")
    model:SetAttribute("DisplayName", "Fragmento do Dragao")
    local core = part(model, "DragonCore", Vector3.new(0.95, 2.8, 1.15),
        CFrame.new(0, 2.0, 0) * CFrame.Angles(0, 0, math.rad(21)),
        RED, Enum.Material.Glass, 0.16)
    lamp(core, Color3.fromRGB(255, 82, 34), 8, 0.7)
    local spikes: {{pos: Vector3, angle: number, length: number}} = {
        {pos = Vector3.new(-0.7, 1.5, 0.0), angle = math.rad(-27), length = 1.6},
        {pos = Vector3.new(0.75, 1.3, 0.05), angle = math.rad(33), length = 1.9},
        {pos = Vector3.new(-0.3, 3.1, -0.1), angle = math.rad(16), length = 1.5},
        {pos = Vector3.new(0.5, 2.65, 0.3), angle = math.rad(-19), length = 1.2},
    }
    for i, item in ipairs(spikes) do
        part(model, "SharpFacet" .. i, Vector3.new(0.45, item.length, 0.6),
            CFrame.new(item.pos) * CFrame.Angles(0, 0, item.angle),
            i % 2 == 0 and Color3.fromRGB(255, 119, 39) or Color3.fromRGB(231, 37, 64),
            Enum.Material.Glass, 0.13)
    end
    beam(model, "DragonVein", Vector3.new(-0.12, 0.82, -0.63),
        Vector3.new(0.17, 3.1, -0.63), 0.11, Color3.fromRGB(255, 174, 70), Enum.Material.Neon)
    ball(model, "InnerFlare", Vector3.new(0, 1.8, -0.68), 0.4,
        Color3.fromRGB(255, 110, 43), Enum.Material.Neon)
    return model
end

local function dragonBall(): Model
    local model = start("DragonBall1Star", "Material")
    model:SetAttribute("DisplayName", "Esfera do Dragao - 1 Estrela")
    local orange = Color3.fromRGB(255, 160, 23)
    local orb = ball(model, "AmberOrb", Vector3.new(0, 1.75, 0), 2.65,
        orange, Enum.Material.Glass, 0.16)
    ball(model, "InnerLight", Vector3.new(0, 1.75, 0), 2.2,
        Color3.fromRGB(254, 129, 20), Enum.Material.Neon, 0.63)
    local starPlate = block(model, "StarFront", Vector3.new(0, 1.75, -1.34),
        Vector3.new(0.95, 0.95, 0.06), orange, Enum.Material.Glass, 1)
    billboardText(starPlate, "★", Color3.fromRGB(190, 27, 33))
    -- Pequeno brilho no vidro para dar leitura de esfera.
    ball(model, "SpecularShine", Vector3.new(-0.47, 2.28, -1.05), 0.38,
        WHITE, Enum.Material.Neon, 0.53)
    lamp(orb, orange, 7, 0.5)
    return model
end

local function richSoul(): Model
    -- Versao espiritual roxa: nucleo redondo e chamas esculpidas com pecas nativas.
    local model = start("RichSoul", "Material")
    model:SetAttribute("DisplayName", "Rich Soul")
    local soul = ball(model, "SoulCore", Vector3.new(0, 1.7, 0), 1.9,
        VIOLET, Enum.Material.Glass, 0.28)
    ball(model, "InnerSoul", Vector3.new(0, 1.7, 0), 1.22,
        Color3.fromRGB(215, 104, 255), Enum.Material.Neon, 0.1)
    ball(model, "SpiritEye", Vector3.new(0, 1.74, -0.93), 0.37,
        WHITE, Enum.Material.Neon, 0.18)
    for i = 1, 5 do
        local a = i * math.pi * 2 / 5
        local x, z = math.cos(a), math.sin(a)
        local base = Vector3.new(x * 0.73, 2.19, z * 0.73)
        local tip = Vector3.new(x * 0.37, 3.65 + (i % 2) * 0.33, z * 0.37)
        beam(model, "SpiritFlame" .. i, base, tip, 0.18,
            i % 2 == 0 and CYAN or VIOLET, Enum.Material.Neon)
        ball(model, "FlameTip" .. i, tip, 0.23, VIOLET, Enum.Material.Neon)
    end
    -- Halo de energia em anel angular em torno da alma.
    for i = 0, 11 do
        local a = 2 * math.pi * i / 12
        local b = 2 * math.pi * (i + 1) / 12
        beam(model, "SoulOrbit", Vector3.new(math.cos(a) * 1.43, 1.73, math.sin(a) * 1.43),
            Vector3.new(math.cos(b) * 1.43, 1.73, math.sin(b) * 1.43),
            0.09, GOLD, Enum.Material.Neon)
    end
    lamp(soul, VIOLET, 8, 0.9)
    return model
end

local function dragonRadar(): Model
    -- Radar de mao original: formato compacto com tela e detalhes em 3D.
    local model = start("DragonRadar", "Material")
    model:SetAttribute("DisplayName", "Radar do Dragao")
    block(model, "RadarHousing", Vector3.new(0, 1.65, 0.06),
        Vector3.new(2.55, 2.8, 0.64), DEEP, Enum.Material.Metal)
    block(model, "SilverFront", Vector3.new(0, 1.73, -0.31),
        Vector3.new(2.15, 2.4, 0.12), METAL, Enum.Material.Metal)
    local screen = block(model, "GreenRadarScreen", Vector3.new(0, 1.91, -0.41),
        Vector3.new(1.86, 1.63, 0.11), Color3.fromRGB(8, 84, 42), Enum.Material.Glass, 0.12)
    block(model, "ScreenInnerGlow", Vector3.new(0, 1.91, -0.483),
        Vector3.new(1.55, 1.33, 0.03), Color3.fromRGB(21, 154, 66), Enum.Material.Neon, 0.42)
    for i = -2, 2 do
        beam(model, "GridVertical", Vector3.new(i * 0.29, 1.23, -0.52),
            Vector3.new(i * 0.29, 2.59, -0.52),
            0.025, Color3.fromRGB(112, 245, 117), Enum.Material.Neon)
        beam(model, "GridHorizontal", Vector3.new(-0.82, 1.9 + i * 0.25, -0.52),
            Vector3.new(0.82, 1.9 + i * 0.25, -0.52),
            0.025, Color3.fromRGB(112, 245, 117), Enum.Material.Neon)
    end
    local target = ball(model, "RadarSignal", Vector3.new(0.22, 2.11, -0.57),
        0.2, Color3.fromRGB(255, 222, 83), Enum.Material.Neon)
    lamp(target, Color3.fromRGB(72, 255, 121), 5, 0.3)
    for _, x in ipairs({-1.17, 1.17}) do
        block(model, "GoldSideGrip", Vector3.new(x, 1.63, 0.08),
            Vector3.new(0.16, 2.3, 0.78), GOLD, Enum.Material.Metal)
    end
    ball(model, "RedButton", Vector3.new(0.7, 0.68, -0.47),
        0.28, RED, Enum.Material.Neon)
    part(model, "Antenna", Vector3.new(0.15, 1.25, 0.15),
        CFrame.new(0.8, 3.15, 0.2) * CFrame.Angles(0, 0, math.rad(-20)),
        METAL, Enum.Material.Metal)
    ball(model, "AntennaTip", Vector3.new(1.02, 3.7, 0.2), 0.24,
        CYAN, Enum.Material.Neon)
    return model
end

local definitions = {
    DB_MoneyCapsule = moneyCapsule,
    DragonFragment = dragonFragment,
    DragonBall1Star = dragonBall,
    RichSoul = richSoul,
    DragonRadar = dragonRadar,
}

function ItemModelBuilder.BuildOne(itemId: string): Model?
    local maker = definitions[itemId]
    if not maker then return nil end
    return maker()
end

function ItemModelBuilder.BuildAll(parent: Instance): Folder
    local previous = parent:FindFirstChild("ItemModels")
    if previous then previous:Destroy() end
    local folder = Instance.new("Folder")
    folder.Name = "ItemModels"
    folder.Parent = parent
    for itemId, maker in pairs(definitions) do
        local model = maker()
        model.Name = itemId
        model.Parent = folder
    end
    return folder
end

function ItemModelBuilder.GetIds(): {string}
    return {"DB_MoneyCapsule", "DragonFragment", "DragonBall1Star", "RichSoul", "DragonRadar"}
end

return ItemModelBuilder
