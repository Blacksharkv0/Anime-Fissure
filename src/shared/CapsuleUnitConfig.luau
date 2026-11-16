--!strict
-- ANIME FISSURE | CapsuleUnitConfig v0.1
-- Fonte unica: familia Capsule, banner, evolucao e economia.
-- O summon atual e apenas cinematografico; o backend futuro deve usar CapsuleAccessService.

local Config = {}

Config.Version = "0.1.0"
Config.LegendaryId = "Capsule"
Config.MythicId = "CapsuleCorp"
Config.MoneyRelicId = "DB_MoneyCapsule"

Config.Definitions = {
    Capsule = {
        Id = "Capsule",
        DisplayName = "Capsule",
        Rarity = "Legendary",
        ObtainMethod = "Summon",
        BannerEligible = true,
        ShinyEligible = true,
        CanEvolveTo = "CapsuleCorp",
        PlacementCost = 500,
        CashPerWave = 700,
        Damage = 0,
        MaxUpgrades = 8,
        MaxPlacements = 3,
    },
    CapsuleCorp = {
        Id = "CapsuleCorp",
        DisplayName = "Capsule (Corp)",
        Rarity = "Mythic",
        ObtainMethod = "EvolutionOnly",
        BannerEligible = false,
        ShinyEligible = false, -- A Shiny Mitica e herdada da Lendaria; nunca sorteada.
        EvolvesFrom = "Capsule",
        CashPerWave = 1200,
        Damage = 0,
        MaxUpgrades = 12,
        MaxPlacements = 1,
        -- PlacementCost e upgrades miticos aguardam valores oficiais.
    },
}

-- Percentuais da Lendaria, aplicados sobre a RENDA DA WAVE ANTERIOR.
Config.LegendaryIncomeGrowth = {0.40, 0.40, 0.40, 0.70, 0.40, 0.40, 0.40, 0.70}
Config.Inventions = {
    {Level = 4, ModelId = "CapsuleCashPrinter", Name = "Impressora de Capsulas", Bonus = 0.20},
    {Level = 8, ModelId = "CapsuleSupportDevice", Name = "Dispositivo de Suporte", Bonus = 0.20},
}

-- O primeiro upgrade e 540, conforme a especificacao enviada.
-- Do segundo em diante, usamos +40% sobre o custo anterior.
-- Isso resolve provisoriamente a contradicao entre "+40%" e "500 -> 540".
Config.LegendaryFirstUpgradeCost = 540
Config.LegendaryNextCostMultiplier = 1.40

function Config.Get(id: string)
    return Config.Definitions[id]
end

function Config.CanAppearInBanner(id: string): boolean
    local def = Config.Get(id)
    return def ~= nil and def.BannerEligible == true
end

function Config.CanObtainFrom(id: string, method: string): boolean
    local def = Config.Get(id)
    if def == nil then return false end
    return def.ObtainMethod == method
end

function Config.GetBannerEntries(): {{Id: string, ShinyEligible: boolean, Rarity: string}}
    -- Nao inclui a versao Mitica em nenhuma hipotese.
    return {{Id = "Capsule", ShinyEligible = true, Rarity = "Legendary"}}
end

function Config.GetEvolutionResult(id: string, shiny: boolean)
    if id ~= Config.LegendaryId or typeof(shiny) ~= "boolean" then
        return nil
    end
    return {
        Id = Config.MythicId,
        Shiny = shiny, -- normal vira normal; Shiny vira Shiny.
        Rarity = "Mythic",
        ObtainMethod = "EvolutionOnly",
    }
end

local function validLevel(level: number, limit: number): boolean
    return typeof(level) == "number"
        and level == level
        and level % 1 == 0
        and level >= 0
        and level <= limit
end

function Config.GetUpgradePrice(id: string, targetUpgrade: number): number?
    if id ~= Config.LegendaryId or not validLevel(targetUpgrade, 8)
        or targetUpgrade == 0 then
        return nil
    end
    local price = Config.LegendaryFirstUpgradeCost
    for _ = 2, targetUpgrade do
        price = math.floor(price * Config.LegendaryNextCostMultiplier + 0.5)
    end
    return price
end

function Config.GetUnlockedInventions(id: string, level: number): {string}
    local def = Config.Get(id)
    if not def or not validLevel(level, def.MaxUpgrades) then return {} end
    local models = {}
    for _, invention in ipairs(Config.Inventions) do
        if level >= invention.Level then
            table.insert(models, invention.ModelId)
        end
    end
    return models
end

function Config.GetPlacementCost(id: string, moneyCapsuleEquipped: boolean): number?
    local def = Config.Get(id)
    if not def or def.PlacementCost == nil then return nil end
    local price = def.PlacementCost
    if moneyCapsuleEquipped then
        price *= 0.70 -- -30% somente na colocacao dessa Capsule.
    end
    return math.floor(price + 0.5)
end

function Config.GetIncomePerWave(id: string, level: number, moneyCapsuleEquipped: boolean): number?
    local def = Config.Get(id)
    if not def or not validLevel(level, def.MaxUpgrades) then return nil end
    local income = def.CashPerWave
    if id == Config.LegendaryId then
        for i = 1, level do
            income *= 1 + Config.LegendaryIncomeGrowth[i]
        end
    elseif level > 0 then
        -- A curva de upgrades da Mitica ainda nao foi definida.
        return nil
    end
    local inventionBonus = 0
    for _, invention in ipairs(Config.Inventions) do
        if level >= invention.Level then
            inventionBonus += invention.Bonus
        end
    end
    income *= 1 + inventionBonus
    if moneyCapsuleEquipped then
        income *= 1.50 -- +50% fixo na producao daquela unidade.
    end
    return math.floor(income + 0.5)
end

return Config
