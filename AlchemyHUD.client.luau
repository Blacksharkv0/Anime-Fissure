--!strict
-- ANIME FISSURE | AlchemyHUD v0.1
-- UI de transmutacao: inventario vazio + Index consultavel.
-- A fabricacao esta desativada ate a implementacao do inventario real.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local indexConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RelicIndexConfig"))
local remotes = ReplicatedStorage:WaitForChild("AlchemyRemotes")
local openRemote = remotes:WaitForChild("OpenWorkshop") :: RemoteEvent
local snapshotRemote = remotes:WaitForChild("GetWorkshopSnapshot") :: RemoteFunction

local C = {
    Backdrop = Color3.fromRGB(5, 7, 18),
    Dark = Color3.fromRGB(10, 14, 32),
    Panel = Color3.fromRGB(17, 24, 49),
    PanelAlt = Color3.fromRGB(23, 29, 58),
    Blue = Color3.fromRGB(56, 123, 255),
    Cyan = Color3.fromRGB(91, 221, 250),
    Purple = Color3.fromRGB(157, 89, 246),
    Gold = Color3.fromRGB(232, 184, 94),
    White = Color3.fromRGB(240, 244, 255),
    Muted = Color3.fromRGB(148, 169, 210),
    Red = Color3.fromRGB(237, 113, 134),
}

local old = playerGui:FindFirstChild("AnimeFissureAlchemyHUD")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFissureAlchemyHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 150
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = false
gui.Parent = playerGui

local function round(parent: Instance, pixels: number)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, pixels)
    c.Parent = parent
end

local function stroke(parent: Instance, color: Color3, thickness: number, transparency: number?)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness
    s.Transparency = transparency or 0
    s.Parent = parent
    return s
end

local function frame(parent: Instance, name: string, x: number, y: number, w: number, h: number, color: Color3, radius: number?): Frame
    local f = Instance.new("Frame")
    f.Name = name
    f.Position = UDim2.fromOffset(x, y)
    f.Size = UDim2.fromOffset(w, h)
    f.BackgroundColor3 = color
    f.BorderSizePixel = 0
    f.Parent = parent
    if radius then round(f, radius) end
    return f
end

local function label(parent: Instance, name: string, value: string, x: number, y: number, w: number, h: number, size: number, color: Color3, bold: boolean?): TextLabel
    local l = Instance.new("TextLabel")
    l.Name = name
    l.Position = UDim2.fromOffset(x, y)
    l.Size = UDim2.fromOffset(w, h)
    l.BackgroundTransparency = 1
    l.Text = value
    l.TextColor3 = color
    l.TextSize = size
    l.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.TextWrapped = true
    l.Parent = parent
    return l
end

local function button(parent: Instance, name: string, value: string, x: number, y: number, w: number, h: number, color: Color3): TextButton
    local b = Instance.new("TextButton")
    b.Name = name
    b.Position = UDim2.fromOffset(x, y)
    b.Size = UDim2.fromOffset(w, h)
    b.BackgroundColor3 = color
    b.BorderSizePixel = 0
    b.Text = value
    b.Font = Enum.Font.GothamBold
    b.TextColor3 = C.White
    b.TextSize = 16
    b.AutoButtonColor = true
    b.Parent = parent
    round(b, 9)
    return b
end

local veil = frame(gui, "Backdrop", 0, 0, 0, 0, C.Backdrop)
veil.Size = UDim2.fromScale(1, 1)
veil.BackgroundTransparency = 0.17
veil.Active = true

local root = frame(veil, "MainWindow", 0, 0, 1120, 660, C.Dark, 14)
root.AnchorPoint = Vector2.new(0.5, 0.5)
root.Position = UDim2.fromScale(0.5, 0.5)
stroke(root, C.Purple, 2)

local scaler = Instance.new("UIScale")
scaler.Parent = root

