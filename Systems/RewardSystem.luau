--[[
    Reward System
    Author: tugra0588-creator

    Description:
    Reusable reward definition and claim system.
]]

local RewardSystem = {}

local rewards = {}
local claimedRewards = {}

function RewardSystem.CreateReward(rewardId, data)
	if typeof(rewardId) ~= "string" then
		return false
	end

	if typeof(data) ~= "table" then
		return false
	end

	rewards[rewardId] = table.clone(data)

	return true
end

function RewardSystem.RemoveReward(rewardId)
	if not rewards[rewardId] then
		return false
	end

	rewards[rewardId] = nil

	return true
end

function RewardSystem.GetReward(rewardId)
	local reward = rewards[rewardId]

	if not reward then
		return nil
	end

	return table.clone(reward)
end

function RewardSystem.GetRewards()
	local result = {}

	for rewardId, reward in pairs(rewards) do
		result[rewardId] = table.clone(reward)
	end

	return result
end

function RewardSystem.CanClaim(player, rewardId)
	if not player then
		return false
	end

	if not rewards[rewardId] then
		return false
	end

	if not claimedRewards[player] then
		return true
	end

	return not claimedRewards[player][rewardId]
end

function RewardSystem.Claim(player, rewardId)
	if not player then
		return false, "Invalid player"
	end

	if not rewards[rewardId] then
		return false, "Reward not found"
	end

	if not claimedRewards[player] then
		claimedRewards[player] = {}
	end

	if claimedRewards[player][rewardId] then
		return false, "Already claimed"
	end

	claimedRewards[player][rewardId] = true

	return true, table.clone(rewards[rewardId])
end

function RewardSystem.ResetClaim(player, rewardId)
	if not player then
		return false
	end

	if not claimedRewards[player] then
		return false
	end

	claimedRewards[player][rewardId] = nil

	return true
end

function RewardSystem.ClearClaims(player)
	if not player then
		return false
	end

	claimedRewards[player] = {}

	return true
end

function RewardSystem.Destroy(player)
	if not player then
		return false
	end

	claimedRewards[player] = nil

	return true
end

return RewardSystem
