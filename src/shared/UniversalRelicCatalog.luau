--!strict
-- ANIME FISSURE | Gilgamesh universal relic catalog v1.0
-- ONE central source to browse relics across ALL anime worlds.
-- Approved live-design rings are listed first. Earlier demo relic concepts
-- remain explicitly ARCHIVED, not Stage drops, not craft recipes.
-- This module is DATA only; neither ownership nor delivery is inferred.
local Rings=require(script.Parent:WaitForChild("RelicRingConfig"))
local Legacy=require(script.Parent:WaitForChild("RelicIndexConfig"))
local Catalog={}
Catalog.Version="1.0.0"
Catalog.OwnerNPC="Gilgamesh"
Catalog.Scope="AllWorlds"
Catalog.Status="CatalogOnly_NoInventory"
Catalog.Entries={}
Catalog.ById={}

local origin={
    MagicPowerRing={"Overlord","OVL_01","Carne Village • Hard"},
    SPARing={"Overlord","OVL_02","Cemitério de E-Rantel"},
    PhysicalDamageRing={"Overlord","OVL_03","O Rei da Floresta"},
    RangeRing={"Overlord","OVL_05","Guerra dos Homens-Lagarto"},
    RestrictionRing={"Overlord","OVL_06","Trono de Nazarick"},
}

local function add(entry: any)
    assert(not Catalog.ById[entry.Id],"Relic ID duplicado "..tostring(entry.Id))
    Catalog.ById[entry.Id]=entry
    table.insert(Catalog.Entries,entry)
end
for _,ring in ipairs(Rings.GetAll()) do
    local place=origin[ring.Id]
    add({
        Id=ring.Id,Name=ring.Name,World=place[1],StageId=place[2],
        Origin=place[3],Category="EvolutionRelic",
        Type="Anel / Relíquia / Material de Evolução",
        Description=ring.Description,Target=if ring.Effect=="MagicDamage"
            then "Unidades mágicas" elseif ring.Effect=="PhysicalDamage"
            then "Unidades físicas" else "Unidades ofensivas",
        Status="Approved_Prototype",VisualId=ring.Id,
        Accent=ring.MainColor,Detail="Efeito comum inativo no Ainz",
        IsRealDrop=false,IsOwned=nil,IsEquipped=nil,
    })
end

-- Older Edward demo catalog contains ideas never adopted as final drops.
-- Keep as an archived concept drawer for future cross-world design work,
-- deliberately not claiming their old StageIDs as drop locations.
for _,concept in ipairs(Legacy.GetAll()) do
    add({
        Id=concept.Id,Name=concept.Name,World=concept.World,
        StageId=nil,Origin="Conceito antigo • sem mapa confirmado",
        Category="LegacyConcept",Type="Projeto de relíquia",
        Description=concept.Buff,Target=concept.Target,
        Status="Archived_NotApproved",VisualId=nil,
        Accent=Color3.fromRGB(150,157,177),
        Detail="Conceito arquivado • efeitos ainda NÃO aprovados",
        IsRealDrop=false,IsOwned=nil,IsEquipped=nil,
    })
end

function Catalog.Get(id: string)
    local entry=Catalog.ById[id]
    return if entry then table.clone(entry) else nil
end
function Catalog.GetAll(): {any}
    local result={}
    for _,entry in ipairs(Catalog.Entries) do
        table.insert(result,table.clone(entry))
    end
    return result
end
function Catalog.GetByCategory(category: string): {any}
    local result={}
    for _,entry in ipairs(Catalog.Entries) do
        if entry.Category==category then table.insert(result,table.clone(entry)) end
    end
    return result
end
function Catalog.IsOwned(_player: Player?,_id: string): boolean
    -- Do not make up player-owned relics while the persistent backend is absent.
    return false
end
return Catalog