local function resize()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local v = camera.ViewportSize
    scaler.Scale = math.min(v.X / 1150, v.Y / 700, 1.1)
end
resize()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
end

label(root, "Title", "⚗  OFICINA DE TRANSMUTAÇÃO", 28, 14, 790, 45, 30, C.White, true)
label(root, "Subtitle", "CRAFTING  /  ORBES  /  RELÍQUIAS", 30, 56, 550, 22, 13, C.Cyan, true)
local goldLabel = label(root, "Gold", "GOLD: --  (perfil ainda não conectado)", 678, 50, 345, 26, 13, C.Muted)
local closeButton = button(root, "Close", "✕", 1058, 19, 44, 42, C.PanelAlt)
stroke(closeButton, C.Purple, 1)

local tabs = {"Relíquias", "Orbes", "Materiais", "Evolução", "Index"}
local tabButtons: {[string]: TextButton} = {}
for i, tab in ipairs(tabs) do
    local b = button(root, "Tab" .. i, tab, 20 + (i - 1) * 218, 95, 202, 40, C.PanelAlt)
    b.TextSize = 17
    stroke(b, C.Blue, 1, 0.35)
    tabButtons[tab] = b
end

local left = frame(root, "CraftingPanel", 20, 150, 690, 488, C.Panel, 11)
stroke(left, C.Blue, 1, 0.4)
local right = frame(root, "IndexPanel", 725, 150, 376, 488, C.Panel, 11)
stroke(right, C.Purple, 1, 0.30)

local modeTitle = label(left, "ModeTitle", "CÍRCULO DE TRANSMUTAÇÃO", 24, 12, 620, 28, 18, C.Cyan, true)
local circleArea = frame(left, "CircleArea", 20, 48, 377, 265, C.Dark, 12)
stroke(circleArea, C.Purple, 1, 0.45)

local function magicRing(diameter: number, color: Color3)
    local ring = frame(circleArea, "MagicRing", 188 - diameter / 2, 132 - diameter / 2, diameter, diameter, C.Dark)
    ring.BackgroundTransparency = 1
    local u = Instance.new("UICorner")
    u.CornerRadius = UDim.new(1, 0)
    u.Parent = ring
    stroke(ring, color, 2, 0.20)
end
magicRing(240, C.Cyan)
magicRing(186, C.Blue)
magicRing(125, C.Purple)

local core = frame(circleArea, "AlchemyCore", 156, 100, 64, 64, C.PanelAlt, 32)
stroke(core, C.Cyan, 2)
local coreSymbol = label(core, "AlchemyIcon", "◇", 0, 0, 64, 64, 40, C.Cyan, true)
coreSymbol.TextXAlignment = Enum.TextXAlignment.Center

-- Seis materiais em volta do circulo. NENHUM material e inventado aqui.
for i = 1, 6 do
    local angle = math.pi * 2 * (i - 1) / 6 - math.pi / 2
    local px = 188 + math.cos(angle) * 106 - 24
    local py = 132 + math.sin(angle) * 106 - 24
    local slot = frame(circleArea, "MaterialSlot" .. i, px, py, 48, 48, C.PanelAlt, 8)
    stroke(slot, C.Purple, 1, 0.12)
    local plus = label(slot, "EmptySymbol", "+", 0, 0, 48, 48, 26, C.Muted, true)
    plus.TextXAlignment = Enum.TextXAlignment.Center
end

local explanation = frame(left, "RecipePanel", 409, 48, 259, 265, C.Dark, 11)
stroke(explanation, C.Blue, 1, 0.5)
local recipeTitle = label(explanation, "RecipeTitle", "NENHUMA RECEITA", 15, 14, 229, 34, 18, C.White, true)
local recipeBody = label(explanation, "RecipeInfo", "Selecione uma relíquia no Index. As receitas serão habilitadas quando os materiais e o inventário forem implementados.", 15, 52, 229, 126, 15, C.Muted)
recipeBody.TextYAlignment = Enum.TextYAlignment.Top
local alchemyHint = label(explanation, "Requirements", "Materiais: 0 / 0\nCusto: --", 15, 177, 229, 43, 15, C.Gold)
local craft = button(explanation, "Craft", "TRANSMUTAR  •  BLOQUEADO", 10, 224, 239, 34, C.PanelAlt)
craft.TextSize = 13
craft.AutoButtonColor = false
craft.Active = false

