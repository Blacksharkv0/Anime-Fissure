--!strict
-- ANIME FISSURE | OverlordTowerModelBuilder v0.1
-- Seis rigs R6 low-poly com volumes/fisionomias/armas exclusivos.
-- Todos os modelos sao PREVIEW VISUAL, nao torres jogaveis.
-- Root esta a 3 studs do solo; Build retorna modelo na origem do mundo.
-- Quatro estagios VISUAIS: base + 3 mudancas de ataque nos upgrades.
-- Sem meshes externos, decal IDs, animacoes proprietarias, drops ou data store.
-- Rigs Motor6D preparados para animacoes futuras.

local Roster = require(script.Parent:WaitForChild("OverlordUnitRoster"))
local Progression = require(script.Parent:WaitForChild("OverlordModelProgression"))
local CharacterArt = require(script.Parent:WaitForChild("OverlordCharacterArtPass"))
local ModelFinish = require(script.Parent:WaitForChild("OverlordModelFinish"))
local Builder = {}
Builder.Version = "0.9.0"

local C = {
    White = Color3.fromRGB(239, 238, 239),
    Silver = Color3.fromRGB(171, 191, 205),
    Steel = Color3.fromRGB(102, 129, 154),
    PaleSteel = Color3.fromRGB(197, 214, 218),
    Gold = Color3.fromRGB(240, 189, 98),
    GoldBright = Color3.fromRGB(255, 229, 139),
    Black = Color3.fromRGB(19, 20, 32),
    Coal = Color3.fromRGB(34, 35, 49),
    Deep = Color3.fromRGB(37, 25, 56),
    Purple = Color3.fromRGB(125, 75, 173),
    BrightPurple = Color3.fromRGB(193, 120, 250),
    Red = Color3.fromRGB(175, 48, 70),
    Ruby = Color3.fromRGB(250, 72, 106),
    Maroon = Color3.fromRGB(91, 32, 58),
    Brown = Color3.fromRGB(88, 57, 43),
    Leather = Color3.fromRGB(94, 71, 60),
    Tan = Color3.fromRGB(165, 127, 90),
    Navy = Color3.fromRGB(39, 54, 89),
    Blue = Color3.fromRGB(72, 153, 239),
    Ice = Color3.fromRGB(145, 229, 255),
    Skin = Color3.fromRGB(233, 190, 160),
    SkinPale = Color3.fromRGB(243, 216, 218),
    Ivory = Color3.fromRGB(234, 224, 198),
    Blonde = Color3.fromRGB(231, 197, 92),
    Yellow = Color3.fromRGB(252, 229, 139),
    EyeBlue = Color3.fromRGB(65, 149, 225),
    EyeGold = Color3.fromRGB(231, 183, 78),
}

local function piece(parent: Instance, name: string, size: Vector3,
    cf: CFrame, color: Color3, material: Enum.Material?,
    kind: string?): BasePart
    local p: BasePart
    if kind == "Wedge" then
        p = Instance.new("WedgePart")
    else
        local r = Instance.new("Part")
        if kind == "Ball" then r.Shape = Enum.PartType.Ball
        elseif kind == "Cylinder" then r.Shape = Enum.PartType.Cylinder end
        p = r
    end
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = false
    p.CanCollide = false
    p.CanTouch = false
    -- Corpo do R6 selecionavel no combate; acessorios sao puramente visuais.
    p.CanQuery = parent:IsA("Model") and name ~= "HumanoidRootPart"
    p.Massless = true
    p.CastShadow = false -- muitos acessorios: reduzir custo das sombras no mobile
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent
    return p
end

local function motor(name: string, from: BasePart, to: BasePart)
    local m = Instance.new("Motor6D")
    m.Name = name
    m.Part0 = from
    m.Part1 = to
    m.C0 = from.CFrame:ToObjectSpace(to.CFrame)
    m.C1 = CFrame.identity
    m.Parent = from
end

local function mount(folder: Instance, base: BasePart, name: string,
    size: Vector3, localCF: CFrame, color: Color3, material: Enum.Material?,
    kind: string?): BasePart
    local p = piece(folder, name, size, base.CFrame * localCF, color, material, kind)
    local w = Instance.new("WeldConstraint")
    w.Name = "AccessoryWeld"
    w.Part0 = base
    w.Part1 = p
    w.Parent = p
    return p
end

