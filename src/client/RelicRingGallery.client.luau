--!strict
-- ANIME FISSURE | Gilgamesh's Universal Relic Vault v2.0
-- All anime-world relics live under GILGAMESH, never Edward.
-- Opened ONLY via server-authorized BabylonRelicPrompt -> OpenRelicCatalog.
-- Catalog = READ ONLY. Equip, Evolve and Reroll are explicit future systems.
-- Do not simulate ownership, rolls, materials or currency.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")
local player=Players.LocalPlayer
local guiParent=player:WaitForChild("PlayerGui")
local Shared=RS:WaitForChild("Shared")
local Catalog=require(Shared:WaitForChild("UniversalRelicCatalog"))
local Rings=require(Shared:WaitForChild("RelicRingConfig"))
local Builder=require(Shared:WaitForChild("RelicRingModelBuilder"))

local C={
    Onyx=Color3.fromRGB(12,14,25),Panel=Color3.fromRGB(26,24,39),
    Stone=Color3.fromRGB(37,34,53),Glass=Color3.fromRGB(45,42,59),
    Gold=Color3.fromRGB(241,199,100),Pale=Color3.fromRGB(255,231,174),
    Ruby=Color3.fromRGB(192,49,79),White=Color3.fromRGB(246,242,232),
    Muted=Color3.fromRGB(175,171,184),Blue=Color3.fromRGB(91,157,252),
}
local old=guiParent:FindFirstChild("RelicRingGallery")
if old then old:Destroy() end
local screen=Instance.new("ScreenGui")
screen.Name="RelicRingGallery";screen.DisplayOrder=190
screen.ResetOnSpawn=false;screen.Enabled=false
screen.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
screen.Parent=guiParent

local function panel(parent: Instance,name: string,pos: UDim2,size: UDim2,
    color: Color3,corner: number)
    local f=Instance.new("Frame")
    f.Name=name;f.Position=pos;f.Size=size;f.BackgroundColor3=color
    f.BorderSizePixel=0;f.Parent=parent
    local u=Instance.new("UICorner")
    u.CornerRadius=UDim.new(0,corner);u.Parent=f
    return f
end
local function label(parent: Instance,name: string,content: string,
    pos: UDim2,size: UDim2,fontSize: number,color: Color3,
    strong: boolean?)
    local t=Instance.new("TextLabel")
    t.Name=name;t.Text=content;t.Position=pos;t.Size=size
    t.BackgroundTransparency=1;t.TextColor3=color;t.TextSize=fontSize
    t.Font=if strong then Enum.Font.GothamBold else Enum.Font.Gotham
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.TextYAlignment=Enum.TextYAlignment.Center
    t.TextWrapped=true;t.Parent=parent
    return t
end
local function button(parent: Instance,name: string,title: string,
    pos: UDim2,size: UDim2,color: Color3)
    local t=Instance.new("TextButton")
    t.Name=name;t.Text=title;t.Position=pos;t.Size=size
    t.BackgroundColor3=color;t.TextColor3=C.White
    t.Font=Enum.Font.GothamBold;t.TextSize=14;t.TextWrapped=true
    t.BorderSizePixel=0;t.Parent=parent
    local u=Instance.new("UICorner")
    u.CornerRadius=UDim.new(0,8);u.Parent=t
    return t
end
local shade=panel(screen,"Backdrop",UDim2.fromScale(0,0),
    UDim2.fromScale(1,1),C.Onyx,0)
shade.BackgroundTransparency=0.13;shade.Active=true
local root=panel(shade,"BabylonVault",UDim2.fromScale(0.5,0.5),
    UDim2.fromOffset(950,588),C.Panel,13)
root.AnchorPoint=Vector2.new(0.5,0.5)
local outline=Instance.new("UIStroke")
outline.Color=C.Gold;outline.Thickness=1.8;outline.Parent=root
local uiScale=Instance.new("UIScale");uiScale.Parent=root

label(root,"Title","✦ SALÃO DA BABILÔNIA",
    UDim2.fromOffset(21,10),UDim2.fromOffset(710,35),26,C.Pale,true)
label(root,"Subtitle","GILGAMESH • MESTRE DE TODAS AS RELÍQUIAS",
    UDim2.fromOffset(23,43),UDim2.fromOffset(690,22),12,C.Gold,true)
local close=button(root,"Close","✕",UDim2.fromOffset(888,14),
    UDim2.fromOffset(42,39),C.Stone)
