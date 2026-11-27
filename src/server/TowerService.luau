--!strict
-- ANIME FISSURE | TowerService v1.1
-- Servidor autoritativo: compra, posicionamento, upgrade, venda, farm e alvos.
-- Apenas as unidades beta FissureBlade/FissureMage estao livres;
-- Capsule requer posse REAL no SummonProfileStore.
-- Yen e torres sao temporarios da partida; nao concedem Gold do lobby.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("TowerConfig"))
local GameConfig = require(Shared:WaitForChild("GameConfig"))
local RewardConfig = require(Shared:WaitForChild("StoryRewardConfig"))
local MatchService = require(script.Parent:WaitForChild("MatchService"))
local EnemyService = require(script.Parent:WaitForChild("EnemyService"))
local SummonStore = require(script.Parent:WaitForChild("SummonProfileStore"))
local ModelBuilder = require(script.Parent:WaitForChild("TowerModelBuilder"))
local OverlordCombat = require(script.Parent:WaitForChild("OverlordCombatPrototype"))
local AbilityDesign = require(Shared:WaitForChild("OverlordAbilityDesign"))
local Pair = require(Shared:WaitForChild("OverlordPairSynergy"))
local AttackInfo = require(Shared:WaitForChild("TowerAttackInfo"))
local Rings = require(Shared:WaitForChild("RelicRingConfig"))

local TowerService = {}
local MATCH_ID = "MainMatch"
local states: {[string]: any} = {}
local towerSerial = 0
local requestTimes: {[number]: number} = {}
local syncTimes: {[number]: number} = {}

local remotes = ReplicatedStorage:FindFirstChild("TowerRemotes")
if remotes and not remotes:IsA("Folder") then remotes:Destroy(); remotes = nil end
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "TowerRemotes"
    remotes.Parent = ReplicatedStorage
end

local function ensureRemote(name: string): RemoteEvent
    local old = remotes:FindFirstChild(name)
    if old and old:IsA("RemoteEvent") then return old end
    if old then old:Destroy() end
    local r = Instance.new("RemoteEvent")
    r.Name = name
    r.Parent = remotes
    return r
end

local request = ensureRemote("TowerRequest")
local stateRemote = ensureRemote("TowerState")
local fxRemote = ensureRemote("AttackFX")
local function currentMatch() return MatchService.GetMatch(MATCH_ID) end

local function participant(player: Player)
    local match = currentMatch()
    return player.Parent == Players and player:GetAttribute("InArena") == true
        and match ~= nil and match.Status == "Playing"
        and table.find(match.Players, player) ~= nil
end

local function getPlayerState(player: Player)
    local state = states[MATCH_ID]
    if not state then return nil end
    return state.Owners[player.UserId]
end

-- Teamwide Overseer aura is an independent category; one copy max.
local function teamAuraMultiplier(owners: {[number]: any}): number
    for _, owner in pairs(owners) do
        for _, tower in pairs(owner.Towers) do
            if tower.Id == "OVL_Albedo" and tower.Level >= 9 then
                return 1.12
            end
        end
    end
    return 1
end

local function towerStats(t: any)
    local stats=Config.GetStats(t.Id,t.Level)
    local def=Config.Get(t.Id)
    if not stats or not def then return stats end
    return Rings.ApplyStats(stats,t.Id,def.Element,t.RelicId)
end

