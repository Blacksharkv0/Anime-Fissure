--!strict
-- ANIME FISSURE | Interface Visual Polish v0.3
-- Patch visual ADITIVO: nao troca botao de Summon, remotes nem inventario.
-- Ajusta o layout a largura/altura reais para respeitar a barra superior.

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local PALE = Color3.fromRGB(220, 233, 252)
local PANEL = Color3.fromRGB(24, 36, 69)
local PURPLE = Color3.fromRGB(155, 106, 241)

local function textColor(root: Instance, name: string, color: Color3)
    local label = root:FindFirstChild(name, true)
    if label and label:IsA("TextLabel") then label.TextColor3 = color end
end

-- Every main screen now owns its own responsive UIScale. This art pass
-- must NOT attach a second resize handler that fights Summon/Alchemy.
local function styleWindow(gui: ScreenGui,root: Frame)
    gui.IgnoreGuiInset=false
    root.BackgroundColor3=Color3.fromRGB(16,26,52)
    local close=root:FindFirstChild("Close",true)
    if close and close:IsA("TextButton") then
        close.Text="✕"
        close.TextSize=19
        close.TextColor3=PALE
    end
end

local function polishSummon(gui: ScreenGui)
    local backdrop = gui:WaitForChild("Backdrop", 18)
    local root = backdrop and backdrop:WaitForChild("Window", 18)
    if not root or not root:IsA("Frame") then return end
    if gui:GetAttribute("VisualPolishApplied") then return end
    gui:SetAttribute("VisualPolishApplied", true)

    styleWindow(gui, root)
    local veil = backdrop :: Frame
    veil.BackgroundTransparency = 0.17
    for _, name in ipairs({"CharacterPanel", "PurchasePanel"}) do
        local panel = root:FindFirstChild(name, true)
        if panel and panel:IsA("Frame") then panel.BackgroundColor3 = PANEL end
    end
    local viewport = root:FindFirstChild("CapsuleViewport", true)
    if viewport and viewport:IsA("ViewportFrame") then
        viewport.BackgroundColor3 = Color3.fromRGB(35, 50, 88)
        viewport.LightColor = Color3.fromRGB(255, 252, 244)
        viewport.Ambient = Color3.fromRGB(215, 228, 247)
        local camera = viewport.CurrentCamera
        if camera then
            camera.FieldOfView = 39
            camera.CFrame = CFrame.lookAt(Vector3.new(3.3, 1.4, -10.5), Vector3.new(0, -0.1, 0))
        end
    end
    for _, name in ipairs({"Info", "EvolutionNote", "Collection", "State"}) do
        textColor(root, name, PALE)
    end
    local btn = root:FindFirstChild("SummonOne", true)
    if btn and btn:IsA("TextButton") then
        btn.BackgroundColor3 = Color3.fromRGB(45, 124, 245)
    end
    local ten = root:FindFirstChild("SummonTen", true)
    if ten and ten:IsA("TextButton") then
        ten.BackgroundColor3 = PURPLE
    end
    print("[Fissure Visual] Summon HUD responsivo")
end

local function polishAlchemy(gui: ScreenGui)
    local backdrop = gui:WaitForChild("Backdrop", 18)
    local root = backdrop and backdrop:WaitForChild("AlchemyWindow", 18)
    if not root or not root:IsA("Frame") then return end
    if gui:GetAttribute("VisualPolishApplied") then return end
    gui:SetAttribute("VisualPolishApplied", true)

    styleWindow(gui, root)
    local veil = backdrop :: Frame
    veil.BackgroundTransparency = 0.20
    for _, name in ipairs({"AlchemyBody", "TransmutationCircle"}) do
        local panel = root:FindFirstChild(name, true)
        if panel and panel:IsA("Frame") then
            panel.BackgroundColor3 = PANEL
        end
    end
    for _, name in ipairs({"Mode", "IngredientInventory", "Explanation"}) do
        textColor(root, name, PALE)
    end
    print("[Fissure Visual] Alchemy HUD v0.2 compatível, sem redimensionamento duplicado")
end

local function findLobbyMenu(gui: ScreenGui): Frame?
    -- O cliente original NAO nomeia o Frame do menu. Encontramos pelo botao JOGAR.
    -- Nunca usar :FindFirstChild("Frame"), pois tambem existe o Loading.
    for _, item in ipairs(gui:GetDescendants()) do
        if item:IsA("TextButton") and item.Text:find("JOGAR", 1, true) then
            local parent = item.Parent
            if parent and parent:IsA("Frame") then return parent end
        end
    end
    return nil
end

local function polishLobby(gui: ScreenGui): boolean
    local menu = findLobbyMenu(gui)
    if not menu then return false end
    if gui:GetAttribute("VisualPolishApplied") then return true end
    gui:SetAttribute("VisualPolishApplied", true)

    menu.Position = UDim2.new(1, -22, 1, -24)
    menu.AnchorPoint = Vector2.new(1, 1)
    menu.BackgroundColor3 = Color3.fromRGB(21, 33, 65)
    menu.BackgroundTransparency = 0.09
    for _, child in ipairs(menu:GetDescendants()) do
        if child:IsA("TextLabel") and child.Text:find("BETA", 1, true) then
            child.TextColor3 = PALE
        end
    end
    print("[Fissure Visual] Lobby menu movido para a direita")
    return true
end

local function onGui(child: Instance)
    if not child:IsA("ScreenGui") then return end
    if child.Name == "AnimeFissureSummonHUD" then
        task.spawn(polishSummon, child)
    elseif child.Name == "AnimeFissureAlchemyHUD" then
        task.spawn(polishAlchemy, child)
    elseif child.Name == "AnimeFissureLobbyUI" then
        task.defer(function()
            -- Espera o botao real surgir antes de alterar o menu.
            local deadline = os.clock() + 12
            while os.clock() < deadline do
                if polishLobby(child) then return end
                task.wait(0.1)
            end
        end)
    end
end

playerGui.ChildAdded:Connect(onGui)
for _, gui in ipairs(playerGui:GetChildren()) do onGui(gui) end
