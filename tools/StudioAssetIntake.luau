-- Studio Command Bar only; use in Edit mode, in a separate inspection place.
-- Select ONE authorized tree Model in Explorer before running. Edit fields
-- to match the actual source and slot. Never run a third-party script.
local SLOT="GardenTree" -- GardenTree or SakuraTree
local SOURCE="https://create.roblox.com/store/asset/6933438443"
local CREATOR="Synty Studios"
local LICENSE="Roblox-authorized Synty asset pack; reviewed for use in this experience"
local CONFIRM_RIGHTS=false -- set true ONLY after verifying source and usage rights
assert(not game:GetService("RunService"):IsRunning(),"Use Edit mode, not Play")
assert(CONFIRM_RIGHTS,"Review license and source, then set CONFIRM_RIGHTS=true")
assert(SLOT=="GardenTree" or SLOT=="SakuraTree","Unknown slot")
local selection=game:GetService("Selection")
local selected=selection:Get()
assert(#selected==1 and selected[1]:IsA("Model"),"Select one Model, not entire pack")
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
assert(parts>=1 and parts<=24 and meshes>=1 and #copy:GetDescendants()<=140,
    "Select a single lightweight reusable mesh model")
copy.Name=SLOT
copy:SetAttribute("Reviewed",true)
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