local function eye(folder: Instance, head: BasePart,
    x: number, y: number, color: Color3, pupil: Color3)
    mount(folder, head, "Sclera", Vector3.new(0.23, 0.21, 0.075),
        CFrame.new(x, y, -0.655), color)
    mount(folder, head, "Pupil", Vector3.new(0.11, 0.15, 0.086),
        CFrame.new(x, y - 0.005, -0.703), pupil)
    mount(folder, head, "Eyebrow", Vector3.new(0.32, 0.08, 0.08),
        CFrame.new(x, y + 0.20, -0.658), C.Coal)
end

local function rig(id: string, rarity: string)
    local model = Instance.new("Model")
    model.Name = id .. "_" .. rarity
    model:SetAttribute("UnitId", id)
    model:SetAttribute("Rarity", rarity)
    model:SetAttribute("VisualStage", 0)
    model:SetAttribute("VisualStages", 3)
    model:SetAttribute("PreviewOnly", true)
    model:SetAttribute("CombatReady", false)
    model:SetAttribute("RigType", "R6")
    model:SetAttribute("BuilderVersion", Builder.Version)

    local root = piece(model, "HumanoidRootPart", Vector3.new(2, 2, 1),
        CFrame.new(0, 3, 0), C.White)
    root.Transparency = 1
    root.Anchored = true
    root.CanQuery = false
    model.PrimaryPart = root

    local torso = piece(model, "Torso", Vector3.new(2, 2, 1),
        CFrame.new(0, 3.02, 0), C.Coal)
    local head = piece(model, "Head", Vector3.new(1.35, 1.34, 1.35),
        CFrame.new(0, 4.61, 0), C.Skin)
    local la = piece(model, "Left Arm", Vector3.new(0.73, 1.85, 0.78),
        CFrame.new(-1.40, 2.99, 0), C.Silver)
    local ra = piece(model, "Right Arm", Vector3.new(0.73, 1.85, 0.78),
        CFrame.new(1.40, 2.99, 0), C.Silver)
    local ll = piece(model, "Left Leg", Vector3.new(0.86, 1.95, 0.85),
        CFrame.new(-0.50, 1.05, 0), C.Navy)
    local rl = piece(model, "Right Leg", Vector3.new(0.86, 1.95, 0.85),
        CFrame.new(0.50, 1.05, 0), C.Navy)
    motor("RootJoint", root, torso)
    motor("Neck", torso, head)
    motor("Left Shoulder", torso, la)
    motor("Right Shoulder", torso, ra)
    motor("Left Hip", torso, ll)
    motor("Right Hip", torso, rl)

    local humanoid = Instance.new("Humanoid")
    humanoid.Name = "Humanoid"
    humanoid.WalkSpeed = 0
    humanoid.AutoRotate = false
    humanoid.BreakJointsOnDeath = false
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    humanoid.RequiresNeck = true
    humanoid.RigType = Enum.HumanoidRigType.R6
    humanoid.Parent = model
    local animator = Instance.new("Animator")
    animator.Parent = humanoid

    local base = Instance.new("Folder")
    base.Name = "BaseAccessories"
    base.Parent = model

    return model, {
        Root = root, Torso = torso, Head = head,
        LA = la, RA = ra, LL = ll, RL = rl, Base = base,
    }
end

local function boots(r: any, color: Color3)
    for _, leg in ipairs({r.LL, r.RL}) do
        mount(r.Base, leg, "HighBoot", Vector3.new(0.91, 0.82, 0.99),
            CFrame.new(0, -0.53, -0.055), color, Enum.Material.SmoothPlastic)
    end
end

local function pauldrons(r: any, color: Color3, trim: Color3, size: number)
    for _, arm in ipairs({r.LA, r.RA}) do
        mount(r.Base, arm, "ShoulderArmor", Vector3.new(size, 0.74, 1.13),
            CFrame.new(0, 0.79, 0), color, Enum.Material.Metal)
        mount(r.Base, arm, "ShoulderInsignia", Vector3.new(0.42, 0.14, 0.19),
            CFrame.new(0, 1.02, -0.56), trim, Enum.Material.Metal)
    end
end

