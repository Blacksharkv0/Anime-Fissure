--!strict
-- Studio-only, reviewed weapon meshes on the existing R6 animation rig.
local RS=game:GetService("ReplicatedStorage")
local RunService=game:GetService("RunService")
local Art={}
local prefixes={
    OVL_Climb={"GuardSword_"},
    OVL_Brain={"Katana_","KatanaHiltWrap"},
    OVL_Gazef={"RazorEdge_"},
    OVL_Shalltear={"SpuitLance"},
    OVL_Albedo={"GuardianHalberd"},
    OVL_Ainz={"OverlordStaff","StaffSecondaryOrb"},
}
local allowed={Model=true,Folder=true,Part=true,MeshPart=true,WedgePart=true,
    SpecialMesh=true,Decal=true,Texture=true,SurfaceAppearance=true,Attachment=true}
function Art.Reviewed(source: Instance): boolean
    if source:GetAttribute("Reviewed")~=true then return false end
    for _,key in ipairs({"SourceURL","Creator","License"}) do
        local v=source:GetAttribute(key)
        if typeof(v)~="string" or v=="" then return false end
    end
    return true
end
function Art.ApplyWeapon(model: Model,id: string): boolean
    if not RunService:IsStudio() then return false end
    local names=prefixes[id]
    local library=RS:FindFirstChild("OverlordArtLibrary")
    local weapons=if library then library:FindFirstChild("Weapons") else nil
    local source=if weapons then weapons:FindFirstChild(id) else nil
    if not names or not source or not source:IsA("Model") or not Art.Reviewed(source) then return false end
    local arm=model:FindFirstChild("Right Arm")
    if not arm or not arm:IsA("BasePart") then return false end
    local focus=arm:FindFirstChild("WeaponFocus")
    if not focus or not focus:IsA("Attachment") then return false end
    local count,meshes=0,0
    local children=source:GetDescendants()
    if #children>90 then return false end
    for _,obj in ipairs(children) do
        if not allowed[obj.ClassName] then return false end
        if obj:IsA("BasePart") then count+=1 end
        if obj:IsA("MeshPart") and obj.MeshId~="" then meshes+=1 end
        if obj:IsA("SpecialMesh") and obj.MeshType==Enum.MeshType.FileMesh and obj.MeshId~="" then meshes+=1 end
    end
    if count<1 or count>12 or meshes<1 then return false end
    local clone=source:Clone()
    if not clone then return false end
    local ok,err=pcall(function()
        local grip=clone:FindFirstChild("Grip",true)
        local tip=clone:FindFirstChild("Tip",true)
        assert(grip and grip:IsA("Attachment") and grip.Parent and grip.Parent:IsA("BasePart"))
        assert(tip and tip:IsA("Attachment") and tip.Parent and tip.Parent:IsA("BasePart"))
        local target=arm.CFrame*CFrame.new(0,-.69,-.59)
        local length=(tip.WorldPosition-grip.WorldPosition).Magnitude
        assert(length>.05)
        local desired=(focus.WorldPosition-target.Position).Magnitude
        local scale=desired/length
        assert(scale>=.02 and scale<=100)
        clone:ScaleTo(clone:GetScale()*scale)
        clone:PivotTo(target*grip.WorldCFrame:Inverse()*clone:GetPivot())
        local _,size=clone:GetBoundingBox()
        assert(math.max(size.X,size.Y,size.Z)<=7,"weapon bounds too large")
        assert((tip.WorldPosition-focus.WorldPosition).Magnitude<1.3,"orient Grip so local +Y points along blade toward Tip")
        for _,p in ipairs(clone:GetDescendants()) do
            if p:IsA("BasePart") then
                p.Anchored=false;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.Massless=true
                local weld=Instance.new("WeldConstraint")
                weld.Name="ImportedWeaponWeld";weld.Part0=arm;weld.Part1=p;weld.Parent=p
            end
        end
    end)
    if not ok then clone:Destroy();warn("[OverlordArt] "..id..": "..tostring(err));return false end
    for _,folderName in ipairs({"BaseAccessories","AnimeArtPass","WeaponFinish"}) do
        local folder=model:FindFirstChild(folderName)
        if folder then
            for _,obj in ipairs(folder:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local hide=folderName=="WeaponFinish"
                    for _,prefix in ipairs(names) do
                        if string.sub(obj.Name,1,#prefix)==prefix then hide=true end
                    end
                    if hide then obj.Transparency=1;obj.CastShadow=false end
                end
            end
        end
    end
    clone.Name="ImportedWeapon";clone.Parent=model
    model:SetAttribute("ImportedWeapon",true)
    return true
end
return Art
