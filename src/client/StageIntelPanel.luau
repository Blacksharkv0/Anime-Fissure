--!strict
-- ANIME FISSURE | StageIntelPanel v0.9
-- Modulo integrado diretamente ao ScreenGui do BetaHUD (sem GUI duplicada).
-- Nao cria dados de pity ou inventario; preview so no Roblox Studio.

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local StageIntelPanel = {}

function StageIntelPanel.Attach(gui: ScreenGui)
    local STUDIO = RunService:IsStudio()

local C = {
    Dark = Color3.fromRGB(9, 13, 26),
    Panel = Color3.fromRGB(15, 25, 49),
    Card = Color3.fromRGB(23, 37, 68),
    Line = Color3.fromRGB(58, 98, 156),
    Blue = Color3.fromRGB(56, 123, 255),
    Cyan = Color3.fromRGB(98, 222, 255),
    White = Color3.fromRGB(241, 247, 255),
    Muted = Color3.fromRGB(166, 188, 221),
    Gold = Color3.fromRGB(246, 196, 103),
    Green = Color3.fromRGB(83, 221, 153),
    Purple = Color3.fromRGB(161, 112, 241),
}

local function corner(parent: Instance, px: number)
    local item = Instance.new("UICorner")
    item.CornerRadius = UDim.new(0, px)
    item.Parent = parent
end

local function stroke(parent: Instance, color: Color3, size: number, transparency: number?)
    local item = Instance.new("UIStroke")
    item.Color = color
    item.Thickness = size
    item.Transparency = transparency or 0
    item.Parent = parent
end

local function frame(parent: Instance, name: string, size: UDim2, position: UDim2,
    color: Color3): Frame
    local item = Instance.new("Frame")
    item.Name = name
    item.Size = size
    item.Position = position
    item.BorderSizePixel = 0
    item.BackgroundColor3 = color
    item.Parent = parent
    return item
end

local function label(parent: Instance, name: string, value: string, pos: UDim2,
    size: UDim2, fontSize: number, color: Color3, bold: boolean?): TextLabel
    local t = Instance.new("TextLabel")
    t.Name = name
    t.Position = pos
    t.Size = size
    t.BackgroundTransparency = 1
    t.Font = if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    t.Text = value
    t.TextSize = fontSize
    t.TextColor3 = color
    t.TextWrapped = true
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.Parent = parent
    return t
end

local function safeText(value: any, fallback: string): string
    return if typeof(value) == "string" and value ~= "" then value else fallback
end

local function safeInt(value: any): number?
    if typeof(value) ~= "number" or value ~= value
        or value == math.huge or value == -math.huge then return nil end
    return math.max(0, math.floor(value))
end

local root = frame(gui, "StageInfoDock", UDim2.fromOffset(177, 44),
    UDim2.new(1, -12, 0, 114), C.Panel)
root.ZIndex = 10
root.BackgroundTransparency = 0.04
root.ClipsDescendants = true

local topGlow = Instance.new("UIGradient")
topGlow.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(23, 47, 94)),
    ColorSequenceKeypoint.new(1, C.Dark),
})
topGlow.Rotation = 90
topGlow.Parent = root
root.AnchorPoint = Vector2.new(1, 0)
corner(root, 11)
stroke(root, C.Blue, 1.6, 0.05)

local scale = Instance.new("UIScale")
scale.Parent = root

local header = Instance.new("TextButton")
header.Name = "StageInfoToggle"
header.Size = UDim2.new(1, -8, 0, 38)
header.Position = UDim2.fromOffset(4, 3)
header.BackgroundColor3 = C.Dark
header.BorderSizePixel = 0
header.TextColor3 = C.Cyan
header.Text = "ⓘ  STAGE INFO   ▾"
header.ZIndex = 11
header.TextStrokeTransparency = 0.78
header.Font = Enum.Font.GothamBold
header.TextSize = 15
header.AutoButtonColor = true
header.Parent = root
corner(header, 9)

local scroll = Instance.new("ScrollingFrame")
scroll.Name = "StageInfoContent"
scroll.Position = UDim2.fromOffset(8, 49)
scroll.Size = UDim2.new(1, -16, 1, -57)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = C.Cyan
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.fromOffset(0, 0)
scroll.Visible = false
scroll.ZIndex = 11
scroll.Parent = root

local layout = Instance.new("UIListLayout")
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 9)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = scroll

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 4)
padding.PaddingBottom = UDim.new(0, 9)
padding.PaddingLeft = UDim.new(0, 3)
padding.PaddingRight = UDim.new(0, 8)
padding.Parent = scroll

local expanded = false
local lastKey = ""
local lastInfo: any = nil
local latestWave = 0
local previewStep = 0 -- 0: ainda nao; 1: obteve e reiniciou; 2: obteve e progrediu

local function resize()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local v = camera.ViewportSize
    if expanded then
        -- Abaixo do painel superior de recursos; espaço para o HUD inferior.
        scale.Scale = math.clamp(math.min(
            (v.X - 26) / 360,
            (v.Y - 148) / 500,
            1
        ), 0.46, 1)
    else
        -- Botao de abertura sempre legivel inclusive no celular.
        scale.Scale = math.clamp((v.X - 18) / 240, 0.86, 1)
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

