--[[

	PlayerMessageHandler
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	Adds prefixes, name colors, and chat tags to player messages

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- local Knit = require(ReplicatedStorage.Packages.Knit)
local Util = require(script.Parent.Parent.Util)
local Configuration = require(script.Parent.Parent.Configuration)

---------------------
-- MODULE CREATION --
---------------------

local PlayerMessageHandler = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function PlayerMessageHandler:ProcessMessage(message, properties)
	local player: Player = Players:GetPlayerByUserId(message.TextSource.UserId)
	if not Util.AssignmentOptions:CheckIsPlayerValid(player) then
		return properties
	end

	local prefixText = player:GetAttribute("ChatData_PrefixText")
	local prefixColor = player:GetAttribute("ChatData_PrefixColor")
	local nameColor = player:GetAttribute("ChatData_NameColor")
	local chatColor = player:GetAttribute("ChatData_ChatColor")
	local customName = player:GetAttribute("ChatData_CustomName")

	properties.PrefixText = string.format(
		Configuration.PlayerMessage.NameFormat,
		customName ~= "" and customName or message.PrefixText
	)

	if typeof(nameColor) == "string" then
		properties.PrefixText = string.format(
			Configuration.PlayerMessage.NameColorFormat,
			nameColor,
			properties.PrefixText
		)
	end

	if typeof(prefixText) == "string" and typeof(prefixColor) == "string" then
		properties.PrefixText = string.format(
			Configuration.PlayerMessage.PrefixFormat,
			prefixColor,
			prefixText,
			properties.PrefixText
		)
	end

	if typeof(chatColor) == "string" then
		properties.Text = string.format(
			Configuration.PlayerMessage.TextFormat,
			chatColor,
			message.Text
		)
	end

	return properties
end

--------------------
-- RETURN HANDLER --
--------------------

return PlayerMessageHandler
