--[[

	UtilModule
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	The algorithm used by Roblox circa TextChatService

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- local Knit = require(ReplicatedStorage.Packages.Knit)

------------------------
-- PRIVATE PROPERTIES --
------------------------

-- List of classic roblox name colors
local CLASSIC_NAME_COLORS: { Color3 } = {
	Color3.new(253/255, 41/255, 67/255), -- BrickColor.new("Bright red").Color,
	Color3.new(1/255, 162/255, 255/255), -- BrickColor.new("Bright blue").Color,
	Color3.new(2/255, 184/255, 87/255), -- BrickColor.new("Earth green").Color,
	BrickColor.new("Bright violet").Color,
	BrickColor.new("Bright orange").Color,
	BrickColor.new("Bright yellow").Color,
	BrickColor.new("Light reddish violet").Color,
	BrickColor.new("Brick yellow").Color,
}

-- The offset used for the algorithm; has historically always been 0
local CLASSIC_COLOR_OFFSET: number = 0

-- Caching classic roblox name colors for efficiency so the algorithm isn't being run every message 🧍‍♀️
local classicNameColorCache = {}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function GetClassicNameValue(playerName: string): number
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

local function ComputeClassicNameColor(playerName: string): Color3
	return CLASSIC_NAME_COLORS[((GetClassicNameValue(playerName) + CLASSIC_COLOR_OFFSET) % #CLASSIC_NAME_COLORS) + 1]
end

local function OnPlayerAdded(player: Player)
	classicNameColorCache[player] = ComputeClassicNameColor(player.Name)
	player:GetAttributeChangedSignal("ChatData_CustomName"):Connect(function()
		if player:GetAttribute("ChatData_CustomName") ~= "" then
			classicNameColorCache[player] = ComputeClassicNameColor(player:GetAttribute("ChatData_CustomName"))
		end
	end
end

local function OnPlayerRemoving(player: Player)
	classicNameColorCache[player] = nil
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

for _, player: Player in ipairs(Players:GetPlayers()) do
	task.spawn(OnPlayerAdded, player)
end

-------------------------
-- RETURN GET FUNCTION --
-------------------------

return function(player)
	if not classicNameColorCache[player] then
		classicNameColorCache[player] = ComputeClassicNameColor(player.Name)
	end

	return classicNameColorCache[player]
end
