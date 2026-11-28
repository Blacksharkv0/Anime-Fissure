--!strict
-- ANIME FISSURE | Three multiverse lobby service stalls and central event hub
-- Additive procedural prototypes, static figures (NOT finished rigged NPCs).
-- Only decorative geometry + ProximityPrompts. No raid/evolution/reroll grants.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Config=require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("LobbyServiceConfig"))
local Art=require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("LobbyNPCArtFinish"))
local Builder={}
Builder.Version="1.2.0"

local P={
    Ink=Color3.fromRGB(15,19,35),Stone=Color3.fromRGB(33,37,57),
    Steel=Color3.fromRGB(118,132,164),Gold=Color3.fromRGB(242,195,95),
    Pearl=Color3.fromRGB(225,235,246),Blue=Color3.fromRGB(62,118,246),
    Ruby=Color3.fromRGB(219,74,98),
}
local function model(parent: Instance,name: string): Model
    local x=Instance.new("Model");x.Name=name;x.Parent=parent;return x
end
local function part(parent: Instance,name: string,size: Vector3,
    cf: CFrame,color: Color3,material: Enum.Material?,solid: boolean?,
    transparency: number?): BasePart
    local p=Instance.new("Part")
    p.Name=name;p.Size=size;p.CFrame=cf;p.Color=color
    p.Material=material or Enum.Material.SmoothPlastic
    p.Anchored=true;p.CanCollide=solid==true;p.CanQuery=solid==true
    p.CanTouch=false;p.Transparency=transparency or 0
    p.CastShadow=material~=Enum.Material.Neon
    p.Parent=parent;return p
end
local function sphere(parent: Instance,name: string,size: Vector3,
    cf: CFrame,color: Color3,material: Enum.Material?,alpha: number?)
    local p=part(parent,name,size,cf,color,material,false,alpha)
    p.Shape=Enum.PartType.Ball;return p
end
local function rod(parent: Instance,name: string,a: Vector3,b: Vector3,
    width: number,color: Color3,material: Enum.Material?)
    local v=b-a
    if v.Magnitude<=0.01 then return end
    part(parent,name,Vector3.new(width,width,v.Magnitude),
        CFrame.lookAt((a+b)/2,b),color,material,false)
end
local function circle(parent: Instance,name: string,center: Vector3,
    radius: number,col: Color3,thickness: number,count: number,
    plane: string?)
    for i=1,count do
        local a=(i-1)*math.pi*2/count
        local b=i*math.pi*2/count
        local function pt(t: number)
            if plane=="front" then
                return center+Vector3.new(math.cos(t)*radius,math.sin(t)*radius,0)
            end
            return center+Vector3.new(math.cos(t)*radius,0,math.sin(t)*radius)
        end
        rod(parent,name..i,pt(a),pt(b),thickness,col,Enum.Material.Neon)
    end
end
local function billboard(parent: Instance,content: string,subtitle: string,
    pos: Vector3,color: Color3)
    local anchor=part(parent,"StationNameAnchor",Vector3.new(.2,.2,.2),
        CFrame.new(pos),color,nil,false,1)
    local gui=Instance.new("BillboardGui")
    gui.Name="StationName";gui.Adornee=anchor
    gui.Size=UDim2.fromOffset(252,69)
    gui.MaxDistance=80;gui.AlwaysOnTop=false;gui.Parent=anchor
    local bg=Instance.new("Frame")
    bg.BackgroundColor3=P.Ink;bg.BackgroundTransparency=.1
    bg.BorderSizePixel=0;bg.Size=UDim2.fromScale(1,1)
    bg.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,8);corner.Parent=bg
    local stroke=Instance.new("UIStroke")
    stroke.Color=color;stroke.Thickness=1.5;stroke.Parent=bg
    for i,line in ipairs({content,subtitle}) do
        local txt=Instance.new("TextLabel")
        txt.Name=if i==1 then "StationTitle" else "StationSubtitle"
        txt.Size=UDim2.new(1,-12,0,if i==1 then 39 else 25)
        txt.Position=UDim2.fromOffset(6,if i==1 then 3 else 41)
        txt.BackgroundTransparency=1;txt.Text=line
        txt.Font=Enum.Font.GothamBold
        txt.TextColor3=if i==1 then color else P.Pearl
        txt.TextScaled=true;txt.Parent=bg
    end
