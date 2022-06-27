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

local ClassicNameColors = Util.ClassicNameColors

local Prefixes = Configuration.Prefixes
local NameColors = Configuration.NameColors
local ChatColors = Configuration.ChatColors

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function PlayerMessageHandler:Sending(message, properties)
	properties.PrefixText = string.format(Configuration.PlayerMessage.NameFormat, message.PrefixText)

	return properties
end

function PlayerMessageHandler:Success(message, properties)
	local player: Player = Players:GetPlayerByUserId(message.TextSource.UserId)
	if not Util.AssignmentOptions:CheckIsPlayerValid(player) then
		return properties
	end

	local prefix = player:GetAttribute("ChatData_Prefix")
	local nameColor = player:GetAttribute("ChatData_NameColor")
	local chatColor = player:GetAttribute("ChatData_ChatColor")

	properties.PrefixText = string.format(
		Configuration.PlayerMessage.NameFormat,
		message.PrefixText
	)

	if typeof(nameColor) == "table" and typeof(nameColor.Color) == "Color3" then
		properties.PrefixText = string.format(
			Configuration.PlayerMessage.NameColorFormat,
			nameColor.Color:ToHex(),
			properties.PrefixText
		)
	end

	if typeof(prefix) == "table" and typeof(prefix.Text) == "string" and typeof(prefix.Color) == "Color3" then
		properties.PrefixText = string.format(
			Configuration.PlayerMessage.PrefixFormat,
			prefix.Color:ToHex(),
			prefix.Text,
			properties.PrefixText
		)
	end

	-- THIS IS VERY BROKEN. DISABLED BY DEFAULT. ENABLE IN ChatColorModule IF YOU WANT TO TRY IT.
	if typeof(chatColor) == "table" and typeof(chatColor.Color) == "Color3" then
		properties.Text = string.format(
			Configuration.PlayerMessage.TextFormat,
			chatColor.Color:ToHex(),
			message.Text
		)
	end

	return properties
end

--------------------
-- RETURN HANDLER --
--------------------

return PlayerMessageHandler