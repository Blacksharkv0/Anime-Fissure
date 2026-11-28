--!strict
-- ANIME FISSURE | Babylon Hall Builder v1.0
-- Permanent, additive right-side LOBBY ANNEX for the Master of Relics.
-- Installs a royal gold/onyx hall, static king NPC concept, 11 Gate-style
-- weapon portals (original geek-inspired silhouettes), 5 true 3D ring
-- showcases and a READ-ONLY ProximityPrompt to open the catalog.
-- Does NOT change spawn, arena entry, towers, loot, summoning or inventory.
-- The hall is an original Roblox Parts interpretation, NOT imported IP meshes.
local RS=game:GetService("ReplicatedStorage")
local RingModelBuilder=require(RS:WaitForChild("Shared"):WaitForChild("RelicRingModelBuilder"))
local RingConfig=require(RS:WaitForChild("Shared"):WaitForChild("RelicRingConfig"))
local NPCArt=require(RS:WaitForChild("Shared"):WaitForChild("LobbyNPCArtFinish"))

local Hall={}
Hall.Version="1.1.0"
Hall.Center=Vector3.new(347,0,19)
Hall.NPCCenter=Vector3.new(355,0,20)
Hall.PortalCount=11
Hall.RingCount=5

local COLOR={
    Onyx=Color3.fromRGB(15,17,27),Stone=Color3.fromRGB(29,30,44),
    Tile=Color3.fromRGB(35,36,53),Gold=Color3.fromRGB(232,181,65),
    GoldLight=Color3.fromRGB(255,225,143),Antique=Color3.fromRGB(125,86,39),
    Ruby=Color3.fromRGB(188,40,68),Wine=Color3.fromRGB(93,23,47),
    Midnight=Color3.fromRGB(19,28,53),Silver=Color3.fromRGB(187,202,220),
    Azure=Color3.fromRGB(78,186,255),Violet=Color3.fromRGB(150,84,241),
}
local function newModel(parent: Instance,name: string): Model
    local m=Instance.new("Model");m.Name=name;m.Parent=parent
    return m
end
local function block(parent: Instance,name: string,size: Vector3,cf: CFrame,
    col: Color3,mat: Enum.Material?,solid: boolean?,alpha: number?): BasePart
    local p=Instance.new("Part")
    p.Name=name;p.Size=size;p.CFrame=cf;p.Color=col
    p.Material=mat or Enum.Material.Metal
    p.Transparency=alpha or 0
    p.Anchored=true;p.CanCollide=solid==true
    p.CanTouch=false;p.CanQuery=solid==true
    p.CastShadow=(mat~=Enum.Material.Neon)
    p.Parent=parent
    return p
end
local function sphere(parent: Instance,name: string,size: Vector3,
    center: Vector3,col: Color3,mat: Enum.Material?,alpha: number?)
    local p=block(parent,name,size,CFrame.new(center),col,mat,false,alpha)
    p.Shape=Enum.PartType.Ball
    return p
end
local function beam(parent: Instance,name: string,a: Vector3,b: Vector3,
    width: number,col: Color3,mat: Enum.Material?)
    local delta=b-a
    if delta.Magnitude<0.02 then return nil end
    return block(parent,name,Vector3.new(width,width,delta.Magnitude),
        CFrame.lookAt((a+b)/2,b),col,mat,false)
end
local function loop(parent: Instance,prefix: string,c: Vector3,r: number,
    col: Color3,width: number,segments: number,frontX: number)
    -- Rings lie in Y/Z plane, readable from the lobby to the WEST (-X).
    for i=1,segments do
        local a=math.pi*2*(i-1)/segments
        local b=math.pi*2*i/segments
        beam(parent,prefix..i,
            Vector3.new(frontX,c.Y+math.cos(a)*r,c.Z+math.sin(a)*r),
            Vector3.new(frontX,c.Y+math.cos(b)*r,c.Z+math.sin(b)*r),
            width,col,Enum.Material.Neon)
    end
