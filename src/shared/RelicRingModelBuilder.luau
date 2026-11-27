--!strict
-- ANIME FISSURE | Five Overlord evolution/relic ring models v1.0
-- Procedural Roblox Parts, low-poly ornaments, no external MeshId/TextureId.
-- Concept: purple magical runes / red steel blades / cyan clock /
-- emerald compass / chained red-purple double-core restriction.
-- Visual-only, anchored, no collision or game-stat side effects.
local Rings=require(script.Parent:WaitForChild("RelicRingConfig"))
local Builder={}
Builder.Version="1.0.0"

local function part(model: Model,name: string,size: Vector3,cf: CFrame,
    color: Color3,material: Enum.Material?,kind: string?,transparency: number?)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=cf
    if kind=="Ball" then p.Shape=Enum.PartType.Ball end
    if kind=="Cylinder" then p.Shape=Enum.PartType.Cylinder end
    p.Color=color
    p.Material=material or Enum.Material.Metal
    p.Transparency=transparency or 0
    p.Reflectance=if p.Material==Enum.Material.Metal then 0.18 else 0
    p.Anchored=true
    p.CanCollide=false
    p.CanQuery=false
    p.CanTouch=false
    p.CastShadow=false
    p.Parent=model
    return p
end

local function bar(model: Model,name: string,a: Vector3,b: Vector3,
    width: number,color: Color3,material: Enum.Material?)
    local d=b-a
    if d.Magnitude<0.01 then return end
    return part(model,name,Vector3.new(width,width,d.Magnitude),
        CFrame.lookAt((a+b)*0.5,b),color,material)
end

local function hoop(model: Model,name: string,radius: number,z: number,
    color: Color3,width: number,sides: number,phase: number?,
    material: Enum.Material?)
    for i=1,sides do
        local a=2*math.pi*(i-1)/sides+(phase or 0)
        local b=2*math.pi*i/sides+(phase or 0)
        bar(model,name..i,Vector3.new(math.cos(a)*radius,math.sin(a)*radius,z),
            Vector3.new(math.cos(b)*radius,math.sin(b)*radius,z),width,color,material)
    end
end

local function star(model: Model,name: string,radius: number,z: number,
    color: Color3,points: number)
    for i=1,points do
        local a=2*math.pi*i/points
        local p=Vector3.new(math.cos(a)*radius,math.sin(a)*radius,z)
        bar(model,name..i,Vector3.new(0,0,z),p,0.07,color,Enum.Material.Neon)
    end
end

local function gem(model: Model,name: string,pos: Vector3,size: Vector3,
    tint: Color3)
    part(model,name.."Glass",size,CFrame.new(pos),tint,Enum.Material.Glass,"Ball",0.07)
    part(model,name.."Core",size*0.63,CFrame.new(pos+Vector3.new(0,0,-0.11)),
        tint,Enum.Material.Neon,"Ball",0.12)
    part(model,name.."Highlight",Vector3.new(0.17,0.25,0.09),
        CFrame.new(pos+Vector3.new(-0.22,0.24,-size.Z/2-0.05)),
        Color3.fromRGB(253,248,255),Enum.Material.Neon,"Ball",0.12)
end

local function chain(model: Model,name: string,
    start: Vector3,finish: Vector3,color: Color3,links: number)
    for i=1,links do
        local t=(i-0.5)/links
        local xyz=start:Lerp(finish,t)
        local dr=(finish-start).Unit
        part(model,name..i,Vector3.new(0.18,0.25,0.40),
            CFrame.lookAt(xyz,xyz+dr)*CFrame.Angles(0,0,math.rad(i*33)),
            color,Enum.Material.Metal,"Ball")
    end
end

