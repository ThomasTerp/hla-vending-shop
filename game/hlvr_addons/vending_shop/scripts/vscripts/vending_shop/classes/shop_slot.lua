_G.VendingShop = _G.VendingShop or {}
VendingShop._shopSlotMetatable = VendingShop._shopSlotMetatable or {}
VendingShop._shopSlotMetatable.__index = {
	--Get target name for the slot drawer func_physbox
	GetSlotDrawerName = function(self)
		return self.shop:GetRealEntityName("slot" .. self.slotIndex .. "_drawer")
	end,
	
	--Get target name for the slot phys_slideconstraint
	GetSlotSlideName = function(self)
		return  self.shop:GetRealEntityName("slot" .. self.slotIndex .. "_slide")
	end,
	
	--Get target name for the currency point_worldtext
	GetSlotCurrencyTextName = function(self)
		return  self.shop:GetRealEntityName("slot" .. self.slotIndex .. "_currency_text")
	end,
	
	--Close and lock
	Lock = function(self)
		DoEntFire(self:GetSlotSlideName(), "SetOffset", "0", 0, nil, nil)
		
		self._isUnlocked = false
	end,
	
	--Unlock
	Unlock = function(self)
		DoEntFire(self:GetSlotSlideName(), "TurnMotorOn", "", 0, nil, nil)
		
		self._isUnlocked = true
	end,
	
	--Set text for the currency point_worldtext
	SetCurrencyText = function(self, currency)
		DoEntFire(self:GetSlotCurrencyTextName(), "SetMessage", tostring(currency), 0, nil, nil)
	end,
	
	--Set cost
	SetCost = function(self, currency)
		self._cost = currency
		
		self:SetCurrencyText(self:FormatCurrency(currency))
	end,
	
	--Get cost
	GetCost = function(self)
		return self._cost
	end,
	
	--Set bought state
	SetBought = function(self, isBought)
		self._isBought = isBought
		
		if isBought then
			self:SetCurrencyText("--")
		else
			self:SetCurrencyText(self:FormatCurrency(self:GetCost()))
		end
	end,
	
	--Is bought?
	IsBought = function(self)
		return self._isBought
	end,
	
	--Is unlocked?
	IsUnlocked = function(self)
		return self._isUnlocked
	end,
	
	--Format currency into a number with leading zeros and clamp it between 0 to 99
	FormatCurrency = function(self, currency)
		return string.format("%02d", VendingShop.Clamp(currency, 0, 99))
	end,
	
	--Get position of the drawer func_physbox
	GetDrawerPosition = function(self)
		return Entities:FindByName(nil, self:GetSlotDrawerName()):GetAbsOrigin()
	end,
	
	--Get the default position of the drawer func_physbox
	GetDefaultDrawerPosition = function(self)
		return self._defaultDrawerPosition
	end,
	
	--Retrieve the default position from the drawer func_physbox
	--This should be called when the map loads
	_RetrieveDefaultDrawerPosition = function(self)
		self._defaultDrawerPosition = self:GetDrawerPosition()
	end
}

VendingShop._shopSlotMetatable.__tostring = function(self)
	return "[ShopSlot: " .. self.shop.name .. " (slot " .. self.slotIndex .. ")]"
end

--Creates an instance of an shopSlot
--Example: VendingShop.ShopSlot(myShop, 1, myShopItem)
function VendingShop.ShopSlot(shop, slotIndex, shopItem)
    local slot = setmetatable({
        shop = shop,
        slotIndex = slotIndex,
        shopItem = shopItem,
		_isUnlocked = false,
		_isBought = false,
		_cost = 0,
		_defaultDrawerPosition = nil,
    }, VendingShop._shopSlotMetatable)
	
	slot:_RetrieveDefaultDrawerPosition()
	slot:Lock()
	slot:SetCost(shopItem and shopItem.cost or slot:GetCost())
	
	return slot
end
