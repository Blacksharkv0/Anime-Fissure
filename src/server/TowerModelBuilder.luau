--!strict
-- ANIME FISSURE | TowerModelBuilder v1.1
-- Representacoes 3D originais feitas com parts, nao meshes importadas.
-- Modelo ancorado com Root no chao; armas e corpo movem como conjunto.

local Builder = {}

local function piece(model: Model, name: string, size: Vector3, pose: CFrame,
    color: Color3, material: Enum.Material?, shape: Enum.PartType?): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = pose
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = true
    if shape then p.Shape = shape end
    p.Parent = model
    return p
end

local function addBody(model: Model, coat: Color3, accent: Color3, mask: boolean)
    piece(model, "Torso", Vector3.new(1.65, 1.9, 0.85),
        CFrame.new(0, 3.0, 0), coat, Enum.Material.Fabric)
    piece(model, "ArmorTrim", Vector3.new(0.58, 1.18, 0.10),
        CFrame.new(0, 3.15, -0.49), accent, Enum.Material.Metal)
    piece(model, "Neck", Vector3.new(0.46, 0.36, 0.5),
        CFrame.new(0, 4.1, 0), Color3.fromRGB(223, 187, 155))
    piece(model, "Head", Vector3.new(1.24, 1.33, 1.24),
        CFrame.new(0, 4.90, 0), Color3.fromRGB(223, 187, 155),
        Enum.Material.SmoothPlastic, Enum.PartType.Ball)
    for _, side in ipairs({-1, 1}) do
        piece(model, "AnimeEye", Vector3.new(0.28, 0.12, 0.06),
            CFrame.new(side * 0.27, 5.03, -0.58),
            accent, Enum.Material.Neon)
        piece(model, "Arm", Vector3.new(0.57, 1.72, 0.67),
            CFrame.new(side * 1.1, 3.12, 0), coat, Enum.Material.Fabric)
        piece(model, "Leg", Vector3.new(0.62, 1.72, 0.71),
            CFrame.new(side * 0.45, 1.38, 0), Color3.fromRGB(36, 47, 69),
            Enum.Material.Fabric)
        piece(model, "Boot", Vector3.new(0.72, 0.55, 0.94),
            CFrame.new(side * 0.45, 0.42, -0.09),
            Color3.fromRGB(36, 36, 50), Enum.Material.Leather)
    end
    piece(model, "HairCap", Vector3.new(1.33, 0.58, 1.33),
        CFrame.new(0, 5.56, 0), Color3.fromRGB(31, 38, 58),
        Enum.Material.SmoothPlastic, Enum.PartType.Ball)
    if mask then
        piece(model, "FaceMask", Vector3.new(0.97, 0.35, 0.20),
            CFrame.new(0, 4.75, -0.59), Color3.fromRGB(28, 35, 50),
            Enum.Material.Fabric)
    end
end

