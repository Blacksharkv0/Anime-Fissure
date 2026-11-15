--!strict
-- ANIME FISSURE | AlchemyWorkshop v0.1.0
-- Oficina de transmutacao no lobby principal.
-- Modelo de cenario procedural, sem menus ou crafting ainda.
-- Colocar em: src/server/AlchemyWorkshop.server.luau

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ServerStorage = game:GetService("ServerStorage")

local lobby = Workspace:WaitForChild("FissureLobby", 30)
if not lobby then
    warn("[Anime Fissure] Oficina: FissureLobby nao encontrado")
    return
end

-- O lobby original tem centro em (260, 0, 0), largura 110x110.
-- A oficina ocupa o lado direito, longe do spawn e do portal.
local ORIGIN = Vector3.new(293, 0, -6)
local workshopName = "AlchemyWorkshop"

local previous = lobby:FindFirstChild(workshopName)
if previous then
    previous:Destroy()
end

local workshop = Instance.new("Model")
workshop.Name = workshopName
workshop:SetAttribute("Version", "0.1.0")
workshop:SetAttribute("Role", "RelicAndOrbCrafting")
workshop.Parent = lobby

local C = {
    Stone = Color3.fromRGB(42, 46, 58),
    StoneLight = Color3.fromRGB(69, 74, 87),
    Wood = Color3.fromRGB(83, 56, 44),
    WoodDark = Color3.fromRGB(46, 31, 30),
    Roof = Color3.fromRGB(91, 36, 53),
    Metal = Color3.fromRGB(118, 125, 141),
    Gold = Color3.fromRGB(214, 175, 105),
    Blue = Color3.fromRGB(56, 123, 255),
    Cyan = Color3.fromRGB(82, 221, 240),
    Violet = Color3.fromRGB(156, 98, 245),
    Glass = Color3.fromRGB(98, 187, 215),
    Ink = Color3.fromRGB(18, 22, 34),
}

local function at(x: number, y: number, z: number): Vector3
    return ORIGIN + Vector3.new(x, y, z)
end

local function makePart(
    name: string,
    size: Vector3,
    cf: CFrame,
    color: Color3,
    material: Enum.Material,
    collision: boolean?
): Part
    local obj = Instance.new("Part")
    obj.Name = name
    obj.Size = size
    obj.CFrame = cf
    obj.Color = color
    obj.Material = material
    obj.Anchored = true
    obj.CanCollide = collision ~= false
    obj.CanTouch = false
    obj.CanQuery = collision ~= false
    obj.TopSurface = Enum.SurfaceType.Smooth
    obj.BottomSurface = Enum.SurfaceType.Smooth
    obj.Parent = workshop
    return obj
end

local function block(
    name: string,
    size: Vector3,
    x: number, y: number, z: number,
    color: Color3,
    material: Enum.Material,
    collision: boolean?
): Part
    return makePart(name, size, CFrame.new(at(x, y, z)), color, material, collision)
end

local function glow(parent: Instance, color: Color3, brightness: number, range: number)
    local light = Instance.new("PointLight")
    light.Color = color
    light.Brightness = brightness
    light.Range = range
    light.Shadows = false
    light.Parent = parent
end

local function cylinder(
    name: string,
    radius: number,
    height: number,
    x: number, y: number, z: number,
    color: Color3,
    material: Enum.Material,
    collision: boolean?
): Part
    -- O eixo de Cylinder e o X; rotacao alinha o cilindro na vertical.
    local p = makePart(
        name,
        Vector3.new(height, radius * 2, radius * 2),
        CFrame.new(at(x, y, z)) * CFrame.Angles(0, 0, math.pi / 2),
        color,
        material,
        collision
    )
    p.Shape = Enum.PartType.Cylinder
    return p
end

local function line(
    name: string,
    a: Vector3,
    b: Vector3,
    thickness: number,
    color: Color3
): Part
    local midpoint = (a + b) / 2
    return makePart(
        name,
        Vector3.new(thickness, thickness, (b - a).Magnitude),
        CFrame.lookAt(midpoint, b),
        color,
        Enum.Material.Neon,
        false
    )
end

-- 1 | BASE E ESCADA DE ENTRADA
local floor = block(
    "Floor", Vector3.new(34, 0.55, 28),
    0, 0.16, 0, C.Stone, Enum.Material.Slate
)
workshop.PrimaryPart = floor

block("EntryStep", Vector3.new(16, 0.25, 2.8),
    0, 0.1, 15, C.StoneLight, Enum.Material.Slate)

for _, x in ipairs({-16.1, 16.1}) do
    block("SideTrim", Vector3.new(0.45, 0.28, 27.5),
        x, 0.48, 0, C.Gold, Enum.Material.Metal, false)
end

for i = 1, 7 do
    local z = -11 + i * 3.1
    block("FloorInlay", Vector3.new(0.15, 0.04, 2.4),
        -9.5, 0.46, z, C.Gold, Enum.Material.Metal, false)
end

