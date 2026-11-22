--!strict
-- ANIME FISSURE | LobbyStageConfig v1.0
-- Catalogo visivel no lobby e validacao server-side da primeira arena.
-- Somente OVL_01 possui mapa e EnemyService prontos para Play.
-- Nao usa dados de inventario nem desbloqueia recompensas.

local StoryConfig = require(script.Parent:WaitForChild("StoryConfig"))
local Rewards = require(script.Parent:WaitForChild("StoryRewardConfig"))

local Config = {}
Config.Version = "1.0"
Config.WorldId = "Overlord"
Config.Playable = {OVL_01 = true}
Config.Modes = {Classic = true, Hard = true}

function Config.CanEnter(stageId: any, difficulty: any): (boolean, string)
    if typeof(stageId) ~= "string" or typeof(difficulty) ~= "string" then
        return false, "Selecao de fase invalida."
    end
    if not Config.Playable[stageId] then
        return false, "Essa fase ainda nao possui mapa jogavel."
    end
    if not Config.Modes[difficulty] then
        return false, "Dificuldade invalida."
    end
    return true, "OK"
end

function Config.GetCatalog()
    local world = StoryConfig.GetWorld(Config.WorldId)
    local list = {}
    if not world then return list end

    for i, stage in ipairs(world.Stages) do
        local playable = Config.Playable[stage.Id] == true
        table.insert(list, {
            Id = stage.Id,
            Order = i,
            Name = stage.Name,
            Boss = stage.Boss,
            MapId = stage.MapId,
            Playable = playable,
            Status = if playable then "BETA JOGAVEL" else "EM DESENVOLVIMENTO",
        })
    end
    return list
end

function Config.GetRewardPreview(stageId: string, difficulty: string)
    local valid = Config.CanEnter(stageId, difficulty)
    if not valid then return nil end
    local reward = Rewards.GetVictory(difficulty, false)
    if not reward then return nil end
    return {
        Gold = reward.BaseGold,
        Fragments = reward.Fragments,
        Item = "Insignia Solar",
        Chance = reward.RareDropChance,
        HardPity = reward.HardPity,
        Granted = false, -- o serviço de entrega ainda não foi implementado
    }
end

return Config
