
--!strict
-- ANIME FISSURE
-- Dimensional Summon | Cinematic Prototype v0.1
-- Teste local, sem sorteio e sem consumo de moedas.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("SummonPrototype")
if oldGui then oldGui:Destroy() end

local oldScene = workspace:FindFirstChild("LocalSummonScene")
if oldScene then oldScene:Destroy() end

local BLUE = Color3.fromRGB(45, 125, 255)
local CYAN = Color3.fromRGB(85, 235, 255)
local PURPLE = Color3.fromRGB(120, 65, 220)
local DARK = Color3.fromRGB(9, 12, 31)

local gui = Instance.new("ScreenGui")
gui.Name = "SummonPrototype"
gui.IgnoreGuiInset = false
gui.ResetOnSpawn = false
gui.DisplayOrder = 90
gui.Parent = playerGui

local function label(
    text: string,
    size: UDim2,
    position: UDim2,
    parent: Instance
): TextLabel
    local item = Instance.new("TextLabel")
    item.Size = size
    item.Position = position
    item.BackgroundTransparency = 1
    item.Text = text
    item.TextColor3 = Color3.new(1, 1, 1)
    item.TextScaled = true
    item.Font = Enum.Font.GothamBold
    item.Parent = parent
    return item
end

local testButton = Instance.new("TextButton")
testButton.Name = "TestSummon"
testButton.AnchorPoint = Vector2.new(0.5, 0)
testButton.Position = UDim2.fromScale(0.5, 0.04)
testButton.Size = UDim2.fromOffset(190, 44)
testButton.BackgroundColor3 = DARK
testButton.TextColor3 = CYAN
testButton.Text = "TESTAR SUMMON"
testButton.TextSize = 17
testButton.Font = Enum.Font.GothamBold
testButton.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = testButton

local stroke = Instance.new("UIStroke")
stroke.Color = BLUE
stroke.Thickness = 2
stroke.Parent = testButton

local overlay = Instance.new("Frame")
overlay.Name = "CinematicOverlay"
overlay.Size = UDim2.fromScale(1, 1)
overlay.BackgroundColor3 = DARK
overlay.BackgroundTransparency = 1
overlay.Visible = false
overlay.Parent = gui

local caption = label(
    "O VAZIO DAS FISSURAS",
    UDim2.fromScale(0.7, 0.09),
    UDim2.fromScale(0.15, 0.08),
    overlay
)

local skip = Instance.new("TextButton")
skip.AnchorPoint = Vector2.new(1, 1)
skip.Position = UDim2.new(1, -18, 1, -18)
skip.Size = UDim2.fromOffset(100, 38)
skip.BackgroundColor3 = DARK
skip.TextColor3 = Color3.new(1, 1, 1)
skip.Text = "PULAR"
skip.TextSize = 16
skip.Font = Enum.Font.GothamBold
skip.Parent = overlay

local skipCorner = Instance.new("UICorner")
skipCorner.CornerRadius = UDim.new(0, 8)
skipCorner.Parent = skip

local scene: Model? = nil
local busy = false
local cancelled = false

local function part(
    parent: Instance,
    name: string,
    size: Vector3,
    cf: CFrame,
    color: Color3,
    material: Enum.Material
): Part
    local p = Instance.new("Part")
    p.Name = name
    p.Anchored = true
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.Size = size
    p.CFrame = cf
    p.Color = color
    p.Material = material
    p.Parent = parent
    return p
end

local function animate(
    object: Instance,
    duration: number,
    properties: {[string]: any}
)
    local t = TweenService:Create(
        object,
        TweenInfo.new(
            duration,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ),
        properties
    )
    t:Play()
    return t
end

local function waitScene(seconds: number): boolean
    local elapsed = 0

    while elapsed < seconds do
        if cancelled then
            return false
        end

        elapsed += task.wait(0.03)
    end

    return true
end

