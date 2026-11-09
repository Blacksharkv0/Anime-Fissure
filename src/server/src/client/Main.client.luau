
--!strict
-- ANIME FISSURE
-- HUD Mobile - Prototipo visual v0.3.0
-- DEMO LOCAL: nao altera a partida no servidor

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("AnimeFissureHUD")
if old then
    old:Destroy()
end

local COLORS = {
    Background = Color3.fromRGB(9, 15, 29),
    Panel = Color3.fromRGB(16, 29, 51),
    Slot = Color3.fromRGB(22, 43, 73),
    Blue = Color3.fromRGB(56, 123, 255),
    Cyan = Color3.fromRGB(92, 219, 255),
    White = Color3.fromRGB(239, 247, 255),
    Muted = Color3.fromRGB(155, 183, 219),
    Gold = Color3.fromRGB(255, 210, 96),
    Red = Color3.fromRGB(255, 112, 130),
    Green = Color3.fromRGB(83, 224, 169),
}

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFissureHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

local function corner(parent: Instance, radius: number)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

local function stroke(parent: Instance, color: Color3)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = 1
    s.Transparency = 0.4
    s.Parent = parent
end

local function frame(
    name: string,
    parent: Instance,
    size: UDim2,
    position: UDim2,
    color: Color3
): Frame
    local f = Instance.new("Frame")
    f.Name = name
    f.Size = size
    f.Position = position
    f.BackgroundColor3 = color
    f.BorderSizePixel = 0
    f.Parent = parent
    corner(f, 12)
    return f
end

local function label(
    name: string,
    parent: Instance,
    text: string,
    size: UDim2,
    position: UDim2,
    color: Color3,
    fontSize: number
): TextLabel
    local t = Instance.new("TextLabel")
    t.Name = name
    t.Size = size
    t.Position = position
    t.BackgroundTransparency = 1
    t.Text = text
    t.TextColor3 = color
    t.Font = Enum.Font.GothamBold
    t.TextSize = fontSize
    t.TextScaled = false
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextTruncate = Enum.TextTruncate.AtEnd
    t.Parent = parent
    return t
end

local function button(
    name: string,
    parent: Instance,
    text: string,
    size: UDim2,
    position: UDim2,
    color: Color3
): TextButton
    local b = Instance.new("TextButton")
    b.Name = name
    b.Size = size
    b.Position = position
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = COLORS.White
    b.Font = Enum.Font.GothamBold
    b.TextScaled = true
    b.Parent = parent
    corner(b, 10)
    return b
end

-- Estado de demonstracao.
local currentWave = 1
local maxWaves = 15
local yen = 700
local baseHealth = 3
local countdown = 10
local autoSkip = false
local skipRequested = false
local demoFinished = false

-- Painel superior.
local top = frame(
    "TopPanel",
    gui,
    UDim2.new(0.92, 0, 0, 90),
    UDim2.new(0.04, 0, 0, 12),
    COLORS.Background
)
stroke(top, COLORS.Blue)

label(
    "GameTitle", top, "ANIME FISSURE",
    UDim2.new(0.55, 0, 0, 22),
    UDim2.new(0.04, 0, 0, 5),
    COLORS.Cyan, 13
)

local waveText = label(
    "WaveText", top, "WAVE 01 / 15",
    UDim2.new(0.6, 0, 0, 32),
    UDim2.new(0.04, 0, 0, 27),
    COLORS.White, 23
)

local baseText = label(
    "BaseText", top, "BASE 3/3",
    UDim2.new(0.36, 0, 0, 24),
    UDim2.new(0.63, 0, 0, 12),
    COLORS.Red, 15
)
baseText.TextXAlignment = Enum.TextXAlignment.Right

local yenText = label(
    "YenText", top, "YEN 700",
    UDim2.new(0.5, 0, 0, 23),
    UDim2.new(0.04, 0, 0, 62),
    COLORS.Gold, 15
)

local modeText = label(
    "ModeText", top, "CLASSIC | DEMO",
    UDim2.new(0.47, 0, 0, 23),
    UDim2.new(0.51, 0, 0, 62),
    COLORS.Muted, 12
)
modeText.TextXAlignment = Enum.TextXAlignment.Right

