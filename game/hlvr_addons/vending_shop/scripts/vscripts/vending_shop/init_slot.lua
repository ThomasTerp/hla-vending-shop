
function LinkSlot(trigger)
	local variables = EntityGroup[1]:GetPrivateScriptScope()
	
	trigger.activator:GetPrivateScriptScope().LinkSlot(variables.index, variables.item, variables.cost, EntityGroup[2], EntityGroup[3])
end
