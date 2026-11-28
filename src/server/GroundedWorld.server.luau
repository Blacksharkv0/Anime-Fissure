--!strict
-- FISSURE CITY | grounded landscape, no external asset dependencies.
-- Independent scenery beneath and around city/annex; does not touch arena.
local Workspace=game:GetService("Workspace")
local Assets=require(script.Parent:WaitForChild("LobbyAssetLibrary"))
local lobby=Workspace:WaitForChild("FissureLobby",60)
if not lobby or not lobby:IsA("Model") then return end
local floor=lobby:WaitForChild("LobbyFloor",20)
if not floor then return end
local world=Instance.new("Model");world.Name="GroundedWorld"
local C={Earth=Color3.fromRGB(48,53,57),Rock=Color3.fromRGB(66,77,83),
    Grass=Color3.fromRGB(58,89,73),Moss=Color3.fromRGB(83,114,88),
    Water=Color3.fromRGB(35,84,109),Ink=Color3.fromRGB(25,33,49),
    Cyan=Color3.fromRGB(109,221,255),Wood=Color3.fromRGB(94,62,54),
    Rose=Color3.fromRGB(201,125,156),Pink=Color3.fromRGB(241,181,204)}
local function group(n: string): Model
    local m=Instance.new("Model");m.Name=n;m.Parent=world;return m
end
local function p(parent: Instance,n: string,s: Vector3,cf: CFrame,col: Color3,mat: Enum.Material,shape: string?,alpha: number?): Part
    local obj=Instance.new("Part");obj.Name=n;obj.Size=s;obj.CFrame=cf
    obj.Color=col;obj.Material=mat;obj.Anchored=true
    obj.CanCollide=false;obj.CanTouch=false;obj.CanQuery=false
    obj.CastShadow=mat~=Enum.Material.Neon;obj.Transparency=alpha or 0
    if shape=="Ball" then obj.Shape=Enum.PartType.Ball elseif shape=="Cylinder" then obj.Shape=Enum.PartType.Cylinder end
    obj.Parent=parent;return obj
end
local function at(x: number,y: number,z: number): CFrame return CFrame.new(x,y,z) end
local land=group("ContinentalFoundation")
-- Land begins at x=175, safely beyond Carne Village's x<=136.5 terrain.
-- Its top is immediately below the city and connected Babylon foundations.
p(land,"ContinentalBedrock",Vector3.new(355,34,370),at(352.5,-23,0),C.Earth,Enum.Material.Rock)
p(land,"ContinentalSurface",Vector3.new(355,2,370),at(352.5,-5.1,0),C.Grass,Enum.Material.Grass)
p(land,"CityStoneFoundation",Vector3.new(116,3.4,116),at(260,-2.65,0),C.Rock,Enum.Material.Slate)
-- Lower stone plinth ends at y=-.95: original floor stays authoritative.
p(land,"BabylonFoundation",Vector3.new(64,3.2,65),at(347,-3.1,19),C.Rock,Enum.Material.Slate)
p(land,"BridgeAbutment",Vector3.new(28,4.5,14),at(318,-2.55,20),C.Rock,Enum.Material.Slate)
-- Two broad terraces frame the inner city, with irregular hills behind.
p(land,"NorthTerrace",Vector3.new(140,1.5,30),at(268,-3.3,-69),C.Moss,Enum.Material.Grass)
p(land,"SouthTerrace",Vector3.new(140,1.5,27),at(268,-3.3,69),C.Moss,Enum.Material.Grass)
local mountains=group("MountainBackdrop")
for i,loc in ipairs({{211,-124,60,31},{258,-145,85,49},{314,-133,76,38},{380,-151,92,51},
    {436,-120,78,36},{200,125,49,28},{267,147,75,38},{353,143,83,48},{435,120,66,30}}) do
    local x,z,w,h=loc[1],loc[2],loc[3],loc[4]
    p(mountains,"Foothill_"..i,Vector3.new(w,h,w*.78),at(x,h*.34-6,z),C.Rock,Enum.Material.Rock,"Ball")
    p(mountains,"GreenSlope_"..i,Vector3.new(w*.84,h*.63,w*.70),at(x,h*.16-4,z+3),C.Moss,Enum.Material.Grass,"Ball")