-- Painel de Skip.
local skipPanel = frame(
    "SkipPanel",
    gui,
    UDim2.new(0, 190, 0, 118),
    UDim2.new(1, -202, 0, 115),
    COLORS.Panel
)
stroke(skipPanel, COLORS.Blue)

local timerText = label(
    "Timer", skipPanel, "NEXT WAVE: 10s",
    UDim2.new(1, -16, 0, 26),
    UDim2.new(0, 8, 0, 7),
    COLORS.Cyan, 14
)
timerText.TextXAlignment = Enum.TextXAlignment.Center

local skipButton = button(
    "SkipButton", skipPanel, "SKIP WAVE",
    UDim2.new(1, -16, 0, 38),
    UDim2.new(0, 8, 0, 36),
    COLORS.Blue
)

local autoButton = button(
    "AutoSkipButton", skipPanel, "AUTO SKIP: OFF",
    UDim2.new(1, -16, 0, 28),
    UDim2.new(0, 8, 0, 81),
    COLORS.Slot
)

-- Barra de unidades.
local deck = frame(
    "DeckPanel",
    gui,
    UDim2.new(0.94, 0, 0, 82),
    UDim2.new(0.03, 0, 1, -94),
    COLORS.Background
)
stroke(deck, COLORS.Blue)

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Padding = UDim.new(0, 5)
layout.Parent = deck

for i = 1, 6 do
    local slot = button(
        "UnitSlot" .. i,
        deck,
        tostring(i),
        UDim2.new(0.15, 0, 0, 62),
        UDim2.new(),
        COLORS.Slot
    )

    stroke(slot, COLORS.Blue)

    slot.Activated:Connect(function()
        print("[HUD DEMO] Slot selecionado:", i)

        local original = slot.BackgroundColor3
        slot.BackgroundColor3 = COLORS.Blue

        TweenService:Create(
            slot,
            TweenInfo.new(0.35),
            {BackgroundColor3 = original}
        ):Play()
    end)
end

-- Mensagem discreta de demonstracao.
local notice = label(
    "DemoNotice", gui,
    "HUD TEST • SEM COMBATE REAL",
    UDim2.new(0, 220, 0, 20),
    UDim2.new(0, 12, 1, -121),
    COLORS.Muted, 10
)

local function updateHUD()
    waveText.Text = string.format(
        "WAVE %02d / %02d",
        currentWave,
        maxWaves
    )

    baseText.Text = "BASE " .. baseHealth .. "/3"
    yenText.Text = "YEN " .. yen

    timerText.Text = "NEXT WAVE: " .. countdown .. "s"

    autoButton.Text =
        autoSkip and "AUTO SKIP: ON" or "AUTO SKIP: OFF"

    autoButton.BackgroundColor3 =
        autoSkip and COLORS.Green or COLORS.Slot

    autoButton.TextColor3 =
        autoSkip and COLORS.Background or COLORS.White

    skipButton.Text =
        skipRequested and "SKIP REQUESTED" or "SKIP WAVE"
end

local function nextWave()
    if demoFinished then
        return
    end

    skipRequested = false

    if currentWave >= maxWaves then
        demoFinished = true
        timerText.Text = "DEMO COMPLETE"
        skipButton.Text = "FINISHED"
        skipButton.Active = false
        autoButton.Active = false
        notice.Text = "SIMULACAO CONCLUIDA"
        return
    end

    currentWave += 1
    countdown = 10

    -- Yen ficticio para testar o HUD.
    yen += 100

    updateHUD()
end

skipButton.Activated:Connect(function()
    if demoFinished then
        return
    end

    skipRequested = true
    updateHUD()
end)

autoButton.Activated:Connect(function()
    if demoFinished then
        return
    end

    autoSkip = not autoSkip
    updateHUD()
end)

updateHUD()

-- Loop visual local.
-- Nao envia comandos para o servidor.
task.spawn(function()
    while gui.Parent and not demoFinished do
        task.wait(1)

        if not gui.Parent or demoFinished then
            break
        end

        if autoSkip then
            skipRequested = true
        end

        if skipRequested then
            nextWave()
        else
            countdown = math.max(0, countdown - 1)

            if countdown == 0 then
                nextWave()
            else
                updateHUD()
            end
        end
    end
end)

print("[Anime Fissure] HUD DEMO carregado")
print("Dispositivo touch:", UserInputService.TouchEnabled)
