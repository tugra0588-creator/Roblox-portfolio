--[[
    Notification System
    Author: tugra0588-creator

    Description:
    Server-side notification queue and management system.
]]

local NotificationSystem = {}

local notifications = {}
local nextId = 0

local function getPlayerNotifications(player)
	if not notifications[player] then
		notifications[player] = {}
	end

	return notifications[player]
end

function NotificationSystem.Send(player, title, message, notificationType, duration)
	if not player then
		return nil
	end

	if typeof(title) ~= "string" or typeof(message) ~= "string" then
		return nil
	end

	nextId += 1

	local notification = {
		Id = nextId,
		Title = title,
		Message = message,
		Type = notificationType or "Info",
		Duration = duration or 5,
		CreatedAt = os.time(),
	}

	table.insert(getPlayerNotifications(player), notification)

	return notification.Id
end

function NotificationSystem.GetAll(player)
	if not player then
		return {}
	end

	local result = {}

	for _, notification in ipairs(getPlayerNotifications(player)) do
		table.insert(result, table.clone(notification))
	end

	return result
end

function NotificationSystem.Get(player, notificationId)
	if not player then
		return nil
	end

	for _, notification in ipairs(getPlayerNotifications(player)) do
		if notification.Id == notificationId then
			return table.clone(notification)
		end
	end

	return nil
end

function NotificationSystem.Remove(player, notificationId)
	if not player then
		return false
	end

	local playerNotifications = getPlayerNotifications(player)

	for index, notification in ipairs(playerNotifications) do
		if notification.Id == notificationId then
			table.remove(playerNotifications, index)
			return true
		end
	end

	return false
end

function NotificationSystem.Clear(player)
	if not player then
		return false
	end

	notifications[player] = {}

	return true
end

function NotificationSystem.Destroy(player)
	if not player then
		return false
	end

	notifications[player] = nil

	return true
end

return NotificationSystem
