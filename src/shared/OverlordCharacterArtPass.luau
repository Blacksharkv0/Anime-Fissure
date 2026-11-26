--!strict
-- ANIME FISSURE | Overlord Character Art Pass v0.8
-- Anime-directed R6 cosmetics over existing six Studio models.
-- All details are welded to rig parts; no additional anchored parts,
-- no collision and no RemoteEvents, damage or stat changes.
-- Layered fabrics, metal trims and recognizable silhouettes; no imported IP.
local Art={}
Art.Version="0.8.0"

local C={
    white=Color3.fromRGB(244,243,238),
    pale=Color3.fromRGB(216,224,232),
    steel=Color3.fromRGB(131,149,165),
    silver=Color3.fromRGB(198,205,215),
    blue=Color3.fromRGB(79,136,225),
    gold=Color3.fromRGB(240,196,112),
    bronze=Color3.fromRGB(172,123,68),
    shadow=Color3.fromRGB(29,28,42),
    navy=Color3.fromRGB(38,50,76),
    maroon=Color3.fromRGB(104,41,59),
    red=Color3.fromRGB(183,54,75),
    ruby=Color3.fromRGB(240,65,99),
    ivory=Color3.fromRGB(230,215,185),
    violet=Color3.fromRGB(118,77,161),
    fuchsia=Color3.fromRGB(202,110,173),
    cloth=Color3.fromRGB(176,151,130),
    darkHair=Color3.fromRGB(40,30,35),
    brown=Color3.fromRGB(105,67,43),
    frost=Color3.fromRGB(198,220,230),
    cyan=Color3.fromRGB(136,224,248),
}

local function add(folder: Instance,base: BasePart,name: string,
    size: Vector3,localCF: CFrame,color: Color3,
    material: Enum.Material?,shape: string?): BasePart
    local p: BasePart
    if shape=="Wedge" then p=Instance.new("WedgePart")
    else
        local item=Instance.new("Part")
        if shape=="Ball" then item.Shape=Enum.PartType.Ball
        elseif shape=="Cylinder" then item.Shape=Enum.PartType.Cylinder end
        p=item
    end
    p.Name=name
    p.Size=size
    p.CFrame=base.CFrame*localCF
    p.Material=material or Enum.Material.SmoothPlastic
    p.Color=color
    p.Anchored=false
    p.Massless=true
    p.CastShadow=false
    p.CanCollide=false
    p.CanQuery=false
    p.CanTouch=false
    p.Parent=folder
    local weld=Instance.new("WeldConstraint")
    weld.Name="CosmeticWeld"
    weld.Part0=base
    weld.Part1=p
    weld.Parent=p
    return p
end

local function leftRight(folder: Instance,baseL: BasePart,baseR: BasePart,
    name: string,size: Vector3,cf: CFrame,
    color: Color3,mat: Enum.Material?,kind: string?)
    add(folder,baseL,"Left"..name,size,cf,color,mat,kind)
    add(folder,baseR,"Right"..name,size,cf,color,mat,kind)
end

