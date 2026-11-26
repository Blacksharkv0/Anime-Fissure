--!strict
-- ANIME FISSURE | StageInfoConfig v0.8
-- Dados da fase extraidos dos configs canonicos.
-- Pity e posse de itens NAO sao inventados; integracao ao perfil pendente.

local RewardConfig = require(script.Parent:WaitForChild("StoryRewardConfig"))
local StoryConfig = require(script.Parent:WaitForChild("StoryConfig"))
local EnemyConfig = require(script.Parent:WaitForChild("EnemyConfig"))
local BossConfig = require(script.Parent:WaitForChild("BossConfig"))
local EvolutionLoot = require(script.Parent:WaitForChild("OverlordEvolutionLootConfig"))

local StageInfoConfig = {}

local displayNames = {
    SolarInsignia = "Insignia Solar",
    SolarSealFragment = "Fragmento do Selo Solar",
}

local function enemy(id: string, available: string): {[string]: any}
    local regular = EnemyConfig.Get(id)
    local special = BossConfig.GetBoss(id)
    local value = regular or special
    return {
        Id = id,
        Name = if value then value.Name else id,
        Appears = available,
        Category = if special then special.Category else (if regular then regular.Class else "Unknown"),
    }
end

function StageInfoConfig.BuildPayload(stageId: string, difficulty: string): {[string]: any}?
    if stageId ~= RewardConfig.StageId or (difficulty ~= "Classic" and difficulty ~= "Hard") then
        return nil
    end

    local stage = StoryConfig.GetStage("Overlord", 1)
    local rewards = RewardConfig.GetVictory(difficulty, false)
    if not stage or not rewards or stage.Id ~= stageId then return nil end

    local bossWave = if difficulty == "Hard" then 20 else 15
    local hasMini = BossConfig.GetBossForWave(stageId, difficulty, 10)
    local hasMain = BossConfig.GetBossForWave(stageId, difficulty, bossWave)

    local enemies: {{[string]: any}} = {
        enemy("Invader", "Wave 1+"),
        enemy("Scout", "Wave 3+"),
        enemy("Armored", "Wave 6+"),
    }
    if hasMini then table.insert(enemies, enemy(hasMini.Id, "Wave 10")) end
    if hasMain then
        table.insert(enemies, enemy(hasMain.Id, "Wave " .. bossWave))
        table.insert(enemies, enemy("WarAngel", "Invocacao de Nigun"))
        table.insert(enemies, enemy("DominionAuthority", "Fase 2 de Nigun"))
    end

    return {
        StageId = stage.Id,
        Name = "Carne Village",
        FullName = stage.Name,
        World = "Overlord",
        Difficulty = difficulty,
        Waves = bossWave,
        Element = nil, -- O elemento da fase ainda nao consta no catalogo.
        ElementConfigured = false,
        Enemies = enemies,
        Rewards = {
            {Id = "Gold", Name = "Gold", Amount = rewards.BaseGold, Type = "Currency"},
            {Id = rewards.FragmentItemId,
                Name = displayNames[rewards.FragmentItemId] or rewards.FragmentItemId,
                Amount = rewards.Fragments, Type = "Material"},
            {Id = "FirstClearBonus", Name = "Bonus primeira vitoria",
                Amount = RewardConfig.Victory[difficulty].FirstClearBonus, Type = "Bonus"},
        },
        XPConfigured = false, -- Nao existe valor de XP em StoryRewardConfig.
        RewardsActive = false, -- Ainda nao existe um servico de entrega de recompensas.
        PlannedEvolutionItems = EvolutionLoot.GetPlannedPreview(stageId, difficulty),
        SpecialDrops = {
            {
                Id = rewards.RareItemId,
                Name = displayNames[rewards.RareItemId] or rewards.RareItemId,
                Chance = rewards.RareDropChance,
                Needed = rewards.HardPity,
                Current = nil, -- Nao ha perfil de pity salvo para ler.
                Obtained = nil, -- Nao ha inventario de recompensas para consultar.
                ProgressConnected = false,
            },
        },
    }
end

return StageInfoConfig
