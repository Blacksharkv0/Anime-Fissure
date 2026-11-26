--!strict
-- ANIME FISSURE | Studio smoke tests: nonstacking Ainz/Albedo pair
-- and info card attack labels for 6 characters at all 4 stages.
local RunService = game:GetService("RunService")
if not RunService:IsStudio() then return end
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Pair = require(Shared:WaitForChild("OverlordPairSynergy"))
local AttackInfo = require(Shared:WaitForChild("TowerAttackInfo"))
local Config = require(Shared:WaitForChild("TowerConfig"))

local owners = {
    [101] = {Towers = {
        [1] = {Id = "OVL_Albedo"},
    }},
    [202] = {Towers = {}},
}
assert(not Pair.HasPair(owners), "Albedo solo must not gain 30%")
assert(Pair.GetMultiplier("OVL_Albedo", false) == 1)
owners[202].Towers[2] = {Id = "OVL_Ainz"}
assert(Pair.HasPair(owners), "Coop ally's Ainz should activate Albedo")
assert(Pair.GetMultiplier("OVL_Albedo", Pair.HasPair(owners)) == 1.30)
assert(Pair.GetMultiplier("OVL_Ainz", true) == 1,
    "Ainz should not receive Albedo's damage boost")
assert(Pair.GetMultiplier("OVL_Brain", true) == 1,
    "Only Albedo gets this pair bonus")
owners[202].Towers[3] = {Id = "OVL_Ainz"}
assert(Pair.HasPair(owners))
assert(Pair.GetMultiplier("OVL_Albedo", true) == 1.30,
    "Two Ainz cannot stack the synergy")
owners[202].Towers[2] = nil
assert(Pair.HasPair(owners), "One remaining Ainz keeps pair active")
owners[202].Towers[3] = nil
assert(not Pair.HasPair(owners), "Selling last Ainz must deactivate pair")
owners[202].Towers[4] = {Id = "OVL_Ainz"}
owners[101].Towers[1] = nil
assert(not Pair.HasPair(owners), "Removing Albedo must deactivate pair")

local stages = 0
for _, id in ipairs({"OVL_Climb", "OVL_Brain", "OVL_Gazef",
    "OVL_Shalltear", "OVL_Albedo", "OVL_Ainz"}) do
    local def = Config.Get(id)
    assert(def and def.MaxUpgrades == 9)
    for stage = 0, 3 do
        local info = AttackInfo.Get(id, stage)
        assert(type(info.Name) == "string" and info.Name ~= "")
        assert(type(info.Type) == "string" and info.Type ~= "")
        assert(Config.GetVisualStage(id, stage * 3) == stage)
        stages += 1
    end
end
local capsuleInfo = AttackInfo.Get("Capsule", 0)
assert(capsuleInfo.Type == "ECONOMIA", "Farm should not display a fake attack")
print("[Anime Fissure] PAIR SYNERGY + INFO SMOKE OK: 30% Albedo only / " ..
    tostring(stages) .. " attack labels / coop, stacking and removal checked")
