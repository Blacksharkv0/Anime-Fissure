--!strict
-- ANIME FISSURE | OverlordEvolutionLootConfig v1.0
-- Approved map -> evolution item mapping from game designer (26/11/2026).
-- DATA ONLY: rings are evolution materials AND equippable relic designs.
-- Does not enable real drops, pity, inventory, or evolution crafting.
-- Carne Village's Magic Power Ring is designated for HARD farming.
-- Other stages' eligible difficulties are intentionally UNDECIDED.
local Rings = require(script.Parent:WaitForChild("RelicRingConfig"))
local Loot = {}
Loot.Version = "1.1.0"
Loot.Status = "Planned_NoActiveDrops"
Loot.WorldId = "Overlord"

Loot.Items = {
    MagicPowerRing = {
        Id = "MagicPowerRing", Name = "Anel de Magic Power",
        Type = "EvolutionRelic", StageId = "OVL_01",
        Relic = true, Equippable = true, EvolutionLink = "OVL_Ainz",
        Difficulty = "Hard",
    },
    SPARing = {
        Id = "SPARing", Name = "Anel de SPA",
        Type = "EvolutionRelic", StageId = "OVL_02",
        Relic = true, Equippable = true, EvolutionLink = "OVL_Ainz",
        Difficulty = "Undecided",
    },
    PhysicalDamageRing = {
        Id = "PhysicalDamageRing", Name = "Anel de dano físico",
        Type = "EvolutionRelic", StageId = "OVL_03",
        Relic = true, Equippable = true, EvolutionLink = "OVL_Ainz",
        Difficulty = "Undecided",
    },
    ShalltearEvolutionItem = {
        Id = "ShalltearEvolutionItem", Name = "Item de evolução da Shalltear",
        Type = "EvolutionMaterial", StageId = "OVL_04",
        Difficulty = "Undecided", EvolutionLink = "OVL_Shalltear",
    },
    RangeRing = {
        Id = "RangeRing", Name = "Anel de range",
        Type = "EvolutionRelic", StageId = "OVL_05",
        Relic = true, Equippable = true, EvolutionLink = "OVL_Ainz",
        Difficulty = "Undecided",
    },
    RestrictionRing = {
        Id = "RestrictionRing", Name = "Anel da restrição",
        Type = "EvolutionRelic", StageId = "OVL_06",
        Relic = true, Equippable = true, EvolutionLink = "OVL_Ainz",
        Difficulty = "Undecided",
    },
    AlbedoEvolutionItem = {
        Id = "AlbedoEvolutionItem", Name = "Item de evolução da Albedo",
        Type = "EvolutionMaterial", StageId = "OVL_06",
        Difficulty = "Undecided", EvolutionLink = "OVL_Albedo",
    },
}

Loot.ByStage = {
    OVL_01 = {"MagicPowerRing"},
    OVL_02 = {"SPARing"},
    OVL_03 = {"PhysicalDamageRing"},
    OVL_04 = {"ShalltearEvolutionItem"},
    OVL_05 = {"RangeRing"},
    OVL_06 = {"RestrictionRing", "AlbedoEvolutionItem"},
}

local function readOnlyCopy(item: any): any
    return if item then table.clone(item) else nil
end

function Loot.GetItem(itemId: string)
    return readOnlyCopy(Loot.Items[itemId])
end

-- Returns planned catalog entries. Unknown eligibility is never treated as
-- an active drop, even when the caller supplies a difficulty.
function Loot.GetStageItems(stageId: string): {any}
    local entries: {any} = {}
    for _, itemId in ipairs(Loot.ByStage[stageId] or {}) do
        local item = Loot.Items[itemId]
        if item then table.insert(entries, readOnlyCopy(item)) end
    end
    return entries
end

-- This is for showing PLANNED items in Stage Info only.
-- Do not use this function to perform rolls or grant items.
function Loot.GetPlannedPreview(stageId: string, difficulty: string): {any}
    local results: {any} = {}
    if difficulty ~= "Hard" and difficulty ~= "Classic" then return results end
    for _, item in ipairs(Loot.GetStageItems(stageId)) do
        -- Carne Village's approved item is Hard-only; unknown stages are
        -- visible in the catalog, but are not automatically Hard-only.
        if item.Difficulty == difficulty then
            table.insert(results, {
                Id = item.Id, Name = item.Name, Type = item.Type,
                Relic = item.Relic == true,
                RelicDescription = if item.Relic then Rings.Get(item.Id).Description else nil,
                Planned = true, Enabled = false, Chance = nil,
                Pity = nil, Obtained = nil, ProgressConnected = false,
                Difficulty = item.Difficulty,
            })
        end
    end
    return results
end

function Loot.IsDropEnabled(_itemId: string, _stageId: string, _difficulty: string): boolean
    return false
end

return Loot
