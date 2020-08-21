local util = {}

--[[Get a random value of the chance table formatted like this:
	{
		{
			value = <any type>,
			chance = <float>
		},
		...
	}
]]
function util.TableRandomChance(chanceTable)
	local range = 0
	
	for _, chanceData in pairs(chanceTable) do
		range = range + chanceData.chance
	end
	
	local randomNumber = math.random(0, range)
	local top = 0
	
	for _, chanceData in pairs(chanceTable) do
		top = top + chanceData.chance
		
		if randomNumber <= top then
			return chanceData.value
		end
	end
end

--Clamp a number between a minimum and a maximum
function util.Clamp(value, min, max)
	return math.min(math.max(value, min), max)
end

--Seed the random number generator based on local time
function util.RandomSeed()
	local time = LocalTime()
	local seed = tonumber(time.Hours .. time.Minutes .. time.Seconds)
	
	math.randomseed(seed)
	
	return seed
end

function util.Trim(s)
	return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

--Convert a comma seperated string with equal signs into a table
function util.StringDataToTable(input)
	local output = {}
	
	for _, keyValue in pairs(vlua.split(input, ",")) do
		keyValue = vlua.split(keyValue, "=")
		keyValue[1] = util.Trim(keyValue[1])
		keyValue[2] = util.Trim(keyValue[2])
		output[keyValue[1]] = tonumber(keyValue[2]) or keyValue[2]
	end
	
	return output
end

return util
