--!strict
-- ANIME FISSURE | Carne Village Map v0.7
-- Mapa 01 de Overlord: vilarejo rural, campo, estradas, casas e ataque.
-- Preserva nomes exigidos por EnemyService, BetaLobby e ArenaCombatVisuals:
-- Workspace.FissureArena.EnemyPath.Waypoint_XX (Order, +2Y)
-- Workspace.FissureArena.FissureBase.BaseCore
-- Workspace.FissureArena.PlayerSpawns.PlayerSpawn_X
-- Workspace.FissureArena.FissurePortal

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local MAP_NAME = "FissureArena"
local rng = Random.new(1741)

local C = {
    Grass = Color3.fromRGB(89, 124, 67),
    GrassDark = Color3.fromRGB(58, 97, 58),
    Leaf = Color3.fromRGB(67, 119, 63),
    LeafLight = Color3.fromRGB(120, 154, 81),
    Dirt = Color3.fromRGB(128, 97, 69),
    Path = Color3.fromRGB(156, 129, 97),
    Stone = Color3.fromRGB(124, 120, 114),
    PaleStone = Color3.fromRGB(179, 169, 145),
    Timber = Color3.fromRGB(93, 67, 49),
    TimberLight = Color3.fromRGB(139, 103, 70),
    Plaster = Color3.fromRGB(216, 194, 153),
    Roof = Color3.fromRGB(121, 76, 58),
    RoofAlt = Color3.fromRGB(91, 63, 57),
    Straw = Color3.fromRGB(207, 178, 104),
    Iron = Color3.fromRGB(69, 69, 70),
    Portal = Color3.fromRGB(146, 92, 206),
    PortalGlow = Color3.fromRGB(214, 166, 240),
    Core = Color3.fromRGB(108, 192, 219),
}

local old = Workspace:FindFirstChild(MAP_NAME)
if old then old:Destroy() end
local arena = Instance.new("Model")
arena.Name = MAP_NAME
arena.Parent = Workspace

local function group(parent: Instance, name: string): Model
    local m = Instance.new("Model")
    m.Name = name
    m.Parent = parent
    return m
end

local function piece(parent: Instance, name: string, size: Vector3, pose: CFrame,
    color: Color3, material: Enum.Material?, collision: boolean?): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = pose
    p.Material = material or Enum.Material.SmoothPlastic
    p.Color = color
    p.Anchored = true
    p.CanCollide = collision == true
    p.CanTouch = false
    p.CanQuery = collision == true
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent
    return p
end

local function wedge(parent: Instance, name: string, size: Vector3, pose: CFrame,
    color: Color3, material: Enum.Material?): WedgePart
    local p = Instance.new("WedgePart")
    p.Name = name
    p.Size = size
    p.CFrame = pose
    p.Material = material or Enum.Material.SmoothPlastic
    p.Color = color
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.Parent = parent
    return p
end

local function orb(parent: Instance, name: string, pos: Vector3, size: Vector3,
    color: Color3, material: Enum.Material?): Part
    local p = piece(parent, name, size, CFrame.new(pos), color, material)
    p.Shape = Enum.PartType.Ball
    return p
end

local function beam(parent: Instance, name: string, a: Vector3, b: Vector3,
    width: number, height: number, color: Color3, material: Enum.Material?)
    local d = b - a
    return piece(parent, name, Vector3.new(width, height, d.Magnitude),
        CFrame.lookAt((a + b) / 2, b), color, material)
end

local function light(parent: Instance, color: Color3, brightness: number, range: number)
    local obj = Instance.new("PointLight")
    obj.Color = color
    obj.Brightness = brightness
    obj.Range = range
    obj.Shadows = false
    obj.Parent = parent
end

