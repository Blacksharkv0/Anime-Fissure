
--!strict
-- ANIME FISSURE | BetaLobby v1.0 | selecao de mundo e fase
-- Lobby 3D + entrada autorizada na arena

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local StageConfig = require(
    ReplicatedStorage:WaitForChild("Shared"):WaitForChild("LobbyStageConfig")
)

local BLUE = Color3.fromRGB(56, 123, 255)
local DARK = Color3.fromRGB(17, 24, 42)
local CYAN = Color3.fromRGB(100, 220, 255)

local existingLobby = Workspace:FindFirstChild("FissureLobby")
if existingLobby then existingLobby:Destroy() end
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

-- Split the east border around the Babylon bridge (z=14..26).
-- Keep a generous clear passage for walking and touch controls.
createPart("BlueBorder",Vector3.new(1,1,108),CENTER+Vector3.new(-54,.5,0),Color3.fromRGB(59,83,120),Enum.Material.Metal)
for _,span in ipairs({{-54,13},{27,54}}) do
    createPart("BlueBorder",Vector3.new(1,1,span[2]-span[1]),
        CENTER+Vector3.new(54,.5,(span[1]+span[2])*.5),Color3.fromRGB(59,83,120),Enum.Material.Metal)
end

for _, z in ipairs({-54, 54}) do
    createPart(
        "BlueBorder",
        Vector3.new(108, 1, 1),
        CENTER + Vector3.new(0, 0.5, z),
        Color3.fromRGB(59,83,120),
        Enum.Material.Metal
    )
end

-- WORLD POLISH: physical perimeter rails separate from cosmetic geometry.
-- Main lobby remains the same floor and opens only onto the royal bridge.
local safety=Instance.new("Model")
safety.Name="CitySafety"
safety.Parent=lobby
local function guard(name: string,size: Vector3,position: Vector3)
    local rail=Instance.new("Part")
    rail.Name=name;rail.Size=size;rail.Position=position
    rail.Material=Enum.Material.Metal;rail.Color=DARK
    rail.Anchored=true;rail.CanCollide=true;rail.CanTouch=false;rail.CanQuery=true
    rail.Parent=safety
    local trim=Instance.new("Part")
    trim.Name="RailTrim";trim.Size=Vector3.new(size.X,.12,size.Z)
    trim.Position=position+Vector3.new(0,size.Y*.5+.06,0)
    trim.Color=Color3.fromRGB(59,83,120);trim.Material=Enum.Material.Metal
    trim.Anchored=true;trim.CanCollide=false;trim.CanTouch=false;trim.CanQuery=false
    trim.CastShadow=false;trim.Parent=safety
end
guard("WestGuard",Vector3.new(.70,4.2,109),CENTER+Vector3.new(-54.5,2.1,0))
for _,z in ipairs({-54.5,54.5}) do
    guard("NorthSouthGuard",Vector3.new(109,4.2,.70),CENTER+Vector3.new(0,2.1,z))
end
for _,span in ipairs({{-54.5,13},{27,54.5}}) do
    guard("EastGuard",Vector3.new(.70,4.2,span[2]-span[1]),
        CENTER+Vector3.new(54.5,2.1,(span[1]+span[2])*.5))
end
-- Rails continue along the exposed gap between the main floor and annex.
-- They leave the central bridge channel (z=14.6..25.4) clear.
for _,z in ipairs({14.30,25.70}) do
    guard("BridgeGuard",Vector3.new(4.5,4.2,.52),Vector3.new(316.7,2.15,z))
end
safety:SetAttribute("Ready",true)

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
light.Range = 19
light.Brightness = 0.85
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
title.Text = "PORTAL DAS FISSURAS\nESCOLHA SUA MISSAO"
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

local remotes = ReplicatedStorage:FindFirstChild("LobbyRemotes")
if remotes and not remotes:IsA("Folder") then remotes:Destroy(); remotes = nil end
if not remotes then
    remotes = Instance.new("Folder")
    remotes.Name = "LobbyRemotes"
    remotes.Parent = ReplicatedStorage
end

local function ensureRemote(name: string): RemoteEvent
    local old = remotes:FindFirstChild(name)
    if old and old:IsA("RemoteEvent") then return old end
    if old then old:Destroy() end
    local created = Instance.new("RemoteEvent")
    created.Name = name
    created.Parent = remotes
    return created
end

local enterRemote = ensureRemote("EnterArena")
local feedbackRemote = ensureRemote("LobbyFeedback")
local openBoardRemote = ensureRemote("OpenMissionBoard")

local portalPrompt = portal:FindFirstChild("MissionBoardPrompt")
if not portalPrompt or not portalPrompt:IsA("ProximityPrompt") then
    if portalPrompt then portalPrompt:Destroy() end
    portalPrompt = Instance.new("ProximityPrompt")
    portalPrompt.Name = "MissionBoardPrompt"
    portalPrompt.Parent = portal
