
--!strict
-- ANIME FISSURE
-- BetaMap.server.luau
-- Fissure Arena - Prototype 01
-- Versao: 0.1.0
-- Mapa procedural para a beta
-- Sem dependencias externas

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")

local MAP_NAME = "FissureArena"

local BLUE = Color3.fromRGB(56, 123, 255)
local CYAN = Color3.fromRGB(80, 225, 255)
local DARK = Color3.fromRGB(12, 17, 30)
local STONE = Color3.fromRGB(26, 32, 49)
local METAL = Color3.fromRGB(43, 54, 78)
local PURPLE = Color3.fromRGB(112, 65, 220)

local oldMap = Workspace:FindFirstChild(MAP_NAME)

if oldMap then
    oldMap:Destroy()
end

local arena = Instance.new("Model")
arena.Name = MAP_NAME
arena.Parent = Workspace

local function part(
    name: string,
    size: Vector3,
    cf: CFrame,
    color: Color3,
    material: Enum.Material,
    parent: Instance?,
    collidable: boolean?
): Part

    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Anchored = true
    p.CanCollide = collidable ~= false
    p.CanTouch = false
    p.Material = material
    p.Color = color
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent or arena

    return p
end

local function neon(
    name: string,
    size: Vector3,
    cf: CFrame,
    color: Color3,
    parent: Instance?
): Part
    return part(
        name,
        size,
        cf,
        color,
        Enum.Material.Neon,
        parent,
        false
    )
end

local function light(
    parent: Instance,
    color: Color3,
    brightness: number,
    range: number
)
    local point = Instance.new("PointLight")
    point.Color = color
    point.Brightness = brightness
    point.Range = range
    point.Shadows = false
    point.Parent = parent
end

local function cylinder(
    name: string,
    radius: number,
    height: number,
    position: Vector3,
    color: Color3,
    material: Enum.Material,
    parent: Instance?
): Part

    local p = part(
        name,
        Vector3.new(height, radius * 2, radius * 2),
        CFrame.new(position)
            * CFrame.Angles(0, 0, math.rad(90)),
        color,
        material,
        parent
    )

    p.Shape = Enum.PartType.Cylinder
    return p
end

local function ring(
    name: string,
    center: Vector3,
    radius: number,
    segments: number,
    thickness: number,
    color: Color3,
    parent: Instance
)
    for i = 1, segments do
        local a1 = (i - 1) / segments * math.pi * 2
        local a2 = i / segments * math.pi * 2

        local p1 = center + Vector3.new(
            math.cos(a1) * radius,
            math.sin(a1) * radius,
            0
        )

        local p2 = center + Vector3.new(
            math.cos(a2) * radius,
            math.sin(a2) * radius,
            0
        )

        local middle = (p1 + p2) / 2
        local distance = (p2 - p1).Magnitude

        neon(
            name .. "_" .. tostring(i),
            Vector3.new(thickness, thickness, distance + 0.1),
            CFrame.lookAt(middle, p2),
            color,
            parent
        )
    end
end

-- TERRENO PRINCIPAL

local ground = part(
    "ObsidianPlatform",
    Vector3.new(180, 6, 130),
    CFrame.new(0, -3, 0),
    STONE,
    Enum.Material.Slate
)

part(
    "LowerIsland",
    Vector3.new(165, 10, 115),
    CFrame.new(0, -11, 0),
    DARK,
    Enum.Material.Basalt
)

-- Bordas luminosas

for _, z in ipairs({-64, 64}) do
    neon(
        "ArenaEdge",
        Vector3.new(178, 0.5, 0.8),
        CFrame.new(0, 0.3, z),
        BLUE
    )
end

for _, x in ipairs({-89, 89}) do
    neon(
        "ArenaEdge",
        Vector3.new(0.8, 0.5, 128),
        CFrame.new(x, 0.3, 0),
        BLUE
    )
end

