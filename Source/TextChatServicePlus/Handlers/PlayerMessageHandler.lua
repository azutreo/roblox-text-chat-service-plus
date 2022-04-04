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

local ClassicRobloxNameColors = Util.ClassicRobloxNameColors

local Prefixes = Configuration.Prefixes
local NameColors = Configuration.NameColors
local ChatColors = Configuration.ChatColors

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function GetPrefixForPlayer(player: Player)
	if not Prefixes.IsEnabled then
		return nil
	end

	local prefix = Util.AssignmentOptions:CompareAssignments(player, Prefixes.Assignments, Prefixes.Options)

	if typeof(prefix) == "table" then
		return prefix
	end

	return Prefixes.Configuration.UseDefaultPrefix and Prefixes.Configuration.DefaultPrefix or nil
end

local function GetChatColorForPlayer(player: Player)
	if not ChatColors.IsEnabled then
		return nil
	end

	if not Util.AssignmentOptions:CheckIsPlayerValid(player) then
		return {
			NameColor = ChatColors.Configuration.DefaultColor,
			Priority = 0
		}
	end

	local chatColor = Util.AssignmentOptions:CompareAssignments(player, ChatColors.Assignments, ChatColors.Options)

	if typeof(chatColor) == "table" then
		return chatColor
	end

	return {
		NameColor = ChatColors.Configuration.DefaultColor,
		Priority = 0
	}
end

local function GetNameColorForPlayer(player: Player)
	if not NameColors.IsEnabled then
		return nil
	end

	if not Util.AssignmentOptions:CheckIsPlayerValid(player) then
		return {
			NameColor = NameColors.Configuration.DefaultColor,
			Priority = 0
		}
	end

	local nameColor = Util.AssignmentOptions:CompareAssignments(player, NameColors.Assignments, NameColors.Options)

	if typeof(nameColor) == "table" then
		return nameColor
	end

	if NameColors.Configuration.UseTeamColor and typeof(player.Team) ~= "nil" then
		return {
			NameColor = player.TeamColor.Color,
			Priority = 0
		}
	end

	if not NameColors.Configuration.UseClassicNameColor then
		return {
			NameColor = NameColors.Configuration.DefaultColor,
			Priority = 0
		}
	end

	return {
		NameColor = ClassicRobloxNameColors(player),
		Priority = 0
	}
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function PlayerMessageHandler:Sending(message, properties)
	properties.PrefixText = string.format(Configuration.PlayerMessage.NameFormat, message.PrefixText)
	properties.Text = message.Text

	return properties
end

function PlayerMessageHandler:Success(message, properties)
	local player: Player = Players:GetPlayerByUserId(message.TextSource.UserId)
	if not Util.AssignmentOptions:CheckIsPlayerValid(player) then
		return properties
	end

	local prefix = GetPrefixForPlayer(player)
	local nameColor = GetNameColorForPlayer(player)
	local chatColor = GetChatColorForPlayer(player)

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

	message.TextChannel:DisplaySystemMessage(message.Text)

	return properties
end

--------------------
-- RETURN HANDLER --
--------------------

return PlayerMessageHandler