end
local function validatePrompt(m: Model,station: any): ProximityPrompt
    local facing=CFrame.new(station.Position)*CFrame.Angles(0,station.Yaw or 0,0)
    local at=facing:PointToWorldSpace(Vector3.new(0,4,-4.25))
    local anchor=part(m,"InteractionPoint",Vector3.new(1,2,1),
        CFrame.new(at),station.Accent,nil,false,1)
    local prompt=Instance.new("ProximityPrompt")
    prompt.Name="LobbyServicePrompt"
    prompt.ActionText=station.Action
    prompt.ObjectText=station.NPC.." • "..station.Title
    prompt.MaxActivationDistance=11
    prompt.RequiresLineOfSight=false;prompt.ClickablePrompt=true
    prompt.HoldDuration=0
    prompt.KeyboardKeyCode=Enum.KeyCode.E
    prompt.GamepadKeyCode=Enum.KeyCode.ButtonX
    prompt.Parent=anchor
    return prompt
end
local function stationaryCharacter(parent: Model,station: any,kind: string)
    local npc=model(parent,station.NPC:gsub("%W","").."NPC")
    npc:SetAttribute("NPC",station.NPC)
    npc:SetAttribute("Role",kind)
    npc:SetAttribute("Prototype","StaticDecorative")
    local pos=station.Position+Vector3.new(0,.32,0)
    local frame=CFrame.new(pos)*CFrame.Angles(0,station.Yaw or 0,0)
    local function bodyPart(name: string,size: Vector3,x: number,y: number,z: number,
        col: Color3,material: Enum.Material?)
        return part(npc,name,size,frame*CFrame.new(x,y,z),col,material,false)
    end
    local main=if kind=="Index" then Color3.fromRGB(130,29,49)
        elseif kind=="Evolution" then Color3.fromRGB(95,45,126)
        elseif kind=="Traits" then Color3.fromRGB(41,75,59)
        elseif kind=="Raids" then Color3.fromRGB(30,30,58)
        else Color3.fromRGB(181,93,29)
    local skin=if kind=="Evolution" then Color3.fromRGB(146,212,228)
        elseif kind=="EventHub" then Color3.fromRGB(240,206,161)
        else Color3.fromRGB(230,190,160)
    bodyPart("BootL",Vector3.new(1.0,1.5,1.25),-.62,1,0,P.Ink)
    bodyPart("BootR",Vector3.new(1.0,1.5,1.25),.62,1,0,P.Ink)
    bodyPart("LegL",Vector3.new(1.05,2.1,1.1),-.63,2.7,0,main)
    bodyPart("LegR",Vector3.new(1.05,2.1,1.1),.63,2.7,0,main)
    bodyPart("Robe",Vector3.new(2.43,3.1,1.37),0,5.1,0,main,Enum.Material.Fabric)
    bodyPart("ArmL",Vector3.new(.83,3.05,.92),-1.63,5.18,0,main)
    bodyPart("ArmR",Vector3.new(.83,3.05,.92),1.63,5.18,0,main)
    bodyPart("HandL",Vector3.new(.72,.64,.84),-1.63,3.4,0,skin)
    bodyPart("HandR",Vector3.new(.72,.64,.84),1.63,3.4,0,skin)
    bodyPart("Neck",Vector3.new(.70,.65,.72),0,7.01,0,skin)
    local head=bodyPart("Head",Vector3.new(1.61,1.70,1.44),0,8.03,0,skin)
    for _,side in ipairs({-1,1}) do
        bodyPart("Eye"..side,Vector3.new(.23,.18,.10),
            side*.35,8.19,-.76,station.Secondary,Enum.Material.Neon)
    end
    if kind=="Index" then
        -- Dante's red coat, silver hair, black undershirt, broad sword.
        -- 3D PARTS prototype only, NOT a finished animated character.
        bodyPart("CrimsonLongCoat",Vector3.new(2.77,3.68,1.50),
            0,4.57,.23,Color3.fromRGB(170,31,57),Enum.Material.Fabric)
        bodyPart("DarkInnerVest",Vector3.new(1.36,2.05,.16),
            0,5.31,-.79,P.Ink,Enum.Material.SmoothPlastic)
        for _,side in ipairs({-1,1}) do
            bodyPart("RedCoatTail"..side,Vector3.new(.83,3.09,.19),
                side*.77,2.76,.76,Color3.fromRGB(148,23,48),Enum.Material.Fabric)
            bodyPart("SilverHairLock"..side,Vector3.new(.35,.88,.39),
                side*.69,8.91,-.42,Color3.fromRGB(216,224,234))
        end
        bodyPart("SilverHairCrown",Vector3.new(1.88,.48,1.50),
            0,8.98,0,Color3.fromRGB(214,226,236))
        for i=1,5 do
            bodyPart("SweptHair"..i,Vector3.new(.31,.76,.40),
                -.73+i*.24,9.37+(i%2)*.1,.03,Color3.fromRGB(232,234,237))
        end
        bodyPart("SwordOverShoulder",Vector3.new(.44,4.1,.33),
            1.91,5.27,.90,P.Steel,Enum.Material.Metal)
        bodyPart("SwordCrossguard",Vector3.new(1.68,.28,.50),
            1.91,3.89,.90,P.Gold,Enum.Material.Metal)
        bodyPart("RedGloveL",Vector3.new(.9,.72,1.00),
            -1.63,3.51,0,Color3.fromRGB(39,42,50))
        bodyPart("RedGloveR",Vector3.new(.9,.72,1.00),
            1.63,3.51,0,Color3.fromRGB(39,42,50))
    elseif kind=="Evolution" then
        -- Whis silhouette: silver vertical hair, blue neck halo and staff.
        for i=1,6 do
            bodyPart("SilverTowerHair"..i,Vector3.new(.24,1.7+0.15*i,.42),
                -.78+i*.22,9.12+.14*(i%3),-.08,P.Pearl)
        end
        circle(npc,"AngelHalo",pos+Vector3.new(0,7.2,0),2.12,
            station.Accent,.13,20,"front")
        rod(npc,"AngelStaff",pos+Vector3.new(-2,1.5,-.3),
            pos+Vector3.new(-2,10.5,-.3),.20,P.Gold,Enum.Material.Metal)
        sphere(npc,"StaffCore",Vector3.new(.78,.78,.78),
            CFrame.new(pos+Vector3.new(-2,10.15,-.3)),
            station.Accent,Enum.Material.Neon)
        bodyPart("LongRoyalTabard",Vector3.new(.98,3.82,.11),0,4.25,-.73,
            Color3.fromRGB(18,33,58),Enum.Material.Fabric)
    elseif kind=="Traits" then
        -- Striped hat and a floating process rune, visually distinct from
        -- Edward's alchemy. Traits only, never relic reroll.
        local hat=bodyPart("StripedHatBrim",Vector3.new(3.0,.25,2.65),
            0,8.98,0,Color3.fromRGB(240,241,224))
        bodyPart("StripedHatCrown",Vector3.new(2.22,1.05,2.13),
            0,9.53,0,station.Accent)
        for i=-2,2 do
            bodyPart("HatStripe"..i,Vector3.new(.23,1.10,2.16),
                i*.41,9.57,-.02,Color3.fromRGB(232,239,218))
        end
        bodyPart("DarkOuterCloak",Vector3.new(2.84,2.42,1.49),
            0,5.00,.11,P.Ink,Enum.Material.Fabric)
        circle(npc,"TraitRuneHalo",pos+Vector3.new(3.2,6.0,0),
            1.65,station.Accent,.10,12,"front")
        rod(npc,"TraitFocus",pos+Vector3.new(3.2,4.6,-.1),
            pos+Vector3.new(3.2,7.4,-.1),.13,station.Secondary,Enum.Material.Neon)
    elseif kind=="Raids" then
        bodyPart("ShadowHair",Vector3.new(1.72,.58,1.51),
            0,8.92,0,Color3.fromRGB(12,16,35))
        for i=1,5 do
            bodyPart("ShadowSpike"..i,Vector3.new(.24,.65,.42),
                -.65+i*.23,9.25,0,Color3.fromRGB(11,17,37))
        end
        bodyPart("HunterCoatTail",Vector3.new(2.45,3.1,.19),
            0,3.1,.78,P.Ink,Enum.Material.Fabric)
        for _,side in ipairs({-1,1}) do
            bodyPart("ShadowDagger"..side,Vector3.new(.19,1.54,.23),
                side*2.12,2.92,-.22,station.Accent,Enum.Material.Neon)
        end
    else
        -- An example ONLY shown in Studio, intentionally not a live event.
        bodyPart("GoldenMane",Vector3.new(2.18,.82,1.65),
            0,9.0,0,P.Gold)
        bodyPart("SunEmblem",Vector3.new(.62,.62,.24),
            0,5.9,-.76,P.Gold,Enum.Material.Neon)
    end
    npc.PrimaryPart=head
    Art.ApplyService(npc,kind,frame,station)
    return npc
