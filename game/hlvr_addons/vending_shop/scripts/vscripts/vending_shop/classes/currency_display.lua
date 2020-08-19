local util = require("vending_shop/util")

local CurrencyDisplay = class(
	{
		minimum = 0,
		maximum = 99,
		
		constructor = function(self, textEntity)
			self._textEntity = textEntity
			
			self._isActive = false
			self:SetAmount(0)
			
			getmetatable(self).__tostring = function()
				return "[" .. self.__class__name .. ": " .. self:GetMessage() .. "]"
			end
		end
	},
	{
		__class__name = "CurrencyDisplay"
	},
	nil
)

function CurrencyDisplay:Activate()
	self._isActive = true
	self._textEntity:SetMessage(self:GetMessage())
end

function CurrencyDisplay:Deactivate()
	self._isActive = false
	self._textEntity:SetMessage(self:GetMessage())
end

function CurrencyDisplay:IsActive()
	return self._isActive
end

function CurrencyDisplay:SetAmount(amount)
	self._amount = util.Clamp(amount, self.minimum, self.maximum)
	self._textEntity:SetMessage(self:GetMessage())
end

function CurrencyDisplay:AddAmount(amount)
	self:SetAmount(self:GetAmount() + amount)
end

function CurrencyDisplay:GetAmount()
	return self._amount
end

function CurrencyDisplay:GetFormattedAmount()
	return string.format("%02d", self:GetAmount())
end

function CurrencyDisplay:GetMessage()
	return self:IsActive() and self:GetFormattedAmount() or "--"
end

return CurrencyDisplay
