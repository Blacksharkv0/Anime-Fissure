
--!strict
-- ANIME FISSURE
-- Inicializacao do servidor
-- Versao: 0.1.0

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameConfig = require(Shared:WaitForChild("GameConfig"))

print("================================")
print("ANIME FISSURE - SERVIDOR ONLINE")
print("Versao: 0.1.0")
print("Jogadores maximos:", GameConfig.MaxPlayers)
print("Unidades por deck:", GameConfig.DeckSlots)
print("Waves Classic:", GameConfig.Waves.Classic)
print("Waves Hard:", GameConfig.Waves.Hard)
print("================================")

-- Os sistemas de partidas, unidades e economia
-- serao adicionados nas proximas etapas.