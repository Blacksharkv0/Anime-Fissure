-- Edit mode only. Select a single inspected Model (weapon) or ParticleEmitter.
-- Verify actual source, license, textures and visual before setting CONFIRM=true.
local KIND="Weapons" -- Weapons or Particles
local SLOT="OVL_Ainz" -- Particles example: OVL_Ainz_3
local SOURCE="" -- real Creator Store URL
local CREATOR=""
local LICENSE=""
local CONFIRM=false
assert(not game:GetService("RunService"):IsRunning(),"Edit mode only")
assert(CONFIRM and SOURCE~="" and CREATOR~="" and LICENSE~="","Review rights and fill metadata")
assert(KIND=="Weapons" or KIND=="Particles")
local roster={OVL_Climb=true,OVL_Brain=true,OVL_Gazef=true,OVL_Shalltear=true,OVL_Albedo=true,OVL_Ainz=true}
if KIND=="Weapons" then assert(roster[SLOT]) else
    local id,stage=string.match(SLOT,"^(OVL_%a+)_(%d)$")
    assert(id and roster[id] and tonumber(stage)<=3,"Invalid particle slot")
end
local selection=game:GetService("Selection")
local picked=selection:Get()
assert(#picked==1)
local source=picked[1]
local copy=source:Clone()
assert(copy)
if KIND=="Weapons" then
    assert(copy:IsA("Model"),"Select weapon Model with Grip and Tip attachments")
    local allow={Model=true,Folder=true,Part=true,MeshPart=true,WedgePart=true,
        SpecialMesh=true,Decal=true,Texture=true,SurfaceAppearance=true,Attachment=true}
    local function clean(parent)
        for _,obj in ipairs(parent:GetChildren()) do
            if not allow[obj.ClassName] then obj:Destroy()
            else clean(obj) end
        end
    end
    clean(copy)
    local count,meshes=0,0
    for _,obj in ipairs(copy:GetDescendants()) do
        if obj:IsA("BasePart") then count+=1;obj.Anchored=true;obj.CanCollide=false;obj.CanTouch=false;obj.CanQuery=false end
        if obj:IsA("MeshPart") and obj.MeshId~="" then meshes+=1 end
        if obj:IsA("SpecialMesh") and obj.MeshType==Enum.MeshType.FileMesh and obj.MeshId~="" then meshes+=1 end
    end
    assert(count>=1 and count<=12 and meshes>=1 and #copy:GetDescendants()<=90)
    for _,name in ipairs({"Grip","Tip"}) do
        local marker=copy:FindFirstChild(name,true)
        assert(marker and marker:IsA("Attachment") and marker.Parent:IsA("BasePart"),"Missing "..name)
    end
else
    assert(copy:IsA("ParticleEmitter"),"Select one ParticleEmitter, not whole effect pack")
    copy:ClearAllChildren()
    assert(copy.Texture~="","Missing texture")
    copy.Enabled=false;copy.Rate=0
end
local library=game:GetService("ReplicatedStorage"):FindFirstChild("OverlordArtLibrary")
assert(library and library:IsA("Folder"),"Open current Overlord art-ready build")
local group=library:FindFirstChild(KIND)
if not group then group=Instance.new("Folder");group.Name=KIND;group.Parent=library end
assert(group:IsA("Folder") and not group:FindFirstChild(SLOT),"Slot occupied")
copy.Name=SLOT
copy:SetAttribute("SourceURL",SOURCE);copy:SetAttribute("Creator",CREATOR);copy:SetAttribute("License",LICENSE)
copy:SetAttribute("Reviewed",true)
copy.Parent=group
selection:Set({copy})
print("[Overlord Intake] "..KIND.."/"..SLOT.." staged; test in Studio, not approved for production")