local function makeArena(origin: Vector3)
    local model = Instance.new("Model")
    model.Name = "LocalSummonScene"
    model.Parent = workspace
    scene = model

    local floor = part(
        model, "FloatingArena",
        Vector3.new(34, 2, 28),
        CFrame.new(origin),
        Color3.fromRGB(26, 34, 62),
        Enum.Material.Slate
    )

    -- Placas e fragmentos suspensos.
    local rng = Random.new(2090)

    for i = 1, 32 do
        local angle = rng:NextNumber(0, math.pi * 2)
        local radius = rng:NextNumber(20, 55)
        local height = rng:NextNumber(-9, 20)

        local pos = origin + Vector3.new(
            math.cos(angle) * radius,
            height,
            math.sin(angle) * radius
        )

        local rock = part(
            model, "FloatingFragment",
            Vector3.new(
                rng:NextNumber(2, 7),
                rng:NextNumber(1, 4),
                rng:NextNumber(2, 7)
            ),
            CFrame.new(pos) *
                CFrame.Angles(
                    rng:NextNumber(-1, 1),
                    rng:NextNumber(-3, 3),
                    rng:NextNumber(-1, 1)
                ),
            Color3.fromRGB(40, 48, 83),
            Enum.Material.Slate
        )

        animate(
            rock,
            rng:NextNumber(3, 6),
            {Position = rock.Position + Vector3.new(0, 2, 0)}
        )
    end

    -- Estrelas físicas locais, sem física simulada.
    for i = 1, 65 do
        local pos = origin + Vector3.new(
            rng:NextNumber(-90, 90),
            rng:NextNumber(10, 70),
            rng:NextNumber(-85, -35)
        )

        local star = part(
            model, "CosmicStar",
            Vector3.new(0.3, 0.3, 0.3),
            CFrame.new(pos),
            i % 3 == 0 and PURPLE or CYAN,
            Enum.Material.Neon
        )
        star.Shape = Enum.PartType.Ball
    end

    local moon = part(
        model, "DimensionalMoon",
        Vector3.new(32, 32, 32),
        CFrame.new(origin + Vector3.new(20, 35, -65)),
        Color3.fromRGB(65, 125, 230),
        Enum.Material.Neon
    )
    moon.Shape = Enum.PartType.Ball

    -- Guardião provisório blocado.
    local bodyOrigin = origin + Vector3.new(0, 5, 0)

    local torso = part(
        model, "GuardianTorso",
        Vector3.new(4, 5, 2),
        CFrame.new(bodyOrigin),
        Color3.fromRGB(14, 25, 57),
        Enum.Material.SmoothPlastic
    )

    part(
        model, "GuardianHead",
        Vector3.new(2.8, 2.8, 2.8),
        CFrame.new(bodyOrigin + Vector3.new(0, 4, 0)),
        Color3.fromRGB(210, 220, 235),
        Enum.Material.SmoothPlastic
    )

    for _, x in ipairs({-1.3, 1.3}) do
        part(
            model, "Leg",
            Vector3.new(1.5, 3, 1.8),
            CFrame.new(bodyOrigin + Vector3.new(x, -4, 0)),
            Color3.fromRGB(9, 15, 34),
            Enum.Material.SmoothPlastic
        )
    end

    local sword = part(
        model, "DimensionalBlade",
        Vector3.new(0.25, 0.3, 8),
        CFrame.new(bodyOrigin + Vector3.new(3.4, -1, -1)) *
            CFrame.Angles(0, 0, math.rad(15)),
        CYAN,
        Enum.Material.Neon
    )

    local arm = part(
        model, "SwordArm",
        Vector3.new(1.5, 4, 1.8),
        CFrame.new(bodyOrigin + Vector3.new(3, 0, 0)),
        Color3.fromRGB(22, 50, 112),
        Enum.Material.SmoothPlastic
    )

    return model, torso, arm, sword, floor
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

    local previousType = camera.CameraType
    local previousSubject = camera.CameraSubject
    local previousCFrame = camera.CFrame
    local previousFov = camera.FieldOfView

    -- Cenário longe do lobby, apenas no cliente.
    local origin = Vector3.new(0, 20000, 0)
    local model, torso, arm, sword, floor = makeArena(origin)

    camera.CameraType = Enum.CameraType.Scriptable
    camera.FieldOfView = 58

    local focus = torso.Position + Vector3.new(0, 1.8, 0)
    local front = focus + Vector3.new(0, 2, -22)

    camera.CFrame = CFrame.lookAt(front, focus)
    caption.Text = "O VAZIO DAS FISSURAS"

    -- 1. Aproximação e suspiro.
    animate(
        camera,
        1.4,
        {
            CFrame = CFrame.lookAt(
                focus + Vector3.new(0, 1, -14),
                focus
            )
        }
    )

    if waitScene(1.5) then
        -- 2. Preparação da espada.
        caption.Text = "A REALIDADE ESTÁ PRESTES A SE ROMPER"

        animate(
            arm,
            0.65,
            {
                CFrame = arm.CFrame *
                    CFrame.Angles(math.rad(-45), 0, 0)
            }
        )

        animate(
            sword,
            0.65,
            {
                CFrame = sword.CFrame *
                    CFrame.Angles(math.rad(-65), 0, 0)
            }
        )

        if waitScene(0.9) then
            -- 3. Golpe.
            caption.Text = ""

            local slash = part(
                model, "DimensionalSlash",
                Vector3.new(0.3, 0.3, 1),
                CFrame.new(
                    origin + Vector3.new(0, 8, -7)
                ) * CFrame.Angles(
                    0, 0, math.rad(-12)
                ),
                CYAN,
                Enum.Material.Neon
            )

            animate(
                slash,
                0.22,
                {Size = Vector3.new(27, 0.3, 1)}
            )

            if waitScene(0.3) then
                -- 4. Ruptura.
                local rift = part(
                    model, "DimensionalRift",
                    Vector3.new(0.2, 0.4, 0.2),
                    CFrame.new(
                        origin + Vector3.new(0, 8, -8)
                    ),
                    PURPLE,
                    Enum.Material.Neon
                )

                animate(
                    rift,
                    0.65,
                    {
                        Size = Vector3.new(27, 12, 0.4),
                        Color = BLUE
                    }
                )

                animate(
                    overlay,
                    0.12,
                    {BackgroundTransparency = 0.45}
                )

                if waitScene(0.2) then
                    animate(
                        overlay,
                        0.35,
                        {BackgroundTransparency = 1}
                    )
                end

                if waitScene(0.75) then
                    -- 5. Três feixes de invocação.
                    caption.Text = "UNIDADES ENCONTRADAS"

                    local colors = {
                        BLUE,
                        Color3.fromRGB(255, 196, 55),
                        PURPLE
                    }

                    for i = 1, 3 do
                        local beam = part(
                            model, "SummonBeam" .. i,
                            Vector3.new(2, 0.2, 2),
                            CFrame.new(
                                origin + Vector3.new(
                                    (i - 2) * 7,
                                    7,
                                    -6
                                )
                            ),
                            colors[i],
                            Enum.Material.Neon
                        )

                        animate(
                            beam,
                            0.65,
                            {
                                Size = Vector3.new(2, 14, 2),
                                Position = beam.Position +
                                    Vector3.new(0, 7, 0)
                            }
                        )
                    end

                    waitScene(1.6)
                end
            end
        end
    end

    -- Restaura a câmera, inclusive ao pular.
    if workspace.CurrentCamera == camera then
        camera.CameraType = previousType
        camera.CameraSubject = previousSubject
        camera.CFrame = previousCFrame
        camera.FieldOfView = previousFov
    end

    if scene == model then
        scene = nil
    end

    model:Destroy()
    overlay.Visible = false
    testButton.Visible = true
    busy = false
end

skip.Activated:Connect(function()
    cancelled = true
end)

testButton.Activated:Connect(function()
    task.spawn(runCinematic)
end)

gui.Destroying:Connect(function()
    cancelled = true
    if scene then
        scene:Destroy()
        scene = nil
    end
end)

print("[Anime Fissure] Summon Cinematic v0.1 carregado")
