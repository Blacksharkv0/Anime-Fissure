--!strict
-- ANIME FISSURE | TowerHUD v1.3
-- Deck beta de 6 slots e card de info detalhado ao selecionar Tower.
-- Clique/toque no slot e depois na grama para colocar, em PC e mobile.
-- Upgrade/venda so por serial de torre propria (server verifica tudo).
-- HUD da arena e StageInfo continuam intactos.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("TowerRemotes")
local request = remotes:WaitForChild("TowerRequest") :: RemoteEvent
local stateRemote = remotes:WaitForChild("TowerState") :: RemoteEvent

local C = {
    Dark = Color3.fromRGB(9, 14, 30),
    Panel = Color3.fromRGB(17, 27, 53),
    Inner = Color3.fromRGB(26, 40, 72),
    Blue = Color3.fromRGB(56, 123, 255),
    Cyan = Color3.fromRGB(91, 220, 247),
    Purple = Color3.fromRGB(166, 112, 244),
    Gold = Color3.fromRGB(250, 199, 112),
    White = Color3.fromRGB(239, 245, 255),
    Muted = Color3.fromRGB(159, 183, 214),
    Green = Color3.fromRGB(96, 222, 152),
    Red = Color3.fromRGB(255, 113, 140),
}

local old = playerGui:FindFirstChild("AnimeFissureTowers")
if old then old:Destroy() end
local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFissureTowers"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.DisplayOrder = 22
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = player:GetAttribute("InArena") == true
gui.Parent = playerGui

local function round(parent: Instance, px: number)
    local r = Instance.new("UICorner")
    r.CornerRadius = UDim.new(0, px)
    r.Parent = parent
end

local function border(parent: Instance, color: Color3, thickness: number)
    local r = Instance.new("UIStroke")
    r.Color = color
    r.Thickness = thickness
    r.Transparency = 0.18
    r.Parent = parent
    return r
end

local function frame(parent: Instance, name: string, pos: UDim2,
    size: UDim2, color: Color3): Frame
    local f = Instance.new("Frame")
    f.Name = name
    f.Position = pos
    f.Size = size
    f.BackgroundColor3 = color
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end

local function text(parent: Instance, name: string, content: string, pos: UDim2,
    size: UDim2, fontSize: number, color: Color3): TextLabel
    local t = Instance.new("TextLabel")
    t.Name = name
    t.Position = pos
    t.Size = size
    t.BackgroundTransparency = 1
    t.Text = content
    t.Font = Enum.Font.GothamBold
    t.TextSize = fontSize
    t.TextColor3 = color
    t.TextWrapped = true
    t.TextXAlignment = Enum.TextXAlignment.Center
    t.TextYAlignment = Enum.TextYAlignment.Center
    t.Parent = parent
    return t
end

local function button(parent: Instance, name: string, value: string,
    pos: UDim2, size: UDim2, color: Color3): TextButton
    local b = Instance.new("TextButton")
    b.Name = name
    b.Text = value
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.TextWrapped = true
    b.TextColor3 = C.White
    b.Position = pos
    b.Size = size
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Parent = parent
    round(b, 8)
    return b
end

local bar = frame(gui, "DeckBar", UDim2.new(0.5, 0, 1, -13),
    UDim2.fromOffset(556, 122), C.Panel)
bar.AnchorPoint = Vector2.new(0.5, 1)
round(bar, 11)
border(bar, C.Blue, 1.5)
local barScale = Instance.new("UIScale")
barScale.Parent = bar

local deckTitle = text(bar, "DeckTitle", "DECK DE COMBATE  •  BETA",
    UDim2.fromOffset(12, 3), UDim2.fromOffset(350, 23), 13, C.Cyan).TextXAlignment =
    Enum.TextXAlignment.Left
local yen = text(bar, "Yen", "¥ 700",
    UDim2.fromOffset(382, 3), UDim2.fromOffset(158, 23), 15, C.Gold)
