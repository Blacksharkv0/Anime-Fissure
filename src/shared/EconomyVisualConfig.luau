--!strict
-- ANIME FISSURE | EconomyVisualConfig v0.1
-- Visual IDs only. Does NOT create wallets, drop rates, purchases, prices,
-- grant items, or replace the current SummonTickets banner.
-- Names and symbols are original gameplay-asset proposals.

local Config = {}
Config.Version = "0.1.0"
Config.Status = "StudioVisualPrototype"

Config.Items = {
    {
        Id = "FissureGems",
        Name = "Gemas da Fissura",
        ShortName = "Gems",
        Category = "PremiumCurrency",
        Usage = "Moeda prevista para o Summon e futura loja de Gems",
        VisualIdentity = "Duas metades cristalinas flutuantes unidas por fissura luminosa",
        Accent = Color3.fromRGB(68, 209, 255),
        Secondary = Color3.fromRGB(164, 98, 255),
        Shadow = Color3.fromRGB(32, 23, 74),
        Status = "VisualOnly",
    },
    {
        Id = "Gold",
        Name = "Gold",
        ShortName = "Gold",
        Category = "SoftCurrency",
        Usage = "Moeda tradicional de progressao fora das partidas",
        VisualIdentity = "Moeda dourada com duplo rasgo angular e aro de metal",
        Accent = Color3.fromRGB(255, 218, 119),
        Secondary = Color3.fromRGB(213, 140, 51),
        Shadow = Color3.fromRGB(112, 71, 28),
        Status = "VisualOnly",
    },
    {
        Id = "TraitRerollCore",
        Name = "Nucleo de Reescrita",
        ShortName = "Trait Reroll",
        Category = "TraitReroll",
        Usage = "Recurso futuro de reroll de Trait de unidades",
        VisualIdentity = "Nucleo turquesa tripartido entre anel hexagonal mecanico",
        Accent = Color3.fromRGB(81, 247, 219),
        Secondary = Color3.fromRGB(61, 124, 240),
        Shadow = Color3.fromRGB(22, 57, 76),
        Status = "VisualOnly",
    },
    {
        Id = "RelicTraitSeal",
        Name = "Selo de Ressonancia",
        ShortName = "Relic Trait",
        Category = "RelicTraitReroll",
        Usage = "Recurso futuro de reroll de Trait de reliquia, separado do reroll comum",
        VisualIdentity = "Mandala octogonal violeta, runas originais e nucleo suspenso",
        Accent = Color3.fromRGB(255, 159, 113),
        Secondary = Color3.fromRGB(194, 112, 252),
        Shadow = Color3.fromRGB(55, 33, 78),
        Status = "VisualOnly",
    },
}

local byId: {[string]: any} = {}
for _, item in ipairs(Config.Items) do
    assert(not byId[item.Id], "EconomyVisualConfig ID duplicado: " .. item.Id)
    byId[item.Id] = item
end

function Config.Get(id: string)
    local item = byId[id]
    return if item then table.clone(item) else nil
end

function Config.GetAll(): {any}
    local result = {}
    for _, item in ipairs(Config.Items) do
        table.insert(result, table.clone(item))
    end
    return result
end

function Config.IsLive(_id: string): boolean
    -- Explicit: no real wallet, shop, trade or consumable uses this yet.
    return false
end

return Config
