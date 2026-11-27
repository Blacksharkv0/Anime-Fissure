--!strict
-- ANIME FISSURE | Babylon Hall bootstrap v1.0
-- Separate, additive annex. Never replaces or edits the mission lobby.
local Workspace=game:GetService("Workspace")
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
    print("[Anime Fissure] BABYLON HALL READY: 11 weapon portals, " ..
        "5 rings, Gilgamesh and relic catalog prompt")
end
