--!strict
-- ANIME FISSURE | TowerConfig v1.1 BETA
-- Beta normal preservada; Overlord ativado APENAS no Studio para playtest.
-- 6 personagens com passiva e 3 marcos de ataque (up 3,6,9) em teste.
-- Nenhum slot ou inventario final e desbloqueado por este modulo.
-- O config canonico da Capsule controla custo, upgrade e renda.

local Capsule = require(script.Parent:WaitForChild("CapsuleUnitConfig"))
local GameConfig = require(script.Parent:WaitForChild("GameConfig"))
local RunService = game:GetService("RunService")
local OverlordRoster = require(script.Parent:WaitForChild("OverlordUnitRoster"))
local Progression = require(script.Parent:WaitForChild("OverlordModelProgression"))

local Config = {}
Config.Version = "1.2.0"
Config.StudioOverlordOnly = true
Config.StudioLabYen = 18000
Config.AttackUpgradeMilestones = {3, 6, 9}
Config.MaxDeckSlots = GameConfig.DeckSlots
Config.StartingYen = GameConfig.StartingYen

Config.Units = {
    FissureBlade = {
        Id = "FissureBlade",
        Name = "Espadachim da Fissura",
        Role = "Damage",
        Element = "Physical",
        Rarity = "Beta",
        Temporary = true,
        PlacementCost = 220,
        Damage = 40,
        SPA = 0.90,
        Range = 23,
        MaxUpgrades = 3,
        MaxPlacements = 4,
        Color = Color3.fromRGB(57, 152, 239),
        AttackColor = Color3.fromRGB(91, 216, 255),
    },
    FissureMage = {
        Id = "FissureMage",
        Name = "Arcanista da Fissura",
        Role = "Damage",
        Element = "Magic",
        Rarity = "Beta",
        Temporary = true,
        PlacementCost = 320,
        Damage = 85,
        SPA = 1.8,
        Range = 29,
        MaxUpgrades = 3,
        MaxPlacements = 3,
        Color = Color3.fromRGB(130, 78, 197),
        AttackColor = Color3.fromRGB(216, 152, 250),
    },
    Capsule = {
        Id = "Capsule",
        Name = "Capsule",
        Role = "Farm",
        Element = "None",
        Rarity = "Legendary",
        Temporary = false,
        PlacementCost = Capsule.GetPlacementCost("Capsule", false),
        Damage = 0,
        SPA = 0,
        Range = 0,
        MaxUpgrades = Capsule.Get("Capsule").MaxUpgrades,
        MaxPlacements = Capsule.Get("Capsule").MaxPlacements,
        Color = Color3.fromRGB(71, 205, 228),
        AttackColor = Color3.fromRGB(255, 220, 116),
    },
}

-- Numeros TEMPORARIOS para testar ataque, passivas, upgrade e VFX no Studio.
-- Nao sao o balanceamento final do banner ou da Legend Stage.
local prototypes = {
    OVL_Climb = {Cost=180, Damage=30, SPA=0.93, Range=20, Limit=4,
        Color=Color3.fromRGB(217, 222, 239), FX=Color3.fromRGB(113, 203, 255)},
    OVL_Brain = {Cost=270, Damage=55, SPA=1.15, Range=22, Limit=3,
        Color=Color3.fromRGB(42, 56, 87), FX=Color3.fromRGB(187, 231, 255)},
    OVL_Gazef = {Cost=390, Damage=95, SPA=1.50, Range=24, Limit=3,
        Color=Color3.fromRGB(170, 65, 75), FX=Color3.fromRGB(255, 190, 94)},
    OVL_Shalltear = {Cost=620, Damage=133, SPA=1.44, Range=26, Limit=2,
        Color=Color3.fromRGB(164, 49, 87), FX=Color3.fromRGB(247, 70, 113)},
    OVL_Albedo = {Cost=750, Damage=91, SPA=1.62, Range=27, Limit=1,
        Color=Color3.fromRGB(217, 222, 235), FX=Color3.fromRGB(245, 204, 119)},
    OVL_Ainz = {Cost=1150, Damage=245, SPA=2.35, Range=35, Limit=1,
        Color=Color3.fromRGB(86, 49, 143), FX=Color3.fromRGB(191, 106, 250)},
}
local studioRoster = {"OVL_Climb", "OVL_Brain", "OVL_Gazef",
    "OVL_Shalltear", "OVL_Albedo", "OVL_Ainz"}

