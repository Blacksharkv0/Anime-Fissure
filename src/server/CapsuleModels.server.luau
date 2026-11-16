--!strict
-- ANIME FISSURE | CapsuleModels v0.1
-- Cria prototipos no ReplicatedStorage. NAO insere nenhuma unidade no deck.
-- No futuro os sistemas de colocacao clonarao os modelos daqui.

local RS = game:GetService("ReplicatedStorage")
local shared = RS:WaitForChild("Shared")
local characterBuilder = require(shared:WaitForChild("CapsuleR6Builder"))
local inventionBuilder = require(shared:WaitForChild("CapsuleInventionBuilder"))

local rigs = characterBuilder.BuildAll(RS)
local inventions = inventionBuilder.BuildAll(RS)
print("[Anime Fissure] Capsule: modelos R6:", #rigs:GetChildren(),
    "| invencoes:", #inventions:GetChildren())
