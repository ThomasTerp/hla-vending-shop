local ContextManager = require("vending_shop/classes/context_manager")
local util = require("vending_shop/util")

local VendingShop = class(
	{
		constructor = function(self, scriptEntity, largeRefundTarget, smallRefundTargets, refundTriggerEntity, slotOpenTrigger, itemRemoveEntity, currencyAddedSoundEntity, slotBoughtSoundEntity, refundSoundEntity, currencyDisplay, slots)
			self.smallCurrency = {
				classname = "item_hlvr_crafting_currency_small",
				amount = 1,
				refundSpeed = 0.2
			}
			self.largeCurrency = {
				classname = "item_hlvr_crafting_currency_large",
				amount = 5,
				refundSpeed = 0.4
			}
			self.items = {
				["item_hlvr_clip_energygun"] = {
					cost = 3,
					offsetPosition = Vector(-0.8, -3.45, -3.7054),
					offsetAngle = QAngle(-70.8897, 179.864, 177.606)
				};
				["item_hlvr_clip_energygun_multiple"] = {
					cost = 10,
					offsetPosition = Vector(-0.61, -3.36, -1.6149),
					offsetAngle = QAngle(-89.8865, 86.6341, -87.4212)
				};
				["item_hlvr_clip_shotgun_multiple"] = {
					cost = 6,
					offsetPosition = Vector(-0.41, -3.56, -3.2453),
					offsetAngle = QAngle(0.0013459, 358.914, 0.0123638)
				};
				["item_hlvr_clip_rapidfire"] = {
					cost = 8,
					offsetPosition = Vector(0.7, -4.22, -1.7546),
					offsetAngle = QAngle(-3.18289, 6.42088, -92.4409)
				};
				["item_hlvr_grenade_frag"] = {
					cost = 5,
					offsetPosition = Vector(-0.2, -3.6, -1.4992),
					offsetAngle = QAngle(-8.75917, 358.956, 0.825748)
				};
				["item_hlvr_grenade_xen"] = {
					cost = 5,
					offsetPosition = Vector(-0.2, -3.6, -1.4992),
					offsetAngle = QAngle(0, 0, 0)
				};
				["item_healthvial"] = {
					cost = 5,
					offsetPosition = Vector(-4.02, -2.21, -2.9019),
					offsetAngle = QAngle(36.9168, 268.969, -56.3617)
				};
			}
			self.itemChanceTable = {
				{
					value = "item_hlvr_clip_energygun",
					chance = 80
				};
				{
					value = "item_hlvr_clip_energygun_multiple",
					chance = 20
				};
				{
					value = "item_hlvr_clip_shotgun_multiple",
					chance = 100
				};
				{
					value = "item_hlvr_clip_rapidfire",
					chance = 100
				};
				{
					value = "item_hlvr_grenade_frag",
					chance = 50
				};
				{
					value = "item_hlvr_grenade_xen",
					chance = 50
				};
				{
					value = "item_healthvial",
					chance = 100
				};
			}
			
			self._scriptEntity = scriptEntity
			self._largeRefundTarget = largeRefundTarget
			self._smallRefundTargets = smallRefundTargets
			self._refundTriggerEntity = refundTriggerEntity
			self._itemRemoveEntity = itemRemoveEntity
			self._currencyAddedSoundEntity = currencyAddedSoundEntity
			self._slotBoughtSoundEntity = slotBoughtSoundEntity
			self._refundSoundEntity = refundSoundEntity
			self._slots = slots
			self._currencyDisplay = currencyDisplay
			
			self._active = false
			self._currency = 0
			self._contextManager = ContextManager(self:GetScriptEntity())
			
			getmetatable(self).__tostring = function()
				return "[" .. self.__class__name .. ": " .. tostring(self:GetScriptEntity()) .. "]"
			end
		end
	},
	{
		__class__name = "VendingShop"
	},
	nil
)

function VendingShop:GetScriptEntity()
	return self._scriptEntity
end

function VendingShop:GetSlot(index)
	return self._slots[index]
end

function VendingShop:GetCurrencyDisplay()
	return self._currencyDisplay
end

function VendingShop:GetContextManager()
	return self._contextManager
end

--Activate the vending shop
function VendingShop:Activate()
	self._isActive = true
	
	self._currencyDisplay:Activate()
	
	for _, slot in ipairs(self:GetSlots()) do
		slot:Activate()
		self:RefreshSlot(slot)
	end
end

--Deactivate the vending shop
function VendingShop:Deactivate()
	self._isActive = false
	
	self._currencyDisplay:Deactivate()
	
	for _, slot in ipairs(self:GetSlots()) do
		slot:Deactivate()
		self:RefreshSlot(slot)
	end
end

--Is the shop active?
function VendingShop:IsActive()
	return self._isActive
end

