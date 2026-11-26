--!strict
-- ANIME FISSURE | Overlord Model Smoke Test v0.1
-- Testa TODOS os personagens e as quatro aparencias SOMENTE no Studio.
-- Nao libera personagens, nao inicia waves nem concede itens.

local RunService = game:GetService("RunService")
if not RunService:IsStudio() then return end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local shared = ReplicatedStorage:WaitForChild("Shared")
local Roster = require(shared:WaitForChild("OverlordUnitRoster"))
local Progression = require(shared:WaitForChild("OverlordModelProgression"))
local Builder = require(shared:WaitForChild("OverlordTowerModelBuilder"))
local Abilities = require(shared:WaitForChild("OverlordAbilityDesign"))

local library = ReplicatedStorage:WaitForChild("OverlordTowerModels", 45)
if not library or not library:IsA("Folder") then
    warn("[Overlord Model Test] Biblioteca nao encontrada")
    return
end

local passed = 0
for _, entry in ipairs(Roster.GetAll()) do
    local source = library:FindFirstChild(entry.Id .. "_" .. entry.Rarity)
    assert(source and source:IsA("Model"), "Modelo nao encontrado: " .. entry.Id)
    assert(source.PrimaryPart ~= nil, "Rig sem PrimaryPart: " .. entry.Id)
    assert(source:FindFirstChild("Humanoid") ~= nil, "Rig sem Humanoid: " .. entry.Id)
    assert(source:FindFirstChild("Neck", true) ~= nil, "Rig R6 sem Neck: " .. entry.Id)
    assert(source:GetAttribute("ArtPassVersion") == "0.8.0",
        "Refinamento visual ausente: " .. entry.Id)
    local cosmetics=source:FindFirstChild("AnimeArtPass")
    assert(cosmetics and cosmetics:IsA("Folder"),
        "Pecas de roupa/cabelo/arma ausentes: " .. entry.Id)
    local cosmeticCount=0
    for _, item in ipairs(cosmetics:GetDescendants()) do
        if item:IsA("BasePart") then
            cosmeticCount+=1
            assert(not item.Anchored and not item.CanCollide
                and not item.CanTouch and not item.CanQuery,
                "Cosmetico 3D impacta movimentacao/combate: " .. entry.Id)
            assert(item:FindFirstChild("CosmeticWeld"),
                "Cosmetico precisa ser soldado ao R6: " .. item.Name)
        end
    end
    assert(cosmeticCount>=10,"Modelo pouco detalhado: " .. entry.Id)
    assert(entry.PassivePlanned == true, "Unidade sem passiva: " .. entry.Id)
    assert(entry.AttackChangesPlanned == 3, "Unidade sem tres mudancas: " .. entry.Id)
    assert(Abilities.Get(entry.Id) and Abilities.Get(entry.Id).Passive,
        "Passiva de design ausente: " .. entry.Id)
    assert((entry.Id == "OVL_Ainz") == (entry.BannerCandidate == false),
        "Somente Ainz deve ficar fora do banner planejado")

    local previous = -1
    for stage = 0, 3 do
        assert(Progression.Get(entry.Id, stage), "Ataque de stage ausente: " .. entry.Id)
        local clone = source:Clone()
        clone.Parent = ServerStorage
        assert(Builder.SetVisualStage(clone, stage),
            "Nao conseguiu mudar para etapa " .. stage .. ": " .. entry.Id)
        assert(clone:GetAttribute("VisualStage") == stage,
            "Atributo visual incorreto: " .. entry.Id)
        local folder = clone:FindFirstChild("ActiveVisualStage")
        assert(folder ~= nil, "Stage visual sem folder: " .. entry.Id)
        local count = 0
        for _, descendant in ipairs(folder:GetDescendants()) do
            if descendant:IsA("BasePart") then count += 1 end
        end
        assert(count > previous, "Mudanca visual nao adicionou detalhes: " .. entry.Id)
        previous = count
        clone:Destroy()
        passed += 1
    end
end

assert(#Roster.GetAll() == 6, "O elenco Overlord deveria ter seis personagens")
print("[Anime Fissure] OVERLORD MODEL TESTE ESTATICO OK: " .. passed ..
    " variantes | 6 passivas | cinco banner planejado | Ainz especial")
