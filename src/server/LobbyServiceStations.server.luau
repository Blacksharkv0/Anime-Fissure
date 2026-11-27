--!strict
-- ANIME FISSURE | Lobby service network bootstrap v1.0
-- Server-verifies NPC ProximityPrompt and opens informational UI ONLY.
-- Evolution/Traits/Raids/EventRaid are NOT playable or transactable here.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local Config=require(RS:WaitForChild("Shared"):WaitForChild("LobbyServiceConfig"))
local Builder=require(script.Parent:WaitForChild("LobbyServiceBuilder"))

local lobby=Workspace:WaitForChild("FissureLobby",60)
if not lobby or not lobby:IsA("Model") then return end
if not lobby:WaitForChild("LobbyFloor",15)
    or not lobby:WaitForChild("LobbySpawn",15)
    or not lobby:WaitForChild("ArenaPortal",15) then
    warn("[Anime Fissure] SERVICE STATIONS: main lobby incomplete")
    return
end

local ok,built=pcall(function() return Builder.Build(lobby) end)
if not ok then
    warn("[Anime Fissure] SERVICE STATIONS build failed: "..tostring(built))
    return
end
if not built or not built:IsA("Model") then return end

local remotes=RS:FindFirstChild("LobbyServicesRemotes")
if remotes and not remotes:IsA("Folder") then
    remotes:Destroy()
    remotes=nil
end
if not remotes then
    remotes=Instance.new("Folder")
    remotes.Name="LobbyServicesRemotes"
    remotes.Parent=RS
end
local open=remotes:FindFirstChild("OpenServiceInfo")
if open and not open:IsA("RemoteEvent") then
    open:Destroy();open=nil
end
if not open then
    open=Instance.new("RemoteEvent")
    open.Name="OpenServiceInfo"
    open.Parent=remotes
end

local last: {[number]: number}={}
local count=0
for _,stationModel in ipairs(built:GetChildren()) do
    if not stationModel:IsA("Model") then continue end
    local role=stationModel:GetAttribute("Role")
    if typeof(role)~="string" then continue end
    local info=Config.Get(role)
    if not info then continue end
    local anchor=stationModel:FindFirstChild("InteractionPoint")
    local prompt=if anchor then anchor:FindFirstChild("LobbyServicePrompt") else nil
    if not anchor or not anchor:IsA("BasePart")
        or not prompt or not prompt:IsA("ProximityPrompt") then
        warn("[Anime Fissure] missing prompt for role "..role)
        continue
    end
    local id=role
    prompt.Triggered:Connect(function(player: Player)
        if player.Parent~=Players or player:GetAttribute("InArena")==true then
            return
        end
        local character=player.Character
        local root=if character then character:FindFirstChild("HumanoidRootPart") else nil
        local humanoid=if character then character:FindFirstChildOfClass("Humanoid") else nil
        if not root or not root:IsA("BasePart")
            or not humanoid or humanoid.Health<=0 then return end
        if (root.Position-anchor.Position).Magnitude>14 then return end
        local now=os.clock()
        if now-(last[player.UserId] or -10)<0.45 then return end
        last[player.UserId]=now
        (open :: RemoteEvent):FireClient(player,id)
    end)
    count+=1
end
Players.PlayerRemoving:Connect(function(player)
    last[player.UserId]=nil
end)
print("[Anime Fissure] LOBBY SERVICE NPCS READY: "..tostring(count)
    .." NPC prompts (Whis/Urahara/Jinwoo/Event Hub), no gameplay actions")
