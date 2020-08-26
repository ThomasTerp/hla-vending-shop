if IsClient() then
	return
end

local VendingShop = require("vending_shop/classes/vending_shop")
local Slot = require("vending_shop/classes/slot")
local CurrencyDisplay = require("vending_shop/classes/currency_display")
local util = require("vending_shop/util")
local ContextManager = require("vending_shop/classes/context_manager")
local EntityGroupManager = require("vending_shop/classes/entity_group_manager")

local player
local variables
local linksReceived = 0
local isLinkRelayTriggered = false
local slotLinks = {}
local currencyDisplayLinks = {}
local contextManager = ContextManager(thisEntity)
local entityGroupManager

thisEntity:SetThink(function()
	local hasInitialized = contextManager:GetStoredBool("init_vending_shop.hasInitialized")
	
	if not player then
		player = Entities:GetLocalPlayer()
	end
	
	if player and (EntityGroup or hasInitialized) then
		if not entityGroupManager then
			entityGroupManager = EntityGroupManager(thisEntity)
		end
		
		if not variables then
			variables = entityGroupManager:GetEntity(1):GetPrivateScriptScope()
		end
		
		if not isLinkRelayTriggered then
			entityGroupManager:GetEntity(2):Trigger(thisEntity, thisEntity)
			
			isLinkRelayTriggered = true
		end
		
		if variables and linksReceived == variables.totalLinks then
			local slots = {}
			local slotConfig = {}
			
			for index, slotLink in ipairs(slotLinks) do
				slots[index] = Slot(thisEntity, slotLink.drawerEntity, slotLink.slideEntity, CurrencyDisplay(currencyDisplayLinks[index].currencyTextEntity))
				slotConfig[index] = {
					item = slotLink.item,
					cost = slotLink.cost
				}
			end
			
			vendingShop = VendingShop(
				thisEntity,
				{
					refundTriggerEntity = entityGroupManager:GetEntity(3),
					currencyAddedSoundEntity = entityGroupManager:GetEntity(5),
					slotBoughtSoundEntity = entityGroupManager:GetEntity(6),
					refundSoundEntity = entityGroupManager:GetEntity(7),
					largeRefundTargetEntity = entityGroupManager:GetEntity(8),
					prefabRelays1 = entityGroupManager:GetEntity(14),
					prefabRelays2 = entityGroupManager:GetEntity(15)
				},
				{
					entityGroupManager:GetEntity(9),
					entityGroupManager:GetEntity(10),
					entityGroupManager:GetEntity(11),
					entityGroupManager:GetEntity(12),
					entityGroupManager:GetEntity(13)
				},
				{
					startingCurrencyAmount = variables.startingCurrencyAmount,
					slotConfig = slotConfig,
					itemChances = util.StringDataToTable(variables.itemChances),
					itemCosts = util.StringDataToTable(variables.itemCosts)
				},
				CurrencyDisplay(currencyDisplayLinks[variables.refundCurrencyDisplayIndex].currencyTextEntity),
				slots
			)
			
			if variables.startActive then
				vendingShop:Activate()
			end
			
			contextManager:SetStoredBool("init_vending_shop.hasInitialized", true)
			
			return false
		end
	end
	
	return true
end, "init_vending_shop.ReadyCheck", 0)

function Precache(context)
	context:AddResource("models/weapons/vr_grenade/grenade.vmdl")
	context:AddResource("models/weapons/vr_grenade/grenade_handle.vmdl")
	context:AddResource("models/weapons/vr_ipistol_capsule/vr_ipistol_capsule.vmdl")
	context:AddResource("models/weapons/vr_alyxgun/vr_alyxgun_clip.vmdl")
	context:AddResource("models/weapons/vr_alyxgun/pistol_clip_holder.vmdl")
	context:AddResource("models/weapons/vr_xen_grenade/vr_xen_grenade.vmdl")
	context:AddResource("models/weapons/vr_alyxhealth/vr_health_pen_capsule.vmdl")
	context:AddResource("models/weapons/vr_alyxhealth/vr_health_pen.vmdl")
	context:AddResource("models/weapons/vr_ammo/shotgun_shell_ammo_box.vmdl")
	context:AddResource("models/weapons/vr_ipistol/capsule_power_cell.vmdl")
end

function LinkSlot(index, item, cost, drawerEntity, slideEntity)
	slotLinks[index] = {
		item = item,
		cost = cost,
		drawerEntity = drawerEntity,
		slideEntity = slideEntity
	}
	
	linksReceived = linksReceived + 1
end

function LinkCurrencyDisplay(index, currencyTextEntity)
	currencyDisplayLinks[index] = {
		currencyTextEntity = currencyTextEntity
	}
	
	linksReceived = linksReceived + 1
end

function OnActivate()
	if vendingShop then
		vendingShop:Activate()
	end
end

function OnDeactivate()
	if vendingShop then
		vendingShop:Deactivate()
	end
end

function OnRefundTrigger(...)
	if vendingShop then
		vendingShop:OnRefundTrigger(...)
	end
end

function OnSlotOpenTrigger(...)
	if vendingShop then
		vendingShop:OnSlotOpenTrigger(...)
	end
end

function OnRefundButtonPressed(...)
	if vendingShop then
		vendingShop:OnRefundButtonPressed(...)
	end
end

function OnInteriorTriggerStartTouch(...)
	if vendingShop then
		vendingShop:OnInteriorTriggerStartTouch(...)
	end
end

function OnInteriorTriggerEndTouch(...)
	if vendingShop then
		vendingShop:OnInteriorTriggerEndTouch(...)
	end
end