local function climb(m: Model,f: Instance)
    local t=m.Torso::BasePart
    local h=m.Head::BasePart
    local la=m:FindFirstChild("Left Arm")::BasePart
    local ra=m:FindFirstChild("Right Arm")::BasePart
    local ll=m:FindFirstChild("Left Leg")::BasePart
    local rl=m:FindFirstChild("Right Leg")::BasePart
    -- Pure white royal guard armor; avoid upgrading Climb into plate-heavy Gazef.
    add(f,t,"WhiteGuardsmanCollar",Vector3.new(1.48,0.26,1.08),
        CFrame.new(0,0.83,0),C.white,Enum.Material.Metal)
    add(f,t,"WhiteChestInnerPlate",Vector3.new(1.46,1.05,0.20),
        CFrame.new(0,0.10,-0.70),C.white,Enum.Material.Metal)
    for side=-1,1,2 do
        add(f,t,"BreastplateSeam",Vector3.new(0.10,1.38,0.12),
            CFrame.new(side*0.64,0.05,-0.82),
            C.silver,Enum.Material.Metal)
        add(f,t,"RoyalShoulderTab",Vector3.new(0.23,0.60,0.17),
            CFrame.new(side*0.88,0.62,-0.55),C.blue,Enum.Material.Fabric)
    end
    add(f,t,"BlueRoyalInsignia",Vector3.new(0.38,0.54,0.16),
        CFrame.new(0,0.27,-0.84)*CFrame.Angles(0,0,math.rad(45)),
        C.blue,Enum.Material.Metal)
    add(f,t,"CloakFastener",Vector3.new(0.52,0.15,0.13),
        CFrame.new(0,0.63,-0.74),C.gold,Enum.Material.Metal)
    leftRight(f,la,ra,"WhiteGauntlet",Vector3.new(0.79,0.68,0.83),
        CFrame.new(0,-0.51,0),C.white,Enum.Material.Metal)
    leftRight(f,ll,rl,"WhiteGreave",Vector3.new(0.90,0.94,0.89),
        CFrame.new(0,0.12,-0.04),C.pale,Enum.Material.Metal)
    add(f,h,"ThinFrontHairLock",Vector3.new(0.21,0.58,0.25),
        CFrame.new(0.30,0.38,-0.53)*CFrame.Angles(0,0,math.rad(-19)),
        Color3.fromRGB(245,220,132),Enum.Material.SmoothPlastic,"Wedge")
end

local function brain(m: Model,f: Instance)
    local t=m.Torso::BasePart
    local h=m.Head::BasePart
    local la=m:FindFirstChild("Left Arm")::BasePart
    local ra=m:FindFirstChild("Right Arm")::BasePart
    -- Slim swordmaster: loose robe, exposed slim waist and long hair.
    add(f,t,"RoninOvercoatLapelL",Vector3.new(0.31,1.68,0.23),
        CFrame.new(-0.52,0.14,-0.69)*CFrame.Angles(0,0,math.rad(-13)),
        C.navy,Enum.Material.Fabric)
    add(f,t,"RoninOvercoatLapelR",Vector3.new(0.31,1.68,0.23),
        CFrame.new(0.52,0.14,-0.69)*CFrame.Angles(0,0,math.rad(13)),
        C.navy,Enum.Material.Fabric)
    add(f,t,"Undergarment",Vector3.new(0.83,1.25,0.12),
        CFrame.new(0,0.06,-0.65),C.cloth,Enum.Material.Fabric)
    add(f,t,"VioletWaistSashKnot",Vector3.new(0.51,0.50,0.24),
        CFrame.new(-0.91,-0.66,-0.56),C.violet,Enum.Material.Fabric,"Ball")
    for i=1,3 do
        add(f,t,"WindblownRoninCape"..i,Vector3.new(0.51,2.35,0.19),
            CFrame.new((i-2)*0.55,-0.59,0.65)
                *CFrame.Angles(math.rad(15),0,math.rad((i-2)*13)),
            if i%2==0 then C.shadow else C.navy,Enum.Material.Fabric,"Wedge")
    end
    for i=1,4 do
        local x=(i-2.5)*0.30
        add(f,h,"DarkHairSpike"..i,Vector3.new(0.31,0.53,0.32),
            CFrame.new(x,0.76,-0.24)*CFrame.Angles(0,0,math.rad((i-2)*17)),
            C.darkHair,Enum.Material.SmoothPlastic,"Wedge")
    end
    add(f,h,"BackPonytail",Vector3.new(0.57,1.57,0.50),
        CFrame.new(0,-0.62,0.64)*CFrame.Angles(math.rad(12),0,0),
        C.darkHair,Enum.Material.SmoothPlastic,"Ball")
    leftRight(f,la,ra,"DarkForearmWrap",Vector3.new(0.75,0.64,0.80),
        CFrame.new(0,-0.51,0),C.shadow,Enum.Material.Fabric)
    add(f,ra,"KatanaHiltWrap",Vector3.new(0.24,0.66,0.24),
        CFrame.new(0,-0.66,-0.60),C.violet,Enum.Material.Fabric)
