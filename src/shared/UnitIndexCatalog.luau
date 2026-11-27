--!strict
-- ANIME FISSURE | DANTE: index de unidades de todos os universos
-- Fonte: OverlordUnitRoster + CapsuleUnitConfig, SEM inventar propriedade,
-- pity, summon liberado, banners, drops ou progresso de colecao.
local Overlord=require(script.Parent:WaitForChild("OverlordUnitRoster"))
local Capsule=require(script.Parent:WaitForChild("CapsuleUnitConfig"))
local Catalog={}
Catalog.Version="1.0.0"
Catalog.OwnerNPC="Dante"
Catalog.Scope="AllWorlds"
Catalog.CollectionConnected=false
Catalog.BetaStatus="IndexOnly"
Catalog.Entries={}
Catalog.ById={}
Catalog.Worlds={"Overlord","Dragon Ball"}

local function add(data: any)
    assert(typeof(data.Id)=="string" and not Catalog.ById[data.Id],
        "UnitIndex: ID duplicado ou invalido")
    Catalog.ById[data.Id]=data
    table.insert(Catalog.Entries,data)
end

for _,unit in ipairs(Overlord.GetAll()) do
    add({
        Id=unit.Id,Name=unit.FullName,ShortName=unit.Name,
        World="Overlord",Rarity=unit.Rarity,
        ObtainMethod=if unit.Id=="OVL_Ainz"
            then "Fase especial (método exato a definir)"
            else "Banner planejado",
        Status="Planejada",
        IsBannerActive=false,IsOwned=nil,IsDiscovered=nil,
        HasPlayableDataInStudio=true,
        Description=if unit.Id=="OVL_Ainz"
            then "Secreto do mundo Overlord; não pertence ao banner."
            else "Personagem aprovado para o mundo Overlord; não habilitado no banner atual.",
    })
end

for _,id in ipairs({Capsule.LegendaryId,Capsule.MythicId}) do
    local unit=Capsule.Get(id)
    assert(unit,"UnitIndex: Capsule faltando "..id)
    add({
        Id=id,Name=unit.DisplayName,ShortName=unit.DisplayName,
        World="Dragon Ball",Rarity=unit.Rarity,
        ObtainMethod=if unit.ObtainMethod=="EvolutionOnly"
            then "Apenas evolução da Capsule lendária"
            else "Banner beta de Capsule (teste)",
        Status=if id==Capsule.LegendaryId then "Beta de Summon"
            else "Evolução planejada",
        IsBannerActive=unit.BannerEligible==true and id==Capsule.LegendaryId,
        IsOwned=nil,IsDiscovered=nil,
        HasPlayableDataInStudio=false,
        Description=if id==Capsule.MythicId
            then "Forma evoluída exclusiva: não aparece no Summon."
            else "Unidade econômica; o banner atual ainda é um protótipo.",
    })
end

function Catalog.Get(id: string)
    local info=Catalog.ById[id]
    return if info then table.clone(info) else nil
end

function Catalog.GetAll(): {any}
    local result={}
    for _,entry in ipairs(Catalog.Entries) do
        table.insert(result,table.clone(entry))
    end
    return result
end

function Catalog.GetWorld(world: string): {any}
    if world=="Todos" then return Catalog.GetAll() end
    local entries={}
    for _,info in ipairs(Catalog.Entries) do
        if info.World==world then table.insert(entries,table.clone(info)) end
    end
    return entries
end

function Catalog.GetOwnershipState(_player: Player?,_unitId: string): string
    -- NÃO dizer "não obtido": não existe coleção persistente integrada.
    return "Inventário não conectado"
end

return Catalog