-- 2 | PAREDE BAIXA E COLUNAS: FRENTE ABERTA PARA O JOGADOR
block("BackWall", Vector3.new(33, 8, 0.9),
    0, 4.3, -13.2, C.StoneLight, Enum.Material.Slate)
for _, x in ipairs({-15.5, 15.5}) do
    block("BackColumn", Vector3.new(1.3, 11, 1.3),
        x, 5.6, -13, C.WoodDark, Enum.Material.Wood)
    block("FrontColumn", Vector3.new(1.1, 10, 1.1),
        x, 5.1, 12.6, C.WoodDark, Enum.Material.Wood)
    block("ColumnBand", Vector3.new(1.55, 0.4, 1.55),
        x, 8.9, 12.6, C.Gold, Enum.Material.Metal, false)
end

-- Meias paredes laterais mantem o espaco com aparencia de loja.
for _, x in ipairs({-16, 16}) do
    block("HalfWall", Vector3.new(0.8, 2.6, 12),
        x, 1.5, -6.5, C.StoneLight, Enum.Material.Slate)
end

-- 3 | COBERTURA PARCIAL: APENAS FUNDOS, SEM ESCONDER O CIRCULO
for _, side in ipairs({-1, 1}) do
    local x = side * 8.1
    local slope = -side * math.rad(17)
    makePart("RoofPanel", Vector3.new(17.8, 0.85, 13),
        CFrame.new(at(x, 11, -7.5)) * CFrame.Angles(0, 0, slope),
        C.Roof, Enum.Material.Slate)
end
block("RoofRidge", Vector3.new(1.2, 0.9, 14),
    0, 13.3, -7.5, C.Gold, Enum.Material.Metal, false)

-- 4 | LETREIRO DA OFICINA
local signAnchor = block("WorkshopSignAnchor", Vector3.new(0.5, 0.5, 0.5),
    0, 10, 9.7, C.Ink, Enum.Material.SmoothPlastic, false)
signAnchor.Transparency = 1
local signGui = Instance.new("BillboardGui")
signGui.Name = "WorkshopSign"
signGui.Size = UDim2.fromOffset(340, 90)
signGui.StudsOffset = Vector3.new(0, 1, 0)
signGui.MaxDistance = 70
signGui.AlwaysOnTop = true
signGui.Parent = signAnchor
local signText = Instance.new("TextLabel")
signText.Size = UDim2.fromScale(1, 1)
signText.BackgroundColor3 = C.Ink
signText.BackgroundTransparency = 0.18
signText.BorderSizePixel = 0
signText.Font = Enum.Font.GothamBold
signText.TextColor3 = C.Cyan
signText.TextStrokeTransparency = 0.6
signText.TextScaled = true
signText.Text = "OFICINA DE TRANSMUTACAO\nORBes  -  RELIQUIAS"
signText.Parent = signGui
local rounded = Instance.new("UICorner")
rounded.CornerRadius = UDim.new(0, 12)
rounded.Parent = signText
local outline = Instance.new("UIStroke")
outline.Color = C.Gold
outline.Thickness = 1.5
outline.Parent = signText

-- 5 | CIRCULO ALQUIMICO NO PISO
local runeCenter = at(-3.5, 0.48, 4.5)
local function makeRing(radius: number, segments: number, thickness: number, color: Color3)
    for i = 1, segments do
        local a = (i - 1) / segments * math.pi * 2
        local b = i / segments * math.pi * 2
        local first = runeCenter + Vector3.new(math.cos(a) * radius, 0, math.sin(a) * radius)
        local second = runeCenter + Vector3.new(math.cos(b) * radius, 0, math.sin(b) * radius)
        line("TransmutationRune", first, second, thickness, color)
    end
end
makeRing(4.6, 24, 0.12, C.Cyan)
makeRing(3.5, 20, 0.1, C.Blue)
for i = 1, 3 do
    local a = (i - 1) * math.pi * 2 / 3 - math.pi / 2
    local b = (i % 3) * math.pi * 2 / 3 - math.pi / 2
    line("InnerTriangle",
        runeCenter + Vector3.new(math.cos(a) * 3, 0, math.sin(a) * 3),
        runeCenter + Vector3.new(math.cos(b) * 3, 0, math.sin(b) * 3),
        0.1, C.Violet)
end
local core = cylinder("RuneCore", 0.65, 0.1,
    -3.5, 0.52, 4.5, C.Cyan, Enum.Material.Neon, false)
glow(core, C.Cyan, 0.65, 16)

-- 6 | BANCADA DE ALQUIMIA, SUPORTES E LIVRO
block("WorkbenchTop", Vector3.new(12, 0.65, 3.5),
    7.6, 3.0, -6.7, C.Wood, Enum.Material.WoodPlanks)
for _, x in ipairs({2.5, 12.7}) do
    for _, z in ipairs({-8, -5.3}) do
        block("WorkbenchLeg", Vector3.new(0.8, 2.6, 0.8),
            x, 1.65, z, C.WoodDark, Enum.Material.Wood)
    end
