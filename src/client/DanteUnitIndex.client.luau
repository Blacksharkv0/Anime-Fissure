--!strict
-- ANIME FISSURE | Dante's Universal Unit Index v1.0 (read-only)
-- This is an index of registered units, NOT the player's owned Collection.
-- Opens only via server-validated Dante LobbyServicePrompt.
-- No summon, account data, item grants, discovery or ownership claims.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local UIS=game:GetService("UserInputService")

local player=Players.LocalPlayer
local parent=player:WaitForChild("PlayerGui")
local Catalog=require(RS:WaitForChild("Shared"):WaitForChild("UnitIndexCatalog"))
local C={
    Back=Color3.fromRGB(10,12,22),
    Panel=Color3.fromRGB(30,26,40),
    Surface=Color3.fromRGB(40,37,55),
    Red=Color3.fromRGB(234,67,91),
    Pale=Color3.fromRGB(249,241,229),
    Muted=Color3.fromRGB(187,180,197),
    Gold=Color3.fromRGB(248,209,137),
    Blue=Color3.fromRGB(99,175,252),
}
local old=parent:FindFirstChild("DanteUnitIndex")
if old then old:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="DanteUnitIndex";gui.DisplayOrder=185
gui.ResetOnSpawn=false;gui.Enabled=false
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;gui.Parent=parent

local function frame(where: Instance,name: string,pos: UDim2,
    size: UDim2,color: Color3,radius: number): Frame
    local f=Instance.new("Frame")
    f.Name=name;f.Position=pos;f.Size=size
    f.BackgroundColor3=color;f.BorderSizePixel=0;f.Parent=where
    local rounded=Instance.new("UICorner")
    rounded.CornerRadius=UDim.new(0,radius);rounded.Parent=f
    return f
end
local function label(where: Instance,name: string,value: string,pos: UDim2,
    size: UDim2,fontSize: number,color: Color3,bold: boolean?): TextLabel
    local x=Instance.new("TextLabel")
    x.Name=name;x.Text=value;x.Position=pos;x.Size=size
    x.BackgroundTransparency=1;x.TextColor3=color
    x.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    x.TextSize=fontSize;x.TextWrapped=true
    x.TextXAlignment=Enum.TextXAlignment.Left
    x.TextYAlignment=Enum.TextYAlignment.Center
    x.Parent=where;return x
end
local function button(where: Instance,name: string,value: string,pos: UDim2,
    size: UDim2,color: Color3): TextButton
    local b=Instance.new("TextButton")
    b.Name=name;b.Text=value;b.Size=size;b.Position=pos
    b.BackgroundColor3=color;b.BorderSizePixel=0
    b.TextWrapped=true;b.TextColor3=C.Pale
    b.Font=Enum.Font.GothamBold;b.TextSize=13
    b.Parent=where
    local round=Instance.new("UICorner")
    round.CornerRadius=UDim.new(0,8);round.Parent=b
    return b
end
local back=frame(gui,"Backdrop",UDim2.fromScale(0,0),
    UDim2.fromScale(1,1),C.Back,0)
back.BackgroundTransparency=.18;back.Active=true
local root=frame(back,"HunterArchive",UDim2.fromScale(.5,.5),
    UDim2.fromOffset(890,554),C.Panel,15)
root.AnchorPoint=Vector2.new(.5,.5)
local stroke=Instance.new("UIStroke")
stroke.Thickness=1.6;stroke.Color=C.Red;stroke.Parent=root
local scale=Instance.new("UIScale");scale.Parent=root

label(root,"Title","DANTE  •  INDEX DOS UNIVERSOS",
    UDim2.fromOffset(23,15),UDim2.fromOffset(765,43),25,C.Pale,true)
label(root,"Subtitle","ARQUIVO DOS CAÇADORES — PERSONAGENS DE TODOS OS MUNDOS",
    UDim2.fromOffset(25,59),UDim2.fromOffset(755,24),12,C.Red,true)
local close=button(root,"Close","✕",
    UDim2.fromOffset(824,16),UDim2.fromOffset(48,42),C.Surface)

local filterBar=frame(root,"UniverseFilters",UDim2.fromOffset(18,100),
    UDim2.fromOffset(855,50),C.Surface,10)
local categories={"Todos","Overlord","Dragon Ball"}
local filters: {[string]: TextButton}={}
for i,name in ipairs(categories) do
    filters[name]=button(filterBar,"Filter_"..i,name,
        UDim2.fromOffset(10+(i-1)*278,8),
        UDim2.fromOffset(267,34),C.Panel)
end

local listPanel=frame(root,"UnitListPanel",UDim2.fromOffset(18,160),
    UDim2.fromOffset(375,337),C.Surface,10)
label(listPanel,"ListTitle","UNIDADES CADASTRADAS",
    UDim2.fromOffset(11,8),UDim2.fromOffset(350,28),14,C.Gold,true)
local list=Instance.new("ScrollingFrame")
list.Name="IndexScroll";list.Position=UDim2.fromOffset(9,42)
list.Size=UDim2.fromOffset(355,286)
list.BackgroundTransparency=1;list.BorderSizePixel=0
list.CanvasSize=UDim2.fromOffset(0,0)
list.ScrollBarThickness=4;list.ScrollBarImageColor3=C.Red
list.Parent=listPanel
local stack=Instance.new("UIListLayout")
stack.Padding=UDim.new(0,6)
stack.SortOrder=Enum.SortOrder.LayoutOrder;stack.Parent=list

