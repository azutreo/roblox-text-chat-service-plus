--[[

	GamePassModule
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

local MyGamePassModule: table = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

export type Pass = {
	Name: string,
	Identifier: string,
	PassId: number
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

MyGamePassModule.Passes = {

}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

function MyGamePassModule:GetPassByIdentifier(identifier: string): Pass
	for _, product: Pass in ipairs(self.Passes) do
		if product.Identifier == identifier then
			return product
		end
	end

	return {
		Name = "Not Found",
		Identifier = "Not_Found",
		PassId = 0
	}
end

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-------------------
-- RETURN MODULE --
-------------------

return MyGamePassModule