--!strict
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local RS=game:GetService("ReplicatedStorage")
local shared=RS:WaitForChild("Shared")
local Builder=require(shared:WaitForChild("OverlordTowerModelBuilder"))
local Art=require(shared:WaitForChild("OverlordImportedArt"))
local Roster=require(shared:WaitForChild("OverlordUnitRoster"))
local test=Instance.new("Folder")
assert(not Art.Reviewed(test))
test:SetAttribute("Reviewed",true)
assert(not Art.Reviewed(test),"Missing origin must reject import")
test:Destroy()
local imported=0
for _,entry in ipairs(Roster.GetAll()) do
    local model=Builder.Build(entry.Id)
    assert(model and model.PrimaryPart and model.PrimaryPart.Name=="HumanoidRootPart")
    assert(model:FindFirstChild("Neck",true) and model:FindFirstChild("WeaponFocus",true))
    if model:GetAttribute("ImportedWeapon")==true then
        local visual=model:FindFirstChild("ImportedWeapon")
        assert(visual and visual:IsA("Model"))
        for _,obj in ipairs(visual:GetDescendants()) do
            assert(not obj:IsA("LuaSourceContainer"))
            if obj:IsA("BasePart") then
                local weld=obj:FindFirstChild("ImportedWeaponWeld")
                assert(not obj.Anchored and not obj.CanCollide and not obj.CanQuery and not obj.CanTouch)
                assert(weld and weld:IsA("WeldConstraint") and weld.Part0==model:FindFirstChild("Right Arm"))
            end
        end
        imported+=1
    end
    for stage=0,3 do assert(Builder.SetVisualStage(model,stage)) end
    model:Destroy()
end
print("[Anime Fissure] OVERLORD IMPORTED ART CHECK: 6 rigs, 24 stages; "..imported.." imported weapons loaded")