-- CAMINHO DOS INIMIGOS
-- Waypoints armazenados para futura IA

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

for i, position in ipairs(waypoints) do
    local marker = part(
        string.format("Waypoint_%02d", i),
        Vector3.new(1, 1, 1),
        CFrame.new(position + Vector3.new(0, 2, 0)),
        CYAN,
        Enum.Material.SmoothPlastic,
        pathFolder,
        false
    )

    marker.Transparency = 1
    marker.CanQuery = false
    marker:SetAttribute("Order", i)
end

for i = 1, #waypoints - 1 do
    local a = waypoints[i]
    local b = waypoints[i + 1]

    local middle = (a + b) / 2
    local length = (b - a).Magnitude

    local segment = part(
        "Path_" .. tostring(i),
        Vector3.new(12, 0.25, length),
        CFrame.lookAt(
            middle + Vector3.new(0, 0.14, 0),
            b + Vector3.new(0, 0.14, 0)
        ),
        METAL,
        Enum.Material.Metal
    )

    segment.CanTouch = false

    for _, offset in ipairs({-5.4, 5.4}) do
        neon(
            "PathLight",
            Vector3.new(0.3, 0.2, length),
            segment.CFrame
                * CFrame.new(offset, 0.2, 0),
            BLUE
        )
    end
end

-- PORTAL DIMENSIONAL

local portal = Instance.new("Model")
portal.Name = "FissurePortal"
portal.Parent = arena

local portalCenter = Vector3.new(-72, 10, 0)

ring(
    "PortalOuter",
    portalCenter,
    9,
    24,
    1.2,
    BLUE,
    portal
)

ring(
    "PortalInner",
    portalCenter,
    6.8,
    24,
    0.35,
    CYAN,
    portal
)

local portalCore = part(
    "PortalCore",
    Vector3.new(0.5, 13, 13),
    CFrame.new(portalCenter)
        * CFrame.Angles(0, 0, math.rad(90)),
    BLUE,
    Enum.Material.Neon,
    portal,
    false
)

portalCore.Shape = Enum.PartType.Cylinder
portalCore.Transparency = 0.55

light(portalCore, BLUE, 3, 32)

local portalAttachment = Instance.new("Attachment")
portalAttachment.Parent = portalCore

local particles = Instance.new("ParticleEmitter")
particles.Name = "RiftParticles"
particles.Color = ColorSequence.new(BLUE, CYAN)
particles.LightEmission = 0.8
particles.Rate = 18
particles.Lifetime = NumberRange.new(0.8, 1.8)
particles.Speed = NumberRange.new(1, 4)
particles.Size = NumberSequence.new(0.3)
particles.SpreadAngle = Vector2.new(180, 180)
particles.Parent = portalAttachment

-- BASE DOS JOGADORES

local base = Instance.new("Model")
base.Name = "FissureBase"
base.Parent = arena

local basePosition = Vector3.new(72, 0, 0)

cylinder(
    "BasePlatform",
    12,
    2,
    basePosition + Vector3.new(0, 1, 0),
    METAL,
    Enum.Material.Metal,
    base
)

local core = part(
    "BaseCore",
    Vector3.new(7, 12, 7),
    CFrame.new(basePosition + Vector3.new(0, 9, 0)),
    CYAN,
    Enum.Material.Neon,
    base,
    false
)

core.Shape = Enum.PartType.Ball
light(core, BLUE, 3, 35)

local coreGlow = TweenService:Create(
    core,
    TweenInfo.new(
        2,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ),
    {
        Transparency = 0.45,
        Size = Vector3.new(8, 13, 8),
    }
)

coreGlow:Play()

-- CRISTAIS DIMENSIONAIS

local crystalFolder = Instance.new("Folder")
crystalFolder.Name = "DimensionalCrystals"
crystalFolder.Parent = arena

