--!strict
-- ANIME FISSURE | Babylon Relic Catalog v1.1
-- In-lobby READ ONLY catalog, opens via Gilgamesh ProximityPrompt or button.
-- 3D ring previews are safely built client-side outside Studio.
-- No loot, fake ownership, equipping or currency operations.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Workspace=game:GetService("Workspace")

local player=Players.LocalPlayer
local playerGui=player:WaitForChild("PlayerGui")
local Shared=ReplicatedStorage:WaitForChild("Shared")
local Rings=require(Shared:WaitForChild("RelicRingConfig"))
local RingBuilder=require(Shared:WaitForChild("RelicRingModelBuilder"))

local old=playerGui:FindFirstChild("RelicRingGallery")
if old then old:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="RelicRingGallery"
gui.ResetOnSpawn=false
gui.DisplayOrder=80
gui.IgnoreGuiInset=false
gui.Enabled=player:GetAttribute("InArena")~=true
gui.Parent=playerGui

local P={
    Dark=Color3.fromRGB(9,13,29),Panel=Color3.fromRGB(18,29,53),
    Inner=Color3.fromRGB(26,39,69),Blue=Color3.fromRGB(55,116,244),
    Text=Color3.fromRGB(240,245,255),Muted=Color3.fromRGB(177,195,223),
    Gold=Color3.fromRGB(249,208,131),
}
local function panel(parent: Instance,name: string,
    size: UDim2,pos: UDim2,color: Color3): Frame
    local f=Instance.new("Frame")
    f.Name=name;f.Size=size;f.Position=pos
    f.BackgroundColor3=color;f.BorderSizePixel=0;f.Parent=parent
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,12);corner.Parent=f
    return f
end
local function text(parent: Instance,name: string,content: string,size: UDim2,
    pos: UDim2,fontSize: number,color: Color3): TextLabel
    local t=Instance.new("TextLabel")
    t.Name=name;t.Text=content;t.Size=size;t.Position=pos
    t.BackgroundTransparency=1;t.TextWrapped=true
    t.TextColor3=color;t.Font=Enum.Font.GothamBold;t.TextSize=fontSize
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.Parent=parent
    return t
end
local function button(parent: Instance,name: string,content: string,
    size: UDim2,pos: UDim2,color: Color3): TextButton
    local t=Instance.new("TextButton")
    t.Name=name;t.Text=content;t.TextColor3=P.Text
    t.Font=Enum.Font.GothamBold;t.TextSize=13;t.TextWrapped=true
    t.Size=size;t.Position=pos;t.BackgroundColor3=color
    t.BorderSizePixel=0;t.Parent=parent
    local round=Instance.new("UICorner");round.CornerRadius=UDim.new(0,8)
    round.Parent=t
    return t
end

-- Third laboratory launch, below Overlord Models (y12) and
-- Economy Items (y65); does not cover either existing button.
local launch=button(gui,"OpenRings","✧ SALÃO DA BABILÔNIA",
    UDim2.fromOffset(218,38),UDim2.new(1,-230,0,119),P.Blue)
local shade=panel(gui,"Backdrop",UDim2.fromScale(1,1),
    UDim2.fromScale(0,0),P.Dark)
shade.BackgroundTransparency=0.12
shade.Visible=false
local window=panel(shade,"RingLabWindow",UDim2.fromOffset(710,470),
    UDim2.fromScale(0.5,0.5),P.Panel)
window.AnchorPoint=Vector2.new(0.5,0.5)
local scaled=Instance.new("UIScale");scaled.Parent=window

text(window,"Title","BABILÔNIA • CATÁLOGO DE RELÍQUIAS",
    UDim2.fromOffset(605,37),UDim2.fromOffset(16,11),22,P.Gold)
local close=button(window,"Close","✕",UDim2.fromOffset(48,38),
    UDim2.fromOffset(647,10),P.Inner)
local viewport=Instance.new("ViewportFrame")
viewport.Name="Ring3DPreview"
viewport.Size=UDim2.fromOffset(417,330)
viewport.Position=UDim2.fromOffset(14,60)
viewport.BackgroundColor3=P.Dark
viewport.BackgroundTransparency=0
viewport.BorderSizePixel=0
viewport.Ambient=Color3.fromRGB(175,190,229)
viewport.LightColor=Color3.fromRGB(237,227,255)
viewport.LightDirection=Vector3.new(-1,-2,-1)
viewport.Parent=window
local camera=Instance.new("Camera")
camera.CFrame=CFrame.lookAt(Vector3.new(0,0,-8.3),Vector3.zero)
camera.Parent=viewport
viewport.CurrentCamera=camera
local world=Instance.new("WorldModel")
world.Parent=viewport
local title=text(window,"RingName","Selecione um anel",
    UDim2.fromOffset(268,60),UDim2.fromOffset(441,65),18,P.Text)
