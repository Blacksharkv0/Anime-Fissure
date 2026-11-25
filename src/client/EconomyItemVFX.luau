--!strict
-- ANIME FISSURE | EconomyItemVFX v0.2
-- Client-only, reusable VFX controller for a single ViewportFrame preview.
-- No particles/textures/asset IDs required: instanced neon geometry and lights.
-- Continuous effects run only while the preview is visible and get cleaned up.
-- Call Attach(model, id) -> controller:Update(dt), :Burst(), :SetEnabled(bool), :Destroy().

local FX = {}
FX.Version = "0.2.0"

local colors: {[string]: {primary: Color3, secondary: Color3}}={
    FissureGems={primary=Color3.fromRGB(66,207,255),secondary=Color3.fromRGB(190,96,255)},
    Gold={primary=Color3.fromRGB(255,211,106),secondary=Color3.fromRGB(255,151,65)},
    TraitRerollCore={primary=Color3.fromRGB(73,235,255),secondary=Color3.fromRGB(78,132,255)},
    RelicTraitSeal={primary=Color3.fromRGB(209,115,255),secondary=Color3.fromRGB(255,151,91)},
}

local function orb(parent: Instance,name: string, size: number,
    color: Color3, alpha: number): Part
    local p=Instance.new("Part")
    p.Name=name
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.CastShadow=false
    p.Shape=Enum.PartType.Ball
    p.Material=Enum.Material.Neon
    p.Color=color
    p.Transparency=alpha
    p.Size=Vector3.new(size,size,size)
    p.Parent=parent
    return p
end

local function streak(parent: Instance,name: string,color: Color3): Part
    local p=Instance.new("Part")
    p.Name=name
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.CastShadow=false
    p.Material=Enum.Material.Neon
    p.Color=color
    p.Transparency=0.2
    p.Size=Vector3.new(0.07,0.07,0.5)
    p.Parent=parent
    return p
end

local function pathPart(p: Part,a: Vector3,b: Vector3,root: CFrame)
    local d=b-a
    p.Size=Vector3.new(0.07,0.07,math.max(0.06,d.Magnitude))
    p.CFrame=root*CFrame.lookAt((a+b)*0.5,b)
end

function FX.Attach(model: Model,id: string)
    local palette=colors[id]
    assert(palette and model.PrimaryPart,"Invalid EconomyVFX model/id")
    local folder=Instance.new("Folder")
    folder.Name="LocalAuthoredVFX"
    folder.Parent=model

    local glows={}
    local sparkles={}
    local strokes={}
    -- Each token has its own moving glyphs, but the particle count is capped.
    for i=1,if id=="Gold" then 7 else 10 do
        glows[i]=orb(folder,"OrbitEmber"..i,
            if id=="Gold" then 0.08 else 0.12,
            if i%3==0 then palette.secondary else palette.primary,0.14)
    end
    if id=="FissureGems" then
        for i=1,4 do
            strokes[i]=streak(folder,"LightningBranch"..i,palette.primary)
        end
    elseif id=="TraitRerollCore" then
        for i=1,3 do strokes[i]=streak(folder,"RewriterPulse"..i,palette.primary) end
    elseif id=="RelicTraitSeal" then
        for i=1,4 do strokes[i]=streak(folder,"RuneTrail"..i,palette.secondary) end
    else
        for i=1,3 do strokes[i]=streak(folder,"CoinGlint"..i,palette.primary) end
    end
    for i=1,3 do
        sparkles[i]=orb(folder,"Surge"..i,0.14,palette.secondary,1)
    end

    local light=Instance.new("PointLight")
    light.Name="ItemGlow"
    light.Color=palette.primary
    light.Range=8
    light.Brightness=0.70
    light.Shadows=false
    light.Parent=model.PrimaryPart

    local t=0
    local burst=0
    local enabled=true
    local gone=false

    local controller={}
    function controller:SetEnabled(value: boolean)
        enabled=value
        for _,p in ipairs(glows) do p.Transparency=if value then 0.30 else 1 end
        for _,p in ipairs(strokes) do p.Transparency=if value then 0.30 else 1 end
        light.Enabled=value
    end
    function controller:Burst()
        burst=1
    end
    function controller:Update(dt: number)
        if gone or not enabled or not model.Parent then return end
        dt=math.clamp(dt,0,0.065)
        t+=dt
        burst=math.max(0,burst-dt*1.5)
        local root=model:GetPivot()
        local idRate=if id=="TraitRerollCore" then 1.8
            elseif id=="RelicTraitSeal" then -0.65
            elseif id=="FissureGems" then 0.8 else 0.95
        local angleOffset=t*idRate

        for i,p in ipairs(glows) do
            local phi=i/#glows*math.pi*2+angleOffset
            local radius=if id=="FissureGems" then 1.65
                elseif id=="Gold" then 1.42
                elseif id=="TraitRerollCore" then 1.70 else 1.84
            local z=if id=="Gold" then -0.51 else -0.65
            local wave=0.18*math.sin(t*2.5+i)
            p.CFrame=root*CFrame.new(math.cos(phi)*radius,
                math.sin(phi)*radius+wave,z+0.16*math.cos(t+i))
            p.Transparency=math.clamp(0.30+0.24*math.sin(t*3+i),0.10,0.74)
            local sz=(if id=="Gold" then 0.08 else 0.12)*
                (1+0.40*math.sin(t*2+i))
            p.Size=Vector3.new(sz,sz,sz)
        end
        for i,p in ipairs(strokes) do
            local angle=i/#strokes*math.pi*2+t*(id=="Gold" and 0.2 or 1.3)
            local a: Vector3
            local b: Vector3
            if id=="FissureGems" then
                local x=0.18*math.sin(t*9+i)
                a=Vector3.new(x,1.20-(i-1)*0.58,-0.88)
                b=Vector3.new(-x*0.5,-1.20+(i-1)*0.58,-0.88)
            elseif id=="Gold" then
                a=Vector3.new(math.cos(angle)*1.18,math.sin(angle)*1.18,-0.44)
                b=Vector3.new(math.cos(angle+0.18)*1.52,
                    math.sin(angle+0.18)*1.52,-0.44)
            elseif id=="TraitRerollCore" then
                a=Vector3.new(math.cos(angle)*0.42,math.sin(angle)*0.42,-0.91)
                b=Vector3.new(math.cos(angle)*1.23,math.sin(angle)*1.23,-0.91)
            else
                a=Vector3.new(math.cos(angle)*1.12,math.sin(angle)*1.12,-0.80)
                b=Vector3.new(math.cos(angle+0.4)*1.52,
                    math.sin(angle+0.4)*1.52,-0.80)
            end
            pathPart(p,a,b,root)
            p.Transparency=math.clamp(0.22+0.40*math.sin(t*4+i),0.1,0.80)
        end
        for i,p in ipairs(sparkles) do
            if burst>0 then
                local phi=i*2*math.pi/3+t*2
                p.CFrame=root*CFrame.new(math.cos(phi)*(1.7+(1-burst)*0.9),
                    math.sin(phi)*(1.7+(1-burst)*0.9),-0.8)
                p.Transparency=1-burst
                p.Size=Vector3.one*(0.12+0.30*burst)
            else
                p.Transparency=1
            end
        end
        light.Brightness=0.70+0.35*math.sin(t*2.6)+burst*0.90
    end
    function controller:Destroy()
        if gone then return end
        gone=true
        light:Destroy()
        folder:Destroy()
    end
    return controller
end

return FX