local function sign(parent: Instance, anchor: BasePart, title: string, subtitle: string,
    color: Color3)
    local board = Instance.new("BillboardGui")
    board.Name = "LocationSign"
    board.Adornee = anchor
    board.Size = UDim2.fromOffset(285, 66)
    board.StudsOffsetWorldSpace = Vector3.new(0, 5, 0)
    board.AlwaysOnTop = true
    board.MaxDistance = 160
    board.Parent = parent
    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(33, 27, 23)
    bg.BackgroundTransparency = 0.20
    bg.BorderSizePixel = 0
    bg.Parent = board
    local cr = Instance.new("UICorner")
    cr.CornerRadius = UDim.new(0, 7)
    cr.Parent = bg
    local t = Instance.new("TextLabel")
    t.BackgroundTransparency = 1
    t.Position = UDim2.fromScale(0.03, 0.04)
    t.Size = UDim2.fromScale(0.94, 0.51)
    t.Font = Enum.Font.GothamBold
    t.Text = title
    t.TextColor3 = color
    t.TextScaled = true
    t.Parent = bg
    local desc = Instance.new("TextLabel")
    desc.BackgroundTransparency = 1
    desc.Position = UDim2.fromScale(0.03, 0.59)
    desc.Size = UDim2.fromScale(0.94, 0.31)
    desc.Font = Enum.Font.Gotham
    desc.Text = subtitle
    desc.TextScaled = true
    desc.TextColor3 = Color3.fromRGB(233, 220, 199)
    desc.Parent = bg
end

-- TERRENO RURAL (superficie jogavel em Y=0)
local landscape = group(arena, "CarneTerrain")
piece(landscape, "VillageMeadow", Vector3.new(180, 5, 130),
    CFrame.new(0, -2.5, 0), C.Grass, Enum.Material.Grass, true)
piece(landscape, "EarthFoundation", Vector3.new(183, 12, 133),
    CFrame.new(0, -10, 0), C.Dirt, Enum.Material.Ground, true)
for _, z in ipairs({-81, 81}) do
    piece(landscape, "OuterMeadow", Vector3.new(260, 5, 37),
        CFrame.new(0, -2.55, z), C.GrassDark, Enum.Material.Grass, true)
end
for _, x in ipairs({-112, 112}) do
    piece(landscape, "OuterMeadow", Vector3.new(49, 5, 165),
        CFrame.new(x, -2.55, 0), C.GrassDark, Enum.Material.Grass, true)
end

-- PATH ORIGINAL: os mesmos 8 pontos preservam o combate atual.
local pathFolder = Instance.new("Folder")
pathFolder.Name = "EnemyPath"
pathFolder.Parent = arena
local waypoints = {
    Vector3.new(-72, 0, 0),
    Vector3.new(-48, 0, 0),
    Vector3.new(-48, 0, -32),
    Vector3.new(-12, 0, -32),
    Vector3.new(-12, 0, 25),
    Vector3.new(35, 0, 25),
    Vector3.new(35, 0, 0),
    Vector3.new(68, 0, 0),
}

local villageRoads = group(arena, "VillageRoads")
for i, position in ipairs(waypoints) do
    local marker = piece(pathFolder, string.format("Waypoint_%02d", i),
        Vector3.new(0.7, 0.7, 0.7), CFrame.new(position + Vector3.new(0, 2, 0)),
        C.Path)
    marker.Transparency = 1
    marker.CanQuery = false
    marker:SetAttribute("Order", i)
end
for i = 1, #waypoints - 1 do
    local a = waypoints[i]
    local b = waypoints[i + 1]
    local line = beam(villageRoads, "Road_" .. i,
        a + Vector3.new(0, 0.13, 0), b + Vector3.new(0, 0.13, 0),
        12, 0.25, C.Path, Enum.Material.Ground)
    line.CanCollide = false
    local length = (b - a).Magnitude
    for n = 1, math.floor(length / 3.6) do
        local alpha = n * 3.6 / length
        local start = a:Lerp(b, alpha)
        local normal = line.CFrame.RightVector
        for _, side in ipairs({-1, 1}) do
            local offset = normal * side * 5.6
            local pebble = orb(villageRoads, "RoadStone",
                start + offset + Vector3.new(0, 0.12, 0),
                Vector3.new(rng:NextNumber(0.7, 1.4), 0.20, rng:NextNumber(0.8, 1.7)),
                C.Stone, Enum.Material.Cobblestone)
            pebble.CanCollide = false
        end
    end
