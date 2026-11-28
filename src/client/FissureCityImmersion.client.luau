--!strict
-- Fissure City IMMERSION: local atmosphere and distance-aware cosmetic FX.
-- Never changes server Lighting, arena rules, camera controls or rewards.
local Players=game:GetService("Players")
local Workspace=game:GetService("Workspace")
local Lighting=game:GetService("Lighting")
local UIS=game:GetService("UserInputService")
local TweenService=game:GetService("TweenService")
local player=Players.LocalPlayer
local lobby=Workspace:WaitForChild("FissureLobby",60)
if not lobby then return end
local city=lobby:WaitForChild("FissureCity",60)
if not city then return end
local immersion=city:WaitForChild("Immersion",20)
if not immersion then return end
local tint=Instance.new("ColorCorrectionEffect")
tint.Name="LocalFissureCityGrade"
tint.TintColor=Color3.fromRGB(227,240,255)
tint.Contrast=.075;tint.Brightness=.025;tint.Saturation=.04
tint.Enabled=false;tint.Parent=Lighting
local bloom=Instance.new("BloomEffect")
bloom.Name="LocalFissureCityBloom"
bloom.Intensity=.18;bloom.Size=16;bloom.Threshold=1.8
bloom.Enabled=false;bloom.Parent=Lighting
-- Apply only a local grade; baseline global atmosphere remains untouched.
-- This prevents the Carne Village match from inheriting a dark lobby sky.
local lights: {PointLight}={}
local floats: {{Part: BasePart, Base: CFrame, Tween: Tween?}}={}
for _,obj in ipairs(immersion:GetDescendants()) do
    if not obj:IsA("BasePart") then continue end
    if obj:GetAttribute("CityLocalLight")==true then
        local l=Instance.new("PointLight")
        l.Name="LocalCityLantern";l.Color=Color3.fromRGB(145,219,255)
        l.Range=13;l.Brightness=.42;l.Shadows=false;l.Enabled=false;l.Parent=obj
        table.insert(lights,l)
    elseif obj:GetAttribute("CityFloat")==true then
        table.insert(floats,{Part=obj,Base=obj.CFrame,Tween=nil})
    end
end
local function inCity(): boolean
    local camera=Workspace.CurrentCamera
    return camera~=nil and player:GetAttribute("InArena")~=true
        and (camera.CFrame.Position-Vector3.new(260,8,0)).Magnitude<155
end
local function update()
    local active=inCity()
    local reduced=player:GetAttribute("ReducedVFX")==true
    if player:GetAttribute("ReducedVFX")==nil then reduced=UIS.TouchEnabled end
    local camera=Workspace.CurrentCamera
    tint.Enabled=active
    bloom.Enabled=active and not reduced
    local nearby: {{Light: PointLight, Distance: number}}={}
    for _,l in ipairs(lights) do
        l.Enabled=false
        local part=l.Parent
        if active and camera and part and part:IsA("BasePart") then
            local distance=(part.Position-camera.CFrame.Position).Magnitude
            if distance<48 then table.insert(nearby,{Light=l,Distance=distance}) end
        end
    end
    table.sort(nearby,function(a,b) return a.Distance<b.Distance end)
    local cap=if reduced or UIS.TouchEnabled then 2 else 4
    for i=1,math.min(cap,#nearby) do nearby[i].Light.Enabled=true end
    for i,item in ipairs(floats) do
        local near=active and not reduced and camera~=nil
            and (camera.CFrame.Position-item.Base.Position).Magnitude<65
        if near and not item.Tween and item.Part.Parent then
            local tween=TweenService:Create(item.Part,
                TweenInfo.new(2.4+i*.18,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),
                {CFrame=item.Base+Vector3.new(0,.65+(i%2)*.25,0)})
            item.Tween=tween;tween:Play()
        elseif not near and item.Tween then
            item.Tween:Cancel();item.Tween=nil
            if item.Part.Parent then item.Part.CFrame=item.Base end
        end
    end
end
local arenaConnection=player:GetAttributeChangedSignal("InArena"):Connect(update)
local qualityConnection=player:GetAttributeChangedSignal("ReducedVFX"):Connect(update)
update()
while immersion.Parent and city.Parent and lobby.Parent do
    task.wait(.65)
    if not immersion.Parent or not city.Parent or not lobby.Parent then break end
    update()
end
arenaConnection:Disconnect();qualityConnection:Disconnect()
for _,item in ipairs(floats) do if item.Tween then item.Tween:Cancel() end end
for _,l in ipairs(lights) do l:Destroy() end
tint:Destroy();bloom:Destroy()
