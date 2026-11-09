
--!strict
-- ANIME FISSURE
-- Inicializacao do cliente
-- Versao: 0.1.0

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared:WaitForChild("GameConfig"))

print("================================")
print("ANIME FISSURE - CLIENTE ONLINE")
print("Versao: 0.1.0")
print("Jogador:", LocalPlayer.Name)
print("Unidades por deck:", GameConfig.DeckSlots)
print("Auto Replay:", GameConfig.Farm.AutoReplayDefault)
print("================================")

-- Futuramente:
-- HUD de Waves e vida da base
-- Interface de unidades e deck
-- Controles mobile
-- Sistema visual de Farm e Auto Replay