local tabs={"CATÁLOGO","EQUIPAR","EVOLUIR","REROLL","INFORMAÇÕES"}
local tabsByName: {[string]: TextButton}={}
for i,name in ipairs(tabs) do
    tabsByName[name]=button(root,"Tab_"..i,name,
        UDim2.fromOffset(18+(i-1)*185,79),
        UDim2.fromOffset(175,38),C.Stone)
end
local body=panel(root,"CatalogArea",UDim2.fromOffset(17,127),
    UDim2.fromOffset(916,412),C.Onyx,10)

-- Left: multi-world catalogs / special concepts, all server-unowned.
local side=panel(body,"Library",UDim2.fromOffset(10,11),
    UDim2.fromOffset(255,389),C.Stone,9)
label(side,"LibraryTitle","TESOUROS DE TODOS OS MUNDOS",
    UDim2.fromOffset(10,10),UDim2.fromOffset(232,37),14,C.Pale,true)
local filters={"Anéis","Conceitos"}
local filterButtons: {[string]: TextButton}={}
for i,kind in ipairs(filters) do
    filterButtons[kind]=button(side,"Filter_"..i,string.upper(kind),
        UDim2.fromOffset(9+(i-1)*119,56),
        UDim2.fromOffset(110,30),C.Glass)
end
local scroll=Instance.new("ScrollingFrame")
scroll.Name="Relics";scroll.Position=UDim2.fromOffset(9,95)
scroll.Size=UDim2.fromOffset(238,281)
scroll.ScrollBarThickness=4;scroll.ScrollBarImageColor3=C.Gold
scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0
scroll.CanvasSize=UDim2.fromOffset(0,0);scroll.Parent=side
local layout=Instance.new("UIListLayout")
layout.SortOrder=Enum.SortOrder.LayoutOrder
layout.Padding=UDim.new(0,5);layout.Parent=scroll

-- Right: three dimensional preview + exact planned effects.
local center=panel(body,"RelicPreview",UDim2.fromOffset(273,11),
    UDim2.fromOffset(347,389),C.Panel,9)
local viewport=Instance.new("ViewportFrame")
viewport.Name="Ring3DPreview"
viewport.Size=UDim2.fromOffset(329,307)
viewport.Position=UDim2.fromOffset(9,10)
viewport.BackgroundColor3=C.Onyx
viewport.BorderSizePixel=0
viewport.Ambient=Color3.fromRGB(180,184,218)
viewport.LightColor=Color3.fromRGB(245,222,171)
viewport.LightDirection=Vector3.new(-1,-2,-1)
viewport.Parent=center
local camera=Instance.new("Camera")
camera.CFrame=CFrame.lookAt(Vector3.new(0,0,-8.4),Vector3.zero)
camera.Parent=viewport;viewport.CurrentCamera=camera
local world=Instance.new("WorldModel")
world.Parent=viewport
local conceptMessage=label(center,"ConceptPreview",
    "CONCEITO ARQUIVADO\n\nModelo 3D ainda não criado",
    UDim2.fromOffset(21,70),UDim2.fromOffset(304,200),
    22,C.Gold,true)
conceptMessage.TextXAlignment=Enum.TextXAlignment.Center
conceptMessage.Visible=false
label(center,"PreviewFooter","MODELO 3D • VISUALIZAÇÃO",
    UDim2.fromOffset(14,329),UDim2.fromOffset(320,37),12,C.Muted,true)

local info=panel(body,"RelicInfo",UDim2.fromOffset(628,11),
    UDim2.fromOffset(278,389),C.Stone,9)
local itemTitle=label(info,"ItemName","RELÍQUIA",
    UDim2.fromOffset(12,10),UDim2.fromOffset(254,55),20,C.Pale,true)
local worldName=label(info,"World","UNIVERSO",
    UDim2.fromOffset(12,73),UDim2.fromOffset(253,22),13,C.Blue,true)
local status=label(info,"Status","",
    UDim2.fromOffset(12,103),UDim2.fromOffset(253,51),12,C.Gold,true)
local effect=label(info,"Effect","",
    UDim2.fromOffset(12,163),UDim2.fromOffset(253,84),14,C.White)
effect.TextYAlignment=Enum.TextYAlignment.Top
local origin=label(info,"Source","",
    UDim2.fromOffset(12,251),UDim2.fromOffset(252,48),12,C.Muted)
