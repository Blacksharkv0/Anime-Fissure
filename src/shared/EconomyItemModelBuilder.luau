--!strict
-- ANIME FISSURE | EconomyItemModelBuilder v0.2
-- Geometry follows approved 4-item concept sheet: fractured azure/violet
-- gem with rings; engraved thick gold coin; cyan mechanical reroll core;
-- violet/gold rune mandala with orange heart.
-- Authored procedural geometry/materials; NOT imported textures or mesh assets.
-- Effects are client-side and separate in EconomyItemVFX.luau.
-- Static parts only, so models are safe for ViewportFrame and future UI icons.
local Visuals = require(script.Parent:WaitForChild("EconomyVisualConfig"))
local Builder = {}
Builder.Version = "0.2.0"

local function part(model: Model, name: string, size: Vector3, cf: CFrame,
    color: Color3, material: Enum.Material?, kind: string?, alpha: number?): BasePart
    local p: BasePart
    if kind == "Wedge" then
        p = Instance.new("WedgePart")
    else
        local a = Instance.new("Part")
        if kind == "Ball" then a.Shape = Enum.PartType.Ball end
        if kind == "Cylinder" then a.Shape = Enum.PartType.Cylinder end
        p = a
    end
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = material or Enum.Material.SmoothPlastic
    p.Transparency = alpha or 0
    p.Reflectance = if p.Material == Enum.Material.Metal then 0.17 else 0
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.Parent = model
    return p
end

local function segment(model: Model, name: string, a: Vector3, b: Vector3,
    thickness: number, color: Color3, material: Enum.Material?)
    local d = b-a
    if d.Magnitude < 0.01 then return end
    return part(model, name, Vector3.new(thickness, thickness, d.Magnitude),
        CFrame.lookAt((a+b)*0.5, b), color, material or Enum.Material.Metal)
end

local function ring(model: Model, prefix: string, sides: number, radius: number,
    z: number, color: Color3, thickness: number, phase: number?, material: Enum.Material?)
    local offset = phase or 0
    for i=1,sides do
        local a,b = 2*math.pi*(i-1)/sides+offset,2*math.pi*i/sides+offset
        segment(model, prefix .. i,
            Vector3.new(math.cos(a)*radius,math.sin(a)*radius,z),
            Vector3.new(math.cos(b)*radius,math.sin(b)*radius,z),
            thickness,color,material)
    end
end

local function disc(model: Model, name: string, radius: number, thick: number,
    z: number, color: Color3, material: Enum.Material?)
    -- Cylinder axis is X in Roblox; rotate Y 90 degrees so it faces camera.
    return part(model,name,Vector3.new(thick,radius*2,radius*2),
        CFrame.new(0,0,z)*CFrame.Angles(0,math.rad(90),0),
        color,material or Enum.Material.Metal,"Cylinder")
end

local function diamond(model: Model, prefix: string, at: Vector3,
    scale: Vector3, color: Color3, alpha: number?)
    -- Paired mirrored wedges form a layered faceted silhouette.
    local a=part(model,prefix.."Upper",scale,
        CFrame.new(at+Vector3.new(0,scale.Y*0.24,0))
          * CFrame.Angles(0,math.rad(180),math.rad(180)),
        color,Enum.Material.Glass,"Wedge",alpha)
    local b=part(model,prefix.."Lower",scale*Vector3.new(1,0.88,1),
        CFrame.new(at-Vector3.new(0,scale.Y*0.26,0)),
        color,Enum.Material.Glass,"Wedge",alpha)
    return a,b
end

local function addTextureLikeLines(model: Model, prefix: string, radius: number,
    z: number, color: Color3, count: number)
    -- Tiny engraved strokes emulate surface texture without uploaded decals.
    for i=1,count do
        local a=(i-1)*2*math.pi/count
        local r=radius
        local start=Vector3.new(math.cos(a)*r,math.sin(a)*r,z)
        local finish=Vector3.new(math.cos(a)*(r-0.16),math.sin(a)*(r-0.16),z)
        segment(model,prefix..i,start,finish,0.043,color)
    end
end

