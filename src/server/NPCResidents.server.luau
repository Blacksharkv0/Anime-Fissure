--!strict
-- ANIME FISSURE | NPCResidents v0.5 - Dialogo seguro antes dos sistemas
-- Virgil e Edward iniciam dialogo via E / gamepad / toque.
-- Desativa os prompts dos altares APENAS quando os dos NPCs estiverem prontos.
-- Escolhas revalidadas no servidor; sorteio, inventario e economia intactos.

local Workspace = game:GetService("Workspace")
local RS = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Builder = require(RS:WaitForChild("Shared"):WaitForChild("FissureNPCBuilder"))
local Appearance=require(script.Parent:WaitForChild("LobbyNPCAppearance"))

-- Remotes separados dos sistemas reais para o cliente nao poder abrir
-- interfaces sem ter iniciado uma interacao valida com o NPC.
local dialogueFolder = RS:FindFirstChild("NPCDialogueRemotes")
if dialogueFolder and not dialogueFolder:IsA("Folder") then
    dialogueFolder:Destroy()
    dialogueFolder = nil
end
if not dialogueFolder then
    dialogueFolder = Instance.new("Folder")
    dialogueFolder.Name = "NPCDialogueRemotes"
    dialogueFolder.Parent = RS
end

local function ensureDialogueRemote(name: string): RemoteEvent
    local existing = dialogueFolder:FindFirstChild(name)
    if existing and existing:IsA("RemoteEvent") then return existing end
    if existing then existing:Destroy() end
    local new = Instance.new("RemoteEvent")
    new.Name = name
    new.Parent = dialogueFolder
    return new
end

local dialogueOpen = ensureDialogueRemote("OpenDialogue")
local dialogueChoice = ensureDialogueRemote("ChooseDialogue")

local targets: {[string]: {Anchor: BasePart, Destination: RemoteEvent}} = {}
local pending: {[number]: {Kind: string, ExpiresAt: number}} = {}

local lobby = Workspace:WaitForChild("FissureLobby", 45)
if not lobby or not lobby:IsA("Model") then
    warn("[NPC v0.4] FissureLobby nao encontrado")
    return
end

local POSITIONS = {
    -- Ao lado da entrada do stand: nao fica atras do cristal/pedestal.
    Virgil = CFrame.new(233.2, 3.5, -1.8) * CFrame.Angles(0, math.pi, 0),
    -- A FRENTE da bancada, nao atras dela como na versao antiga.
    Edward = CFrame.new(301.4, 3.5, -8.5) * CFrame.Angles(0, math.pi, 0),
}

local function animateIdle(npc: Model)
    local torso = npc:FindFirstChild("Torso")
    if not torso or not torso:IsA("BasePart") then return end
    local neck = torso:FindFirstChild("Neck")
    if not neck or not neck:IsA("Motor6D") then return end
    local startC0 = neck.C0
    TweenService:Create(neck,
        TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {C0 = startC0 * CFrame.Angles(math.rad(2), 0, math.rad(2))}
    ):Play()
end

local function waitForRemote(kind: string): RemoteEvent?
    local folderName = if kind == "Virgil" then "SummonRemotes" else "AlchemyRemotes"
    local eventName = if kind == "Virgil" then "Open" else "OpenWorkshop"
    local folder = RS:WaitForChild(folderName, 35)
    if not folder then
        warn("[NPC v0.4] Pasta de remotes ausente:", folderName)
        return nil
    end
    local remote = folder:WaitForChild(eventName, 35)
    if not remote or not remote:IsA("RemoteEvent") then
        warn("[NPC v0.4] RemoteEvent ausente:", folderName, eventName)
        return nil
    end
    return remote
end

