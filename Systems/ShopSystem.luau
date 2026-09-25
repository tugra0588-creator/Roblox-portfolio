--[[
    Shop System
    Author: tugra0588-creator

    Description:
    Simple and reusable server-side shop system.
]]

local ShopSystem = {}

local products = {}

function ShopSystem.CreateProduct(productId, name, price, stock)
	if typeof(productId) ~= "string" then
		return false
	end

	if typeof(name) ~= "string" then
		return false
	end

	if typeof(price) ~= "number" or price < 0 then
		return false
	end

	if stock ~= nil and (typeof(stock) ~= "number" or stock < 0) then
		return false
	end

	products[productId] = {
		Id = productId,
		Name = name,
		Price = price,
		Stock = stock,
	}

	return true
end

function ShopSystem.RemoveProduct(productId)
	if not products[productId] then
		return false
	end

	products[productId] = nil

	return true
end

function ShopSystem.GetProduct(productId)
	local product = products[productId]

	if not product then
		return nil
	end

	return table.clone(product)
end

function ShopSystem.GetProducts()
	local result = {}

	for productId, product in pairs(products) do
		result[productId] = table.clone(product)
	end

	return result
end

function ShopSystem.IsAvailable(productId)
	local product = products[productId]

	if not product then
		return false
	end

	if product.Stock == nil then
		return true
	end

	return product.Stock > 0
end

function ShopSystem.Purchase(player, productId, currencyAmount)
	if not player then
		return false, "Invalid player"
	end

	local product = products[productId]

	if not product then
		return false, "Product not found"
	end

	if product.Stock ~= nil and product.Stock <= 0 then
		return false, "Out of stock"
	end

	if typeof(currencyAmount) ~= "number" then
		return false, "Invalid currency"
	end

	if currencyAmount < product.Price then
		return false, "Not enough currency"
	end

	if product.Stock ~= nil then
		product.Stock -= 1
	end

	return true, {
		ProductId = product.Id,
		ProductName = product.Name,
		Price = product.Price,
		RemainingCurrency = currencyAmount - product.Price,
	}
end

function ShopSystem.SetStock(productId, stock)
	local product = products[productId]

	if not product then
		return false
	end

	if typeof(stock) ~= "number" or stock < 0 then
		return false
	end

	product.Stock = stock

	return true
end

function ShopSystem.Restock(productId, amount)
	local product = products[productId]

	if not product then
		return false
	end

	if typeof(amount) ~= "number" or amount <= 0 then
		return false
	end

	if product.Stock == nil then
		return false
	end

	product.Stock += amount

	return true
end

function ShopSystem.Clear()
	table.clear(products)
end

return ShopSystem