-- Server-side TowerService tambem checa IsStudio: nunca liberar por
-- uma simples string enviada no RemoteEvent de posicionamento.
for _, id in ipairs(studioRoster) do
    local rarity = OverlordRoster.Get(id)
    local beta = prototypes[id]
    assert(rarity and Progression.Get(id, 3), "Overlord cadastro incompleto: " .. id)
    Config.Units[id] = {
        Id = id, Name = rarity.FullName, Rarity = rarity.Rarity,
        Role = if id == "OVL_Albedo" then "Support" else "Damage",
        Element = if id == "OVL_Ainz" then "Magic" else "Physical",
        Temporary = true, StudioOnly = true, Passive = true,
        PlacementCost = beta.Cost, Damage = beta.Damage,
        SPA = beta.SPA, Range = beta.Range,
        MaxUpgrades = 9, MaxPlacements = beta.Limit,
        Color = beta.Color, AttackColor = beta.FX,
        TargetAir = id == "OVL_Ainz" or id == "OVL_Albedo"
            or id == "OVL_Shalltear",
    }
end

-- Slots livres da beta (o deck configuravel com 6 e objeto de outra etapa).
Config.StarterDeck = {"FissureBlade", "FissureMage", "Capsule"}
Config.StudioOverlordDeck = studioRoster

function Config.IsOverlord(id: any): boolean
    return typeof(id) == "string" and prototypes[id] ~= nil
end

function Config.GetVisualStage(id: string, level: number): number
    if not Config.IsOverlord(id) then return 0 end
    return math.clamp(math.floor(level / 3), 0, 3)
end

function Config.Get(id: any)
    if typeof(id) ~= "string" then return nil end
    return Config.Units[id]
end

function Config.GetCost(id: string, upgrade: number): number?
    local def = Config.Get(id)
    if not def or typeof(upgrade) ~= "number" or upgrade % 1 ~= 0
        or upgrade < 1 or upgrade > def.MaxUpgrades then return nil end
    if id == "Capsule" then return Capsule.GetUpgradePrice("Capsule", upgrade) end
    if Config.IsOverlord(id) then
        return math.floor(def.PlacementCost * (0.38 + 0.22 * upgrade) + 0.5)
    end
    return math.floor(def.PlacementCost * (0.65 + upgrade * 0.4) + 0.5)
end

function Config.GetStats(id: string, level: number)
    local def = Config.Get(id)
    if not def or typeof(level) ~= "number" or level % 1 ~= 0
        or level < 0 or level > def.MaxUpgrades then return nil end
    if id == "Capsule" then
        return {
            Damage = 0,
            Range = 0,
            SPA = 0,
            Income = Capsule.GetIncomePerWave("Capsule", level, false),
        }
    end
    return {
        Damage = math.floor(def.Damage * (1 + (if Config.IsOverlord(id) then 0.24 else 0.50) * level) + 0.5),
        Range = def.Range + (if Config.IsOverlord(id) then 0.9 else 1.8) * level,
        SPA = math.max(0.33, def.SPA * (1 - (if Config.IsOverlord(id) then 0.035 else 0.07) * level)),
        Income = 0,
    }
end

function Config.GetPublicDeck(hasCapsule: boolean, mode: string?)
    local deck = {}
    local choices = if RunService:IsStudio() and mode == "Overlord"
        then Config.StudioOverlordDeck else Config.StarterDeck
    for index, id in ipairs(choices) do
        local def = Config.Get(id)
        table.insert(deck, {
            Slot = index, UnitId = id, Name = def.Name,
            Role = def.Role, Element = def.Element,
            PlacementCost = def.PlacementCost,
            MaxPlacements = def.MaxPlacements,
            Temporary = def.Temporary, StudioOnly = def.StudioOnly == true,
            Available = id ~= "Capsule" or hasCapsule,
            Reason = if id == "Capsule" and not hasCapsule
                then "Obtenha Capsule no Summon do Virgil"
                else (if def.StudioOnly then "LABORATORIO STUDIO: sem liberar no banner"
                  else (if def.Temporary then "Unidade provisoria da beta" else "")),
        })
    end
    return deck
end

return Config
