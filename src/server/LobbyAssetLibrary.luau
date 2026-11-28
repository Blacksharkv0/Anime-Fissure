--!strict
-- Fissure City Reborn: optional, reviewed static asset templates.
-- No InsertService, asset-id require, remote downloads or third-party scripts.
local ServerStorage=game:GetService("ServerStorage")
local Library={}
local budgets={GardenTree=3,SakuraTree=8,SummonFacade=24,IndexFacade=24,AlchemyFacade=24,EvolutionFacade=24,TraitsFacade=24,RaidsFacade=24,CityBench=4,GardenFountain=12,SkylineTower=5}
local allowed={
    Model=true,Folder=true,Part=true,MeshPart=true,WedgePart=true,CornerWedgePart=true,
    SpecialMesh=true,BlockMesh=true,CylinderMesh=true,Decal=true,Texture=true,SurfaceAppearance=true,
}
function Library.Validate(template: Instance): (boolean,string)
    if not template:IsA("Model") then return false,"expected Model" end
    if template:GetAttribute("Reviewed")~=true then return false,"not reviewed" end
    for _,key in ipairs({"SourceURL","Creator","License"}) do
        local value=template:GetAttribute(key)
        if typeof(value)~="string" or value=="" then return false,"missing "..key end
    end
    local parts,meshes=0,0
    local all=template:GetDescendants()
    if #all>140 then return false,"too many instances" end
    for _,obj in ipairs(all) do
        if not allowed[obj.ClassName] then return false,"unsupported "..obj.ClassName end
        if obj:IsA("BasePart") then
            parts+=1
            if obj:IsA("MeshPart") then
                meshes+=1
                if obj.MeshId=="" then return false,"missing mesh ID" end
            end
        elseif obj:IsA("SpecialMesh") and obj.MeshType==Enum.MeshType.FileMesh then
            meshes+=1
            if obj.MeshId=="" then return false,"missing mesh ID" end
        end
    end
    if parts<1 or parts>24 or meshes<1 then return false,"expected 1–24 parts and at least one reusable mesh" end
    return true,"ok"
end
function Library.Place(slot: string,parent: Instance,ground: CFrame,height: number,maxWidth: number,maxDepth: number?): Model?
    local folder=ServerStorage:FindFirstChild("LobbyAssetLibrary")
    local source=if folder then folder:FindFirstChild(slot) else nil
    if not source then return nil end
    local valid,why=Library.Validate(source)
    if not valid then
        warn("[LobbyAssetLibrary] "..slot..": "..why.."; using procedural fallback")
        return nil
    end
    local partCount=0
    for _,obj in ipairs(source:GetDescendants()) do if obj:IsA("BasePart") then partCount+=1 end end
    local budget=budgets[slot]
    if not budget then return nil end
    if partCount>budget then
        warn("[LobbyAssetLibrary] "..slot.." exceeds per-instance budget "..budget)
        return nil
    end
    local clone=(source :: Model):Clone()
    if not clone then return nil end
    local ok,err=pcall(function()
        for _,obj in ipairs(clone:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Anchored=true;obj.CanCollide=false;obj.CanTouch=false;obj.CanQuery=false
            end
        end
        -- Align the model to a grounded center regardless of imported pivot.
        clone:PivotTo(CFrame.identity)
        local _,size=clone:GetBoundingBox()
        assert(size.Y>.01 and math.max(size.X,size.Z)>.01,"empty bounds")
        local scale=if maxDepth then math.min(height/size.Y,maxWidth/size.X,maxDepth/size.Z) else math.min(height/size.Y,maxWidth/math.max(size.X,size.Z))
        if maxDepth then assert(size.Y*scale>=height*.55,"model too short for architectural slot") end
        assert(scale>=.02 and scale<=100,"invalid scale")
        clone:ScaleTo(clone:GetScale()*scale)
        local bounds,scaled=clone:GetBoundingBox()
        local pivot=clone:GetPivot()
        clone:PivotTo(ground*CFrame.new(0,scaled.Y*.5,0)*bounds:Inverse()*pivot)
        clone.Name=slot.."_Imported"
        clone:SetAttribute("AssetSlot",slot)
        clone.Parent=parent
    end)
    if not ok then clone:Destroy();warn("[LobbyAssetLibrary] "..slot..": "..tostring(err));return nil end
    return clone
end
return Library
