--!strict
-- ANIME FISSURE | Five 3D ring relics and actual stat math - Studio smoke
-- Tests pure server-side balance, Ainz evolution-only exception and visuals.
-- Never grants owned items, modifies currency or persists an inventory.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("Shared")
local Rings=require(Shared:WaitForChild("RelicRingConfig"))
local Loot=require(Shared:WaitForChild("OverlordEvolutionLootConfig"))
local Builder=require(Shared:WaitForChild("RelicRingModelBuilder"))
local Config=require(Shared:WaitForChild("TowerConfig"))

local stats={Damage=1000,SPA=2.0,Range=30.0,Income=0}
local function get(id: string,unitId: string,element: string)
    return Rings.ApplyStats(stats,unitId,element,id)
end

assert(#Rings.Order==5 and Rings.SlotsPerTower==1)
assert(get("MagicPowerRing","FissureMage","Magic").Damage==1200)
assert(get("MagicPowerRing","OVL_Albedo","Physical").Damage==1000)
assert(get("PhysicalDamageRing","OVL_Albedo","Physical").Damage==1200)
assert(get("PhysicalDamageRing","FissureMage","Magic").Damage==1000)
assert(get("SPARing","OVL_Climb","Physical").SPA==1.60)
assert(get("RangeRing","OVL_Brain","Physical").Range==36)
local restriction=get("RestrictionRing","OVL_Gazef","Physical")
assert(restriction.Damage==2000 and restriction.SPA==4.0)
assert(restriction.Damage/restriction.SPA==stats.Damage/stats.SPA,
    "Restriction should trade attack frequency for hit size, not add base DPS")
assert(get("RestrictionRing","OVL_Gazef","Physical").Range==stats.Range)

for _,id in ipairs(Rings.Order) do
    assert(Rings.IsRing(id),"Missing ring "..id)
    local info=Rings.Get(id)
    local catalog=Loot.GetItem(id)
    assert(info and catalog and catalog.Type=="EvolutionRelic" and
        catalog.Equippable and catalog.Relic,
        "Ring must be equip-capable AND an evolution material: "..id)
    assert(catalog.EvolutionLink=="OVL_Ainz",
        "Rings must be retainable for Ainz's evolution")
    assert(Loot.IsDropEnabled(id,catalog.StageId,"Hard")==false,
        "Do not enable loot without approved chance and inventory")
    local model=Builder.Build(id)
    assert(model and model.PrimaryPart and model:GetAttribute("DualUse")==true,
        "Ring 3D model missing: "..id)
    local count=0
    for _,obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart") then
            count+=1
            assert(obj.Anchored and not obj.CanCollide and not obj.CanQuery,
                "Ring previews must have no game physics: "..obj.Name)
        end
    end
    assert(count>=45,"Ring model needs faceted shank and detailed gem: "..id)
    model:Destroy()

    -- ALL five rings lose ALL ordinary bonuses when worn by Ainz.
    local ainz=Rings.ApplyStats(stats,"OVL_Ainz","Magic",id)
    assert(ainz.Damage==1000 and ainz.SPA==2 and ainz.Range==30,
        "Ainz must receive no standard relic bonus: "..id)
    assert(Rings.IsBonusActive(id,"OVL_Ainz","Magic")==false)
end

local base=Config.GetStats("OVL_Albedo",1)
local albedo=Rings.ApplyStats(base,"OVL_Albedo",
    Config.Get("OVL_Albedo").Element,"PhysicalDamageRing")
assert(base.Damage==700 and albedo.Damage==840)
assert(Rings.GetStatus("MagicPowerRing","OVL_Ainz","Magic"):find("evolução")~=nil)
assert(Rings.GetStatus("MagicPowerRing","OVL_Albedo","Physical"):find("Incompatível")~=nil)
assert(Loot.GetItem("ShalltearEvolutionItem").Relic~=true)
assert(Loot.GetItem("AlbedoEvolutionItem").Relic~=true)

print("[Anime Fissure] RELIC RINGS STUDIO OK: five dual-use ring models, " ..
    "all stat modifiers, physical/magic gating and Ainz suppression")