end
local water=group("OuterCanals")
-- Water is scenery only, contained in low stone basins, not in pathways.
for _,loc in ipairs({{260,-94,123,12},{260,95,123,12},{409,20,13,142}}) do
    local x,z,w,d=loc[1],loc[2],loc[3],loc[4]
    p(water,"CanalBasin",Vector3.new(w+2,.50,d+2),at(x,-3.85,z),C.Rock,Enum.Material.Slate)
    local surface=p(water,"CanalSurface",Vector3.new(w,.16,d),at(x,-3.49,z),C.Water,Enum.Material.Glass,nil,.19)
    surface.Reflectance=.09;surface.CastShadow=false
    for i=1,3 do
        local r=p(water,"WaterReflection",Vector3.new(w*.78,.025,.12),at(x,-3.39,z+(i-2)*d*.23),C.Cyan,Enum.Material.SmoothPlastic,nil,.63)
        r.CastShadow=false
    end
end
local grove=group("SakuraGrove")
-- Low poly cherry blossoms, layered irregular crowns and forked branches.
local rng=Random.new(2711)
local function tree(x: number,z: number,y: number,k: number)
    local h=rng:NextNumber(5.7,8.2)
    if Assets.Place("SakuraTree",grove,at(x,y,z)*CFrame.Angles(0,k*.73,0),h+2,7.5) then return end
    p(grove,"SakuraTrunk_"..k,Vector3.new(.66,h,.70),at(x,y+h*.5,z)*CFrame.Angles(0,0,.06),C.Wood,Enum.Material.Wood)
    for i=1,3 do
        local a=i*math.pi*2/3+rng:NextNumber(-.2,.2)
        local a0=Vector3.new(x,y+h*.55,z)
        local b=Vector3.new(x+math.cos(a)*1.9,y+h*.86,z+math.sin(a)*1.9)
        p(grove,"SakuraBranch",Vector3.new(.30,.30,(b-a0).Magnitude),CFrame.lookAt((a0+b)*.5,b),C.Wood,Enum.Material.Wood)
        p(grove,"SakuraCanopy",Vector3.new(3.7,2.65,3.5),CFrame.new(b+Vector3.new(0,.85,0)),if i%2==0 then C.Rose else C.Pink,Enum.Material.SmoothPlastic,"Ball")
    end
    p(grove,"SakuraCrown",Vector3.new(4.6,2.75,4.4),at(x,y+h+.55,z),C.Pink,Enum.Material.SmoothPlastic,"Ball")
end
for i=1,8 do
    local x=213+(i-1)*13.5
    tree(x,-70,-2.55,i)
    tree(x,70,-2.55,8+i)
end
-- Four landmark Japanese gates along the outside embankment, not portals.
local gates=group("HeritageGates")
for i,loc in ipairs({{210,-84},{310,-84},{210,84},{310,84}}) do
    local x,z=loc[1],loc[2]
    for side=-1,1,2 do
        p(gates,"ToriiPillar",Vector3.new(.8,9,.8),at(x+side*3.8,.4,z),C.Wood,Enum.Material.Wood)
        p(gates,"ToriiFoot",Vector3.new(1.2,.7,1.2),at(x+side*3.8,-3.3,z),C.Ink,Enum.Material.Slate)
    end
    p(gates,"ToriiCrossbar",Vector3.new(10.4,.55,.85),at(x,3.8,z),C.Wood,Enum.Material.Wood)
    p(gates,"ToriiRoof",Vector3.new(11.4,.55,1.3),at(x,5.35,z),C.Ink,Enum.Material.Metal)
    p(gates,"ToriiBlueInlay",Vector3.new(9.6,.10,.11),at(x,5.03,z-.71),C.Cyan,Enum.Material.Neon)
end
-- Publish atomically after constructing everything.
world:SetAttribute("Ready",true)
world:SetAttribute("Version","1.0.0")
world:SetAttribute("SceneryOnly",true)
local previous=lobby:FindFirstChild(world.Name)
if previous then previous:Destroy() end
world.Parent=lobby
print("[Anime Fissure] GROUNDED WORLD READY | land, terraces, canals, mountains, sakura")