local function sword(r: any, name: string, blade: Color3,
    length: number, width: number, grip: Color3)
    mount(r.Base, r.RA, name .. "_Grip", Vector3.new(0.20, 1.00, 0.20),
        CFrame.new(0, -0.69, -0.59), grip, Enum.Material.Wood)
    mount(r.Base, r.RA, name .. "_Guard", Vector3.new(width + 0.52, 0.18, 0.27),
        CFrame.new(0, -0.11, -0.59), C.Gold, Enum.Material.Metal)
    mount(r.Base, r.RA, name .. "_Blade", Vector3.new(width, length, 0.16),
        CFrame.new(0, length * 0.50 - 0.05, -0.59), blade, Enum.Material.Metal)
    mount(r.Base, r.RA, name .. "_Tip", Vector3.new(width * 0.76, 0.48, 0.17),
        CFrame.new(0, length + 0.17, -0.59), blade, Enum.Material.Metal, "Wedge")
end

local function characterClimb(r: any)
    r.Torso.Color = C.PaleSteel
    r.Head.Color = C.Skin
    r.LA.Color = C.PaleSteel
    r.RA.Color = C.PaleSteel
    r.LL.Color = C.Silver
    r.RL.Color = C.Silver
    boots(r, C.Steel)
    pauldrons(r, C.PaleSteel, C.Blue, 1.06)
    mount(r.Base, r.Torso, "BrightSilverBreastplate", Vector3.new(1.90, 1.49, 0.29),
        CFrame.new(0, 0.10, -0.51), C.White, Enum.Material.Metal)
    mount(r.Base, r.Torso, "ChestCrest", Vector3.new(0.43, 0.59, 0.14),
        CFrame.new(0, 0.25, -0.72), C.Blue, Enum.Material.Metal)
    mount(r.Base, r.Torso, "PurpleRoyalBelt", Vector3.new(2.03, 0.25, 1.13),
        CFrame.new(0, -0.85, 0), C.Purple, Enum.Material.Fabric)
    mount(r.Base, r.Head, "BlondeHair", Vector3.new(1.37, 0.42, 1.37),
        CFrame.new(0, 0.58, -0.01), C.Blonde, Enum.Material.SmoothPlastic, "Ball")
    for _, x in ipairs({-0.35, 0, 0.34}) do
        mount(r.Base, r.Head, "BlondeFringe", Vector3.new(0.36, 0.49, 0.36),
            CFrame.new(x, 0.40, -0.48)
                * CFrame.Angles(math.rad(18), 0, math.rad(x * 13)),
            C.Yellow, Enum.Material.SmoothPlastic, "Wedge")
    end
    for _, x in ipairs({-0.30, 0.30}) do eye(r.Base, r.Head, x, 0.07, C.White, C.EyeBlue) end
    sword(r, "GuardSword", C.Silver, 2.3, 0.33, C.Brown)
end

local function characterBrain(r: any)
    r.Torso.Color = C.Navy
    r.Head.Color = C.Skin
    r.LA.Color = C.Navy
    r.RA.Color = C.Navy
    r.LL.Color = C.Coal
    r.RL.Color = C.Coal
    boots(r, C.Black)
    mount(r.Base, r.Torso, "BlackRoninVest", Vector3.new(1.73, 1.71, 0.21),
        CFrame.new(0, -0.02, -0.52), C.Coal, Enum.Material.Fabric)
    mount(r.Base, r.Torso, "PurpleSash", Vector3.new(2.12, 0.40, 1.17),
        CFrame.new(0, -0.65, 0) * CFrame.Angles(0, 0, math.rad(-10)),
        C.Purple, Enum.Material.Fabric)
    mount(r.Base, r.Head, "DarkHairCap", Vector3.new(1.44, 0.53, 1.44),
        CFrame.new(0, 0.63, 0), C.Black, Enum.Material.SmoothPlastic, "Ball")
    for _, x in ipairs({-0.38, 0.35}) do
        mount(r.Base, r.Head, "DarkLongSideLock", Vector3.new(0.31, 0.98, 0.37),
            CFrame.new(x * 1.45, 0.01, -0.06), C.Coal, Enum.Material.SmoothPlastic)
    end
    for _, x in ipairs({-0.29, 0.29}) do eye(r.Base, r.Head, x, 0.04, C.White, C.Coal) end
    mount(r.Base, r.Torso, "KatanaScabbard", Vector3.new(0.26, 3.14, 0.28),
        CFrame.new(-0.95, -0.39, 0.35) * CFrame.Angles(0, 0, math.rad(38)),
        C.Black, Enum.Material.Metal)
    sword(r, "Katana", C.PaleSteel, 2.7, 0.19, C.Black)
end

