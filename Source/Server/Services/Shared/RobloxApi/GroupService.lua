--[[

	GroupService
	- Server/Services/Shared/RobloxApi
	Nicholas Foreman

	Caches group ranks

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit: table = require(ReplicatedStorage.Packages.Knit)
local Signal: table = require(Knit.SharedPackages.Signal)
local GroupModule: table = require(Knit.SharedModules.RobloxApi.GroupModule)

-------------------------
-- CREATE KNIT SERVICE --
-------------------------

local MyGroupService: table = Knit.CreateService {
	Name = "GroupService",
	Client = {
		Value = Knit.CreateProperty({})
	},
	GroupJoined = Signal.new()
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
	local playerGroups = {}

	for _, group: table in ipairs(GroupModule.Groups) do
		if not Knit.SharedUtil:GetIsPlayerValid(player) then
			break
		end

		local rankInGroup = player:GetRankInGroup(group.GroupId)
		playerGroups[group.Name] = rankInGroup
	end

	playerGroups._IsLoaded = true

	self.Client.Value:SetFor(player, playerGroups)
end

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyGroupService:GetRankInGroup(player: Player, groupName: string)
	assert(Knit.SharedUtil:GetIsPlayerValid(player), "Player must be a Player Instance")
	assert(typeof(groupName) == "string", "Group Name must be a string")

	if not Knit.SharedUtil:YieldPropertyLoaded(player, self.Client.Value.GetFor, self.Client.Value) then
		return false
	end

	return self.Client.Value:GetFor(player)[groupName]
end

------------------------------
-- CLIENT-EXPOSED FUNCTIONS --
------------------------------

----------------------------------
-- INITIALIZE AND START SERVICE --
----------------------------------

function MyGroupService:KnitStart(): nil
	Knit.SharedUtil:WrapPlayerAdded(OnPlayerAdded, self)
end

function MyGroupService:KnitInit(): nil

end

----------------------------
-- RETURN SERVICE TO KNIT --
----------------------------

return MyGroupService