
--Class for storing contexts easily
--Has no limit on context size
local ContextManager = class(
	{
		_engineContextLimit = 62,
		
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

--Get the entity that contexts are stored on
function ContextManager:GetEntity()
	return self._entity
end

--Set a string to be stored in the instance entity
function ContextManager:SetStoredString(key, str)
	local currentStringIndex = 0
	local keyIndex = 1
	
	repeat
		--The "_" in the value is needed to fix a problem where if the string starts with a number, the string will only be that number
		self:GetEntity():SetContext(self:_GetStoreKey(key, keyIndex), "_" .. string.sub(str, currentStringIndex + 1, currentStringIndex + self._engineContextLimit), 0)
		
		currentStringIndex = currentStringIndex + self._engineContextLimit
		keyIndex = keyIndex + 1
	until currentStringIndex >= #str
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
	local str
	local keyIndex = 1
	
	repeat
		local strPart = self:GetEntity():GetContext(self:_GetStoreKey(key, keyIndex))
		
		if strPart then
			str = (str or "") .. string.sub(strPart, 2)
			keyIndex = keyIndex + 1
		end
	until not strPart
	
	return str
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

function ContextManager:_GetStoreKey(key, keyIndex)
	return key .. "[" .. keyIndex .. "]"
end

return ContextManager
