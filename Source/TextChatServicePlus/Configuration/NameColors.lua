--[[

	NameColors
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	A list of options and how to assign them for name colors
	Uses the old Roblox method of getting name color for classic purposes if desired

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- local Knit = require(ReplicatedStorage.Packages.Knit)
local Enums = require(script.Parent.Parent.Util.Enums) -- Avoid cyclic table reference

-------------------
-- CREATE MODULE --
-------------------

local NameColors = {
	IsEnabled = true,
	Configuration = {},

	Options = {},
	Assignments = {}
}

------------------------
-- PRIVATE PROPERTIES --
------------------------

export type NameColor = {
	Name: string,
	Color: Color3
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-- Configuration

NameColors.Configuration.UseTeamColor = true
NameColors.Configuration.UseClassicNameColor = true
NameColors.Configuration.DefaultColor = Color3.fromRGB(170, 170, 170)

-- Name color options

NameColors.Options = {

	{
		Name = "Owner",
		Color = Color3.fromHex("#af4448"), -- Dark pastel red
	},

	{
		Name = "Administrator",
		Color = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Developer",
		Color = Color3.fromHex("#64b5f6"), -- Light pastel blue
	},

	{
		Name = "Moderator",
		Color = Color3.fromHex("#81c784"), -- Light pastel green
	},

	{
		Name = "Contributor",
		Color = Color3.fromHex("#f06292"), -- Light pastel magenta
	},

	{
		Name = "Roblox Staff",
		Color = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Roblox Intern",
		Color = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Roblox Star",
		Color = Color3.fromHex("#ffb74d"), -- Light pastel orange
	},

	{
		Name = "Tester",
		Color = Color3.fromRGB(172, 137, 228), -- Roblox QA Valiant pink (estimated)
	},

	{
		Name = "VIP",
		Color = Color3.fromHex("#ffd54f"), -- Light pastel amber
	},

	{
		Name = "Group Member",
		Color = Color3.fromHex("#9e9e9e"), -- Light grey
	},

	{
		Name = "Random for Example Purposes",
		Color = Color3.fromHex("#f06292"), -- Light pastel magenta
	}

}

-- Name color assignments

NameColors.Assignments.Players = {

	{
		OptionName = "Contributor",

		UserId = 9221415, -- https://www.roblox.com/users/9221415/profile
		IsPlayer = true
	},

}

NameColors.Assignments.Passes = {

	{
		OptionName = "VIP",

		GamePassId = 37639178, -- https://www.roblox.com/game-pass/37639178/Sample-Pass
		HasPass = true
	},

}

NameColors.Assignments.Groups = {

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

NameColors.Assignments.Badges = {

	{
		OptionName = "Random for Example Purposes",

		BadgeId = 9249849654, -- https://www.roblox.com/badges/2125764099/Sample-Badge
		HasBadge = true
	},

}

NameColors.Assignments.Teams = {

	{
		OptionName = "Random for Example Purposes",

		TeamName = "Random for Example Purposes",
		IsOnTeam = true
	},

}

NameColors.Assignments.CollectionTags = {

	{
		OptionName = "Random for Example Purposes",

		CollectionTagName = "RandomExampleTag",
		HasTag = true
	},

}

NameColors.Assignments.Attributes = {

	{
		OptionName = "Random for Example Purposes",

		AttributeName = "RandomExampleAttribute",
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

-------------------
-- RETURN MODULE --
-------------------

return NameColors