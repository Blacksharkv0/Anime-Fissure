--!strict
-- ANIME FISSURE | EnemyService v0.5
-- Spawns reais e movimento pelo EnemyPath da FissureArena.
-- Servidor controla HP, spawns, dano na base e conclusao da wave.
-- Ataque por clique APENAS no Studio; as torres usam DamageEnemy no servidor.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local EnemyConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("EnemyConfig"))
local BossConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("BossConfig"))
local BossService = require(script.Parent:WaitForChild("BossService"))
local Builder = require(script.Parent:WaitForChild("EnemyModelBuilder"))

local EnemyService = {}
local live: {[string]: any} = {}
local serial = 0
local lastTestHit: {[number]: number} = {}
local TRAINING_DAMAGE = 450

local function loadPath(): (Model?, {Vector3})
    local arena = Workspace:WaitForChild("FissureArena", 35)
    if not arena or not arena:IsA("Model") then return nil, {} end
    local folder = arena:WaitForChild("EnemyPath", 15)
    if not folder or not folder:IsA("Folder") then return nil, {} end

    local points: {{N: number, Position: Vector3}} = {}
    for _, marker in ipairs(folder:GetChildren()) do
        if marker:IsA("BasePart") then
            local order = marker:GetAttribute("Order")
            if typeof(order) == "number" then
                table.insert(points, {N = order, Position = marker.Position})
            end
        end
    end
    table.sort(points, function(a, b) return a.N < b.N end)
    local result: {Vector3} = {}
    for _, entry in ipairs(points) do table.insert(result, entry.Position) end
    if #result < 2 then return nil, {} end
    return arena, result
end

local function report(state: any)
    if live[state.Id] ~= state then return end
    local ok, err = pcall(state.Hooks.OnCount, math.max(0, state.Remaining))
    if not ok then warn("[EnemyService] OnCount:", err) end
end

local function finishIfClear(state: any)
    if live[state.Id] ~= state or state.Finished or not state.SpawnDone or state.Remaining > 0 then
        return
    end
    state.Finished = true
    local ok, err = pcall(state.Hooks.OnCleared)
    if not ok then warn("[EnemyService] OnCleared:", err) end
end

local function removeActor(state: any, actor: any, leaked: boolean)
    if live[state.Id] ~= state or state.Actors[actor.Serial] ~= actor then return end
    state.Actors[actor.Serial] = nil
    if actor.Model then actor.Model:Destroy() end

    if actor.SourceEncounter then
        BossService.NotifySummonRemoved(actor.SourceEncounter, actor.Id, 1)
    end

    state.Remaining = math.max(0, state.Remaining - 1)
    report(state)

    if leaked then
        local instant = actor.InstantDefeatOnLeak == true
        local ok, err = pcall(state.Hooks.OnLeak, instant, actor.Id)
        if not ok then warn("[EnemyService] OnLeak:", err) end
        if live[state.Id] ~= state then return end
    end

    finishIfClear(state)
end

local function damageActor(state: any, actor: any, amount: number, damageType: string?, attacker: Player?)
    if live[state.Id] ~= state or state.Actors[actor.Serial] ~= actor then return end
    if typeof(amount) ~= "number" or amount ~= amount
        or amount <= 0 or amount > 100000 or amount == math.huge then return false end
    local dealt = math.max(0, amount)
    if actor.BossEncounter then
        local result = BossService.ApplyDamage(actor.BossEncounter, dealt, damageType or "Physical")
        if result == nil then return false end
        local bossState = BossService.GetState(actor.BossEncounter)
        if not bossState then return false end
        actor.Health = bossState.Health
    else
        actor.Health = math.max(0, actor.Health - dealt)
    end
    Builder.UpdateHealth(actor.Model, actor.Health, actor.MaxHealth)
    if actor.Health <= 0 then
        -- Premio associado a quem acertou o golpe final, sem RemoteEvent publico.
        if attacker and typeof(state.Hooks.OnDefeated) == "function" then
            local ok, err = pcall(state.Hooks.OnDefeated, attacker, actor.Id)
            if not ok then warn("[EnemyService] OnDefeated:", err) end
        end
        removeActor(state, actor, false)
    end
    return true
end

-- API de combate exclusiva de ModuleScripts no servidor; IDs temporarios por wave.
-- NUNCA aceitar dano vindo de um RemoteEvent do cliente.
function EnemyService.GetTargets(matchId: string): {any}
    local state = live[matchId]
    local targets = {}
    if not state then return targets end
    for _, actor in pairs(state.Actors) do
        if actor.Health > 0 and actor.Model and actor.Model.Parent then
            table.insert(targets, {
                Serial = actor.Serial,
                Id = actor.Id,
                Position = actor.Position,
                Health = actor.Health,
                Air = actor.Air,
                Progress = actor.NextWaypoint,
            })
        end
    end
    return targets
