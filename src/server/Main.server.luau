
--!strict
-- ANIME FISSURE
-- Inicializacao e integracao dos sistemas
-- Versao: 0.2.0

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared:WaitForChild("GameConfig"))

local MatchService = require(script.Parent:WaitForChild("MatchService"))
local WaveService = require(script.Parent:WaitForChild("WaveService"))

local MATCH_ID = "MainMatch"

local matchStarted = false
local waveReady = false

print("================================")
print("ANIME FISSURE - SERVIDOR ONLINE")
print("Versao: 0.2.0")
print("Sistema de Waves: Carregado")
print("Sistema de Skip: Carregado")
print("================================")

local function prepareNextWave()
    local match = MatchService.GetMatch(MATCH_ID)

    if not match or match.Status ~= "Playing" then
        return
    end

    if waveReady then
        return
    end

    waveReady = true

    WaveService.SetRemainingEnemies(MATCH_ID, 0)

    local started = WaveService.BeginPreparation(MATCH_ID, 10)

    if started then
        print("[Anime Fissure] Preparacao iniciada")
    else
        waveReady = false
    end
end

local function advanceWave()
    local match = MatchService.GetMatch(MATCH_ID)

    if not match or match.Status ~= "Playing" then
        return
    end

    waveReady = false

    local completed = MatchService.CompleteWave(MATCH_ID)

    if not completed then
        return
    end

    if match.Status == "Victory" then
        print("[Anime Fissure] Partida finalizada!")
        WaveService.Remove(MATCH_ID)
        return
    end

    print("[Anime Fissure] Wave atual:", match.CurrentWave)

    -- Integracao temporaria.
    -- Futuramente o sistema de inimigos
    -- chamara prepareNextWave ao terminar a Wave.
    task.delay(2, prepareNextWave)
end

local function startMainMatch()
    if matchStarted then
        return
    end

    local participants = Players:GetPlayers()

    if #participants == 0 then
        return
    end

    local match = MatchService.CreateMatch(
        MATCH_ID,
        "Classic",
        participants
    )

    if not match then
        return
    end

    local created = WaveService.Create(
        MATCH_ID,
        participants,
        advanceWave
    )

    if not created then
        MatchService.RemoveMatch(MATCH_ID)
        return
    end

    if not MatchService.StartMatch(MATCH_ID) then
        WaveService.Remove(MATCH_ID)
        MatchService.RemoveMatch(MATCH_ID)
        return
    end

    matchStarted = true

    print("[Anime Fissure] Partida iniciada!")
    print("[Anime Fissure] Wave:", match.CurrentWave)

    -- Primeira Wave simulada.
    task.delay(2, prepareNextWave)
end

Players.PlayerAdded:Connect(function()
    task.delay(3, startMainMatch)
end)

task.delay(3, startMainMatch)
