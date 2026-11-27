--!strict
-- ANIME FISSURE | RelicIndexConfig v0.2 - LEGACY ARCHIVE
-- Old unapproved design concepts, formerly displayed in Edward alchemy.
-- Archived entries now appear only in Gilgamesh global CONCEPTS drawer.
-- NOT the approved Overlord stage drops; no item, recipe or reward exists.

local RelicIndexConfig = {}

RelicIndexConfig.Relics = {
    {
        Id = "OVL_SolarSeal",
        Name = "Selo da Luz Solar",
        World = "Overlord",
        StageId = "OVL_01",
        Buff = "+20% de dano fisico; ignora 15% da armadura inimiga.",
        Target = "Unidades de dano fisico",
        Availability = "Archived",
    },
    {
        Id = "OVL_NecromancerBook",
        Name = "Livro do Necromante",
        World = "Overlord",
        StageId = "OVL_02",
        Buff = "+25% de dano DOT; derrotas por DOT criam uma area de corrupcao.",
        Target = "Unidades com dano continuo (DOT)",
        Availability = "Archived",
    },
    {
        Id = "OVL_HunterEye",
        Name = "Olho do Predador",
        World = "Overlord",
        StageId = "OVL_03",
        Buff = "+12 pontos percentuais de critico; +20% de dano critico contra chefes.",
        Target = "Unidades com ataques criticos",
        Availability = "Archived",
    },
    {
        Id = "OVL_BloodChalice",
        Name = "Calice Carmesim",
        World = "Overlord",
        StageId = "OVL_04",
        Buff = "+25% de dano magico; a cada 10 ataques, um golpe adicional.",
        Target = "Unidades de dano magico",
        Availability = "Archived",
    },
    {
        Id = "OVL_FrostHeart",
        Name = "Coracao da Geada",
        World = "Overlord",
        StageId = "OVL_05",
        Buff = "+15% de velocidade de ataque; chance de aplicar lentidao.",
        Target = "Unidades de ataque",
        Availability = "Archived",
    },
    {
        Id = "OVL_SupremeCrown",
        Name = "Coroa do Supremo",
        World = "Overlord",
        StageId = "OVL_06",
        Buff = "+20% de dano; ativa um impulso de velocidade uma vez por wave.",
        Target = "Unidades compativeis (a definir)",
        Availability = "Archived",
    },
    {
        Id = "DB_MoneyCapsule",
        Name = "Money Capsule",
        World = "Dragon Ball",
        StageId = "DB_TBD",
        Buff = "-30% no custo de colocacao; +50% de Yen por wave.",
        Target = "Capsule e Capsule (Corp) exclusivamente",
        Availability = "Archived",
    },
}

local byId: {[string]: any} = {}
for _, relic in ipairs(RelicIndexConfig.Relics) do
    assert(byId[relic.Id] == nil, "ID de reliquia duplicado: " .. relic.Id)
    byId[relic.Id] = relic
end

function RelicIndexConfig.GetAll()
    return table.clone(RelicIndexConfig.Relics)
end

function RelicIndexConfig.Get(id: string)
    return byId[id]
end

function RelicIndexConfig.IsAvailable(id: string): boolean
    local relic = byId[id]
    return relic ~= nil and relic.Availability == "Live"
end

return RelicIndexConfig
