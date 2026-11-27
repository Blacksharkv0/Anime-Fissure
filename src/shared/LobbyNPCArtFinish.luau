--!strict
-- ANIME FISSURE | Lobby NPC art finish v1.0
-- One consistent anime-stylized finishing layer for STATIC prototype
-- Whis, Kisuke Urahara, Sung Jinwoo, Dante, preview Escanor and Gilgamesh.
-- Detailed native Roblox Parts/WedgeParts with no third party meshes or IDs.
-- These are NOT licensed source models or fully animated R15 characters.
-- No physics, inventory, weapons capable of attack or gameplay actions.
local Art={}
Art.Version="1.0.0"
local C={
 Gold=Color3.fromRGB(245,191,73),Champagne=Color3.fromRGB(255,232,158),
 Silver=Color3.fromRGB(211,226,240),Steel=Color3.fromRGB(115,131,153),
 Onyx=Color3.fromRGB(14,17,26),Midnight=Color3.fromRGB(25,28,51),
 Blue=Color3.fromRGB(72,183,248),Violet=Color3.fromRGB(132,97,243),
 Ruby=Color3.fromRGB(214,52,78),Wine=Color3.fromRGB(119,22,51),
 White=Color3.fromRGB(240,241,225),Forest=Color3.fromRGB(42,104,68),
 Emerald=Color3.fromRGB(101,213,151),Skin=Color3.fromRGB(244,202,170),
 Lilac=Color3.fromRGB(190,168,241),Cyan=Color3.fromRGB(147,236,255),
}
local function add(npc: Model,name: string,sz: Vector3,root: CFrame,
 x: number,y: number,z: number,col: Color3,material: Enum.Material?,
 rotation: Vector3?,shape: string?,alpha: number?)
    local p: BasePart
    if shape=="Wedge" then p=Instance.new("WedgePart")
    else
        local q=Instance.new("Part")
        if shape=="Ball" then q.Shape=Enum.PartType.Ball end
        if shape=="Cylinder" then q.Shape=Enum.PartType.Cylinder end
        p=q
    end
    p.Name=name
    p.Size=sz
    p.CFrame=root*CFrame.new(x,y,z)
        *CFrame.Angles(math.rad(if rotation then rotation.X else 0),
            math.rad(if rotation then rotation.Y else 0),
            math.rad(if rotation then rotation.Z else 0))
    p.Color=col
    p.Material=material or Enum.Material.SmoothPlastic
    p.Transparency=alpha or 0
    p.Anchored=true
    p.CanCollide=false
    p.CanQuery=false
    p.CanTouch=false
    p.CastShadow=material~=Enum.Material.Neon
    p.Parent=npc
    return p
end
local function line(npc: Model,name: string,root: CFrame,
 a: Vector3,b: Vector3,w: number,col: Color3,mat: Enum.Material?)
    local one=(root*CFrame.new(a)).Position
    local two=(root*CFrame.new(b)).Position
    local d=two-one
    if d.Magnitude<.03 then return end
    local p=add(npc,name,Vector3.new(w,w,d.Magnitude),CFrame.identity,
        0,0,0,col,mat)
    p.CFrame=CFrame.lookAt((one+two)*.5,two)
end
local function halo(npc: Model,name: string,cf: CFrame,
 center: Vector3,rad: number,color: Color3,sections: number,
 thickness: number,plane: string?)
    for i=1,sections do
        local a=math.pi*2*(i-1)/sections
        local b=math.pi*2*i/sections
        local function vertex(t: number)
            if plane=="Horizontal" then
                return center+Vector3.new(math.cos(t)*rad,0,math.sin(t)*rad)
            end
            return center+Vector3.new(math.cos(t)*rad,math.sin(t)*rad,0)
        end
        line(npc,name..i,cf,vertex(a),vertex(b),thickness,color,Enum.Material.Neon)
    end