end

local buildings = group(arena, "TimberHomes")
local housePositions: {{number}} = {
    {-73, -44, 1}, {-27, -51, 0}, {18, -51, 1}, {59, -49, 0},
    {-75, 44, 0}, {-35, 46, 1}, {57, 48, 0}, {79, 44, 1},
}

local function house(index: number, x: number, z: number, angled: boolean)
    local h = group(buildings, "House_" .. index)
    local w = if index % 3 == 0 then 15 else 13
    local d = if index % 2 == 0 then 12 else 14
    local height = if index % 3 == 0 then 9.8 else 8.7
    local origin = CFrame.new(x, 0, z) * CFrame.Angles(0, if angled then math.rad(13) else 0, 0)
    local function place(name: string, size: Vector3, offset: Vector3,
        color: Color3, material: Enum.Material?, solid: boolean?)
        return piece(h, name, size, origin * CFrame.new(offset), color, material, solid)
    end
    place("StoneBase", Vector3.new(w + 1.1, 0.85, d + 1.1),
        Vector3.new(0, 0.40, 0), C.Stone, Enum.Material.Cobblestone, true)
    place("PlasterHouse", Vector3.new(w, height - 0.8, d),
        Vector3.new(0, height / 2, 0), C.Plaster, Enum.Material.Plaster, true)
    for _, side in ipairs({-1, 1}) do
        for _, zSide in ipairs({-1, 1}) do
            place("WoodCorner", Vector3.new(0.50, height, 0.50),
                Vector3.new(side * w / 2, height / 2, zSide * d / 2),
                C.Timber, Enum.Material.WoodPlanks)
        end
        place("WoodLintel", Vector3.new(w + 0.7, 0.38, 0.5),
            Vector3.new(0, height - 1.25, side * d / 2),
            C.TimberLight, Enum.Material.Wood)
        place("SideWindow", Vector3.new(0.22, 1.8, 2.2),
            Vector3.new(side * (w / 2 + 0.15), height * 0.57, 0),
            C.Iron, Enum.Material.Metal)
        place("WindowGold", Vector3.new(0.23, 1.35, 1.75),
            Vector3.new(side * (w / 2 + 0.18), height * 0.57, 0),
            Color3.fromRGB(177, 146, 106), Enum.Material.Glass)
    end
    local frontZ = -d / 2 - 0.14
    place("FrontDoor", Vector3.new(2.5, 4.5, 0.27),
        Vector3.new(0, 2.65, frontZ), C.Timber, Enum.Material.WoodPlanks)
    place("DoorMetalBand", Vector3.new(2.4, 0.17, 0.3),
        Vector3.new(0, 3.02, frontZ - 0.07), C.Iron, Enum.Material.Metal)
    local handle = orb(h, "DoorHandle",
        (origin * CFrame.new(0.70, 2.5, frontZ - 0.3)).Position,
        Vector3.new(0.24, 0.24, 0.24), C.Gold, Enum.Material.Metal)

    -- Painéis inclinados dão um telhado de duas águas real, não blocos retos.
    for _, side in ipairs({-1, 1}) do
        local roofAngle = -side * math.rad(28)
        local roof = piece(h, "ThatchRoof",
            Vector3.new(w * 0.66, 0.48, d + 2.6),
            origin * CFrame.new(side * w * 0.245, height + 1.55, 0)
                * CFrame.Angles(0, 0, roofAngle),
            if index % 2 == 0 then C.RoofAlt else C.Roof, Enum.Material.WoodPlanks)
        roof.CanCollide = false
        for j = 1, 3 do
            piece(h, "RoofRafter",
                Vector3.new(w * 0.65, 0.10, 0.26),
                origin * CFrame.new(side * w * 0.245, height + 1.78, -d / 2 + j * d / 4)
                    * CFrame.Angles(0, 0, roofAngle),
                C.TimberLight, Enum.Material.Wood)
        end
    end
    place("RoofRidge", Vector3.new(0.61, 0.47, d + 3.1),
        Vector3.new(0, height + 3.03, 0), C.TimberLight, Enum.Material.Wood)
    if index % 3 == 0 then
        place("Chimney", Vector3.new(1.6, 3.1, 1.7),
            Vector3.new(w * 0.27, height + 2.6, d * 0.19),
            C.Stone, Enum.Material.Cobblestone)
    end
    return h