local effect=text(window,"Effect","",
    UDim2.fromOffset(253,76),UDim2.fromOffset(441,145),13,P.Gold)
local origin=text(window,"Origin","",
    UDim2.fromOffset(253,83),UDim2.fromOffset(441,226),12,P.Muted)
local ainz=text(window,"AinzRule","AINZ: sem bônus comum • material de evolução",
    UDim2.fromOffset(253,80),UDim2.fromOffset(441,302),12,P.Gold)
local footer=text(window,"Note",
    "CATÁLOGO • Sem drops ativos ou inventário real. Equipar e evoluir: em desenvolvimento.",
    UDim2.fromOffset(670,35),UDim2.fromOffset(18,432),12,P.Muted)

local btns: {[string]: TextButton}={}
for i,id in ipairs(Rings.Order) do
    local info=Rings.Get(id)
    local short=({"MAGIA","FÍSICO","SPA","RANGE","RESTRIÇÃO"})[i]
    local b=button(window,"Ring_"..id,short,
        UDim2.fromOffset(130,36),UDim2.fromOffset(17+(i-1)*138,393),P.Inner)
    btns[id]=b
end
local templates: Folder?=nil
local selected=Rings.Order[1]
local yaw=0

local originByRing={
    MagicPowerRing="Carne Village • Hard",
    PhysicalDamageRing="O Rei da Floresta",
    SPARing="Cemitério de E-Rantel",
    RangeRing="Guerra dos Homens-Lagarto",
    RestrictionRing="Trono de Nazarick",
}

local function display()
    local info=Rings.Get(selected)
    if not info then return end
    title.Text=info.Name
    title.TextColor3=info.MainColor
    effect.Text=info.Description
    origin.Text="Mapa: "..(originByRing[selected] or "a definir")
    for id,b in pairs(btns) do
        b.BackgroundColor3=if id==selected then P.Blue else P.Inner
    end
    world:ClearAllChildren()
    -- Outside Studio previews are built locally; no server equipment or
    -- ownership state is inferred from having a preview model.
    local source=if templates then templates:FindFirstChild(selected) else nil
    local model=if source and source:IsA("Model")
        then source:Clone() else RingBuilder.Build(selected)
    if not model then
        footer.Text="Prévia indisponível. Nenhum item foi alterado."
        return
    end
    footer.Text="CATÁLOGO VISUAL • sem drops, inventário ou evolução ativos."
    model.Parent=world
    model:PivotTo(CFrame.Angles(0,yaw,0))
end

for id,b in pairs(btns) do
    b.Activated:Connect(function() selected=id;yaw=0;display() end)
end

local function resize()
    local c=Workspace.CurrentCamera
    if not c then return end
    local size=c.ViewportSize
    scaled.Scale=math.clamp(math.min((size.X-15)/710,(size.Y-14)/470,1),0.48,1)
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(resize)
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
end
resize()

local function setOpen(value: boolean)
    shade.Visible=value
    if value then display() else world:ClearAllChildren() end
end
launch.Activated:Connect(function() setOpen(not shade.Visible) end)
close.Activated:Connect(function() setOpen(false) end)
player:GetAttributeChangedSignal("InArena"):Connect(function()
    gui.Enabled=player:GetAttribute("InArena")~=true
    if not gui.Enabled then setOpen(false) end
end)
RunService.RenderStepped:Connect(function(dt: number)
    if not shade.Visible then return end
    local model=world:FindFirstChild(selected)
    if model and model:IsA("Model") then
        yaw=(yaw+dt*0.30)%(2*math.pi)
        model:PivotTo(CFrame.Angles(0,yaw,0))
    end
end)
-- Gilgamesh's proximity interaction opens the same UI as the launcher.
-- Client-only trigger; no reward, equip or DataStore call is exposed.
task.spawn(function()
    local lobby=Workspace:WaitForChild("FissureLobby",60)
    if not lobby or not lobby:IsA("Model") then return end
    local hall=lobby:WaitForChild("BabylonHall",60)
    if not hall or not hall:IsA("Model") then return end
    local king=hall:WaitForChild("GilgameshNPC",15)
    if not king then return end
    local anchor=king:WaitForChild("RelicMasterInteraction",15)
    if not anchor then return end
    local prompt=anchor:FindFirstChild("BabylonRelicPrompt")
    if prompt and prompt:IsA("ProximityPrompt") then
        prompt.Triggered:Connect(function()
            if player:GetAttribute("InArena")~=true then setOpen(true) end
        end)
    end
end)

if RunService:IsStudio() then
    task.spawn(function()
        local f=ReplicatedStorage:WaitForChild("RelicRingPreviewModels",12)
        if f and f:IsA("Folder") then
            templates=f
            if shade.Visible then display() end
        end
    end)
end
print("[Anime Fissure] BABYLON RELIC CATALOG v1.1 | readonly 3D ring previews")