end
portalPrompt.ActionText = "ESCOLHER FASE"
portalPrompt.ObjectText = "PORTAL DAS FISSURAS"
portalPrompt.KeyboardKeyCode = Enum.KeyCode.E
portalPrompt.GamepadKeyCode = Enum.KeyCode.ButtonX
portalPrompt.ClickablePrompt = true
portalPrompt.RequiresLineOfSight = false
portalPrompt.HoldDuration = 0
portalPrompt.MaxActivationDistance = 15
portalPrompt.Triggered:Connect(function(player: Player)
    if player:GetAttribute("InArena") == true then return end
    local character = player.Character
    local root = if character then character:FindFirstChild("HumanoidRootPart") else nil
    if not root or not root:IsA("BasePart") then return end
    if (root.Position - portal.Position).Magnitude > 20 then return end
    openBoardRemote:FireClient(player)
end)
local function feedback(player: Player, status: string, message: string)
    if player.Parent == Players then
        feedbackRemote:FireClient(player, status, message)
    end
end

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

-- Keep the scenery non-playable and rescue accidental falls below the
-- actual walking surface, before the default void destroys the character.
-- Do not touch arena players, combat state, currencies or health.
task.spawn(function()
    while lobby.Parent do
        task.wait(.5)
        for _,player in ipairs(Players:GetPlayers()) do
            if player:GetAttribute("InArena")==true then continue end
            local character=player.Character
            local root=if character then character:FindFirstChild("HumanoidRootPart") else nil
            local humanoid=if character then character:FindFirstChildOfClass("Humanoid") else nil
            if character and root and root:IsA("BasePart") and humanoid and humanoid.Health>0
                and root.Position.Y < -8 then
                character:PivotTo(CFrame.new(CENTER+Vector3.new(0,5,25)))
                root.AssemblyLinearVelocity=Vector3.zero
                root.AssemblyAngularVelocity=Vector3.zero
            end
        end
    end
end)

-- A beta atual possui uma partida por servidor; nao e matchmaking cooperativo.
local entryLocked = false
local lastRequests: {[number]: number} = {}

enterRemote.OnServerEvent:Connect(function(player: Player, stageId: any, difficulty: any)
    if player.Parent ~= Players then return end
    local now = os.clock()
    if now - (lastRequests[player.UserId] or -100) < 0.45 then return end
    lastRequests[player.UserId] = now

    if player:GetAttribute("InArena") == true then
        feedback(player, "Denied", "Voce ja esta na arena.")
        return
    end

    local allowed, reason = StageConfig.CanEnter(stageId, difficulty)
    if not allowed then
        feedback(player, "Denied", reason)
        return
    end

    if entryLocked then
        feedback(player, "Denied", "Uma partida ja foi iniciada neste servidor beta.")
        return
    end

    -- A escolha do cliente precisa ser validada; somente OVL_01 e Classic/Hard.
    entryLocked = true
    local arena = Workspace:FindFirstChild("FissureArena")
    local mapReady = arena and arena:IsA("Model") and arena:GetAttribute("Ready") == true
    if not mapReady then
        entryLocked = false
        feedback(player, "Denied", "O mapa ainda esta carregando. Tente novamente.")
        return
    end

    if Workspace:GetAttribute("ArenaControllerReady") ~= true then
        entryLocked = false
        feedback(player, "Denied", "O controlador da partida ainda esta carregando.")
        return
    end

    local character = player.Character
    local humanoid = if character then character:FindFirstChildOfClass("Humanoid") else nil
    local root = if character then character:FindFirstChild("HumanoidRootPart") else nil
    if not character or not humanoid or humanoid.Health <= 0
        or not root or not root:IsA("BasePart") then
        entryLocked = false
        feedback(player, "Denied", "Personagem indisponivel. Tente novamente.")
        return
    end

    -- Consumo atomico da vaga de partida. Todos os dados usados por Main
    -- sao definidos do lado do servidor ANTES de ArenaRequested.
    Workspace:SetAttribute("ArenaStageId", stageId)
    Workspace:SetAttribute("ArenaMode", difficulty)
    player:SetAttribute("InArena", true)
    player.RespawnLocation = nil

    local spawnFolder = (arena :: Model):FindFirstChild("PlayerSpawns")
    local pad = if spawnFolder then spawnFolder:FindFirstChild("PlayerSpawn_1") else nil
    local spawnPos = if pad and pad:IsA("BasePart")
        then pad.Position + Vector3.new(0, 4, 0)
        else Vector3.new(0, 5, 52)

    teleportCharacter(player, spawnPos)
    Workspace:SetAttribute("ArenaRequested", true)
    feedback(player, "Accepted", "Carne Village - " .. difficulty .. " iniciada.")
    print("[Anime Fissure] Entrada validada:", player.Name, stageId, difficulty)
end)

Players.PlayerRemoving:Connect(function(player)
    lastRequests[player.UserId] = nil
end)

print("[Anime Fissure] Lobby v1.0 ONLINE | mundo / fase / modo validado")
