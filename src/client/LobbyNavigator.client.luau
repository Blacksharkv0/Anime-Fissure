--!strict
-- ANIME FISSURE | LOBBY NAVIGATOR v1.0
-- QoL: nine real lobby destinations, personal landmark and distance display.
-- NEVER teleports, opens unavailable systems, calls inventory, or changes map.
-- Mouse/touch/gamepad activated; keyboard M toggles the directory.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local UserInputService=game:GetService("UserInputService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local playerGui=player:WaitForChild("PlayerGui")
local cfg=require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("LobbyServiceConfig"))

local C={
    Ink=Color3.fromRGB(9,15,32),Panel=Color3.fromRGB(20,30,55),
    Inner=Color3.fromRGB(34,48,80),Electric=Color3.fromRGB(65,126,250),
    Cyan=Color3.fromRGB(106,220,249),Gold=Color3.fromRGB(247,204,107),
    White=Color3.fromRGB(243,247,254),Muted=Color3.fromRGB(180,193,219),
}
local old=playerGui:FindFirstChild("AnimeFissureLobbyNavigator")
if old then old:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="AnimeFissureLobbyNavigator"
-- Keep directory below Story/Guide/loading overlays of the main lobby.
gui.DisplayOrder=39
gui.ResetOnSpawn=false
gui.IgnoreGuiInset=false
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=playerGui
local function round(parent: Instance,r: number)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r);c.Parent=parent
end
local function frame(parent: Instance,name: string,pos: UDim2,
    size: UDim2,bg: Color3): Frame
    local f=Instance.new("Frame")
    f.Name=name;f.Position=pos;f.Size=size;f.BackgroundColor3=bg
    f.BorderSizePixel=0;f.Parent=parent
    round(f,11);return f
end
local function label(parent: Instance,name: string,value: string,pos: UDim2,
    size: UDim2,fontSize: number,color: Color3,bold: boolean?): TextLabel
    local t=Instance.new("TextLabel")
    t.Name=name;t.Text=value;t.Position=pos;t.Size=size
    t.BackgroundTransparency=1;t.TextColor3=color
    t.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    t.TextSize=fontSize;t.TextWrapped=true
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.Parent=parent;return t
end
local function button(parent: Instance,name: string,value: string,
    pos: UDim2,size: UDim2,color: Color3): TextButton
    local b=Instance.new("TextButton")
    b.Name=name;b.Text=value;b.Position=pos;b.Size=size
    b.BackgroundColor3=color;b.BorderSizePixel=0
    b.Font=Enum.Font.GothamBold;b.TextSize=13
    b.TextColor3=C.White;b.TextWrapped=true
    b.Parent=parent;round(b,8)
    return b
end
local trigger=button(gui,"OpenDirectory","⌖ NPCs / MAPA",
    UDim2.fromOffset(14,90),UDim2.fromOffset(158,38),C.Panel)
local trigStroke=Instance.new("UIStroke")
trigStroke.Color=C.Electric;trigStroke.Thickness=1.3;trigStroke.Parent=trigger
-- Local cosmetic preference. Touch defaults to reduced effects.
-- This attribute affects only client particles and ambient VFX; the
-- SERVER still owns all combat, damage and reward calculations.
if player:GetAttribute("ReducedVFX")==nil then
    player:SetAttribute("ReducedVFX",UserInputService.TouchEnabled)
end
local fxButton=button(gui,"FXQualityToggle","FX: PADRÃO",
    UDim2.fromOffset(183,90),UDim2.fromOffset(141,38),C.Panel)
local function refreshFx()
    local low=player:GetAttribute("ReducedVFX")==true
    fxButton.Text=if low then "FX: LEVE ✓" else "FX: PADRÃO"
    fxButton.BackgroundColor3=if low then C.Inner else C.Panel
end
fxButton.Activated:Connect(function()
    player:SetAttribute("ReducedVFX",
        player:GetAttribute("ReducedVFX")~=true)
    refreshFx()
end)
refreshFx()
local panel=frame(gui,"Directory",UDim2.fromOffset(14,137),
    UDim2.fromOffset(365,500),C.Panel)