local note=label(info,"Note","",
    UDim2.fromOffset(12,311),UDim2.fromOffset(252,65),12,C.Gold)

-- Other tabs remain informative, NOT functional buttons that pretend to
-- equip a non-existent item. Gilgamesh alone owns these future workflows.
local other=panel(root,"ComingSoon",UDim2.fromOffset(17,127),
    UDim2.fromOffset(916,412),C.Onyx,10)
other.Visible=false
local otherTitle=label(other,"ComingSoonTitle","",
    UDim2.fromOffset(35,35),UDim2.fromOffset(838,52),26,C.Pale,true)
local otherBody=label(other,"ComingSoonBody","",
    UDim2.fromOffset(35,111),UDim2.fromOffset(820,182),18,C.Muted)
otherBody.TextYAlignment=Enum.TextYAlignment.Top

local footer=label(root,"StatusLine",
    "CATÁLOGO GLOBAL • Prévia visual, sem itens obtidos nem drop ativo.",
    UDim2.fromOffset(25,548),UDim2.fromOffset(897,26),12,C.Muted)
footer.TextXAlignment=Enum.TextXAlignment.Center

local category="Anéis"
local selected=Catalog.GetAll()[1]
local yaw=0
local activeTab="CATÁLOGO"
local entries=Catalog.GetAll()

local function drawSelected()
    if not selected then return end
    itemTitle.Text=selected.Name
    itemTitle.TextColor3=selected.Accent
    worldName.Text="UNIVERSO: "..selected.World
    status.Text=if selected.Category=="LegacyConcept"
        then "CONCEITO ANTIGO • NÃO APROVADO"
        else "RELÍQUIA APROVADA • DROP NÃO ATIVO"
    status.TextColor3=if selected.Category=="LegacyConcept" then C.Muted else C.Gold
    effect.Text=selected.Description
    origin.Text="ORIGEM: "..selected.Origin
    note.Text=selected.Detail.."\nPOSSE: NÃO CONECTADA"
    world:ClearAllChildren()
    conceptMessage.Visible=selected.Category~="EvolutionRelic"
    if selected.Category=="EvolutionRelic" then
        local model=Builder.Build(selected.Id)
        if model then
            model.Parent=world
            yaw=0
            model:PivotTo(CFrame.Angles(0,yaw,0))
        else
            conceptMessage.Text="MODELO 3D INDISPONÍVEL"
            conceptMessage.Visible=true
        end
    else
        conceptMessage.Text="CONCEITO ARQUIVADO\n\nModelo 3D não aprovado"
    end
end
local function drawList()
    for _,obj in ipairs(scroll:GetChildren()) do
        if obj:IsA("TextButton") then obj:Destroy() end
    end
    local count=0
    for _,entry in ipairs(entries) do
        local matches=if category=="Anéis"
            then entry.Category=="EvolutionRelic"
            else entry.Category=="LegacyConcept"
        if matches then
            count+=1
            local row=button(scroll,"Catalog_"..entry.Id,entry.Name,
                UDim2.fromOffset(0,0),UDim2.fromOffset(224,45),
                if selected and selected.Id==entry.Id then C.Glass else C.Panel)
            row.LayoutOrder=count;row.TextSize=12
            row.TextColor3=entry.Accent
            row.Activated:Connect(function()
                selected=entry
                drawList()
                drawSelected()
            end)
        end
    end
    scroll.CanvasSize=UDim2.fromOffset(0,count*51)
    for n,b in pairs(filterButtons) do
        b.BackgroundColor3=if category==n then C.Gold else C.Glass
        b.TextColor3=if category==n then C.Onyx else C.White
    end
end
for n,b in pairs(filterButtons) do
    b.Activated:Connect(function()
        category=n
        local categoryName=if n=="Anéis" then "EvolutionRelic" else "LegacyConcept"
        local choices=Catalog.GetByCategory(categoryName)
        selected=choices[1]
        drawList()
        drawSelected()
    end)