end
local function station(root: Model,info: any,kind: string)
    local m=model(root,kind.."Station")
    m:SetAttribute("Role",kind)
    m:SetAttribute("NPC",info.NPC)
    m:SetAttribute("GameplayActive",false)
    local pos=info.Position
    local rear=if math.cos(info.Yaw or 0)<0 then -1 else 1
    -- Station bases span max 14 studs; all are offset from center walkway.
    part(m,"Footprint",Vector3.new(14,.45,14),
        CFrame.new(pos+Vector3.new(0,.21,0)),P.Stone,
        Enum.Material.Slate,true)
    part(m,"RoyalEdge",Vector3.new(13.5,.09,13.5),
        CFrame.new(pos+Vector3.new(0,.50,0)),info.Accent,
        Enum.Material.Metal,false,.40)
    circle(m,"PedestalSigil",pos+Vector3.new(0,.55,0),5.2,
        info.Accent,.14,22)
    for _,side in ipairs({-1,1}) do
        local corner=pos+Vector3.new(side*5,4.5,4*rear)
        part(m,"StationPillar",Vector3.new(.9,8.3,.9),
            CFrame.new(corner),P.Ink,Enum.Material.Metal)
        sphere(m,"StationGem",Vector3.new(.84,1.25,.84),
            CFrame.new(corner+Vector3.new(0,4.55,0)),
            info.Accent,Enum.Material.Glass,.1)
    end
    stationaryCharacter(m,info,kind)
    billboard(m,info.Name,info.Title,pos+Vector3.new(0,12.5,0),
        info.Accent)
    local prompt=validatePrompt(m,info)
    prompt:SetAttribute("ServiceId",kind)
    if kind=="Index" then
        -- Floating crimson codex; the Archive is not a personal Collection.
        local book=part(m,"HunterUnitIndex",Vector3.new(2.15,2.85,.33),
            CFrame.new(pos+Vector3.new(0,7.2,5.0*rear)),P.Ink,
            Enum.Material.Metal,false)
        part(m,"IndexCover",Vector3.new(1.76,2.51,.13),
            CFrame.new(pos+Vector3.new(0,7.2,4.79*rear)),
            info.Accent,Enum.Material.Glass,false,.12)
        circle(m,"IndexRune",pos+Vector3.new(0,7.2,4.61*rear),1.36,
            info.Secondary,.09,12,"front")
        local light=Instance.new("PointLight")
        light.Color=info.Accent;light.Brightness=.46;light.Range=9
        light.Shadows=false;light.Parent=book
    elseif kind=="Raids" then
        -- Shadow gate: vertical split at rear of booth, decorative.
        circle(m,"ShadowGateway",pos+Vector3.new(0,7,5*rear),4.0,
            info.Accent,.18,24,"front")
        circle(m,"HunterGateInner",pos+Vector3.new(0,7,5*rear),2.7,
            info.Secondary,.1,20,"front")
    elseif kind=="Evolution" then
        circle(m,"AstralChamber",pos+Vector3.new(0,11,4.4*rear),3.25,
            info.Secondary,.13,20,"front")
    elseif kind=="Traits" then
        circle(m,"AptitudeSeal",pos+Vector3.new(0,10,4.4*rear),3.0,
            info.Accent,.1,16,"front")
    end
    return m
