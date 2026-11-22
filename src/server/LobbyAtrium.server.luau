--!strict
-- ANIME FISSURE | Lobby Atrium v1.0
-- Decoracao ADITIVA. Nao altera FissureLobby, NPCs, remotes ou Spawns.
-- Atrio anime-arcade: jardins flutuantes, esculturas, lanternas e totens.
-- Geometria decorativa CanCollide=false para manter acessibilidade PC/mobile.

local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local lobby = Workspace:WaitForChild("FissureLobby", 45)
if not lobby or not lobby:IsA("Model") then
    warn("[Fissure Lobby Atrium] Lobby nao encontrado")
    return
end

local old = lobby:FindFirstChild("AtriumV1")
if old then old:Destroy() end
local decor = Instance.new("Model")
decor.Name = "AtriumV1"
decor:SetAttribute("Version", "1.0")
decor.Parent = lobby

local O = Vector3.new(260, 0, 0)
local C = {
    Blue = Color3.fromRGB(58, 135, 255),
    Cyan = Color3.fromRGB(93, 225, 247),
    Purple = Color3.fromRGB(177, 101, 247),
    Gold = Color3.fromRGB(252, 199, 116),
    Silver = Color3.fromRGB(141, 173, 209),
    Ink = Color3.fromRGB(25, 35, 59),
    Rock = Color3.fromRGB(76, 93, 124),
    Green = Color3.fromRGB(75, 145, 113),
    GreenLight = Color3.fromRGB(113, 190, 158),
}
local function part(parent: Instance, name: string, size: Vector3, pose: CFrame,
    color: Color3, material: Enum.Material?): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = pose
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = true
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent
    return p
end

local function orb(parent: Instance, name: string, size: Vector3, pose: CFrame,
    color: Color3, material: Enum.Material?): Part
    local p = part(parent, name, size, pose, color, material)
    p.Shape = Enum.PartType.Ball
    return p
end

local function segment(parent: Instance, a: Vector3, b: Vector3,
    width: number, color: Color3, material: Enum.Material?)
    return part(parent, "ArcSegment",
        Vector3.new(width, width, (b - a).Magnitude + 0.04),
        CFrame.lookAt((a + b) / 2, b), color, material or Enum.Material.Metal)
end

local function ring(parent: Instance, center: Vector3, radius: number,
    segments: number, color: Color3, vertical: boolean)
    for i = 1, segments do
        local a = (i - 1) * 2 * math.pi / segments
        local b = i * 2 * math.pi / segments
        local function point(theta: number)
            if vertical then
                return center + Vector3.new(math.cos(theta) * radius, math.sin(theta) * radius, 0)
            end
            return center + Vector3.new(math.cos(theta) * radius, 0, math.sin(theta) * radius)
        end
        segment(parent, point(a), point(b), 0.19, color, Enum.Material.Neon)
    end
end

-- Quatro jardins baixos nos cantos laterais; estacoes em x=-32/+33, z=-6.
local gardens = Instance.new("Model")
gardens.Name = "CornerGardens"
gardens.Parent = decor
for _, x in ipairs({-36, 36}) do
    for _, z in ipairs({-33, 33}) do
        local at = O + Vector3.new(x, 0, z)
        part(gardens, "PlanterBase", Vector3.new(12, 1.05, 12),
            CFrame.new(at + Vector3.new(0, 0.45, 0)), C.Ink, Enum.Material.Slate)
        part(gardens, "PlanterSoil", Vector3.new(11, 0.18, 11),
            CFrame.new(at + Vector3.new(0, 1.04, 0)), C.Green, Enum.Material.Grass)
        for i = 1, 4 do
            local a = i * math.pi / 2
            orb(gardens, "CrystalShrub", Vector3.new(3.7, 2.9, 3.7),
                CFrame.new(at + Vector3.new(math.cos(a) * 3.2, 2.2, math.sin(a) * 3.2)),
                i % 2 == 0 and C.GreenLight or C.Green, Enum.Material.Grass)
        end
        local core = orb(gardens, "GardenCrystal",
            Vector3.new(1.5, 2.8, 1.5), CFrame.new(at + Vector3.new(0, 4.1, 0)),
            if x < 0 then C.Purple else C.Cyan, Enum.Material.Glass)
        core.Transparency = 0.16
        local light = Instance.new("PointLight")
        light.Color = core.Color
        light.Range = 12
        light.Brightness = 0.65
        light.Parent = core
        TweenService:Create(core,
            TweenInfo.new(2.5 + math.abs(z) / 55, Enum.EasingStyle.Sine,
                Enum.EasingDirection.InOut, -1, true),
            {CFrame = core.CFrame + Vector3.new(0, 0.75, 0)}):Play()
    end
