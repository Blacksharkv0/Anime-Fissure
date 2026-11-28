--!strict
-- ANIME FISSURE | Lobby Visual Polish v0.2
-- Melhora o lobby EXISTENTE. Nao cria outro lobby, nem modifica remotes.
-- Eixo central: (260,0,0). Virgil: (228,0,-6). Alquimista: (293,0,-6).
-- Nenhum asset externo ou plugin necessario.

local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local lobby = Workspace:WaitForChild("FissureLobby", 40)
if not lobby or not lobby:IsA("Model") then
    warn("[Fissure Visual] Nao encontrei FissureLobby")
    return
end

local old = lobby:FindFirstChild("FissureVisualPolishV2")
if old then old:Destroy() end
local decor = Instance.new("Model")
decor.Name = "FissureVisualPolishV2"
decor:SetAttribute("Version", "0.2")
decor.Parent = lobby

local CENTER = Vector3.new(260, 0, 0)
local C = {
    Floor = Color3.fromRGB(53, 68, 98),
    FloorAlt = Color3.fromRGB(58, 75, 106),
    Path = Color3.fromRGB(94, 117, 153),
    Ink = Color3.fromRGB(20, 28, 48),
    Metal = Color3.fromRGB(127, 150, 180),
    Cyan = Color3.fromRGB(84, 224, 246),
    Blue = Color3.fromRGB(63, 139, 250),
    Purple = Color3.fromRGB(162, 96, 246),
    Gold = Color3.fromRGB(254, 207, 126),
    White = Color3.fromRGB(228, 241, 255),
    Green = Color3.fromRGB(89, 222, 180),
}

local function part(name: string, pos: Vector3, size: Vector3,
    color: Color3, material: Enum.Material, collide: boolean?): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Position = pos
    p.Size = size
    p.Color = color
    p.Material = material
    p.Anchored = true
    p.CanCollide = collide == true
    p.CanTouch = false
    p.CanQuery = false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.CastShadow = false
    p.Parent = decor
    return p
end

local function lamp(parent: BasePart, color: Color3, brightness: number, range: number)
    local light = Instance.new("PointLight")
    light.Color = color
    light.Brightness = brightness
    light.Range = range
    light.Shadows = false
    light.Parent = parent
end

local function line(name: string, a: Vector3, b: Vector3, width: number,
    color: Color3, material: Enum.Material?): Part
    local delta = b - a
    local segment = part(name, (a + b) * 0.5,
        Vector3.new(width, width, delta.Magnitude),
        color, material or Enum.Material.Neon, false)
    segment.CFrame = CFrame.lookAt((a + b) * 0.5, b)
    return segment
end

local function billboard(anchor: BasePart, titleText: string, subtitleText: string,
    accent: Color3, w: number): BillboardGui
    local gui = Instance.new("BillboardGui")
    gui.Name = "FissureStationSign"
    gui.Size = UDim2.new(5.0, 0, 1.1, 0)
    gui.StudsOffset = Vector3.new(0, 0.6, 0)
    gui.MaxDistance = 28
    gui.AlwaysOnTop = false
    gui:SetAttribute("CityLocalSign", true)
    gui.Parent = anchor

    local background = Instance.new("Frame")
    background.Size = UDim2.fromScale(1, 1)
    background.BackgroundColor3 = C.Ink
    background.BackgroundTransparency = 0.48
    background.BorderSizePixel = 0
    background.Parent = gui
    local corners = Instance.new("UICorner")
    corners.CornerRadius = UDim.new(0, 12)
    corners.Parent = background
    local border = Instance.new("UIStroke")
    border.Color = accent
    border.Thickness = 0.8
    border.Transparency = 0.6
    border.Parent = background

    local upper = Instance.new("TextLabel")
    upper.BackgroundTransparency = 1
    upper.Size = UDim2.fromScale(.96,.56)
    upper.Position = UDim2.fromScale(.02,.04)
    upper.Font = Enum.Font.GothamBlack
    upper.TextScaled = true
    upper.TextColor3 = C.White
    upper.Text = titleText
    upper.Parent = background

    local lower = Instance.new("TextLabel")
    lower.BackgroundTransparency = 1
    lower.Size = UDim2.fromScale(.96,.35)
    lower.Position = UDim2.fromScale(.02,.61)
    lower.Font = Enum.Font.GothamBold
    lower.TextScaled = true
    lower.TextColor3 = accent
    lower.Text = subtitleText
    lower.Parent = background
    return gui
end

-- ILUMINACAO: o prototipo antigo ficava praticamente preto.
-- Como Lighting e global, esta paleta tambem deixa a arena beta mais clara.
Lighting.ClockTime = 16.5
Lighting.Brightness = 2.6
Lighting.ExposureCompensation = 0.18
Lighting.GlobalShadows = true
Lighting.Ambient = Color3.fromRGB(132, 148, 179)
Lighting.OutdoorAmbient = Color3.fromRGB(153, 169, 199)
Lighting.ColorShift_Top = Color3.fromRGB(255, 239, 221)
Lighting.ColorShift_Bottom = Color3.fromRGB(49, 67, 113)

local color = Lighting:FindFirstChild("FissureColorGrade")
if not color or not color:IsA("ColorCorrectionEffect") then
    color = Instance.new("ColorCorrectionEffect")
    color.Name = "FissureColorGrade"
    color.Parent = Lighting
end
local grade = color :: ColorCorrectionEffect
grade.TintColor = Color3.fromRGB(235, 243, 255)
grade.Brightness = 0.06
grade.Contrast = 0.06
grade.Saturation = 0.08

