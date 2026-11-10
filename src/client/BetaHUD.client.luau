
--!strict
-- ANIME FISSURE | BetaHUD v0.1
-- Interface mobile da Beta
-- Conectado ao BetaBridge
-- Nao altera o sistema de Summon

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("BetaRemotes")
local stateRemote = remotes:WaitForChild("MatchState") :: RemoteEvent
local commandRemote = remotes:WaitForChild("MatchCommand") :: RemoteEvent

local BLUE = Color3.fromRGB(56, 123, 255)
local CYAN = Color3.fromRGB(90, 225, 255)
local WHITE = Color3.fromRGB(230, 240, 255)
local MUTED = Color3.fromRGB(145, 170, 205)
local GOLD = Color3.fromRGB(255, 215, 110)
local RED = Color3.fromRGB(255, 95, 115)
local DARK = Color3.fromRGB(8, 11, 19)
local PANEL = Color3.fromRGB(16, 27, 53)

local previous = playerGui:FindFirstChild("AnimeFissureBetaHUD")
if previous then
    previous:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFissureBetaHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 15
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function addCorner(parent: Instance, radius: number)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = parent
end

local function addStroke(parent: Instance)
    local stroke = Instance.new("UIStroke")
    stroke.Color = BLUE
    stroke.Thickness = 1
    stroke.Transparency = 0.3
    stroke.Parent = parent
end

local function makeLabel(
    parent: Instance,
    name: string,
    text: string,
    size: UDim2,
    position: UDim2,
    fontSize: number,
    color: Color3
): TextLabel
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = color
    label.TextSize = fontSize
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextTruncate = Enum.TextTruncate.AtEnd
    label.Parent = parent
    return label
end

local function makePanel(
    name: string,
    size: UDim2,
    position: UDim2,
    anchor: Vector2
): Frame
    local frame = Instance.new("Frame")
    frame.Name = name
    frame.Size = size
    frame.Position = position
    frame.AnchorPoint = anchor
    frame.BackgroundColor3 = DARK
    frame.BackgroundTransparency = 0.12
    frame.Parent = gui

    addCorner(frame, 12)
    addStroke(frame)

    return frame
end

-- PAINEL SUPERIOR ESQUERDO

local wavePanel = makePanel(
    "WavePanel",
    UDim2.fromOffset(200, 88),
    UDim2.new(0, 12, 0, 12),
    Vector2.new(0, 0)
)

makeLabel(
    wavePanel,
    "Brand",
    "ANIME FISSURE",
    UDim2.new(1, -20, 0, 18),
    UDim2.fromOffset(12, 8),
    11,
    CYAN
)

local waveLabel = makeLabel(
    wavePanel,
    "Wave",
    "WAVE -- / --",
    UDim2.new(1, -20, 0, 28),
    UDim2.fromOffset(12, 28),
    21,
    WHITE
)

local statusLabel = makeLabel(
    wavePanel,
    "Status",
    "AGUARDANDO PARTIDA",
    UDim2.new(1, -20, 0, 18),
    UDim2.fromOffset(12, 62),
    10,
    MUTED
)

-- PAINEL SUPERIOR DIREITO

local statsPanel = makePanel(
    "StatsPanel",
    UDim2.fromOffset(140, 88),
    UDim2.new(1, -12, 0, 12),
    Vector2.new(1, 0)
)

makeLabel(
    statsPanel,
    "YenTitle",
    "YEN",
    UDim2.fromOffset(110, 17),
    UDim2.fromOffset(12, 8),
    11,
    MUTED
)

local yenLabel = makeLabel(
    statsPanel,
    "Yen",
    "¥ 700",
    UDim2.fromOffset(120, 27),
    UDim2.fromOffset(12, 25),
    21,
    GOLD
)

local healthLabel = makeLabel(
    statsPanel,
    "BaseHealth",
    "BASE 3 / 3",
    UDim2.fromOffset(120, 20),
    UDim2.fromOffset(12, 61),
    12,
    WHITE
)