end
local function sign(parent: Instance,name: string,at: Vector3,
    headline: string,description: string,col: Color3,width: number?)
    local root=block(parent,name.."Anchor",Vector3.new(0.2,0.2,0.2),
        CFrame.new(at),col,nil,false,1)
    local board=Instance.new("BillboardGui")
    board.Name=name;board.Adornee=root
    board.Size=UDim2.new(math.clamp((width or 240)/58,3.4,6),0,1.15,0)
    board.StudsOffsetWorldSpace=Vector3.new(0,0,0)
    board.MaxDistance=24;board.AlwaysOnTop=false
    board:SetAttribute("CityLocalSign",true)
    board.Parent=root
    local bg=Instance.new("Frame")
    bg.Size=UDim2.fromScale(1,1)
    bg.BackgroundColor3=COLOR.Onyx;bg.BackgroundTransparency=0.48
    bg.BorderSizePixel=0;bg.Parent=board
    local ui=Instance.new("UICorner");ui.CornerRadius=UDim.new(0,7);ui.Parent=bg
    local border=Instance.new("UIStroke")
    border.Color=col;border.Thickness=.8;border.Transparency=.6;border.Parent=bg
    local title=Instance.new("TextLabel")
    title.Name="Title";title.Text=headline
    title.Size=UDim2.new(1,-8,0.55,0);title.Position=UDim2.fromOffset(4,2)
    title.BackgroundTransparency=1;title.TextColor3=col;title.TextScaled=true
    title.Font=Enum.Font.GothamBold;title.Parent=bg
    local sub=Instance.new("TextLabel")
    sub.Name="Subtitle";sub.Text=description
    sub.Size=UDim2.new(1,-8,0.38,0);sub.Position=UDim2.new(0,4,0.58,0)
    sub.BackgroundTransparency=1;sub.TextColor3=Color3.fromRGB(219,222,237)
    sub.TextScaled=true;sub.Font=Enum.Font.Gotham;sub.Parent=bg
    return root
end
local function glow(p: BasePart,col: Color3,radius: number,intensity: number)
    local l=Instance.new("PointLight")
    l.Color=col;l.Range=radius;l.Brightness=intensity;l.Shadows=false
    l.Parent=p
end

