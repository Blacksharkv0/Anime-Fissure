--!strict
-- Optional character skins: reviewed, baked static meshes only.
-- Never replace original functional model, prompt anchor or NPC ID.
local Assets=require(script.Parent:WaitForChild("LobbyAssetLibrary"))
local Appearance={}
local specs={
    Vergil={Height=5.9,Width=4.6,Depth=3.8},
    Edward={Height=5.2,Width=4.4,Depth=3.6},
    Dante={Height=9.8,Width=5.6,Depth=4.4},
    Whis={Height=10.8,Width=6.2,Depth=4.4},
    Urahara={Height=9.8,Width=5.6,Depth=4.4},
    Jinwoo={Height=9.8,Width=5.6,Depth=4.4},
    Gilgamesh={Height=9.8,Width=6.2,Depth=4.4},
    Escanor={Height=10.6,Width=7.0,Depth=4.8},
}
local preserved={SovereignPedestal=true,SovereignStep=true}
function Appearance.Apply(npc: Model,id: string,ground: CFrame): boolean
    if npc:GetAttribute("ImportedAppearance")==true then return true end
    local spec=specs[id]
    if not spec then return false end
    local original=npc:GetDescendants()
    local imported=Assets.Place("NPC_"..id,npc,ground,spec.Height,spec.Width,spec.Depth)
    if not imported then return false end
    -- Functional parts and original art markers are retained, for reliable
    -- interactions, existing smoke tests and a procedural fallback.
    for _,obj in ipairs(original) do
        if obj:IsA("BasePart") and not preserved[obj.Name] and not obj.CanCollide then
            obj.Transparency=1;obj.CastShadow=false
        elseif obj:IsA("SurfaceGui") then
            -- Facial art only; functional BillboardGui labels untouched.
            obj.Enabled=false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency=1
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight") or obj:IsA("SurfaceLight") then
            obj.Enabled=false
        end
    end
    imported.Name="ImportedVisual"
    npc:SetAttribute("ImportedAppearance",true)
    npc:SetAttribute("AppearanceSource",imported:GetAttribute("SourceURL"))
    npc:SetAttribute("AppearanceMode","ReviewedStaticMesh")
    print("[Anime Fissure] NPC ASSET READY: "..id)
    return true
end
return Appearance
