--[[
    Permission System
    Author: tugra0588-creator

    Description:
    Group-based permission management system.
]]

local PermissionSystem = {}

local playerRoles = {}
local rolePermissions = {}

local DEFAULT_ROLE = "Player"

function PermissionSystem.CreateRole(roleName)
	if typeof(roleName) ~= "string" or roleName == "" then
		return false
	end

	if rolePermissions[roleName] then
		return false
	end

	rolePermissions[roleName] = {}

	return true
end

function PermissionSystem.RemoveRole(roleName)
	if not rolePermissions[roleName] then
		return false
	end

	rolePermissions[roleName] = nil

	return true
end

function PermissionSystem.AddPermission(roleName, permission)
	if not rolePermissions[roleName] then
		PermissionSystem.CreateRole(roleName)
	end

	if typeof(permission) ~= "string" then
		return false
	end

	rolePermissions[roleName][permission] = true

	return true
end

function PermissionSystem.RemovePermission(roleName, permission)
	if not rolePermissions[roleName] then
		return false
	end

	rolePermissions[roleName][permission] = nil

	return true
end

function PermissionSystem.SetRole(player, roleName)
	if not player or typeof(roleName) ~= "string" then
		return false
	end

	if not rolePermissions[roleName] and roleName ~= DEFAULT_ROLE then
		return false
	end

	playerRoles[player] = roleName

	return true
end

function PermissionSystem.GetRole(player)
	if not player then
		return DEFAULT_ROLE
	end

	return playerRoles[player] or DEFAULT_ROLE
end

function PermissionSystem.HasPermission(player, permission)
	if not player or typeof(permission) ~= "string" then
		return false
	end

	local role = PermissionSystem.GetRole(player)

	if role == "Owner" then
		return true
	end

	if not rolePermissions[role] then
		return false
	end

	return rolePermissions[role][permission] == true
end

function PermissionSystem.GetRoles()
	local result = {}

	for roleName, permissions in pairs(rolePermissions) do
		result[roleName] = {}

		for permission, enabled in pairs(permissions) do
			result[roleName][permission] = enabled
		end
	end

	return result
end

function PermissionSystem.Destroy(player)
	if not player then
		return false
	end

	playerRoles[player] = nil

	return true
end

return PermissionSystem
