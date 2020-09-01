local ContextManager = require("vending_shop/classes/context_manager")
local util = require("vending_shop/util")

--Class for vending shop slots
local Slot = class(
	{
		constructor = function(self, scriptEntity, drawerEntity, slideEntity, currencyDisplay)
			self._scriptEntity = scriptEntity
			self._drawerEntity = drawerEntity
			self._slideEntity = slideEntity
			self._currencyDisplay = currencyDisplay
			self._contextManager = ContextManager(self:GetDrawerEntity())
			self._isActive = self._contextManager:GetStoredBool("Slot._isActive") or false
			self:SetCost(self._contextManager:GetStoredNumber("Slot._cost") or 0)
			
			if self:IsActive() then
				self._currencyDisplay:Activate()
			end
			
			getmetatable(self).__tostring = function()
				return "[" .. self.__class__name .. ": " .. tostring(self:GetDrawerEntity()) .. "]"
			end
		end
	},
	{
		__class__name = "Slot"
	},
	nil
)

--Get the physical drawer entity
function Slot:GetDrawerEntity()
	return self._drawerEntity
end

--Activate the slot, showing numbers and making it possible to buy
function Slot:Activate()
	self._isActive = true
	self._contextManager:SetStoredBool("Slot._isActive", true)
	self._currencyDisplay:Activate()
end

--Deactivate the slot, hiding the numbers and making it impossible to buy
function Slot:Deactivate()
	self._isActive = false
	self._contextManager:SetStoredBool("Slot._isActive", false)
	self._currencyDisplay:Deactivate()
end

--Is the slot active?
function Slot:IsActive()
	return self._isActive
end

--Close and lock
function Slot:Lock()
	EntFireByHandle(self._slideEntity, self._slideEntity, "SetOffset", "0")
	self._isLocked = true
end

--Unlock
function Slot:Unlock()
	EntFireByHandle(self._slideEntity, self._slideEntity, "TurnMotorOn")
	self._isLocked = false
end

--Is unlocked?
function Slot:IsLocked()
	return self._isLocked
end

--Set cost
function Slot:SetCost(cost)
	self._cost = cost
	self._contextManager:SetStoredNumber("Slot._cost", cost)
	self._currencyDisplay:SetAmount(cost)
end

--Get cost
function Slot:GetCost()
	return self._cost
end

--Set bought state
function Slot:SetBought(isBought)
	self._isBought = isBought
	
	if isBought then
		self:Deactivate()
	end
end

--Is bought?
function Slot:IsBought()
	return self._isBought
end

return Slot