local function publicTower(t: any, pairActive: boolean, aura: number)
    local stats = towerStats(t)
    local def = Config.Get(t.Id)
    local nextLevel = t.Level + 1
    local stage = Config.GetVisualStage(t.Id, t.Level)
    local attack = AttackInfo.Get(t.Id, stage)
    -- The displayed damage is one NORMAL hit including always-on buffs.
    -- Crits, situational passives and enemy resistances are excluded.
    local currentDamage = if Config.IsOverlord(t.Id)
        then math.floor(stats.Damage * (1 + 0.16 * stage) * aura
            * Pair.GetMultiplier(t.Id, pairActive) + 0.5)
        else stats.Damage
    return {
        Serial = t.Serial, UnitId = t.Id, Name = t.Model.Name, Level = t.Level,
        Position = t.Position,
        Rarity = def.Rarity,
        Damage = stats.Damage, EffectiveDamage = currentDamage,
        SPA = stats.SPA, Range = stats.Range,
        RelicId = t.RelicId,
        RelicName = if t.RelicId then Rings.Get(t.RelicId).Name else nil,
        RelicStatus = Rings.GetStatus(t.RelicId,t.Id,def.Element),
        RelicActive = Rings.IsBonusActive(t.RelicId,t.Id,def.Element),
        AttackName = attack.Name, AttackType = attack.Type,
        Income = stats.Income, MaxUpgrades = def.MaxUpgrades,
        UpgradeCost = Config.GetCost(t.Id, nextLevel),
        SellValue = math.floor(t.Invested * 0.50 + 0.5),
        OwnerId = t.OwnerId,
        VisualStage = stage,
        PassiveName = if AbilityDesign.Get(t.Id)
            then AbilityDesign.Get(t.Id).Passive.Name else nil,
        SynergyName = if Pair.AppliesToInfo(t.Id) then Pair.Name else nil,
        SynergyActive = Pair.AppliesToInfo(t.Id) and pairActive,
        SynergyBonus = if t.Id == "OVL_Albedo" and pairActive then Pair.Bonus else 0,
        Blood = t.Blood,
        GuardCharges = t.GuardCharges,
    }
end

local function sendState(player: Player, message: string?)
    if player.Parent ~= Players then return end
    local owner = getPlayerState(player)
    local state = states[MATCH_ID]
    local towers = {}
    if owner and state then
        local pairActive = Pair.HasPair(state.Owners)
        local aura = teamAuraMultiplier(state.Owners)
        -- Info for ALL placed allied towers is public; upgrade/sell remain owner-only.
        for _, alliedOwner in pairs(state.Owners) do
            for _, tower in pairs(alliedOwner.Towers) do
                table.insert(towers, publicTower(tower, pairActive, aura))
            end
        end
        table.sort(towers, function(a, b) return a.Serial < b.Serial end)
    end
    stateRemote:FireClient(player, {
        Ready = owner ~= nil,
        HasCapsule = owner and owner.HasCapsule == true or false,
        ProfileLoading = owner and owner.ProfileLoading == true or false,
        Yen = if owner then owner.Yen else nil,
        Deck = Config.GetPublicDeck(owner and owner.HasCapsule == true or false,
            if owner then owner.DeckMode else "Legacy"),
        StudioLab = RunService:IsStudio(),
        DeckMode = if owner then owner.DeckMode else "Legacy",
        Towers = towers,
        Message = message,
    })
end

local function validPosition(pos: any, state: any): (boolean, Vector3?)
    if typeof(pos) ~= "Vector3" or pos.X ~= pos.X or pos.Y ~= pos.Y or pos.Z ~= pos.Z
        or math.abs(pos.X) > 84 or math.abs(pos.Z) > 58
        or math.abs(pos.Y) > 10 then return false, nil end
    local arena = state.Arena
    if not arena or not arena.Parent then return false, nil end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = {arena}
    params.IgnoreWater = true
    local hit = Workspace:Raycast(Vector3.new(pos.X, 180, pos.Z),
        Vector3.new(0, -195, 0), params)
    if not hit or not hit.Instance or hit.Instance.Name ~= "VillageMeadow"
        or math.abs(hit.Position.Y) > 0.65 then return false, nil end

    local flat = Vector3.new(pos.X, 0, pos.Z)
    local path = arena:FindFirstChild("EnemyPath")
    if not path then return false, nil end
    local markers = {}
    for _, p in ipairs(path:GetChildren()) do
        local order = p:GetAttribute("Order")
        if p:IsA("BasePart") and typeof(order) == "number" then
            table.insert(markers, {Order = order, Position = Vector2.new(p.Position.X, p.Position.Z)})
        end
    end
    table.sort(markers, function(a,b) return a.Order < b.Order end)
    if #markers < 2 then return false, nil end
    local minPath = math.huge
    for i = 1, #markers - 1 do
        local a, b = markers[i].Position, markers[i+1].Position
        local point = Vector2.new(pos.X, pos.Z)
        local d = b - a
        local t = if d:Dot(d) > 0 then math.clamp((point - a):Dot(d) / d:Dot(d), 0, 1) else 0
        minPath = math.min(minPath, (point - (a + d * t)).Magnitude)
    end
    -- A torre precisa poder atacar o trajeto sem obstruir passagem.
    if minPath < 8 or minPath > 38 then return false, nil end

    for _, sp in ipairs({Vector3.new(-4,0,48),Vector3.new(4,0,48),
        Vector3.new(-4,0,57),Vector3.new(4,0,57)}) do
        if (flat - sp).Magnitude < 7 then return false, nil end
    end

    for _, owner in pairs(state.Owners) do
        for _, t in pairs(owner.Towers) do
            if (flat - t.Position).Magnitude < 6.1 then return false, nil end
        end
    end
    return true, flat
