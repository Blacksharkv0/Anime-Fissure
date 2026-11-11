
--!strict
-- ANIME FISSURE | BetaLobby Client v0.1
-- Loading + menu inicial mobile/PC

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local remotes = ReplicatedStorage:WaitForChild(
    "LobbyRemotes"
)

local enterRemote = remotes:WaitForChild(
    "EnterArena"
) :: RemoteEvent

local old = playerGui:FindFirstChild(
    "AnimeFissureLobbyUI"
)
if old then old:Destroy() end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFissureLobbyUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 100
gui.Parent = playerGui

local loading = Instance.new("Frame")
loading.Size = UDim2.fromScale(1, 1)
loading.BackgroundColor3 = Color3.fromRGB(5, 8, 18)
loading.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 80)
title.Position = UDim2.fromScale(0.5, 0.33)
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.BackgroundTransparency = 1
title.Text = "ANIME FISSURE"
title.TextColor3 = Color3.fromRGB(90, 190, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.Parent = loading

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(0.8, 0, 0, 35)
subtitle.Position = UDim2.fromScale(0.5, 0.48)
subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
subtitle.BackgroundTransparency = 1
subtitle.Text = "SINCRONIZANDO FISSURA..."
subtitle.TextColor3 = Color3.fromRGB(180, 205, 255)
subtitle.TextScaled = true
subtitle.Font = Enum.Font.Gotham
subtitle.Parent = loading

local barBack = Instance.new("Frame")
barBack.Size = UDim2.new(0.65, 0, 0, 12)
barBack.Position = UDim2.fromScale(0.5, 0.59)
barBack.AnchorPoint = Vector2.new(0.5, 0.5)
barBack.BackgroundColor3 = Color3.fromRGB(30, 40, 65)
barBack.BorderSizePixel = 0
barBack.Parent = loading

local bar = Instance.new("Frame")
bar.Size = UDim2.fromScale(0, 1)
bar.BackgroundColor3 = Color3.fromRGB(56, 123, 255)
bar.BorderSizePixel = 0
bar.Parent = barBack

local function corner(object: Instance)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = object
end

corner(barBack)
corner(bar)

local menu = Instance.new("Frame")
menu.Size = UDim2.fromOffset(290, 155)
menu.Position = UDim2.new(0.5, 0, 1, -28)
menu.AnchorPoint = Vector2.new(0.5, 1)
menu.BackgroundColor3 = Color3.fromRGB(10, 16, 32)
menu.BackgroundTransparency = 0.1
menu.Visible = false
menu.Parent = gui
corner(menu)

local menuTitle = Instance.new("TextLabel")
menuTitle.Size = UDim2.new(1, -20, 0, 40)
menuTitle.Position = UDim2.fromOffset(10, 10)
menuTitle.BackgroundTransparency = 1
menuTitle.Text = "FISSURE LOBBY"
menuTitle.TextColor3 = Color3.fromRGB(110, 210, 255)
menuTitle.Font = Enum.Font.GothamBold
menuTitle.TextSize = 21
menuTitle.Parent = menu

local play = Instance.new("TextButton")
play.Size = UDim2.new(1, -30, 0, 52)
play.Position = UDim2.fromOffset(15, 65)
play.BackgroundColor3 = Color3.fromRGB(56, 123, 255)
play.TextColor3 = Color3.new(1, 1, 1)
play.Text = "JOGAR - CLASSIC"
play.Font = Enum.Font.GothamBold
play.TextSize = 18
play.Parent = menu
corner(play)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 25)
info.Position = UDim2.fromOffset(10, 125)
info.BackgroundTransparency = 1
info.Text = "BETA 0.2 | LOBBY EXPERIMENTAL"
info.TextColor3 = Color3.fromRGB(140, 165, 200)
info.Font = Enum.Font.Gotham
info.TextSize = 11
info.Parent = menu

local waiting = false

play.Activated:Connect(function()
    if waiting then return end
    waiting = true
    play.Text = "ENTRANDO NA ARENA..."
    enterRemote:FireServer()

    -- Caso a entrada seja recusada, permite tentar
    -- novamente sem deixar o botao travado.
    task.delay(8, function()
        if not player:GetAttribute("InArena") then
            waiting = false
            play.Text = "TENTAR NOVAMENTE"
        end
    end)
end)

local function updateMenu()
    local inArena = player:GetAttribute("InArena") == true
    menu.Visible = not inArena and not loading.Visible

    if inArena then
        gui.Enabled = false
    end
end

player:GetAttributeChangedSignal("InArena"):Connect(
    updateMenu
)

-- Carregamento visual. A barra nao representa
-- o percentual real de assets baixados.
if not game:IsLoaded() then
    game.Loaded:Wait()
end

local tween = TweenService:Create(
    bar,
    TweenInfo.new(2, Enum.EasingStyle.Quad),
    {Size = UDim2.fromScale(1, 1)}
)
tween:Play()
tween.Completed:Wait()

subtitle.Text = "FISSURA ESTABILIZADA"
task.wait(0.4)

loading.Visible = false
updateMenu()

print("[Anime Fissure] Loading concluido")
