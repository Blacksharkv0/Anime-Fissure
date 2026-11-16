--!strict
-- ANIME FISSURE | CapsuleInventionBuilder v0.1
-- Invention assets separados e reutilizaveis na arena e no ViewportFrame.
-- Level 4: impressora; Level 8: dispositivo de suporte.

local Builder = {}
Builder.Version = "0.1.0"

local BLUE = Color3.fromRGB(63, 171, 252)
local WHITE = Color3.fromRGB(221, 234, 246)
local GOLD = Color3.fromRGB(245, 191, 76)
local NAVY = Color3.fromRGB(28, 37, 70)
local CYAN = Color3.fromRGB(74, 230, 255)

local function add(parent: Instance, name: string, size: Vector3, cf: CFrame,
    color: Color3, material: Enum.Material, shape: Enum.PartType?): Part
    local p = Instance.new("Part")
    p.Name, p.Size, p.CFrame, p.Color, p.Material = name, size, cf, color, material
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    if shape then p.Shape = shape end
    p.Parent = parent
    return p
end

local function buildPrinter(): Model
    local m = Instance.new("Model")
    m.Name = "CapsuleCashPrinter"
    m:SetAttribute("UnlockedAtUpgrade", 4)
    m:SetAttribute("IncomeBonus", 0.20)
    local pivot = add(m, "Pivot", Vector3.new(0.1, 0.1, 0.1), CFrame.new(), NAVY, Enum.Material.SmoothPlastic)
    pivot.Transparency = 1
    m.PrimaryPart = pivot
    add(m, "Base", Vector3.new(3.1, 0.4, 2.1), CFrame.new(0, 0.3, 0), NAVY, Enum.Material.Metal)
    add(m, "Body", Vector3.new(2.8, 2.3, 1.9), CFrame.new(0, 1.65, 0), WHITE, Enum.Material.Metal)
    add(m, "UpperShell", Vector3.new(2.9, 0.45, 2), CFrame.new(0, 3, 0), GOLD, Enum.Material.Metal)
    add(m, "Reader", Vector3.new(2.2, 0.55, 0.14), CFrame.new(0, 2.25, -1.02), BLUE, Enum.Material.Neon)
    add(m, "PrintSlot", Vector3.new(1.9, 0.35, 0.15), CFrame.new(0, 1.55, -1.03), NAVY, Enum.Material.Metal)
    add(m, "PrintedYen", Vector3.new(1.45, 0.08, 1.2), CFrame.new(0, 1.22, -1.4), Color3.fromRGB(73, 228, 147), Enum.Material.Neon)
    for _, x in ipairs({-1.25, 1.25}) do
        add(m, "SideTrim", Vector3.new(0.16, 2.2, 1.95), CFrame.new(x, 1.65, 0), GOLD, Enum.Material.Metal)
    end
    return m
end

local function buildSupport(): Model
    local m = Instance.new("Model")
    m.Name = "CapsuleSupportDevice"
    m:SetAttribute("UnlockedAtUpgrade", 8)
    m:SetAttribute("IncomeBonus", 0.20)
    local pivot = add(m, "Pivot", Vector3.new(.1,.1,.1), CFrame.new(), NAVY, Enum.Material.SmoothPlastic)
    pivot.Transparency = 1
    m.PrimaryPart = pivot
    add(m, "Pad", Vector3.new(3, 0.45, 3), CFrame.new(0, .35, 0), NAVY, Enum.Material.Metal)
    add(m, "Column", Vector3.new(.7, 2.3, .7), CFrame.new(0, 1.6, 0), WHITE, Enum.Material.Metal)
    local head = add(m, "Dish", Vector3.new(.52, 2.9, 2.9),
        CFrame.new(0, 3.1, 0) * CFrame.Angles(0, 0, math.rad(90)) * CFrame.Angles(math.rad(20), 0, 0), WHITE, Enum.Material.Metal, Enum.PartType.Cylinder)
    add(m, "DishGlow", Vector3.new(.13, 2, 2), head.CFrame * CFrame.new(.35, 0, 0), CYAN, Enum.Material.Neon, Enum.PartType.Cylinder)
    add(m, "Antenna", Vector3.new(.14, 1.3, .14), CFrame.new(0, 3.75, -.3), GOLD, Enum.Material.Metal)
    add(m, "Signal", Vector3.new(.46,.46,.46), CFrame.new(0, 4.4, -.3), BLUE, Enum.Material.Neon, Enum.PartType.Ball)
    for _, x in ipairs({-1, 1}) do
        add(m, "EnergyCell", Vector3.new(.45,1.2,.45), CFrame.new(x,1.2,.9), CYAN, Enum.Material.Glass)
    end
    return m
end

function Builder.BuildOne(id: string): Model?
    if id == "CapsuleCashPrinter" then return buildPrinter() end
    if id == "CapsuleSupportDevice" then return buildSupport() end
    return nil
end

function Builder.BuildAll(parent: Instance): Folder
    local old = parent:FindFirstChild("CapsuleInventions")
    if old then old:Destroy() end
    local folder = Instance.new("Folder")
    folder.Name = "CapsuleInventions"
    folder.Parent = parent
    for _, id in ipairs({"CapsuleCashPrinter", "CapsuleSupportDevice"}) do
        local model = Builder.BuildOne(id)
        assert(model ~= nil, "Modelo de invencao inexistente: " .. id)
        model.Parent = folder
    end
    return folder
end

return Builder
