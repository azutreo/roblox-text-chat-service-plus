--[[

	GroupModule
	- Shared/Modules/RobloxApi
	Nicholas Foreman

	Description of Module

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage: ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

local Knit = require(ReplicatedStorage.Packages.Knit)

-------------------
-- CREATE MODULE --
-------------------

local MyGroupModule = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

export type Rank = {
	Name: string,
	Value: number
}

export type Group = {
	Name: string,
	GroupId: number,
	Ranks: {Rank}
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

MyGroupModule.Groups = {

	{

		Name = "Official Group of Roblox",
		GroupId = 3055661,

		Ranks = {

			{
				Name = "Employee",
				Value = 71
			},

			{
				Name = "Intern",
				Value = 5
			},

		}

	},

	{

		Name = "Roblox QA",
		GroupId = 3055661,

		Ranks = {

			{
				Name = "Manager",
				Value = 254
			},

			{
				Name = "Moderator",
				Value = 5
			},

			{
				Name = "Verified Tester",
				Value = 1
			},

		}

	},

	{

		Name = "Roblox DevForum Community",
		GroupId = 3055661,

		Ranks = {

			{
				Name = "Forum Staff",
				Value = 5
			},

			{
				Name = "Leader",
				Value = 4
			},

			{
				Name = "Editor",
				Value = 3
			},

			{
				Name = "Regular",
				Value = 2
			},

			{
				Name = "Member",
				Value = 1
			},

		}

	}

}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyGroupModule:GetGroupByName(groupName: string): Group
	for _, group: Group in ipairs(self.Groups) do
		if group.Name == groupName then
			return group
		end
	end

	return {
		Name = "Not Found",
		GroupId = -1,
		Ranks = {}
	}
end

function MyGroupModule:GetGroupRankByName(groupName: string, rankName: string): Rank
	local group: Group = self:GetGroupByName(groupName)

	for _, rank: Rank in ipairs(group.Ranks) do
		if rank.Name == rankName then
			return rank, group
		end
	end

	return {
		Name = "Not Found",
		Value = 256
	}, group
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-------------------
-- RETURN MODULE --
-------------------

return MyGroupModule