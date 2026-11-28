-- Command Bar, modo Edit. Selecione UM candidato inteiro da galeria.
-- Só execute depois de confirmar aparência, modelo completo, licença e permissão das malhas/texturas.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Pare o Play")
local selection=game:GetService("Selection")
local picked=selection:Get()
assert(#picked==1 and picked[1]:IsA("Model"),"Selecione um Model inteiro")
local gallery=workspace:FindFirstChild("FissureAssetGallery")
assert(gallery and picked[1].Parent==gallery,"Selecione um candidato da galeria")
local source=picked[1]
local slot=source:GetAttribute("SuggestedSlot")
local budgets={GardenTree=3,SakuraTree=8,CityBench=4,GardenFountain=12}
assert(typeof(slot)=="string" and budgets[slot],"Slot inválido")
local library=game:GetService("ServerStorage"):FindFirstChild("LobbyAssetLibrary")
assert(library and library:IsA("Folder") and not library:FindFirstChild(slot),"Slot ocupado ou biblioteca ausente")
local allow={Model=true,Folder=true,Part=true,MeshPart=true,WedgePart=true,CornerWedgePart=true,
    SpecialMesh=true,BlockMesh=true,CylinderMesh=true,Decal=true,Texture=true,SurfaceAppearance=true}
local parts,meshes=0,0
for _,obj in ipairs(source:GetDescendants()) do
    assert(allow[obj.ClassName],"Objeto não autorizado: "..obj.ClassName)
    if obj:IsA("BasePart") then parts+=1 end
    if obj:IsA("MeshPart") and obj.MeshId~="" then meshes+=1 end
end
assert(parts>=1 and parts<=budgets[slot] and meshes>=1 and #source:GetDescendants()<=140,"Modelo fora do orçamento")
for _,key in ipairs({"SourceURL","Creator","License"}) do
    local value=source:GetAttribute(key)
    assert(typeof(value)=="string" and value~="","Origem não registrada")
end
local template=source:Clone()
template.Name=slot
template:SetAttribute("Reviewed",true)
template:PivotTo(CFrame.identity)
template.Parent=library
selection:Set({template})
print("[FISSURE] "..slot.." aprovado. Será usado automaticamente no próximo Play.")
print("Antes do Play, remova apenas FissureAssetGallery e FissureAssetCatalog (cópias de inspeção), não LobbyAssetLibrary.")
