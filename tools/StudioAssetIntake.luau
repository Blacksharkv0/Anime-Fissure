-- Studio Command Bar only; use in Edit mode, in a separate inspection place.
-- Select ONE authorized static Model in Explorer before running. Edit fields
-- to match the actual source and slot. Never run a third-party script.
local SLOT="GardenTree" -- see budgets below
local SOURCE="https://create.roblox.com/store/asset/6933438443"
local CREATOR="Synty Studios"
local LICENSE="Roblox-authorized Synty asset pack; reviewed for use in this experience"
local CONFIRM_RIGHTS=false -- set true ONLY after verifying source and usage rights
assert(not game:GetService("RunService"):IsRunning(),"Use Edit mode, not Play")
assert(CONFIRM_RIGHTS,"Review license and source, then set CONFIRM_RIGHTS=true")
local budgets={GardenTree=3,SakuraTree=8,SummonFacade=24,IndexFacade=24,AlchemyFacade=24,EvolutionFacade=24,TraitsFacade=24,RaidsFacade=24,CityBench=4,GardenFountain=12,SkylineTower=5,NPC_Vergil=24,NPC_Edward=24,NPC_Dante=24,NPC_Whis=24,NPC_Urahara=24,NPC_Jinwoo=24,NPC_Gilgamesh=24,NPC_Escanor=24}
assert(budgets[SLOT],"Unknown slot")
local selection=game:GetService("Selection")
local selected=selection:Get()
assert(#selected==1 and selected[1]:IsA("Model"),"Select one Model, not entire pack")
if string.sub(SLOT,1,4)=="NPC_" then
    for _,obj in ipairs(selected[1]:GetDescendants()) do
        assert(not obj:IsA("Bone") and not obj:IsA("WrapLayer") and not obj:IsA("WrapTarget") and not obj:IsA("Clothing"),"Bake static character mesh and texture first; rigged or layered characters require a separate pipeline")
    end
end
local copy=selected[1]:Clone()
assert(copy,"Cannot clone selected model")
local allow={Model=true,Folder=true,Part=true,MeshPart=true,WedgePart=true,CornerWedgePart=true,
    SpecialMesh=true,BlockMesh=true,CylinderMesh=true,Decal=true,Texture=true,SurfaceAppearance=true}
local removed=0
for _,obj in ipairs(copy:GetDescendants()) do
    if not allow[obj.ClassName] then obj:Destroy();removed+=1 end
end
local parts,meshes=0,0
for _,obj in ipairs(copy:GetDescendants()) do
    if obj:IsA("BasePart") then
        parts+=1
        obj.Anchored=true;obj.CanCollide=false;obj.CanTouch=false;obj.CanQuery=false
        if obj:IsA("MeshPart") and obj.MeshId~="" then meshes+=1 end
    elseif obj:IsA("SpecialMesh") and obj.MeshType==Enum.MeshType.FileMesh and obj.MeshId~="" then
        meshes+=1
    end
end
assert(parts>=1 and parts<=budgets[SLOT] and meshes>=1 and #copy:GetDescendants()<=140,
    "Select a single lightweight reusable mesh model")
copy.Name=SLOT
copy:SetAttribute("Reviewed",false) -- set true only after visual and permission inspection
copy:SetAttribute("SourceURL",SOURCE)
copy:SetAttribute("Creator",CREATOR)
copy:SetAttribute("License",LICENSE)
local storage=game:GetService("ServerStorage")
local library=storage:FindFirstChild("LobbyAssetLibrary")
if not library then
    library=Instance.new("Folder");library.Name="LobbyAssetLibrary";library.Parent=storage
end
assert(library:IsA("Folder"))
assert(not library:FindFirstChild(SLOT),"Slot already occupied; inspect and remove old template manually")
copy.Parent=library
selection:Set({copy})
print("[Asset Intake] "..SLOT.." staged: "..parts.." parts, "..meshes.." meshes, "..removed.." unsupported objects removed")
print("Inspect mesh/texture permissions and appearance; Save to File as "..SLOT..".rbxmx")