end
local function basicFace(npc: Model,cf: CFrame,kind: string)
    local eye=if kind=="Raids" then C.Violet
        elseif kind=="Evolution" then C.Violet
        elseif kind=="Index" then C.Blue
        elseif kind=="Traits" then Color3.fromRGB(94,169,141)
        else C.Gold
    local eyebrow=if kind=="Evolution" then C.Silver
        elseif kind=="Index" then C.Silver else C.Onyx
    for _,side in ipairs({-1,1}) do
        add(npc,"StyledEyebrow_"..side,Vector3.new(.50,.08,.12),
            cf,side*.40,8.51,-.785,eyebrow,nil,Vector3.new(0,0,-side*11))
        add(npc,"AnimeIris_"..side,Vector3.new(.15,.17,.08),
            cf,side*.35,8.23,-.87,eye,Enum.Material.Neon,nil,"Ball")
        add(npc,"EyeGlint_"..side,Vector3.new(.07,.08,.07),
            cf,side*.38,8.30,-.93,C.White,Enum.Material.Neon,nil,"Ball")
    end
    add(npc,"ExpressionMouth",Vector3.new(.40,.055,.085),
        cf,.08,7.70,-.84,Color3.fromRGB(102,54,58))
end
local function armorTrim(npc: Model,cf: CFrame,color: Color3)
    for side=-1,1,2 do
        add(npc,"ShoulderTrim_"..side,Vector3.new(1.06,.18,1.24),
            cf,side*1.63,6.61,-.03,color,Enum.Material.Metal)
        add(npc,"SleeveBand_"..side,Vector3.new(.91,.17,.99),
            cf,side*1.63,4.06,0,color,Enum.Material.Metal)
        add(npc,"BootBand_"..side,Vector3.new(1.06,.17,1.18),
            cf,side*.62,1.50,-.04,color,Enum.Material.Metal)
    end
