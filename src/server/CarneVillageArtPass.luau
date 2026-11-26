--!strict
-- ANIME FISSURE | Carne Village Art Pass v0.8
-- Story OVL_01: rural / vulnerable village before later fortifications.
-- NON-BLOCKING scenery. Never modify EnemyPath, FissureBase, PlayerSpawns,
-- existing terrain, waypoints, tower placement rules or NPC scripts.
-- All parts are anchored, CanCollide/CanQuery/CanTouch false.
local Art = {}
Art.Version="0.8.0"
local rng=Random.new(818240)

local COL={
    timber=Color3.fromRGB(90,65,47),
    aged=Color3.fromRGB(125,91,62),
    roof=Color3.fromRGB(106,70,52),
    plaster=Color3.fromRGB(224,204,165),
    charcoal=Color3.fromRGB(67,58,54),
    iron=Color3.fromRGB(78,77,69),
    warm=Color3.fromRGB(243,204,123),
    flax=Color3.fromRGB(212,174,97),
    straw=Color3.fromRGB(227,197,107),
    rust=Color3.fromRGB(154,78,51),
    linen=Color3.fromRGB(198,186,155),
    stone=Color3.fromRGB(134,128,107),
    burgundy=Color3.fromRGB(109,64,53),
    green=Color3.fromRGB(117,145,79),
}

local function piece(parent: Instance,name: string,sz: Vector3,cf: CFrame,
    color: Color3,mat: Enum.Material?, kind: string?): BasePart
    local p: BasePart
    if kind=="Wedge" then p=Instance.new("WedgePart")
    else
        local a=Instance.new("Part")
        if kind=="Ball" then a.Shape=Enum.PartType.Ball
        elseif kind=="Cylinder" then a.Shape=Enum.PartType.Cylinder end
        p=a
    end
    p.Name=name; p.Size=sz; p.CFrame=cf; p.Color=color
    p.Material=mat or Enum.Material.WoodPlanks
    p.Anchored=true; p.CanCollide=false; p.CanQuery=false
    p.CanTouch=false; p.CastShadow=false
    p.Parent=parent
    return p
end

local function strut(parent: Instance,name: string,a: Vector3,b: Vector3,
    width: number,color: Color3,mat: Enum.Material?)
    local d=b-a
    if d.Magnitude<0.04 then return end
    return piece(parent,name,Vector3.new(width,width,d.Magnitude),
        CFrame.lookAt((a+b)*0.5,b),color,mat)
end

local function crate(parent: Instance, origin: CFrame, s: number, name: string)
    local center=origin*CFrame.new(0,0.68*s,0)
    piece(parent,name.."_Body",Vector3.new(1.5,1.2,1.4)*s,
        center,COL.aged,Enum.Material.WoodPlanks)
    for _,side in ipairs({-1,1}) do
        local l,r=Vector3.new(-0.71*s,0,side*0.73*s),Vector3.new(0.71*s,0,side*0.73*s)
        strut(parent,name.."_X1", (origin*CFrame.new(l.X,0.15*s,l.Z)).Position,
            (origin*CFrame.new(r.X,1.24*s,r.Z)).Position,0.11*s,COL.timber,Enum.Material.Wood)
        strut(parent,name.."_X2", (origin*CFrame.new(r.X,0.15*s,r.Z)).Position,
            (origin*CFrame.new(l.X,1.24*s,l.Z)).Position,0.11*s,COL.timber,Enum.Material.Wood)
    end
end

local function sack(parent: Instance,origin: CFrame,s: number)
    piece(parent,"GrainSack",Vector3.new(1.0,1.3,0.95)*s,
        origin*CFrame.new(0,0.67*s,0)*CFrame.Angles(0,0,math.rad(10)),
        COL.linen,Enum.Material.Fabric,"Ball")
    piece(parent,"SackTwine",Vector3.new(0.62,0.13,0.63)*s,
        origin*CFrame.new(-0.10*s,1.25*s,0),
        COL.timber,Enum.Material.Wood)
end

