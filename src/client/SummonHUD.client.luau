--!strict
-- ANIME FISSURE | SummonHUD v0.2 - cinematic reveal integrado
-- HUD de Summon real. Abre pelo Virgil (E / toque) no lobby.
-- Compra confirmada pelo servidor -> cinematica real -> revelacao 3D.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local SummonReveal = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("SummonRevealClient"))

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild("SummonRemotes")
local openEvent = remotes:WaitForChild("Open") :: RemoteEvent
local stateRemote = remotes:WaitForChild("GetState") :: RemoteFunction
local purchaseRemote = remotes:WaitForChild("Purchase") :: RemoteFunction

local existing = playerGui:FindFirstChild("AnimeFissureSummonHUD")
if existing then existing:Destroy() end

local C = {
    BG = Color3.fromRGB(5, 9, 23),
    Panel = Color3.fromRGB(12, 20, 43),
    Mid = Color3.fromRGB(21, 33, 64),
    Blue = Color3.fromRGB(56, 123, 255),
    Cyan = Color3.fromRGB(98, 228, 255),
    Gold = Color3.fromRGB(238, 190, 95),
    White = Color3.fromRGB(237, 245, 255),
    Muted = Color3.fromRGB(161, 183, 210),
    Green = Color3.fromRGB(96, 235, 170),
    Purple = Color3.fromRGB(153, 98, 249),
}

local function corner(object: Instance, radius: number)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object
end

local function stroke(object: Instance, color: Color3, width: number)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = width
    s.Transparency = 0.28
    s.Parent = object
end

local function makeFrame(parent: Instance, name: string, position: UDim2, size: UDim2,
    bg: Color3, radius: number): Frame
    local f = Instance.new("Frame")
    f.Name = name
    f.Position = position
    f.Size = size
    f.BackgroundColor3 = bg
    f.BorderSizePixel = 0
    f.Parent = parent
    corner(f, radius)
    return f
end

local function makeText(parent: Instance, name: string, value: string, position: UDim2,
    size: UDim2, fontSize: number, color: Color3, bold: boolean?): TextLabel
    local text = Instance.new("TextLabel")
    text.Name = name
    text.Position = position
    text.Size = size
    text.BackgroundTransparency = 1
    text.Text = value
    text.TextColor3 = color
    text.TextSize = fontSize
    text.TextWrapped = true
    text.Font = if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.Parent = parent
    return text
end

local function makeButton(parent: Instance, name: string, value: string, position: UDim2,
    size: UDim2, bg: Color3): TextButton
    local b = Instance.new("TextButton")
    b.Name = name
    b.Text = value
    b.Position = position
    b.Size = size
    b.BackgroundColor3 = bg
    b.BorderSizePixel = 0
    b.TextColor3 = C.White
    b.TextSize = 17
    b.TextWrapped = true
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    corner(b, 8)
    return b
end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFissureSummonHUD"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.DisplayOrder = 165
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = false
gui.Parent = playerGui

local fade = makeFrame(gui, "Backdrop", UDim2.fromScale(0,0), UDim2.fromScale(1,1), C.BG, 0)
fade.BackgroundTransparency = 0.07
local window = makeFrame(fade, "Window", UDim2.fromScale(.5,.5), UDim2.fromOffset(1000,620), C.Panel, 14)
window.AnchorPoint = Vector2.new(.5,.5)
stroke(window, C.Blue, 2)
local scale = Instance.new("UIScale")
scale.Parent = window
local function resize()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local view = camera.ViewportSize
    scale.Scale = math.clamp(math.min(view.X / 1050, view.Y / 675), .37, 1.05)
end
resize()
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(resize)
end

makeText(window, "Brand", "ANIME FISSURE    /    VIRGIL", UDim2.fromOffset(25, 18),
    UDim2.fromOffset(750, 32), 17, C.Cyan, true)
makeText(window, "Title", "FISSURA DAS CÁPSULAS", UDim2.fromOffset(25, 51),
    UDim2.fromOffset(740, 45), 29, C.White, true)
local closeButton = makeButton(window, "Close", "✕", UDim2.fromOffset(935, 17),
    UDim2.fromOffset(43, 43), C.Mid)
