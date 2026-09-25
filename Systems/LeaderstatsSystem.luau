--[[
    Leaderstats System
    Author: tugra0588-creator

    Description:
    Basic Roblox leaderstats system.
]]

local Players = game:GetService("Players")

local LeaderstatsSystem = {}

function LeaderstatsSystem.Create(player: Player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = "Coins"
	coins.Value = 0
	coins.Parent = leaderstats

	local level = Instance.new("IntValue")
	level.Name = "Level"
	level.Value = 1
	level.Parent = leaderstats
end

function LeaderstatsSystem.Start()
	Players.PlayerAdded:Connect(function(player)
		LeaderstatsSystem.Create(player)
	end)
end

return LeaderstatsSystem
