--[[

	ChatColors
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	A list of options and how to assign them for chat colors
	Doesn't work well with the new Roblox chat system YET due to chat bubbles
	Any additional assistance apprecaited :D

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

local ChatColors = {
	IsEnabled = false,
	Configuration = {},

	Options = {},
	Assignments = {}
}

------------------------
-- PRIVATE PROPERTIES --
------------------------

export type ChatColor = {
	Name: string,
	ChatColor: Color3
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-- Configuration

ChatColors.Configuration.DefaultColor = Color3.fromRGB(255, 255, 255)

-- Chat color options

ChatColors.Options = {

	{
		Name = "Roblox Employee",
		ChatColor = Color3.fromRGB(255, 215, 0), -- Classic admin yellow
	},

	{
		Name = "Roblox Intern",
		ChatColor = Color3.fromRGB(175, 221, 255), -- Classic intern blue
	},

	{
		Name = "Roblox Quality Assurance",
		ChatColor = Color3.fromRGB(175, 221, 255), -- Classic intern blue
	},

}

-- Chat color assignments

ChatColors.Assignments.Players = {

}

ChatColors.Assignments.Passes = {

}

ChatColors.Assignments.Groups = {

	{
		OptionName = "Roblox Employee",

		GroupId = 1200769, -- https://www.roblox.com/groups/1200769/Official-Group-of-Roblox
		Rank = 71, -- Employee
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Roblox Intern",

		GroupId = 1200769, -- https://www.roblox.com/groups/1200769/Official-Group-of-Roblox
		Rank = 1, -- Intern
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Roblox Intern",

		GroupId = 2868472, -- https://www.roblox.com/groups/2868472/Roblox-Interns
		Rank = 106, -- Accelerator
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		OptionName = "Roblox Quality Assurance",

		GroupId = 3055661, -- https://www.roblox.com/groups/3055661/Roblox-Community-QA-Team
		Rank = 1, -- Verified Tester
		ComparisonType = Enums.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

}

ChatColors.Assignments.Badges = {

}

ChatColors.Assignments.Teams = {

}

ChatColors.Assignments.CollectionTags = {

}

ChatColors.Assignments.Attributes = {

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

return ChatColors