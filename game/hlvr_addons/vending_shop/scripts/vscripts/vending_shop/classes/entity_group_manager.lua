local ContextManager = require("vending_shop/classes/context_manager")

local EntityGroupManager = class(
	{		
		constructor = function(self, scriptEntity)
			self._scriptEntity = scriptEntity
			self._scriptScope = scriptEntity:GetPrivateScriptScope()
			self._contextManager = ContextManager(scriptEntity)
			
			self:_StoreEntities()
			
			getmetatable(self).__tostring = function()
				return "[" .. self.__class__name .. ": " .. tostring(self:GetScriptEntity()) .. "]"
			end
		end
	},
	{
		__class__name = "EntityGroupManager"
	},
	nil
)

function EntityGroupManager:GetScriptEntity()
	return self._scriptEntity
end

function EntityGroupManager:GetEntity(entityGroupIndex)
	return (self._scriptScope.EntityGroup and self._scriptScope.EntityGroup[entityGroupIndex]) or self._contextManager:GetStoredEntity(self:_GetStoreKey(entityGroupIndex))
end

function EntityGroupManager:_StoreEntities()
	if self._scriptScope.EntityGroup then
		for entityGroupIndex, entity in pairs(self._scriptScope.EntityGroup) do
			if not self._contextManager:GetStoredEntity(self:_GetStoreKey(entityGroupIndex)) then
				self._contextManager:SetStoredEntity(self:_GetStoreKey(entityGroupIndex), entity)
			end
		end
	end
end

function EntityGroupManager:_GetStoreKey(entityGroupIndex)
	return "EntityGroupManager._entityGroup[" .. entityGroupIndex .. "]"
end

return EntityGroupManager
