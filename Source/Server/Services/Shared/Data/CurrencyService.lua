--[[

	CurrencyService
	- Server/Services/Shared/Data
	Nicholas Foreman

	Data handler for player currency

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit = require(ReplicatedStorage.Packages.Knit)
local DataStore2 = require(Knit.ServerModules.DataStore2)

-------------------------
-- CREATE KNIT SERVICE --
-------------------------

local MyCurrencyService = Knit.CreateService {
	Name = "CurrencyService",
	Client = {
		Value = Knit.CreateProperty(0)
	}
}

------------------------
-- PRIVATE PROPERTIES --
------------------------

local STORAGE_KEY = "Currency"
local DEFAULT_VALUE = 1000

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function OnPlayerAdded(self, player: Player): nil
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")

	local function OnUpdate(value: number): nil
		self.Client.Value:SetFor(player, value)
	end

	local dataStore = DataStore2(STORAGE_KEY, player)
	dataStore:OnUpdate(OnUpdate)
	dataStore:SetBackup(5)

	self.Client.Value:SetFor(player, self:Get(player))
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyCurrencyService:Get(player: Player): number
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")

	local dataStore = DataStore2(STORAGE_KEY, player)

	return dataStore:Get(DEFAULT_VALUE)
end

function MyCurrencyService:Set(player: Player, value: number): nil
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(typeof(value) == "number", "Value must be a number")

	local dataStore = DataStore2(STORAGE_KEY, player)

	dataStore:Set(value)
end

function MyCurrencyService:Add(player: Player, value: number): nil
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(typeof(value) == "number", "Value must be a number")

	self:Get(player)

	local dataStore = DataStore2(STORAGE_KEY, player)

	dataStore:Increment(value)
end

function MyCurrencyService:Subtract(player: Player, value: number): nil
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(typeof(value) == "number", "Value must be a number")

	local dataStore = DataStore2(STORAGE_KEY, player)

	dataStore:Increment(-value)
end

------------------------------
-- CLIENT-EXPOSED FUNCTIONS --
------------------------------

function MyCurrencyService.Client:Get(player: Player): number
	return self.Server:Get(player)
end

function MyCurrencyService.Client:Set(player: Player, ...): any
	return player:Kick(Knit.ServerConfig.DataSetFromClientMessage)
end

function MyCurrencyService.Client:Add(player: Player, ...): any
	return player:Kick(Knit.ServerConfig.DataSetFromClientMessage)
end

function MyCurrencyService.Client:Subtract(player: Player, ...): any
	return player:Kick(Knit.ServerConfig.DataSetFromClientMessage)
end

----------------------------------
-- INITIALIZE AND START SERVICE --
----------------------------------

function MyCurrencyService:KnitStart(): nil
	Knit.SharedUtil:WrapPlayerAdded(OnPlayerAdded, self)
end

function MyCurrencyService:KnitInit(): nil
	DataStore2.Combine(Knit.ServerConfig.DataCombineKey, STORAGE_KEY)
end

----------------------------
-- RETURN SERVICE TO KNIT --
----------------------------

return MyCurrencyService