stroke(closeButton, C.Blue, 1)
local ticketsLabel = makeText(window, "Tickets", "TICKETS: --", UDim2.fromOffset(733, 67),
    UDim2.fromOffset(195, 28), 17, C.Gold, true)

local left = makeFrame(window, "CharacterPanel", UDim2.fromOffset(24, 116),
    UDim2.fromOffset(468, 475), C.Mid, 10)
stroke(left, C.Purple, 1)
local right = makeFrame(window, "PurchasePanel", UDim2.fromOffset(509, 116),
    UDim2.fromOffset(467, 475), C.Mid, 10)
stroke(right, C.Blue, 1)

local viewport = Instance.new("ViewportFrame")
viewport.Name = "CapsuleViewport"
viewport.Position = UDim2.fromOffset(18, 14)
viewport.Size = UDim2.fromOffset(432, 300)
viewport.BackgroundColor3 = Color3.fromRGB(13, 23, 52)
viewport.BorderSizePixel = 0
viewport.Ambient = Color3.fromRGB(185, 205, 255)
viewport.LightColor = Color3.fromRGB(255, 255, 255)
viewport.LightDirection = Vector3.new(-1, -1, -1)
viewport.Parent = left
corner(viewport, 9)
local world = Instance.new("WorldModel")
world.Parent = viewport
local camera = Instance.new("Camera")
camera.FieldOfView = 38
camera.CFrame = CFrame.lookAt(Vector3.new(0, .6, -10), Vector3.new(0, -.15, 0))
camera.Parent = viewport
viewport.CurrentCamera = camera
local fallback = makeText(viewport, "ModelFallback", "CARREGANDO MODELO 3D...",
    UDim2.fromOffset(35, 115), UDim2.fromOffset(365, 50), 18, C.Cyan, true)
fallback.TextXAlignment = Enum.TextXAlignment.Center

local previewShiny = false
local previewButton = makeButton(left, "PreviewShiny", "VER SHINY ★",
    UDim2.fromOffset(18, 333), UDim2.fromOffset(200, 40), C.Panel)
local previewTitle = makeText(left, "PreviewName", "CAPSULE  •  LENDÁRIA",
    UDim2.fromOffset(18, 389), UDim2.fromOffset(424, 32), 19, C.White, true)
makeText(left, "EvolutionNote", "Capsule (Corp) Mítica: APENAS EVOLUÇÃO. Nunca aparece no banner.",
    UDim2.fromOffset(18, 418), UDim2.fromOffset(423, 46), 13, C.Muted)

local rate = makeText(right, "Rates", "CAPSULE: 100%  |  SHINY: 1% (PROVISÓRIO)",
    UDim2.fromOffset(19, 17), UDim2.fromOffset(430, 34), 17, C.Gold, true)
local info = makeText(right, "Info", "Este banner contém somente Capsule Normal e Shiny.\nSem Capsule (Corp) e sem unidades míticas.",
    UDim2.fromOffset(19, 63), UDim2.fromOffset(426, 70), 15, C.Muted)
local oneButton = makeButton(right, "SummonOne", "INVOCAR 1×   •   1 TICKET",
    UDim2.fromOffset(18, 157), UDim2.fromOffset(426, 58), C.Blue)
local tenButton = makeButton(right, "SummonTen", "INVOCAR 10×   •   10 TICKETS",
    UDim2.fromOffset(18, 230), UDim2.fromOffset(426, 58), C.Purple)
local stateLabel = makeText(right, "State", "Carregando sua coleção...",
    UDim2.fromOffset(18, 307), UDim2.fromOffset(426, 72), 15, C.Cyan)
local collectionLabel = makeText(right, "Collection", "NA COLEÇÃO: Normal 0  |  Shiny 0",
    UDim2.fromOffset(18, 382), UDim2.fromOffset(426, 50), 15, C.White, true)

-- Modal de resultados aparece apenas APOS confirmacao do servidor.
local resultsPanel = makeFrame(window, "Results", UDim2.fromScale(.5,.5),
    UDim2.fromOffset(690, 455), C.Panel, 12)
