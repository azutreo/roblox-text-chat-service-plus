--[[

	NameColorModule
	- Shared/Modules
	Azutreo : Nicholas Foreman

	A list of options and how to assign them for name colors
	Uses the old Roblox method of getting name color for classic purposes if desired

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- Commented since this is going to the public
-- local Knit = require(ReplicatedStorage.Packages.Knit)
local UtilModule = require(script.Parent.UtilModule)

-------------------
-- CREATE MODULE --
-------------------

local MyNameColorModule = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

local IS_ENABLED: boolean = true

local COLOR_DEFAULT: Color3 = Color3.fromRGB(170, 170, 170)
-- Set to false if you want to use COLOR_DEFAULT if the player doesn't have an assigned name color
local USE_ROBLOX_NAME_COLOR: boolean = true
-- Set to false if you don't want to use a player's team color when they don't have a name color
local USE_TEAM_COLOR: boolean = true

local ROBLOX_NAME_COLORS: { Color3 } = {
	Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
	Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
	Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
	BrickColor.new("Bright violet").Color,
	BrickColor.new("Bright orange").Color,
	BrickColor.new("Bright yellow").Color,
	BrickColor.new("Light reddish violet").Color,
	BrickColor.new("Brick yellow").Color,
}
local ROBLOX_COLOR_OFFSET: number = 0

export type NameColor = {
	NameColor: Color3,
	Priority: number
}

local robloxNameColorCache = {}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

MyNameColorModule.Options = {

	["Owner"] = {
		NameColor = Color3.fromHex("#af4448"), -- Dark pastel red

		Priority = 1
	},

	["Administrator"] = {
		NameColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 2
	},

	["Developer"] = {
		NameColor = Color3.fromHex("#64b5f6"), -- Light pastel blue

		Priority = 3
	},

	["Moderator"] = {
		NameColor = Color3.fromHex("#81c784"), -- Light pastel green

		Priority = 4
	},

	["Contributor"] = {
		NameColor = Color3.fromHex("#f06292"), -- Light pastel magenta

		Priority = 5
	},

	["Roblox Staff"] = {
		NameColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 6
	},

	["Roblox Intern"] = {
		NameColor = Color3.fromHex("#e57373"), -- Light pastel red

		Priority = 7
	},

	["Roblox Star"] = {
		NameColor = Color3.fromHex("#ffb74d"), -- Light pastel orange

		Priority = 8
	},

	["Tester"] = {
		NameColor = Color3.fromRGB(172, 137, 228), -- Roblox QA Valiant Pink (estimated)

		Priority = 9
	},

	["VIP"] = {
		NameColor = Color3.fromHex("#ffd54f"), -- Light pastel amber

		Priority = 10
	},

	["Group Member"] = {
		NameColor = Color3.fromHex("#9e9e9e"), -- Light grey

		Priority = 11
	},

	["Random for Testing Purposes"] = {
		NameColor = Color3.fromHex("#f06292"), -- Light pastel magenta

		Priority = 12
	}

}

MyNameColorModule.References = {}

MyNameColorModule.References.Players = {

	{
		ReferenceName = "Contributor",

		UserId = 9221415,
		IsPlayer = true
	},

}

MyNameColorModule.References.Passes = {

	{
		ReferenceName = "VIP",

		GamePassId = 37639178, -- Put your VIP pass id here
		HasPass = true
	},

}

MyNameColorModule.References.Groups = {

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

MyNameColorModule.References.Badges = {

	{
		ReferenceName = "VIP",

		BadgeId = 9249849654,
		HasBadge = true
	},

}

MyNameColorModule.References.Teams = {

	{
		ReferenceName = "Random for Testing Purposes",

		TeamName = "Random Team for Testing Purposes",
		IsOnTeam = true
	},

}

MyNameColorModule.References.CollectionTags = {

	{
		ReferenceName = "VIP",

		CollectionTagName = "VIP",
		HasTag = true
	},

}

MyNameColorModule.References.Attributes = {

	{
		ReferenceName = "VIP",

		AttributeName = "IsVIP",
		AttributeValue = true
	},

}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function GetRobloxNameValue(playerName: string): number
	local value: number = 0

	for index = 1, #playerName do
		local cValue: number = string.byte(string.sub(playerName, index, index))
		local reverseIndex: number = #playerName - index + 1

		if #playerName % 2 == 1 then
			reverseIndex = reverseIndex - 1
		end

		if reverseIndex % 4 >= 2 then
			cValue = -cValue
		end

		value = value + cValue
	end

	return value
end

local function ComputeRobloxNameColor(playerName: string): Color3
	return ROBLOX_NAME_COLORS[((GetRobloxNameValue(playerName) + ROBLOX_COLOR_OFFSET) % #ROBLOX_NAME_COLORS) + 1]
end

local function OnPlayerAdded(player: Player): nil
	robloxNameColorCache[player] = ComputeRobloxNameColor(player.Name)

	return nil
end

local function OnPlayerRemoving(player: Player): nil
	robloxNameColorCache[player] = nil

	return nil
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyNameColorModule:GetNameColorForPlayer(player: Player): NameColor?
	if not IS_ENABLED then
		return nil
	end

	if not UtilModule:CheckIsPlayerValid(player) then
		return {
			NameColor = COLOR_DEFAULT,
			Priority = 0
		}
	end

	local nameColor = UtilModule:CompareReferences(player, MyNameColorModule.References, MyNameColorModule.Options)

	if typeof(nameColor) == "table" then
		return nameColor
	end

	if USE_TEAM_COLOR and typeof(player.Team) ~= "nil" then
		return {
			NameColor = player.TeamColor.Color,
			Priority = 0
		}
	end

	if not USE_ROBLOX_NAME_COLOR then
		return {
			NameColor = COLOR_DEFAULT,
			Priority = 0
		}
	end

	if not robloxNameColorCache[player] then
		robloxNameColorCache[player] = ComputeRobloxNameColor(player.Name)
	end

	return {
		NameColor = robloxNameColorCache[player],
		Priority = 0
	}
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-- Commented for public module
-- Knit.OnStart:andThen(function()
	Players.PlayerAdded:Connect(OnPlayerAdded)
	Players.PlayerRemoving:Connect(OnPlayerRemoving)

	for _, player: Player in ipairs(Players:GetPlayers()) do
		task.spawn(OnPlayerAdded, player)
	end
-- end):catch(warn)


-------------------
-- RETURN MODULE --
-------------------

return MyNameColorModule