local function buildDetails(model: Model,id: string,v: any)
    local primary=v.MainColor
    local metal=v.MetalColor
    -- An elaborate metal shank in front view, with elevated crown and
    -- separate inner engraving. 20+ edges give rounded silhouette.
    hoop(model,"RoyalBand",1.32,0.12,metal,0.17,20,math.rad(9))
    hoop(model,"EngravedHalo",1.13,-0.06,primary,0.075,20,math.rad(9),Enum.Material.Neon)
    hoop(model,"ShankInner",0.99,0.28,metal,0.075,20,0)
    for i=1,8 do
        local a=(i-1)*math.pi/4
        local q=Vector3.new(math.cos(a)*1.30,math.sin(a)*1.30,-0.07)
        part(model,"RoyalSocket"..i,Vector3.new(0.29,0.26,0.21),
            CFrame.new(q)*CFrame.Angles(0,0,a),metal)
        part(model,"RuneEngraving"..i,Vector3.new(0.09,0.25,0.08),
            CFrame.new(q+Vector3.new(0,0,-0.21))*CFrame.Angles(0,0,a),
            primary,Enum.Material.Neon,nil,0.13)
    end

    if id=="MagicPowerRing" then
        hoop(model,"MagicGlyphCircle",1.68,-0.20,primary,0.055,16,
            math.rad(11),Enum.Material.Neon)
        gem(model,"ArcaneAmethyst",Vector3.new(0,0.38,-0.27),
            Vector3.new(1.14,1.28,0.70),v.GemColor)
        for i=1,6 do
            local a=i*math.pi/3
            local q=Vector3.new(math.cos(a)*1.74,math.sin(a)*1.74,-0.27)
            part(model,"FloatingArcaneRune"..i,Vector3.new(0.18,0.27,0.13),
                CFrame.new(q)*CFrame.Angles(0,0,a),primary,Enum.Material.Neon)
        end
        star(model,"MysticSigil",0.48,-0.88,
            Color3.fromRGB(247,203,255),6)
    elseif id=="PhysicalDamageRing" then
        gem(model,"CrimsonHeart",Vector3.new(0,0.27,-0.29),
            Vector3.new(1.11,1.02,0.72),v.GemColor)
        for i=1,5 do
            local a=math.rad(-160+80*(i-1))
            local q=Vector3.new(math.cos(a)*1.19,math.sin(a)*1.12,-0.32)
            part(model,"SteelClaw"..i,Vector3.new(0.19,0.80,0.32),
                CFrame.new(q)*CFrame.Angles(0,0,a+math.rad(90)),
                metal,Enum.Material.Metal)
        end
        hoop(model,"SanguineFlame",1.60,-0.20,primary,0.09,12,
            math.rad(10),Enum.Material.Neon)
    elseif id=="SPARing" then
        gem(model,"ClockCrystal",Vector3.new(0,0.14,-0.32),
            Vector3.new(1.18,1.19,0.53),v.GemColor)
        hoop(model,"ChronoDial",0.67,-0.64,primary,0.10,12,0,Enum.Material.Neon)
        for i=1,12 do
            local a=i*math.pi/6
            local start=Vector3.new(math.cos(a)*0.77,math.sin(a)*0.77,-0.67)
            local finish=Vector3.new(math.cos(a)*0.90,math.sin(a)*0.90,-0.67)
            bar(model,"HourMark"..i,start,finish,0.06,metal)
        end
        bar(model,"ClockHandLong",Vector3.new(0,0,-0.77),
            Vector3.new(0.40,0.41,-0.77),0.10,metal)
        bar(model,"ClockHandShort",Vector3.new(0,0,-0.79),
            Vector3.new(-0.13,0.36,-0.79),0.13,primary)
    elseif id=="RangeRing" then
        gem(model,"EmeraldEye",Vector3.new(0,0.15,-0.40),
            Vector3.new(1.21,1.12,0.57),v.GemColor)
        hoop(model,"TargetSight",0.86,-0.75,primary,0.09,16,0,Enum.Material.Neon)
        for i=1,4 do
            local a=i*math.pi/2
            local start=Vector3.new(math.cos(a)*0.88,math.sin(a)*0.88,-0.80)
            local finish=Vector3.new(math.cos(a)*1.68,math.sin(a)*1.68,-0.80)
            bar(model,"CompassArm"..i,start,finish,0.10,primary,Enum.Material.Neon)
        end
        part(model,"RangeFocus",Vector3.new(0.16,0.16,0.12),
            CFrame.new(0,0,-0.84),Color3.fromRGB(243,255,245),Enum.Material.Neon)
    elseif id=="RestrictionRing" then
        -- Dark crown and two diametrically opposite spell cores:
        -- red = double power; violet = double attack interval.
        hoop(model,"ObsidianCrown",1.49,-0.03,
            Color3.fromRGB(42,27,49),0.26,16)
        gem(model,"CrimsonSeal",Vector3.new(-0.53,0.26,-0.42),
            Vector3.new(0.82,0.85,0.66),Color3.fromRGB(231,58,91))
        gem(model,"VioletSeal",Vector3.new(0.53,0.26,-0.42),
            Vector3.new(0.82,0.85,0.66),v.GemColor)
        chain(model,"LeftBinding",Vector3.new(-1.95,0.95,-0.45),
            Vector3.new(-0.63,-1.30,-0.53),Color3.fromRGB(115,92,115),9)
        chain(model,"RightBinding",Vector3.new(1.90,1.02,-0.45),
            Vector3.new(0.66,-1.39,-0.53),Color3.fromRGB(115,92,115),9)
        hoop(model,"RestrictionScar",1.84,-0.14,primary,0.09,12,
            math.rad(10),Enum.Material.Neon)
    end
end

function Builder.Build(id: string): Model?
    local v=Rings.Get(id)
    if not v then return nil end
    local model=Instance.new("Model")
    model.Name=id
    model:SetAttribute("RelicRingId",id)
    model:SetAttribute("DisplayName",v.Name)
    model:SetAttribute("DualUse",true)
    model:SetAttribute("VisualOnly",true)
    model:SetAttribute("Version",Builder.Version)
    local root=part(model,"Root",Vector3.new(0.08,0.08,0.08),
        CFrame.identity,v.MainColor)
    root.Transparency=1
    model.PrimaryPart=root
    buildDetails(model,id,v)
    return model
end

function Builder.BuildAll(parent: Instance): Folder
    local old=parent:FindFirstChild("RelicRingPreviewModels")
    if old then old:Destroy() end
    local folder=Instance.new("Folder")
    folder.Name="RelicRingPreviewModels"
    folder:SetAttribute("StudioOnly",true)
    folder:SetAttribute("Preview",true)
    for _,v in ipairs(Rings.GetAll()) do
        local model=Builder.Build(v.Id)
        assert(model,"Missing ring model "..v.Id)
        model.Parent=folder
    end
    folder.Parent=parent
    return folder
end

return Builder
