local Util = require(script.Parent.Parent.Util)
local ClassicRobloxNameColors = require(script.Parent.Parent.Util.ClassicRobloxNameColors)

local Configration = require(script.Parent.Parent.Configuration)
local Prefixes = Configration.Prefixes
local NameColors = Configration.NameColors
local ChatColors = Configration.ChatColors

local function GetPrefixForPlayer(player: Player)
	if not Prefixes.IsEnabled then
		return nil
	end

	local prefix = Util:CompareAssignments(player, Prefixes.Assignments, Prefixes.Options)

	if typeof(prefix) == "table" then
		return prefix
	end

	return Prefixes.Configration.UseDefaultPrefix and Prefixes.Configration.DefaultPrefix or nil
end

local function GetChatColorForPlayer(player: Player)
	if not ChatColors.IsEnabled then
		return nil
	end

	if not Util:CheckIsPlayerValid(player) then
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

	if not Util:CheckIsPlayerValid(player) then
		return {
			NameColor = NameColors.Configration.DefaultColor,
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

	if not NameColors.Configration.UseClassicNameColor then
		return {
			NameColor = NameColors.Configration.DefaultColor,
			Priority = 0
		}
	end

	return {
		NameColor = ClassicRobloxNameColors(player),
		Priority = 0
	}
end

return function(player, message, properties)
	local prefix = GetPrefixForPlayer(player)
	local nameColor = GetNameColorForPlayer(player)
	local chatColor = GetChatColorForPlayer(player)

	properties.PrefixText = string.format(Configration.NameFormat, message.PrefixText)

	if typeof(nameColor) == "table" and typeof(nameColor.NameColor) == "Color3" then
		properties.PrefixText = string.format(Configration.NameColorFormat, nameColor.NameColor:ToHex(), properties.PrefixText)
	end

	if typeof(prefix) == "table" and typeof(prefix.TagText) == "string" and typeof(prefix.TagColor) == "Color3" then
		properties.PrefixText = string.format(Configration.PrefixFormat, prefix.TagColor:ToHex(), prefix.TagText, properties.PrefixText)
	end

	-- THIS IS VERY BROKEN. DISABLED BY DEFAULT. ENABLE IN ChatColorModule IF YOU WANT TO TRY IT.
	if typeof(chatColor) == "table" and typeof(chatColor.ChatColor) == "Color3" then
		properties.Text = string.format(Configration.ChatColorFormat, chatColor.ChatColor:ToHex(), message.Text)
	end

	return properties
end