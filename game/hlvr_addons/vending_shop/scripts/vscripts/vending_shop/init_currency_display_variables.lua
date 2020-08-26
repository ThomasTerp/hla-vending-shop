local ContextManager = require("vending_shop/classes/context_manager")
local contextManager = ContextManager(thisEntity)

if contextManager:GetStoredBool("init_currency_display_variables.hasInitialized") then
	index = contextManager:GetStoredNumber("init_currency_display_variables.index")
end

function Spawn(spawnKeys)
	index = tonumber(spawnKeys:GetValue("Case01"))
	
	contextManager:SetStoredNumber("init_currency_display_variables.index", index)
	contextManager:SetStoredBool("init_currency_display_variables.hasInitialized", true)
end
