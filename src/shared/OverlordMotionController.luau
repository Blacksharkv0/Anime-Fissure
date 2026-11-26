--!strict
-- ANIME FISSURE | OverlordMotionController v0.9
-- Client-side PROCEDURAL R6 motion, using Motor6D.Transform in PreSimulation.
-- Animation is purely visual: actual damage and cooldowns stay on server.
-- No uploaded animation IDs, no AnimationTrack requirements.
-- The caller MUST call controller:Update() from RunService.PreSimulation.
-- Works for live arena R6 towers and Studio ViewportFrame preview clones.

local Motion={}
Motion.Version="0.9.0"

local DURATIONS: {[string]: number}={
    OVL_Climb=0.41, OVL_Brain=0.27, OVL_Gazef=0.46,
    OVL_Shalltear=0.43, OVL_Albedo=0.52, OVL_Ainz=0.63,
}

local function rad(deg: number): number
    return math.rad(deg)
end

local function clampStage(value: any): number
    if typeof(value)~="number" then return 0 end
    return math.clamp(math.floor(value),0,3)
end

local function lookYaw(model: Model, point: Vector3?): number
    if not point or not model.PrimaryPart then return 0 end
    local relative=model.PrimaryPart.CFrame:PointToObjectSpace(point)
    local d=Vector2.new(relative.X,relative.Z)
    if d.Magnitude<0.01 then return 0 end
    -- R6 front is -Z; clamp so figures keep readable attack silhouettes.
    return math.clamp(math.atan2(-relative.X,-relative.Z),-0.95,0.95)
end

local function easing(u: number): number
    return 1-(1-u)^3
end

-- Windup -> contact -> recovery.
local function attackCurve(progress: number): (number,number)
    if progress<0 or progress>=1 then return 0,0 end
    local windup=if progress<0.32 then easing(progress/0.32)
        else math.max(0,1-(progress-0.32)/0.68)
    local strike=if progress<0.32 then 0
        elseif progress<0.57 then math.sin(((progress-0.32)/0.25)*math.pi)
        else math.max(0,1-(progress-0.57)/0.43)
    return math.clamp(windup,0,1),math.clamp(strike,0,1)
end

local function animateJoints(id: string, stage: number, t: number,
    windup: number, strike: number, yaw: number): {[string]: CFrame}
    local idle=math.sin(t*1.7)
    local breath=idle*0.018
    local s=1+stage*0.19
    local right=CFrame.identity
    local left=CFrame.identity
    local root=CFrame.new(0,breath,0)*CFrame.Angles(0,yaw,0)
    local neck=CFrame.Angles(rad(1.2*idle),0,0)
    local hipL=CFrame.identity
    local hipR=CFrame.identity

    if id=="OVL_Climb" then
        root*=CFrame.Angles(rad(7*strike*s),rad(-11*windup),rad(-6*strike))
        right=CFrame.Angles(rad(-12-57*windup*s+100*strike*s),0,
            rad(-7-12*strike))
        left=CFrame.Angles(rad(15+21*windup),0,rad(-9))
        hipL=CFrame.Angles(rad(-5*strike),0,0)
        hipR=CFrame.Angles(rad(7*strike),0,0)
        neck=CFrame.Angles(rad(-5*windup+8*strike),0,0)
    elseif id=="OVL_Brain" then
        root*=CFrame.Angles(rad(14*windup-13*strike),
            rad(-27*windup+35*strike),rad(-8*strike))
        right=CFrame.Angles(rad(-10-82*windup+104*strike*s),0,
            rad(-19+11*strike))
        left=CFrame.Angles(rad(18+15*windup),0,rad(29*strike))
        hipL=CFrame.Angles(rad(-17*windup+15*strike),0,0)
        neck=CFrame.Angles(rad(-9*windup+11*strike),0,0)
    elseif id=="OVL_Gazef" then
        root*=CFrame.Angles(rad(5*windup+10*strike),
            rad(20*windup-38*strike),rad(7*windup-9*strike))
        right=CFrame.Angles(rad(-8-66*windup+83*strike*s),0,
            rad(-18-18*strike))
        left=CFrame.Angles(rad(12+19*strike),0,rad(-16*windup))
        hipR=CFrame.Angles(rad(-11*strike),0,0)
        neck=CFrame.Angles(rad(5*windup-7*strike),0,0)
    elseif id=="OVL_Shalltear" then
        root*=CFrame.Angles(rad(-7*windup+19*strike),
            rad(-8*windup+10*strike),rad(-5*strike))
        -- Forward thrust with the Spuit Lance, not a sword chop.
        right=CFrame.Angles(rad(-25-43*windup+58*strike*s),0,
            rad(-17+12*strike))
        left=CFrame.Angles(rad(6+32*windup-10*strike),0,
            rad(-15*windup))
        hipL=CFrame.Angles(rad(5*strike),0,0)
        neck=CFrame.Angles(rad(-6*strike),0,0)
    elseif id=="OVL_Albedo" then
        root*=CFrame.Angles(rad(-2*windup+6*strike),
            rad(11*windup-11*strike),rad(8*windup))
        right=CFrame.Angles(rad(-19-33*windup+45*strike*s),0,
            rad(-20+5*strike))
        left=CFrame.Angles(rad(15-12*strike),0,rad(-19-35*windup+51*strike))
        neck=CFrame.Angles(rad(-3*windup+6*strike),0,0)
    elseif id=="OVL_Ainz" then
        root*=CFrame.Angles(rad(-3*windup),rad(11*strike),0)
        right=CFrame.Angles(rad(-13-65*windup+16*strike),0,
            rad(-8-16*windup))
        left=CFrame.Angles(rad(-17-42*windup+22*strike),0,
            rad(11+19*windup-9*strike))
        neck=CFrame.Angles(rad(3*windup-9*strike),0,0)
    end
    -- Stage 1/2/3 adds more distinct attack motion, never adds a fourth stage.
    if stage==2 then
        root*=CFrame.Angles(0,rad(8*strike),0)
        right*=CFrame.Angles(rad(12*strike),0,rad(13*strike))
    elseif stage==3 then
        root*=CFrame.Angles(rad(-4*strike),rad(18*strike),rad(7*strike))
        right*=CFrame.Angles(rad(20*strike),0,rad(14*strike))
        left*=CFrame.Angles(rad(-15*strike),0,rad(9*strike))
    end
    return {
        RootJoint=root, Neck=neck,
        ["Left Shoulder"]=left,["Right Shoulder"]=right,
        ["Left Hip"]=hipL,["Right Hip"]=hipR,
    }
