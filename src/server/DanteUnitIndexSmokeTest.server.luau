--!strict
-- ANIME FISSURE | Universal unit Index, server Studio smoke v1.0.
-- Index must never invent ownership/discovery or unlock a Summon entry.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end

local RS=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Shared=RS:WaitForChild("Shared")
local Catalog=require(Shared:WaitForChild("UnitIndexCatalog"))
local Roster=require(Shared:WaitForChild("OverlordUnitRoster"))
local Capsule=require(Shared:WaitForChild("CapsuleUnitConfig"))
local Summon=require(Shared:WaitForChild("SummonConfig"))
local Stations=require(Shared:WaitForChild("LobbyServiceConfig"))

assert(Catalog.OwnerNPC=="Dante" and Catalog.Scope=="AllWorlds")
assert(Catalog.CollectionConnected==false)
local total=Catalog.GetAll()
assert(#total==8,"Expected six Overlord + two Capsule forms")
assert(#Catalog.GetWorld("Overlord")==6)
assert(#Catalog.GetWorld("Dragon Ball")==2)
assert(#Catalog.GetWorld("Todos")==8)

local seen: {[string]: boolean}={}
for _,entry in ipairs(total) do
    assert(not seen[entry.Id],"Duplicate unit Index entry")
    seen[entry.Id]=true
    assert(entry.IsOwned==nil and entry.IsDiscovered==nil,
        "Unit Index must NOT fake ownership/discovery")
    assert(entry.Name~="" and entry.Rarity~="" and entry.ObtainMethod~="")
    assert(Catalog.GetOwnershipState(nil,entry.Id)=="Inventário não conectado")
    if entry.World=="Overlord" then
        assert(Roster.Get(entry.Id)~=nil)
        assert(entry.IsBannerActive==false,
            "Overlord is not approved for the current banner")
    end
end
assert(seen.OVL_Ainz and seen.OVL_Albedo and seen.OVL_Shalltear
    and seen.OVL_Gazef and seen.OVL_Brain and seen.OVL_Climb)
assert(seen[Capsule.LegendaryId] and seen[Capsule.MythicId])
assert(Catalog.Get("OVL_Ainz").ObtainMethod:find("Fase especial"))
assert(Catalog.Get(Capsule.MythicId).IsBannerActive==false)
assert(Summon.IsInBanner("OVL_Ainz")==false)
assert(Summon.IsInBanner(Capsule.MythicId)==false)

local index=Stations.GetStation("Index")
local raid=Stations.GetStation("Raids")
assert(index.NPC=="Dante" and raid.NPC=="Sung Jinwoo",
    "Index must NOT replace permanent challenges/raids NPC")
assert(index.Position.X==247 and index.Position.Z==-8)
local lobby=Workspace:WaitForChild("FissureLobby",65)
local stations=lobby:WaitForChild("LobbyServiceStations",70)
local dante=stations:WaitForChild("IndexStation",10)
assert(dante:GetAttribute("GameplayActive")==false)
local npc=dante:FindFirstChild("DanteNPC")
assert(npc and npc:GetAttribute("Prototype")=="StaticDecorative")
local hologram=dante:FindFirstChild("HunterUnitIndex")
assert(hologram and hologram:IsA("BasePart"))
local promptAnchor=dante:FindFirstChild("InteractionPoint")
local prompt=if promptAnchor then promptAnchor:FindFirstChild("LobbyServicePrompt") else nil
assert(prompt and prompt:IsA("ProximityPrompt") and prompt.ClickablePrompt)
assert(prompt:GetAttribute("ServiceId")=="Index")
assert(prompt.ActionText=="ABRIR INDEX")

print("[Anime Fissure] DANTE UNIVERSAL INDEX SMOKE OK: " ..
    tostring(#total) .. " entries, no fake ownership, Jinwoo raids kept")
