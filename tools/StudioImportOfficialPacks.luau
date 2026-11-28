-- ANIME FISSURE | IMPORTADOR DE PACOTES OFICIAIS (Command Bar, modo Edit)
-- Execute somente em uma COPIA local do projeto, nunca no jogo publicado.
-- Nenhuma compra, upload, require remoto, alteração de permissão ou código de terceiros.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Pare o Play antes de importar")
local Storage=game:GetService("ServerStorage")
local Workspace=game:GetService("Workspace")
local InsertService=game:GetService("InsertService")
local AssetService=game:GetService("AssetService")
local Selection=game:GetService("Selection")
local library=Storage:FindFirstChild("LobbyAssetLibrary")
assert(library and library:IsA("Folder"),"Abra a build Asset Ready")
assert(not Storage:FindFirstChild("FissureAssetCatalog"),"Catálogo já existe; não sobrescrevi")
assert(not Workspace:FindFirstChild("FissureAssetGallery"),"Galeria já existe; não sobrescrevi")
local packs={
    {Name="SyntyNature",Id=6933438443,Creator="Synty / Roblox"},
    {Name="SyntyCity",Id=6933556508,Creator="Synty / Roblox"},
    {Name="SyntyDungeon",Id=6934021345,Creator="Synty / Roblox"},
    {Name="CityProps",Id=6370681139,Creator="Roblox"},
}
local allow={Model=true,Folder=true,Part=true,MeshPart=true,WedgePart=true,CornerWedgePart=true,
    SpecialMesh=true,BlockMesh=true,CylinderMesh=true,Decal=true,Texture=true,SurfaceAppearance=true}
local catalog=Instance.new("Folder");catalog.Name="FissureAssetCatalog";catalog.Parent=Storage
local gallery=Instance.new("Folder");gallery.Name="FissureAssetGallery";gallery.Parent=Workspace
local function sanitize(root)
    local removed=0
    local function visit(parent)
        for _,child in ipairs(parent:GetChildren()) do
            if not allow[child.ClassName] then child:Destroy();removed+=1
            else
                if child:IsA("BasePart") then
                    child.Anchored=true;child.CanCollide=false;child.CanTouch=false;child.CanQuery=false
                end
                visit(child)
            end
        end
    end
    visit(root)
    return removed
end
local function loadPack(id)
    local ok,asset=pcall(function() return InsertService:LoadAsset(id) end)
    if ok and typeof(asset)=="Instance" then return asset end
    local firstError=tostring(asset)
    -- Do not change AllowInsertFreeAssets or any Studio security setting.
    local ok2,asset2=pcall(function() return AssetService:LoadAssetAsync(id) end)
    if ok2 and typeof(asset2)=="Instance" then return asset2 end
    warn("PACOTE "..id.." indisponível: "..firstError.." | "..tostring(asset2))
    return nil
end
local function sampleScore(obj,slot)
    local name=string.lower(obj.Name)
    if slot=="GardenTree" or slot=="SakuraTree" then
        if not name:find("tree",1,true) then return 0 end
        for _,word in ipairs({"stump","branch","trunk","leaf","leaves","log","dead","broken"}) do
            if name:find(word,1,true) then return 0 end
        end
        local score=10
        if slot=="SakuraTree" and (name:find("cherry",1,true) or name:find("sakura",1,true) or name:find("pink",1,true)) then score+=30 end
        if name:find("pine",1,true) or name:find("palm",1,true) then score-=5 end
        return score
    elseif slot=="CityBench" then
        return if name:find("bench",1,true) then 10 else 0
    elseif slot=="GardenFountain" then
        return if name:find("fountain",1,true) then 10 else 0
    end
    return 0