end

function TowerService.BeginMatch(matchId: string, participants: {Player}): boolean
    if matchId ~= MATCH_ID or states[matchId] or #participants < 1 then return false end
    local arena = Workspace:FindFirstChild("FissureArena")
    if not arena or not arena:IsA("Model") then return false end
    local folder = arena:FindFirstChild("LiveTowers")
    if folder then folder:Destroy() end
    folder = Instance.new("Folder")
    folder.Name = "LiveTowers"
    folder.Parent = arena

    local state = {Id = matchId, Arena = arena, Folder = folder, Owners = {}}
    for _, player in ipairs(participants) do
        state.Owners[player.UserId] = {
            Player = player,
            Yen = if RunService:IsStudio() then Config.StudioLabYen else Config.StartingYen,
            DeckMode = if RunService:IsStudio() then "Overlord" else "Legacy",
            HasCapsule = false,
            ProfileLoading = true,
            Towers = {},
        }
    end
    states[matchId] = state
    for _, player in ipairs(participants) do
        sendState(player, "Unidades de teste disponiveis. Sincronizando Capsule...")
        task.spawn(function()
            local snapshot = SummonStore.Snapshot(player)
            if states[matchId] ~= state then return end
            local owner = state.Owners[player.UserId]
            if not owner then return end
            owner.ProfileLoading = false
            owner.HasCapsule = snapshot.Ready == true
                and typeof(snapshot.Collection) == "table"
                and (function()
                    for _, item in ipairs(snapshot.Collection) do
                        if item.UnitId == "Capsule" then return true end
                    end
                    return false
                end)()
            sendState(player, if owner.HasCapsule
                then "Capsule desbloqueada via Summon." else "Capsule requer Summon com Virgil.")
        end)
    end
    print("[Anime Fissure Towers] Partida iniciada; unidades beta disponiveis")
    return true
end

function TowerService.GetYen(player: Player): number?
    local owner = getPlayerState(player)
    return if owner then owner.Yen else nil
end

local function countUnit(owner: any, id: string): number
    local n = 0
    for _, t in pairs(owner.Towers) do
        if t.Id == id then n += 1 end
    end
    return n
end