--Spawn items depending on the settings
function VendingShop:SpawnItems()
	for _, slot in ipairs(self:GetSlots()) do
		local classname = util.TableRandomChance(self.itemChanceTable)
		local item = self.items[classname]
		local slotDrawerEntity = slot:GetDrawerEntity()
		
		SpawnEntityFromTableSynchronous(classname, {
			origin = slotDrawerEntity:TransformPointEntityToWorld(item.offsetPosition),
			angles = RotateOrientation(slotDrawerEntity:GetAngles(), item.offsetAngle)
		})
		
		slot:SetCost(item.cost)
		self:RefreshSlot(slot)
	end
end

--Play the slot bought point_soundevent
function VendingShop:PlayCurrencyAddedSound()
	EntFireByHandle(self:GetScriptEntity(), self._currencyAddedSoundEntity, "StartSound")
end

--Play the slot bought point_soundevent
function VendingShop:PlaySlotBoughtSound()
	EntFireByHandle(self:GetScriptEntity(), self._slotBoughtSoundEntity, "StartSound")
end

--Play the refund point_soundevent
function VendingShop:PlayRefundSound()
	EntFireByHandle(self:GetScriptEntity(), self._refundSoundEntity, "StartSound")
end

function VendingShop:RefreshSlot(slot)
	if slot:IsActive() then
		if self:CanAfford(slot:GetCost()) then
			if slot:IsLocked() then
				slot:Unlock()
			end
		elseif not slot:IsBought() then
			if not slot:IsLocked() then
				slot:Lock()
			end
		end
	end
end

function VendingShop:RefreshSlots()
	for _, slot in ipairs(self:GetSlots()) do
		self:RefreshSlot(slot)
	end
end

--Set currency and unlock/lock slots if they can/can't be afforded
function VendingShop:SetCurrency(currency)
	self._currency = currency
	
	self:GetCurrencyDisplay():SetAmount(currency)
	self:RefreshSlots()
	
	if currency > self:GetCurrencyDisplay().maximum then
		self:Refund()
	end
end

--Add currency and unlock/lock slots if they can/can't be afforded
function VendingShop:AddCurrency(currency)
	self:SetCurrency(self:GetCurrency() + currency)
end

--Get currency
function VendingShop:GetCurrency()
	return self._currency
end

--Can the a cost be afforded?
function VendingShop:CanAfford(cost)
	return self:GetCurrency() >= cost
end

--Get a slot by index
function VendingShop:GetSlot(slotIndex)
	return self._slots[slotIndex]
end

--Get all slots
function VendingShop:GetSlots()
	return self._slots
end

--Buy a slot
function VendingShop:BuySlot(slot)
	slot:SetBought(true)
	self:AddCurrency(-slot:GetCost())
	self:PlaySlotBoughtSound()
end

--Refund all resin
function VendingShop:Refund()
	if not self:IsRefunding() and self:GetCurrency() > 0 then
		self._isRefunding = true
		
		self:GetScriptEntity():SetThink(function()
			local currency = self:GetCurrency()
			
			if currency >= self.largeCurrency.amount then
				SpawnEntityFromTableSynchronous(self.largeCurrency.classname, {
					origin = self._largeRefundTarget:GetAbsOrigin(),
					angles = RotateOrientation(self._largeRefundTarget:GetAngles(), QAngle(0, math.random(0, 359), 0))
				})
				
				self:AddCurrency(-self.largeCurrency.amount)
				self:PlayRefundSound()
				
				return self.largeCurrency.refundSpeed
			elseif currency > 0 then
				self:AddCurrency(-self.smallCurrency.amount)
				self:PlayRefundSound()
				
				local spawnTarget = self._smallRefundTargets[math.random(#self._smallRefundTargets)]
				
				SpawnEntityFromTableSynchronous(self.smallCurrency.classname, {
					origin = spawnTarget:GetAbsOrigin(),
					angles = RotateOrientation(spawnTarget:GetAngles(), QAngle(0, math.random(0, 359), 0))
				})
				
				return self.smallCurrency.refundSpeed
			end
			
			--This part will only be reached when currency is 0
			self._isRefunding = false
		end, "VendingShop.Refund", 0)
	end
end

--Is refunding?
function VendingShop:IsRefunding()
	return self._isRefunding
end

function VendingShop:OnRefundTrigger(trigger)
	if self:IsActive() then
		local classname = trigger.activator:GetClassname()
		
		if classname == self.largeCurrency.classname then
			trigger.activator:RemoveSelf()
			self:AddCurrency(self.largeCurrency.amount)
			self:PlayCurrencyAddedSound()
		elseif classname == self.smallCurrency.classname then
			trigger.activator:RemoveSelf()
			self:AddCurrency(self.smallCurrency.amount)
			self:PlayCurrencyAddedSound()
		end
	end
end

function VendingShop:OnSlotOpenTrigger(trigger)
	if self:IsActive() then
		for _, slot in ipairs(self:GetSlots()) do
			if trigger.activator == slot:GetDrawerEntity() and slot:IsActive() and not slot:IsLocked() and not slot:IsBought() then
				self:BuySlot(slot)
				
				break
			end
		end
	end
end

function VendingShop:OnRefundButtonPressed(trigger)
	if self:IsActive() then
		self:Refund()
	end
end

return VendingShop
