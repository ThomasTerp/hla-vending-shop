local util = require("vending_shop/util")

--Class for currency displays
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

--Activate the currency display, showing the numbers
function CurrencyDisplay:Activate()
	self._isActive = true
	self._textEntity:SetMessage(self:GetMessage())
end

--Deactivate the currency display, hiding the numbers
function CurrencyDisplay:Deactivate()
	self._isActive = false
	self._textEntity:SetMessage(self:GetMessage())
end

--Is the currency display active?
function CurrencyDisplay:IsActive()
	return self._isActive
end

--Set amount to be displayed
function CurrencyDisplay:SetAmount(amount)
	self._amount = util.Clamp(amount, self.minimum, self.maximum)
	self._textEntity:SetMessage(self:GetMessage())
end

--Add amount to be displayed
function CurrencyDisplay:AddAmount(amount)
	self:SetAmount(self:GetAmount() + amount)
end

--Get amount that is displayed
function CurrencyDisplay:GetAmount()
	return self._amount
end

--Get amount that is displayed as a formatted text
function CurrencyDisplay:GetFormattedAmount()
	return string.format("%02d", self:GetAmount())
end

--Get message string that is used to display
function CurrencyDisplay:GetMessage()
	return self:IsActive() and self:GetFormattedAmount() or "--"
end

return CurrencyDisplay