end

local function gazef(m: Model,f: Instance)
    local t=m.Torso::BasePart
    local h=m.Head::BasePart
    local la=m:FindFirstChild("Left Arm")::BasePart
    local ra=m:FindFirstChild("Right Arm")::BasePart
    local ll=m:FindFirstChild("Left Leg")::BasePart
    local rl=m:FindFirstChild("Right Leg")::BasePart
    -- A veteran: stout red-and-steel warrior captain, not a second Climb.
    add(f,t,"RoyalWarriorGorget",Vector3.new(2.04,0.47,1.25),
        CFrame.new(0,0.79,0),C.steel,Enum.Material.Metal)
    add(f,t,"IronChestChevron",Vector3.new(1.36,0.21,0.17),
        CFrame.new(0,0.34,-0.75)*CFrame.Angles(0,0,math.rad(-7)),
        C.gold,Enum.Material.Metal)
    add(f,t,"WarriorCaptainSigil",Vector3.new(0.54,0.61,0.14),
        CFrame.new(0,0.02,-0.76),C.silver,Enum.Material.Metal,"Wedge")
    for side=-1,1,2 do
        add(f,t,"PlateFlank",Vector3.new(0.37,1.53,0.41),
            CFrame.new(side*0.93,-0.26,-0.30),
            C.steel,Enum.Material.Metal)
        add(f,t,"LongBeltCloth",Vector3.new(0.48,1.55,0.14),
            CFrame.new(side*0.54,-1.36,-0.67)
                *CFrame.Angles(math.rad(9),0,math.rad(side*8)),
            C.maroon,Enum.Material.Fabric)
        add(f,if side<0 then la else ra,"VeteranPlateGauntlet",
            Vector3.new(0.90,0.91,0.85),CFrame.new(0,-0.49,0),
            C.silver,Enum.Material.Metal)
        add(f,if side<0 then ll else rl,"BandedGreave",
            Vector3.new(0.93,1.18,0.90),CFrame.new(0,0.29,0),
            C.steel,Enum.Material.Metal)
    end
    add(f,h,"BrownHairTuft",Vector3.new(0.61,0.43,0.44),
        CFrame.new(-0.22,0.76,-0.22)*CFrame.Angles(0,0,math.rad(-21)),
        C.brown,Enum.Material.SmoothPlastic,"Wedge")
    add(f,h,"WarriorNoseBridge",Vector3.new(0.15,0.23,0.12),
        CFrame.new(0,-0.15,-0.69),Color3.fromRGB(196,151,120))
end

