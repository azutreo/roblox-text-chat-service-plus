--[[

	CheckCanRunCommands
	- Server/Shared/Main/CmdrService/Util
	Nicholas Foreman

	Checks if a player is a developer

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
local GroupModule = require(Knit.SharedModules.RobloxApi.GroupModule)

---------------
-- CONSTANTS --
---------------

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- UTILITY FUNCTIONS --
-----------------------

----------------------------------
-- RETURN CMDR UTILITY FUNCTION --
----------------------------------

return function(userId: number): boolean
	if userId == game.CreatorId then
		return true
	end

	local player: Player? = Players:GetPlayerByUserId(userId)
	if not player or not player:IsDescendantOf(Players) then
		return false
	end

	local groupRank, gameGroup = GroupModule:GetGroupRankByName(Knit.SharedConfig.GameName, "Staff")
	local rankInGroup = player:GetRankInGroup(gameGroup.GroupId)

	if rankInGroup <= 0 then
		return false
	end

	return rankInGroup >= groupRank.Value
end