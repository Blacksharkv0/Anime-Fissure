
--!strict
-- ANIME FISSURE | BetaHUD v0.9 - HUD arcade unificado com Stage Info
-- HUD de combate para PC e Mobile
-- Invisivel no lobby e durante o loading
-- Visivel somente dentro da arena
-- Integrado ao BetaBridge e Lobby

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local StageIntelPanel = require(script.Parent:WaitForChild("StageIntelPanel"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild("BetaRemotes")
local stateRemote = remotes:WaitForChild("MatchState") :: RemoteEvent
local commandRemote = remotes:WaitForChild("MatchCommand") :: RemoteEvent

-- CORES

local BLUE = Color3.fromRGB(56, 123, 255)
local CYAN = Color3.fromRGB(90, 225, 255)
local WHITE = Color3.fromRGB(230, 240, 255)
local MUTED = Color3.fromRGB(145, 170, 205)
local GOLD = Color3.fromRGB(255, 215, 110)
local RED = Color3.fromRGB(255, 95, 115)
local DARK = Color3.fromRGB(8, 11, 19)
local PANEL = Color3.fromRGB(16, 27, 53)
local ACCENT = Color3.fromRGB(164, 103, 246)

-- INTERFACE PRINCIPAL

local previous = playerGui:FindFirstChild(
    "AnimeFissureBetaHUD"
)

if previous then
    previous:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFissureBetaHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 18
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Comeca sempre invisivel.
gui.Enabled = false
gui.Parent = playerGui

-- CONTROLE DE VISIBILIDADE

local stageUI: any = nil

local function isInArena(): boolean
    return player:GetAttribute("InArena") == true
end

local function updateHudVisibility()
    gui.Enabled = isInArena()
    if not gui.Enabled and stageUI then
        stageUI.Close()
    end

    if gui.Enabled then
        print("[Anime Fissure] HUD da arena ativado")
    else
        print("[Anime Fissure] HUD oculto no lobby")
    end
end

player:GetAttributeChangedSignal(
    "InArena"
):Connect(updateHudVisibility)

updateHudVisibility()

-- FUNCOES VISUAIS

local function addCorner(
    parent: Instance,
    radius: number
)
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
    labelText: string,
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
    label.Text = labelText
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
    frame.BackgroundTransparency = 0.05
    frame.BorderSizePixel = 0
    frame.Parent = gui

    addCorner(frame, 12)
    addStroke(frame)

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 90
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, PANEL),
        ColorSequenceKeypoint.new(1, DARK),
    })
    gradient.Parent = frame

    return frame
end

-- PAINEL SUPERIOR ESQUERDO

local wavePanel = makePanel(
    "WavePanel",
    UDim2.fromOffset(246, 105),
    UDim2.new(0, 12, 0, 12),
    Vector2.new(0, 0)
)

makeLabel(
    wavePanel,
    "Brand",
    "ANIME FISSURE",
    UDim2.new(1, -20, 0, 18),
    UDim2.fromOffset(13, 7),
    11,
    CYAN
)

local stageNameLabel = makeLabel(
    wavePanel,
    "StageName",
    "CARREGANDO FASE...",
    UDim2.new(1, -26, 0, 18),
    UDim2.fromOffset(13, 26),
    12,
    GOLD
)

local waveLabel = makeLabel(
    wavePanel,
    "Wave",
    "WAVE -- / --",
    UDim2.new(1, -20, 0, 30),
    UDim2.fromOffset(13, 45),
    23,
    WHITE
)

local statusLabel = makeLabel(
    wavePanel,
    "Status",
    "AGUARDANDO PARTIDA",
    UDim2.new(1, -26, 0, 18),
    UDim2.fromOffset(13, 81),
    11,
    MUTED
)

local phaseAccent = Instance.new("Frame")
phaseAccent.Name = "PhaseAccent"
phaseAccent.Size = UDim2.new(0, 4, 0, 44)
phaseAccent.Position = UDim2.new(0, 0, 0, 44)
phaseAccent.BackgroundColor3 = CYAN
phaseAccent.BorderSizePixel = 0
phaseAccent.Parent = wavePanel
addCorner(phaseAccent, 3)

-- PAINEL SUPERIOR DIREITO

local statsPanel = makePanel(
    "StatsPanel",
    UDim2.fromOffset(168, 105),
    UDim2.new(1, -12, 0, 12),
    Vector2.new(1, 0)
)

makeLabel(
    statsPanel,
    "YenTitle",
    "YEN",
    UDim2.fromOffset(139, 17),
    UDim2.fromOffset(13, 9),
    11,
    MUTED
)

local yenLabel = makeLabel(
    statsPanel,
    "Yen",
    "¥ 700",
    UDim2.fromOffset(142, 31),
    UDim2.fromOffset(13, 29),
    25,
    GOLD
)

