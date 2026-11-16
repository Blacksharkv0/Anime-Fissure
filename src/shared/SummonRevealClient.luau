--!strict
-- ANIME FISSURE | SummonRevealClient v0.2
-- Cinematica exibida SOMENTE DEPOIS da compra confirmada pelo servidor.
-- Nunca sorteia, concede ou cobra unidades. Aceita os resultados certificados
-- da funcao SummonService.Purchase, inclusive as variantes Shiny.
-- Cenarios 3D locais, luzes, camera, Guardian e vitrine com ViewportFrame.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local GuardianBuilder = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("GuardianBuilder"))
local Reveal = {}
local running = false

local C = {
    Dark = Color3.fromRGB(5, 9, 24),
    Panel = Color3.fromRGB(15, 25, 51),
    Panel2 = Color3.fromRGB(27, 39, 76),
    White = Color3.fromRGB(239, 247, 255),
    Cyan = Color3.fromRGB(81, 228, 255),
    Blue = Color3.fromRGB(60, 126, 255),
    Violet = Color3.fromRGB(166, 99, 255),
    Gold = Color3.fromRGB(255, 216, 112),
}

local function round(parent: Instance, radius: number)
    local u = Instance.new("UICorner")
    u.CornerRadius = UDim.new(0, radius)
    u.Parent = parent
end
local function border(parent: Instance, color: Color3, thickness: number)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness
    s.Color = color
    s.Transparency = 0.12
    s.Parent = parent
end
local function newLabel(parent: Instance, name: string, text: string,
    size: UDim2, pos: UDim2, fontSize: number, color: Color3): TextLabel
    local t = Instance.new("TextLabel")
    t.Name = name
    t.Size = size
    t.Position = pos
    t.Text = text
    t.TextColor3 = color
    t.Font = Enum.Font.GothamBlack
    t.TextSize = fontSize
    t.BackgroundTransparency = 1
    t.TextScaled = false
    t.TextWrapped = true
    t.Parent = parent
    return t
end
local function newButton(parent: Instance, text: string, size: UDim2,
    pos: UDim2, color: Color3): TextButton
    local b = Instance.new("TextButton")
    b.Name = "SummonAction"
    b.Size = size
    b.Position = pos
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = C.White
    b.TextSize = 18
    b.Font = Enum.Font.GothamBold
    b.Parent = parent
    round(b, 10)
    return b
end

local function staticPart(parent: Model, name: string, size: Vector3,
    cf: CFrame, color: Color3, material: Enum.Material): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = material
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.CastShadow = false
    p.Parent = parent
    return p
end

local function modelFor(item: any): Model?
    local folder = ReplicatedStorage:FindFirstChild("CapsuleUnitModels")
    if not folder then return nil end
    if typeof(item) ~= "table" then return nil end
    local unitId = item.UnitId
    local shiny = item.Shiny == true
    local name: string?
    if unitId == "Capsule" then
        name = if shiny then "Capsule_Legendary_Shiny" else "Capsule_Legendary"
    elseif unitId == "CapsuleCorp" then
        -- Nunca pertence ao banner, mas o modelo pode servir no Evolve.
        name = if shiny then "CapsuleCorp_Mythic_Shiny" else "CapsuleCorp_Mythic"
    end
    if not name then return nil end
    local original = folder:FindFirstChild(name)
    if original and original:IsA("Model") then
        return original:Clone()
    end
    return nil
end

