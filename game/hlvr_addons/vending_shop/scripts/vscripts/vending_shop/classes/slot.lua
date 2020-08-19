local util = require("vending_shop/util")

local Slot = class(
	{
		constructor = function(self, scriptEntity, drawerEntity, slideEntity, currencyDisplay)
			self._scriptEntity = scriptEntity
			self._drawerEntity = drawerEntity
			self._slideEntity = slideEntity
			self._currencyDisplay = currencyDisplay
			
			self._isActive = false
			self:SetCost(0)
			
			getmetatable(self).__tostring = function()
				return "[" .. self.__class__name .. ": " .. tostring(self:GetScriptEntity()) .. "]"
			end
		end
	},
	{
		__class__name = "Slot"
	},
	nil
)

function Slot:GetScriptEntity()
	return self._scriptEntity
end

function Slot:GetDrawerEntity()
	return self._drawerEntity
end

function Slot:Activate()
	self._isActive = true
	self._currencyDisplay:Activate()
end

function Slot:Deactivate()
	self._isActive = false
	self._currencyDisplay:Deactivate()
end

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
