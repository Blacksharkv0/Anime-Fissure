--!strict
-- ANIME FISSURE | Dual-purpose Evolution Rings / Relics v1.0
-- Approved image: purple mage, red steel, cyan clock, emerald compass,
-- and dark crimson-violet chained restriction ring.
-- ONE relic slot per placed Tower in this playtest.
-- The five rings can be equipment OR be retained for Ainz evolution.
-- IMPORTANT: ANY ring on Ainz produces ZERO standard stat bonus.
-- This module never grants, consumes, rolls, or persists an item.

local Rings={}
Rings.Version="1.0.0"
Rings.Status="GameplayRules_StudioEquipOnly"
Rings.SlotsPerTower=1

Rings.Order={"MagicPowerRing","PhysicalDamageRing","SPARing",
    "RangeRing","RestrictionRing"}

Rings.Items={
    MagicPowerRing={
        Id="MagicPowerRing",Name="Anel de Magic Power",
        Description="+20% de dano mágico em unidades de dano mágico",
        Effect="MagicDamage",Value=0.20,
        MainColor=Color3.fromRGB(167,77,255),
        GemColor=Color3.fromRGB(223,155,255),
        MetalColor=Color3.fromRGB(235,194,109),
        Motif="ArcaneRunes",Glyph="✦",
    },
    PhysicalDamageRing={
        Id="PhysicalDamageRing",Name="Anel de dano físico",
        Description="+20% de dano físico em unidades de dano físico",
        Effect="PhysicalDamage",Value=0.20,
        MainColor=Color3.fromRGB(228,57,86),
        GemColor=Color3.fromRGB(255,127,147),
        MetalColor=Color3.fromRGB(152,161,177),
        Motif="BladeFlames",Glyph="⚔",
    },
    SPARing={
        Id="SPARing",Name="Anel de SPA",
        Description="−20% no intervalo entre ataques (mais rápido)",
        Effect="AttackInterval",Value=-0.20,
        MainColor=Color3.fromRGB(48,199,254),
        GemColor=Color3.fromRGB(175,245,255),
        MetalColor=Color3.fromRGB(188,209,223),
        Motif="Clock",Glyph="◷",
    },
    RangeRing={
        Id="RangeRing",Name="Anel de range",
        Description="+20% de alcance",
        Effect="AttackRange",Value=0.20,
        MainColor=Color3.fromRGB(73,240,139),
        GemColor=Color3.fromRGB(194,255,209),
        MetalColor=Color3.fromRGB(191,206,204),
        Motif="CompassSight",Glyph="◎",
    },
    RestrictionRing={
        Id="RestrictionRing",Name="Anel da restrição",
        Description="Dano ×2, porém SPA ×2 (ataca pela metade da frequência)",
        Effect="RestrictionTradeoff",Value=2,
        MainColor=Color3.fromRGB(200,46,110),
        GemColor=Color3.fromRGB(189,122,248),
        MetalColor=Color3.fromRGB(210,167,94),
        Motif="ChainedDoubleCore",Glyph="⛓",
    },
}

function Rings.Get(id: string)
    local info=Rings.Items[id]
    return if info then table.clone(info) else nil
end

function Rings.GetAll(): {any}
    local results={}
    for _,id in ipairs(Rings.Order) do
        table.insert(results,Rings.Get(id))
    end
    return results
end

function Rings.IsRing(id: any): boolean
    return typeof(id)=="string" and Rings.Items[id]~=nil
end

function Rings.IsBonusActive(id: any, unitId: string, element: string): boolean
    if not Rings.IsRing(id) or unitId=="OVL_Ainz" or element=="None" then
        return false
    end
    if id=="MagicPowerRing" then return element=="Magic" end
    if id=="PhysicalDamageRing" then return element=="Physical" end
    return true
end

-- The optional ring is not consumed when equipped; it remains the same
-- owned item (future persisted inventory), usable as evolution material.
-- Statistics are copied; never mutate TowerConfig's shared stat table.
function Rings.ApplyStats(stats: any, unitId: string, element: string, id: any)
    local result=table.clone(stats)
    if not Rings.IsBonusActive(id,unitId,element) or
        typeof(stats.Damage)~="number" or stats.Damage<=0 then
        return result
    end
    if id=="MagicPowerRing" or id=="PhysicalDamageRing" then
        result.Damage=math.floor(result.Damage*1.20+0.5)
    elseif id=="SPARing" then
        result.SPA=math.max(0.22,math.floor(result.SPA*0.80*100+0.5)/100)
    elseif id=="RangeRing" then
        result.Range=math.floor(result.Range*1.20*100+0.5)/100
    elseif id=="RestrictionRing" then
        result.Damage=math.floor(result.Damage*2+0.5)
        result.SPA=math.floor(result.SPA*2*100+0.5)/100
    end
    return result
end

function Rings.GetStatus(id: any,unitId: string,element: string): string
    if not Rings.IsRing(id) then return "Sem relíquia" end
    if unitId=="OVL_Ainz" then
        return "Material da evolução de Ainz • bônus desativado"
    end
    if element=="None" then return "Unidade sem ataque • bônus inativo" end
    if not Rings.IsBonusActive(id,unitId,element) then
        return "Incompatível com o tipo de dano • bônus inativo"
    end
    return Rings.Items[id].Description
end

return Rings
