--!strict
-- ANIME FISSURE | Overlord Combat VFX v0.9
-- Efeitos visuais locais: servidor aplica TODO o dano; cliente so desenha.
-- Cada personagem recebe identidade inicial distinta e VFX por attack stage.
-- Sem assets externos e com limite simples de pecas para mobile.

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local fx = ReplicatedStorage:WaitForChild("TowerRemotes"):WaitForChild("AttackFX") :: RemoteEvent
local folder = Instance.new("Folder")
folder.Name = "AnimeFissureLocalCombatFX"
folder.Parent = Workspace.CurrentCamera or Workspace

Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if Workspace.CurrentCamera then folder.Parent = Workspace.CurrentCamera end
end)

local COLORS = {
    OVL_Climb = Color3.fromRGB(135, 219, 255),
    OVL_Brain = Color3.fromRGB(226, 241, 255),
    OVL_Gazef = Color3.fromRGB(255, 195, 95),
    OVL_Shalltear = Color3.fromRGB(250, 67, 105),
    OVL_Albedo = Color3.fromRGB(255, 224, 150),
    OVL_Ainz = Color3.fromRGB(197, 123, 255),
}
local active = 0
local function effectPart(name: string, shape: Enum.PartType?, color: Color3): Part?
    if active >= (if player:GetAttribute("ReducedVFX")==true then 48 else 140) then return nil end
    active += 1
    local part = Instance.new("Part")
    part.Name = name
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Material = Enum.Material.Neon
    part.Color = color
    part.Transparency = 0.12
    if shape then part.Shape = shape end
    part.Parent = folder
    part.Destroying:Connect(function() active = math.max(0, active - 1) end)
    return part
end

local function fade(part: Part?, seconds: number, size: Vector3?)
    if not part then return end
    local props: {[string]: any} = {Transparency = 1}
    if size then props.Size = size end
    TweenService:Create(part, TweenInfo.new(seconds, Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out), props):Play()
    Debris:AddItem(part, seconds + 0.08)
end

local function line(name: string, start: Vector3, finish: Vector3,
    color: Color3, width: number, lifetime: number)
    if (finish - start).Magnitude < 0.1 then return end
    local part = effectPart(name, nil, color)
    if not part then return end
    part.Size = Vector3.new(width, width, (finish - start).Magnitude)
    part.CFrame = CFrame.lookAt((start + finish) * 0.5, finish)
    fade(part, lifetime, Vector3.new(0.04, 0.04, part.Size.Z))
end

local function spark(name: string, at: Vector3,
    color: Color3, size: number, lifetime: number)
    local part = effectPart(name, Enum.PartType.Ball, color)
    if not part then return end
    part.Size = Vector3.new(size, size, size)
    part.CFrame = CFrame.new(at)
    fade(part, lifetime, Vector3.new(size * 2.1, size * 2.1, size * 2.1))
end

local function ring(name: string, at: Vector3, radius: number,
    color: Color3, count: number, lifetime: number, vertical: boolean?)
    count = math.min(count,if player:GetAttribute("ReducedVFX")==true then 4 else 12)
    for i = 1, count do
        local a = (i - 1) * math.pi * 2 / count
        local b = i * math.pi * 2 / count
        local function pos(theta: number): Vector3
            if vertical then
                return at + Vector3.new(math.cos(theta) * radius,
                    math.sin(theta) * radius, 0)
            end
            return at + Vector3.new(math.cos(theta) * radius,
                0, math.sin(theta) * radius)
        end
        line(name, pos(a), pos(b), color, 0.11, lifetime)
    end
end

local function bolt(from: Vector3, to: Vector3, color: Color3, lifetime: number)
    local projectile = effectPart("MagicProjectile", Enum.PartType.Ball, color)
    if not projectile then return end
    projectile.Size = Vector3.new(0.62, 0.62, 0.62)
    projectile.Position = from
    TweenService:Create(projectile, TweenInfo.new(lifetime * 0.75,
        Enum.EasingStyle.Linear), {Position = to}):Play()
    fade(projectile, lifetime)
end