local function place(player: Player, unitId: any, pos: any)
    local state = states[MATCH_ID]
    local owner = getPlayerState(player)
    if not state or not owner then return "Sem partida ativa." end
    local def = Config.Get(unitId)
    if not def then return "Unidade desconhecida." end
    if def.StudioOnly == true and not RunService:IsStudio() then
        return "Modelo exclusivo do laboratorio Studio."
    end
    local deck = Config.GetPublicDeck(owner.HasCapsule, owner.DeckMode)
    local equipped = false
    for _, entry in ipairs(deck) do
        if entry.UnitId == unitId and entry.Available == true then
            equipped = true
            break
        end
    end
    if not equipped then return "Essa unidade nao esta no deck de teste atual." end
    if def.Id == "Capsule" and not owner.HasCapsule then
        return "Voce precisa obter Capsule no Summon antes da partida."
    end
    if countUnit(owner, def.Id) >= def.MaxPlacements then
        return "Limite de colocacoes dessa unidade atingido."
    end
    local valid, final = validPosition(pos, state)
    if not valid or not final then return "Escolha grama livre, perto do caminho." end
    local cost = def.PlacementCost
    if owner.Yen < cost then return "Yen insuficiente." end

    local model = ModelBuilder.Build(def.Id, def)
    towerSerial += 1
    local id = towerSerial
    local unit = {
        Serial = id, Id = def.Id, Level = 0, OwnerId = player.UserId,
        Position = final, Model = model, Invested = cost,
        NextAttack = 0,
        RelicId = nil, -- Tower-local Studio trial, never item inventory.
        AttackCount = 0,
        Blood = 0,
        AuraNext = os.clock() + 2,
        GuardCharges = if def.Id == "OVL_Albedo" then 3 else nil,
        LastGuard = -100,
        TargetAir = def.TargetAir == true,
    }
    model:SetAttribute("TowerSerial", id)
    model:SetAttribute("OwnerId", player.UserId)
    -- Os R6 de Overlord usam o HumanoidRootPart a 3 studs do solo.
    -- Modelos legados mantem o pivot na base.
    model:PivotTo(CFrame.new(final +
        (if Config.IsOverlord(def.Id) then Vector3.new(0, 3, 0) else Vector3.zero)))
    model.Parent = state.Folder
    owner.Yen -= cost
    owner.Towers[id] = unit
    return nil
end

local function changeTower(player: Player, serialId: any, sell: boolean): string?
    local owner = getPlayerState(player)
    if not owner or typeof(serialId) ~= "number" or serialId % 1 ~= 0 then
        return "Torre invalida."
    end
    local tower = owner.Towers[serialId]
    if not tower then return "Essa torre nao pertence a voce." end
    if sell then
        owner.Yen += math.floor(tower.Invested * 0.5 + 0.5)
        owner.Towers[serialId] = nil
        tower.Model:Destroy()
        return nil
    end
    local nextLevel = tower.Level + 1
    local price = Config.GetCost(tower.Id, nextLevel)
    if not price then return "Torre ja esta no nivel maximo." end
    if owner.Yen < price then return "Yen insuficiente para o upgrade." end
    local nextStats = Config.GetStats(tower.Id, nextLevel)
    if not nextStats then return "Upgrade indisponivel para essa unidade." end
    owner.Yen -= price
    tower.Invested += price
    tower.Level = nextLevel
    ModelBuilder.UpdateLevel(tower.Model, nextLevel)
    return nil
end

-- Equipment trial is server-authoritative but intentionally Studio-only.
-- No item is minted; no inventory, persistence, drop or evolution happens.
local function equipRelic(player: Player, serial: any, relicId: any): string?
    if not RunService:IsStudio() then return "Relíquias aguardam inventário real." end
    if typeof(serial)~="number" or serial%1~=0 then return "Torre inválida." end
    if typeof(relicId)~="string" then return "Relíquia inválida." end
    if relicId~="None" and not Rings.IsRing(relicId) then
        return "Esse item não é um anel equipável."
    end
    local owner=getPlayerState(player)
    local tower=if owner then owner.Towers[serial] else nil
    if not tower then return "Essa Tower não pertence a você." end
    if tower.Id=="Capsule" then return "Capsule não equipa anéis de combate." end
    tower.RelicId=if relicId=="None" then nil else relicId
    tower.Model:SetAttribute("EquippedRelicId",tower.RelicId)
    -- The existing attack cooldown is NOT reset to prevent swap exploits.
    return nil
end