end
for i, data in ipairs(housePositions) do
    house(i, data[1], data[2], data[3] == 1)
end

-- HORTAS, PALHA E CERCA DE MADEIRA
local farms = group(arena, "Farmland")
local function fenceLine(parent: Instance, a: Vector3, b: Vector3, count: number)
    for n = 0, count do
        local p = a:Lerp(b, n / count)
        piece(parent, "FencePost", Vector3.new(0.44, 3.1, 0.44),
            CFrame.new(p + Vector3.new(0, 1.55, 0)), C.Timber, Enum.Material.Wood, true)
    end
    for _, y in ipairs({1.00, 2.18}) do
        beam(parent, "FenceRail", a + Vector3.new(0, y, 0),
            b + Vector3.new(0, y, 0), 0.26, 0.35, C.TimberLight, Enum.Material.Wood)
    end
end

local fields: {{number}} = {{-8, -54, 16, 11}, {-61, 57, 18, 8}, {32, 51, 16, 10}}
for index, plot in ipairs(fields) do
    local x, z, w, d = plot[1], plot[2], plot[3], plot[4]
    piece(farms, "CultivatedSoil", Vector3.new(w, 0.28, d),
        CFrame.new(x, 0.04, z), C.Dirt, Enum.Material.Ground)
    for row = 1, 4 do
        local px = x - w / 2 + (w / 5) * row
        piece(farms, "SoilRow", Vector3.new(0.78, 0.33, d - 1),
            CFrame.new(px, 0.28, z), Color3.fromRGB(108, 73, 52), Enum.Material.Ground)
        for crop = 1, 9 do
            local pz = z - d / 2 + crop * d / 10
            wedge(farms, "WheatStalk", Vector3.new(0.31, rng:NextNumber(1.3, 2.4), 0.32),
                CFrame.new(px, 1.24, pz) * CFrame.Angles(0, rng:NextNumber(0, 6), 0),
                if (crop + row) % 4 == 0 then C.LeafLight else C.Straw, Enum.Material.Grass)
        end
    end
    fenceLine(farms, Vector3.new(x - w / 2 - 1, 0, z + d / 2 + 1),
        Vector3.new(x + w / 2 + 1, 0, z + d / 2 + 1), 4)
end

-- POCO CENTRAL E CARROÇAS
local square = group(arena, "VillageSquare")
local wellPos = Vector3.new(-52, 0, 36)
piece(square, "WellFoundation", Vector3.new(9, 0.3, 9),
    CFrame.new(wellPos + Vector3.new(0, 0.15, 0)), C.Path, Enum.Material.Cobblestone)
for i = 1, 12 do
    local a = i / 12 * math.pi * 2
    local pos = wellPos + Vector3.new(math.cos(a) * 2.3, 1.15, math.sin(a) * 2.3)
    piece(square, "WellStone", Vector3.new(1.3, 2.2, 0.75),
        CFrame.new(pos) * CFrame.Angles(0, -a, 0), C.Stone, Enum.Material.Cobblestone)
