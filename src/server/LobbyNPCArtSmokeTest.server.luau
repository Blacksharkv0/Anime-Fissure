--!strict
-- ANIME FISSURE | Studio art audit for all lobby mentor NPCs v1.0.
-- This runs after the procedural models are constructed.
-- It confirms unique recognizable details without claiming licensed meshes
-- or live animation. All new ornaments are non-solid and safely anchored.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local RS=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Art=require(RS:WaitForChild("Shared"):WaitForChild("LobbyNPCArtFinish"))
local lobby=Workspace:WaitForChild("FissureLobby",70)
local stations=lobby:WaitForChild("LobbyServiceStations",70)
local started=os.clock()
while stations:GetAttribute("Ready")~=true and os.clock()-started<15 do
    task.wait(.2)
end
assert(stations:GetAttribute("Ready")==true)

local expected={
    {station="IndexStation",npc="DanteNPC",
        markers={"DanteCollarL","DanteBangs_3","DanteCoatButton_4",
            "SwordPommel"}},
    {station="EvolutionStation",npc="WhisNPC",
        markers={"NeckRingPremium1","AngelCuff_1","DiamondRobe_1"}},
    {station="TraitsStation",npc="KisukeUraharaNPC",
        markers={"SandySideHair_1","FoldedFanLeaf_3","HatDroop_1"}},
    {station="RaidsStation",npc="SungJinwooNPC",
        markers={"ObsidianPauldron_1","SpectralFlare_1",
            "HunterCoatEdge_1"}},
}
local finished=0
for _,entry in ipairs(expected) do
    local stand=stations:FindFirstChild(entry.station)
    assert(stand,"Missing art station "..entry.station)
    local npc=stand:FindFirstChild(entry.npc)
    assert(npc and npc:IsA("Model"),"Missing model "..entry.npc)
    assert(npc:GetAttribute("ArtFinish")==Art.Version,
        "Art finish did not attach to "..entry.npc)
    for _,marker in ipairs(entry.markers) do
        local part=npc:FindFirstChild(marker)
        assert(part and part:IsA("BasePart"),
            "Missing recognizable detail "..entry.npc..":"..marker)
        assert(part.Anchored and not part.CanCollide and not part.CanTouch
            and not part.CanQuery,"Decorative art blocks movement or hitboxes")
    end
    finished+=1
end
local index=stations:FindFirstChild("IndexStation")
local dante=if index then index:FindFirstChild("DanteNPC") else nil
assert(dante and dante:IsA("Model") and dante:GetAttribute("CharacterReborn")=="Dante-v1")
local danteHead=dante:FindFirstChild("Head")
assert(danteHead and danteHead:IsA("BasePart") and dante.PrimaryPart==danteHead)
assert(danteHead:FindFirstChild("Reborn_DanteFace"))
for _,name in ipairs({"DanteBangs_7","DanteCollarL","Reborn_DanteTail_1",
    "Reborn_DantePocket_-1","Reborn_DanteBladeCore","Reborn_DanteSwordGuard",
    "SwordPommel","Reborn_DanteBootLace_1_3"}) do
    local p=dante:FindFirstChild(name)
    assert(p and p:IsA("BasePart") and p.Anchored and not p.CanCollide
        and not p.CanQuery and not p.CanTouch,"Dante detail missing or unsafe: "..name)
end
local danteParts=0
for _,p in ipairs(dante:GetChildren()) do
    if p:IsA("BasePart") and string.sub(p.Name,1,7)=="Reborn_" then
        danteParts+=1
        assert(p.Anchored and not p.CanCollide and not p.CanQuery and not p.CanTouch)
    end
end
assert(danteParts>=70 and danteParts<=130,"Dante cosmetic geometry budget: "..danteParts)
local indexAnchor=index:FindFirstChild("InteractionPoint")
local indexPrompt=if indexAnchor then indexAnchor:FindFirstChild("LobbyServicePrompt") else nil
assert(indexPrompt and indexPrompt:IsA("ProximityPrompt") and indexPrompt.Enabled and indexPrompt.ClickablePrompt)
print("[Anime Fissure] DANTE REBORN SMOKE OK: "..danteParts.." static cosmetic parts, Index prompt preserved")

local raids=stations:FindFirstChild("RaidsStation")
local hunter=if raids then raids:FindFirstChild("SungJinwooNPC") else nil
assert(hunter and hunter:IsA("Model") and hunter:GetAttribute("CharacterReborn")=="Jinwoo-v1")
local hunterHead=hunter:FindFirstChild("Head")
assert(hunterHead and hunterHead:IsA("BasePart") and hunter.PrimaryPart==hunterHead)
assert(hunterHead:FindFirstChild("Reborn_ShadowFace"))
for _,name in ipairs({"Reborn_Fringe_0","Reborn_Lapel_1","Reborn_CoatTail_1",
    "Reborn_Dagger_1_Core","Reborn_Dagger_-1_Edge","Reborn_ShadowWisp_1","HunterCircle1"}) do
    local p=hunter:FindFirstChild(name)
    assert(p and p:IsA("BasePart") and p.Anchored and not p.CanCollide
        and not p.CanQuery and not p.CanTouch,"Jinwoo detail missing or unsafe: "..name)
end
local newParts=0
for _,p in ipairs(hunter:GetChildren()) do
    if p:IsA("BasePart") and string.sub(p.Name,1,7)=="Reborn_" then
        newParts+=1
        assert(p.Anchored and not p.CanCollide and not p.CanTouch and not p.CanQuery)
    end
end
assert(newParts>=70 and newParts<=120,"Jinwoo cosmetic geometry budget: "..newParts)
local interaction=raids:FindFirstChild("InteractionPoint")
local raidPrompt=if interaction then interaction:FindFirstChild("LobbyServicePrompt") else nil
assert(raidPrompt and raidPrompt:IsA("ProximityPrompt") and raidPrompt.Enabled and raidPrompt.ClickablePrompt)
assert(raids:GetAttribute("GameplayActive")==false,"Art pass must not activate raids")
print("[Anime Fissure] JINWOO REBORN SMOKE OK: "..newParts.." static cosmetic parts, raid prompt preserved")

local event=stations:FindFirstChild("SeasonalEventHub")
assert(event and event:GetAttribute("DisplayState")=="StudioPreviewOnly")
local example=event:FindFirstChild("EscanorNPC")
assert(example and example:GetAttribute("ArtFinish")==Art.Version)
assert(example:FindFirstChild("SolarCrown1"),
    "Escanor event concept should remain visually distinct, Studio only")

local hall=lobby:WaitForChild("BabylonHall",70)
local king=hall:FindFirstChild("GilgameshNPC")
assert(king and king:GetAttribute("ArtFinish")==Art.Version)
for _,name in ipairs({"ImperialPauldron_1","RoyalChestSigil",
    "GoldenBrow_1","BabylonGoldSigil1"}) do
    assert(king:FindFirstChild(name),"Gilgamesh is missing detail "..name)
end
assert(king:GetAttribute("Prototype")=="DecorativeStaticNpc")

local old=lobby:WaitForChild("VirgilSummonStand",40)
local edward=lobby:WaitForChild("AlchemyWorkshop",40)
assert(old and edward and old:WaitForChild("VirgilNPC",40)
    and edward:WaitForChild("AlchemistNPC",40),
    "Old rigged Vergil/Edward must survive the mentor art pass")

print("[Anime Fissure] PREMIUM LOBBY ART SMOKE OK: "..finished..
    " mentor details, Escanor preview, Gilgamesh and old NPCs safe")
