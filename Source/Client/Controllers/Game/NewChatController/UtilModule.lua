--[[

	UtilModule
	- Shared/Modules
	Nicholas Foreman

	Description of Module

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit = require(ReplicatedStorage.Packages.Knit)

-------------------
-- CREATE MODULE --
-------------------

local MyUtilModule = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

export type Reference = {
	ReferenceName: string
}

export type PlayerReference = {
	ReferenceName: string,

	UserId: number,
	IsPlayer: boolean -- if true, gives prefix if matches; if false, then gives prefix if it DOESN'T match
}

export type PassReference = {
	ReferenceName: string,

	GamePassId: number,
	HasPass: boolean -- if true, gives prefix if matches; if false, then gives prefix if it DOESN'T match
}

export type GroupReference = {
	ReferenceName: string,

	GroupId: number,
	Rank: number,
	ComparrisonType: number
}

export type BadgeReference = {
	ReferenceName: string,

	BadgeId: number,
	HasBadge: boolean -- if true, gives prefix if matches; if false, then gives prefix if it DOESN'T match
}

export type CollectionTagReference = {
	ReferenceName: string,

	CollectionTagName: string,
	HasTag: boolean -- if true, gives prefix if matches; if false, then gives prefix if it DOESN'T match
}

export type AttributeReference = {
	ReferenceName: string,

	AttributeName: string,
	AttributeValue: any -- value to match to
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

MyUtilModule.GroupComparisonType = {
	IS_NOT_IN_GROUP = 0,
	IS_IN_GROUP = 1,
	NOT_EQUAL_TO = 2,
	EQUAL_TO = 3,
	LESS_THAN = 4,
	LESS_THAN_OR_EQUAL_TO = 5,
	GREATER_THAN = 6,
	GREATER_THAN_OR_EQUAL_TO = 7,
}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function AssertReference(player: Player, reference: Reference): any
	if not MyUtilModule:CheckIsPlayerValid(player) then
		return false, "Player must be a Player Instance"
	elseif typeof(reference) ~= "table" then
		return false, "Reference must be a Reference table"
	end

	return true, ""
end

local function CheckReference(reference: Reference, options: {table})
	assert(typeof(reference.ReferenceName), "Reference missing a name")

	return options[reference.ReferenceName]
end

local function CheckIsPlayer(player: Player, reference: PlayerReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.UserId) == "number", "Player Reference must contain a UserId to compare")

	if player.UserId == reference.UserId then
		if reference.IsPlayer then
			return true
		else
			return false
		end
	elseif not reference.IsPlayer then
		return true
	end

	return false
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyUtilModule:CheckIsPlayerValid(player: Player)
	return typeof(player) == "Instance" and player:IsDescendantOf(Players)
end

function MyUtilModule:GetHighestOption(
		referenceType: string,
		player: Player,
		references: {PlayerReference},
		options: {table},
		highestOption: table?
	): {any}?

	assert(AssertReference(player, references))
	assert(typeof(referenceType) == "string", "Reference type must be a string")

	local function CheckOption(option: {any}): nil
		if typeof(highestOption) == "table" then
			if option.Priority < highestOption.Priority then
				highestOption = option
			end
		else
			highestOption = option
		end

		return nil
	end

	local function CheckReferenceType(reference: Reference): {any}?
		local option = CheckReference(reference, options)
		if not option then
			return nil
		end

		local hasOption = false

		if referenceType == "Players" then
			hasOption = CheckIsPlayer(player, reference)
		elseif referenceType == "Passes" then
			-- hasOption = CheckHasPass(player, reference)
		elseif referenceType == "Groups" then
			-- hasOption = CheckGroupRank(player, reference)
		elseif referenceType == "Badges" then
			-- hasOption = CheckHasBadge(player, reference)
		elseif referenceType == "CollectionTags" then
			-- hasOption = CheckHasTag(player, reference)
		elseif referenceType == "Attributes" then
			-- hasOption = CheckAttribute(player, reference)
		end

		if hasOption then
			return option
		end

		return nil
	end

	for _, reference: Reference in ipairs(references) do
		local option: {any} = CheckReferenceType(reference)

		if typeof(option) == "table" then
			CheckOption(option)
		end
	end

	return highestOption
end

function MyUtilModule:CompareReferences(player: Player, references: {table}, options: {table}): table?
	assert(AssertReference(player, references))
	assert(typeof(options) == "table", "Options must be a table")

	local highestOption: table?

	if references.Players then
		highestOption = self:GetHighestOption("Players", player, references.Players, options, highestOption)
	end

	return highestOption
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

return MyUtilModule