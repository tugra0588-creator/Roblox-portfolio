--[[
    Round System
    Author: tugra0588-creator

    Description:
    Reusable round management system.
]]

local RoundSystem = {}

local currentRound = {
	Active = false,
	Number = 0,
	TimeLeft = 0,
}

local roundCallbacks = {
	OnStarted = {},
	OnEnded = {},
	OnTick = {},
}

local function fireCallbacks(callbackList, ...)
	for _, callback in ipairs(callbackList) do
		task.spawn(callback, ...)
	end
end

function RoundSystem.OnStarted(callback)
	if typeof(callback) ~= "function" then
		return false
	end

	table.insert(roundCallbacks.OnStarted, callback)
	return true
end

function RoundSystem.OnEnded(callback)
	if typeof(callback) ~= "function" then
		return false
	end

	table.insert(roundCallbacks.OnEnded, callback)
	return true
end

function RoundSystem.OnTick(callback)
	if typeof(callback) ~= "function" then
		return false
	end

	table.insert(roundCallbacks.OnTick, callback)
	return true
end

function RoundSystem.Start(duration)
	if currentRound.Active then
		return false
	end

	if typeof(duration) ~= "number" or duration <= 0 then
		return false
	end

	currentRound.Active = true
	currentRound.Number += 1
	currentRound.TimeLeft = math.floor(duration)

	fireCallbacks(
		roundCallbacks.OnStarted,
		currentRound.Number,
		currentRound.TimeLeft
	)

	task.spawn(function()
		while currentRound.Active and currentRound.TimeLeft > 0 do
			task.wait(1)

			if not currentRound.Active then
				break
			end

			currentRound.TimeLeft -= 1

			fireCallbacks(
				roundCallbacks.OnTick,
				currentRound.Number,
				currentRound.TimeLeft
			)
		end

		if currentRound.Active and currentRound.TimeLeft <= 0 then
			RoundSystem.End("TimeUp")
		end
	end)

	return true
end

function RoundSystem.End(reason)
	if not currentRound.Active then
		return false
	end

	currentRound.Active = false
	currentRound.TimeLeft = 0

	fireCallbacks(
		roundCallbacks.OnEnded,
		currentRound.Number,
		reason or "Unknown"
	)

	return true
end

function RoundSystem.IsActive()
	return currentRound.Active
end

function RoundSystem.GetTimeLeft()
	return currentRound.TimeLeft
end

function RoundSystem.GetRoundNumber()
	return currentRound.Number
end

function RoundSystem.GetState()
	return {
		Active = currentRound.Active,
		Number = currentRound.Number,
		TimeLeft = currentRound.TimeLeft,
	}
end

function RoundSystem.Reset()
	currentRound.Active = false
	currentRound.Number = 0
	currentRound.TimeLeft = 0

	table.clear(roundCallbacks.OnStarted)
	table.clear(roundCallbacks.OnEnded)
	table.clear(roundCallbacks.OnTick)
end

return RoundSystem