end
local future={
    ["EQUIPAR"]={"EQUIPAMENTO DE RELÍQUIAS",
        "Gilgamesh será o único NPC com acesso ao sistema de equipar e remover relíquias. Será necessário conectar o inventário persistente e validar a posse da unidade e do item no servidor.\n\nPor enquanto, a troca de anéis existe somente como teste de combate no Roblox Studio."},
    ["EVOLUIR"]={"EVOLUÇÃO COM RELÍQUIAS",
        "Aqui serão feitas as evoluções que dependem de relíquias e seus materiais, inclusive as ligadas a Ainz, Shalltear e Albedo.\n\nAinda não existem receitas, quantidades de materiais, consumo real nem execução de evolução."},
    ["REROLL"]={"REROLL DE RELÍQUIAS",
        "O reroll de atributos de relíquias ficará exclusivamente sob a responsabilidade de Gilgamesh, separado do reroll de Traits das unidades.\n\nCustos, valores, chances e moeda ainda exigem configuração real."},
    ["INFORMAÇÕES"]={"O TESOURO DE TODOS OS UNIVERSOS",
        "O Salão da Babilônia reúne relíquias de todos os mundos do Anime Fissure, não apenas de Overlord.\n\nA aba ANÉIS mostra os cinco itens aprovados. CONCEITOS contém projetos antigos não aprovados, sem chances ou mapa de obtenção confirmados.\n\nQuando qualquer anel é colocado no Ainz, seus bônus comuns ficam inativos; ele utiliza esses itens como materiais de evolução."},
}
local function chooseTab(name: string)
    activeTab=name
    body.Visible=name=="CATÁLOGO"
    other.Visible=not body.Visible
    for id,b in pairs(tabsByName) do
        b.BackgroundColor3=if id==name then C.Gold else C.Stone
        b.TextColor3=if id==name then C.Onyx else C.White
    end
    if name~="CATÁLOGO" then
        local data=future[name]
        otherTitle.Text=data[1]
        otherBody.Text=data[2]
    end
end
for name,b in pairs(tabsByName) do
    b.Activated:Connect(function() chooseTab(name) end)
end

local function scale()
    local cameraView=Workspace.CurrentCamera
    if not cameraView then return end
    local v=cameraView.ViewportSize
    uiScale.Scale=math.clamp(math.min((v.X-12)/963,(v.Y-14)/602,1),0.37,1)
end
local savedLobby: boolean?=nil
local function setLobbyVisible(hidden: boolean)
    local ui=guiParent:FindFirstChild("AnimeFissureLobbyUI")
    if not ui or not ui:IsA("ScreenGui") then return end
    if hidden then
        if savedLobby==nil then savedLobby=ui.Enabled end
        ui.Enabled=false
    elseif savedLobby~=nil then
        ui.Enabled=savedLobby and player:GetAttribute("InArena")~=true
        savedLobby=nil
    end
end
local function setOpen(on: boolean)
    screen.Enabled=on and player:GetAttribute("InArena")~=true
    setLobbyVisible(screen.Enabled)
    if screen.Enabled then
        category="Anéis";selected=Catalog.GetByCategory("EvolutionRelic")[1]
        chooseTab("CATÁLOGO");drawList();drawSelected()
        scale()
    else
        world:ClearAllChildren()
    end
end
close.Activated:Connect(function() setOpen(false) end)
UserInputService.InputBegan:Connect(function(input: InputObject,processed: boolean)
    if processed or not screen.Enabled then return end
    if input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.ButtonB then
        setOpen(false)
    end
end)
player:GetAttributeChangedSignal("InArena"):Connect(function()
    if player:GetAttribute("InArena")==true then setOpen(false) end
end)
RunService.RenderStepped:Connect(function(dt: number)
    if not screen.Enabled or activeTab~="CATÁLOGO" or not selected then return end
    local model=world:FindFirstChild(selected.Id)
    if model and model:IsA("Model") then
        yaw=(yaw+dt*0.38)%(2*math.pi)
        model:PivotTo(CFrame.Angles(0,yaw,0))
    end
end)
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(scale)
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(scale)
end
task.spawn(function()
    local folder=RS:WaitForChild("BabylonRemotes",65)
    if not folder or not folder:IsA("Folder") then
        warn("[Anime Fissure] Gilgamesh: remotes não encontrados")
        return
    end
    local open=folder:WaitForChild("OpenRelicCatalog",15)
    if open and open:IsA("RemoteEvent") then
        open.OnClientEvent:Connect(function()
            if player:GetAttribute("InArena")~=true then setOpen(true) end
        end)
    end
end)
print("[Anime Fissure] GILGAMESH UNIVERSAL RELIC VAULT v2.0 | 5 approved rings, archived concepts, server-only access")
