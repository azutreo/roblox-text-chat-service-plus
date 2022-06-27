--[[

	AssignChatDataHandler
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	Adds prefixes, name colors, and chat tags to player messages

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- local Knit = require(ReplicatedStorage.Packages.Knit)
local Util = require(script.Parent.Parent.Util)
local Configuration = require(script.Parent.Parent.Configuration)

---------------------
-- MODULE CREATION --
---------------------

local AssignChatDataHandler = {}

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
			Name = "Default",
			Color = ChatColors.Configuration.DefaultColor
		}
	end

	local chatColor = Util.AssignmentOptions:CompareAssignments(player, ChatColors.Assignments, ChatColors.Options)

	if typeof(chatColor) == "table" then
		return chatColor
	end

	return {
		Name = "Default",
		Color = ChatColors.Configuration.DefaultColor
	}
end

local function GetNameColorForPlayer(player: Player)
	if not NameColors.IsEnabled then
		return nil
	end

	if not Util.AssignmentOptions:CheckIsPlayerValid(player) then
		return {
			Name = "Default",
			Color = NameColors.Configuration.DefaultColor
		}
	end

	if NameColors.Configuration.UseAssignedColor then
		local nameColor = Util.AssignmentOptions:CompareAssignments(player, NameColors.Assignments, NameColors.Options)

		if typeof(nameColor) == "table" then
			return nameColor
		end
	end

	if NameColors.Configuration.UseTeamColor and typeof(player.Team) ~= "nil" then
		return {
			Name = "Team",
			Color = player.TeamColor.Color
		}
	end

	if NameColors.Configuration.UseClassicNameColor then
		return {
			Name = "Classic",
			Color = ClassicNameColors(player)
		}
	end

	return {
		Name = "Default",
		Color = NameColors.Configuration.DefaultColor
	}
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function AssignChatDataHandler:UpdateForPlayer(player: Player)
	if not Util.AssignmentOptions:CheckIsPlayerValid(player) then
		return
	end

	local prefix = GetPrefixForPlayer(player)
	local nameColor = GetNameColorForPlayer(player)
	local chatColor = GetChatColorForPlayer(player)

	if not Util.AssignmentOptions:CheckIsPlayerValid(player) then
		return
	end

	if typeof(prefix) == "table" and typeof(prefix.Text) == "string" and typeof(prefix.Color) == "Color3" then
		player:SetAttribute("ChatData_PrefixColor", prefix.Color:ToHex())
		player:SetAttribute("ChatData_PrefixText", prefix.Text)
	end

	if typeof(nameColor) == "table" and typeof(nameColor.Color) == "Color3" then
		player:SetAttribute("ChatData_NameColor", nameColor.Color:ToHex())
	end

	if typeof(chatColor) == "table" and typeof(chatColor.Color) == "Color3" then
		player:SetAttribute("ChatData_ChatColor", chatColor.Color:ToHex())
	end
end

--------------------
-- RETURN HANDLER --
--------------------

return AssignChatDataHandler