end

function EnemyService.DamageEnemy(matchId: string, serialId: number,
    amount: number, damageType: string, attacker: Player): boolean
    local state = live[matchId]
    if not state or typeof(serialId) ~= "number" or serialId % 1 ~= 0
        or (damageType ~= "Physical" and damageType ~= "Magic" and damageType ~= "True")
        or attacker.Parent ~= Players or attacker:GetAttribute("InArena") ~= true
        or table.find(state.Players, attacker) == nil then return false end
    local actor = state.Actors[serialId]
    if not actor then return false end
    return damageActor(state, actor, amount, damageType, attacker) == true
end

local spawnActor: (any, string, Vector3?, number?, string?) -> boolean

spawnActor = function(state: any, id: string, atPosition: Vector3?, atWaypoint: number?, sourceEncounter: string?): boolean
    if live[state.Id] ~= state then return false end
    local bossDefinition = BossConfig.GetBoss(id)
    local bossMain = bossDefinition
        and (bossDefinition.Category == "MiniBoss" or bossDefinition.Category == "MainBoss")
    local stats = if bossDefinition then
        BossConfig.GetStats(id, state.Mode, state.PlayerCount)
        else EnemyConfig.GetStats(id, state.Wave, state.Mode, state.PlayerCount)
    if not stats then
        warn("[EnemyService] Tipo desconhecido:", id)
        return false
    end

    stats.Size = if bossMain then 2.3 elseif bossDefinition then 1.35 else stats.Size
    stats.Color = if bossDefinition then Color3.fromRGB(95, 68, 144) else stats.Color
    stats.Accent = if bossDefinition then Color3.fromRGB(224, 171, 255) else stats.Accent
    stats.Boss = bossMain == true
    local model = Builder.Build(stats)
    serial += 1

    local offsetY = math.max(0, 2.83 * (stats.Size or 1) - 2)
        + (if stats.Air == true then 3.2 else 0)
    local nextWaypoint = math.clamp(atWaypoint or 2, 2, #state.Path)
    local at = atPosition or state.Path[1]
    local position = Vector3.new(at.X, state.Path[nextWaypoint - 1].Y + offsetY, at.Z)
    model.Parent = state.Folder
    model:PivotTo(CFrame.new(position))
    local maxHealth = stats.MaxHealth or stats.Health
    local actor = {
        Serial = serial,
        Id = id,
        Model = model,
        Position = position,
        NextWaypoint = nextWaypoint,
        Health = maxHealth,
        MaxHealth = maxHealth,
        Speed = stats.Speed,
        Air = stats.Air == true,
        OffsetY = offsetY,
        BossEncounter = nil :: string?,
        SourceEncounter = sourceEncounter,
        InstantDefeatOnLeak = stats.InstantDefeatOnLeak == true,
    }
    state.Actors[serial] = actor
    model:SetAttribute("EnemySerial", serial)
    Builder.UpdateHealth(model, maxHealth, maxHealth)

    if bossMain then
        local encounterId = state.Id .. ":" .. tostring(state.Wave) .. ":" .. id
        actor.BossEncounter = encounterId
        state.BossEncounter = encounterId
        local created = BossService.Create(encounterId, id, state.Mode, state.PlayerCount, {
            OnSummon = function(_encounter: string, unitId: string, amount: number): number
                if live[state.Id] ~= state or state.Actors[actor.Serial] ~= actor then return 0 end
                local made = 0
                for _ = 1, amount do
                    local ok = spawnActor(state, unitId, actor.Position, actor.NextWaypoint, encounterId)
                    if ok then
                        made += 1
                        state.Remaining += 1
                    end
                end
                report(state)
                return made
            end,
            OnEvent = function(_encounter: string, eventName: string, info: any)
                if live[state.Id] ~= state then return end
                model:SetAttribute("BossEvent", eventName)
                if eventName == "PhaseChanged" then
                    model:SetAttribute("BossPhase", info.Phase)
                end
                print("[Anime Fissure Boss]", id, eventName)
            end,
        })
        if not created then
            state.Actors[serial] = nil
            model:Destroy()
            return false
        end
    end

    if RunService:IsStudio() then
        local body = model:FindFirstChild("Body")
        if body and body:IsA("BasePart") then
            local click = Instance.new("ClickDetector")
            click.MaxActivationDistance = 90
            click.Parent = body
            click.MouseClick:Connect(function(player: Player)
                if live[state.Id] ~= state or player.Parent ~= Players
                    or player:GetAttribute("InArena") ~= true
                    or table.find(state.Players, player) == nil then return end
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not root or not root:IsA("BasePart")
                    or (root.Position - actor.Position).Magnitude > 94 then return end
                local now = os.clock()
                if now - (lastTestHit[player.UserId] or -100) < 0.11 then return end
                lastTestHit[player.UserId] = now
                damageActor(state, actor, TRAINING_DAMAGE, "Physical", player)
            end)
        end
    end

    return true
end

function EnemyService.StartWave(matchId: string, wave: number, mode: string,
    participants: {Player}, hooks: any): boolean
    if live[matchId] or #participants < 1 or #participants > 4 then return false end
    if typeof(hooks) ~= "table"
        or typeof(hooks.OnCount) ~= "function"
        or typeof(hooks.OnCleared) ~= "function"
        or typeof(hooks.OnLeak) ~= "function" then return false end

    local arena, path = loadPath()
    if not arena then
        warn("[EnemyService] Arena/waypoints ausentes")
        return false
    end

    local plan = EnemyConfig.GetWavePlan(wave)
    local boss = BossConfig.GetBossForWave(EnemyConfig.StageId, mode, wave)
    if boss then table.insert(plan, boss.Id) end

    local folder = arena:FindFirstChild("LiveEnemies")
    if folder then folder:Destroy() end
    folder = Instance.new("Folder")
    folder.Name = "LiveEnemies"
    folder.Parent = arena

    local state = {
        Id = matchId,
        Wave = wave,
        Mode = mode,
        PlayerCount = #participants,
        Players = table.clone(participants),
        Hooks = hooks,
        Folder = folder,
        Path = path,
        Actors = {} :: {[number]: any},
        Remaining = #plan,
        SpawnDone = false,
        Finished = false,
        BossEncounter = nil :: string?,
        BossTime = 0,
    }
    live[matchId] = state
    report(state)
    print(string.format("[EnemyService] Wave %d | %d inimigos reais | Modo %s",
        wave, #plan, mode))

    task.spawn(function()
        for i, id in ipairs(plan) do
            if live[matchId] ~= state then return end
            if not spawnActor(state, id, nil, nil, nil) then
                state.Remaining = math.max(0, state.Remaining - 1)
                report(state)
            end
            if i < #plan then task.wait(EnemyConfig.SpawnInterval) end
        end
        if live[matchId] ~= state then return end
        state.SpawnDone = true
        finishIfClear(state)
    end)

    return true
end

RunService.Heartbeat:Connect(function(dt: number)
    local delta = math.min(dt, 0.1)
    for _, state in pairs(live) do
        state.BossTime += delta
        if state.BossEncounter and state.BossTime >= 0.15 then
            BossService.Update(state.BossEncounter, state.BossTime)
            state.BossTime = 0
        end
        for _, actor in pairs(state.Actors) do
            if live[state.Id] ~= state then break end
            if state.Actors[actor.Serial] ~= actor then continue end
            local speed = actor.Speed
            if actor.BossEncounter then
                local bossState = BossService.GetState(actor.BossEncounter)
                if bossState then
                    speed = bossState.Speed
                    if bossState.MovementPaused then continue end
                end
            end

            local destination = state.Path[actor.NextWaypoint]
            if not destination then
                removeActor(state, actor, true)
                continue
            end
            destination += Vector3.new(0, actor.OffsetY, 0)
            local difference = destination - actor.Position
            local distance = difference.Magnitude
            local move = speed * delta

            if distance <= move + 0.05 then
                actor.Position = destination
                actor.NextWaypoint += 1
                if actor.NextWaypoint > #state.Path then
                    removeActor(state, actor, true)
                    continue
                end
            elseif distance > 0.001 then
                actor.Position += difference.Unit * move
            end
            if state.Actors[actor.Serial] == actor then
                local nextTarget = state.Path[actor.NextWaypoint]
                if nextTarget then
                    local direction = nextTarget - state.Path[math.max(1, actor.NextWaypoint - 1)]
                    if direction.Magnitude > 0.01 then
                        local flat = Vector3.new(direction.X, 0, direction.Z)
                        actor.Model:PivotTo(CFrame.lookAt(actor.Position, actor.Position + flat))
                    else
                        actor.Model:PivotTo(CFrame.new(actor.Position))
                    end
                end
            end
        end
    end
end)

function EnemyService.StopWave(matchId: string)
    local state = live[matchId]
    if not state then return end
    live[matchId] = nil
    if state.BossEncounter then BossService.Remove(state.BossEncounter) end
    if state.Folder then state.Folder:Destroy() end
end

Players.PlayerRemoving:Connect(function(player)
    lastTestHit[player.UserId] = nil
end)

return EnemyService
