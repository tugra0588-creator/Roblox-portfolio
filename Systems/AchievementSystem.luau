--[[
    Achievement System
    Author: tugra0588-creator

    Description:
    Achievement creation, progress and unlock system.
]]

local AchievementSystem = {}

local achievements = {}
local playerAchievements = {}

local function getPlayerAchievements(player)
	if not playerAchievements[player] then
		playerAchievements[player] = {}
	end

	return playerAchievements[player]
end

function AchievementSystem.Create(id, name, description, goal)
	if typeof(id) ~= "string" then
		return false
	end

	if typeof(name) ~= "string" then
		return false
	end

	if typeof(goal) ~= "number" or goal <= 0 then
		return false
	end

	achievements[id] = {
		Id = id,
		Name = name,
		Description = description or "",
		Goal = goal,
	}

	return true
end

function AchievementSystem.Get(id)
	if not achievements[id] then
		return nil
	end

	return table.clone(achievements[id])
end

function AchievementSystem.AddProgress(player, id, amount)
	if not player or not achievements[id] then
		return false
	end

	amount = amount or 1

	if typeof(amount) ~= "number" or amount <= 0 then
		return false
	end

	local playerData = getPlayerAchievements(player)

	if not playerData[id] then
		playerData[id] = {
			Progress = 0,
			Unlocked = false,
		}
	end

	local data = playerData[id]

	if data.Unlocked then
		return false
	end

	data.Progress += amount

	if data.Progress >= achievements[id].Goal then
		data.Progress = achievements[id].Goal
		data.Unlocked = true
	end

	return true
end

function AchievementSystem.IsUnlocked(player, id)
	if not player then
		return false
	end

	local data = getPlayerAchievements(player)[id]

	return data ~= nil and data.Unlocked == true
end

function AchievementSystem.GetPlayerAchievements(player)
	if not player then
		return {}
	end

	local result = {}

	for id, data in pairs(getPlayerAchievements(player)) do
		result[id] = table.clone(data)
	end

	return result
end

function AchievementSystem.Reset(player, id)
	if not player then
		return false
	end

	local playerData = getPlayerAchievements(player)

	if not playerData[id] then
		return false
	end

	playerData[id] = nil

	return true
end

function AchievementSystem.Destroy(player)
	if not player then
		return false
	end

	playerAchievements[player] = nil

	return true
end

return AchievementSystem