resultsPanel.AnchorPoint = Vector2.new(.5,.5)
resultsPanel.Visible = false
resultsPanel.ZIndex = 15
stroke(resultsPanel, C.Gold, 2)
makeText(resultsPanel, "ResultTitle", "INVOCACÃO CONCLUÍDA",
    UDim2.fromOffset(24, 22), UDim2.fromOffset(620, 46), 26, C.Gold, true)
local resultItems = makeText(resultsPanel, "ResultList", "",
    UDim2.fromOffset(24, 95), UDim2.fromOffset(640, 270), 22, C.White)
resultItems.TextYAlignment = Enum.TextYAlignment.Top
local resultClose = makeButton(resultsPanel, "ResultClose", "CONTINUAR",
    UDim2.fromOffset(210, 393), UDim2.fromOffset(270, 46), C.Blue)
resultClose.ZIndex = 16

local ready = false
local purchasing = false
local bannerId: string? = nil
local savedGuiStates: {[string]: boolean} = {}

local function showModel()
    world:ClearAllChildren()
    local folder = ReplicatedStorage:FindFirstChild("CapsuleUnitModels")
    if not folder then
        fallback.Visible = true
        fallback.Text = "MODELO DA CAPSULE AINDA NÃO CARREGADO"
        return
    end
    local name = previewShiny and "Capsule_Legendary_Shiny" or "Capsule_Legendary"
    local original = folder:FindFirstChild(name)
    if not original or not original:IsA("Model") then
        fallback.Visible = true
        fallback.Text = "MODELO NÃO ENCONTRADO: " .. name
        return
    end
    local model = original:Clone()
    model.Parent = world
    model:PivotTo(CFrame.new())
    fallback.Visible = false
    previewTitle.Text = if previewShiny then "CAPSULE ★ SHINY  •  LENDÁRIA"
        else "CAPSULE  •  LENDÁRIA"
end
previewButton.Activated:Connect(function()
    previewShiny = not previewShiny
    previewButton.Text = if previewShiny then "VER NORMAL" else "VER SHINY ★"
    showModel()
end)

local function updateState(data: any)
    ready = typeof(data) == "table" and data.Ready == true
    if not ready then
        stateLabel.Text = if typeof(data) == "table" then (data.Error or "Perfil indisponível") else "Perfil indisponível"
        ticketsLabel.Text = "TICKETS: --"
        oneButton.Active = false
        tenButton.Active = false
        return
    end
    local pityText = "Pity Shiny: ainda não definido"
    if typeof(data.Banner) == "table" then
        bannerId = data.Banner.Id
        if typeof(data.Banner.ShinyPity) == "number" and data.Banner.ShinyPity > 0 then
            pityText = string.format("Pity Shiny: %d/%d",
                data.ShinyMisses or 0, data.Banner.ShinyPity)
        end
        if typeof(data.Banner.PriceOne) == "number" then
            oneButton.Text = string.format("INVOCAR 1×   •   %d TICKET(S)", data.Banner.PriceOne)
        end
        if typeof(data.Banner.PriceTen) == "number" then
            tenButton.Text = string.format("INVOCAR 10×   •   %d TICKET(S)", data.Banner.PriceTen)
        end
        if typeof(data.Banner.ShinyChance) == "number" then
            rate.Text = string.format("CAPSULE: 100%%  |  SHINY: %.2f%% (PROVISÓRIO)", data.Banner.ShinyChance * 100)
        end
    end
    ticketsLabel.Text = "TICKETS: " .. tostring(data.Tickets or 0)
    local prefix = data.StudioMode and "MODO STUDIO • TICKETS DE TESTE" or "ECONOMIA OFICIAL AINDA NÃO CONECTADA"
    stateLabel.Text = prefix .. "\n" .. pityText
    collectionLabel.Text = string.format("NA COLEÇÃO: Normal %d  |  Shiny %d",
        data.CapsuleNormal or 0, data.CapsuleShiny or 0)
    oneButton.Active = true
    tenButton.Active = true
end

local function hideOtherUI()
    savedGuiStates = {}
    for _, name in ipairs({"AnimeFissureLobbyUI", "SummonPrototype"}) do
        local other = playerGui:FindFirstChild(name)
        if other and other:IsA("ScreenGui") then
            savedGuiStates[name] = other.Enabled
            other.Enabled = false
        end
    end
