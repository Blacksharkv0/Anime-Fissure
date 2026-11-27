--!strict
-- ANIME FISSURE | Ring equipped markers (Studio only).
-- Client-only overhead glow, no particles in the server and no combat math.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local Workspace=game:GetService("Workspace")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Rings=require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("RelicRingConfig"))

local arena=Workspace:WaitForChild("FissureArena")
local connections: {[Model]: {RBXScriptConnection}}={}

local function equipView(model: Model)
    if connections[model] then return end
    if not model.PrimaryPart or not model:GetAttribute("TowerSerial") then return end
    local root=model.PrimaryPart
    local billboard=Instance.new("BillboardGui")
    billboard.Name="ClientRelicHalo"
    billboard.Adornee=root
    billboard.Size=UDim2.fromOffset(50,50)
    billboard.StudsOffsetWorldSpace=Vector3.new(0,5.5,0)
    billboard.AlwaysOnTop=true
    billboard.MaxDistance=105
    billboard.Enabled=false
    billboard.Parent=root

    local background=Instance.new("Frame")
    background.Name="GemBackdrop"
    background.AnchorPoint=Vector2.new(0.5,0.5)
    background.Position=UDim2.fromScale(0.5,0.5)
    background.Size=UDim2.fromOffset(34,34)
    background.BackgroundColor3=Color3.fromRGB(24,21,35)
    background.BackgroundTransparency=0.12
    background.Rotation=45
    background.BorderSizePixel=0
    background.Parent=billboard
    local bgCorner=Instance.new("UICorner")
    bgCorner.CornerRadius=UDim.new(0,8)
    bgCorner.Parent=background
    local border=Instance.new("UIStroke")
    border.Name="RelicRim"
    border.Color=Color3.fromRGB(212,193,244)
    border.Thickness=2.5
    border.Parent=background

    local symbol=Instance.new("TextLabel")
    symbol.Name="RelicSymbol"
    symbol.Size=UDim2.fromScale(1,1)
    symbol.Text="✦"
    symbol.BackgroundTransparency=1
    symbol.TextScaled=true
    symbol.Font=Enum.Font.GothamBold
    symbol.TextColor3=Color3.fromRGB(232,168,255)
    symbol.Parent=billboard

    local function sync()
        local id=model:GetAttribute("EquippedRelicId")
        local ring=if typeof(id)=="string" then Rings.Get(id) else nil
        billboard.Enabled=ring~=nil
        if ring then
            symbol.Text=ring.Glyph
            symbol.TextColor3=ring.GemColor
            border.Color=ring.MainColor
        end
    end
    local changes=model:GetAttributeChangedSignal("EquippedRelicId"):Connect(sync)
    local destroyed=model.Destroying:Connect(function()
        for _,con in ipairs(connections[model] or {}) do con:Disconnect() end
        connections[model]=nil
        billboard:Destroy()
    end)
    connections[model]={changes,destroyed}
    sync()
end

local observed: Folder?=nil
local added: RBXScriptConnection?=nil
local function hook(folder: Instance)
    if not folder:IsA("Folder") then return end
    if added then added:Disconnect();added=nil end
    observed=folder
    for _,child in ipairs(folder:GetChildren()) do
        if child:IsA("Model") then equipView(child) end
    end
    added=folder.ChildAdded:Connect(function(child)
        if child:IsA("Model") then equipView(child) end
    end)
end
local current=arena:FindFirstChild("LiveTowers")
if current then hook(current) end
arena.ChildAdded:Connect(function(child)
    if child.Name=="LiveTowers" then hook(child) end
end)

print("[Anime Fissure] RELIC RING HALOS: local visual markers enabled in Studio")
