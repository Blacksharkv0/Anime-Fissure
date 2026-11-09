
--!strict
-- ANIME FISSURE
-- Configuracoes principais do jogo
-- Versao inicial: 0.1.0

local GameConfig = {}

-- JOGADORES
GameConfig.MaxPlayers = 4
GameConfig.DeckSlots = 6

-- PARTIDA
GameConfig.StartingYen = 700
GameConfig.BaseHealth = 3

-- WAVES
GameConfig.Waves = {
    Classic = 15,
    Hard = 20,
}

-- REGRAS DOS INIMIGOS
GameConfig.Enemies = {
    NormalLeakDamage = 1,
    BossLeakInstantDefeat = true,
}

-- VELOCIDADE
GameConfig.Speed = {
    Default = 1,
    Free = {1, 2},
    Gamepass = 3,
}

-- FARM
GameConfig.Farm = {
    AutoReplayDefault = false,
    FarmSuggestionDefault = true,
    ReportHistoryLimit = 10,
    PinnedReportsLimit = 3,
}

-- COOPERATIVO
GameConfig.Coop = {
    EqualRewardsPerPlayer = true,
    SharedYenFromKills = true,
    ScalingByDeckStrength = false,
}

return GameConfig