request.OnServerEvent:Connect(function(player: Player, action: any, a: any, b: any)
    if typeof(action) ~= "string" then return end
    if action == "Sync" then
        local now = os.clock()
        if now - (syncTimes[player.UserId] or -100) >= 0.6 then
            syncTimes[player.UserId] = now
            sendState(player)
        end
        return
    end
    if not participant(player) then
        sendState(player, "Voce precisa estar em uma partida ativa.")
        return
    end
    local now = os.clock()
    if now - (requestTimes[player.UserId] or -100) < 0.13 then return end
    requestTimes[player.UserId] = now
    local err: string?
    if action == "LabDeck" and RunService:IsStudio() then
        local owner = getPlayerState(player)
        if owner then
            owner.DeckMode = if owner.DeckMode == "Overlord" then "Legacy" else "Overlord"
            sendState(player, "DECK LAB alterado: " .. owner.DeckMode)
        end
        return
    elseif action == "LabFunds" and RunService:IsStudio() then
        local owner = getPlayerState(player)
        if owner then
            owner.Yen = math.min(100000, owner.Yen + 20000)
            sendState(player, "+20000 Yen de laboratorio (apenas Studio).")
        end
        return
    elseif action == "Place" then err = place(player, a, b)
    elseif action == "Upgrade" then err = changeTower(player, a, false)
    elseif action == "Sell" then err = changeTower(player, a, true)
    elseif action == "EquipRelic" then err = equipRelic(player, a, b)
    else return end
    local resultMessage = err or (if action == "Place" then "Torre posicionada."
        elseif action == "Upgrade" then "Upgrade realizado."
        elseif action == "Sell" then "Torre vendida."
        else "Relíquia alterada no Studio • nenhuma posse foi concedida.")
    if err then
        sendState(player, resultMessage)
    else
        -- Keep cross-player info and Albedo/Ainz synergy state in sync when
        -- one team member places, upgrades or sells a tower.
        local state = states[MATCH_ID]
        if state then
            for _, teamOwner in pairs(state.Owners) do
                if teamOwner.Player.Parent == Players then
                    sendState(teamOwner.Player,
                        if teamOwner.Player == player then resultMessage else nil)
                end
            end
        end
    end
end)

function TowerService.OnEnemyDefeated(matchId: string, player: Player,
    enemyId: string, position: Vector3?)
    if matchId ~= MATCH_ID or not participant(player) then return end
    local state = states[matchId]
    if not state then return end
    if typeof(position) == "Vector3" then
        OverlordCombat.AddBloodOnKill(state.Owners, position)
    end
    local gained = RewardConfig.GetEnemyYen(enemyId)
    if gained <= 0 then return end
    if GameConfig.Coop.SharedYenFromKills then
        for _, owner in pairs(state.Owners) do
            if owner.Player.Parent == Players then
                owner.Yen += gained
                sendState(owner.Player, "+" .. gained .. " Yen compartilhado por kill.")
            end
        end
    else
        local owner = getPlayerState(player)
        if owner then
            owner.Yen += gained
            sendState(player, "+" .. gained .. " Yen por inimigo derrotado.")
        end
    end
end

function TowerService.OnWaveCleared(matchId: string)
    local state = states[matchId]
    if not state or not currentMatch() or currentMatch().Status ~= "Playing" then return end
    OverlordCombat.ResetWave(state.Owners)
    for _, owner in pairs(state.Owners) do
        local farmYield = 0
        for _, t in pairs(owner.Towers) do
            if t.Id == "Capsule" then
                local stats = Config.GetStats(t.Id, t.Level)
                farmYield += if stats and stats.Income then stats.Income else 0
            end
        end
        if farmYield > 0 then
            owner.Yen += farmYield
            sendState(owner.Player, "+" .. farmYield .. " Yen das Capsules nesta wave.")
        end
    end
end

-- Hermes Trismegistus: passiva funcional inicial da Albedo.
-- Bloqueia no maximo 3 vazamentos NORMAIS por Albedo perto da base,
-- intervalo minimo de 28s; nao anula boss que causa derrota instantanea.
function TowerService.TryBlockLeak(matchId: string, instantDefeat: boolean): boolean
    if instantDefeat == true then return false end
    local state = states[matchId]
    if not state then return false end
    local baseFolder = state.Arena:FindFirstChild("FissureBase")
    local core = if baseFolder then baseFolder:FindFirstChild("BaseCore") else nil
    if not core or not core:IsA("BasePart") then return false end
    local now = os.clock()
    for _, owner in pairs(state.Owners) do
        for _, t in pairs(owner.Towers) do
            if t.Id == "OVL_Albedo" and (t.GuardCharges or 0) > 0
                and now - (t.LastGuard or -100) >= 28
                and (t.Position - core.Position).Magnitude <= 31 then
                t.GuardCharges -= 1
                t.LastGuard = now
                sendState(owner.Player, "Albedo bloqueou um vazamento normal!")
                fxRemote:FireAllClients({Kind = "Guard", To = core.Position})
                return true
            end
        end
    end
    return false
