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

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(Knit.SharedPackages.Signal)
local GamePassModule = require(Knit.SharedModules.RobloxApi.GamePassModule)

-------------------------
-- CREATE KNIT SERVICE --
-------------------------

local MyGamePassService = Knit.CreateService {
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

local function OnPlayerAdded(self, player: Player): nil
	local playerPasses = {}

	for _, pass in ipairs(GamePassModule.Passes) do
		if not Knit.SharedUtil:GetIsPlayerValid(player) then
			break
		end

		local hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, pass.PassId)
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