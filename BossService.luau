--!strict
-- ANIME FISSURE | BossService v0.1.0
-- Controlador de chefes em memoria, exclusivo do servidor.
-- Nao cria modelos, nao altera o Main e nao usa DataStore.
-- Integracao futura: EnemyService/CombatService chamarao as funcoes.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BossConfig = require(
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("BossConfig")
)

local BossService = {}
local active: {[string]: any} = {}

local function validNumber(n: any): boolean
    return typeof(n) == "number"
        and n == n
        and n ~= math.huge
        and n ~= -math.huge
end

local function sendEvent(state: any, name: string, info: any)
    local callback = state.Hooks.OnEvent
    if typeof(callback) ~= "function" then
        return
    end

    local ok, err = pcall(callback, state.Id, name, info)
    if not ok then
        warn("[BossService] OnEvent:", err)
    end
end

-- O callback OnSummon deve criar inimigos REAIS no servidor
-- e devolver quantos foram realmente criados.
local function summon(state: any, enemyId: string, amount: number): number
    local callback = state.Hooks.OnSummon
    if typeof(callback) ~= "function" or amount <= 0 then
        return 0
    end

    local ok, result = pcall(callback, state.Id, enemyId, amount)
    if not ok then
        warn("[BossService] OnSummon:", result)
        return 0
    end

    if not validNumber(result) then
        warn("[BossService] OnSummon deve retornar a quantidade criada")
        return 0
    end

    return math.clamp(math.floor(result), 0, amount)
end

local function physicalResistance(state: any): number
    local resistance = state.Stats.PhysicalResistance or 0
    local shield = state.Config.Abilities.ShieldWall

    if shield and state.ShieldRemaining > 0 and not state.LastStand then
        resistance += shield.ExtraPhysicalResistance
        resistance = math.min(resistance, shield.MaxPhysicalResistance)
    end

    return math.clamp(resistance, 0, 0.95)
end

-- Use IDs unicos por encontro: por exemplo, "MainMatch:Nigun".
-- hooks.OnEvent(id, eventName, info): avisos/efeitos externos.
-- hooks.OnSummon(id, enemyId, quantidade): retorna criados.
function BossService.Create(
    encounterId: string,
    bossId: string,
    difficulty: string,
    playerCount: number,
    hooks: any?
): boolean
    if typeof(encounterId) ~= "string"
        or encounterId == ""
        or active[encounterId] ~= nil then
        return false
    end

    local stats = BossConfig.GetStats(bossId, difficulty, playerCount)
    local config = BossConfig.GetBoss(bossId)
    if not stats or not config then
        return false
    end

    local angel = config.Abilities.AngelSummon
    local seal = config.Abilities.LightSeal
    local shield = config.Abilities.ShieldWall

    active[encounterId] = {
        Id = encounterId,
        BossId = bossId,
        Config = config,
        Stats = stats,
        Hooks = hooks or {},
        Health = stats.MaxHealth,
        Phase = 1,
        Alive = true,
        LastStand = false,
        Elapsed = 0,
        ShieldRemaining = 0,
        ShieldCooldown = shield and shield.Cooldown or 0,
        AngelCooldown = angel and angel.Cooldown[difficulty] or 0,
        SealCooldown = seal and seal.Cooldown or 0,
        SealWarningRemaining = 0,
        SealWarningActive = false,
        FinalCastRemaining = 0,
        FinalCastActive = false,
        ProtectionRemaining = 0,
        AliveAngels = 0,
        AliveDominions = 0,
    }

    sendEvent(active[encounterId], "BossCreated", {
        BossId = bossId,
        Health = stats.MaxHealth,
    })
    return true
end

