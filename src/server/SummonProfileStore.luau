--!strict
-- ANIME FISSURE | SummonProfileStore v0.1
-- Sorteios + gasto de Tickets numa UNICA transacao UpdateAsync.
-- O uso de DataStore fica restrito ao servidor. Em Studio, perfil temporario.
-- Nao integra ainda com moedas/recompensas de outros sistemas.

local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SummonConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("SummonConfig"))

local Store = {}
Store.StudioMode = RunService:IsStudio()
Store.DataStoreName = "AnimeFissure_Summon_v1"
Store.StudioTickets = 25 -- SOMENTE STUDIO. NUNCA e dado no jogo publicado.

local dataStore = if Store.StudioMode then nil
    else DataStoreService:GetDataStore(Store.DataStoreName)

local loaded: {[number]: any} = {}
local loading: {[number]: boolean} = {}

local function normalize(raw: any)
    local source = if typeof(raw) == "table" then raw else {}
    local tickets = if typeof(source.Tickets) == "number" then source.Tickets
        else (if Store.StudioMode then Store.StudioTickets else 0)
    local misses = if typeof(source.ShinyMisses) == "number" then source.ShinyMisses else 0
    local units = if typeof(source.Units) == "table" then source.Units else {}
    local receipts = if typeof(source.Receipts) == "table" then source.Receipts else {}
    return {
        Schema = 1,
        Tickets = math.clamp(math.floor(tickets), 0, 100000000),
        ShinyMisses = math.clamp(math.floor(misses), 0, 100000000),
        Units = table.clone(units),
        Receipts = table.clone(receipts),
        TicketAwards = if typeof(source.TicketAwards) == "table" then table.clone(source.TicketAwards) else {},
    }
end

local function key(player: Player): string
    return "u_" .. tostring(player.UserId)
end

local function receipt(profile: any, txId: string)
    for _, item in ipairs(profile.Receipts) do
        if typeof(item) == "table" and item.Id == txId then
            return item
        end
    end
    return nil
end

function Store.Load(player: Player): (any?, string?)
    local id = player.UserId
    if loaded[id] then return loaded[id], nil end
    if loading[id] then
        local start = os.clock()
        repeat
            task.wait(0.1)
            if loaded[id] then return loaded[id], nil end
        until not loading[id] or os.clock() - start > 15
        if loaded[id] then return loaded[id], nil end
        return nil, "Nao foi possivel carregar o perfil"
    end
    loading[id] = true
    local result: any = nil
    if Store.StudioMode then
        result = normalize(nil)
    else
        local ok, data = pcall(function()
            return (dataStore :: any):GetAsync(key(player))
        end)
        if ok then
            result = normalize(data)
        else
            warn("[Summon] Falha ao carregar perfil:", data)
        end
    end
    loading[id] = nil
    if result then loaded[id] = result end
    if not result then return nil, "Dados indisponiveis; Summon bloqueado por seguranca" end
    return result, nil
end

function Store.Snapshot(player: Player)
    local profile, err = Store.Load(player)
    if not profile then return {Ready = false, Error = err} end
    local normals, shinies = 0, 0
    local entries = {}
    for _, unit in ipairs(profile.Units) do
        if typeof(unit) == "table" and unit.UnitId == "Capsule" then
            if unit.Shiny == true then shinies += 1 else normals += 1 end
        end
        if typeof(unit) == "table" and typeof(unit.Uid) == "string" then
            table.insert(entries, {
                Uid = unit.Uid,
                UnitId = unit.UnitId,
                Shiny = unit.Shiny == true,
                Rarity = unit.Rarity,
            })
        end
    end
    return {
        Ready = true,
        StudioMode = Store.StudioMode,
        Tickets = profile.Tickets,
        ShinyMisses = profile.ShinyMisses,
        CapsuleNormal = normals,
        CapsuleShiny = shinies,
        Collection = entries,
    }
end