panel.Visible=false
local outline=Instance.new("UIStroke")
outline.Color=C.Electric;outline.Thickness=1.2;outline.Parent=panel
label(panel,"Header","ESTAÇÕES DO ANIME FISSURE",
    UDim2.fromOffset(15,10),UDim2.fromOffset(325,26),16,C.White,true)
label(panel,"Sub","Toque no destino para mostrar onde ele fica.",
    UDim2.fromOffset(15,42),UDim2.fromOffset(330,26),12,C.Muted)
local close=button(panel,"CloseDirectory","✕",
    UDim2.fromOffset(327,9),UDim2.fromOffset(28,28),C.Inner)
local scroll=Instance.new("ScrollingFrame")
scroll.Name="Destinations"
scroll.Position=UDim2.fromOffset(10,78)
scroll.Size=UDim2.fromOffset(344,370)
scroll.ScrollBarThickness=4
scroll.ScrollBarImageColor3=C.Cyan
scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0
scroll.CanvasSize=UDim2.fromOffset(0,0)
scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
scroll.Parent=panel
local list=Instance.new("UIListLayout")
list.SortOrder=Enum.SortOrder.LayoutOrder;list.Padding=UDim.new(0,5)
list.Parent=scroll
local tip=label(panel,"Tip","M: abrir/fechar  •  ESC: fechar  •  Sem teleporte.",
    UDim2.fromOffset(13,457),UDim2.fromOffset(333,35),11,C.Muted)
local scale=Instance.new("UIScale")
scale.Parent=panel
local mini=frame(gui,"ActiveWaypoint",UDim2.new(.5,0,0,88),
    UDim2.fromOffset(345,56),C.Panel)
mini.AnchorPoint=Vector2.new(.5,0)
mini.Visible=false
local miniScale=Instance.new("UIScale")
miniScale.Parent=mini
local waypointText=label(mini,"Destination","",
    UDim2.fromOffset(13,6),UDim2.fromOffset(283,44),13,C.Cyan,true)
local clear=button(mini,"ClearTarget","✕",
    UDim2.fromOffset(305,11),UDim2.fromOffset(32,32),C.Inner)

type Entry={id: string,label: string,subtitle: string,accent: Color3}
local entries: {Entry}={
    {id="Story",label="PORTAL STORY",subtitle="Missões / Carne Village",accent=C.Cyan},
    {id="Virgil",label="VERGIL",subtitle="Summon / invocação",accent=Color3.fromRGB(170,126,253)},
    {id="Index",label="DANTE",subtitle="Index de unidades",accent=Color3.fromRGB(244,93,118)},
    {id="Alchemy",label="EDWARD",subtitle="Alquimia / orbes",accent=C.Gold},
    {id="Relics",label="GILGAMESH",subtitle="Salão das relíquias",accent=C.Gold},
    {id="Evolution",label="WHIS",subtitle="Evolução (prévia)",accent=C.Cyan},
    {id="Traits",label="URAHARA",subtitle="Traits (prévia)",accent=Color3.fromRGB(147,221,156)},
    {id="Raids",label="SUNG JINWOO",subtitle="Raids permanentes (prévia)",accent=Color3.fromRGB(169,130,250)},
    {id="EventHub",label="PRAÇA DOS EVENTOS",subtitle="Evento sazonal (sem evento ativo)",accent=C.Gold},
}
local rows: {[string]: TextButton}={}
local positions: {[string]: Vector3}={
    Story=Vector3.new(260,0,-38),
    Virgil=Vector3.new(233.2,0,-1.8),
    Index=cfg.Stations.Index.Position,
    Alchemy=Vector3.new(301.4,0,-8.5),
    Relics=Vector3.new(350.8,0,20),
    Evolution=cfg.Stations.Evolution.Position,
    Traits=cfg.Stations.Traits.Position,
    Raids=cfg.Stations.Raids.Position,
    EventHub=cfg.EventHub.Position,
}
local function resolveTarget(id: string): BasePart?
    local lobby=Workspace:FindFirstChild("FissureLobby")
    if not lobby then return nil end
    local function path(names: {string}): Instance?
        local cur: Instance?=lobby
        for _,name in ipairs(names) do
            if not cur then return nil end
            cur=cur:FindFirstChild(name)
        end
        return cur
    end
    local result: Instance?
    if id=="Story" then result=path({"ArenaPortal"})
    elseif id=="Virgil" then result=path({"VirgilSummonStand","VirgilNPC","Head"})
    elseif id=="Alchemy" then result=path({"AlchemyWorkshop","AlchemistNPC","Head"})
    elseif id=="Relics" then result=path({"BabylonHall","GilgameshNPC","RelicMasterInteraction"})
    elseif id=="EventHub" then result=path({"LobbyServiceStations","SeasonalEventHub","InteractionPoint"})
    else result=path({"LobbyServiceStations",id.."Station","InteractionPoint"})
    end
    return if result and result:IsA("BasePart") then result else nil