local function renderUnit(card: Frame, item: any, w: number, h: number)
    local view = Instance.new("ViewportFrame")
    view.Name = "UnitPreview"
    view.Size = UDim2.fromOffset(w - 16, h - 70)
    view.Position = UDim2.fromOffset(8, 8)
    view.BackgroundColor3 = C.Dark
    view.BackgroundTransparency = 0.15
    view.Ambient = Color3.fromRGB(191, 210, 251)
    view.LightColor = Color3.fromRGB(255, 247, 226)
    view.LightDirection = Vector3.new(-1, -1, -1)
    view.Parent = card
    round(view, 7)

    local world = Instance.new("WorldModel")
    world.Parent = view
    local camera = Instance.new("Camera")
    camera.FieldOfView = 36
    camera.CFrame = CFrame.lookAt(Vector3.new(1.1, -0.1, -11.3), Vector3.new(0, -0.15, 0))
    camera.Parent = view
    view.CurrentCamera = camera
    local model = modelFor(item)
    if model then
        model.Parent = world
        model:PivotTo(CFrame.new())
    else
        newLabel(view, "PreviewUnavailable", tostring(item.UnitId or "UNIDADE"),
            UDim2.fromScale(1, 1), UDim2.fromScale(0, 0), 16, C.Cyan)
    end
end

local function resultCard(parent: Frame, item: any, w: number, h: number)
    local shiny = typeof(item) == "table" and item.Shiny == true
    local color = if shiny then C.Gold else C.Blue
    local card = Instance.new("Frame")
    card.Name = if shiny then "ShinyReward" else "NormalReward"
    card.Size = UDim2.fromOffset(w, h)
    card.BackgroundColor3 = C.Panel2
    card.BorderSizePixel = 0
    card.Parent = parent
    round(card, 10)
    border(card, color, if shiny then 3 else 1)
    renderUnit(card, item, w, h)
    local unitName = if item.UnitId == "Capsule" then "CAPSULE" else tostring(item.UnitId)
    newLabel(card, "UnitName", unitName, UDim2.new(1, -8, 0, 23),
        UDim2.fromOffset(4, h - 58), 14, C.White)
    newLabel(card, "Rarity", if shiny then "★ SHINY ★" else "LENDÁRIA",
        UDim2.new(1, -8, 0, 25), UDim2.fromOffset(4, h - 33),
        14, if shiny then C.Gold else C.Cyan)
    return card
end

