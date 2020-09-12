if IsClient() then
	return
end

local ContextManager = require("vending_shop/classes/context_manager")
local contextManager = ContextManager(thisEntity)

if contextManager:GetStoredBool("init_vending_shop_variables.hasInitialized") then
	totalLinks = contextManager:GetStoredNumber("init_vending_shop_variables.totalLinks")
    refundCurrencyDisplayIndex = contextManager:GetStoredNumber("init_vending_shop_variables.refundCurrencyDisplayIndex")
    startActive = contextManager:GetStoredBool("init_vending_shop_variables.startActive")
    startingCurrencyAmount = contextManager:GetStoredNumber("init_vending_shop_variables.startingCurrencyAmount")
    itemChances = contextManager:GetStoredString("init_vending_shop_variables.itemChances")
    itemCosts = contextManager:GetStoredString("init_vending_shop_variables.itemCosts")
    isTutorialDisabled = contextManager:GetStoredBool("init_vending_shop_variables.isTutorialDisabled")
end

function Spawn(spawnKeys)
	totalLinks = tonumber(spawnKeys:GetValue("Case01"))
    refundCurrencyDisplayIndex = tonumber(spawnKeys:GetValue("Case02"))
    startActive = spawnKeys:GetValue("Case03") ~= "0" and true or false
    startingCurrencyAmount = tonumber(spawnKeys:GetValue("Case04")) or 0
    itemChances = spawnKeys:GetValue("Case05")
    itemCosts = spawnKeys:GetValue("Case06")
    isTutorialDisabled = spawnKeys:GetValue("Case07") ~= "0" and true or false
	
	contextManager:SetStoredNumber("init_vending_shop_variables.totalLinks", totalLinks)
    contextManager:SetStoredNumber("init_vending_shop_variables.refundCurrencyDisplayIndex", refundCurrencyDisplayIndex)
    contextManager:SetStoredBool("init_vending_shop_variables.startActive", startActive)
    contextManager:SetStoredNumber("init_vending_shop_variables.startingCurrencyAmount", startingCurrencyAmount)
    contextManager:SetStoredString("init_vending_shop_variables.itemChances", itemChances)
    contextManager:SetStoredString("init_vending_shop_variables.itemCosts", itemCosts)
    contextManager:SetStoredBool("init_vending_shop_variables.isTutorialDisabled", isTutorialDisabled)
	contextManager:SetStoredBool("init_vending_shop_variables.hasInitialized", true)
end
