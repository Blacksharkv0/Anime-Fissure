--!strict
-- ANIME FISSURE | Carne Village v0.8 visual boot
-- Loads AFTER BetaMap builds. Never changes tower placement or paths.
local Workspace=game:GetService("Workspace")
local Art=require(script.Parent:WaitForChild("CarneVillageArtPass"))
local arena=Workspace:WaitForChild("FissureArena")
if not arena:IsA("Model") then return end
while not arena:GetAttribute("Ready") do
    arena:GetAttributeChangedSignal("Ready"):Wait()
end
if arena:GetAttribute("MapType")~="CarneVillage" then return end
local ok,result=pcall(function() return Art.Apply(arena) end)
if ok then
    print("[Anime Fissure] CARNE VILLAGE ART PASS v"..Art.Version.." | "..#result:GetDescendants().." detalhes")
else
    warn("[Anime Fissure] CarneVillageArtPass falhou: "..tostring(result))
end