local function characterGazef(r: any)
    r.Torso.Color = C.Red
    r.Head.Color = C.Skin
    r.LA.Color = C.Steel
    r.RA.Color = C.Steel
    r.LL.Color = C.Tan
    r.RL.Color = C.Tan
    boots(r, C.Brown)
    pauldrons(r, C.Silver, C.Gold, 1.34)
    mount(r.Base, r.Torso, "CrimsonPlate", Vector3.new(1.89, 1.80, 0.27),
        CFrame.new(0, 0.06, -0.58), C.Red, Enum.Material.Metal)
    for _, side in ipairs({-1, 1}) do
        mount(r.Base, r.Torso, "GoldenChestRibbon", Vector3.new(0.21, 2.1, 0.17),
            CFrame.new(side * 0.39, 0.07, -0.75)
                * CFrame.Angles(0, 0, math.rad(-side * 26)),
            C.Gold, Enum.Material.Metal)
        mount(r.Base, r.Torso, "CrimsonCape", Vector3.new(0.95, 2.9, 0.12),
            CFrame.new(side * 0.54, -0.65, 0.78)
                * CFrame.Angles(math.rad(12), 0, math.rad(side * 13)),
            C.Maroon, Enum.Material.Fabric)
    end
    mount(r.Base, r.Head, "DarkBrownHair", Vector3.new(1.49, 0.46, 1.42),
        CFrame.new(0, 0.56, 0), C.Brown, Enum.Material.SmoothPlastic, "Ball")
    mount(r.Base, r.Head, "ShortHairFront", Vector3.new(1.12, 0.23, 0.4),
        CFrame.new(0, 0.34, -0.47), C.Brown)
    for _, x in ipairs({-0.31, 0.31}) do eye(r.Base, r.Head, x, 0.02, C.White, C.Brown) end
    mount(r.Base, r.Head, "Stubble", Vector3.new(0.86, 0.17, 0.07),
        CFrame.new(0, -0.33, -0.65), C.Brown)
    sword(r, "RazorEdge", C.White, 3.05, 0.43, C.Tan)
end

local function characterShalltear(r: any)
    r.Torso.Color = C.Maroon
    r.Head.Color = C.SkinPale
    r.LA.Color = C.SkinPale
    r.RA.Color = C.SkinPale
    r.LL.Color = C.White
    r.RL.Color = C.White
    boots(r, C.Maroon)
    mount(r.Base, r.Torso, "GothicCorset", Vector3.new(1.87, 1.78, 0.29),
        CFrame.new(0, 0.11, -0.49), C.Maroon, Enum.Material.Fabric)
    mount(r.Base, r.Torso, "GothicGown", Vector3.new(2.79, 2.48, 1.62),
        CFrame.new(0, -1.55, 0), C.Red, Enum.Material.Fabric)
    for _, side in ipairs({-1, 1}) do
        mount(r.Base, r.Torso, "DressRuffle", Vector3.new(0.60, 2.22, 0.26),
            CFrame.new(side * 1.08, -1.58, -0.66), C.White, Enum.Material.Fabric)
        mount(r.Base, r.Head, "LongSilverSideHair", Vector3.new(0.49, 2.10, 0.62),
            CFrame.new(side * 0.55, -0.74, 0.22), C.Silver,
            Enum.Material.SmoothPlastic, "Ball")
        mount(r.Base, if side < 0 then r.LA else r.RA, "PuffedSleeve",
            Vector3.new(1.07, 0.87, 1.0), CFrame.new(0, 0.68, 0),
            C.White, Enum.Material.Fabric, "Ball")
    end
    mount(r.Base, r.Head, "WhiteBlondeHair", Vector3.new(1.47, 0.58, 1.44),
        CFrame.new(0, 0.54, 0), C.White, Enum.Material.SmoothPlastic, "Ball")
    mount(r.Base, r.Head, "RoseHeaddress", Vector3.new(1.19, 0.2, 0.29),
        CFrame.new(0, 0.52, -0.41), C.Red, Enum.Material.Fabric)
    for _, x in ipairs({-0.30, 0.30}) do eye(r.Base, r.Head, x, 0.02, C.White, C.Ruby) end
    mount(r.Base, r.RA, "SpuitLanceShaft", Vector3.new(0.19, 4.38, 0.18),
        CFrame.new(0.12, 0.39, -0.62), C.Steel, Enum.Material.Metal)
    mount(r.Base, r.RA, "SpuitLanceCrystal", Vector3.new(0.85, 1.05, 0.58),
        CFrame.new(0.12, 2.74, -0.62), C.Ruby, Enum.Material.Glass, "Wedge")
    mount(r.Base, r.RA, "SpuitLanceWing", Vector3.new(1.02, 0.18, 0.54),
        CFrame.new(0.12, 2.02, -0.62), C.Gold, Enum.Material.Metal)