end
local selected: Entry?=nil
local selectedAnchor: BasePart?=nil
local marker: BillboardGui?=nil
local markerLabel: TextLabel?=nil
local function clearMarker()
    if marker then marker:Destroy();marker=nil end
    markerLabel=nil
end
local function markerFor(target: BasePart,entry: Entry)
    clearMarker()
    local board=Instance.new("BillboardGui")
    board.Name="LocalWaypoint_"..entry.id
    board.Adornee=target
    board.Size=UDim2.fromOffset(206,70)
    board.StudsOffsetWorldSpace=Vector3.new(0,6,0)
    board.MaxDistance=260
    board.AlwaysOnTop=true
    board.Parent=gui
    local bg=frame(board,"DestinationCard",UDim2.fromScale(0,0),
        UDim2.fromScale(1,1),C.Panel)
    bg.BackgroundTransparency=.08
    local edge=Instance.new("UIStroke")
    edge.Color=entry.accent;edge.Thickness=2;edge.Parent=bg
    local title=label(bg,"Name","⌖ "..entry.label,
        UDim2.fromOffset(7,6),UDim2.fromOffset(192,32),15,entry.accent,true)
    title.TextXAlignment=Enum.TextXAlignment.Center
    local hint=label(bg,"Distance","",
        UDim2.fromOffset(7,39),UDim2.fromOffset(192,25),12,C.White,true)
    hint.TextXAlignment=Enum.TextXAlignment.Center
    marker=board;markerLabel=hint
end
local function refreshScale()
    local camera=Workspace.CurrentCamera
    if not camera then return end
    -- Use actual ScreenGui bounds, which exclude the Roblox top inset.
    local v=gui.AbsoluteSize
    if v.X<=0 or v.Y<=0 then v=camera.ViewportSize end
    local wide=v.X>=690
    local buttonWidth=math.min(158,math.max(86,math.floor((v.X-38)/2)))
    trigger.Size=UDim2.fromOffset(buttonWidth,38)
    fxButton.Position=UDim2.fromOffset(24+buttonWidth,90)
    fxButton.Size=UDim2.fromOffset(math.min(141,buttonWidth),38)
    local top=137
    local available=math.max(1,v.Y-top-10)
    local factor=math.min(1,math.max(1,v.X-28)/365,available/150)
    local height=math.min(500,math.floor(available/factor))
    scale.Scale=factor
    panel.Size=UDim2.fromOffset(365,height)
    tip.Visible=height>=210
    tip.Position=UDim2.fromOffset(13,height-43)
    scroll.Size=UDim2.fromOffset(344,math.max(44,height-(if tip.Visible then 130 else 88)))
    miniScale.Scale=math.min(1,math.max(1,v.X-28)/345)
    mini.AnchorPoint=if wide then Vector2.new(1,0) else Vector2.new(0,0)
    mini.Position=if wide then UDim2.new(1,-14,0,90) else UDim2.fromOffset(14,137)
