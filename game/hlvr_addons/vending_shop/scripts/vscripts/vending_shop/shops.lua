_G.VendingShop = _G.VendingShop or {}
VendingShop._shops = VendingShop._shops or {}

--Add a shop, the shop name will be used as index
function VendingShop.AddShop(shop)
	VendingShop._shops[shop.name] = shop
end

--Get a shop by name
function VendingShop.GetShop(shopName)
	return VendingShop._shops[shopName]
end

--Remove a shop by name
function VendingShop.RemoveRoom(shopName)
	VendingShop._shops[shopName] = nil
end

--Get all shops
function VendingShop.GetAllShops()
	local shops = {}
	
	for _, shop in pairs(VendingShop._shops) do
		shops[#shops + 1] = shop
	end
	
	return shops
end