end
for _, dx in ipairs({-2.5, 2.5}) do
    piece(square, "WellRoofPost", Vector3.new(0.54, 5.2, 0.54),
        CFrame.new(wellPos + Vector3.new(dx, 4.1, 0)), C.Timber, Enum.Material.Wood)
end
piece(square, "WellRoof", Vector3.new(7.0, 0.6, 6.5),
    CFrame.new(wellPos + Vector3.new(0, 6.5, 0)), C.RoofAlt, Enum.Material.WoodPlanks)
for cart = 1, 2 do
    local cartPos = Vector3.new(if cart == 1 then -65 else 44, 0,
        if cart == 1 then 22 else -51)
    piece(square, "CartBody", Vector3.new(5.3, 1.3, 3.0),
        CFrame.new(cartPos + Vector3.new(0, 1.8, 0)), C.TimberLight, Enum.Material.WoodPlanks)
    for _, wheelX in ipairs({-1.9, 1.9}) do
        for _, side in ipairs({-1, 1}) do
            local wheel = piece(square, "WoodWheel", Vector3.new(0.36, 2, 2),
                CFrame.new(cartPos + Vector3.new(wheelX, 1.16, side * 1.6)),
                C.Timber, Enum.Material.Wood)
            wheel.Shape = Enum.PartType.Cylinder
        end
    end
end

-- ARVORES E ROCHAS: deixa o caminho, base e spawns livres.
local trees = group(arena, "VillageForest")
local function distanceFromSegment2D(p: Vector3, a: Vector3, b: Vector3): number
    local ax, az = p.X - a.X, p.Z - a.Z
    local vx, vz = b.X - a.X, b.Z - a.Z
    local t = math.clamp((ax * vx + az * vz) / (vx * vx + vz * vz), 0, 1)
    local dx, dz = ax - vx * t, az - vz * t
    return math.sqrt(dx * dx + dz * dz)
end
local function sceneryClear(p: Vector3): boolean
    for i = 1, #waypoints - 1 do
        if distanceFromSegment2D(p, waypoints[i], waypoints[i + 1]) < 15 then
            return false
        end
    end
    for _, h in ipairs(housePositions) do
        if (Vector2.new(p.X, p.Z) - Vector2.new(h[1], h[2])).Magnitude < 13 then
            return false
        end
    end
    for _, f in ipairs(fields) do
        if math.abs(p.X - f[1]) < f[3] / 2 + 5
            and math.abs(p.Z - f[2]) < f[4] / 2 + 5 then
            return false
        end
    end
    if (Vector2.new(p.X, p.Z) - Vector2.new(-52, 36)).Magnitude < 11 then return false end
    if (Vector2.new(p.X, p.Z) - Vector2.new(0, 53)).Magnitude < 17 then return false end
    if (Vector2.new(p.X, p.Z) - Vector2.new(72, 0)).Magnitude < 25 then return false end
    return true
end

local function tree(p: Vector3, index: number)
    local s = rng:NextNumber(0.78, 1.35)
    local trunk = piece(trees, "OakTrunk_" .. index, Vector3.new(1.8 * s, 8 * s, 1.8 * s),
        CFrame.new(p + Vector3.new(0, 4 * s, 0)), C.Timber, Enum.Material.Wood, true)
    trunk.Shape = Enum.PartType.Cylinder
    for i = 1, 5 do
        local ang = (i - 1) * math.pi * 2 / 5
        orb(trees, "OakCanopy",
            p + Vector3.new(math.cos(ang) * 2.3 * s, (8.4 + (i % 3)) * s, math.sin(ang) * 2.3 * s),
            Vector3.new(6.9, 6.2, 6.7) * s,
            if i % 3 == 0 then C.LeafLight else C.Leaf, Enum.Material.LeafyGrass)
    end
    orb(trees, "OakCrown", p + Vector3.new(0, 11 * s, 0),
        Vector3.new(7.5, 6.2, 7.5) * s, C.GrassDark, Enum.Material.LeafyGrass)
