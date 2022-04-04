local Players = game:GetService("Players")

-- Used for classic roblox name colors
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
local CLASSIC_COLOR_OFFSET: number = 0

-- Caching classic roblox name colors for efficiency so the algorithm isn't being run every message 🧍‍♀️
local classicNameColorCache = {}

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

local function ComputeRobloxNameColor(playerName: string): Color3
	return CLASSIC_NAME_COLORS[((GetClassicNameValue(playerName) + CLASSIC_COLOR_OFFSET) % #CLASSIC_NAME_COLORS) + 1]
end

local function OnPlayerAdded(player: Player): nil
	classicNameColorCache[player] = ComputeRobloxNameColor(player.Name)

	return nil
end

local function OnPlayerRemoving(player: Player): nil
	classicNameColorCache[player] = nil

	return nil
end

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

for _, player: Player in ipairs(Players:GetPlayers()) do
	task.spawn(OnPlayerAdded, player)
end

return function(player)
	if not classicNameColorCache[player] then
		classicNameColorCache[player] = ComputeRobloxNameColor(player.Name)
	end

	return classicNameColorCache[player]
end