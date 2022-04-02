--[[

	BadgeModule
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

local Knit: table = require(ReplicatedStorage.Packages.Knit)

-------------------
-- CREATE MODULE --
-------------------

local MyBadgeModule: table = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

export type Badge = {
	Name: string,
	Identifier: string,
	BadgeId: number
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

MyBadgeModule.Badges = {

}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyBadgeModule:GetBadgeByIdentifier(identifier: string): Badge
	for _, badge: Badge in ipairs(self.Badges) do
		if badge.Identifier == identifier then
			return badge
		end
	end

	return {
		Name = "Not Found",
		Identifier = "Not_Found",
		BadgeId = 0
	}
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-------------------
-- RETURN MODULE --
-------------------

return MyBadgeModule