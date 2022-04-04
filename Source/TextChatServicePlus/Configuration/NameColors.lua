--[[

	NameColors
	Azutreo : Nicholas Foreman

	A list of options and how to assign them for name colors
	Uses the old Roblox method of getting name color for classic purposes if desired

--]]

local MyNameColorModule = {
	IsEnabled = true,
	Configuration = {},

	Options = {},
	Assignments = {}
}

MyNameColorModule.Configuration.UseTeamColor = true
MyNameColorModule.Configuration.UseClassicNameColor = true
MyNameColorModule.Configuration.DefaultColor = Color3.fromRGB(170, 170, 170)

local Enums = require(script.Parent.Parent.Util.Enums)

export type NameColor = {
	NameColor: Color3,
	Priority: number
}

MyNameColorModule.Options = {

	["Owner"] = {
		NameColor = Color3.fromHex("#af4448"), -- Dark pastel red

		Priority = 1
	},

	["Administrator"] = {
		NameColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 2
	},

	["Developer"] = {
		NameColor = Color3.fromHex("#64b5f6"), -- Light pastel blue

		Priority = 3
	},

	["Moderator"] = {
		NameColor = Color3.fromHex("#81c784"), -- Light pastel green

		Priority = 4
	},

	["Contributor"] = {
		NameColor = Color3.fromHex("#f06292"), -- Light pastel magenta

		Priority = 5
	},

	["Roblox Staff"] = {
		NameColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 6
	},

	["Roblox Intern"] = {
		NameColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 7
	},

	["Roblox Star"] = {
		NameColor = Color3.fromHex("#ffb74d"), -- Light pastel orange

		Priority = 8
	},

	["Tester"] = {
		NameColor = Color3.fromRGB(172, 137, 228), -- Roblox QA Valiant Pink (estimated)

		Priority = 9
	},

	["VIP"] = {
		NameColor = Color3.fromHex("#ffd54f"), -- Light pastel amber

		Priority = 10
	},

	["Group Member"] = {
		NameColor = Color3.fromHex("#9e9e9e"), -- Light grey

		Priority = 11
	},

	["Random for Testing Purposes"] = {
		NameColor = Color3.fromHex("#f06292"), -- Light pastel magenta

		Priority = 12
	}

}

MyNameColorModule.Assignments.Players = {

	{
		ReferenceName = "Contributor",

		UserId = 9221415,
		IsPlayer = true
	},

}

MyNameColorModule.Assignments.Passes = {

	{
		ReferenceName = "VIP",

		GamePassId = 37639178, -- Put your VIP pass id here
		HasPass = true
	},

}

MyNameColorModule.Assignments.Groups = {

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

MyNameColorModule.Assignments.Badges = {

	{
		ReferenceName = "VIP",

		BadgeId = 9249849654,
		HasBadge = true
	},

}

MyNameColorModule.Assignments.Teams = {

	{
		ReferenceName = "Random for Testing Purposes",

		TeamName = "Random Team for Testing Purposes",
		IsOnTeam = true
	},

}

MyNameColorModule.Assignments.CollectionTags = {

	{
		ReferenceName = "VIP",

		CollectionTagName = "VIP",
		HasTag = true
	},

}

MyNameColorModule.Assignments.Attributes = {

	{
		ReferenceName = "VIP",

		AttributeName = "IsVIP",
		AttributeValue = true
	},

}

return MyNameColorModule