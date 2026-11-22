--!strict
-- ANIME FISSURE | OVERLORD UNITS | Roster aprovado 22/11/2026
-- Raridades, passiva universal, 3 mudancas de ataque, plano de obtencao.
-- BannerPlanned NAO equivale a elegibilidade ativa no Summon.
-- NAO adiciona unidades ao Summon, TowerConfig, deck, inventario, drops
-- ou lista de personagens jogaveis. Skills/stats/models ainda pendentes.

local Roster = {}

Roster.WorldId = "Overlord"
Roster.Version = "1.0.0"
Roster.Status = "DesignApproved"

Roster.Units = {
    {
        Id = "OVL_Ainz",
        Name = "Ainz",
        FullName = "Ainz Ooal Gown",
        Rarity = "Secret",
        WorldId = "Overlord",
        Status = "Planned",
        ObtainMethod = "SpecialStageUndecided",
        BannerCandidate = false,
        PassivePlanned = true,
        AttackChangesPlanned = 3,
    },
    {
        Id = "OVL_Albedo",
        Name = "Albedo",
        FullName = "Albedo",
        Rarity = "Mythic",
        WorldId = "Overlord",
        Status = "Planned",
        ObtainMethod = "BannerPlanned",
        BannerCandidate = true,
        PassivePlanned = true,
        AttackChangesPlanned = 3,
    },
    {
        Id = "OVL_Shalltear",
        Name = "Shalltear",
        FullName = "Shalltear Bloodfallen",
        Rarity = "Legendary",
        WorldId = "Overlord",
        Status = "Planned",
        ObtainMethod = "BannerPlanned",
        BannerCandidate = true,
        PassivePlanned = true,
        AttackChangesPlanned = 3,
    },
    {
        Id = "OVL_Gazef",
        Name = "Gazef",
        FullName = "Gazef Stronoff",
        Rarity = "Epic",
        WorldId = "Overlord",
        Status = "Planned",
        ObtainMethod = "BannerPlanned",
        BannerCandidate = true,
        PassivePlanned = true,
        AttackChangesPlanned = 3,
    },
    {
        Id = "OVL_Brain",
        Name = "Brain",
        FullName = "Brain Unglaus",
        Rarity = "Rare",
        WorldId = "Overlord",
        Status = "Planned",
        ObtainMethod = "BannerPlanned",
        BannerCandidate = true,
        PassivePlanned = true,
        AttackChangesPlanned = 3,
    },
    {
        Id = "OVL_Climb",
        Name = "Climb",
        FullName = "Climb",
        Rarity = "Common",
        WorldId = "Overlord",
        Status = "Planned",
        ObtainMethod = "BannerPlanned",
        BannerCandidate = true,
        PassivePlanned = true,
        AttackChangesPlanned = 3,
    },
}

local byId: {[string]: any} = {}
local byRarity: {[string]: any} = {}
for _, unit in ipairs(Roster.Units) do
    assert(byId[unit.Id] == nil, "Overlord unit Id duplicado: " .. unit.Id)
    assert(byRarity[unit.Rarity] == nil,
        "Esta versao do roster reserva uma unidade por raridade: " .. unit.Rarity)
    byId[unit.Id] = unit
    byRarity[unit.Rarity] = unit
end

local function copyUnit(unit: any)
    return if unit then table.clone(unit) else nil
end

function Roster.Get(id: string)
    return copyUnit(byId[id])
end

function Roster.GetByRarity(rarity: string)
    return copyUnit(byRarity[rarity])
end

function Roster.GetAll(): {any}
    local result = {}
    for _, unit in ipairs(Roster.Units) do
        table.insert(result, copyUnit(unit))
    end
    return result
end

function Roster.IsPlayable(id: string): boolean
    -- Apenas a existencia no catalogo NAO libera um personagem.
    return byId[id] ~= nil and byId[id].Status == "Playable"
end

return Roster
