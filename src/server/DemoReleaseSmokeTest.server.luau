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

-- Verify the actual anchors used by the navigator, not merely station names.
local function checkPrompt(anchor: Instance?,name: string,context: string)
    assert(anchor and anchor:IsA("BasePart"),context.." missing BasePart anchor")
    local prompt=anchor:FindFirstChild(name)
    assert(prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled,
        context.." missing enabled prompt")
    assert(prompt.ClickablePrompt and prompt.MaxActivationDistance>0,
        context.." prompt unusable on touch")
end
for _,id in ipairs(Services.Order) do
    local station=stations:FindFirstChild(id.."Station")
    assert(station,"Missing station "..id)
    checkPrompt(station:FindFirstChild("InteractionPoint"),"LobbyServicePrompt",id)
end
checkPrompt(event:FindFirstChild("InteractionPoint"),"LobbyServicePrompt","EventHub")
local king=hall:WaitForChild("GilgameshNPC",30)
assert(king and king:IsA("Model"),"Gilgamesh model missing")
checkPrompt(king:FindFirstChild("RelicMasterInteraction"),"BabylonRelicPrompt","Gilgamesh")
for _,entry in ipairs({{summon,"VirgilNPC"},{alchemy,"AlchemistNPC"}}) do
    local stand=entry[1] :: Instance
    local name=entry[2] :: string
    local npc=stand:WaitForChild(name,45)
    assert(npc and npc:IsA("Model"),name.." model missing")
    local untilTime=os.clock()+30
    while npc:GetAttribute("InteractionReady")~=true and os.clock()<untilTime do
        task.wait(.2)
    end
    assert(npc:GetAttribute("InteractionReady")==true,name.." interaction never became ready")
    local prompt=npc:FindFirstChild("FissureNPCPrompt",true)
    assert(prompt and prompt:IsA("ProximityPrompt") and prompt.Enabled
        and prompt.ClickablePrompt,name.." has no usable NPC prompt")
    local attachment=prompt.Parent
    assert(attachment and attachment:IsA("Attachment")
        and attachment.Parent and attachment.Parent:IsA("BasePart"),
        name.." prompt is not attached to a physical anchor")
end
print("[Anime Fissure] NPC INTERACTION SMOKE OK: 7 permanent prompts + event hub")


-- Triggering the NPC menu should be client-only UI. No new remotes allow
-- crafting, card mutations, drops, fake summoning, extra raids or rerolls.
local lobbyRemotes=RS:WaitForChild("LobbyServicesRemotes",30)
assert(lobbyRemotes:FindFirstChild("OpenServiceInfo"))
assert(#lobbyRemotes:GetChildren()==1)
local babylonRemotes=RS:WaitForChild("BabylonRemotes",30)
assert(babylonRemotes:FindFirstChild("OpenRelicCatalog"))
assert(#babylonRemotes:GetChildren()==1)

local postMatch=RS:WaitForChild("PostMatchRemotes",30)
assert(postMatch:FindFirstChild("ShowResult")
    and postMatch.ShowResult:IsA("RemoteEvent"))
assert(postMatch:FindFirstChild("ReturnLobby")
    and postMatch.ReturnLobby:IsA("RemoteEvent"))
assert(not postMatch:FindFirstChild("ClaimRewards")
    and not postMatch:FindFirstChild("Replay"),
    "Post-match must not expose fake replay or rewards")

print("[Anime Fissure] DEMO RELEASE SMOKE OK: playable Story OVL_01, "..
    "7 permanent NPCs, 1 inactive event hub, protected inventories, "..
    "5 relic rings, 8 Index units")