yen.TextXAlignment = Enum.TextXAlignment.Right
local hint = text(bar, "PlaceHint", "Selecione uma Tower e toque no terreno livre",
    UDim2.fromOffset(12, 98), UDim2.fromOffset(520, 20), 11, C.Muted)

-- Tower info card: name / rarity / damage-range-SPA /
-- upgrade pips / attack style / passive and conditional synergy.
-- Layout scales to landscape and mobile portrait; the action buttons
-- are protected both client-side and by the authoritative server.
local management = frame(gui, "TowerManagement",
    UDim2.new(0.5, 0, 1, -195), UDim2.fromOffset(520, 251), C.Panel)
management.AnchorPoint = Vector2.new(0.5, 1)
management.Visible = false
round(management, 12)
border(management, C.Purple, 1.4)
local managementScale = Instance.new("UIScale")
managementScale.Parent = management

local selectedTitle = text(management, "SelectedUnit", "UNIDADE",
    UDim2.fromOffset(14, 9), UDim2.fromOffset(345, 29), 16, C.White)
selectedTitle.TextXAlignment = Enum.TextXAlignment.Left
local rarityBackground = frame(management, "RarityBackground",
    UDim2.fromOffset(370, 9), UDim2.fromOffset(135, 29), C.Inner)
round(rarityBackground, 8)
local rarityLabel = text(rarityBackground, "Rarity", "BETA",
    UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 13, C.White)
local rarityColors: {[string]: Color3} = {
    Common = Color3.fromRGB(115, 169, 159),
    Rare = Color3.fromRGB(74, 149, 248),
    Epic = Color3.fromRGB(155, 100, 249),
    Legendary = Color3.fromRGB(245, 180, 76),
    Mythic = Color3.fromRGB(239, 105, 152),
    Secret = Color3.fromRGB(190, 94, 246),
    Beta = C.Blue,
}
local statsBacking = frame(management, "StatsBacking",
    UDim2.fromOffset(12, 45), UDim2.fromOffset(496, 51), C.Inner)
round(statsBacking, 8)
local function stat(x: number, name: string, labelText: string)
    local label = text(statsBacking, name .. "Label", labelText,
        UDim2.fromOffset(x, 3), UDim2.fromOffset(160, 18), 10, C.Muted)
    local value = text(statsBacking, name .. "Value", "—",
        UDim2.fromOffset(x, 20), UDim2.fromOffset(160, 27), 18, C.White)
    return label, value
end
local damageLabel, damageValue = stat(2, "Damage", "DANO")
local _, rangeValue = stat(167, "Range", "RANGE")
local _, spaValue = stat(331, "SPA", "SPA")
local upgradesLabel = text(management, "UpgradeProgress", "UPGRADES 0/9",
    UDim2.fromOffset(14, 99), UDim2.fromOffset(491, 22), 12, C.Gold)
upgradesLabel.TextXAlignment = Enum.TextXAlignment.Left

local dots: {Frame} = {}
for i = 1, 12 do
    local dot = frame(management, "UpgradeDot_" .. tostring(i),
        UDim2.fromOffset(76 + (i - 1) * 30, 123),
        UDim2.fromOffset(18, 18), C.Dark)
    round(dot, 12)
    border(dot, if i % 3 == 0 then C.Gold else C.Muted, 1.0)
    dots[i] = dot
end
local attackLabel = text(management, "AttackName", "ATTACK: -- (SINGLE)",
    UDim2.fromOffset(14, 145), UDim2.fromOffset(490, 25), 13, C.Cyan)
attackLabel.TextXAlignment = Enum.TextXAlignment.Left
local passiveLabel = text(management, "Passive", "",
    UDim2.fromOffset(14, 171), UDim2.fromOffset(490, 19), 11, C.Gold)
passiveLabel.TextXAlignment = Enum.TextXAlignment.Left
local synergyLabel = text(management, "PairSynergy", "",
    UDim2.fromOffset(14, 190), UDim2.fromOffset(490, 19), 11, C.Green)
