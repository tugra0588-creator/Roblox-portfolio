--[[
    Currency System
    Author: tugra0588-creator

    Description:
    Multi-currency management system.
]]

local CurrencySystem = {}

local playerCurrencies = {}

local DEFAULT_CURRENCY = "Coins"

local function getPlayerCurrencies(player)
	if not playerCurrencies[player] then
		playerCurrencies[player] = {}
	end

	return playerCurrencies[player]
end

function CurrencySystem.Create(player, currencyName, amount)
	if not player or typeof(currencyName) ~= "string" then
		return false
	end

	amount = amount or 0

	if typeof(amount) ~= "number" then
		return false
	end

	local currencies = getPlayerCurrencies(player)

	if currencies[currencyName] ~= nil then
		return false
	end

	currencies[currencyName] = amount

	return true
end

function CurrencySystem.Get(player, currencyName)
	if not player then
		return 0
	end

	currencyName = currencyName or DEFAULT_CURRENCY

	local currencies = getPlayerCurrencies(player)

	return currencies[currencyName] or 0
end

function CurrencySystem.Set(player, currencyName, amount)
	if not player or typeof(currencyName) ~= "string" then
		return false
	end

	if typeof(amount) ~= "number" then
		return false
	end

	local currencies = getPlayerCurrencies(player)

	currencies[currencyName] = amount

	return true
end

function CurrencySystem.Add(player, currencyName, amount)
	if not player or typeof(currencyName) ~= "string" then
		return false
	end

	if typeof(amount) ~= "number" or amount <= 0 then
		return false
	end

	local currencies = getPlayerCurrencies(player)

	currencies[currencyName] = (currencies[currencyName] or 0) + amount

	return true
end

function CurrencySystem.Remove(player, currencyName, amount)
	if not player or typeof(currencyName) ~= "string" then
		return false
	end

	if typeof(amount) ~= "number" or amount <= 0 then
		return false
	end

	local currencies = getPlayerCurrencies(player)
	local currentAmount = currencies[currencyName] or 0

	if currentAmount < amount then
		return false
	end

	currencies[currencyName] = currentAmount - amount

	return true
end

function CurrencySystem.Has(player, currencyName, amount)
	if not player then
		return false
	end

	amount = amount or 0

	return CurrencySystem.Get(player, currencyName) >= amount
end

function CurrencySystem.GetAll(player)
	if not player then
		return {}
	end

	local result = {}

	for name, amount in pairs(getPlayerCurrencies(player)) do
		result[name] = amount
	end

	return result
end

function CurrencySystem.Clear(player)
	if not player then
		return false
	end

	playerCurrencies[player] = {}

	return true
end

function CurrencySystem.Destroy(player)
	if not player then
		return false
	end

	playerCurrencies[player] = nil

	return true
end

return CurrencySystem
