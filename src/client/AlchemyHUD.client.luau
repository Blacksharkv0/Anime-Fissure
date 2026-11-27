--!strict
-- ANIME FISSURE | Edward Alchemy HUD v0.2
-- EXCLUSIVE domain: orbs, alchemy and transmutation of crafting materials.
-- All relic catalog, equipment, relic reroll and relic evolution moved
-- to Gilgamesh's Hall of Babylon. No ownership data is invented.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local TweenService=game:GetService("TweenService")
local Workspace=game:GetService("Workspace")
local player=Players.LocalPlayer
local playerGui=player:WaitForChild("PlayerGui")
local remotes=ReplicatedStorage:WaitForChild("AlchemyRemotes")
local openRemote=remotes:WaitForChild("OpenWorkshop") :: RemoteEvent
local snapshotRemote=remotes:WaitForChild("GetWorkshopSnapshot") :: RemoteFunction

local C={
    Ink=Color3.fromRGB(9,15,30),Panel=Color3.fromRGB(21,29,52),
    Inner=Color3.fromRGB(31,43,67),Cyan=Color3.fromRGB(84,223,255),
    Blue=Color3.fromRGB(60,126,248),Gold=Color3.fromRGB(247,193,102),
    Muted=Color3.fromRGB(174,195,219),White=Color3.fromRGB(246,247,253),
    Red=Color3.fromRGB(240,118,132),
}
local old=playerGui:FindFirstChild("AnimeFissureAlchemyHUD")
if old then old:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="AnimeFissureAlchemyHUD";gui.DisplayOrder=150
gui.ResetOnSpawn=false;gui.Enabled=false
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling;gui.Parent=playerGui
local background=Instance.new("Frame")
background.Name="Backdrop";background.Size=UDim2.fromScale(1,1)
background.BackgroundColor3=C.Ink;background.BackgroundTransparency=0.13
background.BorderSizePixel=0;background.Active=true
background.Parent=gui

local function box(parent: Instance,name: string,position: UDim2,size: UDim2,
    color: Color3,radius: number)
    local f=Instance.new("Frame")
    f.Name=name;f.Size=size;f.Position=position;f.BackgroundColor3=color
    f.BorderSizePixel=0;f.Parent=parent
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,radius);corner.Parent=f
    return f
end
local function txt(parent: Instance,name: string,content: string,
    position: UDim2,size: UDim2,fontSize: number,color: Color3,bold: boolean?)
    local t=Instance.new("TextLabel")
    t.Name=name;t.Text=content;t.Position=position;t.Size=size
    t.TextColor3=color;t.TextSize=fontSize
    t.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    t.BackgroundTransparency=1;t.TextXAlignment=Enum.TextXAlignment.Left
    t.TextYAlignment=Enum.TextYAlignment.Center;t.TextWrapped=true
    t.Parent=parent
    return t
end
local function button(parent: Instance,name: string,content: string,
    position: UDim2,size: UDim2,color: Color3)
    local b=Instance.new("TextButton")
    b.Name=name;b.Text=content;b.Position=position;b.Size=size
    b.BackgroundColor3=color;b.TextColor3=C.White
    b.Font=Enum.Font.GothamBold;b.TextSize=15;b.TextWrapped=true
    b.BorderSizePixel=0;b.Parent=parent
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,9);corner.Parent=b
    return b
end

local root=box(background,"AlchemyWindow",UDim2.fromScale(0.5,0.5),
    UDim2.fromOffset(920,575),C.Panel,14)
root.AnchorPoint=Vector2.new(0.5,0.5)
local uiScale=Instance.new("UIScale");uiScale.Parent=root
local function refreshScale()
    local camera=Workspace.CurrentCamera
    if not camera then return end
    local v=camera.ViewportSize
    uiScale.Scale=math.clamp(math.min((v.X-20)/940,(v.Y-20)/595,1),0.43,1)
end
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshScale)
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(refreshScale)

txt(root,"Title","⚗  OFICINA DE TRANSMUTAÇÃO",
    UDim2.fromOffset(24,17),UDim2.fromOffset(780,44),26,C.White,true)
txt(root,"Subtitle","EDWARD • ALQUIMIA / ORBES / MATERIAIS",
    UDim2.fromOffset(26,61),UDim2.fromOffset(700,23),13,C.Cyan,true)
local close=button(root,"Close","✕",UDim2.fromOffset(853,20),
    UDim2.fromOffset(48,41),C.Inner)
local tabs={"Orbes","Materiais","Transmutação","Informações"}
local buttons: {[string]: TextButton}={}
for i,tab in ipairs(tabs) do
    buttons[tab]=button(root,"Tab_"..i,tab,
        UDim2.fromOffset(23+(i-1)*222,102),
        UDim2.fromOffset(211,41),C.Inner)
end

local main=box(root,"AlchemyBody",UDim2.fromOffset(22,159),
    UDim2.fromOffset(876,357),C.Ink,12)
local title=txt(main,"Mode","ORBis • ESTUDO DOS ORBES",
    UDim2.fromOffset(29,22),UDim2.fromOffset(800,34),21,C.Cyan,true)
local description=txt(main,"Explanation","",
    UDim2.fromOffset(31,69),UDim2.fromOffset(797,94),17,C.White)
