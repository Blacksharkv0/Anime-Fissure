--!strict
-- Studio-only validation of Character Reborn geometry and preserved rig.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local RS=game:GetService("ReplicatedStorage")
local Builder=require(RS:WaitForChild("Shared"):WaitForChild("FissureNPCBuilder"))
local npc=Builder.Build("Virgil")
assert(npc and npc:IsA("Model"),"Vergil builder failed")
assert(npc:GetAttribute("CharacterReborn")=="Vergil-v1")
local details=npc:FindFirstChild("ModularAppearance")
assert(details and details:IsA("Folder"))
local head=npc:FindFirstChild("Head")
local torso=npc:FindFirstChild("Torso")
assert(head and head:IsA("BasePart") and torso and torso:IsA("BasePart"))
assert(head:FindFirstChild("AnimeFace") and head:FindFirstChild("Reborn_RoundedHead"))
assert(torso:FindFirstChild("Neck") and npc.PrimaryPart==npc:FindFirstChild("HumanoidRootPart"))
for _,name in ipairs({"Reborn_SweptLock_0","Reborn_Lapel_1","Reborn_TailOuter_1",
    "Reborn_SwordGuard","Reborn_Scabbard","Reborn_SwordHandle","Reborn_Glove_1","Reborn_BootToe_1"}) do
    assert(details:FindFirstChild(name),"Missing signature detail "..name)
end
local count=0
for _,part in ipairs(details:GetChildren()) do
    if part:IsA("BasePart") then
        local weld=part:FindFirstChild("DetailWeld")
        assert(weld and weld:IsA("WeldConstraint") and weld.Part1==part
            and weld.Part0 and weld.Part0:IsDescendantOf(npc),"Unbound decoration "..part.Name)
        assert(not part.CanCollide and not part.CanQuery and not part.CanTouch and part.Massless)
        count+=1
    end
end
assert(count>=70 and count<=150,"Unexpected geometry budget: "..count)
npc:Destroy()
print("[Anime Fissure] VERGIL REBORN SMOKE OK: "..count.." welded cosmetic details, rig intact")
