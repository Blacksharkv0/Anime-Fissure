--!strict
-- ANIME FISSURE | NPCResidents v0.2
-- Exibe Virgil (Summon) e Edward (Alquimia) sem alterar prompts ou remotes.
-- Se houver NPCs reais colocados nos stands, nao cria duplicados.
local Workspace = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Builder = require(RS:WaitForChild("Shared"):WaitForChild("FissureNPCBuilder"))

local lobby = Workspace:WaitForChild("FissureLobby", 45)
if not lobby then warn("[Anime Fissure NPC] Lobby ausente") return end

local function breathe(model: Model)
    local torso = model:FindFirstChild("Torso")
    if not torso or not torso:IsA("BasePart") then return end
    local neck = torso:FindFirstChild("Neck")
    if neck and neck:IsA("Motor6D") then
        local atRest = neck.C0
        TweenService:Create(neck,
            TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {C0 = atRest * CFrame.Angles(math.rad(3), 0, math.rad(2))}
        ):Play()
    end
end

local function npcInteraction(npc: Model, kind: string)
    local root = npc:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart") then return end
    if root:FindFirstChild("FissureNPCPrompt") then return end
    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = "FissureNPCPrompt"
    prompt.ActionText = if kind == "Virgil" then "Invocar unidades" else "Abrir alquimia"
    prompt.ObjectText = kind
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.HoldDuration = 0.1
    prompt.MaxActivationDistance = 10
    prompt.RequiresLineOfSight = false
    prompt.Parent = root
    task.spawn(function()
        local folder = RS:WaitForChild(
            if kind == "Virgil" then "SummonRemotes" else "AlchemyRemotes", 30)
        if not folder then return end
        local event = folder:WaitForChild(
            if kind == "Virgil" then "Open" else "OpenWorkshop", 20)
        if not event or not event:IsA("RemoteEvent") then return end
        prompt.Triggered:Connect(function(player: Player)
            if player.Parent ~= Players or player:GetAttribute("InArena") == true then return end
            event:FireClient(player)
        end)
    end)
end

local function place(station: Model, kind: string, name: string, cf: CFrame)
    local existing = station:FindFirstChild(name)
    if existing and existing:IsA("Model") then
        npcInteraction(existing, kind)
        print("[Anime Fissure NPC] Modelo existente mantido:", name)
        return
    end
    local npc = Builder.Build(kind)
    if not npc then return end
    npc.Name = name
    npc.Parent = station
    npc:PivotTo(cf)
    breathe(npc)
    npcInteraction(npc, kind)
    print("[Anime Fissure NPC] Personagem instalado:", name)
end

local virgilStand = lobby:WaitForChild("VirgilSummonStand", 35)
if virgilStand and virgilStand:IsA("Model") then
    place(virgilStand, "Virgil", "VirgilNPC",
        CFrame.new(233.5, 3.5, -8.5) * CFrame.Angles(0, math.pi, 0))
else
    warn("[Anime Fissure NPC] Estacao de Virgil indisponivel")
end

local workshop = lobby:WaitForChild("AlchemyWorkshop", 35)
if workshop and workshop:IsA("Model") then
    place(workshop, "Edward", "AlchemistNPC",
        CFrame.new(301.0, 3.5, -16.4) * CFrame.Angles(0, math.pi, 0))
else
    warn("[Anime Fissure NPC] Oficina de Alquimia indisponivel")
end