synergyLabel.TextXAlignment = Enum.TextXAlignment.Left
local upgradeButton = button(management, "Upgrade", "UPGRADE",
    UDim2.fromOffset(10, 214), UDim2.fromOffset(238, 29), C.Blue)
local sellButton = button(management, "Sell", "VENDER",
    UDim2.fromOffset(259, 214), UDim2.fromOffset(153, 29), C.Purple)
local closeManage = button(management, "CloseSelection", "X",
    UDim2.fromOffset(423, 214), UDim2.fromOffset(86, 29), C.Dark)

local slotButtons: {[number]: TextButton} = {}
for i = 1, 6 do
    local x = 10 + (i - 1) * 91
    local cell = button(bar, "Slot_" .. i, "SLOT " .. i,
        UDim2.fromOffset(x, 29), UDim2.fromOffset(82, 66), C.Inner)
    cell.TextSize = 12
    slotButtons[i] = cell
end

local lab = frame(gui, "StudioLabControls",
    UDim2.new(0.5, 0, 1, -141), UDim2.fromOffset(556, 41), C.Panel)
lab.AnchorPoint = Vector2.new(0.5, 1)
lab.Visible = RunService:IsStudio()
round(lab, 10)
border(lab, C.Purple, 1.1)
local labScale = Instance.new("UIScale")
labScale.Parent = lab

local toggleDeck = button(lab, "ToggleLabDeck", "DECK: OVERLORD",
    UDim2.fromOffset(11, 6), UDim2.fromOffset(260, 29), C.Purple)
local labFunds = button(lab, "StudioYen", "+20.000 YEN (STUDIO)",
    UDim2.fromOffset(282, 6), UDim2.fromOffset(263, 29), C.Blue)

local shortNames = {
    OVL_Climb = "CLIMB", OVL_Brain = "BRAIN", OVL_Gazef = "GAZEF",
    OVL_Shalltear = "SHALLTEAR", OVL_Albedo = "ALBEDO", OVL_Ainz = "AINZ",
    FissureBlade = "ESPADACHIM", FissureMage = "ARCANISTA",
    Capsule = "CAPSULE",
}

local selectedUnit: string? = nil
local selectedTower: number? = nil
local deck: {any} = {}
local towers: {any} = {}
local ready = false
local studioDeckMode = "Legacy"
local currentYen = 700
local preview: Part? = nil
local previewPosition: Vector3? = nil
local recentFeedback = ""

local function setHint(value: string, color: Color3?)
    hint.Text = value
    hint.TextColor3 = color or C.Muted
end

local function removePreview()
    if preview then preview:Destroy(); preview = nil end
    previewPosition = nil
end

local function cancelPlacement()
    selectedUnit = nil
    removePreview()
end

local function updateSlots()
    for i = 1, 6 do
        local b = slotButtons[i]
        local item = deck[i]
        if not item then
            b.Text = tostring(i) .. "\nEM BREVE"
            b.BackgroundColor3 = C.Dark
            b.Active = false
            b.AutoButtonColor = false
        else
            local enabled = item.Available == true and ready
            b.Text = tostring(i) .. "  " .. (if item.Role == "Farm" then "◈"
                elseif item.Role == "Support" then "◆" else "⚔")
                .. "\n" .. (shortNames[item.UnitId] or item.Name)
                .. "\n¥ " .. tostring(item.PlacementCost)
            if not enabled then
                b.Text = tostring(i) .. "\n" .. (shortNames[item.UnitId] or item.Name)
                    .. "\nBLOQUEADA"
            end
            b.Active = enabled
            b.AutoButtonColor = enabled
            b.BackgroundColor3 = if not enabled then C.Dark
                elseif selectedUnit == item.UnitId then C.Blue
                elseif item.UnitId == "Capsule" then C.Purple else C.Inner
        end
    end
end

local function findSelectedTower()
    for _, t in ipairs(towers) do
        if t.Serial == selectedTower then return t end
    end
    return nil
end

