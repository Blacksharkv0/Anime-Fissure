--!strict
-- ANIME FISSURE | Overlord rarity balance smoke v1.0
-- Studio-only checks. No battle, wallet, rewards or banner changes.
-- Across the SAME upgrade level 0..9:
--   DAMAGE and RANGE always increase with rarity, and base single-target DPS
--   also rises despite class-specific SPA (e.g. fast Brain).
--   Secret Ainz remains stronger than Albedo EVEN when she has Ainz +30%.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end

local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("Shared")
local Balance=require(Shared:WaitForChild("OverlordBalanceConfig"))
local Config=require(Shared:WaitForChild("TowerConfig"))
local Pair=require(Shared:WaitForChild("OverlordPairSynergy"))
local Roster=require(Shared:WaitForChild("OverlordUnitRoster"))
local Progression=require(Shared:WaitForChild("OverlordModelProgression"))

local rows={
    {Id="OVL_Climb",Rarity="Common",Damage=120,SPA=1.55,Range=20.0},
    {Id="OVL_Brain",Rarity="Rare",Damage=200,SPA=1.30,Range=23.0},
    {Id="OVL_Gazef",Rarity="Epic",Damage=320,SPA=1.72,Range=25.0},
    {Id="OVL_Shalltear",Rarity="Legendary",Damage=480,SPA=1.83,Range=28.0},
    {Id="OVL_Albedo",Rarity="Mythic",Damage=700,SPA=2.10,Range=30.0},
    {Id="OVL_Ainz",Rarity="Secret",Damage=1000,SPA=1.88,Range=36.0},
}

assert(Balance.MaxLevel==9 and #Balance.OrderLowToHigh==6)
assert(Config.StudioOverlordOnly==true)
assert(Config.StartingYen==700,"Starting Yen must remain 700")
assert(Roster.Get("OVL_Ainz").BannerCandidate==false,
    "Secret Ainz remains excluded from the banner")

local verified=0
for _,r in ipairs(rows) do
    local unit=Roster.Get(r.Id)
    local item=Balance.Get(r.Id)
    local level0=Config.GetStats(r.Id,0)
    local level1=Config.GetStats(r.Id,1)
    assert(unit and item and unit.Rarity==r.Rarity
        and item.Rarity==r.Rarity,"Rarity mapping mismatch: "..r.Id)
    assert(level1.Damage==r.Damage and level1.SPA==r.SPA
        and level1.Range==r.Range,"Level1 stats mismatch for "..r.Id)
    assert(level0.Damage<level1.Damage and
        level0.SPA>level1.SPA and level0.Range<level1.Range,
        "First upgrade must improve all stats: "..r.Id)
    assert(Config.Get(r.Id).Damage==level0.Damage
        and Config.Get(r.Id).SPA==level0.SPA
        and Config.Get(r.Id).Range==level0.Range,
        "Definition baseline must mirror balance Lv0: "..r.Id)
    for level=0,9 do
        local stats=Config.GetStats(r.Id,level)
        local reference=Balance.GetStats(r.Id,level)
        assert(stats and reference and
            stats.Damage==reference.Damage and
            stats.SPA==reference.SPA and
            stats.Range==reference.Range,
            "Config diverges from balance at level "..level..": "..r.Id)
        assert(stats.Damage>0 and stats.SPA>0 and stats.Range>0)
        if level>0 then
            local old=Config.GetStats(r.Id,level-1)
            assert(stats.Damage>old.Damage and stats.SPA<old.SPA
                and stats.Range>old.Range,
                "Upgrades must increase damage/range and improve SPA: "..r.Id)
        end
        assert(Config.GetVisualStage(r.Id,level)==math.floor(level/3),
            "Keep base and attack changes at 3/6/9: "..r.Id)
        assert(Progression.Get(r.Id,Config.GetVisualStage(r.Id,level))~=nil)
        verified+=1
    end
end

for level=0,9 do
    local previous: any=nil
    for _,r in ipairs(rows) do
        local current=Config.GetStats(r.Id,level)
        local dps=current.Damage/current.SPA
        if previous then
            assert(current.Damage>previous.Damage,
                "Damage hierarchy broken at Lv"..level..": "..r.Id)
            assert(current.Range>previous.Range,
                "Range hierarchy broken at Lv"..level..": "..r.Id)
            assert(dps>previous.DPS,
                "Base DPS hierarchy broken at Lv"..level..": "..r.Id)
        end
        previous={Damage=current.Damage,Range=current.Range,DPS=dps}
    end

    -- With strongest team aura both Ainz and Albedo receive +12%, which
    -- cancels in the comparison; Albedo alone additionally gets +30% paired.
    local albedo=Config.GetStats("OVL_Albedo",level)
    local ainz=Config.GetStats("OVL_Ainz",level)
    local pair=Pair.GetMultiplier("OVL_Albedo",true)
    assert(pair==1.30 and Pair.GetMultiplier("OVL_Ainz",true)==1)
    assert(ainz.Damage>albedo.Damage*pair,
        "Secret must lead single hit even with Albedo pair Lv"..level)
    assert(ainz.Damage/ainz.SPA > albedo.Damage*pair/albedo.SPA,
        "Secret must lead base DPS even with Albedo pair Lv"..level)
end

assert(Config.GetStats("FissureBlade",0).Damage==40,
    "Legacy tower stats must not change")
assert(Config.GetStats("FissureMage",0).Damage==85,
    "Legacy mage stats must not change")
assert(Config.GetStats("Capsule",0).Damage==0,
    "Capsule must remain a pure farm unit")

print("[Anime Fissure] OVERLORD BALANCE SMOKE OK: " ..
    tostring(verified) .. " levels checked | rarity, DPS, range, SPA, " ..
    "Ainz vs paired Albedo and legacy stats")
