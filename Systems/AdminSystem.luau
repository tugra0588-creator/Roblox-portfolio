--[[
    Admin System
    Author: tugra0588-creator

    Description:
    Simple and reusable server-side admin permission system.
]]

local AdminSystem = {}

local admins = {}
local permissions = {}

local DEFAULT_PERMISSION = "Admin"

local function normalizeUserId(userId)
	return tonumber(userId)
end

function AdminSystem.AddAdmin(userId, permission)
	userId = normalizeUserId(userId)

	if not userId then
		return false
	end

	permission = permission or DEFAULT_PERMISSION

	if typeof(permission) ~= "string" then
		return false
	end

	admins[userId] = true
	permissions[userId] = permission

	return true
end

function AdminSystem.RemoveAdmin(userId)
	userId = normalizeUserId(userId)

	if not userId then
		return false
	end

	if not admins[userId] then
		return false
	end

	admins[userId] = nil
	permissions[userId] = nil

	return true
end

function AdminSystem.IsAdmin(userId)
	userId = normalizeUserId(userId)

	if not userId then
		return false
	end

	return admins[userId] == true
end

function AdminSystem.GetPermission(userId)
	userId = normalizeUserId(userId)

	if not userId or not admins[userId] then
		return nil
	end

	return permissions[userId]
end

function AdminSystem.SetPermission(userId, permission)
	userId = normalizeUserId(userId)

	if not userId or not admins[userId] then
		return false
	end

	if typeof(permission) ~= "string" then
		return false
	end

	permissions[userId] = permission

	return true
end

function AdminSystem.HasPermission(userId, requiredPermission)
	userId = normalizeUserId(userId)

	if not userId or not admins[userId] then
		return false
	end

	local currentPermission = permissions[userId]

	if currentPermission == "Owner" then
		return true
	end

	if currentPermission == requiredPermission then
		return true
	end

	return false
end

function AdminSystem.GetAdmins()
	local result = {}

	for userId, permission in pairs(permissions) do
		result[userId] = permission
	end

	return result
end

function AdminSystem.Clear()
	table.clear(admins)
	table.clear(permissions)
end

return AdminSystem