local healthLabel = makeLabel(
    statsPanel,
    "BaseHealth",
    "BASE 3 / 3",
    UDim2.fromOffset(145, 20),
    UDim2.fromOffset(13, 76),
    13,
    WHITE
)

local coinsDivider = Instance.new("Frame")
coinsDivider.Name = "ResourceDivider"
coinsDivider.Size = UDim2.new(1, -26, 0, 1)
coinsDivider.Position = UDim2.fromOffset(13, 67)
coinsDivider.BackgroundColor3 = ACCENT
coinsDivider.BackgroundTransparency = 0.36
coinsDivider.BorderSizePixel = 0
coinsDivider.Parent = statsPanel

-- PAINEL INFERIOR

local combatPanel = makePanel(
    "CombatPanel",
    UDim2.fromOffset(360, 122),
    UDim2.new(0.5, 0, 1, -16),
    Vector2.new(0.5, 1)
)

combatPanel.BackgroundColor3 = PANEL

local combatScale = Instance.new("UIScale")
combatScale.Parent = combatPanel

local waveScale = Instance.new("UIScale")
waveScale.Parent = wavePanel
local statsScale = Instance.new("UIScale")
statsScale.Parent = statsPanel

local function updateScale()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local v = camera.ViewportSize
    local headerFactor = math.clamp((v.X - 36) / 437, 0.62, 1)
    waveScale.Scale = headerFactor
    statsScale.Scale = headerFactor
    combatScale.Scale = math.clamp(
        math.min((v.X - 26) / 360, (v.Y - 120) / 122, 1),
        0.60, 1
    )
end

local function bindCamera()
    local camera = Workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end
    updateScale()
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
bindCamera()

-- CONTADOR DE INIMIGOS

makeLabel(
    combatPanel,
    "EnemyTitle",
    "INIMIGOS RESTANTES",
    UDim2.fromOffset(230, 20),
    UDim2.fromOffset(14, 12),
    12,
    MUTED
)

local enemyLabel = makeLabel(
    combatPanel,
    "Enemies",
    "0",
    UDim2.fromOffset(65, 25),
    UDim2.fromOffset(285, 8),
    19,
    WHITE
)

enemyLabel.TextXAlignment =
    Enum.TextXAlignment.Right

-- BARRA DE PROGRESSO

local progressBackground = Instance.new("Frame")
progressBackground.Name = "ProgressBackground"
progressBackground.Size = UDim2.fromOffset(332, 8)
progressBackground.Position = UDim2.fromOffset(14, 42)
progressBackground.BackgroundColor3 =
    Color3.fromRGB(35, 52, 86)
progressBackground.BorderSizePixel = 0
progressBackground.Parent = combatPanel

addCorner(progressBackground, 4)

local progressFill = Instance.new("Frame")
progressFill.Name = "ProgressFill"
progressFill.Size = UDim2.fromScale(0, 1)
progressFill.BackgroundColor3 = CYAN
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBackground

addCorner(progressFill, 4)

-- BOTAO SKIP

local skipButton = Instance.new("TextButton")
skipButton.Name = "SkipWave"
skipButton.Size = UDim2.fromOffset(158, 48)
skipButton.Position = UDim2.fromOffset(14, 64)
skipButton.BackgroundColor3 = BLUE
skipButton.BackgroundTransparency = 0.35
skipButton.Text = "SKIP BLOQUEADO"
skipButton.TextColor3 = WHITE
skipButton.TextSize = 12
skipButton.Font = Enum.Font.GothamBold
skipButton.AutoButtonColor = false
skipButton.Parent = combatPanel

addCorner(skipButton, 9)

-- BOTAO AUTO SKIP

local autoButton = Instance.new("TextButton")
autoButton.Name = "AutoSkip"
autoButton.Size = UDim2.fromOffset(158, 48)
autoButton.Position = UDim2.fromOffset(188, 64)
autoButton.BackgroundColor3 = DARK
autoButton.Text = "AUTO: OFF"
autoButton.TextColor3 = CYAN
autoButton.TextSize = 13
autoButton.Font = Enum.Font.GothamBold
autoButton.Parent = combatPanel

addCorner(autoButton, 9)
addStroke(autoButton)

-- Stage Info esta no MESMO ScreenGui e escuta o MESMO snapshot.
-- Nao existe mais StageIntelHUD separado.
stageUI = StageIntelPanel.Attach(gui)

-- ESTADO DO COMBATE

local currentStatus = "Waiting"
local currentWaveStatus = "Idle"

local lastWave = 0
local initialEnemies = 0
local autoMode = "Off"
local voted = false

local autoModes = {
    "Off",
    "Fast",
    "Smart"
}

-- ATUALIZAR BOTAO SKIP

