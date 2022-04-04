--[[

	Prefixes
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	A list of options and how to assign them for prefixes

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

local Prefixes = {
	IsEnabled = true,
	Configuration = {},

	Options = {},
	Assignments = {}
}

------------------------
-- PRIVATE PROPERTIES --
------------------------

export type Prefix = {
	Name: string,
	Text: string,
	Color: Color3
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-- Configuration

Prefixes.Configuration.UseDefaultPrefix = true
Prefixes.Configuration.DefaultPrefix = {
	Name = "Default",
	Text = "[Player]",
	Color = Color3.fromRGB(170, 170, 170),
}

-- Prefix Options

Prefixes.Options = {

	{
		Name = "Owner",
		Text = "[Owner]",
		Color = Color3.fromHex("#af4448"), -- Dark pastel red
	},

	{
		Name = "Administrator",
		Text = "[Admin]",
		Color = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Developer",
		Text = "[Dev]",
		Color = Color3.fromHex("#64b5f6"), -- Light pastel blue
	},

	{
		Name = "Moderator",
		Text = "[Mod]",
		Color = Color3.fromHex("#81c784"), -- Light pastel green
	},

	{
		Name = "Contributor",
		Text = "[Contributor]",
		Color = Color3.fromHex("#f06292"), -- Light pastel magenta
	},

	{
		Name = "Content Creator",
		Text = "[Content Creator]",
		Color = Color3.fromHex("#ffb74d"), -- Light pastel orange
	},

	{
		Name = "Tester",
		Text = "[Tester]",
		Color = Color3.fromHex("#ac89e4"), -- Roblox QA Valiant pink (estimated)
	},

	{
		Name = "VIP",
		Text = "[VIP]",
		Color = Color3.fromHex("#ffd54f"), -- Light pastel amber
	},

	{
		Name = "Group Member",
		Text = "[Member]",
		Color = Color3.fromHex("#9e9e9e"), -- Light grey
	},

	{
		Name = "Roblox Employee",
		Text = "[Roblox Employee]",
		Color = Color3.fromHex("#e57373"), -- Light pastel red
	},

	{
		Name = "Roblox Intern",
		Text = "[Roblox Intern]",
		Color = Color3.fromRGB(175, 221, 255), -- Classic intern blue
	},

	{
		Name = "Roblox Quality Assurance",
		Text = "[Roblox QA]",
		Color = Color3.fromHex("#ac89e4"), -- Roblox QA Valiant Pink (estimated)
	},

	{
		Name = "Roblox Video Star",
		Text = "[Roblox Star]",
		Color = Color3.fromHex("#ffb74d"), -- Light pastel amber
	},

	{
		Name = "Random for Example Purposes",
		Text = "[Example]",
		Color = Color3.fromHex("#f06292"), -- Light pastel magenta
	}

}

-- Prefix Assignments

Prefixes.Assignments.Players = {

	{
		OptionName = "Contributor",

		UserId = 9221415, -- https://www.roblox.com/users/9221415/profile
		IsPlayer = true
	},

}

Prefixes.Assignments.Passes = {

	{
		OptionName = "VIP",

		GamePassId = 37639178, -- https://www.roblox.com/game-pass/37639178/Sample-Pass
		HasPass = true
	},

}

Prefixes.Assignments.Groups = {

	{
		OptionName = "Owner",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 255, -- 255 Owner
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Administrator",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 250, -- 250 Administrator
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Developer",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 225, -- 225 Developer
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Contributor",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 200, -- 200 Contributor
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Moderator",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 175, -- 175 Moderator
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Tester",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 150, -- 150 Tester
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Member",

		GroupId = 14477910, -- https://www.roblox.com/groups/14477910/Sample-Group-With-Ranks
		Rank = 1, -- 001 Member
		ComparisonType = Enums.GroupComparisonType.IS_IN_GROUP
	},

}

Prefixes.Assignments.Badges = {

	{
		OptionName = "Random for Example Purposes",

		BadgeId = 9249849654, -- https://www.roblox.com/badges/2125764099/Sample-Badge
		HasBadge = true
	},

}

Prefixes.Assignments.Teams = {

	{
		OptionName = "Random for Example Purposes",

		TeamName = "Random for Example Purposes",
		IsOnTeam = true
	},

}

Prefixes.Assignments.CollectionTags = {

	{
		OptionName = "Random for Example Purposes",

		CollectionTagName = "RandomExampleTag",
		HasTag = true
	},

}

Prefixes.Assignments.Attributes = {

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

return Prefixes