local function houseDetails(art: Instance,house: Model,index: number)
    local plaster=house:FindFirstChild("PlasterHouse")
    if not plaster or not plaster:IsA("BasePart") then return end
    local cf=plaster.CFrame
    local w,d,h=plaster.Size.X,plaster.Size.Z,plaster.Size.Y
    local yTop=h*0.5
    -- Timbers cross the light plaster panels, emphasizing half-timber houses.
    for _,side in ipairs({-1,1}) do
        for _,x in ipairs({-w*0.31,w*0.31}) do
            piece(art,"House"..index.."_FrontStud",
                Vector3.new(0.21,h*0.84,0.19),
                cf*CFrame.new(x,0,side*(d*0.5+0.12)),
                COL.timber,Enum.Material.Wood)
        end
        for _,y in ipairs({-h*0.25,h*0.19}) do
            piece(art,"House"..index.."_CrossBeam",
                Vector3.new(w*0.93,0.20,0.22),
                cf*CFrame.new(0,y,side*(d*0.5+0.14)),
                COL.aged,Enum.Material.Wood)
        end
        for _,x in ipairs({-w*0.43,w*0.43}) do
            piece(art,"House"..index.."_SidePlank",
                Vector3.new(0.19,h*0.56,0.19),
                cf*CFrame.new(x,-0.13,side*(d*0.5+0.19)),
                COL.charcoal,Enum.Material.WoodPlanks)
        end
    end

    -- Worn thatch strips along existing sloped roofs; keep silhouettes but
    -- no parts extending across the player's playable path.
    for _,roof in ipairs(house:GetChildren()) do
        if roof:IsA("BasePart") and roof.Name=="ThatchRoof" then
            for stripe=1,5 do
                local dx=(stripe-3)*roof.Size.X/5
                piece(art,"RoofThatchStrand",
                    Vector3.new(roof.Size.X*0.065,0.09,roof.Size.Z*0.93),
                    roof.CFrame*CFrame.new(dx,0.28,0),
                    if (index+stripe)%2==0 then COL.straw else COL.roof,
                    Enum.Material.Grass)
            end
        end
    end

    -- Door with black iron hinges and a wooden step.
    local door=house:FindFirstChild("FrontDoor")
    if door and door:IsA("BasePart") then
        for _,dy in ipairs({-1.3,1.3}) do
            piece(art,"ForgedDoorHinge",Vector3.new(1.25,0.13,0.13),
                door.CFrame*CFrame.new(-0.50,dy,-0.22),
                COL.iron,Enum.Material.Metal)
        end
        piece(art,"DoorStep",Vector3.new(3.1,0.26,1.0),
            door.CFrame*CFrame.new(0,-2.10,-0.62),
            COL.stone,Enum.Material.Slate)
    end

    -- Small agricultural props, always near original homes, not inside path.
    if index%2==0 then
        crate(art,cf*CFrame.new(w*0.43,-h*0.48-0.10,d*0.58),0.72,"GrainCrate"..index)
    else
        sack(art,cf*CFrame.new(w*0.46,-h*0.48-0.04,d*0.52),0.84)
    end
end

local function grainFields(art: Instance, farms: Model)
    local plots={}
    for _,p in ipairs(farms:GetChildren()) do
        if p:IsA("BasePart") and p.Name=="CultivatedSoil" then
            table.insert(plots,p)
        end
    end
    for index,p in ipairs(plots) do
        local length=p.Size.Z
        for row=1,4 do
            for stalk=1,10 do
                local dx=(row-2.5)*p.Size.X/5
                local dz=(stalk-5.5)*length/11
                local alt=rng:NextNumber(0.75,1.12)
                local stemBase=p.CFrame*CFrame.new(dx,0.45,dz)
                local top=(stemBase*CFrame.new(0,2.0*alt,0)).Position
                strut(art,"WheatStem",(stemBase).Position,top,0.07,
                    COL.green,Enum.Material.Grass)
                for side=-1,1,2 do
                    piece(art,"WheatAwn",
                        Vector3.new(0.11,0.50*alt,0.10),
                        CFrame.new(top+Vector3.new(side*0.10,-0.14,0))
                            *CFrame.Angles(0,0,math.rad(side*15)),
                        if (index+row+stalk)%3==0 then COL.flax else COL.straw,
                        Enum.Material.Grass,"Wedge")
                end
            end
        end
    end
