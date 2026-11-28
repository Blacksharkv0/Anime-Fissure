--!strict
-- Studio integration audit; no claim of visual approval or live gameplay.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local Workspace=game:GetService("Workspace")
local lobby=Workspace:WaitForChild("FissureLobby",60)
assert(lobby and lobby:IsA("Model"))
local floor=lobby:WaitForChild("LobbyFloor",20)
local spawn=lobby:WaitForChild("LobbySpawn",20)
local portal=lobby:WaitForChild("ArenaPortal",20)
local city=lobby:WaitForChild("FissureCity",60)
assert(city and city:IsA("Model") and city:GetAttribute("Ready")==true)
assert(lobby:GetAttribute("CityReady")==true)
assert(floor and floor:IsA("BasePart") and floor.CanCollide and floor.Size==Vector3.new(110,4,110))
assert(spawn and spawn:IsA("SpawnLocation") and (spawn.Position-Vector3.new(260,.5,25)).Magnitude<.1)
assert(portal and portal:IsA("BasePart") and (portal.Position-Vector3.new(260,10,-38)).Magnitude<.1)
assert(portal:FindFirstChild("MissionBoardPrompt"))
local paving=city:FindFirstChild("CityPaving")
assert(paving)
for _,name in ipairs({"StoryBoulevard","SummonAvenue","AlchemyAvenue","TraitsAvenue","EvolutionAvenue",
    "RaidAvenue","IndexAvenue","RoyalAvenue","SeasonalAvenue"}) do
    assert(paving:FindFirstChild(name),"Missing city route "..name)
end
local plaza=city:FindFirstChild("CentralPlaza")
assert(plaza and plaza:FindFirstChild("FissureMonument"))
for _,name in ipairs({"ArrivalGate","StoryCitadel","SeasonalCourt","RoyalEntrance","EdgeGardens","CityEdge","Skyline"}) do
    assert(city:FindFirstChild(name),"Missing city landmark "..name)
end
local districts=city:FindFirstChild("DistrictArchitecture")
assert(districts)
for _,spec in ipairs({{"Summon","CapsuleCore"},{"Alchemy","ReagentBottle"},{"Index","ArchiveDataBar"},
    {"Evolution","CelestialOrbit0"},{"Traits","TraitSigil"},{"Raids","ShadowRiftArch0"}}) do
    local district=districts:FindFirstChild(spec[1])
    assert(district and district:FindFirstChild(spec[2]),"Missing unique district detail "..spec[1])
end
local immersion=city:FindFirstChild("Immersion")
assert(immersion and immersion:GetAttribute("Ready")==true)
assert(city:GetAttribute("ImmersionVersion")=="1.0.0")
local facades=immersion:FindFirstChild("FacadeDetails")
assert(facades and #facades:GetChildren()==6)
for _,d in ipairs(facades:GetChildren()) do
    assert(d:FindFirstChild("RecessedWing") and d:FindFirstChild("FloatingCanopy"))
end
local lights,floats=0,0
for _,obj in ipairs(immersion:GetDescendants()) do
    if obj:IsA("BasePart") then
        if obj:GetAttribute("CityLocalLight")==true then lights+=1 end
        if obj:GetAttribute("CityFloat")==true then floats+=1 end
    end
end
assert(lights==8 and floats==6,"Immersion anchors mismatch")
assert(immersion:FindFirstChild("Wayfinding") and immersion:FindFirstChild("StreetFurniture"))
local count=0
for _,obj in ipairs(city:GetDescendants()) do
    if obj:IsA("BasePart") then
        count+=1
        assert(obj.Anchored and not obj.CanCollide and not obj.CanTouch and not obj.CanQuery,
            "City decorative part obstructs gameplay: "..obj:GetFullName())
    end
end
assert(city:GetAttribute("DecorativePartCount")==count)
assert(count<900,"City decorative part budget exceeded: "..count)
-- Confirm that the original east border does not cut through the bridge.
for _,obj in ipairs(lobby:GetChildren()) do
    if obj:IsA("BasePart") and obj.Name=="BlueBorder" and math.abs(obj.Position.X-314)<.1 then
        assert(obj.Position.Z+obj.Size.Z/2<=13.01 or obj.Position.Z-obj.Size.Z/2>=26.99,
            "East border intersects Babylon bridge")
    end
end
-- WORLD POLISH: preserve physical edges, passage, and front-facing prompts.
assert(city:GetAttribute("WorldPolishVersion")=="1.0.0")
local skyline=city:FindFirstChild("Skyline")
assert(skyline and skyline:FindFirstChild("WestTower_4") and skyline:FindFirstChild("FarIsland_2"))
local safety=lobby:WaitForChild("CitySafety",20)
assert(safety and safety:GetAttribute("Ready")==true)
local guards=0
for _,obj in ipairs(safety:GetChildren()) do
    if obj:IsA("BasePart") and obj.Name~="RailTrim" then
        guards+=1
        assert(obj.Anchored and obj.CanCollide and obj.Size.Y>=4)
        if obj.Name=="EastGuard" then
            assert(obj.Position.Z+obj.Size.Z/2<=13.01 or obj.Position.Z-obj.Size.Z/2>=26.99)
        elseif obj.Name=="BridgeGuard" then
            assert(math.abs(obj.Position.Z-20)>5.4)
        end
    end
end
assert(guards==7,"Unexpected physical guard count")
local services=lobby:WaitForChild("LobbyServiceStations",60)
assert(services)
for _,spec in ipairs({{"Evolution",-1},{"Traits",-1},{"Index",1},{"Raids",1}}) do
    local station=services:WaitForChild(spec[1].."Station",15)
    assert(station)
    local footprint=station:WaitForChild("Footprint",15)
    local prompt=station:WaitForChild("InteractionPoint",15)
    assert(footprint and footprint:IsA("BasePart") and prompt and prompt:IsA("BasePart"))
    assert(math.abs(prompt.Position.Z-footprint.Position.Z-4.25*spec[2])<.1,
        "Interaction is not facing the public approach: "..spec[1])
    assert(prompt:FindFirstChild("LobbyServicePrompt"))
end
print("[Anime Fissure] WORLD POLISH SMOKE OK: safe edges, bridge channel and forward prompts")
print("[Anime Fissure] FISSURE CITY SMOKE OK: "..count.." decorative parts, 9 routes, existing spawn/portal safe")
