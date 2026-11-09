
--!strict
-- ANIME FISSURE
-- WaveService v0.1.0
-- Preparacao, Skip e Auto Skip de Waves
-- Modulo exclusivo do servidor

local WaveService = {}

local DEFAULT_PREPARATION = 10
local SMART_DELAY = 3

export type SkipMode = "Off" | "Fast" | "Smart"

type WaveData = {
    Status: string,
    RemainingEnemies: number,
    PreparationEndsAt: number,
    Players: {Player},
    Votes: {[number]: boolean},
    AutoModes: {[number]: SkipMode},
    OnAdvance: () -> (),
}

local waves: {[string]: WaveData} = {}

local function getRequiredVotes(playerCount: number): number
    if playerCount <= 1 then
        return 1
    end

    return math.floor(playerCount / 2) + 1
end

local function isParticipant(data: WaveData, player: Player): boolean
    return table.find(data.Players, player) ~= nil
end

local function countVotes(data: WaveData): number
    local total = 0

    for _, player in ipairs(data.Players) do
        if data.Votes[player.UserId] then
            total += 1
        end
    end

    return total
end

local function advance(matchId: string, data: WaveData)
    if data.Status ~= "Preparation" then
        return
    end

    if data.RemainingEnemies > 0 then
        return
    end

    data.Status = "Advancing"
    data.OnAdvance()
end

function WaveService.Create(
    matchId: string,
    players: {Player},
    onAdvance: () -> ()
): boolean
    if waves[matchId] then
        return false
    end

    if #players < 1 or #players > 4 then
        return false
    end

    waves[matchId] = {
        Status = "Idle",
        RemainingEnemies = 0,
        PreparationEndsAt = 0,
        Players = table.clone(players),
        Votes = {},
        AutoModes = {},
        OnAdvance = onAdvance,
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

    if mode ~= "Off" and mode ~= "Fast" and mode ~= "Smart" then
        return false
    end

    data.AutoModes[player.UserId] = mode

    return true
end

function WaveService.SetRemainingEnemies(
    matchId: string,
    amount: number
): boolean
    local data = waves[matchId]

    if not data or amount < 0 or amount % 1 ~= 0 then
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

    if not data or data.Status == "Preparation" then
        return false
    end

    if data.RemainingEnemies > 0 then
        return false
    end

    local waitTime = duration or DEFAULT_PREPARATION

    if waitTime < 0 then
        return false
    end

    data.Status = "Preparation"
    data.Votes = {}
    data.PreparationEndsAt = os.clock() + waitTime

    local currentData = data

    task.spawn(function()
        while waves[matchId] == currentData
            and currentData.Status == "Preparation" do

            local now = os.clock()
            local elapsed = now - (currentData.PreparationEndsAt - waitTime)

            for _, player in ipairs(currentData.Players) do
                local mode = currentData.AutoModes[player.UserId] or "Off"

                if mode == "Fast" or
                    (mode == "Smart" and elapsed >= SMART_DELAY) then

                    currentData.Votes[player.UserId] = true
                end
            end

            local votes = countVotes(currentData)
            local required = getRequiredVotes(#currentData.Players)

            if votes >= required or now >= currentData.PreparationEndsAt then
                advance(matchId, currentData)
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

    local votes = countVotes(data)
    local required = getRequiredVotes(#data.Players)

    if votes >= required then
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
        RequiredVotes = getRequiredVotes(#data.Players),
        PreparationEndsAt = data.PreparationEndsAt,
    }
end

function WaveService.Remove(matchId: string)
    waves[matchId] = nil
end

return WaveService
