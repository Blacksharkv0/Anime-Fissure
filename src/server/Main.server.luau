
--!strict
-- ANIME FISSURE
-- Main.server.luau
-- Versao: 0.4.0
-- Lobby 3D + inicio manual da partida
-- MatchService + WaveService
-- Combate temporariamente simulado
-- Autoridade exclusiva do servidor

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")

local GameConfig = require(
    Shared:WaitForChild("GameConfig")
)

local MatchService = require(
    script.Parent:WaitForChild("MatchService")
)

local WaveService = require(
    script.Parent:WaitForChild("WaveService")
)

-- CONFIGURACOES

local MATCH_ID = "MainMatch"
local GAME_MODE = "Classic"

local BETWEEN_WAVES_DELAY = 1.5
local PREPARATION_TIME = 10

local ENEMY_SPAWN_INTERVAL = 0.35
local ENEMY_DEFEAT_INTERVAL = 0.55

local BASE_ENEMIES = 3
local ENEMIES_PER_WAVE = 1
local MAX_SIMULATED_ENEMIES = 25

-- CONTROLE INTERNO

local matchStarted = false
local matchFinished = false
local matchStarting = false

local simulationGeneration = 0

local startMainMatch: () -> ()
local startWave: () -> ()

-- O LOBBY CONTROLA O INICIO

Workspace:SetAttribute("ArenaRequested", false)

local function log(message: string)
    print("[Anime Fissure v0.4] " .. message)
end

local function getMatch()
    return MatchService.GetMatch(MATCH_ID)
end

local function isPlaying(): boolean
    local match = getMatch()

    return match ~= nil
        and match.Status == "Playing"
        and not matchFinished
end

local function countParticipants(): number
    local match = getMatch()

    if not match then
        return 0
    end

    local count = 0

    for _, player in ipairs(match.Players) do
        if player.Parent == Players then
            count += 1
        end
    end

    return count
end

local function stopSimulation()
    simulationGeneration += 1
end

local function finishMatch()
    if matchFinished then
        return
    end

    matchFinished = true
    stopSimulation()

    local match = getMatch()

    if match then
        log("Partida encerrada: " .. match.Status)

        log(
            "Wave final: "
            .. tostring(match.CurrentWave)
            .. "/"
            .. tostring(match.MaxWaves)
        )
    end

    WaveService.Remove(MATCH_ID)

    -- O resultado permanece no MatchService.
    -- Retorno ao lobby sera implementado depois.
end

local function getEnemyCount(wave: number): number
    return math.min(
        MAX_SIMULATED_ENEMIES,
        BASE_ENEMIES + wave * ENEMIES_PER_WAVE
    )
end

-- COMBATE SIMULADO

local function simulateCombat(wave: number)
    stopSimulation()

    local generation = simulationGeneration
    local enemyCount = getEnemyCount(wave)

    log(
        "Combate simulado | Wave "
        .. tostring(wave)
        .. " | Inimigos: "
        .. tostring(enemyCount)
    )

    local registered = WaveService.SetRemainingEnemies(
        MATCH_ID,
        enemyCount
    )

    if not registered then
        warn(
            "[Anime Fissure] Falha ao registrar inimigos"
        )
        return
    end

    task.spawn(function()
        -- Aguarda o surgimento simulado dos inimigos.

        for _ = 1, enemyCount do
            if generation ~= simulationGeneration
                or not isPlaying() then
                return
            end

            task.wait(ENEMY_SPAWN_INTERVAL)
        end

        local remaining = enemyCount

        while remaining > 0 do
            if generation ~= simulationGeneration
                or not isPlaying() then
                return
            end

            task.wait(ENEMY_DEFEAT_INTERVAL)

            if generation ~= simulationGeneration
                or not isPlaying() then
                return
            end

            remaining -= 1

            local updated =
                WaveService.SetRemainingEnemies(
                    MATCH_ID,
                    remaining
                )

            if not updated then
                warn(
                    "[Anime Fissure] Contador rejeitado"
                )
                return
            end
        end

        if generation ~= simulationGeneration
            or not isPlaying() then
            return
        end

        log(
            "Wave "
            .. tostring(wave)
            .. ": simulacao concluida"
        )

        local prepared =
            WaveService.BeginPreparation(
                MATCH_ID,
                PREPARATION_TIME
            )

        if prepared then
            log(
                "Preparacao: "
                .. tostring(PREPARATION_TIME)
                .. " segundos"
            )
        else
            warn(
                "[Anime Fissure] Falha na preparacao"
            )
        end
    end)
end

-- INICIAR WAVE

