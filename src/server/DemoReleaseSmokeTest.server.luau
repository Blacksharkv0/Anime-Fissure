--!strict
-- ANIME FISSURE | DEMO RELEASE SMOKE v1.0
-- Studio-only integration guard. Not a substitute for live Roblox Playtest.
-- Ensures main Story can start while unreleased systems stay READ ONLY.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local RS=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Shared=RS:WaitForChild("Shared")
local Stages=require(Shared:WaitForChild("LobbyStageConfig"))
local Services=require(Shared:WaitForChild("LobbyServiceConfig"))
local UnitIndex=require(Shared:WaitForChild("UnitIndexCatalog"))
local Relics=require(Shared:WaitForChild("UniversalRelicCatalog"))
local Rings=require(Shared:WaitForChild("RelicRingConfig"))
local Loot=require(Shared:WaitForChild("OverlordEvolutionLootConfig"))

assert(Stages.CanEnter("OVL_01","Classic")==true)
assert(Stages.CanEnter("OVL_01","Hard")==true)
assert(Stages.CanEnter("OVL_02","Classic")==false,
    "Story stages without maps must stay blocked")
assert(Stages.CanEnter("OVL_01","Impossible")==false,
    "Unknown modes must stay blocked")
assert(Loot.Status=="Planned_NoActiveDrops")
assert(not Loot.IsDropEnabled("MagicPowerRing","OVL_01","Hard"),
    "Preview evolution rings cannot be granted")
assert(#Rings.GetAll()==5)
assert(Relics.OwnerNPC=="Gilgamesh" and Relics.Scope=="AllWorlds")
assert(#Relics.GetByCategory("EvolutionRelic")==5)
assert(UnitIndex.OwnerNPC=="Dante" and UnitIndex.CollectionConnected==false)
assert(#UnitIndex.GetAll()==8)
assert(Services.CurrentEventId==nil and Services.GetEvent()==nil)
assert(#Services.Order==4)

local lobby=Workspace:WaitForChild("FissureLobby",60)
local spawn=lobby:WaitForChild("LobbySpawn",25)
local portal=lobby:WaitForChild("ArenaPortal",25)
local summon=lobby:WaitForChild("VirgilSummonStand",30)
local alchemy=lobby:WaitForChild("AlchemyWorkshop",30)
local hall=lobby:WaitForChild("BabylonHall",70)
local stations=lobby:WaitForChild("LobbyServiceStations",70)
assert(spawn and portal and summon and alchemy and hall and stations)
local began=os.clock()
while ((hall:GetAttribute("Ready")~=true) or
    (stations:GetAttribute("Ready")~=true))
    and os.clock()-began<20 do task.wait(.2) end
assert(hall:GetAttribute("Ready")==true and stations:GetAttribute("Ready")==true,
    "Lobby set-pieces did not build")
assert(stations:GetAttribute("StationCount")==4)
assert(stations:GetAttribute("SystemsActive")==false)
assert(stations:FindFirstChild("TwinHuntersEmblem"),
    "Dante and Vergil share a non-blocking decorative feature")
assert(alchemy:GetAttribute("Role")=="OrbsAlchemyOnly")
assert(hall:GetAttribute("RelicScope")=="AllWorlds")
for _,id in ipairs(Services.Order) do
    local p=stations:FindFirstChild(id.."Station")
    assert(p and p:GetAttribute("GameplayActive")==false)
end
local event=stations:FindFirstChild("SeasonalEventHub")
assert(event and event:GetAttribute("GameplayActive")==false)
assert(event:GetAttribute("DisplayState")=="StudioPreviewOnly")

-- Triggering the NPC menu should be client-only UI. No new remotes allow
-- crafting, card mutations, drops, fake summoning, extra raids or rerolls.
local lobbyRemotes=RS:WaitForChild("LobbyServicesRemotes",30)
assert(lobbyRemotes:FindFirstChild("OpenServiceInfo"))
assert(#lobbyRemotes:GetChildren()==1)
local babylonRemotes=RS:WaitForChild("BabylonRemotes",30)
assert(babylonRemotes:FindFirstChild("OpenRelicCatalog"))
assert(#babylonRemotes:GetChildren()==1)

print("[Anime Fissure] DEMO RELEASE SMOKE OK: playable Story OVL_01, "..
    "7 permanent NPCs, 1 inactive event hub, protected inventories, "..
    "5 relic rings, 8 Index units")
