--!strict
-- ANIME FISSURE | Overlord Animation Studio smoke test v0.9
-- Checks all 6 R6 rigs, 3 upgrade changes, weapon anchors, facial assets,
-- and procedural motion API. DOES NOT grant units or modify a live match.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end

local ReplicatedStorage=game:GetService("ReplicatedStorage")
local ServerStorage=game:GetService("ServerStorage")
local Shared=ReplicatedStorage:WaitForChild("Shared")

local Roster=require(Shared:WaitForChild("OverlordUnitRoster"))
local Builder=require(Shared:WaitForChild("OverlordTowerModelBuilder"))
local Motion=require(Shared:WaitForChild("OverlordMotionController"))

local templates=ReplicatedStorage:WaitForChild("OverlordTowerModels",50)
assert(templates and templates:IsA("Folder"),"Overlord model templates unavailable")
local tested=0
for _,unit in ipairs(Roster.GetAll()) do
    local template=templates:FindFirstChild(unit.Id.."_"..unit.Rarity)
    assert(template and template:IsA("Model"),"Missing R6 template: "..unit.Id)
    assert(template:GetAttribute("ModelFinishVersion")=="0.9.0",
        "Unit has no finished face/weapon: "..unit.Id)
    local faces=template:FindFirstChild("ExpressionParts")
    local weapon=template:FindFirstChild("WeaponFinish")
    local hand=template:FindFirstChild("Right Arm")
    assert(faces and faces:IsA("Folder") and
        weapon and weapon:IsA("Folder"),"Missing art folders: "..unit.Id)
    assert(hand and hand:IsA("BasePart"),"Missing weapon arm: "..unit.Id)
    local focus=hand:FindFirstChild("WeaponFocus")
    assert(focus and focus:IsA("Attachment"),
        "Animation VFX requires a moving weapon attachment: "..unit.Id)
    for _,name in ipairs({"MouthNeutral","MouthFocus","MouthAttack",
        "FocusMark","AttackEyeGlint"}) do
        assert(faces:FindFirstChild(name),
            "Missing expression "..name.." in "..unit.Id)
    end
    local facePieces=0
    for _,p in ipairs(faces:GetDescendants()) do
        if p:IsA("BasePart") then
            facePieces+=1
            assert(not p.Anchored and not p.CanCollide and not p.CanQuery,
                "Face part must be visual only: "..p.Name)
            assert(p:FindFirstChild("WeaponFinishWeld"),
                "Face piece not welded to R6 head: "..p.Name)
        end
    end
    assert(facePieces>=7,"Insufficient face expression geometry: "..unit.Id)
    for _,p in ipairs(weapon:GetDescendants()) do
        if p:IsA("BasePart") then
            assert(not p.Anchored and not p.CanCollide and not p.CanQuery,
                "Weapon cosmetics must be non-physical")
            assert(p:FindFirstChild("WeaponFinishWeld"),"Unwelded weapon detail")
        end
    end

    for stage=0,3 do
        local clone=template:Clone()
        clone.Parent=ServerStorage
        assert(Builder.SetVisualStage(clone,stage),
            "No visual upgrade "..stage.." for "..unit.Id)
        local motion=Motion.Attach(clone)
        assert(motion,"No motion controller for "..unit.Id)
        motion:Attack(stage,Vector3.new(6,2,-6))
        local snapshot=motion:Debug()
        assert(snapshot.UnitId==unit.Id and snapshot.Stage==stage,
            "Animation stage mapping error for "..unit.Id)
        motion:Update() -- writes Motor6D.Transform on isolated model
        assert(clone:FindFirstChild("RootJoint",true),
            "Missing R6 animation root joint")
        motion:Destroy()
        clone:Destroy()
        tested+=1
    end
end
assert(tested==24,"Expected six units times four attack appearances")
print("[Anime Fissure] OVERLORD ANIMATION SMOKE OK: 24 motion stages | 6 faces | 6 weapons")