-- A weapon in its own local portrait plane X/Y, projected to Y/Z by this cf.
-- ALL designs are original stylised silhouettes with genre homages, not exact
-- copies of protected weapons. Blade always points upward in local Y.
local function makeWeapon(portal: Model,style: string,point: Vector3,shade: Color3)
    local weapon=newModel(portal,"GeekWeapon_"..style)
    weapon:SetAttribute("Style",style)
    local base=CFrame.new(point)*CFrame.Angles(0,math.rad(90),0)
    local function p(name: string,sx: number,sy: number,sz: number,
        lx: number,ly: number,lz: number,color: Color3,
        mat: Enum.Material?, angle: number?)
        return block(weapon,name,Vector3.new(sx,sy,sz),
            base*CFrame.new(lx,ly,lz)*CFrame.Angles(0,0,math.rad(angle or 0)),
            color,mat,false)
    end
    local function localBeam(name: string,x1: number,y1: number,x2: number,y2: number,
        width: number,color: Color3,mat: Enum.Material?)
        local a=(base*CFrame.new(x1,y1,0)).Position
        local b=(base*CFrame.new(x2,y2,0)).Position
        beam(weapon,name,a,b,width,color,mat)
    end
    local silver=COLOR.Silver
    local gilt=COLOR.GoldLight
    local dark=COLOR.Midnight
    if style=="HeroBlade" then
        p("Hilt",0.30,1.05,0.28,0,-1.53,0,dark)
        p("Crossguard",2.25,0.24,0.38,0,-0.75,0,gilt)
        p("EmeraldLongBlade",0.62,3.34,0.30,0,1.06,0,
            Color3.fromRGB(162,234,209),Enum.Material.Metal)
        p("SwordTip",0.48,0.66,0.24,0,2.89,0,
            Color3.fromRGB(227,253,225),Enum.Material.Neon)
        p("CenterCrystal",0.38,0.50,0.40,0,-0.61,-0.08,shade,Enum.Material.Glass)
    elseif style=="TitanGreatblade" then
        p("HeavyGrip",0.52,1.20,0.46,0,-1.75,0,dark)
        p("IndustrialSlab",1.50,3.65,0.40,0,0.88,0,silver,Enum.Material.Metal)
        p("RaisedEdge",0.16,3.50,0.43,-0.67,0.94,-0.06,
            Color3.fromRGB(237,238,235),Enum.Material.Metal)
        p("HeavyGuard",2.12,0.26,0.55,0,-0.83,0,COLOR.Antique)
        p("RuneHole",0.35,0.36,0.47,0.31,1.79,-0.12,
            Color3.fromRGB(43,51,73),Enum.Material.Neon)
    elseif style=="KeyScepter" then
        p("KeyGrip",0.38,2.95,0.34,0,0,0,silver)
        p("KeyHandle",1.47,0.30,0.40,0,-1.52,0,gilt)
        p("KeyHandleR",0.28,0.68,0.35,-0.60,-1.34,0,gilt)
        p("KeyHandleL",0.28,0.68,0.35,0.60,-1.34,0,gilt)
        p("KeyTeethBase",1.39,0.28,0.35,0.57,1.51,0,gilt)
        p("KeyToothA",0.28,0.66,0.35,1.16,1.77,0,gilt)
        p("KeyToothB",0.28,0.47,0.35,0.52,1.66,0,gilt)
        p("KeyBlueGem",0.55,0.42,0.45,0,-1.51,-0.09,shade,Enum.Material.Neon)
    elseif style=="StarSabre" then
        p("Emitter",0.48,1.29,0.45,0,-1.62,0,silver)
        p("EmitterRings",0.69,0.19,0.49,0,-0.96,0,gilt)
        p("PlasmaCore",0.34,3.40,0.24,0,0.91,0,shade,Enum.Material.Neon)
        p("PlasmaHalo",0.64,3.60,0.10,0,0.96,0,shade,Enum.Material.Glass)
    elseif style=="MoonGreatsword" then
        p("MoonGrip",0.35,1.15,0.32,0,-1.57,0,dark)
        p("MoonGuard",1.64,0.24,0.31,0,-0.82,0,gilt)
        p("IceBlade",0.95,3.25,0.28,0,0.97,0,
            Color3.fromRGB(69,161,217),Enum.Material.Glass)
        p("MoonCenter",0.23,2.88,0.31,0,1.13,-0.06,shade,Enum.Material.Neon)
        p("CrescentTop",0.66,0.43,0.29,0,2.79,0,
            Color3.fromRGB(174,242,255),Enum.Material.Neon)
    elseif style=="OniKatana" then
        p("WrappedHilt",0.35,1.29,0.30,0,-1.77,0,dark)
        p("GuardDisc",1.02,0.17,0.42,0,-1.08,0,COLOR.Ruby)
        p("SlenderBlade",0.29,3.86,0.24,0,1.05,0,silver,Enum.Material.Metal)
        p("CrimsonEdge",0.10,3.57,0.27,-0.15,1.02,-0.02,shade,Enum.Material.Neon)
        p("KatanaPoint",0.33,0.29,0.25,-0.06,3.03,0,silver)
    elseif style=="FrostAxe" then
        p("AxeGrip",0.41,4.30,0.35,0,0,0,COLOR.Antique)
        p("IceAxeHead",2.02,1.26,0.48,0.66,1.32,0,
            Color3.fromRGB(110,200,247),Enum.Material.Metal)
        p("AxeFlare",1.14,0.90,0.27,1.49,1.33,-0.05,
            Color3.fromRGB(189,243,255),Enum.Material.Neon)
        p("AxeRune",0.26,0.84,0.42,0.10,1.40,-0.08,shade,Enum.Material.Neon)
    elseif style=="CursedGreatblade" then
        p("CursedHilt",0.39,1.20,0.33,0,-1.69,0,dark)
        p("SpikedGuard",2.18,0.24,0.39,0,-0.87,0,silver)
        p("DarkBlade",1.02,3.76,0.38,0,0.97,0,
            Color3.fromRGB(66,80,110),Enum.Material.Metal)
        p("CursedCore",0.30,2.86,0.35,0,1.20,-0.11,shade,Enum.Material.Neon)
        for side=-1,1,2 do
            p("IceFang"..side,0.34,0.77,0.33,side*0.56,1.61,0,
                silver,Enum.Material.Metal,side*18)
        end
    elseif style=="CelestialSpear" then
        p("SpearShaft",0.33,4.50,0.33,0,-0.24,0,COLOR.Antique)
        p("SpearHead",0.56,1.61,0.38,0,2.13,0,silver,Enum.Material.Metal)
        p("LightSpine",0.13,1.37,0.39,0,2.23,-0.08,shade,Enum.Material.Neon)
        p("SpearWingA",0.77,0.31,0.34,-0.62,1.37,0,gilt,Enum.Material.Metal,-28)
        p("SpearWingB",0.77,0.31,0.34,0.62,1.37,0,gilt,Enum.Material.Metal,28)
    elseif style=="RuneStaff" then
        p("StaffShaft",0.40,4.34,0.37,0,-0.35,0,dark)
        p("StaffHead",1.43,1.40,0.49,0,2.04,0,gilt,Enum.Material.Metal)
        p("ArcaneOrb",0.71,0.70,0.54,0,2.16,-0.15,shade,Enum.Material.Neon)
        for side=-1,1,2 do
            p("StaffProng"..side,0.28,0.82,0.34,side*0.64,2.47,0,gilt)
        end
    elseif style=="DualHookBlades" then
        for side=-1,1,2 do
            p("TwinGrip"..side,0.30,1.11,0.31,side*0.56,-1.65,0,dark)
            p("TwinMetal"..side,0.30,3.36,0.27,side*0.56,0.44,0,silver)
            p("TwinHook"..side,0.73,0.31,0.30,side*0.85,2.19,0,
                shade,Enum.Material.Neon,side*17)
        end
    end
    return weapon
