
--!strict
-- ANIME FISSURE
-- StoryRewardConfig v0.1.0
-- Economia de Carne Village
-- Recompensas, drops e Hard Pity
-- Nao entrega recompensas automaticamente

local RewardConfig = {}

RewardConfig.Version = "0.1.0"
RewardConfig.StageId = "OVL_01"

RewardConfig.StartingYen = 700

-- YEN RECEBIDO POR INIMIGO DERROTADO
-- Cada participante elegivel recebe o valor.

RewardConfig.EnemyYen = {
    InvaderSoldier = 15,
    OrderScout = 18,
    ShieldGuardian = 40,
    SolarCaster = 30,
    WarAngel = 50,

    CaptainInvader = 150,
    DominionAuthority = 200,
    Nigun = 300,
}

-- RECOMPENSAS AO VENCER A FASE

RewardConfig.Victory = {
    Classic = {
        Gold = 150,
        Fragments = 3,
        FirstClearBonus = 100,
        RareDropChance = 0.08,
        MaxWaves = 15,
    },

    Hard = {
        Gold = 240,
        Fragments = 5,
        FirstClearBonus = 150,
        RareDropChance = 0.12,
        MaxWaves = 20,
    },
}

RewardConfig.FragmentItemId = "SolarSealFragment"
RewardConfig.RareItemId = "SolarInsignia"

-- O MESMO ITEM COMPARTILHA PITY
-- ENTRE CLASSIC E HARD.

RewardConfig.HardPity = 15

-- DERROTAS PODEM DAR ATE 20%
-- DO GOLD NORMAL, SEM DROPS RAROS.

RewardConfig.DefeatGoldCap = 0.20

function RewardConfig.GetEnemyYen(
    enemyId: string
): number
    return RewardConfig.EnemyYen[enemyId] or 0
end

function RewardConfig.GetVictory(
    difficulty: string,
    firstClear: boolean
)
    local mode = RewardConfig.Victory[difficulty]

    if not mode then
        return nil
    end

    local bonus = 0

    if firstClear == true then
        bonus = mode.FirstClearBonus
    end

    return {
        StageId = RewardConfig.StageId,
        Difficulty = difficulty,

        Gold = mode.Gold + bonus,
        BaseGold = mode.Gold,
        FirstClearGold = bonus,

        FragmentItemId =
            RewardConfig.FragmentItemId,

        Fragments = mode.Fragments,

        RareItemId = RewardConfig.RareItemId,
        RareDropChance = mode.RareDropChance,

        HardPity = RewardConfig.HardPity,
    }
end

-- RECOMPENSA PARCIAL DE DERROTA

function RewardConfig.GetDefeatGold(
    difficulty: string,
    wavesCleared: number
): number
    local mode = RewardConfig.Victory[difficulty]

    if not mode then
        return 0
    end

    if typeof(wavesCleared) ~= "number"
        or wavesCleared ~= wavesCleared then
        return 0
    end

    local progress = math.clamp(
        math.floor(wavesCleared) / mode.MaxWaves,
        0,
        1
    )

    return math.floor(
        mode.Gold
        * RewardConfig.DefeatGoldCap
        * progress
    )
end

-- SORTEIO DO ITEM RARO
--
-- misses: vitorias consecutivas sem o item
-- roll: numero entre 0 e 1 (opcional)
--
-- Retorna:
-- conseguiuItem, novoContadorDeFalhas
--
-- O RewardService devera chamar esta funcao
-- APENAS no servidor, apos validar a vitoria.

function RewardConfig.RollRareDrop(
    difficulty: string,
    misses: number,
    roll: number?
): (boolean, number)

    local mode = RewardConfig.Victory[difficulty]

    if not mode then
        return false, misses
    end

    assert(
        typeof(misses) == "number"
            and misses >= 0
            and misses % 1 == 0,
        "Contador de pity invalido"
    )

    -- Garantia na 15a vitoria elegivel.

    if misses >= RewardConfig.HardPity - 1 then
        return true, 0
    end

    local result = roll

    if result == nil then
        result = math.random()
    end

    assert(
        typeof(result) == "number"
            and result >= 0
            and result < 1,
        "Valor de sorteio invalido"
    )

    if result < mode.RareDropChance then
        return true, 0
    end

    return false, misses + 1
end

function RewardConfig.GetPityRemaining(
    misses: number
): number
    if typeof(misses) ~= "number"
        or misses ~= misses then
        return RewardConfig.HardPity
    end

    return math.max(
        1,
        RewardConfig.HardPity
            - math.max(0, math.floor(misses))
    )
end

return RewardConfig