local inventory = frame(left, "InventoryPanel", 20, 327, 648, 145, C.Dark, 10)
stroke(inventory, C.Purple, 1, 0.5)
local inventoryTitle = label(inventory, "InventoryTitle", "MOCHILA DE MATERIAIS   0 ITENS", 14, 7, 610, 26, 17, C.White, true)
for i = 1, 16 do
    local x = 14 + ((i - 1) % 8) * 78
    local y = 38 + math.floor((i - 1) / 8) * 47
    local s = frame(inventory, "EmptyInventory" .. i, x, y, 68, 42, C.PanelAlt, 5)
    stroke(s, C.Blue, 1, 0.65)
end
local inventoryEmpty = label(inventory, "EmptyMessage", "Inventário vazio — obtenha materiais jogando o Modo História.", 33, 55, 582, 58, 15, C.Muted, true)
inventoryEmpty.TextXAlignment = Enum.TextXAlignment.Center
inventoryEmpty.BackgroundColor3 = C.Dark
inventoryEmpty.BackgroundTransparency = 0.1

-- INDEX: todos os itens do catalogo, sem fingir que ja foram liberados.
local indexTitle = label(right, "IndexTitle", "◈  INDEX DE RELÍQUIAS", 16, 10, 346, 30, 19, C.White, true)
local obtainedLabel = label(right, "IndexCount", "Obtidas: 0  •  Disponíveis: 0", 16, 39, 240, 22, 13, C.Muted)
local filterButton = button(right, "Filter", "TODAS", 266, 39, 94, 26, C.PanelAlt)
filterButton.TextSize = 12

local scrolling = Instance.new("ScrollingFrame")
scrolling.Name = "RelicList"
scrolling.Position = UDim2.fromOffset(13, 76)
scrolling.Size = UDim2.fromOffset(350, 198)
scrolling.BackgroundColor3 = C.Dark
scrolling.BorderSizePixel = 0
scrolling.ScrollBarThickness = 5
scrolling.ScrollBarImageColor3 = C.Purple
scrolling.CanvasSize = UDim2.fromOffset(0, 0)
scrolling.Parent = right
round(scrolling, 8)
local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scrolling

local detail = frame(right, "RelicDetails", 13, 283, 350, 192, C.Dark, 10)
stroke(detail, C.Gold, 1, 0.55)
local detailName = label(detail, "SelectedName", "Selecione uma relíquia", 12, 10, 325, 28, 19, C.White, true)
local detailBuff = label(detail, "SelectedBuff", "Buff: --", 12, 42, 325, 60, 14, C.Cyan)
detailBuff.TextYAlignment = Enum.TextYAlignment.Top
local detailTarget = label(detail, "SelectedTarget", "Para: --", 12, 107, 325, 44, 14, C.Muted)
detailTarget.TextYAlignment = Enum.TextYAlignment.Top
local detailStatus = label(detail, "SelectedStatus", "Status: --", 12, 153, 325, 25, 14, C.Gold, true)

local selectedId: string? = nil
local filterLive = false
local profileReady = false
local craftingEnabled = false
local currentGold = 0
local materialCounts: {[string]: number} = {}
local recipes: {[string]: any} = {}
local owned: {[string]: boolean} = {}
local availableCount = 0
local relics = indexConfig.GetAll()
for _, item in ipairs(relics) do
    if item.Availability == "Live" then
        availableCount += 1
    end
end

local function isOwned(id: string): boolean
    return owned[id] == true
