--!strict
-- ANIME FISSURE | VirgilSummonStand v0.1
-- Ponto de Summon na esquerda do lobby.
-- Se existir ServerStorage.VirgilNPC, ele sera utilizado.
-- Caso contrario, exibe um altar de teste; nao inventa personagem final.

local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local lobby = Workspace:WaitForChild("FissureLobby", 40)
if not lobby then warn("[Summon] Lobby ainda nao existe") return end

local old = lobby:FindFirstChild("VirgilSummonStand")
if old then old:Destroy() end

local stand = Instance.new("Model")
stand.Name = "VirgilSummonStand"
stand.Parent = lobby

local ORIGIN = Vector3.new(228, 0, -6)
local BLUE = Color3.fromRGB(56, 123, 255)
local CYAN = Color3.fromRGB(107, 232, 255)
local GOLD = Color3.fromRGB(226, 173, 95)
local PURPLE = Color3.fromRGB(127, 74, 219)
local DARK = Color3.fromRGB(23, 29, 51)

local function brick(name: string, size: Vector3, offset: Vector3,
    color: Color3, material: Enum.Material, collision: boolean?): Part
    local obj = Instance.new("Part")
    obj.Name = name
    obj.Size = size
    obj.Position = ORIGIN + offset
    obj.Color = color
    obj.Material = material
    obj.Anchored = true
    obj.CanCollide = collision ~= false
    obj.CanTouch = false
    obj.Parent = stand
    return obj
end

brick("Platform", Vector3.new(19, 0.45, 16), Vector3.new(0, 0.24, 0), DARK, Enum.Material.Slate)
brick("EdgeLeft", Vector3.new(0.25, 0.35, 15), Vector3.new(-9.2, 0.62, 0), BLUE, Enum.Material.Neon, false)
brick("EdgeRight", Vector3.new(0.25, 0.35, 15), Vector3.new(9.2, 0.62, 0), BLUE, Enum.Material.Neon, false)
brick("BackWall", Vector3.new(18, 7, 1), Vector3.new(0, 3.65, -7.2), DARK, Enum.Material.Slate)
for _, x in ipairs({-7.5, 7.5}) do
    brick("Column", Vector3.new(1.2, 9, 1.2), Vector3.new(x, 4.75, -6.7), DARK, Enum.Material.Basalt)
    brick("ColumnLight", Vector3.new(1.4, 0.4, 1.4), Vector3.new(x, 7.3, -6.7), GOLD, Enum.Material.Metal, false)
end
local pedestal = brick("SummonPedestal", Vector3.new(5, 2.4, 5), Vector3.new(0, 1.5, -1.0), DARK, Enum.Material.Metal)
local crystal = brick("SummonCrystal", Vector3.new(2.2, 3.5, 2.2), Vector3.new(0, 5.0, -1), PURPLE, Enum.Material.Neon, false)
crystal.CFrame = crystal.CFrame * CFrame.Angles(0, 0, math.rad(45))
local light = Instance.new("PointLight")
light.Color = CYAN
light.Brightness = 1.5
light.Range = 17
light.Parent = crystal

local anchor = brick("SignAnchor", Vector3.new(1,1,1), Vector3.new(0, 9.5, -6.3), BLUE, Enum.Material.Neon, false)
anchor.Transparency = 1
local billboard = Instance.new("BillboardGui")
billboard.Name = "VirgilLabel"
billboard.Size = UDim2.fromOffset(250, 65)
billboard.MaxDistance = 70
billboard.AlwaysOnTop = true
billboard.Parent = anchor
local text = Instance.new("TextLabel")
text.Size = UDim2.fromScale(1, 1)
text.BackgroundTransparency = 1
text.Text = "VIRGIL\nSUMMON DE UNIDADES"
text.TextColor3 = CYAN
text.TextStrokeTransparency = 0.45
text.TextScaled = true
text.Font = Enum.Font.GothamBold
text.Parent = billboard

local npcSource = ServerStorage:FindFirstChild("VirgilNPC")
if npcSource and npcSource:IsA("Model") then
    local npc = npcSource:Clone()
    npc.Parent = stand
    npc:PivotTo(CFrame.new(ORIGIN + Vector3.new(5.8, 0.7, -3.8)) * CFrame.Angles(0, math.pi, 0))
end

local prompt = Instance.new("ProximityPrompt")
prompt.Name = "VirgilSummonPrompt"
prompt.ActionText = "Abrir Summon"
prompt.ObjectText = "Virgil - Invocador"
prompt.KeyboardKeyCode = Enum.KeyCode.E
prompt.HoldDuration = 0.15
prompt.MaxActivationDistance = 12
prompt.RequiresLineOfSight = false
prompt.Parent = pedestal

local remotes = ReplicatedStorage:WaitForChild("SummonRemotes", 25)
if not remotes then warn("[Summon] SummonRemotes nao encontrado") return end
local openEvent = remotes:WaitForChild("Open", 15) :: RemoteEvent
prompt.Triggered:Connect(function(player: Player)
    if player.Parent ~= Players or player:GetAttribute("InArena") == true then return end
    openEvent:FireClient(player)
end)

print("[Anime Fissure] Virgil: ponto de Summon pronto no lobby")
