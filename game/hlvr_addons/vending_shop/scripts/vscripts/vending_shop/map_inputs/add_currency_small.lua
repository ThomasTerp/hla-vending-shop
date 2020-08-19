local shop = VendingShop.GetShop(string.sub(thisEntity:GetName(), 2))
shop:AddCurrency(shop.smallCurrencySize)
