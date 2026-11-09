
--!strict
-- ANIME FISSURE | GuardianBuilder v2.0
-- Cortador de Fissuras
-- Modelo 3D procedural com poses cinematograficas.
-- Todas as partes sao ancoradas: animacao local via PivotTo.

local GuardianBuilder = {}

local C = {
    Navy = Color3.fromRGB(12, 25, 65),
    Blue = Color3.fromRGB(32, 75, 156),
    Black = Color3.fromRGB(9, 13, 28),
    Armor = Color3.fromRGB(27, 34, 54),
    Silver = Color3.fromRGB(215, 230, 248),
    Hair = Color3.fromRGB(235, 242, 255),
    Skin = Color3.fromRGB(223, 194, 175),
    Gold = Color3.fromRGB(222, 172, 78),
    Cyan = Color3.fromRGB(75, 225, 255),
}

local function piece(
    parent: Instance,
    name: string,
    size: Vector3,
    cf: CFrame,
    color: Color3,
    material: Enum.Material?,
    shape: string?
): BasePart
    local p: BasePart

    if shape == "Wedge" then
        p = Instance.new("WedgePart")
    else
        p = Instance.new("Part")
    end

    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.Parent = parent

    return p
end

local function createGroup(
    parent: Instance,
    name: string,
    pivot: CFrame
): Model
    local group = Instance.new("Model")
    group.Name = name
    group.Parent = parent

    local root = piece(
        group,
        "Pivot",
        Vector3.new(0.1, 0.1, 0.1),
        pivot,
        C.Black
    )
    root.Transparency = 1
    group.PrimaryPart = root

    return group
end

local function addArm(
    parent: Instance,
    name: string,
    shoulder: CFrame,
    left: boolean
): Model
    local group = createGroup(parent, name, shoulder)

    piece(
        group, "Sleeve",
        Vector3.new(1.35, 2.7, 1.5),
        shoulder * CFrame.new(0, -1.35, 0),
        C.Blue
    )

    piece(
        group, "ShoulderArmor",
        Vector3.new(1.6, 0.55, 1.7),
        shoulder * CFrame.new(0, -0.2, 0),
        C.Navy
    )

    piece(
        group, "Glove",
        Vector3.new(1.25, 0.85, 1.4),
        shoulder * CFrame.new(0, -2.85, 0),
        C.Black
    )

    piece(
        group, "WristTrim",
        Vector3.new(1.3, 0.12, 1.45),
        shoulder * CFrame.new(0, -2.5, 0),
        C.Gold,
        Enum.Material.Metal
    )

    return group
end