end
-- The original Vergil stand and Dante Index together form a single
-- visual district. Keep this emblem above the path, not a physical wall.
local function twinHunterEmblem(root: Model)
    local emblem=model(root,"TwinHuntersEmblem")
    emblem:SetAttribute("Decorative",true)
    local center=Vector3.new(240.1,12.8,-8.5)
    circle(emblem,"CrimsonDemonSigil",center,2.65,
        Color3.fromRGB(232,67,93),.11,16,"front")
    circle(emblem,"AzureDemonSigil",center,2.10,
        Color3.fromRGB(78,164,255),.085,16,"front")
    for _,side in ipairs({-1,1}) do
        local tint=if side<0 then Color3.fromRGB(91,178,255)
            else Color3.fromRGB(240,80,97)
        rod(emblem,"HunterBlade"..side,
            center+Vector3.new(-side*1.70,-2.10,-.20),
            center+Vector3.new(side*1.70,2.10,-.20),
            .24,tint,Enum.Material.Metal)
        rod(emblem,"HunterGuard"..side,
            center+Vector3.new(-side*.66,-1.03,-.21),
            center+Vector3.new(-side*.05,-1.59,-.21),
            .17,P.Gold,Enum.Material.Metal)
    end
    billboard(emblem,"IRMÃOS CAÇADORES",
        "SUMMON  •  INDEX",center+Vector3.new(0,4.0,0),
        Color3.fromRGB(222,212,248))
    return emblem
