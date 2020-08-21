
function Spawn(spawnKeys)
    totalLinks = tonumber(spawnKeys:GetValue("Case01"))
    refundCurrencyDisplayIndex = tonumber(spawnKeys:GetValue("Case02"))
    startActive = spawnKeys:GetValue("Case03") ~= "0" and true or false
    startingCurrencyAmount = tonumber(spawnKeys:GetValue("Case04")) or 0
    itemChances = spawnKeys:GetValue("Case05")
    itemCosts = spawnKeys:GetValue("Case06")
end
