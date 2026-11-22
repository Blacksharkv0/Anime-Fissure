--!strict
-- ANIME FISSURE | OverlordAbilityDesign v0.1
-- RESEARCH-BACKED DESIGN DRAFT, not executable combat logic.
-- Lore anchors are from Overlord. Values/mechanics are ORIGINAL TD ADAPTATIONS.
-- None of these spells, passives or units is live in TowerService or Summon.
-- Review with game creator before enabling balance or effects.

local Roster = require(script.Parent:WaitForChild("OverlordUnitRoster"))
local Design = {}

Design.Version = "0.1.0"
Design.World = "Overlord"
Design.Status = "DesignDraft"
Design.EnabledInCombat = false
Design.NumbersAreProposals = true
Design.Roster = Roster.Version

-- Suggested numbers MUST NOT be treated as final or hard-coded into gameplay.
-- Multiplier: 1.0 = 100% of unit's current AttackDamage.
-- "critChancePP" = additive percentage points, not multiplicative.
Design.Units = {
    OVL_Climb = {
        Id = "OVL_Climb",
        Rarity = "Common",
        RoleProposal = "GroundSingleTarget",
        DamageType = "Physical",
        PrimaryIdentity = "Determination and temporary limit-breaking, not raw power",
        Passive = {
            Id = "UnyieldingGuard",
            Name = "Determinacao do Guarda",
            CanonBasis = "Climb is loyal, relentlessly trains, and pushes his limits",
            Effect = "Enemies in final 25% of path grant Climb temporary attack speed",
            Suggested = {PathThreshold = 0.75, AttackSpeedBonus = 0.12, Duration = 5, InternalCooldown = 20},
        },
        Skills = {
            {
                Id = "HighVerticalStrike",
                Name = "High Vertical Strike",
                Class = "TriggeredAttack",
                CanonBasis = "Climb learned and employs High Vertical Strike",
                Effect = "Every fifth attack delivers a concentrated vertical strike to one target",
                Suggested = {EveryAttacks = 5, DamageMultiplier = 1.8},
                VFX = "Short gold arc; one hit",
            },
            {
                Id = "Fortress",
                Name = "Fortress",
                Class = "PassiveTechnique",
                CanonBasis = "Fortress is a defensive martial art used by Climb",
                Effect = "Briefly resists one disable affecting himself, not the base",
                Suggested = {BuffDuration = 4, Cooldown = 26},
                VFX = "Short silver shield glint",
            },
            {
                Id = "LimitBreakerMind",
                Name = "Limit Breaker: Mind",
                Class = "Active",
                CanonBasis = "Climb bypasses the brain's physical limits temporarily at a cost",
                Effect = "Temporary damage and speed boost, followed by exhaustion",
                Suggested = {Cooldown = 45, Duration = 7, DamageBonus = 0.30,
                    AttackSpeedBonus = 0.20, FatigueDuration = 4, FatigueSpeedPenalty = 0.14},
                VFX = "Golden white aura; glow fades into fatigue",
            },
        },
        BossRule = "No instant kill; defensive technique does not cancel boss leaking",
        RequiredSystems = {"AttackCounters", "StatusBuffs", "ActivatedSkills", "PathProgress"},
    },

    OVL_Brain = {
        Id = "OVL_Brain",
        Rarity = "Rare",
        RoleProposal = "GroundCriticalSingleTarget",
        DamageType = "Physical",
        PrimaryIdentity = "Precision fencing focused on one target",
        Passive = {
            Id = "Field",
            Name = "Field - Dominio de Percepcao",
            CanonBasis = "Brain's custom Field senses and predicts opponents within his field",
            Effect = "Increases critical chance and precision against his selected target",
            Suggested = {CritChancePP = 0.10, PrecisionBonus = 0.15},
        },
        Skills = {
            {
                Id = "GodFlash",
                Name = "God Flash",
                Class = "TriggeredAttack",
                CanonBasis = "Brain's extremely fast personal sword technique",
                Effect = "Quick high-precision strike; does not bypass invulnerability",
                Suggested = {EveryAttacks = 5, DamageMultiplier = 2.0, ExtraCritChancePP = 0.12},
                VFX = "Single thin white flash",
            },
            {
                Id = "NailClipper",
                Name = "Nail Clipper",
                Class = "TriggeredAttack",
                CanonBasis = "Fourfold Slash of Light + Field + God Flash, combined for precise damage",
                Effect = "Four successive hits focused on the same enemy",
                Suggested = {Cooldown = 19, Hits = 4, MultiplierPerHit = 0.65},
                VFX = "Four intersecting silver slashes",
            },
            {
                Id = "TrueNailClipper",
                Name = "True Nail Clipper",
                Class = "ActiveUltimate",
                CanonBasis = "Later-light-novel culmination using Sixfold Slash of Light",
                Effect = "Six rapid hits concentrated on a single target; heavy cooldown",
                Suggested = {Cooldown = 57, Hits = 6, MultiplierPerHit = 0.62,
                    BossDamageMultiplier = 1.0},
                VFX = "Six near-instant pale blue slashes",
                Spoiler = "Late light-novel ability; reveal/upgrade should be optional",
            },
        },
        BossRule = "No death execution; crit, armor and immunity rules remain active",
        RequiredSystems = {"CriticalHits", "TriggeredMultiHit", "ActivatedSkills", "TargetLock"},
    },

    OVL_Gazef = {
        Id = "OVL_Gazef",
        Rarity = "Epic",
        RoleProposal = "GroundAreaPhysicalAntiArmor",
        DamageType = "Physical",
        PrimaryIdentity = "Veteran warrior who sweeps groups and pierces armor",
        Passive = {
            Id = "FocusBattleAura",
            Name = "Focus Battle Aura",
            CanonBasis = "Gazef channels fighting spirit into his weapon against supernatural defenses",
            Effect = "Attacks ignore a portion of physical resistance, especially armored/angel targets",
            Suggested = {ResistancePenetration = 0.15},
        },
        Skills = {
            {
                Id = "FourfoldSlash",
                Name = "Fourfold Slash of Light",
                Class = "TriggeredAttack",
                CanonBasis = "Four strikes released through a single sword swing",
                Effect = "Four directional slashes through enemies in a narrow cone",
                Suggested = {EveryAttacks = 5, Hits = 4, MultiplierPerHit = 0.45,
                    ConeAngleDegrees = 45},
                VFX = "Four golden sword crescents",
            },
            {
                Id = "RazorEdge",
                Name = "Razor Edge",
                Class = "Active",
                CanonBasis = "Gazef's signature enchanted sword",
                Effect = "Strong piercing line strike; shield damage still resolves before HP",
                Suggested = {Cooldown = 24, DamageMultiplier = 2.2, LineWidth = 5,
                    ExtraResistPenetration = 0.10},
                VFX = "Thin long cyan sword trail",
            },
            {
                Id = "SixfoldSlashOfLight",
                Name = "Sixfold Slash of Light",
                Class = "ActiveUltimate",
                CanonBasis = "Gazef's demanding sixfold group-combat martial art",
                Effect = "Six separate slashes distributed across a group, not necessarily one enemy",
                Suggested = {Cooldown = 49, Hits = 6, MultiplierPerHit = 0.72,
                    Radius = 12},
                VFX = "Six outward radiant arcs",
            },
        },
        BossRule = "Penetration applies to resistance, not boss phase shields or immunity",
        RequiredSystems = {"AOE", "ConeAttacks", "MultiHit", "ResistancePenetration"},
    },

    OVL_Shalltear = {
        Id = "OVL_Shalltear",
        Rarity = "Legendary",
        RoleProposal = "GroundHybridSustainedDPS",
        DamageType = "Physical",
        PrimaryIdentity = "Vampiric lance and a temporary combat double",
        Passive = {
            Id = "BloodPool",
            Name = "Blood Pool",
            CanonBasis = "Shalltear accumulates blood, which can provoke Blood Frenzy",
            Effect = "Earns Blood charges through kills in range; each charge empowers lance damage",
            Suggested = {ChargesPerKill = 1, MaxCharges = 5,
                DamageBonusPerCharge = 0.04, ResetAtWaveEnd = true},
        },
        Skills = {
            {
                Id = "SpuitLance",
                Name = "Spuit Lance",
                Class = "TriggeredAttack",
                CanonBasis = "Divine class lance steals health on strikes",
                Effect = "Every fourth strike converts damage into one Blood charge (no HP to heal on towers)",
                Suggested = {EveryAttacks = 4, Multiplier = 1.4, ExtraCharges = 1},
                VFX = "Crimson lance trail and absorbed red particles",
            },
            {
                Id = "BloodFrenzy",
                Name = "Blood Frenzy",
                Class = "Active",
                CanonBasis = "Bloodlust increases aggression but sacrifices self-control",
                Effect = "Consumes Blood charges for speed burst, reducing attack range temporarily",
                Suggested = {RequiredCharges = 5, Duration = 9, Cooldown = 42,
                    AttackSpeedBonus = 0.45, RangePenalty = 0.12},
                VFX = "Red aura, eyes glow, temporary armored fighting silhouette",
            },
            {
                Id = "Einherjar",
                Name = "Einherjar",
                Class = "ActiveUltimate",
                CanonBasis = "Shalltear summons a pale combat duplicate during her duel with Ainz",
                Effect = "Temporary stationary double copies basic attacks at reduced damage",
                Suggested = {Cooldown = 75, Duration = 12, DamageFraction = 0.40,
                    MaxSummonsPerCaster = 1},
                VFX = "Ghostly white translucent duplicate",
            },
        },
        BossRule = "Einherjar is not another permanent tower and does not bypass placement limits",
        RequiredSystems = {"StackingResource", "TemporarySummons", "ActivatedSkills", "MultiAttacks"},
    },

    OVL_Albedo = {
        Id = "OVL_Albedo",
        Rarity = "Mythic",
        RoleProposal = "GroundSupportDefenseControl",
        DamageType = "Physical",
        PrimaryIdentity = "The strongest defensive guardian with protective team utility",
        Passive = {
            Id = "HermesTrismegistus",
            Name = "Hermes Trismegistus",
            CanonBasis = "Her personal armor can absorb heavy hits, with limited layers/uses",
            Effect = "Blocks one ordinary enemy leak near the base by consuming a limited match charge",
            Suggested = {MatchCharges = 3, InternalCooldown = 28,
                GuardDistanceToBase = 31, BlocksBossInstantDefeat = false},
        },
        Skills = {
            {
                Id = "WallsOfJericho",
                Name = "Walls of Jericho",
                Class = "Active",
                CanonBasis = "A defensive Albedo skill listed in novel-based references",
                Effect = "Creates an area barrier that slows normal enemies for a short time",
                Suggested = {Cooldown = 27, Radius = 13, Duration = 5,
                    SlowFraction = 0.24},
                VFX = "Translucent dark-gold wall around the path",
            },
            {
                Id = "Aegis",
                Name = "Aegis",
                Class = "Active",
                CanonBasis = "Albedo's protective skill / transfer of incoming damage",
                Effect = "Nearby towers gain brief protection from one disable, not additional base HP",
                Suggested = {Cooldown = 39, AuraRadius = 20, Duration = 7,
                    MaxDisableBlocksPerUnit = 1},
                VFX = "Pale silver shields surrounding allied towers",
            },
            {
                Id = "GuardianOverseer",
                Name = "Comando da Guardiã Suprema",
                Class = "ActiveUltimate",
                CanonBasis = "Albedo is the Guardian Overseer commanding Nazarick's defenders",
                Effect = "Teamwide short damage buff, limited to one copy of this buff category",
                Suggested = {Cooldown = 70, Duration = 10,
                    TeamDamageBonus = 0.12, StackCategory = "TeamOverseer"},
                VFX = "Black feather halo over allied towers",
                IsGameplayAdaptation = true,
            },
        },
        BossRule = "Never cancels Nigun instant-defeat leak; boss control has progressive resistance",
        RequiredSystems = {"LeakInterceptor", "AOEStatus", "BuffStackPolicy", "TowerDisableProtection"},
    },

    OVL_Ainz = {
        Id = "OVL_Ainz",
        Rarity = "Secret",
        RoleProposal = "GroundMagicAOEDebuff",
        DamageType = "Magic",
        PrimaryIdentity = "High-risk spellcasting, delayed execution and battlefield control",
        Passive = {
            Id = "DespairAura",
            Name = "Despair Aura",
            CanonBasis = "Ainz can emanate powerful fear/despair auras",
            Effect = "Periodic small slow to normal enemies; bosses immune to auto-fear",
            Suggested = {PulseEvery = 13, Radius = 19, SlowFraction = 0.14,
                Duration = 2.5, AffectsBosses = false},
        },
        Skills = {
            {
                Id = "RealitySlash",
                Name = "Reality Slash",
                Class = "TriggeredAttack",
                CanonBasis = "High-tier spatial cutting magic",
                Effect = "High single-target magical burst that ignores a share of magic resistance",
                Suggested = {EveryAttacks = 4, DamageMultiplier = 2.1,
                    ResistancePenetration = 0.25},
                VFX = "Space-distortion slash",
            },
            {
                Id = "GraspHeart",
                Name = "Grasp Heart",
                Class = "Active",
                CanonBasis = "Instant death magic with a secondary disruption effect if resisted",
                Effect = "Executes weakened ordinary enemies; against bosses deals capped damage",
                Suggested = {Cooldown = 32, ExecuteNormalHpFraction = 0.20,
                    BossMaxHealthFraction = 0.025, BossDamageCap = 500,
                    FailedExecuteStun = 1.25},
                VFX = "Crimson spectral heart crush",
            },
            {
                Id = "FallenDown",
                Name = "Fallen Down",
                Class = "ActiveUltimate",
                CanonBasis = "Super-tier magic that floods an area with blinding light",
                Effect = "Big area spell with telegraph/channel, not instantaneous",
                Suggested = {Cooldown = 81, CastTime = 3.0,
                    Radius = 19, DamageMultiplier = 5.0},
                VFX = "Giant blue-white pillar; mobile low-particle mode",
            },
            {
                Id = "GoalOfAllLifeIsDeath",
                Name = "The Goal of All Life Is Death",
                Class = "OneTimeUltimate",
                CanonBasis = "Eclipse skill amplifies death magic with a 12-second delay",
                Effect = "After warning, executes low-health ordinary enemies; boss receives capped damage",
                Suggested = {UsesPerMatch = 1, Delay = 12, Radius = 22,
                    ExecuteNormalHpFraction = 0.25,
                    BossMaxHealthFraction = 0.07, BossDamageCap = 1300},
                VFX = "Dark clock countdown then monochrome shockwave",
                Spoiler = "Advanced Eclipse ability from the anime/light novel",
            },
        },
        BossRule = "No instant boss kill, phase skip, 100% HP execution or immunity bypass in TD",
        RequiredSystems = {"AOE", "ActivatedSkills", "DelayedEffects", "ExecuteThreshold",
            "ResistPenetration", "BossImmunityAndDamageCaps"},
    },
}

local function shallowCopyUnit(id: string): any?
    local unit = Design.Units[id]
    if not unit then return nil end
    -- Read-only design data; consumers must NOT mutate nested tables.
    return unit
end

function Design.Get(id: string)
    return shallowCopyUnit(id)
end

function Design.GetAll()
    local list = {}
    for _, entry in ipairs(Roster.GetAll()) do
        local unit = Design.Get(entry.Id)
        if unit then table.insert(list, unit) end
    end
    return list
end

function Design.IsGameplayEnabled(): boolean
    return false -- Always false until a separate approved combat implementation exists.
end

for id, unit in pairs(Design.Units) do
    assert(Roster.Get(id) ~= nil, "Design de habilidade sem personagem no roster: " .. id)
    assert(unit.Rarity == Roster.Get(id).Rarity,
        "Raridade de habilidade diferente do elenco oficial: " .. id)
end

return Design
