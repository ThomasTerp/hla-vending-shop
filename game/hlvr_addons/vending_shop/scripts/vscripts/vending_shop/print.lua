_G.VendingShop = _G.VendingShop or {}
VendingShop.prefix = "[VENDING_SHOP]"

--Get the keys of a table
function VendingShop.GetTableKeys(t)
	local keys = {}
	local id = 1

	for k, v in pairs(t) do
		keys[id] = k
		id = id + 1
	end

	return keys
end

--Prints the arguments.
function VendingShop.Print(...)
	print(VendingShop.prefix, ...)
end

--Print the contents of a table.
function VendingShop.PrintTable(t, indent, done)
	done = done or {}
	indent = indent or 0
	local keys = VendingShop.GetTableKeys(t)
	
	table.sort(keys, function(a, b)
		if type(a) == "number" and type(b) == "number" then
			return a < b
		end
		
		return tostring(a) < tostring(b)
	end)
	
	done[t] = true
	
	for i = 1, #keys do
		local key = keys[i]
		local value = t[key]
		
		VendingShop.Print((string.rep("\t", indent)))
		
		if type(value) == "table" and not done[value] then
			done[value] = true
			
			VendingShop.Print((tostring(key) .. ":" .. "\n"))
			VendingShop.PrintTable(value, indent + 2, done)
			
			done[value] = nil
		else
			VendingShop.Print((tostring(key) .. "\t=\t"))
			VendingShop.Print((tostring(value) .. "\n"))
		end
	end
end

--Prints the arguments. If the first argument is a table, then the table contents will be printed instead.
function VendingShop.DebugPrint(arg1, ...)
	if type(arg1) == "table" then
		VendingShop.Print("--------Table Print--------")
		VendingShop.PrintTable(arg1)
		VendingShop.Print("---------------------------")
	else
		VendingShop.Print(arg1, ...)
	end
end
