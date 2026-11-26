--!strict
-- ANIME FISSURE | OverlordBalanceConfig v0.1
-- STUDIO PROTOTYPE, NOT LIVE BANNER BALANCE.
-- The user's first hierarchy: Secret strongest overall offensive performance,
-- Mythic next, Legendary, Epic, Rare, Common. Individual SPA can express role.
-- Level 1 = FIRST PURCHASED UPGRADE. Level 0 = just placed.
-- Damage numbers are single-hit base stats, before stage effects, buffs,
-- crits, enemy resistances, Blood Pool and extra targets.
-- Future anime worlds may override individual stats rather than inheriting
-- rigid rarity-wide numbers. No automatic rarity multiplier at runtime.

local Balance = {}
Balance.Version = "0.1.0"
Balance.Mode = "StudioOverlordBalance"
Balance.MaxLevel = 9
Balance.DamageGrowthPerLevel = 0.17   -- linear: +17% of Lv1 per level after Lv1
Balance.SPAReductionPerLevel = 0.028  -- linear reduction from Lv1 SPA
Balance.RangeGrowthPerLevel = 0.75   -- studs per level
Balance.MinimumSPA = 0.32

Balance.OrderLowToHigh = {
    "OVL_Climb", "OVL_Brain", "OVL_Gazef",
    "OVL_Shalltear", "OVL_Albedo", "OVL_Ainz",
}

Balance.Units = {
    OVL_Climb = {
        Rarity="Common", Role="NoviceSword", Level1Damage=120,
        Level1SPA=1.55, Level1Range=20.0,
    },
    OVL_Brain = {
        Rarity="Rare", Role="FastCritDuelist", Level1Damage=200,
        Level1SPA=1.30, Level1Range=23.0,
    },
    OVL_Gazef = {
        Rarity="Epic", Role="HeavyAntiArmorCleave", Level1Damage=320,
        Level1SPA=1.72, Level1Range=25.0,
    },
    OVL_Shalltear = {
        Rarity="Legendary", Role="VampiricSustainedDPS", Level1Damage=480,
        Level1SPA=1.83, Level1Range=28.0,
    },
    OVL_Albedo = {
        Rarity="Mythic", Role="GuardianSupportAOE", Level1Damage=700,
        Level1SPA=2.10, Level1Range=30.0,
    },
    OVL_Ainz = {
        Rarity="Secret", Role="SupremeMagicDPS", Level1Damage=1000,
        Level1SPA=1.88, Level1Range=36.0,
    },
}

local function round(value: number, places: number): number
    local scale=10^places
    return math.floor(value*scale+0.5)/scale
end

function Balance.Get(id: string)
    local unit=Balance.Units[id]
    return if unit then table.clone(unit) else nil
end

function Balance.GetStats(id: string, level: number)
    local item=Balance.Units[id]
    if not item or typeof(level)~="number" or level%1~=0
        or level<0 or level>Balance.MaxLevel then return nil end

    local damage: number
    local spa: number
    local range: number
    if level==0 then
        -- The first upgrade reaches EXACTLY Level1Damage/SPA/Range.
        damage=round(item.Level1Damage/(1+Balance.DamageGrowthPerLevel),0)
        spa=round(item.Level1SPA*(1+Balance.SPAReductionPerLevel),2)
        range=round(item.Level1Range-Balance.RangeGrowthPerLevel,2)
    else
        damage=round(item.Level1Damage*
            (1+Balance.DamageGrowthPerLevel*(level-1)),0)
        spa=round(math.max(Balance.MinimumSPA,
            item.Level1SPA*(1-Balance.SPAReductionPerLevel*(level-1))),2)
        range=round(item.Level1Range+Balance.RangeGrowthPerLevel*(level-1),2)
    end
    return {Damage=damage, SPA=spa, Range=range, Income=0}
end

function Balance.GetBaseDPS(id: string, level: number): number?
    local stats=Balance.GetStats(id,level)
    return if stats then stats.Damage/stats.SPA else nil
end

return Balance