local function makeGems(model: Model, v: any)
    local cyan=Color3.fromRGB(47,191,255)
    local violet=Color3.fromRGB(163,80,255)
    local white=Color3.fromRGB(199,244,255)
    local metal=Color3.fromRGB(90,112,175)
    ring(model,"OuterClasp",12,1.57,0.50,metal,0.15,math.rad(15))
    ring(model,"InnerMagic",12,1.15,0.54,cyan,0.08,math.rad(15),Enum.Material.Neon)
    -- Two large, non-identical broken shards, with reflective face layers.
    diamond(model,"BlueCrystal",Vector3.new(-0.52,0.07,0),
        Vector3.new(0.98,2.30,0.83),cyan,0.09)
    diamond(model,"VioletCrystal",Vector3.new(0.58,-0.08,-0.08),
        Vector3.new(1.05,2.28,0.87),violet,0.10)
    part(model,"BlueFacet",Vector3.new(0.19,1.48,0.09),
        CFrame.new(-0.62,0.20,-0.52)*CFrame.Angles(0,0,math.rad(-24)),
        white,Enum.Material.Neon,nil,0.28)
    part(model,"PurpleFacet",Vector3.new(0.18,1.56,0.09),
        CFrame.new(0.62,-0.21,-0.56)*CFrame.Angles(0,0,math.rad(23)),
        Color3.fromRGB(247,180,255),Enum.Material.Neon,nil,0.28)
    -- Irregular jagged rift between shards, not a standard cut diamond.
    local points={
        Vector3.new(0.01,1.51,-0.67),Vector3.new(-0.16,0.73,-0.69),
        Vector3.new(0.15,0.37,-0.68),Vector3.new(-0.13,-0.25,-0.68),
        Vector3.new(0.11,-0.63,-0.68),Vector3.new(-0.02,-1.46,-0.65)}
    for i=1,#points-1 do
        segment(model,"FissureBolt"..i,points[i],points[i+1],
            0.15,white,Enum.Material.Neon)
    end
    for i,xyz in ipairs({
        Vector3.new(-1.56,0.91,-0.19),Vector3.new(1.51,-0.79,0.24),
        Vector3.new(0.30,1.80,0.02),Vector3.new(-1.35,-0.63,0.11),
    }) do
        diamond(model,"DetachedShard"..i,xyz,
            Vector3.new(0.30,0.51,0.32),
            if i%2==0 then cyan else violet,0.08)
    end
    for i=1,4 do
        local a=(i-1)*math.pi/2
        part(model,"MetalSocket"..i,Vector3.new(0.27,0.34,0.27),
            CFrame.new(math.cos(a)*1.58,math.sin(a)*1.58,0.35)
                *CFrame.Angles(0,0,a),
            metal,Enum.Material.Metal)
    end
end

local function makeGold(model: Model, v: any)
    local gold=Color3.fromRGB(255,203,80)
    local high=Color3.fromRGB(255,238,154)
    local bronze=Color3.fromRGB(146,82,25)
    disc(model,"MilledEdge",1.53,0.46,0,bronze)
    disc(model,"CoinFaceFront",1.39,0.095,-0.28,gold)
    disc(model,"CoinFaceBack",1.39,0.095,0.28,gold)
    ring(model,"RaisedBezel",24,1.36,-0.365,high,0.12)
    ring(model,"InnerEngravedRing",18,1.07,-0.373,bronze,0.075)
    addTextureLikeLines(model,"Milling",1.47,-0.33,high,24)
    -- Original stylised double fissure mark in a laurel-like frame.
    local rune={
        Vector3.new(-0.23,0.84,-0.41),Vector3.new(0.38,0.43,-0.41),
        Vector3.new(0.06,0.23,-0.41),Vector3.new(0.52,-0.05,-0.41),
        Vector3.new(-0.18,-0.72,-0.41)}
    for i=1,#rune-1 do
        segment(model,"CentralEmblem"..i,rune[i],rune[i+1],
            0.16,high,Enum.Material.Neon)
    end
    for side=-1,1,2 do
        for i=1,5 do
            local y=-0.71+i*0.30
            local x=side*(0.68+0.11*math.sin(i*0.6))
            segment(model,"Laurel"..side.."_"..i,
                Vector3.new(x,y,-0.40),
                Vector3.new(x-side*0.24,y+0.19,-0.40),
                0.095,high)
        end
    end
    -- Fine face scoring line denotes cast metal engraving.
    segment(model,"DiagonalScore",Vector3.new(-0.63,-0.98,-0.395),
        Vector3.new(0.37,-0.98,-0.395),0.04,bronze)
end

local function makeTrait(model: Model, v: any)
    local steel=Color3.fromRGB(77,103,141)
    local ice=Color3.fromRGB(74,234,255)
    local dark=Color3.fromRGB(24,40,63)
    ring(model,"ArmorHex",6,1.54,0.13,steel,0.35,math.rad(30))
    ring(model,"InnerGear",12,1.14,-0.12,
        Color3.fromRGB(43,136,201),0.15,0,Enum.Material.Neon)
    disc(model,"MechanicShadow",1.00,0.25,0.24,dark)
    disc(model,"ArcaneCoil",0.79,0.17,-0.13,
        Color3.fromRGB(22,101,136))
    ring(model,"CoreRecess",12,0.64,-0.43,ice,0.13,0,Enum.Material.Neon)
    part(model,"EnergyRewriter",Vector3.new(0.80,0.83,0.56),
        CFrame.new(0,0,-0.55),ice,Enum.Material.Glass,"Ball",0.07)
    for i=1,3 do
        local a=(i-1)*2*math.pi/3-math.pi/2
        local center=Vector3.new(math.cos(a)*1.36,math.sin(a)*1.36,-0.23)
        part(model,"ManipulatorArm"..i,Vector3.new(0.35,0.70,0.34),
            CFrame.new(center)*CFrame.Angles(0,0,a+math.pi/2),
            steel,Enum.Material.Metal)
        local inner=Vector3.new(math.cos(a)*0.43,math.sin(a)*0.43,-0.70)
        segment(model,"EnergySpoke"..i,center,inner,0.14,ice,Enum.Material.Neon)
        part(model,"GlowNode"..i,Vector3.new(0.26,0.33,0.20),
            CFrame.new(center+Vector3.new(0,0,-0.27)),
            ice,Enum.Material.Neon)
    end
    for i=1,6 do
        local a=(i-1)*math.pi/3
        part(model,"ArmorTooth"..i,Vector3.new(0.37,0.29,0.31),
            CFrame.new(math.cos(a)*1.72,math.sin(a)*1.72,0.17)
                *CFrame.Angles(0,0,a),
            steel,Enum.Material.Metal)
    end
