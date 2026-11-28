--!strict
-- CONGRUENCE: only nearby world labels, ranked from the avatar (not zoom).
-- Architectural SurfaceGui signs and the chosen navigator waypoint remain.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local player=Players.LocalPlayer
local lobby=Workspace:WaitForChild("FissureLobby",60)
if not lobby then return end
local signs: {[BillboardGui]: boolean}={}
local oldNames={PortalSign=true,VirgilLabel=true,WorkshopSign=true}
local function add(obj: Instance)
    if not obj:IsA("BillboardGui") then return end
    if oldNames[obj.Name] then obj.Enabled=false;return end
    if obj:GetAttribute("CityLocalSign")==true then
        signs[obj]=true
        obj.AlwaysOnTop=false
        obj.Enabled=false
    end
end
local conn=lobby.DescendantAdded:Connect(add)
for _,obj in ipairs(lobby:GetDescendants()) do add(obj) end
local function position(board: BillboardGui): Vector3?
    local adornee=board.Adornee or board.Parent
    if adornee and adornee:IsA("BasePart") then return adornee.Position+board.StudsOffsetWorldSpace end
    if adornee and adornee:IsA("Attachment") then return adornee.WorldPosition end
    return nil
end
local function update()
    local char=player.Character
    local root=if char then char:FindFirstChild("HumanoidRootPart") else nil
    local camera=Workspace.CurrentCamera
    local active=player:GetAttribute("InArena")~=true and player:GetAttribute("FissureLoading")~=true
    local candidates: {{Board: BillboardGui, Distance: number}}={}
    for board in pairs(signs) do
        if not board:IsDescendantOf(lobby) then signs[board]=nil;continue end
        if active and root and root:IsA("BasePart") and camera then
            local pos=position(board)
            if pos then
                local distance=(Vector3.new(pos.X,root.Position.Y,pos.Z)-root.Position).Magnitude
                local _,onScreen=camera:WorldToViewportPoint(pos)
                if onScreen and distance <= (if board.Enabled then 19 else 17) then
                    table.insert(candidates,{Board=board,Distance=distance-(if board.Enabled then 1.2 else 0)})
                end
            end
        end
    end
    table.sort(candidates,function(a,b) return a.Distance<b.Distance end)
    local shown: {[BillboardGui]: boolean}={}
    -- Only ONE automatic floating label. Full title is always available
    -- via the NPC prompt and the directory.
    if candidates[1] then shown[candidates[1].Board]=true end
    for board in pairs(signs) do board.Enabled=shown[board]==true end
end
while lobby.Parent do
    update()
    task.wait(.18)
end
conn:Disconnect()
