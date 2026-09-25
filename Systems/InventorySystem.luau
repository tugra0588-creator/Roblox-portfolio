--[[
    Inventory System
    Author: tugra0588-creator

    Description:
    Simple server-side inventory system.
]]

local InventorySystem = {}

local inventories = {}

local function getInventory(player)
	if not inventories[player] then
		inventories[player] = {}
	end

	return inventories[player]
end

function InventorySystem.Create(player)
	if not player then
		return false
	end

	if inventories[player] then
		return false
	end

	inventories[player] = {}

	return true
end

function InventorySystem.AddItem(player, itemName, amount)
	if not player or typeof(itemName) ~= "string" then
		return false
	end

	amount = amount or 1

	if typeof(amount) ~= "number" or amount <= 0 then
		return false
	end

	local inventory = getInventory(player)

	inventory[itemName] = (inventory[itemName] or 0) + amount

	return true
end

function InventorySystem.RemoveItem(player, itemName, amount)
	if not player or typeof(itemName) ~= "string" then
		return false
	end

	amount = amount or 1

	local inventory = getInventory(player)
	local currentAmount = inventory[itemName] or 0

	if currentAmount < amount then
		return false
	end

	inventory[itemName] = currentAmount - amount

	if inventory[itemName] <= 0 then
		inventory[itemName] = nil
	end

	return true
end

function InventorySystem.HasItem(player, itemName, amount)
	if not player or typeof(itemName) ~= "string" then
		return false
	end

	amount = amount or 1

	local inventory = getInventory(player)

	return (inventory[itemName] or 0) >= amount
end

function InventorySystem.GetItemAmount(player, itemName)
	if not player or typeof(itemName) ~= "string" then
		return 0
	end

	local inventory = getInventory(player)

	return inventory[itemName] or 0
end

function InventorySystem.GetInventory(player)
	local inventory = getInventory(player)
	local copy = {}

	for itemName, amount in pairs(inventory) do
		copy[itemName] = amount
	end

	return copy
end

function InventorySystem.Clear(player)
	if not player then
		return false
	end

	inventories[player] = {}

	return true
end

function InventorySystem.Destroy(player)
	if not player then
		return false
	end

	inventories[player] = nil

	return true
end

return InventorySystem