-- Retorna apenas uma copia simples do estado, propria para HUD.
function BossService.GetState(encounterId: string)
    local state = active[encounterId]
    if not state then
        return nil
    end

    local speed = state.Stats.Speed
    if state.LastStand then
        local lastStand = state.Config.Abilities.LastStand
        if lastStand then
            speed *= (1 + lastStand.SpeedBonus)
        end
    end

    return {
        Id = state.Id,
        BossId = state.BossId,
        Health = state.Health,
        MaxHealth = state.Stats.MaxHealth,
        Alive = state.Alive,
        Phase = state.Phase,
        Air = state.Stats.Air,
        Speed = speed,
        PhysicalResistance = physicalResistance(state),
        ShieldActive = state.ShieldRemaining > 0,
        ProtectionActive = state.ProtectionRemaining > 0,
        MovementPaused = state.FinalCastActive,
        AliveAngels = state.AliveAngels,
        AliveDominions = state.AliveDominions,
        SealWarningActive = state.SealWarningActive,
    }
end

-- damageType: "Physical", "Magic" ou "True".
-- True ignora armadura e protecao.
-- Retorna o dano realmente causado (ou nil, caso invalido).
function BossService.ApplyDamage(
    encounterId: string,
    amount: number,
    damageType: string
): number?
    local state = active[encounterId]
    if not state or not state.Alive then
        return nil
    end
    if not validNumber(amount) or amount < 0 then
        return nil
    end
    if damageType ~= "Physical"
        and damageType ~= "Magic"
        and damageType ~= "True" then
        return nil
    end
    if amount == 0 then
        return 0
    end

    local multiplier = 1
    if damageType == "Physical" then
        multiplier *= 1 - physicalResistance(state)
    end
    if damageType ~= "True" and state.ProtectionRemaining > 0 then
        local final = state.Config.Abilities.FinalSummon
        multiplier *= 1 - final.Protection
    end

    local requested = math.max(1, math.floor(amount * multiplier + 0.5))
    local dealt = math.min(requested, state.Health)
    state.Health -= dealt

    if state.Health <= 0 then
        state.Health = 0
        state.Alive = false
        state.FinalCastActive = false
        state.ProtectionRemaining = 0
        sendEvent(state, "BossDefeated", {BossId = state.BossId})
        return dealt
    end

    if state.BossId == "CaptainInvader" and not state.LastStand then
        local lastStand = state.Config.Abilities.LastStand
        if lastStand and state.Health / state.Stats.MaxHealth <= lastStand.HealthThreshold then
            state.LastStand = true
            if lastStand.RemovesShieldBonus then
                state.ShieldRemaining = 0
            end
            sendEvent(state, "LastStand", {SpeedBonus = lastStand.SpeedBonus})
        end
    end

    if state.BossId == "Nigun" and state.Phase == 1 then
        local final = state.Config.Abilities.FinalSummon
        if final and state.Health / state.Stats.MaxHealth <= final.HealthThreshold then
            state.Phase = 2
            state.FinalCastActive = true
            state.FinalCastRemaining = final.CastDuration
            state.SealWarningActive = false
            sendEvent(state, "PhaseChanged", {
                Phase = 2,
                CastDuration = final.CastDuration,
            })
        end
    end

    return dealt
end

