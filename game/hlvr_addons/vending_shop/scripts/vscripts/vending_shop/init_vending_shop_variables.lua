
function Spawn(spawnKeys)
    totalLinks = tonumber(spawnKeys:GetValue("Case01"))
    refundCurrencyDisplayIndex = tonumber(spawnKeys:GetValue("Case02"))
    startActive = spawnKeys:GetValue("Case03") == "0" and false or true
    itemChances = spawnKeys:GetValue("Case04") or ""
    startingCurrencyAmount = tonumber(spawnKeys:GetValue("Case05")) or 0
end
