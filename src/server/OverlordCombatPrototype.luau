--!strict
-- ANIME FISSURE | Overlord Combat Prototype v0.1
-- Primeiros ataques + UMA passiva funcional para cada uma das seis raridades.
-- STUDIO ONLY: este modulo recusa combate fora de Studio.
-- Efeito real no HP aplica via EnemyService.DamageEnemy, nunca via cliente.
-- As skills ativas/ultimates da pesquisa ainda nao estao implementadas.

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("TowerConfig"))

local Combat = {}
local RNG = Random.new()

function Combat.IsPrototype(id: any): boolean
    return RunService:IsStudio() and Config.IsOverlord(id)
end

local function capped(value: number): number
    return math.clamp(math.floor(value + 0.5), 1, 95000)
end

local function inRange(t: any, target: any, radius: number): boolean
    return (t.Position - target.Position).Magnitude <= radius
end

-- Uma passiva em cada personagem:
-- Climb: ataque rapido quando inimigo chega perto do fim.
-- Brain: criticos melhores e mais frequentes.
-- Gazef: bonus contra o arquetipo Armored.
-- Shalltear: Blood Pool acumulado por kills dentro do range.
-- Albedo: Hermes protege vazamentos normais (servico central do TowerService).
-- Ainz: Despair Aura provoca slow em inimigos comuns, nunca bosses.
function Combat.TickAura(t: any, targets: {any}, now: number,
    enemyService: any, matchId: string)
    if t.Id ~= "OVL_Ainz" or now < (t.AuraNext or 0) then return end
    t.AuraNext = now + 13
    for _, enemy in ipairs(targets) do
        if not enemy.Boss and inRange(t, enemy, 19) then
            enemyService.ApplySlow(matchId, enemy.Serial, 0.14, 2.5)
        end
    end
end

function Combat.Attack(t: any, target: any, targets: {any},
    stats: any, now: number, player: Player,
    enemyService: any, matchId: string, buff: number): (boolean, boolean)
    if not Combat.IsPrototype(t.Id) then return false, false end
    if target.Health <= 0 then return false, false end

    local stage = Config.GetVisualStage(t.Id, t.Level)
    t.AttackCount = (t.AttackCount or 0) + 1
    local damage = stats.Damage * (1 + 0.16 * stage) * buff
    local critChance = 0.05
    local critMultiplier = 1.5
    local extraTargets = 0
    local secondaryFraction = 0.35

    if t.Id == "OVL_Climb" then
        if target.Progress >= 7 and now >= (t.PassiveNext or 0) then
            t.PassiveUntil = now + 5
            t.PassiveNext = now + 20
        end
        if stage >= 1 and t.AttackCount % 5 == 0 then
            damage *= 1.8
        end
        if stage >= 3 then
            extraTargets = 2
            secondaryFraction = 0.55 -- combo aprimorado Limit Breaker
        elseif stage >= 2 then
            extraTargets = 1
            secondaryFraction = 0.46 -- postura em combo
        end
    elseif t.Id == "OVL_Brain" then
        critChance = 0.15 + 0.04 * stage
        critMultiplier = 1.7
        if stage >= 2 and t.AttackCount % 5 == 0 then
            -- Quatro cortes concentrados, representados pelo dano total.
            damage *= 2.1
        end
        if stage >= 3 and t.AttackCount % 8 == 0 then
            damage *= 2.8
        end
    elseif t.Id == "OVL_Gazef" then
        -- Protótipo de Focus Battle Aura: impacto adicional contra armadura.
        -- A penetracao percentual completa ainda aguarda sistema de resists.
        if target.Id == "Armored" or target.Id == "CaptainInvader"
            or target.Id == "DominionAuthority" then
            damage *= 1.20
        end
        extraTargets = if stage >= 3 then 4 elseif stage >= 2 then 2
            elseif stage >= 1 then 1 else 0
        secondaryFraction = if stage >= 3 then 0.65 else 0.50
    elseif t.Id == "OVL_Shalltear" then
        damage *= 1 + 0.04 * math.clamp(t.Blood or 0, 0, 5)
        if stage >= 1 and t.AttackCount % 4 == 0 then
            t.Blood = math.min(5, (t.Blood or 0) + 1)
        end
        if stage >= 3 then extraTargets = 1; secondaryFraction = 0.44 end
    elseif t.Id == "OVL_Albedo" then
        if stage >= 2 then
            extraTargets = 2 -- pulso de escudo atingindo mais alvos
            secondaryFraction = 0.50
        elseif stage >= 1 then
            extraTargets = 1
            secondaryFraction = 0.42
        end
    elseif t.Id == "OVL_Ainz" then
        if stage >= 1 and t.AttackCount % 4 == 0 then
            damage *= 2.1
        end
        if stage >= 2 and target.MaxHealth
            and target.Health / math.max(1, target.MaxHealth) <= 0.25 then
            damage *= 1.25 -- bonus moderado, nao executa chefe
        end
        if stage >= 3 then extraTargets = 3; secondaryFraction = 0.62 end
    end

    local critical = RNG:NextNumber() < critChance
    if critical then damage *= critMultiplier end

    local damageType = if t.Id == "OVL_Ainz" or t.Id == "OVL_Albedo"
        then "Magic" else "Physical"

    local hit = enemyService.DamageEnemy(matchId, target.Serial,
        capped(damage), damageType, player)
    if not hit then return false, false end

    if extraTargets > 0 then
        local count = 0
        -- Garante que alvos adicionais tambem estejam no alcance da Tower.
        -- Resistencias, shields e boss hooks continuam no EnemyService.
        for _, enemy in ipairs(targets) do
            if count >= extraTargets then break end
            if enemy.Serial ~= target.Serial and enemy.Health > 0
                and inRange(t, enemy, stats.Range)
                and (t.TargetAir == true or enemy.Air ~= true) then
                if enemyService.DamageEnemy(matchId, enemy.Serial,
                    capped(damage * secondaryFraction), damageType, player) then
                    count += 1
                end
            end
        end
    end

    return true, critical
end

function Combat.AttackInterval(t: any, spa: number, now: number): number
    local effective = spa
    if t.Id == "OVL_Climb" and now < (t.PassiveUntil or 0) then
        effective /= 1.12
    elseif t.Id == "OVL_Shalltear" and t.Level >= 6 and (t.Blood or 0) >= 5 then
        effective /= 1.35
    end
    return math.max(0.22, effective)
end

function Combat.AddBloodOnKill(owners: {[number]: any}, where: Vector3)
    for _, owner in pairs(owners) do
        for _, t in pairs(owner.Towers) do
            if t.Id == "OVL_Shalltear" then
                local stats = Config.GetStats(t.Id, t.Level)
                if stats and (t.Position - where).Magnitude <= stats.Range then
                    t.Blood = math.min(5, (t.Blood or 0) + 1)
                end
            end
        end
    end
end

function Combat.ResetWave(owners: {[number]: any})
    for _, owner in pairs(owners) do
        for _, t in pairs(owner.Towers) do
            if t.Id == "OVL_Shalltear" then t.Blood = 0 end
        end
    end
end

return Combat
