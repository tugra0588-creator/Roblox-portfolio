--[[
    Event System
    Author: tugra0588-creator

    Description:
    Lightweight custom event and listener system.
]]

local EventSystem = {}

local events = {}

function EventSystem.Create(eventName)
	if typeof(eventName) ~= "string" or eventName == "" then
		return false
	end

	if events[eventName] then
		return false
	end

	events[eventName] = {}

	return true
end

function EventSystem.Connect(eventName, callback)
	if typeof(callback) ~= "function" then
		return nil
	end

	if not events[eventName] then
		EventSystem.Create(eventName)
	end

	local connection = {
		Connected = true,
		Callback = callback,
	}

	table.insert(events[eventName], connection)

	function connection:Disconnect()
		if not self.Connected then
			return
		end

		self.Connected = false
	end

	return connection
end

function EventSystem.Fire(eventName, ...)
	if not events[eventName] then
		return false
	end

	for _, connection in ipairs(events[eventName]) do
		if connection.Connected then
			task.spawn(connection.Callback, ...)
		end
	end

	return true
end

function EventSystem.Clear(eventName)
	if not events[eventName] then
		return false
	end

	table.clear(events[eventName])

	return true
end

function EventSystem.Remove(eventName)
	if not events[eventName] then
		return false
	end

	events[eventName] = nil

	return true
end

function EventSystem.Exists(eventName)
	return events[eventName] ~= nil
end

return EventSystem