end

function TowerService.EndMatch(matchId: string)
    local state = states[matchId]
    if not state then return end
    -- Modelos permanecem para visual do resultado; desativa ataque e comandos.
    states[matchId] = nil
    for _, owner in pairs(state.Owners) do
        if owner.Player.Parent == Players then sendState(owner.Player, "Partida encerrada.") end
    end
end

local function tracer(from: Vector3, to: Vector3, color: Color3, parent: Instance)
    local diff = to - from
    if diff.Magnitude < 0.2 then return end
    local beam = Instance.new("Part")
    beam.Name = "TowerShot"
    beam.Anchored = true
    beam.CanCollide = false
    beam.CanTouch = false
    beam.CanQuery = false
    beam.Material = Enum.Material.Neon
    beam.Color = color
    beam.Transparency = 0.15
    beam.Size = Vector3.new(0.18, 0.18, diff.Magnitude)
    beam.CFrame = CFrame.lookAt((from + to) / 2, to)
    beam.Parent = parent
    Debris:AddItem(beam, 0.17)
end

local elapsed = 0
RunService.Heartbeat:Connect(function(dt)
    elapsed += math.min(dt, 0.1)
    if elapsed < 0.13 then return end
    elapsed = 0
    local state = states[MATCH_ID]
    local match = currentMatch()
    if not state or not match or match.Status ~= "Playing" then return end
    local targets = EnemyService.GetTargets(MATCH_ID)
    if #targets == 0 then return end
    local now = os.clock()
    local pairActive = Pair.HasPair(state.Owners)
    local aura = teamAuraMultiplier(state.Owners)
    for _, owner in pairs(state.Owners) do
        if owner.Player.Parent ~= Players then continue end
        for _, t in pairs(owner.Towers) do
            local stats = towerStats(t)
            if stats and stats.Damage > 0 then
                if OverlordCombat.IsPrototype(t.Id) then
                    OverlordCombat.TickAura(t, targets, now, EnemyService, MATCH_ID)
                end
            end
            if stats and stats.Damage > 0 and now >= t.NextAttack then
                local best = nil
                local score = -math.huge
                for _, enemy in ipairs(targets) do
                    local distance = (enemy.Position - t.Position).Magnitude
                    if enemy.Health > 0 and distance <= stats.Range
                        and (t.TargetAir == true or not enemy.Air) then
                        local priority = enemy.Progress * 1000 - distance
                        if priority > score then
                            best = enemy
                            score = priority
                        end
                    end
                end
                if best then
                    local def = Config.Get(t.Id)
                    if OverlordCombat.IsPrototype(t.Id) then
                        -- Two independent categories: Overseer +12% to team
                        -- and nonstacking Ainz/Albedo pair +30% to Albedo only.
                        local teamBuff = aura * Pair.GetMultiplier(t.Id, pairActive)
                        local fired, critical = OverlordCombat.Attack(t, best,
                            targets, stats, now, owner.Player, EnemyService,
                            MATCH_ID, teamBuff)
                        if fired then
                            t.NextAttack = now +
                                OverlordCombat.AttackInterval(t, stats.SPA, now)
                            fxRemote:FireAllClients({
                                Kind = "Attack", UnitId = t.Id,
                                Serial = t.Serial,
                                From = t.Position + Vector3.new(0, 4.1, 0),
                                To = best.Position,
                                Stage = Config.GetVisualStage(t.Id, t.Level),
                                Critical = critical,
                            })
                        end
                    else
                        t.NextAttack = now + stats.SPA
                        local kind = if t.Id == "FissureMage" then "Magic" else "Physical"
                        if EnemyService.DamageEnemy(MATCH_ID, best.Serial,
                            stats.Damage, kind, owner.Player) then
                            tracer(t.Position + Vector3.new(0, 4.1, 0),
                                best.Position, def.AttackColor, state.Folder)
                        end
                    end
                end
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    requestTimes[player.UserId] = nil
    syncTimes[player.UserId] = nil
end)

return TowerService