end

local function characterAlbedo(r: any)
    r.Torso.Color = C.White
    r.Head.Color = C.SkinPale
    r.LA.Color = C.White
    r.RA.Color = C.White
    r.LL.Color = C.White
    r.RL.Color = C.White
    boots(r, C.White)
    mount(r.Base, r.Torso, "SnowDress", Vector3.new(2.45, 3.09, 1.55),
        CFrame.new(0, -1.27, 0), C.White, Enum.Material.Fabric)
    mount(r.Base, r.Torso, "GoldNecklace", Vector3.new(0.70, 0.18, 0.31),
        CFrame.new(0, 0.72, -0.58), C.Gold, Enum.Material.Metal)
    mount(r.Base, r.Torso, "BlackDressWaist", Vector3.new(1.85, 0.24, 1.25),
        CFrame.new(0, -0.5, 0), C.Black, Enum.Material.Fabric)
    for _, side in ipairs({-1, 1}) do
        mount(r.Base, r.Head, "BlackLongHair", Vector3.new(0.46, 2.65, 0.65),
            CFrame.new(side * 0.56, -0.88, 0.36), C.Black,
            Enum.Material.SmoothPlastic, "Ball")
        mount(r.Base, r.Head, "BlackHorn", Vector3.new(0.37, 0.91, 0.37),
            CFrame.new(side * 0.52, 1.05, 0.0)
                * CFrame.Angles(0, 0, math.rad(side * 19)),
            C.Black, Enum.Material.SmoothPlastic, "Wedge")
        for i = 1, 3 do
            mount(r.Base, r.Torso, "BlackFeatherWing", Vector3.new(0.81, 2.95 - i * 0.32, 0.28),
                CFrame.new(side * (1.26 + i * 0.37), 1.04 - i * 0.20, 0.64)
                    * CFrame.Angles(0, math.rad(side * 14), math.rad(side * (25 + i * 8))),
                C.Black, Enum.Material.SmoothPlastic, "Wedge")
        end
    end
    mount(r.Base, r.Head, "LongBlackHairTop", Vector3.new(1.46, 0.47, 1.46),
        CFrame.new(0, 0.65, 0), C.Black, Enum.Material.SmoothPlastic, "Ball")
    for _, x in ipairs({-0.30, 0.30}) do eye(r.Base, r.Head, x, 0.04, C.White, C.EyeGold) end
    mount(r.Base, r.RA, "GuardianHalberdStaff", Vector3.new(0.18, 4.0, 0.2),
        CFrame.new(0.12, 0.08, -0.65), C.Gold, Enum.Material.Metal)
    mount(r.Base, r.RA, "GuardianHalberdBlade", Vector3.new(1.18, 1.24, 0.21),
        CFrame.new(0.39, 2.09, -0.65) * CFrame.Angles(0, 0, math.rad(23)),
        C.Silver, Enum.Material.Metal, "Wedge")
end

