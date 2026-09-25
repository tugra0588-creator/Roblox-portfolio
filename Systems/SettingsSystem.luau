--[[
    Settings System
    Author: tugra0588-creator

    Description:
    Player settings management system.
]]

local SettingsSystem = {}

local playerSettings = {}

local DEFAULT_SETTINGS = {
	Music = true,
	SoundEffects = true,
	Notifications = true,
	GraphicsQuality = 3,
}

local function getSettings(player)
	if not playerSettings[player] then
		playerSettings[player] = table.clone(DEFAULT_SETTINGS)
	end

	return playerSettings[player]
end

function SettingsSystem.Get(player, settingName)
	if not player or typeof(settingName) ~= "string" then
		return nil
	end

	local settings = getSettings(player)

	return settings[settingName]
end

function SettingsSystem.Set(player, settingName, value)
	if not player or typeof(settingName) ~= "string" then
		return false
	end

	local settings = getSettings(player)

	if settings[settingName] == nil then
		return false
	end

	settings[settingName] = value

	return true
end

function SettingsSystem.Toggle(player, settingName)
	if not player or typeof(settingName) ~= "string" then
		return false
	end

	local settings = getSettings(player)

	if typeof(settings[settingName]) ~= "boolean" then
		return false
	end

	settings[settingName] = not settings[settingName]

	return settings[settingName]
end

function SettingsSystem.GetAll(player)
	if not player then
		return {}
	end

	local result = {}

	for name, value in pairs(getSettings(player)) do
		result[name] = value
	end

	return result
end

function SettingsSystem.Reset(player)
	if not player then
		return false
	end

	playerSettings[player] = table.clone(DEFAULT_SETTINGS)

	return true
end

function SettingsSystem.SetDefaults(defaults)
	if typeof(defaults) ~= "table" then
		return false
	end

	for name, value in pairs(defaults) do
		DEFAULT_SETTINGS[name] = value
	end

	return true
end

function SettingsSystem.Destroy(player)
	if not player then
		return false
	end

	playerSettings[player] = nil

	return true
end

return SettingsSystem
