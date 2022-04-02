--[[

	MarketplaceService
	- Server/Services/Shared/RobloxApi
	Nicholas Foreman

	Data handler for player currency

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService: MarketplaceService = game:GetService("MarketplaceService")
local Players: Players = game:GetService("Players")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)
local DataStore2: table = require(Knit.ServerModules.DataStore2)
local Signal: table = require(Knit.SharedPackages.Signal)

-------------------------
-- CREATE KNIT SERVICE --
-------------------------

local MyMarketplaceService: table = Knit.CreateService {
	Name = "MarketplaceService",
	Client = {
		Value = Knit.CreateProperty({})
	},
	ProductPurchased = Signal.new()
}

------------------------
-- PRIVATE PROPERTIES --
------------------------

local STORAGE_KEY = "Marketplace"
local DEFAULT_VALUE = {}

-- Roblox ReceiptInfo to remember easier; I forgor ;(
type ReceiptInfo = {
	PlayerId: number,
	PlaceIdWherePurchased: number,
	PurchaseId: string,
	ProductId: number,
	CurrencyType: Enum,
	CurrencySpent: number
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function CheckAlreadyProcessed(purchases: table, purchaseId: string): boolean
	for _, purchase in ipairs(purchases) do
		if purchase.PurchaseId == purchaseId then
			return true
		end
	end

	return false
end

local function ProcessReceipt(self: table, receiptInfo: ReceiptInfo): Enum.ProductPurchaseDecision
	local playerId: number = receiptInfo.PlayerId
	local purchaseId: string = receiptInfo.PurchaseId
	local productId: number = receiptInfo.ProductId
	local currencySpent: number = receiptInfo.CurrencySpent

	local player: Player? = Players:GetPlayerByUserId(playerId)
	if not player:IsDescendantOf(Players) then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	local purchases: table = self:Get(player)

	if CheckAlreadyProcessed(purchases, purchaseId) then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	end

	self.ProductPurchased:Fire(player, productId)

	table.insert(purchases, {
		PlayerId = playerId,
		PurchaseId = purchaseId,
		ProductId = productId,
		Price = currencySpent,
		Time = os.time()
	})
	self:Set(player, purchases)

	return Enum.ProductPurchaseDecision.PurchaseGranted
end

local function OnPlayerAdded(self: table, player: Player): nil
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")

	local function OnUpdate(value: table): nil
		if #value <= 0 then
			return
		end

		-- Return product at last index, which would be the most recently purchased
		self.Client.Value:SetFor(player, value[#value])
	end

	local dataStore = DataStore2(STORAGE_KEY, player)
	dataStore:OnUpdate(OnUpdate)
	dataStore:SetBackup(5)

	self.Client.Value:SetFor(player, self:Get(player))
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyMarketplaceService:Get(player: Player): number
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")

	local dataStore = DataStore2(STORAGE_KEY, player)

	return dataStore:Get(DEFAULT_VALUE)
end

function MyMarketplaceService:Set(player: Player, value: number): nil
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(typeof(value) == "number", "Value must be a number")

	local dataStore = DataStore2(STORAGE_KEY, player)

	dataStore:Set(value)
end

function MyMarketplaceService:PurchaseProduct(player: Player, productId: number): nil
	MarketplaceService:PromptProductPurchase(player, productId)
end

------------------------------
-- CLIENT-EXPOSED FUNCTIONS --
------------------------------

function MyMarketplaceService.Client:Get(player: Player): number
	return self.Server:Get(player)
end

function MyMarketplaceService.Client:Set(player: Player, ...): any
	return player:Kick(Knit.ServerConfig.DataSetFromClientMessage)
end

function MyMarketplaceService.Client:PurchaseProduct(player: Player, productId: number): nil
	return self.Server:PurchaseProduct(player, productId)
end

----------------------------------
-- INITIALIZE AND START SERVICE --
----------------------------------

function MyMarketplaceService:KnitStart(): nil
	MarketplaceService.ProcessReceipt = function(receiptInfo: ReceiptInfo)
		return ProcessReceipt(receiptInfo)
	end

	Knit.SharedUtil:WrapPlayerAdded(OnPlayerAdded, self)
end

function MyMarketplaceService:KnitInit(): nil
	DataStore2.Combine(Knit.ServerConfig.DataCombineKey, STORAGE_KEY)
end

----------------------------
-- RETURN SERVICE TO KNIT --
----------------------------

return MyMarketplaceService