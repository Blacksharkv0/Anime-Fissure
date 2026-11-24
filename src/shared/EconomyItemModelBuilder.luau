--!strict
-- ANIME FISSURE | EconomyItemModelBuilder v0.1
-- Four 3D mini assets built only from native Roblox Parts/Wedges.
-- Not marketplace items: this creates models, not currency balances.
-- All pieces anchored / no collisions; light enough for UI ViewportFrame.

local Visuals = require(script.Parent:WaitForChild("EconomyVisualConfig"))
local Builder = {}
Builder.Version = "0.1.0"

local function make(model: Model, name: string, size: Vector3,
    cf: CFrame, color: Color3, material: Enum.Material?,
    kind: string?, transparency: number?): BasePart
    local p: BasePart
    if kind == "Wedge" then
        p = Instance.new("WedgePart")
    else
        local part = Instance.new("Part")
        if kind == "Ball" then part.Shape = Enum.PartType.Ball end
        if kind == "Cylinder" then part.Shape = Enum.PartType.Cylinder end
        p = part
    end
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Material = material or Enum.Material.SmoothPlastic
    p.Color = color
    p.Transparency = transparency or 0
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = model
    return p
end

local function stroke(model: Model, name: string, a: Vector3, b: Vector3,
    thickness: number, color: Color3, material: Enum.Material?): BasePart
    local delta = b - a
    assert(delta.Magnitude > 0.02, "Economy model zero-length segment")
    return make(model, name, Vector3.new(thickness, thickness, delta.Magnitude),
        CFrame.lookAt((a + b) / 2, b), color, material or Enum.Material.Metal)
end

-- Ring in a vertical XY plane (facing the viewer).
local function polygon(model: Model, prefix: string, n: number, r: number,
    z: number, color: Color3, thick: number, phase: number?)
    local phi = phase or 0
    for i = 1, n do
        local a = ((i - 1) / n) * math.pi * 2 + phi
        local b = (i / n) * math.pi * 2 + phi
        stroke(model, prefix .. "_" .. i,
            Vector3.new(math.cos(a) * r, math.sin(a) * r, z),
            Vector3.new(math.cos(b) * r, math.sin(b) * r, z),
            thick, color, Enum.Material.Metal)
    end
end

local function gemModel(model: Model, item: any)
    -- FISSURE GEMS: neither a regular diamond nor a copy of Robux icon.
    -- Two offset faceted crystal halves split by an electric blue fault line.
    local left = make(model, "FissureCrystalLeft",
        Vector3.new(0.94, 2.13, 0.77),
        CFrame.new(-0.44, 0.04, 0) * CFrame.Angles(
            math.rad(10), math.rad(-12), math.rad(23)),
        item.Secondary, Enum.Material.Glass, "Wedge", 0.09)
    local right = make(model, "FissureCrystalRight",
        Vector3.new(0.97, 2.15, 0.79),
        CFrame.new(0.48, -0.07, 0) * CFrame.Angles(
            math.rad(-7), math.rad(16), math.rad(-20)),
        item.Accent, Enum.Material.Glass, "Wedge", 0.07)

    -- Floating fragments create recognizable asymmetrical silhouette.
    for i, at in ipairs({
        Vector3.new(-1.26, 0.96, -0.08),
        Vector3.new(1.38, -0.75, 0.14),
        Vector3.new(0.31, 1.61, 0.11),
    }) do
        make(model, "OrbitShard_" .. i, Vector3.new(0.39, 0.59, 0.35),
            CFrame.new(at) * CFrame.Angles(
                math.rad(14 * i), math.rad(18 * i), math.rad(33 * i)),
            if i == 2 then item.Accent else item.Secondary,
            Enum.Material.Neon, "Wedge", 0.10)
    end
    stroke(model, "FissureCore", Vector3.new(-0.10, 1.23, -0.44),
        Vector3.new(0.17, -1.12, -0.44), 0.17, item.Accent,
        Enum.Material.Neon)
    stroke(model, "FaultBend", Vector3.new(0.17, -0.35, -0.48),
        Vector3.new(-0.09, 0.18, -0.48), 0.12, Color3.fromRGB(224, 247, 255),
        Enum.Material.Neon)
    polygon(model, "ArcClasp", 6, 1.28, 0.25, item.Shadow, 0.17,
        math.rad(30))
    local light = Instance.new("PointLight")
    light.Name = "FissureGlow"
    light.Color = item.Accent
    light.Range = 8
    light.Brightness = 0.75
    light.Shadows = false
    light.Parent = right
end

local function goldModel(model: Model, item: any)
    -- A familiar coin silhouette; original double-slash engraving.
    local face = CFrame.Angles(0, math.rad(90), 0)
    make(model, "GoldCoinEdge", Vector3.new(0.39, 2.65, 2.65),
        face, item.Secondary, Enum.Material.Metal, "Cylinder")
    make(model, "GoldCoinFace", Vector3.new(0.405, 2.31, 2.31),
        face, item.Accent, Enum.Material.Metal, "Cylinder")
    polygon(model, "FrontMintRing", 12, 1.03, -0.225,
        Color3.fromRGB(255, 239, 164), 0.12)
    polygon(model, "BackMintRing", 12, 1.03, 0.225,
        Color3.fromRGB(172, 108, 44), 0.12)
    -- Original mint mark: two offset angular cuts like a small portal.
    for _, z in ipairs({-0.27, 0.27}) do
        stroke(model, "MintMarkA", Vector3.new(-0.56, 0.51, z),
            Vector3.new(0.18, 0.51, z), 0.20, item.Shadow)
        stroke(model, "MintMarkB", Vector3.new(0.18, 0.51, z),
            Vector3.new(-0.21, -0.04, z), 0.19, item.Shadow)
        stroke(model, "MintMarkC", Vector3.new(-0.23, -0.06, z),
            Vector3.new(0.53, -0.06, z), 0.19, item.Shadow)
        stroke(model, "MintMarkD", Vector3.new(0.53, -0.06, z),
            Vector3.new(-0.06, -0.60, z), 0.16, item.Shadow)
    end