-- PAINEL INFERIOR

local combatPanel = makePanel(
    "CombatPanel",
    UDim2.fromOffset(340, 112),
    UDim2.new(0.5, 0, 1, -12),
    Vector2.new(0.5, 1)
)
combatPanel.BackgroundColor3 = PANEL

local scale = Instance.new("UIScale")
scale.Scale = 1
scale.Parent = combatPanel

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local width = camera.ViewportSize.X
    scale.Scale = math.clamp(width / 390, 0.65, 1)
end

updateScale()

local camera = workspace.CurrentCamera
if camera then
    camera:GetPropertyChangedSignal("ViewportSize"):Connect(
        updateScale
    )
end

makeLabel(
    combatPanel,
    "EnemyTitle",
    "INIMIGOS RESTANTES",
    UDim2.fromOffset(230, 20),
    UDim2.fromOffset(12, 8),
    12,
    MUTED
)

local enemyLabel = makeLabel(
    combatPanel,
    "Enemies",
    "0",
    UDim2.fromOffset(65, 25),
    UDim2.fromOffset(278, 5),
    19,
    WHITE
)
enemyLabel.TextXAlignment = Enum.TextXAlignment.Right

local progressBackground = Instance.new("Frame")
progressBackground.Name = "ProgressBackground"
progressBackground.Size = UDim2.fromOffset(316, 6)
progressBackground.Position = UDim2.fromOffset(12, 36)
progressBackground.BackgroundColor3 = Color3.fromRGB(35, 52, 86)
progressBackground.BorderSizePixel = 0
progressBackground.Parent = combatPanel
addCorner(progressBackground, 4)

local progressFill = Instance.new("Frame")
progressFill.Name = "ProgressFill"
progressFill.Size = UDim2.fromScale(0, 1)
progressFill.BackgroundColor3 = BLUE
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBackground
addCorner(progressFill, 4)

local skipButton = Instance.new("TextButton")
skipButton.Name = "SkipWave"
skipButton.Size = UDim2.fromOffset(150, 44)
skipButton.Position = UDim2.fromOffset(12, 56)
skipButton.BackgroundColor3 = BLUE
skipButton.BackgroundTransparency = 0.35
skipButton.Text = "SKIP BLOQUEADO"
skipButton.TextColor3 = WHITE
skipButton.TextSize = 12
skipButton.Font = Enum.Font.GothamBold
skipButton.AutoButtonColor = false
skipButton.Parent = combatPanel
addCorner(skipButton, 9)

local autoButton = Instance.new("TextButton")
autoButton.Name = "AutoSkip"
autoButton.Size = UDim2.fromOffset(150, 44)
autoButton.Position = UDim2.fromOffset(178, 56)
autoButton.BackgroundColor3 = DARK
autoButton.Text = "AUTO: OFF"
autoButton.TextColor3 = CYAN
autoButton.TextSize = 13
autoButton.Font = Enum.Font.GothamBold
autoButton.Parent = combatPanel
addCorner(autoButton, 9)
addStroke(autoButton)

-- ESTADO RECEBIDO DO SERVIDOR

local currentStatus = "Waiting"
local currentWaveStatus = "Idle"
local lastWave = 0
local initialEnemies = 0
local autoMode = "Off"
local voted = false

local autoModes = {"Off", "Fast", "Smart"}

local function updateSkipButton(
    votes: number,
    required: number
)
    local canSkip =
        currentStatus == "Playing"
        and currentWaveStatus == "Preparation"

    skipButton.Active = canSkip and not voted
    skipButton.AutoButtonColor = canSkip and not voted

    if not canSkip then
        skipButton.Text = "SKIP BLOQUEADO"
        skipButton.BackgroundTransparency = 0.65
    elseif voted then
        skipButton.Text = "VOTO ENVIADO"
        skipButton.BackgroundTransparency = 0.45
    else
        skipButton.Text = string.format(
            "SKIP (%d/%d)",
            votes,
            required
        )
        skipButton.BackgroundTransparency = 0.05
    end