end

-- O simbolo alquimico aparece SOMENTE com todos os requisitos.
-- Quando ligarmos o inventario real, o servidor enviara os dados.
local function canCraft(item: any): boolean
    if not profileReady or not craftingEnabled or item.Availability ~= "Live" then
        return false
    end
    local recipe = recipes[item.Id]
    if typeof(recipe) ~= "table"
        or typeof(recipe.Gold) ~= "number"
        or typeof(recipe.Materials) ~= "table" then
        return false
    end
    if currentGold < recipe.Gold or next(recipe.Materials) == nil then
        return false
    end
    for materialId, required in pairs(recipe.Materials) do
        if typeof(materialId) ~= "string"
            or typeof(required) ~= "number"
            or required <= 0
            or (materialCounts[materialId] or 0) < required then
            return false
        end
    end
    return true
end

local function selectRelic(item: any)
    selectedId = item.Id
    detailName.Text = item.Name
    detailBuff.Text = "Buff: " .. item.Buff
    detailTarget.Text = "Para: " .. item.Target
    if canCraft(item) then
        detailStatus.Text = "Status: ⚗ PRONTA PARA FABRICAR"
        detailStatus.TextColor3 = C.Cyan
    elseif isOwned(item.Id) then
        detailStatus.Text = "Status: OBTIDA"
        detailStatus.TextColor3 = C.Cyan
    elseif item.Availability == "Live" then
        detailStatus.Text = "Status: DISPONÍVEL NO JOGO"
        detailStatus.TextColor3 = C.Gold
    else
        detailStatus.Text = "Status: EM DESENVOLVIMENTO"
        detailStatus.TextColor3 = C.Muted
    end
end

local function redrawIndex()
    for _, child in ipairs(scrolling:GetChildren()) do
        if child:IsA("TextButton") or child.Name == "EmptyFilter" then
            child:Destroy()
        end
    end
    local added = 0
    for i, item in ipairs(relics) do
        if not filterLive or item.Availability == "Live" then
            added += 1
            local b = button(scrolling, "Relic_" .. item.Id, item.Name, 0, 0, 332, 37, C.PanelAlt)
            b.LayoutOrder = i
            b.TextSize = 13
            b.TextXAlignment = Enum.TextXAlignment.Left
            b.Text = (canCraft(item) and "  ⚗ " or "  ◇ ") .. item.Name
            stroke(b, item.Id == selectedId and C.Gold or C.Blue, 1, 0.35)
            b.Activated:Connect(function()
                selectRelic(item)
                redrawIndex()
            end)
        end
    end
    if added == 0 then
        local msg = label(scrolling, "EmptyFilter", "Nenhuma relíquia lançada ainda.", 12, 30, 320, 100, 16, C.Muted)
        msg.LayoutOrder = 1
    end
    scrolling.CanvasSize = UDim2.fromOffset(0, math.max(198, added * 42))
    local count = 0
    for _, item in ipairs(relics) do
        if isOwned(item.Id) then count += 1 end
    end
    obtainedLabel.Text = string.format("Obtidas: %d  •  Em jogo: %d", count, availableCount)
end

filterButton.Activated:Connect(function()
    filterLive = not filterLive
    filterButton.Text = filterLive and "EM JOGO" or "TODAS"
    redrawIndex()
end)

local tabDescriptions = {
    ["Relíquias"] = "Selecione uma relíquia no Index para consultar seus efeitos. A fabricação será liberada quando tivermos receitas e materiais reais.",
    ["Orbes"] = "Nenhuma orbe disponível por enquanto. Esta aba está preparada para futuras receitas.",
    ["Materiais"] = "Seu inventário começa vazio. Materiais serão conquistados nas fases e eventos.",
    ["Evolução"] = "Evoluções serão ligadas às unidades e aos materiais próprios de cada mundo.",
    ["Index"] = "O Index mostra o catálogo planejado e informa o que já está disponível no jogo.",
}

