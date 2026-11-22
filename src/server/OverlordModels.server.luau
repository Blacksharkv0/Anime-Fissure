--!strict
-- ANIME FISSURE | OverlordModels v0.1
-- Gera os seis modelos em ReplicatedStorage somente no Roblox Studio.
-- Nenhuma unidade e concedida ao jogador, registrada no deck ou no banner.
-- A galeria de modelos no lobby faz o preview de 0/1/2/3 visuais.

local RunService = game:GetService("RunService")
if not RunService:IsStudio() then return end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Builder = require(
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("OverlordTowerModelBuilder")
)

local folder = Builder.BuildAll(ReplicatedStorage)
print("[Anime Fissure] Overlord modelos preview: ",
    #folder:GetChildren(), "| Rig R6 | visual base + 3 evolucoes")