local function updateManagement()
    local t = findSelectedTower()
    if not t then
        selectedTower = nil
        management.Visible = false
        return
    end
    management.Visible = gui.Enabled
    local canManage = t.OwnerId == player.UserId
    local level = if typeof(t.Level) == "number" then t.Level else 0
    local maxLevel = if typeof(t.MaxUpgrades) == "number" then t.MaxUpgrades else 0
    selectedTitle.Text = t.Name .. "  •  LV " .. tostring(level)
    rarityLabel.Text = string.upper(t.Rarity or "BETA")
    rarityBackground.BackgroundColor3 = rarityColors[t.Rarity] or C.Blue
    if t.UnitId == "Capsule" then
        damageLabel.Text = "RENDA / WAVE"
        damageValue.Text = "¥ " .. tostring(t.Income or 0)
        rangeValue.Text = "—"
        spaValue.Text = "—"
    else
        damageLabel.Text = "DANO"
        local damage = t.EffectiveDamage or t.Damage or 0
        damageValue.Text = tostring(damage)
        damageValue.TextColor3 = if (t.SynergyBonus or 0) > 0
            then C.Green else C.White
        rangeValue.Text = string.format("%.1f", t.Range or 0)
        spaValue.Text = string.format("%.2fs", t.SPA or 0)
    end
    local stage = if typeof(t.VisualStage) == "number" then t.VisualStage else 0
    upgradesLabel.Text = string.format("UPGRADES   %d / %d   •   ATAQUE %d",
        level, maxLevel, stage)
    for i, dot in ipairs(dots) do
        local milestone = (i % 3 == 0)
        dot.Visible = i <= maxLevel
        dot.BackgroundColor3 = if i <= level
            then (if milestone then C.Gold else C.Cyan) else C.Dark
        local outline = dot:FindFirstChildOfClass("UIStroke")
        if outline then
            outline.Color = if milestone then C.Gold else C.Muted
        end
    end
    attackLabel.Text = "ATTACK: " .. (t.AttackName or "Ataque básico")
        .. " (" .. (t.AttackType or "SINGLE") .. ")"
    passiveLabel.Text = if typeof(t.PassiveName) == "string"
        then "PASSIVA: " .. t.PassiveName
            .. (if t.UnitId == "OVL_Shalltear"
                then " • " .. tostring(t.Blood or 0) .. "/5 sangue"
                elseif t.UnitId == "OVL_Albedo" and t.GuardCharges ~= nil
                then " • " .. tostring(t.GuardCharges) .. " cargas"
                else "")
        else (if t.UnitId == "Capsule" then "SUPORTE: gera Yen por wave"
            else "PASSIVA: ainda não definida")
    if t.UnitId == "OVL_Albedo" then
        synergyLabel.Visible = true
        synergyLabel.Text = if t.SynergyActive
            then "DEVOÇÃO AO SUPREMO ATIVA  •  +30% DANO (AINZ)"
            else "SINERGIA: posicione Ainz para receber +30% dano"
        synergyLabel.TextColor3 = if t.SynergyActive then C.Green else C.Muted
    elseif t.UnitId == "OVL_Ainz" then
        synergyLabel.Visible = true
        synergyLabel.Text = if t.SynergyActive
            then "PARCERIA ATIVA  •  ALBEDO RECEBE +30% DANO"
            else "SINERGIA: posicione Albedo para ativar o bônus dela"
        synergyLabel.TextColor3 = if t.SynergyActive then C.Green else C.Muted
    else
        synergyLabel.Visible = false
    end
    upgradeButton.Text = if not canManage then "SOMENTE O DONO"
        elseif t.UpgradeCost then "UPGRADE  •  ¥ " .. tostring(t.UpgradeCost)
        else "LEVEL MAX"
    upgradeButton.Active = canManage and t.UpgradeCost ~= nil
        and currentYen >= t.UpgradeCost
    upgradeButton.AutoButtonColor = upgradeButton.Active
    upgradeButton.BackgroundColor3 = if upgradeButton.Active then C.Blue else C.Dark
    sellButton.Text = if canManage then "VENDER  •  ¥ " .. tostring(t.SellValue or 0)
        else "TORRE ALIADA"
    sellButton.Active = canManage
    sellButton.AutoButtonColor = canManage
    sellButton.BackgroundColor3 = if canManage then C.Purple else C.Dark
