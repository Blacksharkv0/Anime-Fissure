--!strict
-- ANIME FISSURE | Fissure City 0.3 — architectural masterplan
-- The original floor/spawn/mission portal, station models and remotes remain
-- authoritative. All city overlays are anchored non-colliding cosmetics.
local Workspace=game:GetService("Workspace")
local lobby=Workspace:WaitForChild("FissureLobby",60)
if not lobby or not lobby:IsA("Model") then return end
local floor=lobby:WaitForChild("LobbyFloor",20)
local spawn=lobby:WaitForChild("LobbySpawn",20)
local portal=lobby:WaitForChild("ArenaPortal",20)
if not floor or not floor:IsA("BasePart") or not spawn or not portal then
    warn("[Fissure City] missing original lobby geometry")
    return
end
local O=Vector3.new(260,0,0)
local C={
    Ink=Color3.fromRGB(15,22,39),Stone=Color3.fromRGB(33,44,63),
    Tile=Color3.fromRGB(40,53,74),TileAlt=Color3.fromRGB(45,58,80),
    Path=Color3.fromRGB(70,88,111),Metal=Color3.fromRGB(114,142,172),
    White=Color3.fromRGB(229,241,252),Blue=Color3.fromRGB(56,123,255),
    Cyan=Color3.fromRGB(109,221,255),Gold=Color3.fromRGB(239,190,96),
    Purple=Color3.fromRGB(155,99,246),Green=Color3.fromRGB(137,207,160),
    Red=Color3.fromRGB(225,75,94),Soil=Color3.fromRGB(36,59,59),
}
local function build(): Model
    local root=Instance.new("Model")
    root.Name="FissureCity"
    root:SetAttribute("Version","0.3.0")
    local function group(parent: Instance,name: string): Model
        local m=Instance.new("Model");m.Name=name;m.Parent=parent;return m
    end
    local function p(parent: Instance,name: string,size: Vector3,cf: CFrame,col: Color3,
        mat: Enum.Material?,shape: string?,alpha: number?): Part
        local obj=Instance.new("Part")
        obj.Name=name;obj.Size=size;obj.CFrame=cf;obj.Color=col
        obj.Material=mat or Enum.Material.SmoothPlastic
        if shape=="Cylinder" then obj.Shape=Enum.PartType.Cylinder
        elseif shape=="Ball" then obj.Shape=Enum.PartType.Ball end
        obj.Transparency=alpha or 0
        obj.Anchored=true;obj.CanCollide=false;obj.CanTouch=false;obj.CanQuery=false
        obj.CastShadow=mat~=Enum.Material.Neon
        obj.TopSurface=Enum.SurfaceType.Smooth;obj.BottomSurface=Enum.SurfaceType.Smooth
        obj.Parent=parent;return obj
    end
    local function at(x: number,y: number,z: number): CFrame
        return CFrame.new(O+Vector3.new(x,y,z))
    end
    local function line(parent: Instance,name: string,a: Vector3,b: Vector3,w: number,col: Color3,
        mat: Enum.Material?,height: number?)
        if (b-a).Magnitude<.03 then return end
        return p(parent,name,Vector3.new(w,height or w,(b-a).Magnitude+.025),
            CFrame.lookAt(O+(a+b)*.5,O+b),col,mat)
    end
    local function ring(parent: Instance,name: string,center: Vector3,r: number,segments: number,
        width: number,col: Color3,vertical: boolean?)
        for i=0,segments-1 do
            local a,b=i*2*math.pi/segments,(i+1)*2*math.pi/segments
            local function point(t: number)
                return center+(if vertical then Vector3.new(math.cos(t)*r,math.sin(t)*r,0)
                    else Vector3.new(math.cos(t)*r,0,math.sin(t)*r))
            end
            line(parent,name..i,point(a),point(b),width,col,Enum.Material.Neon)
        end
    end
    local function disc(parent: Instance,name: string,x: number,y: number,z: number,d: number,
        h: number,col: Color3,mat: Enum.Material?)
        return p(parent,name,Vector3.new(h,d,d),at(x,y,z)*CFrame.Angles(0,0,math.pi/2),col,mat,"Cylinder")
    end
    local function lamp(part: BasePart,col: Color3,range: number,brightness: number)
        local l=Instance.new("PointLight");l.Color=col;l.Range=range;l.Brightness=brightness
        l.Shadows=false;l.Parent=part
    end
    local function sign(parent: Instance,name: string,cf: CFrame,w: number,h: number,
        title: string,sub: string,col: Color3)
        local board=p(parent,name,Vector3.new(w,h,.30),cf,C.Ink,Enum.Material.Metal)
        local gui=Instance.new("SurfaceGui")
        gui.Name="CitySign";gui.Face=Enum.NormalId.Front;gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
        gui.PixelsPerStud=40;gui.LightInfluence=0;gui.Parent=board
        local label=Instance.new("TextLabel")
        label.BackgroundTransparency=1;label.Position=UDim2.fromScale(.035,.035)
        label.Size=UDim2.fromScale(.93,.57);label.Text=title;label.TextScaled=true
        label.Font=Enum.Font.GothamBlack;label.TextColor3=C.White;label.Parent=gui
        local detail=Instance.new("TextLabel")
        detail.BackgroundTransparency=1;detail.Position=UDim2.fromScale(.035,.65)
        detail.Size=UDim2.fromScale(.93,.25);detail.Text=sub;detail.TextScaled=true
        detail.Font=Enum.Font.GothamMedium;detail.TextColor3=col;detail.Parent=gui
        return board
    end

    -- Fine modular pavers, deliberately beneath the existing station bases.
    local ground=group(root,"CityPaving")
    for gx=-4,4 do
        for gz=-4,4 do
            p(ground,"Paver_"..gx.."_"..gz,Vector3.new(11.82,.08,11.82),
                at(gx*12,.04,gz*12),if (gx+gz)%2==0 then C.Tile else C.TileAlt,Enum.Material.Slate)
        end
    end
    local function route(name: string,a: Vector3,b: Vector3,width: number,col: Color3)
        local m=group(ground,name)
        local delta=b-a;local mid=(a+b)*.5
        local frame=CFrame.lookAt(O+mid,O+b)
        p(m,"Walkway",Vector3.new(width,.10,delta.Magnitude),frame,C.Path,Enum.Material.Slate)
        for side=-1,1,2 do
            p(m,"RouteEdge_"..side,Vector3.new(.12,.035,delta.Magnitude),
                frame*CFrame.new(side*(width*.5-.18),.075,0),col,Enum.Material.Neon)
        end
        for i=1,math.floor(delta.Magnitude/6) do
            local z=-delta.Magnitude*.5+i*6
            p(m,"Inset_"..i,Vector3.new(1.25,.026,.16),frame*CFrame.new(0,.06,z),col,Enum.Material.Neon)
        end
    end
    route("StoryBoulevard",Vector3.new(0,.14,25),Vector3.new(0,.14,-33),10,C.Cyan)
    route("SummonAvenue",Vector3.new(-5,.14,2),Vector3.new(-27,.14,2),7,C.Blue)
    route("AlchemyAvenue",Vector3.new(5,.14,2),Vector3.new(28,.14,2),7,C.Gold)
    route("TraitsAvenue",Vector3.new(-5,.14,22),Vector3.new(-30,.14,27),6,C.Green)
    route("EvolutionAvenue",Vector3.new(5,.14,22),Vector3.new(30,.14,27),6,C.Cyan)
    route("RaidAvenue",Vector3.new(6,.14,-19),Vector3.new(21,.14,-24),6,C.Purple)
    route("IndexAvenue",Vector3.new(-5,.14,-8),Vector3.new(-13,.14,-8),5,C.Red)
    route("RoyalAvenue",Vector3.new(9,.14,20),Vector3.new(54,.14,20),7,C.Gold)
    route("SeasonalAvenue",Vector3.new(5,.14,8),Vector3.new(10.6,.14,8),5,C.Gold)

    -- Open central plaza and raised emblem overhead: no object in the
    -- spawn-to-Story walking corridor below 12 studs.
    local plaza=group(root,"CentralPlaza")
    disc(plaza,"OnyxMedallion",0,.19,1,20,.06,C.Ink,Enum.Material.Marble)
    ring(plaza,"PlazaOuter",Vector3.new(0,.24,1),10,32,.12,C.Blue)
    ring(plaza,"PlazaInner",Vector3.new(0,.25,1),7.9,28,.08,C.Cyan)
    for i=0,7 do
        local a=i*math.pi/4
        local v=Vector3.new(math.sin(a),0,math.cos(a))
        line(plaza,"CompassInlay"..i,Vector3.new(0,.26,1)+v*8.2,
            Vector3.new(0,.26,1)+v*9.5,.26,C.Gold,Enum.Material.Metal,.035)
    end
    local emblem=group(plaza,"FissureMonument")
    ring(emblem,"HaloOuter",Vector3.new(0,15.5,0),4.1,28,.14,C.Blue,true)
    ring(emblem,"HaloInner",Vector3.new(0,15.5,.16),3.3,24,.09,C.Cyan,true)
    -- Angular stylized F logo formed by three separate strokes.
    for i,v in ipairs({{Vector3.new(-1.5,13.2,-.28),Vector3.new(-.5,17.9,-.28)},
        {Vector3.new(-.55,17.9,-.28),Vector3.new(2.0,17.9,-.28)},
        {Vector3.new(-.95,15.9,-.28),Vector3.new(.95,15.9,-.28)}}) do
        line(emblem,"CrestStroke"..i,v[1],v[2],.54,C.White,Enum.Material.Neon)
    end
    local core=p(emblem,"FissureCore",Vector3.new(.72,1.30,.72),
        at(2.2,14.1,0)*CFrame.Angles(0,0,math.rad(35)),C.Purple,Enum.Material.Neon)
    lamp(core,C.Blue,20,.7)

    -- Spawn frontage: immediately visible from the initial camera facing
    -- the mission portal. Gateway and sign stay above avatar head height.
    local arrival=group(root,"ArrivalGate")
    for side=-1,1,2 do
        p(arrival,"ColumnFoot",Vector3.new(3.5,.60,3.7),at(side*10,.30,17),C.Ink,Enum.Material.Marble)
        p(arrival,"Column",Vector3.new(1.9,11.5,2.2),at(side*10,6.05,17),C.Stone,Enum.Material.Metal)
        p(arrival,"ColumnInset",Vector3.new(.28,9.8,.15),at(side*10,6.1,18.18),C.Blue,Enum.Material.Neon)
        p(arrival,"ColumnCrown",Vector3.new(3.0,.55,3.1),at(side*10,11.9,17),C.Metal,Enum.Material.Metal)
    end
    p(arrival,"GateBeam",Vector3.new(23,1.1,2.8),at(0,13.0,17),C.Ink,Enum.Material.Metal)
    p(arrival,"GateEdge",Vector3.new(22,.13,.12),at(0,13.58,18.44),C.Cyan,Enum.Material.Neon)
    sign(arrival,"WelcomeSign",at(0,14.65,18.55)*CFrame.Angles(0,math.pi,0),19,2.0,
        "ANIME FISSURE","ASCENSION  /  MULTIVERSE CITY",C.Cyan)
    -- Spawn medallion lies visually on the existing platform.
    ring(arrival,"SpawnRing",Vector3.new(0,1.04,25),4.3,24,.09,C.Blue)

    -- Taller architectural portal frame complements the actual Story portal
    -- while leaving its prompt and original location untouched.
    local story=group(root,"StoryCitadel")
    for side=-1,1,2 do
        p(story,"CitadelPillar",Vector3.new(3.4,20,4.2),at(side*11,10,-39.2),C.Ink,Enum.Material.Metal)
        p(story,"CitadelPilaster",Vector3.new(.42,18.6,.20),at(side*11,10,-36.99),C.Cyan,Enum.Material.Neon)
        p(story,"CitadelFoot",Vector3.new(4.4,.9,5),at(side*11,.45,-39.2),C.Stone,Enum.Material.Marble)
        p(story,"CitadelCap",Vector3.new(4.2,1,4.7),at(side*11,20.4,-39.2),C.Metal,Enum.Material.Metal)
    end
    p(story,"CitadelLintel",Vector3.new(26,2.0,4.2),at(0,22,-39.2),C.Ink,Enum.Material.Metal)
    sign(story,"StoryTitle",at(0,22,-36.9)*CFrame.Angles(0,math.pi,0),19,1.55,"STORY","PORTAL DAS FISSURAS",C.Cyan)

    -- Four themed service pavilions and two shop backdrops. Open on all
    -- sides, no walls at the prompt, preserve original station footprints.
    local sectors=group(root,"DistrictArchitecture")
    local districts={
        {Name="Summon",X=-32,Z=-6,Color=C.Blue,Label="SUMMON",Sub="VERGIL",W=14,H=13},
        {Name="Alchemy",X=33,Z=-6,Color=C.Gold,Label="ALQUIMIA",Sub="EDWARD",W=24,H=16},
        {Name="Index",X=-13,Z=-8,Color=C.Red,Label="INDEX",Sub="DANTE",W=12,H=14},
        {Name="Evolution",X=30,Z=33,Color=C.Cyan,Label="EVOLUÇÃO",Sub="WHIS",W=14,H=15},
        {Name="Traits",X=-30,Z=33,Color=C.Green,Label="TRAITS",Sub="URAHARA",W=14,H=14},
        {Name="Raids",X=21,Z=-30,Color=C.Purple,Label="DESAFIOS",Sub="SUNG JINWOO",W=14,H=15},
    }
    for _,d in ipairs(districts) do
        local m=group(sectors,d.Name)
        m:SetAttribute("Accent",d.Color)
        -- Rear-only architecture: keep front and sides open for mobile.
        local back=d.Z+(if d.Name=="Evolution" or d.Name=="Traits" then 8 else -8)
        local orientation=if back>d.Z then 0 else math.pi
        for side=-1,1,2 do
            local x=d.X+side*d.W*.5
            p(m,"Base",Vector3.new(2,.52,2),at(x,.26,back),C.Ink,Enum.Material.Marble)
            p(m,"Column",Vector3.new(1.35,d.H,1.5),at(x,d.H*.5,back),C.Stone,Enum.Material.Metal)
            local glow=p(m,"Accent",Vector3.new(.18,d.H-1.2,.19),at(x,d.H*.5,back),d.Color,Enum.Material.Neon)
            p(m,"ColumnCrown",Vector3.new(2.10,.45,2.1),at(x,d.H,back),C.Metal,Enum.Material.Metal)
            if side==1 then lamp(glow,d.Color,12,.32) end
        end
        p(m,"Cornice",Vector3.new(d.W+2,.78,2.5),at(d.X,d.H+.5,back),C.Ink,Enum.Material.Metal)
        p(m,"CorniceEdge",Vector3.new(d.W+1,.10,.13),at(d.X,d.H+.94,back+(if orientation==0 then -1.29 else 1.29)),d.Color,Enum.Material.Neon)
        sign(m,"DistrictSign",at(d.X,d.H+1.84,back)*CFrame.Angles(0,orientation,0),
            math.min(d.W,17),1.95,d.Label,d.Sub,d.Color)
    end

    -- Rotating seasonal plaza. Its actual event host remains in its own
    -- model at (270.6,0,8), and no active event is created here.
    local season=group(root,"SeasonalCourt")
    ring(season,"SeasonOutline",Vector3.new(10.6,.18,8),6.2,24,.11,C.Gold)
    for side=-1,1,2 do
        local x=10.6+side*6
        p(season,"BannerBase",Vector3.new(1.4,.40,1.4),at(x,.2,12.7),C.Ink,Enum.Material.Metal)
        p(season,"BannerSpire",Vector3.new(.29,8.3,.29),at(x,4.5,12.7),C.Metal,Enum.Material.Metal)
        p(season,"SeasonBanner",Vector3.new(1.65,3.7,.12),at(x,6.4,12.52),C.Ink,Enum.Material.Fabric)
        p(season,"SeasonStripe",Vector3.new(.13,3.35,.07),at(x,6.4,12.42),C.Gold,Enum.Material.Neon)
    end

    -- Royal annex gateway stops at x=54. No railing blocks the existing
    -- Babylon bridge at the east edge, and no geometry enters its hall.
    local royal=group(root,"RoyalEntrance")
    for side=-1,1,2 do
        local z=20+side*7.8
        p(royal,"RoyalColumn",Vector3.new(2.4,13.4,2.4),at(51,6.7,z),C.Ink,Enum.Material.Marble)
        p(royal,"RoyalGoldInlay",Vector3.new(.11,11.5,.22),at(49.74,6.7,z),C.Gold,Enum.Material.Neon)
        p(royal,"RoyalCapital",Vector3.new(3,.65,3),at(51,13.35,z),C.Gold,Enum.Material.Metal)
    end
    p(royal,"RoyalArch",Vector3.new(3,1.0,18),at(51,14.3,20),C.Ink,Enum.Material.Metal)
    sign(royal,"RoyalSign",at(49.3,15.6,20)*CFrame.Angles(0,math.pi/2,0),15,1.8,"BABILÔNIA","GILGAMESH  /  RELÍQUIAS",C.Gold)

    -- Deliberate edge gardens and skyline: no old green balls, no props
    -- on the main routes. Geometric trees and warm architectural lights.
    local gardens=group(root,"EdgeGardens")
    for _,loc in ipairs({{-43,-43},{43,-43},{-43,44},{43,44}}) do
        local x,z=loc[1],loc[2]
        p(gardens,"Planter",Vector3.new(9,.65,9),at(x,.33,z),C.Ink,Enum.Material.Marble)
        p(gardens,"PlanterRim",Vector3.new(8.5,.13,8.5),at(x,.71,z),C.Metal,Enum.Material.Metal)
        p(gardens,"Soil",Vector3.new(7.8,.12,7.8),at(x,.80,z),C.Soil,Enum.Material.Grass)
        for i=1,3 do
            local a=i*2*math.pi/3
            local tx,tz=x+math.cos(a)*2.25,z+math.sin(a)*2.25
            p(gardens,"TreeTrunk",Vector3.new(.32,3.15,.32),at(tx,2.40,tz),Color3.fromRGB(93,80,71),Enum.Material.Wood)
            for j=1,3 do
                local leaf=p(gardens,"LeafLayer",Vector3.new(2.05-j*.19,1.4,2.15-j*.17),
                    at(tx,3.5+j*.47,tz)*CFrame.Angles(0,j*.47,.22),if j%2==0 then C.Green else C.Soil,Enum.Material.SmoothPlastic,"Ball")
            end
        end
        local g=p(gardens,"GardenBeacon",Vector3.new(.55,1.25,.55),at(x,1.45,z)*CFrame.Angles(0,0,.25),C.Cyan,Enum.Material.Neon)
        lamp(g,C.Cyan,9,.30)
    end
    local edges=group(root,"CityEdge")
    for _,side in ipairs({-1,1}) do
        for _,z in ipairs({-45,-30,-15,0,15,30,45}) do
            if side==1 and z>=0 and z<=30 then continue end
            p(edges,"EdgeButtress",Vector3.new(2.1,5.3,2.1),at(side*53,2.65,z),C.Ink,Enum.Material.Metal)
            p(edges,"EdgeCap",Vector3.new(2.3,.24,2.3),at(side*53,5.38,z),C.Blue,Enum.Material.Neon)
        end
        for _,x in ipairs({-45,-30,-15,0,15,30,45}) do
            p(edges,"EdgeButtress",Vector3.new(2.1,5.3,2.1),at(x,2.65,side*53),C.Ink,Enum.Material.Metal)
            p(edges,"EdgeCap",Vector3.new(2.3,.24,2.3),at(x,5.38,side*53),C.Blue,Enum.Material.Neon)
        end
    end
    local skyline=group(root,"Skyline")
    -- Distant scenery built below the platform; does not become a playable
    -- island or a second spawn. Keep east annex sightline unobstructed.
    for i=1,9 do
        local x=-51+(i-1)*12.5
        local h=15+(i*13)%22
        p(skyline,"Tower_"..i,Vector3.new(6,h,7),at(x,h*.5-11,-66-(i%2)*5),C.Stone,Enum.Material.Metal)
        p(skyline,"TowerSpire_"..i,Vector3.new(2.8,4.0,2.8),at(x,h-9,-66-(i%2)*5),C.Ink,Enum.Material.Metal)
        for j=1,3 do
            p(skyline,"TowerWindow",Vector3.new(3.7,.30,.12),at(x,h-12-j*2.4,-62.4-(i%2)*5),C.Blue,Enum.Material.Neon)
        end
    end
    root:SetAttribute("Ready",true)
    return root
end

local ok,result=xpcall(build,debug.traceback)
if not ok then
    warn("[Fissure City] build failed: "..tostring(result))
    lobby:SetAttribute("CityReady",false)
    return
end
local old=lobby:FindFirstChild("FissureCity")
if old then old:Destroy() end
local legacy=lobby:FindFirstChild("AtriumV1")
if legacy then legacy:Destroy() end
-- Retain the original floor object, spawn and portal for existing systems.
floor.Color=C.Stone;floor.Material=Enum.Material.Slate
result.Parent=lobby
lobby:SetAttribute("CityReady",true)
print("[Anime Fissure] FISSURE CITY READY | plaza, 9 routes, six district frames, seasonal court and skyline")
