--!strict
-- ANIME FISSURE | FissureNPCBuilder v0.2
-- Virgil e Edward: personagens R6 estilizados feitos de pecas nativas,
-- com Motor6D e acessorios soldados. Nao depende de asset externo.
-- NPCs decorativos e interativos via prompts dos stands EXISTENTES.
local Builder = {}
Builder.Version = "0.3.0"

local C = {
    Skin = Color3.fromRGB(245, 199, 164),
    Shadow = Color3.fromRGB(24, 29, 46),
    Navy = Color3.fromRGB(34, 49, 105),
    Royal = Color3.fromRGB(52, 78, 150),
    Silver = Color3.fromRGB(222, 233, 249),
    Steel = Color3.fromRGB(134, 158, 192),
    Gold = Color3.fromRGB(246, 204, 108),
    Cyan = Color3.fromRGB(82, 224, 255),
    Purple = Color3.fromRGB(142, 79, 245),
    Red = Color3.fromRGB(207, 39, 58),
    RedDark = Color3.fromRGB(120, 29, 46),
    Black = Color3.fromRGB(29, 32, 45),
    Blonde = Color3.fromRGB(242, 205, 84),
    Brown = Color3.fromRGB(83, 61, 47),
    Eye = Color3.fromRGB(58, 138, 212),
}

local function part(parent: Instance, name: string, size: Vector3, cf: CFrame,
    color: Color3, material: Enum.Material?, shape: string?): BasePart
    local p: BasePart
    if shape == "Wedge" then
        p = Instance.new("WedgePart")
    else
        local q = Instance.new("Part")
        if shape == "Ball" then q.Shape = Enum.PartType.Ball end
        if shape == "Cylinder" then q.Shape = Enum.PartType.Cylinder end
        p = q
    end
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Anchored = false
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = parent
    return p
end

local function motor(parent: BasePart, target: BasePart, name: string, c0: CFrame, c1: CFrame)
    local m = Instance.new("Motor6D")
    m.Name = name
    m.Part0 = parent
    m.Part1 = target
    m.C0 = c0
    m.C1 = c1
    m.Parent = parent
    return m
end

local function attach(folder: Folder, limb: BasePart, name: string, sz: Vector3,
    rel: CFrame, color: Color3, material: Enum.Material?, shape: string?): BasePart
    local p = part(folder, name, sz, limb.CFrame * rel, color, material, shape)
    p.Massless = true
    local weld = Instance.new("WeldConstraint")
    weld.Name = "DetailWeld"
    weld.Part0 = limb
    weld.Part1 = p
    weld.Parent = p
    return p
end

local function addFace(head: BasePart, eyeColor: Color3)
    local s = Instance.new("SurfaceGui")
    s.Name = "AnimeFace"
    s.Face = Enum.NormalId.Front
    s.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
    s.PixelsPerStud = 100
    s.LightInfluence = 0
    s.Parent = head
    local canvas = Instance.new("Frame")
    canvas.Size = UDim2.fromScale(1, 1)
    canvas.BackgroundTransparency = 1
    canvas.Parent = s
    for _, x in ipairs({0.24, 0.63}) do
        local brow = Instance.new("Frame")
        brow.Position = UDim2.fromScale(x, 0.25)
        brow.Size = UDim2.fromScale(0.14, 0.037)
        brow.BackgroundColor3 = C.Shadow
        brow.BorderSizePixel = 0
        brow.Rotation = if x < 0.5 then -12 else 12
        brow.Parent = canvas
        local eye = Instance.new("Frame")
        eye.Position = UDim2.fromScale(x, 0.39)
        eye.Size = UDim2.fromScale(0.15, 0.23)
        eye.BackgroundColor3 = Color3.fromRGB(250, 252, 255)
        eye.BorderSizePixel = 0
        eye.Parent = canvas
        local round = Instance.new("UICorner")
        round.CornerRadius = UDim.new(0.4, 0)
        round.Parent = eye
        local iris = Instance.new("Frame")
        iris.Position = UDim2.fromScale(0.33, 0.20)
        iris.Size = UDim2.fromScale(0.48, 0.73)
        iris.BackgroundColor3 = eyeColor
        iris.BorderSizePixel = 0
        iris.Parent = eye
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = iris
    end
    local smile = Instance.new("TextLabel")
    smile.BackgroundTransparency = 1
    smile.Position = UDim2.fromScale(0.42, 0.70)
    smile.Size = UDim2.fromScale(0.20, 0.16)
    smile.Text = "⌣"
    smile.TextColor3 = C.Shadow
    smile.TextScaled = true
    smile.Font = Enum.Font.GothamBold
    smile.Parent = canvas
