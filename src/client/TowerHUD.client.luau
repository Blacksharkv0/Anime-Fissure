--!strict
-- ANIME FISSURE | TowerHUD v1.1
-- Deck beta de 6 slots (2 prototipos, Capsule se obtida, 3 futuros).
-- Clique/toque no slot e depois na grama para colocar, em PC e mobile.
-- Upgrade/venda so por serial de torre propria (server verifica tudo).
-- HUD da arena e StageInfo continuam intactos.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

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

text(bar, "DeckTitle", "DECK DE COMBATE  •  BETA",
    UDim2.fromOffset(12, 3), UDim2.fromOffset(350, 23), 13, C.Cyan).TextXAlignment =
    Enum.TextXAlignment.Left
local yen = text(bar, "Yen", "¥ 700",
    UDim2.fromOffset(382, 3), UDim2.fromOffset(158, 23), 15, C.Gold)
yen.TextXAlignment = Enum.TextXAlignment.Right
local hint = text(bar, "PlaceHint", "Selecione uma Tower e toque no terreno livre",
    UDim2.fromOffset(12, 98), UDim2.fromOffset(520, 20), 11, C.Muted)

local management = frame(gui, "TowerManagement",
    UDim2.new(0.5, 0, 1, -145), UDim2.fromOffset(520, 102), C.Panel)
management.AnchorPoint = Vector2.new(0.5, 1)
management.Visible = false
round(management, 12)
border(management, C.Purple, 1.4)
local managementScale = Instance.new("UIScale")
managementScale.Parent = management

local selectedTitle = text(management, "SelectedUnit", "TORRE",
    UDim2.fromOffset(10, 7), UDim2.new(1, -20, 0, 24), 15, C.White)
local selectedStats = text(management, "SelectedStats", "",
    UDim2.fromOffset(10, 34), UDim2.new(1, -20, 0, 20), 11, C.Muted)
local upgradeButton = button(management, "Upgrade", "UPGRADE",
    UDim2.fromOffset(10, 62), UDim2.fromOffset(238, 32), C.Blue)
local sellButton = button(management, "Sell", "VENDER",
    UDim2.fromOffset(259, 62), UDim2.fromOffset(153, 32), C.Purple)
local closeManage = button(management, "CloseSelection", "X",
    UDim2.fromOffset(423, 62), UDim2.fromOffset(86, 32), C.Dark)

local slotButtons: {[number]: TextButton} = {}
for i = 1, 6 do
    local x = 10 + (i - 1) * 91
    local cell = button(bar, "Slot_" .. i, "SLOT " .. i,
        UDim2.fromOffset(x, 29), UDim2.fromOffset(82, 66), C.Inner)
    cell.TextSize = 12
    slotButtons[i] = cell
end

local selectedUnit: string? = nil
local selectedTower: number? = nil
local deck: {any} = {}
local towers: {any} = {}
local ready = false
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
            b.Text = tostring(i) .. "  " .. (if item.UnitId == "Capsule" then "◈"
                elseif item.UnitId == "FissureBlade" then "⚔" else "✦")
                .. "\n" .. (if item.UnitId == "FissureBlade" then "ESPADACHIM"
                    elseif item.UnitId == "FissureMage" then "ARCANISTA" else "CAPSULE")
                .. "\n¥ " .. tostring(item.PlacementCost)
            if not enabled then b.Text = tostring(i) .. "\nCAPSULE\nBLOQUEADA" end
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
    selectedTitle.Text = t.Name .. "  •  LV " .. tostring(t.Level)
    selectedStats.Text = if t.UnitId == "Capsule"
        then "Renda: ¥" .. tostring(t.Income or 0) .. " / wave"
        else string.format("Dano: %d   SPA: %.2fs   Range: %.1f",
            t.Damage or 0, t.SPA or 0, t.Range or 0)
    upgradeButton.Text = if t.UpgradeCost
        then "UPGRADE  •  ¥ " .. tostring(t.UpgradeCost) else "LEVEL MAX"
    upgradeButton.Active = t.UpgradeCost ~= nil and currentYen >= t.UpgradeCost
    upgradeButton.AutoButtonColor = upgradeButton.Active
    upgradeButton.BackgroundColor3 = if upgradeButton.Active then C.Blue else C.Dark
    sellButton.Text = "VENDER  •  ¥ " .. tostring(t.SellValue or 0)
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
        if not selectedTower then setHint("Essa torre nao e sua.", C.Gold) end
    else
        selectedTower = nil
        management.Visible = false
    end
end)

upgradeButton.Activated:Connect(function()
    if selectedTower then request:FireServer("Upgrade", selectedTower) end
end)
sellButton.Activated:Connect(function()
    if selectedTower then request:FireServer("Sell", selectedTower) end
end)
closeManage.Activated:Connect(function()
    selectedTower = nil
    management.Visible = false
end)

stateRemote.OnClientEvent:Connect(function(data: any)
    if typeof(data) ~= "table" then return end
    ready = data.Ready == true
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
    local factor = math.clamp(math.min((v.X - 12) / 556, (v.Y - 32) / 235, 1), 0.48, 1)
    barScale.Scale = factor
    managementScale.Scale = factor
    management.Position = UDim2.new(0.5, 0, 1, -(13 + 122 * factor + 12))
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
print("[Anime Fissure] TowerHUD beta 1.1 | 2 atacantes + Capsule")