local function setExpanded(value: boolean)
    expanded = value
    header.Text = if expanded then "ⓘ  STAGE INFO        ▴" else "ⓘ  STAGE INFO   ▾"
    scroll.Visible = expanded
    resize()
    local targetSize = if expanded then UDim2.fromOffset(348, 490) else UDim2.fromOffset(177, 44)
    TweenService:Create(root, TweenInfo.new(0.20, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = targetSize,
    }):Play()
end

header.Activated:Connect(function()
    setExpanded(not expanded)
end)

local function section(titleText: string, height: number, order: number): Frame
    local card = frame(scroll, "Section" .. tostring(order),
        UDim2.new(1, -2, 0, height), UDim2.fromOffset(0, 0), C.Card)
    card.LayoutOrder = order
    corner(card, 9)
    stroke(card, C.Line, 1, 0.38)
    label(card, "SectionHeading", titleText, UDim2.fromOffset(12, 6),
        UDim2.new(1, -24, 0, 24), 12, C.Cyan, true)
    return card
end

local function clearSections()
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
end

local function render(info: any, keepScroll: boolean?)
    local previousScroll = scroll.CanvasPosition
    clearSections()
    if typeof(info) ~= "table" then
        local missing = section("STAGE INFO", 93, 1)
        label(missing, "Missing", "Aguardando dados da fase...", UDim2.fromOffset(12, 32),
            UDim2.new(1, -24, 0, 47), 13, C.Muted)
        return
    end

    local basic = section("FASE", 153, 1)
    label(basic, "StageName", safeText(info.Name, "Fase"), UDim2.fromOffset(12, 34),
        UDim2.new(1, -24, 0, 27), 20, C.White, true)
    label(basic, "Difficulty",
        "Overlord  •  " .. (info.Difficulty == "Hard" and "HARD" or "NORMAL")
            .. "  •  " .. tostring(safeInt(info.Waves) or 15) .. " waves",
        UDim2.fromOffset(12, 62), UDim2.new(1, -24, 0, 21), 12, C.Muted)
    label(basic, "CurrentWave",
        string.format("WAVE ATUAL  %02d / %02d", latestWave,
            safeInt(info.Waves) or 15),
        UDim2.fromOffset(12, 89),
        UDim2.new(1, -24, 0, 22), 13, C.Cyan, true)
    local element = if info.ElementConfigured == true then safeText(info.Element, "Indefinido")
        else "Elemento: ainda nao definido"
    label(basic, "Element", element, UDim2.fromOffset(12, 115),
        UDim2.new(1, -24, 0, 24), 13, C.Gold, true)

    local enemies = if typeof(info.Enemies) == "table" then info.Enemies else {}
    local enemyCount = math.min(#enemies, 20)
    local enemiesCard = section("INIMIGOS DA FASE", 37 + enemyCount * 31, 2)
    for index = 1, enemyCount do
        local entry = enemies[index]
        if typeof(entry) == "table" then
            local y = 32 + (index - 1) * 31
            local isBoss = entry.Category == "MiniBoss" or entry.Category == "MainBoss"
            label(enemiesCard, "Enemy_" .. index,
                (isBoss and "★ " or "• ") .. safeText(entry.Name, "?"),
                UDim2.fromOffset(12, y), UDim2.new(1, -123, 0, 28),
                12, isBoss and C.Gold or C.White, isBoss)
            local when = label(enemiesCard, "Appearance_" .. index,
                safeText(entry.Appears, "--"),
                UDim2.new(1, -130, 0, y), UDim2.fromOffset(118, 28), 10, C.Muted)
            when.TextXAlignment = Enum.TextXAlignment.Right
        end
    end

    local rewards = if typeof(info.Rewards) == "table" then info.Rewards else {}
    local rewardCount = math.min(#rewards, 12)
    local rewardsCard = section("RECOMPENSAS PREVISTAS", 82 + rewardCount * 32, 3)
    for index = 1, rewardCount do
        local entry = rewards[index]
        if typeof(entry) == "table" then
            local y = 31 + (index - 1) * 32
            local value = safeInt(entry.Amount)
            label(rewardsCard, "Reward_" .. index, "✦ " .. safeText(entry.Name, "?"),
                UDim2.fromOffset(12, y), UDim2.new(1, -92, 0, 27), 12, C.White)
            local amountLabel = label(rewardsCard, "Amount_" .. index,
                value and ("+" .. tostring(value)) or "--",
                UDim2.new(1, -83, 0, y), UDim2.fromOffset(69, 27), 12, C.Gold, true)
            amountLabel.TextXAlignment = Enum.TextXAlignment.Right
        end
    end
    label(rewardsCard, "NotYet",
        "XP: nao configurado  •  entrega ainda desativada",
        UDim2.fromOffset(12, 37 + rewardCount * 32),
        UDim2.new(1, -22, 0, 32), 10, C.Muted)

    local drops = if typeof(info.SpecialDrops) == "table" then info.SpecialDrops else {}
    local dropCount = math.min(#drops, 12)
    local rareCard = section("DROPS RAROS / HARD PITY", 58 + dropCount * 81
        + (STUDIO and 74 or 0), 4)

    for index = 1, dropCount do
        local drop = drops[index]
        if typeof(drop) == "table" then
            local y = 32 + (index - 1) * 81
            local iconBg = frame(rareCard, "DropIcon_" .. index,
                UDim2.fromOffset(49, 49), UDim2.fromOffset(12, y + 3), C.Dark)
            corner(iconBg, 7)
            stroke(iconBg, C.Purple, 1)
            label(iconBg, "Gem", "✦", UDim2.fromOffset(0, 0),
                UDim2.fromScale(1, 1), 28, C.Gold, true).TextXAlignment =
                Enum.TextXAlignment.Center

            local owned = drop.Obtained == true
            local current = safeInt(drop.Current)
            local needed = safeInt(drop.Needed) or 0
            local demo = STUDIO and index == 1 and drop.ProgressConnected ~= true
            if demo then
                owned = previewStep >= 1
                current = if previewStep == 2 then 3 else 0
            end

            if owned then
                local check = frame(iconBg, "ObtainedMark", UDim2.fromOffset(23, 23),
                    UDim2.new(1, -20, 0, -5), C.Green)
                corner(check, 12)
                label(check, "Tick", "✓", UDim2.fromOffset(0, 0),
                    UDim2.fromScale(1, 1), 16, C.Dark, true).TextXAlignment =
                    Enum.TextXAlignment.Center
            end

            label(rareCard, "DropName_" .. index,
                safeText(drop.Name, safeText(drop.Id, "Item raro")),
                UDim2.fromOffset(72, y + 1),
                UDim2.new(1, -83, 0, 25), 14, C.White, true)
            local ratio = if current ~= nil then
                tostring(math.min(current, needed)) .. "/" .. tostring(needed)
                else "--/" .. tostring(needed)
            local line = if owned then "✓ Obtido  •  Proximo pity: " .. ratio
                elseif current ~= nil then "Nao obtido  •  " .. ratio
                else "Pity ainda nao conectado: " .. ratio
            label(rareCard, "DropPity_" .. index, line,
                UDim2.fromOffset(72, y + 29),
                UDim2.new(1, -83, 0, 24), 11, owned and C.Green or C.Muted)
            local chance = if typeof(drop.Chance) == "number"
                then string.format("Chance: %.0f%%", drop.Chance * 100)
                else "Chance a definir"
            label(rareCard, "DropChance_" .. index, chance,
                UDim2.fromOffset(72, y + 52),
                UDim2.new(1, -83, 0, 19), 10, C.Gold)
        end
    end

    if STUDIO then
        local demoNoteY = 33 + dropCount * 81
        label(rareCard, "StudioWarning", "MODO STUDIO: preview local, nao concede itens",
            UDim2.fromOffset(10, demoNoteY), UDim2.new(1, -20, 0, 26),
            10, C.Muted, true)
        local test = Instance.new("TextButton")
        test.Name = "PreviewPity"
        test.Text = "SIMULAR CHECK / PROXIMO PITY"
        test.Size = UDim2.new(1, -20, 0, 34)
        test.Position = UDim2.fromOffset(10, demoNoteY + 30)
        test.BackgroundColor3 = C.Blue
        test.TextColor3 = C.White
        test.Font = Enum.Font.GothamBold
        test.TextSize = 11
        test.Parent = rareCard
        corner(test, 8)
        test.Activated:Connect(function()
            previewStep = (previewStep + 1) % 3
            render(info, true)
        end)
    end

    scroll.CanvasPosition = if keepScroll then previousScroll else Vector2.new(0, 0)
end

-- Somente o HUD principal recebe os updates do servidor.
-- Assim as waves e o Stage Info sao sincronizados com um unico stream.
local function update(info: any, wave: number?)
    if typeof(info) ~= "table" then
        if lastKey ~= "__missing" then
            lastKey = "__missing"
            render(nil)
        end
        return
    end
    local drop = if typeof(info.SpecialDrops) == "table" then info.SpecialDrops[1] else nil
    local signature = tostring(info.StageId) .. "|" .. tostring(info.Difficulty)
        .. "|" .. tostring(info.Element)
    if typeof(drop) == "table" then
        signature ..= "|" .. tostring(drop.Current) .. "|" .. tostring(drop.Obtained)
            .. "|" .. tostring(drop.Needed)
    end
    -- A informacao de wave usa o mesmo snapshot que atualiza o HUD principal.
    local waveValue = if typeof(wave) == "number" then math.floor(wave) else 0
    latestWave = math.max(0, waveValue)
    signature ..= "|wave:" .. tostring(waveValue)
    if signature ~= lastKey then
        local resetPreview = (lastInfo == nil or lastInfo.StageId ~= info.StageId)
        if resetPreview then previewStep = 0 end
        lastKey = signature
        lastInfo = info
        render(info, expanded)
    end
end

setExpanded(false)
render(nil)

return {
    Update = update,
    Close = function()
        setExpanded(false)
    end,
    GetRoot = function()
        return root
    end,
}
end

return StageIntelPanel