function Builder.Build(id: string, def: any): Model
    local model = Instance.new("Model")
    model.Name = def.Name
    local root = piece(model, "Root", Vector3.new(1, 0.5, 1),
        CFrame.new(0, 0.25, 0), Color3.new(1, 1, 1))
    root.Transparency = 1
    model.PrimaryPart = root

    local pedestal = piece(model, "Pedestal", Vector3.new(0.42, 5.1, 5.1),
        CFrame.new(0, 0.19, 0), Color3.fromRGB(19, 29, 56),
        Enum.Material.Slate, Enum.PartType.Cylinder)
    pedestal.CFrame *= CFrame.Angles(0, 0, math.rad(90))
    piece(model, "PlatformSigil", Vector3.new(0.18, 2.0, 2.0),
        CFrame.new(0, 0.48, 0), def.AttackColor,
        Enum.Material.Neon, Enum.PartType.Cylinder).CFrame *=
        CFrame.Angles(0, 0, math.rad(90))

    if id == "FissureBlade" then
        addBody(model, Color3.fromRGB(44, 79, 133), def.Color, false)
        piece(model, "BladeHandle", Vector3.new(0.19, 1.03, 0.22),
            CFrame.new(1.71, 2.7, -0.08), Color3.fromRGB(72, 52, 44),
            Enum.Material.Wood)
        piece(model, "SwordBlade", Vector3.new(0.36, 2.6, 0.12),
            CFrame.new(1.71, 4.27, -0.08), Color3.fromRGB(177, 229, 255),
            Enum.Material.Metal)
        piece(model, "BladeGuard", Vector3.new(0.95, 0.16, 0.34),
            CFrame.new(1.71, 3.3, -0.08), def.AttackColor, Enum.Material.Neon)
        piece(model, "LeftScarf", Vector3.new(0.36, 1.4, 0.23),
            CFrame.new(-0.64, 3.58, 0.56) * CFrame.Angles(0, 0, math.rad(14)),
            def.AttackColor, Enum.Material.Fabric)
    elseif id == "FissureMage" then
        addBody(model, Color3.fromRGB(87, 51, 132), def.Color, true)
        piece(model, "MageRobe", Vector3.new(1.98, 1.64, 1.02),
            CFrame.new(0, 1.86, 0), Color3.fromRGB(76, 41, 110),
            Enum.Material.Fabric)
        piece(model, "ArcaneStaff", Vector3.new(0.18, 3.7, 0.18),
            CFrame.new(1.72, 3.13, 0), Color3.fromRGB(109, 74, 56),
            Enum.Material.Wood)
        local orb = piece(model, "StaffGem", Vector3.new(0.93, 0.93, 0.93),
            CFrame.new(1.72, 5.15, 0), def.AttackColor,
            Enum.Material.Neon, Enum.PartType.Ball)
        local glow = Instance.new("PointLight")
        glow.Brightness = 0.8
        glow.Range = 10
        glow.Color = def.AttackColor
        glow.Parent = orb
    elseif id == "Capsule" then
        -- Base farm economica, ainda nao e modelo Bulma definitivo.
        piece(model, "FactoryBase", Vector3.new(3.3, 1.1, 2.8),
            CFrame.new(0, 1.10, 0), Color3.fromRGB(217, 226, 234),
            Enum.Material.Metal)
        piece(model, "CapsuleHousing", Vector3.new(2.1, 2.2, 2.1),
            CFrame.new(0, 2.55, 0), def.Color,
            Enum.Material.Glass, Enum.PartType.Ball)
        piece(model, "FactoryConsole", Vector3.new(2.5, 0.45, 1.05),
            CFrame.new(0, 2.05, -1.39) * CFrame.Angles(math.rad(19), 0, 0),
            Color3.fromRGB(36, 58, 82), Enum.Material.Metal)
        piece(model, "CapsuleLogo", Vector3.new(0.83, 0.22, 0.09),
            CFrame.new(0, 2.10, -1.96), def.AttackColor, Enum.Material.Neon)
        for _, side in ipairs({-1, 1}) do
            piece(model, "PowerCell", Vector3.new(0.55, 1.6, 0.65),
                CFrame.new(side * 1.15, 2.0, 0.75),
                def.AttackColor, Enum.Material.Neon)
        end
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "TowerLabel"
    billboard.Size = UDim2.fromOffset(170, 47)
    billboard.StudsOffsetWorldSpace = Vector3.new(0, if id == "Capsule" then 4.5 else 6.4, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 95
    billboard.Adornee = root
    billboard.Parent = root

    local text = Instance.new("TextLabel")
    text.Name = "UnitTitle"
    text.BackgroundColor3 = Color3.fromRGB(10, 17, 37)
    text.BackgroundTransparency = 0.2
    text.Size = UDim2.fromScale(1, 1)
    text.BorderSizePixel = 0
    text.TextColor3 = Color3.fromRGB(239, 244, 255)
    text.Font = Enum.Font.GothamBold
    text.TextScaled = true
    text.Text = def.Name .. "\nLV 0"
    text.Parent = billboard
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = text
    model:SetAttribute("UnitId", id)
    model:SetAttribute("Level", 0)
    return model
end

function Builder.UpdateLevel(model: Model, level: number)
    model:SetAttribute("Level", level)
    local root = model.PrimaryPart
    local label = if root then root:FindFirstChild("TowerLabel") else nil
    local text = if label then label:FindFirstChild("UnitTitle") else nil
    if text and text:IsA("TextLabel") then
        text.Text = model.Name .. "\nLV " .. tostring(level)
    end
end

return Builder
