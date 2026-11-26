--!strict
-- ANIME FISSURE | TowerAttackInfo v1.0
-- Display-only attack metadata for the selected tower panel.
-- Data comes from the existing Overlord progression; types describe
-- the prototype attack, not unimplemented active ultimates.
local Progression = require(script.Parent:WaitForChild("OverlordModelProgression"))
local Info = {}
Info.Version = "1.0.0"

local types = {
    Single = "SINGLE",
    HeavySingle = "SINGLE",
    Combo = "MULTI-HIT",
    EmpoweredCombo = "MULTI-ALVO",
    FastSingle = "SINGLE",
    MultiHit4 = "MULTI-HIT",
    MultiHit6 = "MULTI-HIT",
    Cone = "AOE / CONE",
    PiercingLine = "LINHA",
    AreaMultiHit = "AOE",
    SustainHit = "SINGLE",
    FrenzyCombo = "MULTI-HIT",
    DuplicateAttack = "MULTI-ALVO",
    Cleave = "AOE",
    ShieldPulse = "AOE",
    SupportBurst = "AOE / BUFF",
    MagicSingle = "SINGLE",
    SpatialSlash = "SINGLE",
    ExecuteSpell = "SINGLE / EXEC",
    BigMagicArea = "AOE",
}

local other = {
    FissureBlade = {Name = "Golpe da Fissura", Type = "SINGLE"},
    FissureMage = {Name = "Projeção Arcana", Type = "SINGLE"},
    Capsule = {Name = "Produção de Yen", Type = "ECONOMIA"},
}

function Info.Get(id: string, stage: number): {Name: string, Type: string}
    local entry = Progression.Get(id, math.clamp(stage, 0, 3))
    if entry then
        return {
            Name = entry.Name,
            Type = types[entry.Pattern] or "SINGLE",
        }
    end
    local fallback = other[id]
    return if fallback then table.clone(fallback)
        else {Name = "Ataque básico", Type = "SINGLE"}
end

return Info
