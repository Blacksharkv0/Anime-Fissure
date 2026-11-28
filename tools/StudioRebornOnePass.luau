-- FISSURE CITY REBORN | One-pass official scenery preview.
-- Paste in Studio Command Bar in EDIT mode of a LOCAL COPY, never a published place.
-- Does not buy assets, change permissions, execute third-party scripts or approve production models.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Pare o Play")
local storage=game:GetService("ServerStorage")
local library=storage:FindFirstChild("LobbyAssetLibrary")
assert(library and library:IsA("Folder"),"Abra a build Reborn com suporte StudioPreviewOnly")
local InsertService=game:GetService("InsertService")
local AssetService=game:GetService("AssetService")
local packs={
    {id=6933438443,name="SyntyNature",creator="Synty / Roblox"},
    {id=6933556508,name="SyntyCity",creator="Synty / Roblox"},
    {id=6934021345,name="SyntyDungeon",creator="Synty / Roblox"},
    {id=6370681139,name="CityProps",creator="Roblox"},
}
local allowed={Model=true,Folder=true,Part=true,MeshPart=true,WedgePart=true,CornerWedgePart=true,
    SpecialMesh=true,BlockMesh=true,CylinderMesh=true,Decal=true,Texture=true,SurfaceAppearance=true}
local function sanitize(root)
    for _,child in ipairs(root:GetChildren()) do
        if not allowed[child.ClassName] then child:Destroy()
        else
            if child:IsA("BasePart") then
                child.Anchored=true;child.CanCollide=false;child.CanTouch=false;child.CanQuery=false
            end
            sanitize(child)
        end
    end
end
local function load(pack)
    local ok,result=pcall(function() return InsertService:LoadAsset(pack.id) end)
    if not ok then
        ok,result=pcall(function() return AssetService:LoadAssetAsync(pack.id) end)
    end
    if not ok or typeof(result)~="Instance" then
        warn("[REBORN] "..pack.name.." indisponível: "..tostring(result));return nil
    end
    if not (result:IsA("Model") or result:IsA("Folder")) then result:Destroy();return nil end
    sanitize(result)
    return result
end
local slots={
    {name="GardenTree",packs={"SyntyNature"},words={"tree"},reject={"trunk","stump","branch","log","dead","leaf","leaves","palm","pine"},h=4.6,w=3.6,d=3.6,budget=3,min=.50},
    {name="SakuraTree",packs={"SyntyNature"},words={"sakura","cherry","blossom","pink tree"},reject={"trunk","stump","branch","log","leaf","leaves"},h=9,w=7.5,d=7.5,budget=8,min=.50},
    {name="CityBench",packs={"CityProps","SyntyCity"},words={"bench"},reject={"broken","leg","seat"},h=1.75,w=4.5,d=2.3,budget=4,min=.50},
    {name="GardenFountain",packs={"CityProps","SyntyCity","SyntyDungeon"},words={"fountain"},reject={"broken","base","water","piece"},h=3.4,w=7,d=7,budget=12,min=.50},
    {name="SkylineTower",packs={"SyntyCity"},words={"skyscraper","tower","building"},reject={"wall","roof","window","door","corner","floor","piece","sign"},h=25,w=7.6,d=7.6,budget=5,min=.55},
    {name="SummonFacade",packs={"SyntyDungeon","SyntyCity"},words={"archway","arch","gateway","gate"},reject={"broken","half","door","corner","window","piece","pillar"},h=13,w=15,d=5,budget=24,min=.55},
    {name="IndexFacade",packs={"SyntyDungeon","SyntyCity"},words={"library","facade","entrance","archway"},reject={"broken","half","roof","window","door","piece","corner"},h=14,w=13,d=5,budget=24,min=.55},
    {name="AlchemyFacade",packs={"SyntyCity"},words={"shop","storefront","workshop","facade"},reject={"sign","window","door","roof","wall","piece","corner"},h=16,w=25,d=5,budget=24,min=.55},
    {name="EvolutionFacade",packs={"SyntyDungeon"},words={"temple","archway","gateway","arch"},reject={"broken","half","door","corner","window","piece","pillar"},h=15,w=15,d=5,budget=24,min=.55},
    {name="TraitsFacade",packs={"SyntyCity"},words={"workshop","shop","storefront","facade"},reject={"sign","window","door","roof","wall","piece","corner"},h=14,w=15,d=5,budget=24,min=.55},
    {name="RaidsFacade",packs={"SyntyDungeon"},words={"dungeon entrance","gateway","archway","gate","arch"},reject={"broken","half","door","corner","window","piece","pillar"},h=15,w=15,d=5,budget=24,min=.55},
}
local function match(name,words)
    for _,word in ipairs(words) do if name:find(word,1,true) then return true end end
    return false
