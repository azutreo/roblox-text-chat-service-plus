--[[

	UtilModule
	Azutreo : Nicholas Foreman

	Utility functions to be used by the script and other modules

--]]

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")
local BadgeService = game:GetService("BadgeService")

local MyUtilModule = {}

local CACHE_UPDATE_TIME = 30

export type CachedResult = {
	Value: any,
	LastUpdate: number
}

export type GroupCachedResult = {
	IsInGroup: boolean,
	GroupRank: number,
	LastUpdate: number
}

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

local playerCache = {}

local function OnPlayerAdded(player: Player): nil
	playerCache[player] = {
		IsUpdating = false,
		Groups = {},
		Passes = {},
		Badges = {}
	}

	return nil
end

local function OnPlayerRemoving(player: Player): nil
	playerCache[player] = nil

	return nil
end

local function AssertReference(player: Player, reference: Reference): any
	if not MyUtilModule:CheckIsPlayerValid(player) then
		return false, "Player must be a Player Instance"
	elseif typeof(reference) ~= "table" then
		return false, "Reference must be a Reference table"
	end

	return true, ""
end

local function CheckReference(reference: Reference, options: {})
	assert(typeof(reference.ReferenceName) == "string", "Reference missing a name")

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

local function CheckHasPass(player: Player, reference: PassReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.GamePassId) == "number", "Pass Reference must contain a GamePassId")

	local cachedResult: CachedResult? = playerCache[player].Passes[reference.GamePassId]

	local shouldUpdate: boolean = true
	local hasPass: boolean = false

	if typeof(cachedResult) ~= "table" or ((cachedResult.LastUpdate - time()) >= CACHE_UPDATE_TIME) then
		shouldUpdate = true
	end

	if shouldUpdate then
		playerCache[player].IsUpdating = true

		local success, _hasPass = pcall(function()
			return MarketplaceService:UserOwnsGamePassAsync(player.UserId, reference.GamePassId)
		end)

		if not success then
			playerCache[player].Passes[reference.GamePassId] = {
				Value = false,
				LastUpdate = time()
			}

			if playerCache[player] then
				playerCache[player].IsUpdating = false
			end

			return false
		end

		cachedResult = {
			Value = _hasPass,
			LastUpdate = time()
		}
		playerCache[player].Passes[reference.GamePassId] = cachedResult

		playerCache[player].IsUpdating = false
		hasPass = cachedResult.Value
	else
		hasPass = cachedResult.Value
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

local function CheckGroupRank(player: Player, reference: GroupReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.GroupId) == "number", "Group Reference must contain a GroupId")
	assert(typeof(reference.Rank) == "number", "Group Reference must contain a Rank")
	assert(typeof(reference.ComparisonType) == "number", "Group Reference must contain a ComparisonType")

	local cachedResult: GroupCachedResult? = playerCache[player].Groups[reference.GroupId]

	local shouldUpdate: boolean = true
	local isInGroup: boolean = false
	local rankInGroup: number = 0

	if typeof(cachedResult) ~= "table" or ((cachedResult.LastUpdate - time()) >= CACHE_UPDATE_TIME) then
		shouldUpdate = true
	end

	if shouldUpdate then
		playerCache[player].IsUpdating = true

		local success1, _isInGroup = pcall(function()
			return player:IsInGroup(reference.GroupId)
		end)

		local success2, _rankInGroup = pcall(function()
			return player:GetRankInGroup(reference.GroupId)
		end)

		if not success1 or not success2 then
			playerCache[player].Groups[reference.GroupId] = {
				IsInGroup = (success1 and _isInGroup) or false,
				RankInGroup = (success2 and _rankInGroup) or 0,
				LastUpdate = time()
			}

			if playerCache[player] then
				playerCache[player].IsUpdating = false
			end

			return false
		end

		cachedResult = {
			IsInGroup = _isInGroup,
			RankInGroup = _rankInGroup,
			LastUpdate = time()
		}
		playerCache[player].Groups[reference.GroupId] = cachedResult

		playerCache[player].IsUpdating = false
		isInGroup = cachedResult.IsInGroup
		rankInGroup = cachedResult.RankInGroup
	else
		isInGroup = cachedResult.IsInGroup
		rankInGroup = cachedResult.RankInGroup
	end

	if reference.ComparisonType == MyUtilModule.GroupComparisonType.IS_IN_GROUP then
		return isInGroup
	elseif reference.ComparisonType == MyUtilModule.GroupComparisonType.IS_NOT_IN_GROUP then
		return not isInGroup
	end

	if reference.ComparisonType == MyUtilModule.GroupComparisonType.EQUAL_TO then
		return rankInGroup == reference.Rank
	elseif reference.ComparisonType == MyUtilModule.GroupComparisonType.NOT_EQUAL_TO then
		return rankInGroup ~= reference.Rank
	elseif reference.ComparisonType == MyUtilModule.GroupComparisonType.LESS_THAN then
		return rankInGroup < reference.Rank
	elseif reference.ComparisonType == MyUtilModule.GroupComparisonType.LESS_THAN_OR_EQUAL_TO then
		return rankInGroup <= reference.Rank
	elseif reference.ComparisonType == MyUtilModule.GroupComparisonType.GREATER_THAN then
		return rankInGroup > reference.Rank
	elseif reference.ComparisonType == MyUtilModule.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO then
		return rankInGroup >= reference.Rank
	end

	return false
end

local function CheckHasBadge(player: Player, reference: BadgeReference): boolean?
	assert(AssertReference(player, reference))
	assert(typeof(reference.BadgeId) == "number", "Badge Reference must contain a BadgeId")

	local cachedResult: CachedResult? = playerCache[player].Badges[reference.BadgeId]

	local shouldUpdate: boolean = true
	local hasBadge: boolean = false

	if typeof(cachedResult) ~= "table" or ((cachedResult.LastUpdate - time()) >= CACHE_UPDATE_TIME) then
		shouldUpdate = true
	end

	if shouldUpdate then
		playerCache[player].IsUpdating = true

		local success, _hasBadge = pcall(function()
			return BadgeService:UserHasBadgeAsync(player.UserId, reference.BadgeId)
		end)

		if not success then
			playerCache[player].Badges[reference.BadgeId] = {
				Value = false,
				LastUpdate = time()
			}

			if playerCache[player] then
				playerCache[player].IsUpdating = false
			end

			return false
		end

		cachedResult = {
			Value = _hasBadge,
			LastUpdate = time()
		}
		playerCache[player].Badges[reference.BadgeId] = cachedResult

		playerCache[player].IsUpdating = false
		hasBadge = cachedResult.Value
	else
		hasBadge = cachedResult.Value
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

local function CheckHasTag(player: Player, reference: CollectionTagReference): boolean?
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

local function CheckAttribute(player: Player, reference: AttributeReference): boolean?
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

function MyUtilModule:CheckIsPlayerValid(player: Player)
	return typeof(player) == "Instance" and player:IsDescendantOf(Players)
end

function MyUtilModule:GetHighestOption(
		referenceType: string,
		player: Player,
		references: {PlayerReference},
		options: {},
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

		while playerCache[player] and playerCache[player].IsUpdating do
			task.wait()
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

function MyUtilModule:CompareReferences(player: Player, references: {}, options: {}): table?
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

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

for _, player: Player in ipairs(Players:GetPlayers()) do
	task.spawn(OnPlayerAdded, player)
end

return MyUtilModule