local crystalPositions = {
    Vector3.new(-72, 0, -45),
    Vector3.new(-72, 0, 45),
    Vector3.new(-22, 0, 47),
    Vector3.new(15, 0, -47),
    Vector3.new(55, 0, -43),
    Vector3.new(55, 0, 46),
    Vector3.new(-5, 0, 48),
    Vector3.new(12, 0, 48),
}

for i, position in ipairs(crystalPositions) do
    local height = 7 + (i % 4) * 2

    local crystal = part(
        "Crystal_" .. tostring(i),
        Vector3.new(4, height, 4),
        CFrame.new(
            position + Vector3.new(0, height / 2, 0)
        ) * CFrame.Angles(
            math.rad(8),
            math.rad(i * 37),
            math.rad(8)
        ),
        if i % 3 == 0 then PURPLE else BLUE,
        Enum.Material.Neon,
        crystalFolder,
        false
    )

    crystal.Shape = Enum.PartType.Block
    crystal.Transparency = 0.15

    light(crystal, crystal.Color, 1, 15)

    part(
        "CrystalBase",
        Vector3.new(6, 2, 6),
        CFrame.new(position + Vector3.new(0, 1, 0)),
        DARK,
        Enum.Material.Basalt,
        crystalFolder
    )
end

-- PONTOS DE SPAWN DOS JOGADORES

local spawnPositions = {
    Vector3.new(-4, 0, 48),
    Vector3.new(4, 0, 48),
    Vector3.new(-4, 0, 57),
    Vector3.new(4, 0, 57),
}

local spawnFolder = Instance.new("Folder")
spawnFolder.Name = "PlayerSpawns"
spawnFolder.Parent = arena

for i, position in ipairs(spawnPositions) do
    local spawn = Instance.new("SpawnLocation")
    spawn.Name = "PlayerSpawn_" .. tostring(i)
    spawn.Size = Vector3.new(7, 1, 7)
    spawn.Position = position + Vector3.new(0, 0.5, 0)
    spawn.Anchored = true
    spawn.Neutral = true
    spawn.Enabled = true
    spawn.AllowTeamChangeOnTouch = false
    spawn.Duration = 0
    spawn.Material = Enum.Material.Neon
    spawn.Color = BLUE
    spawn.Transparency = 0.4
    spawn.Parent = spawnFolder
end

-- ILUMINACAO DA ARENA

Lighting.ClockTime = 0
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(35, 45, 80)
Lighting.OutdoorAmbient = Color3.fromRGB(12, 18, 38)
Lighting.FogColor = DARK
Lighting.FogStart = 80
Lighting.FogEnd = 250

local atmosphere = Lighting:FindFirstChild("FissureAtmosphere")

if not atmosphere then
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Name = "FissureAtmosphere"
    atmosphere.Parent = Lighting
end

if atmosphere:IsA("Atmosphere") then
    atmosphere.Color = Color3.fromRGB(85, 120, 210)
    atmosphere.Decay = Color3.fromRGB(20, 30, 65)
    atmosphere.Density = 0.25
    atmosphere.Haze = 1
    atmosphere.Glare = 0.15
end

local bloom = Lighting:FindFirstChild("FissureBloom")

if not bloom then
    bloom = Instance.new("BloomEffect")
    bloom.Name = "FissureBloom"
    bloom.Parent = Lighting
end

if bloom:IsA("BloomEffect") then
    bloom.Intensity = 0.45
    bloom.Size = 18
    bloom.Threshold = 1.2
end

-- INFORMACOES PARA SISTEMAS FUTUROS

arena:SetAttribute("MapVersion", "0.1.0")
arena:SetAttribute("MapType", "Prototype")
arena:SetAttribute("WaypointCount", #waypoints)
arena:SetAttribute("Ready", true)

print("================================")
print("ANIME FISSURE - MAPA CARREGADO")
print("Fissure Arena Prototype 01")
print("Waypoints:", #waypoints)
print("Spawns:", #spawnPositions)
print("Portal: ONLINE")
print("Base: ONLINE")
print("================================")
