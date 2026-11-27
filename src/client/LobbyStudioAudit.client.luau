--!strict
-- ANIME FISSURE | Lobby Studio readiness overlay v1.0
-- Studio-only readout to verify all promised NPCs, set pieces and UIs.
-- Green = MODEL/PROMPT FOUND, not gameplay deployed or visually perfect.
-- No hidden progression, no fake inventory, no network writes.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local RS=game:GetService("ReplicatedStorage")
local player=Players.LocalPlayer
local playerGui=player:WaitForChild("PlayerGui")
local old=playerGui:FindFirstChild("LobbyStudioAudit")
if old then old:Destroy() end
local gui=Instance.new("ScreenGui")
gui.Name="LobbyStudioAudit"
gui.ResetOnSpawn=false
gui.DisplayOrder=105
gui.Parent=playerGui

local function node(parent: Instance,kind: string,name: string)
    local x=Instance.new(kind)
    x.Name=name
    x.Parent=parent
    return x
end
local toggle=node(gui,"TextButton","ToggleAudit") :: TextButton
toggle.Size=UDim2.fromOffset(168,34)
toggle.Position=UDim2.new(0,12,1,-48)
toggle.BackgroundColor3=Color3.fromRGB(34,57,100)
toggle.BorderSizePixel=0
toggle.TextColor3=Color3.fromRGB(236,244,255)
toggle.TextSize=12
toggle.Font=Enum.Font.GothamBold
toggle.Text="DIAGNÓSTICO DO LOBBY"
node(toggle,"UICorner","Round").CornerRadius=UDim.new(0,8)

local panel=node(gui,"Frame","Report") :: Frame
panel.AnchorPoint=Vector2.new(0,1)
panel.Position=UDim2.new(0,12,1,-88)
panel.Size=UDim2.fromOffset(338,486)
panel.BackgroundColor3=Color3.fromRGB(14,19,35)
panel.BorderSizePixel=0
panel.Visible=false
node(panel,"UICorner","Round").CornerRadius=UDim.new(0,10)
local stroke=node(panel,"UIStroke","GoldRim") :: UIStroke
stroke.Color=Color3.fromRGB(230,192,113)
stroke.Thickness=1.4
local scale=node(panel,"UIScale","Resize") :: UIScale
local title=node(panel,"TextLabel","Title") :: TextLabel
title.Position=UDim2.fromOffset(12,9)
title.Size=UDim2.fromOffset(306,27)
title.Text="DIAGNÓSTICO • ANIME FISSURE"
title.TextColor3=Color3.fromRGB(252,219,153)
title.TextSize=15
title.Font=Enum.Font.GothamBold
title.BackgroundTransparency=1
title.TextXAlignment=Enum.TextXAlignment.Left

local list={
    "Portal Story e Spawn",
    "Vergil • Summon",
    "Edward • Alquimia",
    "Gilgamesh • Ouro / Relíquias",
    "11 portais de armas",
    "5 vitrines de anéis",
    "Whis • Evolução",
    "Urahara • Traits",
    "Jinwoo • Desafios / Raids",
    "Dante • Index",
    "Praça de Eventos (Studio)",
    "Remotes e interfaces",
    "Diretório / FX de desempenho",
}
local labels: {TextLabel}={}
for i,name in ipairs(list) do
    local l=node(panel,"TextLabel","Status"..i) :: TextLabel
    l.Position=UDim2.fromOffset(12,41+(i-1)*31)
    l.Size=UDim2.fromOffset(316,29)
    l.Text="… "..name
    l.TextColor3=Color3.fromRGB(163,175,200)
    l.TextSize=12
    l.Font=Enum.Font.Gotham
    l.TextWrapped=false
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.BackgroundTransparency=1
    labels[i]=l
end
local note=node(panel,"TextLabel","Footer") :: TextLabel
note.Position=UDim2.fromOffset(12,453)
note.Size=UDim2.fromOffset(309,32)
note.Text="Isso verifica carga de modelos, NÃO valida jogabilidade."
note.TextWrapped=true
note.TextColor3=Color3.fromRGB(173,186,213)
note.TextSize=10
note.BackgroundTransparency=1
local function child(root: Instance?,name: string): Instance?
    return if root then root:FindFirstChild(name) else nil
