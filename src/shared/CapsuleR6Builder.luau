--!strict
-- ANIME FISSURE | CapsuleR6Builder v0.1
-- 4 variacoes: Lendaria, Lendaria Shiny, Mitica, Mitica Shiny.
-- R6 com Humanoid, Animator, Motor6D, RootJoint e pecas/acessorios separados.
-- Modelos para preview/colecao e futura colocacao, NAO invocam nem concedem unidades.

local Builder = {}
Builder.Version = "0.1.0"

local C = {
    Skin = Color3.fromRGB(247, 197, 161),
    Hair = Color3.fromRGB(25, 173, 234),
    Turquoise = Color3.fromRGB(48, 225, 226),
    Ice = Color3.fromRGB(140, 196, 255),
    Pink = Color3.fromRGB(247, 81, 148),
    Red = Color3.fromRGB(222, 43, 66),
    Purple = Color3.fromRGB(113, 55, 198),
    Blue = Color3.fromRGB(28, 99, 211),
    Yellow = Color3.fromRGB(252, 189, 60),
    Brown = Color3.fromRGB(93, 48, 38),
    Dark = Color3.fromRGB(27, 29, 50),
    White = Color3.fromRGB(229, 234, 248),
    Green = Color3.fromRGB(39, 120, 96),
    Olive = Color3.fromRGB(72, 82, 52),
    Gray = Color3.fromRGB(99, 105, 127),
    Gold = Color3.fromRGB(250, 204, 82),
}

local function corePart(model: Model, name: string, size: Vector3, pos: Vector3, color: Color3): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = CFrame.new(pos)
    p.Color = color
    p.Material = Enum.Material.SmoothPlastic
    p.Anchored = false
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = model
    return p
end

local function motor(name: string, base: BasePart, limb: BasePart, c0: CFrame, c1: CFrame)
    local m = Instance.new("Motor6D")
    m.Name = name
    m.Part0 = base
    m.Part1 = limb
    m.C0 = c0
    m.C1 = c1
    m.Parent = base
end

local function accessory(folder: Instance, limb: BasePart, name: string, size: Vector3,
    localCF: CFrame, color: Color3, material: Enum.Material?, shape: string?): BasePart
    local p: BasePart
    if shape == "Wedge" then
        p = Instance.new("WedgePart")
    else
        local part = Instance.new("Part")
        if shape == "Ball" then part.Shape = Enum.PartType.Ball end
        if shape == "Cylinder" then part.Shape = Enum.PartType.Cylinder end
        p = part
    end
    p.Name = name
    p.Size = size
    p.CFrame = limb.CFrame * localCF
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = false
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.Massless = true
    p.CastShadow = false
    p.Parent = folder
    local w = Instance.new("WeldConstraint")
    w.Name = "AccessoryWeld"
    w.Part0 = limb
    w.Part1 = p
    w.Parent = p
    return p
end

