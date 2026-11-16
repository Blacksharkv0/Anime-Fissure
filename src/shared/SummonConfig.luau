--!strict
-- ANIME FISSURE | SummonConfig v0.1
-- Banner inicial: somente Capsule lendaria (normal e Shiny).
-- Taxa Shiny e moeda sao PROVISORIAS para o primeiro teste.
-- A Mitica CapsuleCorp NUNCA pertence ao banner.

local CapsuleConfig = require(script.Parent:WaitForChild("CapsuleUnitConfig"))

local Config = {}
Config.Version = "0.1.0"
-- Futuras unidades devem ser cadastradas AQUI e no Pool, explicitamente.
-- Deixe vazio ate cada unidade possuir builder, atributos e origem aprovados.
Config.AdditionalEligibleUnits = {} :: {[string]: boolean}

Config.Banner = {
    Id = "CapsuleLaunch",
    Name = "Fissura das Capsulas",
    Currency = "SummonTickets", -- sera ligada a economia definitiva depois
    PriceOne = 1,
    PriceTen = 10,
    ShinyChance = 0.01, -- PROVISORIO: 1%; alterar aqui apos balanceamento
    ShinyPity = 0, -- 0 significa SEM garantia Shiny por enquanto
    Pool = {
        {UnitId = "Capsule", Weight = 10000, Rarity = "Legendary"},
    },
}

function Config.IsAllowedCount(count: any): boolean
    return typeof(count) == "number" and (count == 1 or count == 10)
end

function Config.GetCost(count: number): number?
    if count == 1 then return Config.Banner.PriceOne end
    if count == 10 then return Config.Banner.PriceTen end
    return nil
end

function Config.IsInBanner(unitId: string): boolean
    if unitId == "CapsuleCorp" then return false end
    local approved = if unitId == "Capsule" then CapsuleConfig.CanAppearInBanner(unitId)
        else Config.AdditionalEligibleUnits[unitId] == true
    if not approved then return false end
    for _, entry in ipairs(Config.Banner.Pool) do
        if entry.UnitId == unitId and entry.Weight > 0 then return true end
    end
    return false
end

function Config.GetPublicInfo()
    local units = {}
    for _, entry in ipairs(Config.Banner.Pool) do
        if Config.IsInBanner(entry.UnitId) then
            table.insert(units, {
                UnitId = entry.UnitId,
                Name = if CapsuleConfig.Get(entry.UnitId) then CapsuleConfig.Get(entry.UnitId).DisplayName
                    else (entry.Name or entry.UnitId),
                Rarity = entry.Rarity,
                Weight = entry.Weight,
            })
        end
    end
    return {
        Id = Config.Banner.Id,
        Name = Config.Banner.Name,
        Currency = Config.Banner.Currency,
        PriceOne = Config.Banner.PriceOne,
        PriceTen = Config.Banner.PriceTen,
        ShinyChance = Config.Banner.ShinyChance,
        ShinyPity = Config.Banner.ShinyPity,
        Units = units,
    }
end

-- Calculo PURO: pode ser repetido pelo UpdateAsync durante uma disputa
-- entre servidores. Nao acessa Workspace, remotes ou DataStore.
function Config.Roll(count: number, misses: number, seed: number): ({any}, number)
    assert(Config.IsAllowedCount(count), "Quantidade de Summon invalida")
    local rng = Random.new(seed)
    local pool = {}
    local weightSum = 0
    for _, entry in ipairs(Config.Banner.Pool) do
        if Config.IsInBanner(entry.UnitId) then
            assert(entry.Weight > 0 and entry.Weight % 1 == 0, "Peso invalido")
            weightSum += entry.Weight
            table.insert(pool, entry)
        end
    end
    assert(weightSum > 0, "Nenhuma unidade de banner elegivel")

    local results = {}
    local newMisses = math.max(0, math.floor(misses))
    for _ = 1, count do
        local ticket = rng:NextInteger(1, weightSum)
        local sum = 0
        local chosen = pool[1]
        for _, entry in ipairs(pool) do
            sum += entry.Weight
            if ticket <= sum then
                chosen = entry
                break
            end
        end
        -- Defesa adicional: o pool nao pode introduzir evolucoes.
        assert(Config.IsInBanner(chosen.UnitId), "Unidade proibida no banner")
        local forced = Config.Banner.ShinyPity > 0
            and newMisses >= Config.Banner.ShinyPity - 1
        local shiny = forced or rng:NextNumber() < Config.Banner.ShinyChance
        newMisses = if shiny then 0 else newMisses + 1
        table.insert(results, {
            UnitId = chosen.UnitId,
            Rarity = chosen.Rarity,
            Shiny = shiny,
        })
    end
    return results, newMisses
end

return Config
