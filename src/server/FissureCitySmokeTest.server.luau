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
print("[Anime Fissure] FISSURE CITY SMOKE OK: "..count.." decorative parts, 9 routes, existing spawn/portal safe")