end
function Art.ApplyService(npc: Model,kind: string,cf: CFrame,station: any)
    if npc:GetAttribute("ArtFinish") then return end
    local accent=station.Accent
    basicFace(npc,cf,kind)
    if kind=="Evolution" then
        -- Whis: elongated coiffure, blue-violet robe with geometric
        -- orange diamond ornaments, dual pale sleeves and neck torus.
        armorTrim(npc,cf,C.Champagne)
        add(npc,"AngelicSash",Vector3.new(2.6,.22,1.48),
            cf,0,4.17,-.04,C.Gold,Enum.Material.Metal)
        for i=1,5 do
            local offset=i-3
            add(npc,"DiamondRobe_"..i,Vector3.new(.32,.52,.14),
                cf,0,6.45-i*.51,-.845,
                if i%2==0 then C.Champagne else C.Ruby,
                Enum.Material.Neon,Vector3.new(0,0,45))
        end
        for side=-1,1,2 do
            add(npc,"AngelCuff_"..side,Vector3.new(1.02,.65,1.0),
                cf,side*1.63,3.70,0,C.Champagne,Enum.Material.Metal)
            add(npc,"SilverHairFang_"..side,Vector3.new(.40,.95,.56),
                cf,side*.83,9.24,.02,C.Silver,nil,Vector3.new(0,0,side*28),"Wedge")
        end
        halo(npc,"NeckRingPremium",cf,Vector3.new(0,7.24,0),
            1.98,C.Cyan,20,.19,"Horizontal")
        add(npc,"StaffSunCore",Vector3.new(.40,.40,.40),
            cf,-2.0,10.5,-.30,C.Champagne,Enum.Material.Neon,nil,"Ball")
    elseif kind=="Traits" then
        -- Urahara: green striped bucket hat, sandy hair poking out
        -- from under the rim, long dark green kimono and folding fan.
        armorTrim(npc,cf,C.Emerald)
        for side=-1,1,2 do
            add(npc,"HatDroop_"..side,Vector3.new(.59,.18,2.43),
                cf,side*1.42,8.94,.02,C.White,nil,Vector3.new(0,0,side*16))
            add(npc,"SandySideHair_"..side,Vector3.new(.28,.63,.37),
                cf,side*.82,8.47,-.10,C.Champagne,nil,Vector3.new(0,0,side*15))
            add(npc,"KimonoLapels_"..side,Vector3.new(.40,2.20,.19),
                cf,side*.44,5.35,-.84,C.White,Enum.Material.Fabric,
                Vector3.new(0,0,side*-12))
        end
        add(npc,"FanHandle",Vector3.new(.17,1.02,.20),
            cf,2.25,3.47,-.43,C.Onyx,Enum.Material.Metal)
        for i=1,6 do
            add(npc,"FoldedFanLeaf_"..i,Vector3.new(.35,1.06,.10),
                cf,2.27+(i-3.5)*.19,4.30,-.51,
                if i%2==0 then C.Forest else C.Champagne,
                Enum.Material.Fabric,Vector3.new(0,0,(i-3.5)*7))
        end
    elseif kind=="Raids" then
        -- Jinwoo: dark layered hunter coat, purple eyes, rune
        -- daggers and spectral shoulder blades (limited to few parts).
        armorTrim(npc,cf,C.Violet)
        add(npc,"ShadowChestClasp",Vector3.new(.56,.44,.15),
            cf,0,6.11,-.77,C.Violet,Enum.Material.Neon,nil,"Ball")
        for side=-1,1,2 do
            add(npc,"HunterCoatEdge_"..side,Vector3.new(.19,3.23,.19),
                cf,side*.96,3.34,-.83,C.Steel,Enum.Material.Metal)
            add(npc,"ObsidianPauldron_"..side,Vector3.new(1.30,.55,1.35),
                cf,side*1.57,6.39,0,C.Midnight,Enum.Material.Metal,
                Vector3.new(0,0,side*12),"Wedge")
            add(npc,"SpectralFlare_"..side,Vector3.new(.22,.95,.29),
                cf,side*2.16,5.88,-.22,C.Violet,Enum.Material.Neon,
                Vector3.new(0,0,side*21),"Wedge",.16)
        end
        halo(npc,"HunterCircle",cf,Vector3.new(0,1.3,1.25),
            3.25,C.Violet,16,.065,"Horizontal")
    elseif kind=="Index" then
        -- Dante: strong crimson shoulder silhouette, white hair swept
        -- across forehead, silver belts, dark undersuit, broad sword.
        armorTrim(npc,cf,C.Silver)
        add(npc,"DanteCollarL",Vector3.new(.46,1.13,1.13),
            cf,-1.08,6.62,-.15,C.Wine,Enum.Material.Fabric,
            Vector3.new(0,0,-17),"Wedge")
        add(npc,"DanteCollarR",Vector3.new(.46,1.13,1.13),
            cf,1.08,6.62,-.15,C.Wine,Enum.Material.Fabric,
            Vector3.new(0,0,17),"Wedge")
        add(npc,"DanteSilverBuckle",Vector3.new(.88,.18,.18),
            cf,0,4.40,-.85,C.Silver,Enum.Material.Metal)
        for i=1,4 do
            add(npc,"DanteCoatButton_"..i,Vector3.new(.17,.17,.11),
                cf,.66,6.08-i*.49,-.97,C.Champagne,Enum.Material.Metal,nil,"Ball")
        end
        for i=1,5 do
            add(npc,"DanteBangs_"..i,Vector3.new(.35,.76,.44),
                cf,-.72+i*.29,8.94,-.53,C.Silver,nil,
                Vector3.new(23,0,-15+i*7),"Wedge")
        end
        add(npc,"GreatbladeBackRidge",Vector3.new(.19,3.29,.23),
            cf,1.88,5.45,.70,C.Champagne,Enum.Material.Metal)
        add(npc,"SwordPommel",Vector3.new(.50,.52,.48),
            cf,1.92,7.25,.89,C.Ruby,Enum.Material.Metal,nil,"Ball")
    elseif kind=="EventHub" then
        -- Escanor Studio ONLY: giant golden sun imagery; no event enabled.
        armorTrim(npc,cf,C.Gold)
        for side=-1,1,2 do
            add(npc,"SunArmor_"..side,Vector3.new(1.22,1.15,1.46),
                cf,side*1.60,6.53,0,C.Gold,Enum.Material.Metal,nil,"Wedge")
        end
        add(npc,"SunChest",Vector3.new(1.23,1.23,.26),
            cf,0,5.88,-.77,C.Champagne,Enum.Material.Neon,
            Vector3.new(0,0,45))
        add(npc,"SolarMoustache",Vector3.new(1.04,.16,.16),
            cf,0,7.77,-.88,Color3.fromRGB(160,100,47))
        halo(npc,"SolarCrown",cf,Vector3.new(0,9.4,.76),
            1.56,C.Gold,16,.12)
    end
    npc:SetAttribute("ArtFinish",Art.Version)
