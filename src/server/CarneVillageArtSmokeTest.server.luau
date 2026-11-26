--!strict
-- ANIME FISSURE | Carne Village v0.8 art validation
-- Studio only: checks art added without altering path, spawns, BaseCore.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local Workspace=game:GetService("Workspace")
local arena=Workspace:WaitForChild("FissureArena",60)
assert(arena and arena:IsA("Model"),"Carne Village arena missing")
local art=arena:WaitForChild("CarneVillageArtPass",60)
assert(art and art:IsA("Model"),"CarneVillageArtPass missing")
assert(art:GetAttribute("Version")=="0.8.0","Incorrect map art pass version")
local path=arena:FindFirstChild("EnemyPath")
local base=arena:FindFirstChild("FissureBase")
local spawn=arena:FindFirstChild("PlayerSpawns")
assert(path and base and spawn,"Core game objects removed by art pass")
assert(base:FindFirstChild("BaseCore"),"BaseCore must keep the match contract")
assert(#path:GetChildren()==8,"Expected eight original enemy waypoints")
assert(#spawn:GetChildren()==4,"Expected four player spawns")
for i=1,8 do
    local wp=path:FindFirstChild(string.format("Waypoint_%02d",i))
    assert(wp and wp:GetAttribute("Order")==i,
        "Enemy path order changed at "..i)
end
local parts=0
for _,item in ipairs(art:GetDescendants()) do
    if item:IsA("BasePart") then
        assert(item.Anchored,"Unanchored map decoration: "..item.Name)
        assert(not item.CanCollide and not item.CanTouch and not item.CanQuery,
            "Map deco must not interfere with placement or player physics: "..item.Name)
        parts+=1
    end
end
assert(parts>=180 and parts<=1000,
    "Unexpected amount of Carne Village decorations: "..parts)
print("[Anime Fissure] CARNE VILLAGE ART TEST OK: "..
    tostring(parts).." decoracoes | 8 waypoints | 4 spawns | base preservada")