startWave = function()
    if not isPlaying() then
        return
    end

    if countParticipants() == 0 then
        log("Nenhum participante ativo")
        finishMatch()
        return
    end

    local match = getMatch()

    if not match then
        return
    end

    local started =
        WaveService.BeginCombat(MATCH_ID)

    if not started then
        warn(
            "[Anime Fissure] BeginCombat recusado"
        )
        return
    end

    local currentWave = match.CurrentWave

    log(
        "COMBATE | Wave "
        .. tostring(currentWave)
        .. "/"
        .. tostring(match.MaxWaves)
    )

    simulateCombat(currentWave)
end

-- AVANCAR WAVE

local function advanceWave()
    if not isPlaying() then
        return
    end

    local completed =
        MatchService.CompleteWave(MATCH_ID)

    if not completed then
        warn(
            "[Anime Fissure] CompleteWave falhou"
        )
        return
    end

    local match = getMatch()

    if not match then
        return
    end

    if match.Status == "Victory" then
        log("VITORIA! Todas as waves concluidas")
        finishMatch()
        return
    end

    if match.Status ~= "Playing" then
        finishMatch()
        return
    end

    log(
        "Proxima wave: "
        .. tostring(match.CurrentWave)
    )

    task.delay(BETWEEN_WAVES_DELAY, function()
        if isPlaying() then
            startWave()
        end
    end)
end

-- CRIAR PARTIDA SOMENTE APOS ENTRAR NA ARENA

startMainMatch = function()
    if matchStarted
        or matchFinished
        or matchStarting then
        return
    end

    -- A partida nunca inicia automaticamente
    -- quando um jogador entra no servidor.

    if Workspace:GetAttribute("ArenaRequested") ~= true then
        log("Aguardando jogador entrar pelo lobby")
        return
    end

    matchStarting = true

    -- Somente jogadores autorizados pelo lobby.

    local participants: {Player} = {}

    for _, player in ipairs(Players:GetPlayers()) do
        if player:GetAttribute("InArena") == true then
            table.insert(participants, player)
        end
    end

    if #participants == 0 then
        log("Nenhum jogador autorizado na arena")
        matchStarting = false
        return
    end

    -- Limite configurado para a beta.

    local selectedPlayers: {Player} = {}

    for _, player in ipairs(participants) do
        if #selectedPlayers >= GameConfig.MaxPlayers then
            break
        end

        table.insert(selectedPlayers, player)
    end

    local match = MatchService.CreateMatch(
        MATCH_ID,
        GAME_MODE,
        selectedPlayers
    )

    if not match then
        warn(
            "[Anime Fissure] Falha ao criar partida"
        )
        matchStarting = false
        return
    end

    local waveCreated = WaveService.Create(
        MATCH_ID,
        selectedPlayers,
        advanceWave
    )

    if not waveCreated then
        MatchService.RemoveMatch(MATCH_ID)

        warn(
            "[Anime Fissure] Falha ao criar WaveService"
        )

        matchStarting = false
        return
    end

    local started =
        MatchService.StartMatch(MATCH_ID)

    if not started then
        WaveService.Remove(MATCH_ID)
        MatchService.RemoveMatch(MATCH_ID)

        warn(
            "[Anime Fissure] Falha ao iniciar partida"
        )

        matchStarting = false
        return
    end

    matchStarted = true
    matchStarting = false

    log("PARTIDA INICIADA PELO LOBBY")
    log("Modo: " .. GAME_MODE)

    log(
        "Jogadores: "
        .. tostring(#selectedPlayers)
    )

    log(
        "Total de waves: "
        .. tostring(match.MaxWaves)
    )

    startWave()
end

-- RECEBER AUTORIZACAO DO LOBBY

Workspace:GetAttributeChangedSignal(
    "ArenaRequested"
):Connect(function()
    if Workspace:GetAttribute("ArenaRequested") == true
        and not matchStarted
        and not matchFinished then

        log("Solicitacao de entrada recebida")
        startMainMatch()
    end
end)

-- MONITORAMENTO DE JOGADORES

Players.PlayerAdded:Connect(function(player)
    log("Jogador conectado: " .. player.Name)

    -- Nao iniciar partida aqui.
    -- Jogador deve permanecer no lobby.
end)

Players.PlayerRemoving:Connect(function(player)
    log("Jogador saiu: " .. player.Name)

    if not matchStarted or matchFinished then
        return
    end

    task.defer(function()
        task.wait(0.1)

        if matchFinished then
            return
        end

        if countParticipants() == 0 then
            log("Partida sem jogadores ativos")
            finishMatch()
        end
    end)
end)

-- INICIALIZACAO

print("================================")
print("ANIME FISSURE - SERVIDOR ONLINE")
print("Versao: 0.4.0")
print("Modo: " .. GAME_MODE)
print("Lobby obrigatorio: ATIVO")
print("Inicio automatico: DESATIVADO")
print("Combate simulado: ATIVO")
print("Skip e Auto Skip: WaveService")
print("================================")

log("Aguardando entrada pelo lobby")
