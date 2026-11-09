
--!strict
-- ANIME FISSURE
-- WaveService v0.2.1
-- Sistema de Waves, Skip e Auto Skip
-- Autoridade exclusiva do servidor

local Players = game:GetService("Players")

local WaveService = {}

local DEFAULT_PREPARATION = 10
local SMART_DELAY = 3
local MAX_PLAYERS = 4

export type SkipMode = "Off" | "Fast" | "Smart"
export type WaveStatus =
    "Idle" | "Combat" | "Preparation" | "Advancing"

type WaveData = {
    Status: WaveStatus,
    RemainingEnemies: number,
    PreparationEndsAt: number,
    PreparationStartedAt: number,
    Players: {Player},
    Votes: {[number]: boolean},
    AutoModes: {[number]: SkipMode},
    OnAdvance: () -> (),
    Generation: number,
}

local waves: {[string]: WaveData} = {}

local function isParticipant(
    data: WaveData,
    player: Player
): boolean
    return table.find(data.Players, player) ~= nil
        and player.Parent == Players
end

local function countPlayers(data: WaveData): number
    local total = 0

    for _, player in ipairs(data.Players) do
        if player.Parent == Players then
            total += 1
        end
    end

    return total
end

local function requiredVotes(total: number): number
    if total <= 0 then
        return 0
    end

    return math.floor(total / 2) + 1
end

local function countVotes(data: WaveData): number
    local total = 0

    for _, player in ipairs(data.Players) do
        if player.Parent == Players
            and data.Votes[player.UserId] then
            total += 1
        end
    end

    return total
end

local function canAdvance(data: WaveData): boolean
    return data.Status == "Preparation"
        and data.RemainingEnemies == 0
        and countPlayers(data) > 0
end

local function advance(
    matchId: string,
    data: WaveData
): boolean
    if waves[matchId] ~= data then
        return false
    end

    if not canAdvance(data) then
        return false
    end

    -- Trava o estado antes do callback.
    data.Status = "Advancing"
    data.Generation += 1

    local success, err = pcall(data.OnAdvance)

    if not success then
        warn("[Anime Fissure] Erro no avanço:", err)
        -- Não repetir automaticamente o callback:
        -- o resultado anterior pode ser incerto.
        return false
    end

    return true
end

function WaveService.Create(
    matchId: string,
    players: {Player},
    onAdvance: () -> ()
): boolean
    if waves[matchId] then
        return false
    end

    if #players < 1 or #players > MAX_PLAYERS then
        return false
    end

    local seen: {[number]: boolean} = {}

    for _, player in ipairs(players) do
        if player.Parent ~= Players
            or seen[player.UserId] then
            return false
        end

        seen[player.UserId] = true
    end

    waves[matchId] = {
        Status = "Idle",
        RemainingEnemies = 0,
        PreparationEndsAt = 0,
        PreparationStartedAt = 0,
        Players = table.clone(players),
        Votes = {},
        AutoModes = {},
        OnAdvance = onAdvance,
        Generation = 0,
    }

    return true
end

function WaveService.SetAutoMode(
    matchId: string,
    player: Player,
    mode: SkipMode
): boolean
    local data = waves[matchId]

    if not data or not isParticipant(data, player) then
        return false
    end

    if mode ~= "Off"
        and mode ~= "Fast"
        and mode ~= "Smart" then
        return false
    end

    data.AutoModes[player.UserId] = mode
    return true
end

-- Inicia o combate da Wave atual.
-- Apenas o controlador do servidor deve chamar.
function WaveService.BeginCombat(matchId: string): boolean
    local data = waves[matchId]

    if not data then
        return false
    end

    if data.Status ~= "Idle"
        and data.Status ~= "Advancing" then
        return false
    end

    data.Status = "Combat"
    data.RemainingEnemies = 0
    data.Votes = {}
    data.Generation += 1

    return true
end

-- Atualizado exclusivamente pelo sistema de inimigos.
function WaveService.SetRemainingEnemies(
    matchId: string,
    amount: number
): boolean
    local data = waves[matchId]

    if not data or data.Status ~= "Combat" then
        return false
    end

    if amount < 0 or amount % 1 ~= 0
        or amount ~= amount
        or amount == math.huge then
        return false
    end

    data.RemainingEnemies = amount
    return true
end

function WaveService.BeginPreparation(
    matchId: string,
    duration: number?
): boolean
    local data = waves[matchId]

    if not data or data.Status ~= "Combat" then
        return false
    end

    if data.RemainingEnemies ~= 0 then
        return false
    end

    local waitTime = duration or DEFAULT_PREPARATION

    if waitTime < 0 or waitTime > 120
        or waitTime ~= waitTime then
        return false
    end

    data.Status = "Preparation"
    data.Votes = {}
    data.Generation += 1

    local generation = data.Generation

    data.PreparationStartedAt = os.clock()
    data.PreparationEndsAt =
        data.PreparationStartedAt + waitTime

    task.spawn(function()
        while waves[matchId] == data
            and data.Status == "Preparation"
            and data.Generation == generation do

            local now = os.clock()
            local elapsed = now - data.PreparationStartedAt

            for _, player in ipairs(data.Players) do
                if player.Parent == Players then
                    local mode =
                        data.AutoModes[player.UserId] or "Off"

                    if mode == "Fast"
                        or (mode == "Smart"
                            and elapsed >= SMART_DELAY) then
                        data.Votes[player.UserId] = true
                    end
                end
            end

            local activeCount = countPlayers(data)
            local votes = countVotes(data)
            local needed = requiredVotes(activeCount)

            if activeCount > 0
                and (votes >= needed
                    or now >= data.PreparationEndsAt) then
                advance(matchId, data)
                break
            end

            task.wait(0.2)
        end
    end)

    return true
end

function WaveService.VoteSkip(
    matchId: string,
    player: Player
): boolean
    local data = waves[matchId]

    if not data or data.Status ~= "Preparation" then
        return false
    end

    if not isParticipant(data, player) then
        return false
    end

    data.Votes[player.UserId] = true

    local activeCount = countPlayers(data)

    if activeCount > 0
        and countVotes(data) >= requiredVotes(activeCount) then
        advance(matchId, data)
    end

    return true
end

function WaveService.GetState(matchId: string)
    local data = waves[matchId]

    if not data then
        return nil
    end

    return {
        Status = data.Status,
        RemainingEnemies = data.RemainingEnemies,
        Votes = countVotes(data),
        RequiredVotes = requiredVotes(countPlayers(data)),
        PreparationEndsAt = data.PreparationEndsAt,
        Generation = data.Generation,
    }
end

function WaveService.Remove(matchId: string)
    local data = waves[matchId]

    if data then
        data.Generation += 1
        waves[matchId] = nil
    end
end

return WaveService
