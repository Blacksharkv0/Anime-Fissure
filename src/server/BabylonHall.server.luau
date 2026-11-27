--!strict
-- ANIME FISSURE | Babylon Hall bootstrap v1.0
-- Separate, additive annex. Never replaces or edits the mission lobby.
local Workspace=game:GetService("Workspace")
local RS=game:GetService("ReplicatedStorage")
local Players=game:GetService("Players")
local Builder=require(script.Parent:WaitForChild("BabylonHallBuilder"))
local lobby=Workspace:WaitForChild("FissureLobby",55)
if not lobby or not lobby:IsA("Model") then
    warn("[Anime Fissure] BABYLON HALL: FissureLobby indisponivel")
    return
end
local floor=lobby:WaitForChild("LobbyFloor",15)
local spawn=lobby:WaitForChild("LobbySpawn",15)
local portal=lobby:WaitForChild("ArenaPortal",15)
if not floor or not spawn or not portal then
    warn("[Anime Fissure] BABYLON HALL: aguardando elementos do lobby")
    return
end
local ok,hall=pcall(function()
    return Builder.Build(lobby)
end)
if not ok then
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
        (open :: RemoteEvent):FireClient(player)
    end)
    Players.PlayerRemoving:Connect(function(player)
        lastOpen[player.UserId]=nil
    end)
    print("[Anime Fissure] BABYLON HALL READY: Gilgamesh governs ALL relics; "..
        "server-validated catalog, 11 portals and 5 ring vitrines")
end
