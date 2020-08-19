_G.VendingShop = _G.VendingShop or {}
VendingShop._shopItemMetatable = VendingShop._shopItemMetatable or {}
VendingShop._shopItemMetatable.__index = {}

VendingShop._shopItemMetatable.__tostring = function(self)
	return "[ShopItem: " .. self.classname .. "]"
end

--Creates an instance of an shopItem
--Example: VendingShop.ShopItem("class_name")
function VendingShop.ShopItem(classname, cost, offsetPosition, offsetAngle)
    local shopItem = setmetatable({
        classname = classname,
        cost = cost,
		offsetPosition = offsetPosition,
		offsetAngle = offsetAngle
    }, VendingShop._shopItemMetatable)
	
	return shopItem
end