local function chooseTab(tab: string)
    for _, name in ipairs(tabs) do
        tabButtons[name].BackgroundColor3 = name == tab and C.Blue or C.PanelAlt
    end
    modeTitle.Text = tab == "Index" and "CONSULTA DE RELÍQUIAS" or string.upper(tab)
    recipeTitle.Text = tab == "Index" and "INDEX DE RELÍQUIAS" or "NENHUMA RECEITA"
    recipeBody.Text = tabDescriptions[tab] or ""
end
for _, tab in ipairs(tabs) do
    tabButtons[tab].Activated:Connect(function()
        chooseTab(tab)
    end)
end
chooseTab("Relíquias")
redrawIndex()

local savedLobbyEnabled: boolean? = nil
local function setLobbyMenuHidden(hidden: boolean)
    local mainLobbyGui = playerGui:FindFirstChild("AnimeFissureLobbyUI")
    if not mainLobbyGui or not mainLobbyGui:IsA("ScreenGui") then return end
    if hidden then
        savedLobbyEnabled = mainLobbyGui.Enabled
        mainLobbyGui.Enabled = false
    elseif savedLobbyEnabled ~= nil then
        mainLobbyGui.Enabled = savedLobbyEnabled and player:GetAttribute("InArena") ~= true
        savedLobbyEnabled = nil
    end
end

local function closeHud()
    gui.Enabled = false
    setLobbyMenuHidden(false)
end
closeButton.Activated:Connect(closeHud)
player:GetAttributeChangedSignal("InArena"):Connect(function()
    if player:GetAttribute("InArena") == true then
        closeHud()
    end
end)

openRemote.OnClientEvent:Connect(function()
    if player:GetAttribute("InArena") == true then return end
    local ok, snapshot = pcall(function()
        return snapshotRemote:InvokeServer()
    end)
    if not ok or typeof(snapshot) ~= "table" then
        warn("[Anime Fissure] Oficina: falha ao consultar inventario")
        return
    end
    owned = {}
    if typeof(snapshot.OwnedRelics) == "table" then
        for _, id in ipairs(snapshot.OwnedRelics) do
            if typeof(id) == "string" then owned[id] = true end
        end
    end
    profileReady = snapshot.GoldConnected == true
    craftingEnabled = snapshot.CraftingEnabled == true
    currentGold = typeof(snapshot.Gold) == "number" and snapshot.Gold or 0
    materialCounts = {}
    recipes = typeof(snapshot.Recipes) == "table" and snapshot.Recipes or {}
    local inventoryCount = 0
    if typeof(snapshot.Inventory) == "table" then
        for _, stack in ipairs(snapshot.Inventory) do
            if typeof(stack) == "table" and typeof(stack.Id) == "string"
                and typeof(stack.Amount) == "number" and stack.Amount > 0 then
                materialCounts[stack.Id] = (materialCounts[stack.Id] or 0) + stack.Amount
                inventoryCount += 1
            end
        end
    end
    goldLabel.Text = profileReady and ("GOLD: " .. tostring(currentGold)) or "GOLD: --  (perfil ainda não conectado)"
    inventoryTitle.Text = "MOCHILA DE MATERIAIS   " .. tostring(inventoryCount) .. " ITENS"
    inventoryEmpty.Visible = inventoryCount == 0
    if selectedId then
        local selected = indexConfig.Get(selectedId)
        if selected then selectRelic(selected) end
    end
    redrawIndex()
    gui.Enabled = true
    setLobbyMenuHidden(true)
    -- Entrada discreta; nenhum material e consumido nesta etapa.
    root.BackgroundColor3 = C.Panel
    TweenService:Create(root, TweenInfo.new(0.2), {BackgroundColor3 = C.Dark}):Play()
end)

print("[Anime Fissure] AlchemyHUD v0.1 carregado")