description.TextYAlignment=Enum.TextYAlignment.Top

-- Edward's authentic specialty is an alchemical transmutation circle.
local circle=box(main,"TransmutationCircle",UDim2.fromOffset(87,179),
    UDim2.fromOffset(180,160),C.Panel,20)
for i,radius in ipairs({140,103,63}) do
    local rim=box(circle,"Rim"..i,UDim2.fromOffset(90-radius/2,80-radius/2),
        UDim2.fromOffset(radius,radius),C.Panel,radius)
    rim.BackgroundTransparency=1
    local stroke=Instance.new("UIStroke")
    stroke.Color=if i==1 then C.Cyan elseif i==2 then C.Gold else C.Blue
    stroke.Thickness=2;stroke.Transparency=0.18;stroke.Parent=rim
end
local sigil=txt(circle,"CircleCore","◇",UDim2.fromOffset(0,0),
    UDim2.fromScale(1,1),72,C.Cyan,true)
sigil.TextXAlignment=Enum.TextXAlignment.Center

local ingredients=txt(main,"IngredientInventory",
    "MATERIAIS: AINDA NÃO CONECTADOS",
    UDim2.fromOffset(315,184),UDim2.fromOffset(526,43),18,C.Gold,true)
local note=txt(main,"SafetyNote",
    "A transmutação só será habilitada com receitas, saldo e materiais reais confirmados pelo servidor.",
    UDim2.fromOffset(316,230),UDim2.fromOffset(521,68),14,C.Muted)
local transmute=button(main,"Transmute","TRANSMUTAR • BLOQUEADO",
    UDim2.fromOffset(316,307),UDim2.fromOffset(519,35),C.Inner)
transmute.Active=false;transmute.AutoButtonColor=false

local bottom=txt(root,"Footer",
    "ALQUIMIA • Nenhuma moeda ou item será concedido neste protótipo.",
    UDim2.fromOffset(27,531),UDim2.fromOffset(847,28),13,C.Muted)
bottom.TextXAlignment=Enum.TextXAlignment.Center

local tabInfo={
    ["Orbes"]={
        "ORbes • OFICINA DE EDWARD",
        "Prepare orbes e estruturas alquímicas. Nenhuma receita foi ativada nesta beta, mas este é o local oficial das futuras sínteses de orbes."
    },
    ["Materiais"]={
        "MATERIAIS ALQUÍMICOS",
        "Consulte os componentes da oficina e prepare recursos de transmutação. A mochila real e suas quantidades serão ligadas aqui quando o inventário estiver pronto."
    },
    ["Transmutação"]={
        "CÍRCULO DE TRANSMUTAÇÃO",
        "Edward realizará apenas transformações alquímicas de materiais e orbes. Os itens devem existir no inventário antes de habilitarmos qualquer receita."
    },
    ["Informações"]={
        "AS LEIS DA ALQUIMIA",
        "Toda síntese exige ingredientes e uma receita válida. Quando o sistema estiver ativo, o servidor verificará recursos, custo e confirmação antes de consumir qualquer coisa."
    },
}
local function selectTab(tab: string)
    local data=tabInfo[tab]
    if not data then return end
    title.Text=data[1];description.Text=data[2]
    for name,b in pairs(buttons) do
        b.BackgroundColor3=if name==tab then C.Blue else C.Inner
    end
end
for name,b in pairs(buttons) do
    b.Activated:Connect(function() selectTab(name) end)
end
selectTab("Orbes")

local savedLobby: boolean?=nil
local function hideLobby(hidden: boolean)
    local lobby=playerGui:FindFirstChild("AnimeFissureLobbyUI")
    if not lobby or not lobby:IsA("ScreenGui") then return end
    if hidden then
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
openRemote.OnClientEvent:Connect(function()
    if player:GetAttribute("InArena")==true then return end
    local ok,snapshot=pcall(function()
        return snapshotRemote:InvokeServer()
    end)
    if not ok or typeof(snapshot)~="table" then
        warn("[Anime Fissure] Edward: snapshot da oficina indisponível")
        return
    end
    -- NEVER assume inventory exists. Server currently exposes empty data.
    local count=0
    if typeof(snapshot.Inventory)=="table" then
        for _,item in ipairs(snapshot.Inventory) do
            if typeof(item)=="table" and typeof(item.Id)=="string"
                and typeof(item.Amount)=="number" and item.Amount>0 then
                count+=1
            end
        end
    end
    ingredients.Text=if snapshot.GoldConnected==true
        then "MATERIAIS ALQUÍMICOS: "..tostring(count)
        else "MATERIAIS: INVENTÁRIO NÃO CONECTADO"
    transmute.Active=false
    transmute.AutoButtonColor=false
    transmute.Text="TRANSMUTAR • BLOQUEADO"
    bottom.Text="ALQUIMIA • "..(if typeof(snapshot.ProfileStatus)=="string"
        then snapshot.ProfileStatus else "Aguardando backend real")
    selectTab("Orbes")
    gui.Enabled=true
    hideLobby(true)
    root.BackgroundColor3=C.Inner
    TweenService:Create(root,TweenInfo.new(0.20),
        {BackgroundColor3=C.Panel}):Play()
    refreshScale()
end)

print("[Anime Fissure] EDWARD ALCHEMY v0.2 | orbs, materials and transmutation only")