end

type PortalDef={offset: number,height: number,radius: number,style: string,tint: Color3}
local PORTALS: {PortalDef}={
    {offset=-23,height=13.0,radius=2.38,style="HeroBlade",tint=Color3.fromRGB(133,239,183)},
    {offset=-17,height=20.0,radius=3.0,style="TitanGreatblade",tint=Color3.fromRGB(220,235,255)},
    {offset=-12,height=12.3,radius=2.25,style="KeyScepter",tint=Color3.fromRGB(106,190,249)},
    {offset=-7,height=22.3,radius=2.70,style="StarSabre",tint=Color3.fromRGB(113,223,255)},
    {offset=-2,height=15.0,radius=2.45,style="MoonGreatsword",tint=Color3.fromRGB(104,169,251)},
    {offset=4,height=22.6,radius=3.12,style="OniKatana",tint=Color3.fromRGB(255,92,137)},
    {offset=10,height=13.1,radius=2.56,style="FrostAxe",tint=Color3.fromRGB(110,218,255)},
    {offset=15,height=20.6,radius=2.80,style="CursedGreatblade",tint=Color3.fromRGB(124,125,247)},
    {offset=20,height=13.7,radius=2.53,style="CelestialSpear",tint=Color3.fromRGB(232,204,120)},
    {offset=24.2,height=21.4,radius=2.66,style="RuneStaff",tint=Color3.fromRGB(198,127,253)},
    {offset=-25.0,height=24.0,radius=2.06,style="DualHookBlades",tint=Color3.fromRGB(253,182,99)},
}