end
local loaded={}
for _,pack in ipairs(packs) do
    local root=load(pack)
    if root then
        loaded[pack.name]={root=root,pack=pack}
        print("[REBORN] carregado: "..pack.name)
    end
end
local function candidate(obj,slot)
    local name=string.lower(obj.Name)
    if not match(name,slot.words) or match(name,slot.reject) then return nil end
    if not (obj:IsA("Model") or obj:IsA("MeshPart")) then return nil end
    local model=Instance.new("Model")
    local clone=obj:Clone()
    if not clone then model:Destroy();return nil end
    clone.Parent=model
    sanitize(model)
    local count,meshes=0,0
    local all=model:GetDescendants()
    if #all>140 then model:Destroy();return nil end
    for _,part in ipairs(all) do
        if part:IsA("BasePart") then
            count+=1
            if part:IsA("MeshPart") and part.MeshId~="" then meshes+=1 end
        elseif part:IsA("SpecialMesh") and part.MeshType==Enum.MeshType.FileMesh and part.MeshId~="" then meshes+=1 end
    end
    if count<1 or count>slot.budget or meshes<1 then model:Destroy();return nil end
    model:PivotTo(CFrame.identity)
    local _,size=model:GetBoundingBox()
    if math.min(size.X,size.Y,size.Z)<.01 then model:Destroy();return nil end
    local scale=math.min(slot.h/size.Y,slot.w/size.X,slot.d/size.Z)
    local ratio=size.Y*scale/slot.h
    if scale<.02 or scale>100 or ratio<slot.min then model:Destroy();return nil end
    -- Prioritize fit, complete models, and early exact semantic keywords.
    local score=ratio*100+(if obj:IsA("Model") then 5 else 0)
    for i,word in ipairs(slot.words) do
        if name:find(word,1,true) then score+=#slot.words-i;break end
    end
    return model,score
end
local installed,missing,existing=0,0,0
local chosen={}
for _,slot in ipairs(slots) do
    if library:FindFirstChild(slot.name) then
        existing+=1;print("[REBORN] preservado: "..slot.name);continue
    end
    local best,bestScore,bestSource,bestName=nil,-1,nil,nil
    for _,packName in ipairs(slot.packs) do
        local entry=loaded[packName]
        if entry then
            for _,obj in ipairs(entry.root:GetDescendants()) do
                local ok,m,score=pcall(candidate,obj,slot)
                if ok and m then
                    if score>bestScore then
                        if best then best:Destroy() end
                        best,bestScore,bestSource,bestName=m,score,entry.pack,obj.Name
                    else m:Destroy() end
                end
            end
        end
    end
    if best then
        best.Name=slot.name
        best:SetAttribute("Reviewed",false)
        best:SetAttribute("StudioPreviewOnly",true)
        best:SetAttribute("SourceURL","https://create.roblox.com/store/asset/"..bestSource.id)
        best:SetAttribute("Creator",bestSource.creator)
        best:SetAttribute("License","Pacote oficial para uso no Roblox; revisão visual pendente")
        best:SetAttribute("CandidateName",bestName)
        best.Parent=library
        installed+=1;table.insert(chosen,best)
        print("[REBORN] PRÉVIA "..slot.name.." = "..bestName)
    else
        missing+=1;warn("[REBORN] Sem candidato adequado: "..slot.name.." (fallback preservado)")
    end
end
for _,entry in pairs(loaded) do entry.root:Destroy() end
game:GetService("Selection"):Set(chosen)
print("[REBORN] RESULTADO: "..installed.." prévias, "..existing.." preservados, "..missing.." sem candidato; NPCs aguardam modelos autorizados.")
print("[REBORN] Salve uma cópia local e pressione F5. Prévia não é aprovação final; revise aparência e Output.")