end

-- Bandeiras em trilhas laterais indicam direcoes sem obstruir NPCs.
local banners = Instance.new("Model")
banners.Name = "ArcadeBanners"
banners.Parent = decor
for _, x in ipairs({-22, 22}) do
    for _, z in ipairs({-23, 20}) do
        local at = O + Vector3.new(x, 0, z)
        part(banners, "BannerPole", Vector3.new(0.35, 10, 0.35),
            CFrame.new(at + Vector3.new(0, 5, 0)), C.Silver, Enum.Material.Metal)
        part(banners, "BannerCrossbar", Vector3.new(3.0, 0.19, 0.24),
            CFrame.new(at + Vector3.new(0, 9.35, 0)), C.Silver, Enum.Material.Metal)
        local cloth = part(banners, "FactionBanner", Vector3.new(2.55, 4.8, 0.16),
            CFrame.new(at + Vector3.new(0, 6.75, -0.13)),
            if x < 0 then C.Purple else C.Cyan, Enum.Material.Fabric)
        cloth.Transparency = 0.14
        part(banners, "BannerMark", Vector3.new(0.52, 1.8, 0.08),
            CFrame.new(at + Vector3.new(0, 7.3, -0.26)), C.Gold, Enum.Material.Neon)
    end
end

-- Portico de boas-vindas atras do spawn para criar profundidade.
local gateway = Instance.new("Model")
gateway.Name = "WelcomeGate"
gateway.Parent = decor
for _, x in ipairs({-12.6, 12.6}) do
    part(gateway, "GateColumn", Vector3.new(1.4, 15, 1.4),
        CFrame.new(O + Vector3.new(x, 7.5, 39)), C.Rock, Enum.Material.Slate)
    part(gateway, "GateColumnInset", Vector3.new(0.8, 11, 0.16),
        CFrame.new(O + Vector3.new(x, 7.5, 38.19)), C.Blue, Enum.Material.Neon)
end
part(gateway, "GateTop", Vector3.new(28, 2.3, 2.4),
    CFrame.new(O + Vector3.new(0, 15.8, 39)), C.Ink, Enum.Material.Metal)
part(gateway, "GateTrim", Vector3.new(27.5, 0.24, 0.35),
    CFrame.new(O + Vector3.new(0, 17.14, 37.7)), C.Gold, Enum.Material.Metal)

-- Emblema flutuante acima do anel central da praca; nada bloqueia caminhada.
local center = Instance.new("Model")
center.Name = "FissureCrest"
center.Parent = decor
local emblem = O + Vector3.new(0, 16, 2)
ring(center, emblem, 3.3, 20, C.Blue, true)
ring(center, emblem, 2.25, 16, C.Cyan, true)
local gem = orb(center, "AetherGem", Vector3.new(1.65, 2.75, 1.65),
    CFrame.new(emblem), C.Purple, Enum.Material.Glass)
gem.Transparency = 0.08
TweenService:Create(gem,
    TweenInfo.new(3.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {CFrame = CFrame.new(emblem + Vector3.new(0, 1, 0))}):Play()

-- Uma linha luminosa curta liga visualmente o emblema ao portal.
local beamCenter = O + Vector3.new(0, 0.33, -19)
for i = 1, 6 do
    local at = beamCenter + Vector3.new(0, 0, (i - 3.5) * 2.2)
    orb(center, "PortalApproach", Vector3.new(0.5, 0.15, 0.5),
        CFrame.new(at), C.Cyan, Enum.Material.Neon).Transparency = 0.23
end

decor:SetAttribute("Ready", true)
print("[Anime Fissure] Lobby Atrium v1.0 | decoracao aditiva")
