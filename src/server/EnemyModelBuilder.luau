--!strict
-- ANIME FISSURE | EnemyModelBuilder v0.5
-- Modelos 3D originais construidos com pecas Roblox (sem asset externo).
-- Apenas visual; vida, movimento e dano sao controlados no EnemyService.

local Builder = {}

local function part(parent: Model, name: string, size: Vector3, offset: Vector3,
    color: Color3, material: Enum.Material, shape: Enum.PartType?): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = CFrame.new(offset)
    p.Color = color
    p.Material = material
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = name == "Body"
    p.CastShadow = false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    if shape then p.Shape = shape end
    p.Parent = parent
    return p
end

local function text(parent: Instance, name: string, content: string, size: UDim2,
    pos: UDim2, fontSize: number, color: Color3): TextLabel
    local t = Instance.new("TextLabel")
    t.Name = name
    t.Size = size
    t.Position = pos
    t.BackgroundTransparency = 1
    t.Text = content
    t.Font = Enum.Font.GothamBold
    t.TextSize = fontSize
    t.TextColor3 = color
    t.TextStrokeTransparency = 0.45
    t.TextScaled = false
    t.TextWrapped = false
    t.Parent = parent
    return t
end

function Builder.Build(stats: any): Model
    local scale = stats.Size or 1
    local base = stats.Color or Color3.fromRGB(178, 70, 82)
    local accent = stats.Accent or Color3.fromRGB(83, 220, 255)
    local isAir = stats.Air == true
    local boss = stats.Boss == true
    local model = Instance.new("Model")
    model.Name = stats.Name or stats.Id or "Enemy"
    model:SetAttribute("EnemyId", stats.Id)
    model:SetAttribute("IsBoss", boss)
    model:SetAttribute("Health", stats.Health)
    model:SetAttribute("MaxHealth", stats.Health)
    model:SetAttribute("Air", isAir)

    local function v(x: number, y: number, z: number): Vector3
        return Vector3.new(x * scale, y * scale, z * scale)
    end
    local chest = part(model, "Body", v(2.15, 2.1, 1.2), v(0, 0, 0),
        base, Enum.Material.SmoothPlastic)
    model.PrimaryPart = chest
    part(model, "Head", v(1.4, 1.3, 1.35), v(0, 1.68, 0),
        Color3.fromRGB(224, 205, 182), Enum.Material.SmoothPlastic, Enum.PartType.Ball)
    part(model, "Helmet", v(1.58, 0.56, 1.45), v(0, 2.22, 0),
        base, Enum.Material.Metal)
    part(model, "Visor", v(1.12, 0.31, 0.14), v(0, 1.78, -0.7),
        accent, Enum.Material.Neon)
    part(model, "LeftArm", v(0.62, 2.0, 0.7), v(-1.39, -0.05, 0),
        base, Enum.Material.Metal)
    part(model, "RightArm", v(0.62, 2.0, 0.7), v(1.39, -0.05, 0),
        base, Enum.Material.Metal)
    part(model, "LeftLeg", v(0.77, 1.8, 0.88), v(-0.57, -1.91, 0),
        Color3.fromRGB(33, 40, 57), Enum.Material.Metal)
    part(model, "RightLeg", v(0.77, 1.8, 0.88), v(0.57, -1.91, 0),
        Color3.fromRGB(33, 40, 57), Enum.Material.Metal)
    part(model, "ArmorCore", v(0.65, 0.65, 0.16), v(0, 0.20, -0.69),
        accent, Enum.Material.Neon, Enum.PartType.Ball)

    if isAir then
        for _, side in ipairs({-1, 1}) do
            part(model, "Wing", v(2.3, 0.20, 1.2), v(side * 2.1, 0.72, 0.5),
                accent, Enum.Material.Neon)
        end
        part(model, "Halo", v(2, 0.16, 2), v(0, 3.05, 0),
            accent, Enum.Material.Neon, Enum.PartType.Cylinder)
    end

    if boss then
        part(model, "Mantle", v(2.6, 2.7, 0.20), v(0, -0.26, 0.78),
            Color3.fromRGB(65, 33, 103), Enum.Material.Fabric)
        for _, side in ipairs({-1, 1}) do
            part(model, "ShoulderCrest", v(1, 0.6, 1.3), v(side * 1.22, 1.1, 0),
                accent, Enum.Material.Metal)
        end
    end

    local overhead = Instance.new("BillboardGui")
    overhead.Name = "EnemyHealthGui"
    overhead.Size = UDim2.fromOffset(168, 57)
    overhead.StudsOffsetWorldSpace = Vector3.new(0, 3.95 * scale, 0)
    overhead.AlwaysOnTop = true
    overhead.MaxDistance = 110
    overhead.Adornee = chest
    overhead.Parent = chest

    local bg = Instance.new("Frame")
    bg.Size = UDim2.fromScale(1, 1)
    bg.BackgroundColor3 = Color3.fromRGB(7, 11, 24)
    bg.BackgroundTransparency = 0.12
    bg.BorderSizePixel = 0
    bg.Parent = overhead
    local rounded = Instance.new("UICorner")
    rounded.CornerRadius = UDim.new(0, 6)
    rounded.Parent = bg

    local nameLabel = text(bg, "NameLabel", model.Name, UDim2.fromScale(1, 0.48),
        UDim2.fromScale(0, 0.03), 13, if boss then Color3.fromRGB(255, 205, 118)
        else Color3.fromRGB(239, 246, 255))
    local barBG = Instance.new("Frame")
    barBG.Name = "HealthBackground"
    barBG.Size = UDim2.new(1, -16, 0, 8)
    barBG.Position = UDim2.new(0, 8, 0.65, 0)
    barBG.BackgroundColor3 = Color3.fromRGB(69, 30, 44)
    barBG.BorderSizePixel = 0
    barBG.Parent = bg
    local fill = Instance.new("Frame")
    fill.Name = "HealthFill"
    fill.Size = UDim2.fromScale(1, 1)
    fill.BackgroundColor3 = if boss then Color3.fromRGB(245, 151, 75)
        else Color3.fromRGB(83, 215, 168)
    fill.BorderSizePixel = 0
    fill.Parent = barBG
    local numbers = text(bg, "HealthText", "", UDim2.new(1, -14, 0, 14),
        UDim2.new(0, 7, 1, -16), 10, Color3.fromRGB(190, 211, 241))
    numbers.TextXAlignment = Enum.TextXAlignment.Center

    Builder.UpdateHealth(model, stats.Health, stats.Health)
    return model
end

function Builder.UpdateHealth(model: Model, health: number, maxHealth: number)
    model:SetAttribute("Health", math.max(0, math.floor(health)))
    model:SetAttribute("MaxHealth", maxHealth)
    local body = model:FindFirstChild("Body")
    local gui = if body then body:FindFirstChild("EnemyHealthGui") else nil
    if not gui then return end
    local bg = gui:FindFirstChildOfClass("Frame")
    if not bg then return end
    local bar = bg:FindFirstChild("HealthBackground")
    local fill = if bar then bar:FindFirstChild("HealthFill") else nil
    local numbers = bg:FindFirstChild("HealthText")
    if fill and fill:IsA("Frame") then
        fill.Size = UDim2.fromScale(math.clamp(health / math.max(1, maxHealth), 0, 1), 1)
    end
    if numbers and numbers:IsA("TextLabel") then
        numbers.Text = tostring(math.max(0, math.floor(health))) .. " / " .. tostring(maxHealth)
    end
end

return Builder
