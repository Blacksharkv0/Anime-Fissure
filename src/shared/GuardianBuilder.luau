
--!strict
-- ANIME FISSURE
-- GuardianBuilder v1.0
-- Cortador de Fissuras
-- Modelo Roblox procedural e animavel por pivots.
--
-- Uso:
-- local GuardianBuilder = require(Shared.GuardianBuilder)
-- local guardian = GuardianBuilder.Build(CFrame.new(0, 5, 0))
-- guardian.Parent = workspace
--
-- O modelo e visual/prototipo.
-- Nao e um rig R15 oficial ainda.

local GuardianBuilder = {}

local COLORS = {
    Coat = Color3.fromRGB(12, 28, 76),
    CoatLight = Color3.fromRGB(25, 67, 150),
    Black = Color3.fromRGB(8, 12, 27),
    Armor = Color3.fromRGB(18, 25, 43),
    Silver = Color3.fromRGB(213, 230, 248),
    Hair = Color3.fromRGB(229, 238, 255),
    Skin = Color3.fromRGB(224, 196, 176),
    Gold = Color3.fromRGB(221, 168, 69),
    Blue = Color3.fromRGB(56, 123, 255),
    Cyan = Color3.fromRGB(87, 225, 255),
    Eye = Color3.fromRGB(72, 194, 255),
}

local function createPart(
    parent: Instance,
    name: string,
    size: Vector3,
    relativeCF: CFrame,
    color: Color3,
    material: Enum.Material?
): Part

    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = relativeCF
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent

    return p
end

local function makeWedge(
    parent: Instance,
    name: string,
    size: Vector3,
    cf: CFrame,
    color: Color3
): WedgePart

    local p = Instance.new("WedgePart")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = Enum.Material.SmoothPlastic
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.Parent = parent

    return p
end

local function addNeon(
    parent: Instance,
    name: string,
    size: Vector3,
    cf: CFrame,
    color: Color3
): Part
    return createPart(
        parent,
        name,
        size,
        cf,
        color,
        Enum.Material.Neon
    )
end

