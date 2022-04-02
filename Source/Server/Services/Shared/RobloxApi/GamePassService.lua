--[[

	GamePassService
	- Server/Services/Shared/RobloxApi
	Nicholas Foreman

	Caches passes and prompts purchases

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService: MarketplaceService = game:GetService("MarketplaceService")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)
local Signal: table = require(Knit.SharedPackages.Signal)
local GamePassModule: table = require(Knit.SharedModules.RobloxApi.GamePassModule)
local TrustModule: table = require(Knit.SharedModules.TrustModule)

-------------------------
-- CREATE KNIT SERVICE --
-------------------------

local MyGamePassService: table = Knit.CreateService {
	Name = "GamePassService",
	Client = {
		Value = Knit.CreateProperty({})
	},
	PassPurchased = Signal.new()
}

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

local function OnPlayerAdded(self: table, player: Player): nil
	local playerPasses = {}

	local playerTrust = TrustModule:GetTrustForPlayer(player)

	for _, pass: table in ipairs(GamePassModule.Passes) do
		if not Knit.SharedUtil:GetIsPlayerValid(player) then
			break
		end

		local hasPass = (playerTrust.Name == "Staff") or MarketplaceService:UserOwnsGamePassAsync(player.UserId, pass.PassId)
		playerPasses[pass.Identifier] = hasPass
	end

	playerPasses._IsLoaded = true

	self.Client.Value:SetFor(player, playerPasses)
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyGamePassService:CheckHasPass(player: Player, identifier: string)
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(typeof(identifier) == "string", "Identifier must be a string")

	if not Knit.SharedUtil:YieldPropertyLoaded(player, self.Client.Value.GetFor, self.Client.Value) then
		return false
	end

	return self.Client.Value:GetFor(player)[identifier]
end

------------------------------
-- CLIENT-EXPOSED FUNCTIONS --
------------------------------

----------------------------------
-- INITIALIZE AND START SERVICE --
----------------------------------

function MyGamePassService:KnitStart(): nil
	Knit.SharedUtil:WrapPlayerAdded(OnPlayerAdded, self)
end

function MyGamePassService:KnitInit(): nil

end

----------------------------
-- RETURN SERVICE TO KNIT --
----------------------------

return MyGamePassService