local function shalltear(m: Model,f: Instance)
    local t=m.Torso::BasePart
    local h=m.Head::BasePart
    local ra=m:FindFirstChild("Right Arm")::BasePart
    -- Distinct gothic gothic-lolita ruffles and curled side locks, spear.
    add(f,t,"WhiteLaceCollar",Vector3.new(1.49,0.32,0.34),
        CFrame.new(0,0.75,-0.50),C.white,Enum.Material.Fabric)
    add(f,t,"GothicNeckGem",Vector3.new(0.44,0.52,0.17),
        CFrame.new(0,0.49,-0.77),C.ruby,Enum.Material.Glass,"Ball")
    for side=-1,1,2 do
        add(f,t,"LayeredDressHem",Vector3.new(1.24,0.31,1.41),
            CFrame.new(side*0.73,-2.58,-0.07),C.white,Enum.Material.Fabric)
        add(f,t,"BurgundyGownRibbon",Vector3.new(0.22,2.04,0.12),
            CFrame.new(side*0.86,-1.26,-0.91),
            C.maroon,Enum.Material.Fabric)
        for curl=1,3 do
            add(f,h,"PaleTwinCurl"..side.."_"..curl,
                Vector3.new(0.28,0.54,0.29),
                CFrame.new(side*(0.64+0.07*curl),-0.37-0.47*curl,0.07)
                    *CFrame.Angles(0,0,math.rad(side*14)),
                C.frost,Enum.Material.SmoothPlastic,"Ball")
        end
        add(f,h,"HeaddressRose"..side,Vector3.new(0.37,0.37,0.38),
            CFrame.new(side*0.57,0.65,-0.44),
            C.red,Enum.Material.Fabric,"Ball")
        add(f,t,"BodiceLaceSeam",Vector3.new(0.12,1.03,0.10),
            CFrame.new(side*0.53,0.19,-0.74),
            C.white,Enum.Material.Fabric)
    end
    for _,y in ipairs({1.78,2.28}) do
        add(f,ra,"SpuitLanceGothicCross",Vector3.new(0.95,0.13,0.35),
            CFrame.new(0.12,y,-0.67),C.silver,Enum.Material.Metal)
    end
    add(f,ra,"SpuitLanceRubyProng",Vector3.new(0.23,0.87,0.22),
        CFrame.new(0.12,3.22,-0.65),C.ruby,Enum.Material.Neon,"Wedge")
end

local function albedo(m: Model,f: Instance)
    local t=m.Torso::BasePart
    local h=m.Head::BasePart
    -- More graceful silhouette: layered white drapes, dramatic black feather fans.
    add(f,t,"WhiteDressBodice",Vector3.new(1.64,1.22,0.19),
        CFrame.new(0,0.19,-0.72),C.white,Enum.Material.Fabric)
    add(f,t,"GoldDressPattern",Vector3.new(0.14,1.33,0.10),
        CFrame.new(0,0.05,-0.84),C.gold,Enum.Material.Metal)
    add(f,t,"BlackNeckRibbon",Vector3.new(0.59,0.26,0.23),
        CFrame.new(0,0.77,-0.55),C.shadow,Enum.Material.Fabric)
    for side=-1,1,2 do
        add(f,t,"SilkDressDrape",Vector3.new(0.99,2.67,0.18),
            CFrame.new(side*0.79,-1.60,-0.42)
                *CFrame.Angles(math.rad(5),0,math.rad(side*10)),
            C.white,Enum.Material.Fabric,"Wedge")
        add(f,t,"SilkGownTrim",Vector3.new(0.21,2.23,0.13),
            CFrame.new(side*1.19,-1.43,-0.64)
                *CFrame.Angles(0,0,math.rad(side*7)),
            C.gold,Enum.Material.Metal)
        for feather=1,5 do
            local x=side*(1.38+feather*0.35)
            add(f,t,"MidnightWingSecondary"..side.."_"..feather,
                Vector3.new(0.54,2.56-feather*0.17,0.20),
                CFrame.new(x,1.32-feather*0.14,0.67)
                    *CFrame.Angles(math.rad(18),math.rad(side*9),
                        math.rad(side*(21+feather*8))),
                C.shadow,Enum.Material.SmoothPlastic,"Wedge")
        end
        add(f,h,"BlackHornSecondaryCurve",Vector3.new(0.26,0.55,0.28),
            CFrame.new(side*0.72,1.30,0)
                *CFrame.Angles(0,0,math.rad(side*41)),
            C.shadow,Enum.Material.SmoothPlastic,"Wedge")
        add(f,h,"EbonyHairLayer",Vector3.new(0.30,2.66,0.44),
            CFrame.new(side*0.58,-0.85,0.44),C.shadow,
            Enum.Material.SmoothPlastic,"Ball")
    end
    add(f,h,"BlackHairCurtain",Vector3.new(0.91,3.25,0.34),
        CFrame.new(0,-1.01,0.63),C.shadow,
        Enum.Material.SmoothPlastic)
