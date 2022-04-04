--[[

	Prefixes
	Azutreo : Nicholas Foreman

	A list of options and how to assign them for prefixes

--]]

local MyPrefixModule = {
	IsEnabled = true,
	Configuration = {},

	Options = {},
	Assignments = {}
}

MyPrefixModule.Configuration.UseDefaultPrefix = true
MyPrefixModule.Configuration.DefaultPrefix = {
	TagText = "[Player]",
	TagColor = Color3.fromHex("#ffffff"),
	Priority = 0
}

local Enums = require(script.Parent.Parent.Util.Enums)

export type Prefix = {
	Name: string,

	TagText: string,
	TagColor: Color3
}

MyPrefixModule.Options = {

	{
		Name = "Owner",

		TagText = "[Owner]",
		TagColor = Color3.fromHex("#af4448"), -- Dark pastel red
	},

	{
		Name = "Administrator",

		TagText = "[Admin]",
		TagColor = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Developer",

		TagText = "[Dev]",
		TagColor = Color3.fromHex("#64b5f6"), -- Light pastel blue
	},

	{
		Name = "Moderator",

		TagText = "[Mod]",
		TagColor = Color3.fromHex("#81c784"), -- Light pastel green
	},

	{
		Name = "Contributor",

		TagText = "[Contributor]",
		TagColor = Color3.fromHex("#f06292"), -- Light pastel magenta
	},

	{
		Name = "Content Creator",

		TagText = "[Content Creator]",
		TagColor = Color3.fromHex("#ffb74d"), -- Light pastel orange
	},

	{
		Name = "Tester",

		TagText = "[Tester]",
		TagColor = Color3.fromRGB(172, 137, 228), -- Roblox QA Valiant Pink (estimated)
	},

	{
		Name = "VIP",

		TagText = "[VIP]",
		TagColor = Color3.fromHex("#ffd54f"), -- Light pastel amber
	},

	{
		Name = "Group Member",

		TagText = "[Member]",
		TagColor = Color3.fromHex("#9e9e9e"), -- Light grey
	},

	{
		Name = "Roblox Employee",

		TagText = "[Roblox Employee]",
		TagColor = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Roblox Intern",

		TagText = "[Roblox Intern]",
		TagColor = Color3.fromRGB(175, 221, 255), -- Light blue
	},

	{
		Name = "Roblox Quality Assurance",

		TagText = "[Roblox QA]",
		TagColor = Color3.fromHex("#ac89e4"), -- Roblox QA Valiant Pink (estimated)
	},

	{
		Name = "Roblox Video Star",

		TagText = "[Roblox Star]",
		TagColor = Color3.fromHex("#ffb74d"), -- Valiant pink/purple
	}

}

MyPrefixModule.Assignments.Players = {

	{
		OptionName = "Contributor",

		UserId = 9221415,
		IsPlayer = true
	},

}

MyPrefixModule.Assignments.Passes = {

	{
		OptionName = "VIP",

		GamePassId = 37639178, -- Put your VIP pass id here
		HasPass = true
	},

}

MyPrefixModule.Assignments.Groups = {

	{
		OptionName = "Owner",

		GroupId = 14477910,
		Rank = 255,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Administrator",

		GroupId = 14477910,
		Rank = 250,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Developer",

		GroupId = 14477910,
		Rank = 225,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Contributor",

		GroupId = 14477910,
		Rank = 200,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Moderator",

		GroupId = 14477910,
		Rank = 175,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Tester",

		GroupId = 14477910,
		Rank = 150,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Member",

		GroupId = 14477910,
		Rank = 1,
		ComparisonType = Enums.GroupComparisonType.IS_IN_GROUP
	},

}

MyPrefixModule.Assignments.Badges = {

	{
		OptionName = "VIP",

		BadgeId = 9249849654,
		HasBadge = true
	},

}

MyPrefixModule.Assignments.Teams = {

	{
		OptionName = "Random for Testing Purposes",

		TeamName = "Random Team for Testing Purposes",
		IsOnTeam = true
	},

}

MyPrefixModule.Assignments.CollectionTags = {

	{
		OptionName = "VIP",

		CollectionTagName = "VIP",
		HasTag = true
	},

}

MyPrefixModule.Assignments.Attributes = {

	{
		OptionName = "VIP",

		AttributeName = "IsVIP",
		AttributeValue = true
	},

}

return MyPrefixModule