end
local function clearDestination()
    selected=nil;selectedAnchor=nil
    mini.Visible=false
    clearMarker()
    for _,row in pairs(rows) do row.BackgroundColor3=C.Inner end
end
local function select(entry: Entry)
    selected=entry
    selectedAnchor=resolveTarget(entry.id)
    panel.Visible=false
    mini.Visible=true
    for id,row in pairs(rows) do
        row.BackgroundColor3=if id==entry.id then C.Electric else C.Inner
    end
    clearMarker()
    if selectedAnchor then markerFor(selectedAnchor,entry) end
end
for i,entry in ipairs(entries) do
    local row=button(scroll,"Destination_"..entry.id,
        entry.label.."    •    "..entry.subtitle,
        UDim2.fromOffset(0,0),UDim2.fromOffset(326,38),C.Inner)
    row.LayoutOrder=i
    row.TextXAlignment=Enum.TextXAlignment.Left
    row.TextSize=12
    rows[entry.id]=row
    row.Activated:Connect(function() select(entry) end)
end
local function setDirectoryVisible(visible: boolean)
    panel.Visible=visible
    mini.Visible=not visible and selected~=nil
end
local function openDirectory()
    if player:GetAttribute("InArena")==true then return end
    local lobbyGui=playerGui:FindFirstChild("AnimeFissureLobbyUI")
    if lobbyGui then
        for _,name in ipairs({"Loading","MissionScrim","GuideScrim"}) do
            local overlay=lobbyGui:FindFirstChild(name)
            if overlay and overlay:IsA("GuiObject") and overlay.Visible then return end
        end
    end
    setDirectoryVisible(not panel.Visible)
    refreshScale()
end
trigger.Activated:Connect(openDirectory)
close.Activated:Connect(function() setDirectoryVisible(false) end)
clear.Activated:Connect(clearDestination)
UserInputService.InputBegan:Connect(function(input: InputObject,processed: boolean)
    if processed then return end
    if input.KeyCode==Enum.KeyCode.M and gui.Enabled then openDirectory() end
    if input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.ButtonB then
        setDirectoryVisible(false)
    end
end)
local function inLobby(): boolean
    return player:GetAttribute("InArena")~=true
end
local function updateVisibility()
    gui.Enabled=inLobby()
    if not gui.Enabled then
        panel.Visible=false
        clearDestination()
    end
end
player:GetAttributeChangedSignal("InArena"):Connect(updateVisibility)
updateVisibility()
local cameraConnection: RBXScriptConnection?=nil
local function bindCamera()
    if cameraConnection then cameraConnection:Disconnect();cameraConnection=nil end
    local camera=Workspace.CurrentCamera
    if camera then cameraConnection=camera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshScale) end
    refreshScale()
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
gui:GetPropertyChangedSignal("AbsoluteSize"):Connect(refreshScale)
bindCamera()
task.spawn(function()
    while gui.Parent do
        if selected and inLobby() then
            local target=selectedAnchor
            if not target or not target.Parent then
                target=resolveTarget(selected.id)
                selectedAnchor=target
                if target then markerFor(target,selected) end
            end
            local character=player.Character
            local root=if character then character:FindFirstChild("HumanoidRootPart") else nil
            local worldPos=if target then target.Position else positions[selected.id]
            if root and root:IsA("BasePart") then
                local meters=math.floor((root.Position-worldPos).Magnitude+.5)
                local msg=selected.label.." • "..tostring(meters).." studs"
                waypointText.Text=msg
                if markerLabel then markerLabel.Text=tostring(meters).." studs" end
                -- The destination should never look "completed" until close.
                if meters<13 then waypointText.Text=selected.label.." • VOCÊ CHEGOU" end
            else waypointText.Text=selected.label.." • LOCALIZANDO…" end
            if not target then
                waypointText.Text=selected.label.." • CARREGANDO CENÁRIO"
            end
        end
        task.wait(.35)
    end
end)
print("[Anime Fissure] LOBBY NAVIGATOR v1.0: 9 stations, distance and visual waypoint")
