
--!strict
-- ANIME FISSURE | Summon Cinematic v2.0
-- Prototipo local integrado ao GuardianBuilder.
-- Nao sorteia unidades nem consome moedas.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local GuardianBuilder = require(
    ReplicatedStorage:WaitForChild("Shared")
        :WaitForChild("GuardianBuilder")
)

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local BLUE = Color3.fromRGB(45, 125, 255)
local CYAN = Color3.fromRGB(85, 235, 255)
local PURPLE = Color3.fromRGB(125, 65, 225)
local DARK = Color3.fromRGB(9, 12, 30)

local existing = playerGui:FindFirstChild("SummonPrototype")
if existing then
    existing:Destroy()
end

local oldScene = workspace:FindFirstChild("LocalSummonScene")
if oldScene then
    oldScene:Destroy()
end

local gui = Instance.new("ScreenGui")
gui.Name = "SummonPrototype"
gui.ResetOnSpawn = false
gui.DisplayOrder = 90
gui.Parent = playerGui

local function corner(parent: Instance)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = parent
end

local testButton = Instance.new("TextButton")
testButton.Name = "TestSummon"
testButton.AnchorPoint = Vector2.new(0.5, 0)
testButton.Position = UDim2.fromScale(0.5, 0.04)
testButton.Size = UDim2.fromOffset(190, 44)
testButton.BackgroundColor3 = DARK
testButton.TextColor3 = CYAN
testButton.Font = Enum.Font.GothamBold
testButton.TextSize = 17
testButton.Text = "TESTAR SUMMON"
testButton.Parent = gui
corner(testButton)

local buttonStroke = Instance.new("UIStroke")
buttonStroke.Color = BLUE
buttonStroke.Thickness = 2
buttonStroke.Parent = testButton

local overlay = Instance.new("Frame")
overlay.Name = "CinematicOverlay"
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundTransparency = 1
overlay.BackgroundColor3 = DARK
overlay.Visible = false
overlay.Parent = gui

