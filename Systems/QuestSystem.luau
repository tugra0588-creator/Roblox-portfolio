--[[
    Quest System
    Author: tugra0588-creator

    Description:
    Simple and reusable quest management system.
]]

local QuestSystem = {}

local playerQuests = {}

local function getPlayerQuests(player)
	if not playerQuests[player] then
		playerQuests[player] = {}
	end

	return playerQuests[player]
end

function QuestSystem.CreateQuest(questId, name, description, goal, reward)
	if typeof(questId) ~= "string" then
		return false
	end

	if typeof(name) ~= "string" then
		return false
	end

	if typeof(goal) ~= "number" or goal <= 0 then
		return false
	end

	local quest = {
		Id = questId,
		Name = name,
		Description = description or "",
		Goal = goal,
		Reward = reward or 0,
	}

	return quest
end

function QuestSystem.StartQuest(player, quest)
	if not player or not quest then
		return false
	end

	local quests = getPlayerQuests(player)

	if quests[quest.Id] then
		return false
	end

	quests[quest.Id] = {
		Id = quest.Id,
		Name = quest.Name,
		Description = quest.Description,
		Goal = quest.Goal,
		Progress = 0,
		Reward = quest.Reward,
		Completed = false,
	}

	return true
end

function QuestSystem.AddProgress(player, questId, amount)
	if not player or typeof(questId) ~= "string" then
		return false
	end

	amount = amount or 1

	if typeof(amount) ~= "number" or amount <= 0 then
		return false
	end

	local quests = getPlayerQuests(player)
	local quest = quests[questId]

	if not quest or quest.Completed then
		return false
	end

	quest.Progress += amount

	if quest.Progress >= quest.Goal then
		quest.Progress = quest.Goal
		quest.Completed = true
	end

	return true
end

function QuestSystem.IsCompleted(player, questId)
	local quests = getPlayerQuests(player)
	local quest = quests[questId]

	if not quest then
		return false
	end

	return quest.Completed
end

function QuestSystem.GetQuest(player, questId)
	local quests = getPlayerQuests(player)
	local quest = quests[questId]

	if not quest then
		return nil
	end

	return table.clone(quest)
end

function QuestSystem.GetQuests(player)
	local quests = getPlayerQuests(player)
	local result = {}

	for questId, quest in pairs(quests) do
		result[questId] = table.clone(quest)
	end

	return result
end

function QuestSystem.RemoveQuest(player, questId)
	if not player or typeof(questId) ~= "string" then
		return false
	end

	local quests = getPlayerQuests(player)

	if not quests[questId] then
		return false
	end

	quests[questId] = nil

	return true
end

function QuestSystem.Clear(player)
	if not player then
		return false
	end

	playerQuests[player] = {}

	return true
end

function QuestSystem.Destroy(player)
	if not player then
		return false
	end

	playerQuests[player] = nil

	return true
end

return QuestSystem
