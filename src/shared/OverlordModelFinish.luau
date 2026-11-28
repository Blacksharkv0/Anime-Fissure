--!strict
-- ANIME FISSURE | OverlordModelFinish v0.9
-- Six procedural expression rigs and individual weapon finish passes.
-- Every piece welded to moving R6 limbs (noncolliding, nonquery).
-- "MouthNeutral/Focus/Attack" switched locally by MotionController.
local Finish={}
Finish.Version="0.9.0"

local ink=Color3.fromRGB(46,36,43)
local gold=Color3.fromRGB(248,210,130)
local ice=Color3.fromRGB(184,228,243)
local silver=Color3.fromRGB(198,204,214)
local ruby=Color3.fromRGB(248,87,115)
local purple=Color3.fromRGB(178,121,237)

local function mount(folder: Instance,anchor: BasePart,name: string,
    size: Vector3,offset: CFrame,color: Color3,
    mat: Enum.Material?,shape: string?,alpha: number?): BasePart
    local item: BasePart
    if shape=="Wedge" then item=Instance.new("WedgePart")
    else
        local part=Instance.new("Part")
        if shape=="Ball" then part.Shape=Enum.PartType.Ball end
        item=part
    end
    item.Name=name
    item.Size=size
    -- The rounded guard head recedes at the cheeks and chin.
    if folder.Name=="ExpressionParts" and anchor:IsA("Part") and anchor.Shape==Enum.PartType.Ball then
        local pos=offset.Position
        local depth=anchor.Size.Z*0.5*math.sqrt(math.max(0,
            1-(2*pos.X/anchor.Size.X)^2-(2*pos.Y/anchor.Size.Y)^2))
        offset=CFrame.new(0,0,0.72-depth)*offset
    end
    item.CFrame=anchor.CFrame*offset
    item.Material=mat or Enum.Material.SmoothPlastic
    item.Color=color
    item.Transparency=alpha or 0
    item.Anchored=false
    item.Massless=true
    item.CanCollide=false
    item.CanQuery=false
    item.CanTouch=false
    item.CastShadow=false
    item.Parent=folder
    local weld=Instance.new("WeldConstraint")
    weld.Name="WeaponFinishWeld"
    weld.Part0=anchor
    weld.Part1=item
    weld.Parent=item
    return item
end

local function face(m: Model,id: string)
    local h=m:FindFirstChild("Head")::BasePart
    local folder=Instance.new("Folder")
    folder.Name="ExpressionParts"
    folder.Parent=m

    -- Silhouette and brow expression: each face uses identical API, but
    -- individual palettes differ, including bone jaw/eye glow on Ainz.
    local skeletal=id=="OVL_Ainz"
    local mouthColor=if skeletal then Color3.fromRGB(10,11,25) else ink
    mount(folder,h,"MouthNeutral",Vector3.new(0.28,0.055,0.07),
        CFrame.new(0,-0.34,-0.756),mouthColor)
    mount(folder,h,"MouthFocus",Vector3.new(0.27,0.08,0.075),
        CFrame.new(0,-0.32,-0.766)*CFrame.Angles(0,0,math.rad(-13)),
        mouthColor,nil,nil,1)
    mount(folder,h,"MouthAttack",Vector3.new(0.32,0.19,0.09),
        CFrame.new(0,-0.33,-0.761),
        if skeletal then purple else Color3.fromRGB(90,41,53),
        if skeletal then Enum.Material.Neon else Enum.Material.SmoothPlastic,
        "Ball",1)

    local iris=if id=="OVL_Climb" then Color3.fromRGB(104,189,248)
        elseif id=="OVL_Gazef" then Color3.fromRGB(102,123,142)
        elseif id=="OVL_Brain" then Color3.fromRGB(147,144,137)
        elseif id=="OVL_Shalltear" then ruby
        elseif id=="OVL_Albedo" then gold
        else ruby

    for _,x in ipairs({-0.30,0.30}) do
        -- Small pinprick pupils with self-authored anime highlights.
        mount(folder,h,"IrisHighlight",Vector3.new(0.048,0.073,0.045),
            CFrame.new(x-0.027,0.12,-0.773),ice,Enum.Material.Neon,"Ball")
        mount(folder,h,"FocusMark",Vector3.new(0.28,0.057,0.07),
            CFrame.new(x,0.36,-0.68)*CFrame.Angles(0,0,
                math.rad(if x<0 then 16 else -16)),
            if skeletal then gold else ink,nil,nil,1)
        mount(folder,h,"AttackEyeGlint",Vector3.new(0.12,0.15,0.065),
            CFrame.new(x,0.04,-0.78),iris,Enum.Material.Neon,"Ball",1)
    end
    if skeletal then
        -- Skull's violet jaw only flashes during casting; preserves bone face.
        mount(folder,h,"SkeletalJawEtch",Vector3.new(0.65,0.07,0.085),
            CFrame.new(0,-0.51,-0.735),
            Color3.fromRGB(117,92,109),Enum.Material.Slate)
    elseif id=="OVL_Brain" or id=="OVL_Gazef" then
        mount(folder,h,"SeriousNoseShadow",Vector3.new(0.10,0.20,0.065),
            CFrame.new(0,-0.15,-0.728),Color3.fromRGB(152,102,86))
    elseif id=="OVL_Shalltear" or id=="OVL_Albedo" then
        for _,x in ipairs({-0.50,0.50}) do
            mount(folder,h,"ElegantEyeLiner",Vector3.new(0.16,0.042,0.06),
                CFrame.new(x,0.11,-0.719),ink)
        end
    end
    return folder
end