local title = Instance.new("TextLabel")
title.AnchorPoint = Vector2.new(0.5, 0)
title.Position = UDim2.fromScale(0.5, 0.08)
title.Size = UDim2.fromScale(0.8, 0.09)
title.BackgroundTransparency = 1
title.Text = ""
title.TextColor3 = Color3.new(1, 1, 1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = overlay

local skipButton = Instance.new("TextButton")
skipButton.AnchorPoint = Vector2.new(1, 1)
skipButton.Position = UDim2.new(1, -18, 1, -18)
skipButton.Size = UDim2.fromOffset(110, 42)
skipButton.BackgroundColor3 = DARK
skipButton.TextColor3 = Color3.new(1, 1, 1)
skipButton.Text = "PULAR"
skipButton.TextSize = 16
skipButton.Font = Enum.Font.GothamBold
skipButton.Parent = overlay
corner(skipButton)

local busy = false
local cancelled = false
local activeScene: Model? = nil
local activeTweens: {Tween} = {}

local function makePart(
    parent: Instance,
    name: string,
    size: Vector3,
    cf: CFrame,
    color: Color3,
    material: Enum.Material
): Part
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

local function tween(
    target: Instance,
    duration: number,
    properties: {[string]: any}
): Tween
    local tw = TweenService:Create(
        target,
        TweenInfo.new(
            duration,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        properties
    )

    table.insert(activeTweens, tw)
    tw:Play()

    return tw
end

local function waitFor(seconds: number): boolean
    local elapsed = 0

    while elapsed < seconds do
        if cancelled then
            return false
        end

        elapsed += RunService.Heartbeat:Wait()
    end

    return not cancelled
end

local function playPose(
    guardian: Model,
    pose: string,
    duration: number
): boolean
    local elapsed = 0

    while elapsed < duration do
        if cancelled then
            return false
        end

        elapsed += RunService.Heartbeat:Wait()

        GuardianBuilder.SetPose(
            guardian,
            pose,
            math.clamp(elapsed / duration, 0, 1)
        )
    end

    return not cancelled
end

local function createArena(origin: Vector3): Model
    local scene = Instance.new("Model")
    scene.Name = "LocalSummonScene"
    scene.Parent = workspace
    activeScene = scene

    local rng = Random.new(2090)

    makePart(
        scene, "FloatingArena",
        Vector3.new(34, 2, 28),
        CFrame.new(origin),
        Color3.fromRGB(30, 39, 70),
        Enum.Material.Slate
    )

    -- Rochas e ruinas flutuantes.
    for i = 1, 28 do
        local angle = rng:NextNumber(0, math.pi * 2)
        local distance = rng:NextNumber(20, 55)

        local position = origin + Vector3.new(
            math.cos(angle) * distance,
            rng:NextNumber(-6, 22),
            math.sin(angle) * distance
        )

        local rock = makePart(
            scene, "FloatingRock",
            Vector3.new(
                rng:NextNumber(2, 7),
                rng:NextNumber(1, 4),
                rng:NextNumber(2, 7)
            ),
            CFrame.new(position)
                * CFrame.Angles(
                    rng:NextNumber(-1, 1),
                    rng:NextNumber(-3, 3),
                    rng:NextNumber(-1, 1)
                ),
            Color3.fromRGB(43, 50, 85),
            Enum.Material.Slate
        )

        tween(
            rock,
            rng:NextNumber(3, 6),
            {Position = rock.Position + Vector3.new(0, 2, 0)}
        )
    end

    -- Estrelas.
    for i = 1, 60 do
        local star = makePart(
            scene, "CosmicStar",
            Vector3.new(0.3, 0.3, 0.3),
            CFrame.new(origin + Vector3.new(
                rng:NextNumber(-90, 90),
                rng:NextNumber(10, 70),
                rng:NextNumber(-85, -35)
            )),
            i % 3 == 0 and PURPLE or CYAN,
            Enum.Material.Neon
        )
        star.Shape = Enum.PartType.Ball
    end

    -- Lua dimensional.
    local moon = makePart(
        scene, "BlueMoon",
        Vector3.new(30, 30, 30),
        CFrame.new(
            origin + Vector3.new(20, 35, -65)
        ),
        Color3.fromRGB(66, 118, 225),
        Enum.Material.Neon
    )
    moon.Shape = Enum.PartType.Ball

    -- Duas colunas de ruinas.
    for _, x in ipairs({-14, 14}) do
        makePart(
            scene, "RuinedPillar",
            Vector3.new(2.4, 11, 2.4),
            CFrame.new(origin + Vector3.new(x, 6, -7))
                * CFrame.Angles(
                    0, 0, math.rad(x < 0 and -8 or 8)
                ),
            Color3.fromRGB(44, 51, 82),
            Enum.Material.Slate
        )
    end

    return scene
end

local function makeSlash(
    scene: Model,
    origin: Vector3
): Part
    local slash = makePart(
        scene, "DimensionalSlash",
        Vector3.new(0.2, 0.25, 0.3),
        CFrame.new(origin + Vector3.new(0, 8, -7))
            * CFrame.Angles(0, 0, math.rad(-12)),
        CYAN,
        Enum.Material.Neon
    )

    tween(
        slash,
        0.23,
        {Size = Vector3.new(29, 0.25, 0.3)}
    )

    return slash
end

local function makeRift(
    scene: Model,
    origin: Vector3
)
    local rift = makePart(
        scene, "DimensionalRift",
        Vector3.new(0.2, 0.3, 0.3),
        CFrame.new(origin + Vector3.new(0, 8, -9)),
        PURPLE,
        Enum.Material.Neon
    )

    tween(
        rift,
        0.7,
        {
            Size = Vector3.new(27, 13, 0.4),
            Color = BLUE
        }
    )
end

local function makeBeams(
    scene: Model,
    origin: Vector3
)
    local colors = {
        BLUE,
        Color3.fromRGB(255, 195, 65),
        PURPLE
    }

    for i = 1, 3 do
        local beam = makePart(
            scene, "SummonBeam" .. i,
            Vector3.new(2, 0.2, 2),
            CFrame.new(origin + Vector3.new(
                (i - 2) * 7,
                7,
                -6
            )),
            colors[i],
            Enum.Material.Neon
        )

        tween(
            beam,
            0.65,
            {
                Size = Vector3.new(2, 14, 2),
                Position = beam.Position
                    + Vector3.new(0, 7, 0)
            }
        )
    end
end

local function cancelTweens()
    for _, tw in ipairs(activeTweens) do
        tw:Cancel()
    end
    table.clear(activeTweens)
end

local function runCinematic()
    if busy then return end

    busy = true
    cancelled = false
    testButton.Visible = false
    overlay.Visible = true
    overlay.BackgroundTransparency = 1

    local camera = workspace.CurrentCamera

    if not camera then
        overlay.Visible = false
        testButton.Visible = true
        busy = false
        return
    end

    local oldType = camera.CameraType
    local oldSubject = camera.CameraSubject
    local oldCFrame = camera.CFrame
    local oldFov = camera.FieldOfView

    -- Posicao isolada para o prototipo local.
    local origin = Vector3.new(0, 20000, 0)
    local scene = createArena(origin)

    -- Aqui usamos o modulo oficial.
    local guardian = GuardianBuilder.Build(
        CFrame.new(origin + Vector3.new(0, 1, 0))
    )
    guardian.Parent = scene

    local focus = origin + Vector3.new(0, 7, 0)

    camera.CameraType = Enum.CameraType.Scriptable
    camera.FieldOfView = 58
    camera.CFrame = CFrame.lookAt(
        focus + Vector3.new(0, 3, -24),
        focus
    )

    title.Text = "O VAZIO DAS FISSURAS"

    -- ETAPA 1: aproximacao.
    tween(
        camera,
        1.3,
        {
            CFrame = CFrame.lookAt(
                focus + Vector3.new(0, 1, -16),
                focus
            )
        }
    )

    local ok = waitFor(1.5)

    -- ETAPA 2: preparacao.
    if ok then
        title.Text = "A REALIDADE ESTA PRESTES A SE ROMPER"

        ok = playPose(guardian, "Ready", 0.85)
    end

    -- ETAPA 3: golpe.
    if ok then
        title.Text = ""

        -- A pose Slash comeca na posicao Ready.
        makeSlash(scene, origin)
        ok = playPose(guardian, "Slash", 0.32)
    end

    -- ETAPA 4: congelamento e ruptura.
    if ok then
        GuardianBuilder.SetPose(guardian, "Finish", 1)

        ok = waitFor(0.18)

        if ok then
            makeRift(scene, origin)

            tween(
                overlay,
                0.12,
                {BackgroundTransparency = 0.5}
            )

            ok = waitFor(0.14)

            if ok then
                tween(
                    overlay,
                    0.35,
                    {BackgroundTransparency = 1}
                )
            end
        end
    end

    -- ETAPA 5: revelacao.
    if ok then
        ok = waitFor(0.75)
    end

    if ok then
        title.Text = "UNIDADES ENCONTRADAS"
        makeBeams(scene, origin)
        waitFor(1.6)
    end

    -- Limpeza e restauracao.
    cancelTweens()

    if workspace.CurrentCamera == camera then
        camera.CameraType = oldType
        camera.CameraSubject = oldSubject
        camera.CFrame = oldCFrame
        camera.FieldOfView = oldFov
    end

    if activeScene == scene then
        activeScene = nil
    end

    scene:Destroy()

    overlay.Visible = false
    testButton.Visible = true
    busy = false
end

skipButton.Activated:Connect(function()
    cancelled = true
end)

testButton.Activated:Connect(function()
    task.spawn(runCinematic)
end)

gui.Destroying:Connect(function()
    cancelled = true
    cancelTweens()

    if activeScene then
        activeScene:Destroy()
        activeScene = nil
    end
end)

print("[Anime Fissure] Summon Cinematic v2.0 carregado")