local function normalizeStage(stage: any): number
    if typeof(stage) ~= "number" then return 0 end
    return math.clamp(math.floor(stage), 0, 3)
end

local function playUnit(id: string, from: Vector3, to: Vector3,
    stage: number, critical: boolean)
    local c = COLORS[id]
    if not c then return end
    local offset = Vector3.new(0, 2, 0)
    local count = if stage >= 3 then 5 elseif stage >= 2 then 3
        elseif stage >= 1 then 2 else 1
    if player:GetAttribute("ReducedVFX")==true then count=math.min(count,2) end
    if id == "OVL_Climb" then
        line("Climb_BladeArc", from, to, c, 0.23, 0.19)
        spark("Climb_Hit", to, c, 0.64, 0.21)
        if stage > 0 then
            line("Climb_VerticalStrike", to - offset, to + offset,
                Color3.fromRGB(255, 219, 136), 0.20, 0.24)
        end
    elseif id == "OVL_Brain" then
        -- cortes finos de precisao, quantidade cresce com upgrade
        for i = 1, count do
            local x = (i - (count + 1) / 2) * 0.43
            line("Brain_GodFlash", from + Vector3.new(x, 0, 0),
                to + Vector3.new(-x, x * 0.8, 0), c, 0.10, 0.17)
        end
        spark("Brain_CriticalPoint", to, critical and Color3.fromRGB(255, 203, 101)
            or c, 0.38, 0.19)
    elseif id == "OVL_Gazef" then
        for i = 1, count do
            local side = (i - (count + 1) / 2) * 0.64
            line("Gazef_FourfoldCrescent", from,
                to + Vector3.new(side, side * 0.25, 0), c, 0.23, 0.28)
        end
        spark("Gazef_RazorEdgeImpact", to, c, 0.8, 0.30)
    elseif id == "OVL_Shalltear" then
        bolt(from, to, c, 0.33)
        line("Shalltear_SpuitLance", from, to, c, 0.16, 0.26)
        ring("Shalltear_BloodRing", to, 0.80 + stage * 0.24,
            c, if stage >= 2 then 10 else 7, 0.28, true)
    elseif id == "OVL_Albedo" then
        bolt(from, to, c, 0.28)
        line("Albedo_GuardianBlade", from, to, c, 0.23, 0.23)
        spark("Albedo_FeatherFlash", to, c, 0.64, 0.23)
        if stage > 0 then
            ring("Albedo_GuardHalo", from, 1.3, c, 9, 0.33, false)
        end
    elseif id == "OVL_Ainz" then
        bolt(from, to, c, 0.35)
        line("Ainz_RealitySlash", to + Vector3.new(-1.3, 1.8, 0.4),
            to + Vector3.new(1.3, -1.1, -0.4), c, 0.28, 0.35)
        ring("Ainz_SpatialGlyph", to, 1.2 + 0.29 * stage, c,
            7 + stage, 0.45, true)
        if stage >= 2 then
            spark("Ainz_GraspHeart", to, Color3.fromRGB(255, 78, 123),
                0.62, 0.36)
        end
    end
    -- Keep essential attacks visible but omit extra flourishes in low-FX.
    if player:GetAttribute("ReducedVFX")==true then return end
    -- Three upgrade-specific visual transformations (Lv 3 / 6 / 9).
    -- Stage flourishes are spatial only; they never change damage or stun.
    if stage >= 1 then
        if id == "OVL_Brain" then
            line("GodFlashFlash", to + Vector3.new(-0.83, 0.2, 0),
                to + Vector3.new(0.83, -0.2, 0), c, 0.10, 0.18)
        elseif id == "OVL_Gazef" then
            ring("FourfoldSignature", to, 1.0, c, 8, 0.27, true)
        elseif id == "OVL_Shalltear" then
            spark("SpuitLanceVampiricPulse", to, c, 0.44, 0.28)
        elseif id == "OVL_Albedo" then
            ring("GuardianFirstWing", from, 0.86, c, 8, 0.24, true)
        elseif id == "OVL_Ainz" then
            ring("RealitySlashSeal", from, 1.28, c, 9, 0.31, true)
        end
    end
    if stage >= 2 then
        if id == "OVL_Climb" then
            ring("ClimbFortressAura", from, 1.17, c, 8, 0.28)
        elseif id == "OVL_Brain" then
            for i = 1, 4 do
                local x = (i - 2.5) * 0.38
                line("NailClipperCross", to + Vector3.new(x, 0.8, 0),
                    to + Vector3.new(-x, -0.8, 0), c, 0.10, 0.21)
            end
        elseif id == "OVL_Gazef" then
            line("RazorEdgePierce", from, to, Color3.fromRGB(169, 236, 255),
                0.16, 0.25)
        elseif id == "OVL_Shalltear" then
            ring("BloodFrenzyFlash", from, 1.24, c, 10, 0.27)
        elseif id == "OVL_Albedo" then
            ring("HermesGuardianWall", from, 1.56, c, 10, 0.36, true)
        elseif id == "OVL_Ainz" then
            spark("GraspHeartFlash", to,
                Color3.fromRGB(255, 72, 137), 0.90, 0.40)
        end
    end
    if stage >= 3 then
        if id == "OVL_Ainz" then
            ring("SuperTierSeal", to, 2.25, Color3.fromRGB(204, 231, 255),
                12, 0.46)
            spark("SuperTierBurst", to, c, 1.1, 0.43)
        elseif id == "OVL_Shalltear" then
            ring("EinherjarEcho", to, 1.6,
                Color3.fromRGB(249, 237, 247), 9, 0.35, true)
        elseif id == "OVL_Albedo" then
            ring("OverseerCommand", from, 1.94,
                Color3.fromRGB(255, 235, 164), 12, 0.45)
        elseif id == "OVL_Brain" then
            ring("TrueNailClipperSeal", to, 1.29, c, 8, 0.26, true)
        elseif id == "OVL_Gazef" then
            ring("SixfoldRadiance", to, 1.70, c, 12, 0.35)
        elseif id == "OVL_Climb" then
            spark("LimitBreakerPulse", from, Color3.fromRGB(255, 215, 133),
                1.1, 0.29)
        end
    end
    if critical then
        spark("Critical", to, Color3.fromRGB(255, 218, 113), 0.33, 0.22)
    end
