--!strict
-- ANIME FISSURE | AlchemyGateway v0.1
-- Interface acionada pela bancada da oficina no lobby.
-- Nao cria itens e nao concede moedas. Todas as operacoes
-- de crafting permanecem BLOQUEADAS ate existir o backend.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local remotes = ReplicatedStorage:FindFirstChild("AlchemyRemotes")
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "AlchemyRemotes"
    remotes.Parent = ReplicatedStorage
end

local function ensureRemote(name: string, className: string): Instance
    local current = remotes:FindFirstChild(name)
    if current and current.ClassName == className then
        return current
    end
    if current then
        current:Destroy()
    end
    local new = Instance.new(className)
    new.Name = name
    new.Parent = remotes
    return new
end

local openRemote = ensureRemote("OpenWorkshop", "RemoteEvent") :: RemoteEvent
local snapshotRemote = ensureRemote("GetWorkshopSnapshot", "RemoteFunction") :: RemoteFunction

-- Um perfil real sera ligado aqui futuramente.
-- Nao fabricamos moedas, materiais nem receitas de teste. Relíquias são exclusivas de Gilgamesh.
snapshotRemote.OnServerInvoke = function(player: Player)
    if player.Parent ~= Players or player:GetAttribute("InArena") == true then
        return nil
    end
    return {
        Inventory = {},
        Recipes = {}, -- somente receitas alquimicas/orbes, ainda vazias
        GoldConnected = false,
        CraftingEnabled = false,
        ProfileStatus = "Aguardando sistema de inventario",
    }
end

local lobby = Workspace:WaitForChild("FissureLobby", 40)
if not lobby then
    warn("[Anime Fissure] AlchemyGateway: lobby ausente")
    return
end

local workshop = lobby:WaitForChild("AlchemyWorkshop", 40)
if not workshop then
    warn("[Anime Fissure] AlchemyGateway: oficina ausente")
    return
end

local counter = workshop:WaitForChild("WorkbenchTop", 10)
if not counter or not counter:IsA("BasePart") then
    warn("[Anime Fissure] AlchemyGateway: bancada ausente")
    return
end

local prompt = counter:FindFirstChild("AlchemyPrompt")
if not prompt or not prompt:IsA("ProximityPrompt") then
    if prompt then prompt:Destroy() end
    prompt = Instance.new("ProximityPrompt")
    prompt.Name = "AlchemyPrompt"
    prompt.Parent = counter
end

prompt.ActionText = "Abrir Oficina"
prompt.ObjectText = "Alquimista - Transmutacao"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.HoldDuration = 0.15
prompt.MaxActivationDistance = 13
prompt.RequiresLineOfSight = false

prompt.Triggered:Connect(function(player: Player)
    if player.Parent ~= Players or player:GetAttribute("InArena") == true then
        return
    end
    openRemote:FireClient(player)
end)

print("[Anime Fissure] Oficina interativa pronta: use E junto a bancada")
