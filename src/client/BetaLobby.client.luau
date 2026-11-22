--!strict
-- ANIME FISSURE | Lobby UI v1.0
-- Terminal de missões responsivo + guia de NPCs. Apenas fases construidas iniciam.
-- Uses LobbyStageConfig (read-only) / LobbyFeedback (server authority).
-- Atualiza o layout para PC, mobile landscape e retrato; sem botoes ficticios.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("LobbyRemotes")
local enterRemote = remotes:WaitForChild("EnterArena") :: RemoteEvent
local feedbackRemote = remotes:WaitForChild("LobbyFeedback") :: RemoteEvent
local StageConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("LobbyStageConfig"))
local catalog = StageConfig.GetCatalog()

local C = {
    Dark = Color3.fromRGB(8, 12, 25),
    Base = Color3.fromRGB(15, 24, 45),
    Inner = Color3.fromRGB(21, 35, 64),
    Ink = Color3.fromRGB(5, 8, 18),
    Border = Color3.fromRGB(59, 108, 184),
    Electric = Color3.fromRGB(56, 123, 255),
    Cyan = Color3.fromRGB(104, 223, 253),
    Purple = Color3.fromRGB(160, 108, 238),
    White = Color3.fromRGB(238, 246, 255),
    Subtle = Color3.fromRGB(168, 186, 218),
    Gold = Color3.fromRGB(245, 196, 107),
    Green = Color3.fromRGB(92, 220, 165),
    Red = Color3.fromRGB(249, 124, 143),
}
local old = playerGui:FindFirstChild("AnimeFissureLobbyUI")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFissureLobbyUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 40
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui:SetAttribute("VisualPolishApplied", true) -- lobby agora tem seu proprio layout
gui:SetAttribute("LobbyVersion", "1.0")
gui.Parent = playerGui

local function round(parent: Instance, radius: number)
    local r = Instance.new("UICorner")
    r.CornerRadius = UDim.new(0, radius)
    r.Parent = parent
end

local function outline(parent: Instance, color: Color3, thick: number, alpha: number?)
    local r = Instance.new("UIStroke")
    r.Color = color
    r.Thickness = thick
    r.Transparency = alpha or 0
    r.Parent = parent
end

local function box(parent: Instance, name: string, color: Color3,
    position: UDim2, size: UDim2, radius: number): Frame
    local b = Instance.new("Frame")
    b.Name = name
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Position = position
    b.Size = size
    b.Parent = parent
    if radius > 0 then round(b, radius) end
    return b
end

local function text(parent: Instance, name: string, value: string, position: UDim2,
    size: UDim2, fontSize: number, color: Color3, bold: boolean?): TextLabel
    local t = Instance.new("TextLabel")
    t.Name = name
    t.BackgroundTransparency = 1
    t.Position = position
    t.Size = size
    t.Font = if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    t.Text = value
    t.TextWrapped = true
    t.TextSize = fontSize
    t.TextColor3 = color
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.Parent = parent
    return t
end

local function button(parent: Instance, name: string, value: string,
    position: UDim2, size: UDim2, color: Color3, fontSize: number): TextButton
    local b = Instance.new("TextButton")
    b.Name = name
    b.Position = position
    b.Size = size
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = value
    b.Font = Enum.Font.GothamBold
    b.TextSize = fontSize
    b.TextWrapped = true
    b.TextColor3 = C.White
    b.AutoButtonColor = true
    b.Selectable = true
    b.Parent = parent
    round(b, 9)
    return b
end

local function gradient(parent: Instance, a: Color3, b: Color3)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(a, b)
    g.Rotation = 90
    g.Parent = parent
end

-- Loading com progresso apenas VISUAL: nao confundir com percentual real de assets.
local loading = box(gui, "Loading", C.Ink, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 0)
loading.ZIndex = 30
local loadingBrand = text(loading, "LoadingBrand", "ANIME FISSURE",
    UDim2.fromScale(0.08, 0.31), UDim2.fromScale(0.84, 0.13), 36, C.White, true)
loadingBrand.TextXAlignment = Enum.TextXAlignment.Center
local loadingDetail = text(loading, "LoadingSubtitle", "SINCRONIZANDO O LOBBY...",
    UDim2.fromScale(0.10, 0.48), UDim2.fromScale(0.80, 0.07), 14, C.Cyan, true)
loadingDetail.TextXAlignment = Enum.TextXAlignment.Center
local loadingBack = box(loading, "LoadingTrack", C.Inner,
    UDim2.fromScale(0.19, 0.61), UDim2.fromScale(0.62, 0.021), 9)
