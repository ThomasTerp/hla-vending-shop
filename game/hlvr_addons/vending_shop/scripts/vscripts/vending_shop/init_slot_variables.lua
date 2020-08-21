
function Spawn(spawnKeys)
    index = tonumber(spawnKeys:GetValue("Case01"))
	item = spawnKeys:GetValue("Case02")
    cost = tonumber(spawnKeys:GetValue("Case03")) or -1
end
