
local ContextManager = class(
	{		
		constructor = function(self, entity)
			self._entity = entity
			
			getmetatable(self).__tostring = function()
				return "[" .. self.__class__name .. ": " .. tostring(self:GetEntity()) .. "]"
			end
		end
	},
	{
		__class__name = "ContextManager"
	},
	nil
)

function ContextManager:GetEntity()
	return self._entity
end

--Set a string to be stored in the instance entity
function ContextManager:SetStoredString(key, str)
	--The "_" is needed to fix a problem where if the string starts with a number, the string will only be that number
	self:GetEntity():SetContext(key, "_" .. str, 0)
end

--Set a number to be stored in the instance entity
function ContextManager:SetStoredNumber(key, number)
	self:GetEntity():SetContextNum(key, number, 0)
end

--Set a bool to be stored in the instance entity
function ContextManager:SetStoredBool(key, bool)
	self:SetStoredNumber(key, bool and 1 or 0)
end

--Set an entity to be stored in the instance entity
--Entity to store must have a target name
function ContextManager:SetStoredEntity(key, entity)
	self:SetStoredString(key, entity:GetName())
end

--Set a vector to be stored in the instance entity
function ContextManager:SetStoredVector(key, vector)
	self:SetStoredString(key, vector.x .. " " .. vector.y .. " " .. vector.z)
end

--Set an angle to be stored in the instance entity
function ContextManager:SetStoredAngle(key, angle)
	self:SetStoredString(key, angle.x .. " " .. angle.y .. " " .. angle.z)
end

--Get a string that is stored in the instance entity
function ContextManager:GetStoredString(key)
	local str = self:GetEntity():GetContext(key)
	
	return str and string.sub(str, 2)
end

--Get a number that is stored in the instance entity
function ContextManager:GetStoredNumber(key)
	return self:GetEntity():GetContext(key)
end

--Get a bool that is stored in the instance entity
function ContextManager:GetStoredBool(key)
	return (self:GetStoredNumber(key) or 0) > 0 and true or false
end

--Get an entity that is stored in the instance entity
function ContextManager:GetStoredEntity(key)
	return Entities:FindByName(nil, self:GetStoredString(key))
end

--Get a vector that is stored in the instance entity
function ContextManager:GetStoredVector(key)
	local vectorString = self:GetStoredString(key)
	
	if vectorString then
		local axes = {}
		
		for numberString in string.gmatch(vectorString, "[^%s]+") do
			axes[#axes + 1] = tonumber(numberString)
		end
		
		if axes[1] and axes[2] and axes[3] then
			return Vector(axes[1], axes[2], axes[3])
		end
	end
end

--Get an angle that is stored in the instance entity
function ContextManager:GetStoredAngle(key)
	local angleString = self:GetStoredString(key)
	
	if angleString then
		local axes = {}
		
		for numberString in string.gmatch(angleString, "[^%s]+") do
			axes[#axes + 1] = tonumber(numberString)
		end
		
		if axes[1] and axes[2] and axes[3] then
			return QAngle(axes[1], axes[2], axes[3])
		end
	end
end

return ContextManager