end

for i, b in pairs(slotButtons) do
    b.Activated:Connect(function()
        if not ready then return end
        local item = deck[i]
        if not item or item.Available ~= true then
            setHint("Slot ainda nao liberado.", C.Gold)
            return
        end
        selectedTower = nil
        management.Visible = false
        if selectedUnit == item.UnitId then
            cancelPlacement()
            setHint("Colocacao cancelada.")
        else
            selectedUnit = item.UnitId
            setHint("Toque na GRAMA perto do trajeto para posicionar " .. item.Name .. ".")
        end
        updateSlots()
    end)
end

local function cameraRay(x: number, y: number): Ray
    local camera = Workspace.CurrentCamera
    assert(camera ~= nil, "Camera indisponivel")
    return camera:ViewportPointToRay(x, y)
end

local function raycastGround(x: number, y: number): RaycastResult?
    local camera = Workspace.CurrentCamera
    if not camera then return nil end
    local ray = cameraRay(x, y)
    local arena = Workspace:FindFirstChild("FissureArena")
    if not arena then return nil end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = {arena}
    return Workspace:Raycast(ray.Origin, ray.Direction * 1100, params)
end

local function ensurePreview()
    if preview then return end
    preview = Instance.new("Part")
    preview.Name = "LocalPlacementPreview"
    preview.Shape = Enum.PartType.Cylinder
    preview.Size = Vector3.new(0.13, 5.1, 5.1)
    preview.Material = Enum.Material.Neon
    preview.Color = C.Cyan
    preview.Transparency = 0.55
    preview.Anchored = true
    preview.CanCollide = false
    preview.CanQuery = false
    preview.CanTouch = false
    preview.Parent = Workspace.CurrentCamera
end

local function updatePreview(x: number, y: number)
    if not selectedUnit or not gui.Enabled then return end
    local hit = raycastGround(x, y)
    if not hit then removePreview(); return end
    local p = hit.Position
    if hit.Instance.Name ~= "VillageMeadow" then
        removePreview()
        return
    end
    ensurePreview()
    previewPosition = Vector3.new(p.X, 0, p.Z)
    if preview then
        preview.CFrame = CFrame.new(p.X, p.Y + 0.13, p.Z)
            * CFrame.Angles(0, 0, math.rad(90))
    end
end

local function towerSerialAt(x: number, y: number): number?
    local camera = Workspace.CurrentCamera
    if not camera then return nil end
    local ray = cameraRay(x, y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    local arena = Workspace:FindFirstChild("FissureArena")
    local folder = if arena then arena:FindFirstChild("LiveTowers") else nil
    if not folder then return nil end
    params.FilterDescendantsInstances = {folder}
    local hit = Workspace:Raycast(ray.Origin, ray.Direction * 1100, params)
    if not hit then return nil end
    local model = hit.Instance:FindFirstAncestorOfClass("Model")
    if not model then return nil end
    local serial = model:GetAttribute("TowerSerial")
    return if typeof(serial) == "number" then serial else nil
end

UserInputService.InputChanged:Connect(function(input: InputObject)
    if not selectedUnit then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        updatePreview(input.Position.X, input.Position.Y)
    end
end)

UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
    if processed or player:GetAttribute("InArena") ~= true then return end
    if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
        cancelPlacement()
        updateSlots()
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local x, y = input.Position.X, input.Position.Y
    if selectedUnit then
        local hit = raycastGround(x, y)
        if hit and hit.Instance.Name == "VillageMeadow" then
            request:FireServer("Place", selectedUnit, Vector3.new(hit.Position.X, 0, hit.Position.Z))
        else
            setHint("Escolha uma area de grama livre.", C.Gold)
        end
        return
    end
    local serial = towerSerialAt(x, y)
    if serial then
        selectedTower = serial
        updateManagement()
        if not selectedTower then setHint("Selecione uma Tower valida.", C.Gold) end
    else
        selectedTower = nil
        management.Visible = false
    end
end)

