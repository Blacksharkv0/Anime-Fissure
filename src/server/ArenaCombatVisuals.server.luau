--!strict
-- ANIME FISSURE | ArenaCombatVisuals v0.6
-- Integra o mapa da beta aos inimigos reais, com painel da base
-- e aviso de combate de treinamento (somente Studio).

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local MatchService = require(script.Parent:WaitForChild("MatchService"))
local GameConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GameConfig"))

local arena = Workspace:WaitForChild("FissureArena", 45)
if not arena or not arena:IsA("Model") then
    warn("[ArenaVisuals] Arena nao encontrada")
    return
end

local base = arena:WaitForChild("FissureBase", 15)
local core = base and base:FindFirstChild("BaseCore")
if not core or not core:IsA("BasePart") then
    warn("[ArenaVisuals] Core da base nao encontrado")
    return
end

local gui = Instance.new("BillboardGui")
gui.Name = "BaseHealthBillboard"
gui.Adornee = core
gui.Size = UDim2.fromOffset(240, 70)
gui.StudsOffsetWorldSpace = Vector3.new(0, 11, 0)
gui.AlwaysOnTop = true
gui.MaxDistance = 160
gui.Parent = core

local background = Instance.new("Frame")
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Color3.fromRGB(8, 13, 30)
background.BackgroundTransparency = 0.13
background.BorderSizePixel = 0
background.Parent = gui
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 9)
corner.Parent = background

local title = Instance.new("TextLabel")
title.Name = "HealthLabel"
title.Size = UDim2.fromScale(1, 0.67)
title.BackgroundTransparency = 1
title.Text = "◈ BASE 3 / 3"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(120, 225, 255)
title.Parent = background

local stateLabel = Instance.new("TextLabel")
stateLabel.Size = UDim2.fromScale(1, 0.33)
stateLabel.Position = UDim2.fromScale(0, 0.65)
stateLabel.BackgroundTransparency = 1
stateLabel.Text = "AGUARDANDO PARTIDA"
stateLabel.Font = Enum.Font.Gotham
stateLabel.TextSize = 12
stateLabel.TextColor3 = Color3.fromRGB(204, 223, 247)
stateLabel.Parent = background

if RunService:IsStudio() then
    local notice = Instance.new("Part")
    notice.Name = "StudioTrainingSign"
    notice.Size = Vector3.new(1, 1, 1)
    notice.Position = Vector3.new(-72, 9, 0)
    notice.Anchored = true
    notice.Transparency = 1
    notice.CanCollide = false
    notice.CanTouch = false
    notice.CanQuery = false
    notice.Parent = arena

    local help = Instance.new("BillboardGui")
    help.Name = "TrainingTip"
    help.Size = UDim2.fromOffset(380, 90)
    help.StudsOffsetWorldSpace = Vector3.new(0, 3.5, 0)
    help.Adornee = notice
    help.AlwaysOnTop = true
    help.MaxDistance = 180
    help.Parent = notice

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundColor3 = Color3.fromRGB(11, 18, 38)
    label.BackgroundTransparency = 0.10
    label.BorderSizePixel = 0
    label.Text = "PORTAL INIMIGO\nSTUDIO: CLIQUE NOS INIMIGOS PARA ATACAR"
    label.TextWrapped = true
    label.Font = Enum.Font.GothamBold
    label.TextSize = 19
    label.TextColor3 = Color3.fromRGB(255, 204, 120)
    label.Parent = help
    local radius = Instance.new("UICorner")
    radius.CornerRadius = UDim.new(0, 9)
    radius.Parent = label
end

arena:SetAttribute("StageId", "OVL_01")
arena:SetAttribute("EnemySystem", "RealWaypoints_v0.6")
arena:SetAttribute("CombatReady", true)

task.spawn(function()
    while arena.Parent and core.Parent do
        local match = MatchService.GetMatch("MainMatch")
        local hp = if match then match.BaseHealth else GameConfig.BaseHealth
        local status = if match then match.Status else "Waiting"
        local color = if hp <= 1 then Color3.fromRGB(255, 83, 109)
            else Color3.fromRGB(90, 225, 255)
        title.Text = string.format("◈ BASE %d / %d", hp, GameConfig.BaseHealth)
        title.TextColor3 = color
        core.Color = color
        core:SetAttribute("BaseHealth", hp)
        stateLabel.Text = if status == "Victory" then "VITORIA"
            elseif status == "Defeat" then "BASE DESTRUIDA"
            elseif status == "Playing" then "DEFENDA O NUCLEO"
            else "AGUARDANDO PARTIDA"
        task.wait(0.25)
    end
end)

print("[Anime Fissure] ArenaCombatVisuals v0.6 carregado")
