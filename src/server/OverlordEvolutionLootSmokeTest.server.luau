--!strict
-- ANIME FISSURE | Overlord evolution loot map assignment test v1.0.
-- No item rewards are granted; verifies planning data without fake drops.
local RunService = game:GetService("RunService")
if not RunService:IsStudio() then return end

local RS=game:GetService("ReplicatedStorage")
local shared=RS:WaitForChild("Shared")
local Story=require(shared:WaitForChild("StoryConfig"))
local Loot=require(shared:WaitForChild("OverlordEvolutionLootConfig"))
local Info=require(shared:WaitForChild("StageInfoConfig"))

local expected={
    OVL_01={"MagicPowerRing"},
    OVL_02={"SPARing"},
    OVL_03={"PhysicalDamageRing"},
    OVL_04={"ShalltearEvolutionItem"},
    OVL_05={"RangeRing"},
    OVL_06={"RestrictionRing","AlbedoEvolutionItem"},
}

local count=0
local seen: {[string]: boolean}={}
local world=Story.GetWorld("Overlord")
assert(world and #world.Stages==6,"Overlord must keep six story maps")
for index,stage in ipairs(world.Stages) do
    local approved=expected[stage.Id]
    assert(approved,"Unexpected Overlord stage: "..stage.Id)
    local entries=Loot.GetStageItems(stage.Id)
    assert(#entries==#approved, "Evolution items count mismatch: "..stage.Id)
    for i,item in ipairs(entries) do
        assert(item.Id==approved[i], "Unexpected evolution item in "..stage.Id)
        assert(item.StageId==stage.Id,
            "Invalid item stage classification")
        if item.Relic == true then
            assert(item.Type=="EvolutionRelic" and item.Equippable==true
                and item.EvolutionLink=="OVL_Ainz",
                "Ring must be relic and evolution material for Ainz")
        else
            assert(item.Type=="EvolutionMaterial" and item.Relic~=true,
                "Dedicated character evolution items must not become rings")
        end
        assert(not seen[item.Id], "Evolution item registered twice: "..item.Id)
        seen[item.Id]=true
        local source=Loot.GetItem(item.Id)
        assert(source and source.Name==item.Name)
        assert(Loot.IsDropEnabled(item.Id,stage.Id,"Classic")==false)
        assert(Loot.IsDropEnabled(item.Id,stage.Id,"Hard")==false)
        count+=1
    end
    assert(Story.GetStage("Overlord",index).Id==stage.Id)
end
assert(count==7,"Expected exactly seven new evolution items")
local hard=Loot.GetPlannedPreview("OVL_01","Hard")
local classic=Loot.GetPlannedPreview("OVL_01","Classic")
assert(#hard==1 and hard[1].Id=="MagicPowerRing")
assert(hard[1].Chance==nil and hard[1].Pity==nil
    and hard[1].Obtained==nil and hard[1].Enabled==false)
assert(#classic==0,"Magic Power Ring must be planned for Hard only")
assert(Loot.GetItem("ShalltearEvolutionItem").EvolutionLink=="OVL_Shalltear")
assert(Loot.GetItem("AlbedoEvolutionItem").EvolutionLink=="OVL_Albedo")
assert(Loot.GetItem("MagicPowerRing").EvolutionLink=="OVL_Ainz")

-- The Stage Info currently only resolves OVL_01 in combat.
local panelHard=Info.BuildPayload("OVL_01","Hard")
local panelClassic=Info.BuildPayload("OVL_01","Classic")
assert(panelHard and panelClassic)
assert(#panelHard.PlannedEvolutionItems==1)
assert(panelHard.PlannedEvolutionItems[1].Id=="MagicPowerRing")
assert(#panelClassic.PlannedEvolutionItems==0)
assert(panelHard.RewardsActive==false,
    "Planned evolution materials must not activate reward delivery")
assert(Loot.GetPlannedPreview("OVL_06","Hard")[1]==nil,
    "Do not assume Hard eligibility for Nazarick before design approves it")

print("[Anime Fissure] OVERLORD EVOLUTION LOOT TEST OK: " ..
    tostring(count) .. " item assignments across 6 story stages; no live drops")
