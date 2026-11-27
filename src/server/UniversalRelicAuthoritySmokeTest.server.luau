--!strict
-- ANIME FISSURE | Universal Gilgamesh relic authority - Studio smoke v1.0
-- Ensures relics moved out of Edward's alchemy without fake ownership.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local Workspace=game:GetService("Workspace")
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("Shared")
local Catalog=require(Shared:WaitForChild("UniversalRelicCatalog"))
local Rings=require(Shared:WaitForChild("RelicRingConfig"))
local Legacy=require(Shared:WaitForChild("RelicIndexConfig"))
assert(Catalog.OwnerNPC=="Gilgamesh" and Catalog.Scope=="AllWorlds")
assert(Catalog.Status=="CatalogOnly_NoInventory")

local rings=Catalog.GetByCategory("EvolutionRelic")
local archive=Catalog.GetByCategory("LegacyConcept")
assert(#rings==5,"The five approved rings must be in Gilgamesh catalog")
assert(#archive==7,"Keep old demo relic concepts archived, NOT as live drops")
for _,entry in ipairs(rings) do
    assert(Rings.IsRing(entry.Id) and entry.Status=="Approved_Prototype",
        "Approved item missing from universal catalog")
    assert(entry.IsRealDrop==false and entry.IsOwned==nil)
    assert(entry.World=="Overlord")
end
local sawDragonBall=false
for _,entry in ipairs(archive) do
    assert(entry.Status=="Archived_NotApproved"
        and entry.IsRealDrop==false and entry.IsOwned==nil)
    assert(entry.StageId==nil,
        "Legacy prototype stage must not pretend to have a drop location")
    assert(Legacy.IsAvailable(entry.Id)==false)
    if entry.World=="Dragon Ball" then sawDragonBall=true end
end
assert(sawDragonBall,"The universal catalog must support multiple anime worlds")
assert(Catalog.IsOwned(nil,"MagicPowerRing")==false)

local lobby=Workspace:WaitForChild("FissureLobby",45)
local workshop=lobby:WaitForChild("AlchemyWorkshop",45)
assert(workshop:GetAttribute("Role")=="OrbsAlchemyOnly",
    "Edward must no longer be assigned relic crafting")
local hall=lobby:WaitForChild("BabylonHall",65)
assert(hall:GetAttribute("RelicScope")=="AllWorlds")
local remotes=RS:WaitForChild("BabylonRemotes",30)
local open=remotes:WaitForChild("OpenRelicCatalog",15)
assert(open and open:IsA("RemoteEvent"),
    "Gilgamesh must be sole public entry point to the relic catalog")
local king=hall:FindFirstChild("GilgameshNPC")
assert(king and king:GetAttribute("RelicScope")=="AllWorlds")
print("[Anime Fissure] GILGAMESH EXCLUSIVE RELIC AUTHORITY OK: " ..
    "all worlds, 5 approved rings, 7 archived concepts, Edward alchemy-only")