local loadingFill = box(loadingBack, "LoadingFill", C.Electric,
    UDim2.fromScale(0, 0), UDim2.fromScale(0, 1), 9)

-- Brand discreta no topo; nao cobre o centro da praca.
local brand = box(gui, "TopBrand", C.Base,
    UDim2.fromOffset(14, 12), UDim2.fromOffset(260, 70), 12)
outline(brand, C.Electric, 1.4, 0.19)
gradient(brand, C.Inner, C.Dark)
text(brand, "Logo", "ANIME FISSURE", UDim2.fromOffset(15, 7),
    UDim2.fromOffset(231, 29), 20, C.White, true)
text(brand, "Version", "LOBBY 1.0   •   BETA SOLO", UDim2.fromOffset(15, 39),
    UDim2.fromOffset(231, 21), 11, C.Cyan, true)

-- Dock inferior: a praça e os NPCs continuam visiveis e interativos.
local dock = box(gui, "LobbyDock", C.Base,
    UDim2.new(1, -14, 1, -14), UDim2.fromOffset(344, 174), 14)
dock.AnchorPoint = Vector2.new(1, 1)
outline(dock, C.Border, 1.5, 0.10)
gradient(dock, C.Inner, C.Dark)
text(dock, "Title", "TERMINAL DE FISSURAS", UDim2.fromOffset(17, 9),
    UDim2.new(1, -34, 0, 31), 19, C.White, true)
text(dock, "Hint", "Overlord  •  Carne Village",
    UDim2.fromOffset(17, 42), UDim2.new(1, -34, 0, 22), 12, C.Subtle)

local openMissions = button(dock, "OpenMissions", "JOGAR  ·  SELECIONAR FASE",
    UDim2.fromOffset(17, 71), UDim2.new(1, -34, 0, 49), C.Electric, 15)
local guideButton = button(dock, "OpenGuide", "GUIA DO LOBBY",
    UDim2.fromOffset(17, 129), UDim2.new(1, -34, 0, 32), C.Inner, 12)
outline(guideButton, C.Border, 1, 0.20)

local status = box(gui, "LobbyStatus", C.Dark,
    UDim2.new(0, 15, 1, -15), UDim2.fromOffset(285, 44), 10)
status.AnchorPoint = Vector2.new(0, 1)
status.BackgroundTransparency = 0.11
local statusText = text(status, "Status", "Virgil: esquerda  •  Edward: direita",
    UDim2.fromOffset(11, 4), UDim2.new(1, -20, 1, -8), 11, C.Cyan)

-- Overlay nao fica ativo quando o usuario apenas circula pela praca.
local scrim = box(gui, "MissionScrim", C.Ink,
    UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 0)
scrim.BackgroundTransparency = 0.17
scrim.Visible = false
scrim.Active = true
scrim.ZIndex = 8

local window = box(scrim, "MissionsWindow", C.Base,
    UDim2.fromScale(0.5, 0.5), UDim2.new(1, -24, 1, -24), 16)
window.AnchorPoint = Vector2.new(0.5, 0.5)
window.ZIndex = 9
window.ClipsDescendants = true
outline(window, C.Electric, 2, 0.02)
gradient(window, C.Inner, C.Dark)
local maxSize = Instance.new("UISizeConstraint")
maxSize.MaxSize = Vector2.new(1000, 630)
maxSize.MinSize = Vector2.new(290, 280)
maxSize.Parent = window

local windowHeader = box(window, "Header", C.Dark,
    UDim2.fromScale(0, 0), UDim2.new(1, 0, 0, 62), 0)
text(windowHeader, "HeaderTitle", "FISSURE TERMINAL  /  MUNDO 01",
    UDim2.fromOffset(18, 8), UDim2.new(1, -105, 0, 26), 18, C.Cyan, true)
text(windowHeader, "HeaderSub", "OVERLORD    •    SELECIONE UMA FASE",
    UDim2.fromOffset(18, 35), UDim2.new(1, -110, 0, 20), 11, C.Subtle)
local closeWindow = button(windowHeader, "Close", "X",
    UDim2.new(1, -54, 0, 10), UDim2.fromOffset(42, 42), C.Inner, 17)
outline(closeWindow, C.Border, 1)

local body = box(window, "MissionsBody", C.Dark,
    UDim2.fromOffset(14, 76), UDim2.new(1, -28, 1, -161), 12)
body.BackgroundTransparency = 1