end
local function preview(obj,pack,slot,index)
    local model=Instance.new("Model")
    model.Name=slot.."__"..obj.Name
    local mesh=obj:Clone();mesh.Parent=model
    sanitize(model)
    model:SetAttribute("SuggestedSlot",slot)
    model:SetAttribute("Reviewed",false)
    model:SetAttribute("SourceURL","https://create.roblox.com/store/asset/"..pack.Id)
    model:SetAttribute("Creator",pack.Creator)
    model:SetAttribute("License","Uso no Roblox conforme termos do pacote; confirmar antes de aprovar")
    model:PivotTo(CFrame.identity)
    local _,size=model:GetBoundingBox()
    if size.Y<.01 then model:Destroy();return end
    local factor=math.min(7/size.Y,9/math.max(size.X,size.Z))
    if factor<.02 or factor>100 then model:Destroy();return end
    model:ScaleTo(model:GetScale()*factor)
    local box,scaled=model:GetBoundingBox()
    local x=250+((index-1)%6)*14
    local z=180+math.floor((index-1)/6)*14
    model:PivotTo(CFrame.new(x,scaled.Y*.5,z)*box:Inverse()*model:GetPivot())
    model.Parent=gallery
    -- Label belongs to gallery only; never inside the reviewed template.
    local marker=Instance.new("Part");marker.Name="Label_"..index
    marker.Anchored=true;marker.CanCollide=false;marker.CanTouch=false;marker.CanQuery=false
    marker.Transparency=1;marker.Size=Vector3.new(.2,.2,.2)
    marker.Position=Vector3.new(x,8.5,z);marker.Parent=gallery
    local sign=Instance.new("BillboardGui");sign.Size=UDim2.fromOffset(145,42);sign.AlwaysOnTop=true;sign.MaxDistance=75;sign.Parent=marker
    local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundColor3=Color3.fromRGB(20,30,48)
    text.BackgroundTransparency=.15;text.TextColor3=Color3.new(1,1,1);text.TextScaled=true;text.TextWrapped=true
    text.Text=slot.."\n"..obj.Name;text.Parent=sign
end
local index=0
local imported=0
for _,pack in ipairs(packs) do
    local asset=loadPack(pack.Id)
    if asset and not (asset:IsA("Model") or asset:IsA("Folder")) then
        asset:Destroy();asset=nil
        warn("[FISSURE] Unexpected pack root; rejected "..pack.Name)
    end
    if asset then
        -- Strip unsupported classes BEFORE parenting anything into the game.
        local removed=sanitize(asset)
        asset.Name=pack.Name
        asset:SetAttribute("SourceURL","https://create.roblox.com/store/asset/"..pack.Id)
        asset:SetAttribute("Creator",pack.Creator)
        asset.Parent=catalog
        imported+=1
        local meshes={}
        for _,obj in ipairs(asset:GetDescendants()) do
            if obj:IsA("MeshPart") and obj.MeshId~="" then table.insert(meshes,obj) end
        end
        print("[FISSURE] "..pack.Name..": "..#meshes.." MeshParts; "..removed.." objetos não autorizados removidos")
        local slots=if pack.Name=="SyntyNature" then {"GardenTree","SakuraTree"} elseif pack.Name=="CityProps" or pack.Name=="SyntyCity" then {"CityBench","GardenFountain"} else {}
        for _,slot in ipairs(slots) do
            local ranked={}
            for _,obj in ipairs(meshes) do
                local score=sampleScore(obj,slot)
                if score>0 then table.insert(ranked,{Object=obj,Score=score}) end
            end
            table.sort(ranked,function(a,b) if a.Score==b.Score then return a.Object.Name<b.Object.Name end return a.Score>b.Score end)
            for i=1,math.min(#ranked,4) do
                index+=1;preview(ranked[i].Object,pack,slot,index)
            end
            if #ranked==0 then print("[FISSURE] "..pack.Name..": sem candidato automático para "..slot.."; escolha manual no catálogo") end
        end
    end
end
if imported==0 then
    catalog:Destroy();gallery:Destroy()
    warn("[FISSURE] Nenhum pacote importado. Adicione os quatro pacotes oficiais pela Toolbox em um Baseplate separado.")
    return
end
if index>0 then
    Selection:Set({gallery})
    local camera=Workspace.CurrentCamera
    if camera then camera.CFrame=CFrame.lookAt(Vector3.new(285,65,150),Vector3.new(285,2,200)) end
else
    Selection:Set({catalog})
end
print("[FISSURE] "..imported.."/4 pacotes importados. "..index.." candidatos de inspeção. Nenhum modelo aprovado automaticamente.")
print("Inspecione FissureAssetGallery e FissureAssetCatalog. Não aperte Play com a galeria presente.")
