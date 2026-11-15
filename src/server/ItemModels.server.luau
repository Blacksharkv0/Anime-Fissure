--!strict
-- ANIME FISSURE | ItemModels.server v0.1
-- Gera modelos reutilizaveis em ReplicatedStorage.ItemModels quando o servidor inicia.
-- Nao concede materiais nem relíquias aos jogadores.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local builder = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("ItemModelBuilder"))
local folder = builder.BuildAll(ReplicatedStorage)
print("[Anime Fissure] Modelos 3D de itens preparados:", #folder:GetChildren())