local function architecture(root: Model)
    local m=newModel(root,"Architecture")
    local c=Hall.Center
    -- RIGHT ANNEX x~317-378; access bridge x305-322, z~19
    -- Keeps Edward x301,z-8 and the AlchemyWorkshop at x293,z4 clear.
    block(m,"AnnexFoundation",Vector3.new(61,3.2,62),
        CFrame.new(c+Vector3.new(0,-1.5,0)),COLOR.Onyx,Enum.Material.Slate,true)
    block(m,"AnnexRoyalFloor",Vector3.new(59,0.18,60),
        CFrame.new(c+Vector3.new(0,0.20,0)),COLOR.Tile,Enum.Material.Marble,true)
    block(m,"BridgeFoundation",Vector3.new(28,1.0,12),
        CFrame.new(Vector3.new(318, -0.43, 20)),COLOR.Onyx,
        Enum.Material.Slate,true)
    block(m,"BridgeGoldPath",Vector3.new(26,0.20,10),
        CFrame.new(Vector3.new(318,0.17,20)),
        COLOR.Antique,Enum.Material.Metal,true)
    -- Floor tiles are purely visual; no extra collision under the player.
    for x=-2,2 do
        for z=-2,2 do
            local base=c+Vector3.new(x*11.0,0.34,z*11.0)
            local tint=if (x+z)%2==0 then COLOR.Stone else COLOR.Tile
            block(m,"OnyxTile_"..x.."_"..z,Vector3.new(10.67,0.12,10.67),
                CFrame.new(base),tint,Enum.Material.Marble)
        end
    end
    -- West entrance split on either side of opening z=20.
    for _,z in ipairs({-1,41}) do
        block(m,"WestWallWing",Vector3.new(2.0,13.0,18),
            CFrame.new(Vector3.new(317.0,6.65,z)),COLOR.Onyx,Enum.Material.Slate,true)
    end
    block(m,"EasternWall",Vector3.new(1.9,21.0,60),
        CFrame.new(Vector3.new(378,10.8,19)),COLOR.Onyx,Enum.Material.Slate,true)
    for _,z in ipairs({-12,50}) do
        block(m,"PerimeterWall",Vector3.new(61,14.3,1.7),
            CFrame.new(Vector3.new(347,7.3,z)),COLOR.Onyx,Enum.Material.Slate,true)
        block(m,"WallGoldRibbon",Vector3.new(58,0.43,0.21),
            CFrame.new(Vector3.new(347,11.8,z+(if z<0 then 1 else -1))),
            COLOR.Gold,Enum.Material.Metal)
    end
    -- Inhabited space: arched entrance with clear 15-stud opening.
    for _,z in ipairs({10,30}) do
        block(m,"EntrancePylon",Vector3.new(2.25,16.4,2.25),
            CFrame.new(Vector3.new(318,8.4,z)),COLOR.Antique,
            Enum.Material.Metal,true)
        block(m,"EntranceRune",Vector3.new(0.30,12.2,0.47),
            CFrame.new(Vector3.new(316.7,8.5,z)),COLOR.GoldLight,Enum.Material.Neon)
    end
    block(m,"GoldenEntranceLintel",Vector3.new(2.6,1.8,24),
        CFrame.new(Vector3.new(318,17.6,20)),COLOR.Gold,Enum.Material.Metal)
    block(m,"ArchRuneSpine",Vector3.new(0.24,0.31,21.1),
        CFrame.new(Vector3.new(316.55,17.9,20)),COLOR.GoldLight,Enum.Material.Neon)
    sign(m,"RoyalHallSign",Vector3.new(314.7,20.6,20),
        "SALAO DA BABILONIA","TESOUROS E RELIQUIAS",COLOR.GoldLight,265)
    -- Royal avenue and inlaid patterns, leaving main walk x320..359, z~20.
    for x=326,366,5 do
        block(m,"RoyalAvenueLine",Vector3.new(2.5,0.06,0.11),
            CFrame.new(Vector3.new(x,0.45,20)),COLOR.GoldLight,Enum.Material.Neon)
    end
    for _,side in ipairs({-1,1}) do
        for i=1,6 do
            local x=325+i*7
            block(m,"RoyalPathBorder",Vector3.new(6.2,0.075,0.16),
                CFrame.new(Vector3.new(x,0.45,20+side*6.0)),
                COLOR.Gold,Enum.Material.Metal)
        end
    end
    -- High ceiling is partial: let players actually see the golden sky of
    -- weapon portals instead of a solid roof hiding the set-piece.
    for _,x in ipairs({325,344,367}) do
        for _,z in ipairs({-7,45}) do
            block(m,"OnyxPillar",Vector3.new(2.6,21,2.6),
                CFrame.new(Vector3.new(x,10.8,z)),COLOR.Stone,
                Enum.Material.Slate,true)
            block(m,"PillarGoldenCrown",Vector3.new(3.7,0.58,3.7),
                CFrame.new(Vector3.new(x,21.4,z)),COLOR.Gold,Enum.Material.Metal)
        end
        block(m,"OpenCeilingTruss",Vector3.new(0.8,1.4,55),
            CFrame.new(Vector3.new(x,21.0,19)),COLOR.Antique,Enum.Material.Metal)
    end
    for _,z in ipairs({-6.7,44.7}) do
        block(m,"UpperRim",Vector3.new(55,0.8,0.8),
            CFrame.new(Vector3.new(349,21.8,z)),COLOR.Gold,Enum.Material.Metal)
    end
    -- Light only near player & center, not one PointLight per portal.
    for _,pos in ipairs({Vector3.new(326,12,-7),
        Vector3.new(326,12,45),Vector3.new(369,15,19)}) do
        local gem=sphere(m,"RoyalLuminance",Vector3.new(0.95,1.20,0.95),
            pos,COLOR.GoldLight,Enum.Material.Neon,0.08)
        glow(gem,COLOR.GoldLight,22,0.9)
    end
    return m
