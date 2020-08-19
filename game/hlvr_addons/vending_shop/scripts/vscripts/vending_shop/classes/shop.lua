require("vending_shop/classes/shop_slot")
require("vending_shop/classes/shop_item")
require("vending_shop/util")

_G.VendingShop = _G.VendingShop or {}
VendingShop._shopMetatable = VendingShop._shopMetatable or {}
VendingShop._shopMetatable.__index = {
	--Classname for small currency
	smallCurrencyClassname = "item_hlvr_crafting_currency_small",
	--Classname for large currency
	largeCurrencyClassname = "item_hlvr_crafting_currency_large",
	--How big a small currency is
	--Refunding only works if this value is 1
	smallCurrencySize = 1,
	--How big a large currency is
	largeCurrencySize = 5,
	--How fast small currency gets refunded
	smallRefundSpeed = 0.2,
	--How fast large currency gets refunded
	largeRefundSpeed = 0.4,
	--Chance table for possible shop items
	itemChanceTable = {
		{
			value = VendingShop.ShopItem("item_hlvr_clip_energygun", 3, Vector(-0.8, -3.45, -3.7054), QAngle(-70.8897, 179.864, 177.606)),
			chance = 80
		};
		{
			value = VendingShop.ShopItem("item_hlvr_clip_energygun_multiple", 10, Vector(-0.61, -3.36, -1.6149), QAngle(-89.8865, 86.6341, -87.4212)),
			chance = 20
		};
		{
			value = VendingShop.ShopItem("item_hlvr_clip_shotgun_multiple", 6, Vector(-0.41, -3.56, -3.2453), QAngle(0.0013459, 358.914, 0.0123638)),
			chance = 100
		};
		{
			value = VendingShop.ShopItem("item_hlvr_clip_rapidfire", 8, Vector(0.7, -4.22, -1.7546), QAngle(-3.18289, 6.42088, -92.4409)),
			chance = 100
		};
		{
			value = VendingShop.ShopItem("item_hlvr_grenade_frag", 5, Vector(-0.2, -3.6, -1.4992), QAngle(-8.75917, 358.956, 0.825748)),
			chance = 50
		};
		{
			value = VendingShop.ShopItem("item_hlvr_grenade_xen", 5, Vector(-0.2, -3.6, -1.4992), QAngle(0, 0, 0)),
			chance = 50
		};
		{
			value = VendingShop.ShopItem("item_healthvial", 5, Vector(-4.02, -2.21, -2.9019), QAngle(36.9168, 268.969, -56.3617)),
			chance = 100
		};
	},
	
	GetRealEntityName = function(self, name)
		return self.entities[name]
	end,
	
	--Get real name for the shop item trigger_remove
	GetShopItemRemoveName = function(self)
		return  self:GetRealEntityName("shopitem_remove")
	end,
	
	--Get real name for the currency point_worldtext
	GetCurrencyTextName = function(self)
		return  self:GetRealEntityName("currency_text")
	end,
	
	--Get real name for the slot bought point_soundevent
	GetSlotBoughtSoundName = function(self)
		return  self:GetRealEntityName("slot_bought_sound")
	end,
	
	--Get target naem for the refund point_soundevent
	GetRefundSoundName = function(self)
		return  self:GetRealEntityName("refund_sound")
	end,
	
	--Get real name for the refund small info_target
	GetRefundSmallName = function(self, index)
		return  self:GetRealEntityName("refund_small_" .. index)
	end,
	
	--Get real name for the refund large info_target
	GetRefundLargeName = function(self)
		return  self:GetRealEntityName("refund_large")
	end,
	
	--Enable the shop item trigger_remove
	EnableShopItemRemove = function(self)
		DoEntFire(self:GetShopItemRemoveName(), "Enable", "", 0, nil, nil)
	end,
	
	--Disable the shop item trigger_remove
	DisableShopItemRemove = function(self)
		DoEntFire(self:GetShopItemRemoveName(), "Disable", "", 0, nil, nil)
	end,
	
	--Set text for the currency point_worldtext
	SetCurrencyText = function(self, currency)
		DoEntFire(self:GetCurrencyTextName(), "SetMessage", tostring(currency), 0, nil, nil)
	end,
	
	--Play the slot bought point_soundevent
	PlaySlotBoughtSound = function(self)
		DoEntFire(self:GetSlotBoughtSoundName(), "StartSound", "", 0, nil, nil)
	end,
	
	--Play the refund point_soundevent
	PlayRefundSound = function(self)
		DoEntFire(self:GetRefundSoundName(), "StartSound", "", 0, nil, nil)
	end,
	
	--Reset the vending shop by removing all items and moving drawers back
	--The callback will be called when it's fully reset
	Reset = function(self, callback)
		self:ForEachSlot(function(slotIndex, slot)
			if slot then
				slot:Lock()
				slot:SetCost(0)
				slot:SetBought(false)
				
				slot.shopItem = nil
			else
				slot = VendingShop.ShopSlot(self, slotIndex, nil)
				self:SetSlot(slotIndex, slot)
			end
		end)
		
		self:SetActive(false)
		self:SetCurrency(0)
		self:EnableShopItemRemove()
		
		--Small delay so the trigger_remove has time to remove the items
		VendingShop.GetPlayer():SetThink(function()
			self:DisableShopItemRemove()
		end, self.name .. "_reset_delay_1", 0.1)
		
		if callback then
			--Longer delay so the drawers has time to fully close
			VendingShop.GetPlayer():SetThink(function()
				callback()
			end, self.name .. "_reset_delay_2", 0.5)
		end
	end,
	
	--Set a slot by index
	SetSlot = function(self, slotIndex, slot)
		self._slots[slotIndex] = slot
	end,
	
	--Get a slot by index
	GetSlot = function(self, slotIndex)
		return self._slots[slotIndex]
	end,
	
	--Get all slots
	GetSlots = function(self)
		return self._slots
	end,
	
	--Call the callback for each slot
	--The callback has arguments: slotIndex, slot
	ForEachSlot = function(self, callback)
		for slotIndex = 1, self.slotCount do
			callback(slotIndex, self:GetSlot(slotIndex))
		end
	end,
	
	--Spawn random items based on itemChanceTable
	RandomizeAndSpawnItems = function(self)
		self:ForEachSlot(function(slotIndex)
			local slot = self:GetSlot(slotIndex)
			slot.shopItem = VendingShop.RandomChanceTable(self.itemChanceTable)
			slot:SetCost(slot.shopItem.cost)
			
			local slotDrawer = Entities:FindByName(nil, slot:GetSlotDrawerName())
			
			SpawnEntityFromTableSynchronous(slot.shopItem.classname, {
				origin = slotDrawer:TransformPointEntityToWorld(slot.shopItem.offsetPosition),
				angles = RotateOrientation(slotDrawer:GetAngles(), slot.shopItem.offsetAngle)
			})
		end)
		
		self:SetActive(true)
	end,
	
	--Reset the shop first and then spawn the items
	ResetAndRandomizeAndSpawnItems = function(self)
		self:Reset(function()
			self:RandomizeAndSpawnItems()
		end)
	end,
	
	--Set currency and unlock/lock slots if they can/can't be afforded
	SetCurrency = function(self, currency)
		self._currency = currency
		
		self:SetCurrencyText(self:FormatCurrency(currency))
		
		self:ForEachSlot(function(slotIndex, slot)
			if slot.shopItem then
				if self:CanAfford(slot.shopItem.cost) then
					if not slot:IsUnlocked() then
						slot:Unlock()
					end
				elseif not slot:IsBought() then
					if slot:IsUnlocked() then
						slot:Lock()
					end
				end
			end
		end)
		
		if currency > 99 then
			self:Refund()
		end
	end,
	
	--Get currency
	GetCurrency = function(self)
		return self._currency
	end,
	
	--Add currency and unlock/lock slots if they can/can't be afforded
	AddCurrency = function(self, currency)
		self:SetCurrency(self:GetCurrency() + currency)
	end,
	
	--Can the player afford a cost?
	CanAfford = function(self, cost)
		return self:GetCurrency() >= cost
	end,
	
	--Format currency into a number with leading zeros and clamp it between 0 to 99
	FormatCurrency = function(self, currency)
		return string.format("%02d", VendingShop.Clamp(currency, 0, 99))
	end,
	
	--Set as active and start the main think function
	SetActive = function(self, isActive)
		self._isActive = isActive
		
		VendingShop.GetPlayer():SetThink(function()
			self:ForEachSlot(function(slotIndex, slot)
				if slot:IsUnlocked() and not slot:IsBought() and VendingShop.VectorDistance(slot:GetDefaultDrawerPosition(), slot:GetDrawerPosition()) > 1 then
					self:BuySlot(slot)
				end
			end)
			
			return self:IsActive()
		end, self.name .. "_active_think", 0)
	end,
	
	--Is the shop active?
	IsActive = function(self)
		return self._isActive
	end,
	
	--Buy the item of a slot
	BuySlot = function(self, slot)
		slot:SetBought(true)
		self:AddCurrency(-slot.shopItem.cost)
		self:PlaySlotBoughtSound()
	end,
	
	--Refund all resin
	Refund = function(self)
		if not self:IsRefunding() and self:GetCurrency() > 0 then
			self._isRefunding = true
			
			VendingShop.GetPlayer():SetThink(function()
				local currency = self:GetCurrency()
				
				if currency >= self.largeCurrencySize then
					local spawnTarget = Entities:FindByName(nil, self:GetRefundLargeName())
					
					SpawnEntityFromTableSynchronous(self.largeCurrencyClassname, {
						origin = spawnTarget:GetAbsOrigin(),
						angles = RotateOrientation(spawnTarget:GetAngles(), QAngle(0, math.random(0, 359), 0))
					})
					
					self:AddCurrency(-self.largeCurrencySize)
					self:PlayRefundSound()
					
					return self.largeRefundSpeed
				elseif currency > 0 then
					self:AddCurrency(-self.smallCurrencySize)
					self:PlayRefundSound()
					
					local spawnTarget = Entities:FindByName(nil, self:GetRefundSmallName(math.random(self.smallRefundCount)))
					
					SpawnEntityFromTableSynchronous(self.smallCurrencyClassname, {
						origin = spawnTarget:GetAbsOrigin(),
						angles = RotateOrientation(spawnTarget:GetAngles(), QAngle(0, math.random(0, 359), 0))
					})
					
					return self.smallRefundSpeed
				end
				
				--This part will only be reached when currency is 0
				self._isRefunding = false
			end, self.name .. "_refund", 0)
		end
	end,
	
	--Is refunding?
	IsRefunding = function(self)
		return self._isRefunding
	end
}

VendingShop._shopMetatable.__tostring = function(self)
	return "[Shop: " .. self.name .. "]"
end

--Creates an instance of a shop
--Example: VendingShop.Shop("shop_name")
function VendingShop.Shop(name, entities, slotCount, smallRefundCount, startDisabled)
    local shop = setmetatable({
		--Name of the shop
        name = name,
		--Entities inside the shop prefab
		entities = entities,
		--How many slots the shop has
		slotCount = slotCount,
		--How many info targets there is for small currency refunding
		smallRefundCount = smallRefundCount,
		_slots = {},
		_isActive = false,
		_isRefunding = false
    }, VendingShop._shopMetatable)
	
	if startDisabled then
		shop:Reset()
	else
		shop:ResetAndRandomizeAndSpawnItems()
	end
	
	return shop
end
