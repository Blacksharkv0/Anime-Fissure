--!strict
-- ANIME FISSURE | EconomyModels Studio v0.1
-- All four economy icons are visual-only models for the model lab.
-- No balance, shop, summon, wallet or inventory mutations.

local RunService = game:GetService("RunService")
if not RunService:IsStudio() then return end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Builder = require(
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("EconomyItemModelBuilder")
)
local folder = Builder.BuildAll(ReplicatedStorage)
print("[Anime Fissure] ECONOMY MODELS: " .. tostring(#folder:GetChildren()) ..
    " visual-only models ready for Studio inspection")
