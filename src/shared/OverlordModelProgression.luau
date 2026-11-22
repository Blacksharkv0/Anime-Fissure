--!strict
-- ANIME FISSURE | OverlordModelProgression v0.1
-- Tres mudancas de APARENCIA e padrao de ataque por personagem,
-- distribuidas por upgrades FUTUROS (marcos numericos ainda pendentes).
-- Model stage 0 = base; 1,2,3 = tres mudancas visuais.
-- NAO aplica dano, skills, summoning nem desbloqueio.

local Roster = require(script.Parent:WaitForChild("OverlordUnitRoster"))
local Abilities = require(script.Parent:WaitForChild("OverlordAbilityDesign"))
local Progression = {}

Progression.Version = "0.1.0"
Progression.Status = "VisualPreview"
Progression.MaxVisualStage = 3

Progression.Stages = {
    OVL_Climb = {
        {Name = "Corte de Espada", Pattern = "Single", Visual = "Armadura clara e espada"},
        {Name = "High Vertical Strike", Pattern = "HeavySingle", Visual = "Lamina azulada"},
        {Name = "Postura de Fortaleza", Pattern = "Combo", Visual = "Arcos dourados"},
        {Name = "Limit Breaker: Mind", Pattern = "EmpoweredCombo", Visual = "Aura de superacao"},
    },
    OVL_Brain = {
        {Name = "Katana Precisa", Pattern = "Single", Visual = "Katana e manto escuro"},
        {Name = "God Flash", Pattern = "FastSingle", Visual = "Fio de katana brilhante"},
        {Name = "Nail Clipper", Pattern = "MultiHit4", Visual = "Quatro cortes cruzados"},
        {Name = "True Nail Clipper", Pattern = "MultiHit6", Visual = "Seis cortes cintilantes"},
    },
    OVL_Gazef = {
        {Name = "Espada do Guerreiro", Pattern = "Single", Visual = "Armadura escarlate"},
        {Name = "Fourfold Slash", Pattern = "Cone", Visual = "Quatro arcos de espada"},
        {Name = "Razor Edge", Pattern = "PiercingLine", Visual = "Lamina de aura"},
        {Name = "Sixfold Slash", Pattern = "AreaMultiHit", Visual = "Seis cortes radiantes"},
    },
    OVL_Shalltear = {
        {Name = "Lanca Vampirica", Pattern = "Single", Visual = "Vestido gotico e lanca"},
        {Name = "Spuit Lance", Pattern = "SustainHit", Visual = "Lanca em rubi"},
        {Name = "Blood Frenzy", Pattern = "FrenzyCombo", Visual = "Protecoes escarlates"},
        {Name = "Einherjar", Pattern = "DuplicateAttack", Visual = "Sombra branca de batalha"},
    },
    OVL_Albedo = {
        {Name = "Guarda do Guardiao", Pattern = "Single", Visual = "Vestido branco e asas negras"},
        {Name = "Asas da Protecao", Pattern = "Cleave", Visual = "Penas energizadas"},
        {Name = "Hermes Trismegistus", Pattern = "ShieldPulse", Visual = "Placas negras e escudo"},
        {Name = "Comando Supremo", Pattern = "SupportBurst", Visual = "Halo dourado de comando"},
    },
    OVL_Ainz = {
        {Name = "Projeção Arcana", Pattern = "MagicSingle", Visual = "Manto de soberano"},
        {Name = "Reality Slash", Pattern = "SpatialSlash", Visual = "Fenda dimensional"},
        {Name = "Grasp Heart", Pattern = "ExecuteSpell", Visual = "Coracao espectral"},
        {Name = "Fallen Down", Pattern = "BigMagicArea", Visual = "Coroa de magia superior"},
    },
}

function Progression.Get(id: string, visualStage: number)
    if typeof(visualStage) ~= "number" or visualStage % 1 ~= 0
        or visualStage < 0 or visualStage > 3 then return nil end
    local stages = Progression.Stages[id]
    if not stages then return nil end
    local stage = stages[visualStage + 1]
    if not stage then return nil end
    return table.clone(stage)
end

function Progression.GetAll(id: string)
    local result = {}
    for index = 0, 3 do
        local stage = Progression.Get(id, index)
        if stage then table.insert(result, stage) end
    end
    return result
end

for _, item in ipairs(Roster.GetAll()) do
    local stages = Progression.Stages[item.Id]
    assert(stages and #stages == 4, "A unidade precisa de base + 3 mudancas: " .. item.Id)
    local design = Abilities.Get(item.Id)
    assert(design and design.Passive, "Passiva obrigatoria ate para comuns: " .. item.Id)
end

return Progression