end

for i = 1, 115 do
    local x, z = rng:NextNumber(-119, 119), rng:NextNumber(-92, 92)
    -- Arvores formam um cinto na borda do campo e grupos rurais espalhados.
    if math.abs(x) > 72 or math.abs(z) > 53 or i % 5 == 0 then
        local pos = Vector3.new(x, 0, z)
        if sceneryClear(pos) then tree(pos, i) end
    end
end

local props = group(arena, "FieldProps")
for i = 1, 34 do
    local x, z = rng:NextNumber(-97, 97), rng:NextNumber(-74, 74)
    local p = Vector3.new(x, 0, z)
    if sceneryClear(p) then
        local stone = orb(props, "MossRock", p + Vector3.new(0, 0.55, 0),
            Vector3.new(rng:NextNumber(1.3, 3.0), rng:NextNumber(0.8, 2.2),
                rng:NextNumber(1.1, 2.8)),
            if i % 3 == 0 then C.PaleStone else C.Stone, Enum.Material.Slate)
        stone.CanCollide = false
    end
end

-- RACHADURA / PORTAL DE ATAQUE: tratado como uma ruptura anormal no campo.
local portal = group(arena, "FissurePortal")
local portalCenter = Vector3.new(-77, 8.7, 0)
for _, side in ipairs({-1, 1}) do
    wedge(portal, "BrokenArchStone", Vector3.new(4.4, 16, 4.1),
        CFrame.new(-77, 7.9, side * 6.8) * CFrame.Angles(0, 0, side * 8),
        C.Stone, Enum.Material.Cobblestone)
end
for i = 1, 16 do
    local angle = (i - 1) * math.pi * 2 / 16
    local nextAngle = i * math.pi * 2 / 16
    local a = portalCenter + Vector3.new(0, math.sin(angle) * 6.5, math.cos(angle) * 6.5)
    local b = portalCenter + Vector3.new(0, math.sin(nextAngle) * 6.5, math.cos(nextAngle) * 6.5)
    beam(portal, "RiftOutline", a, b, 0.34, 0.37, C.Portal, Enum.Material.Neon)
end
local portalCore = piece(portal, "PortalCore", Vector3.new(0.55, 11, 11),
    CFrame.new(portalCenter), C.Portal, Enum.Material.Neon)
portalCore.Transparency = 0.54
portalCore.Shape = Enum.PartType.Ball
light(portalCore, C.PortalGlow, 2.0, 32)
local attachment = Instance.new("Attachment")
attachment.Parent = portalCore
local particles = Instance.new("ParticleEmitter")
particles.Name = "RiftAsh"
particles.Rate = 13
particles.Lifetime = NumberRange.new(0.5, 1.5)
particles.Speed = NumberRange.new(1.5, 3)
particles.Size = NumberSequence.new(0.28)
particles.Color = ColorSequence.new(C.Portal, C.PortalGlow)
particles.LightEmission = 0.7
particles.SpreadAngle = Vector2.new(135, 135)
particles.Parent = attachment
local portalAnchor = piece(portal, "PortalMarker", Vector3.new(1, 1, 1),
    CFrame.new(-77, 9, 0), C.Portal)
portalAnchor.Transparency = 1
sign(portal, portalAnchor, "BRECHA DOS INVASORES", "Origem dos inimigos", C.PortalGlow)

-- DEFESA DA VILA (mesmo BaseCore para o HUD e dano)
local base = group(arena, "FissureBase")
piece(base, "VillageGatePlatform", Vector3.new(19, 1, 22),
    CFrame.new(72, 0.5, 0), C.PaleStone, Enum.Material.Cobblestone)