-- Deve ser chamado APENAS no servidor, a cada ~0.1-0.2 segundos.
-- deltaTime vem do controlador de combate, nunca do cliente.
function BossService.Update(encounterId: string, deltaTime: number): boolean
    local state = active[encounterId]
    if not state or not state.Alive
        or not validNumber(deltaTime)
        or deltaTime <= 0 or deltaTime > 5 then
        return false
    end

    state.Elapsed += deltaTime
    local abilities = state.Config.Abilities

    -- Protecao tem duracao maxima e pode acabar antes
    -- se a invocacao superior for derrotada.
    if state.ProtectionRemaining > 0 then
        state.ProtectionRemaining = math.max(0, state.ProtectionRemaining - deltaTime)
        if state.ProtectionRemaining == 0 then
            sendEvent(state, "ProtectionEnded", {})
        end
    end

    -- Escudo temporario do Capitao.
    if state.ShieldRemaining > 0 then
        state.ShieldRemaining = math.max(0, state.ShieldRemaining - deltaTime)
        if state.ShieldRemaining == 0 then
            sendEvent(state, "ShieldEnded", {})
        end
    end

    local shield = abilities.ShieldWall
    if shield and not state.LastStand then
        state.ShieldCooldown -= deltaTime
        if state.ShieldCooldown <= 0 then
            state.ShieldCooldown = shield.Cooldown
            state.ShieldRemaining = shield.Duration
            sendEvent(state, "ShieldStarted", {Duration = shield.Duration})
        end
    end

    -- Transicao de Nigun: pausa o movimento enquanto invoca.
    if state.FinalCastActive then
        state.FinalCastRemaining -= deltaTime
        if state.FinalCastRemaining <= 0 then
            state.FinalCastActive = false
            state.FinalCastRemaining = 0
            local final = abilities.FinalSummon
            local made = summon(state, final.EnemyId, final.MaximumSummons)
            state.AliveDominions += made
            if made > 0 then
                state.ProtectionRemaining = final.MaxProtectionDuration
            end
            sendEvent(state, "FinalSummonCompleted", {
                Spawned = made,
                ProtectionDuration = state.ProtectionRemaining,
            })
        end
        return true
    end

    -- Contagem do aviso de Selo de Luz.
    if state.SealWarningActive then
        state.SealWarningRemaining -= deltaTime
        if state.SealWarningRemaining <= 0 then
            state.SealWarningRemaining = 0
            state.SealWarningActive = false
            local seal = abilities.LightSeal
            sendEvent(state, "LightSealExecute", {
                Radius = seal.Radius,
                DisableDuration = seal.DisableDuration,
            })
        end
    end

    local seal = abilities.LightSeal
    if seal then
        state.SealCooldown -= deltaTime
        if state.SealCooldown <= 0 then
            state.SealCooldown = seal.Cooldown
            state.SealWarningActive = true
            state.SealWarningRemaining = seal.WarningDuration
            sendEvent(state, "LightSealWarning", {
                Radius = seal.Radius,
                WarningDuration = seal.WarningDuration,
            })
        end
    end

    -- Invocacao periodica dos anjos comuns.
    local angel = abilities.AngelSummon
    if angel then
        state.AngelCooldown -= deltaTime
        if state.AngelCooldown <= 0 then
            state.AngelCooldown = angel.Cooldown[state.Stats.Difficulty]
            local vacancies = math.max(0, angel.MaxAlive - state.AliveAngels)
            local wanted = math.min(angel.Count, vacancies)
            local made = summon(state, angel.EnemyId, wanted)
            state.AliveAngels += made
            if made > 0 then
                sendEvent(state, "AngelsSummoned", {Count = made})
            end
        end
    end

    return true
end

-- O EnemyService avisara quando uma invocacao morrer ou cruzar a base.
-- Sem isso, o limite de invocacoes ficaria permanentemente ocupado.
function BossService.NotifySummonRemoved(
    encounterId: string,
    enemyId: string,
    amount: number?
): boolean
    local state = active[encounterId]
    local count = amount or 1
    if not state or not validNumber(count)
        or count < 1 or count % 1 ~= 0 then
        return false
    end

    if enemyId == "WarAngel" then
        state.AliveAngels = math.max(0, state.AliveAngels - count)
    elseif enemyId == "DominionAuthority" then
        state.AliveDominions = math.max(0, state.AliveDominions - count)
        if state.AliveDominions == 0 and state.ProtectionRemaining > 0 then
            state.ProtectionRemaining = 0
            sendEvent(state, "ProtectionEnded", {})
        end
    else
        return false
    end

    return true
end

function BossService.Remove(encounterId: string): boolean
    if not active[encounterId] then
        return false
    end
    active[encounterId] = nil
    return true
end

return BossService
