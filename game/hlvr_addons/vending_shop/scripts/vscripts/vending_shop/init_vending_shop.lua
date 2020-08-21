if IsClient() then
	return
end

local VendingShop = require("vending_shop/classes/vending_shop")
local Slot = require("vending_shop/classes/slot")
local CurrencyDisplay = require("vending_shop/classes/currency_display")
local util = require("vending_shop/util")

local player
local variables
local linksReceived = 0
local isLinkRelayTriggered = false
local slotLinks = {}
local currencyDisplayLinks = {}

thisEntity:SetThink(function()
	if not player then
		player = Entities:GetLocalPlayer()
	end
	
	if player and EntityGroup then
		if not variables then
			variables = EntityGroup[1]:GetPrivateScriptScope()
		end
		
		if not isLinkRelayTriggered then
			EntityGroup[2]:Trigger(thisEntity, thisEntity)
			
			isLinkRelayTriggered = true
		end
		
		if variables and linksReceived == variables.totalLinks then
			local slots = {}
			local slotConfig = {}
			
			for index, slotLink in ipairs(slotLinks) do
				slots[index] = Slot(thisEntity, slotLink.drawerEntity, slotLink.slideEntity, CurrencyDisplay(currencyDisplayLinks[index].currencyText))
				slotConfig[index] = {
					item = slotLink.item,
					cost = slotLink.cost
				}
			end
			
			vendingShop = VendingShop(
				thisEntity,
				{
					refundTriggerEntity = EntityGroup[3],
					itemRemoveEntity = EntityGroup[4],
					currencyAddedSoundEntity = EntityGroup[5],
					slotBoughtSoundEntity = EntityGroup[6],
					refundSoundEntity = EntityGroup[7],
					largeRefundTargetEntity = EntityGroup[8]
				},
				{
					EntityGroup[9],
					EntityGroup[10],
					EntityGroup[11],
					EntityGroup[12],
					EntityGroup[13]
				},
				{
					startingCurrencyAmount = variables.startingCurrencyAmount,
					slotConfig = slotConfig
				},
				CurrencyDisplay(currencyDisplayLinks[variables.refundCurrencyDisplayIndex].currencyText),
				slots
			)
			
			if variables.startActive then
				vendingShop:Activate()
				vendingShop:SpawnItems()
			end
			
			return false
		end
	end
	
	return true
end, "ReadyCheck", 0)

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

function LinkCurrencyDisplay(index, currencyText)
	currencyDisplayLinks[index] = {
		currencyText = currencyText
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

function OnRefundTrigger(trigger)
	if vendingShop then
		vendingShop:OnRefundTrigger(trigger)
	end
end

function OnSlotOpenTrigger(trigger)
	if vendingShop then
		vendingShop:OnSlotOpenTrigger(trigger)
	end
end

function OnRefundButtonPressed(trigger)
	if vendingShop then
		vendingShop:OnRefundButtonPressed(trigger)
	end
end
