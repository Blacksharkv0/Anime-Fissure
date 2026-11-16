--!strict
-- ANIME FISSURE | CapsuleAccessService v0.1
-- Politica de origem da Capsule, para integrar ao FUTURO Summon/Evolve do servidor.
-- Nao e um sorteador, nao concede unidades e nao salva inventario sozinho.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("CapsuleUnitConfig"))

local Service = {}

function Service.CanGrantFromBanner(unitId: string): boolean
    return Config.CanAppearInBanner(unitId)
end

function Service.FilterBannerPool(pool: {any}): {any}
    local safe = {}
    for _, entry in ipairs(pool) do
        if typeof(entry) == "table" and typeof(entry.Id) == "string" then
            if entry.Id ~= Config.MythicId then
                -- Outras familias nao sao gerenciadas por este modulo.
                table.insert(safe, table.clone(entry))
            end
        end
    end
    return safe
end

function Service.BuildEvolutionResult(unitId: string, isShiny: boolean)
    return Config.GetEvolutionResult(unitId, isShiny)
end

function Service.CanGrantCapsule(unitId: string, source: string): boolean
    -- Negar origens alternativas, inclusive recompensas/eventos ou comandos.
    if unitId == "CapsuleCorp" then
        return source == "Evolution"
    end
    if unitId == "Capsule" then
        return source == "Summon"
    end
    return false
end

return Service