end

skipButton.Activated:Connect(function()
    if currentStatus ~= "Playing"
        or currentWaveStatus ~= "Preparation"
        or voted then
        return
    end

    voted = true
    commandRemote:FireServer("Skip")
    skipButton.Text = "VOTO ENVIADO"
    skipButton.Active = false
end)

autoButton.Activated:Connect(function()
    local currentIndex = table.find(autoModes, autoMode) or 1
    local nextIndex = (currentIndex % #autoModes) + 1

    autoMode = autoModes[nextIndex]
    autoButton.Text = "AUTO: " .. string.upper(autoMode)

    commandRemote:FireServer("AutoSkip", autoMode)
end)

local function safeNumber(value: any, fallback: number): number
    if typeof(value) == "number"
        and value == value
        and value ~= math.huge
        and value ~= -math.huge then
        return value
    end

    return fallback
end

stateRemote.OnClientEvent:Connect(function(data: any)
    if typeof(data) ~= "table" then
        return
    end

    local status = data.Status
    local waveStatus = data.WaveStatus

    if typeof(status) ~= "string"
        or typeof(waveStatus) ~= "string" then
        return
    end

    local wave = safeNumber(data.CurrentWave, 0)
    local maxWaves = safeNumber(data.MaxWaves, 15)
    local enemies = safeNumber(data.RemainingEnemies, 0)
    local yen = safeNumber(data.Yen, 700)
    local health = safeNumber(data.BaseHealth, 3)
    local votes = safeNumber(data.Votes, 0)
    local required = safeNumber(data.RequiredVotes, 0)
    local remaining = safeNumber(
        data.PreparationRemaining,
        0
    )

    if wave ~= lastWave then
        lastWave = wave
        initialEnemies = 0
        voted = false
    end

    if currentWaveStatus ~= waveStatus then
        voted = false
    end

    currentStatus = status
    currentWaveStatus = waveStatus

    waveLabel.Text = string.format(
        "WAVE %02d / %02d",
        wave,
        maxWaves
    )

    yenLabel.Text = "¥ " .. tostring(yen)

    healthLabel.Text = string.format(
        "BASE %d / 3",
        health
    )

    healthLabel.TextColor3 =
        health <= 1 and RED or WHITE

    enemyLabel.Text = tostring(enemies)

    if waveStatus == "Combat" then
        initialEnemies = math.max(initialEnemies, enemies)
    end

    local fraction = 0

    if initialEnemies > 0 then
        fraction = math.clamp(
            enemies / initialEnemies,
            0,
            1
        )
    end

    TweenService:Create(
        progressFill,
        TweenInfo.new(0.2),
        {Size = UDim2.fromScale(fraction, 1)}
    ):Play()

    if status == "Victory" then
        statusLabel.Text = "VITORIA!"
        statusLabel.TextColor3 = GOLD

    elseif status == "Defeat" then
        statusLabel.Text = "DERROTA"
        statusLabel.TextColor3 = RED

    elseif status ~= "Playing" then
        statusLabel.Text = "AGUARDANDO PARTIDA"
        statusLabel.TextColor3 = MUTED

    elseif waveStatus == "Combat" then
        statusLabel.Text = "COMBATE EM ANDAMENTO"
        statusLabel.TextColor3 = CYAN

    elseif waveStatus == "Preparation" then
        statusLabel.Text = string.format(
            "PREPARACAO: %ds",
            remaining
        )
        statusLabel.TextColor3 = GOLD

    else
        statusLabel.Text = "PROXIMA WAVE..."
        statusLabel.TextColor3 = MUTED
    end

    updateSkipButton(votes, required)
end)

print("[Anime Fissure] BetaHUD v0.1 ONLINE")
