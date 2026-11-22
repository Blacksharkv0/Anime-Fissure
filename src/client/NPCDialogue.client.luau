--!strict
-- ANIME FISSURE | NPCDialogue v0.5
-- Camada de conversa para Virgil e Edward.
-- O cliente APENAS apresenta o dialogo: a escolha e validada no servidor.
-- Nao concede Tickets, nao invoca unidades e nao fabrica itens.

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local folder = ReplicatedStorage:WaitForChild("NPCDialogueRemotes")
local openRemote = folder:WaitForChild("OpenDialogue") :: RemoteEvent
local chooseRemote = folder:WaitForChild("ChooseDialogue") :: RemoteEvent

local C = {
    Backdrop = Color3.fromRGB(3, 6, 16),
    Panel = Color3.fromRGB(13, 20, 39),
    Inner = Color3.fromRGB(22, 34, 60),
    White = Color3.fromRGB(244, 248, 255),
    Muted = Color3.fromRGB(166, 185, 220),
    Cyan = Color3.fromRGB(83, 222, 252),
    Purple = Color3.fromRGB(159, 91, 247),
    Gold = Color3.fromRGB(248, 192, 102),
}

local LINES = {
    Virgil = {
        Title = "VIRGIL",
        Role = "MESTRE DAS INVOCAÇÕES",
        Symbol = "V",
        Accent = C.Purple,
        Intro = "Heh... mais um corajoso querendo desafiar o destino?",
        Detail = "Cada invocação pode mudar a sua jornada. Mas não espere que a sorte faça todo o trabalho.",
        Action = "ABRIR SUMMON",
        Footnote = "As invocações e os Tickets são controlados pelo servidor.",
    },
    Edward = {
        Title = "EDWARD",
        Role = "ALQUIMISTA DO LOBBY",
        Symbol = "E",
        Accent = C.Gold,
        Intro = "A alquimia não é um truque de mágica, entendeu?",
        Detail = "Estude as relíquias, descubra seus efeitos e prepare-se. Uma transmutação exige mais que vontade.",
        Action = "EXPLORAR OFICINA",
        Footnote = "Nesta beta, o Index funciona; transmutação ainda está bloqueada.",
    },
}

local old = playerGui:FindFirstChild("AnimeFissureNPCDialogue")
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFissureNPCDialogue"
gui.ResetOnSpawn = false
gui.DisplayOrder = 210
gui.IgnoreGuiInset = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = false
gui.Parent = playerGui

local function rounded(target: Instance, pixels: number)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, pixels)
    corner.Parent = target
end

local function bordered(target: Instance, color: Color3, thickness: number)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color
    stroke.Thickness = thickness
    stroke.Transparency = 0.16
    stroke.Parent = target
    return stroke
end

local function label(parent: Instance, name: string, value: string, pos: UDim2, size: UDim2, textSize: number, color: Color3, bold: boolean): TextLabel
    local object = Instance.new("TextLabel")
    object.Name = name
    object.Position = pos
    object.Size = size
    object.BackgroundTransparency = 1
    object.Font = if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    object.Text = value
    object.TextColor3 = color
    object.TextSize = textSize
    object.TextWrapped = true
    object.TextXAlignment = Enum.TextXAlignment.Left
    object.TextYAlignment = Enum.TextYAlignment.Center
    object.Parent = parent
    return object
end

local veil = Instance.new("Frame")
veil.Name = "Backdrop"
veil.Size = UDim2.fromScale(1, 1)
veil.BackgroundColor3 = C.Backdrop
veil.BackgroundTransparency = 0.20
veil.BorderSizePixel = 0
veil.Active = true
veil.Parent = gui

local root = Instance.new("Frame")
root.Name = "DialogueWindow"
root.Size = UDim2.fromOffset(640, 366)
root.AnchorPoint = Vector2.new(0.5, 0.5)
root.Position = UDim2.fromScale(0.5, 0.5)
root.BackgroundColor3 = C.Panel
root.BorderSizePixel = 0
root.Parent = veil
rounded(root, 15)
local rootStroke = bordered(root, C.Purple, 2)

local scaler = Instance.new("UIScale")
scaler.Parent = root

local accentStrip = Instance.new("Frame")
accentStrip.Name = "AccentStrip"
accentStrip.Size = UDim2.new(1, -28, 0, 4)
accentStrip.Position = UDim2.fromOffset(14, 12)
accentStrip.BackgroundColor3 = C.Purple
accentStrip.BorderSizePixel = 0
accentStrip.Parent = root
rounded(accentStrip, 4)

local portrait = Instance.new("Frame")
portrait.Name = "Portrait"
portrait.Position = UDim2.fromOffset(23, 36)
portrait.Size = UDim2.fromOffset(116, 125)
portrait.BackgroundColor3 = C.Inner
portrait.BorderSizePixel = 0
portrait.Parent = root
rounded(portrait, 12)
local portraitStroke = bordered(portrait, C.Purple, 2)
local avatarSymbol = label(portrait, "AvatarSymbol", "V", UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 70, C.Purple, true)
avatarSymbol.TextXAlignment = Enum.TextXAlignment.Center

