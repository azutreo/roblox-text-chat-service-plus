--[[

	Enums
	- Module
	Author: Nicholas Foreman (Azutreo - https://www.roblox.com/users/9221415/profile)

	Enumerations used throughout the script

--]]

---------------------
-- ROBLOX SERVICES --
---------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")

---------------------------
-- KNIT AND DEPENDENCIES --
---------------------------

-- local Knit = require(ReplicatedStorage.Packages.Knit)

-------------------
-- CREATE MODULE --
-------------------

local Enums = {}

------------------------
-- PRIVATE PROPERTIES --
------------------------

-----------------------
-- PUBLIC PROPERTIES --
-----------------------

Enums.GroupComparisonType = {
	IS_IN_GROUP = 0,
	IS_NOT_IN_GROUP = 1,

	EQUAL_TO = 2,
	NOT_EQUAL_TO = 3,

	LESS_THAN = 4,
	LESS_THAN_OR_EQUAL_TO = 5,

	GREATER_THAN = 6,
	GREATER_THAN_OR_EQUAL_TO = 7,
}

-----------------------
-- PRIVATE FUNCTIONS --
-----------------------

----------------------
-- PUBLIC FUNCTIONS --
----------------------

---------------------------
-- MODULE INITIALIZATION --
---------------------------

-------------------
-- RETURN MODULE --
-------------------

return Enums