local listHolder = box(body, "StageListHolder", C.Dark,
    UDim2.fromScale(0, 0), UDim2.new(0.43, -4, 1, 0), 9)
outline(listHolder, C.Border, 1, 0.38)
text(listHolder, "ListHeading", "FASES DE OVERLORD",
    UDim2.fromOffset(12, 6), UDim2.new(1, -20, 0, 28), 14, C.Gold, true)
local stageScroll = Instance.new("ScrollingFrame")
stageScroll.Name = "StageScroll"
stageScroll.Position = UDim2.fromOffset(8, 38)
stageScroll.Size = UDim2.new(1, -16, 1, -45)
stageScroll.BackgroundTransparency = 1
stageScroll.BorderSizePixel = 0
stageScroll.ScrollBarThickness = 4
stageScroll.ScrollBarImageColor3 = C.Cyan
stageScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
stageScroll.CanvasSize = UDim2.fromScale(0, 0)
stageScroll.Parent = listHolder
local stageListLayout = Instance.new("UIListLayout")
stageListLayout.Padding = UDim.new(0, 7)
stageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
stageListLayout.Parent = stageScroll
local stageListPadding = Instance.new("UIPadding")
stageListPadding.PaddingBottom = UDim.new(0, 7)
stageListPadding.PaddingRight = UDim.new(0, 5)
stageListPadding.Parent = stageScroll

local details = box(body, "StageDetails", C.Inner,
    UDim2.new(0.43, 8, 0, 0), UDim2.new(0.57, -8, 1, 0), 10)
outline(details, C.Purple, 1.5, 0.28)

local stageHeading = text(details, "StageHeading", "CARNE VILLAGE",
    UDim2.fromOffset(18, 13), UDim2.new(1, -36, 0, 40), 22, C.White, true)
local stageStatus = text(details, "StageStatus", "JOGAVEL",
    UDim2.fromOffset(18, 54), UDim2.new(1, -36, 0, 24), 13, C.Green, true)
local bossLabel = text(details, "Boss", "CHEFE FINAL: NIGUN GRID LUIN",
    UDim2.fromOffset(18, 89), UDim2.new(1, -36, 0, 36), 13, C.Gold, true)
local waveCount = text(details, "Waves", "CLASSIC: 15 WAVES",
    UDim2.fromOffset(18, 125), UDim2.new(1, -36, 0, 29), 13, C.White, true)
local rewardLabel = text(details, "Rewards", "",
    UDim2.fromOffset(18, 169), UDim2.new(1, -36, 0, 58), 12, C.Cyan)
local notice = text(details, "RewardsNotice", "",
    UDim2.fromOffset(18, 233), UDim2.new(1, -36, 0, 61), 12, C.Subtle)

-- Modos ficam na faixa inferior e sao sempre clicaveis com mouse/toque/controle.
local footer = box(window, "Footer", C.Dark, UDim2.new(0, 0, 1, -75),
    UDim2.new(1, 0, 0, 75), 0)
local classic = button(footer, "ClassicMode", "CLASSIC  ·  15",
    UDim2.new(0, 13, 0, 13), UDim2.new(0.28, -9, 0, 48), C.Electric, 13)
local hard = button(footer, "HardMode", "HARD  ·  20",
    UDim2.new(0.28, 10, 0, 13), UDim2.new(0.27, -10, 0, 48), C.Inner, 13)
local play = button(footer, "EnterSelected", "INICIAR",
    UDim2.new(0.57, 4, 0, 13), UDim2.new(0.43, -18, 0, 48), C.Green, 14)
outline(classic, C.Border, 1, 0.12)
outline(hard, C.Border, 1, 0.12)

local guide = box(gui, "GuideScrim", C.Ink,
    UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 0)
guide.BackgroundTransparency = 0.25
guide.Active = true
guide.Visible = false
guide.ZIndex = 10
local guideWindow = box(guide, "GuideWindow", C.Base,
    UDim2.fromScale(0.5, 0.5), UDim2.new(1, -40, 0, 286), 13)
guideWindow.AnchorPoint = Vector2.new(0.5, 0.5)
outline(guideWindow, C.Purple, 1.5)
local guideLimit = Instance.new("UISizeConstraint")
guideLimit.MaxSize = Vector2.new(500, 320)
guideLimit.Parent = guideWindow
text(guideWindow, "GuideTitle", "GUIA DO LOBBY",
    UDim2.fromOffset(18, 14), UDim2.new(1, -36, 0, 32), 21, C.Cyan, true)
