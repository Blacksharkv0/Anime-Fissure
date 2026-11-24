--!strict
-- ANIME FISSURE | Overlord Combat smoke test (Studio only)
-- Testa a logica pura dos seis ataques, passivas e marcos de upgrade.
-- Nao cria partidas, nao concede recursos e nao modifica inimigos reais.

local RunService = game:GetService("RunService")
if not RunService:IsStudio() then return end

local RS = game:GetService("ReplicatedStorage")
local shared = RS:WaitForChild("Shared")
local Config = require(shared:WaitForChild("TowerConfig"))
local Roster = require(shared:WaitForChild("OverlordUnitRoster"))
local Design = require(shared:WaitForChild("OverlordAbilityDesign"))
local Combat = require(script.Parent:WaitForChild("OverlordCombatPrototype"))

local expected = {"OVL_Climb", "OVL_Brain", "OVL_Gazef",
    "OVL_Shalltear", "OVL_Albedo", "OVL_Ainz"}

local calls = 0
local slows = 0
local stub = {
    DamageEnemy = function(_id: string, serial: number, damage: number,
        kind: string, _player: Player)
        assert(typeof(serial) == "number" and serial > 0)
        assert(typeof(damage) == "number" and damage > 0 and damage < 100000)
        assert(kind == "Physical" or kind == "Magic")
        calls += 1
        return true
    end,
    ApplySlow = function(_id: string, serial: number, amount: number, duration: number)
        assert(serial > 0 and amount > 0 and duration > 0)
        slows += 1
        return true
    end,
}

for _, id in ipairs(expected) do
    local def = Config.Get(id)
    local design = Design.Get(id)
    assert(def and def.StudioOnly, "Unidade indisponivel no Studio: " .. id)
    assert(design and design.Passive and design.Passive.Name, "Passiva ausente: " .. id)
    assert(Config.IsOverlord(id) and Combat.IsPrototype(id), "Flag de combate ausente: " .. id)
    local tower = {
        Id = id, Level = 0, Position = Vector3.zero,
        AttackCount = 0, Blood = 0, AuraNext = 0,
        TargetAir = def.TargetAir == true,
    }
    local targets = {
        {Serial = 1, Id = "Invader", Position = Vector3.new(9, 0, 0),
            Health = 1000, MaxHealth = 1000, Progress = 7, Air = false, Boss = false},
        {Serial = 2, Id = "Armored", Position = Vector3.new(11, 0, 0),
            Health = 1000, MaxHealth = 1000, Progress = 7, Air = false, Boss = false},
        {Serial = 3, Id = "Scout", Position = Vector3.new(12, 0, 0),
            Health = 1000, MaxHealth = 1000, Progress = 7, Air = false, Boss = false},
        {Serial = 4, Id = "Invader", Position = Vector3.new(13, 0, 0),
            Health = 1000, MaxHealth = 1000, Progress = 7, Air = false, Boss = false},
    }
    for _, level in ipairs({0, 3, 6, 9}) do
        tower.Level = level
        local stats = Config.GetStats(id, level)
        assert(stats and stats.Damage > 0 and stats.Range > 0 and stats.SPA > 0,
            "Atributos invalidos: " .. id)
        assert(Config.GetVisualStage(id, level) == math.floor(level / 3),
            "Upgrade sem 3 mudancas: " .. id)
        local hit = Combat.Attack(tower, targets[1], targets,
            stats, 40 + level, nil :: any, stub, "DryRun", 1)
        assert(hit == true, "Ataque nao executado: " .. id)
        assert(Combat.AttackInterval(tower, stats.SPA, 40) > 0,
            "Intervalo de ataque invalido: " .. id)
    end
    if id == "OVL_Ainz" then
        Combat.TickAura(tower, targets, 80, stub, "DryRun")
    end
end

assert(calls >= 24, "Nao executou todos os ataques base / 3 UP")
assert(slows >= 1, "Ainz nao aplicou sua aura de slow no teste")

local fakeOwners = {
    [1] = {Towers = {
        [7] = {Id = "OVL_Shalltear", Position = Vector3.zero, Level = 0, Blood = 0},
    }},
}
Combat.AddBloodOnKill(fakeOwners, Vector3.new(4, 0, 0))
assert(fakeOwners[1].Towers[7].Blood == 1, "Shalltear nao acumulou sangue")
Combat.ResetWave(fakeOwners)
assert(fakeOwners[1].Towers[7].Blood == 0, "Shalltear nao limpou sangue")

local roster = Roster.GetAll()
assert(#roster == 6 and Roster.Get("OVL_Ainz").BannerCandidate == false,
    "Roster ou politica do Ainz alterada")
print("[Anime Fissure] OVERLORD COMBAT SMOKE OK: 6 unidades / " ..
    tostring(calls) .. " acertos simulados / " .. tostring(slows) ..
    " slows / 4 niveis por unidade")