for _, z in ipairs({-9.2, 9.2}) do
    piece(base, "GatePost", Vector3.new(2.4, 14, 2.5),
        CFrame.new(72, 7.3, z), C.Timber, Enum.Material.WoodPlanks)
    piece(base, "GateBanner", Vector3.new(0.15, 6.0, 3.3),
        CFrame.new(72, 10.2, z + (if z > 0 then -1.3 else 1.3)),
        C.Roof, Enum.Material.Fabric)
end
beam(base, "GateBeam", Vector3.new(72, 14.8, -10),
    Vector3.new(72, 14.8, 10), 2.0, 2.0, C.TimberLight, Enum.Material.Wood)
local core = orb(base, "BaseCore", Vector3.new(77, 8.9, 0),
    Vector3.new(5.6, 8.8, 5.6), C.Core, Enum.Material.Glass)
core.Transparency = 0.14
light(core, C.Core, 1.9, 28)
TweenService:Create(core,
    TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {Transparency = 0.44}):Play()
piece(base, "BaseRunePedestal", Vector3.new(7, 1.7, 7),
    CFrame.new(77, 1.8, 0), C.Stone, Enum.Material.Cobblestone)
sign(base, core, "DEFESA DE CARNE VILLAGE", "Proteja o nucleo da vila", C.Core)

-- SPAWNS DOS JOGADORES NOS MESMOS PONTOS (invisiveis e desativados pelo lobby).
local spawns = Instance.new("Folder")
spawns.Name = "PlayerSpawns"
spawns.Parent = arena
local playerPositions = {
    Vector3.new(-4, 0, 48), Vector3.new(4, 0, 48),
    Vector3.new(-4, 0, 57), Vector3.new(4, 0, 57),
}
for i, pos in ipairs(playerPositions) do
    local pad = Instance.new("SpawnLocation")
    pad.Name = "PlayerSpawn_" .. i
    pad.Size = Vector3.new(7, 1, 7)
    pad.Position = pos + Vector3.new(0, 0.5, 0)
    pad.Anchored = true
    pad.Neutral = true
    pad.Enabled = false
    pad.Duration = 0
    pad.CanCollide = false
    pad.Transparency = 1
    pad.Parent = spawns
end

-- ILUMINACAO RURAL: fim de tarde e poeira, sem o neon da arena antiga.
Lighting.ClockTime = 16.4
Lighting.Brightness = 2.1
Lighting.Ambient = Color3.fromRGB(139, 126, 111)
Lighting.OutdoorAmbient = Color3.fromRGB(160, 153, 139)
Lighting.FogColor = Color3.fromRGB(180, 161, 132)
Lighting.FogStart = 110
Lighting.FogEnd = 360
local atmosphere = Lighting:FindFirstChild("FissureAtmosphere")
if not atmosphere or not atmosphere:IsA("Atmosphere") then
    if atmosphere then atmosphere:Destroy() end
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = "FissureAtmosphere"
    atmosphere.Parent = Lighting
end
atmosphere.Color = Color3.fromRGB(218, 188, 155)
atmosphere.Decay = Color3.fromRGB(144, 135, 125)
atmosphere.Density = 0.24
atmosphere.Haze = 0.8
atmosphere.Glare = 0.10

local bloom = Lighting:FindFirstChild("FissureBloom")
if not bloom or not bloom:IsA("BloomEffect") then
    if bloom then bloom:Destroy() end
    bloom = Instance.new("BloomEffect")
    bloom.Name = "FissureBloom"
    bloom.Parent = Lighting
end
bloom.Intensity = 0.12
bloom.Size = 14
bloom.Threshold = 1.5

arena:SetAttribute("MapVersion", "0.7.0")
arena:SetAttribute("MapType", "CarneVillage")
arena:SetAttribute("StageId", "OVL_01")
arena:SetAttribute("WaypointCount", #waypoints)
arena:SetAttribute("Ready", true)

print("[Anime Fissure] Carne Village v0.7 pronto | casas: "
    .. #housePositions .. " | waypoints: " .. #waypoints
    .. " | jogadores: " .. #playerPositions)