local bloom = Lighting:FindFirstChild("FissureBloom")
if not bloom or not bloom:IsA("BloomEffect") then
    bloom = Instance.new("BloomEffect")
    bloom.Name = "FissureBloom"
    bloom.Parent = Lighting
end
local glow = bloom :: BloomEffect
glow.Intensity = 0.09
glow.Size = 18
glow.Threshold = 2.0

local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
if not atmosphere then
    atmosphere = Instance.new("Atmosphere")
    atmosphere.Parent = Lighting
end
atmosphere.Density = 0.22
atmosphere.Offset = 0.25
atmosphere.Haze = 0.9
atmosphere.Glare = 0.13
atmosphere.Color = Color3.fromRGB(197, 215, 246)
atmosphere.Decay = Color3.fromRGB(94, 124, 182)

local floor = lobby:FindFirstChild("LobbyFloor")
if floor and floor:IsA("BasePart") then
    floor.Color = Color3.fromRGB(33,44,63)
    floor.Material = Enum.Material.Slate
end

-- Fissure City owns pavers, routes, plaza and lamps; no duplicate overlays.

-- Moldura em volta do portal existente (o azul solido escondia o formato).
local portal = lobby:FindFirstChild("ArenaPortal")
if portal and portal:IsA("BasePart") then
    portal.Material = Enum.Material.Glass
    portal.Color = C.Blue
    portal.Transparency = 0.67
    for _, x in ipairs({-8.7, 8.7}) do
        part("PortalFrame", CENTER + Vector3.new(x, 10, -38),
            Vector3.new(1.5, 21.0, 3.1), C.Ink, Enum.Material.Metal, false)
        part("PortalNeon", CENTER + Vector3.new(x - math.sign(x) * 0.65, 10, -36.31),
            Vector3.new(0.18, 18.8, 0.15), C.Cyan, Enum.Material.Neon, false)
    end
    part("PortalCrown", CENTER + Vector3.new(0, 20.7, -38),
        Vector3.new(19.5, 1.7, 3.1), C.Ink, Enum.Material.Metal, false)
    part("PortalCrownLight", CENTER + Vector3.new(0, 21.62, -36.3),
        Vector3.new(18.4, 0.15, 0.15), C.Cyan, Enum.Material.Neon, false)
    local oldSign = portal:FindFirstChild("PortalSign")
    if oldSign and oldSign:IsA("BillboardGui") then
        oldSign.Enabled = false
    end
    local signAnchor = part("ArenaTitleAnchor", CENTER + Vector3.new(0, 25.2, -38),
        Vector3.new(0.5, 0.5, 0.5), C.Ink, Enum.Material.SmoothPlastic, false)
    signAnchor.Transparency = 1
    billboard(signAnchor, "PORTAL DAS FISSURAS", "SELECIONE SUA MISSAO", C.Cyan, 275)
end

-- O Spawn antigo parecia uma placa azul gigante no solo.
local spawn = lobby:FindFirstChild("LobbySpawn")
if spawn and spawn:IsA("SpawnLocation") then
    spawn.Transparency = 0.88
    spawn.Material = Enum.Material.SmoothPlastic
    spawn.Color = C.Floor
end

-- Retoca as duas lojas sem tocar nos ProximityPrompts e objetos de craft.
local virgil = lobby:WaitForChild("VirgilSummonStand", 30)
if virgil and virgil:IsA("Model") then
    local labelAnchor = virgil:FindFirstChild("SignAnchor")
    local existing = if labelAnchor then labelAnchor:FindFirstChild("VirgilLabel") else nil
    if existing and existing:IsA("BillboardGui") then
        existing.Enabled = false
    end
    local signAnchor = part("VirgilTitleAnchor", Vector3.new(228, 11.3, -5.5),
        Vector3.new(0.5, 0.5, 0.5), C.Ink, Enum.Material.SmoothPlastic, false)
    signAnchor.Transparency = 1
    billboard(signAnchor, "VERGIL", "SUMMON", C.Blue, 205)
    for _, x in ipairs({-6.0, 6.0}) do
        local p = part("VirgilLight", Vector3.new(228 + x, 7.1, -6.2),
            Vector3.new(0.35, 0.75, 0.35), C.Purple, Enum.Material.Neon, false)
        lamp(p, C.Blue, .42, 10)
    end
end

local workshop = lobby:WaitForChild("AlchemyWorkshop", 30)
if workshop and workshop:IsA("Model") then
    local labelAnchor = workshop:FindFirstChild("WorkshopSignAnchor")
    local existing = if labelAnchor then labelAnchor:FindFirstChild("WorkshopSign") else nil
    if existing and existing:IsA("BillboardGui") then
        existing.Enabled = false
    end
    local signAnchor = part("AlchemyTitleAnchor", Vector3.new(293, 14.9, 4.6),
        Vector3.new(0.5, 0.5, 0.5), C.Ink, Enum.Material.SmoothPlastic, false)
    signAnchor.Transparency = 1
    billboard(signAnchor, "EDWARD", "ALQUIMIA", C.Gold, 220)
    for _, x in ipairs({-13, 13}) do
        local p = part("AlchemistLight", Vector3.new(293 + x, 7.8, 5.0),
            Vector3.new(0.4, 0.75, 0.4), C.Gold, Enum.Material.Neon, false)
        lamp(p, C.Gold, .40, 10)
    end
end

print("[Anime Fissure] Lobby Visual Polish v0.2 aplicado (sem modificar gameplay)")
