
--!strict
-- ANIME FISSURE
-- Main.server.luau
-- Versao: 1.0.0 | fase e dificuldade definidas pelo lobby
-- Lobby 3D + inicio manual da partida
-- MatchService + WaveService + EnemyService
-- Inimigos reais no caminho + primeiras torres server-side
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

local EnemyService = require(
    script.Parent:WaitForChild("EnemyService")
)

local TowerService = require(
    script.Parent:WaitForChild("TowerService")
)

-- CONFIGURACOES

local MATCH_ID = "MainMatch"
local GAME_MODE = "Classic" -- fallback seguro; escolha valida vem do lobby

local BETWEEN_WAVES_DELAY = 1.5
local PREPARATION_TIME = 10
local INITIAL_PREPARATION_TIME = 24 -- permite posicionar Torres antes da Wave 1

-- CONTROLE INTERNO

local matchStarted = false
local matchFinished = false
local matchStarting = false

local startMainMatch: () -> ()
local startWave: () -> ()

-- O LOBBY CONTROLA O INICIO

Workspace:SetAttribute("ArenaControllerReady", false)
if Workspace:GetAttribute("ArenaRequested") ~= true then
    Workspace:SetAttribute("ArenaRequested", false)
end

local function log(message: string)
    print("[Anime Fissure v0.5] " .. message)
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

local function finishMatch()
    if matchFinished then
        return
    end

    matchFinished = true
    EnemyService.StopWave(MATCH_ID)
    TowerService.EndMatch(MATCH_ID)

    local match = getMatch()

    if match then
        if match.Status == "Playing" then
            -- Encerrada por falta de jogadores ou erro de inicializacao.
            match.Status = "Aborted"
        end
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

-- A beta usa inimigos fisicos, e nao um contador que se auto-derrota.
-- O EnemyService le os waypoints criados pelo BetaMap.

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

    -- Remove quaisquer modelos da wave anterior antes de comecar a nova.
    EnemyService.StopWave(MATCH_ID)

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

    local ready = EnemyService.StartWave(MATCH_ID, currentWave, match.Mode, match.Players, {
        OnCount = function(remaining: number)
            if isPlaying() then
                WaveService.SetRemainingEnemies(MATCH_ID, remaining)
            end
        end,
        OnDefeated = function(player: Player, enemyId: string, position: Vector3)
            TowerService.OnEnemyDefeated(MATCH_ID, player, enemyId, position)
        end,
        OnLeak = function(instantDefeat: boolean, enemyId: string)
            if not isPlaying() then return end
            if TowerService.TryBlockLeak(MATCH_ID, instantDefeat) then
                log("Albedo protegeu a base do vazamento: " .. enemyId)
                return
            end
            MatchService.EnemyLeaked(MATCH_ID, instantDefeat)
            log("Inimigo atravessou a base: " .. enemyId)
            if not isPlaying() then
                finishMatch()
            end
        end,
        OnCleared = function()
            if not isPlaying() then return end
            log("Wave " .. tostring(currentWave) .. ": inimigos derrotados ou vazaram")
            TowerService.OnWaveCleared(MATCH_ID)
            if not WaveService.BeginPreparation(MATCH_ID, PREPARATION_TIME) then
                warn("[Anime Fissure] Preparacao recusada")
            end
        end,
    })
    if not ready then
        warn("[Anime Fissure] Falha ao criar inimigos. Encerrando a partida.")
        finishMatch()
    end
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

    local selectedStage = Workspace:GetAttribute("ArenaStageId")
    local selectedMode = Workspace:GetAttribute("ArenaMode")
    local mode = if selectedStage == "OVL_01"
        and (selectedMode == "Classic" or selectedMode == "Hard")
        then selectedMode
        else GAME_MODE

    local match = MatchService.CreateMatch(
        MATCH_ID,
        mode,
        selectedPlayers
    )

    if not match then
        warn(
            "[Anime Fissure] Falha ao criar partida"
        )
        matchStarting = false
        return
    end

    local firstWavePending = true
    local waveCreated = WaveService.Create(
        MATCH_ID,
        selectedPlayers,
        function()
            if firstWavePending then
                firstWavePending = false
                startWave()
            else
                advanceWave()
            end
        end
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

    local towersReady = TowerService.BeginMatch(MATCH_ID, selectedPlayers)
    if not towersReady then
        warn("[Anime Fissure] Falha ao iniciar TowerService")
        finishMatch()
        return
    end

    log("PARTIDA INICIADA PELO LOBBY")
    log("Modo: " .. tostring(match.Mode))

    log(
        "Jogadores: "
        .. tostring(#selectedPlayers)
    )

    log(
        "Total de waves: "
        .. tostring(match.MaxWaves)
    )

    -- Fase de preparacao inicial: jogador usa o deck e vota iniciar.
    -- O mesmo sistema de Skip/AutoSkip avanca a Wave 1.
    if not WaveService.BeginPreparation(MATCH_ID, INITIAL_PREPARATION_TIME, true) then
        warn("[Anime Fissure] Preparacao inicial falhou; iniciando a Wave 1")
        firstWavePending = false
        startWave()
    end
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
print("Versao: 1.0.0")
print("Modo: " .. GAME_MODE)
print("Lobby obrigatorio: ATIVO")
print("Inicio automatico: DESATIVADO")
print("Inimigos reais: ATIVO | Towers: BETA 1.1")
print("Skip e Auto Skip: WaveService")
print("================================")

Workspace:SetAttribute("ArenaControllerReady", true)
log("Aguardando entrada pelo lobby")
