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

------------------------
-- PRIVATE PROPERTIES --
------------------------

local ClassicRobloxNameColors = Util.ClassicRobloxNameColors

local Prefixes = Configuration.Prefixes
local NameColors = Configuration.NameColors
local ChatColors = Configuration.ChatColors

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function GetPrefixForPlayer(player: Player)
	if not Prefixes.IsEnabled then
		return nil
	end

	local prefix = Util:CompareAssignments(player, Prefixes.Assignments, Prefixes.Options)

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

	local chatColor = Util:CompareAssignments(player, ChatColors.Assignments, ChatColors.Options)

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

	local nameColor = Util:CompareAssignments(player, NameColors.Assignments, NameColors.Options)

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

-----------------------------
-- RETURN HANDLER FUNCTION --
-----------------------------

return function(message, properties)
	local player: Player = Players:GetPlayerByUserId(message.TextSource.UserId)
	if not Util.AssignmentOptions:CheckIsPlayerValid(player) then
		return properties
	end

	local prefix = GetPrefixForPlayer(player)
	local nameColor = GetNameColorForPlayer(player)
	local chatColor = GetChatColorForPlayer(player)

	properties.PrefixText = string.format(Configuration.NameFormat, message.PrefixText)

	if typeof(nameColor) == "table" and typeof(nameColor.NameColor) == "Color3" then
		properties.PrefixText = string.format(Configuration.NameColorFormat, nameColor.NameColor:ToHex(), properties.PrefixText)
	end

	if typeof(prefix) == "table" and typeof(prefix.TagText) == "string" and typeof(prefix.TagColor) == "Color3" then
		properties.PrefixText = string.format(Configuration.PrefixFormat, prefix.TagColor:ToHex(), prefix.TagText, properties.PrefixText)
	end

	-- THIS IS VERY BROKEN. DISABLED BY DEFAULT. ENABLE IN ChatColorModule IF YOU WANT TO TRY IT.
	if typeof(chatColor) == "table" and typeof(chatColor.ChatColor) == "Color3" then
		properties.Text = string.format(Configuration.ChatColorFormat, chatColor.ChatColor:ToHex(), message.Text)
	end

	return properties
end