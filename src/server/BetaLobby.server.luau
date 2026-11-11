
--!strict
-- ANIME FISSURE | BetaLobby v0.1
-- Lobby 3D + entrada autorizada na arena

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local BLUE = Color3.fromRGB(56, 123, 255)
local DARK = Color3.fromRGB(17, 24, 42)
local CYAN = Color3.fromRGB(100, 220, 255)

local lobby = Instance.new("Model")
lobby.Name = "FissureLobby"
lobby.Parent = Workspace

local function createPart(
    name: string,
    size: Vector3,
    position: Vector3,
    color: Color3,
    material: Enum.Material
): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Position = position
    p.Color = color
    p.Material = material
    p.Anchored = true
    p.Parent = lobby
    return p
end

local CENTER = Vector3.new(260, 0, 0)

createPart(
    "LobbyFloor",
    Vector3.new(110, 4, 110),
    CENTER + Vector3.new(0, -2, 0),
    DARK,
    Enum.Material.Slate
)

for _, x in ipairs({-54, 54}) do
    createPart(
        "BlueBorder",
        Vector3.new(1, 1, 108),
        CENTER + Vector3.new(x, 0.5, 0),
        BLUE,
        Enum.Material.Neon
    )
end

for _, z in ipairs({-54, 54}) do
    createPart(
        "BlueBorder",
        Vector3.new(108, 1, 1),
        CENTER + Vector3.new(0, 0.5, z),
        BLUE,
        Enum.Material.Neon
    )
end

local portal = createPart(
    "ArenaPortal",
    Vector3.new(15, 19, 2),
    CENTER + Vector3.new(0, 10, -38),
    BLUE,
    Enum.Material.Neon
)
portal.CanCollide = false
portal.Transparency = 0.35

local light = Instance.new("PointLight")
light.Color = CYAN
light.Range = 35
light.Brightness = 3
light.Parent = portal

local sign = Instance.new("BillboardGui")
sign.Name = "PortalSign"
sign.Size = UDim2.fromOffset(260, 65)
sign.StudsOffset = Vector3.new(0, 12, 0)
sign.AlwaysOnTop = true
sign.MaxDistance = 100
sign.Parent = portal

local title = Instance.new("TextLabel")
title.Size = UDim2.fromScale(1, 1)
title.BackgroundTransparency = 1
title.Text = "FISSURE ARENA\nUSE O BOTAO JOGAR"
title.TextColor3 = CYAN
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = sign

local spawn = Instance.new("SpawnLocation")
spawn.Name = "LobbySpawn"
spawn.Size = Vector3.new(10, 1, 10)
spawn.Position = CENTER + Vector3.new(0, 0.5, 25)
spawn.Anchored = true
spawn.Neutral = true
spawn.Enabled = true
spawn.Duration = 0
spawn.Material = Enum.Material.Neon
spawn.Color = BLUE
spawn.Transparency = 0.3
spawn.Parent = lobby

-- Desativa os spawns automaticos da arena.
-- O acesso a arena sera por teleporte controlado.
task.spawn(function()
    local arena = Workspace:WaitForChild(
        "FissureArena", 30
    )

    if arena then
        local spawns = arena:FindFirstChild(
            "PlayerSpawns"
        )

        if spawns then
            for _, item in ipairs(spawns:GetChildren()) do
                if item:IsA("SpawnLocation") then
                    item.Enabled = false
                end
            end
        end
    end
end)

local remotes = Instance.new("Folder")
remotes.Name = "LobbyRemotes"
remotes.Parent = ReplicatedStorage

local enterRemote = Instance.new("RemoteEvent")
enterRemote.Name = "EnterArena"
enterRemote.Parent = remotes

local function teleportCharacter(
    player: Player,
    position: Vector3
)
    local character = player.Character
    if character then
        character:PivotTo(
            CFrame.new(position)
        )
    end
end

local function setupPlayer(player: Player)
    player:SetAttribute("InArena", false)
    player.RespawnLocation = spawn

    player.CharacterAdded:Connect(function(character)
        local root = character:WaitForChild(
            "HumanoidRootPart", 10
        )

        if root and not player:GetAttribute("InArena") then
            character:PivotTo(
                CFrame.new(
                    CENTER + Vector3.new(0, 5, 25)
                )
            )
        end
    end)

    if player.Character then
        teleportCharacter(
            player,
            CENTER + Vector3.new(0, 5, 25)
        )
    end
end

Players.PlayerAdded:Connect(setupPlayer)

for _, player in ipairs(Players:GetPlayers()) do
    setupPlayer(player)
end

local entryLocked = false

enterRemote.OnServerEvent:Connect(function(player)
    if player:GetAttribute("InArena") then
        return
    end

    -- Prototipo: uma partida por servidor.
    if entryLocked then
        warn("[Anime Fissure] Partida ja iniciada")
        return
    end

    entryLocked = true

    local arena = Workspace:WaitForChild(
        "FissureArena", 10
    )

    if not arena then
        entryLocked = false
        warn("[Anime Fissure] Arena nao encontrada")
        return
    end

    local character = player.Character
    if not character then
        entryLocked = false
        return
    end

    player:SetAttribute("InArena", true)

    player.RespawnLocation = nil

    teleportCharacter(
        player,
        Vector3.new(0, 5, 52)
    )

    -- Sinal para Main.server.luau
    Workspace:SetAttribute("ArenaRequested", true)

    print(
        "[Anime Fissure] Jogador entrou:",
        player.Name
    )
end)

print("[Anime Fissure] Lobby ONLINE")