end
local function ready()
    local lobby=Workspace:FindFirstChild("FissureLobby")
    local services=child(lobby,"LobbyServiceStations")
    local babylon=child(lobby,"BabylonHall")
    local king=child(babylon,"GilgameshNPC")
    local summon=child(lobby,"VirgilSummonStand")
    local alchemy=child(lobby,"AlchemyWorkshop")
    local portals=child(babylon,"GateOfBabylonPortals")
    local showcases=child(babylon,"RelicShowcases")
    local function look(station: string,npc: string): boolean
        local holder=child(services,station)
        local figure=child(holder,npc)
        return holder~=nil and figure~=nil
            and figure:GetAttribute("ArtFinish")=="1.0.0"
            and child(holder,"InteractionPoint")~=nil
    end
    local event=child(services,"SeasonalEventHub")
    local remotes=child(RS,"LobbyServicesRemotes")
    local babylonRemote=child(RS,"BabylonRemotes")
    local dialogue=child(RS,"NPCDialogueRemotes")
    return {
        child(lobby,"ArenaPortal")~=nil and child(lobby,"LobbySpawn")~=nil,
        child(summon,"VirgilNPC")~=nil,
        child(alchemy,"AlchemistNPC")~=nil,
        king~=nil and king:GetAttribute("ArtFinish")=="1.0.0"
            and child(king,"RelicMasterInteraction")~=nil,
        portals~=nil and #portals:GetChildren()==11,
        showcases~=nil and #showcases:GetChildren()==5,
        look("EvolutionStation","WhisNPC"),
        look("TraitsStation","KisukeUraharaNPC"),
        look("RaidsStation","SungJinwooNPC"),
        look("IndexStation","DanteNPC")
            and child(playerGui,"DanteUnitIndex")~=nil,
        event~=nil and event:GetAttribute("DisplayState")=="StudioPreviewOnly"
            and event:GetAttribute("GameplayActive")==false,
        child(remotes,"OpenServiceInfo")~=nil
            and child(babylonRemote,"OpenRelicCatalog")~=nil
            and child(dialogue,"OpenDialogue")~=nil,
        (function()
            local navigator=child(playerGui,"AnimeFissureLobbyNavigator")
            if not navigator then return false end
            return child(navigator,"OpenDirectory")~=nil
                and child(navigator,"FXQualityToggle")~=nil
                and child(navigator,"Directory")~=nil
        end)(),
    }
end
local function sync()
    local results=ready()
    local ok=0
    for i,l in ipairs(labels) do
        if results[i] then ok+=1 end
        l.Text=(if results[i] then "✓ " else "○ ")..list[i]
        l.TextColor3=if results[i]
            then Color3.fromRGB(143,230,181)
            else Color3.fromRGB(246,172,118)
    end
    title.Text="DIAGNÓSTICO • "..tostring(ok).."/"..tostring(#list).." carregados"
end
local function resize()
    local camera=Workspace.CurrentCamera
    if not camera then return end
    local view=camera.ViewportSize
    scale.Scale=math.clamp(math.min((view.X-24)/345,(view.Y-90)/498,1),.47,1)
end
toggle.Activated:Connect(function()
    if player:GetAttribute("InArena")==true then return end
    panel.Visible=not panel.Visible
    if panel.Visible then resize();sync() end
end)
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(resize)
if Workspace.CurrentCamera then
    Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
end
player:GetAttributeChangedSignal("InArena"):Connect(function()
    gui.Enabled=player:GetAttribute("InArena")~=true
    if not gui.Enabled then panel.Visible=false end
end)
gui.Enabled=player:GetAttribute("InArena")~=true
task.spawn(function()
    while gui.Parent do
        if panel.Visible and gui.Enabled then sync() end
        task.wait(1.5)
    end
end)
print("[Anime Fissure] LOBBY STUDIO DIAGNOSTIC ready, 13 scene checks")
