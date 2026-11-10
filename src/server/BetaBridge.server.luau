
--!strict
-- ANIME FISSURE | BetaBridge v0.1
-- Comunicacao segura entre servidor e HUD

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local MatchService = require(
    script.Parent:WaitForChild("MatchService")
)

local WaveService = require(
    script.Parent:WaitForChild("WaveService")
)

local MATCH_ID = "MainMatch"

local remotes = ReplicatedStorage:FindFirstChild("BetaRemotes")

if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "BetaRemotes"
    remotes.Parent = ReplicatedStorage
end

local function getRemote(name: string): RemoteEvent
    local existing = remotes:FindFirstChild(name)

    if existing and existing:IsA("RemoteEvent") then
        return existing
    end

    if existing then
        existing:Destroy()
    end

    local remote = Instance.new("RemoteEvent")
    remote.Name = name
    remote.Parent = remotes
    return remote
end

local stateRemote = getRemote("MatchState")
local commandRemote = getRemote("MatchCommand")

local lastCommands: {[number]: number} = {}

local function isParticipant(player: Player): boolean
    local match = MatchService.GetMatch(MATCH_ID)

    if not match then
        return false
    end

    return table.find(match.Players, player) ~= nil
end

commandRemote.OnServerEvent:Connect(function(
    player: Player,
    command: any,
    value: any
)
    if not isParticipant(player) then
        return
    end

    local now = os.clock()
    local last = lastCommands[player.UserId] or 0

    if now - last < 0.25 then
        return
    end

    lastCommands[player.UserId] = now

    if command == "Skip" then
        WaveService.VoteSkip(MATCH_ID, player)

    elseif command == "AutoSkip" then
        if value == "Off"
            or value == "Fast"
            or value == "Smart" then

            WaveService.SetAutoMode(
                MATCH_ID,
                player,
                value
            )
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    lastCommands[player.UserId] = nil
end)

task.spawn(function()
    while true do
        local match = MatchService.GetMatch(MATCH_ID)
        local wave = WaveService.GetState(MATCH_ID)

        local payload = {
            Status = "Waiting",
            WaveStatus = "Idle",
            CurrentWave = 0,
            MaxWaves = 15,
            BaseHealth = 3,
            Yen = 700,
            RemainingEnemies = 0,
            Votes = 0,
            RequiredVotes = 0,
            PreparationRemaining = 0,
        }

        if match then
            payload.Status = match.Status
            payload.CurrentWave = match.CurrentWave
            payload.MaxWaves = match.MaxWaves
            payload.BaseHealth = match.BaseHealth
        end

        if wave then
            payload.WaveStatus = wave.Status
            payload.RemainingEnemies = wave.RemainingEnemies
            payload.Votes = wave.Votes
            payload.RequiredVotes = wave.RequiredVotes

            if wave.Status == "Preparation" then
                payload.PreparationRemaining = math.max(
                    0,
                    math.ceil(
                        wave.PreparationEndsAt - os.clock()
                    )
                )
            end
        end

        for _, player in ipairs(Players:GetPlayers()) do
            stateRemote:FireClient(player, payload)
        end

        task.wait(0.5)
    end
end)

print("[Anime Fissure] BetaBridge ONLINE")
