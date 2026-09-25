--[[
    DataStore System
    Author: tugra0588-creator

    Description:
    Simple and reusable DataStore wrapper.
]]

local DataStoreService = game:GetService("DataStoreService")

local DataStoreSystem = {}

local storeCache = {}

local function getStore(storeName: string)
	if not storeCache[storeName] then
		storeCache[storeName] = DataStoreService:GetDataStore(storeName)
	end

	return storeCache[storeName]
end

function DataStoreSystem.Get(storeName: string, key: string)
	local store = getStore(storeName)

	local success, result = pcall(function()
		return store:GetAsync(key)
	end)

	if not success then
		warn("[DataStoreSystem] GetAsync failed:", result)
		return nil
	end

	return result
end

function DataStoreSystem.Set(storeName: string, key: string, value)
	local store = getStore(storeName)

	local success, result = pcall(function()
		store:SetAsync(key, value)
	end)

	if not success then
		warn("[DataStoreSystem] SetAsync failed:", result)
		return false
	end

	return true
end

function DataStoreSystem.Update(storeName: string, key: string, updateFunction)
	local store = getStore(storeName)

	local success, result = pcall(function()
		return store:UpdateAsync(key, updateFunction)
	end)

	if not success then
		warn("[DataStoreSystem] UpdateAsync failed:", result)
		return nil
	end

	return result
end

function DataStoreSystem.Remove(storeName: string, key: string)
	local store = getStore(storeName)

	local success, result = pcall(function()
		store:RemoveAsync(key)
	end)

	if not success then
		warn("[DataStoreSystem] RemoveAsync failed:", result)
		return false
	end

	return true
end

return DataStoreSystem
