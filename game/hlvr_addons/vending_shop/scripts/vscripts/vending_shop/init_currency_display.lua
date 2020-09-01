if IsClient() then
	return
end

local EntityGroupManager = require("vending_shop/classes/entity_group_manager")

function LinkCurrencyDisplay(trigger)
	local entityGroupManager = EntityGroupManager(thisEntity)
	
	trigger.activator:GetPrivateScriptScope().LinkCurrencyDisplay(entityGroupManager:GetEntity(1):GetPrivateScriptScope().index, entityGroupManager:GetEntity(2))
end