local function showResults(gui: ScreenGui, items: {any}, flash: Frame)
    flash.BackgroundTransparency = 1
    local existing = gui:FindFirstChild("CinematicTitle")
    if existing and existing:IsA("TextLabel") then existing.Visible = false end
    local result = Instance.new("Frame")
    result.Name = "ResultWindow"
    result.Size = UDim2.fromOffset(1060, 615)
    result.AnchorPoint = Vector2.new(0.5, 0.5)
    result.Position = UDim2.fromScale(0.5, 0.5)
    result.BackgroundColor3 = C.Panel
    result.BorderSizePixel = 0
    result.Parent = gui
    round(result, 15)
    border(result, C.Violet, 2)
    local scale = Instance.new("UIScale")
    scale.Parent = result
    local function resize()
        local camera = workspace.CurrentCamera
        if camera then
            local size = camera.ViewportSize
            scale.Scale = math.clamp(math.min((size.X - 35) / 1085,
                (size.Y - 85) / 670, 1), 0.35, 1)
        end
    end
    resize()
    newLabel(result, "ResultHeading", "FISSURA CONCLUÍDA",
        UDim2.new(1, -55, 0, 48), UDim2.fromOffset(27, 11), 29, C.White)
    newLabel(result, "ResultSubtitle", string.format("%d unidade(s) obtida(s) e salva(s) pelo servidor", #items),
        UDim2.new(1, -55, 0, 27), UDim2.fromOffset(27, 61), 15, C.Cyan)

    local count = #items
    local cards = Instance.new("Frame")
    cards.Name = "RewardCards"
    cards.Size = UDim2.fromOffset(1020, 435)
    cards.Position = UDim2.fromOffset(20, 99)
    cards.BackgroundTransparency = 1
    cards.Parent = result
    if count == 1 then
        local card = resultCard(cards, items[1], 350, 420)
        card.Position = UDim2.fromOffset(335, 6)
    else
        local grid = Instance.new("UIGridLayout")
        grid.CellPadding = UDim2.fromOffset(16, 12)
        grid.CellSize = UDim2.fromOffset(188, 208)
        grid.FillDirection = Enum.FillDirection.Horizontal
        grid.FillDirectionMaxCells = 5
        grid.HorizontalAlignment = Enum.HorizontalAlignment.Center
        grid.VerticalAlignment = Enum.VerticalAlignment.Center
        grid.SortOrder = Enum.SortOrder.LayoutOrder
        grid.Parent = cards
        for _, item in ipairs(items) do
            resultCard(cards, item, 188, 208)
        end
    end

    local close = newButton(result, "CONTINUAR", UDim2.fromOffset(275, 48),
        UDim2.fromOffset(392, 546), C.Blue)
    local done = false
    close.Activated:Connect(function() done = true end)
    while not done and gui.Parent do task.wait(0.05) end
    result:Destroy()
end

function Reveal.Play(items: {any}): boolean
    if running or typeof(items) ~= "table" or #items == 0 then return false end
    running = true
    local player = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "AnimeFissureSummonReveal"
    gui.IgnoreGuiInset = false
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 400
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = playerGui
    local veil = Instance.new("Frame")
    veil.Name = "CinematicBackdrop"
    veil.Size = UDim2.fromScale(1,1)
    veil.BackgroundColor3 = C.Dark
    veil.BorderSizePixel = 0
    veil.Parent = gui
    local flash = Instance.new("Frame")
    flash.Name = "Flash"
    flash.Size = UDim2.fromScale(1, 1)
    flash.BackgroundColor3 = C.White
    flash.BackgroundTransparency = 1
    flash.BorderSizePixel = 0
    flash.Parent = gui
    local title = newLabel(gui, "CinematicTitle", "UMA FISSURA FOI ABERTA",
        UDim2.fromScale(0.94, 0.14), UDim2.fromScale(0.03, 0.07), 32, C.Cyan)
    title.TextScaled = true
    title.ZIndex = 3
    local skip = newButton(gui, "PULAR ANIMAÇÃO", UDim2.fromOffset(165, 45),
        UDim2.new(1, -180, 1, -65), C.Panel2)
    skip.ZIndex = 5

    local cancelled = false
    skip.Activated:Connect(function() cancelled = true end)
    local camera = workspace.CurrentCamera
    local oldType = if camera then camera.CameraType else Enum.CameraType.Custom
    local oldCFrame = if camera then camera.CFrame else CFrame.new()
    local oldSubject = if camera then camera.CameraSubject else nil
    local oldFov = if camera then camera.FieldOfView else 70
    local scene: Model? = nil
    local tweens: {Tween} = {}
    local function tween(object: Instance, sec: number, properties: {[string]: any})
        local tw = TweenService:Create(object, TweenInfo.new(sec, Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out), properties)
        table.insert(tweens, tw)
        tw:Play()
        return tw
    end
    local function phase(seconds: number): boolean
        local elapsed = 0
        while elapsed < seconds and not cancelled and gui.Parent do
            elapsed += RunService.Heartbeat:Wait()
        end
        return not cancelled and gui.Parent ~= nil
    end
    local function cleanup()
        for _, t in ipairs(tweens) do t:Cancel() end
        if scene then scene:Destroy(); scene = nil end
        if camera and workspace.CurrentCamera == camera then
            camera.CameraType = oldType
            camera.CameraSubject = oldSubject
            camera.CFrame = oldCFrame
            camera.FieldOfView = oldFov
        end
    end

    local ok, err = pcall(function()
        if not camera then return end
        -- Mundo paralelo local: o jogador continua onde esta, sem teleporte.
        local origin = Vector3.new(0, 20000, 0)
        scene = Instance.new("Model")
        scene.Name = "AnimeFissureLocalRevealScene"
        scene.Parent = workspace
        staticPart(scene, "FloatingPlatform", Vector3.new(33, 2, 28),
            CFrame.new(origin), C.Panel2, Enum.Material.Slate)
        local core = staticPart(scene, "RiftCore", Vector3.new(0.45, 1.6, 0.45),
            CFrame.new(origin + Vector3.new(0, 8, -6)), C.Violet, Enum.Material.Neon)
        local bloom = Instance.new("PointLight")
        bloom.Color = C.Violet
        bloom.Range = 38
        bloom.Brightness = 3
        bloom.Parent = core
        for i = 1, 25 do
            local a = i * math.pi * 2 / 25
            staticPart(scene, "RiftSpark", Vector3.new(0.4, 0.4, 0.4),
                CFrame.new(origin + Vector3.new(math.cos(a) * 9, 8 + math.sin(a * 3) * 4,
                    -6 + math.sin(a) * 5)), if i % 2 == 0 then C.Violet else C.Cyan,
                Enum.Material.Neon)
        end
        local guardian = GuardianBuilder.Build(CFrame.new(origin + Vector3.new(0, 1, 0)))
        guardian.Parent = scene
        local focus = origin + Vector3.new(0, 8, 0)
        camera.CameraType = Enum.CameraType.Scriptable
        camera.FieldOfView = 58
        camera.CFrame = CFrame.lookAt(focus + Vector3.new(0, 2, -26), focus)
        veil.BackgroundTransparency = 0.65
        title.Text = "O GUARDIÃO RESPONDEU AO SEU CHAMADO"
        tween(camera, 1.15, {CFrame = CFrame.lookAt(focus + Vector3.new(0, 2, -17), focus)})
        if not phase(1.35) then return end
        title.Text = "AS FISSURAS ESTÃO SE ROMPENDO..."
        for t = 1, 10 do
            if cancelled then return end
            GuardianBuilder.SetPose(guardian, "Ready", t / 10)
            if not phase(0.055) then return end
        end
        for t = 1, 8 do
            if cancelled then return end
            GuardianBuilder.SetPose(guardian, "Slash", t / 8)
            if not phase(0.035) then return end
        end
        GuardianBuilder.SetPose(guardian, "Finish", 1)
        title.Text = "UNIDADE ENCONTRADA!"
        core.Size = Vector3.new(0.45, 1.6, 0.45)
        core.Transparency = 0.2
        tween(core, 0.45, {Size = Vector3.new(12, 14, 0.5), Color = C.Cyan})
        flash.BackgroundTransparency = 0.08
        tween(flash, 0.5, {BackgroundTransparency = 1})
        if not phase(0.5) then return end
        local highlight = items[1]
        for _, item in ipairs(items) do
            if item.Shiny == true then highlight = item; break end
        end
        local unitModel = modelFor(highlight)
        if unitModel then
            unitModel.Parent = scene
            unitModel:PivotTo(CFrame.new(origin + Vector3.new(0, 9, -7)))
        end
        if highlight.Shiny then
            title.Text = "★ SHINY! UMA UNIDADE RARA! ★"
            title.TextColor3 = C.Gold
            bloom.Color = C.Gold
            core.Color = C.Gold
        else
            title.Text = "CAPSULE • LENDÁRIA"
        end
        camera.FieldOfView = 52
        tween(camera, 0.65, {CFrame = CFrame.lookAt(
            origin + Vector3.new(0, 11, -19),
            origin + Vector3.new(0, 8.5, -7))})
        phase(1.25)
    end)
    if not ok then
        warn("[Anime Fissure] Falha na parte 3D da cinematica:", err)
    end
    cleanup()
    skip:Destroy()
    veil.BackgroundTransparency = 0
    local good, finalError = pcall(function()
        showResults(gui, items, flash)
    end)
    if not good then
        warn("[Anime Fissure] Erro na tela de resultados:", finalError)
    end
    gui:Destroy()
    running = false
    return good
end

return Reveal