end

local function traitModel(model: Model, item: any)
    -- TRAIT REROLL: a mechanical six-sided spindle; NOT a gold coin.
    -- Three tiny axes converge on a bright turqoise core.
    polygon(model, "HexFrame", 6, 1.47, 0.06,
        item.Secondary, 0.25, math.rad(30))
    polygon(model, "HexInnerTrack", 6, 0.99, -0.07,
        item.Shadow, 0.13, math.rad(30))
    make(model, "SpindleCore", Vector3.new(0.99, 1.02, 0.96),
        CFrame.new(0, 0, -0.14), item.Accent, Enum.Material.Glass, "Ball", 0.08)
    for i = 1, 3 do
        local angle = ((i - 1) / 3) * math.pi * 2 - math.pi / 2
        local a = Vector3.new(math.cos(angle) * 0.35,
            math.sin(angle) * 0.35, -0.75)
        local b = Vector3.new(math.cos(angle) * 1.00,
            math.sin(angle) * 1.00, -0.29)
        stroke(model, "TraitSpindle_" .. i, a, b, 0.16,
            Color3.fromRGB(212, 255, 244), Enum.Material.Neon)
        make(model, "TraitNode_" .. i, Vector3.new(0.32, 0.41, 0.30),
            CFrame.new(b) * CFrame.Angles(0, 0, angle),
            item.Accent, Enum.Material.Neon, "Wedge")
    end
    for i = 1, 6 do
        local angle = ((i - 1) / 6) * math.pi * 2
        local at = Vector3.new(math.cos(angle) * 1.57,
            math.sin(angle) * 1.57, 0)
        make(model, "TraitHexTooth_" .. i, Vector3.new(0.22, 0.35, 0.25),
            CFrame.new(at) * CFrame.Angles(0, 0, angle),
            item.Shadow, Enum.Material.Metal)
    end
end

local function relicTraitModel(model: Model, item: any)
    -- RELIC TRAIT REROLL: original runic resonance seal / octagonal mandala.
    -- A separate silhouette, color language, and geometric symbol.
    polygon(model, "OuterRunicSeal", 8, 1.49, 0.06,
        Color3.fromRGB(231, 170, 103), 0.25, math.rad(22.5))
    polygon(model, "InnerRuneTrack", 8, 0.94, -0.12,
        item.Secondary, 0.15, math.rad(22.5))
    make(model, "VioletRelicHeart", Vector3.new(1.16, 1.17, 0.96),
        CFrame.new(0, 0, -0.25), item.Secondary,
        Enum.Material.Glass, "Ball", 0.08)
    make(model, "RelicCoreDiamond", Vector3.new(0.46, 0.80, 0.29),
        CFrame.new(0, 0.03, -0.83) * CFrame.Angles(0, 0, math.rad(45)),
        item.Accent, Enum.Material.Neon)
    -- Four rune-glyph pairs around the rim are geometric and original.
    for i = 1, 4 do
        local theta = ((i - 1) / 4) * math.pi * 2
        local radial = Vector3.new(math.cos(theta), math.sin(theta), 0)
        local tangential = Vector3.new(-math.sin(theta), math.cos(theta), 0)
        local center = radial * 1.16 + Vector3.new(0, 0, -0.23)
        stroke(model, "RuneAxis_" .. i,
            center - tangential * 0.20, center + tangential * 0.20,
            0.12, item.Accent, Enum.Material.Neon)
        stroke(model, "RuneTail_" .. i,
            center - radial * 0.14,
            center + radial * 0.19 + tangential * 0.17,
            0.10, Color3.fromRGB(255, 221, 179), Enum.Material.Neon)
        local point = radial * 1.82
        make(model, "RelicSpire_" .. i, Vector3.new(0.27, 0.49, 0.29),
            CFrame.new(point) * CFrame.Angles(0, 0, theta - math.pi / 2),
            item.Accent, Enum.Material.Metal, "Wedge")
    end
end

local designers = {
    FissureGems = gemModel,
    Gold = goldModel,
    TraitRerollCore = traitModel,
    RelicTraitSeal = relicTraitModel,
}

function Builder.Build(id: string): Model?
    local visual = Visuals.Get(id)
    local design = designers[id]
    if not visual or not design then return nil end
    local model = Instance.new("Model")
    model.Name = visual.Id
    model:SetAttribute("EconomyVisualId", id)
    model:SetAttribute("DisplayName", visual.Name)
    model:SetAttribute("VisualOnly", true)
    model:SetAttribute("Version", Builder.Version)
    local root = make(model, "Root", Vector3.new(0.2, 0.2, 0.2),
        CFrame.identity, visual.Accent)
    root.Transparency = 1
    model.PrimaryPart = root
    design(model, visual)
    return model
end

function Builder.BuildAll(parent: Instance): Folder
    local existing = parent:FindFirstChild("EconomyPreviewModels")
    if existing then existing:Destroy() end
    local folder = Instance.new("Folder")
    folder.Name = "EconomyPreviewModels"
    folder:SetAttribute("VisualOnly", true)
    folder:SetAttribute("Version", Builder.Version)
    for _, item in ipairs(Visuals.GetAll()) do
        local model = Builder.Build(item.Id)
        assert(model, "Economy model missing: " .. item.Id)
        model.Parent = folder
    end
    folder.Parent = parent
    return folder
end

return Builder