end

local function ainz(m: Model,f: Instance)
    local t=m.Torso::BasePart
    local h=m.Head::BasePart
    local ra=m:FindFirstChild("Right Arm")::BasePart
    -- Regal skull, enlarged trim and multi-layered robes; preserve recognizable orbs.
    add(f,t,"RoyalGoldCollar",Vector3.new(2.20,0.21,1.37),
        CFrame.new(0,0.87,0),C.gold,Enum.Material.Metal)
    add(f,t,"OverlordChestGoldInlay",Vector3.new(0.21,1.56,0.13),
        CFrame.new(0,-0.01,-0.87),C.gold,Enum.Material.Metal)
    for side=-1,1,2 do
        add(f,t,"RegalGoldRobeStrip",Vector3.new(0.17,3.23,0.15),
            CFrame.new(side*1.08,-1.25,-0.65),
            C.gold,Enum.Material.Metal)
        add(f,t,"RoyalVioletDrape",Vector3.new(0.73,3.01,0.20),
            CFrame.new(side*1.12,-1.37,0.31)
                * CFrame.Angles(math.rad(10),0,math.rad(side*7)),
            C.violet,Enum.Material.Fabric)
        add(f,t,"BoneRibRidge",Vector3.new(0.19,0.21,0.30),
            CFrame.new(side*0.46,0.35,-0.82),
            C.ivory,Enum.Material.SmoothPlastic)
        add(f,h,"SkullCheekbone",Vector3.new(0.41,0.16,0.27),
            CFrame.new(side*0.40,-0.25,-0.64),
            C.ivory,Enum.Material.SmoothPlastic)
        add(f,h,"BlackSunkenSocket",Vector3.new(0.25,0.10,0.12),
            CFrame.new(side*0.31,0.22,-0.66),
            C.shadow,Enum.Material.Slate)
    end
    for _,y in ipairs({-0.13,0.10}) do
        add(f,h,"SkeletalJawSeam",Vector3.new(0.78,0.09,0.11),
            CFrame.new(0,-0.48+y,-0.69),
            C.shadow,Enum.Material.Slate)
    end
    add(f,h,"HoodGoldPeak",Vector3.new(0.70,0.32,0.16),
        CFrame.new(0,0.83,-0.62),C.gold,Enum.Material.Metal,"Wedge")
    -- Staff detailing, polished gold prongs and a purple suspended gem.
    for side=-1,1,2 do
        add(f,ra,"OverlordStaffProng",Vector3.new(0.16,0.68,0.16),
            CFrame.new(0.10+side*0.44,2.59,-0.72)
                * CFrame.Angles(0,0,math.rad(-side*28)),
            C.gold,Enum.Material.Metal)
    end
    add(f,ra,"StaffSecondaryOrb",Vector3.new(0.43,0.43,0.43),
        CFrame.new(0.10,3.08,-0.72),
        C.fuchsia,Enum.Material.Glass,"Ball")
end

local builders={
    OVL_Climb=climb,OVL_Brain=brain,OVL_Gazef=gazef,
    OVL_Shalltear=shalltear,OVL_Albedo=albedo,OVL_Ainz=ainz,
}

function Art.Apply(model: Model): boolean
    local id=model:GetAttribute("UnitId")
    if typeof(id)~="string" then return false end
    local build=builders[id]
    if not build then return false end
    if model:FindFirstChild("AnimeArtPass") then return true end
    for _,n in ipairs({"Torso","Head","Left Arm","Right Arm","Left Leg","Right Leg"}) do
        assert(model:FindFirstChild(n),"R6 rig incompleto: "..id.." missing "..n)
    end
    local f=Instance.new("Folder")
    f.Name="AnimeArtPass"
    f.Parent=model
    build(model,f)
    model:SetAttribute("ArtPassVersion",Art.Version)
    return true
end

return Art
