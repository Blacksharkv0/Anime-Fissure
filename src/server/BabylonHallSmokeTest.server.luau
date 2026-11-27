--!strict
-- ANIME FISSURE | Babylon Hall Studio smoke v1.0
-- Decorative art integration; must not alter mission portal, spawn or loot.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local Workspace=game:GetService("Workspace")
local lobby=Workspace:WaitForChild("FissureLobby",60)
assert(lobby and lobby:IsA("Model"),"Missing existing beta lobby")
local originalPortal=lobby:WaitForChild("ArenaPortal",15)
local originalSpawn=lobby:WaitForChild("LobbySpawn",15)
local originalFloor=lobby:WaitForChild("LobbyFloor",15)
assert(originalPortal and originalSpawn and originalFloor,
    "Babylon Hall must keep original portal/spawn/floor")
local hall=lobby:WaitForChild("BabylonHall",70)
assert(hall and hall:IsA("Model"),"Babylon Hall annex was not built")
local ready=hall:GetAttribute("Ready")
local started=os.clock()
while ready~=true and os.clock()-started<15 do
    task.wait(0.15)
    ready=hall:GetAttribute("Ready")
end
assert(ready==true,"Babylon Hall did not complete construction")
assert(hall:GetAttribute("Type")=="RelicLobbyAnnex")
assert(hall:GetAttribute("PortalCount")==11)
assert(hall:GetAttribute("RingCount")==5)
assert(hall:GetAttribute("RelicScope")=="AllWorlds")
assert(lobby:FindFirstChild("ArenaPortal")==originalPortal)
assert(lobby:FindFirstChild("LobbySpawn")==originalSpawn)
assert(lobby:FindFirstChild("LobbyFloor")==originalFloor)
assert((originalSpawn.Position-Vector3.new(260,0.5,25)).Magnitude<0.1,
    "Spawn moved unexpectedly")
assert((originalPortal.Position-Vector3.new(260,10,-38)).Magnitude<0.1,
    "Mission portal moved unexpectedly")

local portalFolder=hall:FindFirstChild("GateOfBabylonPortals")
local showcases=hall:FindFirstChild("RelicShowcases")
local king=hall:FindFirstChild("GilgameshNPC")
local architecture=hall:FindFirstChild("Architecture")
assert(portalFolder and showcases and king and architecture)
assert(#portalFolder:GetChildren()==11,"Must have 11 geek weapon portals")
assert(#showcases:GetChildren()==5,"Must have 5 real ring showcases")

local styles: {[string]: boolean}={}
for _,obj in ipairs(portalFolder:GetChildren()) do
    assert(obj:IsA("Model"),"Each portal should be an individual Model")
    local style=obj:GetAttribute("WeaponStyle")
    assert(typeof(style)=="string" and not styles[style],
        "Weapon portals must have unique archetype")
    styles[style]=true
    local decor=obj:FindFirstChild("GeekWeapon_"..style)
    local disc=obj:FindFirstChild("GoldenRippleCore")
    assert(decor and disc and disc:IsA("BasePart"),
        "Portal missing weapon or golden ripple")
    local frameCount=0
    for _,p in ipairs(obj:GetDescendants()) do
        if p:IsA("BasePart") then
            frameCount+=1
            assert(p.Anchored and not p.CanCollide and not p.CanQuery,
                "Portal decoration must never block walkways")
        end
    end
    assert(frameCount>=38,"Each portal should have ring/frame/weapon detail")
end
assert(styles.HeroBlade and styles.TitanGreatblade and styles.KeyScepter
    and styles.StarSabre and styles.FrostAxe and styles.MoonGreatsword
    and styles.CursedGreatblade and styles.OniKatana and
    styles.CelestialSpear and styles.RuneStaff and styles.DualHookBlades)

for _,id in ipairs({"MagicPowerRing","PhysicalDamageRing","SPARing",
    "RangeRing","RestrictionRing"}) do
    local plinth=showcases:FindFirstChild("Display_"..id)
    assert(plinth and plinth:GetAttribute("RingId")==id)
    local ring=plinth:FindFirstChild("Ring3D")
    assert(ring and ring:IsA("Model")
        and ring:GetAttribute("RelicRingId")==id)
end

local interaction=king:FindFirstChild("RelicMasterInteraction")
local prompt=if interaction then interaction:FindFirstChild("BabylonRelicPrompt") else nil
assert(prompt and prompt:IsA("ProximityPrompt") and prompt.ClickablePrompt
    and prompt.KeyboardKeyCode==Enum.KeyCode.E
    and prompt.GamepadKeyCode==Enum.KeyCode.ButtonX)
assert(prompt.ActionText=="VER RELIQUIAS")
assert(king:GetAttribute("RelicScope")=="AllWorlds")
assert(king:GetAttribute("Prototype")=="DecorativeStaticNpc",
    "Gilgamesh must not impersonate a finished rig")
local bridge=architecture:FindFirstChild("BridgeFoundation")
assert(bridge and bridge:IsA("BasePart") and bridge.CanCollide,
    "The annex must have a walkable bridge connected to the plaza")

local visualParts=0
for _,obj in ipairs(hall:GetDescendants()) do
    if obj:IsA("BasePart") then visualParts+=1 end
end
assert(visualParts<1800,
    "Babylon annex too many parts; optimize for mobile before release")

print("[Anime Fissure] BABYLON HALL SMOKE OK: 11 weapon portals, "..
    "5 ring vitrines, NPC prompt, connected bridge and original lobby safe")