local function faceOn(head: BasePart)
    -- Rosto desenhado sem decals externos, preso a frente (-Z) da cabeca.
    local surface = Instance.new("SurfaceGui")
    surface.Name = "AnimeFace"
    surface.Face = Enum.NormalId.Front
    surface.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    surface.PixelsPerStud = 120
    surface.LightInfluence = 0
    surface.AlwaysOnTop = false
    surface.Parent = head

    local canvas = Instance.new("Frame")
    canvas.BackgroundTransparency = 1
    canvas.Size = UDim2.fromScale(1, 1)
    canvas.Parent = surface

    for _, x in ipairs({0.21, 0.61}) do
        local brow = Instance.new("Frame")
        brow.Name = "Eyebrow"
        brow.Position = UDim2.fromScale(x, 0.26)
        brow.Size = UDim2.fromScale(.18, .035)
        brow.BackgroundColor3 = C.Dark
        brow.BorderSizePixel = 0
        brow.Parent = canvas

        local eye = Instance.new("Frame")
        eye.Name = "Eye"
        eye.Position = UDim2.fromScale(x, .36)
        eye.Size = UDim2.fromScale(.19, .29)
        eye.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        eye.BorderSizePixel = 0
        eye.Parent = canvas
        local shape = Instance.new("UICorner")
        shape.CornerRadius = UDim.new(.45, 0)
        shape.Parent = eye
        local eyeStroke = Instance.new("UIStroke")
        eyeStroke.Thickness = 2
        eyeStroke.Color = C.Dark
        eyeStroke.Parent = eye

        local iris = Instance.new("Frame")
        iris.Name = "BlueIris"
        iris.Size = UDim2.fromScale(.56, .72)
        iris.Position = UDim2.fromScale(.26, .21)
        iris.BackgroundColor3 = C.Blue
        iris.BorderSizePixel = 0
        iris.Parent = eye
        local irisCorner = Instance.new("UICorner")
        irisCorner.CornerRadius = UDim.new(1, 0)
        irisCorner.Parent = iris
        local pupil = Instance.new("Frame")
        pupil.Name = "Pupil"
        pupil.Size = UDim2.fromScale(.42, .68)
        pupil.Position = UDim2.fromScale(.30, .24)
        pupil.BackgroundColor3 = C.Dark
        pupil.BorderSizePixel = 0
        pupil.Parent = iris
        local pupilCorner = Instance.new("UICorner")
        pupilCorner.CornerRadius = UDim.new(1, 0)
        pupilCorner.Parent = pupil
    end
    local mouth = Instance.new("TextLabel")
    mouth.Name = "Smile"
    mouth.Size = UDim2.fromScale(.34, .17)
    mouth.Position = UDim2.fromScale(.33, .70)
    mouth.BackgroundTransparency = 1
    mouth.Text = "⌣"
    mouth.TextColor3 = C.Dark
    mouth.TextScaled = true
    mouth.Font = Enum.Font.GothamBold
    mouth.Parent = canvas
end

local function insignia(surfacePart: BasePart, textValue: string, textColor: Color3)
    local gui = Instance.new("SurfaceGui")
    gui.Name = "ClothingInsignia"
    gui.Face = Enum.NormalId.Front
    gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    gui.PixelsPerStud = 95
    gui.LightInfluence = 0
    gui.Parent = surfacePart
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Symbol"
    textLabel.Size = UDim2.fromScale(1, 1)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = textValue
    textLabel.Font = Enum.Font.GothamBlack
    textLabel.TextColor3 = textColor
    textLabel.TextScaled = true
    textLabel.Parent = gui
end

local function createRig(unitId: string, shiny: boolean): (Model, {[string]: BasePart}, Folder)
    local mythic = unitId == "CapsuleCorp"
    local label = mythic and "CapsuleCorp_Mythic" or "Capsule_Legendary"
    if shiny then label ..= "_Shiny" end
    local model = Instance.new("Model")
    model.Name = label
    model:SetAttribute("UnitId", unitId)
    model:SetAttribute("Shiny", shiny)
    model:SetAttribute("Rarity", mythic and "Mythic" or "Legendary")
    model:SetAttribute("ObtainMethod", mythic and "EvolutionOnly" or "Summon")
    model:SetAttribute("CanAppearInBanner", not mythic)
    model:SetAttribute("BuilderVersion", Builder.Version)
    model:SetAttribute("R6", true)

    local torsoColor = mythic and (shiny and C.Olive or C.Green)
        or (shiny and C.Yellow or C.Pink)
    local legColor = mythic and (shiny and C.Gray or C.White)
        or (shiny and C.Yellow or C.Skin)
    local armColor = mythic and C.Skin or (shiny and C.Yellow or C.Skin)

    local root = corePart(model, "HumanoidRootPart", Vector3.new(2,2,1), Vector3.new(0,3,0), C.Dark)
    root.Transparency = 1
    root.Anchored = true -- Model de exposicao: fixo; e possivel animar as juntas R6.
    local torso = corePart(model, "Torso", Vector3.new(2,2,1), Vector3.new(0,3,0), torsoColor)
    local head = corePart(model, "Head", Vector3.new(2,1,1), Vector3.new(0,4.5,0), C.Skin)
    local leftArm = corePart(model, "Left Arm", Vector3.new(1,2,1), Vector3.new(-1.5,3,0), armColor)
    local rightArm = corePart(model, "Right Arm", Vector3.new(1,2,1), Vector3.new(1.5,3,0), armColor)
    local leftLeg = corePart(model, "Left Leg", Vector3.new(1,2,1), Vector3.new(-.5,1,0), legColor)
    local rightLeg = corePart(model, "Right Leg", Vector3.new(1,2,1), Vector3.new(.5,1,0), legColor)
    model.PrimaryPart = root

    motor("RootJoint", root, torso, CFrame.new(), CFrame.new())
    motor("Neck", torso, head, CFrame.new(0,1,0), CFrame.new(0,-.5,0))
    motor("Left Shoulder", torso, leftArm, CFrame.new(-1,.5,0), CFrame.new(.5,.5,0))
    motor("Right Shoulder", torso, rightArm, CFrame.new(1,.5,0), CFrame.new(-.5,.5,0))
    motor("Left Hip", torso, leftLeg, CFrame.new(-.5,-1,0), CFrame.new(0,1,0))
    motor("Right Hip", torso, rightLeg, CFrame.new(.5,-1,0), CFrame.new(0,1,0))

    local humanoid = Instance.new("Humanoid")
    humanoid.Name = "Humanoid"
    humanoid.RigType = Enum.HumanoidRigType.R6
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    humanoid.AutoRotate = false
    humanoid.BreakJointsOnDeath = false
    humanoid.Parent = model
    local animator = Instance.new("Animator")
    animator.Parent = humanoid

    local visuals = Instance.new("Folder")
    visuals.Name = "ModularAppearance"
    visuals.Parent = model
    faceOn(head)
    return model, {Root = root, Torso = torso, Head = head, LA = leftArm, RA = rightArm, LL = leftLeg, RL = rightLeg}, visuals