local function characterAinz(r: any)
    r.Torso.Color = C.Black
    r.Head.Color = C.Ivory
    r.LA.Color = C.Black
    r.RA.Color = C.Black
    r.LL.Color = C.Deep
    r.RL.Color = C.Deep
    boots(r, C.Black)
    mount(r.Base, r.Torso, "OverlordRobes", Vector3.new(2.82, 3.03, 1.45),
        CFrame.new(0, -1.24, 0), C.Deep, Enum.Material.Fabric)
    mount(r.Base, r.Torso, "RoyalInnerGown", Vector3.new(1.79, 2.93, 0.18),
        CFrame.new(0, -1.19, -0.74), C.Purple, Enum.Material.Fabric)
    mount(r.Base, r.Torso, "BoneRibsPlate", Vector3.new(1.61, 1.37, 0.13),
        CFrame.new(0, 0.14, -0.68), C.Coal, Enum.Material.Metal)
    for _, side in ipairs({-1, 1}) do
        mount(r.Base, r.Torso, "RibBone", Vector3.new(0.19, 1.37, 0.17),
            CFrame.new(side * 0.36, 0.06, -0.85), C.Ivory, Enum.Material.SmoothPlastic)
        mount(r.Base, if side < 0 then r.LA else r.RA,
            "RoyalPauldron", Vector3.new(1.52, 0.86, 1.31),
            CFrame.new(0, 0.81, 0), C.Silver, Enum.Material.Metal)
        local orb = mount(r.Base, if side < 0 then r.LA else r.RA,
            "RedOverlordOrb", Vector3.new(0.73, 0.73, 0.73),
            CFrame.new(0, 1.23, -0.13), C.Ruby, Enum.Material.Glass, "Ball")
        local light = Instance.new("PointLight")
        light.Color = C.Ruby
        light.Brightness = 0.6
        light.Range = 8
        light.Shadows = false
        light.Parent = orb
        mount(r.Base, r.Head, "SkullEyeSocket", Vector3.new(0.35, 0.27, 0.12),
            CFrame.new(side * 0.31, 0.05, -0.63), C.Black, Enum.Material.Slate)
        mount(r.Base, r.Head, "SkullRedGlowingEye", Vector3.new(0.13, 0.12, 0.08),
            CFrame.new(side * 0.31, 0.06, -0.70), C.Ruby, Enum.Material.Neon, "Ball")
    end
    mount(r.Base, r.Head, "SkullNoseVoid", Vector3.new(0.22, 0.24, 0.07),
        CFrame.new(0, -0.18, -0.665), C.Black)
    mount(r.Base, r.Head, "SkullMouthVoid", Vector3.new(0.68, 0.27, 0.09),
        CFrame.new(0, -0.40, -0.66), C.Black)
    for _, x in ipairs({-0.22, 0, 0.22}) do
        mount(r.Base, r.Head, "SkullTeeth", Vector3.new(0.11, 0.18, 0.06),
            CFrame.new(x, -0.44, -0.716), C.Ivory)
    end
    mount(r.Base, r.Head, "DarkOverlordHood", Vector3.new(1.77, 0.70, 1.79),
        CFrame.new(0, 0.69, 0.08), C.Deep, Enum.Material.Fabric)
    mount(r.Base, r.Head, "GoldHoodTrim", Vector3.new(1.65, 0.13, 0.23),
        CFrame.new(0, 0.40, -0.67), C.Gold, Enum.Material.Metal)
    mount(r.Base, r.RA, "OverlordStaffShaft", Vector3.new(0.23, 4.13, 0.23),
        CFrame.new(0.10, 0.32, -0.70), C.Gold, Enum.Material.Metal)
    mount(r.Base, r.RA, "OverlordStaffTopGem", Vector3.new(0.91, 1.03, 0.91),
        CFrame.new(0.10, 2.52, -0.70), C.Purple, Enum.Material.Glass, "Ball")
end

local function ring(folder: Instance, base: BasePart, radius: number,
    vertical: number, color: Color3, segments: number)
    for i = 1, segments do
        local angle = ((i - 1) / segments) * math.pi * 2
        mount(folder, base, "AttackArc", Vector3.new(0.12, 0.11,
            radius * math.pi * 2 / segments * 0.80),
            CFrame.new(math.cos(angle) * radius, vertical, math.sin(angle) * radius)
                * CFrame.Angles(0, -angle, 0),
            color, Enum.Material.Neon)
    end
end

local function slash(folder: Instance, base: BasePart,
    name: string, x: number, y: number, z: number,
    angle: number, color: Color3, length: number)
    local p = mount(folder, base, name, Vector3.new(0.15, length, 0.15),
        CFrame.new(x, y, z) * CFrame.Angles(0, 0, math.rad(angle)),
        color, Enum.Material.Neon)
    p.Transparency = 0.15
end