end

local function wellDetails(art: Instance,square: Model)
    local roof=square:FindFirstChild("WellRoof")
    if not roof or not roof:IsA("BasePart") then return end
    local cf=roof.CFrame
    for i=1,6 do
        piece(art,"WellThatchStrip",Vector3.new(roof.Size.X*0.92,0.08,0.20),
            cf*CFrame.new(0,0.33,(i-3.5)*roof.Size.Z/7),
            if i%2==0 then COL.roof else COL.straw,Enum.Material.Grass)
    end
    local origin=Vector3.new(-52,0,36)
    strut(art,"WellPulleyAxle",
        origin+Vector3.new(-2.6,4.7,0),
        origin+Vector3.new(2.6,4.7,0),0.25,COL.timber,Enum.Material.Wood)
    piece(art,"WellRope",Vector3.new(0.11,2.7,0.11),
        CFrame.new(origin+Vector3.new(0,3.6,0)),COL.flax,Enum.Material.Fabric)
    piece(art,"WellBucket",Vector3.new(1.00,0.91,0.91),
        CFrame.new(origin+Vector3.new(0,2.17,0)),COL.aged,Enum.Material.WoodPlanks)
end

local function householdProps(art: Instance,square: Model)
    for _,p in ipairs(square:GetChildren()) do
        if p:IsA("BasePart") and p.Name=="CartBody" then
            local cf=p.CFrame
            for i=-1,1 do
                piece(art,"CartStackedHay",Vector3.new(1.1,0.75,1.8),
                    cf*CFrame.new(i*1.22,1.08,0),
                    COL.straw,Enum.Material.Grass)
            end
        end
    end
    -- Keep objects at outskirts of the player route.
    crate(art,CFrame.new(-68,0,31),0.85,"VillageSupplies")
    crate(art,CFrame.new(-70.0,0,30.6),0.58,"VillageSuppliesSmall")
    sack(art,CFrame.new(-57.2,0,48.0),1)
end

local function countryside(art: Instance)
    -- Sparse distant bushes / grasses away from central path.
    local places={
        Vector3.new(-87,0,-59),Vector3.new(-94,0,51),
        Vector3.new(-84,0,58),Vector3.new(90,0,58),
        Vector3.new(97,0,-63),Vector3.new(106,0,16),
        Vector3.new(81,0,-66),Vector3.new(-102,0,-38),
        Vector3.new(-101,0,72),Vector3.new(91,0,79),
    }
    for i,center in ipairs(places) do
        for k=1,4 do
            local a=(k/4)*math.pi*2
            piece(art,"OuterShrub",Vector3.new(1.8,1.5,1.9),
                CFrame.new(center+Vector3.new(math.cos(a)*1.0,0.75,math.sin(a))),
                if (i+k)%2==0 then COL.green else Color3.fromRGB(75,126,72),
                Enum.Material.LeafyGrass,"Ball")
        end
    end
end

function Art.Apply(arena: Model): Model
    local existing=arena:FindFirstChild("CarneVillageArtPass")
    if existing and existing:IsA("Model") then return existing end
    assert(arena.Name=="FissureArena", "CarneVillageArtPass precisa da arena")
    local village=arena:FindFirstChild("TimberHomes")
    local farms=arena:FindFirstChild("Farmland")
    local square=arena:FindFirstChild("VillageSquare")
    assert(village and farms and square,"Carne Village incompleta")
    local art=Instance.new("Model")
    art.Name="CarneVillageArtPass"
    art:SetAttribute("VisualOnly",true)
    art:SetAttribute("Version",Art.Version)
    art.Parent=arena
    for _,house in ipairs(village:GetChildren()) do
        local n=tonumber(house.Name:match("^House_(%d+)$"))
        if n and house:IsA("Model") then houseDetails(art,house,n) end
    end
    grainFields(art,farms)
    wellDetails(art,square)
    householdProps(art,square)
    countryside(art)
    arena:SetAttribute("ArtPassVersion",Art.Version)
    return art
end
return Art
