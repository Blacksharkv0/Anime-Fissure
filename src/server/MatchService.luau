
--!strict
-- ANIME FISSURE
-- MatchService - Gerenciamento de partidas
-- Versao: 0.1.0

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig")
)

local MatchService = {}

export type MatchState = {
    Mode: string,
    Status: string,
    CurrentWave: number,
    MaxWaves: number,
    BaseHealth: number,
    Players: {Player},
}

local activeMatches: {[string]: MatchState} = {}

local VALID_MODES = {
    Classic = true,
    Hard = true,
}

-- Cria uma nova partida.
function MatchService.CreateMatch(
    matchId: string,
    mode: string,
    players: {Player}
): MatchState?

    if activeMatches[matchId] then
        warn("Partida ja existe:", matchId)
        return nil
    end

    if not VALID_MODES[mode] then
        warn("Modo invalido:", mode)
        return nil
    end

    if #players < 1 or #players > GameConfig.MaxPlayers then
        warn("Quantidade de jogadores invalida")
        return nil
    end

    local match: MatchState = {
        Mode = mode,
        Status = "Waiting",
        CurrentWave = 0,
        MaxWaves = GameConfig.Waves[mode],
        BaseHealth = GameConfig.BaseHealth,
        Players = table.clone(players),
    }

    activeMatches[matchId] = match

    print("[Anime Fissure] Partida criada:", matchId)

    return match
end

-- Consulta uma partida.
function MatchService.GetMatch(matchId: string): MatchState?
    return activeMatches[matchId]
end

-- Inicia a partida e a primeira Wave.
function MatchService.StartMatch(matchId: string): boolean
    local match = activeMatches[matchId]

    if not match or match.Status ~= "Waiting" then
        return false
    end

    match.Status = "Playing"
    match.CurrentWave = 1

    print("[Anime Fissure] Wave 1 iniciada")

    return true
end

-- Avanca apos a Wave ser concluida.
function MatchService.CompleteWave(matchId: string): boolean
    local match = activeMatches[matchId]

    if not match or match.Status ~= "Playing" then
        return false
    end

    if match.CurrentWave >= match.MaxWaves then
        match.Status = "Victory"
        print("[Anime Fissure] Vitoria:", matchId)
    else
        match.CurrentWave += 1

        print(
            "[Anime Fissure] Nova Wave:",
            match.CurrentWave
        )
    end

    return true
end

-- Aplica dano quando um inimigo atravessa a base.
function MatchService.EnemyLeaked(
    matchId: string,
    isBoss: boolean
): boolean

    local match = activeMatches[matchId]

    if not match or match.Status ~= "Playing" then
        return false
    end

    if isBoss and GameConfig.Enemies.BossLeakInstantDefeat then
        match.BaseHealth = 0
    else
        match.BaseHealth = math.max(
            0,
            match.BaseHealth - GameConfig.Enemies.NormalLeakDamage
        )
    end

    if match.BaseHealth <= 0 then
        match.Status = "Defeat"
        print("[Anime Fissure] Derrota:", matchId)
    end

    return true
end

-- Encerra e remove uma partida da memoria.
function MatchService.RemoveMatch(matchId: string): boolean
    if not activeMatches[matchId] then
        return false
    end

    activeMatches[matchId] = nil
    return true
end

return MatchService