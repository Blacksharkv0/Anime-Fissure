--!strict
-- ANIME FISSURE | SummonService v0.1
-- O cliente NUNCA decide unidade, raridade, Shiny ou saldo.
-- Studio: 25 Tickets temporarios para teste.
-- Publicado: 0 Tickets ate haver uma fonte legitima de moeda.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("SummonConfig"))
local Access = require(script.Parent:WaitForChild("CapsuleAccessService"))
local Profiles = require(script.Parent:WaitForChild("SummonProfileStore"))

local remotes = ReplicatedStorage:FindFirstChild("SummonRemotes")
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "SummonRemotes"
    remotes.Parent = ReplicatedStorage
end

local function remote(name: string, className: string)
    local existing = remotes:FindFirstChild(name)
    if existing and existing.ClassName == className then return existing end
    if existing then existing:Destroy() end
    local new = Instance.new(className)
    new.Name = name
    new.Parent = remotes
    return new
end

remote("Open", "RemoteEvent")
local stateRemote = remote("GetState", "RemoteFunction") :: RemoteFunction
local purchaseRemote = remote("Purchase", "RemoteFunction") :: RemoteFunction

local VIRGIL_POSITION = Vector3.new(228, 0, -6)
local MAX_DISTANCE = 23
local busy: {[number]: boolean} = {}
local lastRequest: {[number]: number} = {}

local function eligible(player: Player): boolean
    if player.Parent ~= Players or player:GetAttribute("InArena") == true then
        return false
    end
    local character = player.Character
    local root = if character then character:FindFirstChild("HumanoidRootPart") else nil
    if not root or not root:IsA("BasePart") then return false end
    return (root.Position - VIRGIL_POSITION).Magnitude <= MAX_DISTANCE
end

stateRemote.OnServerInvoke = function(player: Player)
    if not eligible(player) then
        return {Ready = false, Error = "Aproxime-se de Virgil no lobby"}
    end
    local state = Profiles.Snapshot(player)
    state.Banner = Config.GetPublicInfo()
    return state
end

purchaseRemote.OnServerInvoke = function(
    player: Player,
    bannerId: any,
    count: any,
    transactionId: any
)
    if not eligible(player) then
        return {Ok = false, Error = "Voce precisa estar perto de Virgil no lobby"}
    end
    if bannerId ~= Config.Banner.Id or not Config.IsAllowedCount(count) then
        return {Ok = false, Error = "Banner ou quantidade invalida"}
    end
    if typeof(transactionId) ~= "string" or #transactionId < 8
        or #transactionId > 64 or transactionId:find("[^%w%-]") then
        return {Ok = false, Error = "Identificador da tentativa invalido"}
    end
    if not Access.CanGrantCapsule("Capsule", "Summon")
        or Access.CanGrantCapsule("CapsuleCorp", "Summon") then
        return {Ok = false, Error = "Politica de unidades invalida"}
    end

    local id = player.UserId
    if busy[id] then return {Ok = false, Error = "Summon anterior ainda em andamento"} end
    if os.clock() - (lastRequest[id] or -100) < 0.8 then
        return {Ok = false, Error = "Aguarde antes de invocar novamente"}
    end
    busy[id] = true
    lastRequest[id] = os.clock()

    local cost = Config.GetCost(count :: number)
    local result: any
    -- O callback do DataStore precisa ser puro, com semente interna.
    -- A semente nao vem do cliente e nao pode ser manipulada pelo HUD.
    local seed = Random.new():NextInteger(1, 2147483646)
    local ok, value = pcall(function()
        return Profiles.Purchase(player, transactionId, cost :: number, function(misses)
            local results, newMisses = Config.Roll(count :: number, misses, seed)
            for _, item in ipairs(results) do
                local allowed = if item.UnitId == "Capsule" or item.UnitId == "CapsuleCorp"
                    then Access.CanGrantCapsule(item.UnitId, "Summon")
                    else Config.IsInBanner(item.UnitId)
                assert(allowed, "Unidade nao permitida")
            end
            return results, newMisses
        end)
    end)
    busy[id] = nil
    if not ok then
        warn("[Summon] Falha inesperada:", value)
        return {Ok = false, Error = "Summon indisponivel; tente novamente"}
    end
    result = value
    if result.Ok then
        result.State = Profiles.Snapshot(player)
    end
    return result
end

Players.PlayerRemoving:Connect(function(player)
    busy[player.UserId] = nil
    lastRequest[player.UserId] = nil
    Profiles.Forget(player)
end)

-- Exposto para o stand; o proprio Prompt dispara Open:FireClient.
print("[Anime Fissure] SummonService ONLINE |", Config.Banner.Name,
    "| moeda de teste apenas em Studio")
