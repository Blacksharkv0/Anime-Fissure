--!strict
-- ANIME FISSURE | OverlordPairSynergy v1.0
-- Original bonus passive: Ainz + Albedo in the SAME ACTIVE MATCH.
-- Each Albedo gains +30% damage; Ainz is the partner, not the beneficiary.
-- No distance requirement, rarity restriction beyond IDs, or stacking.
-- Intended for Studio combat prototype only until public release approved.

local Pair = {}
Pair.Version = "1.0.0"
Pair.Id = "DevocaoAoSupremo"
Pair.Name = "Devoção ao Supremo"
Pair.Bonus = 0.30
Pair.Multiplier = 1.30
Pair.Requirements = {"OVL_Albedo", "OVL_Ainz"}

function Pair.HasPair(owners: {[number]: any}): boolean
    local hasAinz = false
    local hasAlbedo = false
    for _, owner in pairs(owners) do
        -- Only currently fielded towers in the same match, from any team member.
        for _, tower in pairs(owner.Towers or {}) do
            if tower.Id == "OVL_Ainz" then hasAinz = true
            elseif tower.Id == "OVL_Albedo" then hasAlbedo = true end
        end
        if hasAinz and hasAlbedo then return true end
    end
    return false
end

function Pair.GetMultiplier(unitId: string, pairActive: boolean): number
    return if unitId == "OVL_Albedo" and pairActive then Pair.Multiplier else 1
end

function Pair.AppliesToInfo(unitId: string): boolean
    return unitId == "OVL_Albedo" or unitId == "OVL_Ainz"
end

return Pair