local function updateSkipButton(
    votes: number,
    required: number
)

    local canSkip =
        isInArena()
        and currentStatus == "Playing"
        and currentWaveStatus == "Preparation"

    skipButton.Active = canSkip and not voted
    skipButton.AutoButtonColor =
        canSkip and not voted

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

-- ENVIAR VOTO SKIP

skipButton.Activated:Connect(function()
    if not isInArena() then
        return
    end

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

-- ALTERNAR AUTO SKIP

autoButton.Activated:Connect(function()
    if not isInArena() then
        return
    end

    local currentIndex =
        table.find(autoModes, autoMode) or 1

    local nextIndex =
        (currentIndex % #autoModes) + 1

    autoMode = autoModes[nextIndex]

    autoButton.Text =
        "AUTO: " .. string.upper(autoMode)

    commandRemote:FireServer(
        "AutoSkip",
        autoMode
    )
end)

-- VALIDAR NUMEROS RECEBIDOS

local function safeNumber(
    value: any,
    fallback: number
): number

    if typeof(value) == "number"
        and value == value
        and value ~= math.huge
        and value ~= -math.huge then

        return value
    end

    return fallback
end

-- ATUALIZAR ESTADO RECEBIDO DO SERVIDOR

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

    local wave = safeNumber(
        data.CurrentWave,
        0
    )

    local maxWaves = safeNumber(
        data.MaxWaves,
        15
    )

    local enemies = safeNumber(
        data.RemainingEnemies,
        0
    )

    local yen = safeNumber(
        data.Yen,
        700
    )

    local health = safeNumber(
        data.BaseHealth,
        3
    )

    local votes = safeNumber(
        data.Votes,
        0
    )

    local required = safeNumber(
        data.RequiredVotes,
        0
    )

    local remaining = safeNumber(
        data.PreparationRemaining,
        0
    )

    -- REINICIAR CONTADORES AO MUDAR WAVE

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

    -- INFORMACOES SUPERIORES

    waveLabel.Text = string.format(
        "WAVE %02d / %02d",
        wave,
        maxWaves
    )

    local info = data.StageInfo
    if typeof(info) == "table" and typeof(info.Name) == "string" then
        stageNameLabel.Text = string.upper(info.Name)
    else
        stageNameLabel.Text = "FASE INDISPONIVEL"
    end
    stageUI.Update(info, wave)
    yenLabel.Text = "¥ " .. tostring(yen)

    healthLabel.Text = string.format(
        "BASE %d / 3",
        health
    )

    if health <= 1 then
        healthLabel.TextColor3 = RED
    else
        healthLabel.TextColor3 = WHITE
    end

    enemyLabel.Text = tostring(enemies)

    -- BARRA DE INIMIGOS

    if waveStatus == "Combat" then
        initialEnemies = math.max(
            initialEnemies,
            enemies
        )
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
        {
            Size = UDim2.fromScale(
                fraction,
                1
            )
        }
    ):Play()

    -- STATUS DA PARTIDA

    if status == "Victory" then
        phaseAccent.BackgroundColor3 = GOLD
        statusLabel.Text = "VITORIA!"
        statusLabel.TextColor3 = GOLD

    elseif status == "Defeat" then
        phaseAccent.BackgroundColor3 = RED
        statusLabel.Text = "DERROTA"
        statusLabel.TextColor3 = RED

    elseif status ~= "Playing" then
        phaseAccent.BackgroundColor3 = MUTED
        statusLabel.Text = "AGUARDANDO PARTIDA"
        statusLabel.TextColor3 = MUTED

    elseif waveStatus == "Combat" then
        phaseAccent.BackgroundColor3 = CYAN
        statusLabel.Text = "COMBATE EM ANDAMENTO"
        statusLabel.TextColor3 = CYAN

    elseif waveStatus == "Preparation" then
        phaseAccent.BackgroundColor3 = GOLD
        statusLabel.Text = string.format(
            "PREPARACAO: %ds",
            remaining
        )
        statusLabel.TextColor3 = GOLD

    else
        phaseAccent.BackgroundColor3 = BLUE
        statusLabel.Text = "PROXIMA WAVE..."
        statusLabel.TextColor3 = MUTED
    end

    updateSkipButton(
        votes,
        required
    )
end)

-- GARANTIR VISIBILIDADE CORRETA

player:GetAttributeChangedSignal(
    "InArena"
):Connect(function()
    if not isInArena() then
        voted = false
        currentStatus = "Waiting"
        currentWaveStatus = "Idle"
        initialEnemies = 0
    end

    updateSkipButton(0, 0)
end)

updateHudVisibility()
updateSkipButton(0, 0)

print(
    "[Anime Fissure] BetaHUD v0.9 ONLINE | Stage Info integrado"
)
