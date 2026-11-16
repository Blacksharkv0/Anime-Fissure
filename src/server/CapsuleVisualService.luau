--!strict
-- ANIME FISSURE | CapsuleVisualService v0.1
-- Usar em FUTURO sistema de upgrades:
-- CapsuleVisualService.Refresh(placedCapsuleModel, newUpgradeLevel)
-- Mostra invencao 1 no upgrade 4 e invencao 2 no upgrade 8.
-- Apenas visual. Nao aplica o bonus economico duas vezes.

local RS = game:GetService("ReplicatedStorage")
local Config = require(RS:WaitForChild("Shared"):WaitForChild("CapsuleUnitConfig"))
local Service = {}

local OFFSETS = {
    CapsuleCashPrinter = CFrame.new(-4, -3, 0),
    CapsuleSupportDevice = CFrame.new(4, -3, 0),
}

function Service.Refresh(unitModel: Model, upgradeLevel: number): boolean
    if not unitModel or not unitModel:IsA("Model") or not unitModel.PrimaryPart then
        return false
    end
    local id = unitModel:GetAttribute("UnitId")
    if id ~= "Capsule" and id ~= "CapsuleCorp" then
        return false
    end
    local def = Config.Get(id)
    if typeof(upgradeLevel) ~= "number" or upgradeLevel % 1 ~= 0
        or upgradeLevel < 0 or upgradeLevel > def.MaxUpgrades then
        return false
    end
    local source = RS:FindFirstChild("CapsuleInventions")
    if not source then return false end
    local old = unitModel:FindFirstChild("ActiveInventions")
    if old then old:Destroy() end
    local holder = Instance.new("Folder")
    holder.Name = "ActiveInventions"
    holder.Parent = unitModel

    for _, inventionId in ipairs(Config.GetUnlockedInventions(id, upgradeLevel)) do
        local template = source:FindFirstChild(inventionId)
        if template and template:IsA("Model") then
            local clone = template:Clone()
            clone.Parent = holder
            clone:PivotTo(unitModel:GetPivot() * OFFSETS[inventionId])
        end
    end
    unitModel:SetAttribute("UpgradeLevel", upgradeLevel)
    return true
end

return Service