local function updateStageVisual(id: string, holder: Instance, r: any, stage: number)
    local t = r.Torso
    local ra = r.RA
    if id == "OVL_Climb" then
        if stage == 1 then
            mount(holder, ra, "BlueBladeAwakening", Vector3.new(0.12, 2.74, 0.10),
                CFrame.new(0, 1.05, -0.77), C.Ice, Enum.Material.Neon)
        elseif stage == 2 then
            for n = 1, 4 do
                slash(holder, t, "FortressArc", (n - 2.5) * 0.50, 0.7, -1.02,
                    n * 31, C.GoldBright, 1.38)
            end
        else
            ring(holder, t, 2.52, -2.71, C.Gold, 12)
            mount(holder, t, "LimitBreakerCrest", Vector3.new(1.13, 1.16, 0.13),
                CFrame.new(0, 0.30, -1.0), C.GoldBright, Enum.Material.Neon, "Wedge")
        end
    elseif id == "OVL_Brain" then
        if stage == 1 then
            mount(holder, ra, "GodFlashBladeGlow", Vector3.new(0.09, 3.11, 0.08),
                CFrame.new(0, 1.18, -0.76), C.Ice, Enum.Material.Neon)
        elseif stage == 2 then
            for n = 1, 4 do
                slash(holder, t, "NailClipperCut", (n - 2.5) * 0.43, 0.45, -1.03,
                    if n % 2 == 0 then 51 else -51, C.Silver, 2.14)
            end
        else
            ring(holder, t, 2.52, -2.76, C.Ice, 12)
            for n = 1, 6 do
                slash(holder, t, "TrueNailClipperCut", (n - 3.5) * 0.24, 0.60, -1.12,
                    -61 + n * 19, C.Ice, 1.66)
            end
        end
    elseif id == "OVL_Gazef" then
        if stage == 1 then
            for n = 1, 4 do
                slash(holder, t, "FourfoldArc", (n - 2.5) * 0.42, 0.26, -1.23,
                    14 + n * 19, C.Gold, 1.48)
            end
        elseif stage == 2 then
            mount(holder, ra, "RazorEdgeAwakened", Vector3.new(0.13, 3.25, 0.10),
                CFrame.new(0, 1.09, -0.77), C.Ice, Enum.Material.Neon)
            ring(holder, t, 2.35, -2.71, C.Blue, 10)
        else
            for n = 1, 6 do
                slash(holder, t, "SixfoldSlash", (n - 3.5) * 0.34, 0.58, -1.49,
                    n * 29, C.GoldBright, 1.85)
            end
        end
    elseif id == "OVL_Shalltear" then
        if stage == 1 then
            mount(holder, ra, "BloodLanceCrystal", Vector3.new(0.30, 1.36, 0.27),
                CFrame.new(0.12, 2.47, -0.61), C.Ruby, Enum.Material.Neon, "Wedge")
        elseif stage == 2 then
            mount(holder, t, "BloodFrenzyArmor", Vector3.new(1.79, 1.42, 0.32),
                CFrame.new(0, 0.23, -0.76), C.Maroon, Enum.Material.Metal)
            for _, side in ipairs({-1, 1}) do
                mount(holder, t, "ArmoredGauntlet", Vector3.new(0.56, 1.33, 0.18),
                    CFrame.new(side * 0.78, 0.13, -0.82), C.Silver, Enum.Material.Metal)
            end
        else
            ring(holder, t, 2.44, -2.65, C.Ruby, 14)
            -- Silhueta de Einherjar: decoracao de preview, NAO uma unidade adicional.
            local ghost = mount(holder, t, "EinherjarPreview", Vector3.new(1.25, 2.85, 0.69),
                CFrame.new(2.8, -0.50, -0.09), C.White, Enum.Material.Glass)
            ghost.Transparency = 0.66
            local head = mount(holder, t, "EinherjarHead", Vector3.new(0.99, 0.99, 0.91),
                CFrame.new(2.8, 1.35, -0.09), C.White, Enum.Material.Glass, "Ball")
            head.Transparency = 0.53
        end
    elseif id == "OVL_Albedo" then
        if stage == 1 then
            for _, side in ipairs({-1, 1}) do
                slash(holder, t, "WingAura", side * 2.28, 1.21, 0.18,
                    side * 34, C.Purple, 3.47)
            end
        elseif stage == 2 then
            mount(holder, t, "HermesBlackArmor", Vector3.new(1.93, 1.73, 0.33),
                CFrame.new(0, 0.14, -0.77), C.Coal, Enum.Material.Metal)
            for _, side in ipairs({-1, 1}) do
                mount(holder, t, "HermesGoldLine", Vector3.new(0.16, 1.40, 0.12),
                    CFrame.new(side * 0.62, 0.20, -0.99), C.Gold, Enum.Material.Metal)
            end
        else
            ring(holder, t, 2.82, -2.74, C.Gold, 14)
            ring(holder, t, 1.43, 3.3, C.GoldBright, 12)
            mount(holder, t, "GuardianShield", Vector3.new(1.60, 2.23, 0.25),
                CFrame.new(-1.95, -0.20, -1.11), C.Silver, Enum.Material.Metal)
        end
    elseif id == "OVL_Ainz" then
        if stage == 1 then
            for n = 1, 3 do
                slash(holder, t, "RealityRift", -1.0 + n * 0.56, 0.20, -1.10,
                    -35 + n * 30, C.BrightPurple, 2.13)
            end
        elseif stage == 2 then
            local heart = mount(holder, t, "SpectralHeart", Vector3.new(0.95, 1.06, 0.91),
                CFrame.new(0, 0.28, -1.42), C.Ruby, Enum.Material.Glass, "Ball")
            heart.Transparency = 0.17
            ring(holder, t, 2.55, -2.69, C.Purple, 12)
        else
            ring(holder, t, 3.18, -2.68, C.Ice, 16)
            ring(holder, t, 1.62, 3.08, C.Ice, 14)
            for _, side in ipairs({-1, 1}) do
                slash(holder, t, "FallenDownPillar", side * 2.52, 0.72, -0.22,
                    side * 3, C.Ice, 4.72)
            end
        end
    end
