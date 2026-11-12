
--!strict
-- ANIME FISSURE | StoryConfig v0.1
-- Catalogo dos mundos e fases da historia
-- Dados apenas: nao inicia partidas

local StoryConfig = {}

StoryConfig.Worlds = {
    Overlord = {
        Id = "Overlord",
        Name = "OVERLORD",
        Subtitle = "Ascensao do Rei Morto",
        Order = 1,

        Stages = {
            {
                Id = "OVL_01",
                Name = "O Massacre de Carne Village",
                MapId = "CarneVillage",
                Waves = 15,
                HardWaves = 20,
                Boss = "Nigun Grid Luin",
                BossMechanic = "AngelSummon",
            },
            {
                Id = "OVL_02",
                Name = "O Cemiterio de E-Rantel",
                MapId = "ERantelCemetery",
                Waves = 15,
                HardWaves = 20,
                Boss = "Clementine",
                BossMechanic = "DualBoss",
            },
            {
                Id = "OVL_03",
                Name = "O Rei da Floresta",
                MapId = "ForestOfTob",
                Waves = 15,
                HardWaves = 20,
                Boss = "Hamsuke",
                BossMechanic = "Charge",
            },
            {
                Id = "OVL_04",
                Name = "A Valquiria Sangrenta",
                MapId = "BloodyValkyrie",
                Waves = 15,
                HardWaves = 20,
                Boss = "Shalltear",
                BossMechanic = "Regeneration",
            },
            {
                Id = "OVL_05",
                Name = "A Guerra dos Homens-Lagarto",
                MapId = "LizardmenSwamp",
                Waves = 15,
                HardWaves = 20,
                Boss = "Cocytus",
                BossMechanic = "Freeze",
            },
            {
                Id = "OVL_06",
                Name = "O Trono de Nazarick",
                MapId = "NazarickThrone",
                Waves = 15,
                HardWaves = 20,
                Boss = "Ainz Ooal Gown",
                BossMechanic = "FinalPhase",
            },
        },
    },
}

function StoryConfig.GetWorld(worldId: string)
    return StoryConfig.Worlds[worldId]
end

function StoryConfig.GetStage(
    worldId: string,
    stageNumber: number
)
    local world = StoryConfig.GetWorld(worldId)

    if not world then
        return nil
    end

    return world.Stages[stageNumber]
end

function StoryConfig.IsStageUnlocked(
    completedStages: {[string]: boolean},
    worldId: string,
    stageNumber: number
): boolean
    local world = StoryConfig.GetWorld(worldId)

    if not world then
        return false
    end

    if stageNumber < 1
        or stageNumber > #world.Stages
        or stageNumber % 1 ~= 0 then
        return false
    end

    if stageNumber == 1 then
        return true
    end

    local previousStage =
        world.Stages[stageNumber - 1]

    return completedStages[previousStage.Id] == true
end

return StoryConfig