end

local function portalCloud(root: Model)
    local portalFolder=newModel(root,"GateOfBabylonPortals")
    for idx,entry in ipairs(PORTALS) do
        local dz,dy,r,style,tint=entry.offset,entry.height,entry.radius,
            entry.style,entry.tint
        local center=Vector3.new(374.0,dy,19+dz)
        local model=newModel(portalFolder,"Portal_"..string.format("%02d",idx))
        model:SetAttribute("WeaponStyle",style)
        model:SetAttribute("HomageOnly",true)
        model:SetAttribute("Decorative",true)
        local disc=block(model,"GoldenRippleCore",Vector3.new(0.13,r*1.84,r*1.84),
            CFrame.new(center),COLOR.Gold,Enum.Material.Glass,false,0.75)
        disc.Shape=Enum.PartType.Cylinder
        -- Facing west: rings in YZ plane at x=center.X - offsets.
        loop(model,"GoldPortalOuter",center,r,COLOR.GoldLight,0.18,12,center.X-0.20)
        loop(model,"DarkRunicRim",center,r*0.80,COLOR.Antique,0.09,12,center.X-0.35)
        loop(model,"InnerTreasurePulse",center,r*0.57,tint,0.09,12,center.X-0.43)
        makeWeapon(model,style,center+Vector3.new(-1.0,0,0),tint)
        -- Tiny central anchor for future CLIENT-only animation/LOD:
        local anchor=block(model,"PortalAnimationAnchor",Vector3.new(0.08,0.08,0.08),
            CFrame.new(center),tint,nil,false,1)
        model.PrimaryPart=anchor
        model:SetAttribute("PortalIndex",idx)
    end
    return portalFolder
end