end

function Motion.Attach(model: Model)
    local id=model:GetAttribute("UnitId")
    if typeof(id)~="string" or not DURATIONS[id] then return nil end
    local joints: {[string]: Motor6D}={}
    for _,d in ipairs(model:GetDescendants()) do
        if d:IsA("Motor6D") and (d.Name=="RootJoint" or d.Name=="Neck"
            or d.Name=="Left Shoulder" or d.Name=="Right Shoulder"
            or d.Name=="Left Hip" or d.Name=="Right Hip") then
            joints[d.Name]=d
        end
    end
    for _,n in ipairs({"RootJoint","Neck","Left Shoulder","Right Shoulder",
        "Left Hip","Right Hip"}) do
        if not joints[n] then return nil end
    end

    local attackTime=-math.huge
    local stage=clampStage(model:GetAttribute("VisualStage"))
    local face="Neutral"
    local target: Vector3?=nil
    local alive=true
    local start=os.clock()
    local faceParts=model:FindFirstChild("ExpressionParts")

    local function setFace(expression: string)
        if face==expression then return end
        face=expression
        if faceParts then
            for _,part in ipairs(faceParts:GetChildren()) do
                if part:IsA("BasePart") then
                    if part.Name=="MouthNeutral" then
                        part.Transparency=if expression=="Neutral" then 0 else 1
                    elseif part.Name=="MouthAttack" then
                        part.Transparency=if expression=="Attack" then 0 else 1
                    elseif part.Name=="MouthFocus" then
                        part.Transparency=if expression=="Focus" then 0 else 1
                    end
                end
            end
        end
    end

    local controller={}
    function controller:Attack(newStage: number, targetPosition: Vector3?)
        if not alive then return end
        stage=clampStage(newStage)
        target=targetPosition
        attackTime=os.clock()
    end
    function controller:Update()
        if not alive or not model.Parent then return end
        local now=os.clock()
        local duration=DURATIONS[id] or 0.40
        local progress=(now-attackTime)/duration
        local windup,strike=attackCurve(progress)
        local facing=if progress>=0 and progress<1 then
            lookYaw(model,target)*(windup*0.60+strike*0.40) else 0
        local transforms=animateJoints(id,stage,now-start,windup,strike,facing)
        for name,motor in pairs(joints) do
            motor.Transform=transforms[name] or CFrame.identity
        end
        if progress>=0 and progress<0.36 then
            setFace("Focus")
        elseif progress>=0.36 and progress<0.72 then
            setFace("Attack")
        else
            setFace("Neutral")
        end
    end
    function controller:Destroy()
        if not alive then return end
        alive=false
        for _,motor in pairs(joints) do
            if motor.Parent then motor.Transform=CFrame.identity end
        end
        setFace("Neutral")
    end
    function controller:Debug()
        return {UnitId=id,Stage=stage,Face=face,
            Active=(os.clock()-attackTime)<(DURATIONS[id] or 0.4)}
    end
    setFace("Focus")
    setFace("Neutral")
    return controller
end

return Motion
