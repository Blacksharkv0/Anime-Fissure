--!strict
-- ANIME FISSURE | Evolution / Traits / Permanent Raids / Event Hub v1.0
-- Only UI descriptions received through validated server NPC prompts.
-- NO buttons to submit requests for unfinished gameplay features.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local player=Players.LocalPlayer
local playerGui=player:WaitForChild("PlayerGui")
local Config=require(RS:WaitForChild("Shared"):WaitForChild("LobbyServiceConfig"))

local old=playerGui:FindFirstChild("AnimeFissureLobbyServicesHUD")
if old then old:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="AnimeFissureLobbyServicesHUD"
gui.ResetOnSpawn=false;gui.Enabled=false
gui.DisplayOrder=175
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Parent=playerGui

local C={
    Back=Color3.fromRGB(9,11,23),
    Panel=Color3.fromRGB(24,29,48),
    Inner=Color3.fromRGB(34,39,65),
    White=Color3.fromRGB(248,248,255),
    Muted=Color3.fromRGB(177,188,213),
    Gold=Color3.fromRGB(255,216,134),
}
local function frame(parent: Instance,name: string,pos: UDim2,
    size: UDim2,col: Color3,radius: number)
    local f=Instance.new("Frame")
    f.Name=name;f.Size=size;f.Position=pos;f.BackgroundColor3=col
    f.BorderSizePixel=0;f.Parent=parent
    local u=Instance.new("UICorner")
    u.CornerRadius=UDim.new(0,radius)
    u.Parent=f;return f
end
local function txt(parent: Instance,name: string,value: string,pos: UDim2,
    size: UDim2,fontSize: number,color: Color3,bold: boolean?)
    local t=Instance.new("TextLabel")
    t.Name=name;t.Text=value;t.Position=pos;t.Size=size
    t.BackgroundTransparency=1
    t.TextColor3=color;t.TextSize=fontSize
    t.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.TextYAlignment=Enum.TextYAlignment.Center
    t.TextWrapped=true;t.Parent=parent
    return t
end
local bg=frame(gui,"Backdrop",UDim2.fromScale(0,0),
    UDim2.fromScale(1,1),C.Back,0)
bg.BackgroundTransparency=.2;bg.Active=true
local root=frame(bg,"StationInfo",UDim2.fromScale(.5,.5),
    UDim2.fromOffset(745,501),C.Panel,15)
root.AnchorPoint=Vector2.new(.5,.5)
local scaler=Instance.new("UIScale")
scaler.Parent=root
local border=Instance.new("UIStroke")
border.Color=C.Gold;border.Thickness=1.8;border.Parent=root
local brand=txt(root,"Brand","ANIME FISSURE • ESTAÇÃO ESPECIAL",
    UDim2.fromOffset(25,15),UDim2.fromOffset(640,25),12,C.Gold,true)
local header=txt(root,"Header","",
    UDim2.fromOffset(24,47),UDim2.fromOffset(661,47),24,C.White,true)
local npcTitle=txt(root,"NPC","",
    UDim2.fromOffset(25,95),UDim2.fromOffset(625,26),13,C.Gold,true)
local close=Instance.new("TextButton")
close.Name="Close";close.Text="✕";close.Position=UDim2.fromOffset(678,14)
close.Size=UDim2.fromOffset(47,41)
close.BackgroundColor3=C.Inner;close.TextColor3=C.White
close.Font=Enum.Font.GothamBold;close.TextSize=19
close.Parent=root
Instance.new("UICorner",close).CornerRadius=UDim.new(0,9)

local divider=frame(root,"GoldRule",UDim2.fromOffset(26,134),
    UDim2.fromOffset(686,2),C.Gold,0)
local subtitle=txt(root,"Subtitle","",
    UDim2.fromOffset(25,150),UDim2.fromOffset(673,38),17,C.White,true)
local description=txt(root,"Description","",
    UDim2.fromOffset(25,202),UDim2.fromOffset(673,71),15,C.Muted)
description.TextYAlignment=Enum.TextYAlignment.Top
local modules=frame(root,"Features",UDim2.fromOffset(25,282),
    UDim2.fromOffset(696,139),C.Inner,10)
local modulesTitle=txt(modules,"ModulesTitle","FUNÇÕES PLANEJADAS",
    UDim2.fromOffset(14,8),UDim2.fromOffset(665,24),13,C.Gold,true)
