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

export type Assignment = {
	OptionName: string
}

export type PlayerAssignment = {
	OptionName: string,

	UserId: number,
	IsPlayer: boolean -- if true, will give if matches; if false, if false, then will give if it DOESN'T match
}

export type PassAssignment = {
	OptionName: string,

	GamePassId: number,
	HasPass: boolean -- if true, will give if matches; if false, if false, then will give if it DOESN'T match
}

export type GroupAssignment = {
	OptionName: string,

	GroupId: number,
	Rank: number,
	ComparrisonType: number
}

export type BadgeAssignment = {
	OptionName: string,

	BadgeId: number,
	HasBadge: boolean -- if true, will give if matches; if false, then will give if it DOESN'T match
}

export type TeamAssignment = {
	OptionName: string,

	TeamName: string,
	IsOnTeam: boolean -- if true, will give if player is on team; if false, will give if NOT on team
}

export type CollectionTagAssignment = {
	OptionName: string,

	CollectionTagName: string,
	HasTag: boolean -- if true, will give if matches; if false, then will give if it DOESN'T match
}

export type AttributeAssignment = {
	OptionName: string,

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

local function AssertAssignment(player: Player, assignment: Assignment): any
	if not MyUtilModule:CheckIsPlayerValid(player) then
		return false, "Player must be a Player Instance"
	elseif typeof(assignment) ~= "table" then
		return false, "Assignment must be a Assignment table"
	end

	return true, ""
end

local function CheckAssignment(assignment: Assignment, options: {})
	assert(typeof(assignment.OptionName) == "string", "Assignment missing a name")

	return options[assignment.OptionName]
end

local function CheckIsPlayer(player: Player, assignment: PlayerAssignment): boolean?
	assert(AssertAssignment(player, assignment))
	assert(typeof(assignment.UserId) == "number", "Player Assignment must contain a UserId")

	if player.UserId == assignment.UserId then
		if assignment.IsPlayer then
			return true
		else
			return false
		end
	elseif not assignment.IsPlayer then
		return true
	end

	return false
end

local function CheckHasPass(player: Player, assignment: PassAssignment): boolean?
	assert(AssertAssignment(player, assignment))
	assert(typeof(assignment.GamePassId) == "number", "Pass Assignment must contain a GamePassId")

	local cachedResult: CachedResult? = playerCache[player].Passes[assignment.GamePassId]

	local shouldUpdate: boolean = true
	local hasPass: boolean = false

	if typeof(cachedResult) ~= "table" or ((cachedResult.LastUpdate - time()) >= CACHE_UPDATE_TIME) then
		shouldUpdate = true
	end

	if shouldUpdate then
		playerCache[player].IsUpdating = true

		local success, _hasPass = pcall(function()
			return MarketplaceService:UserOwnsGamePassAsync(player.UserId, assignment.GamePassId)
		end)

		if not success then
			playerCache[player].Passes[assignment.GamePassId] = {
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
		playerCache[player].Passes[assignment.GamePassId] = cachedResult

		playerCache[player].IsUpdating = false
		hasPass = cachedResult.Value
	else
		hasPass = cachedResult.Value
	end

	if hasPass then
		if assignment.HasPass then
			return true
		else
			return false
		end
	elseif not assignment.HasPass then
		return true
	end

	return false
end

local function CheckGroupRank(player: Player, assignment: GroupAssignment): boolean?
	assert(AssertAssignment(player, assignment))
	assert(typeof(assignment.GroupId) == "number", "Group Assignment must contain a GroupId")
	assert(typeof(assignment.Rank) == "number", "Group Assignment must contain a Rank")
	assert(typeof(assignment.ComparisonType) == "number", "Group Assignment must contain a ComparisonType")

	local cachedResult: GroupCachedResult? = playerCache[player].Groups[assignment.GroupId]

	local shouldUpdate: boolean = true
	local isInGroup: boolean = false
	local rankInGroup: number = 0

	if typeof(cachedResult) ~= "table" or ((cachedResult.LastUpdate - time()) >= CACHE_UPDATE_TIME) then
		shouldUpdate = true
	end

	if shouldUpdate then
		playerCache[player].IsUpdating = true

		local success1, _isInGroup = pcall(function()
			return player:IsInGroup(assignment.GroupId)
		end)

		local success2, _rankInGroup = pcall(function()
			return player:GetRankInGroup(assignment.GroupId)
		end)

		if not success1 or not success2 then
			playerCache[player].Groups[assignment.GroupId] = {
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
		playerCache[player].Groups[assignment.GroupId] = cachedResult

		playerCache[player].IsUpdating = false
		isInGroup = cachedResult.IsInGroup
		rankInGroup = cachedResult.RankInGroup
	else
		isInGroup = cachedResult.IsInGroup
		rankInGroup = cachedResult.RankInGroup
	end

	if assignment.ComparisonType == MyUtilModule.GroupComparisonType.IS_IN_GROUP then
		return isInGroup
	elseif assignment.ComparisonType == MyUtilModule.GroupComparisonType.IS_NOT_IN_GROUP then
		return not isInGroup
	end

	if assignment.ComparisonType == MyUtilModule.GroupComparisonType.EQUAL_TO then
		return rankInGroup == assignment.Rank
	elseif assignment.ComparisonType == MyUtilModule.GroupComparisonType.NOT_EQUAL_TO then
		return rankInGroup ~= assignment.Rank
	elseif assignment.ComparisonType == MyUtilModule.GroupComparisonType.LESS_THAN then
		return rankInGroup < assignment.Rank
	elseif assignment.ComparisonType == MyUtilModule.GroupComparisonType.LESS_THAN_OR_EQUAL_TO then
		return rankInGroup <= assignment.Rank
	elseif assignment.ComparisonType == MyUtilModule.GroupComparisonType.GREATER_THAN then
		return rankInGroup > assignment.Rank
	elseif assignment.ComparisonType == MyUtilModule.GroupComparisonType.GREATER_THAN_OR_EQUAL_TO then
		return rankInGroup >= assignment.Rank
	end

	return false
end

local function CheckHasBadge(player: Player, assignment: BadgeAssignment): boolean?
	assert(AssertAssignment(player, assignment))
	assert(typeof(assignment.BadgeId) == "number", "Badge Assignment must contain a BadgeId")

	local cachedResult: CachedResult? = playerCache[player].Badges[assignment.BadgeId]

	local shouldUpdate: boolean = true
	local hasBadge: boolean = false

	if typeof(cachedResult) ~= "table" or ((cachedResult.LastUpdate - time()) >= CACHE_UPDATE_TIME) then
		shouldUpdate = true
	end

	if shouldUpdate then
		playerCache[player].IsUpdating = true

		local success, _hasBadge = pcall(function()
			return BadgeService:UserHasBadgeAsync(player.UserId, assignment.BadgeId)
		end)

		if not success then
			playerCache[player].Badges[assignment.BadgeId] = {
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
		playerCache[player].Badges[assignment.BadgeId] = cachedResult

		playerCache[player].IsUpdating = false
		hasBadge = cachedResult.Value
	else
		hasBadge = cachedResult.Value
	end

	if hasBadge then
		if assignment.HasBadge then
			return true
		else
			return false
		end
	elseif not assignment.HasBadge then
		return true
	end

	return false
end

local function CheckTeam(player: Player, assignment: TeamAssignment): boolean?
	assert(AssertAssignment(player, assignment))
	assert(typeof(assignment.TeamName) == "string", "Team Assignment must contain a TeamName")

	if typeof(player.Team) == "nil" then
		return not assignment.IsOnTeam
	end

	if player.Team.Name == assignment.TeamName then
		if assignment.IsOnTeam then
			return true
		else
			return false
		end
	elseif not assignment.IsOnTeam then
		return true
	end

	return false
end

local function CheckHasTag(player: Player, assignment: CollectionTagAssignment): boolean?
	assert(AssertAssignment(player, assignment))
	assert(typeof(assignment.CollectionTagName) == "string", "CollectionTag Assignment must contain a CollectionTagName")

	local hasTag = CollectionService:HasTag(player, assignment.CollectionTagName)

	if hasTag then
		if assignment.HasTag then
			return true
		else
			return false
		end
	elseif not assignment.HasTag then
		return true
	end

	return false
end

local function CheckAttribute(player: Player, assignment: AttributeAssignment): boolean?
	assert(AssertAssignment(player, assignment))
	assert(typeof(assignment.AttributeName) == "string", "Attribute Assignment must contain a AttributeName")

	local attributeValue = player:GetAttribute(assignment.AttributeName)

	if attributeValue == assignment.AttributeValue then
		if assignment.HasTag then
			return true
		else
			return false
		end
	elseif not assignment.HasTag then
		return true
	end

	return false
end

function MyUtilModule:CheckIsPlayerValid(player: Player)
	return typeof(player) == "Instance" and player:IsDescendantOf(Players)
end

function MyUtilModule:GetHighestOption(
		assignmentType: string,
		player: Player,
		assignments: {PlayerAssignment},
		options: {},
		highestOption: table?
	): {any}?

	assert(AssertAssignment(player, assignments))
	assert(typeof(assignmentType) == "string", "Assignment type must be a string")

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

	local function CheckAssignmentType(assignment: Assignment): {any}?
		local option = CheckAssignment(assignment, options)
		if not option then
			return nil
		end

		while playerCache[player] and playerCache[player].IsUpdating do
			task.wait()
		end

		local hasOption = false

		if assignmentType == "Players" then
			hasOption = CheckIsPlayer(player, assignment)
		elseif assignmentType == "Passes" then
			hasOption = CheckHasPass(player, assignment)
		elseif assignmentType == "Groups" then
			hasOption = CheckGroupRank(player, assignment)
		elseif assignmentType == "Badges" then
			hasOption = CheckHasBadge(player, assignment)
		elseif assignmentType == "Teams" then
			hasOption = CheckTeam(player, assignment)
		elseif assignmentType == "CollectionTags" then
			hasOption = CheckHasTag(player, assignment)
		elseif assignmentType == "Attributes" then
			hasOption = CheckAttribute(player, assignment)
		end

		if hasOption then
			return option
		end

		return nil
	end

	for _, assignment: Assignment in ipairs(assignments) do
		local option: {any} = CheckAssignmentType(assignment)

		if typeof(option) == "table" then
			CheckOption(option)
		end
	end

	return highestOption
end

function MyUtilModule:CompareAssignments(player: Player, assignments: {}, options: {}): table?
	assert(AssertAssignment(player, assignments))
	assert(typeof(options) == "table", "Options must be a table")

	local highestOption: table?

	if assignments.Players then
		highestOption = self:GetHighestOption("Players", player, assignments.Players, options, highestOption)
	end
	if assignments.Passes then
		highestOption = self:GetHighestOption("Passes", player, assignments.Passes, options, highestOption)
	end
	if assignments.Groups then
		highestOption = self:GetHighestOption("Groups", player, assignments.Groups, options, highestOption)
	end
	if assignments.Badges then
		highestOption = self:GetHighestOption("Badges", player, assignments.Badges, options, highestOption)
	end
	if assignments.Teams then
		highestOption = self:GetHighestOption("Teams", player, assignments.Teams, options, highestOption)
	end
	if assignments.CollectionTags then
		highestOption = self:GetHighestOption("CollectionTags", player, assignments.CollectionTags, options, highestOption)
	end
	if assignments.Attributes then
		highestOption = self:GetHighestOption("Attributes", player, assignments.Attributes, options, highestOption)
	end

	return highestOption
end

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

for _, player: Player in ipairs(Players:GetPlayers()) do
	task.spawn(OnPlayerAdded, player)
end

return MyUtilModule