--!strict
-- ANIME FISSURE | Five Overlord ring visual templates (Studio only).
-- Preview models grant nothing; use one shared folder, not live drops.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Builder=require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RelicRingModelBuilder"))
local folder=Builder.BuildAll(ReplicatedStorage)
print("[Anime Fissure] RING MODELS STUDIO OK: " ..
    tostring(#folder:GetChildren()) .. " visual-only rings ready")
