
--!strict
-- ANIME FISSURE
-- BossConfig v0.1.0
-- Mundo 01: Overlord / Carne Village
-- Configuracao de chefes e habilidades
-- Nao executa combate automaticamente

local BossConfig = {}

BossConfig.Version = "0.1.0"
BossConfig.StageId = "OVL_01"

-- Cada jogador adicional acrescenta 60%
-- da vida base ao chefe.
BossConfig.CoopHealthBonus = 0.60
BossConfig.MaxPlayers = 4

BossConfig.Bosses = {

    -- MINIBOSS: WAVE 10

    CaptainInvader = {
        Id = "CaptainInvader",
        Name = "Capitao Invasor",
        Category = "MiniBoss",

        Health = {
            Classic = 900,
            Hard = 1350,
        },

        Speed = 7,
        Air = false,
        PhysicalResistance = 0.20,
        LeakDamage = 1,

        Abilities = {
            ShieldWall = {
                Enabled = true,
                Cooldown = 25,
                Duration = 8,
                ExtraPhysicalResistance = 0.25,
                MaxPhysicalResistance = 0.65,
            },

            CommandMarch = {
                Enabled = true,
                Radius = 22,
                AllySpeedBonus = 0.15,
            },

            LastStand = {
                Enabled = true,
                HealthThreshold = 0.30,
                SpeedBonus = 0.15,
                RemovesShieldBonus = true,
            },
        },
    },

    -- CHEFE FINAL: WAVE 15 / 20

    Nigun = {
        Id = "Nigun",
        Name = "Nigun Grid Luin",
        Category = "MainBoss",

        Health = {
            Classic = 2000,
            Hard = 3000,
        },

        Speed = 5,
        Air = false,
        PhysicalResistance = 0.05,

        -- Chefe principal que chega na base:
        -- derrota imediata.
        InstantDefeatOnLeak = true,

        PhaseTwoThreshold = 0.40,

        Abilities = {
            AngelSummon = {
                Enabled = true,
                EnemyId = "WarAngel",
                Count = 2,
                MaxAlive = 4,

                Cooldown = {
                    Classic = 18,
                    Hard = 14,
                },
            },

            LightSeal = {
                Enabled = true,
                Cooldown = 28,
                WarningDuration = 3,
                DisableDuration = 2,
                Radius = 16,
            },

            FinalSummon = {
                Enabled = true,
                HealthThreshold = 0.40,

                EnemyId = "DominionAuthority",

                CastDuration = 3,

                Protection = 0.35,
                MaxProtectionDuration = 20,

                MaximumSummons = 1,
            },
        },
    },

    -- INVOCACAO ESPECIAL DE NIGUN

    DominionAuthority = {
        Id = "DominionAuthority",
        Name = "Dominion Authority",
        Category = "EliteSummon",

        Health = {
            Classic = 650,
            Hard = 975,
        },

        Speed = 8,
        Air = true,
        PhysicalResistance = 0.10,
        LeakDamage = 1,

        Abilities = {},
    },
}

-- EM QUAL WAVE CADA CHEFE APARECE

BossConfig.StageBosses = {
    OVL_01 = {
        Classic = {
            [10] = "CaptainInvader",
            [15] = "Nigun",
        },

        Hard = {
            [10] = "CaptainInvader",
            [20] = "Nigun",
        },
    },
}

-- CONSULTAR DEFINICAO

function BossConfig.GetBoss(bossId: string)
    return BossConfig.Bosses[bossId]
end

-- IDENTIFICAR CHEFE DE UMA WAVE

function BossConfig.GetBossForWave(
    stageId: string,
    difficulty: string,
    wave: number
)
    local stage = BossConfig.StageBosses[stageId]

    if not stage then
        return nil
    end

    local mode = stage[difficulty]

    if not mode then
        return nil
    end

    local bossId = mode[wave]

    if not bossId then
        return nil
    end

    return BossConfig.GetBoss(bossId)
end

-- CALCULAR ATRIBUTOS PARA A PARTIDA

function BossConfig.GetStats(
    bossId: string,
    difficulty: string,
    playerCount: number
)
    local boss = BossConfig.GetBoss(bossId)

    if not boss then
        return nil
    end

    if difficulty ~= "Classic"
        and difficulty ~= "Hard" then
        return nil
    end

    if typeof(playerCount) ~= "number"
        or playerCount % 1 ~= 0
        or playerCount < 1
        or playerCount > BossConfig.MaxPlayers then
        return nil
    end

    local baseHealth = boss.Health[difficulty]

    if not baseHealth then
        return nil
    end

    local multiplier =
        1 + BossConfig.CoopHealthBonus
        * (playerCount - 1)

    local finalHealth = math.floor(
        baseHealth * multiplier + 0.5
    )

    return {
        Id = boss.Id,
        Name = boss.Name,
        Category = boss.Category,

        MaxHealth = finalHealth,
        Health = finalHealth,

        Speed = boss.Speed,
        Air = boss.Air,

        PhysicalResistance =
            boss.PhysicalResistance,

        LeakDamage = boss.LeakDamage,

        InstantDefeatOnLeak =
            boss.InstantDefeatOnLeak == true,

        Phase = 1,
        PhaseTwoThreshold =
            boss.PhaseTwoThreshold,

        Abilities = boss.Abilities,

        Difficulty = difficulty,
        PlayerCount = playerCount,
    }
end

-- CONSULTAR COOLDOWN DE INVOCACAO

function BossConfig.GetAngelCooldown(
    difficulty: string
): number?
    local nigun = BossConfig.GetBoss("Nigun")
    local summon = nigun.Abilities.AngelSummon

    return summon.Cooldown[difficulty]
end

return BossConfig
