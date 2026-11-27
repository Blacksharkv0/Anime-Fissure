--!strict
-- ANIME FISSURE | Lobby mentor finishing FX v1.0
-- Local-only and low-cost. Art objects glow while the local player's
-- camera is near the active lobby; no gameplay stats, server effects,
-- particles spam, fake progression or raid activation.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Workspace=game:GetService("Workspace")
local TweenService=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer

local lobby=Workspace:WaitForChild("FissureLobby",70)
if not lobby or not lobby:IsA("Model") then return end
local stations=lobby:WaitForChild("LobbyServiceStations",70)
if not stations or not stations:IsA("Model") then return end
local start=os.clock()
while stations:GetAttribute("Ready")~=true and os.clock()-start<15 do
    task.wait(.2)
end
if stations:GetAttribute("Ready")~=true then
    warn("[Anime Fissure] LOBBY FX: mentor scene did not complete")
    return
end

local low=UIS.TouchEnabled
local maxDistance=if low then 51 else 76
local maxStationLights=if low then 3 else 6
local lights=0
local function pulse(base: BasePart,tint: Color3)
    if lights>=maxStationLights then return end
    lights+=1
    local baseline=base.Transparency
    local glow=Instance.new("PointLight")
    glow.Name="ClientOnlyMentorGlow"
    glow.Color=tint
    glow.Range=if low then 8 else 12
    glow.Brightness=0
    glow.Shadows=false
    glow.Parent=base

    local active=true
    base.Destroying:Connect(function() active=false end)
    task.spawn(function()
        while active and base.Parent and stations.Parent do
            local camera=Workspace.CurrentCamera
            local inLobby=player:GetAttribute("InArena")~=true
            local near=inLobby and camera~=nil
                and (camera.CFrame.Position-base.Position).Magnitude<maxDistance
            if near then
                local duration=1.5
                local up=TweenService:Create(base,
                    TweenInfo.new(duration,Enum.EasingStyle.Sine,
                        Enum.EasingDirection.InOut),
                    {Transparency=math.clamp(baseline+.30,0,0.72)})
                local lightUp=TweenService:Create(glow,
                    TweenInfo.new(duration),{Brightness=if low then .22 else .48})
                up:Play();lightUp:Play();up.Completed:Wait()
                if not active then break end
                local down=TweenService:Create(base,
                    TweenInfo.new(duration,Enum.EasingStyle.Sine,
                        Enum.EasingDirection.InOut),{Transparency=baseline})
                local lightDown=TweenService:Create(glow,
                    TweenInfo.new(duration),{Brightness=0})
                down:Play();lightDown:Play();down.Completed:Wait()
            else
                base.Transparency=baseline
                glow.Brightness=0
                task.wait(1.3)
            end
        end
        if base.Parent then base.Transparency=baseline end
        glow:Destroy()
    end)
end

-- One gem per station, so VFX stay cheap even on crowded servers.
for _,role in ipairs({"Evolution","Traits","Raids","Index"}) do
    local stand=stations:FindFirstChild(role.."Station")
    if not stand then continue end
    local selected: BasePart?=nil
    for _,child in ipairs(stand:GetChildren()) do
        if child.Name=="StationGem" and child:IsA("BasePart") then
            selected=child;break
        end
    end
    if selected then
        local shared=ReplicatedStorage:FindFirstChild("Shared")
        local configModule=if shared then shared:FindFirstChild("LobbyServiceConfig") else nil
        if configModule and configModule:IsA("ModuleScript") then
            local cfg=require(configModule)
            local info=cfg.GetStation(role)
            if info then pulse(selected,info.Accent) end
        end
    end
end
-- One seasonal pulse makes the empty podium feel designed, not broken.
local event=stations:FindFirstChild("SeasonalEventHub")
if event then
    local hologram=event:FindFirstChild("UnassignedEventHologram")
    if hologram and hologram:IsA("BasePart") then
        pulse(hologram,Color3.fromRGB(84,164,247))
    end
end

print("[Anime Fissure] LOBBY MENTOR FX: "..
    tostring(lights).." proximity-LOD decorative glows; touch optimization "..
    (if low then "ON" else "OFF"))
