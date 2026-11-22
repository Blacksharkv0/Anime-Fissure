--!strict
-- ANIME FISSURE | EnemyConfig v0.5
-- Configuracao dos inimigos comuns da primeira arena (OVL_01).
-- Chefes e mecanicas especiais permanecem em BossConfig.

local EnemyConfig = {}

EnemyConfig.StageId = "OVL_01"
EnemyConfig.SpawnInterval = 0.7
EnemyConfig.BaseEnemies = 3
EnemyConfig.EnemiesPerWave = 1
EnemyConfig.MaxNormalEnemies = 25

EnemyConfig.Types = {
    Invader = {
        Id = "Invader",
        Name = "Invasor de Carne Village",
        Health = 95,
        Speed = 10,
        Color = Color3.fromRGB(173, 67, 86),
        Accent = Color3.fromRGB(255, 169, 91),
        Size = 1,
        LeakDamage = 1,
        Air = false,
        Class = "Normal",
    },
    Scout = {
        Id = "Scout",
        Name = "Batedor Veloz",
        Health = 75,
        Speed = 15,
        Color = Color3.fromRGB(209, 151, 62),
        Accent = Color3.fromRGB(255, 216, 116),
        Size = 0.82,
        LeakDamage = 1,
        Air = false,
        Class = "Swift",
    },
    Armored = {
        Id = "Armored",
        Name = "Soldado Blindado",
        Health = 220,
        Speed = 6.5,
        Color = Color3.fromRGB(92, 107, 136),
        Accent = Color3.fromRGB(129, 183, 255),
        Size = 1.28,
        LeakDamage = 1,
        Air = false,
        Class = "Armored",
    },
    WarAngel = {
        Id = "WarAngel",
        Name = "Anjo da Guerra",
        Health = 165,
        Speed = 11,
        Color = Color3.fromRGB(224, 213, 178),
        Accent = Color3.fromRGB(255, 236, 149),
        Size = 1.03,
        LeakDamage = 1,
        Air = true,
        Class = "Summon",
    },
}

function EnemyConfig.Get(id: string)
    return EnemyConfig.Types[id]
end

function EnemyConfig.GetStats(id: string, wave: number, difficulty: string, playerCount: number)
    local kind = EnemyConfig.Types[id]
    if not kind or (difficulty ~= "Classic" and difficulty ~= "Hard") then return nil end
    if typeof(wave) ~= "number" or wave < 1 or wave % 1 ~= 0 then return nil end
    if typeof(playerCount) ~= "number" or playerCount < 1 or playerCount > 4 or playerCount % 1 ~= 0 then return nil end

    local healthScale = 1 + math.max(0, wave - 1) * 0.10
    local difficultyScale = if difficulty == "Hard" then 1.4 else 1
    local coopScale = 1 + (playerCount - 1) * 0.35
    return {
        Id = kind.Id,
        Name = kind.Name,
        Health = math.floor(kind.Health * healthScale * difficultyScale * coopScale + 0.5),
        Speed = kind.Speed,
        Color = kind.Color,
        Accent = kind.Accent,
        Size = kind.Size,
        LeakDamage = kind.LeakDamage,
        Air = kind.Air,
        Class = kind.Class,
        Boss = false,
    }
end

function EnemyConfig.GetWavePlan(wave: number): {string}
    assert(typeof(wave) == "number" and wave >= 1 and wave % 1 == 0, "Wave invalida")
    local total = math.min(EnemyConfig.MaxNormalEnemies, EnemyConfig.BaseEnemies + wave * EnemyConfig.EnemiesPerWave)
    local plan: {string} = {}

    for i = 1, total do
        local id = "Invader"
        if wave >= 6 and i % 5 == 0 then
            id = "Armored"
        elseif wave >= 3 and i % 3 == 0 then
            id = "Scout"
        end
        table.insert(plan, id)
    end

    return plan
end

return EnemyConfig
