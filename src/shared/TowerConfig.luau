--!strict
-- ANIME FISSURE | TowerConfig v1.1 BETA
-- 2 unidades originais de TESTE (nao entram no Summon) e Capsule do banner.
-- Nenhum slot ou inventario final e desbloqueado por este modulo.
-- O config canonico da Capsule controla custo, upgrade e renda.

local Capsule = require(script.Parent:WaitForChild("CapsuleUnitConfig"))
local GameConfig = require(script.Parent:WaitForChild("GameConfig"))

local Config = {}
Config.Version = "1.1.0"
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

-- Slots livres da beta (o deck configuravel com 6 e objeto de outra etapa).
Config.StarterDeck = {"FissureBlade", "FissureMage", "Capsule"}

function Config.Get(id: any)
    if typeof(id) ~= "string" then return nil end
    return Config.Units[id]
end

function Config.GetCost(id: string, upgrade: number): number?
    local def = Config.Get(id)
    if not def or typeof(upgrade) ~= "number" or upgrade % 1 ~= 0
        or upgrade < 1 or upgrade > def.MaxUpgrades then return nil end
    if id == "Capsule" then return Capsule.GetUpgradePrice("Capsule", upgrade) end
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
        Damage = math.floor(def.Damage * (1 + 0.50 * level) + 0.5),
        Range = def.Range + 1.8 * level,
        SPA = math.max(0.22, def.SPA * (1 - 0.07 * level)),
        Income = 0,
    }
end

function Config.GetPublicDeck(hasCapsule: boolean)
    local deck = {}
    for index, id in ipairs(Config.StarterDeck) do
        local def = Config.Get(id)
        table.insert(deck, {
            Slot = index, UnitId = id, Name = def.Name,
            Role = def.Role, Element = def.Element,
            PlacementCost = def.PlacementCost,
            MaxPlacements = def.MaxPlacements,
            Temporary = def.Temporary,
            Available = id ~= "Capsule" or hasCapsule,
            Reason = if id == "Capsule" and not hasCapsule
                then "Obtenha Capsule no Summon do Virgil"
                else (if def.Temporary then "Unidade provisoria da beta" else ""),
        })
    end
    return deck
end

return Config