local title = label(root, "CharacterName", "VIRGIL", UDim2.fromOffset(157, 38), UDim2.fromOffset(403, 42), 29, C.White, true)
local role = label(root, "CharacterRole", "MESTRE DAS INVOCAÇÕES", UDim2.fromOffset(158, 77), UDim2.fromOffset(410, 25), 13, C.Cyan, true)
local intro = label(root, "DialogueIntro", "", UDim2.fromOffset(160, 112), UDim2.fromOffset(451, 55), 17, C.White, true)

local divider = Instance.new("Frame")
divider.Position = UDim2.fromOffset(24, 178)
divider.Size = UDim2.fromOffset(592, 1)
divider.BackgroundColor3 = Color3.fromRGB(62, 83, 122)
divider.BorderSizePixel = 0
divider.Parent = root

local detail = label(root, "DialogueDetail", "", UDim2.fromOffset(28, 192), UDim2.fromOffset(580, 57), 16, C.Muted, false)
detail.TextYAlignment = Enum.TextYAlignment.Top

local action = Instance.new("TextButton")
action.Name = "Continue"
action.Position = UDim2.fromOffset(27, 268)
action.Size = UDim2.fromOffset(385, 53)
action.BackgroundColor3 = C.Purple
action.BorderSizePixel = 0
action.Text = "ABRIR SUMMON"
action.Font = Enum.Font.GothamBold
action.TextSize = 19
action.TextColor3 = C.White
action.AutoButtonColor = true
action.Parent = root
rounded(action, 9)

local cancel = Instance.new("TextButton")
cancel.Name = "Cancel"
cancel.Position = UDim2.fromOffset(427, 268)
cancel.Size = UDim2.fromOffset(185, 53)
cancel.BackgroundColor3 = C.Inner
cancel.BorderSizePixel = 0
cancel.Text = "AGORA NÃO"
cancel.Font = Enum.Font.GothamBold
cancel.TextSize = 15
cancel.TextColor3 = C.White
cancel.Parent = root
rounded(cancel, 9)
bordered(cancel, C.Cyan, 1)

local footnote = label(root, "Footnote", "", UDim2.fromOffset(28, 329), UDim2.fromOffset(585, 24), 12, C.Muted, false)
footnote.TextXAlignment = Enum.TextXAlignment.Center

local closeButton = Instance.new("TextButton")
closeButton.Name = "Close"
closeButton.Size = UDim2.fromOffset(34, 32)
closeButton.Position = UDim2.fromOffset(587, 34)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = C.Muted
closeButton.Parent = root

local currentKind: string? = nil
local openingGeneration = 0

local function refreshScale()
    local camera = Workspace.CurrentCamera
    if not camera then return end
    local v = camera.ViewportSize
    -- Margens protegem as barras do Roblox e os controles de toque.
    scaler.Scale = math.clamp(math.min((v.X - 32) / 660, (v.Y - 100) / 388), 0.52, 1)
end

local function bindCamera()
    local camera = Workspace.CurrentCamera
    if camera then
        camera:GetPropertyChangedSignal("ViewportSize"):Connect(refreshScale)
    end
    refreshScale()
end
Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera)
bindCamera()

local function closeDialogue()
    currentKind = nil
    openingGeneration += 1
    gui.Enabled = false
end

cancel.Activated:Connect(closeDialogue)
closeButton.Activated:Connect(closeDialogue)

UserInputService.InputBegan:Connect(function(input: InputObject, processed: boolean)
    if processed or not gui.Enabled then return end
    if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.ButtonB then
        closeDialogue()
    end
end)

player:GetAttributeChangedSignal("InArena"):Connect(function()
    if player:GetAttribute("InArena") == true then closeDialogue() end
end)

action.Activated:Connect(function()
    local kind = currentKind
    if not kind or not LINES[kind] then return end
    closeDialogue()
    chooseRemote:FireServer(kind)
end)

openRemote.OnClientEvent:Connect(function(kind: any)
    if typeof(kind) ~= "string" or player:GetAttribute("InArena") == true then return end
    local data = LINES[kind]
    if not data then return end

    currentKind = kind
    openingGeneration += 1
    local generation = openingGeneration

    title.Text = data.Title
    role.Text = data.Role
    avatarSymbol.Text = data.Symbol
    avatarSymbol.TextColor3 = data.Accent
    portraitStroke.Color = data.Accent
    rootStroke.Color = data.Accent
    accentStrip.BackgroundColor3 = data.Accent
    intro.Text = data.Intro
    detail.Text = data.Detail
    action.Text = data.Action
    action.BackgroundColor3 = data.Accent
    footnote.Text = data.Footnote
    gui.Enabled = true
    refreshScale()

    root.BackgroundTransparency = 0.12
    TweenService:Create(root, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
    }):Play()

    -- Pequeno brilho em vez de animacao de texto que se torna lenta no celular.
    task.delay(0.25, function()
        if openingGeneration ~= generation or not gui.Enabled then return end
        TweenService:Create(accentStrip, TweenInfo.new(0.18), {
            BackgroundTransparency = 0.15,
        }):Play()
    end)
end)

print("[Anime Fissure] NPCDialogue v0.5 carregado | PC, controle e toque")
