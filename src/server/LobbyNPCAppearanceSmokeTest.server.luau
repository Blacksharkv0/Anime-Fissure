--!strict
-- Studio-only validation of the optional character appearance path.
local RunService=game:GetService("RunService")
if not RunService:IsStudio() then return end
local Assets=require(script.Parent:WaitForChild("LobbyAssetLibrary"))
local Appearance=require(script.Parent:WaitForChild("LobbyNPCAppearance"))
local bad=Instance.new("Model")
bad:SetAttribute("Reviewed",true)
bad:SetAttribute("SourceURL","https://example.invalid/test")
bad:SetAttribute("Creator","Studio test")
bad:SetAttribute("License","Test only")
local forbidden=Instance.new("Script");forbidden.Parent=bad
local valid=Assets.Validate(bad)
assert(not valid,"Executable third-party content must be rejected")
bad:Destroy()
local dummy=Instance.new("Model")
local original=Instance.new("Part");original.Name="Head";original.Parent=dummy
local prompt=Instance.new("ProximityPrompt");prompt.Parent=original
assert(not Appearance.Apply(dummy,"UnknownSlot",CFrame.identity))
assert(original.Transparency==0 and prompt.Parent==original,"Failed import must preserve original visuals and prompt")
dummy:Destroy()
print("[Anime Fissure] NPC ASSET VALIDATION SMOKE OK | reject scripts and preserve fallback")