end

local function nameplate(head: BasePart, name: string, role: string, accent: Color3)
    local gui = Instance.new("BillboardGui")
    gui.Name = "NPCNameplate"
    gui.Size = UDim2.fromOffset(185, 45)
    gui.StudsOffset = Vector3.new(0, 2.15, 0)
    gui.MaxDistance = 28
    gui.AlwaysOnTop = true
    gui.Parent = head
    local panel = Instance.new("Frame")
    panel.Size = UDim2.fromScale(1, 1)
    panel.BackgroundColor3 = C.Shadow
    panel.BackgroundTransparency = 0.22
    panel.BorderSizePixel = 0
    panel.Parent = gui
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = panel
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0.55, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBlack
    label.TextColor3 = Color3.fromRGB(246, 249, 255)
    label.TextScaled = true
    label.Parent = panel
    local sub = Instance.new("TextLabel")
    sub.Position = UDim2.fromScale(0, 0.55)
    sub.Size = UDim2.fromScale(1, 0.35)
    sub.BackgroundTransparency = 1
    sub.Text = role
    sub.Font = Enum.Font.GothamBold
    sub.TextColor3 = accent
    sub.TextScaled = true
    sub.Parent = panel
end

local function rig(kind: string)
    local model = Instance.new("Model")
    model.Name = if kind == "Virgil" then "VirgilNPC" else "AlchemistNPC"
    model:SetAttribute("NPCId", kind)
    model:SetAttribute("BuilderVersion", Builder.Version)
    model:SetAttribute("R6", true)
    local metal = kind == "Virgil"
    local torsoColor = if metal then C.Navy else C.Black
    local root = part(model, "HumanoidRootPart", Vector3.new(2, 2, 1), CFrame.new(0, 3, 0), C.Shadow)
    root.Anchored = true
    root.Transparency = 1
    local torso = part(model, "Torso", Vector3.new(2, 2, 1), CFrame.new(0, 3, 0), torsoColor)
    local head = part(model, "Head", Vector3.new(2, 1, 1), CFrame.new(0, 4.5, 0), C.Skin)
    local la = part(model, "Left Arm", Vector3.new(1, 2, 1), CFrame.new(-1.5, 3, 0), if metal then C.Navy else C.Red)
    local ra = part(model, "Right Arm", Vector3.new(1, 2, 1), CFrame.new(1.5, 3, 0), if metal then C.Navy else C.Steel)
    local ll = part(model, "Left Leg", Vector3.new(1, 2, 1), CFrame.new(-0.5, 1, 0), C.Black)
    local rl = part(model, "Right Leg", Vector3.new(1, 2, 1), CFrame.new(0.5, 1, 0), C.Black)
    model.PrimaryPart = root
    motor(root, torso, "RootJoint", CFrame.new(), CFrame.new())
    motor(torso, head, "Neck", CFrame.new(0, 1, 0), CFrame.new(0, -0.5, 0))
    motor(torso, la, "Left Shoulder", CFrame.new(-1, 0.5, 0), CFrame.new(0.5, 0.5, 0))
    motor(torso, ra, "Right Shoulder", CFrame.new(1, 0.5, 0), CFrame.new(-0.5, 0.5, 0))
    motor(torso, ll, "Left Hip", CFrame.new(-0.5, -1, 0), CFrame.new(0, 1, 0))
    motor(torso, rl, "Right Hip", CFrame.new(0.5, -1, 0), CFrame.new(0, 1, 0))
    local h = Instance.new("Humanoid")
    h.RigType = Enum.HumanoidRigType.R6
    h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    h.AutoRotate = false
    h.BreakJointsOnDeath = false
    h.Parent = model
    local animator = Instance.new("Animator")
    animator.Parent = h
    local details = Instance.new("Folder")
    details.Name = "ModularAppearance"
    details.Parent = model
    addFace(head, if metal then C.Purple else C.Gold)
    nameplate(head, kind, if metal then "INVOCADOR" else "ALQUIMISTA", if metal then C.Purple else C.Gold)
    return model, details, {root = root, torso = torso, head = head, la = la, ra = ra, ll = ll, rl = rl}