end

local function restoreOtherUI()
    for name, wasEnabled in pairs(savedGuiStates) do
        local other = playerGui:FindFirstChild(name)
        if other and other:IsA("ScreenGui") then
            other.Enabled = wasEnabled and player:GetAttribute("InArena") ~= true
        end
    end
    table.clear(savedGuiStates)
end

local function close()
    resultsPanel.Visible = false
    gui.Enabled = false
    restoreOtherUI()
end
closeButton.Activated:Connect(close)
-- Close consistently with ESC on PC or B on gamepad; never interrupt
-- an in-flight server Summon just to hide its confirmation.
UserInputService.InputBegan:Connect(function(input: InputObject,processed: boolean)
    if processed or not gui.Enabled or purchasing then return end
    if input.KeyCode==Enum.KeyCode.Escape
        or input.KeyCode==Enum.KeyCode.ButtonB then
        if resultsPanel.Visible then resultsPanel.Visible=false
        else close() end
    end
end)
resultClose.Activated:Connect(function()
    resultsPanel.Visible = false
end)
player:GetAttributeChangedSignal("InArena"):Connect(function()
    if player:GetAttribute("InArena") == true then close() end
end)

local function open()
    if player:GetAttribute("InArena") == true or gui.Enabled then return end
    hideOtherUI()
    gui.Enabled = true
    resultsPanel.Visible = false
    stateLabel.Text = "Consultando inventário no servidor..."
    ready = false
    oneButton.Active, tenButton.Active = false, false
    showModel()
    task.spawn(function()
        local ok, data = pcall(function() return stateRemote:InvokeServer() end)
        if not gui.Enabled then return end
        if not ok then updateState({Ready=false,Error="Erro de conexão com o servidor"})
        else updateState(data) end
    end)
end
openEvent.OnClientEvent:Connect(open)

local function buy(count: number)
    if purchasing or not ready or not bannerId then return end
    purchasing = true
    oneButton.Active, tenButton.Active = false, false
    stateLabel.Text = "O servidor está processando seu Summon..."
    local txId = HttpService:GenerateGUID(false)
    task.spawn(function()
        local ok, response = pcall(function()
            return purchaseRemote:InvokeServer(bannerId, count, txId)
        end)
        if not gui.Enabled then purchasing = false; return end
        if not ok or typeof(response) ~= "table" then
            purchasing = false
            stateLabel.Text = "Não foi possível confirmar o resultado. Abra o Summon novamente."
            oneButton.Active, tenButton.Active = true, true
            return
        end
        if not response.Ok then
            purchasing = false
            stateLabel.Text = response.Error or "Invocação recusada"
            oneButton.Active, tenButton.Active = true, true
            return
        end
        local lines = {}
        for i, reward in ipairs(response.Items or {}) do
            local shinyText = reward.Shiny and " ★ SHINY" or ""
            local display = if reward.UnitId == "Capsule" then "CAPSULE" else tostring(reward.UnitId)
            table.insert(lines, string.format("%02d  •  %s%s  [%s]", i, display, shinyText, reward.Rarity or "?"))
        end
        resultItems.Text = table.concat(lines, "\n")
        if response.State then
            response.State.Banner = {Id = bannerId}
            updateState(response.State)
        else
            oneButton.Active, tenButton.Active = true, true
        end
        -- A recompensa ja foi salva no servidor. Aqui so a REVELAMOS.
        -- Caso o render 3D falhe, a janela anterior continua como fallback.
        local cinematicOk, shown = pcall(function()
            return SummonReveal.Play(response.Items or {})
        end)
        purchasing = false
        if not cinematicOk or not shown then
            warn("[Summon HUD] Revelacao cinematica indisponivel:", shown)
            if gui.Enabled then
                resultsPanel.Visible = true
                resultsPanel.BackgroundTransparency = 0
            end
        end
    end)
end
oneButton.Activated:Connect(function() buy(1) end)
tenButton.Activated:Connect(function() buy(10) end)

print("[Anime Fissure] SummonHUD v0.2 com revelacao cinematica online")
