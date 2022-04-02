--[[

	PlaceIdToPlaceType
	- Shared/Modules
	Nicholas Foreman

	Used by Knit loaders to know what folders to .

	Credit to Cody Nelson (Schematics) for the idea/solution
	https://www.roblox.com/users/16743585/profile

--]]

-------------------
-- CREATE MODULE --
-------------------

local PlaceIdToPlaceType = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

local Places = {}

-- Game
Places["Game.PROD"] = {
	["Game"] = true,
	IsProd = true
}
Places["Game.DEV"] = {
	["Game"] = true,
	IsDev = true
}

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

-------------------
-- RETURN MODULE --
-------------------

return {
	-- Production
	[9249503006] = Places["Game.PROD"],

	-- Development
	[9249849654] = Places["Game.DEV"],
}