end

function Art.ApplyGilgamesh(npc: Model,cf: CFrame)
    if npc:GetAttribute("ArtFinish") then return end
    -- Gilgamesh uses a taller figure than the other NPCs. Only add
    -- ornaments, not copies of the already-built body parts.
    for side=-1,1,2 do
        add(npc,"ImperialPauldron_"..side,Vector3.new(1.53,.60,1.93),
            cf,side*2.13,6.92,-.14,C.Champagne,Enum.Material.Metal,
            Vector3.new(0,0,side*10),"Wedge")
        add(npc,"RoyalGauntlet_"..side,Vector3.new(1.04,.84,1.23),
            cf,side*2.15,3.73,-.12,C.Gold,Enum.Material.Metal)
        add(npc,"RoyalGem_"..side,Vector3.new(.42,.43,.24),
            cf,side*2.18,5.62,-.68,C.Ruby,Enum.Material.Glass,nil,"Ball")
        add(npc,"RoyalBootSpur_"..side,Vector3.new(.70,.24,1.20),
            cf,side*.92,.65,-.57,C.Champagne,Enum.Material.Metal)
        add(npc,"HairSideFang_"..side,Vector3.new(.47,1.16,.55),
            cf,side*.90,8.95,.04,C.Gold,nil,Vector3.new(0,0,side*24),"Wedge")
        add(npc,"RubyPupil_"..side,Vector3.new(.18,.20,.09),
            cf,side*.40,8.55,-.94,C.Ruby,Enum.Material.Neon,nil,"Ball")
        add(npc,"GoldenBrow_"..side,Vector3.new(.51,.10,.14),
            cf,side*.41,8.86,-.92,C.Gold,Enum.Material.Metal,
            Vector3.new(0,0,side*-9))
    end
    add(npc,"RoyalPectoral",Vector3.new(2.08,.44,.18),
        cf,0,6.52,-.85,C.Champagne,Enum.Material.Metal)
    add(npc,"RoyalChestSigil",Vector3.new(.42,.58,.19),
        cf,0,6.17,-1.04,C.Ruby,Enum.Material.Glass,
        Vector3.new(0,0,45))
    for i=1,5 do
        add(npc,"RoyalBreastplateRidge_"..i,Vector3.new(1.7,.065,.12),
            cf,0,6.19-(i*.19),-.84,C.Champagne,Enum.Material.Metal)
    end
    add(npc,"RoyalDiadem",Vector3.new(1.75,.30,1.16),
        cf,0,9.17,-.12,C.Champagne,Enum.Material.Metal)
    for i=1,7 do
        add(npc,"RegalCrownSpire_"..i,Vector3.new(.27,.95,.42),
            cf,(i-4)*.27,9.58+(i%2)*.14,-.05,C.Gold,
            Enum.Material.Metal,Vector3.new(0,0,(i-4)*-5),"Wedge")
    end
    halo(npc,"BabylonGoldSigil",cf,Vector3.new(0,9.82,1.13),
        2.26,C.Champagne,16,.08)
    npc:SetAttribute("ArtFinish",Art.Version)
end

return Art
