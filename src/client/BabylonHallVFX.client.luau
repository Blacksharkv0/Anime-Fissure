--!strict
-- ANIME FISSURE | Babylon Hall decorative portal shimmer v1.0
-- Client-only, distance-aware, no RunService frame loop, no damage/rewards.
-- Portal circles pulse subtly; full gameplay, lobby NPCs and interactions
-- remain server-authored and unchanged.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local TweenService=game:GetService("TweenService")
local UserInputService=game:GetService("UserInputService")

local player=Players.LocalPlayer
local lobby=Workspace:WaitForChild("FissureLobby",60)
if not lobby or not lobby:IsA("Model") then return end
local hall=lobby:WaitForChild("BabylonHall",60)
if not hall or not hall:IsA("Model") then return end
local portals=hall:WaitForChild("GateOfBabylonPortals",20)
if not portals then return end
-- Limit simultaneous animated surfaces on touch devices.
local maxAnimated=if UserInputService.TouchEnabled then 4 else 9
local count=0
for _,p in ipairs(portals:GetChildren()) do
    if not p:IsA("Model") then continue end
    count+=1
    if count>maxAnimated then continue end
    local portalIndex=count
    local disc=p:FindFirstChild("GoldenRippleCore")
    if not disc or not disc:IsA("BasePart") then continue end
    task.spawn(function()
        local phase=portalIndex*0.14
        task.wait(phase)
        local original=disc.Transparency
        while disc.Parent and hall.Parent do
            local camera=Workspace.CurrentCamera
            local near=player:GetAttribute("InArena")~=true
                and camera~=nil and
                (camera.CFrame.Position-disc.Position).Magnitude<98
            if near then
                local tween=TweenService:Create(disc,
                    TweenInfo.new(1.35+phase,Enum.EasingStyle.Sine,
                        Enum.EasingDirection.InOut),
                    {Transparency=0.56})
                tween:Play()
                tween.Completed:Wait()
                if not disc.Parent then break end
                local retract=TweenService:Create(disc,
                    TweenInfo.new(1.45+phase,Enum.EasingStyle.Sine,
                        Enum.EasingDirection.InOut),
                    {Transparency=0.83})
                retract:Play()
                retract.Completed:Wait()
            else
                disc.Transparency=original
                task.wait(1.0)
            end
        end
    end)
end
print("[Anime Fissure] BABYLON PORTAL FX: "..
    tostring(math.min(count,maxAnimated)).." locally pulsing portals (LOD enabled)")