end
block("WorkbenchMetalEdge", Vector3.new(12.3, 0.18, 0.3),
    7.6, 3.37, -4.95, C.Metal, Enum.Material.Metal, false)
block("OpenAlchemyBook", Vector3.new(2.2, 0.22, 1.5),
    3.7, 3.48, -6.5, C.Gold, Enum.Material.SmoothPlastic, false)
for _, x in ipairs({3.25, 4.15}) do
    block("BookPage", Vector3.new(0.8, 0.035, 1.28),
        x, 3.62, -6.5, Color3.fromRGB(231, 213, 165),
        Enum.Material.SmoothPlastic, false)
end

-- 7 | FRASCOS E ESTANTE: OBJETOS PEQUENOS COM MATERIAL VIDRO
for level = 1, 3 do
    local y = 1.5 + (level - 1) * 2
    block("ShelfBoard", Vector3.new(8.5, 0.3, 2.1),
        -10.6, y, -9.5, C.Wood, Enum.Material.WoodPlanks)
    for i = 1, 4 do
        local px = -13.8 + (i - 1) * 2
        local potion = cylinder("AlchemyVial", 0.32, 0.85,
            px, y + 0.6, -9.5,
            (i % 2 == 0) and C.Cyan or C.Violet,
            Enum.Material.Glass, false)
        potion.Transparency = 0.2
        cylinder("VialCap", 0.24, 0.16,
            px, y + 1.12, -9.5, C.Metal, Enum.Material.Metal, false)
    end
end
for _, x in ipairs({-15.1, -6.2}) do
    block("ShelfSupport", Vector3.new(0.45, 6.9, 2.15),
        x, 3.6, -9.5, C.WoodDark, Enum.Material.Wood)
end

-- 8 | ALTO-FORNO ALQUIMICO AO LADO DO CIRCULO
cylinder("ForgeFoundation", 2.0, 0.65,
    11, 0.84, 3.2, C.Metal, Enum.Material.Metal)
cylinder("ForgeBowl", 1.5, 0.48,
    11, 1.48, 3.2, C.WoodDark, Enum.Material.Basalt)
local forgeGlow = cylinder("ForgeEnergy", 1.04, 0.12,
    11, 1.79, 3.2, C.Cyan, Enum.Material.Neon, false)
glow(forgeGlow, C.Cyan, 1.3, 14)

local floatCrystal = makePart(
    "FloatingCrystal", Vector3.new(1.3, 2.4, 1.3),
    CFrame.new(at(11, 3.4, 3.2)) * CFrame.Angles(0, 0, math.rad(45)),
    C.Cyan, Enum.Material.Neon, false
)
glow(floatCrystal, C.Cyan, 0.9, 14)

-- Animacao simples e barata: cristal oscila sobre o forno.
TweenService:Create(
    floatCrystal,
    TweenInfo.new(2.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {CFrame = floatCrystal.CFrame + Vector3.new(0, 0.55, 0)}
):Play()

-- 9 | ILUMINACAO QUENTE + BANNERS
for _, x in ipairs({-13, 13}) do
    local lantern = block("Lantern", Vector3.new(0.85, 1.25, 0.85),
        x, 6.8, 10.4, C.Gold, Enum.Material.Neon, false)
    glow(lantern, Color3.fromRGB(255, 186, 104), 0.95, 15)
    block("LanternHolder", Vector3.new(1.2, 0.22, 1.2),
        x, 7.5, 10.4, C.WoodDark, Enum.Material.Wood, false)
end
for _, x in ipairs({-15.3, 15.3}) do
    block("WorkshopBanner", Vector3.new(1.6, 4.4, 0.15),
        x, 6.5, 7, C.Roof, Enum.Material.Fabric, false)
    block("BannerTrim", Vector3.new(1.7, 0.15, 0.25),
        x, 4.2, 7, C.Gold, Enum.Material.Metal, false)
end

-- 10 | RESERVA EXATA DO LOCAL DO NPC (MODELO INSERIDO DEPOIS)
local npcSpot = block("AlchemistSpawn", Vector3.new(2, 0.1, 2),
    8, 0.48, -10.4, C.Cyan, Enum.Material.SmoothPlastic, false)
npcSpot.Transparency = 1
npcSpot:SetAttribute("Purpose", "NPCPlacement")

-- Se existir um NPC pronto em ServerStorage, ele e clonado automaticamente.
-- Modelo opcional: ServerStorage.AlchemistNPC
local sourceNPC = ServerStorage:FindFirstChild("AlchemistNPC")
if sourceNPC and sourceNPC:IsA("Model") then
    local npc = sourceNPC:Clone()
    npc.Name = "AlchemistNPC"
    npc.Parent = workshop
    npc:PivotTo(CFrame.new(at(8, 0.7, -10.4)) * CFrame.Angles(0, math.pi, 0))
end

workshop:SetAttribute("Ready", true)
print("[Anime Fissure] Oficina de Transmutacao pronta em FissureLobby")