local function king(root: Model)
    local folder=newModel(root,"GilgameshNPC")
    folder:SetAttribute("DisplayName","Gilgamesh")
    folder:SetAttribute("Role","Mestre Universal das Reliquias")
    folder:SetAttribute("Prototype","DecorativeStaticNpc")
    folder:SetAttribute("RelicScope","AllWorlds")
    local origin=Vector3.new(356,0.35,20)
    local facing=CFrame.new(origin)*CFrame.Angles(0,math.rad(90),0)
    local function item(n: string,size: Vector3,x: number,y: number,z: number,
        color: Color3,mat: Enum.Material?,solid: boolean?,alpha: number?)
        return block(folder,n,size,facing*CFrame.new(x,y,z),
            color,mat,solid,alpha)
    end
    -- Raised steps with accessible approach from west, no physical barrier
    -- around the prompt and no collision with the character statue.
    block(folder,"SovereignPedestal",Vector3.new(11,0.55,11),
        CFrame.new(origin+Vector3.new(0,0.22,0)),COLOR.Antique,
        Enum.Material.Marble,true)
    block(folder,"SovereignStep",Vector3.new(13,0.23,13),
        CFrame.new(origin+Vector3.new(-3,0.10,0)),COLOR.Stone,
        Enum.Material.Marble,true)
    item("GoldBootL",Vector3.new(1.30,1.2,1.65),-0.93,1.10,-0.4,
        COLOR.Gold,Enum.Material.Metal)
    item("GoldBootR",Vector3.new(1.30,1.2,1.65),0.93,1.10,-0.4,
        COLOR.Gold,Enum.Material.Metal)
    item("RoyalGreavesL",Vector3.new(1.22,2.4,1.12),-0.91,2.63,0,
        COLOR.Gold,Enum.Material.Metal)
    item("RoyalGreavesR",Vector3.new(1.22,2.4,1.12),0.91,2.63,0,
        COLOR.Gold,Enum.Material.Metal)
    item("RoyalWaist",Vector3.new(2.80,0.86,1.42),0,4.13,0,
        COLOR.Gold,Enum.Material.Metal)
    item("UnderArmor",Vector3.new(2.55,3.1,1.33),0,5.65,0,
        COLOR.Midnight,Enum.Material.SmoothPlastic)
    item("GoldBreastplate",Vector3.new(2.84,2.50,1.48),0,5.72,-0.05,
        COLOR.Gold,Enum.Material.Metal)
    item("RubyBreastGem",Vector3.new(0.82,0.67,0.38),0,6.10,-0.87,
        COLOR.Ruby,Enum.Material.Glass)
    for _,side in ipairs({-1,1}) do
        item("RoyalShoulder"..side,Vector3.new(1.92,1.13,1.76),
            side*2.14,6.55,0.06,COLOR.GoldLight,Enum.Material.Metal)
        item("RoyalArm"..side,Vector3.new(0.97,2.85,1.09),
            side*2.15,4.68,0,COLOR.Gold,Enum.Material.Metal)
        item("WristGem"..side,Vector3.new(0.47,0.48,0.37),
            side*2.16,3.52,-0.62,COLOR.Ruby,Enum.Material.Glass)
        item("RoyalHand"..side,Vector3.new(0.85,0.87,0.88),
            side*2.16,2.95,-0.19,
            Color3.fromRGB(241,205,159),Enum.Material.SmoothPlastic)
        item("WineCape"..side,Vector3.new(1.12,4.04,0.18),
            side*0.85,2.47,0.76,COLOR.Wine,Enum.Material.Fabric)
    end
    item("RoyalNeck",Vector3.new(0.94,0.75,0.88),0,7.46,0,
        Color3.fromRGB(239,202,158),Enum.Material.SmoothPlastic)
    local head=item("RegalHead",Vector3.new(1.64,1.72,1.40),0,8.37,-0.12,
        Color3.fromRGB(244,204,161),Enum.Material.SmoothPlastic)
    for _,side in ipairs({-1,1}) do
        item("RubyEye"..side,Vector3.new(0.28,0.25,0.09),
            side*0.40,8.55,-0.87,COLOR.Ruby,Enum.Material.Neon)
        item("SharpBrow"..side,Vector3.new(0.49,0.14,0.12),
            side*0.42,8.87,-0.82,COLOR.Antique,Enum.Material.Metal)
    end
    item("RoyalSmirk",Vector3.new(0.41,0.07,0.08),0,7.98,-0.84,
        Color3.fromRGB(89,44,40),Enum.Material.SmoothPlastic)
    for i=1,7 do
        item("GoldenHairSpike"..i,Vector3.new(0.43,0.71+(i%3)*0.16,0.54),
            -1.13+i*0.28,9.43+(i%2)*0.12,-0.08,
            COLOR.GoldLight,Enum.Material.Metal,false)
    end
    local crown=item("RegalHairCrown",Vector3.new(1.78,0.43,1.33),0,9.22,0.1,
        COLOR.Gold,Enum.Material.Metal)
    folder.PrimaryPart=head
    NPCArt.ApplyGilgamesh(folder,facing)
    -- Interaction collider is an invisible anchor in FRONT of the NPC,
    -- so players do not need to jump onto the display pedestal.
    local promptPart=block(folder,"RelicMasterInteraction",Vector3.new(2,4,2),
        CFrame.new(Vector3.new(350.8,3.2,20)),
        COLOR.Gold,nil,false,1)
    local prompt=Instance.new("ProximityPrompt")
    prompt.Name="BabylonRelicPrompt"
    prompt.ActionText="VER RELIQUIAS"
    prompt.ObjectText="GILGAMESH • RELIQUIAS DE TODOS OS MUNDOS"
    prompt.KeyboardKeyCode=Enum.KeyCode.E
    prompt.GamepadKeyCode=Enum.KeyCode.ButtonX
    prompt.RequiresLineOfSight=false
    prompt.MaxActivationDistance=12
    prompt.HoldDuration=0
    prompt.ClickablePrompt=true
    prompt.Parent=promptPart
    sign(folder,"KingNPCSign",Vector3.new(352.3,12.5,20),
        "GILGAMESH","MESTRE DAS RELIQUIAS",COLOR.GoldLight,235)
    glow(crown,COLOR.GoldLight,12,0.62)
    return folder
