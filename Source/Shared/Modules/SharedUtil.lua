--[[

	SharedUtil
	- Shared/Modules
	Nicholas Foreman

	Common utility functions that will help across the game

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players: Players = game:GetService("Players")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit = require(ReplicatedStorage.Packages.Knit)

-------------------
-- CREATE MODULE --
-------------------

local SharedUtil = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

type Function = (...any) -> ()

type Callback = {
	Callback: Function,
	Arguments: {any},
	Self
}

local playerAddedFunctions: {Callback} = {}
local playerRemovingFunctions: {Callback} = {}
local characterAddedFunctions: {Callback} = {}

local playerConnections: {RBXScriptConnection} = {}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function OnCharacterAdded(player: Player, character: Model): nil
	assert(SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(
		typeof(character) == "Instance" and character:IsA("Model") and character == player.Character,
		"Character must be the valid character of " .. player.Name
	)

	for _, callback: Callback in ipairs(characterAddedFunctions) do
		task.spawn(callback.Callback, callback.Self, player, character, table.unpack(callback.Arguments))
	end
end

local function OnPlayerAdded(player: Player): nil
	playerConnections[player] = {}

	for _, callback: Callback in ipairs(playerAddedFunctions) do
		task.spawn(callback.Callback, callback.Self, player, table.unpack(callback.Arguments))
	end

	local connection: RBXScriptConnection = player.CharacterAdded:Connect(function(character)
		OnCharacterAdded(player, character)
	end)
	table.insert(playerConnections[player], connection)

	if player.Character then
		for _, callback: Callback in ipairs(characterAddedFunctions) do
			task.spawn(callback.Callback, callback.Self, player, player.Character, table.unpack(callback.Arguments))
		end
	end
end

local function OnPlayerRemoving(player: Player): nil
	for _, callback: Callback in ipairs(playerRemovingFunctions) do
		task.spawn(callback.Callback, callback.Self, player, table.unpack(callback.Arguments))
	end

	if not playerConnections[player] then
		return
	end

	for _, connection: RBXScriptConnection in ipairs(playerConnections[player]) do
		connection:Disconnect()
	end

	playerConnections[player] = nil
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function SharedUtil:GetIsPlayerValid(player: Player?): boolean
	if typeof(player) == "Instance" and player:IsDescendantOf(Players) then
		return true
	end

	return false
end

function SharedUtil:GetPlayerByUserId(userId: number): Player?
	assert(typeof(userId) == "number", "UserId must be a number")

	local player: Player? = Players:GetPlayerByUserId(userId)
	if not self:GetIsPlayerValid(player) then
		return nil
	end

	return player
end

function SharedUtil:WrapPlayerAdded(callback: Function, this, ...): nil
	assert(typeof(callback) == "function", "Must be a function")
	assert(typeof(this) == "table", "Must pass through a self table for callback")

	table.insert(playerAddedFunctions, {
		Callback = callback,
		Arguments = { ... },
		Self = this
	})

	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(callback, this, player, ...)
	end
end

function SharedUtil:WrapPlayerRemoving(callback: Function, this, ...): nil
	assert(typeof(callback) == "function", "Must be a function")
	assert(typeof(this) == "table", "Must pass through a self table for callback")

	table.insert(playerRemovingFunctions, {
		Callback = callback,
		Arguments = { ... },
		Self = this
	})
end

function SharedUtil:WrapCharacterAdded(callback: Function, this, ...): nil
	assert(typeof(callback) == "function", "Must be a function")
	assert(typeof(this) == "table", "Must pass through a self table for callback")

	table.insert(characterAddedFunctions, {
		Callback = callback,
		Arguments = { ... },
		Self = this
	})

	for _, player: Player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		if typeof(character) == "Instance" and character:IsA("Model") then
			task.spawn(OnCharacterAdded, player, character)
		end
	end
end

function SharedUtil:WeldParts(part0: BasePart, part1: BasePart): nil
	assert(typeof(part0) == "Instance" and part0:IsA("BasePart"), "Part0 must be a BasePart Instance")
	assert(typeof(part1) == "Instance" and part1:IsA("BasePart"), "Part1 must be a BasePart Instance")

	local weld = Instance.new("WeldConstraint")
	weld.Name = part1.Name
	weld.Part0 = part0
	weld.Part1 = part1
	weld.Parent = part1

	part1.Anchored = false
end

function SharedUtil:WeldModel(parent: Instance, rootPart: BasePart): nil
	assert(typeof(parent) == "Instance", "Parent must be an Instance")
	assert(typeof(rootPart) == "Instance" and rootPart:IsA("BasePart"), "RootPart must be a BasePart Instance")

	for _, descendant: BasePart? in ipairs(parent:GetDescendants()) do
		if descendant:IsA("BasePart") and descendant ~= rootPart then
			self:WeldParts(parent, descendant)
		end
	end
end

function SharedUtil:YieldPropertyLoaded(player: Player, callback: Function, this)
	assert(self:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(typeof(callback) == "function", "Callback must be a function")
	assert(typeof(this) == "table", "Must pass through a self table for callback")

	local isStarted = false
	local isLoaded = false

	while not isLoaded do
		local playerProperty = callback(this, player)
		if typeof(playerProperty) ~= "table" then
			return false
		end

		if not self:GetIsPlayerValid(player) then
			return false
		end

		isLoaded = playerProperty._IsLoaded

		if isLoaded then
			break
		elseif isStarted then
			task.wait()
		else
			isStarted = true
		end
	end

	return isLoaded
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

Players.PlayerAdded:Connect(OnPlayerAdded)
Players.PlayerRemoving:Connect(OnPlayerRemoving)

-------------------
-- RETURN MODULE --
-------------------

return SharedUtil