local card=frame(root,"UnitDetail",UDim2.fromOffset(404,160),
    UDim2.fromOffset(468,337),C.Surface,10)
local unitName=label(card,"UnitName","",
    UDim2.fromOffset(16,16),UDim2.fromOffset(436,46),
    22,C.Pale,true)
local rarity=label(card,"UnitRarity","",
    UDim2.fromOffset(17,66),UDim2.fromOffset(432,25),
    15,C.Gold,true)
local universe=label(card,"Universe","",
    UDim2.fromOffset(17,105),UDim2.fromOffset(434,27),
    14,C.Blue,true)
local method=label(card,"ObtainedBy","",
    UDim2.fromOffset(17,145),UDim2.fromOffset(434,57),
    15,C.Pale)
local description=label(card,"Description","",
    UDim2.fromOffset(17,207),UDim2.fromOffset(434,55),
    13,C.Muted)
local ownership=label(card,"OwnedState",
    "COLEÇÃO PESSOAL: INVENTÁRIO AINDA NÃO CONECTADO",
    UDim2.fromOffset(17,272),UDim2.fromOffset(435,55),
    13,C.Red,true)
local footer=label(root,"Footer",
    "INDEX ≠ COLEÇÃO. Exibir uma unidade aqui NÃO significa que você a possui.",
    UDim2.fromOffset(26,509),UDim2.fromOffset(835,29),12,C.Muted)
footer.TextXAlignment=Enum.TextXAlignment.Center

local selected: any=nil
local chosen="Todos"
local rarityColors={
    Common=Color3.fromRGB(198,203,217),
    Rare=Color3.fromRGB(96,167,255),
    Epic=Color3.fromRGB(196,112,244),
    Legendary=Color3.fromRGB(251,202,94),
    Mythic=Color3.fromRGB(248,91,138),
    Secret=Color3.fromRGB(255,234,172),
}
local function draw()
    for _,obj in ipairs(list:GetChildren()) do
        if obj:IsA("TextButton") then obj:Destroy() end
    end
    local units=Catalog.GetWorld(chosen)
    if not selected or not table.find(
        (function()
            local ids={}
            for _,entry in ipairs(units) do table.insert(ids,entry.Id) end
            return ids
        end)(),selected.Id) then
        selected=units[1]
    end
    if selected then
        unitName.Text=selected.Name
        rarity.Text=string.upper(selected.Rarity)
        rarity.TextColor3=rarityColors[selected.Rarity] or C.Gold
        universe.Text="UNIVERSO: "..selected.World
        method.Text="OBTENÇÃO: "..selected.ObtainMethod
        description.Text=selected.Description.."  •  "..selected.Status
        ownership.Text="COLEÇÃO: "..Catalog.GetOwnershipState(nil,selected.Id)
    end
    for i,entry in ipairs(units) do
        local b=button(list,"Unit_"..entry.Id,
            entry.Name.."    •    "..entry.Rarity,
            UDim2.fromOffset(0,0),UDim2.fromOffset(338,51),
            if selected and selected.Id==entry.Id then C.Red else C.Panel)
        b.LayoutOrder=i;b.TextSize=13
        b.Activated:Connect(function()
            selected=entry;draw()
        end)
    end
    list.CanvasSize=UDim2.fromOffset(0,#units*57)
    for id,b in pairs(filters) do
        b.BackgroundColor3=if id==chosen then C.Red else C.Panel
    end
end
for id,b in pairs(filters) do
    b.Activated:Connect(function()
        chosen=id;selected=nil;draw()
    end)
end
local function resize()
    local cam=Workspace.CurrentCamera
    if not cam then return end
    local v=cam.ViewportSize
    scale.Scale=math.clamp(math.min((v.X-18)/910,(v.Y-18)/578,1),.39,1)
end
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(resize)
local savedLobby: boolean?=nil
local function hideLobby(on: boolean)
    local lobby=parent:FindFirstChild("AnimeFissureLobbyUI")
    if not lobby or not lobby:IsA("ScreenGui") then return end
    if on then
        if savedLobby==nil then savedLobby=lobby.Enabled end
        lobby.Enabled=false
    elseif savedLobby~=nil then
        lobby.Enabled=savedLobby and player:GetAttribute("InArena")~=true
        savedLobby=nil
    end
end
local function setOpen(open: boolean)
    gui.Enabled=open and player:GetAttribute("InArena")~=true
    hideLobby(gui.Enabled)
    if gui.Enabled then
        chosen="Todos";selected=nil;draw();resize()
    end
end
close.Activated:Connect(function() setOpen(false) end)
player:GetAttributeChangedSignal("InArena"):Connect(function()
    if player:GetAttribute("InArena")==true then setOpen(false) end
end)
UIS.InputBegan:Connect(function(input: InputObject,processed: boolean)
    if processed or not gui.Enabled then return end
    if input.KeyCode==Enum.KeyCode.Escape
        or input.KeyCode==Enum.KeyCode.ButtonB then setOpen(false) end
end)
task.spawn(function()
    local remotes=RS:WaitForChild("LobbyServicesRemotes",75)
    if not remotes or not remotes:IsA("Folder") then return end
    local open=remotes:WaitForChild("OpenServiceInfo",20)
    if open and open:IsA("RemoteEvent") then
        open.OnClientEvent:Connect(function(id: any)
            if id=="Index" then setOpen(true) end
        end)
    end
end)
print("[Anime Fissure] DANTE INDEX ONLINE: all universes, 8 registered units, no fake ownership")
