--!strict
-- ANIME FISSURE | Economy Model Lab smoke checks v0.1
-- Runs only in Roblox Studio. Does not grant currency or save data.

local RunService = game:GetService("RunService")
if not RunService:IsStudio() then return end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Config = require(Shared:WaitForChild("EconomyVisualConfig"))
local Builder = require(Shared:WaitForChild("EconomyItemModelBuilder"))
local folder = ReplicatedStorage:WaitForChild("EconomyPreviewModels", 40)
assert(folder and folder:IsA("Folder"),
    "EconomyPreviewModels nao foi criado no Studio")

local all = Config.GetAll()
assert(#all == 4, "Economy Lab deveria ter quatro modelos")
assert(#folder:GetChildren() == 4, "Pasta EconomyPreviewModels esta incompleta")

local ids: {[string]: boolean} = {}
local silhouettes: {[string]: number} = {}
local total = 0

for _, entry in ipairs(all) do
    assert(not ids[entry.Id], "Economy Visual ID duplicado: " .. entry.Id)
    ids[entry.Id] = true
    assert(Config.IsLive(entry.Id) == false,
        "Economy visual nao deve criar uma moeda funcional")
    local model = folder:FindFirstChild(entry.Id)
    assert(model and model:IsA("Model"), "Modelo 3D ausente: " .. entry.Id)
    assert(model.PrimaryPart and model.PrimaryPart.Name == "Root",
        "PrimaryPart ausente: " .. entry.Id)
    assert(model:GetAttribute("VisualOnly") == true,
        "Modelo nao pode criar economia real: " .. entry.Id)

    local pieces = 0
    for _, descendant in ipairs(model:GetDescendants()) do
        if descendant:IsA("BasePart") then
            assert(descendant.Anchored, "Economy item possui partes soltas: " .. entry.Id)
            assert(not descendant.CanCollide and not descendant.CanTouch,
                "Economy item nao deve bloquear a arena")
            assert(not descendant.CanQuery,
                "Economy item visual nao deve obstruir raycasts")
            pieces += 1
        end
        assert(not descendant:IsA("Decal") and not descendant:IsA("MeshPart"),
            "Economy item nao deve referenciar assets externos: " .. entry.Id)
    end
    assert(pieces >= 10 and pieces <= 60,
        "Quantidade de pecas estranha em " .. entry.Id .. ": " .. pieces)
    silhouettes[entry.Id] = pieces
    total += pieces

    -- A builder API e independente da biblioteca e pode gerar um icone
    -- 3D para ViewportFrames de futuros menus sem usar asset IDs.
    local clone = Builder.Build(entry.Id)
    assert(clone and clone.PrimaryPart and clone:GetAttribute("VisualOnly") == true,
        "Builder.Build nao criou a previa: " .. entry.Id)
    clone:Destroy()
end

assert(silhouettes.FissureGems ~= silhouettes.Gold,
    "Gem e Gold nao devem ser simplesmente o mesmo modelo")
assert(silhouettes.TraitRerollCore ~= silhouettes.RelicTraitSeal,
    "Reroll de unidade e de reliquia precisam de identidades distintas")
print("[Anime Fissure] ECONOMY MODEL SMOKE OK: " ..
    tostring(#all) .. " modelos | " .. tostring(total) ..
    " pecas | sem alteracao da economia")
