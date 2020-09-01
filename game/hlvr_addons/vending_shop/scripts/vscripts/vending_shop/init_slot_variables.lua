if IsClient() then
	return
end

local ContextManager = require("vending_shop/classes/context_manager")
local contextManager = ContextManager(thisEntity)

if contextManager:GetStoredBool("init_slot_variables.hasInitialized") then
	index = contextManager:GetStoredNumber("init_slot_variables.index")
    item = contextManager:GetStoredString("init_slot_variables.item")
    cost = contextManager:GetStoredNumber("init_slot_variables.cost")
end

function Spawn(spawnKeys)
	index = tonumber(spawnKeys:GetValue("Case01"))
    item = spawnKeys:GetValue("Case02")
    cost = tonumber(spawnKeys:GetValue("Case03")) or -1
	
	contextManager:SetStoredNumber("init_slot_variables.index", index)
    contextManager:SetStoredString("init_slot_variables.item", item)
    contextManager:SetStoredNumber("init_slot_variables.cost", cost)
	contextManager:SetStoredBool("init_slot_variables.hasInitialized", true)
end