end
local function eventHub(root: Model)
    local info=Config.Get("EventHub")
    local m=model(root,"SeasonalEventHub")
    m:SetAttribute("Role","EventHub")
    m:SetAttribute("EventId",Config.CurrentEventId or "")
    m:SetAttribute("GameplayActive",false)
    m:SetAttribute("RotatingSlot",true)
    local pos=info.Position
    part(m,"CenterStage",Vector3.new(10.0,.28,10.0),
        CFrame.new(pos+Vector3.new(0,.19,0)),P.Stone,
        Enum.Material.Marble,true)
    circle(m,"EventArenaSigil",pos+Vector3.new(0,.44,0),5.4,
        P.Gold,.14,24)
    circle(m,"EventInnerRing",pos+Vector3.new(0,.45,0),3.15,
        P.Blue,.10,16)
    local preview=if RunService:IsStudio() then Config.GetEventPreview() else nil
    local active=Config.GetEvent()
    if active then
        local display=table.clone(info)
        display.NPC=active.NPC;display.Accent=active.Accent
        stationaryCharacter(m,display,"EventHub")
        m:SetAttribute("DisplayState","LiveEventVisualOnly")
    elseif preview then
        local display=table.clone(info)
        display.NPC=preview.NPC;display.Accent=preview.Accent
        stationaryCharacter(m,display,"EventHub")
        m:SetAttribute("DisplayState","StudioPreviewOnly")
    else
        -- Neutral holographic figure; no fabricated live event or raid.
        sphere(m,"UnassignedEventHologram",
            Vector3.new(2.0,3.2,2.0),
            CFrame.new(pos+Vector3.new(0,5.3,0)),
            P.Blue,Enum.Material.Glass,.53)
        m:SetAttribute("DisplayState","AwaitingEvent")
    end
    billboard(m,"PRAÇA DOS EVENTOS",
        if preview and not active then "EXEMPLO • NANATSU • NÃO ATIVO"
        else "PERSONAGEM SAZONAL • EM BREVE",
        pos+Vector3.new(0,12.8,0),P.Gold)
    local prompt=validatePrompt(m,info)
    prompt:SetAttribute("ServiceId","EventHub")
    return m
end
function Builder.Build(lobby: Model): Model
    assert(lobby.Name=="FissureLobby","Build only inside main lobby")
    local previous=lobby:FindFirstChild("LobbyServiceStations")
    if previous then previous:Destroy() end
    local root=model(lobby,"LobbyServiceStations")
    root:SetAttribute("Version",Builder.Version)
    root:SetAttribute("StaticPrototype",true)
    root:SetAttribute("SystemsActive",false)
    for _,kind in ipairs(Config.Order) do
        local info=Config.Get(kind)
        assert(info and info.Enabled==false,"Do not activate unfinished systems")
        station(root,info,kind)
    end
    eventHub(root)
    twinHunterEmblem(root)
    root:SetAttribute("StationCount",#Config.Order)
    root:SetAttribute("EventHubCount",1)
    root:SetAttribute("Ready",true)
    return root
end
return Builder