end

type Showcase={id: string,x: number,z: number}
local SHOWCASES: {Showcase}={
    {id="MagicPowerRing",x=335,z=-4},
    {id="PhysicalDamageRing",x=348,z=-4},
    {id="SPARing",x=362,z=-4},
    {id="RangeRing",x=340,z=42},
    {id="RestrictionRing",x=358,z=42},
}
local function galleries(root: Model)
    local stands=newModel(root,"RelicShowcases")
    for i,data in ipairs(SHOWCASES) do
        local id,x,z=data.id,data.x,data.z
        local meta=RingConfig.Get(id)
        local model=newModel(stands,"Display_"..id)
        model:SetAttribute("RingId",id)
        block(model,"OnyxRelicPlinth",Vector3.new(4.4,3.3,4.4),
            CFrame.new(Vector3.new(x,1.90,z)),COLOR.Onyx,Enum.Material.Marble,true)
        block(model,"GoldPedestalTrim",Vector3.new(4.8,0.37,4.8),
            CFrame.new(Vector3.new(x,3.63,z)),COLOR.Gold,Enum.Material.Metal)
        local ring=RingModelBuilder.Build(id)
        if ring then
            ring.Name="Ring3D"
            ring.Parent=model
            -- 3D display faces main walkway; ring occupies ~4 studs.
            ring:PivotTo(CFrame.new(x,6.05,z)*
                CFrame.Angles(0,math.rad(if z<0 then 180 else 0),0))
        end
        local crystal=sphere(model,"RelicOrb",Vector3.new(0.60,0.60,0.60),
            Vector3.new(x,4.32,z),meta.GemColor,Enum.Material.Neon,0.08)
        if i==1 or i==5 then glow(crystal,meta.MainColor,11,0.5) end
        sign(model,"ShowcaseLabel",Vector3.new(x,9.3,z),
            meta.Name,if id=="RestrictionRing" then "DANO x2  /  SPA x2"
            elseif id=="SPARing" then "SPA -20%"
            elseif id=="RangeRing" then "RANGE +20%"
            else "DANO +20%",meta.MainColor,190)
    end
    return stands
end

function Hall.Build(lobby: Model): Model
    assert(lobby.Name=="FissureLobby","Only attach to existing FissureLobby")
    local old=lobby:FindFirstChild("BabylonHall")
    if old then old:Destroy() end
    local root=newModel(lobby,"BabylonHall")
    root:SetAttribute("Version",Hall.Version)
    root:SetAttribute("Type","RelicLobbyAnnex")
    root:SetAttribute("NPC","Gilgamesh")
    root:SetAttribute("RelicScope","AllWorlds")
    root:SetAttribute("DecorOnly",true)
    architecture(root)
    portalCloud(root)
    king(root)
    galleries(root)
    root:SetAttribute("PortalCount",Hall.PortalCount)
    root:SetAttribute("RingCount",Hall.RingCount)
    root:SetAttribute("Ready",true)
    return root
end

return Hall
