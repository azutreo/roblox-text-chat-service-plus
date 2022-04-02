--[[

	BadgeService
	- Server/Services/Shared/RobloxApi
	Nicholas Foreman

	Caches and awards badges

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")
local BadgeService = game:GetService("BadgeService")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit = require(ReplicatedStorage.Packages.Knit)
local Signal = require(Knit.SharedPackages.Signal)
local BadgeModule = require(Knit.SharedModules.RobloxApi.BadgeModule)

-------------------------
-- CREATE KNIT SERVICE --
-------------------------

local MyBadgeService = Knit.CreateService {
	Name = "BadgeService",
	Client = {
		Value = Knit.CreateProperty({})
	},
	BadgeAwarded = Signal.new()
}

------------------------
-- PRIVATE PROPERTIES --
------------------------

local function OnPlayerAdded(self, player: Player): nil
	local playerBadges = {}

	for _, badge in ipairs(BadgeModule.Badges) do
		if not Knit.SharedUtil:GetIsPlayerValid(player) then
			break
		end

		local hasBadge = BadgeService:UserHasBadgeAsync(player.UserId, badge.BadgeId)
		playerBadges[badge.Identifier] = hasBadge
	end

	playerBadges._IsLoaded = true

	self.Client.Value:SetFor(player, playerBadges)
end

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyBadgeService:CheckHasBadge(player: Player, identifier: string)
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(typeof(identifier) == "string", "Identifier must be a string")

	if not Knit.SharedUtil:YieldPropertyLoaded(player, self.Client.Value.GetFor, self.Client.Value) then
		return false
	end

	return self.Client.Value:GetFor(player)[identifier]
end

function MyBadgeService:AwardBadge(player: Player, identifier: string)
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(typeof(identifier) == "string", "Identifier must be a string")

	if not Knit.SharedUtil:YieldPropertyLoaded(player, self.Client.Value.GetFor, self.Client.Value) then
		return false
	end

	local hasBadge: boolean = self:CheckHasBadge(player, identifier)
	if hasBadge then
		return
	end

	local badge = BadgeModule:GetBadgeByIdentifier(identifier)
	if not badge then
		return
	end

	local success: boolean, result: any = pcall(BadgeService.AwardBadge, BadgeService, player.UserId, badge.BadgeId)
	if not success then
		return warn(result)
	end

	return self.Client.Value:GetFor(player)[identifier]
end

------------------------------
-- CLIENT-EXPOSED FUNCTIONS --
------------------------------

----------------------------------
-- INITIALIZE AND START SERVICE --
----------------------------------

function MyBadgeService:KnitStart(): nil
	Knit.SharedUtil:WrapPlayerAdded(OnPlayerAdded, self)
end

function MyBadgeService:KnitInit(): nil

end

----------------------------
-- RETURN SERVICE TO KNIT --
----------------------------

return MyBadgeService