end

local function makeRelic(model: Model, v: any)
    local violet=Color3.fromRGB(171,67,246)
    local lilac=Color3.fromRGB(232,155,255)
    local gold=Color3.fromRGB(250,187,101)
    local warm=Color3.fromRGB(255,118,77)
    ring(model,"OctagonalRuneArmor",8,1.58,0.09,
        Color3.fromRGB(113,65,156),0.30,math.rad(22.5))
    ring(model,"GoldenInlay",8,1.40,-0.09,gold,0.10,math.rad(22.5))
    ring(model,"RitualRuneWheel",12,1.08,-0.27,violet,0.16,
        math.rad(15),Enum.Material.Neon)
    ring(model,"InnerResonance",12,0.78,-0.45,lilac,0.07,
        math.rad(15),Enum.Material.Neon)
    for i=1,8 do
        local a=(i-1)*math.pi/4+math.pi/8
        local p=Vector3.new(math.cos(a),math.sin(a),0)
        local tang=Vector3.new(-p.Y,p.X,0)
        local c=p*1.24+Vector3.new(0,0,-0.39)
        segment(model,"AncientGlyphAxis"..i,
            c-tang*0.14,c+tang*0.13,0.082,lilac,Enum.Material.Neon)
        segment(model,"AncientGlyphTail"..i,
            c-p*0.12,c+p*0.16+tang*0.08,
            0.078,lilac,Enum.Material.Neon)
    end
    for i=1,4 do
        local a=(i-1)*math.pi/2
        local u=Vector3.new(math.cos(a),math.sin(a),0)
        local pos=u*1.67
        diamond(model,"RitualCompass"..i,pos,
            Vector3.new(0.38,0.67,0.33),
            if i%2==0 then lilac else gold,0.03)
    end
    -- Purple suspended heart and vivid orange lower facet.
    diamond(model,"SuspendedVioletCore",Vector3.new(0,0.06,-0.54),
        Vector3.new(0.80,1.18,0.76),violet,0.10)
    diamond(model,"SunsetInnerHeart",Vector3.new(0,-0.22,-0.99),
        Vector3.new(0.43,0.68,0.35),warm,0.08)
    part(model,"HeartGlimmer",Vector3.new(0.13,0.62,0.10),
        CFrame.new(-0.12,0.25,-1.24)*CFrame.Angles(0,0,math.rad(-20)),
        Color3.fromRGB(255,219,160),Enum.Material.Neon,nil,0.20)
end

local designs={
    FissureGems=makeGems,
    Gold=makeGold,
    TraitRerollCore=makeTrait,
    RelicTraitSeal=makeRelic,
}

function Builder.Build(id: string): Model?
    local visual=Visuals.Get(id)
    local build=designs[id]
    if not visual or not build then return nil end
    local model=Instance.new("Model")
    model.Name=id
    model:SetAttribute("EconomyVisualId",id)
    model:SetAttribute("DisplayName",visual.Name)
    model:SetAttribute("VisualOnly",true)
    model:SetAttribute("Version",Builder.Version)
    model:SetAttribute("HasAuthoredSurfaceDetail",true)
    local root=part(model,"Root",Vector3.new(0.10,0.10,0.10),
        CFrame.identity,visual.Accent)
    root.Transparency=1
    model.PrimaryPart=root
    build(model,visual)
    return model
end

function Builder.BuildAll(parent: Instance): Folder
    local prior=parent:FindFirstChild("EconomyPreviewModels")
    if prior then prior:Destroy() end
    local folder=Instance.new("Folder")
    folder.Name="EconomyPreviewModels"
    folder:SetAttribute("VisualOnly",true)
    folder:SetAttribute("Version",Builder.Version)
    for _,item in ipairs(Visuals.GetAll()) do
        local built=Builder.Build(item.Id)
        assert(built,"Missing economy model: "..item.Id)
        built.Parent=folder
    end
    folder.Parent=parent
    return folder
end
return Builder
