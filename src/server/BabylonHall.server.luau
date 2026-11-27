--!strict
-- ANIME FISSURE | Babylon Hall bootstrap v1.0
-- Separate, additive annex. Never replaces or edits the mission lobby.
local Workspace=game:GetService("Workspace")
local RS=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local statusKey="FoundationBabylon"
local function stage(state: string,detail: string?)
    Workspace:SetAttribute(statusKey,state)
    Workspace:SetAttribute(statusKey.."Detail",detail or "")
end
stage("Loading","Carregando BabylonHallBuilder")
local moduleScript=script.Parent:WaitForChild("BabylonHallBuilder",20)
if not moduleScript then
    stage("Error","Módulo BabylonHallBuilder ausente")
    warn("[Anime Fissure] "..statusKey..": módulo ausente")
    return
end
local loaded,Builder=xpcall(function()
    return require(moduleScript)
end,debug.traceback)
if not loaded then
    stage("Error",tostring(Builder))
    warn("[Anime Fissure] "..statusKey..": "..tostring(Builder))
    return
end
local lobby=Workspace:WaitForChild("FissureLobby",55)
if not lobby or not lobby:IsA("Model") then
    stage("Error","FissureLobby indisponível")
    warn("[Anime Fissure] BABYLON HALL: FissureLobby indisponivel")
    return
end
local floor=lobby:WaitForChild("LobbyFloor",15)
local spawn=lobby:WaitForChild("LobbySpawn",15)
local portal=lobby:WaitForChild("ArenaPortal",15)
if not floor or not spawn or not portal then
    stage("Error","Piso, spawn ou portal ausente")
    warn("[Anime Fissure] BABYLON HALL: aguardando elementos do lobby")
    return
end
stage("Loading","Construindo Salão da Babilônia")
local ok,hall=xpcall(function()
    return Builder.Build(lobby)
end,debug.traceback)
if not ok then
    stage("Error",tostring(hall))
    warn("[Anime Fissure] BABYLON HALL: falha ao criar decoracao: "..tostring(hall))
elseif hall then
    -- The client may only OPEN the catalog after Gilgamesh's server prompt
    -- confirms player proximity and lobby state. No relic grant/equip remote.
    local remotes=RS:FindFirstChild("BabylonRemotes")
    if remotes and not remotes:IsA("Folder") then
        remotes:Destroy();remotes=nil
    end
    if not remotes then
        remotes=Instance.new("Folder")
        remotes.Name="BabylonRemotes"
        remotes.Parent=RS
    end
    local open=remotes:FindFirstChild("OpenRelicCatalog")
    if open and not open:IsA("RemoteEvent") then
        open:Destroy();open=nil
    end
    if not open then
        open=Instance.new("RemoteEvent")
        open.Name="OpenRelicCatalog"
        open.Parent=remotes
    end
    local king=hall:FindFirstChild("GilgameshNPC")
    local anchor=if king then king:FindFirstChild("RelicMasterInteraction") else nil
    local prompt=if anchor then anchor:FindFirstChild("BabylonRelicPrompt") else nil
    if not prompt or not prompt:IsA("ProximityPrompt") or not anchor
        or not anchor:IsA("BasePart") then
        stage("Error","Prompt de Gilgamesh indisponível")
        warn("[Anime Fissure] BABYLON: prompt do Gilgamesh indisponivel")
        return
    end
    local lastOpen: {[number]: number}={}
    prompt.Triggered:Connect(function(player: Player)
        if player.Parent~=Players or player:GetAttribute("InArena")==true then return end
        local now=os.clock()
        if now-(lastOpen[player.UserId] or -10)<0.55 then return end
        local character=player.Character
        local humanoid=if character then character:FindFirstChildOfClass("Humanoid") else nil
        local root=if character then character:FindFirstChild("HumanoidRootPart") else nil
        if not humanoid or humanoid.Health<=0
            or not root or not root:IsA("BasePart") then return end
        if (root.Position-anchor.Position).Magnitude>14 then return end
        lastOpen[player.UserId]=now
        local openEvent = open :: RemoteEvent
        openEvent:FireClient(player)
    end)
    Players.PlayerRemoving:Connect(function(player)
        lastOpen[player.UserId]=nil
    end)
    stage("Ready","Gilgamesh e catálogo conectados")
    print("[Anime Fissure] BABYLON HALL READY: Gilgamesh governs ALL relics; "..
        "server-validated catalog, 11 portals and 5 ring vitrines")
end
