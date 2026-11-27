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
    if kind~="Raids" and kind~="Index" and kind~="Evolution" then basicFace(npc,cf,kind) end
    if kind=="Evolution" then
        -- Character Reborn: Whis. Replace blockout, preserve head pivot
        -- and station-owned interaction. All cosmetics are static and safe.
        local skin=Color3.fromRGB(137,199,222)
        local skinShadow=Color3.fromRGB(94,151,188)
        local hair=Color3.fromRGB(240,247,255)
        local hairShade=Color3.fromRGB(171,190,219)
        local burgundy=Color3.fromRGB(113,31,73)
        local wine=Color3.fromRGB(74,23,54)
        local rose=Color3.fromRGB(153,45,92)
        local black=Color3.fromRGB(20,26,47)
        local ivory=Color3.fromRGB(244,245,232)
        local orange=Color3.fromRGB(236,151,56)
        local cyan=Color3.fromRGB(118,224,249)
        local blue=Color3.fromRGB(54,122,181)
        local violet=Color3.fromRGB(128,100,205)
        local function p(n: string,s: Vector3,x: number,y: number,z: number,col: Color3,
            rx: number?,ry: number?,rz: number?,shape: string?,mat: Enum.Material?,alpha: number?)
            return add(npc,n,s,cf,x,y,z,col,mat or Enum.Material.SmoothPlastic,
                Vector3.new(rx or 0,ry or 0,rz or 0),shape,alpha)
        end
        for _,obj in ipairs(npc:GetChildren()) do
            if obj:IsA("BasePart") and obj.Name~="Head" then obj.Transparency=1 end
        end
        local head=npc:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            head.Size=Vector3.new(1.37,1.74,1.26);head.Color=skin
            local mesh=Instance.new("SpecialMesh")
            mesh.Name="Reborn_WhisHead";mesh.MeshType=Enum.MeshType.Head;mesh.Parent=head
            local face=Instance.new("SurfaceGui")
            face.Name="Reborn_WhisFace";face.Face=Enum.NormalId.Front
            face.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;face.PixelsPerStud=160
            face.LightInfluence=.12;face.Parent=head
            local canvas=Instance.new("Frame")
            canvas.Size=UDim2.fromScale(1,1);canvas.BackgroundTransparency=1;canvas.Parent=face
            local function mark(n: string,x: number,y: number,w: number,h: number,col: Color3,rot: number)
                local f=Instance.new("Frame")
                f.Name=n;f.Position=UDim2.fromScale(x,y);f.Size=UDim2.fromScale(w,h)
                f.BackgroundColor3=col;f.BorderSizePixel=0;f.Rotation=rot;f.Parent=canvas
                local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(.28,0);corner.Parent=f
            end
            for side=-1,1,2 do
                local x=if side==-1 then .17 else .57
                local tilt=if side==-1 then -4 else 4
                mark("EyeOutline_"..side,x,.40,.25,.12,black,tilt)
                mark("EyeWhite_"..side,x+.017,.423,.216,.075,ivory,tilt)
                mark("LavenderIris_"..side,x+.09,.407,.077,.101,violet,0)
                mark("Pupil_"..side,x+.117,.415,.024,.084,black,0)
                mark("EyeGlint_"..side,x+.095,.42,.023,.022,hair,0)
                mark("WhiteBrow_"..side,x-.006,.31,.26,.045,hair,tilt)
            end
            mark("NoseShadow",.487,.53,.034,.13,skinShadow,-7)
            mark("CalmSmile",.41,.735,.18,.025,Color3.fromRGB(85,99,151),-3)
            mark("LipHighlight",.45,.767,.10,.012,Color3.fromRGB(179,220,232),0)
        end
        -- Whis's high swept silver coiffure, sculpted with overlapping
        -- tapered locks and separate highlights instead of a crown.
        p("Reborn_WhisHairBase",Vector3.new(1.43,.75,1.40),0,8.69,.03,hairShade,0,0,0,"Ball")
        p("Reborn_WhisHairVolume",Vector3.new(1.39,1.77,1.27),0,9.48,.09,hair,8,0,0,"Ball")
        for i=-3,3 do
            p("Reborn_WhisHairLock_"..i,Vector3.new(.31,1.76-math.abs(i)*.15,.65),
                i*.17,9.62-math.abs(i)*.08,-.22,if i%2==0 then hair else hairShade,
                -11,0,-i*8,"Wedge")
            p("Reborn_WhisHairHighlight_"..i,Vector3.new(.11,1.29,.30),
                i*.17,9.70,-.43,hair,-11,0,-i*8,"Wedge")
        end
        p("Reborn_WhisHairTip",Vector3.new(.66,.96,.70),0,10.63,.14,hair,-15,0,-7,"Wedge")
        for side=-1,1,2 do
            p("SilverHairFang_"..side,Vector3.new(.24,.70,.43),side*.62,8.65,.03,hair,0,0,side*12,"Wedge")
            p("Reborn_WhisEar_"..side,Vector3.new(.16,.38,.29),side*.69,7.99,.03,skin,0,0,side*-10,"Ball")
        end
        p("Reborn_WhisNeck",Vector3.new(.58,.85,.65),0,7.06,0,skin,0,0,0,"Ball")
        p("Reborn_WhisTorso",Vector3.new(1.96,2.75,1.17),0,5.47,0,burgundy,0,0,0,nil,Enum.Material.Fabric)
        p("Reborn_WhisCollar",Vector3.new(1.30,.34,.91),0,6.83,0,black,0,0,0,nil,Enum.Material.Fabric)
        p("Reborn_WhisTabard",Vector3.new(.99,4.80,.17),0,4.25,-.64,black,0,0,0,nil,Enum.Material.Fabric)
        for side=-1,1,2 do
            p("Reborn_WhisTabardEdge_"..side,Vector3.new(.08,4.80,.075),side*.51,4.25,-.76,ivory)
            p("Reborn_WhisShoulder_"..side,Vector3.new(.95,.78,1.08),side*1.15,6.37,0,burgundy,0,0,side*-11,"Ball",Enum.Material.Fabric)
            local armX=if side==-1 then -1.55 else 1.42
            p("Reborn_WhisUpperSleeve_"..side,Vector3.new(.70,1.48,.80),side*1.24,5.73,0,rose,0,0,side*9,"Ball",Enum.Material.Fabric)
            p("Reborn_WhisLowerSleeve_"..side,Vector3.new(.65,1.35,.75),armX,4.50,-.05,burgundy,0,0,side*11,"Ball",Enum.Material.Fabric)
            p("AngelCuff_"..side,Vector3.new(.77,.40,.87),armX,3.99,-.05,ivory,0,0,side*11,nil,Enum.Material.Fabric)
            p("Reborn_WhisCuffTrim_"..side,Vector3.new(.80,.10,.89),armX,3.81,-.05,orange,0,0,side*11)
            p("Reborn_WhisHand_"..side,Vector3.new(.52,.55,.59),armX,3.57,-.08,skin,0,0,side*8,"Ball")
            p("Reborn_WhisThumb_"..side,Vector3.new(.15,.29,.20),armX-side*.25,3.60,-.15,skin,0,0,side*22,"Ball")
            p("Reborn_WhisRobeSide_"..side,Vector3.new(.28,3.18,1.05),side*.91,2.88,.05,wine,0,0,-side*10,nil,Enum.Material.Fabric)
            p("Reborn_WhisRobePanel_"..side,Vector3.new(1.03,3.26,.27),side*.65,2.68,.47,burgundy,-3,0,side*10,nil,Enum.Material.Fabric)
            p("Reborn_WhisRobeFront_"..side,Vector3.new(.55,3.16,.23),side*.80,2.69,-.41,rose,0,0,-side*8,nil,Enum.Material.Fabric)
            p("Reborn_WhisHem_"..side,Vector3.new(.95,.17,.24),side*.86,1.11,.49,ivory,0,0,side*10)
            p("Reborn_WhisTrouser_"..side,Vector3.new(.79,1.53,.82),side*.46,1.20,0,black,0,0,0,"Ball",Enum.Material.Fabric)
            p("Reborn_WhisShoe_"..side,Vector3.new(.87,.51,1.23),side*.46,.65,-.20,ivory,0,0,0,"Ball")
            p("Reborn_WhisSole_"..side,Vector3.new(.87,.13,1.21),side*.46,.42,-.18,black)
        end
        p("AngelicSash",Vector3.new(2.16,.30,1.28),0,4.18,0,orange,0,0,0,nil,Enum.Material.Fabric)
        -- Signature diamond pattern: crisp geometric embroidery, not neon.
        for i=1,5 do
            p("DiamondRobe_"..i,Vector3.new(.37,.37,.075),0,6.39-i*.54,-.77,
                if i%2==0 then orange else ivory,0,0,45,nil,Enum.Material.Fabric)
            if i%2==1 then
                p("Reborn_WhisDiamondInset_"..i,Vector3.new(.17,.17,.08),0,6.39-i*.54,-.815,orange,0,0,45)
            end
        end
        -- Neck ring: smooth circular cyan band and restrained bright rim.
        halo(npc,"NeckRingPremium",cf,Vector3.new(0,7.04,0),1.64,blue,32,.24,"Horizontal")
        halo(npc,"Reborn_WhisRingRim",cf,Vector3.new(0,7.11,0),1.64,cyan,32,.085,"Horizontal")
        -- Angel staff with dark floating orb, pale rings, metallic handle.
        local sx,sz=-2.29,-.17
        p("Reborn_WhisStaffShaft",Vector3.new(.18,8.05,.18),sx,4.47,sz,C.Steel,0,0,0,nil,Enum.Material.Metal)
        p("Reborn_WhisStaffGrip",Vector3.new(.24,.81,.24),sx,3.62,sz,black,0,0,0,nil,Enum.Material.Leather)
        p("Reborn_WhisStaffFoot",Vector3.new(.27,.29,.27),sx,.49,sz,orange,0,0,0,"Ball",Enum.Material.Metal)
        p("Reborn_WhisStaffCrown",Vector3.new(.33,.54,.33),sx,8.67,sz,orange,0,0,0,nil,Enum.Material.Metal)
        p("Reborn_WhisStaffOrb",Vector3.new(.83,.83,.83),sx,9.51,sz,black,0,0,0,"Ball",Enum.Material.Glass)
        local core=p("StaffSunCore",Vector3.new(.24,.24,.24),sx,9.51,sz-.40,cyan,0,0,0,"Ball",Enum.Material.Neon)
        halo(npc,"Reborn_WhisStaffOrbit",cf,Vector3.new(sx,9.51,sz),.77,ivory,20,.105)
        local lamp=Instance.new("PointLight")
        lamp.Name="Reborn_WhisSoftLight";lamp.Color=cyan;lamp.Range=6;lamp.Brightness=.22
        lamp.Shadows=false;lamp.Parent=core
        npc:SetAttribute("CharacterReborn","Whis-v1")
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
        -- Character Reborn: shadow monarch. Keep the station's static model
        -- contract and head pivot; replace blockout visuals with fitted forms.
        local ink=Color3.fromRGB(12,15,23)
        local cloth=Color3.fromRGB(25,31,44)
        local seam=Color3.fromRGB(49,57,78)
        local violet=Color3.fromRGB(126,75,238)
        local lilac=Color3.fromRGB(190,153,255)
        local skin=Color3.fromRGB(232,201,181)
        local hair=Color3.fromRGB(13,18,31)
        local hairLight=Color3.fromRGB(34,43,65)
        local function p(name: string,size: Vector3,x: number,y: number,z: number,
            col: Color3,rx: number?,ry: number?,rz: number?,shape: string?,mat: Enum.Material?,alpha: number?)
            return add(npc,name,size,cf,x,y,z,col,mat or Enum.Material.SmoothPlastic,
                Vector3.new(rx or 0,ry or 0,rz or 0),shape,alpha)
        end
        for _,obj in ipairs(npc:GetChildren()) do
            if obj:IsA("BasePart") and obj.Name~="Head" then obj.Transparency=1 end
        end
        local head=npc:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            head.Size=Vector3.new(1.47,1.65,1.35);head.Color=skin
            local mesh=Instance.new("SpecialMesh")
            mesh.Name="Reborn_ShadowHead";mesh.MeshType=Enum.MeshType.Head;mesh.Parent=head
            local face=Instance.new("SurfaceGui")
            face.Name="Reborn_ShadowFace";face.Face=Enum.NormalId.Front
            face.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;face.PixelsPerStud=150
            face.LightInfluence=.15;face.Parent=head
            local canvas=Instance.new("Frame")
            canvas.Size=UDim2.fromScale(1,1);canvas.BackgroundTransparency=1;canvas.Parent=face
            local function mark(n: string,x: number,y: number,w: number,h: number,col: Color3,angle: number)
                local f=Instance.new("Frame");f.Name=n;f.Position=UDim2.fromScale(x,y)
                f.Size=UDim2.fromScale(w,h);f.BackgroundColor3=col;f.BorderSizePixel=0
                f.Rotation=angle;f.Parent=canvas
                local round=Instance.new("UICorner");round.CornerRadius=UDim.new(.22,0);round.Parent=f
            end
            for side=-1,1,2 do
                local x=if side==-1 then .17 else .57
                local tilt=if side==-1 then 11 else -11
                mark("EyeOutline_"..side,x,.40,.25,.13,ink,tilt)
                mark("EyeWhite_"..side,x+.018,.423,.214,.079,C.White,tilt)
                mark("VioletIris_"..side,x+.087,.407,.08,.105,violet,0)
                mark("Pupil_"..side,x+.113,.415,.027,.09,ink,0)
                mark("EyeGlint_"..side,x+.091,.419,.025,.022,lilac,0)
                mark("Brow_"..side,x-.008,.321,.26,.047,hair,tilt)
            end
            mark("Nose",.489,.54,.031,.12,Color3.fromRGB(190,146,129),-8)
            mark("Mouth",.422,.735,.156,.023,Color3.fromRGB(96,63,63),0)
        end
        p("Reborn_HairBase",Vector3.new(1.60,.73,1.45),0,8.65,.06,hair,0,0,0,"Ball")
        p("Reborn_HairCrown",Vector3.new(1.64,.72,1.40),0,8.86,.02,hair,0,0,0,"Ball")
        for i=-3,3 do
            p("Reborn_Fringe_"..i,Vector3.new(.34,.92-math.abs(i)*.05,.49),
                i*.205,8.64+math.abs(i)*.045,-.56,if i%2==0 then hairLight else hair,
                -12,0,-18-i*10,"Wedge")
            p("Reborn_CrownLock_"..i,Vector3.new(.29,.66,.68),i*.21,9.01,.06,hairLight,-28,0,-i*12,"Wedge")
        end
        for side=-1,1,2 do
            p("Reborn_Temple_"..side,Vector3.new(.28,.65,.59),side*.68,8.23,.03,hair,0,0,side*10,"Wedge")
            p("Reborn_Ear_"..side,Vector3.new(.18,.34,.30),side*.73,7.95,.02,skin,0,0,0,"Ball")
        end
        p("Reborn_Neck",Vector3.new(.67,.73,.72),0,7.02,0,skin,0,0,0,"Ball")
        p("Reborn_Torso",Vector3.new(2.13,2.85,1.20),0,5.35,0,ink,0,0,0,nil,Enum.Material.Fabric)
        p("Reborn_Shirt",Vector3.new(1.09,2.22,.16),0,5.40,-.65,cloth,0,0,0,nil,Enum.Material.Fabric)
        p("Reborn_CollarBack",Vector3.new(1.39,.55,.30),0,6.72,.35,cloth,-10,0,0,nil,Enum.Material.Fabric)
        for side=-1,1,2 do
            p("Reborn_CoatFront_"..side,Vector3.new(.72,2.45,.24),side*.70,5.25,-.52,cloth,0,side*9,side*4,nil,Enum.Material.Fabric)
            p("Reborn_Lapel_"..side,Vector3.new(.37,1.64,.20),side*.44,5.86,-.72,seam,0,0,side*16,nil,Enum.Material.Fabric)
            p("ObsidianPauldron_"..side,Vector3.new(1.10,.66,1.20),side*1.42,6.36,0,cloth,0,0,side*-11,"Ball",Enum.Material.Fabric)
            p("Reborn_SleeveUpper_"..side,Vector3.new(.76,1.53,.84),side*1.52,5.70,0,ink,0,0,side*7,"Ball",Enum.Material.Fabric)
            p("Reborn_SleeveLower_"..side,Vector3.new(.69,1.37,.77),side*1.65,4.47,-.03,cloth,0,0,side*4,"Ball",Enum.Material.Fabric)
            p("Reborn_Cuff_"..side,Vector3.new(.73,.18,.80),side*1.70,3.87,-.03,seam)
            p("Reborn_Glove_"..side,Vector3.new(.65,.62,.72),side*1.72,3.48,-.10,ink,0,0,0,"Ball",Enum.Material.Leather)
            for i=1,3 do
                p("Reborn_GloveSeam_"..side.."_"..i,Vector3.new(.045,.23,.05),side*1.72+(i-2)*.14,3.48,-.45,seam)
            end
            p("Reborn_CoatSide_"..side,Vector3.new(.23,3.35,.99),side*.97,3.79,.03,ink,0,0,side*5,nil,Enum.Material.Fabric)
            p("Reborn_CoatTail_"..side,Vector3.new(1.03,3.52,.23),side*.61,3.23,.67,cloth,-12,0,side*9,nil,Enum.Material.Fabric)
            p("Reborn_TailLining_"..side,Vector3.new(.90,3.40,.12),side*.61,3.23,.51,ink,-12,0,side*9,nil,Enum.Material.Fabric)
            p("HunterCoatEdge_"..side,Vector3.new(.07,3.42,.10),side*.99,3.23,.78,seam,-12,0,side*9)
            p("Reborn_Thigh_"..side,Vector3.new(.89,1.65,.92),side*.58,2.88,0,ink,0,0,0,"Ball",Enum.Material.Fabric)
            p("Reborn_Shin_"..side,Vector3.new(.80,1.59,.85),side*.58,1.56,0,cloth,0,0,0,"Ball",Enum.Material.Fabric)
            p("Reborn_Boot_"..side,Vector3.new(.88,.66,1.29),side*.58,.66,-.17,ink,0,0,0,"Ball",Enum.Material.Leather)
            p("Reborn_BootSole_"..side,Vector3.new(.89,.14,1.26),side*.58,.37,-.16,seam)
            -- Twin spectral daggers, purely cosmetic. Each blade has a
            -- continuous silhouette with a contrasting luminous edge.
            local daggerCF=cf*CFrame.new(side*1.77,3.25,-.31)*CFrame.Angles(math.rad(-8),0,math.rad(side*15))
            local function blade(name: string,size: Vector3,x: number,y: number,z: number,col: Color3,shape: string?,mat: Enum.Material?,angle: number?)
                return add(npc,"Reborn_Dagger_"..side.."_"..name,size,daggerCF,x,y,z,col,mat,Vector3.new(0,0,angle or 0),shape)
            end
            blade("Grip",Vector3.new(.24,.61,.25),0,.18,0,ink,nil,Enum.Material.Leather)
            blade("Pommel",Vector3.new(.32,.18,.29),0,.52,0,seam,"Ball",Enum.Material.Metal)
            blade("Guard",Vector3.new(.66,.14,.30),0,-.15,0,seam,nil,Enum.Material.Metal)
            blade("Core",Vector3.new(.38,1.32,.19),0,-.85,0,Color3.fromRGB(49,27,96),"Wedge",Enum.Material.Metal,180)
            blade("Edge",Vector3.new(.12,1.22,.12),side*.13,-.82,-.07,violet,"Wedge",Enum.Material.Neon,180)
            blade("Tip",Vector3.new(.20,.48,.15),-side*.06,-1.55,0,lilac,"Wedge",Enum.Material.Neon,180)
            -- Sparse shadow wisps, no physics or attack behavior.
            p("SpectralFlare_"..side,Vector3.new(.21,1.17,.29),side*2.34,5.95,.32,violet,0,0,side*24,"Wedge",Enum.Material.Neon,.27)
            p("Reborn_ShadowWisp_"..side,Vector3.new(.38,1.46,.37),side*2.05,2.17,.63,violet,0,0,side*19,"Wedge",Enum.Material.Neon,.54)
        end
        p("Reborn_Belt",Vector3.new(1.83,.21,1.08),0,4.03,0,ink,0,0,0,nil,Enum.Material.Leather)
        p("Reborn_Buckle",Vector3.new(.35,.26,.13),0,4.03,-.62,C.Steel,0,0,0,nil,Enum.Material.Metal)
        p("ShadowChestClasp",Vector3.new(.22,.25,.12),0,5.92,-.78,violet,0,0,45,nil,Enum.Material.Neon)
        halo(npc,"HunterCircle",cf,Vector3.new(0,.27,0),2.79,violet,20,.055,"Horizontal")
        npc:SetAttribute("CharacterReborn","Jinwoo-v1")
    elseif kind=="Index" then
        -- Character Reborn: Dante. Retain station identity and original
        -- head pivot; replace the old rectangular mannequin cosmetically.
        local red=Color3.fromRGB(153,25,43)
        local wine=Color3.fromRGB(71,18,30)
        local worn=Color3.fromRGB(193,49,58)
        local ink=Color3.fromRGB(24,25,32)
        local charcoal=Color3.fromRGB(43,45,54)
        local steel=Color3.fromRGB(146,158,177)
        local silver=Color3.fromRGB(224,230,238)
        local hairShade=Color3.fromRGB(163,173,190)
        local skin=Color3.fromRGB(236,201,174)
        local function p(n: string,s: Vector3,x: number,y: number,z: number,col: Color3,
            rx: number?,ry: number?,rz: number?,shape: string?,mat: Enum.Material?)
            return add(npc,n,s,cf,x,y,z,col,mat or Enum.Material.SmoothPlastic,
                Vector3.new(rx or 0,ry or 0,rz or 0),shape)
        end
        for _,obj in ipairs(npc:GetChildren()) do
            if obj:IsA("BasePart") and obj.Name~="Head" then obj.Transparency=1 end
        end
        local head=npc:FindFirstChild("Head")
        if head and head:IsA("BasePart") then
            head.Size=Vector3.new(1.54,1.66,1.38);head.Color=skin
            local mesh=Instance.new("SpecialMesh")
            mesh.Name="Reborn_DanteHead";mesh.MeshType=Enum.MeshType.Head;mesh.Parent=head
            local face=Instance.new("SurfaceGui")
            face.Name="Reborn_DanteFace";face.Face=Enum.NormalId.Front
            face.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
            face.PixelsPerStud=160;face.LightInfluence=.16;face.Parent=head
            local canvas=Instance.new("Frame")
            canvas.Size=UDim2.fromScale(1,1);canvas.BackgroundTransparency=1;canvas.Parent=face
            local function mark(n: string,x: number,y: number,w: number,h: number,col: Color3,rot: number)
                local f=Instance.new("Frame")
                f.Name=n;f.Position=UDim2.fromScale(x,y);f.Size=UDim2.fromScale(w,h)
                f.BackgroundColor3=col;f.BorderSizePixel=0;f.Rotation=rot;f.Parent=canvas
                local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(.25,0);corner.Parent=f
            end
            for side=-1,1,2 do
                local x=if side==-1 then .17 else .57
                local tilt=if side==-1 then 8 else -5
                mark("EyeOutline_"..side,x,.39,.25,.145,ink,tilt)
                mark("EyeWhite_"..side,x+.018,.415,.214,.092,C.White,tilt)
                mark("BlueIris_"..side,x+.085,.397,.08,.128,Color3.fromRGB(85,151,190),0)
                mark("Pupil_"..side,x+.113,.408,.027,.105,ink,0)
                mark("EyeGlint_"..side,x+.09,.414,.025,.025,silver,0)
                mark("Brow_"..side,x-.005,.315,.25,.048,hairShade,tilt)
            end
            mark("NoseShadow",.49,.53,.032,.127,Color3.fromRGB(185,141,124),-8)
            mark("Smirk",.405,.735,.20,.025,Color3.fromRGB(101,58,53),-10)
            mark("SmirkCorner",.584,.713,.035,.045,Color3.fromRGB(101,58,53),-14)
            -- Subtle stubble, rather than the clean-shaven Vergil expression.
            for i=1,7 do
                mark("Stubble_"..i,.30+i*.045,.81+math.abs(i-4)*-.012,.012,.023,Color3.fromRGB(157,142,137),0)
            end
        end
        p("Reborn_DanteHairBase",Vector3.new(1.69,.77,1.47),0,8.69,.06,hairShade,0,0,0,"Ball")
        p("Reborn_DanteHairCrown",Vector3.new(1.68,.65,1.40),0,8.91,.01,silver,0,0,0,"Ball")
        for i=1,7 do
            local x=-.79+i*.20
            p("DanteBangs_"..i,Vector3.new(.34,.98-(i%3)*.10,.48),x,8.64+(i%2)*.10,-.58,
                if i%2==0 then silver else Color3.fromRGB(199,210,225),-12,0,24-i*5,"Wedge")
            p("Reborn_DanteCrownLock_"..i,Vector3.new(.29,.62,.61),x,9.00,.13,silver,-29,0,24-i*5,"Wedge")
            p("Reborn_DanteBackLock_"..i,Vector3.new(.28,.80,.50),x,8.48,.56,hairShade,18,0,-12+i*4,"Wedge")
        end
        for side=-1,1,2 do
            p("Reborn_DanteTemple_"..side,Vector3.new(.32,.79,.57),side*.68,8.20,.02,silver,0,0,side*10,"Wedge")
            p("Reborn_DanteEar_"..side,Vector3.new(.18,.33,.29),side*.77,7.98,.02,skin,0,0,0,"Ball")
        end
        p("Reborn_DanteNeck",Vector3.new(.70,.73,.77),0,7.03,0,skin,0,0,0,"Ball")
        p("Reborn_DanteTorso",Vector3.new(2.24,2.74,1.25),0,5.39,0,ink,0,0,0,nil,Enum.Material.Fabric)
        p("Reborn_DanteShirt",Vector3.new(1.40,2.29,.18),0,5.38,-.66,charcoal,0,0,0,nil,Enum.Material.Fabric)
        p("Reborn_DanteCollarBack",Vector3.new(1.55,.53,.28),0,6.79,.35,wine,-12,0,0,nil,Enum.Material.Leather)
        for side=-1,1,2 do
            local collarName=if side==-1 then "DanteCollarL" else "DanteCollarR"
            p(collarName,Vector3.new(.47,1.26,.27),side*.62,6.16,-.78,worn,0,0,side*22,nil,Enum.Material.Leather)
            p("Reborn_DanteCoatFront_"..side,Vector3.new(.74,2.52,.23),side*.78,5.30,-.54,red,0,side*9,side*5,nil,Enum.Material.Leather)
            p("Reborn_DanteLapelEdge_"..side,Vector3.new(.065,1.30,.10),side*.45,6.16,-.94,wine,0,0,side*22)
            p("Reborn_DanteShoulder_"..side,Vector3.new(1.04,.73,1.19),side*1.43,6.36,.02,red,0,0,side*-12,"Ball",Enum.Material.Leather)
            local reach=if side==1 then 1.77 else 1.61
            p("Reborn_DanteUpperSleeve_"..side,Vector3.new(.84,1.49,.91),side*1.53,5.67,0,red,0,0,side*10,"Ball",Enum.Material.Leather)
            p("Reborn_DanteLowerSleeve_"..side,Vector3.new(.77,1.37,.85),side*reach,4.50,-.10,wine,if side==1 then -16 else 0,0,side*8,"Ball",Enum.Material.Leather)
            p("Reborn_DanteCuff_"..side,Vector3.new(.79,.22,.88),side*reach,3.91,-.22,ink,0,0,side*6)
            p("Reborn_DanteGlove_"..side,Vector3.new(.69,.61,.74),side*reach,3.53,-.26,charcoal,0,0,side*6,"Ball",Enum.Material.Leather)
            for i=1,3 do
                p("Reborn_DanteGloveSeam_"..side.."_"..i,Vector3.new(.045,.22,.055),side*reach+(i-2)*.15,3.53,-.61,steel)
            end
            p("Reborn_DanteCoatSide_"..side,Vector3.new(.24,3.17,1.04),side*1.02,3.84,.04,red,0,0,side*6,nil,Enum.Material.Leather)
            p("Reborn_DanteTail_"..side,Vector3.new(1.16,3.43,.24),side*.68,3.20,.66,red,-14,0,side*10,nil,Enum.Material.Leather)
            p("Reborn_DanteTailLining_"..side,Vector3.new(1.02,3.27,.12),side*.68,3.20,.51,wine,-14,0,side*10,nil,Enum.Material.Fabric)
            p("Reborn_DanteTailSeam_"..side,Vector3.new(.075,3.25,.10),side*1.12,3.20,.82,worn,-14,0,side*10)
            p("Reborn_DantePocket_"..side,Vector3.new(.49,.36,.16),side*.87,4.57,-.72,wine,0,0,side*8,nil,Enum.Material.Leather)
            p("Reborn_DanteThigh_"..side,Vector3.new(.92,1.63,.96),side*.60,2.88,0,ink,0,0,side*4,"Ball",Enum.Material.Fabric)
            p("Reborn_DanteShin_"..side,Vector3.new(.86,1.51,.90),side*.67,1.57,0,charcoal,0,0,side*2,"Ball",Enum.Material.Leather)
            p("Reborn_DanteBoot_"..side,Vector3.new(.96,.69,1.34),side*.68,.68,-.19,ink,0,0,0,"Ball",Enum.Material.Leather)
            p("Reborn_DanteSole_"..side,Vector3.new(.97,.14,1.29),side*.68,.38,-.18,charcoal)
            for i=1,3 do
                p("Reborn_DanteBootLace_"..side.."_"..i,Vector3.new(.34,.06,.075),side*.67,1.28-i*.17,-.45,steel,0,0,if i%2==0 then 11 else -11)
            end
        end
        for i=1,4 do
            p("DanteCoatButton_"..i,Vector3.new(.14,.14,.09),.80,5.83-i*.36,-.75,steel,0,0,0,"Ball",Enum.Material.Metal)
        end
        p("Reborn_DanteBelt",Vector3.new(1.90,.24,1.12),0,4.03,0,ink,0,0,0,nil,Enum.Material.Leather)
        p("DanteSilverBuckle",Vector3.new(.40,.29,.15),0,4.03,-.65,silver,0,0,0,nil,Enum.Material.Metal)
        p("Reborn_DanteBuckleInset",Vector3.new(.27,.16,.06),0,4.03,-.75,charcoal)
        -- Large sword carried diagonally on the back. A single local
        -- coordinate frame keeps blade, guard and wrapped grip aligned.
        local swordCF=cf*CFrame.new(.30,5.10,.99)*CFrame.Angles(0,0,math.rad(-27))
        local function sword(n: string,s: Vector3,x: number,y: number,z: number,col: Color3,
            shape: string?,mat: Enum.Material?,angle: number?)
            return add(npc,n,s,swordCF,x,y,z,col,mat,Vector3.new(0,0,angle or 0),shape)
        end
        sword("Reborn_DanteBladeCore",Vector3.new(.79,3.71,.24),0,-.80,0,steel,nil,Enum.Material.Metal)
        sword("GreatbladeBackRidge",Vector3.new(.22,3.69,.14),0,-.80,.14,charcoal,nil,Enum.Material.Metal)
        for side=-1,1,2 do
            sword("Reborn_DanteBladeEdge_"..side,Vector3.new(.15,3.56,.18),side*.43,-.80,0,silver,nil,Enum.Material.Metal)
            sword("Reborn_DanteGuardHorn_"..side,Vector3.new(.38,.70,.35),side*.67,1.13,0,steel,"Wedge",Enum.Material.Metal,side*35)
        end
        sword("Reborn_DanteBladeTip",Vector3.new(.86,.78,.24),0,-2.98,0,silver,"Wedge",Enum.Material.Metal,180)
        sword("Reborn_DanteSwordGuard",Vector3.new(1.26,.27,.39),0,1.16,0,steel,nil,Enum.Material.Metal)
        sword("Reborn_DanteSwordGrip",Vector3.new(.28,1.02,.29),0,1.80,0,ink,nil,Enum.Material.Leather)
        for i=1,5 do
            sword("Reborn_DanteGripWrap_"..i,Vector3.new(.32,.10,.32),0,1.36+i*.15,0,charcoal,nil,Enum.Material.Fabric,15)
        end
        sword("SwordPommel",Vector3.new(.43,.31,.38),0,2.43,0,steel,"Ball",Enum.Material.Metal)
        npc:SetAttribute("CharacterReborn","Dante-v1")
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