local function bindInteraction(npc: Model, kind: string, remote: RemoteEvent): ProximityPrompt?
    local head = npc:FindFirstChild("Head")
    local root = npc:FindFirstChild("HumanoidRootPart")
    local anchorPart = if head and head:IsA("BasePart") then head
        elseif root and root:IsA("BasePart") then root else nil
    if not anchorPart then
        warn("[NPC v0.4] NPC sem Head/HumanoidRootPart:", kind)
        return nil
    end

    -- Limpa o prompt antigo, que estava preso ao root invisivel.
    for _, descendant in ipairs(npc:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") and descendant.Name == "FissureNPCPrompt" then
            descendant:Destroy()
        end
    end
    local attachment = anchorPart:FindFirstChild("FissureInteractionPoint")
    if not attachment or not attachment:IsA("Attachment") then
        if attachment then attachment:Destroy() end
        attachment = Instance.new("Attachment")
        attachment.Name = "FissureInteractionPoint"
        attachment.Parent = anchorPart
    end
    (attachment :: Attachment).Position = Vector3.new(0, 0.15, 0)

    local prompt = Instance.new("ProximityPrompt")
    prompt.Name = "FissureNPCPrompt"
    prompt.ActionText = if kind == "Virgil" then "ABRIR SUMMON" else "ABRIR ALQUIMIA"
    prompt.ObjectText = if kind == "Virgil" then "VIRGIL - INVOCADOR" else "EDWARD - ALQUIMISTA"
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    prompt.Style = Enum.ProximityPromptStyle.Default
    prompt.Exclusivity = Enum.ProximityPromptExclusivity.AlwaysShow
    prompt.ClickablePrompt = true
    prompt.RequiresLineOfSight = false
    prompt.MaxActivationDistance = 13
    prompt.HoldDuration = 0
    prompt.Enabled = false
    prompt.Parent = attachment

    prompt.Triggered:Connect(function(player: Player)
        if player.Parent ~= Players or player:GetAttribute("InArena") == true then return end
        local char = player.Character
        local playerRoot = if char then char:FindFirstChild("HumanoidRootPart") else nil
        if not playerRoot or not playerRoot:IsA("BasePart") then return end
        -- Revalidacao no servidor para nao depender somente do Prompt.
        if (playerRoot.Position - anchorPart.Position).Magnitude > 16 then return end
        pending[player.UserId] = {Kind = kind, ExpiresAt = os.clock() + 90}
        dialogueOpen:FireClient(player, kind)
        print("[NPC v0.5] Dialogo:", kind, "por", player.Name)
    end)
    prompt.Enabled = true
    targets[kind] = {Anchor = anchorPart, Destination = remote}
    npc.Destroying:Connect(function()
        local target = targets[kind]
        if target and target.Anchor == anchorPart then
            targets[kind] = nil
        end
    end)
    npc:SetAttribute("InteractionReady", true)
    print("[NPC v0.4] Prompt E ativo:", kind, "em", anchorPart.Position)
    return prompt
end

local function disableStandPrompt(station: Model, kind: string, npc: Model)
    -- Os prompts originais compartilhavam a tecla E, podendo esconder
    -- o prompt sobre o personagem. So desativamos depois do novo estar pronto.
    task.spawn(function()
        local partName = if kind == "Virgil" then "SummonPedestal" else "WorkbenchTop"
        local promptName = if kind == "Virgil" then "VirgilSummonPrompt" else "AlchemyPrompt"
        local holder = station:WaitForChild(partName, 25)
        if not holder then return end
        local oldPrompt = holder:WaitForChild(promptName, 25)
        if oldPrompt and oldPrompt:IsA("ProximityPrompt") then
            oldPrompt.Enabled = false
            npc.Destroying:Connect(function()
                if oldPrompt.Parent then oldPrompt.Enabled = true end
            end)
            print("[NPC v0.4] Prompt antigo desativado:", promptName)
        end
    end)
end

local function install(kind: string, stationName: string, npcName: string)
    local station = lobby:WaitForChild(stationName, 40)
    if not station or not station:IsA("Model") then
        warn("[NPC v0.4] Estacao nao encontrada:", stationName)
        return
    end

    local npc = station:FindFirstChild(npcName)
    local freshlyBuilt = false
    if not npc or not npc:IsA("Model") then
        npc = Builder.Build(kind)
        if not npc then
            warn("[NPC v0.4] Nao foi possivel criar NPC:", kind)
            return
        end
        npc.Name = npcName
        npc.Parent = station
        freshlyBuilt = true
    end

    -- Tambem corrige modelos que ja existiam na oficina mas foram
    -- gerados abaixo do piso ou atras da bancada.
    local destination=POSITIONS[kind]
    -- Reborn Edward is deliberately shorter; keep his boot soles at the
    -- original ground height rather than floating above the workshop.
    if kind=="Edward" and npc:GetAttribute("CharacterReborn")=="Edward-v1" then
        destination=destination-Vector3.new(0,3*(1-npc:GetScale()),0)
    end
    npc:PivotTo(destination)
    local ground=destination*CFrame.new(0,-3*npc:GetScale(),0)
    local imported=Appearance.Apply(npc,if kind=="Virgil" then "Vergil" else "Edward",ground)
    if freshlyBuilt and not imported then animateIdle(npc) end

    local remote = waitForRemote(kind)
    if not remote then
        warn("[NPC v0.4] Mantendo prompt antigo, remote ausente:", kind)
        return
    end
    local interaction = bindInteraction(npc, kind, remote)
    if interaction then
        disableStandPrompt(station, kind, npc)
    end
end


-- O botao do cliente nao ativa o sistema diretamente: verifica prazo,
-- tipo do NPC, distancia e estado do jogador. O cliente nao recebe
-- capacidade de criar Tickets, itens ou resultados de Summon.
dialogueChoice.OnServerEvent:Connect(function(player: Player, requestedKind: any)
    if typeof(requestedKind) ~= "string" then return end
    local id = player.UserId
    local ticket = pending[id]
    pending[id] = nil -- escolha de uso unico, inclusive em caso de falha
    if not ticket or ticket.Kind ~= requestedKind or os.clock() > ticket.ExpiresAt then
        return
    end

    local target = targets[requestedKind]
    if not target or not target.Anchor.Parent then return end
    if player.Parent ~= Players or player:GetAttribute("InArena") == true then return end

    local character = player.Character
    local root = if character then character:FindFirstChild("HumanoidRootPart") else nil
    if not root or not root:IsA("BasePart") then return end
    if (root.Position - target.Anchor.Position).Magnitude > 16 then return end

    target.Destination:FireClient(player)
end)

Players.PlayerRemoving:Connect(function(player)
    pending[player.UserId] = nil
end)

-- Independentes: falha no Virgil nao impede Edward e vice-versa.
task.spawn(function() install("Virgil", "VirgilSummonStand", "VirgilNPC") end)
task.spawn(function() install("Edward", "AlchemyWorkshop", "AlchemistNPC") end)

print("[Anime Fissure] NPCResidents v0.5 carregado")