text(guideWindow, "GuideBody",
    "PORTAL: abra o terminal e escolha uma fase.\n\nVIRGIL: aproxime-se e pressione E (ou toque) para conversar e invocar.\n\nEDWARD: aproxime-se para explorar a oficina de alquimia.\n\nCOLECAO/DECKS: interface completa em desenvolvimento.",
    UDim2.fromOffset(18, 53), UDim2.new(1, -36, 1, -113), 14, C.White)
local guideClose = button(guideWindow, "GuideClose", "ENTENDI",
    UDim2.new(0, 18, 1, -52), UDim2.new(1, -36, 0, 38), C.Electric, 14)

local selectedId = "OVL_01"
local selectedMode = "Classic"
local waiting = false
local loadingDone = false
local stageButtons: {[string]: TextButton} = {}

local function findStage(id: string): any
    for _, stage in ipairs(catalog) do
        if stage.Id == id then return stage end
    end
    return nil
end

local function syncSelection()
    local stage = findStage(selectedId)
    if not stage then return end
    for id, b in pairs(stageButtons) do
        local selected = id == selectedId
        b.BackgroundColor3 = if selected then C.Electric else C.Inner
        b.TextColor3 = if selected then C.White else C.Subtle
    end
    stageHeading.Text = stage.Name
    stageStatus.Text = if stage.Playable then "PRONTA PARA TESTE  ·  BETA" else "EM DESENVOLVIMENTO"
    stageStatus.TextColor3 = if stage.Playable then C.Green else C.Red
    bossLabel.Text = "CHEFE: " .. tostring(stage.Boss)
    waveCount.Text = if stage.Playable then
        (selectedMode .. "  •  " .. (selectedMode == "Hard" and "20" or "15") .. " WAVES")
        else "MAPA AINDA NAO IMPLEMENTADO"

    local reward = StageConfig.GetRewardPreview(selectedId, selectedMode)
    if reward then
        rewardLabel.Text = string.format(
            "GOLD  +%d    |    FRAGMENTOS  +%d\nINSIGNIA SOLAR  %.0f%%    ·    HARD PITY %d",
            reward.Gold, reward.Fragments, reward.Chance * 100, reward.HardPity
        )
        notice.Text = "Recompensas planejadas; entrega e inventario ainda nao conectados.\nBeta: uma partida por servidor, sem replay automatico."
    else
        rewardLabel.Text = "Recompensas nao configuradas."
        notice.Text = "A fase aparece no catalogo, mas ainda nao pode ser iniciada."
    end
    classic.BackgroundColor3 = if selectedMode == "Classic" then C.Electric else C.Inner
    hard.BackgroundColor3 = if selectedMode == "Hard" then C.Purple else C.Inner
    play.Active = stage.Playable and not waiting
    play.AutoButtonColor = stage.Playable and not waiting
    play.BackgroundColor3 = if stage.Playable then C.Green else C.Dark
    play.Text = if waiting then "ENTRANDO..." elseif stage.Playable
        then "INICIAR " .. string.upper(selectedMode) else "INDISPONIVEL"
end

for i, stage in ipairs(catalog) do
    local statusSuffix = if stage.Playable then " [BETA]" else " [EM BREVE]"
    local card = button(stageScroll, "Stage_" .. stage.Id,
        string.format("%02d  %s%s", i, stage.Name, statusSuffix),
        UDim2.fromOffset(0, 0), UDim2.new(1, -3, 0, 67), C.Inner, 13)
    card.LayoutOrder = i
    card.TextXAlignment = Enum.TextXAlignment.Left
    card.TextWrapped = true
    card.TextSize = 13
    stageButtons[stage.Id] = card
    card.Activated:Connect(function()
        if waiting then return end
        selectedId = stage.Id
        syncSelection()
    end)
end

classic.Activated:Connect(function()
    if waiting then return end
    selectedMode = "Classic"
    syncSelection()
end)
hard.Activated:Connect(function()
    if waiting then return end
    selectedMode = "Hard"
    syncSelection()
end)

local function openWindow()
    if waiting then return end
    guide.Visible = false
    scrim.Visible = true
    syncSelection()
end
local function closeMissionWindow()
    if waiting then return end
    scrim.Visible = false
end

openMissions.Activated:Connect(openWindow)
closeWindow.Activated:Connect(closeMissionWindow)
guideButton.Activated:Connect(function()
    scrim.Visible = false
    guide.Visible = true
end)
guideClose.Activated:Connect(function() guide.Visible = false end)