end

local function hair(rig: {[string]: BasePart}, folder: Folder, mythic: boolean, shiny: boolean)
    local head = rig.Head
    local hue = (mythic and shiny) and C.Ice or (shiny and C.Turquoise or C.Hair)
    accessory(folder, head, "HairCap", Vector3.new(2.11,.44,1.15), CFrame.new(0,.51,0), hue, nil, "Ball")
    for i = -2, 2 do
        local x = i * .34
        local fringe = accessory(folder, head, "HairBangs", Vector3.new(.39,.77,.35),
            CFrame.new(x,.24,-.54) * CFrame.Angles(0,0,math.rad(i*8)), hue, nil, "Wedge")
        fringe.CastShadow = false
    end
    if not mythic and not shiny then
        -- Lacinho grande e tranca descendo pelo lado esquerdo.
        for _, side in ipairs({-1,1}) do
            accessory(folder, head, "BowWing", Vector3.new(.82,.62,.25),
                CFrame.new(side*.38,.78,-.15) * CFrame.Angles(0,0,math.rad(side*23)), C.Red, nil, "Wedge")
        end
        accessory(folder, head, "BowKnot", Vector3.new(.35,.35,.34), CFrame.new(0,.83,-.18), C.Red, nil, "Ball")
        for i = 1,4 do
            accessory(folder, head, "BraidSegment", Vector3.new(.45,.48,.45),
                CFrame.new(-.85,-.08-(i-1)*.37,.16 + (i-1)*.07), hue, nil, "Ball")
        end
    elseif not mythic then
        accessory(folder, head, "RedHeadband", Vector3.new(2.12,.30,1.17),
            CFrame.new(0,.22,0), C.Red)
        accessory(folder, head, "BackHair", Vector3.new(2.1,1.1,.35),
            CFrame.new(0,-.17,.48), hue)
    else
        -- Mítica: cabelo curto de laboratorio; Shiny usa tom gelado.
        for _, side in ipairs({-1,1}) do
            accessory(folder, head, "ShortSideHair", Vector3.new(.35,.55,.8),
                CFrame.new(side*1.02,.12,.07), hue)
        end
    end
end

