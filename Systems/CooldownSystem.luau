--[[
    Cooldown System
    Author: tugra0588-creator

    Description:
    Reusable cooldown manager for Roblox systems.
]]

local CooldownSystem = {}

local cooldowns = {}

local function getPlayerCooldowns(player)
	if not cooldowns[player] then
		cooldowns[player] = {}
	end

	return cooldowns[player]
end

function CooldownSystem.Start(player, cooldownName, duration)
	if not player then
		return false
	end

	if typeof(cooldownName) ~= "string" then
		return false
	end

	if typeof(duration) ~= "number" or duration < 0 then
		return false
	end

	local playerCooldowns = getPlayerCooldowns(player)

	if playerCooldowns[cooldownName] then
		return false
	end

	playerCooldowns[cooldownName] = os.clock() + duration

	if duration > 0 then
		task.delay(duration, function()
			if cooldowns[player] then
				cooldowns[player][cooldownName] = nil
			end
		end)
	end

	return true
end

function CooldownSystem.IsActive(player, cooldownName)
	if not player or typeof(cooldownName) ~= "string" then
		return false
	end

	local playerCooldowns = getPlayerCooldowns(player)
	local endTime = playerCooldowns[cooldownName]

	if not endTime then
		return false
	end

	if os.clock() >= endTime then
		playerCooldowns[cooldownName] = nil
		return false
	end

	return true
end

function CooldownSystem.GetRemaining(player, cooldownName)
	if not player or typeof(cooldownName) ~= "string" then
		return 0
	end

	local playerCooldowns = getPlayerCooldowns(player)
	local endTime = playerCooldowns[cooldownName]

	if not endTime then
		return 0
	end

	local remaining = endTime - os.clock()

	if remaining <= 0 then
		playerCooldowns[cooldownName] = nil
		return 0
	end

	return remaining
end

function CooldownSystem.Stop(player, cooldownName)
	if not player or typeof(cooldownName) ~= "string" then
		return false
	end

	local playerCooldowns = getPlayerCooldowns(player)

	if not playerCooldowns[cooldownName] then
		return false
	end

	playerCooldowns[cooldownName] = nil

	return true
end

function CooldownSystem.Clear(player)
	if not player then
		return false
	end

	cooldowns[player] = {}

	return true
end

function CooldownSystem.Destroy(player)
	if not player then
		return false
	end

	cooldowns[player] = nil

	return true
end

return CooldownSystem
