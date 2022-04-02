--[[

	PrefixModule
	- Shared/Modules
	Azutreo : Nicholas Foreman

	A list of options and how to assign them for prefixes

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
local UtilModule = require(script.Parent.UtilModule)

-------------------
-- CREATE MODULE --
-------------------

local MyPrefixModule = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

local IS_ENABLED: boolean = true

-- Set to true if you want to enable a prefix being used when none is already assigned to the player
local USE_DEFAULT_PREFIX: boolean = false

-- Default prefix to be used if enabled and there is not one assigned to the player already
local PREFIX_DEFAULT: Prefix = {
	TagText = "[Player]",
	TagColor = Color3.fromHex("#ffffff"),
	Priority = 0
}

export type Prefix = {
	TagText: string,
	TagColor: Color3,

	Priority: number
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

MyPrefixModule.Options = {

	["Owner"] = {
		TagText = "[Owner]",
		TagColor = Color3.fromHex("#af4448"), -- Dark pastel red

		Priority = 1
	},

	["Administrator"] = {
		TagText = "[Admin]",
		TagColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 2
	},

	["Developer"] = {
		TagText = "[Dev]",
		TagColor = Color3.fromHex("#64b5f6"), -- Light pastel blue

		Priority = 3
	},

	["Moderator"] = {
		TagText = "[Mod]",
		TagColor = Color3.fromHex("#81c784"), -- Light pastel green

		Priority = 4
	},

	["Contributor"] = {
		TagText = "[Contributor]",
		TagColor = Color3.fromHex("#f06292"), -- Light pastel magenta

		Priority = 5
	},

	["Roblox Staff"] = {
		TagText = "[Roblox]",
		TagColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 6
	},

	["Roblox Intern"] = {
		TagText = "[Roblox]",
		TagColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 7
	},

	["Roblox Star"] = {
		TagText = "[Star]",
		TagColor = Color3.fromHex("#ffb74d"), -- Light pastel orange

		Priority = 8
	},

	["Tester"] = {
		TagText = "[Tester]",
		TagColor = Color3.fromRGB(172, 137, 228), -- Roblox QA Valiant Pink (estimated)

		Priority = 9
	},

	["VIP"] = {
		TagText = "[VIP]",
		TagColor = Color3.fromHex("#ffd54f"), -- Light pastel amber

		Priority = 10
	},

	["Group Member"] = {
		TagText = "[Member]",
		TagColor = Color3.fromHex("#9e9e9e"), -- Light grey

		Priority = 11
	}

}

MyPrefixModule.References = {}

MyPrefixModule.References.Players = {

	{
		ReferenceName = "Contributor",

		UserId = 9221415,
		IsPlayer = true
	},

}

MyPrefixModule.References.Passes = {

	{
		ReferenceName = "VIP",

		GamePassId = 37639178, -- Put your VIP pass id here
		HasPass = true
	},

}

MyPrefixModule.References.Groups = {

	{
		ReferenceName = "Owner",

		GroupId = 14477910,
		Rank = 255,
		ComparisonType = UtilModule.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Administrator",

		GroupId = 14477910,
		Rank = 250,
		ComparisonType = UtilModule.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Developer",

		GroupId = 14477910,
		Rank = 225,
		ComparisonType = UtilModule.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Contributor",

		GroupId = 14477910,
		Rank = 200,
		ComparisonType = UtilModule.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Moderator",

		GroupId = 14477910,
		Rank = 175,
		ComparisonType = UtilModule.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Tester",

		GroupId = 14477910,
		Rank = 150,
		ComparisonType = UtilModule.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO
	},

	{
		ReferenceName = "Member",

		GroupId = 14477910,
		Rank = 1,
		ComparisonType = UtilModule.GroupComparisonType.IS_IN_GROUP
	},

}

MyPrefixModule.References.Badges = {

	{
		ReferenceName = "VIP",

		BadgeId = 9249849654,
		HasBadge = true
	},

}

MyPrefixModule.References.Teams = {

	{
		ReferenceName = "Random for Testing Purposes",

		TeamName = "Random Team for Testing Purposes",
		IsOnTeam = true
	},

}

MyPrefixModule.References.CollectionTags = {

	{
		ReferenceName = "VIP",

		CollectionTagName = "VIP",
		HasTag = true
	},

}

MyPrefixModule.References.Attributes = {

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

function MyPrefixModule:GetPrefixForPlayer(player: Player): Prefix?
	if not IS_ENABLED then
		return nil
	end

	local prefix = UtilModule:CompareReferences(player, MyPrefixModule.References, MyPrefixModule.Options)

	if typeof(prefix) == "table" then
		return prefix
	end

	return USE_DEFAULT_PREFIX and PREFIX_DEFAULT or nil
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