local function outfit(rig: {[string]: BasePart}, folder: Folder, mythic: boolean, shiny: boolean)
    local torso, head = rig.Torso, rig.Head
    if not mythic and not shiny then
        accessory(folder, torso, "PinkDressFront", Vector3.new(1.92,1.78,.20), CFrame.new(0,-.05,-.55), C.Pink)
        local chestPatch = accessory(folder, torso, "BulmaNameBadge", Vector3.new(1.1,.30,.12),
            CFrame.new(0,.07,-.72), C.White)
        insignia(chestPatch, "BULMA", C.Dark)
        for i = -2,2 do
            accessory(folder, torso, "SkirtPleat", Vector3.new(.42,.75,.9),
                CFrame.new(i*.4,-1.15,0), C.Pink, nil, "Wedge")
        end
        accessory(folder, torso, "PurpleScarf", Vector3.new(2.2,.46,1.27), CFrame.new(0,.88,0), C.Purple)
        accessory(folder, torso, "Belt", Vector3.new(2.2,.24,1.17), CFrame.new(0,-.75,0), C.Brown)
        accessory(folder, torso, "BeltBuckle", Vector3.new(.35,.32,.10), CFrame.new(0,-.74,-.63), C.Gold, Enum.Material.Metal)
        accessory(folder, torso, "BluePouch", Vector3.new(.56,.63,.28), CFrame.new(.70,-.89,-.65), C.Blue)
        for _, arm in ipairs({rig.LA,rig.RA}) do
            accessory(folder, arm, "PinkSleeve", Vector3.new(1.07,.68,1.08), CFrame.new(0,.66,0), C.Pink)
            accessory(folder, arm, "BrownGlove", Vector3.new(1.07,.72,1.10), CFrame.new(0,-.68,0), C.Brown)
        end
        for _, leg in ipairs({rig.LL,rig.RL}) do
            accessory(folder, leg, "PurpleLegWarmers", Vector3.new(1.08,.54,1.08), CFrame.new(0,-.20,0), C.Purple)
            accessory(folder, leg, "BlueShoes", Vector3.new(1.1,.65,1.38), CFrame.new(0,-.72,-.19), C.Blue)
            accessory(folder, leg, "ShoeTip", Vector3.new(1.1,.20,.55), CFrame.new(0,-.96,-.60), C.White)
        end
    elseif not mythic then
        -- Lendaria Shiny: casaco amarelo, gola, roupa azul e botas castanhas.
        accessory(folder, torso, "BlueInnerShirt", Vector3.new(1.19,1.78,.16), CFrame.new(0,-.04,-.55), C.Blue)
        for _, side in ipairs({-1,1}) do
            accessory(folder, torso, "YellowJacket", Vector3.new(.43,1.9,.18), CFrame.new(side*.74,-.05,-.55), C.Yellow)
            accessory(folder, torso, "JacketPocket", Vector3.new(.42,.32,.16), CFrame.new(side*.66,.12,-.72), C.Gold)
            accessory(folder, torso, "RaisedCollar", Vector3.new(.55,.54,.9), CFrame.new(side*.68,.86,-.05), C.Yellow)
        end
        local badge = accessory(folder, torso, "CapsuleCorpBadge", Vector3.new(.40,.40,.09),
            CFrame.new(.74,.39,-.71), C.White)
        insignia(badge, "C", C.Dark)
        accessory(folder, torso, "Belt", Vector3.new(2.25,.24,1.12), CFrame.new(0,-.78,0), C.Brown)
        accessory(folder, torso, "BeltBuckle", Vector3.new(.36,.30,.11), CFrame.new(0,-.75,-.61), C.Gold, Enum.Material.Metal)
        for _, arm in ipairs({rig.LA,rig.RA}) do
            accessory(folder, arm, "JacketSleeve", Vector3.new(1.08,1.28,1.09), CFrame.new(0,.27,0), C.Yellow)
            accessory(folder, arm, "BrownCuff", Vector3.new(1.09,.24,1.1), CFrame.new(0,-.57,0), C.Brown)
        end
        for _, leg in ipairs({rig.LL,rig.RL}) do
            accessory(folder, leg, "BrownBoot", Vector3.new(1.10,.94,1.27), CFrame.new(0,-.59,-.10), C.Brown)
        end
    elseif not shiny then
        -- Mitica normal: jaleco branco + gola verde, sem laço.
        accessory(folder, torso, "GreenSweater", Vector3.new(1.10,1.78,.16), CFrame.new(0,0,-.55), C.Green)
        for _, side in ipairs({-1,1}) do
            accessory(folder, torso, "LabCoatPanel", Vector3.new(.48,2.43,.22), CFrame.new(side*.72,-.22,-.58), C.White)
            accessory(folder, torso, "LabCoatTail", Vector3.new(.8,1.25,.18), CFrame.new(side*.63,-1.40,.36), C.White)
        end
        local badge = accessory(folder, torso, "CorpLabBadge", Vector3.new(.45,.44,.12),
            CFrame.new(.70,.28,-.76), C.White)
        insignia(badge, "C", C.Dark)
        accessory(folder, torso, "CoatCollar", Vector3.new(1.3,.28,1.2), CFrame.new(0,.93,0), C.White)
        for _, arm in ipairs({rig.LA,rig.RA}) do
            accessory(folder, arm, "LabSleeve", Vector3.new(1.09,1.61,1.1), CFrame.new(0,.15,0), C.White)
        end
        for _, leg in ipairs({rig.LL,rig.RL}) do
            accessory(folder, leg, "DarkBoots", Vector3.new(1.10,.67,1.27), CFrame.new(0,-.68,-.12), C.Dark)
        end
    else
        -- Mitica Shiny: blusa verde oliva, braceletes azuis e botas douradas.
        accessory(folder, torso, "OliveTop", Vector3.new(1.9,1.92,.14), CFrame.new(0,-.04,-.54), C.Olive)
        accessory(folder, torso, "HighCollar", Vector3.new(1.33,.28,1.14), CFrame.new(0,.91,0), C.Olive)
        accessory(folder, torso, "Belt", Vector3.new(2.17,.22,1.11), CFrame.new(0,-.83,0), C.Brown)
        accessory(folder, torso, "Buckle", Vector3.new(.33,.30,.11), CFrame.new(0,-.84,-.60), C.Gold, Enum.Material.Metal)
        for _, arm in ipairs({rig.LA,rig.RA}) do
            accessory(folder, arm, "BlueWristband", Vector3.new(1.10,.63,1.09), CFrame.new(0,-.57,0), C.Blue)
        end
        for _, leg in ipairs({rig.LL,rig.RL}) do
            accessory(folder, leg, "YellowBoots", Vector3.new(1.12,.64,1.25), CFrame.new(0,-.70,-.14), C.Yellow)
        end
        -- Halo com pecas soldadas: permanece no modelo mesmo durante o movimento.
        for i=1,16 do
            local a=math.pi*2*i/16
            local b=math.pi*2*(i+1)/16
            local x1,y1=math.cos(a)*1.38,math.sin(a)*.38
            local x2,y2=math.cos(b)*1.38,math.sin(b)*.38
            local len=math.sqrt((x2-x1)^2+(y2-y1)^2)
            accessory(folder, head, "ShinyHalo", Vector3.new(len,.09,.09),
                CFrame.new((x1+x2)/2, .12+(y1+y2)/2, .74)
                * CFrame.Angles(0,0,math.atan2(y2-y1,x2-x1)),
                C.Gold, Enum.Material.Neon)
        end
    end
    if mythic then
        for _, side in ipairs({-1,1}) do
            accessory(folder, head, "GoldEarring", Vector3.new(.15,.23,.15),
                CFrame.new(side*1.06,-.22,-.05), C.Gold, Enum.Material.Metal, "Ball")
        end
    end
end

function Builder.Build(unitId: string, shiny: boolean): Model?
    if (unitId ~= "Capsule" and unitId ~= "CapsuleCorp")
        or typeof(shiny) ~= "boolean" then return nil end
    local model, rig, visuals = createRig(unitId, shiny)
    local mythic = unitId == "CapsuleCorp"
    hair(rig, visuals, mythic, shiny)
    outfit(rig, visuals, mythic, shiny)
    return model
end

function Builder.BuildAll(parent: Instance): Folder
    local previous = parent:FindFirstChild("CapsuleUnitModels")
    if previous then previous:Destroy() end
    local folder = Instance.new("Folder")
    folder.Name = "CapsuleUnitModels"
    folder.Parent = parent
    for _, spec in ipairs({
        {id = "Capsule", shiny = false},
        {id = "Capsule", shiny = true},
        {id = "CapsuleCorp", shiny = false},
        {id = "CapsuleCorp", shiny = true},
    }) do
        local m = Builder.Build(spec.id, spec.shiny)
        assert(m ~= nil, "Falha ao criar Capsule " .. spec.id)
        m.Parent = folder
    end
    return folder
end

return Builder
