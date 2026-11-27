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
    -- Replace the old blockout's visible geometry while preserving the
    -- original head/pivot, solid pedestal and independently validated prompt.
    local gold=Color3.fromRGB(210,150,41)
    local light=Color3.fromRGB(255,226,146)
    local brass=Color3.fromRGB(124,78,27)
    local dark=Color3.fromRGB(30,25,35)
    local crimson=Color3.fromRGB(136,23,40)
    local red=Color3.fromRGB(200,39,58)
    local skin=Color3.fromRGB(244,208,169)
    local hair=Color3.fromRGB(247,202,83)
    local hairShade=Color3.fromRGB(183,120,35)
    local function p(name: string,s: Vector3,x: number,y: number,z: number,
        color: Color3,rx: number?,ry: number?,rz: number?,shape: string?,mat: Enum.Material?)
        return add(npc,name,s,cf,x,y,z,color,mat or Enum.Material.Metal,
            Vector3.new(rx or 0,ry or 0,rz or 0),shape)
    end
    for _,part in ipairs(npc:GetChildren()) do
        if part:IsA("BasePart") and not part.CanCollide
            and part.Name~="RegalHead" then
            part.Transparency=1
        end
    end
    local head=npc:FindFirstChild("RegalHead")
    if head and head:IsA("BasePart") then
        head.Size=Vector3.new(1.52,1.65,1.37)
        head.Color=skin
        local mesh=Instance.new("SpecialMesh")
        mesh.Name="Reborn_RegalFaceMesh"
        mesh.MeshType=Enum.MeshType.Head;mesh.Parent=head
        local face=Instance.new("SurfaceGui")
        face.Name="Reborn_RoyalFace";face.Face=Enum.NormalId.Front
        face.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
        face.PixelsPerStud=160;face.LightInfluence=.15;face.Parent=head
        local canvas=Instance.new("Frame")
        canvas.Size=UDim2.fromScale(1,1);canvas.BackgroundTransparency=1;canvas.Parent=face
        local function mark(name: string,x: number,y: number,w: number,h: number,col: Color3,rot: number)
            local f=Instance.new("Frame")
            f.Name=name;f.Position=UDim2.fromScale(x,y);f.Size=UDim2.fromScale(w,h)
            f.BackgroundColor3=col;f.BorderSizePixel=0;f.Rotation=rot;f.Parent=canvas
            local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(.22,0);corner.Parent=f
        end
        for side=-1,1,2 do
            local x=if side==-1 then .18 else .58
            local tilt=if side==-1 then 12 else -12
            mark("EyeLine_"..side,x,.37,.24,.14,dark,tilt)
            mark("EyeWhite_"..side,x+.014,.395,.21,.09,C.White,tilt)
            mark("CrimsonIris_"..side,x+.083,.375,.075,.122,red,0)
            mark("SlitPupil_"..side,x+.112,.383,.022,.108,dark,0)
            mark("EyeGlint_"..side,x+.091,.39,.02,.022,C.White,0)
            mark("Brow_"..side,x-.004,.28,.25,.049,hairShade,tilt)
        end
        mark("Nose",.492,.52,.036,.13,Color3.fromRGB(194,143,117),-8)
        mark("RoyalSmirk",.42,.74,.19,.028,Color3.fromRGB(97,55,45),-9)
    end
    -- Golden hair swept upward. No oversized crown: the hair itself is
    -- the distinctive royal silhouette.
    p("Reborn_HairBase",Vector3.new(1.65,.76,1.48),0,8.97,-.02,hairShade,0,0,0,"Ball",Enum.Material.SmoothPlastic)
    p("Reborn_HairCrown",Vector3.new(1.65,.60,1.38),0,9.13,-.06,hair,0,0,0,"Ball",Enum.Material.SmoothPlastic)
    for i=-3,3 do
        p("Reborn_SweptHair_"..i,Vector3.new(.34,.94+(.10-math.abs(i)*.025),.67),
            i*.22,9.48-math.abs(i)*.04,-.14,hair,-24,0,-i*11,"Wedge",Enum.Material.SmoothPlastic)
        p("Reborn_HairHighlight_"..i,Vector3.new(.15,.75,.29),i*.22,9.53,-.30,
            light,-24,0,-i*11,"Wedge",Enum.Material.SmoothPlastic)
    end
    for side=-1,1,2 do
        p("Reborn_Temple_"..side,Vector3.new(.25,.66,.52),side*.72,8.68,.11,hair,7,0,side*18,"Wedge",Enum.Material.SmoothPlastic)
        p("Reborn_Ear_"..side,Vector3.new(.20,.38,.31),side*.76,8.20,.02,skin,0,0,0,"Ball",Enum.Material.SmoothPlastic)
        p("Reborn_RoyalEarring_"..side,Vector3.new(.17,.36,.18),side*.81,7.94,-.04,light,0,0,0,"Ball")
        -- Legacy marker names remain present for existing Studio diagnostics.
        p("GoldenBrow_"..side,Vector3.new(.28,.06,.05),side*.40,8.70,-.82,hairShade,0,0,side*-8,nil,Enum.Material.SmoothPlastic).Transparency=1
    end
    p("Reborn_Neck",Vector3.new(.88,.80,.85),0,7.42,0,skin,0,0,0,"Ball",Enum.Material.SmoothPlastic)
    p("Reborn_UnderSuit",Vector3.new(2.27,2.95,1.32),0,5.56,0,dark,0,0,0,nil,Enum.Material.Fabric)
    p("Reborn_Backplate",Vector3.new(2.34,2.28,.48),0,5.70,.49,brass,0,0,0,"Ball")
    p("Reborn_ChestCore",Vector3.new(2.48,1.82,1.46),0,6.02,-.07,gold,0,0,0,"Ball")
    p("Reborn_Gorget",Vector3.new(1.63,.31,1.12),0,7.02,0,light,0,0,0)
    for side=-1,1,2 do
        p("Reborn_Pectoral_"..side,Vector3.new(1.19,.83,.49),side*.57,6.29,-.63,light,0,side*13,side*11,"Ball")
        p("Reborn_ChestEdge_"..side,Vector3.new(.12,1.02,.15),side*.93,6.05,-.73,brass,0,0,side*-25)
        for i=1,4 do
            p("Reborn_AbdominalPlate_"..side.."_"..i,Vector3.new(.93-i*.08,.34,.29),
                side*(.48-i*.04),5.65-i*.30,-.64,gold,0,side*8,side*-7,"Wedge")
        end
        -- Overlapping shoulder lames taper into an articulated-looking arm.
        p("ImperialPauldron_"..side,Vector3.new(1.69,.89,1.64),side*1.81,6.59,.02,light,0,0,side*-15,"Ball")
        for i=1,3 do
            p("Reborn_ShoulderLame_"..side.."_"..i,Vector3.new(1.12-i*.12,.45,1.28-i*.08),
                side*(1.86+i*.10),6.45-i*.23,-.02,if i==1 then gold else brass,0,0,side*-14,"Wedge")
        end
        p("Reborn_Bicep_"..side,Vector3.new(.78,1.30,.83),side*2.04,5.56,0,dark,0,0,side*-5,"Ball",Enum.Material.Fabric)
        p("Reborn_UpperArmPlate_"..side,Vector3.new(.80,.87,.81),side*2.04,5.68,-.02,gold,0,0,side*-5,"Ball")
        p("Reborn_ElbowJoint_"..side,Vector3.new(.70,.34,.72),side*2.06,4.92,0,dark,0,0,0,"Ball")
        p("Reborn_Vambrace_"..side,Vector3.new(.91,1.19,.92),side*2.08,4.37,-.01,gold,0,0,side*4,"Ball")
        p("Reborn_VambraceRidge_"..side,Vector3.new(.43,.96,.19),side*2.08,4.38,-.43,light,0,0,0,"Wedge")
        p("Reborn_WristRing_"..side,Vector3.new(.83,.20,.85),side*2.08,3.77,0,brass)
        p("Reborn_Gauntlet_"..side,Vector3.new(.66,.63,.73),side*2.08,3.36,-.07,gold,0,0,0,"Ball")
        for i=1,4 do
            p("Reborn_Knuckle_"..side.."_"..i,Vector3.new(.12,.25,.16),side*2.08+(i-2.5)*.14,3.28,-.40,light,0,0,0,"Ball")
        end
        p("Reborn_Thumb_"..side,Vector3.new(.19,.36,.19),side*1.76,3.35,-.15,gold,0,0,side*-18,"Ball")
        -- Waist tassets and greaves, with visible dark joints.
        p("Reborn_HipPlate_"..side,Vector3.new(1.09,.83,1.16),side*.81,4.07,.02,gold,0,0,side*9,"Ball")
        for i=1,3 do
            p("Reborn_Tasset_"..side.."_"..i,Vector3.new(.72,.38,.32),side*(.92+i*.045),3.82-i*.26,-.62,
                if i==1 then light else gold,0,side*10,side*8,"Wedge")
        end
        p("Reborn_Thigh_"..side,Vector3.new(.98,1.55,1.04),side*.83,3.04,0,dark,0,0,0,"Ball",Enum.Material.Fabric)
        p("Reborn_ThighPlate_"..side,Vector3.new(.90,1.15,.46),side*.83,3.10,-.39,gold,0,0,side*5,"Ball")
        p("Reborn_Knee_"..side,Vector3.new(.81,.55,.77),side*.83,2.36,-.12,light,0,0,0,"Ball")
        p("Reborn_Greave_"..side,Vector3.new(.94,1.43,.94),side*.83,1.60,0,gold,0,0,0,"Ball")
        p("Reborn_GreaveRidge_"..side,Vector3.new(.34,1.26,.22),side*.83,1.56,-.47,light,0,0,0,"Wedge")
        p("Reborn_Boot_"..side,Vector3.new(1.08,.53,1.60),side*.83,.78,-.27,gold,0,0,0,"Ball")
        p("Reborn_BootSole_"..side,Vector3.new(1.07,.14,1.52),side*.83,.54,-.27,brass)
        -- Red cloth panels are separated from armor, with dark inner folds.
        p("Reborn_RedCloth_"..side,Vector3.new(.86,3.43,.17),side*.85,2.40,.72,crimson,-7,0,side*8,nil,Enum.Material.Fabric)
        p("Reborn_ClothFold_"..side,Vector3.new(.18,3.23,.10),side*1.02,2.39,.84,red,-7,0,side*8,nil,Enum.Material.Fabric)
    end
    p("Reborn_RoyalBelt",Vector3.new(2.33,.34,1.40),0,4.24,0,brass)
    p("Reborn_BeltClasp",Vector3.new(.65,.47,.20),0,4.24,-.78,light,0,0,45)
    p("RoyalChestSigil",Vector3.new(.38,.51,.23),0,6.20,-.88,C.Ruby,0,0,45,nil,Enum.Material.Glass)
    p("Reborn_SigilRim",Vector3.new(.55,.64,.13),0,6.20,-.79,light,0,0,45)
    -- Restrained halo located behind the hair; the hall retains its 11 portals.
    halo(npc,"BabylonGoldSigil",cf,Vector3.new(0,9.55,1.30),1.92,C.Champagne,16,.055)
    npc:SetAttribute("CharacterReborn","Gilgamesh-v1")
    npc:SetAttribute("ArtFinish",Art.Version)
end

return Art