-- Resolver(profile.ShinyMisses) -> resultados, misses finais.
-- O resolver deve ser deterministico e SEM yield.
function Store.Purchase(
    player: Player,
    txId: string,
    cost: number,
    resolver: (number) -> ({any}, number)
)
    local profile, loadErr = Store.Load(player)
    if not profile then return {Ok = false, Error = loadErr} end

    local savedResult: any = nil
    local denyReason: string? = nil
    local function transact(old: any)
        local nextProfile = normalize(old)
        local previous = receipt(nextProfile, txId)
        if previous then
            savedResult = previous.Items
            return nextProfile -- pedido repetido: nao cobrar de novo
        end
        if nextProfile.Tickets < cost then
            denyReason = "Tickets insuficientes"
            return nil -- cancela a escrita
        end
        local outcomes, misses = resolver(nextProfile.ShinyMisses)
        assert(#outcomes > 0, "Sorteio vazio")
        local granted = {}
        for i, result in ipairs(outcomes) do
            assert(SummonConfig.IsInBanner(result.UnitId), "Unidade proibida no banner")
            local item = {
                Uid = tostring(player.UserId) .. ":" .. txId .. ":" .. tostring(i),
                UnitId = result.UnitId,
                Rarity = result.Rarity,
                Shiny = result.Shiny == true,
            }
            table.insert(nextProfile.Units, item)
            table.insert(granted, item)
        end
        nextProfile.Tickets -= cost
        nextProfile.ShinyMisses = misses
        table.insert(nextProfile.Receipts, {Id = txId, Items = granted})
        while #nextProfile.Receipts > 35 do
            table.remove(nextProfile.Receipts, 1)
        end
        savedResult = granted
        return nextProfile
    end

    if Store.StudioMode then
        local updated = transact(profile)
        if not updated then return {Ok = false, Error = denyReason or "Falha no teste"} end
        loaded[player.UserId] = updated
    else
        local ok, updated = pcall(function()
            return (dataStore :: any):UpdateAsync(key(player), transact)
        end)
        if not ok or updated == nil then
            -- UpdateAsync pode ter sido gravado mesmo em caso de erro de rede.
            -- Nunca conceder itens fora da transacao nem cobrar novamente aqui.
            if not ok then warn("[Summon] Resultado de escrita incerto:", updated) end
            return {Ok = false, Error = denyReason or "Transacao nao confirmada; reabra o Summon"}
        end
        loaded[player.UserId] = normalize(updated)
    end
    return {Ok = true, Items = savedResult or {}}
end

-- Fonte segura de Tickets para futuros modos, missoes e Gold Shop.
-- NUNCA exponha isto em um RemoteEvent que aceite quantidade do cliente.
-- awardId precisa ser unico por recompensa (evita credito duplicado).
function Store.GrantTickets(player: Player, amount: number, awardId: string): boolean
    if typeof(amount) ~= "number" or amount % 1 ~= 0
        or amount <= 0 or amount > 10000
        or typeof(awardId) ~= "string" or #awardId < 8 or #awardId > 100 then
        return false
    end
    local profile = Store.Load(player)
    if not profile then return false end
    local function transact(old: any)
        local nextProfile = normalize(old)
        if table.find(nextProfile.TicketAwards, awardId) then
            return nextProfile
        end
        nextProfile.Tickets = math.min(100000000, nextProfile.Tickets + amount)
        table.insert(nextProfile.TicketAwards, awardId)
        while #nextProfile.TicketAwards > 80 do
            table.remove(nextProfile.TicketAwards, 1)
        end
        return nextProfile
    end
    if Store.StudioMode then
        loaded[player.UserId] = transact(profile)
        return true
    end
    local ok, updated = pcall(function()
        return (dataStore :: any):UpdateAsync(key(player), transact)
    end)
    if not ok or updated == nil then return false end
    loaded[player.UserId] = normalize(updated)
    return true
end

function Store.Forget(player: Player)
    loaded[player.UserId] = nil
    loading[player.UserId] = nil
end

return Store
