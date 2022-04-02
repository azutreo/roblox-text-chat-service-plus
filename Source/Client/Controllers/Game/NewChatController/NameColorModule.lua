--[[

	NameColorModule
	- Shared/Modules
	Azutreo : Nicholas Foreman

	Uses the old Roblox method of getting name color for classic purposes

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

-------------------
-- CREATE MODULE --
-------------------

local MyNameColorModule = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

local NAME_COLORS: { Color3 } = {
	Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
	Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
	Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
	BrickColor.new("Bright violet").Color,
	BrickColor.new("Bright orange").Color,
	BrickColor.new("Bright yellow").Color,
	BrickColor.new("Light reddish violet").Color,
	BrickColor.new("Brick yellow").Color,
}

local COLOR_OFFSET: number = 0
local COLOR_WHITE: Color3 = Color3.fromRGB(255, 255, 255)

local playerNameColorCache = {}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function GetNameValue(playerName: string): number
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

local function ComputeNameColor(playerName: string): Color3
	return NAME_COLORS[((GetNameValue(playerName) + COLOR_OFFSET) % #NAME_COLORS) + 1]
end

local function OnPlayerAdded(player: Player): nil
	playerNameColorCache[player] = ComputeNameColor(player.Name)

	return nil
end

local function OnPlayerRemoving(player: Player): nil
	playerNameColorCache[player] = nil

	return nil
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyNameColorModule:GetNameColorForPlayer(player: Player): Color3
	if not player then
		return COLOR_WHITE
	end

	if typeof(player.Team) ~= "nil" then
		return player.TeamColor.Color
	end

	if not playerNameColorCache[player] then
		playerNameColorCache[player] = ComputeNameColor(player.Name)
	end

	return playerNameColorCache[player]
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

for _, player: Player in ipairs(Players:GetPlayers()) do
	task.spawn(OnPlayerAdded, player)
end

-------------------
-- RETURN MODULE --
-------------------

return MyNameColorModule