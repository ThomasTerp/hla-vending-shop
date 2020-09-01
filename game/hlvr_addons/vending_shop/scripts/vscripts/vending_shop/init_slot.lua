if IsClient() then
	return
end

local EntityGroupManager = require("vending_shop/classes/entity_group_manager")

function LinkSlot(trigger)
	local entityGroupManager = EntityGroupManager(thisEntity)
	local variables = entityGroupManager:GetEntity(1):GetPrivateScriptScope()
	
	trigger.activator:GetPrivateScriptScope().LinkSlot(variables.index, variables.item, variables.cost, entityGroupManager:GetEntity(2), entityGroupManager:GetEntity(3))
end
