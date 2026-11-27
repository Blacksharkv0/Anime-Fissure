--!strict
-- ANIME FISSURE | Permanent lobby NPC & seasonal hub Studio smoke
-- No ability to evolve, reroll, grant drops, play raids or activate events.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local RS=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Config=require(RS:WaitForChild("Shared"):WaitForChild("LobbyServiceConfig"))

local lobby=Workspace:WaitForChild("FissureLobby",70)
assert(lobby and lobby:IsA("Model"),"Base lobby missing")
local spawn=lobby:WaitForChild("LobbySpawn",15)
local portal=lobby:WaitForChild("ArenaPortal",15)
local floor=lobby:WaitForChild("LobbyFloor",15)
local services=lobby:WaitForChild("LobbyServiceStations",70)
assert(services and services:IsA("Model"),"Services not built")
local t=os.clock()
while services:GetAttribute("Ready")~=true and os.clock()-t<12 do
    task.wait(.1)
end
assert(services:GetAttribute("Ready")==true)
assert(services:GetAttribute("StationCount")==4)
assert(services:GetAttribute("EventHubCount")==1)
assert(services:GetAttribute("SystemsActive")==false)
assert(#services:GetChildren()==5,"4 service NPCs + 1 seasonal hub")

local assigned: {[string]: boolean}={}
for _,id in ipairs(Config.Order) do
    local item=Config.GetStation(id)
    assert(item and item.Enabled==false and not assigned[item.NPC])
    assigned[item.NPC]=true
    local stand=services:FindFirstChild(id.."Station")
    assert(stand and stand:GetAttribute("Role")==id)
    assert(stand:GetAttribute("NPC")==item.NPC)
    assert(stand:GetAttribute("GameplayActive")==false)
    local anchor=stand:FindFirstChild("InteractionPoint")
    local prompt=if anchor then anchor:FindFirstChild("LobbyServicePrompt") else nil
    assert(prompt and prompt:IsA("ProximityPrompt") and prompt.ClickablePrompt)
    assert(prompt.KeyboardKeyCode==Enum.KeyCode.E)
    assert(prompt.GamepadKeyCode==Enum.KeyCode.ButtonX)
end

assert(assigned.Whis and assigned["Kisuke Urahara"]
    and assigned["Sung Jinwoo"] and assigned.Dante)
local dante=services:FindFirstChild("IndexStation")
assert(dante and dante:GetAttribute("NPC")=="Dante")
local eventStand=services:FindFirstChild("SeasonalEventHub")
assert(eventStand and eventStand:GetAttribute("RotatingSlot")==true)
assert(eventStand:GetAttribute("GameplayActive")==false)
local eventPrompt=eventStand:FindFirstChild("InteractionPoint")
assert(eventPrompt and eventPrompt:FindFirstChild("LobbyServicePrompt"))
assert(Config.CurrentEventId==nil and Config.GetEvent()==nil,
    "No live event should be inferred from Escanor example")
local example=Config.GetEventPreview()
assert(example and example.NPC=="Escanor"
    and example.Playable==false and example.RewardsEnabled==false
    and example.ApprovedForRelease==false)
assert(eventStand:GetAttribute("DisplayState")=="StudioPreviewOnly")

assert(lobby:FindFirstChild("LobbySpawn")==spawn
    and lobby:FindFirstChild("ArenaPortal")==portal
    and lobby:FindFirstChild("LobbyFloor")==floor,
    "Stations must not replace preexisting spawn or story portal")
assert((spawn.Position-Vector3.new(260,.5,25)).Magnitude<.01)
assert((portal.Position-Vector3.new(260,10,-38)).Magnitude<.01)

local babylon=lobby:WaitForChild("BabylonHall",70)
local edward=lobby:WaitForChild("AlchemyWorkshop",70)
local virgil=lobby:WaitForChild("VirgilSummonStand",70)
assert(babylon and edward and virgil,
    "Other NPC stations must remain")
-- The standalone Index booth must fit precisely between Vergil's stand
-- (east edge x237.5) and central 10.5-stud walkway (west edge x254.75).
local dantePos=Config.GetStation("Index").Position
assert(dantePos.X-7>237.5 and dantePos.X+7<254.75,
    "Dante's station overlaps Vergil or center walkway")
assert(math.abs(dantePos.Z-(-6))<=5,
    "Dante should remain immediately beside Vergil")
-- Both the central 10-stud event plinth and the mandatory 10.5-stud
-- walking aisle must not overlap in X.
local walkRight=265.25
local eventLeft=Config.EventHub.Position.X-5
assert(eventLeft>walkRight,"EventHub blocks main walkway")
-- Edward's current 34-stud building starts at X276.
assert(Config.EventHub.Position.X+5<276,
    "Central event plinth overlaps Edward workshop")
local folder=RS:WaitForChild("LobbyServicesRemotes",30)
assert(folder:FindFirstChild("OpenServiceInfo")
    and folder.OpenServiceInfo:IsA("RemoteEvent"))

print("[Anime Fissure] LOBBY SERVICE NETWORK SMOKE OK: Whis evolution, "..
    "Urahara Traits, Jinwoo raids, Dante Index and safe central event preview")
