local ContextManager = require("vending_shop/classes/context_manager")
local util = require("vending_shop/util")

local VendingShop = class(
	{
		constructor = function(self, scriptEntity, entities, smallRefundTargetEntities, config, currencyDisplay, slots)
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
				item_hlvr_clip_energygun = {
					cost = config.itemCosts.item_hlvr_clip_energygun,
					offsetPosition = Vector(-0.8, -3.45, -3.7054),
					offsetAngle = QAngle(-70.8897, 179.864, 177.606)
				};
				item_hlvr_clip_energygun_multiple = {
					cost = config.itemCosts.item_hlvr_clip_energygun_multiple,
					offsetPosition = Vector(-0.61, -3.36, -1.6149),
					offsetAngle = QAngle(-89.8865, 86.6341, -87.4212)
				};
				item_hlvr_clip_shotgun_multiple = {
					cost = config.itemCosts.item_hlvr_clip_shotgun_multiple,
					offsetPosition = Vector(-0.41, -3.56, -3.2453),
					offsetAngle = QAngle(0.0013459, 358.914, 0.0123638)
				};
				item_hlvr_clip_rapidfire = {
					cost = config.itemCosts.item_hlvr_clip_rapidfire,
					offsetPosition = Vector(0.7, -4.22, -1.7546),
					offsetAngle = QAngle(-3.18289, 6.42088, -92.4409)
				};
				item_hlvr_grenade_frag = {
					cost = config.itemCosts.item_hlvr_grenade_frag,
					offsetPosition = Vector(-0.2, -3.6, -1.4992),
					offsetAngle = QAngle(-8.75917, 358.956, 0.825748)
				};
				item_hlvr_grenade_xen = {
					cost = config.itemCosts.item_hlvr_grenade_xen,
					offsetPosition = Vector(-0.2, -3.6, -1.4992),
					offsetAngle = QAngle(0, 0, 0)
				};
				item_healthvial = {
					cost = config.itemCosts.item_healthvial,
					offsetPosition = Vector(-4.02, -2.21, -2.9019),
					offsetAngle = QAngle(36.9168, 268.969, -56.3617)
				};
			}
			self.itemChanceTable = {
				{
					value = "item_hlvr_clip_energygun",
					chance = config.itemChances.item_hlvr_clip_energygun
				};
				{
					value = "item_hlvr_clip_energygun_multiple",
					chance = config.itemChances.item_hlvr_clip_energygun_multiple
				};
				{
					value = "item_hlvr_clip_shotgun_multiple",
					chance = config.itemChances.item_hlvr_clip_shotgun_multiple
				};
				{
					value = "item_hlvr_clip_rapidfire",
					chance = config.itemChances.item_hlvr_clip_rapidfire
				};
				{
					value = "item_hlvr_grenade_frag",
					chance = config.itemChances.item_hlvr_grenade_frag
				};
				{
					value = "item_hlvr_grenade_xen",
					chance = config.itemChances.item_hlvr_grenade_xen
				};
				{
					value = "item_healthvial",
					chance = config.itemChances.item_healthvial
				};
			}
			self._scriptEntity = scriptEntity
			self._largeRefundTargetEntity = entities.largeRefundTargetEntity
			self._smallRefundTargetEntities = smallRefundTargetEntities
			self._refundTriggerEntity = entities.refundTriggerEntity
			self._currencyAddedSoundEntity = entities.currencyAddedSoundEntity
			self._slotBoughtSoundEntity = entities.slotBoughtSoundEntity
			self._refundSoundEntity = entities.refundSoundEntity
			self._prefabRelays1 = entities.prefabRelays1
			self._prefabRelays2 = entities.prefabRelays2
			self._slots = slots
			self._slotConfig = config.slotConfig
			self._currencyDisplay = currencyDisplay
			self._active = false
			self._contextManager = ContextManager(self:GetScriptEntity())
			self._interiorEntities = {}
			self._startingCurrencyAmount = config.startingCurrencyAmount
			self:SetCurrency(self._startingCurrencyAmount)
			
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
	if not self:IsActive() then
		self._isActive = true
		self._currencyDisplay:Activate()
		
		for _, slot in ipairs(self:GetSlots()) do
			slot:Activate()
		end
		
		self:SetCurrency(self._startingCurrencyAmount)
		self:SpawnItems()
		
		EntFireByHandle(self:GetScriptEntity(), self._prefabRelays1, "fireuser1")
	end
end

--Deactivate the vending shop
function VendingShop:Deactivate()
	if self:IsActive() then
		self._isActive = false
		
		self:SetCurrency(0)
		self:RemoveItems()
		
		self._currencyDisplay:Deactivate()
		
		for _, slot in ipairs(self:GetSlots()) do
			slot:Lock()
			slot:Deactivate()
		end
		
		EntFireByHandle(self:GetScriptEntity(), self._prefabRelays1, "fireuser2")
	end
end

--Is the shop active?
function VendingShop:IsActive()
	return self._isActive
end

--Spawn items depending on the settings
function VendingShop:SpawnItems()
	for slotIndex, slot in ipairs(self:GetSlots()) do
		local slotConfig = self:GetSlotConfig(slotIndex)
		local classname = slotConfig.item == "random" and util.TableRandomChance(self.itemChanceTable) or slotConfig.item
		local item = self.items[classname]
		
		if item and slotConfig.item ~= "none" then
			local slotDrawerEntity = slot:GetDrawerEntity()
			
			--TODO: Use async
			SpawnEntityFromTableSynchronous(classname, {
				origin = slotDrawerEntity:TransformPointEntityToWorld(item.offsetPosition),
				angles = RotateOrientation(slotDrawerEntity:GetAngles(), item.offsetAngle)
			})
		end
		
		slot:SetCost(slotConfig.cost ~= -1 and slotConfig.cost or (item and item.cost) or 0)
		
		if classname == "none" and slotConfig.cost == -1 then
			slot:SetBought(true)
		end
		
		self:RefreshSlot(slot)
	end
end

--Remove all items inside the trigger_remove
function VendingShop:RemoveItems()
	for _, entity in pairs(self:GetInteriorEntities()) do
		entity:RemoveSelf()
	end
end

function VendingShop:GetInteriorEntities()
	local entities = {}
	
	for entity, _ in pairs(self._interiorEntities) do
		if IsValidEntity(entity) then
			entities[#entities + 1] = entity
		end
	end
	
	return entities
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

function VendingShop:GetSlotConfig(slotIndex)
	return self._slotConfig[slotIndex]
end

--Refund all resin
function VendingShop:Refund()
	if not self:IsRefunding() and self:GetCurrency() > 0 then
		self._isRefunding = true
		
		self:GetScriptEntity():SetThink(function()
			if self:IsActive() then
				local currency = self:GetCurrency()
				
				if currency >= self.largeCurrency.amount then
					SpawnEntityFromTableSynchronous(self.largeCurrency.classname, {
						origin = self._largeRefundTargetEntity:GetAbsOrigin(),
						angles = RotateOrientation(self._largeRefundTargetEntity:GetAngles(), QAngle(0, math.random(0, 359), 0))
					})
					
					self:AddCurrency(-self.largeCurrency.amount)
					self:PlayRefundSound()
					
					return self.largeCurrency.refundSpeed
				elseif currency > 0 then
					local spawnTarget = self._smallRefundTargetEntities[math.random(#self._smallRefundTargetEntities)]
					
					SpawnEntityFromTableSynchronous(self.smallCurrency.classname, {
						origin = spawnTarget:GetAbsOrigin(),
						angles = RotateOrientation(spawnTarget:GetAngles(), QAngle(0, math.random(0, 359), 0))
					})
					
					self:AddCurrency(-self.smallCurrency.amount)
					self:PlayRefundSound()
					
					return self.smallCurrency.refundSpeed
				end
			end
			
			--This part will be reached when currency is 0
			self._isRefunding = false
		end, "VendingShop.Refund", 0)
		
		EntFireByHandle(self:GetScriptEntity(), self._prefabRelays2, "fireuser1")
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
			
			EntFireByHandle(self:GetScriptEntity(), self._prefabRelays2, "fireuser3")
		elseif classname == self.smallCurrency.classname then
			trigger.activator:RemoveSelf()
			self:AddCurrency(self.smallCurrency.amount)
			self:PlayCurrencyAddedSound()
			
			EntFireByHandle(self:GetScriptEntity(), self._prefabRelays2, "fireuser2")
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

function VendingShop:OnInteriorTriggerStartTouch(trigger)
	if trigger.activator then
		local foundDrawer = false
		
		for _, slot in ipairs(self:GetSlots()) do
			if trigger.activator == slot:GetDrawerEntity() then
				foundDrawer = true
				
				break
			end
		end
		
		if not foundDrawer then
			self._interiorEntities[trigger.activator] = true
		end
	end
end

function VendingShop:OnInteriorTriggerEndTouch(trigger)
	if trigger.activator then
		self._interiorEntities[trigger.activator] = nil
	end
end

return VendingShop