function GuardianBuilder.Build(spawnCF: CFrame): Model
    local model = Instance.new("Model")
    model.Name = "FissureGuardian"

    -- Todas as coordenadas sao locais.
    -- Model:PivotTo posiciona o conjunto completo.
    local root = createPart(
        model,
        "Root",
        Vector3.new(0.5, 0.5, 0.5),
        CFrame.new(0, 0, 0),
        COLORS.Black
    )
    root.Transparency = 1
    model.PrimaryPart = root

    local torso = createPart(
        model,
        "Torso",
        Vector3.new(3.4, 3.5, 1.8),
        CFrame.new(0, 5.2, 0),
        COLORS.Armor
    )

    -- Sobretudo, parte superior.
    createPart(
        model,
        "CoatChest",
        Vector3.new(3.7, 3.6, 2.05),
        CFrame.new(0, 5.2, 0.08),
        COLORS.Coat
    )

    -- Painel central preto.
    createPart(
        model,
        "ChestPanel",
        Vector3.new(1.7, 3.2, 0.12),
        CFrame.new(0, 5.2, -1.02),
        COLORS.Black
    )

    -- Gola alta.
    createPart(
        model,
        "CollarLeft",
        Vector3.new(0.6, 1.2, 1.3),
        CFrame.new(-1.1, 7.05, -0.1) *
            CFrame.Angles(0, 0, math.rad(-12)),
        COLORS.Coat
    )

    createPart(
        model,
        "CollarRight",
        Vector3.new(0.6, 1.2, 1.3),
        CFrame.new(1.1, 7.05, -0.1) *
            CFrame.Angles(0, 0, math.rad(12)),
        COLORS.Coat
    )

    -- Detalhes metalicos da frente.
    for _, x in ipairs({-1.42, 1.42}) do
        createPart(
            model,
            "CoatTrim",
            Vector3.new(0.12, 3.25, 0.14),
            CFrame.new(x, 5.2, -1.03),
            COLORS.Silver
        )

        for i = 1, 4 do
            local button = createPart(
                model,
                "GoldButton",
                Vector3.new(0.22, 0.22, 0.1),
                CFrame.new(
                    x * 0.72,
                    6.3 - (i - 1) * 0.65,
                    -1.12
                ),
                COLORS.Gold,
                Enum.Material.Metal
            )
            button.Shape = Enum.PartType.Ball
        end
    end

    -- Gema central.
    local gem = addNeon(
        model,
        "DimensionalCore",
        Vector3.new(0.45, 0.65, 0.2),
        CFrame.new(0, 6.1, -1.16) *
            CFrame.Angles(0, 0, math.rad(45)),
        COLORS.Cyan
    )

    -- Cabeca e rosto.
    createPart(
        model,
        "Neck",
        Vector3.new(0.9, 0.5, 0.8),
        CFrame.new(0, 7.2, 0),
        COLORS.Skin
    )

    local head = createPart(
        model,
        "Head",
        Vector3.new(2.35, 2.15, 2.1),
        CFrame.new(0, 8.45, 0),
        COLORS.Skin
    )

    -- Frente do personagem = Z negativo.
    for _, x in ipairs({-0.55, 0.55}) do
        createPart(
            model,
            "EyeWhite",
            Vector3.new(0.57, 0.28, 0.06),
            CFrame.new(x, 8.58, -1.08),
            COLORS.Silver
        )

        createPart(
            model,
            "BlueEye",
            Vector3.new(0.2, 0.25, 0.07),
            CFrame.new(x, 8.58, -1.13),
            COLORS.Eye
        )

        createPart(
            model,
            "Eyebrow",
            Vector3.new(0.72, 0.11, 0.09),
            CFrame.new(x, 8.86, -1.1) *
                CFrame.Angles(
                    0, 0,
                    math.rad(x < 0 and -12 or 12)
                ),
            COLORS.Black
        )
    end

    -- Cabelo prateado blocado.
    createPart(
        model,
        "HairBase",
        Vector3.new(2.55, 0.75, 2.35),
        CFrame.new(0, 9.62, 0.03),
        COLORS.Hair
    )

    local hairPieces = {
        {-0.95, 10.15, -0.4, -20},
        {-0.45, 10.45, -0.25, -8},
        {0.10, 10.58, 0.0, 5},
        {0.65, 10.4, 0.0, 18},
        {1.02, 10.1, 0.3, 28},
        {-0.8, 10.1, 0.75, -25},
        {0.0, 10.45, 0.9, 0},
        {0.8, 10.1, 0.75, 25},
    }

    for i, h in ipairs(hairPieces) do
        makeWedge(
            model,
            "HairSpike" .. i,
            Vector3.new(0.75, 1.65, 1.05),
            CFrame.new(h[1], h[2], h[3]) *
                CFrame.Angles(
                    0, 0, math.rad(h[4])
                ),
            COLORS.Hair
        )
    end

    -- Bracos blocados.
    for _, side in ipairs({-1, 1}) do
        local arm = createPart(
            model,
            side == -1 and "LeftArm" or "RightArm",
            Vector3.new(1.55, 3.7, 1.85),
            CFrame.new(side * 2.6, 5.15, 0),
            COLORS.CoatLight
        )

        createPart(
            model,
            "ShoulderArmor",
            Vector3.new(1.75, 0.55, 2.0),
            CFrame.new(side * 2.6, 6.75, 0),
            COLORS.Coat
        )

        createPart(
            model,
            "ShoulderLine",
            Vector3.new(1.55, 0.13, 0.16),
            CFrame.new(side * 2.6, 6.35, -0.96),
            COLORS.Cyan
        )

        createPart(
            model,
            "Glove",
            Vector3.new(1.45, 0.9, 1.75),
            CFrame.new(side * 2.6, 3.15, 0),
            COLORS.Black
        )
    end

    -- Pernas e botas.
    for _, side in ipairs({-1, 1}) do
        createPart(
            model,
            "Leg",
            Vector3.new(1.55, 3.1, 1.8),
            CFrame.new(side * 0.95, 1.75, 0),
            COLORS.Black
        )

        createPart(
            model,
            "Boot",
            Vector3.new(1.7, 0.8, 2.25),
            CFrame.new(side * 0.95, 0.45, -0.25),
            COLORS.Armor
        )
    end

    -- Caudas do sobretudo.
    for _, x in ipairs({-1.05, 1.05}) do
        createPart(
            model,
            "CoatTail",
            Vector3.new(1.8, 3.0, 0.55),
            CFrame.new(x, 2.2, 0.85) *
                CFrame.Angles(
                    math.rad(-8), 0, 0
                ),
            COLORS.Coat
        )

        createPart(
            model,
            "TailTrim",
            Vector3.new(0.1, 2.8, 0.12),
            CFrame.new(x * 1.7, 2.2, 0.5),
            COLORS.Silver
        )
    end

    -- Bainha na cintura esquerda.
    local scabbard = createPart(
        model,
        "Scabbard",
        Vector3.new(0.65, 0.65, 5.8),
        CFrame.new(-2.1, 3.35, 0.7) *
            CFrame.Angles(
                0, math.rad(-15), math.rad(-12)
            ),
        COLORS.Black
    )

    createPart(
        model,
        "ScabbardGoldTip",
        Vector3.new(0.75, 0.75, 0.3),
        scabbard.CFrame *
            CFrame.new(0, 0, -2.75),
        COLORS.Gold,
        Enum.Material.Metal
    )

    -- Espada separada para futura animacao.
    local swordModel = Instance.new("Model")
    swordModel.Name = "DimensionalKatana"
    swordModel.Parent = model

    local handle = createPart(
        swordModel,
        "Handle",
        Vector3.new(0.42, 0.42, 2.2),
        CFrame.new(0, 0, 0),
        COLORS.Black
    )

    createPart(
        swordModel,
        "Guard",
        Vector3.new(1.4, 0.2, 0.55),
        CFrame.new(0, 0, -1.12),
        COLORS.Gold,
        Enum.Material.Metal
    )

    local blade = createPart(
        swordModel,
        "Blade",
        Vector3.new(0.22, 0.55, 5.5),
        CFrame.new(0, 0, -3.95),
        COLORS.Silver,
        Enum.Material.Metal
    )

    addNeon(
        swordModel,
        "EnergyEdge",
        Vector3.new(0.08, 0.13, 5.2),
        CFrame.new(0, 0.31, -3.95),
        COLORS.Cyan
    )

    swordModel.PrimaryPart = handle

    -- Posicao inicial da katana:
    -- ao lado do corpo, pronta para o saque.
    swordModel:PivotTo(
        CFrame.new(2.5, 3.15, -0.7) *
            CFrame.Angles(
                0, math.rad(15), math.rad(12)
            )
    )

    -- Referencias para animacoes futuras.
    local refs = Instance.new("Folder")
    refs.Name = "AnimationReferences"
    refs.Parent = model

    local function reference(
        name: string,
        target: Instance
    )
        local value = Instance.new("ObjectValue")
        value.Name = name
        value.Value = target
        value.Parent = refs
    end

    reference("Root", root)
    reference("Torso", torso)
    reference("Head", head)
    reference("Sword", swordModel)
    reference("SwordHandle", handle)
    reference("SwordBlade", blade)
    reference("Scabbard", scabbard)
    reference("Core", gem)

    model:PivotTo(spawnCF)

    return model
end

return GuardianBuilder