end

fx.OnClientEvent:Connect(function(data: any)
    if typeof(data) ~= "table" then return end
    if data.Kind == "Guard" then
        if typeof(data.To) == "Vector3" then
            ring("Albedo_HermesGuard", data.To, 2.0,
                Color3.fromRGB(255, 218, 133), 12, 0.5, true)
            spark("Albedo_LeakBlocked", data.To,
                Color3.fromRGB(255, 232, 184), 0.85, 0.38)
        end
        return
    end
    if data.Kind ~= "Attack" or typeof(data.UnitId) ~= "string"
        or typeof(data.From) ~= "Vector3" or typeof(data.To) ~= "Vector3" then
        return
    end
    if player:GetAttribute("InArena") ~= true then return end
    if (data.From - data.To).Magnitude > 150 then return end
    -- Contact FX follows the R6 windup; model pose starts immediately in
    -- OverlordCombatAnimator and the server still owns the real hit.
    task.delay(0.095, function()
        if player:GetAttribute("InArena") ~= true then return end
        local start = data.From
        if typeof(data.Serial) == "number" then
            local arena = Workspace:FindFirstChild("FissureArena")
            local live = if arena then arena:FindFirstChild("LiveTowers") else nil
            if live then
                for _, tower in ipairs(live:GetChildren()) do
                    if tower:IsA("Model")
                        and tower:GetAttribute("TowerSerial") == data.Serial
                        and tower:GetAttribute("UnitId") == data.UnitId then
                        local point = tower:FindFirstChild("WeaponFocus", true)
                        if point and point:IsA("Attachment") then
                            start = point.WorldPosition
                        end
                        break
                    end
                end
            end
        end
        playUnit(data.UnitId, start, data.To,
            normalizeStage(data.Stage), data.Critical == true)
    end)
end)

print("[Anime Fissure] Overlord VFX v0.9 - seis efeitos sincronizados com animaçao R6")