play.Activated:Connect(function()
    if waiting then return end
    local stage = findStage(selectedId)
    if not stage or not stage.Playable then return end
    waiting = true
    syncSelection()
    statusText.Text = "Validando entrada no servidor..."
    enterRemote:FireServer(selectedId, selectedMode)
    task.delay(8, function()
        if waiting and player:GetAttribute("InArena") ~= true then
            waiting = false
            statusText.Text = "Sem resposta do servidor. Tente novamente."
            syncSelection()
        end
    end)
end)

feedbackRemote.OnClientEvent:Connect(function(kind: any, message: any)
    if typeof(kind) ~= "string" or typeof(message) ~= "string" then return end
    statusText.Text = message
    statusText.TextColor3 = if kind == "Accepted" then C.Green else C.Gold
    if kind ~= "Accepted" then
        waiting = false
        syncSelection()
    end
end)

local function syncVisibility()
    local inArena = player:GetAttribute("InArena") == true
    gui.Enabled = not inArena
    if inArena then
        waiting = false
        scrim.Visible = false
        guide.Visible = false
    end
end
player:GetAttributeChangedSignal("InArena"):Connect(syncVisibility)

local function resize()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local v = camera.ViewportSize
    local short = v.X < 690
    local compact = v.Y < 460

    if short then
        brand.Size = UDim2.fromOffset(216, 61)
        dock.Size = UDim2.fromOffset(284, 164)
        dock.Position = UDim2.new(1, -10, 1, -10)
        status.Visible = false
        stageScroll.ScrollBarThickness = 3
        listHolder.Position = UDim2.fromScale(0, 0)
        listHolder.Size = UDim2.new(1, 0, 0.43, -4)
        details.Position = UDim2.new(0, 0, 0.43, 8)
        details.Size = UDim2.new(1, 0, 0.57, -8)
    else
        brand.Size = UDim2.fromOffset(260, 70)
        dock.Size = UDim2.fromOffset(344, 174)
        dock.Position = UDim2.new(1, -14, 1, -14)
        status.Visible = true
        listHolder.Position = UDim2.fromScale(0, 0)
        listHolder.Size = UDim2.new(0.43, -4, 1, 0)
        details.Position = UDim2.new(0.43, 8, 0, 0)
        details.Size = UDim2.new(0.57, -8, 1, 0)
    end

    if compact then
        stageHeading.TextSize = 17
        bossLabel.TextSize = 11
        rewardLabel.TextSize = 11
        notice.TextSize = 10
    else
        stageHeading.TextSize = 22
        bossLabel.TextSize = 13
        rewardLabel.TextSize = 12
        notice.TextSize = 12
    end

    -- Em telas baixas, reduz espacamento interno sem diminuir area de toque.
    if compact then
        body.Position = UDim2.fromOffset(14, 63)
        body.Size = UDim2.new(1, -28, 1, -137)
        windowHeader.Size = UDim2.new(1, 0, 0, 55)
        footer.Size = UDim2.new(1, 0, 0, 68)
        footer.Position = UDim2.new(0, 0, 1, -68)
        bossLabel.Position = UDim2.fromOffset(18, 76)
        waveCount.Position = UDim2.fromOffset(18, 105)
        rewardLabel.Position = UDim2.fromOffset(18, 136)
        notice.Position = UDim2.fromOffset(18, 191)
    else
        body.Position = UDim2.fromOffset(14, 76)
        body.Size = UDim2.new(1, -28, 1, -161)
        windowHeader.Size = UDim2.new(1, 0, 0, 62)
        footer.Size = UDim2.new(1, 0, 0, 75)
        footer.Position = UDim2.new(0, 0, 1, -75)
        bossLabel.Position = UDim2.fromOffset(18, 89)
        waveCount.Position = UDim2.fromOffset(18, 125)
        rewardLabel.Position = UDim2.fromOffset(18, 169)
        notice.Position = UDim2.fromOffset(18, 233)
    end
end

local function bindCamera()
    local camera = Workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
    end
    resize()
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
bindCamera()

syncSelection()
syncVisibility()

if not game:IsLoaded() then game.Loaded:Wait() end
local tween = TweenService:Create(loadingFill, TweenInfo.new(1.1, Enum.EasingStyle.Quart),
    {Size = UDim2.fromScale(1, 1)})
tween:Play()
tween.Completed:Wait()
loadingDetail.Text = "LOBBY PRONTO"
task.wait(0.15)
loading.Visible = false
loadingDone = true

print("[Anime Fissure] Lobby v1.0 pronto: catalogo Overlord + modos Classic/Hard")
