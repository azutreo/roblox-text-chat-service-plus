--[[

	UtilModule
	- Shared/Modules
	Azutreo : Nicholas Foreman

	Utility functions to be used by the script and other modules

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")
local BadgeService = game:GetService("BadgeService")

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
	IsPlayer: boolean -- if true, will give if matches; if false, if false, then will give if it DOESN'T match
}

export type PassReference = {
	ReferenceName: string,

	GamePassId: number,
	HasPass: boolean -- if true, will give if matches; if false, if false, then will give if it DOESN'T match
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
	HasBadge: boolean -- if true, will give if matches; if false, then will give if it DOESN'T match
}

export type TeamReference = {
	ReferenceName: string,

	TeamName: string,
	IsOnTeam: boolean -- if true, will give if player is on team; if false, will give if NOT on team
}

export type CollectionTagReference = {
	ReferenceName: string,

	CollectionTagName: string,
	HasTag: boolean -- if true, will give if matches; if false, then will give if it DOESN'T match
}

export type AttributeReference = {
	ReferenceName: string,

	AttributeName: string,
	AttributeValue: any -- value to compare to
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

MyUtilModule.GroupComparisonType = {
	IS_IN_GROUP = 0,
	IS_NOT_IN_GROUP = 1,

	EQUAL_TO = 2,
	NOT_EQUAL_TO = 3,

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
	assert(typeof(reference.UserId) == "number", "Player Reference must contain a UserId")

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

local function CheckHasPass(player: Player, reference: PlayerReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.GamePassId) == "number", "Pass Reference must contain a GamePassId")

	local success, hasPass = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(player.UserId, reference.GamePassId)
	end)

	if not success then
		return false
	end

	if hasPass then
		if reference.HasPass then
			return true
		else
			return false
		end
	elseif not reference.HasPass then
		return true
	end

	return false
end

local function CheckGroupRank(player: Player, reference: PlayerReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.GroupId) == "number", "Group Reference must contain a GroupId")
	assert(typeof(reference.Rank) == "number", "Group Reference must contain a Rank")
	assert(typeof(reference.ComparisonType) == "number", "Group Reference must contain a ComparisonType")

	if reference.ComparisonType == MyUtilModule.ComparrisonType.IS_IN_GROUP then
		local success, result = pcall(function()
			return player:IsInGroup()
		end)

		return (success and result) or false
	elseif reference.ComparisonType == MyUtilModule.ComparrisonType.IS_NOT_IN_GROUP then
		local success, result = pcall(function()
			return not player:IsInGroup()
		end)

		return (success and result) or false
	end

	local success, playerRank = pcall(function()
		return player:GetRankInGroup(reference.GroupId)
	end)

	if not success then
		warn(playerRank)
		return false
	end

	if reference.ComparisonType == MyUtilModule.ComparrisonType.EQUAL_TO then
		return playerRank == reference.Rank
	elseif reference.ComparisonType == MyUtilModule.ComparrisonType.NOT_EQUAL_TO then
		return playerRank ~= reference.Rank
	elseif reference.ComparisonType == MyUtilModule.ComparrisonType.LESS_THAN then
		return playerRank < reference.Rank
	elseif reference.ComparisonType == MyUtilModule.ComparrisonType.LESS_THAN_OR_EQUAL_TO then
		return playerRank <= reference.Rank
	elseif reference.ComparisonType == MyUtilModule.ComparrisonType.GREATER_THAN then
		return playerRank > reference.Rank
	elseif reference.ComparisonType == MyUtilModule.ComparrisonType.GREATER_THAN_OR_EQUAL_TO then
		return playerRank >= reference.Rank
	end

	return false
end

local function CheckHasBadge(player: Player, reference: PlayerReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.BadgeId) == "number", "Badge Reference must contain a BadgeId")

	local success, hasBadge = pcall(function()
		return BadgeService:UserHasBadgeAsync(player.UserId, reference.BadgeId)
	end)

	if not success then
		return false
	end

	if hasBadge then
		if reference.HasBadge then
			return true
		else
			return false
		end
	elseif not reference.HasBadge then
		return true
	end

	return false
end

local function CheckTeam(player: Player, reference: TeamReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.TeamName) == "string", "Team Reference must contain a TeamName")

	if typeof(player.Team) == "nil" then
		return not reference.IsOnTeam
	end

	if player.Team.Name == reference.TeamName then
		if reference.IsOnTeam then
			return true
		else
			return false
		end
	elseif not reference.IsOnTeam then
		return true
	end

	return false
end

local function CheckHasTag(player: Player, reference: PlayerReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.CollectionTagName) == "string", "CollectionTag Reference must contain a CollectionTagName")

	local hasTag = CollectionService:HasTag(player, reference.CollectionTagName)

	if hasTag then
		if reference.HasTag then
			return true
		else
			return false
		end
	elseif not reference.HasTag then
		return true
	end

	return false
end

local function CheckAttribute(player: Player, reference: PlayerReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.AttributeName) == "string", "Attribute Reference must contain a AttributeName")

	local attributeValue = player:GetAttribute(reference.AttributeName)

	if attributeValue == reference.AttributeValue then
		if reference.HasTag then
			return true
		else
			return false
		end
	elseif not reference.HasTag then
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
			hasOption = CheckHasPass(player, reference)
		elseif referenceType == "Groups" then
			hasOption = CheckGroupRank(player, reference)
		elseif referenceType == "Badges" then
			hasOption = CheckHasBadge(player, reference)
		elseif referenceType == "Teams" then
			hasOption = CheckTeam(player, reference)
		elseif referenceType == "CollectionTags" then
			hasOption = CheckHasTag(player, reference)
		elseif referenceType == "Attributes" then
			hasOption = CheckAttribute(player, reference)
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
	if references.Passes then
		highestOption = self:GetHighestOption("Passes", player, references.Passes, options, highestOption)
	end
	if references.Groups then
		highestOption = self:GetHighestOption("Groups", player, references.Groups, options, highestOption)
	end
	if references.Badges then
		highestOption = self:GetHighestOption("Badges", player, references.Badges, options, highestOption)
	end
	if references.Teams then
		highestOption = self:GetHighestOption("Teams", player, references.Teams, options, highestOption)
	end
	if references.CollectionTags then
		highestOption = self:GetHighestOption("CollectionTags", player, references.CollectionTags, options, highestOption)
	end
	if references.Attributes then
		highestOption = self:GetHighestOption("Attributes", player, references.Attributes, options, highestOption)
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