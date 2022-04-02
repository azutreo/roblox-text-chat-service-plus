--[[

	PrefixModule
	- Shared/Modules
	Azutreo : Nicholas Foreman

	Description of Module

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- Commented since this is going to the public
-- local Knit = require(ReplicatedStorage.Packages.Knit)

-------------------
-- CREATE MODULE --
-------------------

local MyPrefixModule = {}

---------------
-- CONSTANTS --
---------------

------------------------
-- PRIVATE PROPERTIES --
------------------------

local GroupComparisonType = {
	IS_NOT_IN_GROUP = 0,
	IS_IN_GROUP = 1,
	NOT_EQUAL_TO = 2,
	EQUAL_TO = 3,
	LESS_THAN = 4,
	LESS_THAN_OR_EQUAL_TO = 5,
	GREATER_THAN = 6,
	GREATER_THAN_OR_EQUAL_TO = 7,
}

export type Prefix = {
	TagText: string,
	TagColor: Color3
}

export type PlayerPrefix = {
	PrefixName: string,

	UserId: number,
	IsPlayer: boolean -- if true, gives prefix if matches; if false, then gives prefix if it DOESN'T match
}

export type PassPrefix = {
	PrefixName: string,

	GamePassId: number,
	HasPass: boolean -- if true, gives prefix if matches; if false, then gives prefix if it DOESN'T match
}

export type GroupPrefix = {
	PrefixName: string,

	GroupId: number,
	Rank: number,
	ComparrisonType: number
}

export type BadgePrefix = {
	PrefixName: string,

	BadgeId: number,
	HasBadge: boolean -- if true, gives prefix if matches; if false, then gives prefix if it DOESN'T match
}

export type CollectionTagPrefix = {
	PrefixName: string,

	CollectionTagName: string,
	HasTag: boolean -- if true, gives prefix if matches; if false, then gives prefix if it DOESN'T match
}

export type AttributePrefix = {
	PrefixName: string,

	AttributeName: string,
	AttributeValue: any -- value to match to
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

MyPrefixModule.Prefixes = {}

MyPrefixModule.PrefixList = {

	["Owner"] = {
		TagText = "[Owner]",
		TagColor = Color3.fromHex("#af4448"), -- Dark pastel red
	},

	["Administrator"] = {
		TagText = "[Admin]",
		TagColor = Color3.fromHex("#e57373"), -- Light pastel red
	},

	["Developer"] = {
		TagText = "[Dev]",
		TagColor = Color3.fromHex("#64b5f6"), -- Light pastel blue
	},

	["Moderator"] = {
		TagText = "[Mod]",
		TagColor = Color3.fromHex("#81c784"), -- Light pastel green
	},

	["Contributor"] = {
		TagText = "[Contributor]",
		TagColor = Color3.fromHex("#f06292"), -- Light pastel magenta
	},

	["Roblox Staff"] = {
		TagText = "[Roblox]",
		TagColor = Color3.fromHex("#e57373"), -- Light pastel red
	},

	["Roblox Intern"] = {
		TagText = "[Roblox]",
		TagColor = Color3.fromHex("#e57373"), -- Light pastel red
	},

	["Roblox Star"] = {
		TagText = "[Star]",
		TagColor = Color3.fromHex("#ffb74d"), -- Light pastel orange
	},

	["Tester"] = {
		TagText = "[Tester]",
		TagColor = Color3.fromRGB(172, 137, 228), -- Roblox QA Valiant Pink (estimated)
	},

	["VIP"] = {
		TagText = "[VIP]",
		TagColor = Color3.fromHex("#ffd54f"), -- Light pastel amber
	},

	["Group Member"] = {
		TagText = "[Member]",
		TagColor = Color3.fromHex("#9e9e9e"), -- Light grey
	}

}

MyPrefixModule.Prefixes.Players = {

	{
		PrefixName = "Contributor",

		PlayerId = 9221415,
		IsPlayer = true
	},

}

MyPrefixModule.Prefixes.Passes = {

	{
		PrefixName = "VIP",

		GamePassId = 37639178, -- Put your VIP pass id here
		HasPass = true
	},

}

MyPrefixModule.Prefixes.Groups = {

	{
		PrefixName = "Owner",

		GroupId = 14477910,
		Rank = 255,
		ComparrisonType = GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		PrefixName = "Administrator",

		GroupId = 14477910,
		Rank = 250,
		ComparrisonType = GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		PrefixName = "Developer",

		GroupId = 14477910,
		Rank = 225,
		ComparrisonType = GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		PrefixName = "Contributor",

		GroupId = 14477910,
		Rank = 200,
		ComparrisonType = GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		PrefixName = "Moderator",

		GroupId = 14477910,
		Rank = 175,
		ComparrisonType = GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		PrefixName = "Tester",

		GroupId = 14477910,
		Rank = 150,
		ComparrisonType = GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		PrefixName = "Member",

		GroupId = 14477910,
		Rank = 1,
		ComparrisonType = GroupComparisonType.IS_IN_GROUP
	},

}

MyPrefixModule.Prefixes.Badges = {

	{
		PrefixName = "VIP",

		BadgeId = 9249849654,
		HasBadge = true,
	},

}

MyPrefixModule.Prefixes.CollectionTags = {

	{
		PrefixName = "VIP",

		CollectionTagName = "VIP",
		HasTag = true,
	},

}

MyPrefixModule.Prefixes.Attributes = {

	{
		PrefixName = "VIP",

		AttributeName = "IsVIP",
		AttributeValue = true,
	},

}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyPrefixModule:GetPrefixForPlayer(player: Player): Prefix
	local prefix = {
		TagText = "DEV",
		TagColor = Color3.fromHex("#64b5f6")
	}

	prefix.NotDefault = true

	return prefix
end

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

return MyPrefixModule