function GuardianBuilder.Build(spawnCF: CFrame): Model
    local model = Instance.new("Model")
    model.Name = "FissureGuardian"

    local root = piece(
        model, "HumanoidRootPart",
        Vector3.new(0.3, 0.3, 0.3),
        CFrame.new(),
        C.Black
    )
    root.Transparency = 1
    model.PrimaryPart = root

    -- Pernas e botas.
    for _, side in ipairs({-1, 1}) do
        local x = side * 0.85

        piece(
            model, "Leg",
            Vector3.new(1.45, 3.0, 1.5),
            CFrame.new(x, 1.95, 0),
            C.Black
        )

        piece(
            model, "Boot",
            Vector3.new(1.55, 0.8, 2.0),
            CFrame.new(x, 0.45, -0.25),
            C.Armor
        )

        -- Abas do sobretudo.
        piece(
            model, "CoatTail",
            Vector3.new(1.65, 3.2, 0.45),
            CFrame.new(x * 1.05, 2.5, 0.85)
                * CFrame.Angles(math.rad(-9), 0, 0),
            C.Navy
        )

        piece(
            model, "CoatTrim",
            Vector3.new(0.1, 2.8, 0.15),
            CFrame.new(side * 1.65, 2.5, 0.58),
            C.Silver
        )
    end

    -- Corpo e sobretudo.
    piece(
        model, "UpperBody",
        Vector3.new(3.2, 3.5, 1.8),
        CFrame.new(0, 5.3, 0),
        C.Navy
    )

    piece(
        model, "ChestPanel",
        Vector3.new(1.6, 3.0, 0.14),
        CFrame.new(0, 5.3, -0.97),
        C.Black
    )

    for _, side in ipairs({-1, 1}) do
        piece(
            model, "ChestTrim",
            Vector3.new(0.12, 3.0, 0.12),
            CFrame.new(side * 1.3, 5.3, -1.0),
            C.Silver
        )

        piece(
            model, "Collar",
            Vector3.new(0.65, 1.0, 1.3),
            CFrame.new(side * 1.05, 7.1, 0),
            C.Navy
        )

        for i = 1, 3 do
            piece(
                model, "GoldButton",
                Vector3.new(0.2, 0.2, 0.13),
                CFrame.new(
                    side * 0.7,
                    6.25 - (i - 1) * 0.75,
                    -1.08
                ),
                C.Gold,
                Enum.Material.Metal
            )
        end
    end

    piece(
        model, "DimensionalCore",
        Vector3.new(0.48, 0.6, 0.16),
        CFrame.new(0, 6.15, -1.12)
            * CFrame.Angles(0, 0, math.rad(45)),
        C.Cyan,
        Enum.Material.Neon
    )

    -- Cabeca.
    piece(
        model, "Neck",
        Vector3.new(0.8, 0.5, 0.8),
        CFrame.new(0, 7.35, 0),
        C.Skin
    )

    piece(
        model, "Head",
        Vector3.new(2.2, 2.1, 2.0),
        CFrame.new(0, 8.55, 0),
        C.Skin
    )

    -- Frente do personagem: Z negativo.
    for _, side in ipairs({-1, 1}) do
        local x = side * 0.52

        piece(
            model, "Eye",
            Vector3.new(0.48, 0.22, 0.08),
            CFrame.new(x, 8.6, -1.04),
            C.Silver
        )

        piece(
            model, "Iris",
            Vector3.new(0.17, 0.22, 0.09),
            CFrame.new(x, 8.6, -1.1),
            C.Cyan
        )

        piece(
            model, "Eyebrow",
            Vector3.new(0.6, 0.1, 0.1),
            CFrame.new(x, 8.88, -1.07)
                * CFrame.Angles(
                    0, 0,
                    math.rad(side * 12)
                ),
            C.Black
        )
    end

    -- Cabelo prateado espetado.
    piece(
        model, "HairBase",
        Vector3.new(2.45, 0.65, 2.2),
        CFrame.new(0, 9.7, 0),
        C.Hair
    )

    local spikes = {
        {-0.95, 10.2, -0.4, -25},
        {-0.5, 10.55, -0.2, -12},
        {0.05, 10.7, 0, 0},
        {0.6, 10.55, -0.2, 15},
        {1.0, 10.2, 0.3, 25},
        {-0.7, 10.35, 0.8, -15},
        {0.2, 10.5, 0.8, 8},
    }

    for i, h in ipairs(spikes) do
        piece(
            model, "HairSpike" .. i,
            Vector3.new(0.75, 1.4, 0.9),
            CFrame.new(h[1], h[2], h[3])
                * CFrame.Angles(
                    0, 0, math.rad(h[4])
                ),
            C.Hair,
            nil,
            "Wedge"
        )
    end

    -- Bracos separados para poses.
    addArm(
        model, "LeftArm",
        CFrame.new(-2.25, 6.65, 0),
        true
    )

    addArm(
        model, "RightArm",
        CFrame.new(2.25, 6.65, 0),
        false
    )

    -- Bainha presa visualmente a cintura.
    local sheath = createGroup(
        model,
        "Scabbard",
        CFrame.new(-2.0, 3.5, 0.4)
            * CFrame.Angles(
                0, math.rad(-15), math.rad(-12)
            )
    )

    local sheathCF = sheath:GetPivot()

    piece(
        sheath, "Body",
        Vector3.new(0.55, 0.55, 5.5),
        sheathCF * CFrame.new(0, 0, -2.2),
        C.Black
    )

    piece(
        sheath, "MetalTip",
        Vector3.new(0.65, 0.65, 0.25),
        sheathCF * CFrame.new(0, 0, -4.85),
        C.Gold,
        Enum.Material.Metal
    )

    -- Katana independente, controlada pelo braco.
    local sword = createGroup(
        model,
        "DimensionalKatana",
        CFrame.new(0, 0, 0)
    )

    local swordCF = sword:GetPivot()

    piece(
        sword, "Handle",
        Vector3.new(0.4, 0.4, 1.8),
        swordCF * CFrame.new(0, 0, -0.9),
        C.Black
    )

    piece(
        sword, "Guard",
        Vector3.new(1.25, 0.18, 0.55),
        swordCF * CFrame.new(0, 0, -1.85),
        C.Gold,
        Enum.Material.Metal
    )

    piece(
        sword, "Blade",
        Vector3.new(0.2, 0.5, 5.1),
        swordCF * CFrame.new(0, 0, -4.55),
        C.Silver,
        Enum.Material.Metal
    )

    piece(
        sword, "EnergyEdge",
        Vector3.new(0.09, 0.12, 4.9),
        swordCF * CFrame.new(0, 0.3, -4.55),
        C.Cyan,
        Enum.Material.Neon
    )

    -- Posiciona o conjunto no mundo.
    model:PivotTo(spawnCF)

    GuardianBuilder.SetPose(model, "Idle", 0)

    return model
end

-- t vai de 0 a 1.
-- Idle: espada baixa
-- Ready: mao sobe para preparar o golpe
-- Slash: corte atravessando a frente do corpo

function GuardianBuilder.SetPose(
    model: Model,
    pose: string,
    t: number
)
    local root = model:GetPivot()
    local arm = model:FindFirstChild("RightArm")
    local sword = model:FindFirstChild("DimensionalKatana")
    local leftArm = model:FindFirstChild("LeftArm")

    if not arm or not sword or not leftArm then
        return
    end

    local alpha = math.clamp(t, 0, 1)

    local pitch = 0
    local roll = 0
    local yaw = 0

    if pose == "Ready" then
        pitch = math.rad(-75) * alpha
        roll = math.rad(12) * alpha
    elseif pose == "Slash" then
        pitch = math.rad(-75)
        yaw = math.rad(-115) * alpha
        roll = math.rad(12 + 75 * alpha)
    elseif pose == "Finish" then
        pitch = math.rad(-55)
        yaw = math.rad(-115)
        roll = math.rad(85)
    end

    local shoulderCF =
        root
        * CFrame.new(2.25, 6.65, 0)
        * CFrame.Angles(pitch, yaw, roll)

    (arm :: Model):PivotTo(shoulderCF)

    -- Espada acompanha a posicao do braco.
    local swordCF =
        shoulderCF
        * CFrame.new(0, -3.0, -0.1)
        * CFrame.Angles(math.rad(85), 0, 0)

    (sword :: Model):PivotTo(swordCF)

    local leftCF =
        root
        * CFrame.new(-2.25, 6.65, 0)
        * CFrame.Angles(
            math.rad(-12 * alpha),
            0,
            math.rad(-5 * alpha)
        )

    (leftArm :: Model):PivotTo(leftCF)
end

return GuardianBuilder