local function weapon(m: Model,id: string)
    local arm=m:FindFirstChild("Right Arm")::BasePart
    local group=Instance.new("Folder")
    group.Name="WeaponFinish"
    group.Parent=m
    local focus=Instance.new("Attachment")
    focus.Name="WeaponFocus"
    focus.Parent=arm
    focus.Position=Vector3.new(0,2.9,-0.63)
    local function inlay(name: string,sz: Vector3,pos: CFrame,
        color: Color3,material: Enum.Material?,shape: string?)
        return mount(group,arm,name,sz,pos,color,material,shape)
    end
    if id=="OVL_Climb" then
        inlay("SilverGuardBladeBevel",Vector3.new(0.14,2.05,0.10),
            CFrame.new(-0.18,1.11,-0.72),ice,Enum.Material.Metal)
        inlay("RoyalBlueCrossguardGem",Vector3.new(0.29,0.34,0.26),
            CFrame.new(0,-0.05,-0.78),Color3.fromRGB(98,162,255),
            Enum.Material.Glass,"Ball")
        focus.Position=Vector3.new(0,2.75,-0.59)
    elseif id=="OVL_Brain" then
        -- Katana reads as thin and tapered, with dark wrapped hilt.
        inlay("KatanaCuttingEdge",Vector3.new(0.075,2.56,0.07),
            CFrame.new(-0.12,1.10,-0.70),ice,Enum.Material.Metal)
        for i=1,4 do
            inlay("KatanaHiltDiamond",Vector3.new(0.20,0.10,0.06),
                CFrame.new(0,-0.99+i*0.17,-0.74)
                    *CFrame.Angles(0,0,math.rad(40)),silver)
        end
        focus.Position=Vector3.new(0,3.15,-0.59)
    elseif id=="OVL_Gazef" then
        -- Razor Edge should have a recognizable wide sword profile.
        inlay("RazorEdgeSilverSpine",Vector3.new(0.16,2.66,0.13),
            CFrame.new(0,1.33,-0.73),silver,Enum.Material.Metal)
        inlay("RazorEdgeHiltGem",Vector3.new(0.29,0.35,0.31),
            CFrame.new(0,-0.21,-0.80),ruby,Enum.Material.Glass,"Ball")
        for _,side in ipairs({-1,1}) do
            inlay("RazorEdgeGoldenQuillon",Vector3.new(0.49,0.16,0.17),
                CFrame.new(side*0.36,-0.11,-0.63)
                    *CFrame.Angles(0,0,math.rad(side*9)),
                gold,Enum.Material.Metal)
        end
        focus.Position=Vector3.new(0,3.45,-0.59)
    elseif id=="OVL_Shalltear" then
        -- Ornate crimson spear, broken-glass wing motifs.
        for _,side in ipairs({-1,1}) do
            inlay("SpuitLanceWingProng",Vector3.new(0.36,1.18,0.25),
                CFrame.new(side*0.35,2.46,-0.63)
                    *CFrame.Angles(0,0,math.rad(side*20)),
                silver,Enum.Material.Metal,"Wedge")
        end
        inlay("SpuitLanceThorn",Vector3.new(0.27,0.58,0.30),
            CFrame.new(0.12,3.25,-0.62),ruby,Enum.Material.Neon,"Wedge")
        focus.Position=Vector3.new(0.12,3.39,-0.62)
    elseif id=="OVL_Albedo" then
        -- Black-and-gold halberd, her defensive role readable at distance.
        inlay("GuardianDarkWeaponSpine",Vector3.new(0.18,2.63,0.17),
            CFrame.new(0.12,0.39,-0.74),
            Color3.fromRGB(47,43,65),Enum.Material.Metal)
        inlay("GuardianHalberdCounterBlade",Vector3.new(0.61,0.86,0.23),
            CFrame.new(-0.34,1.93,-0.67)*CFrame.Angles(0,0,math.rad(-23)),
            silver,Enum.Material.Metal,"Wedge")
        inlay("GuardianGoldCrest",Vector3.new(0.41,0.43,0.26),
            CFrame.new(0.12,2.68,-0.65),gold,Enum.Material.Metal,"Ball")
        focus.Position=Vector3.new(0.12,2.87,-0.62)
    elseif id=="OVL_Ainz" then
        -- Scepter crest: suspended gems and eight-prong golden crown.
        for i=1,6 do
            local a=math.pi*2*(i-1)/6
            inlay("SupremeStaffCrown"..i,Vector3.new(0.21,0.61,0.23),
                CFrame.new(math.cos(a)*0.65+0.10,2.72+math.sin(a)*0.15,
                    math.sin(a)*0.44-0.72)*CFrame.Angles(0,0,math.rad(16*i)),
                gold,Enum.Material.Metal,"Wedge")
        end
        inlay("StaffArcaneCenter",Vector3.new(0.48,0.49,0.46),
            CFrame.new(0.1,2.58,-0.72),purple,Enum.Material.Neon,"Ball")
        focus.Position=Vector3.new(0.10,3.30,-0.72)
    end
    return group
end

local supported={
    OVL_Climb=true,OVL_Brain=true,OVL_Gazef=true,
    OVL_Shalltear=true,OVL_Albedo=true,OVL_Ainz=true,
}

function Finish.Apply(model: Model): boolean
    local id=model:GetAttribute("UnitId")
    if typeof(id)~="string" then return false end
    if not supported[id] then return false end
    if model:FindFirstChild("ExpressionParts") and
        model:FindFirstChild("WeaponFinish") then return true end
    face(model,id)
    weapon(model,id)
    model:SetAttribute("ModelFinishVersion",Finish.Version)
    return true
end
return Finish
