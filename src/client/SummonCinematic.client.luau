--!strict
-- ANIME FISSURE | Summon Cinematic v2.1 - DEMO LEGADA DESATIVADA
-- O botao TESTAR SUMMON era apenas uma demo sem resultado de servidor.
-- A cinematica real agora e executada pelo modulo Shared.SummonRevealClient
-- apos uma compra confirmada em SummonHUD.client.luau.
-- Mantemos este LocalScript para remover o antigo botao de teste
-- e evitar que o jogador confunda o prototipo com o Summon funcional.
local Players = game:GetService("Players")
local gui = Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("SummonPrototype")
if gui then gui:Destroy() end
print("[Anime Fissure] Demo de summon substituida pela revelacao real")
