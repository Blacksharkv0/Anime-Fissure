--!strict
-- Studio-only: check the new Edward rig without granting items.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local RS=game:GetService("ReplicatedStorage")
local Builder=require(RS:WaitForChild("Shared"):WaitForChild("FissureNPCBuilder"))
local npc=Builder.Build("Edward")
assert(npc and npc:IsA("Model"),"Edward builder failed")
assert(npc:GetAttribute("CharacterReborn")=="Edward-v1")
assert(math.abs(npc:GetScale()-.88)<.001,"Edward scale mismatch")
local details=npc:FindFirstChild("ModularAppearance")
assert(details and details:IsA("Folder"))
local head=npc:FindFirstChild("Head")
local torso=npc:FindFirstChild("Torso")
local right=npc:FindFirstChild("Right Arm")
assert(head and head:IsA("BasePart") and torso and torso:IsA("BasePart"))
assert(right and right:IsA("BasePart"))
assert(head:FindFirstChild("AnimeFace") and head:FindFirstChild("EdwardReborn_RoundedHead"))
assert(torso:FindFirstChild("Neck") and npc.PrimaryPart==npc:FindFirstChild("HumanoidRootPart"))
for _,name in ipairs({"Fringe_1_1","AntennaTip","Braid_7_1","HoodOuter","Tail_1","BackEmblemCross","WhiteGlove","AutomailElbow","Piston_1","Finger_4","BootLace_1_1"}) do
    assert(details:FindFirstChild("EdwardReborn_"..name),"Missing detail "..name)
end
local count=0
for _,part in ipairs(details:GetChildren()) do
    if part:IsA("BasePart") then
        local weld=part:FindFirstChild("DetailWeld")
        assert(weld and weld:IsA("WeldConstraint") and weld.Part1==part
            and weld.Part0 and weld.Part0:IsDescendantOf(npc))
        assert(not part.CanCollide and not part.CanTouch and not part.CanQuery and part.Massless)
        if string.find(part.Name,"Automail",1,true) then
            assert(weld.Part0==right,"Automail attached to wrong limb")
        end
        count+=1
    end
end
assert(count>=80 and count<=150,"Unexpected Edward geometry budget: "..count)
npc:Destroy()
print("[Anime Fissure] EDWARD REBORN SMOKE OK: "..count.." welded details, right automail, scaled rig")