local features: {TextLabel}={}
for i=1,4 do
    features[i]=txt(modules,"Feature"..i,"",
        UDim2.fromOffset(17,32+(i-1)*25),
        UDim2.fromOffset(660,24),14,C.White)
end
local status=txt(root,"Availability",
    "MECÂNICA EM DESENVOLVIMENTO",
    UDim2.fromOffset(27,430),UDim2.fromOffset(687,47),
    14,C.Gold,true)
status.TextYAlignment=Enum.TextYAlignment.Top

local function scale()
    local camera=Workspace.CurrentCamera
    if not camera then return end
    local v=camera.ViewportSize
    scaler.Scale=math.clamp(math.min((v.X-16)/761,(v.Y-24)/525,1),.45,1)
end
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(scale)
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(scale)

local savedLobby: boolean?=nil
local function hideLobby(on: boolean)
    local lobby=playerGui:FindFirstChild("AnimeFissureLobbyUI")
    if not lobby or not lobby:IsA("ScreenGui") then return end
    if on then
        if savedLobby==nil then savedLobby=lobby.Enabled end
        lobby.Enabled=false
    elseif savedLobby~=nil then
        lobby.Enabled=savedLobby and player:GetAttribute("InArena")~=true
        savedLobby=nil
    end
end
local function closeHud()
    gui.Enabled=false
    hideLobby(false)
end
close.Activated:Connect(closeHud)
player:GetAttributeChangedSignal("InArena"):Connect(function()
    if player:GetAttribute("InArena")==true then closeHud() end
end)
UIS.InputBegan:Connect(function(input: InputObject,processed: boolean)
    if processed or not gui.Enabled then return end
    if input.KeyCode==Enum.KeyCode.Escape
        or input.KeyCode==Enum.KeyCode.ButtonB then closeHud() end
end)
local function openInfo(id: string)
    if player:GetAttribute("InArena")==true then return end
    local info=Config.Get(id)
    if not info then return end
    border.Color=info.Accent
    header.Text=info.Name
    header.TextColor3=info.Accent
    npcTitle.Text=info.NPC.." • "..info.Title
    subtitle.Text=info.Subtitle
    description.Text=info.Description
    local items=info.Features or {}
    if id=="EventHub" then
        local current=Config.GetEvent()
        local preview=if RunService:IsStudio() then Config.GetEventPreview() else nil
        if current then
            npcTitle.Text=current.NPC.." • EVENTO SAZONAL"
            subtitle.Text=current.Name
            description.Text="Evento listado no catálogo. A entrada da raid ainda exige fase real, equipe e validação do servidor."
        elseif preview then
            npcTitle.Text="ESCANOR • PRÉVIA DE DESIGN NO STUDIO"
            subtitle.Text="EXEMPLO DE EVENTO: NANATSU"
            description.Text="Escanor representa a ideia de um anfitrião temporário que abre a raid do seu evento. Este exemplo NÃO está ativo e não concede recompensas."
        else
            npcTitle.Text="ANFITRIÃO DO MÊS • A DEFINIR"
            subtitle.Text="A PRAÇA DOS EVENTOS ESTÁ RESERVADA"
            description.Text="Aqui aparecerá o personagem escolhido para cada evento. Sua raid exclusiva só ficará disponível após o evento existir de verdade."
        end
        items={"Personagem e decoração temporários",
            "Raid exclusiva vinculada ao evento",
            "Recompensas e datas confirmadas pelo servidor",
            "Retirada do anfitrião quando o evento terminar"}
    end
    for i,l in ipairs(features) do
        l.Text=if typeof(items[i])=="string" then "✦ "..items[i] else ""
    end
    status.Text="AGUARDANDO IMPLEMENTAÇÃO • "..
        (info.DisabledReason or "Funcionalidade não disponível")
    status.TextColor3=C.Gold
    gui.Enabled=true
    hideLobby(true)
    scale()
end
task.spawn(function()
    local folder=RS:WaitForChild("LobbyServicesRemotes",70)
    if not folder or not folder:IsA("Folder") then
        warn("[Anime Fissure] Lobby Services UI: no server remotes")
        return
    end
    local open=folder:WaitForChild("OpenServiceInfo",20)
    if open and open:IsA("RemoteEvent") then
        open.OnClientEvent:Connect(function(id: any)
            if typeof(id)=="string" then openInfo(id) end
        end)
    end
end)
print("[Anime Fissure] UNIVERSAL LOBBY SERVICES UI v1 | NPC-validated previews only")
