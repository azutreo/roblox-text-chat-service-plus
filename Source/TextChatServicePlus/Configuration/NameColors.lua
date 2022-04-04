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
	Name: string,
	NameColor: Color3
}

MyNameColorModule.Options = {

	{
		Name = "Owner",
		NameColor = Color3.fromHex("#af4448"), -- Dark pastel red
	},

	{
		Name = "Administrator",
		NameColor = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Developer",
		NameColor = Color3.fromHex("#64b5f6"), -- Light pastel blue
	},

	{
		Name = "Moderator",
		NameColor = Color3.fromHex("#81c784"), -- Light pastel green
	},

	{
		Name = "Contributor",
		NameColor = Color3.fromHex("#f06292"), -- Light pastel magenta
	},

	{
		Name = "Roblox Staff",
		NameColor = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Roblox Intern",
		NameColor = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Roblox Star",
		NameColor = Color3.fromHex("#ffb74d"), -- Light pastel orange
	},

	{
		Name = "Tester",
		NameColor = Color3.fromRGB(172, 137, 228), -- Roblox QA Valiant pink (estimated)
	},

	{
		Name = "VIP",
		NameColor = Color3.fromHex("#ffd54f"), -- Light pastel amber
	},

	{
		Name = "Group Member",
		NameColor = Color3.fromHex("#9e9e9e"), -- Light grey
	},

	{
		Name = "Random for Example Purposes",
		NameColor = Color3.fromHex("#f06292"), -- Light pastel magenta
	}

}

MyNameColorModule.Assignments.Players = {

	{
		OptionName = "Contributor",

		UserId = 9221415, -- https://www.roblox.com/users/9221415/profile
		IsPlayer = true
	},

}

MyNameColorModule.Assignments.Passes = {

	{
		OptionName = "VIP",

		GamePassId = 37639178, -- https://www.roblox.com/game-pass/37639178/Sample-Pass
		HasPass = true
	},

}

MyNameColorModule.Assignments.Groups = {

	{
		OptionName = "Owner",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 255,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Administrator",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 250,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Developer",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 225,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Contributor",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 200,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Moderator",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 175,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Tester",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 150,
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Member",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 1,
		ComparisonType = Enums.GroupComparisonType.IS_IN_GROUP
	},

}

MyNameColorModule.Assignments.Badges = {

	{
		OptionName = "Random for Example Purposes",

		BadgeId = 9249849654, -- https://www.roblox.com/badges/2125764099/Sample-Badge
		HasBadge = true
	},

}

MyNameColorModule.Assignments.Teams = {

	{
		OptionName = "Random for Example Purposes",

		TeamName = "Random for Example Purposes",
		IsOnTeam = true
	},

}

MyNameColorModule.Assignments.CollectionTags = {

	{
		OptionName = "Random for Example Purposes",

		CollectionTagName = "RandomExampleTag",
		HasTag = true
	},

}

MyNameColorModule.Assignments.Attributes = {

	{
		OptionName = "Random for Example Purposes",

		AttributeName = "RandomExampleAttribute",
		AttributeValue = true
	},

}

return MyNameColorModule