end

local characterBuilders = {
    OVL_Climb = characterClimb,
    OVL_Brain = characterBrain,
    OVL_Gazef = characterGazef,
    OVL_Shalltear = characterShalltear,
    OVL_Albedo = characterAlbedo,
    OVL_Ainz = characterAinz,
}

function Builder.Build(id: string): Model?
    local unit = Roster.Get(id)
    local buildCharacter = characterBuilders[id]
    if not unit or not buildCharacter then return nil end

    local model, parts = rig(id, unit.Rarity)
    buildCharacter(parts)
    assert(CharacterArt.Apply(model), "Art pass nao foi aplicado: " .. id)
    assert(ModelFinish.Apply(model), "Rosto e arma nao foram finalizados: " .. id)
    model:SetAttribute("DisplayName", unit.FullName)
    model:SetAttribute("Rarity", unit.Rarity)
    model:SetAttribute("PassivePlanned", unit.PassivePlanned == true)
    model:SetAttribute("BannerCandidate", unit.BannerCandidate == true)

    local visualParts = Instance.new("Folder")
    visualParts.Name = "ActiveVisualStage"
    visualParts.Parent = model

    -- Ancorar somente Root. Motores e WeldConstraint seguem o Root para
    -- futura animacao, sem a necessidade de 50+ pecas ancoradas.
    return model
end

function Builder.SetVisualStage(model: Model, value: number): boolean
    if not model or not model:IsA("Model") or typeof(value) ~= "number"
        or value % 1 ~= 0 or value < 0 or value > 3 then return false end
    local id = model:GetAttribute("UnitId")
    if typeof(id) ~= "string" or not Progression.Get(id, value) then return false end
    local torso = model:FindFirstChild("Torso")
    local ra = model:FindFirstChild("Right Arm")
    if not torso or not torso:IsA("BasePart")
        or not ra or not ra:IsA("BasePart") then return false end

    local current = model:FindFirstChild("ActiveVisualStage")
    if current then current:Destroy() end
    local holder = Instance.new("Folder")
    holder.Name = "ActiveVisualStage"
    holder.Parent = model

    local r = {Torso = torso, RA = ra}
    -- Estagios cumulativos: UP 3 preserva efeitos de UP 1 e UP 2.
    for stage = 1, value do
        updateStageVisual(id, holder, r, stage)
    end
    model:SetAttribute("VisualStage", value)
    local currentAttack = Progression.Get(id, value)
    if currentAttack then
        model:SetAttribute("PreviewAttackName", currentAttack.Name)
        model:SetAttribute("PreviewAttackPattern", currentAttack.Pattern)
    end
    return true
end

function Builder.BuildAll(parent: Instance): Folder
    local old = parent:FindFirstChild("OverlordTowerModels")
    if old then old:Destroy() end
    local library = Instance.new("Folder")
    library.Name = "OverlordTowerModels"
    library:SetAttribute("PreviewOnly", true)
    library:SetAttribute("Version", Builder.Version)
    library.Parent = parent
    for _, entry in ipairs(Roster.GetAll()) do
        local model = Builder.Build(entry.Id)
        assert(model, "Modelo Overlord indisponivel: " .. entry.Id)
        Builder.SetVisualStage(model, 0)
        model.Parent = library
    end
    return library
end

return Builder
