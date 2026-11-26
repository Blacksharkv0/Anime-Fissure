--!strict
-- ANIME FISSURE | OverlordCombatAnimator v0.9
-- Client-only R6 animations for six Studio combat towers.
-- Uses RunService.PreSimulation per Roblox Motor6D.Transform scheduler.
-- Does not modify damage, cooldown, positioning, enemy or economy.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")

-- These six towers only appear in Studio until roster/ownership release.
if not RunService:IsStudio() then return end

local player=Players.LocalPlayer
local Shared=ReplicatedStorage:WaitForChild("Shared")
local Motion=require(Shared:WaitForChild("OverlordMotionController"))
local remotes=ReplicatedStorage:WaitForChild("TowerRemotes")
local attackFX=remotes:WaitForChild("AttackFX")::RemoteEvent
local arena=Workspace:WaitForChild("FissureArena")

type AnimationEntry={Model: Model,Controller: any}
local actors: {[number]: AnimationEntry}={}
local folderRef: Instance?=nil
local liveAdded: RBXScriptConnection?=nil
local liveRemoved: RBXScriptConnection?=nil
local liveDestroyed: RBXScriptConnection?=nil

local function clearActors()
    for key,entry in pairs(actors) do
        entry.Controller:Destroy()
        actors[key]=nil
    end
end

local function register(model: Instance)
    if not model:IsA("Model") then return end
    local serial=model:GetAttribute("TowerSerial")
    local id=model:GetAttribute("UnitId")
    if typeof(serial)~="number" or typeof(id)~="string"
        or id:sub(1,4)~="OVL_" then return end
    local existing=actors[serial]
    if existing and existing.Model==model then return end
    if existing then existing.Controller:Destroy() end
    local controller=Motion.Attach(model)
    if controller then actors[serial]={Model=model,Controller=controller} end
end

local function disconnect()
    if liveAdded then liveAdded:Disconnect(); liveAdded=nil end
    if liveRemoved then liveRemoved:Disconnect(); liveRemoved=nil end
    if liveDestroyed then liveDestroyed:Disconnect(); liveDestroyed=nil end
    folderRef=nil
    clearActors()
end

local function hookFolder(folder: Instance)
    if folderRef==folder then return end
    disconnect()
    folderRef=folder
    for _,child in ipairs(folder:GetChildren()) do register(child) end
    liveAdded=folder.ChildAdded:Connect(register)
    liveRemoved=folder.ChildRemoved:Connect(function(child)
        if not child:IsA("Model") then return end
        local serial=child:GetAttribute("TowerSerial")
        if typeof(serial)=="number" and actors[serial]
            and actors[serial].Model==child then
            actors[serial].Controller:Destroy()
            actors[serial]=nil
        end
    end)
    liveDestroyed=folder.Destroying:Connect(disconnect)
end

if arena:FindFirstChild("LiveTowers") then
    hookFolder(arena.LiveTowers)
end
arena.ChildAdded:Connect(function(child)
    if child.Name=="LiveTowers" then hookFolder(child) end
end)

local lastFarTick=0
RunService.PreSimulation:Connect(function(_dt: number)
    if not folderRef then return end
    local camera=Workspace.CurrentCamera
    local now=os.clock()
    for serial,entry in pairs(actors) do
        local model=entry.Model
        if not model.Parent or not model.PrimaryPart then
            entry.Controller:Destroy()
            actors[serial]=nil
            continue
        end
        local distance=if camera then
            (camera.CFrame.Position-model.PrimaryPart.Position).Magnitude else 0
        if distance>165 then
            -- Far characters at 10fps, near characters at display fps.
            if now-lastFarTick>0.10 then entry.Controller:Update() end
        else
            entry.Controller:Update()
        end
    end
    if now-lastFarTick>0.10 then lastFarTick=now end
end)

attackFX.OnClientEvent:Connect(function(data: any)
    if typeof(data)~="table" or data.Kind~="Attack"
        or typeof(data.Serial)~="number"
        or typeof(data.UnitId)~="string"
        or typeof(data.To)~="Vector3" then return end
    local entry=actors[data.Serial]
    if not entry or entry.Model:GetAttribute("UnitId")~=data.UnitId then
        if folderRef then
            for _,child in ipairs(folderRef:GetChildren()) do
                if child:IsA("Model") and child:GetAttribute("TowerSerial")==data.Serial then
                    register(child)
                    break
                end
            end
        end
        entry=actors[data.Serial]
    end
    if not entry or entry.Model:GetAttribute("UnitId")~=data.UnitId then return end
    entry.Controller:Attack(data.Stage, data.To)
end)

print("[Anime Fissure] Overlord combat animation v0.9 | six client-side R6 motion profiles")
