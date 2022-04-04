--[[

	ChatColors
	Azutreo : Nicholas Foreman

	A list of options and how to assign them for chat colors
	Doesn't work well with the new Roblox chat system YET due to chat bubbles
	Any additional assistance apprecaited :D

--]]

local MyChatColorModule = {
	IsEnabled = false,
	Configuration = {},

	Options = {},
	Assignments = {}
}

MyChatColorModule.Configuration.DefaultColor = Color3.fromRGB(255, 255, 255)

export type ChatColor = {
	ChatColor: Color3,
	Priority: number
}

local Enums = require(script.Parent.Parent.Util.Enums)

MyChatColorModule.Options = {

	["Owner"] = {
		ChatColor = Color3.fromHex("#af4448"), -- Dark pastel red

		Priority = 1
	},

	["Administrator"] = {
		ChatColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 2
	},

	["Developer"] = {
		ChatColor = Color3.fromHex("#64b5f6"), -- Light pastel blue

		Priority = 3
	},

	["Moderator"] = {
		ChatColor = Color3.fromHex("#81c784"), -- Light pastel green

		Priority = 4
	},

	["Contributor"] = {
		ChatColor = Color3.fromHex("#f06292"), -- Light pastel magenta

		Priority = 5
	},

	["Roblox Staff"] = {
		ChatColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 6
	},

	["Roblox Intern"] = {
		ChatColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 7
	},

	["Roblox Star"] = {
		ChatColor = Color3.fromHex("#ffb74d"), -- Light pastel orange

		Priority = 8
	},

	["Tester"] = {
		ChatColor = Color3.fromRGB(172, 137, 228), -- Roblox QA Valiant Pink (estimated)

		Priority = 9
	},

	["VIP"] = {
		ChatColor = Color3.fromHex("#ffd54f"), -- Light pastel amber

		Priority = 10
	},

	["Group Member"] = {
		ChatColor = Color3.fromHex("#9e9e9e"), -- Light grey

		Priority = 11
	}

}

MyChatColorModule.Assignments.Players = {

	{
		ReferenceName = "Contributor",

		UserId = 9221415,
		IsPlayer = true
	},

}

MyChatColorModule.Assignments.Passes = {

	{
		ReferenceName = "VIP",

		GamePassId = 37639178, -- Put your VIP pass id here
		HasPass = true
	},

}

MyChatColorModule.Assignments.Groups = {

	{
		ReferenceName = "Owner",

		GroupId = 14477910,
		Rank = 255,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Administrator",

		GroupId = 14477910,
		Rank = 250,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Developer",

		GroupId = 14477910,
		Rank = 225,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Contributor",

		GroupId = 14477910,
		Rank = 200,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Moderator",

		GroupId = 14477910,
		Rank = 175,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Tester",

		GroupId = 14477910,
		Rank = 150,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Member",

		GroupId = 14477910,
		Rank = 1,
		ComparisonType = Enums.GroupComparisonType.IS_IN_GROUP
	},

}

MyChatColorModule.Assignments.Badges = {

	{
		ReferenceName = "VIP",

		BadgeId = 9249849654,
		HasBadge = true
	},

}

MyChatColorModule.Assignments.Teams = {

	{
		ReferenceName = "Random for Testing Purposes",

		TeamName = "Random Team for Testing Purposes",
		IsOnTeam = true
	},

}

MyChatColorModule.Assignments.CollectionTags = {

	{
		ReferenceName = "VIP",

		CollectionTagName = "VIP",
		HasTag = true
	},

}

MyChatColorModule.Assignments.Attributes = {

	{
		ReferenceName = "VIP",

		AttributeName = "IsVIP",
		AttributeValue = true
	},

}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-- Commented for public module
--[[Knit.OnStart:andThen(function()
	-- Do stuff
end):catch(warn)]]

-------------------
-- RETURN MODULE --
-------------------

return MyChatColorModule