toggleDeck.Activated:Connect(function()
    if RunService:IsStudio() and ready then
        selectedTower = nil
        management.Visible = false
        cancelPlacement()
        request:FireServer("LabDeck")
    end
end)
labFunds.Activated:Connect(function()
    if RunService:IsStudio() and ready then request:FireServer("LabFunds") end
end)

upgradeButton.Activated:Connect(function()
    local t = findSelectedTower()
    if t and t.OwnerId == player.UserId and upgradeButton.Active then
        request:FireServer("Upgrade", t.Serial)
    end
end)
sellButton.Activated:Connect(function()
    local t = findSelectedTower()
    if t and t.OwnerId == player.UserId and sellButton.Active then
        request:FireServer("Sell", t.Serial)
    end
end)
closeManage.Activated:Connect(function()
    selectedTower = nil
    management.Visible = false
end)

stateRemote.OnClientEvent:Connect(function(data: any)
    if typeof(data) ~= "table" then return end
    ready = data.Ready == true
    studioDeckMode = if data.DeckMode == "Overlord" then "Overlord" else "Legacy"
    toggleDeck.Text = "DECK: " .. string.upper(studioDeckMode)
    deckTitle.Text = if studioDeckMode == "Overlord"
        then "OVERLORD   •   LABORATORIO"
        else "DECK DE COMBATE   •   BETA"
    deck = if typeof(data.Deck) == "table" then data.Deck else {}
    towers = if typeof(data.Towers) == "table" then data.Towers else {}
    currentYen = if typeof(data.Yen) == "number" then data.Yen else 700
    yen.Text = "¥ " .. tostring(currentYen)
    if typeof(data.Message) == "string" and data.Message ~= "" then
        recentFeedback = data.Message
        setHint(recentFeedback, if recentFeedback:find("insuficiente")
            or recentFeedback:find("bloqueado") then C.Gold else C.Cyan)
    end
    updateSlots()
    updateManagement()
    -- Nao cancelar a escolha enquanto o servidor atualiza Yen ou outra torre.
    -- Cancelar apenas apos confirmar a colocacao desta tentativa.
    if ready and selectedUnit and data.Message == "Torre posicionada." then
        cancelPlacement()
        updateSlots()
    end
end)

local function updateVisibility()
    gui.Enabled = player:GetAttribute("InArena") == true
    if not gui.Enabled then
        cancelPlacement()
        selectedTower = nil
        management.Visible = false
    else
        request:FireServer("Sync")
    end
end
player:GetAttributeChangedSignal("InArena"):Connect(updateVisibility)

local function resize()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local v = cam.ViewportSize
    -- Reserve room for an open 251px detail card plus 122px deck,
    -- 41px Studio controls and spacing on short mobile landscape screens.
    local totalHeight = if lab.Visible then 443 else 394
    local factor = math.clamp(math.min((v.X - 12) / 556,
        (v.Y - 16) / totalHeight, 1), 0.48, 1)
    barScale.Scale = factor
    managementScale.Scale = factor
    labScale.Scale = factor
    lab.Position = UDim2.new(0.5, 0, 1, -(13 + 122 * factor + 8))
    management.Position = UDim2.new(0.5, 0, 1,
        -(13 + 122 * factor + (if lab.Visible then 49 * factor else 0)
            + 10 * factor))
end
local function bindCamera()
    local cam = Workspace.CurrentCamera
    if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
    resize()
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
bindCamera()

updateSlots()
updateVisibility()
print("[Anime Fissure] TowerHUD v1.3 | detailed tower card, upgrades, attack types, Ainz/Albedo synergy")