end

-- Character Reborn: Vergil v1.0. Every visual piece is welded to the
-- existing rig, keeping the Head prompt and the server's summon flow intact.
local function virgil(details: Folder, r: {[string]: BasePart})
    local t,h=r.torso,r.head
    local navy=Color3.fromRGB(17,29,57)
    local blue=Color3.fromRGB(38,69,122)
    local lapel=Color3.fromRGB(58,96,151)
    local lining=Color3.fromRGB(13,21,42)
    local ice=Color3.fromRGB(223,237,250)
    local hairShade=Color3.fromRGB(142,165,190)
    local leather=Color3.fromRGB(19,23,32)
    local steel=Color3.fromRGB(166,184,204)
    local skin=Color3.fromRGB(238,211,190)
    local function piece(limb: BasePart,name: string,s: Vector3,pos: Vector3,
        col: Color3,rx: number?,ry: number?,rz: number?,shape: string?,mat: Enum.Material?)
        return attach(details,limb,"Reborn_"..name,s,
            CFrame.new(pos)*CFrame.Angles(math.rad(rx or 0),math.rad(ry or 0),math.rad(rz or 0)),
            col,mat,shape)
    end
    -- Keep the original Motor6D and anchor, refine only the visible proportions.
    h.Size=Vector3.new(1.46,1.22,1.10)
    h.Color=skin
    local headMesh=Instance.new("SpecialMesh")
    headMesh.Name="Reborn_RoundedHead"
    headMesh.MeshType=Enum.MeshType.Head
    headMesh.Scale=Vector3.new(1,1,1)
    headMesh.Parent=h
    t.Color=lining
    for _,arm in ipairs({r.la,r.ra}) do arm.Transparency=1 end
    for _,leg in ipairs({r.ll,r.rl}) do leg.Transparency=1 end
    -- Custom face, sharp brows and narrow eyes instead of a default smile.
    local oldFace=h:FindFirstChild("AnimeFace")
    if oldFace then oldFace:Destroy() end
    local face=Instance.new("SurfaceGui")
    face.Name="AnimeFace";face.Face=Enum.NormalId.Front
    face.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
    face.PixelsPerStud=160;face.LightInfluence=.12;face.Parent=h
    local canvas=Instance.new("Frame")
    canvas.Size=UDim2.fromScale(1,1);canvas.BackgroundTransparency=1;canvas.Parent=face
    local function mark(name: string,x: number,y: number,w: number,ht: number,col: Color3,rot: number?,round: boolean?): Frame
        local f=Instance.new("Frame")
        f.Name=name;f.Position=UDim2.fromScale(x,y);f.Size=UDim2.fromScale(w,ht)
        f.BackgroundColor3=col;f.BorderSizePixel=0;f.Rotation=rot or 0;f.Parent=canvas
        if round then
            local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(.3,0);corner.Parent=f
        end
        return f
    end
    for _,side in ipairs({-1,1}) do
        local x=if side==-1 then .20 else .57
        local browRot=if side==-1 then 11 else -11
        mark("EyeOutline_"..side,x,.385,.23,.125,lining,browRot,true)
        mark("EyeWhite_"..side,x+.018,.405,.194,.081,ice,browRot,true)
        mark("Iris_"..side,x+.085,.398,.058,.095,Color3.fromRGB(79,145,193),0,true)
        mark("Pupil_"..side,x+.105,.408,.022,.064,lining,0,true)
        mark("Catchlight_"..side,x+.09,.407,.018,.019,ice,0,true)
        mark("Brow_"..side,x-.006,.305,.24,.044,hairShade,browRot,true)
    end
    mark("NoseShadow",.49,.51,.034,.14,Color3.fromRGB(200,162,147),-8,true)
    mark("Mouth",.425,.735,.15,.022,Color3.fromRGB(115,79,78),-3,true)
    -- Layered swept-back hair. The upper strands and side locks form a
    -- recognizable silhouette; separate shades provide depth without textures.
    piece(h,"HairUnderlayer",Vector3.new(1.57,.66,1.19),Vector3.new(0,.43,.13),hairShade,0,0,0,"Ball")
    piece(h,"HairCrown",Vector3.new(1.57,.61,1.12),Vector3.new(0,.60,.04),ice,-12,0,0,"Ball")
    for i=-3,3 do
        local x=i*.195
        piece(h,"SweptLock_"..i,Vector3.new(.33,.83,.65),
            Vector3.new(x,.67+(.12-math.abs(i)*.027),-.12),ice,-34,0,-i*7,"Wedge")
        piece(h,"BackLock_"..i,Vector3.new(.28,.80,.68),
            Vector3.new(x,.35,.38),hairShade,36,0,-i*5,"Wedge")
        piece(h,"HairRidge_"..i,Vector3.new(.13,.65,.28),
            Vector3.new(x,.81,.05),Color3.fromRGB(246,249,255),-31,0,-i*7,"Wedge")
    end
    for _,side in ipairs({-1,1}) do
        piece(h,"TempleLock_"..side,Vector3.new(.24,.56,.48),Vector3.new(side*.68,.15,.09),ice,10,0,-side*9,"Wedge")
        piece(h,"Ear_"..side,Vector3.new(.17,.32,.26),Vector3.new(side*.73,-.08,.02),skin,0,0,0,"Ball")
    end
    -- Long fitted coat with lapels, seam piping, split tails and side panels.
    piece(t,"ChestShell",Vector3.new(1.72,1.76,1.12),Vector3.new(0,.06,0),navy,0,0,0,nil,Enum.Material.Fabric)
    piece(t,"VestFront",Vector3.new(.76,1.65,.14),Vector3.new(0,.02,-.61),leather,0,0,0,nil,Enum.Material.Fabric)
    piece(t,"CollarBack",Vector3.new(1.32,.47,.20),Vector3.new(0,1.02,.40),navy,-12,0,0,nil,Enum.Material.Fabric)
    for _,side in ipairs({-1,1}) do
        piece(t,"CoatChest_"..side,Vector3.new(.56,1.79,.21),Vector3.new(side*.67,.04,-.55),blue,0,side*10,side*4,nil,Enum.Material.Fabric)
        piece(t,"HighCollar_"..side,Vector3.new(.37,.61,.53),Vector3.new(side*.57,.94,-.18),lapel,0,side*14,side*-13,"Wedge",Enum.Material.Fabric)
        piece(t,"Lapel_"..side,Vector3.new(.31,1.15,.19),Vector3.new(side*.39,.34,-.69),lapel,0,0,side*13,nil,Enum.Material.Fabric)
        piece(t,"LapelPiping_"..side,Vector3.new(.055,1.24,.065),Vector3.new(side*.27,.31,-.79),steel,0,0,side*13,nil,Enum.Material.Metal)
        piece(t,"SideCoat_"..side,Vector3.new(.20,2.15,.98),Vector3.new(side*.91,-.94,.01),navy,0,0,-side*4,nil,Enum.Material.Fabric)
        piece(t,"TailOuter_"..side,Vector3.new(.83,2.50,.23),Vector3.new(side*.56,-1.72,.52),blue,-8,0,side*7,nil,Enum.Material.Fabric)
        piece(t,"TailLining_"..side,Vector3.new(.73,2.36,.10),Vector3.new(side*.56,-1.72,.40),lining,-8,0,side*7,nil,Enum.Material.Fabric)
        piece(t,"TailSeam_"..side,Vector3.new(.05,2.46,.07),Vector3.new(side*.83,-1.72,.67),steel,-8,0,side*7,nil,Enum.Material.Metal)
        piece(t,"TailPoint_"..side,Vector3.new(.78,.48,.22),Vector3.new(side*.70,-3.02,.70),navy,-8,0,side*7,"Wedge",Enum.Material.Fabric)
        for i=1,3 do
            piece(t,"CoatClasp_"..side.."_"..i,Vector3.new(.11,.11,.10),Vector3.new(side*.55,.40-i*.28,-.72),steel,0,0,0,"Ball",Enum.Material.Metal)
        end
    end
    piece(t,"Belt",Vector3.new(1.76,.19,1.16),Vector3.new(0,-.79,0),leather,0,0,0,nil,Enum.Material.Leather)
    piece(t,"Buckle",Vector3.new(.35,.25,.13),Vector3.new(0,-.79,-.65),steel,0,0,0,nil,Enum.Material.Metal)
    piece(t,"BuckleInset",Vector3.new(.22,.13,.06),Vector3.new(0,-.79,-.735),lining)
    for i,arm in ipairs({r.la,r.ra}) do
        local side=if i==1 then -1 else 1
        piece(arm,"SleeveUpper_"..i,Vector3.new(.78,1.07,.86),Vector3.new(-side*.09,.43,0),blue,0,0,side*4,"Ball",Enum.Material.Fabric)
        piece(arm,"SleeveForearm_"..i,Vector3.new(.69,.89,.79),Vector3.new(-side*.10,-.28,0),navy,0,0,side*-5,"Ball",Enum.Material.Fabric)
        piece(arm,"Cuff_"..i,Vector3.new(.76,.17,.83),Vector3.new(-side*.10,-.57,0),steel,0,0,0,nil,Enum.Material.Metal)
        piece(arm,"Glove_"..i,Vector3.new(.62,.48,.68),Vector3.new(-side*.10,-.80,0),leather,0,0,0,"Ball",Enum.Material.Leather)
        for j=1,3 do
            piece(arm,"GloveStitch_"..i.."_"..j,Vector3.new(.055,.18,.045),Vector3.new(-side*.10+(j-2)*.12,-.80,-.33),steel)
        end
    end
    for i,leg in ipairs({r.ll,r.rl}) do
        piece(leg,"Trouser_"..i,Vector3.new(.85,1.56,.90),Vector3.new(0,.23,0),lining,0,0,0,"Ball",Enum.Material.Fabric)
        piece(leg,"BootShaft_"..i,Vector3.new(.87,1.01,.94),Vector3.new(0,-.40,0),leather,0,0,0,"Ball",Enum.Material.Leather)
        piece(leg,"BootToe_"..i,Vector3.new(.90,.42,1.28),Vector3.new(0,-.78,-.19),leather,0,0,0,"Ball",Enum.Material.Leather)
        piece(leg,"BootSole_"..i,Vector3.new(.88,.13,1.18),Vector3.new(0,-.94,-.15),lining)
        piece(leg,"BootBand_"..i,Vector3.new(.91,.12,.99),Vector3.new(0,-.12,0),steel,0,0,0,nil,Enum.Material.Metal)
    end
    -- Yamato-inspired sheathed blade: coherent single axis, guard, wrapped
    -- handle, sheath bands and end cap. Pure cosmetic, never a Tool.
    local axis=CFrame.new(.35,-.20,.83)*CFrame.Angles(0,0,math.rad(-32))
    local function blade(name: string,size: Vector3,y: number,color: Color3,mat: Enum.Material?)
        return attach(details,t,"Reborn_"..name,size,axis*CFrame.new(0,y,0),color,mat)
    end
    blade("Scabbard",Vector3.new(.23,3.28,.29),-.42,leather,Enum.Material.Metal)
    blade("ScabbardEnd",Vector3.new(.28,.21,.34),-2.10,steel,Enum.Material.Metal)
    blade("ScabbardMouth",Vector3.new(.31,.22,.36),1.23,steel,Enum.Material.Metal)
    blade("SwordGuard",Vector3.new(.76,.13,.48),1.44,C.Gold,Enum.Material.Metal)
    blade("SwordHandle",Vector3.new(.27,.90,.28),1.94,ice,Enum.Material.Fabric)
    for i=1,5 do
        attach(details,t,"Reborn_HandleWrap_"..i,Vector3.new(.31,.075,.31),
            axis*CFrame.new(0,1.51+i*.14,0)*CFrame.Angles(0,0,math.rad(18)),lining,Enum.Material.Fabric)
    end
    blade("SwordPommel",Vector3.new(.33,.15,.33),2.44,steel,Enum.Material.Metal)
    -- Blue Fissure signature, restrained so the coat retains its silhouette.
    local sigil=piece(t,"FissureSigil",Vector3.new(.21,.21,.08),Vector3.new(.52,.55,-.75),C.Cyan,0,0,45,nil,Enum.Material.Neon)
    local light=Instance.new("PointLight")
    light.Color=C.Cyan;light.Range=5;light.Brightness=.22;light.Parent=sigil
    local plate=h:FindFirstChild("NPCNameplate")
    if plate then
        for _,v in ipairs(plate:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text=="Virgil" then v.Text="VERGIL" end
        end
    end
    local model=t.Parent
    if model then model:SetAttribute("CharacterReborn","Vergil-v1") end
end

local function edward(details: Folder, r: {[string]: BasePart})
    local t, h = r.torso, r.head
    attach(details, h, "GoldenHair", Vector3.new(2.10, 0.43, 1.15),
        CFrame.new(0, 0.52, 0), C.Blonde, nil, "Ball")
    for i = -2, 2 do
        attach(details, h, "GoldenBangs", Vector3.new(0.40, 0.77, 0.40),
            CFrame.new(i * 0.34, 0.24, -0.54) * CFrame.Angles(0, 0, math.rad(8 + i * 11)),
            C.Blonde, nil, "Wedge")
    end
    for i = 1, 5 do
        attach(details, h, "BlondeBraid", Vector3.new(0.42, 0.45, 0.42),
            CFrame.new(0.68, 0.05 - i * 0.32, 0.55), C.Blonde, nil, "Ball")
    end
    attach(details, t, "WhiteCollar", Vector3.new(1.54, 0.38, 1.10),
        CFrame.new(0, 0.85, 0), C.Silver)
    attach(details, t, "BlackUnderShirt", Vector3.new(1.20, 1.7, 0.15),
        CFrame.new(0, -0.05, -0.58), C.Black)
    for _, side in ipairs({-1, 1}) do
        attach(details, t, "RedCoatFront", Vector3.new(0.46, 2.3, 0.20),
            CFrame.new(side * 0.76, -0.40, -0.59), C.Red)
        attach(details, t, "RedCoatTail", Vector3.new(0.90, 2.35, 0.20),
            CFrame.new(side * 0.55, -1.70, 0.48), C.RedDark)
        attach(details, t, "SilverTrim", Vector3.new(0.08, 1.8, 0.10),
            CFrame.new(side * 0.48, -0.20, -0.74), C.Silver)
    end
    attach(details, r.la, "RedSleeve", Vector3.new(1.08, 1.60, 1.09),
        CFrame.new(0, 0.17, 0), C.Red)
    attach(details, r.la, "BlackGlove", Vector3.new(1.11, 0.60, 1.12),
        CFrame.new(0, -0.73, 0), C.Black)
    -- Braco mecanico (lado direito): metal com juntas e detalhes azuis.
    attach(details, r.ra, "AutomailArmor", Vector3.new(1.12, 1.9, 1.10),
        CFrame.new(0, 0, 0), C.Steel, Enum.Material.Metal)
    for _, y in ipairs({0.43, -0.10, -0.59}) do
        attach(details, r.ra, "AutomailJoint", Vector3.new(1.16, 0.15, 1.15),
            CFrame.new(0, y, 0), C.Silver, Enum.Material.Metal)
    end
    attach(details, r.ra, "AutomailGem", Vector3.new(0.26, 0.26, 0.12),
        CFrame.new(0, 0.2, -0.57), C.Cyan, Enum.Material.Neon)
    attach(details, t, "BrownBelt", Vector3.new(2.12, 0.24, 1.14),
        CFrame.new(0, -0.83, 0), C.Brown)
    for _, leg in ipairs({r.ll, r.rl}) do
        attach(details, leg, "BrownBoot", Vector3.new(1.1, 0.83, 1.27),
            CFrame.new(0, -0.60, -0.10), C.Brown)
    end
    local alchemy = attach(details, t, "AlchemyInsignia", Vector3.new(0.42, 0.42, 0.12),
        CFrame.new(0.67, 0.39, -0.70) * CFrame.Angles(0, 0, math.rad(45)), C.Gold, Enum.Material.Neon)
    local light = Instance.new("PointLight")
    light.Color = C.Gold
    light.Range = 7
    light.Brightness = 0.30
    light.Parent = alchemy
end

function Builder.Build(kind: string): Model?
    if kind ~= "Virgil" and kind ~= "Edward" then return nil end
    local model, details, body = rig(kind)
    if kind == "Virgil" then virgil(details, body) else edward(